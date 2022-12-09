////#Include "aarray.ch"
//#Include "json.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"


User Function vSealPedJob()
U_vSealPx(2)
Return

User Function vSealPx(nOpc)
Default nOpc    := 2 // 1 = Job / 2 = vSealMONIT
Private aArea   := GETAREA()
Private oSvc
Private cSession
Private oPedidos
Private aStatus := {'processing'}	//'paga_ps',
If nOpc == 1
	lJob := .T.
Else
	lJob := .F.
EndIf

//If InExec("vSealPedido")
//	MsgAlert("Rotina de integração de pedidos já está em execução")
//	Return
//EndIF

If lJob
	ConOut(OemToAnsi("Início da Integracao vSeal - Pedidos " + Dtoc(date()) +" - " + Time()))
	
	RPCSETTYPE(3)
	//	Prepare Environment Empresa "D1" Filial "F1"
	Prepare Environment Empresa "01" Filial "01"
	
	If Select("SX2") <= 0
		ConOut(OemToAnsi(Dtoc(date()) + " - " + Time() + ": Erro na preparacao do ambiente."))
		Return
	EndIF
	
	If .T. //cNumEmp == "D1F1"
		For nStatus := 1 To Len(aStatus)
			lOk := .f.
			lOk := ContatWeb(lJob,aStatus[nStatus])
			If lOk
				AuxTransp(lJob)
			Endif
		Next
	EndIf
	
	ConOut(OemToAnsi(Dtoc(date()) + " - " + Time() + ": Fim da Integracao vSeal - Pedidos"))
	Reset Environment
Else
	If .T. //cNumEmp == "D1F1"
		For nStatus := 1 To Len(aStatus)
			lOk := .f.
			MsgRun("Integração SealBag x Protheus","Conectando site. Aguarde...Status: "+aStatus[nStatus], { || lOk := ContatWeb(lJob,aStatus[nStatus])	} )
			If lOk
				Processa( { || AuxPedido(lJob) }, 'Processando Pedidos' )
			Endif
		Next
	EndIf
EndIf

RestArea(aArea)
Return
//************************************************************************************************************************
//************************************************************************************************************************
//************************************************************************************************************************

//************************************************************************************************************************
//************************************************************************************************************************
//************************************************************************************************************************
Static Function ContatWeb(lJob,cStatus)
Local cLogin		 := 'totvs' //GetNewPar("MV_MLLOGIN",'sealbag')
//Local cSenha		 := GetNewPar("MV_MLSENHA",'@sb!8434#3ls')
Local cSenha		 := 'sealbagservice2015' //GetNewPar("MV_MLSENHA",'sealbagservice2015')


WSDLDbgLevel(3)
oSvc := wsMagentoService():New()
oSvc:Login(cLogin, cSenha)
ctxt := GetWSCError()
If !Empty(cTxt)
	Alert(cTxt)
	Return .f.
Endif
cSession := oSvc:cloginReturn 
oSvc:cSessionID := cSession
oSvc:salesOrderList(cSession,'',cStatus) 
oPedidos := oSvc:oWSsalesOrderListresult
ctxt := GetWSCError()
If Empty(cTxt)
	Return .t.
Else     
	Alert(cTxt)
	Return .f.
Endif

//************************************************************************************************************************
//************************************************************************************************************************
//************************************************************************************************************************

//************************************************************************************************************************
//************************************************************************************************************************
//************************************************************************************************************************
Static Function AuxPedido(lJob)
Local cLoja   		 := "01"
Local aProds		 := Separa(GetNewPar("MV_MLPRODS",'001;000001;002;000002;0003;000003;015;000003;005;000003'),";")
Local cTES		 	 := GetNewPar("MV_MLTES"  ,'501')
Local cTransp		 := GetNewPar("MV_MLTRANS",'002381')
Local cCondPag		 := GetNewPar("MV_MLCPPAG",'001')
Local cVend			 := GetNewPar("MV_MLVEND",'000020')
Local cNaturez		 := GetNewPar("MV_MLNATR",'101001')
Local cCliCtb		 := GetNewPar("MV_MLCLCTB",'11201000010')
Local cSerieNF		 := GetNewPar("MV_MLSERIE",'2  ')
Local aAreaSC5		 := SC5->(GetArea())
Local aAreaSB1		 := SB1->(GetArea())

PRIVATE lMsErroAuto  := .F.
Private aPedXml		 := {}
Private aCampos		 := {}
Private xCustomerID := ''
Private xEnderecoID := ''
Private aLocCp		:= {} // Campos a Serem Localizados em SOAP 1
Private lTransmite	 := GetNewPar("MV_MLTRSNF",.t.)



Default lJob		 := .F.

//cTexto  := HttpGet('http://www.sealbag.com.br/api_gmc.php')

		
// STRTRAN CORRIGINDO O FINAL DA LINHA (LF+CR). COM ISSO FICA DESNECESSÁRIA A INFORMAÇÃO DO TAMANHO DA LINHA
//cTexto	:= StrTran(cTexto, Chr(10), Chr(13)+Chr(10))


cFiltro := '{"status": [{"eq": "processing"}]}'

//array(array('status'=>array('eq'=>'processing')))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Processo de Importacao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+cTES))		// Posiciona TES Padrao
SA4->(dbSetOrder(1), dbSeek(xFilial("SA4")+cTransp))	// Posiciona Transportadora Padrão
SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+cCondPag))	// Posiciona Condicao de Pagamento Padrao

// Processando os Pedidos Efetivamente



// Mensagem se deseja importar Sim ou Nao

If !lJob
	If Empty(Len(oPedidos:OWSSALESORDERLISTENTITY))
		Alert("Sem Pedidos para Importar...")
		Return
	Else
		MsAguarde({||Inkey(3)}, "", "Existem " +alltrim(str(Len(oPedidos:OWSSALESORDERLISTENTITY)))+" Pedidos a Serem Importados !", .T.)
		If !MsgNoYes('Confirma a Carga dos '+alltrim(str(Len(oPedidos:OWSSALESORDERLISTENTITY)))+' Pedidos ?') 
			Return(.T.)
		Endif
	Endif
Endif

aErrorLog := {}
aSucesso  := {}
nRegistros:= Len(oPedidos:OWSSALESORDERLISTENTITY)
//aPeds := {'100007009'}
ProcRegua(nRegistros)
//For nPed := 1 TO Len(aPeds) //nRegistros
//	cPedWeb	:= aPeds[nPed] //	AllTrim(oPedidos:OWSSALESORDERLISTENTITY[nPed]:CINCREMENT_ID)
For nPed := 1 TO nRegistros
	cPedWeb	:= AllTrim(oPedidos:OWSSALESORDERLISTENTITY[nPed]:CINCREMENT_ID)
		
	IncProc('Processando Pedido: '+ cPedWeb + ' ('+ strzero(nPed,3)+' de '+strzero(nRegistros,3)+')')

	oSvc:salesorderinfo(cSession,cPedWeb)
	oPedDetalhe := oSvc:oWSsalesOrderInforesult
	
	oSvc:Call(cSession,'sales_order.info',cPedWeb) 
	oPdDet := oSvc:oWScallReturn
	
