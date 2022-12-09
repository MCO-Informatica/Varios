#INCLUDE 	"CSEA500.CH"
#INCLUDE 	"PROTHEUS.CH"
//#INCLUDE 	"FWMVCDEF.CH"
//#INCLUDE	"SDIC.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CSEA500  ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ 10/02/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Lan‡amentos Cont beis Off-Line TXT formato CSV ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CONTABILIDADE GERENCIAL                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSEA500()

Local aSays 	:= {}
Local aButtons	:= {}
Local dDataSalv := dDataBase
Local nOpca 	:= 0     
Local oMeter	:= nil
Local oText01	:= nil
Local oText02	:= nil
Local oDlg		:= nil

Private cCadastro := "Contabiliza‡„o de Arquivos TXT em formato CSV"
Private lAtureg	:= .T.        
Private lUsu		:= .T.        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01 // Mostra Lan‡amentos Cont beis                     ³
//³ MV_PAR02 // Aglutina Lan‡amentos Cont beis                   ³
//³ MV_PAR03 // Arquivo a ser importado                          ³
//³ MV_PAR04 // Numero do Lote                                   ³
//³ MV_PAR05 // Quebra Linha em Doc.							 ³
//³ MV_PAR06 // Converte formato de valores (Sim/Nao)            ³
//³ MV_PAR07 // Formato da data: (AAAAMMDD / DD/MM/AAAA )        ³
//³ MV_PAR08 // Validar estrutura de campos: (Sim/Nao)           ³
//³ MV_PAR09 // Layout (Padrao / Despesas / Receitas)            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CSE500PAR()

AADD(aSays,OemToAnsi( STR0002 ) )
AADD(aSays,OemToAnsi( STR0003 ) )

