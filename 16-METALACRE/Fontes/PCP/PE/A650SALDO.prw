#Include "TOPCONN.CH"
#Include "Protheus.Ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A650SALDO � Autor � Luiz Alberto       � Data � 24/06/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � PE na Conversao de Prospects para Clientes   ���
�������������������������������������������������������������������������͹��
���          � 													          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function A650SALDO()
Local nSaldoAnt := PARAMIXB
Local nRetSaldo := 0

If AllTrim(SB1->B1_TIPO) <> 'PA' 
	nRetSaldo := nSaldoAnt
Endif

Return nRetSaldo          

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT250SAL � Autor � Luiz Alberto       � Data � 24/06/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Desconsiderar Saldo Poder Terceiros e Empenho na Inclus�o de 
				Produ��o, Material BN ���
�������������������������������������������������������������������������͹��
���          � 													          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT250SAL()            
Local aSaldos := ParamIxb[1]//   Informa��es do usu�rio.
Local aAreaSB1:= SB1->(GetArea())
Local aAreaSD3:= SD3->(GetArea())
Local lTipoBN := .F.
Local lOpBN   := .F.

If Type("M->D3_COD") <> "U"
	If SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+M->D3_COD)) .And. AllTrim(SB1->B1_TIPO) == 'BN'
		lTipoBN := .T.
	Endif
	
	If Left(M->D3_OP,1)=='X'	// Ordem de Fabrica��o BN
		lOpBN := .t.
	Endif
	
	SB1->(RestArea(aAreaSB1))
	SD3->(RestArea(aAreaSD3))
	
	If lTipoBN .And. lOpBN .And. SB2->(dbSetOrder(1), dbSeek(xFilial("SB2")+aSaldos[1,1]+aSaldos[1,2]))
		nSaldo := SaldoSB2(.F.,.F.)
		aSaldos[1,3] := nSaldo
	Endif
Endif
SB1->(RestArea(aAreaSB1))
SD3->(RestArea(aAreaSD3))
Return(aSaldos)