/*	oSvc:Call(cSession,'order_creditmemo.info',cPedWeb) 
	oPdCartao := oSvc:oWScallReturn

	oSvc:salesOrderCreditmemoInfo(cSession,cPedWeb)
	oCartaoCredito := oSvc:oWSsalesOrderCreditmemoInforesult
  */
	cIdCliente	:= xCustomerID                 
	cIdEndereco := xEnderecoID
	
	If Type("oPdDet") == 'U'
		Loop
	Endif
	
	If Empty(cIdCliente)
		cIdCliente := oPdDet:_ITEM[8]:_VALUE:TEXT	
	Endif

	If Empty(cIdCliente)
		AAdd(aErrorLog,{'Id Cliente WEB Não Localizado, Pedido Numero: ' + cPedWeb})
		Loop
	Endif	

	oSvc:Call(cSession,'customer.info',cIdCliente) 
	oCliente := oSvc:oWScallReturn

	oSvc:Call(cSession,'customer_address.info',cIdEndereco) 
	oEndCli := oSvc:oWScallReturn

	IF !VerifId(cPedWeb) .And. !lJob
		MsAguarde({||Inkey(3)}, "", "Atenção Pedido WEB " + cPedWeb + " Já Importado no Sistema Interno, por Isso o Mesmo Não Será Processado !!!" , .T.)
		AAdd(aErrorLog,{'Pedido WEB Já Importado no Sitema, Pedido Numero: ' + cPedWeb})
		oSvc:Call(cSession,'order_shipment.create',cPedWeb) 		
		Loop
	Endif
	
	If Type("oCliente") == "U"
		AAdd(aErrorLog,{'Cliente Não Identificado Pelo ID ' + cIdCliente + ', Pedido Numero: ' + cPedWeb})
		Loop
	Endif

	lCliente := .t.           
	
	cIdCliWeb	:= ''
	cCelular	:= ''
	cCpfCnpj	:= ''
	cEmail	 	:= ''
	cEmpresa 	:= ''
	cFax	 	:= ''
	cNome1	 	:= ''
	cSexo	 	:= ''
	cInscr	 	:= ''
	cNome3	 	:= ''
	cNome2	 	:= ''
	cApelido 	:= ''
	cRg		 	:= ''
	cTelefone 	:= ''
	cTipoP	 	:= ''
	cComplemento:= ''
	nValFrete	:= 0
	nValDesco	:= 0
	nPeso		:= 0
	cCompl2		:= ''
	cIdPagto 	:= ''
	
	// Localização de Campos dos Dados do Cliente
	For nPosCli := 1 To Len(oCliente:_ITEM)
		If oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'customer_id'
			cIdCliWeb	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'celular'
			cCelular	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'cpfcnpj'
			cCpfCnpj	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'email'
			cEmail	 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'empresa'
			cEmpresa 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'fax'
			cFax	 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'firstname'
			cNome1	 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'gender'
			cSexo	 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'ie'
			cInscr	 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'lastname'
			cNome3	 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'middlename'
			cNome2	 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'nome_fantasia'
			cApelido 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'rg'
			cRg		 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'telephone'
			cTelefone 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'tipopessoa'
			cTipoP	 	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		ElseIf oCliente:_ITEM[nPosCli]:_KEY:TEXT == 'taxvat' .And. Empty(cCpfCnpj)
			cCpfCnpj	:= oCliente:_ITEM[nPosCli]:_VALUE:TEXT
		Endif
	Next
		
	// Detalhes do Pedido
	
	aProd := {}
		
	For nPosPed := 1 To Len(oPdDet:_ITEM)
		If oPdDet:_ITEM[nPosPed]:_KEY:TEXT == 'shipping_description'
			cComplemento	:= oPdDet:_ITEM[nPosPed]:_VALUE:TEXT		//Correios - E-Sedex
		ElseIf oPdDet:_ITEM[nPosPed]:_KEY:TEXT == 'shipping_amount'
			nValFrete	:= Val(oPdDet:_ITEM[nPosPed]:_VALUE:TEXT)		//Frete
		ElseIf oPdDet:_ITEM[nPosPed]:_KEY:TEXT == 'discount_amount'
			nValDesco	:= Val(oPdDet:_ITEM[nPosPed]:_VALUE:TEXT)		//Desconto
		ElseIf oPdDet:_ITEM[nPosPed]:_KEY:TEXT == 'weight'
			nPeso		:= Val(oPdDet:_ITEM[nPosPed]:_VALUE:TEXT)		//Peso
		ElseIf oPdDet:_ITEM[nPosPed]:_KEY:TEXT == 'customer_note'
			cCompl2	:= oPdDet:_ITEM[nPosPed]:_VALUE:TEXT				//Notas Cliente
		ElseIf oPdDet:_ITEM[nPosPed]:_KEY:TEXT == 'payment'				
			If Type("oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM") <> "U"
				For nPosIte := 1 To Len(oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM)
					If oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_KEY:TEXT == 'additional_information'
						If Type("oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_VALUE:_ITEM[4]:_VALUE:TEXT") <> "U"
							cIdPagto	:=	oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_VALUE:_ITEM[4]:_VALUE:TEXT
						Endif
					ElseIf oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_KEY:TEXT == 'pagseguro_transaction_id' .And. Empty(cIdPagto)
						cIdPagto	:= oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_VALUE:TEXT
					Endif
				Next
			Endif
		ElseIf oPdDet:_ITEM[nPosPed]:_KEY:TEXT == 'items'

			// Obtendo Informacoes dos Itens
			
			If Type("oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM") <> "U"
				For nPosIte := 1 To Len(oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM)
					If oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM[nPosIte]:_KEY:TEXT == 'sku'
						cCodSku	:= oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM[nPosIte]:_VALUE:TEXT	// SKU
						AAdd(aProd,{cCodSku,'',0,0})
					ElseIf oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM[nPosIte]:_KEY:TEXT == 'name'
						cDescri	:= oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM[nPosIte]:_VALUE:TEXT	// Descricao
						aProd[Len(aProd),2] := cDescri
					ElseIf oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM[nPosIte]:_KEY:TEXT == 'qty_ordered'
						nQuant	:= Val(oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM[nPosIte]:_VALUE:TEXT)	// Quantidade
						aProd[Len(aProd),3] := nQuant
					ElseIf oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM[nPosIte]:_KEY:TEXT == 'price'
						nValor	:= Val(oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM:_ITEM[nPosIte]:_VALUE:TEXT)	// Valor
						aProd[Len(aProd),4] := nValor
					Endif
				Next nPosIte
			Else
				For nPosIte := 1 To Len(oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM)
					For nItemItem := 1 To Len(oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_ITEM)
						If oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_ITEM[nItemItem]:_KEY:TEXT == 'sku'
							cCodSku	:= oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_ITEM[nItemItem]:_VALUE:TEXT	// SKU
							AAdd(aProd,{cCodSku,'',0,0})
						ElseIf oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_ITEM[nItemItem]:_KEY:TEXT == 'name'
							cDescri	:= oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_ITEM[nItemItem]:_VALUE:TEXT	// Descricao
							aProd[Len(aProd),2] := cDescri
						ElseIf oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_ITEM[nItemItem]:_KEY:TEXT == 'qty_ordered'
							nQuant	:= Val(oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_ITEM[nItemItem]:_VALUE:TEXT)	// Quantidade
							aProd[Len(aProd),3] := nQuant
						ElseIf oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_ITEM[nItemItem]:_KEY:TEXT == 'price'
							nValor	:= Val(oPdDet:_ITEM[nPosPed]:_VALUE:_ITEM[nPosIte]:_ITEM[nItemItem]:_VALUE:TEXT)	// Valor
							aProd[Len(aProd),4] := nValor
						Endif
					Next nItemItem
				Next nPosIte
			Endif
		Endif
	Next nPosPed

	cCPFCliente :=	U_Limpar(cCpfCnpj)
	cCPFCliente	:= 	StrTran(AllTrim(cCPFCliente),'.','')
	cCPFCliente := 	StrTran(AllTrim(cCPFCliente),'-','')
	cCPFCliente := 	StrTran(AllTrim(cCPFCliente),'/','')
	cCPFCliente := 	StrTran(AllTrim(cCPFCliente),' ','')  
	cCPFCliente	:=  AllTrim(cCPFCliente)                  
	
	If Empty(cCPFCliente)		
		AAdd(aErrorLog,{'CPF Cliente Invalido (VAZIO) Pedido Numero: ' + cPedWeb})
		Loop
	Endif
	
	cRGCliente	:=  U_Limpar(cRg)
	cRGCliente	:= 	StrTran(AllTrim(cRGCliente),'.','')
	cRGCliente := 	StrTran(AllTrim(cRGCliente),'-','')
	cRGCliente := 	StrTran(AllTrim(cRGCliente),'/','')
	cRGCliente := 	StrTran(AllTrim(cRGCliente),' ','')  
	cRGCliente	:=  AllTrim(cRGCliente)                  

	// Busca o Cliente
	
	cEst	:= U_Estado(U_Limpar(oPedDetalhe:OWSSHIPPING_ADDRESS:CREGION))
	cCodMun := Posicione("CC2",4,xFilial("CC2")+cEst+AllTrim(U_Limpar(oPedDetalhe:OWSSHIPPING_ADDRESS:CCITY)),"CC2_CODMUN")

	If Empty(cCodMun)
		AAdd(aErrorLog,{'Cidade do Cliente WEB Não Localizado, Pedido Numero: ' + cPedWeb})
		Loop
	Endif

	Begin Transaction
	cEstC	:= U_Estado(U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CREGION))

	If !SA1->(dbSetOrder(3), dbSeek(xFilial("SA1")+cCPFCliente))
		_cNewCod := GetSxENum("SA1","A1_COD")
		ConfirmSx8()

		If RecLock("SA1",.t.)
			SA1->A1_FILIAL	:=	xFilial("SA1")
			SA1->A1_COD		:= _cNewCod
			SA1->A1_LOJA	:= "01"
			SA1->A1_CODPR	:= '07'  
			SA1->A1_PESSOA 	:= Iif(cTipoP=='1','F','J')
			SA1->A1_SEXO	:= Iif(cSexo=='1','M','F')
			SA1->A1_CGC 	:= cCPFCliente
			SA1->A1_RG		:= cRGCliente
			SA1->A1_TIPO 	:= "F"               
			SA1->A1_INSCR 	:= Iif(cTipoP=='1','',Iif(Empty(cInscr),'',cInscr))
			SA1->A1_NOME 	:= U_Limpar(AllTrim(cNome1))+ ' ' + U_Limpar(AllTrim(cNome3))	//+ ' ' + U_Limpar(AllTrim(cNome2)) 
			SA1->A1_NREDUZ 	:= U_Limpar(AllTrim(cNome1))+ ' ' + U_Limpar(AllTrim(cNome3))	//U_Limpar(AllTrim(cApelido))
			SA1->A1_CONTRIB := Iif(cTipoP=='1','2','1')
			SA1->A1_BLEMAIL	:= '2'

			cCep := U_Limpar(StrTran(StrTran(oPedDetalhe:OWSBILLING_ADDRESS:CPOSTCODE,'-',''),' ',''))

			aEnd := StrTokArr(StrTran(oPedDetalhe:OWSBILLING_ADDRESS:CSTREET,Chr(10)," |"),"|")
			aSize(aEnd,4)
			For nEnd := 1 To Len(aEnd);	If Type("aEnd[nEnd]")=='U';	aEnd[nEnd] := '';	Endif;	Next

			SA1->A1_END 	:= FwNoAccent(Upper(AllTrim(aEnd[1]) + ", " + AllTrim(aEnd[2])))
			SA1->A1_COMPLEM	:= FwNoAccent(Upper(AllTrim(aEnd[3])))
			SA1->A1_BAIRRO	:= FwNoAccent(Upper(AllTrim(aEnd[4])))
			SA1->A1_ENDCOB 	:= FwNoAccent(Upper(AllTrim(aEnd[1]) + ", " + AllTrim(aEnd[2])))
			SA1->A1_CEPC 	:= cCep
			SA1->A1_MUNC 	:= U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CCITY)
			SA1->A1_ESTC 	:= cEstC
			SA1->A1_BAIRROC	:= FwNoAccent(Upper(AllTrim(aEnd[4])))

			If Empty(aEnd[4])
				AAdd(aErrorLog,{'Campo Bairro Faturamento (VAZIO) Pedido Numero: ' + cPedWeb})
			Endif 

			cRegiao			:= U_Regiao(cEstC)

			SA1->A1_REGIAO	:= cRegiao
			SA1->A1_EST 	:=	cEstC
			SA1->A1_ESTADO	:= 	Tabela("12",cEstC)
			SA1->A1_COD_MUN := 	cCodMun     
			SA1->A1_CODPR	:= 	'07'
			SA1->A1_CEP 	:= 	cCep
			SA1->A1_MUN 	:= 	U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CCITY)
			SA1->A1_GRPVEN	:= '000006'

			cCep := U_Limpar(StrTran(StrTran(oPedDetalhe:OWSSHIPPING_ADDRESS:CPOSTCODE,'-',''),' ',''))        
				
			aEnd := StrTokArr(StrTran(oPedDetalhe:OWSSHIPPING_ADDRESS:CSTREET,Chr(10)," |"),"|")
			aSize(aEnd,4)
			For nEnd := 1 To Len(aEnd);	If Type("aEnd[nEnd]")=='U';	aEnd[nEnd] := '';	Endif;	Next
			
			SA1->A1_ENDENT 	:= FwNoAccent(Upper(AllTrim(aEnd[1]) + ", " + AllTrim(aEnd[2]))) + ' ' + AllTrim(aEnd[3])
			SA1->A1_BAIRROE	:= FwNoAccent(Upper(AllTrim(aEnd[4])))

			If Empty(aEnd[4])
				AAdd(aErrorLog,{'Campo Bairro Entrega (VAZIO) Pedido Numero: ' + cPedWeb})
			Endif 

			SA1->A1_CEPE 	:= cCep
			SA1->A1_ESTE 	:= cEst
			SA1->A1_MUNE 	:= U_Limpar(oPedDetalhe:OWSSHIPPING_ADDRESS:CCITY)
			SA1->A1_CODPAIS := "01058"
			SA1->A1_VEND 	:= cVend     
			SA1->A1_TRANSP 	:= cTransp 
			SA1->A1_PAIS 	:= '105'     
			SA1->A1_CONTATO := U_Limpar(AllTrim(cNome1))+ ' ' + U_Limpar(AllTrim(cNome3))	//+ ' ' + U_Limpar(AllTrim(cNome2)) 
			SA1->A1_EMAIL	:= Lower(U_Limpar(cEmail))
			SA1->A1_EMAIL1	:= Lower(U_Limpar(cEmail))
			SA1->A1_DDD		:= SubStr(U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CTELEPHONE),2,2)	// DDD
			SA1->A1_TEL  	:= Substr(U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CTELEPHONE),6,20)
			SA1->A1_FAX  	:= U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CFAX)
			SA1->A1_NATUREZ := cNaturez
			SA1->A1_CONTA 	:= cCliCtb
			SA1->A1_RISCO 	:= 'A'
			SA1->A1_COND  	:= cCondPag
			SA1->A1_IDCWEB	:= cIdCliente
			SA1->A1_SATIV1	:= '000037'
			SA1->(MsUnlock())
		Endif
		AAdd(aSucesso,{'Novo Cliente Inserido Com Sucesso na Base de Dados, Codigo: ' + SA1->A1_COD + ' Nome: ' + SA1->A1_NOME + ' Referente Pedido WEB: ' + cPedWeb})

