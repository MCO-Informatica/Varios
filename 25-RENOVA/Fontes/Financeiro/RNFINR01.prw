#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ RNFINR01  ³ Impressão individual do titulo a receber                    º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 04.12.17 ³ Departamento de sistemas / TI - Renova                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 04.12.17 ³ Fabio Jadao Caires - TRIYO Tecnologia                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil.                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil.                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ Impressao individual de um titulo a receber                             º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 04.12.17 - Fabio Jadao Caires - Criacao do relatorio                    º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RNFINR01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaração das variáveis do progra                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Local aDadImp		:= {}
Local aRegs			:= {}
Local lEnd			:= .F.
Local cPerg  		:= "RNFINR01"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parâmetros da Rotina                                                                    ³
//³ mv_par01   Prefixo do Titulo                                                            ³
//³ mv_par02   Numero                                                                       ³
//³ mv_par03   Parcela                                                                      ³
//³ mv_par04   Tipo    
//³ mv_par05   Banco  			     		                                                ³
//³ mv_par06   Agencia	    		 		                                                ³
//³ mv_par07   Digito Agencia	     		                                                ³
//³ mv_par08   Conta	     				                                                ³
//³ mv_par09   Digito Conta 	     		                                                ³
//³ mv_par10   Imprime Recibo	     		                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aRegs,{	cPerg,;										// Grupo de perguntas
				"01",;										// Sequencia
				"Prefixo do Titulo",;						// Nome da pergunta
				"",;										// Nome da pergunta em espanhol
				"",;										// Nome da pergunta em ingles
				"mv_ch1",;									// Variável
				"C",;										// Tipo do campo
				03,;										// Tamanho do campo
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
				"",;								  		// 4a. Variável disponível no programa
				"",;										// 4a. Definição da variável
				"",;										// 4a. Definição variável em espanhol
				"",;										// 4a. Definição variável em ingles
				"",;										// 4o. Conteúdo variável
				"",;										// 5a. Variável disponível no programa
				"",;										// 5a. Definição da variável
				"",;										// 5a. Definição variável em espanhol
				"",;										// 5a. Definição variável em ingles
				"",;										// 5o. Conteúdo variável
				"SE1",;										// F3 para o campo
				"",;										// Identificador do PYME
				"",;										// Grupo do SXG
				"",;										// Help do campo
				"" })										// Picture do campo
				
