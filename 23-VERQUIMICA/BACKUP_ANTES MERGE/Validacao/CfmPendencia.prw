#Include "RwMake.Ch"
#Include "Protheus.Ch"
#Include "TopConn.Ch"
/*
================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+------------------------+------------------------------+------------------+||
||| Programa: CfmPendencia | Autor: Celso Ferrone Martins | Data: 16/12/2014 |||
||+-----------+------------+------------------------------+------------------+||
||| Descricao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Alteracao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Uso       |                                                              |||
||+-----------+--------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
================================================================================
*/

User Function CfmPendencia(lGrava,cMsgInfo)

Local lRet      := .T.
Local aAreaSa1  := SA1->(GetArea())
Local aAreaSa4  := SA4->(GetArea())
Local aAreaSb1  := SB1->(GetArea())
Local aAreaSb5  := SB5->(GetArea())

Local nPosProd  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) // Produto
Local nPosMoed  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MOED"}) // Moeda
Local nPosEM    := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_EM"})   // Embalagem
Local nPosCapa  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"}) // Capacidade
Local nPQtdVer  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"}) // Quantidade
Local nPosUm    := aScan(aHeader,{|x| AllTrim(x[2])=="UB_UM"})      // Unidade de Medida Padrao
Local nPosSegUm := aScan(aHeader,{|x| Alltrim(x[2])=="UB_SEGUM"})   // Segunda Unidade de Medida
Local nPQtdUm1  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})   // Quantidade  
Local nPQtdUm2  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT2"})  // Quantidade

Local nPUniVer  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"}) // Valor Unitário
Local nPosVal   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VAL"})  // Valor tabela

Local nPosTes   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_TES"})     // TES

Local lPolicia  := .F.
Local lExercito := .F.
Local lDifMoeda := .F.
Local nPesoL    := 0
Local nPesoB    := 0
Local cEol      := Chr(13)+Chr(10)
Local aProds    := {}
Local lAleMsg   := .F.
Local MsgTab    := ""
Local lTemMsg   := .F.

Local nKgMinPf  := GetMv("VQ_MINKGPF")
Local nKgMinEx  := GetMv("VQ_MINKGEX")

Local nQtdPf    := 0
Local nQtdEx    := 0

Local cMsg1Info := ""

Local lBlqKgPf  := .F.
Local lBlqKgEx  := .F.

Default lGrava   := .F.
Default cMsgInfo := ""

DbSelectARea("SA1") ; DbSetOrder(1) // Clientes
DbSelectARea("SA4") ; DbSetOrder(1) // Transportadora
DbSelectARea("SB1") ; DbSetOrder(1) // Produtos
DbSelectArea("SB5") ; DbSetOrder(1) // Complemento de Protudo
DbSelectArea("SF4") ; DbSetOrder(1) // Tipo de Entrada e Saida

SA1->(DbSeek(xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA)))
SA4->(DbSeek(xFilial("SA4")+M->UA_TRANSP))

lPfCliTra := .T.
lExCliTra := .T.

For nX := 1 to Len(aCols) // Varre todas as linhas do aCols.
	If !GdDeleted(nX,aHeader,aCols)
	
		If aCols[nX][nPQtdVer] == 0 .And. lRet
			cMsgInfo += "Nao e permitido produtos com quantidade Zero!"
			lTemMsg := .T.
			lRet := .F.
