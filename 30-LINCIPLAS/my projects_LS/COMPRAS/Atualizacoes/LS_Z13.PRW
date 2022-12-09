#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

// Programa: LS_Z13
// Autor   : Alexandre Dalpiaz
// Data    : 01/06/2012
// Função  : PEDIDOS DE COMPRAS X ADIANTAMENTOS
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Z13()
//////////////////////

Local 	aCampos 	:= {}
Private cString 	:= "Z13"

DbSelectArea('SX3')
DbSetOrder(1)
DbGoTop()
DbSeek('Z1301',.F.)
Aadd(aCampos,{ 'Z13_OK', '', '', '' } )

Do While SX3->X3_ARQUIVO == 'Z13'
	If !(alltrim(SX3->X3_CAMPO) $ 'Z13_OK/Z13_FILIAL')
		Aadd(aCampos,{ TRIM( SX3->X3_CAMPO ), SX3->X3_TITULO, TRIM( SX3->X3_TITULO ) , SX3->X3_PICTURE } )
	Endif
	DbSkip()
EndDo

dbSelectArea("Z13")
dbSetOrder(1)

cMarca    := GetMark()
linverte  := .f.
aRotina    := {}
cCadastro  := "Pedidos de Compras X Adiantamentos"
aLegenda   := {}
aCores     := {}
nOpca := 0

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"AxVisual" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"U_Z13Inc()"		,0,3 })
Aadd(aRotina,{"Alterar"  			,"U_Z13Alt()" 		,0,4 })
Aadd(aRotina,{"Exclui"  			,"U_Z13Del()" 		,0,5 })
Aadd(aRotina,{"Aglutina"   			,"U_Z13Agl()" 		,0,3 })
Aadd(aRotina,{"Gera PA"    			,"U_Z13Adt()" 		,0,3 })
Aadd(aRotina,{"Exclui PA"   		,"U_Z13Exc()" 		,0,3 })
Aadd(aRotina,{"Compensação" 		,"U_Z13Cmp()" 		,0,3 })
Aadd(aRotina,{"Imprime" 			,"U_Z13Imp()" 		,0,3 })

DbSelectArea('Z13')
Markbrow("Z13","Z13_OK",,aCampos,@linverte,@cMarca)
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z13Inc()
//////////////////////
nOpca := AxInclui("Z13",Z13->(Recno()), 3)
Return(.t.)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z13Alt()
//////////////////////
nOpca := AxAltera("Z13",Z13->(Recno()), 4)
Return(.t.)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z13Del()
//////////////////////
nOpca := AxDeleta("Z13",Z13->(Recno()), 5)
Return(.t.)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z13AGL()
//////////////////////
//cMarca    := GetMark()

_cQuery := "UPDATE " + RetSqlName('Z13')
_cQuery += _cEnter + " SET Z13_OK = ''"
TcSqlExec(_cQuery)

_cQuery := "UPDATE " + RetSqlName('Z13')
_cQuery += _cEnter + " SET Z13_OK = '" + cMarca + "'"
_cQuery += _cEnter + " WHERE Z13_FORNEC = '"  	+ Z13->Z13_FORNEC 		+ "'"
_cQuery += _cEnter + " AND Z13_LOJA = '"  		+ Z13->Z13_LOJA 		+ "'"
_cQuery += _cEnter + " AND Z13_PREVEN = '"  	+ dtos(Z13->Z13_PREVEN) + "'"
_cQuery += _cEnter + " AND Z13_EMPR = '" 		+ Z13->Z13_EMPR 		+ "'"
_cQuery += _cEnter + " AND Z13_NUMADT = ''"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
TcSqlExec(_cQuery)

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z13CMP()
//////////////////////

