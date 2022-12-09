#INCLUDE "Protheus.ch"


User Function GATFAT01(cCampo)
Local cRet := ""        
local nPTes     := GDFIELDPOS("C6_TES")
local nPCfop    := GDFIELDPOS("C6_CF")
local nPSitTrib := GDFIELDPOS("C6_CLASFIS")
Local aArea := GetArea()
Local cEst := ""
Local cTpCli := M->C5_TIPOCLI

dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,.f.)
	cEst := SA1->A1_EST
Else
	MsgAlert("Cliente nao Encontrado")	
EndIf

Do Case
	Case cCampo == "C6_TES" 

	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+M->C6_PRODUTO,.F.)
	
		dbSelectArea("SF7")
		dbSetOrder(1)
		If dbSeek(xFIlial("SF7")+SB1->B1_GRTRIB,.F.)     
		
			While Eof() == .f. .And. SF7->F7_FILIAL+SF7->F7_GRTRIB == xFilial("SF7")+SB1->B1_GRTRIB
				
				If SF7->F7_EST == cEst
					If SF7->F7_MARGEM > 0
	  					acols[n][nPTes] 	:= Iif(cFilAnt$"0101","5V5","5B5") 
						acols[n][nPCfop] 	:= Iif(cFilAnt$"0101",Iif(cEst$"SP","5401","6401"),Iif(cEst$"SP","5405","6404"))
						acols[n][nPSitTrib]	:= Iif(cFilAnt$"0101","010","")
					Else
			  			acols[n][nPTes] 	:= Iif(cFilAnt$"0101","5V1","5B1")
						acols[n][nPCfop] 	:= Iif(cFilAnt$"0101",Iif(cEst$"SP","5101","6101"),Iif(cEst$"SP","5102","6102"))
						acols[n][nPSitTrib]	:= Iif(cFilAnt$"0101","000","")
					EndIf
				EndIf
							
				dbSelectArea("SF7")
			    dbSkip()
			EndDo
	    Else
  			acols[n][nPTes] 	:= Iif(cFilAnt$"0101","5V1","5B1")
			acols[n][nPCfop] 	:= Iif(cFilAnt$"0101",Iif(cEst$"SP","5101","6101"),Iif(cEst$"SP","5102","6102"))
			acols[n][nPSitTrib]	:= Iif(cFilAnt$"0101","000","")
		EndIf
	    
	    If cTpCli$"F"
  			acols[n][nPTes] 	:= Iif(cFilAnt$"0101","5V1","5B1")
			acols[n][nPCfop] 	:= Iif(cFilAnt$"0101",Iif(cEst$"SP","5101","6107"),Iif(cEst$"SP","5102","6108"))
			acols[n][nPSitTrib]	:= Iif(cFilAnt$"0101","000","")
	    EndIf
		
		If M->C5_X_FPAGT == "O"
	    	acols[n][nPTes] 	:= Iif(cFilAnt$"0101","5V9","5B9")
	    	acols[n][nPCfop] 	:= Iif(cFilAnt$"0101",Iif(cEst$"SP","5910","6910"),Iif(cEst$"SP","5910","6910"))
			acols[n][nPSitTrib]	:= Iif(cFilAnt$"0101","040","")
	    EndIf
    EndIf
End Case

cRet := acols[n][nPTes]

RestArea(aArea)

Return cRet