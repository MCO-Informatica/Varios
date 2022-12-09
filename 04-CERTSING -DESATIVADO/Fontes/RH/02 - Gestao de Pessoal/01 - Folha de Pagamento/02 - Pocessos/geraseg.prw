#include "Protheus.ch"  

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ liqplr   ¦ Autor ¦ Mariella Garagatti    ¦ Data ¦25.11.13  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Gera a verba do Seguro de Vida na folha                    ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ SIGAGPE: Roteiros de calculo da folha                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦		                 Histórico de Alterações		                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Data      ¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦ 
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/     

/* Verba base - 756 - não existe desconto parte funcionário e todos os funcionarios possuem seguro de vida. 
Valor pago do beneficio (somente parte empresa). Fórmula: ((Salário Base * 24)*0,03628%)+1  */     

User function geraSeg()
                  
Local _nSalario := SRA->RA_SALARIO              
Local _nValSeg  := 0   
Local _cDesc    := ""       
Local _nPercF   := 0
Local _nPercE   := 0  
Local _Fx1De    := 0
Local _Fx1Ate   := 0
               

	DbselectArea("SRX")
	Dbsetorder(2)
	
		If SRA->RA_SEGUROV == "01"     
	   		If DbSeek("39"+"            0101     ") 
	   			_cDesc  := SubStr(SRX->RX_TXT,1,38 ) 
				_Fx1De  := Val(SubStr(SRX->RX_TXT,39,4 ))
				_Fx1Ate := Val(SubStr(SRX->RX_TXT,43,12))
		    EndIf
		    If DbSeek("39"+"            0102     ") 
	   			_nPercF  := Val(SubStr(SRX->RX_TXT,7,2 )) 
				_nPercE  := Val(SubStr(SRX->RX_TXT,12,7 )) 
		    EndIf  
		    
		   //_nValSeg := ((_nSalario*24)*noround((_nPercE/100),7))+1
			_nValSeg := ((_nSalario*24)*noround((_nPercE/100),7))
		
		EndIf     
		 
   		If c__Roteiro == "FOL"    
            
        	If _nValSeg <> 0
          		fgeraverba("756",_nValSeg,,,,,,,,,.T.,) 	 
            EndIf
            
     	EndIf 
          
Return(.T.)  