#include "rwmake.ch"
#include "ap5mail.ch"


//Envia E-mail
User Function zEvMailSCA(cTo, cCc, cAssunto, cMsg, aAnexo)
	Local cNum			:= TRB1->NUM

	Local oServer
	Local oMessage
	Local cUsr          := GetMv("MV_RELACNT") //Conta de autenticao do email
	Local cPsw          := GetMv("MV_RELPSW") //Senha para autenticao no servidor de e-mail
	Local cSrv          := GetMv("MV_RELSERV") //Servidor SMTP
	Local lAut          := GetMv("MV_RELAUTH") //Servidor SMTP necessite de AUTENTICAÎ—AO para envio de e-mailÂ’s
	Local nPrt          := 587
	local nI
	local dRevisao
	local cFormula
	local cEmail		:= ""

	Local nTotalProd	:= 0
	Local nTotalDesc	:= 0
	Local nTotalDesp	:= 0
	Local nTotalSeg		:= 0
	Local nTotalFrete	:= 0
	Local nTotalICMSRET	:= 0
	//nTotalAcre	+= aDados[nP,]  //Totalizando Acrescimo
	Local nTotalCom		:= 0
	Local nTotalIPI		:= 0
	Local nTotPdSIPI	:= 0

	Local cLinha1 		:= ""
	Local cLinha2 		:= ""
	Local cLinha3 		:= ""
	Local cLinha4 		:= ""
	Local cLinha5 		:= ""
	Local cLinha6 		:= ""
	Local cLinha7 		:= ""
	Local cLinha8 		:= ""
	Local cLinha9 		:= ""
	Local cLinha10 		:= ""
	Local cLinha11 		:= ""
	Local cLinha12 		:= ""
	Local cLinha13 		:= ""
	Local cLinha14 		:= ""
	Local cCondPagto	:= ""
	Local cGrup			:= ""

	Local aMatriz2 		:= {}
	Local aMatriz		:= {}
	Local nI 			:= 0
	Local nI2 			:= 0
	Local nI3 			:= 0
	Local nI5 			:= 0

	Local cMensagem2 	:= ""
	Local cMensagem 	:= ""

	Private n1 := 0
	Private aDadosEmp	:=	{SM0->M0_NOMECOM,; //Nome da Empresa - 1
	SM0->M0_ENDCOB ,; //Endereï¿½o - 2ï¿½
	AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+" - " + SM0->M0_ESTCOB,;  // + " - " + SM0->M0_UFCOB,;//Complemento - 3
	Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3),; //CEP - 4
	SM0->M0_TEL,; //Telefones - 5
	Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+; // CNPJ - 6
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+;
	Subs(SM0->M0_CGC,13,2),; //CGC
	Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+; // INSCR. ESTADUAL - 7
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3),;
	Subs(SM0->M0_CIDENT,1,20)} //Cidade da

	//Local aAnexo := StrTokArr(cAnexo, ";")
	//Cria a conexÎ³o com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()
	//oServer:SetUseTLS( .T. )
	//O servidor esta com a porta
	If ":" $ cSrv
		nPrt := Val(Substr(cSrv, At(":",cSrv)+1))
		cSrv := Substr(cSrv, 1 , At(":",cSrv)-1)
	EndIf

	oServer:Init( "", cSrv, cUsr, cPsw, , nPrt )

	//seta um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		 MsgAlert( "Falha ao setar o time out", "Email nao enviado!" )
		Return .F.
	EndIf

	//realiza a conexÎ³o SMTP
	If oServer:SmtpConnect() != 0
		 MsgAlert( "Falha ao conectar", "Email nao enviado!" )
		Return .F.
	EndIf

	If lAut
		If oServer:SmtpAuth( cUsr, cPsw ) != 0
			 MsgAlert( "Falha ao autenticar", "Email nao enviado!" )
			Return .F.
		EndIf
	EndIf
	//Apos a conexÎ³o, cria o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpa o objeto
	oMessage:Clear()

dbSelectArea("SC7")
SC7->( dbSetOrder(1))

