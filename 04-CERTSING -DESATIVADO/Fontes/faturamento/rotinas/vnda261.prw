#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"

/*/{Protheus.doc} VNDA260

Funcao criada para fazer a inclusao de pedido de vendas via webservice de integração com o portal de vendas

@author Totvs SM - David
@since 24/04/2015
@version P11

/*/

User Function VNDA261(cId,aParam,aProdutos,lPed)

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
//aParam[14] - cDtVali  //
//aParam[15] - nParcel  //
//aParam[16] - cTipCar  //
//aParam[17] - cNpSite  //
//aParam[18] - cLinDig  //
//aParam[19] - cNumvou  //
//aParam[20] - nQtdVou  //
//aParam[21] - cTabela1 //
//aParam[22] - cOriVen  //
//aParam[23] - cPedGar  //
//aParam[24] - aRVou   //
//aParam[25] - lEntrega //
//aParam[26] - nVlrFret //
//aParam[27] - cPedLog //
//aParam[28] - nTotPed //
//aParam[29] - cServEnt //
//aParam[30] - cTipShop //
//aParam[31] - cPedOrigem //
//----------------------//

Local aCabPV		:= {}
Local aItemPV		:= {}
Local aItemHrd	:= {}
Local nI			:= 0
Local lRet			:= .T.
Local cMsg			:= ""
Local cNumPed		:= ""
Local cGAR			:= ""
Local cNaturez		:= GetMv( 'MV_XNATVST', .F. ) //GetNewPar("MV_XNATVST", "1=FT010013,2=FT010014,3=FT010012")
Local aNaturez		:= {} 
Local cCategoSFW	:= GetNewPar("MV_GARSFT", "2")
Local cCategoHRD	:= GetNewPar("MV_GARHRD", "1")
Local cPrefix		:= GetNewPar("MV_XPREFHD", "VDI")
Local cCondPag		:= GetNewPar("MV_XCPSITE", "0=000,1=001,2=2X ,3=3XA,4=4XA,5=5XA,6=6XA")
Local aCondPag		:= {}
Local cCondPagEnt	:= GetNewPar("MV_XCPENTR", "ENT")
Local cVendedor		:= GetNewPar("MV_XVENSIT", "000001")
Local cGerPR		:= GetNewPar("MV_XSITEPR", "0") 
Local cTrasnpEnt	:= GetNewPar("MV_XTRPENT", "000001")
Local cOperDeliv	:= GetNewPar("MV_XOPDELI", "01")
Local cOperVenS		:= GetNewPar("MV_XOPEVDS", "51")
Local cOperVenH		:= GetNewPar("MV_XOPEVDH", "52")
Local cOperEntH		:= GetNewPar("MV_XOPENTH", "53")
Local cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62")
Local cOriOpeAnt	:= GetNewPar("MV_XORIOPA", "3,4,6") //Origem que usam operações antigas 51,52 e 53 (1=Varejo;2=Hardware Avulso;3=Port.Assinaturas;4=Cursos;5=Port.SSL;6=Pto.Movel)
Local cArmazem		:= GetNewPar("MV_XARMAZE", "11") //Armazem padrão 
Local nTotPed		:= 0
Local aRetTit		:= {}
Local aRetFat		:= {}
Local cNosso		:= ""
Local nItem			:= 0
Local nPosItem		:= 0
Local cUpdPed       := ""
Local cPedGar		:= ""
Local cOpPro		:= ""
Local cOpEnt		:= ""
Local aTitAdt		:= {}
Local bOldBlock
Local cErrorMsg 	:= ''
Local cXnpSite		:= aParam[17] 
Local cMenNot		:= ""
Local cMenNot1		:= ""
Local cMenNot2		:= ""
Local cAdm			:= ""
Local cProGar		:= ""
Local nPosAt		:= 0
Local nItemPed		:= 0
Local cFunProc	:= Upper(Alltrim(ProcName(1)))
Local cLineProc	:= Alltrim(Str(ProcLine(1)))
Local cIpSrv	:= GETSRVINFO()[1]
Local cPortSrv	:= GetPvProfString(GetPvProfString("DRIVERS","ACTIVE","TCP",GetADV97()),"PORT","0",GetADV97())
Local cAmbSrv 	:= GetEnvServer()
Local cCorpo 	:=''
Local aAlfaB	:= {"1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","Y","Z"}
Local lFatFil	:= .F.
Local cEmpOld 	:= ""
Local cFilOld 	:= ""
Local lSeekSC5	:= .F.
Local aOrigemPV := {"2","3","7","8","9","0","A","","B","C","","4","D","2"} 

Private lMsErroAuto := .F.
Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()

