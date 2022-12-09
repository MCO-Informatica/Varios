
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMA012  ºAutor  ³Robson Bueno        º Data ³  19/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³COMPRA VINCULADA                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOMA014()

Local aCores    := {}

aCores    := {{	'ZK_STATUS=="1"' , 'BR_VERDE'},;		// CASADO PENDENTE
			   {'ZK_STATUS=="2"' , 'BR_AMARELO'},;       // CASADO PARCIAMENTE ENTREGUE
			   {'ZK_STATUS=="4"' , 'BR_VERMELHO'}}     // FECHADA	

PRIVATE aRotina := { { "Pesquisar","AxPesqui"  ,0,1},;             
					 { "Visualizar","AxVisual",0,2},;        
                     { "Incluir","U_RCOM14I",0,3},;
                     { "Alterar","U_RCOM14A",0,4},;
                     { "Excluir","u_RCOM14D",0,5},;
                     { OemToAnsi("Aj.Entradas"),"U_RCOMA14AJ",0,6},;
                     { OemToAnsi("Aj.Vdas.Entr."),"U_RCOM14AI",0,7},;
                     { "Legenda","U_RLest002",0,10} }  
						
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi("Amarracao de OC/OS c/ PV/OS")
PRIVATE aTrocaF3  := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

mBrowse(6,1,22,75,"SZK",,,,,3,aCores)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RCOMA12DEL³ Autor ³ ROBSON BUENO          ³ Data ³ 25.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se esta regra e a ultima para o campo             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1: Logico                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function RCOMA14AJ()
Local aSaveArea := GetArea()
Local lRetorno := .T.
Local xQtVend:=0
If MsgYesNo("Esta rotina reprocessa todos os empenhos de Ordens de Compra e Servicos. Este tambem realimenta posicao de entrega das mesmas, a operacao nao movimenta registros manuais alimentados diretamente no modulo. Deseja Processar?")
  If MsgYesNo("Deseja Realmente ajustar Oc. Deseja Processar?")
  MsgInfo("Atencao: Esta rotina atualiza todas as amarracoes com OC e OS pelos modulos de compras e estoques. O processo demora algum tempo, favor aguardar")
  // ATUALIZANDO SZK PELA SC7
  dbSelectArea("SC7")
  DbSetOrder(1)
  DO WHILE (!EOF())
    IF SC7->C7_XPI="      " 
    ELSE
      xQtVend:=Posicione("SC6",1,xFilial("SC6")+SC7->C7_XPI+SUBSTR(SC7->C7_XITPI,1,2),"C6_QTDVEN")
      DbSelectArea("SA2")
      DbSetOrder(1)
      MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
      dbSelectArea("SZK")
      DbSetOrder(4)
      IF MsSeek(xFilial("SZK")+"OC"+SC7->C7_NUM+SUBSTR(SC7->C7_ITEM,2,3))
        Reclock("SZK",.F.)
      ELSE
        Reclock("SZK",.T.)
      ENDIF
      SZK->ZK_FILIAL :=xfilial("SZK") 
      SZK->ZK_TIPO   :="PV"                        						// TIPO 
      SZK->ZK_REF    :=SC7->C7_XPI                 						// PEDIDO
      SZK->ZK_REFITEM:=SC7->C7_XITPI               						// ITEM PEDIDO
      SZK->ZK_NOME   :=SC7->C7_XNREDCL             						// CLIENTE
      SZK->ZK_COD    :=SC7->C7_PRODUTO             						// CODIGO PRODUTO
      SZK->ZK_DESCRI :=SC7->C7_DESCRI            						// DESCRICAO
      IF xQtVend>SC7->C7_QUANT 
         SZK->ZK_QTD    :=SC7->C7_QUANT               						// QUANTIDADE VENDA
      ELSE
         SZK->ZK_QTD    :=xQtVend               						// QUANTIDADE VENDA
      ENDIF
      SZK->ZK_PRAZO  :=SC7->C7_XPZVDA              						// PRAZO VENDA
      SZK->ZK_TIPO2  :="OC"                       						// TIPO2 
      SZK->ZK_OC     :=SC7->C7_NUM	            						// NUMERO OS
      SZK->ZK_ITEM   :=SUBSTR(SC7->C7_ITEM,2,3)   						// ITEM OS
      SZK->ZK_FORN   :=SA2->A2_NREDUZ            						// FORNECEDOR
      SZK->ZK_QTC    :=xQtVend            						// QUANTIDADE CASADA
      SZK->ZK_PRAZOC :=SC7->C7_DATPRF             						// PRAZO ENTRADA
      IF SC7->C7_QUANT<>SC7->C7_QUJE
       SZK->ZK_QTS    :=xQtVend-If(SC7->C7_QUJE>xQtVend,xQtVend,SC7->C7_QUJE)// QUANTIDADE PENDENTE
       SZK->ZK_DT_BX  :=If(SC7->C7_QUJE>xQtVend,DATE(),CTOD(""))
       SZK->ZK_STATUS :=If(SC7->C7_QUJE>xQtVend,"4","1")					// STATUS DA OS
      ELSE
       SZK->ZK_QTS    :=0                      	// QUANTIDADE PENDENTE
       SZK->ZK_DT_BX  :=DATE()
       SZK->ZK_STATUS :="4"							// STATUS DA OS
      ENDIF
      SZK->ZK_DT_VINC:=SC7->C7_EMISSAO    								// DATA DA VINCULACAO
      SZK->ZK_CONTROL:="AOC"									 	    // CONTROLE DE PROCESSO
       MsUnLock()
       xQtVend:=0
    ENDIF
    DBSELECTAREA("SC7")
    dbSkip()
  ENDDO
  MsgInfo("Atualizacao de >>Compras<< Realizada com Sucesso")
  endif
  If MsgYesNo("Deseja Realmente ajustar OS. Deseja Processar?")
  
  // ATUALIZANDO SZK PELA AB7
  dbSelectArea("AB7")
  DbSetOrder(1)
  DO WHILE (!EOF())
    IF AB7->AB7_PV="      "   
    ELSE
      dbselectarea("AB6")
      DbSetOrder(1)
      MsSeek(xFilial("AB6")+AB7->AB7_NUMOS)      
      dbSelectArea("SZK")
      DbSetOrder(4)
      IF MsSeek(xFilial("SZK")+"OS"+AB6->AB6_NUMOS+"01 ")
        Reclock("SZK",.F.)
      ELSE
        Reclock("SZK",.T.)
      ENDIF
      SZK->ZK_FILIAL :=xfilial("SZK") 
      SZK->ZK_TIPO   :="PV"                        	// TIPO 
      SZK->ZK_REF    :=AB7->AB7_PV                 	// PEDIDO
      SZK->ZK_REFITEM:=AB7->AB7_ITPV               	// ITEM PEDIDO
      SZK->ZK_NOME   :=AB7->AB7_NREDUZ             	// CLIENTE
      SZK->ZK_COD    :=AB7->AB7_CODPRE             	// CODIGO PRODUTO
      SZK->ZK_DESCRI :=AB7->AB7_DESENT             	// DESCRICAO
      SZK->ZK_QTD    :=AB7->AB7_QTDVDA             	// QUANTIDADE VENDA
      SZK->ZK_PRAZO  :=AB7->AB7_PRAZOV             	// PRAZO VENDA
      SZK->ZK_TIPO2  :="OS"                       	// TIPO2 
      SZK->ZK_OC     :=AB7->AB7_NUMOS             	// NUMERO OS
      SZK->ZK_ITEM   :="01"                        	// ITEM OS
      SZK->ZK_FORN   :=AB6->AB6_NREDUZ            	// FORNECEDOR
      SZK->ZK_QTC    :=AB7->AB7_QTENT              	// QUANTIDADE CASADA
      SZK->ZK_PRAZOC :=AB6->AB6_VENCTO             	// PRAZO ENTRADA
      IF AB7->AB7_TIPO="5"
        SZK->ZK_QTS    :=0                      	// QUANTIDADE PENDENTE
        SZK->ZK_DT_BX  :=DATE()
        SZK->ZK_STATUS :="4"							// STATUS DA OS
      ELSE
        SZK->ZK_QTS    :=AB7->AB7_QTENT              	// QUANTIDADE PENDENTE
        SZK->ZK_STATUS :="1"							// STATUS DA OS
      ENDIF
      SZK->ZK_DT_VINC:=AB6->AB6_EMISSA				// DATA DA VINCULACAO
      SZK->ZK_CONTROL:="AOS"						// METODO
      MsUnLock()
    ENDIF
    DBSELECTAREA("AB7")
    dbSkip()
  ENDDO
  MsgInfo("Atualizacao de >>Servico<< Realizada com Sucesso")
  endif
  RestArea(aSaveArea)
