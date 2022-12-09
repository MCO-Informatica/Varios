#include 'protheus.ch'
#include 'parmtype.ch'

user function CALCIMP( cTipo, cTipoDoc, cCliFor, cLojaCF, cTipoCF, cCodPro, nQtdPro, nVlrUni, nVlrTot, cTES, cNatureza)

Local aAreaAtu		:= GetArea()
Local aRetorno		:= {}
Local aImpostos		:= {}
Local nValDup		:= 0
Local nValCalc		:= 0

nValCalc := (nVlrTot * 0.0465)

If nValCalc > 10 

	dbSelectArea("SC5")
	
	dbSelectArea("SED")
	dbSetOrder(1)
	dbSeek(xFilial("SED")+cNatureza)
	
	If !SED->(Found())
	
		Alert("Natureza não encontrada!")
		
		Return()
	
	End	
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+cCliFor+cLojaCF)
	
	If !SA1->(Found())
	
		Alert("Cliente não encontrado!")
		
		Return()
	
	End	
	 
	MaFisSave()
	MaFisEnd()
	
	If cTipo = "E"
	
		MaFisIni( cCliFor, cLojaCF, cTipoCF, cTipoDoc,SA1->A1_TIPO, NIL,NIL,NIL,NIL,"MATA461" )
		
	EndIf
	
	If cTipo = "S"
		
		MaFisIni( cCliFor, cLojaCF, cTipoCF, cTipoDoc,SA1->A1_TIPO, NIL,NIL,NIL,NIL,"MATA461" )
		
		MaFisGet("NF_NATUREZA")
		
		MaFisLoad("NF_NATUREZA", cNatureza)
		
		MaFisIni( cCliFor, cLojaCF, cTipoCF, cTipoDoc,SA1->A1_TIPO, NIL,NIL,NIL,NIL,"MATA461" )
		
	EndIf
	
	// 1-Codigo do Produto ( Obrigatorio )
	// 2-Codigo do TES ( Opcional )
	// 3-Quantidade ( Obrigatorio )
	// 4-Preco Unitario ( Obrigatorio )
	// 5-Valor do Desconto ( Opcional )
	// 6-Numero da NF Original ( Devolucao/Benef )
	// 7-Serie da NF Original ( Devolucao/Benef )
	// 8-RecNo da NF Original no arq SD1/SD2
	// 9-Valor do Frete do Item ( Opcional )
	// 10-Valor da Despesa do item ( Opcional )
	// 11-Valor do Seguro do item ( Opcional )
	// 11-Valor do Seguro do item ( Opcional )
	// 12-Valor do Frete Autonomo ( Opcional )
	// 13-Valor da Mercadoria ( Obrigatorio )
	// 14-Valor da Embalagem ( Opiconal )
	// 15,16,17,18,19,20,21,22 e 23
	// 24-Lote Produto
	// 25-Sub-Lote Produto
	
	MaFisAdd(cCodPro,cTes,nQtdPro,nVlrUni,0,"","",0,0,0,0,0,nVlrTot,0,,,,,,,,,,,)			
	
	aAdd( aRetorno, MaFisNFCab() )
	
	MaFisEnd()
	MaFisRestore()
	
	RestArea(aAreaAtu)
	
End If

Return( aRetorno )