#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#include "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE POS_TPAI		1	//Pai
#DEFINE POS_CMPA		3	//Campos de amarracao
#DEFINE POS_PCHV		4	//Controle de posicao dos campos que compoe a chave

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  IMP_SE5    บAutor ณTOTVS                บ Data ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para importa็ใo da moviemnta็ใo bancแria          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบUso       ณ RENOVA SA                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMP_SE5()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nMetGlob
Local nMetParc
Local oRadioArq
Local nRadioArq			:= 1
Local cText				:= ""
Local cFile				:= Replicate(" ",80)
Local cHeader 			:= "Importa็ใo de dados"
///Local cDelim			:= AllTrim(SuperGetMV("MV_TPDELI",.F.,';'))
Local cDelim			:= ";"                                      // Delimitador
Local nLinCabec			:= 1 										// Padrใo sem linha de cabe็alho
Local cCabec			:= "" 										// String com o cabe็alho do arquivo original, se houver
Local nQtdCab			:= 1 										// String com o cabe็alho do arquivo original, se houver
Local cTipo				:= "1"
Local nPainel			:= 1										//Controlador do sequencial de paineis
Local aTMP				:= {}
Local aLstTPN			:= {} 										//Lista de nomes das tabelas
Local cDrive			:= ""										//Drive do arquivo principal
Local cDir				:= ""										//Diretorio do arquivo principal
Local cArqP				:= ""										//Nome do arquivo principal
Local cExt				:= ""										//Extensao do arquivo principal
Local cTabNome			:= ""                                      	//Descricao da tabela selecionada
Local ni				:= 0										//Contador
Local nIPCOV			:= 2										//Interromper ao encontrar campo obrigatorio vazio
Local _Alert1           := ", impossํvel executar a rotina pois existe uma diverg๊ncia entre o n๚mero de elementos da tabelas de importa็ao e as rotinas."


Static oWizard
Static oSay01

Private _lInput         := GetRemoteType() == -1
Private INCLUI			:= .T.
Private ALTERA			:= .F.
Private cNomeUs			:= Upper(AllTrim(UsrRetName(__cUserID)))
Private aLstObr			:= {} 										//Lista de campos obrigatorios com a seguinte estrutura para cada elemento : Alias, Campo e Titulo
Private aLstCmpSA 		:= {"A1_COD","A2_COD","A3_COD"}				//Campos com sequencia automatica
Private aLstVirtual		:= {}										//Campos virtuais que devem ser desconsiderados
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLista de tabelas para importacao. Estrutura :       ณ
//ณ[1] Para importacao de tabela unica - CARACTER      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aLstTabP		:= {"SE5"}

Private aLstRot			:= {{"FINA100"	,"FIN100"}}      //rotinas utilizadas para gravar as importacoes

Private cTpArq			:= "Delimitado (*.csv)|*.CSV|Delimitado TXT (*.txt)|*.TXT|"					//Extensoes de arquivos aceitas
Private cMensProc		:= "Processando"															//Mensagem do painel de processamento
Private aEstru01		:= {}																		//Estrutura da tabela principal
Private aEstru02		:= {}																		//Estrutura da tabela secundaria
Private aLstIniPad		:= {}																		//Inicializador padrao {ALIAS,CAMPO,VALOR}
Private aLstVDes		:= {"NULL","NIL","VOID"}													//Lista de valores a desconsiderar
Private nTamFil			:= IIf(FindFunction("FWSIZEFILIAL"),FWSizeFilial(),2)						//Tamanho da filial

Private lMsErroAuto	    := .F.
Private lMsHelpAuto	    := .F.
Private lAutoErrNoFile	:= .T.

cFile := GETNEWPAR("RV_PATH","C:\Renova\se501012.csv")	//Nome do arquivo da tabela temporaria

IF !_lInput

   If Len(aLstRot) # Len(aLstTabP)
      MsgAlert(cNomeUs + _Alert1)
	  Return Nil
   Endif
Else
   If Len(aLstRot) # Len(aLstTabP)
      qOut(cNomeUs + _Alert1)
	  Return Nil
   Endif
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicao dos nome das tabelas a ser apresentado para selecao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX2")
SX2->(dbSetOrder(1))
For ni := 1 to Len(aLstTabP)
	If SX2->(dbSeek(IIf(ValType(aLstTabP[ni]) == "C",aLstTabP[ni],aLstTabP[ni][1])))
		aAdd(aLstTPN,Upper(AllTrim(SX2->X2_NOME)) + " (" + IIf(ValType(aLstTabP[ni]) == "C",aLstTabP[ni],aLstTabP[ni][1] + "+" + aLstTabP[ni][2]) + ")")
	Endif
Next ni
cTabNome := RetTabN(nRadioArq,aLstTPN)

IF !_lInput

