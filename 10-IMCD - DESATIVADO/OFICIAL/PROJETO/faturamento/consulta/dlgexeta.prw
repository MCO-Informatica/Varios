#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DLGEXETA � Autor � Edson Estevam - Delta Decisao�� 06/04/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tratamento para mudar endere;o destino                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico - PE executado apos grabacao do SDB de Servico    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

USER FUNCTION DLGEXETA

	Local _aAreaAtu := GetArea()
	//Local _aParams	:= PARAMIXB
	Local _cChaveDB		:=  SDB->(DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "DLGEXETA" , __cUserID )

	DbSelectArea("SDB")
	DbSetOrder(1)
	DbSeek(xFilial("SDB")+_cChaveDB,.f.)
	While ! Eof() .AND. xFilial("SDB")+_cChaveDB == SDB->(DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM)
		If SDB->DB_ATIVID == '016'
			Reclock("SDB",.F.)
			SDB->DB_ENDDES = SDB->DB_LOCALIZ
			SDB->DB_ESTDES = SDB->DB_ESTFIS
			msUnlock()
		Endif
		DbSkip()
	Enddo
	RestArea(_aAreaAtu)
Return