#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PZCVA011  	ºAutor  ³Microsiga 	     º Data ³  06/04/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava observação da baixa do CQ				 		      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  
*/
User Function PZCVA011()

	Local aArea	:= GetArea()

	GrvObsCQ(SD7->(Recno()))

	RestArea(aArea)	
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvObsCQ	ºAutor  ³Microsiga		     º Data ³  06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela para gravação da baixa do CQ						      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvObsCQ(nRecSd7)

	Local aArea := GetArea()
	Local cRet	:= ""
	Local oDlg 
	Local oWin01
	Local oFWLayer 
	Local oButSair
	Local oButOk
	Local oTMulget
	Local lGrvObs	:= .F.

	If nRecSd7 != 0
		DbSelectArea("SD7")
		SD7->(DbGoTo(nRecSd7))

		cRet	:=  U_PZCVG003()
	EndiF

	//Montagem da tela
	DEFINE DIALOG oDlg TITLE "Observação CQ" SIZE 400,400 PIXEL STYLE nOr(WS_VISIBLE,WS_OVERLAPPEDWINDOW)

	//Cria instancia do fwlayer
	oFWLayer := FWLayer():New()

	//Inicializa componente passa a Dialog criada,o segundo parametro é para 
	//criação de um botao de fechar utilizado para Dlg sem cabeçalho 		  
	oFWLayer:Init( oDlg, .T. )

	// Efetua a montagem das colunas das telas
	oFWLayer:AddCollumn( "Col01", 100, .T. )


	// Cria tela passando, nome da coluna onde sera criada, nome da window			 	
	// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,	
	// se é redimensionada em caso de minimizar outras janelas e a ação no click do split 	
	oFWLayer:AddWindow( "Col01", "Win01", "Observação", 100, .F., .T., ,,) 
	oWin01 := oFWLayer:getWinPanel('Col01','Win01')

	oTMulget := TMultiGet():New( 005,005, {|u| if( Pcount()>0, cRet:= u, cRet) },;
	oWin01,183,oWin01:nClientHeight - (oWin01:nClientHeight * 56.45)/100 ,;
	,.T.,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,.T.)  


	oButOk		:= TButton():New( 153, 125, "Continuar",oWin01,{ ||; 
	IIf(Empty(cRet),Aviso("Campo obrigatório","Campo obrigatório não preenchido",{"Ok"},1),lGrvObs := .T.),;
	Iif(lGrvObs,oDlg:End(),Nil) }, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	oButSair		:= TButton():New( 153, 160, "Sair",oWin01,{ ||cRet := "", oDlg:End() }, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE DIALOG oDlg CENTERED

	//Grava a observação
	If lGrvObs
		GrvSZQ(cRet, nRecSd7)
	EndIf

	RestArea(aArea)
Return cRet  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GrvSZQ	ºAutor  ³Microsiga		     º Data ³  06/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava os dados da observação na tabela SZQ			      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvSZQ(cMsgObs, nRecSd7)

	Local aArea	:= GetArea()

	Default cMsgObs	:= "" 
	Default nRecSd7	:= 0

	If nRecSd7 != 0
		DbselectArea("SD7")
		SD7->(DbGoTo(nRecSd7))

		DbSelectArea("SZQ")
		DbSetOrder(1)

		If SZQ->(DbSeek(xFilial("SZQ") + SD7->D7_PRODUTO+SD7->D7_LOTECTL))
			RecLock("SZQ",.F.)
			SZQ->ZQ_OBSERV := cMsgObs
			SZQ->(MsUnLock())
		Else
			RecLock("SZQ",.T.)
			SZQ->ZQ_FILIAL	:= xFilial("SZQ")
			SZQ->ZQ_PRODUTO := SD7->D7_PRODUTO
			SZQ->ZQ_LOTECTL	:= SD7->D7_LOTECTL
			SZQ->ZQ_OBSERV := cMsgObs
			SZQ->(MsUnLock())
		EndIf
	EndIf
	
	RestArea(aArea)
Return