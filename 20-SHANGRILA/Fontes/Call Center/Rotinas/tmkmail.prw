#Include "RwMake.Ch"       
#INCLUDE "ap5mail.ch"   
#Define CRLF CHR(13)+CHR(10)

//========================================================================================================================================================
//Nelson Hammel - 20/10/11 - Enviar email quando rotina bloqueada
//========================================================================================================================================================

User Function TMKMAIL()       


       
//===========================
//Cabeçalho
Local cMensag 		:= ""
//Local CRLF    	:= Chr(13) + Chr(10)   
Local cNumPed 		:= M->UA_NUM
Local cTabela 		:= M->UA_TABELA
//Local cStatus 	:= If(M->UA_BLQ=='1',"BLOQUEADO POR REGRA","BLOQUEADO POR VERBA")       
Local xStatus		:="COD BLOQUEIOS:"
Local cStatus		:="DEFINIR"
Local cCondPg 		:= M->UA_CONDPAG
Local dDataEm 		:= DTOC(M->UA_EMISSAO) + Space(5) + Substr(Time(),1,5)
Local cRegra  		:= TRANSFORM(M->UA_X_CODRE,"@R 99/999")
Local cUser   		:= M->UA_USERINC
Local cFrete  		:= If(M->UA_TPFRETE=='C',"CIF",If(M->UA_TPFRETE=='F',"FOB",""))
Local cCodCli 		:= M->UA_CLIENTE
Local cLojCli 		:= M->UA_LOJA
Local cNomeCli		:= Alltrim(M->UA_NOMCLI)
Local cEndCli 		:= Alltrim(Posicione("SA1",1,xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA),"A1_END"))
Local cBaiCli 		:= Alltrim(Posicione("SA1",1,xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA),"A1_BAIRRO"))
Local cCidCli 		:= Alltrim(Posicione("SA1",1,xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA),"A1_MUN"))
Local cEstCli		:= Alltrim(Posicione("SA1",1,xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA),"A1_EST"))     
Local cNomVend		:= Alltrim(Posicione("SA3",1,xFilial("SA3")+M->UA_VEND,"A3_NOME"))

//===========================
//Itens
Local nPosProd  	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})
Local nPosUM    	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_UM"}) 
//Local nPosDescr 	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESCRI"}) 
Local nPosQtdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_QUANT"})
Local nPosPrcVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VRUNIT"})
Local nPosPrcLst	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRCTAB"}) 
Local nPosValor 	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"})
Local nPosDesCon	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESC"}) //Desconto Concedido no Item
Local nPosDesMax	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESCMAX"}) //Desconto Maximo permitido pela regra
Local nPosComis1	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_COMIS1"}) 
//Local nPosComis2	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_COMIS2"}) 
Local nPosValDes	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VALDESC"})
Local nMotBlok2		:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK2"})
Local nMotBlok3		:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK3"})
Local nMotBlok4		:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK4"})
Local nTotalPV 		:= 0
Local nTotalDC 		:= 0
Local nTotalDM 		:= 0
Local xForaDesc      :=""

Local xBloq			:= ""
//=====================================
//Adequações diversas
If M->UA_1OPER=="2"
xTxtOper:="Orçamento No"
ElseIf M->UA_1OPER=="1"
xTxtOper:="Pedido de Venda No"
EndIf

Do Case
	Case Alltrim(M->UA_MTBLOK1)=="X" //Valor de faturamento é menor que o mínimo estabelecido. Orçamento bloqueado.
	xStatus += " 1 "
	Case Alltrim(M->UA_MTBLOK2)=="X" //Desconto concedido acima do máximo permitido. Orçamento bloqueado
	xForaDesc:="1"
	xStatus += " ,2 "
	xBloq += "2"
	Case Alltrim(M->UA_MTBLOK3)=="X" //Valor do produto abaixo do custo. Orçamento bloqueado
	xStatus += " ,3 "
	xBloq += "3"
	Case Alltrim(M->UA_MTBLOK4)=="X" //Prazo médio da condição de pagamento maior que o estabelecido. Orçamento bloqueado
	xStatus += " ,4 "                
	xBloq += "4"
	Case Alltrim(M->UA_MTBLOK5)=="X" //Condição não informada. Orçamento bloqueado
	xStatus += " ,5 "                
	xBloq += "5"