endif
Return(lRetorno)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RCOMA14TOK³ Autor ³ ROBSON BUENO DA SILVA ³ Data ³ 25/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Busca E GUARDA NA X3 SE amarração feita no usuario         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TECA060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCOMA14TOK()
Local aSaveArea := GetArea()
Local lRet    := .T.
RestArea(aSaveArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RCOMA14SD ³ Autor ³ ROBSON BUENO DA SILVA ³ Data ³ 25/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se existe saldo DE VENDA/OS a amarrar             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TECA060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCM14SD(cTipo,cRef,cItem,nQtd)
Local aSaveArea := GetArea()
Local lRet    := .T.
Local nCasada :=0
// FASE1 - LEVANTAMENTO DOS SALDOS DAS AMARRACOES
if cTipo="PV"
  dbSelectArea("SZK")
  DbSetOrder(1)
  MsSeek(xFilial("SZK")+"PV"+cRef+cItem)
  While (!Eof() .And. cRef==SZK->ZK_REF .And.	cItem==SZK->ZK_REFITEM)
      nCasada:=nCasada+SZK->ZK_QTC
  dbSkip()
  ENDDO
ENDIF
if cTipo=="OS"
  dbSelectArea("SZK")
  DbSetOrder(1)
  MsSeek(xFilial("SZK")+"OS"+cRef+cItem)
  While (!Eof() .And. cRef==SZK->ZK_REF .And.	cItem==SZK->ZK_REFITEM)
     nCasada:=nCasada+SZK->ZK_QTC
  dbSkip()
  ENDDO
endif
// FASE2 - ANALISA POSSIBILIDADE DE AMARRACAO
if cTipo=="PV"
  dbSelectArea("SC6")
  DbSetOrder(1)
  MsSeek(xFilial("SC6")+cRef+SUBSTR(cItem,1,2))
  IF (!Eof() .And. cRef==SC6->C6_NUM .And. SUBSTR(cItem,1,2)==SC6->C6_ITEM)
      IF nCasada+nQtd>SC6->C6_QTDVEN-SC6->C6_QTDENT
        LRET=.F.
      ENDIF
  ENDIF
else
  dbSelectArea("AB7")
  DbSetOrder(1)
  MsSeek(xFilial("AB7")+cRef+cItem)
  IF(!Eof() .And. cRef==AB7->AB7_NUMOS .And. cItem==AB7->AB7_ITEM)
      IF nCasada+nQtd>AB7->AB7_QTENT
        LRET=.F.
      ENDIF
  ENDIF
endif
IF LRET=.F. 
    MsgInfo("O pedido refereniado ja esta casado ou entregue")
    lRet:=.F.
ENDIF
RestArea(aSaveArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Rlest002  ³ Autor ³ ROBSON BUENO DA SILVA ³ Data ³ 25/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Legendas                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TECA060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                     

User Function RLest002()

BrwLegenda(cCadastro,"Situacoes",{{"BR_VERDE","Prod. N. Entregue"}, {"BR_AMARELO","Prod. Parc. Entregue"},;  
                                  {"BR_VERMELHO","Prod. Entregue"}})

Return (.T.)   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RCM14Lp   ³ Autor ³ Eduardo Riera         ³ Data ³27.02.99  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Efetua o tratamento da Troca de PV / OS                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Sempre .T.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhuma                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCM14LP(cVar)

Local aArea     := GetArea()
Local aTexto    := {}
Local nEndereco := 0
Local nCntFor	:= 0
Local nX        := 0
Local oDlg

LOCAL lLimpa := .T.
DEFAULT cVar   := &(ReadVar())


If lLimpa
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array criado para trocar o F3                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ( cVar=="OS" )
		aTrocaF3 := {{"ZK_REF","AB7A"}}
	Else
		aTrocaF3 := {{"ZK_REF","SC6"}}
	EndIf
EndIf
lRefresh := .T.
RestArea(aArea)

Return .T.  


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RCM14LL   ³ Autor ³ Eduardo Riera         ³ Data ³27.02.99  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Efetua o tratamento da Troca de OS  / OC.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Sempre .T.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhuma                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCM14LL(cVar)

Local aArea     := GetArea()
Local aTexto    := {}
Local nEndereco := 0
Local nCntFor	:= 0
Local nX        := 0
Local oDlg

LOCAL lLimpa := .T.
DEFAULT cVar   := &(ReadVar())


If lLimpa
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array criado para trocar o F3                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ( cVar=="OS" )
		aTrocaF3 := {{"ZK_OC","AB7B"}}
	Else
		aTrocaF3 := {{"ZK_OC","SC7"}}
	EndIf
EndIf
lRefresh := .T.
RestArea(aArea)

Return .T.  

 
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RCOMA014I ³ Autor ³ ROBSON BUENO          ³ Data ³ 02/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para digitacao dos saldos iniciais dos almoxari-  ³±±
±±³          ³ fados                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A220Inclui(ExpC1,ExpN1,ExpN2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA220                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RCOM14I(cAlias,nReg,nOpc)
Local nOpca

 nOpca := AxInclui(cAlias,nReg,nOpc,,,,"U_RCO14TOK()")                     
 aTrocaF3 := {{"ZK_OC","SC7"}}
 aTrocaF3 := {{"ZK_REF","SC6"}}
 dbSelectArea(cAlias)
 
Return nOpca


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array TUDO OK                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

USER FUNCTION RCO14TOK()

lOCAL cRegistro
Local cForn
Local cLoja
Local cNome
Local aArea     := GetArea()  
Local nSdoOcCas	:= 0
// TRATA CONTROLE DE PROCESSO
if M->ZK_TIPO="PV"
  IF M->ZK_TIPO2="OC"
    // correcao de bug
    /*nSdoOcCas:=  U_RCO14SDCA(M->ZK_OC+"0"+M->ZK_ITEM)*/
    
    
    cForn:=Posicione("SC7",1,xFilial("SC7")+M->ZK_OC+"0"+M->ZK_ITEM,"C7_FORNECE")
    cLoja:=Posicione("SC7",1,xFilial("SC7")+M->ZK_OC+"0"+M->ZK_ITEM,"C7_LOJA")
    cNome:=Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_NREDUZ")  
    dbselectarea("PC2")
    dbSetOrder(4)
    MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"000005")
    if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=M->ZK_REF .AND. SUBSTRING(M->ZK_REFITEM,1,2)=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000005"
       cRegistro:=PC2->PC2_CTR
       // 1 BAIXA SOLICITACAO DE COMPRA E POR EM ORDEM DE COMPRA 
       U_HCICTPR(M->ZK_REF,SUBSTRING(M->ZK_REFITEM,1,2),"000005","000007",M->ZK_QTC,"Aguardando Amarracao","","","Ok Disposto Comprar",cRegistro) 
       MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"000007")
       cRegistro:=PC2->PC2_CTR
       // 2 BAIXA ORDEM DE COMPRA E POE EM AGUARDANDO RECEBIMENTO
        U_HCICTPR(M->ZK_REF,SUBSTRING(M->ZK_REFITEM,1,2),"000007","000010",M->ZK_QTC,"Aguardando Recebimento","","","OC:"+M->SZK_OC+" - 0"+M->ZK_ITEM+" - "+cNome,cRegistro,M->ZK_PRAZO) 
    endif  
  ELSE
    cForn:=Posicione("AB6",1,xFilial("AB6")+M->ZK_OC,"AB6_CODCLI")
    cLoja:=Posicione("AB6",1,xFilial("AB6")+M->ZK_OC,"AB6_LOJA")
    cNome:=Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_NREDUZ")  
    dbselectarea("PC2")
    dbSetOrder(4)
    MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"000005")
    if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=M->ZK_REF .AND. SUBSTRING(M->ZK_REFITEM,1,2)=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000005"
       cRegistro:=PC2->PC2_CTR
       // 1 BAIXA SOLICITACAO DE COMPRA E POR EM ORDEM DE COMPRA 
        U_HCICTPR(M->ZK_REF,SUBSTRING(M->ZK_REFITEM,1,2),"000005","000008",M->ZK_QTC,"Aguardando Amarracao","","","Ok Disposto OS",cRegistro) 
       MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"000008")
       cRegistro:=PC2->PC2_CTR
       // 2 BAIXA ORDEM DE COMPRA E COLOCA EM FATURAMENTO OS
        U_HCICTPR(M->ZK_REF,SUBSTRING(M->ZK_REFITEM,1,2),"000008","000009",M->ZK_QTC,"Aguardando Fat Rem. Benef","","","OS:"+M->ZK_OC+" - 01 - "+cNome,cRegistro) 
     endif
  ENDIF   
  RestArea(aArea)
