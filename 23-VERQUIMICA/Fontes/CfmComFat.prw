#Include "Protheus.Ch"
#Include "TopConn.ch"
#Include "RwMake.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmComFat  | Autor: Celso Ferrone Martins | Data: 04/06/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmComFat(cCodProd)

Private nSldEst := 0

aCpoSb2 := {}
Aadd(aCpoSb2, {"B2_COD"     , "C", 15, 0}) // Produto
Aadd(aCpoSb2, {"B2_EMBA"    , "C", 30, 0}) // Embalagem
Aadd(aCpoSb2, {"B2_QATU"    , "N", 14, 2}) // Quantidade em Estoque
Aadd(aCpoSb2, {"B2_QTDEM"   , "N", 14, 2}) // Quantidade de Embalagem

aHeadSb2 := {}
Aadd(aHeadSb2, {"B2_COD"   ,, "Produto"     , "@!"})
Aadd(aHeadSb2, {"B2_EMBA"  ,, "Armazenagem" , "@!"})
Aadd(aHeadSb2, {"B2_QATU"  ,, "Estoque"     , "@E 9,999,999.99"})
Aadd(aHeadSb2, {"B2_QTDEM" ,, "Qtde.Emb."   , "@E 9,999,999.99"})

If Select("TRBSB2") > 0
	TRBSB2->(DbCloseArea())
EndIf

cNomeTRBSB2 := CriaTrab(aCpoSb2, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTRBSB2, "TRBSB2", .F., .F.)
cIndTRBSB2 := CriaTrab(NIL,.F.)
//IndRegua("TRBSB2",cIndTRBSB2,"B2_COD",,,"Selecionando Registros...")

aCpoSzz := {}
Aadd(aCpoSzz, {"ZZ_COD"     , "C", 15, 0}) // Produto    
Aadd(aCpoSzz, {"ZZ_EMBA"    , "C", 30, 0}) // Embalagem  
Aadd(aCpoSzz, {"ZZ_PEDIDO"  , "C", 06, 0}) // Pedido
Aadd(aCpoSzz, {"ZZ_ENTREGA" , "D", 08, 0}) // Data Entrega
Aadd(aCpoSzz, {"ZZ_QUANT"   , "N", 14, 2}) // Quantidade
Aadd(aCpoSzz, {"ZZ_COMVEN"  , "C", 06, 0}) // Compra/Venda
Aadd(aCpoSzz, {"ZZ_SALDO"   , "N", 14, 2}) // Saldo   

aHeadSzz := {}
Aadd(aHeadSzz, {"ZZ_COD"     ,, "Produto"      , "@!"})
//Aadd(aHeadSzz, {"ZZ_EMBA"    ,, "Embalagem"    , "@!"})
Aadd(aHeadSzz, {"ZZ_PEDIDO"  ,, "Pedido"       , "@!"})
Aadd(aHeadSzz, {"ZZ_ENTREGA" ,, "Data Entrega" , "@D"})
Aadd(aHeadSzz, {"ZZ_QUANT"   ,, "Qtde."        , "@E 999,999,999.99"})
Aadd(aHeadSzz, {"ZZ_COMVEN"  ,, "Compra/Venda" , "@!"})
Aadd(aHeadSzz, {"ZZ_SALDO"   ,, "Saldo"        , "@E 999,999,999.99"})

If Select("TMPSZZ") > 0
	TMPSZZ->(DbCloseArea())
EndIf

cNomeTMPSZZ := CriaTrab(aCpoSzz, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTMPSZZ, "TMPSZZ", .F., .F.)
cIndTMPSZZ := CriaTrab(NIL,.F.)
IndRegua("TMPSZZ",cIndTMPSZZ,"DTOS(ZZ_ENTREGA)+ZZ_COMVEN",,,"Selecionando Registros...")

CfmSd1Sd2(cCodProd)

Define MsDialog oDlgComFat TITLE "Compras e Vendas" From 001,001 To 550,1200 OF oMainWnd PIXEL

oDlgComFat:lEscClose := .F. // Desabilita fechar apertando a tecla escape ESC.

@ 002,540 Say U_CfmFHtml("Saldo Atual","Navy","8","L") Size 100,010 Pixel OF oDlgComFat Html
@ 010,540 Get nSldEst   Picture "@E 999,999,999.99" Size 060,010 When .F. Object oSldEst

@ 000,001 To 253,253 Label "Estoque" Pixel Of oDlgComFat
oMrkSb2 := MsSelect():New("TRBSB2", "", "", aHeadSb2, , , {008, 004, 250, 250})
oMrkSb2:oBrowse:Refresh()

@ 025,258 To 253,599 Label "Provisoes"   Pixel Of oDlgComFat
oMrkSzz := MsSelect():New("TMPSZZ", "", "", aHeadSzz, , , {033, 261, 250, 596})
oMrkSzz:oBrowse:Refresh()

@ 257,560 Button "Encerrar" Size 040,010 Action f2CfmClose() Pixel Of oDlgComFat

Activate MsDialog oDlgComFat Centered

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmSd1Sd2  | Autor: Celso Ferrone Martins | Data: 07/01/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmSd1Sd2(cCodProd)

