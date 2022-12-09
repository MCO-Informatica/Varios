#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JobFinan   ºAutor  ³ Luiz Alberto   º Data ³  Nov/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job Departamento Financeiro, envio de aviso de titulos a
				a vencer e vencidos
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CargaPed(cPedido,cItem,cProduto)
Local aAreaSC2    := SC2->(GetArea())
Local aAreaSC5    := SC5->(GetArea())
Local aAreaSC6    := SC6->(GetArea())
Local aAreaSC9    := SC9->(GetArea())
Local aAreaSB1    := SB1->(GetArea())
Local aEmpresa := {{'01','01'}}

DEFAULT cPedido := ''
DEFAULT cProduto:= ''
DEFAULT cItem   := ''

If cEmpAnt <> '01'
	Return .T.
Endif

// Verifica se ja existe Historico Lancamento Anterior, Se Sim Guarda a Data para ser processada,
// pois o vendedor podera mudar a data da entrega do material, e com isso eu nao saberia
// qual era a data anterior para reprocessar e tirar a quantidade desse produto nesse dia.

// Desativa Log Anterior

Begin Transaction

If SZI->(dbSetOrder(1), dbSeek(xFilial("SZI")+cPedido))
	While SZI->(!Eof()) .And. SZI->ZI_FILIAL == xFilial("SZI") .And. SZI->ZI_PEDIDO == cPedido
		If SZI->ZI_ATIVO == 'S' 
			dDataAnt := SZI->ZI_ENTREGA       
					
			If RecLock("SZI",.F.)
				SZI->ZI_ATIVO	:=	'N'
				SZI->(MsUnlock())
			Endif            
		
			Processa( {|| RunProc(SZI->ZI_GRUPO,dDataAnt) } )			            
		Endif
		
		SZI->(dbSkip(1))
	Enddo	
Endif			
     
// Inclui Log do Pedido

If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+cPedido))
	While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cPedido
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
		
		cGrupo := Iif(!Empty(SB1->B1_XGRUPO),SB1->B1_XGRUPO,SB1->B1_GRUPO)

		nReg := SC6->(Recno())

		Processa( {|| RunProc(cGrupo,SC6->C6_ENTREG) } )			            
		
		SC6->(dbGoTo(nReg))
		
		If RecLock("SZI",.T.)
			SZI->ZI_FILIAL	:=	xFilial("SZI")
			SZI->ZI_PEDIDO	:=	SC6->C6_NUM
			SZI->ZI_GRUPO	:=	cGrupo
			SZI->ZI_ITEM	:=	SC6->C6_ITEM
			SZI->ZI_ENTREGA	:=	SC6->C6_ENTREG
			SZI->ZI_QUANT	:=	SC6->C6_QTDVEN
			SZI->ZI_PRODUTO	:=	SC6->C6_PRODUTO
			SZI->ZI_USUARIO	:=	__cUserId
			SZI->ZI_NOMUSE	:=	AllTrim(UsrRetName(__cUserID))
			SZI->ZI_DTUSER	:=	dDataBase
			SZI->ZI_RECNO	:=	SC6->(Recno())
			SZI->ZI_ATIVO	:=	'S'
			SZI->(MsUnlock())
		Endif
		SC6->(dbSkip(1))
	Enddo
ElseIf SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+cPedido))
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		
	cGrupo := Iif(!Empty(SB1->B1_XGRUPO),SB1->B1_XGRUPO,SB1->B1_GRUPO)

	Processa( {|| RunProc(cGrupo,SC2->C2_DATPRF) } )			            
		
	If RecLock("SZI",.T.)
		SZI->ZI_FILIAL	:=	xFilial("SZI")
		SZI->ZI_PEDIDO	:=	SC2->C2_NUM
		SZI->ZI_GRUPO	:=	cGrupo
		SZI->ZI_ITEM	:=	SC2->C2_ITEM
		SZI->ZI_ENTREGA	:=	SC2->C2_DATPRF
		SZI->ZI_QUANT	:=	SC2->C2_QUANT
		SZI->ZI_PRODUTO	:=	SC2->C2_PRODUTO
		SZI->ZI_USUARIO	:=	__cUserId
		SZI->ZI_NOMUSE	:=	AllTrim(UsrRetName(__cUserID))
		SZI->ZI_DTUSER	:=	dDataBase
		SZI->ZI_RECNO	:=	SC2->(Recno())
		SZI->ZI_ATIVO	:=	'S'
		SZI->(MsUnlock())
	Endif
