#INCLUDE "PROTHEUS.CH"
//#INCLUDE "MATA415.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Rwmake.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ HCIPVEND ³   Fernando Rodrigo Ribeiro    ³ Data ³08.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Refresh no Preco de Venda Conforme os Valores Informados   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                              
±±³Uso       ³ Utilizado como Valid em Varios Campos no SCK               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function HCIPVEND()

/*
Local nQtdVen := TMP1->CK_QTDVEN := If(IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN) == 0,1,IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN))


Reclock("TMP1",.F.)
TMP1->CK_PRCVEN := round(u_HCIPVCIM(),2)
TMP1->CK_VALOR  := IIF(ReadVar()=='M->CK_PRCVEN', M->CK_PRCVEN, TMP1->CK_PRCVEN) * nQtdVen
M->CK_VALDESC := TMP1->CK_VALDESC  := ((TMP1->CK_PRUNIT - TMP1->CK_PRCVEN)*nQtdVen)
M->CK_DESCONT := NoRound(((TMP1->CK_PRUNIT - TMP1->CK_PRCVEN)*nQtdVen )/(TMP1->CK_VALOR)*100,TamSX3("CK_DESCONT")[2])

U_A415Descon()

Msunlock()
*/
Return (.T.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ HCIPVCIM ³   Fernando Rodrigo Ribeiro    ³ Data ³12.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calculo do Preco de Venda Com Imposto                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function HCIPVCIM(nMoeda)
Local aArea := ( GetArea() )
Local nSPercVar := 0
Local nPVSIm    := 0
Local nResult   := 0
Local nSomaPer  := 0
Local nSPercImp := 0
Local nQtdVen	:= 0
Local nCustoMedUnit := IIF(ReadVar()=='M->CK_CUSUNIT', M->CK_CUSUNIT, TMP1->CK_CUSUNIT)


dbSelectArea("SB2")

IF(ReadVar()=='M->CK_QTDVEN')
	nQtdVen	:= If(IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN) == 0,1,IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN))
	aRetCus  :=	U_RetCus(IIF(ReadVar()=='M->CK_PRODUTO', M->CK_PRODUTO, TMP1->CK_PRODUTO),nQtdVen,2)
	dbSelectArea("TMP1")
	TMP1->CK_TABPRC := aRetCus[1]
	nCustoMedUnit := TMP1->CK_CUSUNIT:= aRetcus[2]
EndIf

dbSelectArea("TMP1")
nSomaPer := nSomaPer + IIF(ReadVar()=='M->CK_COMIS1', M->CK_COMIS1, TMP1->CK_COMIS1)
nSomaPer := nSomaPer + IIF(ReadVar()=='M->CK_COMIS2', M->CK_COMIS2, TMP1->CK_COMIS2)
nSomaPer := nSomaPer + IIF(ReadVar()=='M->CK_COMIS3', M->CK_COMIS3, TMP1->CK_COMIS3)
nSomaPer := nSomaPer + IIF(ReadVar()=='M->CK_COMIS4', M->CK_COMIS4, TMP1->CK_COMIS4)
nSomaPer := nSomaPer + IIF(ReadVar()=='M->CK_COMIS5', M->CK_COMIS5, TMP1->CK_COMIS5)
nSomaPer := nSomaPer + IIF(ReadVar()=='M->CK_FRETE', M->CK_FRETE, TMP1->CK_FRETE)
nSomaPer := nSomaPer + IIF(ReadVar()=='M->CK_MRG'  , M->CK_MRG  , TMP1->CK_MRG)
nSomaPer := nSomaPer + IIF(ReadVar()=='M->CK_TXFIN', M->CK_TXFIN, TMP1->CK_TXFIN)

//Soma dos Percentuais das Variaveis
nSPercVar := 1 - (nSomaPer /100)

//Calcula o Preco de Venda Sem Imposto
nPVSIm := nCustoMedUnit / nSPercVar

//Soma dos Percentuais do Imposto

nSPercImp:= U_RetImpos(TMP1->CK_TES)

If (nSPercImp == 0)
	nResult := nPVSIm
	TMP1->CK_PRUNIT := (nCustoMedUnit / u_GetTxs("SCJ"))
Else
	nResult := nPVSIm / nSPercImp
	TMP1->CK_PRUNIT := ((nCustoMedUnit / u_GetTxs("SCJ"))/nSPercImp)
Endif

RestArea(aArea)

Return (nResult)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcRateioºAutor  ³Fernando R. Ribeiro º Data ³  12/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para calcular o Rateio para o Calculo do Preco de   º±±
±±º          ³ Venda na tela de Orcamento.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8    HCI                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CalcRateio(nMargem, nFrete, nTxFinan, nCoCom, nCoVend1, nCoVend2, nCoVend3, nCoVend4, nVAntMargem, nVAntFrete, nVAntTxFinan, nVAntCoCom, nVAntV1, nVAntV2, nVAntV3, nVAntV4,nCMT,nVlTot, nMarMin)

Local aAreaTMP1 := {}
if nMargem<nMarMin 
 	MsgInfo("Valor de Margem Simulada Inferior ao Mínimo permitido para este usuário","Atencao")
else

aAreaTMP1 := TMP1->( GetArea() )
dbSelectArea("TMP1")
TMP1->(dbGoTop())

