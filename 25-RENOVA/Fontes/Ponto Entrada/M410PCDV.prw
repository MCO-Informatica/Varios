// Para Devolução de Compras
#INCLUDE 'PROTHEUS.CH'
User Function M410PCDV()
Local c_AliasD1	:= PARAMIXB[1]
Local c_CC		:= (c_AliasD1)->D1_CC
Local c_ItemCta	:= (c_AliasD1)->D1_ITEMCTA  
Local c_CLVL	:= (c_AliasD1)->D1_CLVL
Local c_EC05CR	:= (c_AliasD1)->D1_EC05DB

aCols[Len(aCols)][AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_CC'})]	:= c_CC
aCols[Len(aCols)][AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_ITEMCTA'})]	:= c_ItemCta
aCols[Len(aCols)][AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_CLVL'})]	:= c_CLVL
aCols[Len(aCols)][AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_EC05CR'})]	:= c_EC05CR   


                                                                                         
Return()