//			Exit
		EndIf

		If SF4->(DbSeek(xFilial("SF4")+aCols[nX][nPosTes]))
			If SF4->F4_ESTOQUE == "S"
				aAdd(aProds,{aCols[nX][nPosProd],aCols[nX][nPQtdUm1],aCols[nX][nPQtdUm2]})
			EndIf
		EndIf

		If aCols[nX][nPUniVer] < aCols[nX][nPosVal]
			MsgTab += "  - "+aCols[nX][nPosProd]+" -> Tabela "+Transform(aCols[nX][nPosVal],"@E 999,999,999.99")+"  Preco digitado "+Transform(aCols[nX][nPUniVer],"@E 999,999,999.99")+cEol
			lAleMsg := .T.
		EndIf

		If lGrava
			If aCols[nX][nPosUm] == "KG"
				nPesoL += aCols[nX][nPQtdUm1]
			ElseIf aCols[nX][nPosSegUm] == "KG"
				nPesoL += aCols[nX][nPQtdUm2]
			EndIf
			If SB1->(DbSeek(xFilial("SB1")+aCols[nX][nPosEM]))
				If SB1->B1_PESO > 0
					nPesoB += (aCols[nX][nPQtdVer] / aCols[nX][nPosCapa]) * SB1->B1_PESO
				EndIf
			EndIf
		EndIf

		SB1->(DbSeek(xFilial("SB1")+aCols[nX][nPosProd]))
		SB5->(DbSeek(xFilial("SB5")+aCols[nX][nPosProd]))

		If SB5->B5_PRODPF == "S"
			lPolicia := .T.
			nQtdPf += aCols[nX][nPQtdUm1]
			If aCols[nX][nPQtdUm1] > SB5->B5_VQ_QTPF
				lTemMsg   := .F.
				cMsg1Info := "Licenca da Policia Federal -> "+cEol
				If Empty(SA1->A1_VQ_LIPF)
					lRet      := .F.
					lTemMsg   := .T.
					cMsg1Info += "  - Cliente -> Sem licenca da Policia Federal Cadastrada."+cEol
				EndIf
				If SA1->A1_VQ_DLPF < Date()
					lRet      := .F.
					lTemMsg   := .T.
					cMsg1Info += "  - Cliente -> Data de Validade Vencida."+cEol
				EndIf
				If lTemMsg
					lBlqKgPf := .T.
					lAleMsg  := .T.
					cMsgInfo += cMsg1Info+cEol
				EndIf

				If lPfCliTra
					lPfCliTra := .F.
					cMsg1Info := "Licenca da Policia Federal -> "+cEol
					lTemMsg := .F.
					If Empty(SA1->A1_VQ_LIPF)
						lRet      := .F.
						lTemMsg   := .T.
						cMsg1Info += "  - Cliente -> Sem licenca da Policia Federal Cadastrada."+cEol
					EndIf
					If SA1->A1_VQ_DLPF < Date()
						lRet      := .F.
						lTemMsg   := .T.
						cMsg1Info += "  - Cliente -> Data de Validade Vencida."+cEol
					EndIf
					If Empty(SA4->A4_VQ_LIPF)
						lRet      := .F.
						lTemMsg   := .T.
						cMsg1Info += "  - Transportadora -> Sem licenca da Policia Federal Cadastrada."+cEol
					EndIf
					If SA4->A4_VQ_DLPF < Date()
						lRet      := .F.
						lTemMsg   := .T.
						cMsg1Info += "  - Transportadora -> Data de Validade Vencida."+cEol
					EndIf
					If lTemMsg
						lAleMsg := .T.
						cMsgInfo += cMsg1Info+cEol
					EndIf
				EndIf
			EndIf
		EndIf
		If SB5->B5_PRODEX == "S"
			lExercito := .T.
			nQtdEx += aCols[nX][nPQtdUm1]
			If aCols[nX][nPQtdUm1] > SB5->B5_VQ_QTEX
				lTemMsg   := .F.
				cMsg1Info := "Licenca do Exercito -> "+cEol
				If Empty(SA1->A1_VQ_LIEX)
					lRet      := .F.
					lTemMsg   := .T.
					cMsg1Info += "  - Cliente -> Sem licenca do Exercito Cadastrada."+cEol
				EndIf
				If SA1->A1_VQ_DLEX < Date()
					lRet      := .F.
					lTemMsg   := .T.
					cMsg1Info += "  - Cliente -> Data de Validade Vencida."+cEol
				EndIf
				If lTemMsg
					lBlqKgEx := .T.
					lAleMsg  := .T.
					cMsgInfo += cMsg1Info+cEol
				EndIf
				If lExCliTra
					lExCliTra := .F.

					cMsg1Info := "Licenca do Exercito -> "+cEol
					lTemMsg   := .F.
					If Empty(SA1->A1_VQ_LIEX)
						lRet      := .F.
						lTemMsg   := .T.
						cMsg1Info += "  - Cliente -> Sem licenca do Exercito Cadastrada."+cEol
					EndIf
					If SA1->A1_VQ_DLEX < Date()
						lRet      := .F.
						lTemMsg   := .T.
						cMsg1Info += "  - Cliente -> Data de Validade Vencida."+cEol
					EndIf
					If Empty(SA4->A4_VQ_LIEX)
						lRet      := .F.
						lTemMsg   := .T.
						cMsg1Info += "  - Transportadora -> Sem licenca do Exercito Cadastrada."+cEol
					EndIf
					If SA4->A4_VQ_DLEX < Date()
						lRet      := .F.
						lTemMsg   := .T.
						cMsg1Info += "  - Transportadora -> Data de Validade Vencida."+cEol
					EndIf
					If lTemMsg
						lAleMsg := .T.
						cMsgInfo += cMsg1Info+cEol
					EndIf

				EndIf
			EndIf
		EndIf

	EndIf
