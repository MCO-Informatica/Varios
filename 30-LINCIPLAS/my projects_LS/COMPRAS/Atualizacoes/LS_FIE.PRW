#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

// Programa: LS_FIE
// Autor   : Alexandre Dalpiaz
// Data    : 01/06/2012
// Função  : PEDIDOS DE COMPRAS X ADIANTAMENTOS
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_FIE()
//////////////////////

Local 	aCampos 	:= {}
Private cString 	:= "FIE"
/*
DbSelectArea('SX3')
DbSetOrder(1)
DbGoTop()
DbSeek('FIE01',.F.)
//Aadd(aCampos,{ 'FIE_OK', '', '', '' } )

Do While SX3->X3_ARQUIVO == 'FIE'
	If !(alltrim(SX3->X3_CAMPO) $ 'FIE_OK')
		Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ) , SX3->X3_PICTURE } )
	Endif
	DbSkip()
EndDo
*/
aLegenda   := {}
aCores     := {}

aAdd(aLegenda, {'BR_VERMELHO'	,'Pedido de compras Bloqueado'		, '3'	})
aAdd(aLegenda, {'BR_VERDE'	  	,'Liberado Financeiro'				, '3'	})
aAdd(aLegenda, {'BR_BRANCO'		,'PA incluido / aguardando NF' 		, '3'	})
aAdd(aLegenda, {'BR_PRETO'		,'Nota Fiscal atrazada'         	, '3'	})
aAdd(aLegenda, {'BR_AMARELO'	,'Nota Fiscal incluida'         	, '3'	})

aAdd(aCores,{ "FIE_SITUA == 'B'" 	, 'BR_VERMELHO'		}) 	// Pedido de compras Bloqueado
aAdd(aCores,{ "FIE_SITUA == 'F' .and. empty(FIE_NUM)" , 'BR_VERDE'		}) // aberto
aAdd(aCores,{ "FIE_SITUA == 'F' .and. empty(FIE_NOTA) .and. FIE_PRVENT < dDataBase " , 'BR_BRANCO'    	}) // Aguardando NF
aAdd(aCores,{ "FIE_SITUA == 'F' .and. empty(FIE_NOTA) .and. FIE_PRVENT >= dDataBase " , 'BR_PRETO'    	}) // Nota Fiscal Atrazada
aAdd(aCores,{ "!empty(FIE_NOTA)" 	, 'BR_AMARELO'    	}) 	// Nota Fiscal Incluída

dbSelectArea("FIE")
dbSetOrder(1)

cMarca    := GetMark()
linverte  := .f.
aRotina    := {}
cCadastro  := "Pedidos de Compras X Adiantamentos"
nOpca := 0

aAdd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
aAdd(aRotina,{"Visualizar"  		,"AxVisual" 		,0,2 })
aAdd(aRotina,{"Incluir"  			,"U_FIEInc()"		,0,3 })
aAdd(aRotina,{"Alterar"  			,"U_FIEAlt()" 		,0,4 })
aAdd(aRotina,{"Exclui"  			,"U_FIEDel()" 		,0,5 })

_aRotina := {}
aAdd(_aRotina,{"Nota Fisal" 		,"U_FIENFE()" 		,0,2 })
aAdd(_aRotina,{"Pedido de Compra" 	,"U_FIEPC()" 		,0,2 })
aAdd(_aRotina,{"Título"				,"U_FIEPA()" 		,0,2 })
aAdd(aRotina,{"Consultas",aClone(_aRotina),0,2})

//aAdd(aRotina,{"Aglutina"   			,"U_FIEAgl()" 		,0,3 })
aAdd(aRotina,{"Gera PA"    			,"U_FIEAdt()" 		,0,3 })
aAdd(aRotina,{"Exclui PA"   		,"U_FIEExc()" 		,0,3 })
//aAdd(aRotina,{"Compensação" 		,"U_FIECmp()" 		,0,3 })
aAdd(aRotina,{"Imprime" 			,"U_FIEImp()" 		,0,3 })
aAdd(aRotina,{"Legenda" 			,"U_FIELeg()" 		,0,3 })