Endif

End Transaction

RestArea(aAreaSC2)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aAreaSB1)
Return .T.
   	 
Static Function RunProc(cGrupo,dData)
Local aArea := GetArea()

DEFAULT cGrupo:= ''
DEFAULT dData := CtoD('')

If cEmpAnt <> '01'
	Return .F.
Endif

Begin Transaction

dDataIni := dData
dDataFim := dData+1

ProcRegua(dDataFim-dDataIni)
For dDt := dDataIni To dDataFim
	IncProc("Aguarde Ajustando Saldos Carga Fabrica * ...")
	
	SBM->(dbGoTop())
	While SBM->(!Eof())
		If SBM->BM_CAPDIA > 0 
			If !SZH->(dbSetOrder(2), dbSeek(xFilial("SZH")+SBM->BM_GRUPO+DtoS(dDt)))
				If RecLock("SZH",.T.)                                    
					SZH->ZH_FILIAL	:=	xFilial("SZH")
					SZH->ZH_DATA	:=	dDt
					SZH->ZH_GRUPO	:=	SBM->BM_GRUPO
					SZH->ZH_CAPGRP	:=	SBM->BM_CAPDIA
					SZH->(MsUnlock())
				Endif
			Endif
		Endif
		
		SBM->(dbSkip(1))
	Enddo
Next

If Len(AllTrim(cGrupo)) == 4
	
	// QUANTIDADE A SER PRODUZIDA
	
	cQuery:= " SELECT ISNULL(SUM(C6_QTDVEN),0) QTDPROD " +CRLF
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
	cQuery+= " AND BM_GRUPO IN('" + cGrupo + "')   " +CRLF
	cQuery+= " AND C6_ENTREG = '" + DtoS(dDataIni) + "'    " +CRLF   
	cQuery+= " AND C6_NUMOP = ''    " +CRLF   
		
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSC6", .F., .T. )
		  
	If SZH->(dbSetOrder(2), dbSeek(xFilial("SZH")+cGrupo+DtoS(dDataIni)))
		If RecLock("SZH",.F.)                                    
			SZH->ZH_GRPAPR	:=	TMPSC6->QTDPROD
			SZH->ZH_SLDGRP	:=	(SZH->ZH_CAPGRP - SZH->ZH_GRPAPR)
			SZH->(MsUnlock())
		Endif
	Endif
		
	TMPSC6->(dbCloseArea())
Endif

// Atualiza Grupo Raiz
	
	cQuery:= " SELECT ISNULL(SUM(C6_QTDVEN),0) QTDPROD " +CRLF
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
	cQuery+= " AND BM_GRUPO IN('" + Left(cGrupo,3) + "','"+ AllTrim(Left(cGrupo,3))+'1' + "','"
	cQuery+=  AllTrim(Left(cGrupo,3))+'2' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'3' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'4' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'5' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'6' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'7' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'8' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'9' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'0' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'A' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'B' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'C' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'D' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'E' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'F' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'G' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'H' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'I' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'J' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'K' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'L' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'M' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'N' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'O' + "')   " +CRLF
	cQuery+= " AND C6_ENTREG = '" + DtoS(dDataIni) + "'    " +CRLF   
	cQuery+= " AND C6_NUMOP = ''    " +CRLF   
		
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSC6", .F., .T. )
		  
	If SZH->(dbSetOrder(2), dbSeek(xFilial("SZH")+PadR(Left(cGrupo,3),4)+DtoS(dDataIni)))
		If RecLock("SZH",.F.)                                    
			SZH->ZH_GRPAPR	:=	TMPSC6->QTDPROD
			SZH->ZH_SLDGRP	:=	(SZH->ZH_CAPGRP - SZH->ZH_GRPAPR)
			SZH->(MsUnlock())
		Endif
	Endif
		
	TMPSC6->(dbCloseArea())