cText 	:= 	 "Esta rotina tem por objetivo importar as movimenta็๕es bancแrias, atrav้s " + ;
			 "de um arquivo padrใo CSV (delimitado) , e armazena-los na tabela "+ ;
			 "correspondente do sistema."+ CRLF + ;
			 "Os nomes das colunas devem ser os mesmos nomes de campos a serem atualizados."+ CRLF + CRLF + ;
			 "Ao final da importa็ใo serแ gerado um arquivo de log contendo as "+ ;
			 "inconsist๊ncias."

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Abertura              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE WIZARD oWizard 	TITLE "Importa็ใo de dados - SE5" ;
							HEADER cHeader ;
							MESSAGE "" ;
							TEXT cText ;
							NEXT { || .T. } ;
							FINISH {|| .T.} PANEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Tabelas de importacao      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "" ;
							BACK {|| .T. } ;
							NEXT {|| !Empty(cFile)} ;
							FINISH {|| .F. } ;
							PANEL

	nPainel++
	oPanel := oWizard:GetPanel(nPainel)

    @ 10, 08 GROUP oGrpCon 	TO 40, 280 LABEL "Tabela a ser importada" OF oPanel 	PIXEL DESIGN

    @ 20,20 SAY "MOVIMENTAวรO BANCมRIA (SE5)" OF oPanel SIZE 100,8 PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Arquivo e Contrato principal ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	@ 50, 08 GROUP oGrpCon 	TO 80, 280 LABEL "Selecione um arquivo." ;
							OF oPanel ;
							PIXEL ;
	     					DESIGN

	@ 60, 35 MSGET oArq 	VAR cFile WHEN .F. OF oPanel SIZE 180, 10 PIXEL ;
							MESSAGE "Utilize o botใo ao lado para selecionar" ;

	DEFINE SBUTTON oButArq 	FROM 61, 215 ;
					 		TYPE 14 ;
					 		ACTION {|| cFile := Upper(cGetFile(cTpArq,,1,IIf(Empty(cDrive),"SERVIDOR\",cDrive + cDir),.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)), ;
					 		RetEstArq(cFile,@cDrive,@cDir,@cArqP,@cExt)} ;
					 		OF oPanel ;
					 		ENABLE

	@ 90, 08 GROUP oGrpCon 	TO 140, 280 LABEL "Informe as configura็๕es do arquivo." ;
							OF oPanel ;
							PIXEL ;
	     					DESIGN

  	@ 100,20 SAY "Delimitador" OF oPanel SIZE 35,8 PIXEL
	@ 100,60 SAY cDelim		OF oPanel SIZE 10,8 PIXEL


  	@ 120,20 SAY "Tipo" OF oPanel SIZE 35,8 PIXEL
	@ 120,60 COMBOBOX oTipo  Var cTipo ITEMS {"1=Somente Log","2=Log + Importa็ใo"} 	SIZE 200,010 OF oPanel PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPainel - Processamento                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Processamento da Importa็ใo." ;
							BACK {|| .F. } ;
							NEXT {|| .T. } ;
							FINISH {|| .T. } ;
							EXEC {|| CursorWait(), IMPCADPro(oMetGlob,nRadioArq,cFile,cDelim,cTipo,nIPCOV), CursorArrow() } ;
							PANEL

	nPainel++
	oPanel := oWizard:GetPanel(nPainel)

	@ 25, 30 SAY oSay01 VAR cMensProc OF oPanel SIZE 140, 8 PIXEL
	@ 40, 30 METER oMetGlob 	VAR nMetGlob ;
								TOTAL 100 ;
								SIZE 224,10 OF oPanel PIXEL UPDATE DESIGN ;
								BARCOLOR CLR_BLACK,CLR_WHITE ;
								COLOR CLR_WHITE,CLR_BLACK

ACTIVATE WIZARD oWizard CENTER

Else
  oMetGlob := 0
  cTipo := "2"
  IMPCADPro(oMetGlob,nRadioArq,cFile,cDelim,cTipo,nIPCOV)
EndIf

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCADPro บAutor  ณTOTVS               บ Data ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao do arquivo selecionado                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบRevisao   ณ01        บAutor ณPablo Gollan Carrerasบ Data ณ  02/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVide cabecalho principal                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPCADPro(oMetGlob,nRadioArq,cFile,cDelim,cTipo,nIPCOV)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea				:= GetArea()
Local lFirst			:= .T.
Local cLinha 			:= ""
Local aHeader			:= {}
Local nHdl    			:= 	0
Local cEnvServ			:= GetEnvServer()
Local cIniFile			:= GetADV97()
Local cEnd				:= GetPvProfString(cEnvServ,"StartPath","",cIniFile)
Local cEnd2             := "C:\"
Local cDtHr 			:= DtoS(dDataBase)+"-"+Substr(time(),1,2)+"-"+Substr(time(),4,2)+"-"+Substr(time(),7,2)
Local cPath				:= "\IMPORT\"
Local cTipoLog			:= "Import_"
Local cNomeLog			:= cPath + cTipoLog + cDtHr + "_Log.txt"
Local cArq				:= cEnd + cNomeLog
Local cArq2             := cEnd2 + cNomeLog
Local cLin				:= ""
Local cCdAlias			:= ""
Local nQtReg			:= 0
Local nQtNOk			:= 0
Local nQtOk				:= 0
Local aLog				:= {}
Local lGrava			:= (cTipo == "2")
Local cRotina			:= ""
Local nCont				:= 0
Local nPos				:= 0		   					//Posicionador
Local nPos02			:= 0							//Posicionador
Local aPosCMP			:= {}							//Posicao de campos
Local nTot02			:= 0							//Totalizador
Local aTMP				:= {}							//Array temporario
Local ni				:= 0							//Contador
Local cFiltro			:= ""							//Filtro de pesquisa
Local aCols02			:= {}							//Array
Local lOk				:= .T.							//Controlador de fluxo
Local nAtu				:= 0							//Registro atual do arquivo de importacao
Local cTMP				:= ""							//Temporaria
Local cDirRem			:= AllTrim(GetClientDir())		//Diretorio do remote
Local lPedComp			:= .F.
Local aLstPCProc		:= {}
Local bErro				:= {|| }
Local lErro				:= .F.
Local cErro				:= ""
Local lIPCOV			:= .F.
Local lVldObrigat       := .F.

Default oMetGlob		:= Nil
Default nRadioArq		:= 0
Default cFile			:= ""
Default cDelim			:= ""
Default cTipo			:= ""
////Default cFile02			:= ""
Default nIPCOV			:= 2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidacao de parametros  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If oMetGlob == Nil .OR. Empty(nRadioArq) .OR. Empty(cFile) .OR. Empty(cDelim) .OR. Empty(cTipo)
	Return Nil
Endif
lIPCOV := (AllTrim(AllToChar(nIPCOV)) == "1")
//Criar diretorio caso seja necessario

If Len(Directory("C:\IMPORT\*.*", "D")) == 0
	MakeDir("C:\IMPORT")
Endif

MakeDir(cEnd + cPath)





//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidacao do arquivo para importacao             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

IF !_lInput
   If !File(cFile) .OR. Empty(cFile)
      ApMsgStop("Problemas com arquivo informado!")
	  RestArea(aArea)
	  Return Nil
   EndIf
Else
   If !File(cFile) .OR. Empty(cFile)
      qOut("Problemas com arquivo informado!")
	  RestArea(aArea)
	  Return Nil
   EndIf
EndIf

cCdAlias 	:= IIf(ValType(aLstTabP[nRadioArq]) == "A",aLstTabP[nRadioArq][1],aLstTabP[nRadioArq])
cRotina		:= aLstRot[nRadioArq][1]

//Carregar campos obrigatorios e inicializadores padrao
SX3Load(cCdAlias)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEstrutura das tabelas envolvidas  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aEstru01 := (cCdAlias)->(dbStruct())

IF !_lInput
   Eval({|| cMensProc := OemToAnsi("Iniciando o LOG"),oSay01:Refresh()})
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia LOG    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aLog,Replicate("=",80))
aAdd(aLog,"INICIANDO O LOG - I M P O R T A C A O   D E   D A D O S")
aAdd(aLog,Replicate("-",80))
aAdd(aLog,"DATABASE...........: " + DtoC(dDataBase))
aAdd(aLog,"DATA...............: " + DtoC(Date()))
aAdd(aLog,"HORA...............: " + Time())
aAdd(aLog,"ENVIRONMENT........: " + GetEnvServer())
aAdd(aLog,"PATCH..............: " + GetSrvProfString("StartPath",""))
aAdd(aLog,"ROOT...............: " + GetSrvProfString("RootPath",""))
aAdd(aLog,"VERSรO.............: " + GetVersao())
aAdd(aLog,"MำDULO.............: " + "SIGA" + cModulo)
aAdd(aLog,"EMPRESA / FILIAL...: " + cEmpAnt + "/" + cFilAnt)
aAdd(aLog,"NOME EMPRESA.......: " + Capital(Trim(SM0->M0_NOME)))
aAdd(aLog,"NOME FILIAL........: " + Capital(Trim(SM0->M0_FILIAL)))
aAdd(aLog,"USUมRIO............: " + SubStr(cUsuario,7,15))
aAdd(aLog,"TABELA IMPORT......: " + cCdAlias)
aAdd(aLog,"ARQUIVO IMPORT.....: " + cFile)
aAdd(aLog,"DELIMITADOR........: " + cDelim)
aAdd(aLog,"MODO PROCESSAMENTO.: " + IIf(lGrava,"Atualizacao","Simulacao"))
aAdd(aLog,"ROTINA IMPORTACAO..: " + Upper(cRotina))
aAdd(aLog,Replicate(":",80))
aAdd(aLog,"")
aAdd(aLog,"Import = INICIO - Data " + DtoC(dDataBase)+ " as " + Time())


IF !_lInput
   Eval({|| cMensProc := OemToAnsi("Processando arquivo principal [" + cCdAlias + "]"),oSay01:Refresh()})
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLeitura do arquivo principal              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FT_FUSE(cFile)
nTot := FT_FLASTREC()
nAtu := 0

IF !_lInput
   oMetGlob:SetTotal(nTot)
   oMetGlob:Set(0)
EndIf
CursorWait()
FT_FGOTOP()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento do arquivo principal  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

While !FT_FEOF()
	nAtu++
	IF !_lInput
	   oMetGlob:Set(nAtu)
	EndIf
	cLinha := LeLinha() //FT_FREADLN()
	If Empty(cLinha) .OR. (!lFirst .AND. cLinha == Replicate(";",Len(aHeader) - 1))
		FT_FSKIP()
		Loop
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento de colunas                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCols 	:= {}
	aCols 	:= TrataCols(cLinha,cDelim)
	aCols02	:= {}
	If lFirst
		aHeader := aClone(aCols)
		lFirst := .F.
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida nomes das colunas                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    	cCpos := ImpVldCols(cCdAlias,aHeader,aEstru01)
		If lVldObrigat
			IF !_lInput
			   If !Empty(cCpos)
				  Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
				  ApMsgStop("Problemas na estrutura do arquivo, faltam as seguintes colunas " + CRLF + cCpos)
				  RestArea(aArea)
				  Return Nil
			   EndIf
			Else
			   If !Empty(cCpos)
				  Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
				  qOut("Problemas na estrutura do arquivo, faltam as seguintes colunas " + CRLF + cCpos)
				  RestArea(aArea)
				  Return Nil
			   EndIf
			EndIf
		Endif
		//Adicionar os campos com inicializacao padrao
		AdCmpIni(cCdAlias,@aHeader)
	Else
		nQtReg++
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValidacao de campos obrigatorios                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lVldObrigat
			cMsg := ImpObrigat(cCdAlias,aCols,aHeader,,aEstru01)

			If !Empty(cMsg)
				If lIPCOV
					Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
					IF !_lInput
					   ApMsgStop("ERRO : " + CRLF + cMsg)
					EndIf
					RestArea(aArea)
					Return
				Else
			  	   AtuLog("NO MOT: CAMPOS OBRIGATORIOS - REGISTRO IGNORADO - "+cMsg,@aLog,nAtu)
					nQtNOk++
					FT_FSKIP()
					Loop
				Endif
			EndIf
		Endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณChamada de rotina automatica de inclusao                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lGrava
			aRet := {}
			/*
			bErro := ErrorBlock({|e| VerErro(e,@lErro,@cErro)})
			Begin Sequence
			*/
				aRet := ImpGrava(cCdAlias,cRotina,aCols,aHeader,,,,FT_FRECNO())
			/*
			Recover
			End Sequence
			If lErro
				AtuLog(cErro,@aLog,nAtu)
				RestArea(aArea)
				ErrorBlock(bErro)
			    Return Nil
			Endif
			ErrorBlock(bErro)
			*/
			If aRet[1]
				nQtOk++
    			   AtuLog("OK MOT:REGISTRO INCLUIDO" + aRet[2],@aLog,nAtu)
			Else
				   AtuLog("NO MOT: PROBLEMAS NA GRAVACAO ROTINA AUTOMATICA - " + cRotina + " - " + aRet[2],@aLog,nAtu)
				nQtNOk++
			EndIf
		Else
			nQtOk++
			   AtuLog("OK MOT:REGISTRO INCLUIDO",@aLog,nAtu)
		EndIf
	EndIf
	FT_FSKIP()
EndDo
FT_FUSE()
IF !_lInput
   Eval({|| cMensProc := OemToAnsi("Finalizando"),oSay01:Refresh()})
EndIf
aAdd(aLog, "Import = Total de Registros = "+ Alltrim(Str(nQtReg)))
aAdd(aLog, "Import = Registros Nao importados = "+ Alltrim(Str(nQtNOk)))
aAdd(aLog, "Import = Registros importados = "+ Alltrim(Str(nQtOk)))
aAdd(aLog, "Import = FIM Data "+DtoC(dDataBase)+ " as "+Time() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFinaliza arquivo de Log                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nHdl := fCreate(cArq)  // cria log na pasta system
If nHdl == -1
	   Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
    IF !_lInput
	   MsgAlert("O arquivo  " + cArq + " nao pode ser criado!","Atencao!")
	Else
	  qOut("O arquivo  " + cArq + " nao pode ser criado!","Atencao!")
	EndIf
	fClose(nHdl)
	fErase(cArq)
	RestArea(aArea)
 	Return Nil
EndIf

nHdl2 := fCreate(cArq2)    // cria log no c:\import
If nHdl2 == -1
	Eval({|| cMensProc := OemToAnsi("ERRO!"),oSay01:Refresh()})
    IF !_lInput
	   MsgAlert("O arquivo  " + cArq2 + " nao pode ser criado!","Atencao!")
	Else
       qOut("O arquivo  " + cArq2 + " nao pode ser criado!","Atencao!")
	EndIf
	fClose(nHdl2)
	fErase(cArq2)
	RestArea(aArea)
 	Return Nil
EndIf

For nCont := 1 to Len(aLog)
	cLin += aLog[nCont] + CRLF
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		fClose(nHdl)
	    fErase(cArq)
	    cLin:=""
		RestArea(aArea)
	    Return Nil
	EndIf
	cLin:=""
Next nCont
fClose(nHdl)

For nCont := 1 to Len(aLog)
	cLin += aLog[nCont] + CRLF
	If fWrite(nHdl2,cLin,Len(cLin)) != Len(cLin)
		fClose(nHdl2)
	    fErase(cArq2)
	    cLin:=""
		RestArea(aArea)
	    Return Nil
	EndIf
	cLin:=""
Next nCont
fClose(nHdl2)

IF !_lInput
   Eval({|| cMensProc := OemToAnsi("Processo de importa็ใo concluํdo!"),oSay01:Refresh()})
EndIf
cTMP := cTipoLog + cDtHr + "_Log.txt"
//Se o arquivo de log existir localmente, excluir
If File(cDirRem + cTMP)
	fErase(cDirRem + cTMP)
Endif
//Copiar do servidor para a estacao
If CpyS2T(cArq,cDirRem,.F.)
	ShellExecute("open",cDirRem + cTMP,"","",1)
Endif

If cTipo <> "1"
   If lOk := .F.
      FRENAME(cFile,substr(cfile,1,len(cfile)-3)+"TER")   // Renomeia arquivo para .TER (Aquivo com erros)
   Else
      FRENAME(cFile,substr(cfile,1,len(cfile)-3)+"TOK")   // Renomeia arquivo para .TOK (Arquivo correto)
   EndIf
EndIf

RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuLog    บAutor  ณTOTVS               บ Data ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza Array de Log                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuLog(cMsg,aLog,nAtu)

aAdd(aLog,"Import = Linha " + StrZero(nAtu,12) + " = " + " LOG = " + cMsg)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLeLinha   บAutor  ณTOTVS               บ Data ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento de leitura de linha TXT, principalmente para     บฑฑ
ฑฑบ          ณcasos de ultrapassar 1Kb por linha                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LeLinha()

Local cLinhaTmp := ""
Local cLinhaM100 := ""

cLinhaTmp := FT_FReadLN()

If !Empty(cLinhaTmp)
	cIdent:= Substr(cLinhaTmp,1,1)
	If Len(cLinhaTmp) < 1023
		cLinhaM100 := cLinhaTmp
	Else
		cLinAnt := cLinhaTmp
		cLinhaM100 += cLinAnt
		FT_FSkip()
		cLinProx := FT_FReadLN()
		If Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent
			While Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent .and. !Ft_fEof()
				cLinhaM100 += cLinProx
				FT_FSkip()
				cLinProx := FT_FReadLn()
				If Len(cLinProx) < 1023 .and. Substr(cLinProx,1,1) <> cIdent
					cLinhaM100 += cLinProx
				Endif
			Enddo
		Else
			cLinhaM100 += cLinProx
		Endif
	Endif
Endif

Return(cLinhaM100)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTrataCols บAutor  ณTOTVS               บ Data ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna array com as colunas da linha informada             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TrataCols(cLinha,cSep,aEstru)

Local aRet 				:= {}
Local nPosSep			:= 0
Local aCmpNome         	:= ""

nPosSep	:= At(cSep,cLinha)
While nPosSep <> 0
	aCmpNome := Upper(AllTrim(SubStr(cLinha,1,nPosSep - 1)))
	//aAdd(aRet,aCmpNome)
	aAdd(aRet,StrTran(aCmpNome,",","."))
	cLinha := SubStr(cLinha,nPosSep + 1)
 	nPosSep	:= At(cSep,cLinha)
EndDo
aAdd(aRet,cLinha)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณRetCol    บAutor ณTOTVS               บ Data ณ  20/05/14    บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o conteudo formatado de uma dada coluna de acordo   บฑฑ
ฑฑบ          ณcom o seu tipo de dados                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetCol(cCpo,aCols,aHeader,aEstru,cAlias)

Local uRet 				:= ""
Local nPos				:= 0
Local nPos02			:= 0
Local aCmpPZero			:= {"N1_ITEM","N3_TIPO","N3_SEQ"}			//Campos que devem ser preenchidos com zero

If Empty(cCpo) .OR. Len(aCols) == 0 .OR. Len(aHeader) == 0 .OR. Len(aEstru) == 0
	Return uRet
Endif
If (nPos := aScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim(cCpo))})) > 0 .AND. nPos <= Len(aCols)
	If (nPos02 := aScan(aEstru,{|x| Upper(AllTrim(x[1])) == Upper(Alltrim(cCpo))})) > 0
		Do Case
			Case aEstru[nPos02][2] == "D"
				//Caso o campo nao esteja vazio ou nao esteja preenchido com valores que indicam NULO
				If !Empty(aCols[nPos]) .AND. aScan(aLstVDes,{|x| x == Upper(AllTrim(aCols[nPos]))}) == 0
					If At("/",aCols[nPos]) == 0
						uRet := StoD(aCols[nPos])
					Else
						uRet := CtoD(aCols[nPos])
					Endif
				Else
					uRet := CtoD("")
				Endif
			Case aEstru[nPos02][2] == "N"
				//Caso o campo nao esteja vazio ou nao esteja preenchido com valores que indicam NULO
				If !Empty(aCols[nPos]) .AND. aScan(aLstVDes,{|x| x == Upper(AllTrim(aCols[nPos]))}) == 0
					uRet := GetDtoVal(AllTrim(aCols[nPos]))
				Else
					uRet := 0
				Endif
			Otherwise
				//Caso o campo esteja preenchido com valores que indicam NULO, zerar
				If aScan(aLstVDes,{|x| x == Upper(AllTrim(aCols[nPos]))}) > 0
					aCols[nPos] := ""
				Endif
				//Validar se o campo eh de filial, se for preencher com zeros a esquerda
				If Right(aEstru[nPos02][1],7) == "_FILIAL"
					If SX2Modo(cAlias) == "C"
						uRet := Space(nTamFil)
					Else
						If !Empty(aCols[nPos])
							uRet := PadL(Upper(AllTrim(aCols[nPos])),nTamFil,"0")
						Else
							uRet := Space(nTamFil)
						Endif
					Endif
				Else
					//Verificar se o campo nao esta categorizado para ter seus espacos preenchidos com zero
					If aScan(aCmpPZero,{|x| x = Upper(AllTrim(cCpo))}) == 0
						uRet := PadR(Upper(AllTrim(aCols[nPos])),aEstru[nPos02][3])
					Else
						uRet := PadL(Upper(AllTrim(aCols[nPos])),aEstru[nPos02][3],"0")
					Endif
				Endif
		EndCase
	Else
		If nPos <= Len(aCols)
			If !Empty(aCols[nPos]) .AND. aScan(aLstVDes,{|x| x == Upper(AllTrim(aCols[nPos]))}) == 0
				uRet := Upper(AllTrim(aCols[nPos]))
			Endif
		Endif
	Endif
