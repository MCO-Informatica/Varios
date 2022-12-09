#INCLUDE "Protheus.ch"        
#INCLUDE "Fileio.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdGe30    ³Autor  ³ Renato Ceadareanu    ³ Data ³ 03/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados                         ³±±
±±³          ³ para contemplar a melhoria do Bops 128748                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGE                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
User function UpdGe30()
Local cMsg := ""         

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd          

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionários e base de dados "
cMsg += "para a implementação da melhoria relacionada a estornos de requerimentos "
cMsg += "Esta rotina deve ser processada em modo exclusivo! "
cMsg += "Faça um backup dos dicionários e base de dados antes do processamento!" 

oMainWnd := MSDIALOG():Create()
oMainWnd:cName := "oMainWnd"
oMainWnd:cCaption := "Implementando Estorno de requerimentos"
oMainWnd:nLeft := 0
oMainWnd:nTop := 0
oMainWnd:nWidth := 640
oMainWnd:nHeight := 460
oMainWnd:lShowHint := .F.
oMainWnd:lCentered := .T.
oMainWnd:bInit := {|| if( Aviso( "Atualizador de Base", cMsg, {"Cancelar", "Prosseguir"}, 2 ) == 2 , ( Processa({|lEnd| GEProc(@lEnd)} , "Atualizador de Base" ) , oMainWnd:End() ), ( MsgAlert( "Operaçao cancelada!" ), oMainWnd:End() ) ) }

oMainWnd:Activate()
	
Return
                                                                                                                                                                           
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEProc    ³ Autor ³Renato Ceadareanu     ³ Data ³ 03/10/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEProc(lEnd)
Local cTexto    := '' 				//Exibira o log ao final do processo
Local cTextoAux	:= ""
Local cFile     :="" 				//Nome do arquivo, caso o usuario deseje salvar o log das operacoes
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local nI        := 0                //Contador para laco
Local nX        := 0	            //Contador para laco
Local aRecnoSM0 := {}			
Local lOpen     := .F. 				//Retorna se conseguiu acesso exclusivo a base de dados
Local nModulo	:= 49 				//SIGAGE - GESTAO EDUCACIONAL
       
Private cArquivo   	:= "UpdGE30.LOG"
Private cErros   	:= "UpdErr.LOG"

/********************************************************************************************
Inicia o processamento.
********************************************************************************************/
IncProc("Verificando integridade dos dicionários....")
Conout("Verificando integridade dos dicionários....")

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
   //		For nI := 1 To Len(aRecnoSM0)
			
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2) 
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			lMsFinalAuto := .F.

			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua( nI)
			IncProc("Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME)			
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos"+CHR(13)+CHR(10)

			cTexto += "Analisando Dicionario de Arquivos..."+CHR(13)+CHR(10)
			GEAtuSX2()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos"+CHR(13)+CHR(10)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			cTexto += "Analisando Dicionario de Dados..."+CHR(13)+CHR(10)
			GEAtuSX3()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados")              
			cTextoAux +=dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados"+CHR(13)+CHR(10)
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Indices")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Indices" +CHR(13)+CHR(10)
			cTexto += "Analisando arquivos de índices. "+CHR(13)+CHR(10)
			GEAtuSIX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Indices")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Fim - Indices" +CHR(13)+CHR(10)
			
			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Retirando registros deletados dos dicionarios...")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Retirando registros deletados dos dicionarios..." +CHR(13)+CHR(10)

		  //	SIX->( Pack() )
		//	SX2->( Pack() )
		 //	SX3->( Pack() )
			
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios...")
			cTextoAux +=  dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios..." +CHR(13)+CHR(10)

			cTextoAux := ""
			RpcClearEnv()
			
	   //	Next nI 
		
		If lOpen

			IncProc( dtoc( Date() )+" "+Time()+" "+"Atualização Concluída." )
			Conout( dtoc( Date() )+" "+Time()+" "+"Atualização Concluída." )
			
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
	End if  
End if
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

aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG",;
			"X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_UNICO","X2_PYME"}

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

aAdd(aSX2,{	"JHT",; 										//Chave
			cPath,	;											//Path
			"JHT"+cNome,;									//Nome do Arquivo
			"Movimentacoes de alunos",;				//Nome Port
			"Movimentacoes de alunos",;				//Nome Port
			"Movimentacoes de alunos",;				//Nome Port
			0,;														//Delete
			"C",;													//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;													//TTS
			"",;													//Rotina
			"JHT_FILIAL+JHT_NUM",;						//Unico
			"S"})													//Pyme
			
