/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RESTA002 ³ Autor ³ Rogerio Leite         ³ Data ³ 25.08.06   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera numero sequencial dos lotes na entrada                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void D3_COD / D3_OP / H6_PRODUTO / H6_OP                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³XX/XX/XX³XXXXXX³                                          ³±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTA002(cProdEst)
Local cInicial,cAliasSB8,nTamLetra,cNovoLote,nSeqLote
Local aAreaLoc := GetArea(),aAreaSB1,aAreaSB8,cFilSB8 := xFilial("SB8")
*  
*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Formato do Lote:  H ou C ou B + AA (Ano) + 999999 (Sequencial de 6 posicoes).  Ex: H06-000002 / C06-000103³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*
dbSelectArea("SB1")
aAreaSB1 := GetArea()
dbSetOrder(1)
MsSeek(xFilial("SB1")+cProdEst)
If SB1->B1_RASTRO $ "LS"
   //cInicial := AllTrim(SB1->B1_FRMLOTE)
	cInicial := If(cFilSB8 == '01' , 'H',If(cFilSB8 == '50','C','B'))
	nTamLetra := Len(cInicial)
	*
	dbSelectArea("SB8")
	aAreaSB8 := GetArea()
   dbOrderNickName("SB8LOTE01")  && SIX - NickName = SB8LOTE01 - Indice - B8_FILIAL + B8_LOTECTL
	**
	cAliasSB8 := CriaTrab(Nil,.F.)
	cQuery := "SELECT SB8.B8_FILIAL,SB8.B8_LOTECTL "
	*
	cQuery += "FROM "+RetSqlName("SB8")+" SB8 WHERE "
	cQuery += "SB8.B8_FILIAL = '"+xFilial("SB8")+"' "
	*
	cQuery += "AND SB8.D_E_L_E_T_<> '*' "
	cQuery += "AND SUBSTRING(SB8.B8_LOTECTL,1,"+StrZero(nTamLetra,1)+") = '"+cInicial +"' "
	cQuery += "ORDER BY B8_LOTECTL DESC "
	*
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB8,.T.,.T.)
	If Eof()
	   nSeqLote := 1
	Else     
	   nPosLot := AT("-",(cAliasSB8)->B8_LOTECTL)
   	nSeqLote  := Val(Subs((cAliasSB8)->B8_LOTECTL,nPosLot+1,6)) + 1
   Endif
	While .T.
		*
		cNovoLote := cInicial+Subs(StrZero(Year(dDataBase),4),3,2)+"-"+StrZero(nSeqLote,6)
		*
		dbSelectArea("SB8")
		MsSeek(xFilial("SB8")+cNovoLote)                                               
		If !Eof()
			nSeqLote++
		Else
			Exit
		Endif
	End
	*
   dbSelectArea(cAliasSB8)
   dbCloseArea(cAliasSB8)   
	*	
	dbSelectArea("SB8") 
	RestArea(aAreaSB8)
   *
Endif         
*
dbSelectArea("SB1")
RestArea(aAreaSB1)
*   
RestArea(aAreaLoc)
*
Return (cNovoLote)
