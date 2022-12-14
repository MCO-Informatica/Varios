#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
User Function RESTR01()

Local wnrel
Local tamanho := "G"
Local titulo  := AllTrim("Consumo Real x Standard")	//"Consumo Real x Standard"
Local cDesc1  := "Este programa ira imprimir a relacao de "
Local cDesc2  := "Consumo Real x Standard.                "
Local cDesc3  := ""
Local cString := "SB1"
Local lRet	  := .T.

Private aReturn    := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
Private cPerg      := PadR("MTR451",Len(SX1->X1_GRUPO))
Private nLastKey   := 0 
Private nTamDecQtd := TamSX3("D3_QUANT")[2]
Private nTamDecCus := 0

If lRet
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Variaveis utilizadas para Impressao do Cabecalho e Rodape    ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	li       := 80
	m_pag    := 1
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Verifica as perguntas selecionadas                           ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	AjustaSX1()
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Variaveis utilizadas para parametros                         ?
	//? mv_par01    // Listagem por Ordem de Producao ou Produto.    ?
	//? mv_par02    // Listagem Sintetica ou Analitica.              ?
	//? mv_par03    // De                                            ?
	//? mv_par04    // Ate                                           ?
	//? mv_par05    // Custo do Consumo Real 1...6 ( Moeda )         ?
	//? mv_par06    // Custo do Consumo Std  1...6                   ?
	//? mv_par07    // Movimentacao De                               ?
	//? mv_par08    // Movimentacao Ate                              ?
	//? mv_par09    // Calcular Pela Estrutura / Empenho             ?
	//? mv_par10    // Aglutina por Produto.                         ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	Pergunte("MTR451",.F.)
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Envia controle para a funcao SETPRINT                        ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	wnrel:="MATR450" //Nome Default do relatorio em Disco
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)
	
	If nLastKey = 27
		dbClearFilter()
	Else

		SetDefault(aReturn,cString)

		RptStatus({|lEnd| C450Imp(@lEnd,tamanho,titulo,wnRel,cString)},titulo)

	EndIf

EndIf
	
Return Nil

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un놹o    ? C450IMP  ? Autor ? Rodrigo de A. Sartorio? Data ? 11.12.95 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Chamada do Relatorio                                       낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR450	  		                                          낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
Static Function C450Imp(lEnd,tamanho,titulo,wnRel,cString)
Local cAnt       := ""
Local cbCont     := 0
Local aTam       := {}
Local nQuantG1   := 0
Local CbTxt      := Space(10)
Local nomeprog   := "MATR450"
Local cPicD3C114 := PesqPict("SD3","D3_CUSTO5",14)
Local cPicD3C116 := PesqPict("SD3","D3_CUSTO5",16)
Local cPicD3C118 := PesqPict("SD3","D3_CUSTO5",18)
Local aAreaD3    := SD3->(GetArea())
Local aRetSD3    := {} // Variavel que recebe conteudo de controle das validacoes das RE's Fantasma
Local cOpAnt     := ""
Local lOpConf    := .T.
Local aRecnoD4   := {}
Local cCondFiltr := ""
Local nPosTrb1   := 0
Local nPosTrb2   := 0
Local nPosTrb3   := 0
Local cabec1
Local cabec2
Local nI

Private aLstTrb1  := {}
Private aLstTrb2  := {}
Private aLstTrb3  := {}
Private lQuery    := .F.
Private cAliasNew := "SD3"

aTam        := TamSX3("D3_CUSTO5")
nTamIntCus  := aTam[1]
nTamDecCus  := aTam[2]
cCondFiltr  := aReturn[7]

If Empty(cCondFiltr)
	cCondFiltr := ".T."
EndIf

dbSelectArea("SB1")
dbClearFilter()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Corre SD3 para gerar registro de trabalho.	                 ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SD3")
dbSetOrder(6)

#IFDEF TOP
	If TcSrvType()<>"AS/400"
		lQuery    := .T.
		cAliasNew := CriaTrab(NIL,.F.)
		cQuery := "SELECT SD3.* ,R_E_C_N_O_ D3REC "
		cQuery += " FROM "+RetSqlName("SD3")+" SD3 "
		cQuery += " WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' AND "
		cQuery += " SD3.D3_OP <> '"+Space(Len(SD3->D3_OP))+"' AND "
		cQuery += " SD3.D3_CF <> 'ER0' AND SD3.D3_CF <> 'ER1' AND "
		cQuery += " SD3.D3_EMISSAO >= '" + DTOS(mv_par07) + "' AND "
		cQuery += " SD3.D3_EMISSAO <= '" + DTOS(mv_par08) + "' AND "
		cQuery += " SD3.D3_ESTORNO = ' ' AND "
		cQuery += " SD3.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY "+SqlOrder(SD3->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
		aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasNew,x[1],x[2],x[3],x[4]),Nil)})
	EndIf
#ENDIF

SetRegua(SD3->(RecCount())) // Total de Elementos da regua

If !lQuery
	SD3->( dbSeek(xFilial("SD3")+DTOS(mv_par07), .T.) )
EndIf

