#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*
+===================+======================+==================+
|Programa: ESTP019  |Autor: Antonio Carlos |Data: 04/08/11    |
+===================+======================+==================+
|Descricao: Rotina responsavel pela geração/baixas das Ordens |
|de Produção referente produtos de Conveniência.              |
+=============================================================+
|Uso: Especifico Laselva                                      |
+=============================================================+
*/
// ALTERADO POR THIAGO QUEIROZ - 04/12/13
// ALTERADO TABELA PA2 PELA TABELA SL2

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ESTP019(aParam)
/////////////////////////////

//Local aparam		:= {"01","01"}
Local cCadastro    	:= "Inclui/Processa - Ordens de Producao"
Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local cArqLock 		:= "ESTP019.lck"

_cEnter 			:= chr(13) + chr(10)
Private oDlg
Private _lJob		:= (aParam <> Nil .Or. ValType(aParam) == "A") //.t.
Private _nCont		:= 0
aParam 				:= {'01','01'}

If _lJob
	fErase(cArqLock)
	If File(cArqLock)
		Return()
	EndIf
	AtuDados(cArqLock)
	If aParam == Nil .Or. ValType(aParam) <> "A"
		// Conout("ESTP001 - Parametros nao recebidos => Empresa e Filial")
		Return
	Else
		// Conout("ESTP001 - Parametros recebidos => Empresa "+aParam[1]+" Filial "+aParam[2])
		AtuDados()
	EndIf
Else
	
	@ 100,150 TO 300,600 DIALOG oDlg TITLE cCadastro
	@ 005,005 TO 080,220
	
	@ 015,015 SAY "Este programa tem como objetivo gerar as Orderns de Producao/Baixas    " COLOR CLR_HBLUE
	@ 025,015 SAY "referente produtos do grupo de Conveniencia.                           " COLOR CLR_HBLUE
	
	@ 085,150 BMPBUTTON TYPE 1 ACTION (Close( oDlg ),Processa( {|lEnd| AtuDados(@lEnd) }, "Processando...","Ordem de Producao", .T. ))
	@ 085,180 BMPBUTTON TYPE 2 ACTION Close( oDlg )
	ACTIVATE DIALOG oDlg CENTERED
EndIf

If !_lJob
	If _nCont > 0
		MsgInfo("Processamento efetuado com sucesso!")
	Else
		MsgStop("Nao existem registros para processamento! (02)")
	EndIf
EndIf

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuDados(cArqLock)
//////////////////////////

Local aparam   := {"01","01"}
Local nHdlLock := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua o Lock de gravacao da Rotina - Monousuario            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF TYPE("cArqLock") == "C"
	FErase(cArqLock)
	If file(cArqLock)
		// Conout("ESTP001 - Rotina "+FunName(0)+" ja em execução.")
		Return(.T.)
	EndIf
	nHdlLock := MsFCreate(cArqLock)
ENDIF

If _lJob
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa ambiente.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcSetType(3)
	If FunName() <> 'LSVIMPSL'
		IF FindFunction('WFPREPENV')
			WfPrepEnv( aParam[1], aParam[2])
		Else
			Prepare Environment Empresa aParam[1] Filial aParam[2]
		EndIF
		ChkFile("SM0")
	EndIf
else
	cFilAnt := '01'
EndIf

_cFil := cFilAnt

If _lJob
	// Conout("ESTP001 - Iniciando ESTP019")
EndIf

cQry := " SELECT L2_FILIAL, COUNT(*) QUANT "
cQry += _cEnter + " FROM " + RetSqlname("SL2") + " SL2(NOLOCK) "
cQry += _cEnter + " INNER JOIN " + RetSqlName("SG1") + " SG1 (NOLOCK) "
cQry += _cEnter + " ON SG1.D_E_L_E_T_ 	= '' 			AND G1_FILIAL 	= '' AND G1_COD 		= L2_PRODUTO "
cQry += _cEnter + " WHERE L2_EMISSAO 	>= '20131201' 	AND L2_OP 		= '' AND SL2.D_E_L_E_T_ = '' "
cQry += _cEnter + " GROUP BY L2_FILIAL
cQry += _cEnter + " HAVING COUNT(*) 	> 0 "
cQry += _cEnter + " ORDER BY L2_FILIAL "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'TMP', .F., .T.)

Do While !Eof()
	
	cFilAnt := TMP->L2_FILIAL
	cline   := 'Filial: ' + cFilAnt + _cEnter
	
	IF EMPTY(ALLTRIM(TMP->L2_FILIAL))
		DbSelectArea('TMP')
		dbSkip()
		loop
	ENDIF
	
	GeraProd()
	DbSelectArea('TMP')
	DbSkip()
	