AADD(aButtons, { 5,.T.,{|| CSE500PAR() } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( CTBOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	
IF nOpca == 1
	If FindFunction("CTBSERIALI")
		While !CTBSerialI("CTBPROC","ON")
		EndDo
	EndIf
	MsgMeter( {|oMeter,oText01,oText02,oDlg,lEnd| CSE500PRC(oMeter,oText01,oText02,oDlg,@lEnd)},"Processando lançamentos contábeis",,"Contabilização Off-Line CSV",.T.)/*Processa({|lEnd| CSE500PRC()})*/
	If FindFunction("CTBSERIALI")
		CTBSerialF("CTBPROC","ON")
	EndIf
Endif

dDataBase := dDataSalv

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CSE500PRC³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento do lancamento contabil TXT                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CSEA500 - CONTABILIZACAO OFF-LINE DE LANCAMENTOS CSV       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION CSE500PRC(oMeter,oText01,oText02,oDlg,lEnd)

Local aArea			:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis do processo de importacao CSV                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cLine			:=	""
Local aField 		:= {{}}
Local aData   		:= {{}}
Local aTempRead		:= {}
Local aTempData		:= {}
Local nLenFields	:= 0
Local nLenData		:= 0
Local lProcess		:= .T.
Local lConverte		:= .F.
Local nX,nY,nZ
Local nCount		:= 0
Local nTotCount		:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis do processo de contabilizacao                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cLote		:= CriaVar("CT2_LOTE")
Local cPadrao
Local lHead		:= .F.
Local lPadrao
Local lAglut
Local nTotal	:=0
Local nHdlPrv	:=0
Local aParam500	:= Array(08)
Local cArquivo
Local dDataAtu	:= CTOD("")
Local dDataLcto	:= CTOD("")
Local lQuebra	:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Identificadores das posicoes dos alias nos arrays de trabalho              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAlias		:= {"CT2"}
Local nPosAlias		:= 0
Local cAliasCab		:= "CT2"
Local aAliasIt		:= {"CT2"}
Local aFieldsObr	:= {}
Local nPosField		:= 0
Local nPCT2_DAT 	:= 0
Local nPCT2_LP		:= 0
Local nPCT2_DC    	:= 0
Local nPCT2_VLR   	:= 0
Local nPCT2_HST   	:= 0
Local nPCT2_CTA   	:= 0
Local nPCT2_CUS		:= 0
Local nPCT2_ITM		:= 0
Local nPCT2_CLV		:= 0
Local nPCT2_E05		:= 0
Local nPCT2_E06		:= 0
Local nPCT2_E07		:= 0
Local nPCT2_E08		:= 0
Local nPCT2_E09		:= 0
Local lPCT2_DSC		:= .F.
Local nPCT2_CTAD  	:= 0
Local nPCT2_CUSD	:= 0
Local nPCT2_ITMD	:= 0
Local nPCT2_CLVD	:= 0
Local nPCT2_E05D	:= 0
Local nPCT2_E06D	:= 0
Local nPCT2_E07D	:= 0
Local nPCT2_E08D	:= 0
Local nPCT2_E09D	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de compatibilizacao com o processo de contabilzacao - CA100INCL  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := {	{ "","" , 0 , 1},;
							{ "","" , 0 , 2 },;
							{ "","" , 0 , 3 },;
							{ "","" , 0 , 4 } }

PRIVATE Inclui := .T.							

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis padroes de contabilizacao que serao carregadas com os dados do CSV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE VALOR 		:= 0
PRIVATE HISTORICO 	:= ""
PRIVATE DEBITO 		:= ""
PRIVATE CREDITO 	:= ""
PRIVATE CUSTOD		:= ""
PRIVATE CUSTOC		:= ""
PRIVATE ITEMD		:= ""
PRIVATE ITEMC		:= ""
PRIVATE CLVLD		:= ""
PRIVATE CLVLC		:= ""
PRIVATE EC05DB		:= ""
PRIVATE EC05CR		:= ""
PRIVATE EC06DB		:= ""
PRIVATE EC06CR		:= ""
PRIVATE EC07DB		:= ""
PRIVATE EC07CR		:= ""
PRIVATE EC08DB		:= ""
PRIVATE EC08CR		:= ""
PRIVATE EC09DB 		:= ""
PRIVATE EC09CR		:= ""
PRIVATE XBUFFER		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array aFieldsObr com os campos que devem existir na estrutura do CSV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldsObr,"CT2_DATA"	)
AADD(aFieldsObr,"CT2_LP"	)
AADD(aFieldsObr,"CT2_DC"	)
AADD(aFieldsObr,"CT2_VALOR")
AADD(aFieldsObr,"CT2_HIST"	)
AADD(aFieldsObr,"CT2_CONTA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do processamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva os parametros no array aPARAM500 para protecao da CA100INCL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FOR nX := 1 TO LEN(aPARAM500)
	aPARAM500[nX] := &("MV_PAR"+StrZero(nX,2))
NEXT nX
lConverte := aPARAM500[06] == 1 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a abertura dos ALIAS utilizados nas buscas por descricao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("CTD")
DbSetOrder(4)  //CTD_FILIAL + CTD_DESC01

DbSelectArea("CTH")
DbSetOrder(4)  //CTH_FILIAL + CTH_DESC01

DbSelectArea("CTT")
DbSetOrder(4)  //CTT_FILIAL + CTT_DESC01

DbSelectArea("CV0")
DbSetOrder(4)  //CV0_FILIAL + CV0_PLANO + CV0_DESC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validacoes preliminares                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Empty(aPARAM500[03])
	HELP(" ",1,"CSE500PRC.01",,"Nao foi informado o nome do arquivo a ser contabilizado.",4,0)
	lProcess := .F.
ENDIF

IF lProcess .AND. (nHandle := FT_FUse(AllTrim(aPARAM500[03])))== -1
	HELP(" ",1,"CSE500PRC.02",,"Nao foi possivel abrir o arquivo selecionado para contabilizacao.",4,0)
	lProcess := .F.
ENDIF

IF lProcess .AND. Empty(aPARAM500[04])
	HELP(" ",1,"CSE500PRC.03",,"Nao foi informado o lote contabil para processamento dos movimentos.",4,0)
	lProcess := .F.
ELSE
	cLote := aPARAM500[04]
ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1a Etapa: Leitura do arquivo em conversao nos arrays de trabalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	( nCount :=0, nTotCount:=FT_FLASTREC(), oMeter:nTotal := nTotCount )  /*ProcRegua(FT_FLASTREC())*/

	WHILE !FT_FEOF()
	
		(nCount++, IncMeter(oMeter,oText01,"Etapa de Importação (01 de 01): ",oText02,"Leitura do arquivo CSV - Processando registro:"+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )/*IncProc()*/

		cLine		:= FT_FREADLN()
		aTempRead:= StrtoKarr(cLine,";")
	
		IF 		aTempRead[1] == "0" // Linhas de estrutrua de campos
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aField[nPosAlias],{aTempRead[nX],X3TIPO(aTempRead[nX])})
				NEXT nX
				
			ELSE
				HELP(" ",1,"CSE500PRC.04",,	"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2])+CRLF+;
											"Linha : "+STRZERO(nCount,12),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF
	
		ELSEIF	aTempRead[1] $ "1/2"	// Linha de dados: CV0(1)
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				aTempData := {}
				
				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aTempData,aTempRead[nX])			
				NEXT nX		

				AADD(aData[nPosAlias],aClone(aTempData))
				
			ELSE
				HELP(" ",1,"CSE500PRC.05",,	"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2])+CRLF+;
											"Linha : "+STRZERO(nCount,12),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF

		ELSE
			HELP(" ",1,"CSE500PRC.06",,	"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
										"Identificador de linha invalido: "+aTempRead[1]+CRLF+;
										"Linha : "+STRZERO(nCount,12),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.1: Validacao das posicoes dos campos necessarios ao processo     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	( nCount :=0, nTotCount:= 4, oMeter:nTotal := nTotCount )
	(nCount++, IncMeter(oMeter,oText01,"Etapa de Validacao ("+STRZERO(nCount,2)+" de "+STRZERO(nTotCount,2)+"): ",oText02,"Validacao das posicoes dos campos necessarios ao processo",nCount) )/*IncProc()*/

	nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(cAliasCab)})        
	
	FOR nX := 1 TO LEN(aFieldsObr)

		IF ( nPosField := aScan(aField[nPosAlias],{|aFieldObr| ALLTRIM(aFieldObr[1]) == ALLTRIM(aFieldsObr[nX]) } ) ) == 0
		
			HELP(" ",1,"CSE500PRC.07",,	"Nao existe na estrutura do arquivo selecionado um dos campos "+CRLF+;
													"necessario a contabilizacao: "+ALLTRIM(aFieldsObr[nX]),4,0)
			lProcess := .F.		
		            
		ELSE
			DO CASE

				CASE 	ALLTRIM(aFieldsObr[nX]) == "CT2_DATA"
						nPCT2_DTA := nPosField
										
				CASE 	ALLTRIM(aFieldsObr[nX]) == "CT2_LP"
						nPCT2_LP := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "CT2_DC"
						nPCT2_DC := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "CT2_VALOR"
						nPCT2_VLR := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "CT2_HIST"
						nPCT2_HST := nPosField
				
				CASE 	ALLTRIM(aFieldsObr[nX]) == "CT2_CONTA"
						nPCT2_CTA := nPosField

			ENDCASE
			
		ENDIF

	NEXT nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.1.1: Carrega as posicoes dos demais campos do CT2 utilizados no  ³
	//³       processo mas que nao sao obrigatorios                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lProcess
	
		nPCT2_CUS	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_CCUSTO")})
		nPCT2_ITM	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_ITEMCT")})
		nPCT2_CLV	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_CLVLCT")})
		nPCT2_E05	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E05CTA")})
		nPCT2_E06	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E06CTA")})
		nPCT2_E07	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E07CTA")})
		nPCT2_E08	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E08CTA")})
		nPCT2_E09	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E09CTA")})
	
		lPCT2_DSC	:= ( nPCT2_CUSD	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_CTTDSC")}) ) > 0 .OR. lPCT2_DSC
		lPCT2_DSC	:= ( nPCT2_ITMD	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_CTDDSC")}) ) > 0 .OR. lPCT2_DSC
		lPCT2_DSC	:= ( nPCT2_CLVD	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_CTHDSC")}) ) > 0 .OR. lPCT2_DSC
		lPCT2_DSC	:= ( nPCT2_E05D	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E05DSC")}) ) > 0 .OR. lPCT2_DSC
		lPCT2_DSC	:= ( nPCT2_E06D	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E06DSC")}) ) > 0 .OR. lPCT2_DSC
		lPCT2_DSC	:= ( nPCT2_E07D	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E07DSC")}) ) > 0 .OR. lPCT2_DSC
		lPCT2_DSC	:= ( nPCT2_E08D	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E08DSC")}) ) > 0 .OR. lPCT2_DSC
		lPCT2_DSC	:= ( nPCT2_E09D	:= aScan(aField[nPosAlias],{|aFieldOpc| ALLTRIM(aFieldOpc[1]) == ALLTRIM("CT2_E09DSC")}) ) > 0 .OR. lPCT2_DSC

	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.2: Validacao da quantidade de estruturas de campos x Alias     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	(nCount++, IncMeter(oMeter,oText01,"Etapa de Validacao ("+STRZERO(nCount,2)+" de "+STRZERO(nTotCount,2)+"): ",oText02,"Validacao da quantidade de estruturas de Campos x Alias",nCount) )/*IncProc()*/

	IF lProcess .AND. LEN(aField) != LEN(aAlias)

		HELP(" ",1,"CSE500PRC.08",,	"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
									"Quantidade de estruturas suportadas/necessarias: "+STRZERO(LEN(aAlias),12)+CRLF+;
									"Quantidade de estruturas informadas no arquivo : "+STRZERO(LEN(aField),12)+CRLF,4,0)
		lProcess := .F.		
	
	ELSE

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.3: Validacao do dicionario de dados x estrutura de campos      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		(nCount++, IncMeter(oMeter,oText01,"Etapa de Validacao ("+STRZERO(nCount,2)+" de "+STRZERO(nTotCount,2)+"): ",oText02,"Validacao do dicionario de dados x estrutura de campos",nCount) )/*IncProc()*/
	
		IF lProcess .AND. aPARAM500[08] == 1

			FOR nX := 1 TO LEN(aAlias)
	
				FOR nY := 1 TO LEN(aField[nX])
	
					IF (aAlias[nX])->(FieldPos(aField[nX][nY][1])) == 0
	
						HELP(" ",1,"CSE500PRC.09",,	"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
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
		(nCount++, IncMeter(oMeter,oText01,"Etapa de Validacao ("+STRZERO(nCount,2)+" de "+STRZERO(nTotCount,2)+"): ",oText02,"Validacao da quantidade de itens das linhas de dados x campos",nCount) )/*IncProc()*/

		IF lProcess

			FOR nX := 1 TO LEN(aAlias)
				
				nLenFields := Len(aField[nX])
				             
				FOR nY := 1 TO LEN(aData[nX])
	
					nLenData := Len(aData[nX][nY])
								
					IF nLenData != nLenFields
	
						HELP(" ",1,"CSE500PRC.10",,	"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
													"Quantidade de campos invalida: "+CRLF+;
													"Alias: "+aAlias[nX]	 +" / Campos: "+STRZERO(nLenFields,12)+CRLF+;
													"Linha: "+STRZERO(nY,12) +" / Campos: "+STRZERO(nLenData,12)+" .",4,0)
						lProcess := .F.
						EXIT
					
					ENDIF	
				
				NEXT nY
			
			NEXT nX

		ENDIF

	ENDIF
	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3a Etapa: Efetua a contabilizacao das informacoes com base       ³
//³          no array dos dados importados.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3.0: Verifica o layout selecionado para o arquivo para aplicar     ³
	//³     os tratamentos especificos                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF 		MV_PAR09 == 1 // LAYOUT PADRAO
			CSELAY01P(oMeter, oText01, oText02, oDlg, aAlias, @aAliasIt, @aData, @aField, APARAM500, lConverte, lPCT2_DSC)	
	ELSEIF  MV_PAR09 == 2 // LAYOUT DESPESAS
			CSELAY02D(oMeter, oText01, oText02, oDlg, aAlias, @aAliasIt, @aData, @aField, APARAM500, lConverte, lPCT2_DSC)	
	ELSEIF	MV_PAR09 == 3 // LAYOUT RECEITAS
			CSELAY03R(oMeter, oText01, oText02, oDlg, aAlias, @aAliasIt, @aData, @aField, APARAM500, lConverte, lPCT2_DSC)	
	ENDIF

	FOR nX := 1 TO Len(aAliasIt)

		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0

			( nCount :=0, nTotCount:= Len(aData[nPosAlias]), oMeter:nTotal := nTotCount ) /*ProcRegua(Len(aData[nPosAlias]))*/

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³3.1.3: Ordena o array de dados pelo campo data do lancamento       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSort(aData[nPosAlias],,,{|x,y| x[nPCT2_DTA] < y[nPCT2_DTA]})

			dDataAtu := CTOD("")
			
			FOR nY := 1 TO Len(aData[nPosAlias])

				(nCount++, IncMeter(oMeter,oText01,"Etapa de Contabilização (03 de 03): ",oText02,"Processando dados do registro "+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )/*IncProc()*/
				
				cPadrao	 := aData[nPosAlias][nY][nPCT2_LP]
				lPadrao	 := VerPadrao(cPadrao)
				dDataLcto:= aData[nPosAlias][nY][nPCT2_DTA]
		
	      		IF Empty(dDataAtu)
					dDataAtu  := dDataLcto
					dDataBase := dDataLcto
				ELSEIF dDataAtu != dDataLcto
					lQuebra   := .T.
				ENDIF

				IF lPadrao

					IF !lHead
						lHead := .T.
						nHdlPrv:=HeadProva(cLote,"CSEA500",Substr(cUsuario,7,6),@cArquivo)
					ENDIF

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ FECHA DOCUMENTO DE CONTABILIZACAO: POR DATA         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF lQuebra
						RodaProva(nHdlPrv,nTotal)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Envia para Lan‡amento Cont bil                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lDigita  := IIF(mv_par01==1,.T.,.F.)
						lAglut   := IIF(mv_par02==1,.T.,.F.)
						cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
						nTotal   := 0
						lQuebra  := .F.
						lHead	 := .F.     
						dDataAtu := dDataLcto
						dDataBase:= dDataLcto
					ENDIF

					IF !lHead
						lHead := .T.
						nHdlPrv:=HeadProva(cLote,"CSEA500",Substr(cUsuario,7,6),@cArquivo)
					ENDIF

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ ZERA AS VARIAVEIS UTILIZADAS NO PROCESSO ANTERIOR   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					VALOR 		:= 0
					HISTORICO 	:= ""
					DEBITO 		:= ""
					CREDITO 	:= ""
					CUSTOD		:= ""
					CUSTOC		:= ""
					ITEMD		:= ""
					ITEMC		:= ""
					CLVLD		:= ""
					CLVLC		:= ""
					EC05DB		:= ""
					EC05CR		:= ""
					EC06DB		:= ""
					EC06CR		:= ""
					EC07DB		:= ""
					EC07CR		:= ""
					EC08DB		:= ""
					EC08CR		:= ""
					EC09DB 		:= ""
					EC09CR		:= ""
					XBUFFER		:= ""

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ CARREGA AS VARIAVEIS DE CONTABILIZACAO COM A LINHA  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					VALOR 		:= aData[nPosAlias][nY][nPCT2_VLR]
					HISTORICO 	:= aData[nPosAlias][nY][nPCT2_HST]

					IF aData[nPosAlias][nY][nPCT2_DC] == "1" 
					
						DEBITO 		:= aData[nPosAlias][nY][nPCT2_CTA]
						CUSTOD		:= IIF( nPCT2_CUS > 0, aData[nPosAlias][nY][nPCT2_CUS], "")
						ITEMD		:= IIF( nPCT2_ITM > 0, aData[nPosAlias][nY][nPCT2_ITM], "")
						CLVLD		:= IIF( nPCT2_CLV > 0, aData[nPosAlias][nY][nPCT2_CLV], "")
						EC05DB		:= IIF( nPCT2_E05 > 0, aData[nPosAlias][nY][nPCT2_E05], "")
						EC06DB		:= IIF( nPCT2_E06 > 0, aData[nPosAlias][nY][nPCT2_E06], "")
						EC07DB		:= IIF( nPCT2_E07 > 0, aData[nPosAlias][nY][nPCT2_E07], "")
						EC08DB		:= IIF( nPCT2_E08 > 0, aData[nPosAlias][nY][nPCT2_E08], "")
						EC09DB 		:= IIF( nPCT2_E09 > 0, aData[nPosAlias][nY][nPCT2_E09], "")

					ELSE
					
						CREDITO 	:= aData[nPosAlias][nY][nPCT2_CTA]
						CUSTOC		:= IIF( nPCT2_CUS > 0, aData[nPosAlias][nY][nPCT2_CUS], "")
						ITEMC		:= IIF( nPCT2_ITM > 0, aData[nPosAlias][nY][nPCT2_ITM], "")
						CLVLC		:= IIF( nPCT2_CLV > 0, aData[nPosAlias][nY][nPCT2_CLV], "")
						EC05CR		:= IIF( nPCT2_E05 > 0, aData[nPosAlias][nY][nPCT2_E05], "")
						EC06CR		:= IIF( nPCT2_E06 > 0, aData[nPosAlias][nY][nPCT2_E06], "")
						EC07CR		:= IIF( nPCT2_E07 > 0, aData[nPosAlias][nY][nPCT2_E07], "")
						EC08CR		:= IIF( nPCT2_E08 > 0, aData[nPosAlias][nY][nPCT2_E08], "")
						EC09CR		:= IIF( nPCT2_E09 > 0, aData[nPosAlias][nY][nPCT2_E09], "")
					
					ENDIF

					nTotal += DetProva(nHdlPrv,cPadrao,"CSEA500",cLote)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ FECHA DOCUMENTO DE CONTABILIZACAO: POR LINHA        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF aPARAM500[05] == 1	// Cada linha contabilizada sera um documento
						RodaProva(nHdlPrv,nTotal)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Envia para Lan‡amento Cont bil                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lDigita	 :=IIF(aPARAM500[01] ==1,.T.,.F.)
						lAglut 	 :=IIF(aPARAM500[02] ==1,.T.,.F.)
						cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
						nTotal 	 := 0
						lHead	 := .F.     
						dDataAtu := dDataLcto
						dDataBase:= dDataLcto
					ENDIF

				ENDIF

			NEXT nY
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ FECHA DOCUMENTO DE CONTABILIZACAO: ENCERRAMENTO     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF (lHead .OR. lQuebra) .AND. nTotal > 0
				RodaProva(nHdlPrv,nTotal)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envia para Lan‡amento Cont bil                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lDigita := IIF(aPARAM500[01]==1,.T.,.F.)
				lAglut  := IIF(aPARAM500[02]==1,.T.,.F.)
				cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
			ENDIF
        
		ELSE

			HELP(" ",1,"CSE500PRC.11",,	"Erro no processamento dos dados para contabilizacao."+CRLF+;
										         "Alias de itens: "+aAliasIt[nX],4,0)
			lProcess := .F.
			DisarmTransaction()
			EXIT

		ENDIF				

	NEXT nX

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
±±ºPrograma  ³ CSELAY01PºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para tratamento do layout de importacao padrao      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSEA500 - CONTABILIZACAO OFF-LINE DE LANCAMENTOS CSV       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSELAY01P(oMeter, oText01, oText02, oDlg, aAlias, aAliasIt, aData, aField, APARAM500, lConverte, lPCT2_DSC)

Local aArea			:= GetArea()
Local nX,nY,nZ
Local nPosAlias		:= 0
Local nCount		:= 0
Local nTotCount		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3.1: Processamento da contabilizacao com base no array de dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FOR nX := 1 TO Len(aAliasIt)

	IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0

		( nCount :=0, nTotCount:= Len(aData[nPosAlias]), oMeter:nTotal := nTotCount ) /*ProcRegua(Len(aData[nPosAlias]))*/

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.1.1: Efetua conversao dos dados em formato caracter para o       ³
		//³       formato dos campos										  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nY := 1 TO Len(aData[nPosAlias])

			(nCount++, IncMeter(oMeter,oText01,"Etapa de Contabilização (01 de 03): ",oText02,"Adequando formato dos dados do registro "+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )/*IncProc()*/
			
			FOR nZ := 1 TO Len(aField[nPosAlias])

				DO CASE
					CASE aField[nPosAlias][nZ][2] == "C"
						aData[nPosAlias][nY][nZ] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]) )
					CASE aField[nPosAlias][nZ][2] == "L"
						aData[nPosAlias][nY][nZ] := IIF( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. )
					CASE aField[nPosAlias][nZ][2] == "D"
						aData[nPosAlias][nY][nZ] := IIF(aPARAM500[07] == 1, STOD( ALLTRIM(aData[nPosAlias][nY][nZ]) ),  CTOD( ALLTRIM(aData[nPosAlias][nY][nZ]) ) )
					CASE aField[nPosAlias][nZ][2] == "N"
						aData[nPosAlias][nY][nZ] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]), lConverte)
					CASE aField[nPosAlias][nZ][2] == "M"
						aData[nPosAlias][nY][nZ] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]) )
				ENDCASE

			NEXT nZ                  

		NEXT nY

		( nCount :=0, nTotCount:= Len(aData[nPosAlias]), oMeter:nTotal := nTotCount ) /*ProcRegua(Len(aData[nPosAlias]))*/

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.1.2: Efetua a conversao das entidades discriminadas como descri- ³
		//³       cao nos codigos adequados			  						  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lPCT2_DSC

			FOR nY := 1 TO Len(aData[nPosAlias])
	
				(nCount++, IncMeter(oMeter,oText01,"Etapa de Contabilização (02 de 03): ",oText02,"Adequando a codificacao das entidades contabeis "+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )/*IncProc()*/
				
				FOR nZ := 1 TO Len(aField[nPosAlias])
                    
 						DO CASE     					
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_CTTDSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))
							
								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_CCUSTO"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CTT","CTT_CUSTO",xFilial("CTT")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CTT_FILIAL+CTT_DESC01
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_CTDDSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_ITEMCT"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALTTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CTD","CTD_ITEM",xFilial("CTD")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CTD_FILIAL+CTD_DESC01
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_CTHDSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_CLVLCT"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CTH","CTH_CLVL",xFilial("CTH")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CTH_FILIAL+CTH_DESC01
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E05DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E05CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"05"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E06DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E06CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"06"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E07DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E07CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E08DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E08CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"08"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF							
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E09DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E09CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"09"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF
                        ENDCASE
						
				NEXT nZ                  

			NEXT nY
            
		ENDIF

	ELSE

		HELP(" ",1,"CSE500PRC.11",,	"Erro no processamento dos dados para contabilizacao."+CRLF+;
									         "Alias de itens: "+aAliasIt[nX],4,0)
		lProcess := .F.
		DisarmTransaction()
		EXIT

	ENDIF				
    
NEXT nX

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSELAY02DºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para tratamento do layout de importacao de despesas º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSEA500 - CONTABILIZACAO OFF-LINE DE LANCAMENTOS CSV       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSELAY02D(oMeter, oText01, oText02, oDlg, aAlias, aAliasIt, aData, aField, APARAM500, lConverte, lPCT2_DSC)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Os tratamentos para o layout padrao atendem as necessidades       ³
	//³ dos lancamentos de despesas. A opcao foi criada para nao		  ³
	//³	confundir o usuario na selecao dos parametros da rotina           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	CSELAY01P(oMeter, oText01, oText02, oDlg, aAlias, aAliasIt, aData, aField, APARAM500, lConverte, lPCT2_DSC)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSELAY03RºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para tratamento do layout de importacao de receitas º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSEA500 - CONTABILIZACAO OFF-LINE DE LANCAMENTOS CSV       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSELAY03R(oMeter, oText01, oText02, oDlg, aAlias, aAliasIt, aData, aField, APARAM500, lConverte, lPCT2_DSC)

Local aArea			:= GetArea()
Local nX,nY,nZ
Local nPosAlias		:= 0
Local nCount		:= 0
Local nTotCount		:= 0
Local lCT2_SB1COD	:= .F.
Local nPosCT2HST	:= 0
Local cCTADef		:= GETMV("MV_CS500CD",.F.,"999999999")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3.1: Processamento da contabilizacao com base no array de dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FOR nX := 1 TO Len(aAliasIt)

	IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0

		( nCount :=0, nTotCount:= Len(aData[nPosAlias]), oMeter:nTotal := nTotCount ) /*ProcRegua(Len(aData[nPosAlias]))*/

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.1.1: Efetua conversao dos dados em formato caracter para o       ³
		//³       formato dos campos										  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nY := 1 TO Len(aData[nPosAlias])

			(nCount++, IncMeter(oMeter,oText01,"Etapa de Contabilização (01 de 03): ",oText02,"Adequando formato dos dados do registro "+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )/*IncProc()*/
			
			FOR nZ := 1 TO Len(aField[nPosAlias])

				DO CASE
					CASE aField[nPosAlias][nZ][2] == "C"
						aData[nPosAlias][nY][nZ] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]) )
					CASE aField[nPosAlias][nZ][2] == "L"
						aData[nPosAlias][nY][nZ] := IIF( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. )
					CASE aField[nPosAlias][nZ][2] == "D"
						aData[nPosAlias][nY][nZ] := IIF(aPARAM500[07] == 1, STOD( ALLTRIM(aData[nPosAlias][nY][nZ]) ),  CTOD( ALLTRIM(aData[nPosAlias][nY][nZ]) ) )
					CASE aField[nPosAlias][nZ][2] == "N"
						aData[nPosAlias][nY][nZ] := ValFormat( ALLTRIM(aData[nPosAlias][nY][nZ]), lConverte)
					CASE aField[nPosAlias][nZ][2] == "M"
						aData[nPosAlias][nY][nZ] := NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ]) )
				ENDCASE

			NEXT nZ                  

		NEXT nY

		( nCount :=0, nTotCount:= Len(aData[nPosAlias]), oMeter:nTotal := nTotCount ) /*ProcRegua(Len(aData[nPosAlias]))*/

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.1.2: Efetua a conversao das entidades discriminadas como descri- ³
		//³       cao nos codigos adequados			  						  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lPCT2_DSC

			FOR nY := 1 TO Len(aData[nPosAlias])
	
				(nCount++, IncMeter(oMeter,oText01,"Etapa de Contabilização (02 de 03): ",oText02,"Adequando a codificacao das entidades contabeis "+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )/*IncProc()*/
				
				FOR nZ := 1 TO Len(aField[nPosAlias])
                    
 						DO CASE     					
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_CTTDSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))
							
								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_CCUSTO"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CTT","CTT_CUSTO",xFilial("CTT")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CTT_FILIAL+CTT_DESC01
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_CTDDSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_ITEMCT"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALTTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CTD","CTD_ITEM",xFilial("CTD")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CTD_FILIAL+CTD_DESC01
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_CTHDSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_CLVLCT"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CTH","CTH_CLVL",xFilial("CTH")+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CTH_FILIAL+CTH_DESC01
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E05DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E05CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"05"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E06DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E06CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"06"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E07DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E07CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E08DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E08CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"08"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF							
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_E09DSC" 
		
							IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))

								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E09CTA"})
			
								IF nPosField > 0 .AND. EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
								
									aData[nPosAlias][nY][nPosField] := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"09"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nZ]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
								
								ENDIF
							ENDIF
                        ENDCASE
						
				NEXT nZ                  

			NEXT nY
            
		ENDIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.1.2.1: Tratamento para definir o campo conta em funcao do produto³
		//³         ou da entidade 07 - produtos comercializados              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lCT2_SB1COD := aScan(aField[nPosAlias],{|aFieldsCT2| ALLTRIM(aFieldsCT2[1]) == "CT2_SB1COD"} ) > 0
		
		IF lCT2_SB1COD
      
			nPosCT2HST := aScan(aField[nPosAlias],{|aFieldsCT2| ALLTRIM(aFieldsCT2[1]) == "CT2_HIST"} )

			FOR nY := 1 TO Len(aData[nPosAlias])
	
				(nCount++, IncMeter(oMeter,oText01,"Etapa de Contabilização (02.1 de 03): ",oText02,"Tratamentos especificos para movimentos de receitas: "+STRZERO(nCount,12)+" de "+STRZERO(nTotCount,12),nCount) )/*IncProc()*/
				
				FOR nZ := 1 TO Len(aField[nPosAlias])
                    
 						DO CASE     					
						CASE ALLTRIM(aField[nPosAlias][nZ][1]) == "CT2_CONTA" 

							IF EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])))
		
								nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E07CTA"})
		
								IF !EMPTY(aData[nPosAlias][nY][nPosField])
									
									cDadosTMP := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nPosField]))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO

									IF !EMPTY(cDadosTMP)
										aData[nPosAlias][nY][nZ] := cDadosTMP 
									ELSE

										aData[nPosAlias][nY][nZ] := cCTADef
										IF ValType(aData[nPosAlias][nY][nPosCT2HST]) == "C" .AND. !EMPTY(aData[nPosAlias][nY][nPosCT2HST])
											aData[nPosAlias][nY][nPosCT2HST] += " "+aData[nPosAlias][nY][nPosField]+": CONTA CONTABIL NAO CONFIGURADA"
										ELSE
											aData[nPosAlias][nY][nPosCT2HST] := aData[nPosAlias][nY][nPosField]+": CONTA CONTABIL NAO CONFIGURADA"
										ENDIF
									
									ENDIF
		
								ELSE
								
									nPosField := aScan(aField[nPosAlias],{|aField| ALLTRIM(aField[1]) == "CT2_E07DSC"})
									
									IF !EMPTY(NoAcento(ALLTRIM(aData[nPosAlias][nY][nPosField])))
										
										cDadosTMP := GetAdvFVal("CV0","CV0_CODIGO",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM(aData[nPosAlias][nY][nPosField]))),4,"") //CV0_FILIAL + CV0_PLANO + CV0_DESC
										
										IF !EMPTY(cDadosTMP)
											
											cDadosTMP := GetAdvFVal("CV0","CV0_ENT01",xFilial("CV0")+"07"+NoAcento(UPPER(ALLTRIM( cDadosTMP ))),1,"") //CV0_FILIAL + CV0_PLANO + CV0_CODIGO
											
											IF !EMPTY(cDadosTMP)
												aData[nPosAlias][nY][nZ] := cDadosTMP 
											ELSE
		
												aData[nPosAlias][nY][nZ] := cCTADef
												IF ValType(aData[nPosAlias][nY][nPosCT2HST]) == "C" .AND. !EMPTY(aData[nPosAlias][nY][nPosCT2HST])
													aData[nPosAlias][nY][nPosCT2HST] += " "+aData[nPosAlias][nY][nPosField]+": CONTA CONTABIL NAO CONFIGURADA"
												ELSE
													aData[nPosAlias][nY][nPosCT2HST] := aData[nPosAlias][nY][nPosField]+": CONTA CONTABIL NAO CONFIGURADA"
												ENDIF
											
											ENDIF
										
										ELSE

											aData[nPosAlias][nY][nZ] := cCTADef
											IF ValType(aData[nPosAlias][nY][nPosCT2HST]) == "C" .AND. !EMPTY(aData[nPosAlias][nY][nPosCT2HST])
												aData[nPosAlias][nY][nPosCT2HST] += " "+aData[nPosAlias][nY][nPosField]+": CONTA CONTABIL NAO CONFIGURADA"
											ELSE
												aData[nPosAlias][nY][nPosCT2HST] := aData[nPosAlias][nY][nPosField]+": CONTA CONTABIL NAO CONFIGURADA"
											ENDIF

										ENDIF
									
									ELSE									
	
										aData[nPosAlias][nY][nZ] := cCTADef
										IF ValType(aData[nPosAlias][nY][nPosCT2HST]) == "C" .AND. !EMPTY(aData[nPosAlias][nY][nPosCT2HST])
											aData[nPosAlias][nY][nPosCT2HST] += " PRODUTO COMERCIALIZADO NAO INFORMADO"
										ELSE
											aData[nPosAlias][nY][nPosCT2HST] := " PRODUTO COMERCIALIZADO NAO INFORMADO"
										ENDIF
									
									ENDIF
								
								ENDIF
							
							ENDIF

                        ENDCASE
						
				NEXT nZ                  

			NEXT nY		

		ENDIF

	ELSE

		HELP(" ",1,"CSE500PRC.11",,	"Erro no processamento dos dados para contabilizacao."+CRLF+;
									         "Alias de itens: "+aAliasIt[nX],4,0)
		lProcess := .F.
		DisarmTransaction()
		EXIT

	ENDIF				
    
