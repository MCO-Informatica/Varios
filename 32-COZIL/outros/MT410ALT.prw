
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |MT410ALT  ºAutor  ³William Luiz A. Gurzoni	³  04/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A cada alteracao do pedido de venda, envia um e-mail de    º±±
±±º          ³ alerta para o grupo "Pedidonovo@cozil.com.br"              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "protheus.ch"
#INCLUDE "Ap5Mail.ch"

User Function MT410ALT()
	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VARIAVEIS DO EMAIL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

	Local lPrimeira := .T. 
	Local cCodgHtml := ""
	Local cNomCliFo := ""
	Local lResultad := .F. 
	Local cTo		:= "pedidonovo@cozil.com.br"
	Local cSubject 	:= "[SISTEMA] - ALTERACAO DE PEDIDO" 
	Local cServer	:= GetMv("MV_RELSERV")
	Local cUser		:= GetMv("MV_RELACNT")
	Local cPassword	:= GetMv("MV_RELPSW")
	Local cPort		:= "587"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VARIAVEIS DO PEDIDO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

	Local cPedido	:= SC5->C5_NUM
	Local cCliente	:= SC5->C5_NOMCLI
	Local cEmissao	:= DtoC(SC5->C5_EMISSAO)
	Local cHoje		:= DtoC(date())
	Local cUsuario	:= ""
	Local cEmpresa	:= ""
	Local cObs		:= SC5->C5_XHISTOR  
	cSubject		+= " - " + cPedido	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³RECEBE VARIAVEIS DE LOGIN DE USUARIO E N. DA EMPRESA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cUsuario := UsrRetName( RetCodUsr() ) 
	
	Do Case 
		Case xEmpresa() == "01"
			cEmpresa := "Cozil Equipamentos Industriais"
		Case xEmpresa() == "02"
			cEmpresa := "Cozil Cozinhas Profissionais"
		Case xEmpresa() == "03"
			cEmpresa := "Cozilandia Equipamentos e Servicos"
	End Case
                                          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CRIA O HTML QUE SERA ENVIADO PARA O E-MAIL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cCodgHtml := '	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">	 '  
	cCodgHtml += '	<html xmlns="http://www.w3.org/1999/xhtml">	 '  
	cCodgHtml += '	<head>	 '  
	cCodgHtml += '	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />	 '  
	cCodgHtml += '	<title>Alteração de pedido</title>	 '  
	cCodgHtml += '	</head>	 '  
	cCodgHtml += '	<body style="font-family:Arial, Helvetica, sans-serif; font-size:20px; font-weight:400" topmargin="0">	 '  
	cCodgHtml += '	<table width="568" height="393" border="3" bordercolor="#000000" cellpadding="0" cellspacing="0"  align="center">	 '  
	cCodgHtml += '	<tr>	 '  
	cCodgHtml += '	<td height="99" align="center" bgcolor="#000000" style="color:#FFF; font-size:19px; font-weight:500;">	 '  
	cCodgHtml += '	<font style="font-size:35px; color:#FFF">ATEN&Ccedil;&Atilde;O</font>	 '  
	cCodgHtml += '	<BR /><br />	 '  
	cCodgHtml += '	ALTERA&Ccedil;&Atilde;O DO PEDIDO Nº ' + cPedido + '<br />	 '  
	cCodgHtml += '	<font style="font-size:8px; text-align:right;  color:#FFF">By Protheus 10</font>	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	</tr>	 '  
	cCodgHtml += '	<tr>	 '  
	cCodgHtml += '	<td height="54" align="center">	 '  
	cCodgHtml += '		O PEDIDO <b>Nº ' + cPedido + '</b> FOI ALTERADO NO SISTEMA.	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	</tr>	 '  
	cCodgHtml += '	<tr>	 '  
	cCodgHtml += '	<td height="46">	 '  
	cCodgHtml += '		&nbsp;EMPRESA: <u>' + cEmpresa + '</u>	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	</tr>	 '  
	cCodgHtml += '	<tr>	 '  
	cCodgHtml += '	<td height="149">	 '  
	cCodgHtml += '		<table width="555">	 '  
	cCodgHtml += '		<tr>	 '  
	cCodgHtml += '		<td width="168">	 '  
	cCodgHtml += '		&nbsp;CLIENTE:	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	<td width="375">' + cCliente + '	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	</tr>	 '  
	cCodgHtml += '	<tr>	 '  
	cCodgHtml += '		<td>	 '  
	cCodgHtml += '		&nbsp;EMISS&Atilde;O:	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	<td>' + cEmissao + '	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	</tr>	 '  
	cCodgHtml += '	<tr>	 '  
	cCodgHtml += '		<td>	 '  
	cCodgHtml += '		&nbsp;ALTERADO EM:	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	<td>' + cHoje + '</td>	 '  
	cCodgHtml += '	</tr>	 '  
	cCodgHtml += '	<tr>	 '  
	cCodgHtml += '		<td>	 '  
	cCodgHtml += '		&nbsp;ALTERADO POR:	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	<td>' + cUsuario + '	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	</tr>	 '
	cCodgHtml += '	</table>	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	</tr>	 '
	cCodgHtml += '	<tr>	 '	
	cCodgHtml += '		<td style="padding-left:7px">	 '
	cCodgHtml += '	<b>OBSERVAÇÕES:</b><BR><BR>	 '
	cCodgHtml += '	' + cObs + '	 '	
	cCodgHtml += '		</td>	 '
	cCodgHtml += '	</tr>	 '   
	cCodgHtml += '	<tr>	 '  
	cCodgHtml += '	<td align="center">	 '  
	cCodgHtml += '		<font size="2"><i>PARA MAIORES INFORMA&Ccedil;&Otilde;ES ACESSE O SISTEMA.</i></font>	 '  
	cCodgHtml += '	</td>	 '  
	cCodgHtml += '	</tr>	 '  
	cCodgHtml += '	</table>	 '  
	cCodgHtml += '	</body>	 '  
	cCodgHtml += '	</html>	 '  
	
//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³ENVIA EMAIL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ                  
	If AllTrim(cUsuario) != 'Administrador' .And. AllTrim(cUsuario) != 'daniela.frota' .And. AllTrim(cUsuario) != 'crislaine.ferreira' .And. AllTrim(cUsuario) != 'tatiane.tamie'
		U_EnviaEmail(cServer, cPort, cUser, cUser, cPassword, .T., 30, cTo, "", "", cSubject, cCodgHtml)    
	EndIF
		
Return