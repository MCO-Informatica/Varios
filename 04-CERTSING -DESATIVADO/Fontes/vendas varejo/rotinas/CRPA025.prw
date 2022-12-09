#INCLUDE "Totvs.ch"
#INCLUDE "prtopdef.ch"

/*
CRPA025 - Renato Ruy - 08/04/15
Programa de apoio para geração de registros na SZ5 referente ao hardware avulso.
*/

User Function CRPA025()

Local   cArqTxt := "C:\ARQUIVO.CSV"
//Local	nHdl    := fCreate(cArqTxt)
//Local	nLin	:= ""
//Private cEOL    := "CHR(13)+CHR(10)"

//If Empty(cEOL)
//	cEOL := CHR(13)+CHR(10)
//Else
//	cEOL := Trim(cEOL)
//	cEOL := &cEOL
//Endif

//If nHdl == -1
//	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
//	Return
//Endif

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv("01","02")

BeginSql Alias "SC5TMP"
	
	SELECT DISTINCT
    F2_EMISSAO,
    C5_NUM,
		C6_VALOR,
		C6_PRODUTO,
		C6_DESCRI,
		C6_XNUMVOU,
		C6_PROGAR,
		C6_NUM,
		C6_ITEM,
		C5_XPOSTO,
		C5_TIPMOV,
		C5_TABELA,
		C5_XNPSITE
    FROM PROTHEUS.SC5010 SC5
	JOIN PROTHEUS.SC6010 SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC6.D_E_L_E_T_ = ' '
	JOIN PROTHEUS.SF2010 SF2 ON F2_FILIAL = '02' AND F2_DOC = C6_NOTA AND F2_SERIE = C6_SERIE AND SF2.D_E_L_E_T_ = ' '
	LEFT JOIN PROTHEUS.SZ5010 SZ5 ON Z5_FILIAL = ' ' AND Z5_PEDIDO = C5_NUM AND Z5_PRODUTO = C6_PRODUTO AND SZ5.D_E_L_E_T_ = ' '
	WHERE
	C5_FILIAL = ' ' AND
	C5_XNPSITE IN ('6136148') AND
	(C6_XOPER = '52') AND
	C5_XPOSTO != ' ' AND
	C5_CHVBPAG = ' ' AND
	C5_XNPSITE != ' ' AND
	C6_NOTA != ' ' AND
	Z5_PEDSITE IS NULL AND
	SC5.D_E_L_E_T_ = ' '
	
EndSql

DbSelectArea("SC5TMP")
DbGoTop()

//nLin := "Data Entrega; Valor ; Produto ; Descrição Prod. ; Número Voucher ; Produto GAR ; Tipo; Descrição;Pedido; Item; Programa Gerador; Tipo Movimento; Tabela de Preço; Pedido Site; Cod. Posto; Desc. Posto;Rede; Desc. AR" + cEOL
//FWrite(nHdl, nLin, Len(nLin))

While !EOF("SC5TMP")
	
	
	DbselectArea("SZ5")
	DbSetOrder(3)
	If !DbSeek(xFilial("SZ5")+SC5TMP->C5_NUM) .And. SZ5->Z5_PRODUTO != SC5TMP->C6_PRODUTO
		
		//Campos adicionados para a gravação de informações perinentes a midia avulsa
		
		Reclock('SZ5',.T.)
		SZ5->Z5_EMISSAO := StoD(SC5TMP->F2_EMISSAO)
		SZ5->Z5_VALOR :=   SC5TMP->C6_VALOR
		SZ5->Z5_PRODUTO := SC5TMP->C6_PRODUTO
		SZ5->Z5_DESPRO  := SC5TMP->C6_DESCRI
		SZ5->Z5_CODVOU  := SC5TMP->C6_XNUMVOU
		SZ5->Z5_PRODGAR := SC5TMP->C6_PROGAR
		SZ5->Z5_TIPO    := "ENTHAR"                           //REMUNERA O POSTO/AR PELA ENTREGA DA MÍDIA
		SZ5->Z5_TIPODES := "ENTREGA HARDWARE AVULSO"
		SZ5->Z5_VALORHW := SC5TMP->C6_VALOR
		SZ5->Z5_PEDIDO  := SC5TMP->C6_NUM
		SZ5->Z5_ITEMPV  := SC5TMP->C6_ITEM
		SZ5->Z5_ROTINA  := "M460FIM"
		SZ5->Z5_CODPOS 	:= SC5TMP->C5_XPOSTO
		SZ5->Z5_TIPMOV	:= SC5TMP->C5_TIPMOV
		SZ5->Z5_TABELA	:= SC5TMP->C5_TABELA
		SZ5->Z5_PEDSITE	:= SC5TMP->C5_XNPSITE
		
		SZ3->(DbSetOrder(6))
		If SZ3->(DbSeek(xFilial("SZ3") + "4" + SC5TMP->C5_XPOSTO))
			
			SZ5->Z5_DESPOS	:= SZ3->Z3_DESENT
			SZ5->Z5_REDE    := SZ3->Z3_REDE
			SZ5->Z5_DESCAR	:= SZ3->Z3_DESAR
		EndIf
		
		SZ5->(MsUnlock())
		
	EndIf
	
	//nLin := DtoC(StoD(SC5TMP->F2_EMISSAO)) + ";" + Str(SC5TMP->C6_VALOR) + ";" + SC5TMP->C6_PRODUTO  + ";" + SC5TMP->C6_DESCRI  + ";" +	SC5TMP->C6_XNUMVOU  + ";" +	SC5TMP->C6_PROGAR + ";" + "ENTHAR" + ";" + "ENTREGA HARDWARE AVULSO"  + ";" + SC5TMP->C6_NUM  + ";" + SC5TMP->C6_ITEM + ";" + "M460FIM" + ";" +	SC5TMP->C5_TIPMOV + ";" + SC5TMP->C5_TABELA + ";" +	SC5TMP->C5_XNPSITE + ";" + SC5TMP->C5_XPOSTO + ";" + SZ3->Z3_DESENT + ";" + SZ3->Z3_REDE + ";" + SZ3->Z3_DESAR + cEOL
	//FWrite(nHdl, nLin, Len(nLin))
	DbSelectArea("SC5TMP")
	SC5TMP->(DbSkip())
EndDo

//fClose(nHdl)

MsgInfo("Processo Finalizado!")

Return
