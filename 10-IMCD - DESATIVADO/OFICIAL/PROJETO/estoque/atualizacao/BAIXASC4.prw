#INCLUDE "PROTHEUS.CH"
/*/{Protheus.doc} BAIXASC4
Baixa previsão de vendas para não gerar duplicidade de informações
@type function
@version  
@author Junior Carvalho	
@since 21/04/2021
@param cProduto, character, Codigo do Produto
@param nQuant, numeric, Quantidade 
@param lBaixa, logical, .T. Subtrair quantidade / .f. somar quantidade
@return nil
/*/
User Function BAIXASC4( cProduto, nQuant, lBaixa)
	Local lGrv := .T.
	Local dIni := FirstDate(dDatabase)
	Local dFim := LastDate(dDatabase)
	Local aAreaSD2 := SD2->( GetArea() )

	DEFAULT cProduto := " "
	DEFAULT nQuant := 0
	DEFAULT lBaixa := .T.


	dbSelectArea("SC4")
	dbSeek(xFilial("SC4")+cProduto)

	While !Eof() .And. SC4->C4_FILIAL == xFilial("SC4") .and. SC4->C4_PRODUTO = cProduto

		IF  SC4->C4_DATA >= dIni .And. SC4->C4_DATA <= dFim .AND. lGrv .and. SC4->C4_QUANT >= nQuant

			RECLOCK("SC4",.F.)
			IF lBaixa
				SC4->C4_QUANT := SC4->C4_QUANT - nQuant
			ELSE
				SC4->C4_QUANT := SC4->C4_QUANT + nQuant
			ENDIF
			MSUNLOCK()

			lGrv := .F.

		ENDIF

		DBSKIP()

	ENDDO

	SC4->(dbCloseArea())

	RestArea( aAreaSD2 )

RETURN()