NEXT nX

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE500PARºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parambox da rotina de importacao de lanctos contabeis      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSEA500 - CONTABILIZACAO OFF-LINE DE LANCAMENTOS CSV       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE500PAR()

Local aParamBox := {}										// Array de parametros de acordo com a regra da ParamBox
Local cTitulo	:= "Contabilizacao Off-Line de Lancamentos .CSV"	// Titulo da janela de parametros
Local aRet		:= {}										// Array que será passado por referencia e retornado com o conteudo de cada parametro
Local bOk		:= {|| .T.}									// Bloco de codigo para validacao do OK da tela de parametros
Local aButtons	:= {}										// Array contendo a regra para adicao de novos botoes (além do OK e Cancelar) // AADD(aButtons,{nType,bAction,cTexto})
Local lCentered	:= .T.										// Se a tela será exibida centralizada, quando a mesma não estiver vinculada a outra janela
Local nPosx		    										// Posicao inicial -> linha (Linha final: nPosX+274)
Local nPosy													// Posicao inicial -> coluna (Coluna final: nPosY+445)
//Local oMainDlg											// Caso o ParamBox deva ser vinculado a uma outra tela
Local cLoad		:= ""										// Nome do arquivo aonde as respostas do usuário serão salvas / lidas
Local lCanSave	:= .F.										// Se as respostas para as perguntas podem ser salvas
Local lUserSave := .F.										// Se o usuário pode salvar sua propria configuracao
Local nX		:= 0
Local lRet		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01 // Mostra Lan‡amentos Cont beis                     ³
//³ MV_PAR02 // Aglutina Lan‡amentos Cont beis                   ³
//³ MV_PAR03 // Arquivo a ser importado                          ³
//³ MV_PAR04 // Numero do Lote                                   ³
//³ MV_PAR05 // Quebra Linha em Doc.							 ³
//³ MV_PAR06 // Converte formato de valores (Sim/Nao)            ³
//³ MV_PAR07 // Formato da data: (AAAAMMDD / DD/MM/AAAA )        ³
//³ MV_PAR08 // Validar estrutura de campos: (Sim/Nao)           ³
//³ MV_PAR09 // Layout (Padrao / Despesas / Receitas)            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aParamBox,{2,"Mostra Lancamentos Contabeis   " ,2,{"Sim","Nao"}						,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Aglutina lancamentos Contabeis " ,2,{"Sim","Nao"}						,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{6,"Arquivo a importar             " ,SPACE(150)								,"",,"",90 ,.T.,"Arquivo .CSV |*.CSV","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
AADD(aParamBox,{1,"Numero do lote                 " ,CRIAVAR("CT2_LOTE")					,"@!","AllwaysTrue()",,".T.",TamSx3("CT2_LOTE")[1],.T.})
AADD(aParamBox,{2,"Quebra linha em documento      " ,2,{"Sim","Nao"}						,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Converte formato de valores    " ,2,{"Sim","Nao"}						,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Formato da data para conversao " ,2,{"AAAAMMDD","DD/MM/AAAA"}			,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Validar estrutura de campos    " ,2,{"Sim","Nao"}						,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Layout do arquivo              " ,1,{"Padrao","Despesas","Receitas"}	,100,"AllwaysTrue()",.T.,.T.})

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

