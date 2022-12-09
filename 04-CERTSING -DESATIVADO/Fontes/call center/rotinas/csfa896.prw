//+------------+---------------+----------------------------------------------------------------------------------+--------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao |
//+------------+---------------+----------------------------------------------------------------------------------+--------+
//| 15/04/2020 | Bruno Nunes   | Desenvolvido essa rotina que tem como objetivo retornar pedidos com o ceritficado| 1.00   |
//|            |               | para expirar em ate 90. Essa busca deve ser por AR.                              |	       |
//+------------+---------------+----------------------------------------------------------------------------------+--------+

// **************************************************************************
// ****                                                                  ****
// ****                 Serviços Protheus Webservice REST                ****
// ****                                                                  ****
// **************************************************************************
#include "protheus.ch"
#include "parmtype.ch"
#include "restful.ch"
#include "tbiconn.ch"

#define cLIGA_LOG   	"MV_890_02" //Habilita gravacao de log
#define nQTD_PARAMETRO  4

//*********************************************************
//*** SERVIÇOS PROTHEUS WEBSERVICE REST PARA CONSULTAR  *** 
//***                                                   ***  
//*********************************************************

WSRESTFUL ativoRenovacao DESCRIPTION "Consultar pedidos elegíveis para renovação"
WSDATA token   AS STRING OPTIONAL
WSDATA cnpj	   AS STRING OPTIONAL
WSDATA dtBase  AS STRING OPTIONAL
WSDATA codAr   AS STRING OPTIONAL

WSMETHOD GET DESCRIPTION "Consultar pedidos elegíveis para renovação" WSSYNTAX "/ativoRenovacao/{token/cnpj/data/codAr}"
END WSRESTFUL

WSMETHOD GET WSRECEIVE token, cnpj, dtBase, codAr WSSERVICE ativoRenovacao
	Local aRet     := {"",""}
	Local cStack   := "Pilha de chamada: ativoRenovacao()" + CRLF
	Local cData    := ""
	Local cCodAr   := ""
	Local cEnvSrv  := GetEnvServer()	
	Local cReturn  := ""
	Local cThread  := "Thread: " + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()

	default ::token   := "x"
	default ::cnpj 	  := "x"
	default ::dtBase  := "x"
	default ::codAr   := "x"

	//Habilita log 
	lLigaLog := enabledLog( )

	//Gera log abertura da rotina
	logInicio( lLigaLog, ::aURLParms, nTimeIni, cStack, cEnvSrv )

	// Define o tipo de retorno do método
	::SetContentType("application/json")

	//Valida autenticacaos
	If U_validAut( ::aURLParms, @cReturn, @aRet, @cStack, cThread, nQTD_PARAMETRO )
		cData := ::aURLParms[3] // Data recebida no formato AAAAMMDD
		cCodAr  := ::aURLParms[4] //cCodAr

		//Busca eventos no GAR
		cReturn := getEvento( cCodAr, cData, @aRet, @cStack, @cThread )

		::SetResponse( cReturn )
	Else
		// Autenticação mal sucedida.
		::SetResponse( "{'codigo': " + LTrim( Str( aRet[ 1 ] ) ) + ",'mensagem': '" + aRet[ 2 ] +"' }" )
	Endif

	//Gera log de encerramento da rotina
	logFim( lLigaLog, nTimeIni, aRet, cReturn, cStack, cEnvSrv )

	DelClassIntf()
Return(.T.)

