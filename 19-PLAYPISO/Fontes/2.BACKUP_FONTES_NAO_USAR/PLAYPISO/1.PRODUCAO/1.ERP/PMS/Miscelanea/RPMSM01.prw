#include "rwmake.ch"
#include 'MsOle.ch'
#include 'TopConn.ch'            
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³RPMSM01   ³Autor  ³Cosme da Silva Nunes   ³Data  ³13/11/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Programa para impressao das propostas comerciais Lisonda /  ³±±
±±³          ³Playpiso via integracao com o Microsoft Word.               ³±±
±±³          ³Este programa recebe o codigo do orcamento desejado e lista ³±±
±±³          ³sua respectiva estrutura / valores.                         ³±±
±±³          ³Arquivos MODELOS do MS Word: Lisonda.dot e                  ³±±
±±³          ³                             Playpiso.dot                   ³±±
±±³          ³Caminho:                     \Protheus_Data\IntMsWord       ³±±
±±³          ³Macros dos arquivos: - Lisonda.dot: OrcLis()                ³±±
±±³          ³                     - Playpiso.dot: OrcPlay()              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Gestao de Projetos                                          ³±±
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
User Function RPMSM01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpca 	:= 0
Local aSays 	:= {}, aButtons := {}
Local aCRA		:=	{ "Parametros", "Modelo Documento" , "Confirma" , "Abandona" }
Local cCadastro := "Impressao da Proposta Comercial"
Local lContinua	:= .T.
Private cArqDot := ""  // Nome do Arquivo MODELO do Word

Private _dDate := Date()

cPerg	:= "PMSM01"
ValidPerg()
Pergunte(cPerg,.T.)

Aadd(aSays, "Rotina para impressao das propostas comerciais" )
Aadd(aSays, "via integracao Microsoft Word" )
Aadd(aSays, "" )
Aadd(aSays, "" )

Aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
Aadd(aButtons, { 1,.T.,{|| nOpca:= 1, FechaBatch() }} )
Aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons,,240,405 )
	
If	nOpca != 1
	Return( Nil )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe a filial de origem na variavel, pois o xFilial nao pega        ³
//³ dentro da QUERY                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("AF8")
	ucFilAF8 := xFilial("AF8")
dbSelectArea("AFC")
	ucFilAFC := xFilial("AFC")	
dbSelectArea("AF9")
	ucFilAF9 := xFilial("AF9")		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona o Projeto / EDTs / Tarefas                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
ucQuery := "SELECT 	AF8_PROJET  "
ucQuery += "  FROM " +	RetSqlName("AF8") + " AF8, "
ucQuery += 			  	RetSqlName("AFC") + " AFC "
ucQuery += 			  	RetSqlName("AF9") + " AF9 "
ucQuery += " WHERE 	AF8_PROJET = AFC_PROJET"
ucQuery += "    AND AFC_PROJET = AF9_PROJET"
ucQuery += "   	AND AF8_FILIAL = '"+ucFilAF8+"'"
ucQuery += "   	AND	AFC_FILIAL = '"+ucFilAFA+"'"
ucQuery += "   	AND	AF9_FILIAL = '"+ucFilAFA+"'"
ucQuery += "   	AND AF8_PROJET = '"+Mv_Par01+"'"
ucQuery += "   	AND AF8.D_E_L_E_T_ <> '*'"
ucQuery += "   	AND AFC.D_E_L_E_T_ <> '*'"
ucQuery += "   	AND AF9.D_E_L_E_T_ <> '*'"
ucQuery := ChangeQuery(ucQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,ucQuery), 'QUERY', .F., .T.) /*
/*	A  T  E  N  C  A  O  !  !  !
	Esse comando nao funciona neste programa!	
	TcSetField("QUERY","XXX_DATA","D",8)
*/
/*
dbSelectArea("QUERY")
dbGotop()
If EOF()
 Aviso( "Atencao","Nao ha registros para o codigo informado." ,{"Ok"})
 lContinua := .F.
 QUERY->( dbCloseArea() )
EndIf
*/
If	lContinua
	Processa({|lEnd| WordImp() })
EndIf

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³WordImp   ³Autor  ³Cosme da Silva Nunes   ³Data  ³13.11.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function WordImp()

