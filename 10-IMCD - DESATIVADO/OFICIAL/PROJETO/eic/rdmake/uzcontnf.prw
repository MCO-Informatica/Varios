#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH" 
#INCLUDE "TOPCONN.CH" 

//+-----------------------------------------------------------------------------------//
//|Empresa...: Makeni
//|Funcao....: UZContNF
//|Autor.....: Armando M. Urzum - armando@urzum.com.br
//|Data......: 11 de Janeiro de 2010, 08:00
//|Uso.......: Nota Fiscal de Entrada - SIGACOM / SIGAEST
//|Versao....: Protheus - 10   
//|Descricao.: Função para retorno de valores para contabilização de importação
//|			   na classificação da NF no Compras
//|Observação: 
//|Parametros: xLoc  - Local de onde irá buscar o valor
//|						"ITEM"...: Para buscar apenas valor do item
//|						"NF".....: Para buscar o valor total de todos os itens da NF
//|
//|			   cTipo - Tipo de valor a ser retornado
//|						"FOB"....: Retorna o Fob limpo da nota sem frete ou de acordo com o Incoterm
//|						"FRETE"..: Retorna o Frete da Nota
//|						"SEGURO".: Retorna o seguro da Nota
//|						"CIF"....: Retorna o CIF da nota
//|						"II".....: Retorna o II da nota
//|						"IPI"....: Retorna o IPI da nota
//|						"PIS"....: Retorna o PIS da nota
//|						"COFINS".: Retorna o COFINS da nota
//|						"ICMS"...: Retorna o ICMS
//|						"DESPESA": Retorna o despesas acessorias da nota
//|					    "GERAL_SEM_FOB": Todas as despesas menos o Fob
//------------------------------------------------------------------------------------//
*----------------------------------------------*
User Function UZContNF(xLoc,cTipo)
	*----------------------------------------------*

	Local cSql := ""
	Local nFOB:=0, nII:=0, nIPI:=0, nPIS:=0, nCOF:=0, nICMS:=0, nDesp:=0, nCIF:=0, nInv:=0, nFrete:=0, nSeg:=0, nTotGer:=0,nSisc:=0,nOutDesp:=0,nDespAdu:=0, nReturn := 0,nFRMM := 0, nDespimp := 0
	local cDespSisco := '415'
	local cAFRMM     := '405'
	local cDESPIMP   := '418'
	local cCustCompl := ""
	local cDESPORI   := ""
	local nCustCompl := 0
	local nDespOri   := 0
	local cImpI      := 0
	local cDespSCont := ""
	local nDespSCont := 0
	local cPisDesp   := ""
	local cCofinsDesp := ""
	local aAreasDoc   := {}


	aAreasDoc := {SF1->(getArea(), SD1->(getArea()))}
	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "UZContNF" , __cUserID )
	
	if (cFilant $ "05/06") .and. cEmpAnt == '01'

	   cDespSisco := '408'
	   cAFRMM     := '401'
	   cDESPIMP   := '418'
	   cCustCompl := "'402','405','409','404','418','411','412','414','419','403','415'"
	   cDESPORI   := '417'
	   cImpI      := '201'
	   cPisDesp       := '203'
	   cCofinsDesp    := '204'
    Endif   
    
    if cFilant =="02" .and. cEmpAnt == '01'
	   cCustCompl := "'413'"
	   cDespSCont := '486'
	endif 

    if cEmpAnt == '02'
	   cDespSCont := '422'
	endif 

	If xLoc == "ITEM"

		cSql := ""
		cSql += " SELECT WN.WN_HAWB, WN.WN_INVOICE, W8.W8_INLAND, W8.W8_OUTDESP, W8.W8_PACKING, W8.W8_FRETEIN, W8.W8_DESCONT "
		cSql += " 	  ,W9.W9_INCOTER, W9.W9_TX_FOB, W9_FREINC "
		cSql += "     ,(W8.W8_INLAND+W8.W8_OUTDESP+W8.W8_PACKING+W8.W8_FRETEIN-W8.W8_DESCONT) AS DESINV "
		cSql += "     , WN.WN_FOB_R AS FOB "
		cSql += "     , WN.WN_FRETE AS FRETE "
		cSql += "     , WN.WN_SEGURO AS SEGURO "
		cSql += "     , (WN.WN_PRUNI*WN.WN_QUANT) AS PRECO1 "
		cSql += "     , (WN.WN_PRECO*WN.WN_QUANT) AS PRECO2 "
		cSql += "     , WN.WN_IIVAL AS II "
		cSql += "     , WN.WN_IPIVAL AS IPI "
		cSql += "     , WN.WN_VLRPIS AS PIS "
		cSql += "     , WN.WN_VLRCOF AS COFINS "
		cSql += "     , WN.WN_VALICM AS ICMS "
		cSql += "     , WN.WN_DESPESA AS DESPESA "  
		cSql += "     , WN.WN_DESPADU AS DESPADU "  	
		cSql += " FROM "+RETSQLNAME("SWN")+" WN ,"+RETSQLNAME("SW8")+" W8 ,"+RETSQLNAME("SW9")+" W9 "
		cSql += " WHERE WN.WN_FILIAL = '"+xFilial("SWN")+"' AND WN.D_E_L_E_T_ = ' ' "
		cSql += " 	  AND W8.W8_FILIAL = '"+xFilial("SW8")+"' AND W8.D_E_L_E_T_ = ' ' "
		cSql += " 	  AND W9.W9_FILIAL = '"+xFilial("SW9")+"' AND W9.D_E_L_E_T_ = ' ' "
		cSql += " 	  AND WN.WN_HAWB = '"+SF1->F1_HAWB+"' AND WN.WN_DOC = '"+SD1->D1_DOC+"' AND WN.WN_SERIE = '"+SD1->D1_SERIE+"' "
		cSql += "     AND WN.WN_FORNECE = '"+SD1->D1_FORNECE+"' AND WN.WN_ITEM = '"+SD1->D1_ITEM+"' AND WN.WN_PO_NUM = '"+SD1->D1_PEDIDO+"' "
		cSql += "     AND W8.W8_PGI_NUM = WN.WN_PGI_NUM AND W8.W8_PO_NUM = WN.WN_PO_EIC AND W8.W8_HAWB = WN.WN_HAWB "
		cSql += "     AND W8.W8_COD_I = WN.WN_PRODUTO AND W8.W8_INVOICE = WN.WN_INVOICE "
		cSql += "     AND W9.W9_HAWB = WN.WN_HAWB AND W9.W9_INVOICE = WN.WN_INVOICE  "
	ElseIf xLoc == "NF" 
		cSql := ""
		cSql += " SELECT WN.WN_HAWB, WN.WN_INVOICE, W9.W9_FREINC, W9.W9_FRETEIN, W9.W9_INCOTER, W9.W9_TX_FOB "
		cSql += "     ,(W9.W9_INLAND+W9.W9_PACKING+W9.W9_OUTDESP-W9.W9_DESCONT) AS DESINV "
		cSql += "     , SUM(WN.WN_FOB_R) AS FOB "
		cSql += "     , SUM(WN.WN_FRETE) AS FRETE "
		cSql += "     , SUM(WN.WN_SEGURO) AS SEGURO "
		cSql += "     , SUM(WN.WN_PRUNI*WN.WN_QUANT) AS PRECO1 "
		cSql += "     , SUM(WN.WN_PRECO*WN.WN_QUANT) AS PRECO2 "
		cSql += "     , SUM(WN.WN_IIVAL) AS II "
		cSql += "     , SUM(WN.WN_IPIVAL) AS IPI "
		cSql += "     , SUM(WN.WN_VLRPIS) AS PIS "
		cSql += "     , SUM(WN.WN_VLRCOF) AS COFINS "
		cSql += "     , SUM(WN.WN_VALICM) AS ICMS "
		cSql += "     , SUM(WN.WN_DESPESA) AS DESPESA " 
		cSql += "     , SUM(WN.WN_DESPADU) AS DESPADU " 
		cSql += "     , SUM(WN.WN_OUT_DES) AS OUTDESP "
		cSql += "     , (SELECT SUM(WD_VALOR_R) FROM "+RETSQLNAME("SWD")+" A WHERE A.WD_FILIAL = '"+xfilial("SWD")+"' AND A.D_E_L_E_T_ = ' ' AND A.WD_HAWB = '"+SF1->F1_HAWB+"' AND A.WD_NF_COMP = '"+SF1->F1_DOC+"' AND A.WD_DESPESA = '"+cDespSisco+"'  AND A.WD_SE_NFC = '"+SF1->F1_SERIE+"') AS SISCOMEX "
		cSql += "     , (SELECT SUM(WD_VALOR_R) FROM "+RETSQLNAME("SWD")+" A WHERE A.WD_FILIAL = '"+xfilial("SWD")+"' AND A.D_E_L_E_T_ = ' ' AND A.WD_HAWB = '"+SF1->F1_HAWB+"' AND A.WD_NF_COMP = '"+SF1->F1_DOC+"' AND A.WD_DESPESA = '"+cAFRMM+"'  AND A.WD_SE_NFC = '"+SF1->F1_SERIE+"') AS AFRMM "
		cSql += "     , (SELECT SUM(WD_VALOR_R) FROM "+RETSQLNAME("SWD")+" A WHERE A.WD_FILIAL = '"+xfilial("SWD")+"' AND A.D_E_L_E_T_ = ' ' AND A.WD_HAWB = '"+SF1->F1_HAWB+"' AND A.WD_NF_COMP = '"+SF1->F1_DOC+"' AND A.WD_DESPESA = '"+cDespImp+"'  AND A.WD_SE_NFC = '"+SF1->F1_SERIE+"') AS DESPIMP "
		
		if !empty(cImpI)
		    cSql += "     , (SELECT SUM(WD_VALOR_R) FROM "+RETSQLNAME("SWD")+" A WHERE A.WD_FILIAL = '"+xfilial("SWD")+"' AND A.D_E_L_E_T_ = ' ' AND A.WD_HAWB = '"+SF1->F1_HAWB+"' AND A.WD_NF_COMP = '"+SF1->F1_DOC+"' AND A.WD_DESPESA = '"+cImpI+"'  AND A.WD_SE_NFC = '"+SF1->F1_SERIE+"') AS IMPI "      
		Endif

		if !empty(cPisDesp) 
		    cSql += "     , (SELECT SUM(WD_VALOR_R) FROM "+RETSQLNAME("SWD")+" A WHERE A.WD_FILIAL = '"+xfilial("SWD")+"' AND A.D_E_L_E_T_ = ' ' AND A.WD_HAWB = '"+SF1->F1_HAWB+"' AND A.WD_NF_COMP = '"+SF1->F1_DOC+"' AND A.WD_DESPESA = '"+cPisDesp+"'  AND A.WD_SE_NFC = '"+SF1->F1_SERIE+"') AS PISDESP "      
		Endif

		if !empty(cCofinsDesp)
		    cSql += "     , (SELECT SUM(WD_VALOR_R) FROM "+RETSQLNAME("SWD")+" A WHERE A.WD_FILIAL = '"+xfilial("SWD")+"' AND A.D_E_L_E_T_ = ' ' AND A.WD_HAWB = '"+SF1->F1_HAWB+"' AND A.WD_NF_COMP = '"+SF1->F1_DOC+"' AND A.WD_DESPESA = '"+cCofinsDesp+"'  AND A.WD_SE_NFC = '"+SF1->F1_SERIE+"') AS COFINSDESP "      
		Endif

		if !empty(cCustCompl)
			cSql += "     , (SELECT SUM(WD_VALOR_R) FROM "+RETSQLNAME("SWD")+" A WHERE A.WD_FILIAL = '"+xfilial("SWD")+"' AND A.D_E_L_E_T_ = ' ' AND A.WD_HAWB = '"+SF1->F1_HAWB+"' AND A.WD_NF_COMP = '"+SF1->F1_DOC+"' AND A.WD_DESPESA IN ("+cCustCompl+") AND A.WD_SE_NFC = '"+SF1->F1_SERIE+"') AS CUSTCOMPL "
		endif
		if !empty(cDESPORI)
			cSql += "     , (SELECT SUM(WD_VALOR_R) FROM "+RETSQLNAME("SWD")+" A WHERE A.WD_FILIAL = '"+xfilial("SWD")+"' AND A.D_E_L_E_T_ = ' ' AND A.WD_HAWB = '"+SF1->F1_HAWB+"' AND A.WD_NF_COMP = '"+SF1->F1_DOC+"' AND A.WD_DESPESA IN ("+cDESPORI+") AND A.WD_SE_NFC = '"+SF1->F1_SERIE+"') AS DESPORI "
		endif
		if !empty(cDespSCont)
			cSql += "     , (SELECT SUM(WD_VALOR_R) FROM "+RETSQLNAME("SWD")+" A WHERE A.WD_FILIAL = '"+xfilial("SWD")+"' AND A.D_E_L_E_T_ = ' ' AND A.WD_HAWB = '"+SF1->F1_HAWB+"' AND A.WD_NF_COMP = '"+SF1->F1_DOC+"' AND A.WD_DESPESA ='"+cDespSCont+"' AND A.WD_SE_NFC = '"+SF1->F1_SERIE+"') AS DESPSCONT "
		endif
			//cSql += "     , SUM(WN.WN_DESPICM) AS SISCOMEX "
		cSql += " FROM "+RETSQLNAME("SWN")+" WN ,"+RETSQLNAME("SW9")+" W9 "
		cSql += " WHERE WN.WN_HAWB = '"+SF1->F1_HAWB+"' AND WN.WN_DOC = '"+SF1->F1_DOC+"' AND WN.WN_SERIE = '"+SF1->F1_SERIE+"'
		cSql += "     AND WN.WN_FORNECE = '"+SF1->F1_FORNECE+"' "
		cSql += "     AND W9.W9_HAWB = WN.WN_HAWB AND W9.W9_INVOICE = WN.WN_INVOICE "
		cSql += " 	  AND WN.WN_FILIAL = '"+xFilial("SWN")+"' AND WN.D_E_L_E_T_ = ' ' "
		cSql += " 	  AND W9.W9_FILIAL = '"+xFilial("SW9")+"' AND W9.D_E_L_E_T_ = ' ' "
		cSql += " GROUP BY WN.WN_HAWB, WN.WN_INVOICE, W9.W9_FREINC, W9.W9_FRETEIN, W9.W9_INCOTER, W9.W9_TX_FOB "
		cSql += "     ,(W9.W9_INLAND+W9.W9_PACKING+W9.W9_OUTDESP-W9.W9_DESCONT) "
	EndIf

	Iif(Select("QRYWN") # 0,QRYWN->(dbCloseArea()),.T.)

	Sd1->(dbsetorder(1))
	sd1->(dbseek(xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE+sf1->f1_fornece+sf1->f1_loja))

	TcQuery cSql New Alias "QRYWN"                               
	TcSetField("QRYWN", "W9_TX_FOB", "N", 15, 8)
	TcSetField("QRYWN", "DESINV"   , "N", 15, 8)
	TcSetField("QRYWN", "FOB"      , "N", 15, 2)
	TcSetField("QRYWN", "FRETE"    , "N", 15, 2)
	TcSetField("QRYWN", "SEGURO"   , "N", 15, 2)
	TcSetField("QRYWN", "PRECO1"   , "N", 18, 8)
	TcSetField("QRYWN", "PRECO2"   , "N", 18, 8)
	TcSetField("QRYWN", "II"       , "N", 15, 2)
	TcSetField("QRYWN", "IPI"      , "N", 15, 2)
	TcSetField("QRYWN", "PIS"      , "N", 15, 2)
	TcSetField("QRYWN", "COFINS"   , "N", 15, 2)
	TcSetField("QRYWN", "ICMS"     , "N", 15, 2)
	TcSetField("QRYWN", "DESPESA"  , "N", 15, 2)
	TcSetField("QRYWN", "OUTDESP"  , "N", 15, 2)
	TcSetField("QRYWN", "DESPADU"  , "N", 15, 2)
	TcSetField("QRYWN", "SISCOMEX" , "N", 15, 2)
	TcSetField("QRYWN", "CUSTCOMPL", "N", 15, 2) //NADIA
	TcSetField("QRYWN", "DESPORI"  , "N", 15, 2) //NADIA
	TcSetField("QRYWN", "IMPI"     , "N", 15, 2) //NADIA
	TcSetField("QRYWN", "COFINSDESP", "N", 15, 2) 
	TcSetField("QRYWN", "PISDESP"  , "N", 15, 2) 
	TcSetField("QRYWN", "DESPSCONT", "N", 15, 2) 

	QRYWN->(dbSelectArea("QRYWN"))
	QRYWN->(dbGoTop())

	If QRYWN->(EOF()) .AND. QRYWN->(BOF())
		QRYWN->(dbCloseArea())
		Return(nReturn)
	EndIf

	If xLoc == "ITEM"

		If QRYWN->W9_FREINC = "2" .AND. QRYWN->W9_INCOTER $ ("CFR,CIP,CIF,CPT,DAF,DES,DDU")
			nFob := (QRYWN->PRECO2-QRYWN->DESINV)*QRYWN->W9_TX_FOB
		Else
			nFob := QRYWN->FOB-(QRYWN->DESPESA*QRYWN->W9_TX_FOB)
		EndIf

		nINV   := QRYWN->FOB
		nII    := QRYWN->II 
		nIPI   := QRYWN->IPI
		nPIS   := QRYWN->PIS
		nCOF   := QRYWN->COFINS
		nICMS  := QRYWN->ICMS
		nDesp  := QRYWN->DESPESA
		nFrete := QRYWN->FRETE
		nSeg   := QRYWN->SEGURO
		nCIF   := (QRYWN->PRECO1-QRYWN->II)    
		nDespAdu := QRYWN->DESPADU
		nTotGer:= nII+nIPI+nPIS+nCOF+nICMS+nDesp+nFrete+nSeg

	ElseIf xLoc == "NF"
		While QRYWN->(!EOF())
			If QRYWN->W9_FREINC = "2" .AND. QRYWN->W9_INCOTER $ ("CFR,CIP,CIF,CPT,DAF,DES,DDU")
				nFob += (QRYWN->PRECO2-QRYWN->DESINV)*QRYWN->W9_TX_FOB
			Else        
				If Empty(QRYWN->FOB)
					nFob+=QRYWN->FOB
				Else
					nFob += QRYWN->FOB-(QRYWN->DESPESA*QRYWN->W9_TX_FOB)
				Endif
			EndIf
			nINV   += QRYWN->FOB
			nII    += QRYWN->II
			nIPI   += QRYWN->IPI
			nPIS   += QRYWN->PIS
			nCOF   += QRYWN->COFINS
			nICMS  += QRYWN->ICMS
			nDesp  += QRYWN->DESPESA
			nFrete += QRYWN->FRETE
			nSeg   += QRYWN->SEGURO
			nDespAdu += QRYWN->DESPADU 
			nCIF   += (QRYWN->PRECO1-QRYWN->II)
			nSisc  := QRYWN->SISCOMEX
			nFRMM	:= QRYWN->AFRMM
			nDespimp :=QRYWN->DESPIMP+iif(alltrim(QRYWN->W9_INCOTER)$'EXW,FOB',nFrete,0)
			nOutDesp += (QRYWN->OUTDESP+QRYWN->DESPADU+QRYWN->SEGURO) 
			if !empty(cCustCompl)
				nCustCompl := QRYWN->CUSTCOMPL  //NADIA
			endif

			if !empty(cPisDesp) .and. empty(QRYWN->PIS)
				nPIS := QRYWN->PISDESP  
			endif

			if !empty(cCofinsDesp) .and. empty(QRYWN->COFINS)
				nCOF := QRYWN->COFINSDESP
			endif

			if !empty(cDESPORI)
				nDespOri := QRYWN->DESPORI  //NADIA
			endif              
			
			if !empty(cIMPI)  
			    cImpI := QRYWN->IMPI  //NADIA
			endif    

			//Despesa sem contra partida
			if !empty(cDespSCont)
				nDespSCont := QRYWN->DESPSCONT
			endif

			QRYWN->(dbSkip())
		EndDo
		nTotGer:= nII+nIPI+nPIS+nCOF+nICMS+nDesp+nFrete+nSeg
	EndIf

	QRYWN->(dbCloseArea())

	aEval(aAreasDoc, {|aArea|restArea(aArea)})
	aSize(aAreasDoc,0)

	Do Case                
		Case cTipo = "INV"
		nReturn := nInv
		Case cTipo = "FOB"
		nReturn := nFob
		Case cTipo = "FRETE"
		nReturn := nFrete
		Case cTipo = "SEGURO"	
		nReturn := nSeg
		Case cTipo = "CIF"	
		nReturn := nCIF	
		Case cTipo = "II"
		nReturn := nII
		Case cTipo = "IPI"
		nReturn := nIPI	
		Case cTipo = "PIS"
		nReturn := nPIS	
		Case cTipo = "COFINS"
		nReturn := nCOF	
		Case cTipo = "ICMS"
		nReturn := nICMS
		Case cTipo = "DESPESA"
		nReturn := nDesp
		Case cTipo = "SISCOMEX"
		nReturn :=nSisc   
		Case cTipo = "AFRMM"
		nReturn :=nFRMM   
		Case cTipo = "OUTDESP" 
		nReturn := nOutDesp   
		Case cTipo = "DESPADU" 
		nReturn := nDespAdu   
		Case cTipo = "GERAL_SEM_FOB"
		nReturn := nTotGer   
		Case cTipo = "DESPIMP"
		nReturn := nDespimp
		Case ctipo = "CUSTCOMPL"  //nadia
		nReturn := nCustCompl      //nadia
		Case ctipo = "DESPORI"  //nadia
		nReturn := nDespOri      //nadia
		Case ctipo = "IMPI"  //nadia
		nReturn := cImpI      //nadia
		Case ctipo = "DESPSCONT" 
		nReturn := nDespSCont      
		OtherWise	        
		nReturn := 0	
	End Case

	If nReturn < 0
		nReturn := 0
	Endif

	Return(nReturn)


	*-------------------------*
User Function ContFrete()  
	*-------------------------*
	// Retorno do Frete em Reais, Lcto Padrao 950 Seq 001
	Local nFrete:=0 

	SD1->(dbsetorder(1))
	//SD1->(dbseek(xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE))
	sd1->(dbseek(xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE+sf1->f1_fornece+sf1->f1_loja))

	SA2->(dbsetorder(1))
	SA2->(dbseek(xFilial('SA2')+SF1->F1_FORNECE))


	If !("3102" $ sd1->d1_cf)
		Return 0
	Endif

	nFrete:= U_UZContNF("NF","FRETE")

	Return nFrete


	*-------------------------*
User Function ContTotProd()  
	*-------------------------*
	// Retorno do Total FOB+FRETE+SEGURO+TAXA SISCOMEX+II em Reais, Lcto Padrao 950 Seq 002
	Local nTotFob :=U_UZContNF("NF","FOB")
	Local nFrete  :=U_ContFrete()
	Local nSeguro :=U_ContSeguro()
	Local nDespSis:=U_DespSiscom()
	Local nTotII  :=U_TotalII()    
	Local nCustCompl := U_CustCompl() //nadia
	Local nDespori  := U_DespOri() //nadia
	Local cImpI     := U_ImpI()  //nadia

	Local nTotProd:=0

	nTotProd:=(nTotFob+nFrete+nSeguro+nDespSis+nTotII)

	Return ntotProd

	*------------------------*      
User Function TotalInv()  
	*------------------------*          
	//Retorna o Total da Invoice convertido na Taxa da DI, Lcto Padrao 950 Seq 003
	Local nTotInv  := 0.00
	Local nDesp412 := 0     // Apura as Despesas de Abatimento ou Acrescimo para o GRANEL
	local aAreasInv:= {}
	local cChvSW8  := ""
	local cAliasSW9 := getNextAlias()
	private lExecAuto := .F.

	// Se nao For Nota Nacionalizacao (1o Nota) ou nao for nota de Importacao - Retornar valor 0                  
	If SF1->F1_TIPO <> "N" .or. Empty(SF1->F1_HAWB)
		Return 0
	Endif      

	if (!(cFilAnt $ '05/06') .and. cEmpAnt == '01') .or. cEmpAnt == '02'
		nTotInv :=U_UZContNF("NF","INV")      
		nDesp412:=DespSWD("412",sf1->f1_hawb)
	endif	

	If (cFilAnt == '02' .and. cEmpAnt == '01') .or. cEmpAnt == '02'  //nadia

		nTotInv :=  nTotInv+nDesp412

	elseif (cFilAnt $ '05/06') .and. cEmpAnt == '01'

		aAreasInv := {SWN->(getArea()), SW8->(getArea()), SW9->(getArea())}
		nTotInv := 0
	
		dbSelectArea("SWN")
		SWN->(dbSetOrder(2))
		
		if SWN->(dbSeek(xFilial("SWN")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
	
			dbSelectArea("SW9")
			SW9->(dbSetOrder(1))
	
			dbSelectArea("SW8")
			SW8->(dbSetOrder(1))
			
			//----------------------------------------------
			//Montagem de query pois o fornecedor da SWN é
			//diferente da SW9
			//----------------------------------------------
			beginSql alias cAliasSW9
				SELECT R_E_C_N_O_ AS REGISTRO
				FROM %table:SW9% SW9
				WHERE SW9.W9_FILIAL  = %exp:SWN->WN_FILIAL % AND
					  SW9.W9_INVOICE = %exp:SWN->WN_INVOICE% AND 
					  SW9.W9_HAWB    = %exp:SWN->WN_HAWB   % AND
					  SW9.%notDel%
			endSql
	
			if (cAliasSW9)->(!eof())
				SW9->(dbGoTo((cAliasSW9)->REGISTRO))
				if SW8->(dbSeek(xFilial("SW8")+SW9->(W9_HAWB+W9_INVOICE+W9_FORN+W9_FORLOJ)))
	
					cChvSW8 := SW9->(W9_HAWB+W9_INVOICE+W9_FORN+W9_FORLOJ)	
	
					while SW8->(W8_HAWB+W8_INVOICE+W8_FORN+W8_FORLOJ) == cChvSW8
						nTotInv += DITRANS(SW8->W8_PRECO*SW8->W8_QTDE,2)
						SW8->(dbSkip())
					enddo
	
					nTotInv := nTotInv * DI154TaxaFOB()
					DITrans(nTotInv, 2)
				endif
	
				
			endif
		endif
	
		aEval(aAreasInv, {|aArea|restArea(aArea)})
		aSize(aAreasInv,0)
	Endif  

return nTotInv


User Function TotalII()
	// Retorna o total de II, Lcto Padrao 950, Seq 004

	Local nTotII:=U_UZContNF("NF","II")

	Return nTotII

	*-------------------------*
User Function IMPI()           //nadia
	*-------------------------*
	// Retorna o total de II, Lcto Padrao 950, Seq 004

	Local cImpI:=U_UZContNF("NF","IMPI")

	Return cImpI


	*-------------------------*
User Function DespSiscom() 
	*-------------------------*
	// Retorna a Taxa Siscomex, Lcto Padrao 950, Seq 005
             
	Local nDespSis:=U_UZContNF("NF","SISCOMEX")
	Return nDespSis                


   	*-------------------------*	
User Function CUSTCOMPL()        //nadia
   	*-------------------------*
   	//Retorna Custo Complementar
    Local nDespSis := U_UZContNF("NF","CUSTCOMPL")  
    Return nDespSis
    
    
   	*-------------------------*	
User Function DESPORI()        //nadia
   	*-------------------------*
   	//Retorna Custo Complementar
    Local nDespSis := U_UZContNF("NF","DESPORI")  
    Return nDespSis
    
	*-------------------------*
User Function DespAFRMM() 
	*-------------------------*
	// Retorna a Taxa Siscomex, Lcto Padrao 950, Seq 005

	Local nDespSis:=U_UZContNF("NF","AFRMM")

	Return nDespSis

	*-------------------------*
User Function ContSeguro()  
	*-------------------------*
	// Retorno do Seguro em Reais       
	                           
	Local nSeguro:= U_UZContNF("NF","SEGURO")
	Return nSeguro


	*-----------------------*                                          
User Function ContDesp() 
	*-----------------------*
	//Retorno do Total de Despesas, Lcto 950  Seq 006 e Seq 007
	Local nOutDesp :=0

	// Apura a Diferenca / Abatimento Custo
	Local nDifAbat :=0

	//nOutDesp :=U_UZContNF("NF","OUTDESP")
	//nOutDesp +=U_UZContNF("NF","DESPESA")
	nOutDesp :=U_UZContNF("NF","DESPIMP")

	If SF1->F1_TIPO == "C"   // Quando for complementar nao apurar novamente despesas de Abatimento / Complemento de Custo pois ja foram apuradas na Primeira Nota
		Return nOutDesp
	Endif                                

	nDifAbat := 0//DespSWD("412",sf1->f1_hawb)

	Return nOutDesp+nDifAbat


	*-----------------------------------*
Static Function DespSWD(cDespesa,cHawb)  
	*-----------------------------------*
	Local cFilSWD:=xFilial('SWD')                                    
	Local nDifAbat:=0

	swd->(dbsetorder(1))
	swd->(dbseek(cFilSWD+cHawb+cDespesa))
	While ! swd->(eof()) .and. swd->wd_filial == cFilSWD .and. swd->wd_hawb == cHawb .and. swd->wd_despesa == cDespesa

		nDifAbat+=swd->wd_valor_r      

		swd->(dbskip())
	End

	Return nDifAbat


	*-------------------------*
User Function DespADU() 
	*-------------------------*
	// Retorna a Despesa Aduaneira

	Local nDespA:=U_UZContNF("NF","DESPADU")

Return nDespA

/*/{Protheus.doc} UZPisCof
Retorna o Pis Cofins do item
@type function
@version 1.0
@author marcio.katsumata
@since 28/08/2020
@return numeric, valor pis cof do item
/*/
user function UZPisCof()
	local cAliasTrb as character
	local nTotalNFe as numeric
	local nTotalPisCof as numeric
	local nPercTot  as numeric
	local nPisCofAcu as numeric
	local nInd      as numeric
	local nDif      as numeric
	local nPosItem  as numeric
	local nRecSD1   as numeric
	local nPisCofRet as numeric
	local aItens    as array
	local aAreasDoc  as array

	aAreasDoc   := {SF1->(getArea()),SD1->(getArea())}
	aItens      := {}
	nTotalNFe   := 0   
	nTotalPisCof:= 0   
	nPercTot    := 0 
	nPisCofAcu  := 0  
	nInd        := 0 
	nDif        := 0 
	nPosItem    := 0 
	nRecSD1     := 0 
	nPisCofRet  := 0  
	cAliasTrb  := getNextAlias()
	nTotalNFe := SF1->F1_VALMERC 
	nTotalPisCof := U_UZContNF("NF", "PIS") + U_UZContNF("NF", "COFINS")


	beginSql alias cAliasTrb

		SELECT SD1.R_E_C_N_O_ AS REGISTRO , SD1.D1_TOTAL
		FROM %table:SD1% SD1
		WHERE SD1.D1_FILIAL = %exp:SF1->F1_FILIAL% AND
		      SD1.D1_DOC    = %exp:SF1->F1_DOC%    AND
			  SD1.D1_SERIE  = %exp:SF1->F1_SERIE%  AND
			  SD1.D1_FORNECE = %exp:SF1->F1_FORNECE% AND
			  SD1.D1_LOJA   = %exp:SD1->D1_LOJA%   AND
			  SD1.%notDel%

	endSql

	while (cAliasTrb)->(!eof())
		nPercTot += round((cAliasTrb)->D1_TOTAL/SF1->F1_VALMERC, 2)
		aadd(aItens,{(cAliasTrb)->REGISTRO, round((cAliasTrb)->D1_TOTAL/SF1->F1_VALMERC, 2), 0})
		(cAliasTrb)->(dbSkip())
	enddo

	(cAliasTrb)->(dbCloseArea())

	if len(aItens) > 0 
		if nPercTot > 1 
			if len(aItens) > 1
				nDif := nPercTot - 1
				aItens [1][2] := aItens [1][2] - nDif
			endif
		elseif nPercTot < 1 
			if len(aItens) > 1
				nDif := 1 - nPercTot 
				aItens [1][2] := aItens [1][2] + nDif
			endif
		endif

		for nInd := 1 to len(aItens) 
			nPisCofAcu += (aItens[nInd][3] := round(nTotalPisCof * aItens[nInd][2], 2))
		next nInd


		if nPisCofAcu > nTotalPisCof 
			nDif := nPisCofAcu - nTotalPisCof
			aItens [1][2] := aItens [1][3] - nDif
		elseif nPisCofAcu < nTotalPisCof 
			nDif := nTotalPisCof - nPisCofAcu 
			aItens [1][2] := aItens [1][3] + nDif
		endif

		aEval(aAreasDoc, {|aArea|restArea(aArea)})

		nRecSD1 := SD1->(recno())

		nPosItem := aScan(aItens, {|aItem|aItem[1]==nRecSD1})

		if nPosItem > 0 
			nPisCofRet := aItens[nPosItem][3]
		endif
	endif
	aEval(aAreasDoc, {|aArea|restArea(aArea)})
	aSize(aAreasDoc,0)
	aSize(aItens,0)
return (nPisCofRet)

/*/{Protheus.doc} DespADU
Retorna valor de despesa sem contrapartida
@type function
@version 1.0
@author marcio.katsumata
@since 22/07/2020
@return numeric, valor
/*/
User Function DespSCont() 

Return U_UZContNF("NF","DESPSCONT")
 
/*
*---------------------------*               
User Function TSTContNFE()  
*---------------------------*

// Nota Entrada       - 000000327 - 2  
// Nota Complementar  - 000000372 - 2
// Processo           - IMP-341/09-A     

nValor1:=0
nValor2:=0
nValor3:=0
nValor4:=0
nValor5:=0
nValor6:=0
nValor7:=0         

SF1->(dbsetorder(1))
SF1->(dbseek(xFilial('SF1')+"000000327"+"2"))
nValor1:=U_ContFrete()

If "3102" $ sd1->d1_cf
nValor2:=U_ContTotProd()
nValor3:=U_TotalInv()
nValor4:=U_TotalII()
nValor5:=U_DespSiscom()
nValor6:=IF(U_ContDesp()<0,U_ContDesp()*(-1),0)
nValor7:=IF(U_ContDesp()>0,U_ContDesp(),0)
Endif

Return .t.



*----------------------*               
User Function TSTNFC()  
*----------------------*

// Nota Entrada       - 000000327 - 2  
// Nota Complementar  - 000000372 - 2
// Processo           - IMP-341/09-A     

nValor1:=0
nValor2:=0
nValor3:=0
nValor4:=0
nValor5:=0
nValor6:=0
nValor7:=0         

SF1->(dbsetorder(1))
SF1->(dbseek(xFilial('SF1')+"000000372"+"2"))
nValor1:=U_ContFrete()

If "3102" $ sd1->d1_cf
nValor2:=U_ContTotProd()
nValor3:=U_TotalInv()
nValor4:=U_TotalII()
nValor5:=U_DespSiscom()
nValor6:=IF(U_ContDesp()<0,U_ContDesp()*(-1),0)
nValor7:=IF(U_ContDesp()>0,U_ContDesp(),0)
Endif

Return .t.
*/