Static Function getEvento( cCodAr, cData, aRet, cStack, cThread )
	Local cMV_896_01 := "MV_896_01"
	Local cReturn := ""
	Local jSon := ""
	Local nOPC := 0

	If .NOT. GetMv( cMV_896_01, .T. )
		CriarSX6( cMV_896_01, "N", "CONSULTAR DIRETO NO 1=GAR-REST OU POR MEIO DO PROTHEUS COMO CONTINGÊNCIA.","1" )
	Endif
	nOPC := GetMv( cMV_896_01, .F. )

	cStack += "GETEVENTO() - OPCAO (MV_896_01) = " + LTrim( Str( nOPC ) ) + CRLF
	conout('getEvento')
	If nOPC == 1
		jSon := getEvent2( cCodAr, cData, @aRet, @cStack, @cThread )
	Elseif nOPC == 2
		//jSon := getEvent2( cCNPJ, cData, @aRet, @cStack, @cThread )
		jSon := getEvent2( cCodAr, cData, @aRet, @cStack, @cThread )
	Else
		U_arErro( 209, @aRet, @cReturn )
		jSon := "[{'codigo': " + LTrim( Str( aRet[ 1 ] ) ) + ",'mensagem': '" + aRet[ 2 ] +"' }]"
	Endif 
Return( jSon )

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
conout('getEvento1')
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

Static Function getEvent2( cCodAr, cData, aRet, cStack, cThread )
	Local aAtivoReno := {}
	Local cReturn := ""
	Local dBuscaIni := stod( cData ) 
	Local i 		:= 0
	Local jSon 		:= ""
	Local oResp

	cStack += "GETEVENTO2()" + CRLF

	conout("pegando dados SZ5")
	aAtivoReno := buscaSZ5( cCodAr, dBuscaIni )

	conout("passou getEvent2")
	If len( aAtivoReno ) == 0
		U_arErro( 207, @aRet, @cReturn )
		jSon := "[{'codigo': " + LTrim( Str( aRet[ 1 ] ) ) + ",'mensagem': '" + aRet[ 2 ] +"' }]"
	Else
		oResp := jSonObject():New()
		oResp := {}
		conout("indo para estrutura de repeticao")
		for i := 1 to len( aAtivoReno )
			//toConGAR( "trilhasDeAuditoria", aAtivoReno[i][1], @aAtivoReno )

			aAdd( oResp, jSonObject():New() )

			oResp[i]["numeroPedidoGAR"] := aAtivoReno[i][1]
			oResp[i]["descricaoAcao"]   := aAtivoReno[i][2]
			oResp[i]["dataExpiraao"]    := aAtivoReno[i][3]

		next i
		jSon := FWJsonSerialize( oResp )
	Endif

	If jSon == ""
		U_arErro( 208, @aRet, @cReturn )
		jSon := "[{'codigo': " + LTrim( Str( aRet[ 1 ] ) ) + ",'mensagem': '" + aRet[ 2 ] +"' }]"
	Endif

Return( jSon )

STATIC oWsGAR := NIL

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

