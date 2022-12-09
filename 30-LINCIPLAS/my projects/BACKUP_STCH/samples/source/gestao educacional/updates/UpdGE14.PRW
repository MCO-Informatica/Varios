#INCLUDE "Protheus.ch" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdGE14    ³Autor  ³ Bruno Lopes Malafaia ³ Data ³ 21/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados para contemplacao da	  ³±±
±±³          ³ rotinas de melhorias do projeto SENAI                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdGE14()

Local cMsg := ""

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionários e base de dados "
cMsg += "para a implementação da melhoria de subturma na grade de aulas diária."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
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
±±³Fun‡…o    ³GEProc    ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
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
            
            //Atualiza indices e chave unica existentes nas tabelas                                 
			AtuBase()
			
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

			dbSelectArea("JBL")
			dbSelectArea("JD2")
			dbSelectArea("JCQ")            

			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			

			
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 
			
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
±±³Fun‡…o    ³GEAtuSX2  ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX2 - Arquivos      ³±± 
±±³          ³ Adiciona as tabelas para regra de visibilidade             ³±± 
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
±±³Fun‡…o    ³GEAtuSX3  ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
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
Local cOrdem		:= ''
Local nPos			:= 0         

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

/******************************************
³ Monta o array com os campos das tabelas ³
*****************************************/
SX3->(DbSetOrder(1))

SX3->( dbSeek("JBL") )
while SX3->( !eof() .and. X3_ARQUIVO == "JBL" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JBL_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JBL",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JBL_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JBE") )
while SX3->( !eof() .and. X3_ARQUIVO == "JBE" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JBE_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JBE",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JBE_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JC7") )
while SX3->( !eof() .and. X3_ARQUIVO == "JC7" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JC7_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JC7",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JC7_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JBR") )
while SX3->( !eof() .and. X3_ARQUIVO == "JBR" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JBR_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JBR",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JBR_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"ACA290Alu( .T. )",;				//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","S","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","INCLUI","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JCS") )
while SX3->( !eof() .and. X3_ARQUIVO == "JCS" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JCS_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JCS",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JCS_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"AC670VlSub()",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JCG") )
while SX3->( !eof() .and. X3_ARQUIVO == "JCG" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JCG_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JCG",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JCG_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"AC590Aula() .and. ACA590ALU(.t.)",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","INCLUI","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JDB") )
while SX3->( !eof() .and. X3_ARQUIVO == "JDB" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JDB_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	If Alltrim(SX3->X3_CAMPO)== "JDB_ATIVID"
		nPos := Val(SX3->X3_ORDEM)
	EndIf   
	If nPos > 0 .and. Val(SX3->X3_ORDEM) >= nPos
		Reclock("SX3",.F.)
		SX3->X3_ORDEM := Soma1(cOrdem)
		SX3->(MsUnLock()) 
	EndIf	
	
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JDB",;								//Arquivo
			StrZero(nPos,2),;						//Ordem
			"JDB_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"AC760Chav()",;						//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","INCLUI","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JCV") )
