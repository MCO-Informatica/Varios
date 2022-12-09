#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"          
#include 'protheus.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZCVR014  บAutor  ณMicrosiga           บ Data ณ  02/28/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio de email dos produtos com                            บฑฑ
ฑฑบ          ณ validade menor ou igual a 60 dias                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


user Function PZCVR014()     

	// Local aItem		:= {}
	// Local _aProd  := {}
	// Variaveis para envio do email.
	Local _cRemet   := ''
	Local _cDest    := ''
	Local _cAssunto := ''
	// Local _cMsg     := ''
	Local _aAnexos  := {}
	Local _cPasta   := ''
	Local nQtdDias	:= 60
	Local nQtdLinhas := 0
	Local cArmzNCons	:= ""

	RpcSetType(3) // Nao utiliza licenca.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Abertura do ambiente                                         |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST"   
	
	cArmzNCons := U_MyNewSX6("CV_NAOCARM", ""	,"C","Armazens nใo considerados no relat๓rio", "", "", .F. )

    // Variaveis para envio do email.
    _cRemet	  := Trim(GetMV("MV_RELACNT"))	
    _cDest    := (SuperGetMv('MV_EMLGVCT',, 'daniel@newbridge.srv.br'))+';daniel@newbridge.srv.br'
    // _cDest:= 'denis.varella@newbridge.srv.br'
    _cAssunto := 'ALERTA | Produtos a vencer nos pr๓ximos '+cValtoChar(nQtdDias)+' Dias - Prozyn ' + DToC(dDataBase)

    // Variaveis para filtro na queries
    _dtAlter := DTOS(dDataBase)  // '20180730'   
    _dtLimit:= DTOS(dDataBase+nQtdDias)


	 _cQry := "SELECT  B8_PRODUTO COD, B1_UM UM, B1_TIPO TIPO, B1_DESC DESC1,  B8_LOCAL ARMZ,  
	 _cQry += " BF_EMPENHO EMP, BF_QUANT SLD,  B8_DATA DATA,  B8_DTVALID DTVALID, (GETDATE()  + "+cValtoChar(nQtdDias)+" )as DTLIMITE,  B8_LOTECTL LOTE, BF_LOCALIZ ENDER, DATEDIFF ( DD , (GETDATE()  + 60 ), B8_DTVALID  ) + 60 as dif
	 _cQry += " FROM SBF010 BF  
	 _cQry += " LEFT JOIN SB8010 B8 ON 
	 _cQry += " B8_PRODUTO = BF_PRODUTO AND
	 _cQry += " B8_LOTECTL = BF_LOTECTL AND
	 _cQry += " B8_LOCAL  = BF_LOCAL
	 _cQry += " INNER JOIN SB2010 B2 ON   
	 _cQry += " B2_COD = B8_PRODUTO AND   
	 _cQry += " B2_LOCAL = B8_LOCAL AND   
	 _cQry += " B8_SALDO <> 0 AND   
	 _cQry += " B8_EMPENHO = 0 AND  
	 _cQry += " B8.D_E_L_E_T_ = '' AND  
	 _cQry += " B2.D_E_L_E_T_<> '*'   
	 _cQry += " INNER JOIN SB1010 B1 ON   
	 _cQry += " B8_PRODUTO = B1_COD AND  
	 _cQry += " B1.D_E_L_E_T_<> '*' 
	 _cQry += " WHERE     
     _cQry += " B8_DTVALID <= (GETDATE()  + 60) AND  
	 _cQry += " B8_LOCAL NOT IN ('97','10') AND  
     _cQry += " (B1_MSBLQL = '2' OR B1_MSBLQL = ' ' )  
	 _cQry += " Order by dif 

dbUseArea( .T., "TopConn", TCGenQry(,,_cQry), "QRYP", .F., .F. )

