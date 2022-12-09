#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH" 
#INCLUDE "AP5MAIL.CH"   

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥FMAILJOB  ∫Autor  ≥Bruno S. Parreira   ∫ Data ≥  20/09/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ FUNCAO PARA ENVIO DE EMAIL PARA GERENCIA EM CASO DE NAO    ∫±±
±±∫          ≥ CUMPRIMENTO DO PRAZO DE RETORNO AO CLIENTE.                ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
 
User Function FMAILJOB(c_fil)  
  
    Private clVend    := ''  
    Private clNmVend  := ''
    Private clNumOrc  := ''
    Private clDescOrc := '' 
    Private clProp  := ''       // numero da proposta WORD
    Private clDtOrca := ''     //data de inclusao do orÁamento
    Private clDtFollo := ''    //data de inclus„o de follow-up   
    Private clDtRet   := ''    //data de Retorno do Follow-up
    Private clNmEnt   := ''
    Private clVTotOrc := ''
    Private c_texto   := '' 
    Private c_assunto := ''
    //excluida linha abaixo [Mauro Nagata, Actual Trend, 20170110] definido pelo Artur
    //Private nMinimo :='150000.00'  // valor minimo para disparo dos orÁamentos para os diretores - solicitado pelo Sr.Edson LH - 09102015    
   // private nVTotVend :=0      //total da soma das vendas
   // private nTotVendas  :=0    //total de vendas
    Private cHistoric := ""
    Private _cHTML 	  := '' 

    _cHTML:='<HTML><HEAD><TITLE></TITLE>'
	_cHTML+= CRLF + '<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
	_cHTML+= CRLF + '<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
	_cHTML+= CRLF + '<style type="text/css">'
    _cHTML+= CRLF + 'table.cont {'
    _cHTML+= CRLF + 'font-size:10}'
    _cHTML+= CRLF + '</style>' 
	_cHTML+= CRLF + '<BODY>'
	_cHTML+= CRLF + '<Table border=0 width=1000>'             
	_cHTML+= CRLF + '<TR align="center">'
	_cHTML+= CRLF + '	<TD><H1>RelatÛrio de Followup</H1></TD>'
	_cHTML+= CRLF + '</TR>' 
	_cHTML+= CRLF + '<TR align="center">'
    _cHTML+= CRLF + '	<TD>Os seguintes vendedores n„o efetuaram retorno ao cliente nos seguintes orÁamentos:</TD>'  
    _cHTML+= CRLF + '</TR>'  
    _cHTML+= CRLF + '<TR align="center">'
    _cHTML+= CRLF + '	<TD>'
    
    c_assunto := "Retorno de Followup - " + c_fil
    
 	clAlias := LJOBSQL()  
    (clAlias)->(DbGoTop())
    if (clAlias)->(!EOF())  
    	While (clAlias)->(!EOF())
    		nValVend := 0 
    		nVendas  := 0 
     //		nVTotVend        //total da soma das vendas      - RETIRAR TOTAIS , solicitado pelo Sr.Edson Simoes  LH -09/10/2015
     //	    nTotVendas       //total das vendas realizadas - RETIRAR TOTAIS , solicitado pelo Sr.Edson Simoes LH - 09/10/2015
    	
    		clVend 	  := AllTrim((clAlias)->AF1_XVEND)
    		clNmVend  := Alltrim(Posicione('SA3',1,xFilial('SA3')+(clAlias)->AF1_XVEND,'A3_NOME'))  	
    			
    		_cHTML+= CRLF + '	<TABLE cellSpacing=0 width="1000" background="" border=1 class="cont">'
			_cHTML+= CRLF + '  	<TBODY>'
			_cHTML+= CRLF + '  	<TR bgcolor="#DDDDDD" align="center">'
			_cHTML+= CRLF + '    	<TD colspan="9"><b>Dados do vendedor:</b></TD>'
			_cHTML+= CRLF + '	</TR>'
			_cHTML+= CRLF + '  	<TR>'
			_cHTML+= CRLF + '    	<TD colspan="1"><b>Vendedor:</b></TD>'
			_cHTML+= CRLF + '    	<TD colspan="8">'+clVend+" - "+clNmVend+'</TD>'
			_cHTML+= CRLF + '	</TR>' 
			_cHTML+= CRLF + '  	<TR bgcolor="#DDDDDD" align="center">'
			_cHTML+= CRLF + '    	<TD colspan="9"><b>Dados do orÁamento</b></TD>'
			_cHTML+= CRLF + '   </TR>'
			_cHTML+= CRLF + '  	<TR bgcolor="#EEEEEE" align="center">'  
			_cHTML+= CRLF + '    	<TD colspan="1"><b>Proposta</b></TD>'            
			_cHTML+= CRLF + '    	<TD colspan="1"><b>CÛdigo</b></TD>'
			_cHTML+= CRLF + '    	<TD colspan="1"><b>DescriÁ„o</b></TD>'
			_cHTML+= CRLF + '    	<TD colspan="1"><b>Cliente/Prospect</b></TD>'    
			//_cHTML+= CRLF + '    	<TD><b>Data OrÁa</b></TD>'        
			//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170110] 
			_cHTML+= CRLF + '    	<TD colspan="1"><b>Data Prop</b></TD>'        
			//_cHTML+= CRLF + '    	<TD><b>Data Follow</b></TD>'    
			//_cHTML+= CRLF + '    	<TD colspan="1"><b>⁄ltimo Follow Up</b></TD>'
			_cHTML+= CRLF + '    	<TD colspan="1"><b>⁄ltimo FU</b></TD>'    
			//_cHTML+= CRLF + '    	<TD><b>Retorno em ..</b></TD>'   
			//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170110]  
			//_cHTML+= CRLF + '    	<TD colspan="1"><b>Previs„o Follow Up</b></TD>' 
			_cHTML+= CRLF + '    	<TD colspan="1"><b>Previs„o FU</b></TD>'  
			_cHTML+= CRLF + '    	<TD colspan="1"><b>Valor Total R$</b></TD>'

			_cHTML+= CRLF + '    	<TD colspan="1"><b>HistÛrico FU</b></TD>'

			_cHTML+= CRLF + '   </TR>'
		                                  
		 	//incluida duas linhas abaixo [Mauro Nagata, Actual Trend, 2170209]
			nCntProp := 0    //contador de proposta         
			nTotProp := 0    //total das propostas
    		
    		while clVend = AllTrim((clAlias)->AF1_XVEND)
    			//incluida linha abaixo [Mauro Nagata, Actual Trend, 2170209]
   				nCntProp  += 1  
    	  		clProp 	  :=AllTrim((clAlias)->AF1_XPROP)  
      			clNumOrc  := AllTrim((clAlias)->AF1_ORCAME)  
    		    clDescOrc := Alltrim((clAlias)->AF1_DESCRI) 
    		    clDtOrca  := STOD(AllTrim((clAlias)->AF1_DATA))  
    		    clDtFollo := STOD(AllTrim((clAlias)->AF1_XDTFOL))
    		    clDtRet	  := STOD(AllTrim((clAlias)->AF1_XDTRET))  
    		    clVTotOrc := Transform((clAlias)->AF5_TOTAL, "@RE 999,999,999,999.99")
				cHistoric := alltrim((clAlias)->AF1_XHIST)
    		    if (clAlias)->AF1_CLIENT = ' '
    		    	clNmEnt := Alltrim(Posicione('SUS',1,xFilial('SUS')+(clAlias)->AF1_XPROSP,'US_NOME'))  	
    		    else          
    		    	clNmEnt := Alltrim(Posicione('SA1',1,xFilial('SA1')+(clAlias)->AF1_CLIENT,'A1_NOME'))  	
    		    EndIf
    		    
    			_cHTML+= CRLF + '  	<TR>'   
    			_cHTML+= CRLF + '    	<TD colspan="1">'+clProp+'</TD>'
    			_cHTML+= CRLF + '    	<TD colspan="1">'+clNumOrc+'</TD>'
				_cHTML+= CRLF + '    	<TD colspan="1">'+clDescOrc+'</TD>'
				_cHTML+= CRLF + '    	<TD colspan="1">'+clNmEnt+'</TD>'
				_cHTML+= CRLF + '    	<TD colspan="1" align="center">'+dtoc(clDtOrca)+'</TD>' 
			   	_cHTML+= CRLF + '    	<TD colspan="1" align="center">'+dtoc(clDtFollo)+'</TD>'  
			   	//_cHTML+= CRLF + '    	<TD>'+dtoc(clDtRet)+'</TD>' 
			   	//substituida linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 20170210]               
			   	Do Case
			   		Case clDtRet > dDatabase
			   			_cHTML+= CRLF + '    	<TD colspan="1" align="center" bgcolor="#F5F5F5">'+dtoc(clDtRet)+'</TD>' //bco
			   		Case clDtRet = dDatabase
				   		_cHTML+= CRLF + '    	<TD colspan="1" align="center" bgcolor="#54FF9F">'+dtoc(clDtRet)+'</TD>' //vrd
				   	Case clDtRet >= dDatabase-7
					   	_cHTML+= CRLF + '    	<TD colspan="1" align="center" bgcolor="#FFF68F">'+dtoc(clDtRet)+'</TD>' //amr   
			   		Case clDtRet >= dDatabase-14                                                                              
			   			_cHTML+= CRLF + '    	<TD colspan="1" align="center" bgcolor="#FFD700">'+dtoc(clDtRet)+'</TD>' //lrj
			   Otherwise		                                                                                        
				   		_cHTML+= CRLF + '    	<TD colspan="1" align="center" bgcolor="#FF6347">'+dtoc(clDtRet)+'</TD>' //vrm
				EndCase                       
				//fim bloco [Mauro Nagata, Actual Trend, 20170210]
				//_cHTML+= CRLF + '    	<TD colspan="1" align="right">R$ '+clVTotOrc+'</TD>'
				//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170210] 
				_cHTML+= CRLF + '    	<TD colspan="1" align="right">'+AllTrim(clVTotOrc)+'</TD>'

				_cHTML+= CRLF + '    	<TD colspan="1" align="right">'+AllTrim(cHistoric)+'</TD>'

				_cHTML+= CRLF + '   </TR>'	 
				
				nValVend += (clAlias)->AF5_TOTAL	
    		    nVendas +=  1                   
    		                                    
    		    //incluida linha abaixo [Mauro Nagata, Actual Trend, 20170209]
    		    nTotProp += (clAlias)->AF5_TOTAL
				
    			(clAlias)->(DbSkip())
    		EndDo  
            
    		If len(_cHTML) > 999999
	    		_cHTML+= CRLF + '	<TABLE cellSpacing=0 width="800" background="" border=1 class="cont">'
				_cHTML+= CRLF + '  	<TBODY>'
				_cHTML+= CRLF + '  	<TR bgcolor="#DDDDDD" align="center">'
				_cHTML+= CRLF + '    	<TD colspan="10"><b>Dados do vendedor:</b></TD>'
				_cHTML+= CRLF + '	</TR>'
				_cHTML+= CRLF + '  	<TR>'
				_cHTML+= CRLF + '    	<TD><b>Vendedor:</b></TD>'
				_cHTML+= CRLF + '    	<TD colspan="9"> *** muitos itens *** </TD>'
				_cHTML+= CRLF + '	</TR>' 
				_cHTML+= CRLF + '  	<TR bgcolor="#DDDDDD" align="center">'
				_cHTML+= CRLF + '    	<TD colspan="10"><b>Dados do orÁamento</b></TD>'
				_cHTML+= CRLF + '   </TR>'
				_cHTML+= CRLF + '  	<TR bgcolor="#EEEEEE" align="center">'  
				_cHTML+= CRLF + '    	<TD><b>Proposta</b></TD>'            
				_cHTML+= CRLF + '    	<TD><b>CÛdigo</b></TD>'
				_cHTML+= CRLF + '    	<TD><b>DescriÁ„o</b></TD>'
				_cHTML+= CRLF + '    	<TD><b>Cliente/Prospect</b></TD>'    
				//_cHTML+= CRLF + '    	<TD><b>Data OrÁa</b></TD>'                        
				//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170110] 
				_cHTML+= CRLF + '    	<TD><b>Data Prop</b></TD>'        
				//_cHTML+= CRLF + '    	<TD><b>Data Follow</b></TD>'    
				_cHTML+= CRLF + '    	<TD><b>⁄ltimo Follow Up</b></TD>'    
				//_cHTML+= CRLF + '    	<TD><b>Retorno em ..</b></TD>'   
				//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170110]  
				_cHTML+= CRLF + '    	<TD><b>Previs„o Follow Up</b></TD>'   
			   	_cHTML+= CRLF + '    	<TD><b>Data Follow</b></TD>'    
			   	_cHTML+= CRLF + '    	<TD><b>Retorno em ..</b></TD>' 
				_cHTML+= CRLF + '    	<TD colspan="3"><b>Valor Total</b></TD>'
				_cHTML+= CRLF + '    	<TD colspan="1"><b>HistÛrico FU</b></TD>'
				_cHTML+= CRLF + '   </TR>'
    			_cHTML+= CRLF + '  	<TR>'
				_cHTML+= CRLF + '    	<TD> </TD>'
				_cHTML+= CRLF + '    	<TD> </TD>'
				_cHTML+= CRLF + '    	<TD> </TD>'  
				_cHTML+= CRLF + '    	<TD> </TD>'     
				_cHTML+= CRLF + '    	<TD> </TD>'
				_cHTML+= CRLF + '    	<TD> </TD>'  
				_cHTML+= CRLF + '    	<TD> </TD>' 
				_cHTML+= CRLF + '    	<TD> </TD>' 
				_cHTML+= CRLF + '    	<TD> </TD>' 
				_cHTML+= CRLF + '    	<TD> </TD>' 
				_cHTML+= CRLF + '   </TR>'	
				_cHTML+= CRLF + '	</TBODY></TABLE>'
			  	_cHTML+= CRLF + '<P>&nbsp;</P>'        
				//luiz henrique 09102015
			 //	_cHTML+= CRLF + '</TR>' 
       		 //	_cHTML+= CRLF + '</TD>'
       		 //	_cHTML+= CRLF + '</Table>'
			 //	_cHTML+= CRLF + '</BODY></HTML>' 
				Exit
    		EndIf           
    		//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170209]
		 	_cHTML+= CRLF + '  	<TR>'
			_cHTML+= CRLF + '    	<TD colspan="2" align="center"><b>Quantidade:</b></TD>'
			_cHTML+= CRLF + '    	<TD colspan="1" align="left">'+Transform(nCntProp,"@RE 9,999")+'</TD>'
			_cHTML+= CRLF + '    	<TD colspan="4" align="right"><b>Total R$:</b></TD>'                      
			_cHTML+= CRLF + '    	<TD colspan="1" align="right">'+AllTrim(Transform(nTotProp,"@RE 9,999,999,999.99"))+'</TD>'
			_cHTML+= CRLF + '	</TR>'
			_cHTML+= CRLF + '  	<TR>'	
		   	_cHTML+= CRLF + '	</TBODY></TABLE>'
		 	_cHTML+= CRLF + '<P>&nbsp;</P>'
		 	//fim 	bloco [Mauro Nagata, Actual Trend, 20170209]  
	 
             //  - COMENTADO BLOCO ABAIXO , POIS NAO EH PARA TER SOMATORIA DE TOTAIS E ORCAMENTOS  - SOLICITADO PELO SR.EDSON
       //     _cHTML+= CRLF + '   <TR>'
        //    _cHTML+= CRLF + '   <TD colspan="6"></TD>'
        //    _cHTML+= CRLF + '   <TD>Valor Total</TD>'    
        //    _cHTML+= CRLF + '   <TD>R$ '+Transform(nValVend, "@E 999,999,999.99")+'</TD>'	   
        //    _cHTML+= CRLF + '   </TR>'
       //     _cHTML+= CRLF + '   <TR>'
        //    _cHTML+= CRLF + '   <TD colspan="6"></TD>'
         //   _cHTML+= CRLF + '   <TD>N∫ OrÁamentos</TD>'
       //     _cHTML+= CRLF + '   <TD>'+Str(nVendas)+'</TD>'	   
       //     _cHTML+= CRLF + '   </TR>'
			_cHTML+= CRLF + '	</TBODY></TABLE>'
			_cHTML+= CRLF + '<P>&nbsp;</P>'   
			   
			   //		nVTotVend += nValVend	    
    		   //   	nTotVendas += nVendas                                
    		   
    		   	//excluida linha abaixo [Mauro Nagata, Actual Trend, 20170110]
				//	(clAlias)->(DbSkip())                		
    	EndDo     
    		
    	  //		_cHTML+= CRLF + '	<TABLE cellSpacing=0 width="800" background="" border=1 class="cont">'
		  //		_cHTML+= CRLF + '  	<TBODY>'
		  //		_cHTML+= CRLF + '  	<TR bgcolor="#DDDDDD" align="right">'	 
			//  	_cHTML+= CRLF + '   <TD colspan="6"></TD>'
 	  //			_cHTML+= CRLF + '   <TD>Valor Total dos OrÁamentos </TD>'    
    //       		_cHTML+= CRLF + '   <TD>R$ '+Transform(	nVTotVend, "@E 999,999,999.99")+'</TD>'	 
       //    		_cHTML+= CRLF + '   </TR>' 
        //   		_cHTML+= CRLF + ' 	<TR bgcolor="#DDDDDD" align="right">'	 
		  //	  	_cHTML+= CRLF + '   <TD colspan="6"></TD>'
 		//		_cHTML+= CRLF + '   <TD>Total de OrÁamentos </TD>'    
         //  		_cHTML+= CRLF + '   <TD>'+Str(nTotVendas)+'</TD>'	 
          // 		_cHTML+= CRLF + '   </TR>'		  
           // 	_cHTML+= CRLF + '	</TBODY></TABLE>'
		   //		_cHTML+= CRLF + '<P>&nbsp;</P>'  				
    	_cHTML+= CRLF + '</TR>' 
       	_cHTML+= CRLF + '</TD>'
       	_cHTML+= CRLF + '</Table>'
		_cHTML+= CRLF + '</BODY></HTML>'

		MemoWrite("FMAILJOB.HTML",_cHTML)

    	EnviaEmail() 
    	//U_FMAILV(c_fil)
    EndIf        
