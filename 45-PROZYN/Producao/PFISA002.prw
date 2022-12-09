#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFISA002  บ Autor ณ Ellen Santiago     บ Data ณ   30/08/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Compara Divergencias entre Item do PV e Tabelas de Pre็o   บฑฑ
ฑฑบ          ณ ap๓s Calculo do FCI  - Envio de Email no formato tabela    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ponto de entrada ap๓s execu็ใo do FCI                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function PFISA002

Local CR       	:= Chr(13)+Chr(10)
Local aFil     	:= {'01'}
Local nFil     	:= 1 
Local _cRemet  	:= ''
Local _cDest   	:= ''
Local _cAssunto	:= ''
Local _cMsg   	:= ''
Local _aAnexos	:= {}
Local _cPasta 	:= ''
Local _dtInicio	:= ''
Local _nC      	:= 0
Local cHtml    	:= ''

// Variaveis para envio do email.
_cRemet	  := Trim(GetMV("MV_RELACNT"))	
_cDest    := SuperGetMv('MV_EMAIFCI',, 'daniel@newbridge.srv.br;osmair.stellzer@newbridge.srv.br')
_cAssunto := 'FCI | Itens no Pedido de Vendas e Tabelas de Pre็o com Diverg๊ncia ' + DToC(dDataBase)

// Variaveis para filtro na queries
_dtInicio := DTOS(dDataBase)  // '20180730'   
_cExcCfopE :=Trim(GetMV("MV_FCIVE",, '5551'))   // CFOP INTERESTADUAIS A EXCLUIR DA COMPARAวรO       
_cExcCfopI :=Trim(GetMV("MV_FCIVI",, '5551')) 	// CFOP INTRAESTADUAIS A EXCLUIR DA COMPARAวรO 
 
// Compara็ใo dos itens da tabela CFD com os itens dos pedidos para identificar as divergencias
                                              
