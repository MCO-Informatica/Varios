#INCLUDE "PROTHEUS.CH"



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MontAcol ³   Fernando Rodrigo Ribeiro    ³ Data ³27.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta Acols baseado na Tabela SA6                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Utilizado para criar vetor com dados da SA6                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*  .AND. U_HCMA001(M->C6_PRODUTO,"01",M->C5_CLIENTE,M->C5_LOJACLI)                                             
*/
User Function MontAcol()
Local aAreaAnt 	:= GetArea()
Local aStru     := {}         
Local nX := 1

Local nProduto  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nQtdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPrcVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nValor	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nTES		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nDescont	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
Local nValDesc	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nComis1	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})
Local nComis2	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})
Local nComis3	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})
Local nComis4	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})
Local nComis5	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})
Local nPrunit	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nTxFin	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})
Local nFrete	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})
Local nMRG		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})

Private cArq    := ""

AADD(aStru,{aHeader[nProduto][2], aHeader[nProduto][8], aHeader[nProduto][4], aHeader[nProduto][5]})
AADD(aStru,{aHeader[nQtdVen][2],  aHeader[nQtdVen][8],  aHeader[nQtdVen][4],  aHeader[nQtdVen][5]})
AADD(aStru,{aHeader[nPrcVen][2],  aHeader[nPrcVen][8],  aHeader[nPrcVen][4],  aHeader[nPrcVen][5]})
AADD(aStru,{aHeader[nValor][2],   aHeader[nValor][8],   aHeader[nValor][4],   aHeader[nValor][5]})
AADD(aStru,{aHeader[nTES][2],     aHeader[nTES][8],     aHeader[nTES][4],     aHeader[nTES][5]})
AADD(aStru,{aHeader[nDescont][2], aHeader[nDescont][8], aHeader[nDescont][4], aHeader[nDescont][5]})
AADD(aStru,{aHeader[nValDesc][2], aHeader[nValDesc][8], aHeader[nValDesc][4], aHeader[nValDesc][5]})
AADD(aStru,{aHeader[nComis1][2],  aHeader[nComis1][8],  aHeader[nComis1][4],  aHeader[nComis1][5]})
AADD(aStru,{aHeader[nComis2][2],  aHeader[nComis2][8],  aHeader[nComis2][4],  aHeader[nComis2][5]})
AADD(aStru,{aHeader[nComis3][2],  aHeader[nComis3][8],  aHeader[nComis3][4],  aHeader[nComis3][5]})
AADD(aStru,{aHeader[nComis4][2],  aHeader[nComis4][8],  aHeader[nComis4][4],  aHeader[nComis4][5]})
AADD(aStru,{aHeader[nComis5][2],  aHeader[nComis5][8],  aHeader[nComis5][4],  aHeader[nComis5][5]})
AADD(aStru,{aHeader[nPrunit][2],  aHeader[nPrunit][8],  aHeader[nPrunit][4],  aHeader[nPrunit][5]})
AADD(aStru,{aHeader[nFrete][2],   aHeader[nFrete][8],   aHeader[nFrete][4],   aHeader[nFrete][5]})
AADD(aStru,{aHeader[nMRG][2],     aHeader[nMRG][8],     aHeader[nMRG][4],     aHeader[nMRG][5]})
AADD(aStru,{aHeader[nTxFin][2],   aHeader[nTxFin][8],   aHeader[nTxFin][4],   aHeader[nTxFin][5]})

If Len(aCols) <> 0
	For nX := 1 to Len(aCols)
		If aCols[nX][Len(aHeader)+1] == .F. //Verifica se a linha eh valida
			//RecLock("TMP1", .T.)
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})] := aCols[nX][nProduto]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]  := aCols[nX][nQtdVen]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]  := aCols[nX][nPrcVen]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]   := aCols[nX][nValor]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})]     := aCols[nX][nTES]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})] := aCols[nX][nDescont]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})] := aCols[nX][nValdesc]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})]  := aCols[nX][nComis1]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})]  := aCols[nX][nComis2]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})]  := aCols[nX][nComis3]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})]  := aCols[nX][nComis4]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})]  := aCols[nX][nComis5]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})]  := aCols[nX][nPrunit]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})]   := aCols[nX][nFrete]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})]     := aCols[nX][nMRG]
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})]   := aCols[nX][nTxFin]
			//MsUnLock()
		EndIf
	Next nX
Endif

RestArea(aAreaAnt)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PVEND    ³   Fernando Rodrigo Ribeiro    ³ Data ³26.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Refresh no Preco de Venda Conforme os Valores Informados   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Utilizado como Valid em Varios Campos no SC6               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PVEND()

