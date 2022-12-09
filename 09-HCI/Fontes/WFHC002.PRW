#INCLUDE "PROTHEUS.CH"
/*
// APCIniciar - Esta função é responsável por iniciar a criação do processo e o
//		    envio da mensagem para o destinatário.
*/
User Function WFHC002()
Local oProcess, oHtml
Local cNumPed, cDestinatario, cShape, cArqHtml, cAssunto, cUsrCorrente,cValcom,cCliente
Local cCodigoStatus, cDescricao, cValor,cCodigo,cIndice,cPedref,cAm1,cAm2,cAm3,cAm4,cAm5,cAm6
Local aObsCpa := {}
Local nTotal := 0, nDias := 1, nHoras := 18, nMinutos := 45 
Local nEstfis:=0,nPoder3:=0,nDe3:=0


// Obtenha o número do pedido:
cNumPed := SC5->C5_NUM

// Monte uma descrição para o assunto:
cAssunto := "Solicitacao de compra ref. Venda No: " + cNumPed

// Informe o caminho e o arquivo html que será usado. 
cArqHtml := "\Workflow\wfhc002p1.html"

// Obtenha o nome do usuário corrente:
cUsrCorrente := Subs(cUsuario,7,15)

// Informe a lista de destinatários, separando-os entre ";" 
//cDestinatario := "marcos.alves@hci.ind.br;jair.villar@hci.ind.br"
dbSelectArea("WF1")
dbSetOrder(1)
IF dbSeek(xFilial("WF1") + "SOLCPA")
  cDestinatario := WF1->WF1_DESTAP
ELSE
  cDestinatario := "thamires.lopes@hci.ind.br"
endif   
// Inicialize a classe de processo:
oProcess := TWFProcess():New( "SOLCPA", cAssunto )

// Crie uma nova tarefa, informando o html template a ser utilizado:
oProcess:NewTask( "Solicitacao para Compra", cArqHtml )

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
oProcess:bReturn := "U_APCRET002"
oProcess:cSubject := cAssunto

// Determine o tempo necessário para executar o timeout. 5 minutos será
// suficiente para respondermos o pedido. Caso contrário, será executado.
oProcess:bTimeOut := {{"U_APCTIME002(1)", nDias, nHoras, nMinutos }}

// Informe qual usuário do Protheus será responsável por esta tarefa.
// Dessa forma, ele poderá ver a pendência na consulta por usuário.
oProcess:UserSiga := WFCodUser( "APROVADOR" )
//oHtml := oProcess:oHTML

// Crie novas informações a serem passadas para o método Track(), baseado
// no novo passo em que o fluxo se encontra.
cShape := "INCLUSAO"
cCodigoStatus := "100200"
cDescricao := "Gerando Solicitacao de Compra ..."
oProcess:Track(cCodigoStatus, cDescricao, cUsrCorrente, cShape )

// Preencha os campos contidos no html com as informações colhidas no
// banco de dados.
oProcess:oHtml:ValByName( "c5_num", SC5->C5_NUM )
oProcess:oHtml:ValByName( "c5_cliente", SC5->C5_CLIENTE ) 
oProcess:oHtml:ValByName( "c5_xnreduz", SC5->C5_XNREDUZ ) 
oProcess:oHtml:ValByName( "c5_loja", SC5->C5_LOJACLI)
oProcess:oHtml:ValByName( "obsqual",SC5->C5_OBSANL)
DbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + SC5->C5_CLIENTE+SC5->C5_LOJACLI)
oProcess:oHtml:ValByName( "a1_nome", SA1->A1_NOME )    
oProcess:oHtml:ValByName( "a1_end", SA1->A1_END )    	
oProcess:oHtml:ValByName( "a1_mun", SA1->A1_MUN )    
oProcess:oHtml:ValByName( "a1_est", SA1->A1_EST )    
oProcess:oHtml:ValByName( "a1_cgc", SA1->A1_CGC )    
oProcess:oHtml:ValByName( "a1_inscr", SA1->A1_INSCR )    
oProcess:oHtml:ValByName( "a1_inscrm", SA1->A1_INSCRM )    
oProcess:oHtml:ValByName( "c5_condpag", SC5->C5_CONDPAG )
dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4") + SC5->C5_CONDPAG)
oProcess:oHtml:ValByName( "e4_descri", SE4->E4_DESCRI) 
dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3") + SC5->C5_VEND1)
oProcess:oHtml:ValByName( "a3_nome", SA3->A3_NOME) 

