#INCLUDE "PROTHEUS.CH"
#DEFINE X3_USADO_EMUSO			"€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO		"€€€€€€€€€€€€€€€"
#DEFINE X3_USADO_USADOKEY		"€€€€€€€€€€€€€€°"
#DEFINE X3_USADO_NAOALTERA		"€€€€€€€€€€€€€€° "
#DEFINE X3_OBRIGATORIO			"Á€"                  
#DEFINE X3_RESER 				"şÀ"
#DEFINE X3_RESER_NUMERICO		"øÇ" 
#DEFINE X3_RESER_DATA			"“€" 
#DEFINE X3_RESER_ALTERA_TAM		"–À"
#DEFINE X3_RESERKEY				"ƒ€"
#DEFINE X3_RES					"€€"               
#DEFINE X3_RESNAO				"›€"               
#DEFINE X3_NAOOBRIGAT			"šÀ" 
#DEFINE X3_RESER_ALT_TAM_DEC   "Ü+"

/*/              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³UpdIF001    ³ Autor ³Roberto Souza        ³ Data ³ 01.01.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao das tabelas.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdIF001()
Local oDlgUpd
Local cTxtIntro := ''
Local aEmpr     := {}
Local oProcess  := NIL
//--DESCONSIDERA REGISTROS EXCLUIDOS NO ARQUIVO
//--DE EMPRESAS:
Private cTitulo := 'COMPATIBILIZADOR - IMPORTA XML - Maio/2015'
Private cMessage
Private aArqUpd	 		:= {}
Private aREOPEN	 		:= {}
Private oMainWnd
Private lMsFinalAuto 	:= .F.
Private lOpen			:= .F.
Private lBOSSKEY        := AllTrim(GetSrvProfString("BOSSKEY","0"))=="1"

SET DELETED ON
cTxtIntro += "<table width='100%' border=2 cellpadding='15' cellspacing='5'>"
cTxtIntro += "<tr>"
cTxtIntro += "<td colspan='5' align='center'><font face='Tahoma' size='+2'>"
cTxtIntro += "<b>COMPATIBILIZADOR - IMPORTA XML</b>"
cTxtIntro += "</font></td>"
cTxtIntro += "</tr>"
cTxtIntro += "<tr>"
cTxtIntro += "<td colspan='5'><font face='Tahoma' color='#000099' size='+1'>"
cTxtIntro += "<b>Este programa tem por objetivo compatibilizar o ambiente/estrutura de dados do cliente "
cTxtIntro += "em relação as atualizações referentes ao projeto de Importação de XML de Fornecedores.<br>"
cTxtIntro += "Estas atualizações somente poderão ser realizadas em modo <b>exclusivo!</b><br>"
cTxtIntro += "Faça um backup dos dicionários e da base de dados antes da atualização para eventuais falhas no processo.<br><br>"
cTxtIntro += "Maiores detalhes sobre o processo de atualização devem ser obtidos na documentacao do projeto.</b>"
cTxtIntro += "<br><br><br><br><br><br><br><br><br><br>"
cTxtIntro += "</font></td>"
cTxtIntro += "</tr>"
cTxtIntro += "</table>"
//--Variaveis de Ambiente (Publicas)
nModulo      := 44 //SIGAFIS
lMsFinalAuto := .F. 
lEmpenho     := .F.
lAtuMnu	     := .F.


If ( lOpen := MyOpenSm0Ex() )
	//--Obtem as Empresas para processamento...
	SM0->( DbEval( {|| If(AScan(aEmpr, {|x| x[1] == M0_CODIGO}) == 0, AAdd(aEmpr, {M0_CODIGO,M0_CODFIL,RecNo()}), .T.) },, {|| !SM0->(Eof())}) )
//	AAdd(aEmpr, {"02","01",2})
	DEFINE MSDIALOG oDlgUpd TITLE cTitulo FROM 00,00 TO 500,700 PIXEL
	TSay():New(005,005,{|| cTxtIntro },oDlgUpd,,,,,,.T.,,,340,200,,,,.T.,,.T.)
	TButton():New( 220,180, '&Processar...', oDlgUpd,;
					{|| RpcClearEnv(), oProcess := MsNewProcess():New( {|lEnd| IF001Proc(@lEnd,@lOpen,oProcess) }, 'Aguarde...', 'Iniciando Processamento...', .F.), oProcess:Activate(), oDlgUpd:End()},;
					075,015,,,,.T.,,,,,,)
	TButton():New( 220,270, '&Cancelar', oDlgUpd,;
					{|| RpcClearEnv(), oDlgUpd:End()},;
					075,015,,,,.T.,,,,,,)
	
	ACTIVATE MSDIALOG oDlgUpd CENTERED
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IF001Proc ³ Autor ³Roberto Souza          ³ Data ³04/05/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IF001Proc(lEnd,lOpen,oProcess)
Local cTexto    := ''
Local cMsg		:= ''
Local cFile     := ""
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local cCodigo   := "DM"
Local nRecno    := 0
Local nI        := 0
Local aRecnoSM0 := {}
Local nX		:= 0
Local cDirFiles	:= Space(120)   
Local nRetAtu   := 0 
Local cTab1     := "ZBZ"
Local cTab2     := "ZB5"
Local cTab3     := "   "
Local cPrf3     := "    "

oProcess:SetRegua1(0)
oProcess:SetRegua2(0)
oProcess:IncRegua1("Verificando integridade dos dicionarios....")
oProcess:IncRegua2("Aguarde...")
/*
nRetAtu := U_MyAviso("Atencao!","Deseja executar o compatibilizador de registros das tabelas  : "+CRLF+;
				cTab1 + " (Xmls Importados)"+CRLF+; 
				cTab2 + " (Amarração Produto X Fornecedor)",;
				{"Ok","Cancelar"},3)
*/
If MyOpenSm0Ex()
	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
		Aadd(aRecnoSM0,SM0->(RECNO()))
		dbSkip()
	EndDo
	
	For nI := 1 To Len(aRecnoSM0)
		SM0->(dbGoto(aRecnoSM0[nI]))
		RpcSetType(2)
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
		RpcClearEnv()
		If !( lOpen := MyOpenSm0Ex() )
			Exit
		EndIf
	Next nI
	oProcess:SetRegua1(Len(aRecnoSM0))
	oProcess:SetRegua2(Len(aRecnoSM0) * 8)	
	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			oProcess:IncRegua1("Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME)			
			
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)


			if .not. TabelaZBB( @cTab3, @cPrf3 )
				lOpen := .F.
				Exit
			endif
			xZBB  := cTab3  //Se essa variavel estiver empty nem cria o arquivo.
			xZBB_ := cPrf3

			ProcRegua(8)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Folders                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Folders...")
			oProcess:IncRegua2("Analisando indices...")
			cTexto += IFAtuSXA(oProcess)          
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza as perguntes de relatorios.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Perguntas de Relatorios...")
			oProcess:IncRegua2("Analisando Perguntas de Relatorios...")

			cTexto += IFAtuSX1()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza indices                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando indices...")
			oProcess:IncRegua2("Analisando indices...")
			cTexto += IFAtuSIX()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Arquivos...")
			oProcess:IncRegua2("Analisando Dicionario de Arquivos...")
			cTexto += IFAtuSX2()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			oProcess:IncRegua2("Analisando Dicionario de Arquivos...")
			cTexto += IFAtuSX3()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os parametros.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Parametros...")
			oProcess:IncRegua2("Analisando Parametros...")
			cTexto += IFAtuSX6()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Gatilhos...")
			oProcess:IncRegua2("Analisando Gatilhos...")
			cTexto += IFAtuSX7()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza as consultas padroes.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Consultas Padroes...")
			oProcess:IncRegua2("Analisando Consultas Padroes...")			
			cTexto += IFAtuSXB()
			
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... "+aArqUpd[nx]+"]")
				oProcess:IncRegua2("Atualizando estruturas. Aguarde... "+aArqUpd[nx]+"]")			
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
			Next nX
			If nRetAtu == 1
				cTexto+= SincTabXML()
			EndIf
			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
			EndIf
		Next nI
						
		If lOpen
			cTexto := "Log da atualizacao "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida." From 3,0 to 340,417 PIXEL
			@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont
			DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTERED
		EndIf
	EndIf
EndIf
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IFAtuSXA  ³ Autor ³Roberto Souza          ³ Data ³24/04/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SXA                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao Importa XML                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IFAtuSXA(oProcess)
Local cTexto := ''
Local aSXA   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0 
Local lSXA   := .F.

aEstrut:= {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}
oProcess:IncRegua2('Atualizando Folders (SXA)' )

AADD(aSXA,{"ZBZ","1","Xml","Xml","Xml","U"})
AADD(aSXA,{"ZBZ","2","Cancelamento","Cancelamento","Cancelamento","U"})
AADD(aSXA,{"ZBZ","3","Notificações","Notificações","Notificações","U"})

