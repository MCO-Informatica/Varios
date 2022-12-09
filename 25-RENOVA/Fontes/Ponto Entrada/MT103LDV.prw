// para devolução de vendas
User Function MT103LDV()
Local a_Campos	:= PARAMIXB[1]
Local c_AliasD2	:= PARAMIXB[2]

Local c_Nfori	:= a_Campos[14][2]
Local c_Seriori	:= a_Campos[15][2]
Local c_Itemori	:= a_Campos[16][2]
Local c_Cod		:= a_Campos[1][2]

DBSELECTAREA("SD2")
DBSETORDER(3)
IF (DBSEEK(XFILIAL("SD2")+c_Nfori+c_Seriori+cCliente+cLoja+c_Cod+c_Itemori))	
   	
   	AADD(a_Campos,{"D1_CC",SD2->D2_CCUSTO, nil})	
   	AADD(a_Campos,{"D1_ITEMCTA",SD2->D2_ITEMCC, nil})
  	AADD(a_Campos,{"D1_CLVL",SD2->D2_CLVL, nil})
   	AADD(a_Campos,{"D1_EC05DB",SD2->D2_EC05CR, nil})  
	AADD(a_Campos,{"D1_EC07DB",SD2->D2_EC07CR, nil})  
   	
        
 
ENDIF

Return(a_Campos)