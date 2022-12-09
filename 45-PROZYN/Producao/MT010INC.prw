#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MT010INC		�Autor  �Microsiga	     � Data �  27/01/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �PE ap�s a inclus�o do produto						 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT010INC()  

	Local aArea		:= GetArea()
	Local cTpComp	:= U_MyNewSX6("CV_TPCOMPI", "PA"	,"C","Tipo de produto para complemento da cor do produto", "", "", .F. )

	//Realiza o bloqueio do produto ap�s a inclus�o
	BlqProd()

	//Complemento do Produto
	If Alltrim(SB1->B1_TIPO) $ Alltrim(cTpComp)
		CompPrdImp(SB1->B1_COD, SB1->B1_DESC)
	EndIf

	RestArea(aArea)
return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �BlqProd		�Autor  �Microsiga	     � Data �  27/01/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Bloqueio de produto								 	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function BlqProd()

	Local aArea := GetArea()

	DbSelectArea("SB1")
	DbSetOrder(1)

	If SB1->(DbSeek(xFilial("SB1") + SB1->B1_COD ))
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL := '1'
		SB1->(MsUnlock())
	endif

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CompPrdImp	�Autor  �Microsiga	     � Data �  27/01/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Informa��o da impressora no complemento de produto.		  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function CompPrdImp(cProd, cDesc)

	Local aArea		:= GetArea()
	Local aParam	:= {}

	Default cProd	:= ""
	Default cDesc	:= ""

	If SB5->(!DbSeek(xFilial("SB5") + cProd)) 
		
		If PergImpres(@aParam)
		
			Reclock("SB5",.T.)
			SB5->B5_FILIAL 	:= xFilial("SB5") 
			SB5->B5_COD		:= cProd
			SB5->B5_CEME	:= cDesc
			SB5->B5_YCODIMP	:= aParam[1]
			SB5->(MsUnLock())
		Else
			Aviso("Aten��o","Necess�rio informar o grupo de impress�o do rotulo.",{"Ok"},2)
			CompPrdImp(cProd, cDesc)
		EndIf
	EndIf

	RestArea(aArea)
Return 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PergImpres  �Autor  �Microsiga	     � Data �  27/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pergunta para o preenchimento da impressora                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                               	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PergImpres(aParam)

	Local aArea 		:= GetArea()
	Local aParamBox		:= {} 
	Local lRet			:= .F.
	Local cLoadArq		:= "mt010incimp"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)

	AADD(aParamBox,{1,"Grupo Imp."	,Space(TAMSX3("PZ1_COD")[1])	,"","U_PZVldImp(MV_PAR01)","PZ1","",50,.T.})

	//Monta a pergunta
	lRet := ParamBox(aParamBox, "Par�metros", @aParam, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

	RestArea(aArea)
Return lRet  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldImp	  �Autor  �Microsiga	     � Data �  27/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o do grupo de impress�o do rotulo	                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                               	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZVldImp(cCodImp)

Local aArea := GetArea()
Local lRet	:= .F.

Default cCodImp := ""

DbSelectArea("PZ1")
DbSetOrder(1)
If PZ1->(DbSeek(xFilial("PZ1") + PadR(cCodImp, TAMSX3("PZ1_COD")[1]) ))
	lRet := .T.
Else
	Aviso("Aten��o","C�digo do grupo inv�lido.",{"Ok"},2)
EndIf 

RestArea(aArea)
Return lRet