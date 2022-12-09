#Include "Protheus.ch"
#Include "Topconn.ch"

/*
+===============================================================+
|Programa: COMP014 |Autor: Antonio Carlos |Data:07/06/10        |
+===============================================================+
|Descricao: Rotina para visualização do Pedido de Compra ref. a |
|rotina de Aprovação de Pedidos Laselva.                        |
+===============================================================+
|Uso: Especifico Laselva                                        |
+===============================================================+
*/

User Function COMP014(_cFilial,_cPedido,_cCgc,_cISql)

Local nLinha		:= 0
Local _nTotal		:= 0
Local _nIcSol		:= 0
Local _nTotSCR		:= 0
Local aButtons 		:= {{"S4WB011N"	,{||U_COMP010(aCols[n,1],aCols[n,3])},"Detalhe PC" }}
Local aCpoGDa		:= {"CR_FILIAL","A2_MUN","C7_NUM","C7_EMISSAO","C7_DATPRF","E4_DESCRI","C7_TOTAL","C5_NUM","C5_EMISSAO","C7_OBS","A2_BAIRRO"}
Private _cFil		:= _cFilial
Private _cPed		:= _cPedido
Private cCadastro	:= "Consulta Pedido de Compra - Pedidos Aglutinados"
Private aHeader		:= {}
Private aCols		:= {}
Private oDlg
Private aRotina		:= {{"Pesquisar"	, "AxPesqui", 0, 1},;
{"Visualizar"	, "AxVisual", 0, 2},;
{"Incluir"		, "AxInclui", 0, 3},;
{"Alterar"		, "AxAltera", 0, 4},;
{"Excluit"		, "AxDeleta", 0, 5}}

DbSelectArea( "SX3" )
SX3->( DbSetOrder( 2 ) )
For nI := 1 To Len( aCpoGDa )
	If SX3->( DbSeek( aCpoGDa[nI] ) )
		aAdd( aHeader, { 	IIf(Alltrim(X3_CAMPO)=="A2_MUN","Nome",IIf(Alltrim(X3_CAMPO)=="A2_BAIRRO","Comprador",IIf(Alltrim(X3_CAMPO)=="E4_DESCRI","Cond.Pagto",IIf(Alltrim(X3_CAMPO)=="C5_NUM","Ult.Pedido",IIf(Alltrim(X3_CAMPO)=="C5_EMISSAO","Dt.Ult.Pedido",AlLTrim(X3Titulo()) ))))) ,;
		SX3->X3_CAMPO		,;
		SX3->X3_Picture		,;
		SX3->X3_TAMANHO		,;
		SX3->X3_DECIMAL		,;
		SX3->X3_Valid	 ,;
		SX3->X3_USADO		,;
		SX3->X3_TIPO		,;
		SX3->X3_F3 			,;
		SX3->X3_CONTEXT		,;
		SX3->X3_CBOX		,;
		SX3->X3_RELACAO } )
	EndIf
Next nI

If Select("TMPA") > 0
	TMPA->( DbCloseArea() )
EndIf

cQuery := " SELECT CR_FILIAL, C7_NUM, E4_DESCRI, A2_NOME, C7_USER, CR_TOTAL, C7_EMISSAO, SUM(C7_TOTAL) AS 'TOTAL',"

cQuery += " COALESCE(( "
cQuery += "	SELECT TOP 1 A.C7_NUM "
cQuery += "	FROM SC7010 A WITH(NOLOCK) "
cQuery += "	WHERE "
cQuery += "	( A.C7_FILIAL = CR_FILIAL AND A.C7_FORNECE = SC7.C7_FORNECE AND A.C7_LOJA = SC7.C7_LOJA AND "
cQuery += "	A.C7_NUM < (SELECT MAX(B.C7_NUM) FROM SC7010 B WHERE B.C7_FILIAL = A.C7_FILIAL AND B.C7_FORNECE = A.C7_FORNECE AND B.C7_LOJA = A.C7_LOJA AND B.D_E_L_E_T_ = '') AND A.D_E_L_E_T_ = '') "
cQuery += "	ORDER BY A.C7_NUM DESC	"
cQuery += " ),'') AS 'PEDIDO', "

cQuery += " COALESCE(( "
cQuery += "	SELECT TOP 1 A.C7_EMISSAO "
cQuery += "	FROM SC7010 A WITH(NOLOCK) "
cQuery += "	WHERE "
cQuery += "	( A.C7_FILIAL = CR_FILIAL AND A.C7_FORNECE = SC7.C7_FORNECE AND A.C7_LOJA = SC7.C7_LOJA AND "
cQuery += "	A.C7_NUM < (SELECT MAX(B.C7_NUM) FROM SC7010 B WHERE B.C7_FILIAL = A.C7_FILIAL AND B.C7_FORNECE = A.C7_FORNECE AND B.C7_LOJA = A.C7_LOJA) ) "
cQuery += "	ORDER BY A.C7_NUM DESC	"
cQuery += " ),'') AS 'EMISSAO' "