Local nPrcCalc  := 0
Local nUlprec   := IIF(ReadVar()=='M->C6_PRCVEN', M->C6_PRCVEN, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})])
Local cInf      := IIF(ReadVar()=='M->C6_TABPRC', M->C6_TABPRC, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TABPRC"})])
if cInf<>"INF"
  ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] := If(ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] == 0, 1, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})])
  nPrcCalc := round(u_PVCIM(),2)
  ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] := nPrcCalc
  ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]  := IIF(ReadVar()=='M->C6_PRCVEN', M->C6_PRCVEN, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]) * IIF(ReadVar()=='M->C6_QTDVEN', M->C6_QTDVEN, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})])
  U_VlDescon(ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})] - nPrcCalc)
ENDIF

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PVCIM    ³   Fernando Rodrigo Ribeiro    ³ Data ³26.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calculo do Preco de Venda Com Imposto                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function PVCIM(nX,nMoeda)
//Local aArea := ( GetArea() )
Local nSPercVar := 0
Local nPVSIm    := 0
Local nResult   := 0
Local nSomaPer  := 0
Local nSPercImp := 0
Local nQtdVend	:= 0
Local cProduto	:= ""
Local nCustoMedUnit := 0
//nCustoMedUnit := U_RetCus(cProduto,nQtdVend)
If !(nX == Nil)
	n := nX
EndIf

nQtdVend	:= IIF(ReadVar()=='M->C6_QTDVEN',  M->C6_QTDVEN,  ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})])
cProduto	:= IIF(ReadVar()=='M->C6_PRODUTO', M->C6_PRODUTO, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})])
nCustoMedUnit := IIF(ReadVar()=='M->C6_CUSUNIT', M->C6_CUSUNIT, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CUSUNIT"})])

dbSelectArea("SB2")

IF(ReadVar()=='M->CK_QTDVEN')
	nQtdVen	:= If(nQtdVend == 0,1,nQtdVend)
	aRetCus  :=	U_RetCus(cProduto,nQtdVen,2)
	dbSelectArea("SC6")
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TABPRC"})] := aRetCus[1]
	nCustoMedUnit  :=	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CUSUNIT"})] := aRetcus[2]
EndIf

dbSelectArea("SC6")
nSomaPer :=  IIF(ReadVar()=='M->C6_COMIS1', M->C6_COMIS1, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})]) ;
+ IIF(ReadVar()=='M->C6_COMIS2', M->C6_COMIS2, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})]) ;
+ IIF(ReadVar()=='M->C6_COMIS3', M->C6_COMIS3, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})]) ;
+ IIF(ReadVar()=='M->C6_COMIS4', M->C6_COMIS4, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})]) ;
+ IIF(ReadVar()=='M->C6_COMIS5', M->C6_COMIS5, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})]) ;
+ IIF(ReadVar()=='M->C6_FRETE',  M->C6_FRETE,  ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})])  ;
+ IIF(ReadVar()=='M->C6_MRG',    M->C6_MRG,    ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})])    ;
+ IIF(ReadVar()=='M->C6_TXFIN',  M->C6_TXFIN,  ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})])


//Soma dos Percentuais das Variaveis
nSPercVar := 1 - (nSomaPer /100)

//Calcula o Preco de Venda Sem Imposto
nPVSIm := nCustoMedUnit / nSPercVar

//Soma dos Percentuais do Imposto

nSPercImp:= U_RetImpos(IIF(ReadVar()=='M->C6_TES', M->C6_TES, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})]))


If (nSPercImp == 0)
	nResult := nPVSIm
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})] := (nCustoMedUnit / u_GetTxs("SC5"))
Else
	nResult := nPVSIm / nSPercImp
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})] := ((nCustoMedUnit / u_GetTxs("SC5"))/nSPercImp)
Endif

//RestArea(aArea)

Return (nResult)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CaRateio  ºAutor  ³Fernando R. Ribeiro º Data ³  12/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para calcular o Rateio para o Calculo do Preco de   º±±
±±º          ³ Venda na tela de Orcamento.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8    HCI                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CaRateio(nMargem, nFrete, nTxFinan, nCoCom, nCoVend1, nCoVend2, nCoVend3, nCoVend4, nVAntMargem, nVAntFrete, nVAntTxFinan, nVAntCoCom, nVAntV1, nVAntV2, nVAntV3, nVAntV4,nCMT, nVlTot, nMarMin)

Local nx := 1
if nMargem<nMarMin 
 	MsgInfo("Valor de Margem Simulada Inferior ao Mínimo permitido para este usuário","Atencao")
else