dbSelectArea("SB1")
dbSetOrder(1)                                                          
dbSelectArea("SC5")
oProcess:oHtml:ValByName( "C5_NUM", SC5->C5_NUM )
cNum := SC5->C5_NUM
// pREENCHIMENTO DAS OPCOES DA OBSERVACAO PARA TODOS OS ITENS
dbSelectArea("SZA")
dbSetOrder(1)    
aAdd( aObsCpa, " ")
While !Eof()
  aAdd( aObsCpa, SZA->ZA_DESCR)
  SZA->(dbSkip())
Enddo
oProcess:oHtml:ValByName( "c7_condpag" ,"   ")
oProcess:oHtml:ValByName( "obs1" ,aObsCpa) 
oProcess:oHtml:ValByName( "obs2" ,aObsCpa)
oProcess:oHtml:ValByName( "obs3" ,aObsCpa)
oProcess:oHtml:ValByName( "obs4" ,aObsCpa)
oProcess:oHtml:ValByName( "obs5" ,aObsCpa)
oProcess:oHtml:ValByName( "obs6" ,aObsCpa)
oProcess:oHtml:ValByName( "obs7" ,aObsCpa)
oProcess:oHtml:ValByName( "obs8" ,aObsCpa)
oProcess:oHtml:ValByName( "obs9" ,aObsCpa)
dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6") + cNum )
// Preencha a tabela do html chamada "produto." com seus respectivos campos.
While !Eof() .and. (SC6->C6_NUM == cNum )
  IF SC6->C6_QTDLOC2 >0 
    DBSELECTAREA("SB1")
    dbSetOrder(1)
    SB1->( dbSeek( xFilial("SB1") + SC6->C6_PRODUTO ) )
    nTotal := nTotal + SC6->C6_VALOR
    dbSelectArea("SC6")
    AAdd( ( oProcess:oHtml:ValByName( "it.it" )),C6_ITEM )		
    AAdd( ( oProcess:oHtml:ValByName( "it.codprod" )),C6_PRODUTO )		       
    AAdd( ( oProcess:oHtml:ValByName( "it.desc" )),SB1->B1_DESC)
    AAdd( ( oProcess:oHtml:ValByName( "it.tecnico" )),C6_DSCTEC) 
    AAdd( ( oProcess:oHtml:ValByName( "it.obs" )),C6_XOBS)
    cValor := Transform( C6_QTDVEN,'@E 99,999.99' )
    AAdd( ( oProcess:oHtml:ValByName( "it.qtd" )), cValor)
    cValor := Transform( C6_PRCVEN,'@E 999,999.99' )
    AAdd( ( oProcess:oHtml:ValByName( "it.vlruni" )), cValor)
    cValor := Transform( C6_VALOR,'@E 9,999,999.99' )
    AAdd( ( oProcess:oHtml:ValByName( "it.vlrtot" )), cValor) 
    cValor := Transform( C6_QTDLOC2,'@E 99,999.99' )
    AAdd( ( oProcess:oHtml:ValByName( "it.qtdoc" )), cValor)
    AAdd( ( oProcess:oHtml:ValByName( "it.prev" )),C6_ENTREG) 
    AAdd( ( oProcess:oHtml:ValByName( "it.fornece" )),"      ")
    AAdd( ( oProcess:oHtml:ValByName( "it.loja" )),"  ") 
    AAdd( ( oProcess:oHtml:ValByName( "it.oc" )),"      ")   
    AAdd( ( oProcess:oHtml:ValByName( "it.item" )),"    ") 
    AAdd( ( oProcess:oHtml:ValByName( "it.OcUnit" )),0.00 )
    AAdd( ( oProcess:oHtml:ValByName( "it.prazo" )),C6_ENTREG)   
  ENDIF  
  SC6->(dbSkip())
Enddo
dbSelectArea("SC5")
dbSetOrder(1) 
IF MsSeek(xfilial("SC5")+cNum)
if RecLock("SC5",.f. )
	C5_WFID := oProcess:fProcessID + oProcess:fTaskID
	MsUnLock("SC5")
