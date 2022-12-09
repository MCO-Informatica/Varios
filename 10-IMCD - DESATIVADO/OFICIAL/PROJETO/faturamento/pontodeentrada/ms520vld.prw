#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MS520VLD � Autor � Fabricio E. da Costa  � Data � 17/03/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada executado antes do estorna da NF de saida ���
���          � Valida se o documento pode ser estornado ou n�o            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Remessa por conta e ordem                                  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � GAP  �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Fabricio    �17/03/11� 167  � Implementa��o                            ���
���            �        �      �                                          ���
���            �        �      �                                          ���
���            �        �      �                                          ���
���            �        �      �                                          ���
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MS520VLD()
	Local cSql    := ""
	Local cAlias  := ""
	Local cTitulo := "Remessa conta e ordem (MS520VLD)"
	Local lRet    := .F.	

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MS520VLD" , __cUserID )

	cAlias := GetNextAlias()
	// Verifica se � uma nota de remessa por conta e ordem
	cSql := "SELECT F2_DOC, F2_SERIE "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SD2") + " SD2 JOIN " + RetSqlName("SF4") + " SF4 ON "
	cSql += "    SD2.D2_FILIAL  = '" + xFilial("SD2") + "'  AND "
	cSql += "    SF4.F4_FILIAL  = '" + xFilial("SF4") + "'  AND "
	cSql += "    SD2.D_E_L_E_T_ = ' ' AND "
	cSql += "    SF4.D_E_L_E_T_ = ' ' AND "
	cSql += "    SD2.D2_TES     = SF4.F4_TESCO "
	cSql += "  JOIN " + RetSqlName("SF2") + " SF2 ON "
	cSql += "    SF2.F2_FILIAL  = '" + xFilial("SF2") + "'  AND "
	cSql += "    SF2.F2_NFCO    = SD2.D2_DOC   AND "
	cSql += "    SF2.F2_SERIECO = SD2.D2_SERIE  "
	cSql += "WHERE "
	cSql += "  SD2.D2_DOC  = '" + SF2->F2_DOC   + "' "
	cSql += "  AND SD2.D2_SERIE = '" + SF2->F2_SERIE + "'"
	TcQuery cSql New Alias (cAlias)

	lRet := (cAlias)->(Eof()) .And. (cAlias)->(Bof())
	If !lRet
		MsgAlert("NF " + SF2->F2_DOC + "-" + AllTrim(SF2->F2_SERIE) + " � uma remessa por conta e ordem. Estorne o documento " + (cAlias)->F2_DOC + "-" + AllTrim((cAlias)->F2_SERIE) + " e este ser� estornado automaticamente.", cTitulo)
	EndIf	
	(cAlias)->(DbCloseArea())

Return lRet