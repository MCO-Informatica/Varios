#INCLUDE "rwmake.ch"     
#include "topconn.ch"                                                                
#INCLUDE "PROTHEUS.CH"                                                               
   
                                                                                                                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±              
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±                                                                                                                                        
±±ºPrograma  ³NOVO4     ºAutor  ³Microsiga           º Data ³  03/26/08   º±±           
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                
±±ºDesc.     ³ funcao para impressao dos codigos de barra                 º±±           
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±              
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/         
                                                                                                                                           
User Function fImpBar(_lAutomatico,_cPrefIni,_cPrefFim,_cNumeIni,	_cNumeFim,_cParcIni,_cParcFim,_cTipoIni,_cTipoFim,_dEmisIni,_dEmisFim,_lVisualizar,_lConfigurar,aTitulos)
Private nLastKey   := 0
Private oArial12N1:=TFont():New("Arial",12,16,,.T.,,,,.T.,.F.)
Private oArial12N2:=TFont():New("Arial",12,16,,.T.,,,,.T.,.F.)
oFont1:=oArial12N1  //Say
oFont2:=oArial12N2  //Get

dbselectarea("SEE")
dbsetorder(1)                                          

dbselectarea("SE1")                      
dbsetorder(1)

If !_lAutomatico
   _retorno :=CallTela(@aTitulos)
Else
   _retorno :=.T.
   _oprn := TMSPrinter():New()
   _oprn:SetPortrait()
   _oprn:Setup()

   If nLastKey == 27
	 Return
   Endif                                                

EndIf   


/////////////////////////////////////////
If _retorno .And. Len(aTitulos) >0
   For nLoop := 1 To Len(aTitulos)
	If aTitulos[nLoop,1] .Or. _lAutomatico
	   SE1->(DbGoto(aTitulos[nLoop,17]))     
	   alert(alltrim(str(aTitulos[nLoop,17])))
	   if se1->("-"$e1_tipo.or.e1_tipo=="PR ")                                    
	   else
	  //jas	If se1->e1_boleto <> "N"
		 se1->(_fBoleto(e1_portado,e1_agedep,e1_conta))
		//jas EndIf
	   endif
	Endif   
   Next nLoop
Else
   retindex("SE1")
   Return   
endIf


//jas setregua(1)
//jas incregua()         

dbCommitAll()
If _lVisualizar
	_oprn:Preview()
else
	_oPrn:Print()
Endif

MS_FLUSH()
retindex("SE1")

Return           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     ºAutor  ³Microsiga           º Data ³  03/26/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-----------------------------------------------------------------------------
Static Function _fBoleto(_cBanco,_cAgencia,_cConta)
*-----------------------------------------------------------------------------

Local nHeight   := 15
Local lBold     := .F.
Local lUnderLine:= .F.
Local lPixel    := .T.
Local lPrint    := .F.
Local ArialN6   := TFont():New("Arial"          ,,06,,.F.,,,,,lUnderLine)
Local ArialN6B  := TFont():New("Arial"          ,,06,,.T.,,,,,lUnderLine)
Local ArialN8   := TFont():New("Arial"          ,,08,,.F.,,,,,lUnderLine)
Local ArialN8B  := TFont():New("Arial"          ,,08,,.T.,,,,,lUnderLine)
Local ArialN10  := TFont():New("Arial"          ,,10,,.F.,,,,,lUnderLine)
Local ArialN10B := TFont():New("Arial"          ,,10,,.T.,,,,,lUnderLine)
Local ArialN12  := TFont():New("Arial"          ,,12,,.F.,,,,,lUnderLine)
Local ArialN12B := TFont():New("Arial"          ,,12,,.T.,,,,,lUnderLine)
Local ArialN14  := TFont():New("Arial"          ,,14,,.F.,,,,,lUnderLine)
Local ArialN14B := TFont():New("Arial"          ,,14,,.T.,,,,,lUnderLine)
Local ArialN16  := TFont():New("Arial"          ,,16,,.F.,,,,,lUnderLine)
Local ArialN16B := TFont():New("Arial"          ,,16,,.T.,,,,,lUnderLine)
Local ArialN14BS:= TFont():New("Arial"          ,,14,,.T.,,,,,.T.)
Local ArialN15  := TFont():New("Arial"          ,,15,,.F.,,,,,lUnderLine)
Local ArialN15B := TFont():New("Arial"          ,,15,,.T.,,,,,lUnderLine)
Local ArialN18  := TFont():New("Arial"          ,,18,,.F.,,,,,lUnderLine)
Local ArialN18B := TFont():New("Arial"          ,,18,,.T.,,,,,lUnderLine)
Local ArialN20  := TFont():New("Arial"          ,,20,,.F.,,,,,lUnderLine)
Local ArialN20B := TFont():New("Arial"          ,,20,,.T.,,,,,lUnderLine)
Local ArialN22  := TFont():New("Arial"          ,,22,,.F.,,,,,lUnderLine)
Local ArialN22B := TFont():New("Arial"          ,,22,,.T.,,,,,lUnderLine)
Local ArialN24B := TFont():New("Arial"          ,,24,,.T.,,,,,lUnderLine)
Local ArialN28  := TFont():New("Arial"          ,,28,,.F.,,,,,lUnderLine)
Local Times14BS := TFont():New("Times New Roman",,14,,.T.,,,,,.T. )
Local Times20   := TFont():New("Times New Roman",,20,,.T.,,,,,.F. )
Local Arial08   := TFont():New("Arial"          ,,08,,.T.,,,,,.F. )
Local Arial12   := TFont():New("Arial"          ,,12,,.T.,,,,,.F. )
LOCAL aCB_RN_NN    := {}                   
Local _cCampo	:= Space(48)

local _lContinua:=.f.

Private _cCodbar  := SPACE(48)
// jas Private lDupdesc  :=GetMv("MC_DUPDESC")



see->(dbsetorder(1)) // EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
/*
If                               
		   _cBanco   :=se1->e1_portado
		   _cAgencia :="0064"  //se1->e1_agedep
		   _cConta   :="311840"  // se1->e1_conta
		   _cAgenciaz :=se1->e1_agedep                           
		   _cContaz   :=se1->e1_conta                   
  */
  
see->(dbseek(xfilial()+_cBanco+_cAgencia+_cConta))//+"R"))
sa1->(dbsetorder(1))
sa1->(dbseek(xfilial()+se1->(e1_cliente+e1_loja),.f.))
//_cBcoLogo:="\imagens\"
_cBcoLogo:=""
_cDigBanco:=""
_cInst1 := left(see->ee_instpri,2)
_cInst2 := left(see->ee_instsec,2)
_cInst3	:= left(see->ee_instter,2)
do case
	case _cBanco=="341"
		_lContinua:=.t.
		_cBcoLogo+="Banco Itaú SA" //"LogoItau.bmp"
		_cDigBanco:="7"
	case _cBanco=="001" 
        _lContinua:=.t.
        _cBcoLogo+="Banco do Brasil" //"LogoItau.bmp"
        _cDigBanco:="9"
	case _cBanco=="033"
		_lContinua:=.t.
		_cBcoLogo+="BANESPA" //"logobanespa.bmp"
		_cDigBanco:="7"
	case _cBanco=="347"
		_lContinua:=.t.
		_cBcoLogo+="SUDAMERIS" //"LogoSudameris.bmp"
		_cDigBanco:="6"
	case _cBanco=="479"
		_lContinua:=.t.
		_cBcoLogo+="Banco Itaú SA" //"LogoBancoDeBoston.bmp"
		_cDigBanco:="0"
	case _cBanco=="422"
		_lContinua:=.t.
		_cBcoLogo+="SAFRA" //"LogoSafra.bmp"
		_cDigBanco:="7"
	case _cBanco=="237"
		_lContinua:=.t.
		_cBcoLogo+="BRADESCO" //"LogoBradesco.bmp"
		_cDigBanco:="2"
	case _cBanco=="643"
		_lContinua:=.t.
		_cBcoLogo+="BRADESCO" //"LogoBradesco.bmp"
		_cDigBanco:="2" 
	case _cBanco=="104"
		_lContinua:=.t.
		_cBcoLogo+="Caixa Economica" //"LogoCEF.bmp"
		_cDigBanco:="0"  
	case _cBanco=="104"
		_lContinua:=.t.
		_cBcoLogo+="Caixa Economica" //"LogoCEF.bmp"
		_cDigBanco:="0"		
	case _cBanco=="399"
		_lContinua:=.t.
		_cBcoLogo+="HSBC" //"LogoCEF.bmp"
		_cDigBanco:="9"
	case _cBanco=="389"
		_lContinua:=.t.
		_cBcoLogo+="MERCANTIL" //"LogoMercantil.bmp"
		_cDigBanco:="2" //falta verificar
	otherwise
		if empty(_cBanco)
			msgbox("O numero do banco nao foi informado")
		else
			msgbox("Nao ha layout previsto para o banco "+_cBanco)
		endif
