#include "rwmake.ch"  

User Function AjusteSB2() 

SetPrvt("_CCOD")
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���RDMAKE    � AJUSTE   � Autor � Rodrigo Demetrios     � Data � 17/07/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualizacao SB9	  	 						              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � ACOS VIC                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
#IFDEF WINDOWS
	Processa({|| GERA()})
#ENDIF

Return

Static Function Gera()

dbSelectArea("SB1")
DBSETORDER(1)
DBGOTOP()
ProcRegua(RecCount(),"Aguarde")
While !Eof()
    _cMat        := SB1->B1_COD
           DBSELECTAREA("SB2")
           RECLOCK("SB2",.T.)
                SB2->B2_FILIAL  :=      "01"
                SB2->B2_COD     :=      _cMat
                SB2->B2_LOCAL   :=      "01"
           MsUnlock()
           
           DBSELECTAREA("SB9")
           RECLOCK("SB9",.T.)
                SB9->B9_FILIAL  :=      "01"
                SB9->B9_COD     :=      _cMat
                SB9->B9_LOCAL   :=      "01" 
                SB9->B9_DATA    :=      CTOD("17/07/08")
           MsUnlock()
           
	dbSelectArea("SB1")
 	dbskip()
    loop
end

return