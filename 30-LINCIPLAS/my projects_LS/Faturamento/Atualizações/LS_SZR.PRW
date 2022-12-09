#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
// Programa.: ls_szr
// Autor....: Alexandre Dalpiaz
// Data.....: 31/01/2011
// Descrição: cadastro de assinaturas
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZR()
//////////////////////
Local aArea  	:= GetArea()
Local cAlias  	:= "SZR"

aRotina    := {}
cCadastro  := "Cadastro de Assinaturas"
aLegenda   := {}
aCores     := {}
nOpca := 0

aAdd(aLegenda, {'BR_VERDE'	  	,'Em andamento'		, '1'	})
aAdd(aLegenda, {'BR_VERMELHO'	,'Encerrada' 		, '3'	})
aAdd(aLegenda, {'BR_PRETO'	    ,'Cancelada' 		, '2'	})
/*
Aadd(aCores,{ "ZR_PROXIMA > DDATABASE"   , 'BR_VERDE'		}) // aberto
Aadd(aCores,{ "ZR_PROXIMA <= DDATABASE .AND. empty(ZR_CANCELA)"  , 'BR_VERMELHO'	}) // ENCERRADO
Aadd(aCores,{ "!empty(ZR_CANCELA)"       , 'BR_PRETO'		}) // CANCELADO
  */

Aadd(aCores,{ "ZR_TERMINO >= DDATABASE"   , 'BR_VERDE'		}) // aberto
Aadd(aCores,{ "ZR_TERMINO < DDATABASE .AND. empty(ZR_CANCELA)"  , 'BR_VERMELHO'	}) // ENCERRADO
Aadd(aCores,{ "!empty(ZR_CANCELA)"       , 'BR_PRETO'		}) // CANCELADO

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"AxVisual" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"U_SZRINC"			,0,3 })
Aadd(aRotina,{"Alterar"  			,"U_SZRALT" 		,0,4 })
Aadd(aRotina,{"Exclui"  			,"U_SZRDEL" 		,0,5 })
Aadd(aRotina,{"Financeiro" 			,"U_SZRFIN" 		,0,8 })
Aadd(aRotina,{"Renovação"			,"AxAltera('SZR',SZR->(Recno()), 4,,{" +GetMv("LS_RENASS")+ "},,,,,,,,,,.T.,,,,,)", 0 , 4})
/*Aadd(aRotina,{"Renovação"			,"U_SZRREN"			,0,3 }) -- comentado por Rodrigo em 23/08*/
Aadd(aRotina,{"Boletos"  			,"U_SZRBOL"        	,0,3 })
Aadd(aRotina,{"Processa"			,"U_SZRPRO"       	,0,8 })
Aadd(aRotina,{"Movimentos"			,"U_LS_SZS(1)"     	,0,8 })
Aadd(aRotina,{"Etiquetas"			,"U_SZRETQ"       	,0,8 })

Aadd(aRotina,{"Legenda"				,"BrwLegenda('Controle de Assinaturas' , 'Legenda' , aLegenda)",0,8})

DbSelectArea('SZS')
DbSelectArea('SZR')
mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

Return()
                                                                                       
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZS(_xPar)
///////////////////////////
                                                              
Local _lOk		:= .t.
Local _dRef		:= SZR->ZR_INICIO
Default _xPar   := 0
Private cString := "SZS"

dbSelectArea(cString)
dbSetOrder(1)


// INCLUÍDO PELO RODRIGO - CÓD PARA GERAR MOVIMENTO DE REVISTA - TAB SZS

DbGoTop(cString)

If !DbSeek(xFilial(cString) + SZR->ZR_CODIGO)
	
	MsgBox("Não existe uma programação de entrega para " + chr(13) + chr(10) + ;
	"este cliente.","Atenção!","INFO")
	
	If MsgBox("Deseja programar as datas de entrega agora?","Programação","YESNO")
		
		DEFINE MSDIALOG oDlg TITLE 'Programação para entrega das reviraoliveistas.' FROM 000,000 TO 150,650 OF oMainWnd PIXEL
		
		@ 020,008 Say "Defina a data referência para a entrega da 1ª edição: " 	Size 180,015 PIXEL OF oDlg
		@ 020,180 Get oText 	Var _dRef		Size 050,015 PIXEL OF oDlg PICT '99/99/9999'
		
		@ 060,120 Button "&Ok" 								Size 080,012 PIXEL OF oDlg ACTION(_lOk := .t., oDlg:End())
		@ 060,220 Button "&Cancela"							Size 080,012 PIXEL OF oDlg ACTION(_lOk := .f., oDlg:End())
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If !_lOk
			Return()
		EndIf
		
		PROGMOV(_dRef)
		
	EndIf
Else
	
EndIf


If _xPar > 0
	_cFilter := "ZS_CODIGO == '" + SZR->ZR_CODIGO + "'"
	set filter to &_cFilter
EndIf
AxCadastro(cString,"Movimentações de assinaturas",'.t.','.t.')
set filter to

Return

