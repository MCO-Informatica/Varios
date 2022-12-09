#include 'Protheus.ch'
#include 'Restful.ch'
#include 'tbiconn.ch'
//#include "Topconn.ch"

WsRestful wsPedidoEad  Description 'Integração de pedidos EAD' FORMAT "application/json"

	WsMethod POST Description 'Inclusão de pedido de EAD' WsSyntax ""

End WsRestful

WsMethod POST WsService wsPedidoEad
	Local _cJson := ::getContent()
	Local _oJson := JsonObject():New()
	Local _oResp := JsonObject():New()

	Local _cGrupo  := ""
	Local _cFilial := ""

	local _lRet := .t.

	//Lendo dados do JSON
	Local _cError := ""
	Local _cMens  := ""

	::SetContentType("application/json; charset=utf-8")

	_lRet := u_critJson(_cJson,@_cError)
	if _lRet
		_oJson:fromJson(_cJson)
		_cGrupo := _oJson['grupo']
		_cFilial := _oJson['filial']
		if empty(_cGrupo) .or. empty(_cFilial)
			_cGrupo := "01"
			_cFilial := "0201"
		endif
		_lRet := u_abrirAmb(_cGrupo,_cFilial)
		if _lRet
			//_lRet := critPedidoEad(_oJson,@_cError)
			_lRet := u_critPedido(_oJson,@_cError,.f.)
			if _lRet
				_lRet := cadPedEad(_oJson,@_cMens)
				If _lRet
					_oResp['Status'] := 201
					_oResp['Message']:= EncodeUTF8( _cMens, "cp1252")
					::SetResponse(_oResp:toJson())
				Else
					SetRestFault( 500, EncodeUTF8( _cMens, "cp1252") )
				EndIf
			else
				SetRestFault( 400, EncodeUTF8( _cError, "cp1252") )
			endif
			RpcClearEnv()
		else
			SetRestFault( 500, EncodeUTF8( "Não Abriu Ambiente Protheus", "cp1252") )
		endif
	else
		SetRestFault( 400, EncodeUTF8( _cError, "cp1252") )
	endif

	// Descarta o objeto json
	FreeObj(_oJson)
	FreeObj(_oResp)

Return _lRet

/*
Static Function critJson(_cJson,_cError)
	Local _lRet := .t.
	Local _oJson := JsonObject():New()

	if Empty(_cJson)
		_cError := "Corpo da estrutura Json é necessária !"
		_lRet := .f.
	Else
		_cError := _oJson:fromJson(_cJson)
		//Se vazio, significa que o parser ocorreu sem erros
		if !Empty(_cError)
			_cError := "Falha ao transformar texto em objeto json ! Erro: "+_cError
			_lRet := .f.
		endif
	endif

return _lRet


Static Function critPedidoEad(_oJson,_cError)
	Local _lRet := .t.
	Local _cId	:= strzero(_oJson['id'],11)
	Local _cCpf := _oJson['cpf']
	//Local _cPessoa := iif(len(alltrim(_cCpf))==14,"J","F")

	sc5->(dbSetOrder(10))
	if sc5->(MsSeek(xFilial()+_cId))
		_cError := "O ID "+_cId+" já foi incluido !"
		_lRet := .f.
	endif

	//if _cPessoa != "F"
	//	_cError := "Não executou a manutenção, pois não é pessoa Física !"
	//	_lRet := .f.
	//else
		sa1->(dbSetOrder(3))
		if !sa1->(MsSeek(xFilial()+_cCpf))
			_cError := "Cliente com CPF/CNPJ: "+_cCpf+", não encontrado !"
			_lRet := .f.
		endif

	//endif

return _lRet
*/

