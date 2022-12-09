#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE110BT ºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para adicao de botoes na MBrowse          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390 - ORCAMENTO CONTABIL                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSE110BT(aRotPad)

ADD OPTION aRotina Title "Importar " Action 'U_CSE110IP'  OPERATION 3 ACCESS 0 //Alterar
ADD OPTION aRotina Title "Exportar " Action 'U_CSE110EP'  OPERATION 4 ACCESS 0 //Alterar
ADD OPTION aRotina Title "Exportar Layout 2016" Action 'U_CSPCO11A'  OPERATION 6 ACCESS 0 //Alterar

RETURN aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE110BE ºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para adicao de botoes na EnchoiceBar      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390 - ORCAMENTO CONTABIL                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSE110BE(aButtonPad)

LOCAL aButtons    := {}

//Define teclas de atalho para os botoes da enchoice
SetKey( VK_F8, {|| GdSeek(oGet,"Pesquisar",aHeader,aColsP,.F.)} )

//Definicao dos botoes adicionais da enchoice
aAdd( aButtons, { "PMSPESQ",{|| GdSeek(oGet,"Pesquisar",aHeader,aColsP    ,.F.)}, "Pesquisar", "Pesquisar - <F8>"})

RETURN aButtons

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE110GR ºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para liberacao do orcamento na gravacao   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390 - ORCAMENTO CONTABIL                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CSE110GR(nOpcx, aDadosCV1)

LOCAL aArea     := GetArea()
LOCAL aAreaCV2 := CV2->(GetArea())

IF nOpcx == 4 // SOMENTE NA ALTERACAO
	DbSelectArea("CV2")
	DbSetOrder(1)
	DbSeek(xFilial("CV2")+aDadosCV1[1]+aDadosCV1[2]+aDadosCV1[3]+aDadosCV1[4])
	IF CV2->CV2_MSBLQL == "1"
		Reclock("CV2",.F.)
		CV2->CV2_MSBLQL := "2"
		MsUnlock()
	ENDIF
ENDIF
RETURN Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE110IP ºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao do orcamento em formato .CSV                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSE110IP(cAlias,nOpc,nRecno)

Local aArea            := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)                      ³
//³ MV_PAR01   - Arquivo a importar:                                        ³
//³ MV_PAR02   - Orcamento:                                                 ³
//³ MV_PAR03   - Calendario:                                                ³
//³ MV_PAR04   - Moeda:                                                     ³
//³ MV_PAR05   - Revisao:                                                   ³
//³ MV_PAR06   - Modo de importacao: (Novo orcamento/Nova revisao)          ³
//³ MV_PAR07   - Exibe orcamento para edicao: (Sim/Nao)                     ³
//³ MV_PAR08   - Layout de importacao       : (Padrao / CertiSign)          ³
//³ MV_PAR09   - Validar estrutura de campos: (Sim/Nao)                     ³
//³ MV_PAR10   - Converte formato de valores: (Sim/Nao)                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF CSE110PBI()  .AND.;//Parambox da rotina de importacao do orcamento
	ApMsgNoYes(    "Confirma a importacao do arquivo de orcamento selecionado ?","ORCAMENTO CONTABIL: Importacao")
	MsgRun("Importando orcamento contabil...","ORCAMENTO CONTABIL: Importacao",{|| CSE110IMP(cAlias,nOpc,nRecno)})
ENDIF

RestArea(aArea)
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE110IMPºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao do orcamento em formato .CSV                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE110IMP(cAlias,nOpc,nRecno)

Local aArea            := GetArea()
Local cLine            :=    ""
Local aField         := {{},{}}
Local aData           := {{},{}}
Local aTempRead    := {}
Local aTempData    := {}
Local nLenFields    := 0
Local nLenData        := 0
Local lProcess        := .T.
Local nModo            := 0
Local lConverte    := MV_PAR10 == 1
Local nX,nY,nZ                            
Local nContLinh   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Identificadores das posicoes dos alias nos arrays de trabalho              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAlias        := {"CV2","CV1"}
Local nPosAlias    := 0
Local cAliasCab    := "CV2"
Local aAliasIt        := {"CV1"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indica se irah gerar o cadastro de orcamento bloqueado, e qual o campo     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lMsBlQl        := .T.
Local cFieldBlq    := "CV2_MSBLQL"
Local nPosField    := 0
Local nPosCV2DSC:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do processamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validacoes preliminares                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	HELP(" ",1,"CSE110IMP.01",,"Nao foi possivel abrir o arquivo selecionado para importacao.",4,0)//"Nao foi possivel abrir o arquivo selecionado para importacao."
	lProcess := .F.
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1a Etapa: Leitura do arquivo em conversao nos arrays de trabalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess
	
	WHILE !FT_FEOF()		
		cLine := FT_FREADLN()
		nContLInh ++ 
		cLine := cLine + ';'
		
		While ( At( ';' + ';', cLine ) > 0 )
			cLine := StrTran( cLine, ( ';' + ';' ), ( ';' + " " + ';' ) )
		End
		
		aTempRead := StrToKArr(cLine,";")
		
		IF aTempRead[1] == "0" // Linhas de estrutura de campos
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0
				
				// Elimina as duas primeiras posicoes: Identificador e Alias
				For nX := 3 To Len(aTempRead)
					If AllTrim(aTempRead[nX]) <> ""
						aAdd(aField[nPosAlias],{aTempRead[nX],X3TIPO(aTempRead[nX])})
					EndIf
				Next nX
				
			Else
				Help(" ",1,"CSE110IMP.02",,    "Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
				"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF
			
		ELSEIF aTempRead[1] $ "1/2"    // Linha de dados: CV2(1) e CV1(2)
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0
				
				aTempData := {}
				
				
				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 1 TO LEN( aField[nPosAlias] ) //LEN(aField[Len(aField)])
					
					If Len(aTempRead) < Len(aField[nPosAlias])
						
						Aviso("Atencao","Linha " + AllTrim(Str(nContLinh)) + " com divergencia - " + cLine + " Processo será interrompido",{"Ok"}) 
						Return 
					
					EndIf
						

					If aField[ nPosAlias, nX, 1 ] == "CV2_APROVA"
						AADD(aTempData,cUserName)
					Else                
						AADD(aTempData,aTempRead[nX+2])
					Endif
					
				NEXT nX
				
				AADD(aData[nPosAlias],aClone(aTempData))
				
			ELSE
				HELP(" ",1,"CSE110IMP.03",,    "Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
				"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF
			
		ELSE
			HELP(" ",1,"CSE110IMP.04",,    "Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
			"Identificador de linha invalido: "+aTempRead[1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
			lProcess := .F.
			EXIT
		ENDIF
		FT_FSKIP()
		
	END
	
	FT_FUSE()
	FCLOSE(nHandle)
	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³2a Etapa: Validacao da estrutura de campos e conteudos dos arrays³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.1: Valida se existe no alias de cabecalho o campo para bloqueio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lMsBlQl
		
		nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(cAliasCab)})
		
		IF (aAlias[nPosAlias])->(FieldPos(ALLTRIM(cFieldBlq))) == 0
			
			HELP(" ",1,"CSE110IMP.05",,    "Nao existe no sistema para o arquivo de cabecalho: "+aAlias[nPosAlias]+" "+CRLF+;
			"o campo de bloqueio necessario para o cadastro : "+ALLTRIM(cFieldBlq),4,0)
			lProcess := .F.
			
		ENDIF
		
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.2: Validacao da quantidade de estruturas de campos x Alias     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF LEN(aField) != LEN(aAlias)
		
		HELP(" ",1,"CSE110IMP.06",,    "Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
		"Quantidade de estruturas suportadas/necessarias: "+STRZERO(LEN(aAlias))+CRLF+;
		"Quantidade de estruturas informadas no arquivo : "+STRZERO(LEN(aField))+CRLF,4,0)
		lProcess := .F.
		
	ELSE
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.3: Validacao do dicionario de dados x estrutura de campos      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF MV_PAR09 == 1
			FOR nX := 1 TO LEN(aAlias) // 1-> CV2 / 2-> CV1
				
				FOR nY := 1 TO LEN(aField[nX])
					
					IF (aAlias[nX])->(FieldPos(aField[nX][nY][1])) == 0
						
						HELP(" ",1,"CSE110IMP.07",,    "Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
						"Campo invalido: "+aField[nX][nY][1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
						lProcess := .F.
						EXIT
						
					ENDIF
					
				NEXT nY
				
			NEXT nX
		ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.4: Validacao da quantidade de itens das linhas de dados x campos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nX := 1 TO LEN(aAlias)
			
			nLenFields := Len(aField[nX])
			
			FOR nY := 1 TO LEN(aData[nX])
				
				nLenData := Len(aData[nX][nY])
				
				IF nLenData != nLenFields
					
					HELP(" ",1,"CSE110IMP.08",,    "Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
					"Quantidade de campos invalida: "+CRLF+;
					"Alias: "+aAlias[nX]    +" / Campos: "+STRZERO(nLenFields)+CRLF+;
					"Linha: "+STRZERO(nY)    +" / Campos: "+STRZERO(nLenData)+" .",4,0)
					lProcess := .F.
					EXIT
					
				ENDIF
				
			NEXT nY
			
		NEXT nX
		
	ENDIF
	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3a Etapa: Efetua a gravacao das tabelas CV1 e CV2 conforme o modo³
//³definido para a importacao: Novo orcamento ou Nova Revisao        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lProcess
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3.1: Validacao dos parametros de importacao em funcao do modo    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("CV2")
	DbSetOrder(1) //CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA
	lFind := CV2->(DbSeek(xFilial("CV2")+MV_PAR02+MV_PAR03+MV_PAR04+MV_PAR05))
	
	Do Case
		Case lFind .And. mv_par06 == 1 //Encontrou orcamento e o modo definido foi "Novo Orcamento"
			
			If Aviso("Importacao do orcamento",;
				"Existe um orcamento cadastrado com as informacoes de importacao selecionadas."+CRLF+;
				"Deseja gerar uma nova revisao ou finalizar o processo?",;
				{"Revisar","Finalizar"}) == 1
				cRevisao := CSE110PROX(CV2_FILIAL,CV2_ORCMTO,CV2_CALEND,CV2_MOEDA,CV2_REVISA)
				nModo     := 2 // Revisao para um orcamento jah existente
			Else
				lProcess := .F.
			EndIf
			
		Case lFind .And. mv_par06 == 2 //Encontrou orcamento e o modo definido foi "Nova Revisao"
			
			cRevisao := CSE110PROX(CV2_FILIAL,CV2_ORCMTO,CV2_CALEND,CV2_MOEDA,CV2_REVISA)
			nModo     := 2 // Revisao para um orcamento jah existente
			
		Case !lFind .And. mv_par06 == 1// Nao encontrou orcamento e o modo definido foi "Novo Orcamento"
			
			cRevisao := "0000"     // Para importacao, a primeira revisao eh a "0000" para diferenciar do processo de inclusao manual
			nModo     := 1         // Novo orcamento
			
		Case !lFind .And. MV_PAR06 == 2 // Nao encontrou orcamento e o modo definido foi "Nova Revisao"
			
			If Aviso("Importacao do orcamento",;
				"Nao existe um orcamento cadastrado com as informacoes de importacao selecionadas."+CRLF+;
				"Deseja incluir um novo orcamento ou finalizar o processo?",;
				{"Incluir","Finalizar"}) == 1
				cRevisao := "0000" // Para importacao, a primeira revisao eh a "0000" para diferenciar do processo de inclusao manual
				nModo     := 1         // Novo orcamento
				
			Else
				lProcess := .F.
			EndIf
			
	EndCase
	
	IF lProcess
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ INICIO DA TRANSACAO                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BEGIN TRANSACTION
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.2: Gravacao do cabecalho do orcamento contabil em funcao do modo ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea(cAliasCab)
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(cAliasCab)})) > 0
			
			FOR nX := 1 TO Len(aData[nPosAlias])
				
				RecLock(cAliasCab,.T.)
				
				FOR nY := 1 TO Len(aField[nPosAlias])
					
					IF (cAliasCab)->(FieldPos(aField[nPosAlias][nY][1])>0)
						
						IF         ALLTRIM(aField[nPosAlias][nY][1]) == "CV2_FILIAL"
							
							FieldPut(FieldPos(aField[nPosAlias][nY][1]), xFilial(cAliasCab) )
							
						ELSEIF    ALLTRIM(aField[nPosAlias][nY][1]) == "CV2_ORCMTO"
							
							FieldPut(FieldPos(aField[nPosAlias][nY][1]), MV_PAR02 )     // ORCAMENTO
							
						ELSEIF    ALLTRIM(aField[nPosAlias][nY][1]) == "CV2_STATUS"
							
							FieldPut(FieldPos(aField[nPosAlias][nY][1]), "1" )            // 1-ABERTO; 2-GERADO SALDO; 3-REVISADO;
							
						ELSEIF    ALLTRIM(aField[nPosAlias][nY][1]) == "CV2_CALEND"
							
							FieldPut(FieldPos(aField[nPosAlias][nY][1]), MV_PAR03 )     // CALENDARIO
							
						ELSEIF    ALLTRIM(aField[nPosAlias][nY][1]) == "CV2_MOEDA"
							
							FieldPut(FieldPos(aField[nPosAlias][nY][1]), MV_PAR04 )     // MOEDA
							
						ELSEIF    ALLTRIM(aField[nPosAlias][nY][1]) == "CV2_REVISA"
							
							FieldPut(FieldPos(aField[nPosAlias][nY][1]), cRevisao )
							
						ELSEIF    ALLTRIM(aField[nPosAlias][nY][1]) == ALLTRIM(cFieldBlq)
							
							FieldPut(FieldPos(aField[nPosAlias][nY][1]), "2" )    // 1-SIM; 2-NAO
							
						ELSE
							
							DO CASE
								CASE aField[nPosAlias][nY][2] == "C"
									FieldPut(FieldPos(aField[nPosAlias][nY][1]), NoAcento(ALLTRIM(aData[nPosAlias][nX][nY])) )
								CASE aField[nPosAlias][nY][2] == "L"
									FieldPut(FieldPos(aField[nPosAlias][nY][1]), IIf( ALLTRIM(aData[nPosAlias][nX][nY]) == "T", .T., .F. ) )
								CASE aField[nPosAlias][nY][2] == "D"
									FieldPut(FieldPos(aField[nPosAlias][nY][1]), STOD( ALLTRIM(aData[nPosAlias][nX][nY]) ) )
								CASE aField[nPosAlias][nY][2] == "N"
									FieldPut(FieldPos(aField[nPosAlias][nY][1]), ValFormat( ALLTRIM(aData[nPosAlias][nX][nY]),lConverte ) )
								CASE aField[nPosAlias][nY][2] == "M"
									FieldPut(FieldPos(aField[nPosAlias][nY][1]), NoAcento(ALLTRIM(aData[nPosAlias][nX][nY])) )
							ENDCASE
							
						ENDIF
						
					ENDIF
					
				NEXT nY
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³3.2.1: Gravacao do campo de bloqueio do cabecalho do orcamento     ³
				//³       Tratamento para garantir o bloqueio mesmo se o campo nao     ³
				//³       existir no arquivo importado.                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//FieldPut(FieldPos(ALLTRIM(cFieldBlq)), "1" ) // 1-SIM; 2-NAO
				MsUnlock()
				
			NEXT nX
			
		ELSE
			HELP(" ",1,"CSE110IMP.09",,    "Erro na gravacao dos dados do arquivo de cabecalho."+CRLF+;
			"Alias de cabecalho: "+cAliasCab,4,0)
			lProcess := .F.
			DisarmTransaction()
		ENDIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.3: Gravacao dos itens do orcamento contabil em funcao do modo    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campos do CV2 que serao referenciados pelo CV1                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPosCV2DSC := aScan(aField[1],{|aFieldsCV2| ALLTRIM(aFieldsCV2[1]) == "CV2_DESCRI" })
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.3.0: Tratamento de layout especifico CERTISIGN                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF         MV_PAR08 == 2 // LAYOUT CERTISIGN 2013D
			CSPCO2016D(aAlias, @aAliasIt, @aData, @aField, cRevisao)
		ELSEIF     MV_PAR08 == 3 // LAYOUT CERTISIGN 2013R
			CSPCO2016R(aAlias, @aAliasIt, @aData, @aField, cRevisao)
		ELSEIF     MV_PAR08 == 4 // LAYOUT CERTISIGN 2014D
			CSELT2014D(aAlias, @aAliasIt, @aData, @aField, cRevisao)
		ELSEIF     MV_PAR08 == 5 // LAYOUT CERTISIGN 2014R
			CSELT2014R(aAlias, @aAliasIt, @aData, @aField, cRevisao)
		ENDIF
		
		FOR nX := 1 TO Len(aAliasIt)
			
			DbSelectArea(aAliasIt[nX])
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0
				
				FOR nY := 1 TO Len(aData[nPosAlias])
					
					RecLock(aAliasIt[nX],.T.)
					
					FOR nZ := 1 TO Len(aField[nPosAlias])
						
						IF (aAliasIt[nX])->(FieldPos(aField[nPosAlias][nZ][1])>0)
							
							IF         ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_FILIAL"
								
								FieldPut(FieldPos(aField[nPosAlias][nZ][1]), xFilial(aAliasIt[nX]) )
								
							ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_ORCMTO"
								
								FieldPut(FieldPos(aField[nPosAlias][nZ][1]), MV_PAR02 )     // ORCAMENTO
								
							ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_STATUS"
								
								FieldPut(FieldPos(aField[nPosAlias][nZ][1]), "1" )            // 1-ABERTO; 2-GERADO SALDO; 3-REVISADO;
								
							ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CALEND"
								
								FieldPut(FieldPos(aField[nPosAlias][nZ][1]), MV_PAR03 )     // CALENDARIO
								
							ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_MOEDA"
								
								FieldPut(FieldPos(aField[nPosAlias][nZ][1]), MV_PAR04 )     // MOEDA
								
							ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_REVISA"
								
								FieldPut(FieldPos(aField[nPosAlias][nZ][1]), cRevisao )
								
							ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_DESCRI" .AND. nPosCV2DSC > 0
								
								FieldPut(FieldPos(aField[nPosAlias][nZ][1]), NoAcento(ALLTRIM(aData[1][1][nPosCV2DSC])) )
								
							ELSE
								
								DO CASE
									CASE aField[nPosAlias][nZ][2] == "C"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])) )
									CASE aField[nPosAlias][nZ][2] == "L" .AND. ValType(aData[nPosAlias][nY][nZ]) == "C"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), IIf( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. ) )
									CASE aField[nPosAlias][nZ][2] == "L" .AND. ValType(aData[nPosAlias][nY][nZ]) == "L"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), aData[nPosAlias][nY][nZ] )
									CASE aField[nPosAlias][nZ][2] == "D" .AND. ValType(aData[nPosAlias][nY][nZ]) == "C"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), STOD( ALLTRIM(aData[nPosAlias][nY][nZ]) ) )
									CASE aField[nPosAlias][nZ][2] == "D" .AND. ValType(aData[nPosAlias][nY][nZ]) == "D"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), aData[nPosAlias][nY][nZ] )
									CASE aField[nPosAlias][nZ][2] == "N" .AND. ValType(aData[nPosAlias][nY][nZ]) == "C"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte ) )
									CASE aField[nPosAlias][nZ][2] == "N" .AND. ValType(aData[nPosAlias][nY][nZ]) == "N"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), aData[nPosAlias][nY][nZ] )
									CASE aField[nPosAlias][nZ][2] == "M"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])) )
								ENDCASE
								
							ENDIF
							
						ENDIF
						
					NEXT nZ
					
					MsUnlock()
					
				NEXT nY
				
			ELSE
				HELP(" ",1,"CSE110IMP.10",,    "Erro na gravacao dos dados nos arquivos de itens."+CRLF+;
				"Alias de itens: "+aAliasIt[nX],4,0)
				lProcess := .F.
				DisarmTransaction()
				EXIT
			ENDIF
			
		NEXT nX
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.4: Se revisao encerra a versao anterior do orcamento contabil    ³
		//³     Garante que todas as revisoes anteriores estao encerradas      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lProcess .AND. nModo == 2 // REVISAO PARA UM ORCAMENTO EXISTENTE
			
			DbSelectArea(cAliasCab)
			DbSetOrder(1) //CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA
			DbSeek(xFilial(cAliasCab)+MV_PAR02+MV_PAR03+MV_PAR04)
			WHILE     (cAliasCab)->(!EOF()) .AND.;
				(cAliasCab)->CV2_FILIAL == xFilial(cAliasCab) .AND.;
				(cAliasCab)->(CV2_ORCMTO+CV2_CALEND+CV2_MOEDA) == +MV_PAR02+MV_PAR03+MV_PAR04 .AND.;
				(cAliasCab)->CV2_REVISA < cRevisao
				
				IF (cAliasCab)->CV2_STATUS != "3" // REVISADO
					
					RecLock(cAliasCab,.F.)
					(cAliasCab)->CV2_STATUS := "3" // REVISADO
					MsUnlock()
					
					FOR nX := 1 TO Len(aAliasIT)
						
						DbSelectArea(aAliasIT[nX])
						DbSetOrder(1)
						DbSeek((cAliasCab)->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA))
						
						WHILE     (aAliasIT[nX])->(!EOF()) .AND.;
							(aAliasIT[nX])->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA) ==;
							(cAliasCab)->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA)
							
							RecLock(aAliasIT[nX],.F.)
							(aAliasIT[nX])->CV1_STATUS := "3" // REVISADO
							MsUnlock()
							
							(aAliasIT[nX])->(DbSkip())
						END
						
					NEXT nX
					
					
				ENDIF
				
				(cAliasCab)->(DbSkip())
			END
			
		ENDIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FIM DA TRANSACAO                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		END TRANSACTION
	ENDIF
