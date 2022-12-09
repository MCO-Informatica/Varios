#INCLUDE 'protheus.ch'
#INCLUDE "ConsolidadoRemuneracao.ch"

/**
* Classe responsável por gerir as informações e Objetos referentes ao 
* processo de Fechamento de Remuneração e geração das devidas ordens
* de pagamento ao Fornecedor por meio do Pedido de Compra.
*
* @class   	ConsolidadoRemuneracao
* @version  1.0
* @date     11/08/2020
*
**/
class ConsolidadoRemuneracao 

	Data cCodigoAC
	Data cPeriodo
	Data cCodigoEntidade
	Data cDescEntidade
	Data nQtdePedidos
	Data nValorSW
	Data nValorHW
	Data nValorFat
	Data nComissaoSw
	Data nComissaoHw
	Data nComissaoTotal
	Data nSaldo
	Data nValorFederacao
	Data nValorCampanha
	Data nValorVisita
	Data nValorTotal
	Data cOrigemRegistro
	Data nValorFedSW
	Data nValorFedHW
	Data nValorCampSW
	Data nValorCampHW
	Data nValorPosto
	Data nValorPostoSW
	Data nValorPostoHW
	Data nValorAR
	Data nValorARSW
	Data nValorARHW
	Data cFornecedor
	Data cLojaFornecedor
	Data cCondicaoPgto
	Data cCentroCusto
	Data cContaContabil
	Data cFormaPagamento
	Data cNumeroNF
	Data dVencimento
	Data cContrato
	Data cCNPJ

	Data nLinhaArquivo
	Data cNomeArquivo

	Data oContrato
	Data oPedido

	Data cMedicao
	Data cPedido
	Data cErroPedido
	Data cErroImport
	Data cErrorFind
	Data nRecno

	method new() constructor 
	Method fromArray(aArray)
	Method Save()
	Method fromSZ6(cPeriodo, cCodEntidade)
	Method geraPedido()
	Method buscaProduto()
	Method buscaContrato()
	Method valCondPgto()
	Method validaProduto(cProduto)
	Method validaFornecedor()
	Method gravaPC5()
	Method mailAdiantamento()
	Static Method toArrayHeader()
	Static Method toCSVHeader()
	Method toCSV()
	Method toArray(cObsExtra)
	Static Method gravaCapaDespesa(ExpA2)

endclass

/**
* Método construtor
* Carrega os campos de forma básica para utilização.
*
* @method   new
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
method new() class ConsolidadoRemuneracao

	::cCodigoAC			:= ""
	::cPeriodo			:= ""		
	::cCodigoEntidade	:= ""
	::cDescEntidade		:= ""
	::nQtdePedidos		:= 0	
	::nValorSW			:= 0	
	::nValorHW			:= 0
	::nValorFat			:= 0
	::nComissaoSw		:= 0
	::nComissaoHw		:= 0	
	::nComissaoTotal	:= 0	
	::nSaldo			:= 0
	::nValorFederacao	:= 0
	::nValorCampanha	:= 0
	::nValorVisita		:= 0
	::nValorTotal		:= 0
	::cOrigemRegistro	:= ""	
	::nValorFedSW		:= 0
	::nValorFedHW		:= 0		
	::nValorCampSW		:= 0
	::nValorCampHW		:= 0
	::nValorPosto		:= 0
	::nValorPostoSW		:= 0
	::nValorPostoHW		:= 0
	::nValorAR			:= 0
	::nValorARSW		:= 0
	::nValorARHW		:= 0
	::cFornecedor		:= ""
	::cLojaFornecedor	:= ""
	::cCondicaoPgto		:= ""
	::cCentroCusto		:= ""
	::cContaContabil	:= ""
	::cFormaPagamento	:= ""
	::cNumeroNF			:= ""
	::dVencimento		:= CTOD("//")
	::cContrato			:= ""
	::cCNPJ				:= ""

	::cNomeArquivo		:= ""
	::nLinhaArquivo		:= 0

return

/**
* Método que carrega as informações de uma linha do arquivo consolidado 
* em uma instância de ConsolidadoRemuneracao, seguindo a definição de estrutura.
* O Método também é reponsável por validar a estrutura e composição dos itens.
*
* @method   fromArray
* @param    aArray Array estruturado para importação do registro 
* @return   boolean Retorna se os dados foram carregados no objeto
* @version  1.0
* @date     11/08/2020
*
**/
Method fromArray(aArray) Class ConsolidadoRemuneracao

	//TODO - Validações de arquivo
	If Len(aArray) != TAMANHO_ARQUIVO
		::cErroImport := ERRO_IMPO01
		Return .F.
	EndIf

	::new()

	::cCodigoAC			:= AllTrim(aArray[CODIGO_AC])
	::cPeriodo			:= AllTrim(aArray[PERIODO])		
	::cCodigoEntidade	:= AllTrim(aArray[COD_ENTIDADE])
	::cDescEntidade		:= AllTrim(aArray[DESC_ENTIDADE])
	::nQtdePedidos		:= Val(StrTran(aArray[QTD_PEDIDOS],",","."))	
	::nValorSW			:= Val(StrTran(aArray[VLR_SW],",","."))	
	::nValorHW			:= Val(StrTran(aArray[VLR_HW],",","."))
	::nValorFat			:= Val(StrTran(aArray[VLR_FAT],",","."))
	::nComissaoSw		:= Val(StrTran(aArray[COMISSAO_SW],",","."))
	::nComissaoHw		:= Val(StrTran(aArray[COMISSAO_HW],",","."))	
	::nComissaoTotal	:= Val(StrTran(aArray[COMISSAO_TOTAL],",","."))	
	::nSaldo			:= Val(StrTran(aArray[SALDO],",","."))
	::nValorFederacao	:= Val(StrTran(aArray[VLR_FEDERA],",","."))
	::nValorCampanha	:= Val(StrTran(aArray[VLR_CAMPANHA],",","."))
	::nValorVisita		:= Val(StrTran(aArray[VLR_VISITA],",","."))
	::nValorTotal		:= Val(StrTran(aArray[TOTAL_GERAL],",","."))
	::cOrigemRegistro	:= AllTrim(aArray[ORIGEM])	
	::nValorFedSW		:= Val(StrTran(aArray[VLR_FED_SW],",","."))
	::nValorFedHW		:= Val(StrTran(aArray[VLR_FED_HW],",","."))
	::nValorCampSW		:= Val(StrTran(aArray[VLR_CAMP_SW],",","."))
	::nValorCampHW		:= Val(StrTran(aArray[VLR_CAMP_HW],",","."))
	::nValorPosto		:= Val(StrTran(aArray[VLR_POSTO],",","."))
	::nValorPostoSW		:= Val(StrTran(aArray[VLR_POSTO_SW],",","."))
	::nValorPostoHW		:= Val(StrTran(aArray[VLR_POSTO_HW],",","."))
	::nValorAR			:= Val(StrTran(aArray[VLR_AR],",","."))
	::nValorARSW		:= Val(StrTran(aArray[VLR_AR_SW],",","."))
	::nValorARHW		:= Val(StrTran(aArray[VLR_AR_HW],",","."))
	::cFornecedor		:= Iif(IsDigit(aArray[FORNECEDOR]),;
								Padl(AllTrim(aArray[FORNECEDOR]),TamSX3("A2_COD")[1],"0"),;
								AllTrim(aArray[FORNECEDOR]))
	::cLojaFornecedor	:= Padl(AllTrim(aArray[LOJA_FORNECEDOR]),TamSX3("A2_LOJA")[1],"0")
	::cCondicaoPgto		:= AllTrim(aArray[COND_PGTO])
	::cCentroCusto		:= AllTrim(aArray[CENTRO_CUSTO])
	::cContaContabil	:= AllTrim(aArray[CTA_CONTABIL])
	::cFormaPagamento	:= AllTrim(aArray[FORMA_PGTO])
	::cNumeroNF			:= AllTrim(aArray[DOC_FISCAL])
	::dVencimento		:= Iif("/" $ aArray[VENCTO], CTOD(aArray[VENCTO]), STOD(aArray[VENCTO]))
	::cContrato			:= AllTrim(aArray[CONTRATO])
	::cCNPJ				:= AllTrim(aArray[CNPJ])
	
	::nLinhaArquivo		:= aArray[LINHA_ARQ]
	::cNomeArquivo		:= AllTrim(aArray[NOME_ARQUIVO])