ENDIF
 
RETURN .T.


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RCOMA014A ³ Autor ³ ROBSON BUENO          ³ Data ³ 02/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para digitacao dos saldos iniciais dos almoxari-  ³±±
±±³          ³ fados                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A220Inclui(ExpC1,ExpN1,ExpN2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA220                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RCOM14A(cAlias,nReg,nOpc)
Local nOpca

 nOpca := Axaltera(cAlias,nReg,nOpc,,,,"U_RCO14AOK()")                     
 aTrocaF3 := {{"ZK_OC","SC7"}}
 aTrocaF3 := {{"ZK_REF","SC6"}}
 dbSelectArea(cAlias)
 
Return nOpca


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array TUDO OK                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

USER FUNCTION RCO14AOK()

lOCAL cRegistro
Local cForn
Local cLoja
Local cNome
Local lRet:=.T.
Local c450Pv
Local c450ItemPv
Local c450Ctr
Local c450CtrOri
// Ve se Pode Alterar
IF M->ZK_TIPO2="OS"
  dbselectarea("PC2")
  dbSetOrder(6)
  MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"OS:"+M->ZK_OC+" - 01")
  IF SUBSTRING(PC2->PC2_INF,1,14)="OS:"+M->ZK_OC+" - 01"
       c450Pv    :=PC2->PC2_NUM
       c450ItemPv:=PC2->PC2_ITEM
       c450Ctr   :=PC2->PC2_CTR
       c450Ctrori:=PC2->PC2_CTRORI
     // sEGUNDO - ELIMINA PROCESSO ATUAL
      IF U_HCIPDPR(c450Pv,c450ItemPv,c450Ctr)=.T.   // PEDIDO - ITEM - CONTROLE
        U_HCIEXPR(c450Pv,c450ItemPv,c450Ctr) 
      ELSE
        lRet:=.F.
      ENDIF
      // PRIMEITAMENTE ELIMINA processo do Faturamento OS se Possivel
      IF U_HCIPDPR(c450Pv,c450ItemPV,c450CtrOri)=.T. .AND. lret  // PEDIDO - ITEM - CONTROLE
        U_HCIEXPR(c450Pv,c450ItemPv,c450Ctrori) 
      ENDIF 
  ENDIF