While TMP1->(!Eof())
	
	RecLock("TMP1",.F.)
	
	//Marg. Contribuição
	TMP1->CK_MRG := Round(nMargem    * (((IIF(ReadVar()=='M->CK_MRG', M->CK_MRG, TMP1->CK_MRG) * 100) / nVAntMargem) / 100),2)
	//Frete
	TMP1->CK_FRETE := Round(nFrete   * (((IIF(ReadVar()=='M->CK_FRETE', M->CK_FRETE, TMP1->CK_FRETE) * 100) / nVAntFrete) / 100),2)
	//Taxa Financeira
	TMP1->CK_TXFIN := Round(nTxFinan * (((IIF(ReadVar()=='M->CK_TXFIN', M->CK_TXFIN, TMP1->CK_TXFIN) * 100) / nVAntTxFinan) / 100),2)
	
	//Preco Unitario
	TMP1->CK_PRCVEN := u_HCIPVCIM()
	
	//COMISSOES
	
	//Comissao Comprador
	//TMP1->CK_COMIS5 := nCoCom * ((TMP1->CK_VALOR * (nVAntCoCom /100)) / nVlTot)
	TMP1->CK_COMIS5 := Round(nCoCom   * (((IIF(ReadVar()=='M->CK_COMIS5', M->CK_COMIS5, TMP1->CK_COMIS5) * 100) / nVAntCoCom) / 100),2)
	
	//Comissao Vendedor 1
	TMP1->CK_COMIS1 := Round(nCoVend1 * (((IIF(ReadVar()=='M->CK_COMIS1', M->CK_COMIS1, TMP1->CK_COMIS1) * 100) / nVAntV1) / 100),2)
	
	//Comissao Vendedor 2
	TMP1->CK_COMIS2 := Round(nCoVend2 * (((IIF(ReadVar()=='M->CK_COMIS2', M->CK_COMIS2, TMP1->CK_COMIS2) * 100) / nVAntV2) / 100),2)
	
	//Comissao Vendedor 3
	TMP1->CK_COMIS3 := Round(nCoVend3 * (((IIF(ReadVar()=='M->CK_COMIS3', M->CK_COMIS3, TMP1->CK_COMIS3) * 100) / nVAntV3) / 100),2)
	
	//Comissao Vendedor 4
	TMP1->CK_COMIS4 := Round(nCoVend4 * (((IIF(ReadVar()=='M->CK_COMIS4', M->CK_COMIS4, TMP1->CK_COMIS4) * 100) / nVAntV4) / 100),2)
	
	//Vl. Desconto
	//TMP1->CK_VALDESC := nVlTot - nCMT --Calculo Antigo
	If SB1->(dbSeek(xFilial("SCK") + IIF(ReadVar()=='M->CK_PRODUTO', M->CK_PRODUTO, TMP1->CK_PRODUTO)))
		If PA7->(dbSeek(xFilial("SB1") + SB1->B1_GRPVAR))
			TMP1->CK_DESCONT := Round(((PA7->PA7_FRETE + PA7->PA7_MRG + PA7->PA7_TXFIN + IIF(ReadVar()=='M->CK_COMIS1', M->CK_COMIS1, TMP1->CK_COMIS1) + ;
			IIF(ReadVar()=='M->CK_COMIS2', M->CK_COMIS2, TMP1->CK_COMIS2) + IIF(ReadVar()=='M->CK_COMIS3', M->CK_COMIS3, TMP1->CK_COMIS3) + IIF(ReadVar()=='M->CK_COMIS4', M->CK_COMIS4, TMP1->CK_COMIS4) + ;
			IIF(ReadVar()=='M->CK_COMIS5', M->CK_COMIS5, TMP1->CK_COMIS5)) ;
			- (IIF(ReadVar()=='M->CK_FRETE', M->CK_FRETE, TMP1->CK_FRETE) + IIF(ReadVar()=='M->CK_MRG', M->CK_MRG, TMP1->CK_MRG) + ;
			IIF(ReadVar()=='M->CK_TXFIN', M->CK_TXFIN, TMP1->CK_TXFIN) + IIF(ReadVar()=='M->CK_COMIS1', M->CK_COMIS1, TMP1->CK_COMIS1) + IIF(ReadVar()=='M->CK_COMIS2', M->CK_COMIS2, TMP1->CK_COMIS2) + ;
			IIF(ReadVar()=='M->CK_COMIS3', M->CK_COMIS3, TMP1->CK_COMIS3) + IIF(ReadVar()=='M->CK_COMIS4', M->CK_COMIS4, TMP1->CK_COMIS4) + IIF(ReadVar()=='M->CK_COMIS5', M->CK_COMIS5, TMP1->CK_COMIS5))), 2)
			//Calcula o Preco de Venda Sem Imposto
			TMP1->CK_VALDESC := ((TMP1->CK_PRCVEN / (1 - ((PA7->PA7_FRETE + PA7->PA7_MRG + PA7->PA7_TXFIN + IIF(ReadVar()=='M->CK_COMIS1', M->CK_COMIS1, TMP1->CK_COMIS1) + IIF(ReadVar()=='M->CK_COMIS2', M->CK_COMIS2, TMP1->CK_COMIS2) + ;
			IIF(ReadVar()=='M->CK_COMIS3', M->CK_COMIS3, TMP1->CK_COMIS3) + IIF(ReadVar()=='M->CK_COMIS4', M->CK_COMIS4, TMP1->CK_COMIS4) + IIF(ReadVar()=='M->CK_COMIS5', M->CK_COMIS5, TMP1->CK_COMIS5)) /100))) - ;
			(TMP1->CK_PRCVEN / (1 - ((TMP1->CK_FRETE + TMP1->CK_MRG + TMP1->CK_TXFIN + IIF(ReadVar()=='M->CK_COMIS1', M->CK_COMIS1, TMP1->CK_COMIS1) + IIF(ReadVar()=='M->CK_COMIS2', M->CK_COMIS2, TMP1->CK_COMIS2) + ;
			IIF(ReadVar()=='M->CK_COMIS3', M->CK_COMIS3, TMP1->CK_COMIS3) + IIF(ReadVar()=='M->CK_COMIS4', M->CK_COMIS4, TMP1->CK_COMIS4) + IIF(ReadVar()=='M->CK_COMIS5', M->CK_COMIS5, TMP1->CK_COMIS5)) /100))))
		Endif
	Endif
	
	//Recalcula o Custo Medio
	//TMP1->CK_PRCVEN := u_HCIPVSIM()
	
	// Valor Total
	TMP1->CK_VALOR := IIF(ReadVar()=='M->CK_PRCVEN', M->CK_PRCVEN, TMP1->CK_PRCVEN) * IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN)
	M->CK_VALDESC := TMP1->CK_VALDESC  := ((TMP1->CK_PRUNIT - TMP1->CK_PRCVEN)*IF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN))
	M->CK_DESCONT := NoRound(((TMP1->CK_PRUNIT - TMP1->CK_PRCVEN)*IF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN) )/(TMP1->CK_VALOR)*100,TamSX3("CK_DESCONT")[2])
	MsUnLock()
	
	TMP1->(DbSkip())
	
Enddo

RestArea(aAreaTMP1)

odlg:End() 

endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PercRateioºAutor  ³Microsiga           º Data ³  04/19/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PercRateio(VlParcialAntigo, VlTotalAntigo)
Local nPercRateio := 0
nPercRateio := (((VlParcialAntigo*100) / VlTotalAntigo) / 100)
Return nPercRateio



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  CPA7    ³   Fernando Rodrigo Ribeiro    ³ Data ³08.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria Tabela para dados no SX3                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CPA7()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "PA7"

dbSelectArea("PA7")
dbSetOrder(1)

AxCadastro(cString,"Cria tabela PA7",cVldExc,cVldAlt)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  TELAPV  ³   Fernando Rodrigo Ribeiro    ³ Data ³09.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela para Exibir Dados para Rateio do Preco de Venda       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#INCLUDE "PROTHEUS.CH"
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
User Function TELAPV()

Local aAreaTMP := {}

// Variaveis Locais da Funcao
Local nCMT	  	 := 0.00
Local nCMT1	  	 := 0.00
Local nMargem	 := 0.00
Local nMarmin    := 0.00
Local nFrete	 := 0.00
Local nTxFinan	 := 0.00
Local nCoCom	 := 0.00
Local nVlTot	 := 0.00
Local nPerDes	 := 0.00
Local nCoVend1   := 0.00
Local nCoVend2   := 0.00
Local nCoVend3   := 0.00
Local nCoVend4   := 0.00
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
// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}
//Totalizadores Antes da Modificacao dos Gets
Private nVAntMargem 	:= 0
Private nVAntMarmin		:= 0
Private nVAntFrete 	    := 0
Private nVAntTxFinan 	:= 0
Private nVAntCoCom   	:= 0
Private nVAntV1 		:= 0
Private nVAntV2 		:= 0
Private nVAntV3 		:= 0
Private nVAntV4 		:= 0

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

