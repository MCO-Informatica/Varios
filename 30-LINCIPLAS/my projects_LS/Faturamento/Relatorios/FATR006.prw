#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATR006   º Autor ³ Vanilson Souza     º Data ³  25/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Este programa tem como objetivo imprimir relatóio de        º±±
±±º			 ³Faturamento por Clienterelatorio de acordo com os parametrosº±±
±±º			 ³informados pelo usuario.									  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR006

//**********************************************************
// ³³³³³³³ Variaveis utilizadas para parametros ³³³³³³³³   ³
//³ mv_par01             // Da Nota Fiscal                 ³
//³ mv_par02             // Ate a Nota Fiscal              ³
//³ mv_par03             // Da Serie                       ³
//³ mv_par04             // Da Emissao			           ³
//³ mv_par05			 // Ate a Emissao	     		   ³
//³ mv_par06             // Do Cliente					   ³
//³ mv_par07             // Ate Cliente					   ³
//³ mv_par08             // Imrime Produto?				   ³
//³ mv_par09             // Do Produto					   ³
//³ mv_par10             // Ate Produto					   ³
//**********************************************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Relatóio de Vendas por Cliente"
Local cPict          	:= ""
Local titulo       		:= "Faturamento por Cliente"
Local nLin         		:= 80
//                          xxx         xxxxxx        xxxxxxxxxxxxxxxxxxxxxxx  		      xxxxxx
Local Cabec1       		:= "Tes         NF            Cliente                             Valor"
//                          xxx    xxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xxxxxxxx      xxxxxx      xxxxxx
Local Cabec2       		:= "Tes    NF       Produto                          Dt Emissão    Cliente     Valor"
Local imprime      		:= .T.
Local aOrd 				:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 80
Private tamanho         := "P"
Private nomeprog        := "FATR006" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       	:= Padr("FREL01",len(SX1->X1_GRUPO)," ")
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "FATR006" // Coloque aqui o nome do arquivo usado para impressao em disco

SET DATE BRITISH  //Corrigi problema com data Britanica

Private cString := "SD2"
/*
dbSelectArea( "SF2" )
dbSetOrder( 1 )
If dbSeek( xAlias( "SF2" ) + MV_PAR01 + MV_PAR03 )
*/

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  25/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cData
Local nTotal := 0
Local nCont := 0

If MV_PAR08 == 2
	
	cQuery := " SELECT DISTINCT F2_DOC, F2_SERIE, F2_EMISSAO, A1_NREDUZ, F2_CLIENTE, D2_TES, F2_VALBRUT"
	cQuery += " FROM  " + RetSqlName("SF2") + "(NOLOCK) INNER JOIN " + RetSqlName("SD2") + " (NOLOCK)"
	cQuery += " ON F2_FILIAL = D2_FILIAL AND "
	cQuery += " F2_DOC = D2_DOC AND "
	cQuery += " F2_SERIE = D2_SERIE AND "
	cQuery += " F2_CLIENTE = D2_CLIENTE "
	cQuery += " INNER JOIN " + RetSqlName("SA1")
	cQuery += " ON F2_CLIENTE = A1_COD AND "
	cQuery += " F2_LOJA = A1_LOJA "
	cQuery += " WHERE D2_FILIAL = '"+SM0->M0_CODFIL+"' AND "
	cQuery += " D2_DOC BETWEEN '"+MV_PAR01 +"' AND "
	cQuery += "'"+ MV_PAR02 +"' AND "
	cQuery += " D2_SERIE = '"+ MV_PAR03 +"' AND "
	cQuery += " D2_EMISSAO BETWEEN '"+ DTOS(MV_PAR04) +"' AND "
	cQuery += "'"+ DTOS(MV_PAR05) +"' AND "
	cQuery += " D2_CLIENTE BETWEEN '"+ MV_PAR06 +"' AND "
	cQuery += "'"+ MV_PAR07 +"'"
	cQuery += " ORDER BY F2_DOC, F2_SERIE, F2_EMISSAO, A1_NREDUZ, F2_CLIENTE, D2_TES, F2_VALBRUT"

	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TRB", .T., .T.)
	
