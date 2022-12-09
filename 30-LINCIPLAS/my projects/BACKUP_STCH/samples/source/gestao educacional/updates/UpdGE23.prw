#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdGE23    ³Autor  ³ Leandro Duarte       ³ Data ³ 26/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados para contemplacao da	  ³±±
±±³          ³ rotinas de melhorias nos relatorios Ficha de matricula     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdGE23()
Local cMsg := ""

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionários e base de dados para "
cMsg += "implementar a melhoria de disciplinas externas do relatorio Ficha de Matricula    "+Chr(13)+Chr(10)+Chr(13)+Chr(10)
cMsg += "Esta rotina deve ser processada em modo exclusivo! "+Chr(13)+Chr(10)+Chr(13)+Chr(10)
cMsg += "Faça um backup dos dicionários e base de dados antes do processamento!"

oMainWnd := MSDIALOG():Create()
oMainWnd:cName := "oMainWnd"
oMainWnd:cCaption := "Implementando ..."
oMainWnd:nLeft := 0
oMainWnd:nTop := 0
oMainWnd:nWidth := 640
oMainWnd:nHeight := 460
oMainWnd:lShowHint := .F.
oMainWnd:lCentered := .T.
oMainWnd:bInit := {|| if( Aviso( "Atualizador de Base", cMsg, {"Cancelar", "Prosseguir"}, 3 ) == 2 , ( Processa({|lEnd| GEProc(@lEnd)} , "Atualizador de Base" ) , oMainWnd:End() ), ( MsgAlert( "Operaçao cancelada!" ), oMainWnd:End() ) ) }

oMainWnd:Activate()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEProc    ³ Autor ³Cristina Souza        ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEProc(lEnd)
Local cTexto    := '' 				//Exibira o log ao final do processo
Local cFile     :="" 				//Nome do arquivo, caso o usuario deseje salvar o log das operacoes
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local nI        := 0                //Contador para laco
Local nX        := 0	            //Contador para laco
Local aRecnoSM0 := {}
Local lOpen     := .F. 				//Retorna se conseguiu acesso exclusivo a base de dados
Local nModulo	:= 49 				//SIGAGE - GESTAO EDUCACIONAL

/********************************************************************************************
Inicia o processamento.
********************************************************************************************/
IncProc("Verificando integridade dos dicionários....")

If ( lOpen := MyOpenSm0Ex() )
	
	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
		If ( nI := Ascan( aRecnoSM0, {|x| x[2] == M0_CODIGO} ) ) == 0 //--So adiciona no aRecnoSM0 se a empresa for diferente
			aAdd(aRecnoSM0,{Recno(),M0_CODIGO,{}})
			nI := Len(aRecnoSM0)
		EndIf
		
		aAdd( aRecnoSM0[nI,3], SM0->M0_CODFIL )
		
		dbSkip()
	EndDo
	
	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			lMsFinalAuto := .F.
			
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
			
			ProcRegua( nI)
			IncProc("Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Elimina do SX o que deve ser eliminado.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Limpando Dicionários")
			cTexto += "Limpando Dicionários..."+CHR(13)+CHR(10)
			GELimpaSX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Limpando Dicionários")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos")
			cTexto += "Analisando Dicionario de Arquivos..."+CHR(13)+CHR(10)
			GEAtuSX2()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")
			cTexto += "Analisando Dicionario de Dados..."+CHR(13)+CHR(10)
			GEAtuSX3()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os parametros.        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Parametros")
			cTexto += "Analisando Parametros..."+CHR(13)+CHR(10)
			GEAtuSX6()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Parametros")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Gatilhos")
			cTexto += "Analisando Gatilhos..."+CHR(13)+CHR(10)
			GEAtuSX7()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Gatilhos")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Indices")
			cTexto += "Analisando arquivos de índices. "+CHR(13)+CHR(10)
			GEAtuSIX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Indices")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Consultas  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Consultas Padroes")
			cTexto += "Analisando consultas padroes..."+CHR(13)+CHR(10)
			GEAtuSxB( SM0->M0_CODIGO )
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Consultas Padroes")
			
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx])
				cTexto += "Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]"+CHR(13)+CHR(10)
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
				IncProc( dtoc( Date() )+" "+Time()+" "+"Fim Atualizando Estruturas "+aArqUpd[nx])
			Next nX
			
			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Retirando registros deletados dos dicionarios...")
			SIX->( Pack() )
			SX2->( Pack() )
			SX3->( Pack() )
			SX6->( Pack() )
			SX7->( Pack() )
			SXB->( Pack() )
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios...")
			
			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas")
			
			dbSelectArea("JA2")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Consultas SX5 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Consultas Padroes")
			cTexto += "Analisando consultas genericas..."+CHR(13)+CHR(10)
			GEAtuSx5( XFILIAL("SX5") )
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Consultas Padroes")
			
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			
		Next nI
		
		If lOpen
			
			IncProc( dtoc( Date() )+" "+Time()+" "+"Atualização Concluída." )
			
			cTexto := "Log da Atualização "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualizacao Concluída." From 3,0 to 340,417 PIXEL
			@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont
			DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
			
		EndIf
		
	EndIf
	