EndDo

cFilAnt := _cFil

DbSelectArea('TMP')
DbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha filial corrente.	   							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lJob .and. FunName() <> 'LSVIMPSL'
	Reset Environment
	// Conout("ESTP019 - Finalizando ESTP019")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cancela o Lock de gravacao da rotina                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF TYPE("cArqLock") == "C"
	FClose(nHdlLock)
	FErase(cArqLock)
ENDIF

Return(.T.)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraProd()
//////////////////////////

Local _nQtd		:= 0
Local nTotRec   := 0
Local _lProc	:= .T.
Local _aRegs	:= {}

cQry1 := " SELECT L2_FILIAL, L2_EMISSAO, L2_PRODUTO, L2_QUANT AS VENDA, L2_NUMCFIS, L2_PDV, L2_ITEM "
cQry1 += _cEnter + " FROM "+RetSqlName("SL2")+" SL2 (NOLOCK) "
cQry1 += _cEnter + " INNER JOIN "+RetSqlName("SG1")+" SG1 (NOLOCK) "
cQry1 += _cEnter + " ON G1_FILIAL = '' AND G1_COD = L2_PRODUTO AND SG1.D_E_L_E_T_ = '' "
cQry1 += _cEnter + " WHERE L2_FILIAL = '"+xFilial("SL2")+"' AND L2_EMISSAO >= '20131201' AND L2_OP = '' AND SL2.D_E_L_E_T_ = '' "
cQry1 += _cEnter + " GROUP BY L2_FILIAL, L2_EMISSAO, L2_PRODUTO, L2_QUANT, L2_NUMCFIS, L2_PDV, L2_ITEM "
cQry1 += _cEnter + " ORDER BY L2_FILIAL, L2_EMISSAO, L2_PRODUTO, L2_NUMCFIS "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry1), 'TMP_PROD', .F., .T.)

Do While !Eof()
	
	_cFilia			:= TMP_PROD->L2_FILIAL
	_dEmiss			:= TMP_PROD->L2_EMISSAO
	_cProd			:= TMP_PROD->L2_PRODUTO
	_cCupons		:= ''
	
	IF EMPTY(ALLTRIM(_cProd))
		DbSelectArea('TMP_PROD')
		dbSkip()
		loop
	ENDIF
	
	Do While !Eof() .And. _cFilia == TMP_PROD->L2_FILIAL .And. _dEmiss == TMP_PROD->L2_EMISSAO .And. _cProd == TMP_PROD->L2_PRODUTO
		
		_nQtd 		+= TMP_PROD->VENDA
		Aadd( _aRegs, {TMP_PROD->L2_FILIAL+TMP_PROD->L2_EMISSAO+TMP_PROD->L2_PDV+TMP_PROD->L2_NUMCFIS+TMP_PROD->L2_PRODUTO+TMP_PROD->L2_ITEM} )
		_cCupons	+= TMP_PROD->L2_NUMCFIS + ' - '
		DbSelectArea('TMP_PROD')
		
		DbSkip()
		
	EndDo
	
	cFilAnt 		:= _cFilia
	_lProc 			:= IncProd(_cProd,_nQtd,STOD(_dEmiss),_cCupons)
	
	For _nI := 1 To Len(_aRegs)
		
		DbSelectArea("SL2")
		//DbSetOrder(9)
		DbOrderNickName('ESTP019')
		If DbSeek( _aRegs[_nI,1] )
			RecLock("SL2",.F.)
			SL2->L2_OP := If(_lProc==.T.,"S","E")
			SL2->( MsUnLock() )
		EndIf
		
	Next _nI
	
	_nQtd 	:= 0
	_aRegs	:= {}
	
	DbSelectArea('TMP')
	
EndDo

DbSelectArea('TMP_PROD')
DbCloseArea()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function IncProd(_cProd,_nQuant,_dData,_cCupons)
///////////////////////////////////////////////////////

Local aArea		:= GetArea()
Local _aVetSC2	:= {}
Local _aVetSD3	:= {}
Local _lProces	:= .T.
lMsErroAuto		:= .F.

_cNumSC2 := GetSxeNum("SC2","C2_NUM")
DbSelectArea('SC2')
DbSetOrder(1)
Do While .T.
	
	If SC2->(DbSeek(xFilial("SC2")+_cNumSC2))
		ConfirmSx8()
		_cNumSC2:= GetSxeNum("SC2","C2_NUM")
		Loop
		
	Else
		Exit
	EndIF
	
EndDo

