#Include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  11/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para alteração das datas no cadastro de projeto com  º±±
±±º          ³as datas e horarios de inclusão e qualificação da oport.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RCRME011()

Local _cCodOp  := M->AD1_PROSPE
Local _cOport  := M->AD1_NROPOR
Local _cRevis  := M->AD1_REVISA
Local _cEstag  := M->AD1_STAGE
Local _cTipo   := M->AD1_TIPO
Local _cProce  := "000001"
Local _cEstag1 := "000001"
Local _cEstag2 := "000002"
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

If _cEstag == "000004" .AND. _cTipo == "1" .OR. (!Empty(_Deciso) .OR. !Empty(_cInflu) .OR. !Empty(_cUsuar) .OR. !Empty(_cDescr)) .AND. Empty(M->AD1_DTINI4) .AND. Empty(M->AD1_HRINI4)
	reclock ("AD1",.F.)
	AD1->AD1_DTINI4 := Date()
 	AD1->AD1_HRINI4 := Substr(Time(),1,5)
	AD1->(MsUnlock())
EndIf
If _cEstag == "000004" .AND. _cTipo == "1" .AND. !Empty(_Deciso) .AND. !Empty(_cInflu) .AND. !Empty(_cUsuar) .AND. !Empty(_cDescr) .AND. Empty(M->AD1_DTFIM4) .AND. Empty(M->AD1_HRFIM4)
	reclock ("AD1",.F.)
	AD1->AD1_DTFIM4 := Date()
	AD1->AD1_HRFIM4 := Substr(Time(),1,5)
	AD1->(MsUnlock())
EndIf

If _cEstag == "000005" .AND. Empty(M->AD1_DTINI5) .AND. Empty(M->AD1_HRINI5)
	reclock ("AD1",.F.)
	AD1->AD1_DTINI5 := M->AD1_DTFIM4
 	AD1->AD1_HRINI5 := M->AD1_HRFIM4
 	AD1->(MsUnlock())
EndIf

If _cEstag == "000005" .AND. !Empty(_cSegme) .AND. !Empty(_cAplic) .AND. !Empty(_cQtmp) .AND. !Empty(_cDescn) .AND. !Empty(_cMpproc) .AND. !Empty(_cDescpr);
                       .AND. (_cCusto = .T. .OR. _cMelhor = .T. .OR. _cRendim = .T. .OR. _cQuali = .T. .OR. _cInova = .T.);
                       .AND. (_cNeces = .T. .OR. (!Empty(_cQtusa) .AND. !Empty(_cQtpag) .AND. !Empty(_cTotano) .AND. !Empty(_cConcor);
                       .AND. !Empty(_cNomcon) .AND. !Empty(_cProdco) .AND. !Empty(_cOqusa))) .AND. Empty(M->AD1_DTFIM5) .AND. Empty(M->AD1_HRFIM5)
	reclock ("AD1",.F.)
	AD1->AD1_DTFIM5 := Date()
	AD1->AD1_HRFIM5 := Substr(Time(),1,5)
 	AD1->(MsUnlock())
EndIf

If _cEstag == "000006" .AND. Empty(M->AD1_DTINI6) .AND. Empty(M->AD1_HRINI6)
	reclock ("AD1",.F.)
	AD1->AD1_DTINI6 := M->AD1_DTFIM5
 	AD1->AD1_HRINI6 := M->AD1_HRFIM5
  	AD1->(MsUnlock())
EndIf 

If _cEstag == "000006" .AND. !Empty(_cCodpro) .AND. !Empty(_cTeste) .AND. !Empty(_cResult) .AND. Empty(M->AD1_DTFIM6) .AND. Empty(M->AD1_HRFIM6)
	reclock ("AD1",.F.)
	AD1->AD1_DTFIM6 := Date()
	AD1->AD1_HRFIM6 := Substr(Time(),1,5)
  	AD1->(MsUnlock())
EndIf
 
Return