ENDIF

IF lProcess
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³4.0: Se o orcamento foi importado com sucesso exibe o mesmo para   ³
	//³     edicao, conforme parametro MV_PAR07, senao encerra.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF MV_PAR07 == 1 // Exibe orcamento para edicao
		PERGUNTE("CTB390", .F.)
		Ctb390Cad(,,4)
	ELSE
		Aviso("Processameto concluido",    "Importacao do orcamento efetuada com sucesso."+CRLF+;
		"Favor proceder com a conferencia e liberacao do orcamento.",{"Concluir"})
	ENDIF
	
ELSE
	Aviso("Processamento com criticas","Nao foi possivel efetuar a importacao do orcamento.",{"Concluir"})
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSELT2013DºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TRATAMENTO ESPECIFICO PARA O LAYOUT DOS ITENS: LAYOUT 2013Dº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSELT2013D(aAlias, aAliasIt, aData, aField, cRevisao)

LOCAL aArea             := GetArea()
LOCAL cExerc         := GetAdvFVal("CTG","CTG_EXERC",xFilial("CTG")+MV_PAR03,1,"")
LOCAL aFieldTRB     := {}
LOCAL aDataCV1      := {}
LOCAL aDadosCV1     := {}
LOCAL aPeriodos     := {}
LOCAL nPeriodo        := 0
LOCAL nSeqCV1         := 0
LOCAL nItemCV1         := 0
LOCAL nPosAlias     := 0
LOCAL nPosField     := 0
LOCAL nW            := 0
LOCAL nX            := 0
LOCAL nY            := 0
LOCAL nZ            := 0
LOCAL lConverte     := MV_PAR10 == 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de controle da posicao dos campos de entidades do CV1            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nPosCT1INI    := 0
LOCAL nPosCTTINI    := 0
LOCAL nPosCTDINI    := 0
LOCAL nPosCTHINI    := 0
LOCAL nPosE05INI    := 0
LOCAL nPosE06INI    := 0
LOCAL nPosE07INI    := 0
LOCAL nPosE08INI    := 0
LOCAL nPosAKFINI    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array aFieldTRB com a nova estrutura do CV1 que devera ser gravada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldTRB,{"CV1_FILIAL","C"})
AADD(aFieldTRB,{"CV1_ORCMTO","C"})
AADD(aFieldTRB,{"CV1_DESCRI","C"})
AADD(aFieldTRB,{"CV1_STATUS","C"})
AADD(aFieldTRB,{"CV1_CALEND","C"})
AADD(aFieldTRB,{"CV1_MOEDA","C"})
AADD(aFieldTRB,{"CV1_REVISA","C"})
AADD(aFieldTRB,{"CV1_SEQUEN","C"})
AADD(aFieldTRB,{"CV1_CT1INI","C"})
AADD(aFieldTRB,{"CV1_CT1FIM","C"})
AADD(aFieldTRB,{"CV1_CTTINI","C"})
AADD(aFieldTRB,{"CV1_CTTFIM","C"})
AADD(aFieldTRB,{"CV1_CTDINI","C"})
AADD(aFieldTRB,{"CV1_CTDFIM","C"})
AADD(aFieldTRB,{"CV1_CTHINI","C"})
AADD(aFieldTRB,{"CV1_CTHFIM","C"})
AADD(aFieldTRB,{"CV1_PERIOD","C"})
AADD(aFieldTRB,{"CV1_DTINI","D"})
AADD(aFieldTRB,{"CV1_DTFIM","D"})
AADD(aFieldTRB,{"CV1_VALOR","N"})
AADD(aFieldTRB,{"CV1_APROVA","C"})
AADD(aFieldTRB,{"CV1_E05INI","C"})
AADD(aFieldTRB,{"CV1_E05FIM","C"})
AADD(aFieldTRB,{"CV1_E06INI","C"})
AADD(aFieldTRB,{"CV1_E06FIM","C"})
AADD(aFieldTRB,{"CV1_E07INI","C"})
AADD(aFieldTRB,{"CV1_E07FIM","C"})
AADD(aFieldTRB,{"CV1_E08INI","C"})
AADD(aFieldTRB,{"CV1_E08FIM","C"})
AADD(aFieldTRB,{"CV1_OPER","C"})
AADD(aFieldTRB,{"CV1_TIPOIT","C"})
AADD(aFieldTRB,{"CV1_DESCIT","C"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o conteudo das variaveis de controle de posicao das entidades     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosCT1INI    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
nPosCTTINI    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTINI"})
nPosCTDINI    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDINI"})
nPosCTHINI    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHINI"})
nPosE05INI    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05INI"})
nPosE06INI    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06INI"})
nPosE07INI    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
nPosE08INI    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08INI"})
nPosAKFINI    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_OPER"})
nPosPeriod    := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_PERIOD"})
nPosValor     := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_VALOR"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Zera os arrays padroes para que os mesmos seja recarregados conforme regra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FOR nX := 1 TO Len(aAliasIt)
	
	IF aAliasIt[nX] == "CV1"
		
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0
			
			FOR nY := 1 TO Len(aData[nPosAlias])
				
				aDadosCV1 := Array(Len(aFieldTRB))
				aPeriodos := {0,0,0,0,0,0,0,0,0,0,0,0}
				
				FOR nZ := 1 TO Len(aField[nPosAlias])
					
					IF         ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_FILIAL"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_FILIAL"})
						
						aDadosCV1[nPosField] := xFilial("CV1")
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_ORCMTO"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_ORCMTO"})
						
						aDadosCV1[nPosField] := MV_PAR02 // ORCAMENTO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_STATUS"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_STATUS"})
						
						aDadosCV1[nPosField] := "1"            // 1-ABERTO; 2-GERADO SALDO; 3-REVISADO;
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CALEND"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CALEND"})
						
						aDadosCV1[nPosField] := MV_PAR03     // CALENDARIO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_MOEDA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_MOEDA"})
						
						aDadosCV1[nPosField] := MV_PAR04    // MOEDA
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_REVISA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_REVISA"})
						
						aDadosCV1[nPosField] := cRevisao
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CT1DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CT1","CT1_CONTA",xFilial("CT1")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),6,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTTDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTT","CTT_CUSTO",xFilial("CTT")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTDDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTD","CTD_ITEM",xFilial("CTD")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTHDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTH","CTH_CLVL",xFilial("CTH")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_AKFDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_OPER"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("AKF","AKF_CODIGO",xFilial("AKF")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),2,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E05DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"05"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E06DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"06"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E07DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E08DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"08"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_VALOR"
						
						nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CV1_PERIOD"})
						
						nPeriodo  := VAL(ALLTRIM(aData[nPosAlias][nY][nPosField]))
						
						IF aPeriodos[nPeriodo] == Nil .OR. aPeriodos[nPeriodo] == 0
							
							aPeriodos[nPeriodo] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PERIOD"
						
						nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CV1_VALOR"})
						
						nPeriodo  := VAL(ALLTRIM(aData[nPosAlias][nY][nZ]) )
						
						IF aPeriodos[nPeriodo] == Nil .OR. aPeriodos[nPeriodo] == 0
							
							aPeriodos[nPeriodo] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nPosField]),lConverte )
							
						ENDIF
						
					ELSE
						
						DO CASE
							CASE aField[nPosAlias][nZ][2] == "C" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "L" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := IIf( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. )
								
							CASE aField[nPosAlias][nZ][2] == "D" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := STOD( ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "N" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
								
							CASE aField[nPosAlias][nZ][2] == "M" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
						ENDCASE
						
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2. Converte e adequa estrutura do arquivo CertiSign para o layout CV1 padrao  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.1. Efetua o tratamento de campos nao presentes no arquivo layout CertiSign  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF aDadosCV1[nZ] == Nil
						aDadosCV1[nZ] := CRIAVAR(ALLTRIM(aFieldTRB[nZ][1]))
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.2. Iguala as para cada entidade os valores finais aos valores iniciais   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF         aFieldTRB[nZ][1] == "CV1_CT1INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTTINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTDINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTHINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E05INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E06INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E07INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E08INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_TPOINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_TPOFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ENDIF
					
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.3. Verifica se jah existe uma linha no CV1 para a combinacao de entidades               ³
				//³        Se nao existir adiciona uma linha no array aDataCV1 para cada um dos 12 periodos     ³
				//³        Se existir efetua a atualizacao das linhas com base nos valores lidos (soma)         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lExistCV1 := ( aScan(aDataCV1,{|aDataCV1|     ALLTRIM(aDataCV1[nPosCT1INI]) == ALLTRIM(aDadosCV1[nPosCT1INI]) .AND.;
				ALLTRIM(aDataCV1[nPosCTTINI]) == ALLTRIM(aDadosCV1[nPosCTTINI]) .AND.;
				ALLTRIM(aDataCV1[nPosCTDINI]) == ALLTRIM(aDadosCV1[nPosCTDINI]) .AND.;
				ALLTRIM(aDataCV1[nPosCTHINI]) == ALLTRIM(aDadosCV1[nPosCTHINI]) .AND.;
				ALLTRIM(aDataCV1[nPosE05INI]) == ALLTRIM(aDadosCV1[nPosE05INI]) .AND.;
				ALLTRIM(aDataCV1[nPosE06INI]) == ALLTRIM(aDadosCV1[nPosE06INI]) .AND.;
				ALLTRIM(aDataCV1[nPosE07INI]) == ALLTRIM(aDadosCV1[nPosE07INI]) .AND.;
				ALLTRIM(aDataCV1[nPosE08INI]) == ALLTRIM(aDadosCV1[nPosE08INI]) .AND.;
				ALLTRIM(aDataCV1[nPosAKFINI]) == ALLTRIM(aDadosCV1[nPosAKFINI]) } ) ) >0
				
				IF     lExistCV1
					
					FOR nZ := 1 to Len(aPeriodos)
						
						nPosData := ( aScan(aDataCV1,{|aDataCV1|      ALLTRIM(aDataCV1[nPosCT1INI]) == ALLTRIM(aDadosCV1[nPosCT1INI]    ) .AND.;
						ALLTRIM(aDataCV1[nPosCTTINI]) == ALLTRIM(aDadosCV1[nPosCTTINI]    ) .AND.;
						ALLTRIM(aDataCV1[nPosCTDINI]) == ALLTRIM(aDadosCV1[nPosCTDINI]    ) .AND.;
						ALLTRIM(aDataCV1[nPosCTHINI]) == ALLTRIM(aDadosCV1[nPosCTHINI]    ) .AND.;
						ALLTRIM(aDataCV1[nPosE05INI]) == ALLTRIM(aDadosCV1[nPosE05INI]    ) .AND.;
						ALLTRIM(aDataCV1[nPosE06INI]) == ALLTRIM(aDadosCV1[nPosE06INI]    ) .AND.;
						ALLTRIM(aDataCV1[nPosE07INI]) == ALLTRIM(aDadosCV1[nPosE07INI]    ) .AND.;
						ALLTRIM(aDataCV1[nPosE08INI]) == ALLTRIM(aDadosCV1[nPosE08INI]    ) .AND.;
						ALLTRIM(aDataCV1[nPosAKFINI]) == ALLTRIM(aDadosCV1[nPosAKFINI]    ) .AND.;
						ALLTRIM(aDataCV1[nPosPeriod]) == STRZERO(nZ,2)    }                 ) )
						
						aDataCV1[nPosData][nPosValor] += aPeriodos[nZ]
						
					NEXT nZ
					
				ELSE
					
					nSeqCV1++
					FOR nZ := 1 to Len(aPeriodos)
						
						AADD(aDataCV1,Array(Len(aFieldTRB)))
						nItemCV1++
						
						FOR nW := 1 to Len(aFieldTRB)
							
							IF        aFieldTRB[nW][1] == "CV1_SEQUEN"
								aDataCV1[nItemCV1][nW] := STRZERO(nSeqCV1,4)
							ELSEIF    aFieldTRB[nW][1] == "CV1_PERIOD"
								aDataCV1[nItemCV1][nW] := STRZERO(nZ,2)
							ELSEIF    aFieldTRB[nW][1] == "CV1_VALOR"
								aDataCV1[nItemCV1][nW] := aPeriodos[nZ]
							ELSEIF    aFieldTRB[nW][1] == "CV1_DTINI"
								aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTINI",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
							ELSEIF    aFieldTRB[nW][1] == "CV1_DTFIM"
								aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTFIM",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
							ELSE
								aDataCV1[nItemCV1][nW] := aDadosCV1[nW]
							ENDIF
							
						NEXT nW
					NEXT nZ
					
				ENDIF
				
			NEXT nY
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega arrays com a nova estrutura e dados jah tratados para a CertiSign  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aField[nPosAlias]     := aClone(aFieldTRB)
			aData[nPosAlias]     := aClone(aDataCV1)
			
		ENDIF
		
	ENDIF
	
