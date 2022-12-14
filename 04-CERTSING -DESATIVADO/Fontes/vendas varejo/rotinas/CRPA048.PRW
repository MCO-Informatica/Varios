#include "totvs.ch"

// #########################################################################################
// Projeto: Integra??o Protheus x Portal da Rede
// Modulo : Remunera??o de Parceiros
// Fonte  : CRPA048
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 22/01/18 | Renato Ruy			 | Cadastro de vinculo Entidade x Parceiro
// ---------+-------------------+-----------------------------------------------------------

user function CRPA048()

	//trabalho/apoio
	Local cTabela := "ZZF"
	
	Private 	aRotina := {;
							{ "Pesquisar"	, "AxPesqui"		, 0, 1},;
							{ "Visualizar", "AxVisual"		, 0, 2},;
							{ "Incluir"	, "AxInclui"		, 0, 3},;
							{ "Alterar"	, "AxAltera"		, 0, 4},;
							{ "Excluir"	, "AxDeleta"		, 0, 5},;
							{ "Importar"	, "U_CRPA048I()"	, 0, 6};
							} 
	
	
	dbSelectArea(cTabela)
	dbSetOrder(1)

	//T?tulo a ser utilizado nas opera??es
	private cCadastro := "Cadastro de Entidade x Parceiro"

	dbSelectArea(cTabela)
	mBrowse( 6, 1, 22, 75, cTabela)
	
	
return

//Renato Ruy - 22/01/2018
//Valida??o para o campo CPF
//Validar se o CPF j? existe e se est? preenchido corretamente.
User Function CRPA048V()
	Local lRet := .T.
	
	//Se a chamada for efetuada pelo c?digo da entidade
	//Verifica se o CPF j? foi preenchido
	If !Empty(M->ZZF_CPF)
		//Utiliza a fun??o padr?o para validar
		lRet := CGC(M->ZZF_CPF)
		
		//Verifica se j? existe na base de dados
		If lRet
			ZZF->(DbSetOrder(1))
			If ZZF->(DbSeek(xFilial("ZZF")+RTRIM(M->ZZF_CPF)+M->ZZF_CODENT))
				MsgInfo("J? existe cadastro para este CPF x Cadastro de Entidade!")
				lRet := .F.
			Endif
		Endif
		
	Endif

Return lRet

//Renato Ruy - 22/01/2018
//Valida??o para o campo CPF
//Validar se o CPF j? existe e se est? preenchido corretamente.
User Function CRPA048X()
	Local lRet 	:= .T.
	Local nRecno	:= Iif(INCLUI,0,ZZF->(Recno()))
	
	//Se a chamada for efetuada pelo c?digo da entidade
	//Verifica se o CPF j? foi preenchido
	If !Empty(M->ZZF_CPF)
		
		ZZF->(DbSetOrder(1))
		If ZZF->(DbSeek(xFilial("ZZF")+RTRIM(M->ZZF_CPF)+M->ZZF_CODENT))
			If nRecno <> ZZF->(Recno())
				MsgInfo("J? existe cadastro para este CPF x Cadastro de Entidade!")
				lRet := .F.
			Endif
		Endif
				
	Endif

Return lRet

//Renato Ruy - 22/01/2018
//Importacao de arquivo
User Function CRPA048I()
	
	Local aArrSay := {}
	Local aArrBut := {}
	Local cArqTxt := ''
	Local lExeFun := .F.
	Private aRet 	:= {}
	Private aPergs:= {}
	
	//Gera as mensagens na tela
	AADD(aArrSay, 'Esta rotina tem por objetivo importar o Cadastro de Parceiro, ')
	AADD(aArrSay, 'conforme arquivos de dados no formato CSV.')
	
	//Botoes na tela
	AAdd(aArrBut, {10, .T., {|| FA160Premis() 				}})
	AADD(aArrBut, {1 , .T., {|| lExeFun := .T., FechaBatch()}})
	AADD(aArrBut, {2 , .T., {|| lExeFun := .F., FechaBatch()}})
	
	//Ativar tela
	FormBatch('Importa??o Parceiros x Entidade', aArrSay, aArrBut)
	
	//Se clicar em OK, executa importacao
	If lExeFun
		//
		aAdd( aPergs ,{6 ,"Importar Arquivo" 	,Space(70)	,""	  ,"","",50,.F.,"Arquivos .CSV |*.CSV"})
		If ParamBox(aPergs ,"Parametro de importa??o ",aRet)
			Processa( {|| CRPA048P( aRet[1] ) }, "Importando cadastros de Parceiros x Entidade") 
		Else
			Alert("A importa??o foi cancelada!")
			Return
		EndIf
	Endif

