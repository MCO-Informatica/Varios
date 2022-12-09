#INCLUDE "PROTHEUS.CH"    
#INCLUDE "RWMAKE.CH"                                                                                                                       
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CARGA_SZV  � Autor � Ilidio Abreu       � Data � 09/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Faz a carga da tabela baseado na planilha de saldos da     ���
���          � Superpedido. Programa sera usado apenas uma vez.           ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico - Laselva                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CARGA_SZV 

dbUseArea( .T.,"TOPCONN", "SZV010",, .T., .F. ) 
dbselectarea("SZV") 

_cArq:= "E:\LaSelva\superpedido4.txt" 
FT_FUSE(_cArq)
FT_FGotop()   
FT_FSkip()
_cLinha := ""

Do While ( !FT_FEof() )
	_cLinha  := alltrim(FT_FREADLN())

    reclock("SZV",.t.)

    SZV->ZV_FILIAL 	:= "  "
	SZV->ZV_COD		:= substr(_cLinha,1,14)	
	SZV->ZV_CODBAR	:= substr(_cLinha,14,20)
	SZV->ZV_ISBN	:= substr(_cLinha,32,20)
	SZV->ZV_DESC	:= substr(_cLinha,52,50)
	SZV->ZV_EDITORA	:= alltrim(substr(_cLinha,160,45))
	SZV->ZV_SALDO	:=val(substr(_cLinha,213,4))

	MsUnlockAll()

	FT_FSkip()
	
Enddo
FT_FUse()	

Return


   