/*
Default _xPar   := 0
Private cString := "SZS"

dbSelectArea("SZS")
dbSetOrder(1)
                   
If _xPar > 0
	_cFilter := "ZS_CODIGO == '" + SZR->ZR_CODIGO + "'"
	set filter to &_cFilter
EndIf
AxCadastro(cString,"Movimentações de assinaturas",'.t.','.t.')
set filter to 
Return
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZRINC()
//////////////////////
nOpca := AxInclui("SZR",SZR->(Recno()), 3,/*{aAcho}*/ , "U_SZRIBefore", /*{aCampos}*/ , "U_SZRITudoOk()", /*lF3*/.F., "U_SZRITransaction", /*{aButtons}*/, /*{aParam}*/,/*{aAuto}*/, /*lVirtual*/, /*lMaximized*/.t., /*cTela*/, /*lPanelFin*/, /*oFather*/, /*{aDim}*/, /*uArea*/)
If nOpca == 1
	U_SZRBOL()
EndIf
Return(nOpca)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function SZRITudoOK()
//////////////////////////
Local _lRet := .t.
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function SZRITransaction()
///////////////////////////////
Local _lRet := .t.
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function SZRIBefore()
//////////////////////////
Local _lRet := (altera .and. empty(SZR->ZR_CANCELA) .and. SZR->ZR_PROXIMA <= dDataBase) .or. inclui
If altera .and. !_lRet
	If empty(SZR->ZR_CANCELA)
		MsgBox('Assinatura cancelada em ' + dtoc(SZR->ZR_CANCELA) + ', não pode ser alterada','ATENÇÃO!!!!','ALERT')
	Else
		MsgBox('Assinatura encerrada ' + dtoc(SZR->ZR_PROXIMA) + ', não pode ser alterada','ATENÇÃO!!!!','ALERT')
	EndIf
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZRALT()
//////////////////////
_lEndTransaction := .f.
Begin Transaction
nOpca := AxAltera("SZR",SZR->(Recno()), 4) //,/*{aAcho}*/ , "U_SZRIBefore", /*{aCampos}*/ , "U_SZRITudoOk()", /*lF3*/.F., "U_SZRITransaction", /*{aButtons}*/, /*{aParam}*/,/*{aAuto}*/, /*lVirtual*/, /*lMaximized*/.t., /*cTela*/, /*lPanelFin*/, /*oFather*/, /*{aDim}*/, /*uArea*/)
Do While !empty(SZR->ZR_CANCELA) .and. empty(SZR->ZR_MOTIVO)
	nOpca := AxAltera("SZR",SZR->(Recno()), 4) //,/*{aAcho}*/ , "U_SZRIBefore", /*{aCampos}*/ , "U_SZRITudoOk()", /*lF3*/.F., "U_SZRITransaction", /*{aButtons}*/, /*{aParam}*/,/*{aAuto}*/, /*lVirtual*/, /*lMaximized*/.t., /*cTela*/, /*lPanelFin*/, /*oFather*/, /*{aDim}*/, /*uArea*/)
	If MsgBox('Para cancelar é necessário informar o motivo do cancelamento','ATENÇÃO!!!','YESNO')
		_lEndTransaction := .t.
		Exit
	EndIf
	
EndDo
If _lEndTransaction
	DisarmTransaction()
EndIf
End Transaction

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZRDEL()
//////////////////////
Local _cTitulos  := ''
Local _aTitulos  := {}
Local _lPagou    := .f.
Local _lNaoPagou := .f.
Local _cHtml	 := ''

If !empty(SZR->ZR_CANCELA) .or. SZR->ZR_PROXIMA > dDataBase
	If empty(SZR->ZR_CANCELA)
		MsgBox('Assinatura cancelada em ' + dtoc(SZR->ZR_CANCELA) + ', não pode ser alterada','ATENÇÃO!!!!','ALERT')
	Else
		MsgBox('Assinatura encerrada ' + dtoc(SZR->ZR_PROXIMA) + ', não pode ser alterada','ATENÇÃO!!!!','ALERT')
	EndIf
	Return()
EndIf

_cHtml += '<html>'
_cHtml += '<head>'
_cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana">Exclusão de assinatura</h3></font>'
_cHtml += '</head>'
_cHtml += '<body bgcolor = white text=black  >'
_cHtml += '<hr width=100% noshade>' + _cEnter

_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Existem título(s) pago(s) para esta assinatura. ' + _cEnter + '</font></b>' + _cEnter
_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Excluir os boletos pendentes e cancelar a assinatura.' + _cEnter + _cEnter + '</font></b>' + _cEnter + _cEnter

_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
_cHtml += '	<TR VALIGN=TOP>                  '

_cHtml += '		<TD WIDTH=10%>'
_cHtml += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>PARCELA<B></P></font> '
_cHtml += '		</TD>'

_cHtml += '		<TD WIDTH=10%>'
_cHtml += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>VENCIMENTO<B></P></font> '
_cHtml += '		</TD>'

_cHtml += '		<TD WIDTH=10%>'
_cHtml += '	   		<P><h3 align = RIGHT<font size="1" face="Verdana"><b>VALOR<B></P></font> '
_cHtml += '		</TD>'