Default lPed		:= .T.

nSlp :=  Randomize(1,1500)

Sleep(nSlp)

cPedGar := aParam[23] 
cPedLog	:= aParam[27] 
  
DbSelectArea('SC5')
SC5->(DbOrderNickName("PEDSITE"))
lSeekSC5 := SC5->(DbSeek(xFilial('SC5')+aParam[17]))

If lSeekSC5
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	
	If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		If SC6->C6_XOPER $ cOperNPF .and. cOperVenS $ cOperNPF .and. cOperVenH $ cOperNPF
			cOriOpeAnt := ""
		ElseIf RAT(SC5->C5_XORIGPV,cOriOpeAnt) <= 0
			cOriOpeAnt += ","+SC5->C5_XORIGPV
		EndIf
		
		lC6Blq := .f.
		
		While !SC6->(EoF()) .and. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM
			
			If !Empty(SC6->C6_BLQ)
				lC6Blq := .T. 
			EndIf
			
			SC6->(DbSkip())
		EndDo
		If lC6Blq
			U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.F.,"E00013",cPedLog,"Pedido com eliminação de resíduos, não pode ser alterado"}},aParam[17])
			
			Return({.F., "Pedido com eliminação de resíduos, não pode ser alterado"})
		EndIf
		
	EndIf
EndIf

//TRATAMENTO PARA ERRO FATAL NA THREAD
cErrorMsg := ""
bOldBlock := ErrorBlock({|e| U_ProcError(e) })

cCorpo	:= "*****Inclusão de pedidos de vendas *****" + CRLF + CRLF
cCorpo	+= "Inicio do processamento de Pedido de Venda de acordo os dados abaixo: Depois do error block"+ CRLF + CRLF
cCorpo	+= "Ambiente : " + cAmbSrv + CRLF	
cCorpo	+= "Função de Processamento : " + cFunProc +" Linha: "+cLineProc+ CRLF	
cCorpo	+= "Servidor Processamento : " + Alltrim(cIpSrv) + " Porta : "+Alltrim(cPortSrv) + CRLF	
cCorpo	+= "Identificação da Fila : " + cId + CRLF	
cCorpo	+= "Pedido: " + cPedLog + CRLF
cCorpo	+= "Data: " + DtoC(Date()) + " Hora: "+Time()+ CRLF

U_GTPutOUT(cID,"P",cPedLog,{"VNDA260",{.F.,"M00002",cPedGar,cCorpo}},aParam[17])
	
BEGIN SEQUENCE
aCondPag		:= StrTokArr(cCondPag,",")
aNaturez		:= StrTokArr(cNaturez,",")

If !Empty(aParam[29])

	/*
	Ajustes de código para atender Migração versão P12
	Uso de DbOrderNickName
	OTRS:2017103110001774
	*/

     SA4->(DbOrderNickName("SA4_4"))	
     If SA4->(DbSeek(xFilial("SA4")+Alltrim(aParam[29])))
     	cTrasnpEnt := Alltrim(SA4->A4_COD)
     EndIf

EndIf

SA4->(DbSetOrder(1))

If ValType(aCondPag)=="A" .and. Len(aCondPag) > 0
	nPosPg := ascan(aCondPag,{|x| SubStr(alltrim(x),1,At('=',x)-1) == Alltrim(Str(Val(aParam[15]))) })
    If nPosPg > 0
    	nPosAt := At("=",aCondPag[nPosPg])
    	If nPosAt > 0
    		cCondPag := SubStr( aCondPag[nPosPg],nPosAt+1,Len(aCondPag[nPosPg]) )
    	Else
    		cCondPag := Right(aCondPag[nPosPg],3)	
    	EndIf
    Else
    	cCondPag := "000"	
    EndIf
Else
	cCondPag := "000"
EndIf

If ValType(aNaturez)=="A" .and. Len(aNaturez) > 0
	nPosNt := ascan(aNaturez,{|x| SubStr(alltrim(x),1,2) == Alltrim(Strzero(Val(aParam[16]),2)) })
    If nPosNt > 0
    	cNaturez := Right(alltrim(aNaturez[nPosNt]),8)	
    Else
    	cNaturez := "FT010010"	
    EndIf
Else
	cNaturez := "FT010010"
EndIf

If aParam[22] == '1'
	cGAR := 'X'
EndIf

cPedGar := aParam[23] 
cPedLog	:= aParam[27]

//1=Visa,2=MasterCard,3=American Express
If aParam[16] == "1"
	cAdm := "VIS"
ElseIf aParam[16] == "2"
	cAdm := "RED"
ElseIf aParam[16] == "3"
	cAdm := "AME"
