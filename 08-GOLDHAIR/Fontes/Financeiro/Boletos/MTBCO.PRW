#include "rwmake.ch"  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                  
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTBCO     º Autor ³Marcel Medeiros     º Data ³  17/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ SELECAO DE BANCO PARA IMPRESSAO DO BOLETO GRAFICO          º±±
±±º          ³                                                            º±±         
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5 IDE                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º							                                                ±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                                                                       º±±  
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MtBco(_aBoletos,_lAutomatico,_cPrefIni,_cPrefFim,_cNumeIni,	_cNumeFim,_cParcIni,	_cParcFim,_cTipoIni,_cTipoFim,_dEmisIni,_dEmisFim,_lVisualizar,_lConfigurar)
//Gravacao dos dados necessarios a emissao do boleto de cobranca
Local _aArea   := getarea()
Local _aImpBol := {}                                                                  
Local _vBoletos:={}                                                                                                     
                                                                                              
For nLoop:=1 to len(_aBoletos)     
//	If _aBoletos[nLoop,1]           
	   SE1->(DbGoto(_aBoletos[nLoop,17]))
	   _fProcCodBco(_aBoletos[nLoop,3],_aBoletos[nLoop,2],_vBoletos,_lAutomatico,_cPrefIni,_cPrefFim,_cNumeIni,	_cNumeFim,_cParcIni,	_cParcFim,_cTipoIni,_cTipoFim,_dEmisIni,_dEmisFim,_lVisualizar,_lConfigurar)
//	EndIf   
Next nLoop

U_fImpBar(_lAutomatico,_cPrefIni,_cPrefFim,_cNumeIni,	_cNumeFim,_cParcIni,	_cParcFim,_cTipoIni,_cTipoFim,_dEmisIni,_dEmisFim,_lVisualizar,_lConfigurar,_aBoletos)

Restarea(_aArea)

Return

Static Function _fProcCodBco(_cNumero,_cPrefixo,_vBoletos,_lAutomatico,_cPrefIni,_cPrefFim,_cNumeIni,	_cNumeFim,_cParcIni,	_cParcFim,_cTipoIni,_cTipoFim,_dEmisIni,_dEmisFim,_lVisualizar,_lConfigurar)

Local _vAmbSe1    :=se1->(getarea())
Local _vAmbSa1    :=sa1->(getarea())
Local _cNumBar    := ""
Local _cNossoNum  := ""

private _cDigBar  := ""
Private _cDigCor  := ""
Private _nDigtc3  := 0
Private _cNossoNd :=""
DBSELECTAREA("SE1")
se1->(dbsetorder(1)) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
se1->(dbseek(xfilial()+_cPrefixo+_cNumero,.f.))
//_cParcIni:=_cParcFim:=nil
do while se1->(!eof().and.e1_filial+e1_prefixo+e1_num==xfilial()+_cPrefixo+_cNumero)   
   DBSELECTAREA("SE1")
	if _cParcIni==nil
		_cParcIni:=se1->e1_parcela                                                 
		_cPrefixo:=se1->e1_prefixo
		_cNum    :=se1->e1_num                  
	endif
	                            
	                                                                                       
   	
 If !se1->("-"$e1_tipo )  .AND.  ( empty(E1_NUMBCO)   .or.  left( se1->e1_coddig,3 )<>se1->e1_portado .OR.   LEN(alltrim(se1->e1_coddig) )<>47  .OR.   LEN(alltrim(se1->e1_codBAR) )<>44   )
  
  /*      
  // TEMPORARIO LINHA ABAIXO APENAS PARA FAZER TESTES COM O CODIGO DE BARRA                                 
   If aLLTRIM(SE1->E1_NUM)="048001" .oR. aLLTRIM(SE1->E1_NUM)="048006" .OR. aLLTRIM(SE1->E1_NUM)="048007";
   .OR. aLLTRIM(SE1->E1_NUM)="048008" .oR. aLLTRIM(SE1->E1_NUM)="048009" .OR. aLLTRIM(SE1->E1_NUM)="048010";
   .OR. aLLTRIM(SE1->E1_NUM)="048011" .oR. aLLTRIM(SE1->E1_NUM)="048012" .OR. aLLTRIM(SE1->E1_NUM)="048013" .oR. aLLTRIM(SE1->E1_NUM)="048014";
   .OR. aLLTRIM(SE1->E1_NUM)="048015" .Or. aLLTRIM(SE1->E1_NUM)="048000" .OR. aLLTRIM(SE1->E1_NUM)="048016" .OR.;
   aLLTRIM(SE1->E1_NUM)="048017" 
    */                                                                                         
                                                                                         
                                                                     