nx := 1 //TMP1->(dbGoTop())

While nx <= Len(aCols) //While TMP1->(!Eof())
	If (aCols[nx][Len(aHeader)+1] == .F.) //Verifica se a aCols nao esta Deletada
		
		
		//Marg. Contribuição
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})] := Round(nMargem    * (((IIF(ReadVar()=='M->C6_MRG', M->C6_MRG, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})]) * 100) / nVAntMargem) / 100),2)
	   
		//Frete
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})] := Round(nFrete   * (((IIF(ReadVar()=='M->C6_FRETE', M->C6_FRETE, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})]) * 100) / nVAntFrete) / 100),2)
		//Taxa Financeira
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})] := Round(nTxFinan * (((IIF(ReadVar()=='M->C6_TXFIN', M->C6_TXFIN, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})]) * 100) / nVAntTxFinan) / 100),2)
		
		//Preco Unitario
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] := ROUND(u_PVCIM(nX),2)
		
		//COMISSOES
		
		//Comissao Comprador
		//ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})] := nCoCom * ((ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})] * (nVAntCoCom /100)) / nVlTot)
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})] := Round(nCoCom   * (((IIF(ReadVar()=='M->C6_COMIS5', M->C6_COMIS5, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})]) * 100) / nVAntCoCom) / 100),2)
		
		//Comissao Vendedor 1
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})] := Round(nCoVend1 * (((IIF(ReadVar()=='M->C6_COMIS1', M->C6_COMIS1, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})]) * 100) / nVAntV1) / 100),2)
		
		//Comissao Vendedor 2
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})] := Round(nCoVend2 * (((IIF(ReadVar()=='M->C6_COMIS2', M->C6_COMIS2, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})]) * 100) / nVAntV2) / 100),2)
		
		//Comissao Vendedor 3
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})] := Round(nCoVend3 * (((IIF(ReadVar()=='M->C6_COMIS3', M->C6_COMIS3, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})]) * 100) / nVAntV3) / 100),2)
		
		//Comissao Vendedor 4
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})] := Round(nCoVend4 * (((IIF(ReadVar()=='M->C6_COMIS4', M->C6_COMIS4, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})]) * 100) / nVAntV4) / 100),2)
		
		//Vl. Desconto
		//ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})] := nVlTot - nCMT --Calculo Antigo
		If SB1->(dbSeek(xFilial("SC6") + IIF(ReadVar()=='M->C6_PRODUTO', M->C6_PRODUTO, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})])))
			If PA7->(dbSeek(xFilial("SB1") + SB1->B1_GRPVAR))
				
				ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})] := ;
				Round( ;
				(PA7->PA7_FRETE + PA7->PA7_MRG + PA7->PA7_TXFIN + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})]) ;
				- ;
				(ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})]) ;
				, 2)
				
				//Calcula o Preco de Venda Sem Imposto
				ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})] := ((ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]/ (1 - ((PA7->PA7_FRETE + PA7->PA7_MRG + PA7->PA7_TXFIN + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})] + ;
				ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})]) /100))) - ;
				(ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]/ (1 - ((ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})] + ;
				ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})] + ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})]) /100))))
			Endif
		Endif
		
		//Recalcula o Custo Medio
		//ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]:= u_PVSIM()
		
		// Valor Total
		ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})] := ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]* ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]
		
		//MsUnLock()
	Endif
	nx := nx + 1//TMP1->(DbSkip())
Enddo
n:=Len(aCols)
nx:=1

odlg:End()

Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PERRATEIO ºAutor  ³Microsiga           º Data ³  04/23/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PERRATEIO(VlParcialAntigo, VlTotalAntigo)
Local nPERRATEIO := 0
nPERRATEIO := (((VlParcialAntigo*100) / VlTotalAntigo) / 100)
Return nPERRATEIO


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  TELPV   ³   Fernando Rodrigo Ribeiro    ³ Data ³09.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela para Exibir Dados para Rateio do Preco de Venda       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TesGaia   ³ Autor ³ Fernando Rodrigo Ribe ³ Data ³12/03/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Fabr.Tradicional ³Contato ³ fernandor@microsiga.com.br     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TELPV()

// Variaveis Locais da Funcao
Local nCMT	  := 0.00       
Local nCMT1	  := 0.00
Local nMargem	 := 0.00
Local nMarMin    := 0.00
Local nFrete	 := 0.00
Local nTxFinan	 := 0.00
Local nCoCom	 := 0.00
Local nVlTot	 := 0.00
Local nCoVend1   := 0.00
Local nCoVend2   := 0.00
Local nCoVend3   := 0.00
Local nCoVend4   := 0.00
Local nPerdes    := 0.00
Local oGet1
Local oGet2
Local oGet3
Local oGet4
Local oGet5
Local oGet6
Local oGet7
Local oGet8
Local oGet9
Local oGet10
Local oGet11  
Local oGet12
Local nx := 1
Local nC6PrcVen := 0

// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}
//Totalizadores Antes da Modificacao dos Gets
Private nVAntMargem := 0
Private nVAntFrete := 0
Private nVAntTxFinan := 0
Private nVAntCoCom := 0
Private nVAntV1 := 0
Private nVAntV2 := 0
Private nVAntV3 := 0
Private nVAntV4 := 0


// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copia os valores da Tabela TMP (Orcamentos) para os Gets         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


dbSelectArea("SB1")
dbSetOrder(1)  //Filial + Codigo


nx := 1 //TMP1->(dbGoTop())
While nx <= Len(aCols) //While TMP1->(!Eof())
	If (aCols[nx][Len(aHeader)+1] == .F.) //Verifica se a aCols esta nao Deletada
		// Verifica se o Saldo Atual e Menor do que a Qtd Vendida
		// Custo Medio
		
		nCMT:= nCMT+ (IIF(ReadVar()=='M->C6_PRUNIT', M->C6_PRUNIT, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})])*IIF(ReadVar()=='M->C6_QTDVEN', M->C6_QTDVEN,  ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]))
		nCMT1:=nCMT1+(IIF(ReadVar()=='M->C6_CUSUNIT', M->C6_CUSUNIT, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CUSUNIT"})])*IIF(ReadVar()=='M->C6_QTDVEN', M->C6_CUSUNIT,  ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})])) 
		
		nC6PrcVen := IIF(ReadVar()=='M->C6_VALOR', M->C6_VALOR, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})])
		
		//Marg. Contribuição
		nMargem :=  nMargem  + (nC6PrcVen * IIF(ReadVar()=='M->C6_MRG', M->C6_MRG, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})]))
		//Marg. Contribuição
		nMarMin :=  nMarmin  + (nC6PrcVen * IIF(ReadVar()=='M->C6_MARMIN', M->C6_MARMIN, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MARMIN"})]))
		//Frete
		nFrete :=    nFrete  + (nC6PrcVen * IIF(ReadVar()=='M->C6_FRETE', M->C6_FRETE, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})]))
		//Taxa Financeira
		nTxFinan := nTxFinan + (nC6PrcVen * IIF(ReadVar()=='M->C6_TXFIN', M->C6_TXFIN, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})]))
		
		//Comissao Comprador C6_COMIS5
		nCoCom   := nCoCom   + (nC6PrcVen * IIF(ReadVar()=='M->C6_COMIS5', M->C6_COMIS5, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})]))
		//Comissao Comprador C6_COMIS1
		nCoVend1 := nCoVend1 + (nC6PrcVen * IIF(ReadVar()=='M->C6_COMIS1', M->C6_COMIS1, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})]))
		//Comissao Comprador C6_COMIS2
		nCoVend2 := nCoVend2 + (nC6PrcVen * IIF(ReadVar()=='M->C6_COMIS2', M->C6_COMIS2, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})]))
		//Comissao Comprador C6_COMIS3
		nCoVend3 := nCoVend3 + (nC6PrcVen * IIF(ReadVar()=='M->C6_COMIS3', M->C6_COMIS3, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})]))
		//Comissao Comprador C6_COMIS4
		nCoVend4 := nCoVend4 + (nC6PrcVen * IIF(ReadVar()=='M->C6_COMIS4', M->C6_COMIS4, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})]))
		
		nVlTot := (nVlTot + IIF(ReadVar()=='M->C6_VALOR', M->C6_VALOR, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]))  //u_PVSIM()
	Endif
	nx := nx + 1//TMP1->(DbSkip())
Enddo

nCoCom   := nCoCom   / nVlTot
nCoVend1 := nCoVend1 / nVlTot
nCoVend2 := nCoVend2 / nVlTot
nCoVend3 := nCoVend3 / nVlTot
nCoVend4 := nCoVend4 / nVlTot
nFrete   := nFrete   / nVlTot
nMargem  := nMargem  / nVlTot
nMarMin  := nMarMin  / nVlTot
nTxFinan := nTxFinan / nVlTot

nVAntMargem  := nMargem
nVAntFrete  := nFrete
nVAntTxFinan  := nTxFinan
nVAntCoCom  := nCoCom
VlGet6TotAnt  := nVlTot
nVAntV1  := nCoVend1
nVAntV2  := nCoVend2
nVAntV3  := nCoVend3
nVAntV4 := nCoVend4