Return 

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Verifica os registros validos para envio do email para os gestores.         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

Static Function LJOBSQL()
		
	Local clAliasSql := GetNextAlias()
    /*
	BeginSql Alias clAliasSql 
	   
	    select AF1.AF1_FILIAL, AF1.AF1_ORCAME,AF1.AF1_DATA, AF1.AF1_CLIENT, AF1.AF1_XPROSP, AF1.AF1_DESCRI, AF1.AF1_XVEND, 
	    	   AF1.AF1_XDTRET, AF5.AF5_EDT, AF5.AF5_TOTAL,AF1.AF1_XSTAT,AF1.AF1_MSFIL, AF1.AF1_XPROP,AF1.AF1_XDTFOL  from %Table:AF1% as AF1
     	inner join %Table:AF5% as AF5 on AF1.AF1_ORCAME = AF5.AF5_ORCAME AND AF1.AF1_ORCAME = AF5.AF5_EDT	    
     	where AF1.AF1_MSFIL=%EXP:cFilAnt% AND AF1.%NotDel% AND AF5.%NotDel% AND AF1.AF1_XDTRET <> ' ' AND AF1.AF1_XDTRET <= %EXP:DDATABASE% AND AF1.AF1_DATA BETWEEN '20150101' AND %EXP:DDATABASE%
     	AND AF1.AF1_FILIAL=%xFilial:AF1% AND AF1.AF1_FASE = '04' AND AF1.AF1_XSTAT <>' H' AND AF1.AF1_XSTAT <>' I'  
      	AND AF5.AF5_TOTAL >=%EXP:nMinimo%
	    ORDER BY AF1.AF1_XVEND,AF5.AF5_TOTAL DESC,AF1.AF1_DATA
	    
	EndSql
	*/    
	//substituido bloco acima pelo abaixo [Mauro Nagata, Actual Trend, 20170110] 
	BeginSql Alias clAliasSql 
	   
	    SELECT 	AF1.AF1_FILIAL, AF1.AF1_ORCAME,AF1.AF1_DATA, AF1.AF1_CLIENT, AF1.AF1_XPROSP, 
	    		AF1.AF1_DESCRI, AF1.AF1_XVEND, AF1.AF1_XDTRET, AF1.AF1_XSTAT,AF1.AF1_MSFIL,
	    		AF1.AF1_XPROP,AF1.AF1_XDTFOL,
	    		SA3.A3_COD,SA3.A3_EMAIL,SA3.A3_NOME,
	    	 	AF5.AF5_EDT, AF5.AF5_TOTAL,AF1_XHIST
	    FROM %Table:AF1% AS AF1
     	INNER JOIN %Table:AF5% AS AF5 
     		ON  AF5.%NotDel%
     			AND AF1.AF1_ORCAME = AF5.AF5_ORCAME 
     			AND AF1.AF1_ORCAME = AF5.AF5_EDT   
     	LEFT JOIN %Table:SA3% AS SA3 
     		ON  SA3.%NotDel%
     			AND AF1.AF1_XVEND = SA3.A3_COD     			 
	     		AND SA3.A3_FILIAL =  AF1.AF1_MSFIL 
	     		AND SA3.A3_EMAIL  <> ' ' 
	     		AND SA3.A3_NOME   <> ' '	    
     	WHERE  AF1.%NotDel%               
     		AND AF1.AF1_FILIAL	= %xFilial:AF1%
     		AND AF1.AF1_MSFIL	= %EXP:cFilAnt%  
     		AND ((AF1.AF1_DATA+3 <= %EXP:DDATABASE% AND AF1.AF1_XDTRET = '' ) OR AF1.AF1_XDTRET <> ' ') 
     		AND AF1.AF1_DATA 	>= '20150101'      		
     		AND AF1.AF1_FASE 	= '04'                 
     		
	    ORDER BY AF1.AF1_XVEND,AF5.AF5_TOTAL DESC,AF1.AF1_DATA
	
	EndSql
		
