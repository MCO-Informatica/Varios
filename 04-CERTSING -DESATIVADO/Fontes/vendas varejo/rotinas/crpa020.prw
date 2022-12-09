#INCLUDE "PROTHEUS.CH" 
#Include "TopConn.Ch" 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRPA020  ? Autor ? Tatiana Pontes 	   ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Descricao ? Manutencao e geracao da remuneracao de parceiros		      ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/ 
 
User Function CRPA020() 
	Local aCores := 	{	{ "Empty(SZ6->Z6_DTPGTO)",	"BR_VERDE"		},; 
							{ "!Empty(SZ6->Z6_DTPGTO)",	"BR_VERMELHO"	}; 
						} 
	
	Private aRotina := 	{	{ "Pesquisar"		, "AxPesqui"	, 0, 1		},; 
							{ "Visualizar"		, "U_CRP020Visu", 0, 2		},; 
							{ "Incluir"			, "U_CRP020Incl", 0, 3		},; 
							{ "Alterar"			, "U_CRP020Alte", 0, 4, 2	},; 
							{ "Copiar"			, "U_CRP020Cpy"	, 0, 3  	},; 
							{ "Excluir"			, "U_CRP020Dele", 0, 5, 1	},; 
							{ "Gerar"			, "U_CRP020Gera", 0, 6  	},; 
							{ "Legenda"			, "U_CRP020Lege", 0, 7		},; 
							{ "Log de C?lculo"	, "U_CRP020Impr", 0, 8		},; 
							{ "Rel. Remuneração", "U_CRPR010"	, 0, 9		},; 
							{ "Grava CCR"		, "U_CRPA020C"	, 0, 1		}; 
						} 
	
	//??????????????????????????????????????????????????? 
	//? Define o cabecalho da tela de atualizacoes       ? 
	//???????????????????????????????????????????????????? 
	
	Private cCadastro 	:= "Remuneração de Parceiros" 
	Private cRemPer		:= AllTrim(GetMV("MV_REMMES")) // PERIODO DE CALCULO EM ABERTO 
	
	//??????????????????????????????????????????????????? 
	//? Endereca a funcao de BROWSE					     ? 
	//???????????????????????????????????????????????????? 
	
	mBrowse(0,0,0,0,"SZ6",,,,,,aCores) 
Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Visu  ? Autor ? Tatiana Pontes    ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Funcao de Visualizacao									  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/ 
User Function CRP020Visu(cAlias,nReg,nOpc) 
	Local aButtons	:=	{} 
	
	//??????????????????????????????????????????????????? 
	//? Adicao de botoes - Enchoice Principal            ? 
	//???????????????????????????????????????????????????? 
	
	AADD(aButtons,{"SDUSTRUCT",{||U_CRP020Gar()},"Proc.GAR"}) // Consulta Processo Gar relacionado a remuneracao 
	
	AxVisual( cAlias, nReg, nOpc, , , , , aButtons ) 
Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Incl  ? Autor ? Tatiana Pontes    ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Funcao de Inclusao   									  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/ 
User Function CRP020Incl(cAlias,nReg,nOpc) 
 	AxInclui( cAlias, nReg, nOpc ) 
Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Alte  ? Autor ? Tatiana Pontes    ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Funcao de Alteracao   									  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/
User Function CRP020Alte(cAlias,nReg,nOpc) 
	Local aParam	:= 	{} 
	Local aButtons	:=	{} 
	Local cLog		:=	"" 
	
	//?????????????????????????????????????????????????????????????????????? 
	//? Antes de permitir alteracao verifica se o periodo nao esta fechado  ? 
	//??????????????????????????????????????????????????????????????????????? 
	
	If SubStr(DtoS(SZ6->Z6_DTEMISS),1,6) < cRemPer 
		cLog := "não ? poss?vel excluir este movimento." + CRLF 
		cLog += "O per?odo " + SubStr( DtoS(SZ6->Z6_DTEMISS),5, 2 ) + "/" + Left( DtoS(SZ6->Z6_DTEMISS), 4 ) + " encontra-se fechado." 
		MsgStop(cLog) 
		Return(.F.) 
	EndIf 
	
	//??????????????????????????????????????????????????? 
	//? Adicao de botoes - Enchoice Principal            ? 
	//???????????????????????????????????????????????????? 
	
	AADD(aButtons,{"SDUSTRUCT",{||U_CRP020Gar()},"Proc.GAR"}) // Consulta Processo Gar relacionado a remuneracao 
	
	Aadd(aParam, {|| .T.} )					// Codeblock a ser executado antes da abertura do dialogo 
	Aadd(aParam, {|| CRP020Ok()  } )		// Codeblock a ser executado ao clicar no botao Ok 
	Aadd(aParam, {|| CRP020Grv() } )		// Codeblock a ser executado dentro da transacao 
	Aadd(aParam, {|| .T.} )					// Codeblock a ser executado apos a transacao. 
	
	AxAltera( cAlias, nReg, nOpc,,,,,,,, aButtons, aParam ) 
Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Dele  ? Autor ? Tatiana Pontes    ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Funcao de Exclusao   									  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/ 
 
User Function CRP020Dele(cAlias,nReg,nOpc) 
	Local aButtons	:=	{} 
	Local cLog		:=	"" 
	Local cChvPesq	:= Alltrim(SZ6->Z6_PEDGAR) 
	
	//?????????????????????????????????????????????????????????????????????? 
	//? Antes de permitir exclusao verifica se o periodo nao esta fechado   ? 
	//??????????????????????????????????????????????????????????????????????? 
	
	If SubStr(DtoS(SZ6->Z6_DTEMISS),1,6) < cRemPer 
		cLog := "não ? poss?vel excluir este movimento." + CRLF 
		cLog += "O per?odo " + SubStr( DtoS(SZ6->Z6_DTEMISS),5, 2 ) + "/" + Left( DtoS(SZ6->Z6_DTEMISS), 4 ) + " encontra-se fechado." 
		MsgStop(cLog) 
		Return(.F.) 
	Endif 
	
	//??????????????????????????????????????????????????? 
	//? Adicao de botoes - Enchoice Principal            ? 
	//???????????????????????????????????????????????????? 
	
	AADD(aButtons,{"SDUSTRUCT",{||U_CRP020Gar()},"Proc.GAR"}) // Consulta Processo Gar relacionado a remuneracao 
	
	uRet := AxDeleta( cAlias , nReg , 5 , NIL , NIL , NIL , NIL , NIL , .T. ) 
	
	If uRet == 2 
		dbSelectArea("SZ5") 
		SZ5->( DbSetOrder(1) )	// Z5_FILIAL + Z5_PEDGAR 
		If SZ5->( MsSeek( xFilial("SZ5") + cChvPesq ) ) 
			While !SZ5->(Eof()) .AND. cChvPesq == SZ5->Z5_PEDGAR 
				If Alltrim(SZ5->Z5_ROTINA) == 'GARA130' 
					SZ5->( RecLock("SZ5",.F.) ) 
					//SZ5->Z5_COMISS := "1" 
					SZ5->Z5_OBSCOM := "" 
					SZ5->( MsUnLock() ) 
				Endif 
				SZ5->( dbSkip() ) 
			End 
		Endif 
		SZ5->( dbCloseArea() )
	Endif 
Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Gera  ? Autor ? Tatiana Pontes    ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Funcao de geracao lancamentos de remuneracao de parceiros  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/ 
User Function CRP020Gera(cAlias,nReg,nOpc) 
	Local cPerg		:= "CRP020    " 
	Local aSays		:= {} 
	Local aButtons	:= {} 
	
	Aadd( aSays, "GERA??O DE LAN?AMENTOS PARA Remuneração DE PARCEIROS" ) 
	Aadd( aSays, "" ) 
	Aadd( aSays, "Ser? gerado lan?amentos de valores apurados para pagamento de comiss?o." ) 
	Aadd( aSays, "Os lan?amentos ser?o gerados a partir dos dados gerados pelo GAR e com" ) 
	Aadd( aSays, "base nas regras de comiss?o do cadastro de entidades." ) 
	Aadd( aSays, "Defina os par?metros para sele??o dos registros que ser?o processados." ) 
	
	AjustaSX1(cPerg) 
	Pergunte(cPerg, .F. ) 
	
	Aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T.) } } ) 
	Aadd(aButtons, { 1,.T.,{|| Processa( {|| CRP020Proc() }, "Selecionando registros..."), FechaBatch() }} ) 
	//Aadd(aButtons, { 1,.T.,{|| 	FWMsgRun(,{|| CRP020Proc()},,'Selecionando registros...'), FechaBatch() }} ) 
	Aadd(aButtons, { 2,.T.,{|| FechaBatch() }} ) 
	
	FormBatch( cCadastro, aSays, aButtons ) 
Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Lege  ? Autor ? Tatiana Pontes    ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Legenda													  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/
User Function CRP020Lege() 
	BrwLegenda(cCadastro,"Legenda", {	{"BR_VERDE",	"Lan?amento em aberto"},; 
										{"BR_VERMELHO",	"Valor com t?tulo gerado"}; 
									}; 
			) 
 Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Imp   ? Autor ? Tatiana Pontes    ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Relatorio de processos do GAR que nao geraram lancamento   ??? 
???          ? de remuneracao											  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/ 
 
User Function CRP020Impr() 
	Local wnrel   	:= "CRPR001"			// Nome do Arquivo utilizado no Spool 
	Local Titulo 	:= "Processos do GAR que não geraram Remuneração" 
	Local cDesc1 	:= "Relat?rio usado para avaliar os itens de valida??es" 
	Local cDesc2 	:= "que não geraram lan?amentos de Remuneração." 
	Local cDesc3 	:= "A emiss?o ocorrer? baseada nos par?metros do relat?rio" 
	Local nomeprog	:= "CRPR001.PRW"		// Nome do programa 
	Local cString 	:= "SZ5"				// Alias utilizado na Filtragem 
	Local lDic    	:= .F.					// Habilita/Desabilita Dicionario 
	Local lComp   	:= .F.					// Habilita/Desabilita o Formato Comprimido/Expandido 
	Local lFiltro 	:= .T.					// Habilita/Desabilita o Filtro 
	
	Private Tamanho := "G"					// P/M/G 
	Private Limite  := 220					// 80/132/220 
	Private aReturn := { "Zebrado",;		// [1] Reservado para Formulario 
						 1,;				// [2] Reservado para N? de Vias 
						 "Administrador",;	// [3] Destinatario 
						 2,;				// [4] Formato => 1-Comprimido 2-Normal 
						 1,;	    		// [5] Midia   => 1-Disco 2-Impressora 
						 1,;				// [6] Porta ou Arquivo 1-LPT1... 4-COM1... 
						 "",;				// [7] Expressao do Filtro 
						 1 } 				// [8] Ordem a ser selecionada 
	// [9]..[10]..[n] Campos a Processar (se houver) 
	Private m_pag   := 1					// Contador de Paginas 
	Private nLastKey:= 0					// Controla o cancelamento da SetPrint e SetDefault 
	Private cPerg   := "CRP020    "			// Pergunta do Relatorio 
	Private aOrdem  := {}					// Ordem do Relatorio 
	
	//??????????????????????????????????????????????????? 
	//? Verifica as perguntas selecionadas			     ? 
	//???????????????????????????????????????????????????? 
	
	AjustaSX1(cPerg) 
	
	If IsInCallStack("CRP020Proc") 
		mv_par06 := 2 
	Endif 
	
	Pergunte(cPerg, .F.) 
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro) 
	
	If (nLastKey == 27) 
		DbSelectArea(cString) 
		DbSetOrder(1) 
		DbClearFilter() 
		Return 
	Endif 
	
	SetDefault(aReturn,cString) 
	
	RptStatus({|lEnd| ImpCRPR01(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo) 
Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Gar  ? Autor ? Tatiana Pontes 	   ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Mostra processo Gar relacionado a remuneracao	 		  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/
User Function CRP020Gar() 
	dbSelectArea("SZ5") 
	SZ5->( DbSetOrder(1) )	// Z5_FILIAL + Z5_PEDGAR 
	If SZ5->( MsSeek( xFilial("SZ5")+Alltrim(SZ6->Z6_PEDGAR) ) ) 
		AxVisual("SZ5",SZ5->(Recno()),4,,,,,,,,,,,,,,) 
	Else 
		MsgAlert("não h? processo GAR relacionado a este registro de Remuneração") 
	Endif 
Return() 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRPA020  ? Autor ? Tatiana Pontes 	   ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Processa lancamentos da remuneracao de parceiros	 		  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/ 
 
Static Function CRP020Proc() 
	Local cQuery	 := "" 
	Local nQtd		 := 0 
	Local nContador  := 0 
	Local nThread	 := 0 
	Local nTotThread := 0 
	Local aPedidos   := {} 
	Local bOldBlock	 := nil 
	Local cErrorMsg	 := "" 
	
	//TRATAMENTO PARA ERRO FATAL NA THREAD 
	cErrorMsg := "" 
	bOldBlock := ErrorBlock({|e| U_ProcError(e) }) 
	
	/* 
	
	BEGINDOC 
	//?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? 
	//?O que deve ser rumerado?                                                                                                                                                     ? 
	//?                                                                                                                                                                             ? 
	//?Entregas de m?dias de vendas avulsas:                                                                                                                                        ? 
	//?     -Remunerar o Hardware                                                                                                                                                   ? 
	//?     -Com base no registro da SZ5 com o campo Z5_TIPO igual a ENTHAR                                                                                                         ? 
	//?     -O registro ? gravado no processo de faturamento da entrega de m?dia (M460FIM)                                                                                          ? 
	//?     -O valor Base ? o valor de faturamento gravado no Z5_VALORHW                                                                                                            ? 
	//?     -O valor da comiss?o segue regra de Remuneração da verifica??o para toda a cadeia                                                                                        ? 
	//?                                                                                                                                                                             ? 
	//?VALIDA??ES DE Pedidos Gar VERIFICADOS:                                                                                                                                                  ? 
	//?     -Remunerar Hardware e Software                                                                                                                                          ? 
	//?     -Com base no registro da SZ5 com o campo DATA VE VERIFICA??O PREENCHIDOS                                                                                                          ? 
	//?     -O registro ? gravado no processo de notifica??o de VERIFICA??O enviada pelo gar.(GARA130)                                                                              ? 
	//?     -O valor Base ? o valor de Software e Hardware do pedido de venda no ERP referente ao pedido gar.                                                                       ? 
	//?          -Se não existir o pedido GAR no ERP, ent?o busca o Voucher referente ao pedido GAR no ERP. No Voucher identificar o pedido de venda do ERP que originou o voucher. ? 
	//?          -Se não existir o pedido de venda, ent?o identificar o pedido GAR de origem do voucher.                                                                            ? 
	//?          -Buscar o pedido de venda do pedido GAR de ORIGEM                                                                                                                  ? 
	//?          -Se não existir buscar a tabela de pre?o.                                                                                                                          ? 
	//?     -O valor da comiss?o segue regra de Remuneração da verfica??o para toda a cadeia                                                                                        ? 
	//?                                                                                                                                                                             ? 
	//?Renova??o de certificado:                                                                                                                                                    ? 
	//?     -Remunerar o Software da renova??o                                                                                                                                      ? 
	//?     -Com base no registro da SZ5 com o campo DATEMIS E Pedido anterior PEDGANT diferente de Vazio.                                                                  ? 
	//?     -O registro ? gravado no processo de notifica??o de EMISS?O enviada pelo gar.(GARA130)                                                                                  ? 
	//?     -O valor Base ? o valor de Software do pedido de venda no ERP referente ao pedido gar.                                                                                  ? 
	//?          -Se não existir o pedido GAR no ERP, ent?o busca o Voucher referente ao pedido GAR no ERP. No Voucher identificar o pedido de venda do ERP que originou o voucher. ? 
	//?          -Se não existir o pedido de venda, ent?o utilizar o valor da tabela de pre?os.                                                                                     ? 
	//?     -O valor da comiss?o segue regra de Remuneração da verfica??o para toda a cadeia                                                                                        ? 
	//?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? 
	ENDDOC 
	
	BEGINDOC 
	//??????????????????????????????????????????????????????????????????os? 
	//?Os valore de Base de c?lculo de software e hardware s?o gravados ? 
	//?na tabela SZ5 pelas Rotinas GARA130, M460FIM.                    ? 
	//?                                                                 ? 
	//?Os dados complementares para c?culo da Remuneração s?o gravados  ? 
	//?na tabela SZ5 pela rotina ATUMOVRP.                              ? 
	//??????????????????????????????????????????????????????????????????os? 
	ENDDOC 
	
	BEGINDOC 
	//????????????????????????????????????????????????????????????lH? 
	//?Este processamento ? destinado apenas a identifcar o valor ? 
	//?da comiss?o e grava-la na tabela SZ6                       ? 
	//????????????????????????????????????????????????????????????lH? 
	ENDDOC 
	
	Abaixo os par?metros para sele??o dos dados de Remuneração 
	
	//MV_PAR01 ,"Data Inicial?"		,"","","MV_CH1","D",8,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","","",""}) 
	//MV_PAR02 ,"Data Final?"		,"","","MV_CH2","D",8,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","","",""}) 
	//MV_PAR03 ,"Grupo/Rede?"		,"","","MV_CH3","C",3,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","SZ3_02"	,"","","","",""}) 
	//MV_PAR04 ,"Entidade Inicial?"	,"","","MV_CH4","C",6,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","SZ3_05","","","","",""}) 
	//MV_PAR05 ,"Entidade Final?"	,"","","MV_CH5","C",6,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","SZ3_05","","","","",""}) 
	*/ 
	
	// Verifica se os parametros informados pelo usuario sao validos 
	If Mv_Par01 > Mv_Par02 
		MsgStop("Per?odo entre data inicial e final inv?lido. Altere os par?metros.") 
		Return(.F.) 
	Endif 
	
	// Verifica se o periodo solicitado nao esta fechado 
	If SubStr(DtoS(Mv_Par01),1,6) < cRemPer .OR. SubStr(DtoS(Mv_Par02),1,6) < cRemPer 
		cLog := "não ? poss?vel gerar c?lculo no per?odo solicitado." + CRLF 
		cLog += "Os c?lculos somente podem ser gerados do per?odo " +  SubStr( cRemPer,5, 2 ) + "/" + Left( cRemPer, 4 ) + " em diante." 
		MsgStop(cLog) 
		Return(.F.) 
	Endif 
	
	
	/* 
	BEGINDOC 
	//????????????????????????????????????????????????????????????????????????????????????????????o 
	//?Os registros Base para Remuneração est?o na SZ5                                          ? 
	//?Ent?o devemos filtrar todos os registros:                                                ? 
	//?                                                                                         ? 
	//?   -Data de verifica??o do certificado (Z5_DATVER)  no per?odo de apura??o               ? 
	//?   -Data de emiss?o do certificado (Z5_DATEMIS) no per?odo de apura??o (quando renova??o)? 
	//?   -Data de emiss?o do faturamento da entrega (Z5_EMISSAO)                               ? 
	//?                                                                                         ? 
	//?   -Rede de parceiros (rede)                                                             ? 
	//?   -Entidade (postos de atendimento) (de/ate)                                            ? 
	//????????????????????????????????????????????????????????????????????????????????????????????o 
	ENDDOC 
	*/ 
	
	// Seleciona registros para geracao de remuneracao 
	
	cQuery		:= "" 
	cQCampos	:= "" 
	
	cQuery		:= " SELECT * FROM (" 
	cQCampos    +=	"SELECT " 
	cQCampos	+=	"SZ5.R_E_C_N_O_, " 
	cQCampos	+=	"SZ5.Z5_PEDSITE PEDIDO_SITE, SZ5.Z5_PEDGAR PEDIDO_GAR, CASE WHEN Z5_PEDSITE > ' ' THEN Z5_EMISSAO WHEN Z5_PEDGANT = ' ' THEN Z5_DATVER ELSE Z5_DATEMIS END DATA_PEDIDO " 
	
	//Renato Ruy - 13/10/2015 
	//Foram retirados os campo que não s?o necess?rios para o calculo 
	//cQCampos	+=	"SZ3.Z3_PONDIS PONTO_DE_DISTRIBUICAO,SZ3.Z3_CODFED COD_FERECACAO, SZ3.Z3_DESFED, SZ3.Z3_CODCAN COD_CANAL, SZ3.Z3_DESCAN DS_CANAL, " 
	//cQCampos	+=	"SZ3.Z3_CODAC GRUPO_REDE, SZ3.Z3_REDE REDE_GAR, SZ5.Z5_REDE REDE_GARVER, Z3_CCRCOM CRR_COMISSAO, " 
	//cQCampos	+=	"SZ5.Z5_POSVER COD_POS_VER, SZ3.Z3_DESENT DS_POS_VER, SZ5.Z5_CODPOS COD_POS_VAL, SZ5.Z5_DESPOS DS_POSTO_VAL, " 
	//cQCampos	+=	"SZ5.Z5_PEDIDO PEDIDO_PROTHEUS,SZ5.Z5_PEDSITE PEDIDO_SITE, SZ5.Z5_PEDGAR PEDIDO_GAR, SZ5.Z5_PEDGANT PED_ANTERIOR,  " 
	//cQCampos	+=	"SZ5.Z5_EMISSAO DT_REG_PROTHEUS, SZ5.Z5_DATEMIS DT_EMISSAO, SZ5.Z5_DATVER DT_VERIFICACAO, SZ5.Z5_DATVAL DT_VALIDACAO, " 
	//cQCampos	+=	"SZ5.Z5_PRODUTO PRODUTO, SZ5.Z5_DESPRO DS_PRODUTO,SZ5.Z5_TABELA TAB_PRECO, SZ5.Z5_VALOR VALOR, SZ5.Z5_VALORSW VALOR_SOFTWARE, SZ5.Z5_VALORHW VALOR_HARDWARE, " 
	//cQCampos	+=	"SZ5.Z5_DESCAR DS_AR_GAR, SZ5.Z5_GRUPO GRUPO_GAR, SZ5.Z5_DESGRU DS_GRUPO_GAR, SZ5.Z5_DESCAC DS_AC_GAR, " 
	//cQCampos	+=	"SZ5.Z5_TIPMOV TIPMOV, SZ5.Z5_TIPVOU TIPO_VOUCHER, SZ5.Z5_CODVOU COD_VOUCHER, SZ5.Z5_TIPO MOVIMENTO, " 
	//cQCampos	+=	"SZ5.Z5_CODVEND VENDEDOR, SZ5.Z5_NOMVEND DS_VENDEDOR, SZ5.Z5_CODPAR COD_PARCEIRO, SZ5.Z5_NOMPAR NOME_PARCEIRO,SZ3.Z3_CODENT CODENT" 
	
	cQuery	+= cQCampos + ", 'ENTHAR'  AS TIPO" 
	cQuery	+=	" FROM " 
	cQuery	+=	"   " + RetSQLName("SZ5") + " SZ5 LEFT JOIN  " + RetSQLName("SZ3") + "  SZ3 ON SZ3.Z3_FILIAL = ' ' AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.D_E_L_E_T_ = ' ' " 
	cQuery	+=	" WHERE  " 
	cQuery	+=	"     SZ5.Z5_FILIAL = '" + xFilial("SZ5") + " '  " 
	cQuery	+=	"     AND SZ5.Z5_EMISSAO >= '" + DtoS(Mv_Par01) + "' AND SZ5.Z5_EMISSAO <= '" + DtoS(Mv_Par02) + "' " 
	cQuery	+=	"     AND SZ5.Z5_CODPOS >= '" + Mv_Par04 + "' AND SZ5.Z5_CODPOS <=  '" + Mv_Par05 + "'   " 
	cQuery	+=	"     AND Z5_TIPO='ENTHAR'  " 
	If !Empty(mv_par03)  // Filtra por Grupo/Rede 
		cQuery	+=	"     AND SZ3.Z3_CODAC='" + Mv_Par03 + "'  " 
	EndIf 
	cQuery	+=	"     AND SZ5.D_E_L_E_T_ = ' ' " 
	
	cQuery	+=	" UNION " 
	
	cQuery	+=	cQCampos + ", 'VERIFI'  AS TIPO" 
	cQuery	+=	" FROM   " 
	cQuery	+=	"    " + RetSQLName("SZ5") + " SZ5 LEFT JOIN  " + RetSQLName("SZ3") + "  SZ3 ON SZ3.Z3_FILIAL = ' ' AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.D_E_L_E_T_ = ' ' " 
	cQuery	+=	" WHERE " 
	cQuery	+=	"     SZ5.Z5_FILIAL = '" + xFilial("SZ5") + " ' " 
	cQuery	+=	"     AND SZ5.Z5_DATVER >= '" + DtoS(Mv_Par01) + "' AND SZ5.Z5_DATVER  <= '" + DtoS(Mv_Par02) + "' " 
	cQuery	+=	"     AND SZ5.Z5_CODPOS >= '" + Mv_Par04 + "' AND SZ5.Z5_CODPOS <=  '" + Mv_Par05 + "'   " 
	cQuery	+=	"     AND SZ5.z5_tipo in (' ','VALIDA','VERIFI','EMISSA') " 
	If !Empty(mv_par03)  // Filtra por Grupo/Rede 
		cQuery	+=	"     AND SZ3.Z3_CODAC='" + Mv_Par03 + "'  " 
	EndIf 
	cQuery	+=	"     AND SZ5.Z5_PEDGANT=' '  " 
	cQuery	+=	"     AND SZ5.D_E_L_E_T_ = ' ' " 
	
	cQuery	+=	" UNION " 
	
	cQuery	+=	cQCampos + ", 'RENOVA'  AS TIPO" 
	cQuery	+=	" FROM " 
	cQuery	+=	"    " + RetSQLName("SZ5") + " SZ5 LEFT JOIN  " + RetSQLName("SZ3") + "  SZ3 ON SZ3.Z3_FILIAL = ' ' AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.D_E_L_E_T_ = ' ' " 
	cQuery	+=	" WHERE " 
	cQuery	+=	"     SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' " 
	cQuery	+=	"     AND SZ5.Z5_DATEMIS >= '" + DtoS(MV_PAR01) + "' AND SZ5.Z5_DATEMIS <= '" + DtoS(MV_PAR02) + "' " 
	cQuery	+=	"     AND SZ5.Z5_CODPOS >= '" + Mv_Par04 + "' AND SZ5.Z5_CODPOS <=  '" + Mv_Par05 + "'   " 
	cQuery	+=	"     AND SZ5.Z5_TIPO = 'EMISSA' " 
	If !Empty(mv_par03)  // Filtra por Grupo/Rede 
		cQuery	+=	"     AND SZ3.Z3_CODAC='" + Mv_Par03 + "'  " 
	EndIf 
	cQuery	+=	"     AND SZ5.Z5_PEDGANT>'0' " 
	cQuery	+=	"     AND SZ5.D_E_L_E_T_ = ' ' " 
	cQuery		+= ") ORDER BY DATA_PEDIDO" 
	
	FWMsgRun(,{|| PLSQuery( cQuery, "SZ5TMP" )},,'Verificando informa??es...') 
	
	If SZ5TMP->(Eof()) 
		MsgInfo('não foi poss?vel encontrar registros com os par?metros informados.') 
		SZ5TMP->( DbCloseArea() ) 
		Return(.F.) 
	EndIf 
	
	ProcRegua(0) 
	
	While SZ5TMP->( !Eof() ) 
		
		
		//Faz distribui??o e monitora a quantidade de thread em execu??o 
		BEGIN SEQUENCE  
		
		nThread := 0 
		aUsers 	:= Getuserinfoarray() 
		aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA020B",nThread++,nil )  }) 
		
		END SEQUENCE 
		
		ErrorBlock(bOldBlock) 
	
		cErrorMsg := U_GetProcError() 
		If !empty(cErrorMsg) 
		cMensagem := "Inconsist?ncia no Processamento: "+CRLF+cErrorMsg 
		conout(cMensagem + " "+TIme()+" Pedido ") 
		EndIf 
	
		
		//Limita a quantidade de Threads. 
		If nThread <= 10 
			
			nContador := 0 
			aPedidos  := {} 
			
			//Envio para processamento de 10 em 10 pedidos. 
			While SZ5TMP->( !Eof() ) .And. nContador <= 100 
				
				nQtd++ 
				//IncProc( "Processo " + AllTrim(Str(nQtd)) + " de " + AllTrim(Str(nTotSZ5)) + " --> " + SZ5->Z5_PEDGAR ) 
				IncProc( "Processo " + AllTrim(Str(nQtd)) + " --> Pedido GAR: " + SZ5TMP->PEDIDO_GAR + " --> Pedido SITE: " + SZ5TMP->PEDIDO_SITE ) 
				ProcessMessage() 
				
				//Se não estiver vazio adiciono no array 
				If !Empty(SZ5TMP->R_E_C_N_O_) 
					Aadd(aPedidos,{SZ5TMP->R_E_C_N_O_}) 
					nContador += 1 
				EndIf 
				
				//Pulo para a pr?xima linha. 
				SZ5TMP->(DbSkip()) 
			EndDo 
			
			//Envio o conte?do para Thread se o array for maior que um 
			If Len(aPedidos) > 0 
				nTotThread += 1 
				StartJob("U_CRPA020B",GetEnvServer(),.F.,'01','02',aPedidos,"CRPA020",cUserName) 
				//U_CRPA020B('01','02',aPedidos,"CRPA020",cUserName) 
				aPedidos := {} 
			EndIf 
		Else 
		
			While nThread>10 
				sleep(30000) 
				cErrorMsg := "" 
				bOldBlock := ErrorBlock({|e| U_ProcError(e) }) 
				BEGIN SEQUENCE       
				
				nThread := 0 
				aUsers 	:= Getuserinfoarray() 
				aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA020B",nThread++,nil )  }) 
						
				END SEQUENCE 
				ErrorBlock(bOldBlock) 
				cErrorMsg := U_GetProcError() 
				If !empty(cErrorMsg) 
				cMensagem := "Inconsist?ncia no Faturamento: "+CRLF+cErrorMsg 
				conout(cMensagem + " "+TIme()+" Pedido ") 
				EndIf 
			EndDo 
			
		EndIf 
		
		If nTotThread > 10                            
			conout( "[CERFATPED] " + "[" + DtoC( Date() ) + " " + Time() + "] - Processou 10 threads - Libera memoria" ) 
			DelClassIntf() 
			nTotThread := 0 
		EndIf 
		
	EndDo 
	
	//Envio o conte?do para Thread se o array for maior que zero 
	If Len(aPedidos) > 0 
		StartJob("U_CRPA020B",GetEnvServer(),.F.,'01','02',aPedidos,"CRPA020",cUserName) 
		aPedidos := {} 
	EndIf 
	
	SZ5TMP->( DbCloseArea() ) 
	
	MsgInfo("Lan?amentos conclu?dos com sucesso.") 
	
	If MsgYesNo("Deseja imprimir o log de c?lculo?") 
		U_CRP020Impr() 
	Endif 

Return(.F.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020GrvErro ? Autor ? Tatiana Pontes  ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Grava observacao do calculo de comissao no processo		  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/
Static Function CRP020GrvErro(cObsCom) 
	Begin Transaction 
	
	SZ5->( RecLock("SZ5",.F.) ) 
	SZ5->Z5_OBSCOM := cObsCom 
	SZ5->( MsUnLock() ) 
	
	If !Empty(cObsCom) 
		lLogErr	:= .T. 
	Endif 
	
	End Transaction 
Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? ImpCRPR01  ? Autor ? Tatiana Pontes 	   ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Relatorio de processos do GAR que nao geraram lancamento   ??? 
???          ? de remuneracao											  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/ 
 
Static Function ImpCRPR01(lEnd,wnrel,cString,nomeprog,Titulo) 
	Local nLi		:= 0			// Linha a ser impressa 
	Local nMax		:= 58			// Maximo de linhas suportada pelo relatorio 
	Local cbCont	:= 0			// Numero de Registros Processados 
	Local cbText	:= SPACE(10)	// Mensagem do Rodape 
	//	Local cCabec1	:= "Ped.GAR   Posto  Descricao Posto                 Produto GAR           Descricao Produto GAR                               Valor Soft.  Valor Hard.  Observa??o" 
	Local cCabec1	:= "Ped.GAR   Dt. Pedido  Dt.Emiss?o  Posto  Descricao Posto       Produto GAR           Descricao Produto GAR            Vl. Total   Vl. Soft.   Vl. Hard.  Observa??o" 
	Local cCabec2	:= "" 
	//  12345678  99/99/9999  99/99/9999  12345  12345678901234567890  12345678901234567890  123456789012345678901234567890  999,999.99  999,999.99  999,999.99  ---> PRODUTO DO ERP NAO LOCALIZADO NO CADASTRO DE DE/PARA COM PRODUTO GAR 
	//  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 
	//          10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220 
	
	//???????????????????????????????????????????????????????????????? 
	//? Declaracao de variaveis especificas para este relatorio	      ? 
	//????????????????????????????????????????????????????????????????? 
	
	Local cQuery	:= ""			// Armazena a expressao da query para top 
	Local nQtd		:= 0			// Contador da usuarios 
	Local Tamanho 	:= "G"			// P/M/G 
	
	//?????????????????????????????????????????????????????????????????????? 
	//? Variaveis para gerar arquivo de log em Excel					    ? 
	//??????????????????????????????????????????????????????????????????????? 
	
	Local cDirDocs  	:= MsDocPath() 
	Local cPath			:= "C:\EXCEL\" 
	Local cArquivo 		:= "CRPR01.CSV" 
	Local nX			:= 0 
	Local cLin 
	Local oExcelApp 
	Local cArqTxt 		:= "\"+cDirDocs+"\CRPR01.CSV" 
	Local nHdl    		:= MsfCreate(cDirDocs+"\"+cArquivo,0) 
	Local cEOL    		:= "CHR(13)+CHR(10)" 
	Local aCabExc		:= {} 
	
	//?????????????????????????????????????????????????????????????????????? 
	//? Pesquisa se existe o fechamento solicitado e o fechamento anterior  ? 
	//??????????????????????????????????????????????????????????????????????? 
	
	cQuery	:=	" Select SZ5.R_E_C_N_O_ " 
	cQuery	+=	" From   " +RetSqlName("SZ5")+ " SZ5 " 
	cQuery	+=	"        INNER JOIN " +RetSqlName("SZ3")+ " SZ3 " 
	cQuery	+=	"               ON SZ3.Z3_FILIAL = '" +xFilial("SZ3")+ "' " 
	cQuery	+=	"               AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS " 
	cQuery	+=	"               AND SZ3.D_E_L_E_T_ = ' ' " 
	If !Empty(MV_PAR03) 
		cQuery	+=	"               AND SZ3.Z3_CODAC = '" +MV_PAR03+ "' " 
	EndIf 
	cQuery	+=	" WHERE   SZ5.Z5_FILIAL = '" +xFilial("SZ5")+ "' " 
	cQuery	+=	"         AND SZ5.Z5_DATVER >= '" +DtoS(MV_PAR01)+ "' AND SZ5.Z5_DATVER <= '" +DtoS(MV_PAR02)+ "' " 
	cQuery	+=	"         AND SZ5.Z5_PEDGANT = ' ' " 
	cQuery	+=	"         AND SZ5.Z5_CODPOS >= '" +MV_PAR04+ "' AND SZ5.Z5_CODPOS <= '" +MV_PAR05+ "' " 
	cQuery	+=	"         AND SZ5.Z5_COMISS IN ('1',' ') " 
	cQuery	+=	"         AND (SZ5.Z5_OBSCOM <> 'OK' And SubStr(SZ5.Z5_OBSCOM,1,1) <> ' ' And SZ5.Z5_OBSCOM <> 'DELET') " 
	cQuery	:=	" UNION " 
	cQuery	:=	" Select SZ5.R_E_C_N_O_ " 
	cQuery	+=	" From   " +RetSqlName("SZ5")+ " SZ5 " 
	cQuery	+=	"        INNER JOIN " +RetSqlName("SZ3")+ " SZ3 " 
	cQuery	+=	"               ON SZ3.Z3_FILIAL = '" +xFilial("SZ3")+ "' " 
	cQuery	+=	"               AND SZ3.Z3_CODGAR = SZ5.Z5_CODPOS " 
	cQuery	+=	"               AND SZ3.D_E_L_E_T_ = ' ' " 
	If !Empty(MV_PAR03) 
		cQuery	+=	"               AND SZ3.Z3_CODAC = '" +MV_PAR03+ "' " 
	EndIf 
	cQuery	+=	" WHERE   SZ5.Z5_FILIAL = '" +xFilial("SZ5")+ "' " 
	cQuery	+=	"         AND SZ5.Z5_DATEMIS >= '" +DtoS(MV_PAR01)+ "' AND SZ5.Z5_DATEMIS <= '" +DtoS(MV_PAR02)+ "' " 
	cQuery	+=	"         AND SZ5.Z5_PEDGANT = ' ' " 
	cQuery	+=	"         AND SZ5.Z5_CODPOS >= '" +MV_PAR04+ "' AND SZ5.Z5_CODPOS <= '" +MV_PAR05+ "' " 
	cQuery	+=	"         AND SZ5.Z5_COMISS = '2' " 
	cQuery	+=	"         AND (SZ5.Z5_OBSCOM <> 'OK' And SubStr(SZ5.Z5_OBSCOM,1,1) <> ' ') " 
	
	PLSQuery( cQuery, "SZ5TMP" ) 
	
	If mv_par06 <> 1 
		
		SetRegua( SZ5->( RecCount() ) ) 
		
		SZ5->( DbSetOrder(1) ) 
		While SZ5TMP->( !Eof() ) 
			nQtd++ 
			IncRegua("Total de verifica??es " + AllTrim(Str(nQtd)) ) 
			ProcessMessage() 
			
			If lEnd 
				@Prow()+1,000 PSay "CANCELADO PELO OPERADOR" 
				Exit 
			Endif 
			
			//???????????????????????????????? 
			//? Considera filtro do usuario   ? 
			//????????????????????????????????? 
			
			If (!Empty(aReturn[7])) .AND. (!&(aReturn[7])) 
				SZ5TMP->( DbSkip() ) 
				Loop 
			Endif 
			
			SZ5->( DbGoTo( SZ5TMP->( R_E_C_N_O_ ) ) ) 
			
			TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho) 
			
			@ nLi,000		PSay PadR(SZ5->Z5_PEDGAR,8) 
			@ nLi,PCol()+2	PSay SZ5->Z5_DATPED 
			@ nLi,PCol()+4	PSay SZ5->Z5_DATVER 
			@ nLi,PCol()+4	PSay PadR(SZ5->Z5_CODPOS,5) 
			@ nLi,PCol()+2	PSay PadR(Upper(SZ5->Z5_DESPOS),20) 
			@ nLi,PCol()+2	PSay PadR(Upper(SZ5->Z5_PRODGAR),20) 
			@ nLi,PCol()+2	PSay PadR(SZ5->Z5_DESPRO,30) 
			@ nLi,PCol()+2	PSay SZ5->Z5_VALOR 					Picture("@E 999,999.99") 
			@ nLi,PCol()+2	PSay SZ5->Z5_VALORSW 				Picture("@E 999,999.99") 
			@ nLi,PCol()+2	PSay SZ5->Z5_VALORHW 				Picture("@E 999,999.99") 
			@ nLi,PCol()+2	PSay PadR(SZ5->Z5_OBSCOM,60) 
			
			SZ5TMP->( DbSkip() ) 
		End 
		
		SZ5TMP->( DbCloseArea() ) 
		
		If nLi == 0 
			TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho) 
			@ nLi+1,000 PSay "não h? informa?es para imprimir este relat?rio" 
		Endif 
		
		Roda(cbCont,cbText,Tamanho) 
		
		Set Device To Screen 
		If ( aReturn[5] = 1 ) 
			Set Printer To 
			dbCommitAll() 
			OurSpool(wnrel) 
		Endif 
		MS_FLUSH() 
		
	Else 
		
		//????????????????????????????????????? 
		//? Gera o arquivo Excel          	   ? 
		//?????????????????????????????????????? 
		
		// Cria Diretorio 
		MakeDir(Trim(cPath)) 
		
		Ferase( "C:\EXCEL\"+cArquivo ) 
		
		If File(cArquivo) .and. Ferase(cArquivo) == -1 
			MsgStop("não foi poss?vel abrir o arquivo CRPR010.CSV pois ele pode estar aberto por outro usu?rio.") 
			SZ5TMP->( DbCloseArea() ) 
			Return(.F.) 
		Endif 
		
		If Empty(cEOL) 
			cEOL := CHR(13)+CHR(10) 
		Else 
			cEOL := Trim(cEOL) 
			cEOL := &cEOL 
		Endif 
		
		If nHdl == -1 
			MsgAlert("O arquivo de nome "+cArqTxt+" não pode ser executado! Verifique os param?tros.","Aten??o!") 
			SZ5TMP->( DbCloseArea() ) 
			Return(.F.) 
		Endif 
		
		// Cabecalho 
		Aadd(aCabExc,"Ped.GAR") 
		Aadd(aCabExc,"Dt.Pedido") 
		Aadd(aCabExc,"Dt.Verificacao") 
		Aadd(aCabExc,"Posto") 
		Aadd(aCabExc,"Descricao Posto") 
		Aadd(aCabExc,"Cod. Agente") 
		Aadd(aCabExc,"Nome Agente") 
		Aadd(aCabExc,"Produto GAR") 
		Aadd(aCabExc,"Descricao Produto GAR") 
		Aadd(aCabExc,"Valor Total") 
		Aadd(aCabExc,"Valor Soft.") 
		Aadd(aCabExc,"Valor Hard.") 
		Aadd(aCabExc,"Observa??o") 
		
		cLin := "" 
		For nX := 1 to Len(aCabExc) 
			cLin += aCabExc[nX] 
			cLin += ";" 
		Next 
		cLin += cEOL // Pula Linha 
		
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin) 
			MsgAlert("Ocorreu um erro na grava??o do arquivo.") 
			fClose(nHdl) 
			Return 
		Endif 
		
		nTamCabEx := Len(aCabExc) 
		
		SetRegua( SZ5->( RecCount() ) ) 
		
		SZ5->( DbSetOrder(1) ) 
		While SZ5TMP->( !Eof() ) 
			
			nQtd++ 
			IncRegua("Total de Verifica??es " + AllTrim(Str(nQtd)) ) 
			ProcessMessage() 
			
			SZ5->( DbGoTo( SZ5TMP->( R_E_C_N_O_ ) ) ) 
			
			aLinha := Array(nTamCabEx)	// cria linha vazia com tamanho do cabecalho 
			
			aLinha[1]	:= SZ5->Z5_PEDGAR 
			aLinha[2]	:= DTOC(SZ5->Z5_DATPED) 
			aLinha[3]	:= DTOC(SZ5->Z5_DATVER) 
			aLinha[4]	:= SZ5->Z5_CODPOS 
			aLinha[5]	:= SZ5->Z5_DESPOS 
			aLinha[6]	:= SZ5->Z5_CODAGE 
			aLinha[7]	:= SZ5->Z5_NOMAGE 
			aLinha[8]	:= SZ5->Z5_PRODGAR 
			aLinha[9]	:= SZ5->Z5_DESPRO 
			aLinha[10]	:= Transform(SZ5->Z5_VALOR,"@E 999,999.99") 
			aLinha[11]	:= Transform(SZ5->Z5_VALORSW,"@E 999,999.99") 
			aLinha[12]	:= Transform(SZ5->Z5_VALORHW,"@E 999,999.99") 
			aLinha[13]	:= SZ5->Z5_OBSCOM 
			
			SZ5TMP->( DbSkip() ) 
			
			cLin := "" 
			For nX := 1 to Len(aLinha) 
				cLin += aLinha[nX] 
				cLin += ";" 
			Next 
			cLin += cEOL //ULTIMO ITEM 
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin) 
				MsgAlert("Ocorreu um erro na grava??o do arquivo.") 
				fClose(nHdl) 
				Return 
			Endif 
			
		End 
		
		SZ5TMP->( DbCloseArea() ) 
		
		fClose(nHdl) 
		
		CpyS2T( cDirDocs+"\"+cArquivo, cPath, .T. ) 
		
		If ! ApOleClient( 'MsExcel' ) 
			ShellExecute("open",cPath+cArquivo,"","", 1 ) 
			Return 
		EndIf 
		
		oExcelApp := MsExcel():New() 
		oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha 
		oExcelApp:SetVisible(.T.) 
		
		If MsgYesNo("Deseja fechar a planilha do excel?") 
			oExcelApp:Quit() 
			oExcelApp:Destroy() 
		EndIf 
		
	Endif 
Return(.T.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Grv  ? Autor ? Tatiana Pontes 	   ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Grava usuario que alterou o registro        				  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/
Static Function CRP020Grv() 
	SZ6->( RecLock("SZ6",.F.) ) 
	SZ6->Z6_DTALTER := dDataBase 
	SZ6->Z6_USUARIO := Alltrim(cUserName)+" - "+DtoC(dDataBase)+" - "+Time()+" - ALTERADO" 
	SZ6->( MsUnLock() ) 
Return(.F.) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? CRP020Ok   ? Autor ? Tatiana Pontes 	   ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Grava motivo de alteracao do registro       				  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/
Static Function CRP020Ok() 
	Local _lRet	:= .T. 
	
	If Empty(M->Z6_MOTALT) 
		_lRet	:= .F. 
		MsgStop("Preencha o campo motivo da Alteração antes de concluir.") 
	Endif 
Return(_lRet) 
 
/* 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
???????????????????????????????????????????????????????????????????????????? 
???Programa  ? AjustaSX1 ? Autor ? Tatiana Pontes 	   ? Data ? 10/07/12  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Desc.     ? Cria grupo de perguntas									  ??? 
???????????????????????????????????????????????????????????????????????????? 
???Uso       ? Certisign                                                  ??? 
???????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
????????????????????????????????????????????????????????????????????????????? 
*/
Static Function AjustaSX1(cPerg) 
	Local cKey 		:= "" 
	Local aRegs		:= {} 
	Local aHelpEng 	:= {} 
	Local aHelpPor 	:= {} 
	Local aHelpSpa 	:= {} 
	
	//SX1 CERTISIGN 
	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVariavl,cTipo,nTamanho,nDecimal,nPresel,cGSC,cValid,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cVar02,cDef02,cDefSpa2,cDefEng2,cCnt02,cVar03,cDef03,cDefSpa3,cDefEng3,cCnt03,cVar04,cDef04,cDefSpa4,cDefEng4,cCnt04,cVar05,cDef05,cDefSpa5,cDefEng5,cCnt05,cF3,cPyme,cGrpSxg,cHelp,cPicture,cIdfil) 
	
	Aadd(aRegs,{cPerg,"01","Data Inicial?"		,"","","MV_CH1","D",8,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","","",""}) 
	Aadd(aRegs,{cPerg,"02","Data Final?"		,"","","MV_CH2","D",8,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","","",""}) 
	Aadd(aRegs,{cPerg,"03","Grupo/Rede?"		,"","","MV_CH3","C",3,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","SZA"	,"","","","",""}) 
	Aadd(aRegs,{cPerg,"04","Entidade Inicial?"	,"","","MV_CH4","C",6,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","SZ3_05","","","","",""}) 
	Aadd(aRegs,{cPerg,"05","Entidade Final?"	,"","","MV_CH5","C",6,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","SZ3_05","","","","",""}) 
	
	If cPerg == "CRPR01" 
		Aadd(aRegs,{cPerg,"06","Excel?"						,"","","MV_CH6","C",1,0,0,"C","","Mv_Par06","Sim","","","","","não","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	Else 
		Aadd(aRegs,{cPerg,"06","Conta Cert. Verificados?"	,"","","MV_CH6","C",1,0,0,"C","","Mv_Par06","Sim","","","","","não","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	Endif 
	
	If Len(aRegs) > 0 
		PlsVldPerg( aRegs ) 
	Endif 
	
	cKey     := "P.CRP02001." 
	aHelpEng := {} 
	aHelpPor := {} 
	aHelpSpa := {} 
	aAdd(aHelpEng,"") 
	aAdd(aHelpEng,"") 
	aAdd(aHelpPor,"Informe data") 
	aAdd(aHelpPor,"inicial") 
	aAdd(aHelpSpa,"") 
	aAdd(aHelpSpa,"") 
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 
	
	cKey     := "P.CRP02002." 
	aHelpEng := {} 
	aHelpPor := {} 
	aHelpSpa := {} 
	aAdd(aHelpEng,"") 
	aAdd(aHelpEng,"") 
	aAdd(aHelpPor,"Informe data") 
	aAdd(aHelpPor,"final") 
	aAdd(aHelpSpa,"") 
	aAdd(aHelpSpa,"") 
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 
	
	cKey     := "P.CRP02003." 
	aHelpEng := {} 
	aHelpPor := {} 
	aHelpSpa := {} 
	aAdd(aHelpEng,"") 
	aAdd(aHelpEng,"") 
	aAdd(aHelpPor,"Informe grupo de entidades (rede)") 
	aAdd(aHelpPor,"ou deixe em branco para todos") 
	aAdd(aHelpSpa,"") 
	aAdd(aHelpSpa,"") 
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 
	
	cKey     := "P.CRP02004." 
	aHelpEng := {} 
	aHelpPor := {} 
	aHelpSpa := {} 
	aAdd(aHelpEng,"") 
	aAdd(aHelpEng,"") 
	aAdd(aHelpPor,"Informe entidade") 
	aAdd(aHelpPor,"inicial") 
	aAdd(aHelpSpa,"") 
	aAdd(aHelpSpa,"") 
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 
	
	cKey     := "P.CRP02005." 
	aHelpEng := {} 
	aHelpPor := {} 
	aHelpSpa := {} 
	aAdd(aHelpEng,"") 
	aAdd(aHelpEng,"") 
	aAdd(aHelpPor,"Informe entidade") 
	aAdd(aHelpPor,"final") 
	aAdd(aHelpSpa,"") 
	aAdd(aHelpSpa,"") 
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 
	
	If cPerg == "CRPR01" 
		cKey     := "P.CRP02006." 
		aHelpEng := {} 
		aHelpPor := {} 
		aHelpSpa := {} 
		aAdd(aHelpEng,"") 
		aAdd(aHelpEng,"") 
		aAdd(aHelpPor,"Gera em Excel") 
		aAdd(aHelpPor,"relat?rio de log do c?lculo") 
		aAdd(aHelpSpa,"") 
		aAdd(aHelpSpa,"") 
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 
	Endif
Return(.T.) 
 
/*
Bruno Nunes - 02/06/2021
Esses parametros estão perdidos no meio do fonte?????
Comentei para não dar problema

//Efetua Ajustes Manualmente. 
// Verifica se os parametros informados pelo usuario sao validos 
If Mv_Par01 > Mv_Par02 
	MsgStop("Per?odo entre data inicial e final inv?lido. Altere os par?metros.") 
	Return(.F.) 
Endif 
 
// Verifica se o periodo solicitado nao esta fechado 
If SubStr(DtoS(Mv_Par01),1,6) < cRemPer .OR. SubStr(DtoS(Mv_Par02),1,6) < cRemPer 
	cLog := "não ? poss?vel gerar c?lculo no per?odo solicitado." + CRLF 
	cLog += "Os c?lculos somente podem ser gerados do per?odo " +  SubStr( cRemPer,5, 2 ) + "/" + Left( cRemPer, 4 ) + " em diante." 
	MsgStop(cLog) 
	Return(.F.) 
Endif 
*/
 
/* 
BEGINDOC 
//????????????????????????????????????????????????????????????????????????????????????????????o 
//?Os registros Base para Remuneração est?o na SZ5                                          ? 
//?Ent?o devemos filtrar todos os registros:                                                ? 
//?                                                                                         ? 
//?   -Data de verifica??o do certificado (Z5_DATVER)  no per?odo de apura??o               ? 
//?   -Data de emiss?o do certificado (Z5_DATEMIS) no per?odo de apura??o (quando renova??o)? 
//?   -Data de emiss?o do faturamento da entrega (Z5_EMISSAO)                               ? 
//?                                                                                         ? 
//?   -Rede de parceiros (rede)                                                             ? 
//?   -Entidade (postos de atendimento) (de/ate)                                            ? 
//????????????????????????????????????????????????????????????????????????????????????????????o 
ENDDOC 
*/ 
 
// Seleciona registros para geracao de remuneracao 
 
// Renato Ruy - 03/07/15 
//Fun??o para retornar a rede da campanha do contador 
Static Function CRR20RD(Desrede, cCCR) 
	Local cCodigoR 	:= "" 
	Local cDescRede := AllTrim(Upper(Desrede)) 
	
	DEFAULT cCCR := "" 
	
	cDescRede := AllTrim(StrTran(cDescRede,"CAMPANHA DO CONTADOR - ","")) 
	cDescRede := AllTrim(StrTran(cDescRede,"CAMAPNHA DO CONTADOR - ",""))                                                
	cDescRede := AllTrim(StrTran(cDescRede,"CAMAPANHA DO CONTADOR - ","")) 
	
	Do Case 
		Case cDescRede == "AC BR" .Or. cDescRede == "AR BR" 
			cCodigoR := "BR" 
		Case cDescRede == "AC FENACOR" 
			cCodigoR := "FENCR" 
		Case cDescRede == "AC SINCOR" 
			cCodigoR := "SIN" 
		Case cDescRede == "REDE FACESP" 
			cCodigoR := "FACES" 
		Case cDescRede == "AC BR CREDENCIADA" .Or. cDescRede == "REDE BR CREDENCIADA ESPECIAL" 
			If cCCR $ "071030/054471/054657/054933" 
				cCodigoR := "CRD" 
			Else 
				cCodigoR := "BRC" 
			EndIf 
		Case cDescRede == "REDE CREDENCIADA" 
			cCodigoR := "CRD" 
		Case cDescRede == "AC SINCOR ENTIDADE DE CLASSE" 
			cCodigoR := "SIN" 
		Case cDescRede == "AR POLOMASTHER 15%" 
			cCodigoR := "SIN" 
		Case cDescRede == "REDE SINCOR CREDENCIADA" 
			If cCCR $ "054403/054553/054924" 
				cCodigoR := "CRD" 
			Else 
				cCodigoR := "SIN" 
			EndIf 
		Case cDescRede == "AC BOA VISTA" 
			cCodigoR := "BV" 
		Case cDescRede == "AC SINCOR RIO" 
			cCodigoR := "SINRJ" 
		Case cDescRede == "AC NOTARIAL" 
			cCodigoR := "NOT" 
		Case cDescRede == "REDE CACB" 
			cCodigoR := "CACB" 
		Case cDescRede == "REDE CNC" 
			cCodigoR := "CNC" 
		Case cDescRede == "AC SINCOR RIO ENTIDADE DE CLASSE" 
			cCodigoR := "SINRJ" 
		Case cDescRede == "REDE CNC VENDAS PELO SITE" 
			cCodigoR := "CNC" 
		Case cDescRede $ "SAGE" 
		Case cDescRede == "REDE FACISC" 
			cCodigoR := "FACISC" 
		Otherwise 
			cCodigoR := " " 
	EndCase
Return (cCodigoR) 
 
//Renato Ruy - 20/07/15 
//Fun??o para processar em Job e em lote o calculo 
User Function CRPA020B(cEmpP,cFilP,aPedidos,cRotina,cNomeUsu,cPeriod,cTipMan,cTipEnt) 
	Local cCodPar		:= "" 
	Local cCodPosto		:= "" 
	Local cCodAR		:= "" 
	Local cCodAC		:= "" 
	Local cCodCanal		:= "" 
	Local cCodCanal2	:= "" 
	Local cCodFeder		:= "" 
	Local cCodCcr		:= "" 
	Local cDesCcr		:= "" 
	Local cQuebra		:= "" 
	Local aStrucSZ6		:= {} 
	Local aDadosSZ6		:= {} 
	Local nI			:= 0 
	Local nJ			:= 0 
	Local nK			:= 0 
	Local nX			:= 0 
	Local nZ			:= 0 
	Local cCampo		:= "" 
	Local nBaseSw		:= 0 
	Local nValSw		:= 0 
	Local aDadosBV	:= {} 
	Local cRegSw		:= 0 
	Local nBaseHw		:= 0 
	Local nValHw		:= 0 
	Local cRegHw		:= "" 
	Local cTipoGar		:= "" 
	Local cCalcRem		:= "" 
	Local nQtdReg		:= 0 
	Local cFxCodEnt		:= "" 
	Local cChaveSZ4		:= "" 
	Local cFaixa		:= "" 
	Local lProdConta	:= .F. 
	Local nValTot       := 0 
	Local nValTotHW     := 0 
	Local nValTotSW     := 0 
	Local nAbtCamH 	    := 0 
	Local nAbtCamS      := 0 
	Local nImpCamp		:= 0 
	Local cTipPar       := "" 
	Local cDesPar       := "" 
	Local nPorSfw		:= 0 
	Local nPorHdw		:= 0 
	Local nRecEnt		:= 0 
	Local cTipo			:= "" 
	Local lMidiaAvulsa  := .F. 
	Local cAbateCcrAC	:= "" //Vari?vel para gravar se abate CCR e GRUPO\Rede(AC) do Canal 1 e 2. 
	Local cAbateCamp	:= "" //Vari?vel para gravar se campanha do contator do Canal 1 e 2. 
	Local cCalcIFEN		:= "" //Variavel para armazena se calcula o produto IFEN. 
	Local cTiped		:= "" 
	Local nAbtAR  		:= 0 
	Local nAbtCart		:= 0 
	Local nAbtAC  		:= 0 
	Local nAbtImp 		:= 0 
	Local lCamRen		:= .T. 
	Local dDataIRenov   := "" 
	Local dDataFRenov   := "" 
	Local lProdCalc		:= .T. //Indica se efetua calculo para AC, Canal, Canal 2 e Remunera o dono do Produto. 
	Local cAcPropri		:= "" //Caso o produto seja especifico de uma AC, guarda entidade propriet?ria. 
	Local lNotarial		:= .T. 
	Local lTemHard		:= .F. 
	//Variaveis de controle de reembolso. 
	Local cDtReemb		:= "" 
	Local cReembIn		:= "" 
	Local aDadoRem		:= {} 
	Local nReembPg		:= 0 
	Local lFaixaCamp	:= .F. 
	Local aVlrPagos 	:= {0, 0, 0, 0, 0, 0} 
	Local lCalcCam		:= .F. 
	Local lProjTop		:= .F. 
	Local lNaoPagou		:= .T. 
	Local lOriCupom		:= .F. 
	Local lPagoProd		:= .T. 
	Local lTemVouc		:= .F. 
	Local cZera			:= "N" 
	Local nCountThrd	:= 0 
	Local cProMinc		:= "" 
	Local cObserva		:= "" 
	Local aAreaSZ4		:= {} 
	Local aStatus		:= {} 
	Local lVouPag		:= .F. 
	Local lProFunc		:= .F. 
	Local aAreaSZ3		:= {} 
	Local lFCSPCalc		:= .F. //Flag para permitir gravacao de Remuneração FACESP Provis?rio 
	Local nValBio		:= 0 
	Local aAreaZ5Vou	:= {} 
	Local lPgDupli		:= .F. 
	Local lPedNoRem		:= .F. 
	Local lDescred		:= .F. 
	Local lCalcAss		:= .F. 
	Local cCodPosOri	:= "" 
	Local nPedidos 
	Local cProdGAR		:= "" 
	Local lPedEcom		:= .F. //Identifica se eh pedido e-Commerce 
	Local cPostoAnt		:= "" 
	Local lBioCanal		:= .F. 
							
	Private lGerReem	:= .T. 
	Private lCNJ		:= .F. 
	Private lACJUS		:= .F. 
	Private nValReem	:= 0 
	Private nVlReemS	:= 0 
	Private nVlReemH	:= 0 
	Private cRemPer		:= "" 
	Private lLogErr		:= .F. 
	Private ltemFaixa   := .F. 
	Private lCalcSAGE	:= .F. 
	
	Default cPeriod		:= "" 
	Default cTipMan		:= "1" 
	Default cTipEnt		:= "0" 
	
	//Conout("cEmpAnt:" + cEmpAnt + " - cFilAnt: " + cFilAnt) 
	
	//Abre a conex?o com a empresa 
	RpcSetType(3) 
	RpcSetEnv("01","02") 
	
	dDataIRenov   := MV_PAR01 //Armazena data inicio para calculo da renovação 
	dDataFRenov   := MV_PAR02 //Armazena data fim para calculo da renovação 
	cRemPer		  := Iif(Empty(cPeriod),AllTrim(GetMV("MV_REMMES")),cPeriod) // PERIODO DE CALCULO EM ABERTO 
	cTipoGar	  := GetMV("MV_TIPGAR") // VERIFI;EMISSA;HWAVUL;ENTMID;CAMPCO;CLUBRE 
	aStrucSZ6	  := SZ6->( DbStruct() ) 
	
	Conout("[CRPA020B] "+Alltrim(Str(ThreadId()))+" Pedidos Recebidos "+Alltrim(Str(Len(aPedidos)))) 
	
	For nPedidos := 1 to Len(aPedidos) 
	
		Conout("[CRPA020B] " + cValToChar(aPedidos[nPedidos][1])) 
		
		nCountThrd++ 
		
		SZ5->( DbGoTo( aPedidos[nPedidos][1] ) ) 
		
		If SZ5->(Found()) 
			Conout("[CRPA020B] SZ5 posicionada") 
		EndIf 
		
		If Len(aPedidos[nPedidos]) > 1 
			cRemPer := aPedidos[nPedidos][2] 
		EndIf 
		
		Conout("[CRPA020B] "+Alltrim(Str(ThreadId()))+" processando "+Alltrim(Str(nCountThrd))+" de "+Alltrim(Str(Len(aPedidos)))+ " Recno "+Alltrim(Str(aPedidos[nPedidos][1])) ) 
		
		//Renato Ruy - 21/03/17 
		//Criacao de semaforo para evitar a duplicidade  
		sleep(Randomize( 1, 1000 )) 
		
		//Possibilita ao analista desabilitar o controle do semaforo 
		If Empty(SZ5->Z5_PEDGAR) .And. GetNewPar("MV_XREMBLQ",.T.) 
			If !LockByName("CRPA020"+SZ5->Z5_PEDSITE) 
				Conout("[CRPA020B] - Pedido Site: "+ SZ5->Z5_PEDSITE +" ja esta em processamento!") 
				CRPA020LOG(1,"Pedido Site ja esta em processamento!",{{'SZ5->Z5_PEDSITE',SZ5->Z5_PEDSITE}},'!LockByName("CRPA020"+SZ5->Z5_PEDSITE)',ProcLine(),cNomeUsu) 
				loop 
			Else 
				ConOut("Calculando Pedido Gar: " + SZ5->Z5_PEDSITE) 
			Endif 
		Elseif GetNewPar("MV_XREMBLQ",.T.) 
			If !LockByName("CRPA020"+SZ5->Z5_PEDGAR) 
				Conout("[CRPA020B] - Pedido Gar: "+ SZ5->Z5_PEDGAR +" ja esta em processamento!") 
				CRPA020LOG(1,"Pedido GAR ja esta em processamento!",{{'SZ5->Z5_PEDGAR',SZ5->Z5_PEDGAR}},'!LockByName("CRPA020"+SZ5->Z5_PEDGAR)',ProcLine(),cNomeUsu) 
				loop 
			Else 
				ConOut("Calculando Pedido Gar: " + SZ5->Z5_PEDGAR) 
			Endif 
		Endif 
		
		
		// Pesquisa se existe calculo anterior e limpa para recalcular // 
		lMidiaAvulsa := (SZ5->Z5_TIPO == 'ENTHAR') 
		
		//SZ5->( RecLock("SZ5",.F.) ) 
		//SZ5->Z5_OBSCOM := '' 
		//SZ5->( MsUnLock() ) 
		
		// Limpa campo de observacao do calculo de comissao na SZ5 
		CRP020GrvErro("") 
		
		/* 
		BEGINDOC 
		//???????????????????????????????????????????????????????????????????????????????? 
		//?Tipos de entidades existentes                                                  ? 
		//?                                                                               ? 
		//?1=Canal;                                                                       ? 
		//?2=AC;                                                                          ? 
		//?3=AR;                                                                          ? 
		//?4=Posto;                                                                       ? 
		//?5=Grupo;                                                                       ? 
		//?6=Rede                                                                         ? 
		//?7=Revendedor                                                                   ? 
		//?8=Ferderação                                                                    ? 
		//?9=CCR                                                                          ? 
		//????????????????????????????????????????????????????????????????????????????????? 
		ENDDOC 
		*/ 
		
		//Me Posiciono Novamente no posto para dar continuidade nas atividades 
		SZ3->(DbSetOrder(6))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR 
		If SZ3->(!MsSeek(xFilial("SZ3") + "4" + SZ5->Z5_CODPOS)) .OR. Empty(SZ5->Z5_PRODGAR) .OR. GetNewPar("MV_XATUREM", .T.) 
			Begin Sequence 
			// Busca os dados do pedido de GAR para atualizar o movimento 
			oWSObj := WSIntegracaoGARERPImplService():New() 
			IF oWSObj:findDadosPedido("erp","password123",Val(SZ5->Z5_PEDGAR)) 
				
				SZ5->(Reclock("SZ5")) 
				
				//Pedido GAR Anterior 
				SZ5->Z5_PEDGANT	:= Iif(ValType(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO) <> "U",AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO)),"") 
		
				//Certificado 
				If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTO) <> "U" 
					SZ5->Z5_PRODGAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTO) 
					SZ5->Z5_PRODUTO := Iif(Empty(SZ5->Z5_PRODUTO),GetAdvFval('PA8','PA8_CODMP8',XFILIAL('PA8')+ALLTRIM(SZ5->Z5_PRODGAR), 1,''), SZ5->Z5_PRODUTO) 
				EndIf 
		
				//DECRICAO do Certificado 
				If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC) <> "U" 
					SZ5->Z5_DESPRO := AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC) 
				EndIf 
		
				//CNPJ do Certificado 
				If ValType(oWSObj:OWSDADOSPEDIDO:NCNPJCERT) <> "U" 
					SZ5->Z5_CNPJ := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT)) 
					SZ5->Z5_CNPJCER := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT)) 
					SZ5->Z5_CNPJV	:= oWSObj:OWSDADOSPEDIDO:NCNPJCERT 
				EndIf 
		
				//Codigo do Parceiro 
				If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO) <> "U" 
					SZ5->Z5_CODPAR := Iif(SZ5->Z5_PROCRET != "M" .Or. empty( SZ5->Z5_CODPAR ), AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO)),SZ5->Z5_CODPAR) 
				EndIf 
				
				//Codigo do Parceiro 
				If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO) <> "U" 
					SZ5->Z5_NOMPAR := Iif(SZ5->Z5_PROCRET != "M" .Or. empty( SZ5->Z5_NOMPAR ),AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO),SZ5->Z5_NOMPAR) 
				EndIf 
		
				If ValType(oWSObj:OWSDADOSPEDIDO:cStatus) <> "U" 
					SZ5->Z5_STATUS := AllTrim(oWSObj:OWSDADOSPEDIDO:cStatus) 
				EndIf 
		
				If ValType(oWSObj:OWSDADOSPEDIDO:nstatusRevendedor) <> "U" 
					SZ5->Z5_BLQVEN := Iif(SZ5->Z5_PROCRET != "M",AllTrim(Str(oWSObj:OWSDADOSPEDIDO:nstatusRevendedor)),SZ5->Z5_BLQVEN) 
				EndIf 
		
				//Descricao AC do Pedido 
				If ValType(oWSObj:OWSDADOSPEDIDO:CACDESC) <> "U" 
					SZ5->Z5_DESCAC	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CACDESC) 
				EndIf 
		
				//Descricao AR de Pedido 
				If ValType(oWSObj:OWSDADOSPEDIDO:CARDESC) <> "U" 
					SZ5->Z5_DESCARP	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CARDESC) 
				EndIf 
		
				//Codigo AR de Pedido 
				If ValType(oWSObj:OWSDADOSPEDIDO:CARID) <> "U" 
					SZ5->Z5_CODARP := AllTrim(oWSObj:OWSDADOSPEDIDO:CARID) 
				EndIf 
		
				//Deve ser a AR de VERIFICACAO 
				//Descricao AR de Validacao 
				If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC) <> "U" 
					SZ5->Z5_DESCAR	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC) 
				EndIf 
		
				//Deve ser a AR de VERIFICACAO 
				//Codigo AR de Validacao 
				If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO) <> "U" 
					SZ5->Z5_CODAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO) 
				EndIf 
		
				//Data de Emissao do Pedido GAR 
				If ValType(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO) <> "U" 
					SZ5->Z5_DATPED := Iif(Empty(SZ5->Z5_DATPED),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO),1,10)),SZ5->Z5_DATPED) 
				EndIf 
		
				//Data da Validacao 
				If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO) <> "U" 
					SZ5->Z5_DATVAL := Iif(Empty(SZ5->Z5_DATVAL),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO),1,10)),SZ5->Z5_DATVAL) 
				EndIf 
		
				If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO) <> "U" 
					SZ5->Z5_DATVER := Iif(Empty(SZ5->Z5_DATVER),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO),1,10)),SZ5->Z5_DATVER) 
				EndIf 
		
				//Data de Emissao do Pedido GAR 
				If ValType(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO) <> "U" 
					SZ5->Z5_DATEMIS := CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO),1,10)) 
				EndIf 
		
				//Grupo 
				If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPO) <> "U" 
					SZ5->Z5_GRUPO := AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPO) 
				EndIf 
		
				//Descricao do Grupo 
				If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO) <> "U" 
					SZ5->Z5_DESGRU := AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO) 
				EndIf 
		
				//Deve ser o Posto de VERIFICACAO 
				//Descricao do Posto de Validação 
				If ValType(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC) <> "U" 
					SZ5->Z5_DESPOS	:= Iif(Empty(SZ5->Z5_DESPOS),AllTrim(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC),SZ5->Z5_DESPOS) 
				EndIf 
		
				//Codigo do posto de validacao 
				If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID) <> "U" 
					SZ5->Z5_CODPOS	:= Iif(Empty(SZ5->Z5_CODPOS),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID)),SZ5->Z5_CODPOS) 
				EndIf 
		
				If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID) <> "U" 
					SZ5->Z5_POSVER	:= Iif(Empty(SZ5->Z5_POSVER),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID)),SZ5->Z5_POSVER) 
				EndIf 
		
				//Rede 
				If ValType(oWSObj:OWSDADOSPEDIDO:CREDE) <> "U" 
					SZ5->Z5_REDE	:= Iif(Empty(SZ5->Z5_REDE),AllTrim(oWSObj:OWSDADOSPEDIDO:CREDE),SZ5->Z5_REDE) 
				EndIf 
		
				//Codigo do Revendedor 
				If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR) <> "U" 
					SZ5->Z5_CODVEND := Iif(SZ5->Z5_PROCRET != "M" .Or. empty( SZ5->Z5_CODVEND ),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR)),SZ5->Z5_CODVEND) 
				EndIf 
		
				//Nome do revendedor 
				If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR) <> "U"  
					SZ5->Z5_NOMVEND := Iif(SZ5->Z5_PROCRET != "M" .Or. empty( SZ5->Z5_NOMVEND ),AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR),SZ5->Z5_NOMVEND) 
				EndIf 
		
				//Comiss?o hardware do parceiro 
				If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW) <> "U" 
					SZ5->Z5_COMHW := oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW 
				EndIf 
		
				//Comiss?o software do parceiro 
				If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW) <> "U" 
					SZ5->Z5_COMSW := Iif(SZ5->Z5_PROCRET != "M", oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW, SZ5->Z5_COMSW) 
				EndIf 
		
				//Descrição da Rede do Parceiro e se faz parte de campanha. 
				If ValType(oWSObj:OWSDADOSPEDIDO:cdescricaoRedeParceiro) <> "U" 
					SZ5->Z5_DESREDE := Iif(SZ5->Z5_PROCRET != "M" .Or. empty(SZ5->Z5_DESREDE), AllTrim(oWSObj:OWSDADOSPEDIDO:cdescricaoRedeParceiro),SZ5->Z5_DESREDE) 
				EndIf 
		
				//CPF do Agente de Validacao 
				If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO) <> "U" 
					SZ5->Z5_CPFAGE	:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO)) 
				EndIf 
		
				If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO) <> "U" 
					SZ5->Z5_AGVER	:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO)) 
				EndIf 
		
				//CPF do Titular do Certificado 
				If ValType(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR) <> "U" 
					SZ5->Z5_CPFT := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR)) 
				EndIf 
		
				//Email do titular 
				If ValType(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR) <> "U" 
					SZ5->Z5_EMAIL := AllTrim(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR) 
				EndIf 
		
				//Nome do Agente de Validação 
				If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO) <> "U" 
					SZ5->Z5_NOMAGE	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO) 
				EndIf 
		
				If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO) <> "U" 
					SZ5->Z5_NOAGVER	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO) 
				EndIf 
		
				//Nome do Titular do Certificado 
				If ValType(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR) <> "U" 
					SZ5->Z5_NTITULA	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR) 
				EndIf 
		
				If ValType(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT) <> "U" 
					SZ5->Z5_RSVALID	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT) 
				EndIf 
				
				
				If !EMPTY(SZ5->Z5_DATEMIS) 
					SZ5->Z5_FLAGA := "E" 
				ElseIf !EMPTY(SZ5->Z5_DATVER) 
					SZ5->Z5_FLAGA := "A" 
				EndIf 
				
				SZ5->(MsUnlock()) 
				
				//conout("Pedido GAR "+Alltrim(SZ5->Z5_PEDGAR)+" atualizado com sucesso") 
				
			Else 
				Conout("Erro ao conectar com WS IntegracaoERP. Pedido GAR " + Alltrim(SZ5->Z5_PEDGAR) + " não atualizado") 
			Endif 
			
			DelClassIntF() 
			End Sequence 
			
			//Yuri Volpe - 30/04/2019 
			//2019042410001698 - Remuneração SAGE Combo Emissor+Certificado	 
			lCalcSAGE := (AllTrim(SZ5->Z5_PRODGAR) == "SRFA1PJEMISSORSAGEHV5" .And. !Empty(SZ5->Z5_DATEMIS))		 
			
			cPostoAnt := "" 
			If Empty(SZ5->Z5_CODPOS) 
				
				/*If !Empty(SZ5->Z5_PEDGANT) 
					aAreaZ5Ped := SZ5->(GetArea()) 
					If SZ5->(dbSeek(xFilial("SZ5") + SZ5->Z5_PEDGANT)) 
						cPostoAnt := SZ5->Z5_CODPOS 
					EndIf 
					RestArea(aAreaZ5Ped) 
				EndIf*/ 
				
				If Empty(cPostoAnt) 
					ConOut("O pedido: "+SZ5->Z5_PEDGAR+" não tem o posto vinculado!") 
					CRPA020LOG(1,"O pedido não tem o posto vinculado!",{{'SZ5->Z5_CODPOS',SZ5->Z5_CODPOS}},'Empty(SZ5->Z5_CODPOS)',ProcLine(),cNomeUsu) 
					UnLockByName("CRPA020"+SZ5->Z5_PEDGAR)		 
					Loop 
				EndIf 
			Endif 
			
			cCodPosto	:= SZ5->Z5_CODPOS  //Posto 
			cCodCCR		:= ""    //C?digo da entidade CCRComiss?o que tem a regra de Remuneração do posto (amarrado ao posto) 
			cDesCcr		:= "" 
			cCodAC		:= ""    //C?digo do Grupo/Rede que deve ser remunerado (amarrado ao posto) 
			cCodCanal   := ""    //C?digo do Canal   a que deve ser remunerado (amarrado ao Grupo/Rede que est? amarrado ao posto) 
			cCodCanal2  := ""    //C?digo do Canal 2 a que deve ser remunerado (amarrado ao Grupo/Rede que est? amarrado ao posto) 
			cCodFeder   := ""    //C?digo da Ferderação que dever ser remunerada (amarrado ao posto) 
			cCodParc	:= SZ5->Z5_CODPAR  //Parceiro Revendedor que deve ser remunerado (- Buscar c?digo no cadastro de parceiros - não est? amarrado ao posto) 
			cTipPar     := "" 
			cCodPar     := "" 
			cDesPar     := "" 
			cAcPropri   := "" 
			lDescred	:= .F. 
			
			//Renato Ruy - 14/09/2017 
			//Busca o produto apos consultar o gar 
			//O sistema nao estava calculando o valor de comissao, como nao existia produto. 
			lTemHard := .F. 
			lPedEcom := .F. 
			If !(lMidiaAvulsa) 
			
				/* 
					Tratamento para pedidos e-Commerce com Software 
					e M?dia avulsa. O campo C6_XSKU definir? um combo  
					a ser utilizado para pagamento da m?dia 
					O produto existe na PA8 e na SG1. 
					Yuri Volpe - 09.04.2020 
				*/ 
				dbSelectArea("SC6") 
				SC6->(dbOrderNickname("NUMPEDGAR")) 
				If SC6->(dbSeek(xFilial("SC6") + SZ5->Z5_PEDGAR)) 
					
					//CERA3PFR301   
					//Verifica se o pedido ? e-Commercer   
					If !Empty(SC6->C6_XNPECOM) 
						//Garante que não ? um Kit Combo ou Combo KT convencional do Protheus/GAR 
						If !(Substr(SC6->C6_XSKU,1,2) $ "CB/KT") 
							cProdGAR 	:= SC6->C6_XSKU 
							cProdServ 	:= SC6->C6_PROGAR 
							lPedEcom	:= .T. 
						EndIf 
					Else 
						cProdGAR  := SZ5->Z5_PRODGAR 
						cProdServ := SZ5->Z5_PRODUTO 
					EndIf 
				Else 
					cProdGAR := SZ5->Z5_PRODGAR
					cProdServ := SZ5->Z5_PRODUTO
				EndIf 
					
				//Identifica a categoria do produto para posicionamento na tabela de regras de c?lculo da entidade 
				PA8->( DbSetOrder(1) )		// PA8_FILIAL + PA8_CODBPG 
				lFoundPA8 := PA8->( MsSeek( xFilial("PA8") + cProdGAR ) ) 
				
				If !lFoundPA8 
					lFoundPA8 := PA8->( MsSeek( xFilial("PA8") + cProdServ ) ) 
				EndIf 
				
				If !lFoundPA8 
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> PRODUTO NAO LOCALIZADO NO CADASTRO DE CLASSIFICA??O DE PRODUTOS: " + AllTrim(SZ5->Z5_PRODGAR) ) 
					cCatProd :='NE' //não encontrado 
				EndIf
					
				SG1->(DbsetOrder(1)) 
				If SG1->(DbSeek( xFilial("SG1") + PA8->PA8_CODMP8)) 
					lTemHard := .T. 
				EndIf 
				
				If !lTemHard 
					If Substr(cProdGAR,1,2) == "KT" 
						lTemHard := .T. 
					EndIf 
				EndIf 

				If Empty(PA8->PA8_CATPRO) .And. Substr(cProdGar,1,3) == "CER" 
					If PA8->(dbSeek(xFilial("PA8") + cProdServ)) 
						cCatProd := PA8->PA8_CATPRO 
					Else 
						cCatProd := "01" 
					EndIf 
				ElseIf Empty(PA8->PA8_CATPRO) 
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> PRODUTO NAO CLASSIFICADO PARA REMUNERACAO DE PARCEIROS: " + AllTrim(PA8->PA8_CODBPG) ) 
					cCatProd :='01' //não encontrado 
				ELSE 
					cCatProd := PA8->PA8_CATPRO 
				Endif 
				//Verifica se deve realizar contagem do produto para faixa de Remuneração. 
				If PA8->PA8_CONCER == "1" 
					lProdConta := .T. 
				Endif
			Else 
				cCatProd:='01' //Produtos Certisign 
			Endif 
			
			IF SZ3->(!MsSeek(xFilial("SZ3") + "4" + SZ5->Z5_CODPOS)) 
				
				//Chamo o webservice para criar o posto. 
				CRPA020Q(SZ5->Z5_CODPOS) 
				
				//Se não gerou posto, gravo log e gero o registro no calculo. 
				IF SZ3->(!MsSeek(xFilial("SZ3") + "4" + SZ5->Z5_CODPOS)) 
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> não FOI LOCALIZADO O POSTO NO CADASTRO DE ENTIDADE PELO C?DIGO " + SZ5->Z5_CODPOS) 
				EndIf 
		
			Endif 
		EndIf 
		
		
		//Me Posiciono Novamente no posto para dar continuidade nas atividades 
		SZ3->(DbSetOrder(6))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR 
		SZ3->(!MsSeek(xFilial("SZ3") + "4" + cCodPosto)) 
		
		//Verifica se a Descrição da entidade est? divergente do GAR e altera 
		//If AllTrim(SZ3->Z3_DESENT) != AllTrim(SZ5->Z5_DESPOS) .And. !Empty(SZ5->Z5_DESPOS) 
		//	RecLock("SZ3", .F.) 
		//		SZ3->Z3_DESENT := SZ5->Z5_DESPOS 
		//	SZ3->(MsUnlock()) 
		//EndIf 
		
		//Identifica o c?digo CCR de comiss?o amarrado ao posto 
		cCodCCR	:= SZ3->Z3_CODCCR			//Identifica a Ferderação vinculada ao posto ou CCR 
		cCodAr	:= SZ3->Z3_CODAR 			//AR associado ao posto 
		cQuebra	:= SZ3->Z3_QUEBRA			//2-CARTORIO OU 1=CCR 
		
		If Empty(SZ3->Z3_CODCCR) 
			cCodFeder	:= SZ3->Z3_CODFED			//Ferderação. Entidade politica associada ao posto de atendimento 
			cCodAC		:= SZ3->Z3_CODAC			//Grupo/Rede. Entidade que agrupa v?rios postos de redes GAR. 
			cCodCanal	:= SZ3->Z3_CODCAN 		//Canal  associado ao posto 
			cCodCanal2	:= SZ3->Z3_CODCAN2		//Canal2 associado ao posto 
			lDescred	:= SZ3->Z3_DESCRED == "S" 
		Else 
			aAreaSZ3 := SZ3->(GetArea()) 
			SZ3->(DbSetOrder(1)) 
			SZ3->(MsSeek(xFilial("SZ3") + cCodCCR)) 
			cDesCcr	:= SZ3->Z3_DESENT 
			cCodFeder	:= SZ3->Z3_CODFED			//Ferderação. Entidade politica associada ao posto de atendimento 
			cCodAC		:= SZ3->Z3_CODAC			//Grupo/Rede. Entidade que agrupa v?rios postos de redes GAR. 
			cCodCanal	:= SZ3->Z3_CODCAN 		//Canal  associado ao posto 
			cCodCanal2	:= SZ3->Z3_CODCAN2		//Canal2 associado ao posto 
			lDescred	:= SZ3->Z3_DESCRED == "S" 
			RestArea(aAreaSZ3) 
		Endif 
		
		//Yuri Volpe - 30/11/2018 
		//OTRS 2018112610000585 - Permitir que pedidos IFEN sejam recalculados mesmo ap?s integra??o (Removido do fonte) 
		//Yuri Volpe - 11/03/2019 
		//Melhoria - Possibilitar o recalculo do Parceiro, mesmo depois de integrado ao Portal 
		//Yuri Volpe - 16/04/2019 
		//Melhoria -  
		//Renato Ruy - 22/03/2018 
		//Validacao para bloquear recalculo de pedidos para integra??o com o Portal da Rede. 
		ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo) 
		If ZZG->(DbSeek(xFilial("ZZG")+AllTrim(cRemPer)+cCodCCR+"1")) .And. !Empty(cCodCCR) 
			/*RecLock("ZZG",.F.) 
				ZZG->ZZG_ATIVO := "2" 
			ZZG->(MsUnlock())*/ 
			ConOut("Pedido ja integrado com o portal da rede! Planilha atual desativada.") 
			/*Loop 
			UnLockByName("CRPA020"+SZ5->Z5_PEDGAR)*/ 
		EndIf 
		
		If ZZG->(DbSeek(xFilial("ZZG")+AllTrim(cRemPer)+cCodAC+"1")) .And. !Empty(cCodAC) 
			/*RecLock("ZZG",.F.) 
				ZZG->ZZG_ATIVO := "2" 
			ZZG->(MsUnlock())*/	 
			ConOut("Pedido ja integrado com o portal da rede! Planilha atual desativada.") 
			/*Loop 
			UnLockByName("CRPA020"+SZ5->Z5_PEDGAR)*/ 
		EndIf 
		
		If ZZG->(DbSeek(xFilial("ZZG")+AllTrim(cRemPer)+cCodCanal+"1")) .And. !Empty(cCodCanal) 
			/*RecLock("ZZG",.F.) 
				ZZG->ZZG_ATIVO := "2" 
			ZZG->(MsUnlock())*/	 
			ConOut("Pedido ja integrado com o portal da rede! Planilha atual desativada.") 
			/*Loop 
			UnLockByName("CRPA020"+SZ5->Z5_PEDGAR)*/ 
		Endif 
			
		If !(lMidiaAvulsa) .And. !Empty(SZ5->Z5_PEDGAR) 
			SZ6->( DbSetOrder(3) ) // Z6_FILIAL + Z6_PEDGAR + Z6_TIPO 
			If SZ6->( MsSeek( xFilial("SZ6") + SZ5->Z5_PEDGAR) ) 
				While	SZ6->( !Eof() ) .AND.; 
					SZ6->Z6_FILIAL == xFilial("SZ6") .AND.; 
					SZ6->Z6_PEDGAR == SZ5->Z5_PEDGAR 
					
					If AllTrim(SZ6->Z6_PERIODO) == AllTrim(cRemPer) .And. (Iif(cTipEnt == "0",.T.,AllTrim(SZ6->Z6_TPENTID) == cTipEnt) .Or.; 
						(cTipEnt == "2" .And. AllTrim(SZ6->Z6_TPENTID) == "1")) 
						SZ6->( RecLock("SZ6",.F.) ) 
						SZ6->( DbDelete() ) 
						SZ6->( MsUnLock() ) 
					EndIf 
					
					SZ6->( DbSkip() ) 
				End 
				
			EndIf 
		ELSE 
			//Renato Ruy - 13/11/2017 
			//Grava nome do cliente para pedido site. 
			//Busca informa??o no pedido 
			SC5->(DbOrderNickName("PEDSITE")) 
			If SC5->(DbSeek( xFilial("SC5")+AllTrim(SZ5->Z5_PEDSITE) )) .And. !Empty(SZ5->Z5_PEDSITE)  
				//Se posiciona no cadastro do cliente 
				SA1->(DbSetOrder(1)) 
				If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE)) 
					//Grava o nome do cliente 
					RecLock("SZ5",.F.) 
						SZ5->Z5_NTITULA := SA1->A1_NOME 
					SZ5->(MsUnlock()) 
				Endif 
			Endif 
			
			SZ6->( DbSetOrder(4) ) // Z6_FILIAL + Z6_PEDSITE + Z6_TIPO 
			If SZ6->( MsSeek( xFilial("SZ6") + SZ5->Z5_PEDSITE) ) 
				
				While AllTrim(SZ5->Z5_PEDSITE) == AllTrim(SZ6->Z6_PEDSITE) 
					If AllTrim(SZ5->Z5_PRODGAR) == AllTrim(SZ6->Z6_PRODUTO) .And. AllTrim(SZ6->Z6_PERIODO) == AllTrim(cRemPer) .And.; 
						(Iif(cTipEnt == "0",.T.,AllTrim(SZ6->Z6_TPENTID) == cTipEnt) .Or. (cTipEnt == "2" .And. AllTrim(SZ6->Z6_TPENTID) == "1")) 
						RecLock("SZ6",.F.) 
						SZ6->(dbDelete()) 
						SZ6->(MsUnLock()) 
					EndIf 
					SZ6->(DbSkip()) 
				EndDo 
			EndIf 
		Endif 
		
		If AllTrim(SZ5->Z5_CODAC) == "NAOREM" 	.OR. ;
			"TESTE" $ UPPER(SZ5->Z5_DESGRU) 	.OR. ;
			!Alltrim(SZ5->Z5_TIPO) $ cTipoGar 	.OR. ; 
			(Empty(SZ5->Z5_PEDGANT) .And. Empty(SZ5->Z5_PEDSITE) .And. SZ5->Z5_DATVAL <= CtoD("31/12/12"))
			//#TODO precisa melhorar essa condição, só fiz para calcular a remuneração - Bruno Nunes 07/07/2021
			if !( "TESTEMUNHA" $ UPPER(SZ5->Z5_DESGRU) )
				CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> PEDIDO IGNORADO ") 
					//Gravacao de Log 
					CRPA020LOG(1,"Pedido não ? remuner?vel",; 
							{{'SZ5->Z5_CODAC',SZ5->Z5_CODAC},{'SZ5->Z5_DESGRU',SZ5->Z5_DESGRU},{'SZ5->Z5_TIPO',SZ5->Z5_TIPO},{'cTipoGar',cTipoGar},{'SZ5->Z5_PEDGANT',SZ5->Z5_PEDGANT},{'SZ5->Z5_PEDSITE',SZ5->Z5_PEDSITE},{'SZ5->Z5_DATVAL',SZ5->Z5_DATVAL}},; 
							'AllTrim(SZ5->Z5_CODAC) == "NAOREM" .OR. "TESTE" $ UPPER(SZ5->Z5_DESGRU) .OR. !Alltrim(SZ5->Z5_TIPO) $ cTipoGar .OR. (Empty(SZ5->Z5_PEDGANT) .And. Empty(SZ5->Z5_PEDSITE) .And. SZ5->Z5_DATVAL <= CtoD("31/12/12"))',; 
							ProcLine(),cNomeUsu) 
				Loop 
				UnLockByName("CRPA020"+SZ5->Z5_PEDGAR)
			endif
		ENDIF 
		
		//Priscila Kuhn - 12/03/15 
		//Buscar posto de verifica??o para casos onde foi validado pela Central de Verifica??o 
		If "CENTRAL DE VERIFICACAO" $ Upper(SZ3->Z3_DESENT) 
			If !Empty(SZ5->Z5_POSVER) 
				cCodPosto := SZ5->Z5_POSVER 
				
				//Me Posiciono Novamente no posto verifica??o para dar continuidade nas atividades 
				SZ3->(DbSetOrder(6))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR 
				SZ3->(!MsSeek(xFilial("SZ3") + "4" + cCodPosto)) 
				
				cCodCCR	:= SZ3->Z3_CODCCR			//Identifica a Ferderação vinculada ao posto ou CCR 
				cCodAr		:= SZ3->Z3_CODAR 			//AR associado ao posto 
				cQuebra	:= SZ3->Z3_QUEBRA			//2-CARTORIO OU 1=CCR 
		
				If Empty(SZ3->Z3_CODCCR) 
					cCodFeder	:= SZ3->Z3_CODFED			//Ferderação. Entidade politica associada ao posto de atendimento 
					cCodAC		:= SZ3->Z3_CODAC			//Grupo/Rede. Entidade que agrupa v?rios postos de redes GAR. 
					cCodCanal	:= SZ3->Z3_CODCAN 		//Canal  associado ao posto 
					cCodCanal2	:= SZ3->Z3_CODCAN2		//Canal2 associado ao posto 
				Else 
					aAreaSZ3 := SZ3->(GetArea()) 
					SZ3->(DbSetOrder(1)) 
					SZ3->(MsSeek(xFilial("SZ3") + cCodCCR)) 
					cDesCcr	:= SZ3->Z3_DESENT 
					cCodFeder	:= SZ3->Z3_CODFED			//Ferderação. Entidade politica associada ao posto de atendimento 
					cCodAC		:= SZ3->Z3_CODAC			//Grupo/Rede. Entidade que agrupa v?rios postos de redes GAR. 
					cCodCanal	:= SZ3->Z3_CODCAN 		//Canal  associado ao posto 
					cCodCanal2	:= SZ3->Z3_CODCAN2		//Canal2 associado ao posto 
					RestArea(aAreaSZ3) 
				Endif 
				
			EndIf 
		EndIf 
		
		/* 
		??????????????????????????????????????????????????????????????????????????????????????? 
		? C?lculo de remuneracao conforme "piramide" definida no cadastro de entidade          ? 
		???????????????????????????????????????????????????????????????????????????????????????? 
		*/ 
		
		// Sequ?ncia de comissao de baixo para cima onde; 
		// nI == 1  --> Posto /CCRcomiss?o 
		// nI == 2  --> Grupo/Rede 
		// nI == 3  --> Canal 
		// nI == 4  --> Canal2 
		// nI == 5  --> Federacao 
		// nI == 6  --> Verificacao Campanha do Contador / Clube do Revendedor 
		// nI == 7  --> AR 
		
		//Renato Ruy - 06/05/2016 
		//Validacao para produtos nao pagos 
		lPagoProd := CRPA020Y(SZ5->Z5_PRODGAR) 
		
		//Renato Ruy - 23/09/2016 
		//Tratamento para o PROJETO TOPOS 
		lProjTop := .F. 
		If "PROJETO TOPOS" $ UPPER(SZ5->Z5_DESGRU) .And. cCatProd $ "01|02" 
			lProjTop 	:= .T. 
		Endif 
		
		If !lPagoProd 
			CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> PEDIDO IGNORADO") 
			CRPA020LOG(1,"Produto " + SZ5->Z5_PRODGAR + " não ? pago.",{{'lPagoProd',lPagoProd}},'lPagoProd',ProcLine(),cNomeUsu) 
			UnLockByName("CRPA020"+SZ5->Z5_PEDGAR) 
			Loop 
		ENDIF 
		
		//Zerar o valor acumulado de abatimento no Canal 1 e 2. 
		nAbtAR	:= 0 
		nAbtCart:= 0 
		nAbtAC  := 0 
		nAbtImp := 0 
		cCalcIFEN := "" //Variavel para armazena se calcula o produto IFEN. 
		
		//Renato Ruy - 24/07/2017 
		//Retorna o status de remuneracao  
		aStatus  := {"",;				//aStatus[1] - NAOPAG -> Origem nao remunerado ou PAGANT - Pago Anteriormente 
					CTOD("  /  /  "),; //aStatus[2] - Data do pedido de origem 
					""}				//aStatus[3] - Tipo do voucher de origem 
		If !Empty(SZ5->Z5_CODVOU) .And. AllTrim(SZ5->Z5_TIPVOU) != "H" 
			
			aStatus := CRPA020V(SZ5->Z5_CODVOU) 
		Endif 
		
		For nI := 1 To 8 
			
			lNaoPagou	:= .T. //Controla se o voucher foi pago. 
			lOriCupom	:= .F. //Controla se o voucher de origem e cupom. 
			lCNJ 		:= .F. //Projeto CNJ com valores fixos 
			nQtdReg		:= 0 
			nValSw  	:= 0 
			nValHw  	:= 0 
			nBaseSw 	:= 0 
			nBaseHw 	:= 0 
			nValTot 	:= 0 
			nImpCamp	:= 0 
			nValTotHW	:= SZ5->Z5_VALORHW 
			nValTotSW	:= SZ5->Z5_VALORSW 
			cTipPar 	:= "" 
			cCodPar 	:= "" 
			cDesPar 	:= "" 
			cTiped		:= "" 
			cAbateCcrAC := "" 
			cAbateCamp 	:= "" //25/06/15 - faltou declarar a vari?vel. Ser? atualizada somente no la?o FOR da entidade que necessita desta condi??o. 
			lProFunc	:= .F. 
			lACJUS	  	:= .F. 
			cProMinc	:= "" 
			cObserva	:= "" 
			lFCSPCalc	:= .F. 
			lPedNoRem	:= .F. 
			lCalcAss	:= .F. 
			
			//Solicitante: Priscila Kuhn - 24/07/15 
			//Tratamento para produto IFEN 
			If SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" 
				
				//Renato Ruy - Atualiza valores conforme tabela de pre?o IFEN - ZZ9. 
				ZZ9->(DbSetOrder(2)) 
				If ZZ9->(DbSeek(xFilial("ZZ9")+SZ5->Z5_PRODGAR)) 
					
					While AllTrim(ZZ9->ZZ9_PROD) == AllTrim(SZ5->Z5_PRODGAR) 
						If ZZ9->ZZ9_DTINI <= SZ5->Z5_DATPED .And. ZZ9->ZZ9_DTFIM >= SZ5->Z5_DATPED 
							If 'RENOVACAO' $ UPPER(SZ5->Z5_DESGRU) 
								nValTotHW:= 0 
								nValTotSW:= ZZ9->ZZ9_VLRENO 
							Else 
								nValTotHW:= ZZ9->ZZ9_VALHW 
								nValTotSW:= ZZ9->ZZ9_VALSW 
							EndIf 
						EndIf 
					EndDo 
					
				EndIf 
				
				//Caso não encontre o valor preenchido, uso valor importado para SZ5. 
				If nValTotHW + nValTotSW == 0 
					nValTotHW:= SZ5->Z5_VALORHW 
					nValTotSW:= SZ5->Z5_VALORSW 
				EndIf 
				
				//Renato Ruy - 03/02/16 
				//Alteração para validar Tabela de Voucher IFEN. 
				ZZ4->(DbSetOrder(1)) 
				If ZZ4->(DbSeek(xFilial("ZZ4")+SZ5->Z5_PEDGAR)) .And.; 
					((DtoS(ZZ4->ZZ4_DATVER) > " " .And. Empty(ZZ4->ZZ4_PEDORI)) .Or.; 
					(DtoS(ZZ4->ZZ4_DATEMI) > " " .And. !Empty(ZZ4->ZZ4_PEDORI))) 
					
					nValTotHW:= 0 
					nValTotSW:= 0 
					cTiped	 := "RECEBANT" 
					
				EndIf 
				
				//Renato Ruy - 03/09/2015 
				// Solicita??o da Tania - Regra para fixar valores quando o produto e o OABA3PFTOHV2 e o valor 165. 
			ElseIf AllTrim(SZ5->Z5_PRODGAR) == "OABA3PFTOHV2" .And. nValTotHW+nValTotSW == 165 
				nValTotHW:= 85 
				nValTotSW:= 80 
			EndIf 
			
			//Solicitante: Priscila Kuhn - 26/11/15 
			//Validação para reembolso. 
			//Somente habilito para calculo do mes 201511. 
			lGerReem		:= .T. 
			nValReem		:= 0 
			
			If lCalcSAGE 
	
				//Verifica se ha pagamento anterior e ignora os registros 
				SZ6->(DbSetOrder(1)) 
				If SZ6->(DbSeek(xFilial("SZ6")+SZ5->Z5_PEDGAR)) .And. SZ6->Z6_PERIODO < cRemPer .And. Ni != 8 
					Loop 
				Endif 
				
			EndIf 
			
			If !Empty(SZ5->Z5_PEDGAR) 
			
				If Select("TMPCHK") > 0 
					DbSelectArea("TMPCHK") 
					TMPCHK->(DbCloseArea()) 
				Endif 
				
				Beginsql Alias "TMPCHK" 
					SELECT MIN(E5_DATA) DATACB, SUM(E5_VALOR) VALOR from %TABLE:SC5% SC5 
					JOIN %TABLE:SE5% SE5  
					ON E5_FILIAL = %xFilial:SE5% AND E5_PREFIXO = 'RCP' AND E5_NUMERO = C5_NUM AND E5_RECPAG = 'P' AND UPPER(E5_HISTOR) LIKE '%CHARGEBACK%' AND SE5.%Notdel% 
					WHERE 
					C5_FILIAL = ' ' AND 
					C5_CHVBPAG = %Exp:SZ5->Z5_PEDGAR% AND 
					SC5.%Notdel% 
				Endsql 
				
				//Me posiciono na tabela do service desk. 
				DbSelectArea("ADE") 
				ADE->(DbOrderNickName("PEDIDOGAR")) 
				If ADE->(DbSeek(xFilial("ADE")+SZ5->Z5_PEDGAR)) 
					
					If Select('TMP') > 0 
						TMP->(DbCloseArea()) 
					EndIf 
					
					//Renato Ruy - 25/08/2016 
					//Sera necessario armazenar todos os atendimentos, para verificar se nenhum deles e de pagamento em duplicidade. 
					cReembIn := "" 
					aDadoRem := {} 
					While !ADE->(EOF()) .And. SZ5->Z5_PEDGAR == ADE->ADE_PEDGAR 
						AADD(aDadoRem,ADE->ADE_CODIGO) 
						cReembIn += Iif(Empty(cReembIn),"",",")+ADE->ADE_CODIGO 
						ADE->(DbSkip()) 
					Enddo 
					cReembIn := "% "+FormatIn(cReembIn,",")+" %" 
					
					//Busca dados do pagamento em duplicidade. 
					BeginSql alias 'TMP' 
						
						SELECT UP_CODCAMP, UP_CARGO, UPPER(UP_DESC) UP_DESC  FROM %Table:SUK% SUK 
						LEFT JOIN %Table:ACI% ACI ON ACI_FILIAL = %xFilial:ACI% AND ACI.ACI_CODIGO = SUK.UK_CODIGO AND ACI.D_E_L_E_T_ = ' ' 
						LEFT JOIN %Table:SUP% SUP ON UP_FILIAL = %xFilial:SUP% AND UP_CODCAMP = ACI_CODSCR AND UP_CARGO = UK_CODRESP AND SUP.D_E_L_E_T_ = ' ' 
						WHERE 
						UK_FILIAL = %xFilial:SUK% AND 
						UK_CODATEN IN %Exp:cReembIn% AND 
						UPPER(UP_DESC) = 'PAGAMENTO EM DUPLICIDADE' AND 
						SUK.D_E_L_E_T_ = ' ' 
						
					EndSql 
					
					lPgDupli := .F. 
					If TMP->(EOF()) .And. ADE->(Found()) 
	
						//Yuri Volpe - 26/08/19 - OTRS 2019041010003284  
						//Tratamento para evitar que reembolso por pagamento em duplicidade 
						//Entre na fila de reembolso para o parceiro					 
						dbSelectArea("ADF") 
						ADF->(dbSetOrder(1)) 
						If ADF->(dbSeek(xFilial("ADF") + ADE->ADE_CODIGO)) 
						
							cCodADE := ADE->ADE_CODIGO 
							
							While ADF->(!EoF()) .And. ADE->ADE_FILIAL+ADE->ADE_CODIGO == xFilial("ADE") + cCodADE 
								If ADF->ADF_CODSU0 $ "74|72" 
									lPgDupli := .T. 
									Exit 
								EndIf 
								ADF->(dbSkip()) 
							EndDo 
							
						EndIf 
						
						If lPgDupli 
							CRPA020LOG(1,"Pedido ignorado. Reembolso para pagamento em duplicidade não gera reembolso ao Parceiro.",{'cNomeUsu',cNomeUsu},'"CRPA027R-REE" == cNomeUsu',ProcLine(),cNomeUsu) 
							Loop 
						EndIf 
						
					EndIf 
					
					//Conforme tratamento inicial nao sera considerado o assunto, somente o grupo 72. 
					//Filial	 + Protocolo  + Equipe	   + Assunto 
					//ADF_FILIAL + ADF_CODIGO + ADF_CODSU0 + ADF_CODSU7 
					//Nao usa mais ADF, pode existir varios atendimentos - somente verifica pagamento em duplicidade 
					If TMP->(EOF()) 
						
						//Me posiciono no financeiro para verificar se gerou reembolso. 
						SE2->(DbSetOrder(1)) 
						//Filial + Prefixo + Titulo + Parcela + Tipo 
						If SE2->(DbSeek(xFilial("SE2") + "REE" + PadL(AllTrim(SZ5->Z5_PEDGAR),9,"0") + "  DEV")) 
							lGerReem	:= .F. 
							nValReem	:= Iif(SE2->E2_VALOR>nValTotHW+nValTotSW,nValTotHW+nValTotSW,SE2->E2_VALOR) 
						Elseif SE2->(DbSeek(xFilial("SE2") + "   " + PadL(AllTrim(SZ5->Z5_PEDGAR),9,"0") + "  DEV")) 
							lGerReem	:= .F. 
							nValReem	:= Iif(SE2->E2_VALOR>nValTotHW+nValTotSW,nValTotHW+nValTotSW,SE2->E2_VALOR) 
						Elseif TMPCHK->VALOR > 0 
							lGerReem	:= .F. 
							nValReem	:= Iif(TMPCHK->VALOR>nValTotHW+nValTotSW,nValTotHW+nValTotSW,TMPCHK->VALOR) 
						Elseif "CRPA027R-REE" == cNomeUsu 
							CRPA020LOG(1,"Pedido ignorado. Usu?rio de Reembolso.",{'cNomeUsu',cNomeUsu},'"CRPA027R-REE" == cNomeUsu',ProcLine(),cNomeUsu) 
							loop 
						EndIf 
						
						//Armazena a data do titulo para utilizar como base. 
						if TMPCHK->VALOR > 0 
							cDtReemb := SUBSTR(TMPCHK->DATACB,1,6) 
						ElseIf !lGerReem 
							cDtReemb := SubStr(DtoS(SE2->E2_EMISSAO),1,6) 
						Else 
							cDtReemb := cRemPer 
						Endif 
						
						//Renato Ruy - 24/08/2016 
						//Pedidos com reembolso no mesmo mes serao zerados e fora do mes descontados. 
						If !lGerReem .And. cDtReemb <= cRemPer 
							
							nReembPg := 0 
							//Tenta se posicionar para negativar. 
							SZ6->(DbSetOrder(1)) 
							If SZ6->(DbSeek(xFilial("SZ6")+SZ5->Z5_PEDGAR)) .And. SZ6->Z6_PERIODO < cRemPer 
								While !SZ6->(EOF()) .And. SZ5->Z5_PEDGAR == SZ6->Z6_PEDGAR .And. !("RETIFICACAO" $ SZ6->Z6_REGCOM) 
									nReembPg += SZ6->Z6_VALCOM 
									SZ6->(DbSkip()) 
								Enddo 
							Endif 
							
							//Caso a soma seja maior ou menor que zero. 
							If nReembPg != 0 
								//Renato Ruy - 20/02/20 
								//Ajuste para descontar somente o valor reembolsado, em alguns caso e menor. 
								lGerReem	:= .F. 
								/*nVlReemS	:= Round(nValReem*(nValTotSw/(nValTotSw+nValTotHw)),2) 
								nVlReemH	:= Round(nValReem*(nValTotHw/(nValTotSw+nValTotHw)),2) 
								nValTotSw  	:= 0-nVlReemS 
								nValTotHw  	:= 0-nVlReemH*/ 
								
								aVlrPagos := CRPA20REMB(Ni, SZ5->Z5_PEDGAR) 
								
								nValTotSw  	:= 0-aVlrPagos[2] 
								nValTotHw  	:= 0-aVlrPagos[1]				 
								nReembPg	:= nValReem								 
							//Desconsidera se o pedido não foi validado/verificado - ToBeConfirmed 					 
							Elseif ( ( SubStr( DtoS (SZ5->Z5_DATVER  ),1,6)  < cRemPer .And.  Empty( SZ5->Z5_PEDGANT ) )   .Or.  ;
									 ( SubStr( DtoS (SZ5->Z5_DATEMIS ),1,6)  < cRemPer .And. !Empty( SZ5->Z5_PEDGANT ) ) ) .And. ;
									 (        Empty (SZ5->Z5_DATVAL  ) .Or. Empty(SZ5->Z5_DATVER)) 
								nValTotSw  	:= 0 
								nValTotHw  	:= 0 
								
								//Log 
								CRPA020LOG(1,"Pedido ainda não foi validado/verificado.",; 
									{{'SZ5->Z5_DATVER',SubStr(DtoS(SZ5->Z5_DATVER),1,6)},{'cRemPer',cRemPer},{'SZ5->Z5_PEDGANT',SZ5->Z5_PEDGANT},{'SZ5->Z5_DATEMIS',SubStr(DtoS(SZ5->Z5_DATEMIS),1,6)},{'SZ5->Z5_DATVAL',SZ5->Z5_DATVAL}},; 
									'((SubStr(DtoS(SZ5->Z5_DATVER),1,6)  < cRemPer .And. Empty(SZ5->Z5_PEDGANT)) .Or. (SubStr(DtoS(SZ5->Z5_DATEMIS),1,6)  < cRemPer .And. !Empty(SZ5->Z5_PEDGANT))) .And. (Empty(SZ5->Z5_DATVAL) .Or. Empty(SZ5->Z5_DATVER))',; 
									ProcLine(),cNomeUsu) 
								Loop 
							//Quando o pedido j? foi zerado anteriormente, desconsidera.						 
							/*Elseif (SubStr(DtoS(SZ5->Z5_DATVER),1,6)  < cRemPer .And. Empty(SZ5->Z5_PEDGANT)) .Or.; 
								(SubStr(DtoS(SZ5->Z5_DATEMIS),1,6)  < cRemPer .And. !Empty(SZ5->Z5_PEDGANT)) 
								//Pedido de meses anteriores que não serao negativados. 
								//Yuri Volpe - 06/03/2019 
								//OTRS 2019030610000635 - Conforme orienta??o da Priscila Kuhn, o pedido não poder? ser ignorado 
								//E dever? ser apresentado ao relat?rio zerado - Revogado em 08/04/2019 
								nValTotSw  	:= 0 
								nValTotHw  	:= 0 
								//Loop*/ 
							Else 
							
								aVlrPagos := CRPA20REMB(Ni, SZ5->Z5_PEDGAR) 
								
								//Renato Ruy - 22/02/17 
								//Desconta somente o valor informado no reembolso. 
								nVlReemS	:= Round(nValReem*(nValTotSw/(nValTotSw+nValTotHw)),2) 
								nVlReemH	:= Round(nValReem*(nValTotHw/(nValTotSw+nValTotHw)),2) 
								nValTotSw  	:= nValTotSw-nVlReemS 
								nValTotHw  	:= nValTotHw-nVlReemH 
							EndIf 
						Elseif !lGerReem .And. cDtReemb > cRemPer 
							lGerReem 	:= .T. 
						EndIf 
					//Para nao gerar registro incorreto quando foi reembolso por duplicidade. 
					Elseif "CRPA027R-REE" == cNomeUsu 
						CRPA020LOG(1,"Usu?rio de Reembolso.",{{'cNomeUsu',cNomeUsu}},'"CRPA027R-REE" == cNomeUsu',ProcLine(),cNomeUsu) 
						Loop 
					EndIf 
				//Renato Ruy - 11/07/2018 
				//2018070310000859 ] Pedidos de Reembolso_jun.18 
				//Quando se trata de chargeback 
				Elseif TMPCHK->VALOR > 0 
				
					//Busca valor pago anteriormente 
					nReembPg := 0 
					//Tenta se posicionar para negativar. 
					SZ6->(DbSetOrder(1)) 
					If SZ6->(DbSeek(xFilial("SZ6")+SZ5->Z5_PEDGAR)) .And. SZ6->Z6_PERIODO < cRemPer 
						While !SZ6->(EOF()) .And. SZ5->Z5_PEDGAR == SZ6->Z6_PEDGAR .And. !("RETIFICACAO" $ SZ6->Z6_REGCOM) 
							nReembPg += SZ6->Z6_VALCOM 
							SZ6->(DbSkip()) 
						Enddo 
					Endif 
					
					//Valor de reembolso não pode exceder o valor total do pedido 
					//nValReem	:= Iif(TMPCHK->VALOR>nValTotHW+nValTotSW,nValTotHW+nValTotSW,TMPCHK->VALOR) 
					//OTRS 2019070310003765 - 05/07/2019 - Yuri Volpe 
					//No caso de CHARGEBACK, os pedidos com reembolso dever?o ter o mesmo valor  
					//Do q foi calculado anteriormente 
					nValReem	:= nValTotHW+nValTotSW				 
					
					//Per?odo superior, remunera normalmente 
					If SUBSTR(TMPCHK->DATACB,1,6) > cRemPer 
						lGerReem 	:= .T. 
						if "CRPA027R-REE" == cNomeUsu 
							CRPA020LOG(1, "Usu?rio de Reembolso.",{{'cNomeUsu',cNomeUsu}},'"CRPA027R-REE" == cNomeUsu',ProcLine(),cNomeUsu) 
							Loop 
						endif 
					//Demais per?odos abate o valor ou negativa. 
					Else 
						lGerReem 	:= .F. 
						If nReembPg > 0 
							//Calcula o percentual para descontar por igual do SW e HW 
							nVlReemS	:= Round(nValReem*(nValTotSw/(nValTotSw+nValTotHw)),2) 
							nVlReemH	:= Round(nValReem*(nValTotHw/(nValTotSw+nValTotHw)),2) 
							//Gera o valor somente com o reembolso 
							nValTotSw  	:= 0-nVlReemS 
							nValTotHw  	:= 0-nVlReemH 
						Elseif "CRPA027R-REE" == cNomeUsu 
							CRPA020LOG(1,"Usu?rio de Reembolso.",{{'cNomeUsu',cNomeUsu}},'"CRPA027R-REE" == cNomeUsu',ProcLine(),cNomeUsu) 
							Loop 
						Else 
							//Calcula o percentual para descontar por igual do SW e HW 
							nVlReemS	:= Round(nValReem*(nValTotSw/(nValTotSw+nValTotHw)),2) 
							nVlReemH	:= Round(nValReem*(nValTotHw/(nValTotSw+nValTotHw)),2) 
							//Abate o valor atrav?s o percentual 
							nValTotSw  	:= nValTotSw-nVlReemS 
							nValTotHw  	:= nValTotHw-nVlReemH 
						Endif 
						
					Endif 
				
				//ElseIf  
					
				EndIf 
				
			EndIf 
			
			ltemFaixa:=.f. 
			//Renato Ruy - 10/10/2016 
			//OTRS: 2016100710001642 - Zera valor para determinados CCR's. 
			cZera	 := "N" 
			
			Do Case 
				Case nI == 1 //Posto ou CCR 
					
					//Renato Ruy - 06/07/2017 
					//Como a variavel ja estava com conteudo sempre calculava. 
					cCalcRem := "" 
					//Efetua busca dos dados de percentual 
					IF !EMPTY(cCodCCR) .And. !lProjTop 
						
						SZ3->(DbSetOrder(1)) // Z3_FILIAL + Z3_TIPENT + C?DIGO CCR 
						IF SZ3->(MsSeek(xFilial("SZ3") + cCodCCR)) 
							cCalcRem	:= SZ3->Z3_TIPCOM   //Define de deve calcular comiss?o para a CCRCOMISSAO do posto e a estrutura de parceiros associados a ele. 
							cAbateCamp	:= SZ3->Z3_REMCAM   //Define se abate valor no calculo da campanha. 
							cCalcIFEN	:= SZ3->Z3_CALIFEN  //Define se vai calcular IFEN para estrutura. 
							cZera		:= SZ3->Z3_ZERA		//Zera valor base do CCR ou entidade. 
						ENDIF 
					//Renato Ruy - 23/09/2016 - não calcular Remuneração para Projeto Topos. 
					Elseif lProjTop 
						SZ3->(DbSetOrder(1)) // Z3_FILIAL + Z3_TIPENT + C?DIGO CCR 
						IF SZ3->(MsSeek(xFilial("SZ3") + "TOPOS")) 
							
							cCodPosOri	:= cCodPosto	//07.11.19 - Alteração para contemplar calculo de AR no calculo TOPOS 
							cCodPosto	:= "TOPOS" 
							cCodCCR		:= SZ3->Z3_CODCCR 
							cCodAc		:= SZ3->Z3_CODAC 
							cCalcRem	:= SZ3->Z3_TIPCOM   //Define de deve calcular comiss?o para a CCRCOMISSAO do posto e a estrutura de parceiros associados a ele. 
							cAbateCamp	:= SZ3->Z3_REMCAM   //Define se abate valor no calculo da campanha. 
							cCalcIFEN	:= SZ3->Z3_CALIFEN  //Define se vai calcular IFEN para estrutura. 
							cZera		:= SZ3->Z3_ZERA		//Zera valor base do CCR ou entidade. 
						ENDIF						 
					ELSE 
						If Empty(cCalcRem) 
							cCalcRem	:= SZ3->Z3_TIPCOM   //Define de deve calcular comiss?o para ao posto e a estrutura de parceiros associados a ele. 
							cAbateCamp	:= SZ3->Z3_REMCAM   //Define se abate valor no calculo da campanha. 
							cCalcIFEN	:= SZ3->Z3_CALIFEN  //Define se vai calcular IFEN para estrutura. 
							cZera		:= SZ3->Z3_ZERA		//Zera valor base do CCR ou entidade. 
						Else 
							//Me Posiciono Novamente no posto verifica??o para dar continuidade nas atividades 
							SZ3->(DbSetOrder(6))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR 
							SZ3->(!MsSeek(xFilial("SZ3") + "4" + cCodPosto)) 
							cAbateCamp	:= SZ3->Z3_REMCAM   //Define se abate valor no calculo da campanha. 
							cCalcIFEN	:= SZ3->Z3_CALIFEN  //Define se vai calcular IFEN para estrutura. 
							cZera		:= SZ3->Z3_ZERA		//Zera valor base do CCR ou entidade. 
						EndIf 
					ENDIF 
					
					If cCalcRem <> "1" // Calcula comissao (Z3_TIPCOM) diferente de Sim (1) 
						CRP020GrvErro("PEDIDO GAR: " + SZ5->Z5_PEDGAR +" ---> NAO CALCULA REMUNERACAO PARA O POSTO " + cCodPosto+"/ CCR: "+cCodCCR) 
						CRPA020LOG(1,"Campo [Calcula Rem.] do Posto/CCR marcado como não ou em Branco.",{{'Ni',Ni},{'cCalcRem',cCalcRem}},'cCalcRem <> "1"',ProcLine(),cNomeUsu) 
						Loop 
						//Calcula apenas comiss?o sobre a venda. 
						//Vai direto para o calculo do parceiro (revendedor/contator) nI RECEBE 6 
						//nI:=6 //Removido para calcular Remuneração para o posto mesmo zerada. 
					//Elseif cCalcIFEN <> "S" .And. SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" 
					/*Elseif cCalcIFEN <> "S" .And. SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" 
						If cCodCCR == '070863' 
							CRP020GrvErro("PEDIDO GAR: " + SZ5->Z5_PEDGAR +" ---> não Gera Calculo para IFEN " + cCodPosto+"/ CCR: "+cCodCCR) 
							Loop 
						EndIf*/ 
					ElseIf SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" //Desconsidera pedidos IFEN 
						CRP020GrvErro("PEDIDO GAR: " + SZ5->Z5_PEDGAR +" ---> não Gera Calculo para IFEN " + cCodPosto+"/ CCR: "+cCodCCR) 
						CRPA020LOG(1,"não Gera Calculo para IFEN " + cCodPosto+"/ CCR: "+cCodCCR+".",{{'Ni',Ni},{'SZ5->Z5_PRODGAR',SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4)}},'SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN"',ProcLine(),cNomeUsu) 
						Loop 
					//Renato Ruy - 01/12/2017 
					//Novo tratamento especifico BV 
					//Para produto que não ? da BV, somente calcular Posto 
					ElseIf AllTrim(cCodAC) $ "BV" .And. !cCatProd $ "01/02/03/04" 
						CRPA020LOG(1,"Produto não ? BV.",{{'Ni',Ni},{'cCodAC',cCodAC},{'cCatProd',cCatProd}},'AllTrim(cCodAC) $ "BV" .And. !cCatProd $ "01/02/03/04"',ProcLine(),cNomeUsu) 
						Loop 
					Elseif cCatProd $ "27/28/29" 
						CRPA020LOG(1,"Produtos de categoria BV",{{'Ni',Ni},{'cCatProd',cCatProd}},'cCatProd $ "27/28/29"',ProcLine(),cNomeUsu) 
						Loop 
					Endif 
					
					CRPA020LOG(0,"MEM?RIA DE C?LCULO - FIM DA CARGA DE VARI?VEIS",{{'Ni',Ni},{'cCodPosto',cCodPosto},{'cCodCCR',cCodCCR},{'cCodAc',cCodAc},{'cCalcRem',cCalcRem},{'cAbateCamp',cAbateCamp},{'cCalcIFEN',cCalcIFEN},{'cZera',cZera}},'cCatProd $ "27/28/29"',ProcLine(),cNomeUsu) 
			
					If !(cTipEnt $ "0/4") 
						CRPA020LOG(1,"C?lculo de Posto não realizado: foi selecionado outro tipo de entidade para c?lculo.",{{'Ni',Ni},{'cTipEnt',cTipEnt}},'',ProcLine(),cNomeUsu) 
						Loop 
					EndIf 
					
					If AllTrim(cCodCCR) == "082321" 
						lCalcAss := .T. 
						cCodCanal := "CA0030" 
					EndIf				 
					
				Case nI == 2  //Grupo/Rede 
					
					//Solicitante: Priscila - 21/07/14 
					//não calcula valor para SINRJ 
					//If "SINRJ" $ SZ5->Z5_PRODGAR 
					//	Loop 
					//EndIf 
					
					//Yuri Volpe - 03/05/2019 
					//OTRS 2019050210001718 - Diversos pedidos IFEN com registros de AC e Posto  
					//Caso espec?fico para AR ABCERTIFICA não apresentar IFEN 3% 
					If ("IFEN" $ SZ5->Z5_PRODGAR .And. cCodAC == "FEN") .Or. ("IFEN" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodCCR) == "070863") 
						CRPA020LOG(1,"AR ABCERTIFICA não pode calcular IFEN 3%.",; 
							{{'Ni',Ni},{'SZ5->Z5_PRODGAR',SZ5->Z5_PRODGAR},{'cCodAC',cCodAC},{'cCodCCR',cCodCCR}},; 
							'("IFEN" $ SZ5->Z5_PRODGAR .And. cCodAC == "FEN") .Or. ("IFEN" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodCCR) == "070863")',; 
							ProcLine(),cNomeUsu) 
						Loop 
					EndIf 
					
					//Valido se o produto e da AC ou pertence a outra. 
					lProdCalc := .T. //Alimento a vari?vel com .T. e ser? validada em seguida. 
					cAcPropri := "" 
					
					//Renato Ruy - 01/12/2017 
					//Novo tratamento especifico BV 
					//Para produto que não ? da BV, somente calcular Posto 
					If AllTrim(SZ5->Z5_TIPVOU) == "L" 
						cAcPropri := Padr("BV",6," ") 
					ElseIf AllTrim(SZ5->Z5_TIPVOU) == "K" 
						cAcPropri := Padr("BV",6," ") 
						nValTotHW:= 0 
						nValTotSW:= 0 
					//If AllTrim(SZ5->Z5_TIPVOU) $ "LK" 
					//	cAcPropri := Padr("BV",6," ") 
					//	lProdCalc := .F. 
					ElseIf AllTrim(cCodAC) == "BV" .And. !cCatProd $ "27/28/29" 
						CRPA020LOG(1,"AC BV e produto não ? Categoria BV",{{'Ni',Ni},{'cCodAc',cCodAc},{'cCatProd',cCatProd}},'AllTrim(cCodAC) == "BV" .And. !cCatProd $ "27/28/29"',ProcLine(),cNomeUsu) 
						Loop 
					//Renato Ruy - 09/02/2018 
					//OTRS: 2018030610001771 - Regra Remuneração 
					//Para produtos da BV - Mesmo que não perten?am a AC, efetua cobran?a 
					ElseIf cCatProd $ "27/28/29" 
						cAcPropri := Padr("BV",6," ") 
						lProdCalc := .F. 
					Endif 
					//Fim - Nova Alteração BV 
					
					//Renato Ruy - 30/08/2018 
					//OTRS:2018082910000961 - BR Credenciada 
					If AllTrim(cCodAC) == "BRC" 
						lProdCalc := .F. 
						cAcPropri := Padr("BR",6," ") 
					Endif 
	
					If cCodCCR $ "071030/054471/054657/054933" 
						cCodAC := "BR " 
					EndIf 
					//If cCodCCR $ "054403/054553/054924" 
					//	cCodAC := "SIN" 
					//EndIf				 
	
					//Nova Regra para alterar AC BR Credenciada para BR 
					//Solicitante: Priscila Kuhn 
					//Valida se o produto pertence ao Produtos REG, SIN ou NOT. 
					//If !(cCodCCR $ "071030/054471/054657/054933/054657/054403") 
						If ("REG" $ SZ5->Z5_PRODGAR .And. !"SERVEREG" $ SZ5->Z5_PRODGAR) .OR. "NOT" $ SZ5->Z5_PRODGAR	.OR. "SIN" $ SZ5->Z5_PRODGAR .OR. "SINRJ" $ SZ5->Z5_PRODGAR .Or. "FENACOR" $ SZ5->Z5_PRODGAR 
							//Caso o produto não perten?a ao Grupo/Rede 
							If !(("REG" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAC) == "BR")  .OR. ; 
								("NOT" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAC) == "NOT") .OR. ; 
								("SIN" $ SZ5->Z5_PRODGAR .And. !"SINRJ" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAC) == "SIN") .OR. ; 
								("SINRJ" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAC) == "SINRJ") .OR.; 
								("FENACOR" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAC) == "FENCR")) 
								
								//produto não pertence ao grupo/rede paga o "dono" do produto controlado pela variavel lProdCalc e cAcPropri na gera??o do registro na SZ6. 
								lProdCalc := .F. 
								
								If "REG" $ SZ5->Z5_PRODGAR 
									cAcPropri := Padr("BR",6," ") 
									If cCodCCR $ "071030/054471/054657/054933" 
										cCodAC := "BR " 
									EndIf								 
								ElseIf "NOT" $ SZ5->Z5_PRODGAR 
									cAcPropri := Padr("NOT",6," ") 
								ElseIf "SINRJ" $ SZ5->Z5_PRODGAR 
									cAcPropri := Padr("SINRJ",6," ") 
								ElseIf  "SIN" $ SZ5->Z5_PRODGAR 
									cAcPropri := Padr("SIN",6," ") 
									//If cCodCCR $ "054403/054553/054924"  
									//	cCodAC := "SIN" 
									//EndIf 
								ElseIf "FENACOR" $ SZ5->Z5_PRODGAR 
									cAcPropri := Padr("FENCR", 6, " ") 
								EndIf 
								
							EndIf 
						EndIf 
					//EndIf 
					//Forca geracao da remuneracao para AC de produtos que tem valor fixo. 
					cCalcRem := Iif(Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_VLSOFT") > 0,"1",cCalcRem) 
					
					//Renato Ruy - 23/09/2016 - não calcular Remuneração para Projeto Topos. 
					If cCalcRem <> "1" .or. lProjTop .or. (Empty(cCodAc) .And. Empty(cAcPropri)) .OR. (cCalcIFEN <> "S" .And. SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN") .Or.; 
							(SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" .And. AllTrim(cCodAc) == "FEN")// Calcula comissao (Z3_TIPCOM) diferente de Sim (1) 
						
						//Log 
						CRPA020LOG(1,"",{{'Ni',Ni},{'cCalcRem',cCalcRem},{'lProjTop',lProjTop},{'cCodAc',cCodAc},{'cAcPropri',cAcPropri},{'cCalcIFEN',cCalcIFEN},{'SZ5->Z5_PRODGAR',SZ5->Z5_PRODGAR}},; 
						'cCalcRem <> "1" .or. lProjTop .or. (Empty(cCodAc) .And. Empty(cAcPropri)) .OR. (cCalcIFEN <> "S" .And. SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN") .Or.(SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" .And. AllTrim(cCodAc) == "FEN")',; 
						ProcLine(),cNomeUsu) 
						
						Loop 
					Endif 
					
					If SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" .And. cCodCCR == '070863' 
						CRP020GrvErro("PEDIDO GAR: " + SZ5->Z5_PEDGAR +" ---> não Gera Calculo para IFEN " + cCodPosto+"/ CCR: "+cCodCCR) 
						CRPA020LOG(1,"não gera calculo para IFEN",'SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" .And. cCodCCR == "070863"',{{"Ni",Ni}},ProcLine(),cNomeUsu)					 
						Loop 
					EndIf 
					
					SZ3->( DbSetOrder(1) ) 
					If Empty(cAcPropri) 
						If SZ3->( !MsSeek( xFilial("SZ3") + cCodAc ) ) 
							CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> não FOI ENCONTRADO O CADASTRO DO GRUPO/REDE "+cCodAc+" DO POSTO " + cCodPosto) 
							CRPA020LOG(1,"não foi encontrado o cadastro do Grupo/Rede " + cCodAc + " do Posto " + cCodPosto,{{"Ni",Ni},{'SZ5->Z5_PEDSITE',SZ5->Z5_PEDSITE}},'!LockByName("CRPA020"+SZ5->Z5_PEDSITE)',ProcLine(),cNomeUsu) 
							Loop 
						Endif 
					Else 
						If SZ3->( !MsSeek( xFilial("SZ3") + cAcPropri ) ) 
							CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> não FOI ENCONTRADO O CADASTRO DO GRUPO/REDE "+cCodAc+" DO POSTO " + cCodPosto) 
							CRPA020LOG(1,"não foi encontrado o cadastro do Grupo/Rede " + cCodAc + " do Posto " + cCodPosto,{{"Ni",Ni},{'SZ5->Z5_PEDSITE',SZ5->Z5_PEDSITE}},'!LockByName("CRPA020"+SZ5->Z5_PEDSITE)',ProcLine(),cNomeUsu) 
							Loop 
						Endif 
					EndIf 
					// Verifica se tem cadastro de faixa 
					SZV->(DbSetOrder(1) ) 
					ltemFaixa:=SZV->( DbSeek( xFilial("SZV")+ SZ3->Z3_CODENT + Left( cRemPer, 4 ) ) ) 
					
					//Se não encontrou cadastro de faixas, cria para gerar o contador. 
					If AllTrim(SZ3->Z3_CODENT) $ "BR/BRC/NOT/SIN/SINRJ" .And. !ltemFaixa 
						
						//Gravo a faixa para iniciar gera??o de dados. 
						SZV->(RecLock("SZV",.T.)) 
							SZV->ZV_CODENT := SZ3->Z3_CODENT 
							SZV->ZV_SALANO := Left(cRemPer,4) 
						SZV->(MsUnlock()) 
						
						//Me posiciono e informo que existe faixa. 
						ltemFaixa:=SZV->( DbSeek( xFilial("SZV")+ SZ3->Z3_CODENT + Left( cRemPer, 4 ) ) ) 
					EndIf 
	
					CRPA020LOG(0,"MEM?RIA DE C?LCULO - FIM DA CARGA DE VARI?VEIS",{{'Ni',Ni},{'ltemFaixa',ltemFaixa},{'cCalcRem',cCalcRem},{'cAcPropri',cAcPropri}},'',ProcLine(),cNomeUsu) 
					
					If !(cTipEnt $ "0/2") 
						CRPA020LOG(1,"Tipo de entidade não selecionada para c?lculo",{{"Ni",Ni},{'cTipEnt',cTipEnt}},'!(cTipEnt $ "0/2")',ProcLine(),cNomeUsu) 
						Loop 
					EndIf 
													
				Case nI == 3 //Canal 
					
					//Solicitante: Priscila - 21/07/14 
					//não calcula valor para SINRJ 
					//If "SINRJ" $ SZ5->Z5_PRODGAR 
					//	Loop 
					//EndIf 
					
					//Solicitante: Priscila - 26/12/14 
					//Valida Canal remunerado x Tipo de produto 
					//Solicitante: Priscila Kuhn - Data: 02/01/2015 - Valida atrav?s do produto para calcula o abatimento para calculo do canal. 
					// Desconta do canal valores pagos para o grupo/Rede e CCR/POSTO 
					If ("REG" $ SZ5->Z5_PRODGAR .And. !"SERVEREG" $ SZ5->Z5_PRODGAR) .Or. "NOT" $ SZ5->Z5_PRODGAR 
						cCodCanal := "CA0002" //Produto com inicio REG e NOT remuneram a PP Consultoria 
						cAbateCcrAC := "1" 
					ElseIf "SIN" $ SZ5->Z5_PRODGAR .Or. Rtrim(cCodAC) == "FENCR" .Or. "FENACOR" $ SZ5->Z5_PRODGAR 
						cCodCanal := "CA0001" //Produto com in?cio SIN remuneram a VIA 
						cAbateCcrAC := "1" 
					ElseIf "IFEN" $ SZ5->Z5_PRODGAR 
						cCodCanal := "CA0009" 
					EndIf 
	
					If cCodCCR $ "071030/054471/054657/054933" .And. ("REG" $ SZ5->Z5_PRODGAR .And. !"SERVEREG" $ SZ5->Z5_PRODGAR) 
						cCodAC := "BRC" 
					ElseIf cCodCCR $ "054403/054553/054924" .And. ("SIN" $ SZ5->Z5_PRODGAR .And. !("SINRJ" $ SZ5->Z5_PRODGAR)) 
					//	cCodAC := "SIN" 
					EndIf 
					
					// 09/05/2018 - Renato Ruy 
					// 2018050810003931 ] Produto BV na Labor Facesp - Abril.18 
					// não pagar produto BV ou origem BV para o Canal				 
					If AllTrim(SZ5->Z5_TIPVOU) $ "LK" .Or. cCatProd $ "27/28/29" 
						CRPA020LOG(1,"não pagar produto BV ou origem BV para o Canal",; 
								{{'Ni',Ni},{'SZ5->Z5_TIPVOU',SZ5->Z5_TIPVOU},{'cCatProd',cCatProd}},; 
								'AllTrim(SZ5->Z5_TIPVOU) $ "LK" .Or. cCatProd $ "27/28/29"',; 
								ProcLine(),cNomeUsu)					 
						Loop 
					Endif 
					
					If !Empty(cCodCanal) 
					
						SZ3->( DbSetOrder(1) ) 
						If SZ3->( !MsSeek( xFilial("SZ3") + cCodCanal ) ) .Or. SZ3->Z3_TIPCOM != "1" 
							CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> não FOI ENCONTRADO O CADASTRO DO CANAL" +cCodCanal+" DO POSTO " + cCodPosto) 
							CRPA020LOG(1,"não foi encontrado o cadastro do Canal " + cCodCanal + " do Posto " + cCodPosto,; 
								{{'Ni',Ni},{'cCodCanal',cCodCanal}},; 
								'SZ3->( !MsSeek( xFilial("SZ3") + cCodCanal ) )',; 
								ProcLine(),cNomeUsu)					 
							Loop 
						Endif 
					
					
						//Fim da Alteração - 26/12/14 
						//Renato Ruy - 23/09/2016 - não calcular Remuneração para Projeto Topos. 
						If (cCalcRem <> "1" .And. !cCodCanal $ "CA0001/CA0002/CA0009") .or. lProjTop .OR. Empty(cCodCanal) .OR. (cCodCanal == "CA0009" .And. !"IFEN" $ SZ5->Z5_PRODGAR) 
							//Log 
							CRPA020LOG(1,"não calcular Remuneração para Projeto Topos",; 
								{{'Ni',Ni},{'cCalcRem',cCalcRem},{'cCodCanal',cCodCanal},{'lProjTop',lProjTop},{'SZ5->Z5_PRODGAR',SZ5->Z5_PRODGAR}},; 
								'(cCalcRem <> "1" .And. !cCodCanal $ "CA0001/CA0002/CA0009") .or. lProjTop .OR. Empty(cCodCanal) .OR. (cCodCanal == "CA0009" .And. !"IFEN" $ SZ5->Z5_PRODGAR)',; 
								ProcLine(),cNomeUsu) 
							Loop 
						EndIf 
					EndIf 
					
					//Solicitante: Suzane / T?nia - 23/04/15 
					//Gravo atrav?s da AC, se dever? descontar os valores da AC e CCR na Remuneração do Canal. 
					If  SZ3->Z3_DEVLAR == "1" 
						cAbateCcrAC := "1" 
					EndIf 
					
					//Calculo de Assessoria 
					/*If !Empty(SZ3->Z3_CODPAR)  
						lCalcAss := .T. 
					EndIf 
					
					If AllTrim(SZ5->Z5_CODPAR) == "15530" .And. cCodCanal != "CA0030"  
						cCodCanal 	:= "CA0030" 
						lCalcAss 	:= .T. 
					EndIf*/ 
					
							
					If Empty(cCodCanal) .Or. cCodCanal == "CA0030" 
						Loop 
					EndIf 
					
					CRPA020LOG(0,"MEM?RIA DE C?LCULO - FIM DA CARGA DE VARI?VEIS",{{'Ni',Ni},{'cAbateCcrAC',cAbateCcrAC},{'cCodCanal',cCodCanal},{'SZ5->Z5_PRODGAR',SZ5->Z5_PRODGAR},{'cCodAc',cCodAc}},'',ProcLine(),cNomeUsu) 
					
					If !(cTipEnt $ "0/1/2") 
						Loop 
					EndIf 
					
				Case nI == 4 //Canal2 
					
					//Solicitante: Priscila - 21/07/14 
					//não calcula valor para SINRJ 
					//If "SINRJ" $ SZ5->Z5_PRODGAR 
					//	Loop 
					//EndIf 
					
					If SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" .And. cCodCCR == '070863' 
						CRP020GrvErro("PEDIDO GAR: " + SZ5->Z5_PEDGAR +" ---> não Gera Calculo para IFEN " + cCodPosto+"/ CCR: "+cCodCCR) 
						CRPA020LOG(1,"não gera c?lculo para IFEN",{{'Ni',Ni},{'SZ5->Z5_PRODGAR',SZ5->Z5_PRODGAR},{'cCodCCR',cCodCCR}},'SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" .And. cCodCCR == "070863"',ProcLine(),cNomeUsu) 
						Loop 
					EndIf 
					
					//Renato Ruy - 09/05/2018  
					//OTRS: 2018050810003931 ] Produto BV na Labor Facesp - Abril.18 
					//não pagar produto BV ou origem BV para o Canal				 
					If AllTrim(SZ5->Z5_TIPVOU) $ "LK" .Or. cCatProd $ "27/28/29" 
						CRPA020LOG(1,"não pagar produto BV ou origem BV para o Canal",; 
								{{'Ni',Ni},{'SZ5->Z5_TIPVOU',SZ5->Z5_TIPVOU},{'cCatProd',cCatProd}},; 
								'AllTrim(SZ5->Z5_TIPVOU) $ "LK" .Or. cCatProd $ "27/28/29"',; 
								ProcLine(),cNomeUsu)									 
						Loop 
					Endif 
					
					//Yuri Volpe - 08/02/2019 
					//OTRS 2019020510004304 - Nova Regra Instituto FENACON - Remunera 3% para Certisign 
					lPosCanal := .F. 
					aAreaSZ3Canal := SZ3->(GetArea()) 
					SZ3->(dbSetOrder(4)) 
					lPosCanal := SZ3->(dbSeek(xFilial("SZ3") + SZ5->Z5_CODPOS))				 
					If "IFEN" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAc) != "FEN" .And. cCodCCR <> '070863' .And. (lPosCanal .And. !("FENACON" $ Upper(SZ3->Z3_DESENT))) 
						cCodCanal2 := "CA0029" 
					EndIf 
					RestArea(aAreaSZ3Canal) 
					
					//Renato Ruy - 23/09/2016 - não calcular Remuneração para Projeto Topos. 
					If (cCalcRem <> "1" .And. !cCodCanal2 $ "CA0029") .Or. lProjTop .OR. Empty(cCodCanal2) .OR. (cCalcIFEN <> "S" .And. SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" .And. AllTrim(cCodAc) == "FEN")//.OR. !lProdCalc // Calcula comissao (Z3_TIPCOM) diferente de Sim (1) e se o produto ? da AC. 
						CRPA020LOG(1,"não calcula Remuneração para Projeto Topos",; 
							{{'Ni',Ni},{'cCalcRem',cCalcRem},{'lProjTop',lProjTop},{'cCodCanal2',cCodCanal2},{'cCalcIFEN',cCalcIFEN},{'SZ5->Z5_PRODGAR',SZ5->Z5_PRODGAR},{'cCodAc',cCodAc}},; 
							'cCalcRem <> "1" .or. lProjTop .OR. Empty(cCodCanal2) .OR. (cCalcIFEN <> "S" .And. SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN" .And. AllTrim(cCodAc) == "FEN")',ProcLine(),cNomeUsu) 
						Loop 
					EndIf 
					SZ3->( DbSetOrder(1) ) 
					If SZ3->( !MsSeek( xFilial("SZ3") + cCodCanal2 ) ) 
						CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> não FOI ENCONTRADO O CADASTRO DO CANAL2" +cCodCanal2+" DO POSTO " + cCodPosto) 
						Loop 
					Endif 
					
					If !Empty(cCodCanal2) 
					
						SZ3->( DbSetOrder(1) ) 
						If SZ3->( !MsSeek( xFilial("SZ3") + cCodCanal2 ) ) .Or. SZ3->Z3_TIPCOM != "1" 
							CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> O CANAL" +cCodCanal2+" NAO ESTA HABILITADO PARA CALCULO ") 
							CRPA020LOG(1,"O canal "+ cCodCanal2 + " não est? habilitado para c?lculo " ,; 
								{{'Ni',Ni},{'cCodCanal',cCodCanal2}},; 
								'SZ3->( !MsSeek( xFilial("SZ3") + cCodCanal ) )',; 
								ProcLine(),cNomeUsu)					 
							Loop 
						Endif 
					EndIf 
					
					//Calculo de Assessoria 
					/*If !Empty(SZ3->Z3_CODPAR) 
						lCalcAss := .T. 
					EndIf*/ 
					
					If !(cTipEnt $ "0/1/2") 
						Loop 
					EndIf 
					
				Case nI == 5 //Ferderação 
					//Renato Ruy - 23/09/2016 - não calcular Remuneração para Projeto Topos. 
					If cCalcRem <> "1" .or. lProjTop .OR. Empty(cCodFeder) .OR. (cCalcIFEN <> "S" .And. SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN")//.OR. !lProdCalc// Calcula comissao (Z3_TIPCOM) diferente de Sim (1) e se o produto ? da AC. 
						Loop 
					Endif 
					SZ3->( DbSetOrder(1) ) 
					If SZ3->( !MsSeek( xFilial("SZ3") + cCodFeder ) ) //Analisar 
						CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> não FOI ENCONTRADO O CADASTRO DA Ferderação" +cCodFeder+" DO POSTO " + cCodPosto) 
						Loop 
					EndIf 
					
					If !(cTipEnt $ "0/8") 
						Loop 
					EndIf 
					
				Case nI == 6 //Parceiro 
					//Renato Ruy - 23/09/2016 - não calcular Remuneração para Projeto Topos. 
					If lProjTop 
						Loop 
					Endif 
					// não existe necessidade de posicionamento. Ser?o utilizadas informa??es do SZ5 para remunerar o parceiro revendedor/contator 
					
					//Renato Ruy - 06/09/2017 
					//Regra para remunerar a AR conforme percentual cadastrado. 
					
					If AllTrim(cCodCCR) == "082321" .And. AllTrim(SZ5->Z5_CODPOS) == "16274" //cCalcAss  
						lCalcAss 	:= .T. 
						cCodCanal 	:= "CA0030" 
					EndIf 
				
					If !(cTipEnt $ "0/7") 
						Loop 
					EndIf 
				
				Case nI == 7 //AR 
				
					//Quando tem campanha os pedidos não ser?o remunerados 
					//Para renovacao apenas considera os links abaixo para nao gerar a validacao incorreta 
					lProdCalc := .T. 
					cAbateCamp := "S" 
					cAcPropri := CRR20RD(SZ5->Z5_DESREDE) 
					//Renato Ruy - 09/05/2018 
					//2018050410003607 ] Pedidos Faltantes Campanha_abril.18 
					//Considerar o link como da Credenciada e calcular na AC como campanha da BR. 
					If !(cAcPropri $ "BR/BRC/SIN/NOT/SINRJ/FACES/FENCR") .And. (!Empty(SZ5->Z5_PEDGANT) .OR. AllTrim(SZ5->Z5_TIPVOU) == 'H') .And. !('BR CRED' $ Upper(SZ5->Z5_DESREDE)) 
						cAbateCamp := "N" 
					EndIf 
					
					If cAbateCamp == "S" .And. nI != 6 .And. ("DO CONTADOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "ENTIDADE DE CLASSE" $ UPPER(SZ5->Z5_DESREDE)) .And.; 
						SZ5->Z5_COMSW > 0 .And. SZ5->Z5_BLQVEN != "0" 
						Loop 
					EndIf 
	
					//Verifica se tem o cadastro da AR no sistema 
					SZ3->( DbSetOrder(1) ) 
					If SZ3->( !MsSeek( xFilial("SZ3") + cCodAr ) ) .OR. Empty(cCodAr) .OR. cQuebra != "2" //Analisar 
						CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> não FOI ENCONTRADO O CADASTRO DA AR" +cCodAr+" DO POSTO " + cCodPosto) 
						Loop 
					EndIf 
					
					//Para AR somente recebe para produtos com categoria cadastrada 
					SZ4->( DbSetOrder(1) )	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD 
					If SZ4->( !MsSeek( xFilial("SZ4") + SZ3->Z3_CODENT + cCatProd ) ) 
						CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> ENTIDADE " + SZ3->Z3_CODENT + " não POSSUI REGRA DE REMUNERACAO DE ACORDO COM PRODUTO ") 
						Loop 
					EndIf 
					
					If !(cTipEnt $ "0/3") 
						Loop 
					EndIf 
				Case Ni == 8 
					
					If !lCalcSAGE 
						Loop 
					EndIf 
						
			Endcase 
			
			
			If nI <> 6 .And. nI <> 8 // Verifica??o normal 
				
				/* 
				??????????????????????????????????????????????????????????????????????????????????????? 
				? Trata a faixa de remuneracao dde acordo com quantidade de centificados verificados 
				somente para ni=2 (grupo/rede) com faixa cadastrada e que não seja companha do contatdor 
				???????????????????????????????????????????????????????????????????????????????????????? 
				*/ 
				
				//Renato Ruy - 14/06/2016 
				//A contagem da faixa somente e realizada no CRPA027W 
				If nI == 2 
					cFaixa		:= Iif(AllTrim(SZ5->Z5_DESCST) == "F0" .Or. Empty(SZ5->Z5_DESCST),"",AllTrim(SZ5->Z5_DESCST)) 
					lFaixaCamp 	:= (SZ3->Z3_ACAMPAN == "S") 
				EndIf 
				
				/* 
				??????????????????????????????????????????????????????????????????????????????????????? 
				? Calculo do valor da comissao e a origem da regra									   ? 
				???????????????????????????????????????????????????????????????????????????????????????? 
				*/ 
				
				nQtdReg	:= 0 
				nValSw  := 0 
				nValHw  := 0 
				nBaseSw := 0 
				nBaseHw := 0 
				
				// 1- Definir percentuais de SoftWare e Hardware conforme categoria de produtos 
				
				// IF Tratamento para Ni=2 (grupo Rede) e Existir Faixa, 
				
				//Para software Utilizar as Faixas (F1F2F3) para posicionar posicionar SZ4. 
				//Para hardware utilizar categoria do produto para posicionar SZ4 
				
				
				// Else Tratamento para Ni<>2 
				
				//Utilizar sempre a categoria do produto para posicionar na SZ4. 
				
				// EndIf 
				
				//A faixa substitui a Categoria do produto. 
				
				//Yuri Volpe - 16/03/2019 
				//OTRS 2019031810004298 - Criar faixa para campanha do contador_AC SINCOR 
				/*If lFaixaCamp 
					aAreaSZ4Camp := SZ4->(GetArea()) 
					SZ4->(dbSetOrder(1)) 
					If SZ4->(dbSeek(xFilial("SZ4") + cCodAc + "C1")) 
						While SZ4->Z4_FILIAL + AllTrim(SZ4->Z4_CODENT) + Substr(SZ4->Z4_CATPROD,1,1) == xFilial("SZ4") + AllTrim(cEntCamp) + "C" 
							If SZV->ZV_SALACU >= SZ4->Z4_QTDMIN .And. SZV->ZV_SALACU <= SZ4->Z4_QTDMAX 
								cFaixa := SZ4->Z4_CATPROD 
								Exit 
							EndIf 
							SZ4->(dbSkip()) 
						EndDo 
					EndIf 
					RestArea(aAreaSZ4Camp) 
				EndIf*/			 
				
				If !Empty(cFaixa) .And. nI == 2 .And. lFaixaCamp  
					cChaveSZ4 := SZ3->Z3_CODENT + cFaixa 
				Else 
					cChaveSZ4 := SZ3->Z3_CODENT + cCatProd 
				Endif 
							
				SZ4->( DbSetOrder(1) )	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD 
				SZ4->( DbGoTop() ) 
				If SZ4->( !MsSeek( xFilial("SZ4") + cChaveSZ4 ) ) 
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> ENTIDADE " + SZ3->Z3_CODENT + " não POSSUI REGRA DE REMUNERACAO DE ACORDO COM PRODUTO ") 
					//	Loop 
				EndIf 
				
				// Define porcentagens de remuneracao que ser?o consideradas 
				//Solicitante: Giovanni - 14/08/14 - Retiro a Validação do Parceiro 
				/*If !Empty(cCodParc) .AND. ( !EMPTY(SZ4->Z4_PARSW) .OR. !EMPTY(SZ4->Z4_PARHW)) // Verificacao Camp.Contador / Clube do Revendedor 
				
				nPorSfw := SZ4->Z4_PARSW / 100 
				nPorHdw := SZ4->Z4_PARHW / 100 
				cTipo	:= 'VERPAR' 
				Else*/ 
				
				//Caso seja calculado faixa buscar? software da faixa e hardware da categoria. 
				cAcPropri := CRR20RD(SZ5->Z5_DESREDE) 
				
				//Renato Ruy - 28/08/15 
				//Tratamento para campanha na renova??o 
				lCamRen := .T. 
				If !(cAcPropri $ "BR/BRC/SIN/SINRJ/NOT/FACES/FENCR") .And. !Empty(SZ5->Z5_PEDGANT) .And. !('BR CRED' $ Upper(SZ5->Z5_DESREDE)) 
					lCamRen := .F. 
				EndIf 
				
				//Renato Ruy - 23/11/2017 
				//Ajuste para não considerar produto notarial com outro link como campanha 
				//Este pedido dever? entrar para o controle de faixas 
				lNotarial := .T. 
				If cAcPropri != "NOT" .And. "NOT" $ SZ5->Z5_PRODGAR  
					lNotarial := .F. 
				Endif 
				
				cTipo	:= IIF(lMidiaAvulsa, 'ENTHAR','VERIFI') 
				
				//Renato Ruy - 02/01/2018 
				//OTRS: 2017121410001231 - Paga percentual de campanha para BR, quando tem origem do revendedor 
				If (cAbateCamp == "S" .Or. nI == 2) .And. SZ5->Z5_BLQVEN != "0" .And. lCamRen .And. lNotarial .And.; 
				("ENTIDADE DE CLASSE" $ UPPER(SZ5->Z5_DESREDE) .Or. "DO CONTADOR" $ UPPER(SZ5->Z5_DESREDE) .Or.; 
					("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE) .And. "REG"$SZ5->Z5_PRODGAR)) .And. PA8->PA8_CATPROD != "09"//.And. SZ5->Z5_COMSW > 0  
								
					//Yuri Volpe - 16/03/2019 
					//OTRS 2019031810004298 - Criar faixa para campanha do contador_AC SINCOR 
					If lFaixaCamp 
						//Calcula o Percentual de Software e Hardware 
						//Baseado na faixa encontrada para cada valor 
						If SZ4->(dbSeek( xFilial("SZ4") + cChaveSZ4 )) 
							nPorSfw := SZ4->Z4_PARSW / 100 
							nPorHdw := SZ4->Z4_PARHW / 100 
						EndIf 
					EndIf 
					
					If !lFaixaCamp .Or. nPorSfw + nPorHdw == 0 
						//Se reposiciona na SZ4, sem a faixa 
						cChaveSZ4 := SZ3->Z3_CODENT + cCatProd 
						SZ4->( !MsSeek( xFilial("SZ4") + cChaveSZ4 ) ) 
						//se tem percentual da campanha para o produto 
						nPorSfw := Iif(SZ4->Z4_PARSW>0,SZ4->Z4_PARSW,SZ4->Z4_PORSOFT) / 100     //Percentual de Sofware 
						nPorHdw := Iif(SZ4->Z4_PARHW>0,SZ4->Z4_PARHW,SZ4->Z4_PORHARD) / 100     //Percentual de Hardware	 
					EndIf		 
				Elseif "CONTROLE DE VENDAS - CACB" $ UPPER(SZ5->Z5_DESREDE) .And. SZ5->Z5_BLQVEN != "0" .And. SZ4->Z4_PARSW > 0 
					nPorSfw := SZ4->Z4_PARSW / 100     //Percentual de Sofware 
					nPorHdw := SZ4->Z4_PARHW / 100     //Percentual de Hardware 
				Elseif nI == 2 .And. !Empty(cCodAr) .And. cQuebra == "2" 
					aAreaSZ4  := SZ4->(GetArea()) 
					nPorSfw := SZ4->Z4_PORSOFT / 100     //Percentual de Sofware 
					nPorHdw := SZ4->Z4_PORHARD / 100     //Percentual de Hardware 
					SZ4->( DbSetOrder(1) )	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD 
					If SZ4->(MsSeek( xFilial("SZ4") + cCodAr + cCatProd )) 
						nPorSfw := 0.03     //Percentual de Sofware 
						nPorHdw := 0.02     //Percentual de Hardware 
					Endif 
					RestArea(aAreaSZ4) 
				//Renato Ruy - 16/04/2018 
				//018040910002781 - Regra para percentual diferenciado 
				//Yuri Volpe - 25/10/2018 
				//2018101910002811 - Regra Facesp [Inclus?o dos grupos FPBRA, FPBRB, FPBRC] 
				//2018102310004571 - Regra Facesp - % diferenciado [Condi??o: Boa Vista e fora da Rede Facesp] 
				Elseif ("BOA VISTA" $ UPPER(SZ5->Z5_DESGRU) .Or. "ACP PR" $ UPPER(SZ5->Z5_DESGRU) .Or. "PBRA" $ UPPER(SZ5->Z5_DESGRU) .Or.	"PBRB" $ UPPER(SZ5->Z5_DESGRU) .Or. ; 
						"PBRC" $ UPPER(SZ5->Z5_DESGRU)) .And. SZ4->Z4_PARSW>0 .And. nI == 1  .And. Empty(SZ5->Z5_PEDGANT) .And. AllTrim(SZ5->Z5_TIPVOU) != 'H' .AND. !'RENOVACAO' $ UPPER(SZ5->Z5_DESGRU) .And. ; 
						!("BOA VISTA" $ UPPER(SZ5->Z5_DESGRU) .And. !"FACESP" $ UPPER(SZ3->Z3_DESAC)) 
					//nPorSfw := SZ4->Z4_PARSW / 100     //Percentual de Sofware 
					//nPorHdw := SZ4->Z4_PARHW / 100     //Percentual de Hardware 
					nPorSfw := 0.5     //Percentual de Sofware 
					nPorHdw := 0.4     //Percentual de Hardware 
					cObserva := " - "+AllTrim(SZ5->Z5_GRUPO)+" - Perc.Diferenciado" 
					lFCSPCalc := .T. 
				//Yuri Volpe - 12/12/2018 
				//OTRS 2018112810000803 - Regra FACESP para calcular Remuneração quando h? Renova??o  
				ElseIf nI == 7 .And. AllTrim(cCodAc) == "FACES" .And. (!Empty(SZ5->Z5_PEDGANT) .Or. SZ5->Z5_TIPVOU == "H" .Or. "RENOVACAO" $ Upper(SZ5->Z5_DESGRU)) 
					nPorSfw := 0.5 //SZ4->Z4_PORSOFT / 100 
					nPorHdw := 0.4 //SZ4->Z4_PORHARD / 100 
				//Yuri Volpe - 14.10.2019 
				//OTRS 2019101410002891 - Percentual AC Sincor_setembro.19 quando conectividade social, deve usar percentual de "campanha" 
				ElseIf nI == 2 .And. PA8->PA8_CATPROD == "09" .And. AllTrim(SZ3->Z3_CODENT) == "SIN" 
					aAreaSZ4  := SZ4->(GetArea()) 
					SZ4->( DbSetOrder(1) )	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD 
					If SZ4->(MsSeek( xFilial("SZ4") + SZ3->Z3_CODENT + cCatProd )) 
						nPorSfw := SZ4->Z4_PORSOFT / 100     //Percentual de Sofware 
						nPorHdw := SZ4->Z4_PORHARD / 100     //Percentual de Hardware 
					Endif 
					RestArea(aAreaSZ4)			 
				Else 
					nPorSfw := SZ4->Z4_PORSOFT / 100     //Percentual de Sofware 
					nPorHdw := SZ4->Z4_PORHARD / 100     //Percentual de Hardware 
				EndIf 
				
				// Solicitante: Priscila - 23/07/15 
				// Passou a utilizar o percentual para abater encima o valor desmembrado. 
				If nI == 1 
					nAbtAR := nPorSfw 
				Elseif nI == 2 
					nAbtAC := nPorSfw 
				//Yuri Volpe - 24.01.2018  
				//OTRS 2019012310002793 - Incluir abatimento aos canais do que foi pago ?s ARs  
				//ElseIf nI == 3 .Or. nI == 4  
				// 	nAbtAR := nPorSfw 
				EndIf 
				
				// 2- Tratar Base de c?lculo e valores de comiss?o fixos por produtos 
				//If !(SZ3->Z3_CODENT $ cOABSP) .And. SZ5->Z5_VALOR <> nValOAB//Tratamento efetuado para entidade OAB-SP quando o valor for num total de R$ 77.50 
				//Trata valor fixo de comiss?o por produto 
				//Alguns produtos tem valor de comiss?o fixo. Mas para isso a na entidade deve indicar usar regra do produto. 
				If (SZ3->Z3_RGVLPRD == "1" .And. PA8->PA8_VLSOFT <> 0 ) .And. !lMidiaAvulsa .And. lGerReem//.And. (nI == 1 .Or. nI == 2 .Or. nI == 3 .Or. nI == 4)) 
					nValTotSW  := 0 
					nValTotHW  := 0 
					nBaseSw := PA8->PA8_VLSOFT 
					nBaseHw := 0 
				Else 
					//Trata produtos de Conectividade social. 
					//Solicitante: Priscila - Data: 16/03/15 - Aglutina valores para Conectividade e mant?m valores para outros 
					DbSelectArea("PA8") 
					DbSetOrder(1) 
					DbSeek( xFilial("PA8") + PadR(AllTrim(SZ5->Z5_PRODGAR),32," ") ) //Me posiciono no produto para verificar se e conectividade 
					
					//IF '18' $ SZ5->Z5_PRODGAR .or. 'SIMPLES'$UPPER(SZ5->Z5_DESPRO) //Se o produto ? conectividade social. 
					//If PA8->PA8_PRDCON == "S" .And. !(cCodCanal $ "CA0001/CA0002" .And. nI == 4) //25/06/2015 - Giovanni 
					If PA8->PA8_PRDCON == "S" .And. !(cCodCanal $ "CA0001/CA0002" .And. nI == 3) 
						nValTotSW:= nValTotSW +nValTotHW 
						nValTotHW:= 0 
					//ElseIf PA8->PA8_PRDCON == "S" .And. cCodCanal $ "CA0001/CA0002" .And. nI == 4  //25/06/2015 - Giovanni 
					//Renato Ruy - 23/09/2016 - Somente produtos que tem Hardware ser?o considerados. 
					//Solicitante: Suzane Santana - 19/10/16 
					//Somente Produto com Hardware e a regra do valor ser? desconsiderada. 
					ElseIf PA8->PA8_PRDCON == "S" .And. "CONECTIVIDADE" $ Upper(SZ5->Z5_DESPRO) .And. cCodCanal $ "CA0001/CA0002" .And.; 
						lTemHard .And. nI == 3 .And. lGerReem 
						If nValTotSW +nValTotHW == 155 .Or. nValTotSW +nValTotHW == -155 
							nValTotSW:= Iif(nValTotSW +nValTotHW>0, 46.5, -46.5)  
							nValTotHW:= 0 
						ElseIf nValTotSW +nValTotHW == 165 .Or. nValTotSW +nValTotHW == -165 
							nValTotSW:= Iif(nValTotSW +nValTotHW>0, 56.5, -56.5) 
							nValTotHW:= 0 
						ElseIf nValTotSW +nValTotHW == 175 .Or. nValTotSW +nValTotHW == -175 
							nValTotSW:= Iif(nValTotSW +nValTotHW>0, 66.50, -66.50) 
							nValTotHW:= 0 
						ElseIf nValTotSW +nValTotHW == 185 .Or. nValTotSW +nValTotHW == -185 
							nValTotSW:= Iif(nValTotSW +nValTotHW>0, 76.50, -76.50) 
							nValTotHW:= 0 
						ElseIf nValTotSW +nValTotHW == 189 .Or. nValTotSW +nValTotHW == -189 
							nValTotSW:= Iif(nValTotSW +nValTotHW>0, 56.65, -56.65) 
							nValTotHW:= 0 
						ElseIf nValTotSW +nValTotHW ==  197.1 .Or. nValTotSW +nValTotHW == -197.1 
							nValTotSW:= Iif(nValTotSW +nValTotHW>0, 64.75, -64.75) 
							nValTotHW:= 0 
						ElseIf nValTotSW +nValTotHW == 199 .Or. nValTotSW +nValTotHW == -199 
							nValTotSW:= Iif(nValTotSW +nValTotHW>0, 66.65, -66.65) 
							nValTotHW:= 0 
						ElseIf nValTotSW +nValTotHW == 209 .Or. nValTotSW +nValTotHW == -209 
							nValTotSW:= Iif(nValTotSW +nValTotHW>0, 76.65, -76.65) 
							nValTotHW:= 0 
						ElseIf nValTotSW +nValTotHW == 219 .Or. nValTotSW +nValTotHW == -219 
							nValTotSW:= Iif(nValTotSW +nValTotHW>0, 86.65, -86.65) 
							nValTotHW:= 0 
						Else 
							nValTotSW+= nValTotHW 
							nValTotHW:= 0 
						EndIf 
						
					Endif 
					
					//Trata Voucher 
					//Se Posiciona SZF, se existir pedido, faz loop 
					//Busca valor do pedido anterior. 
					// H = Voucher de renova?ao automatica 
					// B = Substitui??o de voucher 
					//Verifica se pedido de origem do voucher foi verificado, est? rejeitado ou pronto para emitir. Nestes casos não paga comiss?o pois foi pago anteriormnete 
					If !Empty(SZ5->Z5_CODVOU) .And. AllTrim(SZ5->Z5_TIPVOU) != "H" 
						
						DbSelectArea("SZF") 
						DbSetOrder(2) 
						If DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU) 
						
							// Renato Ruy - 08/11/2016 
							// Voucher de Vendas Canais 
							// Cliente: 787334 - MINC ADMINISTRACAO E CORRETORA DE SEGUROS LTDA EPP 
							// Valor: 30,00 e Produto: SRFA3PFSCHV2 ou Valor: 100,00 e Produto: ACMA1SERVERHV2 
							// Os valores ser?o zerados. 
							If AllTrim(SZ5->Z5_TIPVOU) == "E" .And. SZF->ZF_CODCLI == "787334" 
								
								If (SZF->ZF_VALOR == 30 .And. "SRFA3PFSCHV2" $ SZF->ZF_PDESGAR) .Or. (SZF->ZF_VALOR == 100 .And. "ACMA1SERVERHV2" $ SZF->ZF_PDESGAR) 
									cProMinc := " - Licita??o AR Minc - não remunerado" 
									nValTotSw := 0 
									nValTotHw := 0 
								Endif 
								
							Endif 
							
							If AllTrim(SZ5->Z5_TIPVOU) == "M" .And. nValTotSw+nValTotHw == 0 
								aAreaZ5Vou := SZ5->(GetArea()) 
								SZ5->(dbSetOrder(1)) 
								If !Empty(SZF->ZF_PEDIDO) .And. SZ5->(dbSeek(xFilial("SZ5") + SZF->ZF_PEDIDO)) 
									nValTotSw := SZ5->Z5_VALOR 
								Else 
									nValTotSw := SZF->ZF_VALOR 
								EndIf 
								RestArea(aAreaZ5Vou) 
							EndIf 
							
							If !Empty(aStatus[1]) 
								nValTotSw := 0 
								nValTotHw := 0 
								lNaoPagou := .F. 
								lOriCupom:= Iif(aStatus[1] == "NAOPAG",.T.,.F.) 
							EndIf 
							
						EndIf 
					EndIf 
					
					//Tratamento OAB SP E Valor igual a 77,50 e pertenca a OAB SP e zerado ou tipo de voucher cortesia/funcionario. 
					//Renato Ruy - 24/06/2016 
					//OTRS: 2016062010000886 - Zera os valores do CCR 072855 e Descricao do projeto cont?m PSAR SECOVI. 
					//Yuri Volpe - 04/01/2018  
					//OTRS 2018112810000778 - Remunerar PSAR SECOVI quando for RENOVA??O 
					If (AllTrim(SZ5->Z5_PRODGAR) $ "OABA3PFSCHV2/OABA3PFSCRNHV2/OABA3PFISCHV5/OABA3PFISCRNHV5" .And.; 
					(nValTotSW +nValTotHW == 77.5 .Or. nValTotSW +nValTotHW == 85 .Or.; 
						nValTotSW +nValTotHW == 72 .Or. nValTotSW +nValTotHW == 95) .And.; 
						cCodCcr == "054599") .OR. AllTrim(SZ5->Z5_TIPVOU) $ "1/3/7/8" .Or. cZera == "S" .or.; 
						("FACIAP" $ Upper(SZ5->Z5_DESGRU) .And. AllTrim(SZ5->Z5_GRUPO) == "FACIA") 
						nValTotSw  	:= 0 
						nValTotHw  	:= 0 
						cProMinc 	:= " - PEDIDO NAO REMUNERADO" 
						lPedNoRem	:= .T. 
					//Yuri Volpe - 05/08/2019 
					//OTRS 2019080210003087 - incluir o grupo Psar Certipe como voucher de origem não remunerada 
					//Yuri Volpe - 06/08/2019 
					//OTRS 2019080610003721 -  vouchers do grupo "Auditoria Pre-Op " e devem ter a informa??o de "origem não remunerada				  
					ElseIf ("PSAR CERTIPE" $ Upper(SZ5->Z5_DESGRU) .And. cCodCCR == "087735") .Or. "AUDITORIA PRE-OP" $ Upper(SZ5->Z5_DESGRU) .Or. "GRUPO INOVACAO CERTISIGN" $ Upper(SZ5->Z5_DESGRU) .Or.; 
							"PSAR PROJETO BRY" $ Upper(SZ5->Z5_DESGRU) .Or. "PSAR AGILIZA" $ Upper(SZ5->Z5_DESGRU) .Or. ; 
							(cCodCCR == "072855" .And. "PSAR SECOVI" $ UPPER(SZ5->Z5_DESGRU)) .Or. (("EGBA" $ UPPER(SZ5->Z5_DESPRO)) .And. cCodCCR == "071032") 
						nValTotSw  	:= 0 
						nValTotHw  	:= 0 
						cProMinc 	:= " - VOUCHER ORIGEM NAO REMUNERADO" 
						lProFunc	:= .T. 
					//Renato Ruy - 13/06/2018 
					//OTRS: 2018061210001137 - Regra para produto OABA3PFSCHV2 e Grupo GAOAB 
					Elseif AllTrim(SZ5->Z5_PRODGAR) $ "OABA3PFISPSCHV5/OABA3PFSCRNHV2" .And. AllTrim(SZ5->Z5_GRUPO) == "GAOAB" .And. AllTrim(cCodCCR) == "054599" 
						nValTotSw  	:= 0 
						nValTotHw  	:= 0 
						cProMinc 	:= " - PEDIDO NAO REMUNERADO" 
						lPedNoRem	:= .T. 
					//Renato Ruy - 12/09/2017 
					//Separada regra para produto e voucher funcionario. 
					Elseif 	AllTrim(SZ5->Z5_PRODGAR) $ 'SRFA3PFSCFUNCHV2/SRFA3PFSLFUNCHV2/SRFA1PFMBFUNCHV2' .OR.; 
							AllTrim(SZ5->Z5_TIPVOU) $ "6/G" 
						nValTotSw  	:= 0 
						nValTotHw  	:= 0 
						lProFunc	:= .T. 
					ElseIf AllTrim(SZ5->Z5_PRODGAR) == "OABA3PFSCHV2" .And. nValTotSW +nValTotHW == 99 
						nValTotSW:= 115 
						nValTotHW:= 0 
					ElseIf AllTrim(SZ5->Z5_PRODGAR) == "OABA3PFLEHV2" .And. nValTotSW +nValTotHW == 219 
						nValTotSW:= 115 
						nValTotHW:= 120 
					ElseIf AllTrim(SZ5->Z5_PRODGAR) $ "/OABA3PFLEHV2/OABA3PFTOHV2/" .And. nValTotSW +nValTotHW == 235 
						nValTotSW:= 115 
						nValTotHW:= 120 
					ElseIf AllTrim(SZ5->Z5_PRODGAR) $ "/OABA3PFLEHV2/OABA3PFTOHV2/" .And. nValTotSW +nValTotHW == 240 
						nValTotSW:= 120 
						nValTotHW:= 120 
					//Renato Ruy - 08/01/2018 
					//2018010510001598 - Regra de Remuneração para projeto AC JUS e CNJ 
					//Solicitante: Priscila Kuhn com autoriza??es 
					Elseif RTRIM(UPPER(SZ5->Z5_DESGRU)) $ "PSAR CAMPANHA AC JUS/PSAR CONSELHO NACIONAL DE JUSTICA - CNJ" .And. RTRIM(SZ5->Z5_PRODGAR) $ "ACJIA3PFSC2AHV5/ACJPPA3PFSC2AHV5" 
						nValTotSw := 0 
						nValTotHw := 0  
						lACJUS	  := .T. 
						lPedNoRem := .T. 
					EndIf 
					
					//Priscila Kuhn - OTRS: 2015040210000915 - 02/14/2015 
					//Abater valores da Campanha quando especificado no Posto 
					//Cancelado 06/04/15 - Solicitante: T?nia 
					//Solicitado novamente pela Priscila e e-mail encaminhado pelo Giovanni - 16/06/2015 
					nAbtCamH := 0 
					nAbtCamS := 0 
					
					//Tratamento para não descontar de todas as redes o valor da campanha nos casos de renovação 
					cAcPropri := "" 
					//Priscila Kuhn - 14/07/15 
					//Somente quando for informado ser? descontado. 
					/* 
					If !Empty(SZ5->Z5_DESREDE) .And. !Empty(SZ5->Z5_PEDGANT) 
					cAcPropri := CRR20RD(SZ5->Z5_DESREDE) 
					cAbateCamp := Iif(cAcPropri $ "BR/SIN/NOT","S","N") 
					EndIf 
					*/ 
					
					// Solicitante: Priscila Kuhn - 06/08/2015 
					// Somente abate campanha para BR/Sincor e Notarial 
					cAcPropri := CRR20RD(SZ5->Z5_DESREDE) 
					If !(cAcPropri $ "BR/BRC/SIN/NOT/SINRJ/FACES/FENCR") .And. (!Empty(SZ5->Z5_PEDGANT) .OR. AllTrim(SZ5->Z5_TIPVOU) == 'H') .And. !('BR CRED' $ Upper(SZ5->Z5_DESREDE)) 
						cAbateCamp := "N" 
					EndIf 
					
					If cAbateCamp == "S" .And. nI != 6 .And. ("DO CONTADOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "ENTIDADE DE CLASSE" $ UPPER(SZ5->Z5_DESREDE)) .And.; 
						SZ5->Z5_COMSW > 0 .And. SZ5->Z5_BLQVEN != "0" 
						nAbtCamH :=  (nValTotHW * SZ5->Z5_COMSW) / 100 
						nAbtCamS :=  (nValTotSW * SZ5->Z5_COMSW) / 100 
					EndIf 
					// Fim - Priscila Kuhn - OTRS: 2015040210000915 - 02/14/2015 
					
					//OTRS:2017101910000959 - Priscila Kuhn  
					//Abatimento da AR no calculo 
					If (nI == 3 .Or. nI == 4) .And. cQuebra=="2" 
						
						cAbateCamp := "S" 
						cAcPropri := CRR20RD(SZ5->Z5_DESREDE) 
						If !(cAcPropri $ "BR/BRC/SIN/NOT/SINRJ/FACES/FENCR") .And. (!Empty(SZ5->Z5_PEDGANT) .OR. AllTrim(SZ5->Z5_TIPVOU) == 'H') .And. !('BR CRED' $ Upper(SZ5->Z5_DESREDE)) 
							cAbateCamp := "N" 
						EndIf 
						//Busca o cadastro de percentuais da AR 
						If nValTotSw > 0 
							aAreaSZ4  := SZ4->(GetArea()) 
							If SZ4->(DbSeek(xFilial("SZ4")+cCodAr+cCatProd)) 
								nAbtCart := SZ4->Z4_PORSOFT/100 
							Endif 
							RestArea(aAreaSZ4) 
						EndIf 
						//Se tem campanha ou não tem AR preenchido zera 
						If (cAbateCamp == "S" .And. nI != 6 .And. ("DO CONTADOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "ENTIDADE DE CLASSE" $ UPPER(SZ5->Z5_DESREDE)) .And.; 
							SZ5->Z5_COMSW > 0 .And. SZ5->Z5_BLQVEN != "0") .Or. Empty(cCodAr) 
							nAbtCart := 0 
						EndIf 
		
					Endif 
					//Fim da nova regra de abatimento. 
					
					//Yuri Volpe - 25/02/2019 
					//OTRS 2019012310002757 - Desconto Biometria 
					//Yuri Volpe - 23.01.2020 
					//OTRS 2020012310000809 - Biometria para o Canal - Remove c?lculo de biometria das ACs, exceto as controladas na SZ3					 
					nValBio := 0 
					lBioCanal := .F. 
					If SZ4->(FieldPos("Z4_VALBIO")) > 0 .And. GetNewPar("MV_XBIOATV","N") == "S"  
						If SZ4->Z4_VALBIO > 0 .And. SZ3->Z3_BIO == "S" 
							nValBio := SZ4->Z4_VALBIO 
							lBioCanal := .T. 
						EndIf 
					Else 
						If AllTrim(cCodAc) $ "SIN" .And. !AllTrim(cCodAC) == "SINRJ" .And. lGerReem 
							if ! ( cCodCCR $ "054403/054553/054924" ) .and. !( "REG" $ AllTrim(SZ5->Z5_PRODGAR) ) .and. !lDescred
								nValBio := 10 
								lBioCanal := .T. 
							endif
						EndIf 
					EndIf 
					
					//Caso seja Canal 1 ou 2 e esteja determinado na AC, faz abatimento do valor de softw pagos para  rede e CCR. 
					//O Valor de abatimento de imposto ? calculado sobre o total independente da entidade 
					// Renato Ruy - 30/06/15 - Adicionei as vari?veis nAbtCamH e nAbtCamS para fazer o abatimento da campanha do contato 
					If (nI == 3 .Or. nI == 4) .And. cAbateCcrAC == "1" 
						//Solicitante: Priscila Kuhn - 23/07/15 
						//Calcula o desconto no valor base, não soma valor pago para AR e AC. 
						PA8->( DbSetOrder(1) ) 
						
						If PA8->(MsSeek(xFilial("PA8")+SZ5->Z5_PRODGAR)) .And. SZ5->Z5_DATPED >= CtoD("01/12/15") .And.; 
							nValTotSw <> 0 .And. !("SERVER" $ SZ5->Z5_PRODGAR .Or. "OAB" $ SZ5->Z5_PRODGAR .Or.; 
							(PA8->PA8_PRDCON == "S" .And. ("CONECTIVIDADE" $ Upper(SZ5->Z5_DESPRO) .Or. "SIMPLES" $ UPPER(PA8->PA8_DESBPG) .Or.; 
							"SMART CARD E LEITORA VALIDADE 3 ANOS" $ UPPER(PA8->PA8_DESBPG) )) ) .And.; 
							AllTrim(SZ3->Z3_CODENT) $ "CA0001/CA0002" .And. !(AllTrim(SZ5->Z5_PRODGAR) $ "ACMA3PJNFECSRHV2/ACMA1PJSECCSRHV2") .And.; 
							(!(AllTrim(Upper(SZ5->Z5_DESGRU)) == "GRUPO SAGE") .And. AllTrim(SZ5->Z5_GRUPO) != "GSAGE") .And. (!"SAGE" $ Upper(SZ5->Z5_PRODGAR)) 
											
							//Solicitante: Suzane Santana - Autorizado por: Edson Tsukamoto 
							//Data: 16/02/2016 
							//Validação para não abater valor de pedido e Voucher quando o pedido anterior ? inferior que 01/12/15 
							If !Empty(SZ5->Z5_CODVOU) .and. AllTrim(SZ5->Z5_TIPVOU) != "H" 
									
									//Renato Ruy - 24/07/2017 
									//Utiliza funcao anterior para validar se a data e maior que 01/12/15 
									If (aStatus[2] >= CtoD("01/12/15") .Or. (Empty(aStatus[2]) .And. SZ5->Z5_DATPED >= CtoD("01/12/15"))) .And. !("PSAR" $ Upper(SZ5->Z5_DESGRU)) .And. (nValTotSW+nValTotHW < -14 .Or. nValTotSW+nValTotHW > 14) 
										//Renato Ruy - 17/09/2018 
										//Quando AR não pertence a AC que abate biometria 
										If AllTrim(cCodAC) $ "BR/BRC/BRC/SIN/NOT/SINRJ/FACES/FENCR" 
											nAbtAR  := (Iif(!lGerReem,nValTotSw + nValBio,nValTotSw - nValBio)) * nAbtAR 
										Else 
											nAbtAR  := nValTotSw * nAbtAR									 
										Endif 
										nAbtAC  := (Iif(!lGerReem,nValTotSw + nValBio,nValTotSw - nValBio)) * nAbtAC 
										cTiped	:= Iif(lBioCanal,"BIOMETRIA","") 
									Else 
										nAbtAR  := nValTotSw * nAbtAR 
										nAbtAC  := nValTotSw * nAbtAC 
									EndIf 
								
							ElseIf (Empty(SZ5->Z5_TIPVOU) .OR. AllTrim(SZ5->Z5_TIPVOU) == "H") .And. ((nValTotSW+nValTotHW < -14 .Or. nValTotSW+nValTotHW > 14) .Or. nValTotSW+nValTotHW < 0) .And. !"PSAR" $ Upper(SZ5->Z5_DESGRU) 
								//Renato Ruy - 17/09/2018 
								//Quando AR não pertence a AC que abate biometria 
								If AllTrim(cCodAC) $ "BR/BRC/SIN/NOT/SINRJ/FACES/FENCR" 
									nAbtAR  := (Iif(!lGerReem,nValTotSw + nValBio,nValTotSw - nValBio)) * nAbtAR 
								Else 
									nAbtAR  := nValTotSw * nAbtAR 
								Endif 
								nAbtAC  := (Iif(!lGerReem,nValTotSw + nValBio,nValTotSw - nValBio)) * nAbtAC	 
							Else 
								nAbtAR  := nValTotSw * nAbtAR 
								nAbtAC  := nValTotSw * nAbtAC					 
							EndIf 
							
						Else 
							nAbtAR  := nValTotSw * nAbtAR 
							nAbtAC  := nValTotSw * nAbtAC 
						EndIf 
						
						//RENATO RUY - 17/09/2018 
						//RETIRAR ABATIMENTO DA BIOMETRIA DO CARTORIO 
						If AllTrim(cCodAC) $ "BR/BRC/SIN/NOT/SINRJ/FACES/FENCR" 
							nAbtCart:= (Iif(!lGerReem,nValTotSw + nValBio,nValTotSw - nValBio)) * nAbtCart	 
						Else 
							nAbtCart:= nValTotSw * nAbtCart 
						Endif 
						
						//RENATO RUY - 17/09/2018 
						//ABATER VALOR FIXO PARA CNJ 
						If 	RTRIM(UPPER(SZ5->Z5_DESGRU)) $ "PSAR CONSELHO NACIONAL DE JUSTICA - CNJ/PSAR CNJ" .And.; 
							nAbtAR >= 0 .And. nAbtAR < 20 .And. (nValTotSw + nValTotHw <> 0) 
							nAbtAR := 20 
						Endif 
						
						nAbtImp := nValTotSw * (SZ4->Z4_IMPSOFT / 100) 
						nBaseSw := nValTotSw - nAbtAC- nAbtAR - Iif(cAbateCamp=="S",0,nAbtCart) - nAbtImp - nAbtCamS 
						nBaseHw := (nValTotHw - (nValTotHw * SZ4->Z4_IMPHARD/ 100)) - nAbtCamH 
						
						If aStatus[1] $ "PNOPAG/NAOPAG/PAGANT" 
							nBaseSw := 0 
							nBaseHw := 0 
						EndIf 
						
					Else 
						nBaseSw := (nValTotSw - (nValTotSw * SZ4->Z4_IMPSOFT / 100)) - nAbtCamS 
						nBaseHw := (nValTotHw - (nValTotHw * SZ4->Z4_IMPHARD / 100)) - nAbtCamH 
					EndIf 
					
					//Retira-se em seguida o imposto de renda 
					If !Empty(SZ4->Z4_PORIR) //.AND. Empty(cCodParc) 
						nBaseSw	:= nBaseSw - (nBaseSw * SZ4->Z4_PORIR / 100) 
						nBaseHw	:= nBaseHw - (nBaseHw * SZ4->Z4_PORIR / 100) 
					Endif 
					
					// Solicitante: Priscila Kuhn - 29/12/2015 
					// Desconta biometria para calculo do valor do SW para NOT, REG, SIN e SINRJ. 
					// não ser?o considerados os produtos Conectividade 18 meses/ E-Simples / OAB / SERVEREG 
					// Somente Verifica??o e renovação 
					// Considera atrav?s da data do Pedido (Z5_DATPED) maior ou igual 01/12/2015. 
					If nI == 1 
						//Armazeno recno da entidade atual. 
						nRecEnt := SZ3->(Recno()) 
						
						SZ3->(DbSetOrder(4)) 
						SZ3->(DbSeek(xFilial("SZ3")+SubStr(SZ5->Z5_CODPOS,1,6))) 
						
					EndIf 
	
					//Yuri Volpe - 25/02/2019 
					//OTRS 2019012310002757 - Desconto Biometria 
					//Yuri Volpe - 23.01.2020 
					//OTRS 2020012310000809 - Biometria para o Canal - Remove c?lculo de biometria das ACs, exceto as controladas na SZ3				 
					nValBio := 0 
					lBioCanal := .F. 
					If SZ4->(FieldPos("Z4_VALBIO")) > 0 .And. GetNewPar("MV_XBIOATV","N") == "S" 
						If SZ4->Z4_VALBIO > 0 .And. SZ3->Z3_BIO == "S" 
							nValBio := SZ4->Z4_VALBIO 
							lBioCanal := .T. 
						EndIf 
					Else 
						If AllTrim(cCodAc) $ "SIN" .And. !AllTrim(cCodAC) == "SINRJ" .And. lGerReem 
							if ! ( cCodCCR $ "054403/054553/054924" ) .and. !( "REG" $ AllTrim(SZ5->Z5_PRODGAR) ) .and. !lDescred
								nValBio := 10 
								lBioCanal := .T. 
							endif
						EndIf 
					EndIf 
					
					PA8->( DbSetOrder(1) ) 
					If PA8->(MsSeek(xFilial("PA8")+SZ5->Z5_PRODGAR)) .And. SZ5->Z5_DATPED >= CtoD("01/12/15") .And.; 
						nBaseSw <> 0 .And. !(AllTrim(Str(nI)) $ "3/4") .And. !("SERVER" $ SZ5->Z5_PRODGAR .Or. "OAB" $ SZ5->Z5_PRODGAR .Or.; 
						(PA8->PA8_PRDCON == "S" .And. ("CONECTIVIDADE" $ Upper(SZ5->Z5_DESPRO) .Or. "SIMPLES" $ UPPER(PA8->PA8_DESBPG) )) ) .And. !(AllTrim(SZ5->Z5_PRODGAR) $ "ACMA3PJNFECSRHV2/ACMA1PJSECCSRHV2") .And.; 
						((AllTrim(SZ3->Z3_CODENT) $ "BR/BRC/SIN/SINRJ/NOT/FENCR" .OR. AllTrim(SZ3->Z3_CODAC) $ "BR/BRC/SIN/SINRJ/NOT/FENCR") .And. AllTrim(cCodCCR) != "084511" .And.; 
						!((AllTrim(SZ3->Z3_CODAC) == "FEN") .Or. AllTrim(SZ3->Z3_CODENT) == "FEN")) .And. ; 
						((Ni == 7 .And. nPorSfw <> 0.1) .Or. (Ni <> 7)) .And. ; 
						(!(AllTrim(Upper(SZ5->Z5_DESGRU)) == "GRUPO SAGE") .And. AllTrim(SZ5->Z5_GRUPO) != "GSAGE") .And. (!"SAGE" $ Upper(SZ5->Z5_PRODGAR)) .And.; 
						cCatProd != "02" 
						//Yuri Volpe - 07/02/2019 
						//OTRS 2019020510006062 - Removido c?lculo de biometria quando calculando FACESP REVENDEDOR PROVIS?RIO 
						//Yuri Volpe - 04/04/2019 
						//OTRS 2019040310004055 - Inserido regra para desconsiderar calculo de AR e percentual diferente de 10% 
						//Yuri Volpe - 06/05/2019 
						//OTRS 2019050310003812 - Inserida regra para ignorar pedidos FENACON 
						//OTRS 2019050310003812 - Inserida regra para ignorar Grupo SAGE 
						//OTRS 2019050310003812 - Inserida regra para ignorar produtos de categoria 02 - Servidor  
						
						//"ACMA3PJNFECSRHV2" - Produto servidor e nao contem na Descrição 
						//("NOT" $ SZ5->Z5_PRODGAR .OR. "REG" $ SZ5->Z5_PRODGAR .OR. "SIN" $ SZ5->Z5_PRODGAR) .And.; 
						
						//Solicitante: Suzane Santana - Autorizado por: Edson Tsukamoto 
						//Data: 16/02/2016 
						//Validação para não abater valor de pedido e Voucher quando o pedido anterior ? inferior que 01/12/15 
						If !Empty(SZ5->Z5_CODVOU) .And. AllTrim(SZ5->Z5_TIPVOU) != "H" 
							
							//Renato Ruy - 24/07/2017 
							//Utiliza funcao anterior para validar se a data e maior que 01/12/15 
							If (aStatus[2] >= CtoD("01/12/15") .Or. (Empty(aStatus[2]) .And. SZ5->Z5_DATPED >= CtoD("01/12/15"))) .And. !("PSAR" $ Upper(SZ5->Z5_DESGRU)) .And. (nValTotSW+nValTotHW < -14 .Or. nValTotSW+nValTotHW > 14) 
								nBaseSw := Iif(!lGerReem,nBaseSw + nValBio,nBaseSw - nValBio) 
								cTiped	:= Iif(lBioCanal,"BIOMETRIA","") 
							EndIf 
							
						ElseIf (Empty(SZ5->Z5_TIPVOU) .OR. AllTrim(SZ5->Z5_TIPVOU) == "H") .And. !("PSAR" $ Upper(SZ5->Z5_DESGRU)) .And. (nValTotSW+nValTotHW < -14 .Or. nValTotSW+nValTotHW > 14) 
							nBaseSw := Iif(!lGerReem,nBaseSw + nValBio,nBaseSw - nValBio) 
							cTiped	:= Iif(lBioCanal,"BIOMETRIA","") 
						EndIf 
					EndIf 
					
					//Restauro a conexao na entidade anterior para postos. 
					If nI == 1 
						SZ3->(DbGoTo(nRecEnt)) 
					EndIf 
					
					// Fim da Alteração de biometria. 
					
					If !Empty(nPorSfw) 
						nValSw	:= nBaseSw * nPorSfw 
						//If Empty(cCodParc) 
						cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE SOFTWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
						//Else 
						//	cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE SOFTWARE - PARCEIRO) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
						//Endif 
					Else 
						nValSw	:= PA8->PA8_VLSOFT 
						cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (VALOR FIXO SOBRE SOFTWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
					Endif 
					
					//Para AC BV - Faz a cobranca 
					If AllTrim(SZ5->Z5_TIPVOU) $ "KL" 
	
						If aStatus[1] $ "PAGANT|NAOPAG" 
							
							nValTotSw:= 0 
							nValTotHw:= 0 
							nImpCamp:= 0 
							lNaoPagou := .F. 
							lOriCupom:= .F. 
						
						Else 
							
							aDadosBV	:= CRPA20BV() 
							nValSw		:= aDadosBV[1] * nPorSfw 
							nValHw		:= aDadosBV[2] * nPorHdw 
							nValTotSw 	:= aDadosBV[1] 
							nValTotHw 	:= aDadosBV[2] 
							nBaseSw		:= aDadosBV[1] 
							nBaseHw		:= aDadosBV[2] 
							cRegSw		:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (VALOR FIXO SOBRE SOFTWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ") 
							cProMinc	:= Iif(AllTrim(SZ5->Z5_TIPVOU) == "K","- FATURAMENTO BV","- ORIGEM CERTISIGN") 
							
						EndIf 
						
					Endif 
					
					//Solicitante: Priscila Kuhn - 24/07/2015 
					//Tratamento para zerar valor base de hardware do canal, para casos onde não tem percentual. 
					//Para HW Avulso não gera calculo sem percentual. 
					If nPorHdw <= 0 .And. (nI == 3 .Or. nI == 4) .And. cCodCanal != "CA0009" 
						nValTotHW := 0 
						nBaseHw	  := 0 
						If lMidiaAvulsa 
							Loop 
						EndIf 
					EndIf 
					
					If !Empty(nPorHdw) 
						nValHw	:= nBaseHw * nPorHdw 
						//If Empty(cCodParc) 
						cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE HARDWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
						//Else 
						//	cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE HARDWARE - PARCEIRO) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
						//Endif 
					Else 
						nValHw	:= SZ4->Z4_VALHARD 
						cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (VALOR FIXO SOBRE HARDWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
					EndIf 
					
					If lDescred .And. !( (AllTrim(cCodAC) == "SIN" .And. "SIN" $ SZ5->Z5_PRODGAR) .Or. (AllTrim(cCodAC) == "BR" .And. "REG" $ SZ5->Z5_PRODGAR) .Or. ; 
							(AllTrim(cCodAC) == "NOT" .And. "NOT" $ SZ5->Z5_PRODGAR) .Or. (AllTrim(cCodAC) == "FEN" .And. "FEN" $ SZ5->Z5_PRODGAR) .Or.; 
							(AllTrim(cCodAC) == "SINRJ" .And. "SINRJ" $ SZ5->Z5_PRODGAR)) 
						nValHw := 0 
						nValSw := 0 
						cProMinc += "DESCREDENCIADA" 
					EndIf 
					
					//Solicitante: Priscila Kuhn 
					//Quando o valor e maior que zero e menor que 20,00 e o projeto "PSAR Conselho Nacional de Justica - CNJ" ou "Psar CNJ". 
					//Para este parceiro tem valor fixo no calculo do Posto 
					If 	RTRIM(UPPER(SZ5->Z5_DESGRU)) $ "PSAR CONSELHO NACIONAL DE JUSTICA - CNJ/PSAR CNJ" .And.; 
						nValSw+nValHw != 0 .And. nValSw+nValHw < 20 .And. nI == 1 
						nValSw := Iif(!lGerReem,0-20,20)//se tem reembolso fica negativo 
						nValHw := 0 
						lCNJ := .T.	 
					Endif 
					
					If !lGerReem 
						nValTotHw 	:= Iif(aVlrPagos[1] > 0, 0-aVlrPagos[1], nValTotHw) 
						nValTotSw	:= Iif(aVlrPagos[2] > 0, 0-aVlrPagos[2], nValTotSw) 
						nBaseHw		:= Iif(aVlrPagos[3] > 0, 0-aVlrPagos[3], nBaseHw) 
						nBaseSw		:= Iif(aVlrPagos[4] > 0, 0-aVlrPagos[4], nBaseSw) 
						nValHw 		:= Iif(aVlrPagos[5] > 0, 0-aVlrPagos[5], nValHw)  
						nValSw 		:= Iif(aVlrPagos[6] > 0, 0-aVlrPagos[6], nValSw) 
					EndIF 
					
				EndIf 
			// Verificacao Camp.Contador / Clube do Revendedor 
			ElseIf nI == 6  .And. !Empty(SZ5->Z5_DESREDE) //.And. Empty(SZ5->Z5_PEDGANT) 
				nValTot  := 0 
				//nValTotSw:= 0 
				//nValTotHw:= 0 
				nPorSfw  := 0 
				lVouPag  := .F. 
				
				//cDescPrd:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
				// Solicita??o: Priscila - 24/09/14 - Produtos da Conectividade Social ser? realizado o Skip. 
				//Como não existe cadastro para campanha do contador, fa?o tratamento manual. 
				//If "/"+AllTrim(SZ5->Z5_CODPAR) +"/" $ "/0/72/75/89/90/99/101/102/206/253/262/270/335/335/337/356/440/463/468/555/567/568/586/913/999/1108/1186/1434/1435/1574" .OR. AllTrim(SZ5->Z5_CODVEND) = "19431" .OR. "CONECTIVIDADE SOCIAL DE 18 MESES" $ Upper(cDescPrd) 
				//Renato Ruy - 25/08/2015 
				//Tratamento para Bortolim, busco no cadastro de entidade e gravo se o tratamento sera atraves do cadastro da entidade. 
				SZ4->( DbSetOrder(1) ) 
				lCalcCam := SZ4->(DbSeek(xFilial("SZ4")+SubStr(SZ5->Z5_CODPAR,1,6) )) 
				
				If (!("DO CONTADOR" $ UPPER(SZ5->Z5_DESREDE)) .And.; 
					!("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE)) .And.; 
					!("ENTIDADE DE CLASSE" $ UPPER(SZ5->Z5_DESREDE)); 
				.And. !lCalcCam .And. !("GRUPO SAGE" $ Upper(SZ5->Z5_DESREDE))  ) .Or. SZ5->Z5_BLQVEN == "0" .Or. AllTrim(SZ5->Z5_PRODGAR) == "SRFA1PJ18PHV2" 
					CRPA020LOG(1,"não ? campanha",{{"Z5_DESREDE", SZ5->Z5_DESREDE}},"",ProcLine(),cUserName) 
					Loop 
				EndIf 
				
				//Gera Campanha do Contador 
				If "DO CONTADOR" $ UPPER(SZ5->Z5_DESREDE) .Or. lCalcCam .Or. "REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "ENTIDADE DE CLASSE" $ UPPER(SZ5->Z5_DESREDE) .Or.; 
						"GRUPO SAGE" $ Upper(SZ5->Z5_DESREDE)  
					nQtdReg	:= 0 
					nValSw  := 0 
					nValHw  := 0 
					nBaseSw := 0 
					nBaseHw := 0 
					nPorSfw := 0 
					nValTotSw := 0-nValTotSw 
					nValTotHw := 0-nValTotHw 
					cTipPar := Iif("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE),"10","7") 
					cCodPar := SZ5->Z5_CODPAR 
					cDesPar := Iif("FACESP" $ UPPER(SZ5->Z5_NOMPAR),"FACESP" ,SZ5->Z5_NOMPAR)   
					nValTotSw:= Iif(!lGerReem,0-nValTotSw,SZ5->Z5_VALORSW) 
					nValTotHw:= Iif(!lGerReem,0-nValTotHw,SZ5->Z5_VALORHW) 
					
					If "GRUPO SAGE" $ Upper(SZ5->Z5_DESREDE) 
						cTipPar := "10" 
					EndIf 
	
					//Renato Ruy - 24/06/16 
					//OTRS: 2016062010000886 - Zera os valores do CCR 072855 e Descricao do projeto cont?m PSAR SECOVI. 
					If (cCodCCR == "072855" .And. "PSAR SECOVI" $ UPPER(SZ5->Z5_DESGRU))// .Or. !lGerReem 
						nValTotSw:= 0 
						nValTotHw:= 0 
						CRPA020LOG(1,"PSAR SECOVI Zera Campanha",{{"cCodCCR",cCodCCR},{"Z5_DESGRU",SZ5->Z5_DESGRU}},'(cCodCCR == "072855" .And. "PSAR SECOVI" $ UPPER(SZ5->Z5_DESGRU))',procLine(),cUserName) 
					//Renato Ruy - 24/06/16 
					//OTRS: 2016061310002889 - Grupo Digitalseg não paga Remuneração por ter tabela de pre?os diferenciada. 
					//Renato Ruy - 06/09/2016 
					//Solicitada retirada da regra e abertura para aplica??o em produ??o. 
					//ElseIf "GRUPO DIGITALSEG" $ UPPER(SZ5->Z5_DESGRU) 
					//	nValTotSw:= 0 
					//	nValTotHw:= 0 
					EndIf 
					
					//Renato Ruy - 25/08/15 
					//Tratamento generico para entidades cadastradas na SZ3 
					If lCalcCam 
						
						SZ3->( DbSetOrder(1) ) 
						SZ3->(DbSeek(xFilial("SZ3")+SZ5->Z5_CODPAR)) 
						
						If PA8->PA8_PRDCON == "S" 
							nValTotSW:= nValTotSW +nValTotHW  
							nValTotHw:= 0 
						EndIf 
						
						nPorSfw  := SZ4->Z4_PORSOFT / 100 
						nImpCamp := nValTotSW * (SZ4->Z4_IMPSOFT / 100) 
	
						CRPA020LOG(0,"Pegou percentual campanha, condicao 1",{{"lCalcCam",cValToCHar(lCalcCam)},{"PA8_PRDCON",PA8->PA8_PRDCON},{"nPorSfw",cValToChar(nPorSfw)}},"lCalcCam",ProcLine(),cUserName) 
						
					ElseIf SZ5->Z5_COMSW > 0 
						nPorSfw := SZ5->Z5_COMSW / 100 
						CRPA020LOG(0,"Pegou percentual campanha, condicao 2",{{"Ni",Ni},{"SZ5->Z5_COMSW",cValToChar(SZ5->Z5_COMSW)},{"nPorSfw",cValToCHar(nPorSfw)}},"SZ5->Z5_COMSW > 0",ProcLine(),cUserName) 
					Elseif SZ5->Z5_COMHW > 0 
						nPorSfw := SZ5->Z5_COMHW / 100			 
						CRPA020LOG(0,"Pegou percentual campanha, condicao 3",{{"SZ5->Z5_COMHW",cValToChar(SZ5->Z5_COMHW)},{"nPorSfw",cValToCHar(nPorSfw)}},"SZ5->Z5_COMHW > 0",ProcLine(),cUserName) 
					Else 
						CRPA020LOG(1,"não encontrou percentual para c?lculo de campanha",{{"lCalcCam",cValToChar(lCalcCam)},{"SZ5->Z5_COMSW",cValToChar(SZ5->Z5_COMSW)},{"SZ5->Z5_COMHW",cValToChar(SZ5->Z5_COMHW)},{"SZ4->Z4_PORSOFT",cValToChAr(SZ4->Z4_PORSOFT)}},"ELSE",ProcLine(),cUserName) 
						cDesPar := "" //Quando não recebemos percentual do GAR, não calcula comiss?o para o revendedor. 
						lCalcAss := .F. 
					EndIf 
					cTipo	:= 'PARCEI' 
					
					//RENATO RUY - 14/11/2107 
					//OTRS: 2017102510000312 - CONTRATO ASSINADO ANEXO PARA AUTORIZA??O 
					//PAGAMENTO DE PERCENTUAL 7% PARA PROMOCAO DA NUVEMSIS 
					If RTrim(SZ5->Z5_PRODGAR) == 'SRFA1PJASSHV2' .And. SZ5->Z5_VALOR == 110 .And. 'NUVEMSIS' $ UPPER(SZ5->Z5_NOMPAR) 
					
						nPorSfw := 0.07 
						CRPA020LOG(0,"NUVEMSIS valor fixo, atribui 7%",{{"SZ5->Z5_PRODGAR",SZ5->Z5_PRODGAR},{"SZ5->Z5_VALOR",cValToCHar(SZ5->Z5_VALOR)},{"SZ5->Z5_NOMPAR",SZ5->Z5_NOMPAR}},"RTrim(SZ5->Z5_PRODGAR) == 'SRFA1PJASSHV2' .And. SZ5->Z5_VALOR == 110 .And. 'NUVEMSIS' $ UPPER(SZ5->Z5_NOMPAR)",ProcLine(),cUserName) 
					Endif 
					
					// Calcula Remuneração sobre venda 
					//If !(SZ3->Z3_CODENT $ cOABSP) .And. SZ5->Z5_VALOR <> nValOAB//Tratamento efetuado para entidade OAB-SP quando o valor for num total de R$ 77.50 
					
					//Renato Ruy - 25/08/15 
					//Tratamento generico para entidades cadastradas na SZ3 
					//Priscila Kuhn - 11/01/2016 
					//Desmembrar valor para campanha e clube. 
					/* 
					If lCalcCam 
					nValTot := nValTotSW 
					nValTotHW := 0 
					ElseIf SZ5->Z5_VALORSW > 0 .AND. SZ5->Z5_VALORHW > 0 .And. nValTot == 0 
					nValTot := SZ5->Z5_VALORSW + SZ5->Z5_VALORHW 
					ElseIf SZ5->Z5_VALOR > 0 .And. nValTot == 0 
					nValTot := SZ5->Z5_VALOR 
					ElseIf SZ5->Z5_VALORSW > 0 .And. nValTot == 0 
					nValTot := SZ5->Z5_VALORSW 
					ElseIf SZ5->Z5_VALORHW > 0  .And. nValTot == 0 
					nValTot := SZ5->Z5_VALORHW 
					
					Else 
					
					If !Empty(SZ5->Z5_CODVOU) 
					
					//Caso seja Voucher, se posiciona para retornar o valor 
					SZF->(DbSetOrder(2)) 
					SZF->(DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU)) 
					
					nValTot := SZF->ZF_VALOR 
					
					Else 
					
					SC5->(DbOrderNickName("NUMPEDGAR"))		 
					SC5->(DbSeek(xFilial("SC5")+SZ5->Z5_PEDGAR)) 
					
					nValTot := SC5->C5_TOTPED 
					
					EndIf 
					
					EndIf 
					*/ 
					
					//Se Posiciona SZF, se existir pedido, faz loop 
					//Busca valor do pedido anterior. 
					If !Empty(SZ5->Z5_CODVOU) .And. AllTrim(SZ5->Z5_TIPVOU) != "H" 
						DbSelectArea("SZF") 
						DbSetOrder(2) 
						//Renato Ruy - 12/08/16 - Validação para voucher 'F'. 
						lTemVouc := DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU) 
						If lTemVouc .And. AllTrim(SZ5->Z5_TIPVOU) != "F" 
							
							If PA8->PA8_PRDCON == "S" 
								//nValTot := nValTotHW + nValTotSW 
								nValTotSw:= nValTotHW + nValTotSW 
								nValTotHw:= 0 
								//Else 
								//	nValTot := nValTotSW 
							EndIf 
							
							// Renato Ruy - 08/11/2016 
							// Voucher de Vendas Canais 
							// Cliente: 787334 - MINC ADMINISTRACAO E CORRETORA DE SEGUROS LTDA EPP 
							// Valor: 30,00 e Produto: SRFA3PFSCHV2 ou Valor: 100,00 e Produto: ACMA1SERVERHV2 
							// Os valores ser?o zerados. 
						If AllTrim(SZ5->Z5_TIPVOU) == "E" .And. SZF->ZF_CODCLI == "787334" 
								
							If (SZF->ZF_VALOR == 30 .And. "SRFA3PFSCHV2" $ SZF->ZF_PDESGAR) .Or. (SZF->ZF_VALOR == 100 .And. "ACMA1SERVERHV2" $ SZF->ZF_PDESGAR) 
									cProMinc := " - Licita??o AR Minc - não remunerado" 
									nValTotSw := 0 
									nValTotHw := 0 
							Endif 
								
						Endif 
							
						//Renato Ruy - 24/07/2017 
						//Tratamento especifico dos voucher pagos para parceiros 
						If ALLTRIM(aStatus[3])=="4" .AND. "NUVEMSIS"$UPPER(SZ5->Z5_DESGRU) 
								lVouPag  := .T. 
							Elseif AllTrim(aStatus[3]) == "E" .And. "CERTIFIQUE ON LINE" $ UPPER(SZ5->Z5_NOMPAR) 
								lVouPag  := .T. 
						Endif 
							
							//Se o pedido atual pertencer ao voucher que não paga, zera o valor da campanha. 
							If (AllTrim(aStatus[3]) $ "1/3/5/6/7/C/D/N" .Or. (!lVouPag .And. AllTrim(aStatus[3]) $ "4/E/N")) .And. SZF->ZF_CAMPANH != "1" 
								//nValTot := 0 // Priscila - 26/09/14 - não faz loop, zera valor 
								nValTotSw:= 0 
								nValTotHw:= 0 
								nImpCamp:= 0  
								lNaoPagou := .F. 
								lOriCupom:= Iif(AllTrim(aStatus[3]) $ "1/3/4/5/6/7/C/D/E/N",.T.,.F.) 
							EndIf 
							
							//Solicitante: Priscila Kuhn - 14/09/15 
							//Somente o primeiro pedido verificado ser? pago. 
							If aStatus[1] $ "PAGANT|NAOPAG" 
								
								nValTotSw:= 0 
								nValTotHw:= 0 
								nImpCamp:= 0 
								lNaoPagou := .F. 
								lOriCupom:= .T. 
								
							EndIf 
						
						Elseif lTemVouc .And. AllTrim(SZ5->Z5_TIPVOU) == "F" .And. (SZF->ZF_CAMPANH == "2" .And. cTipPar$ "7/10") 
							nValTotSw:= 0 
							nValTotHw:= 0	 
						EndIf 
						
					EndIf 
					
					//Tratamento OAB SP E Valor igual a 77,50 e pertenca a OAB SP e zerado ou tipo de voucher cortesia/funcionario. 
					//Renato Ruy - 09/11/2017 
					// OTRS: 2017110710002281 - Autorizada pela diretoria 
					//Tratamento para não pagar alguns produtos OAB. 
					//OABA3PFISCHV5 e OABA3PFISCRNHV5  
					If (AllTrim(SZ5->Z5_PRODGAR) $ "OABA3PFSCHV2/OABA3PFSCRNHV2/OABA3PFISCHV5/OABA3PFISCRNHV5" .And.; 
					(nValTotSW +nValTotHW == 77.50 .Or. nValTotSW +nValTotHW == 85) .And. cCodCcr == "054599") .OR.; 
					AllTrim(SZ5->Z5_TIPVOU) $ "1/3/8/7/6/G" 
						//nValTot := 0 
						nValTotSw := 0 
						nValTotHw := 0 
						nImpCamp  := 0 
						lNaoPagou := .F. 
						lOriCupom:= Iif(AllTrim(SZ5->Z5_TIPVOU) $ "1/3/8/7/6/G",.T.,.F.) 
					EndIf 
					
					// Solicitante: Priscila Kuhn - 31/03/15 
					// Alteração para não pagar Remuneração produtos ECPF e que tenham valor de R$ 200 
					// Yuri Volpe - 04/01/18 
					// OTRS 2019010410002613 - Remo??o da Regra para valores de R$ 200 
					/*cDescProd := Upper(Posicione("PA8",1,xFilial("PA8")+PadR(AllTrim(SZ5->Z5_PRODGAR),32," "),"PA8_DESBPG")) 
					If "CPF" $ UPPER(cDescProd) .And. "SMART CARD" $ UPPER(cDescProd) .And. nValTotSW +nValTotHW == 200 
						//nValTot := 0 
						nValTotSw := 0 
						nValTotHw := 0 
						nImpCamp:= 0 
					EndIf*/ 
					
					//Comentado, divisao entre SW e HW. 
					//nValSw	:= (nValTot-nImpCamp) * nPorSfw 
					nBaseSw	:= nValTotSw-nImpCamp 
					nBaseHw	:= nValTotHw 
					
					//Gero comissao com divisao de valores. 
					nValSw	:= nBaseSw * nPorSfw 
					nValHw	:= nBaseHw * nPorSfw 
					
					cRegSw	:= ">>> (" + Alltrim(cCodParc) + ") >>> (PERCENTUAL SOBRE VENDA CAMPANHA CONTADOR) >>> " 
					//EndIf 
					
					//Fa?o tratamento para gravar atrav?s do Z5_DESREDE a AC proprietaria da campanha. 
					lProdCalc := .F. 
					cAcPropri := "" 
					
					If !lCalcCam  
						cAcPropri := CRR20RD(SZ5->Z5_DESREDE, cCodCCR) 
					Else 
						cAcPropri := AllTrim(SZ3->Z3_CODAC) 
					EndIf 
					
					//Renato Ruy - 11/12/2017 
					//Regra, não paga campanha para FACESP
					//2017120810000994 - adicionado para zerar pedido da Facesp. 
					If 	( cAcPropri $ "BV/FACES" .And. ;
					    	( "FACESP"$UPPER(SZ5->Z5_NOMPAR) .Or. "ACSP"$UPPER(SZ5->Z5_NOMPAR) .Or. "MOGIANA"$UPPER(SZ5->Z5_NOMPAR) ) ;
						) .OR. cAcPropri == "FACES" 
						nValSw := 0 
						nValHw := 0 
					Endif 
					
					//Zera valores para produtos que não s?o remunerados. 
					//Renato Ruy - 13/01/2016 
					//Parceiro  3179 do link BR recebe por produto SRF. 
					//TODO Incluir Validação de Rede CNC e AR FECOMERCIO CE Permite Remuneração 
					If ("/"+AllTrim(SZ5->Z5_PRODGAR)+"/" $ "/REGSRFA3PF1AESHV2/NOTSRFA3PF1AESHV2/SINSRFA3PFSC1AESHV2/REGSRFA3PJTO18MCNSESHV2/SINSRFA3PJTO18MCNSESHV2/NOTSRFA3PJTO18MCNSESHV2/NOTSRFA3PJSC18MCNSESHV2/REGSRFA3PJSC18MCNSESHV2/SINSRFA3PJSC18MCNSESHV2/"; 
						.Or. ("/"+AllTrim(SZ5->Z5_PRODGAR)+"/" $ "/SRFA3PJSC18MCNSESHV2/SRFA3PJSC18MCNSESHV5/SRFA3PJSL18MCNSESHV5/SRFA3PJTO18MCNSESBVLEGHV5/SRFA3PJTO18MCNSESHV2/SRFA3PJTO18MCNSESHV5/NOTSRFA3PJTO18MCNSESHV5/" .And. !cAcPropri $  "CNC/CACB/CRD" .And. !"REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE)); 
						.Or. (SubStr(SZ5->Z5_PRODGAR,1,3) == "SRF" .And. !cAcPropri $ "CNC/CRD/CACB/BR/BRC/SIN/NOT/SINRJ/BV/ACP-PR/FACES/FENCR/SAGE/FACISC" .And. AllTrim(SZ5->Z5_CODPAR) != "3179" .And. !lCalcCam ); 
						.Or. SubStr(SZ5->Z5_PRODGAR,1,3) == "OAB") .And. !("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE)) .And.; 
						!("FACESP"$UPPER(SZ5->Z5_NOMPAR) .Or. "ACSP"$UPPER(SZ5->Z5_NOMPAR) .Or. "MOGIANA"$UPPER(SZ5->Z5_NOMPAR))  
						nValSw := 0 
						nValHw := 0 
						cDesPar := "" 
						lCalcAss := .F. 
						CRPA020LOG(0,"Exce??o Outros Produtos",{{"Ni",Ni},{"SZ5->Z5_COMSW",cValToChar(SZ5->Z5_COMSW)},{"nPorSfw",cValToCHar(nPorSfw)},{"nValSw",cValToChar(nValSw)},{"nValHw",cValToCHar(nValHw)},{"cDesPar",cDesPar},{"SZ5->Z5_PRODGAR",SZ5->Z5_PRODGAR},{"cAcPropri",cAcPropri}},"",ProcLine(),cUserName) 
						//Tratamento Valores para campanha, quando produto não faz parte da AC, não remunera. 
						//Priscila Kuhn -05/08/15 
						//Adiciona a ICP para remunerar produtos REG 
					//ElseIf "REG" $ SZ5->Z5_PRODGAR .And. cAcPropri <> "BR" .And. cAcPropri <> "NOT" .And. cAcPropri <> "ICP"  .And. !("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE)) .And. !('BR CRED' $ Upper(SZ5->Z5_DESREDE)) 
						//nValSw := 0 
						//nValHw := 0 
						//cDesPar := "" 
					ElseIf "NOT" $ SZ5->Z5_PRODGAR .And. cAcPropri <> "NOT" .And. cAcPropri <> "BR" .And. cAcPropri <> "ICP" .And. !("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE)) 
						nValSw := 0 
						nValHw := 0 
						cDesPar := "" 
						lCalcAss := .F. 
						CRPA020LOG(0,"Exce??o Produto NOTARIAL",{{"Ni",Ni},{"SZ5->Z5_COMSW",cValToChar(SZ5->Z5_COMSW)},{"nPorSfw",cValToCHar(nPorSfw)},{"nValSw",cValToChar(nValSw)},{"nValHw",cValToCHar(nValHw)},{"cDesPar",cDesPar},{"SZ5->Z5_PRODGAR",SZ5->Z5_PRODGAR},{"cAcPropri",cAcPropri}},"",ProcLine(),cUserName) 
					ElseIf "SIN" $ SZ5->Z5_PRODGAR .And. (cAcPropri <> "SIN" .And. !cCodCCR $ "054403/054553/054924") .And. cAcPropri <> "FENCR"  .And. !("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE)) 
						nValSw := 0 
						nValHw := 0 
						cDesPar := "" 
						lCalcAss := .F. 
						CRPA020LOG(0,"Exce??o Produto SINCOR",{{"Ni",Ni},{"SZ5->Z5_COMSW",cValToChar(SZ5->Z5_COMSW)},{"nPorSfw",cValToCHar(nPorSfw)},{"nValSw",cValToChar(nValSw)},{"nValHw",cValToCHar(nValHw)},{"cDesPar",cDesPar},{"SZ5->Z5_PRODGAR",SZ5->Z5_PRODGAR},{"cAcPropri",cAcPropri}},"",ProcLine(),cUserName) 
					EndIf 
					
					// Solicitante: Priscila Kuhn - 24/06/2015 
					// Não paga campanha quando pedido de renovação para casos que não são REG/SIN/NOT. 
					If !(cAcPropri $ "BR/BRC/SIN/NOT/SINRJ/FACES/FENCR") .And. (!Empty(SZ5->Z5_PEDGANT) .OR. AllTrim(SZ5->Z5_TIPVOU) == 'H' .OR. 'RENOVACAO' $ UPPER(SZ5->Z5_DESGRU)) .And. !('BR CRED' $ Upper(SZ5->Z5_DESREDE)) 
						nValSw := 0 
						nValHw := 0 
						cDesPar := "" 
						lCalcAss := .F. 
						CRPA020LOG(0,"Renova??o não paga campanha;",{{"Ni",Ni},{"SZ5->Z5_COMSW",cValToChar(SZ5->Z5_COMSW)},{"nPorSfw",cValToCHar(nPorSfw)},{"nValSw",cValToChar(nValSw)},{"nValHw",cValToCHar(nValHw)},{"cDesPar",cDesPar}},"!(cAcPropri $ 'BR/BRC/SIN/NOT/SINRJ/FACES/FENCR') .And. (!Empty(SZ5->Z5_PEDGANT) .OR. AllTrim(SZ5->Z5_TIPVOU) == 'H' .OR. 'RENOVACAO' $ UPPER(SZ5->Z5_DESGRU)) .And. !('BR CRED' $ Upper(SZ5->Z5_DESREDE))",ProcLine(),cUserName) 
					EndIf 
					
					CRPA020LOG(0,"Antes de gravar a Campanha, verifica??o dos dados",{{"Ni",Ni},{"SZ5->Z5_COMSW",cValToChar(SZ5->Z5_COMSW)},{"nPorSfw",cValToCHar(nPorSfw)},{"nValSw",cValToChar(nValSw)},{"nValHw",cValToCHar(nValHw)},{"cDesPar",cDesPar}},"SZ5->Z5_COMSW > 0",ProcLine(),cUserName) 
				EndIf 
				
				//PREPARA??O PARA GRAVA??O DA TABELA SZ6 DE RESULTADO DO CALCULO DA COMISS?O. 
				If cTipPar == "7" .And. Empty(cAcPropri) 
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> Parceiro " + cCodParc +" PARCEIRO NAO POSSUI LINK PARA CALCULO.") 
				ElseIf SZ5->Z5_COMSW <= 0 
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> Parceiro " + cCodParc +" NAO POSSUI PERCENTUAL PARA CALCULO.") 
				ElseIf SZ5->Z5_BLQVEN == "0" 
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> Parceiro " + cCodParc +" O PARCEIRO ESTA BLOQUEADO, NAO CALCULA REMUNERACAO.") 
				ElseIf SZ5->Z5_VALORSW < 1 
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> Parceiro " + cCodParc +" NAO POSSUI VALOR DE SW PARA CALCULO.") 
				EndIf 
				
			EndIf 
			
			//Solicitante: Priscila Kuhn - 05/11/2015 
			//Descricao: Quando o CCR ? igual a 054611 - AR POLOMASTHER. 
			//*	Calcula Remuneração para 054611 - AR POLOMASTHER e calcula um valor extra de Remuneração para o CCR 073322 - AR POLOMASTHER 4,5. 
			//*	Os percentuais de cada produto est?o informados no CCR. 
			//*	Para desativar o calculo extra, ser? utilizado o campo se calcula Remuneração para o CCR. 
			If cCodCCR == "054611" .And. nI == 1 .And. cRemPer >= "201510" 
				CRPA020P(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem, lTemHard, lPedEcom) 
			EndIf 
	
			//Solicitante: Priscila Kuhn - 29/10/2018 
			//Descricao: Pedidos oriundos do grupo BVSCE que forem validados fora da Rede FACESP 
			//*	Facesp receber? pela venda 20%(SW) e 20% (HW). 
			//Yuri Volpe - 08/01/2019 
			//OTRS 2019010210003152 - Ajuste para não permitir que o CCR Facesp calcule duas vezes a Remuneração. 
			If (("BOA VISTA" $ UPPER(SZ5->Z5_DESGRU) .And. "FACESP" $ UPPER(SZ5->Z5_DESREDE)) .And. (nI == 1)) .And. cCodCCR != "080361" .And. !lFCSPCalc 
				CRPA020x(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem, lPedEcom) 
			EndIf 
			
			//SAGE 
			If lCalcSAGE .And. nI == 8 
				CRPA020S(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem)
			EndIf 
			
			//Calculo Revendedor  
			If lCalcAss //.And. Ni == 3   
				CRPA20ASS(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem,cCodCanal,cCodCanal2,cCodCCR,(Ni==6),lPedEcom)		 
			EndIf 
			
			If lProjTop .And. Ni == 1   
				CRPA020T(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem,cCodPosOri,lTemHard,lPedEcom) 
			EndIf 
			
			//Yuri Volpe - 23.01.2020 
			//OTRS 2020012310000809 - Biometria para o Canal - Remove c?lculo de biometria das ACs, exceto as controladas na SZ3 
			If lBioCanal .And. Ni == 3   
				CRPA020BIO(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem,cCodPosOri,cCodCCR,lPedEcom) 
			EndIf		 
			
			If ((!lMidiaAvulsa .And. nI <> 6) .OR. (!Empty(cDesPar) .And. nI == 6)) .And. Ni != 8 
				nQtdReg	:= nQtdReg + 1 
			Endif 
			
			// Solicitante: Priscila Kuhn - 11/05/2015 
			// Foi retirada Validação do tipo 3 e 4 para calcular hardware para canais 
			//If !(nI == 3 .Or. nI == 4 .Or. nI == 6) .And. (lTemHard .Or. lMidiaAvulsa) 
			If (((lMidiaAvulsa .Or. lTemHard) .And. nI != 6) .OR. (!Empty(cDesPar) .And. nI == 6 .And. nBaseHw != 0 .And. lTemHard)) .And. Ni != 8  
				nQtdReg	:= nQtdReg + 1 
			Endif 
			
			// Cria a matriz e inicializa as variaveis 
			
			For nX :=1 To nQtdReg 
				Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) ) 
				For nJ := 1 To Len(aStrucSZ6) 
					Do Case 
						Case aStrucSZ6[nJ][2] == "C" 
							aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
						Case aStrucSZ6[nJ][2] == "N" 
							aDadosSZ6[Len(aDadosSZ6)][nJ] := 0 
						Case aStrucSZ6[nJ][2] == "D" 
							aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//") 
						Otherwise 
							aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
					Endcase 
				Next nJ 
			Next nX 
			
			
			//For?o Reposicionamento no cadastro do Posto. Isso ? necess?rio devido ao uso do c?digo de CCR 
			If nI==1 
				SZ3->(DbSetOrder(6))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR 
				SZ3->(!MsSeek(xFilial("SZ3") + "4" + cCodPosto)) 
			Endif 
			
			For nX := 1 To nQtdReg 
				nZ	:=	nZ	+	1 
				For nK := 1 To Len(aStrucSZ6) 
					cCampo := AllTrim(aStrucSZ6[nK][1]) 
					Do Case 
						Case cCampo == "Z6_FILIAL" 
							aDadosSZ6[nZ][nK]	:= xFilial("SZ6") 
						Case cCampo == "Z6_PERIODO" 
							aDadosSZ6[nZ][nK]	:= cRemPer 
						Case cCampo == "Z6_TPENTID" 
							aDadosSZ6[nZ][nK]	:= IIF(nI<>6, SZ3->Z3_TIPENT,cTipPar) 
						Case cCampo == "Z6_CODENT" 
							aDadosSZ6[nZ][nK]	:= IIF(nI<>6, SZ3->Z3_CODENT, cCodPar) 
						Case cCampo == "Z6_DESENT" 
							aDadosSZ6[nZ][nK]	:= IIF(nI<>6, SZ3->Z3_DESENT, cDesPar) 
						Case cCampo == "Z6_PRODUTO" 
							If lPedEcom 
								aDadosSZ6[nZ][nK]	:= SC6->C6_PROGAR 
							Else 
								aDadosSZ6[nZ][nK]	:= iF(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR), SZ5->Z5_PRODUTO,SZ5->Z5_PRODGAR) 
							EndIf							 
						Case cCampo == "Z6_CATPROD" 
							aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware 
						Case cCampo == "Z6_DESCRPR" 
							If lPedEcom 
								If Empty(Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
									aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
								Else 
									aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
								EndIf 
							Else 
								aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
							EndIf 
						Case cCampo == "Z6_PEDGAR" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGAR 
						Case cCampo == "Z6_DTPEDI" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATPED 
						Case cCampo == "Z6_VERIFIC" 
							aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa,SZ5->Z5_EMISSAO,SZ5->Z5_DATVER) 
						Case cCampo == "Z6_VALIDA" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATVAL 
						Case cCampo == "Z6_DTEMISS" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATEMIS 
						Case cCampo == "Z6_TIPVOU" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_TIPVOU 
						Case cCampo == "Z6_CODVOU" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVOU 
						Case cCampo == "Z6_DESCVOU" 
							aDadosSZ6[nZ][nK]	:= "" 
						Case cCampo == "Z6_VLRPROD" 
							//Renato Ruy - 11/01/16 - Separa valor de HW para campanha. 
							//If nI == 6 
							//	aDadosSZ6[nZ][nK]	:= nValTot 
							//Else 
							aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nValTotSw,nValTotHw) 
							//EndIf 
						Case cCampo == "Z6_BASECOM" 
							//If nI == 6 
							//	aDadosSZ6[nZ][nK]	:= nValTot - nImpCamp 
							//Else 
							aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nBaseSw,nBaseHw) 
							//EndIf 
						Case cCampo == "Z6_VALCOM" 
							//If nI == 6 
							//	aDadosSZ6[nZ][nK]	:= nValSw 
							//Else 
							aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValSw,nValHw) 
							//EndIf 
						Case cCampo == "Z6_REGCOM" 
							//If !lMidiaAvulsa .And. nX == 1 .And. nValSw < 1 
							//	aDadosSZ6[nZ][nK]	:= "<<< Pencentual do Software não Informado >>>" 
							//ElseIf !lMidiaAvulsa .And. nValHw < 1 .And. nI <> 6 
							//	aDadosSZ6[nZ][nK]	:= "<<< Pencentual de Hardware não Informado >>>" 
							//Else 
							aDadosSZ6[nZ][nK]	:= Iif(cTipMan == "2", "RETIFICACAO-", "")+DtoC(dDatabase)+"-"+Time()+"-"+AllTrim(cNomeUsu)+"-"+cRotina+"-"+SubStr(IF(!lMidiaAvulsa .And. nX == 1,cRegSw,cRegHw),1,60) 
							//EndIf 
						Case cCampo == "Z6_CODCAN" 
							aDadosSZ6[nZ][nK]	:= cCodCanal 
						Case cCampo == "Z6_CODAC" 
							If nI <> 6 
								aDadosSZ6[nZ][nK]	:= Iif(lProdCalc .Or. nI==1,cCodAc,SZ3->Z3_CODENT) //Grupo/Rede 
							Else 
								aDadosSZ6[nZ][nK]	:= cAcPropri 
							EndIf 
						Case cCampo == "Z6_CODAR" 
							aDadosSZ6[nZ][nK]	:= cCodAR 
						Case cCampo == "Z6_CODPOS" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPOS 
						Case cCampo == "Z6_CODCCR" 
							aDadosSZ6[nZ][nK]	:= cCodCcr 
						Case cCampo == "Z6_CCRCOM" 
							aDadosSZ6[nZ][nK]	:= cDesCcr	//Grava a descricao do CCR. 
						Case cCampo == "Z6_CODPAR" 
							aDadosSZ6[nZ][nK]	:= cCodParc 
						Case cCampo == "Z6_CODFED" 
							aDadosSZ6[nZ][nK]	:= cCodFeder 
						Case cCampo == "Z6_CODVEND" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVEND 
						Case cCampo == "Z6_NOMVEND" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMVEND 
						Case cCampo == "Z6_TIPO" 
							//aDadosSZ6[nZ][nK]	:= SZ5->Z5_TIPO 
							If AllTrim(cTiped) == "RECEBANT" //Pedido IFEN, recebido anteriormente. 
								aDadosSZ6[nZ][nK]	:= "RECANT" 
							Elseif cTipMan == "2" 
								aDadosSZ6[nZ][nK]	:= "RETIFI" 
							Elseif "CRPA027R-REE" == cNomeUsu .Or. !lGerReem //Alteração de status para desconto do reembolso. 
								aDadosSZ6[nZ][nK]	:= "REEMBO" 
							ElseIf !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) .And. lOriCupom //Pedido com voucher de origem não pago. 
								aDadosSZ6[nZ][nK]	:= "NAOPAG" 
							Elseif lProFunc .Or. lProjTop  
								aDadosSZ6[nZ][nK]	:= "NAOPAG" 
							ElseIf aStatus[1] == "PAGANT" .And. !Empty(SZ5->Z5_CODVOU) //Pedido com voucher Pago Anteriormente. 
								aDadosSZ6[nZ][nK]	:= "PAGANT" 
							ElseIf ("RENOVACAO" $ UPPER(SZ5->Z5_DESGRU) .Or. !Empty(SZ5->Z5_PEDGANT) .Or. AllTrim(SZ5->Z5_TIPVOU) == "H") .And. !lPedNoRem //Pedido de renovacao. 
								aDadosSZ6[nZ][nK]	:= "RENOVA" 
							ElseIf Empty(SZ5->Z5_PEDGAR) //Pedido de hardware avulso. 
								aDadosSZ6[nZ][nK]	:= "ENTHAR" 
							ElseIf lPedNoRem //Mensagem especifica Pedido não Pago 
								aDadosSZ6[nZ][nK]	:= "PNOPAG" 
							Else //Se nao entra nas outra condicoes e verificacao. 
								aDadosSZ6[nZ][nK]	:= "VERIFI" 
							EndIf 
						Case cCampo == "Z6_PEDSITE" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDSITE 
						Case cCampo == "Z6_REDE" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_REDE 
						Case cCampo == "Z6_GRUPO" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_GRUPO 
						Case cCampo == "Z6_DESGRU" 
							aDadosSZ6[nZ][nK]	:= AllTrim(SZ5->Z5_DESGRU)+Iif(lGerReem," "," - Pedido Reembolsado ao cliente.")+; 
												Iif(cZera=="S","- CCR Zerado"," ")+cProMinc+cObserva+Iif(lProjTop," - VOUCHER ORIGEM NAO REMUNERADO","")+; 
												Iif(lCNJ," - Remuneracao Fixa","")+Iif(lACJUS," - RENOVACAO não Remunerado","") 
						Case cCampo == "Z6_CODAGE" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODAGE 
						Case cCampo == "Z6_NOMEAGE" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMAGE 
						Case cCampo == "Z6_AGVER" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_AGVER 
						Case cCampo == "Z6_NOAGVER" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOAGVER 
						Case cCampo == "Z6_NTITULA" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_NTITULA 
						Case cCampo == "Z6_DESREDE" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESREDE 
							//Case cCampo == "Z6_DESPOS" 
							//	aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESPOS 
						Case cCampo == "Z6_PEDORI" 
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGANT 
						Case cCampo == "Z6_VLRABT" 
							If (nI == 3 .Or. nI == 4) .And. cAbateCcrAC == "1" .And. nX == 1 
								aDadosSZ6[nZ][nK]	:= nAbtAR + nAbtAC + nAbtImp + nAbtCart + nAbtCamS 
							ElseIf ((nI == 3 .Or. nI == 4) .And. nX == 1) .And. ("CRPA027R-REE" == cNomeUsu .Or. !lGerReem) 
								aDadosSZ6[nZ][nK]	:= aVlrPagos[8] * -1 
							EndIf 
						Case cCampo == "Z6_TIPED" 
							aDadosSZ6[nZ][nK]	:= cTiped 
						Case cCampo == "Z6_ACLCTO" 
							aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE 
						Case cCampo == "Z6_ARLCTO" 
							aDadosSZ6[nZ][nK] 	:= SZ5->Z5_CODAR 						 
					Endcase 
				Next nK 
			Next nX 
			
			cFaixa 	  := "" 
			cFxCodEnt := "" 
			
			//Gravo valores para serem abatidos no CANAL 1 e 2. 
			//If (nI == 1 .Or. nI == 2) .And. cAbateCcrAC == "1" 26/06/2015 
			//O Valor de Hard e Softw (de Posto e Rede) ser? acumulado para uso abatimento da base de c?lculo do canal 
			
		Next nI 
		
		/* 
		??????????????????????????????????????????????????????????????????????????????????????? 
		?Grava todos lancamentos de remuneracao calculados na tabela SZ6   			    	   ? 
		???????????????????????????????????????????????????????????????????????????????????????? 
		*/ 
		
		//If Empty(SZ5->Z5_OBSCOM) .OR. SubStr(SZ5->Z5_OBSCOM,1,2) == "OK" 
		
		Begin Transaction 
		
		For nI := 1 To Len(aDadosSZ6) 
			SZ6->( RecLock("SZ6",.T.) ) 
			For nJ := 1 To Len(aStrucSZ6) 
				cCampo := AllTrim(aStrucSZ6[nJ][1]) 
				&("SZ6->"+cCampo) := aDadosSZ6[nI][nJ] 
			Next nJ 
			SZ6->Z6_RECORI := AllTrim(Str(SZ5->(Recno()))) 
			SZ6->( MsUnLock() ) 
		Next nI 
		
		If Len(aDadosSZ6) > 0 
			SZ5->( RecLock("SZ5",.F.) ) 
				SZ5->Z5_COMISS := "2" 
				SZ5->Z5_OBSCOM := IIF(Empty(SZ5->Z5_OBSCOM), "OK", SZ5->Z5_OBSCOM) 
			SZ5->( MsUnLock() ) 
			
			ConOut("Pedido calculado: " + SZ5->Z5_PEDGAR) 
			
		EndIf 
		
		End Transaction 
		
		//Endif 
		
		aDadosSZ6 := {} 
		nZ := 0 
		
		UnLockByName("CRPA020"+SZ5->Z5_PEDGAR) 
		
	Next 
	
	Conout("[CRPA020B] "+Alltrim(Str(ThreadId()))+" Pedidos Recebidos "+Alltrim(Str(Len(aPedidos)))+" Pedidos Processados "+Alltrim(Str(nCountThrd))) 
	
	RpcClearEnv() 
Return 
 
//Solicitante: Priscila Kuhn - 05/11/2015 
//Descricao: Quando o CCR ? igual a 054611 - AR POLOMASTHER. 
//*	Calcula Remuneração para 054611 - AR POLOMASTHER e calcula um valor extra de Remuneração para o CCR 073322 - AR POLOMASTHER 4,5. 
//*	Os percentuais de cada produto est?o informados no CCR. 
//*	Para desativar o calculo extra, ser? utilizado o campo se calcula Remuneração para o CCR. 
Static Function CRPA020P(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem,lTemHard,lPedEcom) 
	Local aStrucSZ6	:= SZ6->( DbStruct() ) 
	Local aDadosSZ6	:= {} 
	Local nQtdReg	:= 0 
	Local nZ		:= 0 
	Local nBaseSw	:= 0 
	Local nBaseHw	:= 0 
	Local nValSw	:= 0 
	Local nValHw	:= 0 
	Local cRegSw	:= 0 
	Local cRegHw	:= 0 
	Local nPerSW	:= 0 
	Local nPerHW	:= 0 
	Local aAreaSZ3  := SZ3->(GetArea()) 
	Local aAreaSZ4  := SZ4->(GetArea()) 
	Local Nj, Nx, Nk, Ni 
	
	//Me posiciono na entidade. 
	SZ3->(DbSetOrder(1)) 
	SZ3->(DbSeek(xFilial("SZ3")+"073322")) 
	
	//Se o CCR nao esta ativo ou produto nao tem a categoria, nao faco calculo. 
	If SZ3->Z3_TIPCOM <> "1" .OR. cCatProd == "NE" 
		Return 
	EndIf 
	
	//Me posiciono para buscar o percentual. 
	SZ4->(DbSetOrder(1)) 
	SZ4->(DbSeek(xFilial("SZ4")+"073322" + cCatProd)) 
	
	//Renato Ruy - 04/08/2017 
	//Quando o Produto originar da venda de um revendedor 
	//Busca um percentual diferenciado. 
	If RTRIM(SZ5->Z5_CODVEND) $ GetNewPar("MV_XREMVEN","18855") 
		nPerSW	:= SZ4->Z4_PARSW 
		nPerHW	:= SZ4->Z4_PARHW 
	Else 
		nPerSW	:= SZ4->Z4_PORSOFT 
		nPerHW	:= SZ4->Z4_PORHARD 
	Endif 
	
	//Se tem percentual de calculo, gera lancamento 
	If nPerSW > 0 .And. !lMidiaAvulsa 
		nQtdReg += 1 
	EndIf 
	
	If nPerHW > 0 .And. (lMidiaAvulsa .Or. lTemHard) 
		nQtdReg += 1 
	EndIf 
	
	//Retira-se em seguida o imposto de renda 
	//Yuri Volpe - 07/02/2019 
	//OTRS 2019020510006062 - Removido c?lculo de biometria para POLOMASTHER ADICIONAL 
	/*If AllTrim(cTiped) == "BIOMETRIA" .And. (nValTotSW+nValTotHW < -14 .Or. nValTotSW+nValTotHW > 14) 
		nBaseSw	:= nValTotSw - (nValTotSw * SZ4->Z4_PORIR / 100) - 10 
	ElseIf AllTrim(cTiped) == "BIOMETRIA" .And. nValTotSW+nValTotHW < -14 
		nBaseSw	:= nValTotSw - (nValTotSw * SZ4->Z4_PORIR / 100) + 10 
	Else*/ 
		nBaseSw	:= nValTotSw - (nValTotSw * SZ4->Z4_PORIR / 100) 
	//EndIf 
	
	nBaseHw	:= nValTotHw - (nValTotHw * SZ4->Z4_PORIR / 100) 
	
	If !Empty(nPerSW) 
		nValSw	:= nBaseSw * (nPerSW/100) 
		cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE SOFTWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
	Else 
		nValSw	:= 0 
		cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (SEM PERCENTUAL SOBRE SOFTWARE) " 
	Endif 
	
	If !Empty(nPerHW) 
		nValHw	:= nBaseHw * (nPerHW/100) 
		cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE SOFTWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
	Else 
		nValHw	:= 0 
		cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (SEM PERCENTUAL SOBRE HARDWARE) " 
	Endif 
	
	For nX :=1 To nQtdReg 
		Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			Do Case 
				Case aStrucSZ6[nJ][2] == "C" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
				Case aStrucSZ6[nJ][2] == "N" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := 0 
				Case aStrucSZ6[nJ][2] == "D" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//") 
				Otherwise 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
			Endcase 
		Next nJ 
	Next nX 
	
	
	For nX := 1 To nQtdReg 
		nZ	:=	nZ	+	1 
		For nK := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nK][1]) 
			Do Case 
				Case cCampo == "Z6_FILIAL" 
					aDadosSZ6[nZ][nK]	:= xFilial("SZ6") 
				Case cCampo == "Z6_PERIODO" 
					aDadosSZ6[nZ][nK]	:= cRemPer 
				Case cCampo == "Z6_TPENTID" 
					aDadosSZ6[nZ][nK]	:= "4" 
				Case cCampo == "Z6_CODENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_CODENT 
				Case cCampo == "Z6_DESENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_DESENT 
				Case cCampo == "Z6_PRODUTO" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR), SZ5->Z5_PRODUTO,SZ5->Z5_PRODGAR) 
				Case cCampo == "Z6_CATPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware 
				Case cCampo == "Z6_DESCRPR" 
					If lPedEcom 
						If Empty(Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
							aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
						Else 
							aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
						EndIf 
					Else 
						aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
					EndIf 
				Case cCampo == "Z6_PEDGAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGAR 
				Case cCampo == "Z6_DTPEDI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATPED 
				Case cCampo == "Z6_VERIFIC" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa,SZ5->Z5_EMISSAO,SZ5->Z5_DATVER) 
				Case cCampo == "Z6_VALIDA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATVAL 
				Case cCampo == "Z6_DTEMISS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATEMIS 
				Case cCampo == "Z6_TIPVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_TIPVOU 
				Case cCampo == "Z6_CODVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVOU 
				Case cCampo == "Z6_VLRPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nValTotSw,nValTotHw) 
				Case cCampo == "Z6_BASECOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nBaseSw,nBaseHw) 
				Case cCampo == "Z6_VALCOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValSw,nValHw) 
				Case cCampo == "Z6_REGCOM" 
					aDadosSZ6[nZ][nK]	:= DtoC(dDatabase)+"-"+Time()+"-"+AllTrim(cNomeUsu)+"-"+SubStr(IF(!lMidiaAvulsa .And. nX == 1,cRegSw,cRegHw),1,100) 
				Case cCampo == "Z6_CODPOS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPOS 
				Case cCampo == "Z6_CODCCR" 
					aDadosSZ6[nZ][nK]	:= "073322" 
				Case cCampo == "Z6_CCRCOM" 
					aDadosSZ6[nZ][nK]	:= "" 
				Case cCampo == "Z6_CODPAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPAR 
				Case cCampo == "Z6_CODFED" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMPAR 
				Case cCampo == "Z6_CODVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVEND 
				Case cCampo == "Z6_NOMVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMVEND 
				Case cCampo == "Z6_TIPO" 
					If !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) .And. lOriCupom //Pedido com voucher de origem não pago. 
						aDadosSZ6[nZ][nK]	:= "NAOPAG" 
					Elseif "CRPA027R-REE" == cNomeUsu .Or. !lGerReem //Alteração de status para desconto do reembolso. 
						aDadosSZ6[nZ][nK]	:= "REEMBO" 
					ElseIf !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) //Pedido com voucher Pago Anteriormente. 
						aDadosSZ6[nZ][nK]	:= "PAGANT" 
					ElseIf "RENOVACAO" $ UPPER(SZ5->Z5_DESGRU) .Or. !Empty(SZ5->Z5_PEDGANT) .Or. AllTrim(SZ5->Z5_TIPVOU) == "H"  //Pedido de renovacao. 
						aDadosSZ6[nZ][nK]	:= "RENOVA" 
					ElseIf Empty(SZ5->Z5_PEDGAR) //Pedido de hardware avulso. 
						aDadosSZ6[nZ][nK]	:= "ENTHAR" 
					ElseIf lPedNoRem //Mensagem especifica Pedido não Pago 
						aDadosSZ6[nZ][nK]	:= "PNOPAG"			    	 
					Else //Se nao entra nas outra condicoes e verificacao. 
						aDadosSZ6[nZ][nK]	:= "VERIFI" 
					EndIf 
				Case cCampo == "Z6_PEDSITE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDSITE 
				Case cCampo == "Z6_REDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_GRUPO" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_GRUPO 
				Case cCampo == "Z6_DESGRU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESGRU 
				Case cCampo == "Z6_CODAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODAGE 
				Case cCampo == "Z6_NOMEAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMAGE 
				Case cCampo == "Z6_AGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_AGVER 
				Case cCampo == "Z6_NOAGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOAGVER 
				Case cCampo == "Z6_NTITULA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NTITULA 
				Case cCampo == "Z6_DESREDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESREDE 
				Case cCampo == "Z6_PEDORI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGANT 
				Case cCampo == "Z6_TIPED" 
					aDadosSZ6[nZ][nK]	:= cTiped 
				Case cCampo == "Z6_ACLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_ARLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_CODAR 				 
			Endcase 
		Next nK 
	Next nX 
	
	Begin Transaction 
	
	For nI := 1 To Len(aDadosSZ6) 
		SZ6->( RecLock("SZ6",.T.) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nJ][1]) 
			&("SZ6->"+cCampo) := aDadosSZ6[nI][nJ] 
		Next nJ 
		SZ6->Z6_RECORI := AllTrim(Str(SZ5->(Recno()))) 
		SZ6->( MsUnLock() ) 
	Next nI 
	
	End Transaction 
	
	RestArea(aAreaSZ3) 
	RestArea(aAreaSZ4) 
Return 
 
//Solicitante: Priscila Kuhn - 05/11/2015 
//Descricao: Quando o CCR ? igual a 054611 - AR POLOMASTHER. 
//*	Calcula Remuneração para pedidos do grupo BVSCE e calcula um valor extra de Remuneração para a FACESP caso seja validado fora da rede FACESP. 
//*	Os percentuais de cada produto est?o informados no CCR. 
//*	Para desativar o calculo extra, ser? utilizado o campo se calcula Remuneração para o CCR. 
Static Function CRPA020x(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem,lPedEcom) 
	Local aStrucSZ6	:= SZ6->( DbStruct() ) 
	Local aDadosSZ6	:= {} 
	Local nQtdReg	:= 0 
	Local nZ		:= 0 
	Local nBaseSw	:= 0 
	Local nBaseHw	:= 0 
	Local nValSw	:= 0 
	Local nValHw	:= 0 
	Local cRegSw	:= 0 
	Local cRegHw	:= 0 
	Local nPerSW	:= 0 
	Local nPerHW	:= 0 
	Local cNewCCR	:= AllTrim(GetNewPar("MV_XDUPCCR","")) 
	Local aAreaSZ3  := SZ3->(GetArea()) 
	Local aAreaSZ4  := SZ4->(GetArea()) 
	Local Nj, Ni, Nx, Nk 
	
	//Me posiciono na entidade. 
	SZ3->(DbSetOrder(1)) 
	SZ3->(DbSeek(xFilial("SZ3")+ cNewCCR)) 
	
	//Se o CCR nao esta ativo ou produto nao tem a categoria, nao faco calculo. 
	If SZ3->Z3_TIPCOM <> "1" .OR. cCatProd == "NE" 
		Return 
	EndIf 
	
	//Me posiciono para buscar o percentual. 
	SZ4->(DbSetOrder(1)) 
	SZ4->(DbSeek(xFilial("SZ4")+ cNewCCR + cCatProd)) 
	
	nPerSW	:= SZ4->Z4_PARSW 
	nPerHW	:= SZ4->Z4_PARHW 
	
	//Se tem percentual de calculo, gera lancamento 
	If nPerSW > 0 .And. !lMidiaAvulsa 
		nQtdReg += 1 
	EndIf 
	
	If nPerHW > 0 
		nQtdReg += 1 
	EndIf 
	
	nBaseSw	:= nValTotSw - (nValTotSw * SZ4->Z4_PORIR / 100) 
	nBaseHw	:= nValTotHw - (nValTotHw * SZ4->Z4_PORIR / 100) 
	
	If !Empty(nPerSW) 
		nValSw	:= nBaseSw * (nPerSW/100) 
		cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE SOFTWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
	Else 
		nValSw	:= 0 
		cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (SEM PERCENTUAL SOBRE SOFTWARE) " 
	Endif 
	
	If !Empty(nPerHW) 
		nValHw	:= nBaseHw * (nPerHW/100) 
		cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE HARDWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
	Else 
		nValHw	:= 0 
		cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (SEM PERCENTUAL SOBRE HARDWARE) " 
	Endif 
	
	For nX :=1 To nQtdReg 
		Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			Do Case 
				Case aStrucSZ6[nJ][2] == "C" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
				Case aStrucSZ6[nJ][2] == "N" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := 0 
				Case aStrucSZ6[nJ][2] == "D" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//") 
				Otherwise 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
			Endcase 
		Next nJ 
	Next nX 
	
	
	For nX := 1 To nQtdReg 
		nZ	:=	nZ	+	1 
		For nK := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nK][1]) 
			Do Case 
				Case cCampo == "Z6_FILIAL" 
					aDadosSZ6[nZ][nK]	:= xFilial("SZ6") 
				Case cCampo == "Z6_PERIODO" 
					aDadosSZ6[nZ][nK]	:= cRemPer 
				Case cCampo == "Z6_TPENTID" 
					aDadosSZ6[nZ][nK]	:= "4" 
				Case cCampo == "Z6_CODENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_CODENT 
				Case cCampo == "Z6_DESENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_DESENT 
				Case cCampo == "Z6_PRODUTO" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR), SZ5->Z5_PRODUTO,SZ5->Z5_PRODGAR) 
				Case cCampo == "Z6_CATPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware 
				Case cCampo == "Z6_DESCRPR" 
					If lPedEcom 
						If Empty(Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
							aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
						Else 
							aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
						EndIf 
					Else 
						aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
					EndIf 
				Case cCampo == "Z6_PEDGAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGAR 
				Case cCampo == "Z6_DTPEDI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATPED 
				Case cCampo == "Z6_VERIFIC" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa,SZ5->Z5_EMISSAO,SZ5->Z5_DATVER) 
				Case cCampo == "Z6_VALIDA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATVAL 
				Case cCampo == "Z6_DTEMISS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATEMIS 
				Case cCampo == "Z6_TIPVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_TIPVOU 
				Case cCampo == "Z6_CODVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVOU 
				Case cCampo == "Z6_VLRPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nValTotSw,nValTotHw) 
				Case cCampo == "Z6_BASECOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nBaseSw,nBaseHw) 
				Case cCampo == "Z6_VALCOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValSw,nValHw) 
				Case cCampo == "Z6_REGCOM" 
					aDadosSZ6[nZ][nK]	:= DtoC(dDatabase)+"-"+Time()+"-"+AllTrim(cNomeUsu)+"-"+SubStr(IF(!lMidiaAvulsa .And. nX == 1,cRegSw,cRegHw),1,100) 
				Case cCampo == "Z6_CODPOS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPOS 
				Case cCampo == "Z6_CODCCR" 
					aDadosSZ6[nZ][nK]	:= cNewCCR 
				Case cCampo == "Z6_CCRCOM" 
					aDadosSZ6[nZ][nK]	:= "" 
				Case cCampo == "Z6_CODPAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPAR 
				Case cCampo == "Z6_CODFED" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMPAR 
				Case cCampo == "Z6_CODVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVEND 
				Case cCampo == "Z6_NOMVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMVEND 
				Case cCampo == "Z6_TIPO" 
					If !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) .And. lOriCupom //Pedido com voucher de origem não pago. 
						aDadosSZ6[nZ][nK]	:= "NAOPAG" 
					Elseif "CRPA027R-REE" == cNomeUsu .Or. !lGerReem //Alteração de status para desconto do reembolso. 
						aDadosSZ6[nZ][nK]	:= "REEMBO" 
					ElseIf !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) //Pedido com voucher Pago Anteriormente. 
						aDadosSZ6[nZ][nK]	:= "PAGANT" 
					ElseIf "RENOVACAO" $ UPPER(SZ5->Z5_DESGRU) .Or. !Empty(SZ5->Z5_PEDGANT) .Or. AllTrim(SZ5->Z5_TIPVOU) == "H"  //Pedido de renovacao. 
						aDadosSZ6[nZ][nK]	:= "RENOVA" 
					ElseIf Empty(SZ5->Z5_PEDGAR) //Pedido de hardware avulso. 
						aDadosSZ6[nZ][nK]	:= "ENTHAR" 
					ElseIf lPedNoRem //Mensagem especifica Pedido não Pago 
						aDadosSZ6[nZ][nK]	:= "PNOPAG"			    	 
					Else //Se nao entra nas outra condicoes e verificacao. 
						aDadosSZ6[nZ][nK]	:= "VERIFI" 
					EndIf 
				Case cCampo == "Z6_PEDSITE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDSITE 
				Case cCampo == "Z6_REDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_GRUPO" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_GRUPO 
				Case cCampo == "Z6_DESGRU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESGRU 
				Case cCampo == "Z6_CODAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODAGE 
				Case cCampo == "Z6_NOMEAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMAGE 
				Case cCampo == "Z6_AGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_AGVER 
				Case cCampo == "Z6_NOAGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOAGVER 
				Case cCampo == "Z6_NTITULA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NTITULA 
				Case cCampo == "Z6_DESREDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESREDE 
				Case cCampo == "Z6_PEDORI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGANT 
				Case cCampo == "Z6_TIPED" 
					aDadosSZ6[nZ][nK]	:= cTiped 
				Case cCampo == "Z6_ACLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_ARLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_CODAR 				 
			Endcase 
		Next nK 
	Next nX 
	
	Begin Transaction 
	
	For nI := 1 To Len(aDadosSZ6) 
		SZ6->( RecLock("SZ6",.T.) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nJ][1]) 
			&("SZ6->"+cCampo) := aDadosSZ6[nI][nJ] 
		Next nJ 
		SZ6->Z6_RECORI := AllTrim(Str(SZ5->(Recno()))) 
		SZ6->( MsUnLock() ) 
	Next nI 
	
	End Transaction 
	
	RestArea(aAreaSZ3) 
	RestArea(aAreaSZ4) 
Return 
 
//Renato Ruy - 06/01/2016 
//Programa para tratamento de postos inativos e que nao tem cadastro. 
Static Function CRPA020Q(cPosto,lCria) 
	Local cCodPO := " " 
	
	Default cPosto := "0" 
	Default lCria  := .T. 
	
	oWSObj2 := WSIntegracaoGARERPImplService():New() 
	IF oWSObj2:detalhesPosto("erp","password123",Val(cPosto)) 
		
		cCodPO := Iif(lCria,GetSXENum('SZ3','Z3_CODENT'),SZ3->Z3_CODENT) 
		
		RecLock("SZ3", lCria) 
		
		SZ3->Z3_FILIAL	:= xFilial("SZ3")						//Filial Protheus 
		SZ3->Z3_CODENT	:= cCodPO								//Codigo da Entidade 
		SZ3->Z3_CODGAR	:= cPosto								//Codigo GAR 
		
		If ValType(oWSObj2:oWSposto[1]:LATENDIMENTO) <> "U" 
			If oWSObj2:oWSposto[1]:LATENDIMENTO 
				SZ3->Z3_ATENDIM	:= "S"							//Atendimento 
			Else 
				SZ3->Z3_ATENDIM	:= "N"							//Atendimento 
			EndIf 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:LATIVO) <> "U" 
			If oWSObj2:oWSposto[1]:LATIVO 
				SZ3->Z3_ATIVO	:= "S"							//Ativo 
			Else 
				SZ3->Z3_ATIVO	:= "N"							//Ativo 
			EndIf 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:NCEP) <> "U" 
			SZ3->Z3_CEP		:= AllTrim(StrZero(oWSObj2:oWSposto[1]:NCEP,8))	//CEP 
			DbSelectArea("PA7") 
			DbSetOrder(1) 
			If PA7->(DbSeek(xFilial("PA7")+AllTrim(StrZero(oWSObj2:oWSposto[1]:NCEP,8)))) 
				lPa7 := .t. 
			Else 
				lPa7 := .f. 
			EndIf 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:CBAIRRO) <> "U" 
			SZ3->Z3_BAIRRO	:= iif(lPa7 .AND. !Empty(PA7->PA7_BAIRRO) , PA7->PA7_BAIRRO ,AllTrim(oWSObj2:oWSposto[1]:CBAIRRO))		//Bairro 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:CCIDADE) <> "U" 
			SZ3->Z3_MUNICI	:= iif(lPa7 .AND. !Empty(PA7->PA7_MUNIC) , PA7->PA7_MUNIC ,AllTrim(UPPER(oWSObj2:oWSposto[1]:CCIDADE)))	//Cidade 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:CENDERECO) <> "U" 
			SZ3->Z3_LOGRAD	:= oWSObj2:oWSposto[1]:CENDERECO				//Endere?o 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:CUF) <> "U" 
			SZ3->Z3_ESTADO	:= iif(lPa7 .AND. !Empty(PA7->PA7_ESTADO) , PA7->PA7_ESTADO ,oWSObj2:oWSposto[1]:CUF)						//UF 
		EndIf 
		
		SZ3->Z3_NUMLOG	:= "s/n" 
		
		If ValType(oWSObj2:oWSposto[1]:CCNPJ) <> "U" 
			SZ3->Z3_CGC		:= IIf(CGC(oWSObj2:oWSposto[1]:CCNPJ),oWSObj2:oWSposto[1]:CCNPJ,"")					//CNPJ 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:CDESCRICAO) <> "U" 
			SZ3->Z3_DESENT	:= oWSObj2:oWSposto[1]:CDESCRICAO			//Descricao 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:CNOMEFANTASIA) <> "U" 
			SZ3->Z3_NMFANT	:= oWSObj2:oWSposto[1]:CNOMEFANTASIA			//Nome Fantasia 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:CRAZAOSOCIAL) <> "U" 
			SZ3->Z3_RAZSOC	:= oWSObj2:oWSposto[1]:CRAZAOSOCIAL			//Raz?o Social 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:NTELEFONE) <> "U" 
			SZ3->Z3_TEL		:= iif(Empty(Alltrim(Str(oWSObj2:oWSposto[1]:NTELEFONE))) .OR. oWSObj2:oWSposto[1]:NTELEFONE == 0,"1134789444",Alltrim(Str(oWSObj2:oWSposto[1]:NTELEFONE)))	//Telefone 
		EndIf 
		
		SZ3->Z3_TIPENT	:= "4"									//Tipo 
		
		If ValType(oWSObj2:oWSposto[1]:LVISIBILIDADE) <> "U" 
			If oWSObj2:oWSposto[1]:LVISIBILIDADE 
				SZ3->Z3_VISIBIL	:= "N"							//Visibilidade 
			Else 
				SZ3->Z3_VISIBIL	:= "S"							//Visibilidade 
			EndIf 
		EndIf 
		
		If ValType(oWSObj2:oWSposto[1]:LVENDASHW) <> "U" 
			If oWSObj2:oWSposto[1]:LVENDASHW 
				SZ3->Z3_ENTREGA		:= "S"							//Entrega 
			Else 
				SZ3->Z3_ENTREGA		:= "N"							//Entrega 
			EndIf 
		EndIf 
		
		// #TP20130218 - Restricao de Postos / Inclusao do campo de rede 
		If ValType(oWSObj2:oWSposto[1]:CREDE) <> "U" 
			SZ3->Z3_REDE	:= Alltrim(oWSObj2:oWSposto[1]:CREDE)					//Rede 
		EndIf 
		
		SZ3->(MsUnLock()) 
		
		If lCria 
			ConfirmSX8() 
		EndIf 
		
	Else 
		ConOut("não foi poss?vel encontrar a posto: " + cPosto + " ou problema de conex?o!") 
	Endif 
	
	If FindFunction("U_CRPA043") 
		U_CRPA043({{SZ3->Z3_CODENT,SZ3->Z3_DESENT}}) 
	Endif
Return 
 
//Renato Ruy - 06/05/2016 
//Funcao para validar produtos pagos ou nao pagos. 
//Pedidos que tem categoria preenchida na PA8, serao pagos. 
Static Function CRPA020Y(cProduto) 
	Local lPosicao := .F. 
	Local cCategor := "" 
	Local lProPago := .T. 
	
	PA8->(DbSetOrder(1)) 
	lPosicao := PA8->(DbSeek(xFilial("PA8")+PadR(AllTrim(cProduto),32," ") )) 
	
	cCategor := Iif(lPosicao,PA8->PA8_CATPRO,"") 
	
	//Yuri Volpe - 06/12/2018 
	//OTRS 2018120610001155 - Remo??o do produto SPB da regra de produto não pago 
	If SubStr(cProduto,1,3) $ "PRD/CSI" .And. (Empty(cCategor) .Or. !lPosicao) 
		lProPago := .F. 
	Elseif SubStr(cProduto,1,4) $ "CERT/IMES" .And. (Empty(cCategor) .Or. !lPosicao) 
		lProPago := .F. 
	//Renato Ruy - 09/01/2018 
	//2018010810002046 - Regra de Remuneração 
	Elseif "PLOC" $ cProduto .And. (Empty(cCategor) .Or. !lPosicao) 
		lProPago := .F. 
	Elseif SubStr(cProduto,1,5) == "CLASS" .And. (Empty(cCategor) .Or. !lPosicao) 
		lProPago := .F.  
	Elseif  "BB" $ cProduto .And. (Empty(cCategor) .Or. !lPosicao) 
		lProPago := .F. 
	EndIf 
Return(lProPago) 
 
Static Function CRPA020V(cCodVou) 
	Local cRet    := "" 
	Local cPedGar := "" 
	Local cPedSite:= "" 
	Local cVouAnt := "" 
	Local dDatPed := CtoD("  /  /  ") 
	Local cTipOri := "" 
	Local lPosicao:= .F. 
	Local nRecnoZ5:= SZ5->(GetArea()) 
	
	SZF->(DbSetOrder(2)) 
	If SZF->(DbSeek(xFilial("SZF")+cCodVou)) 
		
		cTipOri := SZF->ZF_TIPOVOU 
		
		//Vouchers que não s?o pagos 
		If SZF->ZF_TIPOVOU$"1/3/6/7/8/G/N" 
			cRet := "NAOPAG" 
		//Voucher que tem origem em pedido ou atrav?s de outro voucher. 
		Elseif SZF->ZF_TIPOVOU$"2/A/B/M/L" 
			
			cPedGar  := Iif(Val(SZF->ZF_PEDIDO)>0,AllTrim(Str(Val(SZF->ZF_PEDIDO)))," ") 
			cPedSite := Iif(Val(SZF->ZF_PEDSITE)>0,AllTrim(Str(Val(SZF->ZF_PEDSITE)))," ") 
			cVouAnt  := SZF->ZF_CODORIG 
			
			While (!Empty(cPedGar) .Or. !Empty(cPedSite) .Or. !Empty(cVouAnt)) .And. Empty(cRet) 
				
				lPosicao := .F. 
				//Se posiciona na SZ5 
				//Para verificar se o pedido anterior ja foi remunerado 
				SZ5->(DbSetOrder(1)) 
				If SZ5->(DbSeek(xFilial("SZ5")+cPedGar)) .And. !Empty(cPedGar) 
					
					dDatPed := SZ5->Z5_DATPED 
					
					If !Empty(SZ5->Z5_DATVER) .And. AllTrim(SZ5->Z5_STATUS) $ "3/4" .And. Empty(SZ5->Z5_PEDGANT)  
						cRet := "PAGANT" 
					ElseIf !Empty(SZ5->Z5_DATEMIS) .And. AllTrim(SZ5->Z5_STATUS) $ "3/4" .And. !Empty(SZ5->Z5_PEDGANT)  
						cRet := "PAGANT"				 
					Endif 
					
				Endif 
				
				If !Empty(cPedGar) 
					//Indice - Filial + Pedido Gar 
					SZG->(DbSetOrder(1)) 
					If SZG->(DbSeek(xFilial("SZG")+cPedGar)) 
						//Indice - Filial + Voucher 
						SZF->(DbSetOrder(2)) 
						lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC)) 
					Endif 
				Endif 
				
				If !Empty(cPedSite) .And. !lPosicao 
					//Indice - Filial + Pedido Site  
					SZG->(DbSetOrder(3)) 
					If SZG->(DbSeek(xFilial("SZG")+cPedSite)) 
						//Indice - Filial + Voucher 
						SZF->(DbSetOrder(2)) 
						lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC)) 
					Endif 
				Endif 
				
				If !Empty(cVouAnt) .And. !lPosicao 
					//Indice - Filial + Voucher 
					SZF->(DbSetOrder(2)) 
					lPosicao := SZF->(DbSeek(xFilial("SZF")+cVouAnt)) 
				Endif 
				
				
				//Vouchers que não s?o pagos 
				If lPosicao .And. SZF->ZF_TIPOVOU$"1/3/6/7/8/G/N" 
					cRet := "NAOPAG" 
				//Armazena o tipo do voucher de origem 
				Elseif lPosicao 
					cTipOri := SZF->ZF_TIPOVOU 
				Endif 
				
				//Renato Ruy - 25/07/2017 
				//Caso o voucher ou pedido anterior igual ao atual, sai do la?o. 
				If lPosicao .And. cPedGar == SZF->ZF_PEDIDO .And. cPedSite == SZF->ZF_PEDSITE .And. cVouAnt == SZF->ZF_CODORIG 
					cPedGar  := " " 
					cPedSite := " " 
					cVouAnt  := " " 
				Elseif lPosicao .And. Empty(cRet) 
					cPedGar  := Iif(Val(SZF->ZF_PEDIDO)>0,AllTrim(Str(Val(SZF->ZF_PEDIDO)))," ") 
					cPedSite := Iif(Val(SZF->ZF_PEDSITE)>0,AllTrim(Str(Val(SZF->ZF_PEDSITE)))," ") 
					cVouAnt  := SZF->ZF_CODORIG 
				Else 
					cPedGar  := " " 
					cPedSite := " " 
					cVouAnt  := " " 
				Endif 
	
			Enddo 
			
		EndIf 
		
	EndIf  
	
	RestArea(nRecnoZ5) 
Return {cRet,dDatPed,cTipOri} 
 
//Renato Ruy - 18/01/2018 
//Tratamento especifico para BV 
Static Function CRPA20BV() 
	Local aAreaSZ5 := SZ5->(GetArea()) 
	Local aAreaPA8 := PA8->(GetArea()) 
	Local aAreaSZF := SZF->(GetArea()) 
	Local aAreaSZG := SZG->(GetArea()) 
	Local cPedGAR	 := "" 
	Local cPedSite := "" 
	Local cVoucher := "" 
	Local cProduto := "" 
	Local lPosicao := .T. 
	Local nValor	 := 0 
	Local nValHw	:= 0 
	
	SZF->(DbSetOrder(2)) 
	If SZF->(DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU)) 
		
		While lPosicao .And. Empty(cProduto) 
		
			cPedGAR  := SZF->ZF_PEDIDO 
			cPedSite := SZF->ZF_PEDSITE 
			cVoucher := SZF->ZF_CODORIG 
			lPosicao := .F. 
			
			If Val(cPedGar) > 0 .And. SZ5->(DbSeek(xFilial("SZ5")+cPedGar)) 
				lPosicao := .T. 
				cProduto := Iif(Empty(SZ5->Z5_PRODGAR),"Z",SZ5->Z5_PRODGAR) 
			Elseif Val(cPedGar) > 0 
				SZG->(DbSetOrder(1)) 
				If SZG->(DbSeek(xFilial("SZG")+cPedGAR)) 
					lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC)) 
				Endif 
			Endif 
			
			If Val(cPedSite) > 0 .And. !lPosicao 
				SZG->(DbSetOrder(3)) 
				If SZG->(DbSeek(xFilial("SZG")+cPedSite)) 
					lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC)) 
				Endif 
			Endif  
				
			If Val(cVoucher) > 0 .And. !lPosicao 
				lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC)) 
			Endif  
		
		Enddo	 
	
		nValor := SZ5->Z5_VALORSW 
		nValHw := SZ5->Z5_VALORHW 
	
	Endif 
	
	/*If !Empty(cProduto) 
		PA8->(DbSetOrder(1)) 
		If PA8->(DbSeek(xFilial("PA8")+cProduto)) 
			nValor := PA8->PA8_VLSOFT 
		Endif 
	Endif*/ 
	
	
	RestArea(aAreaSZ5) 
	RestArea(aAreaPA8) 
	RestArea(aAreaSZF) 
	RestArea(aAreaSZG) 
Return {nValor,nValHw,cProduto} 
 
//Renato Ruy - 24/07/2018 
//Grava Descrição atual do CCR 
User Function CRPA020C() 
	Local bValid := {|| .T. } 
	Local aPar 	 := {} 
	Private aRet := {} 
	
	//Utilizo parambox para fazer as perguntas 
	aAdd( aPar,{ 1  ,"Periodo " 	 	,Space(6)	,"","","","",50,.F.}) 
	aAdd( aPar,{ 2  ,"Tipo Ent." 	 	,"4=Posto"	,{"4=Posto","1=Canal","2=AC","3=Cartorio","7=Campanha","8=Federacao","10=Clube"}, 100,'.T.',.T.}) 
	aAdd( aPar,{ 2  ,"Atualiza" 	 	,"2=Nao" 	,{"2=Nao","1=Sim"}, 100,'.T.',.T.}) 
	
	If ParamBox( aPar, 'Par?metros', @aRet, bValid, , , , , ,"CRPA20C" , .T., .F. ) 
		Processa( {|| CRPA20C() }, "Grava CCR Atual no lan?amento...") 
	Else 
		Alert("Rotina Cancelada!") 
	EndIf 
Return 
 
//Renato Ruy - 24/07/2018 
//Processa gravacao do CCR 
Static Function CRPA20C() 
	Local cWhere := "" 
	Local lAtuReg:= .T. 
	Local nConta := 0 
	
	If aRet[2] == "2" 
		cWhere := "% Z6_TPENTID IN ('2','5') AND %" 
	Else 
		cWhere := "% Z6_TPENTID = '"+aRet[2]+"' AND %" 
	Endif 
	
	If Select("TMPCCR") > 0 
		DbSelectArea("TMPCCR") 
		TMPCCR->(DbCloseArea()) 
	Endif 
	
	IncProc( "SELECIONANDO DADOS .... " ) 
	ProcessMessage() 
	
	//Busca os registros que serao atualizados no processo. 
	Beginsql Alias "TMPCCR" 
	
		%NoParser% 
		
		SELECT  Z6_PEDGAR PEDGAR,  
				SZ6.R_E_C_N_O_ RECNOZ6, 
				Z6_PEDSITE PEDSITE, 
				Z3_DESENT CCRCOM 
		FROM %Table:SZ6% SZ6 
		JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = %xFilial:SZ3% AND Z3_CODENT = Z6_CODCCR AND SZ3.%NOTDEL% 
		where 
		Z6_FILIAL = %xFilial:SZ6% AND 
		Z6_PERIODO = %Exp:aRet[1]% AND 
		%Exp:cWhere% 
		SZ6.%NOTDEL% 
	Endsql 
	
	
	//Efetua contagem de registros 
	If Select("TMPNUM") > 0 
		DbSelectArea("TMPNUM") 
		TMPNUM->(DbCloseArea()) 
	Endif 
	
	Beginsql Alias "TMPNUM" 
	
		%NoParser% 
		
		SELECT  COUNT(*) TOTAL 
		FROM %Table:SZ6% SZ6 
		JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = %xFilial:SZ3% AND Z3_CODENT = Z6_CODCCR AND SZ3.%NOTDEL% 
		where 
		Z6_FILIAL = %xFilial:SZ6% AND 
		Z6_PERIODO = %Exp:aRet[1]% AND 
		%Exp:cWhere% 
		SZ6.%NOTDEL% 
	Endsql 
	
	//Seta Regua de processamento com a contagem de registros 
	ProcRegua(TMPNUM->TOTAL) 
	
	DbSelectArea("SZ6") 
	
	While !TMPCCR->(EOF()) 
		
		//Posiciona na tabela atraves do recno 
		SZ6->(DbGoTo(TMPCCR->RECNOZ6)) 
		
		IncProc( "Atualizando Pedido: "+Iif(Empty(SZ6->Z6_PEDGAR),SZ6->Z6_PEDSITE,SZ6->Z6_PEDGAR) ) 
		
		//Diminui a interacao da regua com usuario, para otimizar tempo de processamento 
		If nConta >79 
			ProcessMessage() 
			nConta := 0 
		Else 
			nConta++ 
		Endif 
		
		//Se o usuario solicitar a atualizacao o sistema grava mesmo o registro ja preenchido 
		lAtuReg:= aRet[3] == "1" .Or. Empty(SZ6->Z6_CCRCOM) 
		
		//Verifica se esta posicionado no registro 
		If TMPCCR->RECNOZ6 == SZ6->(Recno()) .And. lAtuReg 
			//Grava a descricao do CCR. 
			Reclock("SZ6",.F.) 
				SZ6->Z6_CCRCOM := TMPCCR->CCRCOM 
			SZ6->(MsUnlock()) 
		Endif 
		
		//Pula para o proximo registro 
		TMPCCR->(DbSkip()) 
	Enddo 
	
	MsgInfo("As descri??es do CCR foram gravadas com sucesso!") 
Return 
 
User Function CRP020Cpy(cAlias,nReg,nOpc) 
	Local aPergs 	:= {} 
	
	Private aPedidos 	:= {} 
	Private aRet 		:= {} 
	
	aAdd( aPergs ,{11,"Pedidos"			,SZ6->Z6_PEDGAR		,'.T.','.T.',.F.}) 
	aAdd( aPergs ,{1 ,"Percentual Sw"	,0 					,"@E 999.99"		, "", "", "", 50, .F.}) 
	aAdd( aPergs ,{1 ,"Valor Base Sw"	,0					,"@E 99,999,999.99" , "", "", "", 50, .F.}) 
	aAdd( aPergs ,{1 ,"Percentual Hw"	,0 					,"@E 999.99"		, "", "", "", 50, .F.}) 
	aAdd( aPergs ,{1 ,"Valor Base Hw"	,0					,"@E 99,999,999.99" , "", "", "", 50, .F.}) 
	aAdd( aPergs ,{6 ,"Gerar relat?rio"	,Space(70)			,""	  ,"","",50,.F.,"Arquivos .CSV |*.CSV"}) 
	
	If !ParamBox(aPergs ,"C?pia de Remuneração ",aRet) 
		Alert("A c?pia foi cancelada!") 
		Return 
	EndIf 
	
	//Retira virgula caso esteja no final 
	aRet[1] := Iif(Substr(aRet[1] ,len(aRet[1] ),1)==",",Substr(aRet[1] ,1,len(aRet[1])-1),aRet[1]) 
	
	//Cria um array para não estourar a quantidade de pedidos 
	aPedidos := StrToArray(aRet[1],chr(13)+chr(10)) 
	
	Processa( {|| CRP20Cpy() }, "Selecionando registros...") 
Return 
 
Static Function CRP20Cpy() 
	Local aStrucSZ6	:= SZ6->( DbStruct() ) 
	Local aDadosSZ6 := {} 
	Local aCopiaSZ6	:= {} 
	Local cCampo	:= "" 
	Local nBaseSw	:= aRet[3] 
	Local nPerSw	:= aRet[2] / 100 
	Local nBaseHw	:= aRet[5] 
	Local nPerHw	:= aRet[4] / 100 
	Local cCatProd  := "" 
	Local cRotina	:= "CRP020CPY" 
	Local cPedido	:= "" 
	Local cPeriodo	:= "" 
	Local Nz, Nj, Ni, Nk, Nx 
	
	dbSelectArea("SZ6") 
	SZ6->(dbSetOrder(1)) 
	
	For Ni := 1 To Len(aPedidos) 
	
		If SZ6->(dbSeek(xFilial("SZ6")+aPedidos[Ni])) 
		
			Aadd( aDadosSZ6, {} ) 
		
			cPeriodo := SZ6->Z6_PERIODO 
			cPedido  := SZ6->Z6_PEDGAR 
	
			Nz := 0 
			While SZ6->(!EoF()) .And. SZ6->Z6_PERIODO + SZ6->Z6_PEDGAR == cPeriodo + cPedido   
		
				Aadd( aDadosSZ6[Ni], Array(Len(aStrucSZ6)) ) 
				Nz++ 
		
				For Nj := 1 To Len(aStrucSZ6) 
					cCampo := AllTrim(aStrucSZ6[Nj][1]) 
					aDadosSZ6[Ni][Nz][Nj] := &("SZ6->"+cCampo) 
				Next Nj	 
			
				aAdd(aTail(aDadosSZ6[Ni]),SZ6->(Recno())) 
				
				SZ6->(dbSkip()) 
			EndDo 
		
		EndIf 
		
	Next Ni 
	
	aCopiaSZ6 := aClone(aDadosSZ6) 
	
	For Nx := 1 To Len(aCopiaSZ6) 
		For Nz := 1 To Len(aCopiaSZ6[Nx]) 
			For Nk := 1 To Len(aStrucSZ6) 
				cCampo := AllTrim(aStrucSZ6[nK][1]) 
			
				cCatProd := aCopiaSZ6[Nx][Nz][aScan(aStrucSZ6,{|z| AllTrim(z[1]) == "Z6_CATPROD"})] 
			
				Do Case 
					Case cCampo == "Z6_PERIODO" 
						aCopiaSZ6[Nx][Nz][Nk]	:= cRemPer 
					
					Case cCampo == "Z6_BASECOM" 
					
						If  cCatProd == "1" .And. nBaseHw > 0 
							aCopiaSZ6[Nx][Nz][Nk]	:= nBaseHw 
						ElseIf cCatProd == "2" .And. nBaseSw > 0 
							aCopiaSZ6[Nx][Nz][Nk]	:= nBaseSw 
						EndIf 
						
						If cCatProd == "1" 
							nBaseHw := aCopiaSZ6[Nx][Nz][Nk] 
						ElseIf cCatProd == "2" 
							nBaseSw := aCopiaSZ6[Nx][Nz][Nk] 
						EndIf  
						
					Case cCampo == "Z6_VALCOM" 
		
						If cCatProd == "1" .And. nPerHw > 0 
							aCopiaSZ6[Nx][Nz][Nk] := nBaseHw * nPerHw 
						ElseIf cCatProd == "2" .And. nBaseSw > 0 
							aCopiaSZ6[Nx][Nz][Nk] := nBaseSw * nPerSw 
						EndIf 
		
					Case cCampo == "Z6_REGCOM" 
						cAux := Substr(aDadosSZ6[Nx][Nz][Nk],rat("-",aDadosSZ6[Nx][Nz][Nk])+1) 
						aCopiaSZ6[Nx][Nz][nK]	:= "COPIA-" + DtoC(dDatabase)+"-"+Time()+"-"+AllTrim(cUserName)+"-"+cRotina+"-"+cAux 
					
					Case cCampo == "Z6_TIPO" 
						//aDadosSZ6[Nx][nK]	:= "RECANT" 
				Endcase 
			Next Nk 
		Next Nz 
	Next Nx 
	
	Begin Transaction 
	
	For Ni := 1 To Len(aCopiaSZ6) 
		For Nk := 1 To Len(aCopiaSZ6[Nk]) 
		
			RecLock("SZ6",.T.)  
				For Nj:= 1 To Len(aStrucSZ6) 
					cCampo := AllTrim(aStrucSZ6[Nj][1]) 
					&("SZ6->"+cCampo) := aCopiaSZ6[Ni][Nk][Nj] 
				Next Nj 
	
				SZ6->Z6_RECORI := AllTrim(Str(aCopiaSZ6[Ni][Nk][Nj])) 
			SZ6->( MsUnLock() ) 
			
		Next Nk 
	Next Ni 
	
	End Transaction 
Return 
 
/* 
	Mensagem a ser gravada no campo Memo: 
 
	{"pedido": { 
			"numero": 123456789, 
			"voucher":  
		} 
	} 
	 
	Blocos da Rotina: 
	================= 
	"RESERVA" - No momento da reserva do processamento  
	"WEBSERV" - Consulta do WebService para atualizar SZ5 
	"LOADVAR" - Carregamento das vari?veis utilizadas na rotina 
	"CALCULO" - Bloco de c?lculo geral 
	"CAMPANH" - BLoco de c?lculo para Campanha 
	"POLOMAS" - Trecho de c?lculo Polomasther Adicional 
	"FACESPP" - Trecho de c?lculo Facesp Revendedor Provis?rio 
	"DTARRAY" - Bloco para grava??o de dados em array 
	"REEMBOL" - Bloco de an?lise de reembolso 
	"EXCEPTI" - BLoco de an?lise de exce??es 
	"VOUCHER" - Bloco de an?lise de Vouchers 
	 
	Cabe?alho do JSON: 
	================== 
	numero 	     - N?mero do pedido 
	voucher 	 - Estrutura contendo os dados do voucher e do pedido original 
	ccr 		 - Dados do CCR de c?lculo 
	periodo 	 - Per?odo de refer?ncia do calculo 
	produto 	 - Produto do Pedido 
	dataVerifica - Data de Verifica??o do pedido 
	dataValida	 - Data de Validação do Pedido 
	dataEmissao  - Data de Emissao do Pedido 
	blocos	 	 - Estrutura contendo os calculos realizados no pedido 
	 
	Estrutura BLOCOS: 
	================= 
	 
	 
	 
	Exce??o [Produto IFEN para AR ABCERTIFICA não calcula IFEN 3%] 
	{Stack: 
		CRPA020 - Linha(nn) 
		Pedido: 1234567890 
		Status: não Calculado (não consta no relat?rio) 
		C?lculo: Posto/AC/AR/Canal/Canal2/Ferderação/Campanha 
		 
		** Lista de Vari?veis de Controle ** 
		Vari?vel1 (Tipo) => Valor 
		Vari?vel2 (Tipo) => Valor 
		... 
		Vari?velN (Tipo) => Valor 
		 
		** Condi??o Avaliada [Regra]** 
		("TESTE" $ SZ5->Z5_TESTE .Or. Empty(cCodAc)) .And. Ni != 2 [.T.] (Retorno do teste)  
	} 
 
*/ 
Static Function CRPA020LOG(nStatus,cMsg,aVariaveis,cCondicao,nLinha,cUserName) 
	Local cMensagem := "" 
	Local cStatus 	:= "" 
	Local nPosNi	:= aScan(aVariaveis,{|z| z[1] == "Ni"}) 
	Local lNewReg	:= .F. 
	Local cCiclo	:= "" 
	Local cJson		:= "" 
	Local Nq 
	
	Do Case 
		Case nStatus == 1 
			cStatus := "não Calculado" 
		Case nStatus == 2 
			cStatus := "Calculado Zerado" 
		Case nStatus == 0 
			cStatus := "Calculado" 
	EndCase   
	
	/*cMensagem := "Exce??o [" + cMsg + "]" + CRLF 
	cMensagem += "{Stack:" + CRLF 
	cMensagem += "	" + FunName() + " - Linha (" + cValToChar(nLinha) + ")" + CRLF 
	cMensagem += "	Pedido: " + SZ5->Z5_PEDGAR + CRLF 
	cMensagem += "	Status: " + cStatus + CRLF*/  
	
	/*If nPosNi > 0 
		cMensagem += "	C?lculo: " 
		Do Case 
			Case aVariaveis[nPosNi][2] == 1 
				cMensagem += "Posto" + CRLF 
			Case aVariaveis[nPosNi][2] == 2 
				cMensagem += "AC" + CRLF 
			Case aVariaveis[nPosNi][2] == 3 
				cMensagem += "Canal" + CRLF 
			Case aVariaveis[nPosNi][2] == 4 
				cMensagem += "Canal 2" + CRLF 
			Case aVariaveis[nPosNi][2] == 5 
				cMensagem += "Ferderação" + CRLF 
			Case aVariaveis[nPosNi][2] == 6 
				cMensagem += "Campanha" + CRLF 
			Case aVariaveis[nPosNi][2] == 7 
				cMensagem += "AR" + CRLF 
			Otherwise 
				cMensagem += "Fora do calculo" + CRLF 
		EndCase 
	EndIf*/ 
	
	/*cMensagem += CRLF 
	cMensagem += "	** Lista de Vari?veis de Controle **" + CRLF*/ 
	
	/*cMensagem += CRLF 
	cMensagem += "	** Condi??o Avaliada [Regra] **" + CRLF 
	cMensagem += "	["+cCondicao+"] " +CRLF 
	cMensagem += "}"*/ 
	
	dbSelectArea("PBY") 
	PBY->(dbSetOrder(3)) 
	
	lNewReg := !PBY->(dbSeek(xFilial("PBY") + SZ5->Z5_PEDGAR + AllTrim(Str(ThreadId())))) 
	
	If nPosNi > 0 
		cMensagem += "	C?lculo: " 
		Do Case 
			Case aVariaveis[nPosNi][2] == 1 
				cMensagem += "Posto" + CRLF 
				cCiclo := "Posto" 
			Case aVariaveis[nPosNi][2] == 2 
				cMensagem += "AC" + CRLF 
				cCiclo := "AC" 
			Case aVariaveis[nPosNi][2] == 3 
				cMensagem += "Canal" + CRLF 
				cCiclo := "Canal" 
			Case aVariaveis[nPosNi][2] == 4 
				cMensagem += "Canal 2" + CRLF 
				cCiclo := "Canal 2" 
			Case aVariaveis[nPosNi][2] == 5 
				cMensagem += "Ferderação" + CRLF 
				cCiclo := "Ferderação" 
			Case aVariaveis[nPosNi][2] == 6 
				cMensagem += "Campanha" + CRLF 
				cCiclo := "Campanha" 
			Case aVariaveis[nPosNi][2] == 7 
				cMensagem += "AR" + CRLF 
				cCiclo := "AR" 
			Otherwise 
				cMensagem += "Fora do calculo" + CRLF 
				cCiclo := "Fora do C?lculo" 
		EndCase 
	EndIf 
	
	If lNewReg 
		cJson := "[" 
		cJson += '	"pedido:"' + SZ5->Z5_PEDGAR + CRLF 
	Else 
		cJson += ','+ CRLF 
	EndIf 
	
	cJson += '	"stack": {' + CRLF 
	cJson += '		"mensagem": "' + cMsg + '",' + CRLF 
	cJson += ' 		"ciclo": "' + cCiclo + '",' + CRLF 
	cJson += '		"linha": ' + cValToChar(nLinha) + ',' + CRLF 
	cJson += '		"status": "' + cStatus + '",' + CRLF 
	cJson += '		"variaveis": [' + CRLF 
	
	For Nq := 1 To Len(aVariaveis) 
		cJson += '	{' + CRLF 
		cJson += '	"nome": "' + aVariaveis[Nq][1] + '",' + CRLF 
		cJson += '	"tipo": "' + ValType(aVariaveis[Nq][2]) + '",' + CRLF 
		cJson += '	"valor": "' + cValToChar(aVariaveis[Nq][2]) + '",' + CRLF 
		cJson += '}' + CRLF 
		If Nq < Len(aVariaveis) 
			cJson += ',' 
		EndIf 
		
		//cMensagem += "	" + aVariaveis[Nq][1] + "("+ ValType(aVariaveis[Nq][2]) +") => " + cValToChar(aVariaveis[Nq][2]) + CRLF  
	Next 
	
	cJson += '],'+ CRLF 
	cJson += '"condicaoTestada": "' + cCondicao + '"' + CRLF 
	cJson += '}'+ CRLF 
	
	If lNewReg 
		RecLock("PBY",lNewReg) 
			PBY->PBY_FILIAL := xFilial("PBY") 
			PBY->PBY_THREAD := ThreadId() 
			PBY->PBY_FUNCAO := "CRPA020" 
			PBY->PBY_USERID := cUserName 
			PBY->PBY_DATA	:= dDataBase 
			PBY->PBY_HORA	:= Time() 
			PBY->PBY_PEDIDO	:= SZ5->Z5_PEDGAR 
			PBY->PBY_PEDSIT := SZ5->Z5_PEDSITE 
			PBY->PBY_LOG 	:= cJson 
		PBY->(MsUnlock()) 
	Else 
		RecLock("PBY",lNewReg) 
			PBY->PBY_LOG	:= PBY->PBY_LOG + CRLF + cJson 
		PBY->(MsUnlock()) 
	EndIf 
Return 
 
/////////////////////////////SAGE 
Static Function CRPA020S(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem) 
	Local aStrucSZ6	:= SZ6->( DbStruct() ) 
	Local aDadosSZ6	:= {} 
	Local nQtdReg	:= 0 
	Local nZ		:= 0 
	Local nBaseSw	:= 0 
	Local nBaseHw	:= 0 
	Local nValSw	:= 0 
	Local nValHw	:= 0 
	Local cRegSw	:= 0 
	Local cRegHw	:= 0 
	Local nPerSW	:= 0 
	Local nPerHW	:= 0 
	Local cNewCCR	:= Padr(AllTrim(GetNewPar("MV_XSAGENT","086161")),TamSX3("Z3_CODENT")[1]) 
	Local aAreaSZ3  := SZ3->(GetArea()) 
	Local aAreaSZ4  := SZ4->(GetArea()) 
	Local Nx
	Local Nj
	Local Nk
	Local Ni 
	
	//Me posiciono na entidade. 
	SZ3->(DbSetOrder(1)) 
	If !SZ3->(DbSeek(xFilial("SZ3") + cNewCCR)) 
		Return 
	EndIf 
	
	//Se o CCR nao esta ativo ou produto nao tem a categoria, nao faco calculo. 
	If SZ3->Z3_TIPCOM <> "1" .OR. cCatProd == "NE" 
		Return 
	EndIf 
	
	//Me posiciono para buscar o percentual. 
	SZ4->(DbSetOrder(1)) 
	If SZ4->(DbSeek(xFilial("SZ4")+ cNewCCR + cCatProd)) 
	
		nPerSW	:= SZ4->Z4_PARSW 
		nPerHW	:= SZ4->Z4_PARHW 
	
		nBaseSw	:= nValTotSw - (nValTotSw * SZ4->Z4_PORIR / 100) 
		nBaseHw	:= nValTotHw - (nValTotHw * SZ4->Z4_PORIR / 100) 
	
		If !Empty(nPerSW) 
			nValSw	:= nBaseSw * (nPerSW/100) 
			cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE SOFTWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
		Else 
			nValSw	:= SZ4->Z4_VALSOFT 
			cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (REMUNERACAO SAGE VALOR FIXO) >>> " 
		Endif 
	
		If !Empty(nPerHW) 
			nValHw	:= nBaseHw * (nPerHW/100) 
			cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE HARDWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
		Else 
			nValHw	:= SZ4->Z4_VALHARD 
			cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (REMUNERACAO SAGE VALOR FIXO) >>> " 
		Endif 
		
		//Se tem percentual de calculo, gera lancamento 
		If nValSw > 0  
			nQtdReg += 1 
		EndIf 
	EndIf		 
	
	For nX :=1 To nQtdReg 
		Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			Do Case 
				Case aStrucSZ6[nJ][2] == "C" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
				Case aStrucSZ6[nJ][2] == "N" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := 0 
				Case aStrucSZ6[nJ][2] == "D" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//") 
				Otherwise 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
			Endcase 
		Next nJ 
	Next nX 
	
	
	For nX := 1 To nQtdReg 
		nZ	:=	nZ	+	1 
		For nK := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nK][1]) 
			Do Case 
				Case cCampo == "Z6_FILIAL" 
					aDadosSZ6[nZ][nK]	:= xFilial("SZ6") 
				Case cCampo == "Z6_PERIODO" 
					aDadosSZ6[nZ][nK]	:= cRemPer 
				Case cCampo == "Z6_TPENTID" 
					aDadosSZ6[nZ][nK]	:= "11" 
				Case cCampo == "Z6_CODENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_CODENT 
				Case cCampo == "Z6_DESENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_DESENT 
				Case cCampo == "Z6_PRODUTO" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR), SZ5->Z5_PRODUTO,SZ5->Z5_PRODGAR) 
				Case cCampo == "Z6_CATPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware 
				Case cCampo == "Z6_DESCRPR" 
					If lPedEcom 
						If Empty(Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
							aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
						Else 
							aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
						EndIf 
					Else 
						aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
					EndIf 
				Case cCampo == "Z6_PEDGAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGAR 
				Case cCampo == "Z6_DTPEDI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATPED 
				Case cCampo == "Z6_VERIFIC" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa,SZ5->Z5_EMISSAO,SZ5->Z5_DATVER) 
				Case cCampo == "Z6_VALIDA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATVAL 
				Case cCampo == "Z6_DTEMISS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATEMIS 
				Case cCampo == "Z6_TIPVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_TIPVOU 
				Case cCampo == "Z6_CODVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVOU 
				Case cCampo == "Z6_VLRPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nValTotSw,nValTotHw) 
				Case cCampo == "Z6_BASECOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nBaseSw,nBaseHw) 
				Case cCampo == "Z6_VALCOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValSw,nValHw) 
				Case cCampo == "Z6_REGCOM" 
					aDadosSZ6[nZ][nK]	:= DtoC(dDatabase)+"-"+Time()+"-"+AllTrim(cNomeUsu)+"-"+SubStr(IF(!lMidiaAvulsa .And. nX == 1,cRegSw,cRegHw),1,100) 
				Case cCampo == "Z6_CODPOS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPOS 
				Case cCampo == "Z6_CODCCR" 
					aDadosSZ6[nZ][nK]	:= cNewCCR 
				Case cCampo == "Z6_CCRCOM" 
					aDadosSZ6[nZ][nK]	:= "" 
				Case cCampo == "Z6_CODPAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPAR 
				Case cCampo == "Z6_CODFED" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMPAR 
				Case cCampo == "Z6_CODVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVEND 
				Case cCampo == "Z6_NOMVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMVEND 
				Case cCampo == "Z6_TIPO" 
					If !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) .And. lOriCupom //Pedido com voucher de origem não pago. 
						aDadosSZ6[nZ][nK]	:= "NAOPAG" 
					Elseif "CRPA027R-REE" == cNomeUsu .Or. !lGerReem //Alteração de status para desconto do reembolso. 
						aDadosSZ6[nZ][nK]	:= "REEMBO" 
					ElseIf !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) //Pedido com voucher Pago Anteriormente. 
						aDadosSZ6[nZ][nK]	:= "PAGANT" 
					ElseIf "RENOVACAO" $ UPPER(SZ5->Z5_DESGRU) .Or. !Empty(SZ5->Z5_PEDGANT) .Or. AllTrim(SZ5->Z5_TIPVOU) == "H"  //Pedido de renovacao. 
						aDadosSZ6[nZ][nK]	:= "RENOVA" 
					ElseIf Empty(SZ5->Z5_PEDGAR) //Pedido de hardware avulso. 
						aDadosSZ6[nZ][nK]	:= "ENTHAR" 
					ElseIf lPedNoRem //Mensagem especifica Pedido não Pago 
						aDadosSZ6[nZ][nK]	:= "PNOPAG"			    	 
					Else //Se nao entra nas outra condicoes e verificacao. 
						aDadosSZ6[nZ][nK]	:= "VERIFI" 
					EndIf 
				Case cCampo == "Z6_PEDSITE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDSITE 
				Case cCampo == "Z6_REDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_GRUPO" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_GRUPO 
				Case cCampo == "Z6_DESGRU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESGRU 
				Case cCampo == "Z6_CODAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODAGE 
				Case cCampo == "Z6_NOMEAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMAGE 
				Case cCampo == "Z6_AGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_AGVER 
				Case cCampo == "Z6_NOAGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOAGVER 
				Case cCampo == "Z6_NTITULA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NTITULA 
				Case cCampo == "Z6_DESREDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESREDE 
				Case cCampo == "Z6_PEDORI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGANT 
				Case cCampo == "Z6_TIPED" 
					aDadosSZ6[nZ][nK]	:= cTiped 
				Case cCampo == "Z6_ACLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_ARLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_CODAR 				 
			Endcase 
		Next nK 
	Next nX 
	
	Begin Transaction 
	
	For nI := 1 To Len(aDadosSZ6) 
		SZ6->( RecLock("SZ6",.T.) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nJ][1]) 
			&("SZ6->"+cCampo) := aDadosSZ6[nI][nJ] 
		Next nJ 
		SZ6->Z6_RECORI := AllTrim(Str(SZ5->(Recno()))) 
		SZ6->( MsUnLock() ) 
	Next nI 
	
	End Transaction 
	
	RestArea(aAreaSZ3) 
	RestArea(aAreaSZ4) 
Return 
 
/*/{Protheus.doc} CRPA20REVL 
//Comp?e valores de reembolso 
@author yuri.volpe 
@since 17/10/2019 
@version 1.0 
 
@type function 
/*/ 
Static Function CRPA20REMB(nCiclo,cPedido) 
	Local cTipEnt 	:= "0" 
	Local aRet		:= {0,0,0,0,0,0,0,0} //Faturamento HW, Faturamento SW, Base HW, Base SW, Comissao Hw, Comissao Sw, Abat Hw, Abat Sw 
	Local cCodEnt	:= "% %" 
	
	Do Case 
		Case nCiclo == 1 //Posto/CCR 
			cTipEnt := "% = '4' %" 
			cCodEnt := "% AND Z6_CODENT = '" + SZ3->Z3_CODENT + "' %" 
		Case nCiclo == 2 //Grupo/Rede 
			cTipEnt := "% IN ('2','5') %"	 
		Case nCiclo == 3 //Canal 
			cTipEnt := "% = '1' %" 
		Case nCiclo == 4 //Canal 2 
			cTipEnt := "% = '1' %"	 
		Case nCiclo == 5 //Ferderação 
			cTipEnt := "% = '8' %" 
		Case nCiclo == 6 //Campanha/Revendedor 
			cTipEnt := "% IN ('7','10') %" 
		Case nCiclo == 7 //AR 
			cTipEnt := "% = '3' %" 
		Case nCiclo == 8 //SAGE 
			cTipEnt := "% = '11' %" 
	EndCase 
	
	If Select("TMPVAL") > 0 
		TMPVAL->(dbCloseArea()) 
	EndIf 
	
	Beginsql Alias "TMPVAL" 
		SELECT SUM(Z6_VLRPROD) VALOR_FATURAMENTO, 
			SUM(Z6_BASECOM) VALOR_BASE, 
			SUM(Z6_VALCOM) VALOR_COMISSAO, 
			SUM(Z6_VLRABT) VALOR_ABAT, 
			Z6_CATPROD 
		FROM SZ6010  
		WHERE  
			Z6_PEDGAR = %Exp:cPedido%  
		AND Z6_TPENTID %Exp:cTipEnt% 
		AND Z6_FILIAL = ' '  
		AND D_E_L_E_T_ = ' '  
		AND Z6_TIPO NOT IN ('DESCON','EXTRA','REEMBO') 
		%Exp:cCodEnt% 
		GROUP BY Z6_CATPROD,Z6_TIPO,Z6_CODENT,Z6_TPENTID 
	Endsql 
	
	While TMPVAL->(!EoF()) 
		If AllTrim(TMPVAL->Z6_CATPROD) == "1" 
			aRet[1] := TMPVAL->VALOR_FATURAMENTO 
			aRet[3] := TMPVAL->VALOR_BASE 
			aRet[5] := TMPVAL->VALOR_COMISSAO 
			aRet[7] := TMPVAL->VALOR_ABAT 
		ElseIf AllTrim(TMPVAL->Z6_CATPROD) == "2" 
			aRet[2] := TMPVAL->VALOR_FATURAMENTO 
			aRet[4] := TMPVAL->VALOR_BASE 
			aRet[6] := TMPVAL->VALOR_COMISSAO 
			aRet[8] := TMPVAL->VALOR_ABAT 
		EndIf 
		TMPVAL->(dbSkip()) 
	EndDo 
Return aRet 
 
Static Function CRPA20ASS(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem,cCanal1,cCanal2,cCodCCR,lCampanha,lPedEcom) 
	Local aStrucSZ6	:= SZ6->( DbStruct() ) 
	Local aDadosSZ6	:= {} 
	Local nQtdReg	:= 0 
	Local nZ		:= 0 
	Local nBaseSw	:= 0 
	Local nBaseHw	:= 0 
	Local nValSw	:= 0 
	Local nValHw	:= 0 
	Local cRegSw	:= 0 
	Local cRegHw	:= 0 
	Local nPerSW	:= 0 
	Local nPerHW	:= 0 
	Local cCanal	:= "" 
	Local aAreaSZ3  := SZ3->(GetArea()) 
	Local aAreaSZ4  := SZ4->(GetArea()) 
	Local Nx
	Local Nj
	Local Nk
	Local Ni 
	
	If !Empty(cCanal1) 
		cCanal := cCanal1 
	EndIf 
	
	If !Empty(cCanal2) 
		cCanal := cCanal2 
	EndIf 
	
	//Me posiciono na entidade. 
	SZ3->(DbSetOrder(1)) 
	If !SZ3->(DbSeek(xFilial("SZ3") + cCanal)) 
		Return 
	EndIf 
	
	//Se o CCR nao esta ativo ou produto nao tem a categoria, nao faco calculo. 
	If SZ3->Z3_TIPCOM <> "1" .OR. cCatProd == "NE" 
		Return 
	EndIf 
	
	//Me posiciono para buscar o percentual. 
	SZ4->(DbSetOrder(1)) 
	If SZ4->(DbSeek(xFilial("SZ4") + cCanal)) 
	
		nPerSW	:= SZ4->Z4_PORSOFT //SZ4->Z4_PARSW 
		nPerHW	:= SZ4->Z4_PORHARD //SZ4->Z4_PARHW 
	
		nBaseSw	:= nValTotSw - (nValTotSw * SZ4->Z4_PORIR / 100) 
		nBaseHw	:= nValTotHw - (nValTotHw * SZ4->Z4_PORIR / 100) 
	
		If !Empty(nPerSW) 
			nValSw	:= nBaseSw * (nPerSW/100) 
			cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL ASSESSORIA SW "+Iif(lCampanha,"CAMPANHA","VERIFICACAO")+") >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
		Else 
			nValSw	:= SZ4->Z4_VALSOFT 
			cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (REMUNERACAO ASSESSORIA SW FIXO "+Iif(lCampanha,"CAMPANHA","VERIFICACAO")+") >>> " 
		Endif 
	
		If !Empty(nPerHW) 
			nValHw	:= nBaseHw * (nPerHW/100) 
			cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL ASSESSORIA HW "+Iif(lCampanha,"CAMPANHA","VERIFICACAO")+") >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
		Else 
			nValHw	:= SZ4->Z4_VALHARD 
			cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (REMUNERACAO ASSESSORIA HW FIXO "+Iif(lCampanha,"CAMPANHA","VERIFICACAO")+") >>> " 
		Endif 
		
		//Se tem percentual de calculo, gera lancamento 
		If nValSw > 0  
			nQtdReg += 1 
		EndIf 
		If nValHw > 0  
			nQtdReg += 1 
		EndIf 
	EndIf		 
	
	For nX :=1 To nQtdReg 
		Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			Do Case 
				Case aStrucSZ6[nJ][2] == "C" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
				Case aStrucSZ6[nJ][2] == "N" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := 0 
				Case aStrucSZ6[nJ][2] == "D" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//") 
				Otherwise 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
			Endcase 
		Next nJ 
	Next nX 
	
	
	For nX := 1 To nQtdReg 
		nZ	:=	nZ	+	1 
		For nK := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nK][1]) 
			Do Case 
				Case cCampo == "Z6_FILIAL" 
					aDadosSZ6[nZ][nK]	:= xFilial("SZ6") 
				Case cCampo == "Z6_PERIODO" 
					aDadosSZ6[nZ][nK]	:= cRemPer 
				Case cCampo == "Z6_TPENTID" 
					aDadosSZ6[nZ][nK]	:= "1" 
				Case cCampo == "Z6_CODENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_CODENT 
				Case cCampo == "Z6_DESENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_DESENT 
				Case cCampo == "Z6_PRODUTO" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR), SZ5->Z5_PRODUTO,SZ5->Z5_PRODGAR) 
				Case cCampo == "Z6_CATPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware 
						Case cCampo == "Z6_DESCRPR" 
							If lPedEcom 
								If Empty(Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
									aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
								Else 
									aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
								EndIf 
							Else 
								aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
							EndIf 
				Case cCampo == "Z6_PEDGAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGAR 
				Case cCampo == "Z6_DTPEDI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATPED 
				Case cCampo == "Z6_VERIFIC" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa,SZ5->Z5_EMISSAO,SZ5->Z5_DATVER) 
				Case cCampo == "Z6_VALIDA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATVAL 
				Case cCampo == "Z6_DTEMISS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATEMIS 
				Case cCampo == "Z6_TIPVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_TIPVOU 
				Case cCampo == "Z6_CODVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVOU 
				Case cCampo == "Z6_VLRPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nValTotSw,nValTotHw) 
				Case cCampo == "Z6_BASECOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nBaseSw,nBaseHw) 
				Case cCampo == "Z6_VALCOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValSw,nValHw) 
				Case cCampo == "Z6_REGCOM" 
					aDadosSZ6[nZ][nK]	:= DtoC(dDatabase)+"-"+Time()+"-"+AllTrim(cNomeUsu)+"-"+SubStr(IF(!lMidiaAvulsa .And. nX == 1,cRegSw,cRegHw),1,100) 
				Case cCampo == "Z6_CODPOS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPOS 
				Case cCampo == "Z6_CODCCR" 
					aDadosSZ6[nZ][nK]	:= cCodCCR 
				Case cCampo == "Z6_CCRCOM" 
					aDadosSZ6[nZ][nK]	:= "" 
				Case cCampo == "Z6_CODPAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPAR 
				Case cCampo == "Z6_CODFED" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMPAR 
				Case cCampo == "Z6_CODVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVEND 
				Case cCampo == "Z6_NOMVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMVEND 
				Case cCampo == "Z6_TIPO" 
					If !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) .And. lOriCupom //Pedido com voucher de origem não pago. 
						aDadosSZ6[nZ][nK]	:= "NAOPAG" 
					Elseif "CRPA027R-REE" == cNomeUsu .Or. !lGerReem //Alteração de status para desconto do reembolso. 
						aDadosSZ6[nZ][nK]	:= "REEMBO" 
					ElseIf !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) //Pedido com voucher Pago Anteriormente. 
						aDadosSZ6[nZ][nK]	:= "PAGANT" 
					ElseIf "RENOVACAO" $ UPPER(SZ5->Z5_DESGRU) .Or. !Empty(SZ5->Z5_PEDGANT) .Or. AllTrim(SZ5->Z5_TIPVOU) == "H"  //Pedido de renovacao. 
						aDadosSZ6[nZ][nK]	:= "RENOVA" 
					ElseIf Empty(SZ5->Z5_PEDGAR) //Pedido de hardware avulso. 
						aDadosSZ6[nZ][nK]	:= "ENTHAR" 
					ElseIf lPedNoRem //Mensagem especifica Pedido não Pago 
						aDadosSZ6[nZ][nK]	:= "PNOPAG"			    	 
					Else //Se nao entra nas outra condicoes e verificacao. 
						aDadosSZ6[nZ][nK]	:= "VERIFI" 
					EndIf 
				Case cCampo == "Z6_PEDSITE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDSITE 
				Case cCampo == "Z6_REDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_GRUPO" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_GRUPO 
				Case cCampo == "Z6_DESGRU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESGRU 
				Case cCampo == "Z6_CODAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODAGE 
				Case cCampo == "Z6_NOMEAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMAGE 
				Case cCampo == "Z6_AGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_AGVER 
				Case cCampo == "Z6_NOAGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOAGVER 
				Case cCampo == "Z6_NTITULA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NTITULA 
				Case cCampo == "Z6_DESREDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESREDE 
				Case cCampo == "Z6_PEDORI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGANT 
				Case cCampo == "Z6_TIPED" 
					aDadosSZ6[nZ][nK]	:= cTiped 
				Case cCampo == "Z6_ACLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_ARLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_CODAR 				 
			Endcase 
		Next nK 
	Next nX 
	
	Begin Transaction 
	
	For nI := 1 To Len(aDadosSZ6) 
		SZ6->( RecLock("SZ6",.T.) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nJ][1]) 
			&("SZ6->"+cCampo) := aDadosSZ6[nI][nJ] 
		Next nJ 
		SZ6->Z6_RECORI := AllTrim(Str(SZ5->(Recno()))) 
		SZ6->( MsUnLock() ) 
	Next nI 
	
	End Transaction 
	
	RestArea(aAreaSZ3) 
	RestArea(aAreaSZ4) 
Return 
 
/*/{Protheus.doc} CRPA020T 
//TODO Descrição auto-gerada. 
@author yuri.volpe 
@since 07/11/2019 
@version 1.0 
@return ${return}, ${return_description} 
@param cCatProd, characters, descricao 
@param lMidiaAvulsa, logical, descricao 
@param nValTotHw, numeric, descricao 
@param nValTotSw, numeric, descricao 
@param cTiped, characters, descricao 
@param lNaoPagou, logical, descricao 
@param lOriCupom, logical, descricao 
@param cNomeUsu, characters, descricao 
@param lGerReem, logical, descricao 
@param lPedNoRem, logical, descricao 
@type function 
/*/ 
Static Function CRPA020T(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem,cCodPosto,lTemHard,lPedEcom) 
	Local cCodCCR		:= "" 
	Local cCodAR		:= "" 
	Local cQuebra		:= "" 
	Local cCodFeder		:= "" 
	Local cCodAC		:= "" 
	Local cCodCanal		:= "" 
	Local cCodCanal2	:= "" 
	Local lDescred		:= "" 
	Local aStrucSZ6		:= SZ6->( DbStruct() ) 
	Local aDadosSZ6		:= {} 
	Local nQtdReg		:= 0 
	Local nZ			:= 0 
	Local nBaseSw		:= 0 
	Local nBaseHw		:= 0 
	Local nValSw		:= 0 
	Local nValHw		:= 0 
	Local cRegSw		:= 0 
	Local cRegHw		:= 0 
	Local nPerSW		:= 0 
	Local nPerHW		:= 0 
	Local aAreaSZ3  	:= SZ3->(GetArea()) 
	Local aAreaSZ4  	:= SZ4->(GetArea()) 
	Local Nx
	Local Nj
	Local Nk
	Local Ni 
	
	SZ3->(DbSetOrder(6))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR 
	If SZ3->(MsSeek(xFilial("SZ3") + "4" + cCodPosto)) 
	
		//Identifica o c?digo CCR de comiss?o amarrado ao posto 
		cCodCCR	:= SZ3->Z3_CODCCR 
		cCodAr	:= SZ3->Z3_CODAR 
		cQuebra	:= SZ3->Z3_QUEBRA 
		
		If Empty(SZ3->Z3_CODCCR) 
			cCodFeder	:= SZ3->Z3_CODFED			//Ferderação. Entidade politica associada ao posto de atendimento 
			cCodAC		:= SZ3->Z3_CODAC			//Grupo/Rede. Entidade que agrupa v?rios postos de redes GAR. 
			cCodCanal	:= SZ3->Z3_CODCAN 			//Canal  associado ao posto 
			cCodCanal2	:= SZ3->Z3_CODCAN2			//Canal2 associado ao posto 
			lDescred	:= SZ3->Z3_DESCRED == "S"	//Verifica se foi descredenciado 
		Else 
			aAreaSZ3 := SZ3->(GetArea()) 
			SZ3->(DbSetOrder(1)) 
			If SZ3->(MsSeek(xFilial("SZ3") + cCodCCR)) 
				cDesCcr		:= SZ3->Z3_DESENT 
				cCodFeder	:= SZ3->Z3_CODFED			//Ferderação. Entidade politica associada ao posto de atendimento 
				cCodAC		:= SZ3->Z3_CODAC			//Grupo/Rede. Entidade que agrupa v?rios postos de redes GAR. 
				cCodCanal	:= SZ3->Z3_CODCAN 			//Canal  associado ao posto 
				cCodCanal2	:= SZ3->Z3_CODCAN2			//Canal2 associado ao posto 
				lDescred	:= SZ3->Z3_DESCRED == "S"	//Verifica se foi descredenciado 
				cCalcRem	:= SZ3->Z3_TIPCOM   		//Define de deve calcular comiss?o para a CCRCOMISSAO do posto e a estrutura de parceiros associados a ele. 
				cAbateCamp	:= SZ3->Z3_REMCAM   		//Define se abate valor no calculo da campanha. 
				cCalcIFEN	:= SZ3->Z3_CALIFEN  		//Define se vai calcular IFEN para estrutura. 
				cZera		:= SZ3->Z3_ZERA				//Zera valor base do CCR ou entidade. 
			EndIf 
			RestArea(aAreaSZ3) 
		Endif 
	
		//Se o CCR nao esta ativo ou produto nao tem a categoria, nao faco calculo. 
		If cCalcRem <> "1" .OR. cCatProd == "NE" .Or. lDescred 
			Return 
		EndIf 
	
		/*If SZ3->Z3_CODENT == "073312" 
			Return 
		EndIf*/ 
	
		//Me posiciono para buscar o percentual. 
		SZ4->(DbSetOrder(1)) 
		If SZ4->(DbSeek(xFilial("SZ4") + cCodCCR + cCatProd)) 
		
			nPerSW	:= 0 //SZ4->Z4_PORSOFT //SZ4->Z4_PARSW 
			nPerHW	:= 0 //SZ4->Z4_PORHARD //SZ4->Z4_PARHW 
		
			nBaseSw	:= nValTotSw - (nValTotSw * SZ4->Z4_PORIR / 100) 
			nBaseHw	:= nValTotHw - (nValTotHw * SZ4->Z4_PORIR / 100) 
		
			If !Empty(nPerSW) 
				nValSw	:= nBaseSw * (nPerSW/100) 
				cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL TOPOS SW) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
				nQtdReg += 1 
			Else 
				nValSw	:= SZ4->Z4_VALSOFT 
				cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (REMUNERACAO TOPOS SW FIXO) >>> " 
				nQtdReg += 1 
			Endif 
		
			If lTemHard 
				If !Empty(nPerHW) 
					nValHw	:= nBaseHw * (nPerHW/100) 
					cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL TOPOS HW) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
					nQtdReg += 1 
				Else 
					nValHw	:= SZ4->Z4_VALHARD 
					cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (REMUNERACAO TOPOS HW FIXO) >>> " 
					nQtdReg += 1 
				Endif 
			EndIf 
			
			//Se tem percentual de calculo, gera lancamento 
			/*If nValTotSw > 0  
				nQtdReg += 1 
			EndIf 
			
			If nValTotHw > 0 
				nQtdReg += 1 
			EndIf*/ 
			
		EndIf		 
	
		For nX :=1 To nQtdReg 
			Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) ) 
			For nJ := 1 To Len(aStrucSZ6) 
				Do Case 
					Case aStrucSZ6[nJ][2] == "C" 
						aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
					Case aStrucSZ6[nJ][2] == "N" 
						aDadosSZ6[Len(aDadosSZ6)][nJ] := 0 
					Case aStrucSZ6[nJ][2] == "D" 
						aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//") 
					Otherwise 
						aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
				Endcase 
			Next nJ 
		Next nX 
		
		
		For nX := 1 To nQtdReg 
			nZ	:=	nZ	+	1 
			For nK := 1 To Len(aStrucSZ6) 
				cCampo := AllTrim(aStrucSZ6[nK][1]) 
				Do Case 
					Case cCampo == "Z6_FILIAL" 
						aDadosSZ6[nZ][nK]	:= xFilial("SZ6") 
					Case cCampo == "Z6_PERIODO" 
						aDadosSZ6[nZ][nK]	:= cRemPer 
					Case cCampo == "Z6_TPENTID" 
						aDadosSZ6[nZ][nK]	:= "4" 
					Case cCampo == "Z6_CODENT" 
						aDadosSZ6[nZ][nK]	:= AllTrim(SZ3->Z3_CODENT) 
					Case cCampo == "Z6_DESENT" 
						aDadosSZ6[nZ][nK]	:= AllTrim(SZ3->Z3_DESENT) 
					Case cCampo == "Z6_PRODUTO" 
						aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR), SZ5->Z5_PRODUTO,SZ5->Z5_PRODGAR) 
					Case cCampo == "Z6_CATPROD" 
						aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware 
						Case cCampo == "Z6_DESCRPR" 
							If lPedEcom 
								If Empty(Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
									aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
								Else 
									aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
								EndIf 
							Else 
								aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
							EndIf 
					Case cCampo == "Z6_PEDGAR" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGAR 
					Case cCampo == "Z6_DTPEDI" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATPED 
					Case cCampo == "Z6_VERIFIC" 
						aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa,SZ5->Z5_EMISSAO,SZ5->Z5_DATVER) 
					Case cCampo == "Z6_VALIDA" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATVAL 
					Case cCampo == "Z6_DTEMISS" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATEMIS 
					Case cCampo == "Z6_TIPVOU" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_TIPVOU 
					Case cCampo == "Z6_CODVOU" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVOU 
					Case cCampo == "Z6_VLRPROD" 
						aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nValTotSw,nValTotHw) 
					Case cCampo == "Z6_BASECOM" 
						aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nBaseSw,nBaseHw) 
					Case cCampo == "Z6_VALCOM" 
						aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValSw,nValHw) 
					Case cCampo == "Z6_REGCOM" 
						aDadosSZ6[nZ][nK]	:= DtoC(dDatabase)+"-"+Time()+"-"+AllTrim(cNomeUsu)+"-"+SubStr(IF(!lMidiaAvulsa .And. nX == 1,cRegSw,cRegHw),1,100) 
					Case cCampo == "Z6_CODPOS" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPOS 
					Case cCampo == "Z6_CODCCR" 
						aDadosSZ6[nZ][nK]	:= cCodCCR 
					Case cCampo == "Z6_CCRCOM" 
						aDadosSZ6[nZ][nK]	:= "" 
					Case cCampo == "Z6_CODPAR" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPAR 
					Case cCampo == "Z6_CODFED" 
						aDadosSZ6[nZ][nK]	:= cCodFeder 
					Case cCampo == "Z6_CODVEND" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVEND 
					Case cCampo == "Z6_NOMVEND" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMVEND 
					Case cCampo == "Z6_TIPO" 
						If !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) .And. lOriCupom //Pedido com voucher de origem não pago. 
							aDadosSZ6[nZ][nK]	:= "NAOPAG" 
						Elseif "CRPA027R-REE" == cNomeUsu .Or. !lGerReem //Alteração de status para desconto do reembolso. 
							aDadosSZ6[nZ][nK]	:= "REEMBO" 
						ElseIf !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) //Pedido com voucher Pago Anteriormente. 
							aDadosSZ6[nZ][nK]	:= "PAGANT" 
						ElseIf "RENOVACAO" $ UPPER(SZ5->Z5_DESGRU) .Or. !Empty(SZ5->Z5_PEDGANT) .Or. AllTrim(SZ5->Z5_TIPVOU) == "H"  //Pedido de renovacao. 
							aDadosSZ6[nZ][nK]	:= "RENOVA" 
						ElseIf Empty(SZ5->Z5_PEDGAR) //Pedido de hardware avulso. 
							aDadosSZ6[nZ][nK]	:= "ENTHAR" 
						ElseIf lPedNoRem //Mensagem especifica Pedido não Pago 
							aDadosSZ6[nZ][nK]	:= "PNOPAG"			    	 
						Else //Se nao entra nas outra condicoes e verificacao. 
							aDadosSZ6[nZ][nK]	:= "NAOPAG" 
						EndIf 
					Case cCampo == "Z6_PEDSITE" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDSITE 
					Case cCampo == "Z6_REDE" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_REDE 
					Case cCampo == "Z6_GRUPO" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_GRUPO 
					Case cCampo == "Z6_DESGRU" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESGRU 
					Case cCampo == "Z6_CODAGE" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODAGE 
					Case cCampo == "Z6_NOMEAGE" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMAGE 
					Case cCampo == "Z6_AGVER" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_AGVER 
					Case cCampo == "Z6_NOAGVER" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOAGVER 
					Case cCampo == "Z6_NTITULA" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_NTITULA 
					Case cCampo == "Z6_DESREDE" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESREDE 
					Case cCampo == "Z6_PEDORI" 
						aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGANT 
					Case cCampo == "Z6_TIPED" 
						aDadosSZ6[nZ][nK]	:= cTiped 
					Case cCampo == "Z6_ACLCTO" 
						aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE 
					Case cCampo == "Z6_ARLCTO" 
						aDadosSZ6[nZ][nK] 	:= SZ5->Z5_CODAR 				 
				Endcase 
			Next nK 
		Next nX 
		
		Begin Transaction 
		
		For nI := 1 To Len(aDadosSZ6) 
			SZ6->( RecLock("SZ6",.T.) ) 
			For nJ := 1 To Len(aStrucSZ6) 
				cCampo := AllTrim(aStrucSZ6[nJ][1]) 
				&("SZ6->"+cCampo) := aDadosSZ6[nI][nJ] 
			Next nJ 
			SZ6->Z6_RECORI := AllTrim(Str(SZ5->(Recno()))) 
			SZ6->( MsUnLock() ) 
		Next nI 
		
		End Transaction 
	
	Else 
		//Posto não encontrado 
	EndIf 
		
	RestArea(aAreaSZ3) 
	RestArea(aAreaSZ4) 
Return 
 
/*/{Protheus.doc} CRPA020BIO 
//TODO Descrição auto-gerada. 
@author yuri.volpe 
@since 23/01/2020 
@version 1.0 
@return ${return}, ${return_description} 
@param cCatProd, characters, descricao 
@param lMidiaAvulsa, logical, descricao 
@param nValTotHw, numeric, descricao 
@param nValTotSw, numeric, descricao 
@param cTiped, characters, descricao 
@param lNaoPagou, logical, descricao 
@param lOriCupom, logical, descricao 
@param cNomeUsu, characters, descricao 
@param lGerReem, logical, descricao 
@param lPedNoRem, logical, descricao 
@param cCodPosto, characters, descricao 
@type function 
/*/ 
Static Function CRPA020BIO(cCatProd,lMidiaAvulsa,nValTotHw,nValTotSw,cTiped,lNaoPagou,lOriCupom,cNomeUsu,lGerReem,lPedNoRem,cCodPosto,cCodCCR,lPedEcom) 
	Local aStrucSZ6	:= SZ6->( DbStruct() ) 
	Local aDadosSZ6	:= {} 
	Local nQtdReg	:= 0 
	Local nZ		:= 0 
	Local nBaseSw	:= 0 
	Local nBaseHw	:= 0 
	Local nValSw	:= 0 
	Local nValHw	:= 0 
	Local cRegSw	:= 0 
	Local cRegHw	:= 0 
	Local nPerSW	:= 0 
	Local cCanal	:= GetNewPar("MV_XBIOCAN","SINF") 
	Local aAreaSZ3  := SZ3->(GetArea()) 
	Local aAreaSZ4  := SZ4->(GetArea()) 
	Local Nx
	Local Nj
	Local Nk
	Local Ni 
	
	//Me posiciono na entidade. 
	SZ3->(DbSetOrder(1)) 
	If !SZ3->(DbSeek(xFilial("SZ3") + cCanal)) 
		//Log: Canal não encontrado 
		Return 
	EndIf 
	
	If SZ3->Z3_ATIVO == "N" 
		//Log: Canal desativado 
		Return 
	EndIf 
	
	//Me posiciono para buscar o percentual. 
	SZ4->(DbSetOrder(1)) 
	If SZ4->(DbSeek(xFilial("SZ4") + cCanal)) 
	
		nVlrBio	:= SZ4->Z4_VALBIO 
	
		nPerSW	:= SZ4->Z4_PORSOFT //SZ4->Z4_PARSW 
		//nPerHW	:= SZ4->Z4_PORHARD //SZ4->Z4_PARHW 
	
		nBaseSw	:= nVlrBio - (nVlrBio * SZ4->Z4_PORIR / 100) 
		//nBaseHw	:= nValTotHw - (nValTotHw * SZ4->Z4_PORIR / 100) 
	
		If !Empty(nPerSW) 
			nValSw	:= nBaseSw * (nPerSW/100) 
			cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (FUNDO BIOMETRIA SW) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
		Else 
			nValSw	:= SZ4->Z4_VALSOFT 
			cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (FUNDO BIOMETRIA SW FIXO) >>> " 
		Endif 
	
		/*If !Empty(nPerHW) 
			nValHw	:= nBaseHw * (nPerHW/100) 
			cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL ASSESSORIA HW "+Iif(lCampanha,"CAMPANHA","VERIFICACAO")+") >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")" 
		Else 
			nValHw	:= SZ4->Z4_VALHARD 
			cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (REMUNERACAO ASSESSORIA HW FIXO ) >>> " 
		Endif*/ 
		
		//Se tem percentual de calculo, gera lancamento 
		If nValSw > 0  
			nQtdReg += 1 
		EndIf 
		/*If nValHw > 0  
			nQtdReg += 1 
		EndIf*/ 
	EndIf		 
	
	For nX :=1 To nQtdReg 
		Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			Do Case 
				Case aStrucSZ6[nJ][2] == "C" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
				Case aStrucSZ6[nJ][2] == "N" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := 0 
				Case aStrucSZ6[nJ][2] == "D" 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//") 
				Otherwise 
					aDadosSZ6[Len(aDadosSZ6)][nJ] := "" 
			Endcase 
		Next nJ 
	Next nX 
	
	
	For nX := 1 To nQtdReg 
		nZ	:=	nZ	+	1 
		For nK := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nK][1]) 
			Do Case 
				Case cCampo == "Z6_FILIAL" 
					aDadosSZ6[nZ][nK]	:= xFilial("SZ6") 
				Case cCampo == "Z6_PERIODO" 
					aDadosSZ6[nZ][nK]	:= cRemPer 
				Case cCampo == "Z6_TPENTID" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_TIPENT 
				Case cCampo == "Z6_CODENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_CODENT 
				Case cCampo == "Z6_DESENT" 
					aDadosSZ6[nZ][nK]	:= SZ3->Z3_DESENT 
				Case cCampo == "Z6_PRODUTO" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR), SZ5->Z5_PRODUTO,SZ5->Z5_PRODGAR) 
				Case cCampo == "Z6_CATPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware 
						Case cCampo == "Z6_DESCRPR" 
							If lPedEcom 
								If Empty(Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
									aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
								Else 
									aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SC6->C6_XSKU,"PA8_DESBPG")) 
								EndIf 
							Else 
								aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG")) 
							EndIf 
				Case cCampo == "Z6_PEDGAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGAR 
				Case cCampo == "Z6_DTPEDI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATPED 
				Case cCampo == "Z6_VERIFIC" 
					aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa,SZ5->Z5_EMISSAO,SZ5->Z5_DATVER) 
				Case cCampo == "Z6_VALIDA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATVAL 
				Case cCampo == "Z6_DTEMISS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATEMIS 
				Case cCampo == "Z6_TIPVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_TIPVOU 
				Case cCampo == "Z6_CODVOU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVOU 
				Case cCampo == "Z6_VLRPROD" 
					aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nVlrBio,nVlrBio) 
				Case cCampo == "Z6_BASECOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nBaseSw,nBaseHw) 
				Case cCampo == "Z6_VALCOM" 
					aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValSw,nValHw) 
				Case cCampo == "Z6_REGCOM" 
					aDadosSZ6[nZ][nK]	:= DtoC(dDatabase)+"-"+Time()+"-"+AllTrim(cNomeUsu)+"-"+SubStr(IF(!lMidiaAvulsa .And. nX == 1,cRegSw,cRegHw),1,100) 
				Case cCampo == "Z6_CODPOS" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPOS 
				Case cCampo == "Z6_CODCCR" 
					aDadosSZ6[nZ][nK]	:= cCodCCR 
				Case cCampo == "Z6_CCRCOM" 
					aDadosSZ6[nZ][nK]	:= "" 
				Case cCampo == "Z6_CODPAR" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPAR 
				Case cCampo == "Z6_CODFED" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMPAR 
				Case cCampo == "Z6_CODVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVEND 
				Case cCampo == "Z6_NOMVEND" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMVEND 
				Case cCampo == "Z6_TIPO" 
					If !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) .And. lOriCupom //Pedido com voucher de origem não pago. 
						aDadosSZ6[nZ][nK]	:= "NAOPAG" 
					Elseif "CRPA027R-REE" == cNomeUsu .Or. !lGerReem //Alteração de status para desconto do reembolso. 
						aDadosSZ6[nZ][nK]	:= "REEMBO" 
					ElseIf !lNaoPagou .And. !Empty(SZ5->Z5_CODVOU) //Pedido com voucher Pago Anteriormente. 
						aDadosSZ6[nZ][nK]	:= "PAGANT" 
					ElseIf "RENOVACAO" $ UPPER(SZ5->Z5_DESGRU) .Or. !Empty(SZ5->Z5_PEDGANT) .Or. AllTrim(SZ5->Z5_TIPVOU) == "H"  //Pedido de renovacao. 
						aDadosSZ6[nZ][nK]	:= "RENOVA" 
					ElseIf Empty(SZ5->Z5_PEDGAR) //Pedido de hardware avulso. 
						aDadosSZ6[nZ][nK]	:= "ENTHAR" 
					ElseIf lPedNoRem //Mensagem especifica Pedido não Pago 
						aDadosSZ6[nZ][nK]	:= "PNOPAG"			    	 
					Else //Se nao entra nas outra condicoes e verificacao. 
						aDadosSZ6[nZ][nK]	:= "VERIFI" 
					EndIf 
				Case cCampo == "Z6_PEDSITE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDSITE 
				Case cCampo == "Z6_REDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_GRUPO" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_GRUPO 
				Case cCampo == "Z6_DESGRU" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESGRU 
				Case cCampo == "Z6_CODAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODAGE 
				Case cCampo == "Z6_NOMEAGE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMAGE 
				Case cCampo == "Z6_AGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_AGVER 
				Case cCampo == "Z6_NOAGVER" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOAGVER 
				Case cCampo == "Z6_NTITULA" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_NTITULA 
				Case cCampo == "Z6_DESREDE" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESREDE 
				Case cCampo == "Z6_PEDORI" 
					aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGANT 
				Case cCampo == "Z6_TIPED" 
					aDadosSZ6[nZ][nK]	:= cTiped 
				Case cCampo == "Z6_ACLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE 
				Case cCampo == "Z6_ARLCTO" 
					aDadosSZ6[nZ][nK] 	:= SZ5->Z5_CODAR 				 
			Endcase 
		Next nK 
	Next nX 
	
	Begin Transaction 
	
	For nI := 1 To Len(aDadosSZ6) 
		SZ6->( RecLock("SZ6",.T.) ) 
		For nJ := 1 To Len(aStrucSZ6) 
			cCampo := AllTrim(aStrucSZ6[nJ][1]) 
			&("SZ6->"+cCampo) := aDadosSZ6[nI][nJ] 
		Next nJ 
		SZ6->Z6_RECORI := AllTrim(Str(SZ5->(Recno()))) 
		SZ6->( MsUnLock() ) 
	Next nI 
	
	End Transaction 
	
	RestArea(aAreaSZ3) 
	RestArea(aAreaSZ4) 

Return 
