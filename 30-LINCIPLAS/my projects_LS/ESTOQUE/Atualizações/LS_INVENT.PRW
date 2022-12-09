#Include "Protheus.ch"
#Include "rwmake.ch"
/* Rotina de inventário */

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_INVENT()
/////////////////////////
Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")

cPerg := 'LS_INVENT '
ValidPerg()

Pergunte(cPerg,.f.)
                                          
_aGrupos := {}
DbSelectArea("SBM")
DbGoTop()
Do While !Eof()
	aAdd(_aGrupos,{.f.,SBM->BM_GRUPO,SBM->BM_DESC})
	DbSkip()
EndDo

_dDtInv := ctod('')
_cFil   := '  '   
_cLocal := '  '
_lOk := .f.
DEFINE MSDIALOG oDlg TITLE 'Importação de itens inventariados' FROM 000,000 TO 500,650 OF oMainWnd PIXEL  
	
@ 010,008 Say "Data do Inventário:" 	Size 051,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 010,070 MsGet oDtInv  Var _dDtInv  	Size 040,009 COLOR CLR_BLACK PIXEL OF oDlg  
@ 025,008 Say "Filial:" 				Size 051,008 COLOR CLR_BLACK PIXEL OF oDlg  
@ 025,070 MsGet oFil 	Var _cFil 		Size 025,009 COLOR CLR_BLACK PIXEL OF oDlg  F3 "SM0" Picture "@!" 
@ 040,008 Say "Armazém:"				Size 051,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 040,070 MsGet oLocal 	Var _cLocal		Size 025,009 COLOR CLR_BLACK PIXEL OF oDlg  F3 "SM0" Picture "@!"  F3 'ZI' Valid _ValiLocal()

@ 055,8 LISTBOX oLbx FIELDS HEADER "","Grupo","Descrição" SIZE 305,150 NOSCROLL ON DBLCLICK (_aGrupos := LSVTroca(oLbx:nAt,_aGrupos),oLbx:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLbx,oOk,oNo,@_aGrupos) OF oDlg PIXEL
oLbx:SetArray(_aGrupos)
oLbx:bLine := { || {iif(_aGrupos[oLbx:nAt,1],oOk,oNo),_aGrupos[oLbx:nAt,2],_aGrupos[oLbx:nAt,3]}}
//oLbx:Refresh()    

@ 220,150 Button "OK" 			Size 037,012 PIXEL OF oDlg ACTION(_lOk := .t.,oDlg:End())
@ 220,200 Button "Sair" 		Size 037,012 PIXEL OF oDlg ACTION(_lOk := .f.,oDlg:End())
@ 220,250 Button "Parâmetros" 	Size 037,012 PIXEL OF oDlg ACTION(Pergunte(cPerg,.t.))
		            
ACTIVATE MSDIALOG oDlg CENTERED //ON INIT EnchoiceBar(oDlg,{|| GrvRom(_aGrupos),oDlg:End()}, {|| oDlg:End()}, , {{"BMPINCLUIR",{|| LSVPesq()},"Pedidos"}})

If !_lOK
	Return()
EndIf

mv_par01 := alltrim(mv_par01)
Do While !File(mv_par01)
	MsgAlert('Arquivo informado no parâmetro não localizado','Atenção!!!')
	If !Pergunte(cPerg,.T.)
		Return()
	EndIf
EndDo
mv_par01 := alltrim(mv_par01)

_cGrupos := ''
For _nI := 1 to len(_aGrupos)
	_cGrupos += iif(_aGrupos[_nI,1],_aGrupos[_nI,2] + ',','')
Next

_cGrupos := left(_cGrupos,len(_cGrupos)-1)

_cQuery := "SELECT COUNT(*) QUANT 
_cQuery += _cEnter + "FROM " + RetSqlName('SB7') + " SB7 (NOLOCK) " 
If !empty(_cGrupos)
	_cQuery += _cEnter + "JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK) " 
	_cQuery += _cEnter + "ON SB1.D_E_L_E_T_ = '' "
	_cQuery += _cEnter + "AND B1_COD = B7_COD"
	_cQuery += _cEnter + "AND B1_GRUPO IN " + FormatIn(_cGrupos,',')
EndIf
_cQuery += _cEnter + "WHERE SB7.D_E_L_E_T_ = '' "
_cQuery += _cEnter + "AND B7_FILIAL = '" + _cFil + "'" 
_cQuery += _cEnter + "AND B7_DATA = '" + dtos(_dDtInv) + "'"
_cQuery += _cEnter + "AND B7_LOCAL = '" + _cLocal + "'"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SB7', .F., .F.)