aAreaTMP1 := TMP1->( GetArea() )

dbSelectArea("TMP1")
TMP1->(dbGoTop())
While TMP1->(!Eof())
	
	// Verifica se o Saldo Atual e Menor do que a Qtd Vendida
	// Custo Medio
	nCMT:= nCMT+ (TMP1->CK_PRUNIT * IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN)) //Totalizar Orcamento (* TMP1->CK_QTDVEN)
	nCMT1:= nCMT1+ (TMP1->CK_CUSUNIT * IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN)) //Totalizar Orcamento (* TMP1->CK_QTDVEN)
	
	//Marg. Contribuição
	nMargem :=  Round(nMargem  + (IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR) * IIF(ReadVar()=='M->CK_MRG', M->CK_MRG, TMP1->CK_MRG)),2)
	//Marg. Minima
	nMarmin :=  Round(nMarmin  + (IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR) * IIF(ReadVar()=='M->CK_MARMIN', M->CK_MARMIN, TMP1->CK_MARMIN)),2)
	//Frete
	nFrete :=    Round(nFrete  + (IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR) * IIF(ReadVar()=='M->CK_FRETE', M->CK_FRETE, TMP1->CK_FRETE)),2)
	//Taxa Financeira
	nTxFinan := Round(nTxFinan + (IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR) * IIF(ReadVar()=='M->CK_TXFIN', M->CK_TXFIN, TMP1->CK_TXFIN)),2)
	//Comissao Comprador CK_COMIS5
	nCoCom   := Round(nCoCom   + (IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR) * (IIF(ReadVar()=='M->CK_COMIS5', M->CK_COMIS5, TMP1->CK_COMIS5)   )),2)// /100
	//Comissao Comprador CK_COMIS1
	nCoVend1 := Round(nCoVend1 + (IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR) * (IIF(ReadVar()=='M->CK_COMIS1', M->CK_COMIS1, TMP1->CK_COMIS1)   )),2)// /100
	//Comissao Comprador CK_COMIS2
	nCoVend2 := Round(nCoVend2 + (IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR) * (IIF(ReadVar()=='M->CK_COMIS2', M->CK_COMIS2, TMP1->CK_COMIS2)   )),2)// /100
	//Comissao Comprador CK_COMIS3
	nCoVend3 := Round(nCoVend3 + (IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR) * (IIF(ReadVar()=='M->CK_COMIS3', M->CK_COMIS3, TMP1->CK_COMIS3)   )),2)// /100
	//Comissao Comprador CK_COMIS4
	nCoVend4 := Round(nCoVend4 + (IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR) * (IIF(ReadVar()=='M->CK_COMIS4', M->CK_COMIS4, TMP1->CK_COMIS4)   )),2)
	
	nVlTot := (nVlTot + IIF(ReadVar()=='M->CK_VALOR', M->CK_VALOR, TMP1->CK_VALOR))
	
	TMP1->(DbSkip())
Enddo
nPerDes	 := (1-(nVlTot/nCMT))*100
nCoCom   := nCoCom   / nVlTot
nCoVend1 := nCoVend1 / nVlTot
nCoVend2 := nCoVend2 / nVlTot
nCoVend3 := nCoVend3 / nVlTot
nCoVend4 := nCoVend4 / nVlTot
nFrete   := nFrete   / nVlTot
nMargem  := nMargem  / nVlTot 
nMarmin  := nMarmin  / nVlTot
nTxFinan := nTxFinan / nVlTot

nVAntMarMin  := nMarmin
nVAntMargem  := nMargem
nVAntFrete   := nFrete
nVAntTxFinan := nTxFinan
nVAntCoCom   := nCoCom
VlGet6TotAnt := nVlTot
nVAntV1  := nCoVend1
nVAntV2  := nCoVend2
nVAntV3  := nCoVend3
nVAntV4 := nCoVend4


RestArea(aAreaTMP1)

//u_Recalcula(nCMT,@nVlTot,nMargem,nFrete,nTxFinan, nCoCom, nCoVend1, nCoVend2, nCoVend3, nCoVend4)

DEFINE MSDIALOG oDlg TITLE "Cálculo do Preço de Venda" FROM C(343),C(357) TO C(700),C(650) PIXEL

// Defina aqui a chamada dos Aliases para o GetArea
CtrlArea(1,@_aArea,@_aAlias,{"SA1","SA2"}) // GetArea


// Cria Componentes Padroes do Sistema
@ C(009),C(070) MsGet oGet12 Var nCMT1 Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg When .F.
@ C(011),C(009) Say "Cus. Méd. Total s/ Imp" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(021),C(070) MsGet oGet2 Var nMargem Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SCK","CK_MRG") PIXEL OF oDlg Valid u_Recalcula(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
@ C(022),C(009) Say "% Marg. Contribuição" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(033),C(070) MsGet oGet2 Var nMarmin Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SCK","CK_MARMIN") PIXEL OF oDlg When .F.
@ C(034),C(009) Say "% Marg. Minima" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg

@ C(046),C(070) MsGet oGet3 Var nFrete Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SCK","CK_FRETE") PIXEL OF oDlg Valid u_Recalcula(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
@ C(047),C(009) Say "% Frete" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(058),C(070) MsGet oGet4 Var nTxFinan Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SCK","CK_TXFIN") PIXEL OF oDlg Valid u_Recalcula(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
@ C(058),C(009) Say "% Taxa Financeira" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg

@ C(070),C(009) Say "% Comissão Comprador" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(070),C(070) MsGet oGet5 Var nCoCom Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SCK","CK_COMIS5") PIXEL OF oDlg Valid u_Recalcula(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)

@ C(082),C(009) Say "% Comissão Vendedor 1" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(082),C(070) MsGet oGet7 Var nCoVend1 Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SCK","CK_COMIS1") PIXEL OF oDlg Valid u_Recalcula(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)

If (nCoVend2 <> 0)
	@ C(094),C(009) Say "% Comissão Vendedor 2" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(094),C(070) MsGet oGet8 Var nCoVend2 Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SCK","CK_COMIS2") PIXEL OF oDlg Valid u_Recalcula(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
Endif

If (nCoVend3 <> 0)
	@ C(106),C(009) Say "% Comissão Vendedor 3" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(106),C(070) MsGet oGet9 Var nCoVend3 Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SCK","CK_COMIS3") PIXEL OF oDlg Valid u_Recalcula(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
Endif

If (nCoVend4 <> 0)
	@ C(118),C(009) Say "% Comissão Vendedor 4" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(118),C(070) MsGet oGet10 Var nCoVend4 Size C(060),C(009) COLOR CLR_BLACK Picture PesqPict("SCK","CK_COMIS4") PIXEL OF oDlg Valid u_Recalcula(nCMT,@nVlTot,nMargem,nFrete,nTxFinan,nCoCom,nCoVend1,nCoVend2,nCoVend3,nCoVend4,@nPerDes)
Endif                                                                                    

