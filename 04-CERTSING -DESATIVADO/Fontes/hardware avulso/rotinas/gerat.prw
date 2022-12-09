#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HSPGERAT  ºAutor  ³ Eduardo Alves      º Data ³  14/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera PRW para atualizador padrao.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs       ³Criado com base no programa desen. por Choite em 11/08/2006 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GERAT()

Local j			:= 0
Local k			:= 0
Local nQtdIt	:= 0
Local cLinha	:= ""

Local cDirSave 	:= 	PadR("D:\", 60, " ") //Space(60)
Local cBOP 		:= Space(6)
Local nSx1		:= 0

Local oDirSave, oDlg, oFolder, aSize := {}, aObjects := {}, aInfo := {}, aPObjs := {}, aPGDs := {}, nOpcDlg
Local nGDOpc := GD_INSERT + GD_UPDATE + GD_DELETE

Local oCDX1, aHGDX1 := {}, aCGX1 := {}
Local oCDX2, aHGDX2 := {}, aCGX2 := {}
Local oCDX3, aHGDX3 := {}, aCGX3 := {}
Local oCDX6, aHGDX6 := {}, aCGX6 := {}
Local oCDX7, aHGDX7 := {}, aCGX7 := {}
Local oCDIX, aHGDIX := {}, aCGIX := {}
Local oCDXB, aHGDXB := {}, aCGXB := {}

Private cArq	:= ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aCols para as GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aHGDX1,{"Grupo", "X1_GRUPO", "@!",	6, 0, "U_HS_VldGET('SX1', PADR(M->X1_GRUPO, Len(SX1->X1_GRUPO)))", /* Usado */, "C", /* F3 */, "R",,,, "A"})
aAdd(aHGDX2,{"Chave", "X2_CHAVE", "@!",	3, 0, "U_HS_VldGET('SX2', M->X2_CHAVE)", /* Usado */, "C", /* F3 */, "R",,,, "A"})
aAdd(aHGDX3,{"Arquivo", "X3_ARQUIVO", "@!",	3, 0, "U_HS_VldGET('SX3', M->X3_ARQUIVO)", /* Usado */, "C", /* F3 */, "R",,,, "A"})

aAdd(aHGDX6,{"Filial", "X6_FILIAL", "@!",	2, 0, "U_HS_VldGET('SX6', M->X6_FILIAL)", /* Usado */, "C", /* F3 */, "R",,,, "A"})
aAdd(aHGDX6,{"Variavel", "X6_VAR", "@!",	10, 0, "U_HS_VldGET('SX6', oGDX6:aCols[oGDX6:oBrowse:nAt, 1] + M->X6_VAR)", /* Usado */, "C", /* F3 */, "R",,,, "A"})

aAdd(aHGDX7,{"Campo", "X7_CAMPO", "@!",	10, 0, "U_HS_VldGET('SX7', M->X7_CAMPO)", /* Usado */, "C", /* F3 */, "R",,,, "A"})
aAdd(aHGDIX,{"Indice", "IX_INDICE", "@!",	3, 0, "U_HS_VldGET('SIX', M->IX_INDICE)", /* Usado */, "C", /* F3 */, "R",,,, "A"})
aAdd(aHGDXB,{"Alias", "XB_ALIAS", "@!",	6, 0, "U_HS_VldGET('SXB', M->XB_ALIAS)", /* Usado */, "C", /* F3 */, "R",,,, "A"})

aSize := MsAdvSize(.T.)
aObjects := {}	
aAdd( aObjects, { 100, 045, .T., .T. } )	
aAdd( aObjects, { 100, 055, .T., .T.,.T. } )	
 
aInfo  := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
aPObjs := MsObjSize( aInfo, aObjects, .T. )

aObjects := {}	
AAdd( aObjects, { 100, 100, .T., .T. } )	
 
aInfo := { aPObjs[2, 1], aPObjs[2, 2], aPObjs[2, 3], aPObjs[2, 4], 0, 0 }
aPGDs := MsObjSize( aInfo, aObjects, .T. )   
 
