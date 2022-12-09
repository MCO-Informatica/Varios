#include "Totvs.ch"
#include "Tbiconn.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} CCIMOEDA
    Função utilizada para buscar a Cotação da moeda na API do Banco Central
    @type       function
    @author     Fabio Favaretto
    @since      30/07/2021
    @version    1.0
    @sample        U_CCIMOEDA()
    @url https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/documentacao
 /*/  

User function CCIMOEDA(lCompra)
	Local cBase     := 'https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata'
	Local cUrl      := ''
	Local cGetParms := ''
	Local nTimeOut  := 200
	Local aHeadStr  := {'Content-Type: application/json'}
	Local cHeadGet  := ''
	Local cRet      := ''
	Local aIdMoeda  := getMoedas() //{'USD', 'CHF', 'EUR','YEN'} //ARRAY COM MOEDAS
	Local cDtCot    := '' //MM-DD-AAAA
	Local oJObj     := ''
	Local cJRet     := ''
	//Local cCotacao  := ''
	Local nY        := ''
	Local nX        := 0

	Default lCompra := .T.

	//Ajusta Padrão da Data para MM-DD-AAAA - cDtCot := '07-29-2021'
	//cDtCot := DToS(dDataBase-1)
	//cDtCot := SubStr(cDtCot,5,2) + '-' + SubStr(cDtCot,7,2) + '-' + SubStr(cDtCot,1,4)

	cDtCot := getReqDt(dDataBase)

	//RpcSetEnv("30","302030","lvieira","251213","FIN","MATA090",{"SM2"})


	FOR nY := 2 TO LEN(aIdMoeda)
		//[GET] Consulta Dados na Api Olinda
		oJObj   := JsonObject():New()
		cUrl := cBase
		cUrl += "/CotacaoMoedaPeriodoFechamento(codigoMoeda=@idMD,dataInicialCotacao=@dtIniCt,dataFinalCotacao=@dtFinCt)"
		cUrl += "?@idMD='"+aIdMoeda[nY][2]+"'&@dtIniCt='"+cDtCot+"'&@dtFinCt='"+cDtCot
		cUrl += "'&$format=json&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim"

		cRet := HTTPGet( cUrl , cGetParms, nTimeOut, aHeadStr, @cHeadGet )

		cJRet := oJObj:FromJson(cRet)

		If ValType(cJRet) == 'U' //NIL
			//Valida se a Cotação esta liberada para o dia - oJObj:hasProperty("value")
			If Len(oJObj["value"]) > 0

				//cMoeda := aIdMoeda[nY][2]

				//aIdMoeda[nY][3] :=
				//nValorAtu :=

				If lCompra
					aIdMoeda[nY][3] := (oJObj["value"][1]["cotacaoCompra"])
				Else
					aIdMoeda[nY][3] := (oJObj["value"][1]["cotacaoVenda"])

				EndIf

				/*
				cCotacao  += aIdMoeda[nY] + "|" // USD | 5.54342 | EUR | 6.71582 | BRL | 1
				cCotacao  += nValorAtu  + "|" 
				*/

			EndIf
			FreeObj(oJObj)
		Else
			ConOut("Ocorreu erro no processamento do Json" + CRLF+CRLF + cJRet, ':: Cotação Moeda PTAX - BC API Olinda ::')
			MsgAlert("Não possivel Estabelecer conexão com o Banco Central, Favor cadastrar moedas manualmente", "API PTAX BANCO CENTRAL")
		EndIf
	NEXT
	//aMoedaAtual := StrTokArr(cCotacao, '|')

	If cEmpAnt == "01"

		If Empty(aIdMoeda) == .F.
			DbSelectArea("SM2")
			If !SM2->( DbSeek( DtoS(DATE()) ) )
				MsgAlert("TAXAS PTAX ATUALIZADAS ", "API PTAX BANCO CENTRAL")
				RecLock("SM2",.T.)
				SM2->M2_DATA    := DATE() //DATA DA INCLUSÃO
				SM2->M2_MOEDA2 := (aIdMoeda[2][3]) //USD
				SM2->M2_MOEDA3 := (aIdMoeda[3][3]) //UFIR  //1.0641
				SM2->M2_MOEDA4 := (aIdMoeda[4][3]) //EUR
				SM2->M2_MOEDA5 := (aIdMoeda[5][3]) //CAD
				SM2->M2_MOEDA6 := (aIdMoeda[6][3]) //GBP
				SM2->M2_INFORM := "S"
				//If !cEmpAnt$"04"
					SM2->M2_MOEDA7 := (aIdMoeda[7][3]) //CHF
				//EndIf

				//	SM2->M2_DCOTAC  := DToS(DATE()-1) //DATA DE COTAÇÃO
			Else
				RecLock("SM2",.F.)
			Endif

			If  SM2->M2_MOEDA2==0
				SM2->M2_MOEDA2 := (aIdMoeda[2][3]) //USD
			ENDIF

			If  SM2->M2_MOEDA3==0
				SM2->M2_MOEDA3 := (aIdMoeda[3][3]) //UFIR  //1.0641
			ENDIF
			If  SM2->M2_MOEDA4==0
				SM2->M2_MOEDA4 := (aIdMoeda[4][3]) //EUR
			ENDIF
			If  SM2->M2_MOEDA5==0
				SM2->M2_MOEDA5 := (aIdMoeda[5][3]) //CAD
			ENDIF
			If  SM2->M2_MOEDA6==0
				SM2->M2_MOEDA6 := (aIdMoeda[6][3]) //GBP
			ENDIF
			SM2->M2_INFORM := "S"

			//If !cEmpAnt$"04"
				If  SM2->M2_MOEDA7==0
					SM2->M2_MOEDA7 := (aIdMoeda[7][3]) //CHF
				ENDIF
			//EndIf
			//MsgAlert(SM2->M2_MOEDA2)
			/*
			aIdMoeda[2][3]
            SM2->M2_MOEDA2 := Val(aMoedaAtual[2]) //USD
            SM2->M2_MOEDA3 := 1.0641              //UFIR  
            SM2->M2_MOEDA4 := Val(aMoedaAtual[6]) //EUR 
            SM2->M2_MOEDA5 := Val(aMoedaAtual[4]) //CHF 
			SM2->M2_MOEDA6 := Val(aMoedaAtual[8]) //YEN 
			*/
			SM2->(MsUnlock())

			DbSelectArea("SYE")
			SYE->(DbSetOrder(1))
			For nX := 1 to Len(aIdMoeda)

				If aIdMoeda[nX][2] $ "USD,GBP,CAN,EUR,CAD,CHF"

					aIdMoeda[nX][2] := IIf(aIdMoeda[nX][2] == "CAD","CAN",aIdMoeda[nX][2])

					If !SYE->(DbSeek(xFilial("SYE")+DtoS(DATE())+aIdMoeda[nX][2]))

						RecLock("SYE",.T.)
						YE_FILIAL   := xFilial("SYE")
						YE_DATA     := DATE()
						YE_MOE_FIN  := "2"
						YE_MOEDA    := IIf(aIdMoeda[nX][2] == "CAD","CAN",aIdMoeda[nX][2])
						YE_VLCON_C  := aIdMoeda[nX][3]
						YE_VLFISCA  := aIdMoeda[nX][3]
						YE_TX_COMP  := aIdMoeda[nX][3]

						SYE->(MsUnlock())


						If aIdMoeda[nX][2] == "USD" .AND. !SYE->(DbSeek(xFilial("SYE")+DtoS(DATE())+"US$"))

							RecLock("SYE",.T.)
							YE_FILIAL   := xFilial("SYE")
							YE_DATA     := DATE()
							YE_MOE_FIN  := "2"
							YE_MOEDA    := "US$"
							YE_VLCON_C  := aIdMoeda[nX][3]
							YE_VLFISCA  := aIdMoeda[nX][3]
							YE_TX_COMP  := aIdMoeda[nX][3]

							SYE->(MsUnlock())

						EndIf

					EndIf

				EndIf

			Next

			ConOut("Tabela SM2 -> Moedas atulizado com sucesso.")
		EndIf

	Else
		VerMdEmp()
	EndIf

