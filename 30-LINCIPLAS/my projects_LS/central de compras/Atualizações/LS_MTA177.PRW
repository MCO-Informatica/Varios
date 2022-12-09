#include "ap5mail.ch"
#include "sigawin.ch"
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS_MTA177 ºAutor  ³Alexandre Dalpiaz º Data ³  08/11/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³    MANUTENÇÃO DOS CALCULOS DA CENTRAL DE COMPRAS           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LaSelva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LS_MATA177()


Local aArea  		:= GetArea()
Local cAlias  		:= "AIE"
Local aCores  		:= {}

_cPa6DtRom 			:= '20121231'
_cFornece  			:= ''

_nRecSM0 			:= SM0->(Recno())

_cFilOri  			:= _cFiliais := _cGrupo    := _cProduto :=  _cFiltro := _cQuery1 := _cQuery2 := _cQuery3 := _cQuery4 := _cQuery5 := _cQuery6 := ''
_cFiliais 			:= _cFilOri  := _cPa6DtRom := _cFornece := ''
_cSalPedi 			:= CriaTrab(,.f.)

Private aRotina    	:= {}
Private cCadastro  	:= "Central de Compras - Manutenção"
Private aLegenda   	:= {}
Private aCores     	:= {}
nOpca 				:= 0
_cFilOri 			:= cFilAnt

ConOut("*** LA SELVA - User FUnction - LS_MATA177 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

aAdd(aLegenda, {'BR_AZUL'		,'Sem Fornecedor/Loja/Dt Entrega ou Preço Zerado' 		, '3'	})
aAdd(aLegenda, {'BR_VERDE'	  	,'Pendente'		, '1'	})
aAdd(aLegenda, {'BR_VERMELHO'	,'Gerado' 		, '3'	})

If (cEmpAnt + cFilAnt $ '0101/0155')  //filiais que podem rodar calculo de reposicao de compras ou estoque
	aAdd(aLegenda, {'BR_PRETO'	,'Romaneio de reposição' 		, '3'	})
	aAdd(aCores,{ "!(AIE_MSFIL $ '0101/0155') " , 'BR_PRETO'		}) // PEDIDO DE COMPRAS
	Public _cFilBrow	:= "AIE_MSFIL = AIE_FILCEN"
Else
	aAdd(aCores,{ "(empty(AIE_CODFOR) .or. empty(AIE_LOJFOR) .or. AIE_UPRC == 0 .or. empty(AIE_ENTREG)) .and. AIE_TIPO == 'CL'" , 'BR_AZUL'    	}) // SEM FORNECEDOR
	aAdd(aCores,{ "(AIE_MSFIL $ '0101/0155') " , 'BR_PRETO'		}) // PEDIDO DE VENDAS
	aAdd(aLegenda, {'BR_PRETO'	,'Pedido de compras' 		, '3'	})
	Public _cFilBrow	:= "AIE_MSFIL = AIE_FILNEC"
EndIf

aAdd(aCores,{ "empty(AIE_PEDIDO) " 		, 'BR_VERDE'							}) // aberto
aAdd(aCores,{ "!empty(AIE_PEDIDO)" 		, 'BR_VERMELHO'							}) // ENCERRADO

aAdd(aRotina,{"Pesquisar" 				, "AxPesqui"				   		,0,1 })
aAdd(aRotina,{"Visualizar"  			, "AxVisual" 						,0,2 })
aAdd(aRotina,{"Incluir"  				, "AxInclui"						,0,3 })
aAdd(aRotina,{"Alterar"  				, "U_LS177Alt" 						,0,4 })
aAdd(aRotina,{"Deleta"  				, "U_LS177Del"			 			,0,5 })
aAdd(aRotina,{"Exclui Calc"				, "U_LS177Exc('C')"			 		,0,2 })
aAdd(aRotina,{"Exclui Pedidos"			, "U_LS177Exc('P')"			 		,0,2 })

If (cEmpAnt + cFilAnt $ '0101/0155')  //filiais que podem rodar calculo de reposicao de compras ou estoque
	aAdd(aRotina,{"Compras" 			, "U_LS177Calc('RC')"				,0,3 })
	aAdd(aRotina,{"Reposição"			, "U_LS177Calc('RE')"				,0,3 })
Else								// filiais que podem rodas calculo de compras
	aAdd(aRotina,{"Compras Lojas"		, "U_LS177Calc('CL')"		 		,0,3 })
	aAdd(aRotina,{"Datas de Entrega"	, "U_LS177Entr()"					,0,3 })
	aAdd(aRotina,{"Atualiza Prc/Forn"	, "U_LS177PrF()"					,0,3 })
EndIf
aAdd(aRotina,{"Consulta Laselva"		, "U_COMP001(AIE->AIE_CODPRO)"		,0,2 })
aAdd(aRotina,{"Consulta Pedidos"		, "U_LS177VPed"						,0,2 })
If (cEmpAnt + cFilAnt $ '0101/0155')  //filiais que podem rodar calculo de reposicao de compras ou estoque
	aAdd(aRotina,{"Gera PVs"			, "U_LS177Calc('PV')"	   			,0,2 })
	aAdd(aRotina,{"Romaneios"			, "U_LS177Rom"			   			,0,3 })
	aAdd(aRotina,{"Imprime" 			, "U_LS177PCl"			   			,0,3 })  // imprime calculo
Else
	aAdd(aRotina,{"Gera PCs"			, "U_LS177Calc('PC')"				,0,2 })
	aAdd(aRotina,{'Imp Cálculo'			, 'U_LS177PCl()'					,0,2 })
	aAdd(aRotina,{'eMail Pedidos'		, 'U_LS177MPC()'					,0,2 })
EndIf
aAdd(aRotina,{ 'Selecionar Produtos' 	, 'U_LS_177Pro()'		  			,0,3 })
aAdd(aRotina,{ 'Filtro' 				, 'U_LS_FILTRO("AIE",_cFilBrow)'	,0,3 })
aAdd(aRotina,{"Legenda"  				, "U_LS177Leg"						,0,3 })

_cQuery := "DELETE FROM " + RetSqlName('AIE')
_cQuery += " WHERE AIE_DTCALC < '" + dtos(date()-30) + "'"
TcSqlExec(_cQuery)

ACC := {}

DbSelectArea('AIE')

Set Filter to &_cFilBrow

//mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)
mBrowse( 7, 4,20,74,'AIE',ACC,,,,,aCores)

Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// alteracao
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177Alt()
////////////////////////
ConOut("*** LA SELVA - User FUnction - LS177ALT - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If AIE->AIE_MSFIL $ '01/55' .and. !(cEmpAnt + _cFilOri $ '0101/0155')  //filiais que podem rodar reposicao de compras ou de estoque
	MsgAlert('Alteração permitida somente na Matriz e CD da Laselva','Central de Compras')
	Return()
EndIf
If !(AIE->AIE_MSFIL $ '01/55') .and. (cEmpAnt + _cFilOri $ '0101/0155')  //filiais que não podem rodar necessidades de compras
	MsgAlert('Alteração permitida somente na Filiais','Central de Compras')
	Return()
EndIf

If empty(AIE->AIE_PEDIDO)
	AxAltera("AIE",AIE->(Recno()), 4)
Else
	MsgBox('Pedido já gerado para esse cálculo, não pode ser alterado','ATENÇÃO!!!','ALERT')
EndIf

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// deleta
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177Del()
////////////////////////

ConOut("*** LA SELVA - User FUnction - LS177DEL - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If AIE->AIE_MSFIL $ '01/55' .and. !(cEmpAnt + _cFilOri $ '0101/0155')  //filiais que podem rodar reposicao de compras ou de estoque
	MsgAlert('Exclusão permitida somente na Matriz e CD da Laselva','Central de Compras')
	Return()
EndIf
If !(AIE->AIE_MSFIL $ '01/55') .and. (cEmpAnt + _cFilOri $ '0101/0155')  //filiais que não podem rodar necessidades de compras
	MsgAlert('Exclusão permitida somente na Filiais','Central de Compras')
	Return()
EndIf

If empty(AIE->AIE_PEDIDO)
	AxDeleta('AIE',AIE->(RecNo()), 5)
Else
	MsgBox('Pedido já gerado para esse cálculo, não pode ser excluido','ATENÇÃO!!!','ALERT')
EndIf

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// legenda
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177LEG()
////////////////////////

ConOut("*** LA SELVA - User FUnction - LS177LEG - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

BrwLegenda("Chamados" , 'Legenda' , aLegenda)
Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// CONSULTA PEDIDOS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177VPed()
////////////////////////

ConOut("*** LA SELVA - User FUnction - LS177VPED - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If empty(AIE->AIE_PEDIDO)
	MsgAlert('Pedido não gerado','ATENÇÃO!!!')
	Return()
EndIf

If (cEmpAnt + cFilAnt $ '0101/0155')  //filiais que podem rodar calculo de reposicao de compras ou estoque
	DbSelectArea('SC5')
	If !DbSeek(AIE->AIE_FILCEN + AIE->AIE_PEDIDO,.f.)
		MsgAlert('Pedido não localizado','ATENÇÃO!!!')
		Return()
	EndIf
	A410Visual('SC5',Recno(),2)
Else
	l120Auto  	:= .f.
	nTipoPed  	:= 1
	cCadastro 	:= 'Pedidos de Compras
	_cFilAnt 	:= cFilAnt
	_cNumEmp 	:= cNumEmp
	cFilAnt 	:= AIE->AIE_MSFIL
	cNumEmp 	:= cEmpAnt + AIE->AIE_MSFIL
	DbSelectArea('SC7')
	If !DbSeek(AIE->AIE_MSFIL + AIE->AIE_PEDIDO,.f.)
		MsgAlert('Pedido não localizado','ATENÇÃO!!!')
		Return()
	EndIf
	A120Pedido('SC7',Recno(),2,,.F.,.T.)
	cFilAnt 	:= _cFilAnt
	cNumEmp 	:= _cNumEmp
EndIf
DbSelectArea('AIE')

Return()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177PCl()
////////////////////////
ConOut("*** LA SELVA - User FUnction - LS177PCL - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

cDesc1        		:= "Este programa tem como objetivo imprimir relatorio "
cDesc2        		:= "com os resultados dos calculos de necessidades gerados a   "
cDesc3        		:= "partir da rotina 'Central de Compras'"
cTitulo       		:= "Calculo de Necessidades - Central de Compras"
nLin          		:= 80

Private aOrd        := {}
Private aReturn     := { "Zebrado",1,"Administracao", 2, 2, 1, '', 1} //--"Zebrado"#"Administracao"
Private cString     := 'SB1'
Private cNomeprog   := CriaTrab(Nil, .F.)
Private lEnd        := .F.
Private lAbortPrint := .F.
Private m_pag       := 01
Private nLimite     := 220
Private nTipo       := 18
Private nLastKey    := 0
Private Tamanho     := 'G'
Private wnrel       := 'LS_MTA177'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,'',@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

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
Static Function RunReport( lEnd)
////////////////////////////////
Local cLinha  := ''
Local nQtdNec := 0
Local nPos    := 0

ConOut("*** LA SELVA - Static FUnction - RUNREPORT - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   resumo dos pedidos
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_cQuery := "SELECT AIE_MSFIL, AIE_NUM, AIE_PEDIDO, AIE_FILNEC, AIE_FILCEN, COUNT(*) QUANTIDADE, AIE_DTCALC, AIE_USERGI, AIE_CLIENT, AIE_LOJFOR, AIE_CODFOR,"
_cQuery += _cEnter + "ISNULL(A1_NREDUZ,'') A1_NREDUZ, ISNULL(A2_NREDUZ,'') A2_NREDUZ"
_cQuery += _cEnter + "FROM " + RetSqlNAme('AIE') + " AIE (NOLOCK) "

_cQuery += _cEnter + "LEFT JOIN " + RetSqlNAme('SA1') + " SA1 (NOLOCK) "
_cQuery += _cEnter + "ON A1_LOJA 			= AIE_FILNEC"
_cQuery += _cEnter + "AND A1_COD 			< '000010'"
_cQuery += _cEnter + "AND SA1.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + "LEFT JOIN " + RetSqlNAme('SA2') + " SA2 (NOLOCK) "
_cQuery += _cEnter + "ON A2_LOJA 			= AIE_LOJFOR"
_cQuery += _cEnter + "AND A2_COD 			= AIE_CODFOR"
_cQuery += _cEnter + "AND SA2.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + "WHERE AIE.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND AIE_NUM 			= '" + AIE->AIE_NUM + "'"
_cQuery += _cEnter + "GROUP BY AIE_MSFIL, AIE_NUM, AIE_PEDIDO, AIE_FILNEC, AIE_FILCEN, AIE_DTCALC, AIE_USERGI, AIE_CLIENT, AIE_LOJFOR, AIE_CODFOR, A1_NREDUZ, A2_NREDUZ"
_cQuery += _cEnter + "ORDER BY AIE_NUM, AIE_FILNEC, AIE_PEDIDO"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)
TcSetField('_AIE','AIE_DTCALC','D',0)

count to _nLastRec
DbGoTop()
SetRegua( _nLastRec )

cCabec1 := 'Calculo nro: ' + _AIE->AIE_NUM + '   em: ' + dtoc(_AIE->AIE_DTCALC) + '    Usuario: ' + left(FWLeUserlg('AIE_USERGI',1),15)
cCabec2 := 'Filial Centralizadora: ' + _AIE->AIE_MSFIL + ' - ' + fBuscaCpo('SM0',1, cFilAnt + _AIE->AIE_MSFIL,'M0_FILIAL')
SM0->(DbGoTo(_nRecSM0))

Do While !eof()
	If lAbortPrint .Or. lEnd
		@ 000,000 PSay "***CANCELADO PELO OPERADOR!"
		Exit
	EndIf
	
	If nLin > 55
		nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
		@ ++nLin,00 pSay 'Cliente                           Fornecedor                    Pedido   Qtde'
		@ ++nLin,00 pSay '                                                                 Venda  Itens'
		@ ++nLin,00 pSay __PrtFatLine()
	EndIf
	
	_cLinha := _AIE->AIE_CLIENT + '/' + _AIE->AIE_FILNEC + ' - ' + _AIE->A1_NREDUZ + ' '
	_cLinha += _AIE->AIE_CODFOR + '/' + _AIE->AIE_LOJFOR + ' - ' + _AIE->A2_NREDUZ + ' '
	_cLinha += _AIE->AIE_PEDIDO + '   ' + str(_AIE->QUANTIDADE,4)
	
	@ ++nLin, 000 PSAY _cLinha
	
	DbSkip()
	IncRegua()
	
EndDo

nLin := 100

DbCloseArea()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// resumido por produto
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_cQuery := "SELECT AIE_MSFIL, AIE_NUM, AIE_FILCEN, SUM(AIE_NECDIG) AIE_NECDIG, SUM(AIE_NECESS) AIE_NECESS, AIE_SLDCEN AIE_SLDCEN, AIE_DTCALC, AIE_USERGI, "
_cQuery += _cEnter + "SUM(AIE_EMAX) AIE_EMAX, AIE_LOJFOR, AIE_CODFOR, AIE_CODPRO, B1_DESC, ISNULL(A2_NREDUZ,'') A2_NREDUZ"

_cQuery += _cEnter + "FROM " + RetSqlNAme('AIE') + " AIE (NOLOCK) "

_cQuery += _cEnter + "INNER JOIN " + RetSqlNAme('SB1') + " SB1 (NOLOCK) "
_cQuery += _cEnter + "ON B1_COD 				= AIE_CODPRO"
_cQuery += _cEnter + "AND SB1.D_E_L_E_T_		= ''"

_cQuery += _cEnter + "LEFT JOIN " + RetSqlNAme('SA2') + " SA2 (NOLOCK) "
_cQuery += _cEnter + "ON A2_LOJA 				= AIE_LOJFOR"
_cQuery += _cEnter + "AND A2_COD 				= AIE_CODFOR"
_cQuery += _cEnter + "AND SA2.D_E_L_E_T_ 		= ''"

_cQuery += _cEnter + "WHERE AIE.D_E_L_E_T_ 		= ''"
_cQuery += _cEnter + "AND AIE_MSFIL 			= '" + AIE->AIE_MSFIL + "'"
_cQuery += _cEnter + "AND AIE_NUM 				= '" + AIE->AIE_NUM + "'"
_cQuery += _cEnter + "GROUP BY AIE_MSFIL, AIE_NUM, AIE_FILCEN, AIE_NECDIG, AIE_DTCALC, AIE_USERGI, AIE_LOJFOR, AIE_CODFOR, B1_DESC, A2_NREDUZ, AIE_CODPRO, AIE_SLDCEN"
_cQuery += _cEnter + "ORDER BY AIE_NUM, AIE_CODPRO"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)
TcSetField('_AIE','AIE_DTCALC','D',0)

count to _nLastRec
DbGoTop()
SetRegua( _nLastRec )

cCabec1 := 'Calculo nro: ' + _AIE->AIE_NUM + '   em: ' + dtoc(_AIE->AIE_DTCALC) + '    Usuario: ' + left(FWLeUserlg('AIE_USERGI',1),15)
cCabec2 := 'Filial Centralizadora: ' + _AIE->AIE_MSFIL + ' - ' + fBuscaCpo('SM0',1, cFilAnt + _AIE->AIE_MSFIL,'M0_FILIAL')
SM0->(DbGoTo(_nRecSM0))
Do While !eof()
	If lAbortPrint .Or. lEnd
		@ 000,000 PSay "***CANCELADO PELO OPERADOR!"
		Exit
	EndIf
	
	If nLin > 55
		nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
		@ ++nLin,00 pSay 'Produto         Descricao                                                                                            Estoque Necess. Necess.   Saldo Fornecedor'
		@ ++nLin,00 pSay '                                                                                                                      Maximo  Calcul. Digitad Central'
		@ ++nLin,00 pSay __PrtFatLine()
	EndIf
	
	_cLinha := _AIE->AIE_CODPRO + ' ' + _AIE->B1_DESC + ' ' + tran(_AIE->AIE_EMAX,'@E 999,999') + ' '
	_cLinha += tran(_AIE->AIE_NECESS,'@E 999,999') + ' ' + tran(_AIE->AIE_NECDIG,'@E 999,999') + ' ' + tran(_AIE->AIE_SLDCEN,'@E 999,999') + ' '
	_cLinha += _AIE->AIE_CODFOR + '/' + _AIE->AIE_LOJFOR + ' ' + _AIE->A2_NREDUZ
	
	@ ++nLin, 000 PSAY _cLinha
	
	DbSkip()
	IncRegua()
	
EndDo

DbCloseArea()
nLin := 100

DbCloseArea()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// analitico
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//_cQuery := "SELECT AIE.*, B1_DESC, ISNULL(A2_NREDUZ,'') A2_NREDUZ, B2_SALPEDI"
_cQuery := "SELECT AIE.*, B1_DESC, ISNULL(A2_NREDUZ,'') A2_NREDUZ, (CASE WHEN B2_XTRANSI < 0 THEN 0 ELSE B2_XTRANSI END)"
_cQuery += _cEnter + "FROM " + RetSqlNAme('AIE') + " AIE (NOLOCK) "

_cQuery += _cEnter + "LEFT JOIN " + RetSqlNAme('SA2') + " SA2 (NOLOCK) "
_cQuery += _cEnter + "ON A2_LOJA 				= AIE_LOJFOR"
_cQuery += _cEnter + "AND A2_COD 				= AIE_CODFOR"
_cQuery += _cEnter + "AND SA2.D_E_L_E_T_ 		= ''"

_cQuery += _cEnter + "INNER JOIN " + RetSqlNAme('SB1') + " SB1 (NOLOCK) "
_cQuery += _cEnter + "ON B1_COD 				= AIE_CODPRO"
_cQuery += _cEnter + "AND SB1.D_E_L_E_T_ 		= ''"

_cQuery += _cEnter + "INNER JOIN " + RetSqlNAme('SB2') + " SB2 (NOLOCK) "
_cQuery += _cEnter + "ON SB2.D_E_L_E_T_ 		= ''"
_cQuery += _cEnter + "AND B2_COD 				= AIE_CODPRO"
_cQuery += _cEnter + "AND B2_FILIAL 			= AIE_FILNEC"
_cQuery += _cEnter + "AND B2_LOCAL 				= '01'"

_cQuery += _cEnter + "WHERE AIE.D_E_L_E_T_ 		= ''"
_cQuery += _cEnter + "AND AIE_MSFIL 			= '" + AIE->AIE_MSFIL + "'"
_cQuery += _cEnter + "AND AIE_NUM 				= '" + AIE->AIE_NUM + "'"
_cQuery += _cEnter + "ORDER BY AIE_NUM, AIE_PEDIDO"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)
TcSetField('_AIE','AIE_DTCALC','D',0)

count to _nLastRec
DbGoTop()
SetRegua( _nLastRec )

cCabec1 := 'Calculo nro: ' + _AIE->AIE_NUM + '   em: ' + dtoc(_AIE->AIE_DTCALC) + '    Usuario: ' + left(FWLeUserlg('AIE_USERGI',1),15)
cCabec2 := 'Filial Centralizadora: ' + _AIE->AIE_MSFIL + ' - ' + fBuscaCpo('SM0',1, cEmpAnt + _AIE->AIE_MSFIL,'M0_FILIAL') + '    '
cCabec2 += 'Filial Destino: ' + _AIE->AIE_FILNEC + ' - ' + fBuscaCpo('SM0',1, cEmpAnt + _AIE->AIE_FILNEC,'M0_FILIAL')
SM0->(DbGoTo(_nRecSM0))
Do While !eof()
	If lAbortPrint .Or. lEnd
		@ 000,000 PSay "***CANCELADO PELO OPERADOR!"
		Exit
	EndIf
	
	If nLin > 55
		nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
		@ ++nLin,00 pSay 'Produto         Descricao                                                                                            Estoque Necess. Necess.   Saldo Transito Fornecedor                     Pedido'
		@ ++nLin,00 pSay '                                                                                                                      Maximo Calcul. Digitad Central                                         Venda'
		@ ++nLin,00 pSay __PrtFatLine()
	EndIf
	
	_cLinha := _AIE->AIE_CODPRO + ' ' + _AIE->B1_DESC + ' ' + tran(_AIE->AIE_EMAX,'@E 999,999') + ' '   
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
//	_cLinha += tran(_AIE->AIE_NECESS,'@E 999,999') + ' ' + tran(_AIE->AIE_NECDIG,'@E 999,999') + ' ' + tran(_AIE->AIE_SLDCEN,'@E 999,999') + '  ' + tran(_AIE->B2_SALPEDI,'@E 999,999') + ' '
	_cLinha += tran(_AIE->AIE_NECESS,'@E 999,999') + ' ' + tran(_AIE->AIE_NECDIG,'@E 999,999') + ' ' + tran(_AIE->AIE_SLDCEN,'@E 999,999') + '  ' + tran(_AIE->B2_XTRANSI,'@E 999,999') + ' '
	_cLinha += _AIE->AIE_CODFOR + '/' + _AIE->AIE_LOJFOR + ' ' + _AIE->A2_NREDUZ + ' ' +_AIE->AIE_PEDIDO
	
	@ ++nLin, 000 PSAY _cLinha
	
	DbSkip()
	IncRegua()
	
EndDo

DbCloseArea()

If aReturn[5]==1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// exclui calculo e pedidos
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177Exc(_xTipo)
//////////////////////////////
ConOut("*** LA SELVA - User FUnction - LS177EXC - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If AIE->AIE_MSFIL $ '01/55' .and. !(cEmpAnt + _cFilOri $ '0101/0155')  //filiais que podem rodar reposicao de compras ou de estoque
	MsgAlert('Exclusão permitida somente na Matriz e CD da Laselva','Central de Compras')
	Return()
EndIf
If !(AIE->AIE_MSFIL $ '01/55') .and. (cEmpAnt + _cFilOri $ '0101/0155')  //filiais que não podem rodar necessidades de compras
	MsgAlert('Exclusão permitida somente nas Filiais','Central de Compras')
	Return()
EndIf

If AIE->AIE_TIPO == 'CL'
	_cQuery := "SELECT COUNT(*) TOTAL"
	_cQuery += _cEnter + " FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"
	_cQuery += _cEnter + " ON C7_NUM 			= AIE_PEDIDO"
	_cQuery += _cEnter + " AND C7_FILIAL 		= AIE_MSFIL"
	_cQuery += _cEnter + " AND C7_QUJE 			= 0"
	_cQuery += _cEnter + " AND SC7.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " WHERE AIE_NUM 		= '" + AIE->AIE_NUM + "'"
	_cQuery += _cEnter + " AND AIE.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND AIE_DTCALC 		= '" + dtos(AIE->AIE_DTCALC) + "'"
	_cQuery += _cEnter + " AND AIE_FILNEC 		= AIE_MSFIL"
Else
	_cQuery := "SELECT COUNT(*) TOTAL"
	_cQuery += _cEnter + " FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC6') + " SC6 (NOLOCK)"
	_cQuery += _cEnter + " ON C6_NUM 			= AIE_PEDIDO"
	_cQuery += _cEnter + " AND C6_FILIAL 		= AIE_MSFIL"
	_cQuery += _cEnter + " AND C6_QTDENT 		= 0"
	_cQuery += _cEnter + " AND SC6.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " WHERE AIE_NUM 		= '" + AIE->AIE_NUM + "'"
	_cQuery += _cEnter + " AND AIE.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND AIE_DTCALC 		= '" + dtos(AIE->AIE_DTCALC) + "'"
	_cQuery += _cEnter + " AND AIE_MSFIL 		= '" + AIE->AIE_MSFIL + "'"
EndIf

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)
_nTotal := _AIE->TOTAL
DbCloseArea()

If _nTotal == 0
	MsgBox('Cálculo não poderá ser excluído, pois um ou mais pedidos já foram faturados.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

_cQuery := "SELECT COUNT(*) TOTAL FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
_cQuery1 := _cEnter + " WHERE AIE_NUM 			= '" + AIE->AIE_NUM + "'"
_cQuery1 += _cEnter + " AND AIE.D_E_L_E_T_ 		= ''"
_cQuery1 += _cEnter + " AND AIE_DTCALC 			= '" + dtos(AIE->AIE_DTCALC) + "'"
If AIE->AIE_TIPO == 'CL'
	_cQuery1 += _cEnter + " AND AIE_FILNEC 		= AIE_MSFIL"
Else
	_cQuery1 += _cEnter + " AND AIE_MSFIL 		= '" + AIE->AIE_MSFIL + "'"
EndIf
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery+=_cQuery1), '_AIE', .F., .T.)
_nTotal := _AIE->TOTAL
DbCloseArea()

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery + " AND AIE_PEDIDO = ''"), '_AIE', .F., .T.)
_nSemPed := _AIE->TOTAL
DbCloseArea()

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery + " AND AIE_PEDIDO <> ''"), '_AIE', .F., .T.)
_nComPed := _AIE->TOTAL
DbCloseArea()

