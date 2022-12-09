/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Rdmake	 ³ EtiqProd ³Autor  ³ Magh Moura            ³ Data ³ 16.05.06  ±±    
±±º			 ³          ³Modif  ³ Magh Moura            ³ Data ³ 25/09/06  ±±
±±º			 ³          ³Modif  ³ SUPORTE               ³ Data ³ 21/02/07  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Descri‡…o ³ Rotina de impressao de etiquetas codigo de Barras	       ±±
±±³          ³ do cadastro de produtos x Lote.                 			   ±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºUso       ³ Minexco Com. Imp. Exp. Ltda.                                ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±ºConf.Impr.³ ELTRON LP2142. (Configurar esse drive de impressao sempre)  ±±        
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION tEtiqProd()
                         
Local cCmd, bExecok	:= .F. 
Local cDescricao 
Local cCodbar		:= ""
Local lRet			:= .T.          
Local dDate			:= DTOC(Date())
Local dTime			:= Substr(Time(),1,5)
Local cUser			:= "000000"
Local lSubLote      := .T.
                                          
cPerg      := "ETIPRO"  // Nome da Pergunte
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF !Pergunte(cPerg,.T.)               // Pergunta no SX1
   lRet:= .F.
Endif	

If lRet

	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial()+MV_PAR01,.T.)
	    cDescricao:= AllTrim(SB1->B1_DESC)
   		cCodBar   := AllTrim(SB1->B1_CODBAR)
	EndIf

	dbSelectArea("SB8")  
	cIndexSB8  := CriaTrab(nil,.f.)   

	cFiltro := 'B8_FILIAL == "' + xFilial("SB8") + '" .AND. '	
	cFiltro	+= 'ALLTRIM(B8_PRODUTO) == "' + ALLTRIM(MV_PAR01) + '" .AND. '
	cFiltro	+= 'ALLTRIM(B8_LOTECTL) >= "' + ALLTRIM(MV_PAR02) + '" .AND. '    
	cFiltro	+= 'ALLTRIM(B8_LOTECTL) <= "' + ALLTRIM(MV_PAR03) + '" .AND. '
	cFiltro	+= 'SB8->B8_QTDORI > 0' 

	IndRegua("SB8",cIndexSB8,"B8_FILIAL+B8_PRODUTO+B8_LOTECTL",,cFiltro,"Selecionando Registros...")
	nIndex	:= RetIndex("SB8")                                 
	dbSetIndex(cIndexSB8+OrdBagExt())
	dbSetOrder(nIndex+1)
    SB8->(dbGotop())
    
//    MSCBPRINTER("ELTRON","LPT1",,31.2,.f.,) 
    MSCBPRINTER("ELTRON","LPT1",,100,.f.,) 
	MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
    //MSCBLOADGRF("\system\LOGMIN.BMP")
	ProcRegua(SB8->(RecCount()))

	While  ! SB8->(eof())      
	   //Se nao tiver saldo em estoque nao imprime a etiqueta
	   //If SB8->B8_QTDORI > 0 //caso coloque 0 no parametro quantidade nao devera ser impresso nada. Estava imprimindo 1
	   If SB8->B8_QTDORI > 0 .and. val(mv_par04) > 0 .And. lSubLote == .T.  
	   		lSubLote:= .F.
	   		bExecOk:= .T.
	    	IncProc("Imprimindo Etiqueta...")
			MSCBBEGIN(val(mv_par04),4) //Inicio da Imagem da Etiqueta 
 	    	MSCBBOX(05,01,110,33)  //Monta BOX  
 	   	    //MSCBSAY(12,03,'Minexco Com. Imp. Exp. Ltda',"N","2","1,2") 
 	    	MSCBSAY(29,03,'Minexco Com. Imp. Exp. Ltda',"N","2","1,2") 
	 	    //MSCBLineV(60,02,7) 
	        //MSCBGRAFIC(65,02,"LOGMIN")                   
 	    	MSCBLineH(05,08,95,2)
        	MSCBSAY(23,10,cDescricao,"N","2","1,2")      
        	MSCBSAYBAR(26,16,cCodBar+SB8->B8_LOTECTL,'N','MB07',07,.f.,.t.,,,2,2)
        	MSCBSAY(25,29,"Cod.: "+ALLTRIM(SB8->B8_PRODUTO)+" / Lote: "+SB8->B8_LOTECTL,"N","2","1,1")
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Log de Impressão de Etiquetas                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If PswSeek(cUserName)
  		cUser:= ALLTRIM(PswRet(1)[1][1])     //Não esta capturando o usuário
	EndIf

	DbSelectArea("SZ3")
	DbSetOrder(1)
	RecLock("SZ3",.T.)
		SZ3->Z3_DATA := CTOD(dDate)
		SZ3->Z3_HORA := dTime
		SZ3->Z3_USER := cUser
		SZ3->Z3_COD  := MV_PAR01	
		SZ3->Z3_COILT:= MV_PAR02	
		SZ3->Z3_COFLT:= MV_PAR03	
		SZ3->Z3_QTDPL:= Val(MV_PAR04)	
	MsUnlock()
Else
   msgalert("Voce Cancelou a Operação.")
EndIf
      
RETURN	 	 