Next nX

If lGrava
	M->UA_PESOL := nPesoL
	M->UA_PESOB := nPesoL + nPesoB
EndIf

/*
//Validacao Policia Federal
If lPolicia .And. !lBlqKgPf
	cMsg1Info := "Licenca da Policia Federal -> "+cEol
	lTemMsg := .F.
	If Empty(SA1->A1_VQ_LIPF)
		lRet      := .F.
		lTemMsg   := .T.
		cMsg1Info += "  - Cliente -> Sem licenca da Policia Federal Cadastrada."+cEol
	EndIf
	If SA1->A1_VQ_DLPF < Date()
		lRet      := .F.
		lTemMsg   := .T.
		cMsg1Info += "  - Cliente -> Data de Validade Vencida."+cEol
	EndIf
	If Empty(SA4->A4_VQ_LIPF)
		lRet      := .F.
		lTemMsg   := .T.
		cMsg1Info += "  - Transportadora -> Sem licenca da Policia Federal Cadastrada."+cEol
	EndIf
	If SA4->A4_VQ_DLPF < Date()
		lRet      := .F.
		lTemMsg   := .T.
		cMsg1Info += "  - Transportadora -> Data de Validade Vencida."+cEol
	EndIf
	If lTemMsg
		lAleMsg := .T.
		cMsgInfo += cMsg1Info+cEol
	EndIf
EndIf
*/
/*
//Validacao Exercito
If lExercito .And. !lBlqKgEx
	cMsg1Info := "Licenca do Exercito -> "+cEol
	lTemMsg   := .F.
	If Empty(SA1->A1_VQ_LIEX)
		lRet      := .F.
		lTemMsg   := .T.
		cMsg1Info += "  - Cliente -> Sem licenca do Exercito Cadastrada."+cEol
	EndIf
	If SA1->A1_VQ_DLEX < Date()
		lRet      := .F.
		lTemMsg   := .T.
		cMsg1Info += "  - Cliente -> Data de Validade Vencida."+cEol
	EndIf
	If Empty(SA4->A4_VQ_LIEX)
		lRet      := .F.
		lTemMsg   := .T.
		cMsg1Info += "  - Transportadora -> Sem licenca do Exercito Cadastrada."+cEol
	EndIf
	If SA4->A4_VQ_DLEX < Date()
		lRet      := .F.
		lTemMsg   := .T.
		cMsg1Info += "  - Transportadora -> Data de Validade Vencida."+cEol
	EndIf
	If lTemMsg
		lAleMsg := .T.
		cMsgInfo += cMsg1Info+cEol
	EndIf
EndIf
*/
// Atualiza campo de moeda do cabeçalho do atendimento
lAtuSua := .F.
If lRet .And. M->UA_OPER == "1"
	For nX := 1 to Len(aCols) // Varre todas as linhas do aCols.
		If !GdDeleted(nX,aHeader,aCols)
			If !lAtuSua
				M->UA_MOEDA := Val(aCols[nX][nPosMoed])
				lAtuSua := .T.
			Else
				If M->UA_MOEDA != Val(aCols[nX][nPosMoed])
					lDifMoeda := .T.
					Exit
				EndIf
			EndIf
		EndIf
	Next nX

	If lDifMoeda
//		MsgBox("Itens com moeda diferente!"+CHR(10)+"Faturamento nao Permitido!")
		cMsgInfo += "Itens com moedas diferentes nao permitido."+cEol+cEol
		lRet := .F.
		lAleMsg := .T.
	EndIf

EndIf

If !Empty(MsgTab)
	cMsgInfo += "Valor abaixo da tabela -> "+cEol
	cMsgInfo += MsgTab+cEol
EndIf


