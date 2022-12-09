#Include "RwMake.Ch"

//========================================================================================================================================================
//Nelson Hammel - 21/09/11 - Rotina para atualizar valores conforme preço de venda
//========================================================================================================================================================

User Function AtuVal()  

//==========================================================================================================================================================
//Só dispara a calculadora para linhas não excluidas
If acols[n,Len(aCols[n])] == .T.
Return()     
EndIf

xPPRCTAB	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRCTAB"})
xPVLRITEM 	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"})
xPVRUNIT 	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VRUNIT"})
xPOSITEMD	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESC"})

xVlrDesc	:=Round(100-((aCols[N,xPVRUNIT]*100 )/aCols[N,xPPRCTAB]),2)

If xVlrDesc>0
GDFIELDPUT("UB_DESC",xVlrDesc,N)
//TK273Calcula("UB_DESC")                                                                                        
EndIf

Return(.T.)          

