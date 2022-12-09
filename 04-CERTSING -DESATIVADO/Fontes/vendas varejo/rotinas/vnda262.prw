#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
/*
ISHOPL_INDEFINIDO- forma de pagamento ainda não definida pelo cliente
ISHOPL_TEF - débito em conta/transferência
ISHOPL_BOLETO - boleto Itaú
ISHOPL_ITAUCARD - cartão de crédito
*/

Static __Shop := {"ISHOPL_INDEFINIDO","ISHOPL_TEF","ISHOPL_BOLETO","ISHOPL_ITAUCARD","BB_INDEFINIDO","BB_TEF","ONEBUY"}

/*/{Protheus.doc} VNDA262

Funcao para tratamento de atualização de dados de cartão de crédito 

@author Giovanni Antonio Rodrigues
@since 23/05/2017
@version P11

/*/

USER FUNCTION Vnda262( cID,cXml,cResponse, cError, cWarning)
               
Local cQrySC5	:= ""
Local cNumPed	:= ""
Local cDocCar	:= ""
Local cDocAut	:= ""
Local cCodConf	:= ""
Local cAut		:= ""
Local cDesFalha	:= ""
Local cTipShop	:= "0"
Local aXmlCC	:= {"","",""}
Local cOperDeliv	:= ""
Local cOperVenS		:= ""
Local cOperVenH		:= ""
Local cOperEntH		:= ""
Local cOperVen		:= ""
Local cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62")
Local lRecPag		:= .F.
Local cCartao		:= ""
Local lRet          := .F.
Local cMsg          := "Sem tratamento no VNDA262"

Private oXml        

cOperDeliv		:= GetNewPar("MV_XOPDELI", "01")
cOperVenS		:= GetNewPar("MV_XOPEVDS", "61")
cOperVenH		:= GetNewPar("MV_XOPEVDH", "62")
cOperEntH		:= GetNewPar("MV_XOPENTH", "53")

oXml := XmlParser( cxml, "_", @cError, @cWarning )

cNumPed := AllTrim(oXml:_NOTIFICAPROCESSAMENTOCARTAO:_PEDIDO:_NUMERO:TEXT)

If Type("oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_CARTAO:TEXT") <> "U"
	cCartao    := Alltrim(oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_CARTAO:TEXT)
EndIf

If Type("oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_TIPO:TEXT") <> "U"
	cTipShop    := Alltrim(Str(aScan(__Shop,{|x| x == oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_TIPO:TEXT })))
EndIf

If Type("oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_DOCUMENTO:TEXT") <> "U"
	cDocCar := AllTrim(oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_DOCUMENTO:TEXT)
EndIf

If Type("oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_AUTORIZACAO:TEXT") <> "U"
	cDocAut	:= AllTrim(oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_AUTORIZACAO:TEXT)
EndIf

If Type("oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_CODIGOCONFIRMACAO:TEXT") <> "U"
	cCodConf := AllTrim(oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_CODIGOCONFIRMACAO:TEXT)
EndIf

If Type("oXml:_NOTIFICAPROCESSAMENTOCARTAO:_FALHA:TEXT") <> "U"
	cDesFalha	:= AllTrim(oXml:_NOTIFICAPROCESSAMENTOCARTAO:_FALHA:TEXT)
Else
	cDesFalha	:= ""
EndIf

aXmlCC[1] := iif(Type("oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_DOCUMENTO:TEXT") <> "U",AllTrim(oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_DOCUMENTO:TEXT),"")
aXmlCC[2] := iif(Type("oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_CODIGOCONFIRMACAO:TEXT") <> "U",AllTrim(oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_CODIGOCONFIRMACAO:TEXT),"")
aXmlCC[3] := iif(Type("oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_AUTORIZACAO:TEXT") <> "U",AllTrim(oXml:_NOTIFICAPROCESSAMENTOCARTAO:_CONFIRMACAO:_AUTORIZACAO:TEXT),"")

cPedLog := cNumPed         

IF EMPTY(cId)
     cId:=cPedLog
EndIf

cQrySC5 := "SELECT C5_NUM, R_E_C_N_O_ RECPED "
cQrySC5 += "FROM " + RetSqlName("SC5") + " "
cQrySC5	+= "WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
cQrySC5 += "  AND C5_XNPSITE = '" + cNumPed + "' "
cQrySC5 += "  AND D_E_L_E_T_ = ' ' "

cQrySC5 := ChangeQuery(cQrySC5)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC5),"QRYSC5",.F.,.T.)
DbSelectArea("QRYSC5")

