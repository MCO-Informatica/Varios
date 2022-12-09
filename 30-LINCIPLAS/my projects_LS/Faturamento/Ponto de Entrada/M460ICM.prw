#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	M460ICM
// Autor 		Alexandre Dalpiaz
// Data 		19/08/2011
// Descricao  	PONTO DE ENTRADA NA GERAÇÃO DO DOCUMENTO DE SAIDA, ACERTA O CALCULO DO ICM PROPRIO PELA ALIQUOTA DA EXCEÇÃO FISCAL (SF7)
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _M460ICM()
///////////////////////

/*
		_ALIQICM 	:=nPerIcm
		_QUANTIDADE :=nQuant
		_BASEICM :=nBaseItem
		_VALICM		:=nItemIcm
		_FRETE		:=nFreteItem
		_VALICMFRETE:=nFreteIcm
		_DESCONTO	:=nDesconto
		_VALRATICM  := nValRatIcm
		_ACRESFIN   :=aTots[nElem][17]
		

*/
                                            
If Posicione('SF4',1,xFilial('SF4') + SC6->C6_TES,'F4_ICM') <> 'S'
	Return()
EndIf
If SF7->(DbSeek(xFilial('SF7') + SB1->B1_GRTRIB,.f.)) .and. SF7->F7_ALIQINT + SF7->F7_ALIQEXT > 0
	If SC5->C5_TIPO $ 'DB' 
		_ALIQICM := iif(SA2->A2_EST == SM0->M0_ESTENT,SF7->F7_ALIQINT,SF7->F7_ALIQEXT)
	Else
		_ALIQICM := iif(SA1->A1_EST == SM0->M0_ESTENT,SF7->F7_ALIQINT,SF7->F7_ALIQEXT)
	EndIf  
	_VALICM := Round(_BASEICM * _ALIQICM / 100,2)
EndIf

Return()

