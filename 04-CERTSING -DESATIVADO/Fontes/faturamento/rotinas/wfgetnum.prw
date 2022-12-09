#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"

/*/{Protheus.doc} wfgetnum
Ponto de entrada para controle de ID de mensagem de WF
@author david.oliveira
@since 18/05/2015
@version 1.0
@return ${uRet}, ${retorno do id de WF}
/*/
User Function wfgetnum()
	
	Local aArea		:= GetArea()
	Local uRet
	Local nID 		:= 0
	Local nKey1 	:= 0
	Local nKey2 	:= 0
	Local cSql		:= ""
	Local cUpd		:= ""
	Local cAlias	:= ""
	Local lWhile	:= .T.
	Local cLogPEWF	:= GetNewPar("MV_XWFGTNU", "1")
	Local cSavePoint := ''
	
	DbSelectArea("SZU")
	
	While lWhile

		Sleep( Randomize( 1, 3 ) * 1000 )
		
		cAlias	:= GetNextAlias()
		
		cSql 	:= "SELECT MAX(R_E_C_N_O_) RECZU FROM "+RetSqlName("SZU")
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAlias,.F.,.T.)
		
		nRecZU := (cAlias)->RECZU+1
		
		(cAlias)->(DbCloseArea())
		
		nKey1 := Date() - Ctod( '27/12/1987' )
		nKey2 := Int( Seconds() )
		nID   := Val( Str( nKey1, 5, 0 ) + Str( nKey2, 5, 0 ) )
		cSavePoint := 'SP'+LTrim(Str(nID))
		
		SZU->(DbCommit())
		
		//+---------------------------------------------------------+
		//| Instrução para incluir o registro na tabela.            |
		//| O registro da tabela deve ser único e aqui fizemos a    |
		//| tratativa para erro e rollback somente nesta instrução, |
		//| pois antes dava rollback em todas as outras rotinas     |
		//| que a chamava.                                          |
		//+---------------------------------------------------------+
		cUpd := "BEGIN "
		cUpd += "    BEGIN "
		cUpd += "        SAVEPOINT "+cSavePoint+"; "
		cUpd += "        INSERT INTO "+RetSqlName("SZU")+" "
		cUpd += "                    (ZU_FILIAL, "
		cUpd += "                     ZU_ID, "
		cUpd += "                     ZU_KEY1, "
		cUpd += "                     ZU_KEY2, "
		cUpd += "                     ZU_DTID, "
		cUpd += "                     R_E_C_N_O_) "
		cUpd += "        VALUES      ("+ValToSql(xFilial("SZU"))+", "
		cUpd += "                     "+Str(nID)+", "
		cUpd += "                     "+Str(nKey1)+", "
		cUpd += "                     "+Str(nKey2)+", "
		cUpd += "                     "+ValToSql(Dtos(Date()))+", "
		cUpd += "                     "+Str(nRecZU)+"); "
		cUpd += "        COMMIT; "
		cUpd += "    EXCEPTION "
		cUpd += "        WHEN DUP_VAL_ON_INDEX THEN "
		cUpd += "          ROLLBACK TO "+cSavePoint+"; "
		cUpd += "          RAISE_APPLICATION_ERROR(-20001, 'An error was encountered - ' "
		cUpd += "                                          ||SQLCODE "
		cUpd += "                                          ||' -ERROR- ' "
		cUpd += "                                          ||SQLERRM); "
		cUpd += "        WHEN OTHERS THEN "
		cUpd += "          ROLLBACK TO "+cSavePoint+"; "
		cUpd += "          RAISE_APPLICATION_ERROR(-20002, 'An error was encountered - ' "
		cUpd += "                                          ||SQLCODE "
		cUpd += "                                          ||' -ERROR- ' "
		cUpd += "                                          ||SQLERRM); "
		cUpd += "    END; "
		cUpd += "END; "
		
		nUpd := TcSqlExec( cUpd )
		
		If nUpd < 0
			lWhile := .T.
			If cLogPEWF = "1"
				cLog := TcSqlError()
				Conout("[WFGETNUM] - ["+DtoC(Date())+"] - ["+Time()+"] - Inconsistencia para ID "+Alltrim(Str(nID))+" Msg: "+cLog)
			EndIf
		Else
			lWhile := .F.
			If cLogPEWF = "1"
				Conout("[WFGETNUM] - ["+DtoC(Date())+"] - ["+Time()+"] - Realizado com Sucesso para ID "+Alltrim(Str(nID)))
			EndIf
		EndIf
		
	EndDo
	
	uRet := nID
	
	RestArea(aArea)	
Return( uRet )