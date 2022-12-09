#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH" 
#INCLUDE "AP5MAIL.CH"   
                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MAILDXC  บAutor  ณMauro Nagata        บ Data ณ  13/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ envio de e-mail quando as despesas da obra versus caixa    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Lisonda / PlayPiso www.actualtrend.com.br                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
User Function MAILDXC(pFilial)
Local   cObrRestr  := GetMV('MV_XOBRRES')  //OBRas administrativas REStritas
Local   nLPRec     := SuperGetMV('LP_PLGXC',.F.,75) //LIMite Percentual da Receita
Private cEmailLPCx := SuperGetMV('LP_EMLGXC',.F.,,"mauro.nagata@actualtrend.com.br") //E-MAIL referente ao Limite Percentual do Caixa
Private cEmailOrc  := SuperGetMV('LP_EMLCUS',.F.,,"mauro.nagata@actualtrend.com.br") //E-MAIL referente ao Limite Percentual do Caixa
Private cObra      := '' 
Private cNomeObra  := ''
Private cRecebidos  := ''
Private cGastosAcm  := '' 
Private cDiferenca := ''
//Private c_texto  := '' 
Private c_assunto  := ''  
Private _cHTML 	   := '' 
Private cHTML_Orc  := ''
Private lIPHTML    := .T.    
Private lIpOrc     := .T.
Private cTimeIni   := Time()                        
Private aEmailFisc := {}  //incluida linha [Mauro Nagata, Actual Trend, 12/09/2013] conforme solicitacao do Fabio     
Private aHtmlFisc  := {}  //incluida linha [Mauro Nagata, Actual Trend, 15/10/2013] conforme solicitacao do Fabio     
Private aEF_Orc    := {}
Private aHF_Orc    := {}  //incluida linha [Mauro Nagata, Actual Trend, 20140918] conforme solicitacao do Artur    
Private cFil       := pFilial                 

DbSelectArea("CTT")
DbSetOrder(1) //CTT_FILIAL, CTT_CUSTO, R_E_C_N_O_, D_E_L_E_T_
DbGotop()