If _SB7->QUANT > 0
 	MsgAlert('Já existem itens inventariados:' + _cEnter + 'Loja ' + _cFil + _cEnter + 'Armazém: ' + _cLocal + iif(empty(_cGrupos),'',_cEnter + 'Grupo(s): ' + _cGrupos) + _cEnter + 'Data: ' + dtoc(_dDtInv) ,'Inventário Laselva','ALERT')
	DbCloseArea()
	Return()
EndIf

DbCloseArea()

If !MsgBox('Confirma invetário da Loja:' + _cEnter + 'Loja ' + _cFil + _cEnter + 'Armazém: ' + _cLocal + iif(empty(_cGrupos),'',_cEnter + 'Grupo(s): ' + _cGrupos) + _cEnter + 'Data: ' + dtoc(_dDtInv) + '?','Inventário Laselva','YESNO')
	Return()
EndIf

_cInvent := 'INVENT_' + _cFil + '_' + dtos(_dDtInv) //CriaTrab(,.f.)

_cQuery := "DROP TABLE " + _cInvent
TcSqlExec(_cQuery)

_cQuery := "SELECT *"
_cQuery += _cEnter + "INTO " + _cInvent
_cQuery += _cEnter + "FROM ("
_cQuery += _cEnter + "SELECT dbo.GM_SALDOESTOQUE_SIGA_SB9('" + _cFil + "','" + _cLocal + "',B1_COD, '" + dtos(_dDtInv) + "') as 'INVENT', B1_COD, B1_DESC, B1_GRUPO"
_cQuery += _cEnter + "FROM " + RetSqlName('SB1') + " A (NOLOCK)"
If !empty(_cGrupos)
	_cQuery += _cEnter + "WHERE B1_GRUPO IN " + FormatIn(_cGrupos,',')
EndIf
_cQuery += _cEnter + ")B"
_cQuery += _cEnter + "WHERE INVENT <> 0"
_cQuery += _cEnter + "ORDER BY B1_GRUPO, B1_COD"

LjMsgRun("Aguarde... Calculando saldos na data do inventário (1/4)",, {|| TcSqlExec(_cQuery)  })

_cTemp  := 'TEMP_' + _cFil + '_' + dtos(_dDtInv)  //CriaTrab(_aEstru,.T.)
_cQuery := "DROP TABLE " + _cTemp
TcSqlExec(_cQuery)         

LjMsgRun('Importando itens inventariados... (2/4)',,{|| _Append()})

_cTemp1 := 'TEMP1_' + _cFil + '_' + dtos(_dDtInv)  //CriaTrab(,.f.)
_cQuery := "DROP TABLE " + _cTemp1
TcSqlExec(_cQuery)
_cQuery := "SELECT CODIGO, DESCR, SUM(QTD) AS 'QTD' INTO " + _cTemp1 + " FROM " + _cTemp  + " GROUP BY CODIGO, DESCR"
LjMsgRun('Agrupando itens duplicados (3/4)',,{|| TcSqlExec(_cQuery)})

_cQuery := "UPDATE A SET CODIGO = B1_COD"
_cQuery += _cEnter + "FROM " + _cTemp1 + " A"
_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SB1')
_cQuery += _cEnter + "ON B1_CODBAR = A.CODIGO"
TcSqlExec(_cQuery)

// Insere na SB7 o inventário e os produtos zerados

_cQuery := "DECLARE @RECNO AS INT"
_cQuery += _cEnter + "SET @RECNO = (SELECT MAX(R_E_C_N_O_)"
_cQuery += _cEnter + "FROM " + RetSqlName('SB7') + " (NOLOCK))+ 1"

_cQuery += _cEnter + "INSERT INTO " + RetSqlName('SB7')
_cQuery += _cEnter + "SELECT '" + _cFil + "', B1_COD, '" + _cLocal + "', 'PA', 'SISTEMA', QTD, QTD, '" + dtos(_dDtInv) + "', '', '',"
_cQuery += _cEnter + " '" + dtos(_dDtInv) + "', '', '', '','', '', '', '', ROW_NUMBER() OVER( ORDER by B1_COD ) + @RECNO, '', '', '', '',"
_cQuery += _cEnter + "'" + cUserName + "','" + dtos(date()) + "','" + left(time(),2) + substr(time(),4,2) + "'"

