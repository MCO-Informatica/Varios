#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVNDA140  บAutor  ณDarcio R. Sporl     บ Data ณ  05/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte criado para executar a fila de pedidos gravada anteri-บฑฑ
ฑฑบ          ณormente com os pedidos gerados pelo site                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlterado  ณ Data     ณ Descricao                                       บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ                                                                             
ฑฑบAlceu P.  ณ03/11/2011ณAlterada a inclusao de pedido que fica dependendoบฑฑ 
ฑฑบ          ณ          ณdo retorno da posicao 3 do array aRVou indicando บฑฑ 
ฑฑบ          ณ          ณse o pedido sera incluido .T. ou nao .F. #1      บฑฑ   
ฑฑบAlceu P.  ณ09/11/2011ณRetirada a chamada. GTPUTIN e do GTPUTOUT.       บฑฑ 
ฑฑฬออออออออออุออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs x Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VNDA140(aParSch)

Local aDados	:= {}
Local aDadosT	:= {}
Local nOpc		:= 3
Local cNpSite	:= ""
Local cTipo		:= ""
Local cCliente	:= ""
Local cLjCli	:= ""
Local cTpCli	:= ""
Local cForPag	:= ""
Local dEmissao	:= ""
Local cItem		:= ""
Local cProd		:= ""
Local cNome		:= ""
Local cNReduz	:= ""
Local cEnd		:= ""
Local cBairro	:= ""
Local cCompl	:= ""
Local cCep		:= ""
Local cFone		:= ""
Local cDDD		:= ""
Local cEmail	:= ""
Local nQtVend	:= 0
Local nPrecUni	:= 0
Local nPrecVen	:= 0          
Local nValor	:= 0
Local dEntreg	:= CtoD("  /  /  ")
Local cTES		:= ""
Local cError	:= ""
Local cWarning	:= ""
Local cCgc		:= ""
Local cPessoa	:= ""
Local cTabela	:= ""
Local cTabela1	:= ""
Local nI		:= 0
Local aProdutos	:= {}
Local aProdPrin	:= {}
Local cPosNom	:= ""	//Nome do Posto
Local cPosEnd	:= ""	//Endereco Posto
Local cPosBai	:= ""	//Bairro Posto
Local cPosCom	:= ""	//Complemento Posto
Local cPosCep	:= ""	//Cep Posto
Local cPosFon	:= ""	//Fone Posto
Local cPosCid	:= ""	//Nome da cidade do Posto
Local cPosUf	:= ""	//UF do Posto
Local cPosCod	:= ""	//Codigo do Posto
Local cPosLoj	:= ""	//Loja do Posto
Local cPosGAR	:= ""
Local lChkVou	:= .F.
Local lRet		:= .T.
Local cTipCar	:= ""
Local cNumCart	:= ""
Local cNomTit	:= ""
Local cCodSeg	:= ""
Local dDtVali	:= CtoD("  /  /  ")
Local cParcela	:= ""
Local cTipo		:= ""
Local cLinDig	:= ""
Local cNumvou	:= ""
Local nQtdVou	:= 0
Local cDados	:= ""
Local aParam	:= {}
Local aRVou		:= {.T., ""}
Local nPed		:= 0
Local nPro		:= 0
Local nProd		:= 0
Local cNomeC	:= ""
Local cCpfC		:= ""
Local cEmailC	:= ""
Local cSenhaC	:= ""
Local cFoneC	:= ""
Local cQrySC5	:= ""
Local cRootPath	:= ""
Local cArquivo	:= ""
Local oXml		:= Nil
Local cQryGT	:= ""
Local cQryXML	:= ""
Local cUpdLis	:= ""
Local cUpdPed	:= ""
Local cRootPath	:= ""
Local cID		:= ""
Local cPedGarL	:= ""
Local cXML		:= ""
Local nXML		:= 0
Local aRetCo	:= {}
Local aRetCl	:= {}
Local cJobEmp	:='' 
Local cJobFil	:='' 
Local cInEst	:= ""
Local cInMun	:= ""
Local cSufra	:= ""
Local cOriVen	:= ""
Local cPedGar	:= ""
Local oWsObj
Local oWsRes
Local _lJob 	:= (Select('SX6')==0)
Local cSvcError   := ""
Local cSoapFCode  := ""
Local cSoapFDescr := ""
Local bOldBlock
Local cErrorMsg := ''

Default aParSch	:= {"01","02"} 

cJobEmp	:= IIF(ValType(aParSch[1])=="C",aParSch[1],"01")
cJobFil	:= IIF(ValType(aParSch[2])=="C",aParSch[2],"02")

Private cContSite := ""

If _lJob
	RpcSetType(3)
	RpcSetEnv(cJobEmp, cJobFil)
EndIf

conout( "Vnda140 - Data: " + dtoc(Date()) + " - " + Time() + " | " + "Inicio do processo de inclusใo de pedidos"   )

BEGIN SEQUENCE	

	oWsObj := WSHARDWAREAVULSOPROVIDER():New()

	lOk := oWsObj:executaPedidos()

	cSvcError   := GetWSCError()  // Re	sumo do erro
	cSoapFCode  := GetWSCError(2)  // Soap Fault Code
	cSoapFDescr := GetWSCError(3)  // Soap Fault Description
			
	If !empty(cSoapFCode) .or. !Empty(cSvcError) 
	 
		//Caso a ocorr๊ncia de erro esteja com o fault_code preenchido ,
		//a mesma teve rela็ใo com a chamada do servi็o . 
		cSvcError   := IIF(cSvcError <> NIL, cSvcError, "")
		cSoapFCode  := IIF(cSoapFCode <> NIL, cSoapFCode, "")
		cSoapFDescr := IIF(cSoapFDescr <> NIL, cSoapFDescr, "")
			
		lOk := .F.
	Endif

END SEQUENCE		

If !lOk
	conout( "Vnda140 - Data: " + dtoc(Date()) + " - " + Time() + " | " + "Foram Encontradas Inconsist๊ncias Processamento da Fila Pelo WebService:"+CRLF+cSoapFDescr+""+cSoapFCode+CRLF+cSvcError  )
EndIf

conout( "Vnda140 - Data: " + dtoc(Date()) + " - " + Time() + " | " + "Fim do processo de inclusใo de pedidos"   )

Return