_cHtml += '		<TD WIDTH=10%>'
_cHtml += '	   		<P><h3 align = RIGHT<font size="1" face="Verdana"><b>SALDO<B></P></font> '
_cHtml += '		</TD>'

_cHtml += '		<TD WIDTH=10%>'
_cHtml += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>BAIXA<B></P></font> '
_cHtml += '		</TD>'

DbSelectArea('SE1')
DbSeek(xFilial('SE1') + 'ASS' + SZR->ZR_CODIGO,.f.)

Do While !eof() .and. xFilial('SE1') + 'ASS' + SZR->ZR_CODIGO == SE1->E1_FILIAL + SE1->E1_PREFIXO + alltrim(SE1->E1_NUM)
	
	_cHtml += '	<TR VALIGN=TOP>                  '
	
	_cHtml += '		<TD WIDTH=10%>'
	_cHtml += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>' + SE1->E1_PARCELA + '<B></P></font> '
	_cHtml += '		</TD>'
	
	_cHtml += '		<TD WIDTH=10%>'
	_cHtml += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>' + dtoc(SE1->E1_VENCREA) + '<B></P></font> '
	_cHtml += '		</TD>'
	
	_cHtml += '		<TD WIDTH=10%>'
	_cHtml += '	   		<P><h3 align = RIGHT<font size="1" face="Verdana"><b>' + tran(SE1->E1_VALOR,'@E 99,999.99') + '<B></P></font> '
	_cHtml += '		</TD>'
	
	_cHtml += '		<TD WIDTH=10%>'
	_cHtml += '	   		<P><h3 align = RIGHT<font size="1" face="Verdana"><b>' + tran(SE1->E1_SALDO,'@E 99,999.99') + '<B></P></font> '
	_cHtml += '		</TD>'
	
	_cHtml += '		<TD WIDTH=10%>'
	_cHtml += '	   		<P><h3 align = LEFT<font size="1" face="Verdana"><b>' + dtoc(SE1->E1_BAIXA) + '<B></P></font> '
	_cHtml += '		</TD>'
	
	If SE1->E1_SALDO == 0
		_lPagou := .t.
	Else
		_nNaoPagou := .t.
	EndIf
	DbSkip()
EndDo

_cHtml += '	</TR>'

_cHtml += '</TABLE>'
_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'

_cHtml += '</P>'

If !_lPagou	 .and. _lNaoPagou // não pagou nenhuma parcela
	
	DbSelectArea('SZR')
	nOpca := AxDeleta('SZR',SZR->(RecNo()), 5)
	
	If nOpca == 1
		DbSelectArea('SE1')
		DbSeek(xFilial('SE1') + 'ASS' + SZR->ZR_CODIGO,.f.)
		
		Do While !eof() .and. xFilial('SE1') + 'ASS' + SZR->ZR_CODIGO == SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM
			RecLock('SE1',.f.)
			DbDelete()
			MsUnLock()
			DbSkip()
		EndDo
		
	EndIf
	
ElseIf _lNaoPagou	// tem uma ou mais parcelar em aberto
	
	If MsgBox(_cHtml,'ATENÇÃO!!!','YESNO')
		U_SZRCAN()
		
		_lEndTransaction := .f.
		Begin Transaction
		
		RecLock('SZR',.f.)
		SZR->ZR_CANCELA := dDataBase
		MsUnLock()
		Do While empty(SZR->ZR_MOTIVO)
			aAcho := {}
			DbSelectArea('SX3')
			DbSeek('SZR02')
			Do While SX3->X3_ALIAS == 'SZR' .and. !eof()
				aAdd(aAcho,SX3->X3_CAMPO)
				DbSkip()
			EndDo
			
			DbSelectArea('SZR')
			nOpca := AxAltera("SZR",SZR->(Recno()), 4,/*{aAcho}*/ , "U_SZRIBefore", /*{aCampos}*/ , "U_SZRITudoOk()", /*lF3*/.F., "U_SZRITransaction", /*{aButtons}*/, /*{aParam}*/,/*{aAuto}*/, /*lVirtual*/, /*lMaximized*/.t., /*cTela*/, /*lPanelFin*/, /*oFather*/, /*{aDim}*/, /*uArea*/)
			
			If MsgBox('Para cancelar é necessário informar o motivo do cancelamento','ATENÇÃO!!!','YESNO')
				_lEndTransaction := .t.
				Exit
			EndIf
			
		EndDo
		
		If _lEndTransaction
			DisarmTrasaction()
		Else
			
			DbSelectArea('SE1')
			DbSeek(xFilial('SE1') + 'ASS' + SZR->ZR_CODIGO,.f.)
			
			Do While !eof() .and. xFilial('SE1') + 'ASS' + SZR->ZR_CODIGO == SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM
				If SE1->E1_SALDO == SE1->E1_VALOR
					RecLock('SE1',.f.)
					DbDelete()
					MsUnLock()
				EndIf
				DbSkip()
			EndDo
		EndIf
		
		End Transaction
		
	EndIf
	
Else		// já pagou tudo.
	MsgBox('Cliente já pagou toda assinatura!' + _cEnter + 'Faça o cancelamento.','Atenção','ALERT')