DEFINE MSDIALOG oDlg TITLE "Atualizador Padrão" From aSize[7],0 TO aSize[6], aSize[5]	PIXEL of oMainWnd

	@ aPObjs[1,1] + 10, 005 SAY OemtoAnsi("Path: ") OF oDlg PIXEL COLOR CLR_BLUE
	@ aPObjs[1,1] + 10, 032 MSGET oDirSave VAR cDirSave PICTURE "@!" SIZE 150,04              	OF oDlg PIXEL COLOR CLR_BLUE
	@ aPObjs[1,1] + 10, 182 BUTTON oBtn1 PROMPT "..." SIZE 10,10 ACTION FS_RetDir(@cDirSave)  	OF oDlg PIXEL 

	@ aPObjs[1,1] + 25, 005 SAY OemtoAnsi("Nº Bops: ") OF oDlg PIXEL COLOR CLR_BLUE
	@ aPObjs[1,1] + 25, 032 MSGET oNumBop 	VAR cBOP 	PICTURE "999999" 		SIZE 010,04 OF oDlg PIXEL COLOR CLR_BLACK
    											
	@ aPObjs[2, 1], aPObjs[2, 2] FOLDER oFolder SIZE aPObjs[2, 3], aPObjs[2, 4] Pixel OF oDlg Prompts "SX1", "SX2", "SX3", "SX6", "SX7", "SIX", "SXB"
	oFolder:Align := CONTROL_ALIGN_BOTTOM

	oGDX1 := MsNewGetDados():New(aPGDs[1, 1], aPGDs[1, 2], aPGDs[1, 3], aPGDs[1, 4], nGDOpc,,,,,,,,,, oFolder:aDialogs[1], aHGDX1, aCGX1)
	oGDX1:oBrowse:align:= CONTROL_ALIGN_ALLCLIENT

	oGDX2 := MsNewGetDados():New(aPGDs[1, 1], aPGDs[1, 2], aPGDs[1, 3], aPGDs[1, 4], nGDOpc,,,,,,,,,, oFolder:aDialogs[2], aHGDX2, aCGX2)
	oGDX2:oBrowse:align:= CONTROL_ALIGN_ALLCLIENT

	oGDX3 := MsNewGetDados():New(aPGDs[1, 1], aPGDs[1, 2], aPGDs[1, 3], aPGDs[1, 4], nGDOpc,,,,,,,,,, oFolder:aDialogs[3], aHGDX3, aCGX3)
	oGDX3:oBrowse:align:= CONTROL_ALIGN_ALLCLIENT

	oGDX6 := MsNewGetDados():New(aPGDs[1, 1], aPGDs[1, 2], aPGDs[1, 3], aPGDs[1, 4], nGDOpc,,,,,,,,,, oFolder:aDialogs[4], aHGDX6, aCGX6)
	oGDX6:oBrowse:align:= CONTROL_ALIGN_ALLCLIENT

	oGDX7 := MsNewGetDados():New(aPGDs[1, 1], aPGDs[1, 2], aPGDs[1, 3], aPGDs[1, 4], nGDOpc,,,,,,,,,, oFolder:aDialogs[5], aHGDX7, aCGX7)
	oGDX7:oBrowse:align:= CONTROL_ALIGN_ALLCLIENT

	oGDIX := MsNewGetDados():New(aPGDs[1, 1], aPGDs[1, 2], aPGDs[1, 3], aPGDs[1, 4], nGDOpc,,,,,,,,,, oFolder:aDialogs[6], aHGDIX, aCGIX)
	oGDIX:oBrowse:align:= CONTROL_ALIGN_ALLCLIENT

	oGDXB := MsNewGetDados():New(aPGDs[1, 1], aPGDs[1, 2], aPGDs[1, 3], aPGDs[1, 4], nGDOpc,,,,,,,,,, oFolder:aDialogs[7], aHGDXB, aCGXB)
	oGDXB:oBrowse:align:= CONTROL_ALIGN_ALLCLIENT
  
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar (oDlg, {|| nOpcDlg := 1, oDlg:End()}, ;
                                                     {|| nOpcDlg := 0, oDlg:End()})

If (nOpcDlg == 0)
	Return()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nenhum folder tenha sido preenchido, finaliza o programa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(oGDX1:aCols[1,1]) .And. Empty(oGDX2:aCols[1,1]) .And. Empty(oGDX3:aCols[1,1]) .And. Empty(oGDX6:aCols[1,2]) .And. Empty(oGDX7:aCols[1,1]) .And. Empty(oGDIX:aCols[1,1]) .And. Empty(oGDXB:aCols[1,1])
	MsgAlert("O fonte não será gerado, pois não foi preenchida nenhuma pasta.", "Atenção")
	Return()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Nome do arquivo fonte a ser gerado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBOP	:= "DARCIO_" + allTrim(cBOP)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria arquivo fonte no local especificado pelo usuario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArq	:= fcreate(allTrim(cDirSave) + cBOP + ".PRW")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao PRINCIPAL que chama as funcoes de geracao de dicionarios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GravaLin('#INCLUDE "protheus.ch"')
