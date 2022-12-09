#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | SF2520E | Autor | Rafael Beghini | Data | 08.07.2016 
//+-------------------------------------------------------------------+
//| Descr. | P.E - Estorno do Documento de Saída
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function SF2520E()
	Local aAreaSE1 	:= GetArea()
	
	SC5->( dbSetOrder(1) )
	IF SC5->( dbSeek(SD2->D2_FILIAL + SD2->D2_PEDIDO) )
		IF SC5->C5_XORIGPV == '6'
			//NF Devolução referente a Contratos para estornar quantidade faturada
			FwMsgRun(,{|| U_A680BXCan( SD2->D2_DOC, SD2->D2_SERIE, SD2->D2_CLIENTE+SD2->D2_LOJA, 3 ) },,'Aguarde, verificando se há faturamento de medição...')
		EndIF
	EndIF
	
	RestArea(aAreaSE1)
Return NIL