NEXT nX

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSELT2013RºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TRATAMENTO ESPECIFICO PARA O LAYOUT DOS ITENS: LAYOUT 2013Rº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSELT2013R(aAlias, aAliasIt, aData, aField, cRevisao)

LOCAL aArea             := GetArea()
LOCAL cExerc         := GetAdvFVal("CTG","CTG_EXERC",xFilial("CTG")+MV_PAR03,1,"")
LOCAL aFieldTRB     := {}
LOCAL aDataCV1      := {}
LOCAL aDadosCV1     := {}
LOCAL aPeriodos     := {}
LOCAL nSeqCV1         := 0
LOCAL nItemCV1         := 0
LOCAL nPosAlias     := 0
LOCAL nPosField     := 0
LOCAL nPosCT1INI    := 0
LOCAL nPosCV1DTI    := 0
LOCAL nW            := 0
LOCAL nX            := 0
LOCAL nY            := 0
LOCAL nZ            := 0
LOCAL lConverte     := MV_PAR10 == 1
LOCAL cDadosTMP        := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array aFieldTRB com a nova estrutura do CV1 que devera ser gravada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldTRB,{"CV1_FILIAL","C"})
AADD(aFieldTRB,{"CV1_ORCMTO","C"})
AADD(aFieldTRB,{"CV1_DESCRI","C"})
AADD(aFieldTRB,{"CV1_STATUS","C"})
AADD(aFieldTRB,{"CV1_CALEND","C"})
AADD(aFieldTRB,{"CV1_MOEDA","C"})
AADD(aFieldTRB,{"CV1_REVISA","C"})
AADD(aFieldTRB,{"CV1_SEQUEN","C"})
AADD(aFieldTRB,{"CV1_CT1INI","C"})
AADD(aFieldTRB,{"CV1_CT1FIM","C"})
AADD(aFieldTRB,{"CV1_CTTINI","C"})
AADD(aFieldTRB,{"CV1_CTTFIM","C"})
AADD(aFieldTRB,{"CV1_CTDINI","C"})
AADD(aFieldTRB,{"CV1_CTDFIM","C"})
AADD(aFieldTRB,{"CV1_CTHINI","C"})
AADD(aFieldTRB,{"CV1_CTHFIM","C"})
AADD(aFieldTRB,{"CV1_PERIOD","C"})
AADD(aFieldTRB,{"CV1_DTINI","D"})
AADD(aFieldTRB,{"CV1_DTFIM","D"})
AADD(aFieldTRB,{"CV1_VALOR","N"})
AADD(aFieldTRB,{"CV1_APROVA","C"})
AADD(aFieldTRB,{"CV1_E05INI","C"})
AADD(aFieldTRB,{"CV1_E05FIM","C"})
AADD(aFieldTRB,{"CV1_E06INI","C"})
AADD(aFieldTRB,{"CV1_E06FIM","C"})
AADD(aFieldTRB,{"CV1_E07INI","C"})
AADD(aFieldTRB,{"CV1_E07FIM","C"})
AADD(aFieldTRB,{"CV1_E08INI","C"})
AADD(aFieldTRB,{"CV1_E08FIM","C"})
AADD(aFieldTRB,{"CV1_OPER","C"})
AADD(aFieldTRB,{"CV1_TIPOIT","C"})
AADD(aFieldTRB,{"CV1_DESCIT","C"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega variaveis utilizadas nos posicionamentos dos campos nos arrays     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosCT1INI := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
nPosCV1DTI := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_DESCIT"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre os ALIAS especiais utilizados pela funcao GetAdvFVal()                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("AKF")
DbSetOrder(1)

DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("CV0")
DbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Zera os arrays padroes para que os mesmos seja recarregados conforme regra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FOR nX := 1 TO Len(aAliasIt)
	
	IF aAliasIt[nX] == "CV1"
		
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0
			
			FOR nY := 1 TO Len(aData[nPosAlias])
				
				aDadosCV1 := Array(Len(aFieldTRB))
				aPeriodos := Array(12)
				
				FOR nZ := 1 TO Len(aField[nPosAlias])
					
					IF         ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_FILIAL"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_FILIAL" })
						
						aDadosCV1[nPosField] := xFilial("CV1")
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_ORCMTO"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_ORCMTO"})
						
						aDadosCV1[nPosField] := MV_PAR02 // ORCAMENTO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_STATUS"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_STATUS"})
						
						aDadosCV1[nPosField] := "1"            // 1-ABERTO; 2-GERADO SALDO; 3-REVISADO;
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CALEND"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CALEND"})
						
						aDadosCV1[nPosField] := MV_PAR03     // CALENDARIO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_MOEDA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_MOEDA"})
						
						aDadosCV1[nPosField] := MV_PAR04    // MOEDA
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_REVISA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_REVISA"})
						
						aDadosCV1[nPosField] := cRevisao
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CT1INI"
						
						IF EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))
							
							nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
							
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
								aDadosCV1[nPosCT1INI] := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
								
							ELSEIF !EMPTY(aDadosCV1[nPosField])
								
								aDadosCV1[nPosCT1INI] := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aDadosCV1[nPosField]))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
								
							ELSE
								
								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CV1_E07DSC"})
								
								IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
									
									cDadosTMP := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nPosField]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
									
									IF !EMPTY(cDadosTMP)
										
										cDadosTMP := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM( cDadosTMP ))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
										
										IF !EMPTY(cDadosTMP)
											aDadosCV1[nPosCT1INI] := cDadosTMP
										ELSE
											aDadosCV1[nPosCT1INI] := ""
											IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
												aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ELSE
												aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ENDIF
										ENDIF
										
									ELSE
										aDadosCV1[nPosCT1INI] := ""
										IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
											aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ELSE
											aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ENDIF
									ENDIF
									
								ELSEIF !EMPTY(aDadosCV1[nPosField])
									
									cDadosTMP := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aDadosCV1[nPosField]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
									
									IF !EMPTY(cDadosTMP)
										
										cDadosTMP := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM( cDadosTMP ))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
										
										IF !EMPTY(cDadosTMP)
											aDadosCV1[nPosCT1INI] := cDadosTMP
										ELSE
											aDadosCV1[nPosCT1INI] := ""
											IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
												aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ELSE
												aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ENDIF
										ENDIF
										
									ELSE
										aDadosCV1[nPosCT1INI] := ""
										IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
											aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ELSE
											aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ENDIF
									ENDIF
									
								ELSE
									
									aDadosCV1[nPosCT1INI] := ""
									IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
										aDadosCV1[nPosCV1DTI] += "LINHA EM BRANCO: "+STRZERO(nY,12)
									ELSE
										aDadosCV1[nPosCV1DTI] := "LINHA EM BRANCO: "+STRZERO(nY,12)
									ENDIF
									
								ENDIF
								
							ENDIF
							
						ELSE
							
							aDadosCV1[nPosCT1INI] :=    NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ])))
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CT1DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CT1","CT1_CONTA",xFilial("CT1")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),6,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTTDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTT","CTT_CUSTO",xFilial("CTT")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTDDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTD","CTD_ITEM",xFilial("CTD")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTHDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTH","CTH_CLVL",xFilial("CTH")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_AKFDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_OPER"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("AKF","AKF_CODIGO",xFilial("AKF")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),2,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E05DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"05"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E06DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"06"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E07DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E08DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"08"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF     ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_DESCIT"
						
						IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
							aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
						ELSE
							aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER01"
						
						aPeriodos[01] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER02"
						
						aPeriodos[02] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER03"
						
						aPeriodos[03] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER04"
						
						aPeriodos[04] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER05"
						
						aPeriodos[05] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER06"
						
						aPeriodos[06] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER07"
						
						aPeriodos[07] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER08"
						
						aPeriodos[08] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER09"
						
						aPeriodos[09] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER10"
						
						aPeriodos[10] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER11"
						
						aPeriodos[11] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER12"
						
						aPeriodos[12] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSE
						
						DO CASE
							CASE aField[nPosAlias][nZ][2] == "C" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "L" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := IIf( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. )
								
							CASE aField[nPosAlias][nZ][2] == "D" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := STOD( ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "N" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
								
							CASE aField[nPosAlias][nZ][2] == "M" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
						ENDCASE
						
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2. Converte e adequa estrutura do arquivo CertiSign para o layout CV1 padrao  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.1. Efetua o tratamento de campos nao presentes no arquivo layout CertiSign  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF aDadosCV1[nZ] == Nil
						aDadosCV1[nZ] := CRIAVAR(ALLTRIM(aFieldTRB[nZ][1]))
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.2. Iguala as para cada entidade os valores finais aos valores iniciais   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF         aFieldTRB[nZ][1] == "CV1_CT1INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTTINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTDINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTHINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E05INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E06INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E07INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E08INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_TPOINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_TPOFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ENDIF
					
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.3. Adiciona uma linha no array aDataCV1 para cada um dos 12 periodos     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSeqCV1++
				FOR nZ := 1 to Len(aPeriodos)
					
					AADD(aDataCV1,Array(Len(aFieldTRB)))
					nItemCV1++
					
					FOR nW := 1 to Len(aFieldTRB)
						
						IF        aFieldTRB[nW][1] == "CV1_SEQUEN"
							aDataCV1[nItemCV1][nW] := STRZERO(nSeqCV1,4)
						ELSEIF    aFieldTRB[nW][1] == "CV1_PERIOD"
							aDataCV1[nItemCV1][nW] := STRZERO(nZ,2)
						ELSEIF    aFieldTRB[nW][1] == "CV1_VALOR"
							aDataCV1[nItemCV1][nW] := aPeriodos[nZ]
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTINI"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTINI",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTFIM"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTFIM",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSE
							aDataCV1[nItemCV1][nW] := aDadosCV1[nW]
						ENDIF
						
					NEXT nW
					
				NEXT nZ
				
			NEXT nY
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega arrays com a nova estrutura e dados jah tratados para a CertiSign  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aField[nPosAlias]     := aClone(aFieldTRB)
			aData[nPosAlias]    := aClone(aDataCV1)
			
		ENDIF
		
	ENDIF
	
NEXT nX

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSELT2014DºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TRATAMENTO ESPECIFICO PARA O LAYOUT DOS ITENS: LAYOUT 2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSELT2014D(aAlias, aAliasIt, aData, aField, cRevisao)

LOCAL aArea             := GetArea()
LOCAL cExerc         := GetAdvFVal("CTG","CTG_EXERC",xFilial("CTG")+MV_PAR03,1,"")
LOCAL aFieldTRB     := {}
LOCAL aDataCV1      := {}
LOCAL aDadosCV1     := {}
LOCAL aPeriodos     := {}
LOCAL nSeqCV1         := 0
LOCAL nItemCV1         := 0
LOCAL nPosAlias     := 0
LOCAL nPosField     := 0
LOCAL nW            := 0
LOCAL nX            := 0
LOCAL nY            := 0
LOCAL nZ            := 0
LOCAL lConverte     := MV_PAR10 == 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array aFieldTRB com a nova estrutura do CV1 que devera ser gravada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldTRB,{"CV1_FILIAL","C"})
AADD(aFieldTRB,{"CV1_ORCMTO","C"})
AADD(aFieldTRB,{"CV1_DESCRI","C"})
AADD(aFieldTRB,{"CV1_STATUS","C"})
AADD(aFieldTRB,{"CV1_CALEND","C"})
AADD(aFieldTRB,{"CV1_MOEDA","C"})
AADD(aFieldTRB,{"CV1_REVISA","C"})
AADD(aFieldTRB,{"CV1_SEQUEN","C"})
AADD(aFieldTRB,{"CV1_CT1INI","C"})
AADD(aFieldTRB,{"CV1_CT1FIM","C"})
AADD(aFieldTRB,{"CV1_CTTINI","C"})
AADD(aFieldTRB,{"CV1_CTTFIM","C"})
AADD(aFieldTRB,{"CV1_CTDINI","C"})
AADD(aFieldTRB,{"CV1_CTDFIM","C"})
AADD(aFieldTRB,{"CV1_CTHINI","C"})
AADD(aFieldTRB,{"CV1_CTHFIM","C"})
AADD(aFieldTRB,{"CV1_PERIOD","C"})
AADD(aFieldTRB,{"CV1_DTINI","D"})
AADD(aFieldTRB,{"CV1_DTFIM","D"})
AADD(aFieldTRB,{"CV1_VALOR","N"})
AADD(aFieldTRB,{"CV1_APROVA","C"})
AADD(aFieldTRB,{"CV1_E05INI","C"})
AADD(aFieldTRB,{"CV1_E05FIM","C"})
AADD(aFieldTRB,{"CV1_E06INI","C"})
AADD(aFieldTRB,{"CV1_E06FIM","C"})
AADD(aFieldTRB,{"CV1_E07INI","C"})
AADD(aFieldTRB,{"CV1_E07FIM","C"})
AADD(aFieldTRB,{"CV1_E08INI","C"})
AADD(aFieldTRB,{"CV1_E08FIM","C"})
AADD(aFieldTRB,{"CV1_OPER","C"})
AADD(aFieldTRB,{"CV1_TIPOIT","C"})
AADD(aFieldTRB,{"CV1_DESCIT","C"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Zera os arrays padroes para que os mesmos seja recarregados conforme regra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FOR nX := 1 TO Len(aAliasIt)
	
	IF aAliasIt[nX] == "CV1"
		
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0
			
			FOR nY := 1 TO Len(aData[nPosAlias])
				
				aDadosCV1 := Array(Len(aFieldTRB))
				aPeriodos := Array(12)
				
				FOR nZ := 1 TO Len(aField[nPosAlias])
					
					IF         ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_FILIAL"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_FILIAL" })
						
						aDadosCV1[nPosField] := xFilial("CV1")
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_ORCMTO"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_ORCMTO"})
						
						aDadosCV1[nPosField] := MV_PAR02 // ORCAMENTO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_STATUS"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_STATUS"})
						
						aDadosCV1[nPosField] := "1"            // 1-ABERTO; 2-GERADO SALDO; 3-REVISADO;
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CALEND"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CALEND"})
						
						aDadosCV1[nPosField] := MV_PAR03     // CALENDARIO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_MOEDA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_MOEDA"})
						
						aDadosCV1[nPosField] := MV_PAR04    // MOEDA
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_REVISA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_REVISA"})
						
						aDadosCV1[nPosField] := cRevisao
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CT1DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CT1","CT1_CONTA",xFilial("CT1")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),6,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTTDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTT","CTT_CUSTO",xFilial("CTT")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTDDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTD","CTD_ITEM",xFilial("CTD")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTHDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTH","CTH_CLVL",xFilial("CTH")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_AKFDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_OPER"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("AKF","AKF_CODIGO",xFilial("AKF")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),2,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E05DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"05"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E06DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"06"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E07DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E08DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"08"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER01"
						
						aPeriodos[01] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER02"
						
						aPeriodos[02] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER03"
						
						aPeriodos[03] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER04"
						
						aPeriodos[04] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER05"
						
						aPeriodos[05] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER06"
						
						aPeriodos[06] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER07"
						
						aPeriodos[07] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER08"
						
						aPeriodos[08] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER09"
						
						aPeriodos[09] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER10"
						
						aPeriodos[10] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER11"
						
						aPeriodos[11] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER12"
						
						aPeriodos[12] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSE
						
						DO CASE
							CASE aField[nPosAlias][nZ][2] == "C" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "L" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := IIf( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. )
								
							CASE aField[nPosAlias][nZ][2] == "D" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := STOD( ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "N" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
								
							CASE aField[nPosAlias][nZ][2] == "M" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
						ENDCASE
						
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2. Converte e adequa estrutura do arquivo CertiSign para o layout CV1 padrao  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.1. Efetua o tratamento de campos nao presentes no arquivo layout CertiSign  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF aDadosCV1[nZ] == Nil
						aDadosCV1[nZ] := CRIAVAR(ALLTRIM(aFieldTRB[nZ][1]))
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.2. Iguala as para cada entidade os valores finais aos valores iniciais   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF         aFieldTRB[nZ][1] == "CV1_CT1INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTTINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTDINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTHINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E05INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E06INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E07INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E08INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_TPOINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_TPOFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ENDIF
					
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.3. Adiciona uma linha no array aDataCV1 para cada um dos 12 periodos     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSeqCV1++
				FOR nZ := 1 to Len(aPeriodos)
					
					AADD(aDataCV1,Array(Len(aFieldTRB)))
					nItemCV1++
					
					FOR nW := 1 to Len(aFieldTRB)
						
						IF            aFieldTRB[nW][1] == "CV1_SEQUEN"
							aDataCV1[nItemCV1][nW] := STRZERO(nSeqCV1,4)
						ELSEIF    aFieldTRB[nW][1] == "CV1_PERIOD"
							aDataCV1[nItemCV1][nW] := STRZERO(nZ,2)
						ELSEIF    aFieldTRB[nW][1] == "CV1_VALOR"
							aDataCV1[nItemCV1][nW] := aPeriodos[nZ]
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTINI"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTINI",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTFIM"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTFIM",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSE
							aDataCV1[nItemCV1][nW] := aDadosCV1[nW]
						ENDIF
						
					NEXT nW
					
				NEXT nZ
				
			NEXT nY
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega arrays com a nova estrutura e dados jah tratados para a CertiSign  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aField[nPosAlias] := aClone(aFieldTRB)
			aData[nPosAlias]     := aClone(aDataCV1)
			
		ENDIF
		
	ENDIF
	
NEXT nX

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSELT2014RºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TRATAMENTO ESPECIFICO PARA O LAYOUT DOS ITENS: LAYOUT 2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSELT2014R(aAlias, aAliasIt, aData, aField, cRevisao)

LOCAL aArea             := GetArea()
LOCAL cExerc         := GetAdvFVal("CTG","CTG_EXERC",xFilial("CTG")+MV_PAR03,1,"")
LOCAL aFieldTRB     := {}
LOCAL aDataCV1      := {}
LOCAL aDadosCV1     := {}
LOCAL aPeriodos     := {}
LOCAL nSeqCV1         := 0
LOCAL nItemCV1         := 0
LOCAL nPosAlias     := 0
LOCAL nPosField     := 0
LOCAL nPosCT1INI    := 0
LOCAL nPosCV1DTI    := 0
LOCAL nW            := 0
LOCAL nX            := 0
LOCAL nY            := 0
LOCAL nZ            := 0
LOCAL lConverte     := MV_PAR10 == 1
LOCAL cDadosTMP        := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array aFieldTRB com a nova estrutura do CV1 que devera ser gravada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldTRB,{"CV1_FILIAL","C"})
AADD(aFieldTRB,{"CV1_ORCMTO","C"})
AADD(aFieldTRB,{"CV1_DESCRI","C"})
AADD(aFieldTRB,{"CV1_STATUS","C"})
AADD(aFieldTRB,{"CV1_CALEND","C"})
AADD(aFieldTRB,{"CV1_MOEDA","C"})
AADD(aFieldTRB,{"CV1_REVISA","C"})
AADD(aFieldTRB,{"CV1_SEQUEN","C"})
AADD(aFieldTRB,{"CV1_CT1INI","C"})
AADD(aFieldTRB,{"CV1_CT1FIM","C"})
AADD(aFieldTRB,{"CV1_CTTINI","C"})
AADD(aFieldTRB,{"CV1_CTTFIM","C"})
AADD(aFieldTRB,{"CV1_CTDINI","C"})
AADD(aFieldTRB,{"CV1_CTDFIM","C"})
AADD(aFieldTRB,{"CV1_CTHINI","C"})
AADD(aFieldTRB,{"CV1_CTHFIM","C"})
AADD(aFieldTRB,{"CV1_PERIOD","C"})
AADD(aFieldTRB,{"CV1_DTINI","D"})
AADD(aFieldTRB,{"CV1_DTFIM","D"})
AADD(aFieldTRB,{"CV1_VALOR","N"})
AADD(aFieldTRB,{"CV1_APROVA","C"})
AADD(aFieldTRB,{"CV1_E05INI","C"})
AADD(aFieldTRB,{"CV1_E05FIM","C"})
AADD(aFieldTRB,{"CV1_E06INI","C"})
AADD(aFieldTRB,{"CV1_E06FIM","C"})
AADD(aFieldTRB,{"CV1_E07INI","C"})
AADD(aFieldTRB,{"CV1_E07FIM","C"})
AADD(aFieldTRB,{"CV1_E08INI","C"})
AADD(aFieldTRB,{"CV1_E08FIM","C"})
AADD(aFieldTRB,{"CV1_OPER","C"})
AADD(aFieldTRB,{"CV1_TIPOIT","C"})
AADD(aFieldTRB,{"CV1_DESCIT","C"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega variaveis utilizadas nos posicionamentos dos campos nos arrays     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosCT1INI := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
nPosCV1DTI := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_DESCIT"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre os ALIAS especiais utilizados pela funcao GetAdvFVal()                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("AKF")
DbSetOrder(1)

DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("CV0")
DbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Zera os arrays padroes para que os mesmos seja recarregados conforme regra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FOR nX := 1 TO Len(aAliasIt)
	
	IF aAliasIt[nX] == "CV1"
		
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0
			
			FOR nY := 1 TO Len(aData[nPosAlias])
				
				aDadosCV1 := Array(Len(aFieldTRB))
				aPeriodos := Array(12)
				
				FOR nZ := 1 TO Len(aField[nPosAlias])
					
					IF         ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_FILIAL"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_FILIAL"})
						
						aDadosCV1[nPosField] := xFilial("CV1")
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_ORCMTO"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_ORCMTO"})
						
						aDadosCV1[nPosField] := MV_PAR02 // ORCAMENTO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_STATUS"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_STATUS"})
						
						aDadosCV1[nPosField] := "1"            // 1-ABERTO; 2-GERADO SALDO; 3-REVISADO;
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CALEND"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CALEND"})
						
						aDadosCV1[nPosField] := MV_PAR03     // CALENDARIO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_MOEDA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_MOEDA"})
						
						aDadosCV1[nPosField] := MV_PAR04    // MOEDA
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_REVISA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_REVISA"})
						
						aDadosCV1[nPosField] := cRevisao
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CT1INI"
						
						IF EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))
							
							nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
							
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
								aDadosCV1[nPosCT1INI] := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
								
							ELSEIF !EMPTY(aDadosCV1[nPosField])
								
								aDadosCV1[nPosCT1INI] := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aDadosCV1[nPosField]))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
								
							ELSE
								
								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CV1_E07DSC"})
								
								IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
									
									cDadosTMP := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nPosField]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
									
									IF !EMPTY(cDadosTMP)
										
										cDadosTMP := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM( cDadosTMP ))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
										
										IF !EMPTY(cDadosTMP)
											aDadosCV1[nPosCT1INI] := cDadosTMP
										ELSE
											aDadosCV1[nPosCT1INI] := ""
											IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
												aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ELSE
												aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ENDIF
										ENDIF
										
									ELSE
										aDadosCV1[nPosCT1INI] := ""
										IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
											aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ELSE
											aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ENDIF
									ENDIF
									
								ELSEIF !EMPTY(aDadosCV1[nPosField])
									
									cDadosTMP := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aDadosCV1[nPosField]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
									
									IF !EMPTY(cDadosTMP)
										
										cDadosTMP := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM( cDadosTMP ))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
										
										IF !EMPTY(cDadosTMP)
											aDadosCV1[nPosCT1INI] := cDadosTMP
										ELSE
											aDadosCV1[nPosCT1INI] := ""
											IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
												aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ELSE
												aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ENDIF
										ENDIF
										
									ELSE
										aDadosCV1[nPosCT1INI] := ""
										IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
											aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ELSE
											aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ENDIF
									ENDIF
									
								ELSE
									
									aDadosCV1[nPosCT1INI] := ""
									IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
										aDadosCV1[nPosCV1DTI] += "LINHA EM BRANCO: "+STRZERO(nY,12)
									ELSE
										aDadosCV1[nPosCV1DTI] := "LINHA EM BRANCO: "+STRZERO(nY,12)
									ENDIF
									
								ENDIF
								
							ENDIF
							
						ELSE
							
							aDadosCV1[nPosCT1INI] :=    NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ])))
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CT1DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CT1","CT1_CONTA",xFilial("CT1")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),6,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTTDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTT","CTT_CUSTO",xFilial("CTT")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTDDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTD","CTD_ITEM",xFilial("CTD")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTHDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTH","CTH_CLVL",xFilial("CTH")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_AKFDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_OPER"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("AKF","AKF_CODIGO",xFilial("AKF")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),2,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E05DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"05"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E06DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"06"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E07DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E08DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"08"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF     ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_DESCIT"
						
						IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
							aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
						ELSE
							aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER01"
						
						aPeriodos[01] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER02"
						
						aPeriodos[02] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER03"
						
						aPeriodos[03] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER04"
						
						aPeriodos[04] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER05"
						
						aPeriodos[05] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER06"
						
						aPeriodos[06] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER07"
						
						aPeriodos[07] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER08"
						
						aPeriodos[08] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER09"
						
						aPeriodos[09] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER10"
						
						aPeriodos[10] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER11"
						
						aPeriodos[11] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER12"
						
						aPeriodos[12] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSE
						
						DO CASE
							CASE aField[nPosAlias][nZ][2] == "C" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "L" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := IIf( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. )
								
							CASE aField[nPosAlias][nZ][2] == "D" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := STOD( ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "N" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
								
							CASE aField[nPosAlias][nZ][2] == "M" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
						ENDCASE
						
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2. Converte e adequa estrutura do arquivo CertiSign para o layout CV1 padrao  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.1. Efetua o tratamento de campos nao presentes no arquivo layout CertiSign  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF aDadosCV1[nZ] == Nil
						aDadosCV1[nZ] := CRIAVAR(ALLTRIM(aFieldTRB[nZ][1]))
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.2. Iguala as para cada entidade os valores finais aos valores iniciais   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF         aFieldTRB[nZ][1] == "CV1_CT1INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTTINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTDINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTHINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E05INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E06INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E07INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E08INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_TPOINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_TPOFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ENDIF
					
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.3. Adiciona uma linha no array aDataCV1 para cada um dos 12 periodos     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSeqCV1++
				FOR nZ := 1 to Len(aPeriodos)
					
					AADD(aDataCV1,Array(Len(aFieldTRB)))
					nItemCV1++
					
					FOR nW := 1 to Len(aFieldTRB)
						
						IF        aFieldTRB[nW][1] == "CV1_SEQUEN"
							aDataCV1[nItemCV1][nW] := STRZERO(nSeqCV1,4)
						ELSEIF    aFieldTRB[nW][1] == "CV1_PERIOD"
							aDataCV1[nItemCV1][nW] := STRZERO(nZ,2)
						ELSEIF    aFieldTRB[nW][1] == "CV1_VALOR"
							aDataCV1[nItemCV1][nW] := aPeriodos[nZ]
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTINI"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTINI",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTFIM"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTFIM",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSE
							aDataCV1[nItemCV1][nW] := aDadosCV1[nW]
						ENDIF
						
					NEXT nW
					
				NEXT nZ
				
			NEXT nY
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega arrays com a nova estrutura e dados jah tratados para a CertiSign  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aField[nPosAlias]     := aClone(aFieldTRB)
			aData[nPosAlias]    := aClone(aDataCV1)
			
		ENDIF
		
	ENDIF
	
NEXT nX

RestArea(aArea)
RETURN

// Layouts 2016

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSPCO2016DºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TRATAMENTO ESPECIFICO PARA O LAYOUT DOS ITENS: LAYOUT 2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSPCO2016D(aAlias, aAliasIt, aData, aField, cRevisao)

LOCAL aArea             := GetArea()
LOCAL cExerc         := GetAdvFVal("CTG","CTG_EXERC",xFilial("CTG")+MV_PAR03,1,"")
LOCAL aFieldTRB     := {}
LOCAL aDataCV1      := {}
LOCAL aDadosCV1     := {}
LOCAL aPeriodos     := {}
LOCAL nSeqCV1         := 0
LOCAL nItemCV1         := 0
LOCAL nPosAlias     := 0
LOCAL nPosField     := 0
LOCAL nW            := 0
LOCAL nX            := 0
LOCAL nY            := 0
LOCAL nZ            := 0
LOCAL lConverte     := MV_PAR10 == 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array aFieldTRB com a nova estrutura do CV1 que devera ser gravada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldTRB,{"CV1_FILIAL","C"})
AADD(aFieldTRB,{"CV1_ORCMTO","C"})
AADD(aFieldTRB,{"CV1_DESCRI","C"})
AADD(aFieldTRB,{"CV1_STATUS","C"})
AADD(aFieldTRB,{"CV1_CALEND","C"})
AADD(aFieldTRB,{"CV1_MOEDA","C"})
AADD(aFieldTRB,{"CV1_REVISA","C"})
AADD(aFieldTRB,{"CV1_SEQUEN","C"})
AADD(aFieldTRB,{"CV1_CT1INI","C"})
AADD(aFieldTRB,{"CV1_CT1FIM","C"})
AADD(aFieldTRB,{"CV1_CTTINI","C"})
AADD(aFieldTRB,{"CV1_CTTFIM","C"})
AADD(aFieldTRB,{"CV1_CTDINI","C"})
AADD(aFieldTRB,{"CV1_CTDFIM","C"})
AADD(aFieldTRB,{"CV1_CTHINI","C"})
AADD(aFieldTRB,{"CV1_CTHFIM","C"})
AADD(aFieldTRB,{"CV1_PERIOD","C"})
AADD(aFieldTRB,{"CV1_DTINI","D"})
AADD(aFieldTRB,{"CV1_DTFIM","D"})
AADD(aFieldTRB,{"CV1_VALOR","N"})
AADD(aFieldTRB,{"CV1_APROVA","C"})
AADD(aFieldTRB,{"CV1_E05INI","C"})
AADD(aFieldTRB,{"CV1_E05FIM","C"})
AADD(aFieldTRB,{"CV1_E06INI","C"})
AADD(aFieldTRB,{"CV1_E06FIM","C"})
AADD(aFieldTRB,{"CV1_E07INI","C"})
AADD(aFieldTRB,{"CV1_E07FIM","C"})
AADD(aFieldTRB,{"CV1_E08INI","C"})
AADD(aFieldTRB,{"CV1_E08FIM","C"})
AADD(aFieldTRB,{"CV1_E09INI","C"})
AADD(aFieldTRB,{"CV1_E09FIM","C"})
AADD(aFieldTRB,{"CV1_OPER","C"})
AADD(aFieldTRB,{"CV1_TIPOIT","C"})
AADD(aFieldTRB,{"CV1_DESCIT","C"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Zera os arrays padroes para que os mesmos seja recarregados conforme regra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FOR nX := 1 TO Len(aAliasIt)
	
	IF aAliasIt[nX] == "CV1"
		
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0
			
			FOR nY := 1 TO Len(aData[nPosAlias])
				
				aDadosCV1 := Array(Len(aFieldTRB))
				aPeriodos := Array(12)
				
				FOR nZ := 1 TO Len(aField[nPosAlias])
					
					IF         ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_FILIAL"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_FILIAL" })
						
						aDadosCV1[nPosField] := xFilial("CV1")
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_ORCMTO"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_ORCMTO"})
						
						aDadosCV1[nPosField] := MV_PAR02 // ORCAMENTO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_STATUS"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_STATUS"})
						
						aDadosCV1[nPosField] := "1"            // 1-ABERTO; 2-GERADO SALDO; 3-REVISADO;
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CALEND"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CALEND"})
						
						aDadosCV1[nPosField] := MV_PAR03     // CALENDARIO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_MOEDA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_MOEDA"})
						
						aDadosCV1[nPosField] := MV_PAR04    // MOEDA
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_REVISA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_REVISA"})
						
						aDadosCV1[nPosField] := cRevisao
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CT1DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CT1","CT1_CONTA",xFilial("CT1")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),6,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTTDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTT","CTT_CUSTO",xFilial("CTT")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTDDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTD","CTD_ITEM",xFilial("CTD")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTHDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTH","CTH_CLVL",xFilial("CTH")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_AKFDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_OPER"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("AKF","AKF_CODIGO",xFilial("AKF")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),2,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E05DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"05"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E06DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"06"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E07DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E08DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"08"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER01"
						
						aPeriodos[01] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER02"
						
						aPeriodos[02] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER03"
						
						aPeriodos[03] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER04"
						
						aPeriodos[04] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER05"
						
						aPeriodos[05] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER06"
						
						aPeriodos[06] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER07"
						
						aPeriodos[07] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER08"
						
						aPeriodos[08] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER09"
						
						aPeriodos[09] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER10"
						
						aPeriodos[10] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER11"
						
						aPeriodos[11] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER12"
						
						aPeriodos[12] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSE
						
						DO CASE
							CASE aField[nPosAlias][nZ][2] == "C" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "L" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := IIf( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. )
								
							CASE aField[nPosAlias][nZ][2] == "D" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := STOD( ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "N" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
								
							CASE aField[nPosAlias][nZ][2] == "M" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
						ENDCASE
						
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2. Converte e adequa estrutura do arquivo CertiSign para o layout CV1 padrao  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.1. Efetua o tratamento de campos nao presentes no arquivo layout CertiSign  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF aDadosCV1[nZ] == Nil
						aDadosCV1[nZ] := CRIAVAR(ALLTRIM(aFieldTRB[nZ][1]))
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.2. Iguala as para cada entidade os valores finais aos valores iniciais   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF         aFieldTRB[nZ][1] == "CV1_CT1INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTTINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTDINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTHINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E05INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E06INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E07INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E08INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_TPOINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_TPOFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E09INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E09FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]	
						
					ENDIF
					
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.3. Adiciona uma linha no array aDataCV1 para cada um dos 12 periodos     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSeqCV1++
				FOR nZ := 1 to Len(aPeriodos)
					
					AADD(aDataCV1,Array(Len(aFieldTRB)))
					nItemCV1++
					
					FOR nW := 1 to Len(aFieldTRB)
						
						IF            aFieldTRB[nW][1] == "CV1_SEQUEN"
							aDataCV1[nItemCV1][nW] := STRZERO(nSeqCV1,4)
						ELSEIF    aFieldTRB[nW][1] == "CV1_PERIOD"
							aDataCV1[nItemCV1][nW] := STRZERO(nZ,2)
						ELSEIF    aFieldTRB[nW][1] == "CV1_VALOR"
							aDataCV1[nItemCV1][nW] := aPeriodos[nZ]
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTINI"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTINI",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTFIM"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTFIM",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSE
							aDataCV1[nItemCV1][nW] := aDadosCV1[nW]
						ENDIF
						
					NEXT nW
					
				NEXT nZ
				
			NEXT nY
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega arrays com a nova estrutura e dados jah tratados para a CertiSign  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aField[nPosAlias] := aClone(aFieldTRB)
			aData[nPosAlias]     := aClone(aDataCV1)
			
		ENDIF
		
	ENDIF
	
NEXT nX

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSPCO2016RºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TRATAMENTO ESPECIFICO PARA O LAYOUT DOS ITENS: LAYOUT 2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSPCO2016R(aAlias, aAliasIt, aData, aField, cRevisao)

LOCAL aArea             := GetArea()
LOCAL cExerc         := GetAdvFVal("CTG","CTG_EXERC",xFilial("CTG")+MV_PAR03,1,"")
LOCAL aFieldTRB     := {}
LOCAL aDataCV1      := {}
LOCAL aDadosCV1     := {}
LOCAL aPeriodos     := {}
LOCAL nSeqCV1         := 0
LOCAL nItemCV1         := 0
LOCAL nPosAlias     := 0
LOCAL nPosField     := 0
LOCAL nPosCT1INI    := 0
LOCAL nPosCV1DTI    := 0
LOCAL nW            := 0
LOCAL nX            := 0
LOCAL nY            := 0
LOCAL nZ            := 0
LOCAL lConverte     := MV_PAR10 == 1
LOCAL cDadosTMP        := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array aFieldTRB com a nova estrutura do CV1 que devera ser gravada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldTRB,{"CV1_FILIAL","C"})
AADD(aFieldTRB,{"CV1_ORCMTO","C"})
AADD(aFieldTRB,{"CV1_DESCRI","C"})
AADD(aFieldTRB,{"CV1_STATUS","C"})
AADD(aFieldTRB,{"CV1_CALEND","C"})
AADD(aFieldTRB,{"CV1_MOEDA","C"})
AADD(aFieldTRB,{"CV1_REVISA","C"})
AADD(aFieldTRB,{"CV1_SEQUEN","C"})
AADD(aFieldTRB,{"CV1_CT1INI","C"})
AADD(aFieldTRB,{"CV1_CT1FIM","C"})
AADD(aFieldTRB,{"CV1_CTTINI","C"})
AADD(aFieldTRB,{"CV1_CTTFIM","C"})
AADD(aFieldTRB,{"CV1_CTDINI","C"})
AADD(aFieldTRB,{"CV1_CTDFIM","C"})
AADD(aFieldTRB,{"CV1_CTHINI","C"})
AADD(aFieldTRB,{"CV1_CTHFIM","C"})
AADD(aFieldTRB,{"CV1_PERIOD","C"})
AADD(aFieldTRB,{"CV1_DTINI","D"})
AADD(aFieldTRB,{"CV1_DTFIM","D"})
AADD(aFieldTRB,{"CV1_VALOR","N"})
AADD(aFieldTRB,{"CV1_APROVA","C"})
AADD(aFieldTRB,{"CV1_E05INI","C"})
AADD(aFieldTRB,{"CV1_E05FIM","C"})
AADD(aFieldTRB,{"CV1_E06INI","C"})
AADD(aFieldTRB,{"CV1_E06FIM","C"})
AADD(aFieldTRB,{"CV1_E07INI","C"})
AADD(aFieldTRB,{"CV1_E07FIM","C"})
AADD(aFieldTRB,{"CV1_E08INI","C"})
AADD(aFieldTRB,{"CV1_E08FIM","C"})
AADD(aFieldTRB,{"CV1_OPER","C"})
AADD(aFieldTRB,{"CV1_TIPOIT","C"})
AADD(aFieldTRB,{"CV1_DESCIT","C"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega variaveis utilizadas nos posicionamentos dos campos nos arrays     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosCT1INI := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
nPosCV1DTI := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_DESCIT"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre os ALIAS especiais utilizados pela funcao GetAdvFVal()                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("AKF")
DbSetOrder(1)

DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("CV0")
DbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Zera os arrays padroes para que os mesmos seja recarregados conforme regra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FOR nX := 1 TO Len(aAliasIt)
	
	IF aAliasIt[nX] == "CV1"
		
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0
			
			FOR nY := 1 TO Len(aData[nPosAlias])
				
				aDadosCV1 := Array(Len(aFieldTRB))
				aPeriodos := Array(12)
				
				FOR nZ := 1 TO Len(aField[nPosAlias])
					
					IF         ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_FILIAL"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_FILIAL"})
						
						aDadosCV1[nPosField] := xFilial("CV1")
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_ORCMTO"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_ORCMTO"})
						
						aDadosCV1[nPosField] := MV_PAR02 // ORCAMENTO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_STATUS"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_STATUS"})
						
						aDadosCV1[nPosField] := "1"            // 1-ABERTO; 2-GERADO SALDO; 3-REVISADO;
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CALEND"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CALEND"})
						
						aDadosCV1[nPosField] := MV_PAR03     // CALENDARIO
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_MOEDA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_MOEDA"})
						
						aDadosCV1[nPosField] := MV_PAR04    // MOEDA
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_REVISA"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_REVISA"})
						
						aDadosCV1[nPosField] := cRevisao
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CT1INI"
						
						IF EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))
							
							nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
							
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
								aDadosCV1[nPosCT1INI] := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
								
							ELSEIF !EMPTY(aDadosCV1[nPosField])
								
								aDadosCV1[nPosCT1INI] := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aDadosCV1[nPosField]))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
								
							ELSE
								
								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CV1_E07DSC"})
								
								IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
									
									cDadosTMP := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nPosField]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
									
									IF !EMPTY(cDadosTMP)
										
										cDadosTMP := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM( cDadosTMP ))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
										
										IF !EMPTY(cDadosTMP)
											aDadosCV1[nPosCT1INI] := cDadosTMP
										ELSE
											aDadosCV1[nPosCT1INI] := ""
											IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
												aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ELSE
												aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ENDIF
										ENDIF
										
									ELSE
										aDadosCV1[nPosCT1INI] := ""
										IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
											aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ELSE
											aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ENDIF
									ENDIF
									
								ELSEIF !EMPTY(aDadosCV1[nPosField])
									
									cDadosTMP := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aDadosCV1[nPosField]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
									
									IF !EMPTY(cDadosTMP)
										
										cDadosTMP := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM( cDadosTMP ))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
										
										IF !EMPTY(cDadosTMP)
											aDadosCV1[nPosCT1INI] := cDadosTMP
										ELSE
											aDadosCV1[nPosCT1INI] := ""
											IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
												aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ELSE
												aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
											ENDIF
										ENDIF
										
									ELSE
										aDadosCV1[nPosCT1INI] := ""
										IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
											aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ELSE
											aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField]))
										ENDIF
									ENDIF
									
								ELSE
									
									aDadosCV1[nPosCT1INI] := ""
									IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
										aDadosCV1[nPosCV1DTI] += "LINHA EM BRANCO: "+STRZERO(nY,12)
									ELSE
										aDadosCV1[nPosCV1DTI] := "LINHA EM BRANCO: "+STRZERO(nY,12)
									ENDIF
									
								ENDIF
								
							ENDIF
							
						ELSE
							
							aDadosCV1[nPosCT1INI] :=    NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ])))
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CT1DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CT1","CT1_CONTA",xFilial("CT1")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),6,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTTDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTT","CTT_CUSTO",xFilial("CTT")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTDDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTD","CTD_ITEM",xFilial("CTD")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_CTHDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHINI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CTH","CTH_CLVL",xFilial("CTH")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_AKFDSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_OPER"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("AKF","AKF_CODIGO",xFilial("AKF")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),2,"")
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E05DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"05"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E06DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"06"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E07DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_E08DSC"
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08INI"})
						
						IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))) .AND. EMPTY(aDadosCV1[nPosField])
							
							aDadosCV1[nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"08"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
							
						ENDIF
						
					ELSEIF     ALLTRIM(aField[nPosAlias][nZ][1]) == "CV1_DESCIT"
						
						IF ValType(aDadosCV1[nPosCV1DTI]) == "C" .AND. !Empty(aDadosCV1[nPosCV1DTI])
							aDadosCV1[nPosCV1DTI] += NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
						ELSE
							aDadosCV1[nPosCV1DTI] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
						ENDIF
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER01"
						
						aPeriodos[01] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER02"
						
						aPeriodos[02] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER03"
						
						aPeriodos[03] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER04"
						
						aPeriodos[04] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER05"
						
						aPeriodos[05] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER06"
						
						aPeriodos[06] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER07"
						
						aPeriodos[07] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER08"
						
						aPeriodos[08] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER09"
						
						aPeriodos[09] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER10"
						
						aPeriodos[10] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER11"
						
						aPeriodos[11] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSEIF    ALLTRIM(aField[nPosAlias][nZ][1]) $ "CV1_PER12"
						
						aPeriodos[12] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
						
					ELSE
						
						DO CASE
							CASE aField[nPosAlias][nZ][2] == "C" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "L" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := IIf( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. )
								
							CASE aField[nPosAlias][nZ][2] == "D" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := STOD( ALLTRIM(aData[nPosAlias][nY][nZ]))
								
							CASE aField[nPosAlias][nZ][2] == "N" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]),lConverte )
								
							CASE aField[nPosAlias][nZ][2] == "M" .AND. (nPosField := aScan(aFieldTRB,{|aFieldTRB| ALLTRIM(aFieldTRB[1]) == ALLTRIM(aField[nPosAlias][nZ][1])}))>0
								
								aDadosCV1[nPosField] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]))
								
						ENDCASE
						
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2. Converte e adequa estrutura do arquivo CertiSign para o layout CV1 padrao  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.1. Efetua o tratamento de campos nao presentes no arquivo layout CertiSign  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF aDadosCV1[nZ] == Nil
						aDadosCV1[nZ] := CRIAVAR(ALLTRIM(aFieldTRB[nZ][1]))
					ENDIF
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.2. Iguala as para cada entidade os valores finais aos valores iniciais   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				FOR nZ := 1 to Len(aFieldTRB)
					
					IF         aFieldTRB[nZ][1] == "CV1_CT1INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CT1FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTTINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTTFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTDINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTDFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_CTHINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_CTHFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E05INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E05FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E06INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E06FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E07INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E07FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_E08INI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_E08FIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ELSEIF    aFieldTRB[nZ][1] == "CV1_TPOINI" .AND. !Empty(aDadosCV1[nZ])
						
						nPosField := aScan(aFieldTRB,{|aField| ALLTRIM(aField[1]) == "CV1_TPOFIM"})
						aDadosCV1[nPosField] := aDadosCV1[nZ]
						
					ENDIF
					
					
				NEXT nZ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.3. Adiciona uma linha no array aDataCV1 para cada um dos 12 periodos     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSeqCV1++
				FOR nZ := 1 to Len(aPeriodos)
					
					AADD(aDataCV1,Array(Len(aFieldTRB)))
					nItemCV1++
					
					FOR nW := 1 to Len(aFieldTRB)
						
						IF        aFieldTRB[nW][1] == "CV1_SEQUEN"
							aDataCV1[nItemCV1][nW] := STRZERO(nSeqCV1,4)
						ELSEIF    aFieldTRB[nW][1] == "CV1_PERIOD"
							aDataCV1[nItemCV1][nW] := STRZERO(nZ,2)
						ELSEIF    aFieldTRB[nW][1] == "CV1_VALOR"
							aDataCV1[nItemCV1][nW] := aPeriodos[nZ]
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTINI"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTINI",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSEIF    aFieldTRB[nW][1] == "CV1_DTFIM"
							aDataCV1[nItemCV1][nW] := GetAdvFVal("CTG","CTG_DTFIM",xFilial("CTG")+MV_PAR03+cExerc+STRZERO(nZ,2),1,CTOD(""))
						ELSE
							aDataCV1[nItemCV1][nW] := aDadosCV1[nW]
						ENDIF
						
					NEXT nW
					
				NEXT nZ
				
			NEXT nY
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega arrays com a nova estrutura e dados jah tratados para a CertiSign  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aField[nPosAlias]     := aClone(aFieldTRB)
			aData[nPosAlias]    := aClone(aDataCV1)
			
		ENDIF
		
	ENDIF
	
