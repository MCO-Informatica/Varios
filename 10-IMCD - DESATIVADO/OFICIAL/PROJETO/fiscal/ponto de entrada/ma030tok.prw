#INCLUDE 'PROTHEUS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA030TOK  ºAutor  ³Leandro Duarte      º Data ³  10/14/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³rotina para validar os campos para ser preenchido no cadas  º±±
±±º          ³tro de cliente caso o cliente possua policia civil ou Federaº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ p11 e p12                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
//MA030TOK  ºAutor  ³ Junior Carvalho   )º Data ³  09/12/2014
*/

user function MA030TOK()
	Local lRet	:=	.T.
	Local cMsg	:=	""
	local aFields as array
	local cFields as character
	local oImcdLog as object
	local nIndFld as numeric
	local nFields as numeric


	If M->A1_MSBLQL <> '1'
		If M->A1_POLFED  == 'S'
			IF EMPTY(M->A1_PFLIC)
				cMsg += "Por Favor Preencha o campo Licenca PF"+CRLF
				lRet:= .F.
			EndIf
			IF EMPTY(M->A1_PFVALID)
				cMsg += "Por Favor Preencha o campo Vld Lic PF"+CRLF
				lRet:= .F.
			EndIf
		EndIf
		If M->A1_POLCIV  == 'S'
			IF EMPTY(M->A1_PCLIC)
				cMsg += "Por Favor Preencha o campo Licenca PC"+CRLF
				lRet:= .F.
			EndIf
			IF EMPTY(M->A1_PCVALID)
				cMsg += "Por Favor Preencha o campo Vld Lic PC"+CRLF
				lRet:= .F.
			EndIf
		EndIf

		IF !(M->A1_TIPO == "X")
			If Empty(M->A1_DDD)
				cMsg +=	"DDD"+CRLF
				lRet:= .F.
			ElseIf Empty(M->A1_CEP)
				cMsg +=	"CEP"+CRLF
				lRet:= .F.
			EndIf
		Endif

		If Empty(M->A1_CODPAIS)
			cMsg +=	"Pais Bacen"+CRLF
			lRet:= .F.
		ElseIf Empty(M->A1_PAIS)
			cMsg +=	"Codigo do Pais "+CRLF
			lRet:= .F.
		ElseIf Empty(M->A1_PESSOA)
			cMsg += "Fisica/Juridica"+CRLF
		ElseIf Empty(M->A1_EMAIL)
			cMsg +=	"E-mail"+CRLF
			lRet:= .F.
		ElseIf Empty(M->A1_CONTA)
			cMsg +=	"Conta"+CRLF
			lRet:= .F.
		ElseIf Empty(M->A1_XCUSTO)
			cMsg +=	"Centro de Custo"+CRLF
			lRet:= .F.
		ElseIf Empty(M->A1_XINTERC)
			cMsg +=	"Intercompany"+CRLF
			lRet:= .F.
		Endif

		IF ALLTRIM(M->A1_EST) <> "EX"
			If  Empty(M->A1_CGC)
				cMsg +=	"CGC / CPF "+CRLF
				lRet:= .F.
			Endif
		Endif

		If !EMPTY(M->A1_SUFRAMA)
			If Empty(M->A1_DTVLSUF)
				cMsg +=	"Data Suframa"+CRLF
				lRet:= .F.
				//	ElseIf Empty(M->A1_CALCSUF)
				//		cMsg +=	"Desc p.Sufr"+CRLF
				//		lRet:= .F.
			Endif
		Endif

		If M->A1_STATRF == 'A' .AND. Empty(M->A1_CONSRF)
			cMsg +=	"Receita Federal"+CRLF
			lRet:= .F.
		Endif

		If M->A1_STATJ == 'A' .AND. Empty(M->A1_CONSJ)
			cMsg +=	"Simples Nacional"+CRLF
			lRet:= .F.
		Endif

		If M->A1_STATSI == 'A' .AND. Empty(M->A1_CONSSI)
			cMsg +=	"Sintegra"+CRLF
			lRet:= .F.
		Endif

		If M->A1_XRESPAG != "3"

			If M->A1_XRESPAG == "1" .AND. EMPTY(M->A1_XSEMPAG)
				cMsg +=	"Restricao Pg - Dia Semana (A1_XSEMPAG)"+CRLF
				lRet:= .F.
			ELSEIF M->A1_XRESPAG == "2" .AND. EMPTY(M->A1_XDIAPAG)
				cMsg +=	"Restricao Pg - Dias do Mes (A1_XDIAPAG) "+CRLF
				lRet:= .F.
			Endif

		Endif

		If (Len(cMsg) >  2 )
			Help("",1,"Atenção - MA030TOK",,"Verifique se os campos não estão vazios:"+CRLF+cMsg,1,1)
			lRet:= .F.
		EndIf
	EndIf

	IF cEmpAnt == '01'

		dbselectarea("CTD")
		dbsetorder(1)
		dbgotop()
		dbseek("  " + ("C" + M->A1_COD + M->A1_LOJA) )

		IF Empty(CTD->CTD_ITEM)
			RECLOCK("CTD",.T.)
			CTD->CTD_FILIAL := "  "
			CTD->CTD_ITEM := "C" + M->A1_COD + M->A1_LOJA
			CTD->CTD_CLASSE := "2"
			CTD->CTD_NORMAL := "0"
			CTD->CTD_DESC01 := M->A1_NOME
			CTD->CTD_BLOQ := "2"
			CTD->CTD_DTEXIS := Date()
			CTD->CTD_ITLP := "C" + M->A1_COD + M->A1_LOJA
			CTD->CTD_CLOBRG := "2"
			CTD->CTD_ACCLVL := "1"
			MSUNLOCK()
			Alert("Item Contabil Criado" + "C" + M->A1_COD + M->A1_LOJA )
		endif

		CTD->(DBCLOSEAREA())
	Endif

//---------------------------------------------------------
//Alerta sobre a ausência de dados do endereço de cobrança
//----------------------------------------------------------
	if empty(M->A1_ENDCOB) .or. empty(M->A1_BAIRROC) .or. ;
			empty(M->A1_MUNC) .or. empty(M->A1_CEPC) .or.;
			empty(M->A1_ESTC)

		if aviso("ATENÇÃO", "Os campos referente aos dados do endereço de cobrança não estão devidamente preenchidos,"+;
				" a ausência dessas informações impossibilitam a geração do boleto de cobrança."+CRLF+CRLF+;
				"Revise estes dados para evitar estas incosistências.", {"Prosseguir" , "Revisar"}, 2) == 2

			lRet := .F.
		endif

	endif
	


	if Altera

		cFields := superGetMv("ES_AUDFL1A", .F., "")+"/"+superGetMv("ES_AUDFL1B", .F., "")

		aFields := strTokArr2(cFields,"/", .F.)
		nFields := len(aFields)
		oImcdLog := ImcdLogAudit():new()

		for nIndFld := 1 to nFields
			if M->&(aFields[nIndFld]) <> SA1->&(aFields[nIndFld])
				oImcdLog:recordLog("SA1",1,SA1->(A1_FILIAL+A1_COD+A1_LOJA),aFields[nIndFld] ,SA1->&(aFields[nIndFld]),M->&(aFields[nIndFld]))
			endif
		next nIndFld

		aSize(aFields,0)
		freeObj(oImcdLog)
	endif


Return(lRet)
