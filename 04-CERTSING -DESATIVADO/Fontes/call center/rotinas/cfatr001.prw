#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.ch"


//+-----------+----------+-------+------------------+------+-----------------+
//| Programa  | CFATR001 | Autor | Felipe de Castro | Data |  22/06/11       |
//+-----------+----------+-------+------------------+------+-----------------+
//| Descr.    | Relatório de apontamento.                                    |
//+-----------+--------------------------------------------------------------+
//| Uso       | Certsign                                                     |
//+-----------+--------------------------------------------------------------+
User Function CFATR001()

	Local aPergs	:= {}
	Local aRetPar	:= {}
	Local lRet		:= .T.		

	//variaveis dos parametros do relatorio
	Local cProcVe	:= ""
	Local cOportDe	:= ""
	Local cOportAt	:= ""
	Local nStatOp	:= 0
	Local cVendDe	:= ""
	Local cVendAt	:= ""
	Local cEstgDe	:= ""
	Local cEstgAt	:= ""
	Local dAponDe	:= StoD("")
	Local dAponAt	:= StoD("")
	Local nTipRel	:= 0

	//Perguntas da rotina
	aAdd( aPergs ,{1 ,"Cod. Proc. Vend"	,"000001" ,"@!" ,".T." ,"AC2" ,"" ,6 ,.T. })                                      
	aAdd( aPergs ,{1 ,"Cod. Oport. De"	,space(6) ,"@!" ,".T." ,"AD1" ,"" ,6 ,.F. })                                      
	aAdd( aPergs ,{1 ,"Cod. Oport. Até"	,"ZZZZZZ" ,"@!" ,".T." ,"AD1" ,"" ,6 ,.T. })                                      
	
	aAdd( aPergs ,{3,"Status Oportunidade",3,{"Aberto","Encerrado","Ambos"},50,"",.T.,".T." })                                      
	
	aAdd( aPergs ,{1 ,"Cod. Vend. De"    ,space(6) ,"@!" ,".T." ,"SA3" ,"" ,6  ,.F. })                                      
	aAdd( aPergs ,{1 ,"Cod. Vend. Até"   ,"ZZZZZZ" ,"@!" ,".T." ,"SA3" ,"" ,6  ,.T. })                                      
	aAdd( aPergs ,{1 ,"Cod. Estagio De"  ,space(6) ,"@!" ,".T." ,"AC5" ,"" ,6  ,.F. })                                      
	aAdd( aPergs ,{1 ,"Cod. Estagio Até" ,space(6) ,"@!" ,".T." ,"AC5" ,"" ,6  ,.T. })                                      
	aAdd( aPergs ,{1 ,"Data Apont. De"   ,StoD("") ,"@D" ,".T." ,""    ,"" ,50 ,.F. })                                      
	aAdd( aPergs ,{1 ,"Data Apont. Até"  ,StoD("") ,"@D" ,".T." ,""    ,"" ,50 ,.T. })                                      
	
	aAdd( aPergs ,{3,"Tipo de Relatorio",1,{"Análitico","Sintético"},50,"",.T.,".T." })                                      

	If ParamBox(aPergs ,"Relatório de Apontamentos",@aRetPar)      
		cProcVe  := aRetPar[1]
		cOportDe := aRetPar[2]
		cOportAt := aRetPar[3]
		nStatOp  := aRetPar[4]
		cVendDe  := aRetPar[5]
		cVendAt  := aRetPar[6]
		cEstgDe  := aRetPar[7]
		cEstgAt  := aRetPar[8]
		dAponDe  := aRetPar[9]
		dAponAt  := aRetPar[10]
		nTipRel  := aRetPar[11]
	
		Processa({|| lRet := CFATRUN(cProcVe,cOportDe,cOportAt,nStatOp,cVendDe,cVendAt,cEstgDe,cEstgAt,dAponDe,dAponAt,nTipRel) },"Processando...","Aguarde...",.T.)
	Else
		lRet := .F.
	EndIf

Return( lRet )

