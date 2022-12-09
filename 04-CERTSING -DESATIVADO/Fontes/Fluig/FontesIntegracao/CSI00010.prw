#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TbiConn.ch"

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE	4

user function CSI00010( nTipoRequi, filial, matricula, periodo  )
	local cRetorno := ""
	default nTipoRequi := 0
	if nTipoRequi == nTIPO_REQUISICAO_POST
		//cRetorno := CSIPost(nTIPO_REQUISICAO_POST, filial, matricula, dIni, dFim, hIni, hFim, abono )
	elseif nTipoRequi == nTIPO_REQUISICAO_GET
		cRetorno := CSIGet(nTIPO_REQUISICAO_GET, url, trigger )
	endif
return cRetorno

static function CSIPost(nTipoRequi, url, trigger, body  )
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
	Default url 	   := ""
	Default trigger  := ""
	Default body  := ""

	/*
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
		CONOUT("# CSI00010: Filial: "+filial+" Matricula: "+matricula+" Incluindo solicitacao ferias. Data e hora Fim: "+dToC(dDataBase)+" - "+Time() )
	endif
	*/
Return(cRetorno)