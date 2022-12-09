#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMK260OK  �Autor  �Opvs (David)        � Data �  23/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para Verifica��o dos Campos Cadastrais do Cliente/   ���
���          �Prospect Obrigatorio na Finalizacao de um Atend. TLV        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function TMK260OK()
Local __aArea		:= GetArea()
Local _lRetPE		:= .T.
Local _cCpoSUS		:= GetNewPar("TLV_SUSOBR", "US_CGC,US_DDD,US_TEL,US_EMAIL,US_INSCR") 
Local __aStru		:= StrTokArr(_cCpoSUS,",")
Local _cCpoObr      := ""
Local cCpo			:= CHR(10)+CHR(13)
Local _nPosCpo,_nI	:= 0
Local _nRetAlt		:= 0

If  alltrim(FunName()) == "TMKA271"
	
	For _nI:=1 to Len(__aStru)
		
		_nPosCpo:= SUS->(FieldPos(__aStru[_nI]))
		If _nPosCpo > 0 .and. Empty(&("M->"+__aStru[_nI])) 
			_cCpoObr +=Alltrim(RetTitle(__aStru[_nI]))+CHR(10)+CHR(13)
		EndIf
	
	Next

	If !Empty(_cCpoObr)
		Help(" ",1,"OBRIGAT2",,_cCpoObr,3,1)
		_lRetPE := .F.
	Else
		_lRetPE := .T.	
	EndIf

Else	
	_lRetPE	:= .T.	
EndIf
	
RestArea(__aArea)

Return(_lRetPE)