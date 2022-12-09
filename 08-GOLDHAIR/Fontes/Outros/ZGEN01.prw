#INCLUDE "PRTOPDEF.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ZGEN01�Autor � Inntecnet - Thiago Dieguez� Data � 16/04/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Importacao de estruturas e produtos do sistema antigo      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Gold Hair                                       ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function ZGEN01()

Local Tmp1Cdx

//Abrindo o DBF no TOP
dbUseArea( .T. ,"DBFCDX", "\IMPORT\sb2mea.dbf" , "ESTRUT" )
dbselectarea("sb2mea")
//Criando Indice para o DBF
Tmp1Cdx := CriaTrab(,.f.)
IndRegua("ESTRUT",Tmp1Cdx,"b2_cod",,,)

dbselectarea("sb2mea")
DbSetOrder(1)
dbgotop()

Begin Transaction

//Lendo todo arquivo DBF
While !eof()
	
	DbSelectArea("SB2")
	DbSetOrder(1)
	DbGotop()
	DbSeek(xFilial("SB2") + SB2MEA->B2_COD )
	
	if found()
		
		//Gravando dados
		dbselectarea("SB2MEA")
		RecLock("SB2",.F.)
		SB2->B2_qEMPPRJ	:=	SB2MEA->b2_QEMPPRJ
		MsUnLock()
		
	endif                                                                   
	
	dbselectarea("SB2MEA")
	dbSkip()
End

End Transaction

Alert("Processamento Concluido!!!")

//Excluindo o arquivo de indices
Ferase(Tmp1Cdx+OrdBagExt())
//Fechando o DBF no TOP
dbselectarea("SB2MEA")
DbCloseArea()

Return()
