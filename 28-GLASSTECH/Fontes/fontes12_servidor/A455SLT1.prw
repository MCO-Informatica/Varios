#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A455SLT1  �Autor  � S�rgio Santana     � Data �  14/03/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ordena��o dos campas a serem demonstrados no browse de se- ���
���          � le��o                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Thermoglass                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



User Function A455SLT1()

    // Paramixb = { aStruTrb ,aBrowse }

    Local _aClas := {}
    aAdd( _aClas,{"TRB_OK",,""} )
	aAdd( _aClas,{"TRB_LOCALI",,RetTitle("C6_LOCALIZ")} )
	aAdd( _aClas,{"TRB_QTDLIB",,RetTitle("C6_QTDLIB")} )
	aAdd( _aClas,{"TRB_LOTECT",,RetTitle("C6_LOTECTL")} )
	aAdd( _aClas,{"TRB_NUMLOT",,RetTitle("C6_NUMLOTE")} )
	aAdd( _aClas,{"TRB_POTENC",,RetTitle("C6_POTENCI")} )
	aAdd( _aClas,{"TRB_NUMSER",,RetTitle("C6_NUMSERI")} )
	aAdd( _aClas,{"TRB_DTVALI",,RetTitle("C6_DTVALID")} )
	
Return( { Paramixb[1], _aClas } )