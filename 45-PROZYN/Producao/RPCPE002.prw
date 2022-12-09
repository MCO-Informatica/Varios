#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'DBTREE.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RPCPE002 ³ Autor ³ Adriano Leonardo    ³ Data ³ 15/07/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsável por demonstrar o mapa da estrutura com  º±±
±±º          ³ os custos de produção.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCPE002(nQtdBase, oTree)

Local aAreaAnt		:= GetArea()
Local aAreaSG1		:= SG1->(GetArea())
Local aAreaSB1		:= SB1->(GetArea())
Local aAreaSB2		:= SB2->(GetArea())
Local aAreaSM2		:= SM2->(GetArea())
Local aAreaTRE		:= {}
Local cMapaFile		:= ''
Local nMapaHdl		:= 0
Local nQuant		:= 0
Local nSeq			:= 0
Local cText			:= ''
Local nRecno		:= 0
Local nQuantSG1		:= 0
Local cProdPai		:= ""
Local aTamSX3		:= TamSX3("G1_QUANT")
Local nX			:= 1
Local nY			:= 1
Local nPos			:= 0
Local _aCstAux		:= {}
Local _nCstMed		:= 0
Private _nCstTot	:= 0
Private _nCstProR 	:= 0
Private _nCstProD 	:= 0
Private _cSubTit	:= "Componentes   Descrição                                                     Quantidade   UM   Tipo             Atividade                 Custo Médio    % Custo do Prod."
Private _cRotina	:= "RPCPE002"
Private nQtdComp	:= 0

cMapaFile := 'MAPA.DIV'
If File(cMapaFile)
	fErase(cMapaFile)
EndIf
nMapaHdl := MSFCREATE(cMapaFile, 0)

//Faço a primeira varredura na estrutura do produto, para compor o custo total do produto acabado
dbSelectArea(oTree:cArqTree)
aAreaTRE := GetArea()
dbSetOrder(1)
dbGoTop()
Do While !Eof()
	nRecno := Val(SubStr(T_CARGO,Len(SG1->G1_COD + SG1->G1_TRT + SG1->G1_COMP) + 1, 9))
	
	If nRecno > 0
		SG1->(dbGoto(nRecno))
		
		If Empty(cProdPai)
			cProdPai    := SG1->G1_COD
		EndIf
		
		If  dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM .And. SG1->G1_COD == cProdPai
			dbSelectArea("SB1")
			dbSetOrder(1)
			If SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
					_nCstTot += Round((SB2->B2_CM1 * SG1->G1_QUANT)/nQtdBasePai,TamSx3("B2_CM1")[02])
				EndIf
			Else
				MsgAlert("Produto" + SG1->G1_COMP + " não encontrado!",_cRotina+"_002")
			EndIf
		EndIf
	EndIf
	dbSelectArea(oTree:cArqTree)
	dbSkip()
End

cProdPai	:= ""
nQtdAux		:= 1