EndCase
/* 
-------------
Mensagem
-------------*/
cMensag  += '<html>' + CRLF
cMensag  += '<body>'
/**/
cMensag  += '<table border="1" width="100%" id="table1" style="border-collapse: collapse">'
cMensag  += '	<tr>' 
cMensag  += '		<td width="135" rowspan="4" style="border-top-color: #C0C0C0; border-top-width: 1px; border-bottom-color: #808080; border-bottom-width: 1px"> '
cMensag  += '		<img border="0" src="http://www.gruposhangrila.com.br/images/__logos/'+ cEmpAnt +'.jpg" width="120" height="40"></td> '
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF" style="border-top-color: #C0C0C0; border-top-width: 1px"> '
cMensag  += '		<div style="background-color: #0066CC"> '
cMensag  += '			<b><font face="Tahoma" size="2" color="#FFFFFF">'+xTxtOper+'</font></b></div> '
cMensag  += '		</td> '
cMensag  += '		<td bgcolor="#9999FF" width="371" style="border-top-color: #C0C0C0; border-top-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2">'+ cNumPed +'</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="130" align="left" style="border-style: solid; border-width: 1px"> '
cMensag  += '		<b><font size="2" face="Tahoma" color="#0000FF">Tabela</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" style="border-style: solid; border-width: 1px"><b> '
If Alltrim(cTabela) == '1N'
	cMensag  += '		<font face="Tahoma" size="2">'+cTabela+'</font></b></td> '
Else
	cMensag  += '		<font face="Tahoma" size="2" color="#FF0000">'+cTabela+'</font></b></td> '
EndIf
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF"><b> '
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Status</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="371"><b><font face="Tahoma" size="2">'+ xStatus +'</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="130" align="left" style="border-style: solid; border-width: 1px"> '
cMensag  += '		<b><font size="2" face="Tahoma" color="#0000FF">Cond. Pagto</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" style="border-style: solid; border-width: 1px"><b> '
cMensag  += '		<font face="Tahoma" size="2">'+cCondPg+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF"><b> '
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Emissão</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="371"><b><font face="Tahoma" size="2"> '+dDataEm+'</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="130" align="left" style="border-style: solid; border-width: 1px"> '
cMensag  += '		<b><font size="2" face="Tahoma" color="#0000FF">Regra Desconto</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" style="border-style: solid; border-width: 1px"><b> '
cMensag  += '		<font face="Tahoma" size="2">'+cRegra+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF" style="border-bottom-color: #808080; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Responsável</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="371" style="border-bottom-color: #808080; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2">'+cUser+'</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" width="130" align="left" style="border-style: solid; border-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Frete</font></b></td> '
cMensag  += '		<td bgcolor="#9999FF" style="border-style: solid; border-width: 1px"><b> '
cMensag  += '		<font face="Tahoma" size="2">'+cFrete+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr>'
cMensag  += '		<td width="133" align="left" bgcolor="#9999FF" style="border-style:solid; border-width:1px; ">'
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Vendedor</font></b></td>'
cMensag  += '		<td bgcolor="#9999FF" style="border-style:solid; border-width:1px; " colspan="3">'
cMensag  += '		<b><font face="Tahoma" size="2">'+cNomVend+'</font></b></td>'
cMensag  += '	</tr>'+ CRLF
cMensag  += '</table> '
/**/
cMensag  += '<table border="1" width="100%" style="border-collapse: collapse; border-top-width: 0px" id="table2"> '
cMensag  += '	<tr> '
cMensag  += '		<td colspan="6" align="left" bgcolor="#0066CC" style="border-left: 1px solid #C0C0C0; border-right: 1px solid #808080; border-top: 1px solid #C0C0C0; border-bottom-style: solid; border-bottom-width: 1px" height="26"> '
cMensag  += '		<p align="center"><b><font face="Tahoma" color="#FFFFFF" size="2">Cliente</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '    
cMensag  += '		<td width="14%" style="border-left: 1px solid #C0C0C0; border-right-style: solid; border-right-width: 1px; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Razão Social</font></td> '
cMensag  += '		<td width="86%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-bottom-style: solid; border-bottom-width: 1px" colspan="5" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cNomeCli+'</font></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="14%" style="border-left: 1px solid #C0C0C0; border-right-style: solid; border-right-width: 1px; border-top-style: solid; border-top-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font size="2" face="Tahoma" color="#0000FF">Endereço</font></td> '
cMensag  += '		<td width="86%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" colspan="5" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cEndCli+'</font></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="14%" style="border-left: 1px solid #C0C0C0; border-right-style: solid; border-right-width: 1px; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font size="2" face="Tahoma" color="#0000FF">Bairro</font></td> '
cMensag  += '		<td width="20%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cBaiCli+'</font></td> '
cMensag  += '		<td width="8%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<p align="center"><font size="2" face="Tahoma" color="#0000FF">Cidade</font></td> '
cMensag  += '		<td width="38%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cCidCli+'</font></td> '
cMensag  += '		<td width="6%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<p align="center"><font size="2" face="Tahoma" color="#0000FF">Estado</font></td> '
cMensag  += '		<td width="12%" style="border-left-style: solid; border-left-width: 1px; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" bgcolor="#9999FF"> '
cMensag  += '		<font face="Tahoma" size="2">'+cEstCli+'</font></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr>'
cMensag  += '		<td colspan="6" align="left" bgcolor="#0066CC" style="border-left: 1px solid #C0C0C0; border-right: 1px solid #808080; border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px" height="28">'
cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#FFFFFF">Itens '
cMensag  += '		do Pedido de Venda</font></b></td>'
cMensag  += '	</tr>' + CRLF
/**/
cMensag  += '<table border="1" width="100%" style="border-collapse: collapse" id="table3">'
cMensag  += '	<tr>'
cMensag  += '		<td width="3%" bgcolor="#9999FF"><b>
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">item</font></b></td>'
cMensag  += '		<td width="11%" bgcolor="#9999FF">'

cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#0000FF">Código</font></b></td>'
cMensag  += '		<td width="3%" align="center" bgcolor="#9999FF"><b>'

cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">UM</font></b></td>'
cMensag  += '		<td width="23%" bgcolor="#9999FF"><b>'

cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Descrição</font></b></td>'
cMensag  += '		<td width="8%" bgcolor="#9999FF"><b>'

cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Quantidade</font></b></td>'
cMensag  += '		<td width="7%" align="center" bgcolor="#9999FF"><b>'

cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Preço Liq.</font></b></td>'
cMensag  += '		<td width="8%" align="center" bgcolor="#9999FF"><b>
cMensag  += '		<font face="Tahoma" size="2" color="#0000FF">Preço Lista</font></b></td>' 
cMensag  += '		<td width="8%" align="center" bgcolor="#9999FF"><b>'                      
cMensag  += '		<font size="2" face="Tahoma" color="#0000FF">Total R$</font></b></td>'
cMensag  += '		<td width="7%" bgcolor="#9999FF">'
cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#0000FF">% Desc.</font></b></td>'
cMensag  += '		<td width="9%" bgcolor="#9999FF">'
cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#0000FF">Desc.Max.</font></b></td>'
cMensag  += '		<td width="9%" align="center" bgcolor="#9999FF">'

cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#0000FF">Bloqueios</font></b></td>'
cMensag  += '		<td width="15%" align="center" bgcolor="#9999FF">'

cMensag  += '		<p align="center"><b><font face="Tahoma" size="2" color="#0000FF">% '
cMensag  += '		Com. Vend. 1</font></b></td>'
cMensag  += '	</tr>' + CRLF
/*
---------------------------------------
Impressao dos itens do Pedido de Venda
---------------------------------------*/
cCorLinha := "BR"		//background branco
For _nCnt := 1 To Len(Acols)
	If acols[_nCnt,Len(aCols[_nCnt])] == .F.		//Verifica se linha esta deletada
               
//==============================================================================================================================
//Adequações gerais
xDescProd:=Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[_nCnt,nPosProd],"B1_DESC"))

//If aCols[_nCnt,nMotBlok2] .Or. aCols[_nCnt,nMotBlok3] .Or. aCols[_nCnt,nMotBlok4]
//xBlokLin:=.T.
//Else
//xBlokLin:=.F.             
//EndIf

		If cCorLinha == 'BR'
			cMensag  += '	<tr>'
			cMensag  += '		<td width="3%"><font size="2" face="Tahoma">'+StrZero(_nCnt,2)+'</font></td>'
			cMensag  += '		<td width="11%"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosProd]+'</font></td>'
			cMensag  += '		<td width="3%" align="center"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosUM]+'</font></td>'
			cMensag  += '		<td width="23%"><font face="Tahoma" size="2">'+xDescProd+'</font></td>' 
			cMensag  += '		<td width="8%">'
			cMensag  += '		<p align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosQtdVen],"@E 999,999.999")+'</font></td>'
			cMensag  += '		<td width="7%" align="center"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosPrcVen],"@E 999.999")+'</font></td>'
			cMensag  += '		<td width="8%" align="center"><font size="2" face="Tahoma">'+Transform(aCols[_nCnt,nPosPrcLst],"@E 999.999")+'</font></td>'
			cMensag  += '		<td width="8%" align="center"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosValor],"@E 999,999.99")+'</font></td>'
		/*	------------------------------------------
			Identifica o item que bloqueou o PV
			------------------------------------------*/
