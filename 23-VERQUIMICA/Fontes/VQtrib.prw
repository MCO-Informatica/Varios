User Function vqTrib()
Local cRet
Local _Tiptrib := SE2->E2_XGPS01

     _vValor  := STRZERO(SE2->E2_VALOR*100,14)
     _vJuros  := STRZERO(SE2->E2_ACRESC*100, 14)  
     _vOutras := STRZERO(SE2->E2_XVOUTRA*100, 14)
     _vDescont:= STRZERO(SE2->E2_DECRESC*100, 14)
     _vTotal  := STRZERO(((SE2->E2_VALOR+SE2->E2_ACRESC+SE2->E2_XVOUTRA)-SE2->E2_DECRESC )*100,14)

DO CASE 

//GPS
  CASE _Tiptrib == "01"
             
     cRet := ALLTRIM(SE2->E2_XGPS01) + PadR(SE2->E2_XGPS02,4) + SUBSTR(ALLTRIM(SE2->E2_XGPS03),1,6) + SUBSTR(SE2->E2_XCNPJ01,1,14) + _vValor + _vOutras + _vJuros + _vValor
     cRet += GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(08) + SPACE(50) + SUBSTR(SA2->A2_NOME,1,30)

//DARF                                                                  
  CASE _Tiptrib == "02" 
  
     IF !EMPTY(SE2->E2_CODBAR)
     
     cRet := ALLTRIM(SE2->E2_XGPS01) + SUBSTR(SE2->E2_CODBAR,40,4) + "2" + SUBSTR(SM0->M0_CGC,1,14) + ALLTRIM(SE2->E2_XDARF03) + SPACE(17) + _vValor
     cRet += _vOutras + _vJuros + _vValor + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(30) + SUBSTR(SA2->A2_NOME,1,30)
     
     ELSE     

     cRet := ALLTRIM(SE2->E2_XGPS01) + ALLTRIM(SE2->E2_XFGTS02) + "2" + SUBSTR(SE2->E2_XCNPJ01,1,14) + ALLTRIM(SE2->E2_XDARF03) + SPACE(17) + _vValor
     cRet += _vOutras + _vJuros + _vValor + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(30) + SUBSTR(SA2->A2_NOME,1,30)
          
     ENDIF                                                                 

//DARF SIMPLES   
  CASE _Tiptrib == "03"	
       
     cRet := ALLTRIM(SE2->E2_XGPS01) + ALLTRIM(SE2->E2_XFGTS02) + "2" + SUBSTR(SE2->E2_XCNPJ01,1,14) + ALLTRIM(SE2->E2_XDARF03) + "000000000" + "0000" + SPACE(4) + _vValor
     cRet += _vOutras + _vJuros + _vValor + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(30) + SUBSTR(SA2->A2_NOME,1,30)

//ICMS                                                                                                                                                                                                 
  CASE _Tiptrib == "05"
                                                                                                                                                                  
     cRet := ALLTRIM(SE2->E2_XGPS01) + ALLTRIM(SE2->E2_XFGTS02) + "2" + SUBSTR(SM0->M0_CGC,1,14) + SUBSTR(SM0->M0_INSC,1,12) + "0000000000000" + STRZE(MONTH(SE2->E2_EMISSAO),2)+STR(YEAR(SE2->E2_EMISSAO),4)    
     cRet += "0000000000000" + _vValor + _vJuros + _vOutras + _vValor + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(11) + SUBSTR(SM0->M0_NOME,1,30)
  
//IPVA   
  CASE _Tiptrib $ "07/08"
     //R
     cRet := ALLTRIM(SE2->E2_XGPS01) + SPACE(4) + "2" + SUBSTR(SM0->M0_CGC,1,14) + DTOS(SE2->E2_EMIS1,4,4) + SUBST(SE2->E2_XIPVA02,4,9) + SM0->M0_ESTENT + SUBST(SM0->M0_CODMUN,3,5)    
     cRet += SUBSTR(SE2->E2_XIPVA05,1,7) + SE2->E2__CODPAG + _vValor + _vJuros + _vOutras + _vValor + GRAVADATA(SE2->E2_VENCREA,.F.,5) + GRAVADATA(SE2->E2_VENCREA,.F.,5) + SPACE(29) + SPACE(29) + SUBSTR(SM0->M0_NOME,1,30)

//FGTS
  CASE _Tiptrib == "11"
     
		cRet := ALLTRIM(SE2->E2_XGPS01) + SUBSTR(SE2->E2_XFGTS02,1,4) + "1" + SUBSTR(SM0->M0_CGC,1,14) + SubStr(SE2->E2_LINDIG,1,48) + SUBSTR(SE2->E2_XFGTS04,1,16) + SUBSTR(SE2->E2_XFGTS05,1,9) + SUBSTR(SE2->E2_XFGTS06,1,2) + SUBSTR(SM0->M0_NOME,1,30)  
  	 	cRet += GRAVADATA(SE2->E2_VENCREA,.F.,5) + _vValor + SPACE(30)
     
  OTHERWISE
     
ENDCASE 

Return(Subs(cRet,3))                     
