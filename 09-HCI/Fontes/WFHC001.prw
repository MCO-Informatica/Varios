#INCLUDE "PROTHEUS.CH"


/*
// APCIniciar - Esta função é responsável por iniciar a criação do processo e o
//		    envio da mensagem para o destinatário.
*/
User Function WFHC001()
Local oProcess, oHtml
Local cNumPed, cDestinatario, cShape, cArqHtml, cAssunto, cUsrCorrente,cValcom,cCliente
Local cCodigoStatus, cDescricao, cValor,cCodigo,cIndice,cPedref,cAm1,cAm2,cAm3,cAm4,cAm5,cAm6
Local aCond := {}
Local nTotal := 0, nDias := 0, nHoras := 6, nMinutos := 30 
Local nEstfis:=0,nPoder3:=0,nDe3:=0
Local nContador:=0
Local nVlIcms,nVlPis,nVlCofins,nVlCom1,nVlCom5,nVlCusto,nVlLucro,nVlMargem 
Local nTotIcms,nTotPis,nTotCofins,nTotCom1,nTotCom5,nTotCusto,nTotLucro,nTotMargem,cAgente  
Local nItens
// Obtenha o número do pedido:
cNumPed := SCJ->CJ_NUM

// Monte uma descrição para o assunto:
cAssunto := "Aprovacao do Orcamento No: " + cNumPed

// Informe o caminho e o arquivo html que será usado. 
cArqHtml := "\Workflow\wfhc001P1.html"

// Obtenha o nome do usuário corrente:
cUsrCorrente := Subs(cUsuario,7,15)

// Informe a lista de destinatários, separando-os entre ";" 
dbSelectArea("WF1")
dbSetOrder(1)
IF dbSeek(xFilial("WF1") + "APORCA")
  cDestinatario := WF1->WF1_DESTAP
ELSE
  cDestinatario := "marcos.alves@hci.ind.br;jair.villar@hci.ind.br;sergio.domiciano@hci.ind.br;robson.bueno@hci.ind.br"
endif   
//cDestinatario := "robson.bueno@hci.ind.br"
// Inicialize a classe de processo:
oProcess := TWFProcess():New( "APORCA", cAssunto )

// Crie uma nova tarefa, informando o html template a ser utilizado:
oProcess:NewTask( "Aprovação do pedido", cArqHtml )

// Informe o nome do shape correspondente a este ponto do fluxo:
cShape := "INICIO"

// Informe o código do status do processo correspondente a este ponto do fluxo.
cCodigoStatus := "100100"
cDescricao := "Iniciando processo..."

// Repasse as informações para o método track() que registrará as informações
// para a rastreabilidade e visio.
oProcess:Track( cCodigoStatus, cDescricao, cUsrCorrente, cShape )

// Informe a função que deverá ser executada quando as respostas chegarem
// ao Workflow.
oProcess:bReturn := "U_APCRetorno"
oProcess:cSubject := cAssunto

// Determine o tempo necessário para executar o timeout. 5 minutos será
// suficiente para respondermos o pedido. Caso contrário, será executado.
oProcess:bTimeOut := {{"U_APCTimeout(1)", nDias, nHoras, nMinutos }}

// Informe qual usuário do Protheus será responsável por esta tarefa.
// Dessa forma, ele poderá ver a pendência na consulta por usuário.
oProcess:UserSiga := WFCodUser( "APROVADOR" )
//oHtml := oProcess:oHTML

// Crie novas informações a serem passadas para o método Track(), baseado
// no novo passo em que o fluxo se encontra.
cShape := "INCLUSAO"
cCodigoStatus := "100200"
cDescricao := "Gerando solicitação de aprovação de Orcamento..."
oProcess:Track(cCodigoStatus, cDescricao, cUsrCorrente, cShape )

// Preencha os campos contidos no html com as informações colhidas no
// banco de dados.
oProcess:oHtml:ValByName( "Titulo", "Aprovação de Orçamento")
oProcess:oHtml:ValByName( "emissao", SCJ->CJ_EMISSAO )
oProcess:oHtml:ValByName( "cliente", SCJ->CJ_CLIENTE )    
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + SCJ->CJ_CLIENTE)
oProcess:oHtml:ValByName( "lb_nome", SA1->A1_NOME )    
oProcess:oHtml:ValByName( "lb_cond", SCJ->CJ_CONDPAG ) 
cAgente:=Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_AGINT,"A3_NOME")
cAgente:=cAgente+" / "+Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_VEND,"A3_NOME")
oProcess:oHtml:ValByName( "lb_agente", cAgente ) 
// Obtenha as condições de pagamento.
dbSelectArea("SE4")

If dbSeek(xFilial("SE4"))
While !Eof() .and. xFilial("SE4") == SE4->E4_FILIAL 
 	AAdd(aCond, "'" + SE4->E4_DESCRI + "'" )
	dbSkip()
end
end

dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SCJ")
oProcess:oHtml:ValByName( "PEDIDO", SCJ->CJ_NUM )
cNum := SCJ->CJ_NUM
dbSelectArea("SCK")
dbSetOrder(1)
dbSeek(xFilial("SCK") + cNum )

