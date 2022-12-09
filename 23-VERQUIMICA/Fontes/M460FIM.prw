#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: M460FIM   | Autor: Celso Ferrone Martins  | Data: 04/06/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE no fim do processo do documento de saida                |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function M460FIM()

Local aAreaSc5 := SC5->(GetArea())
Local aAreaSc6 := SC6->(GetArea())
Local aAreaSd2 := SD2->(GetArea())
Local aAreaSe1 := SE1->(GetArea())
Local aAreaSa1 := SA1->(GetArea())
Local aAreaSf2 := SF2->(GetArea())
Local aAreaSf4 := SF4->(GetArea())
Local aAreaZ04 := Z04->(GetArea())
Local aAreaSb1 := SB1->(GetArea())
Local aAreaSm2 := SM2->(GetArea())
Local aAreaSUA := SUA->(GetArea())

Local _cTipoCo := ""      
Local _cGrpVen := "      "
                            
DbSelectArea("SA1") ; DbSetOrder(1)
DbSelectArea("SB1") ; DbSetOrder(1)
DbSelectArea("SC5") ; DbSetOrder(1)
DbSelectArea("SC6") ; DbSetOrder(1)
DbSelectArea("SD2") ; DbSetOrder(3)
DbSelectArea("SE1") ; DbSetOrder(2)
DbSelectArea("SF2") ; DbSetOrder(1)
DbSelectArea("SF4") ; DbSetOrder(1)
DbSelectArea("SM2") ; DbSetOrder(1)
DbSelectArea("Z04") ; DbSetOrder(1)  

U_GRMETCLI(SF2->(F2_DOC+F2_SERIE))

If SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE)))
	
	If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))     
	 
		If SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))
			_cGrpVen := SA1->A1_GRPVEN
		EndIf

		RecLock("SF2",.F.)
		SF2->F2_VQ_FRET := SC5->C5_VQ_FRET
		SF2->F2_VQ_FCLI := SC5->C5_VQ_FCLI
		SF2->F2_VQ_FVER := SC5->C5_VQ_FVER
		SF2->F2_VQ_FVAL := SC5->C5_VQ_FVAL   
		SF2->F2_GRPVEN 	:= _cGrpVen          
		SF2->F2_VQ_FVRE := SC5->C5_VQ_FVRE		
		MsUnLock()

		_cTipoCo := SC5->C5_VQ_TPCO

		If SE1->(DbSeek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)))
		
			While !SE1->(Eof()) .And. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)
				
				RecLock("SE1",.F.)
				SE1->E1_VQ_TPCO := _cTipoCo
				SE1->(MsUnlock())
				
				SE1->(DbSkip())
			EndDo
		
		EndIf

	EndIf
	
	While !SD2->(Eof()) .And. SF2->(F2_DOC+F2_SERIE) == SD2->(D2_DOC+D2_SERIE)

		If SC6->(DbSeek(xFilial("SC6")+SD2->(D2_PEDIDO+D2_ITEMPV)))     
			
			Reclock("SD2",.F.)
			SD2->D2_VQ_QTDE := SC6->C6_VQ_QTDE
			SD2->D2_VQ_UNIT := SC6->C6_VQ_UNIT
			SD2->D2_VQ_TOTA := SC6->C6_VQ_TOTA
			SD2->D2_VQ_UM   := SC6->C6_VQ_UM
			SD2->D2_VQ_TABE := SC6->C6_VQ_TABE
			SD2->D2_VQ_VOLU := SC6->C6_VQ_VOLU
			SD2->(MsUnLock())

			If SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
				If SF4->F4_DUPLIC == "S" .And. !Empty(SF2->F2_VEND1)
					If  SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
						If SC6->C6_VQ_UM == "KG"
							nQtdSd2 := SD2->D2_QUANT
						Else
							nQtdSd2 := SD2->D2_QUANT/SB1->B1_CONV
						EndIf					
		
						nTxMoed2 := 1
		
						If SC6->C6_VQ_MOED == "2"
							If SM2->(DbSeek(dTos(SD2->D2_EMISSAO)))
								nTxMoed2 := SM2->M2_MOEDA2
							EndIf
						EndIf
		
						_nValTab := Round(SC6->C6_VQ_VAL *nTxMoed2, 2)
						_nValNot := Round(SD2->D2_VQ_UNIT*nTxMoed2, 2)
		
						If _nValTab != _nValNot 
		
							RecLock("Z04", .T.)
							Z04->Z04_FILIAL := xFilial("Z04")
							Z04->Z04_VENDED := SF2->F2_VEND1
							Z04->Z04_EMISSA := SF2->F2_EMISSAO
							Z04->Z04_DOC    := SF2->F2_DOC
							Z04->Z04_SERIE  := SF2->F2_SERIE
							Z04->Z04_TIPO   := SF2->F2_TIPO
							Z04->Z04_CLIENT := SF2->F2_CLIENTE
							Z04->Z04_LOJA   := SF2->F2_LOJA
							Z04->Z04_ITEM   := SD2->D2_ITEM
							Z04->Z04_COD    := SD2->D2_COD
							Z04->Z04_TABELA := SC6->C6_VQ_TABE
							Z04->Z04_UM     := SC6->C6_VQ_UM
							Z04->Z04_MOEDA  := SC6->C6_VQ_MOED
							Z04->Z04_QUANT  := nQtdSd2//SC6->C6_VQ_QTDE//SD2->D2_QUANT
							Z04->Z04_VALTAB := _nValTab
							Z04->Z04_VALNOT := _nValNot
							Z04->Z04_TIPODC := If(_nValTab > _nValNot, "D", "C")//If(SC6->C6_VQ_VAL > SC6->C6_PRCVEN, "D", "C")
							Z04->Z04_VALOR  := Abs(_nValTab-_nValNot)*nQtdSd2//SC6->C6_VQ_QTDE//Abs(SC6->C6_VQ_VAL-SC6->C6_PRCVEN)*SD2->D2_QUANT
							Z04->Z04_OBSERV := If(_nValTab > _nValNot, "DEBITO GERADO AUTOMATICAMENTE - M460FIM", "CREDITO GERADO AUTOMATICAMENTE - M460FIM")//If(SC6->C6_VQ_VAL > SC6->C6_PRCVEN, "DEBITO GERADO AUTOMATICAMENTE - M460FIM", "CREDITO GERADO AUTOMATICAMENTE - M460FIM")
							Z04->Z04_USER   := __cUserId
							Z04->Z04_DTLANC := Date()
							Z04->Z04_HRLANC := Time()
							Z04->Z04_STATUS := "V"
							Z04->Z04_REGIAO := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_REGIAO") //08/12/2014
							Z04->Z04_GRPVEN := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_GRPVEN") //08/12/2014
							Z04->(MsUnlock())

						EndIf
					EndIf
				EndIf
			EndIf			
		EndIf

		SD2->(DbSkip())

	EndDo
	
