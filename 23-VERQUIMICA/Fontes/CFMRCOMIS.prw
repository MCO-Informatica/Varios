
#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CFMRCOMIS  | Autor: Celso Ferrone Martins | Data: 08/12/2014 |||
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

User Function CFMRCOMIS()


Local oReport
Local cTitulo1 := "COMISSAO VENDEDORES"
Local cTitulo2 := "COMISSAO VENDEDORES"

oReport := TReport():New("CFMRCOMIS", cTitulo1, "CFMRCOMIS", {|oReport| PrintReport(oReport)}, cTitulo2)
oReport:SetLandScape() //Retrato
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

PutSX1("CFMRCOMIS","01","Período de  ","","","MV_CH1","D",08,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","","","","")
PutSX1("CFMRCOMIS","02","Período ate ","","","MV_CH2","D",08,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","","","","")

oSection1 := TRSection():New(oReport,"GERAL",{"TMP"})
oSection1:SetTotalInLine(.F.)

oSection2 := TRSection():New(oReport,"VENDEDOR",{"TMP"})
oSection2:SetTotalInLine(.F.)

oSection2 := TRSection():New(oReport,"ZONA",{"TMP"})
oSection2:SetTotalInLine(.F.)

oSection2 := TRSection():New(oReport,"DIVISAO",{"TMP"})
oSection2:SetTotalInLine(.F.)

//TRCell():New(oSection1,"TRANSP"     ,,"Transportadora" , PesqPict('SA4',"A4_NOME")    , TamSX3("A4_NOME")[1]+10,;
//TRFunction():New(oSection2:Cell("Z11_ICMS"),"","SUM",,"Total Vendedor",PesqPict("Z11","Z11_ICMS"),,.T.,.T.,.F.,oSection2)

Pergunte(oReport:uParam,.F.)

oReport:PrintDialog()


Return()

Static Function PrintReport(oReport)

Local aRelVend := {}

cQuery := " SELECT "
cQuery += "   E3_EMISSAO, "
cQuery += "   E3_NUM, "
cQuery += "   E3_SERIE, "
cQuery += "   E3_PEDIDO, "
cQuery += "   E3_CODCLI, "
cQuery += "   E3_LOJA, "
cQuery += "   A1_NOME, "
cQuery += "   A1_REGIAO, "
cQuery += "   A1_GRPVEN, "
cQuery += "   E3_VEND, "
cQuery += "   D2_COD, "
cQuery += "   B1_DESC, "
cQuery += "   D2_VQ_TABE, "
cQuery += "   E3_PORC, "
cQuery += "   D2_COMIS1  "
cQuery += " FROM "+RetSqlName("SE3")+" SE3 "
cQuery += "   INNER JOIN "+RetSqlName("SA1")+" SA1 ON "
cQuery += "     SA1.D_E_L_E_T_ <> '*' "
cQuery += "     AND A1_FILIAL  = '"+xFilial("SA1")+"' "
cQuery += "     AND A1_COD     = E3_CODCLI "
cQuery += "     AND A1_LOJA    = E3_LOJA "
cQuery += "   INNER JOIN "+RetSqlName("SD2")+" SD2 ON "
cQuery += "     SD2.D_E_L_E_T_ <> '*' "
cQuery += "     AND D2_FILIAL  = '"+xFilial("SD2")+"' "
cQuery += "     AND D2_DOC     = E3_NUM "
cQuery += "     AND D2_SERIE   = E3_SERIE "
cQuery += "     AND D2_CLIENTE = E3_CODCLI "
cQuery += "     AND D2_LOJA    = E3_LOJA "
cQuery += "   INNER JOIN "+RetSqlName("SB1")+" SB1 ON "
cQuery += "     SB1.D_E_L_E_T_ <> '*' "
cQuery += "     AND B1_FILIAL  = '"+xFilial("SA1")+"' "
cQuery += "     AND B1_COD     = D2_COD "
cQuery += " WHERE "
cQuery += "   SE3.D_E_L_E_T_ <> '*' "
cQuery += "   AND E3_FILIAL = '"+xFilial("SE3")+"' "
cQuery += "   AND E3_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
cQuery += " ORDER BY A1_REGIAO, A1_GRPVEN, D2_EMISSAO, D2_DOC " 

cQuery := ChangeQuery(cQuery)

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMP"

While !TMP->(Eof())

//	aAdd(aRelVend

	TMP->(DbSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

Return()