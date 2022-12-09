#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Programa: RNVCN001      ||Data: 17/01/2013 ||Cliente: RENOVA        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Autor: Daniel Grotti    ||Empresa: MRW SOLUTIONS                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Módulo: Gestão de Contratos  || Origem: FSW - MRW SOLUTIONS         //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Descrição: Importa medição a partir de arquivo CSV.                 //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
User Function RNVCN001()
Local oCSV
Local cCam    := Space(100)
Private cMask := "Arquivos Texto|*.CSV|Todos os Arquivos|*.*"
Private cTit  := "Diretório de Arquivos"
Private lBut  := .F.
Private nBits := GETF_OVERWRITEPROMPT+GETF_NETWORKDRIVE+GETF_LOCALHARD

//Private lEncerMedic := .T.

Private _cObsPA := ""  // Variavel customizada usada no Pedido de Compras

If Upper(Alltrim(Substr(cUsuario, 7, 15))) == "TOTVS"
	Alert("Fonte de 30/04/2014")
Endif

U_miGeraLog(,, .T.)

Define MsDialog oCSV Title "Gerador de Medição" From 0,0 To 150,380 Pixel
@005,010 Say "Diretório do arquivo." Pixel of oCSV
@015,010 MsGet oCam Var cCam Size 100,10 Picture "@!" Pixel of oCSV

/*
@035,012 CheckBox oCBox Var    lEncerMedic Prompt "Encerrar as Medições" Message "Se marcado as medições serão encerradas" Size 80, 007 Pixel Of oCsv
*/

@015,130 Button   oBtAn Prompt "&Procurar" Size 40,10 Pixel of oCSV Action(cCam := cGetFile(cMask, cTit, , , lBut, nBits))
@060,100 Button   oBtOk Prompt "&Ok" Size 40,10 Pixel of oCSV Action( Iif(Empty(cCam),MsgStop("Campo não pode ser vazio!"), Processa({|| RNVCN01A(cCam), oCSV:End()}, "Processando", "Aguarde...")))
@060,146 Button   oBtAn Prompt "&Cancelar" Size 40,10 Pixel of oCSV Action(oCSV:End())

Activate MsDialog oCSV Centered
Return

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Programa: RNVCN01A      ||Data: 17/01/2013 ||Cliente: RENOVA        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Autor: Daniel Grotti    ||Empresa: MRW SOLUTIONS                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Módulo: Gestão de Contratos  || Origem: FSW - MRW SOLUTIONS         //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Descrição: Função auxiliar para importação do arquivo CSV.          //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
Static Function RNVCN01A(cCam)
Local nLinha        := 0
Local aCab          := {}
Local aItens        := {}
Local dVcto1        := CTOD("//")
Local dVcto2        := CTOD("//")
Local dVcto3        := CTOD("//")
Local cComp1        := ""
Local cComp2        := ""
Local cComp3        := ""
Local cCnpj         := ""
Local cCodAVD       := ""
Local cContrato     := ""
Local cPlanilha     := ""
Local cLog          := ""
Local nValPar1      := 0
Local nValPar2      := 0
Local nValPar3      := 0

Local nValOri1      := 0
Local nValOri2      := 0
Local nValOri3      := 0

Local nParcial      := 0

Local cCodOns       := ""
Local cSigOns       := "" 
Local nValmed       := 0
Local cNomeCom      := SM0->M0_NOMECOM   
Local cEmpFil       := SM0->M0_CODFIL
Local cDescri       := ""
Local cNumPed       := ""   
Local aLog          := {}
Local aDetExcel     := {}
Local nTotApont     := 0
Local lSegue_       := .F.
Local cNumMed       := ""   
Local cNumPed       := ""

Private aLinha      := {}
Private lMsErroAuto := .F. 


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Valida que a extensão é igual a CSV.//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
If !".csv" $ cCam
	MsgStop("A extensão do arquivo deve ser CSV!")
	Return Nil
EndIf

