#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ JobFinan   บAutor  ณ Luiz Alberto   บ Data ณ  Nov/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Job Departamento Financeiro, envio de aviso de titulos a
				a vencer e vencidos
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function JobCarga(dData,lAtuCap)
Local aArea    := GetArea()
Local aEmpresa := {{'01','01'}}

DEFAULT dData := CtoD('')           
DEFAULT lAtuCap := .F.

// Verifica se ja existe Historico Lancamento Anterior, Se Sim Guarda a Data para ser processada,
// pois o vendedor podera mudar a data da entrega do material, e com isso eu nao saberia
// qual era a data anterior para reprocessar e tirar a quantidade desse produto nesse dia.

If Empty(dData)
	For nI := 1 To Len(aEmpresa)
		If !(Select("SX2")<>0)
			RpcSetType( 3 )
			RpcSetEnv( aEmpresa[nI,1], aEmpresa[nI,2] )
		Endif
			
		Processa( {|| RunProc(dData,lAtuCap) } )			
		
		If !(Select("SX2")<>0)
			RpcClearEnv()
		Endif
	Next
Else
	Processa( {|| RunProc(dData,lAtuCap) } )			
Endif
RestArea(aArea)
Return .T.
   	 
Static Function RunProc(dData,lAtuCap)
Local aArea := GetArea()     

DEFAULT dData := CtoD('')
DEFAULT lAtuCap	:=	.F.

ConOut(OemToAnsi("Inํcio Job Carga Fabrica " + Dtoc(date()) +" - " + Time()))
                                      
If cEmpAnt <> '01'
	Return .F.
Endif

dDataIni := CtoD('01/08/2019') //Date()
dDataFim := Date()

If !Empty(dData)
	dDataIni := dData
	dDataFim := dData+5
Endif	

If lAtuCap	// Atualiza Capacidade dos Grupos Que Tiveram Alteracao na Quantidade
	SBM->(dbGoTop())
	While SBM->(!Eof())
		If SZH->(dbSetOrder(2), dbSeek(xFilial("SZH")+SBM->BM_GRUPO))
			While SZH->(!Eof()) .And. SZH->ZH_GRUPO == SBM->BM_GRUPO
				If SBM->BM_CAPDIA <> SZH->ZH_CAPGRP
					If RecLock("SZH",.F.)                                    
						SZH->ZH_CAPGRP	:=	SBM->BM_CAPDIA
						SZH->(MsUnlock())
					Endif
				Endif
				SZH->(dbSkip(1))
			Enddo
		Endif
		SBM->(dbSkip(1))
	Enddo	

	_cQuery := "UPDATE "+RetSqlName("SZH") + " SET ZH_SLDGRP = (ZH_CAPGRP - (ZH_GRPUSO + ZH_GRPAPR)) WHERE D_E_L_E_T_ = '' "
				
	_nRetSql := tcsqlexec(_cQuery)

Endif	

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


// QUANTIDADE A SER PRODUZIDA


If SZH->(dbSetOrder(1), dbSeek(xFilial("SZH")+DtoS(dDataIni),.t.))
	While SZH->(!Eof()) .And. SZH->ZH_DATA <= dDataFim
	
		cGrupo := SZH->ZH_GRUPO
	
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
			cQuery+=  AllTrim(cGrupo)+'9' + "')   " +CRLF
		Endif
		cQuery+= " AND C6_ENTREG = '" + DtoS(SZH->ZH_DATA) + "'    " +CRLF   
		cQuery+= " AND C6_NUMOP = '' AND C6_DATFAT = ''    " +CRLF   
		
		MemoWrite('C:\Qry\GERAPV.txt',cQuery)
		
		DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSC6", .F., .T. )
		  
		If RecLock("SZH",.F.)                                    
			SZH->ZH_GRPAPR	:=	TMPSC6->QTDPROD
			SZH->ZH_SLDGRP	:=	(SZH->ZH_CAPGRP - SZH->ZH_GRPAPR)
			SZH->(MsUnlock())
		Endif
		
		TMPSC6->(dbCloseArea())
	
		SZH->(dbSkip(1))
	Enddo
Endif

// QUANTIDADE EM PRODUCAO

If SZH->(dbSetOrder(1), dbSeek(xFilial("SZH")+DtoS(dDataIni),.t.))
	While SZH->(!Eof()) .And. SZH->ZH_DATA <= dDataFim
	
		cGrupo	:=	SZH->ZH_GRUPO
		
		If SZH->ZH_DATA < Date()
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
		If SZH->ZH_DATA < Date()
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
			cQuery+=  AllTrim(cGrupo)+'9' + "')   " +CRLF
		Endif
		If SZH->ZH_DATA >= Date()
			cQuery+= " AND NOT (C2_TPOP = 'F' AND C2_DATRF <> '' AND (C2_QUJE < C2_QUANT OR C2_QUJE >= C2_QUANT)) " +CRLF                            
		Endif
		cQuery+= " AND C2_DATPRF = '" + DtoS(SZH->ZH_DATA) + "'    " +CRLF   
		
		DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSC6", .F., .T. )
		  
		If RecLock("SZH",.F.)                                    
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

RestArea(aArea)
Return .T.