_cTemp 	:= CriaTrab(,.f.)
_cQuery := "SELECT B1_COD PRODUTO"
_cQuery += _cEnter + " INTO " + _cTemp
_cQuery += _cEnter + " FROM " + RetSqlName('SG1') + " SG1 (NOLOCK)"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + " ON (B1_COD 			= G1_COMP OR B1_COD = '" + _cProd +"')"
_cQuery += _cEnter + " AND B1_MSBLQL 		= '1'"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + " WHERE G1_COD 		= '" + _cProd + "'"
_cQuery += _cEnter + " AND SG1.D_E_L_E_T_ 	= ''"
nValidExec := TcSqlExec(_cQuery)

_cQuery := "UPDATE SB1"
_cQuery += _cEnter + " SET B1_MSBLQL = '2'"
_cQuery += _cEnter + " FROM " + _cTemp
_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + " ON B1_COD 			= PRODUTO"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ 	= ''"
nValidExec := TcSqlExec(_cQuery)

//Inclusão da Ordem de Produção
dDataBase := _dData
_aVetSC2 :={{"C2_NUM"		,_cNumSC2	,NIL},;
			{"C2_ITEM"		,"01"		,NIL},;
			{"C2_SEQUEN"	,"001"		,NIL},;
			{"C2_PRODUTO"	,_cProd		,NIL},;
			{"C2_LOCAL"		,"01"		,NIL},;
			{"C2_QUANT"		,_nQuant	,NIL},;
			{"C2_UM"		,GetAdvFVal("SB1","B1_UM",xFilial("SB1")+_cProd,1),NIL},;
			{"C2_DATPRI"	,_dData		,NIL},;
			{"AUTEXPLODE"	,"S"		,NIL},;
			{"C2_MOPC"   	,_cCupons	,NIL},;
			{"C2_TPOP"   	,"F"		,NIL},;
			{"C2_DATPRF"	,dDataBase	,NIL}}

Begin Transaction

MSExecAuto({|x,y| Mata650(x,y)},_aVetSC2,3)

If lMsErroAuto
	_lProces := .F.
	/*
	If !_lJob
		cErrorMSG := MostraErro()
	EndIf
	*/
	cErrorMSG := MostraErro()
	conout("********** ESTP019 - ERRO AO GRAVAR OP - "+cErrorMSG)
	RollBackSx8()
	
Else
	
	lMsErroAuto	:= .F.
	_cOpera     := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	_cDoc	    := Substr(_cOpera,1,9)
	
	_aVetSD3 	:= {{"D3_TM"		,"301"         		,NIL},;
					{"D3_COD"		,SC2->C2_PRODUTO	,NIL},;
					{"D3_UM"		,SB1->B1_UM			,NIL},;
					{"D3_QUANT"		,SC2->C2_QUANT		,NIL},;
					{"D3_OP"		,_cOpera			,NIL},;
					{"D3_LOCAL"		,SB1->B1_LOCPAD		,NIL},;
					{"D3_DOC"		,_cDoc				,NIL},;
					{"D3_EMISSAO"	,_dData				,NIL},;
					{"D3_PARCTOT"	,"T"				,NIL}}
	
	MSExecAuto({|x,y| MATA250(x,y)},_aVetSD3,3)
	
	If lMsErroAuto
		_lProces := .F.
		If !_lJob
			MostraErro()
		Else
			// Conout("ESTP001 - Ocorreu algum problema no processamento 02!")
			cErrorMSG := MostraErro('c:\spool\','OP.LOG')
			conout("********** ESTP019 - ERRO AO GRAVAR MOV.INTERNO - "+cErrorMSG)
			FT_FUSE('C:\spool\op.log')
			FT_FGotop()
			Do While ( !FT_FEof() )
				cline := alltrim(FT_FREADLN())
				fWrite(nHdlLog,cLine,Len(cLine))
				FT_FSkip()
			EndDo
			FT_FUSE()
			
		EndIf
		RollBackSx8()
		DisarmTransaction()
	Else
		_nCont++
	EndIf
EndIf

End Transaction
If !lMsErroAuto
	ConfirmSX8()
EndIf

_cQuery := "UPDATE SB1"
_cQuery += _cEnter + " SET B1_MSBLQL = '1'"
_cQuery += _cEnter + " FROM " + _cTemp
_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + " ON B1_COD 			= PRODUTO"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_	= ''"
nValidExec := TcSqlExec(_cQuery)

nValidExec := TcSqlExec("DROP TABLE " + _cTemp)

RestArea(aArea)

Return(_lProces)

//////////////////////////////////////////////////////////////////
// EXECUTA A FUNÇÃO VIA JOB                                     //
//////////////////////////////////////////////////////////////////
User Function LSBXEST()

U_ESTP019({"01","01"})

RETURN