FT_FUse(cCam)
FT_FGoTop()
ProcRegua(FT_FLastRec())
FT_FGoTop()
While (!FT_FEof())
	nLinha++

	If nLinha == 1
		FT_FSkip()
		Loop
	EndIf

	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	//Chamada de função que converte texto em array.//
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	aLinha := U_TXTTOARR(FT_FReadLn(), ";")

	IncProc("Lendo arquivo...")

	aItens := {}
	aCab   := {}

	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	//Coleta dados na planilha para checar se existe no cadastro de empresa.//
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	If SubStr(aLinha[2], 1, 7) == "Empresa"
		cCodAVD := aLinha[1]
		DbSelectArea("PA1")
		DbSetOrder(2)
		If DbSeek(xFilial("PA1")+cCodAVD)
			cCnpj := PA1->PA1_CNPJ
			If cCNPJ <> SM0->M0_CGC
				MsgStop("O CNPJ da planilha não corresponde ao CNPJ da empresa que está logado. Por favor verifique!")
				Return Nil
			EndIf
		Else
			MsgStop("Código AVD não encontrado na amarração CNPJ x Cod. AVD. Verifique (PA1)!")
	   		Return Nil
		EndIf
	EndIf

	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	//Coleta dados na planilha para obter vencimento e competencia.         //
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	If aLinha[2] == "Transmissoras"
		dVcto1   := CTOD(SubStr(aLinha[6], 17))
		dVcto2   := CTOD(SubStr(aLinha[7], 17))
		dVcto3   := CTOD(SubStr(aLinha[8], 17))
		cComp1   := SubStr(aLinha[6], At("dia", aLinha[6])+7)
		cComp2   := SubStr(aLinha[7], At("dia", aLinha[7])+7)
		cComp3   := SubStr(aLinha[8], At("dia", aLinha[8])+7)
		FT_FSkip()
		Loop
	EndIf

	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	//Verifica se as variáveis foram preenchidas para iniciar processamento.//
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	If !Empty(cCodAVD) .AND. !Empty(dVcto1) .AND. !Empty(dVcto2) .AND. !Empty(dVcto3)
		nValPar1  := StrTran(aLinha[6], ".", "")
		nValPar1  := StrTran(nValPar1 , ",", ".")
		nValPar1  := Val(nValPar1)

		nValPar2  := StrTran(aLinha[7], ".", "")
		nValPar2  := StrTran(nValPar2 , ",", ".")
		nValPar2  := Val(nValPar2)

		nValPar3  := StrTran(aLinha[8], ".", "")
		nValPar3  := StrTran(nValPar3 , ",", ".")
		nValPar3  := Val(nValPar3)

		nValOri1  := nValPar1
		nValOri2  := nValPar2
		nValOri3  := nValPar3

		If aLinha[1] == "Total Geral"
			Exit
		EndIf

		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
		//Coleta ONS na planilha, posição 01 e 02 do array.   //
		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
        cCodOns := aLinha[01]
        cSigOns := aLinha[02]
        nValmed := aLinha[09]

		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
		//Coleta contrato na planilha, posição 10 do array.   //
		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
		cContrato := aLinha[10]

		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
		//Verifica se o contrato existe na tabela de contratos (CN9).  //
		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
		cQryCont := " SELECT MAX(CN9_REVISA) REVISAO, CN9_CONDPG, CN9_NUMERO, CN9_TPCTO "+CRLF
		cQryCont += " FROM "+RetSqlName("CN9")+" CN9"+CRLF
		cQryCont += " WHERE CN9_NUMERO = '"+cContrato+"'"+CRLF
		cQryCont += " AND CN9.D_E_L_E_T_ = ' ' "+CRLF
		cQryCont += " AND CN9.CN9_FILIAL = '" + xFilial("CN9") + "' "+CRLF
		cQryCont += " GROUP BY CN9_CONDPG, CN9_NUMERO, CN9_TPCTO  "+CRLF


		U_miGeraLog(, cQryCont)

		If Select("QRYCON")<>0
			DbSelectArea("QRYCON")
			DbCloseArea()
		EndIf

		TcQuery cQryCont New Alias "QRYCON"

		QRYCON->(DbGoTop())
		If QRYCON->(!Eof())
			_cRevisa := QRYCON->REVISAO
			cCondPg  := QRYCON->CN9_CONDPG
			cContrato:= QRYCON->CN9_NUMERO
		Else
			cLog := "Contrato não localizado no cadastro (CN9). Contrato Nro.: "+cContrato+"."
			Aadd(aDetExcel, {"NÃO PROCESSADO", cContrato, "ARQUIVO CSV", cLog})
		EndIf

		//%%%%%%%%%%%%%%%%%%%%%%%%%%//
		//Retira a mascara do cnpj. //
		//%%%%%%%%%%%%%%%%%%%%%%%%%%//
		cCnpjFor  := aLinha[3]
		cCnpjFor  := StrTran(cCnpjFor, ".", "")
		cCnpjFor  := StrTran(cCnpjFor, "/", "")
		cCnpjFor  := StrTran(cCnpjFor, "-", "")

		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
		//Pesquisa fornecedor pelo cnpj no cadastro de fornecedores SA2//
		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
		DbSelectArea("SA2")
		/*
		SA2->(DbSetOrder(3))
		If SA2->(DbSeek(xFilial("SA2")+cCnpjFor))
		*/
		If LoczForn(cCnpjFor)
			SA2->(dbSetOrder(1))
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
			//Pesquisa cod e loja no cadastro de fornecedores do contrato CNC.//
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
			cQryFor := " SELECT * "+CRLF
			cQryFor += " FROM "+RetSqlName("CNC")+" CNC"+CRLF
			cQryFor += " WHERE CNC_NUMERO = '"+cContrato+"'"+CRLF
			cQryFor += " AND CNC_CODIGO = '"+SA2->A2_COD+"'"+CRLF
			cQryFor += " AND CNC_LOJA = '"+SA2->A2_LOJA+"'"+CRLF
			cQryFor += " AND D_E_L_E_T_ = ' ' "+CRLF
			cQryFor += " AND CNC_FILIAL = '" + xFilial("CNC") + "' "+CRLF
			U_miGeraLog(, cQryFor)

			If Select("QRYFOR")<>0
				DbSelectArea("QRYFOR")
				DbCloseArea()
			EndIf

			TcQuery cQryFor New Alias "QRYFOR"

			//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
			//Se o fornecedor foi encontrado no cadastro de fornecedores do contra- //
			//to, cruza informação das tabelas CNA e CNB para busca da planilha e do//
			//produto que será utlizado na medição.                                 //
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
			QRYFOR->(DbGoTop())
			If QRYFOR->(!Eof())
				cQryPla := " SELECT *"+CRLF
				cQryPla += " FROM "+RetSqlName("CNA")+" CNA"+CRLF
				cQryPla += " INNER JOIN "+RetSqlName("CNB")+" CNB"+CRLF
				cQryPla += " ON CNA_NUMERO = CNB_NUMERO AND CNA_REVISA = CNB_REVISA "+CRLF
				cQryPla += " AND CNA_CONTRA = CNB_CONTRA"+CRLF
				cQryPla += " AND CNB.D_E_L_E_T_ = ' '"+CRLF
				cQryPla += " AND CNB.CNB_FILIAL = '" + xFilial("CNB") + "' "+CRLF
				cQryPla += " WHERE CNA_CONTRA = '"+cContrato+"'"+CRLF
				cQryPla += " AND CNA_REVISA = '"+_cRevisa+"'"+CRLF
				cQryPla += " AND CNA_FORNEC = '"+SA2->A2_COD+"'"+CRLF
				cQryPla += " AND CNA_LJFORN = '"+SA2->A2_LOJA+"'"+CRLF
				cQryPla += " AND CNA.D_E_L_E_T_ = ' '"+CRLF
				cQryPla += " AND CNA.CNA_FILIAL = '" + xFilial("CNA") + "' "+CRLF
				cQryPla += " ORDER BY CNB_NUMERO, CNB_ITEM "+CRLF

				U_miGeraLog(, cQryPla)

				If Select("QRYPLA")<>0
					DbSelectArea("QRYPLA")
					DbCloseArea()
				EndIf

				TcQuery cQryPla New Alias "QRYPLA"

				Count To nRegPla

				//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
				//Se encontra planilha inicia processamento.//
				//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
				QRYPLA->(DbGoTop())
				If QRYPLA->(!Eof())
					cPlanilha := QRYPLA->CNA_NUMERO
					cTpPlanil := QRYPLA->CNA_TIPPLA
					While QRYPLA->(!Eof())

						//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
						//Verifica se o valor informado na planilha AVD é maior que zero e cole-//
						//ta competencia do cronograma fisico financeiro do contrato.           //
						//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
						If nValPar1 > 0

							aCab   := {}
							aItens := {}
							aCabEnc:= {}

							//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
							//Verifica se existe competencia no cronograma e inicia carregamento dos//
							//para execução da função MSExecAuto da rotina CNTA120.                 //
							//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
							cQryCro := " SELECT *"+CRLF
							cQryCro += " FROM "+RetSqlName("CNF")+" CNF"+CRLF
							cQryCro += " WHERE CNF.D_E_L_E_T_ = ' '"+CRLF
							cQryCro += " AND CNF.CNF_FILIAL = '" + xFilial("CNF") + "' "+CRLF
							cQryCro += " AND CNF_CONTRA = '"+cContrato+"'"+CRLF
							cQryCro += " AND CNF_REVISA = '"+_cRevisa+"'"+CRLF
							cQryCro += " AND CNF_COMPET = '"+cComp1+"'"+CRLF
							cQryCro += " AND CNF_SALDO > 0  "+CRLF

							U_miGeraLog(, cQryCro)

							If Select("QRYCRO")<>0
								DbSelectArea("QRYCRO")
								DbCloseArea()
							EndIf

							TcQuery cQryCro New Alias "QRYCRO"

							QRYCRO->(DbGoTop())
							If QRYCRO->(!Eof())
								cNumMed := CriaVar("CND_NUMMED") 
								cNumPed := CriaVar("CND_PEDIDO")
								aAdd(aCab, {"CND_FILIAL", xFilial("CND")                , NIL})
								aAdd(aCab, {"CND_NUMMED", cNumMed                       , NIL})
								aAdd(aCab, {"CND_CONTRA", cContrato                     , NIL})
								aAdd(aCab, {"CND_REVISA", _cRevisa                      , NIL})
								aAdd(aCab, {"CND_FORNEC", SA2->A2_COD                   , NIL})
								aAdd(aCab, {"CND_LJFORN", SA2->A2_LOJA                  , NIL})
								aAdd(aCab, {"CND_MOEDA" , "1"                           , NIL})
								aAdd(aCab, {"CND_OBS"   , "LINHAS DE TRANSMISSAO", NIL})
								aAdd(aCab, {"CND_XDTVEN", dVcto1                        , NIL})
								aAdd(aCab, {"CND_ZERO"  , "2"                           , NIL})
								aAdd(aCab, {"CND_COMPET", cComp1                        , NIL})
								aAdd(aCab, {"CND_CONDPG", cCondPg                       , NIL})
								aAdd(aCab, {"CND_NUMERO", cPlanilha                     , NIL})
								aAdd(aCab, {"CND_TIPPLA", cTpPlanil                     , NIL})
								aAdd(aCab, {"CND_PARCEL", QRYCRO->CNF_PARCEL            , NIL})
								aAdd(aCab, {"CND_XPA", "2"                              , NIL})
								aAdd(aCab, {"CND_XPMS", "2"                             , NIL})  
								aAdd(aCab, {"CND_XCTRAN", cCodOns                       , NIL})
								aAdd(aCab, {"CND_XDTRAN", cSigOns                       , NIL})
								aAdd(aCab, {"CND_PEDIDO", cNumPed                       , NIL})

								nTotApont := 0

								QRYPLA->(DbGoTop())
								While QRYPLA->(!Eof())

									//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
									//Verifica se existe saldo a ser medido no item da planilha. Caso não      //
									// tenha informa zero para execução da função MSExecAuto da rotina CNTA120.//
									//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
									DbSelectArea("CNB")
									CNB->(DbSetOrder(1))//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM
									If CNB->(DbSeek(xFilial("CNB")+QRYPLA->CNB_CONTRA+QRYPLA->CNB_REVISA+QRYPLA->CNB_NUMERO+QRYPLA->CNB_ITEM))
										If (nValPar1 <= (CNB->CNB_VLUNIT * CNB->CNB_SLDMED * 1.99)) .AND. CNB->CNB_SLDMED > 0
    	                                	lSegue_ := .T.
	         							ElseIf (nValPar1 >= (CNB->CNB_VLUNIT * CNB->CNB_SLDMED * 1.99)) .AND. CNB->CNB_SLDMED > 0
	         								If nRegPla > 1
		         								nParcial := nValPar1 - (CNB->CNB_VLUNIT * CNB->CNB_SLDMED * 1.99)
		         							Else
		         								nParcial := nValPar1
		         							EndIf
        	                            	lSegue_ := .F.
        	         					ElseIf nValPar1 <= 0
        	         						nValPar1 := 0
									    EndIf
									Else
										lSegue_  := .F.
										nParcial := 0
										nValPar1 := 0
									EndIf

									If (!lSegue_) .AND. nValPar1 > 0 .And. Type("nParcial") == "U"
										U_miGeraLog(, "Situacao 01 -> Tratamento de erro")
										QRYPLA->(DbSkip())
										Loop
									Endif

									aAdd(aItens,{})
									aAdd(aItens[Len(aItens)], {"CNE_FILIAL", xFilial("CNE")               , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_ITEM"  , CNB->CNB_ITEM                , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_PRODUT", CNB->CNB_PRODUT              , NIL})
									If lSegue_ .AND. nValPar1 > 0
								//		aAdd(aItens[Len(aItens)], {"CNE_QUANT" , nValPar1/CNB->CNB_VLUNIT , NIL})
								//		aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", CNB->CNB_VLUNIT          , NIL})


										aAdd(aItens[Len(aItens)], {"CNE_QUANT" , 1                        , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", nValPar1                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , nValPar1                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_PERC"  , 1*100/CNB->CNB_QUANT     , NIL})
										nTotApont +=  nValPar1
										nValPar1 := 0

									ElseIf !lSegue_ .AND. nValPar1 > 0
								//		aAdd(aItens[Len(aItens)], {"CNE_QUANT" , nParcial/CNB->CNB_VLUNIT , NIL})
								//		aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", CNB->CNB_VLUNIT          , NIL})

										aAdd(aItens[Len(aItens)], {"CNE_QUANT" , 1                        , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", nParcial                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , nParcial                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_PERC"  , 1*100/CNB->CNB_QUANT     , NIL})
										nTotApont += nParcial
										nValPar1  := nValOri1 - nTotApont
									Else
										aAdd(aItens[Len(aItens)], {"CNE_QUANT" , 0                        , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", CNB->CNB_VLUNIT          , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , 0                        , NIL})
									EndIf
									aAdd(aItens[Len(aItens)], {"CNE_CONTRA", cContrato                    , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_DTENT" , dVcto1                       , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_REVISA", _cRevisa                     , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_NUMERO", cPlanilha                    , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_NUMMED", cNumMed                      , NIL})
                                    aAdd(aItens[Len(aItens)], {"CNE_PEDIDO", cNumPed                      , NIL})      									
									aAdd(aItens[Len(aItens)], {"CNE_DESCRI", cDescri                      , NIL})      
									aAdd(aItens[Len(aItens)], {"CNE_CONTRA", cNumMed                      , NIL}) 
									QRYPLA->(DbSkip())
								End

								//%%%%%%%%%%%%%%%%%%%%%%%%//
								//Chamada para o execauto.//
								//%%%%%%%%%%%%%%%%%%%%%%%%//
								aLog := GeraExcAu(aItens, aCab)
								cNumPed := CND->CND_PEDIDO 
								If aLog[1]
									cLog := aLog[2]
									Aadd(aDetExcel, {cNomeCom, cEmpFil,cCodOns,cSigOns,CnpjExcel(cCnpjFor), cContrato,cDescri , cNumMed , cNumPed,nValmed, "EXECAUTO", cLog})
								Else
									cLog := "Importação realizada com sucesso."
									Aadd(aDetExcel, {cNomeCom, cEmpFil,cCodOns,cSigOns,CnpjExcel(cCnpjFor), cContrato,cDescri , cNumMed , cNumPed,nValmed, "EXECAUTO", cLog})
									cNumMed := ""
								EndIf
							Else
								cLog := "Competência "+cComp1+" não localizada no cronograma do contrato. Possivel saldo zero no cronograma. Contrato Nro.: "+cContrato+" CNPJ: "+cCnpjFor+"."
								Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,CnpjExcel(cCnpjFor), cContrato,cDescri , cNumMed , cNumPed,nValmed, "CRONOGRAMA (CNF)", cLog})
							EndIf
						EndIf

						//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
						//Verifica se o valor informado na planilha AVD é maior que zero e cole-//
						//ta competencia do cronograma fisico financeiro do contrato.           //
						//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
						If nValPar2 > 0

							aCab   := {}
							aItens := {}

							cQryCro := " SELECT *"+CRLF
							cQryCro += " FROM "+RetSqlName("CNF")+" CNF"+CRLF
							cQryCro += " WHERE CNF.D_E_L_E_T_ = ' '"+CRLF
							cQryCro += " AND CNF.CNF_FILIAL = '" + xFilial("CNF") + "' "+CRLF
							cQryCro += " AND CNF_CONTRA = '"+cContrato+"'"+CRLF
							cQryCro += " AND CNF_REVISA = '"+_cRevisa+"'"+CRLF
							cQryCro += " AND CNF_COMPET = '"+cComp2+"'"+CRLF
							cQryCro += " AND CNF_SALDO > 0  "+CRLF

							U_miGeraLog(, cQryCro)

							If Select("QRYCRO")<>0
								DbSelectArea("QRYCRO")
								DbCloseArea()
							EndIf

							TcQuery cQryCro New Alias "QRYCRO"

							//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
							//Verifica se existe competencia no cronograma e inicia carregamento dos//
							//para execução da função MSExecAuto da rotina CNTA120.                 //
							//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
							QRYCRO->(DbGoTop())
							If QRYCRO->(!Eof())
								cNumMed := CriaVar("CND_NUMMED")
								cNumPed := CriaVar("CND_PEDIDO")
								aAdd(aCab, {"CND_FILIAL", xFilial("CND")                , NIL})
								aAdd(aCab, {"CND_NUMMED", cNumMed                       , NIL})
								aAdd(aCab, {"CND_CONTRA", cContrato                     , NIL})
								aAdd(aCab, {"CND_REVISA", _cRevisa                      , NIL})
								aAdd(aCab, {"CND_FORNEC", SA2->A2_COD                   , NIL})
								aAdd(aCab, {"CND_LJFORN", SA2->A2_LOJA                  , NIL})
								aAdd(aCab, {"CND_MOEDA" , "1"                           , NIL})
								aAdd(aCab, {"CND_OBS"   , "LINHAS DE TRANSMISSAO", NIL})
								aAdd(aCab, {"CND_XDTVEN", dVcto2                        , NIL})
								aAdd(aCab, {"CND_ZERO"  , "2"                           , NIL})
								aAdd(aCab, {"CND_COMPET", cComp2                        , NIL})
								aAdd(aCab, {"CND_CONDPG", cCondPg                       , NIL})
								aAdd(aCab, {"CND_NUMERO", cPlanilha                     , NIL})
								aAdd(aCab, {"CND_TIPPLA", cTpPlanil                     , NIL})
								aAdd(aCab, {"CND_PARCEL", QRYCRO->CNF_PARCEL            , NIL})
								aAdd(aCab, {"CND_XPA", "2"                              , NIL})
								aAdd(aCab, {"CND_XPMS", "2"                             , NIL})
								aAdd(aCab, {"CND_XCTRAN", cCodOns                       , NIL})
								aAdd(aCab, {"CND_XDTRAN", cSigOns                       , NIL})
								aAdd(aCab, {"CND_PEDIDO", cNumPed                       , NIL})

								nTotApont := 0

								QRYPLA->(DbGoTop())
								While QRYPLA->(!Eof())

									//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
									//Verifica se existe saldo a ser medido no item da planilha. Caso não      //
									// tenha informa zero para execução da função MSExecAuto da rotina CNTA120.//
									//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
									DbSelectArea("CNB")
									CNB->(DbSetOrder(1))//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM
									If CNB->(DbSeek(xFilial("CNB")+QRYPLA->CNB_CONTRA+QRYPLA->CNB_REVISA+QRYPLA->CNB_NUMERO+QRYPLA->CNB_ITEM))
										If (nValPar2 <= (CNB->CNB_VLUNIT * CNB->CNB_SLDMED * 1.99)) .AND. CNB->CNB_SLDMED > 0
    	                                	lSegue_ := .T.
	         							ElseIf (nValPar2 >= (CNB->CNB_VLUNIT * CNB->CNB_SLDMED * 1.99)) .AND. CNB->CNB_SLDMED > 0
	         								If nRegPla > 1
		         								nParcial := nValPar2 - (CNB->CNB_VLUNIT * CNB->CNB_SLDMED * 1.99)
		         							Else
		         								nParcial := nValPar2
		         							EndIf
        	                            	lSegue_ := .F.
        	         					ElseIf nValPar2 <= 0
        	         						nValPar2 := 0
									    EndIf
									Else
										lSegue_  := .F.
										nParcial := 0
										nValPar2 := 0
									EndIf

									If (!lSegue_) .AND. nValPar2 > 0 .And. Type("nParcial") == "U"
										U_miGeraLog(, "Situacao 02 -> Tratamento de erro")
										QRYPLA->(DbSkip())
										Loop
									Endif

									aAdd(aItens,{})
									aAdd(aItens[Len(aItens)], {"CNE_FILIAL", xFilial("CNE")               , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_ITEM"  , CNB->CNB_ITEM                , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_PRODUT", CNB->CNB_PRODUT              , NIL})
									If lSegue_ .AND. nValPar2 > 0
								//		aAdd(aItens[Len(aItens)], {"CNE_QUANT" , nValPar2/CNB->CNB_VLUNIT , NIL})
								//		aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", CNB->CNB_VLUNIT          , NIL})

										aAdd(aItens[Len(aItens)], {"CNE_QUANT" , 1                        , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", nValPar2                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , nValPar2                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_PERC"  , 1*100/CNB->CNB_QUANT     , NIL})
										nTotApont +=  nValPar2
										nValPar2  := 0
									ElseIf !lSegue_ .AND. nValPar2 > 0
								//		aAdd(aItens[Len(aItens)], {"CNE_QUANT" , nParcial/CNB->CNB_VLUNIT , NIL})
								//		aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", CNB->CNB_VLUNIT          , NIL})

										aAdd(aItens[Len(aItens)], {"CNE_QUANT" , 1                        , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", nParcial                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , nParcial                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_PERC"  , 1*100/CNB->CNB_QUANT     , NIL})
										nTotApont +=  nParcial
										nValPar2  := nValOri2 - nTotApont
									Else
										aAdd(aItens[Len(aItens)], {"CNE_QUANT" , 0                        , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", CNB->CNB_VLUNIT          , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , 0                        , NIL})
									EndIf
									aAdd(aItens[Len(aItens)], {"CNE_CONTRA", cContrato                    , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_DTENT" , dVcto2                       , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_REVISA", _cRevisa                     , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_NUMERO", cPlanilha                    , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_NUMMED", cNumMed                      , NIL})
                                    aAdd(aItens[Len(aItens)], {"CNE_PEDIDO", cNumPed                      , NIL})      									
									QRYPLA->(DbSkip())
								End

								//%%%%%%%%%%%%%%%%%%%%%%%%//
								//Chamada para o execauto.//
								//%%%%%%%%%%%%%%%%%%%%%%%%//
								aLog := GeraExcAu(aItens, aCab)  
								cNumPed := CND->CND_PEDIDO 
								If aLog[1]
									cLog := aLog[2]
									Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,CnpjExcel(cCnpjFor), cContrato,cNumMed , cNumPed, nValmed, "EXECAUTO", cLog})
								Else
									cLog := "Importação realizada com sucesso."
									Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,CnpjExcel(cCnpjFor), cContrato, cNumMed , cNumPed, nValmed, "EXECAUTO", cLog})
									cNumMed := ""
								EndIf
							Else
								cLog := "Competência "+cComp2+" não localizada no cronograma do contrato. Possivel saldo zero no cronograma. Contrato Nro.: "+cContrato+" CNPJ: "+cCnpjFor+"."
								Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,CnpjExcel(cCnpjFor), cContrato,cNumMed , cNumPed, nValmed,"CRONOGRAMA (CNF)", cLog})
							EndIf
						EndIf

						//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
						//Verifica se o valor informado na planilha AVD é maior que zero e cole-//
						//ta competencia do cronograma fisico financeiro do contrato.           //
						//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
						If nValPar3 > 0

							aCab   := {}
							aItens := {}

							cQryCro := " SELECT *"+CRLF
							cQryCro += " FROM "+RetSqlName("CNF")+" CNF"+CRLF
							cQryCro += " WHERE CNF.D_E_L_E_T_ = ' '"+CRLF
							cQryCro += " AND CNF.CNF_FILIAL = '" + xFilial("CNF") + "' "+CRLF
							cQryCro += " AND CNF_CONTRA = '"+cContrato+"'"+CRLF
							cQryCro += " AND CNF_COMPET = '"+cComp3+"'"+CRLF
							cQryCro += " AND CNF_SALDO > 0  "+CRLF

							U_miGeraLog(, cQryCro)

							If Select("QRYCRO")<>0
								DbSelectArea("QRYCRO")
								DbCloseArea()
							EndIf

							TcQuery cQryCro New Alias "QRYCRO"

							//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
							//Verifica se existe competencia no cronograma e inicia carregamento dos//
							//para execução da função MSExecAuto da rotina CNTA120.                 //
							//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
							QRYCRO->(DbGoTop())
							If QRYCRO->(!Eof())
								cNumMed := CriaVar("CND_NUMMED")
								cNumPed := CriaVar("CND_PEDIDO")
								aAdd(aCab, {"CND_FILIAL", xFilial("CND")                , NIL})
								aAdd(aCab, {"CND_NUMMED", cNumMed                       , NIL})
								aAdd(aCab, {"CND_CONTRA", cContrato                     , NIL})
								aAdd(aCab, {"CND_REVISA", _cRevisa                      , NIL})
								aAdd(aCab, {"CND_FORNEC", SA2->A2_COD                   , NIL})
								aAdd(aCab, {"CND_LJFORN", SA2->A2_LOJA                  , NIL})
								aAdd(aCab, {"CND_MOEDA" , "1"                           , NIL})
								aAdd(aCab, {"CND_OBS"   , "LINHAS DE TRANSMISSAO"       , NIL})
								aAdd(aCab, {"CND_XDTVEN", dVcto3                        , NIL})
								aAdd(aCab, {"CND_ZERO"  , "2"                           , NIL})
								aAdd(aCab, {"CND_COMPET", cComp3                        , NIL})
								aAdd(aCab, {"CND_CONDPG", cCondPg                       , NIL})
								aAdd(aCab, {"CND_NUMERO", cPlanilha                     , NIL})
								aAdd(aCab, {"CND_TIPPLA", cTpPlanil                     , NIL})
								aAdd(aCab, {"CND_PARCEL", QRYCRO->CNF_PARCEL            , NIL})
								aAdd(aCab, {"CND_XPA", "2"                              , NIL})
								aAdd(aCab, {"CND_XPMS", "2"                             , NIL})
								aAdd(aCab, {"CND_PEDIDO", cNumPed                       , NIL})

								nTotApont := 0

								QRYPLA->(DbGoTop())
								While QRYPLA->(!Eof())

									//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
									//Verifica se existe saldo a ser medido no item da planilha. Caso não      //
									// tenha informa zero para execução da função MSExecAuto da rotina CNTA120.//
									//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
									DbSelectArea("CNB")
									CNB->(DbSetOrder(1))//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM
									If CNB->(DbSeek(xFilial("CNB")+QRYPLA->CNB_CONTRA+QRYPLA->CNB_REVISA+QRYPLA->CNB_NUMERO+QRYPLA->CNB_ITEM))
										If (nValPar3 <= (CNB->CNB_VLUNIT * CNB->CNB_SLDMED * 1.99)) .AND. CNB->CNB_SLDMED > 0
    	                                	lSegue_ := .T.
	         							ElseIf (nValPar3 >= (CNB->CNB_VLUNIT * CNB->CNB_SLDMED * 1.99)) .AND. CNB->CNB_SLDMED > 0
	         								If nRegPla > 1
		         								nParcial := nValPar3 - (CNB->CNB_VLUNIT * CNB->CNB_SLDMED * 1.99)
		         							Else
		         								nParcial := nValPar3
		         							EndIf
        	                            	lSegue_ := .F.
        	         					ElseIf nValPar3 <= 0
        	         						nValPar3 := 0
									    EndIf
									Else
										lSegue_  := .F.
										nParcial := 0
										nValPar3 := 0
									EndIf

									If (!lSegue_) .AND. nValPar3 > 0 .And. Type("nParcial") == "U"
										U_miGeraLog(, "Situacao 03 -> Tratamento de erro")
										QRYPLA->(DbSkip())
										Loop
									Endif

									aAdd(aItens,{})
									aAdd(aItens[Len(aItens)], {"CNE_FILIAL", xFilial("CNE")               , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_ITEM"  , CNB->CNB_ITEM                , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_PRODUT", CNB->CNB_PRODUT              , NIL})
									If lSegue_ .AND. nValPar3 > 0
									//	aAdd(aItens[Len(aItens)], {"CNE_QUANT" , nValPar3/CNB->CNB_VLUNIT , NIL})
									//	aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", CNB->CNB_VLUNIT          , NIL})

										aAdd(aItens[Len(aItens)], {"CNE_QUANT" , 1                        , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", nValPar3                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , nValPar3                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_PERC"  , 1*100/CNB->CNB_QUANT     , NIL})
										nTotApont +=  nValPar3
										nValPar3  := 0
									ElseIf !lSegue_ .AND. nValPar3 > 0
										aAdd(aItens[Len(aItens)], {"CNE_QUANT" , nParcial/CNB->CNB_VLUNIT , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", CNB->CNB_VLUNIT          , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , nParcial                 , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_PERC"  , 1*100/CNB->CNB_QUANT     , NIL})
										nTotApont += nParcial
										nValPar3  := nValOri3 - nTotApont
									Else
										aAdd(aItens[Len(aItens)], {"CNE_QUANT" , 0                        , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLUNIT", CNB->CNB_VLUNIT          , NIL})
										aAdd(aItens[Len(aItens)], {"CNE_VLTOT" , 0                        , NIL})
									EndIf
									aAdd(aItens[Len(aItens)], {"CNE_CONTRA", cContrato                    , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_DTENT" , dVcto3                       , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_REVISA", _cRevisa                     , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_NUMERO", cPlanilha                    , NIL})
									aAdd(aItens[Len(aItens)], {"CNE_NUMMED", cNumMed                      , NIL})
	                                aAdd(aItens[Len(aItens)], {"CNE_PEDIDO", cNumPed                      , NIL})      																	
									QRYPLA->(DbSkip())
								End

								//%%%%%%%%%%%%%%%%%%%%%%%%//
								//Chamada para o execauto.//
								//%%%%%%%%%%%%%%%%%%%%%%%%//
								aLog := GeraExcAu(aItens, aCab)
								cNumPed := CND->CND_PEDIDO 
								If aLog[1]
									cLog := aLog[2]
									Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,CnpjExcel(cCnpjFor), cContrato,cNumMed,cNumPed, nValmed , "EXECAUTO", cLog})
								Else
									cLog := "Importação realizada com sucesso."
									Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,CnpjExcel(cCnpjFor), cContrato, cNumMed, cNumPed,nValmed, "EXECAUTO", cLog})
									cNumMed := ""
								EndIf
							Else
								cLog := "Competência "+cComp3+" não localizada no cronograma do contrato. Possivel saldo zero no cronograma. Contrato Nro.: "+cContrato+" CNPJ: "+cCnpjFor+"."
								Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,CnpjExcel(cCnpjFor), cContrato, cNumMed, cNumPed,nValmed, "CRONOGRAMA (CNF)", cLog})
							EndIf
						EndIf
						QRYPLA->(DbSkip())
					End
				Else
					cLog := "Alguma informação da planilha não conforme. Verifique os dados como contrato, revisão, fornecedor, etc...! Contrato Nro.: "+cContrato+" CNPJ: "+cCnpjFor+"."
					Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,cCnpjFor, cContrato , cNumMed, cNumPed, nValmed, "PLANILHA (CNA/CNB)", cLog})
					SA2->(dbSetOrder(1))
				EndIf
			Else
				cLog := "Fornecedor não encontrado no cadastro de fornecedores do contrato (CNC). Contrato Nro.: "+cContrato+" CNPJ: "+cCnpjFor+"."
				Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,cCnpjFor, cContrato,cNumMed , cNumPed, nValmed, "CONTRATO (CNC)", cLog})
				SA2->(dbSetOrder(1))
			EndIf
		Else
			cLog := "Fornecedor não encontrado no cadastro de fornecedores (SA2). Contrato Nro.: "+cContrato+" CNPJ: "+cCnpjFor+"."
			Aadd(aDetExcel, {cNomeCom, cEmpFil, cCodOns,cSigOns,cCnpjFor, cContrato , cNumMed , cNumPed, nValmed, "CADASTRO FORNECEDORES (SA2)", cLog})
			SA2->(dbSetOrder(1))
		EndIf
	EndIf

	If aLinha[1] == "Total Geral"
		Exit
	EndIf

	FT_FSkip()