EndIf

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX2  ³ Autor ³Leandro Duarte        ³ Data ³ 07/Dez/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX2 - Arquivos      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX2()
Local aSX2   := {}							//Array que contem as informacoes das tabelas
Local aEstrut:= {}							//Array que contem a estrutura da tabela SX2
Local i      := 0							//Contador para laco
Local j      := 0							//Contador para laco
Local cAlias := ''     						//Nome da tabela
Local cPath									//String para caminho do arquivo
Local cNome									//String para nome da empresa e filial
Local cModo

aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_UNICO","X2_PYME"}

ProcRegua(Len(aSX2))

dbSelectArea("SX2")
SX2->(DbSetOrder(1))
MsSeek("JAH") //Seleciona a tabela que eh padrao do sistema para pegar algumas informacoes
cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)
cModo := SX2->X2_MODO

/******************************************************************************************
* Adiciona as informacoes das tabelas num array, para trabalho posterior
*******************************************************************************************/
/*
aAdd(aSX2,{	"JC7",; 								//Chave
cPath,;									//Path
"JC7"+cNome,;							//Nome do Arquivo
"Itens Alocacao do Aluno",;				//Nome Port
"Itens Alocacao do Aluno",;				//Nome Port
"Itens Alocacao do Aluno",;				//Nome Port
0,;										//Delete
cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
"",;									//TTS
"",;									//Rotina
"JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SEQ",;				//Unico
"S"})									//Pyme
*/

/*******************************************************************************************
Realiza a inclusao das tabelas
*******************************************/
For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		
		If SX2->( !dbSeek(aSX2[i,1]) )
			RecLock("SX2",.T.) //Adiciona registro
		Else
			RecLock("SX2",.F.) //Altera Registro
		EndIf
		
		If !(aSX2[i,1]$cAlias)
			cAlias += aSX2[i,1]+"/"
		EndIf
		
		For j:=1 To Len(aSX2[i])
			If FieldPos(aEstrut[j]) > 0
				FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
			EndIf
		Next j
		SX2->X2_PATH := cPath
		SX2->X2_ARQUIVO := aSX2[i,1]+cNome
		MsUnLock()
		IncProc("Atualizando Dicionario de Arquivos...")
	EndIf
Next i

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX3  ³ Autor ³Leandro Duarte        ³ Data ³ 07/Dez/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3 - Campos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX3()
Local aSX3			:= {}				//Array com os campos das tabelas
Local aEstrut		:= {}              //Array com a estrutura da tabela SX3
Local i				:= 0				//Laco para contador
Local j				:= 0				//Laco para contador
Local lSX3			:= .F.             //Indica se houve atualizacao
Local cAlias		:= ''				//String para utilizacao do noem da tabela
Local cUsadoKey		:= ''				//String que servira para cadastrar um campo como "USADO" em campos chave
Local cReservKey	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos chave
Local cUsadoObr		:= ''				//String que servira para cadastrar um campo como "USADO" em campos obrigatorios
Local cReservObr	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos obrigatorios
Local cUsadoOpc		:= ''				//String que servira para cadastrar um campo como "USADO" em campos opcionais
Local cReservOpc	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos opcionais
Local cUsadoNao		:= ''				//String que servira para cadastrar um campo como "USADO" em campos fora de uso
Local cReservNao	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos fora de uso
Local cCBoxSit		:= ''

