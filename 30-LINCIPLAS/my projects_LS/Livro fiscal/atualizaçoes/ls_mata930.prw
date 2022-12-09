#Include "topconn.CH"
#Include "rwmake.CH"
#Include "protheus.CH"

#define __FILIAL	1
#define __F2EMISSAO	2
#define __DOC		3
#define __SERIE		4
#define __CLIENTE	5
#define __LOJA		6
#define __PDV		7
#define __MAPA		8
#define __CF		9
#define __EST		10
#define __D2EMISSAO 11
#define __PaLivrDoc 64

STATIC lLegislacao := LjAnalisaLeg(43)[1] .AND. cPaisLoc == "BRA" .AND. AliasInDic("MDL")


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User FUNCTION LS_MATA930()
//////////////////////////

If Pergunte("MTA930",.t.)       

	If !MsgBox('Confirma reprocessamento?','ATENÇÃO!!!','YESNO')	
		Return()
	EndIf

	If !MsgBox('Todos os livros referentes aos parâmetros informados serão apagados.' + Chr(13) + Chr(10) + 'Caso o reprocessamento não seja efetuado, os livros não serão reprocessados e os dados serão perdidos!!!' + Chr(13) + Chr(10) + 'Confirma reprocessamento?','ATENÇÃO!!!','YESNO')	
	//If !MsgBox('Todos os livros referentes aos parâmetros informados serão apagados.' + _cEnter + 'Caso o reprocessamento não seja efetuado, os livros não serão reprocessados e os dados serão perdidos!!!' + _cEnter + 'Confirma reprocessamento?','ATENÇÃO!!!','YESNO')	
		Return()
	EndIf
	
	_lCommit := .f.
	
	_cQuery := "SELECT 'DELETE FROM " + RetSqlName('SFT') + " WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,SFT.R_E_C_N_O_) CAMPO"
   //	_cQuery += _cEnter + " FROM " + RetSqlName('SFT') + " SFT (NOLOCK)"       
	_cQuery += Chr(13) + Chr(10) + " FROM " + RetSqlName('SFT') + " SFT (NOLOCK)"     
	
	_cQuery += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName('SF3') + " SF3 (NOLOCK)"       
	_cQuery += Chr(13) + Chr(10) + " 									ON F3_FILIAL 	= FT_FILIAL"
	_cQuery += Chr(13) + Chr(10) + " 									AND F3_NFISCAL 	= FT_NFISCAL"
	_cQuery += Chr(13) + Chr(10) + " 									AND F3_SERIE 	= FT_SERIE"
	_cQuery += Chr(13) + Chr(10) + " 									AND F3_CLIEFOR 	= FT_CLIEFOR"
	_cQuery += Chr(13) + Chr(10) + " 									AND F3_LOJA 	= FT_LOJA"

	_cQuery += Chr(13) + Chr(10) + " WHERE FT_FILIAL 	BETWEEN 	'" 	+ mv_par12 		 + "' AND '" + mv_par13 + "'"
	_cQuery += Chr(13) + Chr(10) + " AND FT_ENTRADA 	BETWEEN 	'" 	+ dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
	_cQuery += Chr(13) + Chr(10) + " AND FT_NFISCAL 	BETWEEN 	'" 	+ mv_par04 		 + "' AND '" + mv_par05 + "'"
	_cQuery += Chr(13) + Chr(10) + " AND FT_SERIE 		BETWEEN 	'" 	+ mv_par06 		 + "' AND '" + mv_par07 + "'"
	_cQuery += Chr(13) + Chr(10) + " AND FT_CLIEFOR 	BETWEEN 	'" 	+ mv_par08 		 + "' AND '" + mv_par09 + "'"
	_cQuery += Chr(13) + Chr(10) + " AND FT_LOJA 		BETWEEN 	'" 	+ mv_par10 		 + "' AND '" + mv_par11 + "'"
	//_cQuery += Chr(13) + Chr(10) + " AND FT_OBSERV 	<> 'NF CANCELADA'"
	If mv_par03 == 1
		_cQuery += Chr(13) + Chr(10) + " AND FT_CFOP < '5'"
	ElseIf mv_par03 == 2
		_cQuery += Chr(13) + Chr(10) + " AND FT_CFOP > '5'"
	EndIf
	_cQuery += Chr(13) + Chr(10) + " AND COALESCE(F3_REPROC,'') IN ('','S')"

	MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'DELSFT', .F., .T.)},'Selecionando registros para exclusão (SFT)')
	
	Processa({|| ExcluiLivros()})
	
	_cQuery := "SELECT 'DELETE FROM " + RetSqlName('SF3') + " WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,R_E_C_N_O_) CAMPO"
	_cQuery += Chr(13) + Chr(10) + " FROM " + RetSqlName('SF3') + " (NOLOCK)"
	_cQuery += Chr(13) + Chr(10) + " WHERE F3_FILIAL 	BETWEEN '" 	+ mv_par12 		 + "' AND '" + mv_par13 + "'"
	_cQuery += Chr(13) + Chr(10) + " AND F3_ENTRADA 	BETWEEN '" 	+ dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
	_cQuery += Chr(13) + Chr(10) + " AND F3_NFISCAL 	BETWEEN '" 	+ mv_par04 		 + "' AND '" + mv_par05 + "'"
	_cQuery += Chr(13) + Chr(10) + " AND F3_SERIE 		BETWEEN '" 	+ mv_par06 		 + "' AND '" + mv_par07 + "'"
	_cQuery += Chr(13) + Chr(10) + " AND F3_CLIEFOR 	BETWEEN '" 	+ mv_par08 		 + "' AND '" + mv_par09 + "'"
	_cQuery += Chr(13) + Chr(10) + " AND F3_LOJA 		BETWEEN '" 	+ mv_par10 		 + "' AND '" + mv_par11 + "'"
	//_cQuery += Chr(13) + Chr(10) + " AND F3_OBSERV 	<> 'NF CANCELADA'"
	_cQuery += Chr(13) + Chr(10) + " AND F3_REPROC 	<> 'N'"

	If mv_par03 == 1
 		_cQuery += Chr(13) + Chr(10) + " AND F3_CFO < '5'"
	ElseIf mv_par03 == 2
		_cQuery += Chr(13) + Chr(10) + " AND F3_CFO > '5'"
	EndIf

	MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'DELSF3', .F., .T.)},'Selecionando registros para exclusão (SF3)')
	
	Processa({|| ExcluiLivros()})
	                
	_cQuery := "SELECT SUM(QUANT) QUANT "
	_cQuery += Chr(13) + Chr(10) + " FROM ("
	If mv_par03 <> 1
		_cQuery += Chr(13) + Chr(10) + " SELECT COUNT(*) QUANT "
		_cQuery += Chr(13) + Chr(10) + " FROM " + RetSqlName('SF2') + " (NOLOCK)"
		_cQuery += Chr(13) + Chr(10) + " WHERE F2_FILIAL 	BETWEEN '" 	+ mv_par12 		 + "' AND '" + mv_par13 + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F2_EMISSAO 	BETWEEN '" 	+ dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F2_DOC 		BETWEEN '" 	+ mv_par04 		 + "' AND '" + mv_par05 + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F2_SERIE 		BETWEEN '" 	+ mv_par06 		 + "' AND '" + mv_par07 + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F2_CLIENTE 	BETWEEN '" 	+ mv_par08 		 + "' AND '" + mv_par09 + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F2_LOJA 		BETWEEN '" 	+ mv_par10 		 + "' AND '" + mv_par11 + "'"
	EndIf
	If mv_par03 == 3
	_cQuery += Chr(13) + Chr(10) + " UNION "
	EndIf
	If mv_par03 <> 2
		_cQuery += Chr(13) + Chr(10) + " SELECT COUNT(*) QUANT "
		_cQuery += Chr(13) + Chr(10) + " FROM " + RetSqlName('SF1') + " (NOLOCK)"
		_cQuery += Chr(13) + Chr(10) + " WHERE F1_FILIAL 	BETWEEN '" 	+ mv_par12 		 + "' AND '" + mv_par13 + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F1_DTDIGIT 	BETWEEN '" 	+ dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F1_DOC 		BETWEEN '" 	+ mv_par04 		 + "' AND '" + mv_par05 + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F1_SERIE 		BETWEEN '" 	+ mv_par06 		 + "' AND '" + mv_par07 + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F1_FORNECE 	BETWEEN '" 	+ mv_par08 		 + "' AND '" + mv_par09 + "'"
		_cQuery += Chr(13) + Chr(10) + " AND F1_LOJA 		BETWEEN '" 	+ mv_par10 		 + "' AND '" + mv_par11 + "'"
	EndIf
	_cQuery += Chr(13) + Chr(10) + " ) A"
	
	MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SF1SF2', .F., .T.)},'Verificando movimentos do período...')
	_nQuant := SF1SF2->QUANT
	DbCloseArea()
	
	If _nQuant == 0
		MsgBox('Não há movimentos para reprocessamento com os parâmetros selecionados!','ATENÇÃO!!!','ALERT')	
		Return		
	EndIf

	mata930()  
               /*
    ALERT('TRESTE')
    _dDataBase := dDataBase   
    _cFilAnt   := cFilAnt                 
    _dDataDe   := mv_par01 
    _dDataAte  := mv_par02
    
	DbSelectArea('SM0')
	DbSeek('01' + mv_par12,.f.)
	_nProc := 0
	Do While SM0->M0_CODIGO == '01' .and. SM0->M0_CODFIL <= mv_par13
		For dDataBase := mv_par01 to mv_par02
			++_nProc
		Next
		DbSkip()
	EndDo
	
  	Processa({|| LS_Loja300()},'Processando Cupons Fiscais')

    dDataBase := _dDataBase   
    cFilAnt   := _cFilAnt
	DbSelectArea('SM0')
	DbSeek('01'  + cFilAnt)
	*/
	If !_lCommit
		MsgBox('O reprocessamento não foi efetuado, os livros referentes aos parâmetros informados foram perdidos!','ATENÇÃO!!!','ALERT')	
	EndIf
	
