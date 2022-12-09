#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH" 
#INCLUDE "AP5MAIL.CH"   
                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MAILROC  บAutor  ณMauro Nagata        บ Data ณ  21/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ envio de e-mail quando as despesas da obra atingirem um    บฑฑ
ฑฑบ          ณ percentual do custo estimado                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Lisonda / PlayPiso www.actualtrend.com.br                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
User Function MAILROC(pFilial)
Local   cObrRestr  := GetMV('MV_XOBRRES')  //OBRas administrativas REStritas
Local   nLPCusto   := SuperGetMV('LP_PLCUSTO',.F.,10) //LIMite Percentual do CUSTO
Private cEmailLPC  := SuperGetMV('LP_EMAILPL',.F.,"mauro.nagata@actualtrend.com.br") //E-MAIL referente ao Limite Percentual do Custo
Private cObra      := '' 
Private cNomeObra  := ''
Private cCustEstim := ''
Private cDespesas  := '' 
Private cDiferenca := ''
//Private c_texto  := '' 
Private c_assunto  := ''  
Private _cHTML 	   := '' 
Private lIPHTML    := .T.    
Private cTimeIni   := Time()
Private aEmailFisc := {}  //incluida linha [Mauro Nagata, Actual Trend, 12/09/2013] conforme solicitacao do Fabio     
Private aHtmlFisc  := {}  //incluida linha [Mauro Nagata, Actual Trend, 15/10/2013] conforme solicitacao do Fabio    
Private cFil       := pFilial      

            

DbSelectArea("CTT")
DbSetOrder(1) //CTT_FILIAL, CTT_CUSTO, R_E_C_N_O_, D_E_L_E_T_
DbGotop()

Do While CTT->(!EOF()) 
    cObra     := CTT->CTT_CUSTO
	cNomeObra := CTT->CTT_DESC01
	                       
	Conout('Job LJOB002 processando obra '+cObra+ " filial " + aEmpres[nCount,2]) 
	//Conout('Job LJOB002 processando obra '+cObra+ " filial " + cFilAnt)
	If AllTrim(CTT->CTT_CUSTO) $ cObrRestr
		CTT->(DbSkip())                                                            
		Loop
	EndIf
	If CTT->CTT_MSBLQL <> '2'  .Or. ((aEmpres[nCount,2]="02".And.("R"$CTT->CTT_CUSTO.Or."L"$CTT->CTT_CUSTO)).Or.(aEmpres[nCount,2]="03".And.("L"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)).Or.(aEmpres[nCount,2]="01".And.("R"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)))
 //  	If CTT->CTT_MSBLQL <> '2'  .Or. ((aEmpres[nCount,2]="02".And.("R"$CTT->CTT_CUSTO.Or."L"$CTT->CTT_CUSTO)).Or.(aEmpres[nCount,2]="03".And.("L"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)).Or.(aEmpres[nCount,2]="04".And.("R"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)))  ACTUAL 26/09/2016
		//If CTT->CTT_MSBLQL <> '2'  .Or. ((cFilAnt="02".And.("R"$CTT->CTT_CUSTO.Or."L"$CTT->CTT_CUSTO)).Or.(cFilAnt="03".And.("L"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)).Or.(cFilAnt="04".And.("R"$CTT->CTT_CUSTO.Or."P"$CTT->CTT_CUSTO)))
		CTT->(DbSkip())
		Loop
	EndIf
	
	DbSelectArea('AF8')
	DbSetOrder(8) //AF8_FILIAL, AF8_CODOBR, R_E_C_N_O_, D_E_L_E_T_
	n_valcust := 0   //valor do custo do material
	
	If DbSeek(xFilial('AF8')+CTT->CTT_CUSTO)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida o filtro de FISCAL de obra de ate                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//If MV_PAR08 > AF8->AF8_CODF1 .or. MV_PAR09 < AF8->AF8_CODF1
		//	CTT->(DbSkip())
		//	Loop
		//EndIf
		
		lIpAF8 := .T.     
		cCodF1 := AF8->AF8_CODF1                        
		cDtPrj := Ctod("")
		Do While AF8->AF8_CODOBR = CTT->CTT_CUSTO
			n_valcust += fRetCusto(AF8->AF8_PROJET, AF8->AF8_REVISA)
			If lIpAF8 
			   lIpAF8 := .F.
			   cDtPrj := Dtoc(AF8->AF8_DATA)
			EndIf
			AF8->(DbSkip())
		EndDo
	EndIf     
	
	//nVCusMO := 0     //valor do custo da mao-de-obra    
	      
	DbSelectArea("SX5")
	If DbSeek(xFilial("SX5")+"ZZ"+cCodF1)
		cNomeFisc  := SX5->X5_DESCRI   //nome do fiscal responsavel pela obra           
		cEmailFisc := SX5->X5_DESCENG  //email do fiscal  
	Else
	    cNomeFisc  := "SEM FISCAL"
	    cEmailFisc := If(cFil = "02","lima@playpiso.com.br","artur@lisonda.com.br")	
	EndIf	
	
	/*
    aAreaAF8 := AF8->(GetArea())
    aAreaAFA := AFA->(GetArea())
	DbSelectArea("AF8")
	DbSetOrder(8)
	If DbSeek(xFilial("AF8")+CTT->CTT_CUSTO)
	   DbSelectArea("AFA")
	   DbSetOrder(2)
	   If DbSeek(xFilial("AFA")+AF8->AF8_PROJET+'0001'+Space(15))
	      Do While !Eof().And.AFA->AFA_PROJET=AF8->AF8_PROJET.And.AFA->AFA_REVISA='0001'.And.AFA->AFA_PRODUT = Space(15).And.!Empty(AFA->AFA_RECURS)
	         nVCusMO += AFA->AFA_QUANT*AFA->AFA_CUSTD
	         DbSkip()
	      EndDo
	   EndIf      	   
	EndIf             
	RestArea(aAreaAF8)
	RestArea(aAreaAFA)
    */ 
    