/*		
		// Inclui o Cliente na MetalSeal tbém
		
		cModo := 'C'
		EmpOpenFile("SA10X","SA1",1,.T.,'02',@cModo)

		If RecLock("SA10X",.t.)
			SA10X->A1_FILIAL	:=	xFilial("SA1")
			SA10X->A1_COD		:= _cNewCod
			SA10X->A1_LOJA	:= "01"
			SA10X->A1_CODPR	:= '07'  
			SA10X->A1_PESSOA 	:= Iif(cTipoP=='1','F','J')
			SA10X->A1_SEXO	:= Iif(cSexo=='1','M','F')
			SA10X->A1_CGC 	:= cCPFCliente
			SA10X->A1_RG		:= cRGCliente
			SA10X->A1_TIPO 	:= "F"               
			SA10X->A1_INSCR 	:= Iif(cTipoP=='1','',Iif(Empty(cInscr),'',cInscr))
			SA10X->A1_NOME 	:= U_Limpar(AllTrim(cNome1))+ ' ' + U_Limpar(AllTrim(cNome3))	//+ ' ' + U_Limpar(AllTrim(cNome2)) 
			SA10X->A1_NREDUZ 	:= U_Limpar(AllTrim(cNome1))+ ' ' + U_Limpar(AllTrim(cNome3))	//U_Limpar(AllTrim(cApelido))
			SA10X->A1_CONTRIB := Iif(cTipoP=='1','2','1')
			SA10X->A1_BLEMAIL	:= '2'

			cCep := U_Limpar(StrTran(StrTran(oPedDetalhe:OWSBILLING_ADDRESS:CPOSTCODE,'-',''),' ',''))

			aEnd := StrTokArr(StrTran(oPedDetalhe:OWSBILLING_ADDRESS:CSTREET,Chr(10)," |"),"|")
			aSize(aEnd,4)
			For nEnd := 1 To Len(aEnd);	If Type("aEnd[nEnd]")=='U';	aEnd[nEnd] := '';	Endif;	Next

			SA10X->A1_END 	:= FwNoAccent(Upper(AllTrim(aEnd[1]) + ", " + AllTrim(aEnd[2])))
			SA10X->A1_COMPLEM	:= FwNoAccent(Upper(AllTrim(aEnd[3])))
			SA10X->A1_BAIRRO	:= FwNoAccent(Upper(AllTrim(aEnd[4])))
			SA10X->A1_ENDCOB 	:= FwNoAccent(Upper(AllTrim(aEnd[1]) + ", " + AllTrim(aEnd[2])))
			SA10X->A1_CEPC 	:= cCep
			SA10X->A1_MUNC 	:= U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CCITY)
			SA10X->A1_ESTC 	:= cEstC
			SA10X->A1_BAIRROC	:= FwNoAccent(Upper(AllTrim(aEnd[4])))

			If Empty(aEnd[4])
				AAdd(aErrorLog,{'Campo Bairro Faturamento (VAZIO) Pedido Numero: ' + cPedWeb})
			Endif 

			cRegiao			:= U_Regiao(cEstC)

			SA10X->A1_REGIAO	:= cRegiao
			SA10X->A1_EST 	:=	cEstC
			SA10X->A1_ESTADO	:= 	Tabela("12",cEstC)
			SA10X->A1_COD_MUN := 	cCodMun     
			SA10X->A1_CODPR	:= 	'07'
			SA10X->A1_CEP 	:= 	cCep
			SA10X->A1_MUN 	:= 	U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CCITY)
			SA10X->A1_GRPVEN	:= '000006'

			cCep := U_Limpar(StrTran(StrTran(oPedDetalhe:OWSSHIPPING_ADDRESS:CPOSTCODE,'-',''),' ',''))        
				
			aEnd := StrTokArr(StrTran(oPedDetalhe:OWSSHIPPING_ADDRESS:CSTREET,Chr(10)," |"),"|")
			aSize(aEnd,4)
			For nEnd := 1 To Len(aEnd);	If Type("aEnd[nEnd]")=='U';	aEnd[nEnd] := '';	Endif;	Next
			
			SA10X->A1_ENDENT 	:= FwNoAccent(Upper(AllTrim(aEnd[1]) + ", " + AllTrim(aEnd[2]))) + ' '
			SA10X->A1_BAIRROE	:= FwNoAccent(Upper(AllTrim(aEnd[4])))

			If Empty(aEnd[4])
				AAdd(aErrorLog,{'Campo Bairro Entrega (VAZIO) Pedido Numero: ' + cPedWeb})
			Endif 

			SA10X->A1_CEPE 	:= cCep
			SA10X->A1_ESTE 	:= cEst
			SA10X->A1_MUNE 	:= U_Limpar(oPedDetalhe:OWSSHIPPING_ADDRESS:CCITY)
			SA10X->A1_CODPAIS := "01058"
			SA10X->A1_VEND 	:= cVend     
			SA10X->A1_TRANSP 	:= cTransp 
			SA10X->A1_PAIS 	:= '105'     
			SA10X->A1_CONTATO := U_Limpar(AllTrim(cNome1))+ ' ' + U_Limpar(AllTrim(cNome3))	//+ ' ' + U_Limpar(AllTrim(cNome2)) 
			SA10X->A1_EMAIL	:= Lower(U_Limpar(cEmail))
			SA10X->A1_EMAIL1	:= Lower(U_Limpar(cEmail))
			SA10X->A1_DDD		:= SubStr(U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CTELEPHONE),2,2)	// DDD
			SA10X->A1_TEL  	:= Substr(U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CTELEPHONE),6,20)
			SA10X->A1_FAX  	:= U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CFAX)
			SA10X->A1_NATUREZ := cNaturez
			SA10X->A1_CONTA 	:= cCliCtb
			SA10X->A1_RISCO 	:= 'A'
			SA10X->A1_COND  	:= cCondPag
			SA10X->A1_IDCWEB	:= cIdCliente
			SA10X->A1_SATIV1	:= '000037'
			SA10X->(MsUnlock())
			
			SA10X->(dbCloseArea())
		Endif
		
  		*/		
	Else
		AAdd(aSucesso,{'Cliente Já Existente, Efetuada Atualizacao de Dados, Codigo: ' + SA1->A1_COD + ' Nome: ' + SA1->A1_NOME + ' Referente Pedido WEB: ' + cPedWeb})

		If RecLock("SA1",.f.)
               // Sempre Atualiza os Dados Abaixo
				
			cCep := U_Limpar(StrTran(StrTran(oPedDetalhe:OWSBILLING_ADDRESS:CPOSTCODE,'-',''),' ',''))
			aEnd := StrTokArr(StrTran(oPedDetalhe:OWSBILLING_ADDRESS:CSTREET,Chr(10)," |"),"|")
			aSize(aEnd,4)
			For nEnd := 1 To Len(aEnd);	If Type("aEnd[nEnd]")=='U';	aEnd[nEnd] := '';	Endif;	Next

			SA1->A1_END 	:= FwNoAccent(Upper(AllTrim(aEnd[1]) + ", " + AllTrim(aEnd[2])))
			SA1->A1_ENDCOB	:= FwNoAccent(Upper(AllTrim(aEnd[1]) + ", " + AllTrim(aEnd[2])))
			SA1->A1_COMPLEM	:= FwNoAccent(Upper(AllTrim(aEnd[3])))
			SA1->A1_BAIRROC	:= FwNoAccent(Upper(AllTrim(aEnd[4])))
			SA1->A1_BAIRRO	:= FwNoAccent(Upper(AllTrim(aEnd[4])))
			SA1->A1_CEPC	:= cCep
			SA1->A1_MUNC	:= U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CCITY)
			SA1->A1_ESTC	:= cEstC
			SA1->A1_CONTRIB := Iif(cTipoP=='1','2','1')

			If Empty(aEnd[4])
				AAdd(aErrorLog,{'Campo Bairro Faturamento (VAZIO) Pedido Numero: ' + cPedWeb})
			Endif 

			cRegiao			:= U_Regiao(cEstC)

			SA1->A1_REGIAO	:= cRegiao
			SA1->A1_EST 		:= cEstC
			SA1->A1_ESTADO		:= Tabela("12",cEstC)
			SA1->A1_COD_MUN 	:= cCodMun
			SA1->A1_CEP 		:= cCep
			SA1->A1_MUN 		:= U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CCITY)
			SA1->A1_SEXO		:= Iif(cSexo=='1','M','F')

				
			cCep := U_Limpar(StrTran(StrTran(oPedDetalhe:OWSSHIPPING_ADDRESS:CPOSTCODE,'-',''),' ',''))        
			aEnd := StrTokArr(StrTran(oPedDetalhe:OWSSHIPPING_ADDRESS:CSTREET,Chr(10)," |"),"|")
			aSize(aEnd,4)
			For nEnd := 1 To Len(aEnd);	If Type("aEnd[nEnd]")=='U';	aEnd[nEnd] := '';	Endif;	Next
			
			SA1->A1_ENDENT 	:= FwNoAccent(Upper(AllTrim(aEnd[1]) + ", " + AllTrim(aEnd[2]))) + ' ' + AllTrim(aEnd[3])
			SA1->A1_BAIRROE	:= FwNoAccent(Upper(AllTrim(aEnd[4])))

			If Empty(aEnd[4])
				AAdd(aErrorLog,{'Campo Bairro Entrega (VAZIO) Pedido Numero: ' + cPedWeb})
			Endif 

			SA1->A1_CEPE 	:= cCep
			SA1->A1_ESTE 	:= cEst
			SA1->A1_MUNE 	:= U_Limpar(oPedDetalhe:OWSSHIPPING_ADDRESS:CCITY)
			SA1->A1_CONTATO := U_Limpar(AllTrim(cNome1))+ ' ' + U_Limpar(AllTrim(cNome3))	//+ ' ' + U_Limpar(AllTrim(cNome2)) 
			SA1->A1_EMAIL	:= U_Limpar(cEmail)
			SA1->A1_EMAIL1	:= Lower(U_Limpar(cEmail))
			SA1->A1_DDD		:= SubStr(U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CTELEPHONE),2,2)	// DDD
			SA1->A1_TEL  	:= Substr(U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CTELEPHONE),6,20)
			SA1->A1_FAX  	:= U_Limpar(oPedDetalhe:OWSBILLING_ADDRESS:CFAX)
			SA1->A1_IDCWEB	:= cIdCliente
			SA1->A1_BLEMAIL	:= '2'
			SA1->A1_SATIV1	:= '000037'

			SA1->(MsUnlock())
		Endif		
	Endif	
	End Transaction
	
	If !lCliente
		Alert("Problemas na Geracao do Cadastro do Cliente do Pedido "+ cPedWeb + ", Verifique !!!")
		Loop
	Endif
	
	If SA1->A1_PESSOA == 'F' .And. GetMV("MV_ESTADO") <> SA1->A1_EST .And. SA1->A1_EST$GETMV("MV_UFGNRE") //'AL*AM*AP*PA*CE*DF*GO*MA*MG*MS*MT*PB*PE*PI*PR*RO*RS*SC'	// Se Estado da Empresa Diferente de Estado
		cTes	:=	'517'
	Endif


	// Efetuando EXECAUTO do Pedido de Vendas
	
	aCabPv  := {}

	dEmissao	:= CtoD(SubStr(oPedDetalhe:CCREATED_AT,9,2)+'/'+SubStr(oPedDetalhe:CCREATED_AT,6,2)+'/'+Left(oPedDetalhe:CCREATED_AT,4))
	cHorario	:= SubStr(oPedDetalhe:CCREATED_AT,12,5)
	
	cEnvio	:= Upper(cComplemento)
	If 'PAC'$cEnvio
		cTransp		 := GetNewPar("MV_MLTPAC",'PAC')
	ElseIf 'E-SEDEX'$cEnvio
		cTransp		 := GetNewPar("MV_MLTESE",'ESEDEX')
	ElseIf 'SEDEX'$cEnvio
		cTransp		 := GetNewPar("MV_MLTSED",'SEDEX')
	Endif

	
	aItemPV := {}
	nPeso	:= 0.00     
	nVolume := 1    
	nLimVol := 4
	nTotQtd := 0
						
	For nIt := 1 To Len(aProd)
		cCodProduto := aProd[nIt,1]
		cProdMtl	:= Space(15)
			
		If !SB1->(dbSetOrder(14), dbSeek(xFilial("SB1")+AllTrim(cCodProduto)))
			If !lJob
				Alert("Problema na Localização do Produto - Verifique o Parâmetro !")
				AAdd(aErrorLog,{"Problema na Localização do Produto - Verifique o Parâmetro ! Pedido Numero: " + cPedWeb})
				Return
			Else
				Conout("Problema na Localização do Produto - Verifique o Parâmetro !")
				AAdd(aErrorLog,{"Problema na Localização do Produto - Verifique o Parâmetro ! Pedido Numero: " + cPedWeb})
				Return
			Endif
		Else
			cProdMtl := SB1->B1_COD
		Endif
			
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProdMtl))

		If Empty(aProd[nIt,3])
			nQuant	:= aProd[nIt,3]*Iif(SB1->B1_CONV>0,SB1->B1_CONV,1) 
			nPeso	+= Round((SB1->B1_PESO * aProd[nIt,3]),4)
		Else
			nQuant	:= Val(oPedDetalhe:OWSITEMS:OWSSALESORDERITEMENTITY[nIT]:CQTY_ORDERED)*Iif(SB1->B1_CONV>0,SB1->B1_CONV,1)
			nPeso	+= Round((SB1->B1_PESO * Val(oPedDetalhe:OWSITEMS:OWSSALESORDERITEMENTITY[nIT]:CQTY_ORDERED)),4)
		Endif
			
		If Empty(aProd[nIt,4])
			nPrcUn	:= Round(aProd[nIt,4]/Iif(SB1->B1_CONV>0,SB1->B1_CONV,1),2)
		Else
			nPrcUn  := Round(Val(oPedDetalhe:OWSITEMS:OWSSALESORDERITEMENTITY[nIT]:CPRICE)/Iif(SB1->B1_CONV>0,SB1->B1_CONV,1),2)
		Endif
		
		nTotQtd += nQuant 
			
		aReg := {}
		AADD(aReg,{"C6_FILIAL" ,XFILIAL("SC6"),Nil})
		AADD(aReg,{"C6_ITEM"   ,StrZero(nIt,2),Nil})
		AADD(aReg,{"C6_PRODUTO",cProdMtl,Nil})
		AADD(aReg,{"C6_DESCRI" ,SB1->B1_DESC,Nil})
		AADD(aReg,{"C6_QTDVEN" ,nQuant,Nil})
		AADD(aReg,{"C6_QTDLIB" ,nQuant,Nil})
		AADD(aReg,{"C6_PRUNIT" ,nPrcUn,NIL})
		AADD(aReg,{"C6_PRCVEN" ,nPrcUn,Nil})
		AADD(aReg,{"C6_VALOR"  ,Round(nPrcUn*nQuant,2),Nil})
		AADD(aReg,{"C6_ENTREG" ,DataValida(dDataBase+2,.t.),Nil})
		AADD(aReg,{"C6_TES"    ,cTes,Nil})
		AADD(aReg,{"C6_UM"     ,SB1->B1_UM,Nil})
		AADD(aReg,{"C6_LOCAL"  ,SB1->B1_LOCPAD,Nil})
		AADD(aReg,{"C6_CLI"    ,SA1->A1_COD,Nil})
		AADD(aReg,{"C6_LOJA"   ,SA1->A1_LOJA,Nil})
		AADD(aReg,{"C6_SUGENTR",DataValida(dDataBase+2,.t.),Nil})
		aAdd(aItemPV,aReg)
			
	Next

	// Calculo do Volume limite de 4 pacotes se for 5 então tem resto de divisao e acrescenta 1 volume
	If Mod(nTotQtd,nLimVol)	= 0
		nVolume := Int((nTotQtd/nLimVol))
	Else                                 
		nVolume := Int((nTotQtd/nLimVol))
		nVolume++
	Endif      

