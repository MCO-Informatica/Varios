#INCLUDE "rwmake.ch"
//#Include "shFIXSC9.CH"
//#Include "PROTHEUS.CH"

//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//   Programa ...: shFIXSC9()                           Modulo : SIGACFG    //
//                                                                          //
//   Autor ......: MARCOS MARTINS NETO                Data ..: 12/06/08     //
//                                                                          //
//   Objetivo ...: Realiza acertos no SC9, com base no SC6 x SD2            //
//                                                                          //
//   Uso ........: Especifico da Shangrila , Capela e Cor&Lar               //
//                                                                          //
//   Observacoes :                                                          //
//                                                                          //
//                                                                          //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

User Function shFIXSC9()
Local _cAlias	:= Alias()
Local _cIndex	:= IndexOrd()
Local _nRecNo	:= RecNo()
Local _aArea	:= GetArea()

//Local aStruSE1  	:= SE1->(dbStruct())
//Local cTrbSE1		:= CriaTrab("",.F.)

Local lQuery		:= .F.

//Local nSeq			:= 0
//Local nTamLin
//Local nX

//Local _nCountA	:= 00
//Local _nCountB	:= 00
//Local _nCountC	:= 00

shFXC9()

dbSelectArea(_cAlias)
dbSetOrder(_cIndex)
dbGoTo(_nRecNo)
RestArea(_aArea)
Return

//############################
Static Function shFXC9()
//############################
// Author : Marcos M. Neto / Criado em : 16/06/2008
// Descrição : Verifica base e realiza inclussoes
Local cAlias := "DSC9"
Local cQuery
Local xSeqP, xSeqG := 1
Local AntPed    := "XXXXXXXXXXXXXXXX"
dbSelectArea("SC9")
dbSetOrder(1)

#IFDEF TOP
	If ( TcSrvType()<>"AS/400" )
		lQuery := .T.
//		cQuery := " select A1_COD, A1_LOJA, A1_GRPTRIB from " + RetSqlName("SA1") + " where (not (( A1_PESSOA = 'F' ) AND ( A1_EST <> 'SP' )) and not (( A1_PESSOA = 'J' ) AND (( A1_EST='AM' AND ( A1_MUN='MANAUS' or A1_MUN='RIO PRETO DA ERA' or A1_MUN='PRESIDENTE FIGUEREDO' or A1_MUN='TABATINGA' ) ) OR ( A1_EST='AC' AND ( A1_MUN='BRASILEIA' or A1_MUN='CRUZEIRO DO SUL' or A1_MUN='EPITACIOLANDIA' ) ) OR ( A1_EST='AP' AND ( A1_MUN='MACAPA' or A1_MUN='SANTANA' ) ) OR ( A1_EST='RO' AND ( A1_MUN='GUAJARA MIRIM' ) ) OR ( A1_EST='RR' AND ( A1_MUN='BOM FIM' or A1_MUN='PACARAIMA' ) )))) and (A1_GRPTRIB<>'100')"
//		cQuery := "SELECT SC6.C6_FILIAL, SD2.D2_PEDIDO, SD2.D2_ITEMPV, SD2.D2_CLIENTE, SD2.D2_LOJA, SC6.C6_PRODUTO, SD2.D2_QUANT, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_EMISSAO, SD2.D2_GRUPO, SD2.D2_PRCVEN, SD2.D2_LOCAL, SC6.C6_TES "
//		cQuery += "FROM (" + RetSqlName("SC6") + " SC6 LEFT JOIN " + RetSqlName("SC9") + " SC9 ON (SC6.C6_NUM = SC9.C9_PEDIDO) AND (SC6.C6_ITEM = SC9.C9_ITEM) AND (SC6.C6_PRODUTO = SC9.C9_PRODUTO)) LEFT JOIN " + RetSqlName("SD2") + " SD2 ON (SC6.C6_NUM = SD2.D2_PEDIDO) AND (SC6.C6_ITEM = SD2.D2_ITEMPV) "
//      cQuery += "WHERE (((SC9.C9_QTDLIB) Is Null) AND ((SD2.D2_EMISSAO) Is Not Null) AND ((SC6.D_E_L_E_T_)<>'*') AND ((SD2.D_E_L_E_T_)<>'*')) "
//      cQuery += "GROUP BY SC6.C6_FILIAL, SD2.D2_PEDIDO, SD2.D2_ITEMPV, SD2.D2_CLIENTE, SD2.D2_LOJA, SC6.C6_PRODUTO, SD2.D2_QUANT, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_EMISSAO, SD2.D2_GRUPO, SD2.D2_PRCVEN, SD2.D2_LOCAL, SC6.C6_TES; "
        cQuery := "Select * from SC6SC9010 order by SC6SC9010.C6_FILIAL, SC6SC9010.D2_PEDIDO, SC6SC9010.D2_ITEMPV, SC6SC9010.C6_PRODUTO"
		cQuery := ChangeQuery(cQuery)
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)},"Aguarde... Filtrando SC9 perdidos...")
	EndIf
