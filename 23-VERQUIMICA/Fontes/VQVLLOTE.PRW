/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ? CriaLote ? Autor ? Ary Medeiros          ? Data ? 02.07.93 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Cria lote para um produto                                  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? ExpC1 = Alias de origem (de onde a funcao e' chamada)      潮?
北?          ? ExpC2 = Produto                                            潮?
北?          ? ExpC3 = Local                                              潮?
北?          ? ExpC4 = Lote                                               潮?
北?          ? ExpC5 = SubLote                                            潮?
北?          ? ExpC6 = Lote do Fornecedor                                 潮?
北?          ? ExpC7 = Cliente                                            潮?
北?          ? ExpC8 = Loja                                               潮?
北?          ? ExpC9 = Tipo do Movimento                                  潮?
北?          ? ExpC10= Origem do Lancamento                               潮?
北?          ? ExpC11= Chave do SB8                                       潮?
北?          ? ExpC12= Numero Sequencial                                  潮?
北?          ? ExpC13= Documento                                          潮?
北?          ? ExpC14= Serie do Documento                                 潮?
北?          ? ExpC15= Ordem de Producao                                  潮?
北?          ? ExpN1 = Quantidade                                         潮?
北?          ? ExpN2 = Quantidade 2a. UM                                  潮?
北?          ? ExpD1 = Data de Criacao do Lote                            潮?
北?          ? ExpD2 = Data de Validade do Lote                           潮?
北?          ? ExpL1 = Indica se cria lote para implantacao de saldos     潮?
北?          ? ExpN3 = Potencia do Lote a ser criado                      潮?
北?          ? ExpC16= Lote produzido                                     潮?
北?          ? ExpC17= Sub-Lote produzido                                 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico                                                   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪幢?
北砇evisao   ? Rodrigo de A. Sartorio                   ? Data  ? 23/02/99潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
User Function LMVLLOTE()
Local _nret := .T.
   
DbSelectArea("SB8")
DbSetOrder(3) // Produto + +Local + Lotectl + NumLote

If !DbSeek(xFilial("SB8")+M->B7_COD+M->B7_LOCAL+M->B7_LOTECTL)
	IF MsgYesNo("Lote nao Existe para este Produto !!"+Chr(13)+"Deseja Cadastrar o Lote "+M->B7_LOTECTL+" ? ")
	   U_LMCriaLote("SB7",M->B7_COD,M->B7_LOCAL,M->B7_LOTECTL,M->B7_DTVALID)
	Else
		_nret := .F.	
    EndIf
EndIf

Return(_nret)
//User Function LMCriaLote(cAlias,cProduto,cLocal,cLoteCtl,cNumLote,cLoteFor,cCliFor,cLoja,cTm,cOrigLan,cChave,cNumSeq,cDoc,cSerie,cOp,nQuant,nQuant2UM,dData,dDtValid,lCrialote,nPotencia,cLotePrd,cSubLotePrd)
User Function LMCriaLote(cAlias,cProduto,cLocal,cLoteCtl,dDtValid,cNumLote,cLoteFor,cCliFor,cLoja,cTm,cOrigLan,cChave,cNumSeq,cDoc,cSerie,cOp,nQuant,nQuant2UM,dData,lCrialote,nPotencia,cLotePrd,cSubLotePrd)
Static lFiCrialo:= Nil
Local nRegOrig	:= 0
Local nRegSeek	:= 0
Local aArea		:= GetArea()
Local aAreaSB1	:= {}
Local cLotePrd   := ""
Local cSubLotePrd:= ""

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Preenche parametros nao recebidos pela funcao         ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
dData     := IF(dData == NIL .Or. !(ValType(dData) == "D") .Or. Empty(dData),dDataBase,dData)
cChave    := IF(cChave == NIL,"",cChave)
cLoteFor  := IF(cLoteFor == NIL,"",cLoteFor)
nQuant2UM := If(nQuant2UM == NIL, ConvUM(cProduto, nQuant, 0, 2),ConvUM(cProduto, nQuant, nQuant2UM,2))
lCriaLote := If(ValType(lCriaLote) # "L",.F.,lCrialote)
nPotencia := If(nPotencia == NIL, 0,nPotencia)

dbSelectArea("SB1")
aAreaSB1:=GetArea()
dbSetOrder(1)
dbSeek(xFilial("SB1")+cProduto)
// Descobre a data de validade                    

If Empty(dDtValid)
	dDtValid := M->B7_DTVALID
EndIf

If !(ValType(dDtValid) == "D") .Or. Empty(dDtValid)
	If SB1->B1_FILIAL+SB1->B1_COD == xFilial("SB1")+cProduto
		dDtValid:=ctod("31/12/20")//dData+SB1->B1_PRVALID
	Else
		dDtValid:=dData
	EndIf
EndIf

// Descobre a POTENCIA do lote
If nPotencia == 0 .And. (SB1->B1_FILIAL+SB1->B1_COD == xFilial("SB1")+cProduto)
	nPotencia:=SB1->B1_POTENCI
EndIf
RestArea(aAreaSB1)

// Descobre o sub-lote
cNumLote := If(cNumLote == Nil,NextLote(cProduto,"S"),IF(Empty(cNumLote),NextLote(cProduto,"S"),cNumLote))
// Descobre o lote
cLoteCtl := If(Empty(cLoteCtl),NextLote(cProduto,"L",cNumLote),cLoteCtl)
cLoteCtl := If(Empty(cLoteCtl),"AUTO"+cNumLote,cLoteCtl)

dbSelectArea("SB8")
RecLock("SB8",.T.)
Replace	B8_FILIAL  with xFilial("SB8"),;
	B8_NUMLOTE with cNumLote,;
	B8_PRODUTO with cProduto,;
	B8_LOCAL   with cLocal,;
	B8_DATA    with dData,;
	B8_DTVALID with dDtValid,;
	B8_SALDO   with nQuant,;
	B8_SALDO2  with nQuant2UM,;
	B8_ORIGLAN with cOrigLan,;
	B8_LOTEFOR with cLoteFor,;
	B8_DOC     with cDoc,;
	B8_SERIE   with cSerie,;
	B8_CLIFOR  with cCliFor,;
	B8_LOJA    with cLoja,;
	B8_PRODUTO with cProduto,;
	B8_QTDORI  with nQuant,;
	B8_QTDORI2 with nQuant2UM,;
	B8_LOTECTL with cLoteCtl,;
	B8_POTENCI with nPotencia
If cAlias=='SD1' .And. (cPaisLoc <> "BRA")
	If (FieldPos("B8_ORIGEM") * (cAlias)->(FieldPos("D1_ORIGEM"))* (cAlias)->(FieldPos("D1_NUMDESP"))) > 0
		Replace B8_NUMDESP With (cAlias)->D1_NUMDESP
		Replace B8_ORIGEM  With (cAlias)->D1_ORIGEM
	EndIf	
	If FieldPos("B8_ITEM") > 0
		Replace B8_ITEM	With (cAlias)->D1_ITEM
	EndIf
EndIf	
MsUnlock()

// Verifica se a data de validade pode ser utilizada
nRegOrig:=Recno()
If dbSeek(xFilial("SB8")+cProduto+cLocal+cLoteCtl+IF(Rastro(cProduto,"S"),cNumLote,""))
	nRegSeek	:= Recno()
	If	dDtValid # SB8->B8_DTVALID
		HelpAutoma(" ",1,"A240DTVALI")
		dDtValid:=SB8->B8_DTVALID
		// Grava no registro o Lote e a Data de Validade
		dbGoto(nRegOrig)
		RecLock("SB8",.F.)
		Replace	B8_DTVALID with dDtValid
		MsUnlock()
	EndIf
	dbGoto(nRegSeek) //-- Retorna ao registro encontrado no dbSeek
	If nPotencia # SB8->B8_POTENCI
		Help(" ",1,"POTENCORI")
		nPotencia:=SB8->B8_POTENCI
		// Grava no registro o Lote e a POTENCIA
		dbGoto(nRegOrig)
		RecLock("SB8",.F.)
		Replace	B8_POTENCI with nPotencia
		MsUnlock()
	EndIf
EndIf
dbGoto(nRegOrig)

If (cAlias != "SD5" .And. !lCrialote)
	GravaSD5(cAlias,cProduto,cLocal,cLoteCtl,cNumLote,cNumSeq,cDoc,cSerie,cOp,cTm,cCliFor,cLoja,cLoteFor,nQuant,nQuant2UM,dData,dDtValid,nPotencia,cLotePrd,cSubLotePrd)
EndIf
If aArea[1] # "SB8"
	RestArea(aArea)
EndIf
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Ponto de entrada no final da CriaLote ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

Return NIL