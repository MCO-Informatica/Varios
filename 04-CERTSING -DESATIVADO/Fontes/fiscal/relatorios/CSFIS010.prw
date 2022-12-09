#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE 'topconn.ch' 
#INCLUDE 'fileio.ch'
#INCLUDE "MSOLE.CH"
                     
//+----------------------------------------------------------------+
//| Rotina | CSFIS010 | Autor | Rafael Beghini | Data | 03/03/2015 |
//+----------------------------------------------------------------+
//| Descr. | Geração de Relatório Mapa imposto : PCC/IRRF          |
//|        | Utiliza DOT Padrao: COMRETIR		                   |
//+----------------------------------------------------------------+
//| Uso    | Financeiro / Fiscal [CertiSign]                       |
//+----------------------------------------------------------------+
User Function CSFIS010()

	Local nOpc := 0
	
	Local aSay := {}
	Local aButton := {}
	Local cCadastro := 'Mapa de Imposto'	
	Local cPerg := "MTA982"

	Pergunte(cPerg,.F.)
	
	AAdd( aSay, 'Esta rotina irá gerar o Mapa de Imposto: PCC/IRRF' )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em Parâmetros para preenchimento e depois' )
	AAdd( aSay, 'clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpc := 1, FechaBatch() } } )
	aAdd( aButton, { 05, .T., {|| Pergunte(cPerg,.T. )    }} )
	AAdd( aButton, { 02, .T., { || FechaBatch() } } )

	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpc == 1
		GeraArquivo()
	Endif
	
Return

//+----------------------------------------------------------------+
//| Rotina | CSFIS010 | Autor | Rafael Beghini | Data | 03/03/2015 |
//+----------------------------------------------------------------+
//| Descr. | Geração de Relatório Mapa imposto : PCC/IRRF          |
//|        | Utiliza DOT Padrao: COMRETIR		                   |
//+----------------------------------------------------------------+
//| Uso    | Financeiro / Fiscal		                           |
//+----------------------------------------------------------------+
Static Function GeraArquivo()

	Local cAlias 	:= GetNextAlias()   
	Local nRecSRA   := 0    
	Local nLinha    := 0
	Local cFornece  := ''   
	Local nPos      := nVlr := nTx := nVlrIr := nTxIr := 0
	
	Private aFornece := {}  
	Private aTotal   := {}  
	Private aPcc1    := {}
	Private aPcc2    := {}
	Private aPcc3    := {}
	Private aPcc4    := {}
	Private aPcc5    := {}
	Private aPcc6    := {}
	Private aPcc7    := {}
	Private aPcc8    := {}
	Private aPcc9    := {}
	Private aPcc10   := {}
	Private aPcc11   := {}
	Private aPcc12   := {}  
	
	Private lGerou := .F.
		
	If MontaQry(cAlias, @nRecSRA)
	
		For nL:=1 To Len(aFornece)
			cFornece := aFornece[nL]
			
			QryIR(cFornece)
			
			/* MES 01 */
			If !Empty(aPcc1)
				nPos := AScan( aPcc1, {|e| e[1]==cFornece } )
				For nL1:=nPos To Len(aPcc1)
					If aPcc1[nL1,1] == cFornece
		   				If aPcc1[nL1,2] == "5952"
				   			nVlr += aPcc1[nL1,3]
							nTx  += aPcc1[nL1,4]
						Else
					   		nVlrIr += aPcc1[nL1,3]
					   		nTxIr  += aPcc1[nL1,4]		
						EndIf
					EndIf
				Next nL1                   
				
				aAdd( aTotal, {nVlr,nTx,1,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,1,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0 
			EndIf
			
			/* MES 02 */
			If !Empty(aPcc2)
				nPos := AScan( aPcc2, {|e| e[1]==cFornece } )
				For nL2:=nPos To Len(aPcc2)
					If aPcc2[nL2,1] == cFornece
						If aPcc2[nL2,2] == "5952"
				   			nVlr += aPcc2[nL2,3]
							nTx  += aPcc2[nL2,4]
						Else
					   		nVlrIr += aPcc2[nL2,3]
					   		nTxIr  += aPcc2[nL2,4]		
						EndIf
					EndIf 
				Next nL2
				                 
				aAdd( aTotal, {nVlr,nTx,2,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,2,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0   
			EndIf
			
			/* MES 03 */ 
			If !Empty(aPcc3)
				nPos := AScan( aPcc3, {|e| e[1]==cFornece } )
				For nL3:=nPos To Len(aPcc3)
					If aPcc3[nL3,1] == cFornece
						If aPcc3[nL3,2] == "5952"
				   			nVlr += aPcc3[nL3,3]
							nTx  += aPcc3[nL3,4]
						Else
					   		nVlrIr += aPcc3[nL3,3]
					   		nTxIr  += aPcc3[nL3,4]		
						EndIf
					EndIf 
				Next nL3
				                 
				aAdd( aTotal, {nVlr,nTx,3,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,3,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0    
			EndIf
			
			/* MES 04 */ 
			If !Empty(aPcc4)
				nPos := AScan( aPcc4, {|e| e[1]==cFornece } )
				For nL4:=nPos To Len(aPcc4)
					If aPcc4[nL4,1] == cFornece
						If aPcc4[nL4,2] == "5952"
				   			nVlr += aPcc4[nL4,3]
							nTx  += aPcc4[nL4,4]
						Else
					   		nVlrIr += aPcc4[nL4,3]
					   		nTxIr  += aPcc4[nL4,4]		
						EndIf
					EndIf 
				Next nL4
				                 
				aAdd( aTotal, {nVlr,nTx,4,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,4,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0    
			EndIf
			
			/* MES 05 */ 
			If !Empty(aPcc5)
				nPos := AScan( aPcc5, {|e| e[1]==cFornece } )
				For nL5:=nPos To Len(aPcc5)
					If aPcc5[nL5,1] == cFornece
						If aPcc5[nL5,2] == "5952"
				   			nVlr += aPcc5[nL5,3]
							nTx  += aPcc5[nL5,4]
						Else
					   		nVlrIr += aPcc5[nL5,3]
					   		nTxIr  += aPcc5[nL5,4]		
						EndIf
					EndIf 
				Next nL5
				                 
				aAdd( aTotal, {nVlr,nTx,5,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,5,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0  
			EndIf  
			
			/* MES 06 */ 
			If !Empty(aPcc6)
				nPos := AScan( aPcc6, {|e| e[1]==cFornece } )
				For nL6:=nPos To Len(aPcc6)
					If aPcc6[nL6,1] == cFornece
						If aPcc6[nL6,2] == "5952"
				   			nVlr += aPcc6[nL6,3]
							nTx  += aPcc6[nL6,4]
						Else
					   		nVlrIr += aPcc6[nL6,3]
					   		nTxIr  += aPcc6[nL6,4]		
						EndIf
					EndIf 
				Next nL6
				                 
				aAdd( aTotal, {nVlr,nTx,6,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,6,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0     
			EndIf
			
			/* MES 07 */   
			If !Empty(aPcc7)
				nPos := AScan( aPcc7, {|e| e[1]==cFornece } )
				For nL7:=nPos To Len(aPcc7)
					If aPcc7[nL7,1] == cFornece
						If aPcc7[nL7,2] == "5952"
				   			nVlr += aPcc7[nL7,3]
							nTx  += aPcc7[nL7,4]
						Else
					   		nVlrIr += aPcc7[nL7,3]
					   		nTxIr  += aPcc7[nL7,4]		
						EndIf
					EndIf 
				Next nL7
				                 
				aAdd( aTotal, {nVlr,nTx,7,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,7,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0   
			EndIf 
			
			/* MES 08 */ 
			If !Empty(aPcc8)
				nPos := AScan( aPcc8, {|e| e[1]==cFornece } )
				For nL8:=nPos To Len(aPcc8)
					If aPcc8[nL8,1] == cFornece
						If aPcc8[nL8,2] == "5952"
				   			nVlr += aPcc8[nL8,3]
							nTx  += aPcc8[nL8,4]
						Else
					   		nVlrIr += aPcc8[nL8,3]
					   		nTxIr  += aPcc8[nL8,4]		
						EndIf
					EndIf 
				Next nL8
				                 
				aAdd( aTotal, {nVlr,nTx,8,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,8,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0   
			EndIf 
			
			/* MES 09 */  
			If !Empty(aPcc9)
				nPos := AScan( aPcc9, {|e| e[1]==cFornece } )
				For nL9:=nPos To Len(aPcc9)
					If aPcc9[nL9,1] == cFornece
						If aPcc9[nL9,2] == "5952"
				   			nVlr += aPcc9[nL9,3]
							nTx  += aPcc9[nL9,4]
						Else
					   		nVlrIr += aPcc9[nL9,3]
					   		nTxIr  += aPcc9[nL9,4]		
						EndIf
					EndIf 
				Next nL9
				                 
				aAdd( aTotal, {nVlr,nTx,9,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,9,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0   
			EndIf 
			
			/* MES 10 */  
			If !Empty(aPcc10)
				nPos := AScan( aPcc10, {|e| e[1]==cFornece } )
				For nL10:=nPos To Len(aPcc10)
					If aPcc10[nL10,1] == cFornece
						If aPcc10[nL10,2] == "5952"
				   			nVlr += aPcc10[nL10,3]
							nTx  += aPcc10[nL10,4]
						Else
					   		nVlrIr += aPcc10[nL10,3]
					   		nTxIr  += aPcc10[nL10,4]		
						EndIf
					EndIf 
				Next nL10
				                 
				aAdd( aTotal, {nVlr,nTx,10,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,10,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0    
			EndIf
			
			/* MES 11 */  
			If !Empty(aPcc11)
				nPos := AScan( aPcc11, {|e| e[1]==cFornece } )
				For nL11:=nPos To Len(aPcc11)
					If aPcc11[nL11,1] == cFornece
						If aPcc11[nL11,2] == "5952"
				   			nVlr += aPcc11[nL11,3]
							nTx  += aPcc11[nL11,4]
						Else
					   		nVlrIr += aPcc11[nL11,3]
					   		nTxIr  += aPcc11[nL11,4]		
						EndIf
					EndIf 
				Next nL11
				                 
				aAdd( aTotal, {nVlr,nTx,11,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,11,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0    
			EndIf
			
			/* MES 12 */   
			If !Empty(aPcc12)
				nPos := AScan( aPcc12, {|e| e[1]==cFornece } )
				For nL12:=nPos To Len(aPcc12)
					If aPcc12[nL12,1] == cFornece
						If aPcc12[nL12,2] == "5952"
				   			nVlr += aPcc12[nL12,3]
							nTx  += aPcc12[nL12,4]
						Else
					   		nVlrIr += aPcc12[nL12,3]
					   		nTxIr  += aPcc12[nL12,4]		
						EndIf
					EndIf 
				Next nL12
				                 
				aAdd( aTotal, {nVlr,nTx,12,"5952"} )
				aAdd( aTotal, {nVlrIr,nTxIr,12,"1708"} )
				nVlr := nTx := nVlrIr := nTxIr := 0    
			EndIf
			
			lGerou := .T.
		    ImpWord(aTotal,cFornece)
		Next nL
		
	Else
		MsgBox("Não há dados. Favor vertificar os Parâmetros.","Atenção","ALERT")
	EndIf   

Return


//+-----------------------------------------------------------------+
//| Rotina | MontaQry | Autor | Rafael Beghini | Data | 03/03/2015  |
//+-----------------------------------------------------------------+
//| Descr. | Cria a query a partir dos parametros informados.       |
//|        | 		                                                |
//+-----------------------------------------------------------------+

Static Function MontaQry(cAlias, nRecSRA)

	Local nValPis := 0
	Local nValCof := 0
	Local nValCsl := 0
	Local cParcCof:= 0 
	Local cParcPIS:= 0
	Local cParCSLL:= 0
	Local _aFornece := {}
	Local cCodReten := 0  
	Local dVencReal  
	Local dVcto  
	
	Local cQuery := ''
	Local cFornece := ''
	Local cForNext := ''
	Local lRetorno := .F. 
	Local pLinha := chr(13) + chr(10) 
	
	cQuery := "SELECT DISTINCT"+pLinha
	cQuery += "  F1.F1_FORNECE COD_FOR,"+pLinha
	cQuery += "  (SELECT A2.A2_NOME FROM "+RetSqlName("SA2")+" A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.D_E_L_E_T_ = ' ') NOME,"+pLinha
	cQuery += "  (SELECT A2.A2_CGC FROM  "+RetSqlName("SA2")+" A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.D_E_L_E_T_ = ' ') CNPJ,"+pLinha
	cQuery += "  E2_NUM NUMERO, "+pLinha
	cQuery += "  E2_BASECSL BASEPCC,"+pLinha
	cQuery += "  E2_PARCCOF,"+pLinha
	cQuery += "  E2_PARCPIS,"+pLinha
	cQuery += "  E2_PARCSLL,"+pLinha
	cQuery += "  E2_COFINS VALCOF,"+pLinha
	cQuery += "  E2_PIS VALPIS,"+pLinha
	cQuery += "  E2_CSLL VALCSL,"+pLinha
	cQuery += "  E2.E2_PREFIXO PREFIXO,"+pLinha
	cQuery += "  E2.E2_VENCREA VENC_REAL,"+pLinha
	cQuery += "  E2.E2_PARCELA PARCELA,"+pLinha
	cQuery += "  F1.F1_FILIAL FILIAL"+pLinha
	cQuery += "FROM "+RetSqlName("SE2")+" E2"+pLinha 
	cQuery += "  LEFT OUTER JOIN "+RetSqlName("SF1")+" F1 ON E2_NUM = F1_DOC "+pLinha
	cQuery += "    AND E2.E2_FORNECE = F1.F1_FORNECE AND F1.D_E_L_E_T_ = ' '"+pLinha
	cQuery += "  INNER JOIN "+RetSqlName("SD1")+" D1 ON D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = E2.E2_FORNECE "+pLinha
	cQuery += "    AND D1.D1_DOC= E2.E2_NUM AND D1.D_E_L_E_T_ = ' '"+pLinha
	cQuery += "WHERE"+pLinha
	cQuery += "  SUBSTR(E2.E2_VENCREA,1,4) = '"+Alltrim(Str(Mv_Par01))+"' AND"+pLinha
	cQuery += "  E2.E2_FORNECE BETWEEN '"+Mv_Par05+"' AND '"+Mv_Par06+"' AND"+pLinha
	cQuery += "  E2.E2_TIPO = 'NF' AND "+pLinha
	cQuery += "  (E2.E2_VRETPIS <> 0 OR E2.E2_VRETCOF <> 0 OR E2.E2_VRETCSL <> 0 ) AND"+pLinha
	cQuery += "  E2.D_E_L_E_T_ = ' ' "+pLinha
	
	cQuery += "ORDER BY E2.E2_VENCREA, F1.F1_FORNECE ASC"+pLinha

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.) 
	
	Count To nRecSRA
	
	//Verifica se dados na tabela temporaria
	If nRecSRA > 0
		lRetorno := .T.   
	EndIf
	  
	DbSelectArea(cAlias) 
	(cAlias)->(dbGoTop())
	
	While !(cAlias)->(EOF())
	
		nValPis := (cAlias)->VALPIS
		nValCof := (cAlias)->VALCOF
		nValCsl := (cAlias)->VALCSL
		cPrefix := (cAlias)->PREFIXO
		//nSumPCC := nValCsl + nValCof + nValPis  
		cNumTit := (cAlias)->NUMERO
		cParcCof:= (cAlias)->E2_PARCCOF
		cParcPIS:= (cAlias)->E2_PARCPIS
		cParCSLL:= (cAlias)->E2_PARCSLL  //E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
		
		DbSelectArea("SE2")
		DbSetOrder(1) //E2_FILIAL+E2_NATUREZ+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE
		
		If nValPis > 0
			//DbSeek(xFilial("SE2")+Space(Len(SE2->E2_PREFIXO))+cNumTit+cParcPIS+"TX")
			If DbSeek(xFilial("SE2")+cPrefix+cNumTit+cParcPIS+"TX")
				nValPis := SE2->E2_VALOR
				dVencReal := SE2->E2_VENCREA 
				cCodReten := SE2->E2_CODRET
			Else
				nValPis   := 0
				dVencReal := CtoD("  /  /  ") 
				cCodReten := ""
			EndIf
		EndIf
		If nValCof > 0 
			If DbSeek(xFilial("SE2")+cPrefix+cNumTit+cParcCOF+"TX")
				nValCof := SE2->E2_VALOR
				dVencReal := SE2->E2_VENCREA 
				cCodReten := SE2->E2_CODRET
			Else
				nValCof   := 0
				dVencReal := CtoD("  /  /  ") 
				cCodReten := ""
			EndIf
		EndIf
		If nValCSL > 0 
			If DbSeek(xFilial("SE2")+cPrefix+cNumTit+cParCSLL+"TX")
		 		nValCSL := SE2->E2_VALOR 
		 		dVencReal := SE2->E2_VENCREA 
				cCodReten := SE2->E2_CODRET
			Else
				nValCSL   := 0
				dVencReal := CtoD("  /  /  ") 
				cCodReten := ""
			EndIf
		EndIf 
		
		nSumPCC := nValCsl + nValCof + nValPis
		
		nCompet := Month( StoD( (cAlias)->Venc_Real ) )
		
		Do Case 
			Case nCompet == 1;  aAdd( aPcc1, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 2;  aAdd( aPcc2, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 3;  aAdd( aPcc3, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 4;  aAdd( aPcc4, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 5;  aAdd( aPcc5, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 6;  aAdd( aPcc6, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 7;  aAdd( aPcc7, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 8;  aAdd( aPcc8, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 9;  aAdd( aPcc9, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 10; aAdd( aPcc10, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 11; aAdd( aPcc11, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
			Case nCompet == 12; aAdd( aPcc12, {(cAlias)->COD_FOR, cCodReten, (cAlias)->BASEPCC, nSumPCC, nCompet } )
		End Case 
		        				
	    If cFornece <> (cAlias)->COD_FOR
	    	aAdd(_aFornece, (cAlias)->COD_FOR )
	    EndIf
	    
	    cFornece := (cAlias)->COD_FOR
	    
		(cAlias)->(dbSkip())   
	
	EndDo 
	
	SE2->(dbCloseArea())
	(cAlias)->(dbCloseArea()) 
	
    aFornece := aClone(_aFornece)
   
Return(lRetorno)   

//+----------------------------------------------------------------+
//| Rotina | ImpWord | Autor | Rafael Beghini | Data | 03/03/2015  |
//+----------------------------------------------------------------+
//| Descr. | Geração de arquivo WORD			                   |
//+----------------------------------------------------------------+
Static Function ImpWord(aTotal,cFornece)    

   	Local cFilOri	:= SM0->M0_CODFIL     
    Local cCnpj		:= SM0->M0_CGC
	Local cRazao	:= SM0->M0_NOME  
	Local cNomeArq	:= "CompRet"
	Local cSaidaDoc := ''
	Local cSaidaPDF := ''    
	Local nNomeArq	:= 0
	Local nLin      := 0     
	Local nVar4Word	:= 30   	
	Local oleWdFormatPDF := ''
		
	Private	cPath	 :=	""
	Private	cArquivo :=	""

	cArquivo :=	Alltrim (MV_PAR02)
	cPath	 :=	AllTrim (MV_PAR03)
                                    
	oleWdFormatPDF := '17'

	If !(File (cPath+cArquivo))
		Help(" ",1,"A9810001") //"Arquivo de Modelo nao encontrado !!"
		Return (lRet)
	Endif
	
	cWord	:=	OLE_CreateLink ()
	If (cWord < "0")
		Help(" ",1,"A9810004") //"MS-WORD nao encontrado nessa maquina !!"
		Return (lRet)
	Endif                              
	
	OLE_SetProperty(cWord, oleWdVisible  ,.F. )    

	If (lGerou)
		If (cWord >= "0")		
			OLE_CloseLink(cWord) //fecha o Link com o Word
			cWord	:=	OLE_CreateLink ()
			OLE_NewFile (cWord, cPath+cArquivo)
			
			DbSelectArea ("SA2")
			SA2->(MsSeek (xFilial("SA2")+cFornece))  
			  
			OLE_SetDocumentVar (cWord, "c_Calendario" , StrZero (MV_PAR01, 4))
			OLE_SetDocumentVar (cWord, "c_Nome1" , cRazao)
			OLE_SetDocumentVar (cWord, "c_Cnpj1" , Transform (cCnpj, "@R 99.999.999/9999-99"))
			OLE_SetDocumentVar (cWord, "c_Nome2" , SA2->A2_NOME)
			OLE_SetDocumentVar (cWord, "c_Cnpj2" , Transform (SA2->A2_CGC, "@R 99.999.999/9999-99"))
			
			For nLin:=1 To Len(aTotal)
				OLE_SetDocumentVar (cWord, "c_Mes"+AllTrim (Str (nLin)), MesExtenso(aTotal[nLin,3]) )
				OLE_SetDocumentVar (cWord, "c_Codigo"+AllTrim (Str (nLin)), aTotal[nLin,4] )
				OLE_SetDocumentVar (cWord, "c_ValorPg"+AllTrim (Str (nLin)), Transform(aTotal[nLin,1], "@R 999,999,999,999.99") )
				OLE_SetDocumentVar (cWord, "c_ValorRet"+AllTrim (Str (nLin)), Transform(aTotal[nLin,2], "@R 999,999,999,999.99") )
			Next nLin
			           
			For nY := nLin To nVar4Word
				OLE_SetDocumentVar (cWord, "c_Mes"+AllTrim (Str (nY)), " ")
				OLE_SetDocumentVar (cWord, "c_Codigo"+AllTrim (Str (nY)), " ")
				OLE_SetDocumentVar (cWord, "c_ValorPg"+AllTrim (Str (nY)), " ")
				OLE_SetDocumentVar (cWord, "c_ValorRet"+AllTrim (Str (nY)), " ")
			Next (nY)
			nCtd4Word	:=	1
						
			OLE_SetDocumentVar (cWord, "c_Nome5", AllTrim (MV_PAR04))
			
			OLE_UpdateFields(cWord)
			
			nNomeArq++
			cSaidaDOC := AllTrim (MV_PAR10)+cNomeArq+StrZero (nNomeArq, 3)+".DOC"		
			cSaidaPDF := AllTrim (MV_PAR10)+cNomeArq+StrZero (nNomeArq, 3)+".PDF"		
			/*
			If (MV_PAR09==1)
				OLE_PrintFile(cWord,"ALL",,,) 
				Sleep(250)                               
				
				cSaidaDOC := AllTrim (MV_PAR10)+cNomeArq+StrZero (nNomeArq, 3)+".DOC"
				
				// Abrir o arquivo no formato DOC.
				OLE_OpenFile( cWord, cSaidaDOC )
			Else
			*/
				OLE_SaveAsFile (cWord, cSaidaDOC )  
				Sleep(250)
				
				// Abrir o arquivo no formato DOC.
				OLE_OpenFile( cWord, cSaidaDOC )  
				
				// Salvar o arquivo no formato PDF.
				OLE_SaveAsFile( cWord, cSaidaPDF, /*cPassword*/, /*cWritePassword*/, .F., oleWdFormatPDF )
				Sleep(250) 
				
				// Fechar a conexão com o arquivo.
				OLE_CloseFile( cWord )
				
				// Desfazer o link.
				OLE_CloseLink( cWord )
				
				// Apagar o arquivo word que foi aqui gerado.
				FErase( cSaidaDOC )
				Sleep(250)
				
				ShellExecute( 'Open', cSaidaPDF, '', '', 1 )	
			//EndIF
		EndIf
	EndIf	

Return

//+-------------------------------------------------------------+
//| Rotina | QryIR | Autor | Rafael Beghini | Data | 03/03/2015 |
//+-------------------------------------------------------------+
//| Descr. | Cria a query para valores de IRRF                  |
//|        | 		                                            |
//+-------------------------------------------------------------+
Static Function QryIR(cFornece)
      
	Local cQuery  := ''
	Local pLinha  := chr(13) + chr(10) 
	Local cAliasB := GetNextAlias()  
	Local cAliasC := GetNextAlias() 
	Local cNumNF  := ''    
	Local cCodRet := '' 
	Local cVcto   := ''
	Local nCompet := 0
	                                 
	cQuery := "SELECT"+pLinha 
	cQuery += "	F1.F1_FORNECE COD_FOR,"+pLinha
	cQuery += "	(SELECT A2.A2_NOME FROM "+RetSqlName("SA2")+" A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.D_E_L_E_T_ = ' ') NOME,"+pLinha
	cQuery += "	(SELECT A2.A2_CGC FROM "+RetSqlName("SA2")+" A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.D_E_L_E_T_ = ' ') CNPJ,"+pLinha
	cQuery += "	E2.E2_NUM NUMERO,"+pLinha                                                                                                    
	cQuery += "	D1.D1_ALIQIRR ALIQIRRF,"+pLinha
	cQuery += "	D1.D1_BASEIRR BASEIRR,"+pLinha
	cQuery += "	D1.D1_VALIRR VLIRR,"+pLinha
	cQuery += "	F1.F1_EMISSAO AS EMISSAO,"+pLinha
	cQuery += " F1.F1_DTDIGIT AS DTDIGIT "+pLinha
	cQuery += "FROM"+pLinha
	cQuery += ""+RetSqlName("SE2")+" E2 LEFT OUTER JOIN "+RetSqlName("SF1")+" F1 ON E2_NUM = F1_DOC AND "+pLinha
	cQuery += "E2.E2_FORNECE = F1.F1_FORNECE AND E2.E2_LOJA = F1.F1_LOJA INNER JOIN "+pLinha
	cQuery += ""+RetSqlName("SD1")+" D1 ON D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = E2.E2_FORNECE AND D1.D1_SERIE = E2.E2_PREFIXO"+pLinha
	cQuery += "WHERE"+pLinha
	cQuery += "SUBSTR(F1.F1_DTDIGIT,1,4) = '"+Alltrim(Str(Mv_Par01))+"' AND"+pLinha
	cQuery += "F1.F1_FORNECE = '"+cFornece+"' AND"+pLinha      
	cQuery += "E2.E2_TIPO IN ('NF') AND"+pLinha
	cQuery += "E2.E2_IRRF <> 0 AND"+pLinha
	cQuery += "E2.D_E_L_E_T_ = ' ' AND"+pLinha
	cQuery += "F1.D_E_L_E_T_ = ' ' AND"+pLinha
	cQuery += "D1.D_E_L_E_T_ = ' ' "+pLinha
	cQuery += "ORDER BY E2.E2_VENCREA ASC"+pLinha   
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasB, .F., .T.) 
	
	DbSelectArea(cAliasB) 
	(cAliasB)->(dbGoTop())
	
	While !(cAliasB)->(EOF()) 
		
		cNumNF := (cAliasB)->NUMERO
		cDtEmi := (cAliasB)->EMISSAO
		
		cQuery := "SELECT"+pLinha
		cQuery += "SE2.E2_CODRET CODRET,"+pLinha 
		//cQuery += "SubStr(SE2.E2_EMISSAO,7,2)||'/'||SubStr(SE2.E2_EMISSAO,5,2)||'/'||SubStr(SE2.E2_EMISSAO,1,4) EMISSAO,"+pLinha
		//cQuery += "SubStr(SE2.E2_VENCTO,7,2)||'/'||SubStr(SE2.E2_VENCTO,5,2)||'/'||SubStr(SE2.E2_VENCTO,1,4) VENCIMENTO,"+pLinha
		cQuery += "SE2.E2_VENCREA VENCREAL"+pLinha
		cQuery += "FROM"+pLinha
		cQuery += ""+RetSqlName("SE2")+" SE2"+pLinha
		cQuery += "WHERE"+pLinha
		cQuery += "SE2.E2_NUM = '"+cNumNF+"' AND"+pLinha
		cQuery += "SE2.E2_NATUREZ IN ('SF410001') AND"+pLinha
		cQuery += "SE2.E2_EMISSAO = '"+cDtEmi+"'  AND"+pLinha
	   	cQuery += "SUBSTR(SE2.E2_TITPAI,18,6) = '"+cFornece+"' AND"+pLinha      
	   	cQuery += "SE2.D_E_L_E_T_ = ' '"+pLinha
       
        dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasC, .F., .T.) 
	
		DbSelectArea(cAliasC) 
		(cAliasC)->(dbGoTop())
		
		While !(cAliasC)->(EOF()) 
			cCodRet := (cAliasC)->CODRET
			cVcto   := (cAliasC)->VENCREAL
			(cAliasC)->(dBSkip())
		End  
		(cAliasC)->(dbCloseArea()) 
		
		nCompet := Month( StoD( cVcto ) )		

		Do Case 
			Case nCompet == 1;  aAdd( aPcc1, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 2;  aAdd( aPcc2, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 3;  aAdd( aPcc3, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 4;  aAdd( aPcc4, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 5;  aAdd( aPcc5, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 6;  aAdd( aPcc6, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 7;  aAdd( aPcc7, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 8;  aAdd( aPcc8, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 9;  aAdd( aPcc9, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 10; aAdd( aPcc10, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 11; aAdd( aPcc11, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
			Case nCompet == 12; aAdd( aPcc12, {cFornece, cCodRet, (cAliasB)->BASEIRR, (cAliasB)->VLIRR, nCompet } )
		End Case 
    
	(cAliasB)->(dbSkip())  
	EndDo                      
	
	(cAliasB)->(dbCloseArea()) 
	
Return