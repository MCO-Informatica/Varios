#INCLUDE "PROTHEUS.CH"

//+------------+---------------+------------------------------------------------------------------------+--------+------------------+---------+
//| Data       | Desenvolvedor | Descricao                                                              | Versao | OTRS             | JIRA    |
//+------------+---------------+------------------------------------------------------------------------+--------+------------------+---------+
//| 06/08/2020 | Bruno Nunes   | - Ajuste no texto para facilitar a especifidade da rotina              | 1.00   |                  | SIS-1364|
//|            |               | - Criado o parametro na SX6 MV_GARSFTW para controle da série da NF    |        |                  |         |
//|            |               | - Incluido log via email do processamento                              |        |                  |         |
//+------------+---------------+------------------------------------------------------------------------+--------+------------------+---------+

/*/{Protheus.doc} GARA170
Reprocessa geração do .pdf da NF de servico
@type function 
@author Microsiga
@since 03/12/2010
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
User Function GARA170()
	Local cPerg		:= "GAR170"
	Local aSays		:= {}
	Local aButtons	:= {}
	Local lEnd		:= .T.
	Local oProcess

	Aadd( aSays, "Gera Espelho de Notas Fiscais em PDF e envia ao GAR" )
	Aadd( aSays, "" )
	Aadd( aSays, "Somente notas de série - RP2 serão consideradas" )
	Aadd( aSays, "" )
	Aadd( aSays, "Esta rotina tem o objetico de gerar os espelhos das notas fiscais que apresentaram" )
	Aadd( aSays, "falhas na transmissão ao SEFAZ e por este motivo não geraram espeslhos das notas." )
	Aadd( aSays, "Os espelhos serviço gerados e recolocados no tunel de comunicação com o GAR." )
	Aadd( aSays, "Apenas as notas transmitidas serviço reenviadas. Para forçar selecione os parãmetros." )

	AjustaSX1(cPerg)
	Pergunte(cPerg, .F. )

	Aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg, .T. ) } } )
	Aadd(aButtons, { 1,.T.,{|| oProcess := MsNewProcess():New({|lEnd| GAR170Proc(@oProcess,@lEnd)}, "Espelho GAR", "Lendo Registros para impressão",.F.),;
	oProcess:Activate(),;
	FechaBatch() }} )
	Aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( "Espelho GAR", aSays, aButtons )

Return(.T.)

/*/{Protheus.doc} GAR170Proc
Processamento geração do .pdf da NF de servico
@type function 
@author Microsiga
@since 03/12/2010
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function GAR170Proc(oProcess,lEnd)
	Local cQuery	:= ""
	Local cGtId		:= cUserName
	Local nNumThrd	:= GetNewPar("MV_XNTHRD" ,20)
	Local nThread 	:= 0
	Local nCount	:= 0
	local cSerie    := GetNewPar("MV_GARSFTW","RP2")

	If Mv_Par01 <> 1
		MsgStop("Rotina desenvolvida apenas na opção de forçar reenvio...")
		Return(.F.)
	Endif

	If Mv_Par01 == 1 .AND. Empty(Mv_Par02)
		MsgStop("O parametro de forçar reenvio está ligado e não foi informado o número da nota a ser reenviada, o processo não será executado.")
		Return(.F.)
	Endif

	If Mv_Par01 == 1
		cQuery	:=	" SELECT COUNT(*) TOTREC "
		cQuery	+=	" FROM   " + RetSqlName("SF2") + " SF2 "
		If !Empty(MV_PAR04)
			cQuery	+=	" INNER JOIN " + RetSqlName("SA1") + " SA1  ON "
			cQuery	+=	"    SF2.F2_FILIAL  = '" + xFilial("SF2") + "' AND "
			cQuery	+=	"    SF2.F2_SERIE   = '" + cSerie + "' AND "
			cQuery	+=	"    SF2.F2_DOC BETWEEN '" + Mv_Par02 + "' AND '" + Mv_Par03 + "' AND "
			cQuery	+=	"    SF2.D_E_L_E_T_ = ' ' AND "
			cQuery	+=	"    SA1.A1_FILIAL  = '" + xFilial("SA1") + "' AND "
			cQuery	+=	"    SF2.F2_CLIENTE = SA1.A1_COD AND "
			cQuery	+=	"    SF2.F2_LOJA    = SA1.A1_LOJA AND "
			cQuery	+=	"    SA1.A1_COD_MUN = '" + Alltrim(MV_PAR04) + "' "
		Else
			cQuery	+=	" WHERE    SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND "
			cQuery	+=	"    SF2.F2_SERIE        = '" + cSerie + "' AND "
			cQuery	+=	"    SF2.F2_DOC BETWEEN '" + Mv_Par02 + "' AND '" + Mv_Par03 + "' AND "
			cQuery	+=	"    SF2.D_E_L_E_T_ = ' ' "

		EndIf

		PLSQuery( cQuery, "SF2TMP" )
		nTotSF2 := SF2TMP->TOTREC
		SF2TMP->( DbCloseArea() )
		If !MsgYesNo("ATENÇÃO, serão processadas "+AllTrim(Str(nTotSF2))+" notas. Deseja continuar?")
			Return(.F.)
		Endif

		cQuery	:=	" SELECT SF2.R_E_C_N_O_ "
		cQuery	+=	" FROM   " + RetSqlName("SF2") + " SF2 "
		If !Empty(MV_PAR04)
			cQuery	+=	" INNER JOIN " + RetSqlName("SA1") + " SA1  ON "
			cQuery	+=	"    SF2.F2_FILIAL  = '" + xFilial("SF2") + "' AND "
			cQuery	+=	"    SF2.F2_SERIE   = '" + cSerie + "' AND "
			cQuery	+=	"    SF2.F2_DOC BETWEEN '" + Mv_Par02 + "' AND '" + Mv_Par03 + "' AND "
			cQuery	+=	"    SF2.D_E_L_E_T_ = ' ' AND "
			cQuery	+=	"    SA1.A1_FILIAL  = '" + xFilial("SA1") + "' AND "
			cQuery	+=	"    SF2.F2_CLIENTE = SA1.A1_COD AND "
			cQuery	+=	"    SF2.F2_LOJA    = SA1.A1_LOJA AND "
			cQuery	+=	"    SA1.A1_COD_MUN = '" + Alltrim(MV_PAR04) + "' "
		Else
			cQuery	+=	" WHERE    SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND "
			cQuery	+=	"    SF2.F2_SERIE        = '" + cSerie + "' AND "
			cQuery	+=	"    SF2.F2_DOC BETWEEN '" + Mv_Par02 + "' AND '" + Mv_Par03 + "' AND "
			cQuery	+=	"    SF2.D_E_L_E_T_ = ' ' "
		EndIf
	Else
		MsgAlert("Somente opção 'Forçar=1-Sim' esta sendo tratada neste momento")
		Return(.F.)
	Endif

	PLSQuery( cQuery, "SF2TMP" )

	If SF2TMP->( Eof() )
		MsgStop("Nao existem notas a serem reenviadas.")
		SF2TMP->( DbCloseArea() )
		Return(.F.)
	Endif
	oProcess:SetRegua1(1)
	oProcess:SetRegua2(nTotSF2)
	nThread := 0

	While SF2TMP->( !Eof() )

		If nThread <= nNumThrd
			nCount++
			oProcess:IncRegua1("Imprimindo Notas")
			oProcess:IncRegua2("Analisando Nota "+AllTrim(Str(nCount))+"/"+AllTrim(Str(nTotSF2)))

			//Executa JOB para gerar o .pdf da NF
			StartJob("u_ImpNFSCe",GetEnvServer(),.F.,cEmpAnt,cFilAnt,SF2TMP->R_E_C_N_O_,cGtId)
			//u_ImpNFSCe( cEmpAnt, cFilAnt, SF2TMP->R_E_C_N_O_, cGtId )

			nThread++

			SF2TMP->( DbSkip() )

		Else
			//aUsers 	:= Getuserinfoarray()
			Sleep(3000)
			nThread := nNumThrd/2
			//aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_ImpNFSCe" ,nThread++,nil )  })
		EndIf
	EndDo


	SF2TMP->( DbCloseArea() )

