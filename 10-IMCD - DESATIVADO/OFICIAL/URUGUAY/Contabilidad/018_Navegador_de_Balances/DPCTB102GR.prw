
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CT102BTO �Autor  � Urudata/SA         �Fecha �  11/17/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Punto de entrada en la pantalla de asiento manual,         ���
���          �  agrega boton de impresion y de rastreo                    ���
�������������������������������������������������������������������������͹��
��� Uso      � Punto de entrada - SIGACTB                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CT102BTO
Local aBtnInc := {}
If (Type("INCLUI") != "L") .Or. (Type("INCLUI") == "L" .And. !INCLUI)
		Aadd( aBtnInc, {"S4WB005N"    ,{ || U_PosCt2R() }	, "Rastrear Asiento"	} )
EndIf
Return aBtnInc

User Function PosCt2R()
Local aArea := GetArea()

dbSelectArea("CT2")
CtbC010Rot("CT2",CT2->(Recno()),2)

RestArea(aArea)
Return NIL


