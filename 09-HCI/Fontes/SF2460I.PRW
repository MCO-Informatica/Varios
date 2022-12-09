#INCLUDE "RWMAKE.CH"
// Ponto de Entrada na Geracao do Documento Fiscal de Saida
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SF2460I  ³ Autor ³ Rogerio Leite         ³ Data ³ 10.08.06   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geracao do Documento Fiscal de Saida                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void SF2460I(void)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³xx/xx/xx³XXXXXX³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF2460I()
Local aArea:= GetArea(),cPrefSE1:= AllTrim(&(GetMv("MV_1DUPREF"))),aTitulos:={},cFilSE1 := xFilial("SE1")
Local aAreaSE1,aAreaSE2,cPrefSE2:= AllTrim(&(GetMv("MV_2DUPREF"))),cFilSE2 := xFilial("SE2")
Local cTpAverb:="NA",aValAverbSF2:={0.00,0.00}
*
cPrefSE1 := cPrefSE1+SPACE(03-Len(cPrefSE1))
cPrefSE2 := cPrefSE2+SPACE(03-Len(cPrefSE2))  
**   
*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo da Averbacao, baseado no arquivo de Tipo de Averbacao x Fator de Averbacao (SZ5).  ³
//³Calculo: Valor da Averbacao = Valor Bruto da NF(SF2) * Fator Averbacao(SZ5)                ³
//³Rotina de Calculo da Averbacao no Programa RFATA050                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*
If SC5->C5_TPFRETE == 'C'    && CIF
   dbSelectArea("SA4")
   MsSeek(xFilial("SA4")+SF2->F2_TRANSP)
   IF SF2->F2_EST == "SP" .And. Len(AllTrim(A4_CGC)) > 14
      SA1->(MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
      If !Eof()                                     
         SZ9->(MsSeek(xFilial("SZ9")+SA1->A1_CEP))
         lAchouSX5 := ChkSX5_Munic(Upper(AllTrim(SZ9->Z9_CIDADE)))        
         If lAchouSX5
            cTpAverb := "UB"
         Else
            cTpAverb := SF2->F2_EST
         Endif
      Else
        cTpAverb := SF2->F2_EST
      Endif
   Else
      cTpAverb := SF2->F2_EST
   Endif             
   *
   aValAverbSF2 := u_Calc_Averbacao(cTpAverb,SF2->F2_VALBRUT)
   *
Endif
*
RecLock("SF2",.F.)
SF2->F2_XTPAVRB := cTpAverb
SF2->F2_XFTAVRB := aValAverbSF2[1]
SF2->F2_XVLAVRB := aValAverbSF2[2]
MsUnLock()
*  
**

	dbSelectArea("SFT")
	dbSetOrder(1)
	If dbSeek(xFilial("SFT")+"E"+SD1->(D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA+D1_ITEM+D1_COD),.F.)
		While Eof() == .F. .And. SFT->FT_FILIAL == xFilial("SFT") .And. SFT->(FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO) == "E"+SD1->(D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA+D1_ITEM+D1_COD)
			RecLock("SFT",.F.)
			SFT->FT_CONTA 	:= Posicione("SB1",1,xFilial("SB1")+SFT->FT_PRODUTO,"B1_CONTA")
			SFT->FT_POSIPI 	:= Posicione("SB1",1,xFilial("SB1")+SFT->FT_PRODUTO,"B1_POSIPI")
			MsUnlock()
			dbSelectArea("SFT")
			dbSkip()
		EndDo	
	EndIf


RestArea(aArea)
* 
U_GERTITST()

Return              


Static Function ChkSX5_Munic(cMunUrbano)
Local aAreaLoc := GetArea(),lRetMun:=.F.
dbSelectArea("SX5")
MsSeek(xFilial("SX5")+"Z2")
While !Eof() .And. X5_TABELA == "Z2"
  If Upper(AllTrim(SZ9->Z9_CIDADE)) == Upper(AllTrim(SX5->X5_DESCRI))
     lRetMun := .T.  
     Exit
  Endif
  dbSkip()
End
*
RestArea(aArealoc)
*
Return lRetMun
