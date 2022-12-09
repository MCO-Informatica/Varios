#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFMAILVEND บ Autor ณ Bruno Parreira     บ Data ณ  26/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Vendas eviado por email                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Lisonda - Actual Trend                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FMAILVEND()
Private cArqTrab                                          	
Private cString     := "AF8"	 
Private aFiliais := {"Lisonda-Taboao","Playpiso","Lisonda-Rio","Lisonda-Alpha"}    
Private cHtmTxt 	:= '' 
//Private cEmailVen := GetMV("MV_")
//Private aEmail := {cEmailDir,cEmailVen}

lEnv := .F.

nDia := Day(dDataBase)
nMes := Month(dDataBase)
nAno := Year(dDataBase)  
nUltimo := Last_day(dDataBase)    // adicionado para trazer o ultimo dia do m๊s atual LH - 15/06/2015
   
cDataIni := ""
cDataFim := ""
               
nDiaSem := Dow(dDataBase)                
If  nDiaSem == 7 .And. nDia <> 1 
	//If nDia <= 7
		cDataIni := StrZero(nAno,4) + StrZero(nMes,2) + "01"
	//else                                
	//	cDataIni := StrZero(nAno,4) + StrZero(nMes,2) + StrZero((nDia-6),2)	     
	//EndIf
	                        
	/*
    //comentado bloco abaixo para tratar a rela็ใo de venda at้ o final de cada m๊s - luiz henrique 15/06/2015     
    //cDataFim := StrZero(nAno,4) + StrZero(nMes,2) + StrZero(nDia,2)
        cDataFim := StrZero(nAno,4) + StrZero(nMes,2) + StrZero(nUltimo,2)
	//fim da altera็ใo  - luiz henrique 15/06/2015	
	*/
	//substituido bloco acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 20180906]
	cDataIni := StrZero(nAno,4) + StrZero(nMes,2) + "01" 
	If nDia <= 7
		cDataFim := StrZero(nAno,4) + StrZero(nMes,2) + StrZero(nDia,2)	     
	Else
		cDataFim := StrZero(nAno,4) + StrZero(nMes,2) + StrZero(nDia-1,2)	     
	EndIf
	
	lEnv := .T.
elseIf nDia == 1
	if nMes := 1	
		cDataIni := StrZero(nAno-1,4) + "12" + "01"	
		cDataFim := StrZero(nAno-1,4) + "12" + "31"
	else		              
		cDataIni := StrZero(nAno,4) + StrZero(nMes-1,2) + "01"	
		//cDataFim := StrZero(nAno,4) + StrZero(nMes-1,2) + "31"        
		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20180906]
		cDataFim := DtoS(dDatabase-1)
	EndIf	
	lEnv := .T.                                                                         
EndIf	 

If lEnv
	If cFilAnt == "02"     // Inserido if para mandar somente uma vez o email. Pois o Job estแ configurado para executar a rotina em todas as filiais.
	 //	MontaHtml("02","04",cDataIni,cDataFim)
			MontaHtml("01","03",cDataIni,cDataFim)
		EnviaEmail()
	EndIf
 //	MontaHtml(cFilAnt,cFilAnt,cDataIni,cDataFim)		 
 //	EnviaEmail(cEmailVen)
