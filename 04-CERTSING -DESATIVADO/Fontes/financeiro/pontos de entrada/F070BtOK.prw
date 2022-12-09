#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | F070BtOK | Autor | Rafael Beghini | Data | 08.07.2016 
//+-------------------------------------------------------------------+
//| Descr. | P.E - Confirmação da baixa a receber
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function F070BtOK()
	Local aAreaSE1 	:= GetArea()
	Local cMotBaixa := 'CANCTO|CAN FAT ER|CAN DESIST|CAN DUPLIC'
	
	SC5->( dbSetOrder(1) )
	IF SC5->( dbSeek(cFilAnt + SE1->E1_PEDIDO) )
		IF SC5->C5_XORIGPV == '6' .And. cMOTBX $ cMotBaixa
			//NF Devolução referente a Contratos para estornar quantidade faturada
			FwMsgRun(,{|| U_A680BXCan( SE1->E1_NUM, SE1->E1_SERIE, SE1->E1_CLIENTE+SE1->E1_LOJA, 3 ) },,'Aguarde, verificando se há faturamento de medição...')
		EndIF
	EndIF
	
	RestArea(aAreaSE1)
Return(.T.)