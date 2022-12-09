#include "ap5mail.ch"
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

// Programa.: LS_SZY
// Autor....: Alexandre Dalpiaz
// Data.....: 02/05/2011
// Descrição: Rotina de cadastro de perdas de mercadoria nas lojas
//			  emissão de relatório de perdas
//			  envio de emails para lojas e usuários que incluiram as perdas
//			  autorização das perdas
//			  integração das perdas, em movimentos internos com rotina automática
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZY()
//////////////////////

Local aArea  	:= GetArea()
Local cAlias  	:= "SZY"

cPerg := 'LS_SZY    '
ValidPerg()

Pergunte(cPerg,.F.)

dbSelectArea("SZY")
dbSetOrder(1)

aRotina    	:= {}
cCadastro  	:= "Perdas de Lojas"
aLegenda   	:= {}
aCores     	:= {}
nOpca 		:= 0

aAdd(aLegenda, {'BR_AZUL' 	    	,'Incluida'  		, '3'	})
aAdd(aLegenda, {'BR_AMARELO'   		,'Pendente'  		, '3'	})
aAdd(aLegenda, {'BR_VERDE'	  		,'Autorizada'  		, '1'	})
aAdd(aLegenda, {'BR_VERMELHO'		,'Bloqueada' 		, '3'	})
aAdd(aLegenda, {'BR_PRETO'	    	,'Importada' 		, '3'	})

Aadd(aCores  ,{ "ZY_STATUS == '1'" 	, 'BR_AZUL' 				}) // INCLUIDO
Aadd(aCores  ,{ "ZY_STATUS == '2'" 	, 'BR_AMARELO'				}) // PENDENTE
Aadd(aCores  ,{ "ZY_STATUS == '3'" 	, 'BR_VERDE'				}) // AUTORIZADO
Aadd(aCores	 ,{ "ZY_STATUS == '4'" 	, 'BR_VERMELHO'				}) // BLOQUEADO
Aadd(aCores  ,{ "ZY_STATUS == '5'" 	, 'BR_PRETO' 				}) // IMPORTADO

Aadd(aRotina ,{"Pesquisar" 			,"AxPesqui"	   		,0,1 	})
Aadd(aRotina ,{"Visualizar"  		,"AxVisual" 		,0,2 	})
Aadd(aRotina ,{"Incluir"  			,"U_SZYInc"			,0,3 	})
Aadd(aRotina ,{"Alterar"  			,"U_SZYAlt" 		,0,4 	})
Aadd(aRotina ,{"Exclui"  			,"U_SZYDel" 		,0,5 	})

If cNivel == 8 .or. __cUserId $ GetMv('LA_PODER')
	Aadd(aRotina,{"Autoriza"   		,"U_SZYAUT" 		,0,6 	})     //2
Endif	
//ElseIf cNivel == 9  .or. __cUserId $ GetMv('LA_PODER')
If cNivel == 9  .or. __cUserId $ GetMv('LA_PODER')
	Aadd(aRotina,{"Integra"  		,"U_SZYINT"			,0,7 	})     //2
ELSE
	Alert(OAPP:CMODNAME + " - " + Substring(cUsuario,7,15)+ " - " + alltrim(str(cNivel)))
EndIf

If cNivel > 7 .or. __cUserId $ GetMv('LA_PODER')
	//	Aadd(aRotina,{"Autoriza"   			,"U_SZYAUT" 		,0,2 })
	//	Aadd(aRotina,{"Integra"  			,"U_SZYINT"			,0,2 })
	Aadd(aRotina,{"Relatório"  			,"U_SZYREL(.f.)"	,0,8 })  //2
	Aadd(aRotina,{"eMail"      			,"U_SZYREL(.t.)"	,0,9 })  //2
	Aadd(aRotina,{"Bloqueio"   			,"U_SZYBLQ" 		,0,10 })  //2