_cQuery := _cEnter + "SELECT B1_COD, SUM(QTD) QTD"
_cQuery += _cEnter + "FROM"
_cQuery += _cEnter + "(SELECT B1_COD, B1_DESC, 0 AS 'QTD'"
_cQuery += _cEnter + "FROM " + _cInvent + " A"
_cQuery += _cEnter + "LEFT JOIN " + _cTemp1 + " B ON B1_COD = CODIGO"
_cQuery += _cEnter + "WHERE B.CODIGO IS NULL"
_cQuery += _cEnter + "UNION"
_cQuery += _cEnter + "SELECT * FROM " + _cTemp1
_cQuery += _cEnter + ") AS A"              
_cQuery += _cEnter + "GROUP BY B1_COD"
_cQuery += _cEnter + "ORDER BY B1_COD"

//MsAguarde({|| TcSqlExec(_cQuery)},'Gerando contagens do inventário... (4/4)')
MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SB7A', .F., .F.)},'Gerando contagens do inventário... (4/4)')
Do While !eof()       
	RecLock('SB7',.t.)
	SB7->B7_FILIAL  := _cFil
	SB7->B7_LOCAL   := _cLocal
	SB7->B7_COD     := SB7A->B1_COD
	SB7->B7_TIPO    := 'PA'
	SB7->B7_DOC     := 'SISTEMA'
	SB7->B7_QUANT   := SB7A->QTD
	SB7->B7_QTSEGUM := SB7A->QTD
	SB7->B7_DATA    := _dDtInv
	SB7->B7_DTVALID := _dDtInv
	SB7->B7_USER    := cUserName
	SB7->B7_DTDIGIT := date()
	SB7->B7_HORA    :=  left(time(),2) + substr(time(),4,2) 
	MsUnLock()                                        
	DbSelectArea('SB7A')
	DbSkip()
EndDo
DbCloseArea()
_cQuery := "DROP TABLE " + _cTemp
TcSqlExec(_cQuery)         

_cQuery := "DROP TABLE " + _cTemp1
TcSqlExec(_cQuery)

_cQuery := "DROP TABLE " + _cInvent
TcSqlExec(_cQuery)

Return           

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LSVTroca(nIt,aArray)
////////////////////////////////////
aArray[nIt,1] := !aArray[nIt,1]
Return aArray

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _ValiLocal()
/////////////////////////////
Local _cFilAnt := cFilAnt
Local cFilAnt := _cFil
Local _lRet := (_cLocal $ GetMv('LS_ALMOXVL'))
If !_lRet
	MsgBox('Armazém inválido para filial selecionada','ATENÇÃO!!!','ALERT')
EndIf

cFilAnt := _cFilAnt

Return(_lRet)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _append()
/////////////////////////

FT_FUSE(mv_par01)
FT_FGotop()

_cQuery := "SELECT '9999999999999999999999999' CODIGO, 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' DESCR, 999999.999 QTD INTO " + _cTemp 
TcSqlExec(_cQuery)

_nInd := 0
Do	While ( !FT_FEof() )
		
	_cLinha  := alltrim(FT_FREADLN())
	FT_FSkip()

	If IsAlpha(left(_cLinha,1))
 		loop
	EndIf             
	
	Do While right(_cLinha,1) == ';'
		_cLinha := left(_cLinha,len(_cLinha)-1)
		_cLinha := strtran(strtran(_cLinha,'"',''),"'",'')
	EndDo   			
 	
	_nPosic := at(';',_cLinha) ; _cCodigo := left(_cLinha,_nPosic-1) ; _cLinha := substr(_cLinha,_nPosic+1)
	_nPosic := at(';',_cLinha) ; _cDescr  := left(_cLinha,_nPosic-1) ; _cLinha := substr(_cLinha,_nPosic+1)
	_nPosic := at(';',_cLinha) ; _cSecao  := left(_cLinha,_nPosic-1) ; _cLinha := substr(_cLinha,_nPosic+1)
	_xLinha := strtran(_clinha,',','.'); _nQuant  := _xLinha
              
 	_cQuery := "INSERT INTO " + _cTemp + " SELECT '" + _cCodigo + "' CODIGO, '" + _cDescr + "' DESCR, " + _nQuant + " QTD"
	TcSqlExec(_cQuery)
EndDo
FT_FUse()

_cQuery := "DELETE FROM " + _cTemp 
_cQuery += " WHERE CODIGO =  '9999999999999999999999999'"
_cQuery += " AND DESCR = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'"
TcSqlExec(_cQuery)
	
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Caminho/arquivo               ?","","", "mv_ch1", "C", 99 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

DbSelectArea("SX1")
DbSetOrder(1)

For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i, 2]))
	For j := 1 to (FCount())
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j, aPerg[i, j])
		Endif
	Next
	MsUnlock()
Next

RestArea(_aAlias)

Return

