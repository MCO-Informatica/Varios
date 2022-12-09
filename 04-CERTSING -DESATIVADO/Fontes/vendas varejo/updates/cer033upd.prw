#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ-ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CER033UPD ³ Autor ³ MICROSIGA             ³ Data ³ 24/07/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Principal                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gestao Hospitalar                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CER033UPD()

cArqEmp 					:= "SigaMat.Emp"
__cInterNet 	:= Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
Private nModulo 	:= 51 // modulo SIGAHSP

Set Dele On

lEmpenho				:= .F.
lAtuMnu					:= .F.

Processa({|| ProcATU()},"Processando [CER033UPD]","Aguarde , processando preparação dos arquivos")

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcATU   ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Baseado na funcao criada por Eduardo Riera em 01/02/2002   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcATU()
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0
Local aRecnoSM0 	:= {}
Local lOpen     	:= .F.

ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")
If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))

	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0 .and. M0_CODIGO == "01"
			Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
		dbSkip()
	EndDo	

	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
 		nModulo := 51 // modulo SIGAHSP
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua(8)

			Begin Transaction

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de perguntas.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Perguntas...")
			cTexto += GeraSX1()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Arquivos...")
			cTexto += GeraSX2()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GeraSX3()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Gatilhos...")
			cTexto += GeraSX7()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando arquivos de índices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
			cTexto += GeraSIX()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os Consulta padrao.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Consulta Padrão...")
 		cTexto += GeraSXB()

			End Transaction
	
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
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
				dbSelectArea(aArqUpd[nx])
			Next nX		

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
		 EndIf
		Next nI
		
		If lOpen
			
			cTexto 				:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [CER033UPD] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
	
		EndIf
		
	EndIf
		
EndIf 	

Return(Nil)


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


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX1  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica as perguntas incluindo-as caso nao existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Uso Generico.                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX1()
Local aArea 			:= GetArea()
Local aRegs 			:= {}
Local i	  					:= 0
Local j     			:= 0
Local lInclui		:= .F.
Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}
Local cTexto      := ''

// Cria grupo de perguntas PCNAB
cPerg 									:= PADR("PCNAB     ", Len(SX1->X1_GRUPO))
aRegs 									:= {}
AADD(aRegs,{cPerg,"01","Endereco Arq CNAB ?           ","                              ","                              ","MV_CH0","C",099,000,000,"G","                                                            ","MV_PAR01       ","               ","               ","               ","d:\cn15010a_itau.ret                                        ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","CCNAB "," ","   ","              ","@!                                      ","      "})
AADD(aRegs,{cPerg,"02","Opcao Proc Arq ?              ","                              ","                              ","MV_CH0","C",001,000,001,"C","                                                            ","MV_PAR02       ","Fatura Pedidos ","               ","               ","                                                            ","               ","Desmembra Ped G","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","      "," ","   ","              ","@!                                      ","      "})

