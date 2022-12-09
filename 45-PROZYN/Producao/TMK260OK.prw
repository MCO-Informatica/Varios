#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMK260OK  �Autor  �Derik Santos        � Data �  19/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esse ponto de entrada � utilizado no cadastro de prospect   ���
���Desc.     �(faturamento), ao clicar no bot�o OK. � chamado tanto na    ���
���Desc.     �inclus�o como na altera��o do cadastro de prospects.        ���
���Desc.     �Usado para verificar se o prospect possui contato amarrado  ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 12 - Prozyn                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TMK260OK()

DbSelectArea("AC8")
DbSetOrder(3)
If !DbSeek(xFilial() + "SUS" + M->US_COD)                         
	Alert("N�o Existe contato para essa oportunidade, favor incluir")
	_cProspect  := RTRIM(M->US_COD)
//	_cLoja      := "01"
	_cEnt		:= _cProspect// + _cLoja
	CRMA470()
	_cContato   := SU5->U5_CODCONT
		
		dbSelectArea("AC8")
		Reclock("AC8",.T.)
		AC8->AC8_ENTIDA := "SUS"
		AC8->AC8_CODENT := _cEnt
		AC8->AC8_CODCON := _cContato
		
		msUnLock()	
EndIf
	
//U_RCRME004()   

U_RCRME015()
			
Return (.T.)