_cTexto := ''
If _nTotal > 0
	_cTexto += 'Total de itens calculados: ' + alltrim(str(_nTotal)) + _cEnter
EndIf
If _nComPed > 0
	_cTexto += 'Foi(ram) gerado(s) ' + alltrim(str(_nComPed)) + ' pedido(s) de venda' + _cEnter
EndIf
If _nSemPed > 0
	_cTexto += 'Não foi(ram) gerado(s) pedido(s) de venda para ' + alltrim(str(_nSemPed)) + ' itens' + _cEnter
EndIf
_cTexto += _cEnter + 'Serão excluidos TODOS os itens do cálculo (inclusive os pedidos de venda e romaneios)?'
_cQuery2 := ''
If _xTipo == 'C'
	If AIE->AIE_TIPO == 'PV'
		_nOpc := Aviso('Central de Compras',_cTexto,{'Exclui Tudo','Sem Pedido','Cancelar'},3,'Exclusão de Cálculo ' + AIE->AIE_NUM)
	Else
		_nOpc := Aviso('Central de Compras',_cTexto,{'Exclui Tudo','Sem Pedido','Sem Fornec','Sem Custo','Loja ' + AIE->AIE_FILNEC,'Cancelar'},3,'Exclusão de Cálculo ' + AIE->AIE_NUM)
		If _nOpc == 3
			_cQuery2 += _cEnter + " AND AIE_CODFOR = ''"
		ElseIf _nOpc == 4
			_cQuery2 += _cEnter + " AND AIE_UPRC = 0"
		ElseIf _nOpc == 5
			_cQuery2 += _cEnter + " AND AIE_FILNEC = '" + AIE->AIE_FILNEC + "'"
		EndIf
	EndIf
Else
	_nOpc := Aviso('Central de Compras',_cTexto,{'Exclui Tudo','Pedido ' + AIE->AIE_PEDIDO,'Loja ' + AIE->AIE_MSFIL,'Forn ' + AIE->AIE_CODFOR,'Cancelar'},3,'Exclusão de Pedidos de ' +  iif(AIE->AIE_TIPO == 'CL','Compras','Vendas') + ' - Cálculo: ' + AIE->AIE_NUM)
	If _nOpc == 2
		_cQuery1 += _cEnter + " AND AIE_PEDIDO = '" + AIE->AIE_PEDIDO + "'"
	ElseIf _nOpc == 3
		_cQuery1 += _cEnter + " AND AIE_FILNEC = '" + AIE->AIE_FILNEC + "'"
	ElseIf _nOpc == 3
		_cQuery1 += _cEnter + " AND AIE_CODFOR = '" + AIE->AIE_CODFOR + "'"
	EndIf
EndIf

If (_xTipo == 'C' .and. _nOpc == 1) .or. (_xTipo == 'P' .and. _nOpc > 1 .and. !empty(AIE->AIE_PEDIDO))
	
	_nExec := 0
	
	_cQuery := "UPDATE " + RetSqlName('SB2')
	_cQuery += _cEnter + "SET B2_RESERVA = B2_RESERVA - AIE_NECDIG" // RESERVA
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + _cQuery1
	_cQuery += _cEnter + " AND B2_COD 		= AIE_CODPRO"
	_cQuery += _cEnter + " AND B2_LOCAL 	= '01'"
	_cQuery += _cEnter + " AND B2_FILIAL 	= AIE_FILCEN"
	_cQuery += _cEnter + " AND AIE_PEDIDO 	<> ''"
	_cQuery += _cEnter + " AND " + RetSqlName('SB2') + ".D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)

/* RESERVA FILIAL*/

If !empty(AIE->AIE_PEDIDO)
	_cQuery := "SELECT AIE_CODPRO,AIE_FILNEC, AIE_NECDIG,AIE_NUM "
	_cQuery += _cEnter + " FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC6') + " SC6 (NOLOCK)"
	_cQuery += _cEnter + " ON C6_NUM 			= AIE_PEDIDO"
	_cQuery += _cEnter + " AND C6_FILIAL 		= AIE_MSFIL"
	_cQuery += _cEnter + " AND C6_QTDENT 		= 0"
	_cQuery += _cEnter + " AND SC6.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " WHERE AIE_NUM 		= '" + AIE->AIE_NUM + "'"
	_cQuery += _cEnter + " AND AIE.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " AND AIE_DTCALC 		= '" + dtos(AIE->AIE_DTCALC) + "'"
	_cQuery += _cEnter + " AND AIE_MSFIL 		= '" + AIE->AIE_MSFIL + "'"


DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_RESER', .F., .T.)

	While !_RESER->( EOF() ) 

	_cQuery := "UPDATE " + RetSqlName('SB2')
	_cQuery += _cEnter + "SET B2_XRESERV = B2_XRESERV - " + CVALTOCHAR(_RESER->AIE_NECDIG) // RESERVA
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	//_cQuery += _cEnter + _cQuery1
	_cQuery += _cEnter + "  B2_COD 		= '"+ _RESER->AIE_CODPRO+"' "
	_cQuery += _cEnter + " AND B2_LOCAL 	= '01'"
	_cQuery += _cEnter + " AND B2_FILIAL 	= '" +_RESER->AIE_FILNEC +"' "
	_cQuery += _cEnter + " AND AIE_PEDIDO   = '"+ _RESER->AIE_NUM +"' "
	_cQuery += _cEnter + " AND " + RetSqlName('SB2') + ".D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)       
	
			_RESER->( DbSkip() )
		EndDo	
ENDIF
		
	_cQuery := "UPDATE " + RetSqlName('SC5')
	_cQuery += _cEnter + "SET " + RetSqlName('SC5') + ".D_E_L_E_T_ = '*', " + RetSqlName('SC5') + ".R_E_C_D_E_L_ = " + RetSqlName('SC5') + ".R_E_C_N_O_"
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + _cQuery1
	_cQuery += _cEnter + " AND C5_NUM 		= AIE_PEDIDO"
	_cQuery += _cEnter + " AND C5_FILIAL 	= AIE_MSFIL"
	_cQuery += _cEnter + " AND " + RetSqlName('SC5') + ".D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('SC6')
	_cQuery += _cEnter + "SET " + RetSqlName('SC6') + ".D_E_L_E_T_ = '*', " + RetSqlName('SC6') + ".R_E_C_D_E_L_ = " + RetSqlName('SC6') + ".R_E_C_N_O_"
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + _cQuery1
	_cQuery += _cEnter + " AND C6_NUM 		= AIE_PEDIDO"
	_cQuery += _cEnter + " AND C6_FILIAL 	= AIE_MSFIL"
	_cQuery += _cEnter + " AND " + RetSqlName('SC6') + ".D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('SC9')
	_cQuery += _cEnter + "SET " + RetSqlName('SC9') + ".D_E_L_E_T_ = '*', " + RetSqlName('SC9') + ".R_E_C_D_E_L_ = " + RetSqlName('SC9') + ".R_E_C_N_O_"
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + _cQuery1
	_cQuery += _cEnter + " AND C9_PEDIDO 	= AIE_PEDIDO"
	_cQuery += _cEnter + " AND C9_FILIAL 	= AIE_MSFIL"
	_cQuery += _cEnter + " AND " + RetSqlName('SC9') + ".D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('PA6')
	_cQuery += _cEnter + "SET " + RetSqlName('PA6') + ".D_E_L_E_T_ = '*'"
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + _cQuery1
	_cQuery += _cEnter + " AND PA6_NUMROM 	= AIE_PEDIDO + AIE_FILCEN"
	_cQuery += _cEnter + " AND PA6_FILIAL 	= ''"
	_cQuery += _cEnter + " AND " + RetSqlName('PA6') + ".D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('PA7')
	_cQuery += _cEnter + "SET " + RetSqlName('PA7') + ".D_E_L_E_T_ = '*'"
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + _cQuery1
	_cQuery += _cEnter + " AND PA7_NUMROM 	= AIE_PEDIDO + AIE_FILCEN"
	_cQuery += _cEnter + " AND PA7_FILIAL 	= ''"
	_cQuery += _cEnter + " AND " + RetSqlName('PA7') + ".D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('SC7')
	_cQuery += _cEnter + "SET " + RetSqlName('SC7') + ".D_E_L_E_T_ = '*'"
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + _cQuery1
	_cQuery += _cEnter + " AND C7_NUM 		= AIE_PEDIDO"
	_cQuery += _cEnter + " AND C7_FILIAL 	= AIE_MSFIL"
	_cQuery += _cEnter + " AND " + RetSqlName('SC7') + ".D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('AIE')
	If _xTipo == 'C'
		_cQuery += _cEnter + "SET AIE010.D_E_L_E_T_ = '*'"
	Else
		_cQuery += _cEnter + "SET AIE_PEDIDO = ''"
	EndIf
	_cQuery += strtran(_cQuery1,'AIE.','AIE010.')
	TcSqlExec(_cQuery)
	
	If _xTipo == 'P'
		MsgInfo('Pedidos excluídos com sucesso','Central de Compras')
	Else
		MsgInfo('Cálculos e pedidos excluídos com sucesso','Central de Compras')
	EndIf
	
