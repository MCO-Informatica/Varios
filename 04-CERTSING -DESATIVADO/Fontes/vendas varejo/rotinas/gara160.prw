#INCLUDE "PROTHEUS.CH"

//+------------+---------------+------------------------------------------------------------------------+--------+------------------+---------+
//| Data       | Desenvolvedor | Descricao                                                              | Versao | OTRS             | JIRA    |
//+------------+---------------+------------------------------------------------------------------------+--------+------------------+---------+
//| 03/06/2020 | Bruno Nunes   | - Necessário a correção da rotina Gara160, que é responsável pela      | 1.00   |                  | PROT-24 |
//|            |               | geração forçado do link da nota de produto.                            |        |                  |         |
//|            |               | Hoje estamos com impacto no processo de envio de códigos de rastreio   |        |                  |         |
//|            |               | para os clientes devido á notas que não geraram esse link.             |        |                  |         |
//|            |               | -Outras rotinas envolvidas: U_NFDENG03, U_GARR010,U_GTPutRet           |        |                  |         |
//|            |               | U_NFDENG02, U_NFDENG01, U_GARR010,U_GTPutRet                           |        |                  |         |
//+------------+---------------+------------------------------------------------------------------------+--------+------------------+---------+
//| 06/08/2020 | Bruno Nunes   | - Ajuste no texto para facilitar a especifidade da rotina              | 1.01   |                  | PROT-160|
//|            |               | - Incluido log via email do processamento                              |        |                  |         |
//+------------+---------------+------------------------------------------------------------------------+--------+------------------+---------+

