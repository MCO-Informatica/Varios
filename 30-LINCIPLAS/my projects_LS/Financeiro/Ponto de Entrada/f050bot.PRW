#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	F050BOT
// Autor 		Alexandre Dalpiaz
// Data 		24/06/10
// Descricao  	Ponto de entrada na tela de consulta de titulos a pagar. Inclui botão.
//				Em consulta de faturas, lista todos os títulos que compoem a fatura.
//				Em consulta de títulos integrantes de fatura, lista os movimentos de baixa da fatura
//				Consulta títulos envolvidos em encontro de contas - compensação entre carteiras (CEC - LS_CEC)
// Uso         	Laselva
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function F050BOT()
///////////////////////

Local _aButtons := {}
If SE2->E2_FATURA = 'NOTFAT'
	aAdd(_aButtons,{'PMSZOOMIN',{|| U_LA_FC750()},'Títulos da Fatura','Títulos da Fatura'})
ElseIf !empty(SE2->E2_FATURA)
	aAdd(_aButtons,{'SIMULACA',{|| U_LA_FC750()},'Posição da Fatura','Posição da Fatura'})
EndIf

If !empty(SE2->E2_IDENTEE)
	aAdd(_aButtons,{'PMSZOOMIN',{|| U_LS_CEC('SE2')},'Encontro de Contas','Encontro de Contas'})
EndIf                

If SE2->E2_SALDO < SE2->E2_VALOR
	_cQuery := "SELECT E5_DATA, E5_VALOR, E5_NUMERO, E5_PARCELA, E5_PREFIXO, E5_TIPO, E5_RECPAG, E5_SEQ, SE2.E2_SALDO SALDO, "
	_cQuery += _cEnter + " SE2.E2_EMISSAO EMISSAO, E2.E2_PREFIXO, E2.E2_TIPO, E2.E2_EMISSAO PAGAMENTO, "
	_cQuery += _cEnter + " RTRIM(LTRIM(SE2.E2_PORTADO + E2.E2_PORTADO)) BANCO, "
	_cQuery += _cEnter + " '' AGENCIA," 
	_cQuery += _cEnter + " '' CONTA"

	_cQuery += _cEnter + " FROM " + RetSqlName('SE5') + " SE5 (NOLOCK)"                                          

	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SE2') + " SE2 (NOLOCK)"                                          
	_cQuery += _cEnter + " ON SE2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO = LEFT(E5_DOCUMEN,18)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SE2') + " E2 (NOLOCK)"
	_cQuery += _cEnter + " ON E2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E2.E2_MSFIL = E2.E2_MATRIZ"
	_cQuery += _cEnter + " AND E2.E2_PREFIXO = E5_PREFIXO "
	_cQuery += _cEnter + " AND E2.E2_NUM = E5_NUMERO"
	_cQuery += _cEnter + " AND E2.E2_PARCELA = E5_PARCELA"
	_cQuery += _cEnter + " AND E2.E2_TIPO = E5_TIPO"
	_cQuery += _cEnter + " AND E2.E2_FORNECE = E5_FORNECE"
	_cQuery += _cEnter + " AND E2.E2_LOJA = E5_LOJA"
	
	_cQuery += _cEnter + " WHERE SE5.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND LEFT(E5_DOCUMEN,18) = '" + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + "'"
	_cQuery += _cEnter + " AND E5_FILIAL = '" + SE2->E2_MATRIZ + "'"
	_cQuery += _cEnter + " AND E5_MOTBX = 'CMP'"
	_cQuery += _cEnter + " AND E5_SITUACA <> 'C'"
	_cQuery += _cEnter + " AND E5_TIPODOC <> '" + iif(SE2->E2_TIPO == 'PA ','BA','CP') + "'"             
	_cQuery += _cEnter + " ORDER BY E5_SEQ"          
	
	If Select('TRBCMP') > 0
		TRBCMP->(DbCloseArea())
	EndIf
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRBCMP',.f.,.f.)},'Verificando Baixas...')
	TcSetField("TRBCMP","E5_DATA"   ,"D")
	TcSetField("TRBCMP","EMISSAO"   ,"D")
	TcSetField("TRBCMP","PAGAMENTO" ,"D")
	If !eof()
		aAdd(_aButtons,{'PMSZOOMIN',{|| U_LS_CMP('SE2')},'Compensações','Compensações'})
	EndIf                                             

