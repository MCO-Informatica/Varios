#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPROD    � Autor � AP6 IDE            � Data �  18/02/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IMPROD

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local nLocaliz := 0
Private aDADOS := {}
Private cString := "SB1"

*/
//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport() },"ACERTA ENDERECAMENTO DO PRODUTO !!!")
Return

Static Function RunReport

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()

SetRegua(RecCount())

// SB1010
USE PRODUTOS Alias "MRD" New

dbSelectArea("MRD")
dbGoTop()                                                
_cNum   := ""
_CEND   := ""
				                                            
While !Eof()  
      _CNUM  := ALLTRIM(MRD->CODIGO)
      _CEND  := MRD->TIPO
       
         // ACERTA ITENS DO SB1 
  	     DbSelectArea("SB1")
         DBSETORDER(1)      
         IF DBSEEK(XFILIAL()+_CNUM)
   			RecLock("SB1", .F.)
             SB1->B1_VEREND  := _CEND
	        MsUnlock("SB1")
         ENDIF

         DbSelectArea("MRD")
		 DbSkip()
		 IncRegua()
End
Return