While (cAliasNew)->( !Eof() .And. If(lQuery,.T.,D3_FILIAL == xFilial("SD3") .And. D3_EMISSAO <= mv_par08) )

	IncRegua()

	If !lQuery 
		If (cAliasNew)->D3_ESTORNO == "S" .Or. Empty( (cAliasNew)->D3_OP ) .Or. ;
			(cAliasNew)->D3_CF == 'ER0' .Or. (cAliasNew)->D3_CF == 'ER1'
			(cAliasNew)->(DbSkip())
			Loop
		EndIf	
	EndIf

	//-- Posiciona tabela SB1
	If SB1->(B1_FILIAL+B1_COD)#(xFilial("SB1")+(cAliasNew)->D3_COD)
		SB1->( dbSeek(xFilial("SB1")+(cAliasNew)->D3_COD) )
	EndIf

	//-- Posiciona tabela SC2
	If SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)#(xFilial("SC2")+(cAliasNew)->D3_OP)
		SC2->( dbSeek(xFilial("SC2")+(cAliasNew)->D3_OP) )
	EndIf
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Le requisicoes e devolucoes SD3 e grava no Array aLstTrb1 para gravacao do REAL  ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If SubStr((cAliasNew)->D3_CF,2,1)$"E" .And. IIf(lQuery,.T.,!Empty((cAliasNew)->D3_OP))

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Ordem de Producao / Produto                                  ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If mv_par01 == 1
			nPosTrb1 := aScan(aLstTrb1,{|x| x[2]+x[1]==(cAliasNew)->D3_OP+(cAliasNew)->D3_COD})
		Else
			If mv_par10 == 1
				nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]==SC2->C2_PRODUTO+(cAliasNew)->D3_COD})
			Else
				nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+(cAliasNew)->D3_COD+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
			EndIf
		EndIf

		If Empty(nPosTrb1)
			aAdd(aLstTrb1,{	(cAliasNew)->D3_COD,;						//01 - PRODUTO
							(cAliasNew)->D3_OP,	;	 					//02 - OP
							(cAliasNew)->D3_NUMSEQ,	; 					//03 - NUMSEQ
							R450TRT("RE"),;						 		//04 - TRT
							(cAliasNew)->D3_CHAVE,;		 				//05 - CHAVE
							(cAliasNew)->D3_EMISSAO,;					//06 - EMISSAO
							SC2->C2_PRODUTO,;			 				//07 - PAI
							"",	;							 			//08 - FIXVAR
							R450Qtd("R",0,cAliasNew),; 					//09 - QTDREAL
							0,;						 					//10 - QTDSTD
							0,;						 					//11 - QTDVAR
							0,;						 					//12 - CUSTOSTD
							R450Cus('R', mv_par05,,cAliasNew),;			//13 - CUSTOREAL
							0	})						  				//14 - CUSTOVAR
		Else
			aLstTrb1[nPosTrb1,03] := (cAliasNew)->D3_NUMSEQ 			// 03 - NUMSEQ
			aLstTrb1[nPosTrb1,04] := R450TRT("RE")			 			// 04 - TRT 
			aLstTrb1[nPosTrb1,05] := (cAliasNew)->D3_CHAVE				// 05 - CHAVE
			aLstTrb1[nPosTrb1,06] := (cAliasNew)->D3_EMISSAO			// 06 - EMISSAO	
			aLstTrb1[nPosTrb1,09] += R450Qtd("R",0,cAliasNew)         	// 09 - QTDREAL
			aLstTrb1[nPosTrb1,13] += R450Cus('R', mv_par05,,cAliasNew)	// 13 - CUSTOREAL
		EndIf
	
	EndIf
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Le producoes e grava aLstTrb2 para gravacao do STANDARD      ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If SubStr((cAliasNew)->D3_CF,1,2)$"PR" 
	
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Considera filtro de Usuario                                  ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If !( SB1->( dbSeek(xFilial("SB1")+(cAliasNew)->D3_COD)  .And. &(cCondFiltr) ) )
			(cAliasNew)->(dbSkip())
			Loop
		EndIf

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Lista por Ordem de Producao / Produto                        ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If mv_par01 == 1
			nPosTrb2 := aScan(aLstTrb2,{|x|x[2]==(cAliasNew)->D3_OP})
		Else
			nPosTrb2 := aScan(aLstTrb2,{|x|x[1]==(cAliasNew)->D3_COD})
		EndIf

		If Empty(nPosTrb2)
			aAdd(aLstTrb2,Array(4))
			nPosTrb2 := Len(aLstTrb2)
			aLstTrb2[nPosTrb2,4] := 0
		EndIf

		aLstTrb2[nPosTrb2,1] := (cAliasNew)->D3_COD
		aLstTrb2[nPosTrb2,2] := (cAliasNew)->D3_OP
		aLstTrb2[nPosTrb2,3] := (cAliasNew)->D3_UM
		aLstTrb2[nPosTrb2,4] += (cAliasNew)->D3_QUANT

		cProduto := (cAliasNew)->D3_COD

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Calcular pela Estrutura                                      ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If mv_par09 == 1
			dbSelectArea("SG1")
			dbSetOrder(1)
			dbSeek(xFilial("SG1")+cProduto)
			While !Eof() .And. xFilial("SG1")+cProduto == G1_FILIAL + G1_COD
				If G1_INI > dDataBase .Or. G1_FIM < dDataBase
					dbSelectArea("SG1")
					dbSkip()
					Loop
				EndIf
				dbSelectArea("SB1")
				MsSeek(xFilial("SB1")+(cAliasNew)->D3_COD)
				If SG1->G1_FIXVAR == "F"
					nQuantG1 := SG1->G1_QUANT
					If (cAliasNew)->D3_PARCTOT == 'P'
						nQuantG1 := Round(nQuantG1*IIf(SC2->(C2_QUJE==C2_QUANT),1,SC2->(C2_QUJE/C2_QUANT)),nTamDecQtd)
					EndIf
				Else
					nQuantG1 := ExplEstr((cAliasNew)->D3_QUANT,,SC2->C2_OPC)
				EndIf

				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//? Se Produto for FANTASMA gravar so os componentes.            ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				//If SB1->B1_FANTASM == "S"
				//	R450Fant( nQuantG1 )
				//Else
					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//? Gravar Valores da Producao em TRB.                           ?
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
					dbSelectArea("SB1")
					dbSeek(xFilial("SB1")+SG1->G1_COMP)
					If Found()
						If mv_par01 == 1
							nPosTrb1 := aScan(aLstTrb1,{|x| x[2]+x[1]==(cAliasNew)->D3_OP+SG1->G1_COMP})
						Else
							If mv_par10 == 1
								nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]==SC2->C2_PRODUTO+SG1->G1_COMP})
							Else
								nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+SG1->G1_COMP+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
							EndIf
						EndIf

						//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
						//? Valida Requesicoes do mesmo componente para a mesma estrutura ?
						//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
						If !Empty(nPosTrb1) .And. !Empty(aLstTrb1[nPosTrb1,4])
							aRetSD3 := R450TRT("PR",nPosTrb1)
						Else
							aRetSD3 := {"",0,.F.}
						EndIf

						If Empty(nPosTrb1)
							aAdd(aLstTrb1,Array(14))
							nPosTrb1 := Len(aLstTrb1)
							aLstTrb1[nPosTrb1,01] := SG1->G1_COMP
							aLstTrb1[nPosTrb1,02] := (cAliasNew)->D3_OP
							aLstTrb1[nPosTrb1,09] := 0
							aLstTrb1[nPosTrb1,10] := 0
							aLstTrb1[nPosTrb1,11] := 0
							aLstTrb1[nPosTrb1,12] := 0
							aLstTrb1[nPosTrb1,13] := 0
							aLstTrb1[nPosTrb1,14] := 0
						EndIf
						aLstTrb1[nPosTrb1,04] := aRetSD3[1]
						aLstTrb1[nPosTrb1,07] := cProduto
						aLstTrb1[nPosTrb1,08] := SG1->G1_FIXVAR
						aLstTrb1[nPosTrb1,10] += Round(nQuantG1,nTamDecQtd)
						aLstTrb1[nPosTrb1,12] += R450Cus("S",mv_par06,Round(nQuantG1,nTamDecCus))

						If aRetSD3[3] .And. !lQuery
							(cAliasNew)->( dbGoTo(aRetSD3[2]) )
						EndIf

					EndIf

				//EndIf

				dbSelectArea("SG1")
				dbSkip()
			EndDo
			
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Calcular pelo Empenho                                        ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		Else

			dbSelectArea("SD4")
			dbSetOrder(2)
			dbSeek(xFilial("SD4")+(cAliasNew)->D3_OP)
			If (cAliasNew)->D3_OP # cOpAnt
				lOpConf:=.T.
			Else
				lOpConf:=.F.
			EndIf

			While SD4->(!Eof() .And. D4_FILIAL + D4_OP == xFilial("SD4")+(cAliasNew)->D3_OP ) .And. cOpAnt # (cAliasNew)->D3_OP .And. lOpConf

				If aScan(aRecnoD4, SD4->(RecNo())) > 0
					dbSkip()
					Loop
				EndIf

				aAdd(aRecnoD4, SD4->(RecNo()))

				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//? Gravar Valores da Producao em TRB.                           ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				dbSelectArea("SB1")
				dbSeek(xFilial("SB1")+SD4->D4_COD)
				If mv_par01 == 1
					nPosTrb1 := aScan(aLstTrb1,{|x|x[2]+x[1]==(cAliasNew)->D3_OP+SD4->D4_COD})
				Else
					If mv_par10 == 1
						nPosTrb1 := aScan(aLstTrb1,{|x|x[7]+x[1]==SC2->C2_PRODUTO+SD4->D4_COD}) 
					Else
						nPosTrb1 := aScan(aLstTrb1,{|x|x[7]+x[1]+x[2]==SC2->C2_PRODUTO+SD4->D4_COD+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})  
					EndIf   
				EndIf	
					
				If Empty(nPosTrb1)
					aAdd(aLstTrb1,Array(14))
					nPosTrb1 := Len(aLstTrb1)
					aLstTrb1[nPosTrb1,01] := SD4->D4_COD
					aLstTrb1[nPosTrb1,02] := (cAliasNew)->D3_OP
					aLstTrb1[nPosTrb1,09] := 0
					aLstTrb1[nPosTrb1,10] := 0
					aLstTrb1[nPosTrb1,11] := 0
					aLstTrb1[nPosTrb1,12] := 0
					aLstTrb1[nPosTrb1,13] := 0
					aLstTrb1[nPosTrb1,14] := 0
				EndIf
				aLstTrb1[nPosTrb1,07] := cProduto
				aLstTrb1[nPosTrb1,08] := ""

				If Empty(SD4->D4_QUANT)
					aLstTrb1[nPosTrb1,10] += Round(SD4->D4_QTDEORI*IIf(SC2->(C2_QUJE==C2_QUANT),1,SC2->(C2_QUJE/C2_QUANT)),nTamDecQtd)
				Else
					aLstTrb1[nPosTrb1,10] += Round((SD4->D4_QTDEORI-SD4->D4_QUANT),nTamDecQtd)
				EndIf
					aLstTrb1[nPosTrb1,12] += R450Cus("S",mv_par06, Round((SD4->D4_QTDEORI-SD4->D4_QUANT),nTamDecQtd))//aLstTrb1[nPosTrb1,10])
				
				dbSelectArea("SD4")
				dbSkip()
				
			EndDo
			cOpAnt := (cAliasNew)->D3_OP
		EndIf
		dbSelectArea(cAliasNew)
	EndIf

	dbSkip()

