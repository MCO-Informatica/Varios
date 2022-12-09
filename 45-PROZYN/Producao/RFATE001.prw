#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RFATE001   � Autor � Adriano Leonardo    � Data � 16/06/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina responsav�l por avaliar a base do CNPJ na inclus�o  ���
���Desc.     � de um cliente e ajustar a codifica��o (c�digo + loja) se-  ���
���Desc.     � guindo o conceito de loja.                                 ���
���Desc.     � Agrupando as filias no mesmo c�digo.                       ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RFATE001()

Private _cRotina	:= "RFATE001"
Private _aSavArea	:= GetArea()
Private _cQuery		:= ""
Private _cAlias		:= GetNextAlias()
Private _cEnt		:= CHR(13) + CHR(10)

If Inclui .And. M->A1_TIPO<>"F" .And. !Empty(M->A1_CGC) .And. M->A1_EST<>"EX"
	
	_cQuery := "SELECT MAX(A1_COD) [A1_COD], MAX(A1_LOJA) [A1_LOJA] FROM " + RetSqlName("SA1") + " SA1 " + _cEnt
	_cQuery += "WHERE SA1.D_E_L_E_T_='' " + _cEnt
	_cQuery += "AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnt
	_cQuery += "AND SA1.A1_CGC<>'" + M->A1_CGC + "' " + _cEnt
	_cQuery += "AND SA1.A1_CGC LIKE '" + SubStr(M->A1_CGC,1,8) + "%' " + _cEnt
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)
	
	dbSelectArea(_cAlias)
	
  	If (_cAlias)->(!EOF())
	  	If(_cAlias)->A1_COD <> Nil .And. !Empty((_cAlias)->A1_COD)
			M->A1_COD 	:= (_cAlias)->A1_COD
			M->A1_LOJA	:= Soma1((_cAlias)->A1_LOJA)
			
			_lVerifica	:= .T.
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			While _lVerifica
				If dbSeek(xFilial("SA1")+M->A1_COD+M->A1_LOJA)
					M->A1_LOJA	:= Soma1(M->A1_LOJA)
				Else
					_lVerifica	:= .F.
				EndIf
			EndDo
		EndIf
	EndIf
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())
	
EndIf

RestArea(_aSavArea)

Return({M->A1_COD,M->A1_LOJA})