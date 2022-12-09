#Include "Protheus.ch"

User Function AFATCLI()
	Local lMsg := .F.
	Private cMsg := ""

	IF !IsInCallStack("U_IMPQUOTE")
////oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "AFatCli" , __cUserID )

		IF ReadVar()  $ "M->CJ_CLIENTE|M->CJ_LOJA|"
			If Empty(M->CJ_CLIENTE) .OR. Empty(M->CJ_LOJA)
				Return .t.
			Endif
			cCliLoja := M->CJ_CLIENTE+M->CJ_LOJA

		ELSEIF ReadVar()  $ "M->C5_CLIENTE|M->C5_LOJACLI|"
			If Empty(M->C5_CLIENTE) .OR. Empty(M->C5_LOJACLI)
				Return .t.
			Endif
			cCliLoja := M->C5_CLIENTE+M->C5_LOJACLI
		ENDIF

		IF IsInCallStack("MATA410")
			IF M->C5_TIPO $ "DB"
				Return .t.
			Endif
		Endif
		
		SA1->(dbseek(xFilial('SA1')+cCliLoja))

		//Se o Estado do Cliente for "EX", nao validar em nenhuma consulta Periodica
		If Left(SA1->A1_EST,2) == "EX"
			Return .t.
		Endif

		If ! U_IsSintegra()
			Return .t.
		Endif

		If Alltrim(SA1->A1_STATRF) == "I"  // Receita Federal
			cMsg += "Cliente esta Inativo na Receita Federal" + CRLF
			lMsg := .T.
		Endif

	/*
		If Alltrim(SA1->A1_STATJ) == "I"  // Simples Nacional
	MsgInfo("Cliente esta Inativo no Simples Nacional - Verifique o Cadastro de Clientes [Simples Nacional]","Aviso")
	Return .t.
		Endif
	*/

		If !U_IsIsentoIE(SA1->A1_INSCR) .and. Alltrim(SA1->A1_STATSI) == "I"    // Sintegra
			cMsg += "Cliente esta Inativo no Sintegra" + CRLF
			lMsg := .T.
		Endif

		If SA1->A1_VALIDRF< dDataBase
			cMsg += "Data de Validade Expirada para este Cliente - [Receita Federal]" + CRLF
			lMsg := .T.
		Endif

		If sa1->a1_validj < dDataBase
			cMsg += "Data de Validade Expirada para este Cliente - [Simples Nacional]" + CRLF
			lMsg := .T.
		Endif

		If !U_IsIsentoIE(SA1->A1_INSCR) .and. SA1->a1_validsi < dDataBase
			cMsg += "Data de Validade Expirada para este Cliente - [Sintegra]" + CRLF
			lMsg := .T.
		Endif

		if lMsg
			//	aviso("AFATCLI",CMSG,{"OK"},3)
			MsgInfo(cMsg,"Verifique o Cadastro de Clientes - AFATCLI")
		Endif
	Endif

Return(.T.)



User Function AFatTran()

	If Empty(M->C5_TRANSP)
		Return .t.
	Endif

	If ! U_IsSintegra()
		Return .t.
	Endif

	SA4->(dbseek(xFilial('SA4')+M->C5_TRANSP))

//Se o Estado da Transportadora for "EX", nao validar em nenhuma consulta Periodica
	If Left(SA4->A4_EST,2) == "EX"
		Return .t.
	Endif

	If Alltrim(SA4->A4_STATRF) == "I"  // Receita Federal
		MsgInfo("Transportadora esta Inativo na Receita Federal - Verifique o Cadastro de Transportadora [Receita Federal]","Aviso")
		Return .t.
	Endif

