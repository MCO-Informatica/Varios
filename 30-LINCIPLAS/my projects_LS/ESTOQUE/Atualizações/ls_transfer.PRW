#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_TRANSF
// Autor 		Alexandre Dalpiaz
// Data 		09/02/11
// Descricao  	Tranferencia de armazem
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function LS_TRANSF()
//////////////////////////


cPerg := 'LS_TRANSFE'

ValidPerg()

If !Pergunte(cPerg,.t.)
	Return()
EndIf

Processa({|| RunProc()},'Gerando Transferências')

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

If mv_par04 == 1  // transferencia de almoxarifados
	If mv_par05 == 1  // origem das informações  = estoque
		_cQuery := "SELECT B2_COD, B1_DESC, B1_GRUPO, B2_QATU, B1_MSBLQL, B1_UM"
		_cQuery += _cEnter + "FROM " + RetSqlName('SB2') + " SB2 (NOLOCK)"
		
		_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
		_cQuery += _cEnter + "ON SB1.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + "AND B1_COD = B2_COD"
		If !empty(mv_par03)
			_cQuery += _cEnter + "AND B1_GRUPO = '" + mv_par03 + "'"
		EndIf
		
		_cQuery += _cEnter + "WHERE SB2.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + "AND B2_QATU > 0"
		_cQuery += _cEnter + "AND B2_LOCAL = '" + mv_par01 + "'"
		_cQuery += _cEnter + "AND B2_FILIAL = '" + xFilial('SB2') + "'"
		_cQuery += _cEnter + "ORDER BY B1_GRUPO, B1_COD"
		
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
		
		If eof()
			MsgAlert('Nenhum item com saldo em estoque','ATENÇÃO!!!')
			DbCloseArea()
			Return()
		EndIf
		
	EndIf
	Begin Transaction
	
	Count to _nLastRec
	DbGoTop()
	ProcRegua(_nLastRec)
	Do While !eof()
		
		_cGrupo := TRB->B1_GRUPO
		Do While !Eof() .and. _cGrupo == TRB->B1_GRUPO
			
			IncProc()
			_lBloqueado := .f.
			If TRB->B1_MSBLQL == '1'
				_lBloqueado := .t.
				If SB1->(DbSeek(xFilial('SB1') + TRB->B2_COD,.F.))
					RecLock('SB1',.f.)
					SB1->B1_MSBLQL := '2'
					MsUnLock()
				EndIf
				DbSelectArea('TRB')
			EndIf
			
			LMSERROAUTO := .F.
			_aAuto := {{GetSxENum("SD3","D3_DOC",1),dDataBase}}  //Cabecalho
			
			//Itens a Incluir
			aItem := {}
			
			aadd(aItem,TRB->B2_COD)  		//D3_COD
			aadd(aItem,TRB->B1_DESC)     	//D3_DESCRI
			aadd(aItem,TRB->B1_UM)  		//D3_UM
			aadd(aItem,mv_par01)      		//D3_LOCAL
			aadd(aItem,"")					//D3_LOCALIZ
			aadd(aItem,TRB->B2_COD)  		//D3_COD
			aadd(aItem,TRB->B1_DESC)	    //D3_DESCRI
			aadd(aItem,TRB->B1_UM)  		//D3_UM
			aadd(aItem,mv_par02)      		//D3_LOCAL
			aadd(aItem,"")					//D3_LOCALIZ
			aadd(aItem,"")          		//D3_NUMSERI
			aadd(aItem,"")					//D3_LOTECTL
			aadd(aItem,"")         			//D3_NUMLOTE
			aadd(aItem,ctod(''))			//D3_DTVALID
			aadd(aItem,0)					//D3_POTENCI
			aadd(aItem,TRB->B2_QATU) 		//D3_QUANT
			aadd(aItem,0)					//D3_QTSEGUM
			aadd(aItem,"")   				//D3_ESTORNO
			aadd(aItem,"")         			//D3_NUMSEQ
			aadd(aItem,"")					//D3_LOTECTL
			aadd(aItem,ctod(''))			//D3_DTVALID
			aadd(aItem,"")					//D3_ITEMGRD
			
			aadd(_aAuto,aItem)
			
			MSExecAuto({|x,y| mata261(x,y)},_aAuto,3)
			
			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
				exit
			EndIf
			
			If _lBloqueado
				RecLock('SB1',.f.)
				SB1->B1_MSBLQL := '1'
				MsUnLock()
			EndIf
			
			DbSelectArea('TRB')
			DbSkip()
			
			Pergunte(cPerg,.f.)
			
		EndDo
		
	EndDo
	
	
	End Transaction
	
	DbCloseArea()
	