oProcess:oHtml:ValByName("ad_validade",SCJ->CJ_VALIDA )
oProcess:oHtml:ValByName("ad_contato" ,SCJ->CJ_NMCONTA )
IF SCJ->CJ_TPFRETE="C" 
  oProcess:oHtml:ValByName("ad_entrega" ,"CIF - Cliente" )
else 
  oProcess:oHtml:ValByName("ad_entrega" ,"FOB - Regiao Metropolitana" )
endif
oProcess:oHtml:ValByName("ad_estado" ,SCJ->CJ_MUNENT+"-"+SCJ->CJ_ESTENT )
oProcess:oHtml:ValByName("ad_refcli" ,SCJ->CJ_COTCLI )

// zerando variaveis 
nVlCusto:=0
nVlIcms:=0
nVLPis:=0
nVlCofins:=0
nVlcom1:=0
nVlcom5:=0
nVlLucro:=0
nVlMargem:=0
nVlmc:=0
nTotCusto:=0
nTotIcms:=0
nTotPis:=0
nTotCofins:=0
nTotCom1:=0
nTotCom5:=0
nTotLucro:=0
nTotMargem:=0
nItens:=0



// Preencha a tabela do html chamada "produto." com seus respectivos campos.
While !Eof() .and. ( CK_NUM == cNum ) .and. nItens<=260
SB1->( dbSeek( xFilial("SB1") + SCK->CK_PRODUTO ) )
nItens:=nItens+1
nVlCusto:=0
nVlIcms:=0
nVLPis:=0
nVlCofins:=0
nVlcom1:=0
nVlcom5:=0
nVlMc:=0
nVlLucro:=0
nVlMargem:=0
nTotal := nTotal + CK_VALOR
// gravacao no acond as informacoes da situacao do item para avaliacao
acond:={}


// ADICIONANDO SALDO ATUAL DO ESTOQUE
nEstfis:=0
//carregando saldo real do produto
nPoder3:=0
nDe3:=0 
cCodigo:=SCK->CK_PRODUTO
DbSelectArea("SB2")
dbSetOrder(1)
MsSeek(xfilial("SB2")+cCodigo)
While ( !Eof() .And. SB2->B2_COD == cCodigo )
    nEstfis:=nEstfis+SB2->B2_QATU+SB2->B2_QNPT
	dbSkip()
EndDo
cQuerySC6 := "SELECT SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO,SC6.C6_TES,SC6.C6_QTDVEN,SC6.C6_QTDENT,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_LOCAL," 
cQuerySC6 += "SC6.C6_PRCVEN,SC6.C6_ENTREG,SC6.C6_NOTA,SC6.C6_DATFAT FROM " + RetSqlName("SC6")+ " SC6 " 
cQuerySC6 += "WHERE "
cQuerySC6 += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
cQuerySC6 += "SC6.C6_PRODUTO = '"+cCodigo+"' AND "
cQuerySC6 += "SC6.D_E_L_E_T_=' ' ORDER BY SC6.C6_ENTREG DESC"
//cQuery := ChangeQuery(cQuery)
If ( Select ("QSC6") <> 0 )
			dbSelectArea ("QSC6")
			dbCloseArea ()
Endif
dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySC6),"QSC6",.T.,.T.)
dbSelectArea("QSC6")
While ( !Eof() .And. QSC6->C6_PRODUTO == cCodigo )
  // precisa verificar empenhO pela tes
  if Posicione("SF4",1,xFilial("SF4")+QSC6->C6_TES,"F4_DUPLIC")="S" .OR. SUBSTR(QSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QSC6->C6_NUM,1,1)="D" .OR. SUBSTR(QSC6->C6_NUM,1,1)="T" .OR. SUBSTR(QSC6->C6_NUM,1,1)="R" .OR. SUBSTR(QSC6->C6_NUM,1,1)="A" .OR. QSC6->C6_TES="514" .OR. QSC6->C6_TES="999" .OR. QSC6->C6_TES="693" .OR. QSC6->C6_TES="553" .OR. QSC6->C6_TES="592"
    nEstfis:=nEstfis-(QSC6->C6_QTDVEN-QSC6->C6_QTDENT)
    IF SUBSTR(QSC6->C6_NUM,1,1)="B" 
      cIndice:="OS"
      cPedRef:="0"+SUBSTR(QSC6->C6_NUM,2,5)
    ELSE  
      cIndice:="PV"
      cPedRef:=QSC6->C6_NUM
    ENDIF  
    IF QSC6->C6_QTDVEN-QSC6->C6_QTDENT>0
     if Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_OC")<>"      " 
       cAm1:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_OC") 
       cAm2:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_ITEM")
       cAm3:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_FORN")
       cAm4:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_TIPO2") 
       cAm5:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_STATUS") 
       cAm6:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_QTS") 
       IF cAm5<>"4" .AND. cAm4="OS"
         IF cAm6>0 .AND. cAm6>QSC6->C6_QTDVEN-QSC6->C6_QTDENT 
           nEstfis:=nEstfis+QSC6->C6_QTDVEN-QSC6->C6_QTDENT
         else
           nEstfis:=nEstfis+cAm6
         endif
       endif
     endif
    else
    ENDIF
  ENDIF
  dbSkip()