NEXT nX

RestArea(aArea)
RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ X3TIPO   ºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RETORNA O TIPO DO CAMPO CONFORME DICIONARIO DE DADOS       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION X3TIPO(cCampo)

LOCAL aArea     := GetArea()
LOCAL aAreaSX3 := SX3->(GetArea())
LOCAL cTipo        := "C"  // RETORNO PADRAO PARA PERMITIR O TRATAMENTO DA INFORMACAO NA ROTINA CHAMADORA

DEFAULT cCampo := ""

IF !Empty(cCampo)
	
	DbSelectArea("SX3")
	DbSetOrder(2) // X3_CAMPO
	IF DbSeek(ALLTRIM(cCampo))
		cTipo := X3_TIPO
	ENDIF
	
ENDIF

RestArea(aAreaSX3)
RestArea(aArea)

RETURN cTipo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE110EP ºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exportacao do orcamento em formato .CSV                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSE110EP(cAlias,nOpc,nRecno)

Local aArea        := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)                          ³
//³ MV_PAR01   - Orcamento:                                                         ³
//³ MV_PAR02   - Calendario:                                                        ³
//³ MV_PAR03   - Moeda:                                                         ³
//³ MV_PAR04   - Revisao:                                                           ³
//³ MV_PAR05   - Arquivo destino:                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If CSE110PBE() .AND.;//Parambox da rotina de exportacao do orcamento
	ApMsgNoYes(    "Confirma a exportacao do orcamento selecionado ?","ORCAMENTO CONTABIL: Exportacao")
	MsgRun("Exportando orcamento contabil...","ORCAMENTO CONTABIL: Exportacao",{|| CSE110EXP(cAlias,nOpc,nRecno)})
