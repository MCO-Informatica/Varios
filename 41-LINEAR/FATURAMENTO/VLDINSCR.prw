#include "rwmake.ch"
#include "ap5mail.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDINSCR  �Autor  �Rogerio Costa - Supertech� Dt 09/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDACAO NA INCLUSAO DA IE CLIENTE, CRIAR INDICE N 09 PARA���
���          � PESQUISA                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VLDINSCR()

CINSCR:=M->A1_INSCR

//'336.449.933.116 '

IE_ATU:=GETADVFVAL("SA1","A1_INSCR",XFILIAL("SA1")+CINSCR,09,"")

IF "ISENT" $ UPPER(IE_ATU)
	RETURN(.T.)
ELSE
	IF IE_ATU=CINSCR
		
		ALERT("A incricao estadual "+ CINSCR + ", ja esta cadastrada no sistema")
		
		RETURN(.f.)
		
	END IF
END IF

RETURN(.t.)
