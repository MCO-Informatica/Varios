#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

// Funcao      	LS_Z15
// Autor 		Alexandre Dalpiaz
// Data 		20/11/2012
// Descricao    NOTAS SILVERADO
// Uso         	Especifico para laselva
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Z15()
//////////////////////

Private cString 	:= "Z15"
Private cCadastro 	:= "Notas Silverado"
Private aRotina 	:= {}
Private aCores 		:= {}
Private _aLegenda 	:= {}
Private _cServerIni := GetAdv97()
Private _cSecao     := "TCP"
Private _cChave     := "Port"
Private _nPadrao    := 0
Private _cPorta     := NToC(GetPvProfileInt(_cSecao, _cChave, _nPadrao, _cServerIni), 10)

dbSelectArea("Z15")
dbSetOrder(1)

aAdd(aRotina, {"Pesquisar"			 , "AxPesqui"		, 0 , 1 })
aAdd(aRotina, {"Incluir"      		 , "AxInclui"                                 				, 0 , 3 })
aAdd(aRotina, {"Alterar"			 , "AxAltera"											, 0 , 4 })
aAdd(aRotina, {"Excluir"     		 , "AxDeleta"											, 0 , 5 })
aAdd(aRotina, {"Gerar Itens"		 , "Processa({|| U_Z15GeraDocs(0,'Gerando Itens para PVs')})"			, 0 , 5 })
aAdd(aRotina, {"Gerar Pedidos"		 , "U_Z15GeraDocs(1,'Gerando Pedidos de Venda')"		, 0 , 5 })
aAdd(aRotina, {"Gerar Notas"		 , "U_Z15GeraDocs(2,'Gerando Notas Fiscais')"			, 0 , 5 })
aAdd(aRotina, {"Classificar"		 , "U_Z15GeraDocs(3,'Classificando Notas Fiscais')"		, 0 , 5 })
aAdd(aRotina, {"Legenda"     	 	 , "BrwLegenda('Notas Silverado','LEGENDA',_aLegenda)" 	, 0 , 7 })

aAdd(aCores, {" empty(Z15_PEDIDO) .and.  empty(Z15_NOTA)"		,'BR_VERDE'})
aAdd(aCores, {"!empty(Z15_PEDIDO) .and.  empty(Z15_NOTA)"		,'BR_AZUL'})
aAdd(aCores, {"!empty(Z15_PEDIDO) .and. !empty(Z15_NOTA)"		,'BR_VERMELHO'})
aAdd(aCores, {"!empty(Z15_PEDIDO) .and. !empty(Z15_NOTA) .and. !empty(Z15_NOTA)"		,'BR_VERMELHO'})

aAdd(_aLegenda, {"BR_VERDE" 	, "Sem Pedido"})
aAdd(_aLegenda, {"BR_AZUL"     	, "Com Pedido"})
aAdd(_aLegenda, {"BR_VERMELHO" 	, "Com Nota Fiscal"})

mBrowse( 6,1,22,75,'Z15',,,,,,aCores)

RetIndex('Z15')

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z15GeraDocs(_xPar1,_xPar2)
////////////////////////////////////////

Local _aArea	:= GetArea()
_nReg			:= 0
_cItePV			:= "0001" 
_cUser			:= RetCodUsr()

_nItensT := _nItensA := _nItensP := 0
_nPedT   := _nPedA   := _nPedP   := 0
_nNFST   := _nNFSA   := _nNFSP   := 0
_nNFET   := _nNFEA   := _nNFEP   := 0
_cHoraI  := _cTempoA := _cTEmpoP := '          '

If _xPar1 == 0
	
	_cPerg := 'ITENSSILVA'
	ValidPerg()
	Do While .t.
		If !Pergunte(_cPerg,.t.)
			Return()
		EndIf
		_nNotasPrev := int(mv_par04 / mv_par05) + iif(mod(mv_par04,mv_par05) <> 0,1,0)
		
		If !MsgBox("Serão gerados itens suficientes para " + alltrim(str(_nNotasPrev)) + " notas fiscais.","Confirma geração dos itens?","YESNO")
			Return()
		EndIf
		
		_cArqTmp := CriaTrab(,.f.)
		_cQuery := ""
		_cDropa := ""
		For _nI := 1 to _nNotasPrev
			_cQuery += _cEnter + " SELECT B1_COD, B1_DESC, B1_PRV1 INTO " + _cArqTmp + strzero(_nI,4) + " FROM " + RetSqlName('SB1') + " B1 (NOLOCK) WHERE B1_GRUPO='0003' AND B1.D_E_L_E_T_='' AND B1_PRV1 BETWEEN 20 AND 31 AND B1_MSBLQL='2'"
			_cQuery += _cEnter + " SELECT TOP 99 B1_COD, B1_DESC, B1_PRV1 INTO " + _cArqTmp + 'A' + strzero(_nI,4) + " FROM " + _cArqTmp + strzero(_nI,4)
			
			_cDropa += _cEnter + " DROP TABLE " + _cArqTmp + strzero(_nI,4)
			_cDropa += _cEnter + " DROP TABLE " + _cArqTmp + 'A' + strzero(_nI,4)
		Next
		TcSqlExec(_cQuery)
		
		_cOrdem := '000000'
		
		ProcRegua(_nNotasPrev)
		_nNotasEfet := 0
		
		For _nI := 1 to _nNotasPrev
			
			IncProc('Buscando itens para pedidos de venda')
			
			_nNotasEfet++
			
			_cQuery := "SELECT B1_COD, B1_DESC,	B1_PRV1"
			_cQuery += _cEnter + " FROM " + _cArqTmp + 'A' + strzero(_nI,4)
			_cQuery += _cEnter + " ORDER BY B1_COD"
			dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"TMP", .T., .T.)
			
			_nTotal := 0
			Do While !eof()
				_nTotal += TMP->B1_PRV1
				DbSkip()
			EndDo
			DbGoTop()
			
			Do While !eof() .and. mv_par04 > 0
				
				_cOrdem := Soma1(_cOrdem)
				RecLock('Z15',.t.)
				Z15->Z15_FILORI	:= mv_par01
				Z15->Z15_CODCLI := mv_par02
				Z15->Z15_LOJA	:= mv_par03
				Z15->Z15_CODPRO	:= TMP->B1_COD
				Z15->Z15_QUANT	:= round(mv_par05 * TMP->B1_PRV1 / _ntotal / (mv_par05/1000),0)
				Z15->Z15_VALOR	:= round(TMP->B1_PRV1 * 0.8,2)
				Z15->Z15_VENCTO	:= mv_par06
				Z15->Z15_PEDIDO := _cOrdem
				MsUnLock()
				mv_par04 -= (Z15->Z15_QUANT * Z15->Z15_VALOR)
				
				DbSelectArea('TMP')
				DbSkip()
			EndDo
			DbCloseArea()
			TcSqlExec('DROP TABLE ' + _cArqTmp + strzero(_nI,4) )
			TcSqlExec('DROP TABLE ' + _cArqTmp + 'A' + strzero(_nI,4) )
			
		Next
		
		MsgBox('Foram gerados ' + alltrim(str(val(_cOrdem))) + ' itens, para ' + alltrim(str(_nNotasEfet)) + ' Notas Fiscais','Concluido','ALERT')
		Return()
	EndDo
