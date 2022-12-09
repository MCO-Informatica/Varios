#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	F040BOT
// Autor 		Alexandre Dalpiaz
// Data 		10/08/2011
// Descricao  	Ponto de entrada na tela de consulta de titulos a receber. Inclui botão.
//				Em consulta de faturas, lista todos os títulos que compoem a fatura.
//				Em consulta de títulos integrantes de fatura, lista os movimentos de baixa da fatura
//				Consulta títulos envolvidos em encontro de contas - compensação entre carteiras (CEC - LS_CEC)
// Uso         	Laselva
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function F040BOT()
///////////////////////
Local _aButtons := {}
If SE1->E1_FATURA = 'NOTFAT'
	aAdd(_aButtons,{'PMSZOOMIN',{|| U_LA_FC740()},'Títulos da Fatura','Títulos da Fatura'})
ElseIf !empty(SE1->E1_FATURA)
	aAdd(_aButtons,{'SIMULACA',{|| U_LA_FC740()},'Posição da Fatura','Posição da Fatura'})
EndIf

If !empty(SE1->E1_IDENTEE)
	aAdd(_aButtons,{'PMSZOOMIN',{|| U_LS_CEC('SE1')},'Encontro de Contas','Encontro de Contas'})
EndIf

If SE1->E1_SALDO < SE1->E1_VALOR
	_cQuery := "SELECT E5_DATA, E5_VALOR, E5_NUMERO, E5_PARCELA, E5_PREFIXO, E5_TIPO, E5_RECPAG, E5_SEQ, SE1.E1_SALDO SALDO, "
	_cQuery += _cEnter + " SE1.E1_EMISSAO EMISSAO, E1.E1_PREFIXO, E1.E1_TIPO, E1.E1_EMISSAO PAGAMENTO, "
	_cQuery += _cEnter + " RTRIM(LTRIM(SE1.E1_PORTADO + E1.E1_PORTADO)) BANCO, "
	_cQuery += _cEnter + " RTRIM(LTRIM(SE1.E1_AGEDEP + E1.E1_AGEDEP)) AGENCIA," 
	_cQuery += _cEnter + " RTRIM(LTRIM(SE1.E1_CONTA + E1.E1_CONTA)) CONTA"

	_cQuery += _cEnter + " FROM " + RetSqlName('SE5') + " SE5 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SE1') + " SE1 (NOLOCK)"
	_cQuery += _cEnter + " ON SE1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND SE1.E1_MSFIL = SE1.E1_MATRIZ"
	_cQuery += _cEnter + " AND SE1.E1_PREFIXO + SE1.E1_NUM + SE1.E1_PARCELA + SE1.E1_TIPO = LEFT(E5_DOCUMEN,18)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SE1') + " E1 (NOLOCK)"
	_cQuery += _cEnter + " ON E1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E1.E1_MSFIL = E1.E1_MATRIZ"
	_cQuery += _cEnter + " AND E1.E1_PREFIXO = E5_PREFIXO "
	_cQuery += _cEnter + " AND E1.E1_NUM = E5_NUMERO"
	_cQuery += _cEnter + " AND E1.E1_PARCELA = E5_PARCELA"
	_cQuery += _cEnter + " AND E1.E1_TIPO = E5_TIPO"
	
	_cQuery += _cEnter + " WHERE SE5.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND LEFT(E5_DOCUMEN,18) = '" + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + "'"
	_cQuery += _cEnter + " AND E5_FILIAL = '" + SE1->E1_MATRIZ + "'"
	_cQuery += _cEnter + " AND E5_MOTBX = 'CMP'"
	_cQuery += _cEnter + " AND E5_SITUACA <> 'C'"
	_cQuery += _cEnter + " AND E5_TIPODOC <> '" + iif(SE1->E1_TIPO == 'RA ','BA','CP') + "'"
	_cQuery += _cEnter + " ORDER BY E5_SEQ"
	
	If Select('TRBCMP') > 0
		TRBCMP->(DbCloseArea())
	EndIf
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRBCMP',.f.,.f.)},'Verificando Baixas...')
	TcSetField("TRBCMP","E5_DATA"   ,"D")
	TcSetField("TRBCMP","EMISSAO"   ,"D")
	TcSetField("TRBCMP","PAGAMENTO" ,"D")
	
	If !eof()
		aAdd(_aButtons,{'PMSZOOMIN',{|| U_LS_CMP('SE1')},'Compensações','Compensações'})
	EndIf
	