ELSE
  dbselectarea("PC2")
  dbSetOrder(6)
  MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"OC:"+M->ZK_OC+" - "+"0"+M->ZK_ITEM)
  IF SUBSTRING(PC2->PC2_INF,1,16)="OC:"+M->ZK_OC+" - "+"0"+M->ZK_ITEM
      c450Pv    :=PC2->PC2_NUM
      c450ItemPv:=PC2->PC2_ITEM
      c450Ctr   :=PC2->PC2_CTR
      c450Ctrori:=PC2->PC2_CTRORI
     // sEGUNDO - ELIMINA PROCESSO ATUAL
      IF U_HCIPDPR(c450Pv,c450ItemPv,c450Ctr)=.T.   // PEDIDO - ITEM - CONTROLE
        U_HCIEXPR(c450Pv,c450ItemPv,c450Ctr) 
      ELSE
        lRet:=.F.
      ENDIF
      // PRIMEITAMENTE ELIMINA processo do Faturamento OS se Possivel
      IF U_HCIPDPR(c450Pv,c450ItemPV,c450CtrOri)=.T. .AND. lret  // PEDIDO - ITEM - CONTROLE
        U_HCIEXPR(c450Pv,c450ItemPv,c450Ctrori) 
      ENDIF 
         
  ENDIF