//		nVolume		:= Int(nTotQtd/10)
		
//					{"C5_NUM"    ,cNumPed      	,Nil},; // Tipo de pedido
		
	aCabPV:={	{"C5_FILIAL" ,XFILIAL("SC5")    ,Nil},;
				{"C5_TIPO"   ,"N"         	,Nil},; // Tipo de pedido
				{"C5_CLIENTE",SA1->A1_COD  ,Nil},; // Codigo do cliente
				{"C5_LOJACLI",SA1->A1_LOJA  	,Nil},; // Loja do cliente
				{"C5_EMISSAO",dEmissao,Nil},; // 'Data de emissao
				{"C5_TRANSP",cTransp,Nil},;
				{"C5_TIPOCLI",SA1->A1_TIPO,Nil},;
				{"C5_CONDPAG",cCondPag   ,Nil},; // Codigo da condicao de pagamanto*
				{"C5_VEND1",cVend,Nil},; // Codigo da condicao de pagamanto*
				{"C5_DESC1"  ,0           	,Nil},; // Percentual de Desconto
				{"C5_TIPLIB" ,"2"         	,Nil},; // Tipo de Liberacao
				{"C5_PBRUTO" ,nPeso         	,Nil},; // Tipo de Liberacao
				{"C5_PESOL" ,nPeso   	,Nil},; // Tipo de Liberacao
				{"C5_MENNOTA" ,"Pedido: " + cPedWeb +" A/C: "+AllTrim(oPedDetalhe:OWSSHIPPING_ADDRESS:CFIRSTNAME+' '+oPedDetalhe:OWSSHIPPING_ADDRESS:CLASTNAME)+' Fone: '+oPedDetalhe:OWSSHIPPING_ADDRESS:CTELEPHONE,Nil},; // Tipo de Liberacao + ' OV:' + cOV
				{"C5_MENPAD" ,"",Nil},; // Tipo de Liberacao
 				{"C5_LIBEROK","S"         	,Nil},;
				{"C5_TPFRETE",'F',Nil},;
				{"C5_FRETE",nValFrete,Nil},;
				{"C5_DESCONT",If(nValDesco<0,nValDesco*-1,nValDesco),Nil},;
				{"C5_MOEDA",1,Nil},;
				{"C5_VOLUME1",nVolume,Nil},;
				{"C5_TXMOEDA",1,Nil},;
				{"C5_TPCARGA","2",Nil},;
				{"C5_GERAWMS","1",Nil},;
				{"C5_PEDWEB",cPedWeb,Nil},;
				{"C5_FECENT",DataValida(dDataBase+1,.t.),Nil},;
				{"C5_FATINT","N",Nil},;
				{"C5_ESPECI1",PadR("ENVELOPE",10),Nil},;
				{"C5_POLITIC","1",Nil},;
				{"C5_TPCORRE",Capital(U_Limpar(cComplemento)),Nil},;
				{"C5_IDPAY",cIdPagto,Nil},;
				{"C5_WBHORA",AllTrim(cHorario),Nil}}
	
	// Muda parametro para liberacao automatica dos pedidos de venda web

	cMvAvalEst := GetMV("MV_AVALEST")
	PutMV("MV_AVALEST",1)

	lMSErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPv,aItemPV,3)
		
	PutMV("MV_AVALEST",3) // cMvAvalEst
		
	IF lMSErroAuto
		MostraErro() // VI
		Conout("Problema na Geração do Pedido de Vendas - Verifique !")
		AAdd(aErrorLog,{"Problema na Geração do Pedido de Vendas - Verifique ! Pedido Numero: " + cPedWeb})
	Else
		// Limpa Vendedor 2 e 3 para Pedidos Sealbag

		If RecLock("SC5",.f.)                       
			SC5->C5_VEND2 	:= Space(06)
			SC5->C5_VEND3 	:= Space(06)
			SC5->C5_COMIS2	:= 0.00
			SC5->C5_COMIS3	:= 0.00
			SC5->(MsUnlock())
		Endif
                                                                                  •
		// Pedido Gerado Com Sucesso, Altera Status no Site
			
		AAdd(aSucesso,{'Pedido Inserido Com Sucesso Sob o Numero: ' + SC5->C5_NUM + ' Referente Pedido WEB: ' + cPedWeb})
			
		oSvc:Call(cSession,'order_shipment.create',cPedWeb) 
		
		AAdd(aSucesso,{'Status Pedido WEB Alterado para Completo com Sucesso, Pedido WEB: ' + cPedWeb})