Return

/**
* Método responsável por gerar a Medição do Contrato para o Fornecedor
* e alimentar o atributo cMedicao com o código gerado. Alimenta, também, o
* número do pedido de compra gerado.
*
* @method   save
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method save() Class ConsolidadoRemuneracao

	Local lNewReg := .F.

	dbSelectArea("SZ3")
	SZ3->(dbSetOrder(1))
	If !SZ3->(dbSeek(xFilial("SZ3") + ::cCodigoEntidade))
		::cErroImport := DecodeUTF8(ERRO_SAVE01) 
		Return .F.
	EndIf
	
	/*If SZ3->Z3_CODFOR + SZ3->Z3_LOJA != ::cFornecedor + ::cLojaFornecedor
		::cErroImport := DecodeUTF8(ERRO_SAVE02) + ::cFornecedor + "/" + ::cLojaFornecedor
		Return .F.		
	EndIf*/

	dbSelectArea("ZZ6")
	ZZ6->(dbSetOrder(1))
	lNewReg := !ZZ6->(dbSeek(xFilial("ZZ6") + ::cPeriodo + ::cCodigoEntidade))
	
		RecLock("ZZ6", lNewReg)
			ZZ6->ZZ6_CODAC	:= ::cCodigoAC		
			ZZ6->ZZ6_PERIOD	:= ::cPeriodo			
			ZZ6->ZZ6_CODENT	:= ::cCodigoEntidade	
			ZZ6->ZZ6_DESENT	:= ::cDescEntidade	
			ZZ6->ZZ6_QTDPED	:= ::nQtdePedidos		
			ZZ6->ZZ6_VALSW	:= ::nValorSW			
			ZZ6->ZZ6_VALHW	:= ::nValorHW			
			ZZ6->ZZ6_VALFAT	:= ::nValorFat		
			ZZ6->ZZ6_COMSW	:= ::nComissaoSw		
			ZZ6->ZZ6_COMHW	:= ::nComissaoHw		
			ZZ6->ZZ6_COMTOT	:= ::nComissaoTotal	
			ZZ6->ZZ6_SALDO	:= ::nSaldo			
			ZZ6->ZZ6_VALFED	:= ::nValorFederacao	
			ZZ6->ZZ6_VALCAM	:= ::nValorCampanha	
			ZZ6->ZZ6_VALVIS	:= ::nValorVisita		
			ZZ6->ZZ6_ORIGEM	:= ::cOrigemRegistro	
			ZZ6->ZZ6_FEDSW	:= ::nValorFedSW		
			ZZ6->ZZ6_FEDHW	:= ::nValorFedHW		
			ZZ6->ZZ6_CAMPSW	:= ::nValorCampSW		
			ZZ6->ZZ6_CAMPHW	:= ::nValorCampHW		
			ZZ6->ZZ6_VALPOS	:= ::nValorPosto		
			ZZ6->ZZ6_POSSW	:= ::nValorPostoSW	
			ZZ6->ZZ6_POSHW	:= ::nValorPostoHW	
			ZZ6->ZZ6_VALAR	:= ::nValorAR			
			ZZ6->ZZ6_ARSW	:= ::nValorARSW		
			ZZ6->ZZ6_ARHW	:= ::nValorARHW
			ZZ6->ZZ6_FORNECE:= ::cFornecedor 
			ZZ6->ZZ6_LOJA	:= ::cLojaFornecedor
			ZZ6->ZZ6_COND	:= ::cCondicaoPgto
			ZZ6->ZZ6_CCUSTO	:= ::cCentroCusto
			ZZ6->ZZ6_CC		:= ::cContaContabil
			ZZ6->ZZ6_FPGTO	:= ::cFormaPagamento
			ZZ6->ZZ6_NF		:= ::cNumeroNF
			ZZ6->ZZ6_VENC	:= ::dVencimento
			ZZ6->ZZ6_CONTRA	:= ::cContrato
			ZZ6->ZZ6_CNPJ	:= ::cCNPJ		
			ZZ6->ZZ6_DTIMP	:= dDataBase
			ZZ6->ZZ6_LINARQ := ::nLinhaArquivo
			ZZ6->ZZ6_ARQUIV := ::cNomeArquivo
		ZZ6->(MsUnlock())
		
		::nRecno := ZZ6->(Recno())