eNDIF
if lRet
  // refaz os registros 
  if M->ZK_TIPO="PV"
    IF M->ZK_TIPO2="OC"
      cForn:=Posicione("SC7",1,xFilial("SC7")+M->ZK_OC+"0"+M->ZK_ITEM,"C7_FORNECE")
      cLoja:=Posicione("SC7",1,xFilial("SC7")+M->ZK_OC+"0"+M->ZK_ITEM,"C7_LOJA")
      cNome:Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_NREDUZ")  
      dbselectarea("PC2")
      dbSetOrder(4)
      MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"000005")
      if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=M->ZK_REF .AND. SUBSTRING(M->ZK_REFITEM,1,2)=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000005"
        cRegistro:=PC2->PC2_CTR
        // 1 BAIXA SOLICITACAO DE COMPRA E POR EM ORDEM DE COMPRA 
        U_HCICTPR(M->ZK_REF,SUBSTRING(M->ZK_REFITEM,1,2),"000005","000007",M->ZK_QTC,"Aguardando Amarracao","","","Ok Disposto Comprar",cRegistro) 
        MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"000007")
        cRegistro:=PC2->PC2_CTR
        // 2 BAIXA ORDEM DE COMPRA E POE EM AGUARDANDO RECEBIMENTO
         U_HCICTPR(M->ZK_REF,SUBSTRING(M->ZK_REFITEM,1,2),"000007","000010",M->ZK_QTC,"Aguardando Recebimento","","","OC:"+M->SZK_OC+" - 0"+M->ZK_ITEM+" - "+cNome,cRegistro,M->ZK_PRAZO) 
      endif  
    ELSE
      cForn:=Posicione("AB6",1,xFilial("AB6")+M->ZK_OC,"AB6_FORNECE")
      cLoja:=Posicione("AB6",1,xFilial("AB6")+M->ZK_OC,"AB6_LOJA")
      cNome:Posicione("SA2",1,xFilial("SA2")+cForn+cLoja,"A2_NREDUZ")  
      dbselectarea("PC2")
      dbSetOrder(4)
      MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"000005")
      if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=M->ZK_REF .AND. SUBSTRING(M->ZK_REFITEM,1,2)=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000005"
         cRegistro:=PC2->PC2_CTR
         // 1 BAIXA SOLICITACAO DE COMPRA E POR EM ORDEM DE COMPRA 
         U_HCICTPR(M->ZK_REF,SUBSTRING(M->ZK_REFITEM,1,2),"000005","000008",M->ZK_QTC,"Aguardando Amarracao","","","Ok Disposto OS",cRegistro) 
         MsSeek(xfilial("PC2")+M->ZK_REF+SUBSTRING(M->ZK_REFITEM,1,2)+"000008")
         cRegistro:=PC2->PC2_CTR
         // 2 BAIXA ORDEM DE COMPRA E COLOCA EM FATURAMENTO OS
          U_HCICTPR(M->ZK_REF,SUBSTRING(M->ZK_REFITEM,1,2),"000008","000009",M->ZK_QTC,"Aguardando Fat Rem. Benef","","","OS:"+M->ZK_OC+" - 01 - "+cNome,cRegistro) 
      endif 
      RestArea(aArea)
    ENDIF
  ENDIF
ELSE
  Aviso("Atencao","Nao sera possivel Alterar Amarracao pois Existem Rotinas de Controle de Processo posteriores Baixadas... Elimine as amarrações de Processo para depois Alterar... ",{"OK"},2) //"Atencao"###"Nao registro de estoques para este produto."###"Voltar"
ENDIF
 
RETURN (lRet)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RCM14A1   ³ Autor ³ ROBSON BUENO          ³ Data ³02.10.07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ALIMENTA CAMPOS CONFORME PARAMETROS INFORMADOS              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Sempre .T.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhuma                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCM14A1()
  LOCAL lRet:=.T.
  Local aArea     := GetArea()  
  LOCAL cVar
  IF FunName()=="RCOMA014"
    cVar:=M->ZK_TIPO
    IF ( cVar=="OS" )
	    dbSelectArea("AB6")
        DbSetOrder(1)
        MsSeek(xFilial("AB6")+M->ZK_Ref+M->ZK_REFITEM)
		IF (!Eof())
			M->ZK_NOME:=AB6->AB6_NREDUZ
		    M->ZK_COD:= AB7->AB7_CODPRS
		    M->ZK_DESCRI:=AB7->AB7_DESSAI
		    IF AB7->AB7_TIPO="5"
		      M->ZK_QTD:=0  
		    ELSE  
		      M->ZK_QTD:=AB7->AB7_QTSAI
		    ENDIF
		    M->ZK_PRAZO:=AB6->AB6_VENCTO
		ENDIF    
    Else
		dbSelectArea("SC5")
        DbSetOrder(1)
        MsSeek(xFilial("SC5")+M->ZK_Ref+M->ZK_REFITEM)
		IF (!Eof())
		  M->ZK_NOME:=SC5->C5_XNREDUZ
		  M->ZK_COD:= SC6->C6_PRODUTO
		  M->ZK_DESCRI:=SC6->C6_DESCRI
		  M->ZK_QTD:=SC6->C6_QTDVEN-SC6->C6_QTDENT
		  M->ZK_PRAZO:=SC6->C6_ENTREG
	    ENDIF
    EndIf
    IF M->ZK_QTD=0 
      MsgInfo("Pedido/OS N." + M->ZK_Ref +"/"+ M->ZK_REFITEM + " nao tem saldo")
      lRet:=.F.
    ENDIF
  ENDIF
  
  RestArea(aArea)