while SX3->( !eof() .and. X3_ARQUIVO == "JCV" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JCV_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JCV",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JCV_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSetOrder(1) )
SX3->( dbSeek("JD2") )
while SX3->( !eof() .and. X3_ARQUIVO == "JD2" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JD2_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JD2",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JD2_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"AC180VlSbT()",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JAU") )
While SX3->( !eof() .and. X3_ARQUIVO == "JAU" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JAU_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
End

aAdd(aSX3,{	"JAU",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JAU_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JCQ") )
While SX3->( !eof() .and. X3_ARQUIVO == "JCQ" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JCQ_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
End

aAdd(aSX3,{	"JCQ",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JCQ_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 

SX3->( dbSeek("JDA") )
While SX3->( !eof() .and. X3_ARQUIVO == "JDA" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JDA_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
End 
			
aAdd(aSX3,{	"JDA",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JDA_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JD9") )
While SX3->( !eof() .and. X3_ARQUIVO == "JD9" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JD9_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
End 
			
aAdd(aSX3,{	"JD9",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JD9_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"AC750Chav()",;						//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JCX") )
While SX3->( !eof() .and. X3_ARQUIVO == "JCX" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JCX_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
End 
			
aAdd(aSX3,{	"JCX",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JCX_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"",;						//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->( dbSeek("JCW") )
while SX3->( !eof() .and. X3_ARQUIVO == "JCW" )
    If .NOT. ALLTRIM(SX3->X3_CAMPO) == "JCW_SUBTUR"
		cOrdem := SX3->X3_ORDEM
	EndIf
	SX3->( dbSkip() )
end

aAdd(aSX3,{	"JCW",;								//Arquivo
			Soma1(cOrdem),;						//Ordem
			"JCW_SUBTUR",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"Sub-Turma",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
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
±±³Fun‡…o    ³GEAtuSX6  ³ Autor ³Bruno Paulinelli      ³ Data ³ 07/Jul/06 ³±±
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
±±³Fun‡…o    ³GEAtuSX7  ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
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

aAdd(aSX7,{	"JBR_SUBTUR",;			 												  				//Campo
			"001",;																	  				//Sequencia
			"JBL->JBL_MATPRF",;														  				//Regra
			"JBR_MATPRF",;      													  				//Campo Dominio
			"P",;              														  				//Tipo
			"S",;  																	  				//Posiciona?
			"JBL",;																	  				//Alias
			16,;																		  			//Ordem do Indice
			'xFilial("JBL")+M->(JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_SUBTUR+JBR_CODDIS)',;//Chave
			"!Empty(M->JBR_SUBTUR)",;												 				//Condição
			"S"})																	 				//Proprietario

aAdd(aSX7,{	"JBR_SUBTUR",;			 			//Campo
			"002",;								//Sequencia
			"SRA->RA_NOME",;					//Regra
			"JBR_NOME",;	      				//Campo Dominio
			"P",;              					//Tipo
			"S",;  								//Posiciona?
			"SRA",;								//Alias
			1,;									//Ordem do Indice
			'xFilial("SRA")+M->JBR_MATPRF',;	//Chave
			"!Empty(M->JBR_SUBTUR)",;			//Condição
			"S"})								//Proprietario


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
±±³Fun‡…o    ³GEAtuSIX  ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
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

aAdd(aSIX,{	"JBL",;   										   													  //Indice
			"F",;                 							   													  //Ordem
			"JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_DIASEM+JBL_CODDIS+JBL_SUBTUR+JBL_MATPRF",; //Chave
			"Cod.Curso+ Per. Let.+ Habil. +Turma +Dia Sem. +Sub-Turma + Mat. Prof.",;		                      //Descicao Port.
			"Cod.Curso+ Per. Let.+ Habil. +Turma +Dia Sem. +Sub-Turma + Mat. Prof.",;			                  //Descicao Port.
			"Cod.Curso+ Per. Let.+ Habil. +Turma +Dia Sem. +Sub-Turma + Mat. Prof.",;		                	  //Descicao Port.
			"S",; 																								  //Proprietario
			"",;  																								  //F3
			"",;  																								  //NickName
			"S"}) 												                                                  //ShowPesq  
			
aAdd(aSIX,{	"JBL",;   										   													  //Indice
			"G",;                 							   													  //Ordem
			"JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_SUBTUR+JBL_CODDIS",; //Chave
			"Cod.Curso+Per. Letivo+Habilitacao+Turma+Sub-Turma+Cod. Discip",;		        //Descicao Port.
			"Cod.Curso+Per. Lectivo+Habilitacion+Grupo+Sub Grupo+Cod. Materia",;		    //Descicao Esp.
			"Course Code+School Year+Qualificat.+Class+Sub Class+Subj. Code",;		        //Descicao Ing.
			"S",; 																		    //Proprietario
			"",;  																			//F3
			"",;  																			//NickName
			"S"}) 												                            //ShowPesq  

aAdd(aSIX,{	"JD2",;   																					//Indice
			"3",;                 																		//Ordem
			"JD2_FILIAL+JD2_CODCUR+JD2_PERLET+JD2_HABILI+JD2_TURMA+JD2_DIASEM+JD2_AULA+JD2_SUBTUR",;	//Chave
			"Cod.Curso + Per. Letivo + Habilitacao + Turma + Dia Semana + Sub-Turma ",;					//Descicao Port.
			"Cod.Curso + Per. Letivo + Habilitacao + Turma + Dia Semana + Sub-Turma ",;					//Descicao Port.
			"Cod.Curso + Per. Letivo + Habilitacao + Turma + Dia Semana + Sub-Turma ",;					//Descicao Port.
			"S",; 																						//Proprietario
			"",;  																						//F3
			"",;  																						//NickName
			"S"}) 																						//ShowPesq    
			
SX3->( dbSetOrder(2) )
If SX3->( dbSeek("JDA_SUBTUR") )		
	aAdd(aSIX,{"JDA",;   										//Indice
	   		"6",;                 								//Ordem
			"JDA_FILIAL+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_SUBTUR+JDA_ATIVID",;//Chave
			"Cod.Curso + Per. Letivo + Habilitacao + Turma + Cod.Discip + Cod. Avali + Cod. Subturma + Ativid",;//Descicao Port.
			"Cod.Curso + Per. Letivo + Habilitacao + Turma + Cod.Discip + Cod. Avali + Cod. Subturma + Ativid",;//Descicao Port.	
			"Cod.Curso + Per. Letivo + Habilitacao + Turma + Cod.Discip + Cod. Avali + Cod. Subturma + Ativid",;//Descicao Port.
			"S",; 												//Proprietario
			"",;  												//F3
			"",;  												//NickName
			"S"}) 												//ShowPesq  
Endif

If SX3->( dbSeek("JC7_SUBTUR") )		
	aAdd(aSIX,{"JC7",;   										//Indice
	   		"E",;                 								//Ordem
			"JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_SUBTUR",;//Chave
			"Numero RA+Cod.Curso+Per. Letivo+Habilitacao+Turma+Sub-Turma",;//Descicao Port.
			"Numero RA+Cod.Curso+Per. Letivo+Habilitacao+Turma+Sub-Turma",;//Descicao Port.	
			"Numero RA+Cod.Curso+Per. Letivo+Habilitacao+Turma+Sub-Turma",;//Descicao Port.
			"S",; 												//Proprietario
			"",;  												//F3
			"",;  												//NickName
			"S"}) 												//ShowPesq  
Endif
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
±±³Fun‡…o    ³GEAtuSXB  ³Autora ³Solange Zanardi        ³ Data ³02/Dez/05 ³±±
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

If Select("SM0") == 0
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
Else
	lOpen := .T. 
EndIf
	
Return( lOpen )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GELimpaSX ³ Autor ³Rafael Rodrigues    ³ Data ³ 01/Fev/2006 ³±±
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
Local aDelSIX	:= {"JBLF","JD23"}
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
		TCSQLExec("DROP INDEX "+RetSQLName(aDelSIX[i])+"."+RetSQLName(aDelSIX[i])+SIX->ORDEM )
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |AtuBase   ³ Autor ³Karen Honda         ³ Data ³ 29/out/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza os indices 1 e chave unica no banco de dados       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
            
Static Function AtuBase()
                
Local lItem     := JCG->( FieldPos("JCG_ITEM") ) > 0
Local lSeq      := JC7->( FieldPos("JC7_SEQ") ) > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Troca a chave da tabela JD9 para subturma                                       		  		  ³
//³De: JD9_FILIAL+JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA        		  |                               ³
//³Para: JD9_FILIAL+JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA+JD9_SUBTUR   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX3->(dbSetOrder(2))
If SX3->( dbSeek("JD9_SUBTUR") )
	if SX2->( dbSeek("JD9") ) .and. .NOT. Alltrim(SX2->X2_UNICO) == "JD9_FILIAL+JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA+JD9_SUBTUR"
		if Select("JD9") > 0
			JD9->( dbCloseArea() )
		endif
		// So atualiza se conseguir acesso exclusivo a tabela
		if ChkFile("JD9",.T.)
			RecLock("SX2",.F.)
			SX2->X2_UNICO := "JD9_FILIAL+JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA+JD9_SUBTUR"
			SX2->( msUnlock() )
		
			// Fecha a Tabela para manipular o INDICE
			JD9->( dbCloseArea() )
		
			// Apaga e Recria INDICE no DATABASE
			TcSqlExec( "DROP INDEX "+RetSqlName("JD9")+"."+RetSQLName("JD9")+"_UNQ" )
			TcSqlExec( "CREATE INDEX "+RetSQLName("JD9")+"_UNQ ON "+RetSQLName("JD9")+" ( JD9_FILIAL,JD9_CODCUR,JD9_PERLET,JD9_HABILI,JD9_TURMA,JD9_CODDIS,JD9_CODAVA,JD9_SUBTUR, R_E_C_D_E_L_ )" )
			TCSQLExec( "commit" )
		endif
	
		// Reabre a Tabela em modo compartilhado
		ChkFile("JD9",.F.)
	EndIf	
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Troca a chave da tabela JBR para subturma                                       		  		  ³
//³De: JBR_FILIAL+JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA        		  |                               ³
//³Para: JBR_FILIAL+JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA+JBR_SUBTUR   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( dbSeek("JBR_SUBTUR") )
	if SX2->( dbSeek("JBR") ) .and. .NOT. Alltrim(SX2->X2_UNICO) == "JBR_FILIAL+JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA+JBR_SUBTUR"
		if Select("JBR") > 0
			JBR->( dbCloseArea() )
		endif
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JBR",.T.)
			RecLock("SX2",.F.)
			SX2->X2_UNICO := "JBR_FILIAL+JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA+JBR_SUBTUR"
			SX2->( msUnlock() )
		
			// Fecha a Tabela para manipular o INDICE
			JBR->( dbCloseArea() )
		
			// Apaga e Recria INDICE no DATABASE
			TcSqlExec( "DROP INDEX "+RetSqlName("JBR")+"."+RetSQLName("JBR")+"_UNQ" )
			TcSqlExec( "CREATE INDEX "+RetSQLName("JBR")+"_UNQ ON "+RetSQLName("JBR")+" ( JBR_FILIAL,JBR_CODCUR,JBR_PERLET,JBR_HABILI,JBR_TURMA,JBR_CODDIS,JBR_CODAVA,JBR_SUBTUR, R_E_C_D_E_L_ )" )
			TCSQLExec( "commit" )
		endif
	
		// Reabre a Tabela em modo compartilhado
		ChkFile("JBR",.F.)
	EndIf	
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona campo de sub-turma na chave 1 da JBR³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( dbSeek("JBR_SUBTUR") )
	SIX->( dbSetOrder(1) )
	if SIX->( dbSeek("JBR1") ) .and. .NOT. Alltrim(SIX->CHAVE) == "JBR_FILIAL+JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA+JBR_SUBTUR"
		if Select("JBR") > 0
			JBR->( dbCloseArea() )
		endif
		
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JBR",.T.)
			RecLock("SIX",.F.)
			SIX->CHAVE := "JBR_FILIAL+JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA+JBR_SUBTUR"
			SIX->( msUnlock() )
			
			// FECHA A TABELA PARA MANIPULAR O INDICE
			JBR->( dbCloseArea() )
			
			// APAGA E RECRIA INDICE NO DATABASE COM NOVO CAMPO
			TcSqlExec( "DROP INDEX "+RetSqlName("JBR")+"."+RetSQLName("JBR")+"1" )
			TcSqlExec( "CREATE INDEX "+RetSQLName("JBR")+"1 ON "+RetSQLName("JBR")+" ( JBR_FILIAL, JBR_CODCUR, JBR_PERLET, JBR_HABILI, JBR_TURMA, JBR_CODDIS, JBR_CODAVA, JBR_SUBTUR, R_E_C_N_O_, D_E_L_E_T_ )" )
			TCSQLExec( "commit" )
		endif
		
		// REABRE A TABELA EM MODO COMPARTILHADO
		ChkFile("JBR",.F.)
	endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Troca a chave da tabela JDB para subturma                                       		  		  			  ³
//³De: JDB_FILIAL+JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID        		  |                               ³
//³Para:JDB_FILIAL+JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID+JDB_SUBTUR     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( dbSeek("JDB_SUBTUR") )
	if SX2->( dbSeek("JDB") ) .and. .NOT. Alltrim(SX2->X2_UNICO) == "JDB_FILIAL+JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID+JDB_SUBTUR"
		if Select("JDB") > 0
			JBR->( dbCloseArea() )
		endif
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JDB",.T.)
			RecLock("SX2",.F.)
			SX2->X2_UNICO := "JDB_FILIAL+JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID+JDB_SUBTUR"
			SX2->( msUnlock() )
		
			// Fecha a Tabela para manipular o INDICE
			JDB->( dbCloseArea() )
		
			// Apaga e Recria INDICE no DATABASE
			TcSqlExec( "DROP INDEX "+RetSqlName("JDB")+"."+RetSQLName("JDB")+"_UNQ" )
			TcSqlExec( "CREATE INDEX "+RetSQLName("JDB")+"_UNQ ON "+RetSQLName("JDB")+" ( JDB_FILIAL,JDB_CODCUR,JDB_PERLET,JDB_HABILI,JDB_TURMA,JDB_CODDIS,JDB_CODAVA,JDB_ATIVID,JDB_SUBTUR, R_E_C_D_E_L_ )" )
			TCSQLExec( "commit" )
		endif
	
		// Reabre a Tabela em modo compartilhado
		ChkFile("JDB",.F.)
	EndIf	
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona campo de sub-turma na chave 1 da JDB³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( dbSeek("JDB_SUBTUR") )
	SIX->( dbSetOrder(1) )
	if SIX->( dbSeek("JDB1") ) .and. .NOT. Alltrim(SIX->CHAVE) == "JDB_FILIAL+JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID+JDB_SUBTUR"
		if Select("JDB") > 0
			JDB->( dbCloseArea() )
		endif
		
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JDB",.T.)
			RecLock("SIX",.F.)
			SIX->CHAVE := "JDB_FILIAL+JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID+JDB_SUBTUR"
			SIX->( msUnlock() )
			
			// FECHA A TABELA PARA MANIPULAR O INDICE
			JDB->( dbCloseArea() )
			
			// APAGA E RECRIA INDICE NO DATABASE COM NOVO CAMPO
			TcSqlExec( "DROP INDEX "+RetSqlName("JDB")+"."+RetSQLName("JDB")+"1" )
			TcSqlExec( "CREATE INDEX "+RetSQLName("JDB")+"1 ON "+RetSQLName("JDB")+" ( JDB_FILIAL, JDB_CODCUR, JDB_PERLET, JDB_HABILI, JDB_TURMA, JDB_CODDIS, JDB_CODAVA, JDB_ATIVID, JDB_SUBTUR, R_E_C_N_O_, D_E_L_E_T_ )" )
			TCSQLExec( "commit" )
		endif
		
		// REABRE A TABELA EM MODO COMPARTILHADO
		ChkFile("JDB",.F.)
	endif
endif
           
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona campo de sub-turma na chave 1 da JD9³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( dbSeek("JD9_SUBTUR") )
	SIX->( dbSetOrder(1) )
	if SIX->( dbSeek("JD91") ) .and. .NOT. Alltrim(SIX->CHAVE) == "JD9_FILIAL+JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA+JD9_SUBTUR"
		if Select("JD9") > 0
			JD9->( dbCloseArea() )
		endif
		
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JD9",.T.)
			RecLock("SIX",.F.)
			SIX->CHAVE := "JD9_FILIAL+JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA+JD9_SUBTUR"
			SIX->( msUnlock() )
			
			// FECHA A TABELA PARA MANIPULAR O INDICE
			JD9->( dbCloseArea() )
			
			// APAGA E RECRIA INDICE NO DATABASE COM NOVO CAMPO
			TcSqlExec( "DROP INDEX "+RetSqlName("JD9")+"."+RetSQLName("JD9")+"1" )
			TcSqlExec( "CREATE INDEX "+RetSQLName("JD9")+"1 ON "+RetSQLName("JD9")+" ( JD9_FILIAL,JD9_CODCUR,JD9_PERLET,JD9_HABILI,JD9_TURMA,JD9_CODDIS,JD9_CODAVA,JD9_SUBTUR, R_E_C_N_O_, D_E_L_E_T_ )" )
			TCSQLExec( "commit" )			
		endif
		
		// REABRE A TABELA EM MODO COMPARTILHADO
		ChkFile("JD9",.F.)
	endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Troca a chave da tabela JDA para subturma                                       		  		  		   ³
//³De: JDA_FILIAL+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID       	   |
//³Para: JDA_FILIAL+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID+JDA_SUBTUR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( dbSeek("JDA_SUBTUR") )
	if SX2->( dbSeek("JDA") ) .and. .NOT. Alltrim(SX2->X2_UNICO) == "JDA_FILIAL+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID+JDA_SUBTUR"
		if Select("JDA") > 0
			JBA->( dbCloseArea() )
		endif
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JDA",.T.)
			RecLock("SX2",.F.)
			SX2->X2_UNICO := "JDA_FILIAL+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID+JDA_SUBTUR"
			SX2->( msUnlock() )
		
			// Fecha a Tabela para manipular o INDICE
			JDA->( dbCloseArea() )
		
			// Apaga e Recria INDICE no DATABASE
			TcSqlExec( "DROP INDEX "+RetSqlName("JDA")+"."+RetSQLName("JDA")+"_UNQ" )
			TcSqlExec( "CREATE INDEX "+RetSQLName("JDA")+"_UNQ ON "+RetSQLName("JDA")+" ( JDA_FILIAL,JDA_CODCUR,JDA_PERLET,JDA_HABILI,JDA_TURMA,JDA_CODDIS,JDA_CODAVA,JDA_ATIVID,JDA_SUBTUR, R_E_C_D_E_L_ )" )
			TCSQLExec( "commit" )
		endif
	
		// Reabre a Tabela em modo compartilhado
		ChkFile("JDA",.F.)
	EndIf	
endif                                             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona campo de sub-turma na chave 1 da JDA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( dbSeek("JDA_SUBTUR") )
	SIX->( dbSetOrder(1) )
	if SIX->( dbSeek("JDA1") ) .and. .NOT. Alltrim(SIX->CHAVE) == "JDA_FILIAL+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID+JDA_SUBTUR"
		if Select("JDA") > 0
			JDA->( dbCloseArea() )
		endif
		
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JDA",.T.)
			RecLock("SIX",.F.)
			SIX->CHAVE := "JDA_FILIAL+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID+JDA_SUBTUR"
			SIX->( msUnlock() )
			
			// FECHA A TABELA PARA MANIPULAR O INDICE
			JDA->( dbCloseArea() )
			
			// APAGA E RECRIA INDICE NO DATABASE COM NOVO CAMPO
			TcSqlExec( "DROP INDEX "+RetSqlName("JDA")+"."+RetSQLName("JDA")+"1" )
			TcSqlExec( "CREATE INDEX "+RetSQLName("JDA")+"1 ON "+RetSQLName("JDA")+" ( JDA_FILIAL,JDA_CODCUR,JDA_PERLET,JDA_HABILI,JDA_TURMA,JDA_CODDIS,JDA_CODAVA,JDA_ATIVID,JDA_SUBTUR, R_E_C_N_O_, D_E_L_E_T_ )" )
			TCSQLExec( "commit" )
		endif
		
		// REABRE A TABELA EM MODO COMPARTILHADO
		ChkFile("JDA",.F.)
	endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona campo de sub-turma na chave 1 da JCG³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( dbSeek("JCG_SUBTUR") )
	SIX->( dbSetOrder(1) )
	if SIX->( dbSeek("JCG1") ) .and. (.NOT. Alltrim(SIX->CHAVE) == iif(lItem, "JCG_FILIAL+JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+DTOS(JCG_DATA)+JCG_ITEM+JCG_DISCIP+JCG_CODAVA+JCG_SUBTUR", "JCG_FILIAL+JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+DTOS(JCG_DATA)+JCG_DISCIP+JCG_CODAVA+JCG_SUBTUR"))
		if Select("JCG") > 0
			JCG->( dbCloseArea() )
		endif
		
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JCG",.T.)
			RecLock("SIX",.F.)
			if lItem
				SIX->CHAVE := "JCG_FILIAL+JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+DTOS(JCG_DATA)+JCG_ITEM+JCG_DISCIP+JCG_CODAVA+JCG_SUBTUR"
			else
				SIX->CHAVE := "JCG_FILIAL+JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+DTOS(JCG_DATA)+JCG_DISCIP+JCG_CODAVA+JCG_SUBTUR"
			endif
			SIX->( msUnlock() )
			
			// FECHA A TABELA PARA MANIPULAR O INDICE
			JCG->( dbCloseArea() )
			
			// APAGA E RECRIA INDICE NO DATABASE COM NOVO CAMPO
			TcSqlExec( "DROP INDEX "+RetSqlName("JCG")+"."+RetSQLName("JCG")+"1" )
			if lItem
				TcSqlExec( "CREATE INDEX "+RetSQLName("JCG")+"1 ON "+RetSQLName("JCG")+" ( JCG_FILIAL, JCG_CODCUR, JCG_PERLET, JCG_HABILI, JCG_TURMA, JCG_DATA, JCG_ITEM, JCG_DISCIP, JCG_CODAVA, JCG_SUBTUR, R_E_C_N_O_, D_E_L_E_T_ )" )
			else
				TcSqlExec( "CREATE INDEX "+RetSQLName("JCG")+"1 ON "+RetSQLName("JCG")+" ( JCG_FILIAL, JCG_CODCUR, JCG_PERLET, JCG_HABILI, JCG_TURMA, JCG_DATA, JCG_DISCIP, JCG_CODAVA, JCG_SUBTUR, R_E_C_N_O_, D_E_L_E_T_ )" )
			endif
			TCSQLExec( "commit" )
		endif
		
		// REABRE A TABELA EM MODO COMPARTILHADO
		ChkFile("JCG",.F.)
	endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Troca a chave da tabela JC7 para subturma                                       		  		  		                                                               ³
//³De: JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SEQ              |
//³Para: JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SEQ+JC7_SUBTUR ³
//³Adiciona campo de sub-turma na chave 1 da JC7                                                                                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( dbSeek("JC7_SUBTUR") )
	if SX2->( dbSeek("JC7") ) .and. .NOT. Alltrim(SX2->X2_UNICO) == iif(lSeq,	"JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SEQ+JC7_SUBTUR",;	
																				"JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SUBTUR")
		if Select("JC7") > 0
			JC7->( dbCloseArea() )
		endif
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JC7",.T.)
			RecLock("SX2",.F.)
			If lSeq
				SX2->X2_UNICO := "JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SEQ+JC7_SUBTUR"
			Else
				SX2->X2_UNICO := "JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SUBTUR"
			EndIf
			SX2->( msUnlock() )
		
			// FECHA A TABELA PARA MANIPULAR O INDICE
			JC7->( dbCloseArea() )
			
			// Apaga e Recria INDICE no DATABASE
			TcSqlExec( "DROP INDEX "+RetSqlName("JC7")+"."+RetSQLName("JC7")+"_UNQ" )
			If lSeq
				TcSqlExec( "CREATE INDEX "+RetSQLName("JC7")+"_UNQ ON "+RetSQLName("JC7")+" ( JC7_FILIAL,JC7_NUMRA,JC7_CODCUR,JC7_PERLET,JC7_HABILI,JC7_TURMA,JC7_DISCIP,JC7_CODLOC,JC7_CODPRE,JC7_ANDAR,JC7_CODSAL,JC7_DIASEM,JC7_HORA1,JC7_SEQ,JC7_SUBTUR,R_E_C_D_E_L_ )" )
			Else
				TcSqlExec( "CREATE INDEX "+RetSQLName("JC7")+"_UNQ ON "+RetSQLName("JC7")+" ( JC7_FILIAL,JC7_NUMRA,JC7_CODCUR,JC7_PERLET,JC7_HABILI,JC7_TURMA,JC7_DISCIP,JC7_CODLOC,JC7_CODPRE,JC7_ANDAR,JC7_CODSAL,JC7_DIASEM,JC7_HORA1,JC7_SUBTUR,R_E_C_D_E_L_ )" )
			EndIf
			TCSQLExec( "commit" )

		endif
		// Reabre a Tabela em modo compartilhado
		ChkFile("JC7",.F.)
	EndIf	
	
	SIX->( dbSetOrder(1) )
	if SIX->( dbSeek("JC71") ) .and. .NOT. Alltrim(SIX->CHAVE) == iif(lSeq,	"JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SEQ",;	
																				"JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SUBTUR")
		// So atualiza se conseguir acesso exclusivo aa tabela
		if ChkFile("JC7",.T.)
			RecLock("SIX",.F.)
			if lSeq
				SIX->CHAVE := "JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SEQ"
			else
				SIX->CHAVE := "JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SUBTUR"
			endif
			SIX->( msUnlock() )
	
			// FECHA A TABELA PARA MANIPULAR O INDICE
			if Select("JC7") > 0
				JC7->( dbCloseArea() )
			endif
		
			// APAGA E RECRIA INDICE NO DATABASE COM NOVO CAMPO
			TcSqlExec( "DROP INDEX "+RetSqlName("JC7")+"."+RetSQLName("JC7")+"1" )
			If lSeq
				TcSqlExec( "CREATE INDEX "+RetSQLName("JC7")+"1 ON "+RetSQLName("JC7")+" ( JC7_FILIAL,JC7_NUMRA,JC7_CODCUR,JC7_PERLET,JC7_HABILI,JC7_TURMA,JC7_DISCIP,JC7_CODLOC,JC7_CODPRE,JC7_ANDAR,JC7_CODSAL,JC7_DIASEM,JC7_HORA1,JC7_SEQ,R_E_C_D_E_L_ )" )
			Else
				TcSqlExec( "CREATE INDEX "+RetSQLName("JC7")+"1 ON "+RetSQLName("JC7")+" ( JC7_FILIAL,JC7_NUMRA,JC7_CODCUR,JC7_PERLET,JC7_HABILI,JC7_TURMA,JC7_DISCIP,JC7_CODLOC,JC7_CODPRE,JC7_ANDAR,JC7_CODSAL,JC7_DIASEM,JC7_HORA1,JC7_SUBTUR,R_E_C_D_E_L_ )" )
			EndIf
			TCSQLExec( "commit" )
		endif	
		// Reabre a Tabela em modo compartilhado
		ChkFile("JC7",.F.)
	EndIf

endif                                             

REturn
