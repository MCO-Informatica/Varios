#INCLUDE "Protheus.ch"

#Define CMD_OPENWORKBOOK			1
#Define CMD_CLOSEWORKBOOK		 	2
#Define CMD_ACTIVEWORKSHEET  		3
#Define CMD_READCELL				4

/*---------------------------------------------------------------------------------
Programa : U_XIMPORT
Autor    : Ricardo Arruda
Data     : 15/08/2014
Descricao: Realiza a Importacao de Planilha Excel de qualquer Tabela.
Descricao: Realiza alteracao de de campos de todas as tabelas.

-Exemplo de Excell para ser alterado ou importado.
As colunas que estao com o campo * , esse sinal voce esta informando que essa coluna sera alterada na base.
E no final da planilha precisa informar o campo # para informar o final do arquivo.

DA1				*		*
DA1_FILIAL	DA1_ITEM	DA1_CODTAB	DA1_CODPRO	DA1_PRCVEN	DA1_VLRDES	DA1_TPOPER
	***1	**1	*****5	100	0	1
	***2	**1	*****6	200	0	1
	***3	XXX	*****1	300	0	1
	***4	**1	*****2	400	0	1
#						
---------------------------------------------------------------------------------*/
Function U_XIMPORT()

Local aPerg		:= {}
Local aParam   	:= { Space(70) }

