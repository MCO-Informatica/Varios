#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ RFATR98  ³ Rotina padrão para impressão da nota fiscal de entrada/saída º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 16.01.07 ³ TI2238 - Osmil Squarcine de Souza Leite                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpC1 = Número da Nota Fiscal Inicial                                   º±±
±±º             ³ ExpC2 = Número da Nota Fiscal Final                                     º±±
±±º             ³ ExpC3 = Série da Nota Fiscal                                            º±±
±±º             ³ ExpC4 = Tipo da Nota Fiscal                                             º±±
±±º             ³ ExpL1 = Imprime Boleto                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ Deve ser definido os parâmetros abaixo antes da implantação do programa º±±
±±º             ³ lChkImp - Verificar se há notas anteriores não impressas                º±±
±±º             ³           Case seja .T. é necessário criar o campo F1_FIMP (C-1,0)      º±±
±±º             ³ nTamMen - Tamanho da linha de mensagme do campo dados adicionais        º±±
±±º             ³ nTamPro - Tamanho da linha de descrição do produto                      º±±
±±º             ³ nTamDet - Quantidade de linhas do detalhe de produtos                   º±±
±±º             ³ nTamSer - Quantidade de linhas do detalhe de serviços                   º±±
±±º             ³ nTamObs - Quantidade de linhas do campo de detalhes adcionais           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 16/01/07 - Consultor - Osmil (Alterações no programa para contemplar    º±±
±±º             ³ as regras da CARMAR                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATR98 (cNotIni, cNotFim, cSerie, nNotTip, lBoleto)

Local aRegs		:= {}
Local nLastKey	:= 0
Local cDesc1	:= "Este programa tem como objetivo efetuar a impressão da"
Local cDesc2	:= "Nota Fiscal de Entrada/Saída, conforme os parâmetros"
Local cDesc3	:= "definidos pelo usuário."
Local cString	:= "SF2"
Local cPerg		:= "RFATR98"

Private lEnd		:= .F.
Private aReturn		:= {	"Especial",;				// [1]= Tipo de Formulário
							1,;							// [2]= Número de Vias
							"Faturamento",;				// [3]= Destinatário
							2,;							// [4]= Formato 1=Comprimido 2=Normal
							2,;							// [5]= Mídia 1=Disco 2=Impressora
							1,;							// [6]= Porta LPT1, LPT2, Etc
							"",;						// [7]= Expressão do Filtro
							"" ;						// [8]= ordem a ser selecionada
							}
Private cTamanho	:= "G"
Private cTitulo		:= "Impressão da Nota Fiscal Entrada/Saída"
Private wnrel		:= "RFATR98"
Private Li			:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define se deve checar se há notas anteriores sem impressão ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lChkImp		:= .f.		// .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o tamanho da linha do campo de dados adicionais     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nTamMen		:= 55
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o tamanho da linha do campo de descrição do produto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nTamPro		:= 30 //55	em 19/05/06
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a quantidade de linhas para o detalhe da nota fiscal ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nTamDet		:= 20
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a quantidade de linhas para o detalhe da nota fiscal ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nTamSer		:= 4
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a quantidade de linhas para os dados adicionais (obs)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nTamObs		:= 11

// Monta array com as perguntas
aAdd(aRegs,{	cPerg,;										// Grupo de perguntas
				"01",;										// Sequencia
				"Nota Fiscal Inicial",;						// Nome da pergunta
				"",;										// Nome da pergunta em espanhol
				"",;										// Nome da pergunta em ingles
				"mv_ch1",;									// Variável
				"C",;										// Tipo do campo
				06,;										// Tamanho do campo
				0,;											// Decimal do campo
				0,;											// Pré-selecionado quando for choice
				"G",;										// Tipo de seleção (Get ou Choice)
				"",;										// Validação do campo
				"MV_PAR01",;								// 1a. Variável disponível no programa
				"",;		  								// 1a. Definição da variável - quando choice
				"",;										// 1a. Definição variável em espanhol - quando choice
				"",;										// 1a. Definição variável em ingles - quando choice
				"",;										// 1o. Conteúdo variável
				"",;										// 2a. Variável disponível no programa
				"",;										// 2a. Definição da variável
				"",;										// 2a. Definição variável em espanhol
				"",;										// 2a. Definição variável em ingles
				"",;										// 2o. Conteúdo variável
				"",;										// 3a. Variável disponível no programa
				"",;										// 3a. Definição da variável
				"",;										// 3a. Definição variável em espanhol
				"",;										// 3a. Definição variável em ingles
				"",;										// 3o. Conteúdo variável
				"",;										// 4a. Variável disponível no programa
				"",;										// 4a. Definição da variável
				"",;										// 4a. Definição variável em espanhol
				"",;										// 4a. Definição variável em ingles
				"",;										// 4o. Conteúdo variável
				"",;										// 5a. Variável disponível no programa
				"",;										// 5a. Definição da variável
				"",;										// 5a. Definição variável em espanhol
				"",;										// 5a. Definição variável em ingles
				"",;										// 5o. Conteúdo variável
				"",;										// F3 para o campo
				"",;										// Identificador do PYME
				"",;										// Grupo do SXG
				"",;										// Help do campo
				"999999" })									// Picture do campo
aAdd(aRegs,{cPerg,"02","Nota Fiscal Final",		"","","mv_ch2","C",06,0,0,"G","","MV_PAR02","",		"",		"",		"999999",	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","","999999" })
aAdd(aRegs,{cPerg,"03","Serie Nota Fiscal",		"","","mv_ch3","C",03,0,0,"G","","MV_PAR03","",		"",		"",		"",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aRegs,{cPerg,"04","Tipo Nota",				"","","mv_ch4","N",01,0,0,"C","","MV_PAR04","Entrada",	"",		"",		"",			"","Saida",	"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})


CriaSx1(aRegs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se é uma impressão automática ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cNotIni <> Nil .and. cNotFim <> Nil .and. cSerie <> Nil .and. nNotTip <> Nil
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a função pergunte para criar as variáveis mv_ e depois inicialza com o conteúdo do parâmetro ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(cPerg,.F.)
	mv_par01	:= cNotIni
	mv_par02	:= cNotFim
	mv_par03	:= cSerie
	mv_par04	:= nNotTip
	cPerg		:= ""
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a função pergunte para criar as variáveis mv_ ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Pergunte(cPerg,.T.)
		Return(Nil)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama a função de interface com o usuário para definição dos parâmetros do relatório ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Wnrel := SetPrint(	cString,;				// Alias do Arquivo Principal
					Wnrel,;					// Nome Padrão do Relatório
					cPerg,;					// Alias do Grupo de Perguntas
					@cTitulo,;				// Título do Relatório
					cDesc1,;				// Descrição 1
					cDesc2,;				// Descrição 2
					cDesc3,;				// Descrição 3
					.F.,;					// Habilita Dicionário de Dados
					,;						// Array com as ordens de indexação do arquivo principal
					.F.,;					// Habilita Compressão do Relatório
					cTamanho,;				// Classificação do Tamanho (P[80]/M[132]/G[220])
					,;						// 
					)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aborta o processamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Set Filter to
	Return(Nil)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta os parâmetros alterados pela SetPrint ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aborta o processamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If nLastKey == 27
	Set Filter to
	Return(Nil)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( { |lEnd| RFATR99A() } )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ RFATR99  ³ Rotina padrão para impressão da nota fiscal de entrada/saída º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 21.04.06 ³ TI0607 - Almir Bandina                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99/99/99 - Consultor - Descricao da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFATR99A()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes das variaveis da funcao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aFImp		:= {}								// Array com os dados das notas fiscais não impressas
Local aPesPed	:= {}								// Array que controla o peso com base no pedido de venda
Local aClasFis	:= {}								// Array com as letras do NBM de cada produto
Local lContinua	:= .T.								// Controlador de impressão
Local lTransp	:= .T.								// Flag para identificar se há transportadora associada a nota
Local lSomLiq	:= .T.								// Flag de Controle de somatória do peso liquido
Local lSomBru	:= .T.								// Flag de Controle de somatória do peso bruto
Local nElem		:= 0								// Elemento do array pesquisado
Local nQdeLnh	:= 0								// Quantidade de linhas do campo de descrição do produto para o campo memo
Local nPesLiq	:= 0								// Peso liquido calculado com base no produto
Local nPesBru	:= 0								// Peso bruto calculado com base no produto
Local dEmiDev	:= CToD("  /  /  ")					// Data de emissão da nota de devolução
Local cMemo		:= ""								// Conteúdo do campo memo
Local cOpMemo	:= ""								// Opção de utilização do campo memo para descrição do produto
Local cCodNBM	:= ""								// Código da Classificação Fiscal NBM para o produto
Local cMensag	:= ""								// String com a mensagem montada
Local cQry		:= ""								// String com a query a ser processada
Local nElem		:= 0								// Posição do elemento encontrado em um ascan
Local cLblTip	:= ""								// Label no nome do imposto
Local nAlqImp	:= 0								// Aliquota do imposto retido
Local aMeses	:= {}								// Array com o nome dos meses
Local cMesAno	:= ""								// Mes e ano de referência
Local lDetMsg	:=	.T.								// Flag para Impressao da Msg do Pedido de Vendas uma única vez por Nota Fiscal
Local lDetMsg1	:=	.T.								// Flag para Impressao da Msg do Pedido de Vendas uma única vez por Nota Fiscal

Private aCab		:= {}							// Array com os dados do cabeçalho da Nota Fiscal
Private aItens		:= {}							// Array com os dados dos itens da Nota Fiscal
Private aServico	:= {}							// Array com os dados dos serviços prestados
Private aRodape		:= {}							// Array com os dados do rodapé (totais)
Private aDuplic		:= {}							// Array com os dados das duplicatas
Private aNatOpe		:= {}							// Array com as naturezas de operação da nota fiscal
Private aObsAcima	:= {}							// Array com a observação acima
Private aObsAbaixo	:= {}							// Array com a observação acima
Private aImpostos	:= {}							// Array com os dados de impostos abatidos do total da nota
Private aTransp		:= {}							// Array com os dados de transporte
Private aCodMen		:= {}							// Array com os códigos das mensagens padrões
Private aDadAdc		:= {}							// Array com os dados de mensagens
Private aNFDev		:= {}							// Array com as Notas de Devolução
Private aIPIDEV		:= {}							// Array com os valores do IPI de devolução para ser impresso no corpo da nota
Private aNBM		:= {}							// Array com os códigos NBM dos produtos
Private nForAtu		:= 0							// Loop do Formulário de nota
Private lC5Mens		:= .t.
Private nTotSer		:= 0							// Valor Total dos serviços
Private cTxt		:= ""							// Texto do codigo da formula


aAdd( aMeses, {  1, "Janeiro"})
aAdd( aMeses, {  2, "Fevereiro"})
aAdd( aMeses, {  3, "Marco"})
aAdd( aMeses, {  4, "Abril"})
aAdd( aMeses, {  5, "Maio"})
aAdd( aMeses, {  6, "Junho"})
aAdd( aMeses, {  7, "Julho"})
aAdd( aMeses, {  8, "Agosto"})
aAdd( aMeses, {  9, "Setembro"})
aAdd( aMeses, { 10, "Outubro"})
aAdd( aMeses, { 11, "Novembro"})
aAdd( aMeses, { 12, "Dezembro"})

If lChkImp
	If mv_par04 == 1	// Entrada
		cQry	:= " SELECT SF1.F1_DOC,SF1.F1_SERIE,SF1.F1_EMISSAO,SF1.F1_FORNECE,SF1.F1_LOJA,SF1.F1_VALBRUT,"
		cQry	+= " CASE WHEN SF1.F1_TIPO IN('B','D')"
		cQry	+= " 	THEN (SELECT SA1.A1_NOME FROM "+RetSqlName("SA1")+" SA1"
		cQry	+= "		WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
		cQry	+= "		AND SA1.A1_COD = SF1.F1_FORNECE"
		cQry	+= "		AND SA1.A1_LOJA = SF1.F1_LOJA"
		cQry	+= "		AND SA1.D_E_L_E_T_ <> '*')"
		cQry	+= "	ELSE (SELECT SA2.A2_NOME FROM "+RetSqlName("SA2")+" SA2"
		cQry	+= "		WHERE SA2.A2_FILIAL = '"+xFilial("SA2")+"'"
		cQry	+= "		AND SA2.A2_COD = SF1.F1_FORNECE"
		cQry	+= "		AND SA2.A2_LOJA = SF1.F1_LOJA"
		cQry	+= "		AND SA2.D_E_L_E_T_ <> '*')"
		cQry	+= "	END AS A1_NOME"
		cQry	+= " FROM "+RetSqlName("SF1")+" SF1"
		cQry	+= " WHERE SF1.F1_FILIAL = '"+xFilial("SF1")+"'"
		cQry	+= " AND SF1.F1_DOC < '"+mv_par01+"'"
		cQry	+= " AND SF1.F1_SERIE = '"+mv_par03+"'"
		cQry	+= " AND SF1.F1_FORMUL = 'S'"
		cQry	+= " AND SF1.D_E_L_E_T_ <> '*'"

		If Select("TMPDUPL") > 0
			dbSelectArea("TMPDUPL")
			dbCloseArea()
		EndIf
		TCQUERY cQry NEW ALIAS "TMPDUPL"
		dbSelectArea("TMPDUPL")
		dbGoTop()
		While !Eof()
			aAdd( aFImp, {	TMPDUPL->F1_DOC,;
							TMPDUPL->F1_SERIE,;
							SToD(TMPDUPL->F1_EMISSAO),;
							TMPDUPL->F1_VALBRUT,;
							TMPDUPL->F1_FORNECE,;
							TMPDUPL->F1_LOJA,;
							TMPDUPL->A1_NOME ;
							})
			dbSkip()
		EndDo
		dbSelectArea("TMPDUPL")
		dbCloseArea()
	Else
		cQry	:= " SELECT SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_EMISSAO,SF2.F2_CLIENTE,SF2.F2_LOJA,SF2.F2_VALBRUT,"
		cQry	+= " CASE WHEN SF2.F2_TIPO NOT IN('B','D')"
		cQry	+= " 	THEN (SELECT SA1.A1_NOME FROM "+RetSqlName("SA1")+" SA1"
		cQry	+= "		WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
		cQry	+= "		AND SA1.A1_COD = SF2.F2_CLIENTE"
		cQry	+= "		AND SA1.A1_LOJA = SF2.F2_LOJA"
		cQry	+= "		AND SA1.D_E_L_E_T_ <> '*')"
		cQry	+= "	ELSE (SELECT SA2.A2_NOME FROM "+RetSqlName("SA2")+" SA2"
		cQry	+= "		WHERE SA2.A2_FILIAL = '"+xFilial("SA2")+"'"
		cQry	+= "		AND SA2.A2_COD = SF2.F2_CLIENTE"
		cQry	+= "		AND SA2.A2_LOJA = SF2.F2_LOJA"
		cQry	+= "		AND SA2.D_E_L_E_T_ <> '*')"
		cQry	+= "	END AS A1_NOME"
		cQry	+= " FROM "+RetSqlName("SF2")+" SF2"
		cQry	+= " WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"'"
		cQry	+= " AND SF2.F2_DOC < '"+mv_par01+"'"
		cQry	+= " AND SF2.F2_SERIE = '"+mv_par03+"'"
		cQry	+= " AND SF2.D_E_L_E_T_ <> '*'"

		If Select("TMPDUPL") > 0
			dbSelectArea("TMPDUPL")
			dbCloseArea()
		EndIf
		TCQUERY cQry NEW ALIAS "TMPDUPL"
		dbSelectArea("TMPDUPL")
		dbGoTop()
		While !Eof()
			aAdd( aFImp, {	TMPDUPL->F2_DOC,;
							TMPDUPL->F2_SERIE,;
							SToD(TMPDUPL->F2_EMISSAO),;
							TMPDUPL->F2_VALBRUT,;
							TMPDUPL->F2_CLIENTE,;
							TMPDUPL->F2_LOJA,;
							TMPDUPL->A1_NOME ;
							})
			dbSkip()
		EndDo
		dbSelectArea("TMPDUPL")
		dbCloseArea()
	EndIf	

	If Len(aFImp) > 0
		VisaFImp(aFImp)
		Return(Nil)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona os arquivos para os loops ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par04 == 2						// Saídas
	dbSelectArea("SF2")					// Cabecalho da Nota Fiscal Saida
	dbSetorder(1)						// FILIAL+DOC+SERIE+CLIENTE+LOJA+FORMUL
	MsSeek(xFilial("SF2")+mv_par01+mv_par03,.T.)
	
	dbSelectArea("SD2")					// Itens de Venda da Nota Fiscal
	dbSetorder(3)						// FILIAL+DOC+SERIE+CLIENTE+LOJA+COD+ITEM
	MsSeek(xFilial("SD2")+mv_par01+mv_par03,.T.)
Else									// Entradas
	dbSelectArea("SF1")					// Cabecalho da Nota Fiscal Entrada
	DbSetorder(1)						// FILIAL+DOC+SERIE+FORNECE+LOJA+TIPO
	MsSeek(xFilial("SF1")+mv_par01+mv_par03,.T.)
	
	dbSelectArea("SD1")					// Itens da Nota Fiscal de Entrada
	dbSetorder(1)						// FILIAL+DOC+SERIE+FORNECE+LOJA+COD+ITEM
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta ordem dos arquivos auxiliares ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SA1")
dbSetOrder(1)

dbSelectArea("SA2")
dbSetOrder(1)

dbSelectArea("SA4")
dbSetOrder(1)

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SC6")
dbSetOrder(1)

dbSelectArea("SE1")
dbSetOrder(1)

dbSelectArea("SE4")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa régua de impressão ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Val(mv_par02)-Val(mv_par01))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos caracteres de controle ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetPrc(0,0)											// Inicializa impressora (Junior em 26/04/06)
Li := 0												// reinicio

/*
@ Li,000 PSAY Chr(27)+"@"
@ li,000 PSay Chr(27)+Chr(67)+chr(80)				// Define tamanho do papel em 100 linhas/pagina... (Junior)
@ Li,000 PSay Chr(27)+Chr(48)       		 		// Compressao de Impressao - Linha		(Junior em 26/04/06)
@ Li,000 PSAY Chr(15)								// Define caracteres comprimidos

*/

// Incluido por Osmil (Impressao em Sextos e não comprimido)

@ Li,000 PSay Chr(27)+ "2"
@ Li,000 PSAY Chr(18)								// Define caracteres normais
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nota Fiscal de Saída ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par04 == 2
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia loop do cabecalho de nota ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	
	While !Eof() .And. SF2->F2_FILIAL == xFilial("SF2") .And. SF2->F2_DOC <= mv_par02 .And. lContinua 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta a regua de impressão ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncRegua("Nota Fiscal "+SF2->F2_DOC+"/"+SF2->F2_SERIE)		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Desconsidera notas com sÉrieS diferentes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF2->F2_SERIE <> mv_par03
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se houve cancelamento pelo usuário ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lEnd
			@ Li,001 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Zera os array's para a nova nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCab		:= {}								// Array com os dados do cabeçalho da Nota Fiscal
		aItens		:= {}								// Array com os dados dos itens da Nota Fiscal
		aServico	:= {}								// Array com os dados dos serviços prestados
		aRodape		:= {}								// Array com os dados do rodapé (totais)
		aDuplic		:= {}								// Array com os dados das duplicatas
		aNatOpe		:= {}								// Array com as naturezas de operação da nota fiscal
		aObsAcima	:= {}								// Array com as observações acima
		aObsABaixo	:= {}								// Array com as observações abaixo
		aImpostos	:= {}								// Array com os dados de impostos abatidos do total da nota
		aTransp		:= {}								// Array com os dados de transporte
		aCodMen		:= {}								// Array com os códigos das mensagens padrões
		aDadAdc		:= {}								// Array com os dados de mensagens
		aNFDev		:= {}								// Array com as Notas de Devolução		
		aIPIDEV		:= {}								// Array com os valores do IPI de devolução para ser impresso no corpo da nota
		aNatOpe		:= {}								// Array com as naturezas de operação da nota fiscal
		aObsAcima	:= {}								// Array com as observações acima
		aPesPed		:= {}								// Array que controla o peso com base no pedido de venda
		aNBM		:= {}								// Array com os códigos NBM dos produtos
		
		lTransp		:= .T.								// Flag  para identificar se há transportadora associada a nota
		dEmiDev		:= CToD("  /  /  ")					// Data de emissão da nota de devolução
		nPesLiq		:= 0								// Peso liquido calculado com base no produto
		nPesBru		:= 0								// Peso bruto calculado com base no produto
		nTotSer		:= 0								// Valor total dos serviços
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no arquivo de clientes/fornecedores de acordo com o tipo da nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SF2->F2_TIPO $ "BD")
			dbSelectArea("SA1")
			If !MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
				Aviso(	cTitulo,;
						"Cliente não localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"Cliente: "+SF2->F2_CLIENTE+"/"+SF2->F2_LOJA)
				Return(Nil)
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega as mensagens codificadas ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SA1->(FieldPos("A1_MENNOT")) > 0 .And. !Empty(SA1->A1_MENNOT)
					If aScan( aCodMen, { |x| x[2] == SA1->A1_MENNOT } ) == 0
						aAdd( aCodMen, { "9", SA1->A1_MENNOT} )
					EndIf
				EndIf
			EndIf
		Else
			dbSelectArea("SA2")
			If !MsSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
				Aviso(	cTitulo,;
						"Fornecedor não localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"Fornecedor: "+SF2->F2_CLIENTE+"/"+SF2->F2_LOJA)
				Return(Nil)
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega as mensagens codificadas ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SA2->(FieldPos("A2_MENNOT")) > 0 .And. !Empty(SA2->A2_MENNOT)
					If aScan( aCodMen, { |x| x[2] == SA2->A2_MENNOT } ) == 0
						aAdd( aCodMen, { "9", SA2->A2_MENNOT} )
					EndIf
				EndIf
			EndIf
		EndIf
		dbSelectArea("SF2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos do cabecalho da nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( aCab, SF2->F2_DOC)  												// [1]Numero
		aAdd( aCab, SF2->F2_SERIE)												// [2]Serie
		aAdd( aCab, SF2->F2_TIPO)												// [3]Tipo da nota fiscal
		aAdd( aCab, SF2->F2_EMISSAO)											// [4]Data de Emissao
		aAdd( aCab, SF2->F2_CLIENTE)											// [5]Codigo do cliente
		aAdd( aCab, SF2->F2_LOJA)												// [6]Loja do Cliente
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_NOME, SA1->A1_NOME))		// [7]Nome do Cliente
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_END, SA1->A1_END))			// [8]Endereço
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_BAIRRO, SA1->A1_BAIRRO))	// [9]Bairro
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_CEP, SA1->A1_CEP))			// [10]Cep
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_MUN, SA1->A1_MUN))			// [11]Município
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_EST, SA1->A1_EST))			// [12]Estado
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_TEL, SA1->A1_TEL))			// [13]Fone
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_FAX, SA1->A1_FAX))			// [14]Fax
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_CGC, SA1->A1_CGC))			// [15]CGC
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_INSCR, SA1->A1_INSCR))		// [16]Inscrição Estadual
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_INSCRM, SA1->A1_INSCRM))	// [17]Inscrição Municipal
	   	aAdd( aCab, SF2->F2_VEND1)												// [18]Vendedor 
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_DDD, SA1->A1_DDD))			// [19]DDD  Incluido em 26/05/06
		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica a regra de impressao dos contatos na nota fiscal ( Ordem SC5/SA1/Primeiro do SU5)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If SF2->F2_TIPO $ "BD"
			aAdd( aCab, " ")												// [20] Contato só será utilizado no cliente
		Else
			If Empty(SC5->C5_XCOMPRA)
				If Empty(SA1->A1_CONTATO)
					dBSelectArea("AC8")
					dbSetOrder(2)
					dbSeek(xFilial("AC8")+"SA1  "+SA1->A1_COD+SA1->A1_LOJA)
					If Found()
						dBSelectArea("SU5")
						dbSetOrder(1)
						dbSeek(xFilial("SU5")+AC8->AC8_CODCON)						
						If Found()							
							aAdd( aCab, SU5->U5_CONTAT)
						Else
							aAdd( aCab, " ")
						EndIf
					Else
						aAdd( aCab, " ")
					EndIf
				Else
					aAdd( aCab, SA1->A1_CONTATO)
				EndIf
			Else
				aAdd( aCab, SC5->C5_XCOMPRA)
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos do cabecalho da nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		 aAdd( aCab,If(SF2->F2_TIPO $ "BD", " ", SA1->A1_ENDENT))							// [21] Endereco de Entrega     
		 aAdd( aCab,If(SF2->F2_TIPO $ "BD", " ", SA1->A1_BAIRROE))							// [22] Bairro de Entrega     		
		 aAdd( aCab,If(SF2->F2_TIPO $ "BD", " ", SA1->A1_MUNE))							// [23] Municipio de Entrega
		 aAdd( aCab,If(SF2->F2_TIPO $ "BD", " ", SA1->A1_ESTE+" - "+SA1->A1_CEPE))			// [24] Estado de Entrega     
 		 aAdd( aCab,If(SF2->F2_TIPO $ "BD", " ", SA1->A1_XOBRA))							// [25] Obra de Entrega     

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os  Enderecos de Entrega       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		 aAdd( aCab,If(SF2->F2_TIPO $ "BD", " ", SA1->A1_ENDCOB))							// [26] Endereco de Entrega     
		 aAdd( aCab,If(SF2->F2_TIPO $ "BD", " ", SA1->A1_BAIRROC))							// [27] Bairro de Entrega     		
		 aAdd( aCab,If(SF2->F2_TIPO $ "BD", " ", SA1->A1_MUNC))							// [28] Municipio de Entrega
		 aAdd( aCab,If(SF2->F2_TIPO $ "BD", " ", SA1->A1_ESTC+" - "+SUBSTR(SA1->A1_CEPC,1,5)+"-"+SUBSTR(SA1->A1_CEPC,6,3)))		// [29] Estado de Entrega     

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos do rodapé da nota (totais) ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( aRodape, If(SF2->F2_VALBRUT == 0,;
						SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE,;
						SF2->F2_VALBRUT))										// [1]Valor Bruto
		aAdd( aRodape, SF2->F2_VALMERC)											// [2]Valor  da Mercadoria
		aAdd( aRodape, SF2->F2_VALFAT)											// [3]Valor faturado
		aAdd( aRodape, SF2->F2_FRETE)											// [4]Frete
		aAdd( aRodape, SF2->F2_ICMFRET)											// [5]ICMS sobre o frete
		aAdd( aRodape, SF2->F2_FRETAUT)											// [6]Frete Autônomo
		aAdd( aRodape, SF2->F2_ICMAUTO)											// [7]ICMS sobre Frete Autônomo
		aAdd( aRodape, SF2->F2_SEGURO)											// [8]Seguro
		aAdd( aRodape, SF2->F2_DESPESA)											// [9]Despesas acessorias
		aAdd( aRodape, SF2->F2_DESCONT)											// [10]Desconto total
		aAdd( aRodape, SF2->F2_VALACRS)											// [11]Acréscimos
		aAdd( aRodape, SF2->F2_BASEICM)											// [12]Base do ICMS
		aAdd( aRodape, SF2->F2_VALICM)											// [13]Valor  do ICMS
		aAdd( aRodape, SF2->F2_BASEIPI)											// [14]Base do IPI
		aAdd( aRodape, SF2->F2_VALIPI) 											// [15]Valor  do IPI
		aAdd( aRodape, SF2->F2_BRICMS)											// [16]Base do ICMS retido
		aAdd( aRodape, SF2->F2_ICMSRET)											// [17]Valor do ICMS Retido
		aAdd( aRodape, SF2->F2_BASEISS)											// [18]Base do ISS
		aAdd( aRodape, SF2->F2_VALISS)											// [19]Valor do ISS
		aAdd( aRodape, SF2->F2_BASEINS)											// [20]Base do INSS
		aAdd( aRodape, SF2->F2_VALINSS)											// [21]Valor do INSS
		aAdd( aRodape, SF2->F2_VALIRRF)											// [22]Valor do IRRF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos do rodapé da nota (totais) ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		MsSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC,.T.)
		While !Eof() .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_PREFIXO == SF2->F2_PREFIXO .And.;
							SE1->E1_NUM == SF2->F2_DOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se for título referente a parcela da nota grava dados no array aDuplic ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE1->E1_TIPO == "NF "
				aAdd( aDuplic,	{	SF2->F2_PREFIXO,;							// [1]Prefixo do Título
									SF2->F2_DUPL,;								// [2]Numero da duplicata
									SF2->F2_COND,;								// [3]Condicao de Pagamento
									GetAdvFVal("SE4",;
							 			"E4_DESCRI",;
							 			xFilial("SE4")+SF2->F2_COND,;
										1,0),;									// [4]Descrição da Condição de Pagamento
									SE1->E1_PARCELA,;							// [5]Parcela
									SE1->E1_VALOR,;								// [6]Valor do Título
									SE1->E1_VENCTO,;							// [7]Vencimento
									SE1->E1_VENCREA ;							// [8]Vencimento Real
									})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se for título referente a abatimento grava os valores no array aImpostos ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIf SE1->E1_TIPO $ MVIRABT .Or.;		// Soma o valor do IRRF
				SE1->E1_TIPO $ MVINABT .Or.;	 	// Soma o valor do Inss
				SE1->E1_TIPO $ MVCSABT .Or.;		// Soma o valor do Csll
				SE1->E1_TIPO $ MVCFABT .Or.;		// Soma o valor do Cofins
				SE1->E1_TIPO $ MVPIABT				// Soma o valor do Pis

				nElem	:= aScan( aImpostos, { |x| x[1] == SE1->E1_TIPO })
				If nElem == 0
					aAdd( aImpostos, { SE1->E1_TIPO, SE1->E1_VALOR})
				Else
					aImpostos[nElem,2]	+= SE1->E1_VALOR
				EndIf
			EndIf
			dbSelectArea("SE1")
			dbSkip()
		EndDo
		dbSelectArea("SF2")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array de mensagens com os impostos da nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aImpostos) > 0
			cMensag	:= "RETENCAO NA FONTE: "
			For nLoop := 1 To Len(aImpostos)
				If aImpostos[nLoop,1] == "IR-"
					cLblTip		:= "IRRF"
					nAlqImp	:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)
				ElseIf aImpostos[nLoop,1] == "IN-"
					cLblTip		:= "INSS"
					nAlqImp	:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)
				ElseIf aImpostos[nLoop,1] == "CS-"
					cLblTip		:= "CSLL"
					nAlqImp		:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)
				ElseIf aImpostos[nLoop,1] == "CF-"
					cLblTip		:= "COFINS"
					nAlqImp		:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)
				ElseIf aImpostos[nLoop,1] == "PI-"
					cLblTip		:= "PIS"
					nAlqImp		:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)
				EndIf
				
				cMensag	+= cLblTip+"-"+AllTrim(Transform(nAlqImp, "@E 999.99%"))+" R$ "+AllTrim(Transform(aImpostos[nLoop,2], "@E 999,999,999.99"))+" " 
			Next nLoop
			
			CallMens(cMensag, 2, "0")
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos da transportadora e dados do transporte ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SF2->F2_TRANSP)
			dbSelectArea("SA4")
			If !MsSeek(xFilial("SA4")+SF2->F2_TRANSP)
				Aviso(	cTitulo,;
							"Transportadora não localizada no arquivo! Contate o Administrador.",;
							{"&Continua"},,;
							"Transportadora: "+SF2->F2_TRANSP)
				lTransp	:= .F.
				Return(Nil)
			EndIf
		Else
			lTransp	:= .F.
		EndIf
		dbSelectArea("SF2")
		aAdd( aTransp, SF2->F2_TRANSP)											// [1]Código da Transportadora
		aAdd( aTransp, SF2->F2_REDESP)											// [2]Transportadora de Redespacho
		If lTransp
			aAdd( aTransp, SA4->A4_NOME)										// [3]Nome da Transportadora
			aAdd( aTransp, SA4->A4_END)											// [4]Endereço
			aAdd( aTransp, SA4->A4_BAIRRO)										// [5]Bairro
			aAdd( aTransp, SA4->A4_MUN)											// [6]Município
			aAdd( aTransp, SA4->A4_EST)											// [7]Estado
			aAdd( aTransp, SA4->A4_CEP)											// [8]Cep 
			aAdd( aTransp, SA4->A4_CGC)											// [9]CGC
			aAdd( aTransp, SA4->A4_INSEST)										// [10]Inscrição Estadual
		Else
			aAdd( aTransp, CriaVar("A4_NOME",.F.))
			aAdd( aTransp, CriaVar("A4_END",.F.))
			aAdd( aTransp, CriaVar("A4_BAIRRO",.F.))
			aAdd( aTransp, CriaVar("A4_MUN",.F.))
			aAdd( aTransp, CriaVar("A4_EST",.F.))
			aAdd( aTransp, CriaVar("A4_CEP",.F.))
			aAdd( aTransp, CriaVar("A4_CGC",.F.))
			aAdd( aTransp, CriaVar("A4_INSEST",.F.))
		EndIf
		If SF2->(FieldPos("F2_TPFRETE")) > 0
			aAdd( aTransp, SF2->F2_TPFRETE)										// [11]Tipo de Frete (1=CIF,2=FOB)
		Else
			aAdd( aTransp, "1")
		EndIf
		If SF2->(FieldPos("F2_UFPLAC")) > 0
			aAdd( aTransp, SF2->F2_UFPLAC)										// [12]UF da Placa do Veículo
		Else
			aAdd( aTransp, SA4->A4_EST)	
		EndIf
		If SF2->(FieldPos("F2_PLACA")) > 0
			aAdd( aTransp, SF2->F2_PLACA)										// [13]Placa do Caminhão
		Else
			aAdd( aTransp, " ")
		EndIf
		aAdd( aTransp, SF2->F2_VOLUME1)											// [14]Quantidade de Volumes
		aAdd( aTransp, SF2->F2_ESPECI1)											// [15]Espécie dos Volumes 
		If SF2->(FieldPos("F2_MARCA")) > 0
			aAdd( aTransp, SF2->F2_MARCA)										// [16]Marca dos Volumes
		Else
			aAdd( aTransp, " ")
		EndIf
		If SF2->(FieldPos("F2_NUMVOL")) > 0
			aAdd( aTransp, SF2->F2_NUMVOL)										// [17]Número dos dos Volumes
		Else
			aAdd( aTransp, " ")
		EndIf
		aAdd( aTransp, SF2->F2_PBRUTO)											// [18]Peso Bruto Total
		aAdd( aTransp, SF2->F2_PLIQUI)											// [19]Peso Líquido Total
		aAdd( aTransp, SA4->A4_DDD)												// [20]DDD
		aAdd( aTransp, SA4->A4_TEL)												// [21]Telefone


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Permite a Impressao da Msg do Pedido de Vendas (C5_MENNOTM) somente uma vez por Nota - Cezar em 22/05/06 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lDetmsg	:=	.T.
		lDetMsg1:=	.T.			
		aPedCli := {}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos dos itens da nota fiscal ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD2")
		dbSetorder(3)
		MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
		While !Eof() .And. SD2->D2_FILIAL == xFilial("SD2") .And. SD2->D2_DOC == SF2->F2_DOC .And.;
							SD2->D2_SERIE == SF2->F2_SERIE
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no arquivo de Produto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			If !MsSeek(xFilial("SB1")+SD2->D2_COD)
				Aviso(	cTitulo,;
							"Produto não localizado no arquivo! Contate o Administrador.",;
							{"&Continua"},,;
							"Produto: "+SD2->D2_COD)
				Return(Nil)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Defino o código NBM para o produto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If Alltrim(SB1->B1_POSIPI) = "68129010"
				cCodNBM := "01"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73051100"
				cCodNBM := "02"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73051200"
				cCodNBM := "03"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73061000"
				cCodNBM := "04"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73069020"
				cCodNBM := "05"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73069090"
				cCodNBM := "06"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73071910"
				cCodNBM := "07"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73071920"
				cCodNBM := "08"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73071990"
				cCodNBM := "09"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73072100"
				cCodNBM := "10"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73072200"
				cCodNBM := "11"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73072300"
				cCodNBM := "12"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73072900"
				cCodNBM := "13"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73079100"
				cCodNBM := "14"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73079200"
				cCodNBM := "15"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73079300"
				cCodNBM := "16"
			ElseIf Alltrim(SB1->B1_POSIPI) = "73079900"
				cCodNBM := "17"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84813000"
				cCodNBM := "18"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84814000"
				cCodNBM := "19"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84818092"
				cCodNBM := "20"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84818093"
				cCodNBM := "21"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84818094"
				cCodNBM := "22"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84818095"
				cCodNBM := "23"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84818096"
				cCodNBM := "24"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84818097"
				cCodNBM := "25"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84818099"
				cCodNBM := "26"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84841000"
				cCodNBM := "27"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84842000"
				cCodNBM := "28"
			ElseIf Alltrim(SB1->B1_POSIPI) = "84849000"
				cCodNBM := "29"
			ElseIf Empty(SB1->B1_POSIPI)
				cCodNBM := ""				
			EndIf				
							
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega os pesos com base no produto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPesLiq	+= Round(SB1->B1_PESO * SD2->D2_QUANT, TAMSX3("B1_PESO")[2])
			nPesBru	+= Round(SB1->B1_PESBRU * SD2->D2_QUANT, TAMSX3("B1_PESBRU")[2])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no arquivo de Tipo de Entrada e Saída ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SF4")
			If !MsSeek(xFilial("SF4")+SD2->D2_TES)
				Aviso(	cTitulo,;
						"Tipo de Entrada/Saída não localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"TES: "+SD2->D2_TES)
				Return(Nil)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega as mensagens codificadas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SF4->(FieldPos("F4_MENNOT1")) > 0 .And. !Empty(SF4->F4_MENNOT1)
				If aScan( aCodMen, { |x| x[2] == SF4->F4_MENNOT1} ) == 0
					aAdd( aCodMen, { "1", SF4->F4_MENNOT1 } )
				EndIf
			EndIf
			If SF4->(FieldPos("F4_MENNOT2")) > 0 .And. !Empty(SF4->F4_MENNOT2)
				If aScan( aCodMen, { |x| x[2] == SF4->F4_MENNOT2 } ) == 0
					aAdd( aCodMen, { "1", SF4->F4_MENNOT2 } )
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona o array com as naturezas de operação ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan( aNatOpe, { |x| x[1] == SD2->D2_TES }) == 0
				aAdd( aNatOpe, { SD2->D2_TES, SD2->D2_CF, SF4->F4_TEXTO })
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no arquivo do Cabeçalho do Pedido de Venda ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC5")
			If !MsSeek(xFilial("SC5")+SD2->D2_PEDIDO)
				Aviso(	cTitulo,;
						"Cabeçalho do Pedido não localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"Pedido: "+SD2->D2_PEDIDO)
				Return(Nil)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega as mensagens codificadas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SC5->C5_MENPAD)
				cTxt := CallMens(SC5->C5_MENPAD,1)
			Else
				cTxt := ""
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega as mensagens no c5_mennota digitadas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
			If !Empty(SC5->C5_MENNOTA) .And. lDetmsg
				aAdd( aObsAcima ,{Substr(SC5->C5_MENNOTA,01,250)} )    // [01] Posiscoes 01  - 250
				lDetmsg	:=	.F.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega as mensagens no observacao abaixo    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
			If !Empty(SC5->C5_XOBSABA) .And. lDetmsg1
				aAdd( aObsAbaixo ,{Substr(SC5->C5_XOBSABA,01,80)} )   // [01] Posiscoes 01  - 80
				aAdd( aObsAbaixo ,{Substr(SC5->C5_XOBSABA,81,80)} )   // [02] Posiscoes 61  - 120
				aAdd( aObsAbaixo ,{Substr(SC5->C5_XOBSABA,161,80)} )   // [03] Posiscoes 121 - 180
				lDetmsg1	:=	.F.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega os pesos com base no pedido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan( aPesPed, { |x| x[1] == SD2->D2_PEDIDO }) == 0
				aAdd( aPesPed, { SD2->D2_PEDIDO, SC5->C5_PBRUTO, SC5->C5_PESOL })
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no arquivo dos Itens do Pedido de Venda ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC6")
			If !MsSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
				Aviso(	cTitulo,;
						"Item do Pedido não localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"Pedido/Item: "+SD2->D2_PEDIDO+"/"+SD2->D2_ITEMPV)
				Return(Nil)
			Else
				aAdd( aPedCli, SC6->C6_PEDCLI)  								// [1]Numero do Pedido do Cliente
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta a descrição do produto com base em campos específicos ou do pedido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			nQdeLnh	:= MlCount( SB1->B1_DESC, nTamPro)
			cOpMemo	:= "4"


			For nLoop := 1 To nQdeLnh

				If SD2->D2_VALISS > 0
					If nLoop <> 1
						aAdd( aServico, {	CriaVar("D2_COD",.F.),;
											cMemo,;
											CriaVar("D2_UM",.F.),;
											CriaVar("D2_QUANT",.F.),;
											CriaVar("D2_PRCVEN",.F.),;
											CriaVar("D2_TOTAL",.F.) ;
										})
					Else
						aAdd( aServico, {	SD2->D2_COD,;
											cMemo,;
											SD2->D2_UM,;
											SD2->D2_QUANT,;
											SD2->D2_PRCVEN,;
											SD2->D2_TOTAL ;
										})
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Adiciona o array apenas com a descrição do produto ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nLoop <> 1
						aAdd( aItens, {	CriaVar("SD2->D2_COD", .F.),;				// [1]Código do Produto
										CriaVar("B1_DESC", .F.),;					// [2]Descrição
										CriaVar("B1_CLASFIS", .F.),;				// [3]NBM
										CriaVar("D2_CLASFIS", .F.),;				// [4]Situação Tributária
										CriaVar("D2_UM", .F.),;						// [5]Unidade de Medida
										CriaVar("D2_QUANT", .F.),;					// [6]Quantidade
										CriaVar("D2_PRCVEN", .F.),;					// [7]Preço de Venda
										CriaVar("D2_TOTAL", .F.),;					// [8]Preço Total
										CriaVar("D2_PICM", .F.),;					// [9]Percentual do ICMS
										CriaVar("D2_IPI", .F.),;					// [10]Percentual do IPI
										CriaVar("D2_VALIPI", .F.),;					// [11]Valor do IPI
										CriaVar("D2_CF", .F.), ;						// [12]Código Fiscal de Operação e Prestação
										CriaVar("D2_PEDIDO", .F.) ;					// [13]Numero do Pedido de Vendas
										 })
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Adiciona o array todos oa dados necessários ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Else
						aAdd( aItens, {	SD2->D2_COD,;
										SB1->B1_DESC,;
										cCodNBM,;
										If(!Empty(SD2->D2_CLASFIS),;
											SD2->D2_CLASFIS,;
											SB1->B1_ORIGEM+SF4->F4_SITTRIB)	,;
										SD2->D2_UM,;
										SD2->D2_QUANT,;
										SD2->D2_PRCVEN,;
										SD2->D2_TOTAL,;
										SD2->D2_PICM,;
										SD2->D2_IPI,;
										If(SF4->F4_DESTACA <> "N", SD2->D2_VALIPI, 0),;
										SD2->D2_CF ,;
										SD2->D2_PEDIDO;
										})
					EndIf
				EndIf
			Next nLoop

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona o array com os valores do IPI no corpo da nota ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SF4->F4_DESTACA == "N" .And. SF2->F2_TIPO $ "BD"
				aAdd( aIPIDEV, SD2->D2_VALIPI )
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona o array com as notas de devolução ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SD2->D2_NFORI)
				dbSelectArea("SF1")
				If MsSeek(xFilial("SF1")+SD2->(D2_NFORI+D2_SERIORI+D2_CLIENTE+D2_LOJA))
					dEmiDev	:= SF1->F1_EMISSAO
				EndIf
				dbSelectArea("SD2")
				If aScan( aNFDev, { |x| x[1]+x[2] == SD2->D2_NFORI+SD2->D2_SERIORI }) == 0
					aAdd( aNFDev, { SD2->D2_NFORI, SD2->D2_SERIORI, dEmiDev, SD2->D2_TIPO })
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Vai para o proximo item de nota³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD2")
			dbSkip()
			
		Enddo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define os pesos da nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aTransp[18]) .Or. !Empty(aTransp[19])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pega os pesos do Pedido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Len(aPesPed) > 0
				lSomLiq	:= Empty(aTransp[18])
				lSomBru	:= Empty(aTransp[19])
				For nLoop := 1 To Len(aPesPed)
					If lSomLiq
						aTransp[18]	+= aPesPed[nLoop,03]
					EndIf
					If lSomBru
						aTransp[19] += aPesPed[nLoop,02]
					EndIf
				Next nLoop
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pega os pesos do produto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aTransp[18]) .Or. Empty(aTransp[19])
				If Empty(aTRansp[18])
					aTransp[18]	+= nPesLiq
				EndIf
				If Empty(aTransp[19])
					aTransp[19] += nPesBru
				EndIf
			EndIf
		EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta a mensagem de devolução de notas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMensag	:= ""
		If Len(aNFDev) > 0
			If aNFDev[1,4] == "D"
				cMensag	:= "Devolucao "
			ElseIf aNFDev[1,4] == "C"
				cMensag	:= "Complemento "
			Else
				cMensag	:= "Retorno "
			EndIf
			cMensag	+= "Referente sua(s) nota(s) fiscal(is) "
			For nLoop := 1 To Len(aNFDev)
				If nLoop <> 1
					cMensag	+= " e "
				EndIf
				cMensag	+= AllTrim(aNFDev[nLoop,1])+"/"+AllTrim(aNFDev[nLoop,2])+" de "+aNFDev[nLoop,3]
			Next nLoop
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava a mensagem montada no array ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cMensag)
			CallMens(cMensag, 2, "2")
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava as mensagens codificadas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nLoop := 1 To Len(aCodMen)
			CallMens(aCodMen[nLoop,2], 1, aCodMen[nLoop,1]+StrZero(nLoop,2))
		Next nLoop

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava as mensagens do IPI para crédito no campo de dados adicionais |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nVlrIPIDev	:= 0
		For nLoop := 1 To Len(aIPIDev)
			nVlrIPIDev += aIPIDev[nLoop]
		Next nLoop
		If !Empty(nVlrIPIDev)
			cMensag	:= "IPI para credito do destinatario no valor de R$ "+AllTrim(Transform(nVlrIPIDev, "@E 999,999,999.99"))
			CallMens(cMensag, 2, "0")
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calcula a quantidade de formularios necessarios³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nFormul := Max( Int(Len(aItens)/nTamDet + .999999999), Int(Len(aServico)/nTamSer + .999999999) )
						  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama funcao de impressao da nota fiscal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nForAtu := 1 to nFormul
			Imprime()
		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Movimenta o registro e a regua de impressao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF2")
		dbSkip()
	EndDo
	
