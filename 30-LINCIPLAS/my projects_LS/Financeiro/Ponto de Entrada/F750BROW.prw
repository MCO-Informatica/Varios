#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa		F750BROW
// Autor		Antonio Carlos
// Data			24/07/08
// Descricao	Filtro do Browse no Contas a Pagar
// Uso			Laselva S/A
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	21/09/12 - 13:41 - Alexandre - F750BROW - criados os PE ULTILOTE, FA070BXL e F070OWN para tratamento do filtro na baixa por lote de titulos a receber
//	08/11/13 - Thiago Queiroz - Removido filtro personalizado para utilizar o filtro padrão da VERSÃO 11
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F750BROW()
////////////////////////


Local _aRot             

U_LS_MATRIZ()

Public _cFilBrow	:= "E2_MATRIZ == '" + cFilAnt + "'" // ALTERADO POR alexandre em 29/7/2011

/*
Sendo assim, a expressão de filtro definida como:
cFiltra       := "F1_FORNECE+F1_LOJA$'" + SA2->( A2_COD+A2_LOJA ) + "'"

será otimizada se for reescrita e prefixada com o símbolo “@”.
cFiltra        := SA2->( "@F1_FORNECE='"+A2_COD+"' AND F1_LOJA='"+A2_LOJA+ "'" )

Na primeira forma, o filtro será avaliado registro a registro tornando-o lento, já na segunda, usamos uma expressão SQL que será resolvida diretamente pelo SGBD deixando o retorno do filtro muito, mas muito,  rápido.

A versão completa do Código com a otimização do filtro ficaria assim:

Read more: http://www.blacktdn.com.br/2011/09/protheus-advpl-otimizando-o-filtro-de.html#ixzz2EHX2TZjF

*/

DbSelectArea('SE2')
Set Filter to &_cFilBrow

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Autor 		Alexandre Dalpiaz
// Data 		28/04/10
// Descricao  	Consulta nota fiscal de saida/entrada a partir do titulo a pagar
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

aAdd(aRotina[06,2], { 'Manutenção','U_LS_590(2)', 0 , 2})

_aRot := {}
aAdd( _aRot,	{ 'Título'		, 'U_FM750NF(1)'	, 0 , 2})
aAdd( _aRot,	{ 'Nota Fiscal'	, 'U_FM750NF(2)'	, 0 , 2})

aAdd( aRotina,	{ 'Cons&ultar'	, _aRot, 0 , 2})
aAdd( aRotina[ 4,2],	{ 'Canc Bxa Cheque' , 'U_LS_CANBXCH()'	, 0 , 2})
aAdd( aRotina[10,2],	{ 'Canc Bxa Cheque' , 'U_LS_CANBXCH()'	, 0 , 2})

_aRot := {}

aAdd( aRotina,	{ 'Cod Barras' , 'U_LS_CodBar("SE2",_cFilBrow)'	, 0 , 2})
//aAdd( aRotina,	{ 'Filtro'     , 'U_LS_FILTRO("SE2",_cFilBrow)'	, 0 , 2})

If '/'+ __cUserId + '/' $ GetMV('LS_GERFINA') + GetMv('LA_PODER')
	aAdd( aRotina,	{ 'Liberar Tít'	  , 'U_LS750LIB(2)'	, 0 , 2})
	aAdd( aRotina,	{ 'Lib/Bloq Data' , 'U_LS750LIB(3)'	, 0 , 2})
EndIf
//aAdd( aRotina,	{ 'Desdobramento' , 'U_LS_DESDOB()'	, 0 , 2})

//aRotina[12,2,2] := {'Receber Arquivo', 'U_LS_FA430',0,2}
aAdd(aRotina, { 'Relatório Retorno','U_FINR01', 0 , 2})

If '/'+ __cUserId + '/' $ GetMv('LA_PODER')
	aAdd(aRotina, { 'Conf CNAB Mod 1','CFGX043', 0 , 2})
	aAdd(aRotina, { 'Conf CNAB Mod 2','CFGX049', 0 , 2})
EndIf

_aRot13 := aClone(aRotina[13])

_aRot := {}
aAdd( _aRot,	{ 'Títulos a pagar'			, 'FINR150'	, 0 , 2})
aAdd( _aRot,	{ 'Emissão de Borderôs'		, 'FINR170'	, 0 , 2})
aAdd( _aRot,	{ 'Posição de Fornecedores'	, 'FINR350'	, 0 , 2})
aAdd( _aRot,	{ 'Pos. Fornec. Laselva'  	, 'U_LS_F350'	, 0 , 2})
aAdd( _aRot,	{ 'Relação de Cheques'		, 'FINR400'	, 0 , 2})
aAdd( _aRot,	{ 'Cheques Especiais'		, 'FINR460'	, 0 , 2})
aAdd( _aRot,	{ 'Impressão de Cheques'	, 'FINR480'	, 0 , 2})
aAdd( _aRot,	{ 'Cópia de Cheques'		, 'FINR490'	, 0 , 2})
aAdd( _aRot,	{ 'Cheques Cancelados'		, 'FINR540'	, 0 , 2})
aAdd( _aRot,	{ 'Borderô de Pagamentos'	, 'FINR710' , 0 , 2})
aAdd( _aRot,	{ 'Pos. Geral de C. Pagar'	, 'FINR330'	, 0 , 2})
aAdd( _aRot,	{ 'Retenção de Impostos'	, 'FINR865'	, 0 , 2})
aAdd( _aRot,	{ 'Tít Pagar c/ Ret. Imp.'	, 'FINR855'	, 0 , 2})
aAdd( _aRot,	{ 'Relação de Aglutinadores', 'FINR875'	, 0 , 2})
aAdd( _aRot,	{ 'Relação Aglut. Impostos'	, 'FINR930'	, 0 , 2})