Return(.T.)

/*/{Protheus.doc} GAR170Proc
Processamento geração do .pdf da NF de servico
@type function 
@author Microsiga
@since 03/12/2010
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
User Function ImpNFSCe(cEmp,cFil,nRecno,cGtId)
	Local cType	:= ""
	local oLog 	:= nil

	If !Empty(cEmp) .and. !Empty(cFil)
		RpcSetType(2)
		RpcSetEnv(cEmp,cFil)
	EndIf

	SF2->( DbGoTo( nRecno) )
	
	oLog := CSLog():New()
	oLog:SetAssunto( "GARA170 - Reenvio do espelho da Nota Fiscal de Serviço" )
	oLog:AddLog( "SF2: "+ SF2->F2_DOC )

	SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
	if SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
		
		if SC6->C6_XOPER $ "51,61"
			cType := "S"
		endif

		oLog:AddLog( "SC6: " + SC6->C6_NUM )
		SC5->( dbSetOrder(1) )		// C5_FILIAL+C5_NUM
		if SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )
			
			oLog:AddLog( "SC5: " + SC5->C5_NUM )
			
			// Gera o arquivo espelho da nota fiscal
			aRetEsp := U_GARR020( {.T.}, .T. )

			oLog:AddLog( {"Retorno do GARR020: ", aRetEsp} )
			If Len(aRetEsp) > 0 .AND. aRetEsp[1]
				//+---------------------------------------------------------------+
				//| cGtId = Identificador de processo                             |
				//| Caso chamado do ERP, pode ser o nome do usuario do ERP        |
				//| cType = "F" // para entrega futura                            |
				//| cType = "E" // para entrega efetiva                           |
				//| cType = "S" // SERVIÇO                                        |
				//+---------------------------------------------------------------+

				cRetInfo := IIF(aRetEsp[1],"T","F")+","
				cRetInfo += aRetEsp[2]+","
				cRetInfo += aRetEsp[4]+","
				aRetEsp[4] := cRetInfo

				U_GTPutRet(cGtId,cType,aRetEsp)
			Endif
		endif
	endif
	
	oLog:EnviarLog()

	DelClassIntf()
Return

/*/{Protheus.doc} AjustaSX1
Rotina que cria parametros de pergunta na SX1 - Não funciona mais na P12
@type function 
@author Microsiga
@since 03/12/2010
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function AjustaSX1(cPerg)

	Local aRegs	:=	{}

	Aadd(aRegs,{cPerg,"01","Forcar reenvio",		"","","MV_CH1","C",1,0,0,"C","","Mv_Par01","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"02","Numero da nota fiscal",	"","","MV_CH2","C",9,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"03","Numero da nota fiscal Ate",	"","","MV_CH3","C",9,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"04","Cod. Municipio"           , "","","MV_CH4","C",9,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","CC2","N","","","",""})

	If Len(aRegs) > 0
		PlsVldPerg( aRegs )
	Endif

Return(.T.)
