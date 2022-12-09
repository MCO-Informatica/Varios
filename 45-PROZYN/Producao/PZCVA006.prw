#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVA006		บAutor  ณMicrosiga	     บ Data ณ  04/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAprova็ใo / Reprova็ใo do pedido de venda		 			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCVA006()

	Local aArea 	:= GetArea()
	Local oBrowse  
	Local cFiltro	:= ""
	Local cCodUsr	:= Alltrim(RetCodUsr())
	Local cCodUApv	:= U_MyNewSX6("CV_USAPVPV", ""	,"C","Usuarios liberados a utilizar a rotina - Faturamento", "", "", .F. )
	Local cCodUFin  := U_MyNewSX6("CV_USAPVFI", ""	,"C","Usuarios liberados a utilizar a rotina - Financeiro", "", "", .F. )
	Local cCodUMar  := U_MyNewSX6("CV_USAPVMA", ""	,"C","Usuarios liberados a utilizar a rotina - Margem", "", "", .F. )
	Local cCodUPMi  := U_MyNewSX6("CV_USAPVPM", ""	,"C","Usuarios liberados a utilizar a rotina - Pre็o Mํnimo", "", "", .F. )
	Private lFat 		:= .F.
	Private lFin 		:= .F.
	Private lMar		:= .F.
	Private lPMi		:= .F.

	Private aRotina	:= {}

	If Alltrim(cCodUsr) $ Alltrim(cCodUApv)
		lFat := .T.
	EndIf
	If Alltrim(cCodUsr) $ Alltrim(cCodUFin)
		lFin := .T.
	EndIf
	If Alltrim(cCodUsr) $ Alltrim(cCodUMar)
		lMar := .T.
	EndIf
	If Alltrim(cCodUsr) $ Alltrim(cCodUPMi)
		lPMi := .T.
	EndIf

	If !lFat .and. !lFin .and. !lMar .and. !lPMi
		Aviso("Aten็ใo-(CV_USAPVPV | CV_USAPVFI | CV_USAPVMA | CV_USAPVPM)","Usuแrio nใo autorizado a utilizar a rotina de aprova็ใo. "+CRLF;
		+"Entre em contato com o administrador do sistema. ",{"Ok"},2)
		Return
	EndIf

	DbSelectArea('SC5')

	//Cria o objeto do tipo FWMBrowse
	oBrowse := FWMBrowse():New()     

	//Alias ta tabela a ser utilizada no browse
	oBrowse:SetAlias('SC5') 

	//Defini็ใo de filtro
	If lFat
		cFiltro += " (C5_BLQ == '9' .AND. Alltrim(C5_YTPBLQ) $ 'ABC') "
	EndIf
	If lFin
		If lFat
			cFiltro += " .OR. Alltrim(C5_XBLQFIN) == 'B' "
		Else
			cFiltro += " Alltrim(C5_XBLQFIN) == 'B' "
		EndIf
	EndIf
	If lMar
		If lFat .or. lFin
			cFiltro += " .OR. Alltrim(C5_XBLQMRG) == 'S' "
		Else
			cFiltro += " Alltrim(C5_XBLQMRG) == 'S' "
		EndIf
	EndIf

	// If lPMi
	// 	If lFat .or. lFin
	// 		cFiltro += " .OR. Alltrim(C5_XBLQMIN) == 'S' "
	// 	Else
	// 		cFiltro += " Alltrim(C5_XBLQMIN) == 'S' "
	// 	EndIf
	// EndIf
	oBrowse:SetFilterDefault(cFiltro)

	//Legenda
	If lFin
		oBrowse:AddLegend( "Alltrim(C5_XBLQFIN) == 'B'"	, "BR_VIOLETA"		, "Blq. Financeiro" )
	EndIf
	If lMar
		oBrowse:AddLegend( "Alltrim(C5_XBLQMRG) == 'S'"	, "BR_PINK"		, "Blq. Margem" )
	EndIf
	// If lPMi
	// 	oBrowse:AddLegend( "Alltrim(C5_XBLQMIN) == 'S'"	, "CLR_HCYAN"		, "Blq. Margem" )
	// EndIf
	If lFat
		// oBrowse:AddLegend( "C5_BLQ == '9' .And. Alltrim(C5_YTPBLQ) == 'A' "	, "BR_PINK"			, "Blq. Faturamento Minimo" )
		// oBrowse:AddLegend( "C5_BLQ == '9' .And. Alltrim(C5_YTPBLQ) == 'B' "	, "BR_BRANCO"		, "Blq. Data Ciclo" )
		oBrowse:AddLegend( "C5_BLQ == '9' .And. Alltrim(C5_YTPBLQ) == 'C' "	, "BR_MARRON"		, "Blq. Credito" )
		// oBrowse:AddLegend( "C5_BLQ == '9' .And. Alltrim(C5_YTPBLQ) == 'AB'"	, "BR_PRETO"		, "Blq. Fat.Min. e Dt.Ciclo" )
	EndIf




	//Descri็ใo da rotina
	oBrowse:SetDescription("Aprova็ใo de pedido de venda")

	oBrowse:Activate()

	RestArea(aArea)	