dbSelectArea(oTree:cArqTree)
aAreaTRE := GetArea()
dbSetOrder(1)
dbGoTop()
nSeq := 1
Do While !Eof()
	
	nRecno := Val(SubStr(T_CARGO,Len(SG1->G1_COD + SG1->G1_TRT + SG1->G1_COMP) + 1, 9))
	
	If nRecno > 0
		SG1->(dbGoto(nRecno))
		
		If Empty(cProdPai)
			cProdPai    := SG1->G1_COD
		EndIf
	EndIf
	
	_cTipo := ""
	
	If SG1->G1_TIPO=='1'
		_cTipo := "Diluente"
	ElseIf SG1->G1_TIPO=='2'
		_cTipo := "Enzima"
	ElseIf SG1->G1_TIPO=='3'
		_cTipo := "Embalagem"
	ElseIf SG1->G1_TIPO=='4'
		_cTipo := "Ingrediente"
	EndIf
	
	_cTipo := PadR(_cTipo,11)
	
	If nSeq == 1
		fSeek(nMapaHdl,0,2)
		cText := '  Produto                Qtd. Basica' +CHR(13) +CHR(10)
		fWrite(nMapaHdl,cText,Len(cText))
		fSeek(nMapaHdl,0,2)
		nQtdBasePai := nQtdBase += CriaVar('B1_QB')
		cProdPai    := SG1->G1_COD
		cText := Space(2) +cProdPai + Space(19-Len(Str(nQtdBase,aTamSX3[1],aTamSX3[2]))) +Str(nQtdBase,aTamSX3[1],aTamSX3[2]) +CHR(13) +CHR(10)
		fWrite(nMapaHdl,cText,Len(cText))
		fSeek(nMapaHdl,0,2)
		cText := + CHR(13) + CHR(10) +_cSubTit + CHR(13) + CHR(10)
		fWrite(nMapaHdl,Replicate('=',Len(_cSubTit)),Len(_cSubTit))
		fWrite(nMapaHdl,cText,Len(cText))
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
				_nCstProR := SB2->B2_CM1
				_nCstProD := SB2->B2_CM3
			Else
				_nCstProR := 0
			EndIf
		Else
			MsgAlert("Produto" + SG1->G1_COD + " não encontrado!",_cRotina+"_001")
		EndIf
		
		dbSelectArea(oTree:cArqTree)
	Else
		
		If  dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM
			
			nQuant := SG1->G1_QUANT
			fSeek(nMapaHdl,0,2)
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			If SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))			
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
					_nCstMed := Round((SB2->B2_CM1 * SG1->G1_QUANT)/nQtdBasePai,TamSx3("B2_CM1")[02])
				Else
					_nCstMed := 0
				EndIf
			Else
				MsgAlert("Produto" + SG1->G1_COMP + " não encontrado!",_cRotina+"_002")
			EndIf
			
			dbSelectArea(oTree:cArqTree)
			
			If SG1->G1_COD == cProdPai
				If nSeq > 2 .And. nQtdComp > 0
					//cText := CHR(13) +CHR(10) + Replicate("-",Len(_cSubTit)) +CHR(13) +CHR(10) + '  Total' +Space(31) +Str(nQtdComp,aTamSX3[1],aTamSX3[2]) +CHR(13) +CHR(10)
					//fWrite(nMapaHdl,cText,Len(cText))
				ElseIf nSeq == 2
					fWrite(nMapaHdl,Replicate('=',Len(_cSubTit)) +CHR(13) +CHR(10),Len(_cSubTit))
				EndIf
				cText := +CHR(13) +CHR(10) + Space(3) + AllTrim(SG1->G1_COMP) +Space(5) + SB1->B1_DESC + Str(nQuant,aTamSX3[1],aTamSX3[2]) +Space(3) + SB1->B1_UM +Space(3) + _cTipo + Space(1) + Transform(SG1->G1_ATIVIDA,PesqPict("SG1","G1_ATIVIDA")) + Space(1) + SG1->G1_UNATIV + Space(1) + Transform(_nCstMed,PesqPict("SB2","B2_CM1")) + Space(12) + Transform((_nCstMed*100)/_nCstTot,PesqPict("SG1","G1_PERCDIL")) + "%"
				If SG1->G1_TIPO <> '3'//Não considero a quantidade de embalagem
					nQtdComp += nQuant
				EndIf
				nQtdAux := SG1->G1_QUANT
			Else
				cText := +CHR(13) +CHR(10) + Space(5) + AllTrim(SG1->G1_COMP) +Space(3) + SB1->B1_DESC + Str(nQuant*nQtdAux,aTamSX3[1],aTamSX3[2]) +Space(3) + SB1->B1_UM +Space(3) //+ _cTipo + Space(3) + Space(Len(Transform(SG1->G1_ATIVIDA,PesqPict("SG1","G1_ATIVIDA")))) + Space(1) + Space(Len(SG1->G1_UNATIV)) + Space(3) + Transform(_nCstMed,PesqPict("SB2","B2_CM1")) + Space(12) + Transform((_nCstMed*100)/_nCstProR,PesqPict("SG1","G1_PERCDIL")) + "%"
			EndIf
			fWrite(nMapaHdl,cText,Len(cText))
		Endif
	EndIf
	nSeq++
	dbSkip()