DbSelectArea('FIE')
mBrowse( 7, 4,20,74,'FIE',,,,,,aCores)
//Markbrow("FIE","FIE_OK",,/*aCampos*/,/*@linverte*/,/*@cMarca*/ , /*[cCtrlM]*/, /*[uPar8]*/, /*[cExpIni*/, /*[cExpFim*/, /*[cAval*/, /*[bParBloco]*/, /*[cExprFilTop*/, /*[uPar14*/, aCores, /*[uPar16]*/, /*[uPar17*/ )
Return                  

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Visualiza NFe
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIENFE()
//////////////////////
DbSelectArea('SF1')
DbSetOrder(1)
If DbSeek(FIE->FIE_FILIAL + FIE->FIE_NOTA + FIE->FIE_SERIE + FIE->FIE_FORNEC + FIE->FIE_LOJA,.F.)
	_cFilAnt := cFilAnt
	cFilAnt  := FIE->FIE_FILIAL
	A103NFiscal('SF1',,2)
	cFilAnt := _cFilAnt
Else
	MsgBox('Nota fiscal de entrada não encontrada','ATENÇÃO!!!','ALERT')
EndIf

DbSelectArea('FIE')

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Ponto de entrada na inclusão de títulos a pagar FINA050 - se estiver sendo executada a partir de uma rotina de pedido de compras, não permite inclusão de Pagamento adiantado.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FA050UPD()
//////////////////////
Local _lRet := IsInCallStack( "MATA120" )

If _lRet
	MsgBox('O título de pagamento adiantado deve ser incluído pelo financeiro','ATENÇÃO!!!','ALERT')
	_lRet := .F.
ELSE
	_lRet := .T.
EndIf

Return(_lRet)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Legenda
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIELeg()
//////////////////////

BrwLegenda("Pagamento Adiantados x Pedidos de Compras" , 'Legenda' , aLegenda)

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIEInc()
//////////////////////
nOpca := AxInclui("FIE",FIE->(Recno()), 3)
Return(.t.)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIEAlt()
//////////////////////
nOpca := AxAltera("FIE",FIE->(Recno()), 4)
Return(.t.)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIEDel()
//////////////////////
nOpca := AxDeleta("FIE",FIE->(Recno()), 5)
Return(.t.)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIEAGL()
//////////////////////
//cMarca    := GetMark()

_cQuery := "UPDATE " + RetSqlName('FIE')
_cQuery += _cEnter + " SET FIE_OK = ''"
TcSqlExec(_cQuery)

_cQuery := "UPDATE " + RetSqlName('FIE')
_cQuery += _cEnter + " SET FIE_OK = '" + cMarca + "'"
_cQuery += _cEnter + " WHERE FIE_FORNEC = '"  	+ FIE->FIE_FORNEC 		+ "'"
_cQuery += _cEnter + " AND FIE_LOJA = '"  		+ FIE->FIE_LOJA 		+ "'"
_cQuery += _cEnter + " AND FIE_PREVEN = '"  	+ dtos(FIE->FIE_PREVEN) + "'"
_cQuery += _cEnter + " AND FIE_EMPR = '" 		+ FIE->FIE_EMPR 		+ "'"
_cQuery += _cEnter + " AND FIE_NUMADT = ''"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
TcSqlExec(_cQuery)

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIECMP()
//////////////////////