ElseIf _xTipo == 'C' .and. ((_nOpc == 2 .and. AIE->AIE_TIPO <> 'CL') .or. (_nOpc > 1 .and. _nOpc < 5 .and. AIE->AIE_TIPO == 'CL'))
	
	_cQuery := "DELETE " + RetSqlName('AIE')
	_cQuery += _cEnter + " WHERE AIE_NUM 	= '" + AIE->AIE_NUM + "'"
	_cQuery += _cEnter + " AND AIE_MSFIL 	= '" + AIE->AIE_MSFIL + "'"
	_cQuery += _cEnter + " AND AIE_PEDIDO 	= ''"
	_cQuery += _cQuery2
	TcSqlExec(_cQuery)
	MsgInfo('Cálculos excluídos com sucesso','Central de Compras')
	
Else
	
	MsgInfo('Nenhum ' + iif(_xTipo == 'C','cálculo','pedido') + ' excluido','Central de Compras')
	
EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS177CALC    												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LASELVA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LS177CALC(_xTipo)
///////////////////////////////
ConOut("*** LA SELVA - User FUnction - LS177CALC - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_cTipoCalc := _xTipo

If !(_cTipoCalc $ 'PC/PV')
	
	If _xTipo <> 'CL' .and. !(cEmpAnt + cFilAnt $ '0101/0155')  //filiais que podem rodar reposicao de compras ou de estoque
		MsgAlert('Rotina de Cálculo de Reposição pode ser utilizada apenas na Matriz e CD da Laselva','Central de Compras')
		Return()
	EndIf
	If _xTipo == 'CL' .and. (cEmpAnt + cFilAnt $ '0101/0155')  //filiais que não podem rodar necessidades de compras
		MsgAlert('Rotina de Cálculo de Compras pode ser utilizada apenas nas Lojas','Central de Compras')
		Return()
	EndIf
   if	!MATA177()
	 return()
	endif 
EndIf

_cQuery := "SELECT MAX(AIE_NUM) CALCULO, MAX(AIE_DTCALC) DATACALC, MAX(AIE_TIPO) AIE_TIPO"
_cQuery += _cEnter + " FROM " + RetSqlName('AIE') + " (NOLOCK)"
_cQuery += _cEnter + " WHERE AIE_PEDIDO 		= ''"

If (cEmpAnt + cFilAnt $ '0101/0155') .and. !(__cUserId $ GetMv('LA_PODER'))
	_cQuery += _cEnter + " AND upper(dbo.DESEMBARALHA(AIE_USERGI)) = '" + upper(cUserName) + "'"
EndIf

_cQuery += _cEnter + " AND D_E_L_E_T_ 			= ''"
_cQuery += _cEnter + " AND AIE_FILIAL 			= '" + xFilial("AIE") + "'"
If (cEmpAnt + cFilAnt $ '0101/0155')
	_cQuery += _cEnter + " AND AIE_FILCEN  		= '" + cFilAnt + "'"
	_cQuery += _cEnter + " AND AIE_TIPO 		IN ('','RE','RC','PV')"
Else
	_cQuery += _cEnter + " AND ((AIE_TIPO 		= ''   AND AIE_MSFIL = '" + cFilAnt + "')"
	_cQuery += _cEnter + " OR  ( AIE_TIPO 		= 'CL' AND AIE_MSFIL = AIE_FILNEC ))"
	
	_cQuery += _cEnter + " AND AIE_MSFIL 	NOT IN ('01','55')"
	//_cQuery += _cEnter + " AND AIE_FILNEC = AIE_MSFIL"
EndIf
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)

_nCalculo 	:= val(_AIE->CALCULO)

_cTipoCalc  := iif(empty(_AIE->AIE_TIPO),_cTipoCalc, _AIE->AIE_TIPO)

DbSelectArea('AIE')

Posicione('AIE',1,xFilial('AIE') + _AIE->CALCULO,'AIE_USERGI')
_cUser      := FWLeUserlg('AIE_USERGI',1)

DbSelectArea('_AIE')
DbCloseArea()

If empty(_nCalculo)
	Return()
EndIf

If _cTipoCalc $ 'PC/CL'
	
	_cQuery := "UPDATE " + RetSqlName('AIE')
	_cQuery += _cEnter + "SET AIE010.AIE_TIPO = 'CL', AIE010.AIE_MSFIL = AIE010.AIE_FILNEC, AIE_CODFOR = LEFT(FORNECEDOR,6), AIE_LOJFOR = SUBSTRING(FORNECEDOR,7,2),"
	_cQuery += _cEnter + "AIE010.AIE_UPRC = CONVERT(FLOAT,RIGHT(FORNECEDOR,10)), AIE_LSHORA = '" + left(Time(),2) + substr(Time(),4,2) + "',"
	
	_cQuery += _cEnter + "AIE010.AIE_QSEGUM = CEILING(CASE WHEN B1_TIPCONV = 'D' THEN AIE010.AIE_NECESS / CASE WHEN B1_CONV = 0 THEN 1 ELSE B1_CONV END ELSE AIE010.AIE_NECESS * B1_CONV END),"
	_cQuery += _cEnter + "AIE010.AIE_NECDIG = CASE WHEN B1_TIPCONV = 'D' THEN CEILING(CASE WHEN B1_TIPCONV = 'D' THEN AIE010.AIE_NECESS / CASE WHEN B1_CONV = 0 THEN 1 ELSE B1_CONV END  ELSE AIE010.AIE_NECESS * B1_CONV END) * B1_CONV ELSE "
	_cQuery += _cEnter + "													  CEILING(CASE WHEN B1_TIPCONV = 'D' THEN AIE010.AIE_NECESS / CASE WHEN B1_CONV = 0 THEN 1 ELSE B1_CONV END  ELSE AIE010.AIE_NECESS * B1_CONV END) / CASE WHEN B1_CONV = 0 THEN 1 ELSE B1_CONV END  END"
	
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE')
	_cQuery += _cEnter + "INNER JOIN "
	_cQuery += _cEnter + "("
	_cQuery += _cEnter + "SELECT AIE_FILNEC, AIE_CODPRO, AIE_NECDIG, AIE_CODFOR, AIE_LOJFOR, AIE.R_E_C_N_O_ RECNO,"
	_cQuery += _cEnter + "ISNULL(("
	_cQuery += _cEnter + "SELECT TOP 1 D1_FORNECE + D1_LOJA + CONVERT(CHAR(10),D1_VUNIT) FORNECEDOR "
	_cQuery += _cEnter + "FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	_cQuery += _cEnter + "WHERE SD1.D_E_L_E_T_ 		= ''"
	_cQuery += _cEnter + "AND D1_FILIAL 			= AIE_FILNEC"
	_cQuery += _cEnter + "AND D1_COD 				= AIE_CODPRO"
	_cQuery += _cEnter + "AND D1_FORNECE 			> '000009'"
	_cQuery += _cEnter + "AND D1_TIPO 				= 'N'"
	_cQuery += _cEnter + "ORDER BY D1_EMISSAO DESC"
	_cQuery += _cEnter + "),'') AS FORNECEDOR"
	_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	
	_cQuery += _cEnter + "WHERE AIE.D_E_L_E_T_ 		= ''"
	_cQuery += _cEnter + "AND AIE_TIPO 				= ''"
	_cQuery += _cEnter + "AND AIE_PEDIDO 			= ''"
	_cQuery += _cEnter + "and AIE_NUM 				= '" + strzero(_nCalculo,15) + "'"
	_cQuery += _cEnter + ") A ON " + RetSqlName('AIE') + ".R_E_C_N_O_ = RECNO"
	
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
	_cQuery += _cEnter + "ON SB1.D_E_L_E_T_ 		= ''"
	_cQuery += _cEnter + "AND B1_COD = A.AIE_CODPRO"
	
	TcSqlExec(_cQuery)
	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³RE = REPOSIÇÃO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ElseIf _cTipoCalc $ 'RE/RC/PV'
	
	_cQuery := "UPDATE " + RetSqlName('AIE')
	_cQuery += _cEnter + "SET AIE_TIPO 				= '" + _cTipoCalc + "', AIE_LSHORA = '" + left(Time(),2) + substr(Time(),4,2) + "'"
	_cQuery += _cEnter + "WHERE D_E_L_E_T_ 			= ''"
	_cQuery += _cEnter + "AND AIE_TIPO 				= ''"
	_cQuery += _cEnter + "AND AIE_PEDIDO 			= ''"
	_cQuery += _cEnter + "AND AIE_NUM 				= '" + strzero(_nCalculo,15) + "'"
	TcSqlExec(_cQuery)
	
EndIf

_nOpcA     		:= 0
_nQtdItens 		:= GetMv('MV_QTITENS')
_cTipoPedido 	:= iif(_cTipoCalc $ 'PV/RC/RE','Vendas / Romaneios','Compras')

Define MsDialog _oDlg Title "Central de Compras - Geração dos Pedidos de " + _cTipoPedido  From 000,000 to 200,500 of oMainWnd Pixel

@ 020,008 Say 'Número do Cálculo último cálculo para o usuário ' + _cUser    Size 250,010 COLOR CLR_BLACK Pixel of _oDlg
@ 018,160 MsGet _oCalculo  Var _nCalculo  	Picture "@E 999999999999999"     Size 040,010 COLOR CLR_BLACK Pixel of _oDlg
@ 040,008 Say 'Quantidade de itens por pedido de venda ' 					 Size 150,010 COLOR CLR_BLACK Pixel of _oDlg
@ 038,160 MsGet _oQtdItens Var _nQtdItens 	Picture "@!" PIXEL 		 		 Size 020,010 COLOR CLR_BLACK Pixel of _oDlg  Valid (_nQtdItens > 0)

@ 85,10 BmpButton Type 1 Action (_nOpcA:= 1, _oDlg:End())
@ 85,50 BmpButton Type 2 Action (_nOpcA:= 0, _oDlg:End()) object _obut

Activate MsDialog _oDlg Centered

If _nOpcA == 0
	Return()
EndIf

_nCalculo		:= strzero(_nCalculo,15)

Posicione('AIE',1, xFilial('AIE') + _nCalculo,'AIE_NUM')

_cQuery	 		:= "SELECT COUNT(*) TOTAL FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
_cQuery1 		:= _cEnter + " WHERE AIE_NUM 		= '" + _nCalculo + "'"
_cQuery1 		+= _cEnter + " AND AIE.D_E_L_E_T_ 	= ''"
If AIE->AIE_TIPO == 'CL'
	_cQuery1	+= _cEnter + " AND AIE_FILNEC 		= AIE_MSFIL "
Else
	_cQuery1	+= _cEnter + " AND AIE_MSFIL 		= '" + AIE->AIE_MSFIL + "'"
EndIf

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery+=_cQuery1), '_AIE', .F., .T.)
_nTotal := _AIE->TOTAL
DbCloseArea()

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery + " AND AIE_PEDIDO = ''"), '_AIE', .F., .T.)
_nSemPed := _AIE->TOTAL
DbCloseArea()

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery + " AND AIE_PEDIDO <> ''"), '_AIE', .F., .T.)
_nComPed := _AIE->TOTAL
DbCloseArea()

_cTexto := 'Cálculo nro ' + _nCalculo + ': ' + _cEnter+ _cEnter
If _nTotal > 0
	_cTexto := 'Total de itens calculados: ' + str(_nTotal,5) + _cEnter
EndIf
If _nComPed > 0
	_cTexto += 'Foi(ram) gerado(s) ' + alltrim(str(_nComPed)) + ' pedido(s) ' + _cTipoPedido + _cEnter
EndIf
If _nSemPed > 0
	_cTexto += 'Não foi(ram) gerado(s) pedido(s) de ' + _cTipoPedido + ' para ' + alltrim(str(_nSemPed)) + ' itens ' + _cEnter
EndIf

_cTexto += _cEnter + 'Gerar pedidos de ' + _cTipoPedido + ' para o cálculo ' + _nCalculo + '?'
If !MsgBox(_cTexto,'Central de Compras','YESNO')
	Return()
EndIf

If _cTipoCalc $ 'PV/RE/RC'
	Processa({ || U_LS177GPV()},'Gerando Pedidos ' + _cTipoPedido)
ElseIf _cTipoCalc $ 'PC/CL'
	Processa({ || U_LS177GPV()},'Gerando Pedidos ' + _cTipoPedido)
EndIf

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// validacao do dialogo de geração de pedidos
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _ValiDlg()
/////////////////////////

Local _lRet := .t.
ConOut("*** LA SELVA - Static FUnction - _VALIDDLG - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If _nOpcA == 1
	MsgAlert('Necessário selecionar o tipo do cálculo (compras ou reposição)','Central de Compras')
	_lRet := .f.
EndIf
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// GERA PEDIDOS DE VENDAS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177GPV()
////////////////////////     

ConOut("*** LA SELVA - User FUnction - LS177GPV - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If _cTipoCalc $ 'PV/RC/RE'  /// para reposicao, apaga todos os itens onde o saldo na filial centralizadora estiver zerado
	
	_cQuery := "UPDATE " + RetSqlName('AIE')
	_cQuery += _cEnter + "SET AIE_SLDCEN = B2_QATU - B2_RESERVA, AIE_TIPO = '" + _cTipoCalc + "', AIE_CODFOR = '', AIE_LOJFOR = ''"
	_cQuery += _cEnter + "FROM " + RetSqlName('SB2') + " SB2 (NOLOCK)"
	_cQuery += _cEnter + "WHERE " + RetSqlName('AIE') + ".D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND AIE_NUM 			= '" + _nCalculo + "'"
	_cQuery += _cEnter + "AND B2_FILIAL 		= AIE_FILCEN "
	_cQuery += _cEnter + "AND B2_COD 			= AIE_CODPRO "
	_cQuery += _cEnter + "AND SB2.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + "AND AIE_PEDIDO 		= ''"
	_cQuery += _cEnter + "AND B2_LOCAL 			= '01'"
	_cQuery += _cEnter + "AND AIE_TIPO 			IN ('RE','RC','PV')"
	TcSqlExec(_cQuery)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 11/02/2016                        ³
//³Trocou o campo b2_reserva por B2_XRESERV              ³
//³ o valor de pedido não faturado para a filial destino ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery := "UPDATE " + RetSqlName('AIE')
	_cQuery += _cEnter + "SET AIE_SLDNEC = B2_QATU - B2_XRESERV, AIE_TIPO = '" + _cTipoCalc + "', AIE_CODFOR = '', AIE_LOJFOR = ''"
	_cQuery += _cEnter + "FROM " + RetSqlName('SB2') + " SB2 (NOLOCK)"
	_cQuery += _cEnter + "WHERE " + RetSqlName('AIE') + ".D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND AIE_NUM 			= '" + _nCalculo + "'"
	_cQuery += _cEnter + "AND B2_FILIAL 		= AIE_FILNEC "
	_cQuery += _cEnter + "AND B2_COD 			= AIE_CODPRO "
	_cQuery += _cEnter + "AND SB2.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + "AND AIE_PEDIDO 		= ''"
	_cQuery += _cEnter + "AND B2_LOCAL 			= '01'"
	_cQuery += _cEnter + "AND AIE_TIPO 			IN ('RE','RC','PV')"
	TcSqlExec(_cQuery)

	
	_cQuery := "UPDATE " + RetSqlNAme('AIE')
	_cQuery += _cEnter + "SET D_E_L_E_T_ 		= '*'"
	_cQuery += _cEnter + "WHERE D_E_L_E_T_ 		= ''"
	_cQuery += _cEnter + "AND AIE_FILIAL 		= '" + xFilial('AIE') + "'"
	_cQuery += _cEnter + "AND (AIE_SLDCEN 		<= 0 OR AIE_NECESS <= 0 OR AIE_NECDIG <= 0)"
	_cQuery += _cEnter + "AND AIE_NUM 			= '" + _nCalculo + "'"
	_cQuery += _cEnter + "AND AIE_PEDIDO 		= ''"
	_cQuery += _cEnter + "AND AIE_TIPO 			IN ('RE','RC','PV')"
	TcSqlExec(_cQuery)
	
	_cQuery := "SELECT AIE_MSFIL, AIE_NUM, AIE_CODPRO, AIE.AIE_SLDCEN, AIE.AIE_NECESS, AIE_FILCEN, AIE_CLIENT, AIE_FILNEC, AIE.AIE_NECESS, AIE_NECDIG"
	_cQuery += _cEnter + "FROM ("
	_cQuery += _cEnter + "	SELECT AIE_MSFIL FIL, AIE_NUM NUM, AIE_CODPRO CODPRO, SUM(AIE_NECESS) AIE_NECESS, AIE_SLDCEN"
	_cQuery += _cEnter + "	FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + "	WHERE AIE_NUM 		= '" + _nCalculo + "'"
	_cQuery += _cEnter + "	AND AIE.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + "	AND AIE_PEDIDO 		= ''"
	_cQuery += _cEnter + "	GROUP BY AIE_MSFIL, AIE_NUM, AIE_CODPRO, AIE_SLDCEN"
	_cQuery += _cEnter + "	HAVING AIE_SLDCEN 	< SUM(AIE_NECDIG)"
	_cQuery += _cEnter + ") A"
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('AIE') + " AIE (NOLOCK)"
	_cQuery += _cEnter + "								ON CODPRO 				= AIE.AIE_CODPRO"
	_cQuery += _cEnter + "								AND FIL 				= AIE.AIE_MSFIL"
	_cQuery += _cEnter + "								AND NUM 				= AIE.AIE_NUM"
	_cQuery += _cEnter + "								AND AIE.D_E_L_E_T_ 		= ''"
	_cQuery += _cEnter + "								AND AIE_PEDIDO 			= ''"
	_cQuery += _cEnter + "								AND AIE_TIPO 			IN ('RE','RC','PV')"
	_cQuery += _cEnter + "ORDER BY CODPRO, AIE.AIE_NECESS DESC, AIE.AIE_FILNEC"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)
	Count to _nLastRec
	DbGoTop()
	
	Do While !eof()
		_cCodPro := _AIE->AIE_CODPRO
		_nSldCen := _AIE->AIE_SLDCEN
		Do While !eof() .and. _cCodPro == _AIE->AIE_CODPRO
			IncProc('Ajustando Necessidades x Estoque Centralizadora')
			DbSelectArea('AIE')
			If DbSeek(xFilial('AIE') + _AIE->AIE_NUM + _AIE->AIE_FILNEC + _AIE->AIE_CODPRO,.F.)
				RecLock('AIE',.f.)
				If _nSldCen > 0
					AIE->AIE_NECDIG := iif(_nSldCen < AIE->AIE_NECESS, _nSldCen, AIE->AIE_NECESS)
					_nSldCen -= AIE->AIE_NECDIG
				Else
					AIE->AIE_NECDIG := 0
					DbDelete()
				EndIf
				MsUnLock()
			EndIf
			
			DbSelectArea('_AIE')
			DbSkip()
		EndDo
		
	EndDo
	DbCloseArea()
	
EndIf

////////////////////////////////////////////////////////////////////
// corrige produtos que estiverem com último preço de compras zerado
/////////////////////////////////////////////////////////////////////
_cQuery := "UPDATE " + RetSqlName('SB1')
_cQuery += _cEnter + "SET B1_UPRC = VUNIT, B1_UCOM = DIGIT"

_cQuery += _cEnter + "FROM ("

_cQuery += _cEnter + "SELECT COD, MAX(D1_VUNIT) VUNIT, DIGIT, B1_UPRC UPRC"
_cQuery += _cEnter + "FROM("

_cQuery += _cEnter + "SELECT B1_COD COD, max(D1_DTDIGIT) DIGIT, B1_UPRC"
_cQuery += _cEnter + "FROM " + RetSqlName('SB1') + " SB1 (NOLOCK)"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SD1') + " SD1 (NOLOCK)"
_cQuery += _cEnter + "ON SD1.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND D1_COD 			= B1_COD"
_cQuery += _cEnter + "AND D1_FILIAL 		IN ('55','01')"
_cQuery += _cEnter + "AND D1_FORNECE 		> '000009'"
_cQuery += _cEnter + "AND D1_TES 			<> ''"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
_cQuery += _cEnter + "ON SF4.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND F4_CODIGO 		= D1_TES "
_cQuery += _cEnter + "AND F4_UPRC 			= 'S'"

_cQuery += _cEnter + "WHERE SB1.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND B1_UPRC 			= 0"
_cQuery += _cEnter + "GROUP BY B1_COD, B1_UPRC"

_cQuery += _cEnter + ") A"

_cQuery += _cEnter + "INNER JOIN SD1010 SD1 (NOLOCK)"
_cQuery += _cEnter + "ON SD1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND D1_COD 		= COD"
_cQuery += _cEnter + "AND D1_DTDIGIT 	= DIGIT"
_cQuery += _cEnter + "AND D1_FILIAL 	IN ('55','01')"
_cQuery += _cEnter + "AND D1_TES 		<> ''"
_cQuery += _cEnter + "GROUP BY COD, DIGIT, B1_UPRC"
_cQuery += _cEnter + "HAVING B1_UPRC 	<> MAX(D1_VUNIT)"

_cQuery += _cEnter + ") B"

_cQuery += _cEnter + "WHERE B1_COD = COD"

TcSqlExec(_cQuery)

_cQuery := "SELECT AIE_FILNEC, AIE_NUM CALCULO, CEILING(CONVERT(FLOAT,COUNT(*))/" + trans(GetMv('MV_QTITENS'),'999') + ") PEDIDOS, CONVERT(FLOAT,COUNT(*)) ITENS, "
_cQuery += _cEnter + "AIE_USERGI, AIE_CODFOR, AIE_LOJFOR"
_cQuery += _cEnter + "FROM " + RetSqlNAme('AIE') + " AIE (NOLOCK) "
_cQuery += _cEnter + "WHERE AIE.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND AIE_FILIAL 		= '" + xFilial('AIE') + "'"
If _cTipoCalc $ 'PV/RC/RE'
	_cQuery += _cEnter + "AND AIE_TIPO 		IN ('RC','RE','PV')
Else
	_cQuery += _cEnter + "AND AIE_TIPO 		= 'CL'
	_cQuery += _cEnter + "AND AIE_FILCEN 	= ''"
	_cQuery += _cEnter + "AND AIE_MSFIL 	= AIE_FILNEC"
	_cQuery += _cEnter + "AND AIE_CODFOR 	<> ''"
	_cQuery += _cEnter + "AND AIE_LOJFOR 	<> ''"
	_cQuery += _cEnter + "AND AIE_ENTREG 	<> ''"
	_cQuery += _cEnter + "AND AIE_UPRC 		> 0"
EndIf
If _cTipoCalc $ 'RE/PV'
	_cQuery += _cEnter + "AND AIE_SLDCEN > 0"
EndIf
_cQuery += _cEnter + "AND AIE_NUM 		= '" + _nCalculo + "'"
_cQuery += _cEnter + "AND AIE_PEDIDO 	= ''"
_cQuery += _cEnter + "GROUP BY AIE_FILNEC,AIE_USERGI, AIE_NUM, AIE_CODFOR, AIE_LOJFOR"
_cQuery += _cEnter + "ORDER BY AIE_FILNEC, AIE_CODFOR, AIE_LOJFOR"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)
count to _nLastRec
If _nLastRec == 0
	MsgAlert('Não há pedidos para gerar para o cálculo ' + _nCalculo ,'Central de Compras')
	DbCloseArea()
	Return()