Private lErro	:= .F.

	Aadd( aPerg, { 6, "Informe o Arquivo a ser Importado", aParam[01], "", ".T.", ".T.", 80, .T., " |*.XLS", "C:\", GETF_LOCALHARD + GETF_NETWORKDRIVE } )

	If ParamBox( aPerg, "Parametros para ImportaÃ§Ã£o de Planilha", , , , , , , , "IMPSFM", .T., .T. )
	
	If !Empty(MV_PAR01)
		
		//Inicia Transacao
		Begin Transaction
		
		Processa( {|| IMPORTA( MV_PAR01 ) }, "Processando arquivo, Por favor aguarde." )
		
		If lErro
			DisarmTransaction()
		EndIf
		
		//Finaliza Transacao
		End Transaction
		
		Aviso( "Aviso", "Processo Finalizado Com Sucesso...", { "Ok" } )
		
	Else
	
		Aviso( "Aviso", "Favor preencher os parametros!", { "Ok" } )
		
	EndIf
	
EndIf

Return Nil

/*---------------------------------------------------------------------------------

Programa : IMPORTA
Autor    : Ricardo Arruda
Data     : 30/12/2013
Descricao: Efetivamente realiza a importacao.

---------------------------------------------------------------------------------*/

Static Function IMPORTA( cArquivo )

Local aCelulas		:= {}
//Local aCampos		:= {}       
Local aDados		:= {}
//Local cTabela		:= ""
Local cDado			:= ""
Local cTipo			:= ""
Local nT			:= 0
Local nLin			:= 3
Local cBuffer		:= ""
Local cPasta    	:= ""
Local nCelini   	:= 2
Local nP			:= 0
Local nSequencia	:= 0
Local nHdl    		:= ExecInDLLOpen("C:\DLL\readexcel.dll") //Necessario colocar a DLL , nesse caminho Para o Programa Funcionar.
Local cMsg			:= ""		// mostra problemas na importação - Cristiam Rossi em 14/08/2014
Local nRegs, nI
Private cTabela		:= ""
Private aCampos		:= {}       
Private aAlter		:= {}		// campos alterados - Cristiam Rossi em 13/08/2014

	aCelulas	:= { ;
				'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',;
				'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AV', 'AW', 'AX', 'AY', 'AZ',;
				'BA', 'BB', 'BC', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BK', 'BL', 'BM', 'BN', 'BO', 'BP', 'BQ', 'BR', 'BS', 'BT', 'BU', 'BV', 'BW', 'BX', 'BY', 'BZ',;
				'CA', 'CB', 'CC', 'CD', 'CE', 'CF', 'CG', 'CH', 'CI', 'CJ', 'CK', 'CL', 'CM', 'CN', 'CO', 'CP', 'CQ', 'CR', 'CS', 'CT', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ',;
				'DA', 'DB', 'DC', 'DD', 'DE', 'DF', 'DG', 'DH', 'DI', 'DJ', 'DK', 'DL', 'DM', 'DN', 'DO', 'DP', 'DQ', 'DR', 'DS', 'DT', 'DU', 'DV', 'DW', 'DX', 'DY', 'DZ',;
				'EA', 'EB', 'EC', 'ED', 'EE', 'EF', 'EG', 'EH', 'EI', 'EJ', 'EK', 'EL', 'EM', 'EN', 'EO', 'EP', 'EQ', 'ER', 'ES', 'ET', 'EU', 'EV', 'EW', 'EX', 'EY', 'EZ',;
				'FA', 'FB', 'FC', 'FD', 'FE', 'FF', 'FG', 'FH', 'FI', 'FJ', 'FK', 'FL', 'FM', 'FN', 'FO', 'FP', 'FQ', 'FR', 'FS', 'FT', 'FU', 'FV', 'FW', 'FX', 'FY', 'FZ',;
				'GA', 'GB', 'GC', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GJ', 'GK', 'GL', 'GM', 'GN', 'GO', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GV', 'GW', 'GX', 'GY', 'GZ',;
				'HA', 'HB', 'HC', 'HD', 'HE', 'HF', 'HG', 'HH', 'HI', 'HJ', 'HK', 'HL', 'HM', 'HN', 'HO', 'HP', 'HQ', 'HR', 'HS', 'HT', 'HU', 'HV', 'HW', 'HX', 'HY', 'HZ',;
				'IA', 'IB', 'IC', 'ID', 'IE', 'IF', 'IG', 'IH', 'II', 'IJ', 'IK', 'IL', 'IM', 'IN', 'IO', 'IP', 'IQ', 'IR', 'IS', 'IT', 'IU', 'IV', 'IW', 'IX', 'IY', 'IZ',;
				'JA', 'JB', 'JC', 'JD', 'JE', 'JF', 'JG', 'JH', 'JI', 'JJ', 'JK', 'JL', 'JM', 'JN', 'JO', 'JP', 'JQ', 'JR', 'JS', 'JT', 'JU', 'JV', 'JW', 'JX', 'JY', 'JZ' ;
				}
	
	cPasta	:= "Plan1"

	For nP := 1 To 1
	
	
		If !( nHdl >= 0 )
		
			Aviso("Aviso","NÃ£o foi possivel carregar a DLL (C:\DLL\readexcel.dll)",{"Retornar"},2) // Nao encontru a Dll Verificar se esta no Diretorio Correto.
			Return Nil
			
		Else
		
			// Carrega o Excel e Abre o arquivo
			cBuffer := cArquivo + Space(512)
			nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)		
			ProcRegua(nHdl)
		
			// Verifica se Arquivo Foi aberto Corretamente
			If ( nBytes < 0 )
			
				Aviso("Aviso","NÃ£o foi possivel abrir o arquivo : " + cArquivo,{"Ok"})
				Return Nil
				
			ElseIf ( nBytes > 0 )
			
				MsgStop(Substr(cBuffer, 1, nBytes))
				Return Nil
				
			EndIf
		
			// Abre a Pasta p/ Iniciar a Leitura
			cBuffer := cPasta + Space(512)
			ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)

			For nT := 1 To Len( aCelulas )

				cBuffer	 := aCelulas[nt]+'2' + Space( 1024 )
				nBytes	 := ExeDLLRun2( nHdl, CMD_READCELL, @cBuffer )
				cCampo  := Substr(cBuffer, 1, nBytes)			
				If( cCampo != '' )

					Aadd( aCampos, { aCelulas[nT],AllTrim( cCampo ) } )

					if nT > 1					// se coluna for maior que 1
						cBuffer	 := aCelulas[nt]+'1' + Space( 1024 )
						nBytes	 := ExeDLLRun2( nHdl, CMD_READCELL, @cBuffer )
						cCampo  := Substr(cBuffer, 1, nBytes)
						if !Empty(cCampo)		// se existir algum dado suponhamos que será alteração
							aadd(aAlter, nT)	// armazeno a posição do Campo no array aCampos
						endif
					endif

				EndIf

			Next nT		

			lContinua := .T.
			cBuffer	 := 'A1 '
			nBytes	 := ExeDLLRun2( nHdl, CMD_READCELL, @cBuffer )     
			cTabela := Substr( cBuffer, 1, nBytes )

			If Empty( ALLTRIM( cTabela ) )

				lContinua := .F.

			EndIF

			While lContinua

				IncProc( "Processando Registro " + StrZero( nSequencia, 10, 0 ) )

				cBuffer	 := 'A' + CValToChar( nLin )
				nBytes	 := ExeDLLRun2( nHdl, CMD_READCELL, @cBuffer )     
				cBuffer  := Substr( cBuffer, 1, nBytes )
            
				If( AllTrim( cBuffer ) == '#' )
					lContinua := .F.
					Loop
				EndIF


				if len(aAlter) > 0			// existe alterações
					nRegs := fPesquisar( nHdl, nLin )
					if nRegs == 1
						RecLock(cTabela, .F.)
						for nI := 1 to len(aAlter)
							cBuffer	:= aCampos[ aAlter[nI] ][1] + CValToChar( nLin ) + Space(1024)
							nBytes	:= ExeDLLRun2( nHdl, CMD_READCELL, @cBuffer )     
							cDado   := StrTran( AllTrim( Substr( cBuffer, 1, nBytes ) ), '*', '0' )
							cTipo   := GetAdvFVal( "SX3", "X3_TIPO", aCampos[ aAlter[nI] ][2], 2, "C" )

							Do Case
								Case cTipo == 'N'
									cDado := Val( Strtran(cDado,",",".") )
								Case cTipo == 'D'
									cDado := Ctod( cDado )
							EndCase

							( cTabela )->&(aCampos[ aAlter[nI] ][2])  := cDado

						next
						MsUnlock()
					else
						cMsg += "Encontrado(s) ["+Alltrim(Str(nRegs))+"] registro(s) para a linha "+Alltrim(Str(nLin)) +CRLF
					endif
					nLin++					// incrementa avanço
					nSequencia++
					Loop
				endif


				dbSelectArea( ( cTabela ) )
				RecLock( cTabela ,.T.)

				For nT := 1 To Len( aCampos )

					cBuffer	 := aCampos[nT][1] + CValToChar( nLin ) + Space(1024)
					nBytes	 := ExeDLLRun2( nHdl, CMD_READCELL, @cBuffer )     

					cDado := StrTran( AllTrim( Substr( cBuffer, 1, nBytes ) ), '*', '0' )
					cTipo := GetAdvFVal( "SX3", "X3_TIPO", aCampos[nT][2], 2, "C" )

					Do Case

						Case cTipo == 'N'
						
							cDado := Val( cDado )

						Case cTipo == 'D'
						
							cDado := Ctod( cDado )
							
						OtherWise							
					
					EndCase
					( cTabela )->&(aCampos[nT][2])  := cDado
			
				Next nT
 			
				dbSelectArea("SX3")
				dbSetOrder(1)
				dbSeek( cTabela )
				While !Eof() .And. SX3->X3_ARQUIVO == cTabela
				
					If X3Uso(SX3->X3_USADO)                                       
						IF Ascan(aCampos,{|x| AllTrim(x[2]) == ALLTRIM(SX3->X3_CAMPO)}) == 0
						//If !alltrim(SX3->X3_CAMPO)$"FM_FILIAL/FM_TIPO/FM_TE/FM_TS/FM_EST/FM_GRTRIB/FM_GRPROD/FM_DHUSER"
							If !Empty(SX3->X3_RELACAO)
								INCLUI := .T.
								( cTabela )->&(SX3->X3_CAMPO) := &(SX3->X3_RELACAO)
							Endif
						EndIf
					EndIf
					dbSelectArea("SX3")
					dbSkip()
				EndDo
				
				( ctabela )->( MsUnlock() )
		
				nLin++			
				nSequencia ++
			
			Enddo
		
			//Fecha o arquivo e remove o Excel da memoria
			cBuffer := Space(512)
			ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
			ExecInDLLClose(nHdl)

		EndIf
	Next nP

	if ! Empty(cMsg)
		cMsg := "Aumente os campos não alterados, de preferência campos chave para refinar a pesquisa e garantir a atualização. As linhas listadas abaixo não foram alteradas:" + CRLF + CRLF + cMsg
		Aviso("Problemas na atualização",cMsg,{"Ok"},3)
	endif