Do While CTT->(!EOF()) 
    cObra      := CTT->CTT_CUSTO
	cNomeObra  := CTT->CTT_DESC01    

	nVlrVnd    := CTT->CTT_XVLR
	                       
	Conout('Job LJOB002 processando obra '+cObra+ " filial " + aEmpres[nCount,2]) 
	//Conout('Job LJOB002 processando obra '+cObra+ " filial " + cFilAnt)
	If AllTrim(CTT->CTT_CUSTO) $ cObrRestr
		CTT->(DbSkip())                                                            
		Loop
	EndIf
	If CTT->CTT_MSBLQL <> '2'  .Or. ((aEmpres[nCount,2]="02".And.("R"$CTT->CTT_CUSTO.Or."L"$CTT->CTT_CUSTO)).Or.(aEmpres[nCount,2]="03".And.("L"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)).Or.(aEmpres[nCount,2]="01".And.("R"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)))
 //	If CTT->CTT_MSBLQL <> '2'  .Or. ((aEmpres[nCount,2]="02".And.("R"$CTT->CTT_CUSTO.Or."L"$CTT->CTT_CUSTO)).Or.(aEmpres[nCount,2]="03".And.("L"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)).Or.(aEmpres[nCount,2]="04".And.("R"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)))   ACTUAL 26/09/2016
		//If CTT->CTT_MSBLQL <> '2'  .Or. ((cFilAnt="02".And.("R"$CTT->CTT_CUSTO.Or."L"$CTT->CTT_CUSTO)).Or.(cFilAnt="03".And.("L"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)).Or.(cFilAnt="04".And.("R"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)))
		CTT->(DbSkip())
		Loop
	EndIf
	
	DbSelectArea('AF8')
	DbSetOrder(8) //AF8_FILIAL, AF8_CODOBR, R_E_C_N_O_, D_E_L_E_T_
	nCustEstim :=  0   //valor do custo do material
	
	If DbSeek(xFilial('AF8')+cObra)
		
		lIpAF8 := .T.     
		cCodF1 := AF8->AF8_CODF1                        
		cDtPrj := Ctod("")
		Do While AF8->AF8_CODOBR = cObra
			nCustEstim += fRetCusto(AF8->AF8_PROJET, AF8->AF8_REVISA)
			If lIpAF8 
			   lIpAF8 := .F.
			   cDtPrj := Dtoc(AF8->AF8_DATA)
			EndIf
			AF8->(DbSkip())
		EndDo
	EndIf     
	      
	DbSelectArea("SX5")
	If DbSeek(xFilial("SX5")+"ZZ"+cCodF1)
		cNomeFisc  := SX5->X5_DESCRI   //nome do fiscal responsavel pela obra           
		cEmailFisc := SX5->X5_DESCENG  //email do fiscal  
	Else
	    cNomeFisc  := "SEM FISCAL"
	    cEmailFisc := If(cFil = "02","lima@playpiso.com.br","artur@lisonda.com.br") //291014	
	EndIf	
   // criado a expressao para tratar o ano atual na fun็ใo RFIN011a parametro MV_PAR03 - luiz henrique 16/01/2015
   MV_PAR03 :=Substr(Dtos(ddatabase),1,4) 	 
   //fim do bloco   16/01/2015	    
   U_RFIN011a("",cObra, Str(Year(dDataBase),4),,"A")                  
        
   nRecebidos := 0     
   nGastosAcm := 0
   DbSelectArea("TRAB")
   DbGotop()
   Do While !Eof()
      If TRAB->TRB_GRPO = "018"
         nRecebidos := TRAB->TRB_REAL
      EndIf    
      If TRAB->TRB_GRPO = "028"
         nGastosAcm := TRAB->TRB_REAL
      EndIf
      DbSkip()
   EndDo
            
   cRecebidos  := Transform(nRecebidos,"@RE 999,999,999")
   cGastosAcm  := Transform(nGastosAcm,"@RE 999,999,999")                         
   cCustEstim := Transform(nCustEstim,"@RE 999,999,999")                         
   cVlrVnd    := Transform(nVlrVnd,"@RE 999,999,999")                         
   
   nSldReais  := nCustEstim-nGastosAcm
   cSldReais  := Transform(nSldReais,"@RE 99,999,999")

   nSldCxG := nRecebidos - nGastosAcm
   cSldCxG := Transform(nSldCxG,"@RE 99,999,999")

  nPosFisc := aScan(aEmailFisc,cEmailFisc) 
  If nPosFisc = 0
     aAdd(aEmailFisc,cEmailFisc)   
     /*
     cHTML 	  := '<html>'
	 cHTML 	  += '<head>'
	 cHTML 	  += '  <meta'
	 cHTML 	  += ' content="text/html; charset=ISO-8859-1"'
	 cHTML 	  += ' http-equiv="content-type">'
	 cHTML 	  += '  <title>resobracaixa</title>'
	 cHTML 	  += '</head>'
	 cHTML 	  += '<body>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '<div'
	 cHTML 	  += ' style="text-align: center; font-family: Broadway; direction: ltr;"><big><big><big><big>Alerta'
	 cHTML 	  += '<br>'       
	 cHTML 	  += '<small><small>Gastos vs Recebimento'
	 cHTML 	  += '</small></small><br>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '</big></big></big></big></div>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '<table style="text-align: left; width: 100%;"'
	 cHTML 	  += ' border="1" cellpadding="2" cellspacing="2">'
	 cHTML 	  += '  <tbody>'
	 cHTML 	  += '    <tr>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="width: 117px; background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center;">Obra</td>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 290px;">Nome</td>'
	 cHTML 	  += '      <td'		 
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">(1) Venda '
	 cHTML 	  += '(R$)</td>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">(2) Gasto '
	 cHTML 	  += 'Estimado (R$)</td>' 
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">(3) Rec. '
	 cHTML 	  += '</td>'		 	 
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">(4) Gasto '
	 cHTML 	  += 'Acumulado (R$)</td>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 100px;">(2-4) Saldo '
	 cHTML 	  += 'a Gastar (R$)</td>' 
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 100px;">(3-4) Saldo '
	 cHTML 	  += 'Rec vs Gastos (R$)</td>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">Fiscal'
	 cHTML 	  += '</td>'
	 cHTML 	  += '    </tr>'       
	 */
	 lIpHTML  := .F.
