#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa470Cta  �Autor  �Andreza Favero      � Data �  15/10/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para alterar os dados bancarios do extrato���
���          � bancario.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico ECL                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Fa470Cta()

 
Local aArea := GetArea()
Local cBcoOri:= PARAMIXB[1]
Local cAgOri := PARAMIXB[2]
Local cCCOri := PARAMIXB[3]

cRecno := Posicione("SA6",1,xFilial("SA6")+cBcoOri+cAgOri, "SA6->(Recno())")


DbSelectArea("SA6")
SA6->(DbSetOrder(1))
SA6->(DbGoTO(cRecno))

While SA6->(!Eof())
     
     If StrTran(StrTran(cCCOri," ", ""),"-","") == StrTran(StrTran(SA6->A6_xNUMCO," ", ""),"-","").AND.;
        StrTran(StrTran(cBcoOri," ", ""),"-","") == StrTran(StrTran(SA6->A6_COD," ", ""),"-","").AND.;  
        StrTran(StrTran(cAgOri," ", ""),"-","") == StrTran(StrTran(SA6->A6_AGENCIA," ", ""),"-","")
        
     cCCori:=SA6->A6_xNUMCO
     
     Exit

     EndIf

 SA6->(DbSkip())

End-While

 

 

RestArea(aArea)

 

Return({cBcoOri,cAgOri,cCCori})

 