GravaLin("")
GravaLin("/*/")
GravaLin("ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ")
GravaLin("±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±")
GravaLin("±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ-ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±")
GravaLin("±±³Fun‡ao    ³"+PADR(cBOP,10)	 +"³ Autor ³ MICROSIGA             ³ Data ³ " + DTOC(DDATABASE) + " ³±±")
GravaLin("±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±")
GravaLin("±±³Descri‡ao ³ Funcao Principal                                           ³±±")
GravaLin("±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±")
GravaLin("±±³Uso       ³ Gestao Hospitalar                                          ³±±")
GravaLin("±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±")
GravaLin("±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±")
GravaLin("ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß")
GravaLin("/*/")
GravaLin("User Function " + cBOP + "()")
GravaLin("")
GravaLin('cArqEmp 					:= "SigaMat.Emp"')
GravaLin('__cInterNet 	:= Nil')
GravaLin("")
GravaLin('PRIVATE cMessage')
GravaLin('PRIVATE aArqUpd	 := {}')
GravaLin('PRIVATE aREOPEN	 := {}')
GravaLin('PRIVATE oMainWnd ')
GravaLin("Private nModulo 	:= 51 // modulo SIGAHSP")
GravaLin("")
GravaLin('Set Dele On')
GravaLin("")
GravaLin('lEmpenho				:= .F.')
GravaLin('lAtuMnu					:= .F.')
GravaLin("")
GravaLin('Processa({|| ProcATU()},"Processando [' + cBOP + ']","Aguarde , processando preparação dos arquivos")')
GravaLin("")
GravaLin('Return()')
GravaLin('')
GravaLin('')
GravaLin('/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ')
GravaLin('±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±')
GravaLin('±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±')
GravaLin('±±³Fun‡…o    ³ProcATU   ³ Autor ³                       ³ Data ³  /  /    ³±±')
GravaLin('±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±')
GravaLin('±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±')
GravaLin('±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±')
GravaLin('±±³ Uso      ³ Baseado na funcao criada por Eduardo Riera em 01/02/2002   ³±±')
GravaLin('±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±')
GravaLin('±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±')
GravaLin('ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/')
GravaLin('Static Function ProcATU()')
GravaLin('Local cTexto    	:= ""')
GravaLin('Local cFile     	:= ""')
GravaLin('Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"')
GravaLin('Local nRecno    	:= 0')
GravaLin('Local nI        	:= 0')
GravaLin('Local nX        	:= 0')
GravaLin('Local aRecnoSM0 	:= {} ')    
GravaLin('Local lOpen     	:= .F. ')
GravaLin('')
GravaLin('ProcRegua(1)')
GravaLin('IncProc("Verificando integridade dos dicionários....")')
GravaLin('If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))')
GravaLin('')
GravaLin('	dbSelectArea("SM0")')
GravaLin('	dbGotop()')
GravaLin('	While !Eof() ')
GravaLin('  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0')
GravaLin('			Aadd(aRecnoSM0,{Recno(),M0_CODIGO})')
GravaLin('		EndIf			')
GravaLin('		dbSkip()')
GravaLin('	EndDo	')
GravaLin('')
GravaLin('	If lOpen')
GravaLin('		For nI := 1 To Len(aRecnoSM0)')
GravaLin('			SM0->(dbGoto(aRecnoSM0[nI,1]))')
GravaLin('			RpcSetType(2) ')
GravaLin('			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)')
GravaLin(' 		nModulo := 51 // modulo SIGAHSP')
GravaLin('			lMsFinalAuto := .F.')
GravaLin('			cTexto += Replicate("-",128)+CHR(13)+CHR(10)')
GravaLin('			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)')
GravaLin("")
GravaLin('			ProcRegua(8)')
GravaLin("")
GravaLin('			Begin Transaction')
GravaLin("")