EndDo

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Monta os Cabecalhos                                          ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cProduto := ""
cabec1   :="CODIGO           M A T E R I A L                  |              C O N S U M O  R E A L              |           C O N S U M O  S T A N D A R D         |                          V A R I A C A O 	                      "
cabec2   :="                 DESCRICAO                     UM |      QUANTIDADE      CUSTO UN.       VALOR TOTAL |      QUANTIDADE      CUSTO UN.       VALOR TOTAL |     QUANTIDADE     VALOR TOTAL          $QTD.    $VALOR         %  "
//                     123456789012345  12345678901234567890123456789 12    1234567890123  12345678901234    12345678901234    1234567890123  12345678901234    12345678901234   123456789012    12345678901234 12345678901234  123456789012 1234567
//                                                                         123456789012345                 1234567890123456   123456789012345                 1234567890123456  123456789012345                                1234567890123
//                               1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17         18       19        20        21        22
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec3   := ""
titulo   += IIf( mv_par01 == 1, " ( Por Ordem de Producao )"," ( Por Produto )" )		//" ( Por Ordem de Producao )"###" ( Por Produto )"

SetRegua(Len(aLstTrb1))		// Total de Elementos da regua

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Ordena por Ordem de Producao/Produto                         ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If mv_par01 == 1
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[2]+x[1] < y[2]+y[1] })
Else
	aLstTrb1 := ASort(aLstTrb1,,, { | x,y | x[7]+x[1] < y[7]+y[1] })
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Inicio da Impressao                                          ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
nQuantOp := 0.00