//		If cTes=='517'
//			Conout("Atenção Para as Vendas Fora de SP Não Contribuinte a Geração de Nota deverá ser efetuada Manualmente - Pedido " + SC5->C5_NUM + " Municipio: " + SA1->A1_MUN +" - Verifique !")
//			AAdd(aErrorLog,{"Geração de Nota Não Contribuinte devera ser efetuada Manualmente - Pedido de Vendas " + SC5->C5_NUM + " Municipio: " + SA1->A1_MUN + " -  Verifique ! Pedido Web: " + cPedWeb})				
//		Else
			If !U_GerNF(SC5->C5_NUM,cSerieNF)                                   
				Conout("Problema na Geração da Nota Fiscal - Pedido " + SC5->C5_NUM + " - Verifique !")
				AAdd(aErrorLog,{"Problema na Geração da Nota Fiscal - Pedido de Vendas " + SC5->C5_NUM + " -  Verifique ! Pedido Web: " + cPedWeb})				
			Else
				AAdd(aSucesso,{'Nota Fiscal Gerada Com Sucesso Numero ' + SF2->F2_DOC + ' Pedido WEB: ' + cPedWeb + " UF/Municipio: " + SA1->A1_EST+'/'+SA1->A1_MUN})
				If lTransmite
					AAdd(aSucesso,{'Nota Fiscal TRANSMITIDA AUTOMATICAMENTE - CHECAR STATUS E IMPRIMIR DANFE ' + SF2->F2_DOC + ' Pedido WEB: ' + cPedWeb + " UF/Municipio: " + SA1->A1_EST+'/'+SA1->A1_MUN})
				Endif
				AAdd(aSucesso,{''})
			Endif
