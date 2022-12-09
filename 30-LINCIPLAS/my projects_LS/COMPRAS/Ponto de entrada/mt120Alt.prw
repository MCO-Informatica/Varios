#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

// Programa.: mt120alt()
// Função...: PE antes da alteração do PC. Valida alteração se o pedido for de compra por acerto de consignação
// Autor....: Alexandre Dalpiaz
// Data.....: 17/11/2011

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function mt120Alt()
/////////////////////////
Local _lRet 		:= .T.
Local _aFunc 		:= {'incluir','alterar/copiar','excluir'}
Public _lCopia    	:= (paramixb[1] == 4)
Public _cCompOrig 	:= SC7->C7_USER
Public _cUserLga  	:= SC7->C7_USERLGI
Public _cUserLgi  	:= SC7->C7_USERLGA

Conout("*** La Selva - User Function - MT120ALT - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If paramixb[1] > 2 .and. paramixb[1] < 6
	SY1->(DbSetOrder(3))
	If !(SY1->(DbSeek(xFilial('SY1') + __cUserId,.f.)))
		MsgBox('Você não tem permissão para ' + _aFunc[paramixb[1]-2] + ' Pedidos de Compras','ATENÇÃO!!!','ALERT')
		_lRet := .f.
	EndIf
EndIf

If altera .and. left(SC7->C7_OBS,8) == 'DEV SIMB' .and. _lRet
	If SF2->(DbSeek(xFilial('SF2') + substr(SC7->C7_OBS,10,12),.F.))
		_lRet := MsgBox('Este pedido de compras refere-se à nota fiscal de devolução simbólica nro ' + substr(SC7->C7_OBS,10,9) + ' série ' + substr(SC7->C7_OBS,18,3),'ALTERAR PEDIDO???','YESNO')
	EndIf
EndIf

// VALIDA SE O USUÁRIO TEM PERMISSÃO PARA ALTERAR PEDIDOS DE COMPRAS DE PRODUTOS DOS GRUPOS 0004 E 0006
IF ALTERA .AND. _lRet
	cNumPC 	:= SC7->C7_NUM
	aArea	:= getArea()
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+cNumPC)
	
	WHILE !EOF() .AND. cNumPC == SC7->C7_NUM
		
		cGrupo := GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+SC7->C7_PRODUTO,1)
		
		// VALIDA GRUPOS 0004 E 0006
		IF cGrupo != "0005"
			IF cGrupo $ getmv("MV_GRPREVI") .AND. !__cUserId$getmv("LS_CONSIG1")
				_lRet := .F.
				MsgBox('Você não tem permissão para ' + _aFunc[paramixb[1]-2] + ' Pedidos de Compras','ATENÇÃO!!!','ALERT')
				//RETURN(.F.)
			ENDIF
		ENDIF
		/*
		// VALIDA GRUPOS 0003
		IF cGrupo $ getmv("") .AND. !__cUserId$getmv("LS_CONSIG2")
		//lRet := .F.
		RETURN(.F.)
		ENDIF
		*/
		dbSelectArea("SC7")
		dbSkip()
	ENDDO
	
	RestArea(aArea)

ENDIF

Return(_lRet)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function mta120E()
///////////////////////
Local _lRet 		:= .t.
Public _lCopia    	:= (paramixb[1] == 4)
Public _cCompOrig 	:= SC7->C7_USER
Public _cUserLga  	:= SC7->C7_USERLGI
Public _cUserLgi  	:= SC7->C7_USERLGA

Conout("*** La Selva - User Function MTA120E - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If paramixb[1] > 2 .and. paramixb[1] < 6
	SY1->(DbSetOrder(3))
	If !(SY1->(DbSeek(xFilial('SY1') + __cUserId,.f.)))
		MsgBox('Você não tem permissão para ' + _aFunc[paramixb[1]-2] + ' Pedidos de Compras','ATENÇÃO!!!','ALERT')
		_lRet := .f.
	EndIf
EndIf

If left(SC7->C7_OBS,8) == 'DEV SIMB'
	If SF2->(DbSeek(xFilial('SF2') + substr(SC7->C7_OBS,10,12),.F.))
		_lRet := MsgBox('Este pedido de compras refere-se à nota fiscal de devolução simbólica nro ' + substr(SC7->C7_OBS,10,9) + ' série ' + substr(SC7->C7_OBS,18,3),'EXCLUIR PEDIDO???','YESNO')
	EndIf
EndIf
Return(_lRet)
