
/*/{Protheus.doc} User Function MT461VCT
	MT461VCT - Alteração no vencimento e valor do título
	O ponto de entrada MT461VCT permite alterar o valor e o vencimento do título gerado no momento de geração da nota fiscal.
	Neste PE são implementadas as regras especificas dos clientes Twinglass que possuem acordos de datas de vencimentos especificas.
	@type  Function
	@author Pirolo
	@since 13/07/2021
	@version version
	@return _aVencto, Array, Retorna o Array com as datas de vencimentos tratadas.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784498
	/*/
User Function MT461VCT()
Local _aVencto  := ParamIxb[ 1 ]
Local _nLen     := Len( _aVencto )
Local nI        := 0

//Percorre as parcelas
For nI := 1 To _nLen
	/**
	CAIO-INDUSCAR Codigo: 002598
	O vencimento deve ocorrer as quartas de acordo com os periodos
	**/
	If SA1->A1_COD == SuperGetMv("MV_XINDUSC", , "002598")
		//Quando a data de pagamento cair entre Domingo, Segunda e Terça, os boletos deverão ser ajustado para pagamento na quarta-feira subsequente.
		If DOW(_aVencto[nI, 1]) >= 1 .AND. DOW(_aVencto[nI, 1]) <= 3
			_aVencto[nI, 1] += 4-DOW(_aVencto[nI, 1])
		
		//Quando a data de pagamento cair entre Quinta, Sexta e Sábado, os boletos deverão ser ajustados para pagamento na quarta-feira precedente.
		ElseIf DOW(_aVencto[nI, 1]) >= 5 .AND. DOW(_aVencto[nI, 1]) <= 7
			_aVencto[nI, 1] += 4-DOW(_aVencto[nI, 1])
		EndIf
	Endif

	/**
	VidroBus Código:	005862	São Paulo-SP
						018659	Fortaleza-CE
						021334	Salvador-BA

		Regra solicitada pelo cliente/representante André F. Moussa (Diretor Administrativo)

		01 02 03 04 || 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 || 20 21 22 23 24 25 26 27 28 29 30 31
	  <<------------||------------------------>13<------------------||--------------------->27<-----------<<

		Remover a condição "A VISTA"

	**/
	If SA1->A1_COD $ SuperGetMv("MV_XVIDROB", , "005862|018659|021334") 
		//Se o vencimento for do dia 1 a 4, retroage até o dia 27 do mês anterior
		If Day(_aVencto[nI, 1]) >= 1 .AND. Day(_aVencto[nI, 1]) <= 4
			While Day(_aVencto[nI, 1]) <> 27
				_aVencto[nI, 1] -= 1
			EndDo

		//Se o vencimento for entre 5 e 19
		ElseIf Day(_aVencto[nI, 1]) >= 5 .AND. Day(_aVencto[nI, 1]) <= 19
			_aVencto[nI, 1] += 13-Day(_aVencto[nI, 1])

		//Se o vencimento for entre 20 e 31
		ElseIf Day(_aVencto[nI, 1]) >= 20 .AND. Day(_aVencto[nI, 1]) <= 31
			_aVencto[nI, 1] += 27-Day(_aVencto[nI, 1])

		EndIf		
	EndIf

	/*
		Itatiaia Código:	017892 - Soretama-ES
		
	    01 02 03 04 05 06 07 08 09 10 || 11 12 13 14 15 16 17 18 19 20 || 21 22 23 24 25 26 27 28 29 30 31
      <<------------->01<-------------||-------------->10<-------------||--------------->20<---------------<<
	*/

	If SA1->A1_COD $ SuperGetMv("MV_XITATIA", , "017892") 
		//Se o vencimento for do dia 1 a 10
		If Day(_aVencto[nI, 1]) >= 1 .AND. Day(_aVencto[nI, 1]) <= 10
			_aVencto[nI, 1] += 01-Day(_aVencto[nI, 1])

		//Se o vencimento for entre 11 e 20
		ElseIf Day(_aVencto[nI, 1]) >= 11 .AND. Day(_aVencto[nI, 1]) <= 20
			_aVencto[nI, 1] += 10-Day(_aVencto[nI, 1])

		//Se o vencimento for entre 21 e 31
		ElseIf Day(_aVencto[nI, 1]) >= 21 .AND. Day(_aVencto[nI, 1]) <= 31
			_aVencto[nI, 1] += 20-Day(_aVencto[nI, 1])

		EndIf
	EndIf

	/**
		Esmaltec Código:	003144 - Maracanau-CE

	        01       02~11  ||   12~21   ||   22~(*ULTIMO DIA DO MÊS)
      	>-->01>------>11>---||--->21>----||--->01>--->
	  MÊS (ATUAL)   (ATUAL)     (ATUAL)     (PROXIMO)

	**/
	If SA1->A1_COD $ SuperGetMv("MV_XESMALT", , "003144")
		//Se o vencimento for do dia 2 a 11
		If Day(_aVencto[nI, 1]) >= 2 .AND. Day(_aVencto[nI, 1]) <= 11
			_aVencto[nI, 1] += 11-Day(_aVencto[nI, 1])

		//Se o vencimento for entre 12 e 21
		ElseIf Day(_aVencto[nI, 1]) >= 12 .AND. Day(_aVencto[nI, 1]) <= 21
			_aVencto[nI, 1] += 11-Day(_aVencto[nI, 1])

		//Se o vencimento for entre 12 e 21
		ElseIf Day(_aVencto[nI, 1]) >= 12 .AND. Day(_aVencto[nI, 1]) <= 21
			_aVencto[nI, 1] += 21-Day(_aVencto[nI, 1])

		//Se o vencimento for entre 22 e 31
		ElseIf Day(_aVencto[nI, 1]) >= 22 .AND. Day(_aVencto[nI, 1]) <= 31
			//Avança até o proximo dia 1
			While Day(_aVencto[nI, 1]) <> 1
				_aVencto[nI, 1] += 1
			EndDo
		EndIf
	EndIf

	/*
		IRIZAR Codigo:	002613
		Sempre gera vencimentos no dia 15 mudando apenas o mês de acordo com o período

	*/
	If SA1->A1_COD $ SuperGetMv("MV_XIRIZAR", , "003144")
		//Se o vencimento for entre 01 e 15
		If Day(_aVencto[nI, 1]) <= 15
			_aVencto[nI, 1] += 15-Day(_aVencto[nI, 1])
		Else
			//Avança até o proximo dia 1
			While Day(_aVencto[nI, 1]) <> 15
				_aVencto[nI, 1] += 1
			EndDo
		EndIf
	EndIf
Next

Return( _aVencto )