end 
endif
   
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
User Function APCRET002(oProcess)
Local cFindKey, cAssunto, cNumPed, cShape, cCodigoStatus, cDescricao  
Local cUnitOc
// Obtenha o número do pedido:
cNumPed := oProcess:oHtml:RetByName("c5_num")

// Monte a lista de argumentos para ser passada para o método track():
// Pode ser informado mais do que um nome de shape para uma mesma
// ação do fluxo. Basta informá-los utilizando o ";" para identificar cada um deles.
cAssunto := "Pedido no: " + cNumPed
cShape := "RECEBE;REMETENTE;APROVADO?"
cCodigoStatus := "100400"
cDescricao := "Recebendo resultado processo..."
oProcess:Track( cCodigoStatus, cDescricao,,cShape  )

// Verifique se a resposta é diferente de "SIM", ou seja, reprovado.
if Upper(oProcess:oHtml:RetByName("RBAPROVA")) <> "SIM"

  // Gere novas informações a serem passadas para a rastreabilidade:
  cCodigoStatus := "100600"
  cDescricao := cAssunto + " - REJEITADO"

  // Dessa vez, não informe nenhum shape associado à reprovação por não
  // haver nenhum shape relacionado à reprovação.
  oProcess:Track( cCodigoStatus, cDescricao )

  // Execute a função responsável pela notificação ao usuário solicitante.
  U_APCNot002( oProcess, cDescricao )
  return .t.             
end

// INCLUINDO A OC DOS ITENS ALIMENTADOS NO WORKFLOW
for _nind := 1 to len(oProcess:oHtml:RetByName("it.it"))
           cNumPed := oProcess:oHtml:RetByName("it.oc")[_nind]
           cItem   := oProcess:oHtml:RetByName("it.item")[_nind]
           if LEN(cNumPed)>0 .AND. LEN(cItem)>0 
             dbSelectArea("SC7")  
             dbSetOrder(1)
             cFindKey := xFilial("SC7") + cNumPed+cItem
             If dbSeek( cFindKey )
             else
               cUnitOc:=""
               for x:=1 to Len(oProcess:oHtml:RetByName("it.OcUnit")[_nind])
                 if substring(oProcess:oHtml:RetByName("it.OcUnit")[_nind],x,1) $ "./R/P"
                 else
                   if substring(oProcess:oHtml:RetByName("it.OcUnit")[_nind],x,1)=","
                     cUnitOc:=cUnitOc+"."
                   else
                     cUnitOc:=cUnitOc+substring(oProcess:oHtml:RetByName("it.OcUnit")[_nind],x,1)
                   endif
                 endif
               next
               if len(cUnitOc)=0
                 cUnitOc:="0.00"
               endif   
               RecLock("SC7",.t.)
               SC7->C7_FILIAL		:= xFilial("SC7") 											// 	C2
               SC7->C7_EMISSAO		:=DATE()          											// 	D8
               SC7->C7_NUM	  		:= cNumPed         											// 	C6
               SC7->C7_ITEM  		:= cItem       												//	C4
               SC7->C7_FORNECE		:= oProcess:oHtml:RetByName("it.Fornece")[_nind]        	//	C6 
               SC7->C7_LOJA 		:= oProcess:oHtml:RetByName("it.Loja")[_nind]            	//	C4
               SC7->C7_TIPO			:= 1                                                   		//	N1
               SC7->C7_PRODUTO		:=oProcess:oHtml:RetByName("it.codprod"  )[_nind]     	// 	C15
               SC7->C7_DESCRI		:=oProcess:oHtml:RetByName("it.desc")[_nind]      		//	C52	
               SC7->C7_UM	   		:="PC"                                                    	//	C2		
               SC7->C7_QUANT		:=Val(oProcess:oHtml:RetByName("it.qtdoc")[_nind])  
               SC7->C7_PRECO      	:=Val(cUnitOc)
               SC7->C7_TOTAL      	:= SC7->C7_QUANT*SC7->C7_PRECO
              // SC7->C7_DIAS     	:=ctod(oProcess:oHtml:RetByName("it.prazo")[_nind])-DATE()
               SC7->C7_DATPRF     	:=CTOD(oProcess:oHtml:RetByName("it.prazo")[_nind]  )
               SC7->C7_QUJE       	:=0
               SC7->C7_TES       	:="101"
               SC7->C7_IPI        	:=5
               SC7->C7_PICM      	:=18
               SC7->C7_LOCAL     	:="01"
               SC7->C7_CONTA      	:="1.1.3.03"
               SC7->C7_IPIBRUT		:="B"
               SC7->C7_FLUXO		:="S"
               SC7->C7_APROV		:="000005"
               SC7->C7_USER			:="000035"
               SC7->C7_BASEICM		:=SC7->C7_TOTAL
               SC7->C7_BASEIPI		:=SC7->C7_TOTAL
               SC7->C7_VALICM		:=SC7->C7_TOTAL*18/100
               SC7->C7_VALIPI		:=SC7->C7_TOTAL*5/100
              // SC7->C7_XNREDUZ	:=Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NREDUZ") 
               SC7->C7_XPI    		:=oProcess:oHtml:RetByName("c5_num") 
               SC7->C7_XITPI 		:=oProcess:oHtml:RetByName("it.it")[_nind] 
               SC7->C7_XCLI			:=oProcess:oHtml:RetByName("c5_cliente") 
               SC7->C7_XLOJA    	:=oProcess:oHtml:RetByName("c5_loja") 
               SC7->C7_XNREDCL		:=oProcess:oHtml:RetByName("c5_xnreduz") 
               SC7->C7_XQTVD    	:=val(oProcess:oHtml:RetByName("it.qtd")[_nind] )
               SC7->C7_XPZVDA   	:=CTOD(oProcess:oHtml:RetByName("it.prazo")[_nind] )
               SC7->C7_TECNICO		:=U_MATATEC(oProcess:oHtml:RetByName("it.codprod")[_nind] )
               SC7->C7_OBEXPED		:="G.Eletronica(workflow)"
               SC7->C7_FILENT		:=XFILIAL("SC7")
               SC7->C7_COND     	:=oProcess:oHtml:RetByName("c7_condpag") 
               */
               MsUnlock()
               dbSelectArea("SC7")  
               dbSetOrder(1)
               cFindKey := xFilial("SC7") + cNumPed+cItem
               If dbSeek( cFindKey )
                 U_MT120CC(.t.)
               ENDIF
             ENDIF
           endif
