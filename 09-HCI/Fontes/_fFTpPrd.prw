#Include "Protheus.CH"
#Include "TopConn.Ch"
#Include "RwMake.CH"

User Function _fFTpPrd()

	Local _cFilter	:= ""
	Local _aArea	:= GetArea()
	Local _cTpPrd	:= AllTrim(GetMV("ES_FILTPPR",,"AI|BN|EM|GE|GG|"))
	
	_cFilter	+= "@#"
	_cFilter	+= "("            
//	_cFilter	+= "025->X5_FILIAL == '"+xFilial("SX5")+"'"
//	_cFilter	+= " .AND. "
	_cFilter	+= " 025->X5_TABELA == '02' "
//	_cFilter	+= " .AND. "
//	_cFilter	+= "!(025->X5_CHAVE $ '"
//	_cFilter 	+= _cTpPrd 
//	_cFilter	+= "') "
	_cFilter	+= ")@#"
	RestArea(_aArea)
	
Return _cFilter     

User Function _fFGrpPrd()

	Local _cFilter	:= ""
	Local _aArea	:= GetArea()
	Local _cGpPrd	:= AllTrim(GetMV("ES_FILGRPR",,"0001|0002|0003|0004|0005|0006|0007"))
	
	_cFilter	+= "@#"
	_cFilter	+= "SBM->("            
	_cFilter	+= "SBM->BM_FILIAL == '"+xFilial("SBM")+"'"
	_cFilter	+= " .AND. "
	_cFilter	+= "!(SBM->BM_GRUPO $ '"
	_cFilter 	+= _cGpPrd 
	_cFilter	+= "') "
	_cFilter	+= ")@#"
	RestArea(_aArea)
	
Return _cFilter  

User Function _fGCodPrd()

	Local _cCodPrd		:= ""
	Local _aArea		:= GetArea()
	Local _cCampo		:= ReadVar()
	Local _cSeq			:= Iif(INCLUI,Soma1(_fGetSeq()),SubStr(SB1->B1_COD,7,5))
	Local _cTipo		:= M->B1_TIPO
	Local _cMVEmpAnt	:= AllTrim(GetMV("ES_ATVCPEF",,"0250"))
	Local _nOpcAviso	:= 0
	
	If cEmpAnt+cFilAnt $ _cMVEmpAnt		
		If SB1->(FieldPos("B1_XTPMAT")) != 0
			If Upper(AllTrim(_cCampo)) == "M->B1_TIPO" .And. UPPER(ALLTRIM(M->B1_TIPO)) == "MP"
				_nOpcAviso	:= Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Atribuição do Material ?"),{"Carmar","Cliente"},1)
				If _nOpcAviso == 1
					_cTipo	:= "MP"
				Else
					_cTipo	:= "MC"
				EndIf
			EndIf
			If M->B1_XTPMAT == 'P'
				_cCodPrd	:= _cTipo + Iif(M->B1_TIPO=='MP',M->B1_GRUPO,(M->B1_XUNDNEG + M->B1_XATMAT)) + _cSeq
			Else
				_cCodPrd	:= _cTipo + M->B1_GRUPO + _cSeq
			EndIf
		EndIf
	Else
		_cCodPrd		:= M->B1_COD
	EndIf
	
	RestArea(_aArea)

Return(_cCodPrd)

Static Function _fGetSeq()

	Local _cSeq	:= "00000"
	
	dbSelectArea("SX5")
	SX5->(dbSetORder(1))
	If SX5->(dbSeek(xFilial("SX5") + "SN" + M->B1_TIPO))
		#ifdef SPANISH
			_cSeq	:= ALLTRIM(SX5->X5_DESCSPA)
		#else
			#ifdef ENGLISH
				_cSeq	:= ALLTRIM(SX5->X5_DESCENG)
			#else
				_cSeq	:= ALLTRIM(SX5->X5_DESCRI)
			#endif
		#endif
	EndIf
	
Return(_cSeq)


