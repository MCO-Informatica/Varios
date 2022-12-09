#Include "PROTHEUS.CH"    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    FA040B01          �Autor  �DenisVarella� Data �  05/03/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para excluir SE3 em t�tulos AB-	          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION FA040B01()

If SE1->E1_TIPO == 'AB-'

	If Select("tVEND") > 0
   		tVEND->(DBCloseArea())
   	EndIf
		
	BeginSql alias "tVEND"
		Select R_E_C_N_O_ FROM %Table:SE3%
		WHERE E3_NUM = %Exp:SE1->E1_NUM% and
		E3_FILIAL = %Exp:SE1->E1_FILIAL% and 
		E3_PREFIXO = %Exp:SE1->E1_PREFIXO% and
		E3_CODCLI = %Exp:SE1->E1_CLIENTE% and 
		E3_VENCTO = %Exp:SE1->E1_VENCTO% and 
		E3_LOJA = %Exp:SE1->E1_LOJA% and 
		E3_TIPO = 'AB-' and 
		%notDel%
	EndSql             
	
	While tVEND->(!Eof()) 
		DbSelectArea("SE3")
		SE3->(DbGoTo(tVEND->R_E_C_N_O_))
			RecLock("SE3",.F.)
				dbDelete()
			MsUnlock()
	tVend->(dbskip())
	EndDo   
EndIf

RETURN .T.