ENDIF

RestArea(aArea)
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE110EXPºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exportacao do orcamento em formato .CSV                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE110EXP(cAlias,nOpc,nRecno)

Local aArea        := GetArea()
Local cFile        := ""
Local cLine        := ""
Local aTxt        := {}
Local aStruCV1    := {}
Local aStruCV2    := {}
Local nX,nY

Local lProcess    := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia o processamento da exportacao                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Empty( MV_PAR05 )
	HELP(" ",1,"CSE110EXP.01",,"Nao foi informado o arquivo destino para a exportacao.",4,0)
	lProcess := .F.
	
ELSE
	
	IF At('.',MV_PAR05) == 0
		cFile    := ALLTRIM(MV_PAR05)+'.CSV'
	ELSE
		cFile    := ALLTRIM(MV_PAR05)
	ENDIF
	
	IF File( cFile )
		FErase( cFile )
	Endif
	
	nHandle := FCreate( cFile )
	
	If nHandle <= 0
		For nX := 1 To 5
			MsAguarde( {|| Sleep( 2000 ) },  "Exportacao do orcamento" , "Criando arquivo destino da exportacao")
			
			nHandle := FCreate( cFile )
			
			IF nHandle > 0
				Exit
			Endif
		Next
		
		If nHandle <= 0
			HELP(" ",1,"CSE110EXP.02",,"Nao foi possivel criar o arquivo destino para a exportacao.",4,0)
			lProcess := .F.
		Endif
	EndIf
	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Garante o posicionamento do CV2 com base  ³