//  If aLLTRIM(SE1->E1_NUM)="048016" .oR. aLLTRIM(SE1->E1_NUM)="048017" .OR. aLLTRIM(SE1->E1_NUM)="048018" .OR. aLLTRIM(SE1->E1_NUM)="048019" .Or.;
//     aLLTRIM(SE1->E1_NUM)="048020"
                                                                        
 		//		If se1->e1_boleto == "S"
		// Gravacao do nosso numero                                         
		_cBanco:=_cAgencia:=_cConta:=""         
		_cBanco   :=se1->e1_portado                                                               
		If _cBanco=="237"
		   _cAgencia :="0064"  //se1->e1_agedep
		   _cConta   :="311840"  // se1->e1_conta
		   _cAgenciaz :=se1->e1_agedep    
		   _cContaz   :=se1->e1_conta 
		Else 
		   _cAgencia :=se1->e1_agedep  
		   _cConta   :=se1->e1_conta                                            
		   _cAgenciaz :=se1->e1_agedep
		   _cContaz   :=se1->e1_conta 
		EndIf                                                 
		_cNossoNum:=""
		see->(dbsetorder(1)) // EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
		see->(dbseek(xfilial()+_cBanco+_cAgenciaz+_cContaz))
		do case
			case _cBanco=="001"
				_cNossoNum:=Nosso001()
			case _cBanco=="479"
				_cNossoNum:=Nosso341()
			case _cBanco=="341"
				_cNossoNum:=Nosso341()
			case _cBanco=="104"
				_cNossoNum:=Nosso104()
			case _cBanco=="399"
			    _cNossoNum:=Nosso399()
			case _cBanco=="237"
				_cNossoNum:=Nosso237()
			case _cBanco=="033"
				_cNossoNum:=Nosso033()	
		endcase
		_cNossoNum:=alltrim(_cNossoNum)
		_cNossoNd :=alltrim(_cNossoNum)
		_cNossoDig:=right(_cNossoNum,1)
		_cNossoNum:=left(_cNossoNum,len(_cNossoNum)-1)
		_cDigBar:=""
		
		If _cBanco<>"033"
		   _cNumBar:=_fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
		   _cNumBol:=_fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)                                
		Else 
		   _ares:=Ret_cBarra(_cBanco,_cAgencia,_cConta," ",_cNossoNd,se1->e1_valor,se1->e1_vencto,"9",Substr(SEE->EE_CODEMP,1,7))
		   _cNumBar:=_ares[1]
		   _cNumBol:=_ares[2]
		Endif   
		
		if !empty(_cNossoNum).or.!empty(_cNumBar).or.!empty(_cNumbol)              
			if se1->(reclock(alias(),.f.))
				se1->e1_numbco  :=_cNossoNum + _cNossoDig
				if _cBanco<>'399'
					se1->e1_codbar  :=_cNumBar
					se1->e1_coddig  :=_cNumBol                                               
					se1->e1_numbco  :=_cNossoNd
					//SE1->E1_DATAEDI:=DDATABASE
					//SE1->E1_HIST   := _cNossoNd 
				else
				    se1->e1_codbar  :=_cNumBar
					se1->e1_coddig  :=_cNumBol 
					se1->e1_numbco  :=_cNossoNd                                                                                                                                                
					//se1->e1_codbar  :=_cNumBol
					//se1->e1_coddig  :=_cNumBar        
					//SE1->E1_HIST   := _cNossoNd   
  				  //SE1->E1_DATAEDI:=DDATABASE
				endif
				se1->e1_situaca :="0"
				se1->(msunlock())
			endif
		Endif
	Endif
	//	 nRegSe1 := SE1->(RECNO())
	//	U_fImpBar(_lAutomatico,_cPrefIni,_cPrefFim,_cNumeIni,	_cNumeFim,_cParcIni,	_cParcFim,_cTipoIni,_cTipoFim,_dEmisIni,_dEmisFim,_lVisualizar,_lConfigurar)
	//   SE1->(DBGOTO( nRegSE1 ) )
	se1->(dbskip(1))                   
	
enddo                                                                                                                                                         
retindex("SA1")
retindex("SE1")                                                                

Return

*-----------------------------------------------------------------------------
static function _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
*-----------------------------------------------------------------------------
local _cNumBol,_cNossoNu1:=_cNossoNum,_nVez
for _nVez:=1 to len(_cNossoNum)
	if substr(_cNossoNum,_nVez,1)=="0"
		_cNossoNu1:=right(_cNossoNu1,len(_cNossoNu1)-1)
	else
		exit
	endif
next

do case

case _cBanco=="237" // Bradesco
		_cCampo1:=_cBanco+;
		"9"+;  
		substr(_cNumBar,20,5)
		_cDig1:=_fDigVer(_cCampo1,_cBanco)
		
		_cCampo2:=substr(_cNumBar,25,10)
		_cDig2:=_fDigVer(_cCampo2,_cBanco)
		
		_cCampo3:=substr(_cNumBar,35,10)
		_cDig3:=_fDigVer(_cCampo3,_cBanco)
		
		_cCampo4:=_cDigBar
		
		_cCampo5:=substr(_cNumBar,06,14)
		
		_cNumBol:=_cCampo1+_cDig1+_cCampo2+_cDig2+_cCampo3+_cDig3+_cCampo4+_cCampo5

//00198393300000000350000001534999000000723117                                        	
case _cBanco=="001" //Bco do Brasil
/*
        _cCampo1:=_cBanco+;
              "9"+;
                Substr(_cNumBar,20,5)
    		   _cDig1:=_fDigVer(_cCampo1,_cBanco)      
        
        _cCampo2:=substr(_cNumBar,25,10)
        _cDig2:=_fDigVer(_cCampo2,_cBanco)

        _cCampo3:=substr(_cNumBar,35,10)
        _cDig3:=_fDigVer(_cCampo3,_cBanco)

        _cCampo4:=_cDigBar

        _cCampo5:=substr(_cNumBar,06,4)+;
                  strzero(se1->e1_valor*100,10)       

        _cNumBol:=_cCampo1+_cDig1+_cCampo2+_cDig2+_cCampo3+_cDig3+_cCampo4+_cCampo5
        
  */      
//        ----
        _cCampo1:=_cBanco+;
              "9"+;
                Substr(_cNumBar,20,5)
    		   _cDig1:=_fDigVer(_cCampo1,_cBanco)      
        
        _cCampo2:=substr(_cNumBar,25,10)
        _cDig2:=_fDigVer(_cCampo2,_cBanco)

        _cCampo3:=substr(_cNumBar,35,10)
        _cDig3:=_fDigVer(_cCampo3,_cBanco)

        _cCampo4:=_cDigBar                             

        _cCampo5:=substr(_cNumBar,06,4)+;
                  strzero(se1->e1_valor*100,10)       

        _cNumBol:=_cCampo1+_cDig1+_cCampo2+_cDig2+_cCampo3+_cDig3+_cCampo4+_cCampo5

case _cBanco=="399"   // HSBC    
     
     _banco := "399"
     _moeda := "9"                                                           
     _nosso := SubStr(_cNossoNd,1,5)  // _cNossoNum _cNossoNd    //SubStr(_cNossoNum,1,5) 
     _digt  :=CalcDigM11(_banco+_moeda+_nosso,1)
     _camres:=_banco+_moeda+_nosso+_digt

     _nosso :=SubStr(_cNossoNd,6,6) 
     _age   :=SUBSTR(_cAgencia,1,4)
     
     _digt  :=CalcDigM11(_nosso+_age,2)
     _camres+=_nosso+_age+_digt
     
     If Len(Alltrim(_cConta))<7
        _cont  :=SUBSTR(STRZERO(Val(_cConta),8),1,7)
     Else
        _cont  :=Alltrim(_cConta)
     EndIf     
     _cart  :="00"
     _capli :="1"                              
     _digt  :=CalcDigM11(_cont+_cart+_capli,2)
     _camres+=_cont+_cart+_capli+_digt
     _camres+=SubStr(_cNumBar,5,1)+strzero(se1->e1_vencto-ctod("07/10/1997"),4)+strzero(se1->e1_valor*100,10)
     _cNumBol := _camres                                        

