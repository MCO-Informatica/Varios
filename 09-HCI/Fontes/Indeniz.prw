#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Indeniz   � Autor � Eduardo Porto      � Data �  19/07/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Calculo de 1 dia de salario por ano trabalhado             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Roteiro - Rescisao                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Indeniz()        

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

SetPrvt("nIndeniz,nAnos,dAnoDem,dAnoAdm,nTotal,dAnoSist")
Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)

dAnoDem		:=	SRG->RG_DATADEM
dAnoAdm		:=	SRA->RA_ADMISSA
nAnos		:=	((dAnoDem - dAnoAdm)/365)
nQtdeanos	:= 	0 
nIndeniz    := 	0


//  Roteiro de Calculo de Indenizacao na Rescisao

nIndeniz := ((SRA->RA_SALARIO/30)*int(nAnos))


If nIndeniz > 0 
	If SRA->RA_CATFUNC = "H"
		fGeraVerba("497",nIndeniz*SRA->RA_HRSMES,nQtdeanos,,,,,,,,.T.)
	Else
		fGeraVerba("497",nIndeniz,nQtdeanos,,,,,,,,.T.)
	EndIf          
EndIf

Return(" ")