If QRYSC5->(!Eof())
	DbSelectArea("SC5")
	DbGoTo(QRYSC5->RECPED)
	QRYSC5->(DbCloseArea())

	cPedLog := IIf(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE)

	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

	lFat		:= .F.
	lServ		:= .F.
	lProd		:= .F.
	lRecPgto	:= .F.
	lGerTitRecb	:= .F.
	lEnt		:= .F.
    
	U_GTPutIN(cID,"N",cPedLog,.T.,{"FATURACC",cPedLog,SC5->C5_NUM,cxml},SC5->C5_XNPSITE,,aXmlCC)

	If SC5->C5_TPCARGA <> "1"
	
		cOperVen	:= cOperVenH
		If ! SC6->C6_XOPER $ cOperNPF //Verifica se é nova operação

			cOperVen :='52'
			cOperEntH:='53'
			cOperVenS:='51'

			lFat		:= .T.
			lServ		:= .T.
			lProd		:= .T.
			lEnt		:= .F.
			lRecPgto	:= .T.
			lGerTitRecb	:= .F.

		Else
		
	
			lFat		:= .F.
			lServ		:= .F.
			lProd		:= .F.
			lEnt		:= .F.
			lRecPgto	:= .T.
			lGerTitRecb	:= .T.

		Endif

	Else
		cOperVen	:= cOperDeliv
	    
	
		lFat		:= .T.
		lServ		:= .F.
		lProd		:= .T.
		lEnt		:= .F.
		lRecPgto	:= .T.
		lGerTitRecb	:= .T.
	EndIf


	If SC5->C5_TIPMOV $ '4,7' .OR. ALLTRIM(cDocAut)='TEF ITAU' //ShopLine Itau ou DébAut BB nunca gera título
		lGerTitRecb := .F.
	EndIf

