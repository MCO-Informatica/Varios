#INCLUDE 'PROTHEUS.CH'

/* -------------------------------------------------------------------------
Funcao de Transmissao "na unha" de uma nota fiscal por vez
Recebe o numero da nota e a série

Deve ser configurado no job de envio a url onde
o Totvs Sped esta atendendo as requisicoes de webservices
------------------------------------------------------------------------- */
User Function TRANSMITENFE(cNumNF,cSerie,cPedGar,nRecSf1)

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
Local lDeneg		:= .F.

Private aParam := {}
Private cIdEnt := GetIdEnt()
Private aListBox := {}
Private cError := ''

Default nRecSf1 := -1

//Aadd( aRet, .F. )
//Aadd( aRet, "000132")
//Aadd( aRet, cPedGar)
//Aadd( aRet, "ENVIO DE NOTA AO SEFAZ BLOQUEADO TEMPORARIAMENTE")
//Return(aRet)
if nRecSf1 < 0
	DbSelectArea("SA1")
else
	DbSelectArea("SA2")
endif
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
	Aadd( aRet, "Falha ao obter ambiente " + AllTrim( Str( oWS:nAmbiente ) ) + " : "+getwscerror())
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

if nRecSf1 < 0
	dbSetOrder(6)    // F3_FILIAL+F3_NFISCAL+F3_SERIE
	If !DbSeek(xFilial("SF3")+cNumNF+cSerie)
		Aadd( aRet, .F. )
		Aadd( aRet, "000126")
		Aadd( aRet, cPedGar)
		Aadd( aRet, "Nota Fiscal ["+cNumNF+cSerie+"] nao encontrada no sistema")
		Return aRet
	Endif
else
	sf1->(dbgoto(nRecSf1))
	dbSetOrder(5)    // F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIFOR+F3_LOJA
	if !DbSeek(xFilial("SF3")+cSerie+cNumNF+sf1->f1_fornece+sf1->f1_loja)
		Aadd( aRet, .F. )
		Aadd( aRet, "000126")
		Aadd( aRet, cPedGar)
		Aadd( aRet, "Nota Fiscal de Entrada ["+cNumNF+cSerie+"] nao encontrada no sistema")
		Return aRet
	Endif
	
endif


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

if nRecSf1 < 0
	cRetorno := SpedNfeTrf("SF2",cSerie,cNumNF,cNumNF,cIdent,cAmbiente,cModalidade,cVersao,.f.,.f.,.T.)
	sleep(200)

    aParam := {cSerie,cNumNF,cNumNF}
	cIdEnt := GetIdEnt()
	aListBox := u_GTNFeMnt(cIdEnt,1,aParam,.f.,,"")
else
	cRetorno := SpedNfeTrf("SF1",cSerie,cNumNF,cNumNF,cIdent,cAmbiente,cModalidade,cVersao,.f.,.f.,.T.)
	sleep(200)     

	cIdEnt := GetIdEnt()      
	aParam := {cSerie,cNumNF,cNumNF} 
	aListBox := u_GTNFeMnt(cIdEnt,1,aParam,.f.,,"")
endif



//conout("  Pedido GAR "+cPedGar+" Status Transmissao "+cSerie+"-"+cNumNF+": "+CRLF+cRetorno+CRLF)

lSendOk := iif(At("ERRO",UPPER(cRetorno))>0,.F.,.T.)

If lSendOk
	Aadd( aRet, .T. )
	Aadd( aRet, "000131" )
	Aadd( aRet, cPedGar)
	Aadd( aRet, "NF Transmitida com Sucesso "+cSerie+cNumNF)
	
	
Else
	Aadd( aRet, .F. )
	Aadd( aRet, "000132")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "NFe Recusada : "+cSerie+"/"+cNumNF+". Motivo: "+CRLF+cRetorno)
	
Endif

dbSelectArea("SF2")
SF2->(dbSetOrder(1))
SF2->(DbSeek(xFilial("SF2")+cNumNF+cSerie))

if nRecSf1 < 0
	lDeneg := u_NFDENG01()
else
	lDeneg := .f.
endif

If lDeneg
	aRet:={}
	Aadd( aRet, .T. )
	Aadd( aRet, "000169")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Nfe Denegada processada")
EndIf

VarInfo("aRet --",aRet)
//conout("------ [GTNFETRF] FIM TRANSMISSAO NFE "+cSerie+"/"+cNumNF+" Pedido GAR "+cPedGar+" ------- ["+Dtoc(Date())+"-"+TIME()+"]")


Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GTNFETRF  ºAutor  ³Microsiga           º Data ³  12/21/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TransPMSP(cNumNF,cSerie,cPedGar)