Endif

Return uRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpVldColsบAutor  ณTOTVS               บ Data ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAnalise de colunas obrigatorias para cada alias             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบRevisao   ณ001       บAutor ณPablo Gollan Carrerasบ Data ณ  01/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณUtilizacao da funcao ImpObrigat para validar os campos do   บฑฑ
ฑฑบ          ณcabecalho do arquivo                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpVldCols(cCdAlias,aHeader,aEstru)

Local cRet 				:= ""
Local ni				:= 0

Default aEstru			:= {}

cRet := ImpObrigat(cCdAlias,,aHeader,.T.)
If Empty(cRet) .AND. Len(aEstru) > 0
	//Verificar se no cabecalho existe alguma coluna que nao existe no dicionario de dados
	For ni := 2 to Len(aHeader)
		//Caso o campo seja virtual, nao validar com a estrutura
		If aScan(aLstVirtual,{|x| x == Upper(AllTrim(aHeader[ni]))}) == 0
			If aScan(aEstru,{|x| Upper(AllTrim(x[1])) == Upper(AllTrim(aHeader[ni]))}) == 0
			  cRet += "A coluna " + Upper(AllTrim(aHeader[ni])) + " nใo consta no dicionแrio de dados!" + CRLF
			Endif
		Endif
	Next ni