//+-----------+----------+-------+------------------+------+-----------------+
//| Programa  | CFATRUN  | Autor | Opvs (David)     | Data |  22/02/13       |
//+-----------+----------+-------+------------------+------+-----------------+
//| Descr.    | Rotina de Processamento do relatorio para exportacao para    |
//|           | excel.                                                       |
//+-----------+--------------------------------------------------------------+
//| Uso       | Certsign                                                     |
//+-----------+--------------------------------------------------------------+
Static Function CFATRUN(cProcVe,cOportDe,cOportAt,nStatOp,cVendDe,cVendAt,cEstgDe,cEstgAt,dAponDe,dAponAt,nTipRel) 

	Local lRet 		 := .T.
	Local aCabecExc  := {}
	Local aLinhaExc	 := {}
	Local aItensExc	 := {}
	Local cQuery	 := ""
	Local cSqlSel	 := ""
	Local cSqlFro	 := ""
	Local cSqlWhe	 := ""
	Local cCODA3     := ""
	Local cNomeA3	 := ""
	Local cNroOpr	 := ""
	Local cDescri	 := ""
	Local _cOpor	 := ""
	Local cEveAnt	 := ""
	Local cVedNom	 := ""
	Local cHoraApt	 := ""
	Local cDesPPri   := ""
	Local cDeStage   := ""
	Local nQtdOp	 := 0
	Local nWhile	 := 0
	Local nVerba	 := 0
	Local nCusto	 := 0
	Local dDtAnt 	 := StoD("")
	Local _dInic	 := StoD("")
	Local _dDtFimAnt := StoD("")
	Local lImpAnt	 := .T.
	Local cAD1_Proc  := ''
	Local cAD1_Esta  := ''
	Local cCanal     := ''
	Local cCodVend   := ''

	cQuery :=""
	cQuery +=" SELECT "
	cQuery +="   AD5_NROPOR "
	cQuery +=" FROM "
	cQuery +=RetSqlName("AD5")
	cQuery +=" WHERE " 
	cQuery +="   AD5_NROPOR BETWEEN '"+cOportDe+"' AND '"+cOportAt+"' AND "
	cQuery +="   AD5_VEND BETWEEN '"+cVendDe+"' AND '"+cVendAt+"' AND "
	cQuery +="   AD5_EVENTO BETWEEN '"+cEstgDe+"' AND '"+cEstgAt+"' AND "
	cQuery +="   AD5_DATA BETWEEN '"+DtoS(dAponDe)+"' AND '"+DtoS(dAponAt)+"' AND 
	cQuery +="   D_E_L_E_T_ = ' ' "
	cQuery +=" GROUP BY "
	cQuery +="   AD5_NROPOR "
	cQuery +=" ORDER BY "
	cQuery +="   AD5_NROPOR "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPAD5",.F.,.F.)

	TMPAD5->(DbEval({|| nQtdOp++  }))

	TMPAD5->(DbGoTop())

	//AD1_FILIAL+AD1_NROPOR+AD1_REVISA                                                                                                                                
	DbSelectArea("AD1")
	DbSelectArea("AD5")
	DbSelectArea("SYP")

	AD1->(DbSetOrder(1))

	ProcRegua(nQtdOp)  

	While !TMPAD5->(EoF())
		nWhile++

		IncProc("Analisando oportunidade: "+Alltrim(Str(nWhile))+" de "+Alltrim(Str(nQtdOp)) )	 
	
		//Posiciona na Oportunidade
		AD1->(DbSeek(xFilial("AD1")+TMPAD5->AD5_NROPOR))
	 
		//Verifica se necessita validar status da oportunidade
		If	nStatOp <= 2
			If (nStatOp = 1 .and. !Empty(AD1->AD1_DTFIM)) .OR. (nStatOp = 2 .and. Empty(AD1->AD1_DTFIM))
				TMPAD5->(DbSkip())
				Loop			
			EndIf
		EndIf
	
		cCODA3  := AD1->AD1_VEND
		cNomeA3 := ALLTRIM(POSICIONE("SA3",1,XFILIAL("SA3")+AD1->AD1_VEND,"A3_NOME"))	// Vendedor
 		cNroOpr := AD1->AD1_NROPOR 														// Numero da oportunidade
   		cDescri := AD1->AD1_DESCRI														// Descrição da oportunidade
   		nVerba  := AD1->AD1_VERBA 
   	
   		cSqlSel := ""
		cSqlSel +=" SELECT "
		cSqlSel +="   R_E_C_N_O_ RECAD5 "
		cSqlFro	:= ""
		cSqlFro +=" FROM "
		cSqlFro +=RetSqlName("AD5")

		If nTipRel = 1
			cSqlWhe	:= ""
			cSqlWhe +=" WHERE " 
			cSqlWhe +="   AD5_NROPOR = '"+TMPAD5->AD5_NROPOR+"' AND "
			cSqlWhe +="   D_E_L_E_T_ = ' ' "
			cSqlWhe +=" ORDER BY "
			cSqlWhe +="   AD5_NROPOR,AD5_DATA, R_E_C_N_O_, AD5_EVENTO "
		Else
			cSqlWhe	:= ""
			cSqlWhe +=" WHERE " 
			cSqlWhe +="   AD5_NROPOR = '"+TMPAD5->AD5_NROPOR+"' AND "
			cSqlWhe +="   AD5_VEND BETWEEN '"+cVendDe+"' AND '"+cVendAt+"' AND "
			cSqlWhe +="   AD5_EVENTO BETWEEN '"+cEstgDe+"' AND '"+cEstgAt+"' AND "
			cSqlWhe +="   AD5_DATA BETWEEN '"+DtoS(dAponDe)+"' AND '"+DtoS(dAponAt)+"' AND 
			cSqlWhe +="   D_E_L_E_T_ = ' ' "
			cSqlWhe +=" ORDER BY "
			cSqlWhe +="   AD5_NROPOR,AD5_DATA, R_E_C_N_O_, AD5_EVENTO "
		EndIf  

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSqlSel+cSqlFro+cSqlWhe),"TMPOP",.F.,.F.)

		While TMPOP->(!Eof())

			DbSelectArea("AD5")
			AD5->(DbGoTo(TMPOP->RECAD5))
		
			_cOpor := AD5->AD5_NROPOR
			cMemo	:=    ' '           

			if !AD5->AD5_CODMEN==' '
		 		cMemo	:= MSMM(AD5->AD5_CODMEN,80,,,3,,,'AD5')    
			Endif

			cEveAnt	 :=	AllTrim(AD5->AD5_EVENTO)   	// estágio
			cDeStage :=	AllTrim( POSICIONE("AC5", 1, xFilial("AC5") + cEveAnt, "AC5_DESCRI")) 	// Descrição do estágio.
			dDtAnt	 :=	AD5->AD5_DATA    				// data inicial
			cVedNom	 :=	AllTrim(POSICIONE("SA3", 1, XFILIAL("SA3") + AD5->AD5_VEND, "A3_NOME")) // Vendedor que apontou
			cHoraApt :=	AllTrim(AD5->AD5_XHAPTO)		// hora do apontamento
			cCodVend := AllTrim(SA3->(GetAdvFVal('SA3', 'A3_XCANAL', xFilial('SA3') + AD1->AD1_VEND, 1)))
			cDesPPri := AllTrim(SX5->(GetAdvFVal('SX5', 'X5_DESCRI', xFilial('SX5') + "Z3" + AD1->AD1_CODPRO, 1)))
			If !Empty(AD1->AD1_CODCLI)
				cCliPro := Posicione("SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI, "A1_NOME")
			Else
				cCliPro := Posicione("SUS", 1, xFilial("SUS") + AD1->AD1_PROSPE, "US_NOME")
			EndIf

			If !Empty(cCodVend)
				cCanal := AllTrim(Posicione("SZ2", 1, xFilial("SZ2") + cCodVend, "Z2_CANAL"))
			Else
				cCanal := ""
			EndIf


			nCusto	 :=	CFATCUS(AD5->AD5_FILIAL,AD5->AD5_VEND,AD5->AD5_DATA,AD5->AD5_SEQUEN)

			lImpAnt := .T.

			_dInic		:=	AD5->AD5_DATA 
			_dDtFimAnt	:=  AD1->AD1_DTFIM

			TMPOP->(DBSKIP())
			AD5->(DbGoTo(TMPOP->RECAD5))

			// imprime data fim e duração

			IF lImpAnt
				// tratmento diferenciado para ultima linha, se mudou o vendedor então imprime data fim em branco
				IF _cOpor <> AD5->AD5_NROPOR 									
					cAD1_Proc := Posicione("AD1",1,XFILIAL("AD1")+_cOpor,"AD1_PROVEN")
					cAD1_Esta := Substr(Posicione("AD1",1,XFILIAL("AD1")+_cOpor,"AD1_STAGE"),1,3)
					IF cAD1_Proc == '000001'
						dDtFimAux 	:= IIF(cAD1_Esta=='007',_dDtFimAnt,CtoD("  /  /  "))	
					ElseIF cAD1_Proc == '000002'
						dDtFimAux 	:= IIF(cAD1_Esta=='006',_dDtFimAnt,CtoD("  /  /  "))
					Else
						dDtFimAux 	:= IIF(EMPTY(_dDtFimAnt),CtoD("  /  /  "), _dDtFimAnt)
					EndIF

					cDuracaoAux	:= iif(EMPTY(_dDtFimAnt),diasUteis(dDataBase,_dInic),diasUteis(_dDtFimAnt,_dInic))

					aadd( aLinhaExc ,cCODA3 )									//-> 1
					aadd( aLinhaExc ,cNomeA3 )									//-> 2             
					aadd( aLinhaExc ,cNroOpr )									//-> 3
					aadd( aLinhaExc ,cDescri )									//-> 4
					aadd( aLinhaExc ,cEveAnt )									//-> 5
					aadd( aLinhaExc ,cDeStage )									//-> 6
					aadd( aLinhaExc ,dDtAnt )									//-> 7
					aadd( aLinhaExc ,dDtFimAux )								//-> 8
					aadd( aLinhaExc ,cDuracaoAux )								//-> 9
					aadd( aLinhaExc ,cVedNom )									//-> 10
					aadd( aLinhaExc ,cHoraApt )									//-> 11
					aadd( aLinhaExc ,Transform(nVerba,"@ze 999,999,999.99") )	//-> 12
					aadd( aLinhaExc ,cMemo )									//-> 13
					aadd( aLinhaExc ,cCliPro )									//-> 14
					aadd( aLinhaExc ,cDesPPri )									//-> 15
					aadd( aLinhaExc ,cCanal )									//-> 16
					aadd( aLinhaExc ,AD1->AD1_DTINI )							//-> 17

	       		// as impressões normais entram neste if, ou seja, enquanto for a oporunidade corrente.
				ELSE
					dDtFimAux	:= iif(empty(AD5->AD5_DATA),dDataBase, AD5->AD5_DATA)			
					cDuracaoAux	:= iif(EMPTY(AD5->AD5_DATA),diasUteis(dDataBase,_dInic),diasUteis(AD5->AD5_DATA,_dInic))

					aadd( aLinhaExc ,cCODA3 ) 									//-> 1
					aadd( aLinhaExc ,cNomeA3 )									//-> 2             
					aadd( aLinhaExc ,cNroOpr )									//-> 3
					aadd( aLinhaExc ,cDescri )									//-> 4
					aadd( aLinhaExc ,cEveAnt )									//-> 5
					aadd( aLinhaExc ,cDeStage )									//-> 6
					aadd( aLinhaExc ,dDtAnt )									//-> 7
					aadd( aLinhaExc ,dDtFimAux )								//-> 8
					aadd( aLinhaExc ,cDuracaoAux )								//-> 9
					aadd( aLinhaExc ,cVedNom )									//-> 10
					aadd( aLinhaExc ,cHoraApt )									//-> 11
					aadd( aLinhaExc ,Transform(nVerba,"@ze 999,999,999.99") )	//-> 12
					aadd( aLinhaExc ,cMemo )									//-> 13
					aadd( aLinhaExc ,cCliPro )									//-> 14
					aadd( aLinhaExc ,cDesPPri )									//-> 15
					aadd( aLinhaExc ,cCanal )									//-> 16
					aadd( aLinhaExc ,AD1->AD1_DTINI )							//-> 17

				ENDIF				
	    	ENDIF   

			aadd(aItensExc,aLinhaExc) // adiciona a linha aos itens 
			aLinhaExc := {} //zera linha

			//TMPOP->(!Eof())

		ENDDO

		TMPOP->(DbCloseArea())

		TMPAD5->(DbSkip())
	EndDo

	TMPAD5->(DbCloseArea())

	aadd( aCabecExc ,"COD. VENDEDOR" )		//-> 1             
	aadd( aCabecExc ,"VENDEDOR" )			//-> 2             
	aadd( aCabecExc ,"COD.OPORT." )			//-> 3
	aadd( aCabecExc ,"DESC.OPORT" )			//-> 4
	aadd( aCabecExc ,"ESTAGIO" )			//-> 5
	aadd( aCabecExc ,"DESCRIÇÃO" )			//-> 6
	aadd( aCabecExc ,"DATA INI" )			//-> 7
	aadd( aCabecExc ,"DATA FIM" )			//-> 8
	aadd( aCabecExc ,"DURAÇÃO" )			//-> 9
	aadd( aCabecExc ,"RESP.APTO." )			//-> 10
	aadd( aCabecExc ,"HORA" )				//-> 11
	aadd( aCabecExc ,"VERBA OPORT" )		//-> 12	
	aadd( aCabecExc ,"OBSERVAÇÃO" )			//-> 13	
	aadd( aCabecExc ,"CLIENTE/PROSPECT" )	//-> 14	
	aadd( aCabecExc ,"PRODUTO PRINCIPAL" )	//-> 15	
	aadd( aCabecExc ,"CANAL DE VENDA" )		//-> 16
	aadd( aCabecExc ,"DT. INICIO" )			//-> 17

	processa({||DlgToExcel({ {"ARRAY","Apontamentos", aCabecExc,aItensExc} }) }, "Exp. Apontamentos","Aguarde, exportando Apontamentos para Excel...",.T.) 

Return( lRet )

//+-----------+----------+-------+------------------+------+-----------------+
//| Programa  | CFATCUS  | Autor | Certisign        | Data |  22/02/13       |
//+-----------+----------+-------+------------------+------+-----------------+
//| Descr.    | Calcula dias uteis                                           |
//+-----------+--------------------------------------------------------------+
//| Uso       | Certsign                                                     |
//+-----------+--------------------------------------------------------------+
Static Function diasUteis(dFim, dIni)

	Local nDias := 0

	If Empty(dFim) 
		Return 0
	EndIf

	While dFim >= dIni
		If DataValida(dIni) == dIni
			nDias++
		EndIf
		dIni := dIni + 1
	EndDo
	
Return nDias 

//+-----------+----------+-------+------------------+------+-----------------+
//| Programa  | CFATCUS  | Autor | Certisign        | Data |  22/02/13       |
//+-----------+----------+-------+------------------+------+-----------------+
//| Descr.    | Calcula custos da oportunidade                               |
//+-----------+--------------------------------------------------------------+
//| Uso       | Certsign                                                     |
//+-----------+--------------------------------------------------------------+
Static Function CFATCUS(cFil,cVend,dDat,cSeq)

	Local nRetCus := 0
	Local cSql    := ""

	cSql := ""
	cSql += " SELECT  "
	cSql += "   SUM(AD6_TOTAL) AD6_TOTAL  "	
	cSql += " FROM "
	cSql += RetSqlName("AD6")
	cSql += " WHERE "
	cSql += "   AD6_FILIAL = '"+cFil+"' AND "
	cSql += "   AD6_VEND = '"+cVend+"' AND " 	 	
	cSql += "   AD6_DATA = '"+DtoS(dDat)+"' AND "
	cSql += "   AD6_SEQUEN = '"+cSeq+"' AND "
	cSql += "   D_E_L_E_T_ = ' ' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPAD6",.F.,.F.)

	If !TMPAD6->(EoF())
		nRetCus := TMPAD6->AD6_TOTAL 
	EndIf

	TMPAD6->(DbCloseArea())

Return( nRetCus )