EndIf

_cPedidos := ''
DbGoTop()      

Do While !eof()
	_cCgcFil  := fBuscaCpo("SM0",1,cEmpAnt  + _AIE->AIE_FILNEC,'M0_CGC')
	SM0->(DbGoTo(_nRecSM0))
	_cCliente := Posicione('SA1',10,_cCgcFil + _AIE->AIE_FILNEC,'A1_COD')  
	DbSelectArea('_AIE')
	Do While !eof() .and. _cCliente == '999999' .and. SA1->A1_CGC == _cCgcFil
		SA1->(DbSkip())
		_cCliente := SA1->A1_COD
	EndDo
	_cPedidos += _cCliente + '/' + _AIE->AIE_FILNEC + ' - ' + SA1->A1_NREDUZ + ': ' + tran(_AIE->PEDIDOS,'99') + ' pedidos para ' + tran(_AIE->ITENS,'9999') + ' itens' + _cEnter
	DbSkip()
	
EndDo

_cPedidos := 'Pedidos a serem gerados: ' + _cEnter + _cEnter + _cPedidos
DbCloseArea()
If Aviso('Central de Compras',_cPedidos,{'OK','Cancelar'},3,'Pedidos por Loja') == 2
	Return()
EndIf

_cQuery := "SELECT *"
_cQuery += _cEnter + "FROM " + RetSqlNAme('AIE') + " AIE (NOLOCK) "
_cQuery += _cEnter + "WHERE AIE.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND AIE_FILIAL 		= '" + xFilial('AIE') + "'"
If _cTipoCalc $ 'PV/RC/RE'
	_cQuery += _cEnter + "AND AIE_TIPO 		IN ('RC','RE','PV')
Else
	_cQuery += _cEnter + "AND AIE_TIPO 		= 'CL'
	_cQuery += _cEnter + "AND AIE_FILCEN 	= ''"
	_cQuery += _cEnter + "AND AIE_MSFIL 	= AIE_FILNEC"
EndIf
If _cTipoCalc == 'RE/PV'
	_cQuery += _cEnter + "AND AIE_SLDCEN 	> 0"
EndIf
_cQuery += _cEnter + "AND AIE_NUM 			= '" + _nCalculo + "'"
_cQuery += _cEnter + "AND AIE_PEDIDO 		= ''"
_cQuery += _cEnter + "ORDER BY AIE_FILNEC, AIE_CODFOR, AIE_LOJFOR"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)
count to _nLastRec

DbGoTop()

_cCabTxt   := ''
_cTexto    := ''
_nQuant    := 0
_cSeq      := '00' // nro sequencial para arquivos de log de erro
_nMaxItens := GetMv('MV_QTITENS')
 
