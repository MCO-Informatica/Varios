#INCLUDE "RwMake.ch"

/*
-----------------------------------------------------------------------------
Funcao   : RFatR01       
Autor    : Gildesio Campos                                    |Data: 05.07.07
-----------------------------------------------------------------------------
Descricao: Romaneio de Separacao de Pedidos e Materiais em Estoque 
-----------------------------------------------------------------------------
*/
User Function RFatR01()
	Local 	cDesc1  := "Este programa imprime os Romaneios de Separacao de Pedidos e Listagem acumulada por "
	Local 	cDesc2  := "Produto para facilitar a retirada de mercadorias do Estoque para separacao dos Pedi-"
	Local 	cDesc3  := "dos selecionados conforme parametros."
	Local 	cDesc4  := ""
	Local   nOpca
	Local 	cTitulo := "Romaneios de Separacao de Mercadorias"
	Local   aCampos := {}
	Local   aCposBrw:= {}
	Local   cQuery  := ""
	Local 	aSays   :={}
	Local   aButtons:= {}
	Local 	lAchouSC9 := .F.

	Private cMarca    := GetMark()
	Private cCadastro := OemToAnsi(cTitulo)
	Private aRotina   := {{ "Pedidos", "U_RFatImpP", 0, 2 },;
		{ "Estoque", "U_RFatImpE", 0, 2 }}
	Private cPerg    := PADR("RFTR01",lEN(SX1->X1_GRUPO))
	Private cArqTrab
	Private cIndTrab
	Private xMsgCliente := ""       //Gil 18.10.07
	Private xObsCliente := ""
	Private nTotPed     := 0

	AADD(aSays,OemToAnsi(cDesc1))
	AADD(aSays,OemToAnsi(cDesc2))
	AADD(aSays,OemToAnsi(cDesc3))
	AADD(aSays,OemToAnsi(cDesc4))

	nOpca := 0
	RFatR01Perg(cPerg)
	Pergunte(cPerg,.F.)

	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca != 1
		Return
	EndIf
/*
------------------------
Arquivos utulizados
------------------------*/
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea("SC6")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SF4")
dbSetOrder(1)
dbSelectArea("SA4")
DbSetOrder(1)		

aCampos:={{ "OK"     , "C", 2, 0 },;
		  { "BLCRED" , "C", 2, 0 },;
		  { "PEDIDO" , "C", 6, 0 },;
		  { "EMISSAO", "D", 8, 0 },; 
		  { "CLIENTE", "C", 6, 0 },; 
		  { "LOJA"   , "C", 2, 0 },;
		  { "TIPO"   , "C", 1, 0 },; 
		  { "TRANSP" , "C", 6, 0 },; 
		  { "TPFRETE", "C", 1, 0 },; 
		  { "REDESP" , "C", 6, 0 },; 
		  { "TPFREDE", "C", 1, 0 },; 
		  { "FRETE"  , "N",12, 2 },; 
		  { "MENNOTA", "C",100,0 },; 
		  { "MENPAD ", "C", 3, 0 },; 
		  { "MENPAD2", "C", 3, 0 },; 
		  { "MENPAD3", "C", 3, 0 },; 
		  { "MENPAD4", "C", 3, 0 },;  
		  { "USERINC", "C",15, 0 },; 
		  { "CODRE"  , "C", 5, 0 },; 
		  { "PRODUTO", "C",15, 0 },; 
		  { "UM"     , "C", 2, 0 },; 
		  { "SEGUM"  , "C", 2, 0 },; 
		  { "ITEM"   , "C", 2, 0 },;
		  { "ITEM2"  , "C", 2, 0 },;
		  { "DESCRI" , "C",40, 0 },; 
		  { "OBSERV" , "C",60, 0 },; 
		  { "QTDVEN" , "N", 9, 2 },; 
		  { "QTDENT" , "N", 9, 2 },; 
		  { "ENTREG" , "D", 8, 0 },; 
		  { "PEDCLI" , "C", 6, 0 },; 
		  { "LOCAL" , "C",  2, 0 },; 
		  { "SEQUEN" , "C", 2, 0 },;
		  { "QTDLIB" , "N", 9, 2 },; 
		  { "UNSVEN" , "N", 9, 2 },; 
		  { "BLEST"  , "C", 2, 0 },;
		  { "FORMULA", "C", 2, 0 },;
		  { "FLAG"   , "C", 1, 0 },;
		  { "TES"    , "C", 7, 0 },;
		  { "ALTPED" , "C", 1, 0 },;
		  { "ZPECUB" , "N",14, 3 },; //ALTERADO BRUNO 29-09-14
		  { "ZCUBAGE", "N",14, 3 }}  //ALTERADO BRUNO 29-09-14
		  

AADD(aCposBrw,{"OK"    ,,OemToAnsi("")})
AADD(aCposBrw,{"PEDIDO",,OemToAnsi("Pedido")}) 
AADD(aCposBrw,{"ITEM"  ,,OemToAnsi("Item")}) 
AADD(aCposBrw,{"PRODUTO",,OemToAnsi("Produto")}) 
AADD(aCposBrw,{"DESCRI" ,,OemToAnsi("Descricao")}) 
AADD(aCposBrw,{"CLIENTE",,OemToAnsi("Cod. Cliente")}) 
AADD(aCposBrw,{"LOJA"   ,,OemToAnsi("Loja")}) 
AADD(aCposBrw,{"ENTREG" ,,OemToAnsi("Data Entrega")}) 
AADD(aCposBrw,{"TES"    ,,OemToAnsi("TES")})   
AADD(aCposBrw,{"FLAG"   ,,OemToAnsi("Impresso")})   

