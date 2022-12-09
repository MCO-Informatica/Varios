#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"
#Define  CRLF Chr(13)+Chr(10)

//+----------------------------------------------------------------+
//| Rotina | CSFAT010 | Autor | Rafael Beghini | Data | 24/03/2015 |
//+----------------------------------------------------------------+
//| Descr. | Relatório de Pedidos não Faturados                    |
//|        |                                                       |
//+----------------------------------------------------------------+
//| Uso    | CertiSign - Faturamento/Fiscal                        |
//+----------------------------------------------------------------+
User Function CSFAT010()

	Private oReport   := Nil
	Private oSecCab	:= Nil
	Private oBreak    := Nil
	Private lPgBreak  := .T.
	Private lAutoSize := .T.
	Private cPerg 	:= "CSFAT010"
	Private cTitulo   := "Pedidos não Faturados"
	Private cPicture  := "@E 999,999,999.99"
	
	CriaSX1( cPerg )
	Pergunte( cPerg, .F. )
		
	ReportDef()
	oReport	:PrintDialog()	

Return Nil  

//+------------------------------------------------------------------+
//| Rotina | ReportDef | Autor | Rafael Beghini | Data | 24/03/2015  |
//+------------------------------------------------------------------+
//| Descr. | Definição da estrutura do relatório.			          |
//|        | 		                                                   |
//+------------------------------------------------------------------+
//| Uso    | CertiSign - Faturamento/Fiscal                          |
//+------------------------------------------------------------------+
Static Function ReportDef()

	Local cAliasA := GetNextAlias()
	Local aSetTotal[02] 
                                                                           
	oReport := TReport():New("CSFAT010",cTitulo,cPerg,;
			   {|oReport| PrintReport(oReport,cAliasA)},"Este relatório irá imprimir o relatório de pedidos não faturados conforme parâmetros informados.")
	
	/*
	oReport:cFontBody:= 'Consolas'
	oReport:nFontBody:= 7
	oReport:nLineHeight:= 30
	*/
	
	//oReport:SetPortrait(.T.)  //Retrato 
	oReport:SetLandscape(.T.) //Paisagem   
	
	oSecCab := TRSection():New( oReport , "Pedidos não Faturados", {cAliasA} )
	
	TRCell():New( oSecCab, "C5_NUM"     , "QRY", 'Número'          , 		  ,10 ,.F.,{|| (cAliasA)->C5_NUM })
	TRCell():New( oSecCab, "C5_CHVBPAG" , "QRY", 'Ped. Gar'        , 		  ,15 ,.F.,{|| (cAliasA)->C5_CHVBPAG })
	TRCell():New( oSecCab, "C5_XNPSITE" , "QRY", 'Ped. Site'       , 		  ,15 ,.F.,{|| (cAliasA)->C5_XNPSITE })
	TRCell():New( oSecCab, "C5_XORIGPV" , "QRY", 'Origem'          , 		  ,25 ,.F.,                           )
	TRCell():New( oSecCab, "C5_EMISSAO" , "QRY", 'Emissão'         , 		  ,10 ,.F.,{|| StoD((cAliasA)->C5_EMISSAO) })
	TRCell():New( oSecCab, "A1_TIPO"    , "QRY", 'Tipo Cli'        , 		  ,10 ,.F.,                           )
	TRCell():New( oSecCab, "C5_CLIENTE" , "QRY", 'Cliente'         , 		  ,10 ,.F.,{|| (cAliasA)->C5_CLIENTE })
	TRCell():New( oSecCab, "C5_LOJACLI" , "QRY", 'Loja'            , 		  ,05 ,.F.,{|| (cAliasA)->C5_LOJACLI })
	TRCell():New( oSecCab, "A1_NOME"    , "QRY", 'Nome'            , 		  ,50 ,.F.,                           )     
	TRCell():New( oSecCab, "C5_CONDPAG" , "QRY", 'Cond.Pg'         , 		  ,10 ,.F.,{|| (cAliasA)->C5_CONDPAG })
	TRCell():New( oSecCab, "C5_XNATURE" , "QRY", 'Natureza'        , 		  ,10 ,.F.,{|| (cAliasA)->C5_XNATURE })
	TRCell():New( oSecCab, "C6_ITEM"    , "QRY", 'Item'            , 		  ,05 ,.F.,{|| (cAliasA)->C6_ITEM }   )
	TRCell():New( oSecCab, "C6_PRODUTO" , "QRY", 'Produto'         , 		  ,15 ,.F.,{|| (cAliasA)->C6_PRODUTO })
	TRCell():New( oSecCab, "B1_DESC"    , "QRY", 'Descrição'       , 		  ,30 ,.F.,{|| (cAliasA)->B1_DESC }   )     
	TRCell():New( oSecCab, "VALOR"      , "QRY", 'Valor'           , cPicture  ,10 ,.F.,{|| (cAliasA)->VALOR }     )    
	TRCell():New( oSecCab, "C6_CF"      , "QRY", 'CFOP'            , 		  ,10 ,.F.,{|| (cAliasA)->C6_CF }     )
	TRCell():New( oSecCab, "C6_TES"     , "QRY", 'TES'             , 		  ,10 ,.F.,{|| (cAliasA)->C6_TES }    )
	TRCell():New( oSecCab, "A1_INSCR"   , "QRY", 'Insc.Estadual'   , 		  ,20 ,.F.,                           )
	TRCell():New( oSecCab, "A1_EST"     , "QRY", 'Estado'          , 		  ,10 ,.F.,                           )
	TRCell():New( oSecCab, "C6_XOPER"   , "QRY", 'Operação'        , 		  ,10 ,.F.,{|| (cAliasA)->C6_XOPER }  )
	//TRCell():New( oSecCab, "C5_XRECPG"  , "QRY", 'Recibo Pagamento', 		  ,100,.F.,{|| (cAliasA)->C5_XRECPG}  )
	//TRCell():New( oSecCab, "C6_BLQ"     , "QRY", 'Bloqueio'        , 		  ,100,.F.,                           )
	
	//Totalizadores    
	                              //New(oCell                 ,cName,cFunction,oBreak,cTitle   ,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)                                                                                  
	aSetTotal[ 1  ] := TRFunction():New(oSecCab:Cell("C5_NUM"),     ,"COUNT"  ,NIL   ,"Pedidos",        ,        ,.F.        ,.T.       ,.F.)
	aSetTotal[ 2  ] := TRFunction():New(oSecCab:Cell("VALOR" ),     ,"SUM"    ,NIL   ,"Valor"  ,        ,        ,.F.        ,.T.       ,.F.)
	 
	oSecCab:SetTotalInLine(.T.)
	//oSecCab:SetTotalText("Total...")
		
