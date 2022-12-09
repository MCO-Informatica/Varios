//+------------+---------------+----------------------------------------------------------------------------------+--------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao |
//+------------+---------------+----------------------------------------------------------------------------------+--------+
//| 24/04/2020 | Bruno Nunes   | Desenvolvido servico REST que tem como objetivo retornar dados cadastrais dos    | 9.00   |
//|            |               | postos                                                                           |	       |
//+------------+---------------+----------------------------------------------------------------------------------+--------+
#include "protheus.ch"
#include "parmtype.ch"
#include "restful.ch"
#include "tbiconn.ch"

#define cLIGA_LOG   "MV_890_02" //Habilita gravacao de log
#define nQTD_PARAMETRO  2

WSRESTFUL listaPostos DESCRIPTION "Consultar pedidos elegíveis para renovação"
WSDATA token   AS STRING OPTIONAL
WSDATA cnpj	   AS STRING OPTIONAL

WSMETHOD GET DESCRIPTION "Consultar dados cadastrais de Postos da AR" WSSYNTAX "/listaPostos/{token/cnpj}"
END WSRESTFUL

WSMETHOD GET WSRECEIVE token, cnpj WSSERVICE listaPostos
	Local aRet     := {"",""}
	Local cStack   := "Pilha de chamada: listaPostos()" + CRLF
	Local cEnvSrv  := GetEnvServer()	
	Local cReturn  := ""
	Local cThread  := "Thread: " + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()

	default ::token   := "x"
	default ::cnpj 	  := "x"

	//Habilita log 
	lLigaLog := enabledLog( )

	//Gera log abertura da rotina
	logInicio( lLigaLog, ::aURLParms, nTimeIni, cStack, cEnvSrv )

	// Define o tipo de retorno do método
	::SetContentType("application/json")
	varinfo("::aURLParms", ::aURLParms)

	//Valida autenticacaos
	If U_validAut( ::aURLParms, @cReturn, @aRet, @cStack, cThread, nQTD_PARAMETRO )
		//Busca eventos no GAR
		cReturn := getPostos( @aRet, @cStack, @cThread )

		::SetResponse( cReturn )
	Else
		// Autenticação mal sucedida.
		::SetResponse( "{'codigo': " + LTrim( Str( aRet[ 1 ] ) ) + ",'mensagem': '" + aRet[ 2 ] +"' }" )
	Endif

	//Gera log de encerramento da rotina
	logFim( lLigaLog, nTimeIni, aRet, cReturn, cStack, cEnvSrv )

	DelClassIntf()
Return(.T.)

Static Function getPostos( aRet, cStack, cThread )
	Local jSon    := ""
	local cIdAr   := ""
	local cDireto := ""
	local cDesc   := ""
	local cNomFan := ""
	local lAtivo  := .F.
	local lAtende := .F.
	local aPosto  := {}
	local aJPosto := {}
	local oWsGAR  := nil
	local nPosto := 0
	local i := 0

	oWsGAR := WSIntegracaoGARERPImplService():New()
	oWsGAR:listaARs( "erp", "password123" )

	if oWsGAR != nil
		for i := 1 to len( oWsGAR:CAR )
			lAtivo 	:= oWsGAR:CAR[i]:LATIVO
			lAtende := oWsGAR:CAR[i]:LATENDIMENTO
			cIdAr   := oWsGAR:CAR[i]:CID
			cDireto := oWsGAR:CAR[i]:CDIRETORIO
			cDesc   := oWsGAR:CAR[i]:CDESCRICAO
			cNomFan := oWsGAR:CAR[i]:CNOMEFANTASIA

			if lAtivo .and. lAtende 
				aPosto := retPosto( cIdAr )
				if len( aPosto ) > 0
					aAdd( aJPosto, jSonObject():New() )

					nPosto := len(aJPosto)

					aJPosto[nPosto]["idAR"]           := cIdAr
					aJPosto[nPosto]["diretorioAR"]    := cDireto
					aJPosto[nPosto]["descricaoAR"]    := cDesc
					aJPosto[nPosto]["nomeFantasiaAR"] := cNomFan
					aJPosto[nPosto]["listaPostos"]    := aPosto
				endif
			endif 
		next i
		jSon := FWJsonSerialize( aJPosto )
	endif
	If empty( jSon )
		U_arErro( 216, @aRet, @cReturn )
		aAdd( aJPosto, jSonObject():New() )
		aJPosto[ 01 ]["codigo"]   := aRet[ 01 ]
		aJPosto[ 02 ]["mensagem"] := aRet[ 02 ]
		jSon := FWJsonSerialize( aJPosto )							
	Endif