//u_RECALC(nCMT,@nVlTot,nMargem,nFrete,nTxFinan, nCoCom, nCoVend1, nCoVend2, nCoVend3, nCoVend4)

DEFINE MSDIALOG oDlg TITLE "Cálculo do Preço de Venda" FROM C(343),C(357) TO C(700),C(650) PIXEL

// Defina aqui a chamada dos Aliases para o GetArea
CtrlArea(1,@_aArea,@_aAlias,{"SA1","SA2"}) // GetArea


// Cria Componentes Padroes do Sistema
@ C(009),C(070) MsGet oGet12 Var nCMT1 Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg When .F.
@ C(011),C(009) Say "Cus. Méd. Total s/ Imp" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(021),C(070) MsGet oGet2 Var nMargem Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SC6","C6_MRG") PIXEL OF oDlg Valid U_RECALCT(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
@ C(022),C(009) Say "% Marg. Contribuição" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(033),C(070) MsGet oGet2 Var nMarmin Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SC6","C6_MARMIN") PIXEL OF oDlg When .F.
@ C(034),C(009) Say "% Marg. Minima" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(046),C(070) MsGet oGet3 Var nFrete Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SC6","C6_FRETE") PIXEL OF oDlg Valid U_RECALCT(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
@ C(047),C(009) Say "% Frete" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(058),C(070) MsGet oGet4 Var nTxFinan Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SC6","C6_TXFIN") PIXEL OF oDlg Valid U_RECALCT(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
@ C(058),C(009) Say "% Taxa Financeira" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg

@ C(070),C(009) Say "% Comissão Comprador" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(070),C(070) MsGet oGet5 Var nCoCom Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SC6","C6_COMIS5") PIXEL OF oDlg Valid U_RECALCT(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)

@ C(082),C(009) Say "% Comissão Vendedor 1" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(082),C(070) MsGet oGet7 Var nCoVend1 Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SC6","C6_COMIS1") PIXEL OF oDlg Valid U_RECALCT(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)

If (nCoVend2 <> 0)
	@ C(094),C(009) Say "% Comissão Vendedor 2" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(094),C(070) MsGet oGet8 Var nCoVend2 Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SC6","C6_COMIS2") PIXEL OF oDlg Valid U_RECALCT(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
Endif

If (nCoVend3 <> 0)
	@ C(106),C(009) Say "% Comissão Vendedor 3" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(106),C(070) MsGet oGet9 Var nCoVend3 Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SC6","C6_COMIS3") PIXEL OF oDlg Valid U_RECALCT(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
Endif

If (nCoVend4 <> 0)
	@ C(118),C(009) Say "% Comissão Vendedor 4" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(118),C(070) MsGet oGet10 Var nCoVend4 Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SC6","C6_COMIS4") PIXEL OF oDlg Valid U_RECALCT(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
Endif

@ C(125),C(070) MsGet oGet1 Var nCMT Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg When .F.
@ C(125),C(009) Say  "Preço Venda Total"  Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg

@ C(137),C(009) Say "% Desconto" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(137),C(070) MsGet oGet11 Var nPerDes Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg When .F.

@ C(149),C(009) Say "Vl. Total" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(149),C(070) MsGet oGet6 Var nVlTot Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg When .F.

@ C(165),C(005) Button "Restaurar" Size C(040),C(012) PIXEL OF oDlg ACTION(u_ReOrig()) 
@ C(165),C(055) Button "Ratear" Size C(040),C(012) PIXEL OF oDlg ACTION(u_CaRateio(nMargem, nFrete, nTxFinan, nCoCom, nCoVend1, nCoVend2, nCoVend3, nCoVend4, nVAntMargem, nVAntFrete, nVAntTxFinan, nVAntCoCom, nVAntV1, nVAntV2, nVAntV3, nVAntV4, nCMT, nVlTot, nMarMin))
@ C(165),C(105) Button "Sair" Size C(040),C(012) PIXEL OF oDlg ACTION(odlg:End())


CtrlArea(2,_aArea,_aAlias) // RestArea

ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RECALC  ³ Autores ³ Fernando R. Ribeiro    ³ Data ³13/03/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Recalcula o Custo Medio Total e o Valor Total                ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RECALCT(VlTotal, VlCalc, nPMargem, nPFrete, nPTxFinam, nPCoCom, nPCoV1, nPCoV2, nPCoV3, nPCoV4,nPerdesc)

Local PercVar := 0
Local nSPercImp := 0
Local nx := 1
VlCalc := 0

nx := 1 //TMP1->(dbGoTop())