next
IF len(oProcess:oHtml:RetByName("obs1"))>0  
  If !SZB->(DbSeek(xFilial("SZB")+ cNumPed+"000001"))
  	RecLock("SZB",.T.)
  Else
  	RecLock("SZB",.F.)
  EndIf
  SZB->ZB_FILIAL	:= xFilial("SZB")
  SZB->ZB_XOC		:= cNumPed  
  SZB->ZB_XCOD	    := "000001"
  SZB->ZB_XDESCR	:= oProcess:oHtml:RetByName("obs1")	// Codigo Documento
  SZB->(MsUnlock())
endif 
IF len(oProcess:oHtml:RetByName("obs2"))>0  
  If !SZB->(DbSeek(xFilial("SZB")+ cNumPed+"000002"))
  	RecLock("SZB",.T.)
  Else
  	RecLock("SZB",.F.)
  EndIf
  SZB->ZB_FILIAL	:= xFilial("SZB")
  SZB->ZB_XOC		:= cNumPed  
  SZB->ZB_XCOD	    := "000002"
  SZB->ZB_XDESCR	:= oProcess:oHtml:RetByName("obs2")	// Codigo Documento
  SZB->(MsUnlock())
endif
IF len(oProcess:oHtml:RetByName("obs3"))>0  
  If !SZB->(DbSeek(xFilial("SZB")+ cNumPed+"000003"))
  	RecLock("SZB",.T.)
  Else
  	RecLock("SZB",.F.)
  EndIf
  SZB->ZB_FILIAL	:= xFilial("SZB")
  SZB->ZB_XOC		:= cNumPed  
  SZB->ZB_XCOD	    := "000003"
  SZB->ZB_XDESCR	:= oProcess:oHtml:RetByName("obs3")	// Codigo Documento
  SZB->(MsUnlock())