@ C(125),C(070) MsGet oGet1 Var nCMT Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg When .F.
@ C(125),C(009) Say "Preço Venda Total" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg

@ C(137),C(009) Say "% Desconto" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(137),C(070) MsGet oGet11 Var nPerDes Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg When .F.

@ C(149),C(009) Say "Vl. Total" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(149),C(070) MsGet oGet6 Var nVlTot Size C(060),C(009) COLOR CLR_BLACK Picture "@E 999,999,999.99" PIXEL OF oDlg When .F.

@ C(165),C(005) Button "Restaurar" Size C(040),C(012) PIXEL OF oDlg ACTION(u_RetOrig()) 
@ C(165),C(055) Button "Ratear"    Size C(040),C(012) PIXEL OF oDlg ACTION(u_CalcRateio(nMargem, nFrete, nTxFinan, nCoCom, nCoVend1, nCoVend2, nCoVend3, nCoVend4, nVAntMargem, nVAntFrete, nVAntTxFinan, nVAntCoCom, nVAntV1, nVAntV2, nVAntV3, nVAntV4, nCMT, nVlTot, nMarMin))
@ C(165),C(105) Button "Sair"      Size C(040),C(012) PIXEL OF oDlg ACTION  odlg:End() // Close(oDlg)


CtrlArea(2,_aArea,_aAlias) // RestArea

ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³Recalcula³ Autores ³ Fernando R. Ribeiro    ³ Data ³13/03/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Recalcula o Custo Medio Total e o Valor Total                ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Recalcula(VlTotal	, VlCalc, nPMargem	, nPFrete	, nPTxFinam	, nPCoCom	, nPCoV1	, nPCoV2	, nPCoV3	, nPCoV4, nPerDesc)
//	(nCMT	,@nVlTot,nMargem	,nFrete		,nTxFinan	, nCoCom	, nCoVend1	, nCoVend2	, nCoVend3	, nCoVend4)
Local PercVar := 0
Local nSPercImp := 0
VlCalc := 0
dbSelectArea("TMP1")
TMP1->(dbGoTop())

While TMP1->(!Eof())
	
	
	PercVar :=   1-((	Round(nPMargem  * (((IIF(ReadVar()=='M->CK_MRG', M->CK_MRG, TMP1->CK_MRG) 		* 100) / nVAntMargem)	/ 100),2)+ ;
	Round(nPFrete   * (((IIF(ReadVar()=='M->CK_FRETE', M->CK_FRETE, TMP1->CK_FRETE) 	* 100) / nVAntFrete) 	/ 100),2)+;
	Round(nPTxFinam * (((IIF(ReadVar()=='M->CK_TXFIN', M->CK_TXFIN, TMP1->CK_TXFIN) 	* 100) / nVAntTxFinan) 	/ 100),2)+;
	Round(nPCoCom   * (((IIF(ReadVar()=='M->CK_COMIS5', M->CK_COMIS5, TMP1->CK_COMIS5)* 100) / nVAntCoCom) 	/ 100),2)+;
	Round(nPCoV1  	* (((IIF(ReadVar()=='M->CK_COMIS1', M->CK_COMIS1, TMP1->CK_COMIS1)* 100) / nVAntV1) 		/ 100),2)+;
	Round(nPCoV3 	* (((IIF(ReadVar()=='M->CK_COMIS2', M->CK_COMIS2, TMP1->CK_COMIS2)* 100) / nVAntV2) 		/ 100),2)+;
	Round(nPCoV3 	* (((IIF(ReadVar()=='M->CK_COMIS3', M->CK_COMIS3, TMP1->CK_COMIS3)* 100) / nVAntV3) 		/ 100),2)+;
	Round(nPCoV4 	* (((IIF(ReadVar()=='M->CK_COMIS4', M->CK_COMIS4, TMP1->CK_COMIS4)* 100) / nVAntV4) 		/ 100),2)  )/100)
	
	nSPercImp:= U_RetImpos(TMP1->CK_TES)
	
	
	If (nSPercImp == 0)
		VlCalc += TMP1->CK_QTDVEN*(TMP1->CK_CUSUNIT / PercVar)
	Else
		VlCalc += TMP1->CK_QTDVEN*(TMP1->CK_CUSUNIT / PercVar/nSPercImp)
	Endif
	nPerDesc	 := (1-(VlTotal/VlCalc))*100
	
	dbSkip()
EndDo
dbgotop()
//Soma dos Percentuais das Variaveis
//PercVar := 1 - ((nPMargem + nPFrete + nPTxFinam + nPCoCom + nPCoV1 + nPCoV2 + nPCoV3 + nPCoV4) /100)
//Calcula o Preco de Venda Sem Imposto
//VlCalc := Round(VlTotal/PercVar, 2)

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
±±³Programa  ³ ValPreco ³   Fernando Rodrigo Ribeiro    ³ Data ³21.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa os campos de Porcentagem e Valor do Produto     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Funcao para ficar no Valid do CK_Produto                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ValProd(nTip)

Local aArea 	:= ( GetArea() )
Local aAreaSCJ 	:= SCJ->( GetArea() )
Local aAreaSCK 	:= SCK->( GetArea() )
Local aAreaPA7 	:= PA7->( GetArea() )
Local aAreaSB2 	:= SB2->( GetArea() )
Local aAreaSB1 	:= SB1->( GetArea() )
Local lRet 	   	:= .T.
Local aRetCus	:= {}

Default nTip := 1

TMP1->CK_QTDVEN := If(TMP1->CK_QTDVEN == 0,1,TMP1->CK_QTDVEN)

dbSelectArea("SB1")
dbSetOrder(1)
// Filial + Codigo
If SB1->(dbSeek(xFilial("SB1") + IIF(ReadVar()=='M->CK_PRODUTO', M->CK_PRODUTO, TMP1->CK_PRODUTO)))
	If !Empty(SB1->B1_GRPVAR)
		
		dbSelectArea("PA7")
		dbSetOrder(1)
		// Filial + Codigo
		If PA7->(dbSeek(xFilial("PA7") + SB1->B1_GRPVAR))
			TMP1->CK_FRETE := PA7->PA7_FRETE
			TMP1->CK_MRG   := PA7->PA7_MRG
			TMP1->CK_MARMIN:= PA7->PA7_MARMIN
			TMP1->CK_TXFIN := PA7->PA7_TXFIN
		Endif               
		
				
		If nTip == 1
			aRetCus :=	U_RetCus(IIF(ReadVar()=='M->CK_PRODUTO', M->CK_PRODUTO, TMP1->CK_PRODUTO),TMP1->CK_QTDVEN,2)
		Else                                                                           //(cProduto,nQtdVend,nTipRet,nMoeda,cPrcCm1)
			aRetCus :=	U_RetCus(IIF(ReadVar()=='M->CK_PRODUTO', M->CK_PRODUTO, TMP1->CK_PRODUTO),TMP1->CK_QTDVEN,2,,"2")
		EndIf
	   	M->CK_TABPRC	:= aRetCus[1]
		TMP1->CK_TABPRC := aRetCus[1]
		TMP1->CK_CUSUNIT:= aRetcus[2]
		TMP1->CK_FONTE	:= aRetCus[3]
		TMP1->CK_DTVALID:= aRetCus[4]
		U_RetComis("SCJ",1)
		TMP1->CK_PRCVEN := u_HCIPVCIM()
		TMP1->CK_VALOR  := IIF(ReadVar()=='M->CK_PRCVEN', M->CK_PRCVEN, TMP1->CK_PRCVEN) * IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN)
		TMP1->CK_VALDESC  := (TMP1->CK_PRUNIT - TMP1->CK_PRCVEN)*TMP1->CK_QTDVEN
		TMP1->CK_DESCONT  := NoRound(TMP1->CK_VALDESC/(TMP1->CK_VALOR)*100,TamSX3("CK_DESCONT")[2])
	Else
		MsgInfo("Produto não possui grupo de variaveis informado. Verifique no cadastro de produto","Atencao")
		lRet := .F.
		
	EndIf