cArqTrab:= CriaTrab(aCampos, .T.)
cIndTrab:= CriaTrab(Nil, .F.)
/*
-----------------------------------------------
Cria arquivo de Trabalho
-----------------------------------------------*/
dbUseArea(.T.,__LocalDriver,cArqTrab,"TRB",.F.)
IndRegua("TRB",cIndTrab,"PEDIDO+ITEM",,,"Selecionando Registros...")    
/*
---------------------------------------------------
Consulta Pedidos Liberados
---------------------------------------------------*/
/* //Query Original
aStru := SC9->(DbStruct()) 
cQuery := " SELECT DISTINCT SC5.*,SC6.*,SC9.* ,SC9.R_E_C_N_O_ SC9RECNO "
cQuery += " FROM "
cQuery += RetSqlName("SC5")+" SC5, "
cQuery += RetSqlName("SC6")+" SC6, "
cQuery += RetSqlName("SC9")+" SC9 "
cQuery += " WHERE " 
cQuery += " SC5.C5_FILIAL  = '"+xFilial("SC5")+"' AND "   
cQuery += " SC9.C9_FILIAL  = '"+xFilial("SC9")+"' AND "   
cQuery += " SC6.C6_FILIAL  = '"+xFilial("SC6")+"' AND "
//cQuery += " SC5.C5_TIPO = 'N' AND " 
cQuery += " SC5.C5_DTENTR BETWEEN '"+ Dtos(Mv_Par05) + "' AND '" + Dtos(Mv_Par06) + "' AND " 
cQuery += " SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQuery += " SC9.C9_PEDIDO = SC6.C6_NUM AND "
cQuery += " SC9.C9_CLIENTE = SC5.C5_CLIENTE AND "
cQuery += " SC9.C9_CLIENTE = SC6.C6_CLI AND "
cQuery += " SC9.C9_LOJA = SC5.C5_LOJACLI AND "
cQuery += " SC9.C9_LOJA = SC6.C6_LOJA AND " 
cQuery += " SC9.C9_ITEM = SC6.C6_ITEM AND "

//------------------------------
//Considera já impresso
//------------------------------
	If Mv_Par08 == 2	//Nao
	cQuery += " SC6.C6_X_CTIMP = ' ' AND "
	Else
	cQuery += " SC6.C6_X_CTIMP <> ' ' AND "
	EndIf

cQuery += " SC9.C9_PEDIDO  BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND "  
cQuery += " SC9.C9_CLIENTE BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND "  
cQuery += " SC9.C9_BLCRED <> '10' AND "		//Filtra os ja faturados (ALT. 06.09.07)
cQuery += " SC5.D_E_L_E_T_ = ' ' AND "
cQuery += " SC6.D_E_L_E_T_ = ' ' AND "   
cQuery += " SC9.D_E_L_E_T_ = ' ' "  
cQuery += " ORDER BY SC9.C9_PEDIDO,SC9.C9_ITEM"
*/

	aStru := SC9->(DbStruct())
	cQuery := " SELECT 	C9_PEDIDO,C5_EMISSAO,C9_CLIENTE,C9_LOJA,"
	cQuery += "  		C5_TIPO,C5_TRANSP,C5_REDESP,"
	cQuery += " 		C5_USERINC,C5_X_CODRE,C9_PRODUTO,C6_UM,C6_ITEM,"
	cQuery += " 		C6_OBSERV,C6_QTDVEN,C6_QTDENT,C6_ENTREG,C6_NUMPCOM,C6_ITEMPC,C6_LOCAL,"
	cQuery += " 		C9_SEQUEN,C9_QTDLIB,C9_BLCRED,C9_BLEST,C9_X_TES,C6_X_CTIMP,"
	cQuery += " 		C5_X_MENRO,C5_TPFRETE,C5_TPFREDE,C5_FRETE,C5_MENPAD,C5_MENPAD2,C9_QTDLIB2,C6_SEGUM,"
//ALTERADO BRUNO 29-09-14
//cQuery += " 		C5_MENPAD3,C5_MENPAD4,C9_ITEM,C6_GRADE"
	cQuery += " 		C5_MENPAD3,C5_MENPAD4,C9_ITEM,C6_GRADE,C6_ZPECUB,C6_ZCUBAGE"
//TERMINO BRUNO 29-09-14
	cQuery += " 	FROM "+RetSqlTab("SC5")+" "
	cQuery += "			INNER JOIN "+RetSqlTab("SC6")+" "
	cQuery += "				ON SC6.C6_NUM = SC5.C5_NUM"
	cQuery += "			INNER JOIN "+RetSqlTab("SC9")+" "
	cQuery += "				ON SC9.C9_PEDIDO     = SC5.C5_NUM"
	cQuery += "				AND SC9.C9_CLIENTE   = SC5.C5_CLIENTE"
	cQuery += "				AND SC9.C9_LOJA      = SC5.C5_LOJACLI"
	cQuery += "				AND SC9.C9_ITEM      = SC6.C6_ITEM"
	cQuery += "				AND SC9.C9_PRODUTO   = SC6.C6_PRODUTO"
	cQuery += "		WHERE SC9.C9_FILIAL  = '"+xFilial("SC9")+"'"
	cQuery += "		AND   SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
	cQuery += "		AND   SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
	cQuery += " 	AND   SC5.C5_DTENTR BETWEEN '"+ Dtos(Mv_Par05) + "' AND '" + Dtos(Mv_Par06) + "'"