endif
IF len(oProcess:oHtml:RetByName("obs4"))>0  
  If !SZB->(DbSeek(xFilial("SZB")+ cNumPed+"000004"))
  	RecLock("SZB",.T.)
  Else
  	RecLock("SZB",.F.)
  EndIf
  SZB->ZB_FILIAL	:= xFilial("SZB")
  SZB->ZB_XOC		:= cNumPed  
  SZB->ZB_XCOD	    := "000004"
  SZB->ZB_XDESCR	:= oProcess:oHtml:RetByName("obs4")	// Codigo Documento
  SZB->(MsUnlock())
endif
IF len(oProcess:oHtml:RetByName("obs5"))>0  
  If !SZB->(DbSeek(xFilial("SZB")+ cNumPed+"000005"))
  	RecLock("SZB",.T.)
  Else
  	RecLock("SZB",.F.)
  EndIf
  SZB->ZB_FILIAL	:= xFilial("SZB")
  SZB->ZB_XOC		:= cNumPed  
  SZB->ZB_XCOD	    := "000005"
  SZB->ZB_XDESCR	:= oProcess:oHtml:RetByName("obs5")	// Codigo Documento
  SZB->(MsUnlock())
endif
IF len(oProcess:oHtml:RetByName("obs6"))>0  
  If !SZB->(DbSeek(xFilial("SZB")+ cNumPed+"000006"))
  	RecLock("SZB",.T.)
  Else
  	RecLock("SZB",.F.)
  EndIf
  SZB->ZB_FILIAL	:= xFilial("SZB")
  SZB->ZB_XOC		:= cNumPed  
  SZB->ZB_XCOD	    := "000006"
  SZB->ZB_XDESCR	:= oProcess:oHtml:RetByName("obs6")	// Codigo Documento
  SZB->(MsUnlock())
endif
IF len(oProcess:oHtml:RetByName("obs7"))>0  
  If !SZB->(DbSeek(xFilial("SZB")+ cNumPed+"000007"))
  	RecLock("SZB",.T.)
  Else
  	RecLock("SZB",.F.)
  EndIf
  SZB->ZB_FILIAL	:= xFilial("SZB")
  SZB->ZB_XOC		:= cNumPed  
  SZB->ZB_XCOD	    := "000007"
  SZB->ZB_XDESCR	:= oProcess:oHtml:RetByName("obs7")	// Codigo Documento
  SZB->(MsUnlock())
endif
IF len(oProcess:oHtml:RetByName("obs8"))>0  
  If !SZB->(DbSeek(xFilial("SZB")+ cNumPed+"000008"))
  	RecLock("SZB",.T.)
  Else
  	RecLock("SZB",.F.)
  EndIf
  SZB->ZB_FILIAL	:= xFilial("SZB")
  SZB->ZB_XOC		:= cNumPed  
  SZB->ZB_XCOD	    := "000008"
  SZB->ZB_XDESCR	:= oProcess:oHtml:RetByName("obs8")	// Codigo Documento
  SZB->(MsUnlock())
endif
IF len(oProcess:oHtml:RetByName("obs9"))>0  
  If !SZB->(DbSeek(xFilial("SZB")+ cNumPed+"000009"))
  	RecLock("SZB",.T.)
  Else
  	RecLock("SZB",.F.)
  EndIf
  SZB->ZB_FILIAL	:= xFilial("SZB")
  SZB->ZB_XOC		:= cNumPed  
  SZB->ZB_XCOD	    := "000009"
  SZB->ZB_XDESCR	:= oProcess:oHtml:RetByName("obs9")	// Codigo Documento
  SZB->(MsUnlock())
endif
cShape := "APROVA"
cCodigoStatus := "100500"
cDescricao := cAssunto + " - REALIZADO"
oProcess:Track( cCodigoStatus, cDescricao,,cShape )
// Execute a função responsável pela notificação ao usuário solicitante.
U_APCNot002( oProcess, cDescricao)
Return










/*
// APCNot002 - Essa função é responsável por notificar ao solicitante o
//		        resultado da aprovação do pedido.
*/
User Function APCNot002( oProcess, cDescricao )
Local oHtml
Local aValues := Array(27)
Local cNumPed, cShape, cCodigoStatus, cArqHtml,cMotivo