Else	// Compras - Entradas
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia loop do cabecalho de nota ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF1")
	
	While !Eof() .And. SF1->F1_FILIAL == xFilial("SF1") .And. SF1->F1_DOC <= mv_par02 .And. lContinua 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta a regua de impressão ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncRegua("Nota Fiscal "+SF1->F1_DOC+"/"+SF1->F1_SERIE)		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Desconsidera notas com sÉrieS diferentes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF1->F1_SERIE <> mv_par03
			dbSkip()
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Desconsidera notas que não são formulário próprio |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF1->F1_FORMUL <> "S"
			dbSkip()
			Loop
		Endif
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se houve cancelamento pelo usuário ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lEnd
			@ Li,001 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Zera os array's para a nova nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCab		:= {}								// Array com os dados do cabeçalho da Nota Fiscal
		aItens		:= {}								// Array com os dados dos itens da Nota Fiscal
		aServico	:= {}								// Array com os dados dos serviços prestados
		aRodape		:= {}								// Array com os dados do rodapé (totais)
		aDuplic		:= {}								// Array com os dados das duplicatas
		aNatOpe		:= {}								// Array com as naturezas de operação da nota fiscal
		aObsAcima	:= {}								// Array com as observações acima
		aImpostos	:= {}								// Array com os dados de impostos abatidos do total da nota
		aTransp		:= {}								// Array com os dados de transporte
		aCodMen		:= {}								// Array com os códigos das mensagens padrões
		aDadAdc		:= {}								// Array com os dados de mensagens
		aNFDev		:= {}								// Array com as Notas de Devolução		
		aIPIDEV		:= {}								// Array com os valores do IPI de devolução para ser impresso no corpo da nota
		aNatOpe		:= {}								// Array com as naturezas de operação da nota fiscal
		aObsAcima	:= {}								// Array com as observacoes acima
		aPesPed		:= {}								// Array que controla o peso com base no pedido de venda
		aNBM		:= {}								// Array com os códigos NBM dos produtos
		
		lTransp		:= .T.								// Flag  para identificar se há transportadora associada a nota
		dEmiDev		:= CToD("  /  /  ")					// Data de emissão da nota de devolução
		nPesLiq		:= 0								// Peso liquido calculado com base no produto
		nPesBru		:= 0								// Peso bruto calculado com base no produto
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no arquivo de clientes/fornecedores de acordo com o tipo da nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SF1->F1_TIPO $ "BD")
			dbSelectArea("SA1")
			If !MsSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
				Aviso(	cTitulo,;
						"Cliente não localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"Cliente: "+SF1->F1_FORNECE+"/"+SF1->F1_LOJA)
				Return(Nil)
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega as mensagens codificadas ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SA1->(FieldPos("A1_MENNOT")) > 0 .And. !Empty(SA1->A1_MENNOT)
					If aScan( aCodMen, { |x| x[2] == SA1->A1_MENNOT } ) == 0
						aAdd( aCodMen, { "9", SA1->A1_MENNOT} )
					EndIf
				EndIf
			EndIf
		Else
			dbSelectArea("SA2")
			If !MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
				Aviso(	cTitulo,;
						"Fornecedor não localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"Fornecedor: "+SF1->F1_FORNECE+"/"+SF1->F1_LOJA)
				Return(Nil)
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega as mensagens codificadas ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SA2->(FieldPos("A2_MENNOT")) > 0 .And. !Empty(SA2->A2_MENNOT)
					If aScan( aCodMen, { |x| x[2] == SA2->A2_MENNOT } ) == 0
						aAdd( aCodMen, { "9", SA2->A2_MENNOT} )
					EndIf
				EndIf
			EndIf
		EndIf
		dbSelectArea("SF1")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos do cabecalho da nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( aCab, SF1->F1_DOC)  													// [1]Numero
		aAdd( aCab, SF1->F1_SERIE)													// [2]Serie
		aAdd( aCab, SF1->F1_TIPO)													// [3]Tipo da nota fiscal
		aAdd( aCab, SF1->F1_DTDIGIT)												// [4]Data de Emissao
		aAdd( aCab, SF1->F1_FORNECE)												// [5]Codigo do cliente
		aAdd( aCab, SF1->F1_LOJA)													// [6]Loja do Cliente
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_NOME, 		SA2->A2_NOME))		// [7]Nome do Cliente
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_END, 		SA2->A2_END))		// [8]Endereço
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_BAIRRO,	SA2->A2_BAIRRO))	// [9]Bairro
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_CEP, 		SA2->A2_CEP))		// [10]Cep
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_MUN, 		SA2->A2_MUN))		// [11]Município
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_EST, 		SA2->A2_EST))		// [12]Estado
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_TEL, 		SA2->A2_TEL))		// [13]Fone
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_FAX, 		SA2->A2_FAX))		// [14]Fax
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_CGC, 		SA2->A2_CGC))		// [15]CGC
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_INSCR, 	SA2->A2_INSCR))		// [16]Inscrição Estadual
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_INSCRM,	SA2->A2_INSCRM))	// [17]Inscrição Municipal
	   	aAdd( aCab, CriaVar("F2_VEND1",.F.))										// [18]Vendedor 
		aAdd( aCab, If(SF1->F1_TIPO $ "BD", SA1->A1_DDD, 		SA2->A2_DDD))		// [19]DDD  Incluido em 26/05/06
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos do rodapé da nota (totais) ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( aRodape, If(SF1->F1_VALBRUT == 0,;
						SF1->F1_VALMERC+SF1->F1_VALIPI+SF1->F1_SEGURO+SF1->F1_FRETE,;
						SF1->F1_VALBRUT))										// [1]Valor Bruto
		aAdd( aRodape, SF1->F1_VALMERC)											// [2]Valor  da Mercadoria
		aAdd( aRodape, SF1->F1_VALBRUT)											// [3]Valor faturado
		aAdd( aRodape, SF1->F1_FRETE)											// [4]Frete
		aAdd( aRodape, 0)														// [5]ICMS sobre o frete
		aAdd( aRodape, 0)														// [6]Frete Autônomo
		aAdd( aRodape, 0)														// [7]ICMS sobre Frete Autônomo
		aAdd( aRodape, SF1->F1_SEGURO)											// [8]Seguro
		aAdd( aRodape, SF1->F1_DESPESA)											// [9]Despesas acessorias
		aAdd( aRodape, SF1->F1_DESCONT)											// [10]Desconto total
		aAdd( aRodape, 0)														// [11]Acréscimos
		aAdd( aRodape, SF1->F1_BASEICM)											// [12]Base do ICMS
		aAdd( aRodape, SF1->F1_VALICM)											// [13]Valor  do ICMS
		aAdd( aRodape, SF1->F1_BASEIPI)											// [14]Base do IPI
		//	aAdd( aRodape, SF1->F1_VALIPI)  	// [15]Valor  do IPI // Alterado em 26/05/06 para n Imrimir valor qdi dev.Teste
		//	If(SF4->F4_DESTACA <> "N", SD1->D1_IPI,0),;
		aAdd( aRodape, If(SF4->F4_DESTACA <> "N", SF1->F1_VALIPI,0))			// [15]Valor  do IPI
		aAdd( aRodape, SF1->F1_BRICMS)											// [16]Base do ICMS retido
		aAdd( aRodape, SF1->F1_ICMSRET)											// [17]Valor do ICMS Retido
		aAdd( aRodape, 0)														// [18]Base do ISS
		aAdd( aRodape, SF1->F1_ISS)												// [19]Valor do ISS
		aAdd( aRodape, SF1->F1_BASEINS)											// [20]Base do INSS
		aAdd( aRodape, SF1->F1_INSS)											// [21]Valor do INSS
		aAdd( aRodape, SF1->F1_IRRF)											// [22]Valor do IRRF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega as mensagens digitadas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMensag	:= ""
		If SF1->(FieldPos("F1_OBSERV1")) > 0 .And. !Empty(SF1->F1_OBSERV1)
			cMensag	+= AllTrim(SF1->F1_OBSERV1)
		EndIf
		If SF1->(FieldPos("F1_OBSERV2")) > 0 .And. !Empty(SF1->F1_OBSERV2)
			cMensag += " "+AllTrim(SF1->F1_OBSERV2)
		EndIf
		If SF1->(FieldPos("F1_OBSERV3")) > 0 .And. !Empty(SF1->F1_OBSERV3)
			cMensag	+= " "+AllTrim(SF1->F1_OBSERV3)
		EndIf
		// Incluido em 22/05/06 por Cezar
		If SF1->(FieldPos("F1_OBSERV4")) > 0 .And. !Empty(SF1->F1_OBSERV4)
			cMensag	+= " "+AllTrim(SF1->F1_OBSERV4)
		EndIf
		// Incluido em 24/05/06 por Cezar
		If SF1->(FieldPos("F1_OBSERV5")) > 0 .And. !Empty(SF1->F1_OBSERV5)
			cMensag	+= " "+AllTrim(SF1->F1_OBSERV5)
		EndIf

		CallMens( cMensag, 2, "41" ) 
		cMensag	:= ""
		If SF1->(FieldPos("F1_NUMDI")) > 0 .And. !Empty(SF1->F1_NUMDI)
			cMensag	:= "Referente Declaracao de Importacao No. "+ AllTrim(SF1->F1_NUMDI) +" de "+DToC(SF1->F1_DATDI)
			CallMens( cMensag, 2, "42" ) 
		EndIf
		cMensag	:= ""

		dbSelectArea("SF1")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos da transportadora e dados do transporte ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SF1->F1_TRANSP)
			dbSelectArea("SA4")
			If !MsSeek(xFilial("SA4")+SF1->F1_TRANSP)
				Aviso(	cTitulo,;
							"Transportadora não localizada no arquivo! Contate o Administrador.",;
							{"&Continua"},,;
							"Transportadora: "+SF1->F1_TRANSP)
				lTransp	:= .F.
				Return(Nil)
			EndIf
		Else
			lTransp	:= .F.
		EndIf
		dbSelectArea("SF1")
		aAdd( aTransp, SF1->F1_TRANSP)											// [1]Código da Transportadora
		aAdd( aTransp, CriaVar("F2_REDESP",.F.))								// [2]Transportadora de Redespacho
		If lTransp
			aAdd( aTransp, SA4->A4_NOME)										// [3]Nome da Transportadora
			aAdd( aTransp, SA4->A4_END)											// [4]Endereço
			aAdd( aTransp, SA4->A4_BAIRRO)										// [5]Bairro
			aAdd( aTransp, SA4->A4_MUN)											// [6]Município
			aAdd( aTransp, SA4->A4_EST)											// [7]Estado
			aAdd( aTransp, SA4->A4_CEP)											// [8]Cep 
			aAdd( aTransp, SA4->A4_CGC)											// [9]CGC
			aAdd( aTransp, SA4->A4_INSEST)										// [10]Inscrição Estadual
		Else
			aAdd( aTransp, CriaVar("A4_NOME",.F.))
			aAdd( aTransp, CriaVar("A4_END",.F.))
			aAdd( aTransp, CriaVar("A4_BAIRRO",.F.))
			aAdd( aTransp, CriaVar("A4_MUN",.F.))
			aAdd( aTransp, CriaVar("A4_EST",.F.))
			aAdd( aTransp, CriaVar("A4_CEP",.F.))
			aAdd( aTransp, CriaVar("A4_CGC",.F.))
			aAdd( aTransp, CriaVar("A4_INSEST",.F.))
		EndIf
		If SF1->(FieldPos("F1_TPFRETE")) > 0
			aAdd( aTransp, SF1->F1_TPFRETE)										// [11]Tipo de Frete (1=CIF,2=FOB)
		Else
			aAdd( aTransp, "1")
		EndIf
		If SF1->(FieldPos("F1_UFPLAC")) > 0
			aAdd( aTransp, SF1->F1_UFPLAC)										// [12]UF da Placa do Veículo
		Else
			aAdd( aTransp, SA4->A4_EST)	
		EndIf
		If SF1->(FieldPos("F1_PLACA")) > 0
			aAdd( aTransp, SF1->F1_PLACA)										// [13]Placa do Caminhão
		Else
			aAdd( aTransp, " ")
		EndIf
		aAdd( aTransp, SF1->F1_VOLUME)											// [14]Quantidade de Volumes
