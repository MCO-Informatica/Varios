#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415MNU  � Autor � Junior Carvalho    � Data �  28/12/2017 ���
�������������������������������������������������������������������������͹��
��� Descricao� Incluir bot�o no Borwse do Orocamento                      ���
�������������������������������������������������������������������������͹��
��� Uso      � ORCAMENTOS MATA415                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function MA415MNU()
Local aRotTemp := aRotina
Local cUserLib := '000315|000390|000539|000014|000000'
Local nX := 0
if !( __cUserId $ cUserLib)
	
	aRotina := {}
	
	nPos := ascan(aRotTemp, {|x| UPPER(x[2]) = "A415PCPY"})
	Adel(aRotTemp,nPos)
	
	For nX := 1 TO Len(aRotTemp)
		If !Empty(aRotTemp[nX] )
			aadd(aRotina,aRotTemp[nX])
		endif
	Next Nx
	
Endif

aadd(aRotina,{"Enviar E-mail","U_AFAT008()" , 0 , 2,0,NIL})
RETURN()
