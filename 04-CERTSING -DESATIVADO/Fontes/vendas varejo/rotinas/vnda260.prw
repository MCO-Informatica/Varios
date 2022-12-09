#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"


#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
/*
ISHOPL_INDEFINIDO- forma de pagamento ainda não definida pelo cliente
ISHOPL_TEF - débito em conta/transferência
ISHOPL_BOLETO - boleto Itaú
ISHOPL_ITAUCARD - cartão de crédito
*/

Static __Shop := {"ISHOPL_INDEFINIDO","ISHOPL_TEF","ISHOPL_BOLETO","ISHOPL_ITAUCARD","BB_INDEFINIDO","BB_TEF","ONEBUY"}

/*/{Protheus.doc} VNDA260

Funcao criada para fazer a inclusao de pedido de vendas via webservice de integração com o portal de vendas

@author Totvs SM - Darcio
@since 05/09/2011
@version P11

/*/

User Function VNDA260(cId,aParam,aProdutos)

	//----------------------//
	//aParam[01] - nOpc      //
	//aParam[02] - cTipo     //
	//aParam[03] - cCliente  //
	//aParam[04] - cLjCli    //
	//aParam[05] - cTpCli    //
	//aParam[06] - cForPag   //
	//aParam[07] - dEmissao  //
	//aParam[08] - cPosGAR   //
	//aParam[09] - cPosLoj   //
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
	//aParam[24] - aRVou    //
	//aParam[25] - lEntrega //
	//aParam[26] - nVlrFret //
	//aParam[27] - cPedLog  //
	//aParam[28] - nTotPed  //
	//aParam[29] - cServEnt //
	//aParam[30] - cTipShop //
	//aParam[31] - cPedOrigem //
	//aParam[32] - cCodDUA //
	//aParam[33] - cCGCDUA //
	//aParam[34] - cMunDUA //
	//aParam[35] - cObsDUA //
	//aParam[36] - cEstDUA //
	//aParam[37] - cProtocolo //
	//aParam[38] - cDocCar //
	//aParam[39] - cDocAut //
	//aParam[40] - cCodConf //
	//aParam[41] - cOriVou //
	//aParam[42] - cCodRev //
	//aParam[43] - cEcommerce //
	//aParam[44] - cCupomDesc //
	//aParam[45] - nValBruto //
	//aParam[46] - nValDesc //
	//----------------------//

	Local aCabPV		:= {}
	Local aItemPV		:= {}
	Local aItemHrd		:= {}
	Local nI			:= 0
	Local lRet			:= .T.
	Local cMsg			:= ""
	Local cNumPed		:= ""
	Local nRecPed		:= 0
	Local cGAR			:= ""
	Local cNaturez		:= GetMv( 'MV_XNATVST', .F. ) //GetNewPar("MV_XNATVST", "1=FT010013,2=FT010014,3=FT010012")
	Local aNaturez		:= {}
	Local cCategoSFW	:= GetNewPar("MV_GARSFT", "2")
	Local cCategoHRD	:= GetNewPar("MV_GARHRD", "1")
	Local cPrefix		:= GetNewPar("MV_XPREFHD", "VDI")
	Local cCondPag		:= GetNewPar("MV_XCPSITE", "0=000,1=001,2=2X ,3=3XA,4=4XA,5=5XA,6=6XA")
	Local aCondPag		:= {}
	Local cVend1		:= GetNewPar("MV_XVENSIT", "000001")
	Local cVend2		:= ''
	Local cGerPR		:= GetNewPar("MV_XSITEPR", "0")
	Local cTrasnpEnt	:= GetNewPar("MV_XTRPENT", "000001")
	Local cOperDeliv	:= GetNewPar("MV_XOPDELI", "01")
	Local cOperVenS		:= GetNewPar("MV_XOPEVDS", "51")
	Local cOperVenH		:= GetNewPar("MV_XOPEVDH", "52")
	Local cOperEntH		:= GetNewPar("MV_XOPENTH", "53")
	Local cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62")
	Local cOriOpeAnt	:= GetNewPar("MV_XORIOPA", "2,3,4,6") //Origem CheckOut que usam operações antigas 51,52 e 53 (2=Hardware Avulso;3=Port.Assinaturas;4=Cursos;6=Pto.Movel)
	Local cArmazem		:= GetNewPar("MV_XARMAZE", "11") //Armazem padrão
	Local nTotPed		:= 0
	Local aRetTit		:= {}
	Local aRetFat		:= {}
	Local cNosso		:= ""
	Local nItem			:= 0
	Local nPosItem		:= 0
	Local cPedGar		:= ""
	Local cOpPro		:= ""
	Local cOpEnt		:= ""
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
	Local cFunProc		:= Upper(Alltrim(ProcName(1)))
	Local cLineProc		:= Alltrim(Str(ProcLine(1)))
	Local cIpSrv		:= GETSRVINFO()[1]
	Local cPortSrv		:= GetPvProfString(GetPvProfString("DRIVERS","ACTIVE","TCP",GetADV97()),"PORT","0",GetADV97())
	Local cAmbSrv 		:= GetEnvServer()
	Local cCorpo 		:=''
	Local aAlfaB		:= {"1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","Y","Z"}
	Local aOrigemPV 	:= {"2","3","7","8","9","0","A","","B","C","","4","D","2","2","5"} 
	Local lFatFil		:= .F.
	Local cEmpOld 		:= ""
	Local cFilOld 		:= ""
	Local aAreaSZ3		:= {}
	Local lExecAuto 	:= .F.
	Local cOrigemPV		:= ""
	Local cOrigSite 	:= GetNewPar("MV_XORISIT", "2|A") //Origem ERP que utilizarão CodRev (Varejo)
	Local cCodRev		:= ""
	Local cVendPDA		:= GetNewPar("MV_XVENPDA", "VC0070")
	Local nPosOrig		:= 0
	Local cTRB			:= ''
	Local cSQL			:= ''
	Local cC6_XSKU		:= ''
	Local nOper 		:= aParam[1]
	Local nLenA3_COD 	:= TamSX3( "A3_COD" )[ 1 ]
	Local cPedEcomm		:= IIF( Len(aParam[43]) > 14, Right(aParam[43],14), aParam[43] )
	Local cObservacao	:= IIF( Len(aParam[43]) > 14, 'Pedido eCommerce: ' + aParam[43], '' )
	Local cC6_XNPECOM	:= ''
	Local nTotItem      := 0

	Private lMsErroAuto := .F.
	Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()

	//------------------------------------------------------------
	// C5_XORIGPV :  aOrigemPV 
	// 1=Manual;2=Varejo;3=Hard.Avulso;4=TLV;5=Atend.Ext.;6=Contratos;7=Port.Ass.;8=Cursos;9=Port.SSL;0=Pto.Movel;A=Varejo;B=SAC;C=PDA;D=CertiBio
	// Localizado na tabela Z4 (SX5)

	//+----------------------+----------------------+---------------+--------------+-----------------+------------------------------------------------+
	//| Origem PEDIDO        | CHECKOUT             | C5_XORIGPV	| Z11_ORIGEM   | É LEGADO?       | QUANDO GERA PEDIDO GAR                         |
	//+----------------------+----------------------+---------------+--------------+-----------------+------------------------------------------------+
	//| 1. Portal GAR        | GAR(1)               | 2=Varejo		| ''		   | LEGADO          | EXISTE PEDIDO GAR NA MENSAGEM DO 'ENVIAPEDIDO' |
	//| 2. Portal Certisign  | HARDWARE_AVULSO(2)   | 3=Hard.Avulso	| ''           |                 |                                                |
	//| 3. Portal Assinatura | PORTAL_ASSINATURA(3) | 7=Port.Ass.	| ''           |                 |                                                |
	//| 4. Venda de cursos   | CURSOS(4)            | 8=Cursos		| ''           |                 |                                                |
	//| 5. Portal SSL        | PORTAL_SSL(5)        | 9=Port.SSL	| ''           |                 |                                                |
	//| 6. Ponto Movel       | PONTO_MOVEL(6)       | 0=Pto.Movel	| ''           |                 |                                                |
	//| 7. Gar NOVO          | GAR_NOVO(7)          | A=Varejo		| ''           | LEGADO          | EXISTE PEDIDO GAR NA MENSAGEM 'ENVIAPEDIDOGAR' |
	//| 8. Prodest           | PRODEST(8)           | ''			| '8=Dua'      |                 |                                                |
	//| 9. Venda SAC         | SAC(9)               | B=SAC			| ''           |                 | EXISTE PEDIDO GAR NA MENSAGEM 'ENVIAPEDIDOGAR' |
	//| 10. Emissao Carteira | PDA(10)              | C=PDA			| ''           |                 |                                                |
	//| 11. Sage             | Sage(11)             | ''			| '11=Sage'    |                 |                                                |
	//| 12. Televendas       | Televendas(12)       | 4=Televendas	| ''           |                 |                                                |
	//| 13. CertiBio         | CertiBio(13)         | D=CertiBio	| ''           |                 |                                                |
	//| 14. Combo de Kit´s   | Ecommerce(14)        | 2=Varejo		| ''           |                 | EXISTE PEDIDO GAR NA MENSAGEM 'ENVIAPEDIDOGAR' |
	//| 15. SalesForce  	 | SALESFORCE(15)	    | 2=Varejo      |              |                 | EXISTE PEDIDO GAR NA MENSAGEM 'ENVIAPEDIDOGAR' |
	//| 16. GAD (Domicilio)  | GAD(16)			    | 5=AtendiDomici|              |                 |                                                |
	//+----------------------+----------------------+---------------+--------------+-----------------+------------------------------------------------+

	cPedGar := aParam[23]
	cPedLog := aParam[27]

	//TRATAMENTO PARA ERRO FATAL NA THREAD
	cErrorMsg := ""
	bOldBlock := ErrorBlock({|e| U_ProcError(e) })

	cCorpo	:= "*****Tratamento de pedidos de vendas (Operação - " + IIF(nOper==3,'Inclusão','Alteração') + ") *****" + CRLF + CRLF
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

		//Ajuste para preencher corretamente a transportadora
		//por conta de ajuste e legado. André Sant'ana - Compila
		If !Empty(aParam[29])				
			SA4->(DbOrderNickName("SA4_4"))
			
			If Alltrim(aParam[29]) == '04162'
				SA4->(DbSeek(xFilial("SA4")+Alltrim('03220')))
				cTrasnpEnt := Alltrim(SA4->A4_COD)

			ElseIf Alltrim(aParam[29]) == '04669'
				SA4->(DbSeek(xFilial("SA4")+Alltrim('03298')))
				cTrasnpEnt := Alltrim(SA4->A4_COD)
		
			Else 
				SA4->(DbSeek(xFilial("SA4")+Alltrim(aParam[29])))
				cTrasnpEnt := Alltrim(SA4->A4_COD)
			EndIf
		EndIf

		//Reserva a area antes das alterações a serem realizadas
		aAreaSZ3 := GetArea()

		//Preenche o valor com espaços em branco até o limite do campo
		nPosOrig 	:= Val(aParam[22])
		cOrigemPV	:= IIF(nPosOrig <= Len(aOrigemPV), aOrigemPV[nPosOrig], "")

		//Define Vendedor padrao para Carteira, caso nao haja CodRev
		If Empty(aParam[42]) .And. cOrigemPV == "C"
			cVend1 := cVendPDA
		EndIf

		//Altera o Vendedor, de acordo com a amarração no Revendedor (Entidade)
		If !Empty(aParam[42])

			//Valida se a Origem é Site para unificar a Origem na SZ3
			If cOrigemPV $ cOrigSite
				cOrigemPV := "A"
			EndIf

			cCodRev := Alltrim( aParam[42] )

			cSQL += "SELECT Z3_VEND1 " + CRLF
			cSQL += "FROM   " + RetSqlName('SZ3') + " " + CRLF
			cSQL += "WHERE  D_E_L_E_T_ = ' ' " + CRLF
			cSQL += "       AND Z3_FILIAL = '" + xFilial('SZ3') + "' " + CRLF
			cSQL += "       AND Z3_VEND1 <> ' ' " + CRLF
			cSQL += "       AND Z3_CODREV LIKE '%" + cCodRev + "%' " + CRLF
			cSQL += "       AND Z3_ORIGEM = '" + cOrigemPV + "'" + CRLF

			cSQL := ChangeQuery( cSQL )
			cTRB := GetNextAlias()

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

			IF .NOT. (cTRB)->( EOF() )
				cVend1 := (cTRB)->Z3_VEND1
			Else
				dbSelectArea("SA3")
				SA3->( dbSetOrder(1) )
				IF SA3->( dbSeek( xFilial("SA3") + Padr( Upper( cCodRev ), nLenA3_COD, '' ) ) )
					If cOrigemPV == "C"
						cVend1 := cVendPDA
						cVend2 := cCodRev
					Else
						cVend1 := cCodRev
					EndIF
				ElseIF cOrigemPV == "C"
					cVend1 := cVendPDA
				EndIF		
			EndIf
			(cTRB)->( dbCloseArea() )
			FErase( cTRB + GetDBExtension() )	
		EndIf

		//Recupera area
		RestArea(aAreaSZ3)

		SA4->(DbSetOrder(1))//Não retirar. A validação de campo padrão do ERP espera que esteja no indice 1

		If ValType(aCondPag)=="A" .and. Len(aCondPag) > 0
			aParam[15] := Alltrim(Str(Val(aParam[15])))
			nPosPg := ascan(aCondPag,{|x| SubStr(alltrim(x),1,At('=',x)-1) == aParam[15] })
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

		IF Alltrim(Str(Val(aParam[16]))) == '14' //OneBuy [Solicitação em 02.06.2016 Otrs(2016060210001883)]
			cNaturez := 'FT010016'
		EndIF

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
		ElseIf aParam[16] == "14"
			cAdm := "ONEBUY"

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

		// 02/01/2015 - retirado devido novo ponto de faturamento
		//cMenNot  := "NF EMITIDA NOS TERMOS DO ARTIGO 129 DO RICMS 00 "+cMenNot2

		cMenNot := alltrim(cMenNot2)

		If Len(aParam[24]) >= 9 .and. !Empty(aParam[24,9])
			cNumPed := aParam[24,9]

			cCorpo	:= "*****Tratamento de pedidos de vendas (Operação - " + IIF(nOper==3,'Inclusão','Alteração') + ") *****" + CRLF + CRLF
			cCorpo	+= "Inicio do processamento de Pedido de Venda de acordo os dados abaixo: Voucher"+ CRLF + CRLF
			cCorpo	+= "Ambiente : " + cAmbSrv + CRLF
			cCorpo	+= "Função de Processamento : " + cFunProc +" Linha: "+cLineProc+ CRLF
			cCorpo	+= "Servidor Processamento : " + Alltrim(cIpSrv) + " Porta : "+Alltrim(cPortSrv) + CRLF
			cCorpo	+= "Identificação da Fila : " + cId + CRLF
			cCorpo	+= "Pedido: " + cPedLog + CRLF
			cCorpo	+= "Data: " + DtoC(Date()) + " Hora: "+Time()+ CRLF

			U_GTPutOUT(cID,"P",cPedLog,{"VNDA260",{.F.,"M00002",cNumPed,cCorpo,aParam[24]}},aParam[17])

			//DUA                  //SAGE
		ElseIf aParam[22] == "8" .OR. aParam[22] == "11"

			//cabeçalho
			aCabPV:={	{"Z11_CODDUA"	,aParam[32]	,Nil},; // Codigo DUA
			{"Z11_TPPES"	,iiF(Len(aParam[33]) <> 11,"J","F")	,Nil},; // Tipo de Pessoa
			{"Z11_CGC"		,aParam[33]	,Nil},; // Cpf CnpJ
			{"Z11_MUN"		,aParam[34]	,Nil},; // Municipio
			{"Z11_INFCOM"	,aParam[35]	,Nil},; // Informações Complementares
			{"Z11_EST"		,aParam[36]	,Nil},; // Estado
			{"Z11_PEDSIT"	,aParam[17] ,Nil},; // Pedido Site
			{"Z11_DATA"		,date()	    ,Nil},; // Data
			{"Z11_ORIGEM"	,aParam[22]	,Nil},; // Origem do pedido
			{"Z11_SAGE" 	,aParam[19]	,Nil},; // Voucher Sage
			{"Z11_TOTAL"	,aParam[28]	,Nil} } // Total

			//itens
			For nI := 1 To Len(aProdutos)
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + aProdutos[nI,2])

				IF SB1->B1_CATEGO $ cCategoHRD
					cOpPro		:= cOperVenH
					cOpEnt		:= cOperEntH

					If aParam[22] $ cOriOpeAnt
						cOpPro		:= '52'
						cOpEnt		:= '53'
					EndIf
				Else
					cOpPro		:= cOperVenS

					If aParam[22] $ cOriOpeAnt
						cOpPro		:= '51'
					EndIf
				EndIf

				//TODO Parametro nao existe na SX6
				If SB1->B1_CATEGO $ cCategoSFW
					nItemPed++
					AADD(aItemPV,{	{"Z12_CODDUA"	,aParam[32] ,Nil},; // DUA do Item no Pedido
					{"Z12_ITEM"		,StrZero(nItemPed, TamSX3("C6_ITEM")[1]) ,Nil},; // Numero do Item no Pedido
					{"Z12_PRODUT"	,aProdutos[nI,2]		,Nil},; // Codigo do Produto
					{"Z12_QTDVEN"	,IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3])	,Nil},; // Quantidade Vendida   ***
					{"Z12_PRUNIT"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // PRECO DE LISTA      ***
					{"Z12_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
					{"Z12_OPER"		,cOpPro 	,Nil},; // Operação de faturamento    ***
					{"Z12_PROGAR"	,aProdutos[nI,7]		,Nil},;	// Codigo Produto GAR
					{"Z12_XCDPRC"	,aProdutos[nI,8]		,Nil},;	// Codigo Combo
					{"Z12_PEDSIT"	,aParam[17]				,Nil}}) // Numero do Pedido sITE

					nTotPed += IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3]) * IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])
				
				//TODO Parametro nao existe na SX6
				ElseIf SB1->B1_CATEGO $ cCategoHRD .and. !aParam[25] .and. !cOpPro $ cOperNPF
					nItemPed++
					AADD(aItemPV,{	{"Z12_ITEM"		,StrZero(nItemPed, TamSX3("C6_ITEM")[1]) ,Nil},; // Numero do Item no Pedido
					{"Z12_PRODUT"	,aProdutos[nI,2]		,Nil},; // Codigo do Produto
					{"Z12_QTDVEN"	,IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3])	,Nil},; // Quantidade Vendida   ***
					{"Z12_PRUNIT"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // PRECO DE LISTA      ***
					{"Z12_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
					{"Z12_OPER"		,cOpPro 	,Nil},; // Operação de faturamento    *** Mudar o C6_OPER para retorno do tipo de operacao aRvou//////////
					{"Z12_XOPER"	,cOpPro		,Nil},; // Operação de faturamento    ***
					{"Z12_PROGAR"	,aProdutos[nI,7]		,Nil},;	// Codigo Produto GAR
					{"Z12_XCDPRC"	,aProdutos[nI,8]		,Nil},;	// Codigo Combo
					{"Z12_PEDSIT"	,aParam[17]				,Nil}}) // Numero do Pedido sITE

				EndIf
			Next nI

			For nItem := 1 to Len(aItemPV)
				nPosItem := aScan(aItemPV[nItem], {|x| AllTrim(x[1]) == "Z12_ITEM"})
				aItemPV[nItem][nPosItem][2] := StrZero(nItem, TamSX3("Z12_ITEM")[1])
			Next nItem

			U_GTPutIN(cID,"P",cPedLog,.T.,{"U_VNDA260",cPedLog,aCabPV,aItemPV},aParam[17],{aParam[11],alltrim(aParam[18]),aParam[19]})

			DbSelectArea('Z11')
			Z11->(DbSetOrder(2))
			IF !DbSeek(xFilial('Z11')+aParam[17])
				aRet := U_VNDA720A(aCabPV,aItemPV)

				If aRet[1]
					U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.T.,"M00001",cPedLog,"DUA Incluída com Sucesso"}},aParam[17])
				Else
					U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.F.,"E00013",cPedLog,aRet[2]}},aParam[17])
				EndIf
			Else
				U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"DUA Ja existe no Sistema Protheus"}},aParam[17])
				U_GTPutIN(cID,"A",cPedLog,.T.,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"DUA Ja existe no Sistema Protheus"},aParam[17],aParam[11],alltrim(aParam[18]),aParam[19]})
				cNumPed := ""
				_lExitPed:=.T.
			Endif

		Else
			cLibFat := "S" //O Pedido de verejo sempre entra liberado.
			//RENATO RUY - 05/01/2018
			//Val(aParam[22]) <= Len(aOrigemPV) .AND. aOrigemPV[Val(aParam[22])] =='8'
			//A posição do array é diferente, estava retornando em branco e por este motivo não entrava.
			//Para Origem 8 - cursos - entra bloqueado para análise de retenção de impostos pela equipe Fiscal
			//Para origem 16 - Domicilio
			IF aParam[22] == '4'
				IF !empty(aParam[39])
					cLibFat := "P" //Assim que identificado o pagamento a equipe fiscal realiza a adequação do pedido e muda o status para "S"  
				else
					cLibFat := "N" //Enquanto nao existe pagamento, o pedido não é análisado pelo fiscal e também impedido de faturar. 
				Endif
			ElseIF aParam[22] == '16'
				//Enquanto nao existe mensagem de Notifica Validação Externa, o pedido não é análisado pelo fiscal e também impedido de faturar. 
				cLibFat := "N" 
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
						{"C5_VEND1"		,cVend1		,Nil},; // Vendedor1
						{"C5_VEND2"		,cVend2		,Nil},; // Vendedor2
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
						{"C5_TOTPED"	,aParam[28]	,Nil},; // Valor liquido
						{"C5_MENNOTA"	,cMenNot	,Nil},; // Mensagem da Nota
						{"C5_CHVBPAG"	,cPedGar	,Nil},; // Codigo de Pedido GAR
						{"C5_XPEDORI"	,aParam[31]	,Nil},; // Codigo de Pedido Externo
						{"C5_XITAUSP"	,aParam[30]	,Nil},; // Situação da PAgamento ShopLine
						{"C5_KPROTOC"	,aParam[37]	,Nil},; // Código de protocolo 
						{"C5_XDOCUME"	,aParam[38]	,Nil},; // Numero de documento
						{"C5_XCODAUT"   ,aParam[39]	,Nil},; // Código de autorização
						{"C5_XTIDCC"    ,aParam[40]	,Nil},; // Codigo de confirmaçao
						{"C5_XLIBFAT"   ,cLibFat	,Nil},; // Lib Fat S=SIM;N=NAO;P=PENDENTE
						{"C5_XCODREV"	,aParam[42] ,Nil},; // CodRev utilizado pelo Parceiro	
						{"C5_XNPECOM"	,cPedEcomm	,Nil},; // Pedido Ecommerce
						{"C5_XCUPOM"	,aParam[44]	,Nil},; // Cupom Desconto
						{"C5_TOTBRUT"	,aParam[45]	,Nil},; // Valor Bruto
						{"C5_XVALCUP"	,aParam[46]	,Nil},; // Valor Desconto (Cupom)
						{"C5_XOBS"		,cObservacao,Nil}}  // Observação

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
			nTotItem := 0 

			For nI := 1 To Len(aProdutos)

				//Soma total valor itens para comparar com o cabeçalho. André Sant'ana - Compila
				nTotItem += (Iif(ValType(aProdutos[nI,4]) == "C",Val(aProdutos[nI,4]),aProdutos[nI,4]) * ;
				IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3]))
				
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
	
					//12.10.2020
					//Tratamento para midia avulsa em pedido eCommerce - utilizar operacao legado
					//Produto item SC6 é igual ao Produto GAR && Não é combo && Não é delivery
					If aProdutos[nI,2] == aProdutos[nI,7] .And. Empty(aProdutos[nI,8]) .And. !aParam[25]
						cOpPro := "52"
						cOpEnt := "53"
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

				//Código do COMBO
				cC6_XSKU := ''
				IF .NOT. Empty( aProdutos[nI,8] )
					DbSelectArea("SZI")
					DbSetOrder(1) 
					IF SZI->( DbSeek( xFilial("SZI") + aProdutos[nI,8] ) )
						cC6_XSKU := Alltrim( SZI->ZI_PROKIT )
					EndIF
				EndIF

				//Ajuste no número Pedido eCommerce
				cC6_XNPECOM := IIF( Len(aProdutos[nI,19]) > 14, Right(aProdutos[nI,19],14), aProdutos[nI,19] )

				If SB1->B1_CATEGO $ cCategoSFW
					nItemPed++

					AADD(aItemPV,{	{"C6_ITEM"		,StrZero(nItemPed, TamSX3("C6_ITEM")[1]) 									, Nil },; //1 Numero do Item no Pedido
									{"C6_PRODUTO"	,aProdutos[nI,2]															, Nil },; //2 Codigo do Produto
									{"C6_QTDVEN"	,aProdutos[nI,3]															, Nil },; //3 Quantidade
									{"C6_PRCVEN"	,aProdutos[nI,4]															, Nil },; //4 Preço de Unitario            *** //{"C6_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
									{"C6_PRUNIT"	,aProdutos[nI,4]															, Nil },; //5 Preço de Unitario de Lista   *** //{"C6_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
									{"C6_OPER"		,cOpPro 																	, Nil },; //6 Operacao de faturamento    *** Mudar o C6_OPER para retorno do tipo de operacao aRvou//////////
									{"C6_XOPER"		,cOpPro																		, Nil },; //7 Operacao de faturamento    ***
									{"C6_LOCAL"		,cArmazem																	, Nil },; //8 ArmazÃ©m PadrÃ£o
									{"C6_PROGAR"	,aProdutos[nI,7]															, Nil },; //9 Codigo Produto GAR
									{"C6_XCDPRCO"	,aProdutos[nI,8]															, Nil },; //10 Codigo Combo
									{"C6_ENTREG"	,aProdutos[nI,9]															, Nil },; //11 Data da Entrega
									{"C6_XNUMVOU"	,aProdutos[nI,11]															, Nil },; //12 Numero do Voucher
									{"C6_XQTDVOU"	,aProdutos[nI,12]															, Nil },; //13 Quantidade do Voucher
									{"C6_PEDGAR"	,cPedGar																	, Nil },; //14 Numero do Pedido GAR
									{"C6_UNEG"		,ACV->(GetAdvFVal('ACV','ACV_CATEGO',xFilial('ACV')+aProdutos[nI,2],5))		, Nil },; //15 Código da Unidade de Negócio.
									{"C6_XPEDORI"	,aProdutos[nI,14]															, Nil },; //16 Pedido de Origem
									{"C6_XIDPED"	,aProdutos[nI,15]															, Nil },; //17 Id Pedido 
									{"C6_XIDPEDO"	,aProdutos[nI,16]															, Nil },; //18 Id Pedido origem
									{"C6_TIPVOU"	,aProdutos[nI,18]															, Nil },; //19 Tipo do Voucher
									{"C6_XSKU"		,cC6_XSKU																	, Nil },; //20 Produto do Combo
									{"C6_XORIGPV"	,IIF(Val(aParam[22]) <= Len(aOrigemPV), aOrigemPV[Val(aParam[22])] ,"" )	, Nil },; //21 Origem pedido de vendas
									{"C6_XNPECOM"	,cC6_XNPECOM																, Nil },; //22 Pedido Ecommerce
									{"C6_XCUPOM"	,aProdutos[nI,20]															, Nil },; //23 Cupom Desconto
									{"C6_VALDESC"	,aProdutos[nI,22]															, Nil }}) //24 Valor Desconto 

					nTotPed += IIF(ValType(aProdutos[nI,3]) == "C",Val(aProdutos[nI,3]),aProdutos[nI,3]) * IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])

				ElseIf SB1->B1_CATEGO $ cCategoHRD 
					nItemPed++
					AADD(aItemPV,{	{"C6_ITEM"		,StrZero(nItemPed, TamSX3("C6_ITEM")[1]) 	,Nil},; //1 Numero do Item no Pedido
					{"C6_PRODUTO"	,aProdutos[nI,2]							,Nil},; //1 Codigo do Produto
					{"C6_QTDVEN"	,aProdutos[nI,3]							,Nil},; //2 Quantidade
					{"C6_PRCVEN"	,aProdutos[nI,4]							,Nil},; //3 Preço de Lista      *** //{"C6_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
					{"C6_PRUNIT"	,aProdutos[nI,4]							,Nil},; //4 Preço de Lista      *** //{"C6_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
					{"C6_OPER"		,cOpPro 									,Nil},; //5 OperaÃ§Ã£o de faturamento    *** Mudar o C6_OPER para retorno do tipo de operacao aRvou//////////
					{"C6_XOPER"		,cOpPro										,Nil},; //6 OperaÃ§Ã£o de faturamento    ***
					{"C6_LOCAL"		,cArmazem									,Nil},; //7 ArmazÃ©m PadrÃ£o
					{"C6_PROGAR"	,aProdutos[nI,7]							,Nil},;	//8 Codigo Produto GAR
					{"C6_XCDPRCO"	,aProdutos[nI,8]							,Nil},;	//9 Codigo Combo
					{"C6_ENTREG"	,aProdutos[nI,9]							,Nil},; //10 Data da Entrega
					{"C6_XNUMVOU"	,aProdutos[nI,11]							,Nil},; //11 Numero do Voucher
					{"C6_XQTDVOU"	,aProdutos[nI,12]							,Nil},; //12 Quantidade do Voucher
					{"C6_PEDGAR"	,cPedGar									,Nil},; //13 Numero do Pedido GAR
					{"C6_UNEG"		,ACV->(GetAdvFVal('ACV','ACV_CATEGO',xFilial('ACV')+aProdutos[nI,2],5))		,Nil},; //14 Código da Unidade de Negócio.
					{"C6_XPEDORI"	,aProdutos[nI,14]															,Nil},; //15 Pedido de Origem
					{"C6_XIDPED"	,aProdutos[nI,15]															,Nil},; //16 Id Pedido 
					{"C6_XIDPEDO"	,aProdutos[nI,16]															,Nil},; //17 Id Pedido origem
					{"C6_TIPVOU"	,aProdutos[nI,18]															,Nil},; //18 Tipo do Voucher
					{"C6_XSKU"		,cC6_XSKU																	,Nil},; //19 Produto do Combo
					{"C6_XORIGPV"	,IIF(Val(aParam[22]) <= Len(aOrigemPV), aOrigemPV[Val(aParam[22])] ,"" )	,Nil},; //20 Origem pedido de vendas
					{"C6_XNPECOM"	,cC6_XNPECOM																,Nil},; //21 Pedido Ecommerce
					{"C6_XCUPOM"	,aProdutos[nI,20]															,Nil},; //22 Cupom Desconto
					{"C6_VALDESC"	,aProdutos[nI,22]															,Nil}}) //23

					AADD(aItemHrd,  {StrZero(nItemPed, TamSX3("C6_ITEM")[1]), cOpPro} )

					If !aParam[25] .and. !cOpPro $ cOperNPF
						nItemPed++
						AADD(aItemPV,{	{"C6_ITEM"	,StrZero(nItemPed, TamSX3("C6_ITEM")[1]) 	,Nil},; //1 Numero do Item no Pedido
						{"C6_PRODUTO"	,aProdutos[nI,2]							,Nil},; //2 Codigo do Produto
						{"C6_QTDVEN"	,aProdutos[nI,3]							,Nil},; //3 Quantidade
						{"C6_PRCVEN"	,aProdutos[nI,4]							,Nil},; //4 Preço de Lista      *** //{"C6_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
						{"C6_PRUNIT"	,aProdutos[nI,4]							,Nil},; //5 Preço de Lista      *** //{"C6_PRCVEN"	,IIF(ValType(aProdutos[nI,5]) == "C",Val(aProdutos[nI,5]),aProdutos[nI,5])	,Nil},; // Preco Unitario Liquido   ***
						{"C6_OPER"		,cOpEnt 									,Nil},; //6 OperaÃ§Ã£o de faturamento    *** Mudar o C6_OPER para retorno do tipo de operacao aRvou//////////
						{"C6_XOPER"		,cOpEnt										,Nil},; //7 OperaÃ§Ã£o de faturamento    ***
						{"C6_LOCAL"		,cArmazem									,Nil},; //8 ArmazÃ©m PadrÃ£o
						{"C6_PROGAR"	,aProdutos[nI,7]							,Nil},;	//9 Codigo Produto GAR
						{"C6_XCDPRCO"	,aProdutos[nI,8]							,Nil},;	//10 Codigo Combo
						{"C6_ENTREG"	,aProdutos[nI,9]							,Nil},; //11 Data da Entrega
						{"C6_XNUMVOU"	,aProdutos[nI,11]							,Nil},; //12 Numero do Voucher
						{"C6_XQTDVOU"	,aProdutos[nI,12]							,Nil},; //13 Quantidade do Voucher
						{"C6_PEDGAR"	,cPedGar									,Nil},; //14 Numero do Pedido GAR
						{"C6_UNEG"		,ACV->(GetAdvFVal('ACV','ACV_CATEGO',xFilial('ACV')+aProdutos[nI,2],5))		,Nil},; //15 Código da Unidade de Negócio.
						{"C6_XPEDORI"	,aProdutos[nI,14]															,Nil},; //16 Pedido de Origem
						{"C6_XIDPED"	,aProdutos[nI,15]															,Nil},; //17 Id Pedido 
						{"C6_XIDPEDO"	,aProdutos[nI,16]															,Nil},; //18 Id Pedido origem
						{"C6_TIPVOU"	,aProdutos[nI,18]															,Nil},; //19 Tipo do Voucher
						{"C6_XSKU"		,cC6_XSKU																	,Nil},; //20 Produto do Combo
						{"C6_XORIGPV"	,IIF(Val(aParam[22]) <= Len(aOrigemPV), aOrigemPV[Val(aParam[22])] ,"" )	,Nil},; //21 Origem pedido de vendas
						{"C6_XNPECOM"	,cC6_XNPECOM																,Nil},; //22 Pedido Ecommerce
						{"C6_XCUPOM"	,aProdutos[nI,20]															,Nil},; //23 Cupom Desconto
						{"C6_VALDESC"	,aProdutos[nI,22]															,Nil}}) //24

						AADD(aItemHrd,  {StrZero(nItemPed, TamSX3("C6_ITEM")[1]), cOpEnt} )
					EndIf
				EndIf
			Next nI

			_lExitPed := .F.
			/*
			Ajustes de código para atender Migração versão P12
			Uso de DbOrderNickName
			OTRS:2017103110001774
			*/

			DbSelectArea("SC5")
			DbOrderNickName("PEDSITE")		
			lSeek := DbSeek(xFilial('SC5')+aParam[17])

			IF .NOT. lSeek .And. nOper == 3
				lExecAuto := ( Len( aCabPv ) > 0 .And. Len( aItemPV ) > 0 ) 

				/*
				Caso identificado que há diferença dos totais
				É enviado um email para os citados no parametro para melhor analise
				André Sant'ana - Compila
				*/
				If !(nTotItem == aParam[28])

					lExecAuto := .F. 
					cObs := (STRTRAN(ArrTokStr(aCABPV),"|", "<br>") + STRTRAN(ArrTokStr(aItemPV),"|", "<br>"))

					oProcess	:= TWFProcess():New( "INC_PEDIDO","Diferença Cabeçalho x Itens" )
					oProcess:NewTask( "INC_PEDIDO","\WORKFLOW\INC_PEDIDO.htm")
			
					oHtml 		:= oProcess:oHtml
					oHtml:ValByName( "CPEDSITE" , aParam[17]  )
					oHtml:ValByName( "COBS"     , cObs)
					//oHtml:ValByName( "COBS"     , VarInfo("",{"INC_PEDIDO",{aCabPV,aItemPV}},,.F.,.F.))
					oProcess:cTo 		:= GetMv("CT_XDIFFAT")
					oProcess:cSubject 	:= "Integração de Pedido"
					oProcess:CFROMNAME	:= "NO-REPLY"
					oProcess:Start()
					oProcess:Free()

				EndIf 

				IF lExecAuto
					U_GTPutIN(cID,"P",cPedLog,.T.,{"U_VNDA260",cPedLog,aCabPV,aItemPV},aParam[17],{aParam[11],alltrim(aParam[18]),aParam[19]})

					cEmpOld := cEmpAnt
					cFilOld := cFilAnt
					lFatFil := STATICCALL( VNDA190, FATFIL, cNumPed )

					MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,nOper)

					STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
				Else
					cMsg := 'Dados do Cabeçalho OU Item vazios. Primeiro passo verificar código do produto se existe na base(B1/B2/B5) e B1_CATEGO'
					U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.F.,"E00013",cPedLog,cMsg,aParam,aProdutos}},aParam[17])
					cNumPed := ""
					_lExitPed := .T.
				EndIF		
			ElseIF lSeek .And. nOper == 4
				cEmpOld := cEmpAnt
				cFilOld := cFilAnt
				lFatFil := STATICCALL( VNDA190, FATFIL, SC5->C5_NUM )

				aCabPV:={	{"C5_NUM"		,SC5->C5_NUM	,Nil},; //-- Numero do Pedido
				{"C5_MENNOTA"	,cMenNot		,Nil},; //-- Total Liquido
				{"C5_TOTPED"	,aParam[28]		,Nil},; //-- Total Liquido
				{"C5_TOTBRUT"	,aParam[45]		,Nil}}  //-- Total Bruto

				U_GTPutIN(cID,"A",cPedLog,.T.,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"Pedido Ja existe no Sistema Protheus e será alterado"},aParam[17],aParam[11],alltrim(aParam[18]),aParam[19]})		

				cMVAltped := GetMv("MV_ALTPED")

				PutMv("MV_ALTPED","S")

				MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,nOper)

				PutMv("MV_ALTPED",cMVAltped)

				If !lMsErroAuto
					U_GTPutOUT(cID,"A",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"Pedido Alterado com Sucesso"}},aParam[17])
				EndIf

				STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
			Else

				U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"Pedido Ja existe no Sistema Protheus",}},aParam[17])
				U_GTPutIN(cID,"A",cPedLog,.T.,{"EXECUTAPEDIDOS",{.T.,"M00001",aParam[17],"Pedido Ja existe no Sistema Protheus"},aParam[17],aParam[11],alltrim(aParam[18]),aParam[19]})
				cNumPed := ""
				_lExitPed := .T.
			Endif

			If lMsErroAuto
				//		MOSTRAERRO()
				cMsg := "Inconsistência ao Gerar o Pedido: " + CRLF + CRLF
				aAutoErr := GetAutoGRLog()
				For nI := 1 To Len(aAutoErr)
					cMsg += aAutoErr[nI] + CRLF
				Next nI
				lRet := .F.

				U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.F.,"E00013",cPedLog,cMsg}},aParam[17])

				cNumPed := ""
			ElseIf !_lExitPed
				DbSelectArea("SC5")
				//DbSetOrder(8)
				SC5->(DbOrderNickName("PEDSITE"))//Alterado por LMS em 03-01-2013 para virada
				If DbSeek(xFilial("SC5") + aParam[17])
					cNumPed := SC5->C5_NUM
					nRecPed	:= SC5->(Recno())

					If Len(aItemHrd) > 0

						//Realizada alteração do pedido para os casos onde o mesmo deve contar com 
						//hardware faturado em outra filial, pois é necessário que o software considere 
						//as regras contabeis e fiscais de SP
						cEmpOld := cEmpAnt
						cFilOld := cFilAnt
						lFatFil := STATICCALL( VNDA190, FATFIL, cNumPed )

						IF lFatFil 
							aItemPV := {}
							For nI:=1 to Len(aItemHrd)
								AADD(aItemPV,{	{"LINPOS"		, "C6_ITEM"			, aItemHrd[nI,1]	},; // Numero do Item no Pedido
								{"AUTDELETA"	, "N"				, Nil				},; // Se o item deve ser excluído
								{"C6_OPER"		, aItemHrd[nI,2]	, Nil				}	})//Operação a ser atualizada para ajustar o item de acordo a FIlial
							Next nI

							MSExecAuto({|x,y,z|Mata410(x,y,z)},{{"C5_NUM",cNumPed,Nil}},aItemPV,4)

							If lMsErroAuto
								//						MOSTRAERRO()
								cMsg := "Inconsistência ao Alterar o Pedido: " + CRLF + CRLF
								aAutoErr := GetAutoGRLog()
								For nI := 1 To Len(aAutoErr)
									cMsg += aAutoErr[nI] + CRLF
								Next nI
								lRet := .F.

								U_GTPutOUT(cID,"P",cPedLog,{"ALT_PEDIDO",{.F.,"E00013",cPedLog,cMsg}},aParam[17])

								cNumPed := ""
							EndIf
							STATICCALL( VNDA190, FATFIL, nil ,cFilOld )
						ENDIF	

					EndIf

					If !Empty(cNumPed)
						SC5->(DbGoTo(nRecPed))
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

							cMsg := "Pedido ERP [" + cNumPed + "] (Operação - " + IIF(nOper==3,'Inclusão','Alteração') + ") realizado com sucesso." + CRLF + CRLF
							U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.T.,"M00001",cPedLog,cMsg}},aParam[17])
						EndIf
					EndIf
				EndIf
				//Registra no Atendimento(SDK) o numero do pedido protheus gerado
				//TOTVS - Rafael Beghini | 26.07.2016
				IF aParam[22] == '9' .and. !empty(cNumPed) //SAC(9)
					DbSelectArea("ADE")
					ADE->( dbSetOrder(1) )
					IF ADE->( dbSeek( xFilial('ADE') + aParam[37] ) )
						ADE->( RecLock('ADE', .F.) )
						ADE->ADE_XPSITE := aParam[17]
						ADE->ADE_KC5NUM := cNumPed
						ADE->( MsUnlock() )

						cMsg := 'Gravado Pedido ' + cNumPed + ' no protocolo ' + aParam[37] + '.'  
						U_GTPutOUT(cID,"P",cPedLog,{"INC_PEDIDO",{.T.,"000180",cPedLog,cMsg}},aParam[17])
					EndIF
				EndIF
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

				aRetFat := U_VNDA190( cID ,aParamFun	)
				lRet	 := aRetFat[1]
				cMsg 	 := aRetFat[2]

			ElseIf !Empty(aParam[39])   //Tem autorização

				cTagTipo := '0'

				If Val(aParam[30])> 0 .and. Val(aParam[30]) <= Len( __Shop ) 
					cTagTipo := __Shop[val(aParam[30])]
				Endif

				cXml:='<notificaProcessamentoCartao>'
				cxml+='  <pedido>'
				cxml+='    <numero>'+aParam[17]+'</numero>'
				cxml+='  </pedido>'
				cxml+='  <confirmacao>'
				cxml+='    <tipo>'+cTagTipo+'</tipo>'
				cxml+='    <cartao>'+aParam[11]+'</cartao>'
				cxml+='    <documento>'+aParam[38]+'</documento>'
				cxml+='    <codigoConfirmacao>'+aParam[40]+'</codigoConfirmacao>'
				cxml+='    <autorizacao>'+aParam[39]+'</autorizacao>'
				cxml+='  </confirmacao>'
				cxml+='</notificaProcessamentoCartao>'

				aRetFat:= U_Vnda262(cID, cXml,'', '', '')
				lRet	 := aRetFat[1]
				cMsg 	 := aRetFat[2]

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
		//29/06/20 - Removida descrição do produto - Jira PROT-52
		//cMensagem:= AllTrim(cDescri) + ";" 
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