EndIf	   

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ Mauro Nagata       บ Data ณ  24/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 	
/*/

Static Function MontaHtml(cFIni,cFFim,cDtIni,cDtFim)
Local cObra := ""
Local cDesc := ""
Local nCust := 0
Local nMark := 0	
Local nVend := 0  
Local nPorc := 0   
Private aMeses:= {"Janeiro","Fevereiro","Mar็o","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}   
Private lTotF := .F.                                                                                                                    	


    
cHtmTxt:='<HTML><HEAD><TITLE></TITLE>'
cHtmTxt+= CRLF + '<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
cHtmTxt+= CRLF + '<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
cHtmTxt+= CRLF + '<style type="text/css">'
cHtmTxt+= CRLF + 'table.cont {'
cHtmTxt+= CRLF + 'font-size:10}'
cHtmTxt+= CRLF + '</style>' 
cHtmTxt+= CRLF + '<BODY>'
cHtmTxt+= CRLF + '<Table border=0 width=800>'             
cHtmTxt+= CRLF + '	<TR align="center">'
cHtmTxt+= CRLF + '		<TD><H1>Relacao de vendas</H1></TD>'
cHtmTxt+= CRLF + '	</TR>' 
cHtmTxt+= CRLF + '	<TR align="center">'
cHtmTxt+= CRLF + '		<TD>Relacao das vendas realizadas no perํodo de '+DtoC(StoD(cDtIni))+' at้ '+DtoC(StoD(cDtFim))+': </TD>'  
cHtmTxt+= CRLF + '	</TR>'  
cHtmTxt+= CRLF + '	<TR align="center">'         
cHtmTxt+= CRLF + '		<TD>'
cHtmTxt+= CRLF + '			<Table border=1 width=800>'   
cHtmTxt+= CRLF + '				<TR bgcolor="#CCCCCC" align="center">'
cHtmTxt+= CRLF + '					<TD>Obra</TD>'  
cHtmTxt+= CRLF + '					<TD>Descri็ใo</TD>' 
cHtmTxt+= CRLF + '					<TD>Venda</TD>' 
cHtmTxt+= CRLF + '					<TD>Custo</TD>'  
cHtmTxt+= CRLF + '					<TD>Markup</TD>'
cHtmTxt+= CRLF + '					<TD>Porc.</TD>'
cHtmTxt+= CRLF + '				</TR>'
	
ArqTrb(cFIni,cFFim,cDtIni,cDtFim)  
            
DbSelectArea("TRB") 

DbGoTop()     

nTotCFil := 0
nTotMFil := 0
nTotVFil := 0
nTotCMes := 0
nTotMMes := 0
nTotVMes := 0
nTotCGer := 0
nTotMGer := 0
nTotVGer := 0  
nTotFilPorc := 0
nTotMesPorc := 0
nTotGerPorc := 0

if TRB->(!Eof())      
                                                                            
	lIp := .T.   
	cFilV := TRB->FILIAL  
	Do While TRB->(!EOF()) 
		
		cObra := TRB->OBRA    // Codigo da Obra
		cDesc := TRB->DESCRI  // Descricao
		nVend := TRB->TOTAL  // Valor do Total   alterado p/WILLIAN 30/08/11
		nCust := TRB->CUSTO  // Valor do Custo   alterado p/WILLIAN 30/08/11
		nMark := TRB->MARKUP  // Valor do markup alterado p/WILLIAN 30/08/11      
		
		If cFilV == TRB->FILIAL 
			lTotF := .F.
		else
		    lTotF := .T.   	
		EndIf 
	
	 	If lTotF
	 		nTotFilPorc := (nTotVFil/nTotCFil-1)*100
	 		                                  
	 		cHtmTxt+= CRLF + '				<TR bgcolor="#DDDDDD" align="center">' 
			cHtmTxt+= CRLF + '					<TD colspan="2">Total da filial '+cFilV+':</TD>'//('+aFiliais[Val(cFilV)]+'):</TD>'		
			cHtmTxt+= CRLF + '					<TD>'+Transform(nTotVFil, "@E 99,999,999.99")+'</TD>'
			cHtmTxt+= CRLF + '					<TD>'+Transform(nTotCFil, "@E 99,999,999.99")+'</TD>'
			cHtmTxt+= CRLF + '					<TD>'+Transform(nTotMFil, "@E 99,999,999.99")+'</TD>'
			cHtmTxt+= CRLF + '					<TD>'+Transform(nTotFilPorc, "@E 99,999,999.99")+'%</TD>'
			cHtmTxt+= CRLF + '				</TR>'  
			
			cHtmTxt+= CRLF + '				<TR align="center">' 
			cHtmTxt+= CRLF + '					<TD colspan="6">&nbsp</TD>'		
	 		cHtmTxt+= CRLF + '				</TR>'  
	 			  	
			nTotCFil := 0
			nTotMFil := 0
			nTotVFil := 0
		EndIf
		
		nTotMesPorc := (nTotVMes/nTotCMes-1)*100
		
		if nCust == 0
			nPorc := 0
		else
			nPorc := ((nVend/nCust)-1)*100  	
		Endif

		cHtmTxt += CRLF + '				<TR align="center">' 
		cHtmTxt += CRLF + '					<TD>'+cObra+'</TD>'
		cHtmTxt += CRLF + '					<TD>'+Left(cDesc,60)+'</TD>'		
		cHtmTxt += CRLF + '					<TD>'+Transform(nVend, "@E 99,999,999.99")+'</TD>'
		cHtmTxt += CRLF + '					<TD>'+Transform(nCust, "@E 99,999,999.99")+'</TD>'
		cHtmTxt += CRLF + '					<TD>'+Transform(nMark, "@E 99,999,999.99")+'</TD>'
		cHtmTxt += CRLF + '					<TD>'+Transform(nPorc, "@E 99,999,999.99")+'%</TD>'
		cHtmTxt += CRLF + '				</TR>'

		nTotCFil += nCust
		nTotMFil += nMark
		nTotVFil += nVend 

		nTotCMes += nCust
		nTotMMes += nMark
		nTotVMes += nVend 

		nTotCGer += nCust
		nTotMGer += nMark
		nTotVGer += nVend

		cFilV := TRB->FILIAL  
		cMesD := SubStr(DtoC(TRB->DTINI),4,2)  

		TRB->(DbSkip()) 

        //o bloco abaixo orienta os totais com os usuarios comuns e os usuarios masters wcosta 18/10/11
       	//if mv_par01 <> mv_par02 .and. AllTrim(cFilAnt) $ Alltrim(cUsuMast)
        //	Totais2()     	
	  	//Elseif mv_par01 = mv_par02 .and. AllTrim(cFilAnt) # Alltrim(cUsuMast) 
		// 	Totais1()
	   	//Elseif mv_par01 <> mv_par02 .and. AllTrim(cFilAnt) # Alltrim(cUsuMast) 
	    	Totais1()
	  	//EndIf 
	  	  

	EndDo

    nTotGerPorc=(nTotVGer/nTotCGer-1)*100 

    cHtmTxt+= CRLF + '				<TR bgcolor="#CCCCCC" align="center">' 
	cHtmTxt+= CRLF + '					<TD colspan="2">Total geral do perํodo:</TD>'		
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotVGer, "@E 99,999,999.99")+'</TD>'
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotCGer, "@E 99,999,999.99")+'</TD>'
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotMGer, "@E 99,999,999.99")+'</TD>'
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotGerPorc, "@E 99,999,999.99")+'%</TD>'
	cHtmTxt+= CRLF + '				</TR>'   
	cHtmTxt+= CRLF + '			</Table>' 
	cHtmTxt+= CRLF + '		</TD>'
	cHtmTxt+= CRLF + '	</TR>'  
	cHtmTxt+= CRLF + '</Table>'

	MemoWrite("FMAILVEND.HTML",cHtmTxt)

EndIf   

TRB->(DbCloseArea())

Return   

//Funcao Totais1

Static Function Totais1()

If TRB->(Eof()) 
	nTotFilPorc= (nTotVFil/nTotCFil-1)*100 
	
	cHtmTxt+= CRLF + '				<TR bgcolor="#DDDDDD" align="center">' 
	cHtmTxt+= CRLF + '					<TD colspan="2">Total da filial '+cFilV+':</TD>'// ('+aFiliais[Val(cFilV)]+'):</TD>'		
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotVFil, "@E 99,999,999.99")+'</TD>'
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotCFil, "@E 99,999,999.99")+'</TD>'
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotMFil, "@E 99,999,999.99")+'</TD>'
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotFilPorc, "@E 99,999,999.99")+'%</TD>'
	cHtmTxt+= CRLF + '				</TR>'  
EndIf         

Return

//Funcao Totais2

Static Function Totais2()
If TRB->(Eof()) 
	nTotFilPorc= (nTotVFil/nTotCFil-1)*100 

	cHtmTxt+= CRLF + '				<TR bgcolor="#EEEEEE" align="center">' 
	cHtmTxt+= CRLF + '					<TD colspan="2">Total da filial '+cFilV+':</TD>'		
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotVFil, "@E 99,999,999.99")+'</TD>'
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotCFil, "@E 99,999,999.99")+'</TD>'
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotMFil, "@E 99,999,999.99")+'</TD>'
	cHtmTxt+= CRLF + '					<TD>'+Transform(nTotFilPorc, "@E 99,999,999.99")+'%</TD>'
	cHtmTxt+= CRLF + '				</TR>'  
EndIf         

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณARQTRB    บ Autor ณ Bruno Parreira     บ Data ณ  23/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao para montar a tabela temporaria para uso no         บฑฑ
ฑฑบ          ณ relatorio.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
           
Static Function ARQTRB(	cFilIni, cFilFim, cDtIni, cDtFim)
Local aCampos    := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define array para arquivo de trabalho                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
                               
aTam:=TamSX3("AF8_MSFIL")
aAdd(aCampos,{ "FILIAL"  ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("AF8_CODOBR")
aAdd(aCampos,{ "OBRA"    ,"C",aTam[1],aTam[2] } )

aTam:=TamSX3("AF8_DESCRI")
aAdd(aCampos,{ "DESCRI"  ,"C",aTam[1],aTam[2] } ) 

aTam:=TamSX3("AF8_START")
aAdd(aCampos,{ "DTINI"   ,"D",aTam[1],aTam[2] } )

aTam:=TamSX3("AFC_CUSTO")
aAdd(aCampos,{ "CUSTO"   ,"N",aTam[1],aTam[2] } ) 
                                                                                                                         		
aTam:=TamSX3("AFC_VALBDI")
aAdd(aCampos,{ "MARKUP"  ,"N",aTam[1],aTam[2] } )

aTam:=TamSX3("AFC_TOTAL")
aAdd(aCampos,{ "TOTAL"   ,"N",aTam[1],aTam[2] } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria arquivo de Trabalho                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

DbSelectArea("TRB")
DbGoTop()

cAliasAF8 := "RFMAILTRB"
aStruAF8  := AF8->(dbStruct())   

cQuery :=        "  SELECT AF8_MSFIL, AF8_CODOBR, AF8_DESCRI, AF8_START, AFC_CUSTO, AFC_VALBDI, AFC_TOTAL "
cQuery += CRLF + "  FROM "+ RetSQLName( "AF8" ) +" AF8 "
cQuery += CRLF + "  INNER JOIN "+ RetSQLName( "AFC" ) +" AFC "
cQuery += CRLF + "  ON AFC.D_E_L_E_T_ = ' ' "
cQuery += CRLF + "  AND AFC_PROJET = AF8_PROJET "                              
cQuery += CRLF + "  AND AFC_REVISA = '0001' "
cQuery += CRLF + "  AND AFC_NIVEL = '001' "
cQuery += CRLF + "  WHERE AF8.D_E_L_E_T_ = ' ' "                        
cQuery += CRLF + "  AND AF8_CODOBR <> ' ' "    
cQuery += CRLF + "  AND AF8_FASE <> '08' "
cQuery += CRLF + "  AND AF8_MSFIL BETWEEN '"+cFilIni+"' AND '"+cFilFim+"' "  
//cQuery += CRLF + "  AND AF8_MSFIL BETWEEN '02' AND '04' "  
cQuery += CRLF + "  AND AF8_START BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "//DtoS(cDtIni)+"' AND '"+DtoS(cDtFim)+"' "  
//cQuery += CRLF + "  AND AF8_START BETWEEN '20160401' AND '20160430' "//DtoS(cDtIni)+"' AND '"+DtoS(cDtFim)+"' "
cQuery += CRLF + "  ORDER BY SUBSTRING(AF8_START,5,2),AF8_MSFIL, AF8_CODOBR  "        
    
Memowrite("RMAIL010.SQL",cQuery)    

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasAF8,.T.,.T.)

For nX := 1 To Len(aStruAF8)
	If ( aStruAF8[nX][2] <> "C" )
		TcSetField(cAliasAF8,aStruAF8[nX][1],aStruAF8[nX][2],aStruAF8[nX][3],aStruAF8[nX][4])
	EndIf
Next nX

TcSetField(cAliasAF8,"AFC_CUSTO","N",14,2)
TcSetField(cAliasAF8,"AFC_VALBDI","N",14,2)    
TcSetField(cAliasAF8,"AFC_TOTAL","N",14,2) 
TcSetField(cAliasAF8,"AF8_START","D",08,0)

DbSelectArea(cAliasAF8)
DbGoTop()
Do While !Eof()
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)

	TRB->FILIAL := (cAliasAF8)->AF8_MSFIL
	TRB->OBRA   := (cAliasAF8)->AF8_CODOBR
	TRB->DESCRI := (cAliasAF8)->AF8_DESCRI
	TRB->DTINI  := (cAliasAF8)->AF8_START
	TRB->CUSTO  := (cAliasAF8)->AFC_CUSTO
	TRB->MARKUP := (cAliasAF8)->AFC_VALBDI
	TRB->TOTAL  := (cAliasAF8)->AFC_TOTAL
	
	DbSelectArea(cAliasAF8)
	DbSkip()
EndDo                                                                                          	

(cAliasAF8)->(DbCloseArea())

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaEmailบAutor  ณBruno Parreira      บ Data ณ  24/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia o email para os responsaveis.                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaEmail()

Local l_Continua	:= .T.
Private c_msgerro	:= ''
//Private c_para		:= "bruno.parreira@actualtrend.com.br"//GetMV("MV_XMAILGT")  
//Private c_paradir   := GetMV("MV_XMAILDI")+";bruno.parreira@actualtrend.com.br"   
//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 07/05/2012] conforme solicitacao do Fabio
Private c_paradir   := GetMV("MV_XMAILDI") 
Private c_assunto   := "Relacao de vendas da semana."
                                                                                                       
//incluida linha abaixo, solicitado pelo Artur que o George receba o e-mail [Mauro Nagata, Actual Trend, 20180516]           
cMailGeorge := "george@playpiso.com.br"                                                                                            

//c_paradir += ";mauro.nagata@actualtrend.com.br"
If !U_FGEN010(c_paradir+";"+cMailGeorge,c_assunto,cHtmTxt,,.t.)	
	Return c_msgerro
EndIf	

cHtmTxt := ""

Return
