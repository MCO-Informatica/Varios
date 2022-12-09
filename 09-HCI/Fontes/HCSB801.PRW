#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ HCSB801  ³ Autor ³ 	Robson Bueno         ³ Data ³ 05.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de consulta de saldos por lote                         ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ HCSB801                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³XXXXXXXXXXXXXX³XX/XX/XX³XXXXXX³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCSB801()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores    := {},aCampos:={}

aCores    := {{	'B8_SALDO==0'	 , 'BR_VERMELHO'},;		// LOTE SEM SALDO
			   {'B8_SALDO>0'	 , 'BR_VERDE'}}      // lOTE COM SALDO
			   			  

PRIVATE aRotina := {{  "Pesquisar","AxPesqui"  ,0,1},;             // Pesquisa  LOTES
				    { "Visualizar","AxVisual",0,2},;        //  Vizualiza LOTES
                    { OemToAnsi("C. Movimentos"),"U_HCSB801C",0,3},;    // Consulta Movimentos de lote
				    { OemToAnsi("Tr. Fornecedor"),"U_HCSB801D",0,4},;    // Consulta Movimentos de lote
				    { "Legenda","U_HCSB801L",0,5} }  
						
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi("Saldos por Lote")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
aCampos := {{"Codigo Produto","B8_PRODUTO"},{"Descricao","B8_DESCRI"},{"H","B8_LOTECTL"},{"Corrida","B8_LOTEFOR"},{"Saldo Inicial","B8_QTDORI"},{"Saldo Atual","B8_SALDO"}}
mBrowse(6,1,22,75,"SB8",aCampos,,,,3,aCores)

Return(.T.)


User Function HCSB801L()

BrwLegenda(cCadastro,"Situacoes",{{"BR_VERDE","Lote COM SALDO em estoque"}, {"BR_VERMELHO","Lote SEM SALDO em estoque"}})