For nI:=1 To Len(aLstTrb1)

	IncRegua()

	If lEnd
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Filtro por OP / Produto                                      ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If mv_par01 == 1
		// Filtrar por OP
		If AllTrim(aLstTrb1[nI,2]) < AllTrim(mv_par03) .Or. AllTrim(aLstTrb1[nI,2]) > AllTrim(mv_par04)
           Loop
		EndIf
	Else
		// Filtrar por Produto Pai
		If aLstTrb1[nI,7] < mv_par03 .Or. aLstTrb1[nI,7] > mv_par04
			Loop	
		EndIf
	EndIf

	If li > 55 .And. mv_par02 == 1
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		li-= 2
	EndIf

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Impressao por OP e PRODUTO                               ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If mv_par01 = 1
		nPosTrb2 := aScan(aLstTrb2,{|x| x[2]==aLstTrb1[nI,2]})
	Else
		nPosTrb2 := aScan(aLstTrb2,{|x| x[1]==aLstTrb1[nI,7]})	
	EndIf

	If Empty(nPosTrb2)
		Loop
	EndIf

	If mv_par02 == 1
		R450Linha(@li,.F.)
		li++
		@ li,000 PSAY If(mv_par01=1,"OP: "+aLstTrb2[nPosTrb2,2],"PRODUTO:") //"OP: "###"PRODUTO:"
		@ li,017 PSAY Left(aLstTrb2[nPosTrb2,1],29)
		@ li,030 PSAY Iif(Empty(Posicione("SC2",1,xFilial("SC2")+aLstTrb2[nPosTrb2,2],"C2_DATRF")),"Em Aberto","Encerrada")
		@ li,048 PSAY aLstTrb2[nPosTrb2,3]
		//@ li,050 PSAY "|"
		@ li,052 PSAY aLstTrb2[nPosTrb2,4] PICTURE PesqPict("SC2","C2_QUANT",15)
		@ li,071 PSAY "Qtde Orig: "
		@ li,083 PSAY Posicione("SC2",1,xFilial("SC2")+aLstTrb2[nPosTrb2,2],"C2_QUANT") PICTURE PesqPict("SC2","C2_QUANT",15)
		@ li,106 PSAY Posicione("SB1",1,xFilial("SB1")+aLstTrb2[nPosTrb2,1],"B1_DESC")
		@ li,158 PSAY "Custo Tabela: "+Transform(Posicione("SB1",1,xFilial("SB1")+aLstTrb2[nPosTrb2,1],"B1_CUSTAB"),"@E 999,999.99")
		@ li,198 PSAY "Custo Medio: "+Transform(Posicione("SB2",1,xFilial("SB2")+aLstTrb2[nPosTrb2,1],"B2_CM1"),"@E 999,999.99")
		li++
		@ li,050 PSAY "|"
		@ li,101 PSAY "|"
		@ li,152 PSAY "|"
		nQuantOp := aLstTrb2[nPosTrb2,4]
	EndIf

	nCusStdOP := nTotStdOP := nCusRealOP := nTotRealOP := nTotVarOP := 0
	nCusUnitR := nCusUnitS := 0
	cAnt := IIf( mv_par01 == 1,aLstTrb1[nI,02],aLstTrb1[nI,07])
	While nI <= Len(aLstTrb1) .And. IIf( mv_par01 == 1,aLstTrb1[nI,2],aLstTrb1[nI,7]) == cAnt

		If li > 58 .And. mv_par02 == 1
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIf

		nTotalVar  := aLstTrb1[nI,13]-aLstTrb1[nI,12]  //CUSTOREAL-CUSTOSTD
		nQtdVar    := aLstTrb1[nI,09]-aLstTrb1[nI,10]	//QTDREAL-QTDSTD
		nPercent   := (nQtdVar/aLstTrb1[nI,10])*100	//((QTDREAL-QTDSTD)/QTDSTD)*100
		nCusUnit   := IIf(Empty(aLstTrb1[nI,09]),aLstTrb1[nI,13],Round(aLstTrb1[nI,13]/aLstTrb1[nI,09],nTamDecCus))	//Round(CUSTOREAL/IIF(QTDREAL=0,1,QTDREAL),nTamDecCus)
		nCusUStd   := IIf(Empty(aLstTrb1[nI,10]),aLstTrb1[nI,12],Round(aLstTrb1[nI,12]/aLstTrb1[nI,10],nTamDecCus))	//Round(CUSTOSTD/IIF(QTDSTD=0,1,QTDSTD),nTamDecCus)
		nSValor    := Round(nCusUnit*nQtdVar,nTamDecCus)
		nSQuant    := Round(nTotalVar-nSValor,nTamDecCus)

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Posiciona na tabela de PRODUTOS                          ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		SB1->(DbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+aLstTrb1[nI,01]))	

		If mv_par02 == 1 .And. (mv_par09 == 1 .Or. (QtdComp(aLstTrb1[nI,09],.T.) # QtdComp(0,.T.)))
			li++
			@ li,000 PSAY aLstTrb1[nI,01]
			@ li,016 PSAY Pad(SB1->B1_DESC,29)
			@ li,047 PSAY SB1->B1_UM
			@ li,050 PSAY "|"
			@ li,052 PSAY aLstTrb1[nI,09]	PICTURE PesqPict("SD3","D3_QUANT",15)
			@ li,068 PSAY nCusUnit 			PICTURE cPicD3C114
			@ li,084 PSAY aLstTrb1[nI,13]	PICTURE cPicD3C116
			@ li,101 PSAY "|"
			@ li,103 PSAY aLstTrb1[nI,10]	PICTURE PesqPict("SD3","D3_QUANT",15)
			@ li,119 PSAY nCusUStd			PICTURE cPicD3C114
			@ li,135 PSAY aLstTrb1[nI,12]  	PICTURE cPicD3C116
			@ li,152 PSAY "|"
			@ li,153 PSAY nQtdVar		PICTURE PesqPict("SD3","D3_QUANT",15)
			@ li,167 PSAY nTotalVar 	PICTURE cPicD3C114
			@ li,181 PSAY nSValor		PICTURE cPicD3C114
			@ li,197 PSAY nSQuant		PICTURE PesqPict("SD3","D3_QUANT",13)
			@ li,211 PSAY nPercent		PICTURE "9999.99"
		EndIf

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Aglutinar Produto para Posterior Resumo.                 ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		nPosTrb3 := aScan(aLstTrb3,{|x|x[1]==aLstTrb1[nI,1]})
		If Empty(nPosTrb3)
			aAdd(aLstTrb3,{	aLstTrb1[nI,01],; //PRODUTO
							aLstTrb1[nI,09],; //QTDREAL
							aLstTrb1[nI,10],; //QTDSTD
							aLstTrb1[nI,13],; //CUSTOREAL
							aLstTrb1[nI,12],; //CUSTOSTD
							SB1->B1_DESC})	   //DESCRICAO
		Else
			aLstTrb3[nPosTrb3,02] += aLstTrb1[nI,09] //QTDREAL
			aLstTrb3[nPosTrb3,03] += aLstTrb1[nI,10] //QTDSTD
			aLstTrb3[nPosTrb3,04] += aLstTrb1[nI,13] //CUSTOREAL
			aLstTrb3[nPosTrb3,05] += aLstTrb1[nI,12] //CUSTOSTD
		EndIf

		nCusUnitR  += nCusUnit
		nCusUnitS  += nCusUStd
		nTotRealOP += aLstTrb1[nI,13]
		nTotStdOP  += aLstTrb1[nI,12]
		nTotVarOP  += nTotalVar
		nI++
		If nI > Len(aLstTrb1) .Or. IIF( mv_par01 == 1,aLstTrb1[nI,2],aLstTrb1[nI,7]) # cAnt
			nI--
			Exit
		EndIf
	EndDo
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Impressao dos Totais por OP/Produto.                     ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If mv_par02 == 1
		R450Linha(@li,.T.)
		li++
		@ li,000 PSAY "Total " +IIF(mv_par01==1,"da OP:","do Produto:")		//"Total "###"da OP:"###"do Produto:"
		@ li,050 PSAY "|"
		@ li,066 PSAY (nTotRealOP/nQuantOp)	PICTURE cPicD3C116
		@ li,082 PSAY nTotRealOP	        PICTURE cPicD3C118
		@ li,101 PSAY "|"
		@ li,117 PSAY (nTotStdOP/nQuantOp)	PICTURE cPicD3C116
		@ li,133 PSAY nTotStdOP            	PICTURE cPicD3C118
		@ li,152 PSAY "|"
		@ li,164 PSAY nTotVarOP 	       	PICTURE cPicD3C118
		R450Linha(@li,.T.)
	EndIf
Next

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Impressao do Resumo Aglutinado por Produto.              ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
li := 80

titulo := "V A R I A C A O   DE   U S O   E   C O N S U M O"
cabec1 := ""
cabec2 := ""
cabec3 := ""
//cLinha := "|-----------------------------------------------------------|"
//cLinha += "|-------------------|------------------|--------------------|"
//cLinha += "|-------------------|------------------|--------------------|"
cLinha := __PrtThinLine()

SetRegua(Len(aLstTrb3))		// Total de Elementos da regua

aLstTrb3 := aSort(aLstTrb3,,, { | x,y | x[1] < y[1] })

For nI:=1 To Len(aLstTrb3)

	IncRegua()

	If lEnd
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf

	If li > 58
		R450CabRes(titulo,cabec1,cabec2,nomeprog,tamanho)
	EndIf

	@ li,000 PSAY "|"
	@ li,003 PSAY aLstTrb3[nI,01]
	@ li,021 PSAY Pad(aLstTrb3[nI,06],29)
	@ li,056 PSAY "|"
	@ li,058 PSAY aLstTrb3[nI,02]	 PICTURE PesqPict("SD3","D3_QUANT",16)
	@ li,075 PSAY "|"
	@ li,077 PSAY aLstTrb3[nI,04]	 PICTURE cPicD3C118
	@ li,096 PSAY "|"
	@ li,098 PSAY aLstTrb3[nI,03]	 PICTURE PesqPict("SD3","D3_QUANT",16)
	@ li,115 PSAY "|"
	@ li,117 PSAY aLstTrb3[nI,05]	 PICTURE cPicD3C118
	@ li,136 PSAY "|"
	@ li,138 PSAY Round(aLstTrb3[nI,02]-aLstTrb3[nI,03],nTamDecCus) PICTURE PesqPict("SD3","D3_QUANT",16)
	@ li,155 PSAY "|"
	@ li,157 PSAY Round(aLstTrb3[nI,04]-aLstTrb3[nI,05],nTamDecCus)	 PICTURE cPicD3C118
	@ li,176 PSAY "|"
	@ li,188 PSAY (Round(aLstTrb3[nI,02]-aLstTrb3[nI,03],nTamDecCus) / aLstTrb3[nI,03]) * 100 PICTURE "9999.99" //-- Percentual 
	@ li,197 PSAY "|"	
	li++
	@ li,000 PSAY cLinha
	li++
Next

If li != 80
	roda(cbcont,cbtxt,"G")
EndIf

If aReturn[5] = 1
	Set Printer To
	dbCommitall()
	ourspool(wnrel)
EndIf

dbSelectArea("SB1")
RetIndex("SB1")
dbClearFilter()
dbSetOrder(1)

If lQuery
	dbSelectArea(cAliasNew)
	dbCloseArea()
	dbSelectArea("SD3")
EndIf

RestArea(aAreaD3)
MS_FLUSH()
Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? R450Linha? Autor ? Jose Lucas            ? Data ? 21.09.93 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Imprimir caracteres barra e ifens como separadores.        낢?
굇?          ?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe e ? MATR450(void)                                              낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? Generico                                                   낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
*/
Static Function R450Linha(li,nImpTraco)
Local cLinha
li++
If nImpTraco
	//cLinha := "--------------------------------------------------|"
	//cLinha += "--------------------------------------------------|"
	//cLinha += "--------------------------------------------------|"
	//cLinha += "---------------------------------------------------"
	cLinha := __PrtThinLine()
Else
	cLinha := "                                                  |"
	cLinha += "                                                  |"
	cLinha += "                                                  |"
EndIf
@ li,000 PSAY cLinha
Return Nil

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? R450CabRes? Autor ? Jose Lucas           ? Data ? 21.09.93 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Impressao do Cabecalho do Resumo.                          낢?
굇?          ?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe e ? R450CabRes(void)                                           낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR450                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
*/
Static Function R450CabRes(titulo,cabec1,cabec2,nomeprog,tamanho)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
@ li,000 PSAY __PrtThinLine()
li++
@ li,000 PSAY "|                                                       |        C O N S U M O  R E A L         |    C O N S U M O  S T A N D A R D     |            V A R I A C A O            |"
li++
@ li,000 PSAY "|  CODIGO            DESCRICAO                          |---------------------------------------|---------------------------------------|---------------------------------------|"
li++
@ li,000 PSAY "|                                                       |      QUANTIDADE  |             VALOR  |      QUANTIDADE  |             VALOR  |      QUANTIDADE  |             VALOR  |"
li++
@ li,000 PSAY __PrtFatLine()
li++
Return Nil

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? R450Cus   ? Autor ? Erike Yuri da Silva  ? Data ?14/03/2006낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Retorna o Custo.                                           낢?
굇?          ?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe e ? ExpN1 := R450Cus(ExpC1,ExpN2,ExpN3)                        낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros? ExpC1 := Tipo "S" para Standard e "R" para Real            낢?
굇?          ? ExpC1 := Tipo "S" para Standard e "R" para Real            낢?
굇?          ? ExpN2 := Indica a Moeda para obtencao do Custo             낢?
굇?          ? ExpN3 := Quantidade utilizada.                             낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR450                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?*/
Static Function R450Cus(cTipo,nMoeda,nQtd,cAliasSD3)

Local aAreaAnt  := GetArea()
Local nRet      := 0

Default cAliasSD3 := "SD3"
Default nQtd      := 0

If cTipo = "R" 	// Custo Real
	nRet := (cAliasSD3)->( &("D3_CUSTO"+ Str(nMoeda,1)) ) * IIf(SubStr((cAliasSD3)->D3_CF, 1, 1) == 'R', 1, -1)
Else  // Custo Standard
	dbSelectArea("SB1")
	nRet := (nQtd*xMoeda(RetFldProd(SB1->B1_COD,"B1_CUSTD"),Val(RetFldProd(SB1->B1_COD,"B1_MCUSTD")), nMoeda, RetFldProd(SB1->B1_COD,"B1_DATREF") ))
EndIf

RestArea(aAreaAnt)
Return (nRet)

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? R450Fant  ? Autor ? Cesar Eduardo Valadao? Data ? 01.06.99 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Retorna a Estrutura de Produto Fantasma                    낢?
굇?          ? Funcao Recursiva.                                          낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe e ? R450Fant(ExpN1)                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros? ExpN1 := Quantidade do Pai.                                낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR450                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
*/
Static Function R450Fant(nQuantPai)
Local aAreaAnt  := GetArea()
Local aAreaSB1  := SB1->(GetArea())
Local aAreaSG1  := SG1->(GetArea())
Local cComponen := SG1->G1_COMP
Local nPosTrb1  := 0
Local nPosTrb2  := 0

dbSelectArea("SG1")
If dbSeek(xFilial("SG1")+cComponen, .F.)
	While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cComponen
		If G1_INI > dDataBase .Or. G1_FIM < dDataBase
			dbSkip()
			Loop
		EndIf
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Gravar Valores da Producao em TRB do componente.             ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		dbSelectArea("SB1")
		If dbSeek(xFilial("SB1")+SG1->G1_COMP)
			If SG1->G1_FIXVAR == "F"
				nQuantG1 := SG1->G1_QUANT
			Else
				nQuantG1 := ExplEstr(nQuantPai,,SC2->C2_OPC)
			EndIf
			If mv_par01 == 1
				nPosTrb1 := aScan(aLstTrb1,{|x| x[2]+x[1]==(cAliasNew)->D3_OP+SG1->G1_COMP})
			Else
				If mv_par10 == 1
					nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]==SC2->C2_PRODUTO+SG1->G1_COMP})
				Else
					nPosTrb1 := aScan(aLstTrb1,{|x| x[7]+x[1]+x[2]==SC2->C2_PRODUTO+SG1->G1_COMP+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)})
				EndIf				
			EndIf

			//If SB1->B1_FANTASM == "S"
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//? Se Produto for FANTASMA gravar so os componentes.            ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			//	R450Fant(nQuantG1 )
			//Else
				If !Empty(nPosTrb1) .And. !Empty(aLstTrb1[nPosTrb1,04])
					aRetSD3 := R450TRT("PR",nPosTrb1)
				Else
					aRetSD3 := {"",0,.F.}
				EndIF

				If Empty(nPosTrb1)
					aAdd(aLstTrb1,Array(14))
					nPosTrb1 := Len(aLstTrb1)
					aLstTrb1[nPosTrb1,01] := SG1->G1_COMP
					aLstTrb1[nPosTrb1,02] := (cAliasNew)->D3_OP
					aLstTrb1[nPosTrb1,09] := 0
					aLstTrb1[nPosTrb1,10] := 0
					aLstTrb1[nPosTrb1,12] := 0
					aLstTrb1[nPosTrb1,13] := 0
					aLstTrb1[nPosTrb1,14] := 0
				EndIf
				aLstTrb1[nPosTrb1,04] := aRetSD3[1]
				aLstTrb1[nPosTrb1,07] := cProduto
				aLstTrb1[nPosTrb1,08] := SG1->G1_FIXVAR
				aLstTrb1[nPosTrb1,10] += Round(nQuantG1,nTamDecQtd)
				aLstTrb1[nPosTrb1,12] += R450Cus("S",mv_par06,Round(nQuantG1,nTamDecCus))

				// Volta ao Registro Original do SD3
				If aRetSD3[3] .And. ! lQuery
					(cAliasNew)->( dbGoTo(aRetSD3[2]) )
				EndIf

			//EndIf
		EndIf
		dbSelectArea("SG1")
		dbSkip()
	End
