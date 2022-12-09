#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_FECHSTK()
// Autor 		Alexandre Dalpiaz
// Data 		07/03/2013
// Descricao  	Fechamento de estoque
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_STKCLOSE()
///////////////////////////

_cPerg := 'LSSTKCLOSE'

//////////////////////////////////////////////////////
// PARAMETROS                                       //
//                                                  //
// MV_PAR01 - EMPRESA                               //
// MV_PAR02 - FILIAL DE                             //
// MV_PAR03 - FILIAL ATE                            //
// MV_PAR04 - DATA PARA FECHAMENTO   --- NO CASO DE RECALCULDO DO SALDO ATUAL, ESTA DATA SERÁ CONSIDERADA COMO A DATA DO ULTIMO FECHAMENTO REALIZADO
// MV_PAR05 - PRODUTO                               //
// MV_PAR06 - OPERACAO                              //
//////////////////////////////////////////////////////

ValidPerg()
_lSair := .f.
Do While !_lSair
	If !Pergunte(_cPerg, .t.)
		Return()
	EndIf
	mv_par01 := upper(mv_par01)
	mv_par02 := upper(mv_par02)
	mv_par03 := upper(mv_par03)
	
	If mv_par04 > date()
		MsgBox('Data selecionada maior que a data atual. Verifique!','ATENÇÃO!!!','ALERT')
		loop
	EndIf
	
	_cTexto := 'Data para recálculo: ' + dtoc(mv_par04) + _cEnter
	If empty(mv_par01)
		_lSair := MsgBox('Você selecionou todas empresas para fechamento do estoque.','Confirma processamento?','YESNO')
		_cFilialde := ''
		_cFilialAte := 'ZZ'
	ElseIf !(mv_par01 $ '01/A0/C0/G0/R0/T0/BH/L0')
		MsgBox('Empresa inválida. Selecione a matriz da empresa (01/A0/C0/G0/R0/T0/BH/L0)','ATENÇÃO!!!','ALERT')
		loop
	Else
		
		If mv_par01 == '01' .and. (mv_par02 < '01' .or. mv_par03 > '99')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de 01 a 99','ATENÇÃO!!!','ALERT')
			loop
		ElseIf mv_par01 == 'A0' .and. (mv_par02 < 'A0' .or. mv_par03 > 'AZ')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de A0 a AZ','ATENÇÃO!!!','ALERT')
			loop
		ElseIf mv_par01 == 'BH' .and. (mv_par02 < 'B0' .or. mv_par03 > 'BZ')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de B0 a BZ','ATENÇÃO!!!','ALERT')
			loop
		ElseIf mv_par01 == 'C0' .and. (mv_par02 < 'C0' .or. mv_par03 > 'EZ')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de C0 a EZ','ATENÇÃO!!!','ALERT')
			loop
		ElseIf mv_par01 == 'G0' .and. (mv_par02 < 'G0' .or. mv_par03 > 'GZ')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de G0 a GZ','ATENÇÃO!!!','ALERT')
			loop
		ElseIf mv_par01 == 'L0' .and. (mv_par02 < 'L0' .or. mv_par03 > 'LZ')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de L0 a LZ','ATENÇÃO!!!','ALERT')
			loop
		ElseIf mv_par01 == 'P0' .and. (mv_par02 < 'P0' .or. mv_par03 > 'PZ')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de P0 a PZ','ATENÇÃO!!!','ALERT')
			loop
		ElseIf mv_par01 == 'R0' .and. (mv_par02 < 'R0' .or. mv_par03 > 'RZ')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de R0 a RZ','ATENÇÃO!!!','ALERT')
			loop
		ElseIf mv_par01 == 'T0' .and. (mv_par02 < 'T0' .or. mv_par03 > 'TZ')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de T0 a TZ','ATENÇÃO!!!','ALERT')
			loop
		ElseIf mv_par01 == 'V0' .and. (mv_par02 < 'V0' .or. mv_par03 > 'VZ')
			MsgBox('Intervalo de filial inválido para essa Empresa. Selecione filiais de V0 a VZ','ATENÇÃO!!!','ALERT')
			loop
		Else
			_cFilialde  := mv_par02
			_cFilialAte := mv_par03
		EndIf
		
		_cTexto := 'Data inicial para recálculo dos saldos: ' + dtoc(mv_par04) + _cEnter
		If mv_par06 <> 2
			_cQuery := "SELECT count(*) QUANT"
			_cQuery += _cEnter + " FROM " + RetSqlName('SB9') + " (NOLOCK)"
			_cQuery += _cEnter + " WHERE B9_DATA 		= '" + dtos(mv_par04) + "'"
			_cQuery += _cEnter + " AND D_E_L_E_T_ 		= ''"
			_cQuery += _cEnter + " AND B9_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
			If !empty(mv_par05)
				_cQuery += _cEnter + " AND B9_COD 		= '" + mv_par05 + "'"
			EndIf
			MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SB9', .F., .T.)},'Verifiando fechamendos de estoque...')
			
			If _SB9->QUANT > 0 .and. !MsgBox('Já existe um fechamento de estoque com a data informada.','Excluir fechamento anterior?','YESNO')
				DbCloseArea()
				loop
			Else
				_cFilAnt := cFilAnt
				cFilAnt  := _cFilialDe
				If GetMv('MV_ULMES') == mv_par04 .and. !MsgBox('Já existe um fechamento de estoque com a data informada, porém sem saldos iniciais.','Excluir fechamento anterior?','YESNO')
					DbCloseArea()
					loop
				EndIf
			EndIf
			DbCloseArea()
		EndIf
		_cTexto := 'Data do Fechamento: ' + dtoc(mv_par04) + _cEnter
	EndIf
	
	_cTexto += 'Empresa: ' + iif(empty(mv_par01),'Todas',mv_par01 + ' - ' + Posicione('SM0',1,cEmpAnt + mv_par01,'M0_NOME')) + _cEnter
	If empty(_cFilialDe)
		_cTexto += 'Filiais: Todas' + _cEnter
	Else
		_cTexto += 'Da Filial: '    + _cFilialDe   + ' - ' + Posicione('SM0',1,cEmpAnt + _cFilialDe ,'M0_FILIAL') + _cEnter
		_cTexto += 'Até a Filial: ' + _cFilialAte  + ' - ' + Posicione('SM0',1,cEmpAnt + _cFilialAte,'M0_FILIAL') + _cEnter
	EndIf
	If !empty(mv_par05)
		_cTexto += 'Produto: ' + mv_par05 + ' - ' + Posicione('SB1',1,xFilial('SB1') + mv_par05,'B1_DESC') + _cEnter
	EndIf
	_lSair := MsgBox(_cTexto,iif(mv_par06 == 1,'Confirma fechamento de estoque?','Confirma ajuste dos saldo atual do estoque?'),'YESNO')