//		aAdd( aTransp, SF1->F1_ESPECIE)											// [15]Espécie dos Volumes 
		aAdd( aTransp, SF1->F1_ESPECI1)											// [15]Espécie dos Volumes 
		If SF1->(FieldPos("F1_MARCA")) > 0
			aAdd( aTransp, SF1->F1_MARCA)										// [16]Marca dos Volumes
		Else
			aAdd( aTransp, " ")
		EndIf
		If SF1->(FieldPos("F2_NUMVOL")) > 0
			aAdd( aTransp, SF1->F1_NUMVOL)										// [17]Número dos dos Volumes
		Else
			aAdd( aTransp, " ")
		EndIf
		aAdd( aTransp, SF1->F1_PESOB)											// [18]Peso Bruto Total
		aAdd( aTransp, SF1->F1_PESOL)											// [19]Peso Líquido Total

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os campos dos itens da nota fiscal ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")
		dbSetorder(1)
		MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		While !Eof() .And. SD1->D1_FILIAL == xFilial("SD1") .And. SD1->D1_DOC == SF1->F1_DOC .And.;
							SD1->D1_SERIE == SF1->F1_SERIE .And.;
							SD1->D1_FORNECE == SF1->F1_FORNECE .And.;
							SD1->D1_LOJA == SF1->F1_LOJA

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Desconsidera notas que não são formulário próprio |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SD1->D1_FORMUL <> "S"
				dbSkip()
				Loop
			Endif
					
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no arquivo de Produto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			If !MsSeek(xFilial("SB1")+SD1->D1_COD)
				Aviso(	cTitulo,;
							"Produto não localizado no arquivo! Contate o Administrador.",;
							{"&Continua"},,;
							"Produto: "+SD1->D1_COD)
				Return(Nil)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega as mensagens codificadas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SB1->(FieldPos("B1_MENNOT")) > 0 .And. !Empty(SB1->B1_MENNOT)
				If aScan( aCodMen, { |x| x[2] == SB1->B1_MENNOT } ) == 0
					aAdd( aCodMen, { "8", SB1->B1_MENNOT } )
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega os pesos com base no produto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPesLiq	+= Round(SB1->B1_PESO * SD1->D1_QUANT, TAMSX3("B1_PESO")[2])
			nPesBru	+= Round(SB1->B1_PESBRU * SD1->D1_QUANT, TAMSX3("B1_PESBRU")[2])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no arquivo de Tipo de Entrada e Saída ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SF4")
			If !MsSeek(xFilial("SF4")+SD1->D1_TES)
				Aviso(	cTitulo,;
						"Tipo de Entrada/Saída não localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"TES: "+SD1->D1_TES)
				Return(Nil)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega as mensagens codificadas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SF4->(FieldPos("F4_MENNOT1")) > 0 .And. !Empty(SF4->F4_MENNOT1)
				If aScan( aCodMen, { |x| x[2] == SF4->F4_MENNOT1} ) == 0
					aAdd( aCodMen, { "1", SF4->F4_MENNOT1 } )
				EndIf
			EndIf
			If SF4->(FieldPos("F4_MENNOT2")) > 0 .And. !Empty(SF4->F4_MENNOT2)
				If aScan( aCodMen, { |x| x[2] == SF4->F4_MENNOT2 } ) == 0
					aAdd( aCodMen, { "1", SF4->F4_MENNOT2 } )
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona o array com as naturezas de operação ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan( aNatOpe, { |x| x[1] == SD1->D1_TES }) == 0				 
				aAdd( aNatOpe, { SD1->D1_TES, SD1->D1_CF, SF4->F4_TEXTO })		// SD2->D2_TES 	19/05
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta a descrição do produto com base em campos específicos ou do pedido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Do Case
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Defino a quantidade de linhas com base no campo memo do pedido de venda ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Case SD1->(FieldPos("D1_DESCCOM")) > 0 .And. !Empty(SD1->D1_DESCCOM)
					nQdeLnh	:= MlCount( SD1->D1_DESCCOM, nTamPro)
					cOpMemo	:= "1"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Defino a quantidade de linhas com base no campo memo do cadastro do produto ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Case !Empty(SB1->B1_DESC_P)
					cMemo	:= AllTrim( MSMM(SB1->B1_DESC_P))
					nQdeLnh	:= MlCount( cMemo, nTamPro)
					cOpMemo	:= "2"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Defino a quantidade de linhas com base no campo simples do pedido de venda ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				/*	Inibido/Alterado em 24/05/06 - Cezar
				Case !Empty(SD1->D1_DESCRI)
					nQdeLnh	:= MlCount( SD1->D1_DESCRI, nTamPro)
					cOpMemo	:= "3"
				*/
				Case SD1->(FieldPos("D1_DESCRI")) > 0 .And. !Empty(SD1->D1_DESCRI)
					nQdeLnh	:= MlCount( SD1->D1_DESCRI, nTamPro)
					cOpMemo	:= "3"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Defino a quantidade de linhas com base no campo simples do cadastro do produto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			OtherWise
				nQdeLnh	:= MlCount( SB1->B1_DESC, nTamPro)
				cOpMemo	:= "4"
			EndCase

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se a quantidade de linhas for igual a zero, força pegar do cadastro de produto ³
			//³ pois em alguns casos os campos memos podem estar vazios                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nQdeLnh == 0
				nQdeLnh	:= MlCount( SB1->B1_DESC, nTamPro)
				cOpMemo	:= "4"
			EndIf

			For nLoop := 1 To nQdeLnh
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta a linha de descrição do produto com base no tamanho desta ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Do Case
					Case cOpMemo == "1"
						cMemo	:= MemoLine( SD1->D1_DESCCOM, nTamPro, nLoop)
					Case cOpMemo == "2"
						cMemo	:= MemoLine( AllTrim( MSMM(SB1->B1_DESC_P)), nTamPro, nLoop)
					Case cOpMemo == "3"
						cMemo	:= MemoLine( SD1->D1_DESCRI, nTamPro, nLoop)
				OtherWise
					cMemo	:= MemoLine( SB1->B1_DESC, nTamPro, nLoop)
				EndCase

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adiciona o array apenas com a descrição do produto ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nLoop <> 1
					aAdd( aItens, {	CriaVar("SD1->D1_COD", .F.),;				// [1]Código do Produto
									cMemo,;										// [2]Descrição
									CriaVar("B1_CLASFIS", .F.),;				// [3]NBM
									CriaVar("D1_CLASFIS", .F.),;				// [4]Situação Tributária
									CriaVar("D1_UM", .F.),;						// [5]Unidade de Medida
									CriaVar("D1_QUANT", .F.),;					// [6]Quantidade
									CriaVar("D1_VUNIT", .F.),;					// [7]Preço de Venda
									CriaVar("D1_TOTAL", .F.),;					// [8]Preço Total
									CriaVar("D1_PICM", .F.),;					// [9]Percentual do ICMS
									CriaVar("D1_IPI", .F.),;					// [10]Percentual do IPI
									CriaVar("D1_VALIPI", .F.),;					// [11]Valor do IPI
									CriaVar("D1_CF", .F.) ;						// [12]Código Fiscal de Operação e Prestação
									 })
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adiciona o array todos oa dados necessários ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Else
					aAdd( aItens, {	SD1->D1_COD,;									//1
									cMemo,;
									cCodNBM,;
									If(!Empty(SD1->D1_CLASFIS),;
										SD1->D1_CLASFIS,;
										SB1->B1_ORIGEM+SF4->F4_SITTRIB)	,;
									SD1->D1_UM,;
									SD1->D1_QUANT,;
									SD1->D1_VUNIT,;
									SD1->D1_TOTAL,;
									SD1->D1_PICM,;
									If(SF4->F4_DESTACA <> "N", SD1->D1_IPI,0),; 
									If(SF4->F4_DESTACA <> "N", SD1->D1_VALIPI, 0),;  		
									SD1->D1_CF ;
									})
				EndIf
			Next nLoop

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona o array com os valores do IPI no corpo da nota ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SF4->F4_DESTACA == "N" .And. SF1->F1_TIPO $ "BD"
				aAdd( aIPIDEV, SD1->D1_VALIPI )
			EndIf
							
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona o array com as notas de devolução ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SD1->D1_NFORI)
				dbSelectArea("SF2")
				If MsSeek(xFilial("SF2")+SD1->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA))
					dEmiDev	:= SF2->F2_EMISSAO
				EndIf
				dbSelectArea("SD1")
				If aScan( aNFDev, { |x| x[1]+x[2] == SD1->D1_NFORI+SD1->D1_SERIORI }) == 0
					aAdd( aNFDev, { SD1->D1_NFORI, SD1->D1_SERIORI, dEmiDev, SD1->D1_TIPO })
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Vai para o proximo item de nota³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD1")
			dbSkip()
			
		Enddo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define os pesos da nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aTransp[18]) .Or. !Empty(aTransp[19])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pega os pesos do Pedido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Len(aPesPed) > 0
				lSomLiq	:= Empty(aTransp[18])
				lSomBru	:= Empty(aTransp[19])
				For nLoop := 1 To Len(aPesPed)
					If lSomLiq
						aTransp[18]	+= aPesPed[nLoop,03]
					EndIf
					If lSomBru
						aTransp[19] += aPesPed[nLoop,02]
					EndIf
				Next nLoop
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pega os pesos do produto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aTransp[18]) .Or. Empty(aTransp[19])
				If Empty(aTRansp[18])
					aTransp[18]	+= nPesLiq
				EndIf
				If Empty(aTransp[19])
					aTransp[19] += nPesBru
				EndIf
			EndIf
		EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta a mensagem de devolução de notas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aNFDev) > 0
			If aNFDev[1,4] == "D"
				cMensag	:= "Devolucao "
			Else
				cMensag	:= "Retorno "
			EndIf
			cMensag	+= "Referente sua(s) nota(s) fiscal(is) "
			For nLoop := 1 To Len(aNFDev)
				If nLoop <> 1
					cMensag	+= " e "
				EndIf
				cMensag	+= AllTrim(aNFDev[nLoop,1])+"/"+AllTrim(aNFDev[nLoop,2])+" de "+DToC(aNFDev[nLoop,3])
			Next nLoop
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava a mensagem montada no array ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CallMens(cMensag, 2, "2")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava as mensagens codificadas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nLoop := 1 To Len(aCodMen)
			CallMens(aCodMen[nLoop,2], 1, aCodMen[nLoop,1]+StrZero(nLoop,2))
		Next nLoop

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava as mensagens do IPI para crédito no campo de dados adicionais |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nVlrIPIDev	:= 0
		For nLoop := 1 To Len(aIPIDev)
			nVlrIPIDev += aIPIDev[nLoop]
		Next nLoop
		If !Empty(nVlrIPIDev)
			cMensag	:= "IPI para credito no valor de R$ "+AllTrim(Transform(nVlrIPIDev, "@E 999,999,999.99"))
			CallMens(cMensag, 2, "0")
		EndIf
			   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calcula a quantidade de formularios necessarios³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nFormul := Int(Len(aItens)/nTamDet + .999999999)
						  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama funcao de impressao da nota fiscal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nForAtu := 1 to nFormul
			Imprime()
		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Movimenta o registro e a regua de impressao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF1")
		dbSkip()
	EndDo
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime caracter de descompactacao e zera posicao do formulario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 000, 000 PSAY Chr(18)					  // Descompressao de caracteres

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Encerra a impressao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen    

