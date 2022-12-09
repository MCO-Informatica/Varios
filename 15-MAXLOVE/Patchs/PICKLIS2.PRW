#Include 'Protheus.ch'
#Include 'Rwmake.ch'
#INCLUDE 'TOPCONN.CH'

User Function PICKLIS2()

Local oReport
Local cPerg		:= Padr( "PICKLIST", LEN( SX1->X1_GRUPO ) )
Local cAlias 	:= "SC9"

Pergunte(cPerg,.f. )

oReport := reportDef(cAlias, cPerg)
oReport:printDialog()

return


//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "P I C K - L I S T   M A X L O V E   (PRODUCAO)"
local cHelp   := "Emissao de produtos a serem separados para determinada faixa de pedidos."
local oReport
local oSection1

oReport := TReport():New('PICKLIST',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

//Primeira seção
oSection1 := TRSection():New(oReport,"Pick-List",{"TMPSC9","SC5"})

TRCell():New(oSection1,"C5_X_EMPFA"		, "TMPSC9", "Filial"			,"@!"				,04		)
TRCell():New(oSection1,"C9_DATALIB"		, "TMPSC9", "Data"		,PesqPict("SC9","C9_DATALIB")	,15	)
TRCell():New(oSection1,"C9_PEDIDO"		, "TMPSC9", "Pedido"			,"@!"				,10		)
TRCell():New(oSection1,"A1_NOME"		, "TMPSC9", "Cliente"			,"@!"				,35		)
TRCell():New(oSection1,"C9_ITEM"		, "TMPSC9", "It"				,"@!"				,04		)
TRCell():New(oSection1,"C6_KIT"			, "TMPSC9", "Kit"				,"@!"				,02		)
TRCell():New(oSection1,"C9_PRODUTO"		, "TMPSC9", "Codigo"			,"@!"				,20		)
TRCell():New(oSection1,"B1_DESC"		, "TMPSC9", "Desc.Material"		,"@!"				,100		)
TRCell():New(oSection1,"B1_UM"			, "TMPSC9", "UM"				,"@!"				,02		)
TRCell():New(oSection1,"NQTDE"			, "TMPSC9", "Quantidade"		,PesqPict('SC6','C6_QTDVEN'),10	)
TRCell():New(oSection1,"C9_LOCAL"		, "TMPSC9", "Amz"				,"@!"				,02		)
TRCell():New(oSection1,"C9_LOTECTL"		, "TMPSC9", "Lote"				,"@!"				,25		)
TRCell():New(oSection1,"C9_DTVALID"		, "TMPSC9", "Validade"	,PesqPict("SC9","C9_DTVALID")	,15	)
TRCell():New(oSection1,"C9_BLEST"		, "TMPSC9", "Blq"				,"@!"				,04		)
TRCell():New(oSection1,"C5_PEDECOM"		, "TMPSC9", "Origem"			,"@!"				,04		)

oReport:SetTotalInLine(.F.)

//TRFunction():New(oSection1:Cell("NQTDE"),"QTD GERAL" ,"SUM",,,"@E 999,999,999.99",,.F.,.T.)

TRPosition():New(oSection1,"SC5",1,{|| xFilial("SC5")+TMPSC9->C9_PEDIDO})


Return(oReport)


//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)


Local oSection1 	:= oReport:Section(1)
Local cQuery			:= ""
Local cRepTit		:= oReport:Title()
Local cTitulo		:= oReport:Title() 

Local lUsaLocal  	:= (SuperGetMV("MV_LOCALIZ") == "S")
Local cAliasNew		:= "TMPSC9"
Local aStruSC9 		:= SC9->(dbStruct())
Local cEndereco 	:= ""
Local nQtde     	:= 0

cQuery := "SELECT SA1.A1_NOME,SC9.R_E_C_N_O_ SC9REC, "
cQuery += "SC5.C5_X_EMPFA,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_FILIAL,SC9.C9_QTDLIB,SC9.C9_PRODUTO, "
cQuery += "SC9.C9_LOCAL,SC9.C9_LOTECTL,SC9.C9_POTENCI, SC6.C6_KIT, SC9.C9_DATALIB, "
cQuery += "SC9.C9_NUMLOTE,SC9.C9_DTVALID,SC9.C9_NFISCAL,SC9.C9_BLEST,SC5.C5_PEDECOM,SC5.C5_X_USERS "

If lUsaLocal
	cQuery += ",SDC.DC_LOCALIZ,SDC.DC_QUANT,SDC.DC_QTDORIG"
EndIf
cQuery += " FROM "
cQuery += RetSqlName("SC9") + " SC9 "
If lUsaLocal
	cQuery += "LEFT JOIN "+RetSqlName("SDC") + " SDC "
	cQuery += "ON SDC.DC_PEDIDO=SC9.C9_PEDIDO AND SDC.DC_ITEM=SC9.C9_ITEM AND SDC.DC_SEQ=SC9.C9_SEQUEN AND SDC.D_E_L_E_T_ = ' ' "
EndIf
cQuery += "INNER JOIN "+RetSqlName("SA1") + " SA1 "
cQuery += "ON SA1.A1_COD = SC9.C9_CLIENTE AND SA1.A1_LOJA = SC9.C9_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("SC5") + " SC5 "
cQuery += "ON SC5.C5_NUM = SC9.C9_PEDIDO AND SC5.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("SC6") + " SC6 "
cQuery += "ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC6.D_E_L_E_T_ = ' ' "
cQuery += "WHERE SC9.C9_FILIAL  = '"+xFilial("SC9")+"'"
cQuery += " AND  SC9.C9_PEDIDO >= '"+mv_par01+"'"
cQuery += " AND  SC9.C9_PEDIDO <= '"+mv_par02+"'"
cQuery += " AND  SC9.C9_DATALIB >= '"+DTOS(mv_par03)+"'"
cQuery += " AND  SC9.C9_DATALIB <= '"+DTOS(mv_par04)+"'"
cQuery += " AND  SC9.C9_NFISCAL = '' "
cQuery += " AND SC9.D_E_L_E_T_ = ' '"
cQuery += "ORDER BY SC5.C5_X_EMPFA,SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_PRODUTO,SC9.C9_LOTECTL,"
cQuery += "SC9.C9_NUMLOTE,SC9.C9_DTVALID, SC9.C9_CLIENTE,SC9.C9_LOJA,SC9.C9_BLEST,SC5.C5_PEDECOM,SC5.C5_X_USERS"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

For nX := 1 To Len(aStruSC9)
	If aStruSC9[nX][2] <> "C" .and.  FieldPos(aStruSC9[nX][1]) > 0
		TcSetField(cAliasNew,aStruSC9[nX][1],aStruSC9[nX][2],aStruSC9[nX][3],aStruSC9[nX][4])
	EndIf
Next nX

oReport:SetMeter((cAliasNew)->(LastRec()))

oReport:SetTitle(cTitulo)

(cAliasNew)->(dbGoTop())
While (cAliasNew)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
   
	//inicializo a primeira seção
	oSection1:Init()

	oReport:IncMeter()
	
	IncProc("Imprimindo Pick List ")

	_cPedido := (cAliasNew)->C9_PEDIDO
	
	While (cAliasNew)->(!Eof()) .and. (cAliasNew)->C9_PEDIDO == _cPedido
		
		If lUsaLocal
			cEndereco := (cAliasNew)->DC_LOCALIZ
			nQtde     := Iif((cAliasNew)->DC_QUANT>0,(cAliasNew)->DC_QUANT,(cAliasNew)->C9_QTDLIB)
		Else
			cEndereco := ""
			nQtde     := (cAliasNew)->C9_QTDLIB
		EndIf
		
		SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->C9_PRODUTO))
		
		oSection1:Cell("C5_X_EMPFA"):SetValue((cAliasNew)->C5_X_EMPFA)
		oSection1:Cell("C9_DATALIB"):SetValue((cAliasNew)->C9_DATALIB)
		oSection1:Cell("C9_PEDIDO"):SetValue((cAliasNew)->C9_PEDIDO)
		oSection1:Cell("A1_NOME"):SetValue(SUBS((cAliasNew)->A1_NOME,1,30))
		oSection1:Cell("C9_ITEM"):SetValue((cAliasNew)->C9_ITEM)
		oSection1:Cell("C6_KIT"):SetValue((cAliasNew)->C6_KIT)
		oSection1:Cell("C9_PRODUTO"):SetValue((cAliasNew)->C9_PRODUTO)
		oSection1:Cell("B1_DESC"):SetValue(Subs(SB1->B1_DESC,1,100))
		oSection1:Cell("B1_UM"):SetValue(SB1->B1_UM)
		oSection1:Cell("NQTDE"):SetValue(nQtde)
		oSection1:Cell("C9_LOCAL"):SetValue((cAliasNew)->C9_LOCAL)
		oSection1:Cell("C9_LOTECTL"):SetValue((cAliasNew)->C9_LOTECTL)
		oSection1:Cell("C9_DTVALID"):SetValue((cAliasNew)->C9_DTVALID)
		oSection1:Cell("C9_BLEST"):SetValue(Iif(!Empty((cAliasNew)->C9_BLEST),"SIM",""))
		If Alltrim((cAliasNew)->C5_X_USERS)$"e-commerce" .and. !Subs((cAliasNew)->C5_PEDECOM,1,1)$"1"
			oSection1:Cell("C5_PEDECOM"):SetValue(Subs((cAliasNew)->C5_PEDECOM,1,3))
		ElseIf Alltrim((cAliasNew)->C5_X_USERS)$"e-commerce" .and. Subs((cAliasNew)->C5_PEDECOM,1,1)$"1"
			oSection1:Cell("C5_PEDECOM"):SetValue("MAX")
		else
			oSection1:Cell("C5_PEDECOM"):SetValue("***")
		EndIf

		
		oSection1:Printline()
	
		DbSelectArea(cAliasNew)
		(cAliasNew)->(dbSkip())
		
	End
	
	oReport:EndPage()
	
	
End

oReport:ThinLine()

//finalizo a primeira seção
oSection1:Finish()

IF Select(cAliasNew) <> 0
	DbSelectArea(cAliasNew)
	DbCloseArea()
ENDIF


return

