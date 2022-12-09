#Include "PROTHEUS.CH"
#Include "MSOLE.CH"
#Include "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ HCIR013  ³   Fernando Rodrigo Ribeiro    ³ Data ³05.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a integracao do Protheus com o MS Word                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Impressao do DataSheet                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
O objetivo eh fazer a integracao entre o Protheus e o MS Word.

/*/
        

User Function HCIR013()

AjustaSX1()
Pergunte("HCI013",.T.)


@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Relatorio - HCIR013 (Integracao com MS-Word)")
@ 08,005 TO 048,190
@ 18,010 SAY OemToAnsi("Esta rotina ira imprimir o DataSheet conforme os parametros digitados.")

@ 56,130 BMPBUTTON TYPE 1 ACTION WordImp3()
@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCIR013   ºAutor  ³Microsiga           º Data ³  04/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function WordImp3()

Local aAreaAnt  := GetArea()
Local wcItem 	    := {}
Local wcQtd 	    := {}
Local aInfUser      := {}
//Local aTeste 	    := {}
Local aInfoProd     := {}
Local wcCodCliente  := {}
Local wcDescTecnica := {}
Local wcCliente 	:= ""
Local wcContato 	:= ""
Local wcEndereco 	:= ""
Local wcCEP 		:= ""
Local wcCidade 	    := ""
Local wcEstado 	    := ""
Local wcDepto 		:= ""
Local wcUsuario 	:= ""
Local wcRodape 	    := ""
Local wcNomeContato   := ""
Local wcSuaReferencia := ""
Local wcNossaReferencia := ""
Local nK

//Campos da SB1
Local wcItemB1 		:= ""
Local	wcCodProd 	 	:=  ""
Local wcQuantidade 	:= ""
Local wcDiamentro 	:= ""
Local wcTipo 			:= ""
Local wcCunha 			:= ""
Local wcHaste 			:= ""
Local wcPadraoConstrucao := ""
Local cUserGrp 	 := ""

Local	wB1_XMATCOP := ""
Local	wB1_XMATTAM := ""
Local	wB1_XMATCUN := ""
Local	wB1_XMATHAS := ""
Local	wB1_XMATJUN := ""
Local	wB1_XMATGAX := ""
Local	wB1_XMATPRI := ""
Local	wB1_XMATPOR := ""
Local	wB1_XEXTREM := ""
Local	wB1_XACBFAC := ""
Local	wB1_XCONSTR := ""
Local	wB1_XDIMENS := ""
Local	wB1_XIDENTI := ""
Local	wB1_XINSPEC := ""
Local	wB1_XTESTE  := ""
Local	wB1_XHASTE  := ""
Local	wB1_XACIONA := ""
Local	wB1_XMATERI := ""
Local	wB1_XDESCOP := ""
Local	wB1_XDESCTA := ""
Local	wB1_XDESCUN := ""
Local	wB1_XDESCHA := ""
Local	wB1_XDESCJU := ""
Local	wB1_XDESGAX := ""
Local	wB1_XDESPRI := ""
Local	wB1_XDESPOR := ""
Local	wB1_XDESEXT := ""
Local	wB1_XDESFAC := ""
Local	wB1_XDESCON := ""
Local	wB1_XDESDIM := ""
Local	wB1_XDESIDE := ""
Local	wB1_XDESINS := ""
Local	wB1_XDESTES := ""
Local	wB1_XDESHAT := ""
Local	wB1_XDESACI := ""
Local	wB1_XDESMAT := ""

Local nContador := 0
Local cArqDot  := "HCI\HCIR013.DOT" // Nome do Arquivo MODELO do Word
Local cPathDot := Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD


Private	hWord

Close(oDlg)

// Apagar as 4 linhas abaixo - somente teste
//dbSelectArea("SBP")
//dbSelectArea("SBQ")
//dbSelectArea("SBS")
//aTeste := u_DesmontCodInt("MIC0302020202  ") // u_DesmontCodInt("CARRO1002      ")

// Criando Query 
cQuery := " SELECT CJ_STATUS, CJ_VEND, CJ_DPTO, CJ_CONTATO, CJ_NUMCOT, CJ_NUM, CJ_CONDPAG, CJ_VALIDA, CJ_TPFRETE, "
cQuery += " CJ_OBS, CJ_DIVISAO, CJ_EMISSAO, CJ_LOJA, CJ_CLIENTE "
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
	//wcRRazaoSocial := SM0->M0_NOMECOM

	// Cadastro de Clientes
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1") + TRB->CJ_CLIENTE + TRB->CJ_LOJA, .T.)
		wcCliente   := SA1->A1_NOME	
		wcEndereco  := SA1->A1_END
		wcCEP 		:= SA1->A1_CEP
		wcCidade 	:= SA1->A1_MUN
		wcEstado 	:= SA1->A1_EST
	EndIf
	
	wcContato := TRB->CJ_CONTATO

	// Relacao de Contatos X Entidade
	dbSelectArea("SU5") //AC8
	dbSetOrder(1)
	If dbSeek(xFilial("SU5") + TRB->CJ_CONTATO, .T.)
		wcNomeContato := SU5->U5_CONTAT
	Endif
	
	
	// Busca o Departamento e Usuario
    aInfUser  := pswret(NIl)
    cUserGrp  := alltrim(aInfUser[1,12])
	wcDepto   := cUserGrp
	wcUsuario := cUserName
	
	wcSuaReferencia   := TRB->CJ_NUMCOT 
	wcNossaReferencia := TRB->CJ_NUM

	// Itens do Orcamento
	dbSelectArea("SCK")
	dbSetOrder(1)	
	// Filial    +Num. Pedido +Item    +Produto
	// CK_FILIAL +CK_NUM      +CK_ITEM +CK_PRODUTO
	dbSeek(xFilial("SCK") + TRB->CJ_NUM ,.T.)


	// Descricao Generica do Produto
	dbSelectArea("SB1")
	dbSetOrder(1)
	// Filial    +Codigo
	// B1_FILIAL +B1_COD
	If dbSeek(xFilial("SB1") + SCK->CK_PRODUTO, .T.)	

      // Verifica se o Item e um Cod. Inteligente
      // Caso seja desmonta o codigo
      aInfoProd := u_DesmontCodInt(SB1->B1_COD) // ou SCK->CK_PRODUTO
      
	   // Campos do Codigo Inteligente      
		wcItemB1 	 :=  SCK->CK_QTDVEN
		wcCodProd 	 :=  ""
		wcDiamentro  :=  ""
		wcTipo 	  	 :=  ""
		wcCunha 		 :=  ""
		wcHaste 		 :=  ""
		wcPadraoConstrucao := ""



		//Mat. Corpo
		wB1_XMATCOP := SB1->B1_XMATCOP 
		//Mat. Tampa
		wB1_XMATTAM := SB1->B1_XMATTAM
		//Mat. Cunha
		wB1_XMATCUN := SB1->B1_XMATCUN
		//Mat. Haste
		wB1_XMATHAS := SB1->B1_XMATHAS
		//Mat. Junta
		wB1_XMATJUN := SB1->B1_XMATJUN
		//Mat. Gaxeta
		wB1_XMATGAX := SB1->B1_XMATGAX
		//Mat. Prisioneiro
		wB1_XMATPRI := SB1->B1_XMATPRI
		//Mat. Porca
		wB1_XMATPOR := SB1->B1_XMATPOR
		//Extremidade
		wB1_XEXTREM := SB1->B1_XEXTREM
		//Acab. Face
		wB1_XACBFAC := SB1->B1_XACBFAC
		//Construcao
		wB1_XCONSTR := SB1->B1_XCONSTR
		//Dimensao
		wB1_XDIMENS := SB1->B1_XDIMENS
		//Identificacao
		wB1_XIDENTI := SB1->B1_XIDENTI
		//Inspeção
		wB1_XINSPEC := SB1->B1_XINSPEC
		//Teste
		wB1_XTESTE := SB1->B1_XTESTE
		//Haste
		wB1_XHASTE := SB1->B1_XHASTE
		//Acionamento
		wB1_XACIONA := SB1->B1_XACIONA
		//Material
		wB1_XMATERI := SB1->B1_XMATERI

		//Posicione(cAlias, nOrdem, cChave, cCampo)
		//cAlias - Alias do arquivo
		//nOrdem - Ordem utilizada
		//cChave - Chave pesquisa
		//cCampo - Campo a ser retornado
        //X5_FILIAL+X5_TABELA+X5_CHAVE

		//Material Corpo
		wB1_XDESCOP := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XMATCOP, "X5_DESCRI")
		//Material Tampa
		wB1_XDESCTA := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XMATTAM, "X5_DESCRI")
		//Material Cunha
		wB1_XDESCUN := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XMATCUN, "X5_DESCRI")
		//Material Haste
		wB1_XDESCHA := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XMATHAS, "X5_DESCRI")
		//Material Junta
		wB1_XDESCJU := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XMATJUN, "X5_DESCRI")
		//Material Gaxeta
		wB1_XDESGAX := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XMATGAX, "X5_DESCRI")
		//Material Prisioneiro
		wB1_XDESPRI := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XMATPRI, "X5_DESCRI")
		//Material Porca
		wB1_XDESPOR := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XMATPOR, "X5_DESCRI")
		//Material Extremidade
		wB1_XDESEXT := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XEXTREM, "X5_DESCRI")
		//Material Acab. Face
		wB1_XDESFAC := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XACBFAC, "X5_DESCRI")
		//Mat. Construcao
		wB1_XDESCON := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XCONSTR, "X5_DESCRI")
		//Mat. Dimensao
		wB1_XDESDIM := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XDIMENS, "X5_DESCRI")
		//Mat. Identificação
		wB1_XDESIDE := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XIDENTI, "X5_DESCRI")
		//Mat. Inspecao
		wB1_XDESINS := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XINSPEC, "X5_DESCRI")
		//Mat. Teste
		wB1_XDESTES := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XTESTE,  "X5_DESCRI")
		//Mat. Haste
		wB1_XDESHAT := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XTESTE,  "X5_DESCRI")
		//Mat. Acionamento
		wB1_XDESACI := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XACIONA, "X5_DESCRI")
		//Material
		wB1_XDESMAT := Posicione("SX5", 1, xFilial("SX5")+""+SB1->B1_XMATERI, "X5_DESCRI")
		
	Endif

	nK := 0
	nContador := 0; 
	
	While SCK->CK_NUM == TRB->CJ_NUM 
	   
	   nContador := nContador + 1
	   nK := nK + 1

		//COLUNAS		
		aAdd(wcItem, SCK->CK_ITEM)
		aAdd(wcQtd, SCK->CK_QTDVEN)
		aAdd(wcCodCliente, SCK->CK_NUMREF)
		aAdd(wcDescTecnica, SCK->CK_DSCTEC)

		SCK->(DbSkip())
		
	EndDo
	
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
	OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(nContador))	//variavel para identificar o numero total de
																//linhas na parte variavel
																//Sera utilizado na macro do documento para execucao 
																//do for next

	// Adicionado no HCIR013
	//Cabecalho

	OLE_SetDocumentVar(hWord, 'Prt_Cliente', wcCliente)	
	OLE_SetDocumentVar(hWord, 'Prt_NomeContato', wcNomeContato)	
	OLE_SetDocumentVar(hWord, 'Prt_Contato', wcContato)
	OLE_SetDocumentVar(hWord, 'Prt_Endereco', wcEndereco)
	OLE_SetDocumentVar(hWord, 'Prt_CEP', wcCEP)
	OLE_SetDocumentVar(hWord, 'Prt_Cidade', wcCidade)
	OLE_SetDocumentVar(hWord, 'Prt_Estado', wcEstado)
	OLE_SetDocumentVar(hWord, 'Prt_Depto', wcDepto)
	OLE_SetDocumentVar(hWord, 'Prt_SuaReferencia', wcSuaReferencia)
	OLE_SetDocumentVar(hWord, 'Prt_NossaReferencia', wcNossaReferencia)		
	OLE_SetDocumentVar(hWord, 'Prt_Usuario', wcUsuario)			
	
	
	//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
	// prt_cod1, prt_cod2 ... prt_cod10
	for nK := 1 to nContador
	
	   //Colunas
	   OLE_SetDocumentVar(hWord, 'Prt_Item'+AllTrim(Str(nK)), wcItem[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_Qtd'+AllTrim(Str(nK)), wcQtd[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_CodCliente'+AllTrim(Str(nK)), wcCodCliente[nK])
	   OLE_SetDocumentVar(hWord, 'Prt_DescTecnica'+AllTrim(Str(nK)), wcDescTecnica[nK])
	   
	next

		OLE_SetDocumentVar(hWord, 'P_Item', wcItemB1)
		OLE_SetDocumentVar(hWord, 'P_Quantidade', wcQuantidade)
		OLE_SetDocumentVar(hWord, 'P_Diamentro', wcDiamentro)
		OLE_SetDocumentVar(hWord, 'P_Tipo', wcTipo)
		OLE_SetDocumentVar(hWord, 'P_Cunha', wcCunha)
		OLE_SetDocumentVar(hWord, 'P_Haste', wcHaste)
		OLE_SetDocumentVar(hWord, 'P_PadraoConstrucao', wcPadraoConstrucao)
		
		
		//OLE_SetDocumentVar(hWord, 'P_MaterialCorpo', wcMaterialCorpo)
		//OLE_SetDocumentVar(hWord, 'P_Aneis', wcAneis)
		//OLE_SetDocumentVar(hWord, 'P_Tampa', wcTampa)
		//OLE_SetDocumentVar(hWord, 'P_MaterialCunha', wcMaterialCunha)
		//OLE_SetDocumentVar(hWord, 'P_MaterialHaste', wcMaterialHaste)
		//OLE_SetDocumentVar(hWord, 'P_AnelEspirotalico', wcAnelEspirotalico)
		//OLE_SetDocumentVar(hWord, 'P_ClassePressao', wcClassePressao)
		//OLE_SetDocumentVar(hWord, 'P_Extremidades', wcExtremidades)
		//OLE_SetDocumentVar(hWord, 'P_Gaxeta', wcGaxeta)
		//OLE_SetDocumentVar(hWord, 'P_Castelo', wcCastelo)
		//OLE_SetDocumentVar(hWord, 'P_PremeGaxeta', wcPremeGaxeta)
		//OLE_SetDocumentVar(hWord, 'P_BuchaMovimento', wcBuchaMovimento)
		//OLE_SetDocumentVar(hWord, 'P_Volante', wcVolante)
		//OLE_SetDocumentVar(hWord, 'P_PrisioneiroCorpo', wcPrisioneiroCorpo)
		//OLE_SetDocumentVar(hWord, 'P_PorcaCorpo', wcPorcaCorpo)
		//OLE_SetDocumentVar(hWord, 'P_Pintura', wcPintura)
		//OLE_SetDocumentVar(hWord, 'P_PlacaIdentificacao', wcPlacaIdentificacao)
		//OLE_SetDocumentVar(hWord, 'P_Fabricante', wcFabricante)
		//OLE_SetDocumentVar(hWord, 'P_Modelo', wcModelo)

		OLE_SetDocumentVar(hWord, 'P_B1_XMATCOP', wB1_XMATCOP)
		OLE_SetDocumentVar(hWord, 'P_B1_XMATTAM', wB1_XMATTAM)
		OLE_SetDocumentVar(hWord, 'P_B1_XMATCUN', wB1_XMATCUN)
		OLE_SetDocumentVar(hWord, 'P_B1_XMATHAS', wB1_XMATHAS)
		OLE_SetDocumentVar(hWord, 'P_B1_XMATJUN', wB1_XMATJUN)
		OLE_SetDocumentVar(hWord, 'P_B1_XMATGAX', wB1_XMATGAX)
		OLE_SetDocumentVar(hWord, 'P_B1_XMATPRI', wB1_XMATPRI)
		OLE_SetDocumentVar(hWord, 'P_B1_XMATPOR', wB1_XMATPOR)
		OLE_SetDocumentVar(hWord, 'P_B1_XEXTREM', wB1_XEXTREM)
		OLE_SetDocumentVar(hWord, 'P_B1_XACBFAC', wB1_XACBFAC)
		OLE_SetDocumentVar(hWord, 'P_B1_XCONSTR', wB1_XCONSTR)
		OLE_SetDocumentVar(hWord, 'P_B1_XDIMENS', wB1_XDIMENS)
		OLE_SetDocumentVar(hWord, 'P_B1_XIDENTI', wB1_XIDENTI)
		OLE_SetDocumentVar(hWord, 'P_B1_XINSPEC', wB1_XINSPEC)
		OLE_SetDocumentVar(hWord, 'P_B1_XTESTE',  wB1_XTESTE)
		OLE_SetDocumentVar(hWord, 'P_B1_XHASTE',  wB1_XHASTE)
		OLE_SetDocumentVar(hWord, 'P_B1_XACIONA', wB1_XACIONA)
		OLE_SetDocumentVar(hWord, 'P_B1_XMATERI', wB1_XMATERI)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESCOP', wB1_XDESCOP)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESCTA', wB1_XDESCTA)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESCUN', wB1_XDESCUN)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESCHA', wB1_XDESCHA)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESCJU', wB1_XDESCJU)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESGAX', wB1_XDESGAX)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESPRI', wB1_XDESPRI)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESPOR', wB1_XDESPOR)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESEXT', wB1_XDESEXT)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESFAC', wB1_XDESFAC)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESCON', wB1_XDESCON)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESDIM', wB1_XDESDIM)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESIDE', wB1_XDESIDE)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESINS', wB1_XDESINS)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESTES', wB1_XDESTES)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESHAT', wB1_XDESHAT)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESACI', wB1_XDESACI)
		OLE_SetDocumentVar(hWord, 'P_B1_XDESMAT', wB1_XDESMAT)		
		
		//RODAPE
		OLE_SetDocumentVar(hWord, 'Prt_Rodape', wcRodape)		
	
	OLE_ExecuteMacro(hWord,"tabitens")
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
SCK->(dbCloseArea())
SB1->(dbCloseArea())
SA1->(dbCloseArea())
SU5->(dbCloseArea())

RestArea(aAreaAnt)

Return()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³   Fernando Rodrigo Ribeiro    ³ Data ³05.02.2007³±±
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

PutSX1("HCI013","01","Orcamento Inicial: ","","","mv_ch1","C",06,0,0,"G","ExistCpo('SCJ')","SCJ","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------

PutSX1("HCI013","02","Orcamento Final:   ","","","mv_ch2","C",06,0,0,"G","NaoVazio(mv_par02) .Or. ExistCpo('SCJ')","SCJ","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

RestArea(aAreaAnt)

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DesmontCodInt³ Autor ³Fernando Ribeiro    ³ Data ³ 06/02/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna array com as caracteristica do Cod. Inteligente     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Desmonta um Codigo Inteligente                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DesmontCodInt(cCodigo)
Local cCodBS  := Nil
Local cDescBS := Nil
Local aSavAre := {GetArea(), SBQ->(GetArea()), SBS->(GetArea())}
Local cFamilia := ""
Local nTamanho := 0 
Local nCont := 1
Local aRet     := {}
Local bEncontrou := .F.

dbSelectArea("SBP")
dbSetOrder(1)

While (nCont <= Len(AllTrim(cCodigo)) .AND. bEncontrou == .F.) //Tamanho do SBP->BP_BASE == 14
	cFamilia := SubStr(cCodigo, 1, nCont)
 	If dbSeek(xFilial("SBP") + cFamilia + Space(14-nCont))
 		bEncontrou := .T.
 	Endif
 	nCont := nCont + 1
Enddo


If ! SBP->BP_CODPAD == "2"
	cCodigo := SubStr(cCodigo, Len(AllTrim(SBP->BP_BASE)) + 1)
Endif

dbSelectArea("SBQ")
dbSeek(xFilial("SBQ") + SBP->BP_BASE)

do While ! Eof() .And. SBQ->(BQ_FILIAL + BQ_BASE) == xFilial("SBQ") + SBP->BP_BASE
	
	If SBP->BP_CODPAD == "2"
		cCodBS  := Substr(cCodigo, SBQ->BQ_INICIO, SBQ->BQ_TAMANHO)
	Else
		cCodBS  := SubStr(cCodigo, 1, SBQ->BQ_TAMANHO)
		cCodigo := SubStr(cCodigo, SBQ->BQ_TAMANHO + 1)
	Endif
	
	If SBQ->BQ_TIPDEF == "1" //Manual
		SBS->(dbSeek(xFilial("SBS") + SBQ->(BQ_BASE + BQ_ID) + cCodBS))
		cDescBS := SBS->BS_DESCPRD
	ElseIf SBQ->BQ_TIPDEF == "2" //Conjunto
		SBX->(dbSeek(xFilial("SBX") + SBQ->BQ_CONJUNT + cCodBS))
		cDescBS := SBX->BX_DESCPR
	ElseIf SBQ->BQ_TIPDEF == "3" //Intervalo
		cDescBS := cCodBS
	Endif		
	
	nTamanho := Len(cCodBs)
	
	Aadd(aRet, {cFamilia, SBQ->BQ_ID, cCodBS, cDescBS, nTamanho})
	
	dbSkip()
	
Enddo

RestArea(aSavAre[3])
RestArea(aSavAre[2])
RestArea(aSavAre[1])

Return(aRet)