ElseIf _xPar1 == 1
	
	_cQuery := "SELECT Z15.*, A1_EST, A1_COND, B1_GRUPO, B1_DESC, B1_UM, "
	_cQuery += _cEnter + "CASE WHEN CHARINDEX(B1_GRUPO,'" + GetMv("MV_GRPLIVR") + "') > 0 THEN '" + GetMv("MV_TESVCOL") + "' ELSE '" + GetMv("MV_TESVCOO") + "' END TES"
	
	_cQuery += _cEnter + "FROM " + RetSqlName('Z15') + " Z15 (NOLOCK)"
	
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SA1') + " SA1 (NOLOCK)"
	_cQuery += _cEnter + "ON A1_COD = Z15_CODCLI"
	_cQuery += _cEnter + "AND A1_LOJA = Z15_LOJA"
	_cQuery += _cEnter + "AND SA1.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
	_cQuery += _cEnter + "ON B1_COD = Z15_CODPRO"
	_cQuery += _cEnter + "AND SB1.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + "WHERE Z15_CODPRO <> ''"
	_cQuery += _cEnter + "AND Z15.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "ORDER BY Z15_FILORI + Z15_LOJA + Z15_PEDIDO"
	
	MsAguarde({ ||dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"TMP", .T., .T.),'Buscando informações de faturamento'})
	
	DbGoTop()
	Count To _nLastRec
	_nItensT := _nLastRec
	_nItensA := _nLastRec
	//ProcRegua(_nLastRec+iif(_xPar1 == 1,0,_nPedT ))
	_nPedido := 0
	_nPedT   := _nPedA   := int(_nLastRec/99) + iif(mod(_nLastRec,99) == 0, 0, 1)
	
ElseIf _xPar1 == 2
	
	_cQuery := "SELECT *"
	_cQuery += _cEnter + "FROM " + RetSqlName('Z15') + " Z15 (NOLOCK)"
	
	_cQuery += _cEnter + "WHERE Z15_CODPRO = ''"
	_cQuery += _cEnter + "AND Z15_PEDIDO <> ''"
	_cQuery += _cEnter + "AND Z15_NOTA = ''"
	_cQuery += _cEnter + "AND Z15_NFDATA = ''"
	_cQuery += _cEnter + "AND Z15_CLDATA = ''"
	_cQuery += _cEnter + "AND Z15.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "ORDER BY Z15_FILORI + Z15_LOJA + Z15_PEDIDO"
	
	MsAguarde({ ||dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"TMP", .T., .T.),'Buscando informações de faturamento'})
	
	DbGoTop()
	Count To _nLastRec
	//ProcRegua(_nLastRec)
	_nPedT := _nLastRec
	_nPedA := 0
	_nPedP := _nLastRec
	_nNFST := _nLastRec
	_nNFSA := 0
	_nNFEA := 0
	_nNFET := 0
	
ElseIf _xPar1 == 3
	
	_cQuery := "SELECT COUNT(*) QUANT, Z15_NFDATA"
	_cQuery += _cEnter + "FROM " + RetSqlName('Z15') + " Z15 (NOLOCK)"
	
	_cQuery += _cEnter + "INNER JOIN SPED050 SP (NOLOCK)"
	_cQuery += _cEnter + "ON SP.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND NFE_ID = Z15_SERIE + Z15_NOTA"
	_cQuery += _cEnter + "AND dbo.FN_GETIDSPED(ID_ENT) = Z15_FILORI"
	_cQuery += _cEnter + "AND STATUS = 6"
	
	_cQuery += _cEnter + "WHERE Z15_CODPRO = ''"
	_cQuery += _cEnter + "AND Z15_PEDIDO <> ''"
	_cQuery += _cEnter + "AND Z15_NOTA <> ''"
	_cQuery += _cEnter + "AND Z15_NFDATA <> ''"
	_cQuery += _cEnter + "AND Z15_CLDATA = ''"
	_cQuery += _cEnter + "AND Z15.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "GROUP BY Z15_NFDATA"
	_cQuery += _cEnter + "ORDER BY Z15_NFDATA"
	
	MsAguarde({ ||DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"TMP", .T., .T.),'Buscando informações de faturamento'})
	_aDatas := {}
	Do While !eof()
		aAdd(_aDatas,dtoc(stod(TMP->Z15_NFDATA)) + ' - ' + alltrim(str(TMP->QUANT)) + ' notas')
		DbSkip()
	EndDo
	DbCloseArea()
	
	_nOk   := 0
	_nData := 0
	_cCombo := _aDatas[1]
	
	If len(_aDatas) > 1
		Define MsDialog _oDlg Title 'Datas' From 0,0 to 100,100 of oMainWnd Pixel
		
		_oCombo:= TComboBox():New(010,010,{|u|if(PCount()>0,_cCombo:=u,_cCombo)},;
		_aDatas,65,20,_oDlg,,{|| _nData := aScan(_aDatas,_cCombo) },,,,.T.,,,,,,,,,"_cCombo")
		
		@ 30,10 BmpButton Type 1 Action (_oDlg:End(),_nOk := 1)
		@ 30,50 BmpButton Type 2 Action (_oDlg:End(),_nOk := 2)
		
		Activate MsDialog _oDlg centered
		
		If _nOk <> 1
			Return()
		EndIf
	EndIf
	
	_cQuery := "SELECT *"
	_cQuery += _cEnter + "FROM " + RetSqlName('Z15') + " Z15 (NOLOCK)"
	
	_cQuery += _cEnter + "INNER JOIN SPED050 SP (NOLOCK)"
	_cQuery += _cEnter + "ON SP.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND NFE_ID = Z15_SERIE + Z15_NOTA"
	_cQuery += _cEnter + "AND dbo.FN_GETIDSPED(ID_ENT) = Z15_FILORI"
	_cQuery += _cEnter + "AND STATUS = 6"
	
	_cQuery += _cEnter + "WHERE Z15_CODPRO = ''"
	_cQuery += _cEnter + "AND Z15_PEDIDO <> ''"
	_cQuery += _cEnter + "AND Z15_NOTA <> ''"
	_cQuery += _cEnter + "AND Z15_NFDATA = '" + dtos(ctod(left(_aDatas[_nData],10))) + "'"
	_cQuery += _cEnter + "AND Z15_NFDATA <> ''"
	_cQuery += _cEnter + "AND Z15_CLDATA = ''"
	_cQuery += _cEnter + "AND Z15.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "ORDER BY Z15_FILORI + Z15_LOJA + Z15_PEDIDO"
	
	MsAguarde({ ||DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"TMP", .T., .T.),'Buscando informações de faturamento'})
	
	Count To _nLastRec
	//ProcRegua(_nLastRec)
	_nPedT := _nLastRec
	_nPedA := 0
	_nPedP := _nLastRec
	_nNFST := _nLastRec
	_nNFSP := _nLastRec
	_nNFEA := _nLastRec
	_nNFET := _nLastRec
	
EndIf

Define MsDialog _oDlg Title "Geração de " + iif(_xPar1 == 0, 'Itens para PVs', iif(_xPar1 == 1, 'Pedidos de Venda',iif(_xPar1 == 2, 'NFs Saída', 'Notas de Entrada - Classificação'))) + " - Silverado" From 010,100 to 550,950 of oMainWnd Pixel

@ 020,005 Say 'Total'                  Size 100,010 COLOR CLR_BLACK Pixel of _oDlg
@ 035,005 Say 'Processados'            Size 100,010 COLOR CLR_BLACK Pixel of _oDlg
@ 050,005 Say 'A processar'            Size 100,010 COLOR CLR_BLACK Pixel of _oDlg

