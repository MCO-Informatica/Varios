#include "topconn.ch"
#include "protheus.ch"
#DEFINE DIRXML  "XMLNFE\"
#DEFINE DIRALER "NEW\"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACOMR06   �Autor  �Microsiga           � Data �  04/16/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que gera um arquivo xml e salva na pasta             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ACOMR06( cChave, cDownNF)

Local nArquivo := 0
Local cPreName := "NFe"
Local cNomeArq := cPreName+cChave+".XML" 
Private cStartLido	:= Trim(DIRXML)+DIRALER   

If ( nArquivo := MsFcreate( cStartLido + cNomeArq ) ) > 0
	FWrite( nArquivo, cDownNF )	  
EndIf              

If nArquivo > 0
	FClose(nArquivo)
EndIf

Return cNomeArq