If !Empty(oGDX1:aCols[1,1])
	GravaLin('			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿')
	GravaLin('			//³Atualiza o dicionario de perguntas.³')
	GravaLin('			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ')
	GravaLin('			IncProc("Analisando Dicionario de Perguntas...")')
	GravaLin('			cTexto += GeraSX1() ')
EndIf

If !Empty(oGDX2:aCols[1,1])
	GravaLin('			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿')
	GravaLin('			//³Atualiza o dicionario de arquivos.³')
	GravaLin('			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ')
	GravaLin('			IncProc("Analisando Dicionario de Arquivos...")')
	GravaLin('			cTexto += GeraSX2()')
EndIf

If !Empty(oGDX3:aCols[1,1])
	GravaLin('			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿')
	GravaLin('			//³Atualiza o dicionario de dados.³')
	GravaLin('			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ')
	GravaLin('			IncProc("Analisando Dicionario de Dados...")')
	GravaLin('			cTexto += GeraSX3()')
EndIf

If !Empty(oGDX6:aCols[1,2])
	GravaLin('			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿')
	GravaLin('			//³Atualiza os parametros.        ³')
	GravaLin('			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ')
	GravaLin('			IncProc("Analisando Paramêtros...")')
	GravaLin(" 		cTexto += GeraSX6()")
EndIf

If !Empty(oGDX7:aCols[1,1])
GravaLin('			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿')
GravaLin('			//³Atualiza os gatilhos.          ³')
GravaLin('			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ')
GravaLin('			IncProc("Analisando Gatilhos...")')
GravaLin('			cTexto += GeraSX7()')
EndIf

If !Empty(oGDIX:aCols[1,1])
GravaLin('			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿')
GravaLin('			//³Atualiza os indices.³')
GravaLin('			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ')
GravaLin('			IncProc("Analisando arquivos de índices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME) ')
GravaLin('			cTexto += GeraSIX()')
EndIf

If !Empty(oGDXB:aCols[1,1])
GravaLin('			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿')
GravaLin('			//³Atualiza os Consulta padrao.³')
GravaLin('			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ')
GravaLin('			IncProc("Analisando Consulta Padrão...")')
GravaLin(' 		cTexto += GeraSXB()')
EndIf

GravaLin('')
GravaLin('			End Transaction')

GravaLin('	')
GravaLin('			__SetX31Mode(.F.)')
GravaLin('			For nX := 1 To Len(aArqUpd)')
GravaLin('				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")')
GravaLin('				If Select(aArqUpd[nx])>0')
GravaLin('					dbSelecTArea(aArqUpd[nx])')
GravaLin('					dbCloseArea()')
GravaLin('				EndIf')
GravaLin('				X31UpdTable(aArqUpd[nx])')
GravaLin('				If __GetX31Error()')
GravaLin('					Alert(__GetX31Trace())')
GravaLin('					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)')
GravaLin('					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)')
GravaLin('				EndIf')
GravaLin('				dbSelectArea(aArqUpd[nx])')
GravaLin('			Next nX		')
GravaLin('')
GravaLin('			RpcClearEnv()')
GravaLin('			If !( lOpen := MyOpenSm0Ex() )')
GravaLin('				Exit ')
GravaLin('		 EndIf')
GravaLin('		Next nI ')
GravaLin('		   ')
GravaLin('		If lOpen')
GravaLin('			')
GravaLin('			cTexto 				:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto')
GravaLin('			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)')
GravaLin('			')
GravaLin('			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12')
GravaLin('			DEFINE MSDIALOG oDlg TITLE "Atualizador [' + cBOP + '] - Atualizacao concluida." From 3,0 to 340,417 PIXEL')
GravaLin('				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL')
GravaLin('				oMemo:bRClicked := {||AllwaysTrue()}')
GravaLin('				oMemo:oFont:=oFont')
GravaLin('				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga')
GravaLin('				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."')
GravaLin('			ACTIVATE MSDIALOG oDlg CENTER')
GravaLin('	')
GravaLin('		EndIf ')
GravaLin('		')
GravaLin('	EndIf')
GravaLin('		')
GravaLin('EndIf 	')
GravaLin('')
GravaLin('Return(Nil)')

GravaLin("")
GravaLin("")