@ 005,040 Say 'Itens'                  Size 100,010 COLOR CLR_BLACK Pixel of _oDlg
@ 020,040 MsGet _oItensT Var _nItensT  Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 035,040 MsGet _oItensP Var _nItensP  Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 050,040 MsGet _oItensA Var _nItensA  Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.

@ 005,090 Say 'Pedidos'                Size 100,010 COLOR CLR_BLACK Pixel of _oDlg
@ 020,090 MsGet _oPedT   Var _nPedT    Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 035,090 MsGet _oPedP   Var _nPedP    Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 050,090 MsGet _oPedA   Var _nPedA    Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.

@ 005,140 Say 'NFs Saída'	           Size 100,010 COLOR CLR_BLACK Pixel of _oDlg
@ 020,140 MsGet _oNFST    Var _nNFST     Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 035,140 MsGet _oNFSP    Var _nNFSP     Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 050,140 MsGet _oNFSA    Var _nNFSA     Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.

@ 005,190 Say 'NFs Entrada'            Size 100,010 COLOR CLR_BLACK Pixel of _oDlg
@ 020,190 MsGet _oNFET    Var _nNFET     Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 035,190 MsGet _oNFEP    Var _nNFEP     Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 050,190 MsGet _oNFEA    Var _nNFEA     Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.

@ 005,240 Say 'Tempo / Início'         Size 100,010 COLOR CLR_BLACK Pixel of _oDlg
@ 020,240 MsGet _oHoraI  Var _cHoraI   Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 035,240 MsGet _oTempoP Var _cTempoP  Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.
@ 050,240 MsGet _oTempoA Var _cTempoA  Size 040,010 COLOR CLR_BLACK Pixel of _oDlg when .f.

//@ 70,10 BmpButton Type 1 Action Processa( {|lEnd| Z15RunProc(_xPar1)})
@ 70,10 BmpButton Type 1 Action Z15RunProc(_xPar1)
@ 70,50 BmpButton Type 2 Action _oDlg:End()

Activate MsDialog _oDlg

DbSelectArea('TMP')
DbCloseArea()

RestArea(_aArea)

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Z15RunProc(_xPar1)
//////////////////////////////////

_cHoraI := time()
_oHoraI:Refresh()

If _xPar1 == 1
	
	DbSelectArea("TMP")
	TMP->(DbGoTop())
	Do While !TMP->(Eof())
		
		_cFilAnt := cFilAnt
		cFilAnt  := TMP->Z15_FILORI
		_cTempoI := Time()
		_cTempoA := 'Calculando...'
		
		Do While !TMP->(Eof()) .and. TMP->Z15_FILORI == cFilAnt
			
			_cCliente	:= TMP->Z15_CODCLI
			_cLoja		:= TMP->Z15_LOJA
			_nValorPed  := 0
			_nQuant     := 0
			_nSecI      := int(Seconds())
			
			_cCf	   := iif(SM0->M0_ESTENT <> TMP->A1_EST,'6114','5114')
			
			Begin Transaction
			
			_cNumPed := GetSXENum("SC5","C5_NUM")
			DbSelectArea('SC5')
			Do While DbSeek(xFilial('SC5') + _cNumPed,.f.)
				ConfirmSX8()
				_cNumPed := GetSxeNum("SC5","C5_NUM")
			EndDo
			ConfirmSX8()
			
			DbSelectArea('TMP')
			
			RecLock('SC5',.t.)
			SC5->C5_FILIAL	:= xFilial("SC5")
			SC5->C5_TIPO	:= 'N'
			SC5->C5_NUM		:= _cNumPed
			SC5->C5_CLIENTE	:= TMP->Z15_CODCLI
			SC5->C5_LOJACLI	:= TMP->Z15_LOJA
			SC5->C5_CLIENT	:= TMP->Z15_CODCLI
			SC5->C5_LOJAENT	:= TMP->Z15_LOJA
			SC5->C5_TIPOCLI	:= "R"
			SC5->C5_TRANSP	:= "000001"
			SC5->C5_TPFRETE	:= 'F'
			SC5->C5_MOEDA	:= 1
			SC5->C5_CONDPAG	:= TMP->A1_COND
			SC5->C5_EMISSAO	:= dDataBase
			SC5->C5_DATA1	:= stod(TMP->Z15_VENCTO)
			SC5->C5_LSHORA	:= Time()
			SC5->C5_MOEDA	:= 1
			SC5->C5_TIPLIB	:= '1'
			SC5->C5_TXMOEDA	:= 1
			SC5->C5_TPCARGA	:= '2'
			SC5->C5_TES		:= TMP->TES
			SC5->C5_VEND1	:= "000001"
			SC5->C5_COTACAO	:= "SILVER"
			SC5->C5_LIBEROK := "S"
			MsUnLock()
			
			Do While !TMP->(Eof()) .and. TMP->Z15_FILORI == cFilAnt .and. TMP->Z15_CODCLI == _cCliente .and. TMP->Z15_LOJA == _cLoja .and. _nReg < 99
				
				//IncProc("Montando Pedido de Vendas (" + alltrim(str(++_nPedido)) + '/' + alltrim(str(_nLastRec)) + ")")
				
				RecLock('SC6',.t.)
				SC6->C6_FILIAL	:= xFilial("SC6")
				SC6->C6_NUM		:= _cNumPed
				SC6->C6_CLI   	:= Z15->Z15_CODCLI
				SC6->C6_LOJA   	:= Z15->Z15_LOJA
				SC6->C6_ITEM	:= _cItePV
				SC6->C6_PRODUTO	:= TMP->Z15_CODPROD
				SC6->C6_DESCRI	:= TMP->B1_DESC
				SC6->C6_UM		:= TMP->B1_UM
				SC6->C6_QTDVEN	:= TMP->Z15_QUANT
				SC6->C6_PRUNIT	:= Round(TMP->Z15_VALOR,2)
				SC6->C6_PRCVEN	:= Round(TMP->Z15_VALOR,2)
				SC6->C6_VALOR	:= Round(TMP->Z15_VALOR,2) * TMP->Z15_QUANT
				SC6->C6_TES		:= TMP->TES
				SC6->C6_CF		:= _cCf
				SC6->C6_ENTREG	:= dDataBase
				MsUnLock()
				
				Reclock("SC9",.T.)
				SC9->C9_FILIAL 	:= xFilial("SC9")
				SC9->C9_PEDIDO	:= SC6->C6_NUM
				SC9->C9_ITEM	:= SC6->C6_ITEM
				SC9->C9_CLIENTE	:= SC6->C6_CLI
				SC9->C9_LOJA	:= SC6->C6_LOJA
				SC9->C9_PRODUTO	:= SC6->C6_PRODUTO
				SC9->C9_QTDLIB	:= SC6->C6_QTDVEN
				SC9->C9_DATALIB	:= dDatabase
				SC9->C9_SEQUEN	:= "01"
				SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
				SC9->C9_LOCAL	:= "01"
				SC9->C9_BLEST  	:= ""
				SC9->C9_BLCRED 	:= ""
				SC9->C9_TPCARGA	:= "2"
				Msunlock()
				
				_nReg++
				_cItePV := Soma1(_cItePV)
				
				TcSqlExec("DELETE FROM " + RetSqlName('Z15') + " WHERE R_E_C_N_O_ = " + str(TMP->R_E_C_N_O_))
				
				DbSelectArea('TMP')
				_nValorPed += Round(TMP->Z15_VALOR,2) * TMP->Z15_QUANT
				_nQuant    += TMP->Z15_QUANT
				TMP->(DbSkip())
				
			EndDo
			
			RecLock('Z15',.t.)
			Z15->Z15_FILORI := cFilAnt
			Z15->Z15_CODCLI := SC5->C5_CLIENTE
			Z15->Z15_LOJA   := SC5->C5_LOJACLI
			Z15->Z15_VALOR  := _nValorPed
			Z15->Z15_QUANT  := _nQuant
			Z15->Z15_VENCTO := stod(TMP->Z15_VENCTO)
			Z15->Z15_PEDIDO := SC5->C5_NUM
			Z15->Z15_PVDATA := date()
			Z15->Z15_PVHORA := left(time(),2) + substr(time(),4,2)
			Z15->Z15_PVUSER := cUserName
			MsUnLock()
			
			If _xPar1 == 3
				Z15GeraNF(SC5->C5_NUM)
			EndIf
			
			End Transaction
			--_nPedA
			++_nPedP
			
			_nSecF   := int(seconds())
			_nSecP   := (_nSecF - _nSecI) * _nPedP
			_cTempoP := strzero(int(_nSecP/3600),2) + ':' + strzero(int(mod(_nSecP, 60)),2)
			
			_nSecA   := (_nSecF - _nSecI) * _nPedA
			_cTempoA := strzero(int(_nSecA/3600),2) + ':' + strzero(int(mod(_nSecA, 60)),2)
			
			_oDlgRefresh()
			
			_nReg		:= 0
			_cItePV		:= "01"
			
			DbSelectArea('TMP')
			
		EndDo
		cFilAnt := _cFilAnt
		
	EndDo
	