Static Function cadPedEad(_oJson,_cMens)
	Local _lRet := .t.
	Local _nI 	:= 0
	Local _nOpcAuto := 3

	Local _aCabec := {}
	Local _aItens := {}
	Local _aLinha := {}

	Local _cNum		:= ""
	Local _cCpf		:= _oJson['cpf']
	Local _vlCompra := _oJson['valorCompra']
	Local _cCondPg  := _oJson['condPgto']
	Local _cNaturez:= "0103"
	//Local _Vend1   := ""
	Local _nId		:= _oJson['id']
	Local _nParc	:= _oJson['parcelas']
	Local _cCartao	:= _oJson['cartao']
	Local _cTid		:= _oJson['tid']
	Local _cAutoriz := _oJson['authorizationCode']
  	Local _cIdPagto := _oJson['paymentId']
	Local _DtPgto   := StoD(replace(_oJson['paymentDt'],"-",""))

	Local _cCurso	:= _oJson['curso']
	Local _cTes	   := "531"

	local _aErroAuto := {}
	Local _cLogErro := ""
	Local _cError := ""
	Local _oError := ErrorBlock( { |e| _cError := e:Description } )

	Private lMsErroAuto := .f.

	Begin Sequence

		sa1->(dbSetOrder(3))
		sa1->(msSeek(xFilial()+_cCpf))

		_cNum := GetSXENum("SC5","C5_NUM")

		aadd(_aCabec, {"C5_NUM"    , _cNum			,Nil})
		aadd(_aCabec, {"C5_TIPO"   , "N"			,Nil})
		aadd(_aCabec, {"C5_CLIENTE", sa1->a1_cod	,Nil})
		aadd(_aCabec, {"C5_LOJACLI", sa1->a1_loja	,Nil})
		aadd(_aCabec, {"C5_CLIENT ", sa1->a1_cod	,Nil})
		aadd(_aCabec, {"C5_LOJAENT", sa1->a1_loja	,Nil})
		aadd(_aCabec, {"C5_TIPOCLI", sa1->a1_tipo	,Nil})
		aadd(_aCabec, {"C5_CONDPAG", _cCondPg		,Nil})
		aadd(_aCabec, {"C5_NATUREZ", _cNaturez		,Nil})
		//aadd(_aCabec, {"C5_VEND1"  , _Vend1			,Nil})
		aadd(_aCabec, {"C5_VOLUME1", 1				,Nil})
		aadd(_aCabec, {"C5_ESPECI1", "Servico"		,Nil})
		aadd(_aCabec, {"C5_TPFRETE", "S"			,Nil})
		aadd(_aCabec, {"C5_XIDAPI" , strzero(_nId,11) ,Nil})
		aadd(_aCabec, {"C5_XNPARC" , strzero(_nParc,2),Nil})
		aadd(_aCabec, {"C5_XADM"   , _cCartao		,Nil})
		aadd(_aCabec, {"C5_XTID"   , _cTid			,Nil})
		aadd(_aCabec, {"C5_XAUTOR" , _cAutoriz		,Nil})
		aadd(_aCabec, {"C5_XPAYID" , _cIdPagto		,Nil})
		aadd(_aCabec, {"C5_XDTMOV" , _DtPgto    	,Nil})

		_aLinha := {}
		aadd(_aLinha,{"C6_ITEM"	  ,'01'			,Nil})
		aadd(_aLinha,{"C6_PRODUTO",_cCurso		,Nil})
		aadd(_aLinha,{"C6_QTDVEN" ,1			,Nil})
		aadd(_aLinha,{"C6_PRCVEN" ,_vlCompra	,Nil})
		aadd(_aLinha,{"C6_VALOR"  ,_vlCompra	,Nil})
		aadd(_aLinha,{"C6_TES"	  ,_cTes		,Nil})
		aadd(_aLinha,{"C6_PRUNIT" ,_vlCompra	,Nil})
		aadd(_aLinha,{"C6_QTDLIB" ,1			,Nil})
		aadd(_aItens, _aLinha)

		MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, _aCabec, _aItens, _nOpcAuto, .f. )
		if lMsErroAuto
			_aErroAuto := GetAutoGRLog()
			For _nI := 1 To Len(_aErroAuto)
				_cLogErro += StrTran(StrTran(_aErroAuto[_nI], "<", ""), "-", "") + " "
				//ConOut(_cLogErro)
			Next
			_lRet := .f.
			_cMens := iif(Empty(_cLogErro),"Internal Error.",Substr(_cLogErro,1,150) )
		Else
			_cMens := "Pedido "+_cNum+", incluido com sucesso !"
		EndIf

	End Sequence

	ErrorBlock(_oError)	//Restaurando bloco de erro do sistema
	If !Empty(_cError)	//Se houve erro, será mostrado ao usuário
		_lRet := .f.
		_cMens := Substr("Falha ao incluir pedido APi: "+alltrim(str(_nId))+". Detalhes: "+_cError,1,150)
	EndIf

Return _lRet
