#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#DEFINE ENTER CHR(13)+CHR(10)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa.: LA_FECCX
// Autor....: Alexandre Dalpiaz
// Data.....: 29/06/10
// Descrição: WF gerador de títulos no SE1 para conciliação dos depósitos efetuados pelas lojas e crédito dos pagamento das operadoras de cartão de crédito
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 03/10/2012 - alexandre - criação de parâmetros para seleção de banco/ag/conta corrente que será utilizado no boleto
//							criação de parâmetros para seleção do cedente (fornecedor) utilizado no boleto
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LA_FECCX()
///////////////////////

_cPerg         := left("LAFECH    ",len(SX1->X1_GRUPO))
ValidPerg()
Pergunte(_cPerg, .f.)

DEFINE MSDIALOG _oDlgMenu TITLE "PDV - Geração de Títulos" FROM 1, 1 to 200, 420 OF oMainWnd PIXEL
@ 02,10 TO 077,200	 PIXEL OF _oDlgMenu

@ 10,018 Say " Este programa gerará títulos a receber "   		PIXEL OF _oDlgMenu
@ 18,018 Say " a partir do movimento dos PDVs das filiais," 	PIXEL OF _oDlgMenu
@ 26,018 Say " para posterior conciliação" 						PIXEL OF _oDlgMenu

@ 080, 060 button 'Parâmetros' 	size 40,15 action pergunte (_cPerg,.t.) OF _oDlgMenu PIXEL
@ 080, 110 button 'OK' 			size 40,15 action (Processa ({|lEnd| U_LAFECCX(.f.)}, "Processando..."),_oDlgMenu:End()) OF _oDlgMenu PIXEL
@ 080, 160 button 'Fechar' 		size 40,15 action _oDlgMenu:End() OF _oDlgMenu PIXEL

ACTIVATE MSDIALOG _oDlgMenu CENTERED

lEnd := .t.

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LAFECCX(aParam)
///////////////////////
//User Function LAFECCX()  // linhas para teste em debug
//aparam := {'01','01'}
_cTeste := '0000'
_cEnter := chr(13)
Private _lJob   := (aParam <> Nil .and. ValType(aParam) == "A")
Private _lAutom := (aParam <> Nil .and. ValType(aParam) == "L")
If _lJob .and. _cTeste < '9999'
	conout('teste ' + SOMA1(_cteste))
EndIf

If _lJob
	
	WfPrepEnv( '01','01')
	ChkFile("SM0")
	
	mv_par01 := date() - 5
	mv_par02 := date() - 1
	mv_par03 := "  "
	
ElseIf FunName() <> 'LA_FECCX'
	
	mv_par01 := date() - 5
	mv_par02 := date() - 1
	mv_par03 := "  "
	
EndIf

_cQuery := "SELECT L4_FILIAL, A1_COD, A1_NREDUZ, L4_DATA, L4_FORMA, L4_ADMINIS, L4_PDV, SUM(L4_VALOR) VALOR, AE_DESC, SUM(AE_TAXA) TAXA, AE_DIAS, "
_cQuery += _cEnter + " ISNULL(PAI_NUMRED,'') PAI_NUMRED, ISNULL(PAI_SERPDV,'') PAI_SERPDV"
_cQuery += _cEnter + " FROM " + RetSqlName('SL4') + " SL4 (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('PAI') + " PAI (NOLOCK)"
_cQuery += _cEnter + " ON PAI.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAI_FILIAL = L4_FILIAL"
_cQuery += _cEnter + " AND PAI_DTMOVT = L4_DATA"
_cQuery += _cEnter + " AND RIGHT('0000000000' + PAI_PDV,10) = L4_PDV"

_cQuery += _cEnter + " JOIN " + RetSqlName('SAE') + " SAE (NOLOCK)"
_cQuery += _cEnter + " ON SAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND AE_COD = L4_ADMINIS"

_cQuery += _cEnter + " JOIN " + RetSqlName('SA1') + " SA1 (NOLOCK)"
_cQuery += _cEnter + " ON SA1.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + " AND A1_COD 			< '000009'"
_cQuery += _cEnter + " AND A1_FILIAL 		= ''"
_cQuery += _cEnter + " AND A1_LOJA 			= L4_FILIAL"
_cQuery += _cEnter + " AND A1_MSBLQL 		<> '1'"