Local cTrfPMSP := GetNewPar("MV_TRFPMSP","N")
Local aRet	:= {}
Local cCodMun
Local lOk := .t.
Local cNotasOk
Local nRecnoSF2 := -1
Local nRecnoSF3 := -1
Local cXmlret := ""
Local cErro   := ""
Local cSpedURL
Local nX
Local lSendOk

If cTrfPMSP == "N"
	
	// Integracao para envio automatico nao habilitada
	// Continua do jeito que estava
	
	//	conout("Envio de nota PMSP desabilitada.")
	Aadd( aRet, .T. )
	Aadd( aRet, "" )
	Aadd( aRet, "" )
	Aadd( aRet, "" )
	Return aRet
	
Endif

//conout("*** Transmissao de nota - Prefeitura")
//conout("Nota Fiscal ...: "+cNumNF)
//conout("Serie .........: "+cSerie)
//conout("Pedido GAR ....: "+cPedGar)

// Inicio da montagem da transmissao da nota
// Monta interface client do SPED.

cCodMun       := SM0->M0_CODMUN
cSpedURL      := GetNewPar("MV_SPEDURL","")

If Empty(cSpedURL)
	//	Conout("Problemas EM fPMSP : Verifique MV_SPEDURL")
	Aadd( aRet, .F.)
	Aadd( aRet, "000119")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "")
	Return aRet
Endif

// Demais dados para emissao
Private cIdEnt    := GetIdEnt()
Private cInscMun  := Alltrim(SM0->M0_INSCM)

DbSelectArea("SF3")
dbSetOrder(5)

IF !DBSeek(xFilial("SF3")+cSerie+cNumNF,.T.)
	//	conout("Falha ao buscar SF3 ["+xFilial("SF3")+cSerie+cNumNF+"]")
	Aadd( aRet, .F. )
	Aadd( aRet, "000128")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Nota Fiscal ["+cNumNF+cSerie+"] invalida para processamento ou ja processada.")
	Return aRet
Endif

// Guarda registro do SF3
nRecnoSF3 := Recno()

IF !Empty(F3_DTCANC)
	//	Conout("NOTA PMSP Cancelada em "+dtoc(F3_DTCANC))
	Aadd( aRet, .F. )
	Aadd( aRet, "000127")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Nota Fiscal ["+cNumNF+cSerie+"] cancelada em "+dtoc(F3_DTCANC))
	Return aRet
Endif

lOk :=  ( SubStr(SF3->F3_CFO,1,1)>="5" .Or. SF3->F3_FORMUL=="S" )

If !lOk
	Aadd( aRet, .F. )
	Aadd( aRet, "000128")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Nota Fiscal ["+cNumNF+cSerie+"] inadequada para processamento.")
	Return aRet
Endif

cF3Cfo      := IIF(SF3->F3_CFO<"5","0","1") // 1
cF3Entrada  := SF3->F3_ENTRADA         		 // 2
cF3Serie    := SF3->F3_SERIE          	     // 3
cF3NFiscal  := SF3->F3_NFISCAL        	  	 // 4
cF3ClieFor  := SF3->F3_CLIEFOR        		 // 5
cF3Loja     := SF3->F3_LOJA            	     // 6

// Localiza nota no SF2
DbSelectArea("SF2")
DbSetOrder(1)
If DbSeek(xFilial("SF2")+cF3NFiscal+cF3Serie+cF3ClieFor+cF3Loja)
	// Guarda registro do SF2
	nRecnoSF2 := SF2->(Recno())
	//	conout("Registro da nota no SF2 : "+str(nRecnoSF2,10))
Endif

If nRecnoSF2 < 0
	// Nao achou a nota ? NAo vai rolar ..
	//	conout("Nota nao localizada SF2 ["+xFilial("SF2")+cF3NFiscal+cF3Serie+cF3ClieFor+cF3Loja+"]")
	Aadd( aRet, .F. )
	Aadd( aRet, "000128")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Nota Fiscal ["+cNumNF+cSerie+"] invalida para processamento.")
	Return aRet
Endif

// Inicializa o webservices para transmissao PMSP
oWS := WsNFSE001():New()
oWS:cUSERTOKEN            := "TOTVS"
oWS:cID_ENT               := cIdEnt
oWS:cCodMun               := cCodMun
oWS:_URL                  := AllTrim(cSpedURL)+"/NFSE001.apw"
oWs:OWSNFSE:oWSNOTAS      :=  NFSe001_ARRAYOFNFSES1():New()

// Gera um pacote XML com os dados da nota
aXml := NfseXml(cCodMun,cF3Cfo,cF3Entrada,cF3Serie,cF3NFiscal,cF3ClieFor,cF3Loja)
cNFSE := aXml[1]

If Empty(cNFSE)
	Aadd( aRet, .F. )
	Aadd( aRet, "000129")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "XML Vazio para Nota Fiscal ["+cNumNF+cSerie+"]")
	Return aRet