Return(clAliasSql)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥TK260ROT  ∫Autor  ≥Microsiga           ∫ Data ≥  08/23/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Envia o email para os responsaveis.                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function EnviaEmail()

	Local l_Continua	:= .T.
	Private c_msgerro	:= ''
 	//Private c_para		:= GetMV("MV_XMAILGT")  
 	Private c_paradir   := GetMV("MV_XMAILDI")       
 	
 	//solicitado que fosse enviado ao george pelo Artur e Fabio [Mauro Nagata, Actual Trend, 20180524]
	//cMailAdd := "george@playpiso.com.br"      
	//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20180827]
	//cMailAdd := "comercial@playpiso.com.br;armando@playpiso.com.br;thiago.rufino@actualtrend.com.br"
	//If !U_FGEN010(c_paradir+";"+cMailAdd,c_assunto,_cHTML,,.t.)
	//substituÌdo bloco acima pelo abaixo [Mauro Nagata, Actual Trend,20190906]
	//solicitado pelo Fabio
	cMailAdd1 := SuperGetMv("LP_EMFUP1",.F.,"mauro.nagata@actualtrend.com.br")
    cMailAdd2 := SuperGetMv("LP_EMFUP2",.F.,"mauro.nagata@actualtrend.com.br")
	If !U_FGen010(c_paradir+If(Empty(cMailAdd1),"",";"+cMailAdd1)+If(Empty(cMailAdd2),"",";"+cMailAdd2),c_assunto,_cHTML,,.t.)
	//fim bloco [Mauro Nagata, Actual Trend,20190906]	 
			Return c_msgerro
	EndIf	
	//Substituido bloco abaixo pelo acima [Mauro Nagata, Actual Trend, 07/05/2012]
	/*                                    
	Private c_paradir   := "bruno.parreira@actualtrend.com.br"
	      
	If !U_FGEN010(c_paradir,c_assunto,_cHTML,,.t.)	
		Return c_msgerro
	EndIf	
	*/
	
