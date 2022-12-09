#INCLUDE "RWMAKE.ch" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"



USER FUNCTION MTA456L()
     
 	xArea := GetArea()
    xCHAVE := SC9->C9_FILIAL+SC9->C9_PEDIDO
       
    Dbselectarea("SC9")
    DbsetOrder(1)
    Dbseek(xCHAVE)
    While !eof() .and. xCHAVE == SC9->C9_FILIAL+SC9->C9_PEDIDO
    
    	Dbselectarea("SBF")
    	DbsetOrder(2)
    	If DBseek(xFILIAL("SBF")+SC9->C9_PRODUTO+SC9->C9_LOCAL)
	   		U_TWAJEMP(SC9->C9_PRODUTO,SC9->C9_LOCAL,"","","","","","")
    	Endif
    	Dbselectarea("SC9")
    	DbsKip()
    Enddo	
    	
RestArea(xAREA)
Return()