EndDo
dbSelectArea("QSC6")
QSC6->(DbCloseArea())
// deduzindo posse de terceiros nao disponivel
DBSELECTAREA("SB6")
DBSETORDER(1)                                                                                                          
If SB6->(DbSeek(xFilial("SB6")+cCodigo))
	While xFilial("SB6") == SB6->B6_FILIAL .and. SB6->B6_PRODUTO == cCodigo  
		If SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="E" 
	      // ACERTANDO A SITUACAO DE DEPOSITO FECHADO CARMAR (NAO SUBTRAI ESTOQUE)
		  IF (SB6->B6_CLIFOR='000090' .OR. SB6->B6_CLIFOR='000669') .AND. SB6->B6_tpcf='C'
		    
		  ELSE
		    // DEMAIS SITUACOES DA ANALISE 
		    // SITUACOES EM QUE MANDO PARA BENEFICIAR FORA (SUBTRAI ESTOQUE)
		    IF SB6->B6_tpcf='F' .AND. SB6->B6_PODER3='R'
		        nEstfis:=nEstfis-SB6->B6_SALDO
		    ENDIF
		    // SITUACOES EM QUE EXISTE REMESSA EM CONSIGNACAO INDUSTRIAL (SUBTRAI ESTOQUE)
		    IF SB6->B6_tpcf='C' .AND. SB6->B6_PODER3='R'
		      nEstfis:=nEstfis-SB6->B6_SALDO
		    ENDIF
		  ENDIF
		ENDIF
		IF SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="D" .AND. SB6->B6_tpcf='C'
		  nEstfis:=nEstfis-SB6->B6_SALDO
		ELSE
		ENDIF  
		SB6->(DbSkip())
	EndDo 
ENDIF
SB6->(DbCloseArea())

/// finalmente o estoque
/// ADICIONANDO 5 ULTIMAS ENTRADAS EFETUADAS
cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_TOTAL," 
cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.D1_EMISSAO DESC"
//cQuery := ChangeQuery(cQuery)
If ( Select ("SD1") <> 0 )
			dbSelectArea ("SD1")
			dbCloseArea ()