End

RestArea(aAreaTRE)
RestArea(aAreaSB1)
RestArea(aAreaSB2)
RestArea(aAreaSM2)
RestArea(aAreaSG1)
RestArea(aAreaAnt)
FClose(nMapaHdl)

aExplode := {}
Explode(cProduto, @aExplode, cRevisao, @nCount, oTree)

aPai := {}
For nX := 1 to Len(aExplode)
	If (nPos := aScan(aPai, {|x| x[2] == aExplode[nX, 2]})) == 0
		aAdd(aPai, {1, aExplode[nX, 2]})
	ElseIf nPos > 0
		aPai[nPos, 1]++
	EndIf
Next nX

cCodPai   := cProduto
nQtdNivel := CriaVar('B1_QB')
For nX:=1 to Len(aPai)
	nQuant1 := CriaVar('B1_QB')
	If aPai[nX, 2] # cCodPai
		nPos   := aScan(aExplode,{|x| x[3] == aPai[nX, 2]})
		nQuant := If(nPos>0,aExplode[nPos, 4],0)
		For nY := 1 to Len(aExplode)
			If aExplode[nY, 2] == aPai[nX, 2]
				nQuant1 += aExplode[nY, 4]
			EndIf
		Next nY
		If nQuant1 # nQuant
			lMap := .T.
		EndIf
	Else
		For nY := 1 to Len(aExplode)
			If aExplode[nY, 2] == cCodPai
				nQuant1 += aExplode[nY, 4]
			EndIf
		Next nY
		If nQuant1 # nQtdBase
			lMap := .T.
			nQtdNivel += nQuant1
			Exit
		Else
			nQtdNivel += nQuant1
		EndIf
	EndIf
Next nX
		
A200ShowMap(nQtdNivel)

Return()

STATIC Function A200ShowMap(nQtdNivel)

Local oGet
Local oDlg
Local oFontLoc
Local aAreaAnt   := GetArea()
Local aAreaSX2   := {}
Local cMapaFile  := ''
Local cString    := ''
Local cText      := ''
Local nNumLinhas := 0
Local cAlias     := Alias()
Local lRet       := .F.
Local aString    := {}
Local aTamSX3	 := TamSX3("G1_QUANT")

cMapaFile := 'MAPA.DIV'
If !File(cMapaFile)
	cString    := '  Nenhuma Divergencia...'
	nNumLinhas := 1
Else
	nMapaHdl := FOpen(cMapaFile,2+64)
	FSeek(nMapaHdl,0,2)
	cText := CHR(13)+CHR(10) + '  Total      :   ' + Transform(nQtdComp,PesqPict("SB2","B2_QATU")) + " Kg"
	cText += CHR(13)+CHR(10) + Replicate("_",Len(_cSubTit))
	cText += CHR(13)+CHR(10) + '  Custo Total: R$' + Transform(_nCstTot,PesqPict("SB2","B2_QATU")) //Custo médio em real
	
	dbSelectArea("SM2")
	dbSetOrder(1) //Data
	If dbSeek(dDataBase)		
		If SM2->M2_MOEDA2 > 0
			cText += CHR(13)+CHR(10) + '  Custo Total: $ ' + Transform(_nCstTot*SM2->M2_MOEDA2,PesqPict("SB2","B2_QATU")) //Custo médio em dólar
		EndIf
	EndIf
	FWrite(nMapaHdl,+CHR(13)+CHR(10),Len(_cSubTit))
	FWrite(nMapaHdl,Replicate("=",Len(_cSubTit)),Len(_cSubTit))
	FWrite(nMapaHdl,cText,Len(cText))
	FClose(nMapaHdl)
	cString := MEMOREAD(cMapaFile)
