#include "Protheus.Ch"
#INCLUDE "rwmake.ch"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	ma410mnu
// Autor 		Alexandre Dalpiaz
// Data 		22/06/10
// Descricao  	modifica menu dos pedidos de venda, inclui mais opções
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 28/09/2012 - ALEXANDRE - correção da rotina de visualização das NFs
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA410MNU()
////////////////////////

aRotina[9] := { "Prep.Doc.Saída"		,"U_LS_PvNfs"	,0,2,0 ,NIL}
aAdd(aRotina, { "Consulta NF"			,"U_LS_090"		, 0, 4, 20, nil})
aAdd(aRotina, { "Consulta Financeiro"	,"U_LS_040"		, 0, 4, 20, nil})
aAdd(aRotina, { "Estorna Liberação"		,"U_LS_BLQPV"	, 0, 4, 20, nil})

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_PvNfs()
////////////////////////

If PA6->(DbSeek(xFilial('PA6') + SC5->C5_NUM + SC5->C5_FILIAL,.f.)) .and. PA6->PA6_STATUS <> '02'
	Aviso('Documento de saída',"O pedido desta NF possui romaneio. Favor concluir o fluxo operacional pela rotina de distribuição. Romaneio nro.: " + alltrim(PA7->PA7_NUMROM) ,{'OK'},3)
Else
	
	If !U_LS_M460PROC()  // VERIFICA SE QUANTIDADES ESTÃO OK.
		Return()
	EndIf
	
	Ma410PvNfs()
	
EndIf

Return()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_090()  // CONSULTA NOTA FISCAL DE SAIDA A PARTIR DO PEDIDO DE VENDAS
/////////////////////////////////////////////////////////////////////////////////////
Local _aAlias, _cQuery, _aNotas, _nNota, _lTela, _cCombo, _oCombo
_aAlias := GetArea()

_cQuery := "SELECT DISTINCT C9_FILIAL, C9_NFISCAL, C9_SERIENF"
_cQuery += " FROM " + RetSqlName('SC9') + " SC9 (NOLOCK) "
_cQuery += " WHERE C9_FILIAL = '" + SC5->C5_FILIAL + "'"
_cQuery += " AND C9_PEDIDO = '" + SC5->C5_NUM + "'"
_cQuery += " AND C9_NFISCAL <> ''"
_cQuery += " AND SC9.D_E_L_E_T_ = ''"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'_SC9',.F.,.T.)
_cTexto := 'Este pedido foi faturado em mais de uma nota fiscal' + chr(13) + chr(10)
_cTexto += 'Selecione a nota que deseja consultar'

_aNotas := {}
Do While !eof()
	aAdd(_aNotas,_SC9->C9_NFISCAL + ' / ' + _SC9->C9_SERIENF)
	DbSkip()
EndDo
DbCloseArea()

If len(_aNotas) > 1
	_lTela := .t.
	Do While _lTela
		_cCombo := _aNotas[1]
		_lTela := .f.
		DEFINE MSDIALOG oDlg FROM 000,000 TO 400,400 TITLE "Visualiza Nota Fiscal" PIXEL
		
		_oCombo:= TComboBox():New(010,090,{|u|if(PCount()>0,_cCombo:=u,_cCombo)},;
		_aNotas,65,20,oDlg,,{|| _nNota := aScan(_aNotas,_cCombo) },,,,.T.,,,,,,,,,"_cCombo")
		
		@ 140,055 	BUTTON "Visualiza NF"		SIZE 040,015 OF oDlg PIXEL ACTION(_lTela := .t.,oDlg:End())
		@ 140,160 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(_lTela := .f.,oDlg:End())
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If _lTela
			_nNota := aScan(_aNotas,_cCombo)
			a410VeNota(SC5->C5_FILIAL + left(_aNotas[_nNota],9) + right(_aNotas[_nNota],3))
		EndIf
	EndDo
ElseIf empty(_aNotas)
	MsgAlert('Não há notas fiscais para esse pedido','ATENÇÃO!!!')
Else
	a410VeNota(SC5->C5_FILIAL + left(_aNotas[1],9) + right(_aNotas[1],3))
EndIf

RestArea(_aAlias)

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function a410VeNota(_cNota)
//////////////////////////////////

SF2->(DbSetOrder(1))
If SF2->(DbSeek(_cNota,.F.))
	MC090Visual()
Else
	MsgAlert('Nota Fiscal não encontrada','ATENÇÃO!!!')