End

U_miGeraLog(,,, .T.)

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Gera LOG dos registros em excel. //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

// Empresa / Número / Contrato / CNPJ / Cod. ONS / Sigla ONS / Medição / Pedido Numero / Titulo / Valor Medido / STATUS

DlgToExcel({{"ARRAY", "LOG_DE_IMPORTAÇÃO_DO_ARQUIVO: ==>> "+Upper(cCam), {"EMPRESA","NUMERO","COD. ONS","SIGLA ONS","CNPJ", "CONTRATO", "MEDIÇÃO","PEDIDO NUMERO","VALOR MEDIDO","ORIGEM", "DESCRIÇÃO"}, aDetExcel}})
///DlgToExcel({{"ARRAY", "LOG_DE_IMPORTAÇÃO_DO_ARQUIVO: ==>> "+Upper(cCam), {"CNPJ", "CONTRATO", "ORIGEM", "DESCRIÇÃO"}, aDetExcel}})

Return .T.

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Programa: GERAEXCAU     ||Data: 17/01/2013 ||Cliente: RENOVA        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Autor: Daniel Grotti    ||Empresa: MRW SOLUTIONS                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Módulo: Gestão de Contratos  || Origem: FSW - MRW SOLUTIONS         //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Descrição: Função auxiliar para importação do arquivo CSV.          //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
Static Function GeraExcAu(aItens, aCab)
Local aAutoErro        := {}
Local nA               := 0
Local cDebug           := ""
Local cEnter           := Chr(13) + Chr(10)
Private cRet           := ""
Private aResult        := {}
Private lMsErroAuto    := .F.
Private lAutoErrNoFile := .T.

