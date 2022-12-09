#INCLUDE 'PROTHEUS.CH'

/* -------------------------------------------------------------------------
Funcao de Transmissao "na unha" de uma nota fiscal por vez
Recebe o numero da nota e a série

Deve ser configurado no job de envio a url onde   
o Totvs Sped esta atendendo as requisicoes de webservices
------------------------------------------------------------------------- */

User Function TransNfeEnt(cNumNF,cSerie,cPedGar,cFornece,cLoja,cEntSai)

Local aArea			:= GetArea()
Local oWS
Local cSpedURL  	:= ''
Local aRet 			:= {}
Local aInfoNota 	:= {}
Local aXmlNfe   	:= {}
Local lSendOk 		:= .F.
Local cEntidade
Local cAmbiente
Local cModalidade
Local cVersao
Local cDebugInfo	:= ""
Local cIdEnt    	:= GetIdEnt()
Local cRetorno		:= ""

DEFAULT cEntSai:="S"   
DEFAULT cPedGar:="S"           

If cEntSai =='S'
	DbSelectArea("SA1")
Else
	DbSelectArea("SA2")
Endif
cDebugInfo := GetSrvProfString("SPEDDEBUG","0")

IF val(cDebugInfo) > 0 
	// seta parametro de debug para msgs do client de webservices do SPED
	WSDLDBGLevel(3)
Else
	// Debug nao esta ligado ? desliga entao ...
	WSDLDbgLevel(0)
Endif


// Le a URL de envio para Notas Fiscais - SPED - do SX6
cSpedURL  	:= GetNewPar("MV_SPEDURL","")

// Verifica se a configuracao do job de processos está OK
If Empty(cSpedURL)
//	Conout("Problemas EM fNFE : Verifique MV_SPEDURL")
	Aadd( aRet, .F.)
	Aadd( aRet, "000119")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "")
	Return aRet
Endif

// Testa conexao com o Tovs Sped
oWs := WsSpedCfgNFe():New()
oWs:cUserToken := "TOTVS"
oWS:_URL := cSpedURL+"/SPEDCFGNFe.apw"

If !oWs:CFGCONNECT()
	Aadd( aRet, .F.)
	Aadd( aRet, "000120")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "TOTVS SPED SERVICE FORA DO AR - "+GetWscError())
	Return aRet
EndIf

// Obtem o codigo da entidade

oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()

oWS:_URL := cSpedURL+"/SPEDADM.apw"

If !oWs:ADMEMPRESAS()
	Aadd( aRet, .F.)
	Aadd( aRet, "000121")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Falha ao obter identificador da Entidade : "+GetWSCERRor())
Endif

cEntidade := oWs:cADMEMPRESASRESULT

// Obtem o ambiente de execucao do Totvs Services SPED

oWS := WsSpedCfgNFe():New()
oWS:cUSERTOKEN := "TOTVS"
oWS:cID_ENT    := cEntidade
oWS:nAmbiente  := 0
oWS:_URL       := cSpedURL+"/SPEDCFGNFe.apw"

If !oWS:CFGAMBIENTE()
	Aadd( aRet, .F.)
	Aadd( aRet, "000122")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Falha ao obter ambiente " + AllTrim( Str( oWS:nAmbiente ) ) + " : " + getwscerror())
	Return aRet
Endif

cAmbiente := left(oWS:cCfgAmbienteResult,1)

// Obtem a modalidade de execucao do Totvs Services SPED

oWS:cUSERTOKEN := "TOTVS"
oWS:cID_ENT    := cEntidade
oWS:nModalidade:= 0
oWS:cModelo    := ""
oWS:_URL       := cSpedURL+"/SPEDCFGNFe.apw"

If !oWS:CFGModalidade()
	Aadd( aRet, .F.)
	Aadd( aRet, "000123")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Falha ao obter modalidade " + AllTrim( Str( oWS:nModalidade ) ) + " : "+getwscerror() )	
	Return aRet
Endif

cModalidade    := left(oWS:cCfgModalidadeResult,1)

// Obtem a versao de trabalho da NFe do Totvs Services SPED

oWS:cUSERTOKEN := "TOTVS"
oWS:cID_ENT    := cEntidade
oWS:cVersao    := "0.00"
oWS:_URL       := cSpedURL+"/SPEDCFGNFe.apw"