EndIf

oFontLoc := TFont():New('Consolas',6,15)
DEFINE MSDIALOG oDlg TITLE OemToAnsi('Resumo') FROM 15,30 To 38,165
DEFINE SBUTTON FROM 156,470 TYPE 1  ENABLE OF oDlg ACTION (lRet := .T.,oDlg:End())
DEFINE SBUTTON FROM 156,500 TYPE 2  ENABLE OF oDlg ACTION (lRet := .F.,oDlg:End())
@ 0.5,0.7  GET oGet VAR cString OF oDlg MEMO size 525,145 READONLY COLOR CLR_BLACK,CLR_HGRAY
oGet:oFont     := oFontLoc
oGet:bRClicked := {||AllwaysTrue()}
ACTIVATE MSDIALOG oDlg Centered
oFontLoc:End()

RestArea(aAreaAnt)
Return (lRet)

Static Function Explode(cProduto, aExplode, cRevisao, nCount, oTree)

Local aAreaAnt   := GetArea()
Local aAreaSG1   := SG1->(GetArea())
Local aAreaTRE   := {}
Local cCod       := cProduto
Local cSeq       := ''
Local cComp      := ''
Local nRecno     := 0
Local cFilSG1    := xFilial('SG1')

nCount++
SG1->(dbSetOrder(1))

dbSelectArea(oTree:cArqTree)
aAreaTRE := GetArea()
dbSetOrder(1)
dbGoTop()
(aAreaTRE[1])->(dbSkip())// ignora o primeiro recno do arquivo temporario pois esta relacionado ao PA. 
Do While !Eof()
	cCod   := Left(T_CARGO, Len(SG1->G1_COD))
	cSeq   := SubStr(T_CARGO, Len(SG1->G1_COD) + 1, Len(SG1->G1_TRT))
	cComp  := SubStr(T_CARGO, Len(SG1->G1_COD + SG1->G1_TRT) + 1, Len(SG1->G1_COMP))
	nRecno := Val(SubStr(T_CARGO,Len(SG1->G1_COD + SG1->G1_TRT + SG1->G1_COMP) + 1, 9))

    If !SG1->(DbSeek(cFilSG1+cCod+cComp+cSeq))
		(aAreaTRE[1])->(dbSkip())
		Loop
    EndIf
	If cCod # cProduto
		dbSkip()
		Loop
	EndIf

	If nRecno > 0
		SG1->(dbGoto(nRecno))
	Else
		Exit
	EndIf
	If cCod # cComp .And. SG1->G1_REVINI <= cRevisao .And. SG1->G1_REVFIM >= cRevisao
		nPos := aScan(aExplode,{|x| x[1] == nCount .And. x[2] == cCod .And. x[3] == cComp .And. x[5] == cSeq})
		If nPos == 0 .And. dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM
			aAdd(aExplode,{nCount, cCod, cComp, SG1->G1_QUANT, cSeq, SG1->G1_REVINI, SG1->G1_REVFIM})
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe sub-estrutura                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRecno := SG1->(Recno())
		If SG1->(dbSeek(cFilSG1+cComp, .F.))
			Explode( SG1->G1_COD, @aExplode, cRevisao, @nCount, oTree)
			nCount --
		Else
			SG1->(dbGoto(nRecno))
			nPos := aScan(aExplode,{|x| x[1] == nCount .And. x[2] == cCod .And. x[3] == cComp .And. x[5] == cSeq})
			If nPos == 0 .And. dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM
				aAdd(aExplode,{nCount, cCod, cComp, SG1->G1_QUANT, cSeq, SG1->G1_REVINI, SG1->G1_REVFIM})
			EndIf
		Endif
	EndIf
	(aAreaTRE[1])->(dbSkip())
Enddo

RestArea(aAreaTRE)
RestArea(aAreaSG1)
RestArea(aAreaAnt)

Return Nil