EndIf

Return()
        
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ExcluiLivros()
//////////////////////////////
Count to _nLastRec
DbGoTop()
ProcRegua(_nLastRec)

Do While !eof()
	TcSqlExec((alias())->CAMPO)
	IncProc('Excluindo livros (' + alias() + ')')
	DbSkip()
EndDo
DbCloseArea()
	
Return()                   

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT930SF3()
////////////////////////
_lCommit := .t.
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// não reprocessa cupons fiscais na rotina MATA930 - vai reprocessar na LOJA300
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function __MTA930F2()
////////////////////////
Local _lRet := .t.
Local _cAlias := ParamIxb[1]
If (_cAlias)->F2_ECF == 'S'
	_lRet := .f.
EndIf
Return(_lRet)



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_Loja300()
////////////////////////////
_lCommit := .t.

ProcRegua(_nProc)
DbSeek('01' + mv_par12,.f.)
Do While SM0->M0_CODIGO == '01' .and. SM0->M0_CODFIL <= mv_par13
	For dDataBase := _dDatade to _dDataAte
		IncProc('Cupons fiscais: ' + SM0->M0_CODFIL + ' - ' + dtoc(dDataBase))
		//LOJA300( '01', SM0->M0_CODFIL)       
		
		nOpca		:= 0											// Opcao de escolha
		lWorkFlow 	:= .T.                                       	// Se trabalha com Workflow
		lEcf		:= .T.											// Variavel para verificar se o campo F3_ECF existe
		aArraySD2 	:= {}											// Array que guarda as informacoes do arquivo SD2
		lEstadoDF	:= SuperGetMV("MV_ESTADO") == "DF"				// Se o estado eh "DF"
		cFilAnt		:= SM0->M0_CODFIL
		
		If ! SuperGetMV("MV_MAPARES") == "N"
			If lEstadoDF
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cria a aArraSD2 e gera a query temporaria do SD2   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				LOJA301(.T., mv_par01, mv_par02, @aArraySD2 )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gera informacoes para a aArraySD2             	   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				LOJA301( .F., Nil, Nil, @aArraySD2 )
			EndIf
	
			R930MResumo( lWorkFlow, @aArraySD2 )
			LJ300Proc(.T.,lWorkFlow)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Apaga o temporario criado no LOJA301³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If lEstadoDF
				TMPSD2->(dbCloseArea())
			EndIf
		Else
			LJ300Proc(.F.,lWorkFlow)
		EndIF
	Next
	DbSelectArea('SM0')
	DbSkip()
EndDo

Return()

User Function LJGRVSF3()
a := 0
Return

//iif(cFilAnt $ '01/55', '     ', U_LS_C7CCI())