Endif

cXmlret := ""
cErro   := ""

aadd(oWS:OWSNFSE:OWSNOTAS:OWSNFSES1,NFSE001_NFSES1():New())

oWS:OWSNFSE:OWSNOTAS:OWSNFSES1[1]:CCODMUN  := cCodMun
oWS:OWSNFSE:OWSNOTAS:OWSNFSES1[1]:cID      := cF3Serie+cF3NFiscal
oWS:OWSNFSE:OWSNOTAS:OWSNFSES1[1]:cXML     := cNFSE
oWS:OWSNFSE:OWSNOTAS:OWSNFSES1[1]:CNFSECANCELADA:= " "

lOk := oWS:RemessaNFSE001()

If !lOk
	//	conout("Falha no envio - PMSP : "+Getwscerror())
	Aadd( aRet, .F. )
	Aadd( aRet, "000130")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Erro de Envio da Remessa : "+Getwscerror())
	Return aRet
Endif

oRetorno := oWS:OWSREMESSANFSE001RESULT

If !Empty(oRetorno:OWSID:CSTRING)
	For Nx := 1 to len(oRetorno:OWSID:CSTRING)
		//		conout("Nota Enviada : "+oRetorno:OWSID:CSTRING[nx])
	Next
EndIf

// Caso o array de retorno contenta a nota, entao foi enviada com sucesso
lSendOk  := aScan(oRetorno:OWSID:CSTRING,cF3Serie+AllTrim(cF3NFiscal)) > 0

// Atualiza SF2 com status da emissao / transmissao
DbSelectArea("SF2")
DbSetOrder(1)
DbGoto(nRecnoSF2)

If SF2->F2_FIMP$"N, "
	RecLock("SF2",.F.)
	SF2->F2_FIMP := IIF(lSendOk,"T","N")
	MsUnlock()
Endif


// Atualiza SF3 - Apenas caso exista o campo F3_CODRSEF
dbSelectArea("SF3")
If SF3->(FieldPos("F3_CODRSEF")) > 0
	dbgoto(nRecnoSF3)
	RecLock("SF3")
	SF3->F3_CODRSEF:= IIF(lSendOk,"T","N")
	MsUnlock()
EndIf

IF lSendOk
	
	//	conout("Nota Fiscal enviada com sucesso.")
	
	// Tudo certo !!
	Aadd( aRet, .T. )
	Aadd( aRet, "000131" )
	Aadd( aRet, cPedGar)
	Aadd( aRet, "")
	
Else
	
	// Hummm... algo aconteceu ... nao esta impressa ???
	//	conout("Nota com problema ou rejeitada - Verificar LOG de transmissao.")
	
	Aadd( aRet, .F. )
	Aadd( aRet, "000132")
	Aadd( aRet, cPedGar)
	Aadd( aRet, "Nota PMSP Recusada : "+cF3Serie+cF3NFiscal)
	
Endif

Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GTNFETRF  ºAutor  ³Microsiga           º Data ³  12/28/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Registra falha de transmissao da nota para tentativa posteriº±±
±±º          ³or                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Nota de Produto - SEFAZ
User Function RetranNFE(aRetTrans,cNumNF,cSerie,cPedGar,cCliFor,cLoja)

// Servico de retransmissao de nota descontinuadio ...
// U_SetRetran("S",aRetTrans,cNumNF,cSerie,cPedGar)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GTNFETRF  ºAutor  ³Microsiga           º Data ³  12/28/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Registra falha de transmissao da nota para tentativa posteriº±±
±±º          ³or                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Nota de Software - Prefeitura Municipal
User Function RetranPMSP(aRetTrans,cNumNF,cSerie,cPedGar)

// Servico de retransmissao de nota descontinuadio ...
// U_SetRetran("P",aRetTrans,cNumNF,cSerie,cPedGar)

Return(.T.)

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

//---------- Rotina de COnsulta ----------------------------

User Function GTNFeMnt(cIdEnt,nModelo,aParam,lCTe,lMsg,cModel)

Local aListBox	:= {}
Local aMsg		:= {}
Local aXML		:= {}
Local aNotas	:= {}

Local nX		:= 0
Local nY		:= 0
Local nSX3SF2	:= TamSx3("F2_DOC")[1]
Local nLastXml	:= 0
Local nSFTIndex	:= 0
Local nSFTRecno	:= 0
Local nSF3Index	:= 0
Local nSF3Recno	:= 0

Local lOk		:= .T.

Local oOk		:= LoadBitMap(GetResources(), "ENABLE")
Local oNo		:= LoadBitMap(GetResources(), "DISABLE")
Local oWS
Local oRetorno

