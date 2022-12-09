#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINE006  ºAutor  ³Leandro Schumann    º Data ³  17/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta posição 18 a 195 do segmento N do SISPAG TRIBUTOS     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFINE006()
Local _str := ""
Local _imp := SEA->EA_MODELO 
Local _CodRec:=SUBSTR(SE2->E2_CODPAG,1,4)

	If _imp = "22"    //GARE
		_str += "05"  
		_str += _CodRec
	    _str += "2"
	    _str += SUBSTR(SM0->M0_CGC,1,14) 
	    _str += SUBSTR(Alltrim(SM0->M0_INSC),1,12)
	    _str += STRZERO(0,13)  
	    _str += GravaData(SE2->E2_DTAPURA,.F.,5) 
	    _str += STRZERO(0,13)
	    _str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14) 
	    _str += STRZERO(SE2->E2_ACRESC*100,14)
	    _str += STRZERO(0,14)
	    _str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
	    _str += GravaData(SE2->E2_VENCREA,.F.,5) 
	    _str += GravaData(SE2->E2_VENCREA,.F.,5) 
	    _str += SPACE(11)
	    _str += SUBSTR(SM0->M0_NOMECOM,1,34)  
	Endif	   
	
	If _imp == "35" //GRF
		_str += "11"                              
		_str += _CodRec
	    _str += "2"
	    _str += SUBSTR(SM0->M0_CGC,1,14)
	    _str += Alltrim(SE2->E2_CODBAR) 
	    _str += STRZERO(0,27)
	    _str += SUBSTR(SM0->M0_NOMECOM,1,30)
	    _str += GravaData(SE2->E2_VENCREA,.F.,5) 
	    _str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
	Endif
	
    If _imp == "17" //GPS
        _str += "01"                                                
		_str += _CodRec
		_str += Strzero(Month(SE2->E2_DTAPURA),2)+Strzero(Year(SE2->E2_DTAPURA),4) 
	 	If !Empty(SE2->E2_XCNPJC)
         _str += Strzero(Val(SE2->E2_XCNPJC),14)
      	Else
         _str += Subs(SM0->M0_CGC,1,14)
      	EndIf
		_str += Strzero((SE2->E2_SALDO-SE2->E2_XVLENT)*100,14)
		_str += Strzero(SE2->E2_XVLENT*100,14)     
		_str += STRZERO(SE2->E2_ACRESC*100,14)                              
		_str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)              
	    _str += GravaData(SE2->E2_VENCREA,.F.,5) 
		_str += SPACE(8)                                                    
		_str += SPACE(50)                                                   
  	  	If !Empty(SE2->E2_XCONTR)
	  	 _str += Subs(SE2->E2_XCONTR,1,30)
	  	Else
	  	 _str += Subs(SM0->M0_NOMECOM,1,30)
	    EndIf 
    Endif           
    
	If _imp == "16" //DARF 
	   	_str += "02"
	    _str += _CodRec
	    _str += "2"
	    _str += SUBSTR(SM0->M0_CGC,1,14)       
	    _str += GravaData(SE2->E2_DTAPURA,.F.,5) 	    
	    _str += STRZERO(0,17)  
		_str += STRZERO(SE2->E2_SALDO*100,14)                               
		_str += STRZERO(SE2->E2_ACRESC*100,14)                              
		_str += REPLICATE("0",14)                                                
		_str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)                                            
	    _str += GravaData(SE2->E2_VENCREA,.F.,5) 
	    _str += GravaData(SE2->E2_VENCREA,.F.,5)
		_str += SPACE(30)                                                    
		_str += SUBSTR(SM0->M0_NOMECOM,1,34)                                     
	Endif	 

Return(_str)