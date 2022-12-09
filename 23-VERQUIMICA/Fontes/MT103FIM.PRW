#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "colors.CH"
#Include "font.CH"
#include "Fileio.ch"
#Include "Report.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³Elias Reis          º Data ³01/03/2018   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto no final da rotina, para o usuario completar algum    º±±
±±º          ³processo                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Verquimica       ALVES                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT103FIM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea     	:= GetArea()
Local aAreaSE2  	:= SE2->(Getarea())
Local aAreaSED  	:= SED->(Getarea())
Local aAreaSF1  	:= SF1->(Getarea())
Local aAreaSD1  	:= SD1->(Getarea())
Local aAreaSFT  	:= SFT->(Getarea())
Local aAreaSCR		:= SCR->(Getarea())
Local lCenXml   	:= IsInCallStack("U_CENTNFEXM")
Local cContaPad 	:= "" 
Local cPedido		:= ""
Local dDtEmissao	:= ctod("  /  /  ")
Local lPerguntou	:= .F.
Local lExecuta		:= .F.
Local aRecSC7Aux	:= {}
Local lConsEIC 		:= SuperGetMV("MV_ELREIC",.F.,.T.)

If ( !INCLUI .AND. !ALTERA .AND. !lCenXml)
	Return nil
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³posiciona nas tabelas usadas                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)//B1_FILIAL+B1_COD

dbSelectArea("SFT")
dbSetOrder(1)//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO

dbSelectArea("SE2")
dbSetOrder(6)//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	
dbSelectArea("SD1")
dbSetOrder(1)//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

If SD1->(dbSeek(xFilial("SD1")+cNFiscal+cSerie+cA100For+cLoja))
	While SD1->(!Eof()) .And. xFilial("SD1")+cNFiscal+cSerie+cA100For+cLoja == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		If SUBST(SD1->D1_CF,2,3)="353"
			DbSelectArea("SF4"); DbSetOrder(1)
			If SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
				While SF4->(!Eof()) .AND. SF4->(F4_CODIGO+F4_CF) == SD1->(D1_TES+D1_CF)
					cContaPad := SF4->F4_XCTAD
					SF4->(dbSkip())
				EndDo
			EndIf
		Else
			cContaPad := SD1->D1_CONTA
		EndIf
			
		dbSelectArea("SFT")
		If dbSeek(xFilial("SFT")+"E"+SD1->(D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA+D1_ITEM+D1_COD))
			RecLock("SFT",.F.)
			SFT->FT_CONTA := cContaPad
			MsUnlock()
		EndIf
			
		dbSelectArea("SD1")
		SD1->(dbSkip())
	EndDo
EndIf

//============================================================
// Eliminação de Residuos de pedidos de compras
// Por Anderson Gonçalves em 23/03/21
//============================================================
If INCLUI .or. ALTERA .and. !Empty(SF1->F1_STATUS)

	//===============================================================
	// Verifica se foi amarrado pedido de compras no documento fiscal
	//===============================================================
	cQuery := "SELECT DISTINCT D1_PEDIDO FROM "+RetSqlName("SD1") + " (NOLOCK) "
	cQuery += "WHERE D1_FILIAL = '" + xFilial("SD1") + "' "
	cQuery += "AND D1_DOC = '" + cNFiscal + "' "
	cQuery += "AND D1_SERIE = '" + cSerie + "' "
	cQuery += "AND D1_FORNECE = '" + cA100For + "' "
	cQuery += "AND D1_LOJA = '" + cLoja + "' "
	cQuery += "AND D1_PEDIDO <> ' ' "

	U_FinalArea("QUERY")
	TcQuery cQuery New Alias "QUERY"
	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xFilial("SC7")+QUERY->D1_PEDIDO ))
	While SC7->(!EOF()) .and. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+QUERY->D1_PEDIDO
		lExecuta 	:= .F.
		If SC7->C7_QUANT > SC7->C7_QUJE
			If Aviso("MT103FIM","O pedido "+QUERY->D1_PEDIDO+", gerou uma diferença de "+;
				AllTrim(TransForm(SC7->C7_QUANT - SC7->C7_QUJE,PesqPict("SC7","C7_QUANT")))+" em residuo, deseja eliminar o saldo residual deste pedido?",{"Sim","Não"},2,"Atenção") == 1
				lPerguntou 	:= .T.
				lExecuta 	:= .T.
				cPedido		:= SC7->C7_NUM
				dDtEmissao	:= SC7->C7_EMISSAO
			EndIf

			If lExecuta
				aAdd(aRecSC7Aux,SC7->(Recno()))
			EndIf
		EndIf

		SC7->(dbSkip())
	Enddo
	
	//==========================================================
	// Efetua a eliminação de residuos
	//==========================================================
	If Len(aRecSC7Aux) > 0
		//Eliminacao de residuos
		MA235PC(	100,;									//mv_par01
				 	1,;										//mv_par08
					dDtEmissao,;							//mv_par02
					dDtEmissao,;							//mv_par03
					cPedido,;								//mv_par04
					cPedido,;								//mv_par05
					"",; 									//mv_par06
					Replicate("Z",TamSX3("B1_COD")[1]),;	//mv_par07
					cA100For,; 								//mv_par09
					cA100For,; 								//mv_par10
					ctod("20150101"),; 						//mv_par11
					ctod("20491231"),; 						//mv_par12
					"0000",; 								//mv_par14
					"9999",; 								//mv_par15
					lConsEIC,; 								//lConsEIC
					aRecSC7Aux)								//aRecSC7
	
		DbSelectArea("SCR")
		DbSetOrder(1)
		If SCR->(dbSeek(xFilial("SCR")+"PC"+cPedido,.f.))

			While Eof()==.f. .And. SCR->CR_FILIAL+SCR->CR_TIPO+Alltrim(SCR->CR_NUM) == xFilial("SCR")+"PC"+cPedido
				RecLock("SCR", .f.)
					dbDelete()	
				SCR->(MsUnlock())
				SCR->(dbSkip())
			EndDo
		
		EndIf
	
	EndIf
	
	U_FinalArea("QUERY")

EndIf

RestArea(aAreaSED)
RestArea(aAreaSF1)
RestArea(aAreaSD1)
RestArea(aAreaSFT)
RestArea(aAreaSE2)
RestArea(aAreaSCR)
RestArea(aArea)

Return NIL