//------------------------------
//Considera já impresso
//------------------------------
	If Mv_Par08 == 2	//Nao
		cQuery += " AND SC6.C6_X_CTIMP = ' '"
	Else
		cQuery += " AND SC6.C6_X_CTIMP <> ' ' "
	EndIf

	cQuery += "		AND  SC9.C9_PEDIDO  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cQuery += "     AND  SC9.C9_CLIENTE BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"'"
	cQuery += "		AND  SC9.C9_BLCRED <> '10'"
	cQuery += "		AND  SC5.D_E_L_E_T_ = ' '"
	cQuery += "		AND  SC6.D_E_L_E_T_ = ' '"
	cQuery += "		AND  SC9.D_E_L_E_T_ = ' '"
	cQuery += "		GROUP BY C9_PEDIDO,C5_EMISSAO,C9_CLIENTE,C9_LOJA,"
	cQuery += "				C5_TIPO,C5_TRANSP,C5_REDESP,"
	cQuery += "				C5_USERINC,C5_X_CODRE,C9_PRODUTO,C6_UM,C6_ITEM,"
	cQuery += "				C6_OBSERV,C6_QTDVEN,C6_QTDENT,C6_ENTREG,C6_NUMPCOM,C6_ITEMPC,C6_LOCAL,"
	cQuery += "				C9_SEQUEN,C9_QTDLIB,C9_BLCRED,C9_BLEST,C9_X_TES,C6_X_CTIMP,"
	cQuery += "				C5_X_MENRO,C5_TPFRETE,C5_TPFREDE,C5_FRETE,C5_MENPAD,C5_MENPAD2,C9_QTDLIB2,C6_SEGUM,"
	cQuery += "				C5_MENPAD3,C5_MENPAD4,C9_ITEM,C6_GRADE,C6_ZPECUB,C6_ZCUBAGE"
	cQuery += "		ORDER BY SC9.C9_PEDIDO,SC9.C9_ITEM"

	MemoWrite("C:\Temp\Shangrila\QryRFATR01.txt",cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

	For nI := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField('TMP', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next

	dbSelectArea("TMP")
	nRegs := 0
	While !Eof()
		nRegs++
		dbSkip()
	End
	dbGoTop()
	If nRegs == 0
		ApMsgAlert("Nenhum registro encontrado!")

		dbSelectArea("TMP")
		dbCloseArea()

		Return
	EndIf
	ProcRegua(nRegs)
	dbGoTop()

	While TMP->(!Eof())
		IncProc("Gerando arquivo temporario...")

		cPedido := TMP->C9_PEDIDO

		While TMP->(!Eof()) .And. cPedido == TMP->C9_PEDIDO

			lAchouSC9 := GetLiber(TMP->C9_PEDIDO)

			If lAchouSC9 == .F.
				TMP->(dbSkip())
				Loop
			EndIf

			lAchouSC6 := SC6->(MsSeek(xFilial("SC6")+TMP->(C9_PEDIDO+C9_ITEM+C9_PRODUTO)))    //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

			If lAchouSC6 == .F.
				TMP->(dbSkip())
				Loop
			EndIf
	/*	------------------------------
		Considera itens já impressos
		------------------------------*/
			If Mv_Par08 == 2	//Nao
				If SC6->C6_X_CTIMP == 'P' .OR. SC6->C6_X_CTIMP == 'A' 	//Considera Item Já Impresso
	   			TMP->(dbSkip())
		       	Loop    
				EndIf
			EndIf
	/*	-----------------------------------------------------
		Verifica se TES movimenta estoque. (Inc. em 23/08/07)
		-----------------------------------------------------*/
		xF4Estoque := Posicione("SF4",1,xFilial("SF4")+TMP->C9_X_TES,"F4_ESTOQUE")
		xF4Poder3  := Posicione("SF4",1,xFilial("SF4")+TMP->C9_X_TES,"F4_PODER3")    //alt. 29.11.07  
		
			If Upper(xF4Estoque) == "N"
				If Upper(xF4Poder3) != "R" .And. Upper(xF4Poder3) != "D"		//Inc. 29.11.07  solic. Norberto
   				TMP->(dbSkip())
	       		Loop    
				EndIf
			EndIf
               
			If	Alltrim(TMP->C5_X_CODRE) == '5130' .Or. Alltrim(TMP->C5_X_CODRE) == '5150'
				If SUBSTR(TMP->C9_X_TES,1,1) == '6'
					If TRB->(!EOF())
					RecLock("TRB",.F.)
					TRB->TES  := Alltrim(TRB->TES) + "/" + TMP->C9_X_TES
					TRB->ITEM2:= SC6->C6_ITEM
					MsUnlock()
					EndIf
    			TMP->(dbSkip())
		       	Loop    
				EndIf
			EndIf
	/*	-------------------------------------
		Grava registro valido para o processo
		-------------------------------------*/
		
			
		RecLock("TRB",.T.)
		TRB->PEDIDO := TMP->C9_PEDIDO
   		TRB->EMISSAO:= StoD(TMP->C5_EMISSAO)
		TRB->CLIENTE:= TMP->C9_CLIENTE
	    TRB->LOJA   := TMP->C9_LOJA
		TRB->TIPO   := TMP->C5_TIPO
	    TRB->TRANSP := TMP->C5_TRANSP
	    TRB->REDESP	:= TMP->C5_REDESP
		TRB->TPFRETE:= TMP->C5_TPFRETE
	   	TRB->TPFREDE:= TMP->C5_TPFREDE
	   	TRB->FRETE  := TMP->C5_FRETE
		TRB->MENNOTA:= TMP->C5_X_MENRO
	    TRB->MENPAD := TMP->C5_MENPAD
    	TRB->MENPAD2:= TMP->C5_MENPAD2
	    TRB->MENPAD3:= TMP->C5_MENPAD3
		TRB->MENPAD4:= TMP->C5_MENPAD4
	   	TRB->USERINC:= TMP->C5_USERINC
		TRB->CODRE  := TMP->C5_X_CODRE
	    TRB->PRODUTO:= TMP->C9_PRODUTO
		TRB->UM     := SC6->C6_UM
	    TRB->ITEM   := SC6->C6_ITEM
	    //ALTERADO BRUNO 29-09-14
	    TRB->ZPECUB := SC6->C6_ZPECUB
	    TRB->ZCUBAGE:= SC6->C6_ZCUBAGE
	    //TERMINO BRUNO 29-09-14
	    
	    //Alterado por rodrigo sanches 27/11/2013
			IF Alltrim(TMP->C6_GRADE) == 'S'
	    	SB1->(DbSetOrder(1))
	    	SB1->(DbSeek(xFilial("SB1")+TMP->C9_PRODUTO))
	    	TRB->DESCRI := SB1->B1_DESC
			Else
			TRB->DESCRI := SC6->C6_DESCRI
			EndIf
		//fim alteracao
		
	   	TRB->OBSERV := SC6->C6_OBSERV
		TRB->QTDVEN := SC6->C6_QTDVEN
	    TRB->QTDENT := SC6->C6_QTDENT
		TRB->ENTREG := SC6->C6_ENTREG
	    TRB->PEDCLI := SC6->C6_NUMPCOM+SC6->C6_ITEMPC
    	TRB->LOCAL  := SC6->C6_LOCAL
		TRB->SEQUEN := TMP->C9_SEQUEN
	   	TRB->QTDLIB := TMP->C9_QTDLIB
		TRB->BLCRED := TMP->C9_BLCRED
    	TRB->BLEST  := TMP->C9_BLEST
		TRB->TES    := TMP->C9_X_TES 
		TRB->FLAG   := SC6->C6_X_CTIMP 			//TMP->C9_X_IMP
		TRB->ALTPED := ""
	   	TRB->OK     := ""
		TRB->UNSVEN	:= TMP->C9_QTDLIB2
		TRB->SEGUM	:= SC6->C6_SEGUM
		MsUnlock()
	
	    TMP->(dbSkip())
		End
	End
dbSelectArea("TRB") 
dbGoTop()

MarkBrow("TRB","OK","BLCRED",aCposBrw,,cMarca,"U_R01MarkAll()",,,,"U_R01Mark()")
/*
-------------------------------------
Apaga arquivos e Indices Temporarios
-------------------------------------*/
dbSelectArea("TMP") 
dbCloseArea()

dbSelectArea("TRB")
dbCloseArea()

FErase(cArqTrab + GetDBExtension())
FErase(cIndTrab + OrdBagExt())
Return                                                 
/*
-----------------------------------------------------------------------------
Funcao   : R01Mark 
Autor    : Gildesio Campos                                    |Data: 30.06.07
-----------------------------------------------------------------------------
Descricao: Grava marca no campo OK dos itens do pedido
-----------------------------------------------------------------------------
*/
Static Function GetLiber(cPedido)

	Local lRet	 :=	.T.

	cQuery1 := " SELECT 	C9_PEDIDO,C5_EMISSAO,C9_CLIENTE,C9_LOJA,"
	cQuery1 += "  		C5_TIPO,C5_TRANSP,C5_REDESP,"
	cQuery1 += " 		C5_USERINC,C5_X_CODRE,C9_PRODUTO,C6_UM,C6_ITEM,"
	cQuery1 += " 		C6_OBSERV,C6_QTDVEN,C6_QTDENT,C6_ENTREG,C6_PEDCLI,C6_LOCAL,"
	cQuery1 += " 		C9_SEQUEN,C9_QTDLIB,C9_BLCRED,C9_BLEST,C9_X_TES,C6_X_CTIMP,"
	cQuery1 += " 		C5_X_MENRO,C5_TPFRETE,C5_TPFREDE,C5_FRETE,C5_MENPAD,C5_MENPAD2,C6_SEGUM,C9_QTDLIB2,"
	cQuery1 += " 		C5_MENPAD3,C5_MENPAD4,C9_ITEM,C6_GRADE,C6_ZPECUB,C6_ZCUBAGE"
	cQuery1 += " 		FROM "+RetSqlTab("SC5")+" "
	cQuery1 += "			INNER JOIN "+RetSqlTab("SC6")+" "
	cQuery1 += "				ON SC6.C6_NUM = SC5.C5_NUM"
	cQuery1 += "			INNER JOIN "+RetSqlTab("SC9")+" "
	cQuery1 += "				ON SC9.C9_PEDIDO     = SC5.C5_NUM"
	cQuery1 += "				AND SC9.C9_CLIENTE   = SC5.C5_CLIENTE"
	cQuery1 += "				AND SC9.C9_LOJA      = SC5.C5_LOJACLI"
	cQuery1 += "				AND SC9.C9_ITEM      = SC6.C6_ITEM"
	cQuery1 += "				AND SC9.C9_PRODUTO   = SC6.C6_PRODUTO"
	cQuery1 += "		WHERE SC9.C9_FILIAL  = '"+xFilial("SC9")+"'"
	cQuery1 += "		AND   SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
	cQuery1 += "		AND   SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"

//------------------------------
//Considera já impresso
//------------------------------
	If Mv_Par08 == 2	//Nao
		cQuery1 += " AND SC6.C6_X_CTIMP = ' '"
	Else
		cQuery1 += " AND SC6.C6_X_CTIMP <> ' ' "
	EndIf

	cQuery1 += "		AND  SC9.C9_PEDIDO = '"+cPedido+"'
	cQuery1 += "		AND  SC9.C9_BLCRED <> '10'"
	cQuery1 += "		AND  SC5.D_E_L_E_T_ = ' '"
	cQuery1 += "		AND  SC6.D_E_L_E_T_ = ' '"
	cQuery1 += "		AND  SC9.D_E_L_E_T_ = ' '"
	cQuery1 += "		GROUP BY C9_PEDIDO,C5_EMISSAO,C9_CLIENTE,C9_LOJA,"
	cQuery1 += "				C5_TIPO,C5_TRANSP,C5_REDESP,"
	cQuery1 += "				C5_USERINC,C5_X_CODRE,C9_PRODUTO,C6_UM,C6_ITEM,"
	cQuery1 += "				C6_OBSERV,C6_QTDVEN,C6_QTDENT,C6_ENTREG,C6_PEDCLI,C6_LOCAL,"
	cQuery1 += "				C9_SEQUEN,C9_QTDLIB,C9_BLCRED,C9_BLEST,C9_X_TES,C6_X_CTIMP,"
	cQuery1 += "				C5_X_MENRO,C5_TPFRETE,C5_TPFREDE,C5_FRETE,C5_MENPAD,C5_MENPAD2,C9_QTDLIB2,C6_SEGUM,"
	cQuery1 += "				C5_MENPAD3,C5_MENPAD4,C9_ITEM,C6_GRADE,C6_ZPECUB,C6_ZCUBAGE"
	cQuery1 += "		ORDER BY SC9.C9_PEDIDO,SC9.C9_ITEM"

	MemoWrite("C:\Temp\Shangrila\QryRFATR02.txt",cQuery1)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TMP1",.F.,.T.)

	While TMP1->(!Eof()) .And. cPedido == TMP1->C9_PEDIDO
		If TMP1->C9_BLCRED <> ' '
			lRet := .F.
		EndIf
		TMP1->(dbSkip())
	End
	TMP1->(dbclosearea())

Return(lRet)


/*
-----------------------------------------------------------------------------
Funcao   : RFatImpP       
Autor    : Gildesio Campos                                    |Data: 27.06.07
-----------------------------------------------------------------------------
Descricao: Impressao do Romaneio para Separacao de Pedidos
-----------------------------------------------------------------------------
*/
User Function RFatImpP()
	Local cDesc1  	:= "Este programa tem como objetivo imprimir Romaneios de Separacao de "
	Local cDesc2  	:= "Pedidos, conforme os parametros informados."
	Local cDesc3  	:= ""
	Local imprime 	:= .T.
	Local aOrd    	:= {}
	Local cPict   	:= ""
	Local lImpMsg 	:= .F.
	Local lMarcado	:= .F.
//ALTERADO BRUNO 29-09-14
	local lQuebrou	:= .F.
	local nTamObs	:= 0
	local nTotPCubic:= 0
	local nTotCubage:= 0
//TERMINO BRUNO 29-09-14

	Private nLin       := 80
	Private Cabec1 	   := "Cliente       : "
	Private Cabec2 	   := "End.p/ Entrega: "
	Private titulo     := "Romaneio de Separacao - Pedidos " //mudar conforme relatorio
	Private lEnd       := .F.
	Private lAbortPrint:= .F.
	Private CbTxt      := ""
	Private limite     := 220
	Private tamanho    := "G"
	Private nomeprog   := "RFATR01"
	Private nTipo      := 15
	Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey   := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "RFATR01"


	wnrel := SetPrint("SC9",NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,"SC9")

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	dbSelectArea("TRB")
	nRegs := RecCount()
	ProcRegua(nRegs)
	dbGoTop()

	While TRB->(!EOF())
		IncProc()
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If Empty(TRB->OK)
			TRB->(dbSkip())
			Loop
		EndIf
		lMarcado:= .T.

		If nLin > 55
			RfatR01Cab()
		EndIf
		nLin     := nLin + 1
		cPedido  := TRB->PEDIDO
		xMensagem:= Alltrim(TRB->MENNOTA)
		_cMsgG	 := Alltrim(Posicione("SC5",1,xFilial("SC5")+cPedido,"C5_XOBS"))
		_cMsgGI	 := Alltrim(Posicione("SC5",1,xFilial("SC5")+cPedido,"C5_XOBSINT"))
		xCodPad  := TRB->MENPAD
		xMenPad  := Alltrim(Posicione("SM4",1,xFilial("SM4")+xCodPad ,"M4_FORMULA"))
		xCodPad2 := TRB->MENPAD2
		xMenPad2 := Alltrim(Posicione("SM4",1,xFilial("SM4")+xCodPad2,"M4_FORMULA"))
		xCodPad3 := TRB->MENPAD3
		xMenPad3 := Alltrim(Posicione("SM4",1,xFilial("SM4")+xCodPad3,"M4_FORMULA"))
		xCodPad4 := TRB->MENPAD4
		xMenPad4 := Alltrim(Posicione("SM4",1,xFilial("SM4")+xCodPad4,"M4_FORMULA"))
		aTes     := {}
		nPesBrt  := 0
		nPesoLQ	 := 0
		nTotPed  := 0
		While TRB->(!Eof()) .And. cPedido == TRB->PEDIDO
			lQuebrou := .F.
			IncProc()
			If !Empty(TRB->OK) //Verifica se está marcado
				If nLin > 55
					RfatR01Cab()
					nLin += 1
				EndIf
				cTes := Substr(TRB->TES,1,3)
				nX := Ascan(aTes, {|x| x[1] == cTes})
				If nX <= 0
					xCodForm := Posicione("SF4",1,xFilial("SF4")+cTes,"F4_FORMULA")
					aAdd(aTes,{cTes,xCodForm})
				EndIf
				nTamDesc := Len(Alltrim(TRB->DESCRI))
				//ALTERADO BRUNO 29-09-14
				nTamObs	 := Len(Alltrim(TRB->OBSERV))
				//TERMINO BRUNO 29-09-14


				
				//@nLin,000		  	PSAY Transform(TRB->QTDLIB,"@E 999,999.9999") //TRANSFORM(TRB->QTDLIB,"@E 99.999")
				cvaliddec := alltrim(cvaltochar(Transform(TRB->QTDLIB,"@E 999,999.9999")))
				cPesq := ","
  				PosAT:= AT( cPesq, cvaliddec ) // Resultado: 7

				If substr(cvaliddec,PosAT+1,4) $ "0000"
				//	Alert("Não Encontrou decimais"+'-'+cvaliddec+'-'+"0000")
				@nLin,000		  	PSAY Transform(TRB->QTDLIB,"@E 999,999") + '     ' //TRANSFORM(TRB->QTDLIB,"@E 99.999")
				Else
				@nLin,000		  	PSAY Transform(TRB->QTDLIB,"@E 999,999.9999") //TRANSFORM(TRB->QTDLIB,"@E 99.999")
				Endif
				@nLin,Pcol()+002  	PSAY TRB->UM
				@nLin,Pcol()+001  	PSAY Transform(TRB->UNSVEN,"@E 999,999.99") //TRANSFORM(TRB->QTDLIB,"@E 99.999")
				@nLin,Pcol()+002  	PSAY TRB->SEGUM
				@nLin,Pcol()+004  	PSAY Substr(TRB->DESCRI,1,50)	//Gil 18.10.07
				@nLin,Pcol()+004  	PSAY Substr(TRB->OBSERV,1,45)
				@nLin,Pcol()+004  	PSAY Substr(Dtos(TRB->ENTREG),7,2)+"/"+Substr(Dtos(TRB->ENTREG),5,2)+"/"+Substr(Dtos(TRB->ENTREG),3,2)
				//@nLin,Pcol()+004  	PSAY ALLTRIM(TRB->PRODUTO) //Alterado Marcos Floridi 04-11-2020 corrigir posisionamento das colunas.
				@nLin,Pcol()+004  	PSAY SUBSTR(TRB->PRODUTO,1,10)
				@nLin,Pcol()+004  	PSAY TRB->LOCAL
				@nLin,Pcol()+004  	PSAY TRB->TES
				@nLin,Pcol()+004  	PSAY Substr(TRB->PEDCLI,1,8)//Altrim(TRB->PEDCLI)
				@nLin,Pcol()+004  	PSAY Substr(TRB->ITEM,1,2)//Nro Item Pedido Marcos 26/06/08
				@nLin,Pcol()+004  	PSAY "-"+If(Empty(TRB->FLAG),"",If(TRB->FLAG != "E","I",""))
				//CAMPOS NOVOS - CUBAGEM E PESO CUBADO
				@nLin,Pcol()+004  	PSAY TRB->ZPECUB	  Picture "@E 999,999.999"
				@nLin,Pcol()+004  	PSAY TRB->ZCUBAGE	  Picture "@E 999,999.999"
				//TERMINO BRUNO 29-09-14

				nPesoL	:= Posicione("SB1",1,xFilial("SB1")+TRB->PRODUTO,"B1_PESO") //Peso Liquido - Marcos Floridi Leme 11.11.2020
				nPeso   := Posicione("SB1",1,xFilial("SB1")+TRB->PRODUTO,"B1_PESBRU")

				nPesoLQ	+= nPesoL * TRB->QTDLIB //Peso Liquido - Marcos Floridi Leme 11.11.2020
				nPesBrt += nPeso * TRB->QTDLIB

				nTotPCubic := nTotPCubic + TRB->ZPECUB
				nTotCubage := nTotCubage + TRB->ZCUBAGE

				//If nTamDesc > 25      //Gil 18.10.07
				//	nLin := nLin + 1
				//	@nLin,10 PSAY Substr(TRB->DESCRI,26)
				//ALTERADO BRUNO 29-09-14
				//	lQuebrou := .T.
				//TERMINO BRUNO 29-09-14
				//EndIf

				//ALTERADO BRUNO 29-09-14
				//if nTamObs	> 25
				//	if !lQuebrou
				//		nLin := nLin + 1
				//	endIf

				//	@nLin,10 PSAY Substr(allTrim(TRB->OBSERV),26)

				//endIf
				//TERMINO BRUNO 29-09-14
				nLin := nLin + 2
		/*	----------------------------
			Flag de Impressao
			----------------------------*/	 
			cFlag := TRB->FLAG	//""				
				If Empty(TRB->FLAG)
				cFlag := "P"
				ElseIf TRB->FLAG != "P"
				cFlag := "A"
				EndIf
			GravaSC6(cFlag)
						
			EndIf
		TRB->(dbSkip()) 
		EndDo
		
  	@nLin,00 PSay Replicate("-",limite)
    nLin := nLin + 1
	@nLin,30 Psay "PESO LIQUIDO TOTAL -->" + TRANSFORM(nPesoLQ,"@E 999,999.999")+ " Kg"
	@nLin,78 PSay "PESO BRUTO TOTAL -->" + TRANSFORM(nPesBrt,"@E 999,999.999")+ " Kg"
	
	//ALTERADO BRUNO 29/09/14
	//ALTERADO MARCOS FLORIDI 04/11/2020 POSICIONAMENTO DA IMPRESSAO ORIGINAL 120/130
	@nLin,194 PSAY nTotPCubic	  Picture "@E 999,999.999"
	@nLin,208 PSAY nTotCubage	  Picture "@E 999,999.999"
	//ALTERADO BRUNO 29/09/14		
	
	//ALTERADO MATHEUS 09/01/2015 - Após impressão dos totais, zero a variável para não acumular nas impressões dos próximos pedidos
	nTotPCubic := 0
	nTotCubage := 0
	// FIM MATHEUS
	
    nLin := nLin + 1                                                                 
    
   	@nLin,78 PSay "VALOR TOTAL PEDIDO->" + TRANSFORM(nTotPed,PesqPict("SC6","C6_VALOR"))
                                                                                     
    nLin := nLin + 1                                                                 
/*	------------------------------------------
	Mensagens para NF
	------------------------------------------*/
		If !Empty(xMensagem)
			If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			Else
		  	@nLin,00 PSay Replicate("-",limite)
		    nLin := nLin + 1
			EndIf
			If !Empty(xMensagem)
			@nLin,00 PSay "Mensagem para o Faturamento:" 
		    nLin := nLin + 1
	  		@nLin,00 PSay Replicate("-",limite)
		    nLin := nLin + 1
			@nLin,00 PSay xMensagem 
	    	nLin := nLin + 1 
	  		@nLin,00 PSay Replicate("-",limite)
	    	nLin := nLin + 1 
				If !Empty(_cMsgG)
				@nLin,00 PSay "Observações do Guarani - " +  _cMsgG 
	    		nLin := nLin + 1 
	  			@nLin,00 PSay Replicate("-",limite)
	    		nLin := nLin + 1
				Endif
				If !Empty(_cMsgGI)
				@nLin,00 PSay "Observações Interna do Guarani - " +_cMsgGI 
	    		nLin := nLin + 1 
	  			@nLin,00 PSay Replicate("-",limite)
	    	nLin := nLin + 2 
				Endif
			Elseif Empty(xMensagem) .and. !Empty(_cMsgG) .or. !Empty(_cMsgGI)
			
			@nLin,00 PSay "Mensagem para o Faturamento:" 
		    nLin := nLin + 1
	  		@nLin,00 PSay Replicate("-",limite)
		    nLin := nLin + 1
				If !Empty(_cMsgG)
					@nLin,00 PSay "Observações do Guarani - " +  _cMsgG 
	    			nLin := nLin + 1 
	  				@nLin,00 PSay Replicate("-",limite)
	    			nLin := nLin + 1
				Endif
				If !Empty(_cMsgGI)
					@nLin,00 PSay "Observações Interna do Guarani - " +_cMsgGI 
	    			nLin := nLin + 1 
	  				@nLin,00 PSay Replicate("-",limite)
	    	    	nLin := nLin + 2 
				Endif


			Endif
		Elseif Empty(xMensagem)	 
			@nLin,00 PSay "Mensagem para o Faturamento:" 
		    nLin := nLin + 1
	  		@nLin,00 PSay Replicate("-",limite)
		    nLin := nLin + 1
				If !Empty(_cMsgG)
					@nLin,00 PSay "Observações do Guarani - " +  _cMsgG 
	    			nLin := nLin + 1 
	  				@nLin,00 PSay Replicate("-",limite)
	    			nLin := nLin + 1
				Endif
				If !Empty(_cMsgGI)
					@nLin,00 PSay "Observações Interna do Guarani - " +_cMsgGI 
	    			nLin := nLin + 1 
	  				@nLin,00 PSay Replicate("-",limite)
	    	    	nLin := nLin + 2 
				Endif			

		
		EndIf
/*	----------------------------------------
	Mensagens Padrão do Pedido
	----------------------------------------*/
		If !Empty(xCodPad+xCodPad2+xCodPad3+xCodPad4)
			If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			Else
	  		@nLin,00 PSay Replicate("-",limite)
		    nLin := nLin + 1
			EndIf
			If !Empty(xMenPad)
			@nLin,00 PSay "Mensagens:" 
		    nLin := nLin + 1
  			@nLin,00 PSay Replicate("-",limite)
	    	nLin := nLin + 1
			@nLin,00 PSay xCodPad+"-"+xMenPad
	    	nLin := nLin + 1
			lImpMsg := .T.
			EndIf
			If !Empty(xMenPad2)
				If !lImpMsg
				@nLin,00 PSay "Mensagens:" 
			    nLin := nLin + 1
  				@nLin,00 PSay Replicate("-",limite)
	    		nLin := nLin + 1
				lImpMsg := .T.
				EndIf
			@nLin,00 PSay xCodPad2+"-"+xMenPad2
	    	nLin := nLin + 1
			EndIf
			If !Empty(xMenPad3)
				If !lImpMsg
				@nLin,00 PSay "Mensagens:" 
			    nLin := nLin + 1
  				@nLin,00 PSay Replicate("-",limite)
	    		nLin := nLin + 1
				lImpMsg := .T.
				EndIf
			@nLin,00 PSay xCodPad3+"-"+xMenPad3
	    	nLin := nLin + 1
			EndIf
			If !Empty(xMenPad4)
				If !lImpMsg
				@nLin,00 PSay "Mensagens:" 
			    nLin := nLin + 1
  				@nLin,00 PSay Replicate("-",limite)
	    		nLin := nLin + 1
				lImpMsg := .T.
				EndIf
			@nLin,00 PSay xCodPad4+"-"+xMenPad4
	    	nLin := nLin + 1
			EndIf

			If lImpMsg
	  		@nLin,00 PSay Replicate("-",limite)
	    	nLin := nLin + 2 
			EndIf
		EndIf
/*	----------------------------------------
	Mensagens do TES
	----------------------------------------*/
		If Len(aTes) > 0
			For _nCnt := 1 To Len(aTes)
			xMsgTes := Posicione("SM4",1,xFilial("SM4")+aTes[_nCnt,2],"M4_FORMULA")

				If !Empty(xMsgTes)
					If nLin > 55
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				
					@nLin,00 PSay "Mensagem TES:" 
	    			nLin := nLin + 1
					@nLin,00 PSay Replicate("-",limite)
					nLin := nLin + 1
					EndIf
				@nLin,00 PSay aTes[_nCnt,1]+"/"+aTes[_nCnt,2]+"-"+Alltrim(xMsgTes)
				nLin := nLin + 1
				EndIf
			Next
		EndIf
/*	----------------------------------------
	Observacao Faturamento - Cliente
	----------------------------------------*/
		If !Empty(xMsgCliente)
		@nLin,00 PSay xMsgCliente
		nLin++
		EndIf
	
		If !Empty(xObsCliente)
		@nLin,00 PSay xObsCliente
		Endif
   	nLin := 80
	EndDo

	If !lMarcado
	ApMsgAlert("Nenhum registro selecionado!") 
	MS_FLUSH()
	Return
	EndIf

SET DEVICE TO SCREEN

	If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
	Endif

MS_FLUSH()

Return     
/*
-----------------------------------------------------------------------------
Funcao   : RfatR01Cab()
Autor    : Gildesio Campos                                    |Data: 01.06.07
-----------------------------------------------------------------------------
Descricao: Cabecalho do Romaneio de Pedidos
-----------------------------------------------------------------------------
*/
Static Function RfatR01Cab()
/*		
-------------------------------------------
Cliente
-------------------------------------------*/
SA1->(MsSeek(xFilial("SA1")+TRB->(CLIENTE+LOJA)))

Cabec1 := "Cliente  : "+ Alltrim(SA1->A1_COD) + " - " + Alltrim(SA1->A1_NOME)+ SPACE(10) + "Regra: "+;
   	      				 Substr(TRB->CODRE,1,2)+"/"+Substr(TRB->CODRE,3,3)+ SPACE(10)+ ;
       	                 Iif(SA1->A1_PESSOA$"F"," - CPF: "+Transform(SA1->A1_CGC,"@R 999.999.999-99")," - CNPJ: "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"))
Cabec2 := "Endereco : "+TRANSFORM(SA1->A1_CEP,"@R 99999-999")+"-"+Alltrim(SA1->A1_END)+;
	If(!Empty(SA1->A1_BAIRRO)," - "+ Alltrim(SA1->A1_BAIRRO),"")+;
			If(!Empty(SA1->A1_MUN),+" - "+Alltrim(SA1->A1_MUN),"")+" - "+SA1->A1_EST+;
                        " Incl. Por: "+Upper(Alltrim(TRB->USERINC))
xMsgCliente := Alltrim(SA1->A1_X_OBSFA)
xObsCliente	:= Alltrim(SA1->A1_OBSPED)
/*
-------------------------------------------
Cabecalho
-------------------------------------------*/
titulo := "Romaneio de Separacao - Pedido "+If(TRB->ALTPED=="A","Alterado ","")+"No. " + TRB->PEDIDO + " - Emissao: " +Substr(Dtos(TRB->EMISSAO),7,2)+"/"+Substr(Dtos(TRB->EMISSAO),5,2)+"/"+Substr(Dtos(TRB->EMISSAO),1,4) //	EndIf

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
/*
-------------------------------------------
			Endereco de Entrega
-------------------------------------------*/
		If !Empty(SA1->A1_ENDENT)
	nLin := nLin + 1
 	@nLin,00 PSay "End.p/ Entrega: "+TRANSFORM(SA1->A1_CEPE,"@R 99999-999")+"-"+Alltrim(SA1->A1_ENDENT)+If(!Empty(SA1->A1_BAIRROE),+" - "+Alltrim(SA1->A1_BAIRROE),'')+If(!Empty(SA1->A1_MUNE),+" - "+Alltrim(SA1->A1_MUNE),"")+" - "+SA1->A1_ESTE
  	nLin := nLin + 1
  	@nLin,00 PSay Replicate("-",limite)
		EndIf
/*
-------------------------------------------
Transportadora
-------------------------------------------*/
		If !Empty(TRB->TRANSP)
   	SA4->(MsSeek(xFilial("SA4")+TRB->TRANSP))
  	nLin := nLin + 1
  	@nLin,00 PSay "Transportadora: "+ Alltrim(SA4->A4_COD)+"-"+Alltrim(SA4->A4_NOME)+ "     Frete: "+If(TRB->TPFRETE=="C","CIF","FOB")
	nLin := nLin + 1
   	@nLin,00 PSay "Endereco      : "+ Alltrim(SA4->A4_END)+If(!Empty(SA4->A4_BAIRRO)," - "+Alltrim(SA4->A4_BAIRRO),"")+If(!Empty(SA4->A4_MUN)," - "+Alltrim(SA4->A4_MUN),"")+" - "+Alltrim(SA4->A4_EST)+"   Tel: "+If(!Empty(SA4->A4_DDD),"("+SA4->A4_DDD+")","")+" "+Alltrim(SA4->A4_TEL)
 	nLin := nLin + 1
	@nLin,00 PSay Replicate("-",limite)
		EndIf

nLin := nLin + 1

		If !Empty(TRB->REDESP)
   	SA4->(MsSeek(xFilial("SA4")+TRB->REDESP))
  	nLin := nLin + 1
  	@nLin,00 PSay "Redespacho:     "+ Alltrim(SA4->A4_COD)+"-"+Alltrim(SA4->A4_NOME)+ "     Frete: "+If(TRB->TPFREDE=="D","DESTINATARIO","REMETENTE")
	nLin := nLin + 1
   	@nLin,00 PSay "Endereco      : "+ Alltrim(SA4->A4_END)+If(!Empty(SA4->A4_BAIRRO)," - "+Alltrim(SA4->A4_BAIRRO),"")+If(!Empty(SA4->A4_MUN)," - "+Alltrim(SA4->A4_MUN),"")+" - "+Alltrim(SA4->A4_EST)+"   Tel: "+If(!Empty(SA4->A4_DDD),"("+SA4->A4_DDD+")","")+" "+Alltrim(SA4->A4_TEL)
 	nLin := nLin + 1
	@nLin,00 PSay Replicate("-",limite)
		EndIf

nLin := nLin + 1

//@nLin,00 PSay "Quant. UN Descricao                      Dt.Entrg Observacao                                          Codigo   Al TES     Ped.Cl. " 
//ALTERADO BRUNO 29-09-14
//@nLin,00 PSay "Quant. UN Descricao                 Dt.Entrg Observacao                                          Codigo     Al TES     Ped.Cl.  ITEM"
@nLin,00 PSay " Quant.       UN    QtdSeg.  UN    Descricao                                   Observacao                                        Dt.Entrg    Codigo        Al    TES        Ped.Cl.  ITEM            P.Cubado        Cubagem"
//TERMINO BRUNO 29-09-14
nLin := nLin + 1                                                                                               
@nLin,00 PSay Replicate("-",limite)

Return
/*
-----------------------------------------------------------------------------
Funcao   : RFatImpE
Autor    : Gildesio Campos                                    |Data: 01.06.07
-----------------------------------------------------------------------------
Descricao: Impressao do Romaneio para Retirar do Estoque
-----------------------------------------------------------------------------
*/
User Function RFatImpE()
	Local cDesc1  := "Este programa tem como objetivo imprimir Romaneios de Separacao de "
	Local cDesc2  := "Estoque, aglutinado por Produto conforme os parametros informados. "
	Local cDesc3  := ""
	Local imprime := .T.
	Local aOrd    := {}
	Local cPict   := ""
	Local lImp    := .F.
	Local lMarcado:= .F.

	Private nLin       := 80
	Private Cabec1 := "Produto"
	Private Cabec2 := "Codigo          UM Descricao                                   Quantidade   Observações"
	Private titulo     := "Romaneio de Separacao - Estoque "
	Private lEnd       := .F.
	Private lAbortPrint:= .F.
	Private CbTxt      := ""
	Private limite     := 132
	Private tamanho    := "M"
	Private nomeprog   := "RFATR01"
	Private nTipo      := 15
	Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey   := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "RFATR01" // nome do arquivo usado para impressao em disco

	wnrel := SetPrint("SC9",NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,"SC9")

	If nLastKey == 27
		Return
	Endif
	nTipo := If(aReturn[4]==1,15,18)
/*
----------------------------------------------
Reindexa arquivo temporario
----------------------------------------------*/
dbSelectArea("TRB")
IndRegua("TRB",cIndTrab,"PRODUTO+PEDIDO+Upper(OBSERV)",,,"Selecionando Registros...")    

	While !EOF()
   	IncProc()
		If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
		Endif

		If Empty(TRB->OK) //Verifica se está marcado
	    TRB->(dbSkip()) 
	    Loop
		EndIf
	lMarcado := .T.
	cProduto := TRB->PRODUTO
	nTotPro  := 0
	nTotItem := 0

		If nLin > 55
      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       	nLin := 8
		Endif
    nLin++
/*	------------------------------
	Imprime a descricao do Produto
	------------------------------*/  
	@nLin,00 PSAY ALLTRIM(TRB->PRODUTO)
	@nLin,16 PSAY TRB->UM
   	@nLin,19 PSAY TRB->DESCRI 
// 	@nLin,51 PSAY If(Empty(TRB->FLAG),"",If(TRB->FLAG != "P","(I)",Space(3)))  //o CONTROLE DE JA IMPRESSOS SERA FEITO MANUALMENTE PELO USUARIO

	cObserv := Upper(TRB->OBSERV)
		While !Eof() .And. cProduto == TRB->PRODUTO
			If Empty(TRB->OK) //Verifica se está marcado
		    TRB->(dbSkip()) 
		    Loop
			EndIf
		lImp := .F.
			If cObserv  == Upper(TRB->OBSERV)
			nTotItem += TRB->QTDLIB 
			Else
	 		@nLin,66 PSAY TRANSFORM(nTotItem,"@E 999,999")
	 		@nLin,76 PSAY Upper(cObserv)     //(Alltrim(cObserv))

			cObserv  := Upper(TRB->OBSERV)
			nTotItem := TRB->QTDLIB
		    nLin     := nLin + 1
			EndIf
		nTotPro += TRB->QTDLIB
/*		----------------------------
		Flag de Impressao
		----------------------------*/		
		cFlag := TRB->FLAG 	//""    29.11.07
			If Empty(TRB->FLAG)
			cFlag := "E"
			ElseIf TRB->FLAG != "E"
			cFlag := "A"
			EndIf
		GravaSC6(cFlag)
 
    	TRB->(dbSkip()) 
			If cProduto != TRB->PRODUTO
			lImp := .T.					
			EndIf
		EndDo
		If lImp
		@nLin,66 PSAY TRANSFORM(nTotItem,"@E 999,999") 
 		@nLin,76 PSAY Upper(cObserv) //(Alltrim(cObserv))
		nLin++
		EndIf
	@nLin,63 PSay "----------"
	nLin++	
	@nLin,37 PSay "TOTAL ---------->"
	@nLin,64 PSay TRANSFORM(nTotPro,"@E 9,999,999") 
	nLin++
	@nLin,00 PSay __PrtThinLine()
	EndDo

	If !lMarcado
	ApMsgAlert("Nenhum registro selecionado!") 
	MS_FLUSH()
	Return
	EndIf

SET DEVICE TO SCREEN

	If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
	Endif

MS_FLUSH()

Return 
/*
-----------------------------------------------------------------------------
Funcao   : GravaSC6
Autor    : Gildesio Campos                                    |Data: 24.07.07
-----------------------------------------------------------------------------
Descricao: Grava flag de impressao
-----------------------------------------------------------------------------
*/
Static Function GravaSC6(xFlag)
	Local _aArea := GetArea()
	Local lGrava := .T.
	Local nX     := 0

	If SC6->(MsSeek(xFilial("SC6")+TRB->(PEDIDO+ITEM+PRODUTO)))

		//nTotPed += ZCalcImp(TRB->CLIENTE,TRB->LOJA,TRB->PRODUTO,SC6->C6_TES,1,(SC6->C6_VALOR),If(TRB->TIPO == 'D','F','C'),TRB->TIPO,'MATA410')
		nTotPed += ZCalcImp(TRB->CLIENTE,TRB->LOJA,TRB->PRODUTO,SC6->C6_TES,1,ROUND(((SC6->C6_QTDVEN-SC6->C6_QTDENT) * SC6->C6_PRCVEN),2),If(TRB->TIPO == 'D','F','C'),TRB->TIPO,'MATA410')

		While .T.

			If SC6->(Found())
				RecLock("SC6",.F.)
				SC6->C6_X_CTIMP := xFlag
				MsUnlock()
				nX++
			EndIf

			If nX > 1
				Exit
			EndIf

			If !Empty(TRB->ITEM2)
				SC6->(MsSeek(xFilial("SC6")+TRB->(PEDIDO+ITEM2+PRODUTO)))
				nX++
				Loop
			Else
				Exit
			EndIf
		End
	EndIf
	RestArea(_aArea)
Return
/*
-----------------------------------------------------------------------------
Funcao   : R01MarkAll 
Autor    : Gildesio Campos                                    |Data: 30.06.07
-----------------------------------------------------------------------------
Descricao: Grava marca em todos os registros do Arquivo
-----------------------------------------------------------------------------
*/
User Function R01MarkAll()

	Local nRecno :=	0
	DbSelectArea("TRB")
	nRecno	:=	REcno()
	DbGoTop()

	While !EOF()
		U_R01Mark(.T.)
		DbSkip()
	Enddo
	DbGoTo(nRecno)
Return
/*
-----------------------------------------------------------------------------
Funcao   : R01Mark 
Autor    : Gildesio Campos                                    |Data: 30.06.07
-----------------------------------------------------------------------------
Descricao: Grava marca no campo OK dos itens do pedido
-----------------------------------------------------------------------------
*/
User Function R01Mark(lTodos)
	Local lRet	 :=	.F.
	Local nX	 :=	0
	Local lAchou := .F.

	lTodos	:=	Iif(lTodos == Nil, .F., lTodos)

	DbSelectArea("TRB")

	If Empty(TRB->BLCRED)
		If IsMark("OK",cMarca)
			MsRLock(TRB->(RECNO()))
			Replace OK With "  "
			MsRUnLock(TRB->(RECNO()))
		Else
			MsRLock(TRB->(RECNO()))
			Replace OK With cMarca
			MsRUnLock(TRB->(RECNO()))
		Endif
	Endif

Return
/*
-----------------------------------------------------------------------------
Funcao   : RFatR01Perg
Autor    : Gildesio Campos                                    |Data: 01.06.07
-----------------------------------------------------------------------------
Descricao: Perguntas
-----------------------------------------------------------------------------
*/
Static Function RFatR01Perg(xPerg)
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := Padr(cPerg,10) //AQUI ESTÁ O PROBLEMA
	aRegs:= {}

	AADD(aRegs,{cPerg,"01","Pedido de                  ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5","","","","",""})
	AADD(aRegs,{cPerg,"02","Pedido Ate         	       ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC5","","","","",""})
	AADD(aRegs,{cPerg,"03","Cliente de                 ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})
	AADD(aRegs,{cPerg,"04","Cliente Ate        	       ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})
	AADD(aRegs,{cPerg,"05","Data Entrega de            ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Data Entrega Ate           ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Quanto ao Credito          ?","","","mv_ch7","N",01,0,0,"C","","Mv_Par07","Liberados","","","","","Bloqueados","","","","","Ambos","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Considera Item ja Impresso ?","","","mv_ch8","N",01,0,0,"C","","Mv_Par08","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

Return(.T.)
/*	       0        1         2         3         4         5         6         7         8         9        10        11        12        13        
           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
           ------------------------------------------------------------------------------------------------------------------------------------
           Quant. UN Descricao                 Dt.Entrg Observacao                                         Codigo     Al TES     Ped.Cl. 
           ------------------------------------------------------------------------------------------------------------------------------------
           999999 XX XXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999999999 99 999/999 9999999999   I
					 XXXXXXXXXXXXXXX
           999999 XX XXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999999999 99 999/999 9999999999   I

					 													  							    PESO BRUTO TOTAL ---> 99.999,999 Kg 

           Relacao de Pedidos para retirar do Estoque
           ------------------------------------------
  	      0        1         2         3         4         5         6         7         8         9        10        11        12        13        
          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Cabec1 :="Produto                                            
Cabec2 :="Codigo          UM Descricao                                   Quantidade   Observações
          --------------------------------------------------------------------------------------------------------------------------------------
          999999999999999 XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  (I)            999.999   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx      
                                                                         ----------
                                      TOTAL ---------->                   9.999.999        
          --------------------------------------------------------------------------------------------------------------------------------------
*/

Static Function ZCalcImp(cClieFor,cLoja,cProduto,cTes,nQuant,nPreco,cTipo,cTipoNF,cRotina)
	Local aArea           := GetArea()
	Local cTipoCli        := ''
	Local nTotal		  := 0

	If cTipo == 'F'
		cTipo       := If(cTipoNF=='D','C','F')
	Else
		cTipo := If(cTipoNF=='D','F','C')
	EndIf

	cTipoCli    := POSICIONE(If(cTipo=='C','SA1','SA2'),1,xFilial(If(cTipo=='C','SA1','SA2')) + cClieFor + cLoja,If(cTipo=='C','A1_TIPO','A2_TIPO'))

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&| Verifico o tipo da nota para efetuar o calculo                                          |
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	MaFisSave()
	MaFisEnd()

	MaFisIni(cClieFor,;&& 1-Codigo Cliente/Fornecedor
	cLoja,;		&& 2-Loja do Cliente/Fornecedor
	cTipo,;				&& 3-C:Cliente , F:Fornecedor
	cTipoNF,;				&& 4-Tipo da NF
	cTipoCli,;		&& 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		cRotina)

	&&Na argentina o calculo de impostos depende da serie.
	If cPaisLoc == 'ARG'
		MaFisAlt('NF_SERIENF',LocXTipSer(If(cTipo=='C','SA1','SA2'),MVNOTAFIS))
	Endif

	MaFisAdd(    cProduto                    ,;           // 1-Codigo do Produto ( Obrigatorio )
	cTes                        ,;          // 2-Codigo do TES ( Opcional )
	nQuant                   ,;          // 3-Quantidade ( Obrigatorio )
	nPreco                    ,;          // 4-Preco Unitario ( Obrigatorio )
	0                                ,;           // 5-Valor do Desconto ( Opcional )
	""                                ,;          // 6-Numero da NF Original ( Devolucao/Benef )
	""                                ,;          // 7-Serie da NF Original ( Devolucao/Benef )
	""                                ,;          // 8-RecNo da NF Original no arq SD1/SD2
	0                                ,;          // 9-Valor do Frete do Item ( Opcional )
	0                                ,;          // 10-Valor da Despesa do item ( Opcional )
	0                                ,;        // 11-Valor do Seguro do item ( Opcional )
	0                                ,;          // 12-Valor do Frete Autonomo ( Opcional )
	nPreco    ,;          // 13-Valor da Mercadoria ( Obrigatorio )
	0                                ,;          // 14-Valor da Embalagem ( Opiconal )
	0                                ,;          // 15-RecNo do SB1
	0                                )           // 16-RecNo do SF4

	MaFisWrite(1)

	nBasIPI := MaFisRet(1,'IT_BASEIPI')
	nValIPI := MaFisRet(1,'IT_VALIPI')
	nAlqIPI := MaFisRet(1,'IT_ALIQIPI')
	nBasICM := MaFisRet(1,'IT_BASEICM')
	nValICM := MaFisRet(1,'IT_VALICM')
	nAlqICM := MaFisRet(1,'IT_ALIQICM')
	nBasSol := MaFisRet(1,'IT_BASESOL')
	nValSol := MaFisRet(1,'IT_VALSOL')
	nBasPS2 := MaFisRet(1,'IT_BASEPS2')
	nBasCF2 := MaFisRet(1,'IT_BASECF2')

	nDescZF  := MaFisRet(,"NF_DESCZF")
	ntotSol  := MaFisRet(,"NF_VALSOL")
	ntotFrt  := MaFisRet(,"NF_FRETE")
	ntotDesp := MaFisRet(,"NF_DESPESA")
	ntotDesc := MaFisRet(,"NF_DESCONTO")
	ntotGer  := MaFisRet(,"NF_TOTAL")
	ntotMerc := MaFisRet(,"NF_VALMERC")

	MaFisEnd()
	RestArea( aArea )

Return nTotGer
