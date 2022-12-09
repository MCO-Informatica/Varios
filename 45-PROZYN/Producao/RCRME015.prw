#Include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO6     ºAutor  ³Microsiga           º Data ³  12/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCRME015()

Local _cNome   := M->US_NREDUZ
Local _cOport  := M->US_OPORTUN
Local _cUsdano := M->US_USDANO
Local _cStatus := M->US_COMENT
Local _cBarre  := M->US_BARRE
Local _cAcoes  := M->US_ACOES
Local _cPorte  := M->US_PORTE
Local _cProd   := M->US_PRODPZ
Local _cMun    := M->US_COD_MUN
Local _cEst	   := M->US_EST
Local _cDtenc  := M->US_DTENCE 
Local _cHrenc  := M->US_HRENCE
Local _cDini   := M->US_DTCAD
Local _cHini   := M->US_HRCAD
Local _cProj   := M->US_CODPROJ

If Inclui .Or. Altera   
	DbSelectArea("AIJ")
	If !dbSeek(xFilial("AIJ") + _cProj + "01" + "000001" + "000001")
		reclock ("AIJ",.T.)
		AIJ->AIJ_NROPOR := M->US_CODPROJ//OPORTUNIDADE
		AIJ->AIJ_REVISA := "01"         //REVISAO
		AIJ->AIJ_PROVEN := "000001"     //PROCESSO DE VENDA
		AIJ->AIJ_STAGE  := "000001"     //ESTAGIO
		AIJ->AIJ_DTINIC := _cDini
	 	AIJ->AIJ_HRINIC := _cHini
		AIJ->(MsUnlock())
	EndIf
	
	If !Empty(_cNome) .OR. !Empty(_cOport) .OR. !Empty(_cUsdano) .OR. !Empty(_cStatus) .OR. !Empty(_cBarre) .OR. ;
	   !Empty(_cAcoes) .OR. !Empty(_cPorte) .OR. !Empty(_cProd) .OR. !Empty(_cMun) .OR. !Empty(_cEst)
	
		DbSelectArea("AIJ")
		If dbSeek(xFilial("AIJ") + _cProj + "01" + "000001" + "000001")
		reclock ("AIJ",.F.)
		AIJ->AIJ_DTENCE := _cDtenc
		AIJ->AIJ_HRENCE := _cHrenc
		AIJ->(MsUnlock())
		EndIf
		
		DbSelectArea("AIJ")
		If !dbSeek(xFilial("AIJ") + _cProj + "01" + "000001" + "000002")
		reclock ("AIJ",.T.)
		reclock ("AIJ",.T.)
		AIJ->AIJ_NROPOR := _cProj       //OPORTUNIDADE
		AIJ->AIJ_REVISA := "01"         //REVISAO
		AIJ->AIJ_PROVEN := "000001"     //PROCESSO DE VENDA
		AIJ->AIJ_STAGE  := "000002"     //ESTAGIO
		AIJ->AIJ_DTINIC := _cDtenc
	 	AIJ->AIJ_HRINIC := _cHrenc
		AIJ->(MsUnlock())
		EndIf
	EndIf
	
	If !Empty(_cNome) .AND. !Empty(_cOport) .AND. !Empty(_cUsdano) .AND. !Empty(_cStatus) .AND. !Empty(_cBarre) .AND. ;
	   !Empty(_cAcoes) .AND. !Empty(_cPorte) .AND. !Empty(_cProd) .AND. !Empty(_cMun) .AND. !Empty(_cEst) .AND. Empty(_cDtenc)
	
		DbSelectArea("AIJ")
		If dbSeek(xFilial("AIJ") + _cProj + "01" + "000001" + "000002")
		reclock ("AIJ",.F.)
		AIJ->AIJ_DTENCE := Date()
		AIJ->AIJ_HRENCE := Substr(time(),1,5)
		AIJ->(MsUnlock())
		EndIf
	EndIf
EndIf
	
Return()