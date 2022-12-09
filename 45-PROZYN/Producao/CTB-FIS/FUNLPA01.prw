#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FUNLPA01  ºAutor  ³Luiz Eduardo Fael   º Data ³  02/17/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Conta Debito ou Credito Conforme Tipo de Centro de Custo   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSitaxe    ³ U_LPA01('D') Para Debito e U_LPA01('C') Para Credito       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION LPA01(cTipo)

Local aAreaCTT := CTT->(GetArea())
Local aAreaSRV := SRV->(GetArea())
Local __cConta := ''
Local __cCampo := 'SRV->RV_CONT'+Alltrim(cTipo)
Local __CC	   := SRZ->RZ_CC
Local __Verba  := SRZ->RZ_PD
CTT->(dbSetOrder(1))
SRV->(dbSetOrder(1))
If Alltrim(cTipo) == 'C' .or. Alltrim(cTipo) == 'D'
	If Alltrim(SM0->M0_CODIGO) == '06' .or. Alltrim(SM0->M0_CODIGO) == '12'
		SZ0->(dbSetOrder(1))
		If SZ0->(dbSeek(XFILIAL("SZ0")+__Verba+__CC))
			If cTipo == 'D'
				__cConta := SZ0->Z0_DEB01
			ElseIf cTipo == 'C'
				__cConta := SZ0->Z0_CRED01
			EndIf
		Else
			IW_MSGBOX("Regra "+Chr(13)+chr(10)+'Contabilização','Verba ou Centro de Custo não Cadastrado (SZ0)',"STOP")
			__cConta := ''
		EndIf
	Else
		If CTT->(dbSeek(xFilial("CTT")+__CC))
			If SRV->(dbSeek(xFilial("SRV")+__Verba))
				__cCampo += CTT->CTT_FOLHA
				__cConta := &__cCampo
			Else
				IW_MSGBOX("Cadastro "+Chr(13)+chr(10)+'Verba','Verba não Cadastrada',"STOP")
				__cConta := ''
			EndIf
		Else
			IW_MSGBOX("Cadastro "+Chr(13)+chr(10)+'Centro de Custo','Centro de Custo não Cadastrado',"STOP")
			__cConta := ''
		EndIf
	EndIf
Else
	IW_MSGBOX("Tipo "+Chr(13)+chr(10)+'Não Informado','Informe o tipo de Lançamento (D/C)',"STOP")
	__cConta := ''
EndIf
RestArea(aAreaCTT)
RestArea(aAreaSRV)
Return(__cConta)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LA01HIST  ºAutor  ³Luiz Eduardo Fael   º Data ³  02/21/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna historico                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION LA01HIST()
Local __cDesc := SRZ->RZ_PD +" - "+SUBSTR(MesExtenso(Ddatabase),1,3)+"/"+Str(Year(DdataBase),4)
SRV->(dbSetOrder(1))
If SRV->(dbSeek(xFilial("SRV")+SRZ->RZ_PD))
	__cDesc := SRZ->RZ_PD +" - "+ ALLTRIM(SRV->RV_DESC) +" - "+SUBSTR(MesExtenso(Ddatabase),1,3)+"/"+Str(Year(DdataBase),4)
EndIf
Return(__cDesc)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FUNLPA01  ºAutor  ³Microsiga           º Data ³  02/26/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION LPA01VAL(cTipo)
Local __nValor := 0
If Alltrim(SM0->M0_CODIGO) == '06' .or. Alltrim(SM0->M0_CODIGO) == '12'
	SZ0->(dbSetOrder(1))
	If SZ0->(dbSeek(XFILIAL("SZ0")+SRZ->RZ_PD+SRZ->RZ_CC))
		If cTipo == 'D'
			If !Empty(SZ0->Z0_DEB01) .and. Empty(SZ0->Z0_CRED01)
				__nValor := SRZ->RZ_VAL
			EndIf
		ElseIf cTipo == 'C'
			If !Empty(SZ0->Z0_CRED01) .and. Empty(SZ0->Z0_DEB01)
				__nValor := SRZ->RZ_VAL
			EndIf
		ElseIf cTipo == 'X'
			If !Empty(SZ0->Z0_CRED01) .and. !Empty(SZ0->Z0_DEB01)
				__nValor := SRZ->RZ_VAL
			EndIf
		EndIf
	EndIf
EndIf
Return(__nValor)