Begin Transaction

//%%%%%%%%%%%%%//
//Gera medição.//
//%%%%%%%%%%%%%//

cDebug += cEnter + "Inicio de geracao da medicao" + cEnter

MsExecAuto({|a,b,c|,CNTA120(a,b,c)},aCab,aItens,3, .F.)

U_miGeraLog(aCab)
U_miGeraLog(aItens)

If lMsErroAuto
	cDebug += "Erro na geracao da medicao" + cEnter
	If lAutoErrNoFile
		aAutoErro := GetAutoGrLog()
		For nA := 1 To Len(aAutoErro)
			cRet += RTrim(aAutoErro[nA])+" "+CRLF
		Next nA
	Else
		MostraErro()
	Endif
Else
	cDebug += "Medicao gerada com sucesso" + cEnter
Endif

//%%%%%%%%%%%%%%%%//
//Encerra medição.//
//%%%%%%%%%%%%%%%%//

If !lMsErroAuto
	cDebug += "Inicio do encerramento da medicao" + cEnter
	lMsErroAuto := .F.
	MsExecAuto({|a,b,c|,CNTA120(a,b,c)},aCab,aItens,6, .F.)
	If lMsErroAuto
		cDebug += "Erro no encerramento da medicao" + cEnter
		If lAutoErrNoFile
			aAutoErro := GetAutoGrLog()
			For nA := 1 To Len(aAutoErro)
				cRet += RTrim(aAutoErro[nA])+" "+CRLF
			Next nA
		Else
			MostraErro()
			cRet += ""
		Endif
		cDebug += "Transacao desarmada - RollBack executado" + cEnter
		DisarmTransaction()
	Else
		cDebug += "Encerramento da medicao realizado com sucesso" + cEnter
	EndIf