Return( jSon )

static function retPosto( cIdAr )
	local aPosto := {}
	local oWsPosto := nil
	local oPosto := nil
	local lAtende := .F.
	local lAtivo := .F.
	local lVisivel := .F.
	local i := 0
	local nPosto := 0

	default cIdAr := ""

	if !empty( cIdAr )
		oWsPosto := WSIntegracaoGARERPImplService():New()
		oWsPosto:postosParaIdAR( "erp", "password123", cIdAr )

		if oWsPosto != nil

			for i := 1 to len( oWsPosto:OWSPOSTO )		
				oPosto   := oWsPosto:OWSPOSTO[i]
				
				lAtende  := oPosto:LATENDIMENTO 
				lAtivo   := oPosto:LATIVO
				lVisivel := oPosto:LVISIBILIDADE

				//if lAtende .and. lAtivo .and. lVisivel

					aAdd( aPosto, jSonObject():New() )

					nPosto := len(aPosto)

					aPosto[nPosto]["cepPosto"]           := oPosto:NCEP
					aPosto[nPosto]["cidadePosto"]        := oPosto:CCIDADE
					aPosto[nPosto]["descricaoPosto"]     := oPosto:CDESCRICAO
					aPosto[nPosto]["idPosto"]            := oPosto:NID
					aPosto[nPosto]["idRede"]             := oPosto:NIDREDE
					aPosto[nPosto]["nomeFantansiaPosto"] := oPosto:CNOMEFANTASIA
					aPosto[nPosto]["razaoSocialPosto"]   := oPosto:CRAZAOSOCIAL
					aPosto[nPosto]["redePosto"]          := oPosto:CREDE
					aPosto[nPosto]["telefonePosto"]      := oPosto:NTELEFONE
					aPosto[nPosto]["tipoPosto"]          := oPosto:NTIPO
					aPosto[nPosto]["ufPosto"]            := oPosto:CUF
					aPosto[nPosto]["atendimento"]        := oPosto:LATENDIMENTO
					aPosto[nPosto]["ativo"]              := oPosto:LATIVO
					aPosto[nPosto]["visibilidade"]       := oPosto:LVISIBILIDADE
				//endif				
			next i
		endif
	endif
return aPosto

