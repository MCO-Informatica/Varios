#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MULTD3    �Autor  �QS DO BRASIL        � Data �  16/05/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �VALIDACAO D3                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MultD3()
local _nProd	:= IIF(INCLUI,M->D3_COD,D3_COD)
local _nQtd     := IIF(INCLUI,M->D3_QUANT,D3_QUANT)
local _lRet    	:= .T.
Local _aArea    := GetArea()
Local  _cUser   := Retcodusr()

	If Type("L410AUTO") == "U" .OR. !L410Auto
	  	dbSelectArea("SB1")
		dbSetOrder(1)
   	     if dbSeek(xFilial("SB1")+ALLTRIM(_nProd))
			  	if M->D3_QUANT % B1_QB <> 0.AND. ALLTRIM(B1_TIPO)<>'MP'
				    	_nQtd 	:= 0
						msgstop("A quantidade deve ser multiplo de "+str(b1_qb))
						_lRet := .F.
					endif
			   	endif
	      endif
	
Restarea(_aArea)
Return _lRet