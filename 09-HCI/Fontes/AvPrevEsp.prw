#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AvPrevEsp � Autor � Eduardo Porto      � Data �  19/07/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Calculo do Aviso Previo Especial                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Roteiro - Rescisao                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AvPrevEsp()        

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

SetPrvt("nIndeniz,nAnos,dAnoDem,dAnoAdm,nTotal,dAnoSist")
Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)

dAnoSist	:=	dDataBase
dAnoNasc	:=	SRA->RA_NASC
dAnoDem		:=	SRG->RG_DATADEM
dAnoAdm		:=	SRA->RA_ADMISSA
nTotal		:=	((dAnoSist-dAnoNasc)/365)   
nAnos		:=	((dAnoDem - dAnoAdm)/365)
nQtdeanos	:= 	0 
nIndeniz    := 	0


//  Roteiro de Calculo de Indenizacao na Rescisao


If nTotal >= 45 .and. nAnos > 5 
	nQtdeanos:= (15)
	nIndeniz := ((SRA->RA_SALARIO/30)*nQtdeanos)
EndIf 

If (nTotal >= 45 .and. nAnos > 5) .and. SRA->RA_Filial == "02"
	nQtdeanos:= (30)
	nIndeniz := ((SRA->RA_SALARIO/30)*nQtdeanos)
EndIf 

If nIndeniz > 0 
	If SRA->RA_CATFUNC = "H"
		fGeraVerba("495",nIndeniz*SRA->RA_HRSMES,nQtdeanos,,,,,,,,.T.)
	Else
		fGeraVerba("495",nIndeniz,nQtdeanos,,,,,,,,.T.)
	EndIf          
EndIf

Return(" ")