// Informe o 2º html para notificação que é diferente do wfw120p1.htm
cArqHtml := "\Workflow\wfhc002p2.html"

// Gere informações para a rastreabilidade:
cShape := "NOTIFICACAO;SOLICITANTE"	
cCodigoStatus := "100700"
oProcess:Track( cCodigoStatus, cDescricao,, cShape )

// Devido os htmls serem diferentes, não será possível usar o terceiro parâmetro
// com o valor .T. no método NewTask() da classe TWFProcess(). Neste caso,
// deve-se obter todas as informações necessárias para montar o novo html
// para notificação ao solicitante.
//oHtml := oProcess:oHtml


// cabecalho
aValues[01] := oProcess:oHtml:ValByName("c5_num")
aValues[02] := oProcess:oHtml:ValByName("c5_cliente")
aValues[03] := oProcess:oHtml:ValByName("c5_xnreduz")
aValues[04] := oProcess:oHtml:ValByName("c5_loja")
aValues[05] := oProcess:oHtml:ValByName("a1_nome")
aValues[06] := oProcess:oHtml:ValByName("a1_end")
aValues[07] := oProcess:oHtml:ValByName("a1_est")
aValues[08] := oProcess:oHtml:ValByName("a1_cgc")
aValues[09] := oProcess:oHtml:ValByName("a1_inscr")
aValues[10] := oProcess:oHtml:ValByName("a1_inscrm")
aValues[11] := oProcess:oHtml:ValByName("c5_condpag")
//itens
aValues[12] := oProcess:oHtml:ValByName("it.it")
aValues[13] := oProcess:oHtml:ValByName("it.codprod")
aValues[14] := oProcess:oHtml:ValByName("it.desc")
aValues[15] := oProcess:oHtml:ValByName("it.prev")
aValues[16] := oProcess:oHtml:ValByName("it.qtd")
aValues[17] := oProcess:oHtml:ValByName("it.vlruni")
aValues[18] := oProcess:oHtml:ValByName("it.vlrtot")
// itens da oc
aValues[19] := oProcess:oHtml:ValByName("it.qtdoc")
aValues[20] := oProcess:oHtml:RetByName("it.fornece")
aValues[21] := oProcess:oHtml:RetByName("it.loja")
aValues[22] := oProcess:oHtml:RetByName("it.Oc")
aValues[23] := oProcess:oHtml:RetByName("it.OcUnit")
aValues[24] := oProcess:oHtml:RetByName("it.Prazo") 
aValues[25] := oProcess:oHtml:RetByName("it.Item")
aValues[26] := oProcess:oHtml:ValByName("it.Tecnico")
aValues[27] := oProcess:oHtml:ValByName("it.obs")
cMotivo:= oProcess:oHtml:RetByName("obs")

// Após obter as informações desejadas, crie uma nova tarefa:
oProcess:NewTask("Criando OC", cArqHtml )
//oHtml := oProcess:oHtml

// Repasse as informações do outro html para esse novo.
oProcess:oHtml:ValByName("c5_num", aValues[01] )
oProcess:oHtml:ValByName("c5_cliente", aValues[02] )
oProcess:oHtml:ValByName("c5_xnreduz", aValues[03] )
oProcess:oHtml:ValByName("c5_loja", aValues[04] )
oProcess:oHtml:ValByName("a1_nome", aValues[05] ) 
oProcess:oHtml:ValByName("a1_end", aValues[06] )
oProcess:oHtml:ValByName("a1_est", aValues[07] )
oProcess:oHtml:ValByName("a1_cgc", aValues[08] )
oProcess:oHtml:ValByName("a1_inscr", aValues[09] )
oProcess:oHtml:ValByName("a1_inscrm", aValues[10] )
oProcess:oHtml:ValByName("c5_condpag", aValues[11] )