/*
	If Alltrim(SA4->A4_STATJ) == "I"  // Simples Nacional
MsgInfo("Transportadora esta Inativo no Simples Nacional - Verifique o Cadastro de Transportadora [Simples Nacional]","Aviso")
Return .t.
	Endif
*/

	If !U_IsIsentoIE(SA4->A4_INSEST) .and. Alltrim(SA4->A4_STATSI) == "I"  // Sintegra
		MsgInfo("Transportadora esta Inativo no Sintegra - Verifique o Cadastro de Transportadora [Sintegra]","Aviso")
		Return .t.
	Endif

	If sa4->a4_validrf < dDataBase
		MsgInfo("Data de Validade Expirada para esta Transportadora - Verifique o Cadastro de Transportadora [Receita Federal]","Aviso")
		Return .t.
	Endif

	If sa4->a4_validj < dDataBase
		MsgInfo("Data de Validade Expirada para esta Transportadora - Verifique o Cadastro de Transportadora [Simples Nacional]","Aviso")
		Return .t.
	Endif

	If sa4->a4_validsi < dDataBase
		MsgInfo("Data de Validade Expirada para esta Transportadora - Verifique o Cadastro de Transportadora [Sintegra]","Aviso")
		Return .t.
	Endif

Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TELASINT  ºAutor  ³Microsiga           º Data ³  24/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de Alteracao dos Parametros para Habilitar/Desabilitar º±±
±±º          ³as Consultas Periodicas (Sintegra/Receita/Simples Nacional) º±±
±±º          ³e alteracao do Prazo de Validade das Consultas              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fiscal                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function TelaSint()

	If !TelaGets()
		Return .f.
	EndIf


Return .t.


/*
Funcao      : TelaGets.
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Tela para digitação dos filtros.
Autor       : Robson Sanchez dias
Revisao     :
Obs.        :
*/


	*---------------------*
Static Function TelaGets()
	*---------------------*
	Local lRet:=.f.
	Local oDlg
	Local bOk :={|| If(MsgYesNo( "Confirma Atualizacao (S/N) ? " ),(lRet:=.t., oDlg:End()),)}
	Local bCancel:= {|| oDlg:End()}

	Local cConsPer:=Left(GetMv("ES_SINTEGR"),1)
	Local nPrzRF  :=GetMv("MV_PRZRF")
	Local nPrzJ   :=GetMv("MV_PRZJ")
	Local nPrzSI  :=GetMv("MV_PRZSI")

	Begin Sequence

		Define MsDialog oDlg Title "Parametros" From 0,0 To 195,368 Of oMainWnd Pixel //"Aprovação de Preços - Filtros"
		@ 15,004 To 095,182 LABEL "Consultas Periodicas"  Pixel //"Parâmetros Iniciais"

		@ 27,015 Say "Habilita" Pixel Of oDlg
		@ 27,060 MsGet cConsPer Picture "@!";
			Size 020,08;
			Valid(!Empty(cConsPer) .and. (cConsPer $ 'SN')) Pixel Of oDlg


		@ 39,015 Say "Prz. Rec.Federal" Pixel Of oDlg
		@ 39,060 MsGet nPrzRF Picture "999";
			Size 045,08;
			Valid(nPrzRF>0) Pixel Of oDlg

		@ 51,015 Say "Prz. Simples Nac" Pixel Of oDlg
		@ 51,060 MsGet nPrzJ Picture "999";
			Size 045,08;
			Valid(nPrzJ>0) Pixel Of oDlg

		@ 63,015 Say "Prz. Sintegra" Pixel Of oDlg
		@ 63,060 MsGet nPrzSI Picture "999";
			Size 045,08;
			Valid(nPrzSI>0) Pixel Of oDlg

		Activate MsDialog oDlg On Init EnChoiceBar(oDlg,bOk,bCancel) Centered

	End Sequence

	If lRet

		PUTMV("ES_SINTEGR",cConsPer)
		PUTMV("MV_PRZRF",Str(nPrzRF,3))
		PUTMV("MV_PRZJ",Str(nPrzJ,3))
		PUTMV("MV_PRZSI",Str(nPrzSI,3))
	Endif

Return lRet


User Function IsSintegra()

Return GetMv("ES_SINTEGR") == "S"


	*--------------------------*
User Function IsIsentoIE(cInsc)
	*--------------------------*

	If "ISENT" $ Alltrim(cInsc)
		Return .t.
	Endif

Return .f.
