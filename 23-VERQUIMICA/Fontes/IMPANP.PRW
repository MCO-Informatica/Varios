#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE DMPAPER_A4 9
#DEFINE CRLF (Chr(13)+Chr(10))

User Function IMPANP()

Processa( {|| xImpAnp() }, "Gerando arquivo txt...", "Carregando definição dos campos...",.F.)

Return()

Static Function xImpAnp()

Local oReport            
Private _nSeqLin	:= 0     
Private _nQtdReg	:= 1
Private _cLinAnp	:= ""  
Private _aTotais    := {}   
Private _aTotProd	:= {}
Private _aTotPad	:= {}     
Private _aTPrdCons	:= {}     
Private _aArrQtd	:= {}  
Private nPos2	:= 0

//Vendas
cQry := "SELECT * FROM ( SELECT 	"
cQry += "'C' AS ESPECIE, 			"
cQry += "SF2.F2_TIPO AS TIPO, 		"
cQry += "SF2.F2_CLIENTE AS CLIFOR, 	"
cQry += "SF2.F2_LOJA AS LOJA, 		"
cQry += "SB5.B5_CODANP AS PRODUTO, 	"
cQry += "SUM(SD2.D2_QUANT) AS QTDKG,"
cQry += "SUM(SD2.D2_QTSEGUM) AS QTDLT,"
cQry += "SB1.B1_CONV AS DENSIDADE,  "
cQry += "SF2.F2_EMISSAO AS EMISSAO, "
cQry += "SF2.F2_CHVNFE AS CHAVENFE, "
cQry += "SF2.F2_DOC AS DOC, 	"
cQry += "SF2.F2_SERIE AS SERIE 	"
cQry += "FROM 					"
cQry += RetSQLName("SF2")+" SF2 "
cQry += "JOIN "+RetSQLName("SD2")+" SD2 ON  SF2.F2_DOC = SD2.D2_DOC "
cQry += "                				AND SF2.F2_SERIE = SD2.D2_SERIE "
cQry += "                				AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "
cQry += "                				AND SF2.F2_LOJA = SD2.D2_LOJA "
cQry += "                				AND SD2.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SD2.D2_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SF4.F4_CODIGO = SD2.D2_TES "
cQry += "                				AND SF4.D_E_L_E_T_ <> '*' "
cQry += "                				AND SF4.F4_VQENTAN <> 'N' "
cQry += "WHERE "                                           
cQry += "SF2.D_E_L_E_T_ <> '*' "      
cQry += "AND SF2.F2_FILIAL = '" +xFilial("SF2")+ "' "
cQry += "AND SD2.D2_FILIAL = '" +xFilial("SD2")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SF4.F4_FILIAL = '" +xFilial("SF4")+ "' "
cQry += "AND SF2.F2_TIPO NOT IN ('C', 'I', 'P') "
cQry += "AND SF2.F2_EMISSAO BETWEEN '20160401' AND '20160430' "
cQry += "GROUP BY "
cQry += "SF2.F2_CLIENTE, "
cQry += "SF2.F2_LOJA, "
cQry += "SF2.F2_TIPO, "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "                                                                   	
cQry += "SF2.F2_EMISSAO, "
cQry += "SF2.F2_CHVNFE, SF2.F2_DOC, SF2.F2_SERIE "

cQry += "UNION ALL "