//³nos parametros da PARAMBOX()              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("CV2")
DbSetOrder(1) //CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA
IF !CV2->(DbSeek(xFilial("CV2")+MV_PAR01+MV_PAR02+MV_PAR03+MV_PAR04))
	
	HELP(" ",1,"CSE110EXP.03",,"Nao foi possivel localizar o orcamento especificado para exportacao.",4,0)
	lProcess := .F.
	
ENDIF

IF lProcess
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV2 - identificador 0³
	//³Cabecalho do orcamento - campos           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEstruCV2 :=    CV2->(DbStruct())
	
	cLine :="0;CV2;"
	For nX:=1 To Len(aEstruCV2)
		cLine    +=    aEstruCV2[nX,1]+";"
	Next
	cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
	FWrite(nHandle,cLine,Len(cLine))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV2 - identificador 1³
	//³Cabecalho do orcamento - dados            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTxt := {}
	AAdd(aTxt,{})
	For nX:=1 To Len(aEstruCV2)
		Do Case
			Case aEstruCV2[nX,2] == "C"
				AADd(aTxt[Len(aTxt)], IIF( Empty(FieldGet(FieldPos(aEstruCV2[nX,1]))),'""',FieldGet(FieldPos(aEstruCV2[nX,1])) ) )
			Case aEstruCV2[nX,2] == "L"
				AADd(aTxt[Len(aTxt)],If(FieldGet(FieldPos(aEstruCV2[nX,1])),"T","F"))
			Case aEstruCV2[nX,2] == "D"
				AADd(aTxt[Len(aTxt)], IIF( Empty(Dtos(FieldGet(FieldPos(aEstruCV2[nX,1])))), '""', Dtos(FieldGet(FieldPos(aEstruCV2[nX,1])))) )
			Case aEstruCV2[nX,2] == "N"
				AADd(aTxt[Len(aTxt)],Str(FieldGet(FieldPos(aEstruCV2[nX,1]))))
		EndCase
	Next
	
	For nX:= 1 To Len(aTxt)
		cLine    :=    "1;CV2;"
		For nY:=1 To Len(aTxt[nX])
			cLine  +=   aTxt[nX,nY]+";"
		Next
		cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
		FWrite(nHandle,cLine,Len(cLine))
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV1 - identificador 0³
	//³Itens do orcamento - campos                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEstruCV1    :=    CV1->(DbStruct())
	
	cLine        := "0;CV1;"
	For nX := 1 To Len( aEstruCV1 )
		cLine    +=    aEstruCV1[nX,1]+";"
	Next
	cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
	FWrite(nHandle,cLine,Len(cLine))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV1 - identificador 2³
	//³Itens do orcamento - dados                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTxt := {}
	DbSelectArea("CV1")
	DbSetOrder(1) //CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA+CV1_SEQUEN+CV1_PERIOD
	DbSeek(xFilial("CV1")+CV2->(CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA))
	While  CV1->(!Eof()) .AND.;
		CV1->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA) == CV2->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA)
		
		AAdd(aTxt,{})
		
		For nX:=1 To Len(aEstruCV1)
			Do Case
				Case aEstruCV1[nX,2] == "C"
					AADd(aTxt[Len(aTxt)],IIF( EMPTY(FieldGet(FieldPos(aEstruCV1[nX,1]))), '""', FieldGet(FieldPos(aEstruCV1[nX,1])) ))
				Case aEstruCV1[nX,2] == "L"
					AADd(aTxt[Len(aTxt)],If(FieldGet(FieldPos(aEstruCV1[nX,1])),"T","F"))
				Case aEstruCV1[nX,2] == "D"
					AADd(aTxt[Len(aTxt)],IIF( EMPTY(Dtos(FieldGet(FieldPos(aEstruCV1[nX,1])))), '""', Dtos(FieldGet(FieldPos(aEstruCV1[nX,1]))) ))
				Case aEstruCV1[nX,2] == "N"
					AADd(aTxt[Len(aTxt)],Str(FieldGet(FieldPos(aEstruCV1[nX,1]))))
			EndCase
		Next
		CV1->(DbSkip())
	End
	
	For nX:= 1 To Len(aTxt)
		cLine    :=    "2;CV1;"
		For nY:=1 To Len(aTxt[nX])
			cLine  +=   aTxt[nX,nY]+";"
		Next
		cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
		FWrite(nHandle,cLine,Len(cLine))
	Next
	
	FClose(nHandle)
	
