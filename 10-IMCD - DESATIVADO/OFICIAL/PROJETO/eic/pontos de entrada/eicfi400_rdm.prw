#INCLUDE "AVERAGE.CH" 
//-------------------------------------------------------------------
/*/{Protheus.doc} EICFI400
Utilizado durante a rotina de manutenção do Financeiro do Easy Import 
Control.
@author  author
@since   date
@version 1.1
@see     https://tdn.totvs.com/pages/releaseview.action?pageId=235307328
/*/
//-------------------------------------------------------------------
User Function EICFI400()

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "EICFI400" , __cUserID )

	Do Case 
		//+-----------------------------------------------------------------------------------//
		//|Parametro..: "FI400INCTIT"
		//|Descricao..: Para gravação do NF das despesas do processo
		//|
		//|Nesse exemplo, estou carregando o numero do titulo definido. Para o Processo de
		//|importação. É só fazer do mesmo jeito e colocar o campo que desejar
		//+-----------------------------------------------------------------------------------//
		Case ParamIxb == "FI400INCTIT"
			M->E2_GRUPO := "000003"

		//+-----------------------------------------------------------------------------------//
		//|Parametro..: "ANTES_GRAVACAO_TIT"
		//|Descricao..: Antes da Gravação do Numero Titulo no Financeiro "INV", "NF, "PA" Inter
		//|
		//|Aqui é antes da gravação onde eu confirmo o numero. Nesse caso é quando o sistema
		//|abre a tela com os dados do titulo.
		//+-----------------------------------------------------------------------------------//
		Case ParamIxb == "ANTES_GRAVACAO_TIT"

			//--------------------------------------------------
			//Tratativa para gerar os títulos das despesas
			//de forma customizada e sem telas de confirmação
			//de geração do título
			//---------------------------------------------------
			setFunName("FINA050")
			//Se a chamada for pela integração SYSFIORDE
			if isInCallStack("U_RDIEXEC")
				//----------------------------------------- 
				//Realiza o resgate da natureza cadastrada
				//na tabela de despesas
				//-----------------------------------------
				dbSelectArea("SYB")
				SYB->(dbSetOrder(1))
				if SYB->(dbSeek(xFilial("SYB")+SWD->WD_DESPESA))
					cNatureza := SYB->YB_XNATFIN
				endif
				//---------------------------------
				//Realiza a seleçao de fornecedor
				//de acordo com a despesas informada
				//----------------------------------
				if SWD->WD_DESPESA == '203'
					cCodFor   := "ESTADO"
					cLojaFor  := "00"
				else
					cCodFor   := "UNIAO"
					cLojaFor  := "00"
				endif
					
				if type('nValorS') == 'N' .and. nValorS > 0
					
					cEmissao     := stod(substr(Int_DspHe->NDHDPAGIMP,5,4)+substr(Int_DspHe->NDHDPAGIMP,3,2)+substr(Int_DspHe->NDHDPAGIMP,1,2))
					cDtVecto     := stod(substr(Int_DspHe->NDHDPAGIMP,5,4)+substr(Int_DspHe->NDHDPAGIMP,3,2)+substr(Int_DspHe->NDHDPAGIMP,1,2))
					cPrefixo     := "EIC"
					cIniDocto    := SWD->WD_HAWB
					cTipo_Tit    := "NF"
					nTxMoeda     := 1
					M->WD_EMISSAO := cEmissao

					reclock("SWD", .F.)
					SWD->WD_EMISSAO := cEmissao
					SWD->(msUnlock())

					//--------------------------------------------------------------
					//Verificação da última parcela de titulo lançada no financeiro
					//para incrementar a parcela.
					//--------------------------------------------------------------
					if lPrimDIEx

						cParcela := getLastParc(cFilAnt,cPrefixo,cIniDocto,cTipo_Tit)

						if !empty(cParcela)
							cParcDIEx := soma1(cParcela)
						endif

						lPrimDIEx := .F.

					endif
					
					cParcela     := cParcDIEx

		  			aTit:={}
		  			AADD(aTit,{"E2_NUM"    ,cIniDocto                        ,NIL})
		  			AADD(aTit,{"E2_PREFIXO",cPrefixo                         ,NIL})
		  			AADD(aTit,{"E2_PARCELA",cParcela                         ,NIL})
		  			AADD(aTit,{"E2_TIPO"   ,cTipo_Tit                        ,NIL})
		  			AADD(aTit,{"E2_NATUREZ",cNatureza                        ,NIL})
		  			AADD(aTit,{"E2_FORNECE",cCodFor                          ,NIL})
		  			AADD(aTit,{"E2_LOJA"   ,cLojaFor                         ,NIL})
		  			AADD(aTit,{"E2_EMISSAO",cEmissao                         ,NIL})
		  			AADD(aTit,{"E2_VENCTO" ,cDtVecto                         ,NIL})
		  			AADD(aTit,{"E2_VENCREA",DataValida(cDtVecto,.T.)         ,NIL})//AWR - 09/11/2006 - ANTES: cDtVecto
		  			AADD(aTit,{"E2_VENCORI",cDtVecto                         ,NIL})
		  			AADD(aTit,{"E2_VALOR"  ,nValorS                          ,NIL})
		  			AADD(aTit,{"E2_EMIS1"  ,Ddatabase                        ,NIL})
		  			AADD(aTit,{"E2_MOEDA"  ,nMoedSubs                        ,NIL})
		  			AADD(aTit,{"E2_VLCRUZ" ,Round(NoRound(xMoeda(nValorS,nMoedSubs,1,cEmissao,3,nTxMoeda),3),2),NIL})
		  			AADD(aTit,{"E2_TXMOEDA",nTxMoeda                         ,NIL})
		  			AADD(aTit,{"E2_HIST"   ,cHistorico                       ,NIL})
		  			If FindFunction("F050EasyOrig")
						 AADD(aTit,{"E2_ORIGEM" ,"SIGAEIC"                        ,NIL})  // LGS - 16/05/2016
		  			Else
						 AADD(aTit,{"E2_ORIGEM" ,/*"SIGAEIC"*/""                  ,NIL})  // GFP - 11/05/2015
		  			EndIf
		  			lMsErroAuto:=.F.
		  			lRetF050   :=.T.
		  			DBSELECTAREA("SE2")

					FI400ExecutaValid(1) //LGS - 24/04/2015
					Pergunte("EICFI4",.F.)

					MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aTit,, 3,, Nil, Nil,MV_PAR02 == 1, MV_PAR01 == 1 )
					If Len(aFIN050)<>0 //LGS - 24/04/2015
						FI400ExecutaValid(2)
					EndIf
					If lMsErroAuto
						If type("oErrorFin") == "O" //AOM - 28/07/2011 - Adiciona os Erros
							If ValType(NomeAutoLog()) == "C" .And. !Empty(MemoRead(NomeAutoLog()))
								oErrorFin:Error(MemoRead(NomeAutoLog()))
							EndIf
						Else
							lRetF050:=.F.
							MOSTRAERRO()
						EndIf
					Else
						cAutMotbx := If(Type("cAutMotbx")<>"C", "", cAutMotbx)
						cParcDIEx := soma1(cParcDIEx)
					endif
					If SE5->(DbSeek(xFilial("SE5")+cPrefixo+cIniDocto+cParcela)) //LGS-22/12/2014
						If IsLocked("SE5")
							lLocSE5 := .F.
						Else
							lLocSE5 := .T.
							RecLock("SE5",.F.)
						EndIf
						If !Empty(cAutMotbx) .And. cAutMotbx != "NORMAL"
							SE5->E5_MOTBX := cAutMotbx
						EndIf
						/*If SWB->WB_NUMDUP == SE5->E5_NUMERO .AND. nAtomatico == 1
							SE5->E5_BANCO   := SWB->WB_BANCO
							SE5->E5_AGENCIA := SWB->WB_AGENCIA
							SE5->E5_CONTA   := SWB->WB_CONTA
						EndIf*/
						If lLocSE5
							SE5->(MSUnLock())
						EndIf
					EndIf

				endif
				//--------------------------------------------
                //Procedimento paliativo para inibir a geração
                //de titulos 
                //--------------------------------------------
				lGravaTit := .F.
			Endif
      		


		//+-----------------------------------------------------------------------------------//
		//|Parametro..: "FI400INIVALPA"
		//|Descricao..: Inicial variavel de titulo PA ao Despachante no financeiro
		//|
		//|Esse aqui é para o PA do despachante. É só carregar a variavel de memória com o que
		//|precisa
		//+-----------------------------------------------------------------------------------//
		Case ParamIxb == "FI400INIVALPA"
			M->E2_GRUPO := "000003"

		Case ParamIxb == "ARRAY_AALTINVOICE"

			/*
			2)	Para calcular o vencimento do título o sistema utiliza os seguintes campos como base, se preenchidos, na ordem abaixo:
			o	Data de Entrega
			o	Dt. Previsão de Entrega
			o	Data Desembaraço + Lead Time Transporte (definido na tabela de Portos)
			o	Dt. Prev. Desembaraço + Lead Time Transporte (definido na tabela de Portos)
			o	Data de Atracação + Lead Time Desembaraço (definido na tabela de Portos) + Lead Time Transporte (definido na tabela de Portos)
			o	Dt. Prev. Atracação (ETA) + Lead Time Desembaraço (definido na tabela de Portos) + Lead Time Transporte (definido na tabela de Portos)
			o	Data de Embarque + Lead Time Transporte (Cadastro de Vias de Transporte) + Lead Time Desembaraço (definido na tabela de Portos) + Lead Time Transporte (definido na tabela de Portos)
			o	Dt. Prev. Embarque (ETD) + Lead Time Transporte (Cadastro de Vias de Transporte) + Lead Time Desembaraço (definido na tabela de Portos) + Lead Time Transporte (definido na tabela de Portos)
			*/         

			lAlterouData := .F.

			IF !Empty(M->W6_PRVDESEM) .Or. !Empty(M->W6_DT_DESE) .OR. !Empty(SW6->W6_PRVDESEM) .Or. !Empty(SW6->W6_DT_DESE)
				// Desembaraço
				IF !Empty(M->W6_DT_DESE)
					lAlterouData := SW6->W6_DT_DESE <> M->W6_DT_DESE
				Else
					lAlterouData := SW6->W6_PRVDESEM <> M->W6_PRVDESEM
				Endif
			Elseif !Empty(M->W6_DT_ETA) .Or. !Empty(M->W6_CHEG) .OR. !Empty(SW6->W6_DT_ETA) .Or. !Empty(SW6->W6_CHEG)
				// Atracação
				IF !Empty(M->W6_CHEG)
					lAlterouData := SW6->W6_CHEG <> M->W6_CHEG
				Else
					lAlterouData := SW6->W6_DT_ETA <> M->W6_DT_ETA
				Endif
			Else           
				// Embarque
				IF !Empty(M->W6_DT_EMB)
					lAlterouData := SW6->W6_DT_EMB <> M->W6_DT_EMB
				Else
					lAlterouData := SW6->W6_DT_ETD <> M->W6_DT_ETD
				Endif
			Endif

			if lAlterouData
				//MSGINFO("ALTEROU DATAS")
				lRETURN := .T.
			Endif

	EndCase
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} getLastParc
Resgata a última parcela utilizada para os titulos lançadas pelo 
processo de DI
@author  marcio.katsumata
@since   25/10/2019
@version 1.0
@param   cFilTit, character, filial do titulo
@param   cPrfTit, character, prefixo do titulo
@param   cNumTit, character, número do titulo
@param   cTipoTit, character, tipo do titulo
/*/
//-------------------------------------------------------------------
static function getLastParc(cFilTit,cPrfTit,cNumTit,cTipoTit)

	local cAliasTit as character
	local cUltParc  as character

	//--------------------------
	//Incialização de variáveis
	//--------------------------
	cUltParc  := ""
	cAliasTit := getNextAlias()


	beginSql alias cAliasTit

		SELECT MAX(E2_PARCELA) AS ULTPARC
		FROM %table:SE2% SE2
		WHERE SE2.E2_FILIAL  = %exp:cFilTit%  AND
			  SE2.E2_PREFIXO = %exp:cPrfTit%  AND
			  SE2.E2_NUM     = %exp:cNumTit%  AND
			  SE2.E2_TIPO    = %exp:cTipoTit% AND
			  SE2.%notDel%

	endSql

	if (cAliasTit)->(!eof())
		cUltParc := alltrim((cAliasTit)->ULTPARC)
	endif
	
	(cAliasTit)->(dbCloseArea())
return cUltParc