#Include "PROTHEUS.CH"
#Include "MSOLE.CH"
#Include "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ HCIR015  ³   Fernando Rodrigo Ribeiro    ³ Data ³31.01.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a integracao do Protheus com o MS Word                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Impressao do Pedido de Vendas                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
O objetivo eh fazer a integracao entre o Protheus e o MS Word.

/*/


User Function HCIR015()

AjustaSX1()
Pergunte("HCI015",.T.)


@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Relatorio - HCIR015 (Integracao com MS-Word)")
@ 08,005 TO 048,190
@ 18,010 SAY OemToAnsi("Esta  rotina  ira  imprimir  os  pedidos  de  vendas  conforme  os ")
@ 32,010 SAY OemToAnsi("parametros  digitados.")

@ 56,130 BMPBUTTON TYPE 1 ACTION WordImp5()
@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIR015   ºAutor  ³Microsiga           º Data ³  04/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function WordImp5()

Local aAreaAnt := GetArea()
Local wcTTotal 	 := 0
Local wcTIPI 		 := 0
Local wcTDesconto  := 0
Local wcTTotcomIPI := 0
Local wcPrecoUnid  := {}
Local wcPrecoTotal := {}
Local wcPrazo	 	 := {}
Local wcQTDE	 	 := {}
Local wcIPI		 	 := {}
Local wcItem		 := {}
Local wcDescricao  := {}
Local wcObs 		 := {}
Local wcProjeto	 := {}
Local wcPV 			 := {}
Local wcCodPedIt   := {}
Local wcItemCli 	 := {}
Local wcCodigo		 := {}
Local aInfUser		 := {}
Local aUser 		 := {}
Local wcMaterialPosto := ""
Local wcRevRealizadas := ""
Local wcEntrega   := ""
Local wcCondPag   := ""
Local wcEmbalagem := ""
Local wcObsPedido := ""
Local cUserGrp 	  := ""
Local wcCCFOP     := ""
Local nK
Local nContador := 0
Local cArqDot  := "HCI\HCIR015.DOT" // Nome do Arquivo MODELO do Word
Local cPathDot := Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD

Private	hWord

// Busca o Departamento
aInfUser := pswret(NIl)
cUserGrp := alltrim(aInfUser[1,12])

Close(oDlg)

// Criando Query
cQuery := "SELECT SC5.C5_NUM, SC5.C5_REVISA, SC5.C5_EMISSAO, SC5.C5_NUMCOT, SC5.C5_CONTATO, SC5.C5_VEND1, SC5.C5_CONDPAG, SC5.C5_OBS, SC5.C5_HIST, SC5.C5_CLIENTE, SC5.R_E_C_N_O_ RECNO, "
cQuery += " SA1.A1_COD, SA1.A1_NOME, SA1.A1_END, SA1.A1_MUN, SA1.A1_CEP, SA1.A1_CGC, SA1.A1_INSCR, SA1.A1_FAX, SA1.A1_EST, SA1.A1_TEL "
cQuery += " FROM "
cQuery += RetSqlName("SC5") + " SC5, " + RetSqlName("SA1") + " SA1 "
cQuery += " WHERE "
cQuery += " SC5.C5_NUM >= '" + MV_PAR01 + "'"
cQuery += " AND C5_NUM <= '" + MV_PAR02 + "'"
cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE "
cQuery += " AND SC5.D_E_L_E_T_ != '*' "
cQuery += " AND SA1.D_E_L_E_T_ != '*' "
cQuery += " ORDER BY C5_NUM"

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery) ,"TRB",.T.,.T.)

// ABRIR TABELAS

// Cabecalho do Orcamento
dbSelectArea("TRB")

While TRB->(!Eof())

	wcTTotal := 0
	wcTIPI := 0
	wcTDesconto := 0

	// ITENS DOS PEDIDOS DE VENDA
	dbSelectArea("SC6")
	// C6_FILIAL +C6_NUM      +C6_ITEM +C6_PRODUTO
	// Filial    +Num. Pedido +Item    +Produto
	dbSetOrder(1)
	If dbSeek(xFilial("SC6") + TRB->C5_NUM, .T.)
		wcCCFOP			:= SC6->C6_CF
	EndIf

	//CABECALHO
	//wcC = Cabecalho
	wcCRazaoSocial := SM0->M0_NOMECOM
	wcCNumPed      := TRB->C5_NUM + " /Rev.  " + TRB->C5_REVISA
	wcCEmissao     := TRB->C5_EMISSAO
	wcCSNumPed     := TRB->C5_NUMCOT
	wcCCliente     := TRB->A1_NOME
	wcCEndereco    := TRB->A1_END
	wcCCidade      := TRB->A1_MUN                                                      
	wcCCEP         := TRB->A1_CEP
	wcCCNPJ        := TRB->A1_CGC
	wcCInscr		  := TRB->A1_INSCR
	wcCFAX		  := TRB->A1_FAX
	wcCEstado	  := TRB->A1_EST
	wcCTelefone	  := TRB->A1_TEL
	wcCContato	  := TRB->C5_CONTATO
	wcCVendedor	  := TRB->C5_VEND1

	//wcRDepartamento := cUserGrp

	nK := 0
    nContador := 0
    wcItem  	:= {}
	wcDescricao := {}
	wcObs 		:= {}
	wcProjeto 	:= {}
	wcPv 		:= {}
	wcItemCli 	:= {}
	wcIPI 		:= {}
	wcQTDE 		:= {}
	wcPrecoUnid := {}
	wcPrecoTotal:= {}
	wcPrazo 	:= {}
	wcCodigo 	:= {}
	wcCodPedIt 	:= {}
	While SC6->C6_NUM == TRB->C5_NUM

		nContador := nContador + 1
		nK := nK + 1

		//COLUNAS
		aAdd(wcItem, SC6->C6_ITEM)
		aAdd(wcDescricao, SC6->C6_DSCTEC)
		aAdd(wcObs, SC6->C6_OBS)
		aAdd(wcProjeto, SC6->C6_PROJETO)
		aAdd(wcPv, SC6->C6_PV)
		aAdd(wcItemCli, SC6->C6_ITEMCLI)
		aAdd(wcIPI, SC6->C6_IPI)
		aAdd(wcQTDE, SC6->C6_QTDVEN)
		aAdd(wcPrecoUnid, SC6->C6_PRCVEN)
		aAdd(wcPrecoTotal, SC6->C6_VALOR )
		aAdd(wcPrazo, SC6->C6_ENTREG )
		aAdd(wcCodigo, SC6->C6_PRODUTO)
		aAdd(wcCodPedIt, "Cod. Cli.: " + SC6->C6_CLI + "   Ped. Cli.:" + SC6->C6_PEDCLI + "   It. Cli.:" + SC6->C6_ITEMCLI  )

		SC6->(DbSkip())

	EndDo
    dbSelectArea("SC5")
    dbGoTo(TRB->RECNO)
	//APOS TABELA
	wcEntrega 	:= ""// "Entrega (a ser definido)"
	wcCondPag 	:= TRB->C5_CONDPAG
	wcMaterialPosto := ""
	wcEmbalagem :=   ""
	wcObsPedido := TRB->C5_OBS
	wcRevRealizadas := SC5->C5_HIST 

	//RODAPE
	wcRodape := Alltrim(SM0->M0_ENDCOB) + " - " + Alltrim(SM0->M0_BAIRCOB) + " "
	If Len(AllTrim(SM0->M0_CEPCOB)) != 0
		wcRodape += " CEP: " + Alltrim(SM0->M0_CEPCOB) + " "
	Endif
	wcRodape += " " + Alltrim(SM0->M0_CIDCOB) + "/" + Alltrim(SM0->M0_ESTCOB) + CHR(13)
	If Len(Alltrim(SM0->M0_TEL)) != 0
		wcRodape += " Telefone: " + Alltrim(SM0->M0_TEL) + " "
	Endif
	If Len(Alltrim(SM0->M0_FAX)) != 0
		wcRodape += " FAX: " + Alltrim(SM0->M0_FAX) + " "
	Endif
	If Len(Alltrim(SM0->M0_CGC)) != 0
		wcRodape += " CGC: " + Alltrim(SM0->M0_CGC) + " "
	Endif
	If Len(Alltrim(SM0->M0_INSC)) != 0
		wcRodape += " Inscr.: " + Alltrim(SM0->M0_INSC)
	Endif

	//Procurando Departamento do Vendedor
	PswOrder(1)
	If PswSeek(SA3->A3_CODUSR)
		aUser := PswRet(1)[1][12]
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criando link de comunicacao com o word ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	hWord := OLE_CreateLink()
	OLE_SetProperty ( hWord, oleWdVisible, .F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seu Documento Criado no Word A extensao do documento tem que ser .DOT ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nPos := RAT("\",cArqDot)

	If nPos > 0
		cArq:= Substr(cArqDot,nPos+1)
	Else
		cArq:= ""
	Endif

	//Local HandleWord
	Private cPathEst:= Alltrim(GetMv("MV_DIREST")) 		// PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO

	MontaDir(cPathEst)

	// Caso encontre arquivo ja gerado na estacao
	// com o mesmo nome apaga primeiramente antes de gerar a nova impressao
	If File( cPathEst + cArq )
		Ferase( cPathEst + cArq )
	EndIf

	CpyS2T(cPathDot,cPathEst,.T.) 	// Copia do Server para o Remote, eh necessario
	// para que o wordview e o proprio word possam preparar o arquivo para impressao e
	// ou visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da
	// estacao , por exemplo C:\WORDTMP

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando novo documento do Word na estacao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_NewFile( hWord, cPathEst + cArq)


	//Conecta ao word
	BeginMsOle()

	//Montagem das variaveis do cabecalho
	OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(nContador))	//variavel para identificar o numero total de
	//linhas na parte variavel
	//Sera utilizado na macro do documento para execucao
	//do for next
	//CABECALHO
	OLE_SetDocumentVar(hWord, 'Prt_CRazaoSocial', wcCRazaoSocial)
	OLE_SetDocumentVar(hWord, 'Prt_CNumPed', wcCNumPed)
	OLE_SetDocumentVar(hWord, 'Prt_CEmissao', wcCEmissao)
	OLE_SetDocumentVar(hWord, 'Prt_CSNumPed', wcCSNumPed)
	OLE_SetDocumentVar(hWord, 'Prt_CCliente', wcCCliente)
	OLE_SetDocumentVar(hWord, 'Prt_CEndereco', wcCEndereco)
	OLE_SetDocumentVar(hWord, 'Prt_CCidade', wcCCidade)
	OLE_SetDocumentVar(hWord, 'Prt_CCEP', wcCCEP)
	OLE_SetDocumentVar(hWord, 'Prt_CCNPJ', wcCCNPJ)
	OLE_SetDocumentVar(hWord, 'Prt_CInscr', wcCInscr)
	OLE_SetDocumentVar(hWord, 'Prt_CCFOP', wcCCFOP)
	OLE_SetDocumentVar(hWord, 'Prt_CFAX', wcCFAX)
	OLE_SetDocumentVar(hWord, 'Prt_CEstado', wcCEstado)
	OLE_SetDocumentVar(hWord, 'Prt_CTelefone', wcCTelefone)
	OLE_SetDocumentVar(hWord, 'Prt_CContato', wcCContato)
	OLE_SetDocumentVar(hWord, 'Prt_CVendedor', wcCVendedor)


	//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
	// prt_cod1, prt_cod2 ... prt_cod10
	for nK := 1 to nContador

		//Colunas
		OLE_SetDocumentVar(hWord, 'Prt_Item'+AllTrim(Str(nK)), wcItem[nK])
		OLE_SetDocumentVar(hWord, 'Prt_Obs'+AllTrim(Str(nK)), wcObs[nK])
		OLE_SetDocumentVar(hWord, 'Prt_Projeto'+AllTrim(Str(nK)), wcProjeto[nK])
		OLE_SetDocumentVar(hWord, 'Prt_PV'+AllTrim(Str(nK)), wcPV[nK])
		OLE_SetDocumentVar(hWord, 'Prt_ItemCli'+AllTrim(Str(nK)), wcItemCli[nK])
		OLE_SetDocumentVar(hWord, 'Prt_Descricao'+AllTrim(Str(nK)), wcDescricao[nK])
		OLE_SetDocumentVar(hWord, 'Prt_IPI'+AllTrim(Str(nK)), wcIPI[nK])
		OLE_SetDocumentVar(hWord, 'Prt_QTDE'+AllTrim(Str(nK)), wcQTDE[nK])
		OLE_SetDocumentVar(hWord, 'Prt_PrecoUnid'+AllTrim(Str(nK)), Alltrim(Transform(wcPrecoUnid[nK],"@E 999,999,999.99")))
		OLE_SetDocumentVar(hWord, 'Prt_PrecoTotal'+AllTrim(Str(nK)), Alltrim(Transform(wcPrecoTotal[nK],"@E 999,999,999.99")))
		OLE_SetDocumentVar(hWord, 'Prt_Prazo'+AllTrim(Str(nK)), wcPrazo[nK])
		OLE_SetDocumentVar(hWord, 'Prt_Codigo'+AllTrim(Str(nK)), wcCodigo[nK])
		OLE_SetDocumentVar(hWord, 'Prt_CodPedIt'+AllTrim(Str(nK)), wcCodPedIt[nK])

		wcTTotal := wcTTotal + wcPrecoTotal[nK]
		wcTIPI := wcTIPI + wcIPI[nK]
		wcTDesconto := wcTDesconto + SC6->C6_VALDESC

	next

	wcTTotcomIPI := (wcTTotal + wcTIPI) - wcTDesconto
	OLE_ExecuteMacro(hWord,"tabitens")
	

	//Rodape
	OLE_SetDocumentVar(hWord, 'Prt_Rodape', wcRodape)

	//Apos Tabela

	OLE_SetDocumentVar(hWord, 'Prt_TTotal', Alltrim(Transform(wcTTotal,"@E 999,999,999.99")))
	OLE_SetDocumentVar(hWord, 'Prt_TIPI', Alltrim(Transform(wcTIPI,"@E 999,999,999.99")))
	OLE_SetDocumentVar(hWord, 'Prt_TDesconto', Alltrim(Transform(wcTDesconto,"@E 999,999,999.99")))
	OLE_SetDocumentVar(hWord, 'Prt_TTotcomIPI', Alltrim(Transform(wcTTotcomIPI,"@E 999,999,999.99")))
	OLE_SetDocumentVar(hWord, 'Prt_Entrega', wcEntrega)
	OLE_SetDocumentVar(hWord, 'Prt_CondPag', wcCondPag)
	OLE_SetDocumentVar(hWord, 'Prt_MaterialPosto', wcMaterialPosto)
	OLE_SetDocumentVar(hWord, 'Prt_Embalagem', wcEmbalagem)
	OLE_SetDocumentVar(hWord, 'Prt_ObsPedido', wcObsPedido)
	OLE_SetDocumentVar(hWord, 'Prt_RevRealizadas', wcRevRealizadas)
	OLE_UpdateFields(hWord)
	EndMsOle()
	TRB->(DBSKIP())

Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando as variaveis do documento do Word                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//OLE_UpdateFields(hWord)
OLE_SetProperty( hWord, oleWdVisible, .T. )
OLE_SetProperty( hWord, oleWdWindowState, "MAX" )

//If MsgYesNo("Imprime o Documento ?")
//	Ole_PrintFile(hWord,"ALL",,,1)
//	OLE_CloseFile( hWord )
//	OLE_CloseLink( hWord )
//EndIf

MsgInfo("Fechar Link do Documento!")
OLE_CloseFile( hWord )
OLE_CloseLink( hWord )

TRB->(dbCloseArea())
SC6->(dbCloseArea())

RestArea(aAreaAnt)

Return()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³   Fernando Rodrigo Ribeiro    ³ Data ³31.01.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajusta as perguntas do SX1                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function AjustaSX1()

Local aAreaAnt := GetArea()

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

aHelpPor:={}
Aadd(aHelpPor,"Informe:")
Aadd(aHelpPor,"- O Pedido de Venda Inicial e Final.")
Aadd(aHelpPor,"- O Cliente Inicial e Final.")
aHelpEng := {""}
aHelpSpa := {""}

//---------------------------------------MV_PAR01--------------------------------------------------
PutSX1("HCI015","01","Ped. Venda Inicial: ","","","mv_ch1","C",06,0,0,"G","ExistCpo('SC5')","SC5","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
PutSX1("HCI015","02","Ped. Venda Final:   ","","","mv_ch2","C",06,0,0,"G","NaoVazio(mv_par02) .Or. ExistCpo('SC5')","SC5","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------
PutSX1("HCI015","03","Cliente Inicial: ","","","mv_ch3","C",06,0,0,"G","ExistCpo('SA1')","SA1","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------
PutSX1("HCI015","04","Cliente Final:   ","","","mv_ch4","C",06,0,0,"G","NaoVazio(mv_par04) .Or. ExistCpo('SA1')","SA1","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


RestArea(aAreaAnt)

Return
