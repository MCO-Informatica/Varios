#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WMCQLIB   ºAutor  ³Edson Estevam       º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Na liberação do CQ atribui no campo serviço o conteudo     º±±
±±º          ³ inserido no campo Seriço de Entrada no complemento de      º±±
±±º          ³ Produtos                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Makeni                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WMCQLIB()

	Local _aArea 	     := GetArea()
	Local _aAreaB5       := SB5->(GetArea())
	Local _cproduto      := QEK->QEK_PRODUTO
	Local _nPosTipo      := aScan(aHeader,{|x| AllTrim(x[2]) == "D7_TIPO"} )
	Local _nPosServ      := aScan(aHeader,{|x| AllTrim(x[2]) == "D7_SERVIC"} )
	local _nPosTpEst     := aScan(aHeader,{|x| AllTrim(x[2]) == "D7_TPESTR" } )

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "WMCQLIB" , __cUserID )

	//Carrega o código do Produto da Tabela SD7

	_cTipo      := aCols[n,_nPosTipo]
	_cServico    :=aCols[n, _nPosServ]
	If GetMv( "MV_INTDL" ) == "S"
		If !Empty(_cProduto)
			dbSelectArea("SB5")
			dbSetOrder(1)

			If dbSeek(xFilial("SB5")+  _cproduto ,.F.)
				_cServico:= Alltrim(SB5->B5_SERVENT)
			EndIf
			aCols[n,_nPosTpEst] := "000003"
		EndIf
	EndIf

	// _cServico := "   "   // Incluido a pedido de Leomar (temporariamente)


	RestArea(_aAreaB5)
	RestArea(_aArea)

Return(_cServico)
