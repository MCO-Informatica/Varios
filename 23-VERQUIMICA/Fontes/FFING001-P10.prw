#include "rwmake.ch" 

User Function _NumAGCTA()
Local _cAGCTA := ""
Local _cConta := ALLTRIM(SA2->A2_NUMCON)+ IIF(!Empty(SA2->A2_DVCTA),ALLTRIM(SA2->A2_DVCTA),"")
IF ALLTRIM(SA2->A2_BANCO) == "341"  .OR.  ALLTRIM(SA2->A2_BANCO) == "409"
	_cAGCTA:="0"+SUBST(SA2->A2_AGENCIA,1,4)+" 0000000"+SUBSTR(SA2->A2_NUMCON,1,5)+" "+SUBSTR(SA2->A2_NUMCON,6,1)    
	//_cAGCTA:="0"+SUBSTR(SA2->A2_AGENCIA,1,4)+" "+Replicate("0",6) + StrZero(Val(SA2->A2_NUMCON),6,0)+" "+StrZero(Val(SA2->A2_NUMCON),6,0)
Else
	_cAGCTA:=STRZERO(VAL(SA2->A2_AGENCIA),5) +" "+STRZERO(VAL(SUBSTR(_cConta,1,LEN(_cConta)-1)),12)+" "+RIGHT(_cConta,1)
EndIf

Return (_cAGCTA )

User Function _TCODD()
Local _cod := "34191124812351197025570994400003339300000580041 "
U_CFING001(_cod,"1")
Return

User Function _TCODL()
Local _cod := "34198393300000031161124720549423129002527000 "  
U_CFING001(ALLTRIM(_cod),"1") 
Return 

User Function CFING001(_cCodBar,_cTipoProc)

Local _cRetorno := ""
Local _nTam := Len(ALLTRIM(_cCodBar))
If _nTam < 44
	_cCodBar := ALLTRIM(_cCodBar)+REPLICATE("0",47-_nTam) 
EndIf
Do Case
	    Case _cTipoProc == 1 //banco
	    	_cRetorno := _banco(_cCodBar)
	    Case _cTipoProc == 2 //moeda
		    _cRetorno := _moeda(_cCodBar)
	    Case _cTipoProc == 3 //dv
			_cRetorno := _DV(_cCodBar)
		Case _cTipoProc == 4 //fator + valor
			_cRetorno := _fvalor(_cCodBar)				
		Case _cTipoProc == 5 //livre
			_cRetorno := _livre(_cCodBar)
	    OtherWise
	    
	    EndCase
//Alert(STR(_nTAM))
Return(_cRetorno) 

Static Function _banco(_cCodBar) 
Local _cBanco :=""       
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cBanco := SUBSTR(_cCodBar,1,3)                                  
	ElseIf _nTam == 47
		_cBanco := SUBSTR(_cCodBar,1,3) 
	EndIf

Return(_cBanco)

Static Function _moeda(_cCodBar)
Local _cMoeda :="" 
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cMoeda := SUBSTR(_cCodBar,4,1)                                                                    
	ElseIf _nTam == 47
		_cMoeda := SUBSTR(_cCodBar,4,1) 
	EndIf

Return(_cMoeda)

Static Function _DV(_cCodBar)
Local _cDV :=""
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44 
    	_cDV := SUBSTR(_cCodBar,5,1)                                                                    
  //  	Alert(_cDV)
	ElseIf _nTam == 47
		_cDV := SUBSTR(_cCodBar,33,1)
	//	Alert(_cDV) 
	EndIf          
//	Alert(_cCodBar)
Return(_cDV)       



Static Function _fvalor(_cCodBar)
Local _cValor :=""
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cValor := STRZERO(VAL(SUBSTR(_cCodBar,6,14)),14)                                                                    
	ElseIf _nTam == 47
		_cValor := SUBSTR(_cCodBar,34,14) 
	EndIf

Return(_cValor)       

Static Function _livre(_cCodBar)
Local _cLivre :="" 
Local _nTam := Len(ALLTRIM(_cCodBar))
	If _nTam == 44
    	_cLivre := SUBSTR(_cCodBar,20,25)                                                                    
	ElseIf _nTam == 47
		_cLivre := SUBSTR(_cCodBar,5,5) +SUBSTR(_cCodBar,11,10)+SUBSTR(_cCodBar,22,10)
	EndIf

Return(_cLivre)


User Function _Trib1() 


LOCAL __nVal:= ""
Local _Chv := SE2->E2_NUMBOR + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
Local nVALOR := 0	

_Mod := SUBSTR(POSICIONE("SEA",1,xFilial("SEA")+_Chv,"EA_MODELO"),1,2)

If SEA->EA_MODELO == "24"
nVALOR :=  STRZERO(ROUND(SE2->E2_VALOR+SE2->E2_ACRESC-SE2->E2_DECRESC,2)*100,12)
Else
nVALOR := STRZERO(ROUND(SE2->E2_DECRESC,2)*100,12)
EndIf   
			 
RETURN ( nVALOR )
