#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ-ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ UPDSDK06  ³ Autor ³ MICROSIGA             ³ Data ³ 18/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Principal                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CERTISIGN                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UPDSDK06()

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

Processa({|| ProcATU()},"Processando [UPDSDK06]","Aguarde , processando preparação dos arquivos")

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
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0
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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Arquivos...")
			cTexto += GeraSX2()    
			
			IncProc("Analisando indices de Arquivos...")
			cTexto += GeraSIX()    
			
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
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Consulta padroes...")
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
			DEFINE MSDIALOG oDlg TITLE "Atualizador [UPDSDK06] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
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
AADD(aRegs,{"SZR","                                        ","SZR010  ","CONTAS X ABERTURA ATENDIMENTOS","CONTAS X ABERTURA ATENDIMENTOS","CONTAS X ABERTURA ATENDIMENTOS","                                        ","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              "})

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
AADD(aRegs,{"SZS","                                        ","SZS010  ","REGRAS DE EMAIL               ","REGRAS DE EMAIL               ","REGRAS DE EMAIL               ","                                        ","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              "})

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
AADD(aRegs,{"SZR","01","ZR_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZR","02","ZR_SERVER","C",40,00,"ServerMail","ServerMail","ServerMail","ServidorPop3","ServidorPop3","ServidorPop3","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","03","ZR_CTAMAIL","C",40,00,"Contae-mail","Contae-mail","Contae-mail","Contase-mail","Contase-mail","Contase-mail","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","EXISTCHAV('SZR',M->ZR_CTAMAIL,2)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","04","ZR_PASMAIL","C",40,00,"SenhaConta","SenhaConta","SenhaConta","SenhadaConta","SenhadaConta","SenhadaConta","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","05","ZR_GRPSDK","C",02,00,"Grupo","Grupo","Grupo","Grupo","Grupo","Grupo","","","€€€€€€€€€€€€€€ ","","GRUPO",00,"şÀ","","S","U","S","A","R","€","EXISTCPO('SU0',M->ZR_GRPSDK)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","06","ZR_DSCGRUP","C",30,00,"Desc.Grupo","Desc.Grupo","Desc.Grupo","Desc.Grupo","Desc.Grupo","Desc.Grupo","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SU0',1,XFILIAL('SU0')+SZR->ZR_GRPSDK,'U0_NOME'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","07","ZR_ASSSDK","C",06,00,"Assunto","Assunto","Assunto","CodigodoAssunto","CodigodoAssunto","CodigodoAssunto","","","€€€€€€€€€€€€€€ ","","SBJNEW",00,"şÀ","","S","U","N","A","R","€","EXISTCPO('EXISTCPO('SX5','T1'+M->ZR_ASSSDK).OR.EMPTY(M->ZR_ASSSDK)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","08","ZR_DESCASS","C",30,00,"Descricao","Descricao","Descricao","DescricaoAssunto","DescricaoAssunto","DescricaoAssunto","","","€€€€€€€€€€€€€€ ","IIF(!EMPTY(SZR->ZR_ASSSDK),IIF(!INCLUI,TABELA('T1',SZR->ZR_ASSSDK),''),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","09","ZR_OCOSDK","C",06,00,"Ocorrencia","Ocorrencia","Ocorrencia","CodigodaOcorrencia","CodigodaOcorrencia","CodigodaOcorrencia","","","€€€€€€€€€€€€€€ ","","SU9NEW",00,"şÀ","","S","U","N","A","R","€","EXISTCPO('SU9',M->ZR_OCOSDK,2)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","10","ZR_DESCOCO","C",30,00,"Descricao","Descricao","Descricao","DescricaoOcorrencia","DescricaoOcorrencia","DescricaoOcorrencia","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SU9',2,XFILIAL('SU9')+SZR->ZR_OCOSDK,'U9_DESC'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","11","ZR_ACASDK","C",06,00,"Acao","Acao","Acao","CodigodaAcao","CodigodaAcao","CodigodaAcao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","S","U","N","V","R","","EXISTCPO('SUQ',M->ZR_ACASDK)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","12","ZR_DESCACA","C",55,00,"Descricao","Descricao","Descricao","DescricaoAcao","DescricaoAcao","DescricaoAcao","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SUQ',1,XFILIAL('SUQ')+SZR->ZR_ACASDK,'UQ_DESC'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","13","ZR_OCOSDK2","C",06,00,"Ocorrencia2","Ocorrencia2","Ocorrencia2","OcorrenciaparaResposta","OcorrenciaparaResposta","OcorrenciaparaResposta","","","€€€€€€€€€€€€€€ ","","SU9",00,"şÀ","","S","U","N","A","R","€","EXISTCPO('SU9',M->ZR_OCOSDK2,2)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","14","ZR_DESCOC2","C",30,00,"Descricao","Descricao","Descricao","DescricaoOcorrencia2","DescricaoOcorrencia2","DescricaoOcorrencia2","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SU9',2,XFILIAL('SU9')+SZR->ZR_OCOSDK2,'U9_DESC'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","15","ZR_ACASDK2","C",06,00,"Acao2","Acao2","Acao2","AcaoparaResposta","AcaoparaResposta","AcaoparaResposta","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","S","U","N","V","R","","EXISTCPO('SUQ',M->ZR_ACASDK2)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","16","ZR_DESCAC2","C",55,00,"Descricao","Descricao","Descricao","DescricaoAcao2","DescricaoAcao2","DescricaoAcao2","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SUQ',1,XFILIAL('SUQ')+SZR->ZR_ACASDK2,'UQ_DESC'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","17","ZR_ATIVO","C",01,00,"Ativo","Ativo","Ativo","ContaAtivo?","ContaAtivo?","ContaAtivo?","","","€€€€€€€€€€€€€€ ","'S'","",00,"şÀ","","","U","S","A","R","€","","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","18","ZR_OPESDK","C",25,00,"Usuario","Usuario","Usuario","UsuarioProtheus","UsuarioProtheus","UsuarioProtheus","","","€€€€€€€€€€€€€€€","","US3",00,"şÀ","","","U","S","A","R","","U_ValidUser()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","19","ZR_OPENSEN","C",25,00,"Senha","Senha","Senha","SenhadoUsuario","SenhadoUsuario","SenhadoUsuario","","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","IIF(PswName(M->ZR_OPENSEN),.T.,.F.==Alert('SenhaInvalida!','Atencao'))","","","","","","","","","","","","","N","N","","N","N","N"})

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
AADD(aRegs,{"SZS","01","ZS_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZS","02","ZS_EMAIL","C",40,00,"Email","Email","Email","Email","Email","Email","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","03","ZS_ORDEM","N",03,00,"Ordem","Ordem","Ordem","Ordem","Ordem","Ordem","@999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","04","ZS_REGRA","C",40,00,"Regra","Regra","Regra","NomedaRegra","NomedaRegra","NomedaRegra","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","05","ZS_ATIVA","C",01,00,"Ativa","Ativa","Ativa","Ativa?","Ativa?","Ativa?","","","€€€€€€€€€€€€€€ ","'S'","",00,"şÀ","","","U","N","A","R","€","","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","06","ZS_GRUPO","C",02,00,"Grupo","Grupo","Grupo","Grupo","Grupo","Grupo","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","07","ZS_DESGRUP","C",30,00,"Descricao","Descricao","Descricao","Descricao","Descricao","Descricao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","08","ZS_ASSUNTO","C",06,00,"Assunto","Assunto","Assunto","Assunto","Assunto","Assunto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","09","ZS_DESASSU","C",30,00,"Descricao","Descricao","Descricao","Descricao","Descricao","Descricao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","10","ZS_OCORREN","C",06,00,"Ocorrencia","Ocorrencia","Ocorrencia","Ocorrencia","Ocorrencia","Ocorrencia","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","11","ZS_DESOCOR","C",30,00,"Descricao","Descricao","Descricao","Descricao","Descricao","Descricao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","12","ZS_ACAO","C",06,00,"Acao","Acao","Acao","Acao","Acao","Acao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","13","ZS_DESCACA","C",55,00,"Descricao","Descricao","Descricao","Descricao","Descricao","Descricao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","14","ZS_ACAO2","C",06,00,"Acao2","Acao2","Acao2","AcaodeRetorno","AcaodeRetorno","AcaodeRetorno","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","15","ZS_OCORRE2","C",06,00,"Ocorrencia2","Ocorrencia2","Ocorrencia2","OcorrenciadeRetorno","OcorrenciadeRetorno","OcorrenciadeRetorno","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","16","ZS_ENDEREC","M",10,00,"Endereco","Endereco","Endereco","PalavraChavesEndereco","PalavraChavesEndereco","PalavraChavesEndereco","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","17","ZS_ASSUNT2","M",10,00,"Assunto2","Assunto2","Assunto2","PalavraChaveAssunto","PalavraChaveAssunto","PalavraChaveAssunto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZS","18","ZS_CORPO","M",10,00,"CorpoEmail","CorpoEmail","CorpoEmail","PalavraChaveCorpoEmail","PalavraChaveCorpoEmail","PalavraChaveCorpoEmail","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
AADD(aRegs,{"ZR_GRPSDK","001","POSICIONE('SU0',1,XFILIAL('SU0')+M->ZR_GRPSDK,'U0_NOME')","ZR_DSCGRUP","P","N","",00,"","","U"})

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
AADD(aRegs,{"ZR_ASSSDK","001","TABELA('T1',M->ZR_ASSSDK)","ZR_DESCASS","P","N","",00,"","","U"})

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
AADD(aRegs,{"ZR_OCOSDK","001","POSICIONE('SU9',2,XFILIAL('SU9')+M->ZR_OCOSDK,'U9_DESC')","ZR_DESCOCO","P","N","",00,"","","U"})

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
AADD(aRegs,{"ZR_ACASDK","001","POSICIONE('SUQ',1,XFILIAL('SUQ')+M->ZR_ACASDK,'UQ_DESC')","ZR_DESCACA","P","N","",00,"","","U"})

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
AADD(aRegs,{"ZR_OCOSDK2","001","POSICIONE('SU9',2,XFILIAL('SU9')+M->ZR_OCOSDK2,'U9_DESC')","ZR_DESCOC2","P","N","",00,"","","U"})

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
AADD(aRegs,{"ZR_ACASDK2","001","POSICIONE('SUQ',1,XFILIAL('SUQ')+M->ZR_ACASDK2,'UQ_DESC')","ZR_DESCAC2","P","N","",00,"","","U"})

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
AADD(aRegs,{"ZR_OCOSDK","001","POSICIONE('SU9',2,XFILIAL('SU9')+M->ZR_OCOSDK,'U9_DESC')","ZR_DESCOCO","P","N","",00,"","","U"})
AADD(aRegs,{"ZR_OCOSDK","002","POSICIONE('SUR',1,XFILIAL('SUR')+M->ZR_OCOSDK+'0000001'+'0000002','UR_CODSOL')","ZR_ACASDK","P","N","",00,"","","U"})
AADD(aRegs,{"ZR_OCOSDK","003","POSICIONE('SUQ',1,XFILIAL('SUQ')+M->ZR_ACASDK,'UQ_DESC')","ZR_DESCACA","P","N","",00,"","","U"})

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
AADD(aRegs,{"ZR_OCOSDK2","001","POSICIONE('SU9',2,XFILIAL('SU9')+M->ZR_OCOSDK2,'U9_DESC')","ZR_DESCOC2","P","N","",00,"","","U"})
AADD(aRegs,{"ZR_OCOSDK2","002","POSICIONE('SUR',1,XFILIAL('SUR')+M->ZR_OCOSDK2+'0000001'+'0000002','UR_CODSOL')","ZR_ACASDK2","P","N","",00,"","","U"})
AADD(aRegs,{"ZR_OCOSDK2","003","POSICIONE('SUQ',1,XFILIAL('SUQ')+M->ZR_ACASDK2,'UQ_DESC')","ZR_DESCAC2","P","N","",00,"","","U"})

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
AADD(aRegs,{"SZR","1","ZR_FILIAL+ZR_GRPSDK","Grupo","Grupo","Grupo","U","","GRUPO","S"})
AADD(aRegs,{"SZR","2","ZR_FILIAL+ZR_CTAMAIL","Contae-mail","Contae-mail","Contae-mail","U","","CTA_EMAIL","S"})
AADD(aRegs,{"SZR","3","ZR_FILIAL+ZR_OPESDK","Usuario","Usuario","Usuario","U","","USUARIO","S"})

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
AADD(aRegs,{"SZS","1","ZS_FILIAL+ZS_EMAIL+ZS_ORDEM","Email+Ordem","Email+Ordem","Email+Ordem","U","","","N"})
AADD(aRegs,{"SZS","2","ZS_FILIAL+ZS_REGRA+ZS_EMAIL","Regra","Regra","Regra","U","","","N"})

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
AADD(aRegs,{"SU9NEW","1","01","DB","SU9NEW              ","SU9NEW              ","Cadastro Ocorrencias","SU9                                                                                                                                                                                                                                                       ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NEW","2","01","02","Codigo              ","Codigo              ","Code                ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NEW","4","01","01","Codigo              ","Codigo              ","Code                ","U9_CODIGO                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NEW","4","01","02","Assunto             ","Asunto              ","Subject             ","U9_ASSUNTO                                                                                                                                                                                                                                                ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NEW","4","01","03","Ocorrencia          ","Evento              ","Occurrence          ","U9_DESC                                                                                                                                                                                                                                                   ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NEW","5","01","  ","                    ","                    ","                    ","SU9->U9_CODIGO                                                                                                                                                                                                                                            ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NEW","6","01","  ","                    ","                    ","                    ","U9_ASSUNTO==M->ZR_ASSSDK                                                                                                                                                                                                                                  ","                                                                                                                                                                                                                                                          "})

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
AADD(aRegs,{"SU9NE2","1","01","DB","SU9NEW              ","SU9NE2              ","Cadastro Ocorrencias","SU9                                                                                                                                                                                                                                                       ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NE2","2","01","02","Codigo              ","Codigo              ","Code                ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NE2","4","01","01","Codigo              ","Codigo              ","Code                ","U9_CODIGO                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NE2","4","01","02","Assunto             ","Asunto              ","Subject             ","U9_ASSUNTO                                                                                                                                                                                                                                                ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NE2","4","01","03","Ocorrencia          ","Evento              ","Occurrence          ","U9_DESC                                                                                                                                                                                                                                                   ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NE2","5","01","  ","                    ","                    ","                    ","SU9->U9_CODIGO                                                                                                                                                                                                                                            ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SU9NE2","6","01","  ","                    ","                    ","                    ","U9_ASSUNTO==_cAssunto                                                                                                                                                                                                                                  ","                                                                                                                                                                                                                                                          "})

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
AADD(aRegs,{"SBJNEW","1","01","RE","Assuntos            ","Asuntos             ","Subjects            ","SX5                                                                                                                                                                                                                                                       ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SBJNEW","2","01","01","                    ","                    ","                    ","U_ASSUNTONEW()                                                                                                                                                                                                                                              ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"SBJNEW","5","01","  ","                    ","                    ","                    ","SX5->X5_CHAVE                                                                                                                                                                                                                                             ","                                                                                                                                                                                                                                                          "})

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

aRegs  := {}
AADD(aRegs,{"GRUPO ","1","01","DB","GRUPO ZR            ","GRUPO ZR            ","GRUPO ZR            ","SU0                                                                                                                                                                                                                                                       ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"GRUPO ","2","01","01","Grupo               ","Grupo               ","Position            ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"GRUPO ","2","02","02","Descricao           ","Descripcion         ","Description         ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"GRUPO ","4","01","01","Grupo               ","Grupo               ","Position            ","U0_CODIGO                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"GRUPO ","4","01","02","Descricao           ","Descripcion         ","Description         ","U0_NOME                                                                                                                                                                                                                                                   ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"GRUPO ","4","02","01","Descricao           ","Descripcion         ","Description         ","U0_NOME                                                                                                                                                                                                                                                   ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"GRUPO ","4","02","02","Grupo               ","Grupo               ","Position            ","U0_CODIGO                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"GRUPO ","5","01","  ","                    ","                    ","                    ","SU0->U0_CODIGO                                                                                                                                                                                                                                            ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"GRUPO ","6","01","  ","                    ","                    ","                    ","IIF(!(lAdmin .or. lGrupoAdmin),SU0->U0_CODIGO$cGrupos,.T.)                                                                                                                                                                                                ","                                                                                                                                                                                                                                                          "})

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

Return('SXB : ' + cTexto  + CHR(13) + CHR(10))