//		Endif
	Endif
Next nPed
If Len(aErrorLog) > 0 .Or. Len(aSucesso) > 0
	cMensagem := 'Log de Processamento de Importação Pedidos WEB na Data de ' + DtoC(dDataBase)+' as ' + Time() + '<BR><BR>'
	If Len(aErrorLog) > 0
		cMensagem += 'Problemas Detectados <BR>'
		cMensagem += '==================== <BR>'
	Endif
	For nI := 1 To Len(aErrorLog)
		cMensagem += aErrorLog[nI,1] + '<BR>'
	Next                                     
	cMensagem += '<BR><BR>'
	If Len(aErrorLog) > 0
		cMensagem += 'Sucessos <BR>'
		cMensagem += '======== <BR>'
	Endif
	For nI := 1 To Len(aSucesso)
		cMensagem += aSucesso[nI,1] + '<BR>'
	Next                                     
	
	cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
	cDe			:= RTrim(SuperGetMV("MV_RELFROM"))
	cPara		:= RTrim(SuperGetMV("MV_MLEMLOG")) //'marcel.hozawa@metalacre.com.br;lalberto@3lsystems.com.br'
	cAssunto	:= 'Erros e/ou Sucessos Apresentados na Importação de Pedidos WEB'
	cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
	cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
	aAnexos		:= {}

	EnvMail(cAccount	,cPassword	,cServer	,cDe  , cPara  ,cAssunto, cMensagem, aAnexos)                             
Endif
Return

User Function Limpar(cTxt)
Local cRet := ''
Local nX := 0  
If cTxt == Nil
	Return cTxt
ElseIf Empty(cTxt)
	Return cTxt
ElseIf ValType("cTxt") <> "C"
	Return cTxt
Endif


cTxt := StrTRAN(cTxt,CHR(13)," ")
cTxt := StrTRAN(cTxt,CHR(10)," ")
cTxt := Upper(strtran(cTxt,'Ã£','A'))
cTxt := Upper(strtran(cTxt,'Ã©','E'))