RETURN (LRET)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RCM14A1   ³ Autor ³ ROBSON BUENO          ³ Data ³02.10.07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ALIMENTA CAMPOS CONFORME PARAMETROS INFORMADOS              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Sempre .T.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhuma                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCM14A2(cVar)
  Local aArea     := GetArea()  
  LOCAL lRet:=.T.
  IF ( cVar=="OS" )
	    dbSelectArea("AB6")
        DbSetOrder(1)
        MsSeek(xFilial("AB6")+M->ZK_OC+M->ZK_ITEM)
		IF (!Eof())
			M->ZK_FORN:=AB6->AB6_NREDUZ
		    IF AB7->AB7_TIPO="5" 
		      M->ZK_QTC:= 0
		      M->ZK_QTS:= 0
		    ELSE
		      M->ZK_QTC:= AB7->AB7_QTENT
		      M->ZK_QTS:= AB7->AB7_QTENT
		    ENDIF
		    M->ZK_PRAZOC:=AB6->AB6_VENCTO
		    M->ZK_DT_VINC:=DATE()
		ENDIF
		if M->ZK_COD<>AB7->AB7_CODPRE
		  MsgInfo("Produtos Divergentes PV/OS -->" + M->ZK_COD + " OC/OS --> " +  AB7->AB7_CODPRE + ", portanto nao e possivel amarrar Processos")
		  lret:=.F.
		ENDIF    
  Else
		dbSelectArea("SA2")
        DbSetOrder(1)
        MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
		IF (!Eof())
		  M->ZK_FORN:=SA2->A2_NREDUZ
		  IF SC7->C7_QUANT-SC7->C7_QUJE>M->ZK_QTD
            M->ZK_QTC:= M->ZK_QTD
		    M->ZK_QTS:= M->ZK_QTD
		  ELSE  
		    M->ZK_QTC:= SC7->C7_QUANT-SC7->C7_QUJE
		    M->ZK_QTS:= SC7->C7_QUANT-SC7->C7_QUJE
		  ENDIF  
		  M->ZK_PRAZOC:=SC7->C7_DATPRF
		  M->ZK_DT_VINC:=DATE()
	    ENDIF
		if M->ZK_COD<>SC7->C7_PRODUTO
		  MsgInfo("Produtos Divergentes PV/OS -->" + M->ZK_COD + " OC/OS --> " +  SC7->C7_PRODUTO + ", portanto nao e possivel amarrar Processos")
		  lret:=.F.
		ENDIF    
  EndIf
  IF M->ZK_QTC=0                
    MsgInfo("OC/OS N." + M->ZK_OC +"/"+ M->ZK_ITEM + " nao tem saldo, portanto nao e possivel amarrar Processos")
    lRet:=.F.
  ENDIF
  
  RestArea(aArea)