EnDIf  

RestArea(aArea)
RestArea(aAreaSCJ)
RestArea(aAreaSCK)
RestArea(aAreaPA7)
RestArea(aAreaSB2)
RestArea(aAreaSB1)

Return (lRet)



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MA415Impos³ Autor ³ Eduardo Riera         ³ Data ³24.07.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ma415Impos(nOpc)                                             ³±±
±±³          ³Funcao de calculo dos impostos contidos no orcamento de venda³±±
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
USer Function Ma415Impos( nOpc )

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaTMP1 := TMP1->(GetArea())
Local aRetImp   := {}
Local nPrcLista := 0
Local nValMerc  := 0




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona Registros                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+If(!Empty(M->CJ_CLIENT),M->CJ_CLIENT,M->CJ_CLIENTE)+M->CJ_LOJAENT)

dbSelectArea("SE4")
dbSetOrder(1)
MsSeek(xFilial("SE4")+M->CJ_CONDPAG)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa a funcao fiscal                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisSave()

//MaFisEnd()
MaFisIni(Iif(Empty(M->CJ_CLIENT),M->CJ_CLIENTE,M->CJ_CLIENT),;// 1-Codigo Cliente/Fornecedor
M->CJ_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
"C",;				// 3-C:Cliente , F:Fornecedor
"N",;				// 4-Tipo da NF
SA1->A1_TIPO,;		// 5-Tipo do Cliente/Fornecedor
Nil,;
Nil,;
Nil,;
Nil,;
"MATA461")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Agrega os itens para a funcao fiscal         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TMP1")
//dbGotop()
//While ( !Eof() )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a linha foi deletada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( !TMP1->CK_FLAG .And. !Empty(if(readvar()="M->CK_PRODUTO",M->CK_PRODUTO,TMP1->CK_PRODUTO)+TMP1->CK_LOCAL))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona Registros                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SB2->(dbSetOrder(1))
	SB2->(MsSeek(xFilial("SB2")+if(readvar()="M->CK_PRODUTO",M->CK_PRODUTO,TMP1->CK_PRODUTO)+TMP1->CK_LOCAL))
	SF4->(dbSetOrder(1))
	SF4->(MsSeek(xFilial("SF4")+if(readvar()="M->CK_TES",M->CK_TES,TMP1->CK_TES)))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula o preco de lista                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPrcLista := 100
	nValMerc  := 100
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Agrega os itens para a funcao fiscal         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAdd(if(readvar()="M->CK_PRODUTO",M->CK_PRODUTO,TMP1->CK_PRODUTO),;   	// 1-Codigo do Produto ( Obrigatorio )
	If(readvar()="M->CK_TES",M->CK_TES,TMP1->CK_TES),;	   	// 2-Codigo do TES ( Opcional )
		1,;  	// 3-Quantidade ( Obrigatorio )
		nPrcLista,;		  	// 4-Preco Unitario ( Obrigatorio )
		0,; 	// 5-Valor do Desconto ( Opcional )
		"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
		"",;				// 7-Serie da NF Original ( Devolucao/Benef )
		0,;					// 8-RecNo da NF Original no arq SD1/SD2
		0,;					// 9-Valor do Frete do Item ( Opcional )
		0,;					// 10-Valor da Despesa do item ( Opcional )
		0,;					// 11-Valor do Seguro do item ( Opcional )
		0,;					// 12-Valor do Frete Autonomo ( Opcional )
		nValMerc,;			// 13-Valor da Mercadoria ( Obrigatorio )
		0)					// 14-Valor da Embalagem ( Opiconal )
		
	   RecLock("TMP1",.F.)
	   If(readvar()="M->CK_PIS",M->CK_PIS,TMP1->CK_PIS):=mafisret(1,"IT_ALIQPIS")
       If(readvar()="M->CK_COFINS",M->CK_COFINS,TMP1->CK_COFINS):=mafisret(1,"IT_ALIQCOF")
       If(readvar()="M->CK_IPI",M->CK_IPI,TMP1->CK_IPI):=mafisret(1,"IT_ALIQIPI")
       If(readvar()="M->CK_VLICM",M->CK_VLICM,TMP1->CK_VLICM):=mafisret(1,"IT_ALIQICM")		
		MsUnLock()
		Aadd(aRetImp, {mafisret(1,"IT_ALIQPIS"),mafisret(1,"IT_ALIQCOF"),mafisret(1,"IT_ALIQIPI"),mafisret(1,"IT_ALIQICM")})
		
EndIf

dbSelectArea("TMP1")

MaFisEnd()
MaFisRestore()

RestArea(aAreaTMP1)
RestArea(aAreaSA1)
RestArea(aArea)

Return(aRetImp)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A415Descon  ³ Autor ³Eduardo Riera        ³ Data ³ 09.12.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da Digitacao do Percentual de Desconto           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := A415Descon( [ ExpL2 ] )                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA415                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A415Descon()

Local aArea		:= GetArea()
Local lRetorno	:= .T.
Local nValor      := TMP1->CK_VALOR
Local nPDesc      := TMP1->CK_DESCONT
Local nVlDesc     := TMP1->CK_VALDESC
Local nPrcVen	:= 0
//Positivo() .and. a415QtdVen()
//If "CK_DESCONT"$ReadVar()
nPDesc := M->CK_DESCONT
//EndIf

If ( TMP1->(FieldPos("CK_VALDESC")) > 0 .And.;
	TMP1->(FieldPos("CK_DESCONT"))>0  .And.;
	TMP1->CK_QTDVEN>0 .And.;
	TMP1->CK_PRCVEN>0 )
	
	nPrcVen  := FtDescItem(FtDescCab(TMP1->CK_PRUNIT,{M->CJ_DESC1,M->CJ_DESC2,M->CJ_DESC3,M->CJ_DESC4}),TMP1->CK_PRCVEN,TMP1->CK_QTDVEN,@nValor,@M->CK_DESCONT,@nVlDesc,nVlDesc,1,,If(cPaisLoc=="CHI",M->CJ_MOEDA,NIL))
	
	If ( nPrcVen <= 0 )
		TMP1->CK_DESCONT  := 0
		TMP1->CK_VALDESC  := 0
		Help(" ",1,"A415DESCON")
		lRetorno := .F.
	Else
		TMP1->CK_PRCVEN  := nPrcVen
		TMP1->CK_VALOR   := nValor
		TMP1->CK_DESCONT := nPDesc
		TMP1->CK_VALDESC := nVlDesc
	EndIf
