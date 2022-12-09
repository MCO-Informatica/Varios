#include "Protheus.ch"
#include 'Restful.ch'
#include "FwMvcDef.ch"
#include 'tbiconn.ch'
//#include "Topconn.ch"

WsRestful wsCliente  Description 'Integração de clientes' FORMAT "application/json"

	WsData Cpf AS Character
	WsData Grupo AS Character
	WsData Filial AS Character

	WsMethod GET  Description 'Consulta de cliente'  WsSyntax "/wsCliente?Cpf=valueParam1&Grupo=valueParam2&Filial=valueParam3"
	WsMethod POST Description 'Inclusão de cliente'  WsSyntax ""

End WsRestful

WsMethod GET WsReceive Cpf, Grupo, Filial WsService wsCliente
	Local _lRet := .t.
	Local _oResp := JsonObject():New()
	Local _oJSa1 := JsonObject():New()
	Local _cCpf := Self:Cpf
	Local _cGru := Self:Grupo
	Local _cFil	:= Self:Filial
	Local _aEnd 	:= {}
	Local _cEnd 	:= ""
	Local _cNum 	:= ""
	Local _cCompl:= ""
	Local _cDtNasc := ""

	::SetContentType("application/json; charset=utf-8")

	//_oResp['Status'] := 200
	//_oResp['Message']:= _cCpf+" "+_cGru+" "+_cFil		//EncodeUTF8( "", "cp1252")
	//::SetResponse(_oResp:toJson())
	//return .t.

	If empty(_cCpf) //Len(::aURLParms) == 0
		SetRestFault(400, EncodeUTF8("Parametro CPF/CNPJ é necessário", "cp1252") )
		_lRet := .f.
		//::aURLParms[1]
	else
		if empty(_cGru) .or. empty(_cFil)
			_cGru := "01"
			_cFil := "0201"
		endif
		_lRet := u_abrirAmb(_cGru,_cFil)
		if _lRet
			sa1->(dbSetOrder(3))
			if sa1->(MsSeek(xFilial()+_cCpf))
				_aEnd 	:= MyGetEnd(sa1->a1_end,"SA1")
				_cEnd 	:= _aEnd[1]
				_cNum 	:= alltrim(str(_aEnd[2]))
				_cCompl := _aEnd[4]
				_cDtNasc := DtoS(sa1->a1_dtnasc)
				_cDtNasc := substr(_cDtNasc,1,4)+"-"+substr(_cDtNasc,5,2)+"-"+substr(_cDtNasc,7,2)
				_oJSa1['nome']     := EncodeUTF8(sa1->a1_nome, "cp1252")
				_oJSa1['email']    := sa1->a1_email
				_oJSa1['ddd']      := sa1->a1_ddd
				_oJSa1['telefone'] := sa1->a1_tel
				_oJSa1['dtNasc']   := _cDtNasc
				_oJSa1['endereco'] := _cEnd
				_oJSa1['Numero']   := _cNum
				_oJSa1['Complemento'] := _cCompl
				_oJSa1['bairro']   := sa1->a1_bairro
				_oJSa1['cep']      := sa1->a1_cep
				_oJSa1['municipio']:= EncodeUTF8(sa1->a1_mun, "cp1252")
				_oJSa1['estado']   := sa1->a1_est
				_oJSa1['codErp']   := sa1->a1_cod
				_oJSa1['tabPreco'] := sa1->a1_tabela
				_oJSa1['ecommerce'] := sa1->a1_xativo
	  
				//_cJSa1 := FWJsonSerialize(_oJSa1)
				_oResp['Status'] := 200
				_oResp['Message']:= _oJSa1
				//_oResp['Message']:= _cJSa1

			Else
				//SetRestFault(204, EncodeUTF8( "Cliente Não existe", "cp1252") )
				_oResp['Status'] := 204
				_oResp['Message']:= EncodeUTF8( "Cliente Não existe", "cp1252")
			EndIf

			::SetResponse(_oResp:toJson())

			RpcClearEnv()

		else
			SetRestFault(500, EncodeUTF8( "Não Abriu Ambiente ", "cp1252") )
			//oResp['Status'] := 500
			//oResp['Message']:=  EncodeUTF8( "Não Abriu Ambiente ", "cp1252")
		endif

	EndIf