/*
     cValor := STRZERO(se1->e1_valor,14,2)
     
     cNewValor := ""
     nZeros := 0
     for i:=1 to len(cValor)
          if Substr(cValor,i,1) # "." .and. Substr(cValor,i,1) # ","
               cNewValor += Substr(cValor,i,1)
          ELSE
               nZeros ++
          endif
     next
     cValor := ""
     For i:=1 to nZeros
          cValor += "0"
     next

  	cValor 	+= Substr(Alltrim(cNewValor),5,10)
    cFatorVen	:= strzero(se1->e1_vencto-ctod("07/10/1997"),4)           
	cNumDig10 	:= _cBanco + "0" + cFatorVen + cValor + SUBSTR(_cAgencia,1,4) + _cNossoNum + SUBSTR(STRZERO(Val(_cConta),8),1,7) +"0"

	cDigVerif := CalcDigM11(cNumDig10)
	cQuaGrupo := cDigVerif
	cFatorVen:=strzero(se1->e1_vencto-ctod("07/10/1997"),4)

    cValor := STRZERO(se1->e1_valor,14,2)
     
     cNewValor := ""
     nZeros := 0
     for i:=1 to len(cValor)
          if Substr(cValor,i,1) # "." .and. Substr(cValor,i,1) # ","
               cNewValor += Substr(cValor,i,1)
          ELSE
               nZeros ++
          endif
     next
     cValor := ""
     For i:=1 to nZeros
          cValor += "0"
     next
     cValor += Substr(Alltrim(cNewValor),5,10)


		//_cNumBol := _cBanco + "0" +cQuaGrupo + cFatorVen + cValor +SUBSTR(_cAgencia,1,4)+  _cNossoNum + SUBSTR(STRZERO(Val(_cConta),8),1,7) +"0"
	 _cNumBol := _cBanco + "9" +cQuaGrupo + cFatorVen + cValor +SUBSTR(_cAgencia,1,4)+  _cNossoNum + SUBSTR(STRZERO(Val(_cConta),8),1,7) +"0"	                  
	 
	 */
	
case _cBanco=="104"	// Caixa Economica

     _banco := SubStr(_cNumBar,1,3)
     _moeda := SubStr(_cNumBar,4,1)
     _nosso := SubStr(_cNumBar,20,5)
     _digt  :=CalcDigM11(_banco+_moeda+_nosso,1)
     _camres:=_banco+_moeda+_nosso+_digt

     _nosso :=SubStr(_cNumBar,25,10)
     
     _digt  :=CalcDigM11(_nosso,2)           
     _camres+=_nosso+_digt            
                                                                    
     _cont  :=SubStr(_cNumBar,35,10)
     _digt  :=CalcDigM11(_cont,2)
     _camres+=_cont+_digt
     _camres+=SubStr(_cNumBar,5,1)+SubStr(_cNumBar,6,4)+SubStr(_cNumBar,10,10)
     _cNumBol := _camres                                                   

                                                            
/*
 			_cCampo1:=_cBanco+;
              "9"+;
         Substr(_cNumBar,19,5)
			_cDig1:=_fDigVer(_cCampo1,_cBanco)   
					 
			_cCampo2:=substr(_cNumBar,24,10)
        _cDig2:=_fDigVer(_cCampo2,_cBanco)

			_cCampo3:="70000000"+_cNossoDig
			_cDig3:=_fDigVer(_cCampo3,_cBanco)     
			
			if val(subs(_cNumBar,05,14))==0
				_cCampo4:="            000"
			else
			   _cCampo4:=Str(Val(Subs(_cNumBar,05,14)),14)
			endif
			
			_cNumBol:=_cCampo1+_cDig1+_cCampo2+_cDig2+_cCampo3+_cDig3+_cCampo4								                              
			
			*/
		
case _cBanco=="341" // Itau
		_cCampo1:=_cBanco+;
		"9"+;
		see->ee_cart+;
		left(_cNossoNum,2)
		
		_cDig1:=_fDigVer(_cCampo1,_cBanco)
		
		_cCampo2:=substr(_cNossoNum,3)+;
		_cNossoDig+;
		left(_cAgencia,3)
		
		_cDig2:=_fDigVer(_cCampo2,_cBanco)
		
		_cCampo3:=substr(_cAgencia,4,1)+;
		iif(len(alltrim(_cConta))> 6,substr(alltrim(_cConta),2,6),substr(alltrim(_cConta),1,6))+;
		"000"
		
		_cDig3:=_fDigVer(_cCampo3,_cBanco)
		
		_cCampo4:=_cDigBar
		_cCampo5:=strzero(se1->e1_vencto-ctod("07/10/1997"),4)+; // fator vencimento
		strzero(se1->e1_valor*100,10)
		
		_cNumBol:=_cCampo1+_cDig1+_cCampo2+_cDig2+_cCampo3+_cDig3+_cCampo4+_cCampo5
		
case _cBanco=="479" // Banco de Bostom / Itau
		
		_cCampo1:=_cBanco+;
		"9"+;
		"001526"
		
		_cCampo2:="20600000002"
		
		_cCampo3:=_cNossoNu1+;
		_cNossoDig+;
		"8"
		_cDig3:=_fDigVer(_cCampo3,_cBanco)
		
		_cCampo4:=_cDigBar
		
		_cCampo5:=strzero(se1->e1_vencto-ctod("07/10/1997"),4)+; // fator vencimento
		strzero(se1->e1_valor*100,10)
		_cNumBol:=_cCampo1+_cCampo2+_cCampo3+_cDig3+_cCampo4+_cCampo5
		
endcase	

return _cNumBol

*-----------------------------------------------------------------------------
static function _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,_cDigBar,_cNossoDig)
*-----------------------------------------------------------------------------
local _cNumBar,_cNossoNu1:=_cNossoNum,_nVez
Private _cDigcor:= ""
Private cQuaGrupo
Public cNumDig10
                                     
dbselectarea("SEE")
dbsetorder(1)

see->(dbsetorder(1)) // EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
see->(dbseek(xfilial()+_cBanco+_cAgenciaz+_cContaz))//+"R"))
for _nVez:=1 to len(_cNossoNum)
	if substr(_cNossoNum,_nVez,1)=="0"
		_cNossoNu1:=right(_cNossoNu1,len(_cNossoNu1)-1)
	else
		exit
	endif
next