aAdd(aSX2,{	"JHU",; 								//Chave
			cPath,;									//Path
			"JHU"+cNome,;							//Nome do Arquivo
			"Itens movimentacoes de alunos",;		//Nome Port
			"Itens movimentacoes de alunos",;		//Nome Port
			"Itens movimentacoes de alunos",;		//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHU_FILIAL+JHU_NUM+JHU_CODDIS",;		//Unico
			"S"})									//Pyme
			
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
		Conout("Atualizando Dicionario de Arquivos...")
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
Local aSX3           := {}				//Array com os campos das tabelas
Local aEstrut        := {}              //Array com a estrutura da tabela SX3
Local i              := 0			   		//Laco para contador
Local j              := 0				//Laco para contador
Local lSX3	         := .F.             //Indica se houve atualizacao
Local cAlias         := ''				//String para utilizacao do noem da tabela
Local cUsadoKey		 := ''				//String que servira para cadastrar um campo como "USADO" em campos chave
Local cReservKey	 := ''				//String que servira para cadastrar um campo como "Reservado" em campos chave
Local cUsadoObr		 := ''				//String que servira para cadastrar um campo como "USADO" em campos obrigatorios
Local cReservObr	 := ''				//String que servira para cadastrar um campo como "Reservado" em campos obrigatorios
Local cUsadoOpc		 := ''				//String que servira para cadastrar um campo como "USADO" em campos opcionais
Local cReservOpc	 := ''				//String que servira para cadastrar um campo como "Reservado" em campos opcionais
Local cUsadoNao		 := ''				//String que servira para cadastrar um campo como "USADO" em campos fora de uso
Local cReservNao	 := ''				//String que servira para cadastrar um campo como "Reservado" em campos fora de uso

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


/*******************************************************************************************
Monta o array com os campos das tabelas/*
*******************************************************************************************/

