#include "protheus.ch"
#include "parmtype.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CUSTOMERVENDOR  ณAutor  ณ  Junior Carvalho   ณ Data ณ 18/09/2019  บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATA020                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CUSTOMERVENDOR()
	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObj := ""
	Local cIdPonto := ""
	Local cIdModel := ""
	Local lIsGrid := .F.
	Local lAltCpo := .F.
	Local aCampos := {}
	Local aCpsAlt := {}
	Local nX := 0

	IF cEmpAnt == '04'
		Return (xRet)
	Endif
	If aParam <> NIL
		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid := (Len(aParam) > 3)


		If cIdPonto == "FORMCOMMITTTSPRE"

			If ALTERA
				aAdd(aCpsAlt,{ FWFLDGET("A2_COD"),FWFLDGET("A2_LOJA" ),FWFLDGET("A2_NOME") })

				ACAMPOS :=  {'A2_BANCO','A2_AGENCIA', 'A2_NUMCON'}

				For nX:=1 to Len(ACAMPOS)
					cCpoMVC := FWFLDGET(ACAMPOS[nX])
					cCpoTb := ('SA2')->&(ACAMPOS[nX])

					IF ( ALLTRIM(cCpoMVC) <> ALLTRIM(cCpoTb)  ).AND. !Empty(cCpoTb)
						lAltCpo := .T.
					Endif
					aAdd(aCpsAlt,{ ACAMPOS[nX], cCpoMVC,cCpoTb } )

				Next nX

				if lAltCpo

					FWFldPut('A2_DATBLO',DDATABASE,,,,.T.)

					U_WFGEFOR(aCpsAlt )

				Endif

			ENDIF

		elseif cIdPonto == "FORMCOMMITTTSPOS"
			IF cEmpAnt == '01'

				IF INCLUI

					dbselectarea("CTD")
					dbsetorder(1)
					if !(dbseek(xfilial("CTD") + ("F" + M->A2_COD + M->A2_LOJA) ))
						RECLOCK("CTD",.T.)
						CTD->CTD_FILIAL := "  "
						CTD->CTD_ITEM := "F" + M->A2_COD + M->A2_LOJA
						CTD->CTD_CLASSE := "2"
						CTD->CTD_NORMAL := "0"
						CTD->CTD_DESC01 := M->A2_NOME
						CTD->CTD_BLOQ := "2"
						CTD->CTD_DTEXIS := date()
						CTD->CTD_ITLP := "F" + M->A2_COD + M->A2_LOJA
						CTD->CTD_CLOBRG := "2"
						CTD->CTD_ACCLVL := "1"

						MSUNLOCK()

						Alert("Item Contabil Criado -> " + "F" + M->A2_COD + M->A2_LOJA )
					Endif
					CTD->(DBCLOSEAREA())

				ENDIF

			ENDIF

		ENDIF

	ENDIF

Return xRet
