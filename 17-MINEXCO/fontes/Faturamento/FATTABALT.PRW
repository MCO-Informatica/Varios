#include "rwmake.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³U_FATTabAlt ³ Autor ³Magh Moura           ³ Data ³28/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Conversao dos Precos.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := U_TabAlt()                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpC1 -> Moeda Alterada Para Gatilho                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Minexco Com. Imp. Exp. Ltda                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATTabAlt()

Local aArea      := GetArea()
Local aAreaSB1   := SB1->(GetArea())

LOCAL nRegAtu    := 0
LOCAL nPrcVen    := 0
LOCAL nVlrTabela := 0

LOCAL lPrcOrc    := GetMv("MV_PRCORC")
Local lProcess   := .F.

nRegAtu := TMP1->( RecNo() )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os valores dos itens com base na tabela     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TMP1->( dbGoTop() )

While TMP1->( !Eof() )

	If lPrcOrc
           lProcess:= .T.
  
		dbSelectArea("TMP2")
		dbSetOrder(1)
		If MsSeek(M->CJ_NUM+TMP1->CK_ITEM,.T.)

			nPrcVen := 0

			While ( !Eof() .And. M->CJ_NUM == TMP2->CL_NUM .And. ;
					TMP2->CL_ITEMORC == TMP1->CK_ITEM )

				dbSelectArea("SB1")
				dbSetOrder(1)
				MsSeek(xFilial()+TMP2->CL_PRODUTO)

				If ( !TMP2->CL_FLAG )
					nPrcVen += (TMP2->CL_QUANT*A415Tabela(TMP2->CL_PRODUTO,M->CJ_TABELA,TMP2->CL_QUANT*TMP1->CK_QTDVEN))
				EndIf

				dbSelectArea("TMP2")
				dbSkip()
			EndDo
		Else
			nPrcVen := A415Tabela(TMP1->CK_PRODUTO,M->CJ_TABELA,TMP1->CK_QTDVEN)
		Endif	

	Else
		nPrcVen := A415Tabela(TMP1->CK_PRODUTO,M->CJ_TABELA,TMP1->CK_QTDVEN)
	Endif	    	

	nVlrTabela := nPrcVen

	RecLock("TMP1",.F.)	
	TMP1->CK_PRUNIT  := nVlrTabela
	TMP1->CK_PRCVEN  := nPrcVen
	TMP1->CK_VALOR   := A410Arred(TMP1->CK_QTDVEN*TMP1->CK_PRCVEN,"CK_VALOR")
	MsUnlock()

	TMP1->(dbSkip())

EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aplica os descontos de cabecalho e de item           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lProcess
   A415DesCab( .T. )          
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona na linha original                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TMP1->( MsGoto( nRegAtu ) )

If Type("oGetDad") <> "U"
	oGetDad:oBrowse:Refresh()
Endif	

RestArea(aAreaSB1)
RestArea(aArea)

Return( M->CJ_MOEDA )