Endif

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpObrigatบAutor  ณTOTVS               บ Data ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida preenchimento/conteudo de campos obrigatorios        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบRevisao   ณ001       บAutor ณPablo Gollan Carrerasบ Data ณ  15/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFazer com que a rotina monte a lista de campos obrigatorios บฑฑ
ฑฑบ          ณatraves do dicionario de dados e nao de campos chumbados.   บฑฑ
ฑฑบ          ณ------------------------------------------------------------บฑฑ
ฑฑบ          ณExpansao da funcionalidade que valida conteudo de campos e  บฑฑ
ฑฑบ          ณo campos do cabecalho do arquivo.                           บฑฑ
ฑฑบ          ณ------------------------------------------------------------บฑฑ
ฑฑบ          ณTratamento para ignorar campo vazios que possuam sequencia  บฑฑ
ฑฑบ          ณautomatica.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTotvs                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpObrigat(cCdAlias,aCols,aHeader,lVldHead,aEstru)

Local cRet 				:= ""
Local ni				:= 0
Local cTMP				:= ""

Default aCols			:= {}
Default lVldHead		:= .F.
Default aEstru			:= {}

If Empty(cCdAlias)
	Return cRet
Endif
cCdAlias := AllTrim(Upper(cCdAlias))

If !lVldHead
	//Validar se os campos obrigatorios da tabela nao estao vazios no registros passado
	For ni := 1 to Len(aLstObr)
		If aLstObr[ni][1] == cCdAlias
			//Se o conteudo do campo obrigatorio estiver vazio e o campo nao estiver na lista de campos de sequencia automatica
			cTMP := RetCol(aLstObr[ni][2],aCols,aHeader,aEstru,cCdAlias)
			If Empty(cTMP) .AND. aScan(aLstCmpSA,{|x| AllTrim(Upper(x)) == aLstObr[ni][2]}) == 0
				cRet += "A coluna obrigat๓ria " + aLstObr[ni][2] + " (" + aLstObr[ni][3] + ") estแ vazia!" + CRLF
			Endif
		Endif
	Next ni
