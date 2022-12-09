#INCLUDE "protheus.ch"


User Function LJI701O1()

Local oRet          := PARAMIXB[1] 
Local nI            := 0
Local nTotBrinde    := 0
Local nUnitPr       :=  0
Local nItemPr       :=  0
Local nQuanty       :=  0

ConOut("Inicio PE LJI701O1: "+Time())

For nI := 1 to Len(oRet)

    //----> VERIFICA SE EXISTE PRECO ZERO (BRINDE VTEX)
    If oRet[nI]:getPropValue("UnitPrice") == 0
       
        //ConOut("Antes - ItemOrder 1: "+Str(oRet[nI]:getPropValue("ItemOrder")))
        //ConOut("Antes - ItemCode 1:  "+oRet[nI]:getPropValue("ItemCode"))

        //ConOut("Antes - Unit Price Zerado: "+Str(oRet[nI]:getPropValue("UnitPrice")))
        oRet[nI]:SetProp("UnitPrice",0.01)  
        oRet[nI]:SetProp("ItemPrice",oRet[nI]:getPropValue("Quantity")*oRet[nI]:getPropValue("UnitPrice"))
        //ConOut("Depois - Unit Price Zerado: "+Str(oRet[nI]:getPropValue("UnitPrice")))

        //----> ARMAZENA O VALOR DE 0.01 NA VARIAVEL (VALOR DO BRINDE)
        nTotBrinde := oRet[nI]:getPropValue("ItemPrice")

    Else
      
        //----> SE VALOR DO BRINDE MAIOR QUE ZERO, TIRA O VALOR DO BRINDE DE OUTRO PRODUTO 
        If nTotBrinde > 0
      
            //ConOut("Antes - ItemOrder 2: "+Str(oRet[nI]:getPropValue("ItemOrder")))
            //ConOut("Antes - ItemCode 2:  "+oRet[nI]:getPropValue("ItemCode"))

            //ConOut("Antes - Unit  Price Item: "+Str(oRet[nI]:getPropValue("UnitPrice")))
            //ConOut("Antes - Total Price Item: "+Str(oRet[nI]:getPropValue("ItemPrice")))

            nUnitPr :=  oRet[nI]:getPropValue("UnitPrice")
            nItemPr :=  oRet[nI]:getPropValue("ItemPrice")
            nQuanty :=  oRet[nI]:getPropValue("Quantity")
            
            oRet[nI]:SetProp("ItemPrice",nItemPr-nTotBrinde)  
            oRet[nI]:SetProp("UnitPrice",(nItemPr-nTotBrinde)/nQuanty)  
            

            //ConOut("Depois - nTotBrinde 2: "+Str(nTotBrinde))
            //ConOut("Depois - nUnitPr 2: "+Str(nUnitPr))
            //ConOut("Depois - nItemPr 2: "+Str(nItemPr))
            //ConOut("Depois - nQuanty 2: "+Str(nQuanty))

            nTotBrinde  :=  0
            nUnitPr     :=  0
            nItemPr     :=  0
            nQuanty     :=  0


            //ConOut("Depois - ItemOrder 2: "+Str(oRet[nI]:getPropValue("ItemOrder")))
            //ConOut("Depos - ItemCode 2:  "+oRet[nI]:getPropValue("ItemCode"))

            //ConOut("Depois - Unit  Price Item: "+Str(oRet[nI]:getPropValue("UnitPrice")))
            //ConOut("Depois - Total Price Item: "+Str(oRet[nI]:getPropValue("ItemPrice")))

            Exit

        EndIf
    
    EndIf 

Next nI 

ConOut("Fim PE LJI701O1: "+Time())

Return(oRet)
