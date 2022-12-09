#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PCOA1001 �Autor  �TOTVS               � Data �  01/07/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adiciona botoes na tela de PLANILHA ORCAMENTARIA            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PCOA1001()
Local _nNivel    := GetNewPar("ES_PCONIV",0)                 // Padr�o = 5. Neste par�metro colocar com 6. Depois alterar o n�vel do usu�rio que ir� importar
Local aRetorno   := {}

/* Local aPlanning  :=	{	{"Finaliza Orc"		,"MsgRun('Finalizando Or�amento. Aguarde...',, {|| U_FIPCOA11() } )",0,3},;
						{"Reabre Orc"		,"MsgRun('Reabrindo Or�amento. Aguarde...',, {|| U_FIPCOA23() } )"	,0,3},;
						{"Aprova Orc"		,"U_FIPCOA22(1)"													,0,3},;
						{"Est. Aprovacao"	,"U_FIPCOA22(2)"													,0,3},;
						{"Consulta CC"		,"MsgRun('Consultando UOs. Aguarde...',, {|| U_SIPCOA13() } )"		,0,3}}
*/

Local aImpPlan  := {{ "Exp. Planilha","U_SIPCOA15",0,4},{ "Imp. Planilha","U_RENOIPCO",0,4}}
						
// Verifica se usu�rio tem nivel para acessar rotina
IF cNivel >= _nNivel
//	aAdd(aRetorno,{"Planning",aPlanning,0,6})
	aAdd(aRetorno,{"Importacao",aImpPlan,0,6})
ENDIF

Return(aRetorno)