EndIf

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZRFIN()
//////////////////////

DbSelectArea('SE1')
set filter to E1_PREFIXO = 'ASS' .and. alltrim(E1_NUM) == SZR->ZR_CODIGO
FINC040()
set filter to
DbSelectArea('SZR')

Return()

/* COMENTADO POR RODRIGO EM 23/08
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZRREN()
//////////////////////
If MsgBox('Confirma renovação da assinatura?','Assinaturas','YESNO')
	RegToMemory('SZR',.T.)
EndIf

Return()
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   Processa as assinturas, fazendo a reserva e transferência do estoque para a filial 20 (SAC)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZRPRO()
//////////////////////

If MsgBox('Confirma geração dos boletos?','Assinaturas','YESNO')
	
EndIf
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZRBOL()
//////////////////////

If MsgBox('Confirma geração dos boletos?','Assinaturas','YESNO')
	
EndIf
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZRETQ()
//////////////////////

cDesc1        := "Este programa tem como objetivo imprimir etiquetas"
cDesc2        := "para remessa de revistas de assinaturas, individual"
cDesc3        := "ou em grupo"
cTitulo       := "Assinaturas de Revistas"
nLin          := 80

Private aOrd        := {}
Private aReturn     := { "Zebrado",1,"Administracao", 2, 2, 1, '', 1}
Private cString     := 'SZR'
Private cNomeprog   := 'LS_SZR'
Private lEnd        := .F.
Private lAbortPrint := .F.
Private m_pag       := 01
Private nLimite     := 220
Private nTipo       := 18
Private nLastKey    := 0
Private Tamanho     := 'G'
Private wnrel       := 'LS_SZRETQ'

cPerg := 'LS_SZRETQ '
ValidPerg()
Pergunte(cPerg,.t.)


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
	
/*
	MsgBox("Deseja macar revista como entregue?","PERGUNTA","YESNO")
	If MsgBox()
		MsgAlert("Deu certo!","Atenção!!!","ALERT")
	EndIf
  */
nTipo := If(aReturn[4]==1,15,18)  

RptStatus({|lEnd| RunReport( @lEnd) }, cTitulo)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport( lEnd)
///////////////////////////    
@ 0,0 pSay '.'
//SetPrc(0,0)

/*
If mv_par01 == 1
	If !Empty(MV_PAR09)
		_cExpr := ".AND. ZR_CODIGO $ MV_PAR09"
	Else
		_cExpr := " "
	EndIf	
		
	Set filter to ZR_PROXIMA >= mv_par03 .and. ZR_PROXIMA <= mv_par04 .and. ZR_CLIENTE >= MV_PAR05 .AND. ZR_LOJA >= MV_PAR06 .AND. ZR_CLIENTE <= MV_PAR07 .AND. ZR_LOJA <= MV_PAR08 + _cExpr
Else

EndIf
*/
@ 0,0 pSay AvalImp(220)
_nLin := 1


_cQuery := " SELECT * "
_cQuery += _cEnter + " FROM " + RetSqlName('SZR') + " SZR (NOLOCK) "
_cQuery += _cEnter + " WHERE "
If MV_PAR01 == 1
	_cQuery += _cEnter + " ZR_CODIGO = '"+SZR->ZR_CODIGO+"' "
Else	
	_cQuery += _cEnter + " ZR_CLIENTE BETWEEN '" + mv_par05 + "' AND '" + mv_par07 + "' "
	_cQuery += _cEnter + " AND ZR_LOJA BETWEEN '" + mv_par06 + "' AND '" + mv_par08 + "' "
	_cQuery += _cEnter + " AND ZR_PROXIMA BETWEEN '" + DTOS(mv_par03) + "' AND '" + DTOS(mv_par04) + "' "
	_cQuery += _cEnter + " AND ZR_CODIGO IN ('" + mv_par09 + "')"	
EndIf	
_cQuery += _cEnter + " AND SZR.D_E_L_E_T_ = '' "	
TcQuery _cQuery NEW ALIAS "TMP"

count to _nLastRec
SetRegua(_nLastRec)

DbSelectArea("TMP")
TMP->( DbGoTop() )
While TMP->( !Eof() )

	If lAbortPrint .Or. lEnd
		@ _nLin+=2,02 PSay "***CANCELADO PELO OPERADOR!"
		Exit
	EndIf
	
	For _nI := 1 to mv_par02
		IncRegua()
		@ ++_nLin,02 pSay 'ASSINATURA: ' + TMP->ZR_CODIGO + ' - ' + SUBSTR(TMP->ZR_PRODUTO,14,30) + ' - ' + ALLTRIM(SZS->ZS_NUM) + '/' + ALLTRIM(STR(TMP->ZR_EDICOES)) + ' - ' + DTOC(SZS->ZS_ENTREGA)
		@ ++_nLin,02 pSay TMP->ZR_NOMEENT + ' [' + TMP->ZR_CLIENTR + '/' + TMP->ZR_LOJAENT + ']'
		@ ++_nLin,02 pSay TMP->ZR_ENDENTR
		@ ++_nLin,02 pSay TMP->ZR_BAIRENT + ' - ' + alltrim(TMP->ZR_MUNENT) + ' - ' + TMP->ZR_ESTENT
		@ ++_nLin,02 pSay tran(TMP->ZR_CEPENT,'@R 99999-999')
		_nLin++
	Next
	
	TMP->( DbSkip() )
	