ElseIf _xPar1 == 2
	
	DbSelectArea("TMP")
	TMP->(DbGoTop())
	_nPedido := 0
	Do While !TMP->(Eof())
		
		_cFilAnt := cFilAnt
		cFilAnt  := TMP->Z15_FILORI
		DbSelectArea('SC5')
		DbSeek(TMP->Z15_FILORI + TMP->Z15_PEDIDO,.f.)
		++_nPedido
		If found()
			
			_nSecI   := int(seconds())
			
			LibPedid(SC5->C5_NUM)
			Z15GeraNF(SC5->C5_NUM)
			
			--_nNFSA
			++_nNFSP
			
			_nSecF   := int(seconds())
			_nSecP   := (_nSecF - _nSecI) * _nNFSP
			_cTempoP := strzero(int(_nSecP/3600),2) + ':' + strzero(int(mod(_nSecP, 60)),2)
			
			_nSecA   := (_nSecF - _nSecI) * _nNFSA
			_cTempoA := strzero(int(_nSecA/3600),2) + ':' + strzero(int(mod(_nSecA, 60)),2)
			
			_oDlgRefresh()
		EndIf
		
		DbSelectArea('TMP')
		DbSkip()
	EndDo
	
ElseIf _xPar1 == 3
	_cCadastro := cCadastro
	_aRotina   := aClone(aRotina)
	_aCores    := aClone(aCores)
	_cFilAnt   := cFilAnt
	
	DbSelectArea("TMP")
	DbGoTop()
	_cTes := GetMv("MV_TESCCOL")
	Do While !eof()
		
		_aCab := {}
		
		DbSelectArea('SF2')
		
		If !DbSeek(TMP->Z15_FILORI + TMP->Z15_NOTA + TMP->Z15_SERIE,.f.)
			DbSelectArea('TMP')
			DbSkip()
			loop
		EndIf
		
		_nSecI   := int(seconds())
		If _cPorta <> '7990' .and. alltrim(SF2->F2_SERIE) == '8' .and. SF2->F2_FILIAL <> 'BH'
			//Verifica status da NF-e enviada e aprovada
			_cQuery := "SELECT STATUS STATUSNFE, ID_ENT, NFE_ID"
			_cQuery += _cEnter + "FROM SPED050"
			_cQuery += _cEnter + "WHERE ID_ENT = dbo.FN_GETIDSPED('" + SF2->F2_FILIAL + "')"
			_cQuery += _cEnter + "AND NFE_ID = '" + SF2->F2_SERIE + SF2->F2_DOC + "'"
			_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
			
			dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"SEFAZ", .T., .T.)
			_cStatus := SEFAZ->STATUSNFE
			DbCloseArea()
			
			If _cStatus = 0
				MsgBox('NF-e ainda não transmitida para a SEFAZ. Verifique com a Loja de origem!','ATENÇÃO!!!','ALERT')
				DbSelectArea('TMP')
				DbSkip()
				loop
			ElseIf _cStatus <> 6
				MsgBox('NF-e não aprovada pela SEFAZ. Verifique com a Loja de origem se a nota já foi transmitida e aprovada na SEFAZ','ATENÇÃO!!!','ALERT')
				DbSelectArea('TMP')
				DbSkip()
				loop
			EndIf
		EndIf
		
		If TMP->Z15_FILORIG >= '01' .and. TMP->Z15_FILORIG <= '99'
			_cFornece := '000001'
		ElseIf TMP->Z15_FILORIG >= 'A0' .and. TMP->Z15_FILORIG <= 'AZ'
			_cFornece := '000004'
		ElseIf TMP->Z15_FILORIG >= 'C0' .and. TMP->Z15_FILORIG <= 'EZ'
			_cFornece := '000003'
		ElseIf TMP->Z15_FILORIG >= 'G0' .and. TMP->Z15_FILORIG <= 'GZ'
			_cFornece := '000002'
		ElseIf TMP->Z15_FILORIG >= 'R0' .and. TMP->Z15_FILORIG <= 'RZ'
			_cFornece := '000005'
		ElseIf TMP->Z15_FILORIG >= 'T0' .and. TMP->Z15_FILORIG <= 'TZ'
			_cFornece := '000006'
		ElseIf TMP->Z15_FILORIG == 'BH'
			_cFornece := '000004'
		EndIf
		
		aAdd(_aCab,{"F1_TIPO",			'N'         	, 	Nil		})
		aAdd(_aCab,{"F1_FORMUL",      	"N" 			, 	Nil		})
		aAdd(_aCab,{"F1_DOC",         	SF2->F2_DOC     , 	Nil		})
		aAdd(_aCab,{"F1_SERIE",      	SF2->F2_SERIE 	, 	Nil		})
		aAdd(_aCab,{"F1_EMISSAO",     	SF2->F2_EMISSAO	, 	Nil		})
		aAdd(_aCab,{"F1_FORNECE",     	_cFornece		, 	Nil		})
		aAdd(_aCab,{"F1_LOJA",        	SF2->F2_FILIAL  , 	Nil		})
		aAdd(_aCab,{"F1_ESPECIE",     	"NFE"			, 	Nil		})
		aAdd(_aCab,{"F1_COND",			SF2->F2_COND	, 	Nil		})
		
		_aItens := {}
		DbSelectArea('SD2')
		DbSetOrder(3)
		DbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE,.F.)
		Do While !Eof() .and. SD2->D2_FILIAL == SF2->F2_FILIAL .and. SD2->D2_DOC == SF2->F2_DOC .and. SD2->D2_SERIE == SF2->F2_SERIE
			_aLinha := {}
			
			aAdd(_aLinha,{"D1_ITEM",	strzero(len(_aItens)+1,4)		, 	Nil	})