/*******************************************************************************************
Define a estrutura do array
*******************************************/
aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}

dbSelectArea("SX3")
SX3->(DbSetOrder(2))

/*******************************************************************************************
Seleciona as informacoes de alguns campos para uso posterior
*******************************************/
If SX3->( dbSeek("JC7_SITUAC") ) //Este campo eh chave
	cCBoxSit	:= SX3->X3_CBOX
EndIf

If SX3->( dbSeek("JAE_CODIGO") ) //Este campo eh chave
	cUsadoKey	:= SX3->X3_USADO
	cReservKey	:= SX3->X3_RESERV
EndIf

If SX3->( dbSeek("JAE_DESC") ) //Este campo eh obrigatorio e permite alterar
	cUsadoObr	:= SX3->X3_USADO
	cReservObr	:= SX3->X3_RESERV
EndIf

If SX3->( dbSeek("JAE_DISPAI") ) //Este campo eh opcional e permite alterar
	cUsadoOpc	:= SX3->X3_USADO
	cReservOpc	:= SX3->X3_RESERV
EndIf

If SX3->( dbSeek("JAE_FILIAL") ) //Este campo nao eh usado
	cUsadoNao	:= SX3->X3_USADO
	cReservNao	:= SX3->X3_RESERV
EndIf

/*******************************************************************************************
Monta o array com os campos das tabelas/*
*******************************************/

aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_PAIPRO" ),;	//Ordem
"JA2_PAIPRO",;						//Campo
"C",;								//Tipo
40,;									//Tamanho
0,;									//Decimal
"Profiss. Pai",;			    		//Titulo
"Profiss. Pai",;			    		//Titulo
"Profiss. Pai",;			    		//Titulo
"Profissao Pai",;			    		//Titulo
"Profissao Pai",;			    		//Titulo
"Profissao Pai",;			    		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_PAICAR" ),;	//Ordem
"JA2_PAICAR",;						//Campo
"C",;								//Tipo
40,;									//Tamanho
0,;									//Decimal
"Cargo Pai   ",;			    		//Titulo
"Cargo Pai   ",;			    		//Titulo
"Cargo Pai   ",;			    		//Titulo
"Cargo Pai   ",;			    		//Titulo
"Cargo Pai   ",;			    		//Titulo
"Cargo Pai   ",;			    		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_PAILCT" ),;	//Ordem
"JA2_PAILCT",;						//Campo
"C",;								//Tipo
40,;									//Tamanho
0,;									//Decimal
"Local Trab. ",;			    		//Titulo
"Local Trab. ",;			    		//Titulo
"Local Trab. ",;			    		//Titulo
"Local Trab. ",;			    		//Titulo
"Local Trab. ",;			    		//Titulo
"Local Trab. ",;			    		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_PAIFON" ),;		//Ordem
"JA2_PAIFON",;						//Campo
"C",;								//Tipo
20,;									//Tamanho
0,;									//Decimal
"Telefone Pai",;				    		//Titulo
"Telefone Pai",;				    		//Titulo
"Telefone Pai",;				    		//Titulo
"Telefone Pai",;				    		//Titulo
"Telefone Pai",;				    		//Titulo
"Telefone Pai",;				    		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_MAEPRO" ),;	//Ordem
"JA2_MAEPRO",;						//Campo
"C",;								//Tipo
40,;									//Tamanho
0,;									//Decimal
"Profiss. Mae",;				   		//Titulo
"Profiss. Mae",;				   		//Titulo
"Profiss. Mae",;				   		//Titulo
"Profiss. Mae",;	   		//Titulo
"Profiss. Mae",;	   		//Titulo
"Profiss. Mae",;	   		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_MAECAR" ),;	//Ordem
"JA2_MAECAR",;						//Campo
"C",;								//Tipo
40,;									//Tamanho
0,;									//Decimal
"Cargo Mae   ",;				   		//Titulo
"Cargo Mae   ",;				   		//Titulo
"Cargo Mae   ",;				   		//Titulo
"Cargo Mae   ",;				   		//Titulo
"Cargo Mae   ",;				   		//Titulo
"Cargo Mae   ",;				   		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_MAELCT" ),;	//Ordem
"JA2_MAELCT",;						//Campo
"C",;								//Tipo
40,;								//Tamanho
0,;									//Decimal
"Local Trab. ",;			   		//Titulo
"Local Trab. ",;			   		//Titulo
"Local Trab. ",;			   		//Titulo
"Local Trab. da Mae",;		   		//Titulo
"Local Trab. da Mae",;		   		//Titulo
"Local Trab. da Mae",;		   		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_MAEFON" ),;	//Ordem
"JA2_MAEFON",;						//Campo
"C",;								//Tipo
20,;    							//Tamanho
0,;									//Decimal
"Telefone Mae",;			   		//Titulo
"Telefone Mae",;			   		//Titulo
"Telefone Mae",;			   		//Titulo
"Telefone Mae",;			   		//Titulo
"Telefone Mae",;			   		//Titulo
"Telefone Mae",;			   		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_RELIGI" ),;	//Ordem
"JA2_RELIGI",;						//Campo
"C",;								//Tipo
20,;    							//Tamanho
0,;									//Decimal
"Religiao    ",;			   		//Titulo
"Religiao    ",;			   		//Titulo
"Religiao    ",;			   		//Titulo
"Religiao do aluno        ",;  		//Titulo
"Religiao do aluno        ",;  		//Titulo
"Religiao do aluno        ",;  		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
            