//            If xForaDesc<>"1" .Or. !xBloq $ "1/2/3/4/5"
				cMensag  += '		<td width="7%" align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosDesCon],"@E 99.99")+'</font></td>'
//			Else
//				cMensag  += '		<td width="7%" align="right"><font face="Tahoma" size="2" color="#FF0000">'+Transform(aCols[_nCnt,nPosDesCon],"@E 99.99")+'</font></td>'
//			EndIf
			cMensag  += '		<td width="9%" align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosDesMax],"@E 99.99")+'</font></td>'
//Adicionado Coluna de Bloqueios			
			cMensag  += '		<td width="7%" align="right"><font face="Tahoma" size="2" color="#FF0000">'+Iif(!Empty(aCols[_nCnt,nMotBlok2]),"Por Regra/","")+Iif(!Empty(aCols[_nCnt,nMotBlok3]),"Por Custo/","")+Iif(!Empty(aCols[_nCnt,nMotBlok4]),"Por Prazo Medio","")+'</font></td>'
			
			cMensag  += '		<td width="11%" align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosComis1],"@E 99.99")+'</font></td>'
			cMensag  += '	</tr>' + CRLF

			cCorLinha := "AZ"		        
        Else     
			cMensag  += '	<tr>'
			cMensag  += '		<td width="3%" bgcolor="#9999FF"><font size="2" face="Tahoma">'+StrZero(_nCnt,2)+'</font></td>'
			cMensag  += '		<td width="11%" bgcolor="#9999FF"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosProd]+'</font></td>'
			cMensag  += '		<td width="3%" align="center" bgcolor="#9999FF"><font face="Tahoma" size="2">'+aCols[_nCnt,nPosUM]+'</font></td>'
			cMensag  += '		<td width="23%" bgcolor="#9999FF"><font face="Tahoma" size="2">'+xDescProd+'</font></td>'
			cMensag  += '		<td width="8%" bgcolor="#9999FF"><p align="right"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosQtdVen],"@E 999,999.999")+'</font></td>'
			cMensag  += '		<td width="7%" align="center" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosPrcVen],"@E 999.999")+'</font></td>' 
			cMensag  += '		<td width="8%" align="center" bgcolor="#9999FF"><font size="2" face="Tahoma">'+Transform(aCols[_nCnt,nPosPrcLst],"@E 999.999")+'</font></td>'
			cMensag  += '		<td width="8%" align="center" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosValor],"@E 999,999.99")+'</font></td>'
		/*	------------------------------------------
			Identifica o item que bloqueou o PV
			------------------------------------------*/
//            If xForaDesc<>"1" .Or. !xBloq $ "1/2/3/4/5"
 				cMensag  += '		<td width="7%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosDesCon],"@E 99.99")+'</font></td>'
// 			Else
//				cMensag  += '		<td width="7%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2" color="#FF0000">'+Transform(aCols[_nCnt,nPosDesCon],"@E 99.99")+'</font></td>'
//				cMensag  += '		<td width="7%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2" color="#FF0000">'+Iif(!Empty(aCols[_nCnt,nMotBlok2]),"Bloqueio por Regra","")+'</font></td>'
//				cMensag  += '		<td width="7%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2" color="#FF0000">'+Iif(!Empty(aCols[_nCnt,nMotBlok2]),"Bloqueio por Custo","")+'</font></td>'
//				cMensag  += '		<td width="7%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2" color="#FF0000">'+Iif(!Empty(aCols[_nCnt,nMotBlok2]),"Bloqueio por Prazo Medio","")+'</font></td>'
// 			EndIf		
			cMensag  += '		<td width="9%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosDesMax],"@E 99.99")+'</font></td>'

//Adicionado Coluna de Bloqueios			
			cMensag  += '		<td width="7%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2" color="#FF0000">'+Iif(!Empty(aCols[_nCnt,nMotBlok2]),"Por Regra/","")+Iif(!Empty(aCols[_nCnt,nMotBlok3]),"Por Custo/","")+Iif(!Empty(aCols[_nCnt,nMotBlok4]),"Por Prazo Medio","")+'</font></td>'

			cMensag  += '		<td width="11%" align="right" bgcolor="#9999FF"><font face="Tahoma" size="2">'+Transform(aCols[_nCnt,nPosComis1],"@E 99.99")+'</font></td>'
			cMensag  += '	</tr>' + CRLF

			cCorLinha := "BR"					
        EndIf
		nTotalPV += aCols[_nCnt,nPosValor]
		nTotalDC += aCols[_nCnt,nPosValDes]
		nTotalDM += 0
	EndIf
