#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "TOPCONN.CH" 
#INCLUDE "AP5MAIL.CH"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFMAILPVD  บAutor  ณBruno S. Parreira   บ Data ณ  28/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO PARA ENVIO DE EMAIL DOS PEDIDOS DE VENDA EM ABERTO  บฑฑ
ฑฑบ          ณ QUE TENHAM PASSADO DA DATA DE ENTREGA.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LISONDA                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
User Function FMAILPVD(c_fil)
    Private cpVazio   := '' 
    Private clNumPed  := '' 
    Private clNumOb   := ''  
    Private clNumIt   := ''
    Private clNumPro  := ''
    Private clVlPro   := ''
    Private clDtEnt   := '' 
    Private vTotPed   := 0
    Private vTotGer   := 0 
    Private clVTotPed := ''   
    Private clCondF   := ''
    Private clSitP    := ''
    Private clVlTPd   := ''   
    Private clTotGer  := ''
    Private c_texto   := '' 
    Private c_assunto := ''  
    Private cCalc     := ''
    Private cBranco   := " "  
   
    
    Private _cHTML 	  := '' 
    
    _cHTML:='<HTML><HEAD><TITLE></TITLE>'
	_cHTML+= CRLF +'<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
	_cHTML+= CRLF +'<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
	_cHTML+= CRLF +'<style type="text/css">'
    _cHTML+= CRLF + 'table.cont {'
    _cHTML+= CRLF + 'font-size:10}'
    _cHTML+= CRLF + '</style>' 
	_cHTML+= CRLF + '<BODY>'
	_cHTML+= CRLF + '<Table align="center" border=0 width=800>'             
	_cHTML+= CRLF + '	<TR align="center">'
	_cHTML+= CRLF + '		<TD><H1>Saldos a Faturar</H1></TD>'
	_cHTML+= CRLF + '	</TR>' 
  	_cHTML+= CRLF + '	<TR align="center">'
  	_cHTML+= CRLF + '		<TD>Os seguintes pedidos de venda estใo em aberto:</TD>'  
  	_cHTML+= CRLF + '	</TR>'  
    
   	Conout('ENTROU NA ROTINA FILIAL ' + CFILANT + ' VARIAVEL C_FIL = '+c_fil)

    c_assunto := "Saldos a Faturar - " + c_fil  
    
    
 	clAliasCTT := FPVDSQLCTT()  
    (clAliasCTT)->(DbGoTop())
    if (clAliasCTT)->(!EOF())                                                                 	
    	While (clAliasCTT)->(!EOF())
    		clNumPed  := (clAliasCTT)->C5_NUM
    		clNumOb   := (clAliasCTT)->CTT_CUSTO       
    		clNmCli   := Posicione("SA1",1,xFilial()+(clAliasCTT)->CTT_XCONT1+(clAliasCTT)->CTT_XLJCT1,"A1_NOME") 
    	
			if (clAliasCTT)->C5_XSITP == "N"
				clSitPd := "Normal"
			elseif (clAliasCTT)->C5_XSITP == "C"
				clSitPd := "Caucionado"
			else
				clSitPd := ""
			EndIf   
				
			if (clAliasCTT)->C5_XCONDF == "1" 		
				clCondF := "Dt. Fixa"
			elseif (clAliasCTT)->C5_XCONDF == "2"
				clCondF := "Dt. Entrega"          
			elseif (clAliasCTT)->C5_XCONDF == "3"
				clCondF := "Medi็ใo"
			else
				clCondF := "" 		
			EndIf
    		
    		clAliasSC6 := FPVDSQLSC6()
    		(clAliasSC6)->(DbGoTop())
    		if (clAliasSC6)->(!EOF()) 
    			clAliasTot := FPVDSQLTOT()	
				(clAliasTot)->(DbGoTop())	
				clVlTPd := "R$ " + Alltrim(Transform((clAliasTot)->TOTAL, "@E 999,999,999.99"))
				
    			_cHTML+= CRLF + '	<TR align="center">'
    			_cHTML+= CRLF + '		<TD>'
    			_cHTML+= CRLF + '			<TABLE align="center" cellSpacing=0 width="800" background="" border=1 class="cont">'
				_cHTML+= CRLF + '  				<TR bgcolor="#DDDDDD" align="center">'
				_cHTML+= CRLF + '    				<TD colspan="6"><b>Dados do Pedido:</b></TD>'
				_cHTML+= CRLF + '				</TR>'
				_cHTML+= CRLF + '  				<TR align="center">'
				_cHTML+= CRLF + '    				<TD><b>Num. Pedido:</b></TD>'
				_cHTML+= CRLF + '    				<TD>'+clNumPed+'</TD>'
				_cHTML+= CRLF + '    				<TD><b>Num. Obra:</b></TD>'
				_cHTML+= CRLF + '    				<TD>'+clNumOb+'</TD>' 
				_cHTML+= CRLF + '    				<TD><b>Cliente:</b></TD>'
				_cHTML+= CRLF + '    				<TD>'+clNmCli+'</TD>'
				_cHTML+= CRLF + '				</TR>'
				_cHTML+= CRLF + '  				<TR>'
				_cHTML+= CRLF + '    				<TD colspan="6">'
				_cHTML+= CRLF + '						<TABLE cellSpacing=0 width="800" background="" border=0 class="cont">' 
				_cHTML+= CRLF + '  							<TR bgcolor="#EEEEEE" align="center">'
				//_cHTML+= CRLF + '    							<TD><b>Sit. Pedido:</b></TD>' // Substituido por espa็o em branco [Bruno Parreira, Actual Trend, 01/06/2011]
				//_cHTML+= CRLF + '    							<TD>'+clSitPd+'</TD>'
				_cHTML+= CRLF + '    							<TD></TD>'
				_cHTML+= CRLF + '    							<TD></TD>'
				_cHTML+= CRLF + '    							<TD><b>Cond. Fat.:</b></TD>'
				_cHTML+= CRLF + '    							<TD>'+clCondF+'</TD>'
				_cHTML+= CRLF + '    							<TD><b>Valor Total:</b></TD>'
				_cHTML+= CRLF + '    							<TD>'+clVlTPd+'</TD>'
				_cHTML+= CRLF + '   						</TR>'
				_cHTML+= CRLF + '  	    				</TABLE>'
				_cHTML+= CRLF + '  					</TD>'
				_cHTML+= CRLF + '  				</TR>'
				_cHTML+= CRLF + '  				<TR>'
				_cHTML+= CRLF + '    				<TD colspan="6">'
				_cHTML+= CRLF + '						<TABLE cellSpacing=0 width="800" background="" border=0 class="cont">' 
				_cHTML+= CRLF + '  							<TR bgcolor="#EEEEEE" align="center">'
				_cHTML+= CRLF + '    							<TD><b>Item</b></TD>'
				_cHTML+= CRLF + '    							<TD><b>Produto</b></TD>'
				_cHTML+= CRLF + '    							<TD><b>Valor</b></TD>'
				_cHTML+= CRLF + '    							<TD><b>Data de Entrega</b></TD>' 
				_cHTML+= CRLF + '    							<TD></TD>' 
				_cHTML+= CRLF + '    							<TD></TD>'
				_cHTML+= CRLF + '   						</TR>'
    		
    			While (clAliasSC6)->(!EOF())	
    			 	clNumIt := (clAliasSC6)->C6_ITEM 
    			 	clNmPro := AllTrim((clAliasSC6)->C6_PRODUTO) + " - " + AllTrim(Posicione("SB1",1,xFilial()+(clAliasSC6)->C6_PRODUTO,"B1_DESC")) 
    			 	clVlPro := "R$ " + Alltrim(Transform((clAliasSC6)->C6_VALOR, "@E 999,999,999.99"))
    			
    		        clAliasLOG := FPVDSQLLOG()
					(clAliasLOG)->(DbGoTop())
    		        
    		        if (clAliasLOG)->REG > 1
    					clDtEnt := DtoC(stod((clAliasSC6)->C6_ENTREG)) + '*'
    				else
    					clDtEnt := DtoC(stod((clAliasSC6)->C6_ENTREG))
    				EndIf	
    				
    				if (claliasSC6)->C6_XSITP == 'S'                                                            //////
						cCalc := "Caucionado" 
					else
						cCalc := " "	
					EndIf	
    		    
    				_cHTML+= CRLF + '  						<TR align="center">'
					_cHTML+= CRLF + '    						<TD>'+clNumIt+'</TD>'
					_cHTML+= CRLF + '    						<TD>'+clNmPro+'</TD>'
					_cHTML+= CRLF + '    						<TD>'+clVlPro+'</TD>'
					_cHTML+= CRLF + '    						<TD>'+clDtEnt+'</TD>'  
					_cHTML+= CRLF + '    						<TD>'+cCalc+'</TD>'  
					_cHTML+= CRLF + '    						<TD>'+cBranco+'</TD>'  // Incluido espa็o em branco para deixar numero de colunar certo 
					_cHTML+= CRLF + '   					</TR>'                     // quando copiar para excel [Bruno Parreira, Actual Trend, 12/07/2011]
					
					vTotPed += (clAliasSC6)->C6_VALOR 	
    				
    				(clAliasSC6)->(DbSkip())
    			EndDo
    			clVTotPed := "R$ "+Alltrim(Transform(vTotPed, "@E 999,999,999.99"))
    			vTotGer += vTotPed  
    			vTotPed := 0
    			_cHTML+= CRLF + '  							<TR align="center">'
				_cHTML+= CRLF + '    							<TD colspan="6"><b>Saldo total a Faturar: '+clVTotPed+'</b></TD>'
				_cHTML+= CRLF + '   						</TR>' 
    			_cHTML+= CRLF + '   					</TABLE>'
    			_cHTML+= CRLF + '    				</TD>'
    			_cHTML+= CRLF + '    			</TR>'
    			_cHTML+= CRLF + '    		</TABLE>'
    			_cHTML+= CRLF + '		</TD>'
    			_cHTML+= CRLF + '	</TR>'
			EndIf
			(clAliasCTT)->(DbSkip())		
    	EndDo   
    	clTotGer := "R$ " + Alltrim(Transform(vTotGer, "@E 999,999,999.99"))
    	_cHTML+= CRLF + '	<TR align="center">'
    	_cHTML+= CRLF + '		<TD><p align="center"><b>Total Geral: ******************************************************************** '+clTotGer+'</b></p></TD>'
    	_cHTML+= CRLF + '	</TR>' 
    	_cHTML+= CRLF + '</Table>'
		_cHTML+= CRLF + '</BODY></HTML>'
		
		MemoWrite("FMAILPVD.HTML",_cHTML)
    	
		Conout('VAI ENVIAR O EMAIL...  ')

    	EnviaEmail()
	EndIf    		        
