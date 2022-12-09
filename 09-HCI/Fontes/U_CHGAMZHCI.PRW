#INCLUDE 'PROTHEUS.CH'

USER FUNCTION ChgAmzHCI()

	Local cNumPedido 	:= AllTrim(SC7->C7_NUM)
	Local cOrigemPedido	:= AllTrim(SC7->C7_ORIGEM)
	Local cMensagemUsu	:= "Caro usuario, vc deseja alterar o armazem padrao, referente ao pedido de compra ->" + AllTrim(SC7->C7_NUM) + " ?"
	Local cMensagemNeg	:= "Caro usuario, o pedido de compra ->" + AllTrim(SC7->C7_NUM) + "nao foi originado pelo SIGAEIC, favor realizar o processo padrão!!!"
	Local lRet			:= .F.
	
	IF Alltrim(cOrigemPedido) == "EICPO400"
		IF MsgYesNo(cMensagemUsu,"Atenção","YESNO") .AND. Alltrim(cOrigemPedido) == "EICPO400"
			__AlteraAmz()         
			lRet := .T.
		EndIF
	ELSE	                   
		MsgInfo(cMensagemNeg)
		lRet := .F.			
	EndIF		

Return

STATIC FUNCTION __AlteraAmz()

	Private _cNPed	:= AllTrim(SC7->C7_NUM)
	Private _cOrPed	:= AllTrim(SC7->C7_ORIGEM)
	Private _cHciLoc:= ""
	
	Private oDlg  
	
	_cHciLoc := (CriaVar("C7_LOCAL",.F.),SC7->C7_LOCAL)
	
	Define MsDialog oDlg Title "Alteração Amz HCI - EIC" From 000,000 To 200, 200 PIXEL
	
	@ 005,005 SAY "Pedido" Size 052,007 Of oDlg Colors 0,16777215 PIXEL
	@ 003,035 MSGET oNPed VAR _cNPed Size 030,010 Of oDlg Colors 0,16777215 PIXEL
	
	@ 020,005 SAY "Armazem" Size 052,007 Of oDlg Colors 0,16777215 PIXEL
	@ 018,035 MSGET oHciLoc VAR _cHciLoc Size 030,010 Of oDlg Colors 0,16777215 PIXEL F3 "NNR"
	
	@ 035,005 Button "Sair" Size 030, 012 PIXEL OF oDlg Action(oDlg:End())
	@ 050,005 Button "Alterar" Size 030, 012 PIXEL OF oDlg Action(__AltHCIAmz(),oDlg:End())

	ACTIVATE MsDialog oDlg Centered

Return(.T.)		                                                                                      

STATIC FUNCTION __AltHCIAmz()

	DbSelectArea("SC7")   
	dbSetOrder(1)
	
	IF MsSeek(xFilial("SC7")+Alltrim(_cNPed))
		Do While !Eof() .AND. C7_FILIAL == xFilial("SC7") .AND. C7_NUM == _cNPed
		RecLock("SC7",.F.)
		SC7->C7_LOCAL	:= 	_cHciLoc
		MsUnlock()  
		SC7->(dbSkip())
		EndDo
	EndIF		
Return		