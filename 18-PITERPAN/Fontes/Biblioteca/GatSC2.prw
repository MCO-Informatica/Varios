#Include "Protheus.ch"
#Include "TopConn.ch"

/*
FUNÇÃO DISPARADA PELA VALIDAÇÃO DE USUÁRIO NO CAMPO INFORMADO
*/
User Function GatSC2(cCampo)
	Local xRet    := .T.
	Local nProdTot := 0
	//Local cCodVen := ""
	//Local cCodCli := ""

	Default cCampo := ""

	If cCampo == "C2_PRODUTO"
		M->C2_MATPRIM := Substr(M->C2_PRODUTO,7,2)
		M->C2_COR     := GetCor(Substr(M->C2_PRODUTO,9,1))
		M->C2_GRAVTIN := RetGrvTin(M->C2_PRODUTO)
		M->C2_INFTRYO := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_INFTRYO")

		M->C2_PESOBRU := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_PESBRU")
		M->C2_PESOLIQ := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_PESO")
		M->C2_CAVIDAD := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_CAVIDAD")
		M->C2_CICLO   := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_CICLOPC")
		M->C2_PRODHOR := Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_PRODUCH")
		
		nProdTot	  := Round(M->C2_QUANT / M->C2_PRODHOR,2)
		M->C2_PRODTOT := nProdTot

		If Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XHRTING") > 0 
			M->C2_PRODTOT += Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_XHRTING")
		EndIf

		//U_CpPdvC2()


	ElseIf cCampo == "C2_PEDIDO"
		M->C2_XNOMEV  := Posicione("SC5",1,xFilial("SC5")+M->C2_PEDIDO,"C5_USUARIO")
		M->C2_CLIPV1  := Posicione("SC5",1,xFilial("SC5")+M->C2_PEDIDO,"C5_RAZSOCI")
		M->C2_QTDPV1  := QtdPdv1(M->C2_PEDIDO,M->C2_PRODUTO,M->C2_ITEMPV)

		CpoPdv1(M->C2_PEDIDO,M->C2_PRODUTO)

		nProdTot 	  := Round(M->C2_QUANT / M->C2_PRODHOR,2)

		If Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XHRTING") > 0 
			nProdTot += Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_XHRTING")
		EndIf

		M->C2_PRODTOT := noRound(nProdTot,0)+Val(Right(Str(nProdTot*100),2))*0.006


	EndIf

Return xRet


/*
RETORNA A COR CONFORME CODIGO DO PRODUTO, SEGUINDO O DOCUMENTO ENVIADO PELO CLIENTE
*/
Static Function GetCor(cCod)
	Local cCor   := ""

	Default cCod := "0"

	If cCod == "0"
		cCor := "Natural"
	EndIf

	If cCod == "1"
		cCor := "Branco"
	EndIf

	If cCod == "2"
		cCor := "Pintado"
	EndIf

	If cCod == "3"
		cCor := "Injetado na cor"
	EndIf

	If cCod == "4"
		cCor := "Estonado"
	EndIf
	
	If cCod == "5"
		cCor := "Pintado e estonado"
	EndIf

	If cCod == "6"
		cCor := "Perolado"
	EndIf

	If cCod == "7"
		cCor := "Preto"
	EndIf

	If cCod == "8"
		cCor := "Impresso"
	EndIf

	If cCod == "9"
		cCor := "Metalado"
	EndIf

	If cCod == "A"
		cCor := "Aluminado"
	EndIf

	If cCod == "B"
		cCor := "Banhado"
	EndIf

	If cCod == "C"
		cCor := "Cromado"
	EndIf

	If cCod == "D"
		cCor := "Madeira"
	EndIf
	
	If cCod == "E"
		cCor := "Especial, Escovado"
	EndIf

	If cCod == "F"
		cCor := "Fosco, Opaco"
	EndIf

	If cCod == "G"
		cCor := "Golden, Ouro"
	EndIf

	If cCod == "H"
		cCor := "Niquel Fosco, Holografia"
	EndIf

	If cCod == "I"
		cCor := "Impressão digital"
	EndIf

	If cCod == "J"
		cCor := "Esmaltado, Resinado"
	EndIf

	If cCod == "K"
		cCor := "Cromo"
	EndIf

	If cCod == "L"
		cCor := "Latao"
	EndIf

	If cCod == "M"
		cCor := "Militar"
	EndIf

	If cCod == "N"
		cCor := "Niquel"
	EndIf

	If cCod == "O"
		cCor := "Natural"
	EndIf

	If cCod == "P"
		cCor := "Polido"
	EndIf

	If cCod == "Q"
		cCor := "Chifre, Osso"
	EndIf

	If cCod == "R"
		cCor := "Estanho, Niquel Free"
	EndIf

	If cCod == "S"
		cCor := "Niquel Batido ou Escovado"
	EndIf

	If cCod == "T"
		cCor := "Transparente"
	EndIf

	If cCod == "U"
		cCor := "Fume, Grafite"
	EndIf

	If cCod == "V"
		cCor := "Ouro Velho"
	EndIf

	If cCod == "W"
		cCor := "Prata Velha"
	EndIf

	If cCod == "X"
		cCor := "Tartaruga"
	EndIf

	If cCod == "Y"
		cCor := "Tingido"
	EndIf

	If cCod == "Z"
		cCor := "Bronze"
	EndIf

Return Upper(cCor)

Return Upper(cCor)