RETURN (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RCM14PC   ³ Autor ³ ROBSON BUENO DA SILVA ³ Data ³ 25/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se existe saldo DE OC/OS a amarrar COM PV/OS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TECA060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCM14PC(cTipo,cRef,cItem,nQtd)
Local aSaveArea := GetArea()
Local lRet    := .T.
Local nCasada :=0
// FASE1 - LEVANTAMENTO DOS SALDOS DAS AMARRACOES
if cTipo="OC"
  dbSelectArea("SZK")
  DbSetOrder(4)
  MsSeek(xFilial("SZK")+"OC"+cRef+"0"+cItem)
  While (!Eof() .And. cRef==SZK->ZK_OC .And. "0"+cItem==SZK->ZK_ITEM)
      nCasada:=nCasada+SZK->ZK_QTC
  dbSkip()
  ENDDO
ENDIF
if cTipo=="OS"
  dbSelectArea("SZK")
  DbSetOrder(1)
  MsSeek(xFilial("SZK")+"OS"+cRef+cItem)
  While (!Eof() .And. cRef==SZK->ZK_REF .And.	cItem==SZK->ZK_REFITEM)
     nCasada:=nCasada+SZK->ZK_QTC
  dbSkip()
  ENDDO
endif
// FASE2 - ANALISA POSSIBILIDADE DE AMARRACAO
if cTipo=="OC"
  dbSelectArea("SC7")
  DbSetOrder(1)
  MsSeek(xFilial("SC7")+cRef+cItem)
  IF (!Eof() .And. cRef==SC7->C7_NUM .And. cItem==SC7->C7_ITEM)
      IF nCasada+nQtd>SC7->C7_QUANT-SC7->C7_QTDENT
        LRET=.F.
      ENDIF
  ENDIF
else
  dbSelectArea("AB7")
  DbSetOrder(1)
  MsSeek(xFilial("AB7")+cRef+cItem)
  IF(!Eof() .And. cRef==AB7->AB7_NUMOS .And. cItem==AB7->AB7_ITEM)
      IF nCasada+nQtd>AB7->AB7_QTENT
        LRET=.F.
      ENDIF
  ENDIF
endif
IF LRET=.F. 
    MsgInfo("O item da OC/OS ja esta totalmente empenhado ou entregue")
    lRet:=.F.
ENDIF
RestArea(aSaveArea)
Return(lRet)
            

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RCOM14D   ³ Autor ³ ROBSON BUENO          ³ Data ³ 02/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Validacao de Dados da Oc na Exclusao da Amarra ³±±
±±³          ³ cao da OC x Oc/PV                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A450EXCLUI(ExpC1,ExpN1,ExpN2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA220                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RCOM14D(cAlias,nReg,nOpc)
 Local nOpca
 Local lRet:=.T.
 Local c450Pv
 Local c450ItemPv
 Local c450Ctr
 Local c450CtrOri
 // Ve se pode excluir
 IF SZK->ZK_TIPO2="OS"
    dbselectarea("PC2")
    dbSetOrder(6)
    MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"OS:"+SZK->ZK_OC+" - 01")
    IF SUBSTRING(PC2->PC2_INF,1,14)="OS:"+SZK->ZK_OC+" - 01"
       c450Pv    :=PC2->PC2_NUM
       c450ItemPv:=PC2->PC2_ITEM
       c450Ctr   :=PC2->PC2_CTR
       c450Ctrori:=PC2->PC2_CTRORI
     // sEGUNDO - ELIMINA PROCESSO ATUAL
      IF U_HCIPDPR(c450Pv,c450ItemPv,c450Ctr)=.T.   // PEDIDO - ITEM - CONTROLE
        LrET:=.T.
      ELSE
        lRet:=.F.
      ENDIF
      // PRIMEITAMENTE ELIMINA processo do Faturamento OS se Possivel
      IF U_HCIPDPR(c450Pv,c450ItemPV,c450CtrOri)=.T. .AND. lret  // PEDIDO - ITEM - CONTROLE
        LRET:=.T.
      ELSE
        lRet:=.F.
      ENDIF 
    ENDIF
 ELSE
    dbselectarea("PC2")
    dbSetOrder(6)
    MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"OC:"+SZK->ZK_OC+" - "+"0"+SZK->ZK_ITEM)
    IF SUBSTRING(PC2->PC2_INF,1,16)="OC:"+SZK->ZK_OC+" - "+"0"+SZK->ZK_ITEM
      c450Pv    :=PC2->PC2_NUM
      c450ItemPv:=PC2->PC2_ITEM
      c450Ctr   :=PC2->PC2_CTR
      c450Ctrori:=PC2->PC2_CTRORI
     // sEGUNDO - ELIMINA PROCESSO ATUAL
      IF U_HCIPDPR(c450Pv,c450ItemPv,c450Ctr)=.T.   // PEDIDO - ITEM - CONTROLE
        LRET:=.T.
      ELSE
        lRet:=.F.
      ENDIF
      // PRIMEITAMENTE ELIMINA processo do Faturamento OS se Possivel
      IF U_HCIPDPR(c450Pv,c450ItemPV,c450CtrOri)=.T. .AND. lret  // PEDIDO - ITEM - CONTROLE
        LRET:=.T.
      ELSE
        lRet:=.F.
      ENDIF
    ENDIF
    // CONTINUA A ROTINA ANTERIOR
 ENDIF
 if lRet=.T.
   AxDELETA(cAlias,nReg,nOpc,"U_RCO14DOK()")        
 else
    Aviso("Atencao","Nao sera possivel excluir Amarracao pois Existem Rotinas De Controle de Processo posteriores Baixadas... Elimine as amarrações de Processo para depois excluir... ",{"OK"},2) //"Atencao"###"Nao registro de estoques para este produto."###"Voltar"
 endif 
 dbSelectArea(cAlias)
 
Return LRET


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array TUDO OK                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

