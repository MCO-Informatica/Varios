#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA180TOK  �Autor  �Opvs (David)        � Data �  04/07/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para na rotina de Complemento de Produtos  ���
���          �que verifica se o produto sendo atualizado consta de al-    ���
���          �guma tabela que e enviada ao site. Com isso atualiza a mes- ���
���          �ma automaticamente e caso nao obtenha sucesso nao permite a ���
���          �alteracao                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA180TOK
Local lRet 	:= .T.
Local cSql	:= ""
Local cTabPrc	:= GetMV("MV_XTABPRC",,"001,002")

cTabPrc := "'"+StrTran(cTabPrc,",","','")+"'"

cSql := " SELECT DA1_CODTAB "
cSql += " FROM " + RetSqlName("DA1") + " DA1 "
cSql += " LEFT JOIN " + RetSqlName("DA0") + " DA0 ON DA0.DA0_FILIAL = '" + xFilial("DA0") + "' AND DA0.D_E_L_E_T_ = ' ' AND DA0.DA0_CODTAB = DA1.DA1_CODTAB "
cSql += " LEFT JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = DA1.DA1_CODPRO AND SB1.D_E_L_E_T_ = ' ' "
cSql += " WHERE DA1.DA1_FILIAL = '" + xFilial("DA1") + "' "
cSql += "   AND DA1.DA1_CODTAB IN (" + cTabPrc + ") "
cSql += "   AND DA1.DA1_CODPRO = '" + M->B5_COD + "' "
cSql += "   AND DA1.DA1_PRCVEN > 0 "
cSql += "   AND DA1.DA1_ATIVO = '1' "
cSql += "   AND DA1.D_E_L_E_T_ = ' ' "
cSql += " GROUP BY DA1_CODTAB "

cSql := ChangeQuery(cSql)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"QRYDA1",.F.,.T.)
DbSelectArea("QRYDA1")
	
QRYDA1->(DbGoTop())
While QRYDA1->(!Eof())

	If !U_VNDA020(QRYDA1->DA1_CODTAB)
		lRet := .F.
		Help( ,, 'MA180TOK',,'N�o Foi poss�vel Alterar os dados do Produto no E-commerce. Altera��o n�o foi realizada. Entre em contato com Administrador', 1, 0 ) 
		Exit
	EndIf

	QRYDA1->(DbSkip())	
EndDo

QRYDA1->(DbCloseArea())	

Return(lRet)