If !oWS:CFGVersao()
	Aadd( aRet, .F.)
	Aadd( aRet, "000124")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Falha ao obter versao NFE : "+getwscerror())
	Return aRet
Endif

cVersao        := oWS:cCfgVersaoResult

// Verifica o status na SEFAZ

oWS:= WSNFESBRA():NEW()
oWS:cUSERTOKEN := "TOTVS"
oWS:cID_ENT    := cEntidade
oWS:_URL       := cSpedURL+"/NFeSBRA.apw"

If !oWS:MONITORSEFAZ()
	Aadd( aRet, .F.)
	Aadd( aRet, "000125")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Falha ao obter status Sefaz : "+getwscerror())
	Return aRet
Endif

// Obtem layout em uso
cMonitorSEF := oWS:cMonitorSefazResult

// Acha a nota fiscal
dbSelectArea("SF3")
dbClearFilter()
RetIndex("SF3")
If cEntSai=='S'
	dbSetOrder(6)    // F3_FILIAL+F3_NFISCAL+F3_SERIE
Else
	dbSetOrder(5)    // F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIFOR+F3_LOJA
EndIf

If iif(cEntSai=='S',!DbSeek(xFilial("SF3")+cNumNF+cSerie),!DbSeek(xFilial("SF3")+cSerie+cNumNF+cFornece+cLoja) )
	Aadd( aRet, .F. )
	Aadd( aRet, "000126")
	Aadd( aRet, cPedGar)
	Aadd( aRet, iif( cEntSai=='S', "Nota Fiscal ["+cNumNF+cSerie+"] nao encontrada no sistema", "Nota Fiscal Entrada ["+cNumNF+cSerie+"] nao encontrada no sistema"))
	Return aRet
Endif

IF !Empty(F3_DTCANC)
	Aadd( aRet, .F. )
	Aadd( aRet, "000127")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Nota Fiscal ["+cNumNF+cSerie+"] cancelada em "+dtoc(F3_DTCANC))
	Return aRet
Endif

If (SubStr(F3_CFO,1,1)>="5" .Or. F3_FORMUL=="S") .and. ;
	(AModNot(F3_ESPECIE)=="55" .Or. cAmbiente=="2")

	Aadd(aInfoNota,{})
	Aadd(Atail(aInfoNota),.f.)	
	Aadd(Atail(aInfoNota),IIF(F3_CFO<"5","0","1"))
	Aadd(Atail(aInfoNota),F3_ENTRADA)
	Aadd(Atail(aInfoNota),F3_SERIE)
	Aadd(Atail(aInfoNota),F3_NFISCAL)
	Aadd(Atail(aInfoNota),F3_CLIEFOR)
	Aadd(Atail(aInfoNota),F3_LOJA)

Else
	Aadd( aRet, .F. )
	Aadd( aRet, "000128")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Nota Fiscal ["+cNumNF+cSerie+"] invalida para processamento ou ja processada.")
	Return aRet
EndIf

cRetorno := SpedNfeTrf(iif(cEntSai=='S',"SF2",'SF3'),cSerie,cNumNF,cNumNF,cIdent,cAmbiente,cModalidade,cVersao,.f.,.f.,.T.)

lSendOk := iif(At("ERRO",UPPER(cRetorno))>0,.F.,.T.)

If lSendOk
	Aadd( aRet, .T. )
	Aadd( aRet, "000131" )
	Aadd( aRet, cPedGar)
	Aadd( aRet, "")
Else
	Aadd( aRet, .F. )
	Aadd( aRet, "000132")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "NFe Recusada : "+cSerie+"/"+cNumNF+". Motivo: "+CRLF+cRetorno)
Endif
VarInfo("aRet --",aRet)


Return aRet

                          
/* ----------------------------------------------------------------------------
Recupera o codigo da entidade...
( Esta funcao esta duplicada, pode ser unificada posteriormente )
------------------------------------------------------------------------------*/

Static Function GetIdEnt()

Local cIdEnt := ""                      			
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs                                	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := "microsigafin@certisign.com.br"//UsrRetMail(RetCodUsr()) -- retirado devido a error.log na recepção de nota via JOB
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
EndIf

Return(cIdEnt)