aAdd(aSX3,{	"JCL",;								//Arquivo
GetOrdem( "JCL", "JCL_REDESC" ),;	//Ordem
"JCL_REDESC",;						//Campo
"C",;								//Tipo
1,;    							//Tamanho
0,;									//Decimal
"Rede Ensino ",;			   		//Titulo
"Rede Ensino ",;			   		//Titulo
"Rede Ensino ",;			   		//Titulo
"Rede Ensino              ",;  		//Titulo
"Rede Ensino              ",;  		//Titulo
"Rede Ensino              ",;  		//Titulo
"9",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"1=Particular;2=Pública","1=Particular;2=Pública","1=Particular;2=Pública",; //CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME


aAdd(aSX3,{	"JA2",;								//Arquivo
GetOrdem( "JA2", "JA2_NASCMN" ),;	//Ordem
"JA2_NASCMN",;						//Campo
"C",;								//Tipo
20,;    							//Tamanho
0,;									//Decimal
"Municip.Nasc",;			   		//Titulo
"Municip.Nasc",;			   		//Titulo
"Municip.Nasc",;			   		//Titulo
"Municipio de Nascimento  ",;  		//Titulo
"Municipio de Nascimento  ",;  		//Titulo
"Municipio de Nascimento  ",;  		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JAY",;								//Arquivo
GetOrdem( "JAY", "JAY_TIPCOM" ),;	//Ordem
"JAY_TIPCOM",;						//Campo
"C",;								//Tipo
1,;	    							//Tamanho
0,;									//Decimal
"Tipo Comp",;				   		//Titulo
"Tipo Comp",;				   		//Titulo
"Tipo Comp",;				   		//Titulo
"Tipo de Componente",;  		//Titulo
"Tipo de Componente",;  		//Titulo
"Tipo de Componente",;  		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"1=Base Comum;2=Parte Diversificada","1=Base Comum;2=Parte Diversificada","1=Base Comum;2=Parte Diversificada",;//CBOX, CBOX SPA, CBOX ENG
"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JAE",;								//Arquivo
GetOrdem( "JAE", "JAE_DISMES" ),;	//Ordem
"JAE_DISMES",;						//Campo
"C",;								//Tipo
6,;	    							//Tamanho
0,;									//Decimal
"Dis.Mestre",;				   		//Titulo
"Dis.Mestre",;				   		//Titulo
"Dis.Mestre",;				   		//Titulo
"Identif. da Discip. Mestr",;  		//Titulo
"Identif. da Discip. Mestr",;  		//Titulo
"Identif. da Discip. Mestr",;  		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"",;								//RELACAO
"JM",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","S","","","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JAE",;								//Arquivo
GetOrdem( "JAE", "JAE_DESCME" ),;	//Ordem
"JAE_DESCME",;						//Campo
"C",;								//Tipo
50,;    							//Tamanho
0,;									//Decimal
"Desc. Mestre",;			   		//Titulo
"Desc. Mestre",;			   		//Titulo
"Desc. Mestre",;			   		//Titulo
"Descricao Mestre da Disc ",;  		//Titulo
"Descricao Mestre da Disc ",;  		//Titulo
"Descricao Mestre da Disc ",;  		//Titulo
"@!",;								//Picture
"",;								//VALID
cUsadoOpc,;							//USADO
"IIF(INCLUI,TABELA('JM',M->JAE_DISMES,.F.),TABELA('JM',JAE->JAE_DISMES,.F.))",;								//RELACAO
"",;								//F3
1,;									//NIVEL
cReservOpc,;						//RESERV
"","","","","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
"","","",;							//CBOX, CBOX SPA, CBOX ENG
"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

/******************************************************************************************
Grava informacoes do array no banco de dados
******************************************************************************************/
ProcRegua(Len(aSX3))

SX3->(DbSetOrder(2))

For i:= 1 To Len(aSX3)
	
	If !Empty(aSX3[i][1])
		
		If !dbSeek(aSX3[i,3])
			RecLock("SX3",.T.)
		Else
			RecLock("SX3",.F.)
		EndIf
		
		lSX3	:= .T.
		If !(aSX3[i,1]$cAlias)
			cAlias += aSX3[i,1]+"/"
			if aScan(aArqUpd, aSX3[i,1] ) == 0
				aAdd(aArqUpd,aSX3[i,1])
			endif
		EndIf
		
		For j:=1 To Len(aSX3[i])
			If FieldPos(aEstrut[j])>0 .And. aSX3[i,j] != NIL
				FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
			EndIf
		Next j
		MsUnLock()
		IncProc("Atualizando Dicionario de Dados...")
		
	EndIf
Next i

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX6  ³ Autor ³Leandro Duarte        ³ Data ³ 07/Dez/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX6 - Parametros    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX6()

Local aSX6   := {}					//Array que contera os dados dos gatilhos
Local aEstrut:= {}					//Array que contem a estrutura da tabela SX6
Local i      := 0					//Contador para laco
Local j      := 0					//Contador para laco
/*********************************************************************************************
Define a estrutura da tabela SX6
*********************************************************************************************/
aEstrut:= { "X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1",;
"X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA",;
"X6_CONTENG","X6_PROPRI","X6_PYME"}

/*******************************************************************************************
aAdd(aSX6,{	"MV_ACDGHIS",;																//Parametro
"L",;																		//Tipo
"Indica se a inclusao de disciplinas na digitacao do historico",;			//Descricao
"",;																		//Descricao
"",;																		//Descricao
" do aluno deve alterar o curriculo (.T.) ou gerar disciplinas","","",;		//Descricao1,Descricao SPA1, Descricao ENG1
" externas para o aluno (.F.)","","",;										//Descricao2,Descricao SPA2, Descricao ENG2
"F","F","F",;						  										//Conteudo, Conteudo SPA, Conteudo ENG
"S","S"})																	//Propri, PYME
*********************************************************************************************/
/*********************************************************************************************
Realiza a gravacao das informacoes do array na tabela SX6
*********************************************************************************************/
ProcRegua(Len(aSX6))

dbSelectArea("SX6")
SX6->(DbSetOrder(1))
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][1])
		If !DbSeek('  '+aSX6[i,1])
			RecLock("SX6",.T.)
		Else
			RecLock("SX6",.F.)
		Endif
		For j:=1 To Len(aSX6[i])
			If !Empty(FieldName(FieldPos(aEstrut[j])))
				FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
			EndIf
		Next j
		MsUnLock()
		IncProc("Atualizando Parametros...")
	EndIf
Next i

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX7  ³ Autor ³Leandro Duarte        ³ Data ³ 07/Dez/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX7 - Gatilhos      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX7()

Local aSX7   := {}					//Array que contera os dados dos gatilhos
Local aEstrut:= {}					//Array que contem a estrutura da tabela SX7
Local i      := 0					//Contador para laco
Local j      := 0					//Contador para laco
/*********************************************************************************************
Define a estrutura da tabela SX7
*********************************************************************************************/
aEstrut:= { "X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS",;
"X7_ORDEM","X7_CHAVE","X7_CONDIC","X7_PROPRI"}

aAdd(aSX7,{	"JAE_DISMES",;			 												  //Campo
"001",;																	  //Sequencia
"TABELA('JM',JAE_DISMES,.F.)",;											  //Regra
"JAE_DESCME",;      													  //Campo Dominio
"P",;              														  //Tipo
"N",;  																	  //Posiciona?
"",;																	  //Alias
0,;																		  //Ordem do Indice
"",;																	  //Chave
"",;																	  //Condi
"S"})																	  //Proprietario

/*********************************************************************************************
Realiza a gravacao das informacoes do array na tabela SX7
*********************************************************************************************/
ProcRegua(Len(aSX7))

dbSelectArea("SX7")
SX7->(DbSetOrder(1))
For i:= 1 To Len(aSX7)
	If !Empty(aSX7[i][1])
		If !DbSeek(aSX7[i,1]+aSX7[i,2])
			RecLock("SX7",.T.)
		Else
			RecLock("SX7",.F.)
		Endif
		For j:=1 To Len(aSX7[i])
			If !Empty(FieldName(FieldPos(aEstrut[j])))
				FieldPut(FieldPos(aEstrut[j]),aSX7[i,j])
			EndIf
		Next j
		MsUnLock()
		IncProc("Atualizando Gatilhos...")
	EndIf
Next i

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSIX  ³ Autor ³Leandro Duarte        ³ Data ³ 07/Dez/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SIX - Indices       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSIX()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME SHOWPESQ
Local lSix      := .F.                      //Verifica se houve atualizacao
Local aSix      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SiX
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco
Local cAlias    := ''						//Alias para tabelas
Local lDelInd   := .F.

/*********************************************************************************************
Define estrutura do array
*********************************************************************************************/
aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3",;
"NICKNAME","SHOWPESQ"}
/********************************************************************************************
aAdd(aSIX,{	"JD1",;   										//Indice
"2",;                 								//Ordem
"JD1_FILIAL+JD1_NUMRA+JD1_CODCUR+JD1_PERLET+JD1_HABILI+JD1_DISCIP",;		//Chave
"Numero RA + Cod.Curso + Per. Letivo + Habilitacao + Disciplina",;			//Descicao Port.
"Numero RA + Cod.Curso + Per. Letivo + Habilitacao + Disciplina",;			//Descicao Port.
"Numero RA + Cod.Curso + Per. Letivo + Habilitacao + Disciplina",;			//Descicao Port.
"S",; 												//Proprietario
"",;  												//F3
"",;  												//NickName
"S"}) 												//ShowPesq
***********************************************************************************************/

/*********************************************************************************************
Grava as informacoes do array na tabela six
*********************************************************************************************/
ProcRegua(Len(aSIX))

dbSelectArea("SIX")
SIX->(DbSetOrder(1))

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,1])
		If !DbSeek(aSIX[i,1]+aSIX[i,2])
			RecLock("SIX",.T.)
			lDelInd := .F.
		Else
			RecLock("SIX",.F.)
			lDelInd := .T. //Se for alteracao precisa apagar o indice do banco
		EndIf
		
		If UPPER(AllTrim(CHAVE)) != UPPER(Alltrim(aSIX[i,3]))
			if aScan(aArqUpd, aSIX[i,1]) == 0
				aAdd(aArqUpd,aSIX[i,1])
			endif
			
			lSix := .T.
			If !(aSIX[i,1]$cAlias)
				cAlias += aSIX[i,1]+"/"
			EndIf
			For j:=1 To Len(aSIX[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
				EndIf
			Next j
			MsUnLock()
			If lDelInd
				TcInternal(60,RetSqlName(aSix[i,1]) + "|" + RetSqlName(aSix[i,1]) + aSix[i,2]) //Exclui sem precisar baixar o TOP
			Endif
		EndIf
		IncProc("Atualizando índices...")
	EndIf
Next i

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSXB  ³Autora ³Leandro Duarte         ³ Data ³07/Dez/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para atualização das consultas padroes do sistema   ³±±
±±³          ³ para quando o cliente for utilizar visibilidade            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSXB(cCodFilial)
Local lSXB      := .F.                      //Verifica se houve atualizacao
Local aSXB      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SXB
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define estrutura do array³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEstrut:= {"XB_ALIAS", "XB_TIPO", "XB_SEQ", "XB_COLUNA", "XB_DESCRI", "XB_DESCSPA", "XB_DESCENG", "XB_CONTEM", "XB_WCONTEM"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os novos conteudos dos filtros das consultas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
aAdd(aSXB,{	"JBL001","1","01","RE",;		// ALIAS, TIPO, SEQ, COLUNA
"Selecione a sub-turma",;		// DESCRI
"Selecione a sub-turma",;		// DESCRI
"Selecione a sub-turma",;		// DESCRI
"JBL", "" })				// CONTEM, WCONTEM

aAdd(aSXB,{	"JBL001","2","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
"",;						// DESCRI
"",;						// DESCRI
"",;						// DESCRI
"AC670SelSub()", "" })		// CONTEM, WCONTEM

aAdd(aSXB,{	"JBL001","5","01","",;		// ALIAS, TIPO, SEQ, COLUNA
"",;						// DESCRI
"",;						// DESCRI
"",;						// DESCRI
"M->JCS_SUBTUR", "" })			// CONTEM, WCONTEM
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa consultas para alteracao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(Len(aSXB))

dbSelectArea("SXB")
SXB->(dbSetOrder(1)) //XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA
For i := 1 To Len(aSXB)
	If !DbSeek(PadR(aSXB[i,1],6)+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
		RecLock("SXB",.T.)
	Else
		RecLock("SXB",.F.)
	EndIf
	lSxB := .T.
	For j:=1 To Len(aSXB[i])
		If FieldPos(aEstrut[j]) > 0
			FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
		EndIf
	Next j
	MsUnLock()
	IncProc("Atualizando consulta padrao...")
Next i

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX5  ³Autora ³Leandro Duarte         ³ Data ³25/JAN/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para atualização das consultas padroes do sistema   ³±±
±±³          ³ para quando o cliente for utilizar visibilidade            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX5(cCodFilial)
Local aSX5      := {}						//Array que armazenara os indices
Local i         := 0 						//Contador para laco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os novos conteudos dos filtros das consultas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aSX5,{	cCodFilial, "00", "JM",;		// FILIAL, TABELA, CHAVE
"DISCIPLINAS MESTRES DA EDUCACAO BASICA",;		// DESCRI
"DISCIPLINAS MESTRES DA EDUCACAO BASICA",;		// DESCRI
"DISCIPLINAS MESTRES DA EDUCACAO BASICA" })		// DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000001",;				// FILIAL, TABELA, CHAVE
"PORTUGUES","PORTUGUES","PORTUGUES"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000002",;				// FILIAL, TABELA, CHAVE
"MATEMATICA","MATEMATICA","MATEMATICA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000003",;				// FILIAL, TABELA, CHAVE
"FISICA","FISICA","FISICA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000004",;				// FILIAL, TABELA, CHAVE
"HISTORIA","HISTORIA","HISTORIA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000005",;				// FILIAL, TABELA, CHAVE
"GEOGRAFIA","GEOGRAFIA","GEOGRAFIA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000006",;				// FILIAL, TABELA, CHAVE
"QUIMICA","QUIMICA","QUIMICA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000007",;				// FILIAL, TABELA, CHAVE
"LINGUA INGLESA","LINGUA INGLESA","LINGUA INGLESA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000008",;				// FILIAL, TABELA, CHAVE
"EDUCACAO FISICA","EDUCACAO FISICA","EDUCACAO FISICA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000009",;				// FILIAL, TABELA, CHAVE
"BIOLOGIA","BIOLOGIA","BIOLOGIA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000010",;				// FILIAL, TABELA, CHAVE
"FILOSOFIA","FILOSOFIA","FILOSOFIA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000011",;				// FILIAL, TABELA, CHAVE
"SOCIOLOGIA","SOCIOLOGIA","SOCIOLOGIA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000012",;				// FILIAL, TABELA, CHAVE
"INFORMATICA","INFORMATICA","INFORMATICA"})		// DESCRI, DESCRI, DESCRI

