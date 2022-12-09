#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT120GRV
Ponto de entrada para envio de e-mail para os solicitante informando que o pedido foi gerado ou excluido
@author  weskley.silva
@since   09/01/2020
@version 1.0
/*/
//-------------------------------------------------------------------

User Function MT120GRV()

Local xInclui  := PARAMIXB[2]
Local xExclui  := PARAMIXB[4] 
Local cNum     := PARAMIXB[1]
Local cEmail   := "" 
Local cFornece := ""
Local cLoja    := ""
Local cData 
Local cStatus 
Local cQuery  := " "
Local lEmail
Local cTempAlias := GetNextAlias()
Local cNumSC := " "
Local nX
Local aAttach := {}
Local cAssunto := ""


nPosSC := GDFIELDPOS("C7_NUMSC")


For nX := 1 to Len(acols)
	cNumSC += "'"+acols[nX][nPosSC]+"',"
Next nX

cNumSC := SubStr(cNumSC,1,Len(cNumSC)-1)

cQuery := " SELECT C1_NUM,C1_USER FROM "+RetSqlName("SC1")+" SC1 WHERE SC1.D_E_L_E_T_ <> '*' AND SC1.C1_NUM IN ("+cNumSC+") AND C1_FILIAL = '"+xFilial("SC1")+"' GROUP BY C1_USER,C1_NUM "

dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)


cFornece := Posicione("SA2",1,xFilial("SA2")+CA120FORN,"A2_NREDUZ")
cLoja := CA120LOJ
cData := DTOC(DA120EMIS)

While !(cTempAlias)->(EOF())

	cEmail  := alltrim(UsrRetMail((cTempAlias)->C1_USER))

	IF xInclui

		cAssunto := "Pedido de compra Gerado " + ALLTRIM(cNum)
		cTextoEmail := SSCAprov(cNum,cFornece,cLoja,cData,"GERADO",(cTempAlias)->C1_NUM)
		lEmail := U_ENVMAILIMCD(cEmail," "," ",cAssunto,cTextoEmail,aAttach)

	elseif xExclui

		cAssunto := "Pedido de compra Excluido " + ALLTRIM(cNum)
		cTextoEmail := SSCAprov(cNum,cFornece,cLoja,cData,"EXCLUIDO",(cTempAlias)->C1_NUM)
		lEmail := U_ENVMAILIMCD(cEmail," "," ",cAssunto,cTextoEmail,aAttach)

	ENDIF

	If !lEmail
		MsgInfo("E-mail não enviado referente a SC "+(cTempAlias)->C1_NUM+"  ","IMCD")						
	Endif
(cTempAlias)->(DbSkip())  
enddo				

return 

Static Function SSCAprov(cNum,cFornece,cLoja,cData,cStatus,cNumSC)

Local cMensagem := ' '
Local nX
Local nTotal  := 0
Local nVlRTotal := 0
Local cForn :=  CA120FORN+" - "+Alltrim(cFornece)+" / "+Alltrim(cLoja) 
Local cEmpresa := SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+ALLTRIM(SM0->M0_NOME)+" - "+ALLTRIM(SM0->M0_FILIAL )
Local cLogo := 'https://www.imcdgroup.com/-/media/imcd/to-be-ordered/imcd-logo-2015_color_cmyk_300dpi_10cm/imcd-logo-2015_color_rgb_72dpi_250px.jpg'

cMensagem :='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem +='<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem +='<head>'
cMensagem +='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMensagem +='</head>'
cMensagem +='<body>'
cMensagem +='<style>'
cMensagem +='div.a {'
cMensagem +='	text-align: center;'
cMensagem +='}'
cMensagem +='</style>'
cMensagem +='<div class ="a">'
cMensagem +='	<h1><center>PEDIDO DE COMPRA '+Alltrim(cStatus)+'</center></h1>'
cMensagem +='</div>'
cMensagem +='<img src="'+cLogo+'"/></br>'
cMensagem +='</br>'
cMensagem +='<p>Pedido :<strong>'+Alltrim(cNum)+'</strong></p>'
cMensagem +='<p>Fornecedor/Loja : <strong>'+Alltrim(cForn)+'</strong></p>'
cMensagem +='<p>Emissão: <strong>'+cData+'</strong></p>'
cMensagem +='<p>N° SCs: <strong>'+Alltrim(cNumSC)+'</strong></p></br>'

cMensagem +='<table border="2">'
cMensagem +='<tbody>'
cMensagem +='<tr>'
cMensagem +='<td style="width: 40px;"><span style="color: #0000ff;"><strong>Item</strong></span></td>'
cMensagem +='<td style="width: 100px;"><span style="color: #0000ff;"><strong>Produto</strong></span></td>'
cMensagem +='<td style="width: 250px;"><span style="color: #0000ff;"><strong>Descri&ccedil;&atilde;o</strong></span></td>'
cMensagem +='<td style="width: 075px;"><span style="color: #0000ff;"><strong>Qtd</strong></span></td>'
cMensagem +='<td style="width: 100px;"><span style="color: #0000ff;"><strong>Preco Unit</strong></span></td>'
cMensagem +='<td style="width: 150px;"><span style="color: #0000ff;"><strong>Total</strong></span></td>'
cMensagem +='</tr>'

For nX := 1 To Len(aCOLS)
 	nVlRTotal := aCOLS[nX , GDFieldPos( 'C7_TOTAL', aHeader)] 
	cMensagem += '<tr>'
	cMensagem += '<td style="width: 150px;">'+aCOLS[nX , GDFieldPos( 'C7_ITEM', aHeader)]+'</td>'
	cMensagem += '<td style="width: 250px;">'+ALLTRIM(	aCOLS[nX , GDFieldPos( 'C7_PRODUTO', aHeader)] ) +'</td>'
	cMensagem += '<td style="width: 075px;">'+ALLTRIM(aCOLS[nX , GDFieldPos( 'C7_DESCRI', aHeader)] )+'</td>'
	cMensagem += '<td style="width: 100px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C7_QUANT', aHeader)] 	,"@E 9,999,999.9999")+'</td>'
	cMensagem += '<td style="width: 150px;">'+TRANSFORM(aCOLS[nX , GDFieldPos( 'C7_PRECO' , aHeader)] 	,"@E 9,999,999.9999")+'</td>'
	cMensagem += '<td style="width: 075px;">'+TRANSFORM( nVlRTotal ,"@E 9,999,999.9999")+'</td>'
	cMensagem += '</tr>'
	//Totalizador 
	nTotal += nVlRTotal

Next nX

cMensagem +='</tbody>'
cMensagem +='</table>'
cMensagem +='</br>'
cMensagem +='</BR><p>VALOR TOTAL: <strong>'+TRANSFORM(nTotal,"@E 9,999,999.9999")+'</strong></p>
cMensagem +='<p>EMPRESA :<strong>'+ cEmpresa + '</strong></p>'
cMensagem +='</body>'
cMensagem +='</html>'

Return(cMensagem)
