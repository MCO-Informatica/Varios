#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HCIA016   �Autor  �Aline Catarina      � Data �  24/01/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro do Grupo de Variaveis                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/    

User Function HCIA016()
	AxCadastro("PA7","Cadastro Variaveis de Calculo","U_BTEXA016()",".T.")
Return        
  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BTEXA016  �Autor  �Aline Catarina      � Data �  24/01/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que valida a exclusao do registro                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BTEXA016()
Local lRetEx  := .T.                    
Local cEnterL := "" 
//Local cEnterL := Chr(13)                       
    // Monta a Query p/ verificar se a variavel esta relacionada a algum produto
	cQuery := "SELECT *	"
	cQuery += " FROM "+RetSQLName("SB1")+" SB1 "+cEnterL
	cQuery += " WHERE SB1.B1_FILIAL = '"+xFilial("PA7")+"' "+cEnterL
	cQuery += " AND   SB1.B1_GRPVAR = '"+PA7->PA7_CODIGO+"' "
	cQuery += " AND   SB1.D_E_L_E_T_ <> '*'                                  	"
	cQuery := ChangeQuery(cQuery)
	// Cria tabela temporaria para verificacao
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSB1",.T.,.T.)
	dbGotop()
	IF !TMPSB1->(Eof())
		MsgAlert("Ha registros relacionados a este codigo")
        lRetEx := .F.
    EndIf                              
    dbCloseArea()
Return(lRetEx)            