Return





Static Function DeParaMD(cMoedaErp)

	Default cMoedaErp := alltrim(cMoedaErp)

	DO CASE
	CASE cMoedaErp $ "US$/USD"
		cMoedaRet := "USD"
	CASE cMoedaErp == "CAN"
		cMoedaRet := "CAD"
	CASE cMoedaErp == "LBR"
		cMoedaRet := "GBP"
	CASE cMoedaErp == "IENE"
		cMoedaRet := "JPY"
	CASE cMoedaErp == "CHF"
		cMoedaRet := "CHF"
	CASE cMoedaErp == "EUR"
		cMoedaRet := "EUR"
	OTHERWISE
		cMoedaRet := ""
	ENDCASE

return cMoedaRet




Static Function getReqDt(dDataRef)

	local dDataNew := dDataBase
	local cDataRet := ""

	dDataNew := DataValida (dDataRef-1, .F.)
	cDataRet := strZero(month(dDataNew), 2) + "-"+ strZero(day(dDataNew),2)  + "-"+ strZero(year(dDataNew),4)


return cDataRet





Static Function getMoedas()

	local cPrefix as character
	local cSufix  as character
	local aMoedas as array

	aMoedas := {}
	cPrefix := "MV_SIMB"
	cSufix  := "1"
	cParam  := "cPrefix+cSufix"

	while FWSX6Util():ExistsParam( &(cParam) )

		cMoeda := getMv(&(cParam))
		aadd(aMoedas, {cSufix, DeParaMD(cMoeda), 1})
		cSufix := soma1(cSufix)
	enddo

