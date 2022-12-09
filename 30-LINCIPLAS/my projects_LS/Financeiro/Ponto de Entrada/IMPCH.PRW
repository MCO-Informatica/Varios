#include "FINR460.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR460	³ Autor ³ Paulo Boschetti		  ³ Data ³ 09.07.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impress„o de Cheques 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR460(void)															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPCH()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define vari veis 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aCheque[10]
LOCAL nRet
LOCAL cNumCheq
LOCAL cNome 		:= Space(20)
LOCAL lEnd		:=.F.
LOCAL oDlg
LOCAL oCBXImp
Local cRet
Local cBenef := ""
Local nHdl460 := 0
Local nTamArq := 0
Local nLidos  := 0
Local xBuffer := Space(37)
Local cUser460:= Space(15)
Local cImp460 := Space(20)
Local lF460MSG := ExistBlock("F460MSG")
Local lF460OK := ExistBlock("F460OK")
Local cLista := " "
Local aImpChq := {}
Local lLojaDll := .F.  //Verifica se utiliza SigalojaDll
Local cTmpMun
Local lF460BXT := ExistBlock("F460BXT")
Local lClosePort := .T.

PRIVATE titulo 	:=OemToAnsi(STR0001)  //"Cheques Especiais"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn	:= { OemToAnsi(STR0002), 1,OemToAnsi(STR0003), 1, 2, 1, "",1 }  //"Cheque"###"Administracao"
PRIVATE nomeprog	:="FINR460"
PRIVATE nLastKey	:= 0
PRIVATE cPerg		:=Padr("FIN460",len(SX1->X1_GRUPO)," ")
PRIVATE cImprVerso	:= AllTrim( GetMv("MV_IMPVER") )
PRIVATE cDesc1 	:=OemToAnsi(STR0004)  //"Este programa ir  imprimir os Cheques do Banco Selecionado"
PRIVATE cDesc2 	:=OemToAnsi(STR0005)  //"na impressora padr„o selecionada."
PRIVATE nHdll



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Handle da biblioteca para impress„o serial        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdll := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN460",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de arquivo INI para selecionar impres- ³
//³ sora de acordo com usuario. O arquivo devera ter a seguinte  ³
//³ configuracao:                            					     ³
//³                                         							  ³
//³ Descricao 			Tamanho		Pos Ini		Pos Fim 				  ³
//³ Usuario       	015			001			015					  ³
//³ Nome Impressora	020			016			036					  ³
//³                                   									  ³
//³ Cada linha deste arquivo dever  ser encerrada com CHR(10)+	  ³
//³ CHR(13)																		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF FILE("FINR460.INI")
	nHdl460 := fOpen("FINR460.INI")
	If nHdl460 > 0
		nTamArq := fSeek(nHdl460,0,2)
		fSeek(nHdl460,0,0)
		While nLidos <= nTamArq
			xBuffer := Space(37)
			fRead(nHdl460,@xBuffer,37)
			cUser460 := Substr(xBuffer,1, 15)
			cImp460  := Substr(xBuffer,16,20)
			If Trim(Upper(cUser460)) == Trim(Upper(cUserName))
				cNome := Substr(cImp460,1,20)
				Exit
			Endif
			nLidos+=37
		EndDo
	Endif
Endif

// Preparação do array das impressoras de cheque
// Alimenta uma string com o nome de todas as impressoras, separadas por virgulas.
cLista := Space(2000)
CHListar(@cLista)
// Alimenta o Vetor com o nome das impressoras recuperadas
cLista := AllTrim(cLista)
While Len(cLista)<>0
	If (nPos:=at(",",cLista))<>0
		aAdd(aImpChq, Subs(cLista, 2, nPos-3))
		cLista := Subs(cLista, nPos+1 )
	Else
		If Left(cLista,1)=='"'
			aAdd(aImpChq, Subs(cLista, 2, len(cLista)-2) )
		Else
			aAdd(aImpChq, cLista )
		EndIf
		cLista := ""
	EndIf
Enddo

//Adiciono impressoras exclusivas do Financeiro
AADD(aImpChq,"NCR                 ")
AADD(aImpChq,"CHRONOS             ")
AADD(aImpChq,"CHECKCERTO URANO    ")
AADD(aImpChq,"OLIVETTI PR 45      ")
AADD(aImpChq,"SCHALTER            ")
AADD(aImpChq,"QUATTRO             ")
AADD(aImpChq,"AUTOCHECK           ")

If mv_par01 <= 2 	// COM1 / COM2
	cPorta:="COM"+str(mv_par01,1)
Else					// LPT1 / LPT2
	cPorta:="LPT"+str(mv_par01-2,1)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega impressora padrao para cheques		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cNome)
	cNome := Substr(GetMV("MV_IMPESPE"),1,20)
Endif

DEFINE MSDIALOG oDlg FROM 173,9 TO 340,453 TITLE OemToAnsi(titulo) PIXEL

@ 005, 007 TO 075, 175 LABEL OemToAnsi(STR0006) OF oDlg PIXEL	//"Impressoras disponiveis no sistema"
@ 017, 014 SAY  OemToAnsi(STR0007) OF oDlg PIXEL  //"Modelo"
@ 015, 040 COMBOBOX oCBXImp VAR cNome ITEMS aImpChq SIZE 100, 90 OF oDlg PIXEL

DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End()	ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava dados no SX6									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !SX6->(eof())
	RecLock("SX6")
	SX6->X6_CONTEUD := cNome
	msUnlock()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ vari veis utilizadas para parametros								  ³
//³ mv_par01					// Porta (COM1,COM2) 					  ³
//³ mv_par02					// Codigo do Banco						  ³
//³ mv_par03					// Agencia									  ³
//³ mv_par04					// Conta 									  ³
//³ mv_par05					// Numera cheque automaticamente (S/N)³
//³ mv_par06					// numero do 1. cheque					  ³
//³ mv_par07					// Do Cheque								  ³
//³ mv_par08					// At‚ o Cheque							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Array que sera utilizado na impress„o do cheques  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCheque[1] := SPACE(3)					// Codigo do Banco
aCheque[2] := "#"         			 	// Simbolo da Moeda ou identificador
aCheque[3] := SPACE(30) 				// Favorecido
aCheque[4] := SPACE(30) 				// Cidade
aCheque[5] := dDatabase 				// Data de Emiss„o do Cheque
aCheque[6] := 0							// Valor
aCheque[7] := SPACE(15) 				// N£mero do Cheque
aCheque[8] := SPACE(80) 				// Primeira linha do hist¢rico
aCheque[9] := GetMv("MV_MENS") 		// Segunda  linha do hist¢rico
aCheque[10]:= SPACE(80) 				// Terceira Linha do hist¢rico

DbSelectArea("SA6")
DbSetOrder(1)
DbSeek( cFilial+MV_PAR02+MV_PAR03+MV_PAR04 )

cNumCheq := MV_PAR06

