#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"   

//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | Jira    |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+
//| 01/11/2011 | Darcio Sporl  | Valida Voucher.                                                                  | 1.00   |         |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+
//| 01/11/2011 | Alceu P.      | Incluido a verificacao de geracao de Nota ,TES e Pedido.                         | 1.01   |         |
//|            |               | Incluida a variavel aArea                                                        |        |         |
//|            |               | Alterado o retorno da funcao para retornar lGeraPed                              |        |         |
//|            |               | .T. indicando que o tipo de voucher ou                                           |        |         |
//|            |               | .F. caso contrario,lGeraNota .T. indicando que                                   |        |         |
//|            |               | o tipo de voucher gera NF ou .F. caso contrario,                                 |        |         |
//|            |               | cTESProd referente ao codigo TES de produto e                                    |        |         |
//|            |               | cTESServ referente ao codigo da TES de servico.                                  |        |         |
//|            |               | Acrescentado ao retorno a TES de Entrega.                                        |        |         |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+
//| 21/07/2020 | Bruno Nunes   | Revisão do processo de  fluxo de voucher / negativo.                             | 1.02   | PROT-89 |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+

#define cTIPO_VOUCHER "V" //Tipo de processo do voucher 

/*/{Protheus.doc} VNDA430
Valida voucher      
@type function
@author Alceu P. / Darcio R. Sporl
@since 01/11/2011
@version P12  17.3.0.8
@build 7.00.170117A-20190627
@return array
/*/
User Function VNDA430( oVoucher )
	local aArea      := GetArea()
	local cMensagem	 := ""
	local cCopProd   := ""
	local cCopEntr   := ""
	local cCopServ   := ""
	local cPedidov	 := "" // Código do Pedido de Vendas
	local cFluxo	 := ""
	local cTpVoucher := ""
	local lRet		 := .T.
	local lGeraPed   := .F.
	local lGeraNotaS := .F.
	local lGeraNotaP := .F.
	local cCodErro   := "M00001"

	//GTPutIN( cGtId      ,cType         , cCodPed           ,lSend, aParam                                                                                     ,cXNpSite, aDetPag, aXmlCC, aChkOut, cNpEcomm )
	U_GTPutIN( oVoucher:id, cTIPO_VOUCHER, oVoucher:pedidoLog, .T. , {"U_VNDA430", ProcName(1),oVoucher:pedidoLog,{ oVoucher:voucherCodigo , oVoucher:voucherQuantidade } }, oVoucher:pedidoSite )

	dbSelectArea("SZF")
	SZF->( dbSetOrder(2) )	// ZF_FILIAL + ZF_COD
	if SZF->( dbSeek( xFilial( "SZF" ) + oVoucher:voucherCodigo ) )	// Verifico se o numero do voucher existe
		if dtos( Date() ) > dtos( SZF->ZF_DTVALID ) // Verifico se o voucher esta dentro da validade
			lRet 		:= .F.
			cMensagem	:= "O voucher informado está fora da validade."
			cCodErro  := "E00027"
		else
			dbSelectArea("SZF")
			SZF->( dbSetOrder(2) )
			if SZF->( dbSeek( xFilial("SZF") + oVoucher:voucherCodigo ) )
				if SZF->ZF_ATIVO == "S"
					if alltrim( SZF->ZF_PRODEST ) == oVoucher:produtoCodigo
						if SZF->ZF_SALDO >= oVoucher:produtoQuantidade
							lRet 		:= .T.
							cMensagem	:= "Voucher Válido."
							cCodErro  := "M00001"
						else
							SZG->( dbSetOrder(3) )
							if SZG->( dbSeek( xFilial("SZG") + oVoucher:pedidoSite ) )
								lRet	  := .F.
								cMensagem := "O voucher informado não tem saldo para ser utilizado."
								lGeraPed  := .F.  //#1
								lGeraNota := .F.
								cCopProd  := ""
								cCopEntr  := ""
								cCopServ  := ""
								cCodErro  := "E00028"
							else
								lRet	  := .T.
								cMensagem := "Consumiu voucher sem criar movimentação. Continua processo."
								cCodErro  := "W00001"							
							endif
						endif
					else
						lRet		:= .F.
						cMensagem	:= "O produto não corresponde ao produto cadastrado no voucher."
						cCodErro  := "E00029"
					endif
				else
					lRet		:= .F.
					cMensagem	:= "O voucher informado não está ativo."
					cCodErro  := "E00030"
				endif
			else
				lRet		:= .F.
				cMensagem	:= "O voucher informado não foi encontrado."
				cCodErro  := "E00031"
			endif    
		endif

		if lRet
			cPedidov 	:= SZF->ZF_PEDIDOV  
			cFluxo	 	:= SZF->ZF_CODFLU 
			cTpVoucher	:= SZF->ZF_TIPOVOU
			DbSelectArea("SZH") //Tipos de Voucher                         		
			SZH->( dbSetOrder(1) )
			if SZH->( dbSeek( xFilial("SZF") + cTpVoucher ) ) 
				if SZH->ZH_EMNTVEN = "N"
					lGeraNotaS	:= .F.
					lGeraNotaP	:= .F.
				elseif SZH->ZH_EMNTVEN = "S"
					lGeraNotaS	:= .T.
					lGeraNotaP	:= .F.
				elseif SZH->ZH_EMNTVEN = "P"
					lGeraNotaS	:= .F.
					lGeraNotaP	:= .T.
				elseif SZH->ZH_EMNTVEN = "A" 
					lGeraNotaS	:= .T.
					lGeraNotaP	:= .T.				
				endif 

				iif( lGeraNotaS .OR. lGeraNotaP, lGeraPed := .T., lGeraPed := .F. )

				cCopProd := SZH->ZH_TPOPP
				cCopEntr := SZH->ZH_TPOPENT
				cCopServ := SZH->ZH_TPOPSER
			endif
		endif
	else
		lRet	  := .F.
		cMensagem := "O voucher informado não existe."
		cCodErro  := "E00032"
	endif

	U_GTPutOUT( oVoucher:id, cTIPO_VOUCHER, oVoucher:pedidoLog, { "U_VNDA430", { lRet, cCodErro, oVoucher:pedidoLog, ProcName(1), cMensagem}},oVoucher:pedidoSite )
	
	oVoucher:voucherValido           := lRet
	oVoucher:mensagem                := cMensagem
	oVoucher:geraPedidoProtheus      := lGeraPed
	oVoucher:geraNFServico           := lGeraNotaS
	oVoucher:geraNFProduto           := lGeraNotaP
	oVoucher:operacaoVendaServico    := cCopServ
	oVoucher:operacaoVendaHardware   := cCopProd  //Operação de venda Hardware 
	oVoucher:operacaoEntregaHardware := cCopEntr //Operação de entrega Hardware 	

	RestArea( aArea ) 
Return( { lRet, cMensagem, lGeraPed, lGeraNotaS, lGeraNotaP, cCopServ, cCopProd, cCopEntr, cPedidov, cFluxo, cTpVoucher } )