ElseIf aParam[16] == "4"
	cAdm := "AUR"
ElseIf aParam[16] == "5"
	cAdm := "DIS"
ElseIf aParam[16] == "6"
	cAdm := "JCB"
ElseIf aParam[16] == "7"
	cAdm := "DIN"
ElseIf aParam[16] == "8"
	cAdm := "ELO"
ElseIf aParam[16] == "9"
	cAdm := "DEB. VISA"
ElseIf aParam[16] == "10"
	cAdm := "DEB MASTER"                                             
ElseIf aParam[16] == "11"
	cAdm := "VCH"
ElseIf aParam[16] == "12"
	cAdm := "DEB. ITA"
ElseIf aParam[16] == "13"
	cAdm := "DEB. BB"
EndIf

If Len(aProdutos) > 0
	For nI:=1 to Len(aProdutos)
	    IF ALLTRIM( aProdutos[nI,2] ) $ 'MR010001|MR010002'
           aProdutos[nI,2]:='MR010003'
		Endif
		If !Empty(aProdutos[nI,8])
			cProGar := aProdutos[nI,7]
			cProProt:= "" 
			nQtdPro	:= 1
			nVlrPro	 := IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])
			cMenNot1 := MakeMens(cProGar,cProProt,1,aParam[28],cAdm,aParam[23],aParam[17])
			cMenNot2 := alltrim(cMenNot1)
			exit
		Else
			cProGar  := "" 
			cProProt := aProdutos[nI,2]
			nQtdPro	 := IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3])
			nVlrPro	 := IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])
			cMenNot1 := MakeMens(cProGar,cProProt,nQtdPro,nVlrPro,cAdm,aParam[23],aParam[17])
			cMenNot2 += alltrim(cMenNot1)
		EndIf
	Next
Else
	cProGar := ""	
EndIf

cMenNot := alltrim(cMenNot2)

If Len(aParam[24]) >= 9 .and. !Empty(aParam[24,9])
	cNumPed := aParam[24,9]
	
	cCorpo	:= "*****Inclusão de pedidos de vendas *****" + CRLF + CRLF
	cCorpo	+= "Inicio do processamento de Pedido de Venda de acordo os dados abaixo: Voucher"+ CRLF + CRLF
	cCorpo	+= "Ambiente : " + cAmbSrv + CRLF	
	cCorpo	+= "Função de Processamento : " + cFunProc +" Linha: "+cLineProc+ CRLF	
	cCorpo	+= "Servidor Processamento : " + Alltrim(cIpSrv) + " Porta : "+Alltrim(cPortSrv) + CRLF	
	cCorpo	+= "Identificação da Fila : " + cId + CRLF	
	cCorpo	+= "Pedido: " + cPedLog + CRLF
	cCorpo	+= "Data: " + DtoC(Date()) + " Hora: "+Time()+ CRLF
	
	U_GTPutOUT(cID,"P",cPedLog,{"VNDA260",{.F.,"M00002",cNumPed,cCorpo,aParam[24]}},aParam[17]) 