SetPrvt("ucNome,ucEnd,ucCEP,ucCidade,ucUF,ucTel,ucEmail,ucObra,ucContato,ucProjet,ucDescPrj,ucAllAF9")
SetPrvt("ucDscConc")
Private _nVlrTtl 	:= 0;	_nVlrRet	:= 0;	_nVlrDscRet := 0
Private unCntLin		:= 0; 	unCntCol 	:= 0
//Private unCntLin2 	:= 0; 	unCntCol2 	:= 0 
Private unTotalAFC := 0
Private ucDescrAF9 := 0 
Private unTotal := 0
Private _cData 		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preparacao para integracao                                            ³
//³ Carrega variaveis / sincroniza modelo via Macro                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dbSelectArea("QUERY")
//dbGotop()

dbSelectArea("AF8")
dbSetOrder(1)
If dbSeek(xFilial("AF8")+AllTrim(MV_PAR01))

	If SubStr(cNumEmp,3,2) == "01" .Or. SubStr(cNumEmp,3,2) == "03"
		cArqDot := "Lisonda.dot"
	Else
		cArqDot := "Playpiso.dot"
	EndIf
	
	unCntLin  := 0
	unCntCol  := 0
//	unCntLin2 := 0
//	unCntCol2 := 0
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                                       ³ 
	//³ Carrega variaveis para integracao                                     ³
	//³                                                                       ³ 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//CABECALHO DO ARQUIVO .DOT
	ucNome		:= AllTrim(Posicione("SA1",1,xFilial("SA1")+AF8->AF8_CLIENT,"A1_NOME"))
	ucEnd		:= AllTrim(SA1->A1_END)
	ucBairro	:= AllTrim(SA1->A1_BAIRRO)
	ucConc2		:= 	ucEnd+" "+ucBairro
	ucCEP		:= ALLTRIM(SA1->A1_CEP)
	ucCidade	:= AllTrim(SA1->A1_MUNC)
	ucUF		:= AllTrim(SA1->A1_EST)
	ucConc3		:= ucCEP+" "+ucCidade+" "+ucUF
	ucTel		:= AllTrim(SA1->A1_TEL)
	ucEmail		:= AllTrim(SA1->A1_EMAIL)
	ucObra		:= AllTrim(SA1->A1_OBRA)
	//ucContato	:= AllTrim(Posicione("AC8",1,"SA1"+xFilial("SA1")+SA1->A1_COD,"U5_EMAIL"))
	ucProjet	:= AF8->AF8_PROJET
	ucDescrPrj	:= AF8->AF8_DESCRI

	//DETALHE DO ARQUIVO .DOT


	//RODAPE DO ARQUIVO .DOT
	ucVendedor 	:= ""

	//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
	//ºIncia integracao                                                       º
	//ºCopia arquivo .dot do servidor para maquina local                      º
	//º                                                                       º
	//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
	CpyS2T( "\IntMsWord\"+cArqDot, "C:\" )
	cArqWord := "C:\"+cArqDot
	
	hWord := OLE_CreateLink("TMSOLEWORD97")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Abre arquivo .dot na maquina do usuario                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_OpenFile( hWord , cArqWord, .T. )  // Abro arquivo da maquina local
	OLE_SetPropertie( hWord, oleWdPrintBack	, .F.)
	OLE_SetPropertie( hWord, oleWdVisible	, .T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega as variaveis do cabecalho no demonstrativo do Word             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_SetDocumentVar(hWord, "Nome"		, ucNome		)
	OLE_SetDocumentVar(hWord, "End"			, ucEnd			)
	OLE_SetDocumentVar(hWord, "Bairro"		, ucBairro		)
	OLE_SetDocumentVar(hWord, "Conc2"		, ucConc2		)
	OLE_SetDocumentVar(hWord, "CEP"			, ucCEP			)
	OLE_SetDocumentVar(hWord, "Cidade"		, ucCidade		)
	OLE_SetDocumentVar(hWord, "UF"			, ucUF			)
	OLE_SetDocumentVar(hWord, "Conc3"		, ucConc3		)
	OLE_SetDocumentVar(hWord, "Tel"			, ucTel			)
	OLE_SetDocumentVar(hWord, "Email"		, ucEmail		)
	OLE_SetDocumentVar(hWord, "Obra"		, ucObra		)
	OLE_SetDocumentVar(hWord, "Contato"		, ucContato		)
	OLE_SetDocumentVar(hWord, "Projeto"		, ucProjet		)
	OLE_SetDocumentVar(hWord, "DescrPrj"	, ucDescrPrj	)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³
	//³Carrega os itens do orcamento via macro do arquivo .dot               ³
	//³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona Estrutura do projeto                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("AFC")
	dbSetOrder(1)
	If dbSeek(xFilial("AFC")+ucProjet)
		While AFC->( !EOF() ) .And. (xFilial("AFC")+AFC->AFC_PROJET) == (ucFilAF8+ucProjet)
			unCntLin 	+= 1 //Incializa o contador de linhas para o objeto OLE
			unCntCol 	:= 1 //Incializa o contador de colunas para o objeto OLE
			ucDescrAFC	:= AllTrim(AFC->AFC_DESCRI) 	//Recebe descricao da EDT
			unTotalAFC 	:= AFC->AFC_TOTAL 	//Recebe valor da EDT
			unTotal		+= unTotalAFC 		//Incrementa o totalizador de EDTs
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Tarefas do projeto                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			dbSelectArea("AF9")
			dbSetOrder(1)
			If dbSeek(xFilial("AF9")+ucProjet)
				While AF9->( !EOF() ) .And. (xFilial("AF9")+AF9->AF9_PROJET) == (ucFilAF8+ucProjet)
					ucDescrAF9 	:= AllTrim(AF9->AF9_DESCRI) //+(Chr(13)+Chr(10)) //Recebe descricao da Tarefa
					ucAllAF9	=+ (" "+ucDescrAF9) //Concatena descricao das Tarefas da EDT
					dbSelectArea("AF9")
					AF9->(dbSkip())
				EndDo
			EndIf
			//Concatena a descricao da EDT com a descricao da Tarefa
			ucDscConc := (ucDescrAFC+ucAllAF9) 
			
			//Coluna 1 - Descricao
			OLE_SetDocumentVar(hWord, "DescrConc"+ AllTrim(Str(unCntLin))+AllTrim(Str(unCntCol)),;
			ucDscConc)
			unCntCol ++
			
			//Coluna 2 - Valor
			OLE_SetDocumentVar(hWord, "ValorAFC"+ AllTrim(Str(unCntLin))+AllTrim(Str(unCntCol)),;
			unTotalAFC)
			unCntCol ++		
			
			dbSelectArea("AFC")
			AFC->(dbSkip())
					
		EndDo
    EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ carrega as variaveis do rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SetDocumentVar(hWord, "ValorAFC"	, unTotal	)
OLE_SetDocumentVar(hWord, "Vendedor"	, ucVendedor	)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nr. de linhas da Tabela a ser utilizada na matriz do Word             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SubStr(cNumEmp,3,2) == "01" .Or. SubStr(cNumEmp,3,2) == "03"
	OLE_SetDocumentVar(hWord,"Adv_OrcLis"	,Str(unCntLin)	)
Else
	OLE_SetDocumentVar(hWord,"Adv_OrcPlay"	,Str(unCntLin)	)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa macro do Word                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SubStr(cNumEmp,3,2) == "01" .Or. SubStr(cNumEmp,3,2) == "03"
	OLE_ExecuteMacro(hWord,"OrcLis")
Else
	OLE_ExecuteMacro(hWord,"OrcPlay")
EndIf
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizacao das variaveis do documento do Word                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_UpdateFields(hWord)

If MsgYesNo("Imprime a proposta comercial p/ o orcamento" + ucProjet + "?" )
	Ole_PrintFile(hWord,'ALL',,,mv_par02) //N. de copias
EndIf

//Fecha o Word e Corta o Link
OLE_CloseFile( hWord )
OLE_CloseLink( hWord )

dbSelectArea("AF8")
AF8->(dbCloseArea())

Return(Nil)
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ValidPerg ºAutor  ³Cosme da Silva NunesºData  ³13.11.2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                              							  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local aRegs   := {}

cPerg := PADR(cPerg,10)
//			Grupo 	/Ordem	/Pergunta				/Pergunta Espanhol	/Pergunta Ingles	/Variavel	/Tipo	/Tamanho	/Decimal/Presel	/GSC	/Valid	/Var01		/Def01	/DefSpa1/DefEng1/Cnt01	/Var02	/Def02	/DefSpa2/DefEng2/Cnt02	/Var03	/Def03	/DefSpa3/DefEng3/Cnt03	/Var04	/Def04	/DefSpa4/DefEng4/Cnt04	/Var05	/Def05	/DefSpa5/DefEng5/Cnt05	/F3		/GRPSX6
Aadd(aRegs,{cPerg	,"01"	,"Orcamento ?"			,""					,""					,"mv_ch1"	,"C"	,10			,00		,0		,"G"	,""		,"mv_par01"	,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"AF8"	,""		})
Aadd(aRegs,{cPerg	,"02"	,"Numero de Copias ?"	,""					,""					,"mv_ch2"	,"N"	, 2			,00		,2		,"G"	,""		,"mv_par02"	,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		})

//LValidPerg( aRegs )

Return