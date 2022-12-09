#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_LANCA
// Autor 		Alexandre Dalpiaz
// Data 		27/07/2012
// Descricao  	Gera NFs de entrada para NFs de saída que não foram incluidas nos filiais de destino.
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_LANCA()
////////////////////////

cPerg := 'LS_LANCANF'

ValidPerg()

If !Pergunte(cPerg,.t.)
	Return()
EndIf
 
_aErros	:= Directory('c:\spool\NFE_*.LOG')

For _nI := 1 to len(_aErros)
	fErase('c:\spool\' + _aErros[_nI,1])
Next

Processa({|| RunProc()},'Gerando Notas Fiscais')

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////
_cFilAnt := cFilAnt
// monta array com código dos clientes/fornecedores e lojas
_cQuery := "SELECT A1_COD, A1_LOJA, A1_CGC"
_cQuery += _cEnter + "FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)"
_cQuery += _cEnter + "WHERE A1_COD < '000009'"
_cQuery += _cEnter + "AND A1_MSBLQL = '2'"
_cQuery += _cEnter + "AND SA1.D_E_L_E_T_ = ''"
dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"FORNECE", .T., .T.)
_aFornece := {}
Do While !eof()
	aAdd(_aFornece,{FORNECE->A1_COD, FORNECE->A1_LOJA, FORNECE->A1_CGC})
	DbSkip()
EndDo
DbCloseArea()
                
// acha as notas que não foram incluidas nos destinos
_cQuery := "SELECT ID_ENT, STATUSNFE, F4_ESTOQUE, D2_DOC, D2_LOJA, *"
_cQuery += _cEnter + "FROM ("
_cQuery += _cEnter + "SELECT F4_ESTOQUE, dbo.FN_GETIDSPED(D2_FILIAL) ID_ENT, ISNULL(STATUS,0) STATUSNFE, ISNULL(F1_DTDIGIT,'') F1_DTDIGIT, SD2.*"

_cQuery += _cEnter + "FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SF2') + " SF2 (NOLOCK)"
_cQuery += _cEnter + "ON F2_FILIAL = D2_LOJA"
_cQuery += _cEnter + "AND F2_DOC = D2_DOC"
_cQuery += _cEnter + "AND F2_SERIE = D2_SERIE"
_cQuery += _cEnter + "AND SF2.D_E_L_E_T_ = ''"

_cQuery += _cEnter + "LEFT JOIN " + RetSqlName('SF1') + " SF1 (NOLOCK)"
_cQuery += _cEnter + "ON F1_FILIAL = D2_LOJA"
_cQuery += _cEnter + "AND F1_DOC = RIGHT('000000000' + RTRIM(D2_DOC),9)"
_cQuery += _cEnter + "AND F1_SERIE = D2_SERIE"
_cQuery += _cEnter + "AND F1_FORNECE < '000010'"
_cQuery += _cEnter + "AND F1_LOJA = D2_FILIAL"
_cQuery += _cEnter + "AND SF1.D_E_L_E_T_ = ''"

_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
_cQuery += _cEnter + "ON F4_CODIGO = D2_TES"
_cQuery += _cEnter + "AND SF4.D_E_L_E_T_ = ''"

_cQuery += _cEnter + "LEFT JOIN SPED050 SP50 (NOLOCK)"
_cQuery += _cEnter + "ON SP50.ID_ENT = dbo.FN_GETIDSPED(D2_FILIAL)"
_cQuery += _cEnter + "AND SP50.NFE_ID = F2_SERIE + F2_DOC"
_cQuery += _cEnter + "AND SP50.D_E_L_E_T_ = ''"

_cQuery += _cEnter + "WHERE D2_CLIENTE < '000010'"
_cQuery += _cEnter + "AND SD2.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND D2_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += _cEnter + "AND D2_PDV = '' ) A"
_cQuery += _cEnter + "WHERE F1_DTDIGIT = ''"
_cQuery += _cEnter + "AND (STATUSNFE = 6"
_cQuery += _cEnter + "OR ID_ENT = '')"

