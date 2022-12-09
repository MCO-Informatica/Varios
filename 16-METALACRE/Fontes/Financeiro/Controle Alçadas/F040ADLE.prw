#include "rwmake.ch"
/*
���������������������������������������������������������������������������
���������������������������������������������������������������������������
�����������������������������������������������������������������������ͻ��
��� Programa � F040ADLE � Autor � Luiz Alberto       � Data �  MAR/17   ���
�����������������������������������������������������������������������͹��
��� Funcao   � Legenda Contas a Pagar     ���
�����������������������������������������������������������������������͹��
��� Uso      � Personalizacao Metalacre                                    ���
�����������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
User Function F040ADLE
Local aRet := {}     
Local cAli := If(AllTrim(Upper(FunName()))$("FINA740/FINA040"),"SE1","SE2")

If cAli == "SE2"
     aAdd(aRet,{"BR_VIOLETA","T�tulo Aguard. Libera��o (Al�ada)"})
     aAdd(aRet,{"BR_LARANJA","T�tulo Liberado (Al�ada)"})
     aAdd(aRet,{"BR_PRETO","T�tulo Rejeitado (Al�ada)"})
Endif

Return aRet

/*
If FunName() $ "FINA050,FINA750"
     aAdd(aRet,{"BR_VIOLETA","T�tulo Aguard. Libera��o (Al�ada)"})
     aAdd(aRet,{"BR_LARANJA","T�tulo Liberado (Al�ada)"})
     aAdd(aRet,{"BR_PRETO","T�tulo Rejeitado (Al�ada)"})
EndIf
*/
//If FunName() $ "FINA040,FINA740"
//     aAdd(aRet,{"BR_LARANJA","T�tulo Bloqueado"})
//EndIf
//Return aRet


/*
���������������������������������������������������������������������������
���������������������������������������������������������������������������
�����������������������������������������������������������������������ͻ��
��� Programa � F040URET � Autor � Luiz Alberto       � Data �  MAR/17   ���
�����������������������������������������������������������������������͹��
��� Funcao   � Controle de Legendas Contas a Pagar      ���
�����������������������������������������������������������������������͹��
��� Uso      � Personalizacao Metalacre                                    ���
�����������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
User Function F040URET
Local aRet := {}
Local cAli := If(AllTrim(Upper(FunName()))$("FINA740/FINA040"),"SE1","SE2")

If cAli=="SE2"
     aAdd(aRet,{"(E2_XCONAP) <> 'L' .AND. E2_ORIGEM='FINA050' ","BR_VIOLETA"})
     aAdd(aRet,{"(E2_XCONAP) == 'L' .AND. E2_ORIGEM='FINA050' ","BR_LARANJA"})
     aAdd(aRet,{"(E2_XCONAP) == 'R' .AND. E2_ORIGEM='FINA050' ","BR_PRETO"})  
Endif

/*If FunName() $ "FINA050,FINA750"
     aAdd(aRet,{"(E2_XCONAP) <> 'L' .AND. E2_ORIGEM='FINA050' ","BR_VIOLETA"})
     aAdd(aRet,{"(E2_XCONAP) == 'L' .AND. E2_ORIGEM='FINA050' ","BR_LARANJA"})
     aAdd(aRet,{"(E2_XCONAP) == 'R' .AND. E2_ORIGEM='FINA050' ","BR_PRETO"})  
EndIf
*/
//If FunName() $ "FINA040,FINA740"
//     aAdd(aRet,{"(E1_MSBLQL) == '1'","BR_LARANJA"})
//EndIf
Return aRet