EndIf
RestArea(aAreaSB1)
RestArea(aAreaSG1)
RestArea(aAreaAnt)
Return(Nil)

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? R450TRT   ? Autor ? Marcelo Iuspa        ? Data ? 24.11.03 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri놹o ? Funcao para tratar duas ou mais requisicoes de um mesmo    낢?
굇?          ? componente utilizados dentro da mesma estrutura.           낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe   ? R450Fant(ExpC1,ExpN2)                                      낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros? ExpC1 := Tipo de Movimento 'RE' ou 'PR'                    낢?
굇?          ? ExpN1 := Numero da Linha                                   낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR450                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
*/
Static Function R450TRT(cTipoMov,nLin)
Local cConteudo := If(Empty(nLin),"",RTrim(aLstTrb1[nLin,4]))
Local nRegSD3,xRetorno,nPosCorte,lReposSD3

If cTipoMov == "RE"
	// Chamado apartir da leitura das REQUISICOES para compor o REAL
	If !Empty((cAliasNew)->D3_TRT)
		If Empty(cConteudo)
			xRetorno := "   /" + (cAliasNew)->D3_TRT
		Else
			xRetorno := cConteudo+"/" + (cAliasNew)->D3_TRT
		EndIf
	EndIf
Else
	// Chamado apartir da leitura das PRODUCOES para compor o STANDARD
	lReposSD3	:= .F.
	nPosCorte	:= At("/",cConteudo)
	If nposCorte <> 0
		cTRTCorte	:= SubStr(cConteudo,1,nPosCorte-1)
		cConteudo	:= Substr(cConteudo,nPosCorte+1,Len(cConteudo))
	Else
		cTRTCorte	:= AllTrim(cConteudo)
		cConteudo	:= ""
	EndIf
	nRegSD3	:= SD3->( Recno() )
	If SD3->( dbSeek(xFilial("SD3")+DTOS(aLstTrb1[nLin,06])+aLstTrb1[nLin,03]+aLstTrb1[nLin,05]+aLstTrb1[nLin,01]) )
		Do While ! SD3->(Eof())
			If SD3->D3_TRT == cTRTCorte
				lReposSD3 := .T.
				Exit
			EndIf
			SD3->( dbSkip() )
		EndDo
		xRetorno := {cConteudo,nRegSD3,lReposSD3}
	EndIf