AEval( aValues[12],{ |x| AAdd( oProcess:oHtml:ValByName( "it.it" ), x ) } )
AEval( aValues[13],{ |x| AAdd( oProcess:oHtml:ValByName( "it.codprod" ), x ) } )
AEval( aValues[14],{ |x| AAdd( oProcess:oHtml:ValByName( "it.desc" ), x ) } )
AEval( aValues[15],{ |x| AAdd( oProcess:oHtml:ValByName( "it.prev" ), x ) } )
AEval( aValues[16],{ |x| AAdd( oProcess:oHtml:ValByName( "it.qtd" ), x ) } )
AEval( aValues[17],{ |x| AAdd( oProcess:oHtml:ValByName( "it.vlruni" ), x ) } )
AEval( aValues[18],{ |x| AAdd( oProcess:oHtml:ValByName( "it.vlrtot" ), x ) } )
AEval( aValues[19],{ |x| AAdd( oProcess:oHtml:ValByName( "it.qtdoc" ), x ) } )
AEval( aValues[20],{ |x| AAdd( oProcess:oHtml:ValByName( "it.fornece" ), x ) } )
AEval( aValues[21],{ |x| AAdd( oProcess:oHtml:ValByName( "it.loja" ), x ) } )
AEval( aValues[22],{ |x| AAdd( oProcess:oHtml:ValByName( "it.oc" ), x ) } )
AEval( aValues[23],{ |x| AAdd( oProcess:oHtml:ValByName( "it.ocunit" ), x ) } )
AEval( aValues[24],{ |x| AAdd( oProcess:oHtml:ValByName( "it.prazo" ), x ) } )
AEval( aValues[25],{ |x| AAdd( oProcess:oHtml:ValByName( "it.Item" ), x ) } )
AEval( aValues[26],{ |x| AAdd( oProcess:oHtml:ValByName( "it.Tecnico" ), x ) } )
AEval( aValues[27],{ |x| AAdd( oProcess:oHtml:ValByName( "it.Obs" ), x ) } ) 
oProcess:oHtml:ValByName( "obs", cMotivo )
// Informe o endereço eletrônico do solicitante. Esta informação pode estar
// armazenada em um campo na tabela SC7, por exemplo:




//******************FALTA DEFINIR O DESTINATARIO DO E-MAIL
cEmitente:=Posicione("SA3",1,xFilial("SA3")+SC5->C5_AGINT,"A3_EMAIL")
oProcess:cTo := cEmitente
//oProcess:cTo := "robson.bueno@hci.ind.br"
oProcess:cSubject := cDescricao

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
// APCTime002 - Esta função é responsável pela execução do timeout
//		      do processo.
*/
User Function APCTIME002( nVezes, oProcess )
Local nDias := 1, nHoras := 18, nMinutos := 45
Local cNumPed, cShape, cCodigoStatus, cDescricao, cArqHtml

// Informe o html:
cArqHtml := "\Workflow\wfhc002p1.html"

// Obtenha o número do pedido:
// Veja que o método Valbyname() deve ser usado na função de timeout.
cNumPed := oProcess:oHtml:ValByName("c5_num")


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
dbSelectArea("WF1")
dbSetOrder(1)
IF dbSeek(xFilial("WF1") + "SOLCPA")
  oProcess:cTo :=WF1->WF1_DESTOU
ELSE
//oProcess:cTo := "marcos.alves@hci.ind.br;jair.villar@hci.ind.br"
  oProcess:cTo := "robson.bueno@hci.ind.br"
ENDIF
oProcess:bReturn := "U_APCRet002"

     // Desta vez, informe ao timeout que ser for executado, será pela segunda vez.
oProcess:bTimeOut := {{"U_APCTime002(2)", nDias, nHoras, nMinutos }}

     // Incremente o assunto da mensagem para ficar ressaltado que se trata
     // de um reenvio indicando o timeout.
oProcess:cSubject := "(Favor Responder)" + oProcess:cSubject

     // Prepare novas informações a serem inseridas na rastreabilidade.
cShape := "REENVIO;APROVADOR_B"
cCodigoStatus := "100900"
cDescricao := "Reenviando Pedido em Solicitação de Compra no. " + cNumPed
oProcess:Track( cCodigoStatus, cDescricao,, cShape )
oProcess:cSubject := "(Nao Foi Atendido)" + oProcess:cSubject
     // Gere o processo e envie a mensagem.
oProcess:Start()
else
     // Envie uma notificação ao usuário, indicando que o processo foi descartado.
cDescricao := "O Pedido no. " + cNumPed + " não foi atendido."
U_APCNot002(oProcess, cDescricao )
end

Return 
