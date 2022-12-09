#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³RPMSR02   ³Autor  ³Cosme da Silva Nunes   ³Data  ³28/01/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Programa p/ imprimir o relatorio de projetos                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³PMS                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            |          |                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RPMSR02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de Variaveis                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Projetos"
Local cPict         := ""
Local titulo       	:= "Projetos"
Local nLin         	:= 80
Local Cabec1       	:= "Projeto                                      Indice de Natalidade  MW         Gestor                Valor Previsto      Valor Real          Data de Inicio  Data Entrega Aneel  Data de Inic.Real  Data Entrega Aneel Real  "
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 			:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nTipo       := 18
Private aReturn     := {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private cPerg       := PADR("PMSR02", LEN(SX1->X1_GRUPO)) //nome da pegunta do grupo de perguntas
Private nomeprog    := FunName() // Nome do programa para impressao no cabecalho
Private wnrel      	:= FunName() // Nome do arquivo usado para impressao em disco
Private cString 	:= "AF8" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a interface padrao com o usuario...                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento. RptStatus monta janela com a regua de processamento.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³RunReport ³Autor  ³Cosme da silva Nunes   ³Data  ³20/05/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao auxiliar chamada pela RptStatus. A funcao RptStatus  ³±±
±±³          ³monta a janela com a regua de processamento.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³nomeprog                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            |          |                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query da tabela AF8 - Projetos                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT "
cQuery += " AF8_PROJET, AF8_DESCRI, AF8_XTIPO, AF8_GESTOR, AF8_INDNAT, AF8_MW, AF8_RD, AF8_DIPR, AF8_DEAP, AF8_DIR, AF8_DEAR, AF8_VORAPR, AF8_VRACUM "
cQuery += " FROM " + RetSqlName("AF8") + " AF8 "
cQuery += " WHERE "
cQuery += " AF8_FILIAL = '" + xFilial("AF8") + "'"
If Mv_Par01 <> 3 //Ambos
	cQuery +=	" AND 	AF8_XTIPO  = '"+If(Mv_Par01==1,"PB","INV")+"' "
EndIf
cQuery += " AND 	AF8_PROJET >= '" + Mv_Par02       + "' AND AF8_PROJET <= '" + Mv_Par03+"'"
cQuery += " AND 	AF8_GESTOR >= '" + Mv_Par04       + "' AND AF8_GESTOR <= '" + Mv_Par05+"'"
cQuery += " AND 	AF8_INDNAT >= '" + Mv_Par06       + "' AND AF8_INDNAT <= '" + Mv_Par07+"'"
cQuery += " AND 	AF8_MW     >= '" + Mv_Par08       + "' AND AF8_MW     <= '" + Mv_Par09+"'"
cQuery += " AND 	AF8_RD     >= '" + Mv_Par10       + "' AND AF8_RD     <= '" + Mv_Par11+"'"
cQuery += " AND 	AF8_DIPR   >= '" + Dtos(Mv_Par12) + "' AND AF8_DIPR   <= '" + Dtos(Mv_Par13)+"'"
cQuery += " AND 	AF8_DEAP   >= '" + Dtos(Mv_Par14) + "' AND AF8_DEAP   <= '" + Dtos(Mv_Par15)+"'"
cQuery += " AND 	AF8_DIR    >= '" + Dtos(Mv_Par16) + "' AND AF8_DIR    <= '" + Dtos(Mv_Par17)+"'"
cQuery += " AND 	AF8_DEAR   >= '" + Dtos(Mv_Par18) + "' AND AF8_DEAR   <= '" + Dtos(Mv_Par19)+"'"
cQuery += " AND 	D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY 	AF8_PROJET "
cQuery := ChangeQuery(cQuery)
MemoWrit(FunName()+".TXT",cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'QUERY',.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QUERY")
dbGoTop()
If Eof()
	Aviso("Atenção!","Nenhum registro selecionado",{"OK"})
	QUERY->(Dbclosearea())
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|                                                                     ³
//³Inicio da logica de impressao do programa...                         ³
//|                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !EOF()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o cancelamento pelo usuario...                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao do cabecalho do relatorio...                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin++
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Lay-out do relatorio                                                                                                                                                                                                        |
	//|0                                                                                                   1                                                                                                   2                   |
	//|0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         |
	//|0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789|
	//|Posicao do conteudo da variavel Cabec1                                                                                                                                                                                      |
	//|Projeto                                      Indice de Natalidade  MW         Gestor                Valor Previsto      Valor Real          Data de Inicio  Data Entrega Aneel  Data de Inic.Real  Data Entrega Aneel Real  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                                                                                                                                                                                                        
	@nLin, 00 PSay SubStr(QUERY->AF8_DESCRI,1,40)
	@nLin, 45 PSay QUERY->AF8_INDNAT
	@nLin, 67 PSay QUERY->AF8_MW
	@nLin, 78 PSay SubStr(QUERY->AF8_GESTOR,1,20)
	@nLin,100 PSay QUERY->AF8_VORAPR 	Picture "@E 999,999,999.99"
	@nLin,120 PSay QUERY->AF8_VRACUM 	Picture "@E 999,999,999.99"
	@nLin,140 PSay QUERY->AF8_DIPR
	@nLin,156 PSay QUERY->AF8_DEAP
	@nLin,176 PSay QUERY->AF8_DIR
	@nLin,195 PSay QUERY->AF8_DEAR

	nLin := nLin + 1 // Avanca a linha de impressao
	QUERY->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

roda(cbcont,cbtxt,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finaliza a execucao do relatorio...                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

QUERY->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se impressao em disco, chama o gerenciador de impressao...           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³ValidPerg ³Autor  ³Cosme da Silva Nunes   ³Data  ³28/01/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Cria Pergunta no SX1                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³nomeprog                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local aRegs := {}
//Estrutura {Grupo	/Ordem	/Pergunta				/Pergunta Espanhol		/Pergunta Ingles   		/Variavel	/Tipo	/Tamanho	/Decimal	/Presel	/GSC	/Valid	/Var01		/Def01		/DefSpa1	/DefEng1	/Cnt01	/Var02	/Def02		/DefSpa2	/DefEng2	/Cnt02	/Var03	/Def03	/DefSpa3	/DefEng3	/Cnt03	/Var04	/Def04	/DefSpa4	/DefEng4	/Cnt04	/Var05	/Def05	/DefSpa5	/DefEng5	/Cnt05	/F3		/PYME	/GRPSX6	/HELP	}
Aadd(aRegs,{cPerg	,"01"	,"Tipo	"				,"Tipo"					,"Tipo"			   		,"mv_ch1"	,"N"	, 1			,0			,0		,"C"	,""		,"mv_par01"	,"PB"		,""			,""			,""		,""		,"INV"		,""			,""			,""		,""		,"Ambos",""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"02"	,"Projeto De"			,"Projeto De"			,"Projeto De"	   		,"mv_ch2"	,"C"	,10			,0			,0		,"G"	,""		,"mv_par02"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,"AF8"	,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"03"	,"Projeto Ate"			,"Projeto Ate"	 		,"Projeto Ate"	  		,"mv_ch3"	,"C"	,10			,0			,0		,"G"	,""		,"mv_par03"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,"AF8"	,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"04"	,"Gestor De"	   		,"Gestor De"	  		,"Gestor De"	   		,"mv_ch4"	,"C"	,40			,0			,0		,"G"	,""		,"mv_par04"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"05"	,"Modulo Ate"	   		,"Modulo Ate"	  		,"Modulo Ate"	   		,"mv_ch5"	,"C"	,40			,0			,0		,"G"	,""		,"mv_par05"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"06"	,"Ind.Natal. De"   		,"Ind.Natal.De"	   		,"Ind.Natal. De"   		,"mv_ch6"	,"C"	, 3			,0			,0		,"G"	,""		,"mv_par06"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"07"	,"Ind.Natal. Ate" 		,"Ind.Natal. Ate" 		,"Ind.Natal. Ate"  		,"mv_ch7"	,"C"	, 3			,0			,0		,"G"	,""		,"mv_par07"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"08"	,"MW De"		   		,"MW De"		 		,"MW De"		  		,"mv_ch8"	,"C"	,10			,0			,0		,"G"	,""		,"mv_par08"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"09"	,"MW Ate"		  		,"MW Ate"		 		,"MW Ate" 		   		,"mv_ch9"	,"C"	,10			,0			,0		,"G"	,""		,"mv_par09"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"10"	,"RD De"		   		,"RD De"		   		,"RD De"		   		,"mv_cha"	,"C"	,10			,0			,0		,"G"	,""		,"mv_par10"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"11"	,"RD Ate"		   		,"RD Ate"		  		,"RD Ate"		   		,"mv_chb"	,"C"	,10			,0			,0		,"G"	,""		,"mv_par11"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"12"	,"Dt.In.Prev. De"  		,"Dt.In.Prev. De" 		,"Dt.In.Prev. De"  		,"mv_chc"	,"D"	, 8			,0			,0		,"G"	,""		,"mv_par12"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"13"	,"Dt.In.Prev. Ate" 		,"Dt.In.Prev. Ate"		,"Dt.In.Prev. Ate" 		,"mv_chd"	,"D"	, 8			,0			,0		,"G"	,""		,"mv_par13"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"14"	,"Dt.E.ANEEL Prev.De"	,"Dt.E.ANEEL Prev.De"	,"Dt.E.ANEEL Prev.De"	,"mv_che"	,"D"	, 8			,0			,0		,"G"	,""		,"mv_par14"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"15"	,"Dt.E.ANEEL Prev.Ate"	,"Dt.E.ANEEL Prev.Ate"	,"Dt.E.ANEEL Prev.Ate"	,"mv_chf"	,"D"	, 8			,0			,0		,"G"	,""		,"mv_par15"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"16"	,"Dt.In.Real. De"  		,"Dt.In.Real De" 		,"Dt.In.Real De"  		,"mv_chg"	,"D"	, 8			,0			,0		,"G"	,""		,"mv_par16"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"17"	,"Dt.In.Real. Ate" 		,"Dt.In.Real Ate"		,"Dt.In.Real Ate" 		,"mv_chh"	,"D"	, 8			,0			,0		,"G"	,""		,"mv_par17"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"18"	,"Dt.E.ANEEL Real De"	,"Dt.E.ANEEL Real De"	,"Dt.E.ANEEL Real De"	,"mv_chi"	,"D"	, 8			,0			,0		,"G"	,""		,"mv_par18"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"19"	,"Dt.E.ANEEL Real Ate"	,"Dt.E.ANEEL Real Ate"	,"Dt.E.ANEEL Real Ate"	,"mv_chj"	,"D"	, 8			,0			,0		,"G"	,""		,"mv_par19"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		})

lValidPerg( aRegs )

Return