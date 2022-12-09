#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ-ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³UPDIMPCSV  ³ Autor ³ MICROSIGA             ³ Data ³ 10/08/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Principal                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SERVICEDESK - CERTISIGN                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UPDIMPCSV()

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

Processa({|| ProcATU()},"Processando [UPDIMPCSV]","Aguarde , processando preparação dos arquivos")

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
			DEFINE MSDIALOG oDlg TITLE "Atualizador [UPDIMPCSV] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
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
AADD(aRegs,{"ADE","                                        ","ADE010  ","Chamados de Help Desk         ","Llamadas de Help Desk         ","Help Desk Tech.Call           ","                                        ","E",00," ","ADE_FILIAL+ADE_CODIGO                                                                                                                                                                                                                                     ","S",13,"                                                                                                                                                                                                                                                              "})

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
AADD(aRegs,{"SU4","                                        ","SU4010  ","Listas de Contatos            ","Listas de Contactos           ","Contact List                  ","                                        ","C",00," ","U4_FILIAL+U4_LISTA+DTOS(U4_DATA)                                                                                                                                                                                                                          ","S",13,"U4_LISTA+U4_DESC                                                                                                                                                                                                                                              "})

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
AADD(aRegs,{"SU6","                                        ","SU6010  ","Itens das Listas de Contatos  ","Ítems de las Listas de Contact","Contact List Items            ","                                        ","C",00," ","U6_FILIAL+U6_LISTA+U6_CODIGO                                                                                                                                                                                                                              ","S",13,"U6_LISTA                                                                                                                                                                                                                                                      "})

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
AADD(aRegs,{"SU7","                                        ","SU7010  ","Operadores                    ","Operadores                    ","Operators                     ","                                        ","C",00," ","U7_FILIAL+U7_COD                                                                                                                                                                                                                                          ","S",13,"U7_COD+U7_NOME                                                                                                                                                                                                                                                "})

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
AADD(aRegs,{"ADE","00","ADE_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","SucursaldelSistema","SystemBranch","@!","","€€€€€€€€€€€€€€€","","",01,"„À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","02","ADE_CODIGO","C",06,00,"Protocolo","Codigo","Code","CodigodoChamado","CodigodeLlamada","Tech.CallCode","","","€€€€€€€€€€€€€€","IF(INCLUI,GETNUMADE(),M->ADE_CODIGO)","",01,"‡€","","","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","03","ADE_PEDGAR","C",10,00,"PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","@!","Vazio().OR.u_CTSDK05(M->ADE_PEDGAR,.F.)","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","","","","","","","U_WhenGrupos()","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","04","ADE_NMCONT","C",30,00,"NomeContato","NombreCuent","Contc.Name","NomedoContato","NombredelContacto","ContactName","","","€€€€€€€€€€€€€€","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ADE->ADE_CODCON,'U5_CONTAT'),'')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ADE->ADE_CODCONT,'U5_CONTAT')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","05","ADE_ENTIDA","C",03,00,"Entidade","Entidad","Entity","Entidade","Entidad","Entity","","","€€€€€€€€€€€€€€","","",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","06","ADE_TIPPRF","C",30,00,"Perfil","Perfil","Perfil","TipodePerfildocliente","TipoPerfildelcliente","TypeofCustomerProfile","","","€€€€€€€€€€€€€€°","IF(!INCLUI,Tk510PrfDesc(ADE->ADE_ENTIDA,ADE->ADE_CHAVE),'')","",00,"","","","S","S","V","V","","","","","","","","Tk510PrfDesc(ADE->ADE_ENTIDA,ADE->ADE_CHAVE)","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","07","ADE_NMENT","C",30,00,"NomeEntidad","NombreEntid","Ent.Name","NomedaEntidade","NombredelaEntidad","EntityName","","","€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SX2',1,M->ADE_ENTIDA,'X2NOME()'),'')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SX2',1,ADE->ADE_ENTIDA,'X2NOME()')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","08","ADE_CHAVE","C",25,00,"CodEntidade","CodEntidad","Ent.Code","CodigodaEntidade","CodigodelaEntidad","EntityCode","","","€€€€€€€€€€€€€€","","",01,"„À","","S","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","09","ADE_DESCCH","C",40,00,"Nome","Nombre","Name","Nome","Nombre","Name","","","€€€€€€€€€€€€€€","IIF(!INCLUI,TKENTIDADE(M->ADE_ENTIDA,ADE->ADE_CHAVE,1),'')","",01,"„À","","","","S","V","V","","","","","","","","TKENTIDADE(ADE->ADE_ENTIDA,ADE->ADE_CHAVE,1)","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","10","ADE_CODCON","C",06,00,"Contato","Contacto","Contact","Contato","Contacto","Contact","","NaoVazio().And.ExistCpo('SU5')","€€€€€€€€€€€€€€","","TMK002",01,"‡À","","S","","S","A","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","10","ADE_EMAIL","C",40,00,"Email","E-mail","E-mail","Email","E-mail","E-mail","","","€€€€€€€€€€€€€€€","","",01,"„À","","","","N","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","12","ADE_EMAIL2","C",200,00,"Email","Email","Email","Email","Email","Email","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","13","ADE_CODPA8","C",16,00,"CodProdGAR","CodProdGAR","ProdCodGAR","CodigoProdutoGAR","codigoProductoGAR","ProductCodeGAR","@!","","€€€€€€€€€€€€€€ ","","PA8",00,"şA","","S","U","S","A","R","","existcpo('PA8')","","","","","U_WhenGrupos()","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","14","ADE_DATA","D",08,00,"DTAbertura","Fc.Apertur","OpeningDt","DataAbertura","FechaApertura","OpeningDate","@R99/99/99","","€€€€€€€€€€€€€€","MsDate()","",01,"…À","","","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","15","ADE_HORA","C",05,00,"HRAbertura","H.Apertura","OpeningHr","HRAbertura","H.Apertura","OpeningHour","99:99","","€€€€€€€€€€€€€€","TIME()","",01,"…À","","","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","16","ADE_DDDRET","C",02,00,"DDD","DDN","AreaCode","DDD","DDN","AreaCode","@R99","","€€€€€€€€€€€€€€","","",01,"†À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","16","ADE_TELRET","C",08,00,"Telefone","Telefono","Phone","Telefone","Telefono","Phone","@R9999-9999","","€€€€€€€€€€€€€€","","",01,"†À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","17","ADE_NMPA8","C",92,00,"Descr.GAR","Descr.GAR","GARDescript","DescricaoGAR","DescricionGAR","GARDescription","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('PA8',1,XFILIAL('PA8')+ADE->ADE_CODPA8,'PA8_DESBPG'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","POSICIONE('PA8',1,XFILIAL('PA8')+ADE->ADE_CODPA8,'PA8_DESBPG')","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","18","ADE_DESCIN","C",30,00,"IndiceEntid","IndiceEntid","Ent.Index","IndicedaEntidade","IndicedelaEntidad","EntityIndex","","","€€€€€€€€€€€€€€€","","",01,"„À","","","","","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","19","ADE_QUANT","N",14,03,"Quantidade","Quantidade","Quantity","Quantidade","Quantidade","Quantidade","@E9,999,999,999.999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","20","ADE_TECNIC","C",06,00,"Tecnico","Tecnico","Technician","Tecnico","Tecnico","Technician","","","€€€€€€€€€€€€€€","","",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","21","ADE_NMTEC","C",30,00,"NomeTecnico","NombreTecni","Tech.Name","NomeTecnico","NombreTecnico","Tech.Name","","","€€€€€€€€€€€€€€","IF(!INCLUI,POSICIONE('AA1',1,XFILIAL('AA1')+M->ADE_TECNIC,'AA1_NOMTEC'),IF(!EMPTY(M->ADE_TECNIC),AA1->AA1_NOMTEC,''))","",01,"„À","","","","","V","V","","","","","","","","POSICIONE('AA1',1,XFILIAL('AA1')+ADE->ADE_TECNIC,'AA1_NOMTEC')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","22","ADE_TIPO","C",06,00,"Comunicacao","Comunicacion","Communicat.","TipodeComunicacao","TipodeComunicacion","TypeofCommunic.","","IIF(INCLUI.AND.!Empty(M->ADE_TIPO),ExistCpo('SUL',M->ADE_TIPO,1),.T.)","€€€€€€€€€€€€€€","","SUL",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","23","ADE_CODSB1","C",15,00,"Produto","Producto","Product","Produto","Producto","Product","@!","Tk510JValid(2)","€€€€€€€€€€€€€€ ","","TMK007",01,"şA","","S","","S","A","R","","","","","","","U_WhenGrupos()","","030","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","24","ADE_NMPROD","C",30,00,"NomeProduto","NombreProd.","Prod.Name","NomeProduto","NombreProducto","ProductName","","","€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SB1',1,XFILIAL('SB1')+ADE->ADE_CODSB1,'B1_DESC'),'')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SB1',1,XFILIAL('SB1')+ADE->ADE_CODSB1,'B1_DESC')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","25","ADE_NMTIPO","C",30,00,"Descricao","Descripc.","Description","DescricaodaComunicacao","DescripcionComunicacion","Communic.Description","","","€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SUL',1,XFILIAL('SUL')+ADE->ADE_TIPO,'UL_DESC'),'')","",01,"„À","","","","","V","V","","","","","","","","POSICIONE('SUL',1,XFILIAL('SUL')+ADE->ADE_TIPO,'UL_DESC')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","26","ADE_MIDIA","C",06,00,"CodMidia","CodMedia","MediaCode","CodigodaMidia","CodigodelaMedia","MediaCode","","ExistCpo('SUH')","€€€€€€€€€€€€€€€","","SUH",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","27","ADE_NMMIDI","C",30,00,"NomeMidia","NombreMedia","MediaName","NomedaMidia","NombredelaMedia","MediaName","","","€€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SUH',1,XFILIAL('SUH')+M->ADE_MIDIA,'UH_DESC'),'')","",01,"„À","","","","","V","V","","","","","","","","POSICIONE('SUH',1,XFILIAL('SUH')+ADE->ADE_MIDIA,'UH_DESC')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","28","ADE_OPERAD","C",06,00,"Analista","Analista","Analyst","Analista","Analista","Analyst","","","€€€€€€€€€€€€€€","","",01,"„À","","S","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","29","ADE_NMOPER","C",30,00,"NomeAnalist","NombreAnali","AnalystNm","NomedoAnalista","NombredelAnalista","AnalystName","","","€€€€€€€€€€€€€€","IF(!INCLUI,POSICIONE('SU7',1,XFILIAL('SU7')+M->ADE_OPERAD,'U7_NOME'),IF(!EMPTY(M->ADE_OPERAD),SU7->U7_NOME,''))","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SU7',1,XFILIAL('SU7')+ADE->ADE_OPERAD,'U7_NOME')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","30","ADE_GRUPO","C",02,00,"Equipe","Equipo","Team","Equipe","Equipo","Team","","","€€€€€€€€€€€€€€","IIF(INCLUI,POSICIONE('SU7',1,XFILIAL('SU7')+TKOPERADOR(),'U7_POSTO'),M->ADE_OPERAD)","",01,"„À","","S","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","31","ADE_DESCGP","C",40,00,"NomeEquipe","NombreEquip","TeamName","NomedaEquipe","NombredelEquipo","TeamName","","","€€€€€€€€€€€€€€","POSICIONE('SU0',1,XFILIAL('SU0')+M->ADE_GRUPO,'U0_NOME')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SU0',1,xFilial('SU0')+ADE->ADE_GRUPO,'U0_NOME')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","32","ADE_DESCAS","C",30,00,"DescAssunto","DescAsunto","Subj.Desc.","DescricaodoAssunto","Descripc.delAsunto","SubjectDescrip.","","","€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SX5',1,XFILIAL('SX5')+'T1'+ADE->ADE_ASSUNT,'X5DESCRI()'),'')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SX5',1,xFilial('SX5')+'T1'+ADE->ADE_ASSUNT,'X5DESCRI()')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","33","ADE_SEVCOD","C",01,00,"Criticidade","Criticidad","Severity","CriticidadedoProblema","CriticidaddelProblema","ProblemSeverity","","Pertence('12345')","€€€€€€€€€€€€€€","","",01,"‡À","","","","S","A","R","","","5=Crítica;4=Alta;3=Média;2=Baixa;1=Alteraçãodeespecificação","5=Critica;4=Alta;3=Media;2=Baja;1=Modific.deespecificacion","5=Severe;4=High;3=Medium;2=Low;1=Changeofspecification","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","34","ADE_CHANEX","C",06,00,"CHAssociado","CHAsociado","CHLinked","CHAssociado","CHAsociado","CHLinked","","","€€€€€€€€€€€€€€","","",01,"„À","","","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","35","ADE_TO","C",200,00,"Destinatario","Destinatario","Destinatario","DestinatariodoEmail","DestinatariodoEmail","DestinatariodoEmail","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","36","ADE_CC","C",200,00,"Dest.Copiado","Dest.Copiado","Dest.Copiado","Dest.Copiadonoemail","Dest.Copiadonoemail","Dest.Copiadonoemail","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","37","ADE_ASSUNT","C",06,00,"Assunto","Asunto","Subject","Assunto","Asunto","Subject","","Tk510ValAss().AND.Tk510JVT1()","€€€€€€€€€€€€€€","","TMK003",01,"‡À","","S","","","A","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","38","ADE_CCO","C",200,00,"Dest.Oculto","Dest.Oculto","Dest.Oculto","Dest.Ocultonoemail","Dest.Ocultonoemail","Dest.Ocultonoemail","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","39","ADE_OPERAC","C",01,00,"Atendimento","Atencion","Cust.Service","Atendimento","Atencion","CustomerService","","Pertence('12')","€€€€€€€€€€€€€€","","",01,"‡À","","","","S","A","R","","","1=Receptivo;2=Ativo","1=Receptivo;2=Activo","1=Receptive;2=Active","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","40","ADE_REGSLA","C",06,00,"RegistroSLA","RegistroSLA","SLARegist.","RegistrodeSLA","RegistrodeSLA","SLARegistration","","","€€€€€€€€€€€€€€","","",01,"„À","","","","","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","41","ADE_STATUS","C",01,00,"Status","Estatus","Status","Status","Estatus","Status","","Pertence('123')","€€€€€€€€€€€€€€","IIF(INCLUI,'1','')","",01,"‡À","","","","S","A","R","","","1=EmAberto;2=Pendente;3=Encerrado","1=Abierto;2=Pendiente;3=Finalizado","1=Open;2=Pending;3=Closed","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","42","ADE_DTEXPI","D",08,00,"DataSLA","FechaSLA","SLADate","Datap/expirarSLA","Fechap/expirarSLA","SLAExpirationDate","","","€€€€€€€€€€€€€€","","",01,"„À","","","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","43","ADE_HREXPI","C",05,00,"HoraSLA","HoraSLA","HoraSLA","Horap/expirarSLA","Horap/expirarSLA","Horap/expirarSLA","","","€€€€€€€€€€€€€€ ","","",00,"","","","S","S","V","R","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","44","ADE_CODINC","C",06,00,"CodIncident","CodIncident","IncidentCd.","CodigoIncidente","CodigoIncidente","IncidentCode","","","€€€€€€€€€€€€€€€","","",01,"„À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","45","ADE_SEVSLA","N",03,00,"Severid.SLA","Severid.SLA","SLASever.","SeveridadedoSLA","SeveridaddelSLA","SLASeverity","","","€€€€€€€€€€€€€€","","",01,"„À","","","","","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","46","ADE_PLVCHV","C",200,00,"PalavraChav","PalabraClv","KeyWord","PalavraChave","PalabraClave","KeyWord","","","€€€€€€€€€€€€€€","","",01,"†À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","47","ADE_CRITIC","N",03,00,"Criticidade","Criticidad","Criticity","CriticidadedoProblema","CriticidaddelProblema","CriticityProblem","","","€€€€€€€€€€€€€€€","","",01,"„À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","48","ADE_FNCFIL","C",02,00,"FilialFNC","SucursalFNC","FNCBranch","FilialdaFichanoQNC","SucursalFichaenQNC","CardBranchinQNC","","","€€€€€€€€€€€€€€","","",01,"„À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","49","ADE_FNC","C",15,00,"CodigoFNC","CodigoFNC","FNCCode","CodigodaFichanoQNC","CodigodelaFichaenQNC","CardCodeinQNC","@!","","€€€€€€€€€€€€€€","","",01,"„À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","50","ADE_FNCREV","C",02,00,"RevisaoFNC","RevisionFNC","NCFReview","CodigodaRevisaodaFNC","CodigodeRevisiondeFNC","NCFReviewCode","@!","","€€€€€€€€€€€€€€","","",01,"„À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","51","ADE_CODCAM","C",06,00,"Campanha","Campana","Campaign","CodigodaCampanha","CodigodeCampana","CampaignCode","","Tk510JValid(1)","€€€€€€€€€€€€€€","","TMK006",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","52","ADE_DSCCAM","C",30,00,"Descricao","Descripc.","Description","Descricao","Descripción","Description","","","€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SUO',1,XFILIAL('SUO')+ADE->ADE_CODCAM,'UO_DESC'),'')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SUO',1,XFILIAL('SUO')+ADE->ADE_CODCAM,'UO_DESC')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","53","ADE_CODORI","C",08,00,"Cod.Origem","Cod.Origen","OriginCode","Codigodotipodeorigem","Codigodetipodeorigen","Origintypecode","","Tk510JValid(4)","€€€€€€€€€€€€€€","","TMK009",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","54","ADE_NORIGE","C",25,00,"Origem","Origen","Origin","OrigemdaNão-Conformidad","OrigendeNo-Conformidad","Non-ConformanceOrigin","@!","","€€€€€€€€€€€€€€","IF(!INCLUI,FQNCNTAB('3',M->ADE_CODORI),'')","",01,"„À","","","","","V","V","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","55","ADE_CODEFE","C",08,00,"Cod.Efeitos","Cod.Efectos","EffectCode","CodigodosEfeitos","CodigodeEfectos","EffectCode","","Tk510JValid(6)","€€€€€€€€€€€€€€","","TMK011",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","56","ADE_NEFEIT","C",25,00,"Efeitos","Efectos","Effects","EfeitosCausados","EfectosCausados","SideEffects","@!","","€€€€€€€€€€€€€€","IF(!INCLUI,FQNCNTAB('2',M->ADE_CODEFE),'')","",01,"„À","","","","","V","V","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","57","ADE_CODCAT","C",08,00,"Cod.Categ.","Cod.Categ.","Catg.Code","CodigodaCategoria","CodigodelaCategoria","CategoryCode","","Tk510JValid(3)","€€€€€€€€€€€€€€","","TMK008",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","58","ADE_NCATEG","C",25,00,"Categoria","Categoria","Category","TipodeProblema","TipodeProblema","TypeofProblem","@!","","€€€€€€€€€€€€€€","IF(!INCLUI,FQNCNTAB('4',M->ADE_CODCAT),'')","",01,"„À","","","","","V","V","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","59","ADE_CODCAU","C",08,00,"Cod.Causa","Cod.Causa","ReasonCd.","CodigodaCausa","CodigodelaCausa","ReasonCode","","Tk510JValid(5)","€€€€€€€€€€€€€€","","TMK010",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","60","ADE_NCAUSA","C",25,00,"Causa","Causa","Reason","PossiveisCausas","Posiblescausas","PossibleReasons","@!","","€€€€€€€€€€€€€€","IF(!INCLUI,FQNCNTAB('1',M->ADE_CODCAU),'')","",01,"„À","","","","","V","V","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","61","ADE_OPEUSO","C",06,00,"Analistuso","Analistuso","BusyAnalyst","Analistaematendimento","Analistaenatencion","Analystinservice","","","€€€€€€€€€€€€€€€","","",01,"„€","","","","N","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","62","ADE_SECUSO","N",06,00,"Horaemuso","Horaenuso","BusyHour","Hrinicioanalistaatend.","Hrinicioanalistaatenc.","Starthr.analystservice","","","€€€€€€€€€€€€€€€","","",01,"„€","","","","N","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","63","ADE_CHORIG","C",06,00,"ChOriginal","ChOriginal","ChOriginal","Chamadogeradooriginalme","Chamadogeradooriginalme","Chamadogeradooriginalme","","","€€€€€€€€€€€€€€€","","",00,"","","","S","N","V","R","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","64","ADE_INCIDE","M",80,00,"Incidente","Incidente","Incident","Incidente","Incidente","Incident","","","€€€€€€€€€€€€€€","","",01,"‡À","","","","S","A","V","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","65","ADE_FILORI","C",02,00,"Fil.Orig","Fil.Orig","Fil.Orig","Filialdeorigemdochama","Filialdeorigemdochama","Filialdeorigemdochama","","","€€€€€€€€€€€€€€€","","",00,"€€","","","S","N","V","R","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","66","ADE_CODDEC","C",06,00,"ChDesc","ChDesc","Degres.Call","NoChamadoDecrescente","EnelLlamadoDecrecente","DegressiveCallNr.","","","€€€€€€€€€€€€€€€","","",01,"ÆÀ","","","","N","V","R","","","","","","","","","","1","S","","","S","N","N","","N","N","N"})
AADD(aRegs,{"ADE","67","ADE_ASSANT","C",06,00,"AssuntoAnt.","AssuntoAnt.","AssuntoAnt.","Assuntoanterior","Assuntoanterior","Assuntoanterior","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","S","N","V","R","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","68","ADE_PRDANT","C",15,00,"ProdutoAnt.","ProdutoAnt.","ProdutoAnt.","Produtoanterior","Produtoanterior","Produtoanterior","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","S","N","V","R","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","69","ADE_CODREP","C",06,00,"Cont.Repres.","Cont.Repres.","Cont.Repres.","Contatorepresentante","Contatorepresentante","Contatorepresentante","","Vazio().OR.ExistCpo('SU5')","€€€€€€€€€€€€€€ ","","TMK002",00,"’À","","S","S","N","A","R","","","","","","","U_WhenGrupos()","","","2","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","70","ADE_DESREP","C",30,00,"NomeRepres.","NomeRepres.","NomeRepres.","Nomedorepresentante","Nomedorepresentante","Nomedorepresentante","","","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ADE->ADE_CODREP,'U5_CONTAT'),'')","",00,"’À","","","S","N","V","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ADE->ADE_CODREP,'U5_CONTAT')","","2","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","71","ADE_ENTREP","C",03,00,"Ent.Repres.","Ent.Repres.","Ent.Repres.","Entidaderepresentante","Entidaderepresentante","Entidaderepresentante","","","€€€€€€€€€€€€€€ ","","",00,"’À","","S","S","N","V","R","","","","","","","","","","2","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","72","ADE_DESENT","C",30,00,"NomeEnt.Rep","NomeEnt.Rep","NomeEnt.Rep","Nomedorepresentante","Nomedorepresentante","Nomedorepresentante","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SX2',1,M->ADE_ENTREP,'X2NOME()'),'')","",00,"’À","","","S","N","V","V","","","","","","","","POSICIONE('SX2',1,ADE->ADE_ENTREP,'X2NOME()')","","2","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","73","ADE_CHVREP","C",25,00,"Cod.Ent.Rep.","Cod.Ent.Rep.","Cod.Ent.Rep.","CodigoEntidadeRep.","CodigoEntidadeRep.","CodigoEntidadeRep.","","","€€€€€€€€€€€€€€ ","","",00,"’À","","S","S","N","V","R","","","","","","","","","","2","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","74","ADE_DCHREP","C",40,00,"NomeRep.","NomeRep.","NomeRep.","NomeEntidadeRep.","NomeEntidadeRep.","NomeEntidadeRep.","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,TKENTIDADE(M->ADE_ENTREP,ADE->ADE_CHVREP,1),'')","",00,"’À","","","S","N","V","V","","","","","","","","TKENTIDADE(ADE->ADE_ENTREP,ADE->ADE_CHVREP,1)","","2","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","75","ADE_DDDREP","C",02,00,"DDDRepres.","DDDRepres.","DDDRepres.","DDDdorepresentante","DDDdorepresentante","DDDdorepresentante","@R99","","€€€€€€€€€€€€€€ ","","",00,"’À","","","S","N","A","R","","","","","","","U_WhenGrupos()","","","2","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","76","ADE_TELREP","C",08,00,"Tel.Repres.","TelRepres.","TelRepres.","Telefonedorepresentante","Telefonedorepresentante","Telefonedorepresentante","@R9999-9999","","€€€€€€€€€€€€€€ ","","",00,"’À","","","S","N","A","R","","","","","","","U_WhenGrupos()","","","2","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","77","ADE_RECORR","C",01,00,"Recorrente","Recorrente","Recorrente","Chamadorecorrente","Chamadorecorrente","Chamadorecorrente","","","€€€€€€€€€€€€€€€","'2'","",00,"şÀ","","","U","N","V","R","","","1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","78","ADE_STRREC","C",40,00,"Cfg.Recorren","Cfg.Recorren","Cfg.Recorren","Config.derecorrencia","Config.derecorrencia","Config.derecorrencia","","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","79","ADE_CHORRC","C",06,00,"Ch.Ori.Rec","Ch.Ori.Rec","Ch.Ori.Rec","ChamadoOri.recorrencia","ChamadoOri.recorrencia","ChamadoOri.recorrencia","","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","80","ADE_XCPFTI","C",11,00,"CpfTitular","CpfTitular","CpfTitular","CpfTitular","CpfTitular","CpfTitular","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","81","ADE_XMAILT","C",50,00,"MailTitular","MailTitular","MailTitular","MailTitular","MailTitular","MailTitular","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","82","ADE_XNOMTI","C",50,00,"NomeTitular","NomeTitular","NomeTitular","NomeTitular","NomeTitular","NomeTitular","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","83","ADE_XPRODG","C",50,00,"Prod.Gar","Prod.Gar","Prod.Gar","Prod.Gar","Prod.Gar","Prod.Gar","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","84","ADE_XRZSOC","C",50,00,"RzSocial","RzSocial","RzSocial","RzSocial","RzSocial","RzSocial","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","85","ADE_XSTATG","C",30,00,"StatusGar","StatusGar","StatusGar","StatusGar","StatusGar","StatusGar","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","86","ADE_XCNPJC","C",15,00,"CnpjCertif.","CnpjCertif.","CnpjCertif.","CnpjCertif.","CnpjCertif.","CnpjCertif.","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","87","ADE_PEDANT","C",10,00,"PedGarAnt","PedGarAnt","PedGarAnt","PedGarAnt","PedGarAnt","PedGarAnt","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","88","ADE_XARVLD","C",50,00,"ArVld","ArVld","ArVld","ArVld","ArVld","ArVld","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","89","ADE_XDTVRF","D",08,00,"DtVerif.","DtVerif.","DtVerif.","DtVerif.","DtVerif.","DtVerif.","@D","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","90","ADE_XDVLD","D",08,00,"DtVld","DtVld","DtVld","DtVld","DtVld","DtVld","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","91","ADE_XHRVRF","C",08,00,"HrVerif.","HrVerif.","HrVerif.","HrVerif.","HrVerif.","HrVerif.","99:99:99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","92","ADE_XHVLD","C",08,00,"HrVld","HrVld","HrVld","HrVld","HrVld","HrVld","99:99:99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","93","ADE_XPSTVL","C",50,00,"PostoVld","PostoVld","PostoVld","PostoVld","PostoVld","PostoVld","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","94","ADE_XPSTVR","C",50,00,"PostoVrf","PostoVrf","PostoVrf","PostoVrf","PostoVrf","PostoVrf","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","95","ADE_XAGTVL","C",50,00,"AgenteVld","AgenteVld","AgenteVld","AgenteVld","AgenteVld","AgenteVld","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","96","ADE_XAGTVR","C",50,00,"AgenteVrf","AgenteVrf","AgenteVrf","AgenteVrf","AgenteVrf","AgenteVrf","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","97","ADE_DOCSUP","C",06,00,"CodSupervis","CodSupervis","CodSupervis","CodigodoSupervisor","CodigodoSupervisor","CodigodoSupervisor","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","98","ADE_CODIAR","C",06,00,"CodigoAR","CodigoAR","CodigoAR","CodigoAR","CodigoAR","CodigoAR","","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","99","ADE_NOMSUP","C",30,00,"NomSupervis","NomSupervis","NomSupervis","NomedoSupervisor","NomedoSupervisor","NomedoSupervisor","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A0","ADE_NOMEAR","C",30,00,"NomeAR","NomeAR","NomeAR","NomeAR","NomeAR","NomeAR","","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A1","ADE_CODIAC","C",06,00,"CodigoAC","CodigoAC","CodigoAC","CodigoAC","CodigoAC","CodigoAC","","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A2","ADE_NOMEAC","C",30,00,"NomeAC","NomeAC","NomeAC","NomeAC","NomeAC","NomeAC","","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A3","ADE_XAC","C",50,00,"Ac","Ac","Ac","Ac","Ac","Ac","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A4","ADE_XAR","C",50,00,"Ar","Ar","Ar","Ar","Ar","Ar","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A5","ADE_TELPTO","C",10,00,"TeldoPosto","TeldoPosto","TeldoPosto","TelefonedoPosto","TelefonedoPosto","TelefonedoPosto","@R99-9999-9999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A5","ADE_MAILPT","C",40,00,"MailCtoPos","MailCtoPos","MailCtoPos","EmaildecontatodoPosto","EmaildecontatodoPosto","EmaildecontatodoPosto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A6","ADE_XDEMIS","D",08,00,"DataEmissao","DataEmissao","DataEmissao","DataEmissao","DataEmissao","DataEmissao","@D","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A7","ADE_ORGUNI","C",02,00,"Org.Unit","Org.Unit","Org.Unit","Org.Unit","Org.Unit","Org.Unit","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A8","ADE_CODREG","C",06,00,"CodigoRegra","CodigoRegra","CodigoRegra","CodigoRegra","CodigoRegra","CodigoRegra","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B1","ADE_REGRA","M",80,00,"Regra","Regra","Regra","RegradacaixadeEntrada","RegradacaixadeEntrada","RegradacaixadeEntrada","","","€€€€€€€€€€€€€€ ","If(inclui,'',MSMM(ADE->ADE_CODREG,80))","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B2","ADE_XHEMIS","C",08,00,"HrEmissao","HrEmissao","HrEmissao","HrEmissao","HrEmissao","HrEmissao","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B3","ADE_COMNAM","C",60,00,"CommonName","CommonName","CommonName","CommonName","CommonName","CommonName","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B4","ADE_XVALID","C",10,00,"Validade","Validade","Validade","ValidadedoCertificado","ValidadedoCertificado","ValidadedoCertificado","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B5","ADE_XDTEXP","D",08,00,"Dt.Expiracao","Dt.Expiracao","Dt.Expiracao","DatadeExpiracao","DatadeExpiracao","DatadeExpiracao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})

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
AADD(aRegs,{"SU4","01","U4_FILIAL","C",02,00,"Filial","Sucursal","Branch","Filial","Sucursal","Branch","@!","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"„€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","02","U4_TIPO","C",01,00,"TipoLista","TipoLista","ListType","ObjetivodaLista","ObjetivodelaLista","ListPurpose","@!","Pertence('1234')","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(INCLUI,'1','')","",01,"†€","","","","S","A","","","","1=Marketing;2=Cobranca;3=Vendas;4=TeleAtendimento","1=Marketing;2=Cobro;3=Ventas;4=TeleAtencion","1=Marketing;2=Collection;3=Sales;4=CustomerService","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","03","U4_STATUS","C",01,00,"Status","Estatus","Status","StatusdaLista","EstatusdelaLista","ListStatus","@!","Pertence('123')","€€€€€€€€€€€€€€€","","",01,"†À","","","","S","V","","","","1=Ativa;2=Encerrada;3=EmAndamento","1=Activa;2=Finalizada;3=EnProceso","1=Active;2=Concluded;3=InCourse","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","04","U4_LISTA","C",06,00,"Codigo","Codigo","Code","CodigodaLista","CodigodelaLista","ListCode","999999","naovazio()","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(INCLUI,GETSXENUM('SU4','U4_LISTA'),SU4->U4_LISTA)","",01,"“€","","","","S","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","05","U4_DESC","C",60,00,"NomeLista","NombreLista","ListName","NomedaLista","NombredelaLista","ListName","@x","Naovazio()","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"›€","","","","S","A","","","","","","","","","","","","S","","","S","N","","","N","N","N"})
AADD(aRegs,{"SU4","06","U4_DATA","D",08,00,"Data","Fecha","Date","DatadageracaodaLista","FechageneraciondeLista","ListGenerationDate","99/99/99","NaoVazio().AND.M->U4_DATA>=dDatabase.AND.TK061DATA()","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","dDataBase","",01,"›€","","","","S","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","07","U4_HORA1","C",08,00,"HoraInicial","HoraInicial","Init.Time","HoraInicialparacontato","HoraIniciop/contacto","InitialTime","99:99:99","","€€€€€€€€€€€€€€ ","","",01,"–À","","","","N","A","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","08","U4_FORMA","C",01,00,"TipoContato","TipoContact","ContactType","TipodeMarketing","Tipodetelemercadeo","ContactType","9","Pertence('1234')","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"›€","","S","","N","A","","","","1=Voz;2=Fax;3=CrossPosting;4=MalaDireta;5=Pendencia;6=Website","1=Voz;2=Fax;3=CrossPosting;4=CorreoDirecto;5=Pendencia;6=Website","1=Voice;2=Fax;3=CrossPosting;4=DirectMail;5=Pending;6=Website","","","Tk061DescForma(SU4->U4_FORMA)","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","09","U4_TELE","C",01,00,"Rotina","Rutina","Routine","RotinadeAtendimento","RutinadeAtencion","ServiceRoutine","9","Iif(IsInCallStack('TMKA061'),Pertence('125'),Pertence('3'))","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(INCLUI,'1',SU4->U4_TELE)","",01,"„€","","","","N","A","","","","1=TeleMarketing;2=TeleVendas;3=TeleCobranca;4=Todos;5=Teleatendimento","1=TeleMarketing;2=TeleVentas;3=TeleCobro;4=Todos;5=Teleatencion","1=Telemarketing;2;Telesales;3=TeleCollection;4=All;5=CustomerService","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","10","U4_OPERAD","C",06,00,"Operador","Operador","Operator","Operador","Operador","Operator","999999","Tk061VldOp()","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","FU7",01,"†€","","S","","S","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","11","U4_NOPERAD","C",40,00,"Nome","Nombre","Name","NomedoOperador","NombredelOperador","OperatorName","@!","","€‚€€€€€€€€€€€€€","IIF(!INCLUI,Posicione('SU7',1,xFilial('SU7')+SU4->U4_OPERAD,'U7_NOME'),'')","",01,"šÀ","","","","S","V","V","","","","","","","","Posicione('SU7',1,xFilial('SU7')+SU4->U4_OPERAD,'U7_NOME')","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","12","U4_CONFIG","C",06,00,"Configuracao","Configurac.","Conf.","ConfiguracaodeTMK","ConfiguraciondeTelemerc","TMKConfiguration","999999","IIF(!EMPTY(M->U4_CONFIG),ExistCpo('SUE',M->U4_CONFIG),.T.)","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","SUE",01,"šÀ","","","","N","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","13","U4_TIPOTEL","C",01,00,"Telefone","Tp.Telefono","Teleph.Type","TipodoTelefone","TipodeTelefono","TelephoneType","9","IIF(M->U4_FORMA=='1',Pertence('1245'),IIF(M->U4_FORMA=='2',Pertence('3'),Vazio()))","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"‚€","","","","N","","","","","1=Residencial;2=Celular;3=Fax;4=Comercial1;5=Comercial2","1=Residencial;2=Celular;3=Fax;4=Comercial1;5=Comercial2","1=Home;2=Celular;3=Fax;4=Work1;5=Work2","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","14","U4_MALADIR","C",30,00,"Arquivo","Archivo","File","ArquivodeMala-Direta","ArchivoMailingDirecto","MailingFile","@!","IIF(M->U4_FORMA=='2'.OR.M->U4_FORMA=='3'.OR.M->U4_FORMA=='4',Naovazio(),(Vazio(),Tk061VLD()))","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","ARQ",01,"š€","","","","N","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","15","U4_TIPOEND","C",01,00,"Endereco","Direccion","Address","Endereçoparaenvio","Direccionparaenvio","AddressforRemit.","9","IIF(M->U4_FORMA=='4',Pertence('12'),Vazio())","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"’€","","","","N","A","","","","1=Residencial;2=Comercial","1=Residencial;2=Comercial","1=Home;2=Work","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","16","U4_LABEL","C",01,00,"Etiqueta","Etiqueta","Label","GerarEtiquetas","GenerarEtiquetas","GenerateLabels","9","IIF(M->U4_FORMA=='4',Pertence('12'),Vazio())","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"’À","","","","N","A","","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","17","U4_ETIQUET","C",30,00,"Arq.Etiqueta","Arc.Etiqueta","LabelFile","ArquivodeEtiqueta","ArchivodeEtiqueta","LabelsFile","@!","IIF(M->U4_LABEL=='1',Naovazio(),Vazio())","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","AR1",01,"šÀ","","","","N","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","18","U4_CODCAMP","C",06,00,"Campanha","Campa±a","Campaign","Campanha","Campana","Campaign","999999","IIF(!Empty(M->U4_CODCAMP),ExistCpo('SUO',M->U4_CODCAMP),.T.)","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","SUO",01,"†€","","S","","N","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","19","U4_DESCCAM","C",40,00,"Descricao","Descripcion","Description","DescricaodaCampanha","DescripciondeCampa±a","CampaignDescription","@!","","€‚€€€€€€€€€€€€€","IIF(!INCLUI,Posicione('SUO',1,xFilial('SUO')+SU4->U4_CODCAMP,'UO_DESC'),'')","",01,"šÀ","","","","N","V","V","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","20","U4_SCRIPT","C",06,00,"Script","Script","Script","CodigodoScript","CodigodeScript","ScriptCode","999999","IIF(!Empty(M->U4_SCRIPT),ExistCpo('SUZ',M->U4_SCRIPT),.T.)","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","FUZ",01,"‚À","","","","S","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","21","U4_EVENTO","C",06,00,"Evento","Evento","Event","CodigodoEvento","CodigodeEvento","EventCode","999999","IIF(!Empty(M->U4_EVENTO),EXISTCPO('ACD',M->U4_EVENTO),.T.)","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","FCD",01,"‚À","","","","N","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","22","U4_ASSUNTO","C",80,00,"Assunto","Asunto","Subjetc","AssuntodoEmail","AsuntodeEmail","E-mailSubject","","","€€€€€€€€€€€€€€€","","",01,"š€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","23","U4_CODMENS","C",06,00,"CodigoMsg.","CodigoMsj.","MessageCode","Codigodamensagememail","Codigodemensajeemail","E-mailmessagecode","@!","","€€€€€€€€€€€€€€€","","",01,"š€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","24","U4_ATTACH","C",254,00,"Anexos","Adjuntos","Attachments","Anexos","Adjuntos","Attachments","@!","","€€€€€€€€€€€€€€€","","",01,"š€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","25","U4_FILTRO","C",40,00,"Filtro","Filtro","Filter","Filtroutilizado","FiltroUtilizado","FilterUsed","@!","","€€€€€€€€€€€€€€€","","",01,"‚€","","","","N","V","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","26","U4_CRONUM","C",06,00,"Codigo","Codigo","Code","Codigo","Codigo","Code","@!","","€€€€€€€€€€€€€€€","","",01,"€€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","27","U4_CLIENTE","C",06,00,"OperadorAnt","Cliente","P.Operator","Operadoranterior","Cliente","PreviousOperator","@!","","€€€€€€€€€€€€€€€","","",01,"„À","","","","N","A","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","28","U4_LOJA","C",02,00,"Chamadas","Llamadas","Unit","Qtd.deChamadasRealizad","Cant.deLLamadasRealliz","Unit","@!","","€€€€€€€€€€€€€€€","","",01,"€€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","29","U4_NREDUZ","C",20,00,"TotalItens","Nombre","Name","TotaldeitensdaLista","Nombrereducido","ReducedName","999999","","€€€€€€€€€€€€€€€","","",01,"–€","","","","N","A","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","30","U4_HORA2","C",08,00,"HoraFinal","HoraFin","FinalTime","Horafinalparacontato","HoraFin","ContactFinalTime","99:99:99","","€€€€€€€€€€€€€€€","","",01,"–À","","","","N","A","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","31","U4_NCONTAT","C",40,00,"Nome","Nombre","Name","Nomedocontato","Nombredecontacto","ContactName","@!","","€€€€€€€€€€€€€€€","","",01,"€€","","","","N","V","V","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","32","U4_OCODISC","C",02,00,"AnoNasc.","Estatus","Status","AnodeNascimento","Codigodelestatus","StatusCode","99","","€€€€€€€€€€€€€€€","","",01,"†À","","","","N","A","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","33","U4_NSTATUS","C",20,00,"Off","Descripcion","Description","Off","Descripcion","Description","","","€€€€€€€€€€€€€€€","","",01,"„€","","","","N","","V","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","34","U4_NIVEL","C",01,00,"Lembrete","Recordatorio","Reminder","Lembretemessenger","RecordatorioMessenger","MessengerReminder","","Pertence('12')","€€€€€€€€€€€€€€€","","",01,"„À","","","","N","A","R","","","1=Sim;2=Näo","1=Si;2=No","1=Yes;2=No","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","35","U4_CODLIG","C",06,00,"Cod.Ligacao","Cod.Llamada","LinkCode","Codigodaligacao","Codigodellamada","LinkCode","999999","","€€€€€€€€€€€€€€€","","",01,"€€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","36","U4_PROSPEC","C",01,00,"Periodicidad","Periodicidad","Periodicity","Periodicidade","Periodicidad","Periodicity","@!","Pertence('12')","€€€€€€€€€€€€€€€","","",01,"–À","","","","N","A","R","","","1=Sim;2=Näo","1=Si;2=No","1=Yes;2=No","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","37","U4_FAXARQ","C",14,00,"Off","Off","Off","Off","Off","Off","","","€€€€€€€€€€€€€€€","","",01,"„€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","38","U4_MESSAGE","M",40,00,"Mensagem","Mensaje","Message","Mensagemdoe-mail","Mensajedee-mail","E-mailMessage","","","€€€€€€€€€€€€€€€","","",01,"€€","","","","N","","V","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","39","U4_CONTATO","C",06,00,"DataAnivers","Contacto","Birthday","DatadeAniversario","Contacto","Birthday","","","€€€€€€€€€€€€€€€","","",01,"†À","","","","N","A","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","40","U4_ROTINA","C",15,00,"Rotina","Rutina","Routing","RotinaEncerramento","RutinaCierre","Closingroutine","@!","","€€€€€€€€€€€€€€€","","",01,"€€","","","","N","V","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU4","41","U4_XDTVENC","D",08,00,"Vencimento","Vencimento","Vencimento","DatadeVencimento","DatadeVencimento","DatadeVencimento","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SU4","42","U4_XGRUPO","C",02,00,"Grupo","Grupo","Grupo","Grupodeatendimento","Grupodeatendimento","Grupodeatendimento","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
AADD(aRegs,{"SU6","01","U6_FILIAL","C",02,00,"Filial","Sucursal","Branch","Filial","Sucursal","Branch","99","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"€€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","02","U6_LISTA","C",06,00,"CodigoLista","CodigoLista","ListCode","CodigodaLista","CodigodelaLista","ListCode","999999","ExistChav('SU4').AND.FreeForUse('SU4',M->U4_LISTA)","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"‚€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","03","U6_CODIGO","C",06,00,"Codigo","Codigo","Code","CodigodeInteracao","CodigodeInteraccion","Contact","@!","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(INCLUI,GetSxENum('SU6','U6_CODIGO'),M->U6_CODIGO)","",01,"ƒ€","","","","S","V","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","04","U6_CONTATO","C",06,00,"Contato","Contacto","Contact","Contato","Contacto","Contact","@!","IIF(INCLUI,Tk061ValContM(M->U6_CONTATO),.T.).AND.Tk061EntCont(M->U6_CONTATO)","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","SU5",01,"‚€","","","","S","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","05","U6_NCONTAT","C",40,00,"Nome","Nombre","Name","NomedoContato","NombredelContacto","ContactName","@!","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIf(!INCLUI,Posicione('SU5',1,xFilial('SU5')+SU6->U6_CONTATO,'U5_CONTAT'),'')","",01,"’À","","","","S","V","V","","","","","","","","Posicione('SU5',1,xFilial('SU5')+SU6->U6_CONTATO,'U5_CONTAT')","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","06","U6_FILENT","C",02,00,"Fil.Entidade","Suc.Entidad","Entit.Branch","FilialdaEntidade","SucursaldelaEntidad","EntityBranch","99","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"€€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","07","U6_ENTIDA","C",03,00,"Entidade","Entidad","Entity","Entidade","Entidad","Entity","@!","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"–€","","","","N","V","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","08","U6_DENTIDA","C",30,00,"Entidade","Entidad","Entity","DescriçãodaEntidade","DescripciondelaEntidad","EntityDescription","","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(!INCLUI,Posicione('SX2',1,SU6->U6_ENTIDA,'X2NOME()'),'')","",01,"–À","","","","N","V","V","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","09","U6_CODENT","C",25,00,"Cod.Entidade","Cod.Entidad","EntityCode","Codigodaentidade","Codigodelaentidad","EntityCode","@!","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"›€","","","","N","V","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","10","U6_DESCENT","C",30,00,"Nome","Nombre","Name","NomedaChave","NombredelaClave","KeyName","@!","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(!INCLUI,TkEntidade(SU6->U6_ENTIDA,SU6->U6_CODENT,1),'')","",01,"‚€","","","","N","V","V","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","11","U6_ORIGEM","C",01,00,"Origem","Atend.Origem","Source","OrigemdaInteracao","OrigendeInteraccion","InteractionSource","9","Pertence('12')","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(INCLUI,'1',SU6->U6_ORIGEM)","",01,"’€","","","","N","V","","","","1=Lista;2=Manual;3=Atendimento","1=Lista;2=Manual;3=Atencion","1=List/Table;2=Manual;3=Servicing","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","12","U6_DATA","D",08,00,"Data","Fecha","Date","Data","Fecha","Date","","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(INCLUI,M->U4_DATA,SU6->U6_DATA)","",01,"’€","","","","S","V","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","13","U6_HRINI","C",05,00,"Inicio","Inicio","Start","HoraInicio","HoraInicial","InitialTime","99:99","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(INCLUI,'09:00',SU6->U6_HRFIM)","",01,"‚€","","","","S","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","14","U6_HRFIM","C",05,00,"HoraFim","HoraFinal","FinalTime","HoraFim","HoraFinal","FinalTime","99:99","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(INCLUI,'17:00',SU6->U6_HRINI)","",01,"‚€","","","","S","A","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","15","U6_STATUS","C",01,00,"Status","Estatus","Status","StatusdaInteracao","EstatusdelaInteraccion","InteractionStatus","9","Pertence('123')","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","IIF(INCLUI,'1',SU6->U6_STATUS)","",01,"‚€","","","","S","A","","","","1=NaoEnviado;2=EmUso;3=Enviado","1=NoEnviado;2=EnUso;3=Enviado","1=NotSent;2=InUse;3=Sent","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","16","U6_CODLIG","C",06,00,"Atend.Origem","Atenc.Origen","Orig.Servic.","CodigodoAtend.Origem","CodigodeAtenc.Origen","SourceServic.Code","999999","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"‚€","","","","N","V","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","17","U6_CODOPER","C",06,00,"Operador","Operador","Operator","CodigodoOperador","CodigodelOperador","OperatorCode","@!","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"†€","","","","N","V","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU6","18","U6_ROTINA","C",15,00,"Rotina","Rutina","Routine","RotinaEncerramento","RutinaCierre","Closingroutine","@!","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"€€","","","","N","V","","","","","","","","","","","","S","","","S","N","","","N","N","N"})
AADD(aRegs,{"SU6","19","U6_DTBASE","D",08,00,"DataBase","FechaBase","Basedate","Datadegeracaodalista","Fchdegener.delalista","Listgenerationdate","@D","","ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá","","",01,"€€","","","","N","V","R","","","","","","","","","","","S","","","S","N","N","","N","N","N"})

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
AADD(aRegs,{"SU7","01","U7_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","SucursaldelSistema","SystemBranch","@!","","€€€€€€€€€€€€€€€","","",01,"€€","","","","N","","","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","02","U7_COD","C",06,00,"Codigo","Codigo","Code","CodigodoOperador","CodigodelOperador","OperatorCode","@!","NaoVazio().AND.ExistChav('SU7',M->U7_COD,1,'EXISTOPER').AND.FreeForUse('SU7',M->U7_COD)","€‚€€€€€€€€€€€€ˆ","IIF(INCLUI,GETSXENUM('SU7','U7_COD'),'')","",01,"‡€","","","","S","A","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","03","U7_NOME","C",40,00,"Nome","Nombre","Name","NomedoOperador","NombredelOperador","OperatorName","@x","texto()","€‚€€€€€€€€€€€€€","","",01,"“€","","","","S","","","","","","","","","","","","1","S","","","S","N","","","N","N","N"})
AADD(aRegs,{"SU7","04","U7_NREDUZ","C",15,00,"NomeReduzid","NombreReduc","ShortName","NomeReduzidodoOperador","NombreReducdelOperador","ShortNameforOperator","@x","texto()","€‚€€€€€€€€€€€€€","","",01,"“€","","","","S","V","R","","","","","","","","","","1","S","","","S","N","","","N","N","N"})
AADD(aRegs,{"SU7","05","U7_END","C",40,00,"Endereco","Direccion","Address","EnderecodoOperador","DirecciondelOperador","AddressofOperator","@x","Texto().OR.Vazio()","€‚€€€€€€€€€€€€€","","",01,"’À","","","","S","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","06","U7_BAIRRO","C",20,00,"Bairro","Barrio","District","BairrodoOperador","BarriodelOperador","OperatorDistrict","@x","Texto().OR.Vazio()","€‚€€€€€€€€€€€€€","","",01,"’À","","","","S","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","07","U7_MUN","C",15,00,"Municipio","Municipio","City","MunicipiodoOperador","MunicipiodoOperador","OperatorCity","@x","Texto().OR.Vazio()","€‚€€€€€€€€€€€€€","","",01,"’À","","","","S","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","08","U7_EST","C",02,00,"Estado","Estado","State","SigladaFederacao","SigladelEstado","InitialsState","@!","ExistCpo('SX5','12'+M->U7_EST)","€‚€€€€€€€€€€€€€","","12",01,"’À","","","","N","","","","","","","","","","","010","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","09","U7_CEP","C",08,00,"CEP","CP","ZipCode","CodEnderecamentoPostal","CodDireccionPostal","ZipCode","@R99999-999","naovazio()","€‚€€€€€€€€€€€€€","","",01,"’À","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","10","U7_CGC","C",14,00,"CPF/CNPJ","CPF/CNPJ","CPF/CNPJ","CPF/CNPJdoOperador","CPF/CNPJdelOperador","Operator`sCPF/CNPJ","@R99.999.999/9999-99","Vazio().or.(CGC(M->U7_CGC).AND.Existchav('SU7',M->U7_CGC,2,'U7_CGC').AND.FreeForUse('SU7',M->U7_CGC))","€‚€€€€€€€€€€€€€","","",01,"’À","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","11","U7_FAX","C",15,00,"FAX","FAX","FAX","NumerodoFAXdoOperador","NºdeFAXdelOperador","OperatorFAXNumber","@!","","€‚€€€€€€€€€€€€€","","",01,"’À","","","","S","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","12","U7_TEL","C",15,00,"Telefone","Telefono","Phone","NumerodoTelefone","NumerodelTelefono","PhoneNumber","@!","","€‚€€€€€€€€€€€€€","","",01,"’À","","","","S","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","13","U7_VEND","C",01,00,"Vendedor","Vendedor","SalesRepres","OperadoreVendedor","OperadoryVendedor","OperatorandSeller","!","vazio().OR.Pertence('12')","€‚€€€€€€€€€€€€€","","",01,"‚À","","S","","N","A","","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","2","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","14","U7_CODVEN","C",06,00,"Cod.Vendedor","CodVendedor","Sl.Rep.Code","Codigonocad.vendedor","CodigodelReg.Vendedor","SalesRep.Code","@!","ExistCpo('SA3').Or.Vazio()","€€€€€€€€€€€€€€ ","","SA3",01,"†À","","","","N","A","R","","","","","","","M->U7_VEND=='1'","","","2","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SU7","15","U7_POSTO","C",02,00,"Grupo","PuestoVenta","Group","GrupodeAtendimento","PuestodeVentas","ServicingGroup","99","ExistCpo('SU0').Or.Vazio()","€‚€€€€€€€€€€€€€","","SU0",01,"ƒ€","","","","N","V","","","","","","","","","","","2","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","16","U7_TIPOATE","C",01,00,"Atendimento","Atencion","Service","AtendimentoporRotina","AtencionporRotina","ServicebyRoutine","!","Pertence('123456')","€‚€€€€€€€€€€€€€","IIF(INCLUI,'4','')","",01,"—€","","","","S","A","","","","1=TeleMarketing;2=TeleVendas;3=Telecobranca;4=Todos;5=TmkeTlv;6=TeleAtendimento","1=TeleMarketing;2=Televentas;3=Telecobranza;4=Todos;5=TmkyTlv;6=Teleatencion","1=Telemarketing;2=Telesales;3=Telecollection;4=All;5=TmkandTls;6=Teleservice","","","","","2","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","17","U7_REGIAO","C",02,00,"Regiao","Region","Area","AtendeChamadasdaRegiao","AtiendeLlamadasRegion","ServeCallsinRegion","@!","Vazio().OR.ExistCpo('SX5','12'+M->U7_REGIAO)","€‚€€€€€€€€€€€€€","","12",01,"’À","","","","N","A","","","","","","","","","","","2","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","18","U7_HABIL","C",06,00,"Habilidade","Habilidad","Skill","HabilidadedoOperador","HabilidaddelOperador","OperatorSkill","@!","ExistCpo('SX5','A4'+M->U7_HABIL)","€‚€€€€€€€€€€€€€","","A4",01,"‚À","","","","S","","","","","","","","","","","","2","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","19","U7_CONTA","C",20,00,"ContaE-mail","Cuent.E-mail","E-mailAcco.","Contanoservidoremail","Cuentaenservidore-mail","E-MailServerAccount","","","€€€€€€€€€€€€€€€","","",01,"’€","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","20","U7_SENHA","C",10,00,"SenhaE-mail","ClaveE-mail","E-mailPass.","Senhanoservidoremail","ClaveenservidorE-mail","E-MailServerPassword","","","€€€€€€€€€€€€€€€","","",01,"’€","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","21","U7_TAREFA","N",03,00,"Qtd.Tarefas","Ctd.Tareas","No.tasks","QuantidadedeTarefas","CantidaddeTareas","NumberofTask","999","","€€€€€€€€€€€€€€€","","",01,"–€","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","22","U7_VALIDO","C",01,00,"Valido","Valido","Valid","OperadorValido","OperadorValido","Validoperator","!","Pertence('12')","€‚€€€€€€€€€€€€€","IIF(INCLUI,'1','')","",01,"‡€","","","","N","A","","","","1=Sim;2=Nao","1=Si;2=No","1=Yes;2=No","","","","","2","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","23","U7_CFGBTN","C",33,00,"Botões","Botones","Buttons","Configurabotõesdabarra","Config.botonesdelmenu","Configurebarbuttons","9999999999999999999999999999999999","","€€€€€€€€€€€€€€€","","",01,"„€","","","","N","V","","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","24","U7_TIPO","C",01,00,"Tipo","Tipo","Type","Operador/Supervisor","Operador/Supervisor","Operator/Supervisor","@!","Pertence('12')","€€€€€€€€€€€€€€ ","IIF(INCLUI,'1',SU7->U7_TIPO)","",01,"…€","","","","N","A","R","","","1=Operador;2=Supervisor","1=Operador;2=Supervisor","1=Operator;2=Supervisor","","","","","2","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","25","U7_CODUSU","C",06,00,"Cod.Usuario","Cod.Usuario","UserCode","Codigodousuario","Codigodelusuario","UserCode","@!","","€€€€€€€€€€€€€€˜","","US2",01,"†À","","","","N","V","R","","","","","","","","","","","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","26","U7_CODRD0","C",06,00,"Participante","Participante","Participant","Codigodoparticipante","Codigodelparticipante","ParticipantCode","@!","Vazio().OR.ExistCpo('RD0')","€€€€€€€€€€€€€€ ","IIF(!INCLUI,FGetPessoa('SU7',xFilial('SU7')+SU7->U7_COD),'')","RD0",01,"†À","","S","","N","A","V","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","27","U7_DESCRD0","C",60,00,"NomePartic.","NombreParti","Partc.Name","Nomedoparticipante","Nombredelparticipante","ParticipantName","@!","","€€€€€€€€€€€€€€ ","Tk090Rd0Nome()","",01,"†À","","","","N","V","V","","","","","","","","","","1","S","","","N","N","","","N","N","N"})
AADD(aRegs,{"SU7","28","U7_AGENTID","C",50,00,"AgentID","AgentID","AgentID","IDdoAgentenoDAC","IDdelAgenteenDAC","AgentIDinDAC","","","€‚€€€€€€€€€€€€€","","",01,"”À","","","","S","A","R","","","","","","","","","","3","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SU7","29","U7_PENDCHA","C",01,00,"AssumeCh.","AsumeCh.","AssumeCh.","AssumirpendênciaHD","AsumirpendenciaHD","AssumeHDpendency","","","€‚€€€€€€€€€€€€€","'2'","",01,"†À","","","","N","A","R","","","1=Sim;2=Não;3=Pergunte","1=Si;2=No;3=Pregunte","1=Yes;2=No;3=Ask","","","","","2","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"SU7","30","U7_SUBSTIT","C",06,00,"Substituto","Substituto","Substituto","OperadorSubstituto","OperadorSubstituto","OperadorSubstituto","@!","Tk090Substit()","€€€€€€€€€€€€€€ ","","TMK016",00,"şÀ","","","S","N","A","R","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"SU7","31","U7_XASSUNT","C",06,00,"Assunto","Assunto","Assunto","Assunto","Assunto","Assunto","999999","","€€€€€€€€€€€€€€ ","","T1",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SU7","32","U7_XDESASS","C",30,00,"Desc.Assunt","Desc.Assunt","Desc.Assunt","Desc.Assunt","Desc.Assunt","Desc.Assunt","@x","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","V","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SU7","33","U7_XQTDATD","N",03,00,"Qtd.Atend.","Qtd.Atend.","Qtd.Atend.","Qtd.Atend.","Qtd.Atend.","Qtd.Atend.","999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SU7","34","U7_XJCHAT","C",01,00,"Jan.Chat?","Jan.Chat?","Jan.Chat?","Jan.Chat?","Jan.Chat?","Jan.Chat?","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","0=Nenhuma;1=Uma;2=Duas;3=Tres;4=Quatro","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SU7","35","U7_USERLGI","C",17,00,"LogdeInclu","LogdeInclu","LogdeInclu","LogdeInclusao","LogdeInclusao","LogdeInclusao","","","€€€€€€€€€€€€€€€","","",09,"şÀ","","","L","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SU7","35","U7_XOPELIS","C",06,00,"Oper.Lista","Oper.Lista","Oper.Lista","Oper.Lista","Oper.Lista","Oper.Lista","","","€€€€€€€€€€€€€€ ","","SU7NEW",00,"şÀ","","","U","N","A","R","","M->U7_XOPELIS<>M->U7_COD.and.Posicione('SU7',1,Xfilial('SU7')+M->U7_XOPELIS,'U7_TIPO')=='2'","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SU7","36","U7_USERLGA","C",17,00,"LogdeAlter","LogdeAlter","LogdeAlter","LogdeAlteracao","LogdeAlteracao","LogdeAlteracao","","","€€€€€€€€€€€€€€€","","",09,"şÀ","","","L","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SU7","36","U7_XQTDLST","N",01,00,"Qtd.Lista","Qtd.Lista","Qtd.Lista","Qtd.Lista","Qtd.Lista","Qtd.Lista","@9","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"","MV_TMKPHJ","L","Indicaseaspendenciasencerradasnadatabase","Indicasilaspendenciasencerradasenladatabase","Itindicatesifholdoversfinishedinthedatabase","serãoexibidasnopaineldependenciasagendadas.","semostraranenelpaneldependenciasagendadas.","willbedisplayedinthescheduleofpendingissue","","","",".T.",".T.",".T.","S","S","","",".T.",".T.",".T."})

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
AADD(aRegs,{"","SDK_ASSUNT","C","ASSUNTOCHAT","","","","","","","","","CHAT01","","","","","","","","",""})

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
AADD(aRegs,{"","SDK_OCORRE","C","CODIGODACORRENCIA-IMPORTACAODEMAINLING","CODIGODACORRENCIA-IMPORTACAODEMAINLING","CODIGODACORRENCIA-IMPORTACAODEMAINLING","","","","","","","003083","","","U","","","","","",""})

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
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"ADE","1","ADE_FILIAL+ADE_CODIGO","Codigo","Codigo","Code","S","","","S"})
AADD(aRegs,{"ADE","2","ADE_FILIAL+ADE_OPERAD+ADE_GRUPO","Analista+Equipe","Analista+Equipo","Analyst+Team","S","","","S"})
AADD(aRegs,{"ADE","3","ADE_FILIAL+ADE_GRUPO+ADE_OPERAD","Equipe+Analista","Equipo+Analista","Team+Analyst","S","","","S"})
AADD(aRegs,{"ADE","4","ADE_FILIAL+ADE_CHANEX","CHAssociado","CHAsociado","CHLinked","S","","","S"})
AADD(aRegs,{"ADE","5","ADE_FILIAL+ADE_DTEXPI","DataSLA","FechaSLA","SLADate","S","","","S"})
AADD(aRegs,{"ADE","6","ADE_FILIAL+ADE_CODIGO+ADE_GRUPO+ADE_DATA+ADE_STATUS","Codigo+Equipe+DTAbertura+Status","Codigo+Equipo+Fc.Apertur+Estatus","Code+Team+OpeningDt+Status","S","","","N"})
AADD(aRegs,{"ADE","7","ADE_FILIAL+ADE_CODIGO+ADE_GRUPO+ADE_DATA+ADE_STATUS+ADE_CHAVE+ADE_ENTIDA","Codigo+Equipe+DTAbertura+Status+CodEntidade+Entidade","Codigo+Equipo+Fc.Apertur+Estatus+CodEntidad+Entidad","Code+Team+OpeningDt+Status+Ent.Code+Entity","S","","","N"})
AADD(aRegs,{"ADE","8","ADE_FILIAL+ADE_CODIGO+ADE_GRUPO+ADE_DATA+ADE_STATUS+ADE_OPERAD","Codigo+Equipe+DTAbertura+Status+Analista","Codigo+Equipo+Fc.Apertur+Estatus+Analista","Code+Team+OpeningDt+Status+Analyst","S","","","N"})
AADD(aRegs,{"ADE","9","ADE_FILIAL+ADE_STATUS","Status","Estatus","Status","S","","","S"})
AADD(aRegs,{"ADE","A","ADE_FILIAL+ADE_GRUPO+ADE_CODIGO+ADE_DATA+ADE_STATUS","Equipe+Codigo+DTAbertura+Status","Equipo+Codigo+Fc.Apertur+Estatus","Team+Code+OpeningDt+Status","S","","","N"})
AADD(aRegs,{"ADE","B","ADE_FILIAL+ADE_DATA+ADE_CODIGO+ADE_CHAVE+ADE_ENTIDA+ADE_STATUS","DTAbertura+Codigo+CodEntidade+Entidade+Status","Fc.Apertur+Codigo+CodEntidad+Entidad+Estatus","OpeningDt+Code+Ent.Code+Entity+Status","S","","","N"})
AADD(aRegs,{"ADE","C","ADE_FILIAL+ADE_GRUPO+ADE_DATA+ADE_OPERAD+ADE_STATUS+ADE_CODIGO","Equipe+DTAbertura+Analista+Status+Codigo","Equipo+Fc.Apertur+Analista+Estatus+Codigo","Team+OpeningDt+Analyst+Status+Code","S","","","N"})
AADD(aRegs,{"ADE","D","ADE_FILIAL+ADE_CODIGO+ADE_CODSB1+ADE_ENTIDA+ADE_OPERAD+ADE_DATA+ADE_CHAVE+ADE_GRUPO","Codigo+Produto+Entidade+Analista+DTAbertura+CodEntidade+","Codigo+Producto+Entidad+Analista+Fc.Apertur+CodEntidad+E","Code+Product+Entity+Analyst+OpeningDt+Ent.Code+Team","S","","","N"})
AADD(aRegs,{"ADE","E","ADE_FILIAL+ADE_CODCON+ADE_DATA+ADE_CODIGO+ADE_OPERAD+ADE_DTEXPI+ADE_STATUS+ADE_CODINC+ADE_SEVCOD+ADE_CHAVE+ADE_ENTIDA+ADE_CODSB1","Contato+DTAbertura+Codigo+Analista+DataSLA+Status+CodIn","Contacto+Fc.Apertur+Codigo+Analista+FechaSLA+Estatus+Cod","Contact+OpeningDt+Code+Analyst+SLADate+Status+IncidentC","S","","","N"})
AADD(aRegs,{"ADE","F","ADE_FILIAL+ADE_CODSB1+ADE_STATUS+ADE_DATA+ADE_CODIGO+ADE_OPERAD+ADE_DTEXPI+ADE_PLVCHV+ADE_CODINC+ADE_SEVCOD+ADE_CHAVE+ADE_ENTIDA","Produto+Status+DTAbertura+Codigo+Analista+DataSLA+Palavr","Producto+Estatus+Fc.Apertur+Codigo+Analista+FechaSLA+Pal","Product+Status+OpeningDt+Code+Analyst+SLADate+KeyWord+","S","","","N"})
AADD(aRegs,{"ADE","G","ADE_FILIAL+ADE_GRUPO+ADE_TIPO+ADE_STATUS+ADE_DATA+ADE_OPERAD","Equipe+Comunicacao+Status+DTAbertura+Analista","Equipo+Comunicacion+Estatus+Fc.Apertur+Analista","Team+Communicat.+Status+OpeningDt+Analyst","S","","","N"})
AADD(aRegs,{"ADE","H","ADE_FILIAL+ADE_STATUS+ADE_REGSLA+ADE_DATA+ADE_GRUPO+ADE_CODSB1+ADE_OPERAD+ADE_DTEXPI+ADE_CODIGO","Status+RegistroSLA+DTAbertura+Equipe+Produto+Analista+Da","Estatus+RegistroSLA+Fc.Apertur+Equipo+Producto+Analista+","Status+SLARegist.+OpeningDt+Team+Product+Analyst+SLADat","S","","","N"})
AADD(aRegs,{"ADE","I","ADE_FILIAL+ADE_ENTIDA+ADE_GRUPO+ADE_DATA+ADE_CHAVE+ADE_CODSB1+ADE_DTEXPI+ADE_FNC+ADE_ASSUNT+ADE_STATUS+ADE_OPERAD+ADE_CODIGO+ADE_TIPO","Entidade+Equipe+DTAbertura+CodEntidade+Produto+DataSLA+","Entidad+Equipo+Fc.Apertur+CodEntidad+Producto+FechaSLA+","Entity+Team+OpeningDt+Ent.Code+Product+SLADate+FNCCode","S","","","N"})
AADD(aRegs,{"ADE","J","ADE_FILIAL+ADE_STATUS+ADE_DATA+ADE_GRUPO+ADE_CODSB1+ADE_OPERAD","Status+DTAbertura+Equipe+Produto+Analista","Estatus+Fc.Apertur+Equipo+Producto+Analista","Status+OpeningDt+Team+Product+Analyst","S","","","N"})
AADD(aRegs,{"ADE","K","ADE_FILIAL+ADE_CODDEC","ChDesc","ChDesc","Degres.Call","S","ChamadoInvertido","","S"})
AADD(aRegs,{"ADE","L","ADE_FILIAL+ADE_CHORIG","ChOriginal","ChOriginal","ChOriginal","S","","","S"})
AADD(aRegs,{"ADE","M","ADE_FILIAL+ADE_FILORI+ADE_CHORIG","Fil.Orig+ChOriginal","Fil.Orig+ChOriginal","Fil.Orig+ChOriginal","S","","","N"})
AADD(aRegs,{"ADE","N","ADE_FILIAL+ADE_PEDGAR+ADE_DATA","PedidoGAR+DTAbertura","PedidoGAR+DTAbertura","PedidoGAR+DTAbertura","U","","PEDIDOGAR","N"})
AADD(aRegs,{"ADE","O","ADE_FILIAL+ADE_RECORR","Recorrente","Recorrente","Recorrente","","","","N"})
AADD(aRegs,{"ADE","P","ADE_FILIAL+ADE_CHORRC+DTOS(ADE_DATA)","Ch.Ori.Rec+DTAbertura","Ch.Ori.Rec+FchApertura","Ch.Ori.Rec+FchApertura","","","","N"})

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
AADD(aRegs,{"SU4","1","U4_FILIAL+U4_LISTA+DTOS(U4_DATA)","Codigo+Data","Codigo+Fecha","Code+Date","S","","","S"})
AADD(aRegs,{"SU4","2","U4_FILIAL+U4_DESC","NomeLista","NombreLista","ListName","S","","","S"})
AADD(aRegs,{"SU4","3","U4_FILIAL+DTOS(U4_DATA)+U4_STATUS","Data+Status","Fecha+Estatus","Date+Status","S","","","S"})
AADD(aRegs,{"SU4","4","U4_FILIAL+U4_CODLIG","Cod.Ligacao","Cod.Llamada","LinkCode","S","","","S"})
AADD(aRegs,{"SU4","5","U4_FILIAL+U4_OPERAD+U4_STATUS","Operador+Status","Operador+Estatus","Operator+Status","S","","","S"})
AADD(aRegs,{"SU4","6","U4_FILIAL+U4_OPERAD+U4_STATUS+U4_XGRUPO","Operador+Status+Grupo","Operador+Status+Grupo","Operador+Status+Grupo","U","","BAIXA_FILA","N"})
AADD(aRegs,{"SU4","7","U4_FILIAL+U4_OPERAD+U4_DESC","Operador+NomeLista","Operador+NombreLista","Operator+NombreLista","U","","CABECLISTA","S"})

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
AADD(aRegs,{"SU6","1","U6_FILIAL+U6_LISTA+U6_CODIGO","CodigoLista+Codigo","CodigoLista+Codigo","ListCode+Code","S","","","S"})
AADD(aRegs,{"SU6","2","U6_FILIAL+DTOS(U6_DATA)+U6_CONTATO","Data+Contato","Fecha+Contacto","Date+Contact","S","","","S"})
AADD(aRegs,{"SU6","3","U6_FILIAL+U6_LISTA+U6_STATUS","CodigoLista+Status","CodigoLista+Estatus","ListCode+Estatus","U","","ITEMLISTA","N"})

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
AADD(aRegs,{"SU7","1","U7_FILIAL+U7_COD","Codigo","Codigo","Code","S","","","S"})
AADD(aRegs,{"SU7","2","U7_FILIAL+U7_CGC","CPF/CNPJ","CPF/CNPJ","CPF/CNPJ","S","","","S"})
AADD(aRegs,{"SU7","3","U7_FILIAL+U7_NOME","Nome","Nombre","Name","S","","","S"})
AADD(aRegs,{"SU7","4","U7_FILIAL+U7_CODUSU","Cod.Usuario","Cod.Usuario","UserCode","S","","","N"})

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
AADD(aRegs,{"SU7NEW","1","01","DB","Supervisores","Supervisores","Supervisores","SU7",""})
AADD(aRegs,{"SU7NEW","2","01","01","Codigo","Codigo","Code","",""})
AADD(aRegs,{"SU7NEW","2","02","03","Nome","Nombre","Name","",""})
AADD(aRegs,{"SU7NEW","4","01","01","Codigo","Codigo","Code","U7_COD",""})
AADD(aRegs,{"SU7NEW","4","01","02","Nome","Nombre","Name","U7_NOME",""})
AADD(aRegs,{"SU7NEW","4","01","03","NomeReduzid","NombreReduc","ShortName","U7_NREDUZ",""})
AADD(aRegs,{"SU7NEW","4","02","01","Nome","Nombre","Name","U7_NOME",""})
AADD(aRegs,{"SU7NEW","4","02","02","Codigo","Codigo","Code","U7_COD",""})
AADD(aRegs,{"SU7NEW","4","02","03","NomeReduzid","NombreReduc","ShortName","U7_NREDUZ",""})
AADD(aRegs,{"SU7NEW","5","01","","","","","SU7->U7_COD",""})
AADD(aRegs,{"SU7NEW","6","01","","","","","SU7->U7_TIPO=='2'",""})

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