Next
/**/
cMensag  += '	<tr>'
cMensag  += '		<td colspan="11">&nbsp;</td>'
cMensag  += '	</tr>' + CRLF
cMensag  += '</table> '
/**/
cMensag  += '<table border="1" width="100%" style="border-collapse: collapse; border-left-width: 0px; border-right-width: 0px; border-top-width: 0px" id="table4"> '
cMensag  += '	<tr> '
cMensag  += '		<td width="620" align="right" bgcolor="#9999FF" style="border-right-style: none; border-right-width: medium; border-bottom-style: solid; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Total do Pedido R$</font></b></td> '
cMensag  += '		<td align="right" bgcolor="#9999FF" style="border-left-style: none; border-left-width: medium; border-bottom-style: solid; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">'+Transform(nTotalPV,"@E 999,999.99")+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '	<tr> '
cMensag  += '		<td width="620" align="right" bgcolor="#9999FF" style="border-left: 1px solid #C0C0C0; border-right-style: none; border-right-width: medium; border-bottom-style: solid; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">Desconto Concedido R$</font></b></td> '
cMensag  += '		<td align="right" bgcolor="#9999FF" style="border-left-style: none; border-left-width: medium; border-right: 1px solid #808080; border-bottom-style: solid; border-bottom-width: 1px"> '
cMensag  += '		<b><font face="Tahoma" size="2" color="#0000FF">'+Transform(nTotalDC,"@E 999,999.99")+'</font></b></td> '
cMensag  += '	</tr> ' + CRLF
cMensag  += '</table> '
cMensag += '</body>' + CRLF 
cMensag += '</html>' + CRLF 
/*
-----------------------------
Envia e-Mail
-----------------------------*/
U_SMTMK(cMensag)

Return


User Function SMTMK(xBody)

Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""
Local cTitulo  := "Pedido de Venda Bloqueado"
Local cServer  := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
Local cEmail   := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
Local cPass    := Trim(GetMV("MV_RELPSW"))  // 123abc

Local cDe      := Space(200)
Local cPara    := Space(200)
Local cCc      := Space(200)
Local cAssunto := Space(200)
Local cAnexo   := Space(200)
Local cMsg     := ""

Local _cUsr  := __cUSERID
Local _aUsr1 := {}
Local _aUsr2 := {}
Local _aUsr3 := {}

Local _eMailUsr  := ""
Local _eMailResp := SuperGetMV("MV_X_EMAIL")

If Empty(cServer) .And. Empty(cEmail) .And. Empty(cPass)
   MsgAlert("Não foi definido os parâmetros do server do Protheus para envio de e-mail",cTitulo)
   Return
Endif
/*
----------------------------
Identifica E_Mail do Usuario
----------------------------*/
PswOrder(1)

If PswSeek(_cUsr)
	_aUsr1 := PswRet(1)
	_aUsr2 := PswRet(2)
	_aUsr3 := PswRet(3)
Endif

_eMailUsr := _aUsr1[1,14]

cDe      := _eMailUsr		//	"microsiga@gruposhangrila.com.br"
cPara    :=  _eMailResp 		//	"microsiga@gruposhangrila.com.br"
//cCC      := //"achiles@gruposhangrila.com.br"  //"admin@gruposhangrila.com.br" // _eMailResp		
cAssunto := "Atendimento No. " + M->UA_NUM + " - BLOQUEADO"
cAnexo   := ""
cMsg     := xBody
/*
------------------------------
Conexao com Servidor de E-Mail
------------------------------*/
CONNECT SMTP SERVER cServer ACCOUNT cDe PASSWORD cPass RESULT lResulConn       //cEmail

If !lResulConn
   GET MAIL ERROR cError
   MsgAlert("Falha na conexão "+cError)
   Return(.F.)
Endif

// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
// Todos os e-mail terão: De, Para, Assunto e Mensagem, porém precisa analisar se tem: Com Cópia e/ou Anexo

If Empty(cCc) .And. Empty(cAnexo)
	SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
Else
	If Empty(cCc) .And. !Empty(cAnexo)
		SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
	ElseIf !Empty(cCc) .And. Empty(cAnexo)
		SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg RESULT lResulSend   
	Else
		SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResultSend   		   
	Endif
Endif
   
If !lResulSend
   GET MAIL ERROR cError
   MsgAlert("Falha no Envio do e-mail: " + cError)
Endif

DISCONNECT SMTP SERVER

Return(.T.)