EndIf

End Transaction

If ! Empty(cRet)
	If ! Alltrim(aCab[1, 1]) $ cRet
		aEval(aCab, {|z| cRet += Pad(z[1], 11) + " => " + Transform(z[2], "") + cEnter})
		For nA := 1 to Len(aItens)
			aEval(aItens[nA], {|z| cRet += Pad(z[1], 11) + " => " + Transform(z[2], "") + Chr(13) + Chr(10)})
		Next
	Endif
Endif

aResult := {lMsErroAuto, cDebug + cRet}

U_miGeraLog(, If(lMsErroAuto, "Erro no ExecAuto", "ExecAuto executado com sucesso") + Chr(13) + Chr(10) + cDebug + cRet)

Return aResult

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Programa: TXTTOARR      ||Data: 22/01/2013 ||Empresa: RENOVA        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Autor: Daniel Grotti    ||Empresa: MRW SOLUTIONS                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Módulo: Gestão de contratos || Origem: FSW - TOTVS                  //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Descrição: Converte texto com separador em array.                   //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
User Function TXTTOARR(cLinha, cSepara)
Local aArray   := {}
Local cLinha_  := ""
Default cLinha := ""
Default cSepara:= ""

nPosAt := At(AllTrim(cSepara), cLinha)
If nPosAt == 0
	MsgStop("Separador não encontrado!")
	Return Nil
