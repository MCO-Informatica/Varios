#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

// 	Programa:	MT097BUT
//	Autor:		Alexandre Dalpiaz
//	Data:		17/05/08
//	Uso:		Frigorifico Mercosul
//	Funcao:		ponto de entrada da liberacao de pedidos de compra
//              habilita botao "ESPECIFICO"  na tela de liberacao de PCs, permitindo visualizar o pedidos de compra

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT097BUT()
////////////////////////

dbSelectArea("SC7")
dbSetOrder(1)
If DbSeek(SCR->CR_FILIAL+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
	Mata120(NIL,NIL,NIL,2)
EndIf
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_097()
//////////////////////

Local ca097User
Local cFitroUs  := ""
Local aCores :={   	   ;
{ 'CR_STATUS== "02"', 'DISABLE' },;
{ 'CR_STATUS== "01" .and. CR_NIVEL = "02" ', 'BR_AMARELO' },;
{ 'CR_STATUS== "03"', 'ENABLE'  },;
{ 'CR_STATUS== "04"', 'BR_PRETO'},;
{ 'CR_STATUS== "05"', 'BR_CINZA'} }
Private cFiltraSCR
PRIVATE aIndexSCR	:= {}
PRIVATE bFilSCRBrw := {|| Nil}
PRIVATE cXFiltraSCR
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := {{"Pesquisar"			,"Ma097Pesq",   0 , 1},; //
					{"Consulta pedido"		,"A097Visual",  0 , 2},; //
					{"Consulta Saldos"		,"A097Consulta",0 , 2},; //
					{"Liberar"				,"A097Libera",  0 , 4},; //
					{"Estornar"				,"A097Estorna", 0 , 4},; //
					{"Superior"				,"A097Superi",  0 , 4},; //
					{"Transf. para Superior","A097Transf",  0 , 4},; //
					{"Ausencia Temporaria"	,"A097Ausente", 0 , 3},; //
					{'Todas filiais'		,"U_A097Filiais",  0 , 3,1},;
					{"Legenda"				,"A097Legend",  0 , 2}}  //

PRIVATE cCadastro := "Liberacao do PC"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o usuario possui direito de liberacao.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ca097User := RetCodUsr()
dbSelectArea("SAK")
dbSetOrder(2)

If !(ca097User $ GetMv('LA_PODER')) .and. !MsSeek(xFilial("SAK")+ca097User)
	Help(" ",1,"A097APROV")
	dbSelectArea("SCR")
	dbSetOrder(1)
Else
	
	If Pergunte("MTA097",.T.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Controle de Aprovacao : CR_STATUS -->                ³
		//³ 01 - Bloqueado p/ sistema (aguardando outros niveis) ³
		//³ 02 - Aguardando Liberacao do usuario                 ³
		//³ 03 - Pedido Liberado pelo usuario                    ³
		//³ 04 - Pedido Bloqueado pelo usuario                   ³
		//³ 05 - Pedido Liberado por outro usuario               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicaliza a funcao FilBrowse para filtrar a mBrowse          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SCR")
		dbSetOrder(1)      
		cFiltraSCR  := ''
		If (ca097User $ GetMv('LA_PODER'))
			_cUser := LS_RetAprov()
			If !empty(_cUser)
				cFiltraSCR := " CR_APROV = '"+_cUser+"' .AND. "
			EndIf
		Else
			cFiltraSCR  := 'CR_USER=="'  + ca097User + '" .AND.'
		EndIf
		Do Case
			Case mv_par01 == 1
				cFiltraSCR += ' CR_STATUS=="02"'
			Case mv_par01 == 2
				cFiltraSCR += ' (CR_STATUS=="03".OR.CR_STATUS=="05")'
			Case mv_par01 == 3
				cFiltraSCR += ' CR_STATUS!="01"'
			OtherWise
				cFiltraSCR += ' (CR_STATUS=="01".OR.CR_STATUS=="04")'
		EndCase
				
		bFilSCRBrw 	:= {|| FilBrowse("SCR",@aIndexSCR,@cFiltraSCR) }
		Eval(bFilSCRBrw)
		mBrowse( 6, 1,22,75,"SCR",,,,,,aCores)
		EndFilBrw("SCR",aIndexSCR)
		
	EndIf
EndIf
Return Nil

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function A097Filiais()
///////////////////////////
Local aCores :={   	    { 'CR_STATUS== "01"', 'BR_AZUL' },;   //Bloqueado p/ sistema (aguardando outros niveis)
						{ 'CR_STATUS== "02"', 'DISABLE' },;   //Aguardando Liberacao do usuario
						{ 'CR_STATUS== "03"', 'ENABLE'  },;   //Pedido Liberado pelo usuario
						{ 'CR_STATUS== "04"', 'BR_PRETO'},;   //Pedido Bloqueado pelo usuario
						{ 'CR_STATUS== "05"', 'BR_CINZA'} }   //Pedido Liberado por outro usuario

_ca097User 	:= RetCodUsr()
_cFiltraSCR	:= 'CR_USER=="' + _ca097User + '" .AND.'

Do Case
	Case mv_par01 == 1
		_cFiltraSCR += ' CR_STATUS=="02"'
	Case mv_par01 == 2
		_cFiltraSCR += ' (CR_STATUS=="03".OR.CR_STATUS=="05")'
	Case mv_par01 == 3
		_cFiltraSCR += ' CR_STATUS!="01"'
	OtherWise
		_cFiltraSCR += ' (CR_STATUS=="01".OR.CR_STATUS=="04")'
EndCase

/*
CloseBrowse()
alert('teste')
bFilSCRBrw 	:= {|| FilBrowse("SCR",@aIndexSCR,@_cFiltraSCR) }
Eval(bFilSCRBrw)
mBrowse( 6, 1,22,75,"SCR",,,,,,aCores)
cfilant:='00'
DbGoTop()
*/

DbSelectArea('SM0')
_nRec := Recno()
DbgoTop()
_aEmp := {}
Do While !eof()
	If TCCanOpen("SCR" + SM0->M0_CODIGO + "0") .and. aScan(_aEmp,SM0->M0_CODIGO) == 0
		aAdd(_aEmp,SM0->M0_CODIGO)
	EndIf
	DbSkip()
EndDo
DbGoTo(_nRec)

_cQuery  := ''
For _nI := 1 to len(_aEmp)
		_cQuery += " SELECT '" + _aEmp[_nI] + "' EMPRESA, CR_FILIAL, CR_NUM, CR_EMISSAO, CR_TOTAL"
		_cQuery  += " FROM SCR" + _aEmp[_nI] + "0 SCR (NOLOCK) "
		_cQuery  += " WHERE CR_USER = '" + _ca097User + "'"
		Do Case
			Case mv_par01 == 1
				_cQuery  += " AND CR_STATUS = '02'"
			Case mv_par01 == 2
				_cQuery  += " AND (CR_STATUS = '03' OR CR_STATUS = '05')"
			Case mv_par01 == 3
				_cQuery  += " AND CR_STATUS <> '01'"
			OtherWise
				_cQuery  += " AND (CR_STATUS = '01' OR CR_STATUS = '04')"
		EndCase
		
		If _nI < len(_aEmp)
			_cQuery  += " UNION "
		EndIf
	
Next

_cQuery += " ORDER BY EMPRESA, CR_FILIAL, CR_NUM"

MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'TRB',.f.,.f.)},'Selecionando pedidos bloqueados...')
_cLibs := ''