EndIf
Return (xRetorno)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑uncao    쿌justaSX1 ? Autor ? Flavio Luiz Vicco     ? Data ?30/06/2006낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o 쿎ria as perguntas necesarias para o programa                낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿝etorno   쿙enhum                                                      낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros쿙enhum                                                      낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/
Static Function AjustaSx1()
PutSx1('MTR451','01' , 'Relacao por?', '풰elacion por?', 'List by ?', ;
	'mv_ch1', 'N', 1, 0, 1, 'C', '', '', '', '', 'mv_par01','Ordem Producao' , 'Orden de Prod.','Product. Order', ;
	'', 'Produto', 'Producto', 'Product', '', '', '', '', '', '', '','', '', ;
	{'Impressao do relat?rio na sequencia do ', 'n?mero da OP ou Por Produto ','do cadastro de movimentos internos (SD3)'}, ;
	{'Impresion del informe ordenado por Nume-','ro de OP o por Numero de Productos del ','archivo de Movimientos Internos (SD3).  '}, ;
	{'Print the report by Production Order or ','By Product Order number order of the    ', 'internal movements file (SD3).          '}, ;
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451','02' , 'Relacao ?', '풰elacion?', 'Report ?', ;             //-- 05 - X1_PERENG
	'mv_ch2','N', 1, 0, 1, 'C', '', '', '', '', 'mv_par02', 'Analitica' , 'Analitica', 'Detailed', ;                             			//-- 19 - X1_DEFENG1
	'', 'Sintetica', 'Sintetica','Summarized', '','', '','','', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'O relat?rio ser? impresso com conteudo  ', 'analitico ou sintetico a ser considerado', ' na filtragem do cadastro de movimentos ', 'internos (SD3).                         '}, ; //--      HelpPor3#3
	{'El informe ser impreso con contenido    ', 'analitico o sintetico a ser considerado ', 'en el filtro del archivo de Movimientos ', 'Internos (SD3).                         '}, ; //--      HelpEsp3#3
	{'The report will be printed with detaile-', 'dand summarized content to be considered', ' in the filtering of internal movements ', 'file (SD3).                             '}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP
PutSx1('MTR451', '03' , 'De ? ',	'풡e ?', 'From ?', ;             //-- 05 - X1_PERENG
	'mv_ch3', 'C', 	15, 0, 0, 'G', 	'', '', '', '', 'mv_par03', '' ,'', '', Space(15), 	'', ;                   		                 //-- 21 - X1_DEF02
	'', '', '', '', '', '', '', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'De Ordem Produ豫o ou Produto inicial a  ', 'ser considerado na filtragem do cadastro', 'de movimentos internos (SD3). Depende da', ' sua escolha na primeira pergunta.      '}, ; //--      HelpPor3#3
	{'De Orden Produccion o Producto inicial a', 'ser considerado en el filtro del archivo', ' de Movimientos Internos (SD3). Depende ', 'de su eleccion en la pregunta n? 1.     '}, ; //--      HelpEsp3#3
	{'Production Order or Initial Product to  ', 'consider in filtering the internal move-', 'ments file (SD3). It depends on         ', 'yourchoice on question no. 1.           '}, ; //--      HelpEng3#3	
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '04' , 'Ate ?', '풞 ?', 'To ?', ;                                                            //-- 05 - X1_PERENG
	'mv_ch4', 'C', 15, 0, 0, 'G', '', '', '', '', 'mv_par04', '' , '', '', 'ZZZZZZZZZZZZZZZ','', ;           //-- 21 - X1_DEF02
	'', '', '', '', '', '', '',	'', '', '', '', ;                                                             //-- 32 - X1_DEFENG5
	{'De Ordem Produ豫o ou Produto final a    ', 'ser considerado na filtragem do cadastro', 'de movimentos internos (SD3). Depende da', ' sua escolha na primeira pergunta.      '}, ; //--      HelpPor3#3
	{'De Orden Produccion o Producto final  a ', 'ser considerado en el filtro del archivo', ' de Movimientos Internos (SD3). Depende ', 'de su eleccion en la pregunta n? 1.     '}, ; //--      HelpEsp3#3
	{'Production Order or Final Product to    ', 'consider in filtering the internal move-', 'ments file (SD3). It depends on         ', 'yourchoice on question no. 1.           '}, ; //--      HelpEng3#3	
	'')