While nx <= Len(aCols) //While TMP1->(!Eof())
	If (aCols[nx][Len(aHeader)+1] == .F.) //Verifica se a aCols nao esta Deletada
		
PercVar := 1-((	nPMargem * (((IIF(ReadVar()=='M->C6_MRG', M->C6_MRG	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})]) 	* 100) / nVAntMargem) / 100)+;
		nPFrete  	* (((IIF(ReadVar()=='M->C6_FRETE'	, M->C6_FRETE	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})]) 	* 100) / nVAntFrete) / 100)+;
		nPTxFinam 	* (((IIF(ReadVar()=='M->C6_TXFIN'	, M->C6_TXFIN	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})]) 	* 100) / nVAntTxFinan) / 100)+;
		nPCoCom 	* (((IIF(ReadVar()=='M->C6_COMIS5'	, M->C6_COMIS5	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})]) * 100) / nVAntCoCom) / 100)+;
		nPCoV1 		* (((IIF(ReadVar()=='M->C6_COMIS1'	, M->C6_COMIS1	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})]) * 100) / nVAntV1) / 100)+;
		nPCoV2 		* (((IIF(ReadVar()=='M->C6_COMIS2'	, M->C6_COMIS2	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})]) * 100) / nVAntV2) / 100)+;
		nPCoV3 		* (((IIF(ReadVar()=='M->C6_COMIS3'	, M->C6_COMIS3	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})]) * 100) / nVAntV3) / 100)+;
		nPCoV4 		* (((IIF(ReadVar()=='M->C6_COMIS4'	, M->C6_COMIS4	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})]) * 100) / nVAntV4) / 100))/100)
		
		nSPercImp:= U_RetImpos(IF(ReadVar()=='M->C6_TES'	, M->C6_QTDVEN	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})]))
		
		
		If (nSPercImp == 0)
			VlCalc += IF(ReadVar()=='M->C6_QTDVEN'	, M->C6_QTDVEN	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})])*(IF(ReadVar()=='M->C6_CUSUNIT'	, M->C6_CUSUNIT	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CUSUNIT"})]) / PercVar)
		Else
			VlCalc += IF(ReadVar()=='M->C6_QTDVEN'	, M->C6_QTDVEN	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})])*(IF(ReadVar()=='M->C6_CUSUNIT'	, M->C6_CUSUNIT	, ACols[nx][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CUSUNIT"})]) / PercVar/nSPercImp)
		Endif
	EndIf
	nx += 1
EndDo
nPerDesc	 := (1-(VlTotal/VlCalc))*100
//Soma dos Percentuais das Variaveis

dlgRefresh(oDlg)

Return .T.




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtrlArea º Autor ³Ricardo Mansano     º Data ³ 18/05/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLocacao   ³ Fab.Tradicional  ³Contato ³ mansano@microsiga.com.br       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Static Function auxiliar no GetArea e ResArea retornando   º±±
±±º          ³ o ponteiro nos Aliases descritos na chamada da Funcao.     º±±
±±º          ³ Exemplo:                                                   º±±
±±º          ³ Local _aArea  := {} // Array que contera o GetArea         º±±
±±º          ³ Local _aAlias := {} // Array que contera o                 º±±
±±º          ³                     // Alias(), IndexOrd(), Recno()        º±±
±±º          ³                                                            º±±
±±º          ³ // Chama a Funcao como GetArea                             º±±
±±º          ³ P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         º±±
±±º          ³                                                            º±±
±±º          ³ // Chama a Funcao como RestArea                            º±±
±±º          ³ P_CtrlArea(2,_aArea,_aAlias)                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nTipo   = 1=GetArea / 2=RestArea                           º±±
±±º          ³ _aArea  = Array passado por referencia que contera GetArea º±±
±±º          ³ _aAlias = Array passado por referencia que contera         º±±
±±º          ³           {Alias(), IndexOrd(), Recno()}                   º±±
±±º          ³ _aArqs  = Array com Aliases que se deseja Salvar o GetArea º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Generica.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)
Local _nN
// Tipo 1 = GetArea()
If _nTipo == 1
	_aArea   := GetArea()
	For _nN  := 1 To Len(_aArqs)
		DbSelectArea(_aArqs[_nN])
		AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})
	Next
	// Tipo 2 = RestArea()
Else
	For _nN := 1 To Len(_aAlias)
		DbSelectArea(_aAlias[_nN,1])
		DbSetOrder(_aAlias[_nN,2])
		DbGoto(_aAlias[_nN,3])
	Next
	RestArea(_aArea)
Endif
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VlProd   ³   Fernando Rodrigo Ribeiro    ³ Data ³26.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa os campos de Porcentagem e Valor do Produto     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Funcao para ficar no Valid do C6_Produto                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VlProd(nTip)