// SA1->(DbSeek(xFilial("SA1")+M->(UA_CLIENTE+UA_LOJA)))
// Tem que validar titulos em Atraso
	nDiasAtr := SuperGetMv("VQ_DIASATR", ,0) // Dias de atraso ref. 	
	If Empty(nDiasAtr)
		nDiasAtr := 0
	EndIf
	
	cQuery := " SELECT                                                          " + cEol
	cQuery += "   SUM(E1_SALDO)    AS SALDO                                     " + cEol
	cQuery += " FROM "+RetSqlName("SE1")+" SE1                                  " + cEol
	cQuery += " WHERE                                                           " + cEol
	cQuery += "   SE1.D_E_L_E_T_ <> '*'                                         " + cEol
	cQuery += "   AND E1_FILIAL   = '"+xFilial("SE1")+"'                        " + cEol
	cQuery += "    AND E1_CLIENTE = '"+M->UA_CLIENTE+"'                         " + cEol
	cQuery += "    AND E1_LOJA    = '"+M->UA_LOJA+"'                            " + cEol
	cQuery += "    AND E1_SALDO > 0                                             " + cEol
	cQuery += "    AND E1_VENCREA < '"+dtos(dDatabase-nDiasAtr)+"'                             " + cEol	 
	cQuery += "    AND E1_TIPO <> 'RA' " + cEol	 
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TMPSE1") > 0
		TMPSE1->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TMPSE1"
	
	If !TMPSE1->(Eof())
		If TMPSE1->SALDO > 0
			lTemMsg := .T.
//			lRet := .T.
			cMsg1Info += "  - Cliente com Titulo em Atraso: " +Transform(TMPSE1->SALDO,"@E 999,999,999.99")+"   "+cEol
		EndIf
	EndIf

