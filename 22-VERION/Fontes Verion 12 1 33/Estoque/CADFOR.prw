#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADFOR    � Autor � RICARDO CAVALINI   � Data �  06/04/09   ���
�������������������������������������������������������������������������͹��
���Descricao � AJUSTA A NUMERACAO DO CAD DE FORNECEDOR                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CADFOR()


_cAlias:=Alias()
_nOrder:=IndexOrd()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
DbSelectArea("SA2")
DbGotop()
DbSeek(xFilial("SA2")+"ESTADO00")
DbSkip(-1)
_cCodCli := STRZERO((VAL(SA2->A2_COD)+1),6)
_cCodClP := STRZERO((VAL(SA2->A2_COD)+2),6)


USE SXF Alias "SXF" New
DbSelectArea("SXF")
dbGoTop()
while !eof()
   If SXF->XF_ALIAS <> "SA2"
      DbSkip()
      Loop
   Endif                

   IF ALLTRIM(SXF->XF_FILIAL) <> "\DATA\SA2010"
      DbSkip()
      Loop
   Endif                

   RecLock("SXF",.f.)
    SXF->XF_NUMERO := _CCODCLI
   MsunLock("SXF") 
   DbSelectArea("SXF")
   DBSKIP()
End

USE SXE Alias "SXE" New
DbSelectArea("SXE")
dbGoTop()
while !eof()
   If SXE->XE_ALIAS <> "SA2"
      DbSkip()
      Loop
   Endif

   IF ALLTRIM(SXE->XE_FILIAL) <> "\DATA\SA2010"
      DbSkip()
      Loop
   Endif                

   RecLock("SXE",.f.)
    SXE->XE_NUMERO := _CCODCLP
   MsunLock("SXE") 

   DbSelectArea("SXE")
   DBSKIP()
End

MATA020()

Return