cQueryP	:="SELECT C6_NUM, C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_PRCVEN, C6_TES, C6_CF, C6_CLI, A1_NREDUZ, C5_FECENT, CFD_PERCAL, " + CR 
cQueryP	+=" C5_VEND1, (SELECT A3_NOME FROM SA3010 WHERE A3_COD = C5_VEND1 ) VENDEDOR, C5_USUARIO " + CR 
cQueryP	+=" FROM " + RetSqlName("SC6") + " C6 " + CR  
cQueryP	+=" INNER JOIN " + RetSqlName("SA1") + " A1  ON " + CR  
cQueryP	+=" A1_COD = C6_CLI AND A1_LOJA  = C6_LOJA AND A1.D_E_L_E_T_<> '*'  " + CR   
cQueryP	+=" INNER JOIN " + RetSqlName("SC5") + " C5 ON C5_NUM = C6_NUM AND C5.D_E_L_E_T_<> '*' " + CR   
cQueryP	+="	INNER JOIN " + RetSqlName("CFD") + " FD ON " + CR  
cQueryP	+=" CFD_PERCAL = SUBSTRING('"+_dtInicio+"',5,2)+SUBSTRING('"+_dtInicio+"',1,4) AND  " + CR  
cQueryP	+=" C6_PRODUTO = CFD_COD AND " + CR  
cQueryP	+=" CFD_FCICOD <> C6_FCICOD AND " + CR  
cQueryP	+=" FD.D_E_L_E_T_<> '*' " + CR  
cQueryP	+=" WHERE " + CR  
cQueryP	+=" C6_QTDENT <> C6_QTDVEN and  " + CR
cQueryP	+=" C6_NOTA = '' AND " + CR
cQueryP +=" C6_CF IN (" +_cExcCfopE+_cExcCfopI+ ") AND " + CR
cQueryP	+=" C6.D_E_L_E_T_<> '*' AND " + CR   
cQueryP	+=" C6.C6_BLQ <> 'R' " + CR   
cQueryP	+=" ORDER BY C5_FECENT  " + CR  



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ - CABECALHO PRIMEIRA TABELA PEDIDOS DE VENDA -ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cHtml := '<!--mstheme-->'
cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><span style="font-family: trebuchet ms, arial, helvetica;"> <br /> <big> </big> <big> </big> <span style="font-family: Arial;"> <br /> </span> </span></span></p>'
/*
cHtml += '<div style="margin-left: 40px; text-align: justify;"><strong>A rotina de atualiza&ccedil;&atilde;o da FCI - Ficha de Conte&uacute;do de importa&ccedil;&atilde;o foi executada.&nbsp;</strong></div>' 
cHtml += '<div style="margin-left: 40px; text-align: justify;"><strong>Segue abaixo a lista dos pedidos que cont&eacute;m produtos cujo o c&oacute;digo da FCI foi alterado.&nbsp;</strong></div>' 
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
*/
cHtml += '<div style="margin-left: 40px; text-align: justify;">A rotina de atualiza&ccedil;&atilde;o da FCI - Ficha de Conte&uacute;do de Importa&ccedil;&atilde;o foi executada.&nbsp;Segue abaixo a lista dos pedidos que cont&eacute;m produtos cujo o c&oacute;digo da FCI foi alterado.&nbsp;</div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
//cHtml += '<div style="margin-left: 40px;"><span style="font-family: Arial;"><strong>RELA&Ccedil;&Atilde;O DE ITENS COM DIVEG&Ecirc;NCIA NO PEDIDO DE VENDAS</strong></span></div>'
cHtml += '<div style="margin-left: 40px;"><span style="font-family: Arial;"><strong>PEDIDO DE VENDAS</strong></span></div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<div style="margin-left: 40px;"><span style="font-family: Arial;"><strong>Data de Gera&ccedil;&atilde;o FCI: '+ DTOC(STOD(_dtInicio)) +'</strong></span></div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><!--mstheme--></span></p>'
cHtml += '<table style="text-align: left; height: 50px; margin-left: 40px; width: 920px;" border="1" cellspacing="0" cellpadding="1">'
cHtml += '<tbody>'
cHtml += '<tr>'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CABECALHO DOS ITENS DIVERGENTES - PED. VENDA  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 43px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;PEDIDO&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;PREVIS&Atilde;O&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;PRODUTO&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 250px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;DESCRI&Ccedil;&Atilde;O&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 200px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;CLIENTE&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;COD.CLI&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;VENDEDOR&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 200px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;NOME VENDEDOR&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;USU&Aacute;RIO INCLUS&Atilde;O&nbsp;</small><!--mstheme--></span></th>'
cHtml += '</tr>'


If Select("QRYP") > 0
       QRYP->( dbCloseArea() )
EndIf  

dbUseArea( .T., "TopConn", TCGenQry(,,cQueryP), "QRYP", .F., .F. )
 
If Select("QRYP") > 0
   	QRYP->( dbGoTop() )
	While QRYP->( !Eof() )
	
		cHtml += '<tr>'
		cHtml += ' <td style="text-align: center; font-family: Arial;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+ QRYP->C6_NUM +'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>' + DTOC(STOD(QRYP->C5_FECENT)) +'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->C6_PRODUTO+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 288px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->C6_DESCRI+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 288px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->A1_NREDUZ+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 288px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->C6_CLI+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 288px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->C5_VEND1+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 288px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->VENDEDOR+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 70px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->C5_USUARIO+'</small><!--mstheme--></span></td>'
		cHtml += '</tr>'
	
	QRYP->( dbSkip() )
	Enddo
Endif		 
 