EndIf

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Estorna liberações do pedido de venda
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_BLQPV()
////////////////////////

Local _cQuery
Local _lRet    := .f.
Local _lTemNF  := .f.
Local _lTemLib := .f.
Local _aAlias  := GetArea()

DbSelectArea('SC9')
DbSetOrder(1)
DbSeek(xFilial('SC9') + SC5->C5_NUM,.F.)
Do While !Eof() .and. xFilial('SC9') + SC5->C5_NUM == SC9->C9_FILIAL + SC9->C9_PEDIDO
	If !empty(SC9->C9_NFISCAL)
		_lTemNF := .t.
	EndIf
	DbSkip()
EndDo

If _lTemNF
	
	MsgAlert('Pedido já faturado, a liberação não pode ser estornada!','ATENÇÃO!!!')
	_lRet := .f.
	
ElseIf MsgBox('Confirma estorno das liberações do pedido','ATENÇÃO!!!','YESNO')
	
	DbSeek(xFilial('SC9') + SC5->C5_NUM,.F.)
	Do While !Eof() .and. xFilial('SC9') + SC5->C5_NUM == SC9->C9_FILIAL + SC9->C9_PEDIDO
		
		If Empty(SC9->C9_NFISCAL)
			a460Estorna()
			_lRet := .t.
		Endif
		DbSkip()
	EndDo
	DbSelectArea('SC5')
	MsUnLock()
	MsgInfo('Liberação estornada!','ATENÇÃO!!!')
	
Else
	
	MsgAlert('Liberação não foi estornada!','ATENÇÃO!!!')
	
EndIf

RestArea(_aAlias)
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// CONSULTA FINANCEIRO REFERENTE AO PEDIDO DE VENDAS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_040()
//////////////////////

Local _aAlias, _cQuery, _aNotas, _nNota, _lTela, _cCombo, _oCombo
_aAlias := GetArea()

If SC5->C5_TIPO == 'N'
	_cQuery := "SELECT DISTINCT E1_PREFIXO, E1_NUM, E1_PARCELA, CONVERT(CHAR, CONVERT(DATETIME,E1_VENCREA),103) VENCTO, "
	_cQuery += " CONVERT(CHAR, CONVERT(DATETIME,E1_BAIXA),103) BAIXA, E1_SALDO, E1_VALOR"
	_cQuery += " FROM " + RetSqlName('SE1') + " SE1 (NOLOCK) "
	_cQuery += " WHERE E1_MSFIL = '" + SC5->C5_FILIAL + "'"
	_cQuery += " AND E1_PEDIDO = '" + SC5->C5_NUM + "'"
	_cQuery += " AND SE1.D_E_L_E_T_ = ''"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'_SE1',.F.,.T.)
	_cTexto := 'Este pedido foi faturado em mais de uma nota fiscal' + chr(13) + chr(10)
	_cTexto += 'Selecione o título que deseja consultar'
	
	_aNotas := {}
	Do While !eof()
		_cLinha := _SE1->E1_PREFIXO + ' - ' + _SE1->E1_NUM + ' / ' + _SE1->E1_PARCELA + '  Valor: ' + alltrim(tran(_SE1->E1_VALOR,'@E 999,999.99'))
		_cLinha += ' Vencto: ' + _SE1->VENCTO + ' Saldo: ' + alltrim(tran(_SE1->E1_SALDO,'@e 999,999.99')) + '  Baixa: ' + _SE1->BAIXA
		aAdd(_aNotas, _cLinha)
		DbSkip()
	EndDo