return aMoedas


Static Function VerMdEmp()
	Local lRet := .F.
	Local cSql := ""
	Local nX := 0

	If cEmpAnt <> "01"
		cSql := "SELECT * FROM SM2010 WHERE M2_DATA = '"+DtoS(dDataBase)+"' AND D_E_L_E_T_= ' ' "
		If Select("QRYMD") > 0
			QRYMD->(Dbclosearea())
		EndIf

		TCQUERY cSql NEW ALIAS "QRYMD"

		If !Empty(QRYMD->M2_DATA) .AND. QRYMD->M2_MOEDA2 <> 1

			DbSelectArea("SM2")
			If !SM2->( DbSeek( DtoS(DATE()) ) )
				RecLock("SM2",.T.)

				SM2->M2_DATA    := DATE() 			 //DATA DA INCLUSÃO
				SM2->M2_MOEDA2 := QRYMD->(M2_MOEDA2) //USD
				SM2->M2_MOEDA3 := QRYMD->(M2_MOEDA3) //UFIR  //1.0641
				SM2->M2_MOEDA4 := QRYMD->(M2_MOEDA4) //EUR
				SM2->M2_MOEDA5 := QRYMD->(M2_MOEDA5) //CAD
				SM2->M2_MOEDA6 := QRYMD->(M2_MOEDA6) //GBP
				SM2->M2_MOEDA7 := QRYMD->(M2_MOEDA7) //CHF
				SM2->M2_INFORM := "S"

				SM2->(MsUnlock())


				DbSelectArea("SYE")
				SYE->(DbSetOrder(1))
				For nX := 1 to Len(aIdMoeda)

					If aIdMoeda[nX][2] $ "USD,GBP,CAN,EUR,CAD,CHF"

						aIdMoeda[nX][2] := IIf(aIdMoeda[nX][2] == "CAD","CAN",aIdMoeda[nX][2])

						If !SYE->(DbSeek(xFilial("SYE")+DtoS(DATE())+aIdMoeda[nX][2]))

							RecLock("SYE",.T.)
							YE_FILIAL   := xFilial("SYE")
							YE_DATA     := DATE()
							YE_MOE_FIN  := "2"
							YE_MOEDA    := IIf(aIdMoeda[nX][2] == "CAD","CAN",aIdMoeda[nX][2])
							YE_VLCON_C  := aIdMoeda[nX][3]
							YE_VLFISCA  := aIdMoeda[nX][3]
							YE_TX_COMP  := aIdMoeda[nX][3]

							SYE->(MsUnlock())


							If aIdMoeda[nX][2] == "USD" .AND. !SYE->(DbSeek(xFilial("SYE")+DtoS(DATE())+"US$"))

								RecLock("SYE",.T.)
								YE_FILIAL   := xFilial("SYE")
								YE_DATA     := DATE()
								YE_MOE_FIN  := "2"
								YE_MOEDA    := "US$"
								YE_VLCON_C  := aIdMoeda[nX][3]
								YE_VLFISCA  := aIdMoeda[nX][3]
								YE_TX_COMP  := aIdMoeda[nX][3]

								SYE->(MsUnlock())

							EndIf

						EndIf

					EndIf

				Next

				lRet := .T.

			Else

				If SM2->M2_MOEDA2 == 1 .OR. SM2->M2_MOEDA2 == 0

					RecLock("SM2",.F.)
					SM2->M2_MOEDA2 := QRYMD->(M2_MOEDA2) //USD
					SM2->M2_MOEDA3 := QRYMD->(M2_MOEDA3) //UFIR  //1.0641
					SM2->M2_MOEDA4 := QRYMD->(M2_MOEDA4) //EUR
					SM2->M2_MOEDA5 := QRYMD->(M2_MOEDA5) //CAD
					SM2->M2_MOEDA6 := QRYMD->(M2_MOEDA6) //GBP
					SM2->(MsUnlock())

					lRet := .T.

				EndIf

			EndIf

		EndIf

	EndIf

	If Select("QRYMD") > 0
		QRYMD->(Dbclosearea())
	EndIf


Return lRet