//Compras
cQry += "SELECT "
cQry += "'B' AS ESPECIE, "
cQry += "SF1.F1_TIPO AS TIPO, "
cQry += "SF1.F1_FORNECE AS CLIFOR, "
cQry += "SF1.F1_LOJA AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SD1.D1_QUANT) AS QTDKG, "
cQry += "SUM(SD1.D1_QTSEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "SF1.F1_DTDIGIT AS EMISSAO, "
cQry += "SF1.F1_CHVNFE AS CHAVENFE, "
cQry += "SF1.F1_DOC AS DOC, "
cQry += "SF1.F1_SERIE AS SERIE "
cQry += "FROM "
cQry += RetSQLName("SF1")+" SF1 "
cQry += "JOIN "+RetSQLName("SD1")+" SD1 ON  SF1.F1_DOC = SD1.D1_DOC "
cQry += "                				AND SF1.F1_SERIE = SD1.D1_SERIE "
cQry += "                				AND SF1.F1_FORNECE = SD1.D1_FORNECE "
cQry += "                				AND SF1.F1_LOJA = SD1.D1_LOJA "
cQry += "                				AND SD1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SD1.D1_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "JOIN "+RetSQLName("SF4")+" SF4 ON  SF4.F4_CODIGO = SD1.D1_TES "
cQry += "                				AND SF4.D_E_L_E_T_ <> '*' "
cQry += "                				AND SF4.F4_VQENTAN <> 'N' "
cQry += "WHERE "
cQry += "SF1.D_E_L_E_T_ <> '*' "     
cQry += "AND SF1.F1_FILIAL = '" +xFilial("SF1")+ "' "
cQry += "AND SD1.D1_FILIAL = '" +xFilial("SD1")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SF4.F4_FILIAL = '" +xFilial("SF4")+ "' "
cQry += "AND SF1.F1_TIPO NOT IN ('C', 'I', 'P') "
cQry += "AND SF1.F1_DTDIGIT BETWEEN '20160401' AND '20160430' "
cQry += "GROUP BY "
cQry += "SF1.F1_FORNECE, "
cQry += "SF1.F1_LOJA, "
cQry += "SF1.F1_TIPO, "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SF1.F1_DTDIGIT, "
cQry += "SF1.F1_CHVNFE, SF1.F1_DOC , SF1.F1_SERIE"

cQry += "UNION ALL "

cQry += "SELECT "
cQry += "'A' AS ESPECIE, "
cQry += "'' AS TIPO, "
cQry += "'' AS CLIFOR, "
cQry += "'' AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SB9.B9_QINI) AS QTDKG, "
cQry += "SUM(SB9.B9_QISEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "'20160401' AS EMISSAO, "
cQry += "RPAD('0', 44, '0') AS CHAVENFE, "
cQry += "RPAD('0', 9, '0') AS DOC, "
cQry += "RPAD('0', 3, '0') AS SERIE "
cQry += "FROM "
cQry += RetSQLName("SB9")+" SB9 "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SB9.B9_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "WHERE "
cQry += "SB9.D_E_L_E_T_ <> '*' "  
cQry += "AND SB9.B9_FILIAL = '" +xFilial("SB9")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SB9.B9_QINI > 0 "
cQry += "AND SB9.B9_DATA = '20160331' "
cQry += "GROUP BY "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SB9.B9_DATA "

cQry += "UNION ALL "

//Saldo Final
cQry += "SELECT "
cQry += "'D' AS ESPECIE, "
cQry += "'' AS TIPO, "
cQry += "'' AS CLIFOR, "
cQry += "'' AS LOJA, "
cQry += "SB5.B5_CODANP AS PRODUTO, "
cQry += "SUM(SB9.B9_QINI) AS QTDKG, "
cQry += "SUM(SB9.B9_QISEGUM) AS QTDLT, "
cQry += "SB1.B1_CONV AS DENSIDADE, "
cQry += "SB9.B9_DATA AS EMISSAO, "
cQry += "RPAD('0', 44, '0') AS CHAVENFE, "
cQry += "RPAD('0', 9, '0') AS DOC, "
cQry += "RPAD('0', 3, '0') AS SERIE "
cQry += "FROM "
cQry += RetSQLName("SB9")+" SB9 "
cQry += "JOIN "+RetSQLName("SB1")+" SB1 ON  SB9.B9_COD = SB1.B1_COD "
cQry += "                				AND SB1.D_E_L_E_T_ <> '*' "
cQry += "JOIN "+RetSQLName("SB5")+" SB5 ON  SB1.B1_COD = SB5.B5_COD "
cQry += "                				AND SB5.D_E_L_E_T_ <> '*' "
cQry += "                				AND SB5.B5_PRODANP = 'S' "
cQry += "WHERE "
cQry += "SB9.D_E_L_E_T_ <> '*' "   
cQry += "AND SB9.B9_FILIAL = '" +xFilial("SB9")+ "' "
cQry += "AND SB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQry += "AND SB5.B5_FILIAL = '" +xFilial("SB5")+ "' "
cQry += "AND SB9.B9_QINI > 0 "
cQry += "AND SB9.B9_DATA = '20160430' "
cQry += "GROUP BY "
cQry += "SB5.B5_CODANP, "
cQry += "SB1.B1_CONV, "
cQry += "SB9.B9_DATA "
cQry += "ORDER BY "
cQry += "ESPECIE, "
cQry += "EMISSAO )" 
//cQry += " WHERE PRODUTO = '310101001' ORDER BY ESPECIE, PRODUTO"

