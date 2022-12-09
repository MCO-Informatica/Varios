#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "FATXJOB.ch"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"

#DEFINE cPERIODO "202104"
#DEFINE cARQUIVO "C:\temp\remuneracao_download.csv"
#DEFINE cPASTA_SERVER "\remuneracao\"+cPERIODO+"\"

 /*/{Protheus.doc} remCheck
Gera relatório com dados dos parceiros que possuem arquivo no ZZG mas não protheusdata.
@author Bruno Vilas Boas Nunes
@since 18/07/2021
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
user function remCheck()
	local cChaveZZG := ""
	local cLog := "Periodo;Entidade;Nome;Filho;Tipo;Versao;Ativo;Total;"+CRLF
	local cArqServer := ""
	
	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"	
	
	cChaveZZG := xFilial('ZZG') + cPERIODO

	if file( cARQUIVO )
		FErase( cARQUIVO )
	endif

	ZZG->( dbSetOrder( 1 ) )
	if ZZG->( dbSeek( cChaveZZG  ) )
		while !( ZZG->(EoF()) ) .and. ZZG->( ZZG_FILIAL + ZZG_PERIOD ) == cChaveZZG
			cArqServer := cPASTA_SERVER + ZZG->ZZG_NOMARQ
			if !file( cArqServer ) .and.  ZZG->ZZG_ATIVO == "1"
				cLog += ZZG->ZZG_PERIOD + ";"
				cLog += ZZG->ZZG_CODENT + ";"
				cLog += POSICIONE( "SZ3", 1, xFilial("SZ3") + ZZG->ZZG_CODENT, "Z3_DESENT") + ";"
				cLog += ZZG->ZZG_FILHO + ";"
				cLog += ZZG->ZZG_TIPO + ";"
				cLog += cValToChar( ZZG->ZZG_VERSAO ) + ";"
				cLog += ZZG->ZZG_ATIVO + ";"
				cLog += cValToChar( ZZG->ZZG_TOTAL ) + ";"
				cLog += CRLF
			endif
			ZZG->(Dbskip())
		end

		MemoWrite( cARQUIVO, cLog )
	endif
	
	RESET ENVIRONMENT	
return
