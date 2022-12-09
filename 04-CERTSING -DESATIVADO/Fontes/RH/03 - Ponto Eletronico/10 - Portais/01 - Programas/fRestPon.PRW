#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*+--------------------------------------------------------------------------------------------------------+-------------------+
| Funcao.: fRestPon() | Restaurar periodos do ponto, encerrados por acidente.                            | Data.: 06.06.2016 |
+------------------------------------+-------------------------------------------------------------------+-------------------+
| Autor.: Alexandre A. Silva - OPVS  | Objetivo.: Realizar leitura das tabelas de acumulados do ponto, carregando as tabelas |
|                                    |            do movimento. Em seguida, os dados lidos e carregados nas tabelas do movi- |
|                                    |            mento, serão apagados das tabelas de acumulados.                           |
+------------------------------------+---------------------------------------------------------------------------------------|
| Observacoes.: Utilização em viradas de versão/releases para auxiliar na correção do dicionario de dados.                   |
+------------------------------------+---------------------------------------------------------------------------------------+
*/
User Function fRestPon()

	Local bProcesso := {|oSelf| RstProc( oSelf )}

	Private cCadastro  := "Restaurar periodos do ponto encerrados por acidente."
	Private cDescricao := "Esta rotina efetuara ações IRREVERSIVEIS nas tabelas doponto.CUIDADO!!."
	Private aLog       := {} //-> Dados processados para planilha.


	tNewProcess():New( "fRestPon" , cCadastro , bProcesso , cDescricao , ,,,,,.T.,.F. )

	//-> Gera planilha para conferencia.
	If !Empty(aLog)
		fPlanLOG(aLog)
	EndIf

Return

/*+-------------------------+-------------------------+-------------------+
| Rotina.: RstProc        | Processamento Principal | Data.: 20.05.2010 |
+-------------------------+-------------------------+-------------------+
| Objetivo.:                                                            |
+-----------------------------------------------------------------------+
*/
Static Function RstProc(oSelf)

	//-> Variaveis de Processamento Basico.
	Local nX        := 0                          //-> Variavel para contagens em lacos.
	Local nY        := 0                          //-> Variavel para contagens em lacos.
	Local aRet      := {}                         //-> Uso no PARAMBOX.
	Local lNew      := .T.                        //-> Flga de controle de inclusão/alteração de registros.
	Local nRecs     := 0                          //-> Contador de registros.
	Local cQuery    := ""                         //-> Variavel para Query.
	Local cTabPrc   := ""                         //-> Tabela em processamento.
	Local cTabGrv   := ""                         //-> Tabela em gravação.
	Local cLocBkp   := GETSRVPROFSTRING("ROOTPATH","") +"\00JOSE\" //-> Local de gravação dos backups dos acumulados.
	Local aByPass   := {}                         //-> Controle do processo.
	Local aParamBox := {}                         //-> Parambox para peguntas da rotina.
	Local cAlsHist 	:= ""
	Local aStruHis

	AADD(aParamBox,{1, "Periodo Inicio", CToD("  /  /    "), "","NaoVazio()",,,200, .T.})
	AADD(aParamBox,{1, "Periodo Fim"   , CToD("  /  /    "), "","NaoVazio()",,,200, .T.})

	If ParamBox(aParamBox,"Periodo de Processamento",@aRet) .And. ( !Empty(aRet[1]) .And. !Empty(aRet[2]) )


		//-> Realiza copia das tabelas de acumulados.
		For nX := 1 To 2
			cTabPrc   := If(nX=1,"SPG","SPH")

			oSelf:SetRegua1( (cTabPrc)->(RecCount()) )
			oSelf:IncRegua1( "Copiando tabela "+cTabPrc+" para  "+cLocBkp+". Aguarde.")
			If oSelf:lEnd
				Break
			EndIf

			cAlsHist 	:= GetNextAlias()
			aStruHis  	:= (cTabPrc)->(dbStruct())
			cQuery 		:= "SELECT * "
			cQuery 		+= "FROM "+ RetSqlName(cTabPrc) + " "
			cQuery 		+= "WHERE D_E_L_E_T_ <> '*' "
			cQuery       += " AND "+(Right(cTabPrc,2)+"_DATA")+" BETWEEN '"+AllTrim(DToS(aRet[1]))+"' AND '"+AllTrim(DToS(aRet[2]))+"' "
			cQuery 		+= "ORDER BY R_E_C_N_O_ "
			cQuery 		:= ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlsHist)
			For nY := 1 To Len(aStruHis)
				If aStruHis[nY][2]<>"C"
					TcSetField(cAlsHist,aStruHis[nY][1],aStruHis[nY][2],aStruHis[nY][3],aStruHis[nY][4])
				EndIf
			Next nY

			//dbSelectArea(cTabPrc)
			//Copy to &(cLocBkp+cTabPrc+"01.DTC") FOR &(Right(cTabPrc,2)+"_DATA") >= aRet[1] .And. &(Right(cTabPrc,2)+"_DATA") <= aRet[2] via "CTREECDX"

			(cAlsHist)->( dbGoTop() )

			Copy to &(cLocBkp+cTabPrc+"01.DTC") via "CTREECDX"

			AADD(aByPass,{ File( (cLocBkp+cTabPrc+"01.DTC") ) })
		Next Nx

		If ASCan(aByPass,{|X| X[1] = .F.}) = 0 .And. Aviso("ATENÇÃO!!","DADOS PRONTOS PARA SEREM CARREGADOS NA SP8 E SP9.CONTINUA ?",{"Sim","Não"}) = 1


			For nX := 1 To 2

				cTabPrc   := If(nX=1,"SPG","SPH")

				If Select("TMP") > 0
					TMP->( dbCloseArea() )
				EndIf

				//-> Iniciando a recarga das tabelas do movimento.
				dbUseArea(.T.,"CTREECDX", (cLocBkp+cTabPrc+"01.DTC"), "TMP", .F., .F.)

				Count to nRecs

				dbSelectArea("TMP")
				dbGoTop()
				oSelf:SetRegua1( TMP->(RecCount()) )
				While TMP->( !EOF() )

					cTabGrv   := If(cTabPrc="SPG","SP8","SPC")

					oSelf:IncRegua1( "Carregando tabela "+cTabGrv+" com os dados...."+Str( TMP->(RecNo()) )+" Aguarde.")
					If oSelf:lEnd
						Break
					EndIf


					If TMP->( &(Right(cTabPrc,2)+"_DATA") ) >= aRet[1] .And.;
					TMP->( &(Right(cTabPrc,2)+"_DATA") ) <= aRet[2]

						/* Chaves conforme SIX.
						SP8-> P8_FILIAL+P8_MAT+P8_ORDEM+Dtos(P8_DATA)+Str(P8_HORA,5,2)
						SPC-> PC_FILIAL+PC_MAT+PC_PD+DTOS(PC_DATA)+PC_TPMARCA+PC_CC+PC_DEPTO+PC_POSTO+PC_CODFUNC
						*/

						cChave := If(cTabGrv="SP8", PG_FILIAL+PG_MAT+PG_ORDEM+Dtos(PG_DATA)+Str(PG_HORA,5,2),;
						PH_FILIAL+PH_MAT+PH_PD+DTOS(PH_DATA)+PH_TPMARCA+PH_CC+PH_DEPTO+PH_POSTO+PH_CODFUNC)


						lNew      := !(cTabGrv)->( dbSeek( TMP->(cChave) ) )

						(cTabGrv)->( RecLock(cTabGrv, lNew) )

						fGrvTab(cTabGrv)

						(cTabGrv)->( MsUnLock() )

					EndIf

					TMP->( dbSkip() )
				EndDo

				//-> Apagando dados das tabelas de acumulado.
				/*
				cQuery := "UPDATE "+RetSqlName(cTabPrc)+" "
				cQuery += "SET D_E_L_E_T_ = '*', "
				cQuery += "    R_E_C_D_E_L_ = R_E_C_N_O_ "
				cQuery += "FROM "+RetSqlName(cTabPrc)+" "
				cQuery += "WHERE D_E_L_E_T_ <> '*' AND "
				cQuery += "      "+Right(cTabPrc,2)+"_DATA BETWEEN '"+DToS(aRet[1])+"' AND '"+DToS(aRet[2])+"' "

				TcSqlExec(cQuery)
				*/

			Next nX
		EndIf
	EndIf