Return

User Function PZCLIANL
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	If ( Pergunte("FIC010",.T.) )
		Fc010Con()
	EndIf
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef บAutor  ณMicrosiga 	          บ Data ณ 04/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de defini็ใo do aRotina							  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef() 

	Private aRotina	:= {}
	Default lFin := .F.

	ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
	ADD OPTION aRotina Title "Visualizar" 				Action 'U_PZCV6VIS' 		OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title "Aprovar"  				Action 'U_PZCV6APR' 		OPERATION 7 ACCESS 0
	ADD OPTION aRotina Title "Reprovar"  				Action 'U_PZCV6REP'			OPERATION 8 ACCESS 0
	If lFin
		ADD OPTION aRotina Title "Anแlise Cliente"  			Action 'U_PZCLIANL'			OPERATION 7 ACCESS 0
	EndIf

Return aRotina 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZCV6VIS บAutor  ณMicrosiga 	          บ Data ณ 04/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de visualiza็ใo									  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCV6VIS()
	Local aArea	:= GetArea()	

	VISUAL := .T.
	A410Visual("SC5",SC5->(Recno()),2)
	VISUAL := .F.
	RestArea(aArea)	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZCV6APR บAutor  ณMicrosiga 	          บ Data ณ 04/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de aprova็ใo										  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCV6APR()

	Local aArea	:= GetArea()

	If Aviso("Aten็ใo","Confirma a aprova็ใo do pedido "+SC5->C5_NUM+" ?",{"Sim","Nใo"})==1

		If Alltrim(SC5->C5_BLQ) == "9" .And. Alltrim(SC5->C5_YTPBLQ) == "C" .and. lFat

			//Efetua a libera็ใo do pedido e envia para analise de credito
			U_PZCVP010(SC5->C5_NUM, 1, .T.)

			RecLock("SC5",.F.)
			SC5->C5_BLQ		:= ""
			SC5->C5_YTPBLQ 	:= "OK"
			SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
			SC5->C5_YOBSR	:= ""   
			SC5->(MsUnLock())

		ElseIf Alltrim(SC5->C5_XBLQFIN) == "B" .and. lFin
		
			RecLock("SC5",.F.)
			SC5->C5_XBLQFIN := "L"

			If Empty(Alltrim(SC5->C5_BLQ))
				SC5->C5_YTPBLQ 	:= "OK"
				SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
			EndIf

			SC5->(MsUnLock())

		ElseIf AllTrim(SC5->C5_XBLQMRG) == 'S' .and. lMar
			SC5->(RecLock("SC5",.F.))
			SC5->C5_XBLQMRG := "L"
			SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
			SC5->(MsUnLock())

		// ElseIf AllTrim(SC5->C5_XBLQMIN) == 'S' .and. lPMi
		// 	SC5->(RecLock("SC5",.F.))
		// 	SC5->C5_XBLQMIN := "L"
		// 	SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
		// 	SC5->(MsUnLock())

		// Else
			//Efetua a libera็ใo do pedido e verifica se existe boqueio de credito. Se existir bloquei o pedido ficarแ bloqueado por credito.
			// If U_PZCVP010(SC5->C5_NUM)
			// 	RecLock("SC5",.F.)
			// 	SC5->C5_BLQ		:= ""
			// 	SC5->C5_YTPBLQ 	:= "OK"
			// 	SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
			// 	SC5->C5_YOBSR	:= ""   
			// 	SC5->(MsUnLock())

			// EndIf

		EndIf 


	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZCV6REP บAutor  ณMicrosiga 	          บ Data ณ 04/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReprova็ใo												  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCV6REP()

	Local aArea		:= GetArea()
	Local cObs		:= ""
	Local cMailRep	:= U_MyNewSX6("CV_MAILRPV", "",;
	"C","E-mail do destinatario para informa็ใo de pedido reprovado", "", "", .F. )
	Local cAssunto	:= "Pedido Reprovado - "+SC5->C5_NUM
	Local cMensagem	:= "Segue as observa็๕es da reprova็ใo: "+CRLF+CRLF
	Local cMsgErr	:= ""

	If Aviso("Aten็ใo","Confirma a reprova็ใo do pedido "+SC5->C5_NUM+" ?",{"Sim","Nใo"})==1

		cObs := GetObsRec()

		If !Empty(cObs)
			RecLock("SC5",.F.)
			SC5->C5_YTPBLQ 	:= "R"
			SC5->C5_LGLIBCO	:= "Reprovado: "+Alltrim(cUserName)+" Data: "+DTOC(MsDate())+" - "+Time()
			SC5->C5_YOBSR	:= cObs  
			SC5->(MsUnLock())

			EnvMail(cMailRep,cAssunto,GetHtmMsg(cMensagem+"<br><br>"+cObs),"", "", @cMsgErr) 
		EndIf
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetObsRec	บAutor  ณMicrosiga		     บ Data ณ  18/01/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a observa็ใo da recusa						      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetObsRec()

	Local aArea := GetArea()
	Local cRet	:= ""
	Local oDlg 
	Local oWin01
	Local oFWLayer 
	Local oButSair
	Local oButOk
	Local oTMulget

	//Montagem da tela
	DEFINE DIALOG oDlg TITLE "Observa็ใo da recusa" SIZE 400,400 PIXEL STYLE nOr(WS_VISIBLE,WS_OVERLAPPEDWINDOW)

	//Cria instancia do fwlayer
	oFWLayer := FWLayer():New()

	//Inicializa componente passa a Dialog criada,o segundo parametro ้ para 
	//cria็ใo de um botao de fechar utilizado para Dlg sem cabe็alho 		  
	oFWLayer:Init( oDlg, .T. )

	// Efetua a montagem das colunas das telas
	oFWLayer:AddCollumn( "Col01", 100, .T. )


	// Cria tela passando, nome da coluna onde sera criada, nome da window			 	
	// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,	
	// se ้ redimensionada em caso de minimizar outras janelas e a a็ใo no click do split 	
	oFWLayer:AddWindow( "Col01", "Win01", "Observa็ใo", 100, .F., .T., ,,) 
	oWin01 := oFWLayer:getWinPanel('Col01','Win01')

	oTMulget := TMultiGet():New( 005,005, {|u| if( Pcount()>0, cRet:= u, cRet) },;
	oWin01,183,oWin01:nClientHeight - (oWin01:nClientHeight * 56.45)/100 ,;
	,.T.,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,.T.)  


	oButOk		:= TButton():New( 153, 125, "Continuar",oWin01,{ || IIf(Empty(cRet),Aviso("Campo obrigat๓rio","Campo obrigat๓rio nใo preenchido",{"Ok"},1),oDlg:End()) }, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	oButSair		:= TButton():New( 153, 160, "Sair",oWin01,{ ||cRet := "", oDlg:End() }, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE DIALOG oDlg CENTERED

	//Verifica se a justificativa foi preenchida para gravar os dados do usuแrio, data e hora de cancelamento
	If !Empty(cRet)
		cRet := cRet +CRLF+CRLF+"Usuแrio: "+UsrFullName( RetCodUsr())+CRLF+"Data: "+DTOC(MsDate())+CRLF+"Hora: "+Time()
	EndIf

	RestArea(aArea)
Return cRet  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail  บAutor  ณMicrosiga	          บ Data ณ  25/03/2017บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 	                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail(cEmailTo,cAssunto,cMensagem,cEmailCc, cAnexos, cMsgErr)

	Local aArea 		:= GetArea()
	Local cServer   	:= Alltrim(Separa(GetMV("MV_RELSERV",,""),":")[1])
	Local nPort			:= Val(Separa(GetMV("MV_RELSERV",,""),":")[2])
	Local cAccount		:= Alltrim(GetMV("MV_RELACNT",,""))
	Local cPwd			:= Alltrim(GetMV("MV_RELPSW",,""))
	Local lAutentic		:= GetNewPar("MV_RELAUTH",.F.)
	Local lSSL			:= .T.
	Local lTLS			:= .T.

	Local oServer       := Nil
	Local oMessage		:= Nil 
	Local aAnexos		:= Iif(!Empty(cAnexos), Separa(cAnexos,";"), "")
	Local nX			:= 1
	Local nErro			:= 0

	Default cMsgErr 	:= ""

	//Crio a conexใo com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()

	If lSSL
		oServer:SetUseSSL(lSSL)
	EndIf

	If lTLS
		oServer:SetUseTLS(lTLS)
	EndIf

	oServer:Init( "", cServer, cAccount,cPwd,0,nPort)

	//realizo a conexใo SMTP
	nErro := oServer:SmtpConnect() 
	If nErro != 0  
		cMsgErr := "Falha na conexใo SMTP. "
		Return .F.
	EndIf

	//seto um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		cMsgErr := "Falha ao setar o time out com o servidor. "
		Return .F.
	EndIf

	// Autentica็ใo
	If lAutentic
		If oServer:SMTPAuth ( cAccount,cPwd ) != 0
			cMsgErr := "Falha ao autenticar. "
			Return .F.
		EndIf
	EndIf

	//Apos a conexใo, crio o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpo o objeto
	oMessage:Clear()

	//Populo com os dados de envio
	oMessage:cFrom		:= 	cAccount
	oMessage:cTo		:=	cEmailTo
	oMessage:cSubject	:= 	cAssunto
	oMessage:cBody		:= 	cMensagem
	oMessage:MsgBodyType( "text/html" )

	For nX := 1 To Len(aAnexos)
		If File(aAnexos[nX])

			//Adiciono um attach
			If oMessage:AttachFile( aAnexos[nX] ) < 0
				cMsgErr := "Erro ao anexar o arquivo. "
				Return .F.
			EndIf
		EndIf     
	Next

	//Envio o e-mail
	If oMessage:Send( oServer ) != 0
		cMsgErr := "Erro ao enviar o e-mail. "
		Return .F.
	EndIf

	//Disconecto do servidor
	If oServer:SmtpDisconnect() != 0
		cMsgErr := "Erro ao disconectar do servidor SMTP. "
		Return .F.
	EndIf

	RestArea(aArea)
Return      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetHtmMsg บAutor  ณMicrosiga 	          บ Data ณ 04/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณHtml da mensagem											  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/            
Static Function GetHtmMsg(cMsg)

	Local aArea		:= GetArea()
	Local cRet		:= ""

	Default cMsg	:= ""

	cRet += "<html>"
	cRet += "	<head>"
	cRet += "	</head>"
	cRet += "	<body>"
	cRet += "		"+StrTran(cMsg,CRLF,"<br>")
	cRet += "	</body>"
	cRet += "</html>" 

	RestArea(aArea)
Return cRet          