for nI=1 to Len( "TRB1" )
	AAdd( aMatriz, ALLTRIM(TRB1->ITEMCONTA),nI ) // Posicione("CTD",1,xFilial("CTD") +  ALLTRIM(aCols[nI][3]),"CTD_XIDPM")
	if ascan(aMatriz2,aMatriz[nI]) = 0 
		aadd(aMatriz2,aMatriz[nI]) 
	endif
//cNum := ALLTRIM(aCols[nI][1])	
next   

/*
for nI=1 to len(aMatriz2) 
			alert(aMatriz2[nI]+"aaa")
			cMensagem += aMatriz[nI] + chr(13) + chr(10)
		next  */

if SC7->( dbSeek(xFilial("SC7")+cNum) ) // == .F. .OR. Empty(cNum)


//////////////////////////////////////////
	cMsg:=' <!DOCTYPE html>'
	cMsg+='<html>'
	cMsg+='	<head>'
	cMsg+='		<meta http-equiv=”Content-Type” content=”text/html; charset=utf-8?>'
	cMsg+='		<title>Aprovação de Relatório de Despesas</title>'
	cMsg+='		<style>'
	cMsg+='		table{'
	cMsg+='			font-size: 0.8em;'
	cMsg+='			border-collapse:collapse;'
	cMsg+='		}'
				
	cMsg+='	table, th, td'
	cMsg+='				{'
	cMsg+='		border: 1px solid #99CCFF;'
	cMsg+='		face="Helvética";'
	cMsg+='		padding: 7px;'
	cMsg+='		}'

	cMsg+='		body{'
	cMsg+='			font-family: "Trebuche MS", Helvetica, sans-serif;'
	cMsg+='			min-width: 750px;'
	cMsg+='			}'

	cMsg+='		#cssTable td'
	cMsg+='				{'
	cMsg+='				vertical-align: middle;'
	cMsg+='				}'

	cMsg+='	.Fonte1{'
	cMsg+='		font-size: 0.75em;'
	cMsg+='	}'

	cMsg+='		.Fonte2{'
	cMsg+='		font-size: 0.7em;'
	cMsg+='		font-weight: bolder;'
	cMsg+='		text-align: center;'
	cMsg+='	}'

	cMsg+='		.Fonte3{'
	cMsg+='		font-size: 1em;'
	cMsg+='		font-weight: bolder;'
	cMsg+='		text-align: right;'
	cMsg+='	}'

	cMsg+='		.Fonte4{'
	cMsg+='				font-size: 0.7em;'
	cMsg+='				text-align: center;'
	cMsg+='		}'

	cMsg+='		.Fonte5{'
	cMsg+='				font-size: 12px;'
	cMsg+='				text-align: right;'
	cMsg+='		}'

	cMsg+='		.Font6{'
	cMsg+='		font-size: 0.7em;'
	cMsg+='		font-weight: bolder;'
	cMsg+='		text-align: left;'
	cMsg+='	}'

	cMsg+='	.ACentro{'
	cMsg+='	text-align:center;'
	cMsg+='	}'

	cMsg+='	.ACentro2{'
	cMsg+='	text-align:center;'
	cMsg+='	background: rgb(1, 86, 151);'
	cMsg+='	}'

	cMsg+='		.ADireita{'
	cMsg+='			text-align:right;'
	cMsg+='		}'

	cMsg+='		.AEsquerda{'
	cMsg+='	text-align:left;'
	cMsg+='	}'
	cMsg+='		.center1 {'
	cMsg+='			margin: auto;'
	cMsg+='			width: 80%;'
	cMsg+='			background: #fff;'
	cMsg+='			border: 3px ;'
	cMsg+='			padding: 10px;'
	cMsg+='			}'

	cMsg+='		#titulo{'
	cMsg+='				font-size: 0.8em;'
	cMsg+='				padding: 10px;'
	cMsg+='				text-align: center;'
	cMsg+='				background: rgb(1, 86, 151);'
	cMsg+='				color: #fff;'				
	cMsg+='			}'

	cMsg+='			.logo {'
	cMsg+='			font-family: "Arial Black";'
	cMsg+='			font-weight: bold;'
	cMsg+='			font-size: 1.9em;'
	cMsg+='			background: rgb(1, 86, 151);'
	cMsg+='			color: #fff;'
	cMsg+='			top: 20px;'
	cMsg+='			padding: 10px 0 0 0;'
	cMsg+='		}'

	cMsg+='		.fundo-logo{'
	cMsg+='			background: rgb(1, 86, 151);'
	cMsg+='			text-align:center;'
	cMsg+='		}'

	cMsg+='			span{'
	cMsg+='				font-size: 0.3em;'
	cMsg+='				/*background: rgb(1, 86, 151);*/'
	cMsg+='				padding-top: 3px;'
	cMsg+='			}'
	cMsg+='		#rodape{'
	cMsg+='				padding: 5px;'
	cMsg+='				color: #fff;'
	cMsg+='				text-align: center;'
	cMsg+='				background: rgb(1, 86, 151);'
	cMsg+='				min-width: 750px;'
	cMsg+='				margin-top: 20px;'
	cMsg+='			}'
	cMsg+='	</style>'
	cMsg+='	</head>'

	cMsg+='<body bgcolor="#FFFFFF">'

	cMsg+='	<div id="titulo">'
	cMsg+='				<h1 class="titulo-topo"> SOLICITAÇÃO DE APROVAÇÃO DE PEDIDO DE COMPRA</h1>'
	cMsg+='	</div>'

	cMsg+='	<div class="center1">'
	cMsg+='		<form action="mailto:%WFMailTo%" method="POST" name="AprPedCom">'

	cMsg+='			<table  width="100%" id="cssTable">'
	cMsg+='				<tr>'
	cMsg+='					<td> <b> Link Planilha de Equalização: </b>  <a href=' + "'" + StrTran(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XARQ"),'\','/') + "'" + '>' + Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XARQ") + '</a></td>'
	cMsg+='				</tr>'
	cMsg+='			</table>'

	cMsg+='			<table  width="100%" id="cssTable">'
	cMsg+='				<tr>'
	cMsg+='					<td> <b> Link arquivo: </b>  <a href=' + Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XARQ") + '>' + Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XARQ") + '</a></td>'
	cMsg+='				</tr>'
	cMsg+='			</table>'

	cMsg+='			<table  width="100%" id="cssTable">'
	cMsg+='				<tr>'
	cMsg+='					<td width="20%" id="cssTable" class="ACentro2" class="fundo-logo">'
							
	cMsg+='							<h1 class="logo"> '
	cMsg+='								WesTech <br><span> Equipamentos Industriais Ltds</span>'
	cMsg+='							</h1>'

							
	cMsg+='					<td width="20%" id="cssTable"  class="ACentro" colspan="2" > <h2> ORDEM DE COMPRA </br>' + cNum + '</h2> </td>'
	cMsg+='					<td width="40%" id="cssTable" class="Fonte1" class="AEsquerda" rowspan="2">'
	cMsg+='						<b> Fornecedor </b> </br>'
	cMsg+= 						Posicione("SC7",1,xFilial("SC7") + cNum,"C7_FORNECE")  + ' - ' +  Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_NOME") + '</br>'
	cMsg+=						Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_END")  + ' - ' + Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_NR_END") + '</br>'
	cMsg+=						Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_MUN") - ' - ' + Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_EST")  + ' - ' + Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_CEP") + '</br>'
	cMsg+=						'CNPJ:' + Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_CGC") + ' - ' + 'Inscr.Est.: ' + Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_INSCR") + ' - ' + 'Incr.Munc.: ' + Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_INSCRM") + '</br>'
	cMsg+='						Email: ' + Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_XXEMAIL") + '</br>'
	cMsg+='						Contato: ' + Posicione("SA2",1,xFilial("SA2") + C7_FORNECE,"A2_CONTATO") + '</br>'
	cMsg+='					</td>'
	cMsg+='					<td width="10%" id="cssTable" class="Fonte1"> '
	
	cMsg+='						Local de Entrega  <br>'
	cFormula	:= Posicione("SM4",1,xFilial("SM4") + Posicione("SC7",1,xFilial("SC7") + cNum," C7_MSG"),"M4_CODIGO")
	dbSelectArea("SM4")
	SM4->( dbSetOrder(1) )
	If SM4->( dbSeek( xFilial("SM4")+cFormula) )
		cCODIGO  := SUBSTR(SM4->M4_FORMULA,2,6)

		If SA2->( dbSeek( xFilial("SA2")+cCODIGO) )
			ccNREDUZ  	:= SA2->A2_NREDUZ
			ccEnd		:= SA2->A2_END
			ccBairro	:= SA2->A2_BAIRRO
			ccEst		:= SA2->A2_EST
			ccMun		:= SA2->A2_MUN
			ccCEP		:= SA2->A2_CEP
			ccPAIS		:= SA2->A2_PAIS
		ENDIF

	ENDIF
	IF EMPTY(cFormula)
		cMsg+=' '+ ALLTRIM( aDadosEmp[2]) + '<br>'
		cMsg+=' '+ ALLTRIM( aDadosEmp[3]) + ' - ' + ALLTRIM( aDadosEmp[4]) + ''

	ELSE
		cMsg+=' ' + ALLTRIM(ccNREDUZ) + " - " + ALLTRIM(ccEND) + '<br>'
		cMsg+=' ' + ALLTRIM(ccBAIRRO) + " - " + ALLTRIM(ccMUN) + " - " + ALLTRIM(ccEST) + " - CEP: " + ALLTRIM(ccCEP) + ''
	ENDIF

	cMsg+='					</td>'
	cMsg+='				</tr>'
	cMsg+='		<tr>'
	cMsg+='		<td width="20%" id="cssTable" class="Fonte1">'

	cMsg+='			Rua Marquês de Paranaguá, 36 </br>'
	cMsg+='			Consolação - São Paulo - SP - Brasil - 01303-050 </br>'
	cMsg+='			Tel.: +55 11 3234 5400 </br>'
	cMsg+='			CNPJ: 07.798.560/0001-82 - Inc.Est.: 149.336.875.115 </br>'
	cMsg+='			Inc.Municipal: 3.489.047-5'
	cMsg+='						</br>'
	cMsg+='		<td width="10%" id="cssTable" class="ACentro" > <b> Data Emissao: </br> '  + dtoc( Posicione("SC7",1,xFilial("SC7") + cNum,"C7_EMISSAO") ) + ' </b></td>'
	

	dRevisao := Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XXREV") 
	If EMPTY(dRevisao)
		cMsg+='		<td width="10%" id="cssTable" class="Fonte1" class="ACentro"> Revisão No. ' + cValToChar(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XXREV")) +  '</td>'
	Else
		cMsg+='		<td width="10%" id="cssTable" class="Fonte1" class="ACentro"> Revisão No. ' + cValToChar(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XXREV"))  + ' </br> ' + dtoc(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XXDTREV")) +  '</td>'
	Endif
	
	cMsg+='					<td width="50%" id="cssTable" class="Fonte1"> '
	cMsg+='						Local de Cobranca <br> '
	cMsg+='' + 					ALLTRIM( aDadosEmp[2])  + '<br>'
	cMsg+='' + 					ALLTRIM( aDadosEmp[3]) + " - " + ALLTRIM( aDadosEmp[4]) + '<br>'
	cMsg+='						E-mail NF Eletronica: notafiscal@westech.com.br'
	cMsg+='					</td>'

	cMsg+='		</tr>'
	cMsg+='			</table>'

	cMsg+='			<table width="100%" id="cssTable">'
	cMsg+='				<tr>'
	cMsg+='					<td id="cssTable" class="ACentro" colspan="7" class="Fonte2"> <b> Escopo de Fornecidmento </b></td>'
	cMsg+='					<td id="cssTable" class="ACentro" colspan="2" class="Fonte2"> <b> Preços com Impostos </b> </td>'
	cMsg+='					<td id="cssTable" class="ACentro" colspan="3" class="Fonte2"> <b> Impostos inclusos </b> </td>'
	cMsg+='					<td colspan="2" id="cssTable" ></td>'
	cMsg+='				</tr>'
	cMsg+='				<tr>'
	cMsg+='					<td id="cssTable" class="Fonte2"> Item </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> Código</td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> Descrição do Material e/ou Serviço </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> 1a. Qtd. </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> 2a. Un. </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> 2a. Qtd. </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> 2a. Un. </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> Unitário </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> Total </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> IPI % </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> ICMS % </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> ISS %</td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> Data de Entrega </td>'
	cMsg+='					<td id="cssTable" class="Fonte2"> Item Contábil </td>'
	cMsg+='				</tr>'

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	SC7->(DbGoTop()) 

	If SC7->( dbSeek(xFilial("SC7")+cNum) )
  		
  		While SC7->( ! EOF() ) .AND. SC7->C7_NUM == cNum

			cMsg+='				<tr>'
			cMsg+='					<td id="cssTable" class="Fonte4">' + C7_ITEM + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">'+ C7_PRODUTO + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte1">' + alltrim(Posicione("SB1",1,xFilial("SB1") + ALLTRIM(C7_PRODUTO),"B1_DESC")) + " " + ALLTRIM(C7_OBS) + " " + ALLTRIM(C7_XMEMO)  + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">'+ TRANSFORM(C7_QUANT, '@E 99,999,999.99') +  '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">' + C7_UM + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">' + TRANSFORM(C7_QTSEGUM, '@E 99,999,999.99') + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">' + C7_SEGUM + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte5">' + TRANSFORM(C7_PRECO, '@E 99,999,999.99') + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte5">' + TRANSFORM(C7_TOTAL, '@E 99,999,999.99') + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">' + TRANSFORM(C7_IPI, '@E 99,999,999.99') + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">' + TRANSFORM(C7_PICM, '@E 99,999,999.99') + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">' + TRANSFORM(C7_ALIQISS, '@E 99,999,999.99') + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">' + DTOC(C7_DATPRF) + '</td>'
			cMsg+='					<td id="cssTable" class="Fonte4">' + C7_ITEMCTA + '</td>'
			cMsg+='				</tr>'
  			
			nTotalProd	+= C7_TOTAL	//Totalizando Valor do produto
			nTotalDesc	+= C7_VLDESC  //Totalizando Descontos
			nTotalDesp  += C7_DESPESA // Totalizando Despesas
			nTotalSeg	+= C7_SEGURO // Totalizando Seguro
			nTotalFrete	+= C7_VALFRE // Totalizando Frete
			nTotalICMSRET += C7_ICMSRET // Totalizando ICMS Retido
			//nTotalAcre	+= aDados[nP,]  //Totalizando Acrescimo
			nTotalProd	+= C7_PRECO	//Totalizando Valor do produto
			nTotalCom	+= (C7_TOTAL + C7_VALIPI + C7_SEGURO + C7_DESPESA + C7_VALFRE) - (C7_VLDESC + C7_ICMSRET)  // Totalizando Valor do pedido de compras
			nTotalIPI 	+= C7_VALIPI // Totalizando IPI
			

		  	SC7->( dbSkip() )
		  	
		enddo
		
	EndIf

	nTotPdSIPI := (nTotalCom - nTotalIPI) - nTotalDesp - nTotalFrete
	cFormula2		:= Posicione("SM4",1,xFilial("SM4") + Posicione("SC7",1,xFilial("SC7") + cNum,"C7_REAJUST"),"M4_CODIGO")
	cXNOTAS       	:= MSMM(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XNOTAS"))

	If SM4->( dbSeek( xFilial("SM4")+cFormula2) )
		//msgAlert ( cFormula2 )
		cLinha1 := SM4->M4_XNOTAL1
		cLinha2 := SM4->M4_XNOTAL2
		cLinha3 := SM4->M4_XNOTAL3
		cLinha4 := SM4->M4_XNOTAL4
		cLinha5 := SM4->M4_XNOTAL5
		cLinha6 := SM4->M4_XNOTAL6
		cLinha7 := SM4->M4_XNOTAL7
		cLinha8 := SM4->M4_XNOTAL8
		cLinha9 := SM4->M4_XNOTAL9
		cLinha10 := SM4->M4_XNOTA10
		cLinha11 := SM4->M4_XNOTA11
		cLinha12 := SM4->M4_XNOTA12
		cLinha13 := SM4->M4_XNOTA13
		cLinha14 := SM4->M4_XNOTA14
	ENDIF

	cMsg+='				<tr>'
	cMsg+='						<td id="cssTable" class="Fonte6" colspan="12" rowspan="4">'
	cMsg+='  						<b> Notas </b> <br>' 

		IF EMPTY(cFormula2) .AND. EMPTY(cXNotas)
			cMsg+='As Condicoes Gerais de Compras - Anexo 3 - PQ-90-0784 revisao 05 - sao parte integrante desta Ordem de compra: <br>'
			cMsg+='A Ordem de Compra e as Condicoes Gerais de Compra deverao ser assinadas e devolvidas em ate tres dias. A partir deste prazo serao considerados aprovadas. <br>'
			cMsg+='Nao serao aceitas notas fiscais de recebimento de materiais sem que nela constem numero da Ordem de Compra. <br>'
			cMsg+='A Westech se reserva o direito de efetuar testes na fabrica do fornecedor antes da liberacao para entrega. <br>'
			cMsg+='A penalidadade por atraso de entrega sera de 0,3% ao dia com teto maximo de 10%. Os valores correspondente serao glosados do pagamento a ser feito. <br>'
			cMsg+='Os preco informados incluem ICMS, PIS e COFINS. <br>'
			cMsg+='Os pagamentos serao feitos atraves de deposito bancario. <br>'
			cMsg+='Material destinado a industrializacao. <br>'
			cMsg+='Enviar certificado de qualidade do produto anexado a nota fiscal. <br>'
			cMsg+='Importante: <br>'
			cMsg+='A Westech nao aceita emissao de boletos para pagamentos, bem como, nao aceita negociacao de duplicata com terceiros. <br>'
			cMsg+='Fornecer uma via fisica do Certificado de Materia Prima / Procedencia junto com envio do produto e uma via eletronica (e-mail) junto com nota fiscal. <br>'

		ELSEIF !EMPTY(cFormula2) .AND. EMPTY(cXNotas)
		
			cMsg+=' ' + cLinha1 + '<br>'
			cMsg+=' ' + cLinha2 + '<br>'
			cMsg+=' ' + cLinha3 + '<br>'
			cMsg+=' ' + cLinha4 + '<br>'
			cMsg+=' ' + cLinha5 + '<br>'
			cMsg+=' ' + cLinha6 + '<br>'
			cMsg+=' ' + cLinha7 + '<br>'
			cMsg+=' ' + cLinha8 + '<br>'
			cMsg+=' ' + cLinha9 + '<br>'
			cMsg+=' ' + cLinha10 + '<br>'
			cMsg+=' ' + cLinha11 + '<br>'
			cMsg+=' ' + cLinha12 + '<br>'
			cMsg+=' ' + cLinha13 + '<br>'
			cMsg+=' ' + cLinha14 + '<br>'

		ELSEIF !EMPTY(cXNotas)
			cMsg+=' ' + Alltrim(cXNotas)  + '<br>'
		endif

	cMsg+='						</td>'
	cMsg+='						<td id="cssTable" class="Fonte6" >'
	cMsg+='							<b> Total itens (s/ IPI): </b>'
	cMsg+='							</br>'
	cMsg+='						<td id="cssTable" class="ADireita" class="Fonte3"  >'
	cMsg+='							<b>' + TRANSFORM(nTotPdSIPI, '@E 99,999,999.99') + '</b>'
	cMsg+='						</td>'
	cMsg+='				</tr>'
	cMsg+='				<tr>'
	cMsg+='						<td id="cssTable" class="Fonte6" >'
	cMsg+='							<b> Seguro: </b> </br>'
	cMsg+='							<b> Frete: </b>   </br>'
	cMsg+='							<b> Despesas: </b> </br>'
	cMsg+='							<b> Total IPI: </b> </br>'
	cMsg+='						</td>'
	cMsg+='						<td id="cssTable" class="Fonte3" >'
	cMsg+='							' + TRANSFORM(nTotalSeg, '@E 99,999,999.99') +  '</br>'
	cMsg+='							' + TRANSFORM(nTotalFrete, '@E 99,999,999.99') + '</br>'
	cMsg+='							' + TRANSFORM(nTotalDesp, '@E 99,999,999.99') + '</br>'
	cMsg+='							' + TRANSFORM(nTotalIPI, '@E 99,999,999.99') + '</br>'
	cMsg+='						</td>'
	cMsg+='				</tr>'
	cMsg+='				<tr>'
	cMsg+='						<td id="cssTable" class="Fonte6">'
	cMsg+='							<b> Desconto: </b> </br>'
	cMsg+='							<b> ICMS Subst.Tributária: </b> </br>'
	cMsg+='						</td>'
	cMsg+='						<td id="cssTable"class="ADireita" class="Fonte3">'
	cMsg+='							' + TRANSFORM(nTotalDesc, '@E 99,999,999.99') + '</br>'
	cMsg+='							' + TRANSFORM(nTotalICMSRET, '@E 99,999,999.99') + '</br>'
	cMsg+='						</td>'
	cMsg+='				</tr>'

	cMsg+='				<tr>'
	cMsg+='						<td id="cssTable" class="Fonte6" >'
	cMsg+='							<b> Total Ordem de Compra: </b> </br>'
	cMsg+='						</td>'
	cMsg+='						<td id="cssTable" class="Fonte3" >'
	cMsg+='							<b> ' + TRANSFORM(nTotalCom, '@E 99,999,999.99') + '</b> </br>'
	cMsg+='						</td>'
	cMsg+='				</tr>'
	cMsg+='				<tr>'


	cCondPagto		:= Posicione("SE4",1,xFilial("SE4") + Posicione("SC7",1,xFilial("SC7") + cNum,"C7_COND"),"E4_DESCRI") 

	cMsg+='			'
	cMsg+='					<td id="cssTable" colspan="14"> <b>Codição de Pagamento:</b> ' + cCondPagto + '</td>'
	cMsg+='					</br>'
	cMsg+='				</tr>'
	cMsg+='			</table>'
	cMsg+='			<br>'
	cMsg+='			</table>'
	cMsg+='			<br>'
	cMsg+='			<table width="100%" id="cssTable" class="ACentro" class="Fonte3">'
	cMsg+='				<tr >'
	cMsg+='						<td colspan="2" class="Fonte2">'
	cMsg+='							Emissao'
	cMsg+='						</td>'
	cMsg+='						<td colspan="3" class="Fonte2">'
	cMsg+='							Aprovação'
	cMsg+='						</td>'
	cMsg+='				</tr>'

	cMsg+='				<tr class="ACentro" >'
	cMsg+='						<td class="Fonte2"> Solicitante</td>'
	cMsg+='						<td class="Fonte2"> Comprador</td>'
	cMsg+='						<td class="Fonte2"> Coordenador</td>'
	cMsg+='						<td class="Fonte2"> Gerencia</td>'
	cMsg+='						<td class="Fonte2"> Diretoria</td>'
	cMsg+='				</tr>'
	cMsg+='				<tr class="ACentro" >'
	cMsg+='						<td class="Fonte2"> '
	cMsg+='							' + AllTrim(UsrFullName(Posicione("SC1",6,xFilial("SC1") + cNum,"C1_USER"))) + "<br>"
	cMsg+='							' + Posicione("ZZE",1,xFilial("ZZE") + (Posicione("SC1",6,xFilial("SC1") + cNum,"C1_USER")),"ZZE_CARGO") + ''
	cMsg+='						</td>'
	cMsg+='						<td class="Fonte2"> '
	cMsg+='							' + AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_USER"))) + '<br>'
	cMsg+='							' +	Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNum,"C7_USER"),"ZZE_CARGO") + ''
	cMsg+='						</td>'
	
	// APROVACAO COORDENADOR
	cMsg+='						<td class="Fonte2"> 
				if  EMPTY(SC7->C7_XAPRN1) .and. SC7->C7_ITEMCTA <> 'ADMINISTRACAO'//.OR. alltrim(SC7->C7_XCTRVB) <> "4" // 
	cMsg+='							REQUER APROVACAO <br>'
	cMsg+='							DO COORDENADOR(A) '		
				elseif !EMPTY(SC7->C7_XAPRN1) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
	cMsg+='							' +	AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XAPRN1"))) + '<br>'
	cMsg+='							' +	Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XAPRN1"),"ZZE_CARGO") + ''
				endif
	cMsg+='						</td>'

	// CAPTURAR DO COORDENADOR DO CONTRATO
				PswOrder(1)
				If PswSeek( SC7->C7_XAPRN1, .T. )
					cGrup := alltrim(PSWRET()[1][12])
				endif

				cUserCoord := POSICIONE("CTD",1,XFILIAL("CTD")+ SC7->C7_ITEMCTA,"CTD_XIDPM")

	// APROVACAO GERENCIA
	cMsg+='						<td class="Fonte2"> '
				if  EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1000 .AND. cGrup == "Contratos(E)"
	cMsg+='							REQUER APROVACAO <br>'
	cMsg+='							DA GERENCIA '		

				elseif  EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1500 .AND. cGrup == "Contratos"
	cMsg+='							REQUER APROVACAO <br>'
	cMsg+='							DA GERENCIA '		

				elseif !EMPTY(SC7->C7_XAPRN3) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
	cMsg+='							' +	AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XAPRN3"))) + '<br>'
	cMsg+='							' +	Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XAPRN3"),"ZZE_CARGO") + ''
				endif
	cMsg+=' 					</td>'


	// APROVACAO DIRETORIA		
	cMsg+='						<td class="Fonte2"> 	
				if EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1000 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR' .AND. cGrup == "Contratos(E)"
	cMsg+='							REQUER APROVACAO <br>'
	cMsg+='							DA DIRETORIA'
				elseif EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1500 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR' .AND. cGrup == "Contratos"
	cMsg+='							REQUER APROVACAO <br>'
	cMsg+='							DA DIRETORIA'
				elseif ALLTRIM(SC7->C7_ITEMCTA) $ "ADMINISTRACAO/PROPOSTA"
	cMsg+='							REQUER APROVACAO <br>'
	cMsg+='							DA DIRETORIA'
				elseif !EMPTY(SC7->C7_XAPRN2)
	cMsg+='							' + AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XAPRN2"))) + '<br>'
	cMsg+='							' + Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNum,"C7_XAPRN2"),"ZZE_CARGO") + ''
				endif

	cMsg+='						</td>'
	cMsg+='				</tr>'
	cMsg+='			</table>'
	cMsg+='		</form>'
	cMsg+='	</div>'

	cMsg+='	<div id="rodape">'
	cMsg+='				<h5> Westech Equipamentos Industriais Ldta - Fonte de dados Protheus (WestechP12)</h3>'
	cMsg+='	</div>'
	cMsg+='</body>'
	cMsg+='</html>'

	