USER FUNCTION RCO14DOK()
  Local lRet:=.T.
  Local c450Pv
  Local c450ItemPv
  Local c450Ctr
  Local c450CtrOri
  // Ve se pode excluir
  IF SZK->ZK_TIPO2="OS"
    dbselectarea("PC2")
    dbSetOrder(6)
    MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"OS:"+SZK->ZK_OC+" - 01")
    IF SUBSTRING(PC2->PC2_INF,1,14)="OS:"+SZK->ZK_OC+" - 01"
       c450Pv    :=PC2->PC2_NUM
       c450ItemPv:=PC2->PC2_ITEM
       c450Ctr   :=PC2->PC2_CTR
       c450Ctrori:=PC2->PC2_CTRORI
     // sEGUNDO - ELIMINA PROCESSO ATUAL
      IF U_HCIPDPR(c450Pv,c450ItemPv,c450Ctr)=.T.   // PEDIDO - ITEM - CONTROLE
        U_HCIEXPR(c450Pv,c450ItemPv,c450Ctr) 
      ELSE
        lRet:=.F.
      ENDIF
      // PRIMEITAMENTE ELIMINA processo do Faturamento OS se Possivel
      IF U_HCIPDPR(c450Pv,c450ItemPV,c450CtrOri)=.T. .AND. lret  // PEDIDO - ITEM - CONTROLE
        U_HCIEXPR(c450Pv,c450ItemPv,c450Ctrori) 
      ENDIF 
    ENDIF
  ELSE
    dbselectarea("PC2")
    dbSetOrder(6)
    MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"OC:"+SZK->ZK_OC+" - "+"0"+SZK->ZK_ITEM)
    IF SUBSTRING(PC2->PC2_INF,1,16)="OC:"+SZK->ZK_OC+" - "+"0"+SZK->ZK_ITEM
      c450Pv    :=PC2->PC2_NUM
      c450ItemPv:=PC2->PC2_ITEM
      c450Ctr   :=PC2->PC2_CTR
      c450Ctrori:=PC2->PC2_CTRORI
     // sEGUNDO - ELIMINA PROCESSO ATUAL
      IF U_HCIPDPR(c450Pv,c450ItemPv,c450Ctr)=.T.   // PEDIDO - ITEM - CONTROLE
        U_HCIEXPR(c450Pv,c450ItemPv,c450Ctr) 
      ELSE
        lRet:=.F.
      ENDIF
      // PRIMEITAMENTE ELIMINA processo do Faturamento OS se Possivel
      IF U_HCIPDPR(c450Pv,c450ItemPV,c450CtrOri)=.T. .AND. lret  // PEDIDO - ITEM - CONTROLE
        U_HCIEXPR(c450Pv,c450ItemPv,c450Ctrori) 
      ENDIF 
    ENDIF
    // CONTINUA A ROTINA ANTERIOR
  ENDIF
  // Exclusao 
  if lRet
    If MsgYesNo("Deseja Eliminar tambem Amarracao Na OC/OS. Rotina Automatica?")
      IF SZK->ZK_TIPO2="OC"
        dbSelectArea("SC7")
        DbSetOrder(1)
        IF MsSeek(xFilial("SC7")+SZK->ZK_OC+"0"+SZK->ZK_ITEM)
          Reclock("SC7",.F.)
          SC7->C7_XPI:="      "  
          MsUnLock()
        ENDIF 
      endif
      IF SZK->ZK_TIPO2="OS"
        dbSelectArea("AB7")
        DbSetOrder(1)
        IF MsSeek(xFilial("AB7")+SZK->ZK_OC)
          Reclock("AB7",.F.)
          AB7->AB7_PV:="      " 
          MsUnLock()
        ENDIF 
      endif
    endif
  else
    Aviso("Atencao","Nao sera possivel excluir Amarracao pois Existem Rotinas ce Controle de Processo posteriores Baixadas... Elimine as amarrações de Processo para depois excluir... ",{"OK"},2) //"Atencao"###"Nao registro de estoques para este produto."###"Voltar"
  endif 
 
RETURN (lret) 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RCOMA12DEL³ Autor ³ ROBSON BUENO          ³ Data ³ 25.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se esta regra e a ultima para o campo             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1: Logico                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function RCOM14AI()
Local aSaveArea := GetArea()
Local lRetorno := .T.
Local nQtd:=0
Local nEntr:=0
If MsgYesNo("Esta Rotina Encerra todos os processos Amarrados a Vendas Ja Entregues. Deseja Processar?")
  // ATUALIZANDO AB7 PELA SC6
  dbSelectArea("SZK")
  DbSetOrder(1)
  MsSeek(xFilial("SZK")+"PV")
  IF MsgYesNo("Liquida Verificando Item a Item?, Se sim vai solicitar a liquidação por Evento encontrado")
   DO WHILE (!EOF() .AND. SZK->ZK_TIPO="PV")
    IF SZK->ZK_STATUS <>"4"		
      nQtd:=0
      nEntr:=0
      nEntr:=Posicione("SC6",1,xFilial("SC6")+SZK->ZK_REF+SUBSTR(SZK->ZK_REFITEM,1,2),"C6_QTDENT")
      nQtd :=Posicione("SC6",1,xFilial("SC6")+SZK->ZK_REF+SUBSTR(SZK->ZK_REFITEM,1,2),"C6_QTDVEN")
      IF nEntr=nQtd 
        
        IF MsgYesNo("Deseja Liquidar pendencia ref:"+SZK->ZK_REF+" Item:"+SZK->ZK_REFITEM + "?")
          Reclock("SZK",.F.)
          SZK->ZK_QTDANT :=SZK->ZK_QTS 
          SZK->ZK_USUARIO:=Substr(cUsuario,7,15)
          SZK->ZK_QTS    :=0                      	// QUANTIDADE PENDENTE
          SZK->ZK_DT_BX  :=DATE()
          SZK->ZK_STATUS :="4" 
          msUnlock()							// STATUS DA OS
        ENDIF
      ENDIF
    ENDIF  
    dbSkip()
   ENDDO
  else
   DO WHILE (!EOF() .AND. SZK->ZK_TIPO="PV")
   IF SZK->ZK_STATUS <>"4"		
      nQtd:=0
      nEntr:=0
      nEntr:=Posicione("SC6",1,xFilial("SC6")+SZK->ZK_REF+SUBSTR(SZK->ZK_REFITEM,1,2),"C6_QTDENT")
      nQtd :=Posicione("SC6",1,xFilial("SC6")+SZK->ZK_REF+SUBSTR(SZK->ZK_REFITEM,1,2),"C6_QTDVEN")
      IF nEntr=nQtd 
          Reclock("SZK",.F.)
          SZK->ZK_QTDANT :=SZK->ZK_QTS 
          SZK->ZK_USUARIO:=Substr(cUsuario,7,15)
          SZK->ZK_QTS    :=0                      	// QUANTIDADE PENDENTE
          SZK->ZK_DT_BX  :=DATE()
          SZK->ZK_STATUS :="4" 
          msUnlock()							// STATUS DA OS
      ENDIF
    ENDIF  
    dbSkip()
   ENDDO
  endif
  MsgInfo("Atualizacao de >>Pendencias<< Realizada com Sucesso")
  RestArea(aSaveArea)
endif
Return(lRetorno)