Else		// movimentação interna
    
	mv_par08 := alltrim(mv_par08)
	If !file(mv_par08)
		MsgBox('Arquivo não localizado','ATENÇÃO!!!!','INFO')
		Return()
	EndIf
		                  
	FT_FUSE(mv_par08)
	ProcRegua(FT_FLastRec())
	FT_FGotop()                      
	
	Do While ( !FT_FEof() )

		IncProc()
		_cLinha := alltrim(FT_FREADLN())

		Do While left(_cLinha,1) == ';'
			IncProc()
			FT_FSkip()
			_cLinha := alltrim(FT_FREADLN())
		EndDo
		
		Do While at(';;',_cLinha) > 0
			_cLinha := strtran(_cLinha,';;',';')
		EndDo
		
		Do While at('; ;',_cLinha) > 0 
			_cLinha := strtran(_cLinha,'; ;',';')
		EndDo
		
		_cLinha := strtran(_cLinha,',','.')   
		If right(_cLinha,1) == ';'
			_cLinha := alltrim(left(_cLinha,len(_cLinha)-1))
    	EndIf
		
		_nPosic   := at(';',_cLinha)
		_cProduto := left(_cLinha,_nPosic-1)

		_cLinha   := substr(_cLinha,_nPosic+1)
		_nPosic   := at(';',_cLinha)
		_cLocal   := left(_cLinha,_nPosic-1)

		_cLinha   := substr(_cLinha,_nPosic+1)
 		_nPosic   := at(';',_cLinha)
		_dData    := ctod(left(_cLinha,_nPosic-1))

		_cLinha   := substr(_cLinha,_nPosic+1)
		_nPosic   := at(';',_cLinha)
		_cDoc     := left(_cLinha,_nPosic-1)

		_cLinha   := substr(_cLinha,_nPosic+1)
		_nPosic   := at(';',_cLinha)
		_cTM      := left(_cLinha,_nPosic-1)

		_cLinha   := substr(_cLinha,_nPosic+1)
		_nQuant   := val(_cLinha)

		_aItens :={}
		aadd ( _aItens, { "D3_FILIAL"	, xFilial("SD3")        , NIL} )
		aadd ( _aItens, { "D3_TM"		, _cTM                  , NIL} )
		aadd ( _aItens, { "D3_COD"		, _cProduto             , NIL} )
		aadd ( _aItens, { "D3_QUANT"	, _nQuant               , NIL} )
		aadd ( _aItens, { "D3_DOC"		, _cDoc                 , NIL} )
		aadd ( _aItens, { "D3_LOCAL"	, _cLocal               , NIL} )
		aadd ( _aItens, { "D3_EMISSAO"	, _dData			    , NIL} )
		
		lMsErroAuto := .F.
		MSExecAuto ( { |x| MATA240(x) }, _aItens )
		If lMsErroAuto
			MostraErro()
		EndIf

		FT_FSkip()
		
	EndDo
	
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Armazém de Origem             ?","","", "mv_ch1", "C",  2 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "02", "Armazém de Destino            ?","","", "mv_ch2", "C",  2 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "03", "Grupo de Produtos             ?","","", "mv_ch3", "C",  4 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBM", "", "",""})
aAdd( aPerg , { cPerg, "04", "Movimento                     ?","","", "mv_ch4", "N",  1 , 0, 0, "C", "", "mv_par04", "Transferência", "", "", "", "", "Movimentação Interna", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "05", "Origem das informações        ?","","", "mv_ch5", "N",  1 , 0, 0, "C", "", "mv_par05", "Estoque", "", "", "", "", "Planilha", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "06", "Cód. da Mov Interna (MI)      ?","","", "mv_ch6", "C",  3 , 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF5", "", "",""})
aAdd( aPerg , { cPerg, "07", "Centro de Custos              ?","","", "mv_ch7", "C", 12 , 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT", "", "",""})
aAdd( aPerg , { cPerg, "08", "Caminho/Arquivo               ?","","", "mv_ch8", "C", 60 , 0, 0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

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
