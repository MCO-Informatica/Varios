#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ-ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³UPDZ8Z9  ³ Autor ³ MICROSIGA             ³ Data ³ 06/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Principal                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gestao Hospitalar                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UPDZ8Z9()

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

Processa({|| ProcATU()},"Processando [UPDZ8Z9]","Aguarde , processando preparação dos arquivos")

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
			DEFINE MSDIALOG oDlg TITLE "Atualizador [UPDZ8Z9] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
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
AADD(aRegs,{"SZ8","                                        ","SZ8010  ","CABECALHO DE PD X PRODUTOS    ","CABECALHO DE PD X PRODUTOS    ","CABECALHO DE PD X PRODUTOS    ","                                        ","C",00," ","Z8_FILIAL+Z8_COD                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              "})

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
AADD(aRegs,{"SZ9","                                        ","SZ9010  ","ITENS DE PD X PRODUTOS        ","ITENS DE PD X PRODUTOS        ","ITENS DE PD X PRODUTOS        ","                                        ","C",00," ","Z9_FILIAL+Z9_COD+Z9_PROD                                                                                                                                                                                                                                  "," ",00,"                                                                                                                                                                                                                                                              "})

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
AADD(aRegs,{"SZ8","01","Z8_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZ8","02","Z8_COD","C",06,00,"CodigoPD","CodigoPD","CodigoPD","CodigodoPD","CodigodoPD","CodigodoPD","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","ExistChav('SZ8',,1)","","","","","INCLUI","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ8","03","Z8_DESC","C",50,00,"DescricaoPD","DescricaoPD","DescricaoPD","DescricaodoPD","DescricaodoPD","DescricaodoPD","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ8","04","Z8_FORNEC","C",06,00,"Fornecedor","Fornecedor","Fornecedor","Fornecedor","Fornecedor","Fornecedor","","","€€€€€€€€€€€€€€ ","","SA2",00,"şÀ","","S","U","N","A","R","","(ExistCpo('SA2',M->Z8_FORNEC,1).and.ExistChav('SZ8',M->Z8_FORNEC+M->Z8_LOJA,2)).or.Vazio()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ8","05","Z8_LOJA","C",02,00,"Loja","Loja","Loja","Loja","Loja","Loja","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","(ExistCpo('SA2',M->Z8_FORNEC+M->Z8_LOJA,1).and.ExistChav('SZ8',M->Z8_FORNEC+M->Z8_LOJA,2)).or.Vazio()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ8","06","Z8_NOMFOR","C",60,00,"NomeFornec","NomeFornec","NomeFornec","NomedoFornecedor","NomedoFornecedor","NomedoFornecedor","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SA2',1,XFILIAL('SA2')+SZ8->(Z8_FORNEC+Z8_LOJA),'A2_NOME'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ8","07","Z8_EMAIL","C",250,00,"Email","Email","Email","Email","Email","Email","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
AADD(aRegs,{"SZ9","01","Z9_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZ9","02","Z9_COD","C",06,00,"CodigoPD","CodigoPD","CodigoPD","CodigoPD","CodigoPD","CodigoPD","","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","03","Z9_FORNEC","C",06,00,"Fornecedor","Fornecedor","Fornecedor","FornecedordoPD","FornecedordoPD","FornecedordoPD","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","04","Z9_LOJA","C",02,00,"Loja","Loja","Loja","Loja","Loja","Loja","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","05","Z9_PROD","C",15,00,"Produto","Produto","Produto","Produto","Produto","Produto","","","€€€€€€€€€€€€€€ ","","SB1",00,"şÀ","","S","U","N","A","R","€","ExistCpo('SB1',M->Z9_PROD,1).or.Vazio()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","06","Z9_DESC","C",30,00,"Descricao","Descricao","Descricao","Descricao","Descricao","Descricao","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SB1',1,XFILIAL('SB1')+SZ9->Z9_PROD,'B1_DESC'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","07","Z9_SALDO","N",12,00,"Saldo","Saldo","Saldo","SaldoPDxProduto","SaldoPDxProduto","SaldoPDxProduto","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","08","Z9_ESTMIN","N",12,00,"EstMinimo","EstMinimo","EstMinimo","EstoqueMinimo","EstoqueMinimo","EstoqueMinimo","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","09","Z9_ESTMAX","N",12,00,"EstMaximo","EstMaximo","EstMaximo","EstoqueMaximo","EstoqueMaximo","EstoqueMaximo","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","10","Z9_LTECON","N",12,00,"LoteEconom","LoteEconom","LoteEconom","LoteEconomico","LoteEconomico","LoteEconomico","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","11","Z9_ESTSEG","N",12,00,"Est.Segura","Est.Segura","Est.Segura","EstoquedeSeguranca","EstoquedeSeguranca","EstoquedeSeguranca","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","12","Z9_DIAREP","N",03,00,"DiaReposica","DiaReposica","DiaReposica","DiasparaReposicao","DiasparaReposicao","DiasparaReposicao","999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","13","Z9_CSMATU","N",12,00,"ConsMesAtu","ConsMesAtu","ConsMesAtu","ConsumoMesAtual","ConsumoMesAtual","ConsumoMesAtual","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","14","Z9_CSM01","N",12,00,"ConsMes01","ConsMes01","ConsMes01","ConsumoMes01","ConsumoMes01","ConsumoMes01","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","15","Z9_CSM02","N",12,00,"ConsMes02","ConsMes02","ConsMes02","ConsumoMes02","ConsumoMes02","ConsumoMes02","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","16","Z9_CSM03","N",12,00,"ConsMes03","ConsMes03","ConsMes03","ConsumoMes03","ConsumoMes03","ConsumoMes03","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","17","Z9_CSM04","N",12,00,"ConsMes04","ConsMes04","ConsMes04","ConsumoMes04","ConsumoMes04","ConsumoMes04","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","18","Z9_CSM05","N",12,00,"ConsMes05","ConsMes05","ConsMes05","ConsumoMes05","ConsumoMes05","ConsumoMes05","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","19","Z9_CSM06","N",12,00,"ConsMes06","ConsMes06","ConsMes06","ConsumoMes06","ConsumoMes06","ConsumoMes06","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","20","Z9_CSM07","N",12,00,"ConsMes07","ConsMes07","ConsMes07","ConsumoMes07","ConsumoMes07","ConsumoMes07","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","21","Z9_CSM08","N",12,00,"ConsMes08","ConsMes08","ConsMes08","ConsumoMes08","ConsumoMes08","ConsumoMes08","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","22","Z9_CSM09","N",12,00,"ConsMes09","ConsMes09","ConsMes09","ConsumoMes09","ConsumoMes09","ConsumoMes09","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","23","Z9_CSM10","N",12,00,"ConsMes10","ConsMes10","ConsMes10","ConsumoMes10","ConsumoMes10","ConsumoMes10","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","24","Z9_CSM11","N",12,00,"ConsMes11","ConsMes11","ConsMes11","ConsumoMes11","ConsumoMes11","ConsumoMes11","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","25","Z9_CSM12","N",12,00,"ConsMes12","ConsMes12","ConsMes12","ConsumoMes12","ConsumoMes12","ConsumoMes12","@E999,999,999,999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","26","Z9_MEDCSM","N",12,02,"MedConsumo","MedConsumo","MedConsumo","Mediadeconsumo","Mediadeconsumo","Mediadeconsumo","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ9","27","Z9_DTCALC","D",08,00,"DataCalculo","DataCalculo","DataCalculo","DatadoCalculo","DatadoCalculo","DatadoCalculo","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
AADD(aRegs,{"Z8_FORNEC","001","SA2->A2_LOJA","Z8_LOJA","P","S","SA2",01,"XFILIAL('SA2')+M->Z8_FORNEC","","U"})
AADD(aRegs,{"Z8_FORNEC","002","SA2->A2_NOME","Z8_NOMFOR","P","S","SA2",01,"XFILIAL('SA2')+M->(Z8_FORNEC+Z8_LOJA)","","U"})

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
AADD(aRegs,{"Z9_PROD","001","SB1->B1_DESC","Z9_DESC","P","S","SB1",01,"XFILIAL('SB1')+M->Z9_PROD","","U"})

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
AADD(aRegs,{"SZ8","1","Z8_FILIAL+Z8_COD","CodigoPD","CodigoPD","CodigoPD","U","","SZ8001","S"})
AADD(aRegs,{"SZ8","2","Z8_FILIAL+Z8_FORNEC+Z8_LOJA","Fornecedor+Loja","Fornecedor+Loja","Fornecedor+Loja","U","","SZ8002","S"})

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
AADD(aRegs,{"SZ9","1","Z9_FILIAL+Z9_COD","CodigoPD","CodigoPD","CodigoPD","U","","SZ9001","S"})
AADD(aRegs,{"SZ9","2","Z9_FILIAL+Z9_PROD","Produto","Produto","Produto","U","","SZ9002","N"})
AADD(aRegs,{"SZ9","3","Z9_FILIAL+Z9_FORNEC+Z9_LOJA","Fornecedor+Loja","Fornecedor+Loja","Fornecedor+Loja","U","","SZ9003","N"})

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
//AADD(aRegs,{"SZ3","1","Z3_FILIAL+Z3_CODENT","CodEntidade","CodEntidade","CodEntidade","U","","","S"})
//AADD(aRegs,{"SZ3","2","Z3_FILIAL+Z3_DESENT","DescrEntid.","DescrEntid.","DescrEntid.","U","","","S"})
//AADD(aRegs,{"SZ3","3","Z3_FILIAL+Z3_CODFOR","CodFornec.","CodFornec.","CodFornec.","U","","","S"})
//AADD(aRegs,{"SZ3","4","Z3_FILIAL+Z3_CODGAR","EntnoGAR","EntnoGAR","EntnoGAR","U","","COD.GAR.","S"})
//AADD(aRegs,{"SZ3","5","Z3_FILIAL+Z3_PONDIS","PontoDistr.","PontoDistr.","PontoDistr.","U","","PONDISTRIB","S"})

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