Else
	//Validar se os campos obrigatorios da tabela constam no header do arquivo
	For ni := 1 to Len(aLstObr)
		If aLstObr[ni][1] == cCdAlias
			If aScan(aHeader,{|x| Upper(AllTrim(x)) == aLstObr[ni][2]}) == 0
				cRet += "A coluna obrigat๓ria " + aLstObr[ni][2] + " (" + aLstObr[ni][3] + ") nใo consta no cabe็alho do arquivo!" + CRLF
			Endif
		Endif
	Next ni
Endif

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpGrava  บAutor  ณTOTVS               บ Data ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamada da rotina automatica de gravacao                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpGrava(cCdAlias,cRotina,aCols,aHeader,cCdAlias02,aCols02,aHeader02,nLinProc)

Local nx				:= 0
Local ni				:= 0
Local lOk				:= .F.
Local cMsg				:= ""
Local lGeraNumSeq		:= .F.
Local nPosSA			:= 0
Local cArqErro			:= "ERRO_AUTO.TXT"
Local lTemFil			:= .F.
Local lTemFil02			:= .F.
Local cCpoFil 			:= IIf(SubStr(cCdAlias,1,1) == "S", SubStr(cCdAlias,2,2), cCdAlias) + "_FILIAL"
Local cCpoFil02 		:= ""
Local cFilAlia			:= xFilial(cCdAlias)
Local cFilAlia02		:= ""
Local uTMP				:= Nil
Local cCMPAt			:= ""									//Nome do campo atual
Local aTMP				:= {} 									//Array temporaria
Local cREG				:= ""									//Referencia do registro processado
Local lPedComp			:= At("MATA120",Upper(cRotina)) > 0	//Rotina de pedido de compras?
Local aErro				:= {}
Local nTamItem			:= TamSX3("C7_ITEM")[1]
Local nPosVP			:= 0									//Posicao do valor padrao de campos
Local lGrvVazio			:= .F.									//Gravar mesmo vazio
Local nPosRot			:= 0									//Posicionador para busca de rotina
Local aFINA100          := {}
Local _cEMPRES          := ""
Local _cEmp             := .T.
Local nScan             := Nil
Local cMsgValid         := ""
Local cOldFilAnt        := cFilAnt
Local aSM0Sav           := SM0->(GetArea())