EndIf
Aadd(aRotina,{"Legenda"			,"BrwLegenda('Perdas de Lojas' , 'Legenda' , aLegenda)",0,5})
DbSelectArea('SZY')
mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZYINC()
//////////////////////
nOpca := AxInclui("SZY",SZY->(Recno()), 3,/*{aAcho}*/ , /*"U_SZRIBefore"*/, /*{aCampos}*/ , "U_SZYITudoOk()", /*lF3*/.F., /*"U_SZRITransaction"*/, /*{aButtons}*/, /*{aParam}*/,/*{aAuto}*/, /*lVirtual*/, /*lMaximized*/.t., /*cTela*/, /*lPanelFin*/, /*oFather*/, /*{aDim}*/, /*uArea*/)
Return(nOpca)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZYITudoOk()
//////////////////////////
Local _lRet := .t.
Local _cMemo := M->ZY_COMPLEM
_cMemo := alltrim(strtran(strtran(strtran(_cMemo,chr(13)+chr(10),''),chr(13),''),chr(10),''))
If empty(_cMemo)
	MsgBox('Obrigatório preencher o campo de observações do motivo do cancelamento.','ATENÇÃO!!!','ALERT')
	_lret := .f.
EndIf
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZYALT()
//////////////////////
Begin Transaction
//nOpca := AxAltera("SZY",SZY->(Recno()), 4) //,/*{aAcho}*/ , "U_SZRIBefore", /*{aCampos}*/ , "U_SZRITudoOk()", /*lF3*/.F., "U_SZRITransaction", /*{aButtons}*/, /*{aParam}*/,/*{aAuto}*/, /*lVirtual*/, /*lMaximized*/.t., /*cTela*/, /*lPanelFin*/, /*oFather*/, /*{aDim}*/, /*uArea*/)

nOpca := AxAltera("SZY",SZY->(Recno()), 4,,     ,,, "U_SZYITudoOk()")
If .f. .and. nOpca == 1 .and. empty(SZY->ZY_COMPLEM)
	
	Do While empty(SZY->ZY_COMPLEM)
		nOpca := MsgBox('Obrigatório preencher o campo de observações do motivo do cancelamento. ABANDONAR?','ATENÇÃO!!!','YESNO')
		If nOpca
			nOpca := 2
		Else
			nOpca := AxAltera("SZY",SZY->(Recno()), 4) //,/*{aAcho}*/ , "U_SZRIBefore", /*{aCampos}*/ , "U_SZRITudoOk()", /*lF3*/.F., "U_SZRITransaction", /*{aButtons}*/, /*{aParam}*/,/*{aAuto}*/, /*lVirtual*/, /*lMaximized*/.t., /*cTela*/, /*lPanelFin*/, /*oFather*/, /*{aDim}*/, /*uArea*/)
		EndIf
		If nOpca == 2
			Exit
		EndIf
	EndDo
	If nOpca == 2
		DisarmTransaction()
	EndIf
EndIf
End Transaction
Return(nOpca)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZYDel()
//////////////////////
If (cNivel > 5 .or. __cUserId $ GetMv('LA_PODER') .or. SZY->ZY_STATUS < '3')
	AxDeleta('SZY',SZY->(RecNo()), 5)
Else
	MsgBox('Exclusão não permitida')
EndIf

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZYAut()
//////////////////////

_cQuery := "SELECT COUNT(*) QUANT"
_cQuery += _cEnter + " FROM " + RetSqlName('SZY') + " SZY (NOLOCK)"
_cQuery += _cEnter + " WHERE ZY_FILIAL 		= '" + SZY->ZY_FILIAL + "'"
_cQuery += _cEnter + " AND ZY_DTPERDA 		= '" + dtos(SZY->ZY_DTPERDA) + "'"
_cQuery += _cEnter + " AND ZY_STATUS 		= '2'"
_cQuery += _cEnter + " AND SZY.D_E_L_E_T_	= ''"

MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)},'Verificando Pendências...')

If TRB->QUANT > 0
	MsgBox('Existem perdas pendentes','Verifique!','ALERT')
	DbCloseArea()
	Return()
EndIf

DbCloseArea()