Else
    cLibFat:="S" //O Pedido de verejo sempre entra liberado.
	//RENATO RUY - 05/01/2018
	//Val(aParam[22]) <= Len(aOrigemPV) .AND. aOrigemPV[Val(aParam[22])] =='8'
	//A posição do array é diferente, estava retornando em branco e por este motivo não entrava.
	IF aParam[22] =='4'//Para Origem 8 - cursos - entra bloqueado para análise de retenção de impostos pela equipe Fiscal
        IF !empty(aParam[39])
			cLibFat:="P" //Assim que identificado o pagamento a equipe fiscal realiza a adequação do pedido e muda o status para "S"  
	    else
            cLibFat:="N" //Enquanto nao existe pagamento, o pedido não é análisado pelo fiscal e também impedido de faturar. 
    	Endif
	Endif
	aCabPV:={	{"C5_TIPO"		,aParam[2]	,Nil},; // Tipo de pedido
				{"C5_CLIENTE"	,aParam[3]	,Nil},; // Codigo do cliente
				{"C5_LOJACLI"	,aParam[4]	,Nil},; // Loja do cliente
				{"C5_TIPOCLI"	,aParam[5]	,Nil},; // Codigo do tipo de cliente.(R = Revendedor, S = Solidario, F = Consumidor Final)
				{"C5_CONDPAG"	,cCondPag	,Nil},; // Codigo da condicao de pagamanto
				{"C5_EMISSAO"	,date()		,Nil},; // Data de emissao
				{"C5_CLIENT"	,aParam[3]	,Nil},; // Indica o cliente em cujo estado (UF) os produtos/servicos serao entregues.
				{"C5_LOJAENT"	,aParam[4]	,Nil},; // Loja para entrada
				{"C5_TABELA"	,aParam[21]	,Nil},; // Tabela de preco
				{"C5_VEND1"		,cVendedor	,Nil},; // Vendedor
				{"C5_XNATURE"	,cNaturez	,Nil},; // Natureza Certisign
				{"C5_TIPMOV"	,aParam[10]	,Nil},; // Forma de pagamento escolhida no site
				{"C5_XNUMCAR"	,aParam[11]	,Nil},; // Numero do cartao de credito
				{"C5_XCARTAO"	,aParam[11] ,Nil},; // Numero do cartao de credito
				{"C5_XNOMTIT"	,aParam[12]	,Nil},; // Nome do titular do cartao de credito
				{"C5_XCODSEG"	,aParam[13]	,Nil},; // Codigo de seguranca do cartao de credito
				{"C5_XVALIDA"	,aParam[14]	,Nil},; // Data de validade do cartao de credito
				{"C5_XNPARCE"	,aParam[15]	,Nil},; // Numero de parcelas para dividir no cartao de credito
				{"C5_XTIPCAR"	,IIf(Val(aParam[16])>9,aAlfaB[Val(aParam[16])],aParam[16])	,Nil},; // Bandeira do cartao de credito 1-Visa, 2-Master e 3-American Express
				{"C5_XNPSITE"	,aParam[17]	,Nil},; // Numero do pedido gerado pelo site
				{"C5_XLINDIG"	,aParam[18]	,Nil},; // Numero da linha digitavel do boleto
				{"C5_XNUMVOU"	,aParam[19]	,Nil},; // Numero do voucher
				{"C5_XFLUVOU"	,iif(Len(aParam[24])>=10,aParam[24,10],"")	,Nil},; // Codigo fluxo de voucher
				{"C5_XQTDVOU"	,aParam[20]	,Nil},; // Quantidade consumida pelo voucher
				{"C5_XPOSTO"	,aParam[8]	,Nil},; // Codigo do Posto GAR
				{"C5_XGARORI"	,cGAR		,Nil},; // Identifica se o pedido eh proveniente do GAR
				{"C5_XORIGPV"	,IIF(Val(aParam[22]) <= Len(aOrigemPV), aOrigemPV[Val(aParam[22])] ,"" ),Nil},; // Identifica a Origem do Pedido
				{"C5_FRETE"		,aParam[26]	,Nil},; // valor do Frete caso exista
				{"C5_TPCARGA"	,IIF(aParam[25],"1","2")	,Nil},; // Identifica se o Pedido se refere a Carga
				{"C5_TPFRETE"	,IIF(aParam[25],"C","S")	,Nil},; // Identifica Tipo de Frete como C=CIF caso se refira a entrega em domicilio
				{"C5_TRANSP"	,IIF(aParam[25],cTrasnpEnt,"")	,Nil},; // Define a transportadora para Geracao da Carga
				{"C5_TOTPED"	,aParam[28]	,Nil},; // valor total do Pedido
				{"C5_MENNOTA"	,cMenNot	,Nil},; // Mensagem da Nota
				{"C5_CHVBPAG"	,cPedGar	,Nil},; // Codigo de Pedido GAR
				{"C5_XPEDORI"	,aParam[31]	,Nil},; // Codigo de Pedido Externo
				{"C5_XITAUSP"	,aParam[30]	,Nil},; // Situação da PAgamento ShopLine
				{"C5_KPROTOC"	,aParam[37]	,Nil},; // Código de protocolo 
				{"C5_XDOCUME"	,aParam[38]	,Nil},; // Numero de documento
				{"C5_XCODAUT"   ,aParam[39]	,Nil},; // Código de autorização
				{"C5_XTIDCC"    ,aParam[40]	,Nil},; // Codigo de confirmaçao
				{"C5_XLIBFAT"   ,cLibFat	,Nil},; // Lib Fat S=SIM;N=NAO;P=PENDENTE
				{"C5_XCODREV"	,aParam[42] ,Nil}}  // CodRev utilizado pelo Parceiro	
	
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
		nItemPed++
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1") + aProdutos[nI,2])
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1") +aParam[3]+aParam[4])
		
		IF SB1->B1_CATEGO $ cCategoHRD
			cOpPro		:= cOperVenH
			cOpEnt		:= cOperEntH
			
			If aParam[22] $ cOriOpeAnt
				cOpPro		:= '52'
				cOpEnt		:= '53'
			EndIf
			
			//Caso se refira a delivery usa tipo de operação específica
			If aParam[25]
				cOpPro		:= cOperDeliv
			EndIf
								
		Else
			cOpPro		:= cOperVenS
			
			If aParam[22] $ cOriOpeAnt
				cOpPro		:= '51'
			EndIf	
		EndIf
		
		// Caso Seja um Pedido com Forma de Pagto Voucher Verifico
		// as parametrizações do Tipo de Voucher
		If Len(aParam[24]) >= 8 
			If SB1->B1_CATEGO $ cCategoHRD
				cOpPro		:= iif(!Empty(aParam[24,7]),aParam[24,7],cOpPro)
				cOpEnt		:= iif(!Empty(aParam[24,8]),aParam[24,8],cOpEnt)		
			Else
				cOpPro		:= iif(!Empty(aParam[24,6]),aParam[24,6],cOpPro)		
			EndIf
		EndIf
		If SB1->B1_CATEGO $ cCategoSFW
			nItemPed++
			AADD(aItemPV,{	{"C6_ITEM"		,StrZero(nItemPed, TamSX3("C6_ITEM")[1]) ,Nil},; // Numero do Item no Pedido
							{"C6_PRODUTO"	,aProdutos[nI,2]		,Nil},; // Codigo do Produto
						    {"C6_QTDVEN"	,IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3])	,Nil},; // Quantidade Vendida   ***
							{"C6_PRUNIT"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // PRECO DE LISTA      ***
						    {"C6_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
							{"C6_OPER"		,cOpPro 																	,Nil},; // OperaÃ§Ã£o de faturamento    *** Mudar o C6_OPER para retorno do tipo de operacao aRvou//////////
							{"C6_XOPER"		,cOpPro																		,Nil},; // OperaÃ§Ã£o de faturamento    ***
							{"C6_LOCAL"		,cArmazem																	,Nil},; // ArmazÃ©m PadrÃ£o
							{"C6_PROGAR"	,aProdutos[nI,7]															,Nil},;	// Codigo Produto GAR
							{"C6_XCDPRCO"	,aProdutos[nI,8]															,Nil},;	// Codigo Combo
							{"C6_ENTREG"	,aProdutos[nI,9]															,Nil},; // Data da Entrega
							{"C6_XNUMVOU"	,aProdutos[nI,11]															,Nil},; // Numero do Voucher
							{"C6_XQTDVOU"	,aProdutos[nI,12]															,Nil},; // Quantidade do Voucher
							{"C6_PEDGAR"	,cPedGar																	,Nil},; // Numero do Pedido GAR
							{"C6_UNEG"		,ACV->(GetAdvFVal('ACV','ACV_CATEGO',xFilial('ACV')+aProdutos[nI,2],5))		,Nil},; // Código da Unidade de Negócio.
							{"C6_XPEDORI"	,aProdutos[nI,14]															,Nil},; // Pedido de Origem
							{"C6_XIDPED"	,aProdutos[nI,15]															,Nil},; // Id Pedido 
							{"C6_XIDPEDO"	,aProdutos[nI,16]															,Nil}}) // Id Pedido origem
							
			nTotPed += IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3]) * IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])

		ElseIf SB1->B1_CATEGO $ cCategoHRD 
			nItemPed++
			AADD(aItemPV,{	{"C6_ITEM"		,StrZero(nItemPed, TamSX3("C6_ITEM")[1])	,Nil},; // Numero do Item no Pedido
							{"C6_PRODUTO"	,aProdutos[nI,2]		,Nil},; // Codigo do Produto
							{"C6_QTDVEN"	,IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3])	,Nil},; // Quantidade Vendida   ***
							{"C6_PRUNIT"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // PRECO DE LISTA      ***
							{"C6_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
							{"C6_OPER"		,cOpPro																		,Nil},; // Valor Total do Item        ***
							{"C6_XOPER"		,cOpPro																		,Nil},; // Valor Total do Item        ***
							{"C6_LOCAL"		,cArmazem																	,Nil},; // ArmazÃ©m PadrÃ£o
							{"C6_PROGAR"	,aProdutos[nI,7]															,Nil},;	// Codigo Produto GAR
							{"C6_XCDPRCO"	,aProdutos[nI,8]															,Nil},;	// Codigo Combo
							{"C6_ENTREG"	,aProdutos[nI,9]															,Nil},; // Data da Entrega
							{"C6_XNUMVOU"	,aProdutos[nI,11]															,Nil},; // Numero do Voucher
							{"C6_XQTDVOU"	,aProdutos[nI,12]															,Nil},; // Quantidade do Voucher
							{"C6_PEDGAR"	,cPedGar																	,Nil},; // Numero do Pedido GAR
							{"C6_UNEG"		,ACV->(GetAdvFVal('ACV','ACV_CATEGO',xFilial('ACV')+aProdutos[nI,2],5))		,Nil},; // Código da Unidade de Negócio.
							{"C6_XPEDORI"	,aProdutos[nI,14]															,Nil},; // Pedido de Origem
							{"C6_XIDPED"	,aProdutos[nI,15]															,Nil},; // Id Pedido 
							{"C6_XIDPEDO"	,aProdutos[nI,16]															,Nil}}) // Id Pedido origem
			
			AADD(aItemHrd,  {StrZero(nItemPed, TamSX3("C6_ITEM")[1]), cOpPro} )
			
			If !aParam[25] .and. !cOpPro $ cOperNPF
				nItemPed++
				AADD(aItemPV,{	{"C6_ITEM"		,StrZero(nItemPed, TamSX3("C6_ITEM")[1])	,Nil},; // Numero do Item no Pedido
								{"C6_PRODUTO"	,aProdutos[nI,2]		,Nil},; // Codigo do Produto
								{"C6_QTDVEN"	,IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3])	,Nil},; // Quantidade Vendida   ***
								{"C6_PRUNIT"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // PRECO DE LISTA      ***
								{"C6_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
								{"C6_OPER"		,cOpEnt																		,Nil},; // Valor Total do Item        ***
								{"C6_XOPER"		,cOpEnt																		,Nil},; // Valor Total do Item        ***
								{"C6_LOCAL"		,cArmazem																	,Nil},; // ArmazÃ©m PadrÃ£o
								{"C6_PROGAR"	,aProdutos[nI,7]															,Nil},;	// Codigo Produto GAR
								{"C6_XCDPRCO"	,aProdutos[nI,8]															,Nil},;	// Codigo Combo
								{"C6_ENTREG"	,aProdutos[nI,9]															,Nil},; // Data da Entrega
								{"C6_XNUMVOU"	,aProdutos[nI,11]															,Nil},; // Numero do Voucher
								{"C6_XQTDVOU"	,aProdutos[nI,12]															,Nil},; // Quantidade do Voucher
								{"C6_PEDGAR"	,cPedGar																	,Nil},; // Numero do Pedido GAR
								{"C6_UNEG"		,ACV->(GetAdvFVal('ACV','ACV_CATEGO',xFilial('ACV')+aProdutos[nI,2],5))		,Nil},; // Código da Unidade de Negócio.
							    {"C6_XPEDORI"	,aProdutos[nI,14]															,Nil},; // Pedido de Origem
							    {"C6_XIDPED"	,aProdutos[nI,15]															,Nil},; // Id Pedido 
							    {"C6_XIDPEDO"	,aProdutos[nI,16]															,Nil}}) // Id Pedido origem
								
				AADD(aItemHrd,  {StrZero(nItemPed, TamSX3("C6_ITEM")[1]), cOpEnt} )
			EndIf
		EndIf
	Next nI
	
	For nItem := 1 to Len(aItemPV)
		nPosItem := aScan(aItemPV[nItem], {|x| AllTrim(x[1]) == "C6_ITEM"})
			
		aItemPV[nItem][nPosItem][2] := StrZero(nItem, TamSX3("C6_ITEM")[1])
	Next nItem
	
	If lSeekSC5 //.or. Valtype(aItemPV[nItem]) <> "U"
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		nAsize := 0
		/*
		For nItem := 1 to Len(aItemPV)
			If Valtype(aItemPV[nItem]) <> "U"
				nPosItem := aScan(aItemPV[nItem], {|x| AllTrim(x[1]) == "C6_ITEM"})
				nPosProd := aScan(aItemPV[nItem], {|x| AllTrim(x[1]) == "C6_PRODUTO"})
				
				If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM+aItemPV[nItem][nPosItem][2]+aItemPV[nItem][nPosProd][2])) .And. aParam[22] != "2"
					aDel(aItemPV,nItem)
					nItem--
					nAsize++
				Endif
			EndIf
		Next
		*/
		If nAsize > 0 
			aSize(aItemPV,Len(aItemPV)-nAsize)
		Endif
	EndIf
   _lExitPed:=.F.

   IF !lSeekSC5
		
		cFilOld := cFilAnt
		
		//Renato Ruy - 13/08/2018
		//Tratamento sera incluido em todas rotinas para compatibilizacao de CFOP.
		If AllTrim(SA1->A1_EST)=="RJ"
			STATICCALL( VNDA190, FATFIL, nil ,"01" )
		Endif
		
		U_GTPutIN(cID,"P",cPedLog,.T.,{"U_VNDA260",cPedLog,aCabPV,aItemPV},aParam[17],{aParam[11],alltrim(aParam[18]),aParam[19]})
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,aParam[1])
		
		If cFilOld <> cFilAnt
			STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
		Endif
		
		DbSelectArea('SC5')
		SC5->(DbOrderNickName("PEDSITE"))
		lSeekSC5 := SC5->(DbSeek(xFilial('SC5')+aParam[17]))
		
		STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
		
	ElseIf lSeekSC5 .and. Len(aItemPV) > 0
		
		cEmpOld := cEmpAnt
		cFilOld := cFilAnt
		lFatFil := STATICCALL( VNDA190, FATFIL,SC5->C5_NUM )
	
		aCabPV:={	{"C5_NUM"		,SC5->C5_NUM	,Nil} } // Tipo de pedido
		
		U_GTPutIN(cID,"A",cPedLog,.T.,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"Pedido Ja existe no Sistema Protheus e será alterado"},aParam[17],aParam[11],alltrim(aParam[18]),aParam[19]})		
		
		cMVAltped := GetMv("MV_ALTPED")
		
		PutMv("MV_ALTPED","S")
		
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,4)
		
		PutMv("MV_ALTPED",cMVAltped)
		
		If !lMsErroAuto
			U_GTPutOUT(cID,"A",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"Pedido Alterado com Sucesso"}},aParam[17])
		EndIf
		
		STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
		
	Else
		U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"Pedido Ja existe no Sistema Protheus"}},aParam[17])
		U_GTPutIN(cID,"A",cPedLog,.T.,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"Pedido Ja existe no Sistema Protheus"},aParam[17],aParam[11],alltrim(aParam[18]),aParam[19]})
		cNumPed := ""
		
		_lExitPed:=.T.
	Endif
	
	If lMsErroAuto
		MOSTRAERRO()
		cMsg := "Inconsistência ao Gerar o Pedido: " + CRLF + CRLF
		aAutoErr := GetAutoGRLog()	
		For nI := 1 To Len(aAutoErr)
			cMsg += aAutoErr[nI] + CRLF
		Next nI
		lRet := .F.
		
		U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.F.,"E00013",cPedLog,cMsg}},aParam[17])
		
		If lSeekSC5 .and. Len(aItemPV) > 0
			U_GTPutOUT(cID,"A",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00001",aParam[17],"Pedido Alterado com Problemas:"+CRLF+cMsg}},aParam[17])
		Endif
		
		cNumPed := ""
	ElseIf !_lExitPed
		DbSelectArea("SC5")
		//DbSetOrder(8)
		SC5->(DbOrderNickName("PEDSITE"))//Alterado por LMS em 03-01-2013 para virada
		If DbSeek(xFilial("SC5") + aParam[17])
			cNumPed := SC5->C5_NUM 
			
			RecLock("SC5", .F.)
				SC5->C5_LIBEROK = ''
			SC5->(MsUnlock())
			
			DbSelectArea("SC6")
			DbSetOrder(1)
			If DbSeek(xFilial("SC6") + cNumPed)
			
				//Estorna Liberação caso seja criado pedido com os itens liberados 
				//Parametro MV_PAR01 = 1 (Sugere Qtd Liberada) f12 na tela de pedidos
				While !SC6->(EoF()) .and. SC6->C6_NUM == cNumPed
				
					MaAvalSC6("SC6",4,"SC5")
				
					SC6->(DbSkip())	
				EndDo
	
				cMsg := 'Pedido incluído com sucesso-'+cNumPed
				U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.T.,"M00001",cPedLog,cMsg}},aParam[17])
			EndIf
		EndIf
	EndIf