Return 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica os registros validos para envio do email para os gestores.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function FPVDSQLCTT()
	Local clAliasSql := GetNextAlias()   
	
	BeginSql Alias clAliasSql    
	  
		select CTT_CUSTO, CTT_XCONT1, CTT_XLJCT1, C5_NUM, C5_XSITP, C5_XCONDF from %Table:CTT% CTT
		inner join %Table:SC5% SC5 on C5_CCUSTO = CTT_CUSTO AND C5_FILIAL=%EXP:cFilAnt% AND SC5.%NotDel% AND C5_XPEDFIN='S'
		where CTT.%NotDel%
		order by CTT_CUSTO, C5_NUM

	EndSql

Return(clAliasSql)   

Static Function FPVDSQLSC6()
	Local clAliasSql := GetNextAlias()

	BeginSql Alias clAliasSql    
	  
		select C6_ITEM, C6_PRODUTO, C6_VALOR, C6_ENTREG, C6_XSITP from %Table:SC6% SC6
		where C6_FILIAL=%EXP:cFilAnt% AND SC6.%NotDel% AND C6_NUM=%EXP:clNumPed% AND C6_NOTA=%EXP:cpVazio% AND C6_BLQ=%EXP:cpVazio% //alterado por luiz henrique 01/08/2012 para mostrar resultados de acordo com o RFAT004
		order by C6_ITEM 

	EndSql

