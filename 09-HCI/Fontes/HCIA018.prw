#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"

User Function HCIA018()

	Private _aRet	:= {}

	If ParamBox({	{3,"Pedidos",1,{"Selecionar","Importar"},120,,.F.}		},"Limpeza de Pedidos",_aRet,,,.F.,120,3)
		Do Case
			Case _aRet[1] == 1
				_fSelPed()
			Case _aRet[1] == 2
				_fImpPed()
		End Case
	EndIf

Return()

Static Function _fSelPed()

	Local _aEstrut		:= {}
	Local _nOpc			:= 0
	Local _aCmpMarc		:= {}
	Local _cArqTMP		:= ""
	Local _cIndice		:= "PED_FILIAL+PED_NUM+PED_EMISSAO"
	Local _nOldReg		:= 0
	Local _lInvert		:= .F.
	
	Private _cMark		:= GetMark()
	Private _cAliasMarc := GetNextAlias()
	Private _oDlgLPed	:= Nil
	Private _oGetLPed	:= Nil
	
	Aadd(_aEstrut,{"PED_OK"			,"C",02							,00})
	Aadd(_aEstrut,{"PED_FILIAL"		,"C",TAMSX3("C5_FILIAL")[1]+25	,TAMSX3("C5_FILIAL")[2]})
	Aadd(_aEstrut,{"PED_NUM"		,"C",TAMSX3("C5_NUM")[1]		,TAMSX3("C5_NUM")[2]})
	Aadd(_aEstrut,{"PED_TIPO"		,"C",TAMSX3("C5_TIPO")[1]		,TAMSX3("C5_TIPO")[2]})
	Aadd(_aEstrut,{"PED_CLIENTE"	,"C",TAMSX3("C5_CLIENTE")[1]	,TAMSX3("C5_CLIENTE")[2]})
	Aadd(_aEstrut,{"PED_LOJACLI"	,"C",TAMSX3("C5_LOJACLI")[1]	,TAMSX3("C5_LOJACLI")[2]})
	Aadd(_aEstrut,{"PED_NOMCLI"		,"C",TAMSX3("A1_NOME")[1]		,TAMSX3("A1_NOME")[2]})
	Aadd(_aEstrut,{"PED_EMISSAO"	,"D",TAMSX3("C5_EMISSAO")[1]	,TAMSX3("C5_EMISSAO")[2]})
	
	_aCmpMarc	:= {{"PED_OK"		,," "			,"@!"},;
					{"PED_FILIAL"	,,"Filial"		,"@!"},;
					{"PED_NUM"		,,"Pedido"		,"@!"},;
					{"PED_TIPO"		,,"Tipo"		,"@!"},;
					{"PED_CLIENTE"	,,"Cliente"		,"@!"},;
					{"PED_LOJACLI"	,,"Loja"		,"@!"},;
					{"PED_NOMCLI"	,,"Nome"		,"@!"},;
					{"PED_EMISSAO"	,,"Emissao"		,PesqPict('SC5','C5_EMISSAO')}}
	

	_cArqTMP	:= CriaTrab(_aEstrut,.T.)     
	Iif(Select(_cAliasMarc) > 0, (_cAliasMarc)->(dbCloseArea()),Nil)
	dbUseArea(.T.,, _cArqTMP,_cAliasMarc,.T.)
	IndRegua(_cAliasMarc,_cArqTMP,_cIndice)
	dbSelectArea(_cAliasMarc)                                             			
	
	_fGrvTmp()
	
	DEFINE MSDIALOG _oDlgLPed TITLE OEMTOANSI("Limpeza de Pedidos não atendidos") FROM 0,0 TO 530,1280 PIXEL
	
		_oGetLPed:= MsSelect():New(_cAliasMarc,"PED_OK",,_aCmpMarc,@_lInvert,@_cMark,{18,03,250,640},,,,,/*alCores*/)
		_oGetLPed:oBrowse:lhasMark := .t.
		_oGetLPed:oBrowse:lCanAllmark := .t.
		_oGetLPed:oBrowse:bAllMark := { || _nOldReg := (_cAliasMarc)->(RecNo()), (_cAliasMarc)->(DbGoTop()), ;
									(_cAliasMarc)->(DbEval({|| RecLock(_cAliasMarc, .f.), (_cAliasMarc)->PED_OK := ;
									Iif((_cAliasMarc)->PED_OK == _cMark, Space(2), _cMark), (_cAliasMarc)->(MsUnlock()), ;
									Eval(_oGetLPed:bMark) })), (_cAliasMarc)->(DbGoTo(_nOldReg)), _oGetLPed:oBrowse:Refresh() }
			
	ACTIVATE MSDIALOG _oDlgLPed On Init EnchoiceBar(_oDlgLPed,{|| _nOpc:=1,_oDlgLPed:End()},{_nOpc:=0,_oDlgLPed:End()},,) Centered

	If _nOpc == 1
		Processa({|| _fLmpPed()}, "Aguarde!", "Realizando limpeza dos pedidos selecionados.")
	EndIf