aAdd(aSX5,{	cCodFilial, "JM", "000013",;				// FILIAL, TABELA, CHAVE
"EDUCACAO ARTISTICA","EDUCACAO ARTISTICA","EDUCACAO ARTISTICA"})		// DESCRI, DESCRI, DESCRI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa consultas para alteracao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(Len(aSX5))

dbSelectArea("SX5")
SX5->(dbSetOrder(1)) //X5_ALIAS+X5_TBELA+X5_CHAVE
For i := 1 To Len(aSX5)
	If !DbSeek(PadR(aSX5[i,1],2)+aSX5[i,2]+aSX5[i,3])
		RecLock("SX5",.T.)
	Else
		RecLock("SX5",.F.)
	EndIf
	SX5->X5_FILIAL	:=	aSX5[i,1]
	SX5->X5_TABELA	:=	aSX5[i,2]
	SX5->X5_CHAVE	:=	aSX5[i,3]
	SX5->X5_DESCRI	:=	aSX5[i,4]
	SX5->X5_DESCSPA	:=	aSX5[i,5]
	SX5->X5_DESCENG	:=	aSX5[i,6]
	MsUnLock()
	IncProc("Atualizando consulta padrao...")
Next i

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0Ex()

Local lOpen := .F.
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GELimpaSX ³ Autor ³Leandro Duarte      ³ Data ³ 07/Dez/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Elimina dados do dicionario antes da atualizacao            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GELimpaSX()
Local i
Local aDelSX2	:= {}
Local aDelSIX	:= {}
Local aDelSXB	:= {}
Local aDelSX3	:= {}
Local aDelSX6	:= {}

