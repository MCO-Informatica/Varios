#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: MT116AGR | Autor: Celso Ferrone Martins   | Data: 04/02/2015 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | PE para incluir o pedido de venda referente a CTE          |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function MT116AGR()

If Inclui
	CfmInZ11()
Else
	CfmExZ11()
EndIf

Return()

/*
============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+------------------------------+------------------+||
||| Programa: CfmInZ11 | Autor: Celso Ferrone Martins | Data: 04/02/2015 |||
||+-----------+--------+------------------------------+------------------+||
||| Descricao | PE para incluir o pedido de venda referente a CTE        |||
||+-----------+----------------------------------------------------------+||
||| Alteracao |                                                          |||
||+-----------+----------------------------------------------------------+||
||| Uso       |                                                          |||
||+-----------+----------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
============================================================================
*/
Static Function CfmInZ11()

Local aParamBox	:= {}
Local aRet		:= {}    
Local aSF8ToZ11 := {}
Local lRet      := .T.
Local cEof      := Chr(13)+Chr(10)
Local aAreaSf1  := SF1->(GetArea())
//Local aAreaSf8  := SF8->(GetArea())
Local aAreaSc5  := SC5->(GetArea())
Local lRetSf8   := .T.
Local lRetCte   := .F.
Local cF2Trans  := ""
Local nF2VqVal  := 0

cQuery := " SELECT SF8.F8_NFORIG, SF8.F8_SERORIG, SF8.F8_FORNECE,  SF8.F8_LOJA, SF8.F8_TIPO, SF8.F8_DTDIGIT "
cQuery += " FROM " + RetSqlName("SF8") + " SF8 "
cQuery += " WHERE "
cQuery += "    SF8.D_E_L_E_T_ <> '*' "
cQuery += "    AND F8_FILIAL   = '"+xFilial("SF8")+"' "
cQuery += "    AND F8_NFDIFRE  = '"+cNFiscal+"' "
cQuery += "    AND F8_SEDIFRE  = '"+cSerie+"' "
cQuery += "    AND F8_TRANSP   = '"+cA100For+"' "
cQuery += "    AND F8_LOJTRAN  = '"+cLoja+"' "    

cQuery := ChangeQuery(cQuery)

If Select("TMPSF8") > 0
	TMPSF8->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPSF8"      

While !TMPSF8->(Eof())
	If ASCAN(aSF8ToZ11, {|X| AllTrim(X[1]+X[2]) == AllTrim(TMPSF8->(F8_NFORIG+F8_NFORIG))}) == 0 
		Aadd(aSF8ToZ11, {TMPSF8->F8_NFORIG,TMPSF8->F8_SERORIG,TMPSF8->F8_FORNECE,TMPSF8->F8_LOJA,TMPSF8->F8_TIPO,TMPSF8->F8_DTDIGIT})
	EndIf
	TMPSF8->(DbSkip())
EndDo

If Len(aSF8ToZ11) < 1
	lRetSf8 := .F.
EndIf     

If Select("TMPSF8") > 0
	TMPSF8->(DbCloseArea())
EndIf

If lRetSf8
	If MsgYesNo("Esse CTE esta relacionado a um pedido de vendas?","CTE Pedido de venda.")
		lRetCte := .T.
	EndIf
EndIf

If lRetCte

	aAdd(aParamBox,{1,"Pedido de Venda",Space(TamSX3("C5_NUM")[1]) ,PesqPict("SC5","C5_NUM"),"U_CfmZ11Vl()","SC5","",TamSX3("C5_NUM")[1],.T.})
	
	If ParamBox(aParamBox,"Pedido de Venda",@aRet)
		
		lRet := .T.
		
		DbSelectArea("Z11") ; DbSetOrder(1)
		DbSelectArea("SF1") ; DbSetOrder(1)
		DbSelectArea("SC5") ; DbSetOrder(1)

		If SC5->(DbSeek(xFilial("SC5")+aRet[1]))

			If SF1->(DbSeek(xFilial("SF1")+SF8->(F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA)))
				
				nValOrig := SF1->F1_VALBRUT
				nIcmOrig := SF1->F1_VALICM
				nIssOrig := SF1->F1_ISS