//	 aAdd(aHtmlFisc,cHTML)	
	 aAdd(aHtmlFisc,HCab())	
	 nPosFisc := Len(aHtmlFisc)	 	               
	  
  EndIf	                  
  If nSldReais < 0                 
     nPF_Orc := aScan(aEF_Orc,cEmailFisc) 
     If nPF_Orc = 0
        aAdd(aEF_Orc,cEmailFisc)   
        aAdd(aHF_Orc,HCab())        
        nPF_Orc := Len(aEF_Orc)
	    lIpOrc  := .F.         
	 EndIf   
  EndIf  

  cHTML 	  := '    <tr>'
  cHTML 	  += '      <td'
  cHTML 	  += ' style="width: 122px; text-align: center;">'+cObra+'</td>'
  cHTML 	  += '      <td'
  cHTML 	  += ' style="text-align: center; width: 290px;">'+cNomeObra+'</td>' 
  cHTML 	  += '      <td'
  cHTML 	  += ' style="text-align: center; width: 290px;">'+cVlrVnd+'</td>'	  
  cHTML 	  += '      <td'
  cHTML 	  += ' style="text-align: center; width: 290px;">'+cCustEstim+'</td>'
  cHTML 	  += '      <td'
  cHTML 	  += ' style="text-align: center; width: 180px;">'+cRecebidos+'</td>'	  
  cHTML 	  += '      <td'
  cHTML 	  += ' style="text-align: center; width: 180px;">'+cGastosAcm +'</td>'          
                    
  If nSldReais < 0
     cHTML 	  += '      <td'
     cHTML 	  += ' style="background-color: rgb(255, 102, 102); text-align: center; width: 290px;">'+cSldReais+'</td>'			
  Else
     cHTML 	  += '      <td'
     cHTML 	  += ' style="text-align: center; width: 290px;">'+cSldReais+'</td>'
  EndIf
  If nSldCxG >= 0 
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="text-align: center; width: 100px;">'+cSldCxG+'</td>'
  Else
  	 cHTML 	  += '      <td'
   	 cHTML 	  += ' style="background-color: rgb(255, 102, 102); text-align: center; width: 100px;">'+cSldCxG+'</td>'			
  EndIf     
  cHTML 	  += '      <td'
  cHTML 	  += ' style="text-align: center; width: 150px;">'+cNomeFisc+'</td>'                                             
  cHTML 	  += '    </tr>'                                                                                           
  aHtmlFisc[nPosFisc] += cHtml
      
      
  If nSldReais < 0 .And. !lIpOrc                              
     cHTML_Orc        := cHTML     
     aHF_Orc[nPF_Orc] += cHTML
  EndIf   

   CTT->(DBSkip())        
EndDo	


If !lIpHTML
   For nI := 1 To Len(aHtmlFisc) 
		cHTML     := ' <tr> ' 
		cHTML     += ' <td> ' +cTimeIni+'</td>'
		cHTML     += ' <td> ' +time()+'</td>'
		cHTML     += ' </tr> ' 
		cHTML 	  += '  </tbody>'
		cHTML 	  += '</table>'
		cHTML 	  += '<br>'
		cHTML 	  += '</body>'
		cHTML 	  += '</html>'        
		MemoWrite("MAILGXC.HTML",aHtmlFisc[nI]+cHTML)   		
    	
        Conout('Job LJOB003 enviando e-mail' + " filial " + aEmpres[nCount,2])                                                                                                      	
      //  EnviaEmail()   
	Next		                                        
	
	If Len(aHF_Orc) > 0
	   For nI := 1 To Len(aHF_Orc) 
			cHTML     := ' <tr> ' 
			cHTML     += ' <td> ' +cTimeIni+'</td>'
			cHTML     += ' <td> ' +time()+'</td>'
			cHTML     += ' </tr> ' 
			cHTML 	  += '  </tbody>'
			cHTML 	  += '</table>'
			cHTML 	  += '<br>'
			cHTML 	  += '</body>'
			cHTML 	  += '</html>'        
			MemoWrite("MAILGXC.HTML",aHF_Orc[nI]+cHTML)   		
	    	
	        Conout('Job LJOB003 enviando e-mail' + " filial " + aEmpres[nCount,2])                                                                                                      	
	        EEmail_Orc()   
       Next		                                        
   EndIf	   
EndIf


Static Function EnviaEmail()

Local l_Continua  := .T.
Private c_msgerro := ''
Private c_paradir := cEmailLPCx   //291014

c_Assunto := "WF - Alerta dos Recebidos vs Gastos por Obra"