dbSelectArea("SXA")
dbSetOrder(1)
For i:= 1 To Len(aSXA)
	If !Empty(aSXA[i][1])
		If !dbSeek(aSXA[i,1]+aSXA[i,2])
			RecLock("SXA",.T.)
			lSXA := .T.
			For j:=1 To Len(aSXA[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXA[i,j])
				EndIf
			Next j

			dbCommit()
			MsUnLock()

			cTexto += aSXA[i,1] + ' - ' + aSXA[i,3]+CHR(13)+CHR(10)
		EndIf
	EndIf
Next i
If lSXA
	cTexto += "Folders atualizados  : "+"SXA"+CHR(13)+CHR(10)
EndIf

Return(cTexto)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IFAtuSIX  ³ Autor ³Roberto Souza          ³ Data ³04/05/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SIX                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IFAtuSIX()
Local cTexto    := ''
Local lSix      := .F.
Local aSix      := {}
Local aEstrut   := {}
Local aOld      := {}
Local nOld      := 0
Local nI         := 0
Local nJ         := 0
Local cAlias    := ''
Local lDelInd   := .F.
Local cDelInd   := ''
Local lTemZBB   := (.NOT. Empty( xZBB ) )

aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indices que serao criados apenas para o Brasil.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lBossKey
	Aadd(aSIX,{"ZBX","1","ZBX_FILIAL+ZBX_CODCLI+ZBX_LOJCLI","Codigo Cliente + Loja","Codigo Cliente + Loja","Codigo Cliente + Loja","U","","","S"})
	Aadd(aSIX,{"ZBX","2","ZBX_FILIAL+ZBX_CNPJ_L","CNPJ Liberado","CNPJ Liberado","CNPJ Liberado","U","","","S"})
EndIf

//Tabela ZB5
Aadd(aSIX,{"ZB5","1","ZB5_FILIAL+ZB5_CGC+ZB5_PRODFO","CGC/CPF+Prod. do For","CGC/CPF+Prod. do For","CGC/CPF+Prod. do For","U","","","S"})
Aadd(aSIX,{"ZB5","2","ZB5_FILIAL+ZB5_CGCC+ZB5_PRODFO","CGC/CPF+Prod. do Cli","CGC/CPF+Prod. do Cli","CGC/CPF+Prod. do Cli","U","","","S"})
 
Aadd(aSIX,{"ZBZ","1","ZBZ_FILIAL+ZBZ_CNPJ+ZBZ_CHAVE+ZBZ_DTRECB","CNPJ+Chave+Dt. Rec. XML","CNPJ+Chave+Dt. Rec. XML","CNPJ+Chave+Dt. Rec. XML","U","","","S"})
Aadd(aSIX,{"ZBZ","2","ZBZ_FILIAL+ZBZ_NOTA+ZBZ_SERIE+ZBZ_CNPJ","Doc Fiscal+Serie+CNPJ","Doc Fiscal+Serie+CNPJ","Doc Fiscal+Serie+CNPJ","U","","","S"})
Aadd(aSIX,{"ZBZ","3","ZBZ_CHAVE","Chave","Chave","Chave","U","","","S"})

Aadd(aSIX,{"ZBZ","4","ZBZ_FILIAL+ZBZ_FORNEC+ZBZ_NOTA+ZBZ_SERIE","Fornecedor+Doc Fiscal+Serie","Fornecedor+Doc Fiscal+Serie","Fornecedor+Doc Fiscal+Serie","U","","","S"})
Aadd(aSIX,{"ZBZ","5","ZBZ_FILIAL+ZBZ_DTRECB+ZBZ_FORNEC+ZBZ_NOTA+ZBZ_SERIE","Dt. Rec. XML+Fornecedor+Doc Fiscal+Serie","Dt. Rec. XML+Fornecedor+Doc Fiscal+Serie","Dt. Rec. XML+Fornecedor+Doc Fiscal+Serie","U","","","S"})

Aadd(aSIX,{"ZBZ","6","ZBZ_FILIAL+ZBZ_MODELO+ZBZ_NOTA+ZBZ_SERIE+ZBZ_CNPJ","Modelo+Doc Fiscal+Serie+CNPJ","Modelo+Doc Fiscal+Serie+CNPJ","Modelo+Doc Fiscal+Serie+CNPJ","U","","","S"})
Aadd(aSIX,{"ZBZ","7","ZBZ_MODELO+ZBZ_CHAVE","Modelo+Chave","Modelo+Chave","Modelo+Chave","U","","","S"})

Aadd(aSIX,{"ZBZ","8","ZBZ_FILIAL+ZBZ_CODFOR+ZBZ_LOJFOR+ZBZ_PRENF","Cod Forn+Loja+Stat XML","Cod Forn+Loja+Stat XML","Cod Forn+Loja+Stat XML","U","","","S"})

//ZBB
If lTemZBB
	Aadd(aSIX,{xZBB,"1",xZBB_+"FILIAL+"+xZBB_+"FORNEC+"+xZBB_+"LOJA+"+xZBB_+"PROD+"+xZBB_+"PEDIDO+"+xZBB_+"ITEM+"+xZBB_+"ATUAL","Fornec+Loja+Prod+Atual","Fornec+Loja+Prod+Atual","Fornec+Loja+Prod+Atual","U","","","S"})
	Aadd(aSIX,{xZBB,"2",xZBB_+"FILIAL+"+xZBB_+"PEDIDO+"+xZBB_+"ITEM"                  					                       ,"Pedido+Item"           ,"Pedido+Item"           ,"Pedido+Item"           ,"U","","","S"})
EndIf

ProcRegua(Len(aSIX))

dbSelectArea("SIX")
SIX->(DbSetOrder(1))
For nI := 1 To Len(aSIX)
	If !MsSeek(aSIX[nI,1]+aSIX[nI,2])
		RecLock("SIX",.T.)
	Else
		RecLock("SIX",.F.)
	EndIf
	If UPPER(AllTrim(CHAVE)) != UPPER(Alltrim(aSIX[nI,3]))
		aAdd(aArqUpd,aSIX[nI,1])
		lSix := .T.
		If !(aSIX[nI,1]$cAlias)
			cAlias += aSIX[nI,1]+"/"
		EndIf
		For nJ:=1 To Len(aSIX[nI])
			If FieldPos(aEstrut[nJ])>0
				FieldPut(FieldPos(aEstrut[nJ]),aSIX[nI,nJ])
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()
		cTexto  += (aSix[nI][1] + " - " + aSix[nI][3] + Chr(13) + Chr(10))
		TcInternal(60,RetSqlName(aSix[nI,1]) + "|" + RetSqlName(aSix[nI,1]) + aSix[nI,2]) //Exclui sem precisar baixar o TOP
	EndIf
	IncProc("Atualizando índices...")
Next i

If lSix
	cTexto += "Indices atualizados  : "+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IFAtuSX1  ³ Autor ³Marcos Favaro          ³ Data ³04/05/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos SX1                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IFAtuSX1()
//				X1_GRUPO   X1_ORDEM   X1_PERGUNT X1_PERSPA X1_PERENG  X1_VARIAVL X1_TIPO    X1_TAMANHO X1_DECIMAL X1_PRESEL
//				X1_GSC     X1_VALID   X1_VAR01   X1_DEF01  X1_DEFSPA1 X1_DEFENG1 X1_CNT01   X1_VAR02   X1_DEF02
//				X1_DEFSPA2 X1_DEFENG2 X1_CNT02   X1_VAR03  X1_DEF03   X1_DEFSPA3 X1_DEFENG3 X1_CNT03   X1_VAR04   X1_DEF04
// 				X1_DEFSPA4 X1_DEFENG4 X1_CNT04   X1_VAR05  X1_DEF05   X1_DEFSPA5 X1_DEFENG5 X1_CNT05   X1_F3      X1_GRPSXG X1_PYME
Local aSX1   	:= {}
Local aEstrut	:= {}
Local nI      	:= 0
Local nJ      	:= 0
Local lSX1	 	:= .F.
Local cTexto 	:= ''
Local aHelpPor	:=	{}
Local aHelpEng	:=	{}
Local aHelpSpa	:=	{}
Local nTamSx1Grp:= Len(SX1->X1_GRUPO)

aEstrut:= {	"X1_GRUPO"  ,"X1_ORDEM"  ,"X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO"   ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL",;
"X1_GSC"    ,"X1_VALID"  ,"X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01"  ,"X1_VAR02"  ,"X1_DEF02"  ,;
"X1_DEFSPA2","X1_DEFENG2","X1_CNT02"  ,"X1_VAR03" ,"X1_DEF03"  ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03"  ,"X1_VAR04"  ,"X1_DEF04",;
"X1_DEFSPA4","X1_DEFENG4","X1_CNT04"  ,"X1_VAR05" ,"X1_DEF05"  ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05"  ,"X1_F3"     ,"X1_GRPSXG","X1_PYME"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tipo da Nota                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHelpPor	:=	{}
aHelpEng	:=	{}
aHelpSpa	:=	{}
Aadd( aHelpPor, "Informe o Tipo da Nota no XML           " )
aHelpEng := aHelpSpa := aHelpPor

aAdd (aSx1, {PadR("IMPXML",nTamSx1Grp), "01", "Informe Tipo da Nota do XML ? ", "Informe Tipo da Nota do XML ? ", "Informe Tipo da Nota do XML ? ",;
"mv_ch0", "N", 1, 0, 1,"C", "", "mv_par01", "N=Normal","","","","","B=Beneficiament","","",;
"", "", "D=Devolucao", "",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S" })
PutSX1Help("1IMPXML",aHelpPor,aHelpEng,aHelpSpa)

aAdd (aSx1, {PadR("IMPXML",nTamSx1Grp), "01", "Cod. Prod. a Utilizar", "Cod. Prod. a Utilizar", "Cod. Prod. a Utilizar",;
"mv_ch1", "N", 1, 0, 1,"C", "", "mv_par02", "N=Codigo Padrao","","","","","B=Amarracao Padrao","","",;
"", "", "C=Amar. Customizada", "",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "S" })
PutSX1Help("2IMPXML",aHelpPor,aHelpEng,aHelpSpa)

ProcRegua(Len(aSX1))

dbSelectArea("SX1")                           
dbSetOrder(1)
For nI:= 1 To Len(aSX1)
	If !Empty(aSX1[nI][1])
		If !dbSeek(PADR(aSX1[nI,1],nTamSx1Grp)+aSX1[nI,2])
			lSX1	:= .T.
			RecLock("SX1",.T.)
			
			For nJ:=1 To Len(aSX1[nI])
				If !Empty(FieldName(FieldPos(aEstrut[nJ])))
					FieldPut(FieldPos(aEstrut[nJ]),aSX1[nI,nJ])
				EndIf
			Next nJ
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Perguntas de Relatorios...")
		EndIf
	EndIf
Next nI

If lSX1
	cTexto += "Incluidas novas perguntas no SX1."+CHR(13)+CHR(10)
EndIf
Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IFAtuSX2 ³ Autor ³Marcos Favaro           ³ Data ³04/05/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX2                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IFAtuSX2()
Local aSX2   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local lSX2	 := .F.
Local cAlias := ''
Local cPath
Local cNome
Local lTemZBB:= (.NOT. Empty( xZBB ) )

aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_UNICO"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tabela ZB5 - Amarração Produto Fornecedor X Produto Empresa/Filial      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aSX2,{"ZB5","","","Amarração P.For. X P.Emp/Fil","Amarração P.For. X P.Emp/Fil","Amarração P.For. X P.Emp/Fil",0,"E","","",""}) 
AADD(aSX2,{"ZBZ","","","XML de Entrada Importado","XML de Entrada Importado","XML de Entrada Importado",0,"E","","",""})

If lBOSSKEY
	AADD(aSX2,{"ZBX","","","Uso de licencas","Uso de licencas","Uso de licencas",0,"E","","",""})
EndIf

If lTemZBB
	AADD(aSX2,{xZBB,"","","Pedido Recorrente","Pedido Recorrente","Pedido Recorrente",0,"E","","",""})
EndIf

ProcRegua(Len(aSX2))

dbSelectArea("SX2")
dbSetOrder(1)
cPath := SX2->X2_PATH
cNome := cEmpAnt+"0"

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !dbSeek(aSX2[i,1])
			lSX2	:= .T.
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf
			RecLock("SX2",.T.)
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			SX2->X2_PATH := cPath
			SX2->X2_ARQUIVO := aSX2[i,1]+cNome
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Arquivos...") //
		EndIf
	EndIf
Next i

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IFAtuSX3 ³ Autor ³Marcos Favaro          ³ Data ³04/05/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IFAtuSX3()
Local aSX3   := {}
Local aPHelpPor	:={}
Local aPHelpEng	:={}
Local aPHelpSpa	:={}
Local i      := 0
Local j      := 0
Local lSX3	 := .F.
Local lIndexCC8 := .F.
Local cTexto := ''
Local cAlias := ''
Local cOrdem := ""
Local cfolder:= ""
Local cAux   := ""
Local aAlterTb	:=	{} 
Local nTamDoc   := TAMSX3("F3_NFISCAL")[1]
Local nTamProd  := TAMSX3("B1_COD")[1]
Local nTamPed   := TAMSX3("C7_NUM")[1]
Local nTamIte   := TAMSX3("C7_ITEM")[1]
Local nTamTes   := TAMSX3("D1_TES")[1]
Local nTamCod   := TAMSXG("001")[1]
Local nTamLoja  := TAMSXG("002")[1]
Local lTemZBB   := (.NOT. Empty( xZBB ) )
Local nTamQtdZbb:= TAMSX3("C7_QUANT")[1]
Local nDecQtdZbb:= TAMSX3("C7_QUANT")[2]
Local nTamUniZbb:= TAMSX3("C7_PRECO")[1]
Local nDecUniZbb:= TAMSX3("C7_PRECO")[2]
Local nTamTotZbb:= TAMSX3("C7_TOTAL")[1]
Local nDecTotZbb:= TAMSX3("C7_TOTAL")[2]
Local cPict     := ""

//Estrutura para gravacao dos itens no SX3
Local aEstrut:= { 	"X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,;
"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL",;
"X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
"X3_DESCRIC","X3_DESCSPA","X3_DESCENG",;
"X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,;
"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER",;
"X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,;
"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG",;
"X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,;
"X3_GRPSXG" ,"X3_FOLDER" ,"X3_PYME"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicoes a serem consideradas na definicao dos campos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Titulo 		= 12 caracteres
// Descricao 	= 25 caracteres
// Help			= 40 caracteres por linha de help

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao de novos campos no SX3               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cOrdem    := ""


If lBossKey
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tabela ZBX - LIBERACOES DE USO               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aSX3,{"ZBX","","ZBX_FILIAL",;
	"C",02,0,;
	"Filial","Filial","Filial",;
	"Filial do Sistema","Filial do Sistema","Filial do Sistema",;
	"@!","",X3_USADO_NAOUSADO,;
	"","",1,;
	"","","",;
	"","N","",;
	"","","",;
	"","","",;
	"","","033",;
	"",""})
	aPHelpPor := {"Filial do Sistema"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("PZBX_FILIAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	
	AADD(aSX3,{"ZBX","","ZBX_CODCLI",;
	"C",nTamCod,0,;
	"Cod. Cliente ","Cod. Cliente","Cod. Cliente",;
	"Codigo do Cliente","Codigo do Cliente","Codigo do Cliente",;
	"@!","",X3_USADO_EMUSO,;
	"","SA1ZB5",0,;
	"","","S",;
	"U","S","A",;
	"R","","vazio() .or. existcpo('SA1',M->ZBX_CODCLI,1)",;
	"","","",;
	"","","",;
	"",""})
	
	aPHelpPor := {"Codigo do Cliente"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("PZBX_CODCLI",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	                                                         
	
	AADD(aSX3,{"ZBX","","ZBX_LOJCLI",;
	"C",nTamLoja,0,;
	"Loja Cliente ","Loja Cliente","Loja Cliente",;
	"Loja do Cliente","Loja do Cliente","Loja do Cliente",;
	"@!","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	
	aPHelpPor := {"Loja do Cliente"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("PZBX_LOJCLI",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	
	
	
	AADD(aSX3,{"ZBX","","ZBX_CNPJ",;
	"C",14,0,;
	"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF",;
	"CNPJ/CPF do Cliente","CNPJ/CPF do Cliente","CNPJ/CPF do Cliente",;
	"@R 99.999.999/9999-99","Vazio().Or. Cgc(M->A1_CGC)",X3_USADO_EMUSO,;
	"","",0,;
	"","","",;
	"U","S","A",;
	"R","","(cgc(M->A1_CGC) .and. existchav('SA1',M->A1_CGC,3,'A1_CGC') .and. naovazio() .AND. VldCgcCpf(M->A1_Tipo,M->A1_Cgc))",;
	"","","",;
	"",".F.","",;
	"",""})
	
	aPHelpPor := {"CNPJ do Cliente"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("PZBX_CNPJ",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	

	AADD(aSX3,{"ZBX","","ZBX_CNPJ_L",;
	"C",14,0,;
	"CNPJ Liberado","CNPJ Liberado","CNPJ Liberado",;
	"CNPJ Liberado","CNPJ Liberado","CNPJ Liberado",;
	"@R 99.999.999/9999-99","NaoVazio().Or. Cgc(M->ZBX_CNPJ_L)",X3_USADO_EMUSO,;
	"","",0,;
	"","","",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"",".F.","",;
	"",""})
	
	aPHelpPor := {"CNPJ do Cliente"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("PZBX_CNPJL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)


	AADD(aSX3,{"ZBX","","ZBX_RAZAO",;
	"C",40,0,;
	"Nome","Nome","Nome",;
	"Razao Social Cliente.","Razao Social Cliente.","Razao Social Cliente.",;
	"@!","",X3_USADO_EMUSO,;
	"","",0,;
	"","","",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"",".F.","",;
	"",""})
	
	aPHelpPor := {"Razao Social do Cliente"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("PZBX_RAZAO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	AADD(aSX3,{"ZBX","","ZBX_DTLIB",;
	"D",08,0,;
	"Dt. Liberacao","Dt. Liberacao","Dt. Liberacao",;
	"Dt. Liberacao","Dt. Liberacao","Dt. Liberacao",;
	"@D","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","V",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	
	aPHelpPor := {"Dt. Liberacao"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("PZBX_DTLIB",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)


	AADD(aSX3,{"ZBX","","ZBX_DTVLD",;
	"D",08,0,;
	"Validade","Validade","Validade",;
	"Validade","Validade","Validade",;
	"@D","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","V",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	
	aPHelpPor := {"Validade"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("PZBX_DTVLD",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)		     

EndIf




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tabela ZB5 - Amarração                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aSX3,{"ZB5","","ZB5_FILIAL",;
"C",02,0,;
"Filial","Filial","Filial",;
"Filial do Sistema","Filial do Sistema","Filial do Sistema",;
"@!","",X3_USADO_NAOUSADO,;
"","",1,;
"","","",;
"","N","",;
"","","",;
"","","",;
"","","033",;
"",""})
aPHelpPor := {"Filial do Sistema"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_FILIAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZB5","","ZB5_FORNEC",;
"C",nTamCod,0,;
"Cod. Fornec.","Cod. Fornec.","Cod. Fornec.",;
"Codigo do Fornecedor","Codigo do Fornecedor","Codigo do Fornecedor",;
"@!","",X3_USADO_EMUSO,;
"","SA2ZB5",0,;
"","","S",;
"U","S","A",;
"R","","vazio() .or. existcpo('SA2',M->ZB5_FORNEC,1)",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Codigo do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_FORNEC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)


AADD(aSX3,{"ZB5","","ZB5_LOJFOR",;
"C",nTamLoja,0,;
"Loja Fornec.","Loja Fornec.","Loja Fornec.",;
"Loja do Fornecedor","Loja do Fornecedor","Loja do Fornecedor",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Loja do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_LOJFO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

                   


AADD(aSX3,{"ZB5","","ZB5_CGC",;
"C",14,0,;
"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF",;
"CNPJ/CPF do Fornec.","CNPJ/CPF do Fornec.","CNPJ/CPF do Fornec.",;
"@R 99.999.999/9999-99","Vazio().Or.(Cgc(M->A2_CGC).And.A020CGC(M->A2_TIPO,M->A2_CGC))",X3_USADO_EMUSO,;
"","",0,;
"","","",;
"U","S","A",;
"R","","(cgc(M->A2_CGC) .and. existchav('SA2',M->A2_CGC,3,'A2_CGC') .and. naovazio() .AND. VldCgcCpf(M->A2_Tipo,M->A2_Cgc))",;
"","","",;
"",".F.","",;
"",""})

aPHelpPor := {"CGC do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_CGC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZB5","","ZB5_NOME",;
"C",40,0,;
"Razao Social","Razao Social","Razao Social",;
"Razao Social Fornec.","Razao Social Fornec.","Razao Social Fornec.",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","",;
"U","S","A",;
"R","","",;
"","","",;
"",".F.","",;
"",""})

aPHelpPor := {"Razao Social do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_NOME",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZB5","","ZB5_CLIENTE",;
"C",nTamCod,0,;
"Cod. Cliente ","Cod. Cliente","Cod. Cliente",;
"Codigo do Cliente","Codigo do Cliente","Codigo do Cliente",;
"@!","",X3_USADO_EMUSO,;
"","SA1ZB5",0,;
"","","S",;
"U","S","A",;
"R","","vazio() .or. existcpo('SA1',M->ZB5_CLIENTE,1)",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Codigo do Cliente"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_CLIENTE",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
                                                         

AADD(aSX3,{"ZB5","","ZB5_LOJCLI",;
"C",nTamLoja,0,;
"Loja Cliente ","Loja Cliente","Loja Cliente",;
"Loja do Cliente","Loja do Cliente","Loja do Cliente",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Loja do Cliente"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_LOJCLI",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)



AADD(aSX3,{"ZB5","","ZB5_CGCC",;
"C",14,0,;
"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF",;
"CNPJ/CPF do Cliente","CNPJ/CPF do Cliente","CNPJ/CPF do Cliente",;
"@R 99.999.999/9999-99","Vazio().Or. Cgc(M->A1_CGC)",X3_USADO_EMUSO,;
"","",0,;
"","","",;
"U","S","A",;
"R","","(cgc(M->A1_CGC) .and. existchav('SA1',M->A1_CGC,3,'A1_CGC') .and. naovazio() .AND. VldCgcCpf(M->A1_Tipo,M->A1_Cgc))",;
"","","",;
"",".F.","",;
"",""})

aPHelpPor := {"CNPJ do Cliente"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_CGCC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZB5","","ZB5_NOMEC",;
"C",40,0,;
"R. Social Clie.","R. Social Clie.","R. Social Clie.",;
"Razao Social Cliente.","Razao Social Cliente.","Razao Social Cliente.",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","",;
"U","S","A",;
"R","","",;
"","","",;
"",".F.","",;
"",""})

aPHelpPor := {"Razao Social do Cliente"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_NOMEC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZB5","","ZB5_PRODFO",;
"C",nTamProd,0,;
"Prod. do For","Prod. do For","Prod. do For",;
"Cod. Produto do Fornecedor","Cod. Produto do Fornecedor","Cod. Produto do Fornecedor",;
"","",X3_USADO_EMUSO,;
"","",0,;
"","","",;
"U","S","A",;
"R","","ExistChav('ZB5',M->ZB5_CGC+M->ZB5_PRODFO,1,'ZB5_CGC+ZB5_PRODFO')",;
"","","",;
"","","",;
"",""})
aPHelpPor := {"Codigo o Produto do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_PRODFO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZB5","","ZB5_PRODFI",;
"C",nTamProd,0,;
"Codigo Amarr","Codigo Amarr","Codigo Amarr",;
"Nosso Codigo de Produto","Nosso Codigo de Produto","Nosso Codigo de Produto",;
"","",X3_USADO_EMUSO,;
"","SB1ZB5",0,;
"","","S",;
"U","S","A",;
"R","","existcpo('SB1',M->ZB5_PRODFI,1)",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Nosso Codigo de Produto"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_PRODFI",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZB5","","ZB5_DESCPR",;
"C",40,0,;
"Descricao","Descricao","Descricao",;
"Descricao Nosso Produto","Descricao Nosso Produto","Descricao Nosso Produto",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","",;
"U","S","A",;
"R","","",;
"","","",;
"",".F.","",;
"",""})

aPHelpPor := {"Descricao Nosso Produto"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZB5_DESCPR",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
                    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tabela ZBZ - XML Fornecedores                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aSX3,{"ZBZ","","ZBZ_FILIAL",;
"C",02,0,;
"Filial","Filial","Filial",;
"Filial do Sistema","Filial do Sistema","Filial do Sistema",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","033",;
"",""})

aPHelpPor := {"Filial do Sistema"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_FILIAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 


AADD(aSX3,{"ZBZ","","ZBZ_MODELO",;
"C",02,0,;
"Modelo","Modelo","Modelo",;
"Modelo do XML","Modelo do XML","Modelo do XML",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"55=NF-e;56=NFS-e;57=CT-e",;
"55=NF-e;56=NFS-e;57=CT-e",;
"55=NF-e;56=NFS-e;57=CT-e",;
"","","",;
"",""})

aPHelpPor := {"Modelo do XML :" }
Aadd(aPHelpPor,"55=NF-e"        )
Aadd(aPHelpPor,"56=NFS-e"       )
Aadd(aPHelpPor,"57=CT-e"        )

aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_MODELO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 



//UF destinatário a Pedido da ISERO
AADD(aSX3,{"ZBZ","","ZBZ_UF",;
"C",02,0,;
"UF","UF","UF",;
"UF Destinatario","UF Destinatario","UF Destinatario",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"UF Destinatario" }
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_UF",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 
//UF destinatário a Pedido da ISERO



AADD(aSX3,{"ZBZ","","ZBZ_SERIE",;
"C",03,0,;
"Serie NF","Serie NF","Serie NF",;
"Serie da Nota","Serie da Nota","Serie da Nota",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Serie da N. Fiscal do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_SERIE",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 


AADD(aSX3,{"ZBZ","","ZBZ_NOTA",;
"C",nTamDoc,0,;
"Doc Fiscal","Doc Fiscal","Doc Fiscal",;
"Doc Fiscal","Doc Fiscal","Doc Fiscal",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Numero do Documento Fiscal do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_NOTA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 





AADD(aSX3,{"ZBZ","","ZBZ_DTNFE",;
"D",08,0,;
"Dt. da NFE","Dt. da NFE","Dt. da NFE",;
"Data da NFE de Entrada","Data da NFE de Entrada","Data da NFE de Entrada",;
"@D","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Data da Nota Fiscal do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_DTNFE",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)   


AADD(aSX3,{"ZBZ","","ZBZ_PROT",;
"C",15,0,;
"Protocolo","Protocolo","Protocolo",;
"Protocolo de autorização","Protocolo de autorização","Protocolo de autorização",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","N","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Protocolo de autorização do XML"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_PROT",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 

                                                       
AADD(aSX3,{"ZBZ","","ZBZ_PRENF",;
"C",01,0,;
"Flag Xml","Flag Xml","Flag Xml",;
"Flag de importação do Xml","Flag de importação do Xml","Flag de importação do Xml",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"B=Importado;A=Aviso Recbto Carga;S=Pre-Nota a Classificar;N=Pre-Nota Classificada;F=Falha de Importacao;X=Xml Cancelado;Z=Falha de Consulta","","",;
"","","",;
"",""})

aPHelpPor := {"Flag da Pre Nota Gerada na Entrada"}
AADD(aPHelpPor,"B=XML Importado")
AADD(aPHelpPor,"A=Aviso Recbto Carga")
AADD(aPHelpPor,"S=Pré-Nota a Classificar")
AADD(aPHelpPor,"N=Pré-Nota Classificada" )
AADD(aPHelpPor,"F=Falha de Importação" )
AADD(aPHelpPor,"X=Xml Cancelado Pelo Emissor" )

aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_PRENF",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)


AADD(aSX3,{"ZBZ","","ZBZ_CNPJ",;
"C",14,0,;
"CNPJ Emit.","CNPJ Emit.","CNPJ Emit.",;
"CNPJ Fornec.","CNPJ Fornec.","CNPJ Fornec.",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"CNPJ do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_CNPJ",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZBZ","","ZBZ_FORNEC",;
"C",60,0,;
"R. Social","R. Social","R. Social",;
"Razao Social","Razao Social","Razao Social",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Razao Social do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_FORNEC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 

AADD(aSX3,{"ZBZ","","ZBZ_CNPJD",;
"C",14,0,;
"CNPJ Dest.","CNPJ Dest.","CNPJ Dest.",;
"CNPJ Destino","CNPJ Destino","CNPJ Destino",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"CNPJ da Filial de Entrada"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_CNPJD",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZBZ","","ZBZ_CLIENT",;
"C",60,0,;
"Fil Destino","Fil Destino","Fil Destino",;
"Fil Destino","Fil Destino","Fil Destino",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Razao Social da Filial Destino"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_CLIENT",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

                                                      
AADD(aSX3,{"ZBZ","","ZBZ_CHAVE",;
"C",60,0,;
"Chave NFE","Chave NFE","Chave NFE",;
"Chave da NFE","Chave da NFE","Chave da NFE",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Chave da Nfe do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_CHAVE",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)


AADD(aSX3,{"ZBZ","","ZBZ_XML",;
"M",10,0,;
"XML  ","XML   ","XML  ",;
"XML da NFE/CTE  ","XML da NFE/CTE  ","XML da NFE/CTE  ",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"XML Nfe/CTe do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_XML",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 

AADD(aSX3,{"ZBZ","","ZBZ_DTRECB",;
"D",08,0,;
"Dt. Rec. XML","Dt. Rec. XML","Dt. Rec. XML",;
"Dt. do Recebimento do XML","Dt. do Recebimento do XML","Dt. do Recebimento do XML",;
"@D","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","N","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Data do Recebimento do XML"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_DTRECB",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)


AADD(aSX3,{"ZBZ","","ZBZ_DTHRCS",;
"C",19,0,;
"D/H Consulta","D/H consulta","D/H consulta",;
"Data/Hora consulta","Data/Hora consulta","Data/Hora consulta",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","N","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Data e hora da primeira consulta do XML","Formato AAAA-MM-DDTHH:MM:DD"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_DTHRCS",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)



AADD(aSX3,{"ZBZ","","ZBZ_DTHRUC",;
"C",19,0,;
"D/H Ult Cons","D/H Ult Cons","D/H Ult Cons",;
"Data/Hora Ult consulta","Data/Hora Ult consulta","Data/Hora Ult consulta",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","N","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Data e hora da ultima consulta do XML","Formato AAAA-MM-DDTHH:MM:DD"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_DTHRUC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
    

AADD(aSX3,{"ZBZ","","ZBZ_CODFOR",;
"C",nTamCod,0,;
"Cod Forn","Cod Forn","Cod Forn",;
"Cod Fornecedor","Cod Fornecedor","Cod Fornecedor",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Codigo do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_CODFOR",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 



AADD(aSX3,{"ZBZ","","ZBZ_LOJFOR",;
"C",nTamLoja,0,;
"Loja Forn","Loja Forn","Loja Forn",;
"Loja Fornecedor","Loja Fornecedor","Loja Fornecedor",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Loja do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_LOJFOR",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 



AADD(aSX3,{"ZBZ","","ZBZ_STATUS",;
"C",1,0,;
"Status","Status","Status",;
"Status","Status","Status",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Status do xml."+CRLF+;
				"1=OK"+CRLF+;
				"2=Erro"+CRLF+;
				"3=Aviso"}
                                                                                                             
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_STATUS",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 
                                                         

AADD(aSX3,{"ZBZ","","ZBZ_OBS",;
"M",256,0,;
"Observacao","Observacao","Observacao",;
"Observacao","Observacao","Observacao",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Observaçoes e informaçoes sobre o XML."}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_OBS",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 
         


AADD(aSX3,{"ZBZ","","ZBZ_TPEMIS",;
"C",1,0,;
"Tp Emissao","Tp Emissao","Tp Emissao",;
"Tp Emissao","Tp Emissao","Tp Emissao",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"1=Normal;2=Contingência FS;3=Contingência SCAN; 4=Contingência DPEC; 5=Contingência FS-DA",;
"1=Normal;2=Contingência FS;3=Contingência SCAN; 4=Contingência DPEC; 5=Contingência FS-DA",;
"1=Normal;2=Contingência FS;3=Contingência SCAN; 4=Contingência DPEC; 5=Contingência FS-DA",;
"","","",;
"",""})

aPHelpPor := {"Tipo de Emissao."}
Aadd(aPHelpPor,"1=Normal")
Aadd(aPHelpPor,"2=Contingência FS")
Aadd(aPHelpPor,"3=Contingência SCAN")
Aadd(aPHelpPor,"4=Contingência DPEC")
Aadd(aPHelpPor,"5=Contingência FS-DA")
                                                                                                             
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_TPEMIS",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 

 

AADD(aSX3,{"ZBZ","","ZBZ_TPAMB",;
"C",1,0,;
"Ambiente","Ambiente","Ambiente",;
"Ambiente","Ambiente","Ambiente",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"1=Produção;2=Homologação",;
"1=Produção;2=Homologação",;
"1=Produção;2=Homologação",;
"","","",;
"",""})

aPHelpPor := {"Ambiente de emissão do xml."}
Aadd(aPHelpPor,"1=Produção")
Aadd(aPHelpPor,"2=Homologação")
                                                                                                             
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_TPAMB",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)   

 
AADD(aSX3,{"ZBZ","","ZBZ_TPDOC",;
"C",01,0,;
"Tipo Doc","Tipo Doc","Tipo Doc",;
"Tipo do Documento","Tipo do Documento","Tipo do Documento",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"N=Normal;D=Devolucao;B=Beneficiamento;C=Complemento Preco/Frete;I=Comp. ICMS;P=Comp. IPI",;
"N=Normal;D=Devolucao;B=Beneficiamento;C=Complemento Preco/Frete;I=Comp. ICMS;P=Comp. IPI",;
"N=Normal;D=Devolucao;B=Beneficiamento;C=Complemento Preco/Frete;I=Comp. ICMS;P=Comp. IPI",;
"","","",;
"",""})
  
aPHelpPor := {"Tipo do Documento :"}
Aadd(aPHelpPor,"N=Normal"        )
Aadd(aPHelpPor,"D=Devolucao"        )
Aadd(aPHelpPor,"B=Beneficiamento"        )
Aadd(aPHelpPor,"C=Complemento Preco/Frete"        )
Aadd(aPHelpPor,"I=Comp. ICMS"        )
Aadd(aPHelpPor,"P=Comp. IPI"        )   	

aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_TPDOC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 
                             

AADD(aSX3,{"ZBZ","","ZBZ_FORPAG",;
"C",01,0,;
"Forma Pgto","Forma Pgto","Forma Pgto",;
"Forma Pgto","Forma Pgto","Forma Pgto",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"0=Pago;1=A Pagar;2=Outros",;
"0=Pago;1=A Pagar;2=Outros",;
"0=Pago;1=A Pagar;2=Outros",;
"","","",;
"",""})
  
aPHelpPor := {"Forma de Pagamento :"}
Aadd(aPHelpPor,"0=Pago"        )
Aadd(aPHelpPor,"1=A Pagar"        )
Aadd(aPHelpPor,"2=Outros"        )

aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_FORPAG",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 
               
              
              

AADD(aSX3,{"ZBZ","","ZBZ_TOMA",;
"C",02,0,;
"Tomador CT-e","Tomador","Tomador",;
" Indicador do papel do tomador do CT-e "," Indicador do papel do tomador do CT-e "," Indicador do papel do tomador do CT-e ",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"0-Remetente;1-Expedidor;2-Recebedor;3-Destinatário",;
"0-Remetente;1-Expedidor;2-Recebedor;3-Destinatário",;
"0-Remetente;1-Expedidor;2-Recebedor;3-Destinatário",;
"","","",;
"",""})
 
aPHelpPor := {"Indicador do papel do tomador do serviço no CT-e."}
Aadd(aPHelpPor,"0-Remetente"        )
Aadd(aPHelpPor,"1-Expedidor"        )
Aadd(aPHelpPor,"2-Recebedor"        )
Aadd(aPHelpPor,"3-Destinatário"     )
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_TOMA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 

               


AADD(aSX3,{"ZBZ","","ZBZ_DTHCAN",;
"C",19,0,;
"D/H Ccancel","D/H Ccancel","D/H Ccancel",;
"Data/Hora cancelamento","Data/Hora cancelamento","Data/Hora cancelamento",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","N","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Data e hora do cancelamento do XML","Formato AAAA-MM-DDTHH:MM:DD"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_DTHCAN",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 

 
AADD(aSX3,{"ZBZ","","ZBZ_PROTC",;
"C",15,0,;
"Prot Canc","Prot Canc","Prot Canc",;
"Protocolo de cancelamento","Protocolo de  cancelamento","Protocolo de  cancelamento",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","N","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Protocolo de  cancelamento do XML"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_PROTC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 



AADD(aSX3,{"ZBZ","","ZBZ_XMLCAN",;
"M",10,0,;
"XML Cancel","XML Cancel","XML Cancel",;
"XML de cancelamento","XML de cancelamento","XML de cancelamento",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"XML de cancelamento"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_XMLCAN",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 

 


AADD(aSX3,{"ZBZ","","ZBZ_VERSAO",;
"C",5,0,;
"Versao XML","Versao XML","Versao XML",;
"Versao do XML","Versao do XML","Versao do XML",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Versao do XML"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_VERSA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)  


AADD(aSX3,{"ZBZ","","ZBZ_MAIL",;
"C",1,0,;
"E-mail","E-mail","E-mail",;
"Status E-mail","Status E-mail","Status E-mail",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"0=Ok;1=Erro (Pendente);2=Erro (Enviado);3=Cancelamento (Pendente);4=Cancelamento (Enviado);X=Falha (Erro);Y=Falha (Cancelamento)",;
"0=Ok;1=Erro (Pendente);2=Erro (Enviado);3=Cancelamento (Pendente);4=Cancelamento (Enviado);X=Falha (Erro);Y=Falha (Cancelamento)",;
"0=Ok;1=Erro (Pendente);2=Erro (Enviado);3=Cancelamento (Pendente);4=Cancelamento (Enviado);X=Falha (Erro);Y=Falha (Cancelamento)",;
"","","",;
"",""})


aPHelpPor := {"Status de Notificações por e-mail."}
Aadd(aPHelpPor,"0-Xml Ok (Não envia)"     )
Aadd(aPHelpPor,"1-Xml com erro (Pendente)"     )
Aadd(aPHelpPor,"2-Xml com erro (Enviado)"     )
Aadd(aPHelpPor,"3-Xml cancelado (Pendente)"     )
Aadd(aPHelpPor,"4-Xml cancelado (Enviado)"     )
Aadd(aPHelpPor,"X-Falha ao enviar o e-mail (Erro)"     )
Aadd(aPHelpPor,"Y-Falha ao enviar o e-mail (Cancelamento) "     )
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_MAIL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 



AADD(aSX3,{"ZBZ","","ZBZ_DTMAIL",;
"M",10,0,;
"Msg E-mail","Msg E-mail","Msg E-mail",;
"Mensagem do E-mail","Mensagem do E-mail","Mensagem do E-mail",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","V",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Observação/Mensagens de erros"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_DTMAIL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)


AADD(aSX3,{"ZBZ","","ZBZ_SERORI",;
"C",03,0,;
"Serie Ori","Serie Ori","Serie Ori",;
"Serie Original da Nota","Serie da Nota","Serie Original da Nota",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Serie Original (XML) da N. Fiscal do Fornecedor"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_SERORI",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

AADD(aSX3,{"ZBZ","","ZBZ_EXP",;
"C",01,0,;
"Exportado ?","Exportado ?","Exportado ?",;
"Exportado dados para banco oracle","Exportado dados para banco oracle","Exportado dados para banco oracle",;
"@!","",X3_USADO_NAOUSADO,;
"","",0,;
"","","",;
"U","S","A",;
"R","","",;
"S=Sim;N=Não","","",;
"","","",;
"",""})
aPHelpPor := {"Exportado para banco oracle"}
Aadd(aPHelpPor,"S=Sim"        )
Aadd(aPHelpPor,"N=Não"        )

aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_EXP",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)


AADD(aSX3,{"ZBZ","","ZBZ_MANIF",;
"C",01,0,;
"Manif ?","Manif ?","Manif ?",;
"Manifestado ?","Manifestado ?","Manifestado ?",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","",;
"U","S","A",;
"R","","",;
"0=Não Manifesta;1=Conf.Operação;2=Operação Desconhecida;3=Operação Não Realizada;4=Ciência da Operação","","",;
"","","",;
"",""})
aPHelpPor := {"Manifestado ?"}
Aadd(aPHelpPor,"0=Não Manifesta"          )
Aadd(aPHelpPor,"1=Conf.Operação"          )
Aadd(aPHelpPor,"2=Operação Desconhecida"  )
Aadd(aPHelpPor,"3=Operação Não Realizada" )
Aadd(aPHelpPor,"4=Ciência da Operação"    )

aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_EXP",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

//GETESB
AADD(aSX3,{"ZBZ","","ZBZ_CONDPG",;   
"M",256,0,;
"Cond. Pag.","Cond. Pag.","Cond. Pag.",;
"Condição de Pagamento","Condição de Pagamento","Condição de Pagamento",;
"@!","",X3_USADO_EMUSO,;
"","",0,;
"","","S",;
"U","S","A",;
"R","","",;
"","","",;
"","","",;
"",""})

aPHelpPor := {"Condição de Pagamento da NF-e"}
aPHelpEng := aPHelpPor
aPHelpSpa := aPHelpPor
PutHelp("PZBZ_CONDPG",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tabela (xZBB) - Pedido Recorrente            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTemZBB
	AADD(aSX3,{xZBB,"",xZBB_+"FILIAL",;
	"C",02,0,;
	"Filial","Filial","Filial",;
	"Filial do Sistema","Filial do Sistema","Filial do Sistema",;
	"@!","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","033",;
	"",""})
	aPHelpPor := {"Filial do Sistema"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"FILIAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	AADD(aSX3,{xZBB,"",xZBB_+"FORNEC",;
	"C",nTamCod,0,;
	"Cod Forn","Cod Forn","Cod Forn",;
	"Cod Fornecedor","Cod Fornecedor","Cod Fornecedor",;
	"@!","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Codigo do Fornecedor"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"FORNEC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.) 

	AADD(aSX3,{xZBB,"",xZBB_+"LOJA",;
	"C",nTamLoja,0,;
	"Loja Forn","Loja Forn","Loja Forn",;
	"Loja Fornecedor","Loja Fornecedor","Loja Fornecedor",;
	"@!","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Loja do Fornecedor"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"LOJA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	AADD(aSX3,{xZBB,"",xZBB_+"PROD",;
	"C",nTamProd,0,;
	"Codigo Prod","Codigo Prod","Codigo Prod",;
	"Codigo do Produto","Codigo do Produto","Codigo do Produto",;
	"","",X3_USADO_EMUSO,;
	"","SB1"+xZBB,0,;
	"","","S",;
	"U","S","A",;
	"R","","existcpo('SB1',M->"+xZBB_+"PROD,1)",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Nosso Codigo de Produto"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"PROD",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	AADD(aSX3,{xZBB,"",xZBB_+"DESC",;
	"C",30,0,;
	"Descr Prod","Descr Prod","Descr Prod",;
	"Descrição do Produto","Descrição do Produto","Descrição do Produto",;
	"","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Descrção do Produto"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"DESC",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	AADD(aSX3,{xZBB,"",xZBB_+"UN",;
	"C",30,0,;
	"Unid","Unid","Unid",;
	"Unidade","Unidade","Unidade",;
	"","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Unidade do Produto"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"UN",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	
	cPict := hfPESQPICT("SC7","C7_QUANT")

	AADD(aSX3,{xZBB,"",xZBB_+"QUANT",;
	"N",nTamQtdZbb,nDecQtdZbb,;
	"Quantidade","Quantidade","Quantidade",;
	"Quantidade","Quantidade","Quantidade",;
	cPict,"",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Quantidade"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"QUANT",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	cPict := hfPESQPICT("SC7","C7_PRECO")

	AADD(aSX3,{xZBB,"",xZBB_+"VUNIT",;
	"N",nTamUniZbb,nDecUniZbb,;
	"Vr Unitario","Vr Unitario","Vr Unitario",;
	"Valor Unitario","Valor Unitario","Valor Unitario",;
	cPict,"",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Valor Unitario"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"VUNIT",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	cPict := hfPESQPICT("SC7","C7_TOTAL")

	AADD(aSX3,{xZBB,"",xZBB_+"TOTAL",;
	"N",nTamTotZbb,nDecTotZbb,;
	"Vr Total","Vr Total","Vr Total",;
	"Valor Total","Valor Total","Valor Total",;
	cPict,"",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Valor Total"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"TOTAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	AADD(aSX3,{xZBB,"",xZBB_+"PEDIDO",;
	"C",nTamPed,0,;
	"Pedido","Pedido","Pedido",;
	"Numero Pedido","Numero Pedido","Numero Pedido",;
	"","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Numero Pedido Compra"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"PEDIDO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	AADD(aSX3,{xZBB,"",xZBB_+"ITEM",;
	"C",nTamIte,0,;
	"Item","Item","Item",;
	"Item Pedido","Item Pedido","Item Pedido",;
	"","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Item Pedido Compra"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"ITEM",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	AADD(aSX3,{xZBB,"",xZBB_+"TES",;
	"C",nTamTes,0,;
	"TES","TES","TES",;
	"Tipo de Entrada","Tipo de Entrada","Tipo de Entrada",;
	"","",X3_USADO_EMUSO,;
	"","SF4",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Tipo de Entrada"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"TES",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

	AADD(aSX3,{xZBB,"",xZBB_+"AMARRA",;
	"C",1,0,;
	"Amarracao","Amarracao","Amarracao",;
	"Amarracao Produto","Amarracao Produto","Amarracao Produto",;
	"","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Amarracao Produto"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"AMARRA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)


	AADD(aSX3,{xZBB,"",xZBB_+"ATUAL",;
	"C",1,0,;
	"Ped Atual","Ped Atual","Ped Atual",;
	"Pedido Atual","Pedido Atual","Pedido Atual",;
	"","",X3_USADO_EMUSO,;
	"","",0,;
	"","","S",;
	"U","S","A",;
	"R","","",;
	"","","",;
	"","","",;
	"",""})
	aPHelpPor := {"Pedido Atual"}
	aPHelpEng := aPHelpPor
	aPHelpSpa := aPHelpPor
	PutHelp("P"+xZBB_+"ATUAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterações de campo                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	If dbSeek("ZBZ_LOJFOR")
		If SX3->X3_TAMANHO <> nTamLoja //aquui
			RecLock("SX3",.F.)
			SX3->X3_TAMANHO := nTamLoja
			MsUnLock()
			aAdd(aAlterTb,"ZBZ")
		EndIF
	EndIf
	If dbSeek("ZBZ_MODELO")
		If AllTrim(SX3->X3_CBOX) <> "55=NF-e;56=NFS-e;57=CT-e"
			RecLock("SX3",.F.)
			SX3->X3_CBOX := "55=NF-e;56=NFS-e;57=CT-e"
			MsUnLock()
			aAdd(aAlterTb,"ZBZ")
		EndIF
	EndIf

	If dbSeek("ZB5_PRODFI")
		If SX3->X3_TAMANHO <> nTamProd
			RecLock("SX3",.F.)
			SX3->X3_TAMANHO := nTamProd
			MsUnLock()
			aAdd(aAlterTb,"ZB5")
		EndIF
	EndIf         

	If dbSeek("ZBZ_PRENF")
		If AllTrim(SX3->X3_CBOX) <> "B=Importado;A=Aviso Recbto Carga;S=Pre-Nota a Classificar;N=Pre-Nota Classificada;F=Falha de Importacao;X=Xml Cancelado;Z=Falha de Consulta"
			RecLock("SX3",.F.)
			SX3->X3_CBOX   := "B=Importado;A=Aviso Recbto Carga;S=Pre-Nota a Classificar;N=Pre-Nota Classificada;F=Falha de Importacao;X=Xml Cancelado;Z=Falha de Consulta"
			SX3->X3_TITULO := "Flag Xml"
			SX3->X3_DESCRIC:= "Flag de importação do Xml"
			MsUnLock()
			aAdd(aAlterTb,"ZBZ")
		EndIF
	EndIf

	If dbSeek("ZBZ_MANIF")
		If AllTrim(SX3->X3_CBOX) <> "0=Não Manifesta;1=Conf.Operação;2=Operação Desconhecida;3=Operação Não Realizada;4=Ciência da Operação" .or.;
			SX3->X3_USADO <> X3_USADO_EMUSO
			RecLock("SX3",.F.)
			SX3->X3_CBOX   := "0=Não Manifesta;1=Conf.Operação;2=Operação Desconhecida;3=Operação Não Realizada;4=Ciência da Operação"
			SX3->X3_USADO  := X3_USADO_EMUSO
			MsUnLock()
			aAdd(aAlterTb,"ZBZ")
		EndIF
	EndIf

ProcRegua(Len(aSX3))

dbSelectArea("SX3")
SX3->(dbSetOrder(2))

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(PadR(aSX3[i,3],Len(SX3->X3_CAMPO)))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³A ordem sera analisada no momento da gravacao visto que    ³
			//³a base pode conter alguns dos campos informados neste      ³
			//³fonte para gravacao. Neste caso, se definissemos a ordem   ³
			//³no momento da criacao do array aSX3, algumas ordem ficariam³
			//³perdidas no SX3.                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cOrdem		:= ProxOrdem(aSX3[i,1])
			aSX3[i,2] 	:= cOrdem
			//
			lSX3	:= .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
				aAdd(aArqUpd,aSX3[i,1])
			EndIf
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0
					If aEstrut[j] $ "X3_NIVEL/X3_TAMANHO/X3_DECIMAL" .And. Valtype(aSX3[i,j]) == "C"
						FieldPut(FieldPos(aEstrut[j]),Val(aSX3[i,j]))
					ElseIf aEstrut[j] $ "X3_OBRIGAT" .And. Valtype(aSX3[i,j]) <> "C"
						FieldPut(FieldPos(aEstrut[j]),"")
					Else
						FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
					EndIf
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Dados...")
		Endif
	EndIf
Next i
             
For i:= 1 to len(aAlterTb)
	If !(aAlterTb[i]$cAlias)
		lSX3 := .T.
		cAlias += aAlterTb[i]+"/"
		aAdd(aArqUpd,aAlterTb[i])
	EndIf
Next i


DbSelectArea("SX3")
SX3->(dbSetOrder(1))  
DbSeek("ZBZ")
While   SX3->X3_ARQUIVO  == "ZBZ" 
	cFolder := "1"
	If AllTrim(SX3->X3_CAMPO) == "ZBZ_DTHCAN" .Or. AllTrim(SX3->X3_CAMPO) == "ZBZ_XMLCAN" .Or. AllTrim(SX3->X3_CAMPO) == "ZBZ_PROTC"
		cFolder := "2"
	EndIf
	If AllTrim(SX3->X3_CAMPO) == "ZBZ_MAIL" .Or. AllTrim(SX3->X3_CAMPO) == "ZBZ_DTMAIL"
		cFolder := "3"
	EndIf

	RecLock("SX3",.F.)
	SX3->X3_FOLDER := cFolder
	MsUnLock()

	SX3->(dbSkip())	
EndDo

TcInternal(60,RetSqlName("ZB5") + "|" + RetSqlName("ZB5") + "1") //Inclui sem precisar baixar o TOP
TcInternal(60,RetSqlName("ZBZ") + "|" + RetSqlName("ZBZ") + "1") //Inclui sem precisar baixar o TOP
If lTemZBB
	TcInternal(60,RetSqlName(xZBB) + "|" + RetSqlName(xZBB) + "1") //Inclui sem precisar baixar o TOP
EndIF

If lSX3
	cTexto := 'Foram alteradas as estruturas das seguintes tabelas : '+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IFAtuSX6 ³ Autor ³Marcos Favaro          ³ Data ³04/05/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX6                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IFAtuSX6()
Local aSX6   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX6	 := .F.
Local cTexto := ''
Local cAlias := ''
Local cDeldp := ''

aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Importacao XML NF- Entrada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
AADD(aSx6,{"  ","MV_XMLIMPO","C","Pasta onde os XML de Pre Nota Importados Serao","","","","","","","","","IMPORTADOS","","","",""})
AADD(aSx6,{"  ","MV_XMLREJE","C","Pasta onde os XML de Pre Nota Rejeitados Serao","","","","","","","","","REJEITADOS","","","",""})
AADD(aSx6,{"  ","MV_XMLEXTR","C","Onde Sera Gerada a Pasta de Extrutura dos XML","","","Para serem importados e Arquivados","","","Servidor ou Local","","","XML_FORNECEDORES","","","",""})
AADD(aSx6,{"  ","MV_NFEFOR1","C","SMTP de Envio de XML Fornecedor","","","","","","","","","","","","",""})
AADD(aSx6,{"  ","MV_NFEFOR2","C","Conta de Email de Envio de XML Fornecedor","","","","","","","","","","","","",""})
AADD(aSx6,{"  ","MV_NFEFOR3","C","Senha da Conta de Envio de XML Fornecedor","","","","","","","","","","","","",""})
*/
AADD(aSx6,{space(len(SX6->X6_FIL)),"MV_MOSTRAA","C","Mostra todas Consultas junto a Sefaz S ou N." ,"","","","","","","","","S","","","",""}) 
                       
/* COnfiguração de envios SMTP */
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_PROTENV","C","Protocolo de envio de notificação de xml."    ,"","","","","","","","","1","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_SMTP"   ,"C","SMTP de Envio de e-mail"	          		    ,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_ACCOUNT","C","Conta de Email de Envio de XML Fornecedor."	,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_LOGIN"  ,"C","Login de Email de Envio de XML Fornecedor."	,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_PASS"   ,"C","Senha da Conta de Envio de XML Fornecedor."	,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_AUT"    ,"C","Informa se e-mail utiliza autenticação."		,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_SSL"    ,"C","Informa se e-mail utiliza conexao segura."   	,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_TLS"    ,"C","Informa se e-mail utiliza conexao segura TLS.","","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_ENVPORT","C","Porta de Envio."                             	,"","","","","","","","","","","","",""})
/* Configuração de recebimento POP / IMAP */
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_PROTREC","C","Protocolo de recebimento de xml."	                    ,"","","","","","","","","1","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_POPIMAP","C","Endereço POP/IMAP de Recebimento de XML Fornecedor"	,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_POPACC" ,"C","Conta de Email de Recebimento de XML Fornecedor."		,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_POPPASS","C","Senha da Conta de Recebimento de XML Fornecedor."		,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_POPAUT" ,"C","Informa se e-mail utiliza autenticação."				,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_POPSSL" ,"C","Informa se e-mail utiliza conexao segura."			,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_RECPORT","C","Porta de Recebimento."                             	,"","","","","","","","","","","","",""})

/* E-mail de Notificacao */

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_MAIL01"   ,"C","E-mail para notificaçao de eventos."				,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_MAIL02"   ,"C","E-mail para notificaçao de eventos."				,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_MAIL03"   ,"C","E-mail para notificaçao de eventos."				,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_MAIL04"   ,"C","E-mail para notificaçao de eventos."				,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_MAIL05"   ,"C","E-mail para notificaçao de eventos."				,"","","","","","","","","","","","",""})

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_DIRFIL"   ,"C","Informa se cria diretorio por Filial do cliente."   ,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_DIRCNPJ"  ,"C","Informa se cria diretorio por CNPJ do emitente."    ,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_DIRMOD"   ,"C","Informa se cria diretorio por modelo de XML."       ,"","","","","","","","","","","","",""})
/*Configuração da ABA Geral*/
AADD(aSx6,{space(len(SX6->X6_FIL)),"MV_X_PATHX"  ,"C","Diretorio Raiz dos XMLs importados."                ,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_FORMNFE"  ,"C","Formato do campo Documento/Nota fiscal para NF-e."  ,"","","","","","","","","9","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_FORMCTE"  ,"C","Formato do campo Documento/Nota fiscal para CT-e."  ,"","","","","","","","","9","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_FORCET3"  ,"C","Informa se força a busca pelo tomador do CT-e."     ,"","","","","","","","","","","","",""})

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_USANFE"   ,"C","Informa se utiliza importação de NF-e."             ,"","","","","","","","","S","S","S","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_USACTE"   ,"C","Informa se utiliza importação de CT-e."             ,"","","","","","","","","S","S","S","",""})

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_PRODCTE"  ,"C","Código de produto padrão para NF de CT-e."          ,"","","","","","","","","","","","",""})

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_PED_PRE"  ,"C","Informa se assume valores do pedido na Pre-nota."   ,"","","","","","","","","","","","",""})

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_CFDEVOL"  ,"C","Cfops de devolução em entradas de NF-e."            ,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_CFBENEF"  ,"C","Cfops de beneficiamento em entradas de NF-e."       ,"","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_DE_PARA"  ,"C","Tipo de seleção de amarração de produto."           ,"","","","","","","","","0","","","",""})

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_D_STATUS" ,"C","Dias a retroceder para verificar Status XML."      ,"","","","","","","","","30","30","30","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_D_CANCEL" ,"C","Dias a retroceder para consultar XML na SEFAZ."    ,"","","","","","","","","7","7","7","",""})
																						
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_DT_CONS"  ,"C","Data de execução da ultima consulta XML na SEFAZ." ,"","","","","","","","","20130101","20130101","20130101","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_HR_CONS"  ,"C","Hora programada de execução da consulta XML na SEFAZ." ,"","","","","","","","","22:00","22:00","22:00","",""})																						

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_ROTINAS"  ,"C","Rotinas a serem executadas pelo botão 'Baixar XML'.","","","","","","","","","1,2,3,5","1,2,3,5","1,2,3,5","",""})	

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_CFGPRE"   ,"C","Define a ação após a geração de pré-nota","","","","","","","","","0","0","0","",""})	
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_TIP_PRE"  ,"C","Tipo de pré-nota","","","","","","","","","1","1","1","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_FIL_USU"  ,"C","Filtra Filial por Usuário","","","","","","","","","N","N","N","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_URL"      ,"C","URL do TSS a qual será utilizado pelo importa.","","","","","","","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_CTE_DET"  ,"C","Detalha Notas Fiscias nos itens de CT-e","","","","","","","","","N","N","N","",""})

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_NFORI"  	 ,"C","Amarra NF Origem pelo Livro Fiscal(Entradas)?","","","S - Livro Fiscal(SF3); N - NF Saida(SF2).","","","","","","N","N","N","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_CSOL"  	 ,"C","Amarra C.Custo de Qual Cadastro?","","","S - Ped.Compra; N - Cad.Produto; A - Ambos","","","","","","A","A","A","",""})

/*Configuração da ABA Geral 2 - Alexandro de Oliveira - 25/11/2014*/
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_SEREMP"  ,"C","SERIE POR EMPRESA"          ,"","","EX: SP=01,02;ES=10,11"                 ,"","","VAZIO Mantem Série do XML","","","","","","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_SERXML"  ,"C","SERIE DO XML VAZIA QUANDO 0","","","EX: S=SIM EM BRANCO; N=NAO COM VALOR 0","","",""                         ,"","","N","N","N","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_GRBMOD"  ,"C","CONSULTA TODAS MODALIDADES" ,"","",""                                      ,"","",""                         ,"","","N","N","N","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_PED_GBR" ,"C","Trava XML Diferente Pedido" ,"","",""                                      ,"","",""                         ,"","","N","N","N","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_ROT_CON" ,"C","ROTINA DE CONSULTA AO SEFAZ","","","1=Importa XML, 2=TSS"                  ,"","",""                         ,"","","1","1","1","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_CCNFOR"  ,"C","C.Custo da NF Origem para CTE?","","",""                                   ,"","",""                         ,"","","N","N","N","",""})

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_PEDREC"  ,"C","Utiliza Pedido Recorrente"     ,"","",""                                   ,"","",""                         ,"","","N","N","N","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_TABREC"  ,"C","Tabela de Fornecedores com Pedido Recorrente","","",""                     ,"","",""                         ,"","","   ","   ","   ","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_RECDOC"  ,"C","Tipo de documento a gerar por pedido recorrente"     ,"","",""                                   ,"","",""                         ,"","","1","1","1","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_XMLSEF"  ,"C","Comparar TAGs do XML com a SEFAZ","","",""                                   ,"","",""                         ,"","","N","N","N","",""})
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_MANPRE"  ,"C","Manifestar após gerar a pré-nota","","",""                                   ,"","",""                         ,"","","N","N","N","",""})
//Adicionado dia 16/06/2015 pelo analista Alexandro
AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_LOGOD"   ,"C","Emissão do Logo na Danfe"        ,"","","EX: S=SIM EMITE LOGO; N=NAO EMITE LOGO","","",""                         ,"","","N","N","N","",""})

ProcRegua(Len(aSX6))

dbSelectArea("SX6")
dbSetOrder(1)

For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If !dbSeek(aSX6[i,1]+aSX6[i,2])
			lSX6	:= .T.
			If !(aSX6[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Parametros...") //
		Else
			j := 0
			Do While .Not. SX6->( Eof() ) .And. SX6->X6_FIL == aSX6[i,1] .And. AllTrim(SX6->X6_VAR) == AllTrim(aSX6[i,2])
				j++
				If j >= 2
					RecLock("SX6",.F.)
					SX6->( dbDelete() )
					SX6->( dbCommit() )
					SX6->( MsUnLock() )
					If !(aSX6[i,2]$cDeldp)
						cDeldp += aSX6[i,2]+"/"
					EndIf
				EndIf
				SX6->( dbSkip() )
			EndDo
		EndIf
	EndIf
Next i


If AllTrim(GetNewPar("XM_POPIMAP",""))==""
	PutMv("XM_POPIMAP", GetNewPar("XM_SMTP","")  )
EndIf

If AllTrim(GetNewPar("XM_POPACC" ,""))==""
	PutMv("XM_POPACC", GetNewPar("XM_ACCOUNT","")  )
EndIf

If AllTrim(GetNewPar("XM_POPPASS",""))==""
	PutMv("XM_POPPASS", GetNewPar("XM_PASS","")  )
EndIf

If AllTrim(GetNewPar("XM_POPAUT" ,""))==""
	PutMv("XM_POPAUT", GetNewPar("XM_AUT","")  )
EndIf

If AllTrim(GetNewPar("XM_POPSSL" ,""))==""
	PutMv("XM_POPSSL", GetNewPar("XM_SSL","")  )
EndIf

If lSX6
	cTexto := 'Incluidos novos parametros. Verifique as suas configuracoes e funcionalidades : '+cAlias+CHR(13)+CHR(10)
EndIf
If .Not. Empty( cDeldp )
	cTexto += 'Parametros Duplicados que foram Ajustados : '+cDeldp+CHR(13)+CHR(10)
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IFAtuSX7 ³ Autor ³Marcos Favaro           ³ Data ³04/05/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX7                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IFAtuSX7()
Local aSX7   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX7	 := .F.
Local cTexto := ''
aEstrut:= {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_CONDIC","X7_PROPRI"}

aAdd(aSX7,{"ZB5_FORNEC","001","M->ZB5_NOME:=SA2->A2_NOME"    ,"ZB5_NOME"  ,"P","S","SA2",1,"xFilial('SA2')+M->ZB5_FORNEC","!EMPTY(M->ZB5_FORNEC)","U"})
aAdd(aSX7,{"ZB5_FORNEC","002","M->ZB5_CGC := SA2->A2_CGC"    ,"ZB5_CGC"   ,"P","S","SA2",1,"xFilial('SA2')+M->ZB5_FORNEC","!EMPTY(M->ZB5_FORNEC)","U"})
aAdd(aSX7,{"ZB5_PRODFI","001","M->ZB5_DESCPR := SB1->B1_DESC","ZB5_DESCPR","P","S","SB1",1,"xFilial('SB1')+M->ZB5_PRODFI","!EMPTY(ZB5_PRODFI)","U"})
aAdd(aSX7,{"ZB5_CLIENTE","001","M->ZB5_NOMEC:=SA1->A1_NOME"    ,"ZB5_NOMEC"  ,"P","S","SA1",1,"xFilial('SA1')+M->ZB5_CLIENTE","!EMPTY(M->ZB5_CLIENTE)","U"})
aAdd(aSX7,{"ZB5_CLIENTE","002","M->ZB5_CGCC := SA1->A1_CGC"    ,"ZB5_CGCC"   ,"P","S","SA1",1,"xFilial('SA1')+M->ZB5_CLIENTE","!EMPTY(M->ZB5_CLIENTE)","U"})

ProcRegua(Len(aSX7))

dbSelectArea("SX7")
dbSetOrder(1)
For i:= 1 To Len(aSX7)
	If !Empty(aSX7[i][1])
		If !dbSeek(PADR(aSX7[i,1],len(SX7->X7_CAMPO))+aSX7[i,2])
			lSX7	 := .T.
			RecLock("SX7",.T.)
			
			For j:=1 To Len(aSX7[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX7[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			DbSelectArea("SX3")
			dbSetOrder(2)
			If MsSeek(aSX7[i,1])
				RecLock("SX3")
				SX3->X3_TRIGGER := "S"
				dbCommit()
				MsUnLock()
			EndIf
			DbSelectArea("SX3")
			dbSetOrder(1)
			IncProc("Atualizando Gatilhos...") //
		EndIf
	EndIf
	dbSelectArea("SX7")
Next i      
If lSX7
	cTexto := 'Incluidos novos Gatilhos. Verifique as suas configuracoes e funcionalidades : '+"SX7"+CHR(13)+CHR(10)
EndIF
Return(cTexto)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IFAtuSXB ³ Autor ³Marcos Favaro           ³ Data ³04/05/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SXB                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IFAtuSXB()
Local aSXB   	:= {}
Local aEstrut	:= {}
Local cAlias	:= ""
Local cTexto	:= ""
Local i      	:= 0
Local j      	:= 0
Local lSXB		:= .F.

aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consultas                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aadd(aSXB,{"SA2ZB5","1","01","DB","Fornecedores","Fornecedores","Fornecedores","SA2"})
Aadd(aSXB,{"SA2ZB5","2","01","01","Codigo + Loja","Codigo + Loja","Codigo + Loja",""})
Aadd(aSXB,{"SA2ZB5","2","02","02","Razao Social + Loja","Razao Social + Loja","Razao Social + Loja",""})
Aadd(aSXB,{"SA2ZB5","4","01","01","Filial","Filial","Filial","A2_FILIAL"})
Aadd(aSXB,{"SA2ZB5","4","01","02","Codigo","Codigo","Codigo","A2_COD"})
Aadd(aSXB,{"SA2ZB5","4","01","03","Loja","Loja","Loja","A2_LOJA"})
Aadd(aSXB,{"SA2ZB5","4","01","04","Razao Social","Razao Social","Razao Social","A2_NOME"})
Aadd(aSXB,{"SA2ZB5","4","01","05","CGC/CPF","CGC/CPF","CGC/CPF","A2_CGC"})
Aadd(aSXB,{"SA2ZB5","4","02","01","Filial","Filial","Filial","A2_FILIAL"})
Aadd(aSXB,{"SA2ZB5","4","02","02","Razao Social","Razao Social","Razao Social","A2_NOME"})
Aadd(aSXB,{"SA2ZB5","4","02","03","Codigo","Codigo","Codigo","A2_COD"})
Aadd(aSXB,{"SA2ZB5","4","02","04","Loja","Loja","Loja","A2_LOJA"})
Aadd(aSXB,{"SA2ZB5","4","02","05","CGC/CPF","CGC/CPF","CGC/CPF","A2_CGC"})
Aadd(aSXB,{"SA2ZB5","5","01",""  ,""       ,""       ,""       ,"SA2->A2_COD"})
Aadd(aSXB,{"SA2ZB5","5","03",""  ,""       ,""       ,""       ,"SA2->A2_LOJA"})
Aadd(aSXB,{"SA2ZB5","5","04",""  ,""       ,""       ,""       ,"SA2->A2_NOME"})
Aadd(aSXB,{"SA2ZB5","5","05",""  ,""       ,""       ,""       ,"SA2->A2_CGC"})
Aadd(aSXB,{"SA2ZB5","6","01",""  ,""       ,""       ,""       ,"SA2->A2_MSBLQL <> '1' "})


Aadd(aSXB,{"SA1ZB5","1","01","DB","Clientes","Clientes","Clientes","SA1"})
Aadd(aSXB,{"SA1ZB5","2","01","01","Codigo + Loja","Codigo + Loja","Codigo + Loja",""})
Aadd(aSXB,{"SA1ZB5","2","02","02","Razao Social + Loja","Razao Social + Loja","Razao Social + Loja",""})
Aadd(aSXB,{"SA1ZB5","4","01","01","Filial","Filial","Filial","A1_FILIAL"})
Aadd(aSXB,{"SA1ZB5","4","01","02","Codigo","Codigo","Codigo","A1_COD"})
Aadd(aSXB,{"SA1ZB5","4","01","03","Loja","Loja","Loja","A1_LOJA"})
Aadd(aSXB,{"SA1ZB5","4","01","04","Razao Social","Razao Social","Razao Social","A1_NOME"})
Aadd(aSXB,{"SA1ZB5","4","01","05","CGC/CPF","CGC/CPF","CGC/CPF","A1_CGC"})
Aadd(aSXB,{"SA1ZB5","4","02","01","Filial","Filial","Filial","A1_FILIAL"})
Aadd(aSXB,{"SA1ZB5","4","02","02","Razao Social","Razao Social","Razao Social","A1_NOME"})
Aadd(aSXB,{"SA1ZB5","4","02","03","Codigo","Codigo","Codigo","A1_COD"})
Aadd(aSXB,{"SA1ZB5","4","02","04","Loja","Loja","Loja","A1_LOJA"})
Aadd(aSXB,{"SA1ZB5","4","02","05","CGC/CPF","CGC/CPF","CGC/CPF","A1_CGC"})
Aadd(aSXB,{"SA1ZB5","5","01",""  ,""       ,""       ,""       ,"SA1->A1_COD"})
Aadd(aSXB,{"SA1ZB5","5","02",""  ,""       ,""       ,""       ,"SA1->A1_LOJA"})
Aadd(aSXB,{"SA1ZB5","5","04",""  ,""       ,""       ,""       ,"SA1->A1_NOME"})
Aadd(aSXB,{"SA1ZB5","5","05",""  ,""       ,""       ,""       ,"SA1->A1_CGC"})
Aadd(aSXB,{"SA1ZB5","6","01",""  ,""       ,""       ,""       ,"SA1->A1_MSBLQL <> '1' "})



Aadd(aSXB,{"SB1ZB5","1","01","DB","Produto + Descricao","Produto + Descricao","Produto + Descricao","SB1"})
Aadd(aSXB,{"SB1ZB5","2","01","01","Codigo","Codigo","Codigo",""})
Aadd(aSXB,{"SB1ZB5","2","02","03","Descricao + Codigo","Descricao + Codigo","Descricao + Codigo",""})
Aadd(aSXB,{"SB1ZB5","4","01","01","Filial","Filial","Filial","B1_FILIAL"})
Aadd(aSXB,{"SB1ZB5","4","01","02","Codigo","Codigo","Codigo","B1_COD"})
Aadd(aSXB,{"SB1ZB5","4","01","03","Descricao","Descricao","Descricao","B1_DESC"})
Aadd(aSXB,{"SB1ZB5","4","02","01","Filial","Filial","Filial","B1_FILIAL"})
Aadd(aSXB,{"SB1ZB5","4","02","02","Descricao","Descricao","Descricao","B1_DESC"})
Aadd(aSXB,{"SB1ZB5","4","02","03","Codigo","Codigo","Codigo","B1_COD"})
Aadd(aSXB,{"SB1ZB5","5","02",""  ,"","","","SB1->B1_COD"})
Aadd(aSXB,{"SB1ZB5","5","03",""  ,"","","","SB1->B1_DESC"})
Aadd(aSXB,{"SB1ZB5","6","01",""  ,"","","","SB1->B1_MSBLQL <> '1'"})




Aadd(aSXB,{"SA2PRN","1","01","DB","Fornecedores","Fornecedores","Fornecedores","SA2"})
Aadd(aSXB,{"SA2PRN","2","01","01","Codigo + Loja","Codigo + Loja","Codigo + Loja",""})
Aadd(aSXB,{"SA2PRN","2","02","02","Razao Social + Loja","Razao Social + Loja","Razao Social + Loja",""})
Aadd(aSXB,{"SA2PRN","4","01","01","Filial","Filial","Filial","A2_FILIAL"})
Aadd(aSXB,{"SA2PRN","4","01","02","Codigo","Codigo","Codigo","A2_COD"})
Aadd(aSXB,{"SA2PRN","4","01","03","Loja","Loja","Loja","A2_LOJA"})
Aadd(aSXB,{"SA2PRN","4","01","04","Razao Social","Razao Social","Razao Social","A2_NOME"})
Aadd(aSXB,{"SA2PRN","4","01","05","CGC/CPF","CGC/CPF","CGC/CPF","A2_CGC"})
Aadd(aSXB,{"SA2PRN","4","02","01","Filial","Filial","Filial","A2_FILIAL"})
Aadd(aSXB,{"SA2PRN","4","02","02","Razao Social","Razao Social","Razao Social","A2_NOME"})
Aadd(aSXB,{"SA2PRN","4","02","03","Codigo","Codigo","Codigo","A2_COD"})
Aadd(aSXB,{"SA2PRN","4","02","04","Loja","Loja","Loja","A2_LOJA"})
Aadd(aSXB,{"SA2PRN","4","02","05","CGC/CPF","CGC/CPF","CGC/CPF","A2_CGC"})
Aadd(aSXB,{"SA2PRN","5","01",""  ,""       ,""       ,""       ,"SA2->A2_COD"})
//Aadd(aSXB,{"SA2PRN","5","02",""  ,""       ,""       ,""       ,"SA2->A2_LOJA"})
//Aadd(aSXB,{"SA2PRN","5","04",""  ,""       ,""       ,""       ,"SA2->A2_NOME"})
//Aadd(aSXB,{"SA2PRN","5","05",""  ,""       ,""       ,""       ,"SA2->A2_CGC"})
Aadd(aSXB,{"SA2PRN","6","01",""  ,""       ,""       ,""       ,"SA2->A2_MSBLQL <> '1' .AND.  SA2->A2_CGC == cCnpj "})


Aadd(aSXB,{"SA2XCG","1","01","DB","Fornecedores","Fornecedores","Fornecedores","SA2"})
Aadd(aSXB,{"SA2XCG","2","01","03","CPF/CNPJ","CPF/CNPJ","CPF/CNPJ",""})
Aadd(aSXB,{"SA2XCG","2","02","01","Codigo + Loja","Codigo + Loja","Codigo + Loja",""})
Aadd(aSXB,{"SA2XCG","2","03","02","Razao Social + Loja","Razao Social + Loja","Razao Social + Loja",""})
Aadd(aSXB,{"SA2XCG","4","01","01","Filial","Filial","Filial","A2_FILIAL"})
Aadd(aSXB,{"SA2XCG","4","01","02","CGC/CPF","CGC/CPF","CGC/CPF","A2_CGC"})
Aadd(aSXB,{"SA2XCG","4","01","03","Codigo","Codigo","Codigo","A2_COD"})
Aadd(aSXB,{"SA2XCG","4","01","04","Loja","Loja","Loja","A2_LOJA"})
Aadd(aSXB,{"SA2XCG","4","01","05","Razao Social","Razao Social","Razao Social","A2_NOME"})
Aadd(aSXB,{"SA2XCG","4","02","01","Filial","Filial","Filial","A2_FILIAL"})
Aadd(aSXB,{"SA2XCG","4","02","02","Codigo","Codigo","Codigo","A2_COD"})
Aadd(aSXB,{"SA2XCG","4","02","03","Loja","Loja","Loja","A2_LOJA"})
Aadd(aSXB,{"SA2XCG","4","02","04","Razao Social","Razao Social","Razao Social","A2_NOME"})
Aadd(aSXB,{"SA2XCG","4","02","05","CGC/CPF","CGC/CPF","CGC/CPF","A2_CGC"})
Aadd(aSXB,{"SA2XCG","4","03","01","Filial","Filial","Filial","A2_FILIAL"})
Aadd(aSXB,{"SA2XCG","4","03","02","Razao Social","Razao Social","Razao Social","A2_NOME"})
Aadd(aSXB,{"SA2XCG","4","03","03","CGC/CPF","CGC/CPF","CGC/CPF","A2_CGC"})
Aadd(aSXB,{"SA2XCG","4","03","04","Codigo","Codigo","Codigo","A2_COD"})
Aadd(aSXB,{"SA2XCG","4","03","05","Loja","Loja","Loja","A2_LOJA"})
Aadd(aSXB,{"SA2XCG","5","01",""  ,""       ,""       ,""       ,"SA2->A2_CGC"})


Aadd(aSXB,{"SA1PRN","1","01","DB","Clientes","Clientes","Clientes","SA1"})
Aadd(aSXB,{"SA1PRN","2","01","01","Codigo + Loja","Codigo + Loja","Codigo + Loja",""})
Aadd(aSXB,{"SA1PRN","2","02","02","Razao Social + Loja","Razao Social + Loja","Razao Social + Loja",""})
Aadd(aSXB,{"SA1PRN","4","01","01","Filial","Filial","Filial","A1_FILIAL"})
Aadd(aSXB,{"SA1PRN","4","01","02","Codigo","Codigo","Codigo","A1_COD"})
Aadd(aSXB,{"SA1PRN","4","01","03","Loja","Loja","Loja","A1_LOJA"})
Aadd(aSXB,{"SA1PRN","4","01","04","Razao Social","Razao Social","Razao Social","A1_NOME"})
Aadd(aSXB,{"SA1PRN","4","01","05","CGC/CPF","CGC/CPF","CGC/CPF","A1_CGC"})
Aadd(aSXB,{"SA1PRN","4","02","01","Filial","Filial","Filial","A1_FILIAL"})
Aadd(aSXB,{"SA1PRN","4","02","02","Razao Social","Razao Social","Razao Social","A1_NOME"})
Aadd(aSXB,{"SA1PRN","4","02","03","Codigo","Codigo","Codigo","A1_COD"})
Aadd(aSXB,{"SA1PRN","4","02","04","Loja","Loja","Loja","A1_LOJA"})
Aadd(aSXB,{"SA1PRN","4","02","05","CGC/CPF","CGC/CPF","CGC/CPF","A1_CGC"})
Aadd(aSXB,{"SA1PRN","5","01",""  ,""       ,""       ,""       ,"SA1->A1_COD"})
//Aadd(aSXB,{"SA1PRN","5","02",""  ,""       ,""       ,""       ,"SA1->A1_LOJA"})
//Aadd(aSXB,{"SA1PRN","5","04",""  ,""       ,""       ,""       ,"SA1->A1_NOME"})
//Aadd(aSXB,{"SA1PRN","5","05",""  ,""       ,""       ,""       ,"SA1->A1_CGC"})
Aadd(aSXB,{"SA1PRN","6","01",""  ,""       ,""       ,""       ,"SA1->A1_MSBLQL <> '1' .AND.  SA1->A1_CGC == cCnpj "})




ProcRegua(Len(aSXB))

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aSXB)
	If !Empty(aSXB[i][1])
		If !dbSeek(PADR(aSXB[i,1],Len(SXB->XB_ALIAS))+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
			lSXB := .T.
			RecLock("SXB",.T.)
			
			If !(aSXB[i,1]$cAlias)
				cAlias += aSXB[i,1]+"/"
			Endif
			
			For j:=1 To Len(aSXB[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Consultas Padroes...")
		EndIf
	EndIf
Next i

If lSXB
	cTexto := 'Foram incluídas as seguintes consultas padrão : '+cAlias+CHR(13)+CHR(10)
EndIf
Return(cTexto)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³ Marcos Favaro        ³ Data ³04/05/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MyOpenSM0Ex()

Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit
	EndIf
	Sleep( 500 )
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
EndIf

Return( lOpen )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProxOrdem ºAutor  ³Marcos Favaro       º Data ³  04/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica a proxima ordem no SX3 para criacao de novos camposº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Sigafis                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProxOrdem(cTabela,cOrdem)
Local aOrdem	:= {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","W","Y","Z"}
Local cProxOrdem:= ""
Local nX		:= 0
Local aAreaSX3 := SX3->(GetArea())

Default cOrdem	:= ""

// Verificando a ultima ordem utilizada
If Empty(cOrdem)
	dbSelectArea("SX3")
	dbSetOrder(1)
	If MsSeek(cTabela)
		Do While SX3->X3_ARQUIVO == cTabela .And. !SX3->(Eof())
			cOrdem := SX3->X3_ORDEM
			SX3->(dbSkip())
		Enddo
	Else
		cOrdem := "00"
	EndIf
Endif

// Criando a nova ordem para o cadastro do novo campo
If Val(SubStr(cOrdem,2,1)) < 9
	cProxOrdem 	:= SubStr(cOrdem,1,1) + Str((Val(SubStr(cOrdem,2,1))+1),1)
Else
	For nX := 1 To Len(aOrdem)
		If aOrdem[nX] == SubStr(cOrdem,1,1)
			Exit
		Endif
	Next
	cProxOrdem 	:= aOrdem[nX+1] + "0"
Endif

SX3->(RestArea(aAreaSX3))
Return cProxOrdem


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IFAtuXML  ³ Autor ³Roberto Souza          ³ Data ³12/04/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de compatibilização das tabelas do Importa XML      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IFAtuXML()
Local cInfo := ""
Local nRet  := 0
Local cTab1 := "ZBZ"
Local cTab2 := "ZB5" 
Local cQuery:= ""

nRetAtu := U_MyAviso("Atencao!","Deseja executar o compatibilizador de registros das tabelas  : "+CRLF+;
				cTab1 + " (Xmls Importados)"+CRLF+; 
				cTab2 + " (Amarração Produto X Fornecedor)",;
				{"Ok","Cancelar"},3)
				
If nRet == 1
	cInfo:= "Compatibilizador de registros iniciado."+CRLF 
	SincTabXML(@cInfo)
//	SIncTabDP(@cInfo)              
Else
	cInfo:= "Compatibilizador de registros cancelado."+CRLF
EndIf				
				            

Return(cInfo)   

Static Function SincTabXML()
Local lRet      := .F.
Local cTab1     := "ZBZ"
Local cTab2     := "ZB5" 
Local cAliasZBZ := GetNextAlias()
Local cQuery    := ""
Local nCont     := 0
Local cInfo     := ""

	cQuery := " UPDATE "+RetSqlName(cTab1)
	cQuery += " SET ZBZ_MODELO='55' "
	cQuery += " WHERE ZBZ_MODELO='' AND ZBZ_FILIAL='"+xFilial(cTab1)+"'"
	If !(TCIsConnected())
	     MsgAlert("Você precisa abrir uma conexão com o banco de dados")
	EndIf    

  	If (TCSqlExec(cQuery) < 0)
    	cInfo+= TCSQLError()+CRLF
	Else
	    cInfo+= " Registros atualizados."  +CRLF 
	    lRet := .T.   	
	EndIf
 
Return(cInfo)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TabelaZBB ³ Autor ³ Eneo                  ³ Data ³11/02/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Parâmetro para Tabela Pedido Recorrente                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao COM                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TabelaZBB( cTab3, cPrf3 )
Local aArea  := GetArea()
Local lRet   := .T.
Local aSX6   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX6	 := .F.
Local cAlias := ''

aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}

AADD(aSx6,{space(len(SX6->X6_FIL)),"XM_TABREC"  ,"C","Tabela de Fornecedores com Pedido Recorrente","","",""                     ,"","",""                         ,"","","   ","   ","   ","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If !dbSeek(aSX6[i,1]+aSX6[i,2])
			lSX6	:= .T.
			If !(aSX6[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
				EndIf
			Next j

			dbCommit()
			MsUnLock()
			IncProc("Atualizando Parametros das Tabelas...") //
		EndIf
	EndIf
Next i

cTab3 := AllTrim( GetNewPar("XM_TABREC" ,"") )

//Se não estiver parâmetro Pedir na Tela
If Empty( cTab3 )
	lRet := TelaTabela( @cTab3 )
	if lRet
		PutMv("XM_TABREC" , cTab3 )
	endif
EndIf

if empty(cTab3)
	cPrf3 := ""
else
	cPrf3 := iif(Substr(cTab3,1,1)=="S", Substr(cTab3,2,2), Substr(cTab3,1,3)) + "_"
endif

RestArea(aArea)
Return( lRet )


Static Function TelaTabela( cTab3 )
Local lRet := .T.
Local aWhen := {.F.,.F.}
Local oDlg

if empty( cTab3 )
	cTab3 := "   "
	aWhen[1] := .T.
endif

DO While .T.

	DEFINE MSDIALOG oDlg TITLE "Tabela P/ Pedido Recorrente ("+SM0->M0_CODIGO+"-"+alltrim(SM0->M0_NOME)+")" FROM 000,000 TO 200,350 PIXEL

	@ 010,010 Say "Tabela Pedido Recorrente (exemplo: ZBB)" SIZE 310,230 PIXEL OF oDlg
	@ 010,130 Get oTab1 VAR cTab3 When aWhen[1] SIZE 30,08 PIXEL OF oDlg

	@ 075,090 BUTTON "OK" SIZE 30,15 PIXEL OF oDlg ACTION oDlg:End()
	@ 075,130 BUTTON "Cancela" SIZE 30,15 PIXEL OF oDlg ACTION ( lRet:=.F.,oDlg:End() )

	ACTIVATE MSDIALOG oDlg CENTERED

	if !( lRet )
		if AllTrim( GetNewPar("XM_PEDREC" ,"N") ) == "S"
			if U_MyAviso("Aviso","O Parametro XM_PEDREC (Ped Recorrente) está Ativado.",{"Sair","Voltar"},1) == 2
				Loop
			endif
		else
			lRet := .T.
		endif
		cTab3 := ""
		Exit
	endif

	dbSelectArea( "SX2" )
	dbSetOrder(1)
	If SX2->( DbSeek( cTab3 ) ) .and. aWhen[1]
		U_MyAviso("Aviso","Tabela "+cTab3+" (Ped.Recorrente) já é utilizada pelo seu sistema.",{"Ok"},1)
		Loop
	EndIf
	
	Exit

EndDo

Return( lRet )



Static Function hfPESQPICT(cArq,cCampo)
Local cRet := ""
Local aArea := GetArea()

DbSelectArea( "SX3" )
DbSetOrder( 2 )
DbSeek( cCampo )
Do While .NOT. SX3->( Eof() ) .And. AllTrim(SX3->X3_CAMPO) == cCampo
	if SX3->X3_ARQUIVO == cArq
		cRet := SX3->X3_PICTURE
		Exit
	EndIf
	SX3->( dbSkip() )
EndDo

DbSetOrder( 1 )
RestArea( aArea )
Return cRet


Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_UPDIF001()
	EndIF
Return(lRecursa)