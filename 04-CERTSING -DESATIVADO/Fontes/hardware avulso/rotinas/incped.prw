#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCPED    ºAutor  ³Darcio R. Sporl     º Data ³  09/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para fazer a inclusao de pedido de vendas     º±±
±±º          ³via web service                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OPVS Consultores Associados                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IncPed(cId,aParam,aProdutos)

//----------------------//
//aParam[1] - nOpc      //
//aParam[2] - cTipo     //
//aParam[3] - cCliente  //
//aParam[4] - cLjCli    //
//aParam[5] - cTpCli    //
//aParam[6] - cForPag   //
//aParam[7] - dEmissao  //
//aParam[8] - cPosGAR   //
//aParam[9] - cPosLoj   //
//aParam[10] - cForPag  //
//aParam[11] - cNumCar  //
//aParam[12] - cNomTit  //
//aParam[13] - cCodSeg  //
//aParam[14] - dDtVali  //
//aParam[15] - nParcel  //
//aParam[16] - cTipCar  //
//aParam[17] - cNpSite  //
//aParam[18] - cLinDig  //
//aParam[19] - cNumVou  //
//aParam[20] - nQtdVou  //
//aParam[21] - cTabela1 //
//----------------------//

Local aCabPV		:= {}
Local aItemPV		:= {}
Local aItemPV1		:= {}
Local nI			:= 0
Local lRet			:= .T.
Local cMsg			:= ""
Local cNumPed		:= ""
Local cNaturez		:= GetNewPar("MV_XNATCLI", "FT010010")
Local cCategoSFW	:= GetNewPar("MV_GARSFT", "2")
Local cCategoHRD	:= GetNewPar("MV_GARHRD", "1")
Local cPrefix		:= GetNewPar("MV_XPREFHD", "VDI")
Local cCondPag		:= GetNewPar("MV_XCPSITE", "001")
Local cVendedor		:= GetNewPar("MV_XVENSIT", "000001")
Local cGerPR		:= GetNewPar("MV_XSITEPR", "0") 
Local nTotPed		:= 0
Local aRetTit		:= {}
Local aRetFat		:= {}
Local cNosso		:= ""
Local nItem			:= 0
Local nPosItem		:= 0
Local lFatFil	:= .F.
Local cEmpOld 	:= ""
Local cFilOld 	:= ""

Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()
Private lMsErroAuto 	:= .F.

//dEmissao := stod("20110517")
//Cabecalho

varinfo("APARAM",aParam)
//Conout("NATUREZA: " + cNaturez)
//cNumPed := GetSXENum('SC5','C5_NUM')
//{"C5_NUM"		,cNumPed	,Nil},; // Numero do pedido
aCabPV:={	{"C5_TIPO"		,aParam[2]	,Nil},; // Tipo de pedido
			{"C5_CLIENTE"	,aParam[3]	,Nil},; // Codigo do cliente
			{"C5_LOJACLI"	,aParam[4]	,Nil},; // Loja do cliente
			{"C5_TIPOCLI"	,aParam[5]	,Nil},; // Codigo do tipo de cliente.(R = Revendedor, S = Solidario, F = Consumidor Final)
			{"C5_CONDPAG"	,cCondPag	,Nil},; // Codigo da condicao de pagamanto
			{"C5_EMISSAO"	,aParam[7]	,Nil},; // Data de emissao
			{"C5_CLIENT"	,aParam[3]	,Nil},; // Indica o cliente em cujo estado (UF) os produtos/servicos serao entregues.
			{"C5_LOJAENT"	,aParam[4]	,Nil},; // Loja para entrada
			{"C5_TABELA"	,aParam[21]	,Nil},; // Tabela de preco
			{"C5_VEND1"		,cVendedor	,Nil},; // Vendedor
			{"C5_XNATURE"	,cNaturez	,Nil},; // Natureza Certisign
			{"C5_TIPMOV"	,aParam[10]	,Nil},; // Forma de pagamento escolhida no site
			{"C5_XFORPGT"	,aParam[10]	,Nil},; // Forma de pagamento escolhida no site
			{"C5_XNUMCAR"	,aParam[11]	,Nil},; // Numero do cartao de credito
			{"C5_XNOMTIT"	,aParam[12]	,Nil},; // Nome do titular do cartao de credito
			{"C5_XCODSEG"	,aParam[13]	,Nil},; // Codigo de seguranca do cartao de credito
			{"C5_XDTVALI"	,aParam[14]	,Nil},; // Data de validade do cartao de credito
			{"C5_XNPARCE"	,aParam[15]	,Nil},; // Numero de parcelas para dividir no cartao de credito
			{"C5_XTIPCAR"	,aParam[16]	,Nil},; // Bandeira do cartao de credito 1-Visa, 2-Master e 3-American Express
			{"C5_XNPSITE"	,aParam[17]	,Nil},; // Numero do pedido gerado pelo site
			{"C5_XLINDIG"	,aParam[18]	,Nil},; // Numero da linha digitavel do boleto
			{"C5_XNUMVOU"	,aParam[19]	,Nil},; // Numero do voucher
			{"C5_XQTDVOU"	,aParam[20]	,Nil},; // Quantidade consumida pelo voucher
			{"C5_XPOSTO"	,aParam[8]	,Nil} }	// Codigo do Posto GAR