Return

//luiz henrique 28/01/15 .... SolicitaÁ„o do Sr.Edson Simoes
// funcao FMAILV , criada para enviar os followups, individuais de cada vendedor da empresa, apÛs disparo do job/followups para diretores
User Function FMAILV(c_fil)     

 
    Private clVend    := ''  
    Private clNmVend  := ''
    Private clNumOrc  := ''
    Private clDescOrc := '' 
    Private clProp  := ''       // numero da proposta WORD
    Private clDtOrca := ''     //data de inclusao do orÁamento
    Private clDtFollo := ''    //data de inclus„o de follow-up   
    Private clDtRet   := ''    //data de Retorno do Follow-up
    Private clNmEnt   := ''
    Private clVTotOrc := ''
    Private c_texto   := '' 
    Private c_assunto := ''      
  //  private nVTotVend :=0      //total da soma das vendas
  //  private nTotVendas  :=0    //total de vendas
    Private _cHTML 	  := ''   
    Private clEmailVend 
    
        
 	clAlias := LVENDSQL()  
    (clAlias)->(DbGoTop())
    if (clAlias)->(!EOF())  
    	While (clAlias)->(!EOF())
    		nValVend := 0 
    		nVendas  := 0 
    	//	nVTotVend        //total da soma das vendas
    	//    nTotVendas       //total das vendas realizadas
    	
    		clVend 	  := AllTrim((clAlias)->AF1_XVEND)
    		clNmVend  := Alltrim(Posicione('SA3',1,xFilial('SA3')+(clAlias)->AF1_XVEND,'A3_NOME'))   
    		clEmailVend  := Alltrim(Posicione('SA3',1,xFilial('SA3')+(clAlias)->AF1_XVEND,'A3_EMAIL'))  	
    	   
    			
   		 	_cHTML:='<HTML><HEAD><TITLE></TITLE>'
			_cHTML+= CRLF + '<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
			_cHTML+= CRLF + '<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
			_cHTML+= CRLF + '<style type="text/css">'
		    _cHTML+= CRLF + 'table.cont {'
		    _cHTML+= CRLF + 'font-size:10}'
		    _cHTML+= CRLF + '</style>' 
			_cHTML+= CRLF + '<BODY>'
			_cHTML+= CRLF + '<Table border=0 width=800>'             
			_cHTML+= CRLF + '<TR align="center">'
			_cHTML+= CRLF + '	<TD><H1>RelatÛrio de Followup</H1></TD>'
			_cHTML+= CRLF + '</TR>' 
			_cHTML+= CRLF + '<TR align="center">'
		    _cHTML+= CRLF + '	<TD>Os seguintes vendedores n„o efetuaram retorno ao cliente nos seguintes orÁamentos:</TD>'  
		    _cHTML+= CRLF + '</TR>'  
		    _cHTML+= CRLF + '<TR align="center">'
		    _cHTML+= CRLF + '	<TD>'
		    
		    c_assunto := "Retorno de Followup - " + c_fil
    		
    		_cHTML+= CRLF + '	<TABLE cellSpacing=0 width="800" background="" border=1 class="cont">'
			_cHTML+= CRLF + '  	<TBODY>'
			_cHTML+= CRLF + '  	<TR bgcolor="#DDDDDD" align="center">'
			_cHTML+= CRLF + '    	<TD colspan="8"><b>Dados do vendedor:</b></TD>'
			_cHTML+= CRLF + '	</TR>'
			_cHTML+= CRLF + '  	<TR>'
			_cHTML+= CRLF + '    	<TD><b>Vendedor:</b></TD>'
			_cHTML+= CRLF + '    	<TD colspan="7">'+clVend+" - "+clNmVend+'</TD>'
			_cHTML+= CRLF + '	</TR>' 
			_cHTML+= CRLF + '  	<TR bgcolor="#DDDDDD" align="center">'
			_cHTML+= CRLF + '    	<TD colspan="8"><b>Dados do orÁamento</b></TD>'
			_cHTML+= CRLF + '   </TR>'
			_cHTML+= CRLF + '  	<TR bgcolor="#EEEEEE" align="center">'  
			_cHTML+= CRLF + '    	<TD><b>Proposta</b></TD>'            
			_cHTML+= CRLF + '    	<TD><b>CÛdigo</b></TD>'
			_cHTML+= CRLF + '    	<TD><b>DescriÁ„o</b></TD>'
			_cHTML+= CRLF + '    	<TD><b>Cliente/Prospect</b></TD>'     
			//_cHTML+= CRLF + '    	<TD><b>Data OrÁa</b></TD>'        
			//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170110] 
			_cHTML+= CRLF + '    	<TD><b>Data Prop</b></TD>'        
			//_cHTML+= CRLF + '    	<TD><b>Data Follow</b></TD>'                        
			//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170110]
			_cHTML+= CRLF + '    	<TD><b>⁄ltimo FollowUp</b></TD>'    
			//_cHTML+= CRLF + '    	<TD><b>Retorno em ..</b></TD>'   
			//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170110]  
			_cHTML+= CRLF + '    	<TD><b>Previs„o FollowUp</b></TD>'      
			_cHTML+= CRLF + '    	<TD><b>Valor Total</b></TD>'
			_cHTML+= CRLF + '   </TR>'            
			//incluida linha abaixo [Mauro Nagata, Actual Trend, 2170209]
			nCntProp := 0    //contador de proposta         
			nTotProp := 0    //total das propostas
    		
    		while clVend = AllTrim((clAlias)->AF1_XVEND)
    			//incluida linha abaixo [Mauro Nagata, Actual Trend, 2170209]
    			nCntProp += 1 
    	  		clProp 	  :=AllTrim((clAlias)->AF1_XPROP)  
      			clNumOrc  := AllTrim((clAlias)->AF1_ORCAME)  
    		    clDescOrc := Alltrim((clAlias)->AF1_DESCRI) 
    		    clDtOrca  := STOD(AllTrim((clAlias)->AF1_DATA))  
    		    clDtFollo := STOD(AllTrim((clAlias)->AF1_XDTFOL))
    		    clDtRet	  := STOD(AllTrim((clAlias)->AF1_XDTRET))  
    		    clVTotOrc := Transform((clAlias)->AF5_TOTAL, "@E 999,999,999.99")
    		    if (clAlias)->AF1_CLIENT = ' '
    		    	clNmEnt := Alltrim(Posicione('SUS',1,xFilial('SUS')+(clAlias)->AF1_XPROSP,'US_NOME'))  	
    		    else          
    		    	clNmEnt := Alltrim(Posicione('SA1',1,xFilial('SA1')+(clAlias)->AF1_CLIENT,'A1_NOME'))  	
    		    EndIf
    		    
    			_cHTML+= CRLF + '  	<TR>'   
    			_cHTML+= CRLF + '    	<TD>'+clProp+'</TD>'
    			_cHTML+= CRLF + '    	<TD>'+clNumOrc+'</TD>'
				_cHTML+= CRLF + '    	<TD>'+clDescOrc+'</TD>'
				_cHTML+= CRLF + '    	<TD>'+clNmEnt+'</TD>'
				_cHTML+= CRLF + '    	<TD>'+dtoc(clDtOrca)+'</TD>' 
			   	_cHTML+= CRLF + '    	<TD>'+dtoc(clDtFollo)+'</TD>'  
			   	_cHTML+= CRLF + '    	<TD>'+dtoc(clDtRet)+'</TD>' 
				_cHTML+= CRLF + '    	<TD>R$ '+clVTotOrc+'</TD>'
				_cHTML+= CRLF + '   </TR>'	 
				
				nValVend += (clAlias)->AF5_TOTAL	
    		    nVendas +=  1           
    		    nTotProp += Val(clVTotOrc)
				
    			(clAlias)->(DbSkip())
    		EndDo  
            
    		If len(_cHTML) > 999999
	    		_cHTML+= CRLF + '	<TABLE cellSpacing=0 width="800" background="" border=1 class="cont">'
				_cHTML+= CRLF + '  	<TBODY>'
				_cHTML+= CRLF + '  	<TR bgcolor="#DDDDDD" align="center">'
				_cHTML+= CRLF + '    	<TD colspan="8"><b>Dados do vendedor:</b></TD>'
				_cHTML+= CRLF + '	</TR>'
				_cHTML+= CRLF + '  	<TR>'
				_cHTML+= CRLF + '    	<TD><b>Vendedor:</b></TD>'
				_cHTML+= CRLF + '    	<TD colspan="8"> *** muitos itens *** </TD>'
				_cHTML+= CRLF + '	</TR>' 
				_cHTML+= CRLF + '  	<TR bgcolor="#DDDDDD" align="center">'
				_cHTML+= CRLF + '    	<TD colspan="8"><b>Dados do orÁamento</b></TD>'
				_cHTML+= CRLF + '   </TR>'
				_cHTML+= CRLF + '  	<TR bgcolor="#EEEEEE" align="center">'  
				_cHTML+= CRLF + '    	<TD><b>Proposta</b></TD>'            
				_cHTML+= CRLF + '    	<TD><b>CÛdigo</b></TD>'
				_cHTML+= CRLF + '    	<TD><b>DescriÁ„o</b></TD>'
				_cHTML+= CRLF + '    	<TD><b>Cliente/Prospect</b></TD>'     
				//_cHTML+= CRLF + '    	<TD><b>Data OrÁa</b></TD>'        
				//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170110] 
				_cHTML+= CRLF + '    	<TD><b>Data Prop</b></TD>'        
				//_cHTML+= CRLF + '    	<TD><b>Data Follow</b></TD>'    
				_cHTML+= CRLF + '    	<TD><b>⁄ltimo FollowUp</b></TD>'    
				//_cHTML+= CRLF + '    	<TD><b>Retorno em ..</b></TD>'   
				//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20170110]  
				_cHTML+= CRLF + '    	<TD><b>Previs„o FollowUp</b></TD>'   
				_cHTML+= CRLF + '    	<TD><b>Valor Total</b></TD>'
				_cHTML+= CRLF + '   </TR>'
    			_cHTML+= CRLF + '  	<TR>'
				_cHTML+= CRLF + '    	<TD> </TD>'
				_cHTML+= CRLF + '    	<TD> </TD>'
				_cHTML+= CRLF + '    	<TD> </TD>'  
				_cHTML+= CRLF + '    	<TD> </TD>'     
				_cHTML+= CRLF + '    	<TD> </TD>'
				_cHTML+= CRLF + '    	<TD> </TD>'  
				_cHTML+= CRLF + '    	<TD> </TD>' 
				_cHTML+= CRLF + '    	<TD> </TD>' 
				_cHTML+= CRLF + '   </TR>'	
				_cHTML+= CRLF + '	</TBODY></TABLE>'
				_cHTML+= CRLF + '<P>&nbsp;</P>'                                   		
				Exit
    		EndIf     
    		
    		//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170209]
		 	_cHTML+= CRLF + '  	<TR>'
			_cHTML+= CRLF + '    	<TD align="center" colspan="2"><b>Quantidade:</b></TD>'
			_cHTML+= CRLF + '    	<TD align="left">'+Transform(nCntProp,"@RE 9,999")+'</TD>'
			_cHTML+= CRLF + '    	<TD colspan="3" align="right"><b>Total:</b></TD>'                      
			_cHTML+= CRLF + '    	<TD colspan="2" align="right">'+AllTrim(Transform(nTotProp,"@RE 9,999,999,999.99"))+'</TD>'
			_cHTML+= CRLF + '	</TR>'
			_cHTML+= CRLF + '  	<TR>'	
		   	_cHTML+= CRLF + '	</TBODY></TABLE>'
		 	_cHTML+= CRLF + '<P>&nbsp;</P>'
		 	//fim 	bloco [Mauro Nagata, Actual Trend, 20170209]  
            			   
			//		nVTotVend += nValVend	    
    		//      	nTotVendas += nVendas           
				    
			 if	clVend <>(clAlias)->AF1_XVEND     
			  	_cHTML+= CRLF + '</TR>' 
   	  			_cHTML+= CRLF + '</TD>'
   	   			_cHTML+= CRLF + '</Table>'
  	   			_cHTML+= CRLF + '</BODY></HTML>' 
   				EnvEmailVend() 
   			 endif       		
    	EndDo
      
    EndIf        
