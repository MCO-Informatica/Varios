/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Rdmake	 ³ EtiqMin  ³Autor  ³ Rafael Souza          ³ Data ³ 13.04.10  ±±
±±º			 ³          ³Modif  ³ Rafael Souza          ³ Data ³ 13/04/10  ±±
±±º			 ³          ³Modif  ³ Rafael Souza          ³ Data ³ 13/04/10  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Descri‡…o ³ Rotina de impressao de etiquetas Informativa da Minexco.    ±±
±±³          ³                                               			   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºUso       ³ Minexco Com. Imp. Exp. Ltda.                                ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±ºConf.Impr.³ ELTRON LP2142. (Configurar esse drive de impressao sempre)  ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION EtiqMin()

Local cCmd, bExecok	:= .F.
Local cDescricao
Local cCodbar		:= ""
Local lRet			:= .T.
Local dDate			:= DTOC(Date())
Local dTime			:= Substr(Time(),1,5)
Local cUser			:= "000000"
Local lSubLote      := .T.

cPerg      := "ETIMIN"  // Nome da Pergunte
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF !Pergunte(cPerg,.T.)               // Pergunta no SX1
	lRet:= .F.
Endif

If lRet
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	dbSelectArea("SB8")
	cIndexSB8  := CriaTrab(nil,.f.)
	
	cFiltro := 'B8_FILIAL == "' + xFilial("SB8") + '" .AND. '
	cFiltro	+= 'SB8->B8_QTDORI > 0'
	
	IndRegua("SB8",cIndexSB8,"B8_FILIAL+B8_PRODUTO+B8_LOTECTL",,cFiltro,"Selecionando Registros...")
	nIndex	:= RetIndex("SB8")
	dbSetOrder(nIndex+1)
	SB8->(dbGotop())
	
	//MSCBPRINTER("ELTRON","LPT1",,34.4,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
	MSCBPRINTER("OS 214","LPT1",,,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
	MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
	//MSCBLOADGRF("\system\LOGMIN.BMP")
	ProcRegua(SB8->(RecCount()))
	
	While  ! SB8->(eof())
		//Se nao tiver saldo em estoque nao imprime a etiqueta
		//If SB8->B8_QTDORI > 0 //caso coloque 0 no parametro quantidade nao devera ser impresso nada. Estava imprimindo 1
		If SB8->B8_QTDORI > 0 .and. val(mv_par01) > 0 .And. lSubLote == .T.
			lSubLote:= .F.
			bExecOk:= .T.
			IncProc("Imprimindo Etiqueta...")
			MSCBBEGIN(val(mv_par01),1) //Inicio da Imagem da Etiqueta
			MSCBBOX(05,01,100,35)  //Monta BOX
			MSCBSAY(42,03,'DISTRIBUIDOR',"N","2","1,2")
			MSCBSAY(13,10,'Minexco Comercio Importacao e Exportacao Ltda',"N","2","1,2")
			MSCBSAY(13,17,'Rua Maria Garcia Utrilla, 94 - Jardim Cumbica',"N","2","1,2")
			MSCBSAY(13,24,'CEP: 07230-640  Guarulhos - SP - Fone/Fax: 11 2412-4422',"N","2","1,2")
			MSCBSAY(13,30,'www.minexco.com.br  -  minexco@terra.com.br',"N","2","1,2")
			MSCBEND() //Fim da Imagem da Etiqueta
		EndIf
		SB8->(DbSkip())
		
	End
	
	dbSelectArea("SB8")
	RetIndex("SB8")
	Ferase(cIndexSB8+OrdBagExt())
	
	If !bExecOk
		msgalert("Nenhum registro encontrado com os parametros selecionados, ou nao existe saldo em estoque, ou o parametro quantidade esta informado 0 (zero).")
	Else
		MSCBCLOSEPRINTER()
	EndIf
Else
	msgalert("Voce Cancelou a Operação.")
EndIf

RETURN
