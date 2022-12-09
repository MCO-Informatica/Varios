User Function _fRHA032(poProcess)

	Local _aClientes	:= {}
	Local _cCodMun		:= ""
	Local _cMensagem	:= ""
	Local _cAssunto		:= "ERRO - APROVAÇÃO CADASTRO CLIENTE"
	Local _cObsApv		:= ""
	Local _cRecno		:= ""
	Local _aEmail		:= Separa(GetMv("ES_DTFMAIL",,"000335,000148"),",")
	Local _nI			:= 0 
	Private lMsErroAuto	:= .F.
	
	_cOpc		:= alltrim(poProcess:oHtml:RetByName("OPC"))
	_cObs		:= alltrim(poProcess:oHtml:RetByName("OBS"))
	_cCodigo	:= alltrim(poProcess:oHtml:RetByName("CCODIGO"))
	_cLoja		:= alltrim(poProcess:oHtml:RetByName("CLOJA"))
	_cPessoa	:= SubStr(alltrim(poProcess:oHtml:RetByName("PESSOA")),1,1)
	_cNome		:= alltrim(poProcess:oHtml:RetByName("CNOMCLI"))	
	_cTipoCli	:= SubStr(alltrim(poProcess:oHtml:RetByName("TIPOCLI")),1,1)
	_cEnd		:= alltrim(poProcess:oHtml:RetByName("CEND"))
	_cCEP		:= alltrim(poProcess:oHtml:RetByName("CCEP"))
	_cBairro	:= alltrim(poProcess:oHtml:RetByName("CBAIRRO"))
	_cEstado	:= alltrim(poProcess:oHtml:RetByName("CEST"))   
	_cCNPJ		:= AllTrim(poProcess:oHtml:RetByName("CCGC"))
	_cMun		:= alltrim(poProcess:oHtml:RetByName("CMUN"))
	_cCodMun	:= alltrim(poProcess:oHtml:RetByName("CCODMUN"))
	_cEst		:= alltrim(poProcess:oHtml:RetByName("CEST"))
	_cTEL		:= alltrim(poProcess:oHtml:RetByName("CTEL"))
	_cInsEst	:= alltrim(poProcess:oHtml:RetByName("CINSEST"))
	_cBloq		:= SubStr(alltrim(poProcess:oHtml:RetByName("BLOQUEIO")),1,1)
	_cCNAE		:= alltrim(poProcess:oHtml:RetByName("CCNAE"))
	_cNaturez	:= Separa(alltrim(poProcess:oHtml:RetByName("CNATUREZ")),"-")[1]
	_cVend		:= SubStr(alltrim(poProcess:oHtml:RetByName("CVEND")),1,TamSX3("A3_COD")[1])
	_cConta		:= Separa(alltrim(poProcess:oHtml:RetByName("CCONTAB")),"-")[1]
	_cPaisB		:= Separa(alltrim(poProcess:oHtml:RetByName("CPAISB")),"-")[1]
	_cCValor	:= alltrim(poProcess:oHtml:RetByName("CVALOR"))
	_cSeg1		:= Separa(alltrim(poProcess:oHtml:RetByName("CSEG1")),"-")[1]
	_cPais		:= Separa(alltrim(poProcess:oHtml:RetByName("CPAIS")),"-")[1]
	_cSolicit	:= alltrim(poProcess:oHtml:RetByName("CSOLICIT"))
	_cWFUser	:= Separa(alltrim(poProcess:oHtml:RetByName("CAPROV")),"-")[1]
	_cEmailCon	:= alltrim(poProcess:oHtml:RetByName("CEMAILCON"))
	_cProcesso	:= alltrim(poProcess:fProcessID)
	_cRecno		:= alltrim(poProcess:oHtml:RetByName("CHAVE"))
	
	poProcess:Finish()	

	If _cOpc	== "APROVAR"	
	
		
			
	Else
		dbSelectArea("SZ0")
		SZ0->(dbSetORder(1))
		If SZ0->(dbSeek(xFilial("SZ0")+_cCNPJ))
			If RecLock("SZ0",.F.)		
				SZ0->Z0_STATUS	:= "C"
				SZ0->Z0_CADCLI	:= "R"
				SZ0->Z0_OBS		:= AllTrim(SZ0->Z0_OBS) + " " + _cOBS
				SZ0->(MsUnLock())
			EndIF
		EndIf
	EndIf

Return()