EndIf

While Len(cLinha)>0
	nPosAt := At(AllTrim(cSepara), cLinha)
	cLinha_ := SubStr(cLinha, 1, nPosAt-1)
	cLinha  := SubStr(cLinha, nPosAt+1)
	If nPosAt == 0
		Aadd(aArray, cLinha)
		cLinha := ""
	Else
		Aadd(aArray, cLinha_)
	EndIf
End
Return aArray



Static Function CnpjExcel(cCnpj)
Local cRet := "'" + cCnpj
Return(cRet)


Static Function LoczForn(cCnpjFor)  //Pesquisa fornecedor pelo cnpj no cadastro de fornecedores SA2
Local cSeek    := Nil
Local nA2Recno := Nil
Local aSavAre  := GetArea()

dbSelectArea("SA2")
dbSetOrder(3) // 3  A2_FILIAL+A2_CGC
dbSeek(cSeek := xFilial("SA2") + cCnpjFor)
Do While ! Eof() .And. A2_FILIAL+A2_CGC == cSeek
	If SA2->A2_MSBLQL <> "1"
		nA2Recno := SA2->(Recno())
		Exit
	Endif
	dbSkip()
Enddo
RestArea(aSavAre)
SA2->(dbSetOrder(1))

If nA2Recno <> Nil
	SA2->(dbGoto(nA2Recno))
