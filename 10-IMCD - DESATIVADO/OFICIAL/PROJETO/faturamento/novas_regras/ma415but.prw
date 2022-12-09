#INCLUDE "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415BUT  � Autor � Junior Carvalho    � Data �  28/12/2017 ���
�������������������������������������������������������������������������͹��
��� Descricao� Incluir bot�o no Orocamento                                ���
�������������������������������������������������������������������������͹��
��� Uso      � ORCAMENTOS MATA415                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/


User Function MA415BUT()

	aUsBut	:= {}
	aAdd(aUsBut,{"BMPCPO"	,{|| U_AFAT008()} ,"Enviar E-mail"})
	aAdd(aUsBut,{"NOTE"  	,{|| U_CFAT020(M->CJ_CLIENTE,M->CJ_LOJA)}, "Ult.Compra"}) 
	aAdd(aUsBut,{"RELATORIO",{|| Processa({|| U_CFAT009(TMP1->CK_PRODUTO)},"Consulta Produto","",.T.) }, "Consulta Produto"}) 
	aAdd(aUsBut,{"TROCO",	{|| U_C010VEND(TMP1->CK_PRODUTO, M->CJ_CLIENTE,M->CJ_LOJA)}, "Consulta Pre�o Hist�rico", "Consulta Pre�o Hist�rico"})

Return(aUsBut)