//				cPlaca   := SF1->F1_PLACA
				
				cQuery := " SELECT * FROM " + RetSqlName("SF1") + " SF1 "
				cQuery += " WHERE "
				cQuery += "    SF1.D_E_L_E_T_ <> '*' "
				cQuery += "    AND F1_FILIAL = '"+xFilial("SF1")+"' "
				cQuery += "    AND F1_DOC     = '"+cNFiscal+"' "
				cQuery += "    AND F1_SERIE   = '"+cSerie+"' "
				cQuery += "    AND F1_FORNECE = '"+cA100For+"' "
				cQuery += "    AND F1_LOJA    = '"+cLoja+"' "
				
				cQuery := ChangeQuery(cQuery)
				
				If Select("TMPSF1") > 0
					TMPSF1->(DbCloseArea())
				EndIf
				
				TcQuery cQuery New Alias "TMPSF1"
				
				If !TMPSF1->(Eof())
					nValBrut := TMPSF1->F1_VALBRUT
					nValIcms := TMPSF1->F1_VALICM
					nValIss  := TMPSF1->F1_ISS
				Else
					nValBrut := 0
					nValIcms := 0
					nValIss  := 0
				EndIf
				
				If Select("TMPSF1") > 0
					TMPSF1->(DbCloseArea())
				EndIf

				cQuery := " SELECT * FROM " + RetSqlName("SF2") + " SF2 "
				cQuery += "    INNER JOIN " + RetSqlName("SD2") + " SD2 ON "
				cQuery += "       SD2.D_E_L_E_T_ <> '*' "
				cQuery += "       AND D2_FILIAL = '"+xFilial("SD2")+"' "
				cQuery += "       AND D2_DOC    = F2_DOC "
				cQuery += "       AND D2_SERIE  = F2_SERIE "
				cQuery += "       AND D2_PEDIDO = '"+SC5->C5_NUM+"' "
				cQuery += " WHERE "
				cQuery += "    SF2.D_E_L_E_T_ <> '*' "
				cQuery += "    AND F2_FILIAL = '"+xFilial("SF2")+"' "
				
				cQuery := ChangeQuery(cQuery)

				If Select("TMPSF2") > 0
					TMPSF2->(DbCloseArea())
				EndIf
				
				TcQuery cQuery New Alias "TMPSF2"
				
				cF2Trans := ""
				nF2VqVal := 0

				If !TMPSF2->(Eof())
					cF2Trans := TMPSF2->F2_TRANSP  			// 07 - F2_TRANSP
					nF2VqVal := TMPSF2->F2_VQ_FVAL			// 09 - F2_VQ_FVAL
				EndIf

				If Select("TMPSF2") > 0
					TMPSF2->(DbCloseArea())
				EndIf
				     
				For nX := 1 To Len(aSF8ToZ11)  
					RecLock("Z11",.T.)
					Z11->Z11_FILIAL := xFilial("Z11")
					Z11->Z11_DOC    := cNFiscal			// Numero CTE					// SF8->F8_NFDIFRE	// NF Importacäo / Frete
					Z11->Z11_SERIE  := cSerie			// Serie CTE					// SF8->F8_SEDIFRE	// Serie da NF Importa/Frete
					Z11->Z11_CLIFOR := cA100For			// Fornec. CTE					// SF8->F8_TRANSP 	// Codigo da Transportadora
					Z11->Z11_LOJA   := cLoja			// Loja CTE						// SF8->F8_LOJTRAN	// Loja da Transportadora
					Z11->Z11_TIPO   := cTipo			// Tipo CTE
					Z11->Z11_EMISSA := dDemissao		// Emissao CTE
	//				Z11->Z11_PLACA  := cPlaca			// Placa
	
					Z11->Z11_VALOR  := nValBrut			// Valor CTE
					Z11->Z11_ICMS   := nValIcms			// Valor Icms CTE
					Z11->Z11_ISS    := nValIss			// Valor Iss CTE
					
					Z11->Z11_NUMPV  := aRet[1]			// Numero Pedido de Vendas
					
					Z11->Z11_DOCORI := aSF8ToZ11[nX][1]//SF8->F8_NFORIG	// Nota Fiscal Original			// SF8->F8_NFORIG
					Z11->Z11_SERORI := aSF8ToZ11[nX][2]//SF8->F8_SERORIG	// Serie da NF Original			// SF8->F8_SERORIG
					Z11->Z11_CLFORI := aSF8ToZ11[nX][3]//SF8->F8_FORNECE	// Fornecedor da NF				// SF8->F8_FORNECE
					Z11->Z11_LOJORI := aSF8ToZ11[nX][4]//SF8->F8_LOJA		// Loja do Fornecedor  			// SF8->F8_LOJA
					Z11->Z11_TIPORI := aSF8ToZ11[nX][5]//SF8->F8_TIPO		// Tipo da Nota (Frete/Imp.)	// SF8->F8_TIPO
					Z11->Z11_EMIORI := StoD(aSF8ToZ11[nX][6])//SF8->F8_DTDIGIT	// Data de Digitacao			// SF8->F8_DTDIGIT
					
					Z11->Z11_VALORI := nValOrig
					Z11->Z11_ICMORI := nIcmOrig
					Z11->Z11_ISSORI := nIssOrig
					
					Z11->Z11_COMPLE := "E"
	
					Z11->Z11_TRANSP := cF2Trans
					Z11->Z11_FRETE  := nF2VqVal
	
					MsUnLock()
			  Next		
			EndIF
		EndIF
		
		SC5->(RestArea(aAreaSc5))
		SF1->(RestArea(aAreaSf1))
				
	Else
		lRet := .F.
	EndIf
EndIf

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmExZ11  | Autor: Celso Ferrone Martins  | Data: 12/02/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmExZ11()

DbSelectArea("Z11") ; DbSetOrder(1)
If Z11->(DbSeek(xFilial("Z11")+cNFiscal+cSerie+cA100For+cLoja))
	While !Z11->(Eof()) .And. Z11->(Z11_FILIAL+Z11_DOC+Z11_SERIE+Z11_CLIFOR+Z11_LOJA) == xFilial("Z11")+cNFiscal+cSerie+cA100For+cLoja
		RecLock("Z11",.F.)
		DbDelete()
		MsUnLock()
		Z11->(DbSkip())
	EndDo
EndIf

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmZ11Vl  | Autor: Celso Ferrone Martins  | Data: 12/02/2015 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Validacao ParamBox                                         |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmZ11Vl()

Local lRet := .T.

DbSelectArea("SC5") ; DbSetOrder(1)
If !SC5->(DbSeek(xFilial("SC5")+MV_PAR01))
	lRet := .F.
	MsgAlert("Pedido de Vendas nao encontrado. Favor verificar.","Nao encontrado!!")
EndIf

Return(lRet)