Return .T.

/**
* Método responsável por carregar as informações de um registro da tabela
* de valores Consolidados (ZZ6) para o objeto, recebendo as informações do
* período a ser considerado e da entidade para realização da busca.
*
* @method   fromSZ6
* @param    cPeriodo Periodo no formato AAAAMM para busca na SZ6
* @param    cCodEntidade Código do Parceiro da tabela SZ3
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method fromSZ6(cPeriodo, cCodEntidade) Class ConsolidadoRemuneracao

	::new()

	dbSelectArea("ZZ6")
	ZZ6->(dbSetOrder(1))
	If ZZ6->(dbSeek(xFilial("ZZ6") + cPeriodo + cCodEntidade))
		::cCodigoAC			:= AllTrim(ZZ6->ZZ6_CODAC)	
		::cPeriodo			:= AllTrim(ZZ6->ZZ6_PERIOD)	
		::cCodigoEntidade	:= AllTrim(ZZ6->ZZ6_CODENT)	
		::cDescEntidade		:= AllTrim(ZZ6->ZZ6_DESENT)	
		::nQtdePedidos		:= ZZ6->ZZ6_QTDPED
		::nValorSW			:= ZZ6->ZZ6_VALSW
		::nValorHW			:= ZZ6->ZZ6_VALHW
		::nValorFat			:= ZZ6->ZZ6_VALFAT
		::nComissaoSw		:= ZZ6->ZZ6_COMSW
		::nComissaoHw		:= ZZ6->ZZ6_COMHW
		::nComissaoTotal	:= ZZ6->ZZ6_COMTOT
		::nSaldo			:= ZZ6->ZZ6_SALDO
		::nValorFederacao	:= ZZ6->ZZ6_VALFED
		::nValorCampanha	:= ZZ6->ZZ6_VALCAM
		::nValorVisita		:= ZZ6->ZZ6_VALVIS
		::nValorTotal		:= ZZ6->ZZ6_SALDO
		::cOrigemRegistro	:= AllTrim(ZZ6->ZZ6_ORIGEM)
		::nValorFedSW		:= ZZ6->ZZ6_FEDSW
		::nValorFedHW		:= ZZ6->ZZ6_FEDHW
		::nValorCampSW		:= ZZ6->ZZ6_CAMPSW
		::nValorCampHW		:= ZZ6->ZZ6_CAMPHW
		::nValorPosto		:= ZZ6->ZZ6_VALPOS
		::nValorPostoSW		:= ZZ6->ZZ6_POSSW
		::nValorPostoHW		:= ZZ6->ZZ6_POSHW
		::nValorAR			:= ZZ6->ZZ6_VALAR
		::nValorARSW		:= ZZ6->ZZ6_ARSW
		::nValorARHW		:= ZZ6->ZZ6_ARHW
		::cFornecedor		:= AllTrim(ZZ6->ZZ6_FORNECE)
		::cLojaFornecedor	:= AllTrim(ZZ6->ZZ6_LOJA)
		::cCondicaoPgto		:= AllTrim(ZZ6->ZZ6_COND)
		::cCentroCusto		:= AllTrim(ZZ6->ZZ6_CCUSTO)
		::cContaContabil	:= AllTrim(ZZ6->ZZ6_CC)
		::cFormaPagamento	:= AllTrim(ZZ6->ZZ6_FPGTO)
		::cNumeroNF			:= AllTrim(ZZ6->ZZ6_NF)
		::dVencimento		:= ZZ6->ZZ6_VENC
		::cContrato			:= AllTrim(ZZ6->ZZ6_CONTRA)
		::cCNPJ				:= AllTrim(ZZ6->ZZ6_CNPJ)
		::nRecno			:= ZZ6->(Recno())
	EndIf
	
Return

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method geraPedido() Class ConsolidadoRemuneracao

	Local cAprova 		:= ""
	Local cTES			:= ""
	Local cProduto 		:= ""
	Local nSaveSX8 		:= GetSX8Len()
	Local aCabec		:= {}
	Local aItens		:= {}
	Local aLinha		:= {}
	Local cPeriodCapa	:= ""
	Local lEarlyReturn 	:= .F.

	If ::nRecno == 0
		::cErroPedido := ERRO_RECNO
		Return .F.
	EndIf

	dbSelectArea("ZZ6")
	ZZ6->(dbGoTo(::nRecno))
	
	dbSelectArea("SZ3")
	SZ3->(dbSetOrder(1))
	SZ3->(dbSeek(xFilial("SZ3") + ::cCodigoEntidade))
	
	dbSelectArea("AC9")
	AC9->(DbSetOrder(2)) //AC9_FILIAL, AC9_ENTIDA, AC9_FILENT, AC9_CODENT
	
	If ZZ6->ZZ6_SALDO == 0 .Or. ZZ6->ZZ6_SALDO - ::nValorTotal < 0 
		::cErroPedido := ERRO_SALDO
		Return .F.
	EndIf

	If !::validaFornecedor()
		Return .F.
	EndIf
	
	//Busca o produto para gerar o pedido.
	aRetProd := ::buscaProduto()
	cProduto := aRetProd[1]
	cTES	 := aRetProd[2]
	
	If !::validaProduto(cProduto)
		SB1->(dbSeek(xFilial("SB1") + PRODUTO_PADRAO ))
		cProduto := SB1->B1_COD	
	EndIf

	If !validaTES(cTES)
		SF4->(dbSeek(xFilial("SF4") + TES_PADRAO))
		cTES := SF4->F4_CODIGO
	EndIf

	If !::valCondPgto()
		::cCondicaoPgto := "007"
	EndIf
	
	//Prioriza a busca do contrato pelo informado no arquivo recebido
	If !Empty(::cContrato)
		::oContrato := ContratoRemuneracao():New()
		If !::oContrato:find(::cContrato)
			::cErrorFind := ::oContrato:cErrorFind

			FreeObj(::oContrato)
			::oContrato := Nil
			
		EndIf
	EndIf

	//Quando o contrato não é informado no arquivo, ou falhou a localização
	If ::oContrato == Nil
		::buscaContrato()
	EndIf

	//A verificação serve para garantir que não foi selecionado contrato
	If ::oContrato == Nil
		cNumSC7  := Criavar("C7_NUM",.T.) //Gera numero do pedido de compra
		While ( GetSX8Len() > nSaveSX8 )
			ConfirmSX8()  
		EndDo 
		
		//Cabeçalho do pedido de compras
		aCabec := {}
		aAdd(aCabec,{"C7_NUM" 		, cNumSC7			})
		aAdd(aCabec,{"C7_EMISSAO" 	, dDataBase			})
		aAdd(aCabec,{"C7_FORNECE" 	, ::cFornecedor		})
		aAdd(aCabec,{"C7_LOJA" 		, ::cLojaFornecedor	})
		aAdd(aCabec,{"C7_COND" 		, ::cCondicaoPgto	})
		aAdd(aCabec,{"C7_CONTATO"	, " "				})
		aAdd(aCabec,{"C7_FILENT" 	, xFilial("SC7")	})
		
		//Item do pedido de compras
		aLinha  := {}
		cAprova := Posicione('CTT', 1, xFilial('CTT') + ::cCentroCusto, 'CTT_GARVAR')
		aadd(aLinha,{"C7_PRODUTO" 	, cProduto			,Nil})
		aadd(aLinha,{"C7_QUANT" 	, 1 				,Nil})
		aadd(aLinha,{"C7_PRECO" 	, ::nValorTotal		,Nil})
		aadd(aLinha,{"C7_TOTAL" 	, ::nValorTotal 	,Nil})
		aadd(aLinha,{"C7_TES" 		, cTES 				,Nil})
		aadd(aLinha,{"C7_LOCAL"		, LOCAL_PADRAO		,Nil})
		aadd(aLinha,{"C7_APROV"		, cAprova 			,Nil})
		aadd(aLinha,{"C7_CONTA"		, ::cContaContabil	,Nil})
		
		//Campos da capa de despesa
		cPeriodCapa := Substr(::cPeriodo, 5, 2) + Substr(::cPeriodo, 1, 4)
		aadd(aLinha,{"C7_XREFERE"	, cPeriodCApa		,Nil})     
		aadd(aLinha,{"C7_APBUDGE"	, "1"				,Nil})
		aadd(aLinha,{"C7_XRECORR"	, "1"				,Nil})
		aadd(aLinha,{"C7_CC" 	 	, ::cContaContabil	,Nil})
		aadd(aLinha,{"C7_CCAPROV"   , ::cCentroCusto	,Nil})
		aadd(aLinha,{"C7_ITEMCTA"	, ITCTB_PADRAO		,Nil})
		aadd(aLinha,{"C7_CLVL"		, CLVLR_PADRAO		,Nil})
		aadd(aLinha,{"C7_CTAORC"	, CTAORC_PADRAO		,Nil})     
		aadd(aLinha,{"C7_FORMPG"	, ::cFormaPagamento	,Nil})      
		aadd(aLinha,{"C7_DOCFIS"	, ::cNumeroNF		,Nil})
		aadd(aLinha,{"C7_XVENCTO"	, ::dVencimento		,Nil})
		
		aadd(aItens,aLinha)

		::oPedido := PedidoRemuneracao():New()
		::oPedido:geraPedido(aCabec, aItens)
	Else
		cCompet := SubStr(DtoS(dDataBase),5,2)+"/"+SubStr(DtoS(dDataBase),1,4)
		cAprova := Posicione('CTT', 1, xFilial('CTT') + "80000000", 'CTT_GARVAR')

		aCabec := {}
		cNumCND := CriaVar("CND_NUMMED")
		aAdd(aCabec,{"CND_CONTRA"	, ::oContrato:cNumero			,NIL})
		aAdd(aCabec,{"CND_REVISA"	, ::oContrato:cRevisao			,NIL})
		aAdd(aCabec,{"CND_NUMERO"	, "000001"						,NIL})
		aAdd(aCabec,{"CND_PARCEL"	, " "							,NIL})
		aAdd(aCabec,{"CND_COMPET"	, cCompet						,NIL})
		aAdd(aCabec,{"CND_NUMMED"	, cNumCND						,NIL})
		aAdd(aCabec,{"CND_FORNEC"	, ::oContrato:cFornecedor		,NIL})
		aAdd(aCabec,{"CND_LJFORN"	, ::oContrato:cLojaFornecedor	,NIL})
		aAdd(aCabec,{"CND_CONDPG"	, ::cCondicaoPgto				,NIL})
		aAdd(aCabec,{"CND_VLTOT"	, ::nValorTotal					,NIL})
		aAdd(aCabec,{"CND_APROV"	, cAprova 						,NIL})
		//aAdd(aCabec,{"CND_ALCAPR"	, "B"							,NIL})
		aAdd(aCabec,{"CND_MOEDA"	, "1"							,NIL})
		
		aLinha := {}
		aadd(aLinha,{"CNE_ITEM" 	, "001"					,NIL})
		aadd(aLinha,{"CNE_PRODUT" 	, cProduto				,NIL})
		aadd(aLinha,{"CNE_QUANT" 	, 1 					,NIL})
		aadd(aLinha,{"CNE_VLUNIT" 	, ::nValorTotal 		,NIL})
		aadd(aLinha,{"CNE_VLTOT" 	, ::nValorTotal 		,NIL})
		aadd(aLinha,{"CNE_TE" 		, cTES					,NIL})
		aadd(aLinha,{"CNE_DTENT"	, dDatabase				,NIL})
		aadd(aLinha,{"CNE_CC" 		, ::cCentroCusto  		,NIL})
		aadd(aLinha,{"CNE_CONTA"	, ::cContaContabil		,NIL})
		//CC: 80000000
		aadd(aItens,aLinha)

		Begin Transaction
			If ::oContrato:geraMedicao(aCabec, aItens)
				If !::oContrato:encerraMedicao(aCabec, aItens)
					//::oPedido:rollback()
					::oContrato:rollbackMedicao()
					::cErroPedido := ERRO_MEDI02
					lEarlyReturn := .T.
				EndIf
			Else	
				::cErroPedido := ERRO_MEDI01
				lEarlyReturn := .T.
			EndIf

			If !lEarlyReturn
				::oPedido := PedidoRemuneracao():New()
				::oPedido:getFromMedicao(::oContrato:cMedicao)
				::cPedido := ::oPedido:cNumeroPedido

				RecLock("SC7",.F.)
					SC7->C7_FORMPG	:= ::cFormaPagamento
					SC7->C7_XVENCTO	:= ::dVencimento
				SC7->(MsUnlock())

			EndIf

		End Transaction 

		If lEarlyReturn
			Return .F.
		EndIf

	EndIf

	::oPedido:criaBaseConhecimento()
	::gravaPC5()
	::mailAdiantamento()	
	
Return .T.

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Static Method toArrayHeader() Class ConsolidadoRemuneracao
Return StrTokArr2(ConsolidadoRemuneracao():toCSVHeader(),";",.T.)

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Static Method toCSVHeader() Class ConsolidadoRemuneracao
Return "Periodo;Cod.Entidade;Desc.Entidade;Cod.AC;Qtd.Pedidos;Valor SW;Valor HW;"+;
		"Valor Fat.;Comissao SW;Comissao HW;Total Comiss;Valor Fed.;Val.Campanha;Valor Visita;"+;
		"Vl. Fed. SW;Vl. Fed. HW;Vl.Camp.SW;Vl.Camp.HW;Val.Posto;Vl.Posto.SW;Vl.Posto.HW;Valor AR;Valor AR SW;Valor AR HW;Valor Total"

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method toCSV() Class ConsolidadoRemuneracao
Return ::cPeriodo 					+";"+ ::cCodigoEntidade				+";"+ ::cDescEntidade 				+";"+ ::cCodigoAC 					+";"+;
 		cValToChar(::nQtdePedidos) 	+";"+;
 		cValToChar(::nValorSW) 		+";"+ cValToChar(::nValorHW) 		+";"+ cValToChar(::nValorFat) 		+";"+ cValToChar(::nComissaoSw) 	+";"+;
 		cValToChar(::nComissaoHw) 	+";"+ cValToChar(::nComissaoTotal) 	+";"+ cValToChar(::nValorFederacao) +";"+ cValToChar(::nValorCampanha) 	+";"+;
 		cValToChar(::nValorVisita) 	+";"+ cValToChar(::nValorFedSW) 	+";"+ cValToChar(::nValorFedHW) 	+";"+ cValToChar(::nValorCampSW) 	+";"+;
 		cValToChar(::nValorCampHW) 	+";"+ cValToChar(::nValorPosto) 	+";"+ cValToChar(::nValorPostoSW) 	+";"+ cValToChar(::nValorPostoHW) 	+";"+;
 		cValToChar(::nValorAR) 		+";"+ cValToChar(::nValorARSW) 		+";"+ cValToChar(::nValorARHW) 		+";"+ cValToChar(::nValorTotal)

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/	
Method toArray(cObsExtra) Class ConsolidadoRemuneracao

	Local aRet := StrTokArr2(::toCSV(),";",.T.) 
	Default cObsExtra := ""
	
	aAdd(aRet, cObsExtra)
	
Return aRet

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method validaFornecedor() class ConsolidadoRemuneracao

 	//Cria Entidade para tipo 7 - Revendedor 
	If !SZ3->(Found()) .And. Empty(ZZ6->ZZ6_CODAC)
		
		aAdd( aPar,{ 1  ,"Fornecedor " 	 ,Space(6),"","","SA2","",50,.T.})
	
		If ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CRPA031F" , .T., .F. )
		
			If SZ3->(Reclock("SZ3",.T.))
				SZ3->Z3_FILIAL := xFilial("SZ3")
				SZ3->Z3_CODENT := ZZ6->ZZ6_CODENT
				SZ3->Z3_TIPENT := ZZ6->ZZ6_DESENT
				SZ3->Z3_TIPCOM := "7"
				SZ3->Z3_CODFOR := aRet[1]
				SZ3->Z3_LOJA   := "01"
				SZ3->(MsUnlock())
			Else
				::cErroPedido := ERRO_ENTIDA + ZZ6->ZZ6_CODENT + " - " + ZZ6->ZZ6_DESENT
				Return .F.
			Endif
			
		Endif
	Endif

	//Verifica na tabela Amarração Entidade x Objetos
	//Se existe registro para alterar o código do fornecedor	
	If AC9->(dbSeek(xFilial("AC9") + "SZ3" + xFilial("SZ3") + ZZ6->ZZ6_CODENT))
		
		aAdd( aPar,{ 1  ,"Fornecedor " 	 ,Space(8),"","","SZ3FOR","",50,.T.})
		
		If ParamBox( aPar, ZZ6->ZZ6_DESENT, @aRet, bValid, , , , , ,"CRPA031F" , .T., .F. )
			SZ3->(Reclock("SZ3",.F.))
				SZ3->Z3_CODFOR := Substr(aRet[1],1,6)
				SZ3->Z3_LOJA   := Substr(aRet[1],7,2)
			SZ3->(MsUnlock())
		Else
			MsgInfo("Sera mantido o fornecedor atual: " + SZ3->Z3_CODFOR)
		Endif
		
	Endif
	// Fim do novo processo do fornecedor

	//Se mesmo com as verificações, o código do fornecedor não estiver vinculado, encerra.
	If Empty(SZ3->Z3_CODFOR)
		::cErroPedido := ERRO_FORN01 + ZZ6->ZZ6_CODENT + " - " + AllTrim(ZZ6->ZZ6_DESENT)
		Return .F.
	Else

		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		If !SA2->(dbSeek(xFilial("SA2") + SZ3->Z3_CODFOR + SZ3->Z3_LOJA))
			::cErroPedido := ERRO_FORN02
			Return .F.
		EndIf

		If SA2->A2_MSBLQL == "1"
			::cErroPedido := ERRO_FORN03
			Return .F.
		EndIf
		
	EndIf

	If Empty(::cFornecedor)
		::cFornecedor := SZ3->Z3_CODFOR
		::cLojaFornecedor := SZ3->Z3_LOJA
	EndIf

Return .T.

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method buscaContrato() Class ConsolidadoRemuneracao

	Local _stru 	:= {}
	Local aCpoBro	:= {}
	Local aCores	:= {}
	Local cArq		:= ""
	Local nOpc		:= 0
	Local lContra	:= .F.

	Private nContMed 	:= 0
	Private cMark		:= GetMark()
	Private oMark		:= Nil
	Private lInverte	:= .F.
	Private oDlg

	If Select("TMPMED") > 0
		TMPMED->(dbCloseArea())
	EndIf

	//Busco os dados do contrato.
	Beginsql Alias "TMPMED"
		SELECT Z3_CODENT CODCCR,CNC_NUMERO CTR, MAX(CNC_REVISA) REVISAO, MAX(CN9_DESCRI) DESCRICAO FROM %Table:CNC%  CNC
		JOIN %Table:CN9% CN9 ON CN9_FILIAL = %xFilial:CN9% AND CN9_NUMERO = CNC_NUMERO AND CN9_SITUAC = '05' AND CN9.%NotDel% 
		LEFT JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = %xFilial:SZ3% AND Z3_CODFOR = CNC_CODIGO AND Z3_LOJA = CNC_LOJA AND Z3_TIPENT = '9' AND SZ3.%NotDel%
		WHERE
		CNC_FILIAL = %xFilial:CNC% AND
		CNC_CODIGO = %Exp:SZ3->Z3_CODFOR% AND
		CNC_LOJA = %Exp:SZ3->Z3_LOJA% AND
		CNC.%NotDel%
		GROUP BY CNC_NUMERO, Z3_CODENT
	Endsql
	
	//Cria um arquivo de Apoio para controle dos contratos
	AADD(_stru,{"OK"     	,"C"	,2		,0		})
	AADD(_stru,{"CODCCR"  	,"C"	,6		,0		})
	AADD(_stru,{"CONTRAT"   ,"C"	,15		,0		})
	AADD(_stru,{"REVISAO"  	,"C"	,3		,0		})
	AADD(_stru,{"DESCRICAO" ,"C"	,120	,0		})
	
	cArq:=Criatrab(_stru,.T.)
	
	If Select("TTRB") > 0
		TTRB->(DbCloseArea())
	EndIf
	
	DBUSEAREA(.t.,,carq,"TTRB")
	
	TMPMED->(DbGotop())
	
	While  !TMPMED->(Eof())   
		DbSelectArea("TTRB")
		RecLock("TTRB",.T.)
			TTRB->CODCCR   	:= TMPMED->CODCCR
			TTRB->REVISAO  	:= TMPMED->REVISAO
			TTRB->DESCRICAO	:= TMPMED->DESCRICAO
			TTRB->CONTRAT  	:= TMPMED->CTR
		MsunLock()
		TMPMED->(DbSkip())
	Enddo
	
	//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
	aCpoBro	:= {{ "OK"			,, "Mark"           ,"@!"},;			
				{ "CODCCR"		,, "CODCCR"      	,"@!"},;			
				{ "CONTRAT"		,, "CONTRAT"       ,"@!"},;			
				{ "REVISAO"		,, "REVISAO"        ,"@!"},;
				{ "DESCRICAO"	,, "DESCRICAO"      ,"@!"}}
	
	DbSelectArea("TTRB")
	DbGotop()
	
	If !TTRB->(EOF())

		//Cria uma Dialog
		DEFINE MSDIALOG oDlg TITLE "SELECIONE O CONTRATO" From 9,0 To 315,800 PIXEL
		
		aCores := {}
		aAdd(aCores,{"TTRB->REVISAO == ' '","BR_VERMELHO"})
		aAdd(aCores,{"TTRB->REVISAO != ' '","BR_VERDE"	 })
		
		//Cria a MsSelect
		oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{30,1,150,400},,,,,aCores)
		oMark:bMark := {| | Disp(oMark)} 

		//Exibe a Dialog	
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT	EnchoiceBar(oDlg,{|| oDlg:End(), nOpc := 1},{|| oDlg:End(), nOpc := 2}) 
	EndIf

	If nOpc == 1 
		
		While TTRB->(!EOF())
			
			If !Empty(TTRB->OK)
				lContra := .T.
				Exit
			EndIf
			
			TTRB->(DbSkip())
		EndDo

		If lContra
			::cContrato := TTRB->CONTRAT

			::oContrato := ContratoRemuneracao():New()
			If !::oContrato:find(::cContrato, TTRB->REVISAO)
				::cContrato := ""
				FreeObj(::oContrato)
				::oContrato := Nil
			EndIf

		EndIf
	Else
		::cContrato := ""
	EndIf

	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	TTRB->(DbCloseArea())
	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)

Return

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Static Function Disp(oMark)

	RecLock("TTRB",.F.)

	If Marked("OK")	
		TTRB->OK := cMark
		nContMed := 1
	Else	
		TTRB->OK := ""
		nContMed := 0
	Endif  
	           
	TTRB->(MSUNLOCK())
	oMark:oBrowse:Refresh()

Return()

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method buscaProduto() Class ConsolidadoRemuneracao

	Local cFornece 	:= ::cFornecedor
	Local cLojaFor 	:= ::cLojaFornecedor
	Local cProduto 	:= ""
	Local cTES		:= ""
	
	If Select("TMPPED") > 0
		TMPPED->(dbCloseArea())
	EndIf

	Beginsql Alias "TMPPED"
		SELECT D1_COD, D1_TES FROM %Table:SD1% SD1
		WHERE
		D1_FILIAL = %xFilial:SD1% AND
		D1_FORNECE = %Exp:cFornece% AND
		D1_LOJA = %Exp:cLojaFor% AND
		SUBSTR(D1_COD,1,2) = 'CS' AND
		D1_EMISSAO = (SELECT MAX(D1_EMISSAO) FROM %Table:SD1% WHERE D1_FILIAL = %xFilial:SD1% AND D1_FORNECE = %Exp:cFornece% AND SUBSTR(D1_COD,1,2) = 'CS' AND D1_LOJA = %Exp:cLojaFor% AND SD1.%NOTDEL%) AND
		SD1.%NOTDEL%
	Endsql

	If TMPPED->(!EoF())
		cProduto := TMPPED->D1_COD
		cTES	 := TMPPED->D1_TES

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1") + cProduto))

		dbSelectArea("SF4")
		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial("SF4") + cTES))
	Else
		dbSelectArea("SA5")
		SA5->(dbSetOrder(1))
		If SA5->(dbSeek(xFilial("SA5") + cFornece + cLojaFor))
			cProduto := SA5->A5_PRODUTO
		EndIf
	EndIf

	TMPPED->(dbCloseArea())

Return {cProduto, cTES}

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method valCondPgto() Class ConsolidadoRemuneracao

	dbSelectArea("SE4")
	SE4->(DbSetOrder(1))
	If SE4->(!dbSeek(xFilial("SE4") + ::cCondicaoPgto))
		::cErroPedido := ERRO_COND01
		Return .F.
	EndIf

Return .T.

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method gravaPC5() Class ConsolidadoRemuneracao

	Local lNovo := .T.

	dbSelectArea("PC5")
	PC5->(dbSetOrder(1)) //PC5_FILIAL + PC5_PERIOD + PC5_CODENT
	//lNovo := PC5->(!dbSeek(xFilial("PC5") + ::cPeriodo + ::cCodigoEntidade))

    RecLock("PC5", .T.)
        PC5->PC5_FILIAL := xFilial("PC5") 
        PC5->PC5_PERIOD := ::cPeriodo
        PC5->PC5_CODENT := ::cCodigoEntidade
        PC5->PC5_PEDIDO := ::cPedido
        PC5->PC5_TPPED  := Iif(Empty(::oContrato:cMedicao), "P", "M")
        PC5->PC5_NUMMED := ::oContrato:cMedicao
        PC5->PC5_DTPED  := dDataBase
        PC5->PC5_VALOR  := ::nValorTotal
        PC5->PC5_CONTRA := Iif(Empty(::oContrato:cMedicao), "", ::oContrato:cNumero)
        PC5->PC5_DTESTO := CTOD("//")
    PC5->(MsUnLock())

	ZZ6->(dbGoTo(::nRecno))
	RecLock("ZZ6",.F.)
		ZZ6->ZZ6_SALDO := ZZ6->ZZ6_SALDO - ::nValorTotal
	ZZ6->(MsUnlock())

Return

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method mailAdiantamento() class ConsolidadoRemuneracao

	Local dDiasVen := CTOD("//")

	//Procura adiantamento e grava dados no Pedido de Compras
	dbSelectArea("ZZ7")
	ZZ7->(DbSetOrder(1))
	If ZZ7->(DbSeek(xFilial("ZZ7") + ::cCodigoEntidade + ::cPeriodo + Space(TamSX3("ZZ7_PRETIT")[1])))
		If ZZ7->ZZ7_SALDO > 0
		
			dDiasVen := dDataBase + Val(RTrim(Posicione("SE4", 1, xFilial("SE4") + ::cCondicaoPgto, "E4_COND")))
			
			//Envia notificação de adiantamento
			//U_CRPA051(dDiasVen, dDiasVen, Space(TamSX3("ZZ7_PRETIT")[1]))

		EndIf
	EndIf

Return

/**
* Método responsável por gerar o Pedido de Compra para realização do repasse
* ao parceiro. O método é responsável por identificar se o Pedido deverá ser
* proveniente de uma Medição de Contrato ou diretamente pelo Pedido de Compra
* padrão do Sistema. 
*
* @method   geraPedido
* @param    null
* @return   null
* @version  1.0
* @date     11/08/2020
*
**/
Method validaProduto(cProduto) Class ConsolidadoRemuneracao

	//Verifica se não passou vazio
	If Empty(cProduto)
		Return .F.
	EndIf
	
	//Verifica se existe o Produto
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	If !SB1->(dbSeek(xFilial("SB1") + cProduto))
		Return .F.
	EndIf

	//Verifica se existe amarração Produto x Fornecedor
	dbSelectArea("SA5")
	SA5->(dbSetOrder(1)) //A5_FILIAL + A5_FORNECE + A5_LOJA + A5_PRODUTO