Local nSldAtu  := 0
Local aPrdSld  := {}
Local cPrdSld  := ""
Local aAreaSg1 := SG1->(GetArea())
Local aAreaSb1 := SB1->(GetArea())
Local nB2QTDEM := 0
Local _xcCodEm := ""

nSldEst := 0
Aadd(aPrdSld,cCodProd)

TRBSB2->(DbGoTop())
While !TRBSB2->(Eof())
	RecLock("TRBSB2",.F.)
	TRBSB2->(DbDelete())
	MsUnLock()
	TRBSB2->(DbSkip())
EndDo

TMPSZZ->(DbGoTop())
While !TMPSZZ->(Eof())
	RecLock("TMPSZZ",.F.)
	TMPSZZ->(DbDelete())
	MsUnLock()
	TMPSZZ->(DbSkip())
EndDo

cQuery := " SELECT "
cQuery += "   BF_PRODUTO, "
cQuery += "   BF_LOCALIZ, "
cQuery += "   SUM(BF_QUANT)   AS BF_QUANT, "
cQuery += "   SUM(BF_EMPENHO) AS BF_EMPENHO "
cQuery += " FROM "+RetSqlName("SBF")+" SBF "
cQuery += " WHERE "
cQuery += "   SBF.D_E_L_E_T_ <> '*' "
cQuery += "   AND BF_FILIAL  = '"+xFilial("SBF")+"' " 
cQuery += "   AND BF_PRODUTO = '"+cCodProd+"' "
cQuery += " GROUP BY BF_PRODUTO, BF_LOCALIZ "
cQuery += " ORDER BY BF_PRODUTO, BF_LOCALIZ "

cQuery := ChangeQuery(cQuery)

If Select("TMPEST") > 0 
	TMPEST->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPEST"

While !TMPEST->(Eof())

	nSldEst += TMPEST->BF_QUANT

	RecLock("TRBSB2",.T.)
	TRBSB2->B2_COD   := TMPEST->BF_PRODUTO
	TRBSB2->B2_QATU  := TMPEST->BF_QUANT  // - TMPEST->BF_EMPENHO
	TRBSB2->B2_EMBA  := "Granel - "+TMPEST->BF_LOCALIZ
	TRBSB2->B2_QTDEM := 1
	MsUnLock()

	TMPEST->(DbSkip())
EndDo

cQuery := " SELECT "
cQuery += "    SB1.B1_COD          AS B1_COD, "
cQuery += "    SB1.B1_VQ_EM        AS B1_VQ_EM, "
cQuery += "    SB1EM.B1_DESC       AS B1_DESC, "
cQuery += "    SUM(SB2.B2_QATU)    AS B2_QATU, "
cQuery += "    SUM(SB2.B2_RESERVA) AS B2_RESERVA, "
cQuery += "    SUM(SB2.B2_QACLASS) AS B2_QACLASS "
cQuery += " FROM "+RetSqlName("SB1")+" SB1 "
cQuery += "    INNER JOIN "+RetSqlName("SB2")+" SB2 ON "
cQuery += "       SB2.D_E_L_E_T_ <> '*' "
cQuery += "       AND SB2.B2_FILIAL = '"+xFilial("SB2")+"' "
cQuery += "       AND SB2.B2_COD    = SB1.B1_COD "
cQuery += "    INNER JOIN "+RetSqlName("SB1")+" SB1EM ON "
cQuery += "       SB1EM.D_E_L_E_T_ <> '*' "
cQuery += "       AND SB1EM.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += "       AND SB1EM.B1_COD    = SB1.B1_VQ_EM "
cQuery += " WHERE "
cQuery += "    SB1.D_E_L_E_T_ <> '*' "
cQuery += "    AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += "    AND SB1.B1_VQ_MP = '"+cCodProd+"' "
cQuery += " GROUP BY SB1.B1_COD, SB1.B1_VQ_EM, SB1EM.B1_DESC "
cQuery += " ORDER BY SB1.B1_COD, SB1.B1_VQ_EM "

cQuery := ChangeQuery(cQuery)

If Select("TMPEST") > 0 
	TMPEST->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPEST"

While !TMPEST->(Eof())

	nSldEst += TMPEST->B2_QATU
	Aadd(aPrdSld,TMPEST->B1_COD)
	nB2QTDEM := 0
	If SG1->(DbSeek(xFilial("SG1")+TMPEST->B1_COD+cCodProd))
		nB2QTDEM := TMPEST->B2_QATU / SG1->G1_QUANT
	EndIf
	RecLock("TRBSB2",.T.)
	TRBSB2->B2_COD   := TMPEST->B1_COD
	TRBSB2->B2_QATU  := TMPEST->B2_QATU  // - TMPEST->B2_RESERVA - TMPEST->B2_QACLASS
	TRBSB2->B2_EMBA  := TMPEST->B1_DESC
	TRBSB2->B2_QTDEM := nB2QTDEM
	MsUnLock()

	TMPEST->(DbSkip())
EndDo

If Select("TMPEST") > 0 
	TMPEST->(DbCloseArea())
EndIf