GravaLin('/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ')
GravaLin('±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±')
GravaLin('±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±')
GravaLin('±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±')
GravaLin('±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±')
GravaLin('±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±')
GravaLin('±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±')
GravaLin('±±³ Uso      ³ Atualizacao FIS                                            ³±±')
GravaLin('±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±')
GravaLin('±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±')
GravaLin('ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/')
GravaLin('Static Function MyOpenSM0Ex()')
GravaLin("")
GravaLin('Local lOpen := .F. ')
GravaLin('Local nLoop := 0 ')
GravaLin("")
GravaLin('For nLoop := 1 To 20')
GravaLin('	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. ) ')
GravaLin('	If !Empty( Select( "SM0" ) ) ')
GravaLin('		lOpen := .T. ')
GravaLin('		dbSetIndex("SIGAMAT.IND") ')
GravaLin('		Exit	')
GravaLin('	EndIf')
GravaLin('	Sleep( 500 )') 
GravaLin('Next nLoop ')
GravaLin("")
GravaLin('If !lOpen')
GravaLin('	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) ')
GravaLin('EndIf                                 ')
GravaLin("")
GravaLin('Return( lOpen )')

GravaLin("")
GravaLin("")

If !Empty(oGDX1:aCols[1,1])
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao que cria o SX1																																																																																											³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GravaLin("/*/")
	GravaLin("ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ")
	GravaLin("±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±")
	GravaLin("±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±")
	GravaLin("±±³Fun‡ao    ³ GeraSX1  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±")
	GravaLin("±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±")
	GravaLin("±±³Descri‡ao ³ Verifica as perguntas incluindo-as caso nao existam        ³±±")
	GravaLin("±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±")
	GravaLin("±±³Uso       ³ Uso Generico.                                              ³±±")
	GravaLin("±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±")
	GravaLin("±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±")
	GravaLin("ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß")
	GravaLin("/*/")
	GravaLin("Static Function GeraSX1()")
	GravaLin("Local aArea 		:= GetArea()")
	GravaLin("Local aRegs 		:= {}")
	GravaLin("Local i	  		:= 0")
	GravaLin("Local j     		:= 0")   
	GravaLin("Local lInclui		:= .F.")   	
	GravaLin("Local aHelpPor	:= {}")
	GravaLin("Local aHelpSpa	:= {}")
	GravaLin("Local aHelpEng	:= {}")
	GravaLin("Local cTexto      := ''")
	GravaLin("")
	
	For nSx1 := 1 To Len(oGDX1:aCols)
	 GravaLin("// Cria grupo de perguntas " + PADR(oGDX1:aCols[nSx1, 1], Len(SX1->X1_GRUPO)))
	
	 GravaLin('cPerg := PADR("' + oGDX1:aCols[nSx1, 1] + '", Len(SX1->X1_GRUPO))')
	 GravaLin('aRegs := {}')
	 
	 dbSelectArea("SX1")
	 dbSetOrder(1)
	 DbSeek(oGDX1:aCols[nSx1, 1])
	
		While !Eof() .AND. SX1->X1_GRUPO == PADR(oGDX1:aCols[nSx1, 1], Len(SX1->X1_GRUPO))
			
			nQtdIt++
			GravaLin(FS_Linha(2, FCount()))
			
			DbSkip()
		EndDo
		
		GravaLin("")
		GravaLin('dbSelectArea("SX1")')
		GravaLin("dbSetOrder(1)")
		GravaLin("For i := 1 To Len(aRegs)")
		GravaLin("	lInclui := !dbSeek(cPerg + aRegs[i,2])")
		GravaLin('		RecLock("SX1", lInclui)')
		GravaLin("		For j := 1 to FCount()")
		GravaLin("			If j <= Len(aRegs[i])")
		GravaLin("				FieldPut(j,aRegs[i,j])")
		GravaLin("			EndIf")
		GravaLin("		Next j")
		GravaLin("	MsUnlock()")
		GravaLin("")
		GravaLin("  aHelpPor := {} ; aHelpSpa := {} ; 	aHelpEng := {}")
	
		For k := 1 To nQtdIt          	
			If k==1
	 		GravaLin("  IF i == "+alltrim(str(k)))
			Else
				GravaLin("  ELSEIF i=="+alltrim(str(k)))
			EndIf
			GravaLin('    AADD(aHelpPor,"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ")')
		Next k          
		GravaLin('    ENDIF')
		GravaLin('    PutSX1Help("P."+alltrim(cPerg)+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)')
		GravaLin("") 
      	GravaLin(' cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")')		
		GravaLin("") 
		GravaLin("Next")
		GravaLin("")
	
	Next nSx1	
	
	GravaLin("")
	GravaLin("RestArea(aArea)")
	GravaLin("Return('SX1: ' + cTexto  + CHR(13) + CHR(10))")