If empty(FIE->FIE_SLDADT)
	MsgBox('Saldo do adiantamento está zerado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf
If empty(FIE->FIE_SLDDOC)
	MsgBox('Saldo da nota fiscal está zerado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf
If empty(FIE->FIE_NUMADT)
	MsgBox('Pedido de Compras sem adiantamento lançado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf
If empty(FIE->FIE_DOC)
	MsgBox('Pedido de Compras em aberto. Lançar nota fiscal.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSelectArea('SF1')
If DbSeek(FIE->FIE_FILORI + FIE->FIE_DOC + FIE->FIE_SERIE + FIE->FIE_FORNEC + FIE->FIE_LOJA,.f.)
	MsgBox('Nota fiscal não localizada.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSelectArea('SE2')
DbSetOrder(6)
If !DbSeek(xFilial('SE2') + FIE->FIE_FORNEC + FIE->FIE_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC + FIE->FIE_PARADT,.f.)
	MsgBox('Título não localizado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSetOrder(1)
If !DbSeek(xFilial('SE2') + FIE->FIE_PRFADT + FIE->FIE_NUMADT + FIE->FIE_PARADT + 'PA ' + FIE->FIE_FORNEC + FIE->FIE_LOJA,.f.)
	MsgBox('PA não localizado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSeek(xFilial('SE2') + FIE->FIE_PRFADT + FIE->FIE_NUMADT + FIE->FIE_PARADT + 'PA ' + FIE->FIE_FORNEC + FIE->FIE_LOJA,.f.)
RecLock('SE2',.f.)
SE2->E2_SALDO := SE2->E2_SALDO - min(FIE->FIE_VLRDOC, SE2->E2_SALDO)
MsUnLock()

DbSetOrder(6)
DbSeek(xFilial('SE2') + FIE->FIE_FORNEC + FIE->FIE_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC + FIE->FIE_PARADT,.f.)
RecLock('SE2',.f.)
SE2->E2_SALDO := SE2->E2_SALDO - min(FIE->FIE_VLRDOC, SE2->E2_SALDO)
MsUnLock()

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// geração do adiantamento
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIEADT()
//////////////////////

If FIE->FIE_SITUA == 'B'

	MsgBox('Pedido de Compras bloqueado, não pode gerar PA!','ATENÇÃO!!!','ALERT')

ElseIf FIE->FIE_SITUA == 'L' .and. !empty(FIE->FIE_NUM)

	MsgBox('Título de PA já incluído!','ATENÇÃO!!!','ALERT')

Else
	
	_cPrefixo 	:= 'PC '
	_cNumAdt	:= FIE->FIE_FILIAL + 'P' + FIE->FIE_PEDIDO
	_cParcela   := '   ' 
	_cBanco     := '   '
	_cAgencia   := '     '
	_cConta     := '          '
	_cNatur     := _cNatureza  := '          '
	_nVlrAdt    := FIE->FIE_VALOR
	_nOk := 0
	DEFINE MSDIALOG oDlg TITLE 'Pedidos de Compras X Adiantamento' FROM C(0),C(0) TO C(200),C(350) PIXEL
	
	@ C(005),C(005) Say "Prefixo" 		Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(015),C(005) Say "Número"	 	Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(025),C(005) Say "Parcela"  		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(040),C(005) Say "Banco"   		Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(050),C(005) Say "Agência"	 	Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(060),C(005) Say "Conta"    		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(040),C(090) Say "Natureza"		Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(060),C(090) Say "Valor"  	 	Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	
	@ C(005),C(025) Get _cPrefixo		Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(015),C(025) Get _cNumAdt		Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(025),C(025) Get _cParcela		Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	
	@ C(040),C(025) MsGet _cBanco  		Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg F3 'SA6A'
	@ C(050),C(025) Get _cAgencia		Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(060),C(025) Get _cConta  		Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	
	@ C(040),C(110) MsGet _cNatureza	Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDlg F3 'SED'
	@ C(050),C(110) Get _cNatur    		Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(060),C(110) Get _nVlrAdt 		Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg picture '@E 999,999.99'
	
	@ C(080),C(010) Button "Ok" 		Size C(030),C(012) PIXEL OF oDlg ACTION(_nOk := 1,oDlg:End())
	@ C(080),C(060) Button "Cancelar" 	Size C(030),C(012) PIXEL OF oDlg ACTION(_nOk := 3,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED valid _nOk > 0
	
	If _nOK == 1
		MsAguarde({|| GeraPA()},'Aguarde... gerando PA!')
	EndIf
	
EndIf

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraPA()
////////////////////////

_cFilAnt := cFilAnt
cFilAnt  := U_LS_EMPRESA(FIE->FIE_FILIAL)

_aExecAuto := {}
aAdd(_aExecAuto,{"E2_PREFIXO"   , _cPrefixo			, Nil})
aAdd(_aExecAuto,{"E2_NUM"       , _cNumAdt			, Nil})
aAdd(_aExecAuto,{"E2_PARCELA"   , _cParcela			, Nil})
aAdd(_aExecAuto,{"E2_TIPO"      , 'PA'				, Nil})
aAdd(_aExecAuto,{"E2_NATUREZ"   , _cNatureza		, Nil})
aAdd(_aExecAuto,{"E2_FORNECE"   , FIE->FIE_FORNEC	, Nil})
aAdd(_aExecAuto,{"E2_LOJA"      , FIE->FIE_LOJA		, Nil})
aAdd(_aExecAuto,{"E2_EMISSAO"   , dDataBase			, NIL})
aAdd(_aExecAuto,{"E2_VENCTO"    , dDataBase			, NIL})
aAdd(_aExecAuto,{"E2_VENCREA"   , dDataBase			, NIL})
aAdd(_aExecAuto,{"E2_VALOR"     , _nVlrAdt			, Nil})
aAdd(_aExecAuto,{"E2_BCOTDDC"	, _cBanco			, NIL})
aAdd(_aExecAuto,{"E2_AGETDDC"	, _cAgencia			, NIL})
aAdd(_aExecAuto,{"E2_CNTTDDC"	, _cConta			, NIL})
aAdd(_aExecAuto,{"E2_FILORIG"	, FIE->FI2_FILIAL	, NIL})
aAdd(_aExecAuto,{"E2_MSFIL"  	, FIE->FI2_FILIAL	, NIL})
aAdd(_aExecAuto,{"E2_MATRIZ" 	, cFilAnt        	, NIL})
aAdd(_aExecAuto,{"AUTBANCO"		, _cBanco			, NIL})
aAdd(_aExecAuto,{"AUTAGENCIA"	, _cAgencia			, NIL})
aAdd(_aExecAuto,{"AUTCONTA"		, _cConta			, NIL})

lMsErroAuto := .F.
MsExecAuto({|x,y,z| FINA050(x,y,z)},_aExecAuto,,3) //Inclusao
cFilAnt := _cFilAnt

If lMsErroAuto
	MostraErro()
Else
	_cQuery := "UPDATE " + RetSqlName('FIE')
	_cQuery += _cEnter + " SET FIE_NUM = FIE_FILIAL + 'P' + FIE_PEDIDO, FIE_PREFIX = 'PC'
	_cQuery += _cEnter + " WHERE FIE_OK = '" + cMarca + "'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND R_E_C_N_O_ = " + STR(_FIE->R_E_C_N_O_)
	TcSqlExec(_cQuery)
	
	MsgBox('Pagamento adiantado gerado com sucesso','ATENÇÃO!!!','INFO')
	
	
EndIf
                   
cFilAnt := _cFilAnt

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIEExc()
//////////////////////

SE2->(DbSetOrder(1))
If SE2->(DbSeek(xFilial('SE2') + FIE->FIE_PRFADT + FIE->FIE_NUMADT + FIE->FIE_PARADT + 'PA',.F.))
	
	If SE2->E2_SALDO == 0
		MsgBox('Título de adiantamento já foi compensado, não pode ser excluido','ATENÇÃO!!!','ALERT')
		Return()
	EndIf
	
	_nOk := 0
	DEFINE MSDIALOG oDlg TITLE 'Pedidos de Compras X Adiantamento' FROM C(0),C(0) TO C(200),C(350) PIXEL
	
	@ C(005),C(005) Say "Prefixo" 		Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(015),C(005) Say "Número"	 	Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(025),C(005) Say "Parcela"  		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(040),C(005) Say "Banco"   		Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(050),C(005) Say "Agência"	 	Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(060),C(005) Say "Conta"    		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(040),C(090) Say "Natureza"		Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(060),C(090) Say "Valor"  	 	Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	
	@ C(005),C(025) Get _FIE->FIE_PREFIX		Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(015),C(025) Get _FIE->FIE_NUM   		Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(025),C(025) Get _FIE->FIE_PARCEL		Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	
	@ C(040),C(025) MsGet SE2->E2_BCOTDDC 	Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(050),C(025) Get SE2->E2_AGETDDC		Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(060),C(025) Get SE2->E2_CNTTDDC		Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	
	_cNatur := Posicione('SED',1,xFilial('SED') + SE2->E2_NATUREZ,'ED_DESCRIC')
	
	@ C(040),C(110) MsGet SE2->E2_NATUREZ 	Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(050),C(110) Get _cNatur    			Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(060),C(110) Get SE2->E2_VALOR		Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg picture '@E 999,999.99' when .f.
	
	@ C(080),C(010) Button "Ok" 		Size C(030),C(012) PIXEL OF oDlg ACTION(_nOk := 1,oDlg:End())
	@ C(080),C(060) Button "Cancelar" 	Size C(030),C(012) PIXEL OF oDlg ACTION(_nOk := 3,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED valid _nOk > 0
	
	If _nOK == 1
		_aExecAuto := {}
		aAdd(_aExecAuto,{"E2_PREFIXO"   , SE2->E2_PREFIXO	, Nil})
		aAdd(_aExecAuto,{"E2_NUM"       , SE2->E2_NUM    	, Nil})
		aAdd(_aExecAuto,{"E2_PARCELA"   , SE2->E2_PARCELA	, Nil})
		aAdd(_aExecAuto,{"E2_TIPO"      , SE2->E2_TIPO		, Nil})
		aAdd(_aExecAuto,{"E2_FORNECE"   , SE2->E2_FORNECE	, Nil})
		aAdd(_aExecAuto,{"E2_LOJA"      , SE2->E2_LOJA 		, Nil})
		
		lMsErroAuto := .F.
		_cFilAnt := cFilAnt
		_cFilAnt := FIE->FIE_EMPR
		MsExecAuto({|x,y,z| FINA050(x,y,z)},_aExecAuto,,5) //EXCLUSAO
		cFilAnt := _cFilAnt
		
		If lMsErroAuto
			MostraErro()
		Else
			MsgBox('Pagamento adiantado excluido com sucesso','ATENÇÃO!!!','INFO')
		EndIf
		
	EndIf
	
Else
	
	MsgBox('Título de adiantamento não localizado.' + _cEnter + 'As informações referentes aos PAs serão apagadas.','ATENÇÃO!!!','ALERT')
	_nOk := 1
	
EndIf

If _nOk == 1
	
	_cQuery := "UPDATE " + RetSqlName('SE5')
	_cQuery += _cEnter + " SET D_E_L_E_T_ = '*'"
	_cQuery += _cEnter + " WHERE E5_FILIAL = '" + FIE->FIE_EMPR + "'"
	_cQuery += _cEnter + " AND (E5_KEY = '" + 'PC ' + FIE->FIE_NUMADT + FIE->FIE_PARADT + 'PA ' + alltrim(FIE->FIE_NUMADT) + "'"
	_cQuery += _cEnter + " OR E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_FORNECE + E5_LOJA = '" + FIE->FIE_EMPR + 'PC ' + FIE->FIE_NUMADT + FIE->FIE_PARADT + 'PA ' + alltrim(FIE->FIE_NUMADT) + "')"
	_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('FIE')
	_cQuery += _cEnter + " SET FIE_NUMADT = '', FIE_PRFADT = '', FIE_PARADT = '', FIE_DTADT = '', FIE_VLRADT = 0"
	_cQuery += _cEnter + " WHERE FIE_NUMADT = '" + FIE->FIE_NUMADT  	 + "'"
	_cQuery += _cEnter + " AND FIE_PARADT = '" 	 + FIE->FIE_PARADT 		 + "'"
	_cQuery += _cEnter + " AND FIE_DTADT = '" 	 + dtos(FIE->FIE_DTADT)  + "'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
EndIf

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_VLFIE()
////////////////////////
_lRet := SC7->(DbSeek(M->FIE_FILORI + alltrim(M->FIE_PEDIDO),.f.))

If !_lRet .and. empty(M->FIE_PEDIDO)
	MsgBox('Filial não possui pedido de compra cadastrado','ATENÇÃO!!!','ALERT')
ElseIf !_lRet  .and. !empty(M->FIE_PEDIDO)
	MsgBox('Pedido de compra não localizado na filial informada','ATENÇÃO!!!','ALERT')
ElseIf !_lRet
	MsgBox('Pedido de compra não localizado na filial informada','ATENÇÃO!!!','ALERT')
ElseIf SC7->C7_CONAPRO == 'B' .and. !empty(M->FIE_PEDIDO)
	MsgBox('Pedido de compra encontra-se BLOQUEADO','ATENÇÃO!!!','ALERT')
	_lRet := .f.
ElseIf SC7->C7_ENCER == 'E' .and. !empty(M->FIE_PEDIDO)
	MsgBox('Pedido de compra encontra-se ENCERRADO','ATENÇÃO!!!','ALERT')
	_lRet := .f.
Else
	
	If M->FIE_FILORI <= '99'
		M->FIE_EMPR := '01'
	ElseIf M->FIE_FILORI >= 'A0' .and. M->FIE_FILORI <= 'AZ'
		M->FIE_EMPR := 'A0'
	ElseIf (M->FIE_FILORI >= 'C0' .and. M->FIE_FILORI <= 'EZ') .or. M->FIE_FILORI == 'GH'
		M->FIE_EMPR := 'C0'
	ElseIf M->FIE_FILORI >= 'G0' .and. M->FIE_FILORI <= 'GZ'
		M->FIE_EMPR := 'G0'
	ElseIf M->FIE_FILORI >= 'R0' .and. M->FIE_FILORI <= 'RZ'
		M->FIE_EMPR := 'R0'
	ElseIf M->FIE_FILORI >= 'T0' .and. M->FIE_FILORI <= 'TZ'
		M->FIE_EMPR := 'T0'
	ElseIf M->FIE_FILORI == 'BH'
		M->FIE_EMPR := 'BH'
	EndIf
	
	If !empty(M->FIE_PEDIDO)
		
		If FIE->(DbSeek(xFilial('FIE') + M->FIE_EMPR + M->FIE_FILORI + SC7->C7_FORNECE + SC7->C7_LOJA + dtos(SC7->C7_EMISSAO) + M->FIE_PEDIDO,.f.))
			MsgBox('Pedido de compra já incluido para adiantamento','ATENÇÃO!!!','ALERT')
			_lRet := .f.
		Else
			_cQuery := "SELECT SUM(C7_TOTAL+C7_VALIPI+C7_ICMSRET) TOTALPC"
			_cQuery += _cEnter + " FROM " + RetSqlName('SC7') + " SC7 (NOLOCK)"
			_cQuery += _cEnter + " WHERE C7_FILIAL = '" + M->FIE_FILORI + "'"
			_cQuery += _cEnter + " AND C7_NUM = '" + M->FIE_PEDIDO + "'"
			_cQuery += _cEnter + " AND SC7.D_E_L_E_T_ = ''"
			DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRBSC7', .F., .T.)
			
			M->FIE_ENTREG := SC7->C7_DATPRF
			M->FIE_DATAPC := SC7->C7_EMISSAO
			M->FIE_FORNEC := SC7->C7_FORNECE
			M->FIE_LOJA   := SC7->C7_LOJA
			M->FIE_PREVEN := SC7->C7_DATPRF
			M->FIE_VLRPC  := TRBSC7->TOTALPC
			DbCloseArea()
			
		EndIf
		
	EndIf
	
EndIf

Return(_lRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FIEImp()
//////////////////////

cDesc1        := "Este programa tem como objetivo gerar relatorio/email "
cDesc2        := "relacionando os pedidos de compra para pagamento adiantado"
cDesc3        := ""
cTitulo       := "Pedidos de compras x adiantamentos"
nLin          := 80

Private aOrd        := {}
Private aReturn     := { "Zebrado",1,"Administracao", 2, 2, 1, '', 1}
Private cString     := 'FIE'
Private cNomeprog   := 'LS_FIEREL'
Private lEnd        := .F.
Private lAbortPrint := .F.
Private m_pag       := 01
Private nLimite     := 220
Private nTipo       := 18
Private nLastKey    := 0
Private Tamanho     := 'M'
Private cPerg 		:= wnrel       := 'LS_FIEREL '

ValidPerg()
Pergunte(cPerg,.T.)

wnrel := SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

fErase(__RelDir + wnrel + '.##r')
SetDefault( aReturn, cString )

If nLastKey == 27
	RestArea( aArea )
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|lEnd| RunReport( @lEnd) }, cTitulo)


Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport( lEnd,_lEmail)
////////////////////////////////////////

_cQuery := "SELECT FIE_EMPR,FIE_DATAPC,FIE_FORNEC, FIE_LOJA, FIE_FILORI, FIE_PEDIDO, FIE_ENTREG, SUM(C7_TOTAL) TOTAL,  SUM(C7_VALIPI) IPI, SUM(C7_ICMSRET) ICMSRET, "
_cQuery += _cEnter + " A2_NOME, A2_TEL, A2_BANCO, A2_AGENCIA, A2_NUMCON, A1_NOME, A1_NREDUZ "
_cQuery += _cEnter + " FROM " + RetSqlName('FIE') + " FIE (NOLOCK)"
_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"

_cQuery += _cEnter + " ON C7_FILIAL = FIE_FILORI"
_cQuery += _cEnter + " AND C7_NUM = FIE_PEDIDO"
_cQuery += _cEnter + " AND SC7.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SA2') + " SA2"
_cQuery += _cEnter + " ON A2_COD = C7_FORNECE"
_cQuery += _cEnter + " AND A2_LOJA = C7_LOJA"
_cQuery += _cEnter + " AND SA2.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SA1') + " SA1"
_cQuery += _cEnter + " ON A1_COD < '000009'"
_cQuery += _cEnter + " AND A1_LOJA = C7_FILIAL"
_cQuery += _cEnter + " AND SA1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND A1_MSBLQL = '2'"

_cQuery += _cEnter + " WHERE FIE_DATAPC BETWEEN  '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += _cEnter + " AND FIE_NUMADT = ''"
_cQuery += _cEnter + " AND FIE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " GROUP BY FIE_EMPR,FIE_DATAPC,FIE_FORNEC, FIE_LOJA, FIE_FILORI, FIE_PEDIDO,A2_NOME, A2_TEL, A2_BANCO, A2_AGENCIA, A2_NUMCON,FIE_ENTREG, A1_NOME, A1_NREDUZ "
_cQuery += _cEnter + " ORDER BY FIE_EMPR,FIE_DATAPC,FIE_FORNEC, FIE_LOJA, FIE_FILORI, FIE_PEDIDO"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_FIE', .F., .T.)
TcSetField('_FIE','FIE_ENTREG','D',0)
TcSetField('_FIE','FIE_DATAPC','D',0)

count to _nLastRec
DbGoTop()
SetRegua( _nLastRec )

cCabec1 := 'Empresa Fornecedor                                           Telefone'
//          1234567 123456-02 - 1234567890123456789012345678901234567890 12345678901235
cCabec2 := 'Loja                      Pedido     Emissao    Entrega        Total    ICMS Ret         IPI   Total+Imp'
//          12  12345678901234567890  123456  11/11/1111  11/11/1111  123,123,12  123,123,12  123,123,12  123,123,12

_nTotPed := 0
_nTotICM := 0
_nTotIPI := 0
_nTotGer := 0
Do While !eof()
	
	_nETotPed := 0
	_nETotICM := 0
	_nETotIPI := 0
	_nETotGer := 0
	_cEmpresa := _FIE->FIE_EMPR
	Do While !eof() .and. _cEmpresa == _FIE->FIE_EMPR
		
		If nLin > 55
			nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
		EndIf
		
		_cLinha := _FIE->A1_NOME + ' ' + _FIE->FIE_FORNEC  + '/' + _FIE->FIE_LOJA + ' - ' + _FIE->A2_NOME + ' - ' + _FIE->A2_TEL
		@ ++nLin, 000 PSAY _cLinha
		++nLin
		
		_nSTotPed := 0
		_nSTotICM := 0
		_nSTotIPI := 0
		_nSTotGer := 0
		_cChave   := _FIE->FIE_EMPR + dtos(_FIE->FIE_DATAPC) + _FIE->FIE_FORNEC + _FIE->FIE_LOJA
		Do While !eof() .and. _cChave == _FIE->FIE_EMPR + dtos(_FIE->FIE_DATAPC) + _FIE->FIE_FORNEC + _FIE->FIE_LOJA
			
			If nLin > 55
				nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
			EndIf
			
			If lAbortPrint .Or. lEnd
				@ 000,000 PSay "***CANCELADO PELO OPERADOR!"
				Exit
			EndIf
			
			_nTotal := _FIE->TOTAL + _FIE->ICMSRET + _FIE->IPI
			
			_cLinha := _FIE->FIE_FILORI + '  ' + _FIE->A1_NREDUZ + '  ' + _FIE->FIE_PEDIDO + '  ' + dtoc(_FIE->FIE_DATAPC) + '  ' + dtoc(_FIE->FIE_ENTREG) + '  ' + tran(_FIE->TOTAL,'@E 999,999.99') + '  ' + tran(_FIE->ICMSRET,'@E 999,999.99') + '  ' + tran(_FIE->IPI,'@E 999,999.99') + '  ' + tran(_nTotal,'@E 999,999.99')
			
			@ ++nLin, 000 PSAY _cLinha
			
			_nTotPed += _FIE->TOTAL
			_nTotICM += _FIE->ICMSRET
			_nTotIPI += _FIE->IPI
			_nTotGer += _nTotal
			
			_nSTotPed += _FIE->TOTAL
			_nSTotICM += _FIE->ICMSRET
			_nSTotIPI += _FIE->IPI
			_nSTotGer += _nTotal
			
			_nETotPed += _FIE->TOTAL
			_nETotICM += _FIE->ICMSRET
			_nETotIPI += _FIE->IPI
			_nETotGer += _nTotal
			
			DbSkip()
			IncRegua()
			
		EndDo
		++nLin
		_cLinha := 'Total do Fornecedor: ' + space(17) + tran(_nTotPed,'@E 999,999.99') + '  ' + tran(_nTotICM,'@E 999,999.99') + '  ' + tran(_nTotIPI,'@E 999,999.99') + '  ' + tran(_nTotGer,'@E 999,999.99')
		@ ++nLin, 020 PSAY _cLinha
		@ ++nLin, 000 PSAY __PrtThinLine()
		
	EndDo
	++nLin
	_cLinha := 'Total da Empresa: ' + space(30) + tran(_nETotPed,'@E 999,999.99') + '  ' + tran(_nETotICM,'@E 999,999.99') + '  ' + tran(_nETotIPI,'@E 999,999.99') + '  ' + tran(_nETotGer,'@E 999,999.99')
	@ ++nLin, 010 PSAY _cLinha
	@ ++nLin, 000 PSAY __PrtThinLine()
	
EndDo

++nLin
_cLinha := 'Total geral: ' + space(45) + tran(_nTotPed,'@E 999,999.99') + '  ' + tran(_nTotICM,'@E 999,999.99') + '  ' + tran(_nTotIPI,'@E 999,999.99') + '  ' + tran(_nTotGer,'@E 999,999.99')
@ ++nLin, 000 PSAY __PrtThinLine()
@ ++nLin, 000 PSAY _cLinha
@ ++nLin, 000 PSAY __PrtThinLine()

If aReturn[5]==1
	OurSpool(wnrel)
	MS_FLUSH()
Endif

DbCloseArea()

Return()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Emissão de                    ?","","", "mv_ch1", "D", 08 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "02", "Emissão até                   ?","","", "mv_ch2", "D", 08 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "03", "Entrega de                    ?","","", "mv_ch3", "D", 08 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "04", "Entrega até                   ?","","", "mv_ch4", "D", 08 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

DbSelectArea("SX1")
DbSetOrder(1)

For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i, 2]))
	For j := 1 to (FCount())
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j, aPerg[i, j])
		Endif
	Next
	MsUnlock()
Next

RestArea(_aAlias)

Return
