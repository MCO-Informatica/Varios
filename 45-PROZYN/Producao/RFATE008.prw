#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFATE008    � Autor � Adriano Leonardo  � Data �  03/11/16 ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o respons�vel por atualizar os percentuais de comiss�o���
���          � em todos os itens do pedido de venda, acionada atrav�s     ���
���          � de gatilhos em campos que possam impactar nas comiss�es    ���
���          � como: cliente, loja, condi��o de pagamento e vendedores.   ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn             			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RFATE008()

Local _aSavArea := GetArea()
Local _aSavSZD	:= SZD->(GetArea())
Private _cCodBar:= ""
Private _cRotina:= "RFATE008"
Private _lGrava	:= .T.

MsgRun("Gerando c�digo de barras...",_cRotina,{ |lEnd| SeqEAN13(@lEnd) })

RestArea(_aSavSZD)
RestArea(_aSavArea)

Return(_cCodBar)

Static Function SeqEAN13()

_cUpd := "UPDATE " + RetSqlName("SZD") + " SET ZD_ATUAL= "
_cUpd += "	( "
_cUpd += "		(SELECT ISNULL(MAX((B1_CODBAR)),SZD.ZD_INICIAL) FROM " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) WHERE SB1.D_E_L_E_T_='' AND SB1.B1_FILIAL='" + xFilial("SB1") + "' AND B1_CODBAR BETWEEN SZD.ZD_INICIAL AND SZD.ZD_FINAL AND SB1.B1_TIPO IN ('PA','PI') AND ISNUMERIC(SB1.B1_CODBAR)=1) "
_cUpd += "	) "
_cUpd += "FROM " + RetSqlName("SZD") + " SZD "
_cUpd += "WHERE SZD.D_E_L_E_T_='' "
_cUpd += "AND SZD.ZD_FILIAL='" + xFilial("SZD") + "' "

/*If TCSQLExec(_cUpd) < 0
	MsgStop("[TCSQLError] " + TCSQLError(),_cRotina+"_001")
EndIf
*/
dbSelectArea("SZD")
dbSetOrder(1)
If dbSeek(xFilial("SZD"))
	While SZD->(!EOF()) .And. SZD->ZD_FILIAL==xFilial("SZD")
		
		If SZD->ZD_ATUAL<SZD->ZD_FINAL
		
			_cCodBar := Soma1(SZD->ZD_ATUAL)
			
			dbSelectArea("SB1")
			dbSetOrder(5) //Filial + C�digo de barras
			
			While SB1->((msSeek(xFilial("SB1")+_cCodBar)))
				_cCodBar := Soma1(_cCodBar)
				
				If Soma1(_cCodBar)>SZD->ZD_FINAL
					_lGrava := .F.					
					Exit					
				EndIf
			EndDo
			
			If _lGrava
			
				dbSelectArea("SZD")
				
				RecLock("SZD",.F.)
					SZD->ZD_ATUAL := Soma1(SZD->ZD_ATUAL)
				SZD->(MsUnlock())
				
				Exit
			EndIf
		EndIf
		
		dbSelectArea("SZD")
		dbSetOrder(1)
		dbSkip()
	EndDo
EndIf

If Len(_cCodBar)==12
	_cCodBar := AllTrim(_cCodBar) + EanDigito(_cCodBar)
	_cCodBar := SUBSTR(_cCodBar,1,13)
EndIf

Return()