SetPgEject(.f.)

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif



Ms_Flush()




*******************************************************************************************************
Static Function CriaSx1(aRegs)
*******************************************************************************************************

/*Local aAreaAnt	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nLoop2	:= 0
Local nLoop1	:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nLoop1 := 1 To Len(aRegs)
	If !MsSeek(aRegs[nLoop1,1]+aRegs[nLoop1,2])
		RecLock("SX1",.T.)
		For nLoop2 := 1 To FCount()
			If nLoop2 <= Len(aRegs[nLoop1])
				FieldPut(nLoop2,aRegs[nLoop1,nLoop2])
			EndIf
		Next nLoop2
		MsUnlock()
	EndIf
Next nLoop1

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return(Nil) */                 




******************************************************************************************************
Static Function VisaFImp(aFImp)
******************************************************************************************************

Local oDlg
Local oListBox
Local aTitulo	:= {	"Nota Fiscal",;
						"Série",;
						"Emissão",;
						"Valor Bruto",;
						"Código Cliente",;
						"Loja",;
						"Nome Cliente/Fornecedor" ;
						}								// Array com os t'tiulos da janela listbox
Local cListBox	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Array aFImp                                   | 
//| 1o. Elemento - Número da Nota Fiscal          |
//| 2o. Elemento - Série da Nota Fiscal           |
//| 3o. Elemento - Data de Emissão da Nota Fiscal |
//| 4o. Elemento - Valor Bruto da Nota Fiscal     |
//| 5o. Elemento - Código do Cliente              |
//| 6o. Elemento - Loja do Cliente                |
//| 7o. Elemento - Nome do Cliente                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Ordena array pela parcela de forma descendente para que o registro totalizador fique primeiro |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aFImp,,, { |x, y| x[2]+x[1] < y[2]+y[1] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Monta display |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Notas Fiscais não Impressas" From 9,0 To 19,60 OF oMainWnd 
DEFINE SBUTTON FROM    4,206 	TYPE 1  ACTION (nOpc := 1,oDlg:End()) ENABLE OF oDlg 
@ .5,.7 LISTBOX oListBox VAR cListBox Fields HEADER ;
										aTitulo[1],;
										aTitulo[2],;
										aTitulo[3],;
										aTitulo[4],;
										aTitulo[5],;
										aTitulo[6],;
										aTitulo[7],;
										SIZE 195,62 