EndIf

//===================================================
// Por Anderson Goncalves em 30/04/21
// Ajusta Orçamento
cQuery := "SELECT DISTINCT D2_PEDIDO, UA_NUMSC5, UA_NUM, SUA.R_E_C_N_O_ RECSUA "
cQuery += "FROM "+RetSqlName("SD2")+" SD2 (NOLOCK), "+RetSqlName("SUA")+" SUA (NOLOCK) "
cQuery += "WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += "AND D2_DOC = '"+SF2->F2_DOC+"' "
cQuery += "AND D2_SERIE = '"+SF2->F2_SERIE+"' "
cQuery += "AND SD2.D_E_L_E_T_ = ' ' " 
cQuery += "AND UA_FILIAL = '"+xFilial("SUA")+"' "
cQuery += "AND UA_NUMSC5 = D2_PEDIDO "
cQuery += "AND SUA.D_E_L_E_T_ = ' ' "
U_FinalArea("QUERY")
TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())
While QUERY->(!EOF())
	dbSelectArea("SUA")
	SUA->(dbSetOrder(1))
	SUA->(dbGoTo(QUERY->RECSUA))
	If !Empty(SUA->UA_CANC) .or. SUA->UA_STATUS <> "NF."
		RecLock("SUA",.F.)
		SUA->UA_STATUS 	:= "NF."
		SUA->UA_CANC 	:= ""
		SUA->UA_CODCANC := ""
		SUA->UA_EMISNF 	:= dDataBase
		SUA->UA_SERIE 	:= SF2->F2_SERIE
		SUA->UA_DOC 	:= SF2->F2_DOC
		SUA->(msUnlock())
	EndIf
	QUERY->(dbSkip())
Enddo
U_FinalArea("QUERY")
//==================================== F I M ================================
// AJUSTA BLOQUEIO DE REGRA

cQuery := "SELECT ISNULL(D2_PEDIDO,'') PEDIDO FROM "+RetSqlname("SD2")+" (NOLOCK) "
cQuery += "WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += "AND D2_DOC = '"+SF2->F2_DOC+"' "
cQuery += "AND D2_SERIE = '"+SF2->F2_SERIE+"' "
cQuery += "AND D_E_L_E_T_ = ' ' " 

U_FinalArea("QUERY")
TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())
If !Empty(QUERY->PEDIDO)
	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+QUERY->PEDIDO))
		RecLock("SC5",.F.)
		SC5->C5_BLQ := " "
		SC5->(msUnlock())
	ENDIF
ENDIF
U_FinalArea("QUERY")

//==============================================
// Verifica FCICOD
//==============================================
dbSelectArea("SD2")
SD2->(dbSetOrder(1))

dbSelectArea("SC6")
SC6->(dbSetOrder(1)) //C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

cQuery := "SELECT R_E_C_N_O_ RECSD2 FROM "+RetSqlname("SD2")+" (NOLOCK) "
cQuery += "WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += "AND D2_DOC = '"+SF2->F2_DOC+"' "
cQuery += "AND D2_SERIE = '"+SF2->F2_SERIE+"' "
cQuery += "AND D_E_L_E_T_ = ' ' " 
U_FinalArea("QUERY")
TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())
While QUERY->(!EOF())

	SD2->(dbGoTo(QUERY->RECSD2))
	If Empty(SD2->D2_LOTECTL)
		RecLock("SD2",.F.)
		SD2->D2_FCICOD	:=	POSICIONE("SD1",26,xFilial("SD1")+SD2->D2_LOTECTL,"D1_FCICOD")                                        
		SD2->(msUnLock())
	EndIf

	If SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_COD+SD2->D2_ITEMPV ))
		If Empty(SC6->C6_FCICOD) .and. !Empty(SD2->D2_FCICOD)  
			RecLock("SC6",.F.)
			SC6->C6_FCICOD	:=	SD2->D2_FCICOD                                    
			SC6->(msUnLock())
		EndIf
	EndIf
	QUERY->(dbSkip())

Enddo
U_FinalArea("QUERY")

SC5->(RestArea(aAreaSc5))
SC6->(RestArea(aAreaSc6))
SD2->(RestArea(aAreaSd2))
SE1->(RestArea(aAreaSe1))
SA1->(RestArea(aAreaSa1))
SF2->(RestArea(aAreaSf2))
SF4->(RestArea(aAreaSf4))
Z04->(RestArea(aAreaZ04))
SB1->(RestArea(aAreaSb1))
SM2->(RestArea(aAreaSm2))
SUA->(RestArea(aAreaSUA))

Return()
