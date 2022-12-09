#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDVEND    ºAutor  ³                 º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao de vendedor executado pela rotina MT410CPY       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12                          	                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VALIDVEND()

Local cQuery 	:= ''  
Local cAliasTRB := GetNextAlias()  
Local aAreaC5 := SC5->(GetArea()) 
Local nY := 0

If Select("cAliasTRB") > 0
	cAliasTRB->(DBCLOSEAREA())
EndIf

cQuery := " SELECT "
cQuery += " isnull(A30.A3_COD,'') VEND, "
cQuery += " isnull(A30.A3_SUPER,'') SUPER, "
cQuery += " isnull(A30.A3_GEREN,'') GEREN, "
cQuery += " isnull((SELECT TOP 1 A3_COMIS FROM " + RetSqlName('SA3') + " A31 WHERE A31.A3_COD = A30.A3_COD and A31.D_E_L_E_T_ = ''),0) COMIS_VEND,"
cQuery += " isnull((SELECT TOP 1 A3_COMIS FROM " + RetSqlName('SA3') + " A32 WHERE A32.A3_COD = A30.A3_SUPER and A32.D_E_L_E_T_ = ''),0) COMIS_SUPER,"
cQuery += " isnull((SELECT TOP 1 A3_COMIS FROM " + RetSqlName('SA3') + " A33 WHERE A33.A3_COD = A30.A3_GEREN and A33.D_E_L_E_T_ = ''),0) COMIS_GEREN "
cQuery += " FROM " + RetSqlName('SA1') + " A1 "
cQuery += " INNER JOIN " + RetSqlName('SA3') + " A30 ON A3_COD = A1_VEND and A30.D_E_L_E_T_ = '' "
cQuery += " WHERE "
cQuery += " A1_COD = '"+M->C5_CLIENTE+"' AND A1_LOJA = '"+M->C5_LOJACLI+"' AND A1.D_E_L_E_T_ = '' "
cQuery := ChangeQuery( cQuery ) 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)
dbSelectArea(cAliasTRB)

(cAliasTRB)->(DbGotOP())
M->C5_VEND1  := (cAliasTRB)->VEND
M->C5_VEND2  := (cAliasTRB)->SUPER
M->C5_VEND3  := (cAliasTRB)->GEREN
M->C5_COMIS1 := (cAliasTRB)->COMIS_VEND
M->C5_COMIS2 := (cAliasTRB)->COMIS_SUPER
M->C5_COMIS3 := (cAliasTRB)->COMIS_GEREN
		
For nY := 1 to Len(acols)
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_COMIS1"})] := M->C5_COMIS1 
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_COMIS2"})] := M->C5_COMIS2
	acols[nY,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_COMIS3"})] := M->C5_COMIS3
Next nY

RestArea(aAreaC5) 
Return M->C5_LOJACLI