Return(clAliasSql)    

Static Function FPVDSQLTOT()
	Local clAliasSql := GetNextAlias()

	BeginSql Alias clAliasSql    
	  
		select SUM(C6_VALOR) as TOTAL from %Table:SC6% SC6
		where C6_FILIAL=%EXP:cFilAnt% AND SC6.%NotDel% AND C6_NUM=%EXP:clNumPed% AND C6_NOTA=%EXP:cpVazio% 
		
	EndSql

Return(clAliasSql)    

Static Function FPVDSQLLOG()
	Local clAliasSql := GetNextAlias()

	BeginSql Alias clAliasSql    
	  
		select COUNT(*) as REG from %Table:SZ4% SZ4
		where Z4_FILIAL=%EXP:cFilAnt% AND %NotDel% AND Z4_PEDIDO=%EXP:clNumPed% AND Z4_ITEM=%EXP:clNumIt%
		
	EndSql

Return(clAliasSql)       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTK260ROT  บAutor  ณMicrosiga           บ Data ณ  08/23/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia o email para os responsaveis.                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*Static Function EnviaEmail()

	Local l_Continua	:= .T.
	Private c_msgerro	:= ''
 	Private c_para		:= GetMV("MV_XMAILPV")  
 	Private c_paradir   := GetMV("MV_XMAILDR")

	//If !U_FGEN010(c_para,c_assunto,_cHTML,,.t.)	
	If !U_FGEN010(c_paradir+";"+cMailAdd,c_assunto,_cHTML,,.t.)
		Return c_msgerro
	EndIf 
	
	If !U_FGEN010(c_paradir,c_assunto,_cHTML,,.t.)	
		Return c_msgerro
	EndIf

Return  */

Static Function EnviaEmail()

	Local l_Continua	:= .T.
	Private c_msgerro	:= ''
 	Private c_para		:= GetMV("MV_XMAILPV")  
 	Private c_paradir   := GetMV("MV_XMAILDR")   
 	Private c_assunto := 'Saldos a Faturar - ' + CFILANT 
 	
 	//solicitado que fosse enviado ao george pelo Artur e Fabio [Mauro Nagata, Actual Trend, 20180524]
	//cMailAdd := "george@playpiso.com.br"      
	//substituido linha acima pela abaixo [Mauro Nagata, Actual Trend, 20180827]
	cMailAdd := "comercial@playpiso.com.br;armando@playpiso.com.br;thiago.rufino@actualtrend.com.br"
   //cMailAdd := "thiago.rufino@actualtrend.com.br" 
	If !U_FGEN010(c_paradir+";"+cMailAdd,c_assunto,_cHTML,,.t.)	 
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