//	oProcess := MsNewProcess():New({|lEnd| U_RFIN011a(oProcess,CTT->CTT_CUSTO, Str(Year(dDataBase),4),,"A")},"Processando informa็๕es da Obra","Preparando . . .",.F.)  
//	oProcess:Activate()                                  
   U_RFIN011a("",CTT->CTT_CUSTO, Str(Year(dDataBase),4),,"A")                  
      
   nDespesas := 0
   DbSelectArea("TRAB")
   DbGotop()
   Do While !Eof()
      /*If TRAB->TRB_GRPO = "023"
         nDespesas += TRAB->TRB_TOT
      EndIf*/
      //Substituido bloco acima pelo bloco abaixo 
      If TRAB->TRB_GRPO = "028"
         nDespesas := TRAB->TRB_REAL
      EndIf
      DbSkip()
   EndDo
   
   //cCustEstim := Transform(n_valcust+nVCusMO,"@RE 999,999,999.99")
   //Substituida linha acima pela linha abaixo [Bruno Parreira, Actual Trend, 17/07/2012] 
   cCustEstim := Transform(n_valcust,"@RE 999,999,999.99")
   cDespesas  := Transform(nDespesas,"@RE 999,999,999.99")                         
   //nDiferenca := (nDespesas/(n_valcust+nVCusMO))*100
   //Substituida linha acima pela linha abaixo [Mauro Nagata, Actual Trend, 07/11/2012] 
   nDiferenca := (nDespesas/n_valcust)*100
   cDiferenca := Transform(Abs(100-nDiferenca),"@RE 9,999.9")

   If nDiferenca > 100 - nLPCUSTO  //se as despesas for maior que o limite percentua estabelecido no MV_LPCUSTO
      nPosFisc   := aScan(aEmailFisc,cEmailFisc)
	  If nPosFisc = 0
	     aAdd(aEmailFisc,cEmailFisc)

	     cHTML 	  := '<html>'
		 cHTML 	  += '<head>'
		 cHTML 	  += '  <meta'
		 cHTML 	  += ' content="text/html; charset=ISO-8859-1"'
		 cHTML 	  += ' http-equiv="content-type">'
		 cHTML 	  += '  <title>resobracusto</title>'
		 cHTML 	  += '</head>'
		 cHTML 	  += '<body>'
		 cHTML 	  += '<br>'
		 cHTML 	  += '<br>'
		 cHTML 	  += '<div'
		 cHTML 	  += ' style="text-align: center; font-family: Broadway; direction: ltr;"><big><big><big><big>Alerta'
		 cHTML 	  += ' de Criticidade<br>'       
		 cHTML 	  += '<small><small>Custo '
		 cHTML 	  += 'por Obra</small></small><br>'
		 cHTML 	  += '<br>'
		 cHTML 	  += '</big></big></big></big></div>'
		 cHTML 	  += '<br>'
		 cHTML 	  += '<br>'
		 cHTML 	  += '<table style="text-align: left; width: 100%;"'
		 cHTML 	  += ' border="1" cellpadding="2" cellspacing="2">'
		 cHTML 	  += '  <tbody>'
		 cHTML 	  += '    <tr>'
		 cHTML 	  += '      <td'
		 cHTML 	  += ' style="width: 122px; background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center;">Obra</td>'
		 cHTML 	  += '      <td'
		 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 290px;">Nome</td>'
		 cHTML 	  += '      <td'
		 If cNomeFisc == "SEM FISCAL"
			 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 180px;">Custo '
			 cHTML 	  += 'Realizado (R$)</td>' 
         Else		 
			 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 180px;">Custo '
			 cHTML 	  += 'Realizado (R$)</td>'
		 EndIf
		 cHTML 	  += '      <td'
		 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 180px;">Custo '
		 cHTML 	  += 'Estimado (R$)</td>'
		 cHTML 	  += '      <td' 
		 If cNomeFisc == "SEM FISCAL"
			 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 100px;">Diferen&ccedil;a'
			 cHTML 	  += '(%)</td>'
		 Else  
			 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 100px;">Diferen&ccedil;a'
			 cHTML 	  += '(%)</td>'  
		 Endif
		 cHTML 	  += '      <td'
		 cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">Fiscal'
		 cHTML 	  += '</td>'
		 cHTML 	  += '    </tr>'
		 lIpHTML  := .F.
		 aAdd(aHtmlFisc,cHTML)	
		 nPosFisc := Len(aHtmlFisc)     
	  EndIf	                  

	  cHTML 	  := '    <tr>'
	  cHTML 	  += '      <td'
	  cHTML 	  += ' style="width: 122px; text-align: center;">'+cObra+'</td>'
	  cHTML 	  += '      <td'
	  cHTML 	  += ' style="text-align: center; width: 290px;">'+cNomeObra+'</td>'
	  cHTML 	  += '      <td'
	  cHTML 	  += ' style="text-align: center; width: 180px;">'+cDespesas+'</td>'
	  cHTML 	  += '      <td'
	  cHTML 	  += ' style="text-align: center; width: 180px;">'+cCustEstim+'</td>'
	  If nDiferenca > 100 - nLPCUSTO .And.nDiferenca < 100
		 cHTML 	  += '      <td'
		 cHTML 	  += ' style="text-align: center; width: 100px;">'+cDiferenca+'</td>'
	  ElseIf nDiferenca >= 100
		     cHTML 	  += '      <td'
			 cHTML 	  += ' style="background-color: rgb(255, 102, 102); text-align: center; width: 100px;">'+cDiferenca+'</td>'			
	  EndIf     
	  cHTML 	  += '      <td'
	  cHTML 	  += ' style="text-align: center; width: 150px;">'+cNomeFisc+'</td>'                                             
	  cHTML 	  += '    </tr>'                                                                                           
	  aHtmlFisc[nPosFisc] += cHtml
	  
	  /*
      If lIpHTML
         lIpHTML    := .F.
		    _cHTML 	  += '<html>'
			_cHTML 	  += '<head>'
			_cHTML 	  += '  <meta'
			_cHTML 	  += ' content="text/html; charset=ISO-8859-1"'
			_cHTML 	  += ' http-equiv="content-type">'
			_cHTML 	  += '  <title>resobracusto</title>'
			_cHTML 	  += '</head>'
			_cHTML 	  += '<body>'
			_cHTML 	  += '<br>'
			_cHTML 	  += '<br>'
			_cHTML 	  += '<div'
			_cHTML 	  += ' style="text-align: center; font-family: Broadway; direction: ltr;"><big><big><big><big>Alerta'
			_cHTML 	  += ' de Criticidade<br>'       
			_cHTML 	  += '<small><small>Custo '
			_cHTML 	  += 'por Obra</small></small><br>'
			_cHTML 	  += '<br>'
			_cHTML 	  += '</big></big></big></big></div>'
			_cHTML 	  += '<br>'
			_cHTML 	  += '<br>'
			_cHTML 	  += '<table style="text-align: left; width: 100%;"'
			_cHTML 	  += ' border="1" cellpadding="2" cellspacing="2">'
			_cHTML 	  += '  <tbody>'
			_cHTML 	  += '    <tr>'
			_cHTML 	  += '      <td'
			_cHTML 	  += ' style="width: 122px; background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center;">Obra</td>'
			_cHTML 	  += '      <td'
			_cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 290px;">Nome</td>'
			_cHTML 	  += '      <td'
			_cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 180px;">Custo '
			_cHTML 	  += 'Realizado (R$)</td>'
			_cHTML 	  += '      <td'
			_cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 180px;">Custo '
			_cHTML 	  += 'Estimado (R$)</td>'
			_cHTML 	  += '      <td'
			_cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 100px;">Diferen&ccedil;a'
			_cHTML 	  += '(%)</td>'
			_cHTML 	  += '      <td'
			_cHTML 	  += ' style="background-color: rgb(51, 102, 255); font-family: Arial; color: rgb(255, 255, 255); font-weight: bold; text-align: center; width: 150px;">Fiscal'
			_cHTML 	  += '</td>'
			_cHTML 	  += '    </tr>'
		EndIf	
		_cHTML 	  += '    <tr>'
		_cHTML 	  += '      <td'
		_cHTML 	  += ' style="width: 122px; text-align: center;">'+cObra+'</td>'
		_cHTML 	  += '      <td'
		_cHTML 	  += ' style="text-align: center; width: 290px;">'+cNomeObra+'</td>'
		_cHTML 	  += '      <td'
		_cHTML 	  += ' style="text-align: center; width: 180px;">'+cDespesas+'</td>'
		_cHTML 	  += '      <td'
		_cHTML 	  += ' style="text-align: center; width: 180px;">'+cCustEstim+'</td>'
		If nDiferenca > 100 - nLPCUSTO .And.nDiferenca < 100
			_cHTML 	  += '      <td'
			_cHTML 	  += ' style="text-align: center; width: 100px;">'+cDiferenca+'</td>'
			//_cHTML 	  += '    </tr>'
		ElseIf nDiferenca >= 100
			_cHTML 	  += '      <td'
			_cHTML 	  += ' style="background-color: rgb(255, 102, 102); text-align: center; width: 100px;">'+cDiferenca+'</td>'
			//_cHTML 	  += '    </tr>'                                                                                           
		EndIf     
		_cHTML 	  += '      <td'
		_cHTML 	  += ' style="text-align: center; width: 150px;">'+cNomeFisc+'</td>'                                             
		_cHTML 	  += '    </tr>'                                                                                           
	EndIf
	*/
   EndIf	     
   CTT->(DBSkip())        