Return SA5->(dbSeek(xFilial("SA5") + ::cFornecedor + ::cLojaFornecedor + cProduto))

Static Function validaTes(cTES)

	If Empty(cTES)
		Return .F.
	EndIf

	dbSelectArea("SF4")
	SF4->(dbSetOrder(1)) //F4_FILIAL + F4_CODIGO
	If !SF4->(dbSeek(xFilial("SF4") + cTES))
		//TES não localizado
		Return .F.
	Else	
		If SF4->F4_MSBLQL == "1"
			//TES Bloqueado para uso
			Return .F.
		EndIf
	EndIf

Return .T.

Static Method gravaCapaDespesa(ExpA2) Class ConsolidadoRemuneracao

	Local nPed := 0
	
	Default ExpA2 := {}
	
	If Len(ExpA2) == 0
		RecLock("SC7",.F.)
			SC7->C7_COND := CND->CND_CONDPG
		SC7->(MsUnlock())
	Else
		For nPed := 1 To Len( ExpA2 )
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_APROV"}) == 0
				AAdd(ExpA2[nPed],{"C7_APROV",	Posicione('CTT',1, xFilial('CTT') + CNE->CNE_CC ,'CTT_GARVAR')	, Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_CCAPROV"}) == 0
				AAdd(ExpA2[nPed],{"C7_CCAPROV", CNE->CNE_CC, Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_CC"}) == 0
				AAdd(ExpA2[nPed],{"C7_CC", CNE->CNE_CC , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XRECORR"}) == 0
				AAdd(ExpA2[nPed],{"C7_XRECORR", "2" , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_APBUDGE"}) == 0
				AAdd(ExpA2[nPed],{"C7_APBUDGE", "1" , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_CTAORC"}) == 0
				AAdd(ExpA2[nPed],{"C7_CTAORC", CNE->CNE_CONTA , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_FORMPG"}) == 0
				AAdd(ExpA2[nPed],{"C7_FORMPG", "BOLETO BANCARIO" , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_DOCFIS"}) == 0
				AAdd(ExpA2[nPed],{"C7_DOCFIS", "" , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XCONTRA"}) == 0
				AAdd(ExpA2[nPed],{"C7_XCONTRA", CND->CND_CONTRA , Nil})
			EndIf
	
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_DESCRCP"}) == 0
				AAdd(ExpA2[nPed],{"C7_DESCRCP", "Remuneração de Parceiros" , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XJUST"}) == 0
				AAdd(ExpA2[nPed],{"C7_XJUST", "Remuneração de Parceiros"  , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XOBJ"}) == 0
				AAdd(ExpA2[nPed],{"C7_XOBJ", "Remuneração de Parceiros" , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XADICON"}) == 0
				AAdd(ExpA2[nPed],{"C7_XADICON", "Remuneração de Parceiros" , Nil})
			EndIf
					
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_COND"}) == 0
				AAdd(ExpA2[nPed],{"C7_COND", CND->CND_CONDPG , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XVENCTO"}) == 0
				AAdd(ExpA2[nPed],{"C7_XVENCTO", dDataBase , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_ITEMCTA"}) == 0
				AAdd(ExpA2[nPed],{"C7_ITEMCTA", "000000000" , Nil})
			EndIf
			
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_CLVL"}) == 0
				AAdd(ExpA2[nPed],{"C7_CLVL", "000000000" , Nil})
			EndIf
		Next nPed
	Endif
Return( ExpA2 )