ENDIF

IF lProcess
	Aviso("Processameto concluido","Exportacao do orcamento efetuada com sucesso.",{"Concluir"})
ELSE
	Aviso("Processamento com criticas","Nao foi possivel efetuar a exportacao do orcamento.",{"Concluir"})
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE110PROXºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parambox da rotina de importacao do orcamento              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE110PROX(cCV2FILIAL,cCV2ORCMTO,cCV2CALEND,cCV2MOEDA,cCV2REVISA)

LOCAL aArea     := GetArea()
LOCAL cRevisao     := ""

DbSelectArea("CV2")
DbSetOrder(1) //CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA
DbSeek(cCV2FILIAL+cCV2ORCMTO+cCV2CALEND+cCV2MOEDA)
WHILE     CV2->(!EOF()) .AND.;
	CV2->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA) == cCV2FILIAL+cCV2ORCMTO+cCV2CALEND+cCV2MOEDA
	cRevisao := CV2->CV2_REVISAO
END

cRevisao := SOMA1(cRevisao)
RestArea(aArea)
RETURN cRevisao

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE110PBIºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parambox da rotina de importacao do orcamento              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CSE110PBI()

Local aParamBox := {}                                        // Array de parametros de acordo com a regra da ParamBox
Local cTitulo   := "Importacao da estrutura do orcamento"    // Titulo da janela de parametros
Local aRet      := {}                                        // Array que será passado por referencia e retornado com o conteudo de cada parametro
Local bOk       := {|| .T.}                                    // Bloco de codigo para validacao do OK da tela de parametros
Local aButtons  := {}                                        // Array contendo a regra para adicao de novos botoes (além do OK e Cancelar) // AADD(aButtons,{nType,bAction,cTexto})
Local lCentered := .T.                                        // Se a tela será exibida centralizada, quando a mesma não estiver vinculada a outra janela
Local nPosx                                                    // Posicao inicial -> linha (Linha final: nPosX+274)
Local nPosy                                                    // Posicao inicial -> coluna (Coluna final: nPosY+445)
//Local oMainDlg                                            // Caso o ParamBox deva ser vinculado a uma outra tela
Local cLoad     := ""                                        // Nome do arquivo aonde as respostas do usuário serão salvas / lidas
Local lCanSave  := .F.                                        // Se as respostas para as perguntas podem ser salvas
Local lUserSave := .F.                                        // Se o usuário pode salvar sua propria configuracao
Local nX        := 0
Local lRet      := .F.



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)                      ³
//³ MV_PAR01   - Arquivo a importar:                                        ³
//³ MV_PAR02   - Orcamento:                                                 ³
//³ MV_PAR03   - Calendario:                                                ³
//³ MV_PAR04   - Moeda:                                                     ³
//³ MV_PAR05   - Revisao:                                                   ³
//³ MV_PAR06   - Modo de importacao: (Novo orcamento/Nova revisao)          ³
//³ MV_PAR07   - Exibe orcamento para edicao: (Sim/Nao)                     ³
//³ MV_PAR08   - Layout de importacao : (Padrao / CertiSign)                ³
//³ MV_PAR09   - Validar estrutura de campos: (Sim/Nao)                     ³
//³ MV_PAR10   - Converte formato de valores: (Sim/Nao)                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aParamBox,{6,"Arquivo a importar          " ,SPACE(150)                ,"",,"",90 ,.T.,"Arquivo .CSV |*.CSV","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
AADD(aParamBox,{1,"Orcamento                   " ,CRIAVAR("CV2_ORCMTO")    ,"@!","AllwaysTrue()",,".T.",TamSx3("CV2_ORCMTO")[1],.T.})
AADD(aParamBox,{1,"Calendario                  " ,CRIAVAR("CV2_CALEND")    ,"@!","AllwaysTrue()","CTG",".T.",TamSx3("CV2_CALEND")[1],.T.})
AADD(aParamBox,{1,"Moeda                       " ,CRIAVAR("CV2_MOEDA")    ,"@!","AllwaysTrue()","CTO",".T.",TamSx3("CV2_MOEDA")[1] ,.T.})
AADD(aParamBox,{1,"Revisao                     " ,CRIAVAR("CV2_REVISA")    ,"@!","AllwaysTrue()",,".T.",TamSx3("CV2_REVISA")[1],.T.})
AADD(aParamBox,{2,"Modo de importacao          " ,2,{"Novo orcamento","Nova revisao"}                                                    ,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Exibe orcamento para edicao " ,2,{"Sim","Nao"}                                                                        ,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Layout de importacao        " ,2,{"Padrao","Certisign_2016D","Certisign_2016R","Certisign_2014D","Certisign_2014R"}    ,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Validar estrutura de campos " ,2,{"Sim","Nao"}                                                                        ,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Converte formato de valores " ,2,{"Sim","Nao"}                                                                        ,100,"AllwaysTrue()",.T.,.T.})