ProcRegua(_nLastRec)
Do While !eof() .and. _cTipoCalc $ 'PV/RC/RE'
	
	_cCgcFil  := fBuscaCpo("SM0",1,cEmpAnt  + _AIE->AIE_FILNEC,'M0_CGC')
	SM0->(DbGoTo(_nRecSM0))
	
	_cCliente := Posicione('SA1',10,_cCgcFil + _AIE->AIE_FILNEC,'A1_COD')
	Do While !eof() .and. _cCliente == '999999' .and. SA1->A1_CGC == _cCgcFil
		SA1->(DbSkip())
		_cCliente := SA1->A1_COD
	EndDo
	
	_aCabPv	:= {}
	aAdd(_aCabPv, {"C5_FILIAL"	, xFilial("SC5")	, Nil})
	aAdd(_aCabPv, {"C5_TIPO"	, 'N'				, Nil})
	aAdd(_aCabPv, {"C5_CLIENTE"	, SA1->A1_COD,    	, Nil})
	aAdd(_aCabPv, {"C5_LOJACLI"	, SA1->A1_LOJA		, Nil})
	aAdd(_aCabPv, {"C5_CLIENT"	, SA1->A1_COD,    	, Nil})
	aAdd(_aCabPv, {"C5_LOJAENT"	, SA1->A1_LOJA		, Nil})
	aAdd(_aCabPv, {"C5_CONDPAG"	, SA1->A1_COND		, Nil})
	
	_aItensPv := {}
	_cItem    := '0000' 
	_nRegPv   := 0
	_cQuery1  := ''
	++_nQuant
	_cChave   := _AIE->AIE_NUM + _AIE->AIE_FILNEC
	Do While !eof() .and. _AIE->AIE_NUM + _AIE->AIE_FILNEC == _cChave .and. ++_nRegPv <= _nMaxItens .and. _AIE->AIE_FILIAL == xFilial('AIE')
		


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD¿
//³Realizada melhoria na rotina de Solicitação de Compras  ³
//³(MATA110) com a criação do parâmetro MV_SCSLDBL que     ³
//³possibilita a atualização do campo                      ³
//³Qtd. Prevista (B2_SALPEDI) somente quando a solicitação ³
//³de compras estiver liberada.                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDÙ
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 11/02/2016                        ³
//³Trocou o campo b2_reserva por B2_XRESERV              ³
//³ o valor de pedido não faturado para a filial destino ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		// saldo na loja de destino
//		_nSldNec  := Posicione('SB2',1, _AIE->AIE_FILNEC + _AIE->AIE_CODPRO + '01','B2_QATU') + iif(SB2->B2_SALPEDI < 0, 0, SB2->B2_SALPEDI) 

		_nSldNec  := Posicione('SB2',1, _AIE->AIE_FILNEC + _AIE->AIE_CODPRO + '01','B2_QATU') + iif(SB2->B2_XTRANSI < 0, 0, SB2->B2_XRESERV) + iif(SB2->B2_XRESERV < 0, 0, SB2->B2_XRESERV) 
		
		_nRepMax  := Posicione('SBZ',1, _AIE->AIE_FILNEC + _AIE->AIE_CODPRO ,'BZ_EMAX')
		_nRepMin  := SBZ->BZ_EMIN
		_nNecess  := 0
		If _nSldNec < _nRepMin
			_nNecess := _nRepMax - _nSldNec
		Else
			_cQuery := "UPDATE " + RetSqlName('AIE')
			_cQuery += " SET AIE_NECDIG 	= 0, D_E_L_E_T_ = '*'"
			_cQuery += " WHERE R_E_C_N_O_ 	= " + alltrim(str(R_E_C_N_O_))
			TcSqlExec(_cQuery)
			--_nRegPv
			DbSkip()
			loop
		EndIf
		
		// saldo disponivel na centralizadora: SALDO ATUAL menos QUANTIDADE RESERVADA em PVs
		_nSldCent := Posicione('SB2',1, xFilial('SB2')   + _AIE->AIE_CODPRO + '01','B2_QATU') - iif(SB2->B2_RESERVA < 0, 0, SB2->B2_RESERVA)
		
		If _nSldCent < _nNecess .or. _nSldCent <= 0
			_nQuant := _nSldCent
			_cQuery := "UPDATE " + RetSqlName('AIE')
			_cQuery += " SET AIE_SLDCEN 	= " + alltrim(str(_nSldCent)) + ", AIE_NECDIG = " + alltrim(str(_nQuant)) + iif( _nSldCent == 0,", D_E_L_E_T_ = '*'","")
			_cQuery += " WHERE R_E_C_N_O_ 	= " + alltrim(str(R_E_C_N_O_))
			TcSqlExec(_cQuery)
			
			If _nSldCent <= 0
				DbSkip()
				loop
			EndIf
		Else
			_nQuant := _AIE->AIE_NECDIG
		EndIf
		
		_cItem := Soma1(_cItem)
		_aItem := {}
		
		DbSelectArea("SB1")
		SB1->( DbSetOrder(1) )
		SB1->( DbSeek( xFilial("SB1") + _AIE->AIE_CODPRO, .f. ) )
		_aTESCF := FatG004()
		
		If Substr(SA1->A1_CGC,1,8) $ GetMv("MV_LSVCNPJ")
			_nPrcUni := _nPrcVen := iif(SB1->B1_UPRC > 0, SB1->B1_UPRC, SB1->B1_PRCCOM)
		Else
			_nPrcUni := SB1->B1_PRV1
			_nPDec   :=  If(SB1->B1_GRUPO == "0010",15,20)
			_nPrcVen := noround(_nPrcUni - (SB1->B1_PRV1 * _nPDec) / 100,2)
		EndIf
		
		aAdd(_aItem, {"C6_ITEM"		, _cItem          				, Nil})
		aAdd(_aItem, {"C6_PRODUTO"	, _AIE->AIE_CODPRO				, Nil})
		aAdd(_aItem, {"C6_QTDVEN"	, _nQuant						, Nil})
		aAdd(_aItem, {'C6_PRCVEN'	, round(_nPrcVen,2)				, NIL})
		//aAdd(_aItem, {'C6_VALOR' 	, _AIE->AIE_NECDIG * round(_nPrcVen,2)	, NIL})
		aAdd(_aItem, {'C6_TES'		, _aTesCF[1]					, NIL})
		aAdd(_aItem, {'C6_CF'		, _aTesCF[2]					, NIL})
		aAdd(_aItem, {'C6_PRUNIT'	, _nPrcUni						, NIL})
		
		aAdd(_aItensPv,aClone(_aItem))
		_cQuery1 += "'" + _AIE->AIE_CODPRO + "',"
		
		DbSelectArea('_AIE')
		DbSkip()
		
	EndDo
	
	_cQuery1 := left(_cQuery1,len(_cQuery1)-1) + ")"
	
	lMsErroAuto := .f.
	IncProc()
	
	If empty(_aItensPv) // se não tem item nenhum a gerar no pedido, pula pro proximo
		DbSelectArea('_AIE')
		DbSkip()
		loop
	EndIf
	
	MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItensPv,3)
	
	If lMsErroAuto
		DbSelectArea('SBZ')
		_cSeq := Soma1(_cSeq)
		cErroExecAuto := MostraErro('c:\spool\','CALC_' + substr(_cChave,10,6)  + '_CLI_' + SA1->A1_COD + '_' + SA1->A1_LOJA + '_' + _cSeq + '.LOG')
		U_EnvMail("sidney@stch.com.br","Erro Central de Compras - Reparte",cErroExecAuto)
		
		_cTexto := 'Cliente bloqueado: ' + SA1->A1_COD + '/' + SA1->A1_LOJA + ' - ' + SA1->A1_NREDUZ + _cEnter + _cEnter
		_cTexto += 'Excluir o cálculo das necessidades para esse cliente?' + _cEnter + _cEnter
		_cTexto += 'Item' + _cTabula + 'Produto' + _cTabula + 'Descrição' + _cTabula + _cTabula + 'Quantidade' + _cEnter
		For _nI := 1 to len(_aItensPv)
			_cTexto += _aItensPv[_nI,1,2] + _cTabula + _aItensPv[_nI,2,2] + _cTabula + alltrim(Posicione('SB1',1,xFilial('SB1') + _aItensPv[_nI,2,2],'B1_DESC')) + _cTabula + tran(_aItensPv[_nI,4,2],'@E 9,999') + _cEnter
		Next
		If SA1->A1_MSBLQL == '1'
			If MsgBox(_cTexto,'Central de Compras','YESNO')
				_cQuery := "UPDATE " + RetSqlName('AIE')
				_cQuery += _cEnter + " SET D_E_L_E_T_ 	= '*'"
				_cQuery += _cEnter + " WHERE AIE_CLIENT = '' AND"
				_cQuery += _cEnter + " AIE_FILNEC 		= '" + SA1->A1_LOJA + "' AND"
				_cQuery += _cEnter + " AIE_NUM 			= '" + left(_cChave,15) + "'"
				TcSqlExec(_cQuery)
			EndIf
		EndIf
		_cCabTxt := ''
		_cTexto := ''
		
	Else
		
		_cCabTxt := alltrim(str(_nQuant)) + iif(_nQuant > 1, ' romaneios gerados',' romaneio gerado') + ' com sucesso!' + _cEnter + _cEnter
		_cTexto += SC5->C5_NUM + '  ' + SC5->C5_CLIENTE + ' / ' + SC5->C5_LOJACLI + '  '
		_cTexto += Posicione('SA1',1,xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI,'A1_NREDUZ') + ' '
		_cTexto += alltrim(str(_nRegPv)) + iif(_nRegPv > 1,' itens',' item') + _cEnter
		
		_cQuery := "UPDATE " + RetSqlName('AIE')
		_cQuery += _cEnter + "SET AIE_PEDIDO 		= '" + SC5->C5_NUM + "', AIE_CLIENT = '" + _cCliente + "'"
		_cQuery += _cEnter + "WHERE D_E_L_E_T_ 		= ''"
		_cQuery += _cEnter + "AND AIE_PEDIDO 		= ''"
		_cQuery += _cEnter + "AND AIE_FILIAL 		= '" + xFilial('AIE') + "'"
		_cQuery += _cEnter + "AND AIE_NUM 			= '" + left(_cChave,15) + "'"
		_cQuery += _cEnter + "AND AIE_FILNEC 		= '" + SA1->A1_LOJA + "'"
		_cQuery += _cEnter + "AND AIE_CODPRO 		IN (" + _cQuery1
		
		TcSqlExec(_cQuery)
		
	EndIf
	
	DbSelectArea('_AIE')
	
EndDo

Do While !eof() .and. _cTipoCalc $ 'PC/CL'
	
	cFilAnt := _AIE->AIE_FILNEC
	cNumEmp	:= cEmpAnt + cFilAnt
	_aCabPc	:= {}
	
	_C7_NUM	:= GetSxeNum("SC7","C7_NUM")
	Do While .T.
		DbSelectArea("SC7")
		DbSetOrder(1)
		If DbSeek(xFilial("SC7") + _C7_NUM,.f.)
			ConfirmSX8()
			_C7_NUM := GetSxeNum("SC7","C7_NUM")
		Else
			Exit
		EndIf
	EndDo
	DbSelectArea('_AIE')
	aAdd(_aCabPc, {"C7_NUM"     , _C7_NUM			, Nil})
	aAdd(_aCabPc, {"C7_EMISSAO"	, dDataBase			, Nil})
	aAdd(_aCabPc, {"C7_FORNECE"	, _AIE->AIE_CODFOR 	, Nil})
	aAdd(_aCabPc, {"C7_LOJA"	, _AIE->AIE_LOJFOR	, Nil})
	aAdd(_aCabPc, {"C7_FILENT"	, _AIE->AIE_FILNEC 	, Nil})
	aAdd(_aCabPc, {"C7_COND"   	, Posicione('SA2',1, xFilial('SA2') + _AIE->AIE_CODFOR + _AIE->AIE_LOJFOR,'A2_COND')		, Nil})
	aAdd(_aCabPc, {"C7_CONTATO"	, ''	   			, Nil})
	
	_aItensPc := {}
	_cItem   := '0000'
	_nRegPC  := 0
	_cQuery1 := ''
	++_nQuant
	_cChave := _AIE->AIE_NUM + _AIE->AIE_FILNEC + _AIE->AIE_CODFOR
	Do While !eof() .and. _AIE->AIE_NUM + _AIE->AIE_FILNEC + _AIE->AIE_CODFOR == _cChave
		++_nRegPC
		_cItem := Soma1(_cItem)
		_aItem := {}
		
		DbSelectArea("SB1")
		SB1->( DbSetOrder(1) )
		SB1->( DbSeek( xFilial("SB1") + _AIE->AIE_CODPRO ) )
		
		aAdd(_aItem, {"C7_ITEM"		, _cItem          					, Nil})
		aAdd(_aItem, {"C7_PRODUTO"	, _AIE->AIE_CODPRO					, Nil})
		aAdd(_aItem, {"C7_QUANT"	, _AIE->AIE_NECDIG					, Nil})
		aAdd(_aItem, {"C7_UM"    	, SB1->B1_UM       					, Nil})
		aAdd(_aItem, {"C7_SEGUM"	, SB1->B1_SEGUM    					, Nil})
		aAdd(_aItem, {"C7_QTSEGUM"	, _AIE->AIE_QSEGUM					, Nil})
		aAdd(_aItem, {'C7_PRECO'	, _AIE->AIE_UPRC					, NIL})
		aAdd(_aItem, {'C7_TOTAL' 	, _AIE->AIE_NECDIG * _AIE->AIE_UPRC	, NIL})
		aAdd(_aItem, {"C7_DATPRF" 	, _AIE->AIE_ENTREG					, Nil})
		
		aAdd(_aItensPc,aClone(_aItem))
		_cQuery1 	+= "'" + _AIE->AIE_CODPRO + "',"
		_AIE_CODFOR := _AIE->AIE_CODFOR
		_AIE_LOJFOR := _AIE->AIE_LOJFOR
		_AIE_FILNEC := _AIE->AIE_FILNEC
		_AIE_DTCALC := _AIE->AIE_DTCALC
		
		DbSelectArea('_AIE')
		DbSkip()
		
	EndDo
	
	_cQuery1 := left(_cQuery1,len(_cQuery1)-1) + ")"
	
	lMsErroAuto := .f.
	IncProc()
	MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,_aCabPc,_aItensPc,3,.F.)
	cFilAnt := _cFilOri
	
	If lMsErroAuto
		DbSelectArea('SBZ')
		_cSeq := Soma1(_cSeq)
		cErroExecAuto := MostraErro('c:\spool\','CALC_' + substr(_cChave,10,6) + '_FOR_' + SA2->A2_COD + '_' + SA2->A2_LOJA + '_' + _cSeq + '.LOG')
		U_EnvMail("sidney@stch.com.br","Erro Central de Compras - Reparte",cErroExecAuto)
		
		_cTexto := 'Fornecedor bloqueado: ' + SA2->A2_COD + '/' + SA2->A2_LOJA + ' - ' + SA2->A2_NREDUZ + _cEnter + _cEnter
		_cTexto += 'Excluir o cálculo das necessidades para esse cliente?' + _cEnter + _cEnter
		_cTexto += 'Item' + _cTabula + 'Produto' + _cTabula + 'Descrição' + _cTabula + _cTabula + 'Quantidade' + _cEnter
		For _nI := 1 to len(_aItensPc)
			_cTexto += _aItensPc[_nI,1,2] + _cTabula + _aItensPc[_nI,2,2] + _cTabula + alltrim(Posicione('SB1',1,xFilial('SB1') + _aItensPc[_nI,2,2],'B1_DESC')) + _cTabula + tran(_aItensPc[_nI,4,2],'@E 9,999') + _cEnter
		Next
		If SA2->A2_MSBLQL == '1'
			If MsgBox(_cTexto,'Central de Compras','YESNO')
				_cQuery := "UPDATE " + RetSqlName('AIE')
				_cQuery += _cEnter + " SET D_E_L_E_T_ 	= '*'"
				_cQuery += _cEnter + " WHERE AIE_CODFOR = '" + _AIE_CODFOR + "'"
				_cQuery += _cEnter + " AND AIE_LOJFOR 	= '" + _AIE_LOJFOR + "'"
				_cQuery += _cEnter + " AND AIE_FILNEC 	= AIE_MSFIL"
				_cQuery += _cEnter + " AND AIE_DTCALC 	= '" + _AIE_DTCALC + "'"
				_cQuery += _cEnter + " AND AIE_FILNEC 	= '" + _AIE_FILNEC + "'"
				_cQuery += _cEnter + " AND AIE_NUM 		= '" + left(_cChave,15) + "'"
				TcSqlExec(_cQuery)
			EndIf
		EndIf
		_cCabTxt := ''
		_cTexto  := ''
		
	Else
		
		_cCabTxt := alltrim(str(_nQuant)) + ' pedido(s) de compras gerado(s)  com sucesso!' + _cEnter + _cEnter
		_cTexto += _AIE_FILNEC + ' ' + _C7_NUM + '  ' + _AIE_CODFOR + ' / ' + _AIE_LOJFOR + '  '
		_cTexto += SA2->A2_NREDUZ + ' '
		_cTexto += alltrim(str(_nRegPC)) + iif(_nRegPC > 1,' itens',' item') + _cEnter
		
		_cQuery := "UPDATE " + RetSqlName('AIE')
		_cQuery += _cEnter + "SET AIE_PEDIDO 	= '" + _C7_NUM + "'"
		_cQuery += _cEnter + "WHERE D_E_L_E_T_ 	= ''"
		_cQuery += _cEnter + "AND AIE_PEDIDO 	= ''"
		_cQuery += _cEnter + "AND AIE_MSFIL 	= AIE_FILNEC"
		_cQuery += _cEnter + "AND AIE_FILNEC 	= '" + _AIE_FILNEC + "'"
		_cQuery += _cEnter + "AND AIE_NUM 		= '" + left(_cChave,15) + "'"
		_cQuery += _cEnter + "AND AIE_CODFOR 	= '" + _AIE_CODFOR + "'"
		_cQuery += _cEnter + "AND AIE_DTCALC 	= '" + _AIE_DTCALC + "'"
		_cQuery += _cEnter + "AND AIE_LOJFOR 	= '" + _AIE_LOJFOR + "'"
		_cQuery += _cEnter + "AND AIE_CODPRO 	IN (" + _cQuery1
		
		TcSqlExec(_cQuery)
		
	EndIf
	
	DbSelectArea('_AIE')
	
EndDo

DbCloseArea()

If _cTipoCalc $ 'PV/RC/RE'
	_cTexto := 'Pedido Cliente Loja Nome                Qt Itens' + _cEnter + _cTexto
	_aErros	:= Directory('c:\spool\' + 'CALC_' + substr(_cChave,10,6) + '_CLI_*.LOG')
Else
	_cTexto := 'Fil Pedido Fornec Loja Nome                Qt Itens' + _cEnter + _cTexto
	_aErros	:= Directory('c:\spool\' + 'CALC_' + substr(_cChave,10,6) + '_FOR_*.LOG')
EndIf

_cErros := ''
For _nI := 1 to len(_aErros)
	_cErros += MemoRead('c:\spool\' + _aErros[_nI,1])
	fErase('c:\spool\' + _aErros[_nI,1])
Next
If !empty(_cErros)
	Aviso('Central de Compras',_cErros,{'OK'},3,'Log de erros de geração de pedidos')
Else
	If !empty(_cTexto) .and. !empty(_cCabTxt)
		Aviso('Central de Compras',_cTexto,{'OK'},3,_cCabTxt)
	EndIf
EndIf

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function FATG004()
/////////////////////////
Local cTesFora	:= ""
SM0->(DbGoTo(_nRecSM0))

ConOut("*** LA SELVA - Static FUnction - FATG004 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If (Substr(SA1->A1_CGC,1,8) $ GetMv("MV_LSVCNPJ")) .OR. (Substr(SA1->A1_CGC,1,8) $ GetMv("MV_CNPJLSV"))
	cTes	:= Posicione("SBZ",1,SA1->A1_LOJA + _AIE->AIE_CODPRO,"BZ_TS")
	cCf		:= Posicione("SF4",1,xFilial("SF4") + cTes,"F4_CF")
Else
	cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL + _AIE->AIE_CODPRO,"BZ_TS_FORN")
	cCf		:= Posicione("SF4",1,xFilial("SF4") + cTes,"F4_CF")
EndIf

If SM0->M0_ESTENT <> SA1->A1_EST .AND. !Empty(cTes)
	
	cTesFora := Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF_FORA")
	
	If !empty(cTesFora)
		cCf := cTesFora
	ElseIf !Empty(cCf)
		cCf := "6"+Substr(cCf,2,3)
	EndIf
	
EndIf

Return({cTes,cCf})

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Trans177(_cGru, _cPro, _cFil, _cOri, _cFilter, _cDtRom, _cFor)
////////////////////////////////////////////////////////////////////////////

ConOut("*** LA SELVA - User FUnction - TRANS177 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

Default _cGru    := '    '
Default _cPro    := space(15)
Default _cFil    := ''
Default _cOri    := ''
Default _cFilter := ''
Default _cDtRom  := '20121231'
Default _cFor    := ''

_cGru := strtran(_cGru, "'","")
_cPro := strtran(_cPro, "'","")
_cFor := strtran(_cFor, "'","")

_aFiliais := strtran(strtran(_cFil,"(","{"),")","}")
_aFiliais := iif(empty(_aFiliais),{''},&_aFiliais)
_nLastRec := len(_aFiliais)
ProcRegua(_nLastRec)

_cSB1Temp := CriaTrab(,.f.)

For _nI := 1 to _nLastRec
	
	IncProc('Processando filial ' + _aFiliais[_nI] + '  (' + alltrim(str(_nI)) + ' / ' + alltrim(str(_nLastRec)) + ')')
	
	_cQuery := "SELECT DISTINCT BZ_FILIAL, B1_COD, B1_GRUPO, B1_DESC"
	_cQuery += _cEnter + "INTO " + _cSB1Temp
	_cQuery += _cEnter + "FROM " + RetSqlName('SB1') + " SB1 (NOLOCK)"
	
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SBZ') + " SBZ (NOLOCK)"
	_cQuery += _cEnter + "ON SBZ.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + "AND BZ_COD = B1_COD"
	If !empty(_cPro)
		//_cQuery += _cEnter + "AND BZ_EMAX + BZ_EMIN > 0"
	EndIf
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SB2') + " SB2 (NOLOCK)"
	_cQuery += _cEnter + "ON SB2.D_E_L_E_T_ 	= ''"
	If !empty(_aFiliais[1])
		_cQuery += _cEnter + "AND SB2.B2_FILIAL = '" + _aFiliais[_nI] + "'"
	EndIf
	_cQuery += _cEnter + "AND SB2.B2_FILIAL 	= BZ_FILIAL"
	_cQuery += _cEnter + "AND SB2.B2_COD 		= B1_COD"
	_cQuery += _cEnter + "AND SB2.B2_LOCAL 		= '01'"
	
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SB2') + " SB2CD (NOLOCK)"
	_cQuery += _cEnter + "ON SB2CD.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + "AND SB2CD.B2_COD 		= B1_COD"
	_cQuery += _cEnter + "AND SB2CD.B2_LOCAL 	= '01'"
	_cQuery += _cEnter + "AND SB2CD.B2_FILIAL 	= '" + cFilAnt + "'"
	If !empty(_cPro)
		//_cQuery += _cEnter + "AND SB2CD.B2_QATU > 0"
	EndIf
	
	_cQuery += _cEnter + "WHERE SB1.D_E_L_E_T_ 	= ''"
	//_cQuery += _cEnter + "AND B1_MSBLQL = '2'"
	
	If !empty(_cPro)
		_cQuery += _cEnter + " AND B1_COD 		= '"  + _cPro + "'"
	EndIf
	If !empty(_cGru)
		_cQuery += _cEnter + " AND B1_GRUPO 	= '"  + _cGru + "'"
		If _cGru == '0004'
			_cQuery += _cEnter + " AND B1_ENCALHE > (case when B1_PERIODI = 7 then '" + dtos(dDataBase+2) + "' Else '" + dtos(dDataBase+3) + "' end ) "
		EndIf
	EndIf
	If !empty(_cFor)
		_cQuery += _cEnter + " AND B1_PROC 		= '"  + _cFor + "'"
	EndIf
	
	If !empty(_cFilter) .and. _nI == 1
		_cFilter := strtran(strtran(strtran(strtran(strtran(strtran(_cFilter,' <','<'),' >','>'),'= ','='),' =','='),'< ','<'),'> ','>')
		_nPos1 := at('B1_PE',_cFilter)
		_cRank := ''
		If _nPos1 > 0
			_nPos2 := 0
			For _nJ := _nPos1+5 to len(_cFilter)
				If IsDigit(substr(_cFilter,_nJ,1))
					_cRank += substr(_cFilter,_nJ,1)
				ElseIf substr(_cFilter,_nJ,1) == ' '
					_nPos2 := _nJ
					Exit
				EndIf
			Next
			_cFilter :=  iif(_nPos2 = 0, substr(_cFilter,1,_nPos1-1),'') + 'B1_PE BETWEEN 1 AND ' + _cRank + iif(_nPos2 > 0, substr(_cFilter,_nPos2),'')
		EndIf
		_cQuery += _cEnter + " AND (" + _cFilter +  ")"
	EndIf
	_cQuery += _cEnter + " ORDER BY B1_COD"
	
	MsAguarde({|| TcSqlExec(_cQuery)},'Selecionando Produtos' + iif(empty(_aFiliais),'','  ->' + _aFiliais[_nI]))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	_cQuery1 := "SELECT B2_FILIAL, 'UPDATE" + RetSqlName('SB2') + " SET B2_SALPEDI = ' + RTRIM(CONVERT(CHAR,SALPEDI)) + ' WHERE R_E_C_N_O_ = ' + RTRIM(CONVERT(CHAR, " + RetSqlName('SB2') + " .R_E_C_N_O_)) CAMPO"

	_cQuery1 := "SELECT B2_FILIAL, 'UPDATE" + RetSqlName('SB2') + " SET B2_XTRANSI = ' + RTRIM(CONVERT(CHAR,SALPEDI)) + ' WHERE R_E_C_N_O_ = ' + RTRIM(CONVERT(CHAR, " + RetSqlName('SB2') + " .R_E_C_N_O_)) CAMPO"
	
	_cQuery1 += _cEnter + "FROM " + RetSqlName('SB2') + " (NOLOCK)"
	_cQuery1 += _cEnter + "INNER JOIN ("
	
	_cQuery1 += _cEnter + _cEnter + "SELECT FILIAL, B1_COD, SUM(SALPEDI) SALPEDI"


	_cQuery1 += _cEnter + "FROM ("
	
	_cQuery1 += _cEnter + "SELECT DISTINCT BZ_FILIAL FILIAL, B1_COD, SUM(ISNULL(CASE WHEN PA6_NFE = '' THEN PA7_QTDORI ELSE 0 END,0)) SALPEDI"
	
	_cQuery1 += _cEnter + _cEnter + "FROM " + _cSB1Temp + " SB1 (NOLOCK)"
	
	_cQuery1 += _cEnter + "LEFT JOIN " + RetSqlName('PA7') + " PA7 (NOLOCK)"
	_cQuery1 += _cEnter + "ON PA7.D_E_L_E_T_ 	= ''"
	_cQuery1 += _cEnter + "AND PA7_CODPRO 		= B1_COD"
	_cQuery1 += _cEnter + "AND PA7_FILIAL 		= ''"
	
	_cQuery1 += _cEnter + "LEFT JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK)"
	_cQuery1 += _cEnter + "ON PA6_NUMROM 		= PA7_NUMROM"
	_cQuery1 += _cEnter + "AND PA6.D_E_L_E_T_ 	= ''"
	_cQuery1 += _cEnter + "AND PA6_FILIAL 		= ''"
	If !empty(_cFilOri)
		_cQuery1 += _cEnter + "AND PA6_FILORI 	= '"  + _cFilOri + "'"
	EndIf
	_cQuery1 += _cEnter + "AND PA6_FILDES 		= BZ_FILIAL"
	If !empty(_cDtRom)
		_cQuery1 += _cEnter + "AND PA6_DTROM 	> '" + _cDtRom + "'"
	EndIf
	If !empty(_cDtRom)
		_cQuery1 += _cEnter + "AND PA6_DTROM 	> '" + _cDtRom + "'"
	EndIf
	
	_cQuery1 += _cEnter + "LEFT JOIN " + RetSqlName('SC6') + " SC6 (NOLOCK)"
	_cQuery1 += _cEnter + "ON C6_FILIAL 		= right(PA7_NUMROM,2)"
	_cQuery1 += _cEnter + "and C6_NUM 			= LEFT(PA7_NUMROM,6)"
	_cQuery1 += _cEnter + "AND SC6.D_E_L_E_T_ 	= ''"
	_cQuery1 += _cEnter + "AND C6_PRODUTO 		= PA7_CODPRO"
	_cQuery1 += _cEnter + "AND C6_LOCAL 		= '01'"
	_cQuery1 += _cEnter + "AND C6_LOJA 			= BZ_FILIAL"
	
	_cQuery1 += _cEnter + "LEFT JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	_cQuery1 += _cEnter + "ON F4_CODIGO 		= C6_TES"
	_cQuery1 += _cEnter + "AND SF4.D_E_L_E_T_ 	= ''"
	_cQuery1 += _cEnter + "AND F4_ESTOQUE 		= 'S'"
	_cQuery1 += _cEnter + "AND F4_FILIAL 		= ''"
	
	_cQuery1 += _cEnter + "GROUP BY PA6_FILDES, BZ_FILIAL, B1_COD"
	
	//-----------------------------------
	_cQuery1 += _cEnter + _cEnter + "UNION ALL"
	
	_cQuery1 += _cEnter + _cEnter + "SELECT DISTINCT BZ_FILIAL FILIAL, B1_COD, ISNULL(SUM(D1_QUANT),0) AS SALPEDI"
	_cQuery1 += _cEnter + "FROM " + _cSB1Temp + " SB1 (NOLOCK)"
	
	_cQuery1 += _cEnter + "LEFT JOIN " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	_cQuery1 += _cEnter + "ON SD1.D_E_L_E_T_ 	= ''"
	_cQuery1 += _cEnter + "AND D1_TES 			= ''"
	_cQuery1 += _cEnter + "AND D1_FORNECE 		< '000009'"
	If !empty(_cFilOri)
		_cQuery1 += _cEnter + "AND D1_LOJA 		= '"  + _cFilOri + "'"
	EndIf
	_cQuery1 += _cEnter + "AND D1_COD 			= B1_COD"
	If !empty(_cDtRom)
		_cQuery1 += _cEnter + "AND D1_DTDIGIT 	> '" + _cDtRom + "'"
	EndIf
	_cQuery1 += _cEnter + "AND D1_FILIAL 		= BZ_FILIAL"
	
	_cQuery1 += _cEnter + "LEFT JOIN " + RetSqlName('PA6') + " PA6 (NOLOCK)"
	_cQuery1 += _cEnter + "ON PA6_NFE 			= D1_DOC"
	_cQuery1 += _cEnter + "AND PA6_SERIE 		= D1_SERIE"
	_cQuery1 += _cEnter + "AND PA6_FILDES 		= D1_FILIAL"
	_cQuery1 += _cEnter + "AND PA6.D_E_L_E_T_ 	= ''"
	_cQuery1 += _cEnter + "AND PA6_FILDES 		= BZ_FILIAL"
	_cQuery1 += _cEnter + "AND PA6.D_E_L_E_T_ 	= ''"
	If !empty(_cDtRom)
		_cQuery1 += _cEnter + "AND PA6_DTROM 	> '" + _cDtRom + "'"
	EndIf
	
	_cQuery1 += _cEnter + "LEFT JOIN " + RetSqlNameadalpia('PA7') + " PA7 (NOLOCK)"
	_cQuery1 += _cEnter + "ON PA7_NUMROM 		= PA6_NUMROM"
	_cQuery1 += _cEnter + "AND PA7_CODPRO 		= D1_COD"
	_cQuery1 += _cEnter + "AND PA7.D_E_L_E_T_ 	= ''"
	_cQuery1 += _cEnter + "GROUP BY D1_FILIAL, BZ_FILIAL, B1_COD"
	
	//---------------------------------
	_cQuery1 += _cEnter + "UNION ALL" + _cEnter
	
	_cQuery1 += _cEnter + "SELECT DISTINCT BZ_FILIAL FILIAL, B1_COD, CASE WHEN F4_ESTOQUE = 'S' THEN ISNULL(SUM(C7_QUANT-C7_QUJE),0) ELSE 0 END AS SALPEDI"
	_cQuery1 += _cEnter + "FROM " + _cSB1Temp + " SB1 (NOLOCK)"
	
	_cQuery1 += _cEnter + "LEFT JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"
	_cQuery1 += _cEnter + "ON C7_PRODUTO 		= B1_COD"
	_cQuery1 += _cEnter + "AND SC7.D_E_L_E_T_ 	= ''"
	_cQuery1 += _cEnter + "AND C7_FILIAL 		= BZ_FILIAL"
	_cQuery1 += _cEnter + "AND C7_RESIDUO 		<> 'S'"
	_cQuery1 += _cEnter + "AND C7_QUJE 			<> C7_QUANT"
	_cQuery1 += _cEnter + "AND C7_FORNECE 		> '000009'"
	If !empty(_cDtRom)
		_cQuery1 += _cEnter + "AND C7_EMISSAO 	> '" + _cDtRom + "'"
	EndIf
	
	_cQuery1 += _cEnter + "LEFT JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	_cQuery1 += _cEnter + "ON F4_CODIGO 		= C7_TES"
	_cQuery1 += _cEnter + "AND SF4.D_E_L_E_T_ 	= ''"
	// ********
	_cQuery1 += _cEnter + "GROUP BY C7_FILIAL, BZ_FILIAL, B1_COD, F4_ESTOQUE"
	
	_cQuery1 += _cEnter + ") A"
	_cQuery1 += _cEnter + "GROUP BY FILIAL, B1_COD) B"
	_cQuery1 += _cEnter + "ON B2_COD 			= B1_COD"
	_cQuery1 += _cEnter + "AND B2_FILIAL 		= FILIAL"
	_cQuery1 += _cEnter + "AND B2_LOCAL 		= '01'"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	_cQuery1 += _cEnter + "AND B2_SALPEDI 		<> SALPEDI"
	_cQuery1 += _cEnter + "AND B2_XTRANSI 		<> SALPEDI"
	_cQuery1 += _cEnter + "AND D_E_L_E_T_ 		= ''"
	
//	U_LS_UPDATE(_cQuery1,.t.)
	                       
	TcSqlExec('DROP TABLE ' + _cSB1Temp)
	
Next

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177Rom()
////////////////////////

ConOut("*** LA SELVA - User FUnction - LS177ROM - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

cDesc1        		:= "Este programa tem como objetivo imprimir relatorio "
cDesc2        		:= "de produtos por romaneio e nota fiscal"
cDesc3        		:= ""
cTitulo       		:= "Produtos por romaneio e nota fiscal"
nLin          		:= 80
cPerg         		:= 'MTA177ROM '
ValidPerg()
Private aOrd        := {}
Private aReturn     := { "Zebrado",1,"Administracao", 2, 2, 1, '', 1} //--"Zebrado"#"Administracao"
Private cString     := 'PA6'
Private cNomeprog   := CriaTrab(Nil, .F.)
Private lEnd        := .F.
Private lAbortPrint := .F.
Private m_pag       := 01
Private nLimite     := 220
Private nTipo       := 18
Private nLastKey    := 0
Private Tamanho     := 'P'
Private wnrel       := 'LS_MTA177Rom'
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

fErase(__RelDir + wnrel + '.##r')
SetDefault( aReturn, cString )

If nLastKey == 27
	RestArea( aArea )
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|lEnd| RunRomReport( @lEnd) }, cTitulo)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunRomReport( lEnd)
////////////////////////////////
Local cLinha  := ''
Local nQtdNec := 0
Local nPos    := 0

ConOut("*** LA SELVA - Static FUnction - RUNROMREPORT - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If mv_par09 == 1
	_cQuery := "SELECT PA6_FILORI, PA6_FILDES, B1_COD, B1_DESC, PA7_QTDORI, PA6_NUMROM, PA6_DTROM, PA6_NFS, PA6_NFE, PA6_SERIE, ISNULL(F2_EMISSAO,'') F2_EMISSAO, ISNULL(F1_EMISSAO,'') F1_EMISSAO, ISNULL(F1_DTPRNOT,'') F1_DTPRNOT , ISNULL(F1_DTDIGIT,'') F1_DTDIGIT "
Else
	_cQuery := "SELECT DISTINCT PA6_FILORI, PA6_FILDES, PA6_NUMROM, PA6_DTROM, PA6_NFS, PA6_NFE, PA6_SERIE, ISNULL(F2_EMISSAO,'') F2_EMISSAO, ISNULL(F1_EMISSAO,'') F1_EMISSAO, ISNULL(F1_DTPRNOT,'') F1_DTPRNOT , ISNULL(F1_DTDIGIT,'') F1_DTDIGIT "
EndIf
_cQuery += _cEnter + "FROM " + RetSqlNAme('PA7') + " PA7 (NOLOCK) "

_cQuery += _cEnter + "INNER JOIN " + RetSqlNAme('SB1') + " SB1 (NOLOCK) "
_cQuery += _cEnter + "ON B1_COD 			= PA7_CODPRO"
_cQuery += _cEnter + "AND SB1.D_E_L_E_T_ 	= ''"
If !empty(mv_par05)
	_cQuery += _cEnter + "AND B1_GRUPO 		= '" + mv_par05 + "'"
EndIf

_cQuery += _cEnter + "INNER JOIN " + RetSqlNAme('PA6') + " PA6 (NOLOCK) "
_cQuery += _cEnter + "ON PA6_NUMROM 		= PA7_NUMROM"
_cQuery += _cEnter + "AND PA6.D_E_L_E_T_ 	= ''"
If !empty(mv_par01)
	_cQuery += _cEnter + "AND PA6_FILDES 	= '" + upper(mv_par01) + "'"
EndIf
If !empty(mv_par02)
	_cQuery += _cEnter + "AND PA6_NFS 		= '" + mv_par02 + "'"
EndIf
If !empty(mv_par03)
	_cQuery += _cEnter + "AND PA6_NUMROM 	= '" + mv_par03 + "'"
EndIf
_cQuery += _cEnter + "AND PA6_DTROM BETWEEN '" + dtos(mv_par06) + "' AND '" + dtos(mv_par07) + "'"
If mv_par08 == 1
	_cQuery += _cEnter + "AND PA6_NFE 		= ''"
ElseIf mv_par08 == 2
	_cQuery += _cEnter + "AND PA6_NFE 		<> ''"
EndIf
_cQuery += _cEnter + "LEFT JOIN " + RetSqlNAme('SF2') + " SF2 (NOLOCK) "
_cQuery += _cEnter + "ON SF2.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND F2_FILIAL 		= PA6_FILORI"
_cQuery += _cEnter + "AND F2_DOC 			= PA6_NFS"
_cQuery += _cEnter + "AND F2_SERIE 			= PA6_SERIE"

_cQuery += _cEnter + "LEFT JOIN " + RetSqlNAme('SF1') + " SF1 (NOLOCK) "
_cQuery += _cEnter + "ON SF1.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND F1_FILIAL 		= PA6_FILDES"
_cQuery += _cEnter + "AND F1_DOC 			= PA6_NFS"
_cQuery += _cEnter + "AND F1_SERIE 			= PA6_SERIE"
_cQuery += _cEnter + "AND F1_FORNECE 		= '000001'"
_cQuery += _cEnter + "AND F1_LOJA 			= PA6_FILORI"

_cQuery += _cEnter + "WHERE PA7.D_E_L_E_T_ 	= ''"
If !empty(mv_par04)
	_cQuery += _cEnter + "AND PA7_CODPRO 	= '" + mv_par04 + "'"
EndIf
If mv_par09 == 1
	_cQuery += _cEnter + "ORDER BY PA6_FILORI, PA6_FILDES, PA6_NUMROM, B1_COD"
Else
	_cQuery += _cEnter + "ORDER BY PA6_FILORI, PA6_FILDES, PA6_NUMROM"
EndIf
U_GravaQuery('MTA177ROM.SQL',_cQuery)

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_PA6', .F., .T.)
TcSetField('_PA6','PA6_DTROM' ,'D',0)
TcSetField('_PA6','F2_EMISSAO','D',0)
TcSetField('_PA6','F1_EMISSAO','D',0)
TcSetField('_PA6','F1_DTPRNOT','D',0)
TcSetField('_PA6','F1_DTDIGIT','D',0)

count to _nLastRec
DbGoTop()
SetRegua( _nLastRec )

cCabec1 := iif(mv_par09 == 2,'Origem Destino Romaneio  Data Roma Nt Fiscal Ser      Saida    Entrada','')
cCabec2 := ''

Do While !eof()
	If lAbortPrint .Or. lEnd
		@ 000,000 PSay "***CANCELADO PELO OPERADOR!"
		Exit
	EndIf
	
	If nLin > 55
		nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
	EndIf
	
	If mv_par09 == 1
		@ ++nLin, 000 PSAY 'Origem Destino Romaneio  Data Roma Nt Fiscal Ser      Saida    Entrada Classific.'
		//          		12     12      12345678 11/11/1111 123456789 123 11/11/1111 11/11/1111 11/11/1111
	EndIf
	_cLinha := _PA6->PA6_FILORI + '     ' + _PA6->PA6_FILDES + '      ' + _PA6->PA6_NUMROM + ' ' + dtoc(_PA6->PA6_DTROM)  + ' ' + _PA6->PA6_NFS + ' ' + _PA6->PA6_SERIE + ' ' + dtoc(_PA6->F2_EMISSAO) + ' ' + dtoc(_PA6->F1_DTPRNOT) + ' ' + dtoc(_PA6->F1_DTDIGIT)
	@ ++nLin, 000 PSAY _cLinha
	If  mv_par09 == 1
		@ nLin+=2,00 pSay 'Codigo          Descricao                                            Quantidade'
		//          	   123456789012345 1234567890123456789012345678901234567890123456789012345 999,999
		@ ++nLin, 000 PSAY __PrtThinLine()
		
		Do While !eof() .and. _cLinha == _PA6->PA6_FILORI + '     ' + _PA6->PA6_FILDES + '      ' + _PA6->PA6_NUMROM + ' ' + dtoc(_PA6->PA6_DTROM)  + ' ' + _PA6->PA6_NFS + ' ' + _PA6->PA6_SERIE + ' ' + dtoc(_PA6->F2_EMISSAO) + ' ' + dtoc(_PA6->F1_DTPRNOT) + ' ' + dtoc(_PA6->F1_DTDIGIT)
			
			If nLin > 55
				nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
			EndIf
			_cLinha1 := _PA6->B1_COD + ' ' + left(_PA6->B1_DESC,55) + ' ' + tran(_PA6->PA7_QTDORI,'@E 999,999')
			@ ++nLin, 000 PSAY _cLinha1
			
			DbSkip()
			IncRegua()
		EndDo
	Else
		DbSkip()
	EndIf
	@ ++nLin, 000 PSAY __PrtFatLine()
EndDo

DbCloseArea()

If aReturn[5]==1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
ConOut("*** LA SELVA - Static FUnction - VALIDPERG - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Filial Destino                ?","","", "mv_ch1", "C", 02 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0", "", "","","@!"})
aAdd( aPerg , { cPerg, "02", "Nota fiscal                   ?","","", "mv_ch2", "C", 09 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "03", "Romaneio                      ?","","", "mv_ch3", "C", 08 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "04", "Produto                       ?","","", "mv_ch4", "C", 15 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "",""})
aAdd( aPerg , { cPerg, "05", "Grupo                         ?","","", "mv_ch5", "C", 04 , 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBM", "", "",""})
aAdd( aPerg , { cPerg, "06", "Emissão de                    ?","","", "mv_ch6", "D", 08 , 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "07", "Emissão até                   ?","","", "mv_ch7", "D", 08 , 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "08", "Status                        ?","","", "mv_ch8", "N", 01 , 0, 0, "C", "", "mv_par08", "Pendente", "", "", "", "", "Encerrado", "", "", "", "", "Todos", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "09", "Tipo Relatório                ?","","", "mv_ch9", "N", 01 , 0, 0, "C", "", "mv_par09", "Analítico", "", "", "", "", "Sintético", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// envio de pedidos por email
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177MPC()
////////////////////////

Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")
Local _nI

ConOut("*** LA SELVA - Static FUnction - LS177MPC - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If AIE->AIE_MSFIL $ '01/55'  //filiais que podem rodar reposicao de compras ou de estoque
	MsgAlert('Disponível apenas para pedidos de compras aos fornecedores','Central de Compras')
	Return()
EndIf


Private _cQuery := "SELECT SUM(C7_QUJE) QUJE, C7_CONAPRO, AIE_FILNEC, A1_NREDUZ, AIE_PEDIDO, AIE_CODFOR + '/' + AIE_LOJFOR CODFOR, A2_NOME, A2_CONTATO CONTATO, A2_EMAIL EMAIL, AIE_EMAIL"
_cQuery += _cEnter + "FROM " + RetSqlNAme('AIE') + " AIE (NOLOCK) "

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SA2') + " SA2 (NOLOCK)"
_cQuery += _cEnter + "ON A2_COD 			= AIE_CODFOR"
_cQuery += _cEnter + "AND A2_LOJA 			= AIE_LOJFOR"
_cQuery += _cEnter + "AND SA2.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SA1') + " SA1 (NOLOCK)"
_cQuery += _cEnter + "ON A1_COD 			< '000009'"
_cQuery += _cEnter + "AND A1_LOJA 			= AIE_FILNEC"
_cQuery += _cEnter + "AND A1_MSBLQL 		= '2'"
_cQuery += _cEnter + "AND SA1.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"
_cQuery += _cEnter + "ON C7_FILIAL 			= AIE_FILNEC"
_cQuery += _cEnter + "AND C7_NUM 			= AIE_PEDIDO"
_cQuery += _cEnter + "AND SC7.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + "WHERE AIE.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND AIE_NUM 			= '" + AIE->AIE_NUM + "'"
_cQuery += _cEnter + "AND AIE_PEDIDO 		<> ''"
_cQuery += _cEnter + "GROUP BY C7_CONAPRO, AIE_FILNEC, A1_NREDUZ, AIE_PEDIDO, AIE_CODFOR, AIE_LOJFOR, A2_NOME, A2_CONTATO, A2_EMAIL, AIE_EMAIL"

_cQuery += _cEnter + "UNION"

_cQuery += _cEnter + "SELECT SUM(C7_QUJE) QUJE, C7_CONAPRO, AIE_FILNEC, A1_NREDUZ, AIE_PEDIDO, AIE_CODFOR + '/' + AIE_LOJFOR CODFOR, A2_NOME, U5_CONTAT CONTATO, U5_EMAIL EMAIL, AIE_EMAIL"
_cQuery += _cEnter + "FROM " + RetSqlNAme('AIE') + " AIE (NOLOCK) "

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SA2') + " SA2 (NOLOCK)"
_cQuery += _cEnter + "ON A2_COD 			= AIE_CODFOR"
_cQuery += _cEnter + "AND A2_LOJA 			= AIE_LOJFOR"
_cQuery += _cEnter + "AND SA2.D_E_L_E_T_ = ''"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SA1') + " SA1 (NOLOCK)"
_cQuery += _cEnter + "ON A1_COD 			< '000009'"
_cQuery += _cEnter + "AND A1_LOJA 			= AIE_FILNEC"
_cQuery += _cEnter + "AND A1_MSBLQL 		= '2'"
_cQuery += _cEnter + "AND SA1.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + "LEFT JOIN " + RetSqlName('AC8') + " AC8 (NOLOCK)"
_cQuery += _cEnter + "ON AC8.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND AC8_ENTIDA 		= 'SA2'"
_cQuery += _cEnter + "AND AC8_CODENT 		= A2_COD + A2_LOJA"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SU5') + " SU5 (NOLOCK)"
_cQuery += _cEnter + "ON SU5.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND U5_CODCONT 		= AC8_CODCON"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"
_cQuery += _cEnter + "ON C7_FILIAL 			= AIE_FILNEC"
_cQuery += _cEnter + "AND C7_NUM 			= AIE_PEDIDO"
_cQuery += _cEnter + "AND SC7.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + "WHERE AIE.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND AIE_NUM 			= '" + AIE->AIE_NUM + "'"
_cQuery += _cEnter + "AND AIE_PEDIDO 		<> ''"
_cQuery += _cEnter + "GROUP BY C7_CONAPRO, AIE_FILNEC, A1_NREDUZ, AIE_PEDIDO, AIE_CODFOR, AIE_LOJFOR, A2_NOME, U5_CONTAT, U5_EMAIL, AIE_EMAIL"
_cQuery += _cEnter + "ORDER BY AIE_FILNEC, AIE_PEDIDO"
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)

count to _nLastRec
DbGoTop()

_nAltura 	:= oMainWnd:nClientHeight - 50
_nLargura 	:= oMainWnd:nClientWidth - 50
_lInverte 	:= .F.
_lMarca   	:= .F.
_lDesmarca	:= .F.
_aPedidos	:= {}

_RelDir  := __RelDir
__RelDir := 'C:\SPOOL\PCS\'
If !file(__RelDir)
	MakeDir(__RelDir)
EndIf
//If !file('c:\spool\pcs\corpoemail.txt')
_cCorpo := "Anexo, pedido de compras do grupo Laselva, para entrega na filial descrita no cabeçalho."
_cCorpo += _cEnter + "Por favor, confirme o recebimento deste pedido e a data de entrega, para que possamos efetuar o agendamento do mesmo."
_cCorpo += _cEnter + "Para evitarmos transtornos no recebimento desta compra, pedimos para que as observações abaixo sejam seguidas a fim de que não ocorra a devolução das mercadorias:"
_cCorpo += _cEnter + "- Respeite o horário de recebimento informado;"
_cCorpo += _cEnter + "- Na nota fiscal deve constar o número deste pedido de compra;"
_cCorpo += _cEnter + "- Caso haja divergência no custo apontado no pedido com a tabela de preços em vigência, entre em contato conosco para que ocorra o acerto antes de efetuar o faturamento;"
_cCorpo += _cEnter + "- Verifique se o prazo de pagamento informado no pedido de compra está de acordo com o combinado, caso contrário, nos informe para que possamos providenciar o ajuste, também antes de efetuar o faturamento;"
_cCorpo += _cEnter + "- As notas fiscais eletrônicas devem ser encaminhadas para o e-mail fiscal@laselva.com.br;"
_cCorpo += _cEnter + "- Quando possível, encaminhe o boleto bancário para financeiro@laselva.com.br"
_cCorpo += _cEnter + _cEnter + "Atenciosamente,"

_lOk := .f.
_oDlg:=MsDialog():New(0,0,210,420,'Central de Compras - envio de email de PCs',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

@ 005,005 Say 'Texto: ' 				Size 030,010 Pixel of _oDlg
@ 015,005 GET oMemo VAR _cCorpo MEMO 	Size 200,070 Pixel of _oDlg

@ 090,010 BmpButton Type 01 Action(_lOk := .t.,_oDlg:End())
@ 090,060 BmpButton Type 02 Action(_lOk := .f.,_oDlg:End())
_oDlg:Activate(,,,.T.)
If !_lOK
	DbCloseArea()
	Return()
EndIf
MemoWrit('c:\spool\pcs\corpoemail.txt',_cCorpo)
//EndIf
_aUser := PswRet()
_cCorpo1 := iif(left(Time(),2) < '12', 'Bom dia',iif(left(TIme(),2) < '18','Boa tarde','Boa noite')) + _cEnter
_cCorpo1 += _cEnter + 'Prezado(a) Sr(a) '

_cCorpo2 := _cEnter + _cEnter + MemoRead('c:\spool\pcs\corpoemail.txt') + _cEnter
_cCorpo2 += _cEnter + _aUser[1,4]
_cCorpo2 += _cEnter + alltrim(_aUser[1,12])
_cCorpo2 += _cEnter + alltrim(_aUser[1,13])
_cCorpo2 += _cEnter + alltrim(_aUser[1,14])
_cCorpo2 += _cEnter + 'Fone: (11) 2186.' + alltrim(_aUser[1,20])
_cCorpo2 += _cEnter + 'Laselva'

Do While !eof()
	aAdd(_aPedidos,{!empty(_AIE->EMAIL) .and. _AIE->C7_CONAPRO <> 'B' .and. _AIE->QUJE == 0 .and. empty(_AIE->AIE_EMAIL), iif(!empty(_AIE->AIE_EMAIL),'Email já enviado',iif(empty(_AIE->EMAIL),'Sem eMail',iif(_AIE->QUJE > 0,'Já faturado',iif(_AIE->C7_CONAPRO == 'B','Bloqueado','Liberado')))),	_AIE->AIE_FILNEC, _AIE->A1_NREDUZ, _AIE->AIE_PEDIDO, _AIE->CODFOR, _AIE->A2_NOME, _AIE->CONTATO, _AIE->EMAIL, _cCorpo1 + alltrim(_AIE->CONTATO) + _cCorpo2,!empty(_AIE->AIE_EMAIL),dtoc(stod(_AIE->AIE_EMAIL))})
	DbSkip()
EndDo

oDlg		:= MsDialog():New(0,0,_nAltura,_nLargura,'Central de Compras - envio de email de PCs',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
oInvert   	:= tCheckBox():New(10,10,'Inverte Seleção', {|u|if( pcount()>0,_lInverte :=u,_lInverte )} ,oDlg,100,10,,{|| _aPedidos := TROCA177(1,0,_aPedidos)},,,,,,.T.)
oMarca    	:= tCheckBox():New(20,10,'Marca Tudo'		, {|u|if( pcount()>0,_lMarca   :=u,_lMarca   )} ,oDlg,100,10,,{|| _aPedidos := TROCA177(2,0,_aPedidos)},,,,,,.T.)
oDesmarca 	:= tCheckBox():New(30,10,'Desmarca Tudo'	, {|u|if( pcount()>0,_lDesmarca:=u,_lDesmarca)} ,oDlg,100,10,,{|| _aPedidos := TROCA177(3,0,_aPedidos)},,,,,,.T.)

@ 040,005 ListBox  _oListPed  Var _cVarPed Fields HEADER "","Status PC","Loja", "Descrição", "Pedido", "Cod Fornec", "Nome Fornecedor", "Contato", "eMail","Corpo do Email" Size _nLargura/2-10,_nAltura/2-100 On DblClick (_aPedidos:=Troca177(0,_oListPed:nAt,_aPedidos),_oListPed:Refresh()) On Right Click ListBoxAll(nRow,nCol,@_oListPed,oOk,oNo,@_aPedidos) OF oDlg PIXEL

_oListPed:SetArray(_aPedidos)
_oListPed:bLine := { || {iif(_aPedidos[_oListPed:nAt,1],oOk,oNo),_aPedidos[_oListPed:nAt,2],_aPedidos[_oListPed:nAt,3],_aPedidos[_oListPed:nAt,4],_aPedidos[_oListPed:nAt,5],_aPedidos[_oListPed:nAt,6],_aPedidos[_oListPed:nAt,7],_aPedidos[_oListPed:nAt,8],_aPedidos[_oListPed:nAt,9],_aPedidos[_oListPed:nAt,10]}}

@ _nAltura/2-50,010 BmpButton Type 01 Action(Processa({|| Mail177()},"Aguarde","Enviando emails...",.T.),oDlg:End())
@ _nAltura/2-50,060 BmpButton Type 02 Action(oDlg:End())
oDlg:Activate(,,,.T.,/*{||msgstop('validou!'),.T.}*/,,/*{||msgstop('iniciando…')}*/,,,, )

_AIE->(DbCloseArea())
Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Mail177()
/////////////////////////
Local _cFilAnt := cFilAnt
Local _nI, _aDir

ConOut("*** LA SELVA - Static Function - MAIL177 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_aDir   := Directory(__RelDir + '*.htm')
For _nI := 1 to len(_aDir)
	fErase(__RelDir + _aDir[_nI,1])
	If fError() <> 0
		MsgBox('Erro na exclusão do arquivo ' + __RelDir + _aDir[_nI,1] + '. Verifique!','ATENÇÃO!!!','ALERT')
		Return()
	EndIf
Next

_cServer   	:= GETMV("MV_RELSERV")
_cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
_cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
_cEnvia    	:= alltrim(Pswret()[1,14])
_cErros     := ''
_lAuth      := GetMv('MV_RELAUTH')

CONNECT SMTP SERVER _cServer ACCOUNT _cAccount PASSWORD _cPassword Result _lConectou

If _lConectou
	
	If GetNewPar("MV_RELAUTH",.F.)
		_lRetAuth := MailAuth(_cAccount,_cPassword)
	Else
		_lRetAuth := .T.
	EndIf
	
	If _lRetAuth
		
		ProcRegua(len(_aPedidos))
		For _nI := 1 to len(_aPedidos)
			IncProc()
			
			If !_aPedidos[_nI,1]
				loop
			EndIf
			
			cFilAnt := _aPedidos[_nI,3]
			DbSelectArea('SC7')
			DbSetOrder(1)
			If DbSeek(_aPedidos[_nI,3] + _aPedidos[_nI,5],.f.)
				_cArqPed := 'PC_' + SC7->C7_FILENT + '_' + SC7->C7_NUM
				U_LS_R110('SC7', Recno())
				U_MsRelToHtml(__RelDir + _cArqPed + '.##R', __RelDir + _cArqPed + '.HTM' )
				If file(__RelDir + _cArqPed + '.HTM' )
					fErase(__RelDir + _cArqPed + '.##R')
					
					_cAssunto  	:= "Envio de pedido de compras - Grupo Laselva"
					_cRecebe    := alltrim(_aPedidos[_nI,9])
					_cAnexo     := memoread(__RelDir + _cArqPed + '.HTM')
					memowrit('\' + _cArqPed + '.HTM',_cAnexo)
					_cAnexo     := '\' + _cArqPed + '.HTM'
					
					//_cEnvia  := 'alexandre.dalpiaz@laselva.com.br'
					//_crecebe := 'adalpiaz@laselva.com.br'
					_cCorpo  := _aPedidos[_nI,10]
					If _aPedidos[_nI,11]
						_cCorpo += _cEnter + _cEnter + 'Obs.: Pedido já enviado por email em: ' + _aPedidos[_nI,12]
					EndIf
					
					SEND MAIL FROM _cEnvia TO _cRecebe BCC _cEnvia SUBJECT _cAssunto BODY _cCorpo attachment _cAnexo RESULT _lEnviado
					fErase(_cAnexo)
					
					If !_lEnviado
						GET MAIL ERROR _cErro
						_cErros += _aPedidos[_nI,3] + '/' + _aPedidos[_nI,5] + ' - ' + _cRecebe + ' - ' + _cErro + _cEnter
					Else
						_cQuery := "UPDATE " + RetSqlName('AIE')
						_cQuery += _cEnter + "SET AIE_EMAIL = '" + dtos(date()) + "'"
						_cQuery += _cEnter + "WHERE D_E_L_E_T_ 	= ''"
						_cQuery += _cEnter + "AND AIE_FILIAL 	= ''"
						_cQuery += _cEnter + "AND AIE_FILNEC 	= '" + _aPedidos[_nI,3] + "'"
						_cQuery += _cEnter + "AND AIE_PEDIDO 	= '" + _aPedidos[_nI,5] + "'"
						TcSqlExec(_cQuery)
					EndIf
					
				EndIf
			EndIf
		Next
		
	EndIf
	DISCONNECT SMTP SERVER
	
	If !empty(_cErros)
		MsgBox(_cErros,'Erro no envio dos emails:','ALERT')
	Else
		MsgBox('Emails enviados com sucesso!!!','Central de Compras - envio dos emails:','INFO')
	EndIf
Else
	
	MsgBox("NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL","A T E N Ç Ã O!!!" ,'ALERT')
	
Endif

cFilAnt  := _cFilAnt
__RelDir := _RelDir

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// seleção do pedido de compras par envio de email:
//	altera nome do contato, endereço de email
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Troca177(_nOpc,_nIt,_aArray)
////////////////////////////////////////////
Local _nI

ConOut("*** LA SELVA - Static FUnction - TROCA177 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If _nIt > 0
	
	_cContato := left(_aArray[_nIt,8] + space(30),30)
	_cEmail   := left(_aArray[_nIt,9] + space(200),200)
	_cCorpo   := _aArray[_nIt,10]
	
	_nOk := 0
	_lJaEnviou := (_aArray[_nIt,11]  .and. _aArray[_nIt,2] == 'Email já enviado')
	_oDlg:=MsDialog():New(0,0,320,500,'Central de Compras - envio de email de PCs',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oJaEnviou  := tCheckBox():New(03,30,'Texto eMail Enviado',{ || _lJaEnviou} ,_oDlg,100,10,,{||_lJaEnviou:= !_lJaEnviou},,,,,,.T.)
	@ 015,005 Say 'Contato: ' 					Size 030,010 Pixel of _oDlg
	@ 015,030 MsGet _oCont    Var _cContato 	Size 100,010 Pixel of _oDlg
	@ 030,005 Say 'eMail: '   					Size 030,010 Pixel of _oDlg
	@ 030,030 MsGet _oMail    Var _cEmail 		Size 100,010 Pixel of _oDlg
	@ 045,005 Say 'Mensagem:' 					Size 030,010 Pixel of _oDlg
	@ 045,030 GET oMemo 	  VAR _cCorpo MEMO 	Size 200,080 Pixel of _oDlg
	
	@ 140,010 Button 'Marcar' 	 Action(_nOk := 1,_oDlg:End())  	Size 040,010 Pixel of _oDlg
	@ 140,060 Button 'Desmarcar' Action(_nOk := 2,_oDlg:End())  	Size 040,010 Pixel of _oDlg
	@ 140,110 Button 'Cancelar'	 Action(_nOk := 3,_oDlg:End())  	Size 040,010 Pixel of _oDlg
	_oDlg:Activate(,,,.T.)
	
	If _nOk == 1
		_aArray[_nIt,08] := _cContato
		_aArray[_nIt,09] := _cEmail
		_aArray[_nIt,10] := _cCorpo
		_aArray[_nIt,11] := (_aArray[_nIt,2] == 'Email já enviado') .and. _lJaEnviou
		DbSelectArea('SA2')
		If DbSeek(xFilial('SA2') + strtran(_aArray[_nIt,6],'/',''),.f.)
			RecLock('SA2',.f.)
			SA2->A2_CONTATO := _cContato
			SA2->A2_EMAIL   := _cEmail
			MsUnLock()
		EndIf
		_aArray[_nIt,1] := iif(!empty(_aArray[_nIt,9]) .and. !(alltrim(_aArray[_nIt,2]) $ 'Já faturado/Bloqueado'),.t.,.f.)
	ElseIf _nOk == 2
		_aArray[_nIt,1] := .f.
	EndIf
	
Else
	
	For _nI := 1 to len(_aArray)
		_aArray[_nI,1] := iif(!empty(_aArray[_nI,9]) .and. !(alltrim(_aArray[_nI,2]) $ 'Já faturado/Bloqueado'),iif(_nOpc == 1,!_aArray[_nI,1],(_nOpc == 2)),.f.)
	Next
	
EndIf

_lInverte 	:= .f.
_lMarca   	:= .f.
_lDesmarca	:= .f.
oInvert:Refresh()
oMarca:Refresh()
oDesmarca:Refresh()
_oListPed:Refresh()
Return(_aArray)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// rotina para atualizar as datas de entrega nos calculos de pedidos de compras
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177Entr()
////////////////////////
ConOut("*** LA SELVA - User FUnction - LS177ENTR - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_nOpca := 0
_dEntrega := ctod('')
Define MsDialog _oDlg Title "Central de Compras" From 000,000 to 200,500 of oMainWnd Pixel

@ 010,010 Say 'Data de entrega '          	Size 100,010 COLOR CLR_BLACK Pixel of _oDlg
@ 025,010 MsGet _oEntrega  Var _dEntrega  	Size 050,010 COLOR CLR_BLACK Pixel of _oDlg

@ 050,010 Button 'Todo Cálculo' 	Size 050,010 Pixel of _oDlg		Action (_nOpcA:= 1, _oDlg:End())
@ 050,070 Button 'Fornecedor'  		Size 050,010 Pixel of _oDlg		Action (_nOpcA:= 2, _oDlg:End())
@ 050,130 Button 'Fornecedor Loja' 	Size 050,010 Pixel of _oDlg		Action (_nOpcA:= 3, _oDlg:End())
@ 050,190 Button 'Cancelar'        	Size 050,010 Pixel of _oDlg		Action (_nOpcA:= 0, _oDlg:End())

Activate MsDialog _oDlg Centered Valid _nOpca == 0 .or. !empty(_dEntrega)

If _nOpca == 0
	Return()
EndIf

_cQuery := "UPDATE " + RetSqlName('AIE')
_cQuery += _cEnter + " SET AIE_ENTREG 	= '" + dtos(_dEntrega) + "'"
_cQuery += _cEnter + " WHERE D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + " AND AIE_NUM 			= '" + AIE->AIE_NUM + "'"

_cQuery1 := "UPDATE " + RetSqlName('SC7')
_cQuery1 += _cEnter + " SET C7_DATPRF  = '" + dtos(_dEntrega) + "'"
_cQuery1 += _cEnter + " FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
_cQuery1 += _cEnter + " WHERE " + RetSqlName('SC7') + ".D_E_L_E_T_ = ''"
_cQuery1 += _cEnter + " AND AIE_NUM 			= '" + AIE->AIE_NUM + "'"
_cQuery1 += _cEnter + " AND AIE_FILNEC 			= C7_FILIAL"
_cQuery1 += _cEnter + " AND AIE_PEDIDO 			= C7_NUM"

_cQuery += iif(_nOpca == 2 .or. _nOpca == 3, _cEnter + " AND AIE_CODFOR = '" + AIE->AIE_CODFOR + "'", "")
_cQuery += iif(_nOpca == 3, _cEnter + " AND AIE_LOJFOR = '" + AIE->AIE_LOJFOR + "'", "")

_cQuery1 += iif(_nOpca == 2 .or. _nOpca == 3, _cEnter + " AND AIE_CODFOR = '" + AIE->AIE_CODFOR + "'", "")
_cQuery1 += iif(_nOpca == 3, _cEnter + " AND AIE_LOJFOR = '" + AIE->AIE_LOJFOR + "'", "")

Begin Transaction
_nErro := TcSqlExec(_cQuery)
If _nErro > 0
	DisarmTransaction()
Else
	_nErro := TcSqlExec(_cQuery1)
	If _nErro > 0
		DisarmTransaction()
	EndIf
EndIf
End Transaction

If _nErro == 0
	MsgBox('Datas de entrega alteradas com sucesso','Central de Compras','INFO')
Else
	MsgBox('Ocorreu um erro na alteração das datas de entrega.','Central de Compras','ALERT')
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// atualiza preços e fornecedores para calculos de pedidos de compras
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS177PrF()
////////////////////////

ConOut("*** LA SELVA - User FUnction - LS177PRF - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_nOpca   := 0
_cFilial := '  '
Define MsDialog _oDlg Title "Central de Compras" From 000,000 to 200,500 of oMainWnd Pixel

@ 010,010 Say 'Filial de base'          	Size 100,010 COLOR CLR_BLACK Pixel of _oDlg
@ 025,010 MsGet _oFilial  Var _cFilial   	Size 030,010 COLOR CLR_BLACK Pixel of _oDlg F3 'SM0'

@ 050,010 BmpButton Type 1 Action (_nOpcA:= 1, _oDlg:End())
@ 050,070 BmpButton Type 2 Action (_nOpcA:= 0, _oDlg:End())

Activate MsDialog _oDlg Centered Valid _nOpca == 0 .or. !empty(_cFilial)

If _nOpca == 0
	Return()
EndIf

_cQuery := "UPDATE " + RetSqlName('AIE')
_cQuery += _cEnter + " SET AIE010.AIE_UPRC = CASE WHEN AIE010.AIE_UPRC = 0 THEN CONVERT(FLOAT,RIGHT(FORNECEDOR,10)) ELSE AIE010.AIE_UPRC END,"
_cQuery += _cEnter + " AIE010.AIE_CODFOR = CASE WHEN AIE010.AIE_CODFOR = '' THEN LEFT(FORNECEDOR,6) ELSE AIE010.AIE_CODFOR END,"
_cQuery += _cEnter + " AIE010.AIE_LOJFOR = CASE WHEN AIE010.AIE_CODFOR = '' THEN SUBSTRING(FORNECEDOR,7,2) ELSE AIE010.AIE_LOJFOR END"

_cQuery += _cEnter + "FROM " + RetSqlName('AIE')
_cQuery += _cEnter + "INNER JOIN "
_cQuery += _cEnter + "("
_cQuery += _cEnter + "SELECT AIE_FILNEC, AIE_CODPRO, AIE_NECDIG, AIE_CODFOR, AIE_LOJFOR, AIE.R_E_C_N_O_ RECNO, "
_cQuery += _cEnter + "ISNULL(("
_cQuery += _cEnter + "SELECT TOP 1 D1_FORNECE + D1_LOJA + CONVERT(CHAR(10),D1_VUNIT) FORNECEDOR"
_cQuery += _cEnter + "FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
_cQuery += _cEnter + "WHERE SD1.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND D1_FILIAL 		= '" + _cFilial + "'"
_cQuery += _cEnter + "AND D1_COD 			= AIE_CODPRO"
_cQuery += _cEnter + "AND D1_FORNECE		> '000009'"
_cQuery += _cEnter + "AND D1_TIPO 			= 'N'"
_cQuery += _cEnter + "ORDER BY D1_EMISSAO DESC"
_cQuery += _cEnter + "),'') AS FORNECEDOR"
_cQuery += _cEnter + "FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"

_cQuery += _cEnter + "WHERE AIE.D_E_L_E_T_	= ''"
_cQuery += _cEnter + "AND AIE_TIPO 			= 'CL'"
_cQuery += _cEnter + "AND AIE_PEDIDO 		= ''"
_cQuery += _cEnter + "AND AIE_FILNEC 		= '" + AIE->AIE_FILNEC + "'"
_cQuery += _cEnter + "AND AIE_NUM 			= '" + AIE->AIE_NUM + "'"
_cQuery += _cEnter + ") A ON " + RetSqlName('AIE') + ".R_E_C_N_O_ = RECNO"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + "ON SB1.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + "AND B1_COD 			= A.AIE_CODPRO"

_nErro := TcSqlExec(_cQuery)

If _nErro == 0
	MsgBox('Preços e/ou fornecedores alterados com sucesso','Central de Compras','INFO')
Else
	MsgBox('Ocorreu um erro na alteração de preços e/ou fornecedores.','Central de Compras','ALERT')
EndIf

_cQuery := "SELECT COUNT(*) TOTAL FROM " + RetSqlName('AIE') + " AIE (NOLOCK)"
_cQuery += _cEnter + " WHERE AIE_NUM 		= '" + AIE->AIE_NUM + "'"
_cQuery += _cEnter + " AND AIE.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + " AND AIE_FILNEC 		= AIE_MSFIL"
_cQuery += _cEnter + " AND (AIE_CODFOR 		= '' OR AIE_UPRC = 0 OR AIE_ENTREG = '')"
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_AIE', .F., .T.)
_nTotal := _AIE->TOTAL
DbCloseArea()

If _nTotal > 0
	MsgBox('Existe(m) item(ns) calculado(s) que não tem fornecedor e/ou preço unitário e/ou data de entrega determinado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// inicialidor da coluna status do calculo do browse inicial da rotina
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT177Stat()
/////////////////////////
Local _cRet := ''

ConOut("*** LA SELVA - User FUnction - MT177STAT - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If empty(AIE->AIE_TIPO)
	_cRet := 'ERRO'
ElseIf empty(AIE->AIE_PEDIDO)
	_cRet := 'Sem Pedido'
ElseIf AIE->AIE_TIPO == 'CL'
	_cRet := iif(empty(AIE->AIE_PEDIDO),'Sem Pedido',alltrim(Posicione('SC7',2,AIE->AIE_FILNEC + AIE->AIE_CODPRO + AIE_CODFOR + AIE_LOJFOR + AIE->AIE_PEDIDO + AIE->AIE_CODPRO,'C7_CONAPRO')))
	_cRet := iif(_cRet == 'B','Bloqueado', iif(SC7->C7_QUJE == 0,'Liberado',iif(SC7->C7_QUJE < SC7->C7_QUANT,'Ent Parc','Encerrado')))
Else
	_cRet := Posicione('SC6',2,AIE->AIE_FILCEN + AIE->AIE_CODPRO + AIE->AIE_PEDIDO,'C6_NOTA') + SC6->C6_SERIE
	If !empty(SC6->C6_NOTA)
		_cRet := Posicione('SD1',1,AIE->AIE_FILNEC + _cRet + '000001' + AIE->AIE_FILCEN + AIE->AIE_CODPRO,'D1_TES')
		If SD1->D1_DOC == SC6->C6_NOTA
			_cRet := iif(empty(_cRet), 'Receb OK','Encerrado')
		Else
			_cRet := SC6->C6_QTDENT
			_cRet := iif(_cRet < SC6->C6_QTDVEN, 'Fat Parc','NF Emit')
		EndIf
	Else
		_cRet := 'Não Fat'
	EndIf
EndIf

Return(_cRet)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_177Pro()
/////////////////////////

ConOut("*** LA SELVA - User Function - LS_177PROD - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

aIniSession	:= getIniSessions('APPSERVER.INI')
lContinua	:= .F.

FOR _NX := 1 TO LEN(aIniSession)
	IF ALLTRIM(aIniSession[_nX]) == "COMPRAS"
		lContinua := .T.		
		EXIT
	ENDIF
NEXT _NX

IF !lContinua
	MsgAlert('Esta rotina só pode ser executada pelo ambiente CENTRAL DE COMPRAS' 	+ _cEnter +;
	"Para isso, basta acessar utilizando as seguintes configurações" 	+ _cEnter 	+ _cEnter +;
	"Programa Inicial :		SIGAMDI"												+ _cEnter +;
	"Conexão :           	COMPRAS"												+ _cEnter +;
	"Ambiente no Servidor :	LASELVA"												+ _cEnter;
	,'Central de Compras')
ELSE
	_cProd  := 'Copie do Excel e cole neste espaço, uma planilha com uma coluna com os códigos dos produtos'
	_cForn  := 'Copie do Excel e cole neste espaço, uma planilha com uma coluna com os códigos e lojas dos fornecedores'
	_cGrupo := '    '
	_nOk    := 0
	
	DEFINE MSDIALOG oDlg TITLE 'Reposição - Seleciona Produtos' FROM 000,000 TO 500,650 OF oMainWnd PIXEL
	@ 005,005 say 'Grupo'                       Size 100,010 PIXEL OF oDlg
	@ 005,050 Get oGrupo 	Var _cGrupo 		Size 050,010 PIXEL OF oDlg
	@ 020,005 say 'Produtos'                    Size 100,010 PIXEL OF oDlg
	@ 020,050 Get oProd 	Var _cProd MEMO		Size 050,220 PIXEL OF oDlg Valid Vl_prod()
	@ 020,100 say 'Fornecedores'                Size 100,010 PIXEL OF oDlg
	@ 020,140 Get oForn 	Var _cForn MEMO		Size 050,220 PIXEL OF oDlg Valid Vl_Forn()
	
	oButPro := TButton():New( 200,220, 'Produtos'     , oDlg, {|| _nOk := 1 , oDlg:End() }, 060,10,,,,.T. )
	oButFor := TButton():New( 215,220, 'Fornecedores' , oDlg, {|| _nOk := 2 , oDlg:End() }, 060,10,,,,.T. )

	oButCan := TButton():New( 230,220, 'Cancelar'     , oDlg, {||  _nOk := 0 , oDlg:End()}, 060,10,,,,.F. )
	
	Activate MsDialog oDlg Centered On Init Vl_Dlg()
//	oButCan := TButton():New( 230,220, 'Cancelar'     , oDlg, {|| _nOk := 0 , oDlg:End() }, 060,10,,,,.T. )	
	If _nOk == 0
		
		Return()
		
	ElseIf _nOk == 1
		
		_cProd := strtran(_cProd			,' '		,'' )
		_cProd := strtran(_cProd			,' '		,'' )
		_cProd := strtran(alltrim(_cProd)	,chr(9)		,';')
		_cProd := strtran(alltrim(_cProd)	,chr(10)	,'' )
		_cProd := strtran(_cProd			,chr(13)	,';')
		_cProd := strtran(_cProd			,','		,';')
		_cProd := strtran(_cProd			,'.'		,';')
		_cProd := strtran(_cProd			,' '		,';')
		_cProd := strtran(_cProd			,'/'		,';')
		_cProd := strtran(_cProd			,':'		,';')
		_cProd := strtran(_cProd			,'-'		,';')
		_cProd := strtran(_cProd			,' '		,'' )
		Do While at(';;',_cProd) > 0
			_cProd := strtran(_cProd,';;',';')
		EndDo
		_aProds := {}
		_cErros := ''
		
		TcSqlExec("UPDATE " + RetSqlName('SB1') + " SET B1_OK = '' WHERE B1_OK = '" + _cGrupo + "'")
		
		DbSelectArea('SB1')
		DbSetOrder(1)
		
		Do While len(alltrim(_cProd)) > 0
			_nPosic := at(';',_cProd)
			If _nPosic == 0
				If empty(alltrim(_cProd))
					exit
				EndIf
				aAdd(_aProds,_cProd)
			Else
				If !DbSeek(xFilial('SB1') + alltrim(substr(_cProd,1,_nPosic-1)),.f.)
					_cErros += substr(_cProd,1,_nPosic-1) + _cEnter
				Else
					aAdd(_aProds,alltrim(substr(_cProd,1,_nPosic-1)))
				EndIf
				_cProd := substr(alltrim(_cProd),_nPosic+1)
			EndIf
		EndDo
		
		If !empty(_cErros)
			Aviso('Repartes automático','Produto não cadastrado: ' + _cEnter + _cEnter + _cErros,{'OK'},3,'Erros de seleção')
			Return()
		EndIf
		
		For _nI := 1 to len(_aProds)
			If DbSeek(xFilial('SB1') + _aProds[_nI],.f.)
				RecLock('SB1',.f.)
				SB1->B1_OK := _cGrupo
				MsUnLock()
			EndIf
		Next
		
	ElseIf _nOk == 2
		
		_cForn := strtran(_cForn			,' '		,'' )
		_cForn := strtran(_cForn			,' '		,'' )
		_cForn := strtran(alltrim(_cForn)	,chr(9)		,';')
		_cForn := strtran(alltrim(_cForn)	,chr(10)	,'' )
		_cForn := strtran(_cForn			,chr(13)	,';')
		_cForn := strtran(_cForn			,','		,';')
		_cForn := strtran(_cForn			,'.'		,';')
		_cForn := strtran(_cForn			,' '		,';')
		_cForn := strtran(_cForn			,'/'		,';')
		_cForn := strtran(_cForn			,':'		,';')
		_cForn := strtran(_cForn			,'-'		,';')
		_cForn := strtran(_cForn			,' '		,'' )
		Do While at(';;',_cForn) > 0
			_cForn := strtran(_cForn,';;',';')
		EndDo
		_aForns := {}
		_cErros := ''
		
		TcSqlExec("UPDATE " + RetSqlName('SB1') + " SET B1_OK = '' WHERE B1_OK = '" + _cGrupo + "'")
		
		DbSelectArea('SA2')
		DbSetOrder(1)
		
		Do While len(alltrim(_cForn)) > 0
			_nPosic := at(';',_cForn)
			If _nPosic == 0
				aAdd(_aForns,substr(_cForn,1))
			Else
				If !DbSeek(xFilial('SA2') + alltrim(substr(_cForn,1,_nPosic-1)),.f.)
					_cErros += substr(_cForn,1,_nPosic-1) + _cEnter
				Else
					aAdd(_aForns,alltrim(substr(_cForn,1,_nPosic-1)))
				EndIf
				_cForn := substr(alltrim(_cForn),_nPosic+1)
			EndIf
		EndDo
		
		If !empty(_cErros)
			Aviso('Repartes automático','Fornecedor não cadastrado: ' + _cEnter + _cEnter + _cErros,{'OK'},3,'Erros de seleção')
			Return()
		EndIf
		
		For _nI := 1 to len(_aForns)
			_cQuery := "UPDATE " + RetSqlName('SB1') + " SET B1_OK = '" + _cGrupo + "'"
			_cQuery += _cEnter + " WHERE B1_PROC = '" + left(_aForns[_nI],6) + "'"
			If len(_aForns[_nI]) == 8
				_cQuery += _cEnter + " AND B1_PROCLOJ = '" + right(_aForns[_nI],2) + "'"
			EndIf
			TcSqlExec(_cQuery)
		Next
		
	EndIf
	
ENDIF
Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_GERtranS()
///////////////////////////

ConOut("*** LA SELVA - User Function - LA_GERTRANS - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_cGrupo    := '    '
_cProduto  := space(15)
_cFiliais  := ''
_cFilOri   := ''
_cFiltro   := ''
_cPa6DtRom := '20121231'
_cFornece  := ''

MsAguarde({|| U_trans177(_cGrupo, _cProduto, _cFiliais, _cFilOri, _cFiltro, _cPa6DtRom, _cFornece)},'Aguarde...')

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Vl_Prod()
/////////////////////////

ConOut("*** LA SELVA - Static Function - VL_PROD - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_cForn := ''
oButFor:Disable()
oButPro:Enable()
oForn:Refresh()
oButFor:Refresh()
oButPro:Refresh()

Return(.t.)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Vl_Forn()
/////////////////////////

ConOut("*** LA SELVA - Static Function - VL_FORN - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_cProd := ''
oButFor:Enable()
oButPro:Disable()
oProd:Refresh()
oButFor:Refresh()
oButPro:Refresh()

Return(.t.)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Vl_Dlg()
/////////////////////////

ConOut("*** LA SELVA - Static Function - VL_DLG - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

oButFor:Disable()
oButPro:Disable()
oButFor:Refresh()
oButPro:Refresh()

Return(.t.)