Return   


Static Function LVENDSQL()
		
	Local clAliasSqll := GetNextAlias()
    /*
	BeginSql Alias clAliasSqll 
	   
	     select AF1.AF1_FILIAL, AF1.AF1_ORCAME,AF1.AF1_DATA, AF1.AF1_CLIENT, AF1.AF1_XPROSP, AF1.AF1_DESCRI, AF1.AF1_XVEND,SA3.A3_COD,SA3.A3_EMAIL,SA3.A3_NOME ,  
	    	   AF1.AF1_XDTRET, AF5.AF5_EDT, AF5.AF5_TOTAL,AF1.AF1_XSTAT,AF1.AF1_MSFIL, AF1.AF1_XPROP,AF1.AF1_XDTFOL  from %Table:AF1% as AF1
     	inner join %Table:AF5% as AF5 on AF1.AF1_ORCAME = AF5.AF5_ORCAME AND AF1.AF1_ORCAME = AF5.AF5_EDT  
     	inner join %Table:SA3% as SA3 on AF1.AF1_XVEND = SA3.A3_COD  	    
     	where AF1.AF1_MSFIL=%EXP:cFilAnt% AND AF1.%NotDel% AND AF5.%NotDel% AND AF1.AF1_XDTRET <> ' ' AND AF1.AF1_XDTRET <= %EXP:DDATABASE% AND AF1.AF1_DATA BETWEEN '20150101' AND %EXP:DDATABASE%
     	AND AF1.AF1_FILIAL=%xFilial:AF1% AND AF1.AF1_FASE = '04' AND AF1.AF1_XSTAT <>' H' AND AF1.AF1_XSTAT <>' I'
     	AND SA3.%NotDel% AND SA3.A3_FILIAL =  AF1.AF1_MSFIL AND SA3.A3_EMAIL <>' ' AND SA3.A3_NOME <>' '
	    ORDER BY AF1.AF1_XVEND,AF1.AF1_DATA, AF5.AF5_TOTAL DESC
	     
	EndSql 
	*/    
	//substituido bloco acima pelo abaixo [Mauro Nagata, Actual Trend, 20170110]
	BeginSql Alias clAliasSqll 
	   
	   	SELECT 	AF1.AF1_FILIAL, AF1.AF1_ORCAME,AF1.AF1_DATA, AF1.AF1_CLIENT, AF1.AF1_XPROSP, 
	   			AF1.AF1_DESCRI, AF1.AF1_XVEND,SA3.A3_COD,SA3.A3_EMAIL,SA3.A3_NOME ,  
	    	   	AF1.AF1_XDTRET, AF5.AF5_EDT, AF5.AF5_TOTAL,AF1.AF1_XSTAT,AF1.AF1_MSFIL, 
	    	   	AF1.AF1_XPROP,AF1.AF1_XDTFOL  
	   	FROM %Table:AF1% AS AF1
     	INNER JOIN %Table:AF5% AS AF5 
     		ON  AF5.%NotDel%
     			AND AF1.AF1_ORCAME = AF5.AF5_ORCAME 
     			AND AF1.AF1_ORCAME = AF5.AF5_EDT  
     	LEFT JOIN %Table:SA3% AS SA3 
     		ON  SA3.%NotDel%
     			AND AF1.AF1_XVEND = SA3.A3_COD     			 
	     		AND SA3.A3_FILIAL =  AF1.AF1_MSFIL 
	     		AND SA3.A3_EMAIL  <>' ' 
	     		AND SA3.A3_NOME   <>' '  	    
     	WHERE AF1.AF1_MSFIL=%EXP:cFilAnt% 
     		AND AF1.%NotDel%  
     		AND AF1.AF1_FILIAL 	= %xFilial:AF1%
     		--AND ((AF1.AF1_DATA+3 <= %EXP:DDATABASE% AND AF1.AF1_XDTRET = ' ' ) OR AF1.AF1_XDTRET <> ' ')
     		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20180111]  
     		AND AF1.AF1_DATA+3 <= %EXP:DDATABASE% 
     		AND AF1.AF1_DATA 	>= '20150101'   		 
     		AND AF1.AF1_FASE   	= '04' 
	    ORDER BY AF1.AF1_XVEND,AF1.AF1_DATA, AF5.AF5_TOTAL DESC
	     
	EndSql
		
Return(clAliasSqll)
                             

Static Function EnvEmailVend()

	Local l_Continua	:= .T. 
 	Private c_msgerro	:= ''  
	Private c_para   := clEmailVend                  
	   
	If !U_FGEN010(c_para,c_assunto,_cHTML,,.t.)	 
	//If !U_FGEN010(c_para,c_assunto,_cHTML,,.t.)	
		Return c_msgerro
   	EndIf
	
Return      
//luiz henrique 28/01/15 .... SolicitaÁ„o do Sr.Edson Simoes
// fim da funÁ„o FMAILV , onde trata o envio dos followups individuais