//			aAdd(_aLinha,{"D1_ITEM",	SD2->D2_ITEM		 			, 	Nil	})
			aAdd(_aLinha,{"D1_COD", 	SD2->D2_COD						, 	Nil	})
			aAdd(_aLinha,{"D1_UM", 		SD2->D2_UM						, 	Nil	})
			aAdd(_aLinha,{"D1_QUANT",	SD2->D2_QUANT					, 	Nil	})
			aAdd(_aLinha,{"D1_VUNIT",	SD2->D2_PRUNIT					,	Nil	})
			aAdd(_aLinha,{"D1_TOTAL",	SD2->D2_QUANT * SD2->D2_PRUNIT	, 	Nil	})
			aAdd(_aLinha,{"D1_TES",   	_cTes							,  	Nil	})
			aAdd(_aLinha,{"D1_LOCAL",	SD2->D2_LOCAL					, 	Nil	})
			
			DbSkip()
			aAdd( _aItens, _aLinha )
			
		EndDo
		
		cFilAnt   := SF2->F2_LOJA
		lMsErroAuto := .f.
		MSExecAuto({|x,y,z|Mata103(x,y,z)},_aCab,_aItens,3)
		
		If lMsErroAuto
			MostraErro()
		Else
			_cQuery := "UPDATE " + RetSqlName('Z15')
			_cQuery += " SET Z15_CLDATA = '" + dtos(date()) + "', Z15_CLUSER = '" + cUserName + "', Z15_CLHORA = '" + left(time(),2)+substr(time(),4,2) + "'"
			_cQuery += " WHERE R_E_C_N_O_ = " + str(TMP->R_E_C_N_O_)
			TcSqlExec(_cQuery)
			
			If !empty(TMP->Z15_VENCTO)
				_cQuery := "UPDATE " + RetSqlName('SE2') + " SET E2_VENCTO = '" + TMP->Z15_VENCTO + "',E2_VENCREA = '" + TMP->Z15_VENCTO + "',E2_VENCORI = '" + TMP->Z15_VENCTO + "', E2_NATUREZ = '182'"
				_cQuery += " WHERE E2_MSFIL = '" + cFilAnt + "'"
				_cQuery += " AND E2_NUM = '" + SF1->F1_DOC + "'"
				_cQuery += " AND E2_PREFIXO = '" + SF1->F1_PREFIXO + "'"
				_cQuery += " AND E2_FORNECE = '" + SF1->F1_FORNECE + "'"
				_cQuery += " AND E2_LOJA = '" + SF1->F1_LOJA + "'"
				TcSqlExec(_cQuery)
			EndIf
			
			--_nNFEA
			++_nNFEP
			
			_nSecF   := int(seconds())
			_nSecP   := (_nSecF - _nSecI) * _nNFEP
			_cTempoP := strzero(int(_nSecP/3600),2) + ':' + strzero(int(mod(_nSecP, 60)),2)
			
			_nSecA   := (_nSecF - _nSecI) * _nNFEA
			_cTempoA := strzero(int(_nSecA/3600),2) + ':' + strzero(int(mod(_nSecA, 60)),2)
			
			_oDlgRefresh()
			
		EndIf
		//IncProc("Gerando nota de entrada")
		
		DbSelectArea('TMP')
		DbSkip()
		
	EndDo
	
	aRotina   := aClone(_aRotina)
	aCores    := aClone(_aCores)
	cCadastro := _cCadastro
	cFilAnt   := _cFilAnt
	
EndIf

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Z15GeraNF(_cNumPed)
/////////////////////////////////
_cNota := ''
//IncProc('Gerando Nota Fiscal para o PV ' + SC5->C5_NUM + " (" + alltrim(str(_nPedido))+ '/' + alltrim(str(_nLastRec)) + ")")

***********************************************
***********************************************

cNfSaida    := Alltrim(GetMv("MV_SERIE02")) //Serie NF de Saida

DbSelectArea('SM0')
_cCnpj := SM0->M0_CGC
Set Filter to  SM0->M0_CGC == _cCnpj .and. SM0->M0_CODIGO == cEmpAnt
_cFiliais := ''
_cQueryF  := ''
DbGotop()
Do While _cCnpj == SM0->M0_CGC .AND. !eof()
	_cFiliais += SM0->M0_CODFIL + ','
	DbSkip()
EndDo
Set Filter To
DbSeek(cEmpAnt+cFilAnt)
_cFiliais := FormatIn(left(_cFiliais,len(_cFiliais)-1),',')

_cSerie  := '8  '

_cNota := Posicione('SX5',1,cFilAnt+'8','X5_DESCRI')
//DbCloseArea()
_cNota := iif(empty(_cNota),'000000001',_cNota)

_cQuery := "UPDATE " + RetSqlName('SX5')
_cQuery += _cEnter   + "SET X5_DESCRI = '" + _cNota + "', X5_DESCSPA ='" + _cNota + "', X5_DESCENG ='" + _cNota + "'"
_cQuery += _cEnter   + "WHERE X5_TABELA = '01'"
_cQuery += _cEnter   + "AND X5_FILIAL IN " + _cFiliais
_cQuery += _cEnter   + "AND X5_CHAVE = '8'"
_cQuery += _cEnter   + "AND D_E_L_E_T_ = ''"

TcSqlExec(_cQuery)