lRet := ParamBox(aParamBox, cTitulo, aRet, bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

IF ValType(aRet) == "A" .AND. Len(aRet) == Len(aParamBox)
	For nX := 1 to Len(aParamBox)
		If aParamBox[nX][1] == 1
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "C"
			&("MV_PAR"+StrZero(nX,2)) := aScan(aParamBox[nX][4],{|x| Alltrim(x) == aRet[nX]})
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "N"
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		Endif
	Next nX
ENDIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE110PBEºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parambox da rotina de exportacao do orcamento              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CSE110PBE(lTipoOrca)

Local aParamBox := {}                                        // Array de parametros de acordo com a regra da ParamBox
Local cTitulo    := "Exportacao da estrutura do orcamento"    // Titulo da janela de parametros
Local aRet        := {}                                        // Array que será passado por referencia e retornado com o conteudo de cada parametro
Local bOk        := {|| .T.}                                    // Bloco de codigo para validacao do OK da tela de parametros
Local aButtons    := {}                                        // Array contendo a regra para adicao de novos botoes (além do OK e Cancelar) // AADD(aButtons,{nType,bAction,cTexto})
Local lCentered    := .T.                                        // Se a tela será exibida centralizada, quando a mesma não estiver vinculada a outra janela
Local nPosx                                                    // Posicao inicial -> linha (Linha final: nPosX+274)
Local nPosy                                                    // Posicao inicial -> coluna (Coluna final: nPosY+445)
//Local oMainDlg                                            // Caso o ParamBox deva ser vinculado a uma outra tela
Local cLoad        := ""                                        // Nome do arquivo aonde as respostas do usuário serão salvas / lidas
Local lCanSave    := .F.                                        // Se as respostas para as perguntas podem ser salvas
Local lUserSave := .F.                                        // Se o usuário pode salvar sua propria configuracao
Local nX        := 0
Local lRet        := .F.
Default lTipoOrca := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)                          ³
//³ MV_PAR01   - Orcamento:                                                         ³
//³ MV_PAR02   - Calendario:                                                        ³
//³ MV_PAR03   - Moeda:                                                         ³
//³ MV_PAR04   - Revisao:                                                           ³
//³ MV_PAR05   - Arquivo destino:                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aParamBox,{1,"Orcamento        " ,CV2->CV2_ORCMTO        ,"@!","AllwaysTrue()",,".F.",TamSx3("CV2_ORCMTO")[1],.T.})
AADD(aParamBox,{1,"Calendario       " ,CV2->CV2_CALEND        ,"@!","AllwaysTrue()",,".F.",TamSx3("CV2_CALEND")[1],.T.})
AADD(aParamBox,{1,"Moeda            " ,CV2->CV2_MOEDA        ,"@!","AllwaysTrue()",,".F.",TamSx3("CV2_MOEDA")[1] ,.T.})
AADD(aParamBox,{1,"Revisao          " ,CV2->CV2_REVISA        ,"@!","AllwaysTrue()",,".F.",TamSx3("CV2_REVISA")[1],.T.})
AADD(aParamBox,{6,"Arquivo de saida " ,SPACE(150)                ,"",,"",90 ,.T.,"Arquivo .CSV |*.CSV","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
If lTipoOrca
	aAdd(aParamBox,{ 2, "Tipo Orçamento ",1,{"Despesas","Receitas"},60,"",.T.})
EndIf
lRet := ParamBox(aParamBox, cTitulo, aRet, bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

IF ValType(aRet) == "A" .AND. Len(aRet) == Len(aParamBox)
	For nX := 1 to Len(aParamBox)
		If aParamBox[nX][1] == 1
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "C"
			&("MV_PAR"+StrZero(nX,2)) := aScan(aParamBox[nX][4],{|x| Alltrim(x) == aRet[nX]})
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "N"
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		Endif
	Next nX
ENDIF

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NoAcento ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retira acento dos caracteres                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpC1: Retorna String sem Acento                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Recebe String com Acento                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION NoAcento(cString)

Local nConta := 0
Local cLetra := ""
Local cRet   := ""
cString := Upper(cString)
For nConta:= 1 To Len(cString)
	cLetra := SubStr(cString, nConta, 1)
	Do Case
		Case (Asc(cLetra) >= 191 .and. Asc(cLetra) <= 198) .or. (Asc(cLetra) >= 223 .and. Asc(cLetra) <= 230)
			cLetra := "A"
		Case (Asc(cLetra) >= 199 .and. Asc(cLetra) <= 204) .or. (Asc(cLetra) >= 231 .and. Asc(cLetra) <= 236)
			cLetra := "E"
		Case (Asc(cLetra) >= 204 .and. Asc(cLetra) <= 207) .or. (Asc(cLetra) >= 235 .and. Asc(cLetra) <= 240)
			cLetra := "I"
		Case (Asc(cLetra) >= 209 .and. Asc(cLetra) <= 215) .or. (Asc(cLetra) == 240) .or. (Asc(cLetra) >= 241 .and. Asc(cLetra) <= 247)
			cLetra := "O"
		Case (Asc(cLetra) >= 216 .and. Asc(cLetra) <= 221) .or. (Asc(cLetra) >= 248 .and. Asc(cLetra) <= 253)
			cLetra := "U"
		Case Asc(cLetra) == 199 .or. Asc(cLetra) == 231
			cLetra := "C"
		Case Asc(cLetra) == 35 // "#"
			cLetra := "?"
		Case Asc(cLetra) == 63 // "?"
			cLetra := "?"
		Case cLetra == '"'
			cLetra := ' '
	EndCase
	cRet := cRet+cLetra
Next

Return UPPER(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ValFormat³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retira o "." do separador de milhares e troca a ","        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpC1: Retorna String convertida em valor                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Recebe String de valor formatada                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION ValFormat(cString,lConverte)

Local nConta := 0
Local cLetra := ""
Local cRet   := ""

IF lConverte .AND. AT(",",cString) > 0
	cString := Upper(cString)
	For nConta:= 1 To Len(cString)
		cLetra := SubStr(cString, nConta, 1)
		Do Case
			Case cLetra == "."
				cLetra := ""
			Case cLetra == ","
				cLetra := "."
		EndCase
		cRet := cRet+cLetra
	Next
ELSE
	cRet := cString
ENDIF

Return Val(cRet)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ CSPCO11A ³ Autor ³ Joao Goncalves de Oliveira ³ Data ³ 10/07/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Executa Tela de Parametros para Posterior Execução da Função     ±±
±±³Principal ³ Principal 													    ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CSPCO11A(ExpC1,ExpN2,ExpN3) 				          		   	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 - Apelido do Arquivo 									   ³±±
±±³			 ³ ExpN2 - Opção do Arquivo										   ³±±
±±³			 ³ ExpN3 - Registro no Arquivo	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ³ Nenhum												   		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSPCO11A(cAlias,nOpc,nRecno)

Local aArea        := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)                      ³
//³ MV_PAR01   - Orcamento:                                                 ³
//³ MV_PAR02   - Calendario:                                                ³
//³ MV_PAR03   - Moeda:                                                     ³
//³ MV_PAR04   - Revisao:                                                   ³
//³ MV_PAR05   - Arquivo destino:                                           ³
//³ MV_PAR06   - Tipo Orçamento :                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If CSE110PBE(.T.) .AND.;//Parambox da rotina de exportacao do orcamento
	ApMsgNoYes(    "Confirma a exportacao do orcamento selecionado ?","ORCAMENTO CONTABIL: Exportacao")
	MsgRun("Exportando orcamento contabil...","ORCAMENTO CONTABIL: Exportacao",{|| CSPCO11B(cAlias,nOpc,nRecno)})
ENDIF

RestArea(aArea)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ CSPCO11B ³ Autor ³ Joao Goncalves de Oliveira ³ Data ³ 10/07/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Exporta Planilha para Geração do Orçamento e Posterior Importação±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CSPCO11B(ExpC1,ExpN2,ExpN3) 				          		   	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 - Apelido do Arquivo 									   ³±±
±±³			 ³ ExpN2 - Opção do Arquivo										   ³±±
±±³			 ³ ExpN3 - Registro no Arquivo	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Retorno   ³ Nenhum												   		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CSPCO11B(cAlias,nOpc,nRecno)

Local aArea      := GetArea()
Local cFile      := ""
Local cLine      := ""
Local aTxt       := {}
Local aStruCV1   := {}
Local aStruCV2   := {}
Local nX,nY
Local aListCamp  := {}
Local aListDesc  := {}
Local cInfoDesc  := ""
Local cContCamp  := ""
Local cChavBusc  := ""


Local lProcess    := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

If mv_par06 == 1
	// Despesas
	aListCamp := {"CV1_CT1INI","CV1_CTTINI","CV1_CTDINI","CV1_CTHINI";
	,"CV1_E05INI","CV1_E06INI","CV1_E07INI","CV1_E08INI";
	,"CV1_PER01","CV1_PER02","CV1_PER03","CV1_PER04","CV1_PER05","CV1_PER06";
	,"CV1_PER07","CV1_PER08","CV1_PER09","CV1_PER10","CV1_PER11","CV1_PER12"}
	// Receitas
	aAdd(aListDesc,{"CV1_CT1INI","CT1_DESC01","CT1"})
	aAdd(aListDesc,{"CV1_CTTINI","CTT_DESC01","CTT"})
	aAdd(aListDesc,{"CV1_CTDINI","CTD_DESC01","CTD"})
	aAdd(aListDesc,{"CV1_CTHINI","CTH_DESC01","CTH"})
	aAdd(aListDesc,{"CV1_E05INI","CV0_DESC","CV0"})
	aAdd(aListDesc,{"CV1_E06INI","CV0_DESC","CV0"})
	aAdd(aListDesc,{"CV1_E07INI","CV0_DESC","CV0"})
	aAdd(aListDesc,{"CV1_E08INI","CV0_DESC","CV0"})
Else
	aListCamp := {"CV1_CT1INI","CV1_CTTINI","CV1_CTDINI","CV1_CTHINI","CV1_E05INI","CV1_E06INI";
	,"CV1_E07INI","CV1_E08INI","CV1_E09INI";
	,"CV1_PER01","CV1_PER02","CV1_PER03","CV1_PER04","CV1_PER05","CV1_PER06";
	,"CV1_PER07","CV1_PER08","CV1_PER09","CV1_PER10","CV1_PER11","CV1_PER12"}
	
	
	aAdd(aListDesc,{"CV1_CT1INI","CT1_DESC01","CT1"})
	aAdd(aListDesc,{"CV1_CTTINI","CTT_DESC01","CTT"})
	aAdd(aListDesc,{"CV1_CTDINI","CTD_DESC01","CTD"})
	aAdd(aListDesc,{"CV1_CTHINI","CTH_DESC01","CTH"})
	aAdd(aListDesc,{"CV1_E05INI","CV0_DESC","CV0"})
	aAdd(aListDesc,{"CV1_E06INI","CV0_DESC","CV0"})
	aAdd(aListDesc,{"CV1_E07INI","CV0_DESC","CV0"})
	aAdd(aListDesc,{"CV1_E08INI","CV0_DESC","CV0"})
	aAdd(aListDesc,{"CV1_E09INI","CV0_DESC","CV0"})
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia o processamento da exportacao                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Empty( MV_PAR05 )
	HELP(" ",1,"CSE110EXP.01",,"Nao foi informado o arquivo destino para a exportacao.",4,0)
	lProcess := .F.
	
ELSE
	
	IF At('.',MV_PAR05) == 0
		cFile    := ALLTRIM(MV_PAR05)+'.CSV'
	ELSE
		cFile    := ALLTRIM(MV_PAR05)
	ENDIF
	
	IF File( cFile )
		FErase( cFile )
	Endif
	
	nHandle := FCreate( cFile )
	
	If nHandle <= 0
		For nX := 1 To 5
			MsAguarde( {|| Sleep( 2000 ) },  "Exportacao do orcamento" , "Criando arquivo destino da exportacao")
			
			nHandle := FCreate( cFile )
			
			IF nHandle > 0
				Exit
			Endif
		Next
		
		If nHandle <= 0
			HELP(" ",1,"CSE110EXP.02",,"Nao foi possivel criar o arquivo destino para a exportacao.",4,0)
			lProcess := .F.
		Endif
	EndIf
	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Garante o posicionamento do CV2 com base  ³
//³nos parametros da PARAMBOX()              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("CV2")
DbSetOrder(1) //CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA
IF !CV2->(DbSeek(xFilial("CV2")+MV_PAR01+MV_PAR02+MV_PAR03+MV_PAR04))
	
	HELP(" ",1,"CSE110EXP.03",,"Nao foi possivel localizar o orcamento especificado para exportacao.",4,0)
	lProcess := .F.
	
ENDIF

IF lProcess
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV2 - identificador 0³
	//³Cabecalho do orcamento - campos           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEstruCV2 :=    CV2->(DbStruct())
	
	cLine :="0;CV2;"
	For nX:=1 To Len(aEstruCV2)
		cLine    +=    aEstruCV2[nX,1]+";"
	Next
	cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
	FWrite(nHandle,cLine,Len(cLine))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV2 - identificador 1³
	//³Cabecalho do orcamento - dados            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTxt := {}
	AAdd(aTxt,{})
	For nX:=1 To Len(aEstruCV2)
		Do Case
			Case aEstruCV2[nX,2] == "C"
				AADd(aTxt[Len(aTxt)], IIF( Empty(FieldGet(FieldPos(aEstruCV2[nX,1]))),'""',FieldGet(FieldPos(aEstruCV2[nX,1])) ) )
			Case aEstruCV2[nX,2] == "L"
				AADd(aTxt[Len(aTxt)],If(FieldGet(FieldPos(aEstruCV2[nX,1])),"T","F"))
			Case aEstruCV2[nX,2] == "D"
				AADd(aTxt[Len(aTxt)], IIF( Empty(Dtos(FieldGet(FieldPos(aEstruCV2[nX,1])))), '""', Dtos(FieldGet(FieldPos(aEstruCV2[nX,1])))) )
			Case aEstruCV2[nX,2] == "N"
				AADd(aTxt[Len(aTxt)],Str(FieldGet(FieldPos(aEstruCV2[nX,1]))))
		EndCase
	Next
	
	
	For nX:= 1 To Len(aTxt)
		cLine    :=    "1;CV2;"
		For nY:=1 To Len(aTxt[nX])
			cLine  +=   aTxt[nX,nY]+";"
		Next
		cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
		FWrite(nHandle,cLine,Len(cLine))
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV1 - identificador 0³
	//³Itens do orcamento - campos                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cLine        := "0;CV1;"
	For nX := 1 To Len( aListCamp )
		cLine += aListCamp[nX] + ";"
		nPosiDesc := aScan(aListDesc,{|x| x[1] == aListCamp[nX]})
		If nPosiDesc <> 0
			cLine += aListDesc[nPosiDesc,2] + ";"
		EndIf
	Next
	
	cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
	FWrite(nHandle,cLine,Len(cLine))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV1 - identificador 2³
	//³Itens do orcamento - dados                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTxt := {}
	aConfText := {}
	aListSequ := {}
	
	DbSelectArea("CV1")
	DbSetOrder(1) //CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA+CV1_SEQUEN+CV1_PERIOD
	DbSeek(xFilial("CV1")+CV2->(CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA))
	While  CV1->(!Eof()) .AND. CV1->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA) == CV2->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA)
		
		If aScan(aListSequ,CV1->CV1_SEQUEN) == 0
			cSequInic := CV1->CV1_SEQUEN
			
			aAdd(aTxt,{})
			aAdd(aListSequ,CV1->CV1_SEQUEN)
			aValores := {0,0,0,0,0,0,0,0,0,0,0,0}
			
			While CV1->CV1_SEQUEN == cSequInic
				aValores[Val(CV1_PERIOD)] := CV1->CV1_VALOR
				nRegiFina := CV1->(Recno())
				CV1->(dbSkip())
			End
			CV1->(dbGoTo(nRegiFina))
			
			For nX:=1 To Len(aListCamp)
				If Substr(aListCamp[nX],1,7) == "CV1_PER"
					aAdd(aTxt[Len(aTxt)],AllTrim(Str(aValores[Val(CV1->CV1_PERIOD)])))
				Else
					cContCamp := FieldGet(FieldPos(aListCamp[nX]))
					nPosiDesc := aScan(aListDesc,{|x| x[1] == aListCamp[nX]})
					aAdd(aTxt[Len(aTxt)],cContCamp)
					If nPosiDesc <> 0
						cChavBusc := xfilial(aListDesc[nPosiDesc,3]) + IIf(aListDesc[nPosiDesc,3] == "CV0",Substr(aListDesc[nPosiDesc,1],6,2),"") + cContCamp
						cInfoDesc := Space(10)
						If ! Empty(cContCamp)
							cInfoDesc := Posicione(aListDesc[nPosiDesc,3],1,cChavBusc,aListDesc[nPosiDesc,2])
						EndIf
						aAdd(aTxt[Len(aTxt)],cInfoDesc)
					EndIf
				EndIf
			Next
		EndIf
		
		CV1->(DbSkip())
	End
	
	For nX:= 1 To Len(aTxt)
		cLine    :=    "2;CV1;"
		For nY:=1 To Len(aTxt[nX])
			cLine  +=   aTxt[nX,nY]+";"
		Next
		If aScan(aConfText,cLine) == 0
			aAdd(aConfText,cLine)
			For nContPeri := 1 to 12
				cLine += Space(14) + ";"
			Next
			cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
			FWrite(nHandle,cLine,Len(cLine))
		EndIf
	Next
	
	FClose(nHandle)
	
ENDIF

IF lProcess
	Aviso("Processamento concluido","Exportacao do orcamento efetuada com sucesso.",{"Concluir"})
ELSE
	Aviso("Processamento com criticas","Nao foi possivel efetuar a exportacao do orcamento.",{"Concluir"})
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RestArea(aArea)
Return(.T.)