aRotina[13] := {'Relatór&ios', aClone(_aRot),0,2}
aAdd(aRotina, aClone(_aRot13))

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// liberação de pagamento de título bloqueado por haver pagamentos antecipados para o fornecedor.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS750LIB(_xPar)
/////////////////////////////
Local aInd := {}

If _xPar == 3
	If upper(left(GetMv('LS_CANCBAI'),1)) == 'N'
		If MsgBox('Baixa fora da data está bloqueada.' + _cEnter + 'Deseja liberar?','ATENÇÃO!!!','YESNO')
			PutMv('LS_CANCBAI','S')
		EndIf
	Else
		If MsgBox('Baixa fora da data está liberada.' + _cEnter + 'Deseja bloquear?','ATENÇÃO!!!','YESNO')
			PutMv('LS_CANCBAI','N')
		EndIf
	EndIf
	Return()
EndIf

If SE2->E2_HORASPB <> 'BLOCK'
	MsgBox('Título não está bloqueado','ATENÇÃO!!!','ALERT')
	Return()
EndIf

_cQuery := "SELECT E2_MSFIL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VALOR, E2_SALDO, E2_EMISSAO"
_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
_cQuery += _cEnter + " WHERE E2_TIPO IN ('PA','NDF')"
_cQuery += _cEnter + " AND E2_SALDO > 0"
_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND E2_FORNECE = '" + SE2->E2_FORNECE + "'"
_cQuery += _cEnter + " AND E2_LOJA = '" + SE2->E2_LOJA + "'"
_cQuery += _cEnter + " AND E2_MATRIZ = '" + cFilAnt + "'"