/*
Static Function getEvent1( cCNPJ, cData, aRet, cStack, cThread )
Local aDadosZ5 := {}
Local aHeadStr := {}
Local aStatus := {}
Local aTrilha := {}
Local cDtFormat := ""
Local cEndpoint := ""
Local cGetResult := ""
Local cMV_892_06 := "MV_892_06"
Local cMV_892_07 := "MV_892_07"
Local cParam := ""
Local cPedidoGAR := ""
Local cReturn := ""
Local cStatus := ""
Local cURL := ""
Local i := 0
Local jSon := ""
Local lDeserialize := .T.
Local lGet := .T.
Local oResp 
Local oRest 
Local oResult
Local p := 0 
local aTeste := {}

Private aStatusPed := {}
Private oObj

cStack += "GETEVENT1()" + CRLF

// A data deverá ser entregue para o prottheus no formato AAAAMMDD
// Esta mesma data deverá ser entregue para o GAR no formato AAAA-MM-DD
cDtFormat := SubStr( cData, 1, 4 ) + "-" + SubStr( cData, 5, 2 ) + "-" + SubStr( cData, 7, 2 )

// url teste...: http://192.168.15.74:8080
// url homolog.: http://integracao-ar-homolog.certisign.com.br:8080
// url producao: http://integracao-ar.certisign.com.br
If .NOT. GetMv( cMV_892_06, .T. )
CriarSX6( cMV_892_06, "C", "HOST P/ COMUNICACAO COM SERV REST DO GAR. CSFA892.",;
"http://192.168.15.74:8080" )
Endif
cURL := GetMv( cMV_892_06, .F. )

If .NOT. GetMv( cMV_892_07, .T. )
CriarSX6( cMV_892_07, "C", "ENDPOINT DE COMUNICACAO SERV REST DO GAR. CSFA892.",;
"/consulta-pedido" )
Endif
cEndpoint := GetMv( cMV_892_07, .F. )

cParam := "/status/cnpj/" + cCNPJ + "/" + cDtFormat

AAdd( aHeadStr, "Content-Type: application/json" )
AAdd( aHeadStr, "Accept: application/json" )

oRest := FWRest():New( cURL )
oRest:setPath( cEndpoint + cParam )
lGet := oRest:Get( aHeadStr )

If lGet
cGetResult := oRest:GetResult()
If cGetResult <> "[ ]" .OR. cGetResult <> "[]"
lDeserialize := FwJsonDeserialize( cGetResult, @oResult )
Endif
Endif

lGet := .T.
conout('getPostos1')
//If lGet .AND. cGetResult <> "[ ]" .AND. cGetResult <> "[]" .AND. lDeserialize
if lGet
If ValType( oResult ) == "A"
oObj := AClone( oResult )
Else
oObj := {}
AAdd( oObj, oResult )
Endif

// Tem as TAG <title>,<status>,<detail> então não conseguiu localizar os dados.
If Type("oObj[1]:title") <> "U" .AND. Type("oObj[1]:status") <> "U" .AND. Type("oObj[1]:detail") <> "U"
jSon := "[{"codigo": 210,"mensagem": ""+cValToChar(oObj[1]:title)+" "+cValToChar(oObj[1]:status)+" "+cValToChar(oObj[1]:detail)+"" }]"
Else
// Com o CNPJ informado pesquisar se o primeiro pedido é corresponentes ao CNPJ em questão.
// Se for prosseguir, do contrário devolver uma mensagem de crítica.
If .NOT. U_cnpjMatch( cCNPJ, cValToChar(oObj[1]:pedido), @aRet, @cReturn, cStack )
jSon := "[{"codigo": " + LTrim( Str( aRet[ 1 ] ) ) + ","mensagem": "" + aRet[ 2 ] +"" }]"

Else

oResp := jSonObject():New()
oResp := {}

aAdd(aTeste, {"11696165", "PRESENCIAL"})
aAdd(aTeste, {"11797904", "VIDEO CONFERENCIA"})
aAdd(aTeste, {"11798279", "RENOVACAO ON-LINE"})

//For i := 1 To Len( oObj )
For i := 1 To len(aTeste)
AAdd( oResp, jSonObject():New() )

cDataEvent := Iif(Type("oObj["+Str(i)+"]:dataRenovacao")=="U","",cValToChar(oObj[i]:dataEvento))
cHoraEvent := SubStr( cDataEvent, 12, 5 )
cDataEvent := StrTran( SubStr( cDataEvent, 1, 10 ), "-", "" )

cPedidoGAR := Iif(Type("oObj["+Str(i)+"]:pedido")=="U","",cValToChar(oObj[i]:pedido))
cStatus := Iif(Type("oObj["+Str(i)+"]:statusPedido")=="U","",cValToChar(oObj[i]:statusPedido)) //Aguardando Pagamento; Aguardando Validação; Aguardando Verificação; Aprovado; Rejeitado; Aguardando Autorização; Bloqueado; Excluído

// Tentar localizar o status do pedido e sua descrição.
p := AScan( aStatusPed, {|e| e[ 1 ] == cStatus } )
// Se achou, atribuir.
If p > 0
aStatus := { aStatusPed[ p, 1 ], aStatusPed[ p, 2 ] }
Else
// Se não achou, montar o vetor para futuras pesquisas e atribuir.
p := getStGAR( cStatus )
aStatus := { aStatusPed[ p, 1 ], aStatusPed[ p, 2 ] }
Endif

oResp[i]["numeroPedidoGAR"]    := aTeste[i][1]
oResp[i]["descricaoAcao"]      := aTeste[i][2]

//toConGAR( "trilhasDeAuditoria", cPedidoGAR, @aTrilha )
//oResp[i]["ultimoEventoTrilha"] := aTrilha[ 1 ] + "-" + Upper( U_RnNoAcento( aTrilha[ 2 ] ) )

aDadosZ5 := {}
aStatus := {}
aTrilha := {}
Next i
jSon := FWJsonSerialize( oResp )
//Endif
//Endif
Else
If .NOT. lGet
U_arConout("NAO CONSEGUI FAZER O GET NO GAR DOC[" + cCNPJ + "] DATA[" + cDtFormat + "] THREAD[" + cThread + "]")
U_arConout("GETLASTERRO: " + oRest:GetLastError() )
Endif
If cGetResult == "[ ]" .OR. cGetResult == "[]"
U_arConout("NAO CONSEGUI O GETRESULT NO GAR DOC[" + cCNPJ + "] DATA[" + cDtFormat + "] THREAD[" + cThread + "]")
U_arConout("GETLASTERRO: " + oRest:GetLastError() )
Endif
If ValType(lDeserialize) == "L" .AND. .NOT. lDeserialize
U_arConout("ERRO NO JSON ENTREGUE PELO GAR DOC[" + cCNPJ + "] DATA[" + cDtFormat + "] THREAD[" + cThread + "]")
U_arConout("GETRESULT: " + cGetResult )
Endif
Endif

If jSon == ""
U_arErro( 208, @aRet, @cReturn )
jSon := "[{'codigo': " + LTrim( Str( aRet[ 1 ] ) ) + ",'mensagem': '" + aRet[ 2 ] +"' }]"
Endif

Return( jSon )
*/