SX2->( dbSetOrder(1) )
for i := 1 to len( aDelSX2 )
	if SX2->( dbSeek( aDelSX2[i] ) )
		TCSQLExec("DROP INDEX "+RetSQLName(aDelSX2[i])+"."+RetSQLName(aDelSX2[i])+"_UNQ")
		RecLock( "SX2", .F. )
		SX2->( dbDelete() )
		SX2->( msUnlock() )
	endif
next i

SXB->( dbSetOrder(1) )
for i := 1 to len( aDelSXB )
	while SXB->( dbSeek( aDelSXB[i] ) )
		RecLock( "SXB", .F. )
		SXB->( dbDelete() )
		SXB->( msUnlock() )
	end
next i

SX3->( dbSetOrder(2) )
for i := 1 to len( aDelSX3 )
	if SX3->( dbSeek( aDelSX3[i] ) )
		RecLock( "SX3", .F. )
		SX3->( dbDelete() )
		SX3->( msUnlock() )
	endif
next i

SIX->( dbSetOrder(1) )
for i := 1 to len( aDelSIX )
	if SIX->( dbSeek( aDelSIX[i] ) )
		RecLock( "SIX", .F. )
		SIX->( dbDelete() )
		SIX->( msUnlock() )
	endif
next i

SX6->( dbSetOrder(1) )
for i := 1 to len( aDelSX6 )
	if SX6->(dbSeek( aDelSX6[i] ) )
		RecLock( "SX6", .F. )
		SX6->( dbDelete() )
		SX6->( msUnlock() )
	endif
next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetOrdem  ºAutor  ³Cristina Souza      º Data ³ 26/Set/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca a ordem que deve ser usada para atualizacao de campos º±±
±±º          ³no SX3.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AtuSX3                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetOrdem( cAlias, cCampo )
Local cRet

SX3->( dbSetOrder(2) )
if SX3->( dbSeek( cCampo ) )
	cRet := SX3->X3_ORDEM
else
	SX3->( dbSetOrder(1) )
	SX3->( dbSeek( cAlias ) )
	while SX3->( !eof() .and. X3_ARQUIVO == cAlias )
		cRet := SX3->X3_ORDEM
		SX3->( dbSkip() )
	end
	
	cRet := Soma1( cRet )
endif

Return cRet