Return (.T.) 



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³HCSB801C  ³ Autor ³ Henry Fila            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de menutencao de precos do lote                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ HCSB801C (ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA390                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User  Function HCSB801C(cAlias,nReg,nOpc)

Local a390Fields := {"B8_LOTECTL",;
					 "B8_PRODUTO",;
					 "B8_LOCAL"  ,;
					 "B8_DTVALID",;
					 "B8_SALDO"  ,;
					 "B8_EMPENHO",;
					 "B8_QTDORI" }
Local aRecno     := {}
Local aObjects   := {},aPosObj  :={}
Local aSize      := MsAdvSize()
Local aInfo      := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

Local oDlg,oQual
Local cSeek
Local cCampo
Local cLoteAntX
Local cChaveSBF

Local nOpca
Local nUsado
Local nInd
Local nTotEmpSDD
Local nTotSaldoSB8
Local nPrcVen    := 0
Local nOrder     := IndexOrd()
Local nSaldoB8   := 0

Local oGet
Local bCompSBF
Local bCompSDC
Local bCompSDC2
Local bComparaSBF

Local lRet       := .T.
Local lRetPE     := .T.
Local lUsaLote   := iif(GetMV("MV_RASTRO")== "S",.T.,.F.)
Local lUnlock    := .F.

If !lUsaLote
	Help(" ", 1,"NAOLOTE")
EndIf

Private aHeader    := {}
Private aCols      := {}

Set Key VK_F12 To 

Pergunte("MTA390",.F.)

While .T.

	// ** Recupera rastreabilidade por lote ou sublote
	If Rastro(SD5->D5_PRODUTO,"S")
		If mv_par01 == 1
			cSeek  := xFilial( "SB8" ) + SD5->D5_PRODUTO + SD5->D5_LOCAL + SD5->D5_LOTECTL + SD5->D5_NUMLOTE
			bBlock := { || B8_FILIAL + B8_PRODUTO + B8_LOCAL + B8_LOTECTL + B8_NUMLOTE == cSeek }
		Else
			cSeek  := xFilial( "SB8" ) + SD5->D5_PRODUTO + SD5->D5_LOTECTL + SD5->D5_NUMLOTE
			bBlock := { || B8_FILIAL + B8_PRODUTO + B8_LOTECTL + B8_NUMLOTE == cSeek }
		EndIf
	ElseIf Rastro(SD5->D5_PRODUTO,"L")
		If mv_par01 == 1
			cSeek  := xFilial( "SB8" ) + SD5->D5_PRODUTO + SD5->D5_LOCAL + SD5->D5_LOTECTL
			bBlock := { || B8_FILIAL + B8_PRODUTO + B8_LOCAL +B8_LOTECTL == cSeek }
		Else
			cSeek  := xFilial( "SB8" ) + SD5->D5_PRODUTO + SD5->D5_LOTECTL
			bBlock := { || B8_FILIAL + B8_PRODUTO + B8_LOTECTL == cSeek }
		EndIf	
	EndIf

	dbSelectArea("SB8")
	If mv_par01 == 1
		dbSetOrder(3)
	Else
		dbSetOrder(5)
	EndIf	
	// ** Carrega aHeader
	If dbSeek(cSeek)
		nPrcVen := SB8->B8_PRCLOT
		dbSelectArea("SX2")
		dbSeek("SB8")
		dbSelectArea("SX3")
		dbSeek("SB8")
		nUsado := 0
		While !EOF() .AND. (X3_ARQUIVO == "SB8")
			If X3USO(X3_USADO) .AND.  ASCAN(a390Fields,TRIM(X3_CAMPO)) > 0
				nUsado++
				AADD(aHeader,{ TRIM(X3Titulo()), X3_CAMPO  , X3_PICTURE,;
					X3_TAMANHO     , X3_DECIMAL, X3_VALID  ,;
					X3_USADO       , X3_TIPO   , X3_ARQUIVO,;
					X3_CONTEXT} )
			EndIf
			dbSkip()
		EndDo
	EndIf

	// ** Carrega aCols e array com lotes a serem reavaliados
	dbSelectArea("SB8")
	If mv_par01 == 1
		dbSetOrder(3)
	Else
		dbSetOrder(5)
	EndIf	
	cLoteAntX  := "&&"
	lLocaliza  := Localiza( B8_PRODUTO )
	While !EOF() .AND. Eval( bBlock )
		AADD(aCols,Array(Len(aHeader)+1))
		For nInd := 1 to Len(aHeader)
			cCampo                  := Alltrim(aHeader[nInd,2])
			aCols[Len(aCols)][nInd] := FieldGet(FieldPos(cCampo))
		Next nInd
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		cLoteAntX := If( Rastro( B8_PRODUTO,"S"), B8_NUMLOTE, B8_LOTECTL )
		Reclock("SB8",.F.)
		AADD(aRecno,Recno())
		nSaldoB8 += SB8SALDO(,,,,,,,,.T.)
		DbSelectArea("SB8")
		dbSkip()
	EndDo
	
	dbSelectArea("SB8")
	If Len(aCols) = 0
		Help( " ", 1, "VAZIO" )
		Exit
	Else
		lUnlock := .T.
	EndIf

	AADD(aObjects,{100,100,.T.,.T.,.F.})
	AADD(aObjects,{100,030,.T.,.F.,.F.})
	aPosObj:=MsObjSize(aInfo,aObjects)

	cCadastro := OemToAnsi("Alteracao de precos") // "Alteracao de precos"
	nOpca := 0
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
	@ 0.5 , 00 TO aPosObj[1,3],aPosObj[1,4] LABEL OemtoAnsi("  Lotes afetados  ") OF oDlg //  "  Lotes afetados  "
	If nSaldoB8 > 0
		@ aPosObj[2,1]+2.8,10 SAY OemtoAnsi("Preco atual")  SIZE 63, 9 OF oDlg PIXEL //Preco atual
		@ aPosObj[2,1]+2,75 MSGET nPrcVen Picture "@E 99,999,999.99" Valid (nPrcVen >= 0) SIZE 60,  9 OF oDlg PIXEL
	Else
		oDlg:nBottom -= 40
	Endif
	oGet := MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],2,"Allwaystrue","Allwaystrue","",.F.,{})

	DEFINE SBUTTON FROM aPosObj[2,1]+2,aPosObj[2,4]-60 TYPE 1 ACTION (nOpca :=2,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM aPosObj[2,1]+2,aPosObj[2,4]-30 TYPE 2 ACTION (nOpca :=1,oDlg:End()) ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg On INIT If(nSaldoB8 = 0, (MsUnlockAll(), Help(" ",1,"M390SSALDO"), oDlg:End()), Nil)
	
	If nSaldoB8 = 0
		dbSelectArea(cAlias)
		dbSetOrder(nOrder)
		dbGoTo(nReg)
		Return(.t.)
	Endif

	If nOpca == 2
		A390PrcAtu(nPrcVen,aRecno)
	Endif
	Exit
EndDo

If lUnLock
	nInd := 1
	While nInd <= Len(aRecno)
		dbSelectArea("SB8")
		dbGoTO(aRecno[nInd])
		MSUnLock()
		nInd++
	EndDo
EndIf

Set Key VK_F12 To MTA390PERG()

dbSelectArea(cAlias)
dbSetOrder(nOrder)
dbGoTo(nReg)
Return (.T.)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT390RT1  ºAutor  ³ROBSON BUENO        º Data ³ 11/01/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³TRATAMENTO PARA ROTINA DE LIQUIDACAO EM MASSA               º±±
±±º          ³Inclui Botoes Socios e Documentos no menu da rotina         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function HCSB801D()
  
Local aAreaAtu	:= GetArea()												// Salva a area atual
Local lRet		:= .T.
Local oDlgL
Local cFornAt:=Space(6)
LOCAL cLojaAt:=Space(2)
Local cFornNv:=Space(6)
Local cLoJaNv:=Space(2)
Local cTitulo :="Deseja Alterar Fornecedor"
cFornAt:=SB8->B8_CLIFOR
cLoJaAt:=SB8->B8_LOJA 
@ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Rotina para Alterar Fornecedor")
@ 003,008 To 85,200 Title OemToAnsi("Alteracao de Fornecedor")
@ 015,015 Say OemToAnsi("Forn Atual:") OF Odlgl PIXEL
@ 015,045 msget cfornAt SIZE 30,10 F3 "SA2" PICTURE PesqPict('SC7','C7_FORNECE') OF Odlgl PIXEL
@ 015,120 msget cLojaAt SIZE 10,10 PICTURE PesqPict('SC7','C7_LOJA') OF Odlgl PIXEL
@ 030,015 Say OemToAnsi("Forn Novo:") OF Odlgl PIXEL
@ 030,045 msget cfornNv SIZE 30,10 F3 "SA2" PICTURE PesqPict('SC7','C7_FORNECE') OF Odlgl PIXEL
@ 030,120 msget cLojaNV SIZE 10,10 PICTURE PesqPict('SC7','C7_LOJA') OF Odlgl PIXEL 
@ 065,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg1,SB8->B8_LOTECTL,cfornNv,cLojaNv)},cTitulo,"Atualizando dados, aguarde...")
@ 065,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)

