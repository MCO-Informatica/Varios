#Include "Protheus.ch"
#Include "rwmake.ch"

/*
+==================+======================+==============+
|Programa: MA120BUT|Autor: Antonio Carlos |Data: 06/10/08|
+==================+======================+==============+
|Descricao: Ponto de Entrada utilizado para adicionar    |
|botoes na enchoice da rotina de Pedido de Compra.       |
+========================================================+
|Uso: Laselva                                            |
+========================================================+
*/

User Function MA120BUT()

Local aBotao := {}
Local _nRecno := SC7->(recno())

//aadd(aBotao,{"budget",{|| a120Posic('SC7',_nRecno,2)},"Consulta Aprovacao","Consulta Aprovacao"}) //"Consulta Aprovacao"
AAdd(aBotao,{"AUTOM" ,{||U_COMP001(aCols[n,2])},"Consulta"})

Return(aBotao)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// visualiza documento
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_NFXPC()
///////////////////////////////
Local _cFilial, _cDoc, _cSerie, _cTes, _cQuery, _aNotas
Local _cFilant := cFilAnt
Local _aArea := GetArea()

_cQuery := "SELECT D1_FILIAL, D1_DOC, D1_SERIE, MAX(D1_TES) D1_TES"
_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
_cQuery += _cEnter + " WHERE D1_PEDIDO = '" + SC7->C7_NUM + "'"
_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND D1_FILIAL = '" + SC7->C7_FILENT + "'"
_cQuery += _cEnter + " AND D1_FORNECE = '" + SC7->C7_FORNECE + "'"
_cQuery += _cEnter + " AND D1_LOJA = '" + SC7->C7_LOJA + "'"
_cQuery += _cEnter + " GROUP BY D1_FILIAL, D1_DOC, D1_SERIE"

DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'_SD1',.f.,.f.)

If eof()
	MsgAlert('Pedido de compras ainda não faturado.','ATENÇÃO!!!')
	DbCloseArea()
	RestArea(_aArea)
	Return()
EndIf

_aNotas := {}
Do While !eof()
	aAdd(_aNotas,{_SD1->D1_FILIAL, _SD1->D1_DOC, _SD1->D1_SERIE,_SD1->D1_TES})
	DbSkip()
EndDo

If len(_aNotas) > 1
	_cFilial := _aNotas[1,1]
	_cDoc    := _aNotas[1,2]
	_cSerie  := _aNotas[1,3]
	_cTes    := _aNotas[1,4]
Else
	_cFilial := _aNotas[1,1]
	_cDoc    := _aNotas[1,2]
	_cSerie  := _aNotas[1,3]
	_cTes    := _aNotas[1,4]
EndIf

DbCloseArea()

cFilAnt   := _cFilial
DbSelectArea('SF1')
DbSetOrder(1)
If !DbSeek(cFilAnt + _cDoc + _cSerie + SC7->C7_FORNECE + SC7->C7_LOJA, .F.)
	MsgAlert('Nota Fiscal não localizada. Contate o administrador do sistema','ATENÇÃO!!!')
Else
	
	If empty(_cTes)	// pre-nota
		A140NFiscal('SF1',,2)
	Else 			// nota classificada
		A103NFiscal('SF1',,2)
	EndIf
	
EndIf

cFilAnt := _cFilAnt
RestArea(_aArea)

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function mt120brw
//////////////////////

aAdd(aRotina,{'Alteração Laselva'		,'U_LS_120()'    , 0, 2})
aAdd(aRotina,{'Copia PC Filial'  		,'U_LS_120COP()' , 0, 3})
aAdd(aRotina,{'Consulta NFE'     		,'U_LS_NFXPC()'  , 0, 2})
aAdd(aRotina,{'Consulta Financeiro'   	,'U_LS_TITXPC()' , 0, 2})

Return()
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_120()
//////////////////////

PRIVATE oForCod
PRIVATE oForLoja
PRIVATE oForNome
PRIVATE _oNomeFor
PRIVATE oFilEnt
PRIVATE oNomeEnt
PRIVATE _oNomeEnt
PRIVATE oDEntrega
PRIVATE oSay1
PRIVATE oSay2
PRIVATE oSay3
PRIVATE oSay4

SY1->(DbSetOrder(3))
If !(SY1->(DbSeek(xFilial('SY1') + __cUserId,.f.)))
	MsgBox('Você não tem permissão para alterar Pedidos de Compras','ATENÇÃO!!!','ALERT')
	Return()
EndIf