EndIf
// Caso Forma de Pagamento seja Boleto Gera Título Provisório no Financeiro, caso contrário Fatura Pedido
If !empty(cNumPed)
	If aParam[10] == "1" .and.  cGerPR == "1" // aParam[10]==1 igual a boleto. opvs(warleson)
		cNosso 	:= aParam[17]
		aRetTit	:= U_VNDA270(3,cPrefix,cNumPed,"","PR",cNaturez,aParam[3],aParam[4],aParam[7],aParam[7],nTotPed,cNosso,aParam[17],cId,cPedLog,aParam[10])
		lRet	:= aRetTit[1]
		cMsg 	:= aRetTit[2]
	
	ElseIf aParam[10] == "6"  //voucher
		aParamFun := {cNumPed,;
					Val(aParam[17]),;
					nil,;
					nil,;
					aParam[24,4],;
					aParam[24,5],;
					1,;
					iif(!Empty(aParam[24,7]),aParam[24,7],nil),;
					iif(!Empty(aParam[24,8]),aParam[24,8],nil),;
					iif(!Empty(aParam[24,6]),aParam[24,6],nil),;
					cPedlog,;
					nil,;
					.T.,;
					.F.}
		
		aRetFat	:= U_VNDA190( "" ,aParamFun	)
		lRet	:= aRetFat[1]
		cMsg 	:= aRetFat[2]
		
		/*
		//26/09/2012 - Retirada de envio de notificação ao gar devido solicitação do Sr. GIovanni
		//que solicitou a implantação do envio no HUB de Mensagens 
		DbSelectArea("SC5")
		//SC5->(DbSetOrder(8))
		SC5->(DbOrderNickName("PEDSITE"))//Alterado por LMS em 03-01-2013 para virada de versão	
		If SC5->(DbSeek(xFilial("SC5") + aParam[17])) .and. !Empty(SC5->C5_CHVBPAG)
			
			U_VNDA481({SC5->(Recno())},nil,"Liberação de Pagamento Automatica devido Compra com Voucher")
			
		EndIf
		*/
	EndIf