For nI := 1 To Len(aEmailFisc)
    
    If !U_FGEN010(c_paradir,c_assunto,_cHTML,,.t.)	
	   Return c_msgerro
    EndIf	      
    
    /*
   	If !U_FGEN010(aEmailFisc[nI]+";ney@lisonda.com.br","WF - Alerta dos Recebidos vs Gastos por Obra",+_cHTML+" ",,.t.)
   	 	Return c_msgerro  
   	EndIf   	
   	*/
   	
   	/*If !U_FGEN010("mauro.nagata@actualtrend.com.br","WF - Alerta dos Recebidos vs Gastos por Obra",+_cHTML+" ",,.t.)
   	 	Return c_msgerro  
   	EndIf   	
   	*/
Next   	


Return


Static Function EEmail_orc()

Local l_Continua  := .T.
Private c_msgerro := ''
Private cPara_Orc := cEmailOrc    //291014

c_Assunto := "WF - Alerta dos Recebidos vs Gastos por Obra"

For nI := 1 To Len(aEF_Orc)
    _cHtml := aHF_Orc[nI]  
    If !U_FGEN010(cPara_Orc,c_assunto,_cHTML,,.t.)	
	   Return c_msgerro
    EndIf	      
Next   	
  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRetCusto บAutor  ณAlexandre Sousa     บ Data ณ  11/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o custo do orcamento.                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fRetCusto(c_prj, c_rev)

Local n_Ret := 0

c_query := " select * from "+RetSqlName('AFC')+" "
c_query += " where AFC_PROJET = '"+c_prj+"' "
c_query += " and   AFC_REVISA = '0001'"
c_query += " and   D_E_L_E_T_ <> '*' "
c_query += " and   AFC_NIVEL = '001' "
c_query += " and   AFC_FILIAL = '"+xFilial('AFC')+"' "

MemoWrite("RFIN011_CST",c_query)

If Select("TRP") > 0
	DbSelectArea("TRP")
	DbCloseArea()
EndIf

TcQuery c_Query New Alias "TRP"

If TRP->(!EOF())
	n_Ret := TRP->AFC_CUSTO
EndIf


Return n_Ret



Static Function HCab()

Local cHTML

cHTML 	  := '<html>'
	 cHTML 	  += '<head>'
	 cHTML 	  += '  <meta'
	 cHTML 	  += ' content="text/html; charset=ISO-8859-1"'
	 cHTML 	  += ' http-equiv="content-type">'
	 cHTML 	  += '  <title>resobracaixa</title>'
	 cHTML 	  += '</head>'
	 cHTML 	  += '<body>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '<div'
	 cHTML 	  += ' style="text-align: center; font-family: Broadway; direction: ltr;"><big><big><big><big>Alerta'
	 cHTML 	  += '<br>'       
	 cHTML 	  += '<small><small>Recebido vs Gastos '
	 cHTML 	  += '</small></small><br>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '</big></big></big></big></div>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '<br>'
	 cHTML 	  += '<table style="text-align: left; width: 100%;"'
	 cHTML 	  += ' border="1" cellpadding="2" cellspacing="2">'
	 cHTML 	  += '  <tbody>'
	 cHTML 	  += '    <tr>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="width: 117px; background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center;">Obra <p></p></td>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 290px;">Nome<p></p></td>'
	 cHTML 	  += '      <td'		 
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">Venda '
	 cHTML 	  += '(R$) <P text-align: center; width: 150px;><p><p><p>1</P></p></P></P> </td>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">Gasto '
	 cHTML 	  += 'Estimado (R$) <P text-align: center; width: 150px;><p><p>2</p></P></P> </td>' 
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">Recebido '
	 cHTML 	  += '(R$) <P text-align: center; width: 150px;><p><p><p>3</P></P></P></P> </td>'		 	 
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">Gasto '
	 cHTML 	  += 'Acumulado (R$) <P text-align: center; width: 150px;><p>4</p></p> </td>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 100px;">Saldo '
	 cHTML 	  += 'a Gastar (R$) <P text-align: center; width: 150px;><p><p>(2-4)</p></p></p> </td>' 
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 100px;">Saldo '
	 cHTML 	  += 'Receb vs Gastos Acum(R$) <P text-align: center; width: 150px;>(3-4)</p></td>'
	 cHTML 	  += '      <td'
	 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">Fiscal'
	 cHTML 	  += '<P> </P></td>'
	 cHTML 	  += '    </tr>'
	 
Return(cHTML)	 