EndDo	

If SZS->(DbSeek(xFilial('SZS')+SZR->ZR_CODIGO))

	If MsgBox('Deseja macar revista como entregue?','PERGUNTA','YESNO')
		
		DbSelectArea('SZS')
		DbSetOrder(2)
		
		_lLogic := .f.
		
		Do While SZS->ZS_CODIGO == SZR->ZR_CODIGO .And. _lLogic == .f.
				
			If empty(ZS_ENTREGA) .And. !DELETED()
			
			RecLock('SZS',.F.)
			
			ZS_ENTREGA := dDataBase
			MsUnLock()
            
           	_lLogic := .t.
				
	  		EndIf
            
			DbGoTo(Recno() + 1 ) 

			RecLock('SZR',/*!DbSeek(xFilial('SZS') + SZR->ZR_CODIGO + SZS->ZS_PRODUTO + SZS->ZS_NUM,*/.f.)
			SZR->ZR_PROXIMA := SZS->ZS_RESERVA
			MsUnLock()
					
		  	If Eof()
	    	
	    		MsgBox('Não existe mais entregas para baixar!','Atenção!','ALERT')
				_lLogic := .t.
				
			EndIf
		EndDo	
	EndIf

EndIf	

TMP->( DbCloseArea() )

If aReturn[5]==1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*Static Function RunReport( lEnd)*/
////////////////////////////////
/*
@ 0,0 pSay AvalImp(220)
_nLin := 1



	SetRegua(mv_par02)
	SZRImpEtq()
Else
	count to _nLastRec                                                                                                                                                                                             
	SetRegua(_nLastRec * mv_par02)
	DbGoTop()
   	Do While !eof()
		If lAbortPrint .Or. lEnd
			@ _nLin+=2,02 PSay "***CANCELADO PELO OPERADOR!"
			Exit
		EndIf
		SZRImpEtq()
		DbSkip()
	EndDo
	Set Filter to
EndIf

If aReturn[5]==1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////   ROTINA PARA: RESERVA E TRANSFERENCIA DAS REVISTAS IMPORTADAS PARA O ESTOQUE DO SAC - FILIAL 20 QUANDO HOUVER RESERVA DE ASSINATURAS
/////                ESTORNO DE RESERVA E TRANSFERENCIA DAS REVISTAS IMPORTADAS PARA O ESTOQUE DO SAC - FILIAL 20 QUANDO HOUVER RESERVA DE ASSINATURAS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SZRReser(_xPar)   ///  INCLUI ou EXCLUI
/////////////////////////////
Local _aArea := GetArea()
Local _aAreaSD1 := SD1->(GetArea())
Local _aAreaSF1 := SF1->(GetArea())
Local _aAreaSFT := SFT->(GetArea())
Local _aAreaSF3 := SF3->(GetArea())
Local _aAreaSD3 := SD3->(GetArea())
Local _aAreaSB2 := SB2->(GetArea())

Return()

If cEmpAnt <> '01' .and. cFilAnt <> '55'
	Return()
EndIf

If _xPar == 'INCLUI'
	_cQuery := "SELECT DISTINCT D1_COD, ZR_FILIAL, ZR_CODIGO, ZR_DTDIGIT, ZR_CLIENTE, ZR_LOJA, ZR_NOME, ZR_MAILCLI, ZR_FONECLI, "
	_cQuery += _cEnter + " ZR_CLIENTR, ZR_LOJAENT, ZR_NOMEENT, ZR_MAILENT, ZR_FONEENT, ZR_ENDENTR, ZR_BAIRENT, ZR_CEPENT, ZR_MUNENT, ZR_ESTENT, ZR_FORPAG, ZR_COND,"
	_cQuery += _cEnter + " ZR_DESCCP, ZR_CCNRO, ZR_CCSEGUR, ZR_CCVALID, ZR_COD, ZR_PRODUTO, ZR_QUANT, ZR_EDICOES, ZR_PERIOD, ZR_INICIO, ZR_TERMINO, "
	_cQuery += _cEnter + " ZR_CANCELA, ZR_MOTIVO, ZR_VUNIT, ZR_QEJE, ZR_ULTIMA ZR_PROXIMA"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('SZR') + " SZR (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	_cQuery += _cEnter + " ON D1_FILIAL = '" 	+ SF1->F1_FILIAL 	+ "'"
	_cQuery += _cEnter + " AND D1_DOC = '" 		+ SF1->F1_DOC 		+ "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" 	+ SF1->F1_SERIE 	+ "'"
	_cQuery += _cEnter + " AND D1_FORNECE = '" 	+ SF1->F1_FORNECE 	+ "'"
	_cQuery += _cEnter + " AND D1_LOJA = '" 	+ SF1->F1_LOJA 		+ "'"
	_cQuery += _cEnter + " AND D1_GRUPO = '0006'"							// somente para grupo de revistas importadas
	_cQuery += _cEnter + " AND LEFT(D1_COD,LEN(RTRIM(ZR_COD))) = RTRIM(ZR_COD)"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND F4_CODIGO = D1_TES"
	_cQuery += _cEnter + " AND F4_ESTOQUE = 'S'"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE1') + " SE1 (NOLOCK)"
	_cQuery += _cEnter + " ON SE1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND E1_CLIENTE = ZR_CLIENTE"
	_cQuery += _cEnter + " AND E1_LOJA = ZR_LOJA"
	_cQuery += _cEnter + " AND E1_PREFIXO = 'ASS'"
	_cQuery += _cEnter + " AND E1_NUM = ZR_CODIGO"
	_cQuery += _cEnter + " AND ZR_ULTIMA < D1_DTDIGIT"
	_cQuery += _cEnter + " AND ZR_PROXIMA > D1_DTDIGIT"
	
	_cQuery += _cEnter + " WHERE SZR.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND ZR_PROXIMA >= '" + dtos(dDataBase) + "'"		// data da proxima entrega maior que HOJE
	_cQuery += _cEnter + " AND ZR_ULTIMA < '" + dtos(dDataBase) + "'"		// data da ultima entrega é menor que HOJE
	_cQuery += _cEnter + " AND ZR_CANCELA = ''"								// nao está cancelado
	_cQuery += _cEnter + " AND ZR_QEJE < ZR_EDICOES"						// não entregou todas as edicoes
	_cQuery += _cEnter + " AND ZR_TERMINO > '" + dtos(dDataBase) + "'"		// data da previsao de termino da assinatura maior que HOJE
	_cQuery += _cEnter + " ORDER BY D1_COD"
	
	U_GravaQuery('SZRPROCASSINA.SQL',_cQuery)
	MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SZR', .F., .T.) },'Pesquisando assinaturas...')
	
	If !eof()
		Processa({||SZRProcAssina()})
	EndIf
	DbCloseArea()

Else

	_cQuery := "SELECT SZS.*, ZR_QUANT"
	_cQuery += _cEnter + " FROM SZS010 SZS (NOLOCK)"

	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	_cQuery += _cEnter + " ON D1_FILIAL = '" 	+ SF1->F1_FILIAL 	+ "'"
	_cQuery += _cEnter + " AND D1_DOC = '" 		+ SF1->F1_DOC 		+ "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" 	+ SF1->F1_SERIE 	+ "'"
	_cQuery += _cEnter + " AND D1_FORNECE = '" 	+ SF1->F1_FORNECE 	+ "'"
	_cQuery += _cEnter + " AND D1_LOJA = '" 	+ SF1->F1_LOJA 		+ "'"
	_cQuery += _cEnter + " AND D1_COD = ZS_PRODUTO"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND F4_CODIGO = D1_TES"
	_cQuery += _cEnter + " AND F4_ESTOQUE = 'S'"

	_cQuery += _cEnter + " INNER JOIN SZR010 SZR (NOLOCK)"
	_cQuery += _cEnter + " ON SZR.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND ZR_CODIGO = ZS_CODIGO"
 	_cQuery += _cEnter + " WHERE SZS.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND ZS_RESERVA = '" + dtos(dDataBase) +"'"
	_cQuery += _cEnter + " AND ZS_PRODUTO = '" + SD1->D1_COD + "'"
	
	U_GravaQuery('SZR_ExcAssina.SQL',_cQuery)
	MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SZR', .F., .T.) },'Pesquisando assinaturas...')
	
	If !eof()
		Processa({||SZRExcAssina()})
	EndIf
	DbCloseArea()
	
EndIf

RestArea(_aAreaSF1)
RestArea(_aAreaSD1)
RestArea(_aAreaSFT)
RestArea(_aAreaSF3)
RestArea(_aAreaSD3)
RestArea(_aAreaSB2)
RestArea(_aArea)

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////   ROTINA PARA RESERVA E TRANSFERENCIA DAS REVISTAS IMPORTADAS PARA O ESTOQUE DO SAC - FILIAL 20 QUANDO HOUVER RESERVA DE ASSINATURAS
/////////////////// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function SZRProcAssina()
/////////////////////////////
Count to _nLastRec
DbGoTop()
Do While !eof()
	
	_cChave := _SZR->D1_COD
	_nQuant := 0
	Do While !eof() .and. _cChave == _SZR->D1_COD
		
		IncProc()
		_nQuant += _SZR->ZR_QUANT
		
		DbSelectArea('SZR')
		DbSeek(xFilial('SZR') + _SZR->ZR_CODIGO,.f.)
		RecLock('SZR',.f.)
		SZR->ZR_QEJE    += _SZR->ZR_QUANT
		SZR->ZR_PROXIMA += iif(SZR->ZR_PERIOD == '1', 7, iif(SZR->ZR_PERIOD == '2',15, iif(SZR->ZR_PERIOD == '3',30, 60)))
		SZR->ZR_ULTIMA  := dDataBase
		MsUnLock()

		DbSelectArea('SZS')
		RecLock('SZS',!DbSeek(xFilial('SZS') + _SZR->ZR_CODIGO + _SZR->D1_COD,.f.))
		SZS->ZS_CODIGO  := _SZR->ZR_CODIGO
		SZS->ZS_RESERVA := dDataBase
		SZS->ZS_PRODUTO := _SZR->D1_COD
		MsUnLock()
		
		DbSelectArea('_SZR')
		DbSkip()
		
	EndDo
	
	_aReq := {}				// MI de saida na centralizadora (Matriz ou CD)
	aAdd(_aReq,{"D3_TM" 	 , '900'													, Nil})
	aAdd(_aReq,{"D3_Filial"  , cFilAnt     												, Nil})
	aAdd(_aReq,{"D3_COD" 	 , _cChave													, Nil})
	aAdd(_aReq,{"D3_UM" 	 , Posicione('SB1',1,xFilial('SB1') + _cChave,'B1_UM')		, Nil})
	aAdd(_aReq,{"D3_QUANT" 	 , _nQuant													, Nil})
	aAdd(_aReq,{"D3_LOCAL" 	 , '01'         											, Nil})
	aAdd(_aReq,{"D3_TIPO" 	 , SB1->B1_TIPO												, Nil})
	aAdd(_aReq,{"D3_EMISSAO" , dDataBase    											, Nil})
	
	lMsErroAuto := .F.
	MsExecAuto({|x,y|MATA240(x,y)} , _aReq , 3)
	
	If lMsErroAuto
		MostraErro()
	Endif
	
	_cFilAnt := cFilAnt
	cFilAnt := '20'		// SAC - MI de entrada no SAC
	_aReq := {}
	aAdd(_aReq,{"D3_TM" 	 , '400'			, Nil})
	aAdd(_aReq,{"D3_Filial"  , cFilAnt     		, Nil})
	aAdd(_aReq,{"D3_COD" 	 , _cChave			, Nil})
	aAdd(_aReq,{"D3_UM" 	 , SB1->B1_UM      	, Nil})
	aAdd(_aReq,{"D3_QUANT" 	 , _nQuant 			, Nil})
	aAdd(_aReq,{"D3_LOCAL" 	 , '01'         	, Nil})
	aAdd(_aReq,{"D3_TIPO" 	 , SB1->B1_TIPO		, Nil})
	aAdd(_aReq,{"D3_EMISSAO" , dDataBase    	, Nil})
	
	lMsErroAuto := .F.
	MsExecAuto({|x,y|MATA240(x,y)} , _aReq , 3)
	
	If lMsErroAuto
		MostraErro()
	Endif
	
	DbSelectArea('_SZR')
	
EndDo

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////   ROTINA PARA ESTORNO DE RESERVA E TRANSFERENCIA DAS REVISTAS IMPORTADAS PARA O ESTOQUE DO SAC - FILIAL 20 QUANDO HOUVER RESERVA DE ASSINATURAS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function SZRExcAssina()
/////////////////////////////
Count to _nLastRec
DbGoTop()
Do While !eof()
	
	_cChave := _SZR->ZS_PRODUTO
	_nQuant := 0
	Do While !eof() .and. _cChave == _SZR->ZS_PRODUTO
		
		IncProc()
		_nQuant += _SZR->ZR_QUANT
		_dData := ctod('')
		DbSelectArea('SZS')
		If DbSeek(xFilial('SZS') + _SZR->ZS_CODIGO + _SZR->ZS_PRODUTO,.f.)
			_dData := SZS->ZS_RESERVA
			RecLock('SZS',.f.)
			DbDelete()
			MsUnLock()
		EndIf
		
		DbSelectArea('SZR')
		If DbSeek(xFilial('SZR') + _SZR->ZS_CODIGO,.f.)
			RecLock('SZR',.f.)
			SZR->ZR_QEJE    -= _SZR->ZR_QUANT
			SZR->ZR_PROXIMA := _dData
			SZR->ZR_ULTIMA  := ctod('')
			MsUnLock()
        EndIf
        
		DbSkip()
		
	EndDo
	
	_aReq := {}				// MI de saida na centralizadora (Matriz ou CD)
	aAdd(_aReq,{"D3_TM" 	 , '900'													, Nil})
	aAdd(_aReq,{"D3_Filial"  , cFilAnt     												, Nil})
	aAdd(_aReq,{"D3_COD" 	 , _cChave													, Nil})
	aAdd(_aReq,{"D3_UM" 	 , Posicione('SB1',1,xFilial('SB1') + _cChave,'B1_UM')		, Nil})
	aAdd(_aReq,{"D3_QUANT" 	 , _nQuant													, Nil})
	aAdd(_aReq,{"D3_LOCAL" 	 , '01'         											, Nil})
	aAdd(_aReq,{"D3_TIPO" 	 , SB1->B1_TIPO												, Nil})
	aAdd(_aReq,{"D3_EMISSAO" , dDataBase    											, Nil})
	lMsErroAuto := .F.
	MsExecAuto({|x,y|MATA240(x,y)} , _aReq , 3)
	
	If lMsErroAuto
		MostraErro()
	Endif
	
	_cFilAnt := cFilAnt
	cFilAnt := '20'		// SAC - MI de entrada no SAC
	_aReq := {}
	aAdd(_aReq,{"D3_TM" 	 , '400'			, Nil})
	aAdd(_aReq,{"D3_Filial"  , cFilAnt     		, Nil})
	aAdd(_aReq,{"D3_COD" 	 , _cChave			, Nil})
	aAdd(_aReq,{"D3_UM" 	 , SB1->B1_UM      	, Nil})
	aAdd(_aReq,{"D3_QUANT" 	 , _nQuant 			, Nil})
	aAdd(_aReq,{"D3_LOCAL" 	 , '01'         	, Nil})
	aAdd(_aReq,{"D3_TIPO" 	 , SB1->B1_TIPO		, Nil})
	aAdd(_aReq,{"D3_EMISSAO" , dDataBase    	, Nil})
	
	lMsErroAuto := .F.
	MsExecAuto({|x,y|MATA240(x,y)} , _aReq , 3)
	
	If lMsErroAuto
		MostraErro()
	Endif
	
	DbSelectArea('_SZR')
	
EndDo

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static function ValidPerg()
///////////////////////////

PutSX1(cPerg,"01","Forma de Impressão","Forma de Impressão","Forma de Impressão", "mv_ch1", "N",01,0,0,"C","",""	 ,"",,"mv_par01","Individual","","","","Grupo","","","","","","","","","","","")
PutSX1(cPerg,"02","Quantidade        ","Quantidade        ","Quantidade        ", "mv_ch2", "N",02,0,0,"G","",""	 ,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Data remessa de   ","Data remessa de   ","Data remessa de   ", "mv_ch3", "D",08,0,0,"G","",""	 ,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Data remessa ate  ","Data remessa ate  ","Data remessa ate  ", "mv_ch4", "D",08,0,0,"G","",""	 ,"",,"mv_par04","","","","","","","","","","","","","","","","")

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function Dtterm()
///////////////////////////

Local _nDias   := 0
Local _nMes    := 0
Local _dVer    := CTOD("")

DO CASE
 CASE ZR_PERIOD == '1' 
	_nDias  := (ZR_EDICOES - 1) * 7
	ZR_TERMINO := DaySum(ZR_INICIO,_nDias)
	 
 CASE ZR_PERIOD == '2' 
	_nDias  := (ZR_EDICOES - 1) * 14
	ZR_TERMINO := DaySum(ZR_INICIO,_nDias)

 CASE ZR_PERIOD == '3' 
	_nMes  := (ZR_EDICOES - 1)
	ZR_TERMINO := MonthSum(ZR_INICIO,_nMes)
	 
 CASE ZR_PERIOD == '4'
	_nMes  := (ZR_EDICOES * 2) - 2
	ZR_TERMINO := MonthSum(ZR_INICIO,_nMes)
	_dVer := ZR_TERMINO

	IF _dVer == ''
  		_dVer := DaySum(MonthSum(ZR_INICIO,_nMes),1)
  		ZR_TERMINO := _dVer
//      Return(ZR_TERMINO)
  
  	Else	
	EndIf	 	 
	
ENDCASE

Return(ZR_TERMINO)
                

//////////////////////////////
Static Function PROGMOV(_dRef)
/////////////////////////////


Local _nNum		:= 1

//	DbSelectArea('SZS')

For _nCount := 1 to SZR->ZR_EDICOES
	
	//		DbGoTop()
	DbSelectArea('SZS')
	DbSetOrder(1)
	
	// 		Do While !Eof()
	RecLock('SZS',/*!DbSeek(xFilial('SZS') + SZR->ZR_CODIGO + SZS->ZS_PRODUTO + SZS->ZS_NUM,*/.t.)
	SZS->ZS_CODIGO  := SZR->ZR_CODIGO
	SZS->ZS_RESERVA := _dRef
	SZS->ZS_PRODUTO := SZR->ZR_COD
	SZS->ZS_NUM		:= alltrim(str(_nNum))
	MsUnLock()

	_dRef1		:= _dRef		
	_dRef	 	:= Iif(SZR->ZR_PERIOD == '1', daysum(_dRef1,7), iif(SZR->ZR_PERIOD == '2', DaySum(_dRef1,14), iif(SZR->ZR_PERIOD == '3', MonthSum(_dRef1,1), MonthSum(_dRef1,2))))
	_nNum		+= 1
	
Next

Posicione('SZS',2,xFilial('SZS')+ZS_CODIGO,'ZS_RESERVA')
	RecLock('SZR',/*!DbSeek(xFilial('SZS') + SZR->ZR_CODIGO + SZS->ZS_PRODUTO + SZS->ZS_NUM,*/.f.)
	SZR->ZR_PROXIMA := SZS->ZS_RESERVA
	MsUnLock()
	
DbSkip()

Return()
                  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*User function DtProx()
///////////////////////////

Local _nDias   := 0
Local _nMes    := 0
Local _dVer    := 

Return()*/