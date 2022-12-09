#Include 'Protheus.ch'

User Function ComSI()

	nTotal :=  AScan(aHeader,{|x| Trim(x[2])=="C7_TOTAL"})
	
	M->C7_TOTAL := nTotal
				
Return ( nil )