oListBox:SetArray(aFImp)
oListBox:bLine := { || {	aFImp[oListBox:nAt,1],;
   							aFImp[oListBox:nAt,2],;
   							aFImp[oListBox:nAt,3],;
							Transform(aFImp[oListBox:nAt,4], "@E 9,999,999.99"),;
							aFImp[oListBox:nAt,5],;
							aFImp[oListBox:nAt,6],;
							aFImp[oListBox:nAt,7] ;
							}}
ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)




******************************************************************************************************
Static Function CallMens(cMensag, nTipo, cPrior)
******************************************************************************************************

Local cTexto	:= ""
Local nLoop		:= 0
Local nCnt		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Se for mensagem codificada monta o texto |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 1
	cTexto	:= AllTrim(Formula(cMensag))
Else
	cTexto	:= AllTrim(cMensag)
EndIf

Return(cTexto)




*******************************************************************************************************
Static Function Imprime()
*******************************************************************************************************

Local nLoop		:= 0
Local cNatOpe	:= ""
Local cCFOOpe	:= ""
Local cLinha1	:= ""
Local cLinha2	:= ""
Local cLinha3	:= ""
Local nDetObs	:= 0

For nLoop := 1 To Len(aNatOpe)
	cNatOpe	+= If(!Empty(cNatOpe), "/", "")+AllTrim(aNatOpe[nLoop,3])
	cCFOOpe += If(!Empty(cCFOOpe), "/", "")+Transform(aNatOpe[nLoop,2], "@R 9.999")