/*/{Protheus.doc} GARA160
Reprocessa geração do .pdf da NF de hardware
@type function 
@author Microsiga
@since 03/12/2010
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
User Function GARA160()
	Local cPerg		:= "GAR160"
	Local aSays		:= {}
	Local aButtons	:= {}
	Local aArea		:= GetArea()
	Local nOpcBat	:= 0
	Local oProcess  := nil

	Private cTexto	:= ""
	Private oDlgLog	:= nil
	Private oDlgAux	:= nil
	Private oMemo	:= nil

	Aadd( aSays, "Gera Espelho de Notas Fiscais em PDF e envia ao GAR" )
	Aadd( aSays, "" )
	Aadd( aSays, "Somente notas de série - 2 ou 3 serão consideradas" )
	Aadd( aSays, "" )
	Aadd( aSays, "Esta rotina tem o objetico de gerar os espelhos das notas fiscais que apresentaram" )
	Aadd( aSays, "falhas na transmissão ao SEFAZ e por este motivo não geraram espeslhos das notas." )
	Aadd( aSays, "Os espelhos serão gerados e recolocados no tunel de comunicação com o GAR." )
	Aadd( aSays, "Apenas as notas transmitidas serão reenviadas. Para forçar selecione os parâmetros." )

	AjustaSX1(cPerg)
	Pergunte(cPerg, .F. )

	Aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg, .T. )       } } )
	Aadd(aButtons, { 1,.T.,{|| nOpcBat	:= 1, FechaBatch() } } )
	Aadd(aButtons, { 2,.T.,{|| nOpcBat	:= 2, FechaBatch() } } )

	FormBatch( "Integração com o GAR", aSays, aButtons )

	If nOpcBat = 1
		oProcess := MsNewProcess():New( { |lEnd| GAR160Proc( @oProcess, @lEnd ) }, "Espelho GAR", "Lendo Registros para impressão", .F. )
		oProcess:Activate()
	EndIF

	RestArea(aArea)
Return(.T.)

/*/{Protheus.doc} GAR160Proc
Processamento da rotina
@type function 
@author Microsiga
@since 03/12/2010
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function GAR160Proc(oProcess,lEnd)
	Local cQuery	:= ""
	Local cGtId		:= cUserName
	Local nNumThrd	:= GetNewPar( "MV_XNTHRD", 20 )
	Local nTotSF2	:= 0
	Local nCount	:= 0

	Private	aRetEsp	:= {}

	If Mv_Par01 == 1
		If Empty( Mv_Par02 ) .AND. "Z" $ Upper( Mv_Par03 )
			MsgStop( "O parametro de forçar reenvio está ligado e os parâmetros são invalidos." )
			Return( .F. )
		Endif
	Endif

	If Mv_Par01 == 1
		cQuery	:=	" SELECT COUNT(*) TOTREC "
		cQuery	+=	" FROM " + RetSqlName( "SF2" ) + " SF2 "
		If !Empty( MV_PAR04 )
			cQuery	+=	" INNER JOIN " + RetSqlName( "SA1" ) + " SA1 ON "
			cQuery	+=	"    SF2.F2_FILIAL  = '" + xFilial( "SF2" ) + "' AND "
			cQuery	+=	"    SA1.A1_FILIAL  = '" + xFilial( "SA1" ) + "' AND "
			cQuery	+=	"    SF2.F2_CLIENTE = SA1.A1_COD AND "
			cQuery	+=	"    SF2.F2_LOJA    = SA1.A1_LOJA AND "
			cQuery	+=	"    SA1.A1_COD_MUN = '" + Alltrim(MV_PAR04) + "' "
			cQuery	+=	" WHERE "
		Else
			cQuery	+=	" WHERE    SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND "
		EndIf
		cQuery	+=	"          SF2.F2_SERIE = '" + GetNewPar( "MV_GARSHRD", "2  " ) + "' AND "
		cQuery	+=	"          SF2.F2_DOC BETWEEN '" + Mv_Par02 + "' AND '" + Mv_Par03 + "' AND "
		cQuery	+=	"          SF2.F2_FIMP IN ('T','S','N','D') AND "
		cQuery	+=	"          SF2.D_E_L_E_T_ = ' ' "
		PLSQuery( cQuery, "SF2TMP" )
		nTotSF2 := SF2TMP->TOTREC
		SF2TMP->( DbCloseArea() )
		If !MsgYesNo( "ATENÇÃO, serão processadas " + AllTrim( Str( nTotSF2 ) ) + " notas. Deseja continuar?" )
			Return( .F. )
		Endif

		cQuery	:=	" SELECT   SF2.R_E_C_N_O_ "
		cQuery	+=	" FROM     " + RetSqlName( "SF2" ) + " SF2 "
		If !Empty( MV_PAR04 )
			cQuery	+=	" INNER JOIN " + RetSqlName( "SA1" ) + " SA1  ON "
			cQuery	+=	"    SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND "
			cQuery	+=	"    SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND "
			cQuery	+=	"    SF2.F2_CLIENTE = SA1.A1_COD AND "
			cQuery	+=	"    SF2.F2_LOJA = SA1.A1_LOJA AND "
			cQuery	+=	"    SA1.A1_COD_MUN = '" + Alltrim( MV_PAR04 ) + "' "
			cQuery	+=	" WHERE "
		Else
			cQuery	+=	" WHERE    SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND "
		EndIf
		cQuery	+=	"          SF2.F2_SERIE = '" + GetNewPar( "MV_GARSHRD", "2  " ) + "' AND "
		cQuery	+=	"          SF2.F2_DOC BETWEEN '" + Mv_Par02 + "' AND '" + Mv_Par03 + "' AND "
		cQuery	+=	"          SF2.F2_FIMP IN ('T','S','N','D') AND "
		cQuery	+=	"          SF2.D_E_L_E_T_ = ' ' "
		cQuery	+=	" ORDER BY SF2.F2_DOC "
	Else
		cQuery	:=	" SELECT   COUNT(*) TOTREC "
		cQuery	+=	" FROM     " + RetSqlName( "SF2" ) + " SF2 "
		If !Empty(MV_PAR04)
			cQuery	+=	" INNER JOIN " + RetSqlName( "SA1" ) + " SA1  ON "
			cQuery	+=	"    SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND "
			cQuery	+=	"    SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND "
			cQuery	+=	"    SF2.F2_CLIENTE = SA1.A1_COD AND "
			cQuery	+=	"    SF2.F2_LOJA = SA1.A1_LOJA AND "
			cQuery	+=	"    SA1.A1_COD_MUN = '" + Alltrim( MV_PAR04 ) + "' "
			cQuery	+=	" WHERE "
		Else
			cQuery	+=	" WHERE    SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND "
		EndIf
		cQuery	+=	"          SF2.F2_SERIE = '" + GetNewPar( "MV_GARSHRD", "2  " ) + "' AND "
		cQuery	+=	"          SF2.F2_DOC BETWEEN '" + Mv_Par02 + "' AND '" + Mv_Par03 + "' AND "
		cQuery	+=	"          SF2.F2_FIMP IN ('T','N','D') AND "
		cQuery	+=	"          SF2.D_E_L_E_T_ = ' ' "
		PLSQuery( cQuery, "SF2TMP" )
		nTotSF2 := SF2TMP->TOTREC
		SF2TMP->( DbCloseArea() )
		If !MsgYesNo("ATENÇÃO, serão processadas " + AllTrim( Str( nTotSF2 ) ) + " notas. Deseja continuar?")
			Return(.F.)
		Endif

		cQuery	:=	" SELECT   SF2.R_E_C_N_O_ "
		cQuery	+=	" FROM     " + RetSqlName( "SF2" ) + " SF2 "
		If !Empty( MV_PAR04 )
			cQuery	+=	" INNER JOIN " + RetSqlName( "SA1" ) + " SA1  ON "
			cQuery	+=	"    SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND "
			cQuery	+=	"    SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND "
			cQuery	+=	"    SF2.F2_CLIENTE = SA1.A1_COD AND "
			cQuery	+=	"    SF2.F2_LOJA = SA1.A1_LOJA AND "
			cQuery	+=	"    SA1.A1_COD_MUN = '" + Alltrim( MV_PAR04 ) + "' "
			cQuery	+=	" WHERE "
		Else
			cQuery	+=	" WHERE    SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND "
		EndIf
		cQuery	+=	"          SF2.F2_SERIE = '" + GetNewPar( "MV_GARSHRD", "2  " ) + "' AND "
		cQuery	+=	"          SF2.F2_DOC BETWEEN '" + Mv_Par02 + "' AND '" + Mv_Par03 + "' AND "
		cQuery	+=	"          SF2.F2_FIMP IN ('T','N','D') AND "
		cQuery	+=	"          SF2.D_E_L_E_T_ = ' ' "
		cQuery	+=	" ORDER BY SF2.F2_DOC "
	Endif

	PLSQuery( cQuery, "SF2TMP" )

	If SF2TMP->( Eof() )
		MsgStop( "Nao existem notas a serem reenviadas." )
		SF2TMP->( DbCloseArea() )
		Return(.F.)
	Endif

	oProcess:SetRegua1( 1 )
	oProcess:SetRegua2( nTotSF2 )
	nThread := 0

	While SF2TMP->( !Eof() )
		If nThread <= nNumThrd
			nCount++
			oProcess:IncRegua1( "Imprimindo Notas" )
			oProcess:IncRegua2( "Analisando Nota " + AllTrim( Str( nCount ) ) + "/" + AllTrim( Str( nTotSF2 ) ) )

			//Executa JOB para gerar o .pdf da NF
			StartJob( "u_ImpPdfCe", GetEnvServer(), .F., cEmpAnt, cFilAnt, SF2TMP->R_E_C_N_O_, cGtId )
			//u_ImpPdfCe( cEmpAnt, cFilAnt, SF2TMP->R_E_C_N_O_, cGtId )

			aUsers := {}
			SF2TMP->( DbSkip() )
		Else
			Sleep(3000)
			nThread := nThread := nNumThrd / 2
		EndIf
	End
	SF2TMP->( DbCloseArea() )