IF MV_PAR05 == 1 	//Numera automaticamente
	DbSelectArea( "SEF" )
	If !Empty( MV_PAR06 ) // Numero do primeiro cheque
		If (DbSeek( cFilial+MV_PAR02+MV_PAR03+MV_PAR04+MV_PAR06))
			Help(" ",1,"A460CHEQUE")
			Set Device To Screen
			Set Filter To
			Return
		End
	Else	
		IW_MsgBox(STR0028,STR0029,"STOP") //"Para numeração automática, deve-se informar o número do primeiro cheque"##"Atenção"
		Set Device To Screen
		Set Filter To
		Return
	Endif	
	DbSeek( cFilial )
	cCond1 := ".T."
Else
	DbSelectArea("SEF")
	DbSeek( cFilial+MV_PAR02+MV_PAR03+MV_PAR04+MV_PAR07,.T.)
	cCond1:="EF_BANCO=MV_PAR02.and.EF_AGENCIA=MV_PAR03.and.EF_CONTA=MV_PAR04.and.EF_NUM<=MV_PAR08"
End

While	!Eof() .and. EF_FILIAL = cFilial .and. &cCond1
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi(STR0008)  //"CANCELADO PELO OPERADOR"
		Exit
	End
	
	IF EF_IMPRESS $ "SAC" .or. SubStr(EF_TIPO,1,2) = "TB"
		dbSkip( )
		Loop
	End
	
	IF MV_PAR05 == 2 .and. Empty( EF_NUM )
		DbSkip( )
		Loop
	End
	
	DbSkip( )
	nSavRec := RecNo()
	DbSkip( -1 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso cheque n„o tenha sido gerado, ira gravar a movimen-³
	//³ ‡„o banc ria e atualizar cheque emitido					  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( EF_NUM )
		dbSelectArea( "SE2" )
		If (dbSeek(cFilial+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE))
			If !Empty( E2_PORTADO )
				dbSelectArea( "SA6" )
				dbSeek( cFilial + SE2->E2_PORTADO )
				cBenef := A6_NOME
			Else
				dbSelectArea( "SA2" )
				dbSeek( cFilial + SE2->E2_FORNECE + SE2->E2_LOJA )
				cBenef := A2_NOME
			Endif
		Endif
		RecLock("SE2")
		Replace E2_NUMBCO With  cNumCheq
		MsUnlock()
		dbSelectArea("SE5")
		dbSetOrder(4)
		dbSeek(xFilial()+SE2->E2_NATUREZ+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO,.T.)
		While ( !Eof() .And. xFilial("SE5") == SE5->E5_FILIAL .And.;
			SE2->E2_NATUREZ == SE5->E5_NATUREZ .And.;
			SE2->E2_PREFIXO == SE5->E5_PREFIXO .And.;
			SE2->E2_NUM     == SE5->E5_NUMERO  .And.;
			SE2->E2_PARCELA == SE5->E5_PARCELA .And.;
			SE2->E2_TIPO    == SE5->E5_TIPO )
			If ( SE2->E2_FORNECE+SE2->E2_LOJA == SE5->E5_CLIFOR+SE5->E5_LOJA )
				RecLock("SE5",.F.)
				SE5->E5_BANCO   := mv_par02
				SE5->E5_AGENCIA := mv_par03
				SE5->E5_CONTA   := mv_par04
				SE5->E5_NUMCHEQ := SE2->E2_NUMBCO
				MsUnlock()
			EndIf
			dbSelectArea("SE5")
			dbSkip()
		EndDo
		Reclock( "SEF" )
		Replace EF_NUM 	 With cNumCheq,;
			  EF_BANCO  With MV_PAR02,;
			  EF_AGENCIA With MV_PAR03,;
			  EF_CONTA  With MV_PAR04,;
			  EF_BENEF  With cBenef
		MsUnlock()
		
		Reclock( "SE5",.T. )
		Replace	E5_FILIAL		With cFilial ,;
				E5_BANCO 		With MV_PAR02,;
				E5_AGENCIA		With MV_PAR03,;
				E5_CONTA 		With MV_PAR04,;
				E5_BENEF 		With SEF->EF_BENEF,;
				E5_DATA			With SEF->EF_DATA,;
				E5_NUMCHEQ		With SEF->EF_NUM,;
				E5_DTDIGIT		With SEF->EF_DATA,;
				E5_HISTOR		With SEF->EF_HIST,;
				E5_RECPAG		With "P",;
				E5_TIPODOC		With "CH",;
				E5_VALOR 		With SEF->EF_VALOR,;
				E5_NATUREZ		With SE2->E2_NATUREZ,;
				E5_DTDISPO		With SEF->EF_DATA
				MsUnlock()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se nao for um pagamento antecipado ira atualizar o Saldo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !SE2->E2_TIPO $ MVPAGANT
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o Saldo Banc rio		  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				AtuSalBco( MV_PAR02,MV_PAR03,MV_PAR04,SEF->EF_DATA,SEF->EF_VALOR,"-")
			Endif
			cNumCheq:=Soma1( Trim ( cNumCheq ) , Len( Trim( cNumCheq ) ) )
	Endif

	DbSelectArea("SA6") ; DbSetOrder(1)
	DbSeek( cFilial+MV_PAR02+MV_PAR03+MV_PAR04 )
	
	aCheque[1] := MV_PAR02
	aCheque[2] := "#"
	aCheque[3] := SEF->EF_BENEF			//Favorecido
	If ExistBlock("F460MUN")
		cTmpMun := ExecBlock("F460MUN")
		If !Empty(cTmpMun)
				If ValType(cTmpMun) == "C"
					aCheque[4] := Left(cTmpMun,30)
				EndIf
		EndIf
	Else
		aCheque[4] := SA6->A6_MUN				//Cidade	
	EndIf	
	aCheque[5] := SEF->EF_DATA 			//Data de Emissao do Cheque
	aCheque[6] := SEF->EF_VALOR			//Valor do cheque
	aCheque[7] := SEF->EF_NUM				//n£mero do Cheque
	aCheque[8] := SEF->EF_HIST 			//hist¢rico

	If lF460MSG
		aCheque[9] := ExecBlock("F460MSG",.f.,.f.)
	Endif
	lLojaDll := .F.
	If Alltrim(cNome) == "NCR"
		nRet:=AutoCheck2(aCheque,@lEnd,nHdll)
	ElseIf	Alltrim(cNome) == "CHRONOS"
		nRet:=AutoCheck3(aCheque,@lEnd,nHdll)
	ElseIf	Alltrim(cNome) == "CHECKCERTO URANO"
		nRet:=AutoCheck5(aCheque,@lEnd,nHdll)
	ElseIf	Alltrim(cNome) == "OLIVETTI PR 45"
		nRet:=AutoCheck6(aCheque,@lEnd,nHdll)
	ElseIf	Alltrim(cNome) == "SCHALTER"
		nRet:=AutoCheck8(aCheque,@lEnd,nHdll)
	ElseIf	Alltrim(cNome) == "QUATTRO"
		nRet:=AutoCheck9(aCheque,@lEnd,nHdll)
	ElseIf	Alltrim(cNome) == "AUTOCHECK"
		nRet:=AutoCheckD(aCheque,@lEnd,nHdll)
	Else	
		If lClosePort
			nHdll := -1
			lClosePort := .F.
		Endif
		cRet:=AutoCheckP(aCheque,@lEnd,@nHdll,Alltrim(cNome),cPorta)
		lLojaDll := .T.
	Endif

	If lLojaDll
		IF cRet == "9" // Cancelou
			// Se nao abriu a porta nenhuma vez marco como não inicializado.
			If nHdll < 0
				CHFECHAR(nHdll,cPorta)
				lClosePort := .T.
			Endif
			Exit
		ElseIf cRet == "1" 	// nao imprimiu
			Help(" ",1,"NOIMPCHEQ")
			Exit
		ElseIf cRet == "0"    // imprimiu
			dbSelectArea("SEF")
			RecLock("SEF",.F.)
			Replace SEF->EF_IMPRESS WITH "S"
			MsUnlock()

		   //Ponto de entrada para complemento de gravacao	
		   If lF460BXT	
			    ExecBlock("F460BXT",.F.,.F.)	
		   Endif	
		
		Endif
	Else
		If lF460OK
			lRet := ExecBlock("F460OK",.f.,.f.)
			If lRet
				nRet := 0 	// imprimiu
			Else
				nRet := -5	// cancelou
			Endif
		Endif
		IF	nRet == -1
			Help(" ",1,"NOPRINTDAT")
		ElseIf	nRet == -2
			Help(" ",1,"NOLINHA")
			Exit
		ElseIf	nRet == -4
			Help(" ",1,"NOLAYOUT")
			Exit
		ElseIf nRet == -5	//ver
			Exit
		ElseIf nRet == 0
			dbSelectArea("SEF")
			RecLock("SEF",.F.)
			Replace SEF->EF_IMPRESS WITH "S"
			MsUnlock()

		   //Ponto de entrada para complemento de gravacao	
		   If lF460BXT	
		    ExecBlock("F460BXT",.F.,.F.)	
		   Endif	

		Endif
	Endif

	dbSelectArea( "SEF" )
	dbGoTo( nSavRec )
EndDo

dbSelectArea("SEF")
dbSetOrder(1)
Set Filter To
DbSelectArea("SA6")
dbSetOrder(1)
Set Filter To

//Fecho a porta - Sigaloja.dll
If lLojaDll .and. !lClosePort
	CHFECHAR(nHdll,cPorta)
Endif

Return(.T.)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AutoCheck2³ Autor ³ Erick Nori Barbosa	  ³ Data ³ 09/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime um cheque na impressora padr„o AUTOCHECK NCR. 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ AutoCheck2(ExpN1,ExpC1) 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Valor do cheque a ser impresso.						  ³±±
±±³			 ³ ExpC1 - Codigo do Banco.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoCheck2(aCheque,lEnd,nHdll)

LOCAL cBanco
LOCAL dEmissao
LOCAL nRet
LOCAL oDlg
Local lCheque := (ExistBlock("FINR460"))

cBanco	 := aCheque[1]
cFavorec := aCheque[3]
cCidade	:= aCheque[4]
dEmissao := aCheque[5]
cValor	 := Alltrim(Str(aCheque[6],15,2))
cValor	 := SubStr(cValor,1,Len(cValor)-3) + SubStr(cValor,Len(cValor)-1,2)
nCheque	:= aCheque[7]

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Formata a Serial e Envia caracteres 							³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRet		:= 0

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Mostra a condi‡„o de impress„o do cheque e aceita o n£mero³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM 173,9 TO 344,453 TITLE OemToAnsi(titulo) PIXEL

@ 005, 007 TO 045, 175 LABEL OemToAnsi(STR0009) OF oDlg PIXEL	//"Dados Bancarios"
@ 050, 007 TO 080, 175 OF oDlg PIXEL

@ 029, 014 SAY  OemToAnsi(STR0010) OF oDlg PIXEL  //"Insira o Cheque"
@ 058, 014 SAY  OemToAnsi(cDesc1) SIZE 160, 11 OF oDlg PIXEL
@ 068, 014 SAY  OemToAnsi(cDesc2) SIZE 160, 11 OF oDlg PIXEL

DbSelectArea("SA6")
@ 016, 014 SAY  SA6->A6_COD + "  " + SubStr( SA6->A6_NOME, 1,20 ) SIZE 120, 11 OF oDlg PIXEL
@ 027, 055 MSGET nCheque	Picture "@X"         SIZE 60, 11 OF oDlg PIXEL

DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 20, 187 TYPE 2 ACTION (oDlg:End(),lEnd:=.T.) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg

IF lEnd	.OR.	nLastKey == 27
	Return -5
Endif

MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,n,8,1")

MsWrite(nHdll,"b" + cBanco+chr(13)+chr(10))
MsWrite(nHdll,"c" + cCidade + "$" +chr(13)+chr(10))
MsWrite(nHdll,"d" + DtoC(dEmissao)+chr(13)+chr(10))
MsWrite(nHdll,"f" + cFavorec + "$" +chr(13)+chr(10))
MsWrite(nHdll,"P" +chr(13)+chr(10))
MsWrite(nHdll,"v" + cValor + "$"+chr(13)+chr(10))

If lCheque
	Execblock("FINR460",.f.,.f.,nHdll)
End

MsClosePort(nHdll)

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Imprime o hist¢rico do cheque se houver						³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF cImprVerso	$ "Ss" .and. ( !Empty(aCheque[8]) .or. !Empty(aCheque[9]) )
	
	DEFINE MSDIALOG oDlg FROM 173,9 TO 334,453 TITLE OemToAnsi(titulo) PIXEL
	
	@ 075, 007 TO 130, 175 OF oDlg PIXEL
	
	@ 071, 014 SAY  OemToAnsi(STR0011) OF oDlg PIXEL  //"Vire o cheque na impressora e clique no botao OK"
	@ 085, 014 SAY  OemToAnsi(STR0012) OF oDlg PIXEL  //"para imprimir o hist¢rico no verso.                      "
	
	DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg
	
	If  nLastKey # 27
		
		MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,n,8,1")
		
		MsWrite(nHdll, space(10)+aCheque[8])
		MsWrite(nHdll, space(10)+aCheque[9])
		MsWrite(nHdll, space(10) + aCheque[10])
		
		MsClosePort(nHdll)
		
	Endif
	
Endif

Return nRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AutoCheck3³ Autor ³ Antonio Maniero Jr.   ³ Data ³ 13/10/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime um cheque na impressora padr„o AUTOCHECK CHRONOS   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ AutoCheck2(ExpN1,ExpC1) 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Valor do cheque a ser impresso.						  ³±±
±±³			 ³ ExpC1 - Codigo do Banco.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoCheck3(aCheque,lEnd,nHdll)

LOCAL nPorta
LOCAL cBanco
LOCAL dEmissao
LOCAL nRet
LOCAL oDlg
Local nTam := 0
Local lCheque := (ExistBlock("FINR460"))
Local nOpca := 0

cBanco	 := aCheque[1]
cFavorec := aCheque[3]
cCidade	:= aCheque[4]
dEmissao := aCheque[5]
cValor	 := str(aCheque[6],12,2)
nCheque	:= aCheque[7]

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Acessa a parametriza‡„o do banco  ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA6")
dbSeek(cFilial+cBanco)

DEFINE MSDIALOG oDlg FROM 173,9 TO 344,453 TITLE OemToAnsi(titulo) PIXEL
@ 005, 007 TO 045, 175 LABEL OemToAnsi(STR0009) OF oDlg PIXEL	//"Dados Bancarios"
@ 050, 007 TO 080, 175 OF oDlg PIXEL

@ 029, 014 SAY  OemToAnsi(STR0010) OF oDlg PIXEL  //"Insira o Cheque"
@ 058, 014 SAY  OemToAnsi(cDesc1) SIZE 160, 11 OF oDlg PIXEL
@ 068, 014 SAY  OemToAnsi(cDesc2) SIZE 160, 11 OF oDlg PIXEL

DbSelectArea("SA6")
@ 016, 014 SAY  SA6->A6_COD + "  " + SubStr( SA6->A6_NOME, 1,20 ) SIZE 120, 11 OF oDlg PIXEL
@ 027, 055 MSGET nCheque	Picture "@X"         SIZE 60, 11 OF oDlg PIXEL

DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 20, 187 TYPE 2 ACTION (oDlg:End(),lEnd:=.T.) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg

IF lEnd	.OR.	nLastKey == 27
	Return -5
Endif

If ( MV_PAR01 <= 2 )
	MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,n,8,1")
Else
	nPorta := If( MV_PAR01 == 3 , "LPT1" , "LPT2" )
	Set Printer to &nPorta
	Set Printer on
	set device to printer
	InitPrint()
EndIf	

If ( MV_PAR01 <= 2 )
	MsWrite(nHdll,Chr(27)+Chr(162) + cBanco          +chr(13);
				 +Chr(27)+Chr(164) + left(dTOC(dEmissao),6)+Right(dTOC(dEmissao),2)  +chr(13);
				 +Chr(27)+Chr(160) + cFavorec        +chr(13);
			 	 +Chr(27)+Chr(161) + cCidade         +chr(13);
				 +Chr(27)+Chr(163) + cValor          +chr(13);
				 +Chr(27)+Chr(176))

	MsWrite(nHdll, chr(12))
Else	
	@ 0,0 PSAY chr(27) + Chr(162) + cBanco + Chr(13) + ;
				 chr(27) + Chr(164) + left(dTOC(dEmissao),6)+Right(dTOC(dEmissao),2) + Chr(13) + ;
				 chr(27) + Chr(160) + cFavorec + Chr(13) + ;
				 chr(27) + Chr(161) + cCidade + Chr(13) + ;
				 chr(27) + Chr(163) + cValor	+ Chr(13) + ;
				 chr(27) + Chr(176)
	Eject
	set device to screen
	set printer off
EndIf
If lCheque
	Execblock("FINR460",.f.,.f.,nHdll)
End

If ( MV_PAR01 <= 2 )
	MsClosePort(nHdll)	
Endif

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Imprime o hist¢rico do cheque se houver  ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF cImprVerso	$ "Ss" .and. ( !Empty(aCheque[8]) .or. !Empty(aCheque[9]) )

	nOpca := 0
	DEFINE MSDIALOG oDlg FROM 173,9 TO 334,453 TITLE OemToAnsi(titulo) PIXEL
	
	@ 050, 014 SAY  OemToAnsi(STR0011)	OF oDlg PIXEL	//"Vire o cheque na impressora e clique no botao OK"
	@ 060, 014 SAY  OemToAnsi(STR0026)	OF oDlg PIXEL	//"para imprimir o hist¢rico no verso."
	@ 040, 007 TO 075, 185 OF oDlg PIXEL

	DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 20, 187 TYPE 2 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg
	
	If nOpca == 1  // Se confirma impressao do verso
		If ( MV_PAR01 <= 2 )
			MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,n,8,1")
			nTam := (77 - Len(aCheque[9]))  // MV_MENS
			MsWrite(nHdll, Space(5) + aCheque[9] + Space(nTam))
			MsWrite(nHdll, Space(82))
			nTam := (77 - Len(aCheque[8]))  // EF_HIST
			MsWrite(nHdll, Space(5) + aCheque[8] + Space(nTam))
			MsWrite(nHdll, Space(82))
			MsWrite(nHdll, space(10) + aCheque[10])
			MsWrite(nHdll, chr(12))
			MsClosePort(nHdll)
		Else
			set Printer on
			set Device to Printer
			@ 0,0 Say Space(5) + aCheque[9]
			@ 3,0 Say Space(5) + aCheque[8]
			@ 5,0 Say Space(5) + aCheque[10]
			Eject

			Set Device to Screen
			Set Printer off
			Set Console On				
		EndIf		
	Endif
EndIf  

nRet := 0

Return nRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AutoCheck5³ Autor ³ Raul Carlos Capeleti  ³ Data ³ 19/06/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime um cheque na impressora padr„o checkcerto URANO	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ AutoCheck5(ExpN1,ExpC1) 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Valor do cheque a ser impresso.						  ³±±
±±³			 ³ ExpC1 - Codigo do Banco.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoCheck5(aCheque,lEnd,nHdll)
LOCAL cBanco
LOCAL dEmissao
LOCAL A1
LOCAL A2
LOCAL A3
LOCAL A11
LOCAL A21
LOCAL A31
LOCAL nRet
LOCAL oDlg
Local lCheque := (ExistBlock("FINR460"))

cBanco	 := aCheque[1]
cFavorec := aCheque[3]
cCidade	:= aCheque[4]
dEmissao := aCheque[5]
cValor	 := strzero(aCheque[6],15,2)
nCheque	:= aCheque[7]

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Mostra a condi‡„o de impress„o do cheque e aceita o n£mero³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM 173,9 TO 344,453 TITLE OemToAnsi(titulo) PIXEL

@ 005, 007 TO 045, 175 LABEL OemToAnsi(STR0009) OF oDlg PIXEL	//"Dados Bancarios"
@ 050, 007 TO 080, 175 OF oDlg PIXEL

@ 029, 014 SAY  OemToAnsi(STR0010)	 OF oDlg PIXEL  //"Insira o Cheque"
@ 058, 014 SAY  OemToAnsi(cDesc1) SIZE 160, 11 OF oDlg PIXEL
@ 068, 014 SAY  OemToAnsi(cDesc2) SIZE 160, 11 OF oDlg PIXEL

DbSelectArea("SA6")
@ 016, 014 SAY  SA6->A6_COD + "  " + SubStr( SA6->A6_NOME, 1,20 )  SIZE 120, 11 OF oDlg PIXEL
@ 027, 055 MSGET nCheque	Picture "@X"              SIZE 60, 11  OF oDlg PIXEL

DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End()			 ENABLE OF oDlg
DEFINE SBUTTON FROM 20, 187 TYPE 2 ACTION (oDlg:End(),lEnd:=.T.) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg

IF lEnd	.OR.	nLastKey == 27
	Return -5
Endif

MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,n,8,1")

MsWrite(nHdll,CHR(170)+CHR(1)+cCidade+CHR(128))
MsWrite(nHdll,CHR(170)+CHR(3)+cFavorec+CHR(128))

// CONVERSAO DA DATA
c01:= Substr(Dtoc(dEmissao),1,2)+Substr(Dtoc(dEmissao),4,2)+substr(Dtoc(dEmissao),7,2)
n02:= Val(c01)
A1:=INT(n02/10000)
A2:=INT(n02/100)-A1*100
A3:=n02-A1*10000-A2*100
A11:=(INT(A1/10)*16)+(A1-(INT(A1/10)*10))
A21:=(INT(A2/10)*16)+(A2-(INT(A2/10)*10))
A31:=(INT(A3/10)*16)+(A3-(INT(A3/10)*10))

//CONVERSAO DO VALOR
b1:=Val(Substr(cValor,1,2))
b2:=Val(Substr(cValor,3,2))
b3:=Val(Substr(cValor,5,2))
b4:=Val(Substr(cValor,7,2))
b5:=Val(Substr(cValor,9,2))
b6:=Val(Substr(cValor,11,2))
b7:=Val(Substr(cValor,14,2))

B11:=(INT(B1/10)*16)+(B1-(INT(B1/10)*10))
B21:=(INT(B2/10)*16)+(B2-(INT(B2/10)*10))
B31:=(INT(B3/10)*16)+(B3-(INT(B3/10)*10))
B41:=(INT(B4/10)*16)+(B4-(INT(B4/10)*10))
B51:=(INT(B5/10)*16)+(B5-(INT(B5/10)*10))
B61:=(INT(B6/10)*16)+(B6-(INT(B6/10)*10))
B71:=(INT(B7/10)*16)+(B7-(INT(B7/10)*10))
MsWrite(nHdll,CHR(170)+CHR(2)+CHR(A11)+CHR(A21)+CHR(A31))
MsWrite(nHdll,CHR(170)+CHR(5)+CHR(B11)+CHR(B21)+CHR(B31)+CHR(B41)+CHR(B51)+CHR(B61)+CHR(B71))

// CONVERSAO DO CODIGO DO BANCO
A = INT(val(cBanco)/256)
B = (Val(cBanco)/256-A)*256
MsWrite(nHdll,CHR(170)+CHR(4)+CHR(A)+CHR(B)+CHR(128))

If lCheque
	Execblock("FINR460",.f.,.f.,nHdll)
Endif

MsClosePort(nHdll)

nRet := 0
Return nRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AutoCheck6³ Autor ³ Antonio Maniero Jr.   ³ Data ³ 09/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime um cheque na impressora padr„o olivetti pr45		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ AutoCheck6(ExpN1,ExpC1) 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 - Matriz com os dados do cheque. 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoCheck6(aCheque,lEnd,nHdll)
LOCAL nValor
LOCAL cBanco
LOCAL dEmissao
LOCAL nLinVlr
LOCAL nLin1Ext
LOCAL nCol1Ext
LOCAL nLin2Ext
LOCAL nCol2Ext
LOCAL nLinFav
LOCAL nColFav
LOCAL nLinDat
LOCAL nColVir
LOCAL nTamLin
LOCAL cExt
LOCAL nPosAnt
LOCAL aLinhas :={}
LOCAL nTamAnt :=0
LOCAL nDif
LOCAL nCnt		:=0
LOCAL cValor
LOCAL nPosTot :=0
LOCAL cLin1
LOCAL cLin2
LOCAL cLin3
LOCAL cLin4
LOCAL cLin5
LOCAL nRet
LOCAL nCasas	:=0
LOCAL nColAno :=0
LOCAL aMes		:={ OemToAnsi(STR0013),OemToAnsi(STR0014),OemToAnsi(STR0015),;  //"Janeiro    "###"Fevereiro  "###"Marco      "
OemToAnsi(STR0016),OemToAnsi(STR0017),OemToAnsi(STR0018),;  //"Abril      "###"Maio       "###"Junho      "
OemToAnsi(STR0019),OemToAnsi(STR0020),OemToAnsi(STR0021),;  //"Julho      "###"Agosto     "###"Setembro   "
OemToAnsi(STR0022),OemToAnsi(STR0023),OemToAnsi(STR0024) }  //"Outubro    "###"Novembro   "###"Dezembro   "
LOCAL oDlg
Local lCheque := (ExistBlock("FINR460"))
Local I

cBanco		:= aCheque[1]
cCurrency	:= aCheque[2]
cFavorec 	:= aCheque[3]
cCidade		:= aCheque[4]
dEmissao 	:= aCheque[5]
nValor		:= aCheque[6]
cValor		:= strzero(aCheque[6],12,2)
nCheque		:= aCheque[7]

DEFINE MSDIALOG oDlg FROM 173,9 TO 344,453 TITLE OemToAnsi(titulo) PIXEL

@ 005, 007 TO 045, 175 LABEL OemToAnsi(STR0009) OF oDlg PIXEL	//"Dados Bancarios"
@ 050, 007 TO 080, 175 OF oDlg PIXEL

@ 029, 014 SAY  OemToAnsi(STR0010) OF oDlg PIXEL  //"Insira o Cheque"
@ 058, 014 SAY  OemToAnsi(cDesc1) SIZE 160, 11 OF oDlg PIXEL
@ 068, 014 SAY  OemToAnsi(cDesc2) SIZE 160, 11 OF oDlg PIXEL

DbSelectArea("SA6")
@ 016, 014 SAY  SA6->A6_COD + "  " + SubStr( SA6->A6_NOME, 1,20 ) SIZE 120, 11 OF oDlg PIXEL
@ 027, 055 MSGET nCheque	Picture "@X"         SIZE 60, 11 OF oDlg PIXEL

DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 20, 187 TYPE 2 ACTION (oDlg:End(),lEnd:=.T.) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg

IF lEnd	.OR.	nLastKey == 27
	Return -5
Endif

MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,e,8,2")

msWrite(nHdll,CHR(27)+CHR(48))
msWrite(nHdll,CHR(27)+CHR(83)+"5")
msWrite(nHdll,Chr(27)+Chr(62))
msWrite(nHdll,CHR(27)+CHR(48))

SA6->(dbSeek(xFilial("SA6")+aCheque[1]))
cCfgChk	:= Iif(Empty(SA6->A6_LAYOUT),"208120030004000551285 7090 S",SA6->A6_LAYOUT)
nLinVlr	:= Val(SubStr(cCfgChk, 4, 1))
nColVlr	:= Val(SubStr(cCfgChk,25, 3))
nColVlr	:= IIF(nColVlr==0,93,nColVlr)
nLin1Ext := Val(SubStr(cCfgChk, 5, 1))
nCol1Ext := Val(SubStr(cCfgChk, 6, 2))
nLin2Ext := Val(SubStr(cCfgChk, 8, 1))
nCol2Ext := Val(SubStr(cCfgChk, 9, 2))
nTamExt	:= Val(SubStr(cCfgChk,23, 2))
nTamExt	:= IIF(nTamExt==0,70,nTamExt)
nLinFav	:= Val(SubStr(cCfgChk,11, 2))
nColFav	:= Val(SubStr(cCfgChk,13, 2))
nLinDat	:= Val(SubStr(cCfgChk,15, 2))
nColVir	:= Val(SubStr(cCfgChk,17, 2))
nColAno	:= Val(SubStr(cCfgChk,20,3))
nCasas		:= Val(SubStr(cCfgChk,19, 1))
nCasas		:= IIF(nCasas==0,2,nCasas)
lComp 		:= (SubStr(cCfgChk,28, 1)=="S" .or. SubStr(cCfgChk,28, 1)==" ")

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Recupera o extenso do cheque e monta as linhas			³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cExtenso := Extenso(nValor,.F.,1)+" "
nPosAnt	:= 1

While .T.
	
	nTamLin :=70-IIF(nPosAnt==1,nCol1Ext,nCol2Ext)
	cExt	:= SubStr(cExtenso,nPosAnt,nTamLin)
	
	IF SubStr(cExtenso,(nPosAnt+nTamLin)-1,1)==" " .OR. SubStr(cExtenso,(nPosAnt+nTamLin),1)==" "
		nPosTot += Len(cExt)
		nPosAnt+=Len(cExt)
	Else
		nTamAnt := Len(cExt)
		nPosTot += Len(cExt)+1
		cExt:=SubStr(cExt,1,RAT(" ",cExt)-1)
		nPosAnt+=Len(cExt)+1
		nDif:=nTamAnt-Len(cExt)
		FOR i:= 1 TO LEN(cExt)
			IF nCnt >= nDif;Exit;End
			IF SubStr(cExt,i,1) == " "
				cExt:=SubStr(cExt,1,i)+" "+SubStr(cExt,i+1,Len(cExt))
				i++
				nCnt++
			EndIF
		Next i
	ENDIF
	AADD(aLinhas,cExt)
	IF nPosTot >= Len(cExtenso)
		Exit
	Endif
EndDO

FOR I:= 1 TO LEN(aLinhas)
	nTamLin:=70-IIF(I==1,nCol1Ext,nCol2Ext)
	IF Len(aLinhas[I]) < nTamLin
		aLinhas[I] := aLinhas[I]+Replicate("*",nTamLin-Len(aLinhas[I]))
	ENDIF
NEXT I

IF Len(aLinhas)==1
	AADD(aLinhas,Replicate("*",70-nCol2Ext))
EndIF

cLin1:=cCurrency+LTRIM(Transform(nValor,"@E 999,999,999,999.99"))
cLin2:=aLinhas[1]
cLin3:=IIF(Len(aLinhas)>1,aLinhas[2],Replicate("*",70))
cLin4:=SUBSTR(aLinhas[IIF(Len(aLinhas)>2,3,2)],1,70)
cLin5:=If(GetMV("MV_FAVOR"),cFavorec,Space(Len(cFavorec)))
cPiva:=strzero(80-Len(cLin1),3)

MsWrite(nHdll,Chr(27)+Chr(83)+"4")

MsgAlert(OemToAnsi(STR0025),OemToAnsi(STR0001))  //"Insira o cheque na impressora."###"Cheques Especiais"

msWrite(nHdll,Chr(27)+Chr(55)+Chr(27)+Chr(55)+Chr(27)+Chr(55)+Chr(27)+Chr(55)+Chr(27)+Chr(55))
msWrite(nHdll,Chr(27)+Chr(62))
msWrite(nHdll,Chr(27)+Chr(74)+ cPiva + cLin1)
msWrite(nHdll,Chr(10)+Chr(10))
msWrite(nHdll,Chr(27)+Chr(74)+"010" + "("+SUBST(cLin2,1,70))
msWrite(nHdll,Chr(10)+Chr(10))
msWrite(nHdll,Chr(27)+Chr(74)+"010" + SUBSTR(cLin3 ,1,69)+")")
msWrite(nHdll,Chr(10)+Chr(10))
msWrite(nHdll,Chr(27)+Chr(74)+"010" + subs(cLin5 ,1,70))
msWrite(nHdll,Chr(10)+Chr(10))
msWrite(nHdll,Chr(27)+Chr(74)+"036" + ALLTRIM(cCidade)      + Chr(13) +;
	Chr(27)+Chr(74)+"057" + STR(Day(dEmissao))    + Chr(13) +;
	Chr(27)+Chr(74)+"066" + aMes[Month(dEmissao)] + Chr(13) +;
	Chr(27)+Chr(74)+"078" + SubStr(Str(Year(dEmissao),4),3,2)+Chr(13))
msWrite(nHdll,Chr(27)+Chr(79))

If lCheque
	Execblock("FINR460",.f.,.f.,nHdll)
End

MsClosePort(nHdll)

nRet := 0
Return nRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AutoCheck8³ Autor ³ Erick Nori Barbosa	  ³ Data ³ 09/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime um cheque na impressora padr„o SCHALTER				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³AutoCheck2(ExpN1,ExpC1)												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Valor do cheque a ser impresso.						  ³±±
±±³			 ³ ExpC1 - Codigo do Banco.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoCheck8(aCheque,lEnd,nHdll)

LOCAL cBanco
LOCAL dEmissao
LOCAL nRet
LOCAL oDlg
LOCAL lOk			:= .F.
LOCAL cLinOneVer	:= aCheque[8]
LOCAL cLinTwoVer	:= aCheque[9]
LOCAL cLinTreeVer := aCheque[10]
Local lCheque := (ExistBlock("FINR460"))

cBanco	 := aCheque[1]
cFavorec  := aCheque[3]
cCidade	 := aCheque[4]
dEmissao  := aCheque[5]
cValor	 := Alltrim(Str(aCheque[6],15,2))
cValor	 := SubStr(cValor,1,Len(cValor)-3) + SubStr(cValor,Len(cValor)-1,2)
nCheque	 := aCheque[7]

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Mostra a condi‡„o de impress„o do cheque e aceita o n£mero³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM 173,9 TO 344,453 TITLE OemToAnsi(titulo) PIXEL

@ 005, 007 TO 045, 175 LABEL OemToAnsi("Dados Bancarios") OF oDlg PIXEL
@ 050, 007 TO 080, 175 OF oDlg PIXEL

@ 029, 014 SAY  OemToAnsi("Insira o Cheque") OF oDlg PIXEL
@ 058, 014 SAY  OemToAnsi(cDesc1) SIZE 160, 11 OF oDlg PIXEL
@ 068, 014 SAY  OemToAnsi(cDesc2) SIZE 160, 11 OF oDlg PIXEL

DbSelectArea("SA6")
@ 016, 014 SAY  SA6->A6_COD + "  " + SubStr( SA6->A6_NOME, 1,20 ) SIZE 120, 11 OF oDlg PIXEL
@ 027, 055 MSGET nCheque	Picture "@X"         SIZE 60, 11 OF oDlg PIXEL

DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 20, 187 TYPE 2 ACTION (oDlg:End(),lEnd:=.T.) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg

IF lEnd .OR. nLastKey == 27
	Return -5
Endif

nRet := 0

MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,n,8,1")

MsWrite(nHdll,chr(27)+ "b" + cBanco)
MsWrite(nHdll,chr(27)+ "c" + AllTrim(cCidade) + "$")
MsWrite(nHdll,chr(27)+ "d" + strzero(day(dEmissao),2) +strzero(month(dEmissao),2) +Substr(strzero(year(dEmissao),4),3,2))
MsWrite(nHdll,chr(27)+ "f" + If(GetMV("MV_FAVOR"),cFavorec,Space(Len(cFavorec))) + "$")
MsWrite(nHdll,chr(27)+ "v" + cValor + "$")

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Imprime o hist¢rico do cheque se houver ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cImprVerso	$ "Ss" .and. ( !Empty(aCheque[8]) .or. !Empty(aCheque[9]) )
	DEFINE MSDIALOG oDlg FROM 173,9 TO 334,453 TITLE OemToAnsi(titulo) PIXEL
	@ 005, 007 TO 77, 180 OF oDlg PIXEL
	@ 015, 014 SAY  OemToAnsi("Vire o cheque na impressora e clique no botao OK") SIZE 120, 10 OF oDlg PIXEL
	@ 025, 014 SAY  OemToAnsi("para imprimir o hist¢rico no verso.") SIZE 100, 10 OF oDlg PIXEL
	DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION (lOk := .T. ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 22, 187 TYPE 2 ACTION (lOk := .F. ,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg
	If lOk
		MsWrite(nHdll,Chr(32) + Chr(32) + Chr(32) + Chr(32) + Chr(32) +;
			Chr(32) + Chr(32) + Chr(32) + Chr(32) + Chr(32) + cLinOneVer +;
			Chr(10) + Chr(32) + Chr(32) + Chr(32) + Chr(32) + Chr(32) +;
			Chr(32) + Chr(32) + Chr(32) + Chr(32) + Chr(32) + cLinTwoVer +;
			Chr(10) + Chr(32) + Chr(32) + Chr(32) + Chr(32) + Chr(32) +;
			Chr(32) + Chr(32) + Chr(32) + Chr(32) + Chr(32) + cLinTreeVer +;
			Chr(10) + Chr(12))
	EndIf
EndIf

If lCheque
	Execblock("FINR460",.f.,.f.,nHdll)
End

MsClosePort(nHdll)

Return nRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AutoCheck9³ Autor ³ Antonio Maniero Jr.   ³ Data ³ 13/10/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime um cheque na impressora padr„o AUTOCHECK QUATTRO   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ AutoCheck9(ExpN1,ExpC1) 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Valor do cheque a ser impresso.						  ³±±
±±³			 ³ ExpC1 - Codigo do Banco.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoCheck9(aCheque,lEnd,nHdll)

LOCAL cBanco
LOCAL dEmissao
LOCAL nRet
LOCAL oDlg
Local lCheque := (ExistBlock("FINR460"))
Local lOk

cBanco	 := aCheque[1]
cFavorec := aCheque[3]
cCidade	:= aCheque[4]
dEmissao := aCheque[5]
cValor	 := str(aCheque[6],12,2)
nCheque	:= aCheque[7]

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Acessa a parametriza‡„o do banco 		 ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA6")
dbSeek(cFilial+cBanco)

DEFINE MSDIALOG oDlg FROM 173,9 TO 344,453 TITLE OemToAnsi(titulo) PIXEL
@ 005, 007 TO 045, 175 LABEL OemToAnsi(STR0009) OF oDlg PIXEL	//"Dados Bancarios"
@ 050, 007 TO 080, 175 OF oDlg PIXEL

@ 029, 014 SAY  OemToAnsi(STR0010) OF oDlg PIXEL  //"Insira o Cheque"
@ 058, 014 SAY  OemToAnsi(cDesc1) SIZE 160, 11 OF oDlg PIXEL
@ 068, 014 SAY  OemToAnsi(cDesc2) SIZE 160, 11 OF oDlg PIXEL

DbSelectArea("SA6")
@ 016, 014 SAY  SA6->A6_COD + "  " + SubStr( SA6->A6_NOME, 1,20 ) SIZE 120, 11 OF oDlg PIXEL
@ 027, 055 MSGET nCheque	Picture "@X"         SIZE 60, 11 OF oDlg PIXEL

DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 20, 187 TYPE 2 ACTION (oDlg:End(),lEnd:=.T.) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg

IF lEnd	.OR.	nLastKey == 27
	Return -5
Endif

MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,n,8,1")

MsWrite(nHdll, chr(27) + Chr(162) + cBanco + Chr(13) + ;
	chr(27) + Chr(164) + dTOC(dEmissao) + Chr(13) + ;
	chr(27) + Chr(160) + cFavorec + Chr(13) + ;
	chr(27) + Chr(161) + cCidade + Chr(13) + ;
	chr(27) + Chr(163) + cValor	+ Chr(13) + ;
	chr(27) + Chr(176))

If lCheque
	Execblock("FINR460",.f.,.f.,nHdll)
Endif

MsClosePort(nHdll)

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Imprime o hist¢rico do cheque se houver						³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF cImprVerso	$ "Ss" .and. ( !Empty(aCheque[8]) .or. !Empty(aCheque[9]) )
	DEFINE MSDIALOG oDlg FROM 173,9 TO 334,453 TITLE OemToAnsi(titulo) PIXEL
	@040, 007 TO 075, 175 OF oDlg PIXEL
	@085, 014 SAY  OemToAnsi(STR0011)	OF oDlg PIXEL	//"Vire o cheque na impressora e clique no botao OK"
	@097, 014 SAY  OemToAnsi(STR0026)	OF oDlg PIXEL	//"para imprimir o hist¢rico no verso."
	
	DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION (lOk := .T. ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 22, 187 TYPE 2 ACTION (lOk := .F. ,oDlg:End()) ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg

	If lOk
		MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,n,8,1")
		MsWrite(nHdll, space(10) + aCheque[8])
		MsWrite(nHdll, space(10) + aCheque[9])
		MsWrite(nHdll, space(10) + aCheque[10])
		
		MsClosePort(nHdll)
		
	Endif
Endif

nRet := 0
Return nRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AutoCheckD³ Autor ³ Erick Nori Barbosa	  ³ Data ³ 09/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime um cheque na impressora padr„o AUTOCHECK			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ AutoCheck2(ExpN1,ExpC1) 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Valor do cheque a ser impresso.						  ³±±
±±³			 ³ ExpC1 - Codigo do Banco.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoCheckD(aCheque,lEnd,nHdll)
LOCAL cBanco
LOCAL dEmissao
LOCAL nRet
LOCAL oDlg
Local wData
Local lCheque := (ExistBlock("FINR460"))
Local cPrintStr := ""

cBanco	 := aCheque[1]
cFavorec := aCheque[3]
cCidade	:= aCheque[4]
dEmissao := aCheque[5]
cValor	 := Alltrim(Str(aCheque[6],15,2))
cValor	 := SubStr(cValor,1,Len(cValor)-3) + SubStr(cValor,Len(cValor)-1,2)
nCheque	:= aCheque[7]

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Formata a Serial e Envia caracteres 							³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRet	:=0

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Mostra a condi‡„o de impress„o do cheque e aceita o n£mero³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM 173,9 TO 344,453 TITLE OemToAnsi(titulo) PIXEL

@ 005, 007 TO 045, 175 LABEL OemToAnsi(STR0009) OF oDlg PIXEL	//"Dados Bancarios"
@ 050, 007 TO 080, 175 OF oDlg PIXEL

@ 029, 014 SAY  OemToAnsi(STR0010) OF oDlg PIXEL  //"Insira o Cheque"
@ 058, 014 SAY  OemToAnsi(cDesc1) SIZE 160, 11 OF oDlg PIXEL
@ 068, 014 SAY  OemToAnsi(cDesc2) SIZE 160, 11 OF oDlg PIXEL

DbSelectArea("SA6")
@ 016, 014 SAY  SA6->A6_COD + "  " + SubStr( SA6->A6_NOME, 1,20 ) SIZE 120, 11 OF oDlg PIXEL
@ 027, 055 MSGET nCheque	Picture "@X"         SIZE 60, 11 OF oDlg PIXEL

DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 20, 187 TYPE 2 ACTION (oDlg:End(),lEnd:=.T.) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg

IF lEnd	.OR.	nLastKey == 27
	Return -5
Endif

MsOpenPort(nHdll,Iif(mv_par01==1,"COM1","COM2")+":9600,n,8,1")
wdata := dtoc(dEmissao)
wdata := left(wdata,2) + substr(wdata,4,2) + right(wdata,2)

cPrintStr := chr(27) +'r' 				// Limpeza de Buffer
cPrintStr += chr(27) +'b'+ cBanco
cPrintStr += chr(27) +"f"+ If(GetMV("MV_FAVOR"),cFavorec,Space(Len(cFavorec))) + "$"
cPrintStr += chr(27) +"c"+ AllTrim(cCidade) + "$"
cPrintStr += chr(27) +"d"+ Wdata
cPrintStr += chr(27) +"v"+ cValor + "$"

MsWrite(nHdll,cPrintStr)

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Nesta impressora n„o descobrimos como imprimir o verso   ³
*³ visto que ela somente imprime cheque (n„o texto livre)   ³
*³ Desta forma, abrimos um ponto de entrada com a porta se- ³
*³ rial aberta para que eventualmente possa ser customizado.³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCheque
	Execblock("FINR460",.f.,.f.,nHdll)
End
MsClosePort(nHdll)
Return nRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Cheq4Dg  ³ Autor ³ J£lio Wittwer  		  ³ Data ³10.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Compatibiliza o Parƒmetro MV_CHEQ4DG para Bematech DP10    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ FINR460    			                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function Cheq4Dg(lSetVal)
Local lRet := .F.

IF !SX6->(DbSeek(xFilial("SX6")+"MV_CHEQ4DG"))
	RecLock("SX6",.t.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV_CHEQ4DG"
	SX6->X6_TIPO    := "C"
	SX6->X6_CONTEUD := "N"
	SX6->X6_DESCRIC :="Indica se as Impressoras de Cheques Especiais  "
	SX6->X6_DESC1   :="devem enviar 4 Digitos do ano para Impressora. "
	MsUnlock()
Else
	lRet := Alltrim(upper(SX6->X6_CONTEUD))=="S"
	If lSetVal != NIL
		REclock("SX6")
		SX6->X6_CONTEUD := if(lSetVal,"S","N")
		MsUnlock()
	Endif
Endif
Return lRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AutoCheckP³ Autor ³ Mauricio Pequim Jr	  ³ Data ³25.07.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime um cheque na impressora padr„o PERTOCHEK			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR460  																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AutoCheckP(aCheque,lEnd,nHdll,cNome,cPorta)
LOCAL cBanco, dEmissao, cRet
LOCAL oDlg, cMensagem:=""
Local oDig , lDigAno := Cheq4dg()
Local cVerso := ""

cBanco	 := aCheque[1]
cFavorec  := aCheque[3]
cCidade	 := aCheque[4]
dEmissao  := aCheque[5]
cValor	 := STRZERO(aCheque[6],12,2)
nCheque	 := aCheque[7]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra a condi‡„o de impress„o do cheque e aceita o n£mero³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE MSDIALOG oDlg FROM 173,9 TO 344,453 TITLE OemToAnsi(titulo) PIXEL

@ 005, 007 TO 045, 175 LABEL OemToAnsi(STR0009) OF oDlg PIXEL	//"Dados Bancarios"
@ 050, 007 TO 080, 175 OF oDlg PIXEL

@ 029, 014 SAY  OemToAnsi(STR0010) OF oDlg PIXEL  //"Insira o Cheque"
@ 058, 014 SAY  OemToAnsi(cDesc1) SIZE 160, 11 OF oDlg PIXEL
@ 068, 014 SAY  OemToAnsi(cDesc2) SIZE 160, 11 OF oDlg PIXEL

DbSelectArea("SA6")
@ 016, 014 SAY  SA6->A6_COD + "  " + SubStr( SA6->A6_NOME, 1,20 ) SIZE 120, 11 OF oDlg PIXEL
@ 027, 055 MSGET nCheque	Picture "@X"         SIZE 60, 11 OF oDlg PIXEL

DEFINE SBUTTON FROM 07, 187 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 20, 187 TYPE 2 ACTION (oDlg:End(),lEnd:=.T.) ENABLE OF oDlg

@ 70, 180 CHECKBOX oDig VAR lDigAno PROMPT "4 Digitos" SIZE 30,11 OF oDLG PIXEL

ACTIVATE MSDIALOG oDlg

IF lEnd	.OR.	nLastKey == 27
	Return "9"
Endif

If nHdll < 0
	nHdll := CHABRIR(cNome,cPorta)
Endif

IF nHdll < 0
	Return "9"
Endif

IF ExistBlock("F460VER")
	cVerso:=	Execblock("F460VER",.f.,.f.)
Endif
IF ExistBlock("F460MSG")
	cMensagem := Execblock("F460MSG",.f.,.f.)
Endif
cBanco	 := aCheque[1]
cFavorec  := aCheque[3]
cCidade	 := aCheque[4]
dEmissao  := aCheque[5]
cValor	 := STRZERO(aCheque[6],12,2)
nCheque	 := aCheque[7]

cRet := STR(CHImprime( nHdll, cBanco, cValor, cFavorec, cCidade,DTOS(dEmissao), cMensagem, cVerso))

If !MsgYesNo(OemtoAnsi(STR0027),;	// O Cheque foi impresso corretamente
		OemToAnsi(STR0002))			// Cheque
	cRet := "9"	// N„o imprimiu
Endif

Return Alltrim(cRet)