Local aArea := ( GetArea() )
Local aAreaSC5 := SC5->( GetArea() )
Local aAreaSC6 := SC6->( GetArea() )
Local aAreaPA7 := PA7->( GetArea() )
Local aAreaSB2 := SB2->( GetArea() )
Local aAreaSB1 := SB1->( GetArea() )
Local lRet 	   := .T.
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Default nTip := 1

ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] := If(ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] == 0, 1, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})])

U_Ma410Impos()
//If INCLUI == .T.
dbSelectArea("SB1")
dbSetOrder(1)
// Filial + Codigo
If SB1->(dbSeek(xFilial("SB1") + If(Readvar()=="M->C6_PRODUTO",M->C6_PRODUTO,aCols[n][nPProduto])))
	If !Empty(SB1->B1_GRPVAR)
		
		dbSelectArea("PA7")
		dbSetOrder(1)
		// Filial + Codigo
		If PA7->(dbSeek(xFilial("PA7") + SB1->B1_GRPVAR))
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETE"})] := PA7->PA7_FRETE
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})]   := PA7->PA7_MRG
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_MARMIN"})]:= PA7->PA7_MARMIN
			ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TXFIN"})] := PA7->PA7_TXFIN
		Endif
	Endif
	If nTip == 1
		aRetCus :=	U_RetCus(If(Readvar()=="M->C6_PRODUTO",M->C6_PRODUTO,aCols[n][nPProduto]),ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] ,2)
	Else                                                                           //(cProduto,nQtdVend,nTipRet,nMoeda,cPrcCm1)
		aRetCus :=	U_RetCus(If(Readvar()=="M->C6_PRODUTO",M->C6_PRODUTO,aCols[n][nPProduto]),ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] ,2,,"2")
	EndIf
	M->C6_TABPRC	:= aRetCus[1]
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TABPRC"})] 	:= aRetCus[1]
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CUSUNIT"})]	:= aRetcus[2]
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FONTE"})] 	:= aRetcus[3]
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVLCUS"})]	:= aRetcus[4]
	U_RetComis("SC5",1)
	
	//ElseIf ALTERA == .T.
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})] := u_PVCIM()
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]  := IIF(ReadVar()=='M->C6_PRCVEN', M->C6_PRCVEN, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]) * IIF(ReadVar()=='M->C6_QTDVEN', M->C6_QTDVEN, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})])
	ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})] := IIF(ReadVar()=='M->C6_PRCVEN', M->C6_PRCVEN, ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})])
	//Endif
Else
	MsgInfo("Produto não possui grupo de variaveis informado. Verifique no cadastro de produto","Atencao")
	lRet := .F.
	
EndIf
RestArea(aArea)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaPA7)
RestArea(aAreaSB2)
RestArea(aAreaSB1)

Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A415VlDesc  ³ Autor ³Eduardo Riera        ³ Data ³ 09.12.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da Digitacao do Valor de Desconto                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Logical A410VlDesc(Void)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA410                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VlDescon(nValor)

Local lRetorno    := .T.
Local nPerc       := 0
Local nVlrDesc    := 0
Local nDIfDesc    := 0

nVlrDesc := ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})]
nDIfDesc := ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})] + nVlrDesc - nValor
ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})] := nValor
ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]  := A410Arred((ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})] + nVlrDesc - nValor)/ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})],"C6_PRCVEN")
ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]   := A410Arred((ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] * ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]),"C6_VALOR")
ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})] += (nDIfDesc - ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})])
ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})] := ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})]
nValor            := ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})]
nPerc             := NoRound(ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})]/(ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]+nValor)*100,TamSX3("C6_DESCONT")[2])
ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})]  := nPerc

Return(lRetorno)




