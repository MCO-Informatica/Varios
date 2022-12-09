# Include 'Protheus.ch'
# Include 'Topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA370    ºAutor  ³Darcio R. Sporl     º Data ³  20/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para fazer o retorno de poder de terceiro     º±±
±±º          ³e baixar o saldo do mesmo automaticamente, para controle    º±±
±±º          ³de entrega do cliente certsign.                             º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 1- cPedido     - Numero do pedido                          º±±
±±º          ³ 2- cPosto      - Codigo cliente                            º±±
±±º          ³ 3- cLjPosto    - Loja cliente                              º±±
±±º          ³ 4- cProduto    - Codigo do produto                         º±±
±±º          ³ 5- nQuantidade - Quantidade                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºUso       ³ OPVS / Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA370(cPosto, cLjPosto, cProduto, nQuantidade,cCodOper)

Local aArea		:= GetArea()
Local cQryTER	:= ""
Local cTesRem	:= GetMV("MV_XTESREM",,"611")		//Tes utilizado para busca das notas emitidas para poder de terceiro (Remessa)
Local cTesDev	:= GetMV("MV_XTESDEV",,"001")		//Tes utilizado para devolucao de poder de terceiro
Local cTesSai	:= GetMV("MV_XTESSAI",,"501")		//Tes utilizado para faturamento final
Local cTipoNF	:= GetMV("MV_XTPDEVO",,"B")			//Devera ser informado o tipo de documento de entrada referente a devolucao
Local cEspecie	:= GetMV("MV_XESPECI",,"NFE")		//Devera ser informada a especie na nota fiscal de entrada, referente a devolucao
//Local cCodOper	:= GetMV("MV_XCODOPER",,"53")      //Codigo de operacao da nf de devolucao para geracao da tes
Local aLinha	:= {}
Local aItens	:= {}
Local aCab		:= {}
Local nQtdIni	:= nQuantidade						//Guarda a quantidade inicial, para ser utilizado no faturamento do pedido de venda
Local lErro		:= .F.
Local cMensagem	:= "Processo concluído com sucesso."
Local cSerieDev	:= GetNewPar("MV_XSERDEV","")
Local cNumDev	:= ""  
Local nRecSF1Hrd:= 0

Private lMsErroAuto := .F.
//Private lAutoErrNoFile	:= .T.

if cCodOper!=nil
	Conout("Posto: " + cPosto + " Loja: " + cLjPosto + " Produto: " + cProduto + " Tipo da Operacao: " + cCodOper + " Quantidade: " + AllTrim(Str(nQuantidade)))
	cTesDev	:= GetMV("MV_XTESDEG")
	cTesRem := GetMV("MV_XTESREG")
	cTipoNF := "N"
	cSerieDev	:= GetMV("MV_XSERGAR")
else
	Conout("Posto: " + cPosto + " Loja: " + cLjPosto + " Produto: " + cProduto + " TES: " +cTesDev + " Quantidade: " + AllTrim(Str(nQuantidade)))
endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busco todas as notas que estao em poder de terceiros que ainda³
//³possuem saldo, para poder retornar como Beneficiamento, para  ³
//³poder faturar o novo pedido de vendas.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQryTER := "SELECT SD2.D2_PEDIDO, SD2.D2_NUMSEQ, SD2.D2_ITEM, SD2.D2_COD, SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL, SD2.D2_VALIPI, SD2.D2_VALICM, "
cQryTER += "       SD2.D2_BASEIPI, SD2.D2_BASEICM, SD2.D2_TES, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_TXMOEDA, SB6.B6_IDENT, SB6.B6_SALDO "
cQryTER += "FROM " + RetSqlName("SD2") + " SD2 "
cQryTER += "JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA  AND SF2.D_E_L_E_T_ = ' ' "
cQryTER += "JOIN " + RetSqlName("SB6") + " SB6 ON SB6.B6_FILIAL = '" + xFilial("SB6") + "' AND SB6.B6_PRODUTO = SD2.D2_COD AND SB6.B6_DOC = SF2.F2_DOC AND SB6.B6_SERIE = SF2.F2_SERIE AND SB6.B6_CLIFOR = SF2.F2_CLIENTE AND SB6.B6_SERIE = SF2.F2_SERIE AND SB6.B6_SALDO > 0 AND SB6.D_E_L_E_T_ = ' ' "
cQryTER += "WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
cQryTER += "  AND SD2.D2_CLIENTE = '" + cPosto + "' "
cQryTER += "  AND SD2.D2_LOJA = '" + cLjPosto + "' "
cQryTER += "  AND SD2.D2_COD = '" + cProduto + "' "
cQryTER += "  AND SD2.D2_TES = '" + cTesRem + "' "
cQryTER += "  AND SD2.D_E_L_E_T_ = ' ' "
cQryTER += "ORDER BY SD2.D2_NUMSEQ"

cQryTER := ChangeQuery(cQryTER)

conout("Query da NF dev: "+cQryTER)
	
TCQUERY cQryTER NEW ALIAS "QRYTER"
DbSelectArea("QRYTER")
 
