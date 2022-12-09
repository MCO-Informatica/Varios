#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVV001		�Autor  �Microsiga	     � Data �  16/01/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o da restri��o de armazens em movimentos internos   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVV001(cLocal)

Local aArea 	:= GetArea()
Local cArmzRest	:= U_MyNewSX6("CV_RESTLOC", "00|92"	,"C","Restri��o do armazem para movimentos internos", "", "", .F. )
Local cUserAut	:= U_MyNewSX6("CV_UAUTLOC", ""	,"C","Usu�rios autorizados a utilizar os armazens", "", "", .F. )
Local cRotRest	:= U_MyNewSX6("CV_ROTRLOC", "MATA240|MATA241"	,"C","Rotinas restritas na utiliza��o do armaz�m", "", "", .F. )
Local lRet		:= .T.	
Local cCodUser  := Alltrim(RetCodUsr()) 

Default cLocal := ""

If (FunName() $ Alltrim(cRotRest)) .And. Alltrim(cLocal) $ Alltrim(cArmzRest) .And. !(Alltrim(cCodUser) $ Alltrim(cUserAut))
	Aviso("Aten��o-PZCVV001","Usu�rio n�o autorizado a utilizar o armaz�m: "+Alltrim(cLocal),{"Ok"},2)
	lRet	:= .F.
EndIf

RestArea(aArea)	
Return lRet