dbSelectArea("SX1")
dbSetOrder(1)
For i := 1 To Len(aRegs)
 lInclui := !dbSeek(cPerg + aRegs[i,2])
 RecLock("SX1", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
    FieldPut(j,aRegs[i,j])
   Endif
  Next
 MsUnlock()

  aHelpPor := {} ; aHelpSpa := {} ; 	aHelpEng := {}
  IF i == 1
    AADD(aHelpPor,"Informe o path do arquivo CNAB a ser   ")
    AADD(aHelpPor,"processado                             ")
  ELSEIF i==2
    AADD(aHelpPor,"Defina a opção de processamento de     ")
    AADD(aHelpPor,"arquivo CNAB:                          ")
    AADD(aHelpPor,"-Faturar - Identifica os Pedidos por   ")
    AADD(aHelpPor,"linha do CNAB e Fatura o mesmo         ")
    AADD(aHelpPor,"-Desmebrar - Identifica os pedidos e   ")
    AADD(aHelpPor,"caso se refira a pedidos com Serviço   ")
    AADD(aHelpPor,"e Hardware desmbra linha do cnab       ")
    AADD(aHelpPor,"-Faturar - Identifica os Pedidos por   ")
  ENDIF
    PutSX1Help("P."+alltrim(cPerg)+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)

 cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

Next

// Cria grupo de perguntas PCNABP
cPerg 									:= PADR("PCNABP    ", Len(SX1->X1_GRUPO))
aRegs 									:= {}
AADD(aRegs,{cPerg,"01","Opcao Proc Arq ?              ","Opcao Proc Arq ?              ","Opcao Proc Arq ?              ","MV_CH0","N",001,000,001,"C","                                                            ","MV_PAR01       ","Fatura Pedidos ","Fatura Pedidos ","Fatura Pedidos ","                                                            ","               ","Desmembra Arq  ","Desmembra Arq  ","Desmembra Arq  ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","      "," ","   ","              ","                                        ","      "})

dbSelectArea("SX1")
dbSetOrder(1)
For i := 1 To Len(aRegs)
 lInclui := !dbSeek(cPerg + aRegs[i,2])
 RecLock("SX1", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
    FieldPut(j,aRegs[i,j])
   Endif
  Next
 MsUnlock()

  aHelpPor := {} ; aHelpSpa := {} ; 	aHelpEng := {}
  IF i == 1
    AADD(aHelpPor,"Defina a opção de processamento de     ")
    AADD(aHelpPor,"arquivo CNAB:                          ")
    AADD(aHelpPor,"-Faturar - Identifica os Pedidos por   ")
    AADD(aHelpPor,"linha do CNAB e Fatura o mesmo         ")
    AADD(aHelpPor,"-Desmebrar - Identifica os pedidos e   ")
    AADD(aHelpPor,"caso se refira a pedidos com Serviço   ")
    AADD(aHelpPor,"e Hardware desmbra linha do cnab       ")
    AADD(aHelpPor,"-Faturar - Identifica os Pedidos por   ")
  ELSEIF i==2
    AADD(aHelpPor,"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ")
  ELSEIF i==3
    AADD(aHelpPor,"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ")
    ENDIF
    PutSX1Help("P."+alltrim(cPerg)+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)

 cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

Next

// Cria grupo de perguntas PESCNAB
cPerg 									:= PADR("PESCNAB   ", Len(SX1->X1_GRUPO))
aRegs 									:= {}
AADD(aRegs,{cPerg,"01","Conteudo a Procurar           ","Conteudo a Procurar           ","Conteudo a Procurar           ","MV_CH0","C",010,000,000,"G","                                                            ","MV_PAR01       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","      "," ","   ","              ","@!                                      ","      "})
AADD(aRegs,{cPerg,"02","Onde Procurar                 ","Onde Procurar                 ","Onde Procurar                 ","MV_CH0","C",001,000,004,"C","                                                            ","MV_PAR02       ","Num. Ped.      ","Num. Ped.      ","Num. Ped.      ","                                                            ","               ","Cod. Nf. Prod. ","Cod. Nf. Prod. ","Cod. Nf. Prod. ","                                                            ","               ","Cod. Nf. Serv. ","Cod. Nf. Serv. ","Cod. Nf. Serv. ","                                                            ","               ","Num. Linha     ","Num. Linha     ","Num. Linha     ","                                                            ","               ","Status         ","Status         ","Status    ","                                                            ","      "," ","   ","              ","                                        ","      "})

dbSelectArea("SX1")
dbSetOrder(1)
For i := 1 To Len(aRegs)
 lInclui := !dbSeek(cPerg + aRegs[i,2])
 RecLock("SX1", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
    FieldPut(j,aRegs[i,j])
   Endif
  Next
 MsUnlock()

  aHelpPor := {} ; aHelpSpa := {} ; 	aHelpEng := {}
  IF i == 1
    AADD(aHelpPor,"Conteudo a ser procurado nas linhas    ")
    AADD(aHelpPor,"do cnab                                ")
  ELSEIF i==2
    AADD(aHelpPor,"Coluna da tela a ser procurado o       ")
    AADD(aHelpPor,"conteudo                               ")
  ELSEIF i==3
    AADD(aHelpPor,"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ")
  ELSEIF i==4
    AADD(aHelpPor,"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ")
  ELSEIF i==5
    AADD(aHelpPor,"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ")
    ENDIF
    PutSX1Help("P."+alltrim(cPerg)+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)

 cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

Next


RestArea(aArea)
Return('SX1: ' + cTexto  + CHR(13) + CHR(10))


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX2  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX2()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SZ3","\DATA\                                  ","SZ3010  ","CADASTRO DE ENTIDADES         ","CADASTRO DE ENTIDADES         ","CADASTRO DE ENTIDADES         ","                                        ","C",000," ","                                                                                                                                                                                                                                                          "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZ5","\DATA\                                  ","SZ5010  ","DADOS PARA FTURAMENTO GAR     ","DADOS PARA FTURAMENTO GAR     ","DADOS PARA FTURAMENTO GAR     ","                                        ","C",000," ","                                                                                                                                                                                                                                                          "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZF","\DATA\                                  ","SZF010  ","CADASTRO VOUCHER              ","CADASTRO VOUCHER              ","CADASTRO VOUCHER              ","                                        ","C",000," ","                                                                                                                                                                                                                                                          "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZG","\DATA\                                  ","SZG010  ","MOVIMENTACAO VOUCHER          ","MOVIMENTACAO VOUCHER          ","MOVIMENTACAO VOUCHER          ","                                        ","C",000," ","                                                                                                                                                                                                                                                          "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","\DATA\                                  ","SZH010  ","TIPOS DE VOUCHER              ","TIPOS DE VOUCHER              ","TIPOS DE VOUCHER              ","                                        ","C",000," ","                                                                                                                                                                                                                                                          "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZI","                                        ","SZI010  ","CONTROLE DE TABELA DE PRECOS  ","CONTROLE DE TABELA DE PRECOS  ","CONTROLE DE TABELA DE PRECOS  ","                                        ","C",000," ","                                                                                                                                                                                                                                                          "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZJ","                                        ","SZJ010  ","COMPONENTES                   ","COMPONENTES                   ","COMPONENTES                   ","                                        ","C",000," ","                                                                                                                                                                                                                                                          "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZO","\DATA\                                  ","SZO010  ","CAD USUARIO DISTRIBUIC VOUCHER","CAD USUARIO DISTRIBUIC VOUCHER","CAD USUARIO DISTRIBUIC VOUCHER","                                        ","C",000," ","                                                                                                                                                                                                                                                          "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZP","                                        ","SZP010  ","CNABS PROCESSADAS             ","CNABS PROCESSADAS             ","CNABS PROCESSADAS             ","                                        ","C",000," ","ZP_FILIAL+ZP_ID                                                                                                                                                                                                                                           "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZQ","                                        ","SZQ010  ","ITENS CNABS                   ","ITENS CNABS                   ","ITENS CNABS                   ","                                        ","C",000," ","                                                                                                                                                                                                                                                          "," ",000,"                                                                                                                                                                                                                                                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX2 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX3  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX3()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"DA0","01","DA0_CODTAB","C",003,000,"Cod. Tabela ","Cod. Tabla ","Table Code ","Codigo da Tabela ","Codigo de la Tabla ",;
"Table Code ","@! ","ExistChav('DA0').And.FreeForUse('DA0',xFilial('DA0')+M->DA0_CODTAB) ","€€€€€€€€€€€€€€°",;
"GetSXeNum('DA0','DA0_CODTAB') "," ",001,"‡€"," "," "," ","S"," "," "," "," "," "," "," "," "," "," "," "," ","S"," "," ","S","N"," ",;
" ","N","N","N"})
AADD(aRegs,{"DA0","02","DA0_DESCRI","C",030,000,"Descricao ","Descripcion ","Description ","Descricao da tabela ","Descripcion de la tabla ",;
"Table Description ","@! "," ","€€€€€€€€€€€€€€ "," "," ",001,"›€"," "," "," ","S"," "," "," "," "," "," "," "," "," "," "," "," ","S",;
" "," ","S","N"," "," ","N","N","N"})
AADD(aRegs,{"DA0","03","DA0_DATDE ","D",008,000,"Data Inicial","Fch Inicial ","Initial Date","Data de validade inicial ","Fecha de validez inicial ",;
"Initial Validity "," ","Oms010Hora() ","€€€€€€€€€€€€€€ ","dDataBase "," ",001,"ƒ€"," "," "," ","S"," "," "," "," "," "," "," "," "," ",;
" "," "," ","S"," "," ","N","N"," "," ","N","N","N"})
AADD(aRegs,{"DA0","04","DA0_HORADE","C",005,000,"Hora Inicial","Hora Inicio ","Initial Hour","Hora de validade inicial ","Hora de validez inicial ",;
"Initial Validity Hour ","99:99 ","AtVldHora(M->DA0_HORADE).And. Oms010Hora() ","€€€€€€€€€€€€€€ ","'00:00' "," ",001,"ƒ€"," "," "," ",;
"N"," "," "," "," "," "," "," "," "," "," "," "," ","S"," "," ","N","N"," "," ","N","N","N"})
AADD(aRegs,{"DA0","05","DA0_DATATE","D",008,000,"Data Final ","Fch Final ","Final Date ","Data de validade final ","Fecha de validez final ",;
"Final Validity "," ","M->DA0_DATATE>=M->DA0_DATDE.And. Oms010Hora() ","€€€€€€€€€€€€€€ "," "," ",001,"‚À"," "," "," ","S"," "," "," ",;
" "," "," "," "," "," "," "," "," ","S"," "," ","N","N"," "," ","N","N","N"})
AADD(aRegs,{"DA0","06","DA0_HORATE","C",005,000,"Hora Final ","Hora Final ","Final Hour ","Hora de validade final ","Hora de validez final ",;
"Final Validity Hour ","99:99 ","AtVldHora(M->DA0_HORATE).And. Oms010Hora() ","€€€€€€€€€€€€€€ ","'23:59' "," ",001,"ƒ€"," "," "," ","N",;
" "," "," "," "," "," "," "," "," "," "," "," ","S"," "," ","N","N"," "," ","N","N","N"})
AADD(aRegs,{"DA0","07","DA0_CONDPG","C",003,000,"Cond.Pagto. ","Cond.Pago ","Paym.Term ","Condicao de Pagamento ","Condicion de Pago ",;
"Payment Term "," ","Vazio().Or.ExistCpo('SE4') ","€€€€€€€€€€€€€€ "," ","SE4 ",001,"‚À"," "," "," ","S"," "," "," "," "," "," "," "," ",;
" "," "," "," ","S"," "," ","N","N"," "," ","N","N","N"})
AADD(aRegs,{"DA0","08","DA0_TPHORA","C",001,000,"Tipo horario","Tipo horario","Time Type ","Tipo horario ","Tipo horario ","Time Type ",;
"! ","Pertence('12') ","€€€€€€€€€€€€€€ ","'1' "," ",001,"ƒ€"," "," "," ","S"," "," "," "," ","1=Unico;2=Recorrente ","1=Unico;2=Recursivo ",;
"1=Unique;2=Recursive "," "," "," "," "," ","S"," "," ","N","N"," "," ","N","N","N"})
AADD(aRegs,{"DA0","09","DA0_ATIVO ","C",001,000,"Tab. Ativa ","Tab. Activa ","Active Table","Tabela Ativa ","Tabla Activa ","Active Table ",;
"9 ","Pertence('12') ","€€€€€€€€€€€€€€ ","'1' "," ",001,"ƒ€"," "," "," ","S"," "," "," "," ","1=Sim;2=Nao ","1=Si;2=No ","1=Yes;2=No "," ",;
" "," "," "," ","S"," "," ","N","N"," "," ","N","N","N"})
AADD(aRegs,{"DA0","10","DA0_FILIAL","C",002,000,"Filial ","Sucursal ","Branch ","Filial do Sistema ","Sucursal del Sistema ",;
"System Branch ","@! "," ","€€€€€€€€€€€€€€€"," "," ",001,"‚€"," "," "," ","N"," "," "," "," "," "," "," "," "," "," "," "," ","S"," ",;
" ","N","N"," "," ","N","N","N"})
AADD(aRegs,{"DA0","11","DA0_XFLGEN","C",001,000,"Flag Envio ","Flag Envio ","Flag Envio ","Flag Envio Tab Pre ao Sit","Flag Envio Tab Pre ao Sit",;
"Flag Envio Tab Pre ao Sit"," "," ","€€€€€€€€€€€€€€€"," "," ",000,"þÀ"," "," ","U","N","V","R"," "," "," "," "," "," "," "," "," "," ",;
" "," "," "," ","N","N"," ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"DA1","01","DA1_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","SucursaldelSistema","SystemBranch","@!","","€€€€€€€€€€€€€€€","","",001,"‚€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","02","DA1_ITEM","C",004,000,"Item","Item","Item","Item","Item","Item","@!","","€€€€€€€€€€€€€€ ","","",001,"‚€","","","","S","V","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","03","DA1_CODTAB","C",003,000,"Cod.Tabela","Cod.Tabla","TableCode","CodigodaTabela","CodigodelaTabla","TableCode","@!","ExistCpo('DA0')","€€€€€€€€€€€€€€ ","","DA0",001,"ƒ€","","","","S","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","04","DA1_DESTAB","C",030,000,"Desc.Tabela","Desc.Tabla","TableDesc.","DescricaodaTabela","Descripciondelatabla","TableDescription","@!","","€€€€€€€€€€€€€€ ","If(!INCLUI,Posicione('DA0',1,xFilial('DA0')+DA1->DA1_CODTAB,'DA0_DESCRI'),'')","",001,"šÀ","","","","S","V","V","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"DA1","05","DA1_CODPRO","C",015,000,"Cod.Produto","Cod.Producto","ProductCode","CodigodoProduto","CodigodelProducto","ProductCode","@!","ExistCpo('SB1')","€€€€€€€€€€€€€€ ","","SB1",001,"†€","","S","","S","","","","","","","","","","","030","","S","","","S","N","","","N","N","N"})
AADD(aRegs,{"DA1","06","DA1_DESCRI","C",030,000,"Desc.Prod.","Descr.Prod.","Prod.Desc.","DescricaoProduto","DescripciondelProducto","ProductDescription","@!","","€€€€€€€€€€€€€€ ","IF(!INCLUI,Posicione('SB1',1,xFilial('SB1')+DA1->DA1_CODPRO,'B1_DESC'),'')","",001,"þA","","","","S","V","R","","","","","","","","IF(!INCLUI,POSICIONE('SB1',1,XFILIAL('SB1')+DA1->DA1_CODPRO,'B1_DESC'),'')","","","N","","","N","N","N","","N","N","N"})
AADD(aRegs,{"DA1","07","DA1_PRCBAS","N",009,002,"PrecoBase","PrecioBase","BasePrice","PrecoBase","PrecioBase","BasePrice","@E999,999.99","Positivo()","€€€€€€€€€€€€€€ ","IF(!INCLUI,Posicione('SB1',1,xFilial('SB1')+DA1->DA1_CODPRO,'B1_PRV1'),'')","",001,"š€","","","","N","V","V","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","07","DA1_CODCOB","C",015,000,"CodCombo","CodCombo","CodCombo","CodigodoCombo","CodigodoCombo","CodigodoCombo","","","€€€€€€€€€€€€€€ ","","SZI",000,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"DA1","08","DA1_PRCVEN","N",009,002,"PrecoVenda","PrecioVenta","SalesPrice","Precodevenda","Preciodeventa","SalesPrice","@E999,999.99","Positivo()","€€€€€€€€€€€€€€ ","","",001,"›€","","S","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","08","DA1_CODGAR","C",032,000,"CodGAR","CodGAR","CodGAR","CodigodoGAR","CodigodoGAR","CodigodoGAR","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"DA1","09","DA1_VLRDES","N",009,002,"Vlr.Desconto","Vlr.Descuent","DiscountVl.","ValordoDesconto","ValordelDescuento","DiscountValue","@E999,999.99","","€€€€€€€€€€€€€€ ","","",001,"šÀ","","S","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","09","DA1_DESGAR","C",092,000,"DescGAR","DescGAR","DescGAR","DescricaodoGAR","DescricaodoGAR","DescricaodoGAR","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"DA1","10","DA1_PERDES","N",006,004,"Fator","Factor","Factor","FatordeAcresc./Desconto","FactordeAument./Desc.","Inc./Disc.Factor","@E9.9999","","€€€€€€€€€€€€€€ ","","",001,"š€","","S","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","11","DA1_ATIVO","C",001,000,"Ativo","Activo","Active","ItemAtivo","ItemActivo","ActiveItem","@!","Pertence('12')","€€€€€€€€€€€€€€ ","'1'","",001,"ƒ€","","","","N","","","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","12","DA1_FRETE","N",009,002,"Frete","Flete","Freight","Frete","Flete","Freight","@E999,999.99","Positivo()","€€€€€€€€€€€€€€€","","",001,"šÀ","","","","N","A","R","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"DA1","13","DA1_ESTADO","C",002,000,"Estado","Estado","State","Estado","Estado","State","@!","Vazio().Or.ExistCpo('SX5','12'+M->DA1_ESTADO)","€€€€€€€€€€€€€€ ","","12",001,"‚À","","","","N","","","","","","","","","","","010","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","14","DA1_TPOPER","C",001,000,"TipoOperac.","TipoOperac.","Operat.Type","TipodeOperacao","TipodeOperacion","OperationType","@!","Pertence('1234')","€€€€€€€€€€€€€€ ","'4'","",001,"ƒ€","","","","N","","","","","1=Estadual;2=InterEstadual;3=Norte/Nordeste;4=Todos","1=Estadual;2=InterEstadual;3=Norte/Nordeste;4=Todos","1=State;2=InterState;3=North/North-east;4=All","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","15","DA1_QTDLOT","N",009,002,"Faixa","Intervalo","Range","Faixaparaopreco","Intervaloparaelprecio","PriceRange","@E999,999.99","","€€€€€€€€€€€€€€ ","999999.99","",001,"›€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","16","DA1_INDLOT","C",020,000,"Faixa","Intervalo","Range","Faixaparaopreco","Intervaloparaelprecio","PriceRange","@!","","€€€€€€€€€€€€€€€","","",001,"š€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","17","DA1_MOEDA","N",002,000,"Moeda","Moneda","Currency","Moeda","Moneda","Currency","99","Positivo()","€€€€€€€€€€€€€€ ","1","",001,"ƒ€","","S","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","18","DA1_DATVIG","D",008,000,"Vigencia","Vigencia","Validity","Vigenciadoitem","Vigenciadelitem","ItemValidity","","","€€€€€€€€€€€€€€ ","","",001,"‚€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"DA1","19","DA1_GRUPO","C",004,000,"Grupo","Grupo","Group","GrupodeProduto","GrupodeProducto","Productgroup","@!","ExistCpo('SBM')","€€€€€€€€€€€€€€ ","","SBM",001,"Æ€","","S","","S","A","R","","","","","","","","","","","N","","","S","N","N","","N","N","N"})
AADD(aRegs,{"DA1","20","DA1_REFGRD","C",014,000,"RefGrad/CFG","RefGrad/CFG","RefGrad/CFG","RefGrad/CFG","RefGrad/CFG","RefGrad/CFG","@!","A093Prod().And.OMS010VlRf()","€€€€€€€€€€€€€€ ","","",001,"†€","","S","","S","A","","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"DA1","21","DA1_PRCMAX","N",014,002,"PrecoMax.","PrecoMax.","PrecoMax.","PrecoMax.p/ocliente","PrecoMax.p/ocliente","PrecoMax.p/ocliente","@E99,999,999,999.99","Positivo()","€€€€€€€€€€€€€€ ","","",001,"þÀ","","","","N","A","","","","","","","","","","","","S","","","","","","","N","N","N"})
AADD(aRegs,{"DA1","25","DA1_XDSSIT","C",030,000,"DescSite","DescSite","DescSite","DescricaoSite","DescricaoSite","DescricaoSite","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SC5","A3","C5_XCODAUT","C",020,000,"Cod.Aut.","Cod.Aut.","Cod.Aut.","Cod.Aut.","Cod.Aut.","Cod.Aut.","@!","","€€€€€€€€€€€€€€ ","","",005,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E1","C5_XGARORI","C",001,000,"PedGarOri","PedGarOri","PedGarOri","PedidoGAROrigem","PedidoGAROrigem","PedidoGAROrigem","@!","","€€€€€€€€€€€€€€","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E3","C5_XDOCUME","C",020,000,"Nro.DocCar","Nro.DocCar","Nro.DocCar","Nro.DocCartao","Nro.DocCartao","Nro.DocCartao","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E4","C5_XENTREG","C",001,000,"EntregaHD","EntregaHD","EntregaHD","EntregaHardware","EntregaHardware","EntregaHardware","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","0=Nao;1=Sim","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SC6","B8","C6_XNFCANC","C",001,000,"NFCancelada","NFCancelada","NFCancelada","NFCancelada","NFCancelada","NFCancelada","@!","","€€€€€€€€€€€€€€€","'N'","",000,"þÀ","","","U","N","V","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC6","B9","C6_XDTCANC","D",008,000,"DtCancelNF","DtCancelNF","DtCancelNF","DataCancelamentoNF","DataCancelamentoNF","DataCancelamentoNF","@D","","€€€€€€€€€€€€€€€","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC6","C0","C6_XHRCANC","C",008,000,"HrCancelNF","HrCancelNF","HrCancelNF","HoraCancelamentoNF","HoraCancelamentoNF","HoraCancelamentoNF","99:99:99","","€€€€€€€€€€€€€€€","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC6","C1","C6_XCDPRCO","C",015,000,"CodCombo","CodCombo","CodCombo","CodigodoCombo","CodigodoCombo","CodigodoCombo","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SE1","11","E1_XFLAGEN","C",001,000,"FlagEnvio","FlagEnvio","FlagEnvio","FlagEnvioTabPreaoSit","FlagEnvioTabPreaoSit","FlagEnvioTabPreaoSit","","","€€€€€€€€€€€€€€€","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZ3","01","Z3_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"SZ3","02","Z3_CODENT","C",006,000,"CodEntidade","CodEntidade","CodEntidade","CodEntidade","CodEntidade","CodEntidade","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","","","","","","INCLUI","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","03","Z3_DESENT","C",100,000,"DescrEntid.","DescrEntid.","DescrEntid.","DescrEntid.","DescrEntid.","DescrEntid.","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","","","","","","INCLUI","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","04","Z3_TIPENT","C",001,000,"TipoEntidad","TipoEntidad","TipoEntidad","TipoEntidade","TipoEntidade","TipoEntidade","9","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","","1=Canal;2=AC;3=AR;4=Posto;5=Grupo","1=Canal;2=AC;3=AR;4=Posto","1=Canal;2=AC;3=AR;4=Posto","","INCLUI","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","05","Z3_TIPCOM","C",001,000,"TP.Comissao","TP.Comissao","TP.Comissao","Tipodecomissao","Tipodecomissao","Tipodecomissao","","","€€€€€€€€€€€€€€ ","'1'","",000,"þÀ","","","U","N","A","R","€","","1=Paga;2=Calcula","1=Paga;2=Calcula","1=Paga;2=Calcula","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","06","Z3_CLASSI","C",003,000,"Classificac.","Classificac.","Classificac.","Classificac.","Classificac.","Classificac.","@!","","€€€€€€€€€€€€€€ ","","SZA_01",000,"þÀ","","","U","N","A","R","€","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","07","Z3_CODGAR","C",032,000,"EntnoGAR","EntnoGAR","EntnoGAR","EntnoGAR","EntnoGAR","EntnoGAR","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","","","","","","INCLUI","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","08","Z3_CODCAN","C",006,000,"CodCanal","CodCanal","CodCanal","CodCanalSuperior","CodCanalSuperior","CodCanalSuperior","@!","U_COM010ok('Z3_CODCAN')","€€€€€€€€€€€€€€ ","","SZ3_01",000,"þÀ","","S","U","N","A","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","09","Z3_DESCAN","C",100,000,"DescCanal","DescCanal","DescCanal","DescricaoCanalSuperior","DescricaoCanalSuperior","DescricaoCanalSuperior","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","10","Z3_CODAC","C",006,000,"CodACSuper","CodACSuper","CodACSuper","CodigoACSuperior","CodigoACSuperior","CodigoACSuperior","@!","U_COM010ok('Z3_CODAC')","€€€€€€€€€€€€€€ ","","SZ3_02",000,"þÀ","","S","U","N","A","R","","","","","","","M->Z3_TIPENT>='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","11","Z3_DESAC","C",100,000,"DescrAC","DescrAC","DescrAC","DescricaodoAC","DescricaodoAC","DescricaodoAC","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","M->Z3_TIPENT>='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","12","Z3_CODAR","C",006,000,"CodARSuper","CodARSuper","CodARSuper","CodigoARSuperior","CodigoARSuperior","CodigoARSuperior","@!","U_COM010ok('Z3_CODAR')","€€€€€€€€€€€€€€ ","","SZ3_03",000,"þÀ","","S","U","N","A","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","13","Z3_DESAR","C",100,000,"DescrARSup","DescrARSup","DescrARSup","DescricaoARSuperior","DescricaoARSuperior","DescricaoARSuperior","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","14","Z3_CODFOR","C",006,000,"CodFornec.","CodFornec.","CodFornec.","CodigodoFornecedor","CodigodoFornecedor","CodigodoFornecedor","@!","","€€€€€€€€€€€€€€ ","","SA2",000,"þÀ","","S","U","N","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","15","Z3_LOJA","C",002,000,"Loja","Loja","Loja","Loja","Loja","Loja","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","16","Z3_DESFOR","C",060,000,"NomeFornec","NomeFornec","NomeFornec","NomeFornecedor","NomeFornecedor","NomeFornecedor","@!","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SA2',1,XFILIAL('SA2')+SZ3->Z3_CODFOR,'A2_NOME'),'')","",000,"þÀ","","","U","N","V","V","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","17","Z3_DEVLAR","C",001,000,"DescoComAR","DescoComAR","DescoComAR","DescontaValComissaoAR","DescontaValComissaoAR","DescontaValComissaoAR","9","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","0=Nao;1=Sim","0=Nao;1=Sim","0=Nao;1=Sim","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","18","Z3_PONDIS","C",006,000,"PontoDistr.","PontoDistr.","PontoDistr.","Pontodedistribuicao","Pontodedistribuicao","Pontodedistribuicao","999999","","€€€€€€€€€€€€€€ ","","SZ8_01",000,"þÀ","","","U","N","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","19","Z3_CEP","C",008,000,"CEP","CEP","CEP","CEP","CEP","CEP","@R99999-999","!Empty(M->Z3_CEP).AND.ExistCpo('PA7')","€€€€€€€€€€€€€€ ","","PA7",000,"þÀ","","S","U","N","A","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","20","Z3_LOGRAD","C",060,000,"Logradouro","Logradouro","Logradouro","Logradouro","Logradouro","Logradouro","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","21","Z3_NUMLOG","C",010,000,"NumLograd.","NumLograd.","NumLograd.","NumerodoLogradouro","NumerodoLogradouro","NumerodoLogradouro","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","22","Z3_COMPLE","C",030,000,"Complemento","Complemento","Complemento","Complemento","Complemento","Complemento","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","23","Z3_BAIRRO","C",030,000,"Bairro","Bairro","Bairro","Bairro","Bairro","Bairro","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","24","Z3_CODMUN","C",005,000,"CodMunicip.","CodMunicip.","CodMunicip.","CodMunicipio","CodMunicipio","CodMunicipio","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","25","Z3_MUNICI","C",035,000,"Municipio","Municipio","Municipio","Municipio","Municipio","Municipio","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","26","Z3_ESTADO","C",002,000,"Estado","Estado","Estado","Estado","Estado","Estado","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","27","Z3_REGIAO","C",001,000,"RegiaoPais","RegiaoPais","RegiaoPais","RegiaoPais","RegiaoPais","RegiaoPais","9","","€€€€€€€€€€€€€€ ","'4'","",000,"þÀ","","","U","N","A","R","€","","1=Norte;2=Nordeste;3=Sul;4=Sudeste;5=CentroOeste","1=Norte;2=Nordeste;3=Sul;4=Sudeste;5=CentroOeste","1=Norte;2=Nordeste;3=Sul;4=Sudeste;5=CentroOeste","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","28","Z3_BANCO","C",003,000,"Banco","Banco","Banco","Banco","Banco","Banco","999","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","29","Z3_AGENCIA","C",005,000,"Agencia","Agencia","Agencia","Agencia","Agencia","Agencia","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","30","Z3_CONTA","C",010,000,"ContaCorren","ContaCorren","ContaCorren","ContaCorrente","ContaCorrente","ContaCorrente","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","31","Z3_DDD","C",003,000,"DDD","DDD","DDD","CodigoDDD","CodigoDDD","CodigoDDD","999","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","32","Z3_TEL","C",015,000,"Telefone","Telefone","Telefone","TelefonedoPosto","TelefonedoPosto","TelefonedoPosto","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","33","Z3_CGC","C",014,000,"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF","CNPJ/CPFdoposto","CNPJ/CPFdoposto","CNPJ/CPFdoposto","@R99.999.999/9999-99","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","Vazio().Or.CGC(M->Z3_CGC)","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","34","Z3_CLIENTE","C",006,000,"Cliente","Cliente","Cliente","ClienteSimplesRemessa","ClienteSimplesRemessa","ClienteSimplesRemessa","@!","","€€€€€€€€€€€€€€ ","","SA1",000,"þÀ","","","U","S","A","R","","ExistCpo('SA1',M->Z3_CLIENTE,,,,.F.)","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","35","Z3_LOJACLI","C",002,000,"LojaCliente","LojaCliente","LojaCliente","Ljclientsimplesremessa","Ljclientsimplesremessa","Ljclientsimplesremessa","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","36","Z3_ATENDIM","C",001,000,"Atendimento","Atendimento","Atendimento","Atendimento","Atendimento","Atendimento","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","37","Z3_ATIVO","C",001,000,"Ativo","Ativo","Ativo","Ativo","Ativo","Ativo","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","38","Z3_VISIBIL","C",001,000,"Visibilidade","Visibilidade","Visibilidade","Visibilidade","Visibilidade","Visibilidade","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","39","Z3_ENTREGA","C",001,000,"Entrega","Entrega","Entrega","Entrega","Entrega","Entrega","@!","","€€€€€€€€€€€€€€ ","'N'","",000,"þÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","40","Z3_CODTAB","C",003,000,"Cod.Tab.Pr","Cod.Tab.Pr","Cod.Tab.Pr","CodigodaTabeladePreco","CodigodaTabeladePreco","CodigodaTabeladePreco","@!","","€€€€€€€€€€€€€€ ","","DA0",000,"þÀ","","","U","N","A","R","","","","","","","M->Z3_TIPENT$'2,5'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","41","Z3_CODPRO","C",015,000,"CodProd","CodProd","CodProd","CodigodoProduto","CodigodoProduto","CodigodoProduto","@!","","€€€€€€€€€€€€€€ ","","SB1",000,"þÀ","","","U","N","A","R","","","","","","","M->Z3_TIPENT$'2,5'","","030","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","42","Z3_ENVSITE","C",001,000,"Env.Site","Env.Site","Env.Site","EnviadoparaoSite","EnviadoparaoSite","EnvidadoparaoSite","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZ5","01","Z5_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","","","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZ5","02","Z5_PEDGAR","C",007,000,"PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","03","Z5_DATPED","D",008,000,"DataPedGAR","DataPedGAR","DataPedGAR","DatapedidoGAR","DatapedidoGAR","DatapedidoGAR","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","04","Z5_EMISSAO","D",008,000,"Emissao","Emissao","Emissao","Emissao","Emissao","Emissao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","05","Z5_RENOVA","D",008,000,"DtRenovacao","DtRenovacao","DtRenovacao","DatadaRenovacao","DatadaRenovacao","DatadaRenovacao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","06","Z5_REVOGA","D",008,000,"DtRevogacao","DtRevogacao","DtRevogacao","DatadeRevogacao","DatadeRevogacao","DatadeRevogacao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","07","Z5_DATVAL","D",008,000,"DtValidacao","DtValidacao","DtValidacao","DatadeValidacao","DatadeValidacao","DatadeValidacao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","08","Z5_HORVAL","C",005,000,"HoraValidac","HoraValidac","HoraValidac","HoraValidacao","HoraValidacao","HoraValidacao","99:99","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","09","Z5_CNPJ","C",014,000,"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF","CNPJdoCertificado","CNPJdoCertificado","CNPJdoCertificado","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","10","Z5_CNPJCER","C",014,000,"CNPJ/CPFCer","CNPJ/CPFCer","CNPJ/CPFCer","CNPJ/CPFCertificado","CNPJ/CPFCertificado","CNPJ/CPFCertificado","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","10","Z5_CNPJV","N",014,000,"CnpjValid","CnpjValid","CnpjValid","CnpjdaValidacao","CnpjdaValidacao","CnpjdaValidacao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","11","Z5_NOMREC","C",100,000,"NomeCertifi","NomeCertifi","NomeCertifi","NomeCertificado","NomeCertificado","NomeCertificado","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","11","Z5_RSVALID","C",100,000,"RazaoSocial","RazaoSocial","RazaoSocial","RazaoSocialdoCertifica","RazaoSocialdoCertifica","RazaoSocialdoCertifica","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","12","Z5_DATPAG","D",008,000,"DataPagto","DataPagto","DataPagto","DataPagto","DataPagto","DataPagto","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","13","Z5_VALOR","N",012,002,"Valor","Valor","Valor","Valor","Valor","Valor","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","14","Z5_TIPMOV","C",001,000,"FormaPagto","FormaPagto","FormaPagto","FormaPagto","FormaPagto","FormaPagto","9","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","15","Z5_STATUS","C",001,000,"Status","Status","Status","Status","Status","Status","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","1=Validacao;2-Renovacao","1=Validacao;2-Renovacao","1=Validacao;2-Renovacao","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","16","Z5_GARANT","C",010,000,"PedGARante","PedGARante","PedGARante","PedGARanterior","PedGARanterior","PedGARanterior","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","17","Z5_CODAR","C",020,000,"CodigoARV","CodigoARV","CodigoARV","CodigoARValidacao","CodigoARValidacao","CodigoARValidacao","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","17","Z5_NTITULA","C",100,000,"NomeTitular","NomeTitular","NomeTitular","NomedoTitulardoCertif","NomedoTitulardoCertif","NomedoTitulardoCertif","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","18","Z5_DESCAR","C",100,000,"DescricARV","DescricARV","DescricARV","DescricARValidacao","DescricARValidacao","DescricARValidacao","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","19","Z5_CODPOS","C",020,000,"CodigoPosto","CodigoPosto","CodigoPosto","CodigoPostoValidacao","CodigoPostoValidacao","CodigoPostoValidacao","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","20","Z5_DESPOS","C",100,000,"DescriPosto","DescriPosto","DescriPosto","DescricaodoPosto","DescricaodoPosto","DescricaodoPosto","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","21","Z5_CODAGE","C",020,000,"CodAgente","CodAgente","CodAgente","CodigodoAgente","CodigodoAgente","CodigodoAgente","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","22","Z5_NOMAGE","C",100,000,"NomeAgente","NomeAgente","NomeAgente","NomeAgente","NomeAgente","NomeAgente","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","23","Z5_CPFAGE","C",014,000,"CPFAgente","CPFAgente","CPFAgente","CPFAgente","CPFAgente","CPFAgente","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","24","Z5_CERTIF","C",020,000,"Certificado","Certificado","Certificado","Certificado","Certificado","Certificado","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","25","Z5_PRODUTO","C",020,000,"Produto","Produto","Produto","Produto","Produto","Produto","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","26","Z5_DESPRO","C",100,000,"Descricao","Descricao","Descricao","Descricao","Descricao","Descricao","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","27","Z5_GRUPO","C",020,000,"Grupo","Grupo","Grupo","Grupo","Grupo","Grupo","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","28","Z5_DESGRU","C",100,000,"DescrGrupo","DescrGrupo","DescrGrupo","DescrGrupo","DescrGrupo","DescrGrupo","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","29","Z5_TIPVOU","C",009,000,"TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","29","Z5_CODAC","C",020,000,"CodAC","CodAC","CodAC","CoddaACdePedido","CoddaACdePedido","CoddaACdePedido","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","30","Z5_CODVOU","C",020,000,"CodVoucher","CodVoucher","CodVoucher","CodVoucher","CodVoucher","CodVoucher","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","31","Z5_COMISS","C",001,000,"Comissao","Comissao","Comissao","Controledecomissao","Controledecomissao","Controledecomissao","","PERTENCE('1')","€€€€€€€€€€€€€€ ","'1'","",000,"þÀ","","","U","N","A","R","","","1=AGerar;2=Gerado;3=Pago","1=AGerar;2=Gerado;3=Pago","1=AGerar;2=Gerado;3=Pago","","M->Z5_COMISS<>'3'","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","31","Z5_DESCAC","C",100,000,"DescrAC","DescrAC","DescrAC","DescdaACdePedido","DescdaACdePedido","DescdaACdePedido","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","32","Z5_OBSCOM","C",100,000,"ObsComissao","ObsComissao","ObsComissao","Obsdefalhaaogerarcom","Obsdefalhaaogerarcom","Obsdefalhaaogerarcom","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","33","Z5_CODARP","C",020,000,"CodARPed","CodARPed","CodARPed","CoddaARdoPedido","CoddaARdoPedido","CoddaARdoPedido","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","35","Z5_DESCARP","C",100,000,"DescARPed","DescARPed","DescARPed","DescdaARdoPedido","DescdaARdoPedido","DescdaARdoPedido","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","41","Z5_REDE","C",100,000,"Rede","Rede","Rede","NomedaRededeValidacao","NomedaRededeValidacao","NomedaRededeValidacao","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","42","Z5_PRODGAR","C",020,000,"ProdutoGar","ProdutoGar","ProdutoGar","CodigoProdutoGAR","CodigoProdutoGAR","CodigoProdutoGAR","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","43","Z5_NOMECLI","C",100,000,"NomeCliente","NomeCliente","NomeCliente","NomeClientedaFatura","NomeClientedaFatura","NomeClientedaFatura","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","44","Z5_CNPJFAT","C",014,000,"CNPJ/CPFFAT","CNPJ/CPFFAT","CNPJ/CPFFAT","CNPJ/CPFdaFatura","CNPJ/CPFdaFatura","CNPJ/CPFdaFatura","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","45","Z5_EMAIL","C",050,000,"Email","Email","Email","Emailtitular","Emailtitular","Emailtitular","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","46","Z5_CODVEND","C",020,000,"CodRevendor","CodRevendor","CodRevendor","CoddoRevendedor","CoddoRevendedor","CoddoRevendedor","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","47","Z5_NOMVEND","C",100,000,"NomeRevend","NomeRevend","NomeRevend","NomedoRevendedor","NomedoRevendedor","NomedoRevendedor","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","48","Z5_COMSW","N",007,004,"%ComSW","%ComSW","%ComSW","%ComissaoSoftware","%ComissaoSoftware","%ComissaoSoftware","@999.9999","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","49","Z5_COMHW","N",006,004,"%ComHW","%ComHW","%ComHW","%ComissaoHardware","%ComissaoHardware","%ComissaoHardware","@999.9999","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","50","Z5_VALORSW","N",012,002,"ValordoSW","ValordoSW","ValordoSW","ValordoSW","ValordoSoftware","ValordoSoftware","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","51","Z5_VALORHW","N",012,002,"ValorHW","ValorHW","ValorHW","ValordoHardware","ValordoHardware","ValordoHardware","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","52","Z5_TIPO","C",006,000,"TipodeRem","TipodeRem","TipodeRem","TipodeMovdeRemuneca","TipodeMovdeRemuneca","TipodeMovdeRemuneca","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","VALIDA=Validacao;RENOVA=Renovacao;CLUBRE=ClubedoRevendedor;CAMPCO=CampanhadoContador;HWAVUL=HardwareAvulso","VALIDA=Validacao;RENOVA=Renovacao;CLUBRE=ClubedoRevendedor;CAMPCO=CampanhadoContador;HWAVUL=HardwareAvulso","VALIDA=Validacao;RENOVA=Renovacao;CLUBRE=ClubedoRevendedor;CAMPCO=CampanhadoContador;HWAVUL=HardwareAvulso","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","53","Z5_FLAGA","C",001,000,"FlagAtu","FlagAtu","FlagAtu","FlagdeAtualizacao","FlagdeAtualizacao","FlagdeAtualizacao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","54","Z5_CPFT","C",011,000,"CPFTitular","CPFTitular","CPFTitular","CPFTitularCertificado","CPFTitularCertificado","CPFTitularCertificado","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","55","Z5_DESCST","C",020,000,"DescStatus","DescStatus","DescStatus","DescStatus","DescStatus","DescStatus","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","55","Z5_PEDIDO","C",006,000,"PedidoVenda","PedidoVenda","PedidoVenda","PedidoVendaProtheus","PedidoVendaProtheus","PedidoVendaProtheus","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","56","Z5_CODPAR","C",020,000,"CodParceiro","CodParceiro","CodParceiro","CodigodoParceiro","CodigodoParceiro","CodigodoParceiro","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","57","Z5_NOMPAR","C",060,000,"NomeParceir","NomeParceir","NomeParceir","NomeParceir","NomedoParceiro","NomedoParceiro","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","58","Z5_ITEMPV","C",002,000,"ITEMPV","ITEMPV","ITEMPV","ItemdoPedidodeVenda","ItemdoPedidodeVenda","ItemdoPedidodeVenda","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","59","Z5_TIPODES","C",030,000,"DescTipo","DescTipo","DescTipo","DescTipodeMovRP","DescTipodeMovRP","DescTipodeMovRP","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","60","Z5_PEDGANT","C",007,000,"PedGARAnter","PedGARAnter","PedGARAnter","PedidoGARAnterior","PedidoGARAnterior","PedidoGARAnterior","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","61","Z5_ROTINA","C",010,000,"Rotina","Rotina","Rotina","Rotinadeorigem","Rotinadeorigem","Rotinadeorigem","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","62","Z5_PROCRET","C",001,000,"Processado","Processado","Processado","","","","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZF","01","ZF_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZF","02","ZF_COD","C",012,000,"Cod.Voucher","Cod.Voucher","Cod.Voucher","CodigodoVoucher","CodigodoVoucher","CodigodoVoucher","","","€€€€€€€€€€€€€€ ","U_VNDA350()","",000,"þÀ","","","U","S","V","R","€","NaoVazio().And.ExistChav('SZF')","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","02","ZF_CODFLU","C",007,000,"CodFluxo","CodFluxo","CodFluxo","CodigodoFluxo","CodigodoFluxo","CodigodoFluxo","","","€€€€€€€€€€€€€€ ","GETSXENUM('SZF','ZF_CODFLU')","",000,"þÀ","","","U","S","V","R","","NaoVazio().And.ExistChav('SZF')","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","03","ZF_TIPOVOU","C",001,000,"TipoVoucher","TipoVoucher","TipoVoucher","TipodeVoucher","TipodeVoucher","TipodeVoucher","@!","","€€€€€€€€€€€€€€ ","","SZH",000,"þÀ","","S","U","S","A","R","€","U_VNDA410(M->ZF_USERCOD,M->ZF_TIPOvOU)","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","03","ZF_QTDFLUX","N",005,000,"QtdVouchers","QtdVouchers","QtdVouchers","QuantidadedeVouchers","QuantidadedeVouchers","QuantidadedeVouchers","@E999999","","€€€€€€€€€€€€€€ ","000001","",000,"þÀ","","","U","N","A","V","","positivo()","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","04","ZF_PRODUTO","C",015,000,"ProdutoOrig","Produto","Produto","CodigodoProdutoOrigem","CodigodoProdutoOrigem","CodigodoProdutoOrigem","@!","vazio().or.existCpo('SB1')","€€€€€€€€€€€€€€ ","","ALT",000,"þÀ","","S","U","S","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","05","ZF_QTDVOUC","N",009,002,"Quantidade","Quantidade","Quantidade","QuantidadedoVoucher","QuantidadedoVoucher","QuantidadedoVoucher","@E999999.99","","€€€€€€€€€€€€€€ ","1","",000,"þÀ","","","U","N","V","R","","Positivo()","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","05","ZF_USRSOL","C",025,000,"UsrSolicita","UsrSolicita","UsrSolicita","UsuarioSolicitante","UsuarioSolicitante","UsuarioSolicitante","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","06","ZF_DTVALID","D",008,000,"Val.Voucher","Val.Voucher","Val.Voucher","ValidadedoVoucher","ValidadedoVoucher","ValidadedoVoucher","@D","M->ZF_DTVALID>=DDATABASE","€€€€€€€€€€€€€€ ","DDATABASE+365","",000,"þÀ","","","U","S","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","06","ZF_DATCRI","D",008,000,"DataCriacao","DataCriacao","DataCriacao","DatadeCriacao","DatadeCriacao","DatadeCriacao","@D","","€€€€€€€€€€€€€€ ","DDATABASE","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","07","ZF_PEDIDO","C",010,000,"PedGAROrig","PedGAROrig","PedGAROrig","PedGAROrigem","PedGAROrigem","PedGAROrigem","@X","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","S","U","S","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","07","ZF_HORCRI","C",008,000,"HoraCriacao","HoraCriacao","HoraCriacao","HoradeCriacao","HoradeCriacao","HoradeCriacao","99:99:99","","€€€€€€€€€€€€€€ ","TIME()","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","08","ZF_CONTRAT","C",015,000,"Contrato","Contrato","Contrato","NumerodoContrato","NumerodoContrato","NumerodoContrato","@X","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","09","ZF_TES","C",003,000,"TipoSaida","TipoSaida","TipoSaida","TipodeSaida","TipodeSaida","TipodeSaida","@9","vazio().or.existcpo('SF4').And.M->ZF_TES>='500'","€€€€€€€€€€€€€€ ","","SF4",000,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","10","ZF_SALDO","N",009,002,"SldVoucher","SldVoucher","SldVoucher","SaldodoVoucher","SaldodoVoucher","SaldodoVoucher","@E999999.99","","€€€€€€€€€€€€€€ ","1","",000,"þÀ","","","U","S","V","R","","Positivo()","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","10","ZF_DESTIPO","C",030,000,"DescTipo","DescTipo","DescTipo","DescricaodotipodeVouc","DescricaodotipodeVouc","DescricaodotipodeVouc","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","11","ZF_ATIVO","C",001,000,"Ativo","Ativo","Ativo","Ativo","Ativo","Ativo","@!","","€€€€€€€€€€€€€€ ","'S'","",000,"þÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","11","ZF_PRODEST","C",015,000,"Produto","Produto","Produto","Produtodestino","Produtodestino","Produtodestino","@!","","€€€€€€€€€€€€€€ ","","ALT",000,"þÀ","","S","U","N","A","R","€","existcpo('SB1')","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","12","ZF_FLAGSIT","C",001,000,"Jaenviado","Jaenviado","Jaenviado","Jaenviadoparaosite","Jaenviadoparaosite","Jaenviadoparaosite","@!","","€€€€€€€€€€€€€€€","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","12","ZF_PRODESC","C",030,000,"DescProduto","DescProduto","DescProduto","DescricaodoProduto","DescricaodoProduto","DescricaodoProduto","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","13","ZF_PDESGAR","C",020,000,"ProdutoGar","ProdutoGar","ProdutoGar","ProdutoGar","ProdutoGar","ProdutoGar","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","14","ZF_MOTOCO","C",006,000,"MotOcorrenc","MotOcorrenc","MotOcorrenc","MotivoOcorrencia","MotivoOcorrencia","MotivoOcorrencia","@!","","€€€€€€€€€€€€€€ ","","ZF",000,"þÀ","","S","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","15","ZF_DESMOT","C",030,000,"DescMotivo","DescMotivo","DescMotivo","DescricaoMotivo","DescricaoMotivo","DescricaoMotivo","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","16","ZF_VALID","C",001,000,"Validacao","Validacao","Validacao","Comoseraavalidacao","Comoseraavalidacao","Comoseraavalidacao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","A=Presencial;B=Posto","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","18","ZF_CDPRGAR","C",020,000,"CdProdGAR","CdProdGAR","CdProdGAR","CodigoProdutoGAR","CodigoProdutoGAR","CodigoProdutoGAR","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","S","U","N","A","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","20","ZF_DESPRO","C",030,000,"DescProdOr","DescProdOr","DescProdOr","DescricaodoProduto","DescricaodoProduto","DescricaodoProduto","@!","","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SB1',1,XFILIAL('SB1')+SZF->ZF_PRODUTO,'B1_DESC'),'')","",000,"þÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","22","ZF_CDORATE","C",006,000,"CodOriAten","CodOriAten","CodOriAten","CodigoOrigemAtendimento","CodigoOrigemAtendimento","CodigoOrigemAtendimento","","","€€€€€€€€€€€€€€ ","U_VNDA070('ZF_CDORATE')","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","23","ZF_ORIATE","C",020,000,"OrigemAtend","OrigemAtend","OrigemAtend","OrigemdeAtendimento","OrigemdeAtendimento","OrigemdeAtendimento","@!","","€€€€€€€€€€€€€€ ","U_VNDA070('ZF_ORIATE')","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","24","ZF_AC","C",040,000,"AC","AC","AC","AC","AC","AC","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","25","ZF_AR","C",040,000,"AR","AR","AR","AR","AR","AR","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","26","ZF_CODSTAT","C",002,000,"CodStatus","CodStatus","CodStatus","CodigodoStatus","CodigodoStatus","CodigodoStatus","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","27","ZF_STCERPD","C",030,000,"StCerPEDGA","StCerPEDGA","StCerPEDGA","StatusCertificadoPedGAR","StatusCertificadoPedGAR","StatusCertificadoPedGAR","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","28","ZF_REVREJ","C",001,000,"Revog/Rejeit","Revog/Rejeit","Revog/Rejeit","Revogado/Rejeitado","Revogado/Rejeitado","Revogado/Rejeitado","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","Vazio().OR.Pertence('12')","1=Revogado;2=Rejeitado","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","29","ZF_CGCCLI","C",014,000,"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF","CNPJ/CPFdocliente","CNPJ/CPFdocliente","CNPJ/CPFdocliente","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","30","ZF_NOMCLI","C",040,000,"NomeCliente","NomeCliente","NomeCliente","NomedoCliente","NomedoCliente","NomedoCliente","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","31","ZF_OBS","C",050,000,"Observacao","Observacao","Observacao","Observacao","Observacao","Observacao","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","32","ZF_DTVLPGO","D",008,000,"DtVlPDOri","DtVlPDOri","DtVlPDOri","DtVlPedGAROrigem","DtVlPedGAROrigem","DtVlPedGAROrigem","@D","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","33","ZF_GRPPROJ","C",010,000,"GrpProjeto","GrpProjeto","GrpProjeto","GrupodeProjeto","GrupodeProjeto","GrupodeProjeto","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","36","ZF_NOTEMP","C",013,000,"NotaEmpenho","NotaEmpenho","NotaEmpenho","NotadeEmpenho","NotadeEmpenho","NotadeEmpenho","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","37","ZF_PEDIDOV","C",006,000,"PedidoVenda","PedidoVenda","PedidoVenda","PedidodeVendaProtheus","PedidodeVendaProtheus","PedidodeVendaProtheus","@X","","€€€€€€€€€€€€€€ ","","SC5",000,"þÀ","","","U","N","A","R","","vazio().or.existCpo('SC5')","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","38","ZF_TPOPP","C",006,000,"Tp.Op.Prod","Tp.Op.Prod","Tp.Op.Prod","TipoOperacaoProduto","TipoOperacaoProduto","TipoOperacaoProduto","@!","ExistCpo('SX5','DJ'+M->ZF_TPOPP)","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","38","ZF_OPORTUN","C",006,000,"Oportunidade","Oportunidade","Oportunidade","Oportunidade","Oportunidade","Oportunidade","@!","","€€€€€€€€€€€€€€ ","","AD1",000,"þÀ","","","U","N","A","R","","vazio().or.existCpo('AD1')","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","40","ZF_TPFATUR","C",001,000,"TpFaturamen","TpFaturamen","TpFaturamen","TipodeFaturamento","TipodeFaturamento","TipodeFaturamento","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","Vazio().Or.Pertence('AP')","A=Antecipado;P=Postecipado","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","41","ZF_EMNTVEN","C",001,000,"EmNotaVend","EmNotaVend","EmNotaVend","EmiteNotaVenda","EmiteNotaVenda","EmiteNotaVenda","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","44","ZF_ALBIVE","C",001,000,"ApeItVenda","ApeItVenda","ApeItVenda","ApenasLibItemVenda","ApenasLibItemVenda","ApenasLibItemVenda","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","45","ZF_EMNTENT","C",001,000,"EmNtEntreg","EmNtEntreg","EmNtEntreg","EmiteNotaEntrega","EmiteNotaEntrega","EmiteNotaEntrega","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","46","ZF_TPOPENT","C",006,000,"Tp.Op.Entr","Tp.Op.Entr","Tp.Op.Entr","TipoOperacaoEntrega","TipoOperacaoEntrega","TipoOperacaoEntrega","@!","ExistCpo('SX5','DJ'+M->ZF_TPOPENT)","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","47","ZF_ARQEST","C",001,000,"ApReqEstoq","ApReqEstoq","ApReqEstoq","ApenasRequisicaoEstoque","ApenasRequisicaoEstoque","ApenasRequisicaoEstoque","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","48","ZF_TPMOVIM","C",003,000,"TipoMovimen","TipoMovimen","TipoMovimen","TipoMovimentacao","TipoMovimentacao","TipoMovimentacao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","50","ZF_PEDVEND","C",006,000,"PedVenOrig","PedVenOrig","PedVenOrig","PedidodeVendaOrigem","PedidodeVendaOrigem","PedidodeVendaOrigem","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","51","ZF_NFVENOR","C",013,000,"NFVendOrig","NFVendOrig","NFVendOrig","NFdeVendadeOrigem","NFdeVendadeOrigem","NFdeVendadeOrigem","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","52","ZF_NFSEROR","C",013,000,"NFServOrig","NFServOrig","NFServOrig","NFdeServicodeOrigem","NFdeServicodeOrigem","NFdeServicodeOrigem","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","53","ZF_NFENTOR","C",013,000,"NFEntOrig","NFEntOrig","NFEntOrig","NFdeEntregadeOrigem","NFdeEntregadeOrigem","NFdeEntregadeOrigem","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","54","ZF_USERCOD","C",006,000,"CodUsuario","CodUsuario","CodUsuario","CodigodoUsuario","CodigodoUsuario","CodigodoUsuario","","","€€€€€€€€€€€€€€ ","__CUSERID","",000,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","55","ZF_USERNAM","C",025,000,"NomeUsuario","NomeUsuario","NomeUsuario","NomedoUsuario","NomedoUsuario","NomedoUsuario","","","€€€€€€€€€€€€€€ ","CUSERNAME","",000,"þÀ","","","U","S","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","56","ZF_MIDIA","C",001,000,"MidiaPerson","MidiaPerson","MidiaPerson","MidiaPersonalizada","MidiaPersonalizada","MidiaPersonalizada","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","S=Sim;N=Nao","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","57","ZF_TPOPSER","C",006,000,"Tp.Op.Serv","Tp.Op.Serv","Tp.Op.Serv","TipoOpercaoServico","TipoOpercaoServico","TipoOpercaoServico","@!","ExistCpo('SX5','DJ'+M->ZF_TPOPSER)","€€€€€€€€€€€€€€","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZG","01","ZG_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZG","02","ZG_NUMPED","C",006,000,"NumPedido","NumPedido","NumPedido","NumerodoPedidoProtheus","NumerodoPedidoProtheus","NumerodoPedidoProtheus","@X","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","02","ZG_CODFLU","C",008,000,"CodigoFluxo","CodigoFluxo","CodigoFluxo","CodigoFluxo","CodigoFluxo","CodigoFluxo","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","03","ZG_ITEMPED","C",002,000,"ItemPedido","ItemPedido","ItemPedido","ItemdoPedido","ItemdoPedido","ItemdoPedido","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","04","ZG_NUMVOUC","C",012,000,"NumVoucher","NumVoucher","NumVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","€€€€€€€€€€€€€€ ","","SZF",000,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","05","ZG_QTDSAI","N",009,002,"Quantidade","Quantidade","Quantidade","Quantidadesaida","Quantidadesaida","Quantidadesaida","@E999999.99","","€€€€€€€€€€€€€€ ","0","",000,"þÀ","","","U","S","A","R","€","Positivo()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","07","ZG_PEDIDO","C",006,000,"PedidoGAR","PedidoGAR","PedidoGAR","NumerodoPedidoGAR","NumerodoPedidoGAR","NumerodoPedidoGAR","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","08","ZG_NFSER","C",012,000,"NFServico","NFServico","NFServico","Serie+numeroNFServico","Serie+numeroNFServico","Serie+numeroNFServico","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","09","ZG_NFPROD","C",012,000,"NFProduto","NFProduto","NFProduto","Serie+NumeroNFProduto","Serie+NumeroNFProduto","Serie+NumeroNFProduto","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","10","ZG_NFENT","C",012,000,"NFEntrega","NFEntrega","NFEntrega","Serie+NumeroNFEntrega","Serie+NumeroNFEntrega","Serie+NumeroNFEntrega","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","11","ZG_NUMEST","C",009,000,"Mov.Interna","Mov.Interna","Mov.Interna","MovimentacaoInternaEst.","MovimentacaoInternaEst.","MovimentacaoInternaEst.","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","12","ZG_DATAMOV","D",008,000,"DataMov","DataMov","DataMov","DatadoMovimento","DatadoMovimento","DatadoMovimento","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","13","ZG_ROTINA","C",015,000,"RotinaMov","RotinaMov","RotinaMov","RotinaqueMovimentou","RotinaqueMovimentou","RotinaqueMovimentou","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","14","ZG_GRPROJ","C",010,000,"GrupoProjet","GrupoProjet","GrupoProjet","GrupodoProjeto","GrupodoProjeto","GrupodoProjeto","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","15","ZG_TITULAR","C",030,000,"Titular","Titular","Titular","TitulardoCertificado","TitulardoCertificado","TitulardoCertificado","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","16","ZG_SEQVOUC","C",011,000,"SEQVOUC","SEQVOUC","SEQVOUC","SEQVOUC","SEQVOUC","SEQVOUC","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","01","ZH_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZH","02","ZH_COD","C",006,000,"CodTipoVou","CodTipoVou","CodTipoVou","Codigodotipodovoucher","Codigodotipodovoucher","Codigodotipodovoucher","@!","","€€€€€€€€€€€€€€ ","GETSXENUM('SZH','ZH_COD')","",000,"þÀ","","","U","S","V","R","€","NaoVazio().And.ExistChav('SZH')","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","02","ZH_TIPO","C",001,000,"TipoVoucher","TipoVoucher","TipoVoucher","TipodeVoucher","TipodeVoucher","TipodeVoucher","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","ExistChav('SZH',M->ZH_TIPO)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","03","ZH_DESCRI","C",030,000,"DesTipoVou","DesTipoVou","DesTipoVou","DescricaoTipoVoucher","DescricaoTipoVoucher","DescricaoTipoVoucher","@!","","€€€€€€€€€€€€€€€","","",000,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","04","ZH_INCITVE","C",001,000,"IncIteVen?","IncIteVen?","IncIteVen?","IncluiItemdeVenda?","IncluiItemdeVenda?","IncluiItemdeVenda?","@!","","€€€€€€€€€€€€€€€","'S'","",000,"þÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","04","ZH_EMNTVEN","C",001,000,"Em.NFVenda","Em.NFVenda","Em.NFVenda","EmiteNFVenda","EmiteNFVenda","EmiteNFVenda","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","€","Pertence('SPAN')","S=Servico;P=Produto;A=Ambos;N=NaoEmite","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","05","ZH_TESVEND","C",003,000,"TESIteVend","TESIteVend","TESIteVend","TESItemVenda","TESItemVenda","TESItemVenda","@!","","€€€€€€€€€€€€€€€","","SF4",000,"þÀ","","","U","S","A","R","","vazio().or.existcpo('SF4').And.M->ZH_TESVEND>='500'","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","05","ZH_TPOPSER","C",006,000,"Tp.Op.Serv","Tp.Op.Serv","Tp.Op.Serv","TipoOperacaoServ.","TipoOperacaoServ.","TipoOperacaoServ.","@!","ExistCpo('SX5','DJ'+M->ZH_TPOPSER)","€€€€€€€€€€€€€€ ","","DJ",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","06","ZH_INCITEE","C",001,000,"IncIteEnt?","IncIteEnt?","IncIteEnt?","IncluiItemdeEntrega?","IncluiItemdeEntrega?","IncluiItemdeEntrega?","@!","","€€€€€€€€€€€€€€€","'S'","",000,"þÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","06","ZH_TPOPP","C",006,000,"Tp.Op.Prod","Tp.Op.Prod","Tp.Op.Prod","TipoOperacaoProduto","TipoOperacaoProduto","TipoOperacaoProduto","@!","ExistCpo('SX5','DJ'+M->ZH_TPOPP)","€€€€€€€€€€€€€€€","","DJ",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","07","ZH_TESENTR","C",003,000,"TESIteEntr","TESIteEntr","TESIteEntr","TESItemEntrega","TESItemEntrega","TESItemEntrega","@!","","€€€€€€€€€€€€€€€","","SF4",000,"þÀ","","","U","S","A","R","","vazio().or.existcpo('SF4').And.M->ZH_TESENTR>='500'","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","07","ZH_ALBIVE","C",001,000,"Lib.Item","Lib.Item","Lib.Item","Apenasliberaitemvenda","Apenasliberaitemvenda","Apenasliberaitemvenda","","","€€€€€€€€€€€€€€€","","",000,"þÀ","","","U","N","A","R","€","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","08","ZH_FATITVE","C",001,000,"FatIteVen?","FatIteVen?","FatIteVen?","FaturaItemdeVenda?","FaturaItemdeVenda?","FaturaItemdeVenda?","@!","","€€€€€€€€€€€€€€€","'S'","",000,"þÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","08","ZH_EMNTENT","C",001,000,"Em.NFEnt.","Em.NFEnt.","Em.NFEnt.","EmiteNFdeEntrega","EmiteNFdeEntrega","EmiteNFdeEntrega","","","€€€€€€€€€€€€€€€","","",000,"þÀ","","","U","N","A","R","€","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","09","ZH_FATITEE","C",001,000,"FatIteEnt?","FatIteEnt?","FatIteEnt?","FaturaItemdeEntrega?","FaturaItemdeEntrega?","FaturaItemdeEntrega?","@!","","€€€€€€€€€€€€€€€","'S'","",000,"þÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","09","ZH_TPOPENT","C",006,000,"Tp.Op.Entr","Tp.Op.Entr","Tp.Op.Entr","TipoOperacaoEntrega","TipoOperacaoEntrega","TipoOperacaoEntrega","@!","ExistCpo('SX5','DJ'+M->ZH_TPOPENT)","€€€€€€€€€€€€€€ ","","DJ",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","10","ZH_CONSPDO","C",001,000,"ConsPed?","ConsPed?","ConsPed?","ConsideraPedido?","ConsideraPedido?","ConsideraPedido?","@!","","€€€€€€€€€€€€€€€","'V'","",000,"þÀ","","","U","S","A","R","","Pertence('VPE')","V=Voucher;P=Periodo;E=Entrega","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","10","ZH_ARQEST","C",001,000,"Req.Est.","Req.Est.","Req.Est.","ApenasRequisicaoestoque","ApenasRequisicaoestoque","ApenasRequisicaoestoque","","","€€€€€€€€€€€€€€€","","",000,"þÀ","","","U","N","A","R","€","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","11","ZH_TPMOVIM","C",003,000,"TipodeMov.","TipodeMov.","TipodeMov.","TipodeMovimentacao","TipodeMovimentacao","TipodeMovimentacao","","","€€€€€€€€€€€€€€€","","SF5",000,"þÀ","","","U","N","A","R","","vazio().or.existCpo('SF5')","","","","","M->ZH_ARQEST=='S'","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZI","01","ZI_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZI","02","ZI_COMBO","C",015,000,"Combo","Combo","Combo","Combo","Combo","Combo","","","€€€€€€€€€€€€€€ ","GetSxENum('SZI','ZI_COMBO')","",000,"þÀ","","","U","S","V","R","€","ExistChav('SZI',M->ZI_COMBO)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","03","ZI_TABPRE","C",003,000,"TabdePreco","TabdePreco","TabdePreco","TabeladePreco","TabeladePreco","TabeladePreco","999999","","€€€€€€€€€€€€€€ ","","DA0",000,"þÀ","","S","U","S","A","R","€","ExistCpo('DA0',M->ZI_TABPRE)","","","","","nOpc==3","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","04","ZI_DESCPRE","C",030,000,"DescTabPre","DescTabPre","DescTabPre","DescricaotabeladePreco","DescricaotabeladePreco","DescricaotabeladePreco","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","05","ZI_OBSERV","C",030,000,"Observacao","Observacao","Observacao","Observacao","Observacao","Observacao","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","","","","","","nOpc==3","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","06","ZI_PROKIT","C",015,000,"ProdutoKIT","ProdutoKIT","ProdutoKIT","ProdutoKIT","ProdutoKIT","ProdutoKIT","@!","","€€€€€€€€€€€€€€ ","","SB1",000,"þÀ","","S","U","S","A","R","","","","","","","nOpc==3.AND.Empty(M->ZI_PROGAR)","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","07","ZI_DESCKIT","C",030,000,"DescProKit","DescProKit","DescProKit","DescricaoProdutoKit","DescricaoProdutoKit","DescricaoProdutoKit","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","08","ZI_PROGAR","C",016,000,"ProdutoGAR","ProdutoGAR","ProdutoGAR","ProdutoGAR","ProdutoGAR","ProdutoGAR","@!","","€€€€€€€€€€€€€€ ","","PA8",000,"þÀ","","S","U","S","A","R","","","","","","","nOpc==3","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","09","ZI_DESCGAR","C",092,000,"DescProGAR","DescProGAR","DescProGAR","DescricaoProdutoGAR","DescricaoProdutoGAR","DescricaoProdutoGAR","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","10","ZI_BLOQUE","C",001,000,"Bloqueado","Bloqueado","Bloqueado","Bloqueado","Bloqueado","Bloqueado","","","€€€€€€€€€€€€€€€","'S'","",000,"þÀ","","","U","S","A","R","€","","S=SIM;N=NAO","S=SIM;N=NAO","S=SIM;N=NAO","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","10","ZI_ATIVO","C",001,000,"Ativo","Ativo","Ativo","Ativo","Ativo","Ativo","","","€€€€€€€€€€€€€€ ","'2'","",000,"þÀ","","","U","S","V","R","","Pertence('12')","1=Sim;2=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZI","11","ZI_PREVEN","N",009,002,"PrecoVenda","PrecoVenda","PrecoVenda","PrecodeVenda","PrecodeVenda","PrecodeVenda","@E999,999.99","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZJ","01","ZJ_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZJ","02","ZJ_COMBO","C",015,000,"Combo","Combo","Combo","Combo","Combo","Combo","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZJ","03","ZJ_CODPROD","C",015,000,"CodProduto","CodProduto","CodProduto","CodProduto","CodProduto","CodProduto","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZJ","04","ZJ_PRODUTO","C",030,000,"Produto","Produto","Produto","Produto","Produto","Produto","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZJ","05","ZJ_QTDBAS","N",012,002,"QtdBase","QtdBase","QtdBase","QuantidadeBase","QuantidadeBase","QuantidadeBase","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZJ","06","ZJ_PREBASE","N",009,002,"PrecoBase","PrecoBase","PrecoBase","PrecoBase","PrecoBase","PrecoBase","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZJ","07","ZJ_FATOR","N",009,002,"Fator","Fator","Fator","Fator","Fator","Fator","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZJ","08","ZJ_PRETAB","N",009,002,"PrecoTabela","PrecoTabela","PrecoTabela","PrecoTabela","PrecoTabela","PrecoTabela","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZL","01","ZL_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","A","R","€","","","","","","","","033","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","02","ZL_OCORREN","C",006,000,"Ocorrencia","Ocorrencia","Ocorrencia","Codigodaocorrencia","Codigodaocorrencia","Codigodaocorrencia","@!","","€€€€€€€€€€€€€€ ","","SU9",000,"þÀ","","S","U","N","A","R","€","ExistCpo('SU9',M->ZL_OCORREN,2)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","03","ZL_DESCOCO","C",030,000,"Desc.Ocorr.","Desc.Ocorr.","Desc.Ocorr.","DescriccaodaOcorrencia","DescriccaodaOcorrencia","DescriccaodaOcorrencia","@x","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","04","ZL_ASSUNTO","C",006,000,"Assunto","Assunto","Assunto","Assuntotratado","Assuntotratado","Assuntotratado","@!","","€€€€€€€€€€€€€€ ","","T1",000,"þÀ","","S","U","N","A","R","€","ExistCpo('SX5','T1'+M->ZL_ASSUNTO)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","05","ZL_DESCASS","C",030,000,"DescAssunto","DescAssunto","DescAssunto","DescricaodoAssunto","DescricaodoAssunto","DescricaodoAssunto","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","06","ZL_GRUPO","C",006,000,"Grupo","Grupo","Grupo","GrupodeAtendimento","GrupodeAtendimento","GrupodeAtendimento","@!","","€€€€€€€€€€€€€€ ","","SU0",000,"þÀ","","S","U","N","A","R","","ExistCpo('SQ0')","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","07","ZL_DESCGRU","C",030,000,"DescGrupo","DescGrupo","DescGrupo","DescGrupodeAtendimento","DescGrupodeAtendimento","DescGrupodeAtendimento","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","08","ZL_PRODUTO","C",015,000,"Produto","Produto","Produto","Produtoatendido","Produtoatendido","Produtoatendido","@!","","€€€€€€€€€€€€€€ ","","SB1",000,"þÀ","","S","U","N","A","R","","existcpo('SB1')","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","09","ZL_DESCPRO","C",030,000,"DescProduto","DescProduto","DescProduto","DescricaodoProduto","DescricaodoProduto","DescricaodoProduto","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","10","ZL_PERGUNT","C",150,000,"Pergunta","Pergunta","Pergunta","Perguntapadrao","Perguntapadrao","Perguntapadrao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZL","11","ZL_RESPOST","C",200,000,"Resposta","Resposta","Resposta","Respostapadrao","Respostapadrao","Respostapadrao","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZO","01","ZO_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZO","02","ZO_CODUSER","C",006,000,"CodUsuario","CodUsuario","CodUsuario","CodigoUsuarioDistrib","CodigoUsuarioDistrib","CodigoUsuarioDistrib","","","€€€€€€€€€€€€€€ ","","USR",000,"þÀ","","S","U","S","A","R","€","UsrExist(M->ZO_CODUSER)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZO","03","ZO_NOMUSER","C",025,000,"NomeUsuario","NomeUsuario","NomeUsuario","NomeUsuarioProtheus","NomeUsuarioProtheus","NomeUsuarioProtheus","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZO","04","ZO_EQATEND","C",006,000,"EquipeAtend","EquipeAtend","EquipeAtend","EquipeAtendimento","EquipeAtendimento","EquipeAtendimento","@!","","€€€€€€€€€€€€€€ ","","ZO",000,"þÀ","","S","U","S","A","R","","ExistCpo('SX5','ZO'+M->ZO_EQATEND)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZO","05","ZO_EQATNOM","C",020,000,"NomeEqAten","NomeEqAten","NomeEqAten","NomeEquipeAtendimento","NomeEquipeAtendimento","NomeEquipeAtendimento","@!","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZO","06","ZO_ATIVO","C",001,000,"Ativo","Ativo","Ativo","Ativo","Ativo","Ativo","@!","","€€€€€€€€€€€€€€ ","'S'","",000,"þÀ","","","U","S","A","R","€","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZO","07","ZO_TIPOSVO","C",020,000,"TiposVou","TiposVou","TiposVou","TiposdeVouchers","TiposdeVouchers","TiposdeVouchers","","","€€€€€€€€€€€€€€ ","","USZH",000,"þÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZP","01","ZP_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","V","R","","","","","","","","","033","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZP","02","ZP_ARQUIVO","C",099,000,"Arquivo","Arquivo","Arquivo","ArquivoProcessado","ArquivoProcessado","ArquivoProcessado","","","€€€€€€€€€€€€€€ ","","RCNAB",000,"þÀ","","","U","S","V","R","","File(M->ZP_ARQUIVO)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZP","03","ZP_ID","C",006,000,"IdSequenc.","IdSequenc.","IdSequenc.","IdSequencialdeprocessa","IdSequencialdeprocessa","IdSequencialdeprocessa","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZP","04","ZP_STATUS","C",001,000,"Status","Status","Status","Statusdoprocessamento","Statusdoprocessamento","Statusdoprocessamento","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","S","V","R","","","1=naoprocessado;2=distribuido;3=faturado;4=desmembrado;5=inconsistente;6=baixado","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZP","05","ZP_DATA","D",008,000,"Data","Data","Data","Datadoprocessamento","Datadoprocessamento","Datadoprocessamento","","","€€€€€€€€€€€€€€ ","DDATABASE","",000,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZP","06","ZP_HORA","C",008,000,"Hora","Hora","Hora","HoradoProcessamento","HoradoProcessamento","HoradoProcessamento","","","€€€€€€€€€€€€€€ ","TIME()","",000,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZP","07","ZP_USERLGA","C",017,000,"LogdeAlter","LogdeAlter","LogdeAlter","LogdeAlteracao","LogdeAlteracao","LogdeAlteracao","","","€€€€€€€€€€€€€€€","","",009,"þÀ","","","L","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZQ","01","ZQ_FILIAL","C",002,000,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",001,"þÀ","","","U","N","V","R","","","","","","","","","033","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZQ","03","ZQ_PEDIDO","C",008,000,"PedidoVenda","PedidoVenda","PedidoVenda","PedidodeVenda","PedidodeVenda","PedidodeVenda","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZQ","03","ZQ_LINHA","C",005,000,"Linha","Linha","Linha","LinhadoArquivo","LinhadoArquivo","LinhadoArquivo","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZQ","04","ZQ_ID","C",006,000,"IdArquivo","IdArquivo","IdArquivo","IddoArquivo","IddoArquivo","IddoArquivo","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZQ","05","ZQ_NF1","C",012,000,"NFProduto","NFProduto","NFProduto","NotaFiscaldeProduto","NotaFiscaldeProduto","NotaFiscaldeProduto","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZQ","06","ZQ_NF2","C",012,000,"NFServico","NFServico","NFServico","NotaFiscaldeServico","NotaFiscaldeServico","NotaFiscaldeServico","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZQ","07","ZQ_DATA","D",008,000,"Data","Data","Data","Data","Data","Data","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZQ","08","ZQ_STATUS","C",001,000,"Status","Status","Status","StatusdaLinha","StatusdaLinha","StatusdaLinha","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","1=NaoProcessado;2=Distribuido;3=Faturado;4=Desmenbrado;5=Inconsistente;6=Baixado","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZQ","09","ZQ_HORA","C",008,000,"HORA","HORA","HORA","HORA","HORA","HORA","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZQ","10","ZQ_OCORREN","C",050,000,"Ocorrencia","Ocorrencia","Ocorrencia","Ocorrencia","Ocorrencia","Ocorrencia","","","€€€€€€€€€€€€€€ ","","",000,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX7  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX7()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"C6_OPER","001","MaTesInt(2,,M->C5_CLIENT,M->C5_LOJAENT,If(M->C5_TIPO$'DB','F','C'),M->C6_PRODUTO,'C6_TES')","C6_TES","P","N","",000,"","","S"})
AADD(aRegs,{"C6_OPER","002","CodSitTri()","C6_CLASFIS","P","N","",000,"","","S"})
AADD(aRegs,{"C6_OPER","003","M->C6_OPER","C6_XOPER","P","N","",000,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"DA1_CODCOB","001","Posicione('PA8',1,xFilial('PA8')+M->DA1_CODCOB ,'PA8_CODBPG')                                       ","DA1_CODGAR","P","N","   ",000,"                                                                                                    ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"DA1_CODPRO","001","SB1->B1_DESC","DA1_DESCRI","P","S","SB1",001,"xFilial('SB1')+M->DA1_CODPRO","","S"})
AADD(aRegs,{"DA1_CODPRO","002","SB1->B1_PRV1","DA1_PRCBAS","P","S","SB1",001,"xFilial('SB1')+M->DA1_CODPRO","","S"})
AADD(aRegs,{"DA1_CODPRO","003","Space(Len(SBM->BM_GRUPO))","DA1_GRUPO","P","N","",000,"","!Empty(M->DA1_CODPRO)","S"})
AADD(aRegs,{"DA1_CODPRO","004","Space(Len(DA1->DA1_REFGRD))","DA1_REFGRD","P","N","",000,"","!Empty(M->DA1_CODPRO)","S"})
AADD(aRegs,{"DA1_CODPRO","005","Posicione('SB1',1,xFilial('SB1')+M->DA1_CODPRO,'B1_DESC')","DA1_DESCRI","P","N","",000,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_CDPRGAR","001","PA8->PA8_CODMP8                                                                                     ","ZF_PRODUTO","P","S","PA8",001,"xFilial('PA8')+M->ZF_CDPRGAR                                                                        ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_MOTOCO ","001","X5DESCRI()                                                                                          ","ZF_DESMOT ","P","S","SX5",001,"xFilial('SX5')+'ZF'+ M->ZF_MOTOCO                                                                   ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_PEDIDO","001","U_VNDA450('ZF_AC',M->ZF_PEDIDO)","ZF_AC","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","002","U_VNDA450('ZF_AR',M->ZF_PEDIDO)","ZF_AR","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","003","U_VNDA450('ZF_CDPRGAR',M->ZF_PEDIDO)","ZF_CDPRGAR","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","004","U_VNDA450('ZF_CGCCLI',M->ZF_PEDIDO)","ZF_CGCCLI","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","005","U_VNDA450('ZF_NOMCLI',M->ZF_PEDIDO)","ZF_NOMCLI","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","006","U_VNDA450('ZF_DTVLPGO',M->ZF_PEDIDO)","ZF_DTVLPGO","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","007","U_VNDA230(M->ZF_PEDIDO)","ZF_PEDVEND","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","008","U_VNDA220(M->ZF_PEDIDO,'52')","ZF_NFVENOR","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","009","U_VNDA220(M->ZF_PEDIDO,'51')","ZF_NFSEROR","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","010","U_VNDA220(M->ZF_PEDIDO,'53')","ZF_NFENTOR","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","011","U_VNDA450('ZF_CODSTAT',M->ZF_PEDIDO)","ZF_CODSTAT","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","012","U_VNDA450('ZF_STCERPD',M->ZF_PEDIDO)","ZF_STCERPD","P","N","",000,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_PRODEST","001","SB1->B1_DESC","ZF_PRODESC","P","S","SB1",001,"xFilial('SB1')+M->ZF_PRODEST","","U"})
AADD(aRegs,{"ZF_PRODEST","002","PA8->PA8_CODBPG","ZF_PDESGAR","P","S","PA8",002,"xFilial('PA8')+M->ZF_PRODEST","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_PRODUTO","001","SB1->B1_DESC                                                                                        ","ZF_DESPRO ","P","S","SB1",001,"xFilial('SB1')+M->ZF_PRODUTO                                                                        ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_QTDVOUC","001","M->ZF_QTDVOUC","ZF_SALDO","P","N","",000,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_TIPOVOU","001","SZH->ZH_DESCRI","ZF_DESTIPO","P","S","SZH",001,"xFilial('SZH')+M->ZF_TIPOVOU","","U"})
AADD(aRegs,{"ZF_TIPOVOU","002","U_VNDA170('ZF_EMNTVEN')","ZF_EMNTVEN","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","003","U_VNDA170('ZF_TPOPSER')","ZF_TPOPSER","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","004","U_VNDA170('ZF_TPOPP')","ZF_TPOPP","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","005","U_VNDA170('ZF_ALBIVE')","ZF_ALBIVE","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","006","U_VNDA170('ZF_EMNTENT')","ZF_EMNTENT","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","007","U_VNDA170('ZF_TPOPENT')","ZF_TPOPENT","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","008","U_VNDA170('ZF_ARQEST')","ZF_ARQEST","P","N","",000,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","009","U_VNDA170('ZF_TPMOVIM')","ZF_TPMOVIM","P","N","",000,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZI_PROGAR","001","Posicione('PA8',1,xFilial('PA8')+M->ZI_PROGAR,'PA8_CODMP8')","ZI_PROKIT","P","N","",000,"","","U"})
AADD(aRegs,{"ZI_PROGAR","002","u_ConsKit()","ZI_PROKIT","P","N","",000,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZI_PROKIT","001","SB1->B1_DESC","ZI_DESCKIT","P","S","SB1",001,"xFilial('SB1')+M->ZI_PROKIT","","U"})
AADD(aRegs,{"ZI_PROKIT","002","u_ConsKit()","ZI_PROKIT","P","N","",000,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZI_TABPRE ","001","Posicione('DA0',1,xFilial('DA0')+M->ZI_TABPRE ,'DA0_DESCRI')                                        ","ZI_DESCPRE","P","N","DA0",000,"                                                                                                    ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZL_ASSUNTO","001","X5DESCRI()","ZL_DESCASS","P","S","SX5",001,"xFilial('SX5')+'T1'+M->ZL_ASSUNTO","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZL_GRUPO  ","001","SQ0->Q0_DESCRIC                                                                                     ","ZL_DESCGRU","P","S","SQ0",001,"xFilial('SQ0')+M->ZL_GRUPO                                                                          ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZL_OCORREN","001","SU9->U9_DESC","ZL_DESCOCO","P","S","SU9",002,"xFilial('SU9')+M->ZL_OCORREN","","U"})
AADD(aRegs,{"ZL_OCORREN","002","SU9->U9_ASSUNTO","ZL_ASSUNTO","P","S","SU9",002,"xFilial('SU9')+M->ZL_OCORREN","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZL_PRODUTO","001","SB1->B1_DESC","ZL_DESCPRO","P","N","SB1",001,"xFilial('SB1')+M->ZL_PRODUTO","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZO_CODUSER","001","UsrRetName(M->ZO_CODUSER)","ZO_NOMUSER","P","N","",000,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZO_EQATEND","001","Posicione('SX5',1,xFilial('SX5')+'ZO'+M->ZO_EQATEND,'X5_DESCRI')","ZO_EQATNOM","P","N","",000,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX7 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSIX  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSIX()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"DA0","1","DA0_FILIAL+DA0_CODTAB                                                                                                                                           ","Cod. Tabela                                                           ","Cod. Tabla                                                            ","Table Code                                                            ","S","XXX                                                                                                                                                             ","          ","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"DA1","1","DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM","Cod.Tabela+Cod.Produto+Faixa+Item","Cod.Tabla+Cod.Producto+Intervalo+Item","TableCode+ProductCode+Range+Item","S","","","S"})
AADD(aRegs,{"DA1","2","DA1_FILIAL+DA1_CODPRO+DA1_CODTAB+DA1_ITEM","Cod.Produto+Cod.Tabela+Item","Cod.Producto+Cod.Tabla+Item","ProductCode+TableCode+Item","S","","","S"})
AADD(aRegs,{"DA1","3","DA1_FILIAL+DA1_CODTAB+DA1_ITEM","Cod.Tabela+Item","Cod.Tabla+Item","TableCode+Item","S","","","S"})
AADD(aRegs,{"DA1","4","DA1_FILIAL+DA1_CODTAB+DA1_GRUPO+DA1_INDLOT+DA1_ITEM","Cod.Tabela+Grupo+Faixa+Item","Cod.Tabla+Grupo+Intervalo+Item","TableCode+Group+Range+Item","S","","","S"})
AADD(aRegs,{"DA1","5","DA1_FILIAL+DA1_CODTAB+DA1_REFGRD+DA1_INDLOT+DA1_ITEM","Cod.Tabela+RefGrad/CFG+Faixa+Item","Cod.Tabla+RefGrad/CFG+Intervalo+Item","TableCode+RefGrad/CFG+Range+Item","S","","","S"})
AADD(aRegs,{"DA1","6","DA1_FILIAL+DA1_REFGRD+DA1_CODTAB+DA1_ITEM","RefGrad/CFG+Cod.Tabela+Item","RefGrad/CFG+Cod.Tabla+Item","RefGrad/CFG+TableCode+Item","S","","","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
ADD(aRegs,{"SC5","1","C5_FILIAL+C5_NUM","Numero","Numero","Number","S","","","S"})
AADD(aRegs,{"SC5","2","C5_FILIAL+DTOS(C5_EMISSAO)+C5_NUM","DTEmissao+Numero","FchEmision+Numero","IssueDate+Number","S","","","S"})
AADD(aRegs,{"SC5","3","C5_FILIAL+C5_CLIENTE+C5_LOJACLI+C5_NUM","Cliente+Loja+Numero","Cliente+Tienda+Numero","Customer+Unit+Number","S","CLI","","S"})
AADD(aRegs,{"SC5","4","C5_FILIAL+C5_OS","Geradop/OS","Nr.OSGenera","Gen.f/S.O.","S","","","S"})
AADD(aRegs,{"SC5","5","C5_FILIAL+C5_CHVBPAG","No.PedGAR","No.PedGAR","No.PedGAR","U","","","S"})
AADD(aRegs,{"SC5","6","C5_FILIAL+C5_NOTA+C5_SERIE","NotaFiscal+Serie","Factura+Serie","Invoice+Serie","U","","","S"})
AADD(aRegs,{"SC5","7","C5_FILIAL+C5_ATDTLV","Atend.TLV.","Atend.TLV.","Atend.TLV.","U","","ATENDTLV","S"})
AADD(aRegs,{"SC5","8","C5_FILIAL+C5_XNPSITE","NumPedSite","NumPedSite","NumPedSite","U","","PEDSITE","S"})
AADD(aRegs,{"SC5","9","C5_FILIAL+C5_XORIGPV","OrigemP.V.","OrigemP.V.","OrigemP.V.","U","","","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SC6","1","C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO","Num.Pedido+Item+Produto","NroPedido+Item+Producto","OrderNumber+Item+Product","S","XXX+XXX+SB1","","S"})
AADD(aRegs,{"SC6","2","C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM","Produto+Num.Pedido+Item","Producto+NroPedido+Item","Product+OrderNumber+Item","S","SB1","","S"})
AADD(aRegs,{"SC6","3","C6_FILIAL+DTOS(C6_ENTREG)+C6_NUM+C6_ITEM","Entrega+Num.Pedido+Item","Entrega+NroPedido+Item","Delivery+OrderNumber+Item","S","","","S"})
AADD(aRegs,{"SC6","4","C6_FILIAL+C6_NOTA+C6_SERIE","NotaFiscal+SerieNF","Factura+SerieFact.","Invoice+Series","S","","","S"})
AADD(aRegs,{"SC6","5","C6_FILIAL+C6_CLI+C6_LOJA+C6_PRODUTO+C6_NFORI+C6_SERIORI+C6_ITEMORI","Cliente+Loja+Produto+N.F.Original+SerieOrig.+ItemNF.Orig","Cliente+Tienda+Producto+FacturaOrig+SerieOrig.+ItemFact.O","Customer+Unit+Product+OriginalInv+Orig.Series+Src.Inv.Item","S","SA1+XXX+SB1","","S"})
AADD(aRegs,{"SC6","6","C6_FILIAL+C6_CONTRT+C6_TPCONTR+C6_ITCONTR","Contrato+TipoContrat+It.Contrato","Contrato+TipoContrat+It.Contrato","Contract+Contr.Type+ContractIt.","S","","","S"})
AADD(aRegs,{"SC6","7","C6_FILIAL+C6_NUMOP+C6_ITEMOP","NumeroOP+ItemdaOP","Num.Ord.Prod+ItemdeOP","PONumber+Pr.Ord.Item","S","","","S"})
AADD(aRegs,{"SC6","8","C6_FILIAL+C6_PROJPMS+C6_TASKPMS+C6_EDTPMS","Cod.Projeto+Cod.Tarefa+Cod.EDT","Cod.Proyecto+Cod.Tarea+Cod.EDT","ProjectCode+TaskCode+WBSCode","S","AF8+AF9+AFC","","S"})
AADD(aRegs,{"SC6","9","C6_FILIAL+C6_NUMSC+C6_ITEMSC","NumeroSC+ItemSC","NumeroSC+ItemSC","PRnumber+PRItem","S","","","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZ3","1","Z3_FILIAL+Z3_CODENT","CodEntidade","CodEntidade","CodEntidade","U","","","S"})
AADD(aRegs,{"SZ3","2","Z3_FILIAL+Z3_DESENT","DescrEntid.","DescrEntid.","DescrEntid.","U","","","S"})
AADD(aRegs,{"SZ3","3","Z3_FILIAL+Z3_CODFOR","CodFornec.","CodFornec.","CodFornec.","U","","","S"})
AADD(aRegs,{"SZ3","4","Z3_FILIAL+Z3_CODGAR","EntnoGAR","EntnoGAR","EntnoGAR","U","","COD.GAR.","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZ5","1","Z5_FILIAL+Z5_PEDGAR","PedidoGAR","PedidoGAR","PedidoGAR","U","","","S"})
AADD(aRegs,{"SZ5","2","Z5_FILIAL+Z5_FLAGA","FlagAtualiza","FlagAtualiza","FlagAtualiza","U","","","N"})
AADD(aRegs,{"SZ5","3","Z5_FILIAL+Z5_PEDIDO+Z5_ITEMPV","Pedido+item","Pedido+item","Pedido+item","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZG","1","ZG_FILIAL+ZG_NUMPED+ZG_ITEMPED+ZG_NUMVOUC","NumPedido+ItemPedido+NumVoucher","NumPedido+ItemPedido+NumVoucher","NumPedido+ItemPedido+NumVoucher","U","","","N"})
AADD(aRegs,{"SZG","2","ZG_FILIAL+ZG_PEDIDO","Filial+PedidoGAR","Filial+PedidoGAR","Filial+PedidoGAR","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","1","ZH_FILIAL+ZH_TIPO                                                                                                                                               ","Cod Tipo Vou                                                          ","Cod Tipo Vou                                                          ","Cod Tipo Vou                                                          ","U","                                                                                                                                                                ","          ","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZI","1","ZI_FILIAL+ZI_COMBO","Combo","Combo","Combo","U","","","S"})
AADD(aRegs,{"SZI","2","ZI_FILIAL+ZI_TABPRE+ZI_DESCPRE","TabdePreco+DescTabPre","TabdePreco+DescTabPre","TabdePreco+DescTabPre","U","","","N"})
AADD(aRegs,{"SZI","3","ZI_FILIAL+ZI_PROGAR","ProdutoGAR","ProdutoGAR","ProdutoGAR","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZJ","1","ZJ_FILIAL+ZJ_COMBO","Combo","Combo","Combo","U","","","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZO","1","ZO_FILIAL+ZO_CODUSER+ZO_EQATEND","CodUsuario+EquipeAtend","CodUsuario+EquipeAtend","CodUsuario+EquipeAtend","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZP","1","ZP_FILIAL+ZP_ID","Id","Id","Id","U","","","N"})
AADD(aRegs,{"SZP","2","ZP_FILIAL+ZP_ARQUIVO","Arquivo","Arquivo","Arquivo","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZQ","1","ZQ_FILIAL+ZQ_ID+ZQ_LINHA","IdeLinha","IdeLinha","IdeLinha","U","","","N"})
AADD(aRegs,{"SZQ","2","ZQ_FILIAL+ZQ_PEDIDO","Pedido","Pedido","Pedido","U","","","N"})
AADD(aRegs,{"SZQ","3","ZQ_FILIAL+ZQ_ID+ZQ_STATUS","idestatus","idestatus","idestatus","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SIX : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSXB  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSXB()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"CCNAB","1","01","RE","ConsultaArqCNAB","ConsultaArqCNAB","ConsultaArqCNAB","SB1",""})
AADD(aRegs,{"CCNAB","2","01","01","","","","U_VdGetDir()",""})
AADD(aRegs,{"CCNAB","5","01","","","","","U_VdRetDir()",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"DA1COB","1","01","DB","CODIGOCOMBO","CODIGOCOMBO","CODIGOCOMBO","SZI",""})
AADD(aRegs,{"DA1COB","2","01","01","Combo","Combo","Combo","",""})
AADD(aRegs,{"DA1COB","4","01","01","Combo","Combo","Combo","ZI_COMBO",""})
AADD(aRegs,{"DA1COB","5","01","","","","","SZI->ZI_COMBO",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"PA8","1","01","DB","Produto","Produto","Produto","PA8",""})
AADD(aRegs,{"PA8","2","01","01","CodigodeProdutoBp","CodigodeProdutoBp","CodigodeProdutoBp","PA8_01",""})
AADD(aRegs,{"PA8","4","01","01","CodigoBpag","CodigoBpag","CodigoBpag","PA8_CODBPG",""})
AADD(aRegs,{"PA8","4","01","02","DescriBpag","DescriBpag","DescriBpag","PA8_DESBPG",""})
AADD(aRegs,{"PA8","5","01","","","","","PA8->PA8_CODBPG",""})
AADD(aRegs,{"PA8","5","02","","","","","PA8->PA8_DESBPG",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"RCNAB","1","01","RE","RETORNOCNAB","RETORNOCNAB","RETORNOCNAB","",""})
AADD(aRegs,{"RCNAB","2","01","01","","","","U_VNDA210()",""})
AADD(aRegs,{"RCNAB","5","01","","","","","cRetCnab",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZ1","1","01","DB","SEGMENTO","SEGMENTO","SEGMENTO","SZ1",""})
AADD(aRegs,{"SZ1","2","01","01","Cod+Segmento","Cod+Segmento","Cod+Segmento","",""})
AADD(aRegs,{"SZ1","3","01","01","CadastraNovo","IncluyeNuevo","AddNew","01",""})
AADD(aRegs,{"SZ1","4","01","01","Filial","Sucursal","Branch","Z1_FILIAL",""})
AADD(aRegs,{"SZ1","4","01","02","CODCANAL","CODCANAL","CODCANAL","Z1_CODSEG",""})
AADD(aRegs,{"SZ1","4","01","03","DESCRICAO","DESCRICAO","DESCRICAO","Z1_DESCSEG",""})
AADD(aRegs,{"SZ1","5","01","","","","","SZ1->Z1_CODSEG",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZF","1","01","DB","CadastroVoucher","CadastroVoucher","CadastroVoucher","SZF",""})
AADD(aRegs,{"SZF","2","01","01","Cod.Voucher","Cod.Voucher","Cod.Voucher","",""})
AADD(aRegs,{"SZF","4","01","01","Cod.Voucher","Cod.Voucher","Cod.Voucher","ZF_COD",""})
AADD(aRegs,{"SZF","4","01","02","Produto","Produto","Produto","ZF_PRODUTO",""})
AADD(aRegs,{"SZF","4","01","03","Quantidade","Quantidade","Quantidade","ZF_QTDVOUC",""})
AADD(aRegs,{"SZF","4","01","04","Val.Voucher","Val.Voucher","Val.Voucher","ZF_DTVALID",""})
AADD(aRegs,{"SZF","5","01","","","","","SZF->ZF_COD",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","1","01","DB","TiposdeVoucher","TiposdeVoucher","TiposdeVoucher","SZH",""})
AADD(aRegs,{"SZH","2","01","01","CodTipoVou","CodTipoVou","CodTipoVou","",""})
AADD(aRegs,{"SZH","3","01","01","CadastraNovo","IncluyeNuevo","AddNew","01",""})
AADD(aRegs,{"SZH","4","01","01","TipoVoucher","TipoVoucher","TipoVoucher","ZH_TIPO",""})
AADD(aRegs,{"SZH","4","01","02","DesTipoVou","DesTipoVou","DesTipoVou","ZH_DESCRI",""})
AADD(aRegs,{"SZH","5","01","","","","","SZH->ZH_TIPO",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZI","1","01","DB","TABELADEPRECO","TABELADEPRECO","TABELADEPRECO","SZI",""})
AADD(aRegs,{"SZI","2","01","02","TabdePreco+descTa","TabdePreco+descTa","TabdePreco+descTa","",""})
AADD(aRegs,{"SZI","4","01","01","TabdePreco","TabdePreco","TabdePreco","ZI_TABPRE",""})
AADD(aRegs,{"SZI","4","01","02","DescTabPre","DescTabPre","DescTabPre","ZI_DESCPRE",""})
AADD(aRegs,{"SZI","4","01","03","Combo","Combo","Combo","ZI_COMBO",""})
AADD(aRegs,{"SZI","5","01","","","","","SZI->ZI_TABPRE",""})
AADD(aRegs,{"SZI","5","02","","","","","SZI->ZI_COMBO",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"USZH","1","01","RE","TiposVoucUsuarios","TiposVoucUsuarios","TiposVoucUsuarios","SZH",""})
AADD(aRegs,{"USZH","2","01","01","","","",".T.",""})
AADD(aRegs,{"USZH","5","01","","","","","U_VNDA400()",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZPARQ","1","01","RE","ArquivoCnab","ArquivoCnab","ArquivoCnab","",""})
AADD(aRegs,{"ZPARQ","2","01","01","","","","U_VNDA210()",""})
AADD(aRegs,{"ZPARQ","5","01","","","","","U_VNDA210()",""})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SXB : ' + cTexto  + CHR(13) + CHR(10))
