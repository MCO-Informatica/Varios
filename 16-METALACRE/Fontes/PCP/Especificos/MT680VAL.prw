#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT680VAL � Autor � Luiz Alberto       � Data �  Abr/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida Inclusao PCP Modelo 2      ��
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT680VAL()
Local aArea := GetArea()

/*If l681	// Se For Lan�amento da Producao Modelo 2 Ent�o Valida se Operadores Foram Digitados
	If Type("aColsEx") == "U" .And. Inclui                              aHdPerda
//		Alert("Aten��o Para Inclus�o de Produ��o � Obrigat�rio o Preenchimento dos Operadores, Digite a Quantidade Produzida !!!")
//		Return .f.
	Endif
Endif
  */
Return .t.