Next nLoop

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Imprime o Cabeçalho da Nota |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Li := 02                     

//@ Li,120 PSAY aCab[01] + If(nFormul > 1," / "+AllTrim(Str(nForAtu,6)),"")
        
LI+= 1

If mv_par04 == 2
	@ Li,090 	PSAY "X"   
Else
	@ Li,100 	PSAY "X"
EndIf 


Li+= 5

// Imprime a Natureza da Operação
@ Li,042 PSAY Left(cNatOpe, 30)
@ Li,065 PSAY Left(cCFOOpe, 14)

Li+= 3


@ Li,042 PSAY aCab[7]

If Len(Alltrim(aCab[15])) > 11		
	@ Li,088 PSAY Transform(aCab[15], "@R 99.999.999/9999-99")
Else
	@ Li,088 PSAY Transform(aCab[15], "@R 999.999.999-99")
EndIf
@ Li,111	PSAY aCab[4]  // Data de Emissao

Li+=1


Li+= 1
@ Li,042 PSAY aCab[8]
@ Li,088 PSAY Substr(aCab[9],1,8) // Bairro foi reduzido a 8 posições devido ao layout da nota fiscal
@ Li,98 PSAY Transform(aCab[10], "@R 99999-999")

Li+= 2

@ Li,042 PSAY aCab[11]
@ Li,068 PSAY If(!Empty(Alltrim(aCab[13])), "("+Alltrim(aCab[19])+")"+aCab[13]+" "+aCab[14]," ")
@ Li,084 PSAY aCab[12]
@ Li,089 PSAY aCab[16]Picture "@R 999.999.999"

