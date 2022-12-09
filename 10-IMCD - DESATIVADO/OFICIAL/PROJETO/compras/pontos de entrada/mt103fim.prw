#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³Junior Carvalho     º Data ³  29/07/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para transformar o Valor do documento de entrada em QTD º±±
±±º          ³ Ja entregue no Pedido de Compra                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT103FIM()

Local nOpcao 	:= PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE 1 /
LOCAL aArea 	:= GetArea()
Local cProdServ := SuperGetMV("ES_PRDSERV", ,"SV9910010000003")
Local cProd		:= ' '
Local cPedido	:= ' '
Local cItemPC	:= ' '
Local nVlrTot	:= 0
Local nQuant	:= 0
Local lRet		:= .T.
Local cTes
Local lPrdContr := .F.
Local lQtdNf := .F.
Local nX := 0

if !(isincallstack("EICDI158"))  .and. !(isincallstack("EICDI154"))
	
	IF nConfirma == 1 //
		aB1 := SB1->(GETAREA())
		aD1 := SD1->(GETAREA())
		aF1	:= SF1->(GETAREA())
		aD2 := SD2->(GETAREA())
		aF2	:= SF2->(GETAREA())
		aD7	:= SD7->(GETAREA())
		aN1 := SN1->(GetArea())
		aN3 := SN3->(GetArea())
		aF4 := SF4->(GetArea())
		
		
		IF nOpcao == 5 //EXCLUSÃO
			
			IF SF1->F1_FORMUL == 'S' .and. cEmpAnt $ '02'
				U_GravaZF1(SF1->F1_DOC,SF1->F1_SERIE,'E',"X",SF1->F1_FORNECE, SF1->F1_LOJA,'')
			Endif
			
			For nX := 1 To Len(aCols)
				
				cProd	:= Alltrim(aCols[nX,GDFIELDPOS("D1_COD")])
				cPedido	:= Alltrim(aCols[nX,GDFIELDPOS("D1_PEDIDO")])
				cItemPC	:= Alltrim(aCols[nX,GDFIELDPOS("D1_ITEMPC")])
				nVlrTot	:= aCols[nX,GDFIELDPOS("D1_TOTAL")]
				nQuant	:= aCols[nX,GDFIELDPOS("D1_QUANT")]
				
				
				IF cProd $ cProdServ
					dbSelectArea("SC7")
					dbSetOrder(1)
					if MsSeek(xFilial("SC7")+cPedido+cItemPC)
						If SC7->C7_PRODUTO == cProd
							IF nOpcao == 5 // EXCLUSAO
								RecLock("SC7",.F.)
								SC7->C7_QUJE := SC7->C7_QUJE + nQuant - nVlrTot
								MsUnlock()
								lRet := .T.
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		
		// Funcao para gravar no ativo fixo o item contabil
		DbSelectArea("SF1")
		If SF1->F1_TIPO == "N" .AND. (nOpcao == 3 .OR. nOpcao == 4 )
			
			cEspec:= SF1->F1_ESPECIE
			cDoc  := SF1->F1_FILIAL + SF1->F1_DOC+SF1->F1_SERIE + SF1->F1_FORNECE+SF1->F1_LOJA
			
			//IIF(SELECT("TRBTR")>0,TRBTR->(DBCLOSEAREA()),NIL)
			/*cQuery := "SELECT SD1.D1_FILIAL, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_COD,SD1.D1_ITEM, SD1.D1_XITEMCT, SD1.D1_TES  FROM " + RETSQLNAME("SD1")  + " SD1, " + RETSQLNAME("SF1") + " SF1 "
			cQuery += "WHERE SD1.D1_FILIAL||SD1.D1_DOC||SD1.D1_SERIE||SD1.D1_FORNECE||SD1.D1_LOJA =  '" + cDoc + "'"
			cQuery += "AND SD1.D_E_L_E_T_ = ' ' AND SF1.D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery( cQuery )
			DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T.)
			*/
			DbSelectArea("SD1")
			DbSetOrder(1)
			If DbSeek(xfilial("SD1") + SF1->F1_DOC+SF1->F1_SERIE + SF1->F1_FORNECE+SF1->F1_LOJA)
				
				WHILE  !Eof() .and. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA =  cDoc
					cTes := sd1->D1_TES
					cNfatf := SD1->D1_FORNECE+SD1->D1_LOJA+CESPEC+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_ITEM
					DbSelectArea("SF4")
					DbSetOrder(1)
					If DbSeek(xfilial("SF4") + ctes)
						if SF4->F4_ATUATF == 'S'
							DbSelectArea("SN1")
							DbSetOrder(8)
							//If DbSeek(xfilial("SN1")+ sd1->d1_fornece+sd1->d1_loja+cEspec+sd1->d1_doc+sd1->d1_serie+sd1->d1_item)
							If DbSeek(xfilial("SN1")+ cNfatf)
								While sn1->n1_filial + sn1->n1_fornec+sn1->n1_loja+sn1->n1_nfespec+sn1->n1_nfiscal+sn1->n1_nserie+sn1->n1_nfitem ==  xfilial("SN1")+cNfatf .and. !eof()
									cAtivo := SN1->N1_CBASE + N1_ITEM
									DbSelectArea("SN3")
									DbSetOrder(1)
									If DbSeek(xfilial("SN3")+ cAtivo)
										RecLock("SN3",.F.)
										sn3->n3_subccon := sd1->d1_xitemct
										sn3->n3_ccontab := " "
										MsUnLock()
									Endif
									DbSelectArea("SN1")
									DbSkip()
								Enddo
							Endif
						Endif
					Endif
					
					DbselectArea("SD1")
					DbSkip()
				Enddo
			Endif
			
			If cEmpAnt $ '02' .and.  ( nOpcao = 3 .or. nOpcao = 4)
				
				For nX := 1 To Len(aCols)
					cProd	:= Alltrim(aCols[nX,GDFIELDPOS("D1_COD")])
					nQtd	:= aCols[nX,GDFIELDPOS("D1_QUANT")]
					
					If nQtd > 0
						lQtdNf := .T.
					EndIf
					
					DBSELECTAREA( "SB1" )
					dbSetOrder(1)
					if MsSeek(xFilial("SB1")+cProd)
						IF SB1->B1_MINEXEC == 'S' .OR. SB1->B1_POLCIV == 'S' .OR. SB1->B1_POLFED == 'S'
							lPrdContr := .T.
						Endif
					endif
				Next Nx
				
				IF lPrdContr .and. SF1->F1_FORMUL == 'S' .AND. lQtdNf
					U_GravaZF1(SF1->F1_DOC,SF1->F1_SERIE,'E',"I",SF1->F1_FORNECE, SF1->F1_LOJA,'')
				Endif
				
			Endif
			
			//LUIZ GRAVAR DADOS DO SF1 NA TABELA SW6
			dbSelectArea("SW6")
			dbSetOrder(1)
			if MsSeek(xFilial("SW6")+SF1->F1_HAWB)
				If SF1->F1_TIPO_NF $ ("1","3","5")
					RecLock("SW6",.F.)
					SW6->W6_DT_ENTR = SF1->F1_DTDIGIT
					MsUnlock()
				EndIf
			EndIf
			
		ENDIF
		
		RestArea(aB1)
		RestArea(aD1)
		RestArea(aF1)
		RestArea(aN1)
		RestArea(aN3)
		RestArea(aF4)
	EndIf
	
	RestArea(aArea)
	
Endif

Return(Nil)
