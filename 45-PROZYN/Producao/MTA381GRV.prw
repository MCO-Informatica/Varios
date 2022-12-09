#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ MT380ALT ³ Autor ³ Newbridge			  ³ Data ³ 09/08/2019 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste das ordens de separação após alteraçao de lote      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MTA381GRV()

// Local ExpL1:= PARAMIXB[1]
// Local ExpL2:= PARAMIXB[2]
// Local ExpL3:= PARAMIXB[3]

Local _aSavArea := GetArea()
Local _aSavSC2	:= SC2->(GetArea())
// Local _cRotina	:= "MTA381GRV"

//----------------- Força o preenchimento do campo C2_BATCH para não excluir a OP quando o empenho for incluído manualmente.
dbSelectArea("SC2")
dbSetOrder(1)
If SC2->(dbSeek(xFilial("SC2")+SD4->D4_OP))
	RecLock("SC2",.F.)
	SC2->C2_BATCH := "S"
	SC2->(MsUnLock())
Endif

RestArea(_aSavSC2)
RestArea(_aSavArea)


/*IF L381ALT .And. IsOrdSep(SD4->D4_OP) .and. !Upper(GetEnvServer()) $ 'PROZYN_HM.MELIORAPP'
   Aviso("Atenção","As ordens de separação serão ajustadas em caso de alteração do empenho.",{"Ok"},2)
   MsgRun( "Aguarde...",, { || U_PZCVACD1(SD4->D4_OP) } )
Endif*/

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³IsOrdSep		ºAutor  ³Microsiga	     º Data ³  17/02/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se existe ordem de separação						  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
// Static Function IsOrdSep(cOp)

// 	Local aArea		:= GetArea()
// 	Local lRet		:= .F.
// 	Local cQuery	:= ""
// 	Local cArqTmp	:= GetNextAlias()

// 	Default cOp := ""

// 	cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("CB7")+" CB7 "+CRLF
// 	cQuery	+= " 	WHERE CB7.CB7_FILIAL = '"+xFilial("CB7")+"' " +CRLF
// 	cQuery	+= " 	AND CB7.CB7_OP = '"+cOp+"' "+CRLF
// 	cQuery	+= " 	AND CB7.D_E_L_E_T_ = ' ' "+CRLF

// 	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

// 	If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR>0
// 		lRet	:= .T.
// 	EndIf

// 	If Select(cArqTmp) > 0
// 		(cArqTmp)->(DbCloseArea())
// 	EndIf

// 	RestArea(aArea)
// Return lRet