///

If Len(AllTrim(cGrupo))==4   
	// QUANTIDADE EM PRODUCAO
	
	cQuery:= " SELECT ISNULL(SUM(C2_QUANT - C2_QUJE),0) QTDPROD " +CRLF
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
	CQUERY+= " AND (C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') ) " +CRLF
	cQuery+= " AND BM_GRUPO IN('" + cGrupo + "')   " +CRLF
	cQuery+= " AND NOT (C2_TPOP = 'F' AND C2_DATRF <> '' AND (C2_QUJE < C2_QUANT OR C2_QUJE >= C2_QUANT)) " +CRLF                            
	cQuery+= " AND C2_DATPRF = '" + DtoS(dDataIni) + "'    " +CRLF   
	
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSC6", .F., .T. )
		  
	If SZH->(dbSetOrder(2), dbSeek(xFilial("SZH")+cGrupo+DtoS(dDataIni)))
		If RecLock("SZH",.F.)                                    
			SZH->ZH_GRPUSO	:=	TMPSC6->QTDPROD
			SZH->ZH_SLDGRP	:=	(SZH->ZH_CAPGRP - (SZH->ZH_GRPUSO + SZH->ZH_GRPAPR))
			SZH->(MsUnlock())
		Endif
	Endif	
	
	TMPSC6->(dbCloseArea())
Endif

// Atualiza Grupo Raiz

	// QUANTIDADE EM PRODUCAO
	
	cQuery:= " SELECT ISNULL(SUM(C2_QUANT - C2_QUJE),0) QTDPROD " +CRLF
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
	CQUERY+= " AND (C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') ) " +CRLF
	cQuery+= " AND BM_GRUPO IN('" + Left(cGrupo,3) + "','"+ AllTrim(Left(cGrupo,3))+'1' + "','"
	cQuery+=  AllTrim(Left(cGrupo,3))+'2' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'3' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'4' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'5' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'6' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'7' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'8' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'9' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'0' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'A' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'B' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'C' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'D' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'E' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'F' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'G' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'H' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'I' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'J' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'K' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'L' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'M' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'N' + "','" 
	cQuery+=  AllTrim(Left(cGrupo,3))+'O' + "')   " +CRLF
	cQuery+= " AND NOT (C2_TPOP = 'F' AND C2_DATRF <> '' AND (C2_QUJE < C2_QUANT OR C2_QUJE >= C2_QUANT)) " +CRLF                            
	cQuery+= " AND C2_DATPRF = '" + DtoS(dDataIni) + "'    " +CRLF   
	
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSC6", .F., .T. )
		  
	If SZH->(dbSetOrder(2), dbSeek(xFilial("SZH")+PadR(Left(cGrupo,3),4)+DtoS(dDataIni)))
		If RecLock("SZH",.F.)                                    
			SZH->ZH_GRPUSO	:=	TMPSC6->QTDPROD
			SZH->ZH_SLDGRP	:=	(SZH->ZH_CAPGRP - (SZH->ZH_GRPUSO + SZH->ZH_GRPAPR))
			SZH->(MsUnlock())
		Endif
	Endif	
	
	TMPSC6->(dbCloseArea())

End Transaction

///
/*_cQuery := "UPDATE "+RetSqlName("SZH") + " SET ZH_SLDGRP = (ZH_CAPGRP - (ZH_GRPUSO + ZH_GRPAPR)) WHERE D_E_L_E_T_ = '' "
			
_nRetSql := tcsqlexec(_cQuery)*/

RestArea(aArea)
Return
