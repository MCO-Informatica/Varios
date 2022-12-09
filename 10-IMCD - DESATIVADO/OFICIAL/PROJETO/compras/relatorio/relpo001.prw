#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELPO001  º Autor ³Junior Carvalho     º Data ³  20/08/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio Pedidos de Compra                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELPO001()

Local aItensExcel := {}
Local aPergs := {}
Local cTitulo := "Relação Pedidos de Compras"
Private lRet := .F.
Private aRet := {}

aAdd( aPergs ,{1,"Filial De            ",Space(02),"@!",'.T.',"XM0",'.T.',60,.F.})
aAdd( aPergs ,{1,"Filial Ate           ",Space(02),"@!",'.T.',"XM0",'.T.',60,.T.})
Aadd( aPergs ,{1,"Emissao De           ",FirstDate(dDatabase) ,"@E 99/99/9999","","","",100,.F.})
Aadd( aPergs ,{1,"Emissão Ate          ",LastDate(dDatabase)  ,"@E 99/99/9999","","","",100,.T.})

If ParamBox(aPergs ," Parametros - "+cTitulo,aRet)
		
	MsgRun("Favor Aguardar.....", "Selecionando os Registros... "+cTitulo,{|| GeraItens(@aItensExcel)})
	if lRet
		MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{|| GERAEXCEL()})
	Else
		Aviso( cTitulo,"Nenhum dado gerado! Verifique os parametros utilizados.",{"OK"},3)
	Endif
	
Else
	Aviso(cTitulo,"Pressionado Cancela",{"OK"},1)
EndIf

Return()

Static Function GeraItens( aCols )

Local cAlias := GetNextAlias()
Local cQuery   := ""

cQuery := "SELECT PO.C7_FILIAL,C7_NUM,A2_COD, A2_LOJA, FORN.A2_NREDUZ,C7_ITEM ,C7_PRODUTO ,C7_DESCRI, "
cQuery += " SUBSTR(C7_EMISSAO,7,2)||'/'||SUBSTR(C7_EMISSAO,5,2)||'/'||SUBSTR(C7_EMISSAO,1,4) EMISSAO, "
cQuery += " SUBSTR(C7_EMISSAO,5,2) MES,  C7_NUMIMP ,PO.C7_QUANT, PO.C7_IPI,
cQuery += " PO.C7_MOEDA ,PO.C7_TXMOEDA , PO.C7_PRECO ,PO.C7_TOTAL , "
cQuery += " CASE WHEN C7_MOEDA > 1 THEN (PO.C7_TOTAL * C7_TXMOEDA) ELSE PO.C7_TOTAL END * ( 1+(C7_IPI/100)) AS TOTALREAIS "
cQuery += " FROM "+RETSQLNAME("SC7")+"  PO , "+RETSQLNAME("SA2")+"  FORN "
cQuery += " WHERE A2_COD ||A2_LOJA = C7_FORNECE||C7_LOJA AND FORN.D_E_L_E_T_ <> '*' "
cQuery += " AND SUBSTR( PO.C7_PRODUTO ,1,2) = 'MR' "
cQuery += " AND C7_EMISSAO BETWEEN '"+DTOS(aRet[3])+"' AND '"+DTOS(aRet[4])+"' "
cQuery += " AND C7_FILIAL BETWEEN '"+aRet[1]+"' AND '"+aRet[2]+"' "
cQuery += " AND PO.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY C7_FILIAL , C7_EMISSAO "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias,'QUANTIDADE','N',16,4)
TcSetField(cAlias,'CUSTO','N',16,4)
TcSetField(cAlias,'EMISSAO','D',8,0)

DbSelectArea(cAlias)
(cAlias)->(DbGoTop())
ProcRegua(RecCount())

While !(cAlias)->(EOF())
	
	IncProc(" Pedido nº " + (cAlias)->C7_NUM + " . . .")
	
	aAdd(aCOLSINI,{(cAlias)->C7_FILIAL , (cAlias)->C7_NUM,(cAlias)->A2_COD,(cAlias)-> A2_LOJA,(cAlias)->A2_NREDUZ,;
	(cAlias)->C7_ITEM,(cAlias)->C7_PRODUTO,(cAlias)->C7_DESCRI,(cAlias)->EMISSAO,(cAlias)->MES,(cAlias)->C7_NUMIMP,;
	(cAlias)->C7_QUANT,(cAlias)->C7_IPI,(cAlias)->C7_MOEDA,(cAlias)->C7_TXMOEDA,(cAlias)->C7_PRECO,(cAlias)->C7_TOTAL,;
	(cAlias)->TOTALREAIS })
		
	(cAlias)->(DbSkip())
	lRet := .T.
	