/*
Static Function seekSZ5( cPedidoGAR )
Local aDADOS := {}
Local cSQL := ""
Local cTRB := "SEEKSZ5"
Local i := 0
Local nFCount := 0

If lPostgres
Return( { "PRODGAR","TIPO","TIPODES","EMISSAO","DATVAL","DATVER","DATEMIS"} )
Endif

cSQL += "SELECT Z5_PRODGAR, "
cSQL += "       Z5_TIPO, "
cSQL += "       Z5_TIPODES, "
cSQL += "       Z5_EMISSAO, "
cSQL += "       Z5_DATVAL, "
cSQL += "       Z5_DATVER, "
cSQL += "       Z5_DATEMIS "
cSQL += "FROM   " + RetSqlName("SZ5") + " SZ5 "
cSQL += "WHERE  Z5_FILIAL = ' ' "
cSQL += "       AND Z5_PEDGAR = " + ValToSql( cPedidoGAR ) + " "
cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' "
cSQL += "ORDER  BY R_E_C_N_O_ "

cSQL := ChangeQuery( cSQL )
cTRB := GetNextAlias()
dbUseArea( .T., "TOPCONN", TCGENQRY(,, cSQL ), cTRB, .F., .T. )

nFCount := (cTRB)->( FCount() )
aDADOS := Array( nFCount )
aFill( aDADOS, "" )

While (cTRB)->( .NOT. EOF() )
For i := 1 To nFCount
aDADOS[ i ] := (cTRB)->( FieldGet( i ) )
Next i
(cTRB)->( dbSkip() )
End

(cTRB)->( dbCloseArea() )
Return( aDADOS )
*/
/*
Static Function getStGAR( cStatus )
Local aStatusGAR := {}
Local cFile := "statusgar.ini"
Local cLine := ""
Local nHdl := 0
Local nRet := 0
Local p := 0

If File( cFile )
FT_FUSE( cFile )
FT_FGOTOP()
While .NOT. FT_FEOF()
cLine := FT_FREADLN()
p := At( "#", cLine )
AAdd( aStatusPed, { SubStr( cLine, 1, p-1 ), Upper( U_RnNoAcento( SubStr( cLine, p+1 ) ) )} )
If SubStr( cLine, 1, p-1 ) == cStatus
nRet := Len( aStatusPed )
Endif
FT_FSKIP()
End
FT_FUSE()

If nRet == 0
AAdd( aStatusPed, { "XXX", "STATUS NAO LOCALIZADO" } )
nRet := Len( aStatusPed )
Endif
Else
AAdd( aStatusGAR, { "ADB", "DADOS BIOMETRICOS AUSENTES" } )
AAdd( aStatusGAR, { "AFC", "ANALISE DE SEGURANCA CONCLUIDA - FRAUDE" } )
AAdd( aStatusGAR, { "AFI", "ANALISE DE SEGURANCA INICIADA - FRAUDE" } )
AAdd( aStatusGAR, { "AFP", "ANALISE DE SEGURANCA PARCIAL - FRAUDE" } )
AAdd( aStatusGAR, { "ATV", "ATIVACAO" } )
AAdd( aStatusGAR, { "AUT", "REGISTRO DE AUTORIZACAO" } )
AAdd( aStatusGAR, { "BLQ", "BLOQUEIO DE PEDIDO - FRAUDE" } )
AAdd( aStatusGAR, { "CEA", "CLIQUE BOTAO ANALISE" } )
AAdd( aStatusGAR, { "CIR", "CONSULTA ITI REALIZADA" } )
AAdd( aStatusGAR, { "CSA", "CONSULTA OAB" } )
AAdd( aStatusGAR, { "DBL", "DESBLOQUEAR" } )
AAdd( aStatusGAR, { "DBQ", "DESBLOQUEIO DE PEDIDO - FRAUDE" } )
AAdd( aStatusGAR, { "DEL", "DELETE" } )
AAdd( aStatusGAR, { "DTV", "DESATIVACAO" } )
AAdd( aStatusGAR, { "ECB", "CERTIBIO INDISPONIVEL" } )
AAdd( aStatusGAR, { "EMI", "EMISSAO" } )
AAdd( aStatusGAR, { "ERP", "EDITAR REPRESENTANTES" } )
AAdd( aStatusGAR, { "EXT", "EXIBIR TERMO" } )
AAdd( aStatusGAR, { "IAT", "INICIAR ATENDIMENTO" } )
AAdd( aStatusGAR, { "INS", "INSCRICAO" } )
AAdd( aStatusGAR, { "IPV", "LIBERAR VALIDACAO" } )
AAdd( aStatusGAR, { "LOG", "ACESSAR" } )
AAdd( aStatusGAR, { "OBS", "OBSERVACAO" } )
AAdd( aStatusGAR, { "PAT", "INTERROMPER ATENDIMENTO" } )
AAdd( aStatusGAR, { "RCI", "REGISTRAR COMO INTEGRADO" } )
AAdd( aStatusGAR, { "REM", "APROVAR" } )
AAdd( aStatusGAR, { "REP", "ENVIO PAGAMENTO" } )
AAdd( aStatusGAR, { "RJT", "REJEITAR PEDIDO" } )
AAdd( aStatusGAR, { "RPG", "REGISTRO PAGAMENTO" } )
AAdd( aStatusGAR, { "RRG", "VALIDAR" } )
AAdd( aStatusGAR, { "RRN", "PEDIDO DE RENOVACAO" } )
AAdd( aStatusGAR, { "RRV", "REVOGACAO" } )
AAdd( aStatusGAR, { "RVD", "REVALIDAR PEDIDO" } )
AAdd( aStatusGAR, { "TRS", "ALTERAR SENHA" } )
AAdd( aStatusGAR, { "UPD", "ALTERACAO CADASTRO" } )
AAdd( aStatusGAR, { "WBL", "BLOQUEADO WORKFLOW" } )
AAdd( aStatusGAR, { "WLA", "ACESSO A VERIFICACAO WORKFLOW" } )
AAdd( aStatusGAR, { "WLV", "ACESSO A VALIDACAO WORKFLOW" } )

nHdl := FCreate( cFile )
For p := 1 To Len( aStatusGAR )
If cStatus == aStatusGAR[ p, 1 ]
nRet := p
Endif
AAdd( aStatusPed, { aStatusGAR[ p, 1 ], aStatusGAR[ p, 2 ] } )
FWrite( nHdl, aStatusGAR[ p, 1 ] + "#" + aStatusGAR[ p, 2 ] + CRLF )
Next p
FClose( nHdl )
If nRet == 0 
AAdd( aStatusPed, { "XXX", "STATUS NAO LOCALIZADO" } )
Endif
Endif
Return( nRet )
*/

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
		aParLog[ 2 ] := "ativorenovacao [output]"
		aParLog[ 3 ] := cStack
		aParLog[ 4 ] := cValToChar( aRet[ 1 ] ) + " - " + cValToChar( aRet[ 2 ] ) + " - " + iif( Len( aRet ) > 2 , aRet[3] ,"" ) + " - " + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := cValToChar( Seconds() - nTimeIni )

		// Após processar gerar log da requisição entregue.
		StartJob( "U_arPutLog", cEnvSrv, .F., aParLog, .T. )
	Endif