***********************************************
***********************************************
/*
DbSelectArea('SC6')
DbSeek(SC5->C5_FILIAL + SC5->C5_NUM,.f.)
_nTotal := 0
Do While !eof() .and. SC5->C5_FILIAL == SC6->C6_FILIAL .and. SC5->C5_NUM == SC6->C6_NUM
RecLock('SD2',.t.)
SD2->D2_FILIAL	:= SC6->C6_FILIAL
SD2->D2_ITEM	:= SC6->C6_ITEM
SD2->D2_COD		:= SC6->C6_PRODUTO
SD2->D2_UM		:= SC6->C6_UM
SD2->D2_QUANT	:= SC6->C6_QTDVEN
SD2->D2_PRCVEN	:= SC6->C6_PRCVEN
SD2->D2_TOTAL	:= SC6->C6_VALOR
SD2->D2_TES		:= SC6->C6_TES
SD2->D2_CF		:= SC6->C6_CF
//SD2->D2_CONTA	:= SC6->C6_
SD2->D2_PEDIDO	:= SC6->C6_NUM
SD2->D2_ITEMPV	:= SC6->C6_ITEM
SD2->D2_CLIENTE	:= SC6->C6_CLI
SD2->D2_LOJA	:= SC6->C6_LOJA
SD2->D2_LOCAL	:= SC6->C6_LOCAL
SD2->D2_DOC		:= _cNota
SD2->D2_SERIE	:= _cSerie
SD2->D2_GRUPO	:= SC6->C6_GRUPO
SD2->D2_TP		:= 'PA'
SD2->D2_EMISSAO	:= date()
SD2->D2_PRUNIT	:= SC6->C6_PRCVEN
SD2->D2_NUMSEQ	:= _cNumSeq
SD2->D2_EST		:= SC5->C5_ESTCLI
SD2->D2_TIPO	:= 'N'
SD2->D2_CLASFIS	:= SB1->B1_ORIGEM + '90'
SD2->D2_VALBRUT	:= SC6->C6_TOTAL
SD2->D2_SITTRIB	:= 'N1'
SD2->D2_ALIQSOL	:= 17
MsUnLock()

RecLock('SFT',.t.)
SFT->FT_FILIAL	:= SD2->D2_FILIAL
SFT->FT_ENTRADA	:= date()
SFT->FT_EMISSAO	:= date()
SFT->FT_NFISCAL	:= SD2->D2_DOC
SFT->FT_SERIE	:= SD2->D2_SERIE
SFT->FT_CLIEFOR	:= SD2->D2_CLIENTE
SFT->FT_LOJA	:= SD2->D2_LOJA
SFT->FT_ESTADO	:= SC5->C5_ESTADO
SFT->FT_CFOP	:= SD2->D2_CF
SFT->FT_VALCONT	:= _nTotal
SFT->FT_ISENICM	:= _nTotal
SFT->FT_ESPECIE	:= 'SPED'
SFT->FT_CONTA	:= SD2->D2_CONTA
SFT->FT_PRODUTO	:= SD2->D2_COD
SFT->FT_TIPOMOV := 'S'
SFT->FT_ITEM	:= SD2->D2_ITEM
SFT->FT_CLASFIS	:= SD2->D2_CLASFIS
SFT->FT_CTIPI	:= SD2->D2_
SFT->FT_POSIPI	:= SB1->B1_POSIPI
SFT->FT_IDENTF3	:= '000001'
SFT->FT_ESTOQUE	:= 'N'
SFT->FT_DESPIPI := '53'
SFT->FT_QUANT	:= SD2->D2_QUANT
SFT->FT_PRCUNIT	:= SD2->D2_PRUNIT
SFT->FT_TOTAL	:= SD2->D2_TOTAL
SFT->FT_CLIENT	:= SD2->D2_CLIENTE
SFT->FT_LOJENT	:= SD2->D2_LOJA
SFT->FT_CSTISS	:= '07'
SFT->FT_ALIQSOL := 17
SFT->FT_ALQFECP := 1
SFT->FT_CSTCOF  := '07'
SFT->FT_CSTPIS	:= '07'
SFT->FT_AGREG	:= 'S'
MsUnLock()

RecLock('SC9',.f.)
SC9->C9_NOTA 	:= SD2->D2_DOC
SC9->C9_SERIE  	:= SD2->D2_SERIE
SC9->C9_BLEST   := '10'
SC9->C9_BLCRED  := '10'
MsUnLock()

RecLock('SC6',.f.)
SC6->C6_QTDENT	:= SC6->C6_QTDVEN
SC6->C6_NOTA 	:= SD2->D2_DOC
SC6->C6_SERIE  	:= SD2->D2_SERIE
MsUnLock()

_nTotal += SC6->C6_VALOR

DbSkip()

EndDo

RecLock('SF2',.t.)
SF2->F2_FILIAL	:= SD2->D2_FILIAL
SF2->F2_DOC		:= SD2->D2_DOC
SF2->F2_SERIE	:= SD2->D2_SERIE
SF2->F2_CLIENTE	:= SD2->D2_CLIENTE
SF2->F2_LOJA	:= SD2->D2_LOJA
SF2->F2_COND	:= ''
SF2->F2_DUPL	:= SD2->D2_DOC
SF2->F2_EMISSAO	:= date()
SF2->F2_EST		:= SC5->C5_ESTADO
SF2->F2_TIPOCLI	:= 'R'
SF2->F2_VALBRUT	:= _nTotal
SF2->F2_VALMERC	:= _nTotal
SF2->F2_TIPO	:= 'N'
SF2->F2_TRANSP	:= '000001'
SF2->F2_VEND1	:= '000001'
SF2->F2_VALFAT	:= _nTotal
SF2->F2_ESPECIE	:= 'SPED'
//SF2->F2_PREFIXO	:=
SF2->F2_HORA	:= left(time(),5)
SF2->F2_MOEDA	:= '1'
SF2->F2_CLIENT	:= SD2->D2_CLIENTE
SF2->F2_LOJENT	:= SD2->D2_LOJA
SF2->F2_TPFRETE	:= 'F'
MsUnLock()

RecLock('SF3',.t.)
SF3->F3_FILIAL	:= SD2->D2_FILIAL
SF3->F3_ENTRADA	:= date()
SF3->F3_NFISCAL	:= SD2->D2_DOC
SF3->F3_SERIE	:= SD2->D2_SERIE
SF3->F3_CLIEFOR	:= SD2->D2_CLIENTE
SF3->F3_LOJA	:= SD2->D2_LOJA
SF3->F3_CFO		:= SD2->D2_CF
SF3->F3_ESTADO	:= SC5->C5_ESTADO
SF3->F3_EMISSAO	:= date()
SF3->F3_VALCONT	:= _nTotal
SF3->F3_ISENICM	:= _nTotal
SF3->F3_ESPECIE	:= 'SPED'
SF3->F3_IDENTFT	:= '000001'
SF3->F3_MDCAT79 := '???????????????????????????????'
SF3->F3_CLIENT	:= SD2->D2_CLIENTE
SF3->F3_LOJENT	:= SD2->D2_LOJA
SF3->F3_CSTISS	:= '07'
MsUnLock()
*/
_cNota := GravaNFS()

If SF2->(DbSeek(cFilAnt + SC5->C5_NOTA + SC5->C5_SERIE,.f.))
	If !empty(SC5->C5_DATA1)
		_cQuery := "UPDATE " + RetSqlName('SE1') + " SET E1_VENCTO = '" + dtos(SC5->C5_DATA1) + "',E1_VENCREA = '" + dtos(SC5->C5_DATA1) + "',E1_VENCORI = '" + dtos(SC5->C5_DATA1) + "'"
		_cQuery += " WHERE E1_MSFIL = '" + cFilAnt + "'"
		_cQuery += " AND E1_NUM = '" + SF2->F2_DOC + "'"
		_cQuery += " AND E1_PREFIXO = '" + SF2->F2_PREFIXO + "'"
		_cQuery += " AND E1_CLIENTE = '" + SF2->F2_CLIENTE + "'"
		_cQuery += " AND E1_LOJA = '" + SF2->F2_LOJA + "'"
		TcSqlExec(_cQuery)
	EndIf
	
	_cQuery := "UPDATE " + RetSqlName('Z15')
	_cQuery += " SET Z15_NOTA = '" + _cNota  + "', Z15_SERIE = '" + SF2->F2_SERIE  + "', Z15_NFDATA = '" + dtos(date()) + "', Z15_NFUSER = '" + cUserName + "', Z15_NFHORA = '" + left(time(),2)+substr(time(),4,2) + "'"
	_cQuery += " WHERE R_E_C_N_O_ = " + str(TMP->R_E_C_N_O_)
	TcSqlExec(_cQuery)
	_oDlgRefresh()
EndIf

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LibPedid(_cNumPed)
/////////////////////////////////

Local aArea		:= GetArea()
Local nX		:= 0
Local lLiberOk  := .T.
Local lCredito  := .T.
Local lEstoque  := .T.
Local lLiber    := .T.
Local lTransf   := .F.

DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+_cNumPed)
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->( DbSeek( xFilial("SC6")+_cNumPed ) )
	Do While SC6->( !Eof() ) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == _cNumPed
		
		DbSelectArea("SC9")
		SC9->( DbSetOrder(1) )
		
		If SC9->( DbSeek( xFilial("SC9")+_cNumPed+SC6->C6_ITEM+"01"+SC6->C6_PRODUTO ) )
			Reclock("SC9",.F.)
		Else
			Reclock("SC9",.T.)
		EndIf
		
		SC9->C9_FILIAL 	:= xFilial("SC9")
		SC9->C9_PEDIDO	:= SC6->C6_NUM
		SC9->C9_ITEM	:= SC6->C6_ITEM
		SC9->C9_CLIENTE	:= SC6->C6_CLI
		SC9->C9_LOJA	:= SC6->C6_LOJA
		SC9->C9_PRODUTO	:= SC6->C6_PRODUTO
		SC9->C9_QTDLIB	:= SC6->C6_QTDVEN
		SC9->C9_DATALIB	:= dDatabase
		SC9->C9_SEQUEN	:= "01"
		SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
		SC9->C9_LOCAL	:= "01"
		SC9->C9_BLEST  	:= ""
		SC9->C9_BLCRED 	:= ""
		SC9->C9_TPCARGA	:= "2"
		
		Msunlock()
		
		SC6->( DbSkip() )
		
	EndDo
	
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "S"
	MsUnlock()
	
EndIf

RestArea(aArea)

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaNFS()
//////////////////////////

Local aAreaAnt	 	:= GetArea()

Local aPvlNfs	 	:= {}
Local _nPrcVen    := 0
Local _nRegDAK   	:= 0
Local lMostraCtb 	:= .F.
Local lAglutCtb  	:= .F.
Local lCtbOnLine 	:= .F.
Local lCtbCusto  	:= .F.
Local lReajuste  	:= .F.
Local lAtuSA7    	:= .F.
Local lECF       	:= .F.
Local nCalAcrs   	:= 1
Local nArredPrcLis 	:= 1
Local cRot       	:= ProcName()
Local cPedido := SC5->C5_NUM

// PREPARANDO A NOTA FISCAL
MV_PAR01 := 2           // Mostra Lan‡.Contab ?  Sim/Nao
MV_PAR02 := 2           // Aglut. Lan‡amentos ?  Sim/Nao
MV_PAR03 := 2           // Lan‡.Contab.On-Line?  Sim/Nao
MV_PAR04 := 2           // Contb.Custo On-Line?  Sim/Nao
MV_PAR05 := 1           // Reaj. na mesma N.F.?  Sim/Nao
MV_PAR06 := 0           // Taxa deflacao ICMS ?  Numerico
MV_PAR07 := 3           // Metodo calc.acr.fin?  Taxa defl/Dif.lista/% Acrs.ped
MV_PAR08 := 3           // Arred.prc unit vist?  Sempre/Nunca/Consumid.final
MV_PAR09 := Space( 04 ) // Agreg. liberac. de ?  Caracter
MV_PAR10 := Space( 04 ) // Agreg. liberac. ate?  Caracter
MV_PAR11 := 2           // Aglut.Ped. Iguais  ?  Sim/Nao
MV_PAR12 := 0           // Valor Minimo p/fatu?
MV_PAR13 := Space( 06 ) // Transportadora de  ?
MV_PAR14 := 'ZZZZZZ'    // Transportadora ate ?
MV_PAR15 := 2           // Atualiza Cli.X Prod?  Sim/Nao
MV_PAR16 := 1           // Emitir             ?  Nota/Cupom Fiscal

lMostraCtb  := MV_PAR01 == 1
lAglutCtb   := MV_PAR02 == 1
lCtbOnLine  := MV_PAR03 == 1
lCtbCusto   := MV_PAR04 == 1
lReajuste   := MV_PAR05 == 1

LAtuSA7lECF := .F.
lFaturado   := .F.

// Verifica se o pedido ja foi faturado
IF lFaturado
	Aviso( cRot, 'Pedido ja faturado anteriormente !!!', {'&Abandonar'} )
	Return( .F. )
Endif

// Gera nota.
SC5->( dbSetOrder( 1 ) ) //C5_FILIAL + C5_NUM
If SC5->( MsSeek( xFilial( 'SC5' ) + cPedido, .F. ) )
	
	SC6->( DbSetOrder(1) ) //C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	
	SC9->( DbSetOrder(1) ) //C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO
	
	If SC9->( DbSeek( xFilial("SC9")+cPedido ) )
		
		Do While !SC9->(EOF()) .and. SC9->C9_PEDIDO == cPedido .and. SC9->C9_FILIAL == xFilial('SC9')
			
			If SC6->( DbSeek( xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO ) )
				
				SE4->( dbSetOrder( 1 ) )
				SE4->( MsSeek( xFilial( 'SE4' ) + SC5->C5_CONDPAG, .F. ) )
				
				// Posiciona no produto
				SB1->( dbSetOrder( 1 ) )
				SB1->( MsSeek( xFilial( 'SB1' ) + SC6->C6_PRODUTO, .F. ) )
				
				// Posiciona no saldo em estoque
				SB2->( dbSetOrder( 1 ) )
				SB2->( MsSeek( xFilial( 'SB2' ) + SC6->C6_PRODUTO + SC6->C6_LOCAL, .F. ) )
				
				// Posiciona no TES
				cTes := SC6->C6_TES
				SF4->( dbSetOrder( 1 ) )
				SF4->( MsSeek( xFilial( 'SF4' ) + cTes, .F. ) )
				
				// Converte o valor unitario em Reais quando pedido em outra moeda
				_nPrcVen := SC9->C9_PRCVEN
				If ( SC5->C5_MOEDA <> 1 )
					dbSelectArea( 'SM2' )
					dbSetOrder( 1 )
					If dbSeek( DTOS( dDataBase ) )
						_nPrcVen := SC9->C9_PRCVEN * SM2->M2_MOEDA2
					Else
						_nPrcVen := xMoeda( _nPrcVen, SC5->C5_MOEDA, 1, dDataBase )
					EndIf
					
				EndIf
				
				// Monta array para gerar a nota fiscal
				Aadd( aPvlNfs, { SC9->C9_PEDIDO, ;
				SC9->C9_ITEM, ;
				SC9->C9_SEQUEN, ;
				SC9->C9_QTDLIB, ;
				_nPrcVen, ;
				SC9->C9_PRODUTO, ;
				.F., ;
				SC9->( RecNo() ), ;
				SC5->( RecNo() ), ;
				SC6->( RecNo() ), ;
				SE4->( RecNo() ), ;
				SB1->( RecNo() ), ;
				SB2->( RecNo() ), ;
				SF4->( RecNo() ), ;
				SC6->C6_LOCAL, ;
				_nRegDAK, ;
				SC9->C9_QTDLIB2} )
				
			Else
				
				MsgBox('Pedido de vendas não liberado','ATENÇÃO!!!','ALERT')
				aPvlNfs := {}
				Exit
				
			EndIf
			
			SC9->( DbSkip() )
			
		EndDo
		
	Else
		
		MsgBox('Pedido de vendas não liberado','ATENÇÃO!!!','ALERT')
		
	EndIf
	
Else
	
	MsgBox('Pedido de vendas não encontrado','ATENÇÃO!!!','ALERT')
	
EndIf