EndDo	


/*   
If !lIpHTML
   _cHTML     += ' <tr> ' 
   _cHTML     += ' <td> ' +cTimeIni+'</td>'
   _cHTML     += ' <td> ' +time()+'</td>'
   _cHTML     += ' </tr> ' 
   _cHTML 	  += '  </tbody>'
   _cHTML 	  += '</table>'
   _cHTML 	  += '<br>'
   _cHTML 	  += '</body>'
   _cHTML 	  += '</html>'        
EndIf
MemoWrite("MAILROC.HTML",_cHTML)   
    	
Conout('Job LJOB002 enviando e-mail' + " filial " + aEmpres[nCount,2])                                                                                                      	
EnviaEmail()   
*/             

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
		MemoWrite("MAILROC.HTML",aHtmlFisc[nI]+cHTML)   
    	
        Conout('Job LJOB002 enviando e-mail' + " filial " + aEmpres[nCount,2])                                                                                                      	
        EnviaEmail()   
	Next		
EndIf


Static Function EnviaEmail()

Local l_Continua	:= .T.
Private c_msgerro	:= ''
Private c_paradir := cEmailLPC

c_Assunto := "WF - Alerta de Criticidade do Nํvel do Custo por Obra"

For nI := 1 To Len(aEmailFisc)
    _cHtml := aHtmlFisc[nI]  
    If !U_FGEN010(c_paradir,c_assunto,_cHTML,,.t.)	
	   Return c_msgerro
    EndIf	      
   
   	//If !U_FGEN010(aEmailFisc[nI]+","+If(cFil = "02","fabio@playpiso.com.br","fabio@lisonda.com.br")+",tobias.peniche@actualtrend.com.br" ,"WF - Alerta de Criticidade do Nivel do Custo por Obra",+_cHTML+" ",,.t.)
   	//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 20140522]
    //If !U_FGEN010(aEmailFisc[nI]+";ney@lisonda.com.br"+";ida@lisonda.com.br"+";orcamento@lisonda.com.br","WF - Alerta de Criticidade do Nivel do Custo por Obra",+_cHTML+" ",,.t.) 
    //substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170209]
	If !U_FGEN010(aEmailFisc[nI]+";ida@lisonda.com.br"+";orcamento@lisonda.com.br","WF - Alerta de Criticidade do Nivel do Custo por Obra",+_cHTML+" ",,.t.)   
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