//	( (!Empty(cDocAut) .and. SC5->C5_TIPMOV == "2" ) .or. cTipShop == "2" ) .And. Empty(cDesFalha)
	If ( (!Empty(cDocAut) .and. !Empty(cDocCar)) .or. cTipShop == "2")  .And. Empty(cDesFalha)
		RecLock("SC5", .F.)
		IF .NOT. Empty( cDocCar )
			Replace SC5->C5_XDOCUME With cDocCar
		EndIF
		IF .NOT. Empty( cDocAut )
			Replace SC5->C5_XCODAUT With cDocAut
			IF SC5->C5_XORIGPV=='8' .AND. !SC5->C5_XLIBFAT =='S'//Pedidos de Cursos ainda não liberados pelo Fiscal
				Replace SC5->C5_XLIBFAT With "P" //Muda status para pendente de análise fiscal
		  End
		EndIF
		IF .NOT. Empty( cCodConf ) 
			Replace SC5->C5_XTIDCC With cCodConf
			IF SC5->C5_XORIGPV=='8' .AND. !SC5->C5_XLIBFAT =='S'//Pedidos de Cursos ainda não liberados pelo Fiscal
				Replace SC5->C5_XLIBFAT With "P" //Muda status para pendente de análise fiscal
		  End
		EndIF

		If !Empty(cCartao)
			Replace SC5->C5_XNUMCAR With cCartao
			Replace SC5->C5_XCARTAO With cCartao
			
		Endif
		If cTipShop <> "0"
			Replace SC5->C5_XITAUSP With cTipShop
		EndIf

		IF .NOT. Empty( cCodConf ) .OR. .NOT. Empty( cDocAut )
			Replace SC5->C5_TIPMOV With '2' //Cartão
		EndIF

		SC5->(MsUnLock())

		SC6->(DbSetOrder(1))

		aParamFun := {SC5->C5_NUM,;				//1- Número do pedido
						Val(SC5->C5_XNPSITE),;	//2- Numero de controlo de JOB para log Gtin
						lFat,;						//3- Fatura venda
						nil,;						//4- Nosso número para atualização do título a receber
						lServ,;					//5- Fatura Serviço
						lProd,;					//6- Fatura produto
						nil,;						//7- Quantidade a faturar
						cOperVen,;					//8- Operação de venda Hardware
						cOperEntH,;				//9- Operação de entrega Hardware
						cOperVenS,;				//10- Operação de venda de Serviço
						cPedLog,;					//11- Pedido de Log
						nil,;						//12- data do Crédito Cnab
						lRecPgto,;					//13- Gera recibo de liberação
						lGerTitRecb,;				//14- Gera título para recibo  de liberação
						"PR",;						//15- Tipo do título de recibo de liberação
						lEnt}						//16- Fatura entrega de hardware

           
		aRetFat := U_VNDA190( cID ,aParamFun	)
		
		lRet	 := aRetFat[1]
		cMsg 	 := aRetFat[2]
		
		IF !lRet
			U_GTPutOUT(cID,"N",cPedLog,{"FATURACC",{.F.,"E00003",cPedLog,"Inconsistencia na Geração do PR no processamento do Cartao. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha:"+cDesFalha}},cNumPed)
			
			cResponse := XML_VERSION + CRLF
			cResponse += '<confirmaType>' + CRLF
			cResponse += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro
			cResponse += '		<msg>Inconsistencia na Geração do PR no processamento do Cartao</msg>' + CRLF
			cResponse += '		<exception></exception>' + CRLF
			cResponse += '</confirmaType>' + CRLF
		
		else
			cResponse := XML_VERSION + CRLF
			cResponse += '<confirmaType>' + CRLF
			cResponse += '		<code>1</code>' + CRLF	// 1=sucesso na operação; 0=erro
			cResponse += '		<msg>Processado com sucesso</msg>' + CRLF
			cResponse += '		<exception></exception>' + CRLF
			cResponse += '</confirmaType>' + CRLF
		EndIf
	
		
	ElseIf !Empty(cDesFalha)
	
		U_GTPutOUT(cID,"N",cPedLog,{"FATURACC",{.F.,"E00003",cPedLog,"Inconsistencia de Processamento Cartao. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha:"+cDesFalha}},cNumPed)

		cResponse := XML_VERSION + CRLF
		cResponse += '<confirmaType>' + CRLF
		cResponse += '		<code>1</code>' + CRLF	// 1=sucesso na operação; 0=erro
		cResponse += '		<msg>Notificacao de processamento com falha recebida com sucesso</msg>' + CRLF
		cResponse += '		<exception></exception>' + CRLF
		cResponse += '</confirmaType>' + CRLF
		lRet	 := .f.
		cMsg 	 := "Inconsistencia de Processamento Cartao. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha:"+cDesFalha
		      

	ElseIf SC5->C5_TIPMOV <> '2'
		aXmlCC[2] := " Falha: Faturamento de Pedido com Tipo de Pagamento diferente de Cartão de Crédito"
	
		U_GTPutOUT(cID,"N",cPedLog,{"FATURACC",{.F.,"E00003",cPedLog,"Inconsistencia de Processamento cartão. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha: Faturamento de Pedido com Tipo de Pagamento diferente de Cartão de Crédito"}},cNumPed)

		cResponse := XML_VERSION + CRLF
		cResponse += '<confirmaType>' + CRLF
		cResponse += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro
		cResponse += '		<msg>Pedido Não Foi Processado</msg>' + CRLF
		cResponse += '		<exception>Notificação de pagamento para pedido com forma de pagamento diferente de cartão de crédito</exception>' + CRLF
		cResponse += '</confirmaType>' + CRLF
		lRet	 := .f.
		cMsg 	 := "Inconsistencia de Processamento cartão. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha: Faturamento de Pedido com Tipo de Pagamento diferente de Cartão de Crédito"

	ElseIf Empty(SC5->C5_XDOCUME) .and. Empty(SC5->C5_XCODAUT)
	
		U_GTPutOUT(cID,"N",cPedLog,{"FATURACC",{.F.,"E00003",cPedLog,"Inconsistencia de Processamento cartao. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha: Não foram gravadas as informações de Doc e Aut "}},cNumPed)

		cResponse := XML_VERSION + CRLF
		cResponse += '<confirmaType>' + CRLF
		cResponse += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro
		cResponse += '		<msg>Não foi gravado documento e autorização no pedido</msg>' + CRLF
		cResponse += '		<exception></exception>' + CRLF
		cResponse += '</confirmaType>' + CRLF
		lRet	 := .f.
		cMsg 	 := "Inconsistencia de Processamento cartao. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha: Não foram gravadas as informações de Doc e Aut "
	Else
		U_GTPutOUT(cID,"N",cPedLog,{"FATURACC",{.F.,"E00003",cPedLog,"Pedido inconcistente. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha:"+cDesFalha}},cNumPed)

		cResponse := XML_VERSION + CRLF
		cResponse += '<confirmaType>' + CRLF
		cResponse += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro
		cResponse += '		<msg>O pedido existe mas está inconcistente.Revise os dados do pedido /msg>' + CRLF
		cResponse += '		<exception>Pedido: ' + cPedLog + '</exception>' + CRLF
		cResponse += '</confirmaType>' + CRLF
		lRet	 := .f.
		cMsg 	 := "Pedido inconcistente. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha:"+cDesFalha
	EndIf
Else

	DbSelectArea("QRYSC5")
	QRYSC5->(DbCloseArea())

	U_GTPutIN(cID,"N",cPedLog,.T.,{"FATURACC",cPedLog,cNumPed,cxml},cNumPed,,aXmlCC)

	U_GTPutOUT(cID,"N",cPedLog,{"FATURACC",{.F.,"E00003",cPedLog,"Nao Foram Encontrados Dados para Busca. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha:"+cDesFalha}},cNumPed)

	cResponse := XML_VERSION + CRLF
	cResponse += '<confirmaType>' + CRLF
	cResponse += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro
	cResponse += '		<msg>Não foi retornado nenhum dado para sua consulta.</msg>' + CRLF
	cResponse += '		<exception>Pedido: ' + cPedLog + '</exception>' + CRLF
	cResponse += '</confirmaType>' + CRLF
	lRet	 := .f.
	cMsg 	 :="Nao Foram Encontrados Dados para Busca. Doc: "+cDocCar+" Aut.: "+cDocAut+" Falha:"+cDesFalha
EndIf


Return({lRet, cMsg})