Return (oReport) 

//+--------------------------------------------------------------------+
//| Rotina | PrintReport | Autor | Rafael Beghini | Data | 24/03/2015  |
//+--------------------------------------------------------------------+
//| Descr. | Executa a query para processamento do relatório.          |
//|        |                                                           |
//+--------------------------------------------------------------------+
//| Uso    | CertiSign - Faturamento/Fiscal                            |
//+--------------------------------------------------------------------+
Static Function PrintReport(oReport,cAliasA)
	
	Local oSecCab  := oReport:Section(1)
	Local nCinza   := RGB(217,217,217)
	Local aRect    := {}
	Local nLinha   := 1
	Local cTipo    := ''
	Local cTipCli  := ''
	Local cOrigem  := ''
	Local cCodOri  := ''
	Local cCliente := ''
	Local cNome    := ''
	Local cInsc    := ''
	Local cUf      := ''
	Local oPintacinza := TBrush():New(,nCinza)
	Local aCombo 	:= StrToKarr( U_CSC5XBOX(), ';' )
	Local nPos		:= 0
	aRect := {0,0,0,0}
	aRect[4] := oReport:PageWidth()

	/*Realiza a construcao da Query*/
	CriaSql(@cAliasA)

	dbSelectArea(cAliasA)
	(cAliasA)->(dbGoTop())

	If (cAliasA)->(!EoF())
		While (cAliasA)->(!EoF())
			If oReport:Cancel()
				Exit
			EndIf
			
			If MOD(nLinha,2) == 0
				aRect[1] := oReport:Row()
				aRect[3] := oReport:Row() + oReport:LineHeight() * 2
				oReport:FillRect(aRect,oPintacinza)
			EndIf
	
			oSecCab:Init()
			oReport:IncMeter((cAliasA)->(LastRec()))
			
			cCodOri := Alltrim((cAliasA)->C5_XORIGPV)
			
			nPos := AScan( aCombo, {|x| Left(x,1) == cCodOri  } )
			cOrigem  := IIF( nPos > 0,aCombo[nPos], '')
			
			cTipo := Alltrim((cAliasA)->C5_TIPO)
			cCliente := Alltrim((cAliasA)->C5_CLIENTE+(cAliasA)->C5_LOJACLI)
			
			If !( cTipo $ 'B/D' )
				//Cliente
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial("SA1")+cCliente)
				
				cNome   := SA1->A1_NOME  
				cTipCli := SA1->A1_PESSOA  
				cUf     := SA1->A1_EST  
				cInsc   := SA1->A1_INSCR  
			Else
				//Fornecedor
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(xFilial("SA1")+cCliente)
				
				cNome   := SA2->A2_NOME  
				cTipCli := SA2->A2_TIPO
				cUf     := SA2->A2_EST  
				cInsc   := SA2->A2_INSCR
			EndIf
			
			//Descrição do bloqueio
			/*
			SX5->( dbSetOrder(1) )
			IF SX5->( dbSeek( xFilial('SX5') + 'F1' + (cAliasA)->C6_BLQ ))
				cDesBlq := SX5->X5_DESCRI
			Else
				cDesBlq := (cAliasA)->C6_BLQ
			EndIF
			*/
			
			oSecCab:Cell("C5_XORIGPV"):SetBlock( { || cOrigem })
			oSecCab:Cell("A1_TIPO"   ):SetBlock( { || cTipCli })
			oSecCab:Cell("A1_NOME"   ):SetBlock( { || cNome   })
			oSecCab:Cell("A1_INSCR"  ):SetBlock( { || cInsc   })
			oSecCab:Cell("A1_EST"    ):SetBlock( { || cUf     })                                           
			//oSecCab:Cell("C6_BLQ"    ):SetBlock( { || cDesBlq })                                           
			
			oSecCab:PrintLine()
			oReport:SkipLine()
			nLinha++
			
			(cAliasA)->(dbSkip())
		EndDo  
	Else
		MsgBox("Não há dados. Favor vertificar os Parâmetros.","Atenção","ALERT")
	EndIf	
	
	oSecCab:Finish()
