#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CCDEDI02  ³ Autor ³Henio Brasil Claudino  ³ Data ³ 20.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Interface de Importacao do cadastro de clientes para toda   ³±±
±±³          ³nova movimentacao                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCDEDI02()

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Definicao das variaveis³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local aTarget  := {}
Local aTemp    := {}
Local aSource  := {}
Local aInco	   := {}

// Inserir a FormBatch
Local ctitulo  := OemToAnsi("Importacao de Base de Clientes ")
Local cDesc1   := OemToAnsi("Este programa ir  importar base de novos clientes ")
Local cDesc2   := OemToAnsi("e as Pedidos de Vendas da CertiSign para o Protheus.")

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Chama a Interface de Clientes     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
ImpCli(@aTemp,@aSource,@aTarget,cTitulo,cDesc1,cDesc2)		// cDirImp

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³IMPCLI    ³ Autor ³Henio Brasil Claudino  ³ Data ³ 21.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inicio do Processamento                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPCLI(aTemp,aSource,aTarget,cTitulo,cDesc1,cDesc2)		// cDirImp

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Definicao das variaveis³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local oDlgInt1
Local i
Local cVersion   := " - Vr 6.4"
Local aTarget    := {}					 // relacao de arquivos no diretorio
Local aTemp      := {}
Local aSource    := {}
Local aIncon     := {}
Local ctitulo    := OemToAnsi("Interface de Clientes"+cVersion)
Local cDesc1     := OemToAnsi("Este programa ir  importar clientes novos")
Local cDesc2     := OemToAnsi("da base de dados BPag da CertiSign para o Protheus.")
Private cPerg	 := "CCPCLI"
Private cDirImp  := Space(30) //"c:\import\cli\new\"       // Clientes novos
Private cDirInc  := Space(30) //"c:\import\cli\pend\"      // Clientes Inconsistentes
Private cDirBac  := Space(30) //"c:\import\cli\procd\"     // Backup de clientes
Private cDirLog  := Space(30) // "c:\Import\Cli\Log\"

ValidPerg("CCPCLI")		// Cria as perguntas
Pergunte("CCPCLI")		// Realiza as Perguntas

