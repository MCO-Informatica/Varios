#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA020ALT �Autor  � Cesar Padovani     � Data �  15/09/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do Cadastro de Fornecedores.                     ���
�������������������������������������������������������������������������͹��
���Uso       � Compras / Fiscal                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA020ALT()
Local aAreaAtu	:= GetArea()
lOk := .T.

//���������������������������������������������������������������������������Ŀ
//� Obriga a digitacao do CNPJ / CPF quando o Fornecedor nao for pessoa fisica ou juridica �
//�����������������������������������������������������������������������������
If Empty(M->A2_CGC) 
	If M->A2_TIPO =="J" .or. M->A2_TIPO =="F"
	lOk := .F.
	MsgStop("Para este Fornecedor o preenchimento do Campo CNPJ/CPF e Obrigatorio!!!")
	Endif
EndIf
//���������������������������������������������������������������������������Ŀ
//� Amarracao da classe de valor ao ALTERAR um fornecedor                     �
//�����������������������������������������������������������������������������     

DbSelectArea("CTH")
dbSetOrder(1)
If MsSeek(xfilial("CTH")+ "F" + M->A2_COD)     
   
else
  	    Reclock("CTH",.T.)
		CTH->CTH_FILIAL :=xfilial("CTH") 
		CTH->CTH_CLVL   := "F" + M->A2_COD
		CTH->CTH_CLASSE := "2"
		CTH->CTH_NORMAL := "1"
	    CTH->CTH_DESC01 := M->A2_NOME    
        CTH->CTH_BLOQ  := "2"  
        CTH->CTH_DTEXIS := CTOD("01/01/80")
        CTH->CTH_CLVLLP := "F" + M->A2_COD

ENDIF 
MSUnlock()
Return lOk
