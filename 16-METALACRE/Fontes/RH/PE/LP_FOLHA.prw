#Include "Protheus.ch"
#Include "RWMAKE.CH"

/*
�������������������������������������������������������������������������ͻ��
���Programa  � LP_SED �Autor � Alexandre Antunes Lima � Data � 19/04/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Pega a conta dsa natureza                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Emporio                                              ���
�������������������������������������������������������������������������ͼ��
*/
User Function LP_FOLHA(_cCC)
Local _cAlias:= Alias()
Local _cCC


If SubStr(AllTrim(_cCC),1,4) == "3012"
	_cCC := '301200'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3013"
	_cCC := '301300'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3015"
	_cCC := '301500'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3016"
	_cCC := '301600'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3017"
	_cCC := '301700'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3018"
	_cCC := '301800'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3019"
	_cCC := '301900'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3021"
	_cCC := '302100'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3022"
	_cCC := '302200'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3028"
	_cCC := '302800'
ElseIf SubStr(AllTrim(_cCC),1,4) == "3029"
	_cCC := '302900'
EndIf

Return(_cCC) 