aAdd(aRegs,{cPerg,"02","Numero"        				,"","","mv_ch2","C",09,0,0,"G",""				,"MV_PAR02","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"03","Parcela"           			,"","","mv_ch3","C",03,0,0,"G",""				,"MV_PAR03","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"04","Tipo"             			,"","","mv_ch4","C",03,0,0,"G",""				,"MV_PAR04","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"05","Banco"        				,"","","mv_ch5","C",03,0,0,"G","U_FNR01BCO()"	,"MV_PAR05","",			"","","","","","","","","","","","","","","","","","","","","","","","SA6"	,"","","","" })
aAdd(aRegs,{cPerg,"06","Agencia"           			,"","","mv_ch6","C",05,0,0,"G",""				,"MV_PAR06","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"07","Dig.Age"           			,"","","mv_ch7","C",01,0,0,"G",""				,"MV_PAR07","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"08","Conta"             			,"","","mv_ch8","C",10,0,0,"G",""				,"MV_PAR08","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"09","Dig.CC."           			,"","","mv_ch9","C",01,0,0,"G",""				,"MV_PAR09","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
//Incluido Ronaldo Bicudo - Analista Totvs - 20/03/2018
aAdd(aRegs,{cPerg,"10","Imprime Recibo?"   			,"","","mv_cha","N",01,0,2,"C",""				,"MV_PAR10","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","     ","","","","","","!@"})
//AADD(aRegs,{cPerg,"16","Imprime Provisorios ?"      ,"","","mv_chg","N", 1,0,2,"C",""             ,"mv_par16","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","","","","!@" })
//Fim da Inclusão

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria as perguntas se necessário                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaSx1(aRegs)

Pergunte(cPerg,.T.)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona a SE1 no titulo selecinado a partir das perguntas                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SE1->( DbSetOrder(1))	// E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
lEnd := !( SE1->( DbSeek( xFilial("SE1") + mv_par01 + mv_par02 + mv_par03 + mv_par04 ) ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se não abortar a rotina, chama a função de impressão                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lEnd
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se encontrou dados a serem processados faz a interface com o usuário                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus( { |lEnd| RunReport(@lEnd) }, "Aguarde...", "Imprimindo Título...", .T. )
EndIf

Return( Nil )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ RunReport³ Efetua a impressão do titulo a receber                       º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 04.12.17 ³ Implantação                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 04.12.17 ³ Almir Bandina                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpL1 - Variável de controle de cancelamento da função                  º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil.                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 04.12.17 - Fabio Jadao Caires - Criacao da funcao                       º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport(lEnd)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as variáveis da funcao                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Local oBrush
Local oFont07		:= TFont():New("Verdana",07,10,,.F.,,,,.T.,.F.)
Local oFont09		:= TFont():New("Verdana",09,09,,.F.,,,,.T.,.F.)  
Local oFont10		:= TFont():New("Verdana",10,10,,.F.,,,,.T.,.F.)
Local oFont10n		:= TFont():New("Verdana",10,10,,.T.,,,,.T.,.F.)
Local oFont12		:= TFont():New("Verdana",12,12,,.F.,,,,.T.,.F.)
Local oFont12n		:= TFont():New("Verdana",12,12,,.T.,,,,.T.,.F.)
Local oFont11n		:= TFont():New("Verdana",11,11,,.T.,,,,.T.,.F.)
Local oFont15		:= TFont():New("Verdana",15,15,,.F.,,,,.T.,.F.)
Local oFont15n		:= TFont():New("Verdana",15,15,,.T.,,,,.T.,.F.)
Local oFont21n		:= TFont():New("Verdana",21,21,,.T.,,,,.T.,.F.)
Local nLoop1		:= 0
Local nLoop2		:= 0
Local nLoop3		:= 0
Local nLoop4		:= 0
Local nQdeLnh		:= 0
Local cBmp			:= ""
Local cStartPath	:= AllTrim( GetSrvProfString( "StartPath", "" ) )
Local aDiaSemana	:= {"domingo","segunda-feira","terça-feira","quarta-feira","quinta-feira","sexta-feira","sábado"}
Local aMes			:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

Private oPrint
Private nLin		:= 080
Private nCol		:= 200
Private nPagina		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz ajueste no path se necessário                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If SubStr( cStartPath, Len( cStartPath ), 1 ) != "\"
//	cStartPath += "\"
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a regua de impressão                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SetRegua( Len( aDadImp ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializacao do objeto grafico                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint 	:= TMSPrinter():New("Titulo a Receber")
oPrint:Setup()
oPrint:SetPortrait()
//oBrush	:= TBrush():New( , CLR_LIGHTGRAY)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se tem impressora ativa                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If 	oPrint:IsPrinterActive()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona nos arquivos necessários da chave                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("SE1")
	SE1->( DbSetOrder(1) )	// E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
	SE1->( DbSeek( xFilial("SE1") + mv_par01 + mv_par02 + mv_par03 + mv_par04 ) )
	If	SE1->( EOF() )
		Alert("Título a Receber não encontrado. Por favor verifique.")
		Return
	EndIf

	dbSelectArea( "SA1" )
	SA1->( DbSetorder(1) )	// A1_FILIAL + A1_COD + A1_LOJA
	SA1->( DbSeek( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA ) )
	If	SA1->( EOF() )
		Alert("Cliente não cadastrado. Por favor verifique.")
		Return
	EndIf
	
	dbSelectArea( "SA6" )
	SA6->( DbSetorder(1) )	// A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
	SA6->( DbSeek( xFilial("SA6") + mv_par05 + mv_par06 + mv_par08 ) )
	If	SA6->( EOF() )
		Alert("Banco/Agencia/Conta não cadastrado. Por favor verifique.")
		Return
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a página                                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:StartPage()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do Box principal                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oPrint:Box(nLin,nCol,3100,2350)
	//oPrint:Say(3105,nCol, "Página " + AllTrim( Str( nPagina ) ), oFont07)			
	nLin := IncLinha(nLin,060)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclusao do logotipo da filial de faturamento                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBmp	:= "\logo\renova_logo_490_250.bmp"	// "C:\Temp\renova_logo_490_250.bmp"
	If File( cBmp )
		oPrint:SayBitmap(nLin,nCol+0020,cBmp,490,250)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do Quadro Dados da Empresa                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:Say(nLin,nCol+0600, Capital(OemtoAnsi(SM0->M0_NOMECOM)), oFont15n)
	nLin := IncLinha(nLin,60)
	oPrint:Say(nLin,nCol+0600, Capital(AllTrim(SM0->M0_ENDCOB)) + " " + AllTrim(SM0->M0_COMPCOB) + " " + Capital( AllTrim(SM0->M0_BAIRCOB) ), oFont10)
	nLin := IncLinha(nLin,40)
	oPrint:Say(nLin,nCol+0600, "CEP  : " + Transform(SM0->M0_CEPCOB, "@R 99999-999") + " - " + AllTrim(SM0->M0_CIDCOB) + " - " + SM0->M0_ESTCOB, oFont10)
	nLin := IncLinha(nLin,40)
	oPrint:Say(nLin,nCol+0600, "CNPJ : " + Transform(SM0->M0_CGC, "@R 99.999.999/9999-99") , oFont10)
	nLin := IncLinha(nLin,40)
	oPrint:Say(nLin,ncol+0600, "Insc.Mun: " + Transform(SM0->M0_INSC, "@R 9.999" ), oFont10)
	nLin := IncLinha(nLin,50)
	
	/*
	oPrint:Say(nLin,nCol+1610, "ORDEM DE SERVIÇO",oFont15n)
	nLin := IncLinha(nLin,60)
	If nLoop4 == 1
		oPrint:Say(nLin,nCol+0800, "1a. via - Cliente", oFont10)
	Else
		oPrint:Say(nLin,nCol+0800, "2a. via - Prestador", oFont10)
	EndIf
	oPrint:Say(nLin,nCol+1710, "Impressão: "+DToC(Date()), oFont10)
	nLin := IncLinha(nLin,50)
	*/
	
	//oPrint:Line(nLin,nCol,nLin,2350)
	nLin := IncLinha(nLin,100)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do Quadro de Dados do Projeto/Cliente/Técnico                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oPrint:Box(nLin,nCol+1300,nLin+50,nCol+1700)
	oPrint:Box(nLin,nCol+1700,nLin+50,nCol+2100)
	
	oPrint:Say(nLin,nCol+1400, "Nro. Título ", oFont10n)
	oPrint:Say(nLin,nCol+1800, "Data Emissão", oFont10n)
	nLin := IncLinha(nLin,50)

	oPrint:Box(nLin,nCol+1300,nLin+50,nCol+1700)
	oPrint:Box(nLin,nCol+1700,nLin+50,nCol+2100)
	
	oPrint:Say(nLin,nCol+1400, SE1->E1_PREFIXO + "-" + SE1->E1_NUM, oFont10)
	oPrint:Say(nLin,nCol+1800, DTOC(SE1->E1_EMISSAO), oFont10 )
	

	nLin := IncLinha(nLin,150)

	oPrint:Box(nLin,nCol,nLin+50,nCol+1700)
	//oPrint:Box(nLin,nCol,3100,2350)
	oPrint:Box(nLin,nCol+1700,nLin+50,nCol+2100)
	
	oPrint:Box(nLin+50,nCol,nLin+400,nCol+1700)
	oPrint:Box(nLin+50,nCol+1700,nLin+400,nCol+2100)

	oPrint:Box(nLin+400,nCol,nLin+450,nCol+1700)
	oPrint:Box(nLin+400,nCol+1700,nLin+450,nCol+2100)


	oPrint:Say(nLin,nCol+0600, "Descrição da cobrança ", oFont10n)
	oPrint:Say(nLin,nCol+1800, "Valor R$", oFont10n)
	
	nLin := IncLinha(nLin,200)
	
	
	oPrint:Say(nLin,nCol+0300, SE1->E1_HIST		, oFont10 )
	oPrint:Say(nLin,nCol+1800, Transform(SE1->E1_VLCRUZ, "@E 999,999,999.99")	, oFont10 )

	nLin := IncLinha(nLin,200)

	oPrint:Say(nLin,nCol+0600, " Total da cobrança ", oFont10n )
	oPrint:Say(nLin,nCol+1800, Transform(SE1->E1_VLCRUZ, "@E 999,999,999.99")	, oFont10 )

	nLin := IncLinha(nLin,150)
	
	oPrint:Box(nLin    ,nCol,nLin+ 50,nCol+2100)
	oPrint:Box(nLin+ 50,nCol,nLin+100,nCol+2100)
	
	oPrint:Box(nLin+ 50,nCol + 350,nLin+150,nCol+1700)
	oPrint:Box(nLin+ 50,nCol + 750,nLin+150,nCol+1100)
	
	oPrint:Box(nLin+100,nCol,nLin+150,nCol+2100)
	
	oPrint:Say(nLin,nCol+0750, " Dados bancários para pagamento: ", oFont10n )

	nLin := IncLinha(nLin,50)
	oPrint:Say(nLin,nCol+0150, "Banco"			, oFont10n )
	oPrint:Say(nLin,nCol+0500, "Agencia"		, oFont10n )
	oPrint:Say(nLin,nCol+0850, "Conta"			, oFont10n )
	oPrint:Say(nLin,nCol+1200, "Vencimento"		, oFont10n )
	oPrint:Say(nLin,nCol+1800, "Valor R$"		, oFont10n )

	nLin := IncLinha(nLin,50)
	oPrint:Say(nLin,nCol+0150, SA6->A6_COD		, oFont10 )
	oPrint:Say(nLin,nCol+0500, Alltrim(SA6->A6_AGENCIA) + "-" + Alltrim(SA6->A6_DVAGE)	, oFont10 )
	oPrint:Say(nLin,nCol+0850, Alltrim(SA6->A6_NUMCON ) + "-" + Alltrim(SA6->A6_DVCTA)	, oFont10 )
	oPrint:Say(nLin,nCol+1200, DTOC(SE1->E1_VENCREA)	, oFont10 )
	oPrint:Say(nLin,nCol+1800, Transform(SE1->E1_VLCRUZ, "@E 999,999,999.99")	, oFont10 )

	nLin := IncLinha(nLin,150)
	
	oPrint:Box(nLin    ,nCol,nLin+ 50,nCol+2100)
	oPrint:Box(nLin+ 50,nCol,nLin+450,nCol+2100)
	
	oPrint:Say(nLin,nCol+0850, " Dados do Sacado ", oFont10n )
	nLin := IncLinha(nLin,100)

	oPrint:Say(nLin,nCol+0050, "Sacado  : " + SA1->A1_NOME		, oFont10 )
	nLin := IncLinha(nLin,50)

	oPrint:Say(nLin,nCol+0050, "CNPJ    : " + Transform(SA1->A1_CGC, "@R 99.999.999/9999-99")		, oFont10 )
	nLin := IncLinha(nLin,50)

	oPrint:Say(nLin,nCol+0050, "Endereço: " + Alltrim(SA1->A1_END) + Iif( !Empty(SA1->A1_XNUMERO),", " + Alltrim(SA1->A1_XNUMERO),", ") + ;
	 										 						 Iif( !Empty(SA1->A1_COMPLEM),", " + Alltrim(SA1->A1_COMPLEM),""  )	, oFont10 )
	nLin := IncLinha(nLin,50)

	oPrint:Say(nLin,nCol+0050, "Bairro  : " + Alltrim(SA1->A1_BAIRRO), oFont10 )
	nLin := IncLinha(nLin,50)

	oPrint:Say(nLin,nCol+0050, "CEP     : " + Transform(SA1->A1_CEP, "@R 99999-99"), oFont10 )
	nLin := IncLinha(nLin,50)
	
	oPrint:Say(nLin,nCol+0050, "Cidade  : " + SA1->A1_MUN + "     Estado: " + SA1->A1_EST , oFont10 )

	nLin := IncLinha(nLin,200)
    
	If MV_PAR10 = 1
		oPrint:Box(nLin    ,nCol,nLin+ 50,nCol+2100)
		oPrint:Box(nLin+ 50,nCol,nLin+650,nCol+2100)


		oPrint:Say(nLin,nCol+0900, " RECIBO ", oFont10n )
		nLin := IncLinha(nLin,100)
	
		oPrint:Say(nLin,nCol+0050, "Recebemos a importância de " + Transform(SE1->E1_VLCRUZ, "@E 999,999,999.99") , oFont10 )
		nLin := IncLinha(nLin,50)
		oPrint:Say(nLin,nCol+0050, "referente a " + SE1->E1_HIST , oFont10 )
		nLin := IncLinha(nLin,160)
		oPrint:Say(nLin,nCol+0200, "São Paulo, " + aDiaSemana[dow(SE1->E1_EMISSAO)] + ", " + Substr( DTOC(SE1->E1_EMISSAO),1,2 ) + " de " + aMes[ Val(Substr( DTOS(SE1->E1_EMISSAO),5,2 )) ] + " de " + Substr( DTOS(SE1->E1_EMISSAO),1,4 ) , oFont10 )
		
		nLin := IncLinha(nLin,160)
		oPrint:Say(nLin,nCol+0200, "____________________________________________________" , oFont10 )
		nLin := IncLinha(nLin,50)
		oPrint:Say(nLin,nCol+0300, Capital(OemtoAnsi(SM0->M0_NOMECOM)), oFont10 )
		
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a página                                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:EndPage()
	nLin := 0080


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Finaliza a Impressão                                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	oPrint:Preview()
EndIf

Return( Nil )



Static Function IncLinha(nLin,nQdeLin)

Local oFont07		:= TFont():New("Verdana",07,10,,.F.,,,,.T.,.F.)

If nLin >= 3020
	nLin := 80
	nPagina++
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:Box(nLin,nCol,3100,2350)
	oPrint:Say(3105,nCol, "Página " + AllTrim( Str( nPagina ) ), oFont07)			
	nLin += 40
Else
	nLin+= nQdeLin
EndIf

Return(nLin)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CriaSx1  ³ Verifica e cria um novo grupo de perguntas com base nos      º±±
±±º             ³          ³ parâmetros fornecidos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(aRegs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis         										  	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)

// Funcao   : U_FNR01BCO	| Autor: Fabio Jadao Caires		| Data: 09/01/2018
// Descricao: Chamada pelo X1_VALID da pergunta 05 - Banco (F3: SA6) para alimentar a agencia, dv da agencia, conta e dv da conta.
User Function FNR01BCO()

Local nRecSA6 := 0

mv_par06	:= SA6->A6_AGENCIA
mv_par07	:= SA6->A6_DVAGE
mv_par08	:= SA6->A6_NUMCON
mv_par09	:= SA6->A6_DVCTA

Return 