_cQuery += _cEnter + " WHERE SL4.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND L4_DATA 			BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += _cEnter + " AND L4_DATA 			> '20121001'
_cQuery += _cEnter + " AND L4_FORMA 		NOT IN ('E$','MK','U$','CO')"
_cQuery += _cEnter + " AND L4_FILIAL 		IN " + FormatIn(alltrim(GetMv('LA_PDVDPID')),',')

/*
If cFilAnt <> '01'
	_cQuery += _cEnter + " AND L4_FILIAL = '" + cFilAnt+ "'"
EndIf
*/

If !Empty(mv_par03)
	_cQuery += _cEnter + " AND L4_FILIAL = '" + mv_par03+ "'"
EndIf

_cQuery += _cEnter + " AND L4_ADMINIS 		= '016'"		// gera somente para valores em dinheiro.
_cQuery += _cEnter + " AND 'Z' + L4_FILIAL + RIGHT(L4_DATA,6) + left(L4_ADMINIS,3) + 'PDV' + RIGHT(L4_PDV,3) NOT IN "
_cQuery += _cEnter + " (SELECT E1_PREFIXO + E1_NUM + E1_TIPO + E1_PARCELA TITULOS"
_cQuery += _cEnter + " FROM  " + RetSqlName('SE1') + " SE1 (NOLOCK)"
_cQuery += _cEnter + " WHERE SE1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND E1_PREFIXO 		= 'Z' + L4_FILIAL"
_cQuery += _cEnter + " AND E1_NUM 			= RIGHT(L4_DATA,6) + left(L4_ADMINIS,3) "
_cQuery += _cEnter + " AND E1_TIPO 			= 'PDV'"
_cQuery += _cEnter + " AND E1_PARCELA 		= RIGHT(L4_PDV,3)"
_cQuery += _cEnter + " AND E1_FILIAL 		= '" + xFilial('SE1') + "'"
_cQuery += _cEnter + " AND E1_EMISSAO 		BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "')"
_cQuery += _cEnter + " GROUP BY L4_FILIAL, A1_COD, A1_NREDUZ, L4_DATA, L4_FORMA, L4_ADMINIS, L4_PDV, AE_DESC, AE_DIAS,PAI_NUMRED, PAI_SERPDV"

If _lJob .and. _cTeste < '9999'
	conout('teste ' + SOMA1(_cteste))
EndIf
If !_lJob
	U_GravaQuery('LA_FECCX.SQL',_cQuery)
Else
	MemoWrit('\\terra\c$\spool\queries\WF_feccx.sql', _cQuery)
EndIf
MsAguarde({||DbUseArea(.t.,'TOPCONN', TcGenQry(,,_cQuery),'PDV',.f.,.f.)},'Verificando Movimentos')

If eof()
	If !_lJob .and. !_lAutom .and. FunName() == 'LA_FECCX'
		MsgAlert('Nenhum lançamento encontrado. Verifique os parâmetros: ' + dtoc(mv_par01) + ' a ' + dtoc(mv_par02))
	ElseIf _lJob .or. _lAutom
		Conout('Nenhum lançamento encontrado. Verifique os parâmetros: ' + dtoc(mv_par01) + ' a ' + dtoc(mv_par02))
	EndIf
	DbCloseArea()
	Return()
EndIf

TCSetField('PDV', 'L4_DATA', 'D')

count to _nLastRec
DbGoTop()
If _lJob .and. _cTeste < '9999'
	conout('teste ' + SOMA1(_cteste))
EndIf
_aTitulos := {}
_aErros   := {}

_aNumBor := {}

Processa({|| GeraTitulos()})

//alice 85654595
WaitRun("NET USE x: /DELETE /Y")
WaitRun("NET USE x: \\192.168.0.189\OUTBOX")

