#INCLUDE "PROTHEUS.CH"

#DEFINE          cSep         ";"
#DEFINE          cEol         CHR(13)+CHR(10)

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} fRstPCB7()
Efetua a regravação dos eventos de horas extras e abonos aprovados via portal, na tabela de apontamentos.

@author Alexandre Alves
@since 24/03/2017
@version 1.0
/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

User Function fRstPCB7()
	Local bProcesso := {|oSelf| fPrcPrin( oSelf ) }
	Local cTitulo   := "Carrega Abonos e Horas Extras na SPC"
	Local cObjetiv  := "Efetua a gravação dos eventos de Horas Extras Autorizadas e Abonos, aprovados via portal, na tabela de apontamentos."

	tNewProcess():New( "fRstPCB7", cTitulo, bProcesso, cObjetiv,,,,,,.T.,.F. )

	Return


	//-------------------------------------------------------------------------------------------------------------------------------------------------------------
	/*/{Protheus.doc} fPrcPrin()
	Processamento central.

	@author Alexandre Alves
	@since 24/03/2017
	@version 1.0
	/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function fPrcPrin(oSelf)

	Local nX        := 0
	Local aRet      := {}
	Local cQuery    := ""
	Local cPonMes   := " "
	Local cTrbFile  := GetNextAlias()
	Local cTrbAuxi  := GetNextAlias()
	Local lProcExc  := .F.
	Local aRegPlan  := {}
	Local aParamBox := {}

	aAdd(aRegPlan,{"FILIAL","CCUSTO", " ", "DATA", "MATRICULA", " ", "EVENTO", " ", "HORAS", "INFORMADO", " ", "QTD. INFORMADA", "ABONO", " "})

	//              1 - MsGet  [2] : Descrição  [3]    : String contendo o inicializador do campo  [4] : String contendo a Picture do campo  [5] : String contendo a validação  [6] : Consulta F3  [7] : String contendo a validação When   [8] : Tamanho do MsGet   [9] : Flag .T./.F. Parâmetro Obrigatório ?
	aAdd(aParamBox,{1              ,"Periodo Inicial"  ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Inicial
	aAdd(aParamBox,{1              ,"Periodo Final"    ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Final
	aAdd(aParamBox,{1              ,"Filial Inicial"   ,Space(02)                                      ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.F.}) // Filial Inicial
	aAdd(aParamBox,{1              ,"Filial Final"     ,Replicate("Z",02)                              ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.T.}) // Filial Inicial
	aAdd(aParamBox,{1              ,"Matricula Inicial",Space(        TAMSX3("RA_MAT")[1])             ,"@!"                                     ,""                                ,"SRA"             ,""                                      ,TAMSX3("RA_MAT")[1]     ,.F.}) // Matricula Inicial
	aAdd(aParamBox,{1              ,"Matricula Final"  ,Replicate("Z",TAMSX3("RA_MAT")[1])             ,"@!"                                     ,""                                ,"SRA"             ,""                                      ,TAMSX3("RA_MAT")[1]     ,.T.}) // Matricula Final
	aAdd(aParamBox,{1              ,"C. Custo Inicial" ,Space(        TAMSX3("CTT_CUSTO")[1])          ,"@!"                                     ,""                                ,"CTT"             ,""                                      ,TAMSX3("CTT_CUSTO")[1]  ,.F.}) // C. de Custo Inicial
	aAdd(aParamBox,{1              ,"C. Custo Final"   ,Replicate("Z",TAMSX3("CTT_CUSTO")[1])          ,"@!"                                     ,""                                ,"CTT"             ,""                                      ,TAMSX3("CTT_CUSTO")[1]  ,.T.}) // C. de Custo Final

	If Parambox(aParambox,"Parametros de Processamento",@aRet)

		cPonMes   := AllTrim( DToS(aRet[1]) + DToS(aRet[2]) )

		cQuery += "SELECT TMP.*                        "+CRLF
		cQuery += "      ,PB7.PB7_STATUS AS STSREG     "+CRLF
		cQuery += "      ,PB7.PB7_HRPOSE AS EVEPOS     "+CRLF
		cQuery += "      ,PB7.PB7_HRPOSV AS HRSPOS     "+CRLF
		cQuery += "      ,PB7.PB7_STAHE  AS STAHRE     "+CRLF
		cQuery += "      ,PB7.PB7_HRNEGE AS EVENEG     "+CRLF
		cQuery += "      ,PB7.PB7_HRNEGV AS HRSNEG     "+CRLF
		cQuery += "      ,PB7.PB7_STAATR AS STAATR     "+CRLF
		cQuery += "FROM "+RetSqlName("PB7")+" PB7,     "+CRLF
		cQuery += "	   (SELECT PB7_FILIAL AS FILIAL   "+CRLF
		cQuery += "            ,PB7_CC     AS CCUSTO   "+CRLF
		cQuery += "            ,CTT_DESC01 AS CCUDES   "+CRLF
		cQuery += "	          ,PB7_MAT    AS MATRIC   "+CRLF
		cQuery += "	          ,RA_NOME    AS NOME     "+CRLF
		cQuery += "	          ,PB7_DATA   AS DATA     "+CRLF
		cQuery += "	          ,max(PB7_VERSAO) VERSAO "+CRLF
		cQuery += "	    FROM  "+RetSqlName("PB7")+" PB7 "+CRLF
		cQuery += "      INNER JOIN      "+RetSqlName("SRA")+" SRA ON  RA_MAT         = PB7_MAT AND SRA.D_E_L_E_T_  <> '*' "+CRLF
		cQuery += "      LEFT OUTER JOIN "+RetSqlName("CTT")+" CTT ON  CTT_CUSTO      = PB7_CC  AND CTT.D_E_L_E_T_  <> '*' "+CRLF
		cQuery += "      LEFT OUTER JOIN "+RetSqlName("PBB")+" PBB ON  PB7_FILIAL     = PBB_FILMAT                         "+CRLF
		cQuery += "                                                AND PB7_DATA       = PBB_DTAPON                         "+CRLF
		cQuery += "                                                AND PB7.PB7_MAT    = PBB_MAT                            "+CRLF
		cQuery += "                                                AND PBB.D_E_L_E_T_ = ' '                                "+CRLF
		cQuery += "      WHERE PB7.D_E_L_E_T_ <> '*'                                                                       "+CRLF
		cQuery += "	      AND PB7_PAPONT = '"      +cPonMes+"'                   "+CRLF
		cQuery += "        AND PB7_FILIAL BETWEEN '"+aRet[3]+"' AND '"+aRet[4]+"' "+CRLF
		cQuery += "        AND PB7_CC     BETWEEN '"+aRet[7]+"' AND '"+aRet[8]+"' "+CRLF
		cQuery += "	      AND PB7_MAT    BETWEEN '"+aRet[5]+"' AND '"+aRet[6]+"' "+CRLF
		cQuery += "     GROUP BY PB7_FILIAL, PB7_CC, CTT_DESC01, PB7_MAT, RA_NOME, PB7_DATA  "+CRLF
		cQuery += "     ORDER BY PB7_FILIAL, PB7_CC, CTT_DESC01, PB7_MAT, RA_NOME, PB7_DATA  "+CRLF
		cQuery += "     )TMP                                "+CRLF
		cQuery += "WHERE	 PB7.PB7_FILIAL =  TMP.FILIAL      "+CRLF
		cQuery += "  AND  PB7.PB7_VERSAO =  TMP.VERSAO      "+CRLF
		cQuery += "  AND  PB7.PB7_DATA   =  TMP.DATA        "+CRLF
		cQuery += "  AND  PB7.PB7_MAT    =  TMP.MATRIC      "+CRLF
		cQuery += "  AND  PB7.PB7_STATUS =  '7'             "+CRLF
		cQuery += "  AND (PB7.PB7_HRPOSE <> ' ' OR PB7.PB7_HRNEGE <> ' ' ) "+CRLF
		cQuery += "  AND (PB7.PB7_STAHE  =  '3' OR PB7.PB7_STAATR  = '3' ) "+CRLF
		cQuery += "  AND  PB7.D_E_L_E_T_ <> '*'                            "+CRLF
		cQuery += "ORDER BY PB7.PB7_FILIAL, PB7.PB7_MAT, PB7.PB7_DATA      "+CRLF
		cQuery := ChangeQuery( cQuery )

		dbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), cTrbFile, .F., .T.)

		(cTrbFile)->(dbGoTop())

		oSelf:SetRegua1( (cTrbFile)->( RecCount() ) )

		While (cTrbFile)->( !Eof() )

			oSelf:IncRegua1( "Processando Registro.: "+(cTrbFile)->(FILIAL+" - "+MATRIC+" - "+DATA)+" ...aguarde." )
			If oSelf:lEnd
				Break
			EndIf

			//-> Verifica se o Evento Informado ou o Codigo do Abono na SPC, estão em branco.
			cQuery := "SELECT 1 FROM "+RetSqlName("SPC")+" SPC "
			cQuery += "WHERE SPC.D_E_L_E_T_ <> '*' "
			cQuery += "  AND SPC.PC_FILIAL = '"+(cTrbFile)->FILIAL+"' "
			cQuery += "  AND SPC.PC_MAT    = '"+(cTrbFile)->MATRIC+"' "
			cQuery += "  AND SPC.PC_DATA   = '"+(cTrbFile)->DATA+"'   "

			If (cTrbFile)->EVEPOS <> ' '
				cQuery += "  AND SPC.PC_PDI     = ' ' "
			EndIf

			If (cTrbFile)->EVENEG <> ' '
				cQuery += "  AND SPC.PC_ABONO   = ' ' "
			EndIf

			cQuery := ChangeQuery( cQuery )

			dbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), cTrbAuxi, .F., .T.)

			(cTrbAuxi)->( dbGoTop()     )
			lProcExc := (cTrbAuxi)->( !Eof()        )
			(cTrbAuxi)->( dbCloseArea() )


			If lProcExc

				SPC->( dbSetOrder(2) ) //-> INDICE 2 # PC_FILIAL+PC_MAT+DTOS(PC_DATA)+PC_PD+PC_TPMARCA+PC_CC+PC_DEPTO+PC_POSTO+PC_CODFUNC
				If SPC->( dbSeek( (cTrbFile)->(FILIAL+MATRIC+DATA) ) )

					While SPC->(!EOF()) .And. SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA)) = (cTrbFile)->(FILIAL+MATRIC+DATA)

						//-> Se houver Justificativa para Horas Positivas no portal e se foi aprovada, atualiza a codigo do Evento Informado na SPC.
						If (cTrbFile)->EVEPOS <> ' ' .And.;
						(cTrbFile)->STAHRE = '3'  .And.;
						SPC->PC_PDI = ' '  .And.;
						Posicione( 'SP9', 1, XFILIAL('SP9')+SPC->PC_PD, 'P9_CLASEV' ) $ '01'

							//-> Localza o codigo do Evento Autorizado da Hora Extra.
							SP4->( dbSetOrder(2) ) //--> Indice 2 -> P4_FILIAL+P4_CODNAUT+P4_TIPO
							If SP4->( dbSeek( SPC->(PC_FILIAL+PC_PD)) ) .And. SP4->P4_CODNAUT = SPC->PC_PD

								SPC->( RecLock("SPC",.F.) )
								SPC->PC_PDI    := SP4->P4_CODAUT
								SPC->PC_QUANTI := SPC->PC_QUANTC
								//SPC->PC_LOG     := "fPrcPrin Usuario Protheus: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
								SPC->( MsUnLock() )

								//-> Carrega variavel para montagem do LOG.
								nX := Ascan(aRegPlan,{|x| x[1] = (cTrbFile)->FILIAL .And.;
								X[2] = (cTrbFile)->CCUSTO .And.;
								x[4] = (cTrbFile)->DATA   .And.;
								x[5] = (cTrbFile)->MATRIC .And.;
								x[7] =        SPC->PC_PD;
								};
								)


								If nX = 0
									aAdd(aRegPlan,{(cTrbFile)->FILIAL,;                                      //-> 01 -> FILIAL.
									(cTrbFile)->CCUSTO,;                                      //-> 02 -> COD. CENTRO DE CUSTO.
									(cTrbFile)->CCUDES,;                                      //-> 03 -> DESC. CENTRO DE CUSTO.
									(cTrbFile)->DATA,;                                        //-> 04 -> DATA.
									(cTrbFile)->MATRIC,;                                      //-> 05 -> MATRICULA.
									(cTrbFile)->NOME,;                                        //-> 06 -> NOME.
									SPC->PC_PD,;                                       //-> 07 -> COD. EVENTO.
									Posicione("SP9",1,xFilial("SP9")+SPC->PC_PD,"P9_DESC"),;  //-> 08 -> DESC. EVENTO.
									SPC->(Str(PC_QUANTC)),;                                //-> 09 -> QTD. HORAS CALCULADAS.
									SPC->PC_PDI,;                                          //-> 10 -> COD. EVENTO INFORMADO.
									Posicione("SP9",1,xFilial("SP9")+SPC->PC_PDI,"P9_DESC"),; //-> 11 -> DESC. EVENTO INFORMADO.
									SPC->(Str(PC_QUANTI)),;                                //-> 12 -> QTD. HORAS INFORMADAS.
									' ',;                                                 //-> 13 -> COD. ABONO.
									'  ';                                                 //-> 14 -> DESC. ABONO.
									})
								EndIf
							EndIf
						EndIf

						//-> Se houver Justificativa para Horas NEGATIVAS no portal e se foi aprovada, atualiza a codigo do Abono na SPC e na SPK.
						If (cTrbFile)->EVENEG <> ' ' .And.;
						(cTrbFile)->STAATR =  '3' .And.;
						SPC->PC_ABONO =  ' ' .And.;
						Posicione( 'SP9', 1, XFILIAL('SP9')+SPC->PC_PD, 'P9_CLASEV' ) $ '02/03/04/05'

							SPC->( RecLock("SPC",.F.) )
							SPC->PC_ABONO   := (cTrbFile)->EVENEG
							SPC->PC_QTABONO :=        SPC->PC_QUANTC
							//SPC->PC_LOG     := "fPrcPrin Usuario Protheus: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
							SPC->( MsUnLock() )


							//-> Indice - 2 - PK_FILIAL+PK_MAT+DTOS(PK_DATA)+PK_CODEVE+STR(PK_HORINI,5,2)+PK_CC
							SPK->( dbSetOrder(2) )
							If SPK->( dbSeek(SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA)+PC_PD) ) ) .And.;
							SPK->(PK_FILIAL+PK_MAT+DTOS(PK_DATA)+PK_CODEVE) == SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA)+PC_PD)

								SPK->(RecLock("SPK", .F.))
								SPK->PK_CODABO := SPC->PC_ABONO
								SPK->PK_HRSABO := SPC->PC_QTABONO
								SPK->PK_HORINI := 0
								SPK->PK_HORFIM := 0
								//SPK->PK_LOG     := "fPrcPrin Usuario Protheus: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
								SPK->(MsUnLock())

							Else
								SPK->(RecLock("SPK", .T.))
								SPK->PK_FILIAL := SPC->PC_FILIAL
								SPK->PK_MAT	 := SPC->PC_MAT
								SPK->PK_DATA   := SPC->PC_DATA
								SPK->PK_CODABO := SPC->PC_ABONO
								SPK->PK_HRSABO := SPC->PC_QTABONO
								SPK->PK_HORINI := 0
								SPK->PK_HORFIM := 0
								SPK->PK_CODEVE := SPC->PC_PD
								SPK->PK_CC     := SPC->PC_CC
								SPK->PK_FLAG   := 'I'
								//SPK->PK_LOG     := "fPrcPrin Usuario Protheus: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
								SPK->(MsUnLock())
							EndIf

							//-> Carrega variavel para montagem do LOG.
							nX := Ascan(aRegPlan,{|x| x[1] = (cTrbFile)->FILIAL .And.;
							X[2] = (cTrbFile)->CCUSTO .And.;
							x[4] = (cTrbFile)->DATA   .And.;
							x[5] = (cTrbFile)->MATRIC .And.;
							x[7] =        SPC->PC_PD;
							};
							)


							If nX = 0
								aAdd(aRegPlan,{(cTrbFile)->FILIAL,;  //-> 01 -> FILIAL.
								(cTrbFile)->CCUSTO,;  //-> 02 -> COD. CENTRO DE CUSTO.
								(cTrbFile)->CCUDES,;  //-> 03 -> DESC. CENTRO DE CUSTO.
								(cTrbFile)->DATA,;    //-> 04 -> DATA.
								(cTrbFile)->MATRIC,;  //-> 05 -> MATRICULA.
								(cTrbFile)->NOME,;    //-> 06 -> NOME.
								SPC->PC_PD,;   //-> 07 -> COD. EVENTO.
								Posicione("SP9",1,xFilial("SP9")+SPC->PC_PD,"P9_DESC"),;   //-> 08 -> DESC. EVENTO.
								SPC->(Str(PC_QUANTC)),;                                 //-> 09 -> QTD. HORAS CALCULADAS.
								SPC->PC_PDI,;                                           //-> 10 -> COD. EVENTO INFORMADO.
								Posicione("SP9",1,xFilial("SP9")+SPC->PC_PDI,"P9_DESC"),;  //-> 11 -> DESC. EVENTO INFORMADO.
								SPC->(Str(PC_QUANTI)),;                                 //-> 12 -> QTD. HORAS INFORMADAS.
								SPC->PC_ABONO,;                                         //-> 13 -> COD. ABONO.
								Posicione("SP6",1,xFilial("SP6")+SPC->PC_ABONO,"P6_DESC"); //-> 14 -> DESC. ABONO.
								})
							EndIf
						EndIf


						SPC->( dbSkip() )
					EndDo
				EndIf
			EndIf

			(cTrbFile)->(dbSkip())

		EndDo
	EndIf

	(cTrbFile)->(dbCloseArea())

	If   !Empty( aRegPlan )
		fPlanLOG( aRegPlan )
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
	local nX := 0
	local nY := 0

	Private nHdl

	If Len(aRegs) > 1

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
					cLin := If(Type(aRegs[nX][nY])="N", Str(aRegs[nX][nY]), aRegs[nX][nY]) + cSep
				Else
					cLin += If(Type(aRegs[nX][nY])="N", Str(aRegs[nX][nY]), aRegs[nX][nY]) + cSep
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
	EndIf
Return

/*
+---------------------+-----------------------------------+-------------------------+
|Funcao.: fStartExce | Autor.: Alexandre Alves           | Data.: 06/06/2016       |
+---------------------+-----------------------------------+-------------------------+
|Descricao.: Realiza o merge entre as informações geradas pela rotina com o MsExcel |
+-----------------------------------------------------------------------------------+
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