//Items

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³[1]Item              ³
//³[2]Codigo Produto    ³
//³[3]Quantidade        ³
//³[4]Valor Unitario    ³
//³[5]Valor com desconto³
//³[6]Valor Total       ³
//³[7]Codigo Produto GAR³
//³[8]Codigo Combo      ³
//³[9]Data da Entrega   ³
//³[10]TES              ³
//³[11]Numero Voucher   ³
//³[12]Saldo Voucher    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nI := 1 To Len(aProdutos)
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1") + aProdutos[nI,2])
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1") +aParam[3]+aParam[4])
	
	//{"C6_NUM"		,cNumped				,Nil},; // Numero do Pedido
	AADD(aItemPV,{	{"C6_ITEM"		,aProdutos[nI,1]		,Nil},; // Numero do Item no Pedido
					{"C6_PRODUTO"	,aProdutos[nI,2]		,Nil},; // Codigo do Produto
					{"C6_QTDVEN"	,Val(aProdutos[nI,3])	,Nil},; // Quantidade Vendida   ***
					{"C6_PRUNIT"	,Val(aProdutos[nI,5])	,Nil},; // PRECO DE LISTA      ***
					{"C6_PRCVEN"	,Val(aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
					{"C6_VALOR"		,Val(aProdutos[nI,3]) * Val(aProdutos[nI,5])	,Nil},; // Valor Total do Item        ***
					{"C6_OPER"		,IIF(SB1->B1_CATEGO $ cCategoHRD, "52", "51")	,Nil},; // Operação de faturamento    ***
					{"C6_XOPER"		,IIF(SB1->B1_CATEGO $ cCategoHRD, "52", "51")	,Nil},; // Operação de faturamento    ***
					{"C6_ENTREG"	,aProdutos[nI,7]		,Nil},; // Data da Entrega
					{"C6_XNUMVOU"	,aProdutos[nI,9]		,Nil},; // Numero do Voucher
					{"C6_XQTDVOU"	,aProdutos[nI,10]		,Nil}}) // Quantidade do Voucher
	nTotPed += Val(aProdutos[nI,3]) * Val(aProdutos[nI,4])

	If SB1->B1_CATEGO $ cCategoHRD

		//{"C6_NUM"		,cNumped				,Nil},; // Numero do Pedido
		AADD(aItemPV,{	{"C6_ITEM"		,Soma1(aProdutos[nI,1])	,Nil},; // Numero do Item no Pedido
						{"C6_PRODUTO"	,aProdutos[nI,2]		,Nil},; // Codigo do Produto
						{"C6_QTDVEN"	,Val(aProdutos[nI,3])	,Nil},; // Quantidade Vendida   ***
						{"C6_PRUNIT"	,Val(aProdutos[nI,5])	,Nil},; // PRECO DE LISTA      ***
						{"C6_PRCVEN"	,Val(aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
						{"C6_VALOR"		,Val(aProdutos[nI,3]) * Val(aProdutos[nI,5])	,Nil},; // Valor Total do Item        ***
						{"C6_OPER"		,"53"					,Nil},; // Valor Total do Item        ***					
						{"C6_XOPER"		,"53"					,Nil},; // Valor Total do Item        ***					
						{"C6_ENTREG"	,aProdutos[nI,7]		,Nil},; // Data da Entrega
						{"C6_XNUMVOU"	,aProdutos[nI,9]		,Nil},; // Numero do Voucher
						{"C6_XQTDVOU"	,aProdutos[nI,10]		,Nil}}) // Quantidade do Voucher	
	
	EndIf
Next nI

//					{"C6_VALOR"		,Val(aProdutos[nI,6])	,Nil},; // Valor Total do Item        ***
For nItem := 1 to Len(aItemPV)
	nPosItem := aScan(aItemPV[nItem], {|x| AllTrim(x[1]) == "C6_ITEM"})
	aItemPV[nItem][nPosItem][2] := StrZero(nItem, TamSX3("C6_ITEM")[1])
Next nItem

cEmpOld := cEmpAnt
cFilOld := cFilAnt
//Renato Ruy - 13/08/2018
//Tratamento sera incluido em todas rotinas para compatibilizacao de CFOP.
If AllTrim(SA1->A1_EST)=="RJ"
	STATICCALL( VNDA190, FATFIL, nil ,"01" )
Endif

MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,aParam[1])

If cFilOld <> cFilAnt
	STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
Endif


If lMsErroAuto
	MOSTRAERRO()
	DisarmTransaction()
	cAutoErr := "SC5, SC6 --> Erro de inclusão de pedido de vendas na rotina padrão do sistema Protheus MSExecAuto({|x,y,z| MATA410(x,y,z)}, aAutoSC5, aAutoSC6, 3)" + CRLF + CRLF
	aAutoErr := GetAutoGRLog()
	For nI := 1 To Len(aAutoErr)
		cAutoErr += aAutoErr[nI] + CRLF
	Next nI
                                                                                       
	aRet := {}
	Aadd( aRet, .F. )
	Aadd( aRet, "E00001" )
	Aadd( aRet, aParam[17] )
	Aadd( aRet, "" )

	lRet := .F.
	cMsg := 'O pedido não pôde ser incluído.'
	U_GTPutOUT(cId,"P",aParam[17],{"u_IncPed",{"P",aRet},"Inconsistência ao Gerar Pedido",VarInfo("",aCabPV,,.f.,.f.),VarInfo("",aItemPV,,.f.,.f.),cAutoErr})
	cNumPed := ""
Else
	DbSelectArea("SC5")
	//DbSetOrder(8)
	SC5->(DbOrderNickName("PEDSITE"))//Alterado por LMS em 03-01-2013 para virada
	If DbSeek(xFilial("SC5") + aParam[17])
		
		RecLock("SC5", .F.)
			SC5->C5_LIBEROK = ''
			SC5->C5_XORIGPV = '3'
			SC5->(MsUnlock())
		
		DbSelectArea("SC6")
		DbSetOrder(1)
		If DbSeek(xFilial("SC6") + cNumPed)
		
			aRet := {}
			Aadd( aRet, .T. )
			Aadd( aRet, "M00001" )
			Aadd( aRet, aParam[17] )
			Aadd( aRet, "" )
		
			Alert("Inclusao efetuada com sucesso!!!")
			cMsg := 'Pedido incluído com sucesso'
			U_GTPutOUT(cId,"P",aParam[17],{"u_IncPed",{"P",aRet},"Pedido Gerado com Sucesso",VarInfo("",aCabPV,,.f.,.f.),VarInfo("",aItemPV,,.f.,.f.)})
		EndIf
		
	EndIf
EndIf


// Caso Forma de Pagamento seja Boleto Gera Título Provisório no Financeiro, caso contrário Fatura Pedido
If !empty(cNumPed)
	If aParam[10] == "1" .and.  cGerPR == "1" 
		cNosso 	:= SubStr(aParam[18],8,2)+SubStr(aParam[18],12,5)
		aRetTit	:= U_IncTitE1(3,cPrefix,cNumPed,"","PR",cNaturez,aParam[3],aParam[4],aParam[7],aParam[7],nTotPed,cNosso,aParam[17])
		lRet	:= aRetTit[1]
		cMsg 	:= aRetTit[2]
		
		aRet := {}
		Aadd( aRet, lRet)
		Aadd( aRet, "M00001" )
		Aadd( aRet, aParam[17] )
		Aadd( aRet, "" )
		
		If lRet
			U_GTPutOUT(cId,"T",aParam[17],{"u_IncTitE1",{"T",aRet},"Título Incluído com Sucesso",VarInfo("",aRetTit[3],,.f.,.f.)})
		Else
			U_GTPutOUT(cId,"T",aParam[17],{"u_IncTitE1",{"T",aRet},"Inconsistência ao Incluir o Título",VarInfo("",aRetTit[3],,.f.,.f.)})
		EndIf 
	ElseIf aParam[10] <> "1"  
	
		aRetFat	:= U_GERFAT(cNumPed, Val(aParam[17]))
		lRet	:= aRetFat[1]
		cMsg 	:= aRetFat[2] 
	    
		aRet := {}
		Aadd( aRet, lRet)
		Aadd( aRet, IF(lRet,"M00001","E00001") )
		Aadd( aRet, aParam[17] )
		Aadd( aRet, "" )
	  
		
		If lRet
			U_GTPutOUT(cId,"N",aParam[17],{"u_GerFat",{"T",aRet},"Faturamento Gerado com Sucesso",cMsg})
		Else
			U_GTPutOUT(cId,"N",aParam[17],{"u_GerFat",{"T",aRet},"Inconsistência realizar Faturamento",cMsg})
		EndIf 
	EndIf
EndIf

Return({lRet, cMsg})