Return Nil


//-------------------------------------------------------------------
Static Function fPesquisar( nHdl, nLin )
Local  cQuery, nI, cBuffer, nBytes, cDado
Local  cAlias    := Alias()
Local  cAliasQry := GetNextAlias()
Local  nQtd      := 0
Static aCpos     := {}

	if len(aCpos) == 0
		for nI := 1 to len( aCampos )
			if aScan( aAlter, nI ) == 0
				cTipo := GetAdvFVal( "SX3", "X3_TIPO", aCampos[nI][2], 2, "C" )
				aadd(aCpos, {aCampos[nI][1], aCampos[nI][2], cTipo})
			endif
		next
	endif

	cQuery := "select R_E_C_N_O_ RECORD from "+RetSqlName(cTabela)
	cQuery += " where D_E_L_E_T_ = ' '"
	for nI := 1 to len( aCpos )
		cQuery += " and "
		cQuery += aCpos[nI,2]
		cQuery += " = "

		cBuffer	:= aCpos[nI][1] + CValToChar( nLin ) + Space(1024)
		nBytes  := ExeDLLRun2( nHdl, CMD_READCELL, @cBuffer )     
		cDado   := StrTran( AllTrim( Substr( cBuffer, 1, nBytes ) ), '*', '0' )

		if aCpos[nI,3] == "N"
			cQuery += StrTran(cDado, ",", ".")
//		elseif aCpos[nI,3] == "D"
//			cQuery += "'" + CTOS(cDado) + "'"
		else
			cQuery += "'" + cDado + "'"
		endif
	next
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	while ! (cAliasQry)->( EOF() )
		(cTabela)->( dbGoto( (cAliasQry)->RECORD ) )
		nQtd++
		(cAliasQry)->( dbSkip() )
	end

	if Select( cAliasQry ) > 0
		dbSelectArea( cAliasQry )
		dbCloseArea()
	endif

	dbSelectArea( cAlias )
Return nQtd