cQry := ChangeQuery(cQry)

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

TcQuery cQry New Alias "QRY"      

DbSelectArea("QRY")
nTotalReg := Contar("QRY", "!Eof()")
QRY->(DbGoTop())    

ProcRegua(nTotalReg)     

//A - SALDO INICIAL
//B - COMPRAS
//C - VENDAS
//D - SALDO FINAL

// sobra - 1021001 ( entrada - saldo a mais )
// perda - 1022004 ( requisicao -  )
// formulacao -  1022015 ( consumo para producao )
DbSelectArea("SD2");DbSetOrder(3)
DbSelectArea("SD1");DbSetOrder(3)

While QRY->(!Eof())   
	IncProc("Preenchendo " + QRY->PRODUTO)
	//Dados dos clientes/fornecedores
	If _nSeqLin == 0   
		_cLinAnp += STRZERO(_nSeqLin,10)                            											//1. CONTADOR SEQUENCIAL  					/10
		_cLinAnp += "1043588060" 																				//2. AGENTE REGULADO INFORMANTE  			/10
		_cLinAnp += "072017"																					//3. MÊS DE REFERÊNCIA (MMAAAA)             /06
		_cLinAnp += STRZERO(_nQtdReg, 7) + CRLF
		_nSeqLin += 1
	EndIf
	
	If AllTrim(QRY->ESPECIE) == "C"
		//
		If !AllTrim(QRY->TIPO) $ "D/B"
			//
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+QRY->CLIFOR+QRY->LOJA))
			//
			_cInst2 := SA1->A1_INSTANP
			_cInst1 := If(Empty(_cInst2),"1012002","1012001")
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA1->A1_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN),"CC2_CODANP"),"")
			//
		Else
			//
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+QRY->CLIFOR+QRY->LOJA))
			//
			_cInst2 := SA2->A2_T_INST
			_cInst1 := If(Empty(_cInst2),"1012005","1012004")
			//	_cInst1 := If(Empty(_cInst2),"1011002","1011001")  
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA2->A2_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA2->(A2_EST+A2_COD_MUN),"CC2_CODANP"),"")   

			//		
		EndIf
		//
	ElseIf AllTrim(QRY->ESPECIE) == "B"
		//
		If AllTrim(QRY->TIPO) $ "D/B"
			//
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+QRY->CLIFOR+QRY->LOJA))
			//        
			// Felipe - Armi          
			_cInst2 := SA1->A1_INSTANP
			_cInst1 := If(Empty(_cInst2),"1011005","1011004")
			// Original _cInst1 := If(Empty(_cInst2),"1012002","1012001")
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA1->A1_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN),"CC2_CODANP"),"")
			//
		Else
			//
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+QRY->CLIFOR+QRY->LOJA))
			//
			_cInst2 := SA2->A2_T_INST
			
			If SA2->A2_EST = "EX"
				_cInst1 := "2011001"
			Else
				_cInst1 := If(Empty(_cInst2),"1011002","1011001")
			EndIf
			
			_cCnpj  := If(Empty(_cInst2),AllTrim(SA2->A2_CGC),"")
			_cAtiv  := If(Empty(_cInst2),"46842","")
			_cLocal := If(Empty(_cInst2),Posicione("CC2",1,xFilial("CC2")+SA2->(A2_EST+A2_COD_MUN),"CC2_CODANP"),"")
			//		
		EndIf
		//
	ElseIf AllTrim(QRY->ESPECIE) == "A"
		//
		_cInst2 := "0"
		_cInst1 := "3010003"
		_cCnpj  := "00000000000000"
		_cAtiv  := "0"
		_cLocal := "0"
		//
	ElseIf AllTrim(QRY->ESPECIE) == "D"
		//
		_cInst2 := "0"
		_cInst1 := "3020003"
		_cCnpj  := "00000000000000"
		_cAtiv  := "0"
		_cLocal := "0"
		//
	EndIf
	//                     
	
	If SubStr(_cInst1,1,1) $ '1/2'          
		nPos2 := Ascan(_aArrQtd, {|x| x[1]+x[2] == QRY->PRODUTO+STRZERO(QRY->DENSIDADE*1000,7)  } )
		If nPos2 == 0
		     aadd(_aArrQtd, {QRY->PRODUTO,STRZERO(QRY->DENSIDADE*1000,7), 0, 0} )
		Else 
			If QRY->QTDLT < 1
				_nQtdLt := 1       
				_aArrQtd[nPos2][3] += (1 - QRY->QTDLT)
			Else                                                                                                                        	
				If(QRY->QTDLT-Round(QRY->QTDLT, 0)) >= 0.5
				
					_nQtdLt := Ceiling(QRY->QTDLT)
					_aArrQtd[nPos2][3] += (1 - (QRY->QTDLT-Round(QRY->QTDLT, 0)) )
				Else
					_nQtdLt := Round(QRY->QTDLT, 0)		
					_aArrQtd[nPos2][3] += (QRY->QTDLT-Round(QRY->QTDLT, 0))
				EndIf

			EndIf            
		EndIf
	EndIf
		
	If QRY->QTDLT < 1
		_nQtdLt := 1       
	Else                                                                                                                        	
		_nQtdLt := If(QRY->QTDLT-Round(QRY->QTDLT, 0) >= 0.5, Ceiling(QRY->QTDLT), Round(QRY->QTDLT, 0))		
	EndIf                                                                                                
	
	If QRY->QTDKG < 1	
		_nQtdKg := 1
	Else 
		_nQtdKg := If(QRY->QTDKG-Round(QRY->QTDKG, 0) >= 0.5, Ceiling(QRY->QTDKG), Round(QRY->QTDKG, 0))
	EndIf  
	/*
	_nQtdLt := If(QRY->QTDLT-Round(QRY->QTDLT, 0) >= 0.5, Ceiling(QRY->QTDLT), Round(QRY->QTDLT, 0))  
	_nQtdKg := If(QRY->QTDKG-Round(QRY->QTDKG, 0) >= 0.5, Ceiling(QRY->QTDKG), Round(QRY->QTDKG, 0))
	*/	             
	_cLinAnp += STRZERO(_nSeqLin,10)                            											//1. CONTADOR SEQUENCIAL  					 /10
	_cLinAnp += "1043588060" 																				//2. AGENTE REGULADO INFORMANTE  		     /10
	_cLinAnp += "072017"																					//3. MÊS DE REFERÊNCIA (MMAAAA)              /06
	_cLinAnp += IIF(EMPTY(_cInst1),STRZERO(0,7),STRZERO(VAL(_cInst1),7))									//4. CÓDIGO DA OPERAÇÃO                      /07
	_cLinAnp += "1032993"						 			   												//5. CÓDIGO DA INSTALAÇÃO 1                  /07
	_cLinAnp += IIF(EMPTY(_cInst2),STRZERO(0,7),STRZERO(VAL(_cInst2),7))									//6. CÓDIGO DA INSTALAÇÃO 2                  /07
	_cLinAnp += AllTrim(QRY->PRODUTO)															   			//7. CÓDIGO DO PRODUTO OPERADO               /09
	_cLinAnp += STRZERO(_nQtdLt,15)		   																	//8. QUANTIDADE UNITÁRIA MEDIDA ANP          /15
	_cLinAnp += STRZERO(_nQtdKg,15)																			//9. QUANTIDADE DE PRODUTO EM KG             /15
	_cLinAnp += "1"					 						   												//10. CÓDIGO DO MODAL                        /01
	_cLinAnp += STRZERO(0,7)			 																	//11. CÓDIGO DO VEÍCULO                      /07
	_cLinAnp += IIF(EMPTY(_cCnpj) ,STRZERO(0, 14),STRZERO(VAL(_cCnpj),14))				  					//12. IDENTIFICAÇÃO DO TERCEIRO              /14
	_cLinAnp += IIF(EMPTY(_cLocal),STRZERO(0, 7),STRZERO(VAL(_cLocal),7))				   					//13. CÓDIGO DO MUNICÍPIO                    /07
	_cLinAnp += IIF(EMPTY(_cAtiv) ,STRZERO(0, 5),STRZERO(VAL(_cAtiv), 5))	   								//14. CÓDIGO DA ATIVIDADE ECONÔMICA          /05
	_cLinAnp += STRZERO(0, 4)				 																//15. CÓDIGO DO PAÍS                         /04
	_cLinAnp += STRZERO(0, 10) 																				//16. LI - LICENÇA DE IMPORTAÇÃO             /10
	_cLinAnp += STRZERO(0, 10) 									   											//17. DI - DECLARAÇÃO DE IMPORTAÇÃO          /10
	_cLinAnp += STRZERO(0, 7)									   											//18. NÚMERO DA NOTA FISCAL                  /07
	_cLinAnp += STRZERO(0, 2)									   																//19. CÓDIGO DA SÉRIE DA NF /02
	_cLinAnp += Substr(DtoC(StoD(QRY->EMISSAO)),1,2)+Substr(DtoC(StoD(QRY->EMISSAO)),4,2)+Substr(DtoC(StoD(QRY->EMISSAO)),7,4)	//20. DATA DA NOTA FISCAL   /08
	_cLinAnp += STRZERO(0, 1)									  											//21. CÓDIGO DO SERVIÇO ACORDADO             /01
	_cLinAnp += STRZERO(0, 3)									   											//22. CÓDIGO DA CARACTERÍSTICA FÍSICO-QUÍMICA/03
	_cLinAnp += STRZERO(0, 3)									   											//23. CÓDIGO DO MÉTODO                       /03
	_cLinAnp += STRZERO(0, 2)									   											//24. MODALIDADE DO FRETE                    /02
	_cLinAnp += STRZERO(0, 10)									   											//25. VALOR ENCONTRADO DA CARACTERÍSTICA     /10
	_cLinAnp += STRZERO(0, 9)																				//26. CÓDIGO DO PRODUTO / OPER / RESULTANTE  /09
	_cLinAnp += STRZERO(QRY->DENSIDADE*1000,7)																//27. VALOR UNITÁRIO                         /07
	_cLinAnp += STRZERO(0, 2)																				//28. RECIPIENTE GLP                         /02
	_cLinAnp += IIF(EMPTY(AllTrim(QRY->CHAVENFE)),STRZERO(0,44),AllTrim(QRY->CHAVENFE))	  + CRLF			//29. CHAVE DE ACESSO NF-E (DANFE)           /44
	//
	_nSeqLin +=  1                  
		
	nPos := Ascan(_aTotProd, { |x| Alltrim(x[1]) == AllTrim(QRY->PRODUTO)})      	
	If nPos == 0  
		Aadd(_aTotProd,{AllTrim(QRY->PRODUTO), 0, 0 } )
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1011998", 	"TOTAL DE ENTRADAS COMERCIAIS NACIONAIS"			, 0 ,0 }) 
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1012998",	"TOTAL DE SAÍDAS COMERCIAIS NACIONAIS"				, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1021998",	"TOTAL DE ENTRADAS OPERACIONAIS"					, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1022998",	"TOTAL DE SAÍDAS OPERACIONAIS"						, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1041998",	"TOTAL DE ENTRADAS DE PROCESSAMENTO EXTERNO"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1042998",	"TOTAL DE SAÍDAS PARA PROCESSAMENTO EXTERNO"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1051998",	"TOTAL DE ENTRADA DE TRANSFERÊNCIA ENTRE INSTALAÇÕES"	, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1052998",	"TOTAL DE SAÍDA DE TRANSFERÊNCIA ENTRE INSTALAÇÕES"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1061998",	"TOTAL DE ENTRADAS POR TRANSFERÊNCIA ENTRE PRODUTOS"	, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1062998",	"TOTAL DE SAÍDAS POR TRANSFERÊNCIA ENTRE PRODUTOS"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1071998",	"TOTAL DE ENTRADAS EM TRANSPORTE DE DUTOS"			, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "1072998",	"TOTAL DE SAÍDAS EM TRANSPORTE DE DUTOS"			, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "2011998",	"TOTAL DE ENTRADAS COMERCIAIS INTERNACIONAIS"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "2012998",	"TOTAL DE SAÍDAS COMERCIAIS INTERNACIONAIS"			, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "2021998",	"TOTAL DE ENTRADAS OPERACIONAIS INTERNACIONAIS"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "2022998",	"TOTAL DE SAÍDAS OPERACIONAIS INTERNACIONAIS"		, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "4011998",	"TOTAL GERAL DE ENTRADAS"							, 0 ,0 })
		Aadd(_aTotais, {AllTrim(QRY->PRODUTO), "4012998",	"TOTAL GERAL DE SAÍDAS"								, 0 ,0 })
	EndIf               
                                            
	If SubStr(_cInst1,1,1) <> '3'
		nPPrdOp := Ascan(_aTotais, {|x| x[1]+SubStr(x[2],1,4) == QRY->PRODUTO+SubStr(AllTrim(_cInst1),1,4)  } )
		If _aTotais[nPPrdOp][1] == QRY->PRODUTO .AND. SubStr(_aTotais[nPPrdOp][2],1,4) == SubStr(AllTrim(_cInst1),1,4)
			_aTotais[nPPrdOp][4] += _nQtdLt   
			_aTotais[nPPrdOp][5] += _nQtdKg                  		
			If SubStr(AllTrim(_cInst1),1,4) $ "1011/1021/1041/1051/1061/1071/2011/2021"
				nPPrdTOp := Ascan(_aTotais, {|x| AllTrim(x[1]+x[2]) == AllTrim(QRY->PRODUTO+"4011998")  } )
			 	_aTotais[nPPrdTOp][4] += _nQtdLt   
 				_aTotais[nPPrdTOp][5] += _nQtdKg                  		
			ElseIf SubStr(AllTrim(_cInst1),1,4) $ "1012/1022/1042/1052/1062/1072/2012/2022"  								
				nPPrdTOp := Ascan(_aTotais, {|x| AllTrim(x[1]+x[2]) == AllTrim(QRY->PRODUTO+"4012998")  } )
			 	_aTotais[nPPrdTOp][4] += _nQtdLt   
 				_aTotais[nPPrdTOp][5] += _nQtdKg                  		
			EndIf
		EndIf		
	EndIf		
		
	If SD2->(DbSeek(xFilial("SD2")+QRY->DOC+QRY->SERIE))   
	   	While( SD2->(!EoF()) .AND. SD2->D2_DOC == QRY->DOC .AND. SD2->D2_SERIE == QRY->SERIE)
	   			DbSelectArea("SB5"); DbSetOrder(1)       
	   			If(SB5->(DbSeek(xFilial("SB5")+SD2->D2_COD))) 
	   				If (!EMPTY(SB5->B5_CODANP) .AND. ALLTRIM(SB5->B5_CODANP) == ALLTRIM(QRY->PRODUTO))     
	   				      If( ASCAN(_aTPrdCons, {|X| X[1]+X[2] == ALLTRIM(SB5->B5_COD)+ALLTRIM(SB5->B5_CODANP)}) == 0 )
	   				      	AADD(_aTPrdCons, {ALLTRIM(SB5->B5_COD), ALLTRIM(SB5->B5_CODANP), MOVSD3(SB5->B5_COD, "PRO"), MOVSD3(SB5->B5_COD, "CON") })
	   				      EndIf
	   				EndIf
	   			EndIf
	   	     SD2->(DbSkip())
	   	 EndDo
	EndIf      

	QRY->(DbSkip())               