Private aReg			:= {}
Private aReg02			:= {}
Private cRotAuto		:= ""


Default cCdAlias02		:= ""
Default aCols02			:= {}
Default aHeader02		:= {}
Default nLinProc		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta array com os campos do registro                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nx := 1 to Len(aHeader)
	cCMPAt := Upper(Alltrim(aHeader[nx]))
	//Saltar se o campo for virtual
	If aScan(aLstVirtual,{|x| x == cCMPAt}) > 0
		Loop
	Endif
	//Verificar se o campo do header do arquivo existe na estrutura da tabela de destino
	If aScan(aEstru01,{|x| Upper(AllTrim(x[1])) == cCMPAt}) > 0
		uTMP := RetCol(cCMPAt,aCols,aHeader,aEstru01,cCdAlias)
		lGrvVazio := .F.
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se possui campo sequencial informado                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nPosSA == 0 .AND. Empty(uTMP) .AND. (nPosSA := aScan(aLstCmpSA,{|x| AllTrim(Upper(x)) == AllTrim(Upper(aHeader[nx]))})) > 0
			lGeraNumSeq := .T.
		Else
			//Caso o campo esteja vazio, se tiver, utilizar o inicializador padrao
			If Empty(uTMP)

				If (nPosVP := aScan(aLstIniPad,{|x| x[1] == Upper(AllTrim(cCdAlias)) .AND. x[2] == cCmpAt})) > 0
					lGrvVazio := .T.
					//Se nao utiliza memvar, inicializar o campo
					If At("->",aLstIniPad[nPosVP][3]) == 0
						uTMP := &(aLstIniPad[nPosVP][3])
					Endif
				Endif
			Endif
			//Caso o conteudo do campo definido no arquivo de origem nao seja nulo, adicionar
			If !Empty(uTMP) .OR. lGrvVazio
				//Adicionar ao array que sera passado para rotina automatica
					aAdd(aReg,{cCMPAt,uTMP,Nil})
			Endif
		Endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se informou filial no arquivo              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !lTemFil
			If cCMPAt == cCpoFil
				lTemFil := .T.
		    EndIf
		Endif
	Endif
Next nx
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso seja necessario determinar numero sequencial  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If lGeraNumSeq
	aAdd(aReg,{aLstCmpSA[nPosSA],GetSXENum(cCdAlias),Nil})
	ConfirmSX8()
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso o campo de filial nao tenha sido informado, alimentar  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lTemFil .AND. !Empty(cCpoFil)
	aAdd(aReg,{cCpoFil,cFilAlia,Nil})
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChamada da rotina automatica                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