Return

/*
+--------------------+-----------------------------------+-----------------------+
|Funcao.: fPlanLOG   | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+--------------------+-----------------------------------+-----------------------+
|Descricao.: Funcao auxiliar para geracao de planilha de conferencia do calculo. |
+--------------------------------------------------------------------------------+
*/
Static Function fPlanLOG( aRegs )

	Local lSetCentury := __SetCentury( "on" )
	Local cPath       := AllTrim( GetTempPath() )
	Local cNomeArq    := ""

	Local cLin
	Local nX
	Local nY

	Private nHdl

	cNomeArq  := CriaTrab(,.F.) + ".CSV"

	// Cria Arquivo Texto
	cPath    := cPath + If(Right(cPath,1) <> "\","\","")
	cNomeArq := cPath + cNomeArq
	nHdl     := fCreate( cNomeArq )

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	EndIf

	//-> Gravando Cabecalho.
	For nX := 1 To Len(aRegs[1])
		If nX = 1
			cLin := aRegs[1][nX] + cSep
		Else
			cLin += aRegs[1][nX] + cSep
		EndIf
	Next
	cLin += cEol

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Return
		Endif
	Endif


	//-> Gravando Dados.
	For nX := 2 To Len(aRegs)

		For nY := 1 To Len(aRegs[nX])
			If nY = 1
				cLin := If( ValType( aRegs[nX][nY] ) = "N", AllTrim( Str(aRegs[nX][nY]) ), aRegs[nX][nY] ) + cSep
			Else
				cLin += If( ValType( aRegs[nX][nY] ) = "N", AllTrim( Str(aRegs[nX][nY]) ), aRegs[nX][nY] ) + cSep
			EndIf
		Next nY
		cLin += cEol

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Return
			Endif
		Endif

	Next nX



	If !lSetCentury
		__SetCentury( "off" )
	EndIf

	fClose( nHdl )

	// Integra Planilha ao Excel
	MsAguarde( {|| fStartExce( cNomeArq )}, "Aguarde...", "Integrando Planilha ao Excel..." )

Return


/*
+---------------------+-----------------------------------+-----------------------+
|Funcao.: fStartExce | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+---------------------+-----------------------------------+-----------------------+
|Descricao.: Integra os dados gerados com uma planilha no Excel.                  |
+---------------------------------------------------------------------------------+
*/
Static Function fStartExce( cNomeArq )

	If !ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cNomeArq ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	EndIf

Return


Static Function fGrvTab(cTabela)


	If cTabela = "SP8"
		SP8->P8_FILIAL  := TMP->PG_FILIAL
		SP8->P8_MAT     := TMP->PG_MAT
		SP8->P8_DATA    := TMP->PG_DATA
		SP8->P8_HORA    := TMP->PG_HORA
		SP8->P8_CC      := TMP->PG_CC
		SP8->P8_ORDEM   := TMP->PG_ORDEM
		SP8->P8_FLAG    := TMP->PG_FLAG
		SP8->P8_APONTA  := TMP->PG_APONTA
		SP8->P8_TURNO   := TMP->PG_TURNO
		SP8->P8_RELOGIO := TMP->PG_RELOGIO
		SP8->P8_FUNCAO  := TMP->PG_FUNCAO
		SP8->P8_GIRO    := TMP->PG_GIRO
		SP8->P8_TPMARCA := TMP->PG_TPMARCA
		SP8->P8_PAPONTA := TMP->PG_PAPONTA
		SP8->P8_PROCES  := TMP->PG_PROCES
		SP8->P8_ROTEIR  := TMP->PG_ROTEIR
		SP8->P8_PERIODO := TMP->PG_PERIODO
		SP8->P8_NUMPAG  := TMP->PG_NUMPAG
		SP8->P8_DEPTO   := TMP->PG_DEPTO
		SP8->P8_POSTO   := TMP->PG_POSTO
		SP8->P8_CODFUNC := TMP->PG_CODFUNC
		SP8->P8_DATAAPO := TMP->PG_DATAAPO
		SP8->P8_SEMANA  := TMP->PG_SEMANA
		SP8->P8_NUMREP  := TMP->PG_NUMREP
		SP8->P8_TPMCREP := TMP->PG_TPMCREP
		SP8->P8_TIPOREG := TMP->PG_TIPOREG
		SP8->P8_MOTIVRG := TMP->PG_MOTIVRG
		SP8->P8_EMPORG  := TMP->PG_EMPORG
		SP8->P8_FILORG  := TMP->PG_FILORG
		SP8->P8_MATORG  := TMP->PG_MATORG
		SP8->P8_DHORG   := TMP->PG_DHORG
		SP8->P8_IDORG   := TMP->PG_IDORG
		SP8->P8_DATAALT := TMP->PG_DATAALT
		SP8->P8_HORAALT := TMP->PG_HORAALT
		SP8->P8_USUARIO := TMP->PG_USUARIO
		SP8->P8_SEQJRN  := TMP->PG_SEQJRN

	ElseIf cTabela = "SPC"
		SPC->PC_FILIAL  := TMP->PH_FILIAL
		SPC->PC_MAT     := TMP->PH_MAT
		SPC->PC_DATA    := TMP->PH_DATA
		SPC->PC_PD      := TMP->PH_PD
		SPC->PC_TPMARCA := TMP->PH_TPMARCA
		SPC->PC_QUANTC  := TMP->PH_QUANTC
		SPC->PC_PDI     := TMP->PH_PDI
		SPC->PC_QUANTI  := TMP->PH_QUANTI
		SPC->PC_ABONO   := TMP->PH_ABONO
		SPC->PC_QTABONO := TMP->PH_QTABONO
		SPC->PC_CC      := TMP->PH_CC
		SPC->PC_FLAG    := TMP->PH_FLAG
		SPC->PC_PROCES  := TMP->PH_PROCES
		SPC->PC_ROTEIR  := TMP->PH_ROTEIR
		SPC->PC_PERIODO := TMP->PH_PERIODO
		SPC->PC_NUMPAG  := TMP->PH_NUMPAG
		SPC->PC_DEPTO   := TMP->PH_DEPTO
		SPC->PC_POSTO   := TMP->PH_POSTO
		SPC->PC_CODFUNC := TMP->PH_CODFUNC
		SPC->PC_TURNO   := TMP->PH_TURNO
		SPC->PC_SEMANA  := TMP->PH_SEMANA
		SPC->PC_PERCENT := TMP->PH_PERCENT
		SPC->PC_TIPOHE  := TMP->PH_TIPOHE
		SPC->PC_DATAALT := TMP->PH_DATAALT
		SPC->PC_HORAALT := TMP->PH_HORAALT
		SPC->PC_USUARIO := TMP->PH_USUARIO
	EndIf

Return