Else
	
	cQuery += "SELECT	DISTINCT D2_DOC AS NF, D2_SERIE, D2_COD ,D2_EMISSAO AS EMISSAO, D2_CLIENTE AS CLIENTE, D2_TES AS TES, D2_VALBRUT AS TOTAL "
	cQuery += "FROM	SF2010 (NOLOCK) INNER JOIN SD2010 (NOLOCK)"
	cQuery += "ON		F2_FILIAL	=		D2_FILIAL			AND"
	cQuery += "F2_DOC				=		D2_DOC				AND"
	cQuery += "F2_SERIE				=		D2_SERIE			AND"
	cQuery += "F2_CLIENTE			=		D2_CLIENTE"
	cQuery += "INNER JOIN SA1010"
	cQuery += "ON		F2_CLIENTE	=		A1_COD				AND"
	cQuery += "F2_LOJA				=		A1_LOJA"
	cQuery += "WHERE	D2_FILIAL	=	"+ SM0->M0_CODFIL +"	AND"
	cQuery += "D2_DOC BETWEEN			"+ MV_PAR01 +"		AND"
	cQuery += "							"+ MV_PAR02 +"		AND"
	cQuery += "D2_SERIE				=	"+ MV_PAR03 +"		AND"
	cQuery += "D2_EMISSAO BETWEEN		"+ MV_PAR04 +"		AND"
	cQuery += "							"+ MV_PAR05 +"		AND"
	cQuery += "D2_CLIENTE BETWEEN		"+ MV_PAR06 +"		AND"
	cQuery += "							"+ MV_PAR07
	cQuery += "ORDER BY F2_EMISSAO      "
	
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TRB", .F., .T.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O tratamento dos parametros deve ser feito dentro da logica do seu  ³
//³ relatorio. Geralmente a chave principal e a filial (isto vale prin- ³
//³ cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ³
//³ meiro registro pela filial + pela chave secundaria (codigo por exem ³
//³ plo), e processa enquanto estes valores estiverem dentro dos parame ³
//³ tros definidos. Suponha por exemplo o uso de dois parametros:       ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³ Assim o processamento ocorrera enquanto o codigo do registro posicio³
//³ nado for menor ou igual ao parametro mv_par02, que indica o codigo  ³
//³ limite para o processamento. Caso existam outros parametros a serem ³
//³ checados, isto deve ser feito dentro da estrutura de laço (WHILE):  ³
//³                                                                     ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³ mv_par03 -> Considera qual estado?                                  ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³     If A1_EST <> mv_par03                                           ³
//³         dbSkip()                                                    ³
//³         Loop                                                        ³
//³     Endif                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
If TRB->F2_DOC <> ""
  TRB->(dbGoTop())
	
	cData := TRB->F2_EMISSAO
	
	
	While !TRB->(EOF())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			DbCloseArea("TRB")
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			If MV_PAR08 == 2
				
				Cabec2 := ""
				
			Else
				
				Cabec1 := Cabec2
				Cabec2 := ""
				
			Endif
			
			Cabec( Titulo, Cabec1,Cabec2, NomeProg, Tamanho, nTipo )
			nLin := 8
			
			@nLin, 00 PSAY "Emissão :" + convData(TRB->F2_EMISSAO)
			nLin++
			nLin++
		Endif
		
		If MV_PAR08 == 2
			
			If cData <> TRB->F2_EMISSAO
				nLin++
				
				@nLin, 00 PSAY "Total Registros: " + cValToChar(nCont)
				
				nLin++
				nLin++
				
				@nLin, 00 PSAY "Valor Total _______________________________________________________ R$" + transform(nTotal ,"@E 999,999.99")
				
				nLin++
				
				@nLin, 00 PSAY "_________________________________________________________________________________"
				
				nLin++
				nLin++
				
				cData  := TRB->F2_EMISSAO
				nTotal := 0
				nConta := 0
				
				nLin++
				
				@nLin, 00 PSAY "Emissão :" + convData(TRB->F2_EMISSAO)
				
				nLin++
				nLin++
				
			Endif
			
			@nLin, 00 PSAY  TRB->D2_TES							// Tes
			@nLin, 12 PSAY  TRB->F2_DOC							// NF
			@nLin, 27 PSAY  TRB->F2_CLIENTE + " - " + TRB->A1_NREDUZ	// Cliente
			//@nLin, 46 PSAY  convData(TRB->D2_EMISSAO)						// Data Emissão
			@nLin, 62 PSAY  "R$" + transform(TRB->F2_VALBRUT,"@E 999,999.99")// Valor
			
			nTotal += F2_VALBRUT
			nCont  += 1
			nLin++
			
			
		Endif
		
		nLin := nLin ++ // Avanca a linha de impressao
		
		TRB->( dbSkip( ) ) // Avanca o ponteiro do registro no arquivo
		
		//@nLin, 00 PSAY "Total Registros: " + cValToChar(nCont)
		
		//nLin++
		//nLin++
		
		//@nLin, 00 PSAY "Valor Total _______________________________________________________ R$" + transform(nTotal ,"@E 999,999.99")
		
		//nLin++
		//nLin++
		
	EndDo
	
	@nLin, 00 PSAY "Total Registros: " + cValToChar(nCont)
	
	nLin++
	nLin++
	
	@nLin, 00 PSAY "Valor Total _______________________________________________________ R$" + transform(nTotal ,"@E 999,999.99")
	
	nLin++
	
	@nLin, 00 PSAY "________________________________________________________________________________"
	
	nLin++
	nLin++
	
	dbCloseArea("TRB") 
	
Endif	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
	
	Static Function convData(cData)  // Converte a data do banco
	
		cDTConv := Substr(cData,7,2)+"/"+Substr(cData,5,2)+"/"+Substr(cData,1,4)
	
	Return cDTConv

	
	Return