Li+= 3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Imprime a Fatura      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Len(aDuplic) > 0
	@Li,042	PSAY aCab[4]											// Emissao da Duplicata
	@Li,055	PSAY aDuplic[1,2]										// Numero da Fatura
	@Li,074	PSAY aRodape[3]											// Valor Faturado
	@Li,086	PSAY aDuplic[1,2]										// Numero da Fatura
	
	If Len(aDuplic)  = 1                            
		@Li,98	PSAY aDuplic[1,7]		// Vencimento
	Else
		@Li,96	PSAY "VIDE QUADRO"		// Vencimento
	EndIf
EndIf		  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                          
//| Imprime as Duplicatas |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cLinha1	:= ""
cLinha2	:= ""
cLInha3	:= ""
cLinha4 := ""
cLinha5 := ""
cLinha6	:= ""

For nLoop := 1 To Min(Len(aDuplic), 6) 	// Step 3
	If nLoop == 1 
		cLinha1 += aDuplic[nLoop,2]+"  "+DToC(aDuplic[nLoop,7])+""+Transform(aDuplic[nLoop,6], "@E 999,999,999.99")
	ElseIf nLoop == 2
		cLinha2 += aDuplic[nLoop,2]+"  "+DToC(aDuplic[nLoop,7])+""+Transform(aDuplic[nLoop,6], "@E 999,999,999.99")	
	ElseIf nLoop == 3
		cLinha3 += aDuplic[nLoop,2]+"  "+DToC(aDuplic[nLoop,7])+""+Transform(aDuplic[nLoop,6], "@E 999,999,999.99")	
	ElseIf nLoop == 4
		cLinha4 += aDuplic[nLoop,2]+"  "+DToC(aDuplic[nLoop,7])+""+Transform(aDuplic[nLoop,6], "@E 999,999,999.99")	
	ElseIf nLoop == 5
		cLinha5 += aDuplic[nLoop,2]+"  "+DToC(aDuplic[nLoop,7])+""+Transform(aDuplic[nLoop,6], "@E 999,999,999.99")	
	ElseIf nLoop == 6
		cLinha6 += aDuplic[nLoop,2]+"  "+DToC(aDuplic[nLoop,7])+""+Transform(aDuplic[nLoop,6], "@E 999,999,999.99")	
	EndIf