endif

	cEmail		:=  "linfanti@westech-inc.com"  //"rvalerio@westech.com.br" 

	//Popula com os dados de envio
	oMessage:cFrom              := cUsr
	oMessage:cTo                := cEmail //"rvalerio@westech.com.br" 
	oMessage:cCc                := "rcalvo@westech.com.br"
	//oMessage:cBcc             := ""
	oMessage:cSubject           := "Solicitação de Aprovação de Pedido de Compra" //cAssunto
	oMessage:cBody              := cMsg

	/*if empty(cEmail)
		RETURN .F.
	endif*/

	//Adiciona um attach
	If !Empty(aAnexo) //.AND. !Empty(cAnexo)
		For nI:= 1 To Len(aAnexo)
			If oMessage:AttachFile(aAnexo[nI]) < 0
				 MsgAlert( "Erro ao anexar o arquivo", "Email nao enviado!")
				Return .F.
				//Else
				//adiciona uma tag informando que e um attach e o nome do arq
				//oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=arquivo.txt')
			EndIf
		Next nI
	EndIf

	//Envia o e-mail
	If oMessage:Send( oServer ) != 0
		 MsgAlert( "Erro ao enviar o e-mail", "Email nao enviado!")
		Return .F.
	EndIf


//Desconecta do servidor
	If oServer:SmtpDisconnect() != 0
		 MsgAlert( "Erro ao disconectar do servidor SMTP", "Email nao enviado!")
		Return .F.
	EndIf

	msginfo('Aviso de solicitacao de aprovacao enviado paro o e-mail ' + cEmail + '.','Westech')
Return .T.