do case
   case _cBanco=="001" // Bco do Brasil
           _cCampo1:=_cBanco+;
              "9"+;                     
              _cDigBar+;
              strzero(se1->e1_vencto-ctod("07/10/1997"),4)+;
              strzero(se1->e1_valor*100,10)+;
              "000000"+;
              "1534999"+;
              Substr(_cNossoNum,2,10)+;
              "17"                  
                         
        _cNumBar:=left(_cCampo1,4)+(_cDigBar:=_fDigBar(_cCampo1,_cBanco))+substr(_cCampo1,5)  

	case _cBanco=="399"          
	
	    cFatorVen	:= strzero(se1->e1_vencto-ctod("07/10/1997"),4)
	    cValor := strzero(se1->e1_valor*100,10)  //STRZERO(se1->e1_valor,10,2)
		cNumDig10 := _cBanco+"9"+cFatorVen+cValor+_cNossoNd+SUBSTR(_cAgencia,1,4)+SUBSTR(_cConta,1,7)+"00"+"1"    //+"0009"+SUBSTR(_cAgencia,1,4)+substr(see->ee_cart,1,1)     
		cDigVerif := CalcDigMOD10(cNumDig10)//Calculo modulo 10, RETORNA O DIGITO VERIF.
     	_cNumBar :=SubStr(cNumDig10,1,4)+cDigVerif+Alltrim(SubStr(cNumDig10,5,39)) //RETORNA 10 POSICOES

        //_cNumBar := cPriGrupo + cSegGrupo + cTerGrupo + cQuaGrupo + cFatorVen + cValor
	
	/*
		cNumDig10 := _cBanco+"9"+"0009"+SUBSTR(_cAgencia,1,4)+substr(see->ee_cart,1,1)     
		cDigVerif := CalcDigMOD10(cNumDig10)//Calculo modulo 10, RETORNA O DIGITO VERIF.
     	cPriGrupo := cNumDig10 + cDigVerif //RETORNA 10 POSICOES
			 				
 		cNumDig10 := + Substr(_cNossoNum,1,9)
     	cDigVerif := CalcDigMOD10(cNumDig10)//Claculo modulo 10, RETORNA O DIGITO VERIF.
     	cSegGrupo := cNumDig10 + cDigVerif //RETORNA 11 POSICOES		
		
	  cNumDig10 := Substr(_cNossoNum,10,2)+SUBSTR(STRZERO(Val(_cConta),8),1,7)+"0"
     cDigVerif := CalcDigMOD10(cNumDig10)//Claculo modulo 10, RETORNA O DIGITO VERIF.
     cTerGrupo := cNumDig10+cDigVerif	
			 			
     cValor := STRZERO(se1->e1_valor,14,2)
     
     cNewValor := ""
     nZeros := 0
     for i:=1 to len(cValor)
          if Substr(cValor,i,1) # "." .and. Substr(cValor,i,1) # ","
               cNewValor += Substr(cValor,i,1)
          ELSE
               nZeros ++
          endif
     next
     cValor := ""
     For i:=1 to nZeros
          cValor += "0"
     next
     	cValor 	+= Substr(Alltrim(cNewValor),5,10)
   cFatorVen	:= strzero(se1->e1_vencto-ctod("07/10/1997"),4)           
	cNumDig10 	:= _cBanco + "0" + cFatorVen + cValor + SUBSTR(_cAgencia,1,4) + _cNossoNum + SUBSTR(STRZERO(Val(_cConta),8),1,7) +"0"             
   cDigVerif 	:= CalcDigM11(cNumDig10)//Claculo modulo 11, RETORNA O DIGITO VERIF.
   cQuaGrupo 	:= cDigVerif     
	
    _cNumBar := cPriGrupo + cSegGrupo + cTerGrupo + cQuaGrupo + cFatorVen + cValor
      */
             
   case _cBanco=="104" // Caixa Economica

	  	_cCampo1:=_cBanco+;                                      
   	"9"+;
     	strzero(se1->e1_vencto-ctod("07/10/1997"),4)+;
      strzero(se1->e1_valor*100,10)+;
      Substr(_cNossoNum,1,10)+;    
      "135800300000294"
	  _cNumBar:=left(_cCampo1,4)+(_cDigBar:=_fDigBar(_cCampo1,_cBanco))+substr(_cCampo1,5) 
		
	case _cBanco=="341" // Itau
		_cCampo1:=_cBanco+;                 
		"9"+;
		strzero(se1->e1_vencto-ctod("07/10/1997"),4)+;       
		strzero(se1->e1_valor*100,10)+;
		see->ee_cart+;
		_cNossoNum+;
		_cNossoDig+;
		alltrim(_cAgencia)+;
		iif(len(alltrim(_cConta))> 6,substr(alltrim(_cConta),2,6),substr(alltrim(_cConta),1,6))+;
		"000"
		
		_cNumBar:=left(_cCampo1,4)+(_cDigBar:=_fDigBar(_cCampo1,_cBanco))+substr(_cCampo1,5)
		
	case _cBanco=="479" // Banco de boston
	 /*	_cCampo1:=_cBanco+;
		"9"+;
		strzero(se1->e1_vencto-ctod("07/10/1997"),4)+;
		strzero(se1->e1_valor*100,10)+;
		"001522060000000"+;
		_cNossoNu1+;
		_cNossoDig+;
		"8"
		
		_cNumBar:=left(_cCampo1,4)+(_cDigBar:=_fDigBar1(_cCampo1,_cBanco))+substr(_cCampo1,5)
	*/
	
		_cCampo1:=_cBanco+;
		"9"+;
		strzero(se1->e1_vencto-ctod("07/10/1997"),4)+;
		strzero(se1->e1_valor*100,10)+;
		see->ee_cart+;
		_cNossoNum+;  
		_cNossoDig+;
		alltrim(_cAgencia)+;
		iif(len(alltrim(_cConta))> 6,substr(alltrim(_cConta),2,6),substr(alltrim(_cConta),1,6))+;
		"000"
		
		_cNumBar:=left(_cCampo1,4)+(_cDigBar:=_fDigBar(_cCampo1,_cBanco))+substr(_cCampo1,5)	
				
	case _cBanco=="237" // Bradesco
	/*
		_cCampo1:=_cBanco+;
		"9"+;
		strzero(se1->e1_vencto-ctod("07/10/1997"),4)+;
		strzero(se1->e1_valor*100,10)+;
		substr(_cAgencia,1,4)+;
		substr(see->ee_cart,2,2)+; //carteira
		_cNossoNum+;
		"0"+substr(_cConta,1,6)+;
		"0"
		*/ 
		_cCampo1:=_cBanco+;
		"9"+;
		strzero(se1->e1_vencto-ctod("07/10/1997"),4)+;
		strzero(se1->e1_valor*100,10)+;
		"0064"+;
		"09"+; //carteira
		_cNossoNum+;  
		"0"+substr(_cConta,1,6)+;  
		"0"
		
		_cNumBar:=left(_cCampo1,4)+(_cDigBar:=_fDigBar(_cCampo1,_cBanco))+substr(_cCampo1,5)

endcase

return _cNumBar

