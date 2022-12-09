#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���/����������������������������������������������������������������������ͻ��
���Programa  �OS010GRV  �Autor  �Darcio R. Sporl     � Data �  20/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada criado para passar ao HUB as alteracoes dos���
���          �produtos nas tabelas de preco.                              ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function OS010GRV()
	Local nTipo		:= ParamIXB[1]
	Local nOpc		:= ParamIXB[2]
	Local aArea		:= GetArea()
	Local cXml		:= ""
	Local cCodAnt	:= ""
	Local cCodTbA	:= ""
	Local nQtdDe	:= 0
	Local nQtdAt	:= 0
	Local cQryDA	:= ""
	Local cQryZ3	:= ""
	Local lRet		:= .T.
	Local cTabPrc	:= GetMV("MV_XTABPRC",,"001,002,003,004,005,006,007,008,009,010,011,012,013,014,015,016,017,018,019,020,021,022,023,024,025,026,027,028,029,030")

	IF .NOT. GetMv( 'MV_LJECOMM' )
		HS_MsgInf("Para este processo habilitar o par�metro MV_LJECOMM" + CRLF + CRLF + "N�o ser� enviado para o CheckOut",;
					"Aten��o","[OS010GRV] Atualiza-Tabela-Preco")
		Return
	EndIF

	//If (DA0->(fieldpos('DA0_XSITE')) > 0 .AND. DA0->DA0_XSITE = '1' ) .OR. (DA0->(fieldpos('DA0_XSITE')) = 0 .AND. DA0->DA0_CODTAB $ cTabPrc )
	IF DA0->DA0_XSITE == '1' .AND. DA0->DA0_ECFLAG == '1'
		
		//10/07/2019 - Envia combos de produtos para garantir que tabela subira correta
		U_VNDA750( ,'OS010GRV')
		
		If !U_VNDA020(DA0->DA0_CODTAB)
			lRet := .F.
			Help( ,, 'OS010GRV',,'N�o Foi poss�vel Alterar os dados do Produto no E-commerce. Altera��o n�o foi realizada. Entre em contato com Administrador', 1, 0 ) 
		Else
			//Atualiza cadastro no Cadastros de entidades Grupos e ACs que utilizam a tabela
			cQryZ3	:= " SELECT R_E_C_N_O_ RECZ3 FROM "+RetSqlName("SZ3")+" WHERE Z3_FILIAL = '"+xFilial("SZ3")+"' AND Z3_TIPENT IN ('2','5')  AND Z3_CODTAB LIKE '%"+Alltrim(DA0->DA0_CODTAB)+"%' AND D_E_L_E_T_ = ' '  "
			
			cQryZ3 := ChangeQuery(cQryZ3)
		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryZ3),"QRYZ3",.F.,.T.)
			DbSelectArea("QRYZ3")
			
			QRYZ3->(DbGoTop())
			If QRYZ3->(!Eof())
				
				While QRYZ3->(!Eof())
					SZ3->(DbGoTo(QRYZ3->RECZ3))
					RecLock("SZ3",.F.)
						SZ3->Z3_ENVSITE := ' '
					SZ3->(MsUnlock())
					QRYZ3->(DbSkip())
				EndDo 

				//executa funcao existente no fonte COMA010 para atualiza��o da tabela de associacao
				//MsAguarde({|| lRet:= u_InfSite(Alltrim(DA0->DA0_CODTAB))	},"Comunicando com o HUB")
				
				If !lRet
					Help( ,, 'OS010GRV2',,'N�o Foi poss�vel Alterar a tabela de Associ��o de Produto x Grupo no E-commerce. Entre em contato com Administrador', 1, 0 ) 
				EndIf
				
			EndIf
			QRYZ3->(DbCloseArea())
			
			//10/07/2019 - Volta status da tabela para n�o enviar para site evitando envio manuais incorretos
			RecLock("DA0",.F.)
				DA0->DA0_XSITE := '0' 
			DA0->(MsUnlock())
		EndIf
	EndIf

	RestArea(aArea)
Return(lRet)