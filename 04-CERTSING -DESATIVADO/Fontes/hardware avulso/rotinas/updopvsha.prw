#INCLUDE "protheus.ch"
                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³UPDOPVSHA  ³ Autor ³ Darcio Ribeiro Sporl  ³ Data ³ 28.06.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualizacao dos dicionarios Certisign       				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Opvs X Certisign					                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UPDOPVSHA()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis                                                       |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpca			:= 0
Local aSays			:= {}, aButtons := {}   
Local aRecnoSM0		:= {}  
Local lOpen			:= .F.  
Private cMessage
Private aArqUpd		:= {}
Private aREOPEN		:= {} 
Private oMainWnd 
Private cCadastro	:= "Compatibilizador de Dicionários x Banco de dados"
Private cCompat		:= "UPDOPVSCERT"
Private cFnc		:= "Atualização Certisign"
Private cRef		:= "Compatibilização de Dicionário Hardware Avulso"
Set Dele On      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta texto para janela de processamento                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aSays,"Esta rotina irá efetuar a compatibilização dos dicionários e banco de dados.")
aadd(aSays,cFnc)
aadd(aSays,"   Referência: " + cRef)
aadd(aSays," ")
aadd(aSays,"Atenção: efetuar backup dos dicionários e do banco de dados previamente ")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta botoes para janela de processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch() }} )
aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch() }} )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe janela de processamento                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FormBatch( cCadastro, aSays, aButtons,, 230 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa calculo                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  nOpca == 1
	If  MsgYesNo("Deseja confirmar o processamento do compatibilizador ?") //Aviso("Compatibilizador", "Deseja confirmar o processamento do compatibilizador ?", {"Sim","Não"}) == 1
          Processa({||UpdEmp(aRecnoSM0,lOpen)},"Processando","Aguarde, processando preparação dos arquivos",.F.)
    Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim do programa                                                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
Static Function ProcATU(lEnd,aRecnoSM0,lOpen)
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0

ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")

	If lOpen   
		lSel:=.F.
		For nI := 1 To Len(aRecnoSM0)
			if ! aRecnoSM0[nI,1]
				loop
			Endif 
			lSel:=.T.
			
			SM0->(dbGoto(aRecnoSM0[nI,2]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
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
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza o dicionario de dados.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Analisando Dicionario de Dados...")
				cTexto += GeraSX3()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza os parametros.        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Analisando Paramêtros...")
		 		cTexto += GeraSX6()
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
	 			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Inclui tabela padrao.       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Analisando Tabela Padrão...")
	 			cTexto += IncSX5()
			
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
			
			cTexto := "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			
				If !lSel 
					cTexto+= "Não foram selecionadas nenhuma empresa para Atualização"
				Endif
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [" + cCompat + "] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
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

If Select("SM0") > 0
	DbSelectArea("SM0")
	SM0->(DbCloseArea())
EndIf

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
Local aArea		:= GetArea()
Local i			:= 0
Local j			:= 0
Local aRegs		:= {}
Local cTexto	:= ''
Local lInclui	:= .F.

aRegs  := {}
AADD(aRegs,{"SZF","\DATA\                                  ","SZF010  ","CADASTRO VOUCHER              ","CADASTRO VOUCHER              ","CADASTRO VOUCHER              ","                                        ","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              "})

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
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZG","\DADOS\                                 ","SZG010  ","MOVIMETACAO VOUCHER           ","MOVIMETACAO VOUCHER           ","MOVIMETACAO VOUCHER           ","                                        ","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              "})

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
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","\DATA\                                  ","SZH010  ","TIPOS DE VOUCHER              ","TIPOS DE VOUCHER              ","TIPOS DE VOUCHER              ","                                        ","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              "})

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
		Next j
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
Local aArea		:= GetArea()
Local i			:= 0
Local j      	:= 0
Local aRegs		:= {}
Local cTexto	:= ''
Local lInclui	:= .F.
Local cHelp		:= ''
Local aHelp		:= {}
Local aHelpI	:= {}
Local aHelpE	:= {}

aRegs  := {}
AADD(aRegs,{"SZF","01","ZF_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZF","02","ZF_COD","C",15,00,"Cod.Voucher","Cod.Voucher","Cod.Voucher","CodigodoVoucher","CodigodoVoucher","CodigodoVoucher","@!","","€€€€€€€€€€€€€€ ","GETSXENUM('SZF','ZF_COD')","",00,"şÀ","","","U","S","V","R","","NaoVazio().And.ExistChav('SZF')","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","03","ZF_TIPOVOU","C",06,00,"TipoVoucher","TipoVoucher","TipoVoucher","TipodeVoucher","TipodeVoucher","TipodeVoucher","@!","","€€€€€€€€€€€€€€ ","","SZH",00,"şÀ","","","U","S","A","R","€","ExistChav('SZH',M->ZF_TIPOVOU)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","04","ZF_PRODUTO","C",15,00,"Produto","Produto","Produto","CodigodoProduto","CodigodoProduto","CodigodoProduto","@!","vazio().or.existcpo('SB1')","€€€€€€€€€€€€€€ ","","SB1",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","05","ZF_QTDVOUC","N",09,02,"Quantidade","Quantidade","Quantidade","QuantidadedoVoucher","QuantidadedoVoucher","QuantidadedoVoucher","@E999999.99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","Positivo()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","06","ZF_DTVALID","D",08,00,"Val.Voucher","Val.Voucher","Val.Voucher","ValidadedoVoucher","ValidadedoVoucher","ValidadedoVoucher","@D","M->ZF_DTVALID>=DDATABASE","€€€€€€€€€€€€€€ ","CTOD('')","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","07","ZF_PEDIDO","C",06,00,"Num.Pedido","Num.Pedido","Num.Pedido","NumerodoPedido","NumerodoPedido","NumerodoPedido","@X","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","08","ZF_CONTRAT","C",06,00,"Contrato","Contrato","Contrato","NumerodoContrato","NumerodoContrato","NumerodoContrato","@X","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","09","ZF_TES","C",03,00,"TipoSaida","TipoSaida","TipoSaida","TipodeSaida","TipodeSaida","TipodeSaida","@9","vazio().or.existcpo('SF4').And.M->ZF_TES>='500'","€€€€€€€€€€€€€€ ","","SF4",00,"şÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","10","ZF_SALDO","N",09,02,"SldVoucher","SldVoucher","SldVoucher","SaldodoVoucher","SaldodoVoucher","SaldodoVoucher","@E999999.99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","Positivo()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","11","ZF_ATIVO","C",01,00,"Ativo","Ativo","Ativo","Ativo","Ativo","Ativo","@!","","€€€€€€€€€€€€€€ ","'S'","",00,"şÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","12","ZF_FLAGSIT","C",01,00,"Jaenviado","Jaenviado","Jaenviado","Jaenviadoparaosite","Jaenviadoparaosite","Jaenviadoparaosite","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
		Next j
	MsUnlock()
Next i

//HELP - ZF_COD
aHelp := {	"É informado o código do Voucher, por um",;
			" número sequencial."}
                     
cHelp := "ZF_COD    "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_PRODUTO
aHelp := {	"Informar para qual produto o Voucher",;
			" será referenciado."}
                     
cHelp := "ZF_PRODUTO"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_QTDVOUC
aHelp := {	"Informar a quantidade do Voucher,",;
			" referente ao produto informado."}
                     
cHelp := "ZF_QTDVOUC"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_DTVALID
aHelp := {	"Informe a data de validade do Voucher."}
                     
cHelp := "ZF_DTVALID"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_PEDIDO 
aHelp := {	"Informe o número do pedido para",;
			" faturamento."}
                     
cHelp := "ZF_PEDIDO "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_CONTRAT
aHelp := {	"Informe o número do contrato para",;
			" medição."}
                     
cHelp := "ZF_CONTRAT"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_TES
aHelp := {	"Informe o tipo de saída para a geração",;
			" do pedido e faturamento."}
                     
cHelp := "ZF_TES    "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZF_SALDO
aHelp := {	"É controlado o saldo do Voucher,",;
			" conforme suas saídas."}
                     
cHelp := "ZF_SALDO  "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SZG","01","ZG_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZG","02","ZG_NUMPED","C",06,00,"NumPedido","NumPedido","NumPedido","NumerodoPedido","NumerodoPedido","NumerodoPedido","@X","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","03","ZG_ITEMPED","C",02,00,"ItemPedido","ItemPedido","ItemPedido","ItemdoPedido","ItemdoPedido","ItemdoPedido","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","04","ZG_NUMVOUC","C",15,00,"NumVoucher","NumVoucher","NumVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","€€€€€€€€€€€€€€ ","","SZF",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","05","ZG_QTDSAI","N",09,02,"Quantidade","Quantidade","Quantidade","Quantidadesaida","Quantidadesaida","Quantidadesaida","@E999999.99","","€€€€€€€€€€€€€€ ","0","",00,"şÀ","","","U","S","A","R","€","Positivo()","","","","","","","","","","","","","N","N","","N","N","N"})

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
		Next j
	MsUnlock()
Next i

//HELP - ZG_NUMPED 
aHelp := {	"Informe o número do pedido que",;
			" movimentou o Voucher."}
                     
cHelp := "ZG_NUMPED "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZG_ITEMPED
aHelp := {	"Informar o item do pedido referente ao",;
			" produto do Voucher."}
                     
cHelp := "ZG_ITEMPED"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZG_NUMVOUC
aHelp := {	"Informar o número do Voucher para",;
			" movimentação do mesmo."}
                     
cHelp := "ZG_NUMVOUC"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - ZG_QTDSAI
aHelp := {	"Informe a quantidade que saiu do Voucher",;
			" informado."}
                     
cHelp := "ZG_QTDSAI "
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SZH","01","ZH_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZH","02","ZH_COD","C",06,00,"CodTipoVou","CodTipoVou","CodTipoVou","Codigodotipodovoucher","Codigodotipodovoucher","Codigodotipodovoucher","@!","","€€€€€€€€€€€€€€ ","GETSXENUM('SZH','ZH_COD')","",00,"şÀ","","","U","S","V","R","€","NaoVazio().And.ExistChav('SZH')","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","03","ZH_DESCRI","C",30,00,"DesTipoVou","DesTipoVou","DesTipoVou","DescricaoTipoVoucher","DescricaoTipoVoucher","DescricaoTipoVoucher","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","04","ZH_INCITVE","C",01,00,"IncIteVen?","IncIteVen?","IncIteVen?","IncluiItemdeVenda?","IncluiItemdeVenda?","IncluiItemdeVenda?","@!","","€€€€€€€€€€€€€€ ","'S'","",00,"şÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","05","ZH_TESVEND","C",03,00,"TESIteVend","TESIteVend","TESIteVend","TESItemVenda","TESItemVenda","TESItemVenda","@!","","€€€€€€€€€€€€€€ ","","SF4",00,"şÀ","","","U","S","A","R","","vazio().or.existcpo('SF4').And.M->ZH_TESVEND>='500'","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","06","ZH_INCITEE","C",01,00,"IncIteEnt?","IncIteEnt?","IncIteEnt?","IncluiItemdeEntrega?","IncluiItemdeEntrega?","IncluiItemdeEntrega?","@!","","€€€€€€€€€€€€€€ ","'S'","",00,"şÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","07","ZH_TESENTR","C",03,00,"TESIteEntr","TESIteEntr","TESIteEntr","TESItemEntrega","TESItemEntrega","TESItemEntrega","@!","","€€€€€€€€€€€€€€ ","","SF4",00,"şÀ","","","U","S","A","R","","vazio().or.existcpo('SF4').And.M->ZH_TESENTR>='500'","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","08","ZH_FATITVE","C",01,00,"FatIteVen?","FatIteVen?","FatIteVen?","FaturaItemdeVenda?","FaturaItemdeVenda?","FaturaItemdeVenda?","@!","","€€€€€€€€€€€€€€ ","'S'","",00,"şÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","09","ZH_FATITEE","C",01,00,"FatIteEnt?","FatIteEnt?","FatIteEnt?","FaturaItemdeEntrega?","FaturaItemdeEntrega?","FaturaItemdeEntrega?","@!","","€€€€€€€€€€€€€€ ","'S'","",00,"şÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","10","ZH_CONSPDO","C",01,00,"ConsPed?","ConsPed?","ConsPed?","ConsideraPedido?","ConsideraPedido?","ConsideraPedido?","@!","","€€€€€€€€€€€€€€ ","'V'","",00,"şÀ","","","U","S","A","R","","Pertence('VPE')","V=Voucher;P=Periodo;E=Entrega","","","","","","","","","","","","N","N","","N","N","N"})

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
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SC5","C6","C5_XNPSITE","C",10,00,"NumPedSite","NumPedSite","NumPedSite","Numerodopedidonosite","Numerodopedidonosite","Numerodopedidonosite","9999999999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C7","C5_XFORPGT","C",01,00,"FormaPagto","FormaPagto","FormaPagto","FormadePagamento","FormadePagamento","FormadePagamento","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","Pertence('123')","1=Cartao;2=Boleto;3=Voucher","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C8","C5_XNUMCAR","C",16,00,"NumCartao","NumCartao","NumCartao","NumCartaodeCredito","NumCartaodeCredito","NumCartaodeCredito","9999999999999999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","C9","C5_XNOMTIT","C",20,00,"NomTitular","NomTitular","NomTitular","NomedoTitularCartao","NomedoTitularCartao","NomedoTitularCartao","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D0","C5_XCODSEG","C",04,00,"CodSegCart","CodSegCart","CodSegCart","CodigodeSeg.Cartao","CodigodeSeg.Cartao","CodigodeSeg.Cartao","9999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D1","C5_XDTVALI","D",08,00,"DtValCart","DtValCart","DtValCart","DataValidadeCartao","DataValidadeCartao","DataValidadeCartao","@D","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D2","C5_XNPARCE","C",02,00,"NumParcelas","NumParcelas","NumParcelas","NumerodeParcelas","NumerodeParcelas","NumerodeParcelas","99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D3","C5_XTIPCAR","C",01,00,"TipoCartao","TipoCartao","TipoCartao","TipoCartaodeCredito","TipoCartaodeCredito","TipoCartaodeCredito","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","Pertence('123')","1=Visa;2=MasterCard;3=AmericanExpress","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D4","C5_XLINDIG","C",48,00,"LinhaDigita","LinhaDigita","LinhaDigita","LinhaDigitavelBoleto","LinhaDigitavelBoleto","LinhaDigitavelBoleto","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D5","C5_XNUMVOU","C",15,00,"NumVoucher","NumVoucher","NumVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D6","C5_XQTDVOU","N",09,02,"QtdVoucher","QtdVoucher","QtdVoucher","QuantidadedoVoucher","QuantidadedoVoucher","QuantidadedoVoucher","@E999999,99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D7","C5_XNFHRD","C",80,00,"LinkNFHRD","LinkNFHRD","LinkNFHRD","LinkNotaFiscalHardware","LinkNotaFiscalHardware","LinkNotaFiscalHardware","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D8","C5_XNFSFW","C",80,00,"LinkNFSFW","LinkNFSFW","LinkNFSFW","LinkNotaFiscalSoftware","LinkNotaFiscalSoftware","LinkNotaFiscalSoftware","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","D9","C5_XNFHRE","C",80,00,"LinkNFHRE","LinkNFHRE","LinkNFHRE","LinkNFHRDEntrega","LinkNFHRDEntrega","LinkNFHRDEntrega","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E0","C5_XFLAGEN","C",01,00,"FlagEnvSit","FlagEnvSit","FlagEnvSit","FlagEnvioSite","FlagEnvioSite","FlagEnvioSite","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E1","C5_STENTR","C",01,00,"StatEntrega","StatEntrega","StatEntrega","StatusdaEntrega","StatusdaEntrega","StatusdaEntrega","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC5","E2","C5_XPOSTO","C",06,00,"Posto","Posto","Posto","PostodeEntrega","PostodeEntrega","PostodeEntrega","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
		Next j
	MsUnlock()
Next i

//HELP - C5_XNPSITE
aHelp := {	"É informado o número do pedido no site."}
                     
cHelp := "C5_XNPSITE"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XFORPGT
aHelp := {	"É informada a forma de pagamento do site",;
			" 1 - Cartão, 2 - Boleto e 3 - Voucher."}
                     
cHelp := "C5_XFORPGT"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XNUMCAR
aHelp := {	"Gravado o número de cartão de crédito",;
			" informado no site."}
                     
cHelp := "C5_XNUMCAR"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XNOMTIT
aHelp := {	"É informado o nome do títular do cartão."}
                     
cHelp := "C5_XNOMTIT"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XCODSEG 
aHelp := {	"É informado o código de segurança do",;
			" cartão."}
                     
cHelp := "C5_XCODSEG"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XDTVALI
aHelp := {	"É informado a data de validade do cartão",;
			" informado no site."}
                     
cHelp := "C5_XDTVALI"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XNPARCE
aHelp := {	"É informado o número de parcelas que",;
			" será divido o cartão de crédito."}
                     
cHelp := "C5_XNPARCE"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XTIPCAR
aHelp := {	"É informada a bandeira do cartão de",;
			" crédito 1 - Visa, 2 - MasterCard e 6 -",;
			" American Express."}
                     
cHelp := "C5_XTIPCAR"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XLINDIG
aHelp := {	"É informada a linha digitável do boleto."}
                     
cHelp := "C5_XLINDIG"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XNUMVOU
aHelp := {	"É informado o número do Voucher."}
                     
cHelp := "C5_XNUMVOU"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C5_XQTDVOU
aHelp := {	"É informada a quantidade utilizada."}
                     
cHelp := "C5_XQTDVOU"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SC6","B8","C6_XNUMVOU","C",15,00,"NrVoucher","NrVoucher","NrVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SC6","B9","C6_XQTDVOU","N",09,02,"QtdVoucher","QtdVoucher","QtdVoucher","QuantidadedoVoucher","QuantidadedoVoucher","QuantidadedoVoucher","@E999999,99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
		Next j
	MsUnlock()
Next i

//HELP - C6_XNUMVOU
aHelp := {	"É informado o número do Voucher."}
                     
cHelp := "C6_XNUMVOU"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

//HELP - C6_XQTDVOU
aHelp := {	"É informada a quantidade consumida pelo",;
			" voucher."}
                     
cHelp := "C6_XQTDVOU"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SE1","N1","E1_XNPSITE","C",10,00,"NrPedSite","NrPedSite","NrPedSite","NumeroPedidoSite","NumeroPedidoSite","NumeroPedidoSite","9999999999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
		Next j
	MsUnlock()
Next i

//HELP - E1_XNPSITE
aHelp := {	"É informado o número do pedido do site."}
                     
cHelp := "E1_XNPSITE"
PutHelp("P"+cHelp,aHelp,aHelpI,aHelpE,.T.)

aRegs  := {}
AADD(aRegs,{"SZ3","01","Z3_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"SZ3","02","Z3_CODENT","C",06,00,"CodEntidade","CodEntidade","CodEntidade","CodEntidade","CodEntidade","CodEntidade","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","INCLUI","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","03","Z3_DESENT","C",100,00,"DescrEntid.","DescrEntid.","DescrEntid.","DescrEntid.","DescrEntid.","DescrEntid.","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","INCLUI","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","04","Z3_TIPENT","C",01,00,"TipoEntidad","TipoEntidad","TipoEntidad","TipoEntidade","TipoEntidade","TipoEntidade","9","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","1=Canal;2=AC;3=AR;4=Posto","1=Canal;2=AC;3=AR;4=Posto","1=Canal;2=AC;3=AR;4=Posto","","INCLUI","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","05","Z3_TIPCOM","C",01,00,"TP.Comissao","TP.Comissao","TP.Comissao","Tipodecomissao","Tipodecomissao","Tipodecomissao","","","€€€€€€€€€€€€€€ ","'1'","",00,"şÀ","","","U","N","A","R","€","","1=Paga;2=Calcula","1=Paga;2=Calcula","1=Paga;2=Calcula","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","06","Z3_CLASSI","C",03,00,"Classificac.","Classificac.","Classificac.","Classificac.","Classificac.","Classificac.","@!","","€€€€€€€€€€€€€€ ","","SZA_01",00,"şÀ","","","U","N","A","R","€","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","07","Z3_CODGAR","C",20,00,"EntnoGAR","EntnoGAR","EntnoGAR","EntnoGAR","EntnoGAR","EntnoGAR","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","INCLUI","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","08","Z3_CODCAN","C",06,00,"CodCanal","CodCanal","CodCanal","CodCanalSuperior","CodCanalSuperior","CodCanalSuperior","@!","U_COM010ok('Z3_CODCAN')","€€€€€€€€€€€€€€ ","","SZ3_01",00,"şÀ","","S","U","N","A","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","09","Z3_DESCAN","C",100,00,"DescCanal","DescCanal","DescCanal","DescricaoCanalSuperior","DescricaoCanalSuperior","DescricaoCanalSuperior","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","10","Z3_CODAC","C",06,00,"CodACSuper","CodACSuper","CodACSuper","CodigoACSuperior","CodigoACSuperior","CodigoACSuperior","@!","U_COM010ok('Z3_CODAC')","€€€€€€€€€€€€€€ ","","SZ3_02",00,"şÀ","","S","U","N","A","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","11","Z3_DESAC","C",100,00,"DescrAC","DescrAC","DescrAC","DescricaodoAC","DescricaodoAC","DescricaodoAC","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","12","Z3_CODAR","C",06,00,"CodARSuper","CodARSuper","CodARSuper","CodigoARSuperior","CodigoARSuperior","CodigoARSuperior","@!","U_COM010ok('Z3_CODAR')","€€€€€€€€€€€€€€ ","","SZ3_03",00,"şÀ","","S","U","N","A","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","13","Z3_DESAR","C",100,00,"DescrARSup","DescrARSup","DescrARSup","DescricaoARSuperior","DescricaoARSuperior","DescricaoARSuperior","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","M->Z3_TIPENT=='4'","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","14","Z3_CODFOR","C",06,00,"CodFornec.","CodFornec.","CodFornec.","CodigodoFornecedor","CodigodoFornecedor","CodigodoFornecedor","@!","","€€€€€€€€€€€€€€ ","","SA2",00,"şÀ","","S","U","N","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","15","Z3_LOJA","C",02,00,"Loja","Loja","Loja","Loja","Loja","Loja","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","16","Z3_DESFOR","C",60,00,"NomeFornec","NomeFornec","NomeFornec","NomeFornecedor","NomeFornecedor","NomeFornecedor","@!","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SA2',1,XFILIAL('SA2')+SZ3->Z3_CODFOR,'A2_NOME'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","17","Z3_DEVLAR","C",01,00,"DescoComAR","DescoComAR","DescoComAR","DescontaValComissaoAR","DescontaValComissaoAR","DescontaValComissaoAR","9","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","0=Nao;1=Sim","0=Nao;1=Sim","0=Nao;1=Sim","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","18","Z3_PONDIS","C",06,00,"PontoDistr.","PontoDistr.","PontoDistr.","Pontodedistribuicao","Pontodedistribuicao","Pontodedistribuicao","999999","","€€€€€€€€€€€€€€ ","","SZ8_01",00,"şÀ","","","U","N","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","19","Z3_CEP","C",08,00,"CEP","CEP","CEP","CEP","CEP","CEP","@R99999-999","!Empty(M->Z3_CEP).AND.ExistCpo('PA7')","€€€€€€€€€€€€€€ ","","PA7",00,"şÀ","","S","U","N","A","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","20","Z3_LOGRAD","C",60,00,"Logradouro","Logradouro","Logradouro","Logradouro","Logradouro","Logradouro","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","21","Z3_NUMLOG","C",10,00,"NumLograd.","NumLograd.","NumLograd.","NumerodoLogradouro","NumerodoLogradouro","NumerodoLogradouro","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","22","Z3_COMPLE","C",30,00,"Complemento","Complemento","Complemento","Complemento","Complemento","Complemento","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","23","Z3_BAIRRO","C",30,00,"Bairro","Bairro","Bairro","Bairro","Bairro","Bairro","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","24","Z3_CODMUN","C",05,00,"CodMunicip.","CodMunicip.","CodMunicip.","CodMunicipio","CodMunicipio","CodMunicipio","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","25","Z3_MUNICI","C",35,00,"Municipio","Municipio","Municipio","Municipio","Municipio","Municipio","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","26","Z3_ESTADO","C",02,00,"Estado","Estado","Estado","Estado","Estado","Estado","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","27","Z3_REGIAO","C",01,00,"RegiaoPais","RegiaoPais","RegiaoPais","RegiaoPais","RegiaoPais","RegiaoPais","9","","€€€€€€€€€€€€€€ ","'4'","",00,"şÀ","","","U","N","A","R","€","","1=Norte;2=Nordeste;3=Sul;4=Sudeste;5=CentroOeste","1=Norte;2=Nordeste;3=Sul;4=Sudeste;5=CentroOeste","1=Norte;2=Nordeste;3=Sul;4=Sudeste;5=CentroOeste","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","28","Z3_BANCO","C",03,00,"Banco","Banco","Banco","Banco","Banco","Banco","999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","29","Z3_AGENCIA","C",05,00,"Agencia","Agencia","Agencia","Agencia","Agencia","Agencia","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","30","Z3_CONTA","C",10,00,"ContaCorren","ContaCorren","ContaCorren","ContaCorrente","ContaCorrente","ContaCorrente","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","31","Z3_DDD","C",03,00,"DDD","DDD","DDD","CodigoDDD","CodigoDDD","CodigoDDD","999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","32","Z3_TEL","C",15,00,"Telefone","Telefone","Telefone","TelefonedoPosto","TelefonedoPosto","TelefonedoPosto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","33","Z3_CGC","C",14,00,"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF","CNPJ/CPFdoposto","CNPJ/CPFdoposto","CNPJ/CPFdoposto","@R99.999.999/9999-99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","Vazio().Or.CGC(M->Z3_CGC)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","34","Z3_CLIENTE","C",06,00,"Cliente","Cliente","Cliente","ClienteSimplesRemessa","ClienteSimplesRemessa","ClienteSimplesRemessa","@!","","€€€€€€€€€€€€€€ ","","SA1",00,"şÀ","","","U","S","A","R","","ExistCpo('SA1',M->Z3_CLIENTE,,,,.F.)","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","35","Z3_LOJACLI","C",02,00,"LojaCliente","LojaCliente","LojaCliente","Ljclientsimplesremessa","Ljclientsimplesremessa","Ljclientsimplesremessa","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","36","Z3_ATENDIM","C",01,00,"Atendimento","Atendimento","Atendimento","Atendimento","Atendimento","Atendimento","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","37","Z3_ATIVO","C",01,00,"Ativo","Ativo","Ativo","Ativo","Ativo","Ativo","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","38","Z3_VISIBIL","C",01,00,"Visibilidade","Visibilidade","Visibilidade","Visibilidade","Visibilidade","Visibilidade","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ3","39","Z3_ENTREGA","C",01,00,"Entrega","Entrega","Entrega","Entrega","Entrega","Entrega","@!","","€€€€€€€€€€€€€€ ","'S'","",00,"şÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})

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
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SU5","73","U5_XSENHA","C",50,00,"SenhaIntern","SenhaIntern","SenhaIntern","SenhadeInternet","SenhadeInternet","SenhadeInternet","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
±±³Fun‡ao    ³ GeraSX6  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX6()
Local aArea		:= GetArea()
Local i      	:= 0
Local j      	:= 0
Local aRegs  	:= {}
Local cTexto 	:= ''
Local lInclui	:= .F.

aRegs  := {}
AADD(aRegs,{"","MV_XTABPRC","C","Informeaocodigodatabeladeprecogenericaque","","","serautilizadaviawebservice.","","","","","","001","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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
AADD(aRegs,{"","MV_XPOSGRU","C","IdentificaocodigodogruporeferenteaosPostos","","","deEntrega.","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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
AADD(aRegs,{"","MV_XTESWEB","C","InformaroTESpadraodevendapelowebservice,","","","poisomesmoserautilizadonainclusaodepedidos","","","viawebservice.","","","501","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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
AADD(aRegs,{"","MV_XTESDEV","C","TESutilizdoparadevolucaodePoderdeTerceiros.","","","","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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
AADD(aRegs,{"","MV_XTESREM","C","TESutilizadoparabuscadasnotasemitidaspara","","","PoderdeTerceiros(remessa).","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")
	
	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
	
	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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
AADD(aRegs,{"","MV_XTESSAI","C","TESutilizadoparaofaturamentofinalviaweb","","","service.","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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
AADD(aRegs,{"","MV_XTPDEVO","C","Deveraserinformadootipodedocumentodeentrad","","","areferenteadevolucaodepoderdeterceiros.","","","","","","B","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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
AADD(aRegs,{"","MV_XESPECI","C","DeveraserinformadaaespeciedaNotalFiscalde","","","Entrada,referenteadevolucao.","","","","","","","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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

AADD(aRegs,{"","MV_XCPSITE","C","Informeacondicaodepagamentopadraoutilizada","","","nositehardwareavulso.","","","","","","001","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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

AADD(aRegs,{"","MV_XVENSIT","C","Informequalovendedorpadraodositehardwareav","","","ulso.","","","","","","000001","","","U","","","","","",""})

dbSelectArea("SX6")
dbSetOrder(1)

For i := 1 To Len(aRegs)

	cTexto += IIf( aRegs[i,1] + aRegs[i,2] $ cTexto, "", aRegs[i,1] + aRegs[i,2] + "\")

	dbSetOrder(1)
	lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

	cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

	RecLock("SX6", lInclui)
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
Return('SX6 : ' + cTexto  + CHR(13) + CHR(10))

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
Local aArea		:= GetArea()
Local i      	:= 0
Local j      	:= 0
Local aRegs  	:= {}
Local cTexto 	:= ''
Local lInclui	:= .F.

aRegs  := {}
AADD(aRegs,{"SC5","8","C5_FILIAL+C5_XNPSITE","NumPedSite","NumPedSite","NumPedSite","U","","","N"})

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
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZF","1","ZF_FILIAL+ZF_COD","Cod.Voucher","Cod.Voucher","Cod.Voucher","U","","","N"})

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
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZG","1","ZG_FILIAL+ZG_NUMPED+ZG_ITEMPED+ZG_NUMVOUC","NumPedido+ItemPedido+NumVoucher","NumPedido+ItemPedido+NumVoucher","NumPedido+ItemPedido+NumVoucher","U","","","N"})

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
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","1","ZH_FILIAL+ZH_COD","CodTipoVou","CodTipoVou","CodTipoVou","U","","","N"})

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
		Next j
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
Local aArea		:= GetArea()
Local i      	:= 0
Local j      	:= 0
Local aRegs  	:= {}
Local cTexto 	:= ''
Local lInclui	:= .F.

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
		Next j
	MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","1","01","DB","TiposdeVoucher","TiposdeVoucher","TiposdeVoucher","SZH",""})
AADD(aRegs,{"SZH","2","01","01","CodTipoVou","CodTipoVou","CodTipoVou","",""})
AADD(aRegs,{"SZH","3","01","01","CadastraNovo","IncluyeNuevo","AddNew","01",""})
AADD(aRegs,{"SZH","4","01","01","CodTipoVou","CodTipoVou","CodTipoVou","ZH_COD",""})
AADD(aRegs,{"SZH","4","01","02","DesTipoVou","DesTipoVou","DesTipoVou","ZH_DESCRI",""})
AADD(aRegs,{"SZH","5","01","","","","","SZH->ZH_COD",""})

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
		Next j
	MsUnlock()
Next i

RestArea(aArea)
Return('SXB : ' + cTexto + CHR(13) + CHR(10))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncSX5     ºAutor  ³Darcio R. Sporl     º Data ³  01/08/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para incluir a consulta padrao do tipo de     º±±
±±º          ³produto da certisign.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncSX5()
Local aArea		:= GetArea()
Local cTexto 	:= "Incluída a tabela ZZ."
Local aRegs		:= {}
Local nI		:= 0

aRegs  := {}
AADD(aRegs,{"02","00","ZZ","TIPOPRODUTOCERTISIGN","TIPOPRODUTOCERTISIGN","TIPOPRODUTOCERTISIGN"})
AADD(aRegs,{"02","ZZ","01","SMARTCARD","SMARTCARD","SMARTCARD"})
AADD(aRegs,{"02","ZZ","02","LEITORA","LEITORA","LEITORA"})
AADD(aRegs,{"02","ZZ","03","TOKEN","TOKEN","TOKEN"})

DbSelectArea("SX5")
DbSetOrder(1)

For nI := 1 To Len(aRegs)
	If !DbSeek(aRegs[nI][1] + aRegs[nI][2] + aRegs[nI][3])
		RecLock("SX5", .T.)
			SX5->X5_FILIAL	:= aRegs[nI][1]
			SX5->X5_TABELA	:= aRegs[nI][2]
			SX5->X5_CHAVE	:= aRegs[nI][3]
			SX5->X5_DESCRI	:= aRegs[nI][4]
			SX5->X5_DESCSPA	:= aRegs[nI][5]
			SX5->X5_DESCENG	:= aRegs[nI][6]
		SX5->(MsUnLock())
	EndIf
Next nI

RestArea(aArea)
Return('SX5 : ' + cTexto + CHR(13) + CHR(10))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ UpdEmp   ³ Autor ³ Luciano Aparecido     ³ Data ³ 15.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Trata Empresa. Verifica as Empresas para Atualizar         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao PLS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  UpdEmp(aRecnoSM0,lOpen)
Local cVar		:= Nil
Local oDlg		:= Nil
Local cTitulo	:= "Escolha a(s) Empresa(s) que será(ão) Atualizada(s)"
Local lMark		:= .F.
Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk		:= Nil
Local bCode		:= {||oDlg:End(),Processa({|lEnd| ProcATU(@lEnd,aRecnoSM0,lOpen)},"Processando","Aguarde, processando preparação dos arquivos",.F.)}
Private lChk	:= .F.
Private oLbx	:= Nil

If ( lOpen := MyOpenSm0Ex() )
	dbSelectArea("SM0")
	
	/////////////////////////////////////////
	//| Carrega o vetor conforme a condicao |/
	//////////////////////////////////////////
	dbGotop()
	While !Eof()
		If Ascan(aRecnoSM0,{ |x| x[3] == M0_CODIGO}) == 0 //--So adiciona no aRecnoSM0 se a empresa for diferente
			Aadd(aRecnoSM0,{lMark,Recno(),M0_CODIGO,M0_CODFIL,M0_NOME+"/ "+M0_FILIAL})
		EndIf
		dbSkip()
	EndDo
	
	///////////////////////////////////////////////////
	//| Monta a tela para usuario visualizar consulta |
	///////////////////////////////////////////////////
	If Len( aRecnoSM0 ) == 0
		Aviso( cTitulo, "Nao existe bancos a consultar", {"Ok"} )
		Return
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	
	@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER ;
	" ", "Recno", "Cod Empresa","Cod Filial","Empresa /Filial" ;
	SIZE 230,095 OF oDlg PIXEL ON dblClick(aRecnoSM0[oLbx:nAt,1] := !aRecnoSM0[oLbx:nAt,1],oLbx:Refresh())
	
	oLbx:SetArray( aRecnoSM0)
	oLbx:bLine := {|| {Iif(aRecnoSM0[oLbx:nAt,1],oOk,oNo),;
	aRecnoSM0[oLbx:nAt,2],;
	aRecnoSM0[oLbx:nAt,3],;
	aRecnoSM0[oLbx:nAt,4],;
	aRecnoSM0[oLbx:nAt,5]}}
	
	////////////////////////////////////////////////////////////////////
	//| Para marcar e desmarcar todos existem duas opçoes, acompanhe...
	////////////////////////////////////////////////////////////////////
	
	@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ;
	ON CLICK(aEval(aRecnoSM0,{|x| x[1]:=lChk}),oLbx:Refresh())
	
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION Eval(bCode) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
Endif

Return