*-----------------------------------------------------------------------------
static function _fDigVer(_cCampo,_cBanco)
*-----------------------------------------------------------------------------
local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
if _cBanco=="001" // Brasil
   _nFator:=0
   _nPeso:=2
   _nReturn:=0
   for _nVez:=len(_cCampo) to 1 step -1
       _nResult:=val(substr(_cCampo,_nVez,1))*_nPeso
       _cResult:=strzero(_nResult,2)
       _nFator+=val(substr(_cResult,1,1))
       _nFator+=val(substr(_cResult,2,1))
       _nPeso:=if(_nPeso==2,1,2)
   next
   _nReturn:=mod(_nFator,10)
   if _nReturn>0
      _nReturn:=10-_nReturn
   endif   
elseif _cBanco=="104"
nCont:=0
_cCampo:=StrZero(Val(_cCampo),10)
For i:=1 to Len(_cCampo)
	If (i%2) != 0
		nCont:=nCont+(Val(Subs(_cCampo,i,1))*1)
	Else
		If Val(Subs(_cCampo,i,1))*2 >= 10
			nVal:=Val(Subs(_cCampo,i,1))*2
			nCont:=nCont+(Val(Subs(Str(nVal,2),1,1))+Val(Subs(Str(nVal,2),2,1)))
		Else
			nCont:=nCont+(Val(Subs(_cCampo,i,1))*2)
		Endif
	Endif
Next i
_nReturn:=Abs(If(nCont%10==0,0,(nCont%10)-10))