MsAguarde( {|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SE2PA', .F., .F.)},"Procurando PA's em aberto...")

TcSetField("SE2PA","E2_EMISSAO"	,"D"	,8	,0)

DbGoTop()

_cTexto := ''
Do While !eof()
	_cTexto += SE2PA->E2_MSFIL + ' ' + SE2PA->E2_PREFIXO + ' ' + SE2PA->E2_NUM + ' ' + SE2PA->E2_PARCELA + ' '
	_cTexto += dtoc(SE2PA->E2_EMISSAO) + ' ' + tran(SE2PA->E2_VALOR,'@E 99,999,999.99') + ' ' + tran(SE2PA->E2_SALDO,'@E 99,999,999.99') + _cEnter
	DbSkip()
EndDo

If !empty(_cTexto)
	_lRet    := .f.
	_cRecebe := alltrim(SE2->E2_NUMTIT)
	_cTexto  := 'Filial Prefixo Numero Parcela Emissão Valor Saldo' + _cEnter + _cEnter + _cTexto + _cEnter + _cEnter
	_cTexto  += 'Liberar pagamento do título?'
	If MsgBox(_cTexto,'Liberação para pagamento','YESNO')
		_cQuery := "UPDATE " + RetSqlName('SE2')
		_cQuery += _cEnter + " SET E2_HORASPB = '', E2_NUMTIT = ''"
		_cQuery += _cEnter + " WHERE D_E_L_E_T_ = ''"
		_cQuery += _cEnter + " AND E2_FORNECE = '" + SE2->E2_FORNECE + "'"
		_cQuery += _cEnter + " AND E2_LOJA = '" + SE2->E2_LOJA + "'"
		_cQuery += _cEnter + " AND E2_FILIAL = ''"
		_cQuery += _cEnter + " AND E2_MSFIL = '" + SE2->E2_MSFIL + "'"
		_cQuery += _cEnter + " AND E2_NUM = '" + SE2->E2_NUM + "'"
		_cQuery += _cEnter + " AND E2_PREFIXO = '" + SE2->E2_PREFIXO + "'"
		
		TcSqlExec(_cQuery)
	EndIf
Else
	MsgBox('Título não está bloqueado')
EndIf

SE2PA->(DbCloseArea())
DbSelectArea('SE2')

eMail()

Return()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_590(_xRadio)
////////////////////////////

Private lF590Pag := ExistBlock("F590PAG")
Private lF590Rec := ExistBlock("F590REC")
Private cNumBor  := CriaVar("EA_NUMBOR")
PRIVATE cPort590 ,cAgen590 , cConta590,cModPgto, cTipoPag
PRIVATE cLote

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procura o Lote do Financeiro                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LoteCont( "FIN" )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ A fun‡„o SomaAbat reabre o SE1/SE2 com outro nome pela ChkFile,  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SomaAbat("","","","P")
SomaAbat("","","","R")

cFilial := xFilial('SEA')
nOpca   := 0
DbSelectArea('SEA')
DbSetOrder(1)
nRadio := _xRadio

DEFINE MSDIALOG oDlg FROM  094,1 TO 200,293 TITLE 'Manutenção de Borderôs' PIXEL

@ 05,07 TO 32, 140 OF oDlg  PIXEL
@ 10,60 SAY 'Borderô nro:'	   SIZE 023,07 OF oDlg PIXEL  //"Bordero"
@ 10,90 MSGET cNumBor          SIZE 023,10 OF oDlg PIXEL Valid FA590NumC()

DEFINE SBUTTON FROM 35,085 TYPE 1 ENABLE OF oDlg ACTION (nOpca := 1, oDlg:End())
DEFINE SBUTTON FROM 35,115 TYPE 2 ENABLE OF oDlg ACTION (nOpca := 0, oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	
	SEA->( dbSeek(cFilial+cNumBor,.t.) )
	If Fa590NumC()
		cPort590 :=	SEA->EA_PORTADO
		cAgen590 :=	SEA->EA_AGEDEP
		cConta590:=	SEA->EA_NUMCON
		cModPgto :=	SEA->EA_MODELO
		cTipoPag :=	SEA->EA_TIPOPAG
	Else
		Return
	Endif
	
	If SEA->EA_CART == "P"
		_Fin590('SE2') 	//lF590Pag)
	Else
		_Fin590('SE1')	//lF590Rec)
	Endif
	
Else
	
	Return
	
EndIf

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FM750NF(_xPar)  // CONSULTA NOTA FISCAL A PARTIR DO DO TITULO
///////////////////////////////////////////////////////////////////////////
Local _cFilAnt
Local _aAlias := GetArea()

_aAlias := GetArea()

If _xPar == 1
	_cFilAnt := cFilAnt
	Fc050Con()
	cFilAnt := _cFilAnt
Else
	
	If	SE2->E2_FATURA = 'NOTFAT'
		_cQuery := "SELECT E2_NUM, E2_PREFIXO, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_ORIGEM, E2_EMISSAO, SE2.R_E_C_N_O_ REGISTRO "
		_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
		_cQuery += _cEnter + " WHERE E2_FATURA = '" + SE2->E2_NUM + "'"
		_cQuery += _cEnter + " AND E2_FILIAL = ''"
		_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + " ORDER BY E2_EMISSAO"
		
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SE2', .F., .T.)
		If !eof()
			_cArq := CriaTrab(,.f.)
			copy to &_cArq
			DbCloseArea()
			DbUseArea( .T.,,_cArq, "_SE2", .F., .F. )
		EndIf
		
		_aNotas := {}
		Do While !eof()
			aAdd(_aNotas,_SE2->E2_PREFIXO + ' / ' + _SE2->E2_NUM)
			DbSkip()
		EndDo
		
		_lTela := .t.
		If len(_aNotas) > 1
			
			Do While _lTela
				
				_nNota  := 1
				_cCombo := _aNotas[1]
				_lTela  := .f.
				DEFINE MSDIALOG oDlg FROM 000,000 TO 400,400 TITLE "Visualiza Nota Fiscal" PIXEL
				
				@ 010, 010 say 'Este título é uma fatura e pode ter sido originado' PIXEL
				@ 020, 010 say 'a partir de mais de uma nota/título' PIXEL
				@ 030, 010 say 'Selecione o título que deseja consultar'  PIXEL
				
				_oCombo:= TComboBox():New(040,090,{|u|if(PCount()>0,_cCombo:=u,_cCombo)},;
				_aNotas,65,20,oDlg,,{|| _nNota := aScan(_aNotas,_cCombo) },,,,.T.,,,,,,,,,"_cCombo")
				
				@ 140,055 	BUTTON "Visualiza"		SIZE 040,015 OF oDlg PIXEL ACTION(_lTela := .t.,oDlg:End())
				@ 140,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(_lTela := .f.,oDlg:End())
				
				ACTIVATE MSDIALOG oDlg CENTERED
				
				If _lTela
					DbSelectArea('_SE2')
					DbGoTo(_nNota)
					DbSelectArea('SE2')
					DbGoTo(_SE2->REGISTRO)
					MostraNotas()
				EndIf
				
			EndDo
			
		Else
			
			DbSelectArea('SE2')
			DbGoTo(_SE2->REGISTRO)
			MostraNotas()
			
		EndIf
		
		
	Else
		
		MostraNotas()
		
	EndIf
	
	
EndIf

If Select('_SE2') > 0
	DbSelectArea('_SE2')
	DbCloseArea()
EndIf

RestArea(_aAlias)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MostraNotas()
/////////////////////////////

If alltrim(SE2->E2_ORIGEM) == 'MATA460'
	
	DbSelectArea('SF2')
	SF2->(DbSetOrder(1))
	If SF2->(DbSeek(SE2->E2_FILORIG + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM,.F.))
		_cFilAnt := cFilAnt
		cFilAnt  := SE2->E2_FILORIG
		MC090Visual()
		cFilAnt := _cFilAnt
	Else
		MsgBox('Nota fiscal de saída não encontrada','ATENÇÃO!!!','ALERT')
	EndIf
	
ElseIf alltrim(SE2->E2_ORIGEM) $ 'MATA100/MATA103'
	
	DbSelectArea('SF1')
	SF1->(DbSetOrder(2))
	If SF1->(DbSeek(SE2->E2_FILORIG + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM,.F.))
		_cFilAnt := cFilAnt
		cFilAnt  := SE2->E2_FILORIG
		A103NFiscal('SF1',,2,.f.,.f.)       //	A103NFiscal('SF1',SF1->(RECNO()),2,.f.,.f.)
		cFilAnt := _cFilAnt
	Else
		MsgBox('Nota fiscal de entrada não encontrada','ATENÇÃO!!!','ALERT')
	EndIf
	
Else
	
	MsgBox('Titulo não foi originado através de nota fiscal','ATENÇÃO!!!','ALERT')
	
EndIf

Return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_FA430()
////////////////////////

Local lOk		:= .F.
Local aSays 	:= {}
Local aButtons := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de baixas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := "Retorno CNAB Pagar"
Private _lBaixou := .f.	// controla se baixou algum titulo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                 ³
//³                                                    ³
//³ Parametros                                         ³
//³                                                    ³
//³ MV_PAR01: Mostra Lanc. Contab  ? Sim Nao           ³
//³ MV_PAR02: Aglutina Lanc. Contab? Sim Nao           ³
//³ MV_PAR03: Arquivo de Entrada   ?                   ³
//³ MV_PAR04: Arquivo de Config    ?                   ³
//³ MV_PAR05: Banco                ?                   ³
//³ MV_PAR06: Agencia              ?                   ³
//³ MV_PAR07: Conta                ?                   ³
//³ MV_PAR08: SubConta             ?                   ³
//³ MV_PAR09: Contabiliza          ?                   ³
//³ MV_PAR10: Padrao Cnab          ? Modelo1 Modelo 2  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Pergunte("AFI430",.T.)
	
	If Empty(mv_par03)
		
		//MV_PAR03 := upper(alltrim(mv_par13) + alltrim(MV_PAR03))
		mv_par13 := alltrim(mv_par13)
		_aArqs := Directory(mv_par13 + '*.*')
		
		For _nI := 1 to len(_aArqs)
			If left(_aArqs[_nI,1],3) $ 'CCG/COB'
				
				_cOrigem := mv_par13 + _aArqs[_nI,1]
				_cDestino := mv_par13 + 'excluidos\' + _aArqs[_nI,1]
				copy file &_cOrigem to &_cDestino
				fErase(mv_par13+_aArqs[_nI,1])
				
			ElseIf left(_aArqs[_nI,1],3) $ 'FCP'
				
				nHdl := ft_fuse(mv_par13 + _aArqs[_nI,1])
				ft_fgotop()
				_cLinha  := ft_freadln()
				_cArq := substr(_cLinha,73,4) + '_' + alltrim(substr(_cLinha,148,4) + substr(_cLinha,146,2) + substr(_cLinha,144,2)) + '.RET'
				_lPvez := .T.
				Do While File(mv_par13 + _cArq)
					_nPosic := at('.',_cArq)
					If _lPvez
						_lPvez := .f.
						_cArq := left(_cArq,_nPosic-1) + 'A.RET'
					Else
						_cArq := left(_cArq,_nPosic-2) + Soma1(substr(_cArq,_nPosic-1,1)) +  '.RET'
					EndIf
				EndDo
				ft_fuse()
				fRename(upper(mv_par13 + _aArqs[_nI,1]), upper(mv_par13 + _cArq))
			EndIf
		Next
		
		dbSelectArea("SE2")
		dbSetOrder(1)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o log de processamento                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogIni( aButtons )
	
	aADD(aSays,	"Esta rotina permite receber o arquivo de retorno do CNAB de pagamentos, com base nas")
	aADD(aSays,	"ocorrências cadastradas e com os parametros configurados.")
	
	aADD(aButtons, { 5,.T.,{|| Pergunte("AFI430",.T. ) } } )
	aADD(aButtons, { 1,.T.,{|| lOk := .T.,FechaBatch()}} )
	aADD(aButtons, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons ,,,535)
	If empty(mv_par03)
		_aArqs := Directory(mv_par13 + '*.ret')
		aSort(_aArqs ,,, {|x,y| x[1] < y[1] } )
	Else
		_aArqs := Directory(mv_par13 + alltrim(mv_par03))
	EndIf
	
	If lOk
		_cFilAnt := cFilAnt
		_aFiliais := {}
		aAdd(_aFiliais,{'LASE','01'})
		aAdd(_aFiliais,{'GUAN','G0'})
		aAdd(_aFiliais,{'CLIO','C0'})
		aAdd(_aFiliais,{'REDE','R0'})
		aAdd(_aFiliais,{'AERO','A0'})
		aAdd(_aFiliais,{'BOMB','T0'})
		aAdd(_aFiliais,{'SING','FQ'})
		
		For _nI := 1 to len(_aArqs)
			Pergunte('AFI430',.F.)
			mv_par13 := alltrim(mv_par13)
			mv_par03 := alltrim(_aArqs[_nI,1])
			
			_nPosic := aScan(_aFiliais,{|x| Upper(AllTrim(x[1])) == left(mv_par03,4) })
			
			mv_par03 := mv_par13 + mv_par03
			cFilAnt := _aFiliais[_nPosic,2]
			
			nHdl := ft_fuse(mv_par13 + _aArqs[_nI,1])
			ft_fgotop()
			_cLinha  := ft_freadln()
			ft_fuse()
			
			MV_PAR05 := left(_cLinha,3)
			MV_PAR06 :=	padr(substr(_cLinha,54,4),5,' ')
			MV_PAR07 :=	padr(substr(_cLinha,65,7),10,' ')
			MV_PAR08 := '55'
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o log de processamento   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcLogAtu("INICIO")
			
			fa430gera("SE2")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o log de processamento   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcLogAtu("FIM")
			// relatorio de baixas
			
			_aPar := {}
			aAdd(_aPar,mv_par13 + _aArqs[_nI,1])	// arquivo de entrada
			aAdd(_aPar,mv_par04)					// arquivo de configuracao
			aAdd(_aPar,mv_par05)					// banco
			aAdd(_aPar,mv_par06)                    // agencia
			aAdd(_aPar,mv_par07)                    // conta
			aAdd(_aPar,mv_par08)                    // subconta
			aAdd(_aPar,2)                           // 1 - receber ou 2 - pagar
			aAdd(_aPar,2)                           // 1 - cnab 400 ou 2 - cnab 240
			
			_cDefs := 'C#G#' + mv_par13 + _aArqs[_nI,1] + _cEnter
			_cDefs += 'C#G#' + mv_par04 + _cEnter
			_cDefs += 'C#G#' + mv_par05 + _cEnter
			_cDefs += 'C#G#' + mv_par06 + _cEnter
			_cDefs += 'C#G#' + mv_par07 + _cEnter
			_cDefs += 'C#G#' + mv_par08 + _cEnter
			_cDefs += 'N#C#' + '2' + _cEnter
			_cDefs += 'N#C#' + '2' + _cEnter
			
			DbSelectArea('PROFALIAS')
			RecLock('PROFALIAS',!DbSeek(cUserName + 'FIN650',.f.))
			PROFALIAS->P_NAME := cUserName
			PROFALIAS->P_PROG := "FIN650"
			PROFALIAS->P_TASK := 'PERGUNTE'
			PROFALIAS->P_TYPE := 'MV_PAR'
			PROFALIAS->P_DEFS := _cDefs
			MsUnLock()
			
			U_FINR01(_aPar)
			
			_cDefs := 'C#G#' + mv_par03 + _cEnter	// banco
			_cDefs += 'C#G#' + mv_par04 + _cEnter	// agencia
			_cDefs += 'C#G#' + mv_par05 + _cEnter	// conta
			_cDefs += 'C#G#' + dtoc(stod(substr(_aArqs[_nI,1],6,8))) + _cEnter	// data de
			_cDefs += 'C#G#' + dtoc(stod(substr(_aArqs[_nI,1],6,8))) + _cEnter	// data ate
			_cDefs += 'N#C#' + '1' + _cEnter		// moeda
			_cDefs += 'N#C#' + '3' + _cEnter		// Demonstra Todos/Conciliados/Nao Conc.³
			_cDefs += 'N#G#' + '55' + _cEnter		// linhas por página
			
			DbSelectArea('PROFALIAS')
			RecLock('PROFALIAS',!DbSeek(cUserName + 'FIN470',.f.))
			PROFALIAS->P_NAME := cUserName
			PROFALIAS->P_PROG := 'FIN470'
			PROFALIAS->P_TASK := 'PERGUNTE'
			PROFALIAS->P_TYPE := 'MV_PAR'
			PROFALIAS->P_DEFS := _cDefs
			MsUnLock()
			
			FINR470()
			
			_cOrigem := mv_par13 + _aArqs[_nI,1]
			_cDestino := mv_par13 + 'baixados\' + _aArqs[_nI,1]
			If _lBaixou
				copy file &_cOrigem to &_cDestino
				fErase(mv_par13+_aArqs[_nI,1])
			Else
				MsgBox('Arquivo ' + _cOrigem + ' não baixou nenhum título. O arquivo não será excluido da pasta','ATENÇÃO','ALERT')
			EndIf
			
		Next
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(1)
	
EndIf


Return()


User Function FA430PA()

//_lBaixou := .t.

Return .T.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//			 Envia email para o responsável pela liberação dos títulos (financeiro) com cópia para o classficador (fiscal)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Email()
///////////////////////

Enter       := chr(13)
cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
_aUsuario  := U_fUser(1, .t., __cUserId)		// usuário que está liberando o pagamento
cEnvia := alltrim(_aUsuario[1,14])				// email
_cUsuario  := alltrim(_aUsuario[1,4])			// nome completo do usuário

cAssunto  	:= "Solicitação para liberação de pagamento"

_aSizes := {'10','10','10','10','10','10','10'}
_aAlign := {'','','','','','RIGHT','RIGHT'}
_aLabel := {'Filial','Prefixo','Título','Tipo','Emissão','Valor','Saldo'}

_cHtml	 	:= ""

_cHtml += '<html>'
_cHtml += '<head>'
_cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana">' + cAssunto + '</h3></font>'
_cHtml += '</head>'
_cHtml += '<body bgcolor = white text=black  >'
_cHtml += '<hr width=100% noshade>' + _cEnter

_cTexto := "Conforme avisado na inclusão/classificação da nota fiscal de entrada número " + SE2->E2_NUM + " do fornecedor "
_cTexto += alltrim(Posicione('SA2',1,xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,'A2_NOME'))
_cTexto += " possui Títulos de PA's e/ou NDF's em aberto para o qual foi feita uma solicitação de liberação para pagamento deste título." + _cEnter + _cEnter
_cTexto += " O título foi liberado para pagamento" + _cEnter + _cEnter

_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> ' + _cTexto+ '</font></b>'+ _cEnter+_cEnter

_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'

_cHtml += '</P>'

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
If lConectou
	
	SEND MAIL FROM cEnvia TO alltrim(SE2->E2_NUMTIT) SUBJECT cAssunto BODY _cHtml RESULT lEnviado
	
	If !lEnviado
		cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
		GET MAIL ERROR cHtml
		Conout( "ERRO SMTP EM: " + cAssunto )
	Else
		DISCONNECT SMTP SERVER
		Conout( cAssunto )
	Endif
	
Else
	
	Conout( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
	MsgAlert(cHtml)
Endif

Return


Return(.t.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// mbrowse para a manutencao de borderôs -
// Alexandre Dalpiaz
// 03/11/10
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _Fin590(_cAlias)
////////////////////////////////

Local aCores := {}   
U_LS_MATRIZ()

If _cAlias == 'SE1'
	aAdd(aCores, {'Empty(E1_PORTADO) .AND. E1_SALDO>0'  , 'ENABLE' })
	aAdd(aCores, {'!Empty(E1_PORTADO).and. E1_SALDO>0 .and. E1_NUMBOR != cNumBor' , 'DISABLE'})
	aAdd(aCores, {'!Empty(E1_PORTADO).and. E1_SALDO>0 .and. E1_NUMBOR == cNumBor' , 'BR_AMARELO'})
	aAdd(aCores, {'E1_SALDO=0' , 'BR_AZUL'})
Else
	aAdd(aCores, {'Empty(E2_NUMBOR) .AND. E2_SALDO>0'  , 'ENABLE' })
	aAdd(aCores, {'!Empty(E2_NUMBOR).and. E2_SALDO>0 .and. E2_NUMBOR != cNumBor' , 'DISABLE'})
	aAdd(aCores, {'!Empty(E2_NUMBOR).and. E2_SALDO>0 .and. E2_NUMBOR == cNumBor' , 'BR_AMARELO'})
	aAdd(aCores, {'E2_SALDO=0' , 'BR_AZUL'})
EndIf

PRIVATE cCadastro := 'Manutenção de Borderôs'

aRotina := {}
aAdd(aRotina, {"Pesquisar", "AxPesqui"  , 0 , 1,,.F.})
aAdd(aRotina, {"Visualizar", "AxVisual"  , 0 , 2})
aAdd(aRotina, {"Incluir", "FA590Inclu", 0 , 3})
aAdd(aRotina, {"Cancelar", "FA590Canc" , 0 , 4})
aAdd(aRotina, {"Legenda", "FA590Legen", 0 , 4, ,.F.})

SetKey (VK_F12,{|a,b| AcessaPerg("FIN590",.T.)})

pergunte("FIN590",.F.)

DbSelectArea(_cAlias)
DbSetOrder(iif(_cAlias == 'SE1',5,14))
DbSeek(xFilial(_cAlias) + cNumBor,.f.)
DbSetOrder(1)
mBrowse( 6, 1,22,75,_cAlias,,,,,,aCores)

dbSelectArea(_cAlias)
dbSetOrder(1)

Return

                 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function UltiLote()
////////////////////////
cLoteFin := Soma1(GetMv('LS_ULTLOTE'))

Return()                    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FA070BXL()
////////////////////////
PutMv('LS_ULTLOTE',cLoteFin)

Return()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F070OWN()
///////////////////////
Local _cFiltro, _cCliente := '      '

DEFINE MSDIALOG oDlg FROM  094,1 TO 200,293 TITLE 'Baixas por Lote' PIXEL
@ 10,20 SAY 'Cliente:'	   SIZE 023,07 OF oDlg pixel
@ 10,60 MSGET _cCliente    SIZE 050,10 OF oDlg PIXEL Valid empty(_cCliente) .or. ExistCpo('SA1',_cCliente) F3 'SA1'

DEFINE SBUTTON FROM 35,085 TYPE 1 ENABLE OF oDlg ACTION (nOpca := 1, oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

_cFiltro := 'E1_FILIAL=="' + xFilial("SE1") + '".And.'
_cFiltro += 'DTOS(E1_VENCREA)>="' + DTOS(dVencDe)  + '".And.'
_cFiltro += 'DTOS(E1_VENCREA)<="' + DTOS(dVencAte) + '".And.'
_cFiltro += 'E1_NATUREZ>="'       + cNatDe         + '".And.'
_cFiltro += 'E1_NATUREZ<="'       + cNatAte        + '".And.'
_cFiltro += '(E1_PORTADO="'       + cBancolt         + '".OR.'
_cFiltro += 'E1_PORTADO=="'+ space(Len(E1_PORTADO)) + '").AND.'
_cFiltro += '!(E1_TIPO$"'+MVPROVIS+"/"+MVRECANT+"/"+MVIRABT+"/"+MVINABT+"/"+MV_CRNEG

//Destacar Abatimentos
If mv_par06 == 2
	_cFiltro += "/"+MVABATIM+'")'
Else
	_cFiltro += '")'
Endif

// Verifica integracao com TMS e nao permite baixar titulos que tenham solicitacoes
// de transferencias em aberto.
_cFiltro += ' .And. Empty(E1_NUMSOL)'
_cFiltro += ' .And. (E1_SALDO>0 .OR. E1_OK="xx")
If !empty(_cCliente)
	_cFiltro += ' .And. E1_CLIENTE = "' + _cCliente + '"'
EndIf

Return(_cFiltro)	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_CodBar
///////////////////////

_cCodBar  := space(44)
_cDigita  := space(47)
_lDigita  := _lCodBar := .t.
_cTitulo  := space(18)             
_cFornece := space(50)
_dVencto  := _dVencRea := ctod('')
_nValor   := _nSaldo   := 0

DEFINE MSDIALOG oDlg FROM  000,000 TO 350,500 TITLE 'Leitura de código de barras' PIXEL

@ 005,007 TO 040, 250 OF oDlg  PIXEL
@ 010,015 say 'Código de Barras'	SIZE 200,07 OF oDlg PIXEL
@ 025,015 say 'Linha digitável' 	SIZE 200,07 OF oDlg PIXEL
@ 010,070 MsGet _oCodBar Var _cCodBar pict '@9'										        	 	   SIZE 160,10 OF oDlg PIXEL when _lCodBar Valid VL_CodBar(_cCodBar)
@ 025,070 MsGet _oDigita Var _cDigita pict '@R 99999.99999 99999.999999 99999.999999 9 99999999999999' SIZE 160,10 OF oDlg PIXEL when _lDigita Valid VL_CodBar(U_Z14GAT01(_cDigita))

@ 045,007 TO 115, 250 OF oDlg  PIXEL
@ 050,015 say 'Título'					SIZE 200,07 OF oDlg PIXEL
@ 050,070 MsGet _oTitulo  var _cTitulo 	SIZE 070,10 OF oDlg PIXEL when .f.				pict '@R !!! / !!!!!!!!! - !!! (!!!)'
@ 065,015 say 'Fornecedor'				SIZE 200,07 OF oDlg PIXEL
@ 065,070 MsGet _oFornece var _cFornece SIZE 100,10 OF oDlg PIXEL when .f.			    pict '@R !!!!!!-!! - !!!!!!!!!!!!!!!!!!!!'
@ 080,015 Say 'Vencimento'				SIZE 100,07 OF oDlg PIXEL
@ 080,130 say 'Vencimento real'			SIZE 100,07 OF oDlg PIXEL
@ 080,070 MsGet _oVencto  var _dVencto  SIZE 050,10 OF oDlg PIXEL when !empty(_cTitulo)
@ 080,180 MsGet _oVencRea var _dVencRea SIZE 050,10 OF oDlg PIXEL when !empty(_cTitulo)
@ 095,015 Say 'Valor'     				SIZE 050,07 OF oDlg PIXEL
@ 095,130 say 'Saldo'          			SIZE 050,07 OF oDlg PIXEL
@ 095,070 MsGet _oValor   var _nValor   SIZE 050,10 OF oDlg PIXEL when !empty(_cTitulo) pict '@E 999,999,999.99'
@ 095,180 MsGet _oSaldo   var _nSaldo   SIZE 050,10 OF oDlg PIXEL when !empty(_cTitulo) pict '@E 999,999,999.99'

DEFINE SBUTTON FROM 150,085 TYPE 1 ENABLE OF oDlg ACTION (nOpca := 1,GravaCB())
DEFINE SBUTTON FROM 150,115 TYPE 2 ENABLE OF oDlg ACTION (nOpca := 0, oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Vl_CodBar(_xCodBar)
///////////////////////////////////
Local _lRet := .t.
Local _nLastRec := 0
Local _aTitulos := {}
Local _aCombo := {}

If empty(_xCodBar)
	Return(.t.)
EndIf

_cQuery := "SELECT R_E_C_N_O_, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_VALOR, E2_SALDO, E2_VENCTO, E2_VENCREA"
_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
_cQuery += _cEnter + " WHERE SE2.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND E2_VALOR = " + alltrim(str(val(subs(_xCodBar,10,10))/100,10,2))
_cQuery += _cEnter + " AND E2_VENCTO = '" + dtos(ctod('07/10/1997') + val(subs(_xCodBar,6,4))) + "'"
_cQuery += _cEnter + " AND E2_SALDO > 0"
_cQuery += _cEnter + " AND E2_MATRIZ = '" + cFilAnt + "'"

_cQuery := "SELECT R_E_C_N_O_, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_VALOR, E2_SALDO, E2_VENCTO, E2_VENCREA  FROM SE2010 SE2 (NOLOCK)  WHERE SE2.D_E_L_E_T_ = ''  AND E2_VALOR = 250.00  AND E2_SALDO > 0  AND E2_MATRIZ = '01'"

MsAguarde( {|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SE2CB', .F., .F.)},"Procurando Títulos")

Do While !eof()
	aAdd(_aTitulos,{SE2CB->R_E_C_N_O_, SE2CB->E2_PREFIXO, SE2CB->E2_NUM, SE2CB->E2_PARCELA, SE2CB->E2_TIPO, SE2CB->E2_FORNECE, SE2CB->E2_LOJA, SE2CB->E2_NOMFOR, SE2CB->E2_VALOR, SE2CB->E2_SALDO, stod(SE2CB->E2_VENCTO), stod(SE2CB->E2_VENCREA)})
	_cTitulo := 'Tit: ' + SE2CB->E2_PREFIXO + '/' + SE2CB->E2_NUM + '-' + SE2CB->E2_PARCELA + '(' + SE2CB->E2_TIPO + ') Forn: '
	_cTitulo += SE2CB->E2_FORNECE + '/' + SE2CB->E2_LOJA + ' - ' + SE2CB->E2_NOMFOR
	_cTitulo += '  Vlr: ' + tran(SE2CB->E2_VALOR,'@E 999,999.99') + '  Sld: ' + tran(SE2CB->E2_SALDO,'@E 999,999.99')
	_cTitulo += '  Vencto: ' + dtoc(stod(SE2CB->E2_VENCTO)) + ' Venc Real: ' + dtoc(stod(SE2CB->E2_VENCREA)) 
	aAdd(_aCombo,_cTitulo)
	++_nLastRec
	DbSkip()
EndDo

DbCloseArea()

_nI := 1
If empty(_aTitulos)

	MsgBox('Nenhum título encontrado','ATENÇÃO!!!','INFO')
	Return(.t.)

ElseIf len(_aTitulos) > 1
	
	_lTela := .t.
	_cCombo := _aCombo[1]
	_lTela := .f.                                       
	
	_oFonte := TFont():New("Courier New",10,18,,.T.,,,,,)
	DEFINE MSDIALOG _oDlgCB FROM 000,000 TO 400,800 TITLE "Leitura de códigos de barras" PIXEL

	_oDlgCB:SetFont(_oFonte)
	_oCombo:= TComboBox():New(010,005,{|u|iif(PCount()>0,_cCombo:=u,_cCombo)},_aCombo,365,20,_oDlgCB,,{|| _nI := aScan(_aCombo,_cCombo) },,,,.T.,,,,,,,,,"_cCombo")
	
	@ 140,055 	BUTTON "Selecionar"		SIZE 040,015 OF _oDlgCB PIXEL ACTION(_lTela := .t.,_oDlgCB:End())
	@ 140,110 	BUTTON "Fechar"  		SIZE 040,015 OF _oDlgCB PIXEL ACTION(_lTela := .f.,_oDlgCB:End())
	
	ACTIVATE MSDIALOG _oDlgCB CENTERED
	
	If _lTela
		_nI := aScan(_aCombo,_cCombo)
	Else
		Return(.t.)
	EndIf
EndIf

DbSelectArea('SE2')
DbGoTo(_aTitulos[_nI,1] )

_cTitulo  := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO
_cFornece := SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NOMFOR
_nValor   := SE2->E2_VALOR
_nSaldo   := SE2->E2_SALDO
_dVencto  := SE2->E2_VENCTO
_dVencRea := SE2->E2_VENCREA

oDlg:Refresh()

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaCB()
/////////////////////////

RecLock('SE2',.f.)
SE2->E2_CODBAR  := _cCodBar
SE2->E2_VALOR   := _nValor
SE2->E2_SALDO   := _nSaldo
SE2->E2_VLCRUZ  := _nValor
SE2->E2_VENCTO  := _dVencto
SE2->E2_VENCREA := _dVencRea
MsUnLock()

_cCodBar  := space(44)
_cDigita  := space(47)
_lDigita  := _lCodBar := .t.
_cTitulo  := space(18)             
_cFornece := space(50)
_dVencto  := _dVencRea := ctod('')
_nValor   := _nSaldo   := 0

oDlg:Refresh()

Return()
                         
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_MATRIZ()
/////////////////////////

cFilAnt := iif(cFilAnt >= '01' .and. cFilAnt <= '99','01', cFilAnt)
cFilAnt := iif(cFilAnt >= 'A0' .and. cFilAnt <= 'AZ','A0', cFilAnt) 
cFilAnt := iif(cFilAnt >= 'BH' .and. cFilAnt <= 'BI','BH', cFilAnt) 

cFilAnt := iif(cFilAnt >= 'C0' .and. cFilAnt <= 'EZ','C0', cFilAnt)
cFilAnt := iif(cFilAnt >= 'G0' .and. cFilAnt <= 'GZ','G0', cFilAnt)
cFilAnt := iif(cFilAnt >= 'R0' .and. cFilAnt <= 'RZ','R0', cFilAnt)
cFilAnt := iif(cFilAnt >= 'T0' .and. cFilAnt <= 'TZ','T0', cFilAnt)
cFilAnt := iif(cFilAnt >= 'V0' .and. cFilAnt <= 'VZ','V0', cFilAnt) 
cFilAnt := iif(cFilAnt == 'K0','K0', cFilAnt) 
cFilAnt := iif(cFilAnt >= 'K5' .and. cFilAnt <= 'KA','K0', cFilAnt)
//cFilAnt := iif(cFilAnt >= 'K0' .and. cFilAnt <= 'KA','K0', cFilAnt) 
//cFilAnt := iif(cFilAnt = 'K0','K0', cFilAnt) 
cFilAnt := iif(cFilAnt = 'K1','K1', cFilAnt) 
cFilAnt := iif(cFilAnt = 'K2','K2', cFilAnt) 
cFilAnt := iif(cFilAnt = 'K3','K3', cFilAnt) 
cFilAnt := iif(cFilAnt = 'K4','K4', cFilAnt) 
cFilAnt := iif(cFilAnt = 'K2','K2', cFilAnt) 
cNumEmp := cEmpAnt + cFilAnt


Return()