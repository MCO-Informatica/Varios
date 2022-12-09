#include "sigawin.ch"
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA103BUT  ºAutor  ³ A.C.Silva          º Data ³ 23/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada - Adiciona Botao - Doc.Entrada             º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA103BUT()
////////////////////////
Local _aMyBtn	:= {}

If 	ExistBlock('PE_ImpXmlNFe')
	_aMyBtn	:=	ExecBlock('PE_ImpXmlNFe',.F.,.F.,{'MA103BUT'})
EndIf

If !inclui .and. SF1->F1_FORMUL == 'S'
	
	_cQuery := "SELECT ISNULL(SPED.CSTAT_SEFR,'') SPED_STATUS"
	_cQuery += _cEnter + "FROM " + RetSqlName('SF1') + " SF1 (NOLOCK)"
	
	_cQuery += _cEnter + "LEFT JOIN SPED054 SPED"
	_cQuery += _cEnter + "ON ID_ENT = (SELECT dbo.FN_GETIDSPED(F1_FILIAL))"
	_cQuery += _cEnter + "AND NFE_ID = F1_SERIE + F1_DOC"
	_cQuery += _cEnter + "AND SPED.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + "WHERE SF1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND F1_SERIE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + "AND F1_DOC = '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + "AND F1_FILIAL = '" + SF1->F1_FILIAL + "'"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SF1', .F., .T.)
	If eof() .or. alltrim(_SF1->SPED_STATUS) <> '100'  // VERIFICA SE A NOTA AINDA NÃO FOI ENVIADA PARA A SEFAZ, SOMENTE FORMULARIO PROPRIO E VISUALIZAÇÃO.	
		AAdd( _aMyBtn, { "EDIT",	{ || U_LS_MSGNF('A') } , "Mensagem NFE", "Mensagem NFE" } )
	Else
		AAdd( _aMyBtn, { "EDIT",	{ || U_LS_MSGNF('V') } , "Mensagem NFE", "Mensagem NFE" } )
	EndIf	

	If SF1->F1_EST == 'EX'	// SOMENTE NA VISUALIZAÇÃO E PARA NOTAS DE IMPORTAÇÃO
		If eof() .or. alltrim(_SF1->SPED_STATUS) <> '100'  // VERIFICA SE A NOTA AINDA NÃO FOI ENVIADA PARA A SEFAZ, SOMENTE FORMULARIO PROPRIO E VISUALIZAÇÃO.	
			AAdd(_aMyBtn, { "NOTE", { || U_LS_103CD5('A') } , "Comp. Imp", "Complemento de Importação" } )
			//AAdd(_aMyBtn, { "NOTE", { || MATA926(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_ESPECIE,SF1->F1_FORNECE,SF1->F1_LOJA,'E',SF1->F1_TIPO) } , "Comp. Imp", "Complemento de Importação" } )
		Else
			AAdd(_aMyBtn, { "NOTE", { || U_LS_103CD5('V') } , "Comp. Imp", "Complemento de Importação" } )
		EndIf
	EndIf


	DbCloseArea()
	
EndIf
If !inclui .and. !altera
	AAdd(_aMyBtn, { "NOTE", { || U_LS_DESDO() }, "Desdobramento de Títulos"  , "Desd. Tít."} )
EndIf