return

static function buscaSZ5( cCodAr, dBuscaIni )
	local aAtivoReno  := {}
	local aAux := {}
	local cQuery 	  := ""
	local cAlias 	  := getNextAlias()
	local dBuscaFim   := ctod("//")

	default cCodAr 	  := ""
	default dBuscaIni := ctod("//")

	if !empty( cCodAr ) .and. !empty( dBuscaIni )
		dBuscaFim := dBuscaIni + 90

		cQuery := " SELECT " 
		cQuery += " 	SZ5.Z5_FILIAL, "
		cQuery += " 	SZ5.Z5_VLDCERT, "
		cQuery += " 	SZ5.Z5_PEDGAR, "
		cQuery += " 	SZ5.Z5_CODAR "
		cQuery += " FROM  "
		cQuery += " 	" + RetSqlName("SZ5") + " SZ5 "
		cQuery += " WHERE "
		cQuery += " 	SZ5.D_E_L_E_T_    = ' ' "
		cQuery += " 	AND SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' "
		cQuery += " 	AND SZ5.Z5_CODAR   = '" + cCodAr + "' "
		cQuery += " 	AND SZ5.Z5_VLDCERT BETWEEN '" + dtos( dBuscaIni ) + "' AND '" + dtos( dBuscaFim ) + "' "		
		cQuery += " ORDER BY "
		cQuery += " 	SZ5.Z5_FILIAL,  "
		cQuery += " 	SZ5.Z5_VLDCERT, "
		cQuery += " 	SZ5.Z5_PEDGAR   "

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAlias, .F., .T.)
		if select( cAlias ) > 0
			while ( cAlias )->( !EoF() )
				aAux := {}
				aAdd( aAux, ( cAlias )->Z5_PEDGAR )
				aAdd( aAux, "" )
				aAdd( aAux, dtoc( stod( ( cAlias )->Z5_VLDCERT ) ))
				aAdd( aAtivoReno, aAux )
				( cAlias )->( dbSkip() )
			end
			( cAlias )->(dbCloseArea())
		endif
	endif
return aAtivoReno