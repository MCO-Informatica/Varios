#Include "Protheus.ch"
#include "rwmake.ch"
#include "ap5mail.ch"

USER FUNCTION ENVBOL()
	Local aFiles 		:= {}
	Local aSizes 		:= {}
	Local aAnexos		:= {}
	Local cNota 		:= ''
	Local nX

	ADir(cDirPDF+"*.pdf", aFiles, aSizes)
	// Exibe dados dos arquivos
	nCount := Len( aFiles )
	For nX := 1 to nCount
		//Valida arquivo
		If file(cDirPDF+aFiles[nX])
			aNota	:= strtokarr (Strtran(aFiles[nX],'.PDF',''), "_")
			If trim(cNota) == ''
				cNota 	:= aNota[3]
				cSerie 	:= aNota[2]
			EndIf

			If cNota != aNota[3] .and. trim(cNota) != ''
				MsgRun("Enviando por e-mail o boleto " + Alltrim(Str(nX)) + " de " + Alltrim(Str(nCount)) + ".","Gera Boletos",{|| enviarBL(cNota,cSerie,aAnexos) })
				aAnexos	:= {}
				cNota 	:= aNota[3]
				cSerie 	:= aNota[2]
			EndIf
			Aadd(aAnexos,cDirPDF+aFiles[nX])
		EndIf
	Next nX
	If nCount > 0
		MsgRun("Enviando por e-mail o boleto " + Alltrim(Str(nCount)) + " de " + Alltrim(Str(nCount)) + ".","Gera Boletos",{|| enviarBL(cNota,cSerie,aAnexos) })
	EndIf
Return

Static Function enviarBL(cNota,cSerie,aAnexos)
	Local cEmailFin		:= SUPERGETMV("PZ_ENVBOL", .T., "cobranca@prozyn.com.br")

	If Select("QrySA1") > 0
		QrySA1->(DbCloseArea())
	Endif

	/////// PREENCHER CAMPO CERTO TO EMAIL
	cQry := "SELECT TOP 1 A1_EMAIL,A1_NOME,C5_NUM FROM "+RetSqlName("SA1")+" SA1 "
	cQry += "INNER JOIN "+RetSqlName("SE1")+" SE1 ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA "
	cQry += "INNER JOIN "+RetSqlName("SC5")+" SC5 ON E1_NUM = C5_NOTA AND E1_SERIE = C5_SERIE "
	cQry += "WHERE E1_NUM = '"+cNota+"' AND E1_PREFIXO = '"+cSerie+"' AND E1_FILIAL = '"+xFilial("SE1")+"' "
	cQry += "AND SE1.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' "

	cQry := ChangeQuery(cQry)

	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"QrySA1",.F.,.T.)

	QrySA1->(DbGotop())

	cNome	:= Alltrim(QrySA1->A1_NOME)
	cPedido	:= Alltrim(QrySA1->C5_NUM)
	
	cCorpo := "<p><font face='Arial' size='3'>Olá " + cNome + ", tudo bem?</font></p>
	cCorpo += "<p><font face='Arial' size='3'>Passando para avisar que estamos cuidando do seu pedido nº <strong>" + cPedido + "</strong>! Para sua comodidade estamos anexando o(s) boleto(s) referente à NF <strong>" + cNota + "</strong>. <br/> <br/> "
	cCorpo += "<p><font face='Arial' size='3'>Em caso de dúvidas, não responda esse e-mail, encaminhe para " + cEmailFin + "</font></p>"
	
	//cDestin := Alltrim(QrySA1->A1_EMAIL)
	//TESTE
	cDestin	:= 'nailson.paixao@prozyn.com.br'

	lEnv := .F.
	nEnv := 0
	While !lEnv .AND. nEnv <= 5
		nEnv++
		lEnv := U_zEnvMail(cDestin, "Prozyn - Boleto NF " + cNota + " ", cCorpo, aAnexos, ,.T.)
	EndDo
RETURN