Return Nil 

//+----------------------------------------------------------------+
//| Rotina | CriaSql | Autor | Rafael Beghini | Data | 02/04/2015  |
//+----------------------------------------------------------------+
//| Descr. | Executa a query para processamento do relatório.      |
//|        |                                                       |
//+----------------------------------------------------------------+
//| Uso    | CertiSign - Faturamento/Fiscal                        |
//+----------------------------------------------------------------+
Static Function CriaSql(cAliasA) 

	Local cQuery  := ""

	cQuery += " SELECT C5_NUM," + CRLF 
	cQuery += "        C5_CHVBPAG," + CRLF 
	cQuery += "        C5_XNPSITE," + CRLF 
	cQuery += "        C5_XORIGPV," + CRLF 
	cQuery += "        C5_EMISSAO," + CRLF 
	cQuery += "        C5_CLIENTE," + CRLF 
	cQuery += "        C5_LOJACLI," + CRLF 
	cQuery += "        C5_CONDPAG," + CRLF 
	cQuery += "        C5_XNATURE," + CRLF 
	cQuery += "        C5_TOTPED,"  + CRLF 
	cQuery += "        Sum(C6_VALOR)VALOR," + CRLF 
	cQuery += "        C6_CF,"      + CRLF 
	cQuery += "        C6_TES,"     + CRLF
	cQuery += "        C5_TIPO,"    + CRLF
	cQuery += "        C6_ITEM,"    + CRLF
	cQuery += "        C6_PRODUTO," + CRLF
	cQuery += "        B1_DESC,"    + CRLF
	cQuery += "        C6_XOPER"   	+ CRLF
	//cQuery += "        C5_XRECPG,"  + CRLF
	//cQuery += "        C6_BLQ"      + CRLF
	
	cQuery += " FROM " + RetSqlName("SC5") + " SC5 " 													+ CRLF 
	cQuery += "        INNER JOIN "+ RetSqlName("SC6") + " SC6 " 		 								+ CRLF 
	cQuery += "                ON C5_NUM = C6_NUM "                		 								+ CRLF
	cQuery += "                   AND C6_FILIAL = '"+xFilial("SC6")+"' " 								+ CRLF 
	cQuery += "                   AND SC6.D_E_L_E_T_ = ' ' "       		 								+ CRLF 
	
	cQuery += "        INNER JOIN "+ RetSqlName("SB1") + " SB1 " 		 								+ CRLF 
	cQuery += "                	   ON C6_PRODUTO = B1_COD "            								 	+ CRLF
	cQuery += "                   AND B1_FILIAL = '"+xFilial("SB1")+"' " 								+ CRLF
	cQuery += "                   AND SB1.D_E_L_E_T_ = ' ' "  	   		 								+ CRLF
	cQuery += "        INNER JOIN "+ RetSqlName("SA1") + "  A1 " 		 								+ CRLF 
	cQuery += "    				   ON A1.A1_COD = C5_CLIENTE      "										+ CRLF
	cQuery += "       			  AND A1.A1_LOJA = C5_LOJACLI	" 		 								+ CRLF
	cQuery += "       			  AND A1.D_E_L_E_T_ = ' ' 		"										+ CRLF
	cQuery += " WHERE  SC5.D_E_L_E_T_ = ' ' "                 	  						 				+ CRLF
	cQuery += "        AND C5_FILIAL = '"+ xFilial("SC5")+"' " 	   										+ CRLF
	cQuery += "        AND C5_NOTA = ' ' "                    	   										+ CRLF
	cQuery += "        AND C5_NUM     BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " 				+ CRLF
	cQuery += "        AND C5_CLIENTE BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' " 				+ CRLF
	cQuery += "        AND C5_EMISSAO BETWEEN '" + dTos(mv_par05) + "' AND '" + dTos(mv_par06) + "' " 	+ CRLF
	if mv_par09 <> 3
		cQuery += "        AND A1.A1_PESSOA = '" + if(mv_par09 = 1,'F','J') + "'" 						+ CRLF
    endif
    cQuery += "        AND A1.A1_EST BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " 				+ CRLF
	
	cQuery += " GROUP  BY C5_NUM, C5_CHVBPAG, C5_XNPSITE, C5_XORIGPV, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_CONDPAG, " + CRLF 
	cQuery += "   	    C5_XNATURE, C5_TOTPED, C6_CF, C6_TES, C5_TIPO, C6_ITEM, C6_PRODUTO, B1_DESC, C6_XOPER " + CRLF
	
	cQuery += " ORDER BY C5_NUM, C6_ITEM ASC"
	
	//MEMOWRITE("C:\Protheus\TESTE.sql",cQuery)
	If Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIf

	// *** Abre Tabelas *** //
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasA , .F., .T.) 