/*
RETORNA A QUANTIDADE SOMADA DE TODOS OS ITENS DO PEDIDO DE VENDA
*/
Static Function QtdPdv1(cNum,cProd,cItem)
	Local nVal := 0
	Local cSql := ""

	Default cNum  := ""
	Default cProd := ""
	Default cItem := ""

	cSql := "SELECT SUM(SC6.C6_QTDVEN) QTDE FROM "+RetSqlName("SC6")+ " SC6 WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = '"+cNum+"' AND SC6.D_E_L_E_T_<>'*' AND SC6.C6_PRODUTO = '"+cProd+"' "+IIf(!Empty(cItem),"AND C6_ITEM = '"+cItem+"' ","")

	If Select("QC6") > 0
		QC6->(DbCloseArea())
	EndIf

	TcQuery ChangeQuery(cSql) New Alias "QC6"

	nVal := QC6->QTDE

	If Select("QC6") > 0
		QC6->(DbCloseArea())
	EndIf

Return nVal


/*
RETORNA O CODIGO DO ACABAMENTO
*/

Static Function RetGrvTin(cProd)
	Local cAux1 := ""
	Local cAux2 := ""
	Local cSql  := ""
	Local cRet  := ""

	Default cProd := ""

	cAux1 := Substr(cProd,11,1)
	cAux2 := Substr(cProd,9,1)
	cAux3 := Right(AllTrim(cProd),4)


	If (cAux1 $ "1,3,6,7,9,0,D,F,Q,T,X" .OR. cAux2 $ "1,3,6,7,9,0,D,F,Q,T,X" .OR. Right(AllTrim(cProd),3) == "INJ" .OR. Right(AllTrim(cProd),1) $ "F,M,A,B,C,D,E")
		cRet := "01"
	EndIf

	If cAux1 == "Y" .OR. cAux2 == "Y" .OR. Right(AllTrim(cProd),4) $ "FERV,TING"
		cRet := "02"
	EndIf

	If cAux1 == "8" .OR. cAux2 == "8" .OR. Right(AllTrim(cProd),4) == 'TAMP'
		cRet := "03"
	EndIf

	If cAux1 == "2" .OR. cAux2 == "2"
		cRet := "04"
	EndIf

	If cAux1 == "4" .OR. cAux2 == "4"
		cRet := "05"
	EndIf

	If cAux1 $ "8" .OR. cAux2 $ "8" .OR. Right(AllTrim(cProd),3) == 'HOT'
		cRet := "08"
	EndIf

	If cAux1 $ "A,B,C,E,G,H,K,M,N,P,R,S,U,V,W,Z" .OR. cAux2 $ "A,B,C,E,G,H,K,M,N,P,R,S,U,V,W,Z"
		cRet := "09"
	EndIf

	If cAux1 $ "L" .OR. cAux2 $ "L"
		cRet := "10"
	EndIf

	If cAux1 $ "O" .OR. cAux2 $ "O"
		cRet := "11"
	EndIf

	If cAux1 $ "I" .OR. cAux2 $ "I" .OR. Right(AllTrim(cProd),3) == 'IMP'
		cRet := "12"
	EndIf

	If SC2->C2_SEQUEN == '001'
	
		cSql := "SELECT * FROM "+RetSqlName("SG1")+ " SG1 "
		cSql += "JOIN "+RetSqlName("SB1")+ " SB1 ON (SB1.B1_COD = SG1.G1_COD OR SB1.B1_COD = SG1.G1_COMP) AND SB1.D_E_L_E_T_<>'*' AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO = 'PP' "
		cSql += "WHERE (SG1.G1_COD = '"+cProd+"' OR SG1.G1_COMP LIKE '%"+cProd+"%') AND SG1.G1_FILIAL = '"+xFilial("SG1")+"' "

		If Select("QRY") > 0
			QRY->(DbCloseArea())
		EndIf
		TcQuery ChangeQuery(cSql) New Alias "QRY"

		If !Empty(QRY->B1_TIPO) .OR. Right(AllTrim(cProd),4) == 'MONT'
			cRet := "06"
		EndIf

		If Select("QRY") > 0
			QRY->(DbCloseArea())
		EndIf

	EndIf

	If At("DESG",AllTrim(cProd)) > 0
		cRet := "07"
	EndIf

	If SC2->C2_SEQUEN == '001' //At("INJ",AllTrim(cProd)) > 0
	//cRet := "13"
	
	cSql := "SELECT * FROM "+RetSqlName("SB1")+ " SB1 "
	cSql += "WHERE SB1.D_E_L_E_T_<>'*' AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO = 'PA' "
	cSql += "AND SB1.B1_COD = '"+cProd+"' "

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
	TcQuery ChangeQuery(cSql) New Alias "QRY"

	If !Empty(QRY->B1_COD)
		cRet := "13"
	EndIf

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf


	EndIf


Return cRet




Static Function CpoPdv1(cNum,cProd,cItem)
	Local nVal := 0
	Local cSql := ""

	Default cNum  := ""
	Default cProd := ""
	Default cItem := ""

	cSql := "SELECT * FROM "+RetSqlName("SC6")+ " SC6 WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = '"+cNum+"' AND SC6.D_E_L_E_T_<>'*' AND SC6.C6_PRODUTO = '"+cProd+"' "+IIf(!Empty(cItem),"AND C6_ITEM = '"+cItem+"' ","")

	If Select("QC6") > 0
		QC6->(DbCloseArea())
	EndIf

	TcQuery ChangeQuery(cSql) New Alias "QC6"

	M->C2_XACAB   := QC6->C6_ACAB
	M->C2_XTON    := QC6->C6_TON
	M->C2_XCODCOR := QC6->C6_CODCOR
	M->C2_XTABCOR := QC6->C6_TABCOR
	M->C2_XOBS    := QC6->C6_OBS
	M->C2_OBS     := QC6->C6_OBS


	If Select("QC6") > 0
		QC6->(DbCloseArea())
	EndIf

Return Nil
