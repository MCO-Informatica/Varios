#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410MNU  �Autor  �Isaque O. Silva   � Data �  	11/07/2016���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. para acrescentar botao no menu cadastro de produtos	  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                 
User Function MT010BRW()

Local cUsrLib	:= U_MyNewSX6("CV_USRCPYR", ""	,"C","Usuario liberados a copiar produto de reprocesso", "", "", .F. )
Local cCodUsr	:= Alltrim(RetCodUsr())

aadd(aRotina,{'Frases','U_RFATE004()' , 0 , 4,0,.T.})
aadd(aRotina,{'Cons.Est.Esp.','U_PZCVC001()' , 0 , 4,0,.T.})

If Alltrim(cCodUsr) $ Alltrim(cUsrLib)
	aadd(aRotina,{'Copia Reprocesso','U_PZCVA010()' , 0 , 4,0,.T.})
EndIf
 
Return()