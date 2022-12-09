#include 'Protheus.ch'
#INCLUDE 'MATA175.CH'
#INCLUDE 'FILEIO.CH'

#DEFINE MAXGETDAD  999
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A175Tipo  ³ Autor ³ Bruno Daniel Abrigo   ³ Data ³ 26.04.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica o tipo digitado e critica os movimentos            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Mata175                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function D7TipoV()
Local nPosLDest  := 0
Local nPosDesMot := 0
Local nPosTipo   := 0
Local nTipoAnt   := 2
Local nTipo      := &(ReadVar())
Local lRet       := .T.
Local cLocCQ     := Iif(Empty(GetMV('MV_CQ')),SB1->B1_LOCPAD,GetMV('MV_CQ'))
Local cMETLoc	 :=SuperGetMv("MV_METLOC" , .F. , "EX") // Utilizado para retornar o estoque padrao Metalacre - Bruno Abrigo em 26/04/2012
Local nPosSeq	 :=0// Bruno Abrigo em 26/04/2012
Local cLocPad    := IIF(SD7->D7_ORIGLAN=="PR",SB1->B1_LOCPAD,If(cLocCQ == SD7->D7_LOCDEST,SB1->B1_LOCPAD,SD7->D7_LOCDEST))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MV_A175VLD - Parametro utilizado para verificar se o usuario  |
//|              podera realizar a alteração da data de validade  |
//|              do lote atraves da rotina de Baixas do CQ.       |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lA175Vld   :=	SuperGetMv("MV_A175VLD",.F.,.F.)	.And.;
Rastro(SD7->D7_PRODUTO)           	.And.;
SD7->(FieldPos("D7_DTVALID")) > 0

If n > nAColsIni .And. !aCols[n, Len(aCols[n])]
	
	If ReadVar() == 'M->D7_TIPO'
		If lA175Vld
			lRet := Pertence("1,2,5")
		Else
			lRet := Pertence("1,2")
		EndIf
	Else
		Help(' ',1,'D7_TIPO')                                        	
		lRet := .F.
	EndIf
	
	If lA175Vld
		If lRet .And. !(nTipo == 1 .Or. nTipo == 2 .Or. nTipo == 5)
			Help(' ',1,'D7_TIPO')
			lRet := .F.
		EndIf
	Else
		If lRet .And. !(nTipo == 1 .Or. nTipo == 2)
			Help(' ',1,'D7_TIPO')
			lRet := .F.
		EndIf
	EndIf
	
	nPosSeq    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'D7_SEQ' })// Bruno Abrigo em 26/04/2012
	nPosDesMot := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'D7_DESCRT' })
	nPosLDest  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'D7_LOCDEST'})
	nPosTipo   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'D7_TIPO'   })
	nPosDtValid:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'D7_DTVALID'})
	
	If lRet .And. nPosTipo>0 .And. nPosLDest>0 .And. nPosTipo>0
		
		nTipoAnt := aCols[n, nPosTipo]
		
		//-- Preenche a Descricao do Movimento
		If nTipo == 1
			aCols[n, nPosDesMot] := 'Liberado            ' //OemToAnsi(STR0008) //'Liberado            '
		ElseIf nTipo == 2
			aCols[n, nPosDesMot] := 'Rejeitado           ' //OemToAnsi(STR0009) //'Rejeitado           '
		ElseIf nTipo == 5
			aCols[n, nPosDesMot] := 'Alterar Dt.Validade ' //OemToAnsi(STR0046) //'Alterar Dt.Validade '
		EndIf
		
		//-- Atualiza o campo de data de validade
		If nPosDtValid > 0 .And. nTipo # nTipoAnt
			aCols[n, nPosDtValid] := CTOD('  /  /  ')
		EndIf
		
		//-- Preenche o Local de Destino Padrao
		If nTipo # nTipoAnt .And. (Empty(aCols[n, nPosLDest])    .Or. nTipoAnt==1 .And. aCols[n, nPosLDest] == cLocPad .Or. nTipoAnt==2 .And. aCols[n, nPosLDest] == cLocCQ .or. nTipoAnt==2 .and. aCols[n, nPosLDest] == cMETLoc .Or. nTipoAnt==1 .and. aCols[n, nPosLDest] == cMETLoc)
			&&	aCols[n, nPosLDest] := If(nTipo==1,iif(cLocPad,cLocCQ)
			aCols[n, nPosLDest] :=	If(nTipo==1,Iif( aCols[n,nPosSeq] != '001' .and. Substr(SD7->D7_PRODUTO,1,2)=="LM" .and. SD7->D7_ORIGLAN=="PR",cMETLoc, cLocPad ),cLocCQ)// Bruno Abrigo em 26/04/2012
			
		EndIf
		
	EndIf
	
EndIf

Return lRet
