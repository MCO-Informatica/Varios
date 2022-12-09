#include "rwmake.ch"

User Function RFATA05()

Processa({|| PRECO()},"Atualização de Custos...")
Return

Static Function PRECO()


Local _cArquivo		:=	"\SYSTEM\CUSTO.DBF"

dbUseArea(.t.,"DBFCDX",_cArquivo,"PRC",.f.,.f.)


dbSelectArea("PRC")
dbGoTop()
ProcRegua(RecCount())

While Eof() == .f.
	
	IncProc("Processando Atualizacao de Custos...")
	
	dbSelectArea("SB9")
	dbSetOrder(1)
	If dbSeek(xFilial("SB9")+PRC->PRODUTO,.F.)
		
		While SB9->B9_COD == PRC->PRODUTO
		
			RecLock("SB9",.f.)
			SB9->B9_CM1 	:=	PRC->CUSTO
			SB9->B9_CUSTD 	:=	PRC->CUSTO
			SB9->B9_VINI1 	:=	SB9->B9_QINI * PRC->CUSTO
			MsUnLock()
			
			dbSelectArea("SB9")
			dbSkip()
	
		EndDo
	EndIf
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial("SB2")+PRC->PRODUTO,.F.)
		
		While SB2->B2_COD == PRC->PRODUTO
		
			RecLock("SB2",.f.)
			SB2->B2_CM1 	:=	PRC->CUSTO
			SB2->B2_VATU1 	:=	SB2->B2_QATU * PRC->CUSTO
			MsUnLock()
			
			dbSelectArea("SB2")
			dbSkip()
	
		EndDo
	EndIf

	dbSelectArea("SD1")
	dbSetOrder(2)
	If dbSeek(xFilial("SD1")+PRC->PRODUTO,.F.)
		
		While SD1->D1_COD == PRC->PRODUTO
		
			RecLock("SD1",.f.)
			SD1->D1_CUSTO 	:=	SD1->D1_QUANT * PRC->CUSTO
			MsUnLock()
			
			dbSelectArea("SD1")
			dbSkip()
	
		EndDo
	EndIf

	dbSelectArea("SD2")
	dbSetOrder(1)
	If dbSeek(xFilial("SD2")+PRC->PRODUTO,.F.)
		
		While SD2->D2_COD == PRC->PRODUTO
		
			RecLock("SD2",.f.)
			SD2->D2_CUSTO1 	:=	SD2->D2_QUANT * PRC->CUSTO
			MsUnLock()
			
			dbSelectArea("SD2")
			dbSkip()
	
		EndDo
	EndIf

	dbSelectArea("SD3")
	dbSetOrder(3)
	If dbSeek(xFilial("SD3")+PRC->PRODUTO,.F.)
		
		While SD3->D3_COD == PRC->PRODUTO
		
			RecLock("SD3",.f.)
			SD3->D3_CUSTO1 	:=	SD3->D3_QUANT * PRC->CUSTO
			MsUnLock()
			
			dbSelectArea("SD3")
			dbSkip()
	
		EndDo
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+PRC->PRODUTO,.F.)
		
		While SB1->B1_COD == PRC->PRODUTO
		
			RecLock("SB1",.f.)
			SB1->B1_CUSTD 	:=	PRC->CUSTO
			MsUnLock()
			
			dbSelectArea("SB1")
			dbSkip()
	
		EndDo
	EndIf



	dbSelectArea("PRC")
	dbSkip()
EndDo

Return