_cQuery := "UPDATE " + RetSqlName('SZY')
_cQuery += _cEnter + " SET ZY_STATUS 	= '3'"
_cQuery += _cEnter + " WHERE ZY_FILIAL 	= '" + SZY->ZY_FILIAL + "'"
_cQuery += _cEnter + " AND ZY_DTPERDA 	= '" + dtos(SZY->ZY_DTPERDA) + "'"
_cQuery += _cEnter + " AND ZY_STATUS 	= '1'"
_cQuery += _cEnter + " AND D_E_L_E_T_ 	= ''"

MsAguarde({|| TcSqlExec(_cQuery)},'Autorizando perdas...')
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZYInt()
//////////////////////

If !Pergunte(cPerg,.t.)
	Return()
EndIf

Processa({|| RunProc()})

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

_cQuery := "SELECT * "
_cQuery += _cEnter + " FROM " + RetSqlName('SZY') + " SZY (NOLOCK)"
_cQuery += _cEnter + " WHERE ZY_FILIAL		BETWEEN '" + mv_par01 		+ "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND ZY_DTPERDA 		BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"
_cQuery += _cEnter + " AND ZY_DOC 			= ''"
_cQuery += _cEnter + " AND ZY_STATUS 		= '3'"
_cQuery += _cEnter + " AND SZY.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + " ORDER BY ZY_FILIAL, ZY_DTPERDA, ZY_MOTIVO, ZY_COD"

MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)},'Selecionando Perdas...')

If eof()
	MsgBox('Nenhuma perda selecionada para os parâmetros informados','Verifique!','ALERT')
	DbCloseArea()
	Return()
EndIf
Count to _nLastRec
DbgoTop()
ProcRegua(_nLastRec)

Do While !eof()
	
	aCab 	 := {}
	aItens	 := {}
	_cFilial := TRB->ZY_FILIAL
	_cData   := TRB->ZY_DTPERDA
	_cMotivo := TRB->ZY_MOTIVO
	_cCC     := alltrim(Posicione('SX5',1,xFilial('SX5') + 'ZM' + _cFilial,'X5_DESCRI'))
	
	aAdd(aCab, {"D3_TM" 		,	Posicione('SX5',1,xFilial('SX5') + 'ZT' + TRB->ZY_MOTIVO, alltrim('X5_DESCSPA'))  									, NIL})
	aAdd(aCab, {"D3_DOC"		,	alltrim(SX5->X5_DESCENG) + right(TRB->ZY_DTPERDA,2) + substr(TRB->ZY_DTPERDA,5,2) + substr(TRB->ZY_DTPERDA,3,2) 	, NIL})
	aAdd(aCab, {"D3_CC" 		,	_cCC	 																											, NIL})
	aAdd(aCab, {"D3_EMISSAO" 	,	stod(TRB->ZY_DTPERDA)					 																			, NIL})
	
	Do While !eof() .and. _cFilial == TRB->ZY_FILIAL .and. _cData == TRB->ZY_DTPERDA .and. _cMotivo == TRB->ZY_MOTIVO
		
		IncProc()
		
		aAdd(aItens, {})
		aAdd(aItens[len(aItens)], {"D3_COD"    	,TRB->ZY_COD	,NIL})
		aAdd(aItens[len(aItens)], {"D3_QUANT"  	,TRB->ZY_PERDA  ,NIL})
		aAdd(aItens[len(aItens)], {"D3_LOCAL"  	,'01'			,NIL})
		
		DbSkip()
	EndDo
	
	_lGera := .t.
	If empty(_cCC)
		MsgBox('Centro de custo não informado para esta loja' + _cEnter + 'Escolha o centro de custo correto na sexta pergunta','ATENÇÃO!!!','ALERT')
		If !Pergunte(cPerg,.t.) .or. empty(mv_par05)
			_lGera := MsgBox('Centro de Custo não informado' + _cEnter + _cEnter + 'Gerar o movimento de perda sem Centro de Custos?','ATENÇÃO!!!','YESNO')
		Else
			aCab[3,2] := mv_par05
			RecLock('SX5',.t.)
			SX5->X5_TABELA  := 'ZM'
			SX5->X5_CHAVE   := _cFilial
			SX5->X5_DESCRI  := mv_par05
			SX5->X5_DESCSPA := Posicione('SM0', 1, cEmpAnt + _cFilial,'M0_FILIAL')
			MsUnLock()
		EndIf
	EndIf
	
	If _lGera
		
		cNumEmp := cEmpAnt + _cFilial
		_cFilAnt := cFilAnt
		cFilAnt  := _cFilial
		
		lMsErroAuto := .f.
		MsExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItens,3)
		
		If lMsErroAuto
			MostraErro()
		Else
			_cQuery := "UPDATE " + RetSqlName('SZY')
			_cQuery += _cEnter + " SET ZY_STATUS = '5', ZY_DOC = '" + alltrim(SX5->X5_DESCENG) + right(_cData,2) + substr(_cData,5,2) + substr(_cData,3,2) + "'"
			_cQuery += _cEnter + " WHERE ZY_FILIAL = '" + _cFilial + "'"
			_cQuery += _cEnter + " AND ZY_DOC = ''"
			_cQuery += _cEnter + " AND ZY_STATUS = '3'"
			_cQuery += _cEnter + " AND ZY_DTPERDA = '" + _cData + "'"
			_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
			
			TcSqlExec(_cQuery)
			
		EndIf
		
		cFilAnt  := _cFilAnt
		cNumEmp  := cEmpAnt + cFilAnt
		SM0->(DbSeek(cNumEmp,.f.))
		
	EndIf
	
	DbSelectArea('TRB')
	