If empty(Z13->Z13_SLDADT)
	MsgBox('Saldo do adiantamento está zerado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf
If empty(Z13->Z13_SLDDOC)
	MsgBox('Saldo da nota fiscal está zerado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf
If empty(Z13->Z13_NUMADT)
	MsgBox('Pedido de Compras sem adiantamento lançado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf
If empty(Z13->Z13_DOC)
	MsgBox('Pedido de Compras em aberto. Lançar nota fiscal.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSelectArea('SF1')
If DbSeek(Z13->Z13_FILORI + Z13->Z13_DOC + Z13->Z13_SERIE + Z13->Z13_FORNEC + Z13->Z13_LOJA,.f.)
	MsgBox('Nota fiscal não localizada.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSelectArea('SE2')
DbSetOrder(6)
If !DbSeek(xFilial('SE2') + Z13->Z13_FORNEC + Z13->Z13_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC + Z13->Z13_PARADT,.f.)
	MsgBox('Título não localizado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSetOrder(1)
If !DbSeek(xFilial('SE2') + Z13->Z13_PRFADT + Z13->Z13_NUMADT + Z13->Z13_PARADT + 'PA ' + Z13->Z13_FORNEC + Z13->Z13_LOJA,.f.)
	MsgBox('PA não localizado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSeek(xFilial('SE2') + Z13->Z13_PRFADT + Z13->Z13_NUMADT + Z13->Z13_PARADT + 'PA ' + Z13->Z13_FORNEC + Z13->Z13_LOJA,.f.)
RecLock('SE2',.f.)
SE2->E2_SALDO := SE2->E2_SALDO - min(Z13->Z13_VLRDOC, SE2->E2_SALDO)
MsUnLock()

DbSetOrder(6)
DbSeek(xFilial('SE2') + Z13->Z13_FORNEC + Z13->Z13_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC + Z13->Z13_PARADT,.f.)
RecLock('SE2',.f.)
SE2->E2_SALDO := SE2->E2_SALDO - min(Z13->Z13_VLRDOC, SE2->E2_SALDO)
MsUnLock()                                   

Return()
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z13ADT()
//////////////////////

_cQuery := "SELECT SUM(Z13_VLRPC) VALORPCS"
_cQuery += _cEnter + " FROM " + RetSqlName('Z13') + " Z13 (NOLOCK)"
_cQuery += _cEnter + " WHERE Z13_OK = '" + cMarca + "'"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"

DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), '_Z13', .F., .T.)
_nValorPCs := _Z13->VALORPCS
DbCloseArea()

If _nValorPCs == 0
	MsgBox('Nenhum título selecionado para geração do PA','ATENÇÃO!!!','ALERT')
	Return()
EndIf

_cPrefixo 	:= 'PC '
_cNumAdt	:= Z13->Z13_FORNEC + Z13->Z13_LOJA + ' '
_cBanco     := '   '
_cAgencia   := '     '
_cConta     := '          '
_cNatur     := _cNatureza  := '          '

_cQuery := "SELECT MAX(E2_PARCELA) PARCELA"
_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
_cQuery += _cEnter + " WHERE E2_PREFIXO = 'PC'"
_cQuery += _cEnter + " AND E2_NUM = '" + _cNumAdt + "'"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND E2_MATRIZ = '" + Z13->Z13_EMPR + "'"

DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), '_SE2', .F., .T.)
_cParcela := iif(empty(_SE2->PARCELA),'001',Soma1(_SE2->PARCELA))
DbCloseArea()

cFilOrig   := Z13->Z13_EMPR

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
@ C(060),C(110) Get _nValorPCs 		Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg picture '@E 999,999.99'

@ C(080),C(010) Button "Ok" 		Size C(030),C(012) PIXEL OF oDlg ACTION(_nOk := 1,oDlg:End())
@ C(080),C(060) Button "Cancelar" 	Size C(030),C(012) PIXEL OF oDlg ACTION(_nOk := 3,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED valid _nOk > 0

If _nOK == 1   
	MsAguarde({|| GeraPA()},'Aguarde... gerando PA!')
EndIf

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraPA()
////////////////////////

_cFilAnt := cFilAnt
cFilAnt := Z13->Z13_EMPR
_aExecAuto := {}
aAdd(_aExecAuto,{"E2_PREFIXO"   , _cPrefixo			, Nil})
aAdd(_aExecAuto,{"E2_NUM"       , _cNumAdt			, Nil})
aAdd(_aExecAuto,{"E2_PARCELA"   , _cParcela			, Nil})
aAdd(_aExecAuto,{"E2_TIPO"      , 'PA'				, Nil})
aAdd(_aExecAuto,{"E2_NATUREZ"   , _cNatureza		, Nil})
aAdd(_aExecAuto,{"E2_FORNECE"   , Z13->Z13_FORNEC	, Nil})
aAdd(_aExecAuto,{"E2_LOJA"      , Z13->Z13_LOJA		, Nil})
aAdd(_aExecAuto,{"E2_EMISSAO"   , dDataBase			, NIL})
aAdd(_aExecAuto,{"E2_VENCTO"    , dDataBase			, NIL})
aAdd(_aExecAuto,{"E2_VENCREA"   , dDataBase			, NIL})
aAdd(_aExecAuto,{"E2_VALOR"     , _nValorPCs		, Nil})
aAdd(_aExecAuto,{"E2_BCOTDDC"	, _cBanco			, NIL})
aAdd(_aExecAuto,{"E2_AGETDDC"	, _cAgencia			, NIL})
aAdd(_aExecAuto,{"E2_CNTTDDC"	, _cConta			, NIL})
aAdd(_aExecAuto,{"AUTBANCO"		, _cBanco			, NIL})
aAdd(_aExecAuto,{"AUTAGENCIA"	, _cAgencia			, NIL})
aAdd(_aExecAuto,{"AUTCONTA"		, _cConta			, NIL})

lMsErroAuto := .F.
MsExecAuto({|x,y,z| FINA050(x,y,z)},_aExecAuto,,3) //Inclusao
cFilAnt := _cFilAnt

If lMsErroAuto
	MostraErro()
Else
	_cQuery := "UPDATE " + RetSqlName('Z13')
	_cQuery += _cEnter + " SET Z13_NUMADT = Z13_FORNEC + Z13_LOJA, Z13_PRFADT = 'PC', Z13_PARADT = '" + _cParcela + "', Z13_DTADT = '" + dtos(dDataBase) + "',"
	_cQuery += _cEnter + " Z13_VLRADT = " + str(_nValorPCs,9,2)
	_cQuery += _cEnter + " WHERE Z13_OK = '" + cMarca + "'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
	MsgBox('Pagamento adiantado gerado com sucesso','ATENÇÃO!!!','INFO')
	
EndIf

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z13Exc()
//////////////////////

SE2->(DbSetOrder(1))
If SE2->(DbSeek(xFilial('SE2') + Z13->Z13_PRFADT + Z13->Z13_NUMADT + Z13->Z13_PARADT + 'PA',.F.))

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
	
	@ C(005),C(025) Get Z13->Z13_PRFADT		Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(015),C(025) Get Z13->Z13_NUMADT		Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	@ C(025),C(025) Get Z13->Z13_PARADT		Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDlg when .f.
	
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
		_cFilAnt := Z13->Z13_EMPR
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
	_cQuery += _cEnter + " WHERE E5_FILIAL = '" + Z13->Z13_EMPR + "'"
	_cQuery += _cEnter + " AND (E5_KEY = '" + 'PC ' + Z13->Z13_NUMADT + Z13->Z13_PARADT + 'PA ' + alltrim(Z13->Z13_NUMADT) + "'"
	_cQuery += _cEnter + " OR E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_FORNECE + E5_LOJA = '" + Z13->Z13_EMPR + 'PC ' + Z13->Z13_NUMADT + Z13->Z13_PARADT + 'PA ' + alltrim(Z13->Z13_NUMADT) + "')"
	_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)

	_cQuery := "UPDATE " + RetSqlName('Z13')
	_cQuery += _cEnter + " SET Z13_NUMADT = '', Z13_PRFADT = '', Z13_PARADT = '', Z13_DTADT = '', Z13_VLRADT = 0"
	_cQuery += _cEnter + " WHERE Z13_NUMADT = '" + Z13->Z13_NUMADT  	 + "'"
	_cQuery += _cEnter + " AND Z13_PARADT = '" 	 + Z13->Z13_PARADT 		 + "'"
	_cQuery += _cEnter + " AND Z13_DTADT = '" 	 + dtos(Z13->Z13_DTADT)  + "'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)

EndIf

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_VLZ13()
////////////////////////
_lRet := SC7->(DbSeek(M->Z13_FILORI + alltrim(M->Z13_PEDIDO),.f.))

If !_lRet .and. empty(M->Z13_PEDIDO)
	MsgBox('Filial não possui pedido de compra cadastrado','ATENÇÃO!!!','ALERT')
ElseIf !_lRet  .and. !empty(M->Z13_PEDIDO)
	MsgBox('Pedido de compra não localizado na filial informada','ATENÇÃO!!!','ALERT')
ElseIf !_lRet
	MsgBox('Pedido de compra não localizado na filial informada','ATENÇÃO!!!','ALERT')
ElseIf SC7->C7_CONAPRO == 'B' .and. !empty(M->Z13_PEDIDO)
	MsgBox('Pedido de compra encontra-se BLOQUEADO','ATENÇÃO!!!','ALERT')
	_lRet := .f.
ElseIf SC7->C7_ENCER == 'E' .and. !empty(M->Z13_PEDIDO)
	MsgBox('Pedido de compra encontra-se ENCERRADO','ATENÇÃO!!!','ALERT')
	_lRet := .f.
Else
	
	If M->Z13_FILORI <= '99'
		M->Z13_EMPR := '01'
	ElseIf M->Z13_FILORI >= 'A0' .and. M->Z13_FILORI <= 'AZ'
		M->Z13_EMPR := 'A0'
	ElseIf (M->Z13_FILORI >= 'C0' .and. M->Z13_FILORI <= 'EZ') .or. M->Z13_FILORI == 'GH'
		M->Z13_EMPR := 'C0'
	ElseIf M->Z13_FILORI >= 'G0' .and. M->Z13_FILORI <= 'GZ'
		M->Z13_EMPR := 'G0'
	ElseIf M->Z13_FILORI >= 'R0' .and. M->Z13_FILORI <= 'RZ'
		M->Z13_EMPR := 'R0'
	ElseIf M->Z13_FILORI >= 'T0' .and. M->Z13_FILORI <= 'TZ'
		M->Z13_EMPR := 'T0'
	ElseIf M->Z13_FILORI == 'BH'
		M->Z13_EMPR := 'BH'
	EndIf
	
	If !empty(M->Z13_PEDIDO)
		
		If Z13->(DbSeek(xFilial('Z13') + M->Z13_EMPR + M->Z13_FILORI + SC7->C7_FORNECE + SC7->C7_LOJA + dtos(SC7->C7_EMISSAO) + M->Z13_PEDIDO,.f.))
			MsgBox('Pedido de compra já incluido para adiantamento','ATENÇÃO!!!','ALERT')
			_lRet := .f.
		Else
			_cQuery := "SELECT SUM(C7_TOTAL+C7_VALIPI+C7_ICMSRET) TOTALPC"
			_cQuery += _cEnter + " FROM " + RetSqlName('SC7') + " SC7 (NOLOCK)"
			_cQuery += _cEnter + " WHERE C7_FILIAL = '" + M->Z13_FILORI + "'"
			_cQuery += _cEnter + " AND C7_NUM = '" + M->Z13_PEDIDO + "'"
			_cQuery += _cEnter + " AND SC7.D_E_L_E_T_ = ''"
			DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRBSC7', .F., .T.)
			
			M->Z13_ENTREG := SC7->C7_DATPRF
			M->Z13_DATAPC := SC7->C7_EMISSAO
			M->Z13_FORNEC := SC7->C7_FORNECE
			M->Z13_LOJA   := SC7->C7_LOJA
			M->Z13_PREVEN := SC7->C7_DATPRF
			M->Z13_VLRPC  := TRBSC7->TOTALPC
			DbCloseArea()
			
		EndIf
		
	EndIf
	
EndIf

Return(_lRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z13Imp()
//////////////////////

cDesc1        := "Este programa tem como objetivo gerar relatorio/email "
cDesc2        := "relacionando os pedidos de compra para pagamento adiantado"
cDesc3        := ""
cTitulo       := "Pedidos de compras x adiantamentos"
nLin          := 80

Private aOrd        := {}
Private aReturn     := { "Zebrado",1,"Administracao", 2, 2, 1, '', 1}
Private cString     := 'Z13'
Private cNomeprog   := 'LS_Z13REL'
Private lEnd        := .F.
Private lAbortPrint := .F.
Private m_pag       := 01
Private nLimite     := 220
Private nTipo       := 18
Private nLastKey    := 0
Private Tamanho     := 'M'
Private cPerg 		:= wnrel       := 'LS_Z13REL '

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

_cQuery := "SELECT Z13_EMPR,Z13_DATAPC,Z13_FORNEC, Z13_LOJA, Z13_FILORI, Z13_PEDIDO, Z13_ENTREG, SUM(C7_TOTAL) TOTAL,  SUM(C7_VALIPI) IPI, SUM(C7_ICMSRET) ICMSRET, "
_cQuery += _cEnter + " A2_NOME, A2_TEL, A2_BANCO, A2_AGENCIA, A2_NUMCON, A1_NOME, A1_NREDUZ "
_cQuery += _cEnter + " FROM " + RetSqlName('Z13') + " Z13 (NOLOCK)"
_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"

_cQuery += _cEnter + " ON C7_FILIAL = Z13_FILORI"
_cQuery += _cEnter + " AND C7_NUM = Z13_PEDIDO"
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

_cQuery += _cEnter + " WHERE Z13_DATAPC BETWEEN  '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += _cEnter + " AND Z13_NUMADT = ''"
_cQuery += _cEnter + " AND Z13.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " GROUP BY Z13_EMPR,Z13_DATAPC,Z13_FORNEC, Z13_LOJA, Z13_FILORI, Z13_PEDIDO,A2_NOME, A2_TEL, A2_BANCO, A2_AGENCIA, A2_NUMCON,Z13_ENTREG, A1_NOME, A1_NREDUZ "
_cQuery += _cEnter + " ORDER BY Z13_EMPR,Z13_DATAPC,Z13_FORNEC, Z13_LOJA, Z13_FILORI, Z13_PEDIDO"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_Z13', .F., .T.)
TcSetField('_Z13','Z13_ENTREG','D',0)
TcSetField('_Z13','Z13_DATAPC','D',0)

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
	_cEmpresa := _Z13->Z13_EMPR
	Do While !eof() .and. _cEmpresa == _Z13->Z13_EMPR
		
		If nLin > 55
			nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
		EndIf
		
		_cLinha := _Z13->A1_NOME + ' ' + _Z13->Z13_FORNEC  + '/' + _Z13->Z13_LOJA + ' - ' + _Z13->A2_NOME + ' - ' + _Z13->A2_TEL
		@ ++nLin, 000 PSAY _cLinha
		++nLin
		
		_nSTotPed := 0
		_nSTotICM := 0
		_nSTotIPI := 0
		_nSTotGer := 0
		_cChave   := _Z13->Z13_EMPR + dtos(_Z13->Z13_DATAPC) + _Z13->Z13_FORNEC + _Z13->Z13_LOJA
		Do While !eof() .and. _cChave == _Z13->Z13_EMPR + dtos(_Z13->Z13_DATAPC) + _Z13->Z13_FORNEC + _Z13->Z13_LOJA
			
			If nLin > 55
				nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
			EndIf
			
			If lAbortPrint .Or. lEnd
				@ 000,000 PSay "***CANCELADO PELO OPERADOR!"
				Exit
			EndIf
			
			_nTotal := _Z13->TOTAL + _Z13->ICMSRET + _Z13->IPI
			
			_cLinha := _Z13->Z13_FILORI + '  ' + _Z13->A1_NREDUZ + '  ' + _Z13->Z13_PEDIDO + '  ' + dtoc(_Z13->Z13_DATAPC) + '  ' + dtoc(_Z13->Z13_ENTREG) + '  ' + tran(_Z13->TOTAL,'@E 999,999.99') + '  ' + tran(_Z13->ICMSRET,'@E 999,999.99') + '  ' + tran(_Z13->IPI,'@E 999,999.99') + '  ' + tran(_nTotal,'@E 999,999.99')
			
			@ ++nLin, 000 PSAY _cLinha
			
			_nTotPed += _Z13->TOTAL
			_nTotICM += _Z13->ICMSRET
			_nTotIPI += _Z13->IPI
			_nTotGer += _nTotal
			
			_nSTotPed += _Z13->TOTAL
			_nSTotICM += _Z13->ICMSRET
			_nSTotIPI += _Z13->IPI
			_nSTotGer += _nTotal
			
			_nETotPed += _Z13->TOTAL
			_nETotICM += _Z13->ICMSRET
			_nETotIPI += _Z13->IPI
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