cQuery += " FROM "+RetSqlName("SCR")+" SCR 	(NOLOCK) "
cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 (NOLOCK) "
cQuery += " ON CR_FILIAL = C7_FILIAL AND RTRIM(CR_NUM) = C7_NUM AND SC7.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 (NOLOCK) "
cQuery += " ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN "+RetSqlName("SE4")+" SE4 (NOLOCK) "
cQuery += " ON C7_COND = E4_CODIGO AND SE4.D_E_L_E_T_ = '' "
cQuery += " WHERE "
If !empty(_cUser)
	cQuery += " CR_USER = '"+_cUser+"' AND "
EndIf
cQuery += " SUBSTRING(A2_CGC,1,8) = '"+_cCgc+"' AND "
cQuery += _cISql
cQuery += " SCR.D_E_L_E_T_ = '' "

cQuery += " GROUP BY CR_FILIAL, C7_NUM, E4_DESCRI, A2_NOME, C7_USER, CR_TOTAL, C7_EMISSAO, C7_FILIAL, C7_FORNECE, C7_LOJA "
cQuery += " ORDER BY CR_FILIAL, C7_FORNECE, C7_LOJA "

TcQuery cQuery NEW ALIAS "TMPA"

Do While TMPA->( !Eof() )
	
	_cFil	:= TMPA->CR_FILIAL
	_cNum	:= TMPA->C7_NUM
	
	aAdd( aCols, Array( Len( aHeader ) + 1 ) )
	nLinha++
	
	For nI := 1 To Len( aHeader )
		cX3Campo := AllTrim( aHeader[nI][2] )
		If aHeader[nI][10] == 'V'
			aCols[nLinha][nI] := CriaVar( cX3Campo, .T. )
		ElseIf Alltrim(aHeader[nI][2]) == "A2_MUN"
			aCols[nLinha][nI] := Posicione("SM0",1,Substr(cNumEmp,1,2)+TMPA->CR_FILIAL,"M0_FILIAL")
		ElseIf Alltrim(aHeader[nI][2]) == "A2_BAIRRO"
			aCols[nLinha][nI] := Alltrim(UsrFullName(TMPA->C7_USER))
		ElseIf Alltrim(aHeader[nI][2]) == "C7_TOTAL"
			aCols[nLinha][nI] := TMPA->CR_TOTAL
		ElseIf Alltrim(aHeader[nI][2]) == "C7_DATPRF"
			aCols[nLinha][nI] := Posicione("SC7",1,TMPA->CR_FILIAL+TMPA->C7_NUM,"C7_DATPRF")
		ElseIf Alltrim(aHeader[nI][2]) == "C7_EMISSAO"
			aCols[nLinha][nI] := STOD(TMPA->C7_EMISSAO)
		ElseIf Alltrim(aHeader[nI][2]) == "C5_NUM"
			aCols[nLinha][nI] := TMPA->PEDIDO
		ElseIf Alltrim(aHeader[nI][2]) == "C5_EMISSAO"
			aCols[nLinha][nI] := IIf(!Empty(TMPA->EMISSAO),(STOD(TMPA->EMISSAO)),"")
		ElseIf Alltrim(aHeader[nI][2]) == "C7_OBS"
			aCols[nLinha][nI] := Posicione("SC7",1,TMPA->CR_FILIAL+TMPA->C7_NUM,"C7_OBS")
		Else
			aCols[nLinha][nI] := &( 'TMPA->' + cX3Campo )
		EndIf
	Next nI
	
	aCols[nLinha][Len( aHeader ) + 1] := .F.
	
	TMPA->( DbSkip() )
	
EndDo

DbSelectArea("SC7")
SC7->( DbsetOrder(1) )
SC7->( DbSeek(_cFil+_cNum) )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 10,10 TO 450,1000 PIXEL

@ 020,010 SAY "Fornecedor" PIXEL
@ 020,050 MSGET oFor VAR Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")) WHEN .F. PIXEL

//oGetDados := MsGetDados():New(10, 10, 100, 100, 2, "U_LINHAOK", , "+A1_COD ", .T., {"BZ_PERFIL","BZ_EMAX","BZ_EMIN"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", ,  "U_DELOK", oDlgCupom)
oGetDados := MsGetDados():New(40, 10, 200, 480, 2, "         ", , "+C7_ITEM", .T.,                                  , , .F., 200, "         ", "          ", ,  "       ", oDlg)

//@ 210,010 SAY "Valor Total" PIXEL
//@ 210,040 MSGET oVlM VAR _nTotSCR PICTURE "@E 999,999,999.99" WHEN .F. PIXEL

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, { || oDlg:End() }, { ||  oDlg:End() },, aButtons )

Return