EndIf
RestArea( aArea )
Return(lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RetOrig     ³ Autor ³ROBSON BUENO         ³ Data ³ 08.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RETORNO AO VALOR ORIGINAL DO ORÇAENTO                      ³±±
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


User Function RetOrig()

dbSelectArea("TMP1")
TMP1->(dbGoTop())
While TMP1->(!Eof())  
    RecLock("TMP1",.F.)
    U_VALPROD()
	MsUnLock()
	TMP1->(DbSkip())
EndDo
TMP1->(dbGoTop())
odlg:End() 

Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RetOri2     ³ Autor ³ROBSON BUENO         ³ Data ³ 08.04.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RETORNO AO VALOR ORIGINAL DO ORÇAENTO                      ³±±
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


USER FUNCTION ATPRECO()


// 1 PASSO - ABRIR LISTA DE OCS A SEREM IMPORTADAS

Local oDlgl
Private nFator:=0 
Private nFator2:=0
Private nFator3:=0
Private nFator4:=0 
Private nFator5:=0
Private nFator6:=0
@ 000,000 To 220,400 Dialog oDlgl Title OemToAnsi("Carregar Dados")
@ 003,008 To 110,200 Title OemToAnsi("Informe o Fator a Sobre a Tabela?")
@ 015,015 Say OemToAnsi("Fator Tabela:") OF Odlgl PIXEL
@ 015,065 MSGET nFator SIZE 65,5 Picture "@E 999.9999" PIXEL OF oDlgl 
@ 025,015 Say OemToAnsi("Fator CMedio:") OF Odlgl PIXEL
@ 025,065 MSGET nFator2 SIZE 65,5 Picture "@E 999.9999" PIXEL OF oDlgl 
@ 035,015 Say OemToAnsi("Fator Base:") OF Odlgl PIXEL
@ 035,065 MSGET nFator3 SIZE 65,5 Picture "@E 999.9999" PIXEL OF oDlgl 
@ 045,015 Say OemToAnsi("Fator Preco:") OF Odlgl PIXEL
@ 045,065 MSGET nFator4 SIZE 65,5 Picture "@E 999.9999" PIXEL OF oDlgl 
@ 055,015 Say OemToAnsi("Preco Fechado:") OF Odlgl PIXEL
@ 055,065 MSGET nFator5 SIZE 65,5 Picture "@E 99999999.9999" PIXEL OF oDlgl 
@ 065,015 Say OemToAnsi("Preco Campanha:") OF Odlgl PIXEL
@ 065,065 MSGET nFator6 SIZE 65,5 Picture "@E 999.9999" PIXEL OF oDlgl 
@ 090,030 BMPBUTTON TYPE 1 ACTION U_Retor2(odlgl,nFator,nFator2,nFator3,nFator4,nFator5,nFator6)
@ 090,060 BMPBUTTON TYPE 2 ACTION  odlgl:End()
Activate Dialog Odlgl CENTER
RETURN              


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RetOrig     ³ Autor ³ROBSON BUENO         ³ Data ³ 08.04.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RETORNO AO VALOR ORIGINAL DO ORÇAENTO                      ³±±
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


User Function RetOr2(odlg)

dbSelectArea("TMP1")
TMP1->(dbGoTop())
if nFator5<>0
  nFator4:=nFator5/M->CJ_TOTAL
endif  
M->CJ_TOTAL:=0
While TMP1->(!Eof())  
    RecLock("TMP1",.F.)
    U_VALPRO2(nFator,nFator2,nFator3,nFator4,nFator5,nFator6)
	MsUnLock()
	TMP1->(DbSkip())
EndDo
TMP1->(dbGoTop())
odlg:End() 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ValPreco ³   Fernando Rodrigo Ribeiro    ³ Data ³21.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa os campos de Porcentagem e Valor do Produto     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Funcao para ficar no Valid do CK_Produto                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ValPro2(nFator,nFator2,nFator3,nFator4,nFator5,nFator6)

Local aArea 	:= ( GetArea() )
Local aAreaSCJ 	:= SCJ->( GetArea() )
Local aAreaSCK 	:= SCK->( GetArea() )
Local aAreaPA7 	:= PA7->( GetArea() )
Local aAreaSB2 	:= SB2->( GetArea() )
Local aAreaSB1 	:= SB1->( GetArea() )
Local lRet 	   	:= .T.
Local aRetCus	:= {}
Local nTip:=1
Local cCusto:=0
Local cCusto:=0 
Local cIcms:=0 
Local cProduto
Local cComis:="" 
Default nTip := 1

TMP1->CK_QTDVEN := If(TMP1->CK_QTDVEN == 0,1,TMP1->CK_QTDVEN)
IIF(ReadVar()=='M->CK_PRODUTO', cProduto:=M->CK_PRODUTO, cProduto:=TMP1->CK_PRODUTO)
// Filial + Codigo
Do Case
Case nFator>0 .and. nFator2=0 .and. nFator4=0 .and. nFator3=0
	if TMP1->CK_PRCVEN=0
	dbSelectArea("SB1")
    dbSetOrder(1)
	If SB1->(dbSeek(xFilial("SB1") + IIF(ReadVar()=='M->CK_PRODUTO', M->CK_PRODUTO, TMP1->CK_PRODUTO))) 
	If !Empty(SB1->B1_VDANOR)
		TMP1->CK_PRCVEN   := SB1->B1_VDANOR*nFator
		TMP1->CK_VALOR    := IIF(ReadVar()=='M->CK_PRCVEN', M->CK_PRCVEN, TMP1->CK_PRCVEN) * IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN)
		TMP1->CK_VALDESC  := 0
		TMP1->CK_DESCONT  := 0
	   	TMP1->CK_FEELING  :=" Est: "+transform(u_retest(cProduto),"@e 99999.99")

	Else
	    lRet := .F.
	EndIf
	EnDIf  
	endif