Next nLoop

cLinha1	:= AllTrim(cLinha1)
cLinha2	:= AllTrim(cLinha2)
cLinha3	:= AllTrim(cLinha3)
cLinha4 := Alltrim(cLinha4)
cLinha5 := Alltrim(cLinha5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime Pedidos / Vendedor  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Li+= 1
@li,010 PSAY aPedCli[1]	   // Imprime o Pedido do Cliente
@li,024 PSAY aItens[1,13]   // Imprime o primeiro pedido
@li,034 PSAY aCab[18]	   // Imprime o Vendedor

Li+= 2


If Len(aDuplic) > 1
	@Li,009 PSAY cLinha1
EndIf	

Li+= 1



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime Endereço de Cobrança³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@Li,009 PSAY cLinha2

If mv_par04 == 2	// Saida
	If Empty(cLinha2)
		@Li,034	PSAY Alltrim(aCab[26])+ " " + Alltrim(aCab[27]) + " " + Alltrim(aCab[28]) + " " +Alltrim(aCab[29])
	Else
		@Li,042	PSAY Alltrim(aCab[26])+ " " + Alltrim(aCab[27]) + " " + Alltrim(aCab[28]) + " " +Alltrim(aCab[29])	
	EndIf	
EndIf	
           
Li+= 1

@Li,009 PSAY cLinha3

Li+= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime Valor por Extenso   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If aRodape[3] > 0      
	@Li,009 PSAY cLinha4
	If Empty(cLinha4)
		@li,034 PSAY Subs(RTRIM(SUBS(EXTENSO(aRodape[3]),1,75)) + REPLICATE("*",75),1,75)
	Else
		@li,042 PSAY Subs(RTRIM(SUBS(EXTENSO(aRodape[3]),1,75)) + REPLICATE("*",75),1,75)
	EndIf			
	li:= li + 1        
	@Li,009 PSAY cLinha5
	If Empty(cLinha5)
		@li,034 PSAY Subs(RTRIM(SUBS(EXTENSO(aRodape[3]),76,75)) + REPLICATE("*",75),1,75)
	Else
		@li,042 PSAY Subs(RTRIM(SUBS(EXTENSO(aRodape[3]),76,75)) + REPLICATE("*",75),1,75)		
	EndIf	
Else
	@Li,009 PSAY cLinha4
	li:= li + 1        
	@Li,009 PSAY cLinha5
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Imprime os Itens da Nota |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Li := 29              

If Len(aItens) > 0
	ImpDet(Li)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Imprime os Itens de Serviço |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Li:= 27
If Len(aServico) > 0
	ImpSer(Li)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime os Totais da Nota ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nFormul > 1 .And. nForAtu <> nFormul
	Li := 57
	@ Li,006 PSAY "***,***,***.**"
	@ Li,023 PSAY "*,***,***.**"
	@ Li,037 PSAY "***,***,***.**"
	@ Li,053 PSAY "*,***,***.**"
	@ Li,072 PSAY "***,***,***.**"
Else
    Li := 54
    @ Li,015 PSAY chr(15)+cTxt+chr(18)
    Li := 57
	@ Li,006 PSAY aRodape[12]				Picture "@E 999,999,999.99"
	@ Li,023 PSAY aRodape[13]				Picture "@E 9,999,999.99"
	@ Li,037 PSAY aRodape[16]				Picture "@E 999,999,999.99"
	@ Li,053 PSAY aRodape[17]  				Picture "@E 9,999,999.99"
	@ Li,072 PSAY aRodape[02]-nTotSer		Picture "@E 999,999,999.99"
EndIf
Li += 2

If nFormul > 1 .And. nForAtu <> nFormul
	@ Li,006 PSAY "***,***,***.**"
	@ Li,023 PSAY "*,***,***.**"
	@ Li,037 PSAY "***,***,***.**"
	@ Li,053 PSAY "*,***,***.**"
	@ Li,072 PSAY "***,***,***.**"
Else
	@ Li,006 PSAY aRodape[04]				Picture "@E 999,999,999.99"
	@ Li,023 PSAY aRodape[08]				Picture "@E 9,999,999.99"
	@ Li,037 PSAY aRodape[09]				Picture "@E 999,999,999.99"
	@ Li,053 PSAY aRodape[15]				Picture "@E 9,999,999.99"
	@ Li,072 PSAY aRodape[01]				Picture "@E 999,999,999.99"
EndIf
Li += 3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime os Dados de Transporte ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFormul = 1 .Or. nForAtu == nFormul
	@ Li,010 PSAY aTransp[03]
	@ Li,054 PSAY aTransp[11]
//	@ Li,051 PSAY Transform(aTransp[13], "@R XXX-9999")
	@ Li,065 PSAY aTransp[12]

	If !Empty(aTransp[09])
		If Len(Alltrim(aTransp[09])) >= 14
			@ Li, 069 PSAY aTransp[09] Picture"@R 99.999.999/9999-99"
		Else
			@ Li, 069 PSAY aTransp[09] Picture"@R 999.999.999-99"
		Endif		
	Endif
EndIf
Li += 2

If nFormul = 1 .Or. nForAtu == nFormul
	@ Li,010 PSAY aTransp[04]
	@ Li,048 PSAY aTransp[06]
	@ Li,066 PSAY aTransp[07]
	@ Li,070 PSAY aTransp[10] 
EndIf
Li += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime dos dados dos volumes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nFormul = 1 .Or. nForAtu == nFormul)
	If aTransp[14] > 0
		@ Li,008 PSAY aTransp[14]			Picture "@E 9999"
	EndIf	
	@ Li,021 PSAY aTransp[15]
	@ Li,035 PSAY aTransp[16]
	@ Li,046 PSAY aTransp[17]
	@ Li,063 PSAY aTransp[18]			Picture "@E 99999.99"
	@ Li,076 PSAY aTransp[19]			Picture "@E 99999.99"
EndIf
Li += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o tamanho a ser impresso com base no array mensagens, NBM ou máqximo de linhas permitido ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDetObs	:= Max( Len(aDadAdc), Len(aNBM)+1 )
nDetObs	:= Min( nTamObs, nDetObs )

/*  DESABILITADO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime dados adicionais na nf    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Li := 61

@ Li,003 PSAY UPPER(aDuplic[1,4])

// Imprime Vendedor

@ Li,22 PSAY aCab[18] 

// Imprime Contato ( Regra primeiro contado do pedido de Vendas, depois contato do cadastro de cliente, 
// depois primeiro registro do cadastro de contatos.

@ Li,35 PSAY aCab[20] 

// Imprime o numero do primeiro pedido.

@li,50 PSAY aItens[1,13]
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona final do formulario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Li := 80
@ Li,000 PSAY Chr(18)								// Define caracteres normais
SetPrc(0,0)											// Inicializa 
Return(.T.)



*******************************************************************************************************
Static Function ImpDet()
*******************************************************************************************************

Local nLoop1 := 0

For nLoop1 := (nForAtu-1)*nTamDet+1 To Min(Len(aItens),nForAtu*nTamDet)

//	@ Li,004 PSAY Left(aItens[nLoop1,01],14)			// Codigo
	@ Li,010 PSAY "."									// O código do produto não é impresso na nota fiscal
	

	@ Li,014 PSAY aItens[nLoop1,02]						// Descricao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Só imprime os demais dados se não for a linha prinicpal do produto ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aItens[nLoop1,01])
		@ Li,064 PSAY aItens[nLoop1,03]													// NCM
	    @ Li,067 PSAY aItens[nLoop1,04]													// Sit. Tribut.
		@ Li,071 PSAY aItens[nLoop1,05]													// Unidade					86
		@ Li,075 PSAY aItens[nLoop1,06]				Picture "@E 99999"					// Qtde.					90
	    @ Li,080 PSAY aItens[nLoop1,07]				Picture "@E 999,999.99"				// Preco Unit.				96
		@ Li,092 PSAY aItens[nLoop1,08]				Picture "@E 99,999,999.99"			// Preco Total              108
		@ Li,106 PSAY aItens[nLoop1,09]				Picture "@E 99"						// ICMS (%)		// 19/05 	127
		@ Li,109 PSAY aItens[nLoop1,10]				Picture "@E 99"						// IPI (%)					132
		@ Li,112 PSAY aItens[nLoop1,11]				Picture "@E 999999.99"				// Valor do IPI             137
	EndIf
	Li++
Next

Li++

If mv_par04 == 2 .And. Len(aObsAcima) >0
 	@ Li,000    PSAY Chr(15)
	@ Li,13   	PSAY Chr(15)+Substr(aObsAcima[01,01],1,200)+Chr(18)		// Observacao Acima
	

@ Li,000    PSAY Chr(18)								// Define caracteres normais
EndIf 

Return(nLoop1)


*******************************************************************************************************
Static Function ImpSer(nLinIni)
*******************************************************************************************************

Local nLoop1 	:= 0

For nLoop1 := (nForAtu-1)*nTamSer+1 To Min(Len(aServico),nForAtu*nTamSer)
	@ Li,004 PSAY aServico[nLoop1,02]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Só imprime os demais dados se não for a linha prinicpal do produto ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aServico[nLoop1,01])
//		@ Li,098 PSAY aServico[nLoop1,03]
//		@ Li,103 PSAY aServico[nLoop1,04				Picture "@E 9999"
	    @ Li,094 PSAY aServico[nLoop1,05]				Picture "@E 999,999,999.99"
		@ Li,107 PSAY aServico[nLoop1,06]				Picture "@E 99999,999,999.99"
	EndIf
	nTotSer += aServico[nLoop1,06]
	Li++
Next

@ nLinIni+nTamSer,127 PSAY nTotSer						Picture "@E 99,999,999,999.99"

Return(nLoop1)
