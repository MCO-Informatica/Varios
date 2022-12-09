#INCLUDE "Rwmake.ch"
#INCLUDE "Average.ch"
#INCLUDE "TOPCONN.CH"

User Function FLWMAN1()

Local aAlias := GETAREA()
//Local cTudoOk     := "U_Valida()"
Local cTudoOk := .T.
local aAlter :={"ZE1_HAWB","ZE1_SEQ","ZE1_DT_EMI","ZE1_SEQ","ZE1_DT_CON","ZE1_HORA","ZE1_USER"} // campo travado a edição
local aAcho := {"ZE1_SEQ","ZE1_F_UP","ZE1_DT_PRO"}// campo a ser editado
Local nRet 
Local aParam := {} 

Public vProcesso := SW6->W6_HAWB 
Public vSeq := 1
Public vSeq2 := "001"	

Private aButtons := {}

dbselectarea("ZE1")
dbgotop()

dbselectarea("ZE1")
dbsetorder(1)
IF MsSeek(xFilial("ZE1")+SW6->W6_HAWB) 

 While ZE1->ZE1_HAWB == SW6->W6_HAWB
	 vSeq := vSeq + 1
	 
	 dbselectarea("ZE1")
	 dbskip() 
 Enddo

Endif
  
     
 vSeq2 := cValToChar(PADL(vSeq,3,"0"))

 AxInclui( "ZE1", ZE1->( LASTREC())+1, 3,,,,,,,,,,.T.)

RestArea(aAlias)

Return(vProcesso,vSeq2)                        