#ENDIF

dbSelectArea(cAlias)
dbGoTop()
nTotReg := RecCount()
ProcRegua(nTotReg)
nContReg := 0

While !(cAlias)->(Eof())
	nContReg += 1	
	IncProc("Processando SC9: "+StrZero(nContReg,6,0)+If(lQuery,"","/"+StrZero(nTotReg,6,0)) )
		//RecLock("SF1",.T.)
		//Replace F1_TIPO With cTipo, F1_DOC With cNFiscal, F1_SERIE With cSerie ,F1_EMISSAO With dDEmissao, F1_LOJA With cLoja ,F1_FORNECE With Subs(cA100For,1,6)
		//dbUnLock()
	RecLock("SC9",.T.)
	SC9->C9_OK      = "XXXX"
	SC9->C9_FILIAL  = DSC9->C6_FILIAL
	SC9->C9_PEDIDO  = DSC9->D2_PEDIDO
	SC9->C9_ITEM    = DSC9->D2_ITEMPV
	SC9->C9_CLIENTE = DSC9->D2_CLIENTE
	SC9->C9_LOJA    = DSC9->D2_LOJA
	SC9->C9_PRODUTO = DSC9->C6_PRODUTO
	SC9->C9_QTDLIB  = DSC9->D2_QUANT
	SC9->C9_NFISCAL = DSC9->D2_DOC
	SC9->C9_SERIENF = DSC9->D2_SERIE
	SC9->C9_DATALIB = StoD(DSC9->D2_EMISSAO)
	if (DSC9->C6_FILIAL+DSC9->D2_PEDIDO+DSC9->D2_ITEMPV+DSC9->C6_PRODUTO=AntPed)
		xSeqP += 1
	else
		xSeqP = 1
		AntPed := DSC9->C6_FILIAL+DSC9->D2_PEDIDO+DSC9->D2_ITEMPV+DSC9->C6_PRODUTO
	endif
	SC9->C9_SEQUEN  = Strzero(xSeqP,2,0)
	SC9->C9_GRUPO   = DSC9->D2_GRUPO
	SC9->C9_PRCVEN  = DSC9->D2_PRCVEN
	SC9->C9_BLEST   = "10"
	SC9->C9_BLCRED  = "10"
	SC9->C9_LOCAL   = DSC9->D2_LOCAL
	SC9->C9_TPCARGA = "2"
	SC9->C9_NUMSEQ  = "999999"
	SC9->C9_X_TES   = DSC9->C6_TES
	MsUnLock()
	dbSelectArea(cAlias)
	(cAlias)->(dbSkip())
//	SA1->( dbSeek(xFilial("SA1")+(cAlias)->(A1_COD+A1_LOJA)) )
//	RecLock("SA1",.F.)
//	SA1->A1_GRPTRIB = "100"
//	MsUnLock()
//	dbSelectArea(cAlias)
//	(cAlias)->(dbSkip())
EndDo

If lQuery
	dbSelectArea(cAlias)
	dbCloseArea()
EndIf
Alert("Processo Finalizado." + chr(13)+chr(10) + "SC9 acertado. ")
Return