_cQuery += _cEnter + "ORDER BY D2_FILIAL, D2_SERIE, D2_DOC, D2_CLIENTE, D2_LOJA"
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
TcSetField('TRB','D2_EMISSAO','D',0)
count to _nLastRec

If _nLastRec == 0
	MsgBox('Notas fiscais não encontrados. Verifique os parâmetros.','ATENÇÃO!!!','ALERT')
	DbCloseArea()
	Return()
EndIf           

_cPreNotas := ''
_cNotasCla := ''
_cErros    := ''

DbGoTop()
ProcRegua(_nLastRec)
Do While !eof()                           

	_aCabMI   := {}	// arrays para movimento interno de exclusão do saldo - CD e Matriz
	_aItensMI := {}
	cFilAnt   := TRB->D2_LOJA  
	cNumEmp   := '01' + cFilAnt
	SM0->(DbSeek(cNumEmp,.f.))
	_nPosic   := aScan(_aFornece, {|_1| Upper(AllTrim(_1[2])) == TRB->D2_FILIAL })
	                                    
	If AllTrim(TRB->D2_FILIAL) $ "01/55"
		_cTipoEmp := "M"
	ElseIf Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ").or. left(SM0->M0_CGC,8) == left(_aFornece[_nPosic,3] ,8)
		_cTipoEmp := "F"
	Else
		_cTipoEmp := "C"
	EndIf
	
	_aCab := {}
	aAdd(_aCab,{"F1_TIPO",			TRB->D2_TIPO		 		, 	Nil		})
	aAdd(_aCab,{"F1_FORMUL",      	"N" 						, 	Nil		})
	aAdd(_aCab,{"F1_DOC",         	strzero(val(TRB->D2_DOC),9)	, 	Nil		})
	aAdd(_aCab,{"F1_SERIE",      	TRB->D2_SERIE				, 	Nil		})
	aAdd(_aCab,{"F1_EMISSAO",     	TRB->D2_EMISSAO				, 	Nil		})
	aAdd(_aCab,{"F1_FORNECE",     	_aFornece[_nPosic,1] 		, 	Nil		})
	aAdd(_aCab,{"F1_LOJA",        	TRB->D2_FILIAL				, 	Nil		})
	aAdd(_aCab,{"F1_ESPECIE",     	"NFE"						, 	Nil		})
	aAdd(_aCab,{"F1_COND",			"001"						, 	Nil		})
	
	_aBloq := {}                         
	_cFilial := TRB->D2_FILIAL
	_cSerie  := TRB->D2_SERIE
	_cDoc    := TRB->D2_DOC
	_aItens  := {}            
	_lPreNota := .f.
	_cEstoque := ''
	Do While !Eof() .and. _cFilial == TRB->D2_FILIAL .and. _cSerie == TRB->D2_SERIE .and. _cDoc == TRB->D2_DOC
		IncProc()                 
		
		If Posicione('SB1',1,xFilial('SB1') + TRB->D2_COD,'B1_MSBLQL') == '1'
			aAdd(_aBloq,SB1->B1_COD)
			RecLock('SB1',.f.)
			SB1->B1_MSBLQL := '2'
			MsUnLock()
			DbSelectArea('TRB')
		EndIf
		
		*************************************************************************
 		If left(_aFornece[_nPosic,3],8) $ GetMv("MV_LSVCNPJ") .or. left(SM0->M0_CGC,8) == left(_aFornece[_nPosic,3] ,8)
			_cTes := Posicione('SBZ',1,xFilial('SBZ') + TRB->D2_COD,'BZ_TE')
		ElseIf left(_aFornece[_nPosic,3],8) $ GetMv("MV_CNPJLSV") .AND. _cTipoEmp == "M"
			_cTes := Posicione('SBZ',1,xFilial('SBZ') + TRB->D2_COD,'BZ_TEC')
		Else
			_cTes := Posicione('SBZ',1,xFilial('SBZ') + TRB->D2_COD,'BZ_TE_FORN')
		EndIf
		
		If empty(_cTes)
			If left(_aFornece[_nPosic,3],8) $ GetMv("MV_LSVCNPJ") .or. left(SM0->M0_CGC,8) == left(_aFornece[_nPosic,3] ,8)
				_cTes := Posicione('SZQ' , 1 , SB1->B1_GRUPO + _cTipoEmp + xFilial('SZQ') , 'ZQ_TE')
			ElseIf left(_aFornece[_nPosic,3] ,8) $ GetMv("MV_CNPJLSV") .AND. _cTipoEmp == "M"
				_cTes := Posicione('SZQ' , 1 , SB1->B1_GRUPO + _cTipoEmp + xFilial('SZQ') , 'ZQ_TEC')
			Else
				_cTes := Posicione('SZQ' , 1 , SB1->B1_GRUPO + _cTipoEmp + xFilial('SZQ') , 'ZQ_TE_FORN')
			EndIf
		EndIf
		_cEstoque := Posicione('SF4',1,xFilial('SF4') + _cTes,'F4_ESTOQUE') 
		If empty(_cTes) .or. _cEstoque == 'S'
			_lPreNota := .t.
		EndIf

		_aLinha := {}
