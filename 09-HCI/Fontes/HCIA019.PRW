#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"
#include "TbIconn.ch" 

#DEFINE CRLF CHR(13) + CHR(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} HCIA019
Rotina para limpeza de residuos e exclusão do pedido de venda.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		26/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function HCIA019()

	Private _aRet		:= {}

	If ParamBox({	{3,"Pedidos",1,{"Selecionar","Importar"},120,,.F.}		},"Limpeza de Pedidos",_aRet,,,.F.,120,3)
		Do Case
			Case _aRet[1] == 1
				Processa({|| _fSelPed()}, "Aguarde!", OEMTOANSI("Realizando a seleção dos pedidos em aberto."))
			Case _aRet[1] == 2
				_cArq	:= cGetFile('','Selecione arquivo',0,'',.T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)
				If !Empty(_cArq)
					Processa({|| _fImpPed(_cArq)}, "Aguarde!", OEMTOANSI("Realizando analise do arquivo selecionado."))					
				EndIf
		End Case
	EndIf
	
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fImpPed
Função para a analise dos registros contidos no arquivo selecionado.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		26/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fImpPed(_cArq)

	Local _cBuffer	:= ""
	Local _cPedido	:= ""
	Local _cMsg		:= ""
	Local _cResiduo	:= ""
	Local _cExc		:= ""
	Local cPath	   	:= AllTrim(GetTempPath())
	Local _cPlanLP	:= "limpeza_pedidos_"+DtoS(dDataBase)+StrTran(Time(),":")+".CSV"
	Local _nHandle	:= FCreate(AllTrim(cPath)+"\"+_cPlanLP)
	Local _cLinha	:= ""
	Local oExcelApp
	Local _nPedidos	:= 0
	Local _aBuffer	:= {}

	FT_FUSE(_cArq)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	
	_cBuffer 	:= Alltrim(FT_FREADLN())
	FT_FSKIP()

	dbSelectArea("SC5")	
	SC5->(dbSetOrder(1))
	
	_cLinha := "Filial;Pedido;Residuo;Exclusao;Mensagem"
	FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
	
	While !FT_FEOF()
		_nPedidos++
		_cBuffer 	:= Alltrim(FT_FREADLN())
		_aBuffer	:= Separa(_cBuffer,";")
		If Len(_aBuffer) == 1
			_cPedido	:= Iif(Len(_cBuffer)<TamSx3("C5_NUM")[1],StrZero(Val(_cBuffer),TamSX3("C5_NUM")[1]),_cBuffer)
			IncProc("Analisando Pedido " + _cPedido)
			
			If SC5->(dbSeek(xFilial("SC5")+_cPedido))
				If _fEResid("SC5",_cPedido)
					_cResiduo	:= "Sim"
					If _fExPed(_cPedido)
						_cExc	:= "Sim"
					Else
						_cExc	:= "Nao"
					EndIf
					_cMsg		:= "Limpeza do pedido realizada com sucesso!"
				Else
					_cResiduo	:= "Nao"
					_cMsg		:= "Ocorreu erro na exclusao de residuos do pedido."
				EndIf
			Else
				_cMsg		:= "Pedido nao encotrado no sistema [" + _cPedido + "]."
				_cResiduo	:= "Nao"
				_cExc		:= "Nao"
			EndIf
			
			_cLinha := xFilial("SC5") + "-" + FWFilialName()+";"+_cPedido+";"+_cResiduo+";"+_cExc+";"+_cMsg
			FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
		EndIF
		
		FT_FSKIP()
	EndDo   

	FT_FUSE()
	FClose(_nHandle)
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop('MsExcel nao instalado')
		Return Nil
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(AllTrim(cPath)+"\"+_cPlanLP)			// Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
	Aviso("Atenção",OEMTOANSI("Finalização da rotina de limpeza dos pedidos não atendidos.") + CRLF +;
						"Pasta selecionada para gravação do arquivo log : " + cPath + CRLF +;
						Alltrim(Str(_nPedidos)) + " registros contidos no arquivo importado." + CRLF ,{"Ok"},2)

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fSelPed
Função para a apresentação dos pedidos em aberto na tela para seleção do usuário

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		26/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fSelPed()

	Local _aEstrut		:= {}
	Local _nOpc			:= 0
	Local _aCmpMarc		:= {}
	Local _cArqTMP		:= ""
	Local _cIndice		:= "PED_FILIAL+DTOS(PED_EMISS)+PED_NUM"
	Local _nOldReg		:= 0
	Local _lInvert		:= .F.
	Local _cTitulo		:= OEMTOANSI("Limpeza de Pedidos não atendidos")
	
	Private _cMark		:= GetMark()
	Private _cAliasMarc := GetNextAlias()
	Private _oDlgLPed	:= Nil
	Private _oGetLPed	:= Nil
	
	Aadd(_aEstrut,{"PED_OK"			,"C",02							,00})
	Aadd(_aEstrut,{"PED_FILIAL"		,"C",TAMSX3("C5_FILIAL")[1]+25	,TAMSX3("C5_FILIAL")[2]})
	Aadd(_aEstrut,{"PED_EMISS"		,"D",TAMSX3("C5_EMISSAO")[1]	,TAMSX3("C5_EMISSAO")[2]})
	Aadd(_aEstrut,{"PED_NUM"		,"C",TAMSX3("C5_NUM")[1]		,TAMSX3("C5_NUM")[2]})
	Aadd(_aEstrut,{"PED_TIPO"		,"C",TAMSX3("C5_TIPO")[1]		,TAMSX3("C5_TIPO")[2]})
	Aadd(_aEstrut,{"PED_CLIENT"		,"C",TAMSX3("C5_CLIENTE")[1]	,TAMSX3("C5_CLIENTE")[2]})
	Aadd(_aEstrut,{"PED_LOJAC"		,"C",TAMSX3("C5_LOJACLI")[1]	,TAMSX3("C5_LOJACLI")[2]})
	Aadd(_aEstrut,{"PED_NOMCLI"		,"C",TAMSX3("A1_NOME")[1]		,TAMSX3("A1_NOME")[2]})
	
	_aCmpMarc	:= {{"PED_OK"		,," "			,"@!"},;
					{"PED_FILIAL"	,,"Filial"		,"@!"},;
					{"PED_EMISS"	,,"Emissao"		,PesqPict('SC5','C5_EMISSAO')},;
					{"PED_NUM"		,,"Pedido"		,"@!"},;
					{"PED_TIPO"		,,"Tipo"		,"@!"},;
					{"PED_CLIENT"	,,"Cliente"		,"@!"},;
					{"PED_LOJAC"	,,"Loja"		,"@!"},;
					{"PED_NOMCLI"	,,"Nome"		,"@!"}}
	

	_cArqTMP	:= CriaTrab(_aEstrut,.T.)     
	Iif(Select(_cAliasMarc) > 0, (_cAliasMarc)->(dbCloseArea()),Nil)
	dbUseArea(.T.,, _cArqTMP,_cAliasMarc,.T.)
	IndRegua(_cAliasMarc,_cArqTMP,_cIndice)
	dbSelectArea(_cAliasMarc)
	
	_fGrvTmp()
	(_cAliasMarc)->(dbGoTop())
	
	_oDlgLPed := TDialog():New(0,000,530,1280,_cTitulo,,,,,,,,oMainWnd,.T.)
	
		_oGetLPed:= MsSelect():New(_cAliasMarc,"PED_OK","",_aCmpMarc,@_lInvert,@_cMark,{08,03,250,640},,,,,)
		_oGetLPed:oBrowse:lhasMark := .t.
		_oGetLPed:oBrowse:lCanAllmark := .t.
		_oGetLPed:oBrowse:bAllMark := { || _nOldReg := (_cAliasMarc)->(RecNo()), (_cAliasMarc)->(DbGoTop()), ;
									(_cAliasMarc)->(DbEval({|| RecLock(_cAliasMarc, .f.), (_cAliasMarc)->PED_OK := ;
									Iif((_cAliasMarc)->PED_OK == _cMark, Space(2), _cMark), (_cAliasMarc)->(MsUnlock()) })),;
									(_cAliasMarc)->(DbGoTo(_nOldReg)), _oGetLPed:oBrowse:Refresh() }

	_oDlgLPed:Activate(,,,.T.,,,{||EnchoiceBar(_oDlgLPed,{|| _nOpc:=1,_oDlgLPed:End()},{|| _nOpc=0,_oDlgLPed:End()},,)},,)

	If _nOpc == 1
		Processa({|| _fLmpPed()}, "Aguarde!", "Realizando limpeza dos pedidos selecionados.")
	EndIf

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fLmpPed
Função para efetuar a limpeza dos pedidos de acordo com a seleção.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		26/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fLmpPed()

	Local _cMsg		:= ""
	Local _cResiduo	:= ""
	Local _cExc		:= ""
	Local cPath	   	:= AllTrim(GetTempPath())
	Local _cPlanLP	:= "limpeza_pedidos_"+DtoS(dDataBase)+".CSV"
	Local _nHandle	:= FCreate(AllTrim(cPath)+"\"+_cPlanLP)
	Local _cLinha	:= ""
	Local _nPedidos	:= 0
	Local oExcelApp
	
	_cLinha := "Filial;Pedido;Residuo;Exclusao;Mensagem"
	FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
		
	ProcRegua((_cAliasMarc)->(RecCount()))
	(_cAliasMarc)->(dbGoTop())
	While (_cAliasMarc)->(!EOF())
		If !EMPTY((_cAliasMarc)->PED_OK)
			_nPedidos++
			IncProc("Analisando Pedido " + (_cAliasMarc)->PED_NUM)
			If _fEResid("SC5",(_cAliasMarc)->PED_NUM)
				_cResiduo	:= "Sim"
				If _fExPed((_cAliasMarc)->PED_NUM)
					_cExc	:= "Sim"
				Else
					_cExc	:= "Nao"
				EndIf
				_cMsg	:= "Limpeza do pedido realizada com sucesso!"
			Else
				_cResiduo	:= "Nao"
				_cMsg	:= "Ocorreu erro na exclusao de residuos do pedido."
			EndIf
			_cLinha := (_cAliasMarc)->PED_FILIAL+";"+(_cAliasMarc)->PED_NUM+";"+_cResiduo+";"+_cExc+";"+_cMsg
			FWrite(_nHandle,AllTrim(_cLinha)+CRLF)
		EndIf
		(_cAliasMarc)->(dbSkip())
	EndDo

	FClose(_nHandle)
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop('MsExcel nao instalado')
		Return Nil
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(AllTrim(cPath)+"\"+_cPlanLP)			// Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
	Aviso("Atenção",OEMTOANSI("Finalização da rotina de limpeza dos pedidos não atendidos.") + CRLF +;
					"Pasta selecionada para gravação do arquivo log : " + cPath + CRLF +;
					Alltrim(Str(_nPedidos)) + " registros selecionados." + CRLF ,{"Ok"},2)
	
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fGrvTmp
Função para gravação dos dados da tabela temporária.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		26/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fGrvTmp()

	Local _cQuery		:= ""
	Local _cAliasTmp	:= GetNextAlias()
	
	_cQuery := "SELECT C7_FILIAL, C7_NUM, C7_TIPO, C7_FORNECE, C7_LOJA, A2_NOME, C7_EMISSAO "
	_cQuery	+= " FROM " + RetSqlName("SC7") + " SC7 "
	
	_cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 "
	_cQuery += " ON A2_FILIAL = '" + xFilial("SA2") + "' "
	_cQuery += " AND A2_COD = C7_FORNECE "
	_cQuery += " AND A2_LOJA = C7_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	
	_cQuery += " WHERE C7_FILIAL = '" + xFilial("SC5") + "' "
	_cQuery += " AND C7_ENCER <> 'E' "
	_cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY C7_EMISSAO, C7_NUM "
	TcQuery _cQuery New Alias &(_cAliasTmp)
	
	If (_cAliasTmp)->(!EOF())
		ProcRegua((_cAliasTmp)->(RecCount()))
		While (_cAliasTmp)->(!EOF())
			IncProc()
			If RecLock((_cAliasMarc),.T.)
				PED_OK		:= Space(2)
				PED_FILIAL	:= (_cAliasTmp)->C7_FILIAL + "-" + FWFilialName()
				PED_NUM		:= (_cAliasTmp)->C7_NUM
				PED_TIPO	:= (_cAliasTmp)->C7_TIPO
				PED_CLIENT	:= (_cAliasTmp)->C7_FORNECE
				PED_LOJA	:= (_cAliasTmp)->C7_LOJA
				PED_NOMCLI	:= (_cAliasTmp)->A2_NOME
				PED_EMISS	:= StoD((_cAliasTmp)->C7_EMISSAO)
				(_cAliasTmp)->(MsUnLock())
			EndIf
			(_cAliasTmp)->(dbSkip())
		EndDo
	EndIf
	
	(_cAliasTmp)->(dbCloseArea())

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fEResid
Função para eliminação dos residuos do pedido.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		26/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fEResid(_cAlias, _cPedido)
	
	Local _aArea	:= GetArea()
	Local lValido	:= .T.
	Local _lOk		:= .T.

	If SoftLock(_cAlias)
		Begin Transaction
		
			dbSelectArea("SC7")
			SC7->(dbSetOrder(1))
			MsSeek(xFilial("SC7")+_cPedido)
			
			While ( !Eof() .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == _cPedido )
				If SC7->C7_ENCER <> 'E' .And. (SC7->C7_QUANT > SC7->C7_QUJE)
					//-- Chama funcao que processa a eliminacao de residuos, acumulados e vinculados
					Ma235ElRes(@nNaoProc,aRefImp)
			
		   		EndIf
				dbSelectArea("SC7")
				SC7->(dbSkip())
			EndDo
		End Transaction
	EndIf
	
	RestArea(_aArea)

Return(_lOk)

//-------------------------------------------------------------------
/*/{Protheus.doc} _fExPed
Função para exclusão do pedido de venda.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		26/06/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
Static Function _fExPed(_cPedido)

	Local _lOk	:= .F.

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
			_lOk	:= .T.
		EndIf
	EndIf

Return(_lOk)