#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  08/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta posição 18 a 195 do segmento N do SISPAG TRIBUTOS     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SISTRIB
Local _str := ""
Local _imp := SE2->E2_SISPAG

	If _imp = "4"    //GARE
		_str += "05"  
		_str += Alltrim(SE2->E2_CODPAG)
	    _str += "2"
	    _str += SUBSTR(SM0->M0_CGC,1,14) 
	    _str += SUBSTR(Alltrim(SM0->M0_INSC),1,12)
	    _str += STRZERO(0,13)  
	    _str += STRZE(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4) 
	    _str += STRZERO(0,13)
	    _str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14) 
	    _str += STRZERO(SE2->E2_ACRESC*100,14)
	    _str += STRZERO(0,14)
	    _str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
	    _str += STRTRAN(STRTRAN(DTOC(SE2->E2_VENCREA),"/","",1,1),"/","20")
	    _str += STRTRAN(STRTRAN(DTOC(SE2->E2_VENCREA),"/","",1,1),"/","20")
	    _str += SPACE(11)
	    _str += SUBSTR(SM0->M0_NOMECOM,1,34)  
	Endif	   
	
	If _imp == "2" //GRF
		_str += "11"                              
		_str += STRTRAN(SE2->E2_CODPAG," ","0")  
	    _str += "2"
	    _str += SUBSTR(SM0->M0_CGC,1,14)
	    _str += Alltrim(SE2->E2_CODBAR) 
	    _str += STRZERO(0,27)
	    _str += SUBSTR(SM0->M0_NOMECOM,1,30)
	    _str += STRTRAN(STRTRAN(DTOC(SE2->E2_VENCREA),"/","",1,1),"/","20")
	    _str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
	Endif
	
    If _imp == "3" //GPS
        _str += "01"                                                
		_str += Alltrim(SE2->E2_CODPAG)                                      
		_str += STRZE(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4)
		_str += SUBSTR(SM0->M0_CGC,1,14)   //SUBSTR(SE2->E2_BENEFIC,1,14)                                  
		_str += STRZERO(SE2->E2_SALDO*100,14)                               
		_str += REPLICATE("0",14)                                                
		_str += STRZERO(SE2->E2_ACRESC*100,14)                              
		_str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)              
		_str += STRTRAN(STRTRAN(DTOC(SE2->E2_VENCREA),"/","",1,1),"/","20") 
		_str += SPACE(8)                                                    
		_str += SPACE(50)                                                   
		_str += SUBSTR(SM0->M0_NOMECOM,1,30) 
    Endif           
    
	If _imp == "1" //DARF 
	   	_str += "02"
	    _str += Alltrim(SE2->E2_CODPAG)
	    _str += "2"
	    _str += SUBSTR(SM0->M0_CGC,1,14) 
	    _str += STRTRAN(STRTRAN(DTOC(SE2->E2_EMISSAO),"/","",1,1),"/","20") 
	    _str += STRZERO(0,17)  //SUBSTR(SE2->E2_BENEFIC,1,17)              
		_str += STRZERO(SE2->E2_SALDO*100,14)                               
		_str += STRZERO(SE2->E2_ACRESC*100,14)                              
		_str += REPLICATE("0",14)                                                
		_str += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)                                            
		_str += STRTRAN(STRTRAN(DTOC(SE2->E2_VENCREA),"/","",1,1),"/","20")                              
		_str += STRTRAN(STRTRAN(DTOC(SE2->E2_VENCREA),"/","",1,1),"/","20")   
		_str += SPACE(30)                                                    
		_str += SUBSTR(SM0->M0_NOMECOM,1,34)                                     
	Endif	 

Return(_str)