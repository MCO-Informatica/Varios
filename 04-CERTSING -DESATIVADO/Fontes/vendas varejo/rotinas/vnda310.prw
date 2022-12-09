#INCLUDE "Protheus.ch"

//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | Jira    |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+
//| 14/06/2011 | Darcio Sporl  | Movimentacao de Voucher.                                                         | 1.00   |         |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+
//| 03/11/2011 | Alceu P.      | Alteracao na rotina de movimentacao de voucher, para realizar a atualizacao dos  | 1.01   |         |
//|            |               | campos na tabela SZG- Tabela de Movimentacao de voucher. Acrescentado o parametro|	       |         |
//|            |               | aRVou na assinatura da funcao e nesta posicao indica se ocorrera a inclusao de   |	       |         |
//|            |               | pedido ou nao. #1                                                                |	       |         |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+
//| 21/07/2020 | Bruno Nunes   | Revisão do processo de  fluxo de voucher / negativo.                             | 1.02   | PROT-89 |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------+

#define cTIPO_VOUCHER "V" //Tipo de processo do voucher 

/*/{Protheus.doc} VNDA310
Movimentacao de Voucher
@author Darcio R. Sporl
@since 14/06/11
@version P12
/*/
User Function VNDA310( oVoucher )
	Local aArea := GetArea()

	DbSelectArea("SZF")
	DbSetOrder(2)
	If DbSeek(xFilial("SZF") + oVoucher:voucherCodigo)
		DbSelectArea("SZG")
		SZG->( dbSetOrder(3) )
		If SZG->( dbSeek( xFilial("SZG") + oVoucher:pedidoSite ) )
			SZG->( RecLock("SZG", .F.) )	//Crio um novo registro com a movimentacao do voucher
		Else	
			SZG->( RecLock("SZG", .T.) )	//Crio um novo registro com a movimentacao do voucher
		Endif
		SZG->ZG_FILIAL  := xFilial("SZG")
		SZG->ZG_NUMPED  := oVoucher:pedidoGAR
		SZG->ZG_NUMVOUC := oVoucher:voucherCodigo
		SZG->ZG_QTDSAI  := oVoucher:voucherQuantidade 
		SZG->ZG_CODFLU  := SZF->ZF_CODFLU  //#1 Foram incluidos mais campos para serem atualizados na movimentacao de voucher
		IF !Empty( oVoucher:pedidoProtheus )
			SZG->ZG_PEDIDO  := oVoucher:pedidoProtheus //SC5_NUM
			SZG->ZG_ITEMPED := oVoucher:itemPVProtheus //SC6_ITEM
		EndIF
		SZG->ZG_DATAMOV := dDataBase
		SZG->ZG_ROTINA  := ProcName()
		SZG->ZG_GRPROJ  := SZF->ZF_GRPPROJ
		SZG->ZG_PEDSITE := oVoucher:pedidoSite
		SZG->(MsUnLock())
		
		SZF->(RecLock("SZF", .F.))	//Gravo o numero do pedido e controlo o saldo do voucher
		SZF->ZF_SALDO := SZF->ZF_SALDO - oVoucher:voucherQuantidade

		//Nao deixa gerar saldo negativo
		if SZF->ZF_SALDO < 0
			SZF->ZF_SALDO := 0
			U_GTPutOUT( oVoucher:id, cTIPO_VOUCHER, oVoucher:pedidoLog, { "U_VNDA310", { .F., "W00002", oVoucher:pedidoLog, "Rotina atual: "+ProcName(), "Rotina anterior: "+ProcName(1), "Voucher gerou saldo negativo"}},oVoucher:pedidoSite )
		endif  
		SZF->(MsUnLock())		
	EndIf

	RestArea (aArea)
Return nil