For _nI := 1 to len(_aNumBor)  

	mv_par01 := _aNumBor[_nI,2]	// bordero
	mv_par02 := _aNumBor[_nI,2]	// bordero
	mv_par03 := 'HSBC_CNR.REM'
	mv_par04 := '\\192.168.0.189\NEXXERA\OUTBOX\COB_' + alltrim(_aNumBor[_nI,5]) + '_' + right(dtos(dDataBase),6) + '.REM'    //pag_bol_1273656_121227.rem
	mv_par04 := 'X:\COB_' + alltrim(_aNumBor[_nI,5]) + '_' + right(dtos(dDataBase),6) + '.REM'    //pag_bol_1273656_121227.rem
	mv_par05 := _aNumBor[_nI,3]					// banco
	mv_par06 := padr(alltrim(_aNumBor[_nI,4]),5,' ')		// agencia
	mv_par07 := padr(alltrim(_aNumBor[_nI,5]),10,' ')	// conta
	mv_par08 := 'PDV'			// Sub-Conta
	mv_par09 := 1
	mv_par10 := 2
	mv_par11 := ''
	mv_par12 := ''
	mv_par13 := 3
	
	MsAguarde({|| fa150Gera("SE1")},'Gerando arquivo de remessa CNAB')
		
Next

WaitRun("NET USE x: /DELETE /Y")

DbSelectArea('PDV')
DbCloseArea()
Email()
If _lJob
	Reset Environment
EndIf


Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg ()
////////////////////////////
Private _cAlias := Alias ()
Private _aRegs  := {}

//           GRUPO  ORDEM PERGUNT                 PERSPA                  PERENG                  VARIAVL   TIPO TAM DEC PRESEL GSC  VALID VAR01       DEF01       DEFSPA1     DEFENG1     CNT01 VAR02 DEF02        DEFSPA2      DEFENG2      CNT02 VAR03 DEF03       DEFSPA3     DEFENG3     CNT03 VAR04 DEF04 DEFSPA4 DEFENG4 CNT04 VAR05 DEF05 DEFSPA5 DEFENG5 CNT05 F3     GRPSXG
aAdd(_aRegs,{_cPerg, "01", "Data de              ","","","mv_ch1", "D",08,  0,  0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "02", "Data até             ","","","mv_ch2", "D",08,  0,  0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "03", "Filial               ","","","mv_ch3", "C",02,  0,  0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0", "", "","","@!"})

DbSelectArea ("SX1")
DbSetOrder (1)
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Email()
///////////////////////

Enter       := chr(13)
cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
cEnvia    	:= 'siga@laselva.com.br'
cAssunto  	:= "Títulos de movimentações dos PDV's"
cRecebe     := GetMv('LA_PDVMAIL') + iif(len(_aErros) > 0,'adalpiaz;','') + ';'
cRecebe 	:= strtran(cRecebe,';;',';')
cRecebe 	:= strtran(cRecebe,';','@laselva.com.br;')

_aSizes := {'18','20','4','4','6','9','15'}
_aAlign := {'','','','','','RIGHT',''}
_aLabel := {'Título','Loja','Filial','Vencimento','Vencimento Real','Valor','Forma Pagamento'}

_cHtml	 	:= cError    := ""

_cHtml += '<html>'
_cHtml += '<head>'
_cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana">' + cAssunto + '</h3></font>'
_cHtml += '</head>'
_cHtml += '<body bgcolor = white text=black  >'
_cHtml += '<hr width=100% noshade>' + ENTER

If len(_aTitulos) > 0
	_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Títulos gerados: </font></b>'+ ENTER+ENTER
	
	_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
	_cHtml += '	<TR VALIGN=TOP>                  '
	
	For _nI := 1 To Len(_aSizes)
		_cHtml += '		<TD WIDTH=' + _aSizes[_nI] + '%>'
		_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nI]),'<h3 align = '+ _aAlign[_nI] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nI] + '<B></P></font> '
		_cHtml += '		</TD>'
	Next
	
	For _nI := 1 To Len(_aTitulos)
		
		_cHtml += '	<TR VALIGN=TOP>'
		
		For _nJ := 1 to len(_aTitulos[_nI])
			_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
			_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aTitulos[_nI,_nJ]+'</P></font>'
			_cHtml += '		</TD>'
		Next
	Next
	_cHtml += '	</TR>'
	
	_cHtml += '</TABLE>'
	_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
	
EndIf

If len(_aErros) > 0
	cRecebe
	_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Movimentos com erro na geração de títulos: </font></b>'+ ENTER+ENTER
	
	_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
	_cHtml += '	<TR VALIGN=TOP>'
	
	For _nI := 1 To Len(_aSizes)
		_cHtml += '		<TD WIDTH=' + _aSizes[_nI] + '%>'
		_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nI]),'<h3 align = '+ _aAlign[_nI] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nI] + '<B></P></font> '
		_cHtml += '		</TD>'
	Next
	
	For _nI := 1 To Len(_aErros)
		
		_cHtml += '	<TR VALIGN=TOP>'
		
		For _nJ := 1 to len(_aErros[_nI])
			_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
			_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aErros[_nI,_nJ]+'</P></font>  '
			_cHtml += '		</TD>'
		Next
		
	Next
	_cHtml += '	</TR>'
	
	_cHtml += '</TABLE>'
	_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
	
