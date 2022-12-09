#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TbiConn.ch"

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE	4

user function CSI00009( nTipoRequi, filial, matricula, periodo  )
	local cRetorno := ""
	default nTipoRequi := 0
	if nTipoRequi == nTIPO_REQUISICAO_POST
		//cRetorno := CSIPost(nTIPO_REQUISICAO_POST, filial, matricula, dIni, dFim, hIni, hFim, abono )
	elseif nTipoRequi == nTIPO_REQUISICAO_GET
		cRetorno := CSIGet(nTIPO_REQUISICAO_GET, filial, matricula, periodo )
	endif
return cRetorno

static function CSIGet( nTipoRequi, filial, matricula, periodo )
	local aLista 	 := {}
	local aAux 		 := {}
	local aFunc		 := {}
	local aProp      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local i := 0
	local cBase64 := ""
	local cCaminho := "" 
	local cFile := ""
	local aFile := {}
	local lPortal := .T.
	local aFalhas := {}
	local lTerminal := .F.
	local aRetPortal := {}
	local aFunProc := {}
	local cHTML := {}
	local aCertFlow := {}
	local aWS := {}
	local nTot := 0
	local nHandle := 0

	default nTipoRequi 	:= nTIPO_REQUISICAO_GET
	default filial  	:= ""
	default matricula 	:= ""
	default periodo		:= ""
	
	CONOUT("# CSI00009: Gerando espelho de ponto	. Data e hora Inicio: "+DtoC(dDataBase)+" - "+Time() )
	cHTML := u_GeraEspe( lTerminal , filial 	  , matricula    , periodo   , lPortal, @aRetPortal, @aFalhas, @aFunProc, @aCertFlow, @aWS )

	if len( aFalhas ) > 0
		varinfo( "aFalhas", aFalhas )
		return
	endif

	if len(aWS) > 0


		nHandle := fOpen( aWS[1][3] + aWS[1][4], 0 )
		if nHandle == -1
			//Caso de erro ao criar arquivo texto
			fCLose(nHandle)
			conout("Erro ao abrir arquivo")
		EndIf

		//Posiciona na ultima linha do arquivo texto
		nTot := fSeek(nHandle, 0, FS_END)
		FSEEK(nHandle, 0)


		

		cFile := FReadStr( nHandle, nTot )
		fCLose(nHandle)
		cBase64 := Encode64(cFile,,.F.,.F.)

		aAdd( aFunc, { aWS[1][1], aWS[1][2], aWS[1][4], cBase64  })
		
	endif
	aAdd( aProp, 'filial' 		 ) //1
	aAdd( aProp, 'matricula'   	 ) //2
	aAdd( aProp, 'nomeArquivo'   ) //3
	aAdd( aProp, 'base64' 		 ) //4

	U_json( @cRetorno, aFunc, aProp, 'espelhoPonto' )
	
	CONOUT("# CSI00009: Gerando espelho de ponto. Data e hora Fim: "+DtoC(dDataBase)+" - "+Time() )
return cRetorno

/*
static function CSIPost(nTipoRequi, filial, matricula, dBaseFer, dIniGozo, dFimGozo, cAbonoPec, c13ParAnt )
local aAux 		 := {}
local aProp      := {}
local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
local cQuery  	 := "" 	//Query SQL
local cRetorno 	 := ""
local lExeChange := .F. //Executa o change Query
local lTotaliza  := .F.
local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
local lCriaDir   := .T.
local lApaga     := .T.

Default nTipoRequi := nTIPO_REQUISICAO_POST
Default filial 	   := ""
Default matricula  := ""
Default dBaseFer   := ctod("//")
Default dIniGozo   := ctod("//")
Default dFimGozo   := ctod("//")
Default cAbonoPec  := ""
Default c13ParAnt  := ""

if 	!Empty( filial ) .And. ;
!Empty( matricula ) .And. ;
!Empty( dBaseFer ) .And. ;
!Empty( dIniGozo ) .And. ;
!Empty( dIniGozo )  .And. ;
!Empty( cAbonoPec )  .And. ;
!Empty( c13ParAnt )  
cTexto := "filial: "+filial+"; "
cTexto += "matricula: "+matricula+"; "
cTexto += "dBaseFer: "+dtos(dBaseFer)+"; "
cTexto += "dIniGozo: "+dtos(dIniGozo)+"; "
cTexto += "dFimGozo: "+dtos(dFimGozo)+"; "
cTexto += "cAbonoPec: "+cAbonoPec+"; "
cTexto += "c13ParAnt: "+c13ParAnt+"; "

u_GerarArq(cTexto, "\fluig\solicitacao_ferias\"+filial+matricula+dtos(dBaseFer)+".txt", lCriaDir, lApaga)

aAdd( aProp, 'filial')
aAdd( aProp, 'matricula')
aAdd( aProp, 'dBaseFerias')
aAdd( aProp, 'dFim')
aAdd( aProp, 'dIniGozo')
aAdd( aProp, 'dFimGozo')
aAdd( aProp, 'abonoPecuniario')
aAdd( aProp, 'primeiraParcela13')

aAdd( aAux, filial )
aAdd( aAux, matricula    )
aAdd( aAux, dBaseFer )
aAdd( aAux, dIniGozo )
aAdd( aAux, dFimGozo )
aAdd( aAux, cAbonoPec )
aAdd( aAux, c13ParAnt )
aAdd( aAux, "ok" )

U_json( @cRetorno, aAux, aProp, 'solicitacaoFerias' )
CONOUT("# CSI00009: Filial: "+filial+" Matricula: "+matricula+" Incluindo solicitacao ferias. Data e hora Fim: "+dToC(dDataBase)+" - "+Time() )
endif
Return(cRetorno)
*/