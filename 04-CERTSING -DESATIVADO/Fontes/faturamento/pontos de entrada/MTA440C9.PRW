#Include "PROTHEUS.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA440C9  ºAutor  ³Microsiga           º Data ³  10/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para atualização do valor de venda das     º±±
±±º          ³mídias para estados com retenção de ICMS                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento do varejo                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MTA440C9  
Local aAlias:=GetArea()
Local aAliasSc6:=sc6->(getarea())
Local aAliasSc5:=sc5->(getarea())

//MsAguarde( {|| fa410Impos()}, "Inclusão de Pedido", "Computando impostos...",.F.)
fa410Impos()

RestArea(aAliasSc6)
RestArea(aAliasSc5)
RestArea(aAlias)

Return




/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MA410Impos³ Autor ³ Eduardo Riera         ³ Data ³06.12.2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ma410Impos( nOpc)                                            ³±±
±±³          ³Funcao de calculo dos impostos contidos no pedido de venda   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nOpc                                                        ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta funcao efetua os calculos de impostos (ICMS,IPI,ISS,etc)³±±
±±³          ³com base nas funcoes fiscais, a fim de possibilitar ao usua- ³±±
±±³          ³rio o valor de desembolso financeiro.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fa410Impos( nOpc )

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aFisGet	:= {}
Local aFisGetSC5:= {}
Local aTitles   := {"Nota Fiscal","Duplicatas","Rentabilidade"} 
Local aDupl     := {}
Local aVencto   := {}
Local aFlHead   := { "Vencimento","Valor","..." }
Local aEntr     := {}
Local aDuplTmp  := {}
Local aRFHead   := { RetTitle("C6_PRODUTO"),RetTitle("C6_VALOR"),"C.M.V","Vlr.Presente","Lucro Bruto","Margem de Contribuição(%)"}
Local aRentab   := {}
//Local nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
//Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
//Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
//Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
//Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
//Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
//Local nPDtEntr  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
//Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
//Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
//Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
//Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
//Local nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
//Local nPIdentB6 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_IDENTB6"})
//Local nPItem    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local nPSuframa := 0
//Local nUsado    := Len(aHeader)
Local nX        := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nDesconto := 0
Local nAcresFin := 0
Local nQtdPeso  := 0
Local nRecOri   := 0
Local nPosEntr  := 0
Local nItem     := 0
Local nY        := 0 
Local nPosCpo   := 0
Local lDtEmi    := SuperGetMv("MV_DPDTEMI",.F.,.T.)
Local dDataCnd  := SC5->C5_EMISSAO
Local oDlg
Local oDupl
Local oFolder
Local oRentab
Local lCondVenda := .F. // Template GEM
Local aRentabil := {}
Local cProduto  := ""
Local nTotDesc  := 0
Local nQtdEnt   := 0
Local aSolid	:= {}
Local cCategoSFW	:= GetNewPar("MV_GARSFT", "2")
Local cCategoHRD	:= GetNewPar("MV_GARHRD", "1")
Local cTESPermit	:= GetNewPar("MV_XF440IM","800;801") //TES Permitidos para realizar procedimento
Local nSomatoria	:= 0
Local nDiferenca	:= 0
Local nItensAptos	:= 0
Local nSumMerc		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC6                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFisGet	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While !Eof().And.X3_ARQUIVO=="SC6"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC5                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFisGetSC5	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof().And.X3_ARQUIVO=="SC5"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

dbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xfilial('SC5')+SC6->C6_NUM)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa a funcao fiscal                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataCnd  := SC5->C5_EMISSAO

MaFisSave()
MaFisEnd()
MaFisIni(Iif(Empty(SC5->C5_CLIENT),SC5->C5_CLIENTE,SC5->C5_CLIENT),;// 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
	IIf(SC5->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	SC5->C5_TIPO,;				// 4-Tipo da NF
	SC5->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza alteracoes de referencias do SC5         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aFisGetSC5) > 0
	dbSelectArea("SC5")
	For nY := 1 to Len(aFisGetSC5)
		If !Empty(&("SC5->"+Alltrim(aFisGetSC5[ny][2])))
			MaFisAlt(aFisGetSC5[ny][1],&("SC5->"+Alltrim(aFisGetSC5[ny][2])),,.F.)
		EndIf
	Next nY
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Agrega os itens para a funcao fiscal         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xfilial("SC6")+SC5->C5_NUM)