EndIf

Return(_aButtons)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LA_FC750()
////////////////////////
Local _cEnter := chr(13) + chr(10)

If SE2->E2_FATURA = 'NOTFAT'
	
	_cQuery := "SELECT E2_FILORIG, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, "
	_cQuery += _cEnter + " E2_EMISSAO, E2_VENCTO, E2_VENCREA, E5_DATA, E2_VALOR, E5_VALOR, E5_RECPAG, E5_MOTBX, E5_HISTOR"
	_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE5') + " SE5 (NOLOCK)"
	_cQuery += _cEnter + " ON SE5.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E5_PREFIXO = E2_PREFIXO"
	_cQuery += _cEnter + " AND E5_NUMERO = E2_NUM"
	_cQuery += _cEnter + " AND E5_FORNECE = E2_FORNECE"
	_cQuery += _cEnter + " AND E5_LOJA = E2_LOJA"
	_cQuery += _cEnter + " AND E5_PARCELA = E2_PARCELA"
	_cQuery += _cEnter + " AND E5_TIPO = E2_TIPO"
	_cQuery += _cEnter + " AND E5_MOTBX = 'FAT'"
	_cQuery += _cEnter + " AND E5_FILIAL = E2_MSFIL"
	
	_cQuery += _cEnter + " WHERE E2_FATURA = '" + SE2->E2_NUM + "'"
	_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E2_MSFIL = '" + SE2->E2_MSFIL + "'"
	_cQuery += _cEnter + " ORDER BY E2_EMISSAO, SE2.R_E_C_N_O_"
	
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)},'Selecionando títulos...')
	U_GravaQuery('f050bot_a.sql',_cQuery)
	
	If !eof()
		
		TcSetField("TRB","E2_EMISSAO","D")
		TcSetField("TRB","E2_VENCTO" ,"D")
		TcSetField("TRB","E2_VENCREA","D")
		TcSetField("TRB","E5_DATA"   ,"D")
		
		DbGoTop()
		
		_aCols := {}
		Do While !eof()
			aAdd(_aCols, {E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_EMISSAO, E2_VENCTO, E2_VENCREA, E5_DATA, E2_VALOR, E5_VALOR, E2_NOMFOR, E5_RECPAG, E5_MOTBX, E5_HISTOR, .F.})
			DbSkip()
		EndDo
		
		_nAltura 	:= 150 + 15 * min(34,len(_aCols))
		_nLargura 	:= oMainWnd:nClientWidth - 50
		_aHeader := {}
		
		DbSelectArea('SX3')
		DbSetOrder(2)
		DbSeek('E2_PREFIXO') ; AADD(_aHeader,{ TRIM(X3_TITULO)   , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E2_NUM'    ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E2_PARCELA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E2_TIPO'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E2_EMISSAO') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E2_VENCTO' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E2_VENCREA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_DATA'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E2_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E2_NOMFOR' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_RECPAG' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_MOTBX'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_HISTOR' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		_nOPc := 0
		oDlg1       := MSDialog():New( 20,0,_nAltura,_nLargura,"Títulos da fatura " + SE2->E2_NUM,,,.F.,,,,,,.T.,,,.T. )
		oDlg1:bInit := {||EnchoiceBar(oDlg1,{||_nOpc :=1,oDlg1:End() },{||_nOpc := 2,oDlg1:End()},.F.)}
		oBrwDiv     := MsNewGetDados():New(020,00,_nAltura/2-10,_nLargura/2,,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',,_aHeader,_aCols )
		oDlg1:Activate(,,,.t.)
		
	Else
		
		MsgBox('Títulos não localizados','ATENÇÃO!!!','INFO')
		
	EndIf
	
	TRB->(DbCloseArea())
	
ElseIf !empty(SE2->E2_FATURA)
	
	_cQuery := "SELECT E2_FILORIG, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_FATURA,"
	_cQuery += _cEnter + " E2_EMISSAO, E2_VENCTO, E2_VENCREA, E5_DATA, E2_VALOR, E5_VALOR, E5_RECPAG, E5_MOTBX, E5_HISTOR, SE2.R_E_C_N_O_"
	_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE5') + " SE5 (NOLOCK)"
	_cQuery += _cEnter + " ON SE5.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E5_PREFIXO = E2_PREFIXO"
	_cQuery += _cEnter + " AND E5_NUMERO = E2_NUM"
	_cQuery += _cEnter + " AND E5_FORNECE = E2_FORNECE"
	_cQuery += _cEnter + " AND E5_LOJA = E2_LOJA"
	_cQuery += _cEnter + " AND E5_PARCELA = E2_PARCELA"
	_cQuery += _cEnter + " AND E5_TIPO = E2_TIPO"
	_cQuery += _cEnter + " AND E5_FILIAL = E2_MSFIL"
	
	_cQuery += _cEnter + " WHERE ((E2_NUM = '" + SE2->E2_FATURA + "'"
	_cQuery += _cEnter + " AND E2_FATURA = 'NOTFAT')"
	_cQuery += _cEnter + " OR E2_FATURA = '" + SE2->E2_FATURA + "')"
	_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E2_MSFIL = '" + SE2->E2_MSFIL + "'"
	_cQuery += _cEnter + " ORDER BY E2_EMISSAO, SE2.R_E_C_N_O_"
	
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)},'Selecionando títulos...')
	U_GravaQuery('f050bot_b.sql',_cQuery)
	
	DbGoTop()
	
	If !eof()
		
		TcSetField("TRB","E2_EMISSAO","D")
		TcSetField("TRB","E2_VENCTO" ,"D")
		TcSetField("TRB","E2_VENCREA","D")
		TcSetField("TRB","E5_DATA"   ,"D")
		_aCols := {}
		
		count to _nQuant for E2_FATURA <> 'NOTFAT'
		DbGoTop()
		If _nQuant > 1
			aAdd(_aCols, {'Títulos', 'Originais', '', '', '', '', '', '', '', '', '', '', '', '', , .F.})
		EndIf
		_cFat  := TRB->E2_FATURA
		Do While !eof()
			
			If 	_cFat <> TRB->E2_FATURA .and. _nQuant > 1
				aAdd(_aCols, {'', '', '', '', '', '', '', '', '', '', '', '', '', '', , .F.})
				aAdd(_aCols, {'Títulos', 'da Fatura', '', '', '', '', '', '', '', '', '', '', '', '', , .F.})
			EndIf
			_cFat  := TRB->E2_FATURA
			
			If (TRB->E2_FATURA <> 'NOTFAT' .and. _nQuant > 1) .or. _nQuant > 1 .or. TRB->E2_FATURA = 'NOTFAT'
				aAdd(_aCols, {TRB->E2_PREFIXO, TRB->E2_NUM, TRB->E2_PARCELA, TRB->E2_TIPO, dtoc(TRB->E2_EMISSAO), dtoc(TRB->E2_VENCTO), dtoc(TRB->E2_VENCREA), dtoc(TRB->E5_DATA), tran(TRB->E2_VALOR,'@E 999,999,999.99'), tran(TRB->E5_VALOR,'@E 999,999,999.99'), TRB->E2_NOMFOR, TRB->E5_RECPAG, TRB->E5_MOTBX, TRB->E5_HISTOR, .F.})
			EndIf
			DbSkip()
		EndDo
		
		_nAltura 	:= 150 + 15 * min(34,len(_aCols))
		_nLargura 	:= oMainWnd:nClientWidth - 50
		_aHeader := {}
		
		DbSelectArea('SX3')
		DbSetOrder(2)
		DbSeek('E2_PREFIXO') ; AADD(_aHeader,{ TRIM(X3_TITULO)   , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E2_NUM'    ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E2_PARCELA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E2_TIPO'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E2_EMISSAO') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E2_VENCTO' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E2_VENCREA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_DATA'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E2_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E2_NOMFOR' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_RECPAG' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_MOTBX'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_HISTOR' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		_nOPc := 0
		oDlg1       := MSDialog():New( 0,0,_nAltura,_nLargura,"Títulos Originais x Fatura ",,,.F.,,,,,,.T.,,,.T. )
		oDlg1:bInit := {||EnchoiceBar(oDlg1,{||_nOpc :=1,oDlg1:End() },{||_nOpc := 2,oDlg1:End()},.F.)}
		oBrwDiv     := MsNewGetDados():New(020,00,_nAltura/2-10,_nLargura/2,,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',,_aHeader,_aCols )
		oDlg1:Activate(,,,.t.)
		
	Else
		MsgBox('Títulos não localizados','ATENÇÃO!!!','INFO')
	EndIf
	
	TRB->(DbCloseArea())

EndIf

Return()

