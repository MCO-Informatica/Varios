/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDA100F  ºAutor  ³NBC                 º Data ³  17/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada do final da geraçao da Ordem de Separacaoº±±
±±º          ³  Utilzado para gerar a ord sep complementar da fraçao      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACDA100F()
Local aArea   := GetArea()                                                        
Local aAreaCB8:= CB8->(GetArea())
Local lCB8    := .F.
Local cOrdSep := ""
Local cOP     := CB7->CB7_OP
Local cArm    := CB7->CB7_LOCAL
Local cCodOpe := CB7->CB7_CODOPE
Local cQryZT1 := getNextAlias()
local cQryZT2 := getNextAlias()
Local cTipExp := "00*08*"  //Separacao


//Esta posicionado na CB7

//Verificar se existem itens fracionados para criar ord sep pre-separaçao

cOrdSepI := CB7->CB7_ORDSEP
// CRIAÇÃO DA OS FRACIONADA INTEIRA

cQry1 := "	SELECT * FROM " + RetSqlName("SZT") + " SZT "
cQry1 += "	WHERE   "
cQry1 += "	ZT_QTDDIF<>0 AND ZT_QTDB01<>0 AND  "
cQry1 += "	ZT_ORDSEP = '" + cOrdSepI + "' AND   "    
cQry1 += "	SZT.D_E_L_E_T_ <> '*'  "


dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry1 ) , cQryZT1, .F., .T. )

If !(cQryZT1)->(Eof())
	
	CB7->(DbSetOrder(5))
	cOrdSep   := GetSX8Num( "CB7", "CB7_ORDSEP" )
	
	Begin Transaction
	
	While !(cQryZT1)->(Eof())
		
		
		CB8->(RecLock( "CB8", .T. ))
		CB8->CB8_FILIAL := xFilial( "CB8" )
		CB8->CB8_ORDSEP := cOrdSep
		CB8->CB8_OP     := cOP
		CB8->CB8_ITEM   := (cQryZT1)->ZT_ITEM
		CB8->CB8_PROD   := (cQryZT1)->ZT_PROD
		CB8->CB8_LOCAL  := (cQryZT1)->ZT_LOCAL
		CB8->CB8_QTDORI := (cQryZT1)->ZT_QTDB01
		CB8->CB8_SALDOS := (cQryZT1)->ZT_QTDB01
		CB8->CB8_LCALIZ := (cQryZT1)->ZT_LCALIZ //Space(15)
		CB8->CB8_SEQUEN := ""
		CB8->CB8_LOTECT := (cQryZT1)->ZT_LOTECTL
		CB8->CB8_NUMLOT := " "
		CB8->CB8_CFLOTE := "1"
		CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
		lCB8  := .T.
		CB8->(MsUnLock())
		(cQryZT1)->(DbSkip())
		
	Enddo
	
   		DbSelectArea("SZT")
		DbSetOrder(1) //ZT_FILIAL+ZT_ORDSEP+ZT_ITEM+ZT_PROD+ZT_LOCAL+ZT_LOTECTL
		If SZT->(DbSeek(xFilial("SZT")+cOrdSepI))
        
		While !SZT->(Eof()) .AND. xFilial("SZT")+cOrdSepI == SZT->(ZT_FILIAL+ZT_ORDSEP)
		//Gravar referencia
		RecLock("SZT", .F.)
		SZT->ZT_ORDSEP2 := cOrdSep
		SZT->(MsUnlock())
		
		SZT->(DbSkip())
		Enddo
	
	    Endif
	
	
	If lCB8
		
		CB7->(DbSetOrder(1))
		CB7->(RecLock( "CB7", .T. ))
		CB7->CB7_FILIAL := xFilial( "CB7" )
		CB7->CB7_ORDSEP := cOrdSep
		CB7->CB7_OP     := cOP
		CB7->CB7_LOCAL  := cArm
		CB7->CB7_DTEMIS := dDataBase
		CB7->CB7_HREMIS := Time()
		CB7->CB7_STATUS := "0"   // gravar STATUS de nao iniciada somente depois do processo
		CB7->CB7_CODOPE := cCodOpe
		CB7->CB7_PRIORI := "1"
		CB7->CB7_ORIGEM := "3"
		CB7->CB7_TIPEXP := cTipExp
		CB7->CB7_TIPSEP := "3"
		CB7->CB7_INTDEC := "INT"
		
		ConfirmSX8()
	
	    	
		aAdd(aLogOS,{"1","OP",CB7->CB7_OP,"",CB7->CB7_LOCAL ,"",CB7->CB7_ORDSEP + If("09*" $ cTipExp,"-PRE-SEPARAÇAO","-FRACIONADA-PESAGEM" )})
		
	EndIf
	
	End Transaction
	