// Alimenta as variaveis
cDirImp	:= Alltrim(mv_par01) + Iif(Right(mv_par01,1)!="\","\","") 	//"c:\import\ped\new\"       // Pedidos Novos
cDirInc	:= Alltrim(mv_par02) + Iif(Right(mv_par02,1)!="\","\","")	//"c:\import\ped\pend\"      // Pedidos Inconsistentes
cDirBac := Alltrim(mv_par03) + Iif(Right(mv_par03,1)!="\","\","")	//"c:\import\ped\procd\"     // Backup de Pedidos de Vendas
cDirLog := Alltrim(mv_par04) + Iif(Right(mv_par04,1)!="\","\","") 	//"c:\Import\Ped\Log\"		 // Log da transacao

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Verifica quais arquivos ira listar³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aTemp:= Directory(Alltrim(cDirImp)+"cl*.txt")      // Interface de Clientes

If Empty(aTemp)
	//If aTemp[i,2] <= 0
	MsgStop("Nao existem arquivos de Clientes a serem importados, ou Pasta Invalida!")
	Return
Endif


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Alerta a existencia de Arquivos Inconsistentes³
³Chamada da funcao para startar o JOB          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aIncon:= Directory(Alltrim(cDirInc)+"CL*.txt")
If !Empty(aIncon) 				// .And. !(U_CallFunc("U_BEGINJOB"))
	MsgStop(OemToAnsi("Existem arquivos inconsistentes a serem importados, verifique."),OemToAnsi("Atencao"))
EndIf


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Carrega a lista de arquivos disponiveis³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
For i:= 1 To Len(aTemp)
	If aTemp[i,2] > 0
		AAdd(aSource,aTemp[i,1])
	EndIf
Next i

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Carrega os arquivos a importar e monta a Interface     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
U_ChosFile(@aSource,@aTarget)    			// Origem x Destino
Define MsDialog oDlgInt1 From 140,171 To 304,607 Title cTitulo Pixel Of GetWndDefault()

@ 006,006 To 048,210 Of oDlgInt1 Pixel
@ 019,013 Say cDesc1 Of oDlgInt1 Size 190,10 Pixel
@ 031,013 Say cDesc2 Of oDlgInt1 Size 190,10 Pixel

Define SButton From 060,120 Type 5; 		// Parametros
Action (U_ChosFile(@aSource,@aTarget)) Enable OF oDlgInt1

Define SButton From 060,150 Type 1;         // OK
Action (oDlgInt1:End(),U_StatProc({||Processa(aTarget,cDirImp,cDirBac,cDirInc)},"Importando...")) Enable OF oDlgInt1

Define SButton From 060,180 Type 2;         // Cancelar
Action (oDlgInt1:End()) Enable OF oDlgInt1

Activate MsDialog oDlgInt1 On Move oDlgCon:Move(0.1,0.1,,,.T.) Centered

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³PROCESSA  ³ Autor ³Henio Brasil Claudino  ³ Data ³ 21.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inicio do Processamento                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Processa(aTarget,cDirImp,cDirBac,cDirInc)		// Comm03Proc

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Definicao das variaveis³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local i
Local aAmb			:= GetArea()
Local aAbort		:= {}
Local cNome			:= ""

Local nHandle		:= 0
Local lOk 			:= .t.

Private _cOldFil	:= cFilAnt
Private cArqTxt	:= ''
Private cArqLog	:= ''
Private _lJob		:= (U_CallFunc("U_CALLJOB1"))

If !_lJob                        // aqui vai validar se a funcao foi acionada por JOB.
	U_SetProc(1,Len(aTarget))
EndIf

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Ordena os arquivos ja selecionados	   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If Len(aTarget) == 0
	Return
Endif
ASort(aTarget)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Inicia o Processo³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
For i:= 1 To Len(aTarget)
	cArqTxt	:= AllTrim(aTarget[i])
	cArqLog := Lower(Left(cArqTxt, At(".",cArqTxt)-1))+'.log'         // 6a posicao
	If !_lJob
		U_AddProc(1,"Processando arquivo..."+cArqTxt)
	EndIf
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Cria aquivo de Semaforo para impedir a importacao do³
	³mesmo arquivo por dois usuario ao mesmo tempo       ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	nHandle:= FCreate(Lower(cDirLog+cArqLog))
	If nHandle >= 0					// IF-1
		FWrite(nHandle,"Importacao Clientes em___: "+Dtoc(Date())+" as: "+Time()+" por: "+Subs(cUsuario,7,6)+Chr(13)+Chr(10))
		FWrite(nHandle, "==================================================================================================="+Chr(13)+Chr(10))
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Verifica se o arquivo existe na pasta para iniciar ³
		³a importacao                                       ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If File(cDirImp+cArqTxt)			// IF-2
			// _cTipoArq := Left(cArqTxt,2)
			
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Gera arquivo de trabalho, appendando para DBF ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			If ReadFile(cDirImp,@cNome)			// IF-3
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³Valida arquivo de trabalho³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				// If !ValFile()				// IF-4
				If !ValFile(cNome,cArqTxt,nHandle,cArqLog)			// IF-4
					
					/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³Importa arquivo de trabalho³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					lOk := ImportCli(cNome)
					
					/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³Move o arquivo para area de Backup qdo bem sucedido  ³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					If lOk
						If File(cDirImp+cArqTxt)
							Copy File (cDirImp+cArqTxt) To (cDirBac+cArqTxt)
						EndIf
						FClose(nHandle)
						FErase(cDirLog+cArqLog)			// apaga arquivo de Log
					Else
						If !File(cDirInc+cArqTxt)
							Copy File (cDirImp+cArqTxt) To (cDirInc+cArqTxt)
						EndIf
					Endif
					FErase(cDirImp+cArqTxt)			// apaga apenas o TXT
					
					/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³Finaliza o arquivo de trabalho³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					If Select("TRB") > 0
						TRB->(dbCloseArea())
					EndIf
					FErase(cNome+GetDbExtension())
					FErase(cNome+OrdBagExt())
				Else
					
					/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³Copia o arquivo Txt para a area de Inconformidade³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					cErroTxt := "- Arquivo de Importacao: "+cArqTxt+" - Recusado, todos registros inconsistentes"
					U_MakeTxt(nHandle,cArqLog,cErroTxt)
					If File(cDirImp+cArqTxt)
						/*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Verifica se o arquivo ja existe³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						If !File(cDirInc+cArqTxt)
							Copy File (cDirImp+cArqTxt) To (cDirInc+cArqTxt)
						EndIf
						FErase(cDirImp+cArqTxt)			// apaga apenas o TXT
					EndIf
					
				EndIf			// IF-4
				
			EndIf			// IF-3
			
		EndIf			// IF-2
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Apaga o Semaforo³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		FClose(nHandle)
		// FErase(cDirLog+cArqTxt)
		
	EndIf		// IF-1
	
Next

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Restaura o Ambiente³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAnt+_cOldFil))
cFilAnt	:= _cOldFil
RestArea(aAmb)
Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³READFILE  ³ Autor ³Henio Brasil Claudino  ³ Data ³ 21.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera o arquivo de trabalho conforme a literal do arquivo    ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function READFILE(cDirImp,cNome)			// antiga funcao Comm03Appe

Local aStru:= {}
Local lRet := .f.
If !_lJob
	U_SetProc(2,50,"Criando estrutura de arquivo temporario...")
EndIf

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Cria estrutura temporaria para importar clientes                       ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aStru,{ "RAZAO  "  , "C", 40, 0 } )			// PA5_NOMCLI
Aadd(aStru,{ "ENDERE "  , "C",100, 0 } ) 			// PA5_ENDCLI	New
Aadd(aStru,{ "CIDADE "  , "C", 35, 0 } ) 			// PA5_MUNCLI   New
Aadd(aStru,{ "ESTADO "  , "C", 02, 0 } ) 			// PA5_ESTCLI
Aadd(aStru,{ "BAIRRO "  , "C", 35, 0 } ) 			// PA5_BAICLI   New
Aadd(aStru,{ "CEPCAD "  , "C", 08, 0 } )			// PA5_CEPCLI
Aadd(aStru,{ "TELCLI "  , "C", 15, 0 } )			// PA5_
Aadd(aStru,{ "ENDENT "  , "C",100, 0 } )			// PA5_ENDENT   New
Aadd(aStru,{ "CGCCPF "  , "C", 14, 0 } )			// PA5_DOCCLI
Aadd(aStru,{ "CONTAT "  , "C", 15, 0 } )			// PA5_
Aadd(aStru,{ "INSCRI "  , "C", 18, 0 } )			// PA5_
Aadd(aStru,{ "BAIENT "  , "C", 35, 0 } )			// PA5_BAIENT	New
Aadd(aStru,{ "EMAIL  "  , "C",100, 0 } )			// PA5_
Aadd(aStru,{ "CEPENT "  , "C", 08, 0 } )			// PA5_CEPENT
Aadd(aStru,{ "CIDENT "  , "C", 35, 0 } )			// PA5_MUNENT 	New
Aadd(aStru,{ "ESTENT "  , "C", 02, 0 } )			// PA5_UFENT

//----- Novas Colunas de Insc.Mun e Suframa
Aadd(aStru,{ "INSMUN "  , "C", 18, 0 } )			// PA5_DOCTIT	New
Aadd(aStru,{ "CODSUF "  , "C", 09, 0 } )			// PA5_NOMTIT	New
//----- Colunas de tratamento do Titular
Aadd(aStru,{ "CGCTIT "  , "C", 14, 0 } )			// PA5_DOCTIT	New
Aadd(aStru,{ "RAZTIT "  , "C", 40, 0 } )			// PA5_NOMTIT	New
Aadd(aStru,{ "ENDTIT "  , "C",100, 0 } ) 			// PA5_ENDTIT	New
Aadd(aStru,{ "BAITIT "  , "C", 35, 0 } ) 			// PA5_BAITIT   New
Aadd(aStru,{ "CIDTIT "  , "C", 35, 0 } ) 			// PA5_MUNTIT   New
Aadd(aStru,{ "CEPTIT "  , "C", 08, 0 } )			// PA5_CEPTIT	New
Aadd(aStru,{ "ESTTIT "  , "C", 02, 0 } ) 			// PA5_ESTTIT	New
Aadd(aStru,{ "INSTIT "  , "C", 18, 0 } )			// PA5_INSTIT	New
Aadd(aStru,{ "EMAILT "  , "C",100, 0 } )			// PA5_EMAILT	New
//----- Colunas Tratamento Especifico do fonte
Aadd(aStru,{ "FLAGTIT"  , "N", 01, 0 } )			// Flag p/ Tipo de Titular
Aadd(aStru,{ "CODMUNC"  , "C", 05, 0 } )			// Codigo do Municipio
Aadd(aStru,{ "CODESTC"  , "C", 02, 0 } )			// Codigo Unid. Federacao
Aadd(aStru,{ "CODPAIC"  , "C", 05, 0 } )			// Codigo do Pais

Aadd(aStru,{ "CODMUNT"  , "C", 05, 0 } )			// Codigo do Municipio
Aadd(aStru,{ "CODESTT"  , "C", 02, 0 } )			// Codigo Unid. Federacao
Aadd(aStru,{ "CODPAIT"  , "C", 05, 0 } )			// Codigo do Pais
Aadd(aStru,{ "IMPORTA"  , "L", 01, 0 } )			// PA5_STAIMP - Valida se vai importar ou nao
Aadd(aStru,{ "DATAIMP"  , "D", 08, 0 } )			// PA5_DTIMP  - Data de Importacao


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Cria o arquivo de trabalho e appenda os dados  	³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
cNome := CriaTrab(aStru,.t.)
DbUseArea(.t.,,cNome,"TRB",.t.,.f.)
Append From &(Lower(cDirImp+cArqTxt)) SDF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Limpa os campos de controle   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
DbGoTop()
/// dbEval({|| RecLock("TRB",.f.), TRB->IMPORTA:= .f., TRB->DATAIMP:=Date(), MsUnLock()})
While !eof()
	RecLock("TRB",.f.)
	TRB->CGCCPF		:= CheckCgc(TRB->CGCCPF)
	TRB->CGCTIT		:= CheckCgc(TRB->CGCTIT)
	TRB->FLAGTIT	:= If(Empty(TRB->CGCTIT) .Or. TRB->CGCCPF == TRB->CGCTIT, 1, 2)
	TRB->DATAIMP	:= Date()
	TRB->IMPORTA	:= .f.
	MsUnlock()
	TRB->(DbSkip())
Enddo

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Valida a existencia do arquivo³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
lRet:= iif( !File(cNome+GetDbExtension()),.f., .t.)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VALFILE   ³ Autor ³Henio Brasil Claudino  ³ Data ³ 21.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Realiza a validacao do arquivo                              ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VALFILE(cNome,cArqTxt,nHandle,cArqLog)

Local lFatal	:= .t.			// tratamento se o arquivo passara ileso na validacao
Local lReg		:= .t.
Local lEstBr	:= .t.
Local lBlqCep	:= .f.
Local lExisTit	:= .f.
Local lCepOn	:= GetMv("MV_CCPCEP")
Local cErrCep1	:= cErrCep2	:= cErrCepT := " "
Local nReg		:= 0
Local nRegBad	:= 0
If !_lJob
	U_SetProc(2,TRB->(RecCount()),"Validando arquivo...")
EndIf

// MsgStop(" Concluida geracao arquivo TRB !")

DbSelectArea("TRB")
DbGoTop()
nReg := 0
While TRB->(!Eof())
	
	lReg 		:= .t.
	lBlqCep	    := .f.
	cErrCep1	:= cErrCep2:= " "
	cClient 	:= Left(TRB->RAZAO,20)
	// Esta instrucao NAO esta funcionando
	// Criar tratamento no Endereco nao permitir sujeira
	lEstBr	    := if(TRB->ESTADO=='EX', .f., .t.)
	lExisTit	:= if(!Empty(TRB->CGCTIT) .And. TRB->FLAGTIT==2, .T., .F.)
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Tratamento da pesquisa na Tabela PA7 e busca  os valores esperados ³
	³Verifica se o estado esta dentro da Unid. da Federacao             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If lCepOn .or. lEstBr
		DbSelectArea("PA7")
		DbSetOrder(1)
		If DbSeek(xFilial("PA7")+TRB->CEPCAD, .f. )
			DbSelectArea("TRB")
			RecLock("TRB", .f.)
			TRB->CODMUNC	:= PA7->PA7_CODMUN	    		// OK - SA1
			TRB->CODESTC	:= PA7->PA7_CODUF				//
			TRB->CODPAIC := PA7->PA7_CODPAI  			// OK - SA1
			MsUnlock()
		Else
			lBlqCep	:= .t.
			cErrCep1 := " de Faturamento"			// complementar do LOG
		Endif
		// Apenas pesquisa no PA7, nao grava no TRB
		DbSelectArea("PA7")
		If !DbSeek(xFilial("PA7")+TRB->CEPENT, .f. )
			lBlqCep	:= .t.
			cErrCep2 := " de Entrega"
		Endif
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Gera Log por inconsistencias de CEP.                               ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If lBlqCep
			cErrCepT := iif(!Empty(cErrCep1).and.!Empty(cErrCep2), cErrCep1+" e"+cErrCep2, iif(Empty(cErrCep1), cErrCep2, cErrCep1) )
			cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Dados de Cep"+cErrCepT+" com inconsistencias."
			U_MakeTxt(nHandle,cArqLog,cErroTxt)
			lReg  := .f.
		Endif
		DbSelectArea("TRB")
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Valida se o CNPJ/CPF esta vazio ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If Empty(TRB->CGCCPF)
		cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Dados de Cnpj Vazio"
		U_MakeTxt(nHandle,cArqLog,cErroTxt)
		lReg  := .f.
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Valida o Endereco de Faturamento e Entrega  ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If (Empty(TRB->ENDERE) .Or. Alltrim(TRB->ENDERE)=='N/A') .or. (Empty(TRB->ENDENT) .Or. Alltrim(TRB->ENDENT)=='N/A')
		cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Dados de Endereço Invalido."
		U_MakeTxt(nHandle,cArqLog,cErroTxt)
		lReg  := .f.
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Valida se o CNPJ/CPF e valido   					      	   ³
	³Se retirar esta funcao, precisa retirar a validacao do A1_CGC ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !U_CgcEsp(TRB->CGCCPF)
		cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Cnpj Invalido"
		U_MakeTxt(nHandle,cArqLog,cErroTxt)
		lReg  := .f.
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Valida se a Inscricao Estadual do Cliente  	   			      ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cInscri := if(Alltrim(TRB->INSCRI)=="isento", 'ISENTO', Alltrim(TRB->INSCRI))
	If !IE(cInscri , Upper(TRB->ESTADO),.F.)
		cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Inscricao Estadual Invalida"
		U_MakeTxt(nHandle,cArqLog,cErroTxt)
		lReg  := .f.
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Valida o Estado cadastrado Bpag, ou se e EX ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !SearchEst(Upper(TRB->ESTADO)) .or. !lEstBr
		cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Estado de Faturamento Invalido "
		U_MakeTxt(nHandle,cArqLog,cErroTxt)
		lReg  := .f.
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Valida o Codigo de Municipio, Estado e Pais     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If lCepOn .and. lEstBr
		If Empty(TRB->CODMUNC)
			cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Nao encontrado Dados de Municipio - Tab.CEP"
			U_MakeTxt(nHandle,cArqLog,cErroTxt)
			lReg  := .f.
		Endif
		If Empty(TRB->CODESTC)
			cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Nao encontrado Dados de Estado - Tab.CEP"
			U_MakeTxt(nHandle,cArqLog,cErroTxt)
			lReg  := .f.
		Endif
		If Empty(TRB->CODPAIC)
			cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Nao encontrado Dados de Pais - Tab.CEP"
			U_MakeTxt(nHandle,cArqLog,cErroTxt)
			lReg  := .f.
		Endif
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Tratamento para Cliente Titular                 ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If lExisTit
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Valida se o CNPJ/CPF esta vazio ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If Empty(TRB->CGCTIT)
			cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Titular: "+cClient+" - Dados de Cnpj Vazio"
			U_MakeTxt(nHandle,cArqLog,cErroTxt)
			lReg  := .f.
		Endif
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Valida se o CNPJ/CPF e valido   					      	   ³
		³Se retirar esta funcao, precisa retirar a validacao do A1_CGC ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		If !U_CgcEsp(TRB->CGCTIT)
			cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Titular: "+cClient+" - Cnpj Invalido"
			U_MakeTxt(nHandle,cArqLog,cErroTxt)
			lReg  := .f.
		Endif
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Valida se a Inscricao Estadual do Cliente  	   			   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		cInscri2 := if(Alltrim(TRB->INSTIT)=="isento", 'ISENTO', Alltrim(TRB->INSTIT))
		If !IE(cInscri2, Upper(TRB->ESTTIT),.F.)
			cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Titular: "+cClient+" - Inscricao Estadual Invalida"
			U_MakeTxt(nHandle,cArqLog,cErroTxt)
			lReg  := .f.
		Endif
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Valida o Endereco de Entrega do Titular     ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		If (Empty(TRB->ENDTIT) .Or. Alltrim(TRB->ENDTIT)=='N/A')
			cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Cliente: "+cClient+" - Dados de Endereço do Titular Invalido."
			U_MakeTxt(nHandle,cArqLog,cErroTxt)
			lReg  := .f.
		Endif
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Valida o Estado cadastrado Bpag ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		If !SearchEst(Upper(TRB->ESTTIT))
			cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Titular: "+cClient+" - Estado de Faturamento Invalido "
			U_MakeTxt(nHandle,cArqLog,cErroTxt)
			lReg  := .f.
		Endif
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Tratamento da pesquisa na Tabela PA7 e busca  os valores esperados ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		If lCepOn .and. lEstBr
			DbSelectArea("PA7")
			DbSetOrder(1)
			If DbSeek(xFilial("PA7")+TRB->CEPTIT, .f. )
				DbSelectArea("TRB")
				RecLock("TRB", .f.)
				TRB->CODMUNT	:= PA7->PA7_CODMUN	    		// OK - SA1
				TRB->CODESTT	:= PA7->PA7_CODUF				//
				TRB->CODPAIT := PA7->PA7_CODPAI  			// OK - SA1
				MsUnlock()
			Else
				cErroTxt := "- Arquivo de Importacao: "+cArqTxt+"  Titular: "+cClient+" - Dados de Cep do Titular nao encontrado."
				U_MakeTxt(nHandle,cArqLog,cErroTxt)
				lReg  := .f.
			Endif
			DbSelectArea("TRB")
		Endif
		
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Verifica se o registro sera importado³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	If lReg
		DbSelectArea("TRB")
		RecLock("TRB", .f.)
		TRB->IMPORTA:= .t.
		MsUnlock()
	Else
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Aqui sei que todos Reg estao RUINS    ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		nRegBad := nRegBad+1
	EndIf
	nReg := nReg+1
	If !_lJob
		U_AddProc(2)
	EndIf
	MsUnLock()
	TRB->(dbSkip())
	
Enddo
lFatal := iif(nReg == nRegBad, .t., .f.)
Return lFatal


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³IMPORTCLI ³ Autor ³Henio Brasil Claudino  ³ Data ³ 21.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Realiza a importacao propriamente dito dos clientes, e o    ³±±
±±³          ³processo de gravacao.                                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImportCli(cNome)

Local lExisTit		:= .f.
Local lAlterCli	:= .t.
Local lFirstCli	:= .t.
Local lImport		:= .t.
Local nQtdExeAuto	:= 1
Local cCtaContabil:= '110301001'
Local cCodigo		:= cLoja 	:= cRazao  	:= cNReduz 	:= ''
Local cEndFat		:= cCidFat	:= cEstFat	:= cBaiFat	:= ''
Local cCepFat 		:= cEmail	:= cFone		:= cCgcCpf	:= ''
Local cInscri 		:= cPessoa 	:= cContato	:= cEndEnt	:= ''
Local cCepEnt 		:= cBaiEnt 	:= cCidEnt	:= cEstEnt	:= ''
Local cStatusVen 	:= cCodMun 	:= cCodEst	:= cCodPais	:= ''
Local cInsMun		:= cCodSuf	:= ''
If !_lJob
	U_SetProc(2,TRB->(RecCount()),"Importando arquivo...")
EndIf
dbSelectArea("TRB")
dbGoTop()

While TRB->(!Eof())
	
	lExisTit	:= If(!Empty(TRB->CGCTIT) .And. TRB->FLAGTIT==2, .T., .F.)
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Gera o Log na Tabela PA5             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	DbSelectArea("PA5")				// Ordem 1 - Cnpj / 2 - Razao / 3 - Cep
	DbSetOrder(1)
	lOpcAltera := (DbSeek(xFilial("PA5")+Alltrim(TRB->CGCCPF), .f.))
	If TRB->(!Eof())
		RecLock("PA5", !lOpcAltera)						// Se nao encontrou sera .T.
		PA5->PA5_FILIAL		:= xFilial("PA5")			// PA5->PA5_FILIAL
		PA5->PA5_NOMCLI 		:= Upper(TRB->RAZAO) 		// PA5->PA5_NOMCLI
		PA5->PA5_ENDCLI		:= Upper(TRB->ENDERE)		// PA5->PA5_ENDCLI
		PA5->PA5_MUNCLI 		:= Upper(TRB->CIDADE)		// PA5->PA5_MUNCLI
		PA5->PA5_ESTCLI		:= Upper(TRB->ESTADO)		// PA5->PA5_ESTCLI
		PA5->PA5_BAICLI		:= Upper(TRB->BAIRRO) 		// PA5->PA5_BAICLI
		PA5->PA5_CEPCLI		:= TRB->CEPCAD 				// PA5->PA5_CEPCLI
		PA5->PA5_TELCLI		:= TRB->TELCLI				// PA5->PA5_TELCLI
		PA5->PA5_DOCCLI		:= TRB->CGCCPF				// PA5->PA5_DOCCLI
		PA5->PA5_INSCRI		:= TRB->INSCRI				// PA5->PA5_INSCRI
		PA5->PA5_CONTAT		:= TRB->CONTAT				// PA5->PA5_CONTAT
		PA5->PA5_EMAIL 		:= TRB->EMAIL 				// PA5->PA5_EMAIL
		PA5->PA5_ENDENT		:= Upper(TRB->ENDENT)		// PA5->PA5_ENDENT
		PA5->PA5_BAIENT		:= Upper(TRB->BAIENT) 		// PA5->PA5_BAIENT
		PA5->PA5_CEPENT		:= TRB->CEPENT				// PA5->PA5_CEPENT
		PA5->PA5_MUNENT		:= Upper(TRB->CIDENT)		// PA5->PA5_MUNENT
		PA5->PA5_UFENT			:= Upper(TRB->ESTENT)	// PA5->PA5_UFENT
		PA5->PA5_CODMUN		:= TRB->CODMUNC				// PA5->PA5_CODMUN
		PA5->PA5_CODUF			:= TRB->CODESTC			// PA5->PA5_CODUF
		PA5->PA5_PAIS			:= TRB->CODPAIC			// PA5->PA5_PAIS
		PA5->PA5_CLITIT		:= Iif(lExisTit , '1', '2')	// PA5->PA5_CLITIT
		PA5->PA5_CGCORI		:= TRB->CGCTIT				// PA5->PA5_CGCORI
		PA5->PA5_NOMORI 		:= Upper(TRB->RAZTIT)	// PA5->PA5_NOMORI
		PA5->PA5_STAIMP		:= Iif(TRB->IMPORTA==.t., '1', '2') 		// PA5->PA5_STAIMP
		PA5->PA5_STAMOV		:= Iif(lOpcAltera , 'I', 'A')				// PA5->PA5_STAMOV
		PA5->PA5_DTIMP			:= date()                              	// PA5->PA5_DTIMP
		MsUnLock()
	Endif
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Valida se realizara a importacao do registro³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	DbSelectArea("TRB")
	If !(TRB->IMPORTA)
		TRB->(DbSkip())
		lImport:= .F.
		Loop
	EndIf
	
	nQtdExeAuto:= If(lExisTit, 2, 1)
	For K:=1 to nQtdExeAuto
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Explosao das Variaveis para Cliente Faturamento ou Titular     ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		cRazao  	:= If(lFirstCli , Upper(Alltrim(TRB->RAZAO)) 	, Upper(Alltrim(TRB->RAZTIT))) // Razao Social
		cNReduz 	:= If(lFirstCli , Upper(Alltrim(TRB->RAZAO)) 	, Upper(Alltrim(TRB->RAZTIT))) // Nome Reduzido
		cEndFat	:= If(lFirstCli , Upper(Alltrim(TRB->ENDERE))	, Upper(Alltrim(TRB->ENDTIT))) // Endereco faturamento
		cCidFat	:= If(lFirstCli , Upper(Alltrim(TRB->CIDADE))	, Upper(Alltrim(TRB->CIDTIT))) // Municipio Faturamento
		cEstFat	:= If(lFirstCli , Upper(TRB->ESTADO)		  	, Upper(TRB->ESTTIT)) 			// Estado Faturamento
		cBaiFat	:= If(lFirstCli , Upper(Alltrim(TRB->BAIRRO))	, Upper(Alltrim(TRB->BAITIT))) // Bairro Faturamento
		cCepFat	:= If(lFirstCli , TRB->CEPCAD	 				, TRB->CEPTIT 	) 				// CEP Faturamento
		cEmail		:= If(lFirstCli , TRB->EMAIL 	 				, TRB->EMAILT 	) 				// Conta de E-mail
		cFone		:= If(lFirstCli , TRB->TELCLI 	 				, '' 			) 				// Telefone Faturamento
		cCgcCpf	:= If(lFirstCli , Alltrim(TRB->CGCCPF)			, Alltrim(TRB->CGCTIT)) 		// Cnpj / Cpf
		cInscri 	:= If(lFirstCli , Upper(TRB->INSCRI) 			, Upper(TRB->INSTIT)) 			// Inscricao Estadual
		cContato	:= If(lFirstCli , TRB->CONTAT	 				, '' 			) 				// Contato no cliente
		cEndEnt	:= If(lFirstCli , Upper(Alltrim(TRB->ENDENT)) 	, Upper(Alltrim(TRB->ENDTIT))) // Endereco Entrega
		cCepEnt	:= If(lFirstCli , TRB->CEPENT	 				, TRB->CEPTIT 	) 				// Cep Entrega
		cBaiEnt 	:= If(lFirstCli , Upper(Alltrim(TRB->BAIENT)) 	, Upper(Alltrim(TRB->BAITIT))) // Bairro Entrega
		cCidEnt	:= If(lFirstCli , Upper(TRB->CIDENT)			, Upper(TRB->CIDTIT)) 			// Municipio Entrega
		cEstEnt	:= If(lFirstCli , Upper(TRB->ESTENT) 			, Upper(TRB->ESTTIT)) 			// Estado de Entrega
		cInsMun	:= If(lFirstCli , Upper(TRB->INSMUN) 			, ''        	) 				// Inscricao Municipal
		cCodSuf	:= If(lFirstCli , Upper(TRB->CODSUF) 			, ''        	) 				// Codigo Suframa
		cCodMun 	:= If(lFirstCli , TRB->CODMUNC	 				, TRB->CODMUNT ) 				// Codigo do Municipio
		cCodEst	:= If(lFirstCli , Upper(TRB->CODESTC)			, Upper(TRB->CODESTT)) 			// Codigo do Estado
		cCodPais	:= If(lFirstCli , TRB->CODPAIC	 				, TRB->CODPAIT ) 				// Codigo do Pais
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Posiciona no Cliente para pesquisar a sua existencia           ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		// cCodigo	:= GetSxeNum("SA1")		...Ja esta no dicionario!
		
		DbSelectArea("SA1")
		DbSetOrder(3)
		lAlterCli	:= DbSeek( xFilial("SA1")+ U_CSFMTSA1(cCgcCpf) , .f.)
		cCodigo	:= If(lAlterCli, SA1->A1_COD , "  ")
		cLoja 	:= If(lAlterCli, SA1->A1_LOJA, "01")
		DbSetOrder(1)
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Tratamento do Status do Cliente e Titular        ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		If lFirstCli
			// E' alteracao e o Cliente e' Titular, se for Inclusao sempre sera 1
			cStatusVen:= If(lAlterCli .And. SA1->A1_STATVEN=='2', '3', '1')
			// Cliente Titular
		ElseIf lExisTit
			cStatusVen:= If(lAlterCli .And. SA1->A1_STATVEN=='1', '3', Str(TRB->FLAGTIT,1))
		Endif
		
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Tratamento do tipo de cliente, se Pessoa Fisica ou Juridica    ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		cInscri := If(Empty(cInscri)	,'ISENTO'	, cInscri)
		cEmail  := If(Empty(cEmail)	, '@'		, cEmail)
		cPessoa := If(Len(cCgcCpf)>=14, 'J'	, 'F')
		cInsMun := 'ISENTO'
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Se for Inclusao de Cliente trata Filial + Loja   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		If !lAlterCli
			aMata030	:= {{"A1_FILIAL"	,'' 				, Nil},;	// Filial
			{"A1_LOJA"		,cLoja   			, Nil},; 	// Loja do cliente
			{"A1_NOME"		,cRazao				, Nil},; 	// Nome
			{"A1_NREDUZ"	,cNReduz 			, Nil},; 	// Nome Reduzido
			{"A1_END"		,cEndFat 			, Nil},; 	// Endereco faturamento
			{"A1_MUN"		,cCidFat				, Nil},; 	// Município Faturamento)
			{"A1_EST"		,cEstFat				, Nil},; 	// Estado Faturamento
			{"A1_BAIRRO"	,cBaiFat				, Nil},; 	// Bairro Faturamento
			{"A1_CEP"		,cCepFat				,'.T.'},; 	// CEP Faturamento
			{"A1_EMAIL"	,cEmail  			, Nil},; 	// E-mail
			{"A1_TEL"		,cFone				, Nil},; 	// Telefone Faturamento
			{"A1_CGC"		,cCgcCpf				,'.T.'},; 	// Cnpj / Cpf
			{"A1_INSCR"	,cInscri  			, Nil},; 	// Inscrição Estadual
			{"A1_INSCRM"	,cInsMun  			, Nil},; 	// Inscrição Municipal
			{"A1_SUFRAMA"	,cCodSuf  			, Nil},; 	// Codigo Suframa
			{"A1_PESSOA"	,cPessoa				, Nil},; 	// Física / Jurídica
			{"A1_PFISICA"	,'' 					, Nil},; 	// Rg / Cédula Estrangeiro
			{"A1_CONTA"	,cCtaContabil		, Nil},; 	// Conta Contabil
			{"A1_CONTATO"	,cContato 			, Nil},; 	// Contato no cliente
			{"A1_ENDENT"	,cEndEnt				, Nil},; 	// Endereço Entrega
			{"A1_BAIRROE"	,cBaiEnt				, Nil},; 	// Bairro Entrega
			{"A1_CEPE"		,cCepEnt				,'.T.'},; 	// Cep Entrega
			{"A1_MUNE"		,cCidEnt				, Nil},; 	// Município Entrega
			{"A1_ESTE"		,cEstEnt				, Nil},; 	// Estado de Entrega
			{"A1_TIPO"		,'F'					, Nil},; 	// Tipo do cliente
			{"A1_RISCO"	,'A' 					, Nil},;	// Risco do cliente
			{"A1_STATVEN"	,cStatusVen			, Nil},;	// Status do cliente - Area Vendas
			{"A1_COD_MUN"	,cCodMun				,'.T.'},; 	// Codigo do Municipio
			{"A1_COD_EST"	,cCodEst				,'.T.'},; 	// Codigo do Estado
			{"A1_COD_PAI"	,cCodPais			,'.T.'},; 	// Codigo do Pais
			{"A1_MOEDALC"	,1.0   				, Nil}} 	// Moeda para Titulos do Financeiro
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Se for Alteracao de Cliente trata Filial + Loja  ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			*/
			
		Else
			aMata030	:= {{"A1_FILIAL"	,'' 				, Nil},;	// Filial
			{"A1_COD"		,cCodigo 			, '.T.'},; 	// Loja do cliente
			{"A1_LOJA"		,cLoja   			, Nil},; 	// Loja do cliente
			{"A1_NOME"		,cRazao				, Nil},; 	// Razao Social
			{"A1_NREDUZ"	,cNReduz				, Nil},; 	// Nome Reduzido
			{"A1_END"		,cEndFat				, Nil},; 	// Endereco faturamento
			{"A1_MUN"		,cCidFat				, Nil},; 	// Município Faturamento)
			{"A1_EST"		,cEstFat				, Nil},; 	// Estado Faturamento
			{"A1_BAIRRO"	,cBaiFat				, Nil},; 	// Bairro Faturamento
			{"A1_CEP"		,cCepFat				,'.T.'},; 	// CEP Faturamento
			{"A1_EMAIL"	,cEmail 				, Nil},; 	// E-mail
			{"A1_TEL"		,cFone				, Nil},; 	// Telefone Faturamento
			{"A1_CGC"		,cCgcCpf				,'.T.'},; 	// Cnpj / Cpf
			{"A1_INSCR"	,cInscri 			, Nil},; 	// Inscrição Estadual
			{"A1_INSCRM"	,cInsMun  			, Nil},; 	// Inscrição Municipal
			{"A1_SUFRAMA"	,cCodSuf  			, Nil},; 	// Codigo Suframa
			{"A1_PESSOA"	,cPessoa				, Nil},; 	// Física / Jurídica
			{"A1_PFISICA"	,'' 					, Nil},; 	// Rg / Cédula Estrangeiro
			{"A1_CONTA"	,cCtaContabil		, Nil},; 	// Conta Contabil
			{"A1_CONTATO"	,cContato			, Nil},; 	// Contato no cliente
			{"A1_ENDENT"	,cEndEnt				, Nil},; 	// Endereço Entrega
			{"A1_BAIRROE"	,cBaiEnt				, Nil},; 	// Bairro Entrega
			{"A1_CEPE"		,cCepEnt				,'.T.'},; 	// Cep Entrega
			{"A1_MUNE"		,cCidEnt				, Nil},; 	// Município Entrega
			{"A1_ESTE"		,cEstEnt				, Nil},; 	// Estado de Entrega
			{"A1_TIPO"		,'F'					, Nil},; 	// Tipo do cliente
			{"A1_RISCO"	,'A'					, Nil},;	// Risco do cliente
			{"A1_STATVEN"	,cStatusVen 		, Nil},;	// Status do cliente - Area Vendas
			{"A1_COD_MUN"	,cCodMun				,'.T.'},; 	// Codigo do Municipio
			{"A1_COD_EST"	,cCodEst				,'.T.'},; 	// Codigo do Estado
			{"A1_COD_PAI"	,cCodPais			,'.T.'},; 	// Codigo do Pais
			{"A1_MSBLQL"	,'2' 					, Nil},; 	// Status de Bloqueio
			{"A1_MOEDALC"	,1.0   				, Nil}} 	// Moeda para Titulos do Financeiro
		Endif
		
		lMsErroAuto := lFirstCli := .F.
		If lAlterCli											// Alteracao
			MsExecAuto({|x,y| MATA030(x,y)},aMata030, 4)		// Ver qual a opcao de alteracao
		Else
			MsExecAuto({|x,y| MATA030(x,y)},aMata030, 3)		// Ver qual a opcao de alteracao
		Endif
		If lMsErroAuto
			MostraErro('SYSTEM','ErroImp.log')
		EndIf
		
	Next
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Proximo registro a ser importado            ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	DbSelectArea("TRB")
	lFirstCli := .T.
	TRB->(DbSkip())
	
EndDo
Return(lImport)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CHECKCGC  ³ Autor ³Henio Brasil Claudino  ³ Data ³ 19.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida a formatacao do Cnpj ou Cpf enviados no arquivo Txt  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CheckCGC(cCnpj)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Pesquisa a existencia do Cliente na base                ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cCnpjCpf:= cCnpj

If !Empty(cCnpj)
	// Verifica se e' CPF
	If Len(Alltrim(cCnpj))<11
		cCnpjCpf:= Strzero(Val(cCnpj),11)
		// Se nao for CPF e' CNPJ
	ElseIf Len(Alltrim(cCnpj))>11 .and. Len(Alltrim(cCnpj))<=14
		cCnpjCpf:= Strzero(Val(cCnpj),14)
	EndIf
Endif
Return(cCnpjCpf)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³EXISTCGC  ³ Autor ³Henio Brasil Claudino  ³ Data ³ 21.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pesquisa da existencia do cliente na base                   ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ExistCGC(cCnpj)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Pesquisa a existencia do Cliente na base                ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local lExist := .f.
SA1->(dbSetOrder(3))
If (SA1->(DbSeek(xFilial("SA1")+U_CSFMTSA1(cCnpj) ,.f.)))
	lExist:= .t.
EndIf
SA1->(dbSetOrder(1))
Return lExist


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³SEARCHEST ³ Autor ³Henio Brasil Claudino  ³ Data ³ 09.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pesquisa o Estado do Cliente para Validar se Existe no SX5  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CertiSign Certificadora Digital S/A                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SearchEst(cEst) 			// SearchPa8(cProd,cDescri)

Local aAmb3		:= GetArea()
Local cEstado 	:= '12'+cEst
Local lRetEst 	:= .t.

DbSelectArea("SX5")
DbSetOrder(1)
lRetEst	:= (DbSeek(xFilial("SX5")+cEstado, .f.))

RestArea(aAmb3)
Return(lRetEst)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCDEDI02  ºAutor  ³Eduardo Ramos       º Data ³  07/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ValidPerg(cPerg) - Valida as perguntas                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

//aAdd(aRegs,{cPerg,"01","Codigo natureza    ?","Codigo Natureza    ?","Codigo natureza    ?","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
aAdd(aRegs,{cPerg,"01","Caminho Cli. NEW   ?","Caminho Ped. Novos ?","Caminho Ped. Novos ?","mv_ch2","C",40,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Caminho Cli. PEND  ?","Caminho Ped. Incons?","Caminho Ped. Incons?","mv_ch3","C",40,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Caminho Cli. PROCD ?","Caminho Backup Ped.?","Caminho Backup Ped.?","mv_ch4","C",40,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Caminho LOG        ?","Caminho Log trans. ?","Caminho Log trans. ?","mv_ch5","C",40,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return