Case nFator=0 .and. (nFator2>0 .or. nFator6>0) .and. nFator4=0 .and. nFator3=0
	if TMP1->CK_PRCVEN=0
	dbSelectArea("SB1")
    dbSetOrder(1)
    SB1->(dbSeek(xFilial("SB1") + IIF(ReadVar()=='M->CK_PRODUTO', M->CK_PRODUTO, TMP1->CK_PRODUTO)))
	CCUSTO:=0.00
	cIcms:=0
	DbSelectArea("PAA")
    dbSetOrder(1)
    if MsSeek(xfilial("PAA")+TMP1->CK_PRODUTO)
       if nFator6>0 
         ccusto:=PAA->PAA_UNIT2
       ENDIF  
       IF CCUSTO=0 
         ccusto:=PAA->PAA_UNIT
       ENDIF
    ELSE
      CCUSTO:=0.00
    ENDIF  
    cMc:=Posicione("PA7",1,xFilial("PA7")+SB1->B1_GRPVAR,"PA7_MRG") 
    If M->CJ_ESTENT="SP"
      cIcms:=18
    ENDIF
    If M->CJ_ESTENT $ "MG/RJ/SC/PR/RS"
      cIcms:=12
    ENDIF  
    If M->CJ_ESTENT $ "AC/AL/AM/AP/BA/CE/DF/ES/GO/MA/MS/MT/PA/PB/PE/PI/SE/RN/RO/RR/TO"
      cIcms:=7
    endif 
    IF nFator6>0
      nFator2:=nFator6
    endif   
    IF M->CJ_VEND='000001' .AND. M->CJ_VEND5='      ' 
      TMP1->CK_PRCVEN := ROUND((cCusto/(1-((0/100)*(1+(cMC*nFator2/100))))*(1+(cMC*nFator2/100)))/(1-((1.65+7.60+cIcms)/100)),2)
	  cComis:="/Rp1:0/Rp2:0/" 
	ELSE
	  IF M->CJ_VEND<>'000001' .AND. M->CJ_VEND5='      '
    	TMP1->CK_PRCVEN := ROUND((cCusto/(1-((SB1->B1_COMIS/100)*(1+(cMC*nFator2/100))))*(1+(cMC*nFator2/100)))/(1-((1.65+7.60+cIcms)/100)),2)
	  cComis:="/Rp1:4/Rp2:0/" 
	  ELSE
	    IF  M->CJ_VEND<>'000001' .AND. M->CJ_VEND5<>'      '
          TMP1->CK_PRCVEN := ROUND((cCusto/(1-((SB1->B1_COMIS*2/100)*(1+(cMC*nFator2/100))))*(1+(cMC*nFator2/100)))/(1-((1.65+7.60+cIcms)/100)),2)
	      cComis:="/Rp1:4/Rp2:4/" 
	    else
	      TMP1->CK_PRCVEN := ROUND((cCusto/(1-((SB1->B1_COMIS*2/100)*(1+(cMC*nFator2/100))))*(1+(cMC*nFator2/100)))/(1-((1.65+7.60+cIcms)/100)),2)
	      cComis:="/Rp1:4/Rp2:4/" 
	    endif
	  ENDIF
	ENDIF    
	TMP1->CK_VALOR  := IIF(ReadVar()=='M->CK_PRCVEN', M->CK_PRCVEN, TMP1->CK_PRCVEN) * IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN)
	TMP1->CK_VALDESC  := 0
	TMP1->CK_DESCONT  := 0
	//PROD. ORIGEM: SK30MS0021/2105  CUSTO:     18,03 MC 30/ICMS 7/RP1 4/RP2 4 EST:    -9,00                                                                
   	TMP1->CK_FEELING:="CUSTO:" +transform(cCusto,"@e 999999.99") + "/ MC:"+transform(cMc,"@e 99")+"/ ICMS:"+transform(cIcms,"@e 99")+cComis+" Est: "+transform(u_retest(cProduto),"@e 99999.99")
    endif
     //
Case nFator=0 .and. nFator2=0 .and. nFator4=0 .and. nFator3>0
	if TMP1->CK_PRCVEN=0
	If SB1->(dbSeek(xFilial("SB1") + IIF(ReadVar()=='M->CK_PRODUTO', M->CK_PRODUTO, TMP1->CK_PRODUTO)))
	If !Empty(SB1->B1_VDANOR) .AND. !EMPTY(SB1->B1_TABELA) .and. len(SB1->B1_TABELA)>0
		TMP1->CK_PRCVEN   := ROUND(SB1->B1_VDANOR/VAL(SB1->B1_TABELA)*nFator3,2)
		TMP1->CK_VALOR    := IIF(ReadVar()=='M->CK_PRCVEN', M->CK_PRCVEN, TMP1->CK_PRCVEN) * IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN)
		TMP1->CK_VALDESC  := 0
		TMP1->CK_DESCONT  := 0 
	   	TMP1->CK_FEELING:=" Est: "+transform(u_retest(cProduto),"@e 99999.99")
	Else
	    lRet := .F.
	EndIf
	EnDIf
	endif  

Case nFator=0 .and. nFator2=0 .and. nFator3=0  .and. nFator4<>0
	
		TMP1->CK_PRCVEN := ROUND(IIF(ReadVar()=='M->CK_PRCVEN', M->CK_PRCVEN, TMP1->CK_PRCVEN)*nFator4,2)
		TMP1->CK_VALOR  := IIF(ReadVar()=='M->CK_PRCVEN', M->CK_PRCVEN, TMP1->CK_PRCVEN) * IIF(ReadVar()=='M->CK_QTDVEN', M->CK_QTDVEN, TMP1->CK_QTDVEN)
		M->CJ_TOTAL:=M->CJ_TOTAL+TMP1->CK_VALOR
		TMP1->CK_VALDESC  := 0
		TMP1->CK_DESCONT  := 0
        TMP1->CK_FEELING:=" Est: "+transform(u_retest(cProduto),"@e 99999.99")
OtherWise
	TMP1->CK_PRCVEN   := 0
	TMP1->CK_VALOR    := 0
	TMP1->CK_VALDESC  := 0
	TMP1->CK_DESCONT  := 0
    TMP1->CK_FEELING  :=" Est: "+transform(u_retest(cProduto),"@e 99999.99")
    TMP1->CK_PRCVEN   := 0
EndCase


RestArea(aArea)
RestArea(aAreaSCJ)
RestArea(aAreaSCK)
RestArea(aAreaPA7)
RestArea(aAreaSB2)
RestArea(aAreaSB1)

Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³retest    ³   robson bueno da silva       ³ Data ³21.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ retorna o saldo real de estoque com base no codigo informad³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Funcao para ficar no Valid do CK_Produto                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RetEst(cCodigo)
Local aArea 	:= ( GetArea() )
Local aAreaSCJ 	:= SCJ->( GetArea() )
Local aAreaSCK 	:= SCK->( GetArea() )
Local aAreaPA7 	:= PA7->( GetArea() )
Local aAreaSB2 	:= SB2->( GetArea() )
Local aAreaSB1 	:= SB1->( GetArea() )
Local cQuerySC6
Local cQuerySCK
Local cQuerySd1
Local cQuerySC7
Local cAliasSd1:="SD1"
Local nEstFis
Local cCliente
local nEntra15:=0
local nEntra01:=0
local nContador:=1
local cIndice
local cPedRef
Local aVdaPend:=0 
Local cAm1
Local cAm2
Local cAm3
Local cAm4
Local cAm5
Local cAm6
Local nPoder3:=0
Local nCasada:=0
Local nEstVir:=0
Local nEstFis:=0 
Local cCli  
lOCAL nSDOCAS:=0
DbSelectArea("SB2")
dbSetOrder(1)
MsSeek(xfilial("SB2")+cCodigo)
While ( !Eof() .And. SB2->B2_COD == cCodigo )
    IF SB2->B2_STATUS<>"2"
      nEstfis:=nEstfis+SB2->B2_QATU+SB2->B2_QNPT
	ENDIF
	dbSkip()
