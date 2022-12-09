#Include "Rwmake.ch"
#Include "Ap5mail.ch"
#Include "Tbicode.ch"
#Include "Tbiconn.ch"
#Include "Topconn.ch"


User Function RPMSA01(ucAtend)

Local _aArea := GetArea()
Private lTk271Auto 	:= .T.
Private nFolder 	:= 2
Private cMVPMSPE01 	:= GetMV("MV_PMSPE01")
//MsgInfo(ucAtend)
DbSelectArea("AF8")
dborderNickName("AF8_X_ATEN")
If DbSeek(xFilial("AF8")+ucAtend)
	
	DbSelectArea("SUA")
	DbSetOrder(1)
	If DbSeek(AF8->AF8_XATFIL+AF8->AF8_X_ATEN)
		
		RecLock("SUA",.F.)
		SUA->UA_X_DORC := Date()
		SUA->UA_X_NORC := AF8->AF8_PROJET
		MsUnlock()
		
	EndIf
	
    dbSelectArea("AEA")
	DbSetOrder(1)
	DbSeek(xFilial("AEA")+AF8->AF8_FASE)
	
	aAttach := {}
	lWorkFlow := .F.
	Copia     := ""
	Mensagem  := "Orçamento Número: " + AF8->AF8_PROJET + Chr(13)+Chr(10)
	Mensagem  += "Número da Obra: " + AF8->AF8_CODOBR + Chr(13)+Chr(10)
	Mensagem  += "Fase: " + AEA->AEA_DESCRI + Chr(13)+Chr(10)
	Mensagem  += "Usuario: " + cUserName + Chr(13)+Chr(10)
	
	ucMail := AEA->AEA_X_MAIL
	If AF8->AF8_FASE $ "02,03,04,05"
		ucOper := SUA->UA_OPERADO //CODIGO DO OPERADOR
		DbSelectArea("SU7") //OPERADORES
		DbSetOrder(1) //U7_FILIAL+U7_COD -> Filial + Codigo
		If DbSeek(xFilial("SU7")+ucOper)
			ucCodUsr := SU7->U7_CODUSU
			ucMail 	 := UsrRetMail(ucCodUsr)
		EndIf
	EndIf
	
	If !Empty(ucMail)
		U_GeraMail(ucMail, "Aviso de Orçamento", Mensagem, aAttach, lWorkFlow, Copia)
	Else
		MsgInfo("Atencao: O usuario "+AllTrim(UsrFullName(ucCodUsr))+" nao tem email cadastrado! Contate o administrador do sistema.")
	EndIf
	
	If AEA->AEA_COD == cMVPMSPE01
		l380 := .F.
		If Empty(SUA->UA_CODCONT)
			ALERT("Atendimento sem contato, não será gravado na agenda do operador")
		Else
			TKGrvSU4(SUA->UA_CODCONT,"SA1"	,SUA->UA_CLIENTE+SUA->UA_LOJA,SUA->UA_OPERADO,;
			"2"		,SUA->UA_NUM	,Date()	,SubStr(Time(),1,5),	l380)
		EndIf
	EndIf
	
EndIf

dbSelectArea("ZA2")
//DbSetOrder(1)
//DbSeek(xFilial("ZA2")+AF8->AF8_PROJET)
//If ZA2->ZA2_FASE <> AF8->AF8_FASE
RecLock("ZA2",.T.)
ZA2->ZA2_PROJET := AF8->AF8_PROJET
ZA2->ZA2_FASE   := AF8->AF8_FASE
ZA2->ZA2_DATA   := dDataBase
ZA2->ZA2_HORA   := SubStr(Time(),1,5)
ZA2->ZA2_USUARI := SubStr(cUsuario,7,15)
MsUnlock()
//EndIf

RestArea(_aArea)

Return()