EndIf
	
GravaLin("")
GravaLin("")

FS_GeraFN("SX2",, FS_CriaVet(oGDX2))      
FS_GeraFN("SX3",, FS_CriaVet(oGDX3))      
FS_GeraFN("SX6","X6_FIL+X6_VAR", FS_CriaVet(oGDX6))      
FS_GeraFN("SX7",, FS_CriaVet(oGDX7))      
FS_GeraFN("SIX",, FS_CriaVet(oGDIX))      
FS_GeraFN("SXB",, FS_CriaVet(oGDXB))      

fClose(cArq)

MsgAlert("Processamento concluído, criado como " + allTrim(cDirSave) + cBOP + ".PRW", "Sucesso")
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_GeraFN ºAutor  ³Eduardo Alves       º Data ³  15/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria funcao para os dicionarios:                            º±±
±±º          ³SX2 SX3 SX6 SX7 SIX SXB                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gestao Hospitalar                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_GeraFN(cAlias, cWhere, aSx)
Local aArea 	:= GetArea()
Local j 		:= 0
Local nSx 		:= 0
Local cLinha	:= ""
Local aTemp		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se os parametros passados existem											³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbSetOrder(1)

For nSx := 1 To Len(aSx)
	If DbSeek(aSx[nSx])
		aAdd(aTemp, aSx[nSx])
	EndIf
Next nSx

aSx := aClone(aTemp)

If Len(aSx) == 0
	Return()
EndIf

Default cWhere := IIf( AT("+", IndexKey()) > 0 , SubStr(IndexKey(), 1, AT("+", IndexKey()) - 1), IndexKey())

GravaLin("/*/")
GravaLin("ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ")
GravaLin("±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±")
GravaLin("±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±")
GravaLin("±±³Fun‡ao    ³ Gera"+cAlias+"  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±")
GravaLin("±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±")
GravaLin("±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±")
GravaLin("±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±")
GravaLin("±±³Uso       ³ Generico                                                   ³±±")
GravaLin("±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±")
GravaLin("±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±")
GravaLin("ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß")
GravaLin("/*/")
GravaLin("Static Function Gera" + cAlias + "()")
GravaLin("Local aArea		:= GetArea()")
GravaLin("Local i      		:= 0")
GravaLin("Local j      		:= 0")
GravaLin("Local aRegs  		:= {}")
GravaLin("Local cTexto 		:= ''")
GravaLin("Local lInclui		:= .F.")

GravaLin("")

For nSx := 1 To Len(aSx)

	DbSeek(aSx[nSx])
	
	GravaLin("aRegs  := {}")
	
	While !Eof() .And. &(cWhere) == aSx[nSx]
		GravaLin(FS_Linha(1, FCount(), cAlias))
		DbSkip()
	EndDo
	
	GravaLin("")
	GravaLin('dbSelectArea("' + cAlias + '")')
	GravaLin("dbSetOrder(1)")
 GravaLin("")
	GravaLin("For i := 1 To Len(aRegs)")
 GravaLin("")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SX2                                           							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 					cAlias == "SX2"
		GravaLin(" dbSetOrder(1)")
		GravaLin(" lInclui := !DbSeek(aRegs[i, 1])")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SX3                                           							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf 	cAlias == "SX3"
		GravaLin('If(Ascan(aArqUpd, aRegs[i,1]) == 0)')
		GravaLin('	 aAdd(aArqUpd, aRegs[i,1])')
		GravaLin('EndIf')
		GravaLin('')
		GravaLin("dbSetOrder(2)")
		GravaLin("lInclui := !DbSeek(aRegs[i, 3])")
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SX6                                           							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cAlias == "SX6"
		GravaLin('cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")')
		GravaLin('')
		GravaLin("dbSetOrder(1)")
		GravaLin("lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])")
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SX7                                           							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cAlias == "SX7"
		GravaLin("dbSetOrder(1)")
		GravaLin("lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])")
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SIX                                           							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cAlias $ "SIX"
		GravaLin('If(Ascan(aArqUpd, aRegs[i,1]) == 0)')
		GravaLin(' 	aAdd(aArqUpd, aRegs[i,1])')
		GravaLin('EndIf')
		GravaLin('')
		GravaLin("dbSetOrder(1)")
		GravaLin("lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])")
		GravaLin("If !lInclui")
		GravaLin('  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])')
		GravaLin("Endif")
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SXB                                           							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cAlias == "SXB"
		GravaLin("dbSetOrder(1)")
		GravaLin("lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])")
	EndIF
	
	GravaLin('')
	GravaLin('cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")')
	GravaLin('')
	GravaLin('	RecLock("'+ cAlias +'", lInclui)')
	GravaLin("		For j := 1 to FCount()")
	GravaLin("			If j <= Len(aRegs[i])") 
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Antes de gravar o campo - Alterar o conteudo do campo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 GravaLin('   	If allTrim(Field(j)) == "X2_ARQUIVO"')
 GravaLin('   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"')
 GravaLin('   	EndIf')

	GravaLin('    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"')
	GravaLin("     Loop")
	GravaLin("    Else")
	GravaLin("     FieldPut(j,aRegs[i,j])")
	GravaLin("    EndIf")

	GravaLin("   Endif")
	GravaLin("  Next")
	GravaLin(" MsUnlock()")
	GravaLin("Next i")
	GravaLin("")