EndDo
aVdaPend:={}
cQuerySC6 := "SELECT SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO,SC6.C6_TES,SC6.C6_QTDVEN,SC6.C6_QTDENT,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_LOCAL," 
cQuerySC6 += "SC6.C6_PRCVEN,SC6.C6_ENTREG,SC6.C6_NOTA,SC6.C6_DATFAT FROM " + RetSqlName("SC6")+ " SC6 " 
cQuerySC6 += "WHERE "
cQuerySC6 += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
cQuerySC6 += "SC6.C6_PRODUTO = '"+cCodigo+"' AND "
cQuerySc6 += "SC6.C6_QTDVEN-SC6.C6_QTDENT>0 AND "
cQuerySC6 += "SC6.D_E_L_E_T_=' ' ORDER BY SC6.C6_ENTREG DESC"
//cQuery := ChangeQuery(cQuery)
If ( Select ("QSC6") <> 0 )
			dbSelectArea ("QSC6")
			dbCloseArea ()
Endif
dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySC6),"QSC6",.T.,.T.)
dbSelectArea("QSC6")
nEntra15:=0
nEntra01:=0
nContador:=0
While ( !Eof() .And. QSC6->C6_PRODUTO == cCodigo )
  // precisa verificar empenhO pela tes
  if Posicione("SF4",1,xFilial("SF4")+QSC6->C6_TES,"F4_DUPLIC")="S" .OR. SUBSTR(QSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QSC6->C6_NUM,1,1)="D" .OR. SUBSTR(QSC6->C6_NUM,1,1)="T" .OR. SUBSTR(QSC6->C6_NUM,1,1)="R" .OR. SUBSTR(QSC6->C6_NUM,1,1)="A" .OR. QSC6->C6_TES="514" .OR. QSC6->C6_TES="999" .OR. QSC6->C6_TES="693" .OR. QSC6->C6_TES="553" .OR. QSC6->C6_TES="592" .OR. QSC6->C6_TES="556" 
    nEstfis:=nEstfis-(QSC6->C6_QTDVEN-QSC6->C6_QTDENT)
    IF SUBSTR(QSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QSC6->C6_NUM,1,1)="D"
    ELSE
    ENDIF
    IF SUBSTR(QSC6->C6_NUM,1,1)="B" 
      cIndice:="OS"
      cPedRef:="0"+SUBSTR(QSC6->C6_NUM,2,5)
    ELSE  
      cIndice:="PV"
      cPedRef:=QSC6->C6_NUM
    ENDIF  
    if nContador<=GETMV("MV_RAP001")
    IF QSC6->C6_QTDVEN-QSC6->C6_QTDENT>0  
      DbSelectArea("SZK")
      dbSetOrder(1)
      //if Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_OC")<>"      " 
      IF MsSeek(xfilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM)
       cAm1:=SZK->ZK_OC 
       cAm2:=SZK->ZK_ITEM
       cAm3:=SZK->ZK_FORN
       cAm4:=SZK->ZK_TIPO2 
       cAm5:=SZK->ZK_STATUS 
       cAm6:=SZK->ZK_QTS
       dbSelectArea("QSC6")
       IF cAm5<>"4" .AND. cAm4="OC"  
         nSdoCas:=nSdoCas + cAm6 
       ENDIF
       IF cAm5<>"4" .AND. cAm4="OS"
         IF cAm6>0 .AND. cAm6>QSC6->C6_QTDVEN-QSC6->C6_QTDENT 
           nEstfis:=nEstfis+QSC6->C6_QTDVEN-QSC6->C6_QTDENT
         else
           nEstfis:=nEstfis+cAm6
         endif
       endif
       if QSC6->C6_LOCAL='15'
         nEntra15:=nEntra15+cAm6
       else  
         nEntra01:=nEntra01+cAm6
       endif
     else
       dbSelectArea("QSC6")
     endif
    else
     if cCli="      "
       nContador:=nContador+1
     else 
       if cCli=QSC6->C6_CLI   
         nContador:=nContador+1
       ENDIF
     ENDIF  
    ENDIF
    Endif
  ENDIF
  dbSkip()
EndDo
dbSelectArea("QSC6")
QSC6->(DbCloseArea())
//CARREGA SALDOS POR ALMOXARIFADO SUBTRAINDO SALDOS DOS PEDIDOS SE ESTOQUE
DBSELECTAREA("SB6")
DBSETORDER(1)                                                                                                          
	If SB6->(DbSeek(xFilial("SB6")+cCodigo))
	While xFilial("SB6") == SB6->B6_FILIAL .and. ! SZB->(Eof()) .and. SB6->B6_PRODUTO == cCodigo  
		If SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="E" 
	      // ACERTANDO A SITUACAO DE DEPOSITO FECHADO CARMAR (NAO SUBTRAI ESTOQUE)
		  IF (SB6->B6_CLIFOR='000090' .OR. SB6->B6_CLIFOR='000669') .AND. SB6->B6_tpcf='C'
		    IF SB6->B6_PODER3='R'
		      nPoder3:=nPoder3+SB6->B6_SALDO
		    ENDIF
		  ELSE
		    // DEMAIS SITUACOES DA ANALISE 
		    // SITUACOES EM QUE MANDO PARA BENEFICIAR FORA (SUBTRAI ESTOQUE)
		    IF SB6->B6_tpcf='F' .AND. SB6->B6_PODER3='R'
		        nEstfis:=nEstfis-SB6->B6_SALDO
		        nPoder3:=nPoder3+SB6->B6_SALDO
		    ENDIF
		    // SITUACOES EM QUE EXISTE REMESSA EM CONSIGNACAO INDUSTRIAL (SUBTRAI ESTOQUE)
		    IF SB6->B6_tpcf='C' .AND. SB6->B6_PODER3='R'
		      nEstfis:=nEstfis-SB6->B6_SALDO
		      nPoder3:=nPoder3+SB6->B6_SALDO
		    ENDIF
		  ENDIF
		ENDIF
		IF SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="D" .AND. SB6->B6_tpcf='C'
		  nEstfis:=nEstfis-SB6->B6_SALDO
		  
		ELSE
		  IF SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="D"
		    
		  ENDIF
		ENDIF  
		SB6->(DbSkip())
	EndDo 
ENDIF

// ABATENDO DAS COMPRRAS PENDENTES AS COMPRAS CASADAS E ATUALIZANDO SALDOS EM ESTOQUE
if nSdoCas>0
  nEstVir:=nEstVir-nSdoCas
  nCasada:=nSdoCas
  // CUIDADO COM ESTA OPERACAO, O INVENTARIO PODE FICAR DOIDO
  nEstFis:=nEstFis+nSdoCas
endif
RestArea(aArea)
RestArea(aAreaSCJ)
RestArea(aAreaSCK)
RestArea(aAreaPA7)
RestArea(aAreaSB2)
RestArea(aAreaSB1)

return (nEstFis)