For nX := 1 To Len(cTxt)
	If SubStr(cTxt,nX,1) $ 'ÃÁÂÀÇÉÊÈÍÎÌÓÕÔÒÚÛÙãáâàçéêèíîìóõôòúûù"~-/\ªº©'
		If SubStr(cTxt,nX,1) == '"'
			cRet += ''
		ElseIf SubStr(cTxt,nX,1) == '~'
			cRet += ''
		ElseIf SubStr(cTxt,nX,1) == '/'
			cRet += ''
		ElseIf SubStr(cTxt,nX,1) == '\'
			cRet += ''
		ElseIf SubStr(cTxt,nX,1) == '-'
			cRet += ''
		ElseIf SubStr(cTxt,nX,1) == '©'
			cRet += 'E'
		ElseIf SubStr(cTxt,nX,1) == 'Ã'
			cRet += 'A'
		ElseIf SubStr(cTxt,nX,1) == 'Á'
			cRet += 'A'
		ElseIf SubStr(cTxt,nX,1) == 'Â'
			cRet += 'A'
		ElseIf SubStr(cTxt,nX,1) == 'À'
			cRet += 'A'
		ElseIf SubStr(cTxt,nX,1) == 'Ç'
			cRet += 'C'
		ElseIf SubStr(cTxt,nX,1) == 'É'
			cRet += 'E'
		ElseIf SubStr(cTxt,nX,1) == 'Ê'
			cRet += 'E'
		ElseIf SubStr(cTxt,nX,1) == 'È'
			cRet += 'E'
		ElseIf SubStr(cTxt,nX,1) == 'Í'
			cRet += 'I'
		ElseIf SubStr(cTxt,nX,1) == 'Î'
			cRet += 'I'
		ElseIf SubStr(cTxt,nX,1) == 'Ì'
			cRet += 'I'
		ElseIf SubStr(cTxt,nX,1) == 'Ó'
			cRet += 'O'
		ElseIf SubStr(cTxt,nX,1) == 'Õ'
			cRet += 'O'
		ElseIf SubStr(cTxt,nX,1) == 'Ô'
			cRet += 'O'
		ElseIf SubStr(cTxt,nX,1) == 'Ò'
			cRet += 'O'
		ElseIf SubStr(cTxt,nX,1) == 'Ú'
			cRet += 'U'
		ElseIf SubStr(cTxt,nX,1) == 'Û'
			cRet += 'U'
		ElseIf SubStr(cTxt,nX,1) == 'Ù'
			cRet += 'U'
		ElseIf SubStr(cTxt,nX,1) == 'ã'
			cRet += 'A'
		ElseIf SubStr(cTxt,nX,1) == 'á'
			cRet += 'A'
		ElseIf SubStr(cTxt,nX,1) == 'â'
			cRet += 'A'
		ElseIf SubStr(cTxt,nX,1) == 'à'
			cRet += 'A'
		ElseIf SubStr(cTxt,nX,1) == 'ç'
			cRet += 'C'
		ElseIf SubStr(cTxt,nX,1) == 'é'
			cRet += 'E'
		ElseIf SubStr(cTxt,nX,1) == 'ê'
			cRet += 'E'
		ElseIf SubStr(cTxt,nX,1) == 'è'
			cRet += 'E'
		ElseIf SubStr(cTxt,nX,1) == 'í'
			cRet += 'I'
		ElseIf SubStr(cTxt,nX,1) == 'î'
			cRet += 'I'
		ElseIf SubStr(cTxt,nX,1) == 'ì'
			cRet += 'I'
		ElseIf SubStr(cTxt,nX,1) == 'ó'
			cRet += 'O'
		ElseIf SubStr(cTxt,nX,1) == 'õ'
			cRet += 'O'
		ElseIf SubStr(cTxt,nX,1) == 'ô'
			cRet += 'O'
		ElseIf SubStr(cTxt,nX,1) == 'ò'
			cRet += 'O'
		ElseIf SubStr(cTxt,nX,1) == 'ú'
			cRet += 'U'
		ElseIf SubStr(cTxt,nX,1) == 'û'
			cRet += 'U'
		ElseIf SubStr(cTxt,nX,1) == 'ù'
			cRet += 'U'
		ElseIf SubStr(cTxt,nX,1) == 'ª'
			cRet += 'a'
		ElseIf SubStr(cTxt,nX,1) == 'º'
			cRet += 'o'
		EndIf
	Else
		cRet += SubStr(cTxt,nX,1)
	EndIf
	
next nX

Return AllTrim(cRet)


STATIC FUNCTION VerifId(cIdPed)
Local _lRet		:= .t.
Local _cQuery	:= ""
Local _cAlias	:= Alias()

_cQuery += "SELECT COUNT(*) AS CNT FROM " + RetSqlName("SC5") + " "
_cQuery += "WHERE D_E_L_E_T_ = ' ' "
_cQuery += "AND C5_PEDWEB = '" + Alltrim(cIdPed) + "' "

DbUseArea(.t., "TOPCONN", TcGenQry(,, _cQuery), "TBUA", .t., .t.)

_lRet	:= (TBUA->CNT == 0)

TBUA->(DbCloseArea())

IF !Empty(Alltrim(_cAlias)) .AND. Select(_cAlias) > 0
	DbSelectArea(_cAlias)
ENDIF
Return(_lRet)



User Function GerNF(cNumPed,cSerieNF)
Local aArea := GetArea()       
Local aPvlNfs := {}
Local aBloqueio := {} 

dbSelectArea("SX1")
dbSetOrder(1)

If DbSeek(PadR("MT460A",10)+"17")
   RecLock("SX1",.F.)
   SX1->X1_CNT01 := '1'
   MsUnlock()
Endif
If DbSeek(PadR("MT460A",10)+"24")
   RecLock("SX1",.F.)
   SX1->X1_CNT01 := '1'
   MsUnlock()
Endif
If DbSeek(PadR("MT460A",10)+"25")
   RecLock("SX1",.F.)
   SX1->X1_CNT01 := '1'
   MsUnlock()
Endif

Pergunte("MT460A",.F.)
 
cAliasSC5 := "TRB1"
cAliasSC6 := "TRB1"   
cAliasSC9 := "TRB1"
cAliasSF4 := "TRB1"
                               
aStruSC5  := SC5->(dbStruct())
aStruSC6  := SC6->(dbStruct())
aStruSC9  := SC9->(dbStruct())
aStruSF4  := SF4->(dbStruct())
 
// TRATAMENTO PARA SÉRIE
                
//cSerieNF := '1  '//Iif(SM0->M0_CODFIL == '01','10 ','2  ')
aPvlNfs := {}
 
nTotC9 := nTotC6 := nIcmRet := 0.00
 
SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNumPed)) 
If Empty(SC5->C5_VOLUME1)
	MsAguarde({||Inkey(3)}, "", 'Atenção Pedido sem Quantidade de Volume Informado ! ', .T.)
	RestArea(aArea)
	Return .f.
Endif
 
_cPedido := SC5->C5_NUM
                    //abre os itens dos pedidos
SC9->(dbSetOrder(1), dbSeek(xFilial("SC9")+SC5->C5_NUM))            
		                    
SC6->(dbSetOrder(1))
SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))
                                        
SE4->(DbSetOrder(1))
SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG) )  //FILIAL+CONDICAO PAGTO

SC9->(DbSetOrder(1))
SC9->(MsSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))) //FILIAL+NUMERO+ITEM
While SC9->(!EOF()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == SC5->C5_NUM
	If !Empty(SC9->C9_NFISCAL)
		SC9->(dbSkip())
		aPvlNfs := {}
		RETURN .F.
	EndIf
                                               
	SC6->(dbSetOrder(1))
	SC6->(MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
			
	SB1->(DbSetOrder(1))
	SB1->(MsSeek(xFilial("SB1")+SC9->C9_PRODUTO))    //FILIAL+PRODUTO
                                  
	SB2->(DbSetOrder(1))
	SB2->(MsSeek(xFilial("SB2")+SC9->(C9_PRODUTO+C9_LOCAL))) //FILIAL+PRODUTO+LOCAL
                                                   
	SF4->(DbSetOrder(1))
	SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))   //FILIAL+TES
                                                   
	nPrcVen := SC9->C9_PRCVEN
	If ( SC5->C5_MOEDA <> 1 )
		nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,DataValida(dDataBase,.t.))
	EndIf
                
	CONOUT(ALLTRIM(STR(SC9->C9_QTDLIB)+"-"+SC9->C9_NFISCAL))
	Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
                           SC9->C9_ITEM,;
                           SC9->C9_SEQUEN,;
                           SC9->C9_QTDLIB,;
                           nPrcVen,;
                           SC9->C9_PRODUTO,;
                           SF4->F4_ISS=="S",;
                           SC9->(RecNo()),;
                           SC5->(RecNo()),;
                           SC6->(RecNo()),;
                           SE4->(RecNo()),;
                           SB1->(RecNo()),;
                           SB2->(RecNo()),;
                           SF4->(RecNo()),;
                           SB2->B2_LOCAL,;
                           0,;
                           SC9->C9_QTDLIB2})
                                                   
	dbSelectArea("SC9")
	dbSkip()
End
                                        
If Len(aPvlNfs) > 0
                               //EMITE A ULTIMA NF
	cNota := MaPvlNfs(aPvlNfs,cSerieNF, .F.    , .F.    , .F.     , .T.    , .F.    , 0      , 0          , .F.  ,.F.)
                               
	nRecSf2 := SF2->(Recno())
                
	cNumero := SF2->F2_DOC
	aGnRe := {}
	aRecTit := {}     
	aDSF2 := {}     
	lConfTit := .f.
                               
	SF2->(dbGoto(nRecSf2))
                
	MsAguarde({||Inkey(3)}, "", 'Nota Gerada Com Sucesso ! ' + cNota + " Aguarde Transmitindo ao Sefaz...", .T.)
		
	If lTransmite	// Efetua a Transmissão Automatica da Nota para o SEFAZ
		NfeTrans()
	Endif
