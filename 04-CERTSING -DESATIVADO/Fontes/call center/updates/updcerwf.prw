#Include 'Protheus.ch'

User Function updcerwf()
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

Processa({|| ProcATU()},"Processando [UPDCERTWF]","Aguarde , processando preparação dos arquivos")

Return()

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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GeraSX3()

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
			DEFINE MSDIALOG oDlg TITLE "Atualizador [GH565656] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
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
AADD(aRegs,{"SC7","E7","C7_XCCSOL","C",09,00,"CCustoSoli","CCustoSoli","CCustoSoli","CentrodeCusto","CentrodeCosto","CostCenter","@!","Vazio().Or.Ctb105CC()","€€€€€€€€€€€€€€ ","","CTT",01,"šÀ","","","U","N","","","","","","","","","","","004","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","E8","C7_XDESCCC","C",40,00,"DescricaoCC","DescricaoCC","DescricaoCC","DescricaoCC","DescricaoCC","DescricaoCC","@!","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F0","C7_XCRESUL","C",09,00,"CentroResul","CentroResul","CentroResul","CentroResul","CentroResul","CentroResul","@!","","€€€€€€€€€€€€€€ ","","CTD",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F1","C7_XDESCRE","C",40,00,"Desc.C.Res","Desc.C.Res","Desc.C.Res","Desc.C.Res","Desc.C.Res","Desc.C.Res","@!","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F2","C7_XRECORR","C",01,00,"Recorrente","Recorrente","Recorrente","Recorrente","Recorrente","Recorrente","@!","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","1=Fixa;2=Recorrente;3=Variavel;4=Pontual","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F3","C7_XREFERE","C",06,00,"Mes/AnoRef","Mes/AnoRef","Mes/AnoRef","Mes/AnoRef","Mes/AnoRef","Mes/AnoRef","999999","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F4","C7_XCLAVAL","C",09,00,"ClasseValor","ClasseValor","ClasseValor","ClasseValor","ClasseValor","ClasseValor","@!","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F5","C7_XDESCLA","C",40,00,"Desc.Clas.","Desc.Clas.","Desc.Clas.","Desc.Clas.","Desc.Clas.","Desc.Clas.","@!","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F6","C7_XJUST","M",10,00,"Justificat.","Justificat.","Justificat.","Justificat.","Justificat.","Justificat.","","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F7","C7_XOBJ","M",10,00,"Objetivo","Objetivo","Objetivo","Objetivo","Objetivo","Objetivo","","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F8","C7_XCONTRA","C",01,00,"Contrato","Contrato","Contrato","Contrato","Contrato","Contrato","","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","1=Vigente;2=NovoContrato;3=SemContratoousobDemanda","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","F9","C7_XADICON","M",10,00,"Inf.Adicona","Inf.Adicona","Inf.Adicona","Inf.Adicona","Inf.Adicona","Inf.Adicona","","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SC7","G0","C7_XVENCTO","D",08,00,"Vencimento","Vencimento","Vencimento","Vencimento","Vencimento","Vencimento","@D","","€€€€€€€€€€€€€€ ","","",01,"šA","","","U","N","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})

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