Endif

Return(nA2Recno <> Nil)


User Function miGeraLog(_aAuto, cMsg, lReset, lEnd)
Local cPathServer := "\"
Local cFile       := "GeraLog.txt"
Local cPathLocal  := iPathLocal()
Local cEnter      := Chr(13) + Chr(10)
Local aAuto       := Nil
Local nHandle     := Nil
Local nLoop1      := Nil
Local nLoop2      := Nil

Default lReset := .F.
Default lEnd   := .F.

If lReset
	fErase(cPathServer + cFile)
	fErase(cPathLocal  + cFile)
	Return
Endif

If lEnd
	CpyS2T(cPathServer + cFile, cPathLocal, .T.)
	If Upper(Alltrim(Substr(cUsuario, 7, 15))) == "TOTVS"
		WinExec( "Notepad.exe " + cPathLocal + cFile)
	Endif
	Return
Endif

If (nHandle := If(File(cPathServer + cFile), fOpen(cPathServer + cFile, 1), Fcreate(cPathServer + cFile, 0))) <= 0
	Return
Endif

fSeek(nHandle, 0, 2)

If cMsg <> Nil
	fWrite(nHandle, cEnter + cMsg + cEnter + cEnter)
Endif

If _aAuto == Nil
	fClose(nHandle)
	Return