LOCAL aArea 	:= GetArea() 
LOCAL aAreaSX3 := SX3->(GetArea())
LOCAL cTipo		:= "C"  // RETORNO PADRAO PARA PERMITIR O TRATAMENTO DA INFORMACAO NA ROTINA CHAMADORA

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
	cRet :=	cString	
ENDIF

Return Val(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MsgMeter ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Regua de processamento personalizada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION MsgMeter(bAction, cMsg01, cMsg02, cTitle, lEnd)

Local oDlg
Local oMeter
Local oText01
Local oText02
Local lEnd := .F. 
Local nVal := 0

DEFAULT bAction := {|| Nil}
DEFAULT cMsg01	 := "Processando ..."
DEFAULT cMsg02	 := ""
DEFAULT cTitle	 := "Aguarde"

DEFINE MSDIALOG oDlg FROM 05.00, 05.00 TO 12.00, 75.00 TITLE cTitle /*STYLE DS_MODALFRAME*/
@ 00.50, 01.00 SAY oText01 VAR cMsg01 SIZE 130.00, 10.00 OF oDlg
@ 01.25, 01.00 SAY oText02 VAR cMsg02 SIZE 130.00, 10.00 OF oDlg
@ 02.50, 01.00 METER oMeter VAR nVal TOTAL 10.00 SIZE 265.00, 10.00 OF oDlg
DEFINE SBUTTON FROM 37.50, 200.00 TYPE 2 ACTION lEnd := .F. ENABLE OF oDlg
oDlg:bStart = {|| Eval (bAction, oMeter, oText01, oText02 , oDlg, @lEnd), lEnd := .T., oDlg:End() }

ACTIVATE MSDIALOG oDlg CENTERED VALID lEnd

RETURN Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ IncMeter ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Incrementa a barra de processamento MsgMeter()             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION IncMeter(oMeter, oText01, cText01, oText02, cText02, nCount)

Local bBlock := {||}

DEFAULT cText01 := ""
DEFAULT cText02 := ""

oText01:SetText( cText01 )
oText02:SetText( cText02 )
bBlock := {|| oMeter:Set(nCount), SysRefresh() }
Eval(bBlock)

RETURN Nil