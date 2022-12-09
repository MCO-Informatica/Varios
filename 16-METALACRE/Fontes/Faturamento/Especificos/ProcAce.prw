#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"

User Function ProcAce()                     
Local aArea := GetArea()
Local 	aSays      	:= {}
Local 	aButtons   	:= {}
Local 	nOpca    	:= 0    
Local	cCadastro	:=	'Reprocessa Carga Fabrica Novo'
Private cPerg := PadR('CGFB',10)

ValidPerg()

Pergunte(cPerg,.f.)

AADD (aSays, "Este programa tem por objetivo efetuar o processamento de ")
AADD (aSays, "saldo do Novo Carga Fabrica.   ")

AAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. )    }} )
AAdd(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AAdd(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	
If nOpca == 1
	If MsgYesNo(OemToAnsi('Alimenta Nova Tabela SZH Saldos Carga Fabrica ?'))
		Processa({||U_ACEPR()})
	Endif
Endif

RestArea(aArea)
Return

User Function AcePR()

dDataIni := MV_PAR01
dDataFim := MV_PAR02

ProcRegua(dDataFim-dDataIni)
For dDt := dDataIni To dDataFim
	IncProc("Aguarde Ajustando Saldos Carga Fabrica...")
	
	SBM->(dbGoTop())
	While SBM->(!Eof())
		If SBM->BM_CAPDIA > 0 .And. !SZH->(dbSetOrder(2), dbSeek(xFilial("SZH")+SBM->BM_GRUPO+DtoS(dDt)))
			If RecLock("SZH",.T.)                                    
				SZH->ZH_FILIAL	:=	xFilial("SZH")
				SZH->ZH_DATA	:=	dDt
				SZH->ZH_GRUPO	:=	SBM->BM_GRUPO
				SZH->ZH_CAPGRP	:=	SBM->BM_CAPDIA
				SZH->(MsUnlock())
			Endif
		Endif
		
		SBM->(dbSkip(1))
	Enddo
Next

SZH->(dbGoTop())

nReg := SZH->(RecCount())

ProcRegua(dDataFim-dDataIni)

If SZH->(dbSetOrder(1), dbSeek(xFilial("SZH")+DtoS(dDataIni),.t.))
	While SZH->(!Eof()) .And. SZH->ZH_DATA <= dDataFim
	
		IncProc("A Produzir C.Fab.: " + DtoC(SZH->ZH_DATA) + " Grupo: " + SZH->ZH_GRUPO)
		
		cGrupo := SZH->ZH_GRUPO
	
		cQuery:= " SELECT SUM(C6_QTDVEN) QTDPROD " +CRLF
		cQuery+= " FROM " + RetSqlName("SC6") +  " C6   " +CRLF
		cQuery+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
		cQuery+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
		cQuery+= " , " + RetSqlName("SC5") +  " C5   " +CRLF
		cQuery+= " WHERE    "
		CQUERY+= "          C6_FILIAL='"+XFilial("SC6")+"' AND C6.D_E_L_E_T_<>'*'  " +CRLF   
		CQUERY+= " AND      C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*'  " +CRLF
		cQuery+= " AND      B1.D_E_L_E_T_<>'*'  AND      B1_FILIAL='"+XFilial("SB1")+"' " +CRLF
		cQuery+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
		cQuery+= " AND      C6_BLQ NOT IN('R')  AND C6_PRODUTO = B1_COD "+CRLF     
		CQUERY+= " AND      C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5_TIPO = 'N'  " +CRLF
		cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO)   "+CRLF 
		cQuery+= " AND      C6_TES <> '516'   "+CRLF            
		If Len(AllTrim(cGrupo)) = 4
			cQuery+= " AND BM_GRUPO IN('" + cGrupo + "')   " +CRLF
		ElseIf Len(AllTrim(cGrupo)) = 3
			cQuery+= " AND BM_GRUPO IN('" + cGrupo + "','"+ AllTrim(cGrupo)+'1' + "','"
			cQuery+=  AllTrim(cGrupo)+'2' + "','" 
			cQuery+=  AllTrim(cGrupo)+'3' + "','" 
			cQuery+=  AllTrim(cGrupo)+'4' + "','" 
			cQuery+=  AllTrim(cGrupo)+'5' + "','" 
			cQuery+=  AllTrim(cGrupo)+'6' + "','" 
			cQuery+=  AllTrim(cGrupo)+'7' + "','" 
			cQuery+=  AllTrim(cGrupo)+'8' + "','" 
			cQuery+=  AllTrim(cGrupo)+'0' + "','" 
			cQuery+=  AllTrim(cGrupo)+'A' + "','" 
			cQuery+=  AllTrim(cGrupo)+'B' + "','" 
			cQuery+=  AllTrim(cGrupo)+'C' + "','" 
			cQuery+=  AllTrim(cGrupo)+'D' + "','" 
			cQuery+=  AllTrim(cGrupo)+'E' + "','" 
			cQuery+=  AllTrim(cGrupo)+'F' + "','" 
			cQuery+=  AllTrim(cGrupo)+'G' + "','" 
			cQuery+=  AllTrim(cGrupo)+'H' + "','" 
			cQuery+=  AllTrim(cGrupo)+'I' + "','" 
			cQuery+=  AllTrim(cGrupo)+'J' + "','" 
			cQuery+=  AllTrim(cGrupo)+'K' + "','" 
			cQuery+=  AllTrim(cGrupo)+'L' + "','" 
			cQuery+=  AllTrim(cGrupo)+'M' + "','" 
			cQuery+=  AllTrim(cGrupo)+'N' + "','" 
			cQuery+=  AllTrim(cGrupo)+'O' + "','" 
			cQuery+=  AllTrim(cGrupo)+'9' + "')   " +CRLF
		Endif
		cQuery+= " AND C6_ENTREG = '" + DtoS(SZH->ZH_DATA) + "'    " +CRLF   
		cQuery+= " AND C6_NUMOP = '' AND C6_DATFAT = ''    " +CRLF   
		
		MemoWrite('C:\Qry\GERAPV.txt',cQuery)
		
		DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSC6", .F., .T. )
		  
		SBM->(dbSetOrder(1), dbSeek(xFilial("SBM")+cGrupo))
		
		If RecLock("SZH",.F.)             
			SZH->ZH_CAPGRP	:=	SBM->BM_CAPDIA
			SZH->ZH_GRPAPR	:=	TMPSC6->QTDPROD
			SZH->ZH_SLDGRP	:=	(SZH->ZH_CAPGRP - SZH->ZH_GRPAPR)
			SZH->(MsUnlock())
		Endif
		
		TMPSC6->(dbCloseArea())
		
		SZH->(dbSkip(1))
	Enddo
Endif

// QUANTIDADE EM PRODUCAO

SZH->(dbGoTop())

nReg := SZH->(RecCount())

ProcRegua(dDataFim-dDataIni)

If SZH->(dbSetOrder(1), dbSeek(xFilial("SZH")+DtoS(dDataIni),.t.))
	While SZH->(!Eof()) .And. SZH->ZH_DATA <= dDataFim
	
		IncProc("Em Producao C.Fab.: " + DtoC(SZH->ZH_DATA) + " Grupo: " + SZH->ZH_GRUPO)
		
		cGrupo := SZH->ZH_GRUPO
	
		If SZH->ZH_DATA < dDataBase
			cQuery:= " SELECT SUM(C2_QUANT) QTDPROD " +CRLF
		Else
			cQuery:= " SELECT SUM(C2_QUANT - C2_QUJE) QTDPROD " +CRLF
		Endif
		CQUERY+= " FROM "   +CRLF
		cQuery+= " " + RetSqlName("SC2") +  " C2   " +CRLF
		cQuery+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
		cQuery+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
		cQuery+= " WHERE    "
		CQUERY+= "          C2_FILIAL='"+XFilial("SC2")+"' AND C2.D_E_L_E_T_<>'*'  " +CRLF
		cQuery+= " AND      B1.D_E_L_E_T_<>'*'  " +CRLF
		cQuery+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
		cQuery+= " AND      B1_FILIAL='"+XFilial("SB1")+"' AND B1.D_E_L_E_T_<>'*'  " +CRLF
		cQuery+= " AND      C2_PRODUTO = B1_COD  "+CRLF         
		cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO)   "+CRLF 
		If SZH->ZH_DATA < dDataBase
			CQUERY+= " AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') ) " +CRLF
		Else
			CQUERY+= " AND (C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') ) " +CRLF
		Endif
		If Len(AllTrim(cGrupo)) = 4
			cQuery+= " AND BM_GRUPO IN('" + cGrupo + "')   " +CRLF
		ElseIf Len(AllTrim(cGrupo)) = 3
			cQuery+= " AND BM_GRUPO IN('" + cGrupo + "','"+ AllTrim(cGrupo)+'1' + "','"
			cQuery+=  AllTrim(cGrupo)+'2' + "','" 
			cQuery+=  AllTrim(cGrupo)+'3' + "','" 
			cQuery+=  AllTrim(cGrupo)+'4' + "','" 
			cQuery+=  AllTrim(cGrupo)+'5' + "','" 
			cQuery+=  AllTrim(cGrupo)+'6' + "','" 
			cQuery+=  AllTrim(cGrupo)+'7' + "','" 
			cQuery+=  AllTrim(cGrupo)+'8' + "','" 
			cQuery+=  AllTrim(cGrupo)+'0' + "','" 
			cQuery+=  AllTrim(cGrupo)+'A' + "','" 
			cQuery+=  AllTrim(cGrupo)+'B' + "','" 
			cQuery+=  AllTrim(cGrupo)+'C' + "','" 
			cQuery+=  AllTrim(cGrupo)+'D' + "','" 
			cQuery+=  AllTrim(cGrupo)+'E' + "','" 
			cQuery+=  AllTrim(cGrupo)+'F' + "','" 
			cQuery+=  AllTrim(cGrupo)+'G' + "','" 
			cQuery+=  AllTrim(cGrupo)+'H' + "','" 
			cQuery+=  AllTrim(cGrupo)+'I' + "','" 
			cQuery+=  AllTrim(cGrupo)+'J' + "','" 
			cQuery+=  AllTrim(cGrupo)+'K' + "','" 
			cQuery+=  AllTrim(cGrupo)+'L' + "','" 
			cQuery+=  AllTrim(cGrupo)+'M' + "','" 
			cQuery+=  AllTrim(cGrupo)+'N' + "','" 
			cQuery+=  AllTrim(cGrupo)+'O' + "','" 
			cQuery+=  AllTrim(cGrupo)+'9' + "')   " +CRLF
		Endif
		If SZH->ZH_DATA >= dDataBase
			cQuery+= " AND NOT (C2_TPOP = 'F' AND C2_DATRF <> '' AND (C2_QUJE < C2_QUANT OR C2_QUJE >= C2_QUANT)) " +CRLF                            
		Endif
		cQuery+= " AND C2_DATPRF = '" + DtoS(SZH->ZH_DATA) + "'    " +CRLF   
	
		DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSC6", .F., .T. )
		  
		SBM->(dbSetOrder(1), dbSeek(xFilial("SBM")+cGrupo))
		
		If RecLock("SZH",.F.)             
			SZH->ZH_CAPGRP	:=	SBM->BM_CAPDIA
			SZH->ZH_GRPUSO	:=	TMPSC6->QTDPROD
			SZH->ZH_SLDGRP	:=	(SZH->ZH_CAPGRP - (SZH->ZH_GRPUSO + SZH->ZH_GRPAPR))
			SZH->(MsUnlock())
		Endif
		
		TMPSC6->(dbCloseArea())
		
		SZH->(dbSkip(1))
	Enddo
