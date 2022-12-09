#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103TPC � Autor �  Daniel   Gondran  � Data �  12/07/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para avaliar se a TES de entrada necessita���
���          � ou n�o de PC para digitar a NF entrada                     ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT103TPC
Local _aArea	:= GetArea()
Local cTes 		:= Paramixb[1]

if !(isincallstack("EICDI158"))
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4"))
	do While !Eof() .and. SF4->F4_FILIAL == xFilial("SF4") .and. SF4->F4_CODIGO < "500"
		If SF4->F4_PEDCOM == "N" .and. !SF4->F4_CODIGO$cTes
			cTes += "/" + AllTrim(SF4->F4_CODIGO)
		Endif
		SF4->(dbSkip())
	Enddo
	
	RestArea(_aArea)
Endif

Return (cTes)