Do While !eof()
	_cFil := TRB->EMPRESA + TRB->CR_FILIAL
	_cLibs += 'Empresa/Filial: ' + tran(_cFil,'@R 99/99') + ' - ' + alltrim(Posicione('SM0',1,_cFil,'M0_NOME')) + ' / ' + SM0->M0_FILIAL + _cEnter + _cEnter
	Do While !eof() .and. _cFil == TRB->EMPRESA + TRB->CR_FILIAL
		_cLibs += alltrim(TRB->CR_NUM) + '   ' + dtoc(stod(TRB->CR_EMISSAO)) + '   ' + tran(TRB->CR_TOTAL,'@E 999,999.99') + _cEnter
		DbSkip()
	EndDo
	_cLibs += replicate('-',100) + _cEnter + _cEnter
EndDo
DbCloseArea()

Aviso('Pedidos Bloqueados', _cLIbs ,{'OK'} , 3 )

Return()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_RetAprov()
/////////////////////////////
Local _cRet := '      '

Define MsDialog _oDlg2 Title "Aprovador"  From 000,000 to 100,200 of oMainWnd Pixel
@ 010,010 say 'Aprovador:' 						 	Size 040,010  Pixel of _oDlg2
@ 010,050 Msget _cRet F3 'SAK'     					Size 050,010  Pixel of _oDlg2
@ 030,010 BmpButton Type 1 Action (_oDlg2:End())	
Activate MsDialog _oDlg2 Centered

Return _cRet