While !EOF().AND. SC5->C5_FILIAL+SC5->C5_NUM==SC6->C6_FILIAL+SC6->C6_NUM

	If !(SC6->C6_TES $ cTESPermit)
		SC6->(dbSkip())
		Loop
	EndIf

	nQtdPeso := 0
	nItem++
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona Registros                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nQtdEnt := SC6->C6_QTDVEN
	cProduto:= SC6->C6_PRODUTO
	MatGrdPrRf(@cProduto)

	SB1->(dbSetOrder(1))
	If SB1->(MsSeek(xFilial("SB1")+cProduto))
		nQtdPeso := nQtdEnt*SB1->B1_PESO
	EndIf                               

	SB2->(dbSetOrder(1))
    SB2->(MsSeek(xFilial("SB2")+SB1->B1_COD+SC6->C6_LOCAL))

    SF4->(dbSetOrder(1))
    SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula o preco de lista                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValMerc  := SC6->C6_VALOR
	nPrcLista := SC6->C6_PRCVEN
     
	nAcresFin := A410Arred(SC6->C6_PRCVEN*SC5->C5_ACRSFIN/100,"D2_PRCVEN")
	nValMerc  += A410Arred(SC6->C6_QTDVEN*nAcresFin,"D2_TOTAL")
	nDesconto := a410Arred(nPrcLista*SC6->C6_QTDVEN,"D2_DESCON")-nValMerc
	nDesconto := IIf(nDesconto==0,SC6->C6_VALDESC,nDesconto)
	nDesconto := Max(0,nDesconto)
	nPrcLista += nAcresFin
	nValMerc  += nDesconto

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a data de entrega para as duplicatas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dDataCnd  := SC5->C5_EMISSAO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Agrega os itens para a funcao fiscal         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAdd(cProduto,;   	// 1-Codigo do Produto ( Obrigatorio )
	SC6->C6_TES,;	    	// 2-Codigo do TES ( Opcional )
	SC6->C6_QTDVEN,;    	// 3-Quantidade ( Obrigatorio )
	nPrcLista,;		  	    // 4-Preco Unitario ( Obrigatorio )
	nDesconto,; 	        // 5-Valor do Desconto ( Opcional )
	"",;	   			    // 6-Numero da NF Original ( Devolucao/Benef )
	"",;				    // 7-Serie da NF Original ( Devolucao/Benef )
	nRecOri,;				// 8-RecNo da NF Original no arq SD1/SD2
	0,;					    // 9-Valor do Frete do Item ( Opcional )
	0,;					    // 10-Valor da Despesa do item ( Opcional )
	0,;			   		    // 11-Valor do Seguro do item ( Opcional )
	0,;					    // 12-Valor do Frete Autonomo ( Opcional )
	nValMerc,;			    // 13-Valor da Mercadoria ( Obrigatorio )
	0)					    // 14-Valor da Embalagem ( Opiconal )	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo do ISS                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF4->(dbSetOrder(1))
	SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
	If ( SC5->C5_INCISS == "N" .And.SC5->C5_TIPO == "N")
		If ( SF4->F4_ISS=="S" )
			nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
			nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
			MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
			MaFisAlt("IT_VALMERC",nValMerc,nItem)
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Altera peso para calcular frete              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAlt("IT_PESO",nQtdPeso,nItem)
	MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
	MaFisAlt("IT_VALMERC",nValMerc,nItem)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analise da Rentabilidade                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SF4->F4_DUPLIC=="S"
		nTotDesc += MaFisRet(nItem,"IT_DESCONTO")
		nY := aScan(aRentab,{|x| x[1] == SC6->C6_PRODUTO})
		If nY == 0
			aadd(aRenTab,{SC6->C6_PRODUTO,0,0,0,0,0})
			nY := Len(aRenTab)
		EndIf
		aRentab[nY][2] += (nValMerc - nDesconto)
		aRentab[nY][3] += SC6->C6_QTDVEN*SB2->B2_CM1
	Else
		If GetNewPar("MV_TPDPIND","1")=="1"
			nTotDesc += MaFisRet(nItem,"IT_DESCONTO")
		EndIf
	EndIf

     SC6->(DbSkip())
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indica os valores do cabecalho               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisAlt("NF_FRETE",SC5->C5_FRETE)
MaFisAlt("NF_VLR_FRT",SC5->C5_VLR_FRT)
MaFisAlt("NF_SEGURO",SC5->C5_SEGURO)
MaFisAlt("NF_AUTONOMO",SC5->C5_FRETAUT)
MaFisAlt("NF_DESPESA",SC5->C5_DESPESA)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indenizacao por valor                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC5->C5_DESCONT > 0
	MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nTotDesc+SC5->C5_DESCONT),/*nItem*/,/*lNoCabec*/,/*nItemNao*/,GetNewPar("MV_TPDPIND","1")=="2" )
EndIf