Local cTextInut	:= GetNewPar("MV_TXTINUT","")
Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local lCTECan	:= GetNewPar( "MV_CTECAN", .F. ) //-- Cancelamento CTE - .F.-Padrao .T.-Apos autorizacao
Local cModalidade:= ""
Local cChaveF3	:= ""
Local cChaveFT	:= ""
Local cTipoMov	:= ""
Private cError := ''


Private oXml
Default cIdEnt := GetIdEnt()
Default lCTe   := .F.
Default	lMsg   := .T.
Default cModel := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento da NFCe para o Loja                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cModel == "65"
	If !Empty( GetNewPar("MV_NFCEURL","") )
		cURL := PadR(GetNewPar("MV_NFCEURL","http://"),250)
	Endif
Endif

oWS:= WSNFeSBRA():New()
oWS:cUSERTOKEN    := "TOTVS"
oWS:cID_ENT       := cIdEnt 
oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"

If cModel == "65"
	oWS:cModelo   := cModel
Endif

If nModelo == 1
	oWS:cIdInicial    := aParam[01]+aParam[02]
	oWS:cIdFinal      := aParam[01]+aParam[03]
	lOk := oWS:MONITORFAIXA()
	oRetorno := oWS:oWsMonitorFaixaResult
Else
	If VALTYPE(aParam[01]) == "N"
		oWS:nIntervalo := Max((aParam[01]),60)
	Else
		oWS:nIntervalo := Max(Val(aParam[01]),60)
	EndIf	
	lOk := oWS:MONITORTEMPO()
	oRetorno := oWS:oWsMonitorTempoResult