EndIf

END SEQUENCE

If InTransact()
	// Esqueceram transacao aberta ... Fecha fazendo commit ...
	Conout("*** AUTOMATIC CLOSE OF ACTIVE TRANSACTION IN "+procname(0)+":"+str(procline(0),6)+"***")
	EndTran()
Endif

ErrorBlock(bOldBlock)

cErrorMsg := U_GetProcError()

If !empty(cErrorMsg)
	lRet := .f.
	cMsg := "Inconsistência no Processamento do Pedido: "+CRLF+cErrorMsg
	U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.F.,"E00014",cPedLog,cMsg}},cXnpSite)
EndIf

// Solta o lock do processo deste item
UnLockByName(cXnpSite,.F.,.F.)//U_GarUnlock(cXnpSite)

Return({lRet, cMsg})


/*/{Protheus.doc} MakeMens

Função personalizada para obter mensagem para gravação a observções do pedidos de vendas

@author Totvs SM - Darcio
@since 05/09/2011
@version P11

/*/

Static Function MakeMens(cProGar,cProProt,nQtdVen,nPrcVen,cCartao,cPedBpag,cXnpSite)

Local cMensagem := ""
Local cDescri	:= ""
Local nValor	:= nQtdVen * nPrcVen
Local cTipoProd := ""