nQtdLinhas := Contar("QRYP","!Eof()")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ - CABECALHO Estrutura do produto             -ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cHtml := '<!--mstheme-->'
cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><span style="font-family: trebuchet ms, arial, helvetica;"> <br /> <big> </big> <big> </big> <span style="font-family: Arial;"> <br /> </span> </span></span></p>'
cStyle := "margin-left: 40px;"
cHtml += '<div style="'+cStyle+' text-align: justify;"> Prezados(as).&nbsp;</div>'
cHtml += '<div style="'+cStyle+'">&nbsp;</div>'
cHtml += '<div style="'+cStyle+' text-align: justify;"> Os Produtos abaixo entraram no limite estipulado para tratativa do prazo de validade igual ou inferior a 60 dias.&nbsp;</div>'
cHtml += '<div style="'+cStyle+'">&nbsp;</div>'
cHtml += '<div style="'+cStyle+'"><span style="font-family: Arial;"><strong>ALERTA DE PRODUTOS COM VALIDADE IGUAL OU INFERIOR A 60 DIAS.</strong></span></div>'
cHtml += '<div style="'+cStyle+'">&nbsp;</div>'
cHtml += '<div style="'+cStyle+'"><span style="font-family: Arial;"><strong>Qtd. Linhas: '+cValtoChar(nQtdLinhas)+'</strong></span></div>'
cHtml += '<div style="'+cStyle+'">&nbsp;</div>'
cHtml += '<div style="'+cStyle+'"><span style="font-family: Arial;"><strong>Data de Execu&ccedil;&atilde;o da Verifica&ccedil;&atilde;o: '+ DTOC(STOD(_dtAlter)) +'</strong></span></div>'
cHtml += '<div style="'+cStyle+'">&nbsp;</div>'
cHtml += '<div style="'+cStyle+'"><span style="font-family: Arial;"><strong>Data Limite de Vencimento (DT Verifica&ccedil;&atilde;o + 60 dias): '+ DTOC(STOD(_dtLimit)) +'</strong></span></div>'
cHtml += '<div style="'+cStyle+'">&nbsp;</div>'
cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><!--mstheme--></span></p>'
cHtml += '<table style="text-align: left; height: 50px; margin-left: 40px; width: 920px;" border="1" cellspacing="0" cellpadding="1">'
cHtml += '<tbody>'
cHtml += '<tr>'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CABECALHO DOS ITENS MODIFICADOS NA ESTRUTURA  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cStyle := "background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px;"
cHtml += '<th style="'+cStyle+' width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Data Entrada&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Prod Principal&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 20px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Unid&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 20px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Tipo&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 250px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Descricao&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 20px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Arm&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 80px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Quant&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 80px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Lote&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Endereco&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;DtValidade&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="'+cStyle+' width: 80px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Dias ate Vencimento&nbsp;</small><!--mstheme--></span></th>'
cHtml += '</tr>'

 
If Select("QRYP") > 0
   	QRYP->(dbGoTop())
	While QRYP->(!Eof())


		cHtml += '<tr>'
        cHtml += ' <td style="text-align: center; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+DTOC(DaySub(STOD(QRYP->DTVALID),nQtdDias))+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: center; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->COD+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: center; font-family: Arial; width: 20px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->UM+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: center; font-family: Arial; width: 20px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->TIPO+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: center; font-family: Arial; width: 250px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->DESC1+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: center; font-family: Arial; width: 20px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->ARMZ+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: right; font-family: Arial; width:  80px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+Transform(QRYP->SLD,"@E 999,999.999")+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: center; font-family: Arial; width: 80px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->LOTE+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: center; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->ENDER+'</small><!--mstheme--></span></td>'
        cHtml += ' <td style="text-align: center; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+DTOC(STOD(QRYP->DTVALID))+'</small><!--mstheme--></span></td>'
        cHtml += ' <td style="text-align: right; font-family: Arial; width: 80px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+Transform(QRYP->dif,"@E 99999")+'</small><!--mstheme--></span></td>'
        cHtml += '</tr>'
	
	QRYP->( dbSkip() )
	Enddo


    cHtml += '</tbody>'
    cHtml += '</table>'
    cHtml += '<p>&nbsp;</p>'

    U_ENVMAIL(_cRemet, _cDest, _cAssunto, cHtml, _aAnexos, _cPasta)    
    
Endif
 QRYP->( DbCloseArea() )
        
	
//MsgAlert('E-Mail de Log de Estrutura Enviado com Sucesso.')		

RESET ENVIRONMENT

Return


