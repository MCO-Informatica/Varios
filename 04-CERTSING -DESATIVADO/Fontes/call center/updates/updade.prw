#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ-ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³UPDADE        ³ Autor ³ OPVS(Warleson)             ³ Data ³ 26/02/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Principal                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Service Desk - Certisign                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UPDADE()

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

Processa({|| ProcATU()},"Processando [UPDADE]","Aguarde , processando preparação dos arquivos")

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
			DEFINE MSDIALOG oDlg TITLE "Atualizador [UPDADE] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
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
±±³Fun‡ao    ³ GeraSX2  ³ Autor ³ OPVS(Warleson)             ³ Data ³   /  /   ³±±
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
AADD(aRegs,{"ADF","                                        ","ADF010  ","Itens do chamado              ","Items del llamado             ","Items of call                 ","                                        ","E",00," ","                                                                                                                                                                                                                                                          ","S",13,"                                                                                                                                                                                                                                                              "})

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
±±³Fun‡ao    ³ GeraSX3  ³ Autor ³ OPVS(Warleson)             ³ Data ³   /  /   ³±±
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
AADD(aRegs,{"ADE","01","ADE_CODIGO","C",06,00,"Protocolo","Codigo","Code","CodigodoChamado","CodigodeLlamada","Tech.CallCode","","","€€€€€€€€€€€€€€","IF(INCLUI,GETNUMADE(),M->ADE_CODIGO)","",01,"‡€","","","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","02","ADE_CODCON","C",06,00,"Contato","Contacto","Contact","Contato","Contacto","Contact","","NaoVazio().And.ExistCpo('SU5')","€€€€€€€€€€€€€€","","TMK002",01,"‡À","","S","","S","A","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","03","ADE_PEDGAR","C",10,00,"PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","@!","Vazio().OR.u_CTSDK05(M->ADE_PEDGAR,.F.)","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","","","","","","","U_WhenGrupos()","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","04","ADE_NMCONT","C",30,00,"NomeContato","NombreCuent","Contc.Name","NomedoContato","NombredelContacto","ContactName","","","€€€€€€€€€€€€€€","IF(!INCLUI,POSICIONE('SU5',1,XFILIAL('SU5')+ADE->ADE_CODCON,'U5_CONTAT'),'')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SU5',1,XFILIAL('SU5')+ADE->ADE_CODCONT,'U5_CONTAT')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","05","ADE_ENTIDA","C",03,00,"Entidade","Entidad","Entity","Entidade","Entidad","Entity","","","€€€€€€€€€€€€€€","","",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","06","ADE_TIPPRF","C",30,00,"Perfil","Perfil","Perfil","TipodePerfildocliente","TipoPerfildelcliente","TypeofCustomerProfile","","","€€€€€€€€€€€€€€°","IF(!INCLUI,Tk510PrfDesc(ADE->ADE_ENTIDA,ADE->ADE_CHAVE),'')","",00,"","","","S","S","V","V","","","","","","","","Tk510PrfDesc(ADE->ADE_ENTIDA,ADE->ADE_CHAVE)","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","07","ADE_NMENT","C",30,00,"NomeEntidad","NombreEntid","Ent.Name","NomedaEntidade","NombredelaEntidad","EntityName","","","€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SX2',1,M->ADE_ENTIDA,'X2NOME()'),'')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SX2',1,ADE->ADE_ENTIDA,'X2NOME()')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","08","ADE_CHAVE","C",25,00,"CodEntidade","CodEntidad","Ent.Code","CodigodaEntidade","CodigodelaEntidad","EntityCode","","","€€€€€€€€€€€€€€","","",01,"„À","","S","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","09","ADE_DESCCH","C",40,00,"Nome","Nombre","Name","Nome","Nombre","Name","","","€€€€€€€€€€€€€€","IIF(!INCLUI,TKENTIDADE(M->ADE_ENTIDA,ADE->ADE_CHAVE,1),'')","",01,"„À","","","","S","V","V","","","","","","","","TKENTIDADE(ADE->ADE_ENTIDA,ADE->ADE_CHAVE,1)","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","10","ADE_EMAIL","C",40,00,"Email","E-mail","E-mail","Email","E-mail","E-mail","","","€€€€€€€€€€€€€€€","","",01,"„À","","","","N","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","11","ADE_DDDRET","C",02,00,"DDD","DDN","AreaCode","DDD","DDN","AreaCode","@R99","","€€€€€€€€€€€€€€","","",01,"†À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","12","ADE_EMAIL2","C",200,00,"Email","Email","Email","Email","Email","Email","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","13","ADE_TELRET","C",08,00,"Telefone","Telefono","Phone","Telefone","Telefono","Phone","@R9999-9999","","€€€€€€€€€€€€€€","","",01,"†À","","","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","14","ADE_DATA","D",08,00,"DTAbertura","Fc.Apertur","OpeningDt","DataAbertura","FechaApertura","OpeningDate","@R99/99/99","","€€€€€€€€€€€€€€","MsDate()","",01,"…À","","","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","15","ADE_HORA","C",05,00,"HRAbertura","H.Apertura","OpeningHr","HRAbertura","H.Apertura","OpeningHour","99:99","","€€€€€€€€€€€€€€","TIME()","",01,"…À","","","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","16","ADE_CODPA8","C",16,00,"CodProdGAR","CodProdGAR","ProdCodGAR","CodigoProdutoGAR","codigoProductoGAR","ProductCodeGAR","@!","","€€€€€€€€€€€€€€ ","","PA8",00,"şA","","S","U","S","A","R","","existcpo('PA8')","","","","","U_WhenGrupos()","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","16","ADE_DINISL","D",08,00,"Dt.IniSLA","Dt.IniSLA","Dt.IniSLA","DatadeIniciodoSLA","DatadeIniciodoSLA","DatadeIniciodoSLA","99/99/99","","€€€€€€€€€€€€€€ ","","",01,"","","","","","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","17","ADE_NMPA8","C",92,00,"Descr.GAR","Descr.GAR","GARDescript","DescricaoGAR","DescricionGAR","GARDescription","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('PA8',1,XFILIAL('PA8')+ADE->ADE_CODPA8,'PA8_DESBPG'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","POSICIONE('PA8',1,XFILIAL('PA8')+ADE->ADE_CODPA8,'PA8_DESBPG')","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","17","ADE_HINISL","C",05,00,"Hr.IniSLA","Hr.IniSLA","Hr.IniSLA","HoradeIniciodoSLA","HoradeIniciodoSLA","HoradeIniciodoSLA","99:99","","€€€€€€€€€€€€€€ ","","",01,"","","","S","S","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","18","ADE_DESCIN","C",30,00,"IndiceEntid","IndiceEntid","Ent.Index","IndicedaEntidade","IndicedelaEntidad","EntityIndex","","","€€€€€€€€€€€€€€€","","",01,"„À","","","","","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","18","ADE_DPSEUL","D",08,00,"Dt.PausaSL","Dt.PausaSL","Dt.PausaSL","DatadaultimapausadoS","DatadaultimapausadoS","DatadaultimapausadoS","","","€€€€€€€€€€€€€€ ","","",01,"","","","S","S","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","19","ADE_QUANT","N",14,03,"Quantidade","Quantidade","Quantity","Quantidade","Quantidade","Quantidade","@E9,999,999,999.999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","19","ADE_HPSEUL","C",05,00,"Hr.PausaSL","Hr.PausaSL","Hr.PausaSL","HrdaultimapausadoSLA","HrdaultimapausadoSLA","HrdaultimapausadoSLA","99:99","","€€€€€€€€€€€€€€ ","","",01,"","","","","","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","20","ADE_TECNIC","C",06,00,"Tecnico","Tecnico","Technician","Tecnico","Tecnico","Technician","","","€€€€€€€€€€€€€€","","",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","20","ADE_DPSE1S","D",08,00,"Dt.PseSLA","Dt.PseSLA","Dt.PseSLA","Datadaprimeirapausano","Datadaprimeirapausano","Datadaprimeirapausano","","","€€€€€€€€€€€€€€ ","","",01,"","","","S","S","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","21","ADE_NMTEC","C",30,00,"NomeTecnico","NombreTecni","Tech.Name","NomeTecnico","NombreTecnico","Tech.Name","","","€€€€€€€€€€€€€€","IF(!INCLUI,POSICIONE('AA1',1,XFILIAL('AA1')+M->ADE_TECNIC,'AA1_NOMTEC'),IF(!EMPTY(M->ADE_TECNIC),AA1->AA1_NOMTEC,''))","",01,"„À","","","","","V","V","","","","","","","","POSICIONE('AA1',1,XFILIAL('AA1')+ADE->ADE_TECNIC,'AA1_NOMTEC')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","21","ADE_HPSE1S","C",05,00,"Hr.PseSLA","Hr.PseSLA","Hr.PseSLA","Horadaprimeirapausano","Horadaprimeirapausano","Horadaprimeirapausano","99:99","","€€€€€€€€€€€€€€ ","","",01,"","","","","","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","22","ADE_TIPO","C",06,00,"Comunicacao","Comunicacion","Communicat.","TipodeComunicacao","TipodeComunicacion","TypeofCommunic.","","IIF(INCLUI.AND.!Empty(M->ADE_TIPO),ExistCpo('SUL',M->ADE_TIPO,1),.T.)","€€€€€€€€€€€€€€","","SUL",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","22","ADE_DATUSL","D",08,00,"Dt.AtuSLA","Dt.AtuSLA","Dt.AtuSLA","DatadeAtualizaçãodoSL","DatadeAtualizaçãodoSL","DatadeAtualizaçãodoSL","99/99/99","","€€€€€€€€€€€€€€ ","","",01,"","","","","","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","23","ADE_CODSB1","C",15,00,"Produto","Producto","Product","Produto","Producto","Product","@!","Tk510JValid(2)","€€€€€€€€€€€€€€ ","","TMK007",01,"şA","","S","","S","A","R","","","","","","","U_WhenGrupos()","","030","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","23","ADE_HATUSL","C",05,00,"Hr.AtuSLA","Hr.AtuSLA","Hr.AtuSLA","HoradeAtualizaçãodoSL","HoradeAtualizaçãodoSL","HoradeAtualizaçãodoSL","99:99","","€€€€€€€€€€€€€€ ","","",01,"","","","","","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","24","ADE_NMPROD","C",30,00,"NomeProduto","NombreProd.","Prod.Name","NomeProduto","NombreProducto","ProductName","","","€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SB1',1,XFILIAL('SB1')+ADE->ADE_CODSB1,'B1_DESC'),'')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SB1',1,XFILIAL('SB1')+ADE->ADE_CODSB1,'B1_DESC')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","24","ADE_DENCSL","D",08,00,"Dt.EncSLA","Dt.EncSLA","Dt.EncSLA","DatadeEncerramentodoS","DatadeEncerramentodoS","DatadeEncerramentodoS","99/99/99","","€€€€€€€€€€€€€€ ","","",01,"","","","","","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","25","ADE_NMTIPO","C",30,00,"Descricao","Descripc.","Description","DescricaodaComunicacao","DescripcionComunicacion","Communic.Description","","","€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SUL',1,XFILIAL('SUL')+ADE->ADE_TIPO,'UL_DESC'),'')","",01,"„À","","","","","V","V","","","","","","","","POSICIONE('SUL',1,XFILIAL('SUL')+ADE->ADE_TIPO,'UL_DESC')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","25","ADE_HENCSL","C",05,00,"Hr.EncSLA","Hr.EncSLA","Hr.EncSLA","HoradeEncerramentodoS","HoradeEncerramentodoS","HoradeEncerramentodoS","99:99","","€€€€€€€€€€€€€€ ","","",01,"","","","","","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","26","ADE_MIDIA","C",06,00,"CodMidia","CodMedia","MediaCode","CodigodaMidia","CodigodelaMedia","MediaCode","","ExistCpo('SUH')","€€€€€€€€€€€€€€€","","SUH",01,"„À","","S","","","A","R","","","","","","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","26","ADE_DENCCH","D",08,00,"Dt.EncCh","Dt.EncCh","Dt.EncCh","DatadeEncerramentodoC","DatadeEncerramentodoC","DatadeEncerramentodoC","99/99/99","","€€€€€€€€€€€€€€ ","","",01,"","","","","","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","27","ADE_NMMIDI","C",30,00,"NomeMidia","NombreMedia","MediaName","NomedaMidia","NombredelaMedia","MediaName","","","€€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SUH',1,XFILIAL('SUH')+M->ADE_MIDIA,'UH_DESC'),'')","",01,"„À","","","","","V","V","","","","","","","","POSICIONE('SUH',1,XFILIAL('SUH')+ADE->ADE_MIDIA,'UH_DESC')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","27","ADE_HENCCH","C",05,00,"Hr.EncCh","Hr.EncCh","Hr.EncCh","HoradeEncerramentodoC","HoradeEncerramentodoC","HoradeEncerramentodoC","99:99","","€€€€€€€€€€€€€€ ","","",01,"","","","","","V","","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","28","ADE_OPERAD","C",06,00,"Analista","Analista","Analyst","Analista","Analista","Analyst","","","€€€€€€€€€€€€€€","TK510OPERA()","",01,"„À","","S","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","29","ADE_NMOPER","C",30,00,"NomeAnalist","NombreAnali","AnalystNm","NomedoAnalista","NombredelAnalista","AnalystName","","","€€€€€€€€€€€€€€","IF(!INCLUI,POSICIONE('SU7',1,XFILIAL('SU7')+M->ADE_OPERAD,'U7_NOME'),IF(!EMPTY(M->ADE_OPERAD),SU7->U7_NOME,''))","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SU7',1,XFILIAL('SU7')+ADE->ADE_OPERAD,'U7_NOME')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","30","ADE_GRUPO","C",02,00,"Equipe","Equipo","Team","Equipe","Equipo","Team","","","€€€€€€€€€€€€€€","IIF(INCLUI,POSICIONE('SU7',1,XFILIAL('SU7')+TKOPERADOR(),'U7_POSTO'),M->ADE_OPERAD)","",01,"„À","","S","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","31","ADE_DESCGP","C",40,00,"NomeEquipe","NombreEquip","TeamName","NomedaEquipe","NombredelEquipo","TeamName","","","€€€€€€€€€€€€€€","POSICIONE('SU0',1,XFILIAL('SU0')+M->ADE_GRUPO,'U0_NOME')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SU0',1,xFilial('SU0')+ADE->ADE_GRUPO,'U0_NOME')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","32","ADE_DESCAS","C",30,00,"DescAssunto","DescAsunto","Subj.Desc.","DescricaodoAssunto","Descripc.delAsunto","SubjectDescrip.","","","€€€€€€€€€€€€€€","IIF(!INCLUI,POSICIONE('SX5',1,XFILIAL('SX5')+'T1'+ADE->ADE_ASSUNT,'X5DESCRI()'),'')","",01,"„À","","","","S","V","V","","","","","","","","POSICIONE('SX5',1,xFilial('SX5')+'T1'+ADE->ADE_ASSUNT,'X5DESCRI()')","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","33","ADE_SEVCOD","C",01,00,"Criticidade","Criticidad","Severity","CriticidadedoProblema","CriticidaddelProblema","ProblemSeverity","","Pertence('12345')","€€€€€€€€€€€€€€","","",01,"‡À","","","","S","A","R","","","5=Crítica;4=Alta;3=Média;2=Baixa;1=Alteraçãodeespecificação","5=Critica;4=Alta;3=Media;2=Baja;1=Modific.deespecificacion","5=Severe;4=High;3=Medium;2=Low;1=Changeofspecification","","U_WhenGrupos()","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","34","ADE_CHANEX","C",06,00,"CHAssociado","CHAsociado","CHLinked","CHAssociado","CHAsociado","CHLinked","","","€€€€€€€€€€€€€€","","",01,"„À","","","","S","V","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","35","ADE_TO","C",200,00,"Destinatario","Destinatario","Destinatario","DestinatariodoEmail","DestinatariodoEmail","DestinatariodoEmail","","U_Valida_email()","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","36","ADE_CC","C",200,00,"Dest.Copiado","Dest.Copiado","Dest.Copiado","Dest.Copiadonoemail","Dest.Copiadonoemail","Dest.Copiadonoemail","","U_Valida_email()","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","37","ADE_ASSUNT","C",06,00,"Assunto","Asunto","Subject","Assunto","Asunto","Subject","","Tk510ValAss().AND.Tk510JVT1()","€€€€€€€€€€€€€€","","TMK003",01,"‡À","","S","","","A","R","","","","","","","","","","1","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADE","38","ADE_CCO","C",200,00,"Dest.Oculto","Dest.Oculto","Dest.Oculto","Dest.Ocultonoemail","Dest.Ocultonoemail","Dest.Ocultonoemail","","U_Valida_email()","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
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
AADD(aRegs,{"ADE","A1","ADE_FOLLOW","D",08,00,"FollowUp","FollowUp","FollowUp","DataparaFollowUp","DataparaFollowUp","DataparaFollowUp","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","S","N","A","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","A1","ADE_DATUSO","D",08,00,"DataAtend.","DataAtend.","DataAtend.","DatausoAtendimento","DatausoAtendimento","DatausoAtendimento","99/99/99","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","S","N","V","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","A1","ADE_WFASTA","C",01,00,"StatusWFA.","StatusWFA.","StatusWFA.","StatusWFAutorizacao","StatusWFAutorizacao","StatusWFAutorizacao","","Vazio().OR.Pertence('12345')","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","","N","V","R","","","1=Semworkflowdeautorizacao;2=Aprovado/Reprovado;3=Aprovado;4=Reprovado;5=Aguardandoresposta","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","A2","ADE_NOMEAC","C",30,00,"NomeAC","NomeAC","NomeAC","NomeAC","NomeAC","NomeAC","","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A3","ADE_XAC","C",50,00,"Ac","Ac","Ac","Ac","Ac","Ac","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A4","ADE_XAR","C",50,00,"Ar","Ar","Ar","Ar","Ar","Ar","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A5","ADE_TELPTO","C",10,00,"TeldoPosto","TeldoPosto","TeldoPosto","TelefonedoPosto","TelefonedoPosto","TelefonedoPosto","@R99-9999-9999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A5","ADE_MAILPT","C",40,00,"MailCtoPos","MailCtoPos","MailCtoPos","EmaildecontatodoPosto","EmaildecontatodoPosto","EmaildecontatodoPosto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A6","ADE_XDEMIS","D",08,00,"DataEmissao","DataEmissao","DataEmissao","DataEmissao","DataEmissao","DataEmissao","@D","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A7","ADE_ORGUNI","C",02,00,"Org.Unit","Org.Unit","Org.Unit","Org.Unit","Org.Unit","Org.Unit","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A8","ADE_XHEMIS","C",08,00,"HrEmissao","HrEmissao","HrEmissao","HrEmissao","HrEmissao","HrEmissao","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A8","ADE_CODREG","C",06,00,"CodigoRegra","CodigoRegra","CodigoRegra","CodigoRegra","CodigoRegra","CodigoRegra","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","A9","ADE_COMNAM","C",60,00,"CommonName","CommonName","CommonName","CommonName","CommonName","CommonName","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","AA","ADE_SLAANT","C",06,00,"Reg.SLA.Ant.","Reg.SLA.Ant.","Reg.SLA.Ant.","RegistroanteriordoSLA","RegistroanteriordoSLA","RegistroanteriordoSLA","","","€€€€€€€€€€€€€€€","","",00,"€€","","","S","N","V","R","","","","","","","","","","1","","","","","","","","N","N","N"})
AADD(aRegs,{"ADE","AB","ADE_SESLA","C",03,00,"Severid.SLA","Severid.SLA","Severid.SLA","SeveridadedoSLA","SeveridadedoSLA","SeveridadedoSLA","","","€€€€€€€€€€€€€€ ","","",00,"","","","S","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B1","ADE_REGRA","M",80,00,"Regra","Regra","Regra","RegradacaixadeEntrada","RegradacaixadeEntrada","RegradacaixadeEntrada","","","€€€€€€€€€€€€€€ ","If(inclui,'',MSMM(ADE->ADE_CODREG,80))","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B4","ADE_XVALID","C",10,00,"Validade","Validade","Validade","ValidadedoCertificado","ValidadedoCertificado","ValidadedoCertificado","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B5","ADE_XDTEXP","D",08,00,"Dt.Expiracao","Dt.Expiracao","Dt.Expiracao","DatadeExpiracao","DatadeExpiracao","DatadeExpiracao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","U_WhenGrupos()","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B6","ADE_CONTA","C",200,00,"Contaemail","Contaemail","Contaemail","Emailpararesposta","Emailpararesposta","Emailpararesposta","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B7","ADE_OBSCOD","C",06,00,"CodigoObs.","CodigoObs.","CodigoObs.","CodigoObservacao","CodigoObservacao","CodigoObservacao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADE","B8","ADE_OBSERV","M",80,00,"Observacao","Observacao","Observacao","Observacao","Observacao","Observacao","","","€€€€€€€€€€€€€€ ","If(inclui,'',MSMM(ADE->ADE_OBSCOD,80))","",00,"şÀ","","","U","N","A","V","","","","","","","","","","1","","","","","N","N","","N","N","N"})

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
AADD(aRegs,{"ADF","01","ADF_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","SucursaldelSistema","SystemBranch","@!","","€€€€€€€€€€€€€€€","","",01,"„À","","","","","A","R","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","02","ADF_CODIGO","C",06,00,"Cod.Chamado","Cod.llamada","Tech.CallCd","CodigodoChamado","CodigodeLlamada","Tech.CallCode","","","€€€€€€€€€€€€€€€","M->ADE_CODIGO","",01,"„À","","","","","V","R","","","","","","","","","","","S","","","S","N","N","","N","N","N"})
AADD(aRegs,{"ADF","03","ADF_ITEM","C",03,00,"Item","Item","Item","Item","Item","Item","","","€€€€€€€€€€€€€€ ","","",01,"‡À","","","","S","V","R","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","04","ADF_CODSU9","C",06,00,"Ocorrencia","Ocurrencia","Occurrence","Ocorrencia","Ocurrencia","Occurrence","","TK510OcoTmk().AND.U_SDK05VLD(M->ADE_PEDGAR,SU9->U9_STTGAR)","€€€€€€€€€€€€€€ ","","OCO",01,"‡À","","S","","S","A","R","","","","","","","","","","","S","","","S","N","N","","N","N","N"})
AADD(aRegs,{"ADF","05","ADF_NMSU9","C",20,00,"Descricao","Descripc.","Description","Descricao","Descripcion","Description","","","€€€€€€€€€€€€€€ ","","",01,"†À","","S","","S","V","V","","","","","","","","POSICIONE('SU9',2,xFilial('SU9')+ADF->ADF_CODSU9,'U9_DESC')","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","06","ADF_CODSUQ","C",06,00,"Acao","Accion","Action","Acao","Accion","Action","","TK510AcaTmk()","€€€€€€€€€€€€€€ ","","SUR",01,"†À","","","","S","A","R","","","","","","","","","","","S","","","S","N","N","","N","N","N"})
AADD(aRegs,{"ADF","07","ADF_NMSUQ","C",20,00,"Descricao","Descripcion","Description","Descricao","Descripcion","Description","","","€€€€€€€€€€€€€€ ","","",01,"†À","","S","","S","V","V","","","","","","","","POSICIONE('SUQ',1,xFilial('SUQ')+ADF->ADF_CODSUQ,'UQ_DESC')","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","08","ADF_CODSU7","C",06,00,"Analista","Analista","Analyst","Analista","Analista","Analyst","","","€€€€€€€€€€€€€€ ","TKOPERADOR()","",01,"„À","","S","","","V","R","","","","","","","","","","","S","","","S","N","N","","N","N","N"})
AADD(aRegs,{"ADF","09","ADF_NMSU7","C",30,00,"NomeAnalist","NombreAnali","AnalystNm.","NomeAnalista","NombreAnalista","AnalystName","","","€€€€€€€€€€€€€€ ","POSICIONE('SU7',1,XFILIAL('SU7')+TKOPERADOR(),'U7_NOME')","",01,"„À","","","","","V","V","","","","","","","","POSICIONE('SU7',1,XFILIAL('SU7')+ADF->ADF_CODSU7,'U7_NOME')","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","10","ADF_CODSU0","C",02,00,"Equipe","Equipo","Team","Equipe","Equipo","Team","","","€€€€€€€€€€€€€€ ","POSICIONE('SU7',1,XFILIAL('SU7')+TKOPERADOR(),'U7_POSTO')","",01,"„À","","S","","","V","R","","","","","","","","","","","S","","","S","N","N","","N","N","N"})
AADD(aRegs,{"ADF","11","ADF_NMGRUP","C",40,00,"NomeEquipe","NombreEquip","TeamName","NomedaEquipe","NombredeEquipo","TeamName","","","€€€€€€€€€€€€€€ ","POSICIONE('SU0',1,XFILIAL('SU0')+POSICIONE('SU7',1,XFILIAL('SU7')+TKOPERADOR(),'U7_POSTO'),'U0_NOME')","",01,"„À","","","","","V","V","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","12","ADF_OBS","M",80,00,"Observacao","Observacion","Note","Observacao","Observacion","Note","","","€€€€€€€€€€€€€€ ","","",01,"„À","","","","S","A","V","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","13","ADF_CODOBS","C",06,00,"Cod.Obs.","Cod.Obs.","NoteCode","CodigodaObservacao","CodigodelaObservacion","NoteCode","","","€€€€€€€€€€€€€€€","","",01,"„À","","","","","V","R","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","14","ADF_DATA","D",08,00,"Data","Fecha","Date","Data","Fecha","Date","@D99/99/99","","€€€€€€€€€€€€€€ ","MsDate()","",01,"„À","","","","","V","R","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","15","ADF_HORA","C",05,00,"Hora","Hora","Time","Hora","Hora","Time","99:99","","€€€€€€€€€€€€€€ ","TIME()","",01,"„À","","","","","V","R","","","","","","","","","","","S","","","N","N","N","","N","N","N"})
AADD(aRegs,{"ADF","15","ADF_HORAF","C",05,00,"HoraFim","HoraFim","HoraFim","Horaqueterminouoitem","Horaqueterminouoitem","Horaqueterminouoitem","","","€€€€€€€€€€€€€€ ","","",00,"","","","S","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"ADF","16","ADF_FNC","C",15,00,"CodigoFNC","CodigoFNC","FNCCode","CodigodafichanoQNC","CodigodefichaenQNC","CardCodeinQNC","@!","","€€€€€€€€€€€€€€ ","","",01,"„À","","","","","V","R","","","","","","","","","","","S","","","S","N","N","","N","N","N"})
AADD(aRegs,{"ADF","17","ADF_FNCREV","C",02,00,"RevisaoFNC","Revis.FNC","FNCRevision","CodigodaRevisaodaFNC","CodigodeRevisionFNC","FNCRevisionCode","@!","","€€€€€€€€€€€€€€ ","","",01,"„À","","","","","V","R","","","","","","","","","","","S","","","S","N","N","","N","N","N"})
AADD(aRegs,{"ADF","18","ADF_CODSKW","C",06,00,"Cod.Workflow","Cod.Workflow","Cod.Workflow","","","","","","€€€€€€€€€€€€€€€","","",00,"€€","","","S","N","V","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"ADF","19","ADF_FILORI","C",02,00,"Fil.Orig","Fil.Orig","Fil.Orig","Filialdeorigemdochama","Filialdeorigemdochama","Filialdeorigemdochama","","","€€€€€€€€€€€€€€€","","",00,"€€","","","S","N","V","R","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"ADF","20","ADF_SKWSTA","C",01,00,"StatusWF","StatusWF","StatusWF","Statusdoworkflow","Statusdoworkflow","Statusdoworkflow","","Vazio().OR.Pertence('123')","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","","N","A","R","","","1=Autorizado;2=Reprovado;3=Aguardandoautorizacao","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"ADF","22","ADF_IDWF","C",08,00,"IDworkflow","IDworkflow","IDworkflow","IDdoprocessoworkflow","IDdoprocessoworkflow","IDdoprocessoworkflow","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

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
AADD(aRegs,{"SZR","01","ZR_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZR","02","ZR_SERVER","C",40,00,"ServerMail","ServerMail","ServerMail","ServidorPop3","ServidorPop3","ServidorPop3","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","03","ZR_CTAMAIL","C",40,00,"Contae-mail","Contae-mail","Contae-mail","Contase-mail","Contase-mail","Contase-mail","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","EXISTCHAV('SZR',M->ZR_CTAMAIL,2)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","04","ZR_PASMAIL","C",40,00,"SenhaConta","SenhaConta","SenhaConta","SenhadaConta","SenhadaConta","SenhadaConta","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","05","ZR_GRPSDK","C",02,00,"Grupo","Grupo","Grupo","Grupo","Grupo","Grupo","","","€€€€€€€€€€€€€€ ","","GRUPO",00,"şÀ","","S","U","S","A","R","€","EXISTCPO('SU0',M->ZR_GRPSDK)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","06","ZR_DSCGRUP","C",30,00,"Desc.Grupo","Desc.Grupo","Desc.Grupo","Desc.Grupo","Desc.Grupo","Desc.Grupo","","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SU0',1,XFILIAL('SU0')+SZR->ZR_GRPSDK,'U0_NOME'),'')","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZR","07","ZR_ASSSDK","C",06,00,"Assunto","Assunto","Assunto","CodigodoAssunto","CodigodoAssunto","CodigodoAssunto","","","€€€€€€€€€€€€€€ ","","SBJNEW",00,"şÀ","","S","U","N","A","R","€","EXISTCPO('SX5','T1'+M->ZR_ASSSDK).OR.EMPTY(M->ZR_ASSSDK)","","","","","","","","","","","","","N","N","","N","N","N"})
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
AADD(aRegs,{"SZR","20","ZR_PASTA","C",20,00,"Correio","Correio","Correio","Correio","Correio","Correio","@!","","€€€€€€€€€€€€€€ ","","PASTA",00,"şÀ","","","U","N","A","R","","EXISTCPO('WF7',M->ZR_PASTA)","","","","","","","","","","","","","N","N","","N","N","N"})

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
±±³Fun‡ao    ³ GeraSIX  ³ Autor ³ OPVS(Warleson)             ³ Data ³   /  /   ³±±
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
AADD(aRegs,{"ADE","O","ADE_FILIAL+ADE_RECORR","Recorrente","Recorrente","Recorrente","","","RECORDD","N"})
AADD(aRegs,{"ADE","P","ADE_FILIAL+ADE_CHORRC+DTOS(ADE_DATA)","Ch.Ori.Rec+DTAbertura","Ch.Ori.Rec+FchApertura","Ch.Ori.Rec+FchApertura","","","CHORCCDATE","N"})

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
AADD(aRegs,{"ADF","1","ADF_FILIAL+ADF_CODIGO+ADF_ITEM","Cod.Chamado+Item","Cod.llamada+Item","Tech.CallCd+Item","S","","","S"})
AADD(aRegs,{"ADF","2","ADF_FILIAL+ADF_CODIGO+ADF_CODSU0+ADF_CODSU7+ADF_CODSU9+ADF_CODSUQ","Cod.Chamado+Equipe+Analista+Ocorrencia+Acao","Cod.llamada+Equipo+Analista+Ocurrencia+Accion","Tech.CallCd+Team+Analyst+Occurrence+Action","S","","","N"})
AADD(aRegs,{"ADF","3","ADF_FILIAL+ADF_DATA+ADF_CODSU7+ADF_CODSU0","Data+Analista+Equipe","Fecha+Analista+Equipo","Date+Analyst+Team","S","","","N"})
AADD(aRegs,{"ADF","4","ADF_FILIAL+ADF_IDWF","IDworkflow","IDworkflow","IDworkflow","U","","ADF4","S"})

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
AADD(aRegs,{"SZR","1","ZR_FILIAL+ZR_GRPSDK","Grupo","Grupo","Grupo","U","","GRUPO","S"})
AADD(aRegs,{"SZR","2","ZR_FILIAL+ZR_CTAMAIL","Contae-mail","Contae-mail","Contae-mail","U","","CTA_EMAIL","S"})

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
AADD(aRegs,{"SZS","1","ZS_FILIAL+ZS_EMAIL+ZS_ORDEM","Email+Ordem","Email+Ordem","Email+Ordem","U","","SZS_01","N"})
AADD(aRegs,{"SZS","2","ZS_FILIAL+ZS_REGRA+ZS_EMAIL","Regra","Regra","Regra","U","","SZS_02","N"})

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
±±³Fun‡ao    ³ GeraSXB  ³ Autor ³ OPVS(Warleson)             ³ Data ³   /  /   ³±±
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
AADD(aRegs,{"PASTA","1","01","DB","CxCorreio","CxCorreio","CxCorreio","WF7",""})
AADD(aRegs,{"PASTA","2","01","01","CxCorreio","CjCorreo","Mailbox","",""})
AADD(aRegs,{"PASTA","4","01","01","CxCorreio","CjCorreo","Mailbox","WF7_PASTA",""})
AADD(aRegs,{"PASTA","4","01","02","Remetente","Remitente","Sender","WF7_REMETE",""})
AADD(aRegs,{"PASTA","4","01","03","Endereco","Direccion","Address","WF7_ENDERE",""})
AADD(aRegs,{"PASTA","5","01","","","","","WF7_PASTA",""})

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