Static Function toConGAR( cService, cId, aDados )
	Local i := 0
	Local oDados

	aDados := {}
	aDados := Array( 2 )

	If oWsGAR == NIL
		oWsGAR := WSIntegracaoGARERPImplService():New()
	Endif

	If Upper( cService ) == "TRILHASDEAUDITORIA"
		oWsGAR:listarTrilhasDeAuditoriaParaIdPedido( "erp", "password123", Val( cId ) )
		oDados := oWsGAR:oWsAuditoriaInfo

		If ( oDados == NIL .AND. oDados[1]:nCpfUsuario == NIL )
			aDados[ 1 ] := "XXX"
			aDados[ 2 ] := "TRILHA NAO LOCALIZADA"
		Else
			// Pegar o último status da trilha de auditoria.
			i := Len( oDados )
			aDados[ 1 ] := cValToChar( oDados[i]:cAcao ) 
			aDados[ 2 ] := cValToChar( oDados[i]:cDescricaoAcao )
		Endif
	Endif
Return

static function enabledLog()
	If !GetMv( cLIGA_LOG, .T. )
		CriarSX6( cLIGA_LOG, "L", "LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW", ".F." )
	Endif
return GetMv( cLIGA_LOG, .F. )

static function logInicio( lLigaLog, aURLParms, nTimeIni, cStack, cEnvSrv )
	Local aParLog  := Array( 7 )

	default lLigaLog  := .F.
	default aURLParms := {}
	default nTimeIni  := Seconds() 
	default cStack    := ""
	default cEnvSrv   := ""
	If lLigaLog
		aParLog[ 1 ] := "CONSULTAR"
		aParLog[ 2 ] := "EVENTONODIA [input]"
		aParLog[ 3 ] := VarInfo( "::aURLParms", aURLParms, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := "PARAMETROS RECEBIDOS DO SISTEMA AENET."
		aParLog[ 5 ] := U_rnGetNow()
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := cValToChar( Seconds() - nTimeIni )

		// Antes de processar gerar log da requisição recebida.
		StartJob( "U_arPutLog", cEnvSrv, .F., aParLog, .T. )
	Endif
return

//Gera log de encerramento da rotina
static function logFim( lLigaLog, nTimeIni, aRet, cReturn, cStack, cEnvSrv )
	Local aParLog  := Array( 7 )

	default lLigaLog := .F.
	default nTimeIni := Seconds()
	default aRet     := {"",""}
	default cReturn  := ""
	default cStack   := ""
	default cEnvSrv  := "" 

	If lLigaLog
		aParLog[ 2 ] := "listaPostos [output]"
		aParLog[ 3 ] := cStack
		aParLog[ 4 ] := cValToChar( aRet[ 1 ] ) + " - " + cValToChar( aRet[ 2 ] ) + " - " + iif( Len( aRet ) > 2 , aRet[3] ,"" ) + " - " + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := cValToChar( Seconds() - nTimeIni )

		// Após processar gerar log da requisição entregue.
		StartJob( "U_arPutLog", cEnvSrv, .F., aParLog, .T. )
	Endif
return