#Include "Protheus.ch"
#Include "RWMAKE.ch"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	SF1140I
// Autor 		Alexandre Dalpiaz
// Data 		23/02/2011
// Descricao  	ponto de entrada no MATA140 - após a gravação da pré nota. Grava data informada no PE MT140CPO ou no PE MT140TOK
// Uso         	LaSelva
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SF1140I()
///////////////////////
Local aAlias	:= GetArea()
If !l140Auto
	
	If ExistBlock('PE_ImpXmlNFe')
		ExecBlock('PE_ImpXmlNFe',.F.,.F.,{'SF1140I'})
	EndIf
	RestArea(aAlias)
	
	If RecLock('SF1',.f.)
		SF1->F1_RECBMTO := __dDtRecebe
		MsUnLock()
	EndIf
EndIf

U_SX5NOTA()

If cA100For < '000010'
 	_cQuery := "UPDATE " + RetSqlName('PA6')
	_cQuery += _cEnter + " SET PA6_NFE = PA6_NFS, PA6_STATUS = '06'"
	_cQuery += _cEnter + " WHERE PA6_NFS = '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + " AND PA6_SERIE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + " AND PA6_FILDES = '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + " AND PA6_FILORI = '" + SF1->F1_LOJA + "'"
	TcSqlExec(_cQuery)
EndIf

If inclui
	
	DbSelectArea('SM0')
	_cCnpj := SM0->M0_CGC
	Set Filter to  SM0->M0_CGC == _cCnpj .and. SM0->M0_CODIGO == cEmpAnt
	_cFiliais := ''
	DbGotop()
	Do While !eof()
		_cFiliais += SM0->M0_CODFIL + ','
		DbSkip()
	EndDo
	Set Filter To
	DbSeek(cEmpAnt+cFilAnt)
	_cFiliais := FormatIn(left(_cFiliais,len(_cFiliais)-1),',')
	
	_cQuery := "UPDATE " + RetSqlName('SX5')
	_cQuery += _cEnter + "SET X5_DESCRI = NF, X5_DESCSPA = NF, X5_DESCENG = NF"
	_cQuery += _cEnter + "FROM ("
	_cQuery += _cEnter + "SELECT X5_CHAVE CHAVE, MAX(X5_DESCRI) NF"
	_cQuery += _cEnter + "FROM " + RetSqlName('SX5') + " SX5 (NOLOCK)"
	_cQuery += _cEnter + "WHERE X5_TABELA = '01'"
	_cQuery += _cEnter + "AND X5_CHAVE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + "AND SX5.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND X5_FILIAL IN " + _cFiliais
	_cQuery += _cEnter + "GROUP BY X5_CHAVE"
	_cQuery += _cEnter + ") A"
	_cQuery += _cEnter + "WHERE X5_TABELA = '01'"
	_cQuery += _cEnter + "AND X5_CHAVE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND X5_FILIAL IN " + _cFiliais
	_cQuery += _cEnter + "AND X5_CHAVE = CHAVE"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('SF1')
	_cQuery += _cEnter + " SET F1_DTPRNOT = '" + dtos(date()) + "'"
	_cQuery += _cEnter + " WHERE D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND F1_FILIAL = '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + " AND F1_DOC = '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + " AND F1_SERIE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + " AND F1_FORNECE = '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + " AND F1_LOJA = '" + SF1->F1_LOJA + "'"
	_cQuery += _cEnter + " AND R_E_C_N_O_ = '" + rtrim(str(SF1->(Recno()))) + "'"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('SC7')
	_cQuery += _cEnter + " SET C7_NFISCAL = D1_DOC + D1_SERIE, C7_ITEMNF = D1_ITEM"
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	_cQuery += _cEnter + " WHERE " + RetSqlName('SC7') + ".D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
	_cQuery += _cEnter + " AND C7_FILENT = D1_FILIAL"
	_cQuery += _cEnter + " AND C7_NUM = D1_PEDIDO"
	_cQuery += _cEnter + " AND C7_ITEM = D1_ITEMPC"
	_cQuery += _cEnter + " AND C7_PRODUTO = D1_COD"
	TcSqlExec(_cQuery)
EndIf

If GetMv('LS_CODBAR') == 'S' .and. !l140Auto
	DbSelectArea('Z14')
	_nParc := 0
	DbSeek(xFilial('Z14') + cNFiscal + cSerie + cA100For + cLoja,.f.)
	Do While !eof() .and. xFilial('Z14') + cNFiscal + cSerie + cA100For + cLoja == Z14->Z14_FILIAL+Z14->Z14_DOC+Z14->Z14_SERIE+Z14->Z14_FORNEC+Z14->Z14_LOJA
		++_nParc
		DbSkip()
	EndDo
	
	Define MsDialog _oDlg Title "Cod Bar x NFE" From 000,000 to 120,200 of oMainWnd Pixel
	@ 010,008 Say 'Número de Parcelas'	   Size 250,010 COLOR CLR_BLACK Pixel of _oDlg
	@ 020,008 Get _nParc  size 40,10
	@ 040,010 BmpButton Type 1 Action (_nOpcA:= 1, _oDlg:End())
	Activate MsDialog _oDlg Centered
	
	For _nI := 1 to _nParc
		_x := DbSeek(xFilial('Z14') + cNFiscal + cSerie + cA100For + cLoja + strzero(_nI,3),.f.)
		If !_x
			RecLock('Z14',.t.)
			Z14->Z14_FILIAL 	:= xFilial('Z14')
			Z14->Z14_DOC		:= cNFiscal
			Z14->Z14_SERIE		:= cSerie
			Z14->Z14_FORNEC		:= cA100For
			Z14->Z14_LOJA		:= cLoja
			Z14->Z14_PARCEL		:= strzero(_nI,3)
			MsUnLock()
		EndIf
	Next
	
	DbSeek(xFilial('Z14') + cNFiscal + cSerie + cA100For + cLoja,.f.)
	Do While !eof() .and. xFilial('Z14') + cNFiscal + cSerie + cA100For + cLoja == Z14->Z14_FILIAL+Z14->Z14_DOC+Z14->Z14_SERIE+Z14->Z14_FORNEC+Z14->Z14_LOJA
		If val(Z14->Z14_PARCEL) > _nParc
			RecLock('Z14',.f.)
			DbDelete()
			MsUnLock()
		EndIf
		DbSkip()
	EndDo
	
	_cFiltro := "Z14_FILIAL+Z14_DOC+Z14_SERIE+Z14_FORNEC+Z14_LOJA == '" + xFilial('Z14') + cNFiscal + cSerie + cA100For + cLoja + "'"
	Set Filter to &_cFiltro
	DbGotop()
	If !eof()
		MsgBox('Leia o código de barras do boleto ou informe a linha digitável','ATENÇÃO!!!','INFO')
	EndIf
	Do While !eof()
		AxAltera("Z14",Z14->(Recno()), 4)
		DbSkip()
	EndDo
	//u_ls_z14()
	Set Filter to
EndIf

DbSelectArea('SF1')
Return()