EndDo
_cLog := ''
If mv_par06 <> 2
	_cLog += 'De: ' + left(time(),5) + ' até '
	Processa({|| DELETASB9()},'Apagando fechamento anterior.')
	_cLog += left(time(),5) + ' - Apagando fechamento anterior.' + _cEnter
EndIf

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////// seleciona produtos com movimentação no mês anterior à data do fechamento                             //
///////////// 27/01/2014 - seleciona produtos com movimentação até a data fornecida no parametro MV_PAR04          //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private _aUsuMail := U_fUser(1, .T., __cUserId)
Private aDiverg := {}
Private cArqLog
Private nHdlLog

IF MV_PAR06 <> 2
	_cQuery := ""
	_cQuery := SB9QRY()
	
	_cLog += 'De: ' + left(time(),5) + ' até '
	
	MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SB9A', .F., .T.)},'Calculando saldos finais' )
	
	Count to _nLastRec
	DbgoTop()
	_cLog += left(time(),5) + ' - Calculando saldos finais' + _cEnter
	
	//If mv_par06 <> 2
	Processa({|| GRAVASB9()}, 'Gravando fechamento de estoque em ' + dtoc(mv_par04) + '.')
	//Else
	//	Processa({|| GRAVASB9()}, 'Gravando saldos atuais.')
	//EndIf
	
	DbCloseArea()
	
ENDIF
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////// 27/01/2014 - Calcula movimentos para atualizar o saldo da SB2 (saldo atual)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

IF MV_PAR06 <> 1
	_cQuery := ""
	_cQuery := SB2QRY()
	
	_cLog += 'De: ' + left(time(),5) + ' até '
	
	MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SB9A', .F., .T.)},'Calculando saldos finais' )
	
	Count to _nLastRec
	DbgoTop()
	_cLog += left(time(),5) + ' - Calculando saldos finais' + _cEnter
	
	//If mv_par06 <> 2
	//	Processa({|| GRAVASB9()}, 'Gravando fechamento inventário em ' + dtoc(mv_par04) + '.')
	//Else
	Processa({|| GRAVASB9()}, 'Gravando saldos atuais.')
	//EndIf
	
	DbCloseArea()
	
ENDIF

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


If mv_par06 <> 2
	MsgBox('Estoque de ' + dtoc(mv_par04) + ' fechado com sucesso.','OK','INFO')