QRYTER->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Enquanto nao zerar a quantidade vendida, continuo fazendo as³
//³devolucoes de terceiro.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aItens	:= {}
aCab	:= {}
While QRYTER->(!Eof()) .And. nQuantidade > 0

	aLinha	:= {}

	cNumDev	:= NxtSX5Nota(cSerieDev, .T., "1")		//Controle da numeracao pelos arquivos SXE e SXF
	cNumDev := PadR(cNumDev, TamSX3("F1_DOC")[1])

	Conout("Nota de Devolução: " + cNumDev + "Série de Devolução: " + cSerieDev)

	AAdd( aLinha, { "D1_DOC"    	, cNumDev																					, Nil } )	
	AAdd( aLinha, { "D1_SERIE"    	, cSerieDev																					, Nil } )	
	AAdd( aLinha, { "D1_FORNECE"   	, QRYTER->F2_CLIENTE																		, Nil } )	
	AAdd( aLinha, { "D1_LOJA"    	, QRYTER->F2_LOJA	    																	, Nil } )		
	AAdd( aLinha, { "D1_COD"    	, QRYTER->D2_COD 	    																	, Nil } )
	AAdd( aLinha, { "D1_NFORI"		, QRYTER->F2_DOC																			, Nil } )
	AAdd( aLinha, { "D1_SERIORI"	, QRYTER->F2_SERIE																			, Nil } )
	AAdd( aLinha, { "D1_ITEMORI"   	, QRYTER->D2_ITEM 	    																	, Nil } )
	AAdd( aLinha, { "D1_QUANT"		, Iif(nQuantidade < QRYTER->B6_SALDO, nQuantidade, QRYTER->B6_SALDO)						, Nil } )
	AAdd( aLinha, { "D1_VUNIT"		, QRYTER->D2_PRCVEN																			, Nil } ) 
	AAdd( aLinha, { "D1_TOTAL"		, Iif(nQuantidade < QRYTER->B6_SALDO, nQuantidade, QRYTER->B6_SALDO) * QRYTER->D2_PRCVEN	, Nil } )
	AAdd( aLinha, { "D1_TES"		, cTesDev																					, Nil } )
//	AAdd( aLinha, { "D1_EMISSAO"	, dDataBase																					, Nil } )
//	AAdd( aLinha, { "D1_VALIPI"		, QRYTER->D2_VALIPI																			, Nil } ) 
//	AAdd( aLinha, { "D1_VALICM"		, QRYTER->D2_VALICM																			, Nil } ) 
//	AAdd( aLinha, { "D1_BASEIPI"	, QRYTER->D2_BASEIPI																		, Nil } ) 
//	AAdd( aLinha, { "D1_BASEICM"	, QRYTER->D2_BASEICM																		, Nil } ) 
//	if cCodOper!=nil
//		AAdd( aLinha, { "D1_OPER"		, cCodOper																					, Nil } )
//	else
//			AAdd( aLinha, { "D1_TES"		, cTesDev																					, Nil } )
//	endif
	AAdd( aLinha, { "D1_IDENTB6"	, QRYTER->D2_NUMSEQ																			, Nil } )
    AAdd( aItens, aLinha)  

	nQuantidade	:= nQuantidade - QRYTER->B6_SALDO
	
	QRYTER->(DbSkip())
	
End

AAdd( aCab, { "F1_DOC"    , cNumDev						, Nil } )	// Numero da NF : Obrigatorio
AAdd( aCab, { "F1_SERIE"  , cSerieDev					, Nil } )	// Serie da NF  : Obrigatorio
AAdd( aCab, { "F1_FORMUL" , "S"							, Nil } )
AAdd( aCab, { "F1_EMISSAO", dDataBase					, Nil } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o cabecalho de acordo com o tipo da devolucao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd( aCab, { "F1_FORNECE", cPosto						, Nil } )	// Codigo do Cliente 	: Obrigatorio
AAdd( aCab, { "F1_LOJA"   , cLjPosto   					, Nil } )	// Loja do Cliente	   	: Obrigatorio
AAdd( aCab, { "F1_TIPO"   , cTipoNF						, Nil } )	// Tipo da NF   		: Obrigatorio
AAdd( aCab, { "F1_ESPECIE", cEspecie					, Nil } )	// Especie da NF   		: Obrigatorio
//	AAdd( aCab, { "F1_TXMOEDA", QRYTER->F2_TXMOEDA			, Nil } ) 

varinfo("Arrays do cabecalho execauto mata103",aCab)
varinfo("Arrays dos itens execauto mata103",aItens)

MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCab, aItens, 3)

DbSelectArea("QRYTER")
DbCloseArea()

If lMsErroAuto
	lErro		:= .T.
	cMensagem	:= "Inconsistência na devolução do poder de terceiros."
//	aAutoErr := GetAutoGRLog()
//	For nI := 1 To Len(aAutoErr)
//		cAutoErr += aAutoErr[nI] + CRLF
//	Next nI
	DisarmTransaction()
	MostraErro("\system\", "poder_terceiros.txt")
else
	nRecSF1Hrd := SF1->( RecNo() )
EndIf

RestArea(aArea)
Return({lErro,cMensagem,nRecSF1Hrd})