Return

/*/{Protheus.doc} ImpPdfCe
Processamento da rotina
@type function 
@author Microsiga
@since 03/12/2010
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
User Function ImpPdfCe( cEmp, cFil, nRecno, cGtId )
	Local cType		:= ""
	Local cRandom   := ""
	Local aTmp  	:= {}	
	local oLog 	:= nil

	If !Empty( cEmp ) .and. !Empty( cFil )
		RpcSetType( 2 )
		RpcSetEnv( cEmp, cFil )
	EndIf

	SF2->( DbGoTo( nRecno ) )

	oLog := CSLog():New()
	oLog:SetAssunto( "GARA160 - Reenvio do espelho da Nota Fiscal de Hardware" )
	oLog:AddLog( "SF2: "+ SF2->F2_DOC )

	SC6->( DbSetOrder( 4 ) ) // C6_FILIAL+C6_NOTA+C6_SERIE
	if SC6->( MsSeek( xFilial( "SC6" ) + SF2->( F2_DOC + F2_SERIE ) ) )

		if SC6->C6_XOPER $ "52,62"
			cType := "F"
		elseif SC6->C6_XOPER == "53"
			cType := "E"
		endif

		oLog:AddLog( "SC6: " + SC6->C6_NUM )
		SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
		if SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )
			oLog:AddLog( "SC5: " + SC5->C5_NUM )
		
			If !empty(SF2->F2_ARET)
				// Se a nota ja foi transmitida com sucesso
				// reutiliza o codigo randomico desta nota
				// pega ele de dentro da sequencia gravada em F2_ARET
				// Observacao : a 4a. posicao somente vai ter o numero
				// randomico quando o codigo de retorno gravado dor 000135
				// senao esta posicao pode conter uma string qqer com msg e descrição
				aTmp := StrTokArr( SF2->F2_ARET, "," )
				If len( aTmp ) > 3 .and. aTmp[ 2 ] == "000135"
					cRandom := right( alltrim( aTmp[ 4 ] ), 10 ) // "NNNNNN.pdf"
					cRandom := left( cRandom, 6 ) 				 // "NNNNNN"
				Else
					cRandom := ""
				Endif
			Else
				cRandom := ""
			Endif

			oLog:AddLog( "Antes de Iniciar verificação de NFE Denegada" )	
			lDeneg 	:= u_NFDENG01()
			oLog:AddLog( "Apos verificação de NFE Denegada" )
			oLog:AddLog( "Nota Denegada? " + cValToChar( lDeneg ) )
			
			aRetEsp := {}			
			If lDeneg
				Aadd( aRetEsp, .T. )
				Aadd( aRetEsp, "000169" )
				Aadd( aRetEsp, SC5->C5_CHVBPAG )
				Aadd( aRetEsp, "Nfe Denegada processada" )

				U_NFDENG02()
				oLog:AddLog( "Antes de Iniciar impressão de NFE Denegada" )
				aRetEsp := U_NFDENG03( aRetEsp, @cRandom )
				oLog:AddLog( "Depois de finalizar impressão de NFE Denegada" )
				oLog:AddLog( {"Retorno da nota denegada: ", aRetEsp} )
			Else
				oLog:AddLog( "Antes de Iniciar impressão de espelho NFE" )
				aRetEsp := U_GARR010( {.T.} , @cRandom )
				oLog:AddLog( "Depois da impressão de espelho NFE" )
				oLog:AddLog( {"Retorno do GARR010: ",  aRetEsp} )
			EndIf

			If Len( aRetEsp ) > 0 .AND. aRetEsp[ 1 ]
				If aRetEsp[ 1 ]
					SF2->( DbGoTo( nRecno ) )
					SF2->( RecLock( "SF2", .F. ) )
					If lDeneg
						SF2->F2_FIMP := "D"
					Else
						SF2->F2_FIMP := "S"
					EndIf
					SF2->( MsUnLock() )
				EndIf

				// cGtId = Identificador de processo
				// Caso chamado do ERP, pode ser o nome do usuario do ERP
				// cType = "F" // para entrega futura
				// cType = "E" // para entrega efetiva
				If cType == "F"
					// Remonta a string de retorno para ser tratada adequadamente pelo engine de retencao
					cRetInfo := ",,,"
					cRetInfo += IIF( aRetEsp[ 1 ], "T", "F" ) + ","
					cRetInfo += aRetEsp[ 2 ] + ","
					cRetInfo += aRetEsp[ 4 ] + ","
					aRetEsp[4] := cRetInfo
				Endif
				U_GTPutRet( cGtId, cType, aRetEsp )
			Endif
		endif
	endif
	oLog:EnviarLog()
	DelClassIntf()
Return

/*/{Protheus.doc} AjustaSX1
Gera SX1 com perguntas para processamento da rotina
@type function 
@author Microsiga
@since 03/12/2010
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function AjustaSX1(cPerg)
	Local aRegs	:= {}

	Aadd( aRegs, {cPerg, "01", "Forcar reenvio"           ,	"", "", "MV_CH1", "C", 1, 0, 0, "C", "", "Mv_Par01", "Sim", "", "", "", "", "Nao", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "" , "", "", "", "" } )
	Aadd( aRegs, {cPerg, "02", "Numero da nota fiscal De" ,	"", "", "MV_CH2", "C", 9, 0, 0, "G", "", "Mv_Par02", ""   , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "" , "", "", "", "" } )
	Aadd( aRegs, {cPerg, "03", "Numero da nota fiscal Ate",	"", "", "MV_CH3", "C", 9, 0, 0, "G", "", "Mv_Par03", ""   , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "" , "", "", "", "" } )
	Aadd( aRegs, {cPerg, "04", "Cod. Municipio"           , "", "", "MV_CH4", "C", 9, 0, 0, "G", "", "Mv_Par04", ""   , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CC2", "N", "", "", "", "" } )

	If Len( aRegs ) > 0
		PlsVldPerg( aRegs )
	Endif
Return(.T.)