EndDo

DbCloseArea()

Return()


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Filial de                     ?","","", "mv_ch1", "C",  2 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0", "", "",""})
aAdd( aPerg , { cPerg, "02", "Filial até                    ?","","", "mv_ch2", "C",  2 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0", "", "",""})
aAdd( aPerg , { cPerg, "03", "Data de                       ?","","", "mv_ch3", "D",  8 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "04", "Data até                      ?","","", "mv_ch4", "D",  8 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "05", "Centro de Custo               ?","","", "mv_ch5", "C", 15 , 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT", "", "",""})
aAdd( aPerg , { cPerg, "06", "Incluidos                     ?","","", "mv_ch6", "N",  1 , 0, 0, "C", "", "mv_par06", "Sim", "", "", "", "", "Não", "", "", "", "", "Ambos", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "07", "Pendentes                     ?","","", "mv_ch7", "N",  1 , 0, 0, "C", "", "mv_par07", "Sim", "", "", "", "", "Não", "", "", "", "", "Ambos", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "08", "Autorizados                   ?","","", "mv_ch8", "N",  1 , 0, 0, "C", "", "mv_par08", "Sim", "", "", "", "", "Não", "", "", "", "", "Ambos", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "09", "Bloqueados                    ?","","", "mv_ch9", "N",  1 , 0, 0, "C", "", "mv_par09", "Sim", "", "", "", "", "Não", "", "", "", "", "Ambos", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "10", "Importados                    ?","","", "mv_chA", "N",  1 , 0, 0, "C", "", "mv_par10", "Sim", "", "", "", "", "Não", "", "", "", "", "Ambos", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZYREL(_lEmail)
/////////////////////////////

cDesc1        		:= "Este programa tem como objetivo imprimir relatorio "
cDesc2        		:= "com as perdas de produtos nas lojas"
cDesc3        		:= ""
cTitulo       		:= "Perdas de Produtos nas Lojas"
nLin          		:= 80

Private aOrd        := {}
Private aReturn     := { "Zebrado",1,"Administracao", 2, 2, 1, '', 1}
Private cString     := 'SZY'
Private cNomeprog   := 'LS_SZYREL'
Private lEnd        := .F.
Private lAbortPrint := .F.
Private m_pag       := 01
Private nLimite     := 220
Private nTipo       := 18
Private nLastKey    := 0
Private Tamanho     := 'P'
Private wnrel       := 'LS_SZYREL'

_cStatus := iif(mv_par06 == 1,'1,','')
_cStatus += iif(mv_par07 == 1,'2,','')
_cStatus += iif(mv_par08 == 1,'3,','')
_cStatus += iif(mv_par09 == 1,'4,','')
_cStatus += iif(mv_par10 == 1,'5,','')

If _lEmail
	
	If !MsgBox('Confirmar envio de emails de perdas para as Lojas?','Perdas de Lojas','YESNO')
		Return()
	EndIf
	
	_cErros := ''
	_cQuery := "SELECT DISTINCT ZY_FILIAL"
	_cQuery += _cEnter + " FROM " + RetSqlName('SZY') + " SZY (NOLOCK)"
	_cQuery += _cEnter + " WHERE ZY_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	_cQuery += _cEnter + " AND ZY_DTPERDA BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"
	//_cQuery += _cEnter + " AND ZY_DOC = ''"
	If !empty(_cStatus)
		_cQuery += _cEnter + " AND ZY_STATUS IN " + FormatIn(left(_cStatus,len(_cStatus)-1),',')
	EndIf
	_cQuery += _cEnter + " AND SZY.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " ORDER BY ZY_FILIAL"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SZY', .F., .T.)
	Do While !eof()
		
		RptStatus({|lEnd| RunReport( @lEnd,_lEmail) }, cTitulo)
		
		DbSelectArea('_SZY')
		DbSkip()
		
	EndDo
	
	DbCloseArea()
	
	MsgBox('Emails enviados com ' + iif(empty(_cErros),'sucesso!!!','erros:' + _cEnter + 'Lojas - ' + _cErros),'Perdas de Lojas','ALERT')
	
Else
	
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
	
	RptStatus({|lEnd| RunReport( @lEnd,_lEmail) }, cTitulo)
	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport( lEnd,_lEmail)
////////////////////////////////////////

_cQuery := "SELECT SZY.*, B1_DESC, A1_NREDUZ, X5_DESCRI, A1_EMAIL, A1_COD"
_cQuery += _cEnter + " FROM " + RetSqlName('SZY') + " SZY (NOLOCK)"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + ' SB1 (NOLOCK)'
_cQuery += _cEnter + " ON B1_COD = ZY_COD"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND B1_FILIAL = ''"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SA1') + ' SA1 (NOLOCK)'
_cQuery += _cEnter + " ON A1_COD < '000009'"
_cQuery += _cEnter + " AND SA1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND A1_FILIAL = ''"
_cQuery += _cEnter + " AND A1_LOJA = ZY_FILIAL"
_cQuery += _cEnter + " AND A1_MSBLQL = '2'"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SX5') + ' SX5 (NOLOCK)'
_cQuery += _cEnter + " ON X5_TABELA = 'ZT'"
_cQuery += _cEnter + " AND SX5.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND X5_FILIAL = ''"
_cQuery += _cEnter + " AND X5_CHAVE = ZY_MOTIVO"

If _lEmail
	_cQuery += _cEnter + " WHERE ZY_FILIAL = '" + _SZY->ZY_FILIAL + "'"
Else
	_cQuery += _cEnter + " WHERE ZY_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
EndIf
_cQuery += _cEnter + " AND ZY_DTPERDA BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"
//_cQuery += _cEnter + " AND ZY_DOC = ''"
If !empty(_cStatus)
	_cQuery += _cEnter + " AND ZY_STATUS IN " + FormatIn(left(_cStatus,len(_cStatus)-1),',')
EndIf
_cQuery += _cEnter + " AND SZY.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " ORDER BY ZY_FILIAL, ZY_DTPERDA, ZY_STATUS, ZY_MOTIVO, ZY_COD"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
TcSetField('TRB','ZY_DTPERDA','D',0)
TcSetField('TRB','ZY_DTLANC' ,'D',0)

count to _nLastRec
DbGoTop()
SetRegua( _nLastRec )

cCabec1 := 'Produto         Descricao                                          Quantidade'
cCabec2 := ''
//          123456798012345 12345678901234567890123456789012345678901234567890  123456,12

If _lEmail .and. eof()
	DbCloseArea()
	MS_FLUSH()
	Return()
EndIf

_cCorpo := '<html>'
_cCorpo += '<head><pre>'
_cCorpo += '<h3 align = Left><font size="3" face="Courier New">'

Do While !eof()
	
	_cChave := TRB->ZY_FILIAL + dtos(TRB->ZY_DTPERDA) + TRB->ZY_MOTIVO + TRB->ZY_STATUS
	
	If nLin > 55 .and. !_leMail
		nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
	EndIf
	
	_cLinha := 'Loja: ' + TRB->ZY_FILIAL + ' - ' + Posicione('SM0', 1, cEmpAnt + TRB->ZY_FILIAL,'M0_FILIAL') + ' Data: ' + dtoc(TRB->ZY_DTPERDA) + ' Status: ' + iif(TRB->ZY_STATUS == '2','Pendente ','Bloqueado') + ' Motivo: ' + alltrim(TRB->X5_DESCRI)
	If _leMail
		_cCorpo += _cEnter + _cLinha + _cEnter
	Else
		@ ++nLin, 000 PSAY _cLinha
		++nLin
	EndIf
	
	Do While !eof() .and. _cChave == TRB->ZY_FILIAL + dtos(TRB->ZY_DTPERDA) + TRB->ZY_MOTIVO + TRB->ZY_STATUS
		
		If nLin > 55
			If _leMail
				_cCorpo += _cEnter + replicate('*',80)
				_cCorpo += _cEnter + cCabec1
				_cCorpo += _cEnter + replicate('*',80) + _cEnter + _cEnter
				nLin := 0
			Else
				nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
			EndIf
		EndIf
		
		If lAbortPrint .Or. lEnd
			@ 000,000 PSay "***CANCELADO PELO OPERADOR!"
			Exit
		EndIf
		
		_cLinha := TRB->ZY_COD + ' ' + left(TRB->B1_DESC,50) + ' ' + tran(TRB->ZY_PERDA,'@e 999,999.99')
		
		If _leMail
			_cCorpo += _cEnter + _cLinha
		Else
			@ ++nLin, 000 PSAY _cLinha
		EndIf
		
		cRecebe     := TRB->A1_EMAIL + space(100)
		_cFilial 	:= TRB->ZY_FILIAL
		_cCod       := TRB->A1_COD
		_cNomeFil 	:= TRB->A1_NREDUZ
		PswOrder(2)
		If PswSeek(left(FWLeUserlg('ZY_USERLGI',1),15))
			cCopia      := alltrim(PswRet()[1,14]) + space(100)
			cCopia		:= iif(cCopia == alltrim(cRecebe),'',cCopia)
		EndIf
		PswOrder(1)
		PswSeek(__cUserId)
		
		DbSkip()
		IncRegua()
		
	EndDo
	nLin := iif(TRB->ZY_FILIAL <> left(_cChave,2),100, nLin+1)
	
EndDo

_cCorpo += '</h3></font>'
_cCorpo += '</head></pre>'
_cCorpo += '<body bgcolor = white text=black  >'
_cCorpo += '<hr width=100% noshade>'

If _lEmail
	Email()
ElseIf aReturn[5]==1
	OurSpool(wnrel)
	MS_FLUSH()
Endif

DbCloseArea()

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Email()
///////////////////////

Enter       := chr(13)
cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
cEnvia    	:= Pswret()[1,14]
cAssunto  	:= "Perdas da Loja"

Do While empty(cRecebe)
	_nOk := 0
	DEFINE MSDIALOG oDlg TITLE 'Perdas em Lojas - email detinatário' FROM C(0),C(0) TO C(200),C(300) PIXEL
	
	@ C(009),C(006) Say "Loja" 					Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(009),C(025) Say Alltrim(_cFilial + ' - ' + _cNomeFil) 	Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(025),C(006) Say "eMail"              		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(025),C(025) Get cRecebe			Size C(115),C(009) COLOR CLR_BLACK  PIXEL OF oDlg
	@ C(050),C(050) Button "Ok" 		Size C(037),C(012) PIXEL OF oDlg ACTION(_nOk := 1,oDlg:End())
	@ C(050),C(100) Button "Cancelar" 	Size C(037),C(012) PIXEL OF oDlg ACTION(_nOk := 2,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED valid _nOk > 0
	
	If _nOk == 2
		Return()
	EndIf
	
	DbSelectArea('SA1')
	If DbSeek(xFilial('SA1') + _cCod + _cFilial,.f.)
		If empty(SA1->A1_EMAIL) .and.  RecLock('SA1',.f.)
			SA1->A1_EMAIL := cRecebe
			MsUnLock()
		EndIf
	EndIf
	DbSelectArea('TRB')
EndDo

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
	
	If empty(cCopia)
		SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY _cCorpo RESULT lEnviado
	Else
		SEND MAIL FROM cEnvia TO cRecebe CC cCopia SUBJECT cAssunto BODY _cCorpo RESULT lEnviado
	EndIf
	
	If !lEnviado
		_cErros += _cFilial + ', '
		cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
		GET MAIL ERROR cHtml
	Else
		DISCONNECT SMTP SERVER
	Endif
	
Else
	
	_cErros += _cFilial + ', '
	Conout( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
Endif

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZYVLCOD()
////////////////////////
Local _lRet := .t.

If SB1->B1_MSBLQL == '1'
	_lRet := .f.
	MsgBox('Produto está bloqueado. Não pode ser utilizado.' ,'ATENÇÃO!!!','ALERT')
EndIf
/*
If _lRet .and. Posicione('SB2',1,xFIlial('SB2')+M->ZY_COD + '01','B2_QATU') <= 0
_lRet := .f.
MsgBox('Produto com saldo zerado ou negativo na loja' + _cEnter + _cEnter + 'Corrija o estoque antes de apontar as perdas','ATENÇÃO!!!','ALERT')
EndIf
*/
/*
SD1->(DbSetOrder(2))
If _lRet .and. !SD1->(DbSeek(xFilial('SD1') + M->ZY_COD,.f.))
_lRet := .f.
MsgBox('Produto não deu entrada na loja' ,'ATENÇÃO!!!','ALERT')
EndIf
*/
Return(_lRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZYBLQ()
////////////////////////
_cMotivo := space(10)
DEFINE MSDIALOG oDlg TITLE 'Bloqueio de lançamento de perdas automático' FROM C(0),C(0) TO C(200),C(300) PIXEL
@ C(009),C(006) Say "Motivo do  bloqueio" 	Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(025),C(025) Get _oMotivo var _cMotivo	memo	Size C(115),C(030) COLOR CLR_BLACK  PIXEL OF oDlg
@ C(060),C(050) Button "Ok" 		Size C(037),C(012) PIXEL OF oDlg ACTION(_nOk := 1,oDlg:End())
@ C(060),C(100) Button "Cancelar" 	Size C(037),C(012) PIXEL OF oDlg ACTION(_nOk := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED valid _nOk > 0

If _nOk == 1
	
	U_LS_FILTRO('SZY',"ZY_STATUS < '4'")
	
	DbSetOrder(1)
	DbGoTop()
	Do While !eof()
		RecLock('SZY',.f.)
		SZY->ZY_STATUS := '4'
		SZY->ZY_COMPLEM := alltrim(SZY->ZY_COMPLEM) + _cEnter + _cMotivo
		MsUnLock()
		DbSkip()
	EndDo
	set filter to
	DbGoTop()
	
EndIf

Return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function VldDtZY()

lRet := .T.

IF !EMPTY(M->ZY_COD)

	_cQuery := "SELECT COUNT(*) AS FECHADO "
	_cQuery += _cEnter + " FROM " + RetSqlName('SB9') + " SB9 (NOLOCK) "
	_cQuery += _cEnter + " WHERE B9_COD 		= '"+M->ZY_COD+"' "
	_cQuery += _cEnter + " AND B9_DATA 			>= '"+DTOS(M->ZY_DTPERDA)+"' "
	_cQuery += _cEnter + " AND B9_LOCAL 		= '01' "
	_cQuery += _cEnter + " AND SB9.D_E_L_E_T_	= '' "
	_cQuery += _cEnter + " AND B9_FILIAL	= '"+M->ZY_FILIAL+"' "
	
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	EndIf

	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
	
	IF TRB->FECHADO > 0
		MsgBox('Período fechado para lançamento!'+_cEnter+'Entre em contato com o setor responsável.' ,'ATENÇÃO!!!','ALERT')
		lRet := .F.
	ENDIF
	
ENDIF

Return lRet	