_cQuery 	:= "SELECT SUM(C7_QUJE) C7_QUJE "
_cQuery 	+= " FROM " + RetSqlName('SC7')+ " (nolock) "
_cQuery 	+= " WHERE D_E_L_E_T_ 	<> '*'"
_cQuery 	+= " AND C7_FILIAL 		= '" + SC7->C7_FILIAL + "'"
_cQuery 	+= " AND C7_NUM 		= '" + SC7->C7_NUM + "'"

DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)
_nQuant 	:= TRB->C7_QUJE
DbCloseArea()

_cEncer 	:= Posicione('SC7',1,xFilial('SC7')+SC7->C7_NUM,'C7_ENCER')

If _nQuant > 0 .and. _cEncer == "E"
	MsgAlert("Pedido não pode ser alterado, pois o mesmo já está TOTAL ou PARCIALMENTE atendido")
	Return
EndIf

_cFornece 	:= SC7->C7_FORNECE
_cLoja    	:= SC7->C7_LOJA
_cFilEnt  	:= SC7->C7_FILENT
_cNomeFor 	:= Posicione('SA2',1,xFilial('SA2') + _cFornece + _cLoja,'A2_NOME')
_dEntrega 	:= SC7->C7_DATPRF
_cNomeEnt 	:= Posicione('SM0',1,'01' + _cFilEnt,'M0_FILIAL')

_nOk 		:= 0
/*
@ 000, 000 TO 200, 400 DIALOG oDlg1 TITLE "Alteração Laselva - Pedido " + SC7->C7_NUM 

@ 005, 005 SAY "Fornecedor"
@ 005, 110 SAY "Loja"
@ 035, 005 SAY "Filial para entrega"
@ 050, 005 SAY "Data de Entrega"

@ 005, 060 GET _cFornece  F3 "SA2" 	SIZE 40, 10 Valid !empty(_cFornece) .and. ValiFor() 
@ 005, 130 GET _cLoja     			SIZE 20, 10 Valid !empty(_cLoja) 	.and. ValiFor()
@ 020, 060 GET _cNomeFor Object _oNomeFor when .f.
@ 035, 060 GET _cFilEnt   			SIZE 20, 10 F3 'SM0' Valid !empty(_cFilEnt) .and. ExistCpo('SM0','01'+_cFilEnt) .and. ValiEnt() size 150,10
@ 035, 090 GET _cNomeEnt Object _oNomeEnt when .f. size 120,10
@ 050, 060 GET _dEntrega			Valid !empty(_dEntrega) size 60,10

@ 080, 025 BMPBUTTON TYPE 1 ACTION (_nOk := 1, Close(oDlg1))
@ 080, 055 BMPBUTTON TYPE 2 ACTION (_nOk := 2, Close(oDlg1))

ACTIVATE DIALOG oDlg1 CENTERED
*/

DEFINE MSDIALOG oDlg1 TITLE "Alteração Laselva - Pedido " + SC7->C7_NUM  FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL
@ 005, 005 SAY        oSay1          PROMPT "Fornecedor"           	             		SIZE 035, 007 OF oDlg1 PIXEL
@ 005, 110 SAY        oSay2          PROMPT "Loja"                     	         		SIZE 035, 007 OF oDlg1 PIXEL
@ 035, 005 SAY        oSay3          PROMPT "Filial para Entrega" 	                 	SIZE 035, 007 OF oDlg1 PIXEL
@ 050, 005 SAY        oSay4          PROMPT "Data de Entrega"                       	SIZE 035, 007 OF oDlg1 PIXEL
@ 005, 060 MSGET      oForCod        VAR _cFornece                     F3 "SA2"      	SIZE 040, 010 OF oDlg1 PIXEL Valid !empty(_cFornece) .and. ValiFor() ON CHANGE atuLoja() 
@ 005, 130 MSGET      oForLoja       VAR _cLoja                                			SIZE 020, 010 OF oDlg1 PIXEL Valid !empty(_cLoja) 	 .and. ValiFor() 
@ 020, 060 MSGET      _oNomeFor      VAR _cNomeFor                     WHEN .F.     	SIZE 120, 010 OF oDlg1 PIXEL 
@ 035, 060 MSGET      oFilEnt        VAR _cFilEnt                      F3 "SM0"			SIZE 020, 010 OF oDlg1 PIXEL
@ 035, 090 MSGET      _oNomeEnt      VAR _cNomeEnt                     WHEN .F.			SIZE 120, 010 OF oDlg1 PIXEL
@ 050, 060 MSGET      oDEntrega      VAR _dEntrega                             			SIZE 060, 010 OF oDlg1 PIXEL Valid !empty(_dEntrega) 