/* Comentado por Felipe - 16/01/15

cMsg1Info := "Produto sem saldo -> "+cEol
//lTemMsg   := .F.

For nX := 1 To Len(aProds)

	SB1->(DbSeek(xFilial("SB1")+aProds[nX][1]))

	cCodMp := ""

	If SB1->B1_TIPO == "MP"
		cCodMp := SB1->B1_COD
	Else
		cCodMp := SB1->B1_VQ_MP
	EndIf

	cQuery := " SELECT                                                          " + cEol
	cQuery += "   SUM(B2_QATU)    AS B2_QATU,                                   " + cEol
	cQuery += "   SUM(B2_RESERVA) AS B2_RESERVA,                                " + cEol
	cQuery += "   SUM(B2_QPEDVEN) AS B2_QPEDVEN,                                " + cEol
	cQuery += "   SUM(B2_QEMP)    AS B2_QEMP,                                   " + cEol
	cQuery += "   SUM(B2_QACLASS) AS B2_QACLASS,                                " + cEol
	cQuery += "   SUM(QTD1)       AS QTD1,                                      " + cEol
	cQuery += "   SUM(B2_QTSEGUM) AS B2_QTSEGUM,                                " + cEol
	cQuery += "   SUM(B2_RESERV2) AS B2_RESERV2,                                " + cEol
	cQuery += "   SUM(B2_QPEDVE2) AS B2_QPEDVE2,                                " + cEol
	cQuery += "   SUM(B2_QEMP2)   AS B2_QEMP2,                                  " + cEol
	cQuery += "   SUM(QTD2)       AS QTD2                                       " + cEol
	cQuery += " FROM (                                                          " + cEol

	cQuery += " SELECT                                                          " + cEol
	cQuery += "   B2_FILIAL,                                                    " + cEol
	cQuery += "   B2_COD,                                                       " + cEol
//	cQuery += "   B2_LOCAL,                                                     " + cEol
	cQuery += "   SUM(B2_QATU   ) AS B2_QATU,                                   " + cEol
	cQuery += "   SUM(B2_RESERVA) AS B2_RESERVA,                                " + cEol
	cQuery += "   SUM(B2_QPEDVEN) AS B2_QPEDVEN,                                " + cEol
	cQuery += "   SUM(B2_QEMP)    AS B2_QEMP,                                   " + cEol
	cQuery += "   SUM(B2_QACLASS) AS B2_QACLASS,                                " + cEol
	cQuery += "   ISNULL(QTD1,0)  AS QTD1,                                      " + cEol
	cQuery += "   SUM(B2_QTSEGUM) AS B2_QTSEGUM,                                " + cEol
	cQuery += "   SUM(B2_RESERV2) AS B2_RESERV2,                                " + cEol
	cQuery += "   SUM(B2_QPEDVE2) AS B2_QPEDVE2,                                " + cEol
	cQuery += "   SUM(B2_QEMP2)   AS B2_QEMP2,                                  " + cEol
	cQuery += "   ISNULL(QTD2,0)  AS QTD2                                       " + cEol
	cQuery += " FROM "+RetSqlName("SB2")+" SB2                                  " + cEol
	cQuery += "   LEFT JOIN (                                                   " + cEol
	cQuery += "     SELECT                                                      " + cEol
	cQuery += "       C6_PRODUTO,                                               " + cEol
	cQuery += "       ISNULL(SUM(C6_QTDVEN-C6_QTDEMP ),0) AS QTD1,              " + cEol
	cQuery += "       ISNULL(SUM(C6_UNSVEN-C6_QTDEMP2),0) AS QTD2               " + cEol
	cQuery += "     FROM "+RetSqlName("Sc6")+" SC6                              " + cEol
	cQuery += "        INNER JOIN " + RetSqlName("SF4") + " SF4 ON              " + cEol
	cQuery += "           SF4.D_E_L_E_T_ <> '*'                                 " + cEol
	cQuery += "           AND F4_FILIAL  = '"+xFilial("SF4")+"'                 " + cEol
	cQuery += "           AND F4_CODIGO  = C6_TES                               " + cEol
	cQuery += "           AND F4_ESTOQUE = 'S'                                  " + cEol
	cQuery += "     WHERE                                                       " + cEol
	cQuery += "        SC6.D_E_L_E_T_ <> '*'                                    " + cEol
	cQuery += "        AND C6_FILIAL   = '"+xFilial("SC6")+"'                   " + cEol
	cQuery += "        AND C6_PRODUTO  = '"+aProds[nX][1]+"'                    " + cEol
	cQuery += "        AND C6_NOTA     = ' '                                    " + cEol
	cQuery += "        AND C6_BLQ     <> 'R'                                    " + cEol
	cQuery += "     GROUP BY C6_PRODUTO                                         " + cEol
	cQuery += "   ) SC6 ON                                                      " + cEol
	cQuery += "     C6_PRODUTO = B2_COD                                         " + cEol
	cQuery += " WHERE                                                           " + cEol
	cQuery += "   SB2.D_E_L_E_T_ <> '*'                                         " + cEol
	cQuery += "   AND B2_FILIAL   = '"+xFilial("SB2")+"'                        " + cEol
	cQuery += "    AND B2_COD IN (                                              " + cEol
	cQuery += "       SELECT                                                    " + cEol
	cQuery += "          B1_COD                                                 " + cEol
	cQuery += "       FROM "+RetSQLName("SB1")+" SB1                            " + cEol
	cQuery += "       WHERE                                                     " + cEol
	cQuery += "          SB1.D_E_L_E_T_ <> '*'                                  " + cEol
	cQuery += "          AND (B1_COD = '"+cCodMp+"' OR B1_VQ_MP = '"+cCodMp+"') " + cEol
	cQuery += "       )                                                         " + cEol
	cQuery += " GROUP BY B2_FILIAL, B2_COD, QTD1, QTD2 "

	cQuery += " )                                                               " + cEol

	cQuery := ChangeQuery(cQuery)
	
	If Select("TMPSB2") > 0
		TMPSB2->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TMPSB2"
	
	If !TMPSB2->(Eof())
		If TMPSB2->(B2_QATU - B2_RESERVA - B2_QPEDVEN - B2_QEMP - B2_QACLASS)-aProds[nX][2] < 0
			lTemMsg := .T.
			lRet := .F.
			cMsg1Info += "  - "+aProds[nX][1]+" -> Saldo " +Transform(TMPSB2->(B2_QATU - B2_RESERVA - B2_QPEDVEN)-aProds[nX][2],"@E 999,999,999.99") +" KG   "+Transform(TMPSB2->(B2_QTSEGUM - B2_RESERV2 - B2_QPEDVE2)-aProds[nX][3],"@E 999,999,999.99") +" L   "+cEol
		EndIf
	EndIf

	If Select("TMPSB2") > 0
		TMPSB2->(DbCloseArea())
	EndIf

Next nX
*/ // Comentado por Felipe - 16/01/15

If lTemMsg
	cMsgInfo += cMsg1Info+cEol
	lAleMsg := .T.
EndIf

SA1->(RestArea(aAreaSa1))
SA4->(RestArea(aAreaSa4))
SB1->(RestArea(aAreaSb1))
SB5->(RestArea(aAreaSb5))

If lAleMsg
	MsgAlert(cMsgInfo,"Atencao!!!")
EndIf

/*
If !lRet .And. Altera
	If SUA->UA_OPER == "1"
		lRet := .T.
	EndIf
EndIf
*/
Return(lRet)