If SC5->C5_PDESCAB > 0
	MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*SC5->C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza alteracoes de referencias do SC6         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
If Len(aFisGet) > 0
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xfilial("SC6")+SC5->C5_NUM)
	nX := 0
	While !EOF().AND. SC5->C5_FILIAL+SC5->C5_NUM==SC6->C6_FILIAL+SC6->C6_NUM

		If !(SC6->C6_TES $ cTESPermit)
			SC6->(dbSkip())
			Loop
		EndIf
	
	    nX++
		For nY := 1 to Len(aFisGet)
			MaFisAlt(aFisGet[ny][1],&("SC6->"+Alltrim(aFisGet[ny][2])),nX,.F.)
		Next nX
	SC6->(DbSkip())
	EndDo
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza alteracoes de referencias do SC5 Suframa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPSuframa:=aScan(aFisGetSC5,{|x| x[1] == "NF_SUFRAMA"})
If !Empty(nPSuframa)
	dbSelectArea("SC5")
	If !Empty(&("SC5->"+Alltrim(aFisGetSC5[nPSuframa][2])))
		MaFisAlt(aFisGetSC5[nPSuframa][1],Iif(&("SC5->"+Alltrim(aFisGetSC5[nPSuframa][2])) == "1",.T.,.F.),nItem,.F.)
	EndIf
Endif

MaFisWrite(1)

nBaseICM	:= MaFisRet(,"NF_BASEICM")
nValdup		:= MaFisRet(,"NF_BASEDUP")
nValSol		:= MaFisRet(,"NF_VALSOL")
nValIPI		:= MaFisRet(,"NF_VALIPI")
nValFrete	:= MaFisRet(,"NF_FRETE")
nValSeguro	:= MaFisRet(,"NF_SEGURO") 
nValDesconto:= MaFisRet(,"NF_DESCONTO")	
nValAltonomo:= MaFisRet(,"NF_AUTONOMO")	
nValDespesa	:= MaFisRet(,"NF_DESPESA")
nValTotal	:= MaFisRet(,"NF_TOTAL")
nBaseISS	:= MaFisRet(,"NF_BASEISS") 
                                       
nIndice:= Round(nBaseICM/(nValTotal-nBaseISS),4)

