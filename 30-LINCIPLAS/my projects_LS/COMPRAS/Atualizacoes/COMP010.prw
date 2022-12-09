#Include "Protheus.ch"   
#Include "Topconn.ch"

/*
+===============================================================+
|Programa: COMP010 |Autor: Antonio Carlos |Data:07/06/10        |
+===============================================================+
|Descricao: Rotina para visualização do Pedido de Compra ref. a |
|rotina de Aprovação de Pedidos Laselva.                        |
+===============================================================+
|Uso: Especifico Laselva                                        |
+===============================================================+
*/

User Function COMP010(_cFilial,_cPedido)

Local _nTotal		:= 0
Local _nIcSol		:= 0
Local _nTotSCR		:= 0
Local aButtons 		:= {{"DBG12"	,{||VAprov()},"Aprovacao" }}   
Local aCpoGDa		:= {"C7_ITEM","C7_PRODUTO","C7_DESCRI","C7_UN","C7_QUANT","C7_PRECO","C7_TOTAL","C7_OBS"}
Private _cFil		:= _cFilial
Private _cPed		:= _cPedido
Private cCadastro	:= "Consulta Pedido de Compra"
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
		aAdd( aHeader, { 	AlLTrim( X3Titulo()) ,;
		SX3->X3_CAMPO		,;
		SX3->X3_Picture		,;
		SX3->X3_TAMANHO		,;
		SX3->X3_DECIMAL		,;
		SX3->X3_Valid		,;
		SX3->X3_USADO		,;
		SX3->X3_TIPO		,;
		SX3->X3_F3 			,;
		SX3->X3_CONTEXT		,;
		SX3->X3_CBOX		,;
		SX3->X3_RELACAO } )
	EndIf
Next nI

DbSelectArea("SC7")     
SC7->( DbSetOrder(1) )
If SC7->( DbSeek(_cFilial+_cPedido) )

	While SC7->( !Eof() ) .And. SC7->C7_FILIAL == _cFilial .And. SC7->C7_NUM == _cPedido
	
		Aadd( aCols, Array( Len( aHeader ) + 1 ) )
		
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2],.T.)
			Else
				aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		aCols[Len(aCols),Len(aHeader)+1] := .F.
		
		_nTotal += SC7->C7_TOTAL+SC7->C7_VALSOL

		SC7->( DbSkip() )
		
	EndDo
	
EndIf

DbSelectArea("SCR")		
SCR->( DbSetOrder(2) )
SCR->( DbSeek( _cFilial+"PC"+_cPedido ) )
_nTotSCR := SCR->CR_TOTAL

_nIcSol := _nTotSCR - _nTotal

DbSelectArea("SC7")
SC7->( DbSetOrder(1) )
SC7->( DbSeek(_cFilial+_cPedido) )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 10,10 TO 550,1000 PIXEL
    
@ 020,010 SAY "Numero" PIXEL
@ 020,040 MSGET oNum VAR SC7->C7_NUM WHEN .F. PIXEL

@ 020,100 SAY "Emissao" PIXEL
@ 020,140 MSGET oEmi VAR SC7->C7_EMISSAO WHEN .F. PIXEL

@ 020,200 SAY "Fornecedor" PIXEL
@ 020,250 MSGET oFor VAR Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")) WHEN .F. PIXEL

@ 040,010 SAY "Cond.Pagto" PIXEL
@ 040,040 MSGET oNum VAR Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI") WHEN .F. PIXEL

//oGetDados := MsGetDados():New(10, 10, 100, 100, 2, "U_LINHAOK", , "+A1_COD ", .T., {"BZ_PERFIL","BZ_EMAX","BZ_EMIN"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", ,  "U_DELOK", oDlgCupom)
  oGetDados := MsGetDados():New(60, 10, 200, 480, 2, "         ", , "+C7_ITEM", .T.,                                  , , .F., 200, "         ", "          ", ,  "       ", oDlg)
  
@ 210,010 SAY "Icms Solid." PIXEL
@ 210,040 MSGET oIcm VAR _nIcSol PICTURE "@E 999,999,999.99" WHEN .F. PIXEL

