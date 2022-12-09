#Include 'Protheus.ch'


/*/{Protheus.doc} vnda640
Rotina job para baixa ou compensação de títulos com NCC em aberto
@author david.oliveira
@since 28/05/2015
@version 1.0
@param aParSch, array, array com empresa e filial para processamento via JOB
/*/

User Function vnda640(aParSch)
	Local cJobEmp	:= ""
	Local cJobFil	:= ""
	Local cDtParIni	:= ""
	Local _lJob 	:= (Select('SX6')==0)
	Local lReturn	:= .T.
	Default aParSch := {"01","02"}

	cJobEmp	:= aParSch[1]
	cJobFil	:= aParSch[2]

	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp, cJobFil)
	EndIf

	cDtParIni := GetNewPar("MV_XDTV640", "20150101")

	If Select("PEDGT") > 0
		DbSelectArea("PEDGT")
		QRYGT->(DbCloseArea())
	EndIf

	BeginSql Alias "PEDGT"

		SELECT
		    PEDIDO,
		    C5_TIPMOV TIPO_MOV,
		    COD_SITE,
		    C5_CHVBPAG COD_GAR,
		    TO_DATE(C5_EMISSAO,'YYYYMMDD') DT_EMISSAO,
		    C5_TOTPED TOTAL_PEDIDO,
		    C5_XNPARCE QTD_PARCELAS,
		    C5_XNATURE NATUREZA_PEDIDO,
		    Round(SUM(VALOR_NF),2) VALOR_NF,
		    Round(SUM(SALDO_NF),2) SALDO_NF,
		    Round(SUM(VALOR_PR),2) VALOR_PR,
		    Round(SUM(SALDO_PR),2) SALDO_PR,
		    Round(SUM(VALOR_NCC),2) VALOR_NCC,
		    Round(SUM(SALDO_NCC),2) SALDO_NCC
		FROM
		    (
		      SELECT
		        SE1.R_E_C_N_O_ RECE1, SE1.E1_PEDIDO PEDIDO, SE1.E1_PARCELA PARCELA, E1_NATUREZ NATUREZA ,E1_TIPMOV TIPO_MOV , E1_XNPSITE COD_SITE, E1_PEDGAR COD_GAR ,E1_VALOR VALOR_NF ,E1_SALDO SALDO_NF, 0 VALOR_PR ,0 SALDO_PR, 0 VALOR_NCC, 0 SALDO_NCC
		      FROM
		        %Table:SE1% SE1 LEFT JOIN ( SELECT
		                          E1_PEDIDO, E1_PARCELA
		                        FROM
		                          %Table:SE1% SE1
		                        WHERE
		                          E1_FILIAL = %xFilial:SE1% AND
		                          (
		                            (E1_PREFIXO = 'RCP' AND E1_TIPO= 'NCC') OR
		                            (E1_PREFIXO = 'VDI' AND E1_TIPO= 'NCC') OR
		                            (E1_PREFIXO = 'RCP' AND E1_TIPO= 'PR')
		                          ) AND
		                          E1_SALDO > 0 AND
		                          E1_EMISSAO >= %Exp:cDtParIni% AND
		                          E1_PEDIDO <> ' ' AND
		                          SE1.%NotDel%
		                        GROUP BY
		                          E1_PEDIDO,
		                          E1_PARCELA) SE1B ON
		                  SE1.E1_PEDIDO = SE1B.E1_PEDIDO
		      WHERE
		        E1_FILIAL = %xFilial:SE1% AND
		        E1_TIPO = 'NF' AND
		        E1_VENCTO <= %Exp:DtoS(dDataBase)% AND
		        SE1.D_E_L_E_T_ = ' '
		      GROUP BY
		        SE1.R_E_C_N_O_,
		        SE1.E1_PEDIDO,
		        SE1.E1_PARCELA,
		        E1_NATUREZ,
		        E1_TIPMOV,
		        E1_XNPSITE,
		        E1_PEDGAR,
		        E1_VALOR,
		        E1_SALDO
		      UNION ALL
		      SELECT
		        SE1.R_E_C_N_O_ RECE1, SE1.E1_PEDIDO PEDIDO, SE1.E1_PARCELA PARCELA,  E1_NATUREZ NATUREZA ,E1_TIPMOV, E1_XNPSITE, E1_PEDGAR, 0  ,0 , E1_VALOR ,E1_SALDO , 0 ,0
		      FROM
		        %Table:SE1% SE1 LEFT JOIN ( SELECT
		                          E1_PEDIDO, E1_PARCELA
		                        FROM
		                          %Table:SE1% SE1
		                        WHERE
		                          E1_FILIAL = %xFilial:SE1%  AND
		                          (
		                            E1_TIPO = 'NF' OR
		                            (E1_PREFIXO = 'RCP' AND E1_TIPO= 'NCC')
		                          ) AND
		                          E1_SALDO > 0 AND
		                          E1_EMISSAO >= %Exp:cDtParIni% AND
		                          E1_PEDIDO <> ' ' AND
		                          SE1.%NotDel%
		                        GROUP BY
		                          E1_PEDIDO,
		                          E1_PARCELA) SE1B ON
		                  SE1.E1_PEDIDO = SE1B.E1_PEDIDO
		      WHERE
		        E1_FILIAL = %xFilial:SE1% AND
		        E1_PREFIXO = 'RCP' AND
		        E1_TIPO = 'PR' AND
		        E1_VENCTO <= %Exp:DtoS(dDataBase)% AND
		        SE1.%NotDel%
		      GROUP BY
		        SE1.R_E_C_N_O_,
		        SE1.E1_PEDIDO,
		        SE1.E1_PARCELA,
		        E1_NATUREZ,
		        E1_TIPMOV,
		        E1_XNPSITE,
		        E1_PEDGAR,
		        E1_VALOR,
		        E1_SALDO
		      UNION ALL
		      SELECT
		        SE1.R_E_C_N_O_ RECE1,SE1.E1_PEDIDO PEDIDO, SE1.E1_PARCELA PARCELA, E1_NATUREZ NATUREZA , E1_TIPMOV, E1_XNPSITE, E1_PEDGAR, 0 , 0 , 0,  0 , E1_VALOR, E1_SALDO
		      FROM
		        %Table:SE1% SE1 LEFT JOIN ( SELECT
		                          E1_PEDIDO,E1_PARCELA
		                        FROM
		                          %Table:SE1% SE1
		                        WHERE
		                          E1_FILIAL = %xFilial:SE1% AND
		                          (
		                            E1_TIPO = 'NF' OR
		                            (E1_PREFIXO = 'RCP' AND E1_TIPO= 'PR')
		                          ) AND
		                          E1_SALDO > 0 AND
		                          E1_EMISSAO >= %Exp:cDtParIni% AND
		                          E1_PEDIDO <> ' ' AND
		                          SE1.%NotDel%
		                        GROUP BY
		                          E1_PEDIDO,
		                          E1_PARCELA ) SE1B ON
		                  SE1.E1_PEDIDO = SE1B.E1_PEDIDO
		      WHERE
		        E1_FILIAL = %xFilial:SE1% AND
		        ( (E1_PREFIXO = 'RCP' AND E1_TIPO = 'NCC') OR (E1_PREFIXO = 'VDI' AND E1_TIPO = 'NCC') ) AND
		        E1_VENCTO <= %Exp:DtoS(dDataBase)% AND
		        SE1.%NotDel%
		      GROUP BY
		        SE1.R_E_C_N_O_,
		        SE1.E1_PEDIDO,
		        SE1.E1_PARCELA,
		        E1_NATUREZ,
		        E1_TIPMOV,
		        E1_XNPSITE,
		        E1_PEDGAR,
		        E1_VALOR,
		        E1_SALDO
		        ) x INNER JOIN %Table:SC5% SC5 ON
		          C5_FILIAL = %xFilial:SC5% AND
		          PEDIDO = C5_NUM AND
		          SC5.%NotDel%
		WHERE
		    COD_SITE <> ' '
		GROUP BY
		    PEDIDO,
		    C5_TIPMOV,
		    COD_SITE,
		    C5_CHVBPAG,
		    C5_EMISSAO,
		    C5_TOTPED,
		    C5_XNPARCE,
		    C5_XNATURE
		HAVING
		  	( SUM(SALDO_NF) > 0 AND SUM(SALDO_NCC) > 0 )  OR
      		( SUM(SALDO_NF) = 0 AND SUM(VALOR_NF) > 0 AND SUM(SALDO_NCC) = 0.01  ) OR
          	( SUM(SALDO_NCC) = 0 AND SUM(VALOR_NF) > 0 AND SUM(SALDO_NF) = 0.01  ) OR
          	( SUM(SALDO_NF) = 0 AND SUM(VALOR_NF) > 0 AND SUM(SALDO_NCC) = 0.02  ) OR
          	( SUM(SALDO_NCC) = 0 AND SUM(VALOR_NF) > 0 AND SUM(SALDO_NF) = 0.02  ) OR
        	( SUM(SALDO_PR) > 0 AND  SUM(VALOR_NF) > 0  AND ( ROUND( SUM(VALOR_PR) ) -  SUM(VALOR_NF) ) <> SUM(SALDO_PR) ) OR
        	( SUM(SALDO_PR) > 0 AND  SUM(VALOR_NCC) > 0  AND ( ROUND( SUM(VALOR_PR) ) -  SUM(VALOR_NCC) ) <> SUM(SALDO_PR) )
		ORDER BY
		    PEDIDO
	EndSql

	While PEDGT->(!Eof())
		cTpFil := ""

		If PEDGT->SALDO_NF > 0
			cTpFil	:= "NF"
		ElseIf PEDGT->SALDO_PR > 0
			cTpFil	:= "PR"
		ElseIf PEDGT->SALDO_NCC > 0 .AND. PEDGT->SALDO_NF = 0  .AND. PEDGT->VALOR_NF > 0 .AND. PEDGT->SALDO_PR = 0
			cTpFil	:= "NCC"
		Endif

		If !Empty(cTpFil)

			BeginSql Alias 'TRBSE1'
			 	SELECT
			 		R_E_C_N_O_ RECE1
			 	FROM
			 		PROTHEUS.SE1010
			 	WHERE
			 		E1_FILIAL = %XFilial:SE1% AND
			 		E1_TIPO = %Exp:cTpFil% AND
			 		E1_PEDIDO =  %Exp:PEDGT->PEDIDO% AND
			 		E1_VENCTO <=  %Exp:DtoS(dDataBase)% AND
			 		E1_SALDO > 0 AND
			 		%NotDel%
			 EndSql

			 aPar:={}

			 While !TRBSE1->(EoF())
			 	aPar:= {{PEDGT->PEDIDO,TRBSE1->RECE1}}
			 	TRBSE1->(DbSkip())
			 EndDo

			 If Len(aPar) > 0
			 	If cTpFil $ "NCC" .OR. (cTpFil $ "NF" .AND. PEDGT->SALDO_NF >= 0.01 .AND. PEDGT->SALDO_NF <= 0.02 .AND. PEDGT->SALDO_NCC == 0 .AND. PEDGT->SALDO_PR == 0)
			 		V640BX("2",aPar)
			 	ElseIf cTpFil $ "NF,PR"
			 		V640BX("1",aPar)
			 	EndIf
			 EndIf

			 TRBSE1->(DbCloseArea())

		Endif

		PEDGT->(DbSkip())
	EndDo
	PEDGT->(DbCloseArea())

