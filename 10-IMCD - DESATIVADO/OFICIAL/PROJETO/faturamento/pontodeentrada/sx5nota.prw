#include 'protheus.ch'
#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SX5NOTA  � Autor � Giane - ADV Brasil � Data �  25/02/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada antes de faturar o pedido, antes da tela  ���
���          � com os numeros e series das notas                          ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / faturamento                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SX5NOTA()

	Local _cFilial  := Paramixb[1]  //Filial
	Local _cTabela  := Paramixb[2]  //Tabela da SX5
	Local _cChave   := Paramixb[3]  //Chave da Tabela na SX5
	Local _cDescri  := Paramixb[4]  //Conte�do da Chave indicada
	Local _lRet     := .F.
	Local cSerie 	:= SuperGetMv("ES_SX5NOTA",,'1')

	If Alltrim(_cChave) $ cSerie 

		cObs := Posicione("SC5",1,xFilial("SC5")+SC9->C9_PEDIDO,"C5_OBSFAT")
		cObs := alltrim(cObs)
		if !empty(cObs)
			MsgInfo(cObs,"Observa��o Pedido n. " + SC9->C9_PEDIDO)
		endif
		_lRet := .T.
		
	Endif

Return _lRet