//-------------------------------------------------------------------
/*/{Protheus.doc} _f014XB
Rotina para criação da consulta padrão de Despesas.

@author 	Bruna Zechetti de Oliveira
@since 		14/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
User Function _f02XB()

	Local alEstrut	:= {}
	Local alCampos	:= {}
	Local olChkB	:= Nil
	Local olBtn1	:= Nil
	Local olBtn2	:= Nil
	Local olBtn3	:= Nil
	Local clNomTmp	:= ""
	Local clMarca	:= "X"
	Local llChkB	:= .T.
	Local _nOpc		:= 0
	Local _cBusca	:= Space(TamSX3("X5_CHAVE")[1])
	Local _nIndice	:= 1
	Local _oIndice	:= Nil
	Local _aBusca	:= {"Codigo"}
	Private olMark	:= Nil
	
	aAdd(alCampos,{"CHAVE"	,,"Chave"		,"@!"})
	aAdd(alCampos,{"DESC"	,,"Descricao"	,"@!"})	

	aAdd(alEstrut,{"CHAVE"	,"C",TamSX3("X5_CHAVE")[1]	,TamSX3("X5_CHAVE")[2]})
	aAdd(alEstrut,{"DESC"	,"C",TamSX3("X5_DESCRI")[1]	,TamSX3("X5_DESCRI")[2]})	

	clNomTmp	:= CriaTrab(alEstrut,.T.)
	If Select("TMP02") > 0
		TMP02->(dbCloseArea())
	EndIf
	dbUseArea(.T.,,clNomTmp,"TMP02",.F.)
	
	INDEX ON CHAVE TAG IND1 TO "TMP02"
	INDEX ON DESC TAG IND2 TO "TMP02"

	FGrvTMP(1)

	TMP02->(dbSetOrder(1))
	TMP02->(dbGoTop())
	
	@000,000 To 440,505 DIALOG olDlgTip TITLE "Tipos de Materiais"
	
		olMark	:= MsSelect():New("TMP02","",,alCampos,,@clMarca,{35,04,200,250})
//		@ 005,004 RADIO _oIndice VAR _nIndice ITEMS "Codigo","Descricao" SIZE 70,10
		_oIndice := TComboBox():New(005,004,{|u|if(PCount()>0,_nIndice:=u,_nIndice)},_aBusca,100,20,olDlgTip,,{||FGrvTMP(_nIndice),TMP02->(dbGoTop()),olMark:oBrowse:Refresh(),olDlgTip:Refresh()},,,,.T.,,,,,,,,,'_nIncide')
		@ 018,004 MSGET _cBusca    							SIZE 150 ,9 OF olDlgTip PIXEL
		@ 004,210 BUTTON olBtn3		PROMPT "Pesquisar" 		SIZE 40,12 ACTION (_fPesqDSP(_nIndice,_cBusca)) 	PIXEL OF olDlgTip
		@ 019,210 BUTTON olBtn3		PROMPT "Limpar Pesq." 	SIZE 40,12 ACTION (FGrvTMP(_nIndice),_cBusca	:= Space(TamSX3("X5_CHAVE")[1]))				PIXEL OF olDlgTip
		@ 205,160 BUTTON olBtn1		PROMPT "Ok" 			SIZE 40,12 ACTION (_nOpc:=1,olDlgTip:End()) 		PIXEL OF olDlgTip
		@ 205,210 BUTTON olBtn2		PROMPT "Cancelar"  		SIZE 40,12 ACTION olDlgTip:End() PIXEL OF olDlgTip

	ACTIVATE DIALOG olDlgTip CENTERED
	
	If _nOpc == 1
		Return(TMP02->CHAVE)
	EndIF
	
Return("")

//-------------------------------------------------------------------
/*/{Protheus.doc} _fPesqDSP
Função para filtro/pesquisa das despesas.

@author 	Bruna Zechetti de Oliveira
@since 		15/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function _fPesqDSP(_nOpc,_cBusca)

    TMP02->(dbSetOrder(_nOpc))
    TMP02->(dbSeek(_cBusca))
    
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} FGrvTMP
Função para gravação dos dados da consulta padrão de Despesas.

@author 	Bruna Zechetti de Oliveira
@since 		14/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function FGrvTMP(_nOpc)

	Local _cQuery	:= ""
	Local _aCodTipo	:= Separa(AllTrim(GetMV("ES_FILTPPR",,"AI|BN|EM|GE|GG|")),"|")
	Local _cCodTipo	:= ""
	Local _cAlias02	:= GetNextAlias()
	Local _nI		:= 0
	
	For _nI := 1 To Len(_aCodTipo)
		_cCodTipo += Iif(Len(_cCodTipo)>0,",","") + "'" +  Alltrim(_aCodTipo[_nI]) + "'"
	Next _nI

	If Select("TMP02") > 0
		TMP02->(dbGoTop())
		If TMP02->(!Eof())
			While TMP02->(!Eof())
				If RecLock("TMP02", .F., .T.)
					TMP02->( dbDelete() )
					TMP02->( MsUnLock() )
				EndIf
				TMP02->( dbSkip() )				
			EndDo
		EndIf
	EndIf

	_cQuery	:= "SELECT	X5_CHAVE, X5_DESCRI "
	_cQuery	+= " FROM " + RetSqlName("SX5") 
	_cQuery	+= " WHERE X5_FILIAL = '" + xFilial("SX5") + "' "
	_cQuery += " AND X5_TABELA = '02' "
	_cQuery	+= " AND X5_CHAVE NOT IN (" + _cCodTipo + ") "
	_cQuery	+= " AND D_E_L_E_T_ = ' '"
    _cQuery	+= " ORDER BY X5_CHAVE "
	TcQuery _cQuery New Alias &(_cAlias02)	
	
	If (_cAlias02)->(!EOF())
		While (_cAlias02)->(!EOF())
			If RecLock("TMP02",.T.)
				TMP02->CHAVE	:= (_cAlias02)->X5_CHAVE
				TMP02->DESC	:= (_cAlias02)->X5_DESCRI
				MsUnLock()
			EndIf		
			(_cAlias02)->(dbSkip())
		EndDO
	EndIf
	(_cAlias02)->(dbCloseArea())
	
    TMP02->(dbSetOrder(1))

Return(Nil)