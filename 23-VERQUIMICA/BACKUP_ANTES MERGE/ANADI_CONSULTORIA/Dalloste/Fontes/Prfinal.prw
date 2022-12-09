#include 'protheus.ch'
#include 'parmtype.ch'

User function Prfinal()

	Local aArea       := GetArea()
	Local nPosTES     := aScan(aHeader,{|x| Upper(AllTrim(x[2]))== "UB_TES"})
	Local nPosProd    := aScan(aHeader,{|x| Upper(AllTrim(x[2]))== "UB_PRODUTO"})
	Local nPosPreco   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))== "UB_VQ_VRUN"})
	Local nPosSuf     := aScan(aHeader,{|x| Upper(AllTrim(x[2]))== "UB_VQ_VSUF"})
	Local cUF         := ""
	Local cOrigem     := ""
	Local nPrVenda    := 0
	Local nPrLiq      := 0
	Local nPIS        := 7.60
	Local nCofins     := 1.65
	Local nIpi        := 0
	Local nICMS       := 7.00
	Local nTotImp     := 0
	Local lImp        := .F.
	Local lSuframa    := .F. 

	If Len(aCols) > 0 

	    DbSelectArea("SA1")
	    DbSetOrder(1) 
	    If Dbseek(FwFilial("SB1")+M->UA_CLIENTE + M->UA_LOJA)
	       cUF := SA1->A1_EST
	       If SA1->A1_CALCSUF == "S" .AND. !Empty(SA1->A1_SUFRAMA)
	         lSuframa := .T.
	       Endif  
   	    Endif 

		DbSelectArea("SB1")
		DbSetOrder(1) 
		If Dbseek(FwFilial("SB1")+aCols[n,NPosProd])
			nIpi    := SB1->B1_IPI
			
			If SB1->B1_ORIGEM $ ("1|2|6|7")
			    lImp := .T.
				nICMS := 4.00  // Importado, ICMS 4%
			Endif
		Endif

		If lImp
	 	    nTotImp := (nCofins + nPIS + nIpi)
	 	   Else
	 	    nTotImp := (nCofins + nPIS + nIpi + nICMS)
	 	Endif    

		DbSelectArea("SF4")
		DbSetOrder(1) 
		If Dbseek(FwFilial("SF4")+aCols[n,nPosTes])
			If SF4->F4_MOTICMS = "7" .AND.  cUF $ ("AM|AP|RR|RO")  .AND. lSuframa // SUFRAMA 
				cTES     := aCols[n,nPosTes]
				nPrVenda := Round(aCols[n,NPosPreco],2)
				nPrLiq   := Round(nPrVenda - ((nPrVenda * nTotImp)/100),2)
				MsgInfo("** Preço Venda: R$ " + cValToChar(nPrVenda) + "  -  Valor S/ imposto: R$ " + cValToChar(nPrLiq),"Cliente SUFRAMA")
				aCols[n,nPosSuf] := nPrLiq
			Endif
		Endif
	Endif       

    

	RestArea(aArea)

Return cTES