Endif

aAuto := aClone(_aAuto)

If ValType(aAuto) == "A" .And. Len(aAuto) == 0
	fClose(nHandle)
	Return
Endif

If ValType(aAuto[1, 1]) <> "A"
	aAuto := aClone( { aAuto } )
Endif

cMsg := cEnter + cEnter

For nLoop1 := 1 to Len(aAuto)
	If Len(aAuto[nLoop1]) > 1
		cMsg += cEnter + "Array de itens: ITEM " + StrZero(nLoop1, 3) + cEnter
	Endif

	For nLoop2 := 1 to Len(aAuto[nLoop1])
		cMsg += Pad(aAuto[nLoop1, nLoop2, 1], 12) + " => " + Alltrim(Transform(aAuto[nLoop1, nLoop2, 2], "")) + cEnter
	Next
	cMsg += cEnter
Next

fWrite(nHandle, cMsg + cEnter)

fClose(nHandle)

Return

Static Function SaveCsv(aHeader, aList)
Local cPasta := "\LogTust"
Local cFile  := Nil

If Right(cPasta, 1) <> "\"
	cPasta += "\"
Endif

If Len(Directory(cPasta + "*.*", "D")) == 0
	MakeDir( cPasta )
Endif

cFile := U_miSeqFile(cPasta, "LogTust_" + Dtos(Date()) + "_", ".Csv", 3)
U_miSaveCsv(cFile, aHeader, aList)
Return

User Function miSaveCsv(cFile, aHeader, aList)
Local nHandle := FCreate(cFile)
Local cEnter  := Chr(13) + Chr(10)
Local cBuffer := ""
Local nLoop1  := Nil
Local nLoop2  := Nil

If nHandle < 0
	Return
Endif

If aList == Nil .Or. Len(aList) == 0
	Return
Endif

cBuffer:= ""
For nLoop1 := 1 To Len(aHeader)
	cBuffer += ToXlsFormat(Alltrim(aHeader[nLoop1])) + If(nLoop1 < Len(aHeader), ";", cEnter)
Next

For nLoop1 := 1 to Len(aList)
	For nLoop2 := 1 to Len(aList[nLoop1])
		cBuffer += ToXlsFormat(aList[nLoop1, nLoop2]) + If(nLoop2 < Len(aList[nLoop1]), ";", cEnter)
	Next
	If Len(cBuffer) > 4096
		FWrite(nHandle, cBuffer)
		cBuffer := ""
	Endif
Next
FWrite(nHandle, cBuffer)

FClose(nHandle)
Return

User Function miSeqFile(cPasta, cRaiz, cExtensao, nSize)
Local cFile
Local nCount := 1

If Right(cPasta, 1) <> "\"
	cPasta := Alltrim(cPasta) + "\"
Endif

If Left(cExtensao, 1) <> "."
	cExtensao := "." + cExtensao
Endif

Do While .T.
	cFile := cPasta + cRaiz + StrZero(nCount ++, nSize) + cExtensao

	If ! File(cFile)
		Exit
	Endif

	If nCount > 2000
		Final("Erro na criacao de arquivo sequencial na pasta " + cPasta)
	Endif
Enddo

Return(cFile)


Static Function iPathLocal
Local cPathLocal

If Empty(cPathLocal := GetTempPath())
	If Len(Directory("C:\Temp\*.*", "D")) > 0
		cPathLocal := "C:\Temp\"
	Else
		cPathLocal := "C:\"
	Endif
Endif

cPathLocal := Alltrim(cPathLocal)

If Right(cPathLocal, 1) <> "\"
	cPathLocal += "\"
Endif

Return(cPathLocal)


