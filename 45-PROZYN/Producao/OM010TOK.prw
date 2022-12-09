#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OM010TOK	 �Autor  �Microsiga           � Data � 12/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o da grava��o da tabela de pre�o					  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function OM010TOK()

Local aArea 	:= GetArea()
Local lRet		:= .T.
Local oModel	:= ParamixB[1]
Local oMdDa0	:= oModel:GetModel("DA0MASTER")
Local cTabela	:= SuperGetMv( "LI_TABPRE",.F.,"ARV")

//Verifica se o cliente possui tabela de pre�o ativa
//Ajuste para ignorar valida��o na tabela da Loja Integrada - Gustavo Gonzalez - 26/01/2022 
If (INCLUI .Or. ALTERA) .And. oMdDa0:GetValue("DA0_CODTAB") <> cTabela
	lRet :=  VldCliAti(oMdDa0:GetValue("DA0_YCODCL"),; 
					oMdDa0:GetValue("DA0_YLJCLI"),; 
					oMdDa0:GetValue("DA0_CODTAB"))
EndIf

RestArea(aArea)	
Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldCliAti	 �Autor  �Microsiga           � Data � 12/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se existe tabela de pre�o ativa para este cliente  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function VldCliAti(cCodCli, cLoja, cCodTab)

Local aArea 	:= GetArea()
Local lRet		:= .T.
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local cTabAtv	:= ""

Default cCodCli := "" 
Default cLoja	:= "" 
Default cCodTab	:= ""

cQuery	:= " SELECT DA0_CODTAB FROM "+RetSqlName("DA0")+" DA0 "+CRLF
cQuery	+= " WHERE DA0_FILIAL  = '"+xFilial("DA0")+"' "+CRLF
cQuery	+= " AND DA0_CODTAB != '"+cCodTab+"' "+CRLF
cQuery	+= " AND DA0_YCODCL = '"+cCodCli+"' "+CRLF
cQuery	+= " AND DA0_YLJCLI = '"+cLoja+"' "+CRLF
cQuery	+= " AND DA0_ATIVO = '1' " +CRLF
cQuery	+= " AND D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cArqTmp , .F., .T.)

While (cArqTmp)->(!Eof())

	cTabAtv += "-"+(cArqTmp)->DA0_CODTAB+";"+CRLF
	
	(cArqTmp)->(DbSkip())
EndDo

If Empty(cTabAtv)
	lRet := .T.
Else
	Aviso("Aten��o","Existe tabela ativa para o cliente "+cCodCli+"/"+cLoja+"."+CRLF+CRLF+"Segue o c�digo da tabela: "+CRLF+cTabAtv, {"Ok"},2)
	lRet := .F.
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return lRet
