#include 'protheus.ch'

#include 'topconn.ch'

User Function ACD170VE()
Local aEtiq := PARAMIXB
Local nQE 	:= 0    
Local lTipo := .F. 
Local fFunc := ''
local lPsep := .F.

fFunc := FunName()    //SEPARAR CONTROLES PRE SEPARAÇÃO E SEPRAO  

IF fFunc <> 'ACDV165' .AND. CB7->CB7_TIPSEP == '2'      //SEPARAÇÃO e AGLUTINADA DE FRACIONADAS
	lTipo := .T.
Endif 

IF fFunc == 'ACDV165' .AND. CB7->CB7_TIPSEP == '2'      // PRE-SEPARAÇÃO e AGLUTINADA DE FRACIONADAS
	lPsep := .T.
Endif 


if lTipo

	nQE := POSICIONE("SB1",1,xFilial("SB1")+aEtiq[1],"B1_QE")   
	
	If aEtiq[2] < CB8->CB8_QTDORI
		conout("Nao ha quantidade suficiente na etiqueta")
	ElseIf aEtiq[2] > nQE
		conout("A quantidade na etiqueta e superior a quantidade por embalagem.")
	ElseIf aEtiq[2] >= CB8->CB8_QTDORI .and. aEtiq[2] <= nQE
		nQtdSob := (aEtiq[2] - CB8->CB8_QTDORI)
		conout("Quantidade na Etiqueda: "+str(aEtiq[2]))
		conout("Quantidade liberada: "+str(CB8->CB8_QTDORI))   
		conout("Quantidade fracionada: "+str(nQtdSob))   
		     

	 	
	 	CB8->(Reclock("CB8",.F.))
	    CB8->CB8_QTDFR:= nQtdSob
	  	CB8->(MsUnlock()) 
	   	
    
	   	aEtiq[2] := CB8->CB8_QTDORI   
	   	aEtiq[3]:=PARAMIXB[16] 
                                                               
		
	EndIf 
	
Return aEtiq
	
Endif  

if lPsep

	nQE := POSICIONE("SB1",1,xFilial("SB1")+aEtiq[1],"B1_QE")   
	
	If aEtiq[2] < aItens[6]  
		conout("Nao ha quantidade suficiente na etiqueta")
	ElseIf aEtiq[2] > nQE
		conout("A quantidade na etiqueta e superior a quantidade por embalagem.")
   	ElseIf aEtiq[2] >= aItens[6] .and. aEtiq[2] <= nQE 
   		nQtdSob := (aEtiq[2] - aItens[6])
		conout("Quantidade na Etiqueda: "+str(aEtiq[2]))
		conout("Quantidade liberada: "+str(aItens[6]))
		conout("Quantidade fracionada: "+str(nQtdSob))   
		     
	  	CB8->(Dbsetorder(1))
	 	
	  	IF CB8->(dbseek(xfilial('CB8')+CB7->CB7_ORDSEP+aItens[2]))  
	 	
	   	CB8->(Reclock("CB8",.F.))
	    CB8->CB8_QTDFR:= nQtdSob
	   	CB8->(MsUnlock()) 
	   	
	   	Endif
	   	      
	   	aEtiq[2] := aItens[6]  
	   	aEtiq[16]:= PARAMIXB[16]
		
	EndIf 
	
Return aEtiq
	
Endif  

aEtiq[1]:=PARAMIXB[1]
aEtiq[3]:=PARAMIXB[16]  


Return aEtiq
