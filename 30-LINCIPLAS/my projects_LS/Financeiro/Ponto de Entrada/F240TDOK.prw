// PE utilizado para validar se a numera��o do border� ja foi utilizada ou n�o
// se ela j� foi utilizada, gera uma nova numera�a�o para que o border� n�o seja perdido
// Thiago Queiroz - 03/01/2013
User Function F240TDOK()

Local peAliasSE2 	:= paramixb[2]
Local lRetorno		:= .T.
Local lMudou		:= .F.
Local lLoop			:= .T.
Local cNumAnt		:= cNumBor

//ALERT("TESTE")

//verifica se esta na memoria sendo usado, busca o proximo numero disponivel
//cNumBor := Soma1(Pad(GetMV("MV_NUMBORP"),Len(SE2->E2_NUMBOR)),Len(SE2->E2_NUMBOR))
//While !MayIUseCode( "E2_NUMBOR"+xFilial("SE2")+cNumBor)

WHILE lLoop

	_cQuery := ""
	_cQuery += " SELECT COUNT(*) AS UsaBor "
	_cQuery += " FROM " + retSqlName("SE2") + " E2 (NOLOCK) "
	_cQuery += " WHERE E2.D_E_L_E_T_ 	= '' "
	_cQuery += " AND E2_NUMBOR 			= '"+cNumBor+"' "
	//_cQuery += " AND E2_MSFIL 		= '"+cFilAnt+"' "
	
	If Select("BORDERO") > 0
		DbSelectArea("BORDERO")
		DbCloseArea()
	EndIf

	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'BORDERO', .F., .T.)

	// SE O BORDERO J� FOI USADO SOMA MAIS 1
	IF BORDERO->UsaBor > 0
		cNumBor 	:= Soma1(cNumBor)
		lRetorno	:= .T.
		lMudou		:= .T.
	ELSE 
		// SAI DO LOOP
		lLoop 		:= .F.
	ENDIF
EndDo

IF lMUDOU
	MsgInfo("N�mero "+cNumAnt+" j� utilizado, o border� foi gravado com o n�mero : "+cNumBor )
ENDIF

Return lRetorno