Activate Dialog Odlg1 CENTER
 

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OKPROC    ºAutor  ³ROBSON BUENO        º Data ³ 11/01/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³executa a Funcao de gravar o fornecedor                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkProc(oDlg1,cRef,cFornNv,cLojaNv)
Local lRet		:= .T.
// verificacao se pode alterar ou nao o fornecedor
// etapa1 (Verificar se ja houve entregas)
// etapa2 (Verificar se Existiu Cotacao de Compras)
dbSelectArea("SB8")
DbSetOrder(6)
MsSeek(xFilial("SB8")+cRef)
do while (!Eof() .And. cRef==SB8->B8_LOTECTL)
    Reclock("SB8",.F.)
    SB8->B8_CLIFOR:=cFornNv 
    SB8->B8_LOJA:=cLojaNv
    MsUnLock()
    dbSkip()
enddo
Close(Odlg1)

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Finaliza  ºAutor  ³ROBSON BUENO        º Data ³ 11/01/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Finalizacao do Objeto                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Finaliza()
 Close(Odlg1)
Return .T.
                 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ROBSON BUENO           º Data ³11/01/2011º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      
Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
EndCase                                                                         
If "MP8" $ oApp:cVersion                                                        
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
  //³Tratamento para tema "Flat"³                                               
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
  If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                          
       	nTam *= 0.90                                                            
  EndIf                                                                         
EndIf                                                                           
Return Int(nTam) 




