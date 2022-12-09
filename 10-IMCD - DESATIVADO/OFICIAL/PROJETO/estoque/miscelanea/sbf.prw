#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATUSBF    �Autor  �  Daniel   Gondran  � Data �  17/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza descricao do produto na tabela SBF para registros ���
���          � n�o preenchidos                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Estoque                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function SBF() 

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "SBF" , __cUserID )

	Private nCont:= 0

	dbSelectArea("SBF")
	DbGoTop()

	While SBF->(!Eof())
		RecLock("SBF",.F.)

		IF EMPTY(SBF->BF_DESCRI)

			REPLACE SBF->BF_DESCRI WITH Posicione("SB1",1,xFilial("SB1") + SBF->BF_PRODUTO,"B1_DESC") 
			nCont ++

		ENDIF

		SBF->(MsUnlock())
		SBF->(DbSkip())

	END                

	Alert("Quantidade de registro afetados: " + alltrim(STR(nCont)))


Return