Next nSx

GravaLin("")
GravaLin("RestArea(aArea)")
GravaLin("Return('" + cAlias + " : ' + " + "cTexto  + CHR(13) + CHR(10))")

RestArea(aArea)
Return(cLinha)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaLin  ºAutor  ³Eduardo Alves       º Data ³  15/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que inclui linha no arquivo PRW.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs       ³Criado com base no programa desen. por Choite em 11/08/2006 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaLin(cConteudo)
	FWrite(cArq,Rtrim(cConteudo) + chr(13) + chr(10) )
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HS_VldGET ºAutor  ³Eduardo Alves       º Data ³  09/15/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para validacao dos campos da getdados.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HS_VldGET(cDic, cChave)
Local aArea 	:= GetArea()
Local lRet			:= .T.

dbSelectArea(cDic)
dbSetOrder(1)
If !(lRet := dbSeek(cChave))
	MsgAlert("Chave informada não encontrada no dicionário " + cDic, "Atenção")
EndIf

RestArea(aArea)
Return(lRet)    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_CriaVetºAutor  ³Eduardo Alves       º Data ³  09/15/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria vetor com do dados informados nos grids.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_CriaVet(oGD)

Local nLinGD := 0, nColGD := 0

Local aTemp := {}
Local cCont := ""

If Len(oGD:aCols) > 0
	For nLinGD := 1 To Len(oGD:aCols)
		For nColGD := 1 To Len(oGD:aHeader)
	 		cCont += oGD:aCols[nLinGD][nColGD]
		Next nCol
		aAdd(aTemp, cCont)
		cCont := ""
	Next nLCol
EndIf

Return(aTemp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_Linha  ºAutor  ³Eduardo Alves       º Data ³  09/15/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria a linha do vetor com dados dos dicionarios.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_Linha(nCpoINI, nTotCPO, cAlias)
Local cLinha 	:= ""
Local j			:= 0

cLinha := "AADD(aRegs,{" + IIF(nCpoINI == 2,"cPerg,","")

For j := nCpoINI to nTotCPO
	cCont  := FieldGet(j)
	IF Type("cCont") == "N"
		cLinha += StrZero(cCont, 2)
	ELSE
		If cCont == ""
			cCont := Space(Len(cCont))
		EndIf
		cLinha += '"' + StrTran(cCont, '"', "'") + '"'
	ENDIF
	IF (j # nTotCPO)
		cLinha += ','
	ENDIF
Next nTotCPO

If cAlias == "SX3"
	cLinha += ',"N","N","N"'
Endif

cLinha += "})"

Return(cLinha)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_RetDir ºAutor  |Eduardo Alves       º Data ³  18/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibe locais onde pode ser salvo o fonte gerado.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs       ³Baseado na funcao criada na HSPDATU.                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_RetDir(cDir, cDescr)
	cDir := PADR(cGetFile(OemToAnsi(cDescr) + " | ",OemToAnsi("Selecione Diretório"),,"",.F.,GETF_RETDIRECTORY), Len(cDir))
Return(.T.)
