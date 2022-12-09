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


User Function RCRME009()

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


DbSelectArea("AIJ")
dbSetOrder(1) //Oportunidade + Revisão + Processo de Venda + Estagio
If dbSeek(xFilial("AIJ") + _cOport + _cRevis + _cProce + _cEstag1)
	reclock ("AIJ",.F.)
	AIJ->AIJ_DTINIC := _cDtini
 	AIJ->AIJ_HRINIC := _cHrini
	AIJ->AIJ_DTENCE := _cDtenc
	AIJ->AIJ_HRENCE := _cHrenc
	AIJ->(MsUnlock())
EndIf

DbSelectArea("AIJ")
dbSetOrder(1) //Oportunidade + Revisão + Processo de Venda + Estagio
If dbSeek(xFilial("AIJ") + _cOport + _cRevis + _cProce + _cEstag2)
	reclock ("AIJ",.F.)
	AIJ->AIJ_DTINIC := _cDtenc
 	AIJ->AIJ_HRINIC := _cHrenc
	AIJ->AIJ_DTENCE := Date()
	AIJ->AIJ_HRENCE := Substr(Time(),1,5)
	AIJ->(MsUnlock())
EndIf

DbSelectArea("AIJ")
dbSetOrder(1) //Oportunidade + Revisão + Processo de Venda + Estagio
If dbSeek(xFilial("AIJ") + _cOport + _cRevis + _cProce + "000004")
	If _cEstag == "000004" .AND. _cTipo == "1" .AND. !Empty(_Deciso) .AND. !Empty(_cInflu) .AND. !Empty(_cUsuar) .AND. !Empty(_cDescr)
		reclock ("AIJ",.F.)
		AIJ->AIJ_DTINIC := M->AD1_DTINI4
	 	AIJ->AIJ_HRINIC := M->AD1_HRINI4
		AIJ->AIJ_DTENCE := M->AD1_DTFIM4
		AIJ->AIJ_HRENCE := M->AD1_HRFIM4
		AIJ->(MsUnlock())
	EndIf
EndIf    

DbSelectArea("AIJ")
dbSetOrder(1) //Oportunidade + Revisão + Processo de Venda + Estagio
If dbSeek(xFilial("AIJ") + _cOport + _cRevis + _cProce + "000005")
	If _cEstag == "000005" .AND. !Empty(_cSegme) .AND. !Empty(_cAplic) .AND. !Empty(_cQtmp) .AND. !Empty(_cDescn) .AND. !Empty(_cMpproc) .AND. !Empty(_cDescpr);
	                       .AND. (_cCusto = .T. .OR. _cMelhor = .T. .OR. _cRendim = .T. .OR. _cQuali = .T. .OR. _cInova = .T.) .AND.;
	                       (_cNeces = .T. .OR. (!Empty(_cQtusa) .AND. !Empty(_cQtpag) .AND. !Empty(_cTotano) .AND. !Empty(_cConcor);
	                                                            .AND. !Empty(_cNomcon) .AND. !Empty(_cProdco) .AND. !Empty(_cOqusa)))
		reclock ("AIJ",.F.)
		AIJ->AIJ_DTINIC := M->AD1_DTINI5
	 	AIJ->AIJ_HRINIC := M->AD1_HRINI5
		AIJ->AIJ_DTENCE := M->AD1_DTFIM5
		AIJ->AIJ_HRENCE := M->AD1_HRFIM5
		AIJ->(MsUnlock())
	EndIf
EndIf

DbSelectArea("AIJ")
dbSetOrder(1) //Oportunidade + Revisão + Processo de Venda + Estagio
If dbSeek(xFilial("AIJ") + _cOport + _cRevis + _cProce + "000006")
	If _cEstag == "000006" .AND. !Empty(_cCodpro) .AND. !Empty(_cTeste) .AND. !Empty(_cResult)
		reclock ("AIJ",.F.)
		AIJ->AIJ_DTINIC := M->AD1_DTINI6
	 	AIJ->AIJ_HRINIC := M->AD1_HRINI6
		AIJ->AIJ_DTENCE := M->AD1_DTFIM6
		AIJ->AIJ_HRENCE := M->AD1_HRFIM6
		AIJ->(MsUnlock())
	EndIf
EndIf
 
Return