EndDo    
  
ASORT(_aTotProd,,, { |x, y| x[1] < y[1] } )  
ASORT(_aTPrdCons,,, { | x,y | x[2] < y[2] } )  
ASORT(_aArrQtd,,, { |x, y| x[1] < y[1] } )  

For nX := 1 To Len(_aTotProd)          
	For nY := 1 To Len(_aTPrdCons)          
		If _aTPrdCons[nY][2] == _aTotProd[nX][1]
			_aTotProd[nX][2] += _aTPrdCons[nY][3]
			_aTotProd[nX][3] += _aTPrdCons[nY][4]
		EndIf
	Next
Next          
               
For nX := 1 To Len(_aTotais)
	_cLinAnp += STRZERO(_nSeqLin,10)	
	_cLinAnp += "1043588060" 																			
	_cLinAnp += "072017"																				
	_cLinAnp += _aTotais[nX][2]
	_cLinAnp += "1032993"						 			   											
	_cLinAnp += STRZERO(0,7)			
	_cLinAnp += AllTrim(_aTotais[nX][1])
	_cLinAnp += STRZERO(_aTotais[nX][4],15)	
	_cLinAnp += STRZERO(_aTotais[nX][5],15)	 
	_cLinAnp += "0"			
	_cLinAnp += STRZERO(0,7)
	_cLinAnp += STRZERO(0, 14)
	_cLinAnp += STRZERO(0, 7)
	_cLinAnp += STRZERO(0, 5)
	_cLinAnp += STRZERO(0, 4)				 																
	_cLinAnp += STRZERO(0, 10) 																				
	_cLinAnp += STRZERO(0, 10) 									   											
	_cLinAnp += STRZERO(0, 7)									   											
	_cLinAnp += STRZERO(0, 2)									   											
	_cLinAnp += STRZERO(0, 8)
	_cLinAnp += STRZERO(0, 1)
	_cLinAnp += STRZERO(0, 3)
	_cLinAnp += STRZERO(0, 3)
	_cLinAnp += STRZERO(0, 2)
	_cLinAnp += STRZERO(0, 10)
	_cLinAnp += STRZERO(0, 9)
	_cLinAnp += STRZERO(0, 7)
	_cLinAnp += STRZERO(0, 2)
	_cLinAnp += STRZERO(0,44) + CRLF	   																	
	
	_nSeqLin += 1	