PutSx1('MTR451', '05' , 'Custo Consumo Real ?', '풲ipo de Costo Real?', 'Real Consumpt.Cost ?', ;             //-- 05 - X1_PERENG
	'mv_ch5', 'N', 1, 0, 1, 'C', '', '', '','', 'mv_par05', 'Moeda 1' , 'Moneda 1','Currency 1', '', ;       //-- 20 - X1_CNT01
	'Moeda 2', 'Moneda 2', 'Currency 2', 'Moeda 3', 'Moneda 3', 'Currency 3', ;                               //-- 26 - X1_DEFENG3
	'Moeda 4', 'Moneda 4', 'Currency 4', 'Moeda 5', 'Moneda 5', 'Currency 5', {}, {}, {},  '')               //-- 36 - X1_HELP

PutSx1('MTR451', '06' , 'Custo Consumo STD  ?', '풲ipo de Costo STD ?', 'Standard Cost Type ?', ;             //-- 05 - X1_PERENG
	'mv_ch6', 'N', 1, 0, 1, 'C', '', '', '', '', 'mv_par06', 'Moeda 1' , 'Moneda 1', 'Currency 1', '', ;     //-- 20 - X1_CNT01
	'Moeda 2', 'Moneda 2', 'Currency 2', 'Moeda 3', 'Moneda 3', 'Currency 3', ;                               //-- 26 - X1_DEFENG3
	'Moeda 4', 'Moneda 4', 'Currency 4', 'Moeda 5', 'Moneda 5', 'Currency 5', ;
	{}, {}, {}, '')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '07' , 'Data de ?', '풡e Fecha?', 'From Date ?', ;             //-- 05 - X1_PERENG
	'mv_ch7', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par07', '' , '', '', '01/01/06', '', '', ;                  		                 //-- 22 - X1_DEFSPA2
	'', '', '', '', '', '', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'Data de movimenta豫o inicial a ser      ', 'considerada na filtragem do cadastro    ', 'de  movimentos internos (SD3).          '}, ; //--      HelpPor3#3
	{'Fecha de movimiento inicial a ser con-  ', 'siderado en el filtro del archivo de    ', 'Movimientos Internos (SD3).             '}, ; //--      HelpEsp3#3
	{'Initial transaction date to consider in ', 'filtering the internal movements file   ', '(SD3).                                  '}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '08' , 'Data Ate ?', '풞 Fecha?','To Date ? ', ;             //-- 05 - X1_PERENG
	'mv_ch8', 'D', 	8,	0, 	0, 'G', '', '',	'', '', 'mv_par08', '' , '','', '31/12/49', '', ;                   		                 //-- 21 - X1_DEF02
	'', '',	'','', '', '', '', '', '', '', 	'', ;                                           //-- 32 - X1_DEFENG5
	{'Data de movimenta豫o final a ser        ', 'considerada na filtragem do cadastro    ',  'de  movimentos internos (SD3).          '}, ; //--      HelpPor3#3
	{'Fecha de movimiento final a ser conside-', 'rado en el filtro del archivo de    ', 'Movimientos Internos (SD3).             '}, ; //--      HelpEsp3#3
	{'Final transaction date to consider in   ', 'filtering the internal movements file   ', '(SD3).                                  '}, ; //--      HelpEng3#3
	'')
PutSx1('MTR451', '09' , 'Calcular Pela ?', '풠alcular por?', 'Calculate by ?', ;             //-- 05 - X1_PERENG
	'mv_ch9', 'N', 	1, 	0, 	1, 'C', '', '', '', '',	'mv_par09', ;                                   //-- 16 - X1_VAR01
	'Estrutura' , 'Estructura', 'Structure', '', 'Empenho', 'Reserva', 'Allocation', '', ;                                           //-- 24 - X1_DEF03
	'', '', '', '', '', '', '', '', ;                                           //-- 32 - X1_DEFENG5
	{'Op豫o do c?lculo do custo pelo Cadastro ', 'sde Estrutura do Produto (SG1) ou pelo  ', 'Cadastro de Empenhos (SD4).             '}, ; //--      HelpPor3#3
	{'Opcion del calculo del costo por el     ', 'Archivo de Estructura del Producto (SG1)', 'o por el Archivo de Reservas (SD4).     '}, ; //--      HelpEsp3#3
	{'Option for cost calculation by the Pro- ', 'duct Structure File (SG1) or by the ', 'Allocations File (SD4).               '}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP

PutSx1('MTR451', '10' , 'Aglutina por Prod. ?', '풞grupa por Prodc ?', 'Group by Product ?', ;//-- 05 - X1_PERENG
	'mv_cha', 'N', 	1, 	0, 	2, 'C', '', '', '', '',	'mv_par10', ; //-- 16 - X1_VAR01
	'Sim' , 'Si', 'Yes', '', 'Nao', 'No', 'No', '', ; //-- 24 - X1_DEF03
	'', '', '', '', '', '', '', '', ;                 //-- 32 - X1_DEFENG5
	{'O relat?rio ser? impresso por produto ', 'com o total aglutinado a ser ', 'considerado na filtragem do cadastro de ','movimentos internos (SD3).'}, ; //--      HelpPor3#3
	{'El informe sera impreso por producto ', 'con el total aglutinado a ser consi-', 'derado en el filtro del archivo de ','Movimientos Internos (SD3).'}, ; //--      HelpEsp3#3
	{'The report will be printed by product ', 'with the grouped total to consider in ', 'filtering the internal movements file',' (SD3).'}, ; //--      HelpEng3#3
	'')                                            //-- 36 - X1_HELP
Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? R450Qtd   ? Autor ? Fernando Joly Siquini? Data ?03/05/2006낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Retorna a Quantidade                                       낢?
굇?          ?                                                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe e ? ExpN1 := R450Qtd(ExpC1,ExpN2,ExpN3)                        낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros? ExpC1 := Tipo "R" Qtde Real, "S" Qtde Standard             낢?
굇?          ? ExpN2 := Quantidade Standard                               낢?
굇?          ? ExpC3 := Alias da tabela SD3                               낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MATR450                                                    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?*/
Static Function R450Qtd(cTipo,nQuant,cAliasSD3)

Local aAreaAnt   := GetArea()
Local nRet       := 0

Default cAliasSD3:= "SD3"

If cTipo = "R" // Quantidade Real
	nRet := (cAliasSD3)->D3_QUANT*IIf(SubStr((cAliasSD3)->D3_CF, 1, 1)=='R', 1, -1)
Else // Quantidade Standard
	nRet := nQuant
EndIf

RestArea(aAreaAnt)
Return (nRet)