Else
	MsAguarde({||Inkey(3)}, "", 'Pedido com Algum Tipo de Restrição ! ', .T.)
Endif

RestArea(aArea)
Return .t.


User Function Estado(cEstado)
Local aEstados := {}
Local nAchou := 0

DEFAULT cEstado := 'SAO PAULO'

// Lista de Estados Brasileiros para Identificacao da Sigla UF

AAdd(aEstados,{'ACRE','AC'})
AAdd(aEstados,{'ALAGOAS','AL'})
AAdd(aEstados,{'AMAPA','AP'})
AAdd(aEstados,{'AMAZONAS','AM'})
AAdd(aEstados,{'BAHIA','BA'})
AAdd(aEstados,{'CEARA','CE'})
AAdd(aEstados,{'DISTRITO FEDERAL','DF'})
AAdd(aEstados,{'ESPIRITO SANTO','ES'})
AAdd(aEstados,{'GOIAS','GO'})
AAdd(aEstados,{'MARANHAO','MA'})
AAdd(aEstados,{'MATO GROSSO','MT'})
AAdd(aEstados,{'MATO GROSSO DO SUL','MS'})
AAdd(aEstados,{'MINAS GERAIS','MG'})
AAdd(aEstados,{'PARA','PA'})
AAdd(aEstados,{'PARAIBA','PB'})
AAdd(aEstados,{'PARANA','PR'})
AAdd(aEstados,{'PERNAMBUCO','PE'})
AAdd(aEstados,{'PIAUI','PI'})
AAdd(aEstados,{'RIO DE JANEIRO','RJ'})
AAdd(aEstados,{'RIO GRANDE DO NORTE','RN'})
AAdd(aEstados,{'RIO GRANDE DO SUL','RS'})
AAdd(aEstados,{'RONDONIA','RO'})
AAdd(aEstados,{'RORAIMA','RR'})
AAdd(aEstados,{'SANTA CATARINA','SC'})
AAdd(aEstados,{'SAO PAULO','SP'})
AAdd(aEstados,{'SERGIPE','SE'})
AAdd(aEstados,{'TOCANTINS','TO'})


nAchou := Ascan(aEstados,{|x| AllTrim(x[1]) == AllTrim(Upper(cEstado))} )
If !Empty(nAchou)
	cEstado := aEstados[nAchou,2]
Else
	cEstado	:= ''
Endif
Return cEstado

User Function LiberaPedido(cNumPed)
Local aArea := GetArea()

dbSelectArea("SC6")
DBSetOrder(1)
MsSeek( xFilial("SC6") + cNumPed )

nValTot := 0
While !EOF() .And. C6_NUM == cNumPed
     nValTot += SC6->C6_VALOR
     
     If RecLock("SC5")
          nQtdLib := SC6->C6_QTDVEN
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³Recalcula a Quantidade Liberada                                         ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          RecLock("SC6") //Forca a atualizacao do Buffer no Top

          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³Libera por Item de Pedido                                               ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          Begin Transaction
          /*
          ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
          ±±³Funcao    ³MaLibDoFat³ Autor ³Eduardo Riera          ³ Data ³09.03.99 ³±±
          ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
          ±±³Descri?.o ³Liberacao dos Itens de Pedido de Venda                      ³±±
          ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
          ±±³Retorno   ³ExpN1: Quantidade Liberada                                  ³±±
          ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
          ±±³Transacao ³Nao possui controle de Transacao a rotina chamadora deve    ³±±
          ±±³          ³controlar a Transacao e os Locks                            ³±±
          ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
          ±±³Parametros³ExpN1: Registro do SC6                                      ³±±
          ±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
          ±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
          ±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
          ±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
          ±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
          ±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
          ±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
          ±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
          ±±³          ³       apenas avalia ).                                    ³±±
          ±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
          ±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
          ±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
          ±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
          ±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
          ±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
          */
          MaLibDoFat(SC6->(RecNo()),@nQtdLib,.T.,.T.,.T.,.T.,.F.,.F.)
          End Transaction
     EndIf
     SC5->(MsUnlock())
     SC6->(MsUnLock())
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³Atualiza o Flag do Pedido de Venda                                      ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     Begin Transaction
     SC6->(MaLiberOk({cNumPed},.F.))
     End Transaction
     
     RecLock("SC6") //Forca a atualizacao do Buffer no Top
  	 SC6->C6_QTDLIB := nQtdLib
  	 SC6->(MsUnlock())

     dbSelectArea("SC6")
     dbSkip()
End            
RestArea(aArea)
Return .t.



				
Static Function EnvMail(cAccount	,cPassword	,cServer	,cFrom,	cEmail ,cAssunto, cMensagem, aAttach)

Local cEmailTo := ""							// E-mail de destino
Local cEmailBcc:= ""							// E-mail de copia
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cEmailTo := cEmail
If At(";",cEmail) > 0 // existe um segundo e-mail.
	cEmailBcc:= SubStr(cEmail,At(";",cEmail)+1,Len(cEmail))
Endif	

CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult

// Se a conexao com o SMPT esta ok
If lResult

	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	If lRelauth
		lRet := Mailauth(cConta,cSenhaTK)	
	Else
		lRet := .T.	
    Endif    

	cAnexos:=''
	
	If lRet
		SEND MAIL FROM cFrom ;
		TO      	cEmailTo;
		SUBJECT 	cAssunto;
		BODY    	cMensagem;
		RESULT lResult
					//danfe_000055024_000055024.pdf
//		ATTACHMENT  cAnexos  ;
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
				Help(" ",1,'Erro no Envio do Email',,cError+ " " + cEmailTo,4,5)	//Atenção
		Endif

	Else
		GET MAIL ERROR cError
		Help(" ",1,'Autenticação',,cError,4,5)  //"Autenticacao"
		MsgStop('Erro de Autenticação','Verifique a conta e a senha para envio') 		 //"Erro de autenticação","Verifique a conta e a senha para envio"
	Endif
		
	DISCONNECT SMTP SERVER
	
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
Endif

Return(lResult)




Static Function NfeTrans()
Local aArea := GetArea()

	AutoNfeEnv(cEmpAnt,SF2->F2_FILIAL,"0","1",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)

RestArea(aArea)	
Return

//Parametros AutoNfeEnv : 
//cEmpresa, 
//cFilial, 
//cEspera, 
//cAmbiente (1=producao,2=Homologacao) Muito cuidado.
//cSerie
//cDoc.Inicial
//cDoc.Final



User Function Regiao(cEstado)
Local aRegiao := {}
Local nAchou := 0

// Lista de Estados Brasileiros para Identificacao da Sigla UF

AAdd(aRegiao,{'300','AC'})
AAdd(aRegiao,{'400','AL'})
AAdd(aRegiao,{'300','AP'})
AAdd(aRegiao,{'300','AM'})
AAdd(aRegiao,{'400','BA'})
AAdd(aRegiao,{'400','CE'})
AAdd(aRegiao,{'500','DF'})
AAdd(aRegiao,{'200','ES'})
AAdd(aRegiao,{'500','GO'})
AAdd(aRegiao,{'400','MA'})
AAdd(aRegiao,{'500','MT'})
AAdd(aRegiao,{'500','MS'})
AAdd(aRegiao,{'200','MG'})
AAdd(aRegiao,{'300','PA'})
AAdd(aRegiao,{'400','PB'})
AAdd(aRegiao,{'100','PR'})
AAdd(aRegiao,{'400','PE'})
AAdd(aRegiao,{'400','PI'})
AAdd(aRegiao,{'200','RJ'})
AAdd(aRegiao,{'400','RN'})
AAdd(aRegiao,{'100','RS'})
AAdd(aRegiao,{'300','RO'})
AAdd(aRegiao,{'300','RR'})
AAdd(aRegiao,{'100','SC'})
AAdd(aRegiao,{'200','SP'})
AAdd(aRegiao,{'400','SE'})
AAdd(aRegiao,{'500','TO'})

nAchou := Ascan(aRegiao,{|x| AllTrim(x[1]) == AllTrim(Upper(cEstado))} )
If !Empty(nAchou)
	cRegiao := aRegiao[nAchou,2]
Else
	cRegiao	:= '200'
Endif
Return cRegiao