Default cProGar	:= ""
Default cProProt:= ""
Default nQtdVen	:= 1
Default nPrcVen	:= 0
Default cCartao	:= ""
Default cPedBpag:= ""
Default cXnpSite:= ""

If !Empty(cProGar)
	PA8->( DbSetOrder(1) )
	PA8->( DbSeek( xFilial("PA8")+cProGar ) )
	
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek( xFilial("SB1")+PA8->PA8_CODMP8 ) )
EndIf

If !empty(cProProt)
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek( xFilial("SB1")+cProProt ) )
EndIf

cTipoProd	:= SB1->B1_TIPO
cDescri		:= SB1->B1_DESC

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Trata o Nome da Operadora de Cartao de Credito                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cCartao 	:= IIF( cCartao=='AME', "Amex",			cCartao)
cCartao 	:= IIF( cCartao=='RED', "Mastercard",	cCartao)
cCartao 	:= IIF( cCartao=='VIS', "Visa",			cCartao)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Processo de Montagem de Mensagem, para SC5 com base no Produto      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cMensagem:= ""
If cTipoProd <> "MR"
	cMensagem:= AllTrim(cDescri) + ";"
	// 02/01/15 - retirado devio novo ponto de faturamento
	//cMensagem+= Space(1) + "Qtde:"
	//cMensagem+= Space(1) + AllTrim(Transform(nQtdVen, "@E 999,999,999.99")) + ";"
	//cMensagem+= Space(1) + "Preço Unitário:"
	//cMensagem+= Space(1) + AllTrim(Transform(nPrcVen, "@E 999,999,999.99")) + ";"
	cMensagem+= Space(1) + "Valor do Pedido:"
	cMensagem+= Space(1) + AllTrim(Transform(nValor,  "@E 9,999,999,999.99")) + ";"
Endif

// 02/01/15 - retirado devio novo ponto de faturamento
//cMensagem+= Space(1) + "NF Liquidada -"
If !Empty(cPedBpag)
	cMensagem+= " Pedido GAR: " + cPedBpag
EndIf

If !Empty(cXnpSite)
	cMensagem+= " Ordem de Fat.: " + cXnpSite
EndIf

If !Empty(cCartao)
	cMensagem+= " Pgto Cartao: " + cCartao
Endif

Return(cMensagem)