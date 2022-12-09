#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

//==================================================================================
// Programa.....: RJOB01
// Autor........: Anderson Goncalves
// Data.........: 09/09/21
// Descricao....: Job para bloqueio de pedido de vendas por alteracao de tabela de 
//                preço
// Uso..........: Verquimica
//==================================================================================

User Function RJOB01()

//===============================================
// Variaveis da Rotina
//===============================================
Local cQuery        := Nil
Local aTabela       := {}
Local cTabela       := ""
Local nTabela       := 0
Local nZ03ValCal    := 0
Local nSe4Indice    := 1
Local nSa1Indice    := 0
Private aHeader 

//=============================================
// Inicialização do ambiente
//=============================================
RpcSetType(3)   
RpcSetEnv("01","01")

Conout("**** Executando alteracao tabela de precos ****")
Conout("Data: "+TransForm(Date(),"@D")+" Hora: "+Time() )

dbSelectArea("SC5")
SC5->(dbSetOrder(1))

dbSelectArea("SC6")
SC6->(dbSetOrder(1))

dbSelectArea("Z02")
Z02->(dbSetOrder(1))

dbSelectArea("Z03")
Z03->(dbSetOrder(2))

dbSelectArea("SE4")
SE4->(dbSetOrder(1))

dbSelectArea("SA1")
SA1->(dbSetOrder(1))

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

//==============================================
// Seleciona os registros
//==============================================
cQuery := "SELECT SC6.R_E_C_N_O_ RECSC6 FROM "+RetSqlName("SC6") + " SC6 (NOLOCK),  "+RetSqlName("SC5") + " SC5 (NOLOCK) "
cQuery += "WHERE C5_FILIAL = '" + FWxFilial("SC5") + "' "
cQuery += "AND C5_EMISSAO >= '20210831' "
cQuery += "AND SC5.D_E_L_E_T_ = ' ' "
cQuery += "AND C6_FILIAL = C5_FILIAL "
cQuery += "AND C6_NUM = C5_NUM "
cQuery += "AND C6_ENTREG >= '"+dtos(DataValida(Date()+2))+"' "
cQuery += "AND C6_QTDVEN - C6_QTDENT > 0 "
cQuery += "AND C6_NOTA = ' ' "
cQuery += "AND C6_BLQ <> 'R' "
cQuery += "AND SC6.D_E_L_E_T_ = ' ' "

U_FinalArea("QUERY")
TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())

While QUERY->(!EOF())

    SC6->(dbGoTo(QUERY->RECSC6))
    SC5->(dbSeek(FWxFilial("SC5")+SC6->C6_NUM ))

    aTabela := {}
	If Z02->(DbSeek(xFilial("Z02")+SC6->C6_PRODUTO))
		cTabela := "A"
		For nTabela := 1 To 5
			If Z03->(DbSeek(xFilial("Z03")+SC6->C6_PRODUTO+Z02->Z02_REVISA+cTabela))
				nZ03ValCal := 0
				nSe4Indice := 1
				nSa1Indice := 0
				If SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
					If SE4->E4_VQ_INDI > 0
						nSe4Indice := SE4->E4_VQ_INDI
					EndIf
				EndIf
				If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
					If SA1->A1_VQ_CMAD > 0
						nSa1Indice := SA1->A1_VQ_CMAD
					EndIf
				EndIf

				//==========================================
                // Devolve o valor da tabela
                //==========================================
				nZ03ValCal := CfmVal2Cal(cTabela,nSe4Indice,nSa1Indice)
				AAdd(aTabela, {	cTabela,Round(nZ03ValCal,2)})
			EndIf
			cTabela := Soma1(cTabela)
		Next
	EndIf

    //=================================================
    // Efetua o bloqueio
    //=================================================
    If Len(aTabela) > 0
		nPos := Ascan(aTabela,{|x| x[1] == SC6->C6_VQ_TABE})
        If SC6->C6_VQ_UNIT < aTabela[nPos,2]
            If !("41E|" $ SC5->C5_VQ_MOT)
                RecLock("SC5",.F.)	
                SC5->C5_VQ_MOT := AllTrim(SC5->C5_VQ_MOT) + "41E|"
                SC5->C5_BLQ := "1"
                SC5->(msUnlock())
                Conout("**** Pedido: "+SC6->C6_NUM)
                Conout("     Produto: "+SC6->C6_PRODUTO)
                Conout("     Valor Pedido: "+TransForm(SC6->C6_VQ_UNIT,"@E 999,999,999.99"))
                Conout("     Valor Tabela "+ aTabela[nPos,1]+": "+TransForm( aTabela[nPos,2],"@E 999,999,999.99"))
                Conout("     Executado em  "+TransForm(Date(),"@D")+" Hora: "+Time() )
                Conout("***********************************************************")
            EndIf
        EndIf
    EndIf
    
    QUERY->(dbSkip())