elseif _cBanco=="341" // Itau
	_nFator:=0
	_nPeso:=2
	_nReturn:=0
	for _nVez:=len(_cCampo) to 1 step -1
		_nResult:=val(substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=strzero(_nResult,2)
		_nFator+=val(substr(_cResult,1,1))
		_nFator+=val(substr(_cResult,2,1))
		_nPeso:=if(_nPeso==2,1,2)
	next
	_nReturn:=mod(_nFator,10)
	if _nReturn>0
		_nReturn:=10-_nReturn
	endif
elseif _cBanco=="237" // Bradesco
	_nFator:=0
	_nPeso:=2
	_nReturn:=0
	for _nVez:=len(_cCampo) to 1 step -1
		_nResult:=val(substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=strzero(_nResult,2)
		_nFator+=val(substr(_cResult,1,1))
		_nFator+=val(substr(_cResult,2,1))
		_nPeso:=if(_nPeso==2,1,2)
	next
	_nReturn:=mod(_nFator,10)
	if _nReturn>0
		_nReturn:=10-_nReturn
	endif

elseif _cBanco=="479" // Boston
	_nFator:=0
	_nPeso:=2
	_nReturn:=0
	for _nVez:=len(_cCampo) to 1 step -1
		_nResult:=val(substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=strzero(_nResult,2)
		_nFator+=val(substr(_cResult,1,1))
		_nFator+=val(substr(_cResult,2,1))
		_nPeso:=if(_nPeso==2,1,2)
	next
	_nReturn:=mod(_nFator,10)
	if _nReturn>0
		_nReturn:=10-_nReturn
	endif
endif
return str(_nReturn,1)

*-----------------------------------------------------------------------------
static function _fDigBar(_cCampo,_cBanco)
*-----------------------------------------------------------------------------
local _nVez,_nPeso,_nFator,_nResto
if _cBanco=="001" // Banco do Brasil
   _nPeso:=2
   _nFator:=0
   _nResto:=0
   for _nVez:=len(_cCampo) to 1 step -1
       _nFator+=val(substr(_cCampo,_nVez,1))*_nPeso
       _nPeso:=if(_nPeso<9,_nPeso+1,2)
   next
   _nResto:=mod(_nFator,11)
   if _nResto==0.or._nResto==1.or._nResto>9
      _nResto:=1
   else
      _nResto:=11-_nResto
	endif 
elseif _cBanco=="104" //Caixa
   _nPeso:=2
   _nFator:=0
   _nResto:=0    
   for _nVez:=len(_cCampo) to 1 step -1
       _nFator+=val(substr(_cCampo,_nVez,1))*_nPeso
       _nPeso:=if(_nPeso<9,_nPeso+1,2)
   next
   _nResto:=mod(_nFator,11)
   if _nResto==0.or._nResto==1.or._nResto>9
      _nResto:=1
   else
      _nResto:=11-_nResto
	endif 
   
                                              
elseif _cBanco=="341" // Itau
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	for _nVez:=len(_cCampo) to 1 step -1
		_nFator+=val(substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=if(_nPeso<9,_nPeso+1,2)
	next
	_nResto:=mod(_nFator,11)
	if _nResto==0.or._nResto==1.or._nResto==10.or._nResto==11
		_nResto:=1
	else
		_nResto:=11-_nResto
	endif

elseif _cBanco=="237" // Bradesco
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	for _nVez:=len(_cCampo) to 1 step -1
		_nFator+=val(substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=if(_nPeso<9,_nPeso+1,2)
	next
	_nResto:=mod(_nFator,11)
	if _nResto==0.or._nResto==1.or._nResto>9
		_nResto:=1
	else
		_nResto:=11-_nResto
	endif
	
elseif _cBanco=="479" // Boston
		_nPeso:=2
	_nFator:=0
	_nResto:=0
	for _nVez:=len(_cCampo) to 1 step -1
		_nFator+=val(substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=if(_nPeso<9,_nPeso+1,2)
	next
	_nResto:=mod(_nFator,11)
	if _nResto==0.or._nResto==1.or._nResto==10.or._nResto==11
		_nResto:=1
	else
		_nResto:=11-_nResto
	endif
endif
return str(_nResto,1)  

Static Function Nosso237()

Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _cResult    := ""
Local _nFator     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para gerar NossoNum()                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEE")
RecLock("SEE",.f.)
see->ee_faxatu := soma1(see->ee_faxatu,11)
MsUnlock()

_xCart    	:= substr(StrZero(Val(SEE->EE_CART),3),2,2)
///_xCart    	:= "09" // TEMPORARIO
_xNosso_num := StrZero(Val(SEE->EE_FAXATU),11)
_xVariavel	:= _xCart+_xNosso_num


_nPeso:=2
_nFator:=0
_nResto:=0
for _nVez:=len(_xVariavel) to 1 step -1
	_nFator+=val(substr(_xVariavel,_nVez,1))*_nPeso
	_nPeso:=if(_nPeso<7,_nPeso+1,2)
next
_nResto:=mod(_nFator,11)
If _nResto = 1
	_cResult := "P"
ElseIf _nResto = 0
	_cResult := "0"
Else
	_nResto:=11-_nResto
	_cResult := str(_nResto,1)
EndIf

return(_xNosso_num+_cResult)

Static Function Nosso399()
Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 9
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0          ///                         5,4,3,2,7,6,5,4,3,2
//aPeso             := {7,6,5,4,3,2}
Local aPeso       := {5,4,3,2,7,6,5,4,3,2}
// 29944
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                    
//³ Funcao para gerar NossoNum()                                 ³                              
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEE")                                                   
RecLock("SEE",.f.)
see->ee_faxatu := soma1(see->ee_faxatu,11)
MsUnlock() 
                                                                 
_xNosso_num := "29944"+Substr(Strzero(Val(SEE->EE_FAXATU),11),7,5)
//_xNosso_num := "5095012345"
_xVariavel	:= _xNosso_num                        
                                                                                 
Strzero(Val(SEE->EE_FAXATU),11)                                          

for _nVez:= len(Alltrim(_xVariavel)) to 1 step -1
   //_nFator+=val(substr(_xVariavel,_nVez,1))*_nPeso
   _nFator+=val(substr(_xVariavel,_nVez,1))*aPeso[_nVez]
   _nPeso := _nPeso - 1
			if _nPeso == 1
				_nPeso :=9
			else
				_nPeso := _nPeso
			endif
next 
_nResto:=mod(_nFator,11)

If _nResto=0 .Or. _nResto=1  
   _cResult := "0"
Else
   _cResult := Alltrim(Str(11-_nResto))
EndIf

If Val(_cResult)>9
   _cResult := "X"  
EndIf
Return(_xNosso_num+_cResult)
                
/*
Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0       
Local cDigito := 0,;
nSoma := 0,;
nBase := 0,;
aPeso := {7,6,5,4,3,2},;
nBase := Len(aPeso)+1                                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para gerar NossoNum()                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEE") 
dbsetorder(1)
//If Dbseek(xFilial("SF2")+mv_par03)//.t.)

RecLock("SEE",.f.)
see->ee_faxatu := soma1(see->ee_faxatu,10)
MsUnlock()

_xConta   	:= Alltrim(Left(SEE->EE_CONTA,5))
_xAgencia 	:= Left(SEE->EE_AGENCIA,4)
_xCart    	:= Left(SEE->EE_CART,3)
_xNosso_num := Right(SEE->EE_FAXATU,8)
_xVariavel	:= _xCart+_xNosso_num



FOR nCnt := Len(_xVariavel) TO 1 STEP -1
     nBase := IF(--nBase = 0,Len(aPeso),nBase)
     nSoma += Val(SUBS(_xCart+_xNosso_num,nCnt,01)) * aPeso[ nBase ]
NEXT

cDigito := 11 - (nSoma % 11)

DO CASE
     CASE cDigito = 11
          cDigito := "0"
     CASE cDigito = 10
          cDigito := "P"
     OTHERWISE
         _nReturn := ( cDigito, 1, 0 )
ENDCASE
*/

Return(_xNosso_num+str(_nReturn,1))


Static Function Nosso104()
/*
Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para gerar NossoNum()                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEE")  
RecLock("SEE",.f.)
 see->ee_faxatu := soma1(see->ee_faxatu,11)
MsUnlock() 

_xNosso_num := "9"+Substr(Strzero(Val(SEE->EE_FAXATU),11),3,9)
_xVariavel	:= _xNosso_num

//Strzero(Val(SEE->EE_FAXATU),11)
ALERT("NUMERO PARA O CALCULO")
ALERT(_xNosso_num)
for _nVez:= len(Alltrim(_xVariavel)) to 1 step -1
   _nFator+=val(substr(_xVariavel,_nVez,1))*_nPeso
   _nPeso := _nPeso + 1
			if _nPeso == 9
				_nPeso :=2
			else
				_nPeso := _nPeso
			endif
next 
*/
dbSelectArea("SEE")                                                   
RecLock("SEE",.f.)
see->ee_faxatu := soma1(see->ee_faxatu,11)
MsUnlock() 
apeso     :={3,2,9,8,7,6,5,4,3,2} //                                     3298765432
_xNosso_num := "9"+Substr(Strzero(Val(SEE->EE_FAXATU),11),3,9)
_xVariavel	:= _xNosso_num
//Strzero(Val(SEE->EE_FAXATU),11)
_nFator   :=0
for _nVez:= len(Alltrim(_xVariavel)) to 1 step -1
   //_nFator+=val(substr(_xVariavel,_nVez,1))*_nPeso
   _nFator+=val(substr(_xVariavel,_nVez,1))*aPeso[_nVez]
next 

_nResto:=mod(_nFator,11)
If 	  11 - _nResto  > 9
       _cResult := "0"  
Elseif 11 - _nResto = 0
       _cResult := "0"
Else
	   _cResult := Str(11-_nResto,1)
EndIf
Return(_xNosso_num+_cResult)

/*        
ROTINA ERRADA 
Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para gerar NossoNum()                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEE")
RecLock("SEE",.f.)
see->ee_faxatu := soma1(see->ee_faxatu,10)
MsUnlock()

_xNosso_num := Strzero(Val(SEE->EE_FAXATU),10)
_xVariavel	:= _xNosso_num

//Calc Dg Nosso\\
nCont:=0
cBarraImp3 	:= space(11)
cBarraImp3	:= _xNosso_num  // Subs(cBarra,19,11)

nCont	:= 0
//nCont	:= nCont+(Val(Subs(cBarraImp3,11,1))*9)
nCont	:= nCont+(Val(Subs(cBarraImp3,10,1))*2)
nCont	:= nCont+(Val(Subs(cBarraImp3,09,1))*3)
nCont	:= nCont+(Val(Subs(cBarraImp3,08,1))*4)
nCont	:= nCont+(Val(Subs(cBarraImp3,07,1))*5)
nCont	:= nCont+(Val(Subs(cBarraImp3,06,1))*6)
nCont	:= nCont+(Val(Subs(cBarraImp3,05,1))*7)
nCont	:= nCont+(Val(Subs(cBarraImp3,04,1))*8)
nCont	:= nCont+(Val(Subs(cBarraImp3,03,1))*9)
nCont	:= nCont+(Val(Subs(cBarraImp3,02,1))*2)
nCont	:= nCont+(Val(Subs(cBarraImp3,01,1))*3)

// \\

nCont1  := int(nCont  / 11)
nCont2	:= ncont1 * 11
nResto  := ncont - ncont2
nResto  := 11 - nResto
if nResto > 9
	nResto := 0
	cBarraImp4 := cBarraImp3+"0"
	alert("valor zero")                                                                
	Return("0")
else
	cBarraImp4 := cBarraImp3 + strzero(nResto,1)
	alert("valor nao zero")
	Return(strzero(nResto,1))
EndIf
alert(_xNosso_num+str(_nReturn,1))
alert("valor gerado")
Return (_xNosso_num+str(_nReturn,1))

*/

Static Function Nosso341()

Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para gerar NossoNum()                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEE")
RecLock("SEE",.f.)
see->ee_faxatu := soma1(see->ee_faxatu,8)
MsUnlock()

_xConta   	:= Alltrim(Left(SEE->EE_CONTA,5))
_xAgencia 	:= Left(SEE->EE_AGENCIA,4)
_xCart    	:= Left(SEE->EE_CART,3)
_xNosso_num := Right(SEE->EE_FAXATU,8)
_xVariavel	:= _xAgencia+_xConta+_xCart+_xNosso_num

for _nVez:= len(Alltrim(_xVariavel)) to 1 step -1
	_nResult:=val(substr(_xVariavel,_nVez,1))*_nPeso
	_cResult:=strzero(_nResult,2)
	_nFator+=val(substr(_cResult,1,1))
	_nFator+=val(substr(_cResult,2,1))
	_nPeso:=if(_nPeso==2,1,2)
next
_nReturn:=mod(_nFator,10)
if _nReturn>0
	_nReturn:=10-_nReturn
endif

Return(_xNosso_num+str(_nReturn,1))
  
  
Static Function Nosso001()
Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 9
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para gerar NossoNum()                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEE")  
RecLock("SEE",.f.)
see->ee_faxatu := soma1(see->ee_faxatu,11)
MsUnlock() 
                                                                                      
_xNosso_num := Strzero(Val(SEE->EE_FAXATU),11)
_xVariavel	:= _xNosso_num                                            

for _nVez:= len(Alltrim(_xVariavel)) to 1 step -1
   _nFator+=val(substr(_xVariavel,_nVez,1))*_nPeso
   _nPeso := _nPeso - 1
			if _nPeso == 1
				_nPeso :=9
			else
				_nPeso := _nPeso
			endif
next 
_nResto:=mod(_nFator,11)
if 	   _nResto  = 10
       _cResult := "X"  
Elseif _nResto   = 0
       _cResult := "0"
else
	   _nResto < 10
	   _nResto := _nResto
	   _cResult := Str(_nResto,1)
EndIf
Return(_xNosso_num+_cResult)

*************//HSBC  --> Dg HSBC
Static Function CalcDigMOD10(cNumDig10)
apeso     :={4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2} //
_nFator   :=0
for _nVez:= len(Alltrim(cNumDig10)) to 1 step -1
   //_nFator+=val(substr(_xVariavel,_nVez,1))*_nPeso
   _nFator+=val(substr(cNumDig10,_nVez,1))*aPeso[_nVez]
next 
_nResto:=mod(_nFator,11)

If _nResto=0 .Or. _nResto=1 .Or. _nResto=10
   _cResult := "1"
Else
   _cResult := Alltrim(Str(11-_nResto))
EndIf

If Val(_cResult)>10
   _cResult := "X"  
EndIf
Return(_cResult)

/*
nCont      := 2
cDigito := "0"
nSoma      := 0
nAux      := 0

For i:=Len(cNumDig10) to 1 step -1
     
     nAux := Val(Substr(cNumDig10,i,1)) * nCont
     if nAux > 9
          nSoma += Val(Substr(Strzero(nAux,2),1,1)) + Val(Substr(Strzero(nAux,2),2,1))
     else
          nSoma += nAux
     endif
     
     if nCont == 2
          nCont := 1
     else
          nCont := 2
     endif
     
Next i

if 10-mod(nSoma,10) > 9
     cDigito := "0"
else
     nDigito := 10-mod(nSoma,10)              
     cDigito := Strzero(nDigito,1)                                                    
endif
*/
return(cDigito)

******************************************

STATIC FUNCTION CalcDigM11(cNumDig10,_ar) //Mod11_237( cNumero ) //-> Modulo 11 especifico p/ Banco Brandesco´para digito do codigo de barras

If _ar=1
   aPeso := {2,1,2,1,2,1,2,1,2}
Else
   aPeso := {1,2,1,2,1,2,1,2,1,2}
EndIf           
                        
_nFator   :=0

For _nVez:= len(Alltrim(cNumDig10)) to 1 step -1
   //_nFator+=val(substr(_xVariavel,_nVez,1))*_nPeso
   _tempc  :=val(substr(cNumDig10,_nVez,1))*aPeso[_nVez]
   _tempvc :=_tempc
   If _tempc >=10
     _tempc  := Alltrim(Str(_tempc,2))
     _tempvc := Val(SubStr(_tempc,1,1))+Val(SubStr(_tempc,2,1))
   EndIf
   _nFator+=_tempvc
Next                                                               

_nResto:=mod(_nFator,10)
   
If _nResto = 0
   _cResult :="0"
Else   
   If _nFator<10 
      _cResult := Alltrim(Str(10-_nFator))
   Else
      _cResult := Alltrim(Str(10-_nResto))
   EndIf   
EndIf

/*
nBase := Len(aPeso)+1

FOR nCnt := Len(cNumDig10) TO 1 STEP -1
     nBase := IF(--nBase = 0,Len(aPeso),nBase)
     nSoma += Val(SUBS(cNumDig10,nCnt,01)) * aPeso[ nBase ]
NEXT

cDigito := 11 - (nSoma % 11)

DO CASE
     CASE cDigito = 0
          cDigito := "1"
     CASE cDigito >= 9
          cDigito := "1"
     OTHERWISE
          cDigito := STR( cDigito, 1, 0 )
ENDCASE
RETURN(cDigito)
*/
RETURN(_cResult)

user function GRVCODBAR()

		// Gravacao do nosso numero
		_cBanco:=_cAgencia:=_cConta:=""
		If Alltrim(se1->e1_portado)=="237"
		   _cBanco   :=se1->e1_portado
		   _cAgencia :="0064"  //se1->e1_agedep
		   _cConta   :="311840"  // se1->e1_conta
		   _cAgenciaz :=se1->e1_agedep                           
		   _cContaz   :=se1->e1_conta 
      Else
		   _cBanco   :=se1->e1_portado
		   _cAgencia :=se1->e1_agedep
		   _cConta   :=se1->e1_conta                              
		   _cAgenciaz :=se1->e1_agedep    
		   _cContaz   :=se1->e1_conta 
		 EndIf  
		_cNossoNum:=""
		see->(dbsetorder(1)) // EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
		If Alltrim(se1->e1_portado)=="237"
		   see->(dbseek(xfilial()+_cBanco+_cAgenciaz+_cContaz))
		Else
		   see->(dbseek(xfilial()+_cBanco+_cAgencia+_cConta))
		EndIf                                  
		do case
			case _cBanco=="001"
				_cNossoNum:=Nosso001()  
			case _cBanco=="479"
				_cNossoNum:=Nosso341()
			case _cBanco=="341"
				_cNossoNum:=Nosso341()
			case _cBanco=="104"
				_cNossoNum:=Nosso104()                            
			case _cBanco=="399"
				_cNossoNum:=Nosso399()
			case _cBanco=="237"
				_cNossoNum:=Nosso237()
			case _cBanco=="033"
				_cNossoNum:=Nosso033()	
				
		endcase
		_cNossoNum:=alltrim(_cNossoNum)         
		_cNossoNd :=alltrim(_cNossoNum)                       
		_cNossoDig:=right(_cNossoNum,1)                          
		_cNossoNum:=left(_cNossoNum,len(_cNossoNum)-1)
		_cDigBar:=""
		_cNumBar:=_fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
		_cNumBol:=_fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
		
		
		if !empty(_cNossoNum).or.!empty(_cNumBar).or.!empty(_cNumbol)
			if se1->(reclock(alias(),.f.))
				se1->e1_numbco  :=_cNossoNum + _cNossoDig
				if _cBanco<>'399'
					se1->e1_codbar  :=_cNumBar
					se1->e1_coddig  :=_cNumBol
					//SE1->E1_HIST   := _cNossoNd
	//									SE1->E1_DATAEDI:=DDATABASE                 
										
				else                            
				  	se1->e1_codbar  :=_cNumBar
					se1->e1_coddig  :=_cNumBol
					//se1->e1_codbar  :=_cNumBol
					//se1->e1_coddig  :=_cNumBar                
					//SE1->E1_HIST   := _cNossoNd          
	  //									SE1->E1_DATAEDI:=DDATABASE
				endif
				se1->e1_situaca :="0"   
				se1->(msunlock())                         
			endif                                                             
		Endif
		
RETURN


////////////////////////////////////////////////////////////////////////////////////
Static Function Nosso033()
RecLock("SEE",.f.)
see->ee_faxatu := soma1(see->ee_faxatu,12)
MsUnlock() 
      
//--- Para o Santander precisa gravar o Nosso Numero com o Digito (Modulo 11)
cNumNN:=see->ee_faxatu
nCalcNrBanc  := Alltrim(cNumNN)
cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
cNossoNum 	:= Alltrim(cNumNN) + Alltrim(str(cDVNrBanc))
Return (cNossoNum)
/*
RecLock( "SE1" , .F. )
	   // jas SE1->E1_NUMBCO := cNossoNum
	   MsUnlock()                                               
    Else
	   cNossoNum := Substr(SE1->E1_NUMBCO,1,12)
    EndIf   
	//--- fim 22.03.07
	
	cAgeNN		:= SUBSTR(SA6->A6_AGENCIA,1,4)
	cCtaNN		:= SUBSTR(SA6->A6_NUMCON,1,9)
	cCarNN		:= Alltrim(SUBSTR(SA6->A6_CARTCBR,1,3)) 
	cNumNN		:= SUBSTR(SE1->E1_NUMBCO,1,12)
	nCalcNrBanc := Alltrim(cNumNN)
	cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
	cNrBancario	:= Alltrim(cNumNN) + Alltrim(str(cDVNrBanc))
	
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	//Monta codigo de barras
     aDadosBanco  := {SA6->A6_COD,;
                   SA6->A6_NOME      	            	                  	,; 	
                   SUBSTR(SA6->A6_AGENCIA, 1, 4)                        	,;	
                   SUBSTR(SA6->A6_NUMCON, 1, 9) ,;
                   SUBSTR(SA6->A6_DVC,1,10) ,;
                   SA6->A6_CARTCBR 										    ,;  
                   SA6->A6_TXMLTBL											,;	
                   SA6->A6_TXMORBL 										    ,;  
                   Substr(SEE->EE_CODEMP,1,7)								}   
	
	
	
	aCB_RN_NN    := Ret_cBarra("033"+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNrBancario,(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCTO,cCarNN,aDadosBanco[9])
  */
  


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11Nn ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11Nn(cData)
LOCAL L, D, P,R := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End

R := mod(D,11)
If (R == 10)
	D := 1
ElseIf (R == 0 .or. R == 1)
    D := 0
Else
    D := (11 - R)
End              

Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNrBancario,nValor,dVencto,cCart,cCedente)
LOCAL cValorFinal 	:= strzero(nValor*100,10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS				:= ''
LOCAL cFator      := strzero(dVencto - ctod("07/10/97"),4)

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
// cBanco está igual a 0339
cS:= cBanco + cFator +  cValorFinal + "9" + cCedente + cNrBancario + "0" + cCart
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.DDDDX		EEEFF.FFFFFY	GGGGG.GHJJJZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao   
//	  B = Codigo da moeda, sempre 9
//	  C = Fixo "9"
//	 DDDD = 4 Primeiras posicoes do codigo do cedente padrao Santander Banespa
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS1   := cBanco + "9" + SubStr(cCedente,1,4)
nDv1  := modulo10(cS1)
cRN1  := SubStr(cS1, 1, 5) + '.' + SubStr(cS1, 6, 4) + AllTrim(Str(nDv1)) + '   '

// 	CAMPO 2:
//	EEE  = Restante do Codigo do Cedente padrao Santander Banesp
//	FFFFFFF = Sete primeiros campos do Nosso Numero
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS2 := SubStr(cCedente,5,3) + SubStr(cNrBancario,1,7) 
nDv2:= modulo10(cS2)
cRN2:= SubStr(cS2, 1, 5) + '.' + SubStr(cS2, 6, 5) + AllTrim(Str(nDv2)) + '   '

// 	CAMPO 3:
//	GGGGGG = Restante do Nosso Numero                  
//	H              = 0  (Conteudo Fixo)
//	JJJ            = Carteira
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS3   := Subs(cNrBancario,8,6) + "0" + cCart
nDv3  := modulo10(cS3)
cRN3  := SubStr(cS3, 1, 5) + '.' + SubStr(cS3, 6, 5) + AllTrim(Str(nDv3)) + '   '

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cRN4  := AllTrim(Str(nDvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
cRN5  := cFator + cValorFinal

cRN	  := cRN1 + cRN2 + cRN3 + cRN4 + cRN5

Return({cCB,cRN})


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)