Else
	MsgBox('Saldos de estoque recalculados a partir do fechamento de ' + dtoc(mv_par04) + '.','OK','INFO')
EndIf

Aviso('Fechamento de estoques',_cLog,{'OK'},3,'Log de proessamento')

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GRAVASB9()
///////////////////////////
/////////////
///////////// GRAVA O ESTOQUE FINAL CALCULADO PARA O FECHAMENTO
/////////////

ProcRegua(_nLastRec)

Do While !eof()

	_cFilial := SB9A->FILIAL
	
	aDiverg := {}
	cArqLog := "\Logs\LogDivSld_"+_cFilial+"_"+DtoS(dDataBase)+"_"+StrTran(Time(),":","")+".log"
	
	If File(cArqLog)
		nHdlLog := fOpen(cArqLog,2)
		If nHdlLog == -1
//			MsgAlert("Impossivel Abrir Arquivo " + cArqLog + " Verificar...","Atencao!")
			Conout("Impossivel Abrir Arquivo " + cArqLog + " Verificar...")
			Return 
		Endif
		fSeek(nHdlLog,0,2)
	Else	
	    nHdlLog := fCreate(cArqLog)
		If nHdlLog == -1
//			MsgAlert("Impossivel Criar Arquivo " + cArqLog + " Verificar...","Atencao!")
			Conout("Impossivel Criar Arquivo " + cArqLog + " Verificar...")
			Return 
		Endif
		cLine := 'Filial Produto         Descrição                               Sld.Anter. Sld.Atual' + _cEnter + _cEnter
		fWrite(nHdlLog,cLine,Len(cLine))
	EndIf

	_cLog += 'De: ' + left(time(),5) + ' até '
	If mv_par06 <> 2
		_cFilAnt := cFilAnt
		cFilAnt  := SB9A->FILIAL
		PutMv('MV_ULMES',dtos(mv_par04))
		cFilAnt  := _cFilAnt
	EndIf
	
	_nQtProc := 0
	Do While !eof() .and. _cFilial == SB9A->FILIAL
		IncProc('Filial: ' + _cFilial + ' ' + str(--_nLastRec))
		++_nQtProc
		
		DbSelectArea('SB2')
		If DbSeek(SB9A->FILIAL + SB9A->CODIGO + '01',.f.)
			
			RecLock('SB2',.f.)
			If mv_par06 <> 2
				SB2->B2_QFIM  	:= SB9A->QUANT
				SB2->B2_VFIM1 	:= SB2->B2_QFIM * SB2->B2_CM1
			EndIf
			If mv_par06 <> 1
				If SB2->B2_QATU <> (SB9A->QUANT + SB9A->ATUAL)
					aAdd(aDiverg,{SB9A->FILIAL,SB9A->CODIGO,SB2->B2_QATU,(SB9A->QUANT + SB9A->ATUAL)})
                    nPosDiv := Len(aDiverg)
					cLine	:= aDiverg[nPosDiv,1]+'     '+Padr(aDiverg[nPosDiv,2],15)+' '+Padr(Posicione("SB1",1,xFilial("SB1")+aDiverg[nPosDiv,2],"B1_DESC"),40)+' '+Str(aDiverg[nPosDiv,3],8,2)+'   '+Str(aDiverg[nPosDiv,4],8,2)  + _cEnter
					fWrite(nHdlLog,cLine,Len(cLine))
				EndIf
				SB2->B2_QATU  	:= SB9A->QUANT + SB9A->ATUAL
				SB2->B2_VATU1 	:= SB2->B2_QFIM * SB2->B2_CM1
			EndIf
			MsUnLock()
			
		Else
			
			RecLock('SB2',.t.)
			SB2->B2_FILIAL 		:= SB9A->FILIAL
			SB2->B2_COD    		:= SB9A->CODIGO
			SB2->B2_LOCAL  		:= '01'
			If mv_par06 <> 2
				SB2->B2_QFIM 	:= SB9A->QUANT
				SB2->B2_VFIM1	:= SB2->B2_QFIM * SB2->B2_CM1
			EndIf
			If mv_par06 <> 1
				SB2->B2_QATU  	:= SB9A->QUANT + SB9A->ATUAL
				SB2->B2_VATU1 	:= SB2->B2_QFIM * SB2->B2_CM1
			EndIf
			MsUnLock()
			
		EndIf
		
