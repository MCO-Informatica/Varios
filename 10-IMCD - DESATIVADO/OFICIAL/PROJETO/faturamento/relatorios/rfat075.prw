#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT075   º Autor ³ Giane              º Data ³  05/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Resumo de estoque                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFAT075    
	Local cQuery := ""     
	Local cPerg := 'RFAT075'

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT075" , __cUserID )

	Private cAlias := "XSB9"

	If !Pergunte(cPerg)
		Return
	Endif                                  

	//agrupa os valores por Mes e ano
	cQuery := "SELECT SB1.B1_SEGMENT, SB9.B9_LOCAL, MAX(SUBSTR(SB9.B9_DATA,1,6)) AS B9_DATA, SUM(SB9.B9_QINI * SB9.B9_CM1) AS ESTOQUE " 
	cQuery += "FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1 " 
	cQuery += "WHERE SB9.B9_COD = SB1.B1_COD "
	cQuery += "AND SB1.B1_SEGMENT >= '" + MV_PAR03 + "' AND SB1.B1_SEGMENT  <= '" + MV_PAR04 + "' "     
	cQuery += "AND SB9.B9_DATA >= '" + dtos(MV_PAR01) + "' AND SB9.B9_DATA <=  '" + dtos(MV_PAR02) + "' "
	cQuery += "AND SB9.D_E_L_E_T_ = ' ' "  
	cQuery += "GROUP BY SB1.B1_SEGMENT, SB9.B9_LOCAL, SUBSTR(SB9.B9_DATA,1,6) "  
	cQuery += "ORDER BY SB1.B1_SEGMENT, SB9.B9_LOCAL, SUBSTR(SB9.B9_DATA,1,6) "    

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	dbSelectArea(cAlias)  
	DbGotop()            

	MsgRun("Processando Relatório Resumo de Estoque em excel, aguarde...","",{|| R075Excel() })

	(cAlias)->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R075EXCEL Autor ³                       ³ Data ³04.02.2010³  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime relatorio na versao excel                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R075EXCEL()

	Local aAux   := {}     
	Local nVariacao := 0
	Local nMesU := 0
	Local nMesP := 0                                                                            
	Local aMesExt := {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez" }
	Local i := 0
	Local _nx := 0

	Private aMes := {}                                              
	Private aTotSeg := {}            
	Private aItens := {}       
	Private aCabec := {}    
	Private aTotMak := {}
	Private aTotTer := {} 
	Private aTotEst := {}  
	Private aTotCst := {}  

	/*==============================
	Monta o cabecalho de estoque 
	==============================*/
	aMes := CalcMeses()
	aadd(aCabec, "Segmento"  )
	aadd(aCabec, "Local") 
	For i:= 1 to len(aMes)
		aadd(aCabec, aMes[i] )
	Next                                               
	nMesU := val( left(aMes[len(aMes)],2) )
	if len(aMes) > 1
		nMesP := val( left(aMes[len(aMes)-1],2) )
	else 
		nMesP := nMesU
	endif
	aadd(aCabec, "Variacao " + (CHR(13)+CHR(10))+  aMesExt[nMesU] + "/" + aMesExt[nMesP]  )                                   


	/*=========================================================
	monta as linhas de total geral do estoque,custos, indices :
	===========================================================*/ 
	For i:= 1 to len(aMes)
		aadd(aTotMak, {aMes[i], 0 } )
	Next        

	For i:= 1 to len(aMes)
		aadd(aTotTer, {aMes[i], 0 } )
	Next               

	For i:= 1 to len(aMes)
		aadd(aTotEst, {aMes[i], 0 } )
	Next

	aadd(aTotCst, "")                
	For i:= 1 to len(aMes)
		aadd(aTotCst,  0  )
	Next
	/*====================================================*/

	dbSelectArea(cAlias) 
	(cAlias)->(DbGotop())

	aAux := {}
	While !EOF()   

		cSegmento := (cAlias)->B1_SEGMENT 

		aadd(aAux, Posicione("ACY",1,xFilial("ACY") + (cAlias)->B1_SEGMENT, "ACY_DESCRI" ) )

		_nSeg := 0
		Do While !eof() .and. (cAlias)->B1_SEGMENT == cSegmento           
			_nSeg ++	    

			If (cAlias)->B9_LOCAL = '01'
				cArmazem := 'MAKENI'     	      
			Else
				cArmazem := 'TERCEIROS'
			Endif	   

			dbSelectArea(cAlias)             	   

			if _nSeg > 1    //nao repete o nome do segmento, mas cria posiçao em branco
				aadd(aAux, " " )
			endif
			aadd(aAux, cArmazem )
			cLocal := cArmazem 

			//agrupa os armazens que sao diferentes de '01' como se fosse um só(Terceiros)
			Do While !eof() .and. (cAlias)->B1_SEGMENT == cSegmento .and.  cLocal == iif( (cAlias)->B9_LOCAL == '01', 'MAKENI', 'TERCEIROS')

				nPos := Ascan(aCabec,  right((cAlias)->B9_DATA ,2)  + '/' + left((cAlias)->B9_DATA,4) ) 
				if nPos == 0
					aadd(aCabec, right((cAlias)->B9_DATA ,2)  + '/' + left((cAlias)->B9_DATA,4) )    	         
				else     
					nTam := (nPos - 1) - len(aAux)                                                                   

					if nTam > 0
						For _nx := 1 to nTam
							aadd(aAux, 0 )  
						Next       
					Endif
				endif	      

				aadd(aAux, (cAlias)->ESTOQUE  )                  

				fTotSeg() // soma os totais do segmento	           
				fTotLocal() //soma os totais gerais por local/armazem
				Dbskip()  
			Enddo  

			if len(aAux) > 0 
				//coloca a variacao na coluna correta, comparando com o cabec:
				nTam := (len(aCabec) - len(aAux)) - 1	      
				For i:= 1 to nTam
					aadd(aAux, 0)
				Next  

				//divide sempre o ultimo mes pelo penultimo mes, para ter a variacao
				nTam := len(aAux)                  
				nVariacao := 0
				if len(aMes) > 1
					if aAux[nTam -1] > 0 .and. aAux[nTam] > 0
						nVariacao := ( (aAux[nTam] * 100) /  aAux[nTam -1] ) - 100
					endif   	         
				endif   	       

				aadd(aAux, Transform( nVariacao , "@E 9,999.99" )  )   
				aadd(aItens, aAux)
				aAux := {}
			endif   

		Enddo 

		fLinSeg() //monta a linha do total do segmento 

	Enddo

	If len(aItens) == 0
		MsgInfo("Não existem dados a serem impressas, de acordo com os parâmetros informados!","Atenção")
	Else      
		//Cria cabecalho para as colunas de Custo: 
		aadd(aCabec, "CUSTOS " + chr(13) + Chr(10)  + "PRODUTOS")
		For i:= 1 to len(aMes)
			aadd(aCabec, aMes[i] )
		Next                                           
		aadd(aCabec, "Variacao " + (CHR(13)+CHR(10)) + aMesExt[nMesU] + "/" + aMesExt[nMesP]  )

		//cria cabecalho para as colunas de Indice de estoque:
		aadd(aCabec, "INDICE " + chr(13)+chr(10) + "ESTOQUE")
		For i:= 1 to len(aMes)
			aadd(aCabec, aMes[i] )
		Next  

		//monta linha do total geral de estoque
		fLinEst()      

		//completa linha de total geral de terceiros, ref. colunas de custos que ficará em branco
		nPos := len(aItens)-1
		For i := 1 to len(aMes)
			aadd(aItens[nPos], "" )
		Next  
		aadd(aItens[nPos], "")   


		nTam := len(aTotCst)
		nVariacao := 0
		if nTam > 2
			nVariacao :=  (aTotCst[nTam] / aTotCst[nTam-1] ) - 1      
		endif 
		aadd(aTotCst, nVariacao)

		aadd(aItens[nPos], "") //coluna em branco 
		aadd(aItens[nPos], "Meses")
		For i := 1 to len(aTotEst)
			if i > 1
				nVariacao := ( ( aTotEst[i,2]+ aTotEst[i-1,2] ) / 2  ) / aTotCst[i+1]
			else
				nVariacao := (aTotEst[i,2] / 2) / aTotCst[i+1]
			endif
			aadd(aItens[nPos], nVariacao)     
		Next    

		//soma totais gerais do custo 
		nPos := len(aItens)   
		For i := 1 to len(aTotCst)
			aadd(aItens[nPos], aTotCst[i])  
		Next                 

		aadd(aItens[nPos], "Dias") 
		For i := 1 to len(aTotEst)
			if i > 1
				nVariacao := ( ( aTotEst[i,2]+ aTotEst[i-1,2] ) / 2  ) / aTotCst[i+1]
			else
				nVariacao := (aTotEst[i,2] / 2) / aTotCst[i+1]
			endif
			aadd(aItens[nPos], (nVariacao * 30) )      
		Next     

		DlgToExcel({ {"ARRAY", "Relatorio Resumo de Estoque", aCabec, aItens} }) 
	Endif       

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fLinEst ³ Autor ³Giane                  ³ Data ³02.03.2010³  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Soma os totais gerais na linha do aitens                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fLinEst()  
	Local nTam := 0   
	Local nVariacao := 0
	Local aAux := {}
	Local i := 0

	aadd(aAux, 'TOTAL')
	aadd(aAux, 'Makeni') 
	nTam := len(aTotMak) 
	For i:= 1 to nTam    
		aadd(aAux, aTotMak[i,2] )
	Next  
	nVariacao := 0
	if nTam > 1
		nVariacao := aTotMak[nTam,2] / aTotMak[nTam-1,2] - 1 
	endif
	aadd(aAux, nVariacao ) 
	aadd(aItens, aAux)

	aAux := {}
	aadd(aAux, "")
	aadd(aAux, 'Terceiros') 
	nTam := len(aTotTer) 
	For i:= 1 to nTam
		aadd(aAux, aTotTer[i,2] )
	Next                                                
	nVariacao := 0
	if nTam > 1
		nVariacao := aTotTer[nTam,2] / aTotTer[nTam-1,2] - 1
	endif   
	aadd(aAux, nVariacao )
	aadd(aItens, aAux)

	aAux := {}
	aadd(aAux, "")
	aadd(aAux, 'Total') 
	nTam := len(aTotEst) 
	For i:= 1 to nTam
		aadd(aAux, aTotEst[i,2] )
	Next      
	nVariacao := 0
	if nTam > 1                            
		nVariacao := aTotEst[nTam,2] / aTotEst[nTam-1,2] - 1
	endif
	aadd(aAux, nVariacao )
	aadd(aItens, aAux)

Return                           

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fTotSeg ³ Autor ³                       ³ Data ³11.02.2010³  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Soma os totais de cada segmento                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fTotSeg()  
	Local nPos := 0       

	nPos := aScan( aTotSeg, { |x| x[1] ==  right((cAlias)->B9_DATA ,2) +  '/' + left((cAlias)->B9_DATA,4)  } )

	if nPos == 0
		aadd(aTotSeg, {right((cAlias)->B9_DATA ,2) +  '/' + left((cAlias)->B9_DATA,4),;  //mes e ano
		(cAlias)->ESTOQUE } )	   	  
	Else
		aTotSeg[nPos,2] += (cAlias)->ESTOQUE 
	Endif 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fTotLocal*Autor ³                       ³ Data ³02.03.2010³  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Soma os totais de estoque para cada local/armazem           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fTotLocal()  
	Local nPos := 0       

	if (cAlias)->B9_LOCAL == '01' //ARMAZEM MAKENI

		nPos := aScan( aTotMak, { |x| x[1] ==  right((cAlias)->B9_DATA ,2) +  '/' + left((cAlias)->B9_DATA,4)  } )

		If nPos <> 0
			aTotMak[nPos,2] += (cAlias)->ESTOQUE 
			aTotEst[nPos,2] += (cAlias)->ESTOQUE 
		Endif 

	Else //OUTROS ARMAZENS (TERCEIROS)

		nPos := aScan( aTotTer, { |x| x[1] ==  right((cAlias)->B9_DATA ,2) +  '/' + left((cAlias)->B9_DATA,4)  } )

		if nPos <> 0
			aTotTer[nPos,2] += (cAlias)->ESTOQUE 
			aTotEst[nPos,2] += (cAlias)->ESTOQUE 
		Endif

	Endif   

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fLinSeg ³ Autor ³                       ³ Data ³11.02.2010³  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta a linha dos totais do segmento no array               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fLinSeg()    
	Local aAux2 := {}   
	Local cMes := ""
	Local nCusto := 0   
	Local aCusto := {}
	Local nTot := 0  
	Local aIndM := {}
	Local aIndD := {}
	Local i := 0
	Local _nx := 0

	If len(aTotSeg) > 0   

		aadd(aAux2, "")
		aadd(aAux2, "Total") 

		nTot := len(aCabec) - 1 // retira a ultima coluna que é a variacao
		For _nx := 3 to nTot   //(aTotSeg[2])      

			nPos := aScan( aTotSeg, { |x| x[1] ==  aCabec[_nx] } )

			cMes := ""
			if nPos > 0
				cMes := left( aTotSeg[nPos,1] ,2) + '/' + substr( aTotSeg[nPos,1] , 4,4) 
			endif

			if cMes <> aCabec[_nx]
				nTot := 0
			else        
				nTot :=  aTotSeg[nPos,2]
			endif 
			aadd(aAux2, nTot )

			/*=====================================================
			Calcular o custo total para o segmento no mês:        
			===================================================*/         
			cMes := subs(aCabec[_nx],4,4)+ left(aCabec[_nx],2)
			nCusto := fCalcCst(cMes)                                   
			aadd(aCusto, nCusto )


			/*=====================================================
			Calcular o indice de estoque para o mês  
			======================================================*/
			nIndice := 0
			if ( nCusto > 0 )          

				//verifica se o mês anterior do total do segmento tem valor:          
				nTotant := 0
				nPos2 := aScan( aTotSeg, { |x| x[1] ==  aCabec[_nx-1] } )   
				if nPos2 > 0
					nTotAnt := aTotSeg[nPos2,2]      
				endif 
				//      

				nIndice := (nTot + nTotAnt ) / nCusto           
			endif   

			aadd(aIndM, nIndice) //indice estoque -> meses   
			aadd(aIndD, nIndice * 30)// indice estoque -> dias
			/*======================================================*/

		Next    

		//calcula variaçao da linha do total do segmento:
		if len(aAux2) > 0         
			//divide sempre o ultimo mes pelo penultimo mes, para ter a variacao
			nTam := len(aAux2)                  
			nVariacao := 0
			if len(aMes) > 1
				if (aAux2[nTam -1] > 0) .and. (aAux2[nTam] > 0)
					nVariacao := ( (aAux2[nTam] * 100) /  aAux2[nTam -1] ) - 100
				endif
			endif   	       

			aadd(aAux2, Transform( nVariacao , "@E 9,999.99" )  )   
		endif   

		//calcula variaçao da linha do custo:
		if len(aCusto) > 0         
			//divide sempre o ultimo mes pelo penultimo mes, para ter a variacao
			nTam := len(aCusto)   
			nVariacao := 0
			if nTam > 1               
				if aCusto[nTam -1] > 0 .and. aCusto[nTam] > 0
					nVariacao := ( (aCusto[nTam] * 100) /  aCusto[nTam -1] ) - 100
				endif
			endif   	       

			aadd(aCusto, Transform( nVariacao , "@E 9,999.99" )  )   
		endif    

		//soma a linha de Itens dos Custos calculados 
		aadd(aAux2, "" ) //primeira coluna que tem o titulo "Custos Prod.faturados"
		For i:= 1 to len(aCusto)
			aadd(aAux2, aCusto[i])       
			//soma os custos para os totais gerais do custo
			if i != len(aCusto) //ultima posicao de acusto é a variacao               
				aTotCst[i+1] += aCusto[i]
			endif
		Next                


		//soma a linha dos indices do estoque/dia:
		aadd(aAux2, "Dias" ) 
		For i:= 1 to len(aIndD)
			aadd(aAux2, aIndD[i])     
		Next      

		aadd(aItens, aAux2) 

		//soma a linha dos indices/meses do estoque no aItens anterior(ultimo segmento antes do total do segmento)   
		if len(aItens) > 1
			nPos := len(aItens) - 1                                                                                
			aadd(aItens[nPos], "")
			For i:= 1 to len(aCusto)
				aadd(aItens[nPos], "")     
			Next 

			aadd(aItens[nPos], "Meses")
			For i:= 1 to len(aIndM)            
				aadd(aItens[nPos], aIndM[i] ) 
			Next   
		Endif   

	Endif  	          

	aTotSeg := {} 
Return   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fCalcCst³ Autor ³ Giane                 ³ Data ³12.02.2010³  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula o custo mensal dos produtos faturados               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/      

Static function fCalcCst(pPeriodo) 
	Local _aAreaAnt := GetArea()
	Local cAlias:= "XSD2"   
	Local nCusto := 0

	cQuery := " SELECT SB1.B1_SEGMENT, SUM(SD2.D2_QUANT * SD2.D2_CUSTO1) AS CUSTO " 
	cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " LEFT JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SD2.D2_COD = SB1.B1_COD"
	cQuery += " LEFT JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_TES = SF4.F4_CODIGO "  
	cQuery += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' "  
	cQuery += " AND SUBSTR(SD2.D2_EMISSAO,1,6) = '" + pPeriodo + "' "
	cQuery += " AND SB1.B1_SEGMENT = '" + cSegmento + "' "   
	cQuery += " AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "  //somente notas fiscais que geram duplicatas e nao de SERVIÇO
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "    
	cQuery += " GROUP BY SB1.B1_SEGMENT "   

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	dbSelectArea(cAlias)  
	DbGotop() 

	nCusto := (cAlias)->CUSTO
	(cAlias)->(DbCloseArea())

	RestArea(_aAreaAnt)
Return(nCusto)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CalcMeses * Autor* Giane                ³ Data ³26.02.2010³  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula meses existentes no periodo digitado nos parametros ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CalcMeses()

	Local nDif    := MV_PAR02 - MV_PAR01
	Local cAux    := ""
	Local aRet    := {}
	Local nLoop   := 0 

	If nDif < 0
		MsgStop( "Parametros Informados de Forma Incorreta" )
	ElseIf nDif == 0
		cAux :=   SubStr( Dtos( MV_PAR01 ), 5, 2 ) + "/" + SubStr( Dtos( MV_PAR01 ), 1, 4 ) 
		aAdd( aRet, cAux )
	Else
		For nLoop := 0 To nDif

			cAux :=  SubStr( Dtos( MV_PAR01 + nLoop ), 5, 2 )  + "/" + SubStr( Dtos( MV_PAR01 + nLoop ), 1, 4 ) 

			If aScan( aRet, cAux ) == 0
				aAdd( aRet, cAux )
			Endif
		Next nLoop 

	Endif 

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT076   ºAutor  ³Microsiga           º Data ³  05/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFAT076

	Local cPerg := 'RFAT075'

	If !Pergunte(cPerg)
		Return
	Endif                                  

	MsgRun( "Processando Relatório Resumo de Estoque em excel, aguarde...", "", { || R076Excel() } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT076   ºAutor  ³Microsiga           º Data ³  05/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R076Excel

	Local cQuery 	:= ""

	Local aMeses 	:= CalcMeses() 

	Local aSegs		:= {}

	Local nLoop  	:= 0
	Local nCntFor 	:= 0

	Local aCabec 	:= {}
	Local aDados 	:= {}

	Local nPosLin	:= 0
	Local nPosCol	:= 0

	Local aSaldo	:= {}

	Local nAux		:= 0

	Local nPosMak 	:= 0
	Local nPosTer 	:= 0

	aAdd( aCabec, "Cod. Segmento" )
	aAdd( aCabec, "Segmento" )
	aAdd( aCabec, "Local" )

	For nLoop := 1 to Len( aMeses )
		aAdd( aCabec, aMeses[nLoop] )
	Next nLoop

	cQuery := "SELECT B1_SEGMENT, ACY_DESCRI, B9_DATA, SUM( B9_QINI * B9_CM1 ) B9_CM1 "
	cQuery += "  FROM " + RetSQLName( "SB9" ) + " SB9 "
	cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL  = '" + xFilial( "SB1" ) + "' AND B1_COD = B9_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "ACY" ) + " ACY ON ACY_FILIAL = '" + xFilial( "ACY" ) + "' AND ACY_GRPVEN = B1_SEGMENT AND ACY.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE B9_FILIAL      = '" + xFilial( "SB9" ) + "' "
	cQuery += "   AND B9_DATA        BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
	cQuery += "   AND B1_SEGMENT     BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery += "   AND SB9.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY B1_SEGMENT, ACY_DESCRI, B9_DATA "
	cQuery += " ORDER BY B1_SEGMENT, ACY_DESCRI, B9_DATA "
	If Select( "TMP_SB9" ) > 0
		TMP_SB9->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SB9", .T., .F. )
	While TMP_SB9->( !Eof() )

		nPosLin := aScan( aDados, { |x| x[1] == TMP_SB9->B1_SEGMENT } )

		If Empty( nPosLin )

			aAdd( aSegs, { TMP_SB9->B1_SEGMENT, TMP_SB9->ACY_DESCRI } )

			aAdd( aDados, Array( Len( aCabec ) ) )

			aDados[Len(aDados)][1] := TMP_SB9->B1_SEGMENT
			aDados[Len(aDados)][2] := TMP_SB9->ACY_DESCRI
			aDados[Len(aDados)][3] := "MAKENI"
			For nLoop := 1 To Len( aMeses )
				aDados[Len(aDados)][nLoop+3] := 0
			Next nLoop

			nPosCol := aScan( aMeses, SubStr( TMP_SB9->B9_DATA, 5, 2 ) + "/" + SubStr( TMP_SB9->B9_DATA, 1, 4 ) )

			If !Empty( nPosCol )
				aDados[Len(aDados)][nPosCol+3] += TMP_SB9->B9_CM1
			Endif
		Else
			nPosCol := aScan( aMeses, SubStr( TMP_SB9->B9_DATA, 5, 2 ) + "/" + SubStr( TMP_SB9->B9_DATA, 1, 4 ) )
			If !Empty( nPosCol )
				aDados[nPosLin][nPosCol+3] += TMP_SB9->B9_CM1
			Endif
		Endif

		TMP_SB9->( dbSkip() )
	End
	TMP_SB9->( dbCloseArea() )

	For nCntFor := 1 To Len( aMeses )

		cQuery := "SELECT B1_SEGMENT, ACY_DESCRI, B6_PRODUTO, B6_DTDIGIT, B6_IDENT, B6_TES, ROUND( ( B6_CUSTO1 / B6_QUANT ), 2 ) B6_CM1 "
		cQuery += "  FROM " + RetSQLName( "SB6" ) + " SB6 "
		cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL  = '" + xFilial( "SB1" ) + "' AND B1_COD = B6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
		cQuery += "  JOIN " + RetSQLName( "ACY" ) + " ACY ON ACY_FILIAL = '" + xFilial( "ACY" ) + "' AND ACY_GRPVEN = B1_SEGMENT AND ACY.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE B6_FILIAL      = '" + xFilial( "SB6" ) + "' "
		cQuery += "   AND B6_PODER3      = 'R' "
		cQuery += "   AND B6_DTDIGIT     <= '" + DtoS( LastDay( Ctod( "01/" + aMeses[nCntFor] ) ) ) + "' "
		cQuery += "   AND B1_SEGMENT     BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
		cQuery += "   AND SB6.D_E_L_E_T_ = ' ' "
		If Select( "TMP_SB6" ) > 0
			TMP_SB6->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SB6", .T., .F. )
		While TMP_SB6->( !Eof() )

			nPosLin := aScan( aDados, { |x| x[1] == TMP_SB6->B1_SEGMENT .and. AllTrim( x[3] ) == "TERCEIROS" } )

			If Empty( nPosLin )
				aAdd( aDados, Array( Len( aCabec ) ) )

				aDados[Len(aDados)][1] := TMP_SB6->B1_SEGMENT
				aDados[Len(aDados)][2] := TMP_SB6->ACY_DESCRI
				aDados[Len(aDados)][3] := "TERCEIROS"
				For nLoop := 1 To Len( aMeses )
					aDados[Len(aDados)][nLoop+3] := 0
				Next nLoop

				nPosCol := nCntFor

				If !Empty( nPosCol )
					aSaldo	:= CalcTerc( TMP_SB6->B6_PRODUTO, Nil, Nil, TMP_SB6->B6_IDENT, TMP_SB6->B6_TES, , , LastDay( Ctod( "01/" + aMeses[nCntFor] ) ) )

					If aSaldo[1] <= 0
						TMP_SB6->( dbSkip() )
						Loop
					Endif

					//AcaLog( "C:\RFAT076.CSV", TMP_SB6->B1_SEGMENT + ";" + TMP_SB6->ACY_DESCRI  + ";" +  TMP_SB6->B6_PRODUTO + ";" + TMP_SB6->B6_DTDIGIT  + ";" +  TMP_SB6->B6_IDENT  + ";" +  TMP_SB6->B6_TES  + ";" +  Transform( TMP_SB6-> B6_CM1, "@E 999999999999.99" ) + ";" + Transform( aSaldo[1], "@E 999999999999.99" ) )

					aDados[Len(aDados)][nPosCol+3] := aDados[Len(aDados)][nPosCol+3] + ( aSaldo[1] * TMP_SB6->B6_CM1 )
				Endif

			Else

				nPosCol := nCntFor

				If !Empty( nPosCol )
					aSaldo	:= CalcTerc( TMP_SB6->B6_PRODUTO, Nil, Nil, TMP_SB6->B6_IDENT, TMP_SB6->B6_TES, , , LastDay( Ctod( "01/" + aMeses[nCntFor] ) ) )

					If aSaldo[1] <= 0
						TMP_SB6->( dbSkip() )
						Loop
					Endif

					//AcaLog( "C:\RFAT076.CSV", TMP_SB6->B1_SEGMENT + ";" + TMP_SB6->ACY_DESCRI  + ";" +  TMP_SB6->B6_PRODUTO + ";" + TMP_SB6->B6_DTDIGIT  + ";" +  TMP_SB6->B6_IDENT  + ";" +  TMP_SB6->B6_TES  + ";" +  Transform( TMP_SB6-> B6_CM1, "@E 999999999999.99" ) + ";" + Transform( aSaldo[1], "@E 999999999999.99" ) )

					aDados[nPosLin][nPosCol+3] := aDados[nPosLin][nPosCol+3] + ( aSaldo[1] * TMP_SB6->B6_CM1 )

				Endif
			Endif

			TMP_SB6->( dbSkip() )
		End
	Next nCntFor
	TMP_SB6->( dbCloseArea() )

	For nLoop := 1 To Len( aSegs )

		nPosMak := aScan( aDados, { |x| x[1] == aSegs[nLoop][1] .and. AllTrim( x[3] ) == "MAKENI" } )
		nPosTer := aScan( aDados, { |x| x[1] == aSegs[nLoop][1] .and. AllTrim( x[3] ) == "TERCEIROS" } )

		If nPosMak > 0 .or. nPosTer > 0

			aAdd( aDados, Array( Len( aCabec ) ) )
			aDados[Len(aDados)][1] := aSegs[nLoop][1]
			aDados[Len(aDados)][2] := aSegs[nLoop][2]
			aDados[Len(aDados)][3] := "TOTAL"
			For nAux := 1 To Len( aMeses )
				aDados[Len(aDados)][nAux+3] := 0
			Next nAux

			For nAux := 1 To Len( aMeses )

				If nPosMak > 0
					aDados[Len(aDados)][nAux+3] += aDados[nPosMak][nAux+3]
				Endif

				If nPosTer > 0
					aDados[Len(aDados)][nAux+3] += aDados[nPosTer][nAux+3]
				Endif

			Next nAux

		Endif

		aAdd( aDados, Array( Len( aCabec ) ) )
		aDados[Len(aDados)][1] := aSegs[nLoop][1]
		aDados[Len(aDados)][2] := aSegs[nLoop][2]
		aDados[Len(aDados)][3] := "TOTAL CUSTOS"
		For nAux := 1 To Len( aMeses )
			aDados[Len(aDados)][nAux+3] := 0
		Next nAux

		For nAux := 1 To Len( aMeses )
			aDados[Len(aDados)][nAux+3] += CalcCusto( aSegs[nLoop][1], aMeses[nAux] )
		Next nAux

	Next nLoop

	aSort( aDados,,, { |x,y| x[1] + x[3] < y[1] + y[3] } )

	DlgToExcel( { {"ARRAY", "Resumo de Estoque", aCabec, aDados } } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT075   ºAutor  ³Microsiga           º Data ³  05/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcCusto( cSegment, cAnoMes )

	Local cQuery := ""
	Local nRet 	 := 0

	cAnoMes := SubStr( cAnoMes, 4, 4 ) + SubStr( cAnoMes, 1, 2 )

	cQuery := "SELECT "
	cQuery += "  SA1.A1_GRPVEN, SA3.A3_NREDUZ, SD2.D2_DOC, SD2.D2_EMISSAO, SD2.D2_CLIENTE, SA1.A1_NREDUZ, SD2.D2_COD, SD2.D2_FILIAL,"
	cQuery += "  SB1.B1_DESC, SD2.D2_QUANT, SD2.D2_VALBRUT , SD2.D2_IPI, SD2.D2_PICM, SD2.D2_ALQIMP5, SD2.D2_ALQIMP6, SA1.A1_SATIV1, "
	cQuery += "  SD2.D2_VALIPI, SD2.D2_VALICM, SD2.D2_VALIMP5, SD2.D2_VALIMP6, SD2.D2_PRCVEN , SD2.D2_LOJA, SD2.D2_NFORI, SD2.D2_SERIORI, SF2.F2_EST, "
	cQuery += "  SB1.B1_SEGMENT, SA3.A3_NOME, SB1.B1_CUSTD, SD2.D2_PEDIDO, SD2.D2_ITEMPV, SC6.C6_COMIS1, SD2.D2_CUSTO1, SC5.C5_TPFRETE, " 
	cQuery += "  SD2.D2_CF, XORI.D2_CUSTO1 CUSTOORI, XORI.D2_PICM PICMORI, SD2.D2_XNFORI, SD2.D2_XSERORI, XORI.D2_VALICM VICMORI, SD2.D2_TOTAL, XORI.D2_QUANT XQUANT, XORI.D2_PEDIDO XPEDIDO, XORI.D2_ITEMPV XITEMPV "
	cQuery += "FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "    SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
	cQuery += "    SD2.D2_COD = SB1.B1_COD AND "
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "    SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
	cQuery += "    SD2.D2_CLIENTE = SA1.A1_COD AND "
	cQuery += "    SD2.D2_LOJA = SA1.A1_LOJA AND "
	cQuery += "    SA1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSqlName("SF2") + " SF2 ON "
	cQuery += "    SF2.F2_FILIAL = SD2.D2_FILIAL AND "
	cQuery += "    SD2.D2_DOC = SF2.F2_DOC AND "
	cQuery += "    SD2.D2_SERIE = SF2.F2_SERIE AND "
	cQuery += "    SF2.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " SA3 ON "
	cQuery += "    SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND "
	cQuery += "    SF2.F2_VEND1 = SA3.A3_COD AND "
	cQuery += "    SA3.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSqlName("SF4") + " SF4 ON "
	cquery += "    SF4.F4_FILIAL = '" + xFilial( "SF4" ) + "' AND "
	cQuery += "    SD2.D2_TES = SF4.F4_CODIGO AND "  
	cQuery += "    SF4.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SC6") + " SC6 ON "
	cQuery += "    SC6.C6_FILIAL = SD2.D2_FILIAL AND "
	cQuery += "    SC6.C6_NUM = SD2.D2_PEDIDO AND " 
	cQuery += "    SC6.C6_ITEM = SD2.D2_ITEMPV AND "
	cQuery += "    SC6.C6_PRODUTO = SD2.D2_COD AND "
	cQuery += "    SC6.C6_NOTA = SD2.D2_DOC AND "
	cQuery += "    SC6.D_E_L_E_T_ = ' ' " 
	cQuery += "  LEFT JOIN " + RetSqlName("SC5") + " SC5 ON "
	cQuery += "     SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ = ' ' " 
	cQuery += "  LEFT JOIN ( SELECT DISTINCT D2_FILIAL, D2_DOC, D2_SERIE, D2_COD, SUM( D2_CUSTO1 ) D2_CUSTO1, AVG( D2_PICM ) D2_PICM, AVG( D2_VALICM ) D2_VALICM, SUM( D2_QUANT ) D2_QUANT, MAX( D2_PEDIDO ) D2_PEDIDO, MAX( D2_ITEMPV ) D2_ITEMPV "
	cQuery += "                FROM " + RetSQLName( "SD2" )
	cQuery += "               WHERE D_E_L_E_T_ = ' ' "
	cQuery += "               GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_COD ) XORI "
	cQuery += "       ON XORI.D2_FILIAL = '" + xFilial( "SD2" ) + "' "
	cQuery += "      AND SC6.C6_XNFORIG = XORI.D2_DOC "
	cQuery += "      AND SC6.C6_XSERORI = XORI.D2_SERIE "
	cQuery += "      AND SC6.C6_PRODUTO = XORI.D2_COD "
	cQuery += "      AND SC6.C6_CF IN('5112','6112') "
	cQuery += "WHERE "
	cQuery += "  SD2.D2_FILIAL = '" + xFilial("SD2") + "' "   
	cQuery += "  AND SUBSTR( SD2.D2_EMISSAO, 1, 6 ) = '" + cAnoMes + "' "
	cQuery += "  AND SB1.B1_SEGMENT  = '" + cSegment + "' "
	cQuery += "  AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "
	cQuery += "  AND SD2.D_E_L_E_T_ = ' ' AND SD2.D2_TIPO IN ('N','C','I','P') "
	cQuery += "ORDER BY SD2.D2_DOC, SD2.D2_COD "
	If Select( "TMP_SD2" ) > 0
		TMP_SD2->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SD2", .T., .F. )

	While TMP_SD2->( !Eof() )

		If AllTrim( TMP_SD2->D2_CF ) $ '5112/6112' .and. ( !Empty( TMP_SD2->D2_XNFORI ) )
			nRet += ( TMP_SD2->CUSTOORI / TMP_SD2->XQUANT ) * TMP_SD2->D2_QUANT
		Else
			nRet += TMP_SD2->D2_CUSTO1
		Endif

		TMP_SD2->( dbSkip() )
	End

Return nRet
