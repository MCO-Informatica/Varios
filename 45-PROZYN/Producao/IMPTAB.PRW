#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'RWMAKE.CH'

User Function IMPTAB()

	Local llOk		:= .T.
	Local alButton	:= {}
	Local alSay		:= {}
	Local clTitulo	:= 'IMPORTAÇÃO CSV'
	Local clDesc1   := 'Esta rotina tem como objetivo fazer a importacao de arquivo no      '             
	Local clDesc2   := 'formato csv, com layout especifico para o correto funcionamento da   '
	Local clDesc3   := 'importação. (Primeira linha sempre sera os campos respectivos)'
	
	// Mensagens de Tela Inicial
	AADD(alSay, clDesc1)
	AADD(alSay, clDesc2)
	AADD(alSay, clDesc3)

	// Botoes do Formatch
	AADD(alButton, {1, .T., {|| llOk := .T., FechaBatch()}})
	AADD(alButton, {2, .T., {|| llOk := .F., FechaBatch()}})
	
	FormBatch(clTitulo, alSay, alButton)
	
	if llOk
		clArq := FARQEX( 1 )
		
		if !File(clArq)	
			MsgStop("O arquivo " + clArq + " não foi encontrado. A importação será abortada!" )
		else
			Processa( {|| FIMPORT( clArq ) }, "Aguarde a importação...","Aguarde!",.F.)
		endif
	endif

Return

Static Function FIMPORT( clArq )

	Local clLinha		:= ""
	Local alCampos		:= {}
	Local alDados		:= {}
	Local nlCont		:= 0
	Local nlTotLin		:= 0
	Local llPrim		:= .T.
	Local llGrv		:= .F.
	Local clAlias		:= ""

	FT_FUSE(clArq)
	FT_FGOTOP()
	
	nlTotLin := FT_FLASTREC()
	ProcRegua( nlTotLin+1 )
	FT_FGOTOP()
	
	//-----------------------------------------------------------
	//- Obrigatorio o nome do arquivo csv ser o alias da tabela -
	//-----------------------------------------------------------
	clAlias := AllTrim( UPPER( STRTRAN(UPPER(SUBSTR(clArq, RAT("\", clArq)+1, Len( clArq ) ) ), ".CSV", "") ) )
	
	IncProc("Deletando registros...")
	if F_DELPFC( clAlias ) // Se deletou a cascata relacionada ao modulo de máquinas

		While !FT_FEOF() 
			
			clLinha := FT_FREADLN()
	
			if llPrim
			
				alCampos := Separa(clLinha,";",.T.)
				llPrim := .F.
				
			else
			
				llGrv := .T.
				AADD(alDados,Separa(clLinha,";",.T.))
				
			endif
			
			nlCont++
			IncProc("Incluindo registro..."+Alltrim(Str(nlTotLin))+"/"+Alltrim(Str(nlCont))+" - "+ Alltrim(Str((nlCont/nlTotLin)*100,3))+"%")
			
			if llGrv
				llGrv := .F.
				FGRVTB( alCampos, alDados, clAlias )
			endif
			alDados := {}
	
			FT_FSKIP()
			
		EndDo
		
		FT_FUSE()
		
		MsgInfo("Importação concluída com sucesso!" )
		
	endif
	
Return

Static Function FGRVTB( alCampos, alDados, clAlias )

	Local nlx
	Local nly
	
	Default clAlias := ""
	
	if !Empty( alCampos ) .And. !Empty( alDados ) .And. !Empty( clAlias )
	
		dbSelectArea( clAlias )
	
		for nlx := 1 To Len( alDados )
		
			if RecLock(clAlias, .T.)
		
				for nly := 1 To Len( alCampos )
			
					Do Case
					
						Case ValType( &( alCampos[nly] ) ) == "N"
							
							&( alCampos[nly] ) := Val( alDados[nlx][nly] )
							
						Case ValType( &( alCampos[nly] ) ) == "D"
						
							&( alCampos[nly] ) := StoD( alDados[nlx][nly] )
							
						OtherWise
							&( alCampos[nly] ) := alDados[nlx][nly]
					
					EndCase
			
				next nly
				
				(clAlias)->( MsUnLock() )
			endif
		
		next nlx
		
	else
		MsgStop("O arquivo csv não foi lido corretamente. Importação abortada!")
	endif

Return

Static Function F_DELPFC( clAlias )

	Local clUPD 	:= ""
	Local llRet	:= .T.
	Default clAlias	:= ""
	
	//- nao sei se eh para deletar antes de importar entao comentei 
	/*
	clUPD := "UPDATE "
	clUPD += RetSQlName( clAlias )
	clUPD += " SET D_E_L_E_T_ = '*' "
	clUPD += " WHERE  D_E_L_E_T_ = ' ' "

	if TcSQLExec( clUPD ) < 0
		llRet := .F.
		Aviso("Erro!", "Erro na exclusao de registros da tabela " + clAlias + ". Importação abortada!" + CRLF + "UPDATE: " + clUPD + CRLF + "Erro retornado do banco de dados: " + TcSQLError(), {"Fechar"}, 3)
	endif
	*/	
Return llRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FARQEX    ºAutor  ³Sergio Daniel Arteroº Data ³  24/04/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de retorno da consulta padrao ARQ_01                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FARQEX( nlOpc, clNomeArq, clExtensao )

	Local clFile	:= ""
	
	Default clExtensao := "CSV" 
	Default clNomeArq  := "*"
	
	clExtensao := UPPER(clExtensao)
	clNomeArq  := AllTrim( clNomeArq )
					
	Do Case
	
		// Arquivo .CSV que sera utilizado para a importacao
		Case nlOpc == 1
			clFile := Trim(	cGetFile(	PADR("Arquivos " + clExtensao + "(" + clNomeArq + "." + Lower(clExtensao) + ")" , 27) +;
										"|" + clNomeArq + "." + clExtensao + "|",;
										"Selecione Diretorio e Arquivo", 0, "C:\" , .T., 49))
		
		// Diretorio onde sera gerado o arquivo
		Case nlOpc == 2
			clFile := Trim(	cGetFile("*.*","Selecione a pasta Destino",0,"C:\",.T.,;
	 					GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE);
					)
	EndCase

Return clFile