Else
	_cQuery := "SELECT DISTINCT E2_PREFIXO, E2_NUM, E2_PARCELA, CONVERT(CHAR, CONVERT(DATETIME,E2_VENCREA),103) VENCTO, "
	_cQuery += " CONVERT(CHAR, CONVERT(DATETIME,E2_BAIXA),103) BAIXA, E2_SALDO, E2_VALOR"
	_cQuery += " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK) "
	_cQuery += " WHERE E2_MSFIL = '" + SC5->C5_FILIAL + "'"
	_cQuery += " AND E2_NUM = '" + SC5->C5_NOTA + "'"
	_cQuery += " AND E2_PREFIXO = '" + left(alltrim(SC5->C5_SERIE) + SC5->C5_FILIAL,3) + "'"
	_cQuery += " AND E2_FORNECE = '" + SC5->C5_CLIENTE + "'"
	_cQuery += " AND E2_LOJA = '" + SC5->C5_LOJACLI + "'"
	_cQuery += " AND SE2.D_E_L_E_T_ = ''"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'_SE2',.F.,.T.)
	_cTexto := 'Este pedido foi faturado em mais de uma nota fiscal' + chr(13) + chr(10)
	_cTexto += 'Selecione o título que deseja consultar'
	
	_aNotas := {}
	Do While !eof()
		_cLinha := _SE2->E2_PREFIXO + ' - ' + _SE2->E2_NUM + ' / ' + _SE2->E2_PARCELA + '  Valor: ' + alltrim(tran(_SE2->E2_VALOR,'@E 999,999.99'))
		_cLinha += ' Vencto: ' + _SE2->VENCTO + ' Saldo: ' + alltrim(tran(_SE2->E2_SALDO,'@e 999,999.99')) + '  Baixa: ' + _SE2->BAIXA
		aAdd(_aNotas, _cLinha)
		DbSkip()
	EndDo
EndIf
DbCloseArea()

If len(_aNotas) > 1
	_lTela := .t.
	Do While _lTela
		_cCombo := _aNotas[1]
		_lTela := .f.
		DEFINE MSDIALOG oDlg FROM 000,000 TO 400,600 TITLE "Consulta Títulos" PIXEL
		
		_oCombo:= TComboBox():New(010,010,{|u|if(PCount()>0,_cCombo:=u,_cCombo)},;
		_aNotas,265,20,oDlg,,{|| _nNota := aScan(_aNotas,_cCombo) },,,,.T.,,,,,,,,,"_cCombo")
		
		@ 140,010 	BUTTON "Consulta Título"	SIZE 080,015 OF oDlg PIXEL ACTION(_lTela := .t.,oDlg:End())
		@ 140,100 	BUTTON "Fechar"  			SIZE 080,015 OF oDlg PIXEL ACTION(_lTela := .f.,oDlg:End())
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If _lTela
			_nNota := aScan(_aNotas,_cCombo)
			a410VeTit(replace(replace(left(_aNotas[_nNota],21),' - ',''),' / ',''))
		EndIf
	EndDo
ElseIf empty(_aNotas)
	MsgAlert('Não há títulos para este pedido','ATENÇÃO!!!')
Else
	a410VeTit(replace(replace(left(_aNotas[1],21),' - ',''),' / ',''))
EndIf

RestArea(_aAlias)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function a410VeTit(_cTit)
////////////////////////////////////////////////
If SC5->C5_TIPO == 'N'
	DbSelectArea('SE1')
	DbSetOrder(1)
	If !DbSeek(xFilial('SE1') + _cTit,.f.)
		MsgBox('Título não localizado','ATENÇÃO!!!','ALERT')
	Else
		Fc040Con()
	EndIf
Else
	DbSelectArea('SE2')
	DbSetOrder(1)
	If !DbSeek(xFilial('SE2') + _cTit + 'NDF' + SC5->C5_CLIENTE + SC5->C5_LOJACLI,.f.)
		MsgBox('Título não localizado','ATENÇÃO!!!','ALERT')
	Else
		Fc050Con()
	EndIf
EndIf
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_m460Proc()
////////////////////////
_cQuery := "SELECT SUM(C9_QTDLIB) QTDLIB, " 
_cQuery += " (SELECT SUM(C6_QTDVEN) C6_QTDVEN"
_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
_cQuery += _cEnter + " WHERE C6_NUM = '" + SC5->C5_NUM + "'"
_cQuery += _cEnter + " AND C6_FILIAL = '" + SC5->C5_FILIAL + "'"
_cQuery += _cEnter + " AND SC6.D_E_L_E_T_ = '') QTDPED"

_cQuery += _cEnter + " FROM " + RetSqlName('SC9') + " SC9 (NOLOCK)"

_cQuery += _cEnter + " WHERE C9_FILIAL = '" + SC5->C5_FILIAL + "'"
_cQuery += _cEnter + " AND C9_PEDIDO = '" + SC5->C5_NUM + "'"
_cQuery += _cEnter + " AND SC9.D_E_L_E_T_ = ''"

DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"LIB", .T., .T.)
_lOkNF := (QTDPED == QTDLIB)
DbCloseArea()

If !_lOkNF
	MsgBox('Divergências nas quantidades liberadas X pedido. Estorne a liberação do pedido e libere novamente.','ATENÇÃO!!!','ALERT')
EndIf
Return(_lOKNF)