EndIf
Return(_aButtons)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LA_FC740()
////////////////////////
Local _cEnter := chr(13) + chr(10)

If SE1->E1_FATURA = 'NOTFAT'
	
	_cQuery := "SELECT E1_FILORIG, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, "
	_cQuery += _cEnter + " E1_EMISSAO, E1_VENCTO, E1_VENCREA, E5_DATA, E1_VALOR, E5_VALOR, E5_RECPAG, E5_MOTBX, E5_HISTOR"
	_cQuery += _cEnter + " FROM " + RetSqlName('SE1') + " SE1 (NOLOCK)"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE5') + " SE5 (NOLOCK)"
	_cQuery += _cEnter + " ON SE5.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E5_PREFIXO = E1_PREFIXO"
	_cQuery += _cEnter + " AND E5_NUMERO = E1_NUM"
	_cQuery += _cEnter + " AND E5_CLIENTE = E1_CLIENTE"
	_cQuery += _cEnter + " AND E5_LOJA = E1_LOJA"
	_cQuery += _cEnter + " AND E5_PARCELA = E1_PARCELA"
	_cQuery += _cEnter + " AND E5_TIPO = E1_TIPO"
	_cQuery += _cEnter + " AND E5_MOTBX = 'FAT'"
	_cQuery += _cEnter + " AND E5_FILIAL = E1_MSFIL"
	
	_cQuery += _cEnter + " WHERE E1_FATURA = '" + SE1->E1_NUM + "'"
	_cQuery += _cEnter + " AND SE1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E1_MSFIL = '" + SE1->E1_MSFIL + "'"
	_cQuery += _cEnter + " ORDER BY E1_EMISSAO, SE1.R_E_C_N_O_"
	
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)},'Selecionando títulos...')
	U_GravaQuery('f040bot_a.sql',_cQuery)
	
	If !eof()
		
		TcSetField("TRB","E1_EMISSAO","D")
		TcSetField("TRB","E1_VENCTO" ,"D")
		TcSetField("TRB","E1_VENCREA","D")
		TcSetField("TRB","E5_DATA"   ,"D")
		
		DbGoTop()
		
		_aCols := {}
		Do While !eof()
			aAdd(_aCols, {E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E5_DATA, E1_VALOR, E5_VALOR, E1_NOMCLI, E5_RECPAG, E5_MOTBX, E5_HISTOR, .F.})
			DbSkip()
		EndDo
		
		_nAltura 	:= 150 + 15 * len(_aCols)
		_nLargura 	:= oMainWnd:nClientWidth - 50
		_aHeader := {}
		
		DbSelectArea('SX3')
		DbSetOrder(2)
		DbSeek('E1_PREFIXO') ; AADD(_aHeader,{ TRIM(X3_TITULO)   , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E1_NUM'    ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E1_PARCELA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E1_TIPO'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E1_EMISSAO') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E1_VENCTO' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E1_VENCREA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_DATA'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E1_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E1_NOMCLI' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_RECPAG' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_MOTBX'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		DbSeek('E5_HISTOR' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL , '', X3_USADO, X3_TIPO, X3_ARQUIVO } )
		_nOPc := 0
		oDlg1       := MSDialog():New( 20,0,_nAltura,_nLargura,"Títulos da fatura " + SE1->E1_NUM,,,.F.,,,,,,.T.,,,.T. )
		oDlg1:bInit := {||EnchoiceBar(oDlg1,{||_nOpc :=1,oDlg1:End() },{||_nOpc := 2,oDlg1:End()},.F.)}
		oBrwDiv     := MsNewGetDados():New(020,00,_nAltura/2-10,_nLargura/2,,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',,_aHeader,_aCols )
		oDlg1:Activate(,,,.t.)
		
	Else
		
		MsgBox('Títulos não localizados','ATENÇÃO!!!','INFO')
		
	EndIf
	
	TRB->(DbCloseArea())
	
ElseIf !empty(SE1->E1_FATURA)
	
	_cQuery := "SELECT E1_FILORIG, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_FATURA,"
	_cQuery += _cEnter + " E1_EMISSAO, E1_VENCTO, E1_VENCREA, E5_DATA, E1_VALOR, E5_VALOR, E5_RECPAG, E5_MOTBX, E5_HISTOR, SE1.R_E_C_N_O_"
	_cQuery += _cEnter + " FROM " + RetSqlName('SE1') + " SE1 (NOLOCK)"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE5') + " SE5 (NOLOCK)"
	_cQuery += _cEnter + " ON SE5.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E5_PREFIXO = E1_PREFIXO"
	_cQuery += _cEnter + " AND E5_NUMERO = E1_NUM"
	_cQuery += _cEnter + " AND E5_CLIENTE = E1_CLIENTE"
	_cQuery += _cEnter + " AND E5_LOJA = E1_LOJA"
	_cQuery += _cEnter + " AND E5_PARCELA = E1_PARCELA"
	_cQuery += _cEnter + " AND E5_TIPO = E1_TIPO"
	_cQuery += _cEnter + " AND E5_FILIAL = E1_MSFIL"
	
	_cQuery += _cEnter + " WHERE ((E1_NUM = '" + SE1->E1_FATURA + "'"
	_cQuery += _cEnter + " AND E1_FATURA = 'NOTFAT')"
	_cQuery += _cEnter + " OR E1_FATURA = '" + SE1->E1_FATURA + "')"
	_cQuery += _cEnter + " AND SE1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E1_MSFIL = '" + SE1->E1_MSFIL + "'"
	_cQuery += _cEnter + " ORDER BY E1_EMISSAO, SE1.R_E_C_N_O_"
	
	MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)},'Selecionando títulos...')
	U_GravaQuery('f050bot_b.sql',_cQuery)
	
	DbGoTop()
	
	If !eof()
		
		TcSetField("TRB","E1_EMISSAO","D")
		TcSetField("TRB","E1_VENCTO" ,"D")
		TcSetField("TRB","E1_VENCREA","D")
		TcSetField("TRB","E5_DATA"   ,"D")
		_aCols := {}
		
		count to _nQuant for E1_FATURA <> 'NOTFAT'
		DbGoTop()
		If _nQuant > 1
			aAdd(_aCols, {'Títulos', 'Originais', '', '', '', '', '', '', '', '', '', '', '', '', , .F.})
		EndIf
		_cFat  := TRB->E1_FATURA
		Do While !eof()
			
			If 	_cFat <> TRB->E1_FATURA .and. _nQuant > 1
				aAdd(_aCols, {'', '', '', '', '', '', '', '', '', '', '', '', '', '', , .F.})
				aAdd(_aCols, {'Títulos', 'da Fatura', '', '', '', '', '', '', '', '', '', '', '', '', , .F.})
			EndIf
			_cFat  := TRB->E1_FATURA
			
			If (TRB->E1_FATURA <> 'NOTFAT' .and. _nQuant > 1) .or. _nQuant > 1 .or. TRB->E1_FATURA = 'NOTFAT'
				aAdd(_aCols, {TRB->E1_PREFIXO, TRB->E1_NUM, TRB->E1_PARCELA, TRB->E1_TIPO, dtoc(TRB->E1_EMISSAO), dtoc(TRB->E1_VENCTO), dtoc(TRB->E1_VENCREA), dtoc(TRB->E5_DATA), tran(TRB->E1_VALOR,'@E 999,999,999.99'), tran(TRB->E5_VALOR,'@E 999,999,999.99'), TRB->E1_NOMCLI, TRB->E5_RECPAG, TRB->E5_MOTBX, TRB->E5_HISTOR, .F.})
			EndIf
			DbSkip()
		EndDo
		
		_nAltura 	:= 150 + 15 * min(34,len(_aCols))
		_nLargura 	:= oMainWnd:nClientWidth - 50
		_aHeader := {}
		
		DbSelectArea('SX3')
		DbSetOrder(2)
		DbSeek('E1_PREFIXO') ; AADD(_aHeader,{ TRIM(X3_TITULO)   , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E1_NUM'    ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E1_PARCELA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E1_TIPO'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E1_EMISSAO') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E1_VENCTO' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E1_VENCREA') ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_DATA'   ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E1_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_VALOR'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E1_NOMCLI' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_RECPAG' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_MOTBX'  ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		DbSeek('E5_HISTOR' ) ; AADD(_aHeader,{ TRIM(X3_TITULO)	 , X3_CAMPO, '',X3_TAMANHO, 0 , '', X3_USADO, 'C', X3_ARQUIVO } )
		_nOPc := 0
		oDlg1       := MSDialog():New( 20,0,_nAltura,_nLargura,"Títulos Originais x Fatura ",,,.F.,,,,,,.T.,,,.T. )
		oDlg1:bInit := {||EnchoiceBar(oDlg1,{||_nOpc :=1,oDlg1:End() },{||_nOpc := 2,oDlg1:End()},.F.)}
		oBrwDiv     := MsNewGetDados():New(020,00,_nAltura/2-10,_nLargura/2,,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',,_aHeader,_aCols )
		oDlg1:Activate(,,,.t.)
		
	Else
		MsgBox('Títulos não localizados','ATENÇÃO!!!','INFO')
	EndIf
	
	TRB->(DbCloseArea())
	
EndIf

Return()


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F040FILTIT()
//////////////////////////

_lRet := .t.
If SE5->E5_MOTBX == 'CMP' .or. alltrim(SE5->E5_TIPO) $ 'RA/PA'
	
	If !(alltrim(SE5->E5_TIPO) $ 'RA/PA')
		_aArea := GetArea()
		DbSelectArea('SE5')
		_aAreaSE5 := GetArea()
		DbSetOrder(7)
		DbSeek(SE5->E5_FILIAL + left(SE5->E5_DOCUMEN,3) + substr(SE5->E5_DOCUMEN,4,9) + substr(SE5->E5_DOCUMEN,13,3) + substr(SE5->E5_DOCUMEN,16,3) ,.f.)
		If found()
			LS_SE5Cmp()
		EndIf
		
		RestArea(_aAreaSE5)
		RestArea(_aArea)
	EndIf

	LS_SE5Cmp()
	
	_lRet := .f.
EndIf
Return(_lRet)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_SE5Cmp()
///////////////////////////

cNomeArq := 'CNOMEARQ'
nValRec	 := SE5->E5_VALOR
cMotivo	 := SE5->E5_MOTBX
nCorrec  := SE5->E5_VLCORRE
nJuros   := SE5->E5_VLJUROS
nDescont := SE5->E5_VLDESCO

RecLock(cNomeArq,.t.)
cNomeArq->OK		 :=	1
cNomeArq->DATAX		 :=	SE5->E5_DATA
cNomeArq->JUROS		 :=	nJuros
//cNomeArq->MULTA		 :=	nMulta
cNomeArq->CORRECAO	 :=	nCorrec
cNomeArq->DESCONTOS  :=	nDescont
cNomeArq->VALORRECEB :=	nValRec
cNomeArq->MOTIVO 	 :=	cMotivo
cNomeArq->DATACONT	 :=	SE5->E5_DTDIGIT
cNomeArq->DATADISP	 :=	SE5->E5_DTDISPO
cNomeArq->LOTE		 :=	SE5->E5_LOTE
cNomeArq->HISTORICO  :=	iif(empty(SE5->E5_HISTOR),iif(SE5->E5_TIPO = 'PA','Pagamento','Recebimento') + ' Antecipago',SE5->E5_HISTOR)
cNomeArq->BANCO		 :=	SE5->E5_BANCO
cNomeArq->AGENCIA	 :=	SE5->E5_AGENCIA
cNomeArq->CONTA		 :=	SE5->E5_CONTA
cNomeArq->DOCUMENTO  :=	tran( SE5->E5_DOCUMEN,'@R XXX-XXXXXXXXX-XXX-XXX-XX-XXXXXX-XX') //Substr(SE5->E5_DOCUMEN,1,3)+"-"+Substr(SE5->E5_DOCUMEN,4,aTamSx3[1])+"-"+Substr(SE5->E5_DOCUMEN,aTamsx3[1]+4,1)+"-"+Substr(SE5->E5_DOCUMEN,aTamsx3[1]+5,3)
cNomeArq->FILIAL  	 := SE5->E5_FILIAL
cNomeArq->RECONC	 := SE5->E5_RECONC
MsUnlock()

Return()