Next

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf
       
grarquivo(_cLinAnp)             

Return()     

static function grarquivo(_cLinAnp)         
	nArquivo := fcreate("c:\temp\"+DtoS(Date())+"_ANP.TXT", 0)    
	fwrite(nArquivo,_cLinAnp)
	fclose(nArquivo) 
return 


Static Function MOVSD3(cProd,cTipo)
Local _cQryD3a := ""
Local _nRetD3a := 0

_cQryD3a :=	" SELECT SUM(D3_QUANT) AS QUANT FROM "+RetSqlName("SD3")+" SD3 "
_cQryD3a +=	" WHERE SD3.D_E_L_E_T_ = '' "                              
_cQryD3a +=	" AND SD3.D3_FILIAL = '"+xFilial("SD3")+"' "
_cQryD3a +=	" AND D3_EMISSAO between '20160401' and '20160430' "
_cQryD3a +=	" AND D3_COD = '"+cProd+"'"
_cQryD3a +=	" AND D3_ESTORNO = '' "

If cTipo = "CON" 
	_cQryD3a +=	" AND D3_CF IN ('RE1','RE2') "
	_cQryD3a +=	" AND D3_OP <> '' "
ElseIf cTipo = "PRO" 	
	_cQryD3a +=	" AND D3_CF = 'PR0' "
	_cQryD3a +=	" AND D3_OP <> '' "
ElseIf cTipo = "REQ" 	
	_cQryD3a +=	" AND D3_CF IN ('RE1','RE2','RE4','RE6','RE7')"
	_cQryD3a +=	" AND D3_OP = '' "
ElseIf cTipo = "DEV" 	
	_cQryD3a +=	" AND D3_CF IN ('DE0','DE1','DE2','DE4','DE6','DE7')"
	_cQryD3a +=	" AND D3_OP = '' "
	
EndIf

_cQryD3a := ChangeQuery(_cQryD3a)
TCQUERY _cQryD3a NEW ALIAS "TRD3a"

DbSelectArea("TRD3a")

TRD3a->(DbGoTop())   
While !TRD3a->(Eof())
	_nRetD3a += TRD3a->QUANT
	DbSkip()
EndDo

TRD3a->(DbCloseArea())

Return(_nRetD3a)  