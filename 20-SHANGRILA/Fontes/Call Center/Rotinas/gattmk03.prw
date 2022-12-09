#Include "RwMake.Ch"

//========================================================================================================================================================
//Nelson Hammel - 27/07/11 - Rotina para validar saldo estoque
//========================================================================================================================================================

User Function GATTMK03()  


	local aArea 		:= getArea()
	Local lRet		    := 0
	local nPosProduto	:= gdFieldPos("UB_PRODUTO")
	local nPosQtdVen	:= gdFieldPos("UB_QUANT")
	local nPosQtdSeg	:= gdFieldPos("UB_QTSEGUM")

	_xSaldoDisp := 0 //Add 19112020 - Marcos Floridi - Fix System
	_xSaldo     := 0 //Add 19112020 - Marcos Floridi - Fix System
	_xReserva   := 0 //Add 19112020 - Marcos Floridi - Fix System
	_xQtdPed    := 0 //Add 19112020 - Marcos Floridi - Fix System
	_cDesc		:= "" //Add 25112020 - Marcos Floridi - Fix System
	_xSldsDig	:= 0
	_xPosProd := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_PRODUTO"}) //Add 19112020 - Marcos Floridi - Fix System
	_xPosQtd  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_QUANT"}) //Add 19112020 - Marcos Floridi - Fix System
	_xEntPrev	:= 0
	//----------------Estoque Vinculado
	_xSld2 := 0 //Add 19112020 - Marcos Floridi - Fix System
	_xSaldo2     := 0 //Add 19112020 - Marcos Floridi - Fix System
	_xReserva2   := 0 //Add 19112020 - Marcos Floridi - Fix System
	_xQtdPed2    := 0 //Add 19112020 - Marcos Floridi - Fix System
	_xEntPrev2	 := 0
	_cDesc2		 := "" //Add 25112020 - Marcos Floridi - Fix System
	_cProdVinc   := ""
	_cDescProdVinc:= ""

	_cProdVinc := Posicione("SB1",1,xFilial("SB1")+aCols[N,_xPosProd],"B1_XPRODCB")

	/*
	Valida a quantidade Estoque - 19112020 - Marcos Floridi - Fix System
	*/

	dbSelectArea("SB2")
	dbSetOrder(1)

	SB2->(MsSeek(xFilial("SB2")+aCols[N,_xPosProd]))

	While SB2->(!Eof()).And. SB2->B2_COD == aCols[N,_xPosProd] .and. SB2->B2_LOCAL <> "98" //Add Trattiva do Armazém 98 25112020 - Marcos Fix System
		_xSaldo   += SB2->B2_QATU
		_xReserva += SB2->B2_RESERVA
		_xQtdPed  += SB2->B2_QPEDVEN
		_xEntPrev += SB2->B2_SALPEDI
		SB2->(dbSkip())
	End
	_xSaldoDisp := _xSaldo - (_xReserva + _xQtdPed + aCols[N,_xPosQtd])
	_xSldsDig	:= _xSaldo - (_xReserva + _xQtdPed)
	If _xSaldoDisp < 0
		_cDesc := "Saldo indisponível.Confirmar prazo de entrega" + Chr(13) + Chr(10)
		_cDesc += + Chr(13) + Chr(10)
		_cDesc+= Alltrim(aCols[N,_xPosProd]) + " - " + Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[N,_xPosProd],"B1_DESC"))+ Chr(13) + Chr(10)		
		_cDesc += "Saldo Atual " + Transform(_xSaldo	,"@E 999,999.99") + Chr(13) + Chr(10)
		_cDesc += "Reserva (-) " + Transform(_xReserva,"@E 999,999.99") + Chr(13) + Chr(10)
		_cDesc += "Pedidos (-) " + Transform(_xQtdPed,"@E 999,999.99") + Chr(13) + Chr(10)
		_cDesc += "Qtd Digitada (-) " + Transform(aCols[N,_xPosQtd],"@E 999,999.99") + Chr(13) + Chr(10)
		If _xSldsDig > 0
			If _xSaldoDisp < 0
				_cDesc += + Chr(13) + Chr(10)
				_cDesc += "Disponível " + Transform(_xSldsDig,"@E 999,999.99") + Chr(13) + Chr(10)
			Endif
		Elseif _xSldsDig < 0
			_cDesc += + Chr(13) + Chr(10)
			_cDesc += "Saldo Indisponível, favor contatar a Produção! " + Chr(13) + Chr(10)
		Endif
		_cDesc += + Chr(13) + Chr(10)
		_cDesc += "Ultrapassou " + Transform(_xSaldoDisp,"@E 999,999.99") + Chr(13) + Chr(10)

		_cDesc += + Chr(13) + Chr(10)
		_cDesc += "Entrada Prevista " + Transform(_xEntPrev,"@E 999,999.99") + Chr(13) + Chr(10)

		//Valida o estoque Vinculado - Campo B1_xPRODCB
		If Empty(_cProdVinc)

			ApMsgAlert(_cDesc)
		Elseif !Empty(_cProdVinc)

			dbSelectArea("SB2")
			dbSetOrder(1)

			SB2->(MsSeek(xFilial("SB2")+_cProdVinc))

			While SB2->(!Eof()).And. SB2->B2_COD == _cProdVinc .and. SB2->B2_LOCAL <> "98" //Add Trattiva do Armazém 98 25112020 - Marcos Fix System
				_xSaldo2   += SB2->B2_QATU
				_xReserva2 += SB2->B2_RESERVA
				_xQtdPed2  += SB2->B2_QPEDVEN
				_xEntPrev2 += SB2->B2_SALPEDI
				SB2->(dbSkip())
			End
			_xSld2 := _xSaldo2 - (_xReserva2 + _xQtdPed2)

			_cDesc+= "--------------------------------------------------------------------------------------------------------"+ Chr(13) + Chr(10)
			_cDesc+= "Estoque Vinculado" + Chr(13) + Chr(10)
			_cDesc+= Alltrim(_cProdVinc) + " - " + Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProdVinc,"B1_DESC"))+ Chr(13) + Chr(10)
			_cDesc += "Saldo Atual " + Transform(_xSaldo2	,"@E 999,999.99") + Chr(13) + Chr(10)
			_cDesc += "Reserva (-) " + Transform(_xReserva2,"@E 999,999.99") + Chr(13) + Chr(10)
			_cDesc += "Pedidos (-) " + Transform(_xQtdPed2,"@E 999,999.99") + Chr(13) + Chr(10)
			_cDesc += "Saldo " + Transform(_xSld2,"@E 999,999.99") + Chr(13) + Chr(10)
			_cDesc += + Chr(13) + Chr(10)
			_cDesc += "Entrada Prevista" + Transform(_xEntPrev2,"@E 999,999.99") + Chr(13) + Chr(10)
			_cDesc += + Chr(13) + Chr(10)
			_cDesc+= "--------------------------------------------------------------------------------------------------------"+ Chr(13) + Chr(10)
			If _xSld2 + (_xSaldoDisp) > 0
			_cDesc += "Disponível Total " + Transform(_xSld2 + (_xSaldoDisp) ,"@E 999,999.99") + Chr(13) + Chr(10)
			Else
			_cDesc += "Ultrapassou " + Transform(_xSld2 + (_xSaldoDisp) ,"@E 999,999.99") + Chr(13) + Chr(10)
			Endif




			ApMsgAlert(_cDesc)

		Endif

	EndIf
/*
	IF  Empty(_cProdVinc)
		Alert("Vazio")
	Elseif !Empty(_cProdVinc)
		Alert("Não Vazio")
	Endif*/


	//If retcodusr() = '000324'
	If aCols[n][nPosQtdSeg] <> INT(aCols[n][nPosQtdSeg])
		Alert("Favor validar a Qtd na 2UM !!!!")
	Endif



	//Endif
	restArea(aArea)

Return(aCols[N,_xPosQtd])   