endcase

_oprn:StartPage()


If _lContinua
	
	/******************/
	/* PRIMEIRA PARTE */
	/******************/
	
	nRow1 := 0
	
	/*
	
	// Inicio da Primeira Parte : Finalidade de Imprimir o Recebimento ou não do Boleto.
	
	
	If _cBanco = "341"
		_oprn:Say(nRow1+0130,0100,_cBcoLogo,ArialN15B,100)
	ElseIf	_cBanco = "104"
		_oprn:SayBitmap(nRow1+0130,0100,"logocx2.bmp", 310, 090 ) //553 x 224 -- 290 , 0480
	ElseIf	_cBanco = "001"
		_oprn:SayBitmap(nRow1+0130,0100,"lgsantander.bmp", 310, 090 ) // LGBB 553 x 224 -- 290 , 0480
	else
		_oprn:Say(nRow1+0130,0100,_cBcoLogo,ArialN15B,100)
	EndIf
	     
	If _cBanco = "643"
		_oprn:Say(nRow1+0130,0513,"|"+"237"+"-"+_cDigBanco+"|",ArialN22B,100)
	Else
		_oprn:Say(nRow1+0130,0513,"|"+_cBanco+"-"+_cDigBanco+"|",ArialN22B,100)
	EndIf
	
	_oprn:Say(nRow1+0154,1810,"Comprovante de Entrega",ArialN12,100)
	_oprn:Line(nRow1+0220,100,nRow1+0220,2300)
	
	_oprn:Say  (nRow1+0220,100 ,"Cedente",ArialN8,100)
	If _cBanco = "643"
		_oprn:say(nRow1+0270,100,"BANCO PINE S/A",ArialN10,100) //Cedente
	ElseIf _cBanco = "001"
		_oprn:say(nRow1+0270,100,"CONIMEL EMPRESA DE MATERIAL ELÉTRICO LTDA",ArialN10,100) //Cedente
	Else
		_oprn:say(nRow1+0270,100,AllTrim(sm0->m0_nomecom),ArialN10,100) //Cedente
	EndIf
	
	_oprn:Say  (nRow1+0220,1060,"Agência/Código Cedente",ArialN8,100)
	if _cBanco=="347" // Excecao para o banco Sudameris
		_oprn:Say(nRow1+0270,1060,alltrim(_cAgencia)+"/"+left(_cConta,7)+"/"+Substr(Alltrim(se1->e1_coddig),17,1),ArialN10,100)
	elseif _cBanco=="001" 
    	// _oprn:Say(nRow1+0270,1060,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,6),ArialN10,100)
    	_oprn:Say(nRow1+0270,1060,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,4)+"-"+Substr(Alltrim(_cConta),5,1),ArialN10,100)
   elseif _cBanco=="104"  	
      _oprn:Say(nRow1+0270,1060,"1358.003.00000294-6",ArialN10,100)    	
	elseif _cBanco=="341"
		_oprn:Say(nRow1+0270,1060,Substr(Alltrim(_cAgencia),1,4)+"/"+Substr(Alltrim(_cConta),1,5)+"-"+Substr(Alltrim(_cConta),6,1),ArialN10,100)
	elseif _cBanco=="033"
		_oprn:Say(nRow1+0270,1060,Substr(Alltrim(_cAgencia),2,3)+" "+Substr(Alltrim(_cConta),1,2)+" "+Substr(Alltrim(_cConta),3,5)+" "+Substr(Alltrim(_cConta),8,1),ArialN10,100)
	elseif _cBanco=="422"
		_oprn:Say(nRow1+0270,1060,strzero(val(alltrim(_cAgencia)),5)+"/"+ strzero(val(_cConta),9),ArialN10,100)
	elseif _cBanco=="237"            
	    _oprn:Say(nRow1+0270,1060,"0064-7"+"/"+"0311840-1",ArialN10,100)
		//_oprn:Say(nRow1+0270,1060,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,6)+"-"+Substr(Alltrim(_cConta),7,1),ArialN10,100)
	elseif _cBanco=="643"
		_oprn:Say(nRow1+0270,1060,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+"-"+Substr(Alltrim(_cConta),8,1),ArialN10,100)
	elseif _cBanco=="399"  
		// com divisoes de digito _oprn:Say(nRow1+0270,1060,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+"-"+Substr(Alltrim(_cConta),8,1),ArialN10,100)		
		_oprn:Say(nRow1+0270,1060,Substr(Alltrim(_cAgencia),1,4)+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+Substr(Alltrim(_cConta),8,1),ArialN10,100)		
	else
		_oprn:Say(nRow1+0270,1060,substr(alltrim(see->ee_cart),2,2)+"-"+Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+"-"+Substr(Alltrim(_cConta),8,1),ArialN10,100)
	endif
		_cCart:=	substr(alltrim(see->ee_cart),2,2)
	_oprn:Say(nRow1+0220,1510,"Nro.Documento",ArialN8,100)
	_oprn:say(nRow1+0270,1510,se1->e1_prefixo+se1->e1_num+se1->e1_parcela,ArialN10,100)    //Numero do titulo
	_NroDoc:= se1->e1_num+se1->e1_parcela                                                     
	
	
	_oprn:Say(nRow1+0320,100 ,"Sacado",ArialN8,100)
	_oprn:Say(nRow1+0370,100 ,substr(sa1->a1_nome,1,40),ArialN10,100)
	
	_oprn:Say(nRow1+0320,1060,"Vencimento",ArialN8,100)
	_oprn:say(nRow1+0370,1060,	Substr( Dtos(se1->e1_vencto),7,2 ) + "/" +  ;   //Dia
	Substr( Dtos(se1->e1_vencto),5,2 ) + "/" + ;    //Mes
	Substr( Dtos(se1->e1_vencto),1,4 ),ArialN10,100)  //Vencimento
	
	//Grava data de vencimento                                
	_DtVenc:= Substr( Dtos(se1->e1_vencto),7,2 ) + "/" +  ;   //Dia
	Substr( Dtos(se1->e1_vencto),5,2 ) + "/" + ;    //Mes
	Substr( Dtos(se1->e1_vencto),1,4 )  //Vencimento		
	
	_oprn:Say(nRow1+0320,1510,"Valor do Documento",ArialN8,100)
	if lDupdesc  
		_oprn:Say(nRow1+0370,1550,AllTrim(Transform(SE1->E1_VALOR,"@E 999,999,999.99")),ArialN10,100)
		_Valor:=AllTrim(Transform(SE1->E1_VALOR,"@E 999,999,999.99"))
	else
		_oprn:Say(nRow1+0370,1550,AllTrim(Transform(SE1->E1_VALOR-DescontoClass(),"@E 999,999,999.99")),ArialN10,100)
		_Valor:=AllTrim(Transform(SE1->E1_VALOR-DescontoClass(),"@E 999,999,999.99"))
	endif
	_oprn:Say  (nRow1+0450,0100,"Recebi(emos) o bloqueto/título",ArialN10,100)
	_oprn:Say  (nRow1+0490,0100,"com as características acima.",ArialN10,100)
	_oprn:Say  (nRow1+0420,1060,"Data",ArialN8,100)
	_oprn:Say  (nRow1+0420,1410,"Assinatura",ArialN8,100)
	_oprn:Say  (nRow1+0520,1060,"Data",ArialN8,100)
	_oprn:Say  (nRow1+0520,1410,"Entregador",ArialN8,100)
	
	_oprn:Line (nRow1+0320, 100,nRow1+0320,1900 )
	_oprn:Line (nRow1+0420, 100,nRow1+0420,1900 )
	_oprn:Line (nRow1+0520,1050,nRow1+0520,1900 ) //---
	_oprn:Line (nRow1+0620, 100,nRow1+0620,2300 )
	
	_oprn:Line (nRow1+0620,1050,nRow1+0220,1050 )
	_oprn:Line (nRow1+0620,1400,nRow1+0420,1400 )
	_oprn:Line (nRow1+0420,1500,nRow1+0220,1500 ) //--
	_oprn:Line (nRow1+0620,1900,nRow1+0220,1900 )
	
	_oprn:Say  (nRow1+0235,1910,"(  )Mudou-se"                                	,ArialN8,100)
	_oprn:Say  (nRow1+0275,1910,"(  )Ausente"                                    ,ArialN8,100)
	_oprn:Say  (nRow1+0315,1910,"(  )Não existe nº indicado"                  	,ArialN8,100)
	_oprn:Say  (nRow1+0355,1910,"(  )Recusado"                                	,ArialN8,100)
	_oprn:Say  (nRow1+0395,1910,"(  )Não procurado"                              ,ArialN8,100)
	_oprn:Say  (nRow1+0435,1910,"(  )Endereço insuficiente"                     	,ArialN8,100)
	_oprn:Say  (nRow1+0475,1910,"(  )Desconhecido"                            	,ArialN8,100)
	_oprn:Say  (nRow1+0515,1910,"(  )Falecido"                                   ,ArialN8,100)
	_oprn:Say  (nRow1+0555,1910,"(  )Outros(anotar no verso)"                  	,ArialN8,100)
	
	  // Fim da Primeira Parte : Finalidade de Imprimir o Recebimento ou não do Boleto.
	  */
	  
	
	/*****************/
	/* SEGUNDA PARTE */
	/*****************/
	
	nRow2 := 0
	