//		If mv_par06 <> 2 .and. (SB9A->QTMOV <> 0 .OR. left(dtoc(mv_par04),5) == '31/12')
		If mv_par06 <> 2 .and. (SB9A->QTMOV <> 0 .OR. SB9A->QUANT <> 0 .OR. left(dtoc(mv_par04),5) == '31/12')
			RecLock('SB9',.t.)
			SB9->B9_FILIAL 		:= SB9A->FILIAL
			SB9->B9_DATA		:= mv_par04
			SB9->B9_COD			:= SB9A->CODIGO
			SB9->B9_LOCAL		:= '01'
			SB9->B9_QINI		:= SB9A->QUANT
			SB9->B9_VINI1 		:= IIF(SB9A->QUANT!=0,SB9A->CUSTO,0) //SB9A->CUSTO
			MsUnLock()
		EndIf
		
		DbSelectArea('SB9A')
		DbSkip()
		
	EndDo
	_cLog += left(time(),5) + ' - Filial: ' + _cFilial +  ' Total Prod: ' + alltrim(str(_nQtProc,6)) +  _cEnter

	fClose(nHdlLog)

	If ! Empty(aDiverg)
		EnvMailDiv()
	EndIf

EndDo

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function DELETASB9()
///////////////////////////
/////////////
///////////// apaga sb9 caso exista fechamento na mesma data
/////////////

_cQuery := "SELECT 'DELETE FROM " + RetSqlName('SB9') + " WHERE R_E_C_N_O_ = ' + CONVERT(VARCHAR,R_E_C_N_O_) DELETAR"
_cQuery += _cEnter + " FROM " + RetSqlName('SB9') + " (NOLOCK)"
_cQuery += _cEnter + " WHERE B9_DATA 		>= '" + dtos(mv_par04) + "' 	AND D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND B9_FILIAL 		BETWEEN '" + _cFilialDe + "' 	AND '" + _cFilialAte + "'"
If !empty(mv_par05)
	_cQuery += _cEnter + " AND B9_COD 		= '" + mv_par05 + "'"
EndIf
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SB9', .F., .T.)

count to _nLastRec
DbgoTop()
ProcRegua(_nLastRec)

Do While !eof()
	IncProc('Processando... ' + str(--_nLastRec))
	nValSql := TcSqlExec(_SB9->DELETAR)
	DbSkip()
EndDo

DbCloseArea()

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg ()
////////////////////////////

Private _cAlias := Alias ()
Private _aRegs  := {}

