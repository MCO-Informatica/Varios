#include 'protheus.ch'

#DEFINE PRODUTDE	1
#DEFINE PRODUTATE	2
#DEFINE LOCALDE		3
#DEFINE LOCALATE	4
#DEFINE LOTEDE		5
#DEFINE LOTEATE		6
#DEFINE SBLOTEDE	7
#DEFINE SBLOTEATE	8

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PZCVP001 �Autor  �Microsiga 	          � Data � 12/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de reprocessamento do saldo de lote bloqueado		  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVP001()

Local aArea 	:= GetArea()
Local aParams    := {}

If CVPerg(@aParams)  

	Processa( {|| u_PZCVA001(aParams[PRODUTDE],;	//Produto de
							aParams[PRODUTATE],;	//Produto ate
							aParams[LOCALDE],;		//Loja de
							aParams[LOCALATE],;		//Loja ate
							aParams[LOTEDE],;		//Lote de 
							aParams[LOTEATE],;		//Lote ate
							aParams[SBLOTEDE],;		//Sub-lote de
							aParams[SBLOTEATE];		//Sub-lote ate
							);
	 			},"Aguarde...","" )
	 
	 Aviso("Aten��o","Reprocessamento finalizado.",{"Ok"},2)
EndIf   

RestArea(aArea)	
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CVPerg	�Autor  �Microsiga		     � Data �  12/12/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Perguntas a serem utilizadas no filtro				      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CVPerg(aParams)

Local aParamBox := {}
Local lRet      := .T.
Local cLoadArq	:= "PZCVP001"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt) 

AADD(aParamBox,{1,"Produto de"			,Space(TAMSX3("B1_COD")[1])		,""	,"","SB1","",50,.F.})
AADD(aParamBox,{1,"Produto ate"			,Space(TAMSX3("B1_COD")[1])		,""	,"","SB1","",50,.T.})
AADD(aParamBox,{1,"Armaz. de"			,Space(TAMSX3("B2_LOCAL")[1])	,""	,"","","",50,.F.})
AADD(aParamBox,{1,"Armaz. ate"			,Space(TAMSX3("B2_LOCAL")[1])	,""	,"","","",50,.T.})
AADD(aParamBox,{1,"Lote de"				,Space(TAMSX3("B8_LOTECTL")[1])	,""	,"","","",50,.F.})
AADD(aParamBox,{1,"Lote ate"			,Space(TAMSX3("B8_LOTECTL")[1])	,""	,"","","",50,.T.})
AADD(aParamBox,{1,"Sub-Lote de"			,Space(TAMSX3("B8_NUMLOTE")[1])	,""	,"","","",50,.F.})
AADD(aParamBox,{1,"Sub-Lote ate"		,Space(TAMSX3("B8_NUMLOTE")[1])	,""	,"","","",50,.T.})

lRet := ParamBox(aParamBox, "Par�metros", aParams, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

Return lRet