cPrdSld := "("
For nX := 1 To Len(aPrdSld)
	If nX == 1
		cPrdSld += "'"+aPrdSld[nX]+"'"
	Else
		cPrdSld += ",'"+aPrdSld[nX]+"'"
	EndIf
Next Nx
cPrdSld += ")"

cQuery := " SELECT * FROM ( " 
cQuery += "    SELECT " 
cQuery += "       C7_PRODUTO AS PRODUTO, " 
cQuery += "       C7_NUM AS PEDIDO, " 
cQuery += "       C7_DATPRF AS PREVISAO, " 
cQuery += "       C7_QUANT - C7_QUJE AS QUANTIDADE, " 
cQuery += "       'COMPRA' AS STATUS " 
cQuery += "    FROM "+RetSqlName("SC7")+" SC7 " 
cQuery += "    WHERE " 
cQuery += "       SC7.D_E_L_E_T_ <> '*' " 
cQuery += "       AND C7_FILIAL = '"+xFilial("SC7")+"' " 
cQuery += "       AND C7_QUANT - C7_QUJE > 0 " 
cQuery += "       AND C7_RESIDUO = ' ' " 
cQuery += "       AND C7_PRODUTO IN " + cPrdSld
cQuery += "    UNION ALL " 
cQuery += "    SELECT " 
cQuery += "       C6_PRODUTO AS PRODUTO, " 
cQuery += "       C6_NUM AS PEDIDO, " 
cQuery += "       C6_ENTREG AS PREVISAO, " 
cQuery += "       C6_QTDVEN AS QUANTIDADE, " 
cQuery += "       'VENDA' AS STATUS " 
cQuery += "    FROM "+RetSqlName("SC6")+" SC6 " 
cQuery += "      INNER JOIN "+RetSqlName("SC5")+" SC5 ON "
cQuery += "         SC5.D_E_L_E_T_ <> '*' "
cQuery += "         AND C5_FILIAL = C6_FILIAL "
cQuery += "         AND C5_NUM    = C6_NUM "
cQuery += "         AND C5_NOTA   = ' ' "
cQuery += "    WHERE " 
cQuery += "       SC6.D_E_L_E_T_ <> '*' " 
cQuery += "       AND C6_FILIAL = '"+xFilial("SC6")+"' " 
cQuery += "       AND C6_NOTA = ' ' " 
cQuery += "       AND C6_PRODUTO IN " + cPrdSld
cQuery += " ) TRB " 
cQuery += " ORDER BY PREVISAO, STATUS, PEDIDO " 

cQuery := ChangeQuery(cQuery)

If Select("TMPC6C7") > 0
	TMPC6C7->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPC6C7"

nSldAtu := nSldEst

While !TMPC6C7->(Eof())

	If SubStr(TMPC6C7->STATUS,1,1) == "C"
		nSldAtu += TMPC6C7->QUANTIDADE
	Else
		nSldAtu -= TMPC6C7->QUANTIDADE
	EndIf

	_xcCodEm := ""

	If SubStr(TMPC6C7->PRODUTO,1,2) == "02"
		_xcCodEm := "GRANEL"
	Else
		If SB1->(DbSeek(xFilial("SB1")+TMPC6C7->PRODUTO))
			_xcCodEm := SB1->B1_VQ_EM
			If SB1->(DbSeek(xFilial("SB1")+_xcCodEm))
				_xcCodEm := SB1->B1_DESC
			EndIf
		EndIf
	EndIf

	Reclock("TMPSZZ",.T.)
	TMPSZZ->ZZ_COD     := TMPC6C7->PRODUTO
	TMPSZZ->ZZ_EMBA    := _xcCodEm
	TMPSZZ->ZZ_PEDIDO  := TMPC6C7->PEDIDO
	TMPSZZ->ZZ_ENTREGA := Stod(TMPC6C7->PREVISAO)
	TMPSZZ->ZZ_QUANT   := TMPC6C7->QUANTIDADE
	TMPSZZ->ZZ_COMVEN  := TMPC6C7->STATUS
	TMPSZZ->ZZ_SALDO   := nSldAtu
	MsUnLock() 
	TMPC6C7->(DbSkip())
EndDo

If Select("TMPC6C7") > 0
	TMPC6C7->(DbCloseArea())
EndIf

TRBSB2->(DbGoTop())
TMPSZZ->(DbGoTop())

If TRBSB2->(Eof())
	RecLock("TRBSB2",.T.)
	MsUnLock()
	TRBSB2->(DbGoTop())
EndIf
If TMPSZZ->(Eof())
	RecLock("TMPSZZ",.T.)
	MsUnLock()
	TMPSZZ->(DbGoTop())
EndIf
	
//oSldEst:Refresh()

SB1->(RestArea(aAreaSb1))
SG1->(RestArea(aAreaSg1))

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: f2CfmClose | Autor: Celso Ferrone Martins | Data: 07/01/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function f2CfmClose()

If Select("TRBSB2") > 0
	TRBSB2->(DbCloseArea())
EndIf

If Select("TMPSZZ") > 0
	TMPSZZ->(DbCloseArea())
EndIf

close(oDlgComFat)

Return()