/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MA410Impos³ Autor ³ Eduardo Riera         ³ Data ³06.12.2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ma410Impos( nOpc)                                            ³±±
±±³          ³Funcao de calculo dos impostos contidos no pedido de venda   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nOpc                                                        ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta funcao efetua os calculos de impostos (ICMS,IPI,ISS,etc)³±±
±±³          ³com base nas funcoes fiscais, a fim de possibilitar ao usua- ³±±
±±³          ³rio o valor de desembolso financeiro.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Ma410Impos( nOpc )

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aFisGet	:= {}
Local aFisGetSC5:= {}
Local nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPDtEntr  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
Local nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
Local nPVlicm	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VLICM"})
Local nPIpi		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_IPI"})
Local nPPis		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PIS"})
Local nPCofins	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_COFINS"})
Local nPSuframa := 0
Local nUsado    := Len(aHeader)
Local nX        := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nDesconto := 0
Local nAcresFin := 0
Local nQtdPeso  := 0
Local nRecOri   := 0
Local nPosEntr  := 0
Local nItem     := 0
Local nY        := 0
Local nPosCpo   := 0
Local lDtEmi    := SuperGetMv("MV_DPDTEMI",.F.,.T.)
Local dDataCnd  := M->C5_EMISSAO
Local oDlg
Local oDupl
Local oFolder
Local oRentab
Local lCondVenda := .F. // Template GEM
Local aRentabil := {}
Local cProduto  := ""
Local nTotDesc  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC6                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFisGet	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While !Eof().And.X3_ARQUIVO=="SC6"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC5                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFisGetSC5	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof().And.X3_ARQUIVO=="SC5"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa a funcao fiscal                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisSave()
MaFisEnd()
MaFisIni(Iif(Empty(M->C5_CLIENT),M->C5_CLIENTE,M->C5_CLIENT),;// 1-Codigo Cliente/Fornecedor
M->C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
M->C5_TIPO,;				// 4-Tipo da NF
M->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
Nil,;
Nil,;
Nil,;
Nil,;
"MATA461")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza alteracoes de referencias do SC5         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aFisGetSC5) > 0
	dbSelectArea("SC5")
	For nY := 1 to Len(aFisGetSC5)
		If !Empty(&("M->"+Alltrim(aFisGetSC5[ny][2])))
			MaFisAlt(aFisGetSC5[ny][1],&("M->"+Alltrim(aFisGetSC5[ny][2])),,.F.)
		EndIf
	Next nY
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Agrega os itens para a funcao fiscal         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPTotal > 0 .And. nPValDesc > 0 .And. nPPrUnit > 0 .And. nPProduto > 0 .And. nPQtdVen > 0 .And. nPTes > 0
	If Len(aCols[n])==nUsado .Or. !aCols[n][nUsado+1]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona Registros                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cProduto := If(Readvar()=="M->C6_PRODUTO",M->C6_PRODUTO,aCols[n][nPProduto])
		
		
		SB2->(dbSetOrder(1))
		SB2->(MsSeek(xFilial("SB2")+SB1->B1_COD+aCols[n][nPLocal]))
		SF4->(dbSetOrder(1))
		SF4->(MsSeek(xFilial("SF4")+aCols[n][nPTES]))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calcula o preco de lista                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nValMerc  := 100
		nPrcLista := 100
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Agrega os itens para a funcao fiscal         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaFisAdd(cProduto,;   	// 1-Codigo do Produto ( Obrigatorio )
		aCols[n][nPTES],;	   	// 2-Codigo do TES ( Opcional )
		1,;  	// 3-Quantidade ( Obrigatorio )
		nPrcLista,;		  	// 4-Preco Unitario ( Obrigatorio )
		0,; 	// 5-Valor do Desconto ( Opcional )
		"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
		"",;				// 7-Serie da NF Original ( Devolucao/Benef )
		nRecOri,;					// 8-RecNo da NF Original no arq SD1/SD2
		0,;					// 9-Valor do Frete do Item ( Opcional )
		0,;					// 10-Valor da Despesa do item ( Opcional )
		0,;					// 11-Valor do Seguro do item ( Opcional )
		0,;					// 12-Valor do Frete Autonomo ( Opcional )
		nValMerc,;			// 13-Valor da Mercadoria ( Obrigatorio )
		0)					// 14-Valor da Embalagem ( Opiconal )
	EndIf
	aCols[n][nPPis]	:= mafisret(1,"IT_ALIQPIS")
	aCols[n][nPCofins]	:= mafisret(1,"IT_ALIQCOF")
	aCols[n][nPIpi]	:= mafisret(1,"IT_ALIQIPI")
	aCols[n][nPVlicm]	:= mafisret(1,"IT_ALIQICM")

EndIf
MaFisEnd()
MaFisRestore()

RestArea(aAreaSA1)
RestArea(aArea)
Return(.T.)
         
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReOrig     ³ Autor ³ROBSON BUENO          ³ Data ³ 08.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RETORNO AO VALOR ORIGINAL DO PEDIDO                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA415                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
         
User Function ReOrig()
LOCAL nx:=1 //TMP1->(dbGoTop())
While nx <= Len(aCols) //While TMP1->(!Eof())
	If (aCols[nx][Len(aHeader)+1] == .F.) //Verifica se a aCols esta nao Deletada
	  n:=nx
	  U_VLPROD()
	Endif
	nx := nx + 1//TMP1->(DbSkip())
Enddo
nx:=1
odlg:End() 
Return