@ 080, 025 BUTTON oButton1           PROMPT "Ok"       ACTION(_nOk := 1, Close(oDlg1))          /* SIZE 037, 012 */ OF oDlg1 PIXEL
@ 080, 055 BUTTON oButton1           PROMPT "Cancelar" ACTION(_nOk := 2, Close(oDlg1))          SIZE 037, 012  		OF oDlg1 PIXEL

ACTIVATE MSDIALOG oDlg1 CENTERED


If _nOk == 1 .and. !empty(_cFornece) .and. !empty(_cLoja) .and. !empty(_dEntrega) .and. !empty(_cFilEnt)
	_cQuery := "UPDATE " + RetSqlName('SC7')
	_cQuery += " SET C7_FORNECE 	= '" + _cFornece + "', "
	_cQuery +=     " C7_LOJA 		= '" 	 + _cLoja 	 + "', "
	_cQuery +=     " C7_DATPRF 		= '" + dtos(_dEntrega) + "', "
	_cQuery +=     " C7_FILENT 		= '"  + _cFilEnt	 + "'"
	_cQuery += " WHERE D_E_L_E_T_ 	<> '*'"
	_cQuery += " AND C7_NUM 		= '" 	 + SC7->C7_NUM    + "'"
	_cQuery += " AND C7_FILIAL 		= '"  + SC7->C7_FILIAL + "'"
	asdf := TcSqlExec(_cQuery)
EndIf

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Atualização da Loja do Fornecedor
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function atuLoja()

_cLoja:=Posicione('SA2',1,xFilial('SA2') + _cFornece, 'A2_LOJA')

Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// validacao fornecdor
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValiFor()
//////////////////////////

_lRet := .f.
If !empty(Posicione('SA2',1,xFilial('SA2') + _cFornece + alltrim(_cLoja),'A2_NOME'))
	If SA2->A2_MSBLQL == '1'
		MsgAlert("Fornecedor bloqueado para uso.")
	Else
		_lRet := .t.
		_cNomeFor := SA2->A2_NOME
		_oNomeFor:Refresh()
	EndIf
Else
	MsgAlert("Fornecedor não localizado")
EndIf

Return(_lRet)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// validacao filial de entrega
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValiEnt()
//////////////////////////

_aAlias := GetArea()
_aAliasSM0 := SM0->(GetArea())

_lRet := .f.
If !empty(Posicione('SM0',1,'01' + _cFilEnt,'M0_FILIAL'))
	_lRet := .t.
	_cNomeEnt := SM0->M0_FILIAL
	_oNomeEnt:Refresh()
Else
	MsgAlert("Loja não localizada")
EndIf

RestArea(_aAliasSM0)
RestArea(_aAlias)

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ALTERA ORDEM DO ARRAY ACORES
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _MT120COR()
////////////////////////
Local _aCores := aClone(paramixb)
Local _x := aclone(_acores[1,4])

_acores[1,4] := aclone(_aCores[1,8])
_acores[1,8] := aclone(_x)

Return(aClone(_aCores[1]))

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CONSULTA FINANCEIRO
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_TITXPC()
///////////////////////////////

Local _aAlias, _cQuery, _aNotas, _nNota, _lTela, _cCombo, _oCombo
_aAlias := GetArea()

If empty(SC7->C7_NFISCAL)
	MsgBox('Pedido ainda não faturado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf
_cQuery := "SELECT DISTINCT E2_PREFIXO, E2_NUM, E2_PARCELA, CONVERT(CHAR, CONVERT(DATETIME,E2_VENCREA),103) VENCTO, "
_cQuery += " CONVERT(CHAR, CONVERT(DATETIME,E2_BAIXA),103) BAIXA, E2_SALDO, E2_VALOR"
_cQuery += " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK) "
_cQuery += " WHERE E2_MSFIL 	= '" + SC7->C7_FILENT + "'"
_cQuery += " AND E2_NUM 		= '" + left(SC7->C7_NFISCAL,9) + "'"
_cQuery += " AND E2_PREFIXO 	= '" + left(alltrim(right(SC7->C7_NFISCAL,3)) + SC7->C7_FILENT,3) + "'"
_cQuery += " AND E2_FORNECE 	= '" + SC7->C7_FORNECE + "'"
_cQuery += " AND E2_LOJA 		= '" + SC7->C7_LOJA + "'"
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
DbSelectArea('SE2')
DbSetOrder(1)
If !DbSeek(xFilial('SE2') + _cTit + 'NF ' + SC7->C7_FORNECE + SC7->C7_LOJA,.f.)
	MsgBox('Título não localizado','ATENÇÃO!!!','ALERT')
Else
	Fc050Con()
EndIf
Return()