Return _lRet


WsMethod POST WsService wsCliente
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
			_lRet := critCliente(_oJson,@_cError)
			if _lRet
				_lRet := cadCliente(_oJson,@_cMens)
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


Static Function critCliente(_oJson,_cError)
	Local _lRet	:= .t.
	//Local _cCpf := _oJson['cpf']
	//Local _cPessoa := iif(len(alltrim(_cCpf))==14,"J","F")

	//if _cPessoa != "F"
	//	_cError := "Não executou a manutenção, pois não é pessoa Física!
	//	_lRet := .f.
	//endif

return _lRet

Static Function cadCliente(_oJson,_cMens)
	Local _lRet    := .t.
	Local _nOpcAuto:= 0
	Local _cEvento := ""

	Local _cError := ""
	Local _oError := ErrorBlock( { |e| _cError := e:Description} )

	Private _cCodCli := ""
	Private _cLojCli := ""
	Private _cCpf    := _oJson['cpf']
	Private _cPessoa := iif(len(alltrim(_cCpf))==14,"J","F")
	Private _cTipoCli:= "F"  //Consumidor final
	Private _cNome   := _oJson['nome']
	Private _cEnd    := _oJson['endereco']
	Private _cNum    := _oJson['numero']
	Private _cCompl  := _oJson['complemento']
	Private _cBairro := _oJson['bairro']
	Private _cEst    := _oJson['estado']
	Private _cCep    := _oJson['cep']
	Private _nCodMun := _oJson['codMunic']
	Private _cMun    := _oJson['municipio']
	Private _cDdd    := _oJson['ddd']
	Private _cTel    := _oJson['telefone']
	Private _DtNasc  := StoD(replace(_oJson['dtNasc'],"-",""))
	Private _cEmail  := _oJson['email']
	Private _IE      := "" //_oJson['IECliente']

	Private _cRisco  := "A"
	//Private _cNaturez:= "0103"

	Private _oModel
	Private _oField

	//Private _lMsErroAuto := .f.

	Begin Sequence

		_oModel := FwLoadModel("CRMA980")
		_oField := _oModel:GetModel("SA1MASTER")

		_cEnd := alltrim(_cEnd)
		if !empty(_cNum)
			_cEnd += ", "+alltrim(_cNum)
		endif
		if !empty(_cCompl)
			_cEnd += " "+alltrim(_cCompl)
		endif

		sa1->(dbSetOrder(3))
		if sa1->(MsSeek(xFilial()+_cCpf))
			_nOpcAuto := 4
			_cEvento  := "Alteração"
			_cCodCli  := sa1->a1_cod
			_cLojCli  := sa1->a1_loja

			_oModel:SetOperation(MODEL_OPERATION_UPDATE)

		else
			_nOpcAuto := 3
			_cEvento  := "Inclusão"
			_cCodCli := LEFT(_cCpf,8)
			_cLojCli := STRZERO(VAL(SUBSTR(_cCpf,9,4)),4)

			_oModel:SetOperation(MODEL_OPERATION_INSERT)

		endif
		_oModel:Activate()

		_oModel:SetValue("SA1MASTER","A1_CGC"    , _cCpf)
		if _nOpcAuto == 3
			_oModel:SetValue("SA1MASTER","A1_COD"    , _cCodCli)
			_oModel:SetValue("SA1MASTER","A1_LOJA"   , _cLojCli)

			_oModel:SetValue("SA1MASTER","A1_XVEAD"  , "1")
		endif
		_oModel:SetValue("SA1MASTER","A1_PESSOA" , _cPessoa)
		_oModel:SetValue("SA1MASTER","A1_NOME"   , DecodeUTF8(_cNome  , "cp1252"))
		_oModel:SetValue("SA1MASTER","A1_NREDUZ" , DecodeUTF8(substr(_cNome,1,20)  , "cp1252"))
		_oModel:SetValue("SA1MASTER","A1_END"    , DecodeUTF8(_cEnd   , "cp1252"))
		_oModel:SetValue("SA1MASTER","A1_TIPO"   , _cTipoCli)
		_oModel:SetValue("SA1MASTER","A1_BAIRRO" , DecodeUTF8(_cBairro, "cp1252"))
		_oModel:SetValue("SA1MASTER","A1_EST"    , _cEst)
		_oModel:SetValue("SA1MASTER","A1_COD_MUN", _nCodMun)
		_oModel:SetValue("SA1MASTER","A1_MUN"    , DecodeUTF8(_cMun   , "cp1252"))
		_oModel:SetValue("SA1MASTER","A1_CEP"    , _cCep)
		_oModel:SetValue("SA1MASTER","A1_DDD"    , _cDdd)
		_oModel:SetValue("SA1MASTER","A1_TEL"    , _cTel)
		_oModel:SetValue("SA1MASTER","A1_PAIS"   , "105")
		//_oModel:SetValue("SA1MASTER","A1_NATUREZ", _cNaturez)
		if _cPessoa == "F"
			_oModel:SetValue("SA1MASTER","A1_CONTRIB", "2")
			_oModel:SetValue("SA1MASTER","A1_IENCONT", "2")
		else
			If !Empty(_IE)
				_oModel:SetValue("SA1MASTER","A1_INSCR"  , Alltrim(_IE))
			Else
				_oModel:SetValue("SA1MASTER","A1_INSCR"  , "")
			EndIf
			_oModel:SetValue("SA1MASTER","A1_CONTRIB", "2")
			_oModel:SetValue("SA1MASTER","A1_IENCONT", "2")
		endif
		//_oModel:SetValue("SA1MASTER","A1_VEND", "000002")
		_oModel:SetValue("SA1MASTER","A1_EMAIL"  , _cEmail)
		_oModel:SetValue("SA1MASTER","A1_CODPAIS", "01058")
		//_oModel:SetValue("SA1MASTER","A1_IBGE", "")
		_oModel:SetValue("SA1MASTER","A1_DTNASC" , _DtNasc)
		_oModel:SetValue("SA1MASTER","A1_RISCO"  , _cRisco)

		If _oModel:VldData()
			_oModel:CommitData()
			_cMens := _cEvento+" do Cliente CPF/CNPJ: "+_cCpf+" com sucesso !"
		Else
			_lRet := .f.
			_cError := oModel:GetErrorMessage()[6]
			_cMens := "Erro na "+_cEvento+" do Cliente CPF/CNPJ: "+_cCpf+". Detalhes: "+_cError
		EndIf

		_oModel:DeActivate()
		_oModel:Destroy()
		_oModel:=nil

	End Sequence

	ErrorBlock(_oError)	//Restaurando bloco de erro do sistema
	If !Empty(_cError)	//Se houve erro, será mostrado ao usuário
		_lRet := .f.
		_cMens := Substr("Falha na "+_cEvento+" do cliente CPF/CNPJ: "+_cCpf+". Detalhes: "+_cError,1,150)
	EndIf

Return _lRet


Static Function MyGetEnd(_cEndereco,_cAlias)

	Local _cCmpEndN	:= SubStr(_cAlias,2,2)+"_ENDNOT"
	Local _cCmpEst	:= SubStr(_cAlias,2,2)+"_EST"
	Local _aRet		:= {"",0,"",""}

	If _cAlias=='SM0'
		_aRet := FisGetEnd(_cEndereco)
	Else
		//Campo ENDNOT indica que endereco participante nao esta no formato <logradouro>, <numero> <complemento>
		//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
		If (&(_cAlias+"->"+_cCmpEst) == "DF") .Or. ((_cAlias)->(FieldPos(_cCmpEndN)) > 0 .And. &(_cAlias+"->"+_cCmpEndN) == "1")
			_aRet[1] := _cEndereco
			_aRet[3] := "SN"
		Else
			_aRet := FisGetEnd(_cEndereco)
		EndIf
	Endif
Return _aRet
