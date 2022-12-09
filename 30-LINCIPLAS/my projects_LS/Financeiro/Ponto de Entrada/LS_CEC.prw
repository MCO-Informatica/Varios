#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_CEC
// Autor 		Alexandre Dalpiaz
// Data 		10/08/2011
// Descricao  	Consulta títulos envolvidos em encontro de contas - compensação entre carteiras (CEC - LS_CEC)
// 				Chamada nos pontos de entrada F040BOT e F050BOT
// Uso         	Laselva
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_CEC(_cCarteira)
///////////////////////////////

_cQuery := "SELECT E5_VALOR, E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_CLIFOR, E5_LOJA, E5_IDENTEE, E5_TIPO, E5_RECPAG,"
_cQuery += _cEnter + " ISNULL(E1_VALOR,E2_VALOR) E1_VALOR, ISNULL(E1_SALDO,E2_SALDO) E1_SALDO, ISNULL(E1_EMISSAO,E2_EMISSAO) E1_EMISSAO, "
_cQuery += _cEnter + " ISNULL(E1_VENCTO,E2_VENCTO) E1_VENCTO, E5_DATA""

_cQuery += _cEnter + " FROM " + RetSqlName('SE5') + " SE5 (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE1') + " SE1 (NOLOCK)"
_cQuery += _cEnter + " ON E1_NUM = E5_NUMERO"
_cQuery += _cEnter + " AND E1_PREFIXO =  E5_PREFIXO"
_cQuery += _cEnter + " AND E1_PARCELA =  E5_PARCELA"
_cQuery += _cEnter + " AND E1_CLIENTE = E5_CLIENTE"
_cQuery += _cEnter + " AND E1_LOJA = E5_LOJA"
_cQuery += _cEnter + " AND E1_IDENTEE =  E5_IDENTEE"
_cQuery += _cEnter + " AND SE1.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE2') + " SE2 (NOLOCK)"
_cQuery += _cEnter + " ON E2_NUM = E5_NUMERO"
_cQuery += _cEnter + " AND E2_PREFIXO =  E5_PREFIXO"
_cQuery += _cEnter + " AND E2_PARCELA =  E5_PARCELA"
_cQuery += _cEnter + " AND E2_FORNECE = E5_FORNECE"
_cQuery += _cEnter + " AND E2_LOJA = E5_LOJA"
_cQuery += _cEnter + " AND E2_IDENTEE =  E5_IDENTEE"
_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ = ''"

If _cCarteira == 'SE2'
	_cQuery += _cEnter + " WHERE E5_FILIAL = '" + SE2->E2_MSFIL + "'"
	_cQuery += _cEnter + " AND E5_MOTBX = 'CEC'"
	_cQuery += _cEnter + " AND E5_IDENTEE = '"  + SE2->E2_IDENTEE + "'"
	_cQuery += _cEnter + " AND SE5.D_E_L_E_T_ = ''"                
	_cTitulo := "Encontro de Contas " + SE2->E2_NUM + ' (' + SE2->E2_IDENTEE + ')'
Else
	_cQuery += _cEnter + " WHERE E5_FILIAL = '" + SE1->E1_MSFIL + "'"
	_cQuery += _cEnter + " AND E5_MOTBX = 'CEC'"
	_cQuery += _cEnter + " AND E5_IDENTEE = '"  + SE1->E1_IDENTEE + "'"
	_cQuery += _cEnter + " AND SE5.D_E_L_E_T_ = ''"
	_cTitulo := "Encontro de Contas " + SE1->E1_NUM + ' (' + SE1->E1_IDENTEE + ')'
EndIf

MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)},'Selecionando títulos...')
U_GravaQuery('f050bot_c.sql',_cQuery)

If !eof()
	
	TcSetField("TRB","E5_DATA"   ,"D")
	TcSetField("TRB","E1_EMISSAO","D")
	TcSetField("TRB","E1_VENCTO" ,"D")
	
	DbGoTop()
	
	_aCols := {}
	Do While !eof()
		aAdd(_aCols, {TRB->E5_PREFIXO, TRB->E5_NUMERO, TRB->E5_PARCELA, TRB->E5_TIPO, TRB->E1_EMISSAO, TRB->E1_VENCTO, TRB->E5_DATA, TRB->E1_VALOR, TRB->E5_VALOR, TRB->E1_SALDO, TRB->E5_RECPAG, .F.})
		DbSkip()
	EndDo
	
	DbCloseArea()
	
	_nAltura 	:= 150 + 15 * len(_aCols)
	_nLargura 	:= oMainWnd:nClientWidth - 50
	_aHeader := {}
	
	DbSelectArea('SX3')
	DbSetOrder(2)
	DbSeek('E5_PREFIXO') ; AADD(_aHeader,{ TRIM(X3_TITULO)   , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_NUMERO' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_PARCELA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_TIPO'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E1_EMISSAO') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E1_VENCTO' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_DATA'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E1_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E1_SALDO'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	DbSeek('E5_RECPAG' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
	_nOPc := 0
	oDlg1       := MSDialog():New( 20,0,_nAltura,_nLargura,_cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oDlg1:bInit := {||EnchoiceBar(oDlg1,{||_nOpc :=1,oDlg1:End() },{||_nOpc := 2,oDlg1:End()},.F.)}
	oBrwDiv     := MsNewGetDados():New(020,00,_nAltura/2-10,_nLargura/2,,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',,_aHeader,_aCols )
	oDlg1:Activate(,,,.t.)
	
Else
	
	MsgBox('Títulos não localizados','ATENÇÃO!!!','INFO')
	
EndIf

DbCloseArea()

Return()