EndDo

(cAlias)->(DbCloseArea())
MsErase(cAlias)
Return()

Static Function GERAEXCEL()
Local ni := 0
Local nj := 0
PRIVATE oExcel := FWMSEXCEL():New()
cTab := 'Pedidos de Compra - Periodo de '+DTOC(DDATAINI)+" ate "+DTOC(DDATAFIM)

aAdd( aHEADINI, { "Filial", "C","@!" })
aAdd( aHEADINI, { "Número PC",  "C","@!" })
aAdd( aHEADINI, { "Cod. Fornec",  "C","@!" })
aAdd( aHEADINI, { "Loja fornec", "C","@!" })
aAdd( aHEADINI, { "Nome fantasia", "C","@!" })
aAdd( aHEADINI, { "Item" , "C","@!" })
aAdd( aHEADINI, { "Cod. Produto" , "C","@!" })
aAdd( aHEADINI, { "Descrição" , "C","@!" })
aAdd( aHEADINI, { "Data emissão", "C","@!"})
aAdd( aHEADINI, { "Mês", "C","@!" })
aAdd( aHEADINI, { "PO Number EIC" , "C","@!" })
aAdd( aHEADINI, { "Quantidade", "N","@E 999,999,999.99"})
aAdd( aHEADINI, { "IPI", "N","@E 999.99"})
aAdd( aHEADINI, { "Moeda", "N","@E 999.99"})
aAdd( aHEADINI, { "Taxa moeda", "N","@E 999.99"})
aAdd( aHEADINI, { "Valor unitário", "N","@E 999,999.99"})
aAdd( aHEADINI, { "Total pedido moeda", "N","@E 999,999,999.99"})
aAdd( aHEADINI, { "Total em reais", "N","@E 999,999,999.99"})


oExcel:AddworkSheet(cPlan)
oExcel:AddTable(cPlan,cTab)
aCab := ACLONE(aHEADINI)
aItens := ACLONE(aCOLSINI)


For ni := 1 to len(aCab)
	nAl := 1 // Alinha: Esquerda
	nTp := 1 // Tipo: Normal
	If aCab[ni,2] == "D"
		nAl := 2 // Alinha: Centralizado
		nTp := 4 // Tipo: Data
	ElseIf aCab[ni,2] == "L"
		nAl := 2 // Alinha: Centralizado
		nTp := 1 // Tipo: Normal
	ElseIf aCab[ni,2] == "N"
		nAl := 3 // Alinha: Direita
		nTp := 2 // Tipo: Numero
	EndIf
	oExcel:AddColumn(cPlan,cTab,aCab[ni,1],nAl,nTp)
Next

For ni := 1 to len(aItens)
	
	aColunas := {}
	For nj := 1 to len(aItens[ni])-1
		If aCab[nj,2] == "C"
			aAdd(aColunas,Transform(aItens[ni,nj],aCab[nj,3]))
		ElseIf aCab[nj,2] $ "N/D"
			aAdd(aColunas,aItens[ni,nj])
		ElseIf aCab[nj,2] == "L"
			aAdd(aColunas,IIf(aItens[ni,nj],".T.",".F."))
		EndIf
	Next
	If len(aColunas) > 0
		oExcel:AddRow(cPlan,cTab,aColunas)
	EndIf
	
Next


oExcel:Activate()
//cArq := &("cGetFile( '*.xml' , '*.xml' , 1 , 'SERVIDOR' , .F. , "+str(nOR( GETF_LOCALHARD , GETF_LOCALFLOPPY , GETF_RETDIRECTORY ))+" , .T. , .T. )")
cArqXml := Alltrim(MV_PAR04)+"FILIAL_"+CFILANT+"_"+cCodAri+MV_PAR01+Substr(MV_PAR02,3,2)+".XML"

If !Empty(cArqXml)
	oExcel:GetXMLFile(cArqXml)
	MsgAlert("Arquivo gerado com sucesso!"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+cArqXml,"ANP")
	If !ApOleClient("MsExcel")
		MsgStop("Microsoft Excel não instalado!","Atencao")
		Return
	EndIf
	oExcelVer:= MsExcel():New()
	oExcelVer:WorkBooks:Open(cArqXml)
	oExcelVer:SetVisible(.T.)
EndIf

Return()
