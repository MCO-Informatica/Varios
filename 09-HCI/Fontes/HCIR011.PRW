#Include "PROTHEUS.CH"
#Include "MSOLE.CH"
#Include "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ HCIR011  ³   Fernando Rodrigo Ribeiro    ³ Data ³24.01.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a integracao do Protheus com o MS Word                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Proposta Tecnica                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
O objetivo eh fazer a integracao entre o Protheus e o MS Word.

/*/
        

User Function HCIR011()

AjustaSX1()
Pergunte("HCI011",.T.)


@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Relatorio - HCIR011 (Integracao com MS-Word)")
@ 08,005 TO 048,190
@ 18,010 SAY OemToAnsi("Esta rotina ira imprimir os orcamentos conforme os parametros digitados.")

@ 56,130 BMPBUTTON TYPE 1 ACTION WordImp1()
@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIR011   ºAutor  ³Microsiga           º Data ³  04/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function WordImp1()

Local wcSValorTotal  := 0
Local wcSPesoTotal   := 0
Local nContador 		:= 0
Local wcItem 	 		:= {}
Local wcQtd 			:= {}
Local wcCodCliente 	:= {}
Local wcItemCliente 	:= {}
Local wcDescricao 	:= {}
Local wcDescTecnica 	:= {}
Local wcDesvios 		:= {}
Local wcClassificacao := {}
Local wcPesoUnitario := {}
Local wcPesoTotal 	:= {}
Local wcPrazoDias 	:= {}
Local aUser 			:= {}
Local aInfUser 		:= {}
Local wcDRazaoSocial := ""
Local wcDivisao 	 := ""
Local wcVNome 		 := ""
Local wcVDepto 	:= ""
Local wcVEmpresa  := ""
Local wcVTelefone := ""
Local wcVFax 	:= ""
Local wcVEmail 	:= ""
Local cUserGrp 	:= ""
Local wcDataEmissao := Date()
Local dtEmissao 	  := Date()
Local nK
Local aAreaAnt := GetArea()

Local cArqDot  := "HCI\HCIR011.DOT" // Nome do Arquivo MODELO do Word
Local cPathDot := Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD

Private	hWord

// Busca o Departamento 
aInfUser := pswret(NIl)
cUserGrp := alltrim(aInfUser[1,12])

Close(oDlg)

// Criando Query 
cQuery := " SELECT CJ_STATUS, CJ_VEND, CJ_DPTO, CJ_CONTATO, CJ_NUMCOT, CJ_NUM, CJ_CONDPAG, CJ_VALIDA, CJ_TPFRETE, "
cQuery += " CJ_OBS, CJ_DIVISAO, CJ_EMISSAO, CJ_CLIENTE, CJ_LOJA"
cQuery += " FROM "
cQuery += RetSqlName("SCJ") + " "
cQuery += " WHERE " 
cQuery += " CJ_NUM >= '" + MV_PAR01 + "'"
cQuery += " AND CJ_NUM <= '" + MV_PAR02 + "'" 
cQuery += " AND CJ_STATUS <> 'E' "
cQuery += " AND D_E_L_E_T_ != '*' "
cQuery += " ORDER BY CJ_NUM"

//cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery) ,"TRB",.T.,.T.)

// ABRIR TABELAS 

// Cabecalho do Orcamento
dbSelectArea("TRB")

While TRB->(!Eof())

	//CABECALHO
	//wcR... = wcRemetente    //wcD... = wcDestinatario
	wcRRazaoSocial := SM0->M0_NOMECOM
	wcRVendedor := TRB->CJ_VEND
	wcRDepartamento := cUserGrp
   // Convertendo TRB->CJ_EMISSAO para data no formato DD/MM/AAAA
	wcDataEmissao := Substr(TRB->CJ_EMISSAO,7,2) + "/" + Substr(TRB->CJ_EMISSAO,5,2) + "/" + Substr(TRB->CJ_EMISSAO,1,4)	
	
	dbSelectArea("SA1")
	dbSetOrder(1)	
	If dbSeek(xFilial("SA1") + TRB->CJ_CLIENTE + TRB->CJ_LOJA, .T.)
       wcDRazaoSocial := SA1->A1_NOME
	Endif
	
	// Relacao de Contatos X Entidade
	//dbSelectArea("AC8")
	//dbSetOrder(1)
	//If dbSeek(xFilial() + TRB->CJ_CONTATO, .T.)
	//	wcDRazaoSocial := AC8->AC8_CONTAT //TRB->CJ_CONTATO
	//Endif
	
	wcDDepartamento := TRB->CJ_DPTO
	wcDContato := TRB->CJ_CONTATO
	wcDSuaReferencia := TRB->CJ_NUMCOT
	wcDNossaReferencia := 'Proposta Tecnica ' + TRB->CJ_NUM

	// Cadastro de Vendedores
	dbSelectArea("SA3")
	dbSetOrder(1)
	// Filial    + Codigo
	// A3_FILIAL +A3_COD 
	If dbSeek(xFilial("SA3") + TRB->CJ_VEND, .T.)
		wcVNome := SA3->A3_NOME
	   //Procurando Departamento do Vendedor
		PswOrder(1)
	   If PswSeek(SA3->A3_CODUSR)
	   	aUser := PswRet(1)[1][12]
	   EndIf
		wcVDepto := aUser		
		wcVEmail := SA3->A3_EMAIL		
	Endif	

	wcDescricao    := {}
	wcClassificacao := {}
	wcPesoUnitario := {}
    wcPesoTotal := {}
    wcItem := {}
	wcQtd := {}
	wcCodCliente := {}
	wcItemCliente := {}
	wcDescTecnica := {}
	wcDesvios := {}
	wcPrazoDias := {}

	// Itens do Orcamento
	dbSelectArea("SCK")
	dbSetOrder(1)	
	// Filial    +Num. Pedido +Item    +Produto
	// CK_FILIAL +CK_NUM      +CK_ITEM +CK_PRODUTO
	dbSeek(xFilial("SCK") + TRB->CJ_NUM ,.T.)

	nK := 0              
	nContador := 0
	
	While SCK->CK_NUM == TRB->CJ_NUM 
		//COLUNAS	   
	   nContador := nContador + 1

		// Descricao Generica do Produto
		dbSelectArea("SB1")
		dbSetOrder(1)
		// Filial    +Codigo
		// B1_FILIAL +B1_COD
		If dbSeek(xFilial("SB1") + SCK->CK_PRODUTO, .T.)
			aAdd(wcDescricao, SB1->B1_DESC) 
			aAdd(wcClassificacao, SB1->B1_POSIPI)
			aAdd(wcPesoUnitario, SB1->B1_PESO) 
			aAdd(wcPesoTotal, SB1->B1_PESO * SCK->CK_QTDVEN)
		Endif		
		aAdd(wcItem, SCK->CK_ITEM)
		aAdd(wcQtd, SCK->CK_QTDVEN)
		aAdd(wcCodCliente, SCK->CK_NUMREF)
		aAdd(wcItemCliente, SCK->CK_ITEMCLI)
		aAdd(wcDescTecnica, SCK->CK_DSCTEC)
		aAdd(wcDesvios, SCK->CK_OBS)
		// Convertendo TRB->CJ_EMISSAO para data no formato DD/MM/AAAA
		dtEmissao := Substr(TRB->CJ_EMISSAO,7,2) + "/" + Substr(TRB->CJ_EMISSAO,5,2) + "/" + Substr(TRB->CJ_EMISSAO,1,4)
		aAdd(wcPrazoDias, SCK->CK_ENTREG - CtoD(dtEmissao))
		
		SCK->(DbSkip())
	EndDo
	
	//RODAPE
	wcObservacao := TRB->CJ_OBS
	wcVEmpresa 	 := SM0->M0_NOMECOM
	wcVTelefone  := SM0->M0_TEL
	wcVFax 		 := SM0->M0_FAX
	
	If (TRB->CJ_DIVISAO == '1') // V == Valvulas	
  	  wcDivisao := 'Garantia: Os Produtos ofertados estao garantidos contra defeitos de fabricação no período de 12 meses '
	  wcDivisao += 'de operação ou 18 meses após a entrega, prevalecendo o que primeiro ocorrer.'
	  wcDivisao += 'Pintura: Padrão Fabricante ' + CHR(13)
	  wcDivisao += 'Inspeção e Testes: Em caso de acompanhamento de inspeção e testes nas instalações HCI-Guarulhos-SP '
	  wcDivisao += 'e/ou fabricante, as despesas para realização da mesma ocorrerão por conta do cliente.'
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criando link de comunicacao com o word ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	hWord := OLE_CreateLink()
	OLE_SetProperty ( hWord, oleWdVisible, .T.)
	
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
	OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(nContador+1))	//variavel para identificar o numero total de
																//linhas na parte variavel
																//Sera utilizado na macro do documento para execucao 
																//do for next
	// Adicionado no HCIR011
	//Cabecalho
	OLE_SetDocumentVar(hWord, 'Prt_RRazaoSocial', wcRRazaoSocial)
	OLE_SetDocumentVar(hWord, 'Prt_RVendedor', wcRVendedor)
	OLE_SetDocumentVar(hWord, 'Prt_RDepartamento', wcRDepartamento)
	OLE_SetDocumentVar(hWord, 'Prt_DRazaoSocial', wcDRazaoSocial)
	OLE_SetDocumentVar(hWord, 'Prt_DDepartamento', wcDDepartamento)
	OLE_SetDocumentVar(hWord, 'Prt_DContato', wcDContato )
	OLE_SetDocumentVar(hWord, 'Prt_DSuaReferencia', wcDSuaReferencia)
	OLE_SetDocumentVar(hWord, 'Prt_DNossaReferencia', wcDNossaReferencia)
	OLE_SetDocumentVar(hWord, 'Prt_DataEmissao', wcDataEmissao)		
		
	//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
	// prt_cod1, prt_cod2 ... prt_cod10
	for nK := 1 to nContador
	   //Colunas
	   OLE_SetDocumentVar(hWord, 'Prt_Item'+AllTrim(Str(nK)), wcItem[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_Qtd'+AllTrim(Str(nK)), wcQtd[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_CodCliente'+AllTrim(Str(nK)), wcCodCliente[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_ItemCliente'+AllTrim(Str(nK)), wcItemCliente[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_Descricao'+AllTrim(Str(nK)), wcDescricao[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_DescTecnica'+AllTrim(Str(nK)), wcDescTecnica[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_Desvios'+AllTrim(Str(nK)), wcDesvios[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_Classificacao'+AllTrim(Str(nK)), wcClassificacao[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_PesoUnitario'+AllTrim(Str(nK)), wcPesoUnitario[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_PesoTotal'+AllTrim(Str(nK)), wcPesoTotal[nK])
	   //OLE_SetDocumentVar(hWord, 'Prt_VlrUnitario'+AllTrim(Str(nK)), Alltrim(Transform(wcVlrUnitario[nK],"@E 999,999,999.99")))
	   //OLE_SetDocumentVar(hWord, 'Prt_VlrTotal'+AllTrim(Str(nK)), Alltrim(Transform(wcVlrTotal[nK],"@E 999,999,999.99")))
	   OLE_SetDocumentVar(hWord, 'Prt_PrazoDias'+AllTrim(Str(nK)), wcPrazoDias[nK])
	
	   wcSPesoTotal  := wcSPesoTotal + wcPesoTotal[nK]
	   //wcSValorTotal := wcSValorTotal + wcVlrTotal[nK]	   
	next
	
	// Montar ultima linha da Tabela com os totalizadores
	// INICIO 
	   nK := nContador + 1
	   OLE_SetDocumentVar(hWord, 'Prt_Item'+AllTrim(Str(nK)), "")
	   OLE_SetDocumentVar(hWord, 'Prt_Qtd'+AllTrim(Str(nK)), "")
	   OLE_SetDocumentVar(hWord, 'Prt_CodCliente'+AllTrim(Str(nK)), "")
	   OLE_SetDocumentVar(hWord, 'Prt_ItemCliente'+AllTrim(Str(nK)), "")
	   OLE_SetDocumentVar(hWord, 'Prt_Descricao'+AllTrim(Str(nK)), "")
	   OLE_SetDocumentVar(hWord, 'Prt_DescTecnica'+AllTrim(Str(nK)), "")
	   OLE_SetDocumentVar(hWord, 'Prt_Desvios'+AllTrim(Str(nK)), "")
	   OLE_SetDocumentVar(hWord, 'Prt_Classificacao'+AllTrim(Str(nK)), "")
	   OLE_SetDocumentVar(hWord, 'Prt_PesoUnitario'+AllTrim(Str(nK)), "Peso Total")
	   OLE_SetDocumentVar(hWord, 'Prt_PesoTotal'+AllTrim(Str(nK)), wcSPesoTotal)
	   OLE_SetDocumentVar(hWord, 'Prt_VlrUnitario'+AllTrim(Str(nK)), "Total (R$)" )
	   OLE_SetDocumentVar(hWord, 'Prt_VlrTotal'+AllTrim(Str(nK)), Alltrim(Transform(wcSValorTotal,"@E 999,999,999.99")))
	   OLE_SetDocumentVar(hWord, 'Prt_PrazoDias'+AllTrim(Str(nK)), "")
	// FIM
	
	OLE_ExecuteMacro(hWord,"tabitens")
	
	
	//Rodape
	OLE_SetDocumentVar(hWord, 'Prt_Observacao', wcObservacao)
	
	//Vendedor
	OLE_SetDocumentVar(hWord, 'Prt_VNome', wcVNome)
	OLE_SetDocumentVar(hWord, 'Prt_VDepto', wcVDepto)
	OLE_SetDocumentVar(hWord, 'Prt_VEmpresa', wcVEmpresa)
	OLE_SetDocumentVar(hWord, 'Prt_VTelefone', wcVTelefone)
	OLE_SetDocumentVar(hWord, 'Prt_VFax', wcVFax)
	OLE_SetDocumentVar(hWord, 'Prt_VEmail', wcVEmail)
	OLE_UpdateFields(hWord)
	EndMsOle()
	TRB->(DBSKIP())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando as variaveis do documento do Word                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
SCK->(dbCloseArea())
SB1->(dbCloseArea())
SA3->(dbCloseArea())
SA1->(dbCloseArea())

RestArea(aAreaAnt)

Return()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³   Fernando Rodrigo Ribeiro    ³ Data ³24.01.2007³±±
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

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor:={}
Aadd(aHelpPor,"Informe o Periodo do Orcamento.")		
Aadd(aHelpPor,"Ex.: Orcamento Inicial: 000001")
Aadd(aHelpPor,"     Orcamento Final:   999999")
aHelpEng := {""}
aHelpSpa := {""}

PutSX1("HCI011","01","Orcamento Inicial: ","","","mv_ch1","C",06,0,0,"G","ExistCpo('SCJ')","SCJ","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------

PutSX1("HCI011","02","Orcamento Final:   ","","","mv_ch2","C",06,0,0,"G","NaoVazio(mv_par02) .Or. ExistCpo('SCJ')","SCJ","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aAreaAnt)

Return