//Calculo a somatoria para cruzar no final
/*For nGet := 1 To Len(aCols)
	If aCols[nGet][aScan(aHeader, {|z| AllTrim(z[2]) == "C6_TES"})] $ cTESPermit
		nSomatoria += aCols[nGet][aScan(aHeader, {|z| AllTrim(z[2]) == "C6_PRCVEN"})] * aCols[nGet][aScan(aHeader, {|z| AllTrim(z[2]) == "C6_QTDVEN"})]
		nItensAptos++
	EndIf 
Next*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualizar valor unitário do produto de acordo com indice³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xfilial("SC6")+SC5->C5_NUM)
nItem:=0
While !EOF().AND. SC5->C5_FILIAL+SC5->C5_NUM==SC6->C6_FILIAL+SC6->C6_NUM
    
    If !(SC6->C6_TES $ cTESPermit)
    	U_GTPutOUT(SC5->C5_NUM,"I",SC5->C5_NUM+SC6->C6_ITEM,{"TES_NO_ICMS",{.F.,"E00025",SC5->C5_NUM+SC6->C6_ITEM,"TES não permite cálculo de ICMS-ST: " + SC6->C6_TES}},iif( empty(alltrim(SC5->C5_XNPSITE)), SC5->C5_NUM+SC6->C6_ITEM, SC5->C5_XNPSITE))    
		SC6->(dbSkip())
		Loop
	EndIf
    
    nItem++

    nValfretItem  := MaFisRet(nItem,"IT_FRETE") //Valor de frete para item
    nValTotalItem := SC6->C6_VALOR //Valor total do Produto sem o frete
    nValUnitItem  := ((nValTotalItem* nIndice) +(nValfretItem*nIndice)-nValfretItem)/SC6->C6_QTDVEN //Novo valor unitáiro do intem sem o frete
    
    MaFisAlt("IT_PRCUNI",nValUnitItem,nItem)
    MaFisAlt("IT_VALMERC",nValUnitItem * SC6->C6_QTDVEN,nItem)
    MaFisRecal(,nItem)

    //nSumMerc += MaFisRet(nItem,"IT_PRCUNI")
    
	SB1->(dbSetOrder(1))	
	If SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO)) .AND. ALLTRIM(cCategoHRD) == ALLTRIM(SB1->B1_CATEGO) .AND. SC9->C9_PEDIDO==SC6->C6_NUM .AND. SC9->C9_ITEM==SC6->C6_ITEM 	 
	  	
	  	/*If nItem > 1 .And. Len(aCols) > 1  	
	  		nDiferenca += (MaFisRet(,"NF_BASEICM") - (nSomatoria - MaFisRet(,"NF_VALSOL"))) / SC6->C6_QTDVEN
	  	EndIf*/
	  	
	  	U_GTPutOUT(SC5->C5_NUM,"I",SC5->C5_NUM+SC6->C6_ITEM,{"TES_ICMS_ST",{.F.,"M00004",SC5->C5_NUM+SC6->C6_ITEM,"TES deve calcular ICMS-ST: " + SC6->C6_TES}},iif( empty(alltrim(SC5->C5_XNPSITE)), SC5->C5_NUM+SC6->C6_ITEM, SC5->C5_XNPSITE))
	  	
	  	If MaFisRet(nItem,"IT_VALMERC") + MaFisRet(nItem,"IT_VALSOL") <> SC6->C6_VALOR
	  		nDiferenca := SC6->C6_VALOR - ( MaFisRet(nItem,"IT_VALMERC") + MaFisRet(nItem,"IT_VALSOL") )
	  		nValUnitItem := (MaFisRet(nItem,"IT_VALMERC") + nDiferenca) / SC6->C6_QTDVEN
	  	EndIf
	  	
	    Reclock('SC9',.F.)
	    	SC9->C9_PRCVEN := nValUnitItem
	    Msunlock()

   	    Reclock('SC6',.F.)
   	    	SC6->C6_PRUNIT := nValUnitItem
	    Msunlock()

	    U_GTPutOUT(SC5->C5_NUM,"I",SC5->C5_NUM+SC6->C6_ITEM,{"TES_ICMS_ST",{.F.,"M00004",SC5->C5_NUM+SC6->C6_ITEM,"Pedido gravou alterações de valor unitário."}},iif( empty(alltrim(SC5->C5_XNPSITE)), SC5->C5_NUM+SC6->C6_ITEM, SC5->C5_XNPSITE))
	    
	    //aCols[n][aScan(aHeader, {|z| AllTrim(z[2]) == "C6_PRCVEN"})] := nValUnitItem
	    //aCols[n][aScan(aHeader, {|z| AllTrim(z[2]) == "C6_PRUNIT"})] := nValUnitItem

	    MaFisAlt("IT_PRCUNI",nValUnitItem,nItem)
	    MaFisAlt("IT_VALMERC",nValUnitItem * SC6->C6_QTDVEN,nItem)
    	MaFisRecal(,nItem)

    	U_GTPutOUT(SC5->C5_NUM,"I",SC5->C5_NUM+SC6->C6_ITEM,{"MEMFISCAL",{.F.,"M00004",SC5->C5_NUM+SC6->C6_ITEM,;
    		"IT_PRCUNI:  " + cValToChar(MaFisRet(nItem,"IT_PRCUNI")) + CHR(13)+CHR(10)+;
    		"IT_VALMERC: " + cValToChar(MaFisRet(nItem,"IT_VALMERC")) + CHR(13)+CHR(10)+;
    		"IT_VALSOL:  " + cValToChar(MaFisRet(nItem,"IT_VALSOL"))}},iif( empty(alltrim(SC5->C5_XNPSITE)), SC5->C5_NUM+SC6->C6_ITEM, SC5->C5_XNPSITE))

    Else
    	U_GTPutOUT(SC5->C5_NUM,"I",SC5->C5_NUM+SC6->C6_ITEM,{"SEMALTERACAO",{.F.,"E00025",SC5->C5_NUM+SC6->C6_ITEM,"Não entrou na alteração: " +;
    		"Filial SB1:" + xFilial("SB1") + CHR(13)+CHR(10)+;
    		"Produto:   " + SC6->C6_PRODUTO + CHR(13)+CHR(10)+;
    		"Categoria: " + ALLTRIM(cCategoHRD) + "/" + ALLTRIM(SB1->B1_CATEGO) + CHR(13)+CHR(10)+;
    		"Pedido:    " + SC9->C9_PEDIDO +"/" + SC6->C6_NUM + CHR(13)+CHR(10)+;
    		"Item:      " + SC9->C9_ITEM+"/"+SC6->C6_ITEM}},iif( empty(alltrim(SC5->C5_XNPSITE)), SC5->C5_NUM+SC6->C6_ITEM, SC5->C5_XNPSITE))
	Endif
	SC6->(DbSkip())
EndDo

MaFisEnd()
MaFisRestore()

RestArea(aAreaSA1)
RestArea(aArea)
Return(.T.)