aAdd(aSX3,{	"JHT",;								//Arquivo
			"01",;								//Ordem
			"JHT_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;					   		//Titulo SPA
			"Filial",;		    				//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"02",;								//Ordem
			"JHT_NUM",;							//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Num.Controle",;					//Titulo
			"Num.Controle",;					//Titulo SPA
			"Num.Controle",;		    		//Titulo ENG
			"Num.Controle",;					//Descricao
			"Num.Controle",;					//Descricao SPA
			"Num.Controle",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHT",;								//Arquivo
			"03",;								//Ordem
			"JHT_TIPO",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Tp.Operacao",;					    //Titulo
			"Tp.Operacao",;					   	//Titulo SPA
			"Tp.Operacao",;		    			//Titulo ENG
			"Tp.Operacao",;						//Descricao
			"Tp.Operacao",;						//Descricao SPA
			"Tp.Operacao",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	
						
aAdd(aSX3,{	"JHT",;								//Arquivo
			"04",;								//Ordem
			"JHT_NUMRA",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"05",;								//Ordem
			"JHT_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"",;								//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"06",;								//Ordem
			"JHT_PERLET",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	 
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"07",;								//Ordem
			"JHT_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME   
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"08",;								//Ordem
			"JHT_TURMA",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"@!",;									//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME   
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"09",;								//Ordem
			"JHT_SEQ",;							//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"10",;								//Ordem
			"JHT_DATA",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"11",;								//Ordem
			"JHT_HORA",;						//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME      
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"12",;								//Ordem
			"JHT_USER",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"13",;								//Ordem
			"JHT_NUMREQ",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"14",;								//Ordem
			"JHT_MEMO1",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME    
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"15",;								//Ordem
			"JHT_OBSERV",;						//Campo
			"M",;								//Tipo
			80,;								//Tamanho
			0,;									//Decimal
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME     
			
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"16",;								//Ordem
			"JHT_CURDES",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME     
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"17",;								//Ordem
			"JHT_PERDES",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME   
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"18",;								//Ordem
			"JHT_HABDES",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME         
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"19",;								//Ordem
			"JHT_TURDES",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME    
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"20",;								//Ordem
			"JHT_BEATIV",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME    
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"21",;								//Ordem
			"JHT_BESITU",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"22",;								//Ordem
			"JHT_BETIPO",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME     
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"23",;								//Ordem
			"JHT_DATAES",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"24",;								//Ordem
			"JHT_HORAES",;						//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"25",;								//Ordem
			"JHT_USERES",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"01",;								//Ordem
			"JHU_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME       
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"02",;								//Ordem
			"JHU_NUM",;							//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Num.Controle",;					//Titulo
			"Num.Controle",;					//Titulo SPA
			"Num.Controle",;			    	//Titulo ENG
			"Num.Controle",;					//Descricao
			"Num.Controle",;					//Descricao SPA
			"Num.Controle",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"03",;								//Ordem
			"JHU_CODDIS",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Disciplina",;						//Titulo
			"Disciplina",;						//Titulo SPA
			"Disciplina",;			    		//Titulo ENG
			"Disciplina",;						//Descricao
			"Disciplina",;						//Descricao SPA
			"Disciplina",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"04",;								//Ordem
			"JHU_SEQDIS",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Seq.Oper.Dis",;					//Titulo
			"Seq.Oper.Dis",;					//Titulo SPA
			"Seq.Oper.Dis",;			    	//Titulo ENG
			"Seq.Oper.Dis",;					//Descricao
			"Seq.Oper.Dis",;					//Descricao SPA
			"Seq.Oper.Dis",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME      
			
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"05",;								//Ordem
			"JHU_C7SITD",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Sit.Mat.Disc",;					//Titulo
			"Sit.Mat.Disc",;					//Titulo SPA
			"Sit.Mat.Disc",;			    	//Titulo ENG
			"Sit.Mat.Disc",;					//Descricao
			"Sit.Mat.Disc",;					//Descricao SPA
			"Sit.Mat.Disc",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME      
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"06",;								//Ordem
			"JHU_C7SITU",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Sit.Final",;						//Titulo
			"Sit.Final",;						//Titulo SPA
			"Sit.Final",;			    		//Titulo ENG
			"Sit.Final",;						//Descricao
			"Sit.Final",;						//Descricao SPA
			"Sit.Final",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME      
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"07",;								//Ordem
			"JHU_C7MEDF",;						//Campo
			"N",;								//Tipo
			5,;									//Tamanho
			0,;									//Decimal
			"Media Ant.",;						//Titulo
			"Media Ant.",;						//Titulo SPA
			"Media Ant.",;			    		//Titulo ENG
			"Media Ant.",;						//Descricao
			"Media Ant.",;						//Descricao SPA
			"Media Ant.",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"08",;								//Ordem
			"JHU_C7MEDC",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Media Conse",;						//Titulo
			"Media Conse",;						//Titulo SPA
			"Media Conse",;			    		//Titulo ENG
			"Media Conse",;						//Descricao
			"Media Conse",;						//Descricao SPA
			"Media Conse",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME         
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"09",;								//Ordem
			"JHU_C7DMEC",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Desc. Conse",;						//Titulo
			"Desc. Conse",;						//Titulo SPA
			"Desc. Conse",;			    		//Titulo ENG
			"Desc. Conse",;						//Descricao
			"Desc. Conse",;						//Descricao SPA
			"Desc. Conse",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"10",;								//Ordem
			"JHU_C7CINS",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Instituicao",;						//Titulo
			"Instituicao",;						//Titulo SPA
			"Instituicao",;			    		//Titulo ENG
			"Instituicao",;						//Descricao
			"Instituicao",;						//Descricao SPA
			"Instituicao",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"11",;								//Ordem
			"JHU_C7AINS",;						//Campo
			"C",;								//Tipo
			20,;								//Tamanho
			0,;									//Decimal
			"Ano Concl",;						//Titulo
			"Ano Concl",;						//Titulo SPA
			"Ano Concl",;			    		//Titulo ENG
			"Ano Concl",;						//Descricao
			"Ano Concl",;						//Descricao SPA
			"Ano Concl",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME   
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"12",;								//Ordem
			"JHU_C7TPCU",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Tipo Curso",;					    //Titulo
			"Tipo Curso",;					   	//Titulo SPA
			"Tipo Curso",;		    			//Titulo ENG
			"Tipo Curso",;						//Descricao
			"Tipo Curso",;						//Descricao SPA
			"Tipo Curso",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHU",;								//Arquivo
			"13",;								//Ordem
			"JHU_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;						//Titulo
			"Componente",;						//Titulo SPA
			"Componente",;			    		//Titulo ENG
			"Componente",;						//Descricao
			"Componente",;						//Descricao SPA
			"Componente",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
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
		Conout("Atualizando Dicionario de Dados...")

	EndIf
	
Next i
		
Return (.T.)

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
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .T., .F. )
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