aAdd(_aRegs,{_cPerg, "01", "Empresa (branco p/ todas)  ","","","mv_ch1", "C",02,  0,  0, "G", "" , "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0","",""})
aAdd(_aRegs,{_cPerg, "02", "Filial de                  ","","","mv_ch2", "C",02,  0,  0, "G", "" , "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0","",""})
aAdd(_aRegs,{_cPerg, "03", "Filial até                 ","","","mv_ch3", "C",02,  0,  0, "G", "" , "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0","",""})
aAdd(_aRegs,{_cPerg, "04", "Data para fechamento       ","","","mv_ch4", "D",08,  0,  0, "G", "" , "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "05", "Produto                    ","","","mv_ch5", "C",15,  0,  0, "G", "" , "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1",""})
aAdd(_aRegs,{_cPerg, "06", "Operação                   ","","","mv_ch6", "N",01,  0,  0, "C", "" , "mv_par06", "Fechamento estoque", "", "", "", "", "Saldo atual", "", "", "", "", "Ambos", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Função responsável por gerar a query com os movimentos para gravar os dados na SB9 ///////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION SB9QRY()

Private cRet	:= ""

cRet := "SELECT FILIAL, CODIGO, SUM(QUANT) QUANT, SUM(CUSTO) CUSTO, SUM(ATUAL) ATUAL, SUM(QTMOV) QTMOV"
cRet += _cEnter + " FROM ("

If mv_par06 <> 2		// para fechamento de estoque ou ambos
	cRet += _cEnter + " ( "
	cRet += _cEnter + " SELECT D2_FILIAL FILIAL, D2_COD CODIGO, SUM(-D2_CUSTO1) CUSTO, SUM(-D2_QUANT) QUANT, 'SD2 ' TIPO, 0 ATUAL, COUNT(*) QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"
	cRet += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	cRet += _cEnter + " ON F4_CODIGO 		= D2_TES"
	cRet += _cEnter + " AND SF4.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F4_ESTOQUE 		= 'S'"
	cRet += _cEnter + " WHERE D2_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD2.D_E_L_E_T_	= '' "
	cRet += _cEnter + " AND D2_EMISSAO 		>  (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL	= D2_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D2_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D2_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	cRet += _cEnter + " AND D2_EMISSAO       <= '" + dtos(mv_par04) + "'"
	If !empty(mv_par05)
		cRet += _cEnter + " AND D2_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D2_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D2_FILIAL, D2_COD"
	cRet += _cEnter + " ) "
	
	cRet += _cEnter + " UNION"
	
EndIf

If mv_par06 <> 1		// para recalculdo do saldo atual ou ambos
	
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D2_FILIAL FILIAL, D2_COD CODIGO, 0 CUSTO, 0 QUANT, 'SD2X ' TIPO, SUM(-D2_QUANT) ATUAL, 0 QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"
	cRet += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	cRet += _cEnter + " ON F4_CODIGO 		= D2_TES"
	cRet += _cEnter + " AND SF4.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F4_ESTOQUE 		= 'S'"
	cRet += _cEnter + " WHERE D2_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD2.D_E_L_E_T_	='' "
	cRet += _cEnter + " AND D2_EMISSAO 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL	= D2_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D2_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D2_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	If !empty(mv_par05)
		cRet += _cEnter + " AND D2_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D2_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D2_FILIAL, D2_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
EndIf

If mv_par06 <> 2
	
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D1_FILIAL FILIAL, D1_COD CODIGO, SUM(D1_CUSTO) CUSTO, SUM(D1_QUANT) QUANT, 'SD1 ' TIPO, 0 ATUAL, COUNT(*) QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	cRet += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	cRet += _cEnter + " ON F4_CODIGO 		= D1_TES"
	cRet += _cEnter + " AND SF4.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F4_ESTOQUE 		= 'S'"
	cRet += _cEnter + " WHERE D1_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD1.D_E_L_E_T_	= '' "
	cRet += _cEnter + " AND D1_DTDIGIT 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL 	= D1_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D1_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D1_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	cRet += _cEnter + " AND D1_DTDIGIT       <= '" + dtos(mv_par04) + "'"
	If !empty(mv_par05)
		cRet += _cEnter + " AND D1_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D1_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D1_FILIAL, D1_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
	
EndIf

If mv_par06 <> 1
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D1_FILIAL FILIAL, D1_COD CODIGO, 0 CUSTO, 0 QUANT, 'SD1X ' TIPO, SUM(D1_QUANT) ATUAL, 0 QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	cRet += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	cRet += _cEnter + " ON F4_CODIGO 		= D1_TES"
	cRet += _cEnter + " AND SF4.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F4_ESTOQUE 		= 'S'"
	cRet += _cEnter + " WHERE D1_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD1.D_E_L_E_T_	= '' "
	cRet += _cEnter + " AND D1_DTDIGIT 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL 	= D1_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D1_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL		= D1_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	If !empty(mv_par05)
		cRet += _cEnter + " AND D1_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D1_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D1_FILIAL, D1_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
EndIf

If mv_par06 <> 2
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D3_FILIAL FILIAL, D3_COD CODIGO, SUM(CASE WHEN D3_TM < '5' THEN D3_CUSTO1 ELSE -D3_CUSTO1 END) CUSTO, SUM(CASE WHEN D3_TM < '5' THEN D3_QUANT ELSE -D3_QUANT END) QUANT, 'SD3 ' TIPO, 0 ATUAL, COUNT(*) QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD3') + " SD3 (NOLOCK)"
	cRet += _cEnter + " LEFT JOIN " + RetSqlName('SF5') + " SF5 (NOLOCK)"
	cRet += _cEnter + " ON F5_CODIGO 		= D3_TM"
	cRet += _cEnter + " AND SF5.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F5_TIPO 			<> 'P'"
	cRet += _cEnter + " WHERE D3_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD3.D_E_L_E_T_	= ''"
	cRet += _cEnter + " AND D3_ESTORNO 		= ''"
	cRet += _cEnter + " AND D3_EMISSAO 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL 	= D3_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D3_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D3_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	cRet += _cEnter + " AND D3_EMISSAO       <= '" + dtos(mv_par04) + "'"
	If !empty(mv_par05)
		cRet += _cEnter + " AND D3_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D3_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D3_FILIAL, D3_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
EndIf

If mv_par06 <> 1
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D3_FILIAL FILIAL, D3_COD CODIGO, 0 CUSTO, 0 QUANT, 'SD3X ' TIPO, SUM(CASE WHEN D3_TM < '5' THEN D3_QUANT ELSE -D3_QUANT END) ATUAL, 0 QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD3') + " SD3 (NOLOCK)"
	cRet += _cEnter + " LEFT JOIN " + RetSqlName('SF5') + " SF5 (NOLOCK)"
	cRet += _cEnter + " ON F5_CODIGO 		= D3_TM"
	cRet += _cEnter + " AND SF5.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F5_TIPO 		<> 'P'"
	cRet += _cEnter + " WHERE D3_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD3.D_E_L_E_T_	= ''"
	cRet += _cEnter + " AND D3_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " AND D3_ESTORNO 		= ''"
	cRet += _cEnter + " AND D3_EMISSAO 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL 	= D3_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D3_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D3_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	If !empty(mv_par05)
		cRet += _cEnter + " AND D3_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " GROUP BY D3_FILIAL, D3_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
	
EndIf

cRet += _cEnter + " ("
cRet += _cEnter + " SELECT B9_FILIAL FILIAL, B9_COD CODIGO, B9_VINI1 CUSTO, B9_QINI QUANT, 'SB9 ' TIPO, 0 ATUAL, 0 QTMOV"
cRet += _cEnter + " FROM " + RetSqlName('SB9') + " SB9 (NOLOCK)"
cRet += _cEnter + " WHERE B9_LOCAL 		= '01'"
cRet += _cEnter + " AND SB9.D_E_L_E_T_	= ''"
//If mv_par06 <> 2
//	cRet += _cEnter + " AND B9_DATA 		= '" + dtos(FirstDay(mv_par04)-1) + "'"
//Else
cRet += _cEnter + " AND B9_DATA 		= (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
cRet += _cEnter + 					" WHERE B9.B9_FILIAL 	= SB9.B9_FILIAL"
cRet += _cEnter + 					" AND B9.B9_COD 		= SB9.B9_COD"
cRet += _cEnter + 					" AND B9.B9_LOCAL 		= SB9.B9_LOCAL"
cRet += _cEnter + 					" ORDER BY B9.B9_DATA DESC) "
//EndIf

If !empty(mv_par05)
	cRet += _cEnter + " AND B9_COD 		= '" + mv_par05 + "'"
EndIf
cRet += _cEnter + " AND B9_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
cRet += _cEnter + " ) "
cRet += _cEnter + " ) X

cRet += _cEnter + " GROUP BY FILIAL, CODIGO"
cRet += _cEnter + " ORDER BY FILIAL, CODIGO"

Return cRet

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Função responsável por gerar a query com os movimentos para gravar os dados na SB2 ///////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION SB2QRY()

Private cRet	:= ""

cRet := "SELECT FILIAL, CODIGO, SUM(QUANT) QUANT, SUM(CUSTO) CUSTO, SUM(ATUAL) ATUAL, SUM(QTMOV) QTMOV"
cRet += _cEnter + " FROM ("

If mv_par06 <> 2		// para fechamento de estoque ou ambos
	cRet += _cEnter + " ( "
	cRet += _cEnter + " SELECT D2_FILIAL FILIAL, D2_COD CODIGO, SUM(-D2_CUSTO1) CUSTO, SUM(-D2_QUANT) QUANT, 'SD2 ' TIPO, 0 ATUAL, COUNT(*) QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"
	cRet += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	cRet += _cEnter + " ON F4_CODIGO 		= D2_TES"
	cRet += _cEnter + " AND SF4.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F4_ESTOQUE 		= 'S'"
	cRet += _cEnter + " WHERE D2_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD2.D_E_L_E_T_	= '' "
	cRet += _cEnter + " AND D2_EMISSAO 		>  (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL 	= D2_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D2_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D2_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	cRet += _cEnter + " AND D2_EMISSAO       <= '" + dtos(ddatabase) + "'"
	If !empty(mv_par05)
		cRet += _cEnter + " AND D2_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D2_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D2_FILIAL, D2_COD"
	cRet += _cEnter + " ) "
	
	cRet += _cEnter + " UNION"
	
EndIf

If mv_par06 <> 1		// para recalculdo do saldo atual ou ambos
	
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D2_FILIAL FILIAL, D2_COD CODIGO, 0 CUSTO, 0 QUANT, 'SD2X ' TIPO, SUM(-D2_QUANT) ATUAL, 0 QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"
	cRet += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	cRet += _cEnter + " ON F4_CODIGO 		= D2_TES"
	cRet += _cEnter + " AND SF4.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F4_ESTOQUE 		= 'S'"
	cRet += _cEnter + " WHERE D2_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD2.D_E_L_E_T_	='' "
	cRet += _cEnter + " AND D2_EMISSAO 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL	= D2_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D2_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D2_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	If !empty(mv_par05)
		cRet += _cEnter + " AND D2_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D2_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D2_FILIAL, D2_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
EndIf

If mv_par06 <> 2
	
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D1_FILIAL FILIAL, D1_COD CODIGO, SUM(D1_CUSTO) CUSTO, SUM(D1_QUANT) QUANT, 'SD1 ' TIPO, 0 ATUAL, COUNT(*) QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	cRet += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	cRet += _cEnter + " ON F4_CODIGO 		= D1_TES"
	cRet += _cEnter + " AND SF4.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F4_ESTOQUE 		= 'S'"
	cRet += _cEnter + " WHERE D1_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD1.D_E_L_E_T_	= '' "
	cRet += _cEnter + " AND D1_DTDIGIT 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL 	= D1_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D1_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D1_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	cRet += _cEnter + " AND D1_DTDIGIT       <= '" + dtos(ddatabase) + "'"
	If !empty(mv_par05)
		cRet += _cEnter + " AND D1_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D1_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D1_FILIAL, D1_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
	
EndIf

If mv_par06 <> 1
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D1_FILIAL FILIAL, D1_COD CODIGO, 0 CUSTO, 0 QUANT, 'SD1X ' TIPO, SUM(D1_QUANT) ATUAL, 0 QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	cRet += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	cRet += _cEnter + " ON F4_CODIGO 		= D1_TES"
	cRet += _cEnter + " AND SF4.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F4_ESTOQUE 		= 'S'"
	cRet += _cEnter + " WHERE D1_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD1.D_E_L_E_T_	= '' "
	cRet += _cEnter + " AND D1_DTDIGIT 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL 	= D1_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D1_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL		= D1_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	If !empty(mv_par05)
		cRet += _cEnter + " AND D1_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D1_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D1_FILIAL, D1_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
EndIf

If mv_par06 <> 2
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D3_FILIAL FILIAL, D3_COD CODIGO, SUM(CASE WHEN D3_TM < '5' THEN D3_CUSTO1 ELSE -D3_CUSTO1 END) CUSTO, SUM(CASE WHEN D3_TM < '5' THEN D3_QUANT ELSE -D3_QUANT END) QUANT, 'SD3 ' TIPO, 0 ATUAL, COUNT(*) QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD3') + " SD3 (NOLOCK)"
	cRet += _cEnter + " LEFT JOIN " + RetSqlName('SF5') + " SF5 (NOLOCK)"
	cRet += _cEnter + " ON F5_CODIGO 		= D3_TM"
	cRet += _cEnter + " AND SF5.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F5_TIPO 			<> 'P'"
	cRet += _cEnter + " WHERE D3_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD3.D_E_L_E_T_	= ''"
	cRet += _cEnter + " AND D3_ESTORNO 		= ''"
	cRet += _cEnter + " AND D3_EMISSAO 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL 	= D3_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D3_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D3_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	cRet += _cEnter + " AND D3_EMISSAO       <= '" + dtos(ddatabase) + "'"
	If !empty(mv_par05)
		cRet += _cEnter + " AND D3_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " AND D3_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " GROUP BY D3_FILIAL, D3_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
EndIf

If mv_par06 <> 1
	cRet += _cEnter + " ("
	cRet += _cEnter + " SELECT D3_FILIAL FILIAL, D3_COD CODIGO, 0 CUSTO, 0 QUANT, 'SD3X ' TIPO, SUM(CASE WHEN D3_TM < '5' THEN D3_QUANT ELSE -D3_QUANT END) ATUAL, 0 QTMOV"
	cRet += _cEnter + " FROM " + RetSqlName('SD3') + " SD3 (NOLOCK)"
	cRet += _cEnter + " LEFT JOIN " + RetSqlName('SF5') + " SF5 (NOLOCK)"
	cRet += _cEnter + " ON F5_CODIGO 		= D3_TM"
	cRet += _cEnter + " AND SF5.D_E_L_E_T_ 	= ''"
	cRet += _cEnter + " AND F5_TIPO 			<> 'P'"
	cRet += _cEnter + " WHERE D3_LOCAL 		= '01'"
	cRet += _cEnter + " AND SD3.D_E_L_E_T_	= ''"
	cRet += _cEnter + " AND D3_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
	cRet += _cEnter + " AND D3_ESTORNO 		= ''"
	cRet += _cEnter + " AND D3_EMISSAO 		> (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
	cRet += _cEnter + " 							WHERE B9.B9_FILIAL 	= D3_FILIAL"
	cRet += _cEnter + " 							AND B9.B9_COD 		= D3_COD"
	cRet += _cEnter + " 							AND B9.B9_LOCAL 	= D3_LOCAL"
	cRet += _cEnter + " 							ORDER BY B9.B9_DATA DESC) "
	If !empty(mv_par05)
		cRet += _cEnter + " AND D3_COD 		= '" + mv_par05 + "'"
	EndIf
	cRet += _cEnter + " GROUP BY D3_FILIAL, D3_COD"
	cRet += _cEnter + " )"
	
	cRet += _cEnter + " UNION"
	
EndIf

cRet += _cEnter + " ("
cRet += _cEnter + " SELECT B9_FILIAL FILIAL, B9_COD CODIGO, B9_VINI1 CUSTO, B9_QINI QUANT, 'SB9 ' TIPO, 0 ATUAL, 0 QTMOV"
cRet += _cEnter + " FROM " + RetSqlName('SB9') + " SB9 (NOLOCK)"
cRet += _cEnter + " WHERE B9_LOCAL 		= '01'"
cRet += _cEnter + " AND SB9.D_E_L_E_T_	= ''"
//If mv_par06 <> 2
//	cRet += _cEnter + " AND B9_DATA 		= '" + dtos(FirstDay(ddatabase)-1) + "'"
//Else
cRet += _cEnter + " AND B9_DATA 		= (SELECT TOP 1 B9.B9_DATA FROM " + RetSqlName('SB9') + " B9 (NOLOCK)"
cRet += _cEnter + 					" WHERE B9.B9_FILIAL 	= SB9.B9_FILIAL"
cRet += _cEnter + 					" AND B9.B9_COD 		= SB9.B9_COD"
cRet += _cEnter + 					" AND B9.B9_LOCAL 		= SB9.B9_LOCAL"
cRet += _cEnter + 					" ORDER BY B9.B9_DATA DESC) "
//EndIf

If !empty(mv_par05)
	cRet += _cEnter + " AND B9_COD 		= '" + mv_par05 + "'"
EndIf
cRet += _cEnter + " AND B9_FILIAL 		BETWEEN '" + _cFilialDe + "' AND '" + _cFilialAte + "'"
cRet += _cEnter + " ) "
cRet += _cEnter + " ) X

cRet += _cEnter + " GROUP BY FILIAL, CODIGO"
cRet += _cEnter + " ORDER BY FILIAL, CODIGO"

Return cRet

Static Function EnvMailDiv()

Local _cEnter := chr(13) + chr(10)
			
cServer   := GETMV("MV_RELSERV")
cAccount  := AllTrim(GETMV("MV_RELACNT"))
cPassword := AllTrim(GETMV("MV_RELAPSW"))
cEnvia    := 'protheus@laselva.com.br'
//cRecebe   := "marcos.rocha@laselva.com.br; helio.assis@laselva.com.br; richard.cabral@laselva.com.br"				// GetMv('LS_SPEMTXT') 
cRecebe   := "marcos.rocha@laselva.com.br; richard.cabral@laselva.com.br"				// GetMv('LS_SPEMTXT') 

_cCorpo   := 'Divergencias encontradas na rotina de saldo atual em ' + DtoC(dDataBase) + _cEnter + _cEnter
_cCorpo   += 'Email enviado automaticamente pelo sistema' + _cEnter
_cCorpo   += 'Favor não responder'  + _cEnter + _cEnter

_cCorpo   += 'Gerado por: ' + _aUsuMail[1,2] + _cEnter + _cEnter

_cCorpo   += 'Filial Produto         Descrição                               Sld.Anter. Sld.Atual' + _cEnter + _cEnter

aCorpo := {}
For nX := 1 to Len(aDiverg)

	cLine	:= aDiverg[nX,1]+'     '+Padr(aDiverg[nX,2],15)+' '+Padr(Posicione("SB1",1,xFilial("SB1")+aDiverg[nX,2],"B1_DESC"),40)+' '+Str(aDiverg[nX,3],8,2)+'   '+Str(aDiverg[nX,4],8,2)  + _cEnter
	cVarCorpo := "_cCorpo"+aDiverg[nX,1]
	If Type(cVarCorpo) = 'U'
		&(cVarCorpo) := _cCorpo
		aAdd(aCorpo,aDiverg[nX,1])
	EndIf
	&(cVarCorpo) += cLine

Next

For nX := 1 to Len(aCorpo)

	cAssunto  := "Divergencias - Saldo Atual " + dtoc(dDataBase) + " - Filial: " + aCorpo[nX]

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	
	If lConectou

		SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY &("_cCorpo"+Alltrim(aCorpo[nX])) RESULT lEnviado
	
		If !lEnviado
			cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
			GET MAIL ERROR cHtml
			Conout( "ERRO SMTP EM: " + cAssunto )
		Else
			DISCONNECT SMTP SERVER
		Endif
	
	Else
	
		Conout( "ERRO SMTP EM: " + cAssunto )
		cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
		GET MAIL ERROR cHtml
		MsgAlert(cHtml)
	
	Endif

Next nX
	
Return