Endif
dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
dbSelectArea("SD1")
nContador:=0
While ( !Eof() .And. SD1->D1_COD == cCodigo )
    IF SD1->D1_TES $ "101/102/156/108"
       cCliente:=Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_NREDUZ")
       cCliente:="Fn:" + RTRIM(cCliente)
       aAdd( aCond, cCliente + "-QTD:" + transform(SD1->D1_QUANT,"@e 99999") + "-R$" + transform((SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT,"@e 999,999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))
       nContador++
       if nContador>=6 
         exit
       endif  
    ENDIF
    IF SD1->D1_TES $ "301/305"
       cCliente:=Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_NREDUZ")
       cCliente:="Fn:" + RTRIM(cCliente)
       aAdd( aCond, cCliente + "-QTD:" + transform(SD1->D1_QUANT,"@e 99999") + "-R$" + transform(SD1->D1_TOTAL/SD1->D1_QUANT,"@e 999,999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) )
       nContador++
       if nContador>=6 
         exit
       endif
    ENDIF
    dbSkip()
EndDo
SD1->(DbCloseArea())
// carregando dados do item no html
// adicionando o valor de venda padrao do sistema
AAdd(aCond, "Vl.Vda.Sis:" + Transform( SB1->B1_VDANOR,'@E 999,999.99' ) + "")
AAdd(aCond, "Vl.Vda.Min:" + Transform( SB1->B1_VDAMIN,'@E 999,999.99' ) + "")
AAdd(aCond, "Tabela    :" + SB1->B1_tabela + "")
dbSelectArea("PAA")
dbSetOrder(1)
If MsSeek(xFilial("PAA")+cCodigo)
  cValor :=Transform( PAA->PAA_UNIT,'@E 999,999,999.99' )
  AAdd( ( oProcess:oHtml:ValByName( "produto.custo" )), cValor)
  nVlCusto:=PAA->PAA_UNIT*SCK->CK_QTDVEN
  nTotCusto:=nTotCusto+ nVlCusto
ELSE 
  cValor :=Transform( 0,'@E 999,999,999.99' )
  AAdd( ( oProcess:oHtml:ValByName( "produto.custo" )), cValor)
  nVlCusto :=0
  nTotCusto:=nTotCusto+ nVlCusto 
ENDIF     
dbSelectArea("SF4")
dbSetOrder(1)
If MsSeek(xFilial("SF4")+SCK->CK_TES)
  // trata icms
  IF SF4->F4_ICM="S" 
    If SCJ->CJ_ESTENT="SP"
      nVlIcms:=SCK->CK_VALOR*0.18
      nTotIcms:=nTotIcms+nVlIcms
    ENDIF
    If SCJ->CJ_ESTENT $ "MG/RJ/SC/PR/RS"
      nVlIcms:=SCK->CK_VALOR*0.12
      nTotIcms:=nTotIcms+nVlIcms
    ENDIF  
    If SCJ->CJ_ESTENT $ "AC/AL/AM/AP/BA/CE/DF/ES/GO/MA/MS/MT/PA/PB/PE/PI/SE/RN/RO/RR/TO"
      nVlIcms:=SCK->CK_VALOR*0.07
      nTotIcms:=nTotIcms+nVlIcms
    endif
  endif  
  // trata pis cofins
  IF SF4->F4_PISCOF="3" 
      nVlPis:=SCK->CK_VALOR*0.0165
      nVlCofins:=SCK->CK_VALOR*0.076 
      nTotPis:=nTotPis+nVlPis
      nTotCofins:=nTotCofins+nVlCofins
  endif
endif    
if SCJ->CJ_VEND $ "000001/000020" 
else
  nVlcom1:=(SCK->CK_VALOR-(nVlIcms+nVlPis+nVlCofins))*sck->ck_COMIS1/100
  nTotCom1:=nTotCom1+nVlcom1 
ENDIF
IF SCJ->CJ_VEND5 <> "      " 
  nVlcom5:=(SCK->CK_VALOR-(nVlIcms+nVlPis+nVlCofins))*SCK->CK_COMIS1/100
  nTotCom5:=nTotCom5+nVlcom5 
endif   
nVlMargem:=(SCK->CK_VALOR-(nVlIcms+nVlPis+nVlCofins))-(nVlCusto+nVlCom1+nVlCom5)
nTotMargem:=nTotMargem+nVlMargem
nVlmc:=nVlMargem/(nVlCusto+nVlCom1+nVlCom5)*100                                                                                                                                                                                                
dbSelectArea("SCK")
AAdd( ( oProcess:oHtml:ValByName( "produto.item" )),CK_ITEM )		
AAdd( ( oProcess:oHtml:ValByName("produto.estoque" )),Transform( nEstfis,'@E 99999' ))
AAdd( ( oProcess:oHtml:ValByName( "produto.codigo" )),CK_PRODUTO )		       
AAdd( ( oProcess:oHtml:ValByName( "produto.descricao" )),SB1->B1_DESC )
cValor := Transform( CK_QTDVEN,'@E 999,999.99' )
AAdd( ( oProcess:oHtml:ValByName( "produto.quant" )), cValor)
cValor := Transform( CK_PRCVEN,'@E 999,999.99' )
AAdd( ( oProcess:oHtml:ValByName( "produto.preco" )), cValor)
cValor := Transform( CK_VALOR,'@E 999,999,999.99' )
AAdd( ( oProcess:oHtml:ValByName( "produto.total" )), cValor) 
AAdd( ( oProcess:oHtml:ValByName( "produto.unid" )),SB1->B1_UM )
cValor := Transform( CK_XDIAS,'@E 99999' ) 
AAdd( ( oProcess:oHtml:ValByName( "produto.entrega" )),cValor ) 
AAdd( ( oProcess:oHtml:ValByName( "produto.condPag" )),aCond )
//<td><font size="2" face="Arial" class="cabecalho">%produto.icms%</font></td>
   // cValor := Transform( nVlIcms,'@E 999999.99' ) 
   // AAdd( ( oProcess:oHtml:ValByName( "produto.icms" )),cValor )
//<td><font size="2" face="Arial" class="cabecalho">%produto.pis%</font></td>
   // cValor := Transform( nVlPis,'@E 99999.99' ) 
   // AAdd( ( oProcess:oHtml:ValByName( "produto.pis" )),cValor )
//<td><font size="2" face="Arial" class="cabecalho">%produto.cofins%</font></td>
   // cValor := Transform( nVlCofins,'@E 99999.99' ) 
   // AAdd( ( oProcess:oHtml:ValByName( "produto.cofins" )),cValor )
//<td><font size="2" face="Arial" class="cabecalho">%produto.com1%</font></td>
    IF nVlcom1=0 
      cValor := Transform( nVlcom1,'@E 999999.99' ) 
      AAdd( ( oProcess:oHtml:ValByName( "produto.com1" )),cValor )
    else
      cValor := Transform( SCK->CK_COMIS1,'@E 999999.99' ) 
      AAdd( ( oProcess:oHtml:ValByName( "produto.com1" )),cValor )   
    endif  
//<td><font size="2" face="Arial" class="cabecalho">%produto.com5%</font></td>
    IF nVlcom5=0 
      cValor := Transform( nVlcom5,'@E 999999.99' ) 
      AAdd( ( oProcess:oHtml:ValByName( "produto.com5" )),cValor )
    ELSE
      cValor := Transform( SCK->CK_COMIS5,'@E 999999.99' ) 
      AAdd( ( oProcess:oHtml:ValByName( "produto.com5" )),cValor )
    ENDIF
//<td><font size="2" face="Arial" class="cabecalho">%produto.lucro%</font></td>
    cValor := Transform( nVlMargem,'@E 999,999,999.99' ) 
    AAdd( ( oProcess:oHtml:ValByName( "produto.lucro" )),cValor )
//<td><font size="2" face="Arial" class="cabecalho">%produto.mc%</font></td>
    if nVlCusto=0 
      cValor := Transform( nVlMc,'@E 99999.9999' ) 
      AAdd( ( oProcess:oHtml:ValByName( "produto.mc" )),"NT" )
    else
      cValor := Transform( nVlMc,'@E 99999.9999' ) 
      AAdd( ( oProcess:oHtml:ValByName( "produto.mc" )),cValor )
    endif 
// Grave o novo campo criado e o ID do processo juntamente com o ID da tarefa
// para ser obtida a partir da pesquisa padrão na janela da rastreabilidade.

dbSkip()
Enddo
dbSelectArea("SCJ")
if RecLock("SCJ",.f. )
	CJ_WFID := oProcess:fProcessID + oProcess:fTaskID
	MsUnLock("SCJ")
end
oProcess:oHtml:ValByName("lbValor"	, Transform( nTotal,'@E 999,999,999.99' ) )		              
oProcess:oHtml:ValByName("lbFrete"	, Transform( 0,'@E 999,999,999.99' ) )		                 
oProcess:oHtml:ValByName("lbTotal"	, Transform( nTotal*1.05,'@E 999,999,999.99' ) )
oProcess:oHtml:ValByName("lbcusto"	, Transform( nTotCusto,'@E 999,999,999.99' ) )
oProcess:oHtml:ValByName("lbvdliq"	, Transform( nTotal-(ntotIcms+ntotPis+ntotCofins),'@E 999,999,999.99' ) )
oProcess:oHtml:ValByName("lblucro"	, Transform( nTotMargem,'@E 999,999,999.99' ) )
oProcess:oHtml:ValByName("lbmc"  	, Transform( nTotMargem/(nTotCusto+nTotCom1+nTotCom5)*100,'@E 999,999,999.99' ) )
oProcess:cTo := cDestinatario


// Finalize a primeira etapa do fluxo do processo, informando em que ponto o
// fluxo do processo foi executado e, posteriormente, repasse para o método track().
cShape := "ENVIAR;APROVADOR_A"
cCodigoStatus := "100300"
cDescricao := "Enviando solicitacao para: " + cDestinatario
oProcess:Track( cCodigoStatus, cDescricao, cUsrCorrente, cShape )

// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
// de destinatários.
oProcess:Start() 

Return 












                      
/*
// APCRetorno - Esta função é responsável por atualizar o pedido de compras
//		      com as respostas vindas do aprovador.
*/
User Function APCRetorno(oProcess)
  Local cFindKey, cAssunto, cNumPed, cShape, cCodigoStatus, cDescricao
  Local nPis,nCofins,nIcms,nCom1,nCom5,nCo1,Nco5
  lOCAL cCusto,cMc, cComi1,cComi5,cComa1,cComa5


  // Obtenha o número do pedido:
  cNumPed := oProcess:oHtml:RetByName("Pedido")

  // Monte a lista de argumentos para ser passada para o método track():
  // Pode ser informado mais do que um nome de shape para uma mesma
  // ação do fluxo. Basta informá-los utilizando o ";" para identificar cada um deles.
  cAssunto := "Orcamento no: " + cNumPed
  cShape := "RECEBE;REMETENTE;APROVADO?"
  cCodigoStatus := "100400"
  cDescricao := "Recebendo resultado aprovação..."
  oProcess:Track( cCodigoStatus, cDescricao,,cShape  )
  
  nIcms:=0
  nPis:=0
  nCofins:=0
  dbSelectArea("SCJ")  
  dbSetOrder(1)
  cFindKey := xFilial("SCJ") + cNumPed
  If dbSeek( cFindKey )
    dbSelectArea("SF4")
    dbSetOrder(1)
    If MsSeek(xFilial("SF4")+SCK->CK_TES)
      // trata icms
      IF SF4->F4_ICM="S" 
        If SCJ->CJ_ESTENT="SP"
           nIcms:=18
        ENDIF
        If SCJ->CJ_ESTENT $ "MG/RJ/SC/PR/RS"
           nIcms:=12
        ENDIF  
        If SCJ->CJ_ESTENT $ "AC/AL/AM/AP/BA/CE/DF/ES/GO/MA/MS/MT/PA/PB/PE/PI/SE/RN/RO/RR/TO"
           nIcms:=7
        endif
        if SCJ->CJ_ESTENT=="  "
           nIcms:=0
        endif   
      endif  
       // trata pis cofins
      IF SF4->F4_PISCOF="3" 
         nPis:=1.65
         nCofins:=7.6 
      endif
    endif    
    dbSelectArea("SCJ")  
    for nind := 1 to len(oProcess:oHtml:RetByName("produto.item"))
         cCusto:=""
         cMc:=""
         cComi1:=""
         cComi5:=""
         nCom1:=0
         nCom5:=0
         cItem   := oProcess:oHtml:RetByName("produto.item")[nind]
         dbSelectArea("SCK")  
         dbSetOrder(1)
         cFindKey := xFilial("SCK") + cNumPed+cItem
         If dbSeek( cFindKey )
           for x:=1 to Len(oProcess:oHtml:RetByName("produto.custo")[nind])
             if substring(oProcess:oHtml:RetByName("produto.custo")[nind],x,1) $ "./R/P"
             else
               if substring(oProcess:oHtml:RetByName("produto.custo")[nind],x,1)=","
                 cCusto:=cCusto+"."
               else
                 cCusto:=cCusto+substring(oProcess:oHtml:RetByName("produto.custo")[nind],x,1)
               endif
             endif
           next
           for x:=1 to Len(oProcess:oHtml:RetByName("produto.mc")[nind])
             if substring(oProcess:oHtml:RetByName("produto.mc")[nind],x,1) $ "./N/T"
             else
               if substring(oProcess:oHtml:RetByName("produto.mc")[nind],x,1)=","
                 cMc:=cMc+"."
               else
                 cMc:=cMc+substring(oProcess:oHtml:RetByName("produto.mc")[nind],x,1)
               endif
             endif
           next
           for x:=1 to Len(oProcess:oHtml:RetByName("produto.com1")[nind])
             if substring(oProcess:oHtml:RetByName("produto.com1")[nind],x,1)="."
             else
               if substring(oProcess:oHtml:RetByName("produto.com1")[nind],x,1)=","
                 cComi1:=cComi1+"."
               else
                 cComi1:=cComi1+substring(oProcess:oHtml:RetByName("produto.com1")[nind],x,1)
               endif
             endif
           next
           for x:=1 to Len(oProcess:oHtml:RetByName("produto.com5")[nind])
             if substring(oProcess:oHtml:RetByName("produto.com5")[nind],x,1)="."
             else
               if substring(oProcess:oHtml:RetByName("produto.com5")[nind],x,1)=","
                 cComi5:=cComi5+"."
               else
                 cComi5:=cComi5+substring(oProcess:oHtml:RetByName("produto.com5")[nind],x,1)
               endif
             endif
           next
           IF VAL(cComi1)>0
             nCom1:=val(cComi1)
           endif
           if val(cComi5)>0 
             nCom5:=val(cComi5)
           endif
           RecLock("SCK",.F.)
           // (cCusto      /(1-((cComis1/100)      *(1+ (cMc1     /100))))*(1+(cMc1      /100)))/(1-((cPis1+cCof1+00)     /100))
           //'=              (A3         / (1-((G3+H3             )*(1+K3             )))* (1+K3             ))/(1-(C3+D3+E3                 ))
           IF LEN(TRIM(cMc))>0
             SCK->CK_PRCVEN:= (val(cCusto)/(1-(((SCK->CK_COMIS1+SCK->CK_COMIS5)/100)*(1+(val(cMc)/100))))*(1+(val(cMc)/100)))/(1-((nPis+nCofins+nIcms)/100))
           endif
           SCK->CK_COMIS1:=nCom1
           SCK->CK_COMIS5:=nCom5
           SCK->CK_VALOR:=  SCK->CK_PRCVEN*SCK->CK_QTDVEN
           MSUNLOCK()
           // cDescricao:=cDescricao+" - " + cMc + " - " + cCusto + "-" + Transform( nCom1,'@E 99.99' ) + "-"+ Transform( nCom5,'@E 99.99' ) +"-"+Transform( SCK->CK_PRCVEN,'@E 999999999.99' ) +"-"+ Transform( nPis+nCofins+nIcms,'@E 999999999.99' )
           // ATUALIZA TABELA DE CUSTO
           IF VAL(cCusto)>0 
             dbSelectArea("PAA")
             dbSetOrder(1)
             If MsSeek(xFilial("PAA")+SCK->CK_PRODUTO)
               RecLock("PAA",.F.)
               PAA->PAA_SALDO	:= 1
     	       PAA->PAA_UNIT	:=VAL(cCusto)
     	       PAA->PAA_TOTAL	:=VAL(cCusto)
     	       PAA->PAA_DATA	:=DATE()
     	       MsUnLock() 	         
             ELSE
               RecLock("PAA",.t.)
               PAA->PAA_FILIAL	:=xFilial("PAA")
   	           PAA->PAA_COD		:=SCK->CK_PRODUTO
   	           PAA->PAA_DESCRI  :=Posicione("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_DESC") 
     	       PAA->PAA_SALDO	:= 1
     	       PAA->PAA_UNIT	:=VAL(cCusto)
     	       PAA->PAA_TOTAL	:=VAL(cCusto)
     	       PAA->PAA_DATA	:=DATE()
     	       MsUnLock() 	         
             ENDIF
           endif 
         ENDIF  
    NEXT 
  End  
  // Verifique se a resposta é diferente de "SIM", ou seja, reprovado.
  if Upper(oProcess:oHtml:RetByName("RBAPROVA")) <> "SIM"

    // Gere novas informações a serem passadas para a rastreabilidade:
    cCodigoStatus := "100600"
    cDescricao := cAssunto + " - REPROVADO"
    // Dessa vez, não informe nenhum shape associado à reprovação por não
    // haver nenhum shape relacionado à reprovação.
    oProcess:Track( cCodigoStatus, cDescricao )

    // Execute a função responsável pela notificação ao usuário solicitante.
    U_APCNotificar( oProcess, cDescricao )
    return .t.             
  else
    // Libere o pedido:
    dbSelectArea("SCJ")  
    dbSetOrder(1)
    cFindKey := xFilial("SCJ") + cNumPed
    If dbSeek( cFindKey )
      RecLock("SCJ",.f.)
      SCJ->CJ_STATUS := "A"
      SCJ->CJ_STSBLQ := "1"
      MsUnLock()
    End  
    cShape := "APROVA"
    cCodigoStatus := "100500"
    cDescricao := cAssunto + " - APROVADO"
    oProcess:Track( cCodigoStatus, cDescricao,,cShape )
    // Execute a função responsável pela notificação ao usuário solicitante.
    U_APCNotificar( oProcess, cDescricao)
    Return .T.
  endif





















/*
// APCNotificar - Essa função é responsável por notificar ao solicitante o
//		        resultado da aprovação do pedido.
*/
User Function APCNotificar( oProcess, cDescricao )
Local oHtml
Local aValues := Array(22)
Local cNumPed, cShape, cCodigoStatus, cArqHtml,cMotivo,cResultado

// Obtenha o número do pedido:
cNumPed := oProcess:oHtml:RetByName("Pedido")

// Informe o 2º html para notificação que é diferente do wfw120p1.htm
cArqHtml := "\Workflow\wfhc001p2.html"

// Gere informações para a rastreabilidade:
cShape := "NOTIFICACAO;SOLICITANTE"	
cCodigoStatus := "100700"
oProcess:Track( cCodigoStatus, cDescricao,, cShape )

// Devido os htmls serem diferentes, não será possível usar o terceiro parâmetro
// com o valor .T. no método NewTask() da classe TWFProcess(). Neste caso,
// deve-se obter todas as informações necessárias para montar o novo html
// para notificação ao solicitante.
//oHtml := oProcess:oHtml

aValues[01] := oProcess:oHtml:ValByName("EMISSAO")
aValues[02] := oProcess:oHtml:ValByName("CLIENTE")
aValues[03] := oProcess:oHtml:ValByName("lb_nome")
aValues[04] := oProcess:oHtml:ValByName("lb_cond")
aValues[05] := oProcess:oHtml:ValByName("PEDIDO")
aValues[06] := oProcess:oHtml:ValByName("Produto.item")
aValues[07] := oProcess:oHtml:ValByName("Produto.codigo")
aValues[08] := oProcess:oHtml:ValByName("Produto.descricao")
aValues[09] := oProcess:oHtml:ValByName("Produto.quant")
aValues[10] := oProcess:oHtml:ValByName("Produto.preco")
aValues[11] := oProcess:oHtml:ValByName("Produto.total")
aValues[12] := oProcess:oHtml:ValByName("Produto.unid")
aValues[13] := oProcess:oHtml:ValByName("Produto.entrega")
aValues[14] := oProcess:oHtml:ValByName("Produto.condPag")
aValues[15] := oProcess:oHtml:ValByName("lbValor")
aValues[16] := oProcess:oHtml:ValByName("lbFrete")
aValues[17] := oProcess:oHtml:ValByName("lbTotal") 
aValues[18] := oProcess:oHtml:ValByName("ad_contato")
aValues[19] := oProcess:oHtml:ValByName("ad_validade")
aValues[20] := oProcess:oHtml:ValByName("ad_entrega")
aValues[21] := oProcess:oHtml:ValByName("ad_estado")
aValues[22] := oProcess:oHtml:ValByName("ad_refcli")
cMotivo:= oProcess:oHtml:RetByName("lbMotivo")
// Após obter as informações desejadas, crie uma nova tarefa:
oProcess:NewTask("Resultado da Aprovação", cArqHtml )
//oHtml := oProcess:oHtml

// Repasse as informações do outro html para esse novo.
oProcess:oHtml:ValByName("EMISSAO", aValues[01] )
oProcess:oHtml:ValByName("CLIENTE", aValues[02] )
oProcess:oHtml:ValByName("lb_nome", aValues[03] )
oProcess:oHtml:ValByName("lb_cond", aValues[04] )
oProcess:oHtml:ValByName("PEDIDO", aValues[05] )
AEval( aValues[06],{ |x| AAdd( oProcess:oHtml:ValByName( "produto.item" ), x ) } )
AEval( aValues[07],{ |x| AAdd( oProcess:oHtml:ValByName( "produto.codigo" ), x ) } )
AEval( aValues[08],{ |x| AAdd( oProcess:oHtml:ValByName( "produto.descricao" ), x ) } )
AEval( aValues[09],{ |x| AAdd( oProcess:oHtml:ValByName( "produto.quant" ), x ) } )
AEval( aValues[10],{ |x| AAdd( oProcess:oHtml:ValByName( "produto.preco" ), x ) } )
AEval( aValues[11],{ |x| AAdd( oProcess:oHtml:ValByName( "produto.total" ), x ) } )
AEval( aValues[12],{ |x| AAdd( oProcess:oHtml:ValByName( "produto.unid" ), x ) } )
AEval( aValues[13],{ |x| AAdd( oProcess:oHtml:ValByName( "produto.entrega" ), x ) } )
//AEval( aValues[14],{ |x| AAdd( oProcess:oHtml:ValByName( "produto.condPag" ), x ) } )
oProcess:oHtml:ValByName( "lbValor", aValues[15])
oProcess:oHtml:ValByName( "lbFrete", aValues[16])
oProcess:oHtml:ValByName( "lbTotal", aValues[17])
oProcess:oHtml:ValByName("ad_contato", aValues[18] )
oProcess:oHtml:ValByName("ad_validade", aValues[19] )
oProcess:oHtml:ValByName("ad_entrega",  aValues[20] )
oProcess:oHtml:ValByName("ad_estado", aValues[21] )
oProcess:oHtml:ValByName("ad_refcli", aValues[22] )
oProcess:oHtml:ValByName( "Titulo", cDescricao )
oProcess:oHtml:ValByName( "lbMotivo", cMotivo )
// Informe o endereço eletrônico do solicitante. Esta informação pode estar
// armazenada em um campo na tabela SC7, por exemplo:


//******************REABRINDO TABELA DE ORCAMENTO PARA TRAZER CONTATO + REPRESENTANTE
dbSelectArea("SCJ")  
dbSetOrder(1)
cFindKey := xFilial("SCJ") + cNumPed
If dbSeek( cFindKey )
//******************FALTA DEFINIR O DESTINATARIO DO E-MAIL + representante
  IF SCJ->CJ_VEND="000001" .or. SCJ->CJ_VEND="000020" 
    cEmitente:=Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_AGINT,"A3_EMAIL")
    oProcess:cSubject := "1-Ret. de Apr do Orcamento N.:"+cNumped
  ELSE
    if Len(SCJ->CJ_VEND)>0 .and.  SCJ->CJ_STATUS = "A" .and.  SCJ->CJ_STSBLQ = "1"
      cEmitente:=Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_VEND,"A3_EMAIL")+";"+Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_AGINT,"A3_EMAIL")
      oProcess:cSubject := "2-Ret. de Apr do Orcamento N.:"+cNumped   
    ELSE
      cEmitente:=Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_AGINT,"A3_EMAIL")
      oProcess:cSubject := "3-Ret. de Apr do Orcamento N.:"+cNumped
    ENDIF  
  ENDIF  
  oProcess:cTo := cEmitente
ELSE
  oProcess:cTo := "robson.bueno@hci.ind.br"
  oProcess:cSubject := "Ret. de Aprovacao do Orcamento N.:"+cNumped+" --> Sem Destino Identificado"
ENDIF

// Envie a mensagem para o solicitante:
oProcess:Start()

// Como não houve informações geradas para essa tarefa nos campos bReturn
// e bTimeout, esse processo será finalizado automaticamente. De qualquer
// forma, informe, na rastreabilidades sobre esse passo alcançado no fluxo.
cShape := "TERMINO"
cCodigoStatus := "101000"
cDescricao := "Termino do processo"
oProcess:Track( cCodigoStatus, cDescricao,, cShape )
Return



















/*
// APCTimeout - Esta função é responsável pela execução do timeout
//		      do processo.
*/
User Function APCTimeOut( nVezes, oProcess )
Local nDias := 0, nHoras := 6, nMinutos := 30
Local cNumPed, cShape, cCodigoStatus, cDescricao, cArqHtml

// Informe o html:
cArqHtml := "\Workflow\wfhc001p1.html"

// Obtenha o número do pedido:
// Veja que o método Valbyname() deve ser usado na função de timeout.
cNumPed := oProcess:oHtml:ValByName("Pedido")


// Verifique o número de vezes que o timeout foi executado para este processo.
If ( nVezes == 1 ) 

     // Se for a primeira vez, finalize a tarefa anterior.
oProcess:Finish()

     // Crie uma nova tarefa de reenvio, aproveitando as mesmas informações do
     // html preenchido anteriormente através do terceiro parâmetro do método
     // NewTask(), usando o valor .T. (verdadeiro).
     oProcess:NewTask("Reenvio de aprovação", cArqHtml, .t. )

     // Determine uma nova informação a ser gravada na rastreabilidade.
cShape := "TIMEOUT"
cCodigoStatus := "100800"
cDescricao := "Executando timeout"
oProcess:Track( cCodigoStatus, cDescricao,, cShape )
//oProcess:cTo := "marcos.alves@hci.ind.br;jair.villar@hci.ind.br"
oProcess:cTo := "robson.bueno@hci.ind.br"
oProcess:bReturn := "U_APCRetorno"

     // Desta vez, informe ao timeout que ser for executado, será pela segunda vez.
oProcess:bTimeOut := {{"U_APCTimeout(2)", nDias, nHoras, nMinutos }}

     // Incremente o assunto da mensagem para ficar ressaltado que se trata
     // de um reenvio indicando o timeout.
oProcess:cSubject := "(Timeout)" + oProcess:cSubject

     // Prepare novas informações a serem inseridas na rastreabilidade.
cShape := "REENVIO;APROVADOR_B"
cCodigoStatus := "100900"
cDescricao := "Reenviando aprovacao do Orcamento no. " + cNumPed
oProcess:Track( cCodigoStatus, cDescricao,, cShape )

     // Gere o processo e envie a mensagem.
oProcess:Start()
else
     // Envie uma notificação ao usuário, indicando que o processo foi descartado.
cDescricao := "Orcamento no. " + cNumPed + " não foi atendido."
U_APCNotificar(oProcess, cDescricao )
end

Return 