Return cAliasA

//+----------------------------------------------------------------+
//| Rotina | CriaSx1 | Autor | Rafael Beghini | Data | 24/03/2015  |
//+----------------------------------------------------------------+
//| Descr. | Cria as Perguntas usadas no parametro.                |
//|        |                                                       |
//+----------------------------------------------------------------+
Static Function CriaSx1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}
	
	/***
	Característica do vetor p/ utilização da função SX1
	---------------------------------------------------
	[n,1] --> texto da pergunta
	[n,2] --> tipo do dado
	[n,3] --> tamanho
	[n,4] --> decimal
	[n,5] --> objeto G=get ou C=choice
	[n,6] --> validacao
	[n,7] --> F3
	[n,8] --> definicao 1
	[n,9] --> definicao 2
	[n,10] -> definicao 3
	[n,11] -> definicao 4
	[n,12] -> definicao 5
	***/
	aAdd(aP,{"Pedido de"                  ,"C",6,0,"G",""                    ,"SC5",""   ,""   ,"","",""})//MV_PAR01
	aAdd(aP,{"Pedido ate"                 ,"C",6,0,"G","(mv_par02>=mv_par01)","SC5",""   ,""   ,"","",""})//MV_PAR02
	aAdd(aP,{"Cliente de"                 ,"C",6,0,"G",""                    ,"SA1",""   ,""   ,"","",""})//MV_PAR03
	aAdd(aP,{"Cliente ate"                ,"C",6,0,"G","(mv_par04>=mv_par03)","SA1",""   ,""   ,"","",""})//MV_PAR04
	aAdd(aP,{"Emissão de"                 ,"D",8,0,"G",""                    ,""   ,""   ,""   ,"","",""})//MV_PAR05
	aAdd(aP,{"Emissão ate"                ,"D",8,0,"G","(mv_par06>=mv_par05)",""   ,""   ,""   ,"","",""})		
	aAdd(aP,{"Estado de    "              ,"C",2,0,"G","					","12"   ,""   ,""   ,"","",""})//MV_PAR07
	aAdd(aP,{"Estado até    "             ,"C",2,0,"G","					","12"   ,""   ,""   ,"","",""})//MV_PAR08
	aAdd(aP,{"Tipo de pessoa"             ,"C",1,0,"C","                    ",""     ,"Física"   ,"Jurídica"   ,"Ambos","",""})//MV_PAR09

	aAdd(aHelp,{"Informe o código do pedido.","inicial."})
	aAdd(aHelp,{"Informe o código do pedido.","final."})
	aAdd(aHelp,{"Cliente inicial."})
	aAdd(aHelp,{"Cliente final."})
	aAdd(aHelp,{"Digite a data de emissão incial."})
	aAdd(aHelp,{"Digite a data de emissão final."})

	aAdd(aHelp,{"Informe o tipo de pessoa física / jurídica."})
	aAdd(aHelp,{"Informe o código do estado.","inicial."})
	aAdd(aHelp,{"Informe o código do estado.","final."})

	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		"",;
		"",;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		"",;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i
	
Return