If !Empty( aPvlNfs )
	
	LimpaMoeda()
	
	//////////////////////////////////////////////////////////////////////
	/////	ponto de entrada para verificação da numeração da nota fiscal
	//////////////////////////////////////////////////////////////////////
	// ATUALIZA A TABELA DE NOTAS FISCAIS PARA CNPJs QUE TEM MAIS DE UMA FILIAL
	
	DbSelectArea('SM0')
	_cCnpj := SM0->M0_CGC
	Set Filter to  SM0->M0_CGC == _cCnpj .and. SM0->M0_CODIGO == cEmpAnt
	_cFiliais := ''
	_cQueryF  := ''
	DbGotop()
	Do While _cCnpj == SM0->M0_CGC .and. !eof()
		_cQueryF += _cEnter + "SELECT RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(NFE_ID)),9))+1)),9) NOTA"
		_cQueryF += _cEnter + "FROM SPED050 (NOLOCK)"
		_cQueryF += _cEnter + "WHERE ID_ENT = dbo.FN_GETIDSPED" +" ('" + SM0->M0_CODFIL + "')"
		_cQueryF += _cEnter + "AND LEFT(NFE_ID,1) = '" + GetMv('FS_LASSER') +"'"
		_cQueryF += _cEnter + "AND D_E_L_E_T_ = ''"
		_cQueryF += _cEnter + "AND LEN(RTRIM(NFE_ID))>9"
		If SM0->M0_CODFIL $ ('C0/CB')
			_cQueryF += _cEnter + "AND NFE_ID not BETWEEN  '8  000010000' AND '89'"
		EndIf
		_cQueryF += _cEnter + "UNION"
		_cFiliais += SM0->M0_CODFIL + ','
		DbSkip()
	EndDo
	Set Filter To
	DbSeek(cEmpAnt+cFilAnt)
	
	_cFiliais := FormatIn(left(_cFiliais,len(_cFiliais)-1),',')
	
	_cQuery2 := _cEnter + "SELECT ISNULL(MAX(NOTA),'') NOTA"
	_cQuery2 += _cEnter + "FROM"
	_cQuery2 += _cEnter + "("
	_cQuery2 += _cQueryF
	_cQuery2 += _cEnter + "SELECT RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(F2_DOC)),9))+1)),9) NOTA"
	_cQuery2 += _cEnter + "FROM SF2010"
	_cQuery2 += _cEnter + "WHERE F2_FILIAL IN " + _cfiliais
	_cQuery2 += _cEnter + "AND F2_SERIE = '" + GetMv('FS_LASSER') + "'"
	If SM0->M0_CODFIL $ ('C0/CB')
		_cQuery2 += _cEnter + "AND F2_SERIE+F2_DOC not BETWEEN  '8  000010000' AND '89'"
	EndIf
	_cQuery2 += _cEnter + "AND D_E_L_E_T_ = ''"
	_cQuery2 += _cEnter + ") A"
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery2),"_NF", .T., .T.)
	_cNota := _NF->NOTA
	DbCloseArea()
	_cNota := iif(empty(_cNota),'000000001',_cNota)
	
	_cQuery := "UPDATE " + RetSqlName('SX5')
	_cQuery += _cEnter   + "SET X5_DESCRI = '" + _cNota + "', X5_DESCSPA ='" + _cNota + "', X5_DESCENG ='" + _cNota + "'"
	_cQuery += _cEnter   + "WHERE X5_TABELA = '01'"
	_cQuery += _cEnter   + "AND X5_CHAVE = '" + GetMv('FS_LASSER') + "'"
	_cQuery += _cEnter   + "AND D_E_L_E_T_ = ''"
	_cQuery += _cEnter   + "AND X5_FILIAL IN " + _cFiliais
	
	TcSqlExec(_cQuery)
	
	_aAlias := GetArea()
	
	_cSerie := padr(GetMv("FS_LASSER"),3,' ')
	_cNumNFX5F := alltrim(Posicione('SX5',1,cFilAnt + '01' + _cSerie,'X5_DESCRI'))
	DbSelectArea('SX5')
	_xFilial := strtran(strtran(strtran(strtran(_cFiliais,"'",""),"(",""),")",""),",","")
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			Do While !RecLock('SX5',.f.)
			EndDo
		EndIf
	Next
	
	DbSelectArea('SF1')
	IndRegua("SF1",CriaTrab(,.f.),SF1->(IndexKey(1)),,,"Selecionando Registros...")
	Do While SF1->(DbSeek(xFilial('SF1') + padr(_cNumNFX5F,9,' ') + _cSerie,.f.))
		_cNumNFX5F := Soma1(_cNumNFX5F)
	EndDo
	RetIndex()
	cNumero := _cNumNFX5F
	
	SF2->(DbSetOrder(1))
	Do While SF2->(DbSeek(xFilial('SF2') + padr(_cNumNFX5F,9,' ') + _cSerie,.f.))
		_cNumNFX5F := Soma1(_cNumNFX5F)
	EndDo
	
	DbSelectArea('SX5')
	_xFilial := strtran(strtran(strtran(strtran(_cFiliais,"'",""),"(",""),")",""),",","")
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			MsUnLock()
		EndIf
	Next
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			RecLock('SX5',.f.)
			SX5->X5_DESCRI  := _cNumNFX5F
			SX5->X5_DESCSPA := _cNumNFX5F
			SX5->X5_DESCENG := _cNumNFX5F
			MsUnLock()
		EndIf
	Next
	
	RestArea(_aAlias)
	//////////////////////////////////////////////////////////////////////
	_cNota := MaPvlNfs(aPvlNfs,;
	_cSerie,;
	lMostraCtb,;
	lAglutCtb,;
	lCtbOnLine,;
	lCtbCusto,;
	lReajuste,;
	nCalAcrs,;
	nArredPrcLis,;
	lAtuSA7,;
	lECF,;
	'',;
	,;
	NIL )
	
	_cNota := PadR(_cNota,9,' ')
	
EndIf

RestArea( aAreaAnt )

Return( _cNota )

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _oDlgRefresh()
/////////////////////////////
_oItensT:refresh()
_oItensP:refresh()
_oItensA:refresh()
_oPedT:refresh()
_oPedP:refresh()
_oPedA:refresh()
_oNFST:refresh()
_oNFSP:refresh()
_oNFSA:refresh()
_oNFET:refresh()
_oNFEP:refresh()
_oNFEA:refresh()
_oHoraI:refresh()
_oTempoP:refresh()
Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg ()
////////////////////////////
Private _cAlias := Alias ()
Private _aRegs  := {}

aAdd(_aRegs,{_cPerg, "01", "Filial Origem              ","","","mv_ch1", "C",02,  0,  0, "G", "" , "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0","",""})
aAdd(_aRegs,{_cPerg, "02", "Cliente                    ","","","mv_ch2", "C",06,  0,  0, "G", "" , "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","",""})
aAdd(_aRegs,{_cPerg, "03", "Loja                       ","","","mv_ch3", "C",02,  0,  0, "G", "" , "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0","",""})
aAdd(_aRegs,{_cPerg, "04", "Valor total a ser gerado   ","","","mv_ch4", "N",12,  2,  0, "G", "" , "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "05", "Valor por Nota             ","","","mv_ch5", "N",12,  2,  0, "G", "" , "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","",""})
aAdd(_aRegs,{_cPerg, "06", "Vencimento                 ","","","mv_ch6", "D",08,  0,  0, "G", "" , "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","",""})

DbSelectArea("SX1")
DbSetOrder(1)
For _i := 1 to Len (_aRegs)
	RecLock ("SX1", !DbSeek (_cPerg + _aRegs [_i, 2]))
	For _j := 1 to FCount ()
		If _j <= Len (_aRegs [_i]) .and. !(left (fieldname (_j), 6) $ "X1_CNT/X1_PRESEL")
			FieldPut (_j, _aRegs [_i, _j])
		Endif
	Next
	MsUnlock ()
Next
DbSelectArea (_cAlias)

Return