//		aAdd(_aLinha,{"D1_ITEM"		,	strzero(len(_aItens)+1,4)		, 	Nil })
		aAdd(_aLinha,{"D1_ITEM"		,	SD2->D2_ITEM		, 	Nil })
		aAdd(_aLinha,{"D1_COD"		, 	TRB->D2_COD						, 	Nil })
		aAdd(_aLinha,{"D1_UM"		, 	TRB->D2_UM						, 	Nil	})
		aAdd(_aLinha,{"D1_QUANT"	,	TRB->D2_QUANT					, 	Nil	})
		If SD2->D2_DESC > 0 .and. TRB->D2_PRUNIT == SD2->D2_PRCVEN
			_nPrUnit  := Round((TRB->D2_DESCON + TRB->D2_TOTAL) / TRB->D2_QUANT,4)
			_nDescont := Round(TRB->D2_DESCON * 100 / (TRB->D2_DESCON + TRB->D2_TOTAL),2)
			aAdd(_aLinha,{"D1_VUNIT",	_nPrUnit						,	Nil	})
			aAdd(_aLinha,{"D1_TOTAL",	TRB->D2_QUANT * _nPrUnit		, 	Nil	})
			aAdd(_aLinha,{"D1_DESC"	,	TRB->D2_DESC					, 	Nil	})
		Else
			aAdd(_aLinha,{"D1_VUNIT",	TRB->D2_PRUNIT					,	Nil	})
			aAdd(_aLinha,{"D1_TOTAL",	TRB->D2_QUANT * TRB->D2_PRUNIT	, 	Nil	})
			aAdd(_aLinha,{"D1_DESC"	,	TRB->D2_DESC					, 	Nil	})
		EndIf
		aAdd(_aLinha,{"D1_TES"		,   _cTes							,   Nil	})
		aAdd(_aLinha,{"D1_LOCAL"	,	TRB->D2_LOCAL					,	Nil	})
		aAdd(_aLinha,{"D1_PESO"		,	TRB->D2_PESO					, 	Nil	})
		aAdd(_aLinha,{"D1_TP"		,	TRB->D2_TP						, 	Nil	})
		aAdd(_aLinha,{"D1_TIPO_NF"	,	" "								, 	Nil	})
		aAdd(_aLinha,{"D1_VALDESC"	,	TRB->D2_DESCON					,	Nil	})
		
		If !empty(TRB->D2_NFORI)
			
			DbSelectArea("SA1")
			SA1->( DbSetOrder(9) )
			SA1->( DbSeek(SM0->M0_CGC+SM0->M0_CODFIL) )
			
			aAdd(_aLinha,{"D1_NFORI"	,	TRB->D2_NFORI				,	Nil	})
			aAdd(_aLinha,{"D1_SERIORI"	,	TRB->D2_SERIORI				,	Nil	})
			aAdd(_aLinha,{"D1_ITEMORI"	,	TRB->D2_ITEMORI				,	Nil	})
			aAdd(_aLinha,{"D1_IDENTB6"	,	Posicione("SD2",3,TRB->D2_LOJA+TRB->D2_NFORI+TRB->D2_SERIORI+SA1->A1_COD+SA1->A1_LOJA+TRB->D2_COD+TRB->D2_ITEMORI,"D2_IDENTB6"), Nil	})
			
		EndIf
		
		TRB->(DbSkip())
		aAdd( _aItens, aClone(_aLinha) )
		_aLinha := {}
	EndDo

	lMsErroAuto := .f.   

	If _lPreNota
		MsAguarde({|| MSExecAuto({|x,y,z|Mata140(x,y,z)},_aCab,_aItens,3)},"Aguarde...","Gerando pré-nota de entrada - "  + _aCab[3,2] + ' / ' + _aCab[4,2],.T.)
	Else
		MsAguarde({|| MSExecAuto({|x,y,z|Mata103(x,y,z)},_aCab,_aItens,3)},"Aguarde...","Gerando nota de entrada - "  + _aCab[3,2] + ' / ' + _aCab[4,2],.T.)
	EndIf
	DbSelectArea('SB1')
	For _nI := 1 to len(_aBloq)
		If DbSeek(xFilial('SB1') + _aBloq[_nI],.f.)
			RecLock('SB1',.f.)
			SB1->B1_MSBLQL := '1'
			MsUnLock()
		EndIf
	Next
	
	If lMsErroAuto
		MostraErro('c:\spool\','NFE_' + cFilAnt + '_' + _aCab[3,2] + '_' + _aCab[4,2] + '_' + _aCab[7,2] + '_' + _aCab[7,2] + '.LOG')
	Else
		If _lPreNota
			_cPreNotas += SF1->F1_FILIAL + ' - ' + SF1->F1_DOC + ' / ' + SF1->F1_SERIE + ' - ' + SF1->F1_FORNECE + '/' + SF1->F1_LOJA + _cEnter
		Else
			_cNotasCla += SF1->F1_FILIAL + ' - ' + SF1->F1_DOC + ' / ' + SF1->F1_SERIE + ' - ' + SF1->F1_FORNECE + '/' + SF1->F1_LOJA + iif(_cEstoque == 'S','  (Estoque)','') + _cEnter
		EndIf
	
	EndIf                                        
	DbSelectArea('TRB')

EndDo
        
DbCloseArea()

_aErros	:= Directory('c:\spool\NFE_*.LOG')

For _nI := 1 to len(_aErros)
	_cErros += substr(_aErros[_nI,1],5,2) + ' - ' + substr(_aErros[_nI,1],8,9) + ' / ' + substr(_aErros[_nI,1],18,3) + ' - ' + substr(_aErros[_nI,1],22,6) + '/' + substr(_aErros[_nI,1],29,2) + _cEnter + MemoRead('c:\spool\' + _aErros[_nI,1])
	fErase('c:\spool\' + _aErros[_nI,1])
Next

_cTexto := iif(!empty(_cPreNotas),'Pré-Notas incluídas com sucesso:' + _cEnter + _cEnter + _cPreNotas + _cEnter + _cEnter,'')
_cTexto += iif(!empty(_cNotasCla),'Notas fiscais incluídas com sucesso:' + _cEnter + _cEnter + _cNotasCla + _cEnter + _cEnter,'')
_cTexto += iif(!empty(_cErros)   ,'Erros de importação:' + _cEnter + _cEnter + _cErros, '')
Aviso('Notas Fiscais de Entrada',_cTexto,{'OK'},3,'Log inclusão de NFes')
		
cFilAnt := _cFilAnt
cNumEmp := '01' + cFilAnt

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Data de                       ?","","", "mv_ch1", "D",  8 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "02", "Data até                      ?","","", "mv_ch2", "D",  8 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

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