@ 240,010 SAY "Valor Total" PIXEL
@ 240,040 MSGET oVlM VAR _nTotSCR PICTURE "@E 999,999,999.99" WHEN .F. PIXEL
  
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, { || oDlg:End() }, { ||  oDlg:End() },, aButtons )

Return

Static Function VAprov()

Local _cNumPed	:= Space(6)
Local _cCompra	
Private oLbx
Private aEstru	:= {}

If Select("QRY") > 0
	QRY->( DbCloseArea() )

EndIf

cQuery := " SELECT CR_FILIAL, CR_NUM, C7_USER, CR_NIVEL, CR_USER, CR_STATUS, CR_APROV, CR_USERLIB, CR_DATALIB, SUM(C7_TOTAL) AS 'TOTAL', " 
cQuery += " CASE WHEN CR_STATUS = '01' THEN 'Nivel Bloqueado' WHEN CR_STATUS = '02' THEN 'Aguardando Liberacao' WHEN CR_STATUS = '04' THEN 'Bloqueado' ELSE 'Nivel Liberado' END AS 'SITUA' "
cQuery += " FROM "+RetSqlName("SCR")+" SCR (NOLOCK) "
cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 (NOLOCK) "
cQuery += " ON CR_FILIAL = C7_FILIAL AND RTRIM(CR_NUM) = C7_NUM AND SC7.D_E_L_E_T_ = '' "
cQuery += " WHERE "
cQuery += " CR_FILIAL = '"+_cFil+"' AND "
cQuery += " RTRIM(CR_NUM) = '"+_cPed+"' AND "
cQuery += " SCR.D_E_L_E_T_ = '' "

cQuery += " GROUP BY CR_FILIAL, CR_NUM, C7_USER, CR_STATUS, CR_NIVEL, CR_USER, CR_APROV, CR_STATUS, CR_USERLIB, CR_TOTAL, CR_DATALIB "
cQuery += " ORDER BY CR_FILIAL, CR_NIVEL "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.)

DbSelectArea("QRY")
QRY->( DbGoTop() )
If QRY->( !Eof() )
	While QRY->( !Eof() )
	
		_cNumPed := Alltrim(QRY->CR_NUM)
		_cCompra := Alltrim(UsrFullName(QRY->C7_USER))	

		Aadd(aEstru,{QRY->CR_NIVEL,;
					Alltrim(UsrRetName(QRY->CR_USER)),;
					QRY->SITUA,;
					IIf(QRY->CR_STATUS $"03/04",Alltrim(UsrFullName(QRY->CR_USER)),""),;
					Substr(QRY->CR_DATALIB,7,2)+"/"+Substr(QRY->CR_DATALIB,5,2)+"/"+Substr(QRY->CR_DATALIB,1,4)})
		QRY->( DbSkip() )
		
	EndDo
EndIf

DEFINE MSDIALOG oDlgV TITLE "Consulta Aprovacao" FROM 000,000 TO 340,650 OF oMainWnd PIXEL  

@ 010,010 SAY "Pedido" PIXEL
@ 010,040 MSGET oPed VAR _cNumPed WHEN .F. PIXEL

@ 010,100 SAY "Comprador" PIXEL
@ 010,140 MSGET oComp VAR _cCompra WHEN .F. PIXEL

@ 030,8 LISTBOX oLbx FIELDS HEADER "Nivel","Usuario","Situacao","Aprovador por:","Data Liber." SIZE 305,100 NOSCROLL OF oDlgV PIXEL
oLbx:SetArray(aEstru)
oLbx:bLine:={|| {aEstru[oLbx:nAt,1],aEstru[oLbx:nAt,2],aEstru[oLbx:nAt,3],aEstru[oLbx:nAt,4],aEstru[oLbx:nAt,5]}}
oLbx:Refresh()    

@ 150,258 BUTTON "Fechar" SIZE 037,012 PIXEL OF oDlgV ACTION( oDlgV:End() )
		            
ACTIVATE MSDIALOG oDlgV CENTERED 

Return