cHtml += '</tbody>'
cHtml += '</table>'
cHtml += '<p>&nbsp;</p>'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ -- QUERY QUE RETORNA OS ITENS DIVERGENTES ----ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQueryL	:=" SELECT DISTINCT DA1_CODTAB, DA0_DESCRI, DA1_CODPRO, B1_DESC, DA1_PRCVEN " + CR      
cQueryL	+=" FROM " + RetSqlName("DA1") + " DA1 " + CR  
cQueryL	+=" INNER JOIN " + RetSqlName("SB1") + " B1  ON " + CR 
cQueryL	+=" B1_COD  = DA1_CODPRO AND B1.D_E_L_E_T_<> '*'" + CR      
cQueryL	+=" INNER JOIN " + RetSqlName("DA0") + " DA0  ON " + CR 
cQueryL	+=" DA0_CODTAB = DA1_CODTAB AND DA0.D_E_L_E_T_<> '*'" + CR    
cQueryL	+=" WHERE" + CR   
cQueryL	+=" DA0_ATIVO <> '2' AND " + CR
cQueryL	+=" DA1_ATIVO <> '2' AND " + CR
cQueryL	+=" DA1.D_E_L_E_T_<> '*' AND " + CR
cQueryL	+=" DA1_CODPRO IN (SELECT DISTINCT C6_PRODUTO FROM " + RetSqlName("SC6") + " C6 " + CR
cQueryL	+=" INNER JOIN " + RetSqlName("SA1") + " A1  ON " + CR 
cQueryL	+=" A1_COD = C6_CLI AND A1_LOJA  = C6_LOJA AND A1.D_E_L_E_T_<> '*' " + CR  
cQueryL	+=" INNER JOIN " + RetSqlName("CFD") + " FD  ON " + CR 
cQueryL	+=" CFD_PERCAL = SUBSTRING('"+_dtInicio+"',5,2)+SUBSTRING('"+_dtInicio+"',1,4) AND  " + CR  
cQueryL	+=" C6_PRODUTO = CFD_COD AND " + CR
cQueryL	+=" CFD_FCICOD <> C6_FCICOD AND " + CR
cQueryL	+=" FD.D_E_L_E_T_<> '*' " + CR
cQueryL	+=" WHERE " + CR
cQueryL	+=" C6_QTDENT <> C6_QTDVEN AND " + CR
cQueryL	+=" C6_NOTA = '' AND " + CR
cQueryL +=" C6_CF IN (" +_cExcCfopE+_cExcCfopI+ ") AND " + CR
cQueryL	+=" C6.D_E_L_E_T_<> '*')" + CR

If Select("QRYL") > 0
	QRYL->( dbCloseArea() )
EndIf  

dbUseArea( .T., "TopConn", TCGenQry(,,cQueryL), "QRYL", .F., .F. ) 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ -- CABECALHO SEGUNDA TABELA - TAB DE PRECOS --ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><span style="font-family: trebuchet ms, arial, helvetica;"> <br /> <big> </big> <big> </big> <span style="font-family: Arial;"> <br /> </span> </span></span></p>'
cHtml += '<div style="margin-left: 40px;"><span style="font-family: Arial;"><strong>TABELA DE PRE&Ccedil;O</strong></span></div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<div style="margin-left: 40px;"><span style="font-family: Arial;"><strong>Data de Gera&ccedil;&atilde;o FCI: ' + DTOC(STOD(_dtInicio)) +'</strong></span></div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><!--mstheme--></span></p>'
cHtml += '<table style="text-align: left; height: 50px; margin-left: 40px; width: 920px;" border="1" cellspacing="0" cellpadding="1">'
cHtml += '<tbody>'
cHtml += '<tr>'



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CABECALHO DOS ITENS DIVERGENTES - TAB. PRECO  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 43px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;TABELA &nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;DESCRI&Ccedil;&Atilde;O TABELA&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;PRODUTO&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 250px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;DESCRI&Ccedil;&Atilde;O PRODUTO&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;PRE&Ccedil;O UNIT&Aacute;RIO&nbsp;</small><!--mstheme--></span></th>'
cHtml += '</tr>'


IF Select("QRYL") > 0
	QRYL->( dbGoTop() )
	While QRYL->( !Eof() )
		cHtml += '<tr>'
		cHtml += ' <td style="text-align: center; font-family: Arial;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+ QRYL->DA1_CODTAB +'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 288px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYL->DA0_DESCRI+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 60px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYL->DA1_CODPRO+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 288px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYL->B1_DESC+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: right; font-family: Arial;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+ ALLTRIM( Transform(QRYL->DA1_PRCVEN,"@E 999,999.99")) + ' </small></span></td>'
	QRYL->( dbSkip() )
	Enddo
Endif		 


U_ENVMAIL(_cRemet, _cDest, _cAssunto, cHtml, _aAnexos, _cPasta)            
	
MsgAlert('E-Mail de Diverg๊ncias Enviado com Sucesso.')	
					

Return