Return

//-------------------------------------------------------------------
// Rotina | FA160Premis | Autor | Robson Luiz - Rleg | DT | 16/05/013
//-------------------------------------------------------------------
// Rotina | Alterado por:  		| Renato Ruy Bernardo | DT | 23/01/18
//-------------------------------------------------------------------
// Descr. | Rotina de apresenta??o das premissas para a rotina poder
//        | ler o arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160Premis()
	Local	oDlg
	Local	oBtOk
	Local	oSay
	Local	oGet
	Local	oFont := TFont():New( "Arial", , 15, ,.F. )
	Local	oFontB := TFont():New( "Arial", , 15, ,.T. )
	
	Local cPremissa := ""
	
	cPremissa := "1? - O arquivo de dados deve ser gerado com a extens?o CSV e os dados separados por ponto-v?rgula. "       + CRLF + CRLF
	cPremissa += "2? - O arquivo deve conter um cabe?alho (header) com as seguintes nomenclaturas abaixo para cada coluna. " + CRLF + CRLF 
	cPremissa += "Em mai?sculo os nomes das colunas s?o: "                                                                   + CRLF + CRLF 
	cPremissa += " * ENTIDADE (CODIGO DA ENTIDADE)"       + CRLF
	cPremissa += " * CPF (CPF DO PARCEIRO QUE ACESSARA O PORTAL)"          + CRLF
	cPremissa += " * NOME (NOME DO PARCEIRO QUE ACESSARA O PORTAL)"      + CRLF
	cPremissa += "   EMAIL (EMAIL DO PARCEIRO QUE ACESSARA O PORTAL)"         + CRLF
	cPremissa += "No m?nimo devem ser informados os campos com (*)."                                                        + CRLF
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 325, 520 TITLE "Premissas para processar o arquivo de dados" PIXEL
		@ 05, 5 SAY oSay VAR "P R E M I S S A S" SIZE 205, 010 FONT oFontB OF oDlg PIXEL COLOR CLR_HRED
		@ 15, 5 GET oGet VAR cPremissa OF oDlg MEMO SIZE 252, 125 FONT oFont PIXEL READONLY
		DEFINE SBUTTON oBtOk FROM 145, 232 TYPE 22 ACTION oDlg:End () ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//Renato Ruy - 23/01/2018