EndIf

_cHtml += '</P>'

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
	
	SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY _cHtml RESULT lEnviado
	
	If !lEnviado
		cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
		GET MAIL ERROR cHtml
		Conout( "ERRO SMTP EM: " + cAssunto )
		If !REC->(eof())
			RecLock('REC',.F.)
			REC->EMAIL := .T.
			MsUnLock()
		EndIf
	Else
		DISCONNECT SMTP SERVER
		Conout( cAssunto )
	Endif
	
Else
	
	Conout( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
	MsgAlert(cHtml)
	If !REC->(eof())
		RecLock('REC',.F.)
		REC->EMAIL := .T.
		MsUnLock()
	EndIf
Endif

Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraTitulos
///////////////////////

If !_lJob
	ProcRegua(_nLastRec)
EndIf

Do While !eof()
	
	_cCliente  := PDV->A1_COD
	_cLoja     := PDV->L4_FILIAL
	_cPrefixo  := 'Z' + PDV->L4_FILIAL
	_cNumero   := right(dtos(PDV->L4_DATA),6) + left(PDV->L4_ADMINIS,3)
	_cParcela  := right(PDV->L4_PDV,3)
	_cTipo     := 'PDV'
	_dVencto   := PDV->L4_DATA + PDV->AE_DIAS + 4
	_cNatureza := 'DINHEIRO'
	
	DbSelectArea('SE1')
	DbSetOrder(2)
	If !DbSeek(xFilial('SE1') + _cCliente + _cLoja + _cPrefixo + _cNumero + _cParcela + _cTipo,.f.)
		
		_cFilAnt    := cFilAnt
		cFilAnt 	:= PDV->L4_FILIAL
		lMsErroAuto := .f.
		_aAutoSE1   := {}
		aAdd(_aAutoSE1, {"E1_FILIAL"  , xFilial('SE1')             		, Nil})
		aAdd(_aAutoSE1, {"E1_PREFIXO" , _cPrefixo                  		, Nil})
		aAdd(_aAutoSE1, {"E1_NUM"     , _cNumero                   		, Nil})
		aAdd(_aAutoSE1, {"E1_PARCELA" , _cParcela                  		, Nil})
		aAdd(_aAutoSE1, {"E1_TIPO"    , _cTipo                     		, Nil})
		aAdd(_aAutoSE1, {"E1_NATUREZ" , _cNatureza                 		, Nil})
		aAdd(_aAutoSE1, {"E1_CLIENTE" , _cCliente                  		, Nil})
		aAdd(_aAutoSE1, {"E1_LOJA"    , _cLoja                     		, Nil})
		aAdd(_aAutoSE1, {"E1_EMISSAO" , PDV->L4_DATA	         		, Nil})
		aAdd(_aAutoSE1, {"E1_VENCTO"  , _dVencto         				, Nil})
		aAdd(_aAutoSE1, {"E1_VENCREA" , DataValida(_dVencto)		  	, Nil})
		aAdd(_aAutoSE1, {"E1_VALOR"   , PDV->VALOR                 		, Nil})
		
		If !_lJob
			IncProc('Lj: ' + _cLoja + ' Prf: ' + _cPrefixo + ' Nro: ' + _cNumero + ' Parc: ' + _cParcela)
		EndIf
	
		MSExecAuto({|x,y| Fina040(x,y)},_aAutoSE1,3) //3-Inclusao
		_aTexto := {_cPrefixo + ' / ' + _cNumero + ' - ' +  _cParcela , _cCliente + ' / ' + _cLoja + ' - ' + PDV->A1_NREDUZ, PDV->L4_FILIAL , dtoc(_dVencto) , dtoc(DataValida(_dVencto)) , tran(PDV->VALOR,'@E 999,999,999.99'), PDV->AE_DESC}
		cFilAnt    := _cFilAnt
		
	EndIf
	
	If lMsErroAuto
		
		If !_lJob .and. !_lAutom
			MsgAlert('Erro na criação de título','ATENÇÃO!!!')
			MostraErro()
		EndIf
		aAdd(_aErros, _aTexto)
		
	Else
		
		If PDV->L4_FILIAL >= '01' .and. PDV->L4_FILIAL <= '99'
			_cDadBanc := GetMv('LS_PDVCT01')
			_cDadCed := GetMv('LS_PDVCD01')
		ElseIf PDV->L4_FILIAL >= 'A0' .and. PDV->L4_FILIAL <= 'AZ'
			_cDadCed := GetMv('LS_PDVCDA0')
			_cDadBanc := GetMv('LS_PDVCTA0')
		ElseIf PDV->L4_FILIAL >= 'C0' .and. PDV->L4_FILIAL <= 'EZ'
			_cDadCed := GetMv('LS_PDVCDC0')
			_cDadBanc := GetMv('LS_PDVCTC0')
		ElseIf PDV->L4_FILIAL >= 'R0' .and. PDV->L4_FILIAL <= 'RZ'
			_cDadCed := GetMv('LS_PDVCDR0')
			_cDadBanc := GetMv('LS_PDVCTR0')
		ElseIf PDV->L4_FILIAL >= 'T0' .and. PDV->L4_FILIAL <= 'TZ'
			_cDadCed := GetMv('LS_PDVCDT0')
			_cDadBanc := GetMv('LS_PDVCTT0')
		ElseIf PDV->L4_FILIAL >= 'G0' .and. PDV->L4_FILIAL <= 'GZ'
			_cDadCed := GetMv('LS_PDVCDG0')
			_cDadBanc := GetMv('LS_PDVCTG0')
		Else
			_cDadBanc := GetMv('LS_PDVCTBH')
			_cDadCed := GetMv('LS_PDVCDBH')
		EndIf
		
		_nPosic := aScan(_aNumBor, {|x| x[1] == right(_cDadCed,2) })
		If _nPosic == 0
			_cNumBor := Soma1(GetMV("MV_NUMBORR"),6)
			_cNumBor := Replicate("0",6-Len(Alltrim(_cNumBor)))+Alltrim(_cNumBor)
			Do While !MayIUseCode("SE1"+xFilial("SE1")+_cNumBor)  //verifica se esta na memoria, sendo usado
				_cNumBor := Soma1(_cNumBor)
			EndDo
			PutMV('MV_NUMBORR',_cNumBor)
			aAdd(_aNumBor,{right(_cDadCed,2),_cNumBor, left(_cDadBanc,3), substr(_cDadBanc,4,5), substr(_cDadBanc,9,15)})
		Else
			_cNumBor := _aNumBor[_nPosic,2]
		EndIf

		RecLock('SE1',.f.)
		SE1->E1_PORTADO := left(_cDadBanc,3)
		SE1->E1_AGEDEP  := substr(_cDadBanc,4,5)
		SE1->E1_CONTA   := substr(_cDadBanc,9,15)
		SE1->E1_BCOCLI	:= 'PDV'
		SE1->E1_MATRIZ	:= right(_cDadCed,2)
		SE1->E1_NUMBOR	:= _cNumBor
		SE1->E1_SITUACA := '1'
		MsUnLock()
		
		U_LS_GeraCodBar()
		
		RecLock("SEA",.T.)
		SEA->EA_FILIAL  := right(_cDadCed,2)
		SEA->EA_NUMBOR  := _cNumBor
		SEA->EA_DATABOR := dDataBase
		SEA->EA_PORTADO := SE1->E1_PORTADO
		SEA->EA_AGEDEP  := SE1->E1_AGEDEP
		SEA->EA_NUMCON  := SE1->E1_CONTA
		SEA->EA_SITUACA := '1'
		SEA->EA_NUM 	:= SE1->E1_NUM
		SEA->EA_PARCELA := SE1->E1_PARCELA
		SEA->EA_PREFIXO := SE1->E1_PREFIXO
		SEA->EA_TIPO	:= SE1->E1_TIPO
		SEA->EA_CART	:= "R"
		SEA->EA_SITUANT := '0'
		SEA->EA_FILORIG := SE1->E1_MSFIL
		MsUnlock()
		
		aAdd(_aTitulos, _aTexto)
	Endif
	
	DbSelectArea('PDV')
	DbSkip()
	
EndDo

Return()