Enddo

RpcClearEnv()

Return NIL

//==================================================================================
// Programa.....: CfmVal2Cal
// Autor........: Anderson Goncalves
// Data.........: 09/09/21
// Descricao....: Coleta preços da tabela
// Uso..........: Verquimica
//==================================================================================

Static Function CfmVal2Cal(cTabela,nSe4Indice,nSa1Indice)

//=========================================
// Variaveis da Rotina
//=========================================
Local cRetValCl     := 0
Local aParamCst     := {}
Local aRetCusto     := {}
Local nValFrete     := 0
Local nFatorFret    := 1
Local nZ03FreEnt    := 0
Local nX            := 0
Local aAreaC6		:= {}

Local nIcmsCliVq    := 18   // Icms Padrao da Tabela

Local _nPisCliVq    := 0
Local _nCofCliVq    := 0

Local aAreaZ02      := Z01->(GetArea())
Local aAreaZ03      := Z03->(GetArea())
Local aAreaSb1      := SB1->(GetArea())

Local nPesoTot      := 0
Local nQtdEmb       := 0
Local cPedSC6		:= SC6->C6_NUM

dbSelectArea("Z02")
Z02->(dbSetOrder(1))

dbSelectArea("Z03")
Z03->(dbSetOrder(2))

aAreaC6 := SC6->(GetArea())

dbSelectArea("SC6")
SC6->(dbSetOrder(1))
SC6->(dbSeek(xFilial("SC6")+cPedSC6))
While SC6->(!EOF()) .and. FWxFilial("SC6")+cPedSC6 == SC6->C6_FILIAL+SC6->C6_NUM
	If !Empty(SC6->C6_PRODUTO)
		If SC6->C6_VQ_UM == "KG"
			nPesoTot += SC6->C6_VQ_QTDE
		Else
			nPesoTot += SC6->C6_VQ_QTDE * SC6->C6_VQ_DENS
		EndIf
		If AllTrim(SC6->C6_VQ_EM) != "03000"
			nQtdEmb += SC6->C6_VQ_QTDE / SC6->C6_VQ_CAPA
		EndIf
	EndIf
	SC6->(dbSkip())
Enddo

RestArea(aAreaC6)

//StaticCall(fGFrete,AjustaSx6)

//U_FGFRETE()


aIcmsAli := &(StrTran(StrTran(FormatIn(AllTrim(GetMv("VQ_ICMSALI")),"|"),"(","{"),")","}"))
aIcmsOri := &("{{'"+StrTran(StrTran(AllTrim(GetMv("VQ_ICMSORI")),"-","',"),"|","},{'")+"}}")

For nX := 1 To Len(aIcmsAli)
	If SubStr(aIcmsAli[nX],1,2) == SA1->A1_EST
		nIcmsCliVq := Val(SubStr(aIcmsAli[nX],3,2))
	EndIf
Next nX