//Processa a importa??o dos dados
Static Function CRPA048P(cArquivo)
	
	Local aHeader := {}
	Local aItem	:= {}
	Local lNovo	:= .F.
	Local aLog		:= {}

	//----------------------------
	// Abrir o arquivo texto (CSV)
	//----------------------------
	FT_FUSE( cArquivo )
	//----------------------------------------
	// Posicionar na primeira linha do arquivo
	//----------------------------------------
	FT_FGOTOP()

	//--------------------------------------------------------
	// Estabelece e inicia o incremento da r?gua de progress?o
	//--------------------------------------------------------
	ProcRegua( FT_FLASTREC() )
	IncProc()
	
	//----------------------------------------------------
	// Ler a 1? linha que precisa ser o Header da planilha
	//----------------------------------------------------
	aHeader := StrTokArr(FT_FREADLN(),";")

   //---------------------------------
   // Efetua compara??es
   //---------------------------------
	If Len(aHeader) < 4
		Alert("O numero de colunas do arquivo esta incorreto!")
		Return
	Endif
	
	If AllTrim(aHeader[1]) != "ENTIDADE"
		Alert("A Coluna Entidade n?o consta na posi??o solicitada e a rotina sera cancelada!")
		Return
	Elseif AllTrim(aHeader[2]) != "CPF"
		Alert("A Coluna CPF n?o consta na posi??o solicitada e a rotina sera cancelada!")
		Return
	Elseif AllTrim(aHeader[3]) != "NOME"
		Alert("A Coluna Nome n?o consta na posi??o solicitada e a rotina sera cancelada!")
		Return
	Elseif AllTrim(aHeader[4]) != "EMAIL"
		Alert("A Coluna E-mail n?o consta na posi??o solicitada e a rotina sera cancelada!")
		Return
	Endif
	
	//---------------------------------
   // Ir para o pr?xima linha de dados
   //---------------------------------
	FT_FSKIP()
	
	//Envio para processamento de 10 em 10 pedidos.
	While !FT_FEOF()
		
		//Leio a linha e gero array com os dados
		aItem	:= StrTokArr(StrTran(FT_FREADLN(),";;","; ;"),";")
		
		While Len(aItem) < 4
			AADD(aItem," ")
		Enddo
		
		//Se uma das informacoes essenciais nao estiver preenchida, pula
		// aItem[1] - ENTIDADE
		// aItem[2] - CPF
		// aItem[3] - NOME
		// aItem[4] - EMAIL - Este campo nao e obrigatorio
		If Empty(aItem[1]) .Or. Empty(aItem[2]) .Or. Empty(aItem[3])
			AADD(aLog,{aItem[1]," ",aItem[2],aItem[3],aItem[4],"Campo Obrigat?rio n?o est? preenchido!"})
			FT_FSKIP()
			Loop
		Endif
		
		//Se e numerico, adiciona os caracteres a esquerda
		If Val(aItem[1]) > 0 //Entidade
			aItem[1] := PadL(aItem[1],6,"0")
		Endif
		
		IncProc( "Importando Dados da Planilha..")
		ProcessMessage()
		
		SZ3->(DbSetOrder(1))
		If !SZ3->(DbSeek(xFilial("SZ3")+aItem[1]))
			AADD(aLog,{aItem[1]," ",aItem[2],aItem[3],aItem[4],"A Entidade n?o existe no cadastro da SZ3!"})
			FT_FSKIP()
			Loop
		Endif
		
		If Val(aItem[2]) > 0 //CPF
			aItem[2] := PadL(aItem[2],11,"0")
		Endif
		
		ZZF->(DbSetOrder(1)) //CPF + ENTIDADE
		lNovo := !ZZF->(DbSeek(xFilial("ZZF")+aItem[2]+aItem[1]))
		
		//Cria ou atualiza as informacoes
		Reclock("ZZF",lNovo)
			ZZF_CODENT   :=  SZ3->Z3_CODENT  
			ZZF_CPF      :=  aItem[2]
			ZZF_NOME     :=  aItem[3] 
			ZZF_EMAIL    :=  aItem[4]	
		ZZF->(MsUnlock())
		
		AADD(aLog,{aItem[1],SZ3->Z3_DESENT,aItem[2],aItem[3],aItem[4],"Cadastro " + Iif(lNovo,"Inclu?do","Alterado")})
		
		FT_FSKIP()	
	Enddo
	
	FT_FUSE()
	fClose(cArquivo)	
	
	//Renato Ruy - 24/01/2018
	//Gera Log para controle
	IncProc( "Gerando relat?rio com o pedidos do per?odo")
	ProcessMessage()
	CRPA48L(aLog)
Return

//Renato Ruy - 24/01/2018
//Rotina para gera??o do log
Static Function CRPA48L(aLog)

Local aHead := {}

Aadd(aHead,"C?DIGO POSTO")
Aadd(aHead,"DESCRI??O POSTO")	
Aadd(aHead,"CPF DO PARCEIRO")
Aadd(aHead,"NOME DO PARCEIRO")
Aadd(aHead,"E-MAIL DO PARCEIRO")
Aadd(aHead,"STATUS")

//Exporta arquivo com os dados do Log de Pedidos em Lote.
MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
								{||DlgToExcel({{"ARRAY",;
								"LOG DE IMPORTA??O",;
								aHead,aLog}})})

Return