Return(lReturn)

/*/{Protheus.doc} V640BX
Rotina estática de execução da movimentação do título referente o pedido
@author david.oliveira
@since 28/05/2015
@version 1.0
@param cTip, character, Tipo de 1=Compensação 2=Baixa
@param aAnalysis, array, Array com recno do título e código do pedido a ser realizado o movimento financeiro
@see (links_or_references)
/*/

Static Function V640BX( cTip ,aAnalysis )
	Local aBaixa      := {}
	Local cPrefixo    := GetNewPar('MV_XPREFRP', 'RCP')
	Local cA6_COD     := Space( Len( SA6->A6_COD ) )
	Local cA6_AGENCIA := Space( Len( SA6->A6_AGENCIA ) )
	Local cA6_NUMCON  := Space( Len( SA6->A6_NUMCON ) )
	Local aParam      := {}
	Local aFaVlAtuCR  := {}
	Local aDadosBaixa := {}
	Local aLog        := {}
	Local aRet        := {}
	Local cHistory    := ''
	Local nDefinitivo := 0
	Local nI, nX	  := 0
	Local aAuxSE1	  := {}
	Local nBaixa	  := 0
	Local dBxRcb	  := dDataBase

	// [1]-Contabiliza on-line.
	// [2]-Agluitna lançamentos contábeis.
	// [3]-Digita lançamento contábeis.
	// [4]-Juros para comissão.
	// [5]-Desconto para comissão.
	// [6]-Calcula comissão para NCC .
	aParam := {.F.,.F.,.F.,.F.,.F.,.F.}

	For nI := 1 To Len( aAnalysis )
		// Localizar o título definitivo NF para capturar o valor a ser baixado no PR.
		SE1->( dbGoTo( aAnalysis[ nI, 2 ]) )
		cTipoOri	:= SE1->E1_TIPO
		nDefinitivo := SE1->E1_VALOR
		cHistory 	:= SE1->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO ) + 'SUB'
		aAuxSE1		:= {}
		dEmissao	:= SE1->E1_EMISSAO
		// Localizar o pedido de venda para encontrar o título PR.
		SC5->( dbSetOrder( 1 ) )
		If SC5->( dbSeek( xFilial( 'SC5' ) + aAnalysis[ nI, 1 ] ) )
			If cTip == "1"
				// Se for PR = provisório baixar parcialmente.
				If SE1->E1_TIPO == 'PR '
					dBxRcb := SE1->E1_EMISSAO

					aFaVlAtuCR := FaVlAtuCr('SE1', dBxRcb)
					AAdd( aDadosBaixa, { SE1->( RecNo() ), cHistory, AClone( aFaVlAtuCR ) } )
					//Verifica se PR conta com mais saldo que titulo que ira substituli
					//pois caso positivo baixa saldo todo do PR
					nBaixa := SE1->E1_SALDO
					aBaixa := { 'SUB', nBaixa, cA6_COD, cA6_AGENCIA, cA6_NUMCON, dBxRcb, dBxRcb }
					aRet := U_CSFA530( 1, { SE1->( RecNo() ) }, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aDadosBaixa, /*aNewSE1*/ )
					aFaVlAtuCR := {}
					aDadosBaixa := {}
					aBaixa := {}
				Else
					cSql := "SELECT R_E_C_N_O_ RECE1 "
					cSql += " FROM "+RetSqlName("SE1")
					cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
					cSql += " E1_PREFIXO IN ('RCP','VDI') AND E1_TIPO IN ('NCC','PR') AND "
					cSql += " E1_PEDIDO = '"+SE1->E1_PEDIDO+"' AND "
					//cSql += " E1_PARCELA = '"+SE1->E1_PARCELA+"' AND "
					cSql += " E1_SALDO > 0 AND "
					cSql += " R_E_C_N_O_ <> "+Alltrim(Str(aAnalysis[ nI, 2 ]))+" AND "
					cSql += " D_E_L_E_T_ = ' ' "

					PLSQuery( cSql, "QRYSE1" )

					While !QRYSE1->(Eof())
						AAdd( aAuxSE1, { SC5->C5_NUM, QRYSE1->RECE1 } )
						QRYSE1->(DbSkip())
					EndDo

					QRYSE1->(DbCloseArea())

					For nX:=1 to Len(aAuxSE1)
						SE1->( dbGoTo( aAuxSE1[ nX, 2 ]) )

						// Se for PR = provisório baixar parcialmente.
						If SE1->E1_TIPO == 'PR '

							If SE1->E1_EMISSAO > dEmissao
								dBxRcb := SE1->E1_EMISSAO
							Else
								dBxRcb := dEmissao
							EndIf

							aFaVlAtuCR := FaVlAtuCr('SE1', dBxRcb)
							AAdd( aDadosBaixa, { SE1->( RecNo() ), cHistory, AClone( aFaVlAtuCR ) } )
							//PR tem sempre o saldo total baixado por esta rotina
							nBaixa := SE1->E1_SALDO

							aBaixa := { 'SUB', nBaixa, cA6_COD, cA6_AGENCIA, cA6_NUMCON, dBxRcb, dBxRcb }

							aRet := U_CSFA530( 1, { SE1->( RecNo() ) }, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aDadosBaixa, /*aNewSE1*/ )

							aFaVlAtuCR := {}

							aDadosBaixa := {}

							aBaixa := {}
						// Se for NCC = nota de crédito de cliente compensar.
						ElseIf SE1->E1_TIPO $ 'NCC'
							If SE1->E1_EMISSAO > dEmissao
								dDataBase := SE1->E1_EMISSAO
							Else
								dDataBase := dEmissao
							EndIf
							//SetdDataBase(dDataBase)
							aRet := U_CSFA530( 3, { aAnalysis[ nI , 2 ] }, /*aBaixa*/, { SE1->( RecNo() ) }, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, /*aDadosBaixa*/, /*aNewSE1*/ )
							dDataBase := Date()
							//SetdDataBase(dDataBase)
						Endif
						// Caso haja consistência de retorno, armazenar no array aLOG.
						If Type("aRet") ==  "A" .and. Len( aRet )>0
							AAdd( aLog, { AClone( aRet ) } )
							aRet := {}
						Endif
					Next nX
				EndIf
			ElseIf cTip == "2"
				If Alltrim(SE1->E1_TIPO) == "NF"
					dBxRcb := Date()
				Else
					dBxRcb := SE1->E1_EMISSAO
				EndIf

				cHistory 	:= SE1->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO ) + 'CAN'

				aFaVlAtuCR := FaVlAtuCr('SE1', dBxRcb)
				AAdd( aDadosBaixa, { SE1->( RecNo() ), cHistory, AClone( aFaVlAtuCR ) } )
				nBaixa := SE1->E1_SALDO
				aBaixa := { 'CAN', nBaixa, cA6_COD, cA6_AGENCIA, cA6_NUMCON, dBxRcb, dBxRcb }
				aRet := U_CSFA530( 1, { SE1->( RecNo() ) }, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aDadosBaixa, /*aNewSE1*/ )
				aFaVlAtuCR := {}
				aDadosBaixa := {}
				aBaixa := {}

			EndIf
		Endif
	Next nI
Return