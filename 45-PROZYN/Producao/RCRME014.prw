#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  11/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RCRME014()

Local _cCodOp  := M->AD1_PROSPE
Local _cOport  := M->AD1_NROPOR
Local _cRevis  := M->AD1_REVISA
Local _cEstag  := M->AD1_STAGE
Local _cTipo   := M->AD1_TIPO
Local _cProce  := "000001"
Local _cDtini  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_DTCAD") 
Local _cHrini  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_HRCAD") 
Local _cDtenc  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_DTENCE") 
Local _cHrenc  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_HRENCE") 
Local _Deciso  := M->AD1_DECI
Local _cInflu  := M->AD1_INFLU
Local _cUsuar  := M->AD1_USUA
Local _cDescr  := M->AD1_DESC
Local _cAmost  := M->AD1_AMOST
Local _cConc1  := M->AD1_CONCL1
Local _cAprov  := M->AD1_APROV
Local _cQuant  := M->AD1_QTDAV
Local _cConc3  := M->AD1_CONCL3
Local _cTestI  := M->AD1_TINDUS
Local _cFtec   := M->AD1_FTEC
Local _cFseg   := M->AD1_FSEG
Local _cNecdc  := M->AD1_DOCS
Local _cSegme  := M->AD1_SEGMEN
Local _cAplic  := M->AD1_APLIC
Local _cQtmp   := M->AD1_QTMP
Local _cDescn  := M->AD1_DESCNC
Local _cCusto  := M->AD1_CUSTOF
Local _cMelhor := M->AD1_MLPROC
Local _cRendim := M->AD1_AUMREB
Local _cQuali  := M->AD1_MLQUAL
Local _cInova  := M->AD1_INOV
Local _cNeces  := M->AD1_NECTEC
Local _cQtusa  := M->AD1_QTUSA
Local _cQtpag  := M->AD1_QTPG
Local _cTotano := M->AD1_TOTANO
Local _cConcor := M->AD1_CONC
Local _cNomcon := M->AD1_NCONC
Local _cProdco := M->AD1_PRODC
Local _cOqusa  := M->AD1_OQUSA
Local _cMpproc := M->AD1_MPPROC
Local _cDescpr := M->AD1_DESCP
Local _cCodpro := M->AD1_CODPRO
Local _cTeste  := M->AD1_TESTE
Local _cResult := M->AD1_RESULT
Local _cAceite := M->AD1_DTASSI

//ESTAGIO 4
If _cTipo == "1" .AND. !Empty(_Deciso) .AND. !Empty(_cInflu) .AND. !Empty(_cUsuar) .AND. !Empty(_cDescr) .AND. AD1_STAG04 = .F.
	_cPerc := M->AD1_PERC
	reclock ("AD1",.F.)
	AD1->AD1_PERC   := _cPerc + 20
	AD1->AD1_STAG04 := .T.
	AD1->(MsUnlock())
EndIf

//ESTAGIO 5
If !Empty(_cSegme) .AND. !Empty(_cAplic) .AND. !Empty(_cQtmp) .AND. !Empty(_cDescn) .AND. !Empty(_cMpproc) .AND. !Empty(_cDescpr);
                       .AND. (_cCusto = .T. .OR. _cMelhor = .T. .OR. _cRendim = .T. .OR. _cQuali = .T. .OR. _cInova = .T.) .AND.;
                       (_cNeces = .T. .OR. (!Empty(_cQtusa) .AND. !Empty(_cQtpag) .AND. !Empty(_cTotano) .AND. !Empty(_cConcor);
                                                            .AND. !Empty(_cNomcon) .AND. !Empty(_cProdco) .AND. !Empty(_cOqusa))) .AND. AD1_STAG05 = .F.
	_cPerc := M->AD1_PERC
	reclock ("AD1",.F.)
	AD1->AD1_PERC := _cPerc + 15
	AD1->AD1_STAG05 := .T.
	AD1->(MsUnlock())
EndIf
   
//ESTAGIO 6
If !Empty(_cCodpro) .AND. !Empty(_cTeste) .AND. !Empty(_cResult) .AND. AD1_STAG06 = .F.
	_cPerc := M->AD1_PERC
	reclock ("AD1",.F.)
	AD1->AD1_PERC := _cPerc + 5
	AD1->AD1_STAG06 := .T.
	AD1->(MsUnlock())
EndIf

//ESTAGIO 7
If ((!Empty(_cAmost) .AND. !Empty(_cAprov)) .OR. _cConc1 = "3") .AND. AD1_STAG07 = .F.
	_cPerc := M->AD1_PERC
	reclock ("AD1",.F.)
	AD1->AD1_PERC := _cPerc + 5
	AD1->AD1_STAG07 := .T.
	AD1->(MsUnlock())
EndIf
 
//ESTAGIO 8
If ((!Empty(_cQuant) .AND. !Empty(_cTestI)) .OR. _cConc3 = "3") .AND. AD1_STAG08 = .F.
	_cPerc := M->AD1_PERC
	reclock ("AD1",.F.)
	AD1->AD1_PERC := _cPerc + 5
	AD1->AD1_STAG08 := .T.
	AD1->(MsUnlock())
EndIf

//ESTAGIO 9
If ((_cFtec = .T. .AND. _cFseg = .T.) .OR. _cNecdc = .T.) .AND. AD1_STAG09 = .F.
	_cPerc := M->AD1_PERC
	reclock ("AD1",.F.)
	AD1->AD1_PERC := _cPerc + 5
	AD1->AD1_STAG09 := .T.
	AD1->(MsUnlock())
EndIf

//ESTAGIO 11
If !Empty(_cAceite)  .AND. AD1_STAG11 = .F.
	_cPerc := M->AD1_PERC
	reclock ("AD1",.F.)
	AD1->AD1_PERC := _cPerc + 10
	AD1->AD1_STAG11 := .T.
	AD1->(MsUnlock())
EndIf
                                                               
Return