Return(_aMyBtn)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// tela para digitação da mensagem de dados adicionais da nota fiscal de entrada de formulário próprio
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_MSGNF(_xEdita)
///////////////////////////////
Local _lOk   := .f.
Local _cMemo := SF1->F1_DADOSAD
_oDlg:=MsDialog():New(0,0,215,420,'Documento de entrada - Observações',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

@ 005,005 Say 'Dados adicionais: '		Size 100,010 Pixel of _oDlg
@ 015,005 GET oMemo VAR _cMemo MEMO 	Size 200,070 Pixel of _oDlg when _xEdita == 'A'

@ 090,010 BmpButton Type 01 Action(_lOk := .t.,_oDlg:End())
@ 090,060 BmpButton Type 02 Action(_lOk := .f.,_oDlg:End())
_oDlg:Activate(,,,.T.)

If _lOK
	RecLock('SF1',.f.)
	SF1->F1_DADOSAD := upper(alltrim(_cMemo))
	If SF1->(FieldPos("F1_MENPAD"))>0
		SF1->F1_MENPAD := iif(empty(_cMemo),'','SF1')
	Else
		SF1->F1_CPROVA := iif(empty(_cMemo),'','SF1')
	EndIf
	MsUnLock()
EndIf

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// insere mais uma opção no arotinas
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA103OPC()
/////////////////////////

_aRet := {}
aAdd(_aRet,{ "Consulta Financeiro"	,"U_LS_NFFIN", 0 , 4})
aAdd(_aRet,{ "Desdobr Título"		,"U_LS_Desdo", 0 , 4})

Return(_aRet)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CONSULTA FINANCEIRO
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_NFFIN()
///////////////////////////////

Local _aAlias, _cQuery, _aNotas, _nNota, _lTela, _cCombo, _oCombo
_aAlias := GetArea()

If empty(SF1->F1_STATUS)
	MsgBox('Pré-nota ainda não classificada.','ATENÇÃO!!!','ALERT')
	Return()
EndIf                                      

If empty(SF1->F1_DUPL)
	MsgBox('Nota fiscal não possui títulos.','ATENÇÃO!!!','ALERT')
	Return()
EndIf                                      

If SF1->F1_TIPO == 'N'
	_cQuery := "SELECT DISTINCT E2_PREFIXO, E2_NUM, E2_PARCELA, CONVERT(CHAR, CONVERT(DATETIME,E2_VENCREA),103) VENCTO, "
	_cQuery += " CONVERT(CHAR, CONVERT(DATETIME,E2_BAIXA),103) BAIXA, E2_SALDO, E2_VALOR"
	_cQuery += " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK) "
	_cQuery += " WHERE E2_MSFIL = '" + SF1->F1_FILIAL + "'"
	_cQuery += " AND E2_NUM = '" + SF1->F1_DOC + "'"
	_cQuery += " AND E2_PREFIXO = '" + SF1->F1_PREFIXO + "'"
	_cQuery += " AND E2_FORNECE = '" + SF1->F1_FORNECE + "'"
	_cQuery += " AND E2_LOJA = '" + SF1->F1_LOJA + "'"
	_cQuery += " AND SE2.D_E_L_E_T_ = ''"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'_SE2',.F.,.T.)
	_aNotas := {}
	Do While !eof()
		_cLinha := _SE2->E2_PREFIXO + ' - ' + _SE2->E2_NUM + ' / ' + _SE2->E2_PARCELA + '  Valor: ' + alltrim(tran(_SE2->E2_VALOR,'@E 999,999.99'))
		_cLinha += ' Vencto: ' + _SE2->VENCTO + ' Saldo: ' + alltrim(tran(_SE2->E2_SALDO,'@e 999,999.99')) + '  Baixa: ' + _SE2->BAIXA
		aAdd(_aNotas, _cLinha)
		DbSkip()
	EndDo
Else
	_cQuery := "SELECT DISTINCT E1_PREFIXO, E1_NUM, E1_PARCELA, CONVERT(CHAR, CONVERT(DATETIME,E1_VENCREA),103) VENCTO, "
	_cQuery += " CONVERT(CHAR, CONVERT(DATETIME,E1_BAIXA),103) BAIXA, E1_SALDO, E1_VALOR"
	_cQuery += " FROM " + RetSqlName('SE1') + " SE1 (NOLOCK) "
	_cQuery += " WHERE E1_MSFIL = '" + SF1->F1_FILIAL + "'"
	_cQuery += " AND E1_NUM = '" + SF1->F1_DOC + "'"
	_cQuery += " AND E1_PREFIXO = '" + SF1->F1_PREFIXO + "'"
	_cQuery += " AND E1_CLIENTE = '" + SF1->F1_FORNECE + "'"
	_cQuery += " AND E1_LOJA = '" + SF1->F1_LOJA + "'"
	_cQuery += " AND SE1.D_E_L_E_T_ = ''"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'_SE1',.F.,.T.)
	_aNotas := {}
	Do While !eof()
		_cLinha := _SE1->E1_PREFIXO + ' - ' + _SE1->E1_NUM + ' / ' + _SE1->E1_PARCELA + '  Valor: ' + alltrim(tran(_SE1->E1_VALOR,'@E 999,999.99'))
		_cLinha += ' Vencto: ' + _SE1->VENCTO + ' Saldo: ' + alltrim(tran(_SE1->E1_SALDO,'@e 999,999.99')) + '  Baixa: ' + _SE1->BAIXA
		aAdd(_aNotas, _cLinha)
		DbSkip()
	EndDo
EndIf
_cTexto := 'Este pedido foi faturado em mais de uma nota fiscal' + chr(13) + chr(10)
_cTexto += 'Selecione o título que deseja consultar'
	
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
////////////////////////////////
If SF1->F1_TIPO == 'N'
	DbSelectArea('SE2')
	DbSetOrder(1)
	If !DbSeek(xFilial('SE2') + _cTit + 'NF ' + SF1->F1_FORNECE + SF1->F1_LOJA,.f.)
		MsgBox('Título não localizado','ATENÇÃO!!!','ALERT')
	Else
		Fc050Con()
	EndIf              
Else
	DbSelectArea('SE1')
	DbSetOrder(1)
	If !DbSeek(xFilial('SE1') + _cTit + 'NCC',.f.)
		MsgBox('Título não localizado','ATENÇÃO!!!','ALERT')
	Else
		Fc040Con()
	EndIf
EndIf

Return()