_cEmp := .F.
DbSelectArea("SM0")
SM0->(DbSetOrder(1))
SM0->(DbGoTop())
While SM0->(!Eof())
    IF Upper(alltrim(SM0->M0_CGC)) == Upper(AllTrim(aCols[1]))
		cFilAnt := Pad(SM0->M0_CODFIL, Len(cFilAnt))
      _cEMPRES := SM0->M0_CODFIL
      _cEmp := .T.
      Exit
    EndIf
    SM0->(Dbskip())
EndDo

If _cEmp == .T.

   dbSelectArea("SE5")
   DbSetOrder(1)

   _cFilial     := _cEMPRES
   _dData       := CTOD(Upper(AllTrim(aCols[2])),"ddmmyy")

   _cMoeda      := Upper(AllTrim(aCols[3]))
   _nValor      := Val(aCols[4]) //Val(STRTRAN(aCols[4], ",", ".")) //Val(aCols[4]) //Upper(AllTrim(aCols[4]))
   _cNatureza   := Upper(AllTrim(aCols[5]))
   _cBANCO	    := Upper(AllTrim(aCols[6]))
   _cAGENCIA    := Upper(AllTrim(aCols[7]))
   _cCONTA	    := Upper(AllTrim(aCols[8]))
   _cRecPag     := Upper(AllTrim(aCols[9]))
   _cHistor     := Upper(AllTrim(aCols[10]))
   _cFilori     := Upper(AllTrim(aCols[1]))
   _cDebito     := Upper(AllTrim(aCols[11]))
   _cCredito    := Upper(AllTrim(aCols[12]))
   _cCCD        := Upper(AllTrim(aCols[13]))
   _cCCC        := Upper(AllTrim(aCols[14]))
   _cItemD      := Upper(AllTrim(aCols[15]))
   _cItemC      := Upper(AllTrim(aCols[16]))
   _cCLVLDB     := Upper(AllTrim(aCols[17]))
   _cCLVLCR     := Upper(AllTrim(aCols[18]))
   _cEC05DB     := Upper(AllTrim(aCols[19]))//Classe Orcamentaria debito
   _cEC05CR     := Upper(AllTrim(aCols[20]))//Classe Orcamentaria Cr้dito

   _cRegistro   := Dtos(_dData) + _cBANCO+_cAGENCIA+_cCONTA
	cMsgValid   := ""

   cRotina      := "FINA100"
   If At("MSEXECAUTO",Upper(cRotina)) > 0
      cRotAuto := cRotina
   Else
    aFINA100 := {    {"E5_FILIAL"     ,_cFilial        ,Nil},;
                     {"E5_DATA"       ,_dData          ,".T."},;
                     {"E5_MOEDA"      ,_cMoeda         ,"fA100Moeda()"},;
                     {"E5_VALOR"      ,_nValor         ,Nil},;
                     {"E5_NATUREZ"    ,_cNatureza      ,Nil},;
                     {"E5_BANCO"      ,_cBANCO         ,Nil},;
                     {"E5_AGENCIA"    ,_cAGENCIA       ,Nil},;
                     {"E5_CONTA"      ,_cCONTA         ,Nil},;
                     {"E5_RECPAG"     ,_cRecPag        ,Nil},;
                     {"E5_HISTOR"     ,_cHistor        ,Nil},;
                     {"E5_FILORIG"    ,_cFilori        ,Nil},;
                     {"E5_DEBITO"     ,_cDebito        ,Nil},;
                     {"E5_CREDITO"    ,_cCredito       ,Nil},;
                     {"E5_CCD"        ,_cCCD           ,Nil},;
                     {"E5_CCC"        ,_cCCC           ,Nil},;
                     {"E5_ITEMD"      ,_cItemD         ,Nil},;
                     {"E5_ITEMC"      ,_cItemC         ,Nil},;
                     {"E5_CLVLDB"     ,_cCLVLDB        ,Nil},;
                     {"E5_CLVLCR"     ,_cCLVLCR        ,Nil},;
                     {"E5_EC05DB"     ,_cEC05DB        ,Nil},;
                     {"E5_EC05CR"     ,_cEC05CR        ,Nil}}

		Aadd(aFINA100, {"E5_MOTBX"    ,"NOR"           ,Nil})
		Aadd(aFINA100, {"E5_VENCTO"   , Date()         ,"FA100VENC()"})

		lMsErroAuto := .F.

		SA6->(dbSetOrder(1))  //  A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
		If ! SA6->(dbSeek(cSeek := xFilial("SA6") + Pad(_cBANCO, Len(SA6->A6_COD)) + Pad(_cAGENCIA, Len(SA6->A6_AGENCIA)) + Pad(_cCONTA, Len(SA6->A6_NUMCON))))
			cMsgValid += "Banco nใo encontrado: " +_cBANCO + "|" + _cAGENCIA + "|" + _cCONTA + Chr(13) + Chr(10)
		Endif
       If _cRecPag == "R"
       MSExecAuto({|x,y,z| FINA100(x,y,z)},0,aFINA100,4)   //Movimento a Receber
       Else
       MSExecAuto({|x,y,z| FINA100(x,y,z)},0,aFINA100,3) //Movimento a pagar
       Endif
   Endif
Else
  lMsErroAuto := .F.
EndIf

//Verificar se a rotina utiliza grupo de perguntas, caso sim, carregar as perguntas
If (nPosRot := aScan(aLstRot,{|x| Upper(AllTrim(x[1])) == Upper(AllTrim(cRotina))})) > 0
  If !Empty(aTail(aLstRot[nPosRot]))
   	//Carregar as perguntas da rotina
     Pergunte(aTail(aLstRot[nPosRot]),.F.)
  Endif
Endif