If !Empty(SC6->C6_PRODUTO)

	Z02->(DbSeek(xFilial("Z02")+SC6->C6_PRODUTO))
	Z03->(DbSeek(xFilial("Z03")+SC6->C6_PRODUTO+Z02->Z02_REVISA+cTabela))
	
	If Z02->Z02_UM == SC6->C6_VQ_UM .And. Z02->Z02_MOEDA == SC6->C6_VQ_MOED
		nZ03FreEnt := Z03->Z03_FREENT
	Else
		nZ03FreEnt := Z03->Z03_FREENT
	EndIf

	nIcmsCliVq := SC6->C6_VQ_PICM
	_nPisCliVq := SC6->C6_VQ_PPIS
	_nCofCliVq := SC6->C6_VQ_PCOF

	SB1->(dbSeek(xFilial("SB1")+Z02->Z02_CODEM))
	
	nFatorFret := If( SC5->C5_VOLUME1 <=1 .and. SB1->B1_VQ_FRT2=="S",2,1 )
	
	//============================================
	// V=Verquimica - N=Normal 
	//============================================
	If SC5->C5_VQ_FRET == "V" .and. SC5->C5_VQ_FVER == "N"
		nValFrete := nZ03FreEnt * nFatorFret
		
    //============================================
	// V=Verquimica - N=Negociada Retira 
	//============================================
	ElseIf SC5->C5_VQ_FRET == "V" .and. SC5->C5_VQ_FVER == "R"
		nValFrete := (SC5->C5_VQ_FVAL / nPesoTot) * 1000
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * SC6->C6_VQ_DENS
		EndIf
		If Z02->Z02_MOEDA == "2"
			nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
			nValFrete := nValFrete / nVqTaxaM2
		EndIf
	
	//============================================
	// V=Verquimica - D=Negociada Redespacho 
	//============================================
	ElseIf  SC5->C5_VQ_FRET == "V" .and. SC5->C5_VQ_FVER == "D"
		nValFrete := (SC5->C5_VQ_FVAL / nPesoTot) * 1000
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * SC6->C6_VQ_DENS
		EndIf
		If Z02->Z02_MOEDA == "2"
			nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
			nValFrete := nValFrete / nVqTaxaM2
		EndIf
		nValFrete += (nZ03FreEnt * nFatorFret)
		
	//============================================
	// C=Cliente - R=Retira   
	//============================================
	ElseIf SC5->C5_VQ_FRET == "C" .and. SC5->C5_VQ_FCLI == "R"
		nValFrete := 0

	//============================================
	// C=Cliente - D= Redespacho  
	//============================================
    ElseIf  SC5->C5_VQ_FRET == "C" .and. SC5->C5_VQ_FCLI == "D"
		nValFrete := nZ03FreEnt * nFatorFret
	EndIf
	
	If SC6->C6_UM == SC6->C6_VQ_UM
		lTrocaUm := .F.
	Else
		lTrocaUm := .T.
	EndIf
	
	lTrocaMo := .F.

	aParamCst := {}
	Aadd(aParamCst,SC6->C6_PRODUTO)	    // Produto
	Aadd(aParamCst,SC6->C6_VQ_MOED)	    // Moeda
	Aadd(aParamCst,SC6->C6_VQ_UM)	    // Unidade de Medida
	Aadd(aParamCst,cTabela)				// Tabela de Preco
	Aadd(aParamCst,nValFrete)			// Valor do Frete
	Aadd(aParamCst,SC6->C6_VQ_QTDE)	    // Quantidade - Calc.
	Aadd(aParamCst,SC6->C6_PRCVEN)	    // Valor Unitario Digitado
	Aadd(aParamCst,lTrocaUm)			// Troca UM
	Aadd(aParamCst,lTrocaMo)            // Troca Mo
	Aadd(aParamCst,nIcmsCliVq)			// Icms Cliente
	Aadd(aParamCst,nSe4Indice)			// Indice Cond. Pagamento
	Aadd(aParamCst,nSa1Indice)			// Indice Cliente
	
	Aadd(aParamCst,_nPisCliVq)			// Pis
	Aadd(aParamCst,_nCofCliVq)			// Cofins

	aRetCusto := U_fCfmCusto(aParamCst)
	
	cRetValCl  := aRetCusto[1] // Valor Tabela
	
EndIf

Z02->(RestArea(aAreaZ02))
Z03->(RestArea(aAreaZ03))
SB1->(RestArea(aAreaSb1))

Return(cRetValCl)