//	_oprn:Say(nRow2+0800,0010,replicate(".",0410),ArialN6,100) 
	
	_oprn:Line (nRow2+0196,100,nRow2+0196,2300)   
	
	If _cBanco = "341"
		_oprn:Say(nRow2+0100,0100,_cBcoLogo,ArialN15B,100)  
	ElseIf _cBanco = "104"
	   _oprn:SayBitmap(nRow2+0100,0100,"logocx2.bmp", 310, 090 ) //553 x 224 -- 290 , 0480	
	ElseIf _cBanco = "001"
	   _oprn:SayBitmap(nRow2+0100,0100,"LGBRASIL.BMP", 310, 090 ) //LGBB 553 x 224 -- 290 , 0480		   
	ElseIf _cBanco = "033"
	   _oprn:SayBitmap(nRow2+0100,0100,"lgsantander.BMP", 310, 090 ) //LGBB 553 x 224 -- 290 , 0480		      
	Else
		_oprn:Say(nRow2+0100,0100,_cBcoLogo,ArialN15B,100)
	EndIf
	
	If _cBanco = "643"
		_oprn:Say(nRow2+0106,0513,"|"+"237"+"-"+_cDigBanco+"|",ArialN22B,100)  
	Else
		_oprn:Say(nRow2+0106,0513,"|"+_cBanco+"-"+_cDigBanco+"|",ArialN22B,100)
	EndIf
	
	_oprn:Say(nRow2+0106,1810,"Recibo do Sacado",ArialN12,100)      
	
	_oprn:Line (nRow2+296,100,nRow2+296,2300 ) 
	_oprn:Line (nRow2+396,100,nRow2+396,2300 ) 
	_oprn:Line (nRow2+466,100,nRow2+466,2300 )  
	_oprn:Line (nRow2+536,100,nRow2+536,2300 )  
	
	_oprn:Line (nRow2+396,500,nRow2+536,500)    
	_oprn:Line (nRow2+466,750,nRow2+536,750)    
	_oprn:Line (nRow2+396,1000,nRow2+536,1000)  
	_oprn:Line (nRow2+396,1300,nRow2+536,1300)  
	_oprn:Line (nRow2+396,1480,nRow2+536,1480)  
	
	_oprn:Say  (nRow2+0195,100 ,"Local de Pagamento",ArialN8,100) 
	If _cBanco = "341"
		_oprn:Say  (nRow2+0211,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ OU BANERJ",ArialN10,100)  
		_oprn:Say  (nRow2+0251,400 ,"APÓS O VENCIMENTO, SOMENTE NO ITAÚ OU BANERJ",ArialN10,100)       
	Elseif _cBanco = "237"
		_oprn:Say  (nRow2+0211,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NAS AGENCIAS DO BRADESCO",ArialN10,100)
		_oprn:Say  (nRow2+0251,400 ,"APÓS O VENCIMENTO, SOMENTE NAS AGENCIAS DO BRADESCO",ArialN10,100)
	Elseif _cBanco = "643"
		_oprn:Say  (nRow2+0211,400 ,"PAGAR PREFERENCIALMENTE NAS AGENCIAS DO BRADESCO",ArialN10,100)
	Elseif _cBanco = "399"
		_oprn:Say  (nRow2+0211,400 ,"PAGAR PREFERENCIALMENTE EM AGENCIAS HSBC",ArialN10,100)	
	Elseif _cBanco = "104"                                                      
		_oprn:Say  (nRow2+0211,400 ,"PREFERENCIALMENTE NAS CASAS LOTÉRICAS E AGÊNCIAS DA CAIXA",ArialN10,100)		
	Else
		_oprn:Say  (nRow2+0221,400 ,"PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO",ArialN10,100)
	EndIf
	
	_oprn:Say  (nRow2+0196,1810,"Vencimento",ArialN8,100)
	cString :=   Dtoc(se1->e1_vencto)  // jas tirei o comentario
	nCol := 1750+(374-(len(cString)*22))
	_oprn:say(nRow2+0236,nCol, Substr( Dtos(se1->e1_vencto),7,2 ) + "/" +  ;   //Dia
	Substr( Dtos(se1->e1_vencto),5,2 ) + "/" + ;    //Mes
	Substr( Dtos(se1->e1_vencto),1,4 ),ArialN10,100)  //Vencimento
	                                 
	//Grava data de vencimento
	_DtVenc:=Substr( Dtos(se1->e1_vencto),7,2 ) + "/" +  ;   //Dia
	Substr( Dtos(se1->e1_vencto),5,2 ) + "/" + ;    //Mes
	Substr( Dtos(se1->e1_vencto),1,4 )  //Vencimento
	
    _oprn:Say  (nRow2+296,100 ,"Cedente" ,ArialN8,100)
	If _cBanco = "643"
		_oprn:say(nRow2+336,100,"BANCO PINE S/A",ArialN10,100) //Cedente
	ElseIf _cBanco = "001" .Or. _cBanco = "033"
    	_oprn:say(nRow2+336,100,"Nome da EMPRESA LTDA",ArialN10,100) //Cedente
	Else
		_oprn:say(nRow2+336,100,AllTrim(sm0->m0_nomecom),ArialN10,100) //Cedente
	EndIf
	
	_oprn:Say  (nRow2+296,1810,"Agência/Código Cedente",ArialN8,100)
	if _cBanco=="347" // Excecao para o banco Sudameris
	    _oprn:Say(nRow2+336,1985,alltrim(_cAgencia)+"/"+left(_cConta,7)+"/"+Substr(Alltrim(se1->e1_coddig),17,1),ArialN10,100)
    elseif _cBanco=="001" 
  	  //  _oprn:Say(nRow2+1070,1985,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,6),ArialN10,100)
  	  _oprn:Say(nRow2+336,1985,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,4)+"-"+Substr(Alltrim(_cConta),5,1),ArialN10,100)
   elseif _cBanco=="104"  	
      _oprn:Say(nRow2+336,1910,"1358.003.00000294-6",ArialN10,100)
  	elseif _cBanco=="341"                             
		_oprn:Say(nRow2+336,1985,Substr(Alltrim(_cAgencia),1,4)+"/"+Substr(Alltrim(_cConta),1,5)+"-"+Substr(Alltrim(_cConta),6,1),ArialN10,100)
	elseif _cBanco=="033"
		_oprn:Say(nRow2+336,1985,Substr(Alltrim(_cAgencia),2,3)+" "+Substr(Alltrim(_cConta),1,2)+" "+Substr(Alltrim(_cConta),3,5)+" "+Substr(Alltrim(_cConta),8,1),ArialN10,100)
	elseif _cBanco=="422"
		_oprn:Say(nRow2+336,1985,strzero(val(alltrim(_cAgencia)),5)+"/"+ strzero(val(_cConta),9),ArialN10,100)
	elseif _cBanco=="237"
	    _oprn:Say(nRow2+336,1985,"0064-7"+"/"+"0311840-1",ArialN10,100)
		//_oprn:Say(nRow2+1070,1985,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,6)+"-"+Substr(Alltrim(_cConta),7,1),ArialN10,100)
	elseif _cBanco=="643"
		_oprn:Say(nRow2+336,1910,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+"-"+Substr(Alltrim(_cConta),8,1),ArialN10,100)
	elseif _cBanco=="399"  
		// com divisoes do digito  _oprn:Say(nRow2+1070,1910,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+"-"+Substr(Alltrim(_cConta),8,1),ArialN10,100)		
		_oprn:Say(nRow2+336,1910,Substr(Alltrim(_cAgencia),1,4)+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+Substr(Alltrim(_cConta),8,1),ArialN10,100)		
	else
		_oprn:Say(nRow2+336,1910,substr(alltrim(see->ee_cart),2,2)+"-"+Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+"-"+Substr(Alltrim(_cConta),8,1),ArialN10,100)
	endif 
	_cCart:=	substr(alltrim(see->ee_cart),2,2)
	
	
	_oprn:Say  (nRow2+396,100 ,"Data do Documento" ,ArialN8,100)
	_oprn:Say  (nRow2+426,100,	Substr( Dtos(se1->e1_emissao),7,2 ) + "/" +  ;   //Dia
	Substr( Dtos(se1->e1_emissao),5,2 ) + "/" + ;    //Mes
	Substr( Dtos(se1->e1_emissao),1,4 ),ArialN10,100)  //Vencimento
	_oprn:Say  (nRow2+396,505 ,"Nro.Documento",ArialN8,100)
	_oprn:say  (nRow2+426,605,se1->e1_prefixo+se1->e1_num+se1->e1_parcela,ArialN10,100)    //Numero do titulo
	_NroDoc:= se1->e1_num+se1->e1_parcela                 
	
	_oprn:Say  (nRow2+396,1005,"Espécie Doc.",ArialN8,100)
	If _cBanco=="399"  
	   _oprn:Say  (nRow2+426,1050,"PD",ArialN10,100) //Tipo do Titulo
	Else
	   _oprn:Say  (nRow2+426,1050,"DM",ArialN10,100) //Tipo do Titulo
	EndIf
	_oprn:Say  (nRow2+396,1305,"Aceite",ArialN8,100)
	_oprn:Say  (nRow2+426,1400,"N",ArialN10,100)
	
	// Data impressao
	_oprn:Say  (nRow2+396,1485,"Data do Processamento",ArialN8,100)
	_oprn:Say  (nRow2+426,1550,	Substr( Dtos(se1->e1_emissao),7,2 ) + "/" +  ;   //Dia
	Substr( Dtos(se1->e1_emissao),5,2 ) + "/" + ;    //Mes
	Substr( Dtos(se1->e1_emissao),1,4 ),ArialN10,100)  //Vencimento
	
	If _cBanco $ "237/643"
	   _oprn:Say  (nRow2+396,1810,"Carteira / Nosso Número",ArialN8,100)
	Else 
	  _oprn:Say  (nRow2+396,1810,"Nosso Número",ArialN8,100)
	EndIf                                                       
	
	if _cBanco=="347"
		cString := substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1)+ right(AllTrim(se1->e1_numbco),1)
	elseif _cBanco $ "237/643"
		cString := substr(alltrim(see->ee_cart),2,2)+if(empty(see->ee_cart),"","/")+substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + "-" + right(AllTrim(se1->e1_numbco),1)
		_cCart:=	substr(alltrim(see->ee_cart),2,2)                                     
		// jas cString := "99 / "+substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + "-" + right(AllTrim(se1->e1_numbco),1)
		// jas _cCart:=	substr(alltrim(see->ee_cart),2,2)                                     
	elseif _cBanco=="422"
		cString := substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + right(AllTrim(se1->e1_numbco),1)
	elseif _cBanco=="001"
	    cString := "1534999" + substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) //+ "-" + right(AllTrim(se1->e1_numbco),1)
	   //cString :=substr(se1->e1_codbar,26,17)
	  // cString :="1534999"
	elseif _cBanco=="104" // CAIXABOL 
	   // cString := substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + "-" + right(AllTrim(se1->e1_numbco),1)
	   // ANTES cString :=substr(se1->e1_codbar,20,10)+"-"+substr(se1->e1_codbar,5,1)
	   cString :=SubStr(Alltrim(se1->e1_numbco),1,10)+"-"+SubStr(Alltrim(se1->e1_numbco),11,1)
	  // cString :="1534999"	  
	elseif _cBanco=="033"
		cString := Substr(see->ee_agencia,2,3)+" "+substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1)+" "+right(AllTrim(se1->e1_numbco),1)
  elseif _cBanco=="399"	
      //cString := "29944"
      cString :=SubStr(Alltrim(se1->e1_numbco),1,10)+"-"+SubStr(Alltrim(se1->e1_numbco),11,1)
	else
		cString := alltrim(see->ee_cart)+if(empty(see->ee_cart),"","/")+substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + "-" + right(AllTrim(se1->e1_numbco),1)
	endif                             
	If _cBanco $ "237/643/001"
	  _cCart:=	substr(alltrim(see->ee_cart),2,2)
	  //jas _cCart:= "09"
	  nCol :=  1850+(374-(len(cString)*22))  // 1750+(374-(len(cString)*22))        // 1900+(374-(len(cString)*22))                                                                                                                                                                                                                          
	  _oprn:Say  (nRow2+426,nCol,cString,ArialN10,100)
	Else
	  _cCart:=	substr(alltrim(see->ee_cart),2,2)
	  nCol :=  1810+(374-(len(cString)*22))  // 1750+(374-(len(cString)*22))        // 1900+(374-(len(cString)*22))                                                                                                                                                                                                                          
	  _oprn:Say  (nRow2+426,nCol,cString,ArialN10,100)
	EndIf  
	
	_oprn:Say  (nRow2+466,100 ,"Uso do Banco",ArialN8,100)
	
	_oprn:Say  (nRow2+466,505 ,"Carteira",ArialN8,100)                              
	
	If _cBanco=="001"	                                               
	    _oprn:Say  (nRow2+496,555 ,"17/019",ArialN10,100) //Codigo da Carteira
	ElseIf _cBanco=="237"	
	    _oprn:Say  (nRow2+496,555 ,"09",ArialN10,100) //Codigo da Carteira
	ElseIf _cBanco=="104"	
	    // _oprn:Say  (nRow2+1230,555 ,"9",ArialN10,100) //Codigo da Carteira    
	    _cCart:=substr(alltrim(see->ee_cart),1,2)
	    // alert("carteira")
	    //_oprn:Say(nRow2+1230,555,"CR",ArialN10,100) //Codigo da Carteira    
	    _oprn:Say(nRow2+496,555,_cCart,ArialN10,100) //Codigo da Carteira    
	Else
	   _oprn:Say  (nRow2+496,555,see->ee_cart,ArialN10,100) //Codigo da Carteira
	EndIf
	
	_cCart:=	substr(alltrim(see->ee_cart),1,2)
  	
	_oprn:Say  (nRow2+466,755 ,"Espécie",ArialN8,100)
	_oprn:Say  (nRow2+496,805 ,"R$",ArialN10,100)
	
	_oprn:Say  (nRow2+466,1005,"Quantidade",ArialN8,100)
	_oprn:Say  (nRow2+466,1485,"Valor",ArialN8,100)
	
	_oprn:Say  (nRow2+466,1810,"Valor do Documento",ArialN8,100)
	cString := Alltrim(Transform(se1->e1_valor,"@E 99,999,999.99"))
	_Valor:=AllTrim(Transform(SE1->E1_VALOR,"@E 999,999,999.99"))
	/*jas
	if lDupdesc
	  cString := Alltrim(Transform(se1->e1_valor,"@E 99,999,999.99"))
	  _Valor:=AllTrim(Transform(SE1->E1_VALOR,"@E 999,999,999.99"))
   else  
	cString := Alltrim(Transform(se1->e1_valor-DescontoClass(),"@E 99,999,999.99"))
   EndIf	
   */
	_Valor:=AllTrim(Transform(SE1->E1_VALOR-DescontoClass(),"@E 999,999,999.99"))
	nCol := 1870+(374-(len(cString)*22))
	_oprn:Say  (nRow2+496,nCol,cString ,ArialN10,100)
	
	_oprn:Say  (nRow2+536,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",ArialN8,100)
  //	If Empty(_cInst3)
		_oprn:Say  (nRow2+636,100,"Juros de mora : 0,33% ao dia ", ArialN10,100)
	//Else
	//	_oprn:Say  (nRow2+1370,100,TABELA("SF",_cBanco+_cInst3,"X5_DESCRI"), ArialN10,100)
	//Endif                                      
/*
Juros de mora : 0,33% ao dia 
 Protestar após 5 dias úteis do vencimento.
 Não dispensar juros de mora após vencimento. 
 */
	
	//If Empty (_cInst1)
		_oprn:Say  (nRow2+686,100,"Protestar após 5 dias úteis do vencimento.", ArialN10,100)
	//Else
	//	_oprn:Say  (nRow2+1420,100,TABELA("SF",_cBanco+_cInst1,"X5_DESCRI"), ArialN10,100)
	//Endif
	
	//If Empty (_cInst2)
		_oprn:Say  (nRow2+736,100," Não dispensar juros de mora após vencimento. ", ArialN10,100)  
		If _cBanco=="104"
			_oprn:Say  (nRow2+786,100," APÓS VENCIMENTO PAGÁVEL NAS AGÊNCIAS DA CAIXA. ", ArialN10,100)
		ElseIf _cBanco=="341"
			_oprn:Say  (nRow2+786,100," APÓS VENCIMENTO PAGÁVEL NAS AGÊNCIAS DO BANCO ITAU. ", ArialN10,100)
		eLSEIf _cBanco=="399"
			_oprn:Say  (nRow2+786,100," APÓS VENCIMENTO PAGÁVEL NAS AGÊNCIAS DO HSBC. ", ArialN10,100)
		ElseIf _cBanco=="237" .or. _cBanco=="643"
			_oprn:Say  (nRow2+786,100," APÓS VENCIMENTO PAGÁVEL NAS AGÊNCIAS DO BRADESCO. ", ArialN10,100)
		ElseIf _cBanco=="001"
			_oprn:Say  (nRow2+786,100," APÓS VENCIMENTO PAGÁVEL NAS AGÊNCIAS DO BANCO DO BRASIL. ", ArialN10,100)
		Else 
			_oprn:Say  (nRow2+786,100," APÓS VENCIMENTO ENTRAR EM CONTATO COM O DEPT. COBRANÇA. ", ArialN10,100)
		Endif									
	//Else
	//	_oprn:Say  (nRow2+1470,100,TABELA("SF",_cBanco+_cInst2,"X5_DESCRI"), ArialN10,100)
	//Endif
	_oprn:Say  (nRow2+836,100,"", ArialN10,100)   //    _oprn:Say  (nRow2+1520,100,"", ArialN10,100)
	
	_oprn:Say  (nRow2+536,1810,"(-)Desconto/Abatimento",ArialN8,100)
	_oprn:Say  (nRow2+616,1810,"(-)Outras Deduções",ArialN8,100)
	_oprn:Say  (nRow2+676,1810,"(+)Mora/Multa",ArialN8,100)
	_oprn:Say  (nRow2+746,1810,"(+)Outros Acréscimos",ArialN8,100)
	_oprn:Say  (nRow2+816,1810,"(=)Valor Cobrado",ArialN8,100)
	
	_oprn:Say  (nRow2+886,100 ,"Sacado",ArialN8,100)
	_oprn:Say  (nRow2+896,400,substr(sa1->a1_nome,1,40),ArialN10,100)
	_oprn:Say  (nRow2+939,400,sa1->(if(empty(a1_endcob),a1_end,a1_endcob)+" "+;
	if(empty(a1_bairroc),a1_bairro,a1_bairroc)),ArialN10,100)
		_oprn:Say  (nRow2+982,400,sa1->(if(empty(a1_cepc),a1_cep,a1_cepc)+" "+;
		if(empty(a1_munc),a1_mun,a1_munc)+" "+;
			if(empty(a1_estc),a1_est,a1_estc)),ArialN10,100)
				_oprn:Say  (nRow2+1091,400,sa1->(tran(a1_cgc,if(len(alltrim(a1_cgc))<12,"@r 999.999.999-99","@r 99.999.999/9999-99"))+;
				"               "+a1_inscr),ArialN10,100)
				_oprn:Say  (nRow2+1091,100 ,"Sacador/Avalista",ArialN8,100)
				If _cBanco = "643"
					_oprn:say(nRow2+1086,0400,AllTrim(sm0->m0_nomecom)+"  CNPJ: "+TRANSFORM(sm0->m0_cgc,"@r 99.999.999/9999-99"),ArialN10,100) //Avalista
				EndIf
				_oprn:Say  (nRow2+1131,1500,"Autenticação Mecânica",ArialN8,100)
				_oprn:Line (nRow2+0196,1800,nRow2+0886,1800 )
				_oprn:Line (nRow2+0606,1800,nRow2+0606,2300 )
				_oprn:Line (nRow2+0676,1800,nRow2+0676,2300 )
				_oprn:Line (nRow2+0746,1800,nRow2+0746,2300 )
				_oprn:Line (nRow2+0816,1800,nRow2+0816,2300 )
				_oprn:Line (nRow2+0886,100 ,nRow2+0886,2300 )
				_oprn:Line (nRow2+1126,100 ,nRow2+1126,2300 )
				
				/******************/
				/* TERCEIRA PARTE */
				/******************/
				
				//nRow3 := 0
				nRow3 :=-40 
				_oprn:Say(nRow3+1386,0010,replicate(".",0410),ArialN6,100)
				_oprn:Line (nRow3+1636,100,nRow3+1636,2300)
				If _cBanco = "341"
					_oprn:Say(nRow3+1538,0100,_cBcoLogo,ArialN15B,100)
				ElseIf _cBanco = "104"
				    _oprn:SayBitmap(nRow3+1538,0100,"logocx2.bmp", 310, 090 ) //553 x 224 -- 290 , 0480		
				ElseIf _cBanco = "001"
				    _oprn:SayBitmap(nRow3+1538,0100,"LGBRASIL.bmp", 310, 090 ) //LGBB 553 x 224 -- 290 , 0480						    
				ElseIf _cBanco = "033"
				    _oprn:SayBitmap(nRow3+1538,0100,"lgsantander.BMP", 310, 090 ) //LGBB 553 x 224 -- 290 , 0480						        
				Else
					_oprn:Say(nRow3+1538,0100,_cBcoLogo,ArialN15B,100)
				EndIf
				                                                                       
				If _cBanco = "643"
					_oprn:Say(nRow3+1541,0513,"|"+"237"+"-"+_cDigBanco+"|",ArialN22B,100)
				Else
					_oprn:Say(nRow3+1541,0513,"|"+_cBanco+"-"+_cDigBanco+"|",ArialN22B,100)
				EndIf
				                                  
				If _cBanco<>'399'
				   _cCodBar:=alltrim(se1->e1_codbar)			
				   _cNumBol:=alltrim(se1->e1_coddig)
				else  
				   _cCodBar:=alltrim(se1->e1_codbar)			
				   _cNumBol:=alltrim(se1->e1_coddig)
				//    _cNumBol:=alltrim(se1->e1_codbar)			
				//   _cCodBar:=alltrim(se1->e1_coddig)
				Endif  
				_cCodBarLit:=left(_cNumBol,5)+"."+substr(_cNumBol,6,5)+"   "+;
				substr(_cNumBol,11,5)+"."+substr(_cNumBol,16,6)+"   "+;
				substr(_cNumBol,22,5)+"."+substr(_cNumBol,27,6)+"   "+;
				substr(_cNumBol,33,1)+"   "+;
				substr(_cNumBol,34)                                            
			                                                            
			
				_oprn:Say(nRow3+1575,785,_cCodBarLit,ArialN14B,100)
				
				_oprn:Line (nRow3+1736,100,nRow3+1736,2300 )
				_oprn:Line (nRow3+1836,100,nRow3+1836,2300 )
				_oprn:Line (nRow3+1906,100,nRow3+1906,2300 )
				_oprn:Line (nRow3+1976,100,nRow3+1976,2300 )
				
				_oprn:Line (nRow3+1836,500 ,nRow3+1976,500 )
				_oprn:Line (nRow3+1906,750 ,nRow3+1976,750 )
				_oprn:Line (nRow3+1836,1000,nRow3+1976,1000)
				_oprn:Line (nRow3+1836,1300,nRow3+1906,1300)
				_oprn:Line (nRow3+1836,1480,nRow3+1976,1480)
				
				_oprn:Say  (nRow3+1636,100 ,"Local de Pagamento",ArialN8,100)
				If _cBanco = "341"
					_oprn:Say  (nRow3+1651,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ ",ArialN10,100)
					_oprn:Say  (nRow2+1691,400 ,"APÓS O VENCIMENTO, SOMENTE NO ITAÚ ",ArialN10,100)
				Elseif _cBanco = "237"
					_oprn:Say  (nRow3+1651,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NAS AGENCIAS DO BRADESCO",ArialN10,100)
					_oprn:Say  (nRow2+1691,400 ,"APÓS O VENCIMENTO, SOMENTE NAS AGENCIAS DO BRADESCO",ArialN10,100)
				Elseif _cBanco = "643"
					_oprn:Say  (nRow3+1651,400 ,"PAGAR PREFERENCIALMENTE NAS AGENCIAS DO BRADESCO",ArialN10,100)
				Elseif _cBanco = "399"
					_oprn:Say  (nRow3+1651,400 ,"PAGAR PREFERENCIALMENTE EM AGENCIAS HSBC",ArialN10,100)	
				Elseif _cBanco = "104"	
					_oprn:Say  (nRow2+1651,400 ,"PREFERENCIALMENTE NAS CASAS LOTÉRICAS E AGÊNCIAS DA CAIXA",ArialN10,100)
				Else      
					_oprn:Say  (nRow2+1651,400 ,"PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO",ArialN10,100)
				EndIf                                            
				
				_oprn:Say  (nRow3+1636,1810,"Vencimento",ArialN8,100)
				nCol := 1810+(374-(len(cString)*22))
				_oprn:say(nRow3+1666,nCol, Substr( Dtos(se1->e1_vencto),7,2 ) + "/" +  ;   //Dia
				Substr( Dtos(se1->e1_vencto),5,2 ) + "/" + ;    //Mes
				Substr( Dtos(se1->e1_vencto),1,4 ),ArialN10,100)  //Vencimento				
				            
                                                         
				_oprn:Say  (nRow3+1736,100 ,"Cedente" ,ArialN8,100)
				If _cBanco = "643"
					_oprn:say(nRow3+1776,100,"BANCO PINE S/A",ArialN10,100) //Cedente
                ElseIf _cBanco = "001"
				    _oprn:say(nRow3+1776,100,"CONIMEL EMPRESA DE MATERIAL ELÉTRICO LTDA",ArialN10,100) //Cedente
				Else                                                                                                                                                                                         
					_oprn:say(nRow3+1776,100,AllTrim(sm0->m0_nomecom),ArialN10,100) //Cedente
				EndIf
				
				_oprn:Say  (nRow3+1736,1810,"Agência/Código Cedente",ArialN8,100)     
				if _cBanco=="347" // Excecao para o banco Sudameris
					_oprn:Say(nRow3+1776,1980,alltrim(_cAgencia)+"/"+left(_cConta,7)+"/"+Substr(Alltrim(se1->e1_coddig),17,1),ArialN10,100)
 				elseif _cBanco=="341"
					_oprn:Say(nRow3+1776,1980,Substr(alltrim(_cAgencia),1,4)+"/"+Substr(Alltrim(_cConta),1,5)+"-"+Substr(Alltrim(_cConta),6,1),ArialN10,100)
			    elseif _cBanco=="001" 
    				//_oprn:Say(nRow3+2410,1980,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,6),ArialN10,100)
    				_oprn:Say(nRow3+1776,1980,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,4)+"-"+Substr(Alltrim(_cConta),5,1),ArialN10,100)
             elseif _cBanco=="104"  	
                _oprn:Say(nRow3+1776,1910,"1358.003.00000294-6",ArialN10,100)
				elseif _cBanco=="033"
					_oprn:Say(nRow3+1776,1980,Substr(Alltrim(_cAgencia),2,3)+" "+Substr(Alltrim(_cConta),1,2)+" "+Substr(Alltrim(_cConta),3,5)+" "+Substr(Alltrim(_cConta),8,1),ArialN10,100)
				elseif _cBanco=="422"
					_oprn:Say(nRow3+1776,1980,strzero(val(alltrim(_cAgencia)),5)+"/"+ strzero(val(_cConta),9),ArialN10,100)
				elseif _cBanco=="237"                
				      _oprn:Say(nRow3+1776,1980,"0064-7"+"/"+"0311840-1",ArialN10,100)
					//_oprn:Say(nRow3+2410,1980,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,6)+"-"+Substr(Alltrim(_cConta),7,1),ArialN10,100)
				elseif _cBanco=="643"
					_oprn:Say(nRow3+1776,1910,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+"-"+Substr(Alltrim(_cConta),8,1),ArialN10,100)
				elseif _cBanco=="399"  
					// com divisoes dos digitos   _oprn:Say(nRow3+2410,1910,Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+"-"+Substr(Alltrim(_cConta),8,1),ArialN10,100)					
					_oprn:Say(nRow3+1776,1910,Substr(Alltrim(_cAgencia),1,4)+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+Substr(Alltrim(_cConta),8,1),ArialN10,100)					
				else
					_oprn:Say(nRow3+1776,1910,substr(alltrim(see->ee_cart),2,2)+"-"+Substr(Alltrim(_cAgencia),1,4)+"-"+Substr(Alltrim(_cAgencia),5,1)+"/"+Substr(Alltrim(_cConta),1,7)+"-"+Substr(Alltrim(_cConta),8,1),ArialN10,100)
				endif
				
				_oprn:Say  (nRow3+1836,100 ,"Data do Documento" ,ArialN8,100)
				_oprn:Say  (nRow3+1866,100,	Substr( Dtos(se1->e1_emissao),7,2 ) + "/" +;   //Dia
				Substr( Dtos(se1->e1_emissao),5,2 ) + "/" +;    //Mes
				Substr( Dtos(se1->e1_emissao),1,4 ),ArialN10,100)  //Vencimento
				_oprn:Say  (nRow3+1836,505 ,"Nro.Documento",ArialN8,100)
				_oprn:say  (nRow3+1866,605,se1->e1_prefixo+se1->e1_num+se1->e1_parcela,ArialN10,100)    //Numero do titulo
				_NroDoc:= se1->e1_num+se1->e1_parcela                 
				
				_oprn:Say  (nRow3+1836,1005,"Espécie Doc.",ArialN8,100)
				_oprn:Say  (nRow3+1866,1050,"DM",ArialN10,100) //Tipo do Titulo
				
				_oprn:Say  (nRow3+1836,1305,"Aceite",ArialN8,100)
				_oprn:Say  (nRow3+1866,1400,"N",ArialN10,100)
				
				// Data impressao
				_oprn:Say  (nRow3+1836,1485,"Data do Processamento",ArialN8,100)
				_oprn:Say  (nRow3+1866,1550,	Substr( Dtos(se1->e1_emissao),7,2 ) + "/" +  ;   //Dia
				Substr( Dtos(se1->e1_emissao),5,2 ) + "/" + ;    //Mes
				Substr( Dtos(se1->e1_emissao),1,4 ),ArialN10,100)  //Vencimento
				
				If _cBanco $ "237/643"                              
				   _oprn:Say  (nRow3+1836,1810,"Carteira / Nosso Número",ArialN8,100)
				Else 
				   _oprn:Say  (nRow3+1836,1810,"Nosso Número",ArialN8,100)
				EndIf   
				
				if _cBanco=="347"
					cString := substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1)+ right(AllTrim(se1->e1_numbco),1)
		        elseif _cBanco=="001"
		            cString := "1534999" + substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) //+ "-" + right(AllTrim(se1->e1_numbco),1)
		            //cString :=substr(se1->e1_codbar,26,17)
		            //cString :="1534999"       
		                                           
	         elseif _cBanco=="104" // CAIXABOL                          
	             // cString := substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + "-" + right(AllTrim(se1->e1_numbco),1)
	             // antes cString :=substr(se1->e1_codbar,20,10)+"-"+substr(se1->e1_codbar,5,1)
	             cString :=SubStr(Alltrim(se1->e1_numbco),1,10)+"-"+SubStr(Alltrim(se1->e1_numbco),11,1)
	             // cString :="1534999"	  		            
				elseif _cBanco $ "237/643"                  
					cString := substr(alltrim(see->ee_cart),2,2)+if(empty(see->ee_cart),"","/")+substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + "-" + right(AllTrim(se1->e1_numbco),1)
					// jas cString := "99 / "+substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + "-" + right(AllTrim(se1->e1_numbco),1)
				elseif _cBanco=="422"
					cString := substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + right(AllTrim(se1->e1_numbco),1)
				elseif _cBanco=="033"
					cString := Substr(see->ee_agencia,2,3)+" "+substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1)+" "+right(AllTrim(se1->e1_numbco),1)
				elseif _cBanco=="399"                     
					//cString := "29944"
					cString :=SubStr(Alltrim(se1->e1_numbco),1,10)+"-"+SubStr(Alltrim(se1->e1_numbco),11,1)
				else                     
					cString := alltrim(see->ee_cart)+if(empty(see->ee_cart),"","/")+substr(se1->e1_numbco,1,len(Alltrim(se1->e1_numbco))-1) + "-" + right(AllTrim(se1->e1_numbco),1)
				endif
				If _cBanco $ "237/643/001"
				   nCol :=  1850+(374-(len(cString)*22))  // 1750+(374-(len(cString)*22))   // 1900+(374-(len(cString)*22))
				   _oprn:Say  (nRow3+1866,nCol,cString,ArialN10,100)
				Else 
				   nCol :=  1810+(374-(len(cString)*22))  // 1750+(374-(len(cString)*22))   // 1900+(374-(len(cString)*22))
				   _oprn:Say  (nRow3+1866,nCol,cString,ArialN10,100)
				EndIf   
				
				_oprn:Say  (nRow3+1906,100 ,"Uso do Banco",ArialN8,100)
				
				_oprn:Say  (nRow3+1906,505 ,"Carteira",ArialN8,100)
				                                                                                                                                       
				If _cBanco=="001"	
	               _oprn:Say  (nRow3+1936,555 ,"17/019",ArialN10,100)                                
	            ElseIf _cBanco=="237"	
	               _oprn:Say  (nRow3+1936,555 ,"09",ArialN10,100)
	            ElseIf _cBanco=="104"	
	               _cCart:=substr(alltrim(see->ee_cart),1,2)
	               _oprn:Say  (nRow3+1936,555 ,_cCart,ArialN10,100)   
	               //_oprn:Say  (nRow3+2570,555 ,"9",ArialN10,100)   
	            Else                                                                                              
	              _oprn:Say  (nRow3+1936,555 ,see->ee_cart,ArialN10,100)   
			    EndIf
				
				
				_oprn:Say  (nRow3+1906,755 ,"Espécie",ArialN8,100)
				_oprn:Say  (nRow3+1936,805 ,"R$",ArialN10,100)
				
				_oprn:Say  (nRow3+1906,1005,"Quantidade",ArialN8,100)
				_oprn:Say  (nRow3+1906,1485,"Valor",ArialN8,100)
				
				_oprn:Say  (nRow3+1906,1810,"Valor do Documento",ArialN8,100)    
				cString := Alltrim(Transform(se1->e1_valor,"@E 99,999,999.99"))
				/*
				jas
				if lDupdesc
				  cString := Alltrim(Transform(se1->e1_valor,"@E 99,999,999.99"))
				else
				  cString := Alltrim(Transform(se1->e1_valor-DescontoClass(),"@E 99,999,999.99"))
				endif
				*/
				nCol := 1870+(374-(len(cString)*22))
				_oprn:Say  (nRow3+1936,nCol,cString ,ArialN10,100)
				
				_oprn:Say  (nRow3+1976,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",ArialN8,100)
				
			//	If Empty (_cInst3)
					_oprn:Say  (nRow3+2076,100 ,"Juros de mora : 0,33% ao dia", ArialN10,100)
			//	Else
			//		_oprn:Say  (nRow3+2710,100 ,TABELA("SF",_cBanco+_cInst3,"X5_DESCRI"), ArialN10,100)
			//	Endif
	/*
Juros de mora : 0,33% ao dia 
 Protestar após 5 dias úteis do vencimento.
 Não dispensar juros de mora após vencimento. 
 */			
			//	If Empty (_cInst1)
					_oprn:Say  (nRow3+2126,100,"Protestar após 5 dias úteis do vencimento", ArialN10,100)
			//	Else
			//		_oprn:Say  (nRow3+2760,100 ,TABELA("SF",_cBanco+_cInst1,"X5_DESCRI"), ArialN10,100)
			//	Endif
				
			//	If Empty (_cInst2)
					_oprn:Say  (nRow3+2176,100,"Não dispensar juros de mora após vencimento", ArialN10,100)
					_oprn:Say  (nRow2+2226,100," APÓS VENCIMENTO PAGÁVEL NAS AGÊNCIAS DA CAIXA. ", ArialN10,100)
			//	Else
			//		_oprn:Say  (nRow3+2810,100 ,TABELA("SF",_cBanco+_cInst2,"X5_DESCRI"), ArialN10,100)
			//	Endif
				                   
				_oprn:Say  (nRow3+2276,100,"", ArialN10,100)
				_oprn:Say  (nRow3+1976,1810,"(-)Desconto/Abatimento",ArialN8,100)
				_oprn:Say  (nRow3+2046,1810,"(-)Outras Deduções",ArialN8,100)
				_oprn:Say  (nRow3+2116,1810,"(+)Mora/Multa",ArialN8,100)
				_oprn:Say  (nRow3+2186,1810,"(+)Outros Acréscimos",ArialN8,100)
				_oprn:Say  (nRow3+2256,1810,"(=)Valor Cobrado",ArialN8,100)
				_oprn:Say  (nRow3+2326,100 ,"Sacado",ArialN8,100)
				_oprn:Say  (nRow3+2336,400,substr(sa1->a1_nome,1,40),ArialN10,100)
				_oprn:Say  (nRow3+2379,400,sa1->(if(empty(a1_endcob),a1_end,a1_endcob)+" "+;
				if(empty(a1_bairroc),a1_bairro,a1_bairroc)),ArialN10,100)
					_oprn:Say  (nRow3+2422,400,sa1->(if(empty(a1_cepc),a1_cep,a1_cepc)+" "+;
					if(empty(a1_munc),a1_mun,a1_munc)+" "+;
						if(empty(a1_estc),a1_est,a1_estc)),ArialN10,100)
							_oprn:Say  (nRow3+2465,400,sa1->(tran(a1_cgc,if(len(alltrim(a1_cgc))<12,"@r 999.999.999-99","@r 99.999.999/9999-99"))+;
							"               "+a1_inscr),ArialN10,100)
							_oprn:Say  (nRow3+2531,100 ,"Sacador/Avalista",ArialN8,100) //JAS
							If _cBanco = "643"
								_oprn:say(nRow3+2526,0400,AllTrim(sm0->m0_nomecom)+"  CNPJ: "+TRANSFORM(sm0->m0_cgc,"@r 99.999.999/9999-99"),ArialN10,100) //Avalista
							EndIf
							_oprn:Say  (nRow3+2571,1500,"Autenticação Mecânica - Ficha de Compensação",ArialN8,100)
							//nRow3:=nRow3+3205
							
							/*
							JAS LINHA ORIGINAL 
						   	_oprn:Line (nRow3+2270,1800,nRow3+2960,1800 )
						    _oprn:Line (nRow3+2680,1800,nRow3+2680,2300 )
							_oprn:Line (nRow3+2750,1800,nRow3+2750,2300 )
							_oprn:Line (nRow3+2820,1800,nRow3+2820,2300 )
							_oprn:Line (nRow3+2890,1800,nRow3+2890,2300 )
							_oprn:Line (nRow3+2960,100 ,nRow3+2960,2300 )
							_oprn:Line (nRow3+3200,100,nRow3+3200,2300  )
							  */
							  
							_oprn:Line (nRow3+1636,1800,nRow3+2326,1800 )
						    _oprn:Line (nRow3+2046,1800,nRow3+2046,2300 )
							_oprn:Line (nRow3+2116,1800,nRow3+2116,2300 )
							_oprn:Line (nRow3+2186,1800,nRow3+2186,2300 )
							_oprn:Line (nRow3+2256,1800,nRow3+2256,2300 )
							_oprn:Line (nRow3+2326,100 ,nRow3+2326,2300 )
							_oprn:Line (nRow3+2566,100,nRow3+2566,2300  )
							
						
							//_oprn:Say  (nRow3+3205,1500,"Autenticação Mecânica - Ficha de Compensação",ArialN8,100)
					       		  
						   
					   //	MSBAR("INT25",28.0,1.50,_cCodBar,_oprn,.F., ,	,   	,1.500,    ,   ,  ,.F.)	
				     // 	MSBAR2("INT25",28.0,1.5,_cCodBar,_oprn,.F.,,.T.,0.011,0.8,NIL,NIL,NIL,.F.)                        
				     //MSBAR("INT25",28.0,1.5,_cCodBar,_oprn,.F.   ,     ,.T.  ,0.01  ,100.7  ,NIL    ,NIL  ,NIL  ,.F.)       
				            MSBAR("INT25",22.55,1.5,_cCodBar,_oprn,.F.   ,     ,.T.  ,Nil  ,Nil  ,NIL    ,NIL  ,NIL  ,.F.)
				            //MSBAR("INT25",28.90,1.5,_cCodBar,_oprn,.F.   ,     ,.T.  ,Nil  ,Nil  ,NIL    ,NIL  ,NIL  ,.F.)
							_oprn:endpage()  
							                                                              
						endif                                                             
return

//***********************************************************************************
//*Static Function DescontoClass()                                                    *
//***********************************************************************************
//*Retorna Valor de desconto para as empresas com tipo de grupo fiscal '001' e '003'*
//*         e Produto com Clas Fiscal 'P' e 'A'.                                    *
//*                                                                                 *
//***********************************************************************************
Static Function DescontoClass()
local nTotalRet:=0
Local aCondicao:={}
Local nValRet:=0
local AAreaSA1:=SA1->(GetArea())
local AAreaSF2:=SF2->(GetArea())
local AAreaSD2:=SD2->(GetArea())

dbselectarea("SA1")
dbselectarea("SF2")
dbselectarea("SD2")

SA1->(dbsetorder(1))
if SA1->(dbseek(xFilial('SA1')+SE1->E1_CLIENTE + SE1->E1_LOJA )) 

	if SA1->A1_GRPTRIB=='001' .OR. SA1->A1_GRPTRIB=='003'
		
		SF2->(dbsetorder(1))

		if SF2->(dbseek(xFilial('SF2')+SE1->E1_NUM + SE1->E1_PREFIXO + SE1->E1_CLIENTE + SE1->E1_LOJA ))
			
			dbsetorder(3)
			SD2->(dbseek(xFilial('SD2')+SE1->E1_NUM + SE1->E1_PREFIXO + SE1->E1_CLIENTE + SE1->E1_LOJA ))

   		while SD2->(! eof() ) .and. SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE +SD2->D2_LOJA ==SE1->E1_NUM + SE1->E1_PREFIXO + SE1->E1_CLIENTE + SE1->E1_LOJA 
            SB1->( DbSeek( xFilial('SB1') + SD2->D2_COD  ))
            if AllTrim(SB1->B1_CLASFIS) =='A' .or. AllTrim(Sb1->B1_CLASFIS) =='P'
               nTotalRet:= nTotalRet + SD2->D2_TOTAL                
            endif
            SD2->(DbSkip() ) 
         end    

         if nTotalRet>0
            aCondicao := condicao(nTotalRet , SF2->F2_COND , , SF2->F2_EMISSAO )       
         endif

         if len(aCondicao)>0
            if (nInd:=ascan(aCondicao, {|x| x[1]==SE1->E1_VENCTO } ) ) > 0   
         	   nValRet:= (aCondicao[nInd][2] * 0.60)  /  100 
            else
               aInd:={'A  ','B  ','C  ','D  ','E  ','F  ','G  ','H  ','I  '} 
               if (nInd:=ascan(aInd, {|x| x==AllTrim(Upper(SE1->E1_PARCELA)) } ) ) > 0
                   nValRet:= (aCondicao[nInd][2] * 0.60)  /  100
               else
                   if val(SE1->E1_PARCELA)>0 
                      nValRet:= (aCondicao[val(SE1->E1_PARCELA)][2] * 0.60)  /  100
                   else
                      nValRet:= (aCondicao[1][2] * 0.60)  /  100
                   endif   
               endif     
            endif
         endif
      endif
   endif
endif          

SA1->(RestArea(AAreaSA1))
SF2->(RestArea(AAreaSF2))
SD2->(RestArea(AAreaSD2))
          
return(nValRet)          
          
////////////////////////////////////////////////////////////////
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CallTela  ºAutor  ³Caio Costa          º Data ³  12/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os titulo no objeto para o usuario selecionar os   º±±
±±º          ³ que serão impressos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CallTela(aTitulos)

Local oDlg
Local oList1
Local oMark
Local bCancel   := {|| RFINR01A(oDlg,@lRetorno,aTitulos) }
Local bOk       := {|| RFINR01B(oDlg,@lRetorno,aTitulos) }
Local aAreaAtu	:= GetArea()
Local aLabel	:= {" ","Prefixo","Número","Parcela","Tipo","Natureza","Cliente","Loja","Nome Cliente","Emissão","Vencimento","Venc.Real","Valor","Histórico","Nosso Número"}
Local aBotao    := {}
Local lRetorno	:= .T.
Local lMark		:= .F.
Local cList1

Private oOk			:= LoadBitMap(GetResources(),"LBOK")
Private oNo			:= LoadBitMap(GetResources(),"NADA")
Private cTitulo	:= "Boleto de Cobrança com Código de Barras"

AADD(aBotao, {"S4WB011N" 	, { || U__RFINR01C("SE1",SE1->(aTitulos[oList1:nAt,15]),2)}, "[F12] - Visualiza Título", "Título" })
SetKey(VK_F10,	{|| U__RFINR01C("SE1",SE1->(aTitulos[oLis1:nAt,15]),2)})


Aviso(	"Numeração Bancária",;
		"Não esquecer de verificar o número bancário antes de gerar os boletos.",;
		{"&Ok"},,;
		"A T E N Ç Ã O" )

DEFINE MSDIALOG oDlg TITLE cTitulo From 000,000 To 420,940 OF oMainWnd PIXEL
@ 015,005 CHECKBOX oMark VAR lMark PROMPT "Marca Todos" FONT oDlg:oFont PIXEL SIZE 80,09 OF oDlg;
			ON CLICK (aEval(aTitulos, {|x,y| aTitulos[y,1] := lMark}), oList1:Refresh() )
@ 030,003 LISTBOX oList1 VAR cList1 Fields HEADER ;
							aLabel[1],;
							aLabel[2],;
							aLabel[3],;
							aLabel[4],;
							aLabel[5],;
							aLabel[6],;
							aLabel[7],;
							aLabel[8],;
							aLabel[9],;
							aLabel[10],;
							aLabel[11],;
							aLabel[12],;
							aLabel[13],;
							aLabel[14],;
							aLabel[15] ;
							SIZE 463,175  NOSCROLL PIXEL
oList1:SetArray(aTitulos)
oList1:bLine	:= {|| {	If(aTitulos[oList1:nAt,1], oOk, oNo),;
							aTitulos[oList1:nAt,2],;
							aTitulos[oList1:nAt,3],;
							aTitulos[oList1:nAt,4],;
							aTitulos[oList1:nAt,5],;
							aTitulos[oList1:nAt,6],;
							aTitulos[oList1:nAt,7],;
							aTitulos[oList1:nAt,8],;
							aTitulos[oList1:nAt,9],;
							aTitulos[oList1:nAt,10],;
							aTitulos[oList1:nAt,11],;
							aTitulos[oList1:nAt,12],;
							Transform(aTitulos[oList1:nAt,13], "@E 999,999,999.99"),;
							aTitulos[oList1:nAt,14],;
							aTitulos[oList1:nAt,16] ;
							}}

oList1:blDblClick 	:= {|| aTitulos[oList1:nAt,1] := !aTitulos[oList1:nAt,1], oList1:Refresh() }
oList1:cToolTip		:= "Duplo click para marcar/desmarcar o título"
oList1:Refresh()

@ 15,81 BMPBUTTON TYPE 01 ACTION (lRetorno:=.T.,oDlg:End())
@ 15,110 BMPBUTTON TYPE 2 ACTION (lRetorno:=.F.,oDlg:End())
ACTIVATE MSDIALOG oDlg CENTERED //ON INIT EnchoiceBar(oDlg,bOk,bcancel,,aBotao)


SetKey(VK_F12,	Nil)

Return(lRetorno)

          