If lMsErroAuto
   aErro := GetAutoGrLog()
	cMsgValid += "Data Base: " + Dtoc(dDataBase) + CRLF
   cMsg  := cREG + "Erro na grava็ใo do registro" + CRLF + cMsgValid + CRLF + ArrayToStr(aErro,150)
	lOk  := .F.
Else
	lOk := .T.
Endif

RestArea(aSM0Sav)
cFilAnt := cOldFilAnt

Return {lOk,cMsg}


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetTabN   บAutor ณTOTVS                บData  ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o nome da tabela selecionada atraves do wizard      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetTabN(nRadioArq,aLstTPN)

Return aLstTPN[nRadioArq]

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetEstArq บAutor ณTOTVS                บData  ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara a estrutura de diretorio dos arquivos selecionados  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetEstArq(cArq,cDrive,cDir,cArqP,cExt)

If !Empty(cArq)
	cDrive	:= ""
	cDir	:= ""
	cArqP	:= ""
	cExt	:= ""
	SplitPath(cArq,@cDrive,@cDir,@cArqP,@cExt)
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณArrayToStrบAutor  ณTOTVS                 บ Data ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConverte o conteudo de uma array em uma string                บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ArrayToStr(aStr,nTamLin)

Local cResp			:= ""
Local cLinha		:= ""
Local ni			:= 0
Local nx			:= 0
Local nLimite		:= 1

Default nTamLin	:= 0

For ni := 1 to Len(aStr)
	nInicio := 1
	cLinha := RTrim(aStr[ni])
	If Len(cLinha) > nTamLiN
		nLimite := Int(Len(cLinha) / nTamLin) + 1
	Else
		nLimite := 1
	Endif
	If nLimite == 1
		cResp += cLinha + CRLF
	Else
		For nx := 1 to nLimite
			cResp += Substr(cLinha,(1 + (nTamLin * nx)),nTamLin) + CRLF
			nInicio += nTamLin
		Next nx
	Endif
Next ni

Return cResp

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSX3Load   บAutor ณTOTVS                       ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que carrega a lista de campos obrigatorios e inicia- บฑฑ
ฑฑบ          ณlizadores padrao                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SX3Load(cAlias)

Local aAreaSX3			:= SX3->(GetArea())

If Empty(cAlias)
	Return cRet
Endif
cAlias := Upper(AllTrim(cAlias))
//Verificar se os campos obrigatorios jah nao foram pesquisados
If aScan(aLstObr,{|x| AllTrim(x[1]) == AllTrim(cAlias)}) == 0
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias))
	Do While !SX3->(Eof()) .AND. AllTrim(SX3->X3_ARQUIVO) == cAlias
		If SX3->X3_CONTEXT == "V"
			aAdd(aLstVirtual,Upper(AllTrim(SX3->X3_CAMPO)))
		Else
			//Verificar se o uso do campo eh obrigatorio, mesmo os nao usados
			If ((SubStr(Bin2Str(SX3->X3_OBRIGAT),1,1) == "x") .OR. VerByte(SX3->X3_RESERV,7))
				//Caso nao esteja na lista, adicionar o campo a lista de campos obrigatorios
				If aScan(aLstObr,{|x| AllTrim(x[1]) == AllTrim(SX3->X3_ARQUIVO) .AND. AllTrim(Upper(x[2])) == AllTrim(Upper(SX3->X3_CAMPO))}) == 0
					aAdd(aLstObr,{AllTrim(SX3->X3_ARQUIVO),AllTrim(Upper(SX3->X3_CAMPO)),AllTrim(SX3->X3_TITULO)})
				Endif
			Endif
			//Verificar se o campo possui um inicializador padrao
			If !Empty(SX3->X3_RELACAO) .AND. aScan(aLstIniPad,{|x| x[1] == Upper(AllTrim(cAlias)) .AND. x[2] == AllTrim(SX3->X3_CAMPO)}) == 0
				aAdd(aLstIniPad,{cAlias,AllTrim(SX3->X3_CAMPO),AllTrim(SX3->X3_RELACAO)})
			Endif
		Endif
		SX3->(dbSkip())
	EndDo
Endif
RestArea(aAreaSX3)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAdCmpIni  บAutor ณTOTVS                บData  ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que adiciona ao header campos que possuem inicializa-บฑฑ
ฑฑบ          ณdor padrao, caso eles nao estejam declarados.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AdCmpIni(cAlias,aHeader)

Local ni               := 0
Local nPosVP			:= 0

For ni := 1 to Len(aLstIniPad)
	If aLstIniPad[ni][1] == Upper(AllTrim(cAlias))
		If (nPosVP := aScan(aHeader,{|x| Upper(AllTrim(x)) == aLstIniPad[ni][2]})) == 0
			aAdd(aHeader,aLstIniPad[ni][2])
		Endif
	Endif
Next ni

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerErro   บAutor ณTOTVS                บData  ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento de erro                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerErro(e,lErro,cErro)

Local lRet				:= .F.

If e:Gencode > 0
	If InTransaction()
    	cErro := "Houve um erro no processamento de gravacao : " + CRLF
	Else
     	cErro := "Houve um erro no levantamento de registros : " + CRLF
	Endif
	cErro += "Descri็ใo : " + e:Description + CRLF
	cErro += e:ErrorStack
	lErro := .T.
    lRet := .T.
    Break
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ renova   บAutor ณTOTVS                บData  ณ  20/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara a empresa                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Renova()
Local _nCnt
Local _aEmpresas	:= {}

qOut("Inํcio de Importa็ใo")

PREPARE ENVIRONMENT EMPRESA "00" FILIAL "0010001"  // faz a primeira conexao somente para pega o SIGAMAT

    U_Import()

	RESET ENVIRONMENT

   	qOut(OemToAnsi("FIM Empresa ")) ///<<"+_aEmpresas[_nCnt]+"0>> เs "+time()+">>"))

qOut("Importa็ใo encerrada")
Return Nil