EndIf
If lOk
	dbSelectArea("SF3")
	dbSetOrder(5)
    For nX := 1 To Len(oRetorno:oWSMONITORNFE)
  		aMsg := {}
 		oXml := oRetorno:oWSMONITORNFE[nX]
 		If Type("oXml:OWSERRO:OWSLOTENFE")<>"U"
			nLastRet := Len(oXml:OWSERRO:OWSLOTENFE)
	 		For nY := 1 To Len(	oXml:OWSERRO:OWSLOTENFE) 				                            
 				If oXml:OWSERRO:OWSLOTENFE[nY]:NLOTE<>0
	 				aadd(aMsg,{oXml:OWSERRO:OWSLOTENFE[nY]:NLOTE,oXml:OWSERRO:OWSLOTENFE[nY]:DDATALOTE,oXml:OWSERRO:OWSLOTENFE[nY]:CHORALOTE,;
	 							oXml:OWSERRO:OWSLOTENFE[nY]:NRECIBOSEFAZ,;
	 							oXml:OWSERRO:OWSLOTENFE[nY]:CCODENVLOTE,PadR(oXml:OWSERRO:OWSLOTENFE[nY]:CMSGENVLOTE,50),;
	 							oXml:OWSERRO:OWSLOTENFE[nY]:CCODRETRECIBO,PadR(oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETRECIBO,50),;
	 							oXml:OWSERRO:OWSLOTENFE[nY]:CCODRETNFE,PadR(oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE,50)})
				EndIf
				SF3->(dbSetOrder(5))
				If SF3->(MsSeek(xFilial("SF3")+oXml:Cid,.T.))
					nSFTRecno:= SFT->(RECNO())
					nSFTIndex:= SFT->(IndexOrd())
					While !SF3->(Eof()) .And. AllTrim(SF3->(F3_SERIE+F3_NFISCAL))==oXml:Cid
						If SF3->( (Left(F3_CFO,1)>="5" .Or. (Left(F3_CFO,1)<"5" .And. F3_FORMUL=="S")) .And. FieldPos("F3_CODRSEF")<>0)
							RecLock("SF3")
							SF3->F3_CODRSEF:= oXml:OWSERRO:OWSLOTENFE[nY]:CCODRETNFE
							//SE FOR UMA NOTA DENEGADA, INFORMA NO CAMPO F3_OBSERV
							If oXml:OWSERRO:OWSLOTENFE[nY]:CCODRETNFE $ RetCodDene()
								SF3->F3_OBSERV := "NF DENEGADA"
							EndIf 
						    //SE FOR INUTILIZAÇÃO ALTERA NOS LIVROS FISCAIS
							If !Empty(cTextInut)
							    If Type("oXml:OWSERRO:OWSLOTENFE["+AllTrim(Str(nY))+"]:CMSGRETNFE")<>"U" .And. ("Inutilizacao de numero homologado" $ oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE .Or. "Inutilização de número homologado" $ oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE)
									SF3->F3_OBSERV := ALLTRIM(cTextInut)
								EndIf
							EndIF
							
							If SF3->F3_FORMUL == "S"
								cTipoMov :=	"E"
							Else
								cTipoMov := "S"
							EndIf
							
							SFT->(dbSetOrder(1))
							If SFT->(Dbseek(xFilial("SFT")+cTipoMov+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA))
								RecLock("SFT")
								If !Empty(cTextInut)
							    	If Type("oXml:OWSERRO:OWSLOTENFE["+AllTrim(Str(nY))+"]:CMSGRETNFE")<>"U" .And. ("Inutilizacao de numero homologado" $ oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE .Or. "Inutilização de número homologado" $ oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE)
										SFT->FT_OBSERV := ALLTRIM(cTextInut)
									EndIf
								EndIF
							EndIf
							MsUnlock()

							//-- Exclusao CTE somente apos envio e autorizacao da SEFAZ
							If lCTE .And. lCTECan .And. !Empty(SF3->F3_DTCANC)
								DT6->(dbSetOrder(1))
								If	DT6->(MsSeek(xFilial('DT6')+cFilAnt+PadR(SF3->F3_NFISCAL,Len(DT6->DT6_DOC))+SF3->F3_SERIE)) .And. DT6->DT6_STATUS$"B/D"
									RecLock('DT6',.F.)
									If SF3->F3_CODRSEF == '101'
										DT6->DT6_STATUS := 'C'  //Cancelamento SEFAZ Autorizado
									Else
										DT6->DT6_STATUS := 'D'  //Cancelamento SEFAZ Nao Autorizado
									EndIf
									MsUnLock()
								EndIf
							EndIf

						EndIf
						SF3->(dbSkip())
					End
					SFT->(DBSETORDER(nSFTIndex))
					SFT->(DBGOTO(nSFTRecno))
				EndIf
				
				If ExistBlock("FISMNTNFE")
    				ExecBlock("FISMNTNFE",.f.,.f.,{oXml:Cid,aMsg})			                    
         		Endif					
			
			Next nY
				
		   	SF3->(DbSetOrder(5))
			If SF3->(MsSeek(xFilial("SF3")+oXml:Cid,.T.))
				nSF3Recno:= SF3->(RECNO())
				nSF3Index:= SF3->(IndexOrd())
				While !SF3->(Eof()) .And. AllTrim(SF3->(F3_SERIE+F3_NFISCAL))==oXml:Cid
					If (SubStr(SF3->F3_CFO,1,1)>="5" .Or. SF3->F3_FORMUL=="S") 
						aNotas 	:= {}  
						aXml2	:= {}
						aadd(aNotas,{})
						aadd(Atail(aNotas),.F.)
						aadd(Atail(aNotas),IIF(SF3->F3_CFO<"5","E","S"))
						aadd(Atail(aNotas),SF3->F3_ENTRADA)
						aadd(Atail(aNotas),SF3->F3_SERIE)
						aadd(Atail(aNotas),SF3->F3_NFISCAL)
						aadd(Atail(aNotas),SF3->F3_CLIEFOR)
						aadd(Atail(aNotas),SF3->F3_LOJA)
						aXml2 := GetXMLNFE(cIdEnt,aNotas,@cModalidade,Iif(lCTE,"57",""))
						
						If ( Len(aXml2) > 0 )					
							aAdd(aXml,aXml2[1])
						EndIf
						
						nLastXml := Len(aXml)
					Else
						nLastXml:= Len(aXml)
					EndIf
						SF3->(dbSkip())
				End
				SF3->(DBSETORDER(nSF3Index))
				SF3->(DBGOTO(nSF3Recno))
			EndIf
				
			//Nota de saida
			dbSelectArea("SF2")
			dbSetOrder(1)
			If SF2->(MsSeek(xFilial("SF2")+PadR(SUBSTR(oXml:Cid,4,Len(oXml:Cid)),nSX3SF2)+SUBSTR(oXml:Cid,1,3),.T.)) .And. nLastXml > 0 .And. !Empty(aXml)
				If (SF2->(FieldPos("F2_HAUTNFE"))<>0 .And. SF2->(FieldPos("F2_DAUTNFE"))<>0) .And. (Empty(SF2->F2_HAUTNFE) .Or. Empty(SF2->F2_DAUTNFE) .Or. (SF2->(FieldPos("F2_CHVNFE"))>0 .And. Empty(SF2->F2_CHVNFE)))
					RecLock("SF2")
					//SF2->F2_HORA 	:= SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
					//SF2->F2_NFELETR := SUBSTR(oXml:Cid,4,9)
					//SF2->F2_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
					//SF2->F2_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5) 
					//SF2->F2_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
					SF2->F2_HAUTNFE := IIF(!Empty(aXML[nLastXML][6]),SUBSTR(aXML[nLastXML][6],1,5),"")      //Grava a hora de autorização da nota 
					SF2->F2_DAUTNFE	:= IIF(!Empty(aXML[nLastXML][7]),aXML[nLastXML][7],SToD("  /  /    "))  //Grava a data de autorização da nota					
					If !Empty(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE) .And. !oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ "100,101,102,124,"+ RetCodDene() 	//Se o retorno for uma rejeição, grava o F2_FIMP como N e a legenda fica como Não Autorizada(preto) (124 = Autorização DPEC)
						SF2->F2_FIMP := "N"	
					ElseIf !Empty(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE) .And. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene() 					// Atualizar a Leganda para Nf-e denegada
						SF2->F2_FIMP := "D"	
					EndIf	
					
					MsUnlock()						
				EndIf			

				If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]) .And. ( !Empty(aXml[nLastXml][1]) .OR. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene() )// Inserida verificação do protocolo , antes de gravar a Chave. Para nota denegada deve gravar a chave
					RecLock("SF2")
					SF2->F2_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
					MsUnlock()						
					// Grava quando a nota for Transferencia entre filiais 
					IF SF2->(FieldPos("F2_FILDEST"))> 0 .And. SF2->(FieldPos("F2_FORDES"))> 0 .And.SF2->(FieldPos("F2_LOJADES"))> 0 .And.SF2->(FieldPos("F2_FORMDES"))> 0 .And. !EMPTY (SF2->F2_FORDES)  
				       SF1->(dbSetOrder(1))
				    	If SF1->(MsSeek(SF2->F2_FILDEST+SF2->F2_DOC+SF2->f2_SERIE+SF2->F2_FORDES+SF2->F2_LOJADES+SF2->F2_FORMDES))
				    		If EMPTY(SF1->F1_CHVNFE)	
					    		RecLock("SF1",.F.)
					    		SF1->F1_CHVNFE := SF2->F2_CHVNFE
					    		MsUnlock()
					    	EndIf	
				    	Endif					    
				    EndiF
				EndIf										
			
			  	//Atualizo SF3
				SF3->(dbSetOrder(4))
				cChave := xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE
				If SF3->(MsSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE,.T.))
					Do While cChave == xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE .And. !SF3->(Eof())
						RecLock("SF3",.F.)
						//SF3->F3_NFELETR	:= SUBSTR(oXml:Cid,4,9)
						//SF3->F3_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
						//SF3->F3_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5) 
						//SF3->F3_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
						If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]) .And. ( !Empty(aXml[nLastXml][1]) .Or. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene() )  // Inserida verificação do protocolo, antes de gravar a Chave. Para nota denegada deve gravar a chave.
							SF3->F3_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						EndIf	
						MsUnLock()
				    SF3->(dbSkip())
				    EndDo
				EndIf	
				//Atualizo SF3
				// Grava quando a nota for Transferencia entre filiais 
				IF SF1->(!EOF()) .And. SF2->(FieldPos("F2_FILDEST"))> 0 .And. SF2->(FieldPos("F2_FORDES"))> 0 .And.SF2->(FieldPos("F2_LOJADES"))> 0 .And.SF2->(FieldPos("F2_FORMDES"))> 0 .And. !EMPTY (SF2->F2_FORDES)   
					SF3->(dbSetOrder(4))
					cChave := SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE
					If SF3->(MsSeek(SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,.T.))
						Do While cChave == SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE .And. !SF3->(Eof())
							RecLock("SF3",.F.)
							//SF3->F3_NFELETR	:= SUBSTR(oXml:Cid,4,9)
							//SF3->F3_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
							//SF3->F3_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5) 
							//SF3->F3_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
							If !Empty(aXML) .And.!Empty(aXml[nLastXml][2]).And. ( !Empty(aXml[nLastXml][1]) .Or. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene() ) // Inserida verificação do protocolo, antes de gravar a Chave. Para nota denegada deve gravar a chave.
								If EMPTY(SF3->F3_CHVNFE)
									SF3->F3_CHVNFE  := SF2->F2_CHVNFE
								EndIf
							EndIf
							MsUnLock()
					    SF3->(dbSkip())
					    EndDo
					EndIf					
				 EndIf 	 
				  	
			  	//Atualizo SFT
			  	SFT->(dbSetOrder(1))
				cChave := xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA
				If SFT->(MsSeek(xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
					Do While cChave == xFilial("SFT")+"S"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
						RecLock("SFT",.F.)
						//SFT->FT_NFELETR	:= SUBSTR(oXml:Cid,4,9)
						//SFT->FT_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
						//SFT->FT_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5) 
						//SFT->FT_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
						If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]).And. ( !Empty(aXml[nLastXml][1]) .Or. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene() ) // Inserida verificação do protocolo, antes de gravar a Chave.
							SFT->FT_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						EndIf
						MsUnLock()
						SFT->(dbSkip())
			    	EndDo
				EndIf 
				
			  	//Atualizo SFT	
				// Grava quando a nota for Transferencia entre filiais 
				IF SF1->(!EOF()) .And. SF2->(FieldPos("F2_FILDEST"))> 0 .And. SF2->(FieldPos("F2_FORDES"))> 0 .And.SF2->(FieldPos("F2_LOJADES"))> 0 .And.SF2->(FieldPos("F2_FORMDES"))> 0 .And. !EMPTY (SF2->F2_FORDES)  
				  	SFT->(dbSetOrder(1))
					cChave := SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
					If SFT->(MsSeek(SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA,.T.))
						Do While cChave == SFT->FT_FILIAL+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
							RecLock("SFT",.F.)
							//SFT->FT_NFELETR	:= SUBSTR(oXml:Cid,4,9)
							//SFT->FT_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
							//SFT->FT_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5) 
							//SFT->FT_CODNFE	:=IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
							If !Empty(aXML) .And.!Empty(aXml[nLastXml][2]).And. ( !Empty(aXml[nLastXml][1]) .Or. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene() ) // Inserida verificação do protocolo, antes de gravar a Chave.
								If EMPTY(SFT->FT_CHVNFE)
									SFT->FT_CHVNFE  := SF2->F2_CHVNFE
								Endif
							EndIf
							MsUnLock()
							SFT->(dbSkip())
				    	EndDo
					EndIf
				EndIf
			ElseIf !Empty(SF3->F3_DTCANC) .and. SubStr(SF3->F3_CFO,1,1)>="5" //Alimenta Chave da NFe Cancelada na F3/FT ao consultar o monitorfaixa
				SF3->(dbSetOrder(4))
				cChaveF3 := xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
				cChaveFT := xFilial("SFT")+"S"+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
				SF3->(dbSeek(cChaveF3,.T.))
				While !SF3->(Eof()) .And. xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE == cChaveF3
					RecLock("SF3",.F.)
					If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]) .And. ( !Empty(aXml[nLastXml][1]) .Or. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene()) // Inserida verificação do protocolo, antes de gravar a Chave.
						SF3->F3_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
					EndIf	
					MsUnLock()
				    SF3->(dbSkip())
			    EndDo
				
   				SFT->(dbSetOrder(1))
				SFT->(dbSeek(cChaveFT,.T.))
				While !SFT->(Eof()) .And. xFilial("SFT")+"S"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == cChaveFT
					RecLock("SFT",.F.)
					If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]).And. ( !Empty(aXml[nLastXml][1]) .Or. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene()) // Inserida verificação do protocolo, antes de gravar a Chave.
						SFT->FT_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
					EndIf
					MsUnLock()
					SFT->(dbSkip())
		    	EndDo
			EndIf		
			
			//Nota de entrada
			dbSelectArea("SF1")
			dbSetOrder(1)				
			If SF1->(MsSeek(xFilial("SF1")+PadR(SUBSTR(oXml:Cid,4,Len(oXml:Cid)),nSX3SF2)+SUBSTR(oXml:Cid,1,3),.T.)) //.And. nLastXml > 0 .And. !Empty(aXml)

					aNotas 	:= {}
					aXml2	:= {}
					aadd(aNotas,{})
					aadd(Atail(aNotas),.F.)
					aadd(Atail(aNotas),"E")
					aadd(Atail(aNotas),SF1->F1_EMISSAO)
					aadd(Atail(aNotas),SF1->F1_SERIE)
					aadd(Atail(aNotas),SF1->F1_DOC)
					aadd(Atail(aNotas),SF1->F1_FORNECEDOR)
					aadd(Atail(aNotas),SF1->F1_LOJA)
					aXml2 := GetXMLNFE(cIdEnt,aNotas,@cModalidade,Iif(lCTE,"57",""))

					If ( Len(aXml2) > 0 )
						aAdd(aXml,aXml2[1])
					EndIf

					nLastXml := Len(aXml)					

				//If SF1->(FieldPos("F1_HORA"))<>0 .And. (Empty(SF1->F1_HORA) .OR. Empty(SF1->F1_NFELETR) .Or. Empty(SF1->F1_EMINFE) .Or.Empty(SF1->F1_HORNFE) .Or. Empty(SF1->F1_CODNFE) .Or. (SF1->(FieldPos("F1_CHVNFE"))>0 .And. Empty(SF1->F1_CHVNFE)))
				If (SF1->(FieldPos("F1_HAUTNFE")) <> 0 .And. SF1->(FieldPos("F1_DAUTNFE")) <> 0) .And. (Empty(SF1->F1_HAUTNFE) .Or. Empty(SF1->F1_DAUTNFE) .Or. (SF1->(FieldPos("F1_CHVNFE")) > 0 .And. Empty(SF1->F1_CHVNFE))) .and. len(axml) > 0
					RecLock("SF1")
		   			//SF1->F1_HORA	:= SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
					//SF1->F1_NFELETR := SUBSTR(oXml:Cid,4,9)
					//SF1->F1_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
					//SF1->F1_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5) 
					//SF1->F1_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
					SF1->F1_HAUTNFE := IIF(!Empty(aXML[nLastXML][6]),SUBSTR(aXML[nLastXML][6],1,5),"")      //Grava a hora de autorização da nota 
					SF1->F1_DAUTNFE	:= IIF(!Empty(aXML[nLastXML][7]),aXML[nLastXML][7],SToD("  /  /    "))  //Grava a data de autorização da nota
					If !Empty(aXML) .And.!Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
					    If (SF1->F1_FORMUL == "S") // So grava a a chave da nota se for formulerio prorpio igual a SIM                                                 
						   		SF1->F1_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						EndIF
					EndIf
					If !Empty(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE) .And. !oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ "100,101,102,124,"+RetCodDene() 	 //Se o retorno for uma rejeição, grava o F2_FIMP como N e a legenda fica como Não Autorizada(preto) (124 = Autorização DPEC)
						SF1->F1_FIMP := "N"
					ElseIf !Empty(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE) .And. oXml:OWSERRO:OWSLOTENFE[nLastRet]:CCODRETNFE $ RetCodDene()  					// Atualizar a Leganda para Nf-e denegada
						SF1->F1_FIMP := "D"	
					EndIf
					MsUnlock()						
				EndIf
			
				//Atualizo SF3
				SF3->(dbSetOrder(4))
				cChave := xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE
				If SF3->(MsSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,.T.))
					Do While cChave == xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE .And. !SF3->(Eof())
						RecLock("SF3",.F.)
						//SF3->F3_NFELETR	:= SUBSTR(oXml:Cid,4,9)
						//SF3->F3_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
						//SF3->F3_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5) 
						//SF3->F3_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
						If !Empty(aXML) .And.!Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
							If (SF3->F3_FORMUL == "S")  
								SF3->F3_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						    Endif
						EndIf
						MsUnLock()
				    SF3->(dbSkip())
				    EndDo
				EndIf
				
			  	//Atualizo SFT
			  	SFT->(dbSetOrder(1))
				cChave := xFilial("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
				If SFT->(MsSeek(xFilial("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA,.T.))
					Do While cChave == xFilial("SFT")+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
						RecLock("SFT",.F.)
						//SFT->FT_NFELETR	:= SUBSTR(oXml:Cid,4,9)
						//SFT->FT_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
						//SFT->FT_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5) 
						//SFT->FT_CODNFE	:=IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
						If !Empty(aXML) .And.!Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
							If (SFT->FT_FORMUL == "S")
								SFT->FT_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
							Endif						
						EndIf
						MsUnLock()
						SFT->(dbSkip())
			    	EndDo
				EndIf
			ElseIf !Empty(SF3->F3_DTCANC) .and. SubStr(SF3->F3_CFO,1,1)<"5" //Alimenta Chave da NFe Cancelada na F3/FT  ao consultar o monitorfaixa
				SF3->(dbSetOrder(4))
				cChaveF3 := xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
				cChaveFT := xFilial("SFT")+"E"+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
				SF3->(dbSeek(cChaveF3,.T.))
				While !SF3->(Eof()) .And. xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE == cChaveF3
					RecLock("SF3",.F.)
					If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]) .And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
						SF3->F3_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
					EndIf	
					MsUnLock()
				    SF3->(dbSkip())
			    EndDo
				
   				SFT->(dbSetOrder(1))
				SFT->(dbSeek(cChaveFT,.T.))
				While !SFT->(Eof()) .And. xFilial("SFT")+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == cChaveFT
					RecLock("SFT",.F.)
					If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
						SFT->FT_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
					EndIf
					MsUnLock()
					SFT->(dbSkip())
		    	EndDo
			EndIf						
 		EndIf
   			aadd(aListBox,{ IIf(Empty(oXml:cPROTOCOLO),oNo,oOk),;
			oXml:cID,;
			IIf(oXml:nAMBIENTE==1,"Produção","Homologação"),; //"Produção"###"Homologação"
			IIf(oXml:nMODALIDADE==1 .Or. oXml:nMODALIDADE==4 .Or. oXml:nModalidade==6,"Normal","Contingência"),; //"Normal"###"Contingência"
			oXml:cPROTOCOLO,;
			PadR(oXml:cRECOMENDACAO,250),;
			oXml:cTEMPODEESPERA,;
			oXml:nTEMPOMEDIOSEF,;
			aMsg})                                                              			
			
			aXml 		:= {}  
			nLastXml	:= 0
    Next nX
    If Empty(aListBox) .And. lMsg .And. !lCTe
    	//Aviso("SPED",STR0106,{STR0114})
    EndIf    
    
		
ElseIf !lOk .And. !lCTe .And. lMsg
	//Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
EndIf

Return(aListBox)