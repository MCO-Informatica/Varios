#INCLUDE 'PROTHEUS.CH'
              
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M116ACOL � Autor � Junior Carvalho    � Data �  15/06/2018 ���
�������������������������������������������������������������������������͹��
���Descricao � Altera o Local do 98 para 01 em nota de entrada de Frete   ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M116ACOL()
Local cAliasSD1 := PARAMIXB[1]   //-- Alias arq. NF Entrada itens
Local nX       := PARAMIXB[2]    //-- N�mero da linha do aCols correspondente
Local aDoc  := PARAMIXB[3]    //-- Vetor contendo o documento, s�rie, fornecedor, loja e itens do documento
Local nPosLocal := GDFieldPos("D1_LOCAL")

aDoc[5][nPosLocal] := '01'

Return Nil