Return()

Static Function _fLmpPed()
	
	ProcRegua((_cAliasMarc)->(RecCount()))
	(_cAliasMarc)->(dbGoTop())
	While (_cAliasMarc)->(!EOF())
		If !EMPTY((_cAliasMarc)->PED_OK)
			IncProc("Analisando Pedido " + (_cAliasMarc)->PED_NUM)
			If _fEResid("SC5",(_cAliasMarc)->PED_NUM)
				_fExPed((_cAliasMarc)->PED_NUM)
			EndIf
		EndIf
		(_cAliasMarc)->(dbSkip())
	EndDo

Return()

Static Function _fGrvTmp()

	Local _cQuery		:= ""
	Local _cAliasTmp	:= GetNextAlias()
	
	_cQuery := "SELECT C5_FILIAL, C5_NUM, C5_TIPO, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO "
	_cQuery	+= " FROM " + RetSqlName("SC5") + " SC5 "
	
	_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery += " ON A1_FILIAL = '" + xFilial("SA1") + "' "
	_cQuery += " AND A1_COD = C5_CLIENTE "
	_cQuery += " AND A1_LOJA = C5_LOJACLI "
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	
	_cQuery += " WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
	_cQuery += " AND C5_NUM IN (SELECT C6_NUM "
	_cQuery += " 					FROM " + RetSqlName("SC6") + " SC6 "
	_cQuery += " 					WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
	_cQuery += " 					AND C6_QTDVEN <> C6_QTDENT "
	_cQuery += " 					AND C6_QTDENT = 0 "
	_cQuery += " 					AND D_E_L_E_T_ = ' ' "
	_cQuery += " 					GROUP BY C6_NUM "
	_cQuery += " 					ORDER BY C6_NUM) "
	_cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY C5_EMISSAO, C5_NUM "
	TcQuery _cQuery New Alias &(_cAliasTmp)
	
	If (_cAliasTmp)->(!EOF())
		While (_cAliasTmp)->(!EOF())
			If RecLock((_cAliasMarc),.T.)
				PED_OK		:= Space(2)
				PED_FILIAL	:= (_cAliasTmp)->C5_FILIAL
				PED_NUM		:= (_cAliasTmp)->C5_NUM
				PED_TIPO	:= (_cAliasTmp)->C5_TIPO
				PED_CLIENTE	:= (_cAliasTmp)->C5_CLIENTE
				PED_LOJACLI	:= (_cAliasTmp)->C5_LOJACLI
				PED_NOMCLI	:= (_cAliasTmp)->A1_NOME
				PED_EMISSAO	:= StoD((_cAliasTmp)->C5_EMISSAO)
				(_cAliasTmp)->(MsUnLock())
			EndIf
			(_cAliasTmp)->(dbSkip())
		EndDo
	EndIf
	
	(_cAliasTmp)->(dbCloseArea())

Return()

Static Function _fImpPed()

Return()

Static Function _fEResid(_cAlias, _cPedido)
	
	Local _aArea	:= GetArea()
	Local lValido	:= .T.
	Local _lOk		:= .T.

	If SoftLock(_cAlias)
		Begin Transaction
		
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			MsSeek(xFilial("SC5")+_cPedido)

			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			MsSeek(xFilial("SC6")+SC5->C5_NUM)
			
			While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM )
				If SC6->C6_BLQ <> 'R'
					lValido  := .T.
					If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
						If FindFunction("EECZERASALDO")
							lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
						Else
							lValido := EECCancelPed(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
						EndIf
					EndIf
			    	If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
		    		    MaResDoFat(,.T.,.F.)
		    		Else
		    			_lOk	:= .F.
		    		EndIf	
		   		EndIf
				dbSelectArea("SC6")
				SC6->(dbSkip())
			EndDo
			SC6->(MaLiberOk({SC5->C5_NUM},.T.))
		End Transaction
	EndIf
	
	RestArea(_aArea)

Return(_lOk)

Static Function _fExPed(_cPedido)

	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	MsSeek(xFilial("SC6")+_cPedido)
	
	While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == _cPedido )
		If RecLock("SC6", .F., .T.)
			SC6->( dbDelete() )
			SC6->( MsUnLock() )
		EndIf
		SC6->(dbSkip())
	EndDo

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+_cPedido))
		If RecLock("SC5", .F., .T.)
			SC5->( dbDelete() )
			SC5->( MsUnLock() )
		EndIf
	EndIf

Return()