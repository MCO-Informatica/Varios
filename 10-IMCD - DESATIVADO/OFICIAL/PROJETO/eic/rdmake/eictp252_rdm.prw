#include "protheus.ch"
#define CRLF chr(13)+chr(10)

Static nTotEmb

User Function EICTP252

	Local xRet   := NIL
	Local cParam := ""
	Local aMyTPC := {}   
	Local cMsgErr := ""
	Local bMsg  := {|msg| cMsgErr += IF(!Empty(cMsgErr),CRLF,"")+msg }
	Local nFobVal := 1
	Local lFreteInc := .F.    
	Local nPar  := 1

	IF Type("ParamIXB") == "C" 
		cParam := Upper(Alltrim(ParamIXB)) 
	Elseif Type("ParamIXB") == "A" .And. Type("ParamIXB[1]") == "C"
		cParam := Upper(Alltrim(ParamIXB[1])) 
	Endif      

	Begin Sequence

		Do Case        
			Case cParam == "TPCCARGA_INICIO"    
			// Iniciar carga da tabela
			nTotEmb := 0

			Case cParam == "APOS_AEVAL_TPC2"
			/*
			IF Type("lAvFluxo") == "L" .And. lAvFluxo
			IF cAliasRdm == "SW7"
			SW2->(dbSetOrder(1))
			SW2->(dbSeek(xFilial()+SW6->W6_PO_NUM))
			lFreteInc := (SW2->W2_FREINC == "1")
			Else
			lFreteInc := (SW2->W2_FREINC == "1")
			Endif        

			IF lFreteInc
			Del102WorkTP()
			Endif
			Endif
			*/

			Case cParam == "APOS_AEVAL_TPC1"
			/*
			IF Type("lAvFluxo") == "L" .And. lAvFluxo
			IF cAliasRdm == "SW7"
			SW2->(dbSetOrder(1))
			SW2->(dbSeek(xFilial()+SW6->W6_PO_NUM))
			lFreteInc := (SW2->W2_FREINC == "1")
			Else
			lFreteInc := (SW2->W2_FREINC == "1")
			Endif        

			IF lFreteInc
			Del102WorkTP()
			Endif
			Endif
			*/

			Case cParam == "APOS_GRAVA_WORKTP"
			IF Type("lAvFluxo") == "L" .And. lAvFluxo .And. ZPDesp == "102"
				IF cAliasRDM == "SW7"
					SW2->(dbSetOrder(1))
					SW2->(dbSeek(xFilial()+SW6->W6_PO_NUM))
					lFreteInc := (SW2->W2_FREINC == "1")
				Else
					lFreteInc := (SW2->W2_FREINC == "1")
				Endif        

				IF lFreteInc
					WorkTP->WKVL_PAGTO := 0
					WorkTP->WKVLPAGTO2 := 0
					WorkTP->(dbDelete())
				Endif
			Endif

			Case cParam == "TPCCALCULO_CALCDESP"
			cCodDesp := ParamIXB[2]      
			cDesDesp := Posicione("SYB",1,xFilial("SYB")+cCodDesp,"YB_DESCR")
			cTipDesp := Posicione("SWI",1,xFilial("SWI")+cTabela+cCodDesp,"WI_IDVL")

			nQtdC20   := 0
			nQtdC40   := 0
			nQtdC40H  := 0
			nQtdCOut  := 0         

			IF cTipDesp == "9" // Calcular por Container....         
				IF cAlias == "SW7"
					IF SW6->(EMPTY(W6_CONTA20+W6_CONTA40+W6_CON40HC+W6_OUTROS))         
						Eval(bMsg,"Os campos de Qtde de Container não foram preenchidos no processo, impossivel calcular valor previsto para a despesa "+cCodDesp+" "+cDesDesp+".")
					Else
						nQtdC20  := SW6->W6_CONTA20
						nQtdC40  := SW6->W6_CONTA40
						nQtdC40H := SW6->W6_CON40HC
						nQtdCOut := SW6->W6_OUTROS
					Endif
					nFobVal := SW6->W6_FOB_TOT             
					//nRateio := (SW7->W7_QTDE*SW7->W7_PRECO)/nFobVal
					nRateio := (SW7->W7_QTDE*SW7->W7_PRECO)/GetTotEmb(SW7->W7_HAWB)
				Else
					IF SW2->(EMPTY(W2_CONTA20+W2_CONTA40+W2_CON40HC+W2_OUTROS))         
						Eval(bMsg,"Os campos de Qtde de Container não foram preenchidos no PO, impossivel calcular valor previsto para a despesa "+cCodDesp+" "+cDesDesp+".")
					Else
						nQtdC20  := SW2->W2_CONTA20
						nQtdC40  := SW2->W2_CONTA40
						nQtdC40H := SW2->W2_CON40HC
						nQtdCOut := SW2->W2_OUTROS
					Endif
					nFobVal := nValFobTot
					nRateio := (Work_1->WKQTD_ACU*Work_1->WKFOB_UNT)/nFobVal
				Endif  

				IF nQtdC20 > 0 .And. SWI->WI_ZVL20 = 0
					Eval(bMsg,"Não foi informado o valor previsto por Container 20' da despesa "+cCodDesp+" "+cDesDesp+" na tabela de pre-calculo "+cTabela)
				Endif
				IF nQtdC40 > 0 .And. SWI->WI_ZVL40 = 0
					Eval(bMsg,"Não foi informado o valor previsto por Container 40' da despesa "+cCodDesp+" "+cDesDesp+" na tabela de pre-calculo "+cTabela)
				Endif
				IF nQtdC40H > 0 .And. SWI->WI_ZVL40H = 0
					Eval(bMsg,"Não foi informado o valor previsto por Container 40' HC da despesa "+cCodDesp+" "+cDesDesp+" na tabela de pre-calculo "+cTabela)
				Endif
				IF nQtdCOut > 0 .And. SWI->WI_ZVLOUT = 0
					Eval(bMsg,"Não foi informado o valor previsto por Container 'Outros' da despesa "+cCodDesp+" "+cDesDesp+" na tabela de pre-calculo "+cTabela)
				Endif

				MVl_Pagto := 0

				IF ! Empty(cMsgErr)
					EECVIEW(cMsgErr)
				Endif

				//nRateio := (SW3->W3_QTDE*SW3->W3_PRECO)/nValFobTot
				//nRateio := (Work_1->WKQTD_ACU*Work_1->WKFOB_UNT)/nFobVal
				IF Type("Paridade") <> "N" .Or. Empty(Paridade) .Or. Paridade = 1
					nPar := BuscaTaxa(SWI->WI_MOEDA,dDataBase,.T.,.F.,.T.)
				Else 
					nPar := Paridade
				Endif

				MVl_Pagto += nQtdC20*SWI->WI_ZVL20
				MVl_Pagto += nQtdC40*SWI->WI_ZVL40
				MVl_Pagto += nQtdC40H*SWI->WI_ZVL40H
				MVl_Pagto += nQtdCOut*SWI->WI_ZVLOUT
				MVl_Pagto := MVl_Pagto*nPar*nRateio
			Endif	                                    

		End case
	End Sequence

Return xRet

//----------------------------------------------------------	     
Static Function Del102WorkTP
	Local nRec := WorkTP->(Recno())

	Begin Sequence
		WorkTP->(dbGoTop())
		While WorkTP->(!Eof())
			IF WorkTP->WKDESPESA == "102"
				WorkTP->(dbDelete())
			Endif
			WorkTP->(dbSkip())
		Enddo
	End Sequence

	WorkTP->(dbGoTo(nRec))

Return NIL	     

//----------------------------------------------------------	     
Static Function GetTotEmb(cProc)

	Local aArea := SW7->(GetArea())
	Local nTot  := 0

	Begin Sequence
		IF Valtype(nTotEmb) == "N" .And. nTotEmb > 0
			Break
		Endif

		SW7->(dbSetOrder(1))   
		SW7->(dbSeek(xFilial()+cProc))
		While SW7->(!Eof() .And. W7_FILIAL == xFilial("SW7") .And. W7_HAWB == cProc)
			if SW7->W7_SEQ <> 0
				SW7->(dbSkip())
				Loop
			Endif

			nTot += (SW7->W7_QTDE*SW7->W7_PRECO)   

			SW7->(dbSkip())
		Enddo

		nTotEmb := nTot

	End Sequence

	SW7->(RestArea(aArea))

Return nTotEmb