Endif

// CRIAÇÃO DA OS FRACIONADA DECIMAL

cQry2 := "	SELECT * FROM " + RetSqlName("SZT") + " SZT "
cQry2 += "	WHERE   "
cQry2 += "	ZT_QTDDIF<>0 AND ZT_QTDB02<>0 AND  "
cQry2 += "	ZT_ORDSEP = '" + cOrdSepI + "' AND   "  
cQry2 += "	SZT.D_E_L_E_T_ <> '*'  "


dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry2 ) , cQryZT2, .F., .T. )

If !(cQryZT2)->(Eof())
	
	CB7->(DbSetOrder(5))
	cOrdSep   := GetSX8Num( "CB7", "CB7_ORDSEP" )
	
	Begin Transaction
	
	While !(cQryZT2)->(Eof())
		
		
		CB8->(RecLock( "CB8", .T. ))
		CB8->CB8_FILIAL := xFilial( "CB8" )
		CB8->CB8_ORDSEP := cOrdSep
		CB8->CB8_OP     := cOP
		CB8->CB8_ITEM   := (cQryZT2)->ZT_ITEM
		CB8->CB8_PROD   := (cQryZT2)->ZT_PROD
		CB8->CB8_LOCAL  := (cQryZT2)->ZT_LOCAL
		CB8->CB8_QTDORI := (cQryZT2)->ZT_QTDB02
		CB8->CB8_SALDOS := (cQryZT2)->ZT_QTDB02
		CB8->CB8_LCALIZ := (cQryZT1)->ZT_LCALIZ  //Space(15) Ajustado por Zanni em 03/02/2021
		CB8->CB8_SEQUEN := ""
		CB8->CB8_LOTECT := (cQryZT2)->ZT_LOTECTL
		CB8->CB8_NUMLOT := " "
		CB8->CB8_CFLOTE := "1"
		CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
		lCB8  := .T.
		CB8->(MsUnLock())
		
		(cQryZT2)->(DbSkip())
		
	Enddo
	
		
		DbSelectArea("SZT")
		DbSetOrder(1) //ZT_FILIAL+ZT_ORDSEP+ZT_ITEM+ZT_PROD+ZT_LOCAL+ZT_LOTECTL
		If SZT->(DbSeek(xFilial("SZT")+cOrdSepI))
        
		While !SZT->(Eof()) .AND. xFilial("SZT")+cOrdSepI == SZT->(ZT_FILIAL+ZT_ORDSEP)
		//Gravar referencia
		RecLock("SZT", .F.)
		SZT->ZT_ORDSEP4 := cOrdSep
		SZT->(MsUnlock())
		
		SZT->(DbSkip())
		Enddo
		
		Endif
	
	
	
	If lCB8
		
		CB7->(DbSetOrder(1))
		CB7->(RecLock( "CB7", .T. ))
		CB7->CB7_FILIAL := xFilial( "CB7" )
		CB7->CB7_ORDSEP := cOrdSep
		CB7->CB7_OP     := cOP
		CB7->CB7_LOCAL  := cArm
		CB7->CB7_DTEMIS := dDataBase
		CB7->CB7_HREMIS := Time()
		CB7->CB7_STATUS := "0"   // gravar STATUS de nao iniciada somente depois do processo
		CB7->CB7_CODOPE := cCodOpe
		CB7->CB7_PRIORI := "1"
		CB7->CB7_ORIGEM := "3"
		CB7->CB7_TIPEXP := cTipExp
		CB7->CB7_TIPSEP  := "3" 
		CB7->CB7_INTDEC := "DEC"
		
		ConfirmSX8()
		

		aAdd(aLogOS,{"1","OP",CB7->CB7_OP,"",CB7->CB7_LOCAL ,"",CB7->CB7_ORDSEP + If("09*" $ cTipExp,"-PRE-SEPARAÇAO","-FRACIONADA-PESAGEM" )})
		
	EndIf
	

	End Transaction
	
Endif		

	
RestArea(aArea)
RestArea(aAreaCB8)

Return
