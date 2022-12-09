User function F240SUMA()

	Public nValret2

nValret:=SE2->E2_SDACRES 
If SEA->EA_MODELO$ "17" .AND. SE2->E2_XVOUTRA <> 0                                                            
nValret2 := SE2->E2_XVOUTRA
EndIF 
Return nValret

User Function F240GER()
 Public nValret2 := 0
return .t. 