Endif
	
_cQuery := "UPDATE "+RetSqlName("SZH") + " SET ZH_SLDGRP = (ZH_CAPGRP - (ZH_GRPUSO + ZH_GRPAPR)) WHERE D_E_L_E_T_ = '' "
			
_nRetSql := tcsqlexec(_cQuery)

			
MsgInfo("Final do Processamento..")
Return
		
		
		

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()
_aArea := GetArea()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,10)

aRegs :={}
Aadd(aRegs,{cPerg,"01","Data Inicial?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data Final  ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","",""})

For i := 1 To Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := aRegs[i,01]
		SX1->X1_ORDEM   := aRegs[i,02]
		SX1->X1_PERGUNT := aRegs[i,03]
		SX1->X1_VARIAVL := aRegs[i,04]
		SX1->X1_TIPO    := aRegs[i,05]
		SX1->X1_TAMANHO := aRegs[i,06]
		SX1->X1_DECIMAL := aRegs[i,07]
		SX1->X1_PRESEL  := aRegs[i,08]
		SX1->X1_GSC     := aRegs[i,09]
		SX1->X1_VALID   := aRegs[i,10]
		SX1->X1_VAR01   := aRegs[i,11]
		SX1->X1_DEF01   := aRegs[i,12]
		SX1->X1_CNT01   := aRegs[i,13]
		SX1->X1_VAR02   := aRegs[i,14]
		SX1->X1_DEF02   := aRegs[i,15]
		SX1->X1_CNT02   := aRegs[i,16]
		SX1->X1_VAR03   := aRegs[i,17]
		SX1->X1_DEF03   := aRegs[i,18]
		SX1->X1_CNT03   := aRegs[i,19]
		SX1->X1_VAR04   := aRegs[i,20]
		SX1->X1_DEF04   := aRegs[i,21]
		SX1->X1_CNT04   := aRegs[i,22]
		SX1->X1_VAR05   := aRegs[i,23]
		SX1->X1_DEF05   := aRegs[i,24]
		SX1->X1_CNT05   := aRegs[i,25]
		SX1->X1_F3      := aRegs[i,26]    
		SX1->X1_VALID	:= aRegs[i,27]
		MsUnlock()
		DbCommit()
	Endif
Next

RestArea(_aArea)

Return()

		