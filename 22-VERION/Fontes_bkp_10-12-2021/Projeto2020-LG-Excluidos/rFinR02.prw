
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ RFINR02 	³ Autor ³ Fernando Macieira     ³ Data ³ 07.Mar.07³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Receber (FINR130) em EXCEL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico Verion                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFINR02()

Local cDesc1 		:= "Imprime a posi‡„o dos titulos a receber relativo a data ba-"
Local cDesc2 		:= "se do sistema."
Local cDesc3 		:= ""
Local wnrel
Local cString		:= "SE1"
Local nRegEmp		:= SM0->(RecNo())
Local dOldDtBase 	:= dDataBase  
Local _nvlrt := 0 
Local _nvlrpro :=0


Private titulo  	:=	""
Private 				cabec1 := 	 "Codigo Nome do Cliente      Prf-Numero    TP     Natureza  Data de   Vencto    Vencto   Banco  Valor Original |        Titulos Vencidos          | Titulos a Vencer |    Num     Vlr.juros ou  Dias   Historico     "
Private 				cabec2 :=	 "                            Parcela                        Emissao   Titulo     Real                          |  Valor Nominal   Valor Corrigido |   Valor Nominal  |    Banco    permanencia  Atraso               "
//     								     XXXXXX-XX-XXXXXXXXXXXXXXXXX XXX-XXXXXX-X [XXX]  XXXXXXXXXXXX/XX/XX  XX/XX/XX  XX/XX/XX  XXX X  999,999,999.99   999,999,999.99    999,999,999.99    999,999,999.99    XXXXXXXXXX 9,999,999.99  9999
//	           	      							  10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//            							  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Private n_colx    := {          0,                          28,        42,43,46 , 49,     59,     69,      79,        89,       96,               113,              131,                   149,       167,           178,    192 }
//             							1                           2           3 4  5     6       7       8        9          10       11                  12                 13                    14         15             16      17
Private aLinha  	:=	{}
Private aReturn 	:=	{ "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private cPerg	 	:=	"FINR02    "
Private nJuros  	:=	0
Private nLastKey	:=	0
Private nomeprog	:=	"RFINR02"
Private tamanho 	:=	"G"
Private a_Dados	:= {}
Private a_TotCli	:= {}
Private n_lin		:= 0
Private c_Filial	 := ''
Private n_pos		:= {}

Aadd(n_pos, {01,06}) // Filial
Aadd(n_pos, {02,06}) // Codigo do Vend1
Aadd(n_pos, {03,40}) // Descricao do Canal
Aadd(n_pos, {04,06}) // Tipo Financeiro
Aadd(n_pos, {05,06}) // Codigo do Cliente
Aadd(n_pos, {06,04}) // Loja
Aadd(n_pos, {07,08}) // CGC - Primeira parte
Aadd(n_pos, {08,15}) // CGC - Digito Verificador
Aadd(n_pos, {09,40}) // Nome do Cliente
Aadd(n_pos, {10,04}) // Tipo
Aadd(n_pos, {11,08}) // Natureza
Aadd(n_pos, {12,07}) // Prefixo
Aadd(n_pos, {13,08}) // Numero
Aadd(n_pos, {14,08}) // Parcela
Aadd(n_pos, {15,15}) // Data de Emissao
Aadd(n_pos, {16,14}) // Data de Vencto
Aadd(n_pos, {17,12}) // Data do Vencto Real
Aadd(n_pos, {18,18}) // Valor Original
Aadd(n_pos, {19,18}) // Valor Nominal
Aadd(n_pos, {20,08}) // Portador
Aadd(n_pos, {21,08}) // Situaca
Aadd(n_pos, {22,50}) // Numero do Bordero
Aadd(n_pos, {23,10}) // Numero do Banco
Aadd(n_pos, {24,50}) // Historico
Aadd(n_pos, {25,32}) // Telefone do Cliente
Aadd(n_pos, {26,50}) // Endereco
Aadd(n_pos, {27,30}) // Cidade
Aadd(n_pos, {28,06}) // Estado
Aadd(n_pos, {29,15}) // CEP
Aadd(n_pos, {30,18}) // Valor Corrigido
Aadd(n_pos, {31,10}) // Valor dos Juros
Aadd(n_pos, {32,12}) // Dias de atraso
Aadd(n_pos, {33,18}) // PROTESTO
Aadd(n_pos, {34,18}) // VALOR TOTAL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "Posicao dos Titulos a Receber"

ValidPerg()
//Nao retire esta chamada. Verifique antes !!!
//Ela é necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

If !pergunte("FINR02",.T.)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:="RFINR02"            //Nome Default do relatorio em Disco
aOrd := {}

If MV_PAR40 == 1
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
EndIf

If MV_PAR40 = 1
	Processa({|lEnd| FA130Imp(@lEnd, cString, wnrel)},titulo)  // Chamada do Relatorio
Else
	Processa({|lEnd| FA130Imp(@lEnd,cString, wnrel)},titulo)  // Chamada do Relatorio
EndIf

SM0->(dbGoTo(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
If mv_par22 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif

If Len(a_Dados) == 0
	msgAlert("Nenhum registro foi selecionado... Verifique os parâmetros!")
	msgAlert("O arquivo não será gerado!")
Else
	Processa({|lEnd| GeraTXT(wnrel)}, "Gerando TXT...")
EndIf

oExcelApp := msExcel():New()
oExcelApp:SetVisible(.t.)

Return


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Static Function GeraTXT(wnrel)
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Local a_Texto		:= {}
Local n_col			:= 0
Local c_EOL			:= chr(13)+chr(10)
Local c_Cabec		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pergunta o nome do arquivo a ser exportado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IncProc("Processando dados")
PROCREGUA( len(a_Dados)/2)

cMask := "Arquivos tipo 'txt' (*.txt) |*txt| Arquivos tipo(*.csv) |*csv"
cpatharqu := cGetFile(	"Arquivos Texto|*.TXT|Todos os Arquivos|*.*",;
OemToAnsi("Selecione o diretório de gravação do arquivo "+Alltrim(wnrel)+".txt"),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY)
cpatharqu := Alltrim(cpatharqu)+wnrel+".txt"

If !Empty(cpatharqu)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o arquivo existe³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If File(AllTrim(cpatharqu))
		If !MsgYesNo("O arquivo selecionado já existe. Deseja continuar?","Arquivo ja existe")
			Return
		EndIf
	EndIf
	
	If Rat('\', cpatharqu) = len(cpatharqu)
		cpatharqu += 'RFINR02.txt'
	EndIF
	
	a_Texto := Array(len(a_Dados))
	
	For n_lin := 1 to len(a_Dados)
		a_Texto[n_lin] := ''
		For n_col := 1 to len(a_Dados[1])
			a_Texto[n_lin] += SubStr(a_Dados[n_lin, n_col]+Space(n_pos[n_col,2]),1,n_pos[n_col,2]) + Iif(n_col = len(a_Dados[1]), "", ";")
		Next
		INCPROC()
		a_Texto[n_lin] += c_EOL
	Next
	
	IncProc("Gravando Arquivo")
	PROCREGUA( len(a_Dados)/2)
	
	nHandle	:=	MSFCREATE(cpatharqu)
	
	c_Cabec := "Filial;Vendedor1;Nome do Vendedor1           ;Comissao Vendedor1 ;Codigo;Loja;CNPJ/CPF;Digito CPF/CNPJ;Nome                                    ;Tipo;Natureza;Prefixo;Numero  ; Parcela;Data de Emissao; Vencto Titulo; Vencto Real;    Valor Original;     Valor Nominal;Portador;Situacao;Bordero ; Numero Banco; Historico                                        ;Telefone              ;Endereco                                          ;Cidade                        ;Estado;CEP            ;   Valor Corrigido;     Juros; Dias Atraso; Protesto; Valor Total" + c_EOL
	//		c_Cabec := "Filial;Vendedor1;Nome do Vendedor1           ;Código;Loja;CNPJ/CPF;Digito CPF/CNPJ;Nome                                    ;Tipo;Natureza;Prefixo;Número  ; Parcela;Data de Emissão; Vencto Título; Vencto Real;    Valor Original;     Valor Nominal;Portador;Situação;Bordero ; Num Banco; Historico                                        ;Telefone              ;Endereço                                          ;Cidade                        ;Estado;CEP            ;   Valor Corrigido;     Juros; Dias Atraso" + c_EOL
	FWrite (nHandle, c_Cabec, Len(c_Cabec))
	
	For n_lin := 1 To (Len (a_Texto))
		FWrite (nHandle, a_Texto[n_lin], Len(a_Texto[n_lin]))
		INCPROC()
	Next
	
	FClose(nHandle)
	msgAlert("O arquivo foi gerado com sucesso!")
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA130Imp ³ Autor ³ Paulo Boschetti		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime relat¢rio dos T¡tulos a Receber						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA130Imp(lEnd,cString,WnRel)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock				    					  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 									  ³±±
±±³			 ³ cString - Mensagem													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA130Imp(lEnd,cString,WnRel)

Local nTit0			:= 0
Local nTit1			:= 0
Local nTit2			:= 0
Local nTit3			:= 0
Local nTit4			:= 0
Local nTit5			:= 0
Local nTotJ			:= 0
Local nTot0			:= 0
Local nTot1			:= 0
Local nTot2			:= 0
Local nTot3			:= 0
Local nTot4			:= 0
Local nSaldo		:= 0
Local nAtraso		:= 0
Local nTotTit		:= 0
Local nAbatim 		:= 0
Local nTotJur		:= 0
Local nTotFil0		:= 0
Local nTotFil1		:= 0
Local nTotFil2		:= 0
Local nTotFil3		:= 0
Local nTotFil4		:= 0
Local nTotFilJ		:= 0
Local nTotAbat		:= 0
Local nMesTit0 	:= 0
Local nMesTit1 	:= 0
Local nMesTit2 	:= 0
Local nMesTit3		:= 0
Local nMesTit4 	:= 0
Local nMesTTit 	:= 0
Local nMesTitj 	:= 0
Local nTotFilTit	:= 0
Local lContinua 	:= .T.
Local dDataAnt 	:= dDataBase
Local cTipos  		:= ""
Local lQuebra
Local nOrdem
Local CbCont
Local CbTxt
Local cCond1
Local cCond2
Local cCarAnt
Local dDataReaj
Local cIndexSe1
Local cChaveSe1
Local nIndexSE1
Local dDtContab
Local c_Cliente := ''
local c_loja	 := ''
Local a_Stru	 := {}
Local n_posCli	 := 0

Local nTotsRec := SE1->(RecCount())
Local aTamCli  := TAMSX3("E1_CLIENTE")
Local lF130Qry := ExistBlock("F130QRY")
// variavel  abaixo criada p/pegar o nr de casas decimais da moeda
Local ndecs := Msdecimais(mv_par17)
Local l_Primeiro := .T.

#IFDEF TOP
	Local aStru := SE1->(dbStruct())//, ni
#ENDIF
Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE dBaixa := dDataBase
PRIVATE cFilDe,cFilAte

nOrdem:= 1

cMoeda:=Str(mv_par17,1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt 	:= ''
cbcont	:= 1
li 		:= 80
m_pag 	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ POR MAIS ESTRANHO QUE PARE€A, ESTA FUNCAO DEVE SER CHAMADA AQUI! ³
//³                                                                  ³
//³ A fun‡„o SomaAbat reabre o SE1 com outro nome pela ChkFile para  ³
//³ efeito de performance. Se o alias auxiliar para a SumAbat() n„o  ³
//³ estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   ³
//³ pois o Filtro do SE1 uptrapassa 255 Caracteres.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SomaAbat("","","","R")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par23 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par24	// Todas as filiais
	cFilAte:= mv_par25
Endif

//Acerta a database de acordo com o parametro
If mv_par22 == 1    // Considera Data Base
	dDataBase := mv_par38
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta estrutura para geracao do arquivo temporario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aadd(a_Stru, {"FILIAL"  	, "C" , 02,0})
//	Aadd(a_Stru, {"TIPOFIN"  	, "C" , 04,0})
Aadd(a_Stru, {"COMIS1"  	, "C" , 06,0})
Aadd(a_Stru, {"CLIENTE"  	, "C" , 06,0})
Aadd(a_Stru, {"LOJA"  		, "C" , 02,0})
Aadd(a_Stru, {"NOME"  		, "C" , 40,0})
Aadd(a_Stru, {"TELEFONE"  	, "C" , 32,0})
Aadd(a_Stru, {"CGC"  		, "C" , 18,0})
Aadd(a_Stru, {"ENDERECO"  	, "C" , 45,0})
Aadd(a_Stru, {"CIDADE"  	, "C" , 15,0})
Aadd(a_Stru, {"ESTADO"  	, "C" , 02,0})
Aadd(a_Stru, {"CEP"  		, "C" , 08,0})
Aadd(a_Stru, {"PREFIXO"  	, "C" , 03,0})
Aadd(a_Stru, {"NUMERO"  	, "C" , 06,0})
Aadd(a_Stru, {"PARCELA"  	, "C" , 01,0})
Aadd(a_Stru, {"TIPO"  		, "C" , 03,0})
Aadd(a_Stru, {"NATUREZA"  	, "C" , 10,0})
Aadd(a_Stru, {"EMISSAO"  	, "D" , 08,0})
Aadd(a_Stru, {"VENCTIT"  	, "D" , 08,0})
Aadd(a_Stru, {"VENCREA"  	, "D" , 08,0})
Aadd(a_Stru, {"PORTADOR"  	, "C" , 03,0})
Aadd(a_Stru, {"SITUACAO"  	, "C" , 01,0})
Aadd(a_Stru, {"VALORIG"  	, "N" , 17,2})
Aadd(a_Stru, {"VALNOMI"  	, "N" , 17,2})
Aadd(a_Stru, {"VALCORR"  	, "N" , 17,2})
Aadd(a_Stru, {"JUROS"  		, "N" , 17,2})
Aadd(a_Stru, {"ATRASO"  	, "C" , 04,0})
Aadd(a_Stru, {"BANCO"  		, "C" , 15,0})
Aadd(a_Stru, {"HISTOR"  	, "C" , 25,0})
Aadd(a_Stru, {"COLCHETE"  	, "C" , 01,0})
Aadd(a_Stru, {"TOTALIZA"  	, "C" , 01,0})
Aadd(a_Stru, {"VEND1"     	, "C" , 06,0})
Aadd(a_Stru, {"NOMEVEND1"  	, "C" , 40,0})
Aadd(a_Stru, {"PROTESTO" 	, "N" , 17,2})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria Arquivo Temporario para filtro por total³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("TRBT") > 0
	dbSelectArea("TRBT")
	dbCloseArea()
Endif

cFile 		:= CriaTrab(a_Stru,.T.)
dbUseArea(.T.,,cFile,"TRBT",.T.,.F.)

cFileIdx	:= CriaTrab(Nil,.F.)
cKeyTRB		:= "NOME+CLIENTE+LOJA+PREFIXO+NUMERO+PARCELA+TIPO"
IndRegua("TRBT",cFileIdx,cKeyTRB,,,"Gerando")

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
	
	IncProc("Processando ")
	
	dbSelectArea("SE1")
	cFilAnt := SM0->M0_CODFIL
	Set Softseek On
	
	If mv_par21 == 1
		titulo := titulo + " - Analitico"
	Else
		titulo := titulo + " - Sintetico"
		cabec1 := "                                                                                                               |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
		cabec2 := "                                                                                                               |  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
	EndIf
	
	#IFDEF TOP
		cQuery := "  SELECT * "
		cQuery += "  FROM     "            + RetSqlName("SE1")
		cQuery += "  WHERE E1_FILIAL =  '" + xFilial("SE1") + "'"
		cQuery += "  AND D_E_L_E_T_  <> '*' "
	#ENDIF
	
	IF nOrdem = 1
		cChaveSe1 := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFDEF TOP
			cOrder := SqlOrder(cChaveSe1)
		#ELSE
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),'')
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ENDIF
		cCond1 := "SE1->E1_CLIENTE <= mv_par02"
		cCond2 := "SE1->E1_CLIENTE + SE1->E1_LOJA"
		titulo := titulo + " - Por Cliente"
		
	Elseif nOrdem = 2
		SE1->(dbSetOrder(1))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par03+mv_par05)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_NUM <= mv_par06"
		cCond2 := "E1_NUM"
		titulo := titulo + " - Por Numero"
	Elseif nOrdem = 3
		SE1->(dbSetOrder(4))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par07)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_PORTADO <= mv_par08"
		cCond2 := "E1_PORTADO"
		titulo := titulo + " - Por Banco"
	Elseif nOrdem = 4
		SE1->(dbSetOrder(7))
		#IFNDEF TOP
			dbSeek(cFilial+DTOS(mv_par09))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_VENCREA <= mv_par10"
		cCond2 := "E1_VENCREA"
		titulo := titulo + " - Por Data de Vencimento"
	Elseif nOrdem = 5
		SE1->(dbSetOrder(3))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par11)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_NATUREZ <= mv_par12"
		cCond2 := "E1_NATUREZ"
		titulo := titulo + " - Por Natureza"
	Elseif nOrdem = 6
		SE1->(dbSetOrder(6))
		#IFNDEF TOP
			dbSeek( cFilial+DTOS(mv_par13))
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_EMISSAO <= mv_par14"
		cCond2 := "E1_EMISSAO"
		titulo := titulo + " - Por Emissao"
	Elseif nOrdem == 7
		cChaveSe1 := "E1_FILIAL+DTOS(E1_VENCREA)+E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),' ')
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ELSE
			cOrder := SqlOrder(cChaveSe1)
		#ENDIF
		cCond1 := "E1_VENCREA <= mv_par10"
		cCond2 := "DtoS(E1_VENCREA)+E1_PORTADO"
		titulo := titulo + " - Por Vencto/Banco"
	Elseif nOrdem = 8
		SE1->(dbSetOrder(2))
		#IFNDEF TOP
			dbSeek(cFilial+mv_par01,.T.)
		#ELSE
			cOrder := SqlOrder(IndexKey())
		#ENDIF
		cCond1 := "E1_CLIENTE <= mv_par02"
		cCond2 := "E1_CLIENTE"
		titulo := titulo + " - Por Cod.Cliente"
	Elseif nOrdem = 9
		cChave := "E1_FILIAL+E1_PORTADO+E1_SITUACA+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,fr130IndR(),' ')
			nIndex := RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbSeek(xFilial("SE1"))
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1 := "E1_PORTADO <= mv_par08"
		cCond2 := "E1_PORTADO+E1_SITUACA"
		titulo := titulo + " - Por Banco e Situacao"
	ElseIf nOrdem == 10
		cChave := "E1_FILIAL+E1_NUM+E1_TIPO+E1_PREFIXO+E1_PARCELA"
		#IFNDEF TOP
			dbSelectArea("SE1")
			cIndex := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndex,cChave,,,' ')
			nIndex := RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbSeek(xFilial("SE1")+mv_par05)
		#ELSE
			cOrder := SqlOrder(cChave)
		#ENDIF
		cCond1 := "E1_NUM <= mv_par06"
		cCond2 := "E1_NUM"
		titulo := titulo + " - Numero/Prefixo"
	Endif
	
	If mv_par21 == 1
		titulo := titulo + " - Analitico"
	Else
		titulo := titulo + " - Sintetico"
		cabec1 := "Nome do Cliente      |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
		cabec2 := "|  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
	EndIf
	
	cFilterUser:=''
	Set Softseek Off
	
	#IFDEF TOP
		cQuery += " AND E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02 + "'"
		cQuery += " AND E1_PREFIXO between '" + mv_par03        + "' AND '" + mv_par04 + "'"
		cQuery += " AND E1_NUM     between '" + mv_par05        + "' AND '" + mv_par06 + "'"
		cQuery += " AND E1_PORTADO between '" + mv_par07        + "' AND '" + mv_par08 + "'"
		cQuery += " AND E1_VENCREA between '" + DTOS(mv_par09)  + "' AND '" + DTOS(mv_par10) + "'"
		cQuery += " AND (E1_MULTNAT = '1' OR (E1_NATUREZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'))"
		cQuery += " AND E1_EMISSAO between '" + DTOS(mv_par13)  + "' AND '" + DTOS(mv_par14) + "'"
		cQuery += " AND E1_LOJA    between '" + mv_par26        + "' AND '" + mv_par27 + "'"
		cQuery += " AND E1_EMISSAO <=      '" + DTOS(dDataBase) + "'"
		cQuery += " AND ((E1_EMIS1  Between '"+ DTOS(mv_par29)+"' AND '"+DTOS(mv_par30)+"') OR E1_EMISSAO Between '"+DTOS(mv_par29)+"' AND '"+DTOS(mv_par30)+"')"
		If !Empty(mv_par33) // Deseja imprimir apenas os tipos do parametro 31
			cQuery += " AND E1_TIPO IN "+FormatIn(mv_par33,";")
		ElseIf !Empty(Mv_par34) // Deseja excluir os tipos do parametro 32
			cQuery += " AND E1_TIPO NOT IN "+FormatIn(Mv_par34,";")
		EndIf
		If mv_par20 == 2
			cQuery += " AND E1_SITUACA NOT IN ('2','7')"
		Endif
		If mv_par22 == 2
			cQuery += ' AND E1_SALDO <> 0'
		Endif
		If mv_par36 == 1
			cQuery += " AND E1_FLUXO <> 'N'"
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para inclusao de parametros no filtro a ser executado ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lF130Qry
			cQuery += ExecBlock("F130QRY",.f.,.f.)
		Endif
		
		cQuery += " ORDER BY "+ cOrder
		
		cQuery := ChangeQuery(cQuery)
		
		memoWrite("rfinr02.sql", cQuery)
		
		dbSelectArea("SE1")
		dbCloseArea()
		dbSelectArea("SA1")
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	#ENDIF
	
	PROCREGUA( nTotsRec )
	
	If MV_MULNATR .And. nOrdem == 5
		Finr135(cTipos, lEnd, @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ )
		#IFDEF TOP
			dbSelectArea("SE1")
			dbCloseArea()
			ChKFile("SE1")
			dbSelectArea("SE1")
			dbSetOrder(1)
		#ENDIF
		If Empty(xFilial("SE1"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		Loop
	Endif
	
	While &cCond1 .and. !Eof() .and. lContinua .and. E1_FILIAL == xFilial("SE1")
		
		IF	lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		INCPROC("Processando ")
		
		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
		
		dbSelectArea("SE1")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega data do registro para permitir ³
		//³ posterior analise de quebra por mes.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dDataAnt := Iif(nOrdem == 6 , SE1->E1_EMISSAO,  SE1->E1_VENCREA)
		
		cCarAnt := &cCond2
		
		While &cCond2==cCarAnt .and. !Eof() .and. lContinua .and. E1_FILIAL == xFilial("SE1")
			
			IF lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIF
			
			INCPROC()
			
			dbSelectArea("SE1")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtrar com base no Pto de entrada do Usuario...             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄJose Lucas, Localiza‡”es ArgentinaÄÙ
			If !Empty(cTipos)
				If !(SE1->E1_TIPO $ cTipos)
					SE1->(dbSkip())
					Loop
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cFilterUser).and.!(&cFilterUser)
				SE1->(dbSkip())
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se titulo, apesar do E1_SALDO = 0, deve aparecer ou ³
			//³ nÆo no relat¢rio quando se considera database (mv_par22 = 1) ³
			//³ ou caso nÆo se considere a database, se o titulo foi totalmen³
			//³ te baixado.																  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE1")
			IF !Empty(SE1->E1_BAIXA) .and. Iif(mv_par22 == 2 ,SE1->E1_SALDO == 0 ,;
				IIF(MV_PAR39 == 1,(SE1->E1_SALDO == 0 .and. SE1->E1_BAIXA <= dDataBase),.F.))
				SE1->(dbSkip())
				Loop
			EndIF
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se trata-se de abatimento ou somente titulos³
			//³ at‚ a data base. 									         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF (SE1->E1_TIPO $ MVABATIM .And. mv_par35 != 1) .Or.;
				SE1->E1_EMISSAO>dDataBase
				SE1->(dbSkip())
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ser  impresso titulos provis¢rios		   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF E1_TIPO $ MVPROVIS .and. mv_par18 == 2
				SE1->(dbSkip())
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ser  impresso titulos de Adiantamento	   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. mv_par28 == 2
				SE1->(dbSkip())
				Loop
			Endif
			
			// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
			dDtContab := Iif(Empty(SE1->E1_EMIS1),SE1->E1_EMISSAO,SE1->E1_EMIS1)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE1")
			IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
				SE1->E1_PREFIXO < mv_par03 .OR. SE1->E1_PREFIXO > mv_par04 .OR. ;
				SE1->E1_NUM	 	 < mv_par05 .OR. SE1->E1_NUM 		> mv_par06 .OR. ;
				SE1->E1_PORTADO < mv_par07 .OR. SE1->E1_PORTADO > mv_par08 .OR. ;
				SE1->E1_VENCREA < mv_par09 .OR. SE1->E1_VENCREA > mv_par10 .OR. ;
				SE1->E1_NATUREZ < mv_par11 .OR. SE1->E1_NATUREZ > mv_par12 .OR. ;
				SE1->E1_EMISSAO < mv_par13 .OR. SE1->E1_EMISSAO > mv_par14 .OR. ;
				dDtContab       < mv_par29 .OR. dDtContab       > mv_par30 .OR. ;
				SE1->E1_EMISSAO > dDataBase .Or. !&(fr130IndR())
				SE1->E1_LOJA    < mv_par26 .OR. SE1->E1_LOJA    > mv_par27 .OR. ;
				SE1->(dbSkip())
				Loop
			Endif
			
			If mv_par20 == 2 .and. E1_SITUACA $ "27"
				SE1->(dbSkip())
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se deve imprimir outras moedas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par32 == 2 // nao imprime
				if SE1->E1_MOEDA != mv_par17 //verifica moeda do campo=moeda parametro
					SE1->(dbSkip())
					Loop
				endif
			Endif
			
			
			dDataReaj := IIF(SE1->E1_VENCREA < dDataBase ,;
			IIF(mv_par19=1,dDataBase,E1_VENCREA),;
			dDataBase)
			
			If mv_par22 == 1	// Considera Data Base
				nSaldo :=SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par17,dDataReaj,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),MV_PAR39)
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
					nSAldo -= SE1->E1_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					nSAldo += SE1->E1_ACRESC
				Endif
			Else
				nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par17,dDataReaj,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			Endif
			
			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
					!( mv_par22 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par17,dDataReaj,SE1->E1_CLIENTE,SE1->E1_LOJA)
					If STR(nSaldo,17,2) == STR(nAbatim,17,2)
						nSaldo := 0
					ElseIf mv_par35 != 3
						nSaldo-= nAbatim
					Endif
				EndIf
			Endif
			nSaldo:=Round(NoRound(nSaldo,3),2)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Desconsidera caso saldo seja menor ou igual a zero   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nSaldo <= 0
				SE1->(dbSkip())
				Loop
			Endif
			
			dbSelectArea("SA6")
			MSSeek(cFilial+SE1->E1_PORTADO)
			dbSelectArea("SE1")
			
			IF li > 58
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				SM0->(dbGoTo(nAtuSM0))
			EndIF
			
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			
			If Type('SE1->E1_VEND1') <> "U"
				If SE1->E1_VEND1 < MV_PAR15 .or. SE1->E1_VEND1 > MV_PAR16
					SE1->(dbSkip())
					Loop
				EndIf
			EndIF
			
			Aadd(a_Dados, {'', '', '', '', '', '', '', '', '', '', '', '', '',  '', '', '', '','', '', '', '','', '', '', '', '', '', '', '', '', '', '','', ''})
			//               1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12,  13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32..
			n_lin := len(a_Dados)
			
			RecLock("TRBT", .T.)
			
			TRBT->FILIAL	:= SE1->E1_MSFIL
			TRBT->COMIS1	:= StrZero(SE1->E1_COMIS1,2)
			TRBT->CGC 		:= Iif(SA1->A1_PESSOA = "J", Transform(SA1->A1_CGC, "@R 99.999.999/9999-99"), Transform(SA1->A1_CGC, "@R 999.999.999-99") )
			TRBT->ENDERECO	:= AllTrim(SA1->A1_END) + ", " + AllTrim(SA1->A1_BAIRRO)
			TRBT->CIDADE 	:= SA1->A1_MUN
			TRBT->ESTADO 	:= SA1->A1_EST
			TRBT->CEP 		:= SA1->A1_CEP
			TRBT->CIDADE 	:= SA1->A1_MUN
			TRBT->CLIENTE 	:= SA1->A1_COD
			TRBT->LOJA 		:= SA1->A1_LOJA
			TRBT->NOME 		:= SA1->A1_NREDUZ
			TRBT->TELEFONE	:= IIF(!Empty(SA1->A1_DDI),"( "+TransForm(SA1->A1_DDI,PesqPict("SA1","A1_DDI"))+") ","")+TransForm(alltrim(SA1->A1_DDD),PesqPict("SA1","A1_DDD"))+" "+TransForm(SA1->A1_TEL,PesqPict("SA1","A1_TEL")) // Telefone
			
			//				PAQ->(dbsetorder(1))
			//				PAQ->(MsSeek(xfilial("PAQ")+SA1->A1_CANAL))
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+'01'))
			
			
			a_Dados[n_lin, n_pos[1	,1]] 	:= SE1->E1_MSFIL
			a_Dados[n_lin, n_pos[2  ,1]]  := SE1->E1_VEND1
			a_Dados[n_lin, n_pos[3  ,1]]  := Posicione("SA3",1,xFilial("SA3")+SE1->E1_VEND1,"A3_NOME")
			a_Dados[n_lin, n_pos[4	,1]]	:= StrZero(SE1->E1_COMIS1,2)
			a_Dados[n_lin, n_pos[26,1]]	:= AllTrim(SA1->A1_ENDCOB) + ", " + AllTrim(SA1->A1_BAIRROC)
			a_Dados[n_lin, n_pos[27	,1]] 	:= AllTrim(SA1->A1_MUNC)
			a_Dados[n_lin, n_pos[28	,1]] 	:= SA1->A1_ESTC
			a_Dados[n_lin, n_pos[29	,1]] 	:= SA1->A1_CEPC
			a_Dados[n_lin, n_pos[9  ,1]] 	:= SA1->A1_NOME
			a_Dados[n_lin, n_pos[25 ,1]] 	:= IIF(!Empty(SA1->A1_DDI),"( "+TransForm(SA1->A1_DDI,PesqPict("SA1","A1_DDI"))+") ","")+TransForm(alltrim(SA1->A1_DDD),PesqPict("SA1","A1_DDD"))+" "+TransForm(SA1->A1_TEL,PesqPict("SA1","A1_TEL")) // Telefone
			
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			
			a_Dados[n_lin, n_pos[7	,1]] 	:= Iif(SA1->A1_PESSOA = "J", SubStr(SA1->A1_CGC, 1,8), SubStr(SA1->A1_CGC, 1, 9))
			a_Dados[n_lin, n_pos[8	,1]]	:= Iif(SA1->A1_PESSOA = "J", substr(SA1->A1_CGC,9,4)+"-"+SubStr(SA1->A1_CGC, 13,len(SA1->A1_CGC)), SubStr(SA1->A1_CGC, 10, len(SA1->A1_CGC)))
			
			DbSelectArea("SE1")
			
			If mv_par21 == 1
				
				li := IIf (aTamCli[1] > 6,li+1,li)
				If SE1->E1_TIPO$MVABATIM
					TRBT->COLCHETE := 'S'
				Else
					TRBT->COLCHETE := 'N'
				Endif
				
				a_Dados[n_lin, n_pos[5,1] ] 	:= AllTrim(SE1->E1_CLIENTE)
				a_Dados[n_lin, n_pos[6,1]   ] 	:= SE1->E1_LOJA
				a_Dados[n_lin, n_pos[12,1] ] 	:= SE1->E1_PREFIXO
				a_Dados[n_lin, n_pos[13,1] ] 	:= SE1->E1_NUM
				a_Dados[n_lin, n_pos[14,1]]	:= SE1->E1_PARCELA
				a_Dados[n_lin, n_pos[10,1]     ]	:= SE1->E1_TIPO
				a_Dados[n_lin, n_pos[11,1]]	:= SE1->E1_NATUREZ
				a_Dados[n_lin, n_pos[15,1]]	:= DtoC(SE1->E1_EMISSAO)
				a_Dados[n_lin, n_pos[16,1] ]	:= DtoC(SE1->E1_VENCTO)
				a_Dados[n_lin, n_pos[17,1]]	:= DtoC(SE1->E1_VENCREA)
				a_Dados[n_lin, n_pos[20,1]]	:= SE1->E1_PORTADO
				a_Dados[n_lin, n_pos[21,1]]	:= SE1->E1_SITUACA
				a_Dados[n_lin, n_pos[18,1]]	:= Transform(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT, -1,1), "@E 999,999,999,999.99")
				a_Dados[n_lin, n_pos[22	,1]] 	:= SE1->E1_NUMBOR
				
				TRBT->PREFIXO		:= SE1->E1_PREFIXO
				TRBT->NUMERO		:= SE1->E1_NUM
				TRBT->PARCELA		:= SE1->E1_PARCELA
				TRBT->TIPO			:= SE1->E1_TIPO
				TRBT->NATUREZA		:= SE1->E1_NATUREZ
				TRBT->EMISSAO		:= SE1->E1_EMISSAO
				TRBT->VENCTIT		:= SE1->E1_VENCTO
				TRBT->VENCREA		:= SE1->E1_VENCREA
				TRBT->PORTADOR		:= SE1->E1_PORTADO
				TRBT->SITUACAO		:= SE1->E1_SITUACA
				TRBT->VALORIG		:= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT, -1,1)
				
				n_posCli := AScan( a_TotCli, {|x| AllTrim(x[1]) = AllTrim(SA1->A1_COD)})
				If n_posCli <> 0
					a_TotCli[n_posCli, 2] += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT, -1,1)
				Else
					Aadd(a_TotCli, { SA1->A1_COD, xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT, -1,1)})
				EndIf                                                            
				
			Endif
			
			If dDataBase > E1_VENCREA .and. E1_TIPO <> 'NCC'	//vencidos
				If mv_par21 == 1
					If ! SE1->E1_TIPO $ MVABATIM
						a_Dados[n_lin, n_pos[19,1]]	:= Transform(nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1), TM(nSaldo,14,nDecs))
						TRBT->VALNOMI := nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1)
					EndIf
				EndIf
				nJuros :=0
				_nvlrt := 0 
				_nvlrpro :=0
				fa070Juros(mv_par17)
				dbSelectArea("SE1")
				If mv_par21 == 1
					a_Dados[n_lin, n_pos[30,1]]	:= Transform((nSaldo+nJuros)* If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1), TM(nSaldo+nJuros,14,nDecs))
					 _nvlrt := (nSaldo+nJuros)* If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1)
					TRBT->VALCORR := (nSaldo+nJuros)* If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1)
				EndIf
				If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG
					nTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit1 -= (nSaldo)
					nTit2 -= (nSaldo+nJuros)
					nMesTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nMesTit1 -= (nSaldo)
					nMesTit2 -= (nSaldo+nJuros)
					nTotJur  -= nJuros
					nMesTitj -= nJuros
					nTotFilJ -= nJuros
				Else
					If !SE1->E1_TIPO $ MVABATIM
						nTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nTit1 += (nSaldo)
						nTit2 += (nSaldo+nJuros)
						nMesTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nMesTit1 += (nSaldo)
						nMesTit2 += (nSaldo+nJuros)
						nTotJur  += nJuros
						nMesTitj += nJuros
						nTotFilJ += nJuros
					Endif
				Endif
			Else						//a vencer
				If mv_par21 == 1
					If Empty(a_Dados[n_lin, n_pos[19,1]])
						a_Dados[n_lin, n_pos[19,1]]	:= Transform(nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1), TM(nSaldo,14,nDecs))
						TRBT->VALNOMI := nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1)
					EndIf
				EndIf
				If ! ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
					If !SE1->E1_TIPO $ MVABATIM
						nTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nTit3 += (nSaldo-nTotAbat)
						nTit4 += (nSaldo-nTotAbat)
						nMesTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nMesTit3 += (nSaldo-nTotAbat)
						nMesTit4 += (nSaldo-nTotAbat)
					EndIf
				Else
					nTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit3 -= (nSaldo-nTotAbat)
					nTit4 -= (nSaldo-nTotAbat)
					nMesTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par17,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nMesTit3 -= (nSaldo-nTotAbat)
					nMesTit4 -= (nSaldo-nTotAbat)
				Endif
			Endif
			
			If mv_par21 == 1
				a_Dados[n_lin, n_pos[23,1]]	:= SE1->E1_NUMBCO
				TRBT->BANCO := SE1->E1_NUMBCO
			EndIf
			If nJuros > 0
				If mv_par21 == 1
					a_Dados[n_lin, n_pos[31,1]]	:= Transform(nJuros, PesqPict("SE1","E1_JUROS",10,mv_par17))
					TRBT->JUROS := nJuros
				EndIf
				nJuros := 0
			Endif
			
			IF dDataBase > SE1->E1_VENCREA
				nAtraso:=dDataBase-SE1->E1_VENCTO
				IF Dow(SE1->E1_VENCTO) == 1 .Or. Dow(SE1->E1_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso := 0
					EndIF
				EndIF
				nAtraso:=IIF(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					If mv_par21 == 1
						a_Dados[n_lin, n_pos[32,1]]	:= Transform(nAtraso , "9999")
						TRBT->ATRASO := Transform(nAtraso , "9999")
				
                        If natraso >= 5  
                           DBSELECTAREA("SZ3")
                           DBSETORDER(1)
                           DBGOTOP()
                           While !eof()
                             if _nvlrt >= SZ3->Z3_INICIO .AND. _nvlrt <= SZ3->Z3_FINAL 
                                _nvlrpro := SZ3->Z3_VALOR
                             Endif 
                             DBSELECTAREA("SZ3") 
                             DBSKIP()
                             LOOP
                           End 
							a_Dados[n_lin, n_pos[33,1]]	:= Transform(_nvlrpro, TM(_nvlrpro,14,nDecs))                           
							a_Dados[n_lin, n_pos[34,1]]	:= Transform((_nvlrt+_nvlrpro), TM((_nvlrt+_nvlrpro),14,nDecs))                               
                        Endif
			
					EndIf
				EndIF
			EndIF
            DBSELECTAREA("SE1") 
			If mv_par21 == 1
				a_Dados[n_lin, n_pos[24,1]]	:= SubStr(SE1->E1_HIST,1,20)+ ;
				IIF(E1_TIPO $ MVPROVIS,"*"," ")+ ;
				Iif(nSaldo == xMoeda(E1_VALOR,E1_MOEDA,mv_par17,dDataReaj,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))," ","P")
				TRBT->HISTOR := SubStr(SE1->E1_HIST,1,20)+ ;
				IIF(E1_TIPO $ MVPROVIS,"*"," ")+ ;
				Iif(nSaldo == xMoeda(E1_VALOR,E1_MOEDA,mv_par17,dDataReaj,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))," ","P")
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega data do registro para permitir ³
			//³ posterior an lise de quebra por mes.   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			dDataAnt := Iif(nOrdem == 6, SE1->E1_EMISSAO, SE1->E1_VENCREA)
			c_Cliente := SE1->E1_CLIENTE
			c_Loja	 := SE1->E1_LOJA
			c_Filial	 := SE1->E1_FILIAL
			SE1->(dbSkip())
			nTotTit ++
			nMesTTit ++
			nTotFiltit++
			nTit5 ++
			If mv_par21 == 1
				li++
			EndIf
			
			IF nTit5 > 0 .and. nOrdem != 2 .and. nOrdem != 10 .and. !(&cCond2==cCarAnt .and. !Eof() .and. lContinua .and. E1_FILIAL == xFilial("SE1"))
				TRBT->TOTALIZA := 'S'
			Else
				TRBT->TOTALIZA := 'N'
			Endif
			
			TRBT->(MsUnlock())
			
		Enddo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quebra por mˆs                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lQuebra := .F.
		If nOrdem == 4  .and. (Month(SE1->E1_VENCREA) # Month(dDataAnt) .or. SE1->E1_VENCREA > mv_par10)
			lQuebra := .T.
		Elseif nOrdem == 6 .and. (Month(SE1->E1_EMISSAO) # Month(dDataAnt) .or. SE1->E1_EMISSAO > mv_par14)
			lQuebra := .T.
		Endif
		If lQuebra .and. nMesTTit # 0
			ImpMes130(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nDecs)
			nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
		Endif
		
		nTot0+=nTit0
		nTot1+=nTit1
		nTot2+=nTit2
		nTot3+=nTit3
		nTot4+=nTit4
		nTotJ+=nTotJur
		
		nTotFil0+=nTit0
		nTotFil1+=nTit1
		nTotFil2+=nTit2
		nTotFil3+=nTit3
		nTotFil4+=nTit4
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur,nTotAbat
	Enddo
	
	dbSelectArea("SE1")		// voltar para alias existente, se nao, nao funciona
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver mais do que 1 filial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Store 0 To nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ
	If Empty(xFilial("SE1"))
		Exit
	Endif
	
	#IFDEF TOP
		dbSelectArea("SE1")
		dbCloseArea()
		ChKFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	#ENDIF
	
	dbSelectArea("SM0")
	dbSkip()
Enddo

DbSelectArea("TRBT")
DbSetOrder(1)
TRBT->(DbGotop())

c_Filial 	:= ""
c_Cliente	:= ""
c_Loja 		:= ""
li 			:= 80
nTotsRec 	:= TRBT->(RecCount())

IncProc("Imprimindo...")
PROCREGUA( nTotsRec )

Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur, nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,;
nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFiltit,nTotFilJ

While TRBT->(!EOF())
	
	INCPROC()
	
	n_posCli := AScan( a_TotCli, {|x| AllTrim(x[1]) = AllTrim(TRBT->CLIENTE)})
	/*
	If n_posCli>0 .and. (MV_PAR26 > a_TotCli[n_posCli, 2] .or. MV_PAR27 < a_TotCli[n_posCli, 2])
	TRBT->(DbSkip())
	Loop
	EndIf
	*/
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	
	If (c_Cliente <> TRBT->CLIENTE .or. c_Loja <> TRBT->LOJA) .and. !l_Primeiro
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+c_Cliente+c_Loja)
		
		SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)
		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
		If c_Filial = TRBT->FILIAL
			li++
			@li,	0 PSAY  Replicate("-", 225)
		EndIf
		If mv_par21 == 1
			Li++
		EndIf
	Endif
	
	/*		If c_Filial <> TRBT->FILIAL
	li++
	
	If mv_par23 == 1 .and. !l_Primeiro
	li++
	@li,	0 PSAY  Replicate("-", 225)
	li++
	ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFiltit,nTotFilJ,nDecs)
	Store 0 To nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFiltit,nTotFilJ
	li++
	Endif
	
	If !l_Primeiro
	@li,	0 PSAY  Replicate("_", 225)
	li++
	@li,	0 PSAY  " "
	li++
	EndIf
	If !l_Primeiro
	li++
	@li,	0 PSAY  " "
	li++
	EndIf
	@li,	0 PSAY  "--> Filial :" + TRBT->FILIAL
	li++
	@li,	0 PSAY  " "
	li++
	EndIF
	*/
	If nOrdem = 1 .and. (c_Cliente <> TRBT->CLIENTE .or. c_Loja <> TRBT->LOJA)
		li++
		@li,	0 PSAY  " "
		li++
		@li,	0 PSAY  "Cliente :" + TRBT->CLIENTE + " - " + TRBT->LOJA  + "  " + TRBT->NOME +;
		"   Tel.: " + TRBT->TELEFONE +;
		"   CNPJ/CPF :" + TRBT->CGC +;
		"   Endereço :" + AllTrim(TRBT->ENDERECO) + " " + AllTrim(TRBT->CIDADE) + " - " + TRBT->ESTADO
		li++
		@li,	0 PSAY  " "
		li++
		l_Primeiro := .F.
	EndIf
	
	@li,n_colx[1] PSAY TRBT->CLIENTE + "-" + TRBT->LOJA + "-" +SubStr( TRBT->NOME, 1, 17 )
	li := IIf (aTamCli[1] > 6,li+1,li)
	@li, n_colx[2] PSAY TRBT->PREFIXO+"-"+TRBT->NUMERO+"-"+TRBT->PARCELA
	If TRBT->COLCHETE = 'S'
		@li,n_colx[3] PSAY "["
	Endif
	@li, n_colx[4] PSAY TRBT->TIPO
	If TRBT->COLCHETE = 'S'
		@li,n_colx[5] PSAY "]"
	Endif
	
	@li,n_colx[06] PSAY TRBT->NATUREZA
	@li,n_colx[07] PSAY TRBT->EMISSAO
	@li,n_colx[08] PSAY TRBT->VENCTIT
	@li,n_colx[09] PSAY TRBT->VENCREA
	@li,n_colx[10] PSAY TRBT->PORTADOR +" "+TRBT->SITUACAO
	@li,n_colx[11] PSAY Transform(TRBT->VALORIG, "@E 999,999,999.99")
	@li,n_colx[12] PSAY Transform(TRBT->VALNOMI, "@E 999,999,999.99")
	@li,n_colx[13] PSAY Transform(TRBT->VALCORR, "@E 999,999,999.99")
	@li,n_colx[14] PSAY Transform(TRBT->VALNOMI, "@E 999,999,999.99")
	@li,n_colx[15] PSAY TRBT->BANCO
	@Li,n_colx[16] PSAY Transform(TRBT->JUROS,"@E 9,999,999.99")
	@li,n_colx[17] PSAY TRBT->ATRASO
	@li,200 PSAY   TRBT->HISTOR
	
	nTit1 	+= TRBT->VALORIG
	nTit2 	+= TRBT->VALNOMI
	nTit3 	+= TRBT->VALCORR
	nTit4 	+= TRBT->VALNOMI
	nTotJur 	+= TRBT->JUROS
	nTotTit++
	nTot1  	+= TRBT->VALORIG
	nTot2  	+= TRBT->VALNOMI
	nTot3		+= TRBT->VALCORR
	nTot4		+= TRBT->VALNOMI
	nTotJ		+= TRBT->JUROS
	nTotFiltit++
	nTotFil1 += TRBT->VALORIG
	nTotFil2 += TRBT->VALNOMI
	nTotFil3 += TRBT->VALCORR
	nTotFil4	+= TRBT->VALNOMI
	nTotFilJ	+= TRBT->JUROS
	
	li++
	nTit5++
	
	c_Filial 	:= TRBT->FILIAL
	c_Cliente	:= TRBT->CLIENTE
	c_Loja 		:= TRBT->LOJA
	
	TRBT->(DbSkip())
	
EndDo

//	If mv_par23 == 1 .and. SM0->(Reccount()) > 1
//		ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFiltit,nTotFilJ,nDecs)
//	Endif

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL
IF li != 80
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)
	Roda(cbcont,cbtxt,"G")
EndIF

Set Device To Screen

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndexSE1)
		FErase (cIndexSE1+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	dbSetOrder(1)
#ENDIF

If MV_PAR40 = 1
	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		Ourspool(wnrel)
	Endif
	MS_FLUSH()
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot130 ³ Autor ³ Paulo Boschetti 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprimir SubTotal do Relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot130()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	    ³ Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)

LOCAL aSituaca := {"Carteira","Simples",;
"Descontada","Caucionada","Vinculada",;
"Advogado","Judicial","Cauc Desc"}

DEFAULT nDecs := Msdecimais(mv_par17)

If mv_par21 == 1
	li++
EndIf

IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

If nOrdem = 1
	@li,000 PSAY IIF(mv_par31 == 1,SA1->A1_NREDUZ,SA1->A1_NOME)+" "+SA1->A1_DDD+"-"+SA1->A1_TEL+ " "+ "Loja - " + Right(cCarAnt,2)+Iif(mv_par23==1," Filial - "+cFilAnt,"")
Elseif nOrdem == 4 .or. nOrdem == 6
	@li,000 PSAY "S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt
	@li,PCOL()+2 PSAY Iif(mv_par23==1,cFilAnt,"  ")
Elseif nOrdem = 3
	@li,000 PSAY "S U B - T O T A L ----> "
	@li,028 PSAY Iif(Empty(SA6->A6_NREDUZ),"Carteira",SA6->A6_NREDUZ) + " " + Iif(mv_par23==1,cFilAnt,"")
ElseIf nOrdem == 5
	dbSelectArea("SED")
	dbSeek(cFilial+cCarAnt)
	@li,000 PSAY "S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt + " "+ED_DESCRIC + " " + Iif(mv_par23==1,cFilAnt,"")
	dbSelectArea("SE1")
Elseif nOrdem == 7
	@li,000 PSAY "S U B - T O T A L ----> "
	@li,028 PSAY SubStr(cCarAnt,7,2)+"/"+SubStr(cCarAnt,5,2)+"/"+SubStr(cCarAnt,3,2)+" - "+SubStr(cCarAnt,9,3) + " " +Iif(mv_par23==1,cFilAnt,"")
ElseIf nOrdem = 8
	@li,000 PSAY SA1->A1_COD+" "+SA1->A1_NOME+" "+SA1->A1_DDD+"-"+SA1->A1_TEL + " " + Iif(mv_par23==1,cFilAnt,"")
ElseIf nOrdem = 9
	@li,000 PSAY SubStr(cCarant,1,3)+" "+SA6->A6_NREDUZ + SubStr(cCarant,4,1) + " "+aSituaca[Val(SubStr(cCarant,4,1))+1] + " " + Iif(mv_par23==1,cFilAnt,"")
Endif
If mv_par21 == 1
Endif
@li,n_colx[11] PSAY nTit1		  Picture "@E 999,999,999.99"
@li,n_colx[12] PSAY nTit2		  Picture "@E 999,999,999.99"
@li,n_colx[13] PSAY nTit3		  Picture "@E 999,999,999.99"
If nTotJur > 0
	@li,n_colx[16] PSAY nTotJur  Picture "@E 9,999,999.99"
Endif
@li,204 PSAY nTit2+nTit3 Picture TM(nTit2+nTit3,16,nDecs)
If (nOrdem = 1 .Or. nOrdem == 8) .And. mv_par37 == 1 // Salta pag. por cliente
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
Endif

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TotGer130³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ TotGer130()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par17)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

@li,000 PSAY "T O T A L   G E R A L ---->   "
@li,028 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,"TITULOS","TITULO")+")"
@li,n_colx[11] PSAY nTot1		  Picture TM(nTot1,14,nDecs)
@li,n_colx[12] PSAY nTot2		  Picture TM(nTot2,14,nDecs)
@li,n_colx[13] PSAY nTot3		  Picture TM(nTot3,14,nDecs)
@li,n_colx[16] PSAY nTotJ		  Picture TM(nTotJ,12,nDecs)
@li,204 PSAY nTot2+nTot3 Picture TM(nTot2+nTot3,16,nDecs)
li++
li++

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpMes130 ³ Autor ³ Vinicius Barreira	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpMes130() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpMes130(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par17)
li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY "T O T A L   D O  M E S ---> "
@li,028 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,"TITULOS","TITULO")+")"
If mv_par21 == 1
	@li,101 PSAY nMesTot0   Picture TM(nMesTot0,14,nDecs)
Endif
@li,116 PSAY nMesTot1	Picture TM(nMesTot1,14,nDecs)
@li,133 PSAY nMesTot2	Picture TM(nMesTot2,14,nDecs)
@li,149 PSAY nMesTot3	Picture TM(nMesTot3,14,nDecs)
@li,179 PSAY nMesTotJ	Picture TM(nMesTotJ,12,nDecs)
@li,204 PSAY nMesTot2+nMesTot3 Picture TM(nMesTot2+nMesTot3,16,nDecs)
li+=2

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ImpFil130³ Autor ³ Paulo Boschetti  	  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpFil130()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	    ³ Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par17)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY "T O T A L   F I L I A L ----> " + " "+Iif(mv_par23==1,c_Filial,"")
@li,n_colx[11] PSAY nTotFil1        Picture TM(nTotFil1,14,nDecs)
@li,n_colx[12] PSAY nTotFil2        Picture TM(nTotFil2,14,nDecs)
@li,n_colx[13] PSAY nTotFil3        Picture TM(nTotFil3,14,nDecs)
@li,n_colx[16] PSAY nTotFilJ		  Picture TM(nTotFilJ,12,nDecs)
@li,204 PSAY nTotFil2+nTotFil3 Picture TM(nTotFil2+nTotFil3,16,nDecs)
li+=2

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fr130Indr ³ Autor ³ Wagner           	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fr130IndR()

Local cString

cString := 'E1_FILIAL=="'+xFilial("SE1")+'".And.'
cString += 'E1_CLIENTE>="'+mv_par01+'".and.E1_CLIENTE<="'+mv_par02+'".And.'
cString += 'E1_PREFIXO>="'+mv_par03+'".and.E1_PREFIXO<="'+mv_par04+'".And.'
cString += 'E1_NUM>="'+mv_par05+'".and.E1_NUM<="'+mv_par06+'".And.'
cString += 'DTOS(E1_VENCREA)>="'+DTOS(mv_par09)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par10)+'".And.'
cString += '(E1_MULTNAT == "1" .OR. (E1_NATUREZ>="'+mv_par11+'".and.E1_NATUREZ<="'+mv_par12+'")).And.'
cString += 'DTOS(E1_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(E1_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par33) // Deseja imprimir apenas os tipos do parametro 31
	cString += '.And.E1_TIPO$"'+mv_par33+'"'
ElseIf !Empty(Mv_par34) // Deseja excluir os tipos do parametro 32
	cString += '.And.!(E1_TIPO$'+'"'+Mv_par34+'")'
EndIf
IF mv_par36 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(E1_FLUXO!="N")'
Endif

Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PutDtBase³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 18/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acerta parametro database do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr130.prx                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PutDtBase()

Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("FINR1036")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()
Endif

dbSelectArea(_sAlias)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ValidPerg º Autor ³ Alexandre Martins  º Data ³  25/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01"  ,"Do Cliente                "	,""      ,""     ,"MV_CH1","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"CLI"})
aAdd(aRegs,{cPerg,"02"  ,"Ate o Cliente             "	,""      ,""     ,"MV_CH2","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR02",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"CLI"})
aAdd(aRegs,{cPerg,"03"  ,"Do Prefixo                "	,""      ,""     ,"MV_CH3","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR03",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"04"  ,"Ate o prefixo             "	,""      ,""     ,"MV_CH4","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR04",""         			,""      ,""      ,""   ,""         ,""            		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"05"  ,"Do Titulo                 "	,""      ,""     ,"MV_CH5","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR05",""         			,""      ,""      ,""   ,""         ,""            		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"06"  ,"Ate o Titulo              "	,""      ,""     ,"MV_CH6","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR06",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"07"  ,"Do Banco                  "	,""      ,""     ,"MV_CH7","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR07",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"BCO"})
aAdd(aRegs,{cPerg,"08"  ,"Ate o Banco               "	,""      ,""     ,"MV_CH8","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR08",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"BCO"})
aAdd(aRegs,{cPerg,"09"  ,"Do Vencimento             "	,""      ,""     ,"MV_CH9","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR09",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"10"  ,"Ate o Vencimento          "	,""      ,""     ,"MV_CHA","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR10",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""            	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"11"  ,"Da Natureza               "	,""      ,""     ,"MV_CHB","C"    ,10      ,0       ,0     ,"G" ,""    ,"MV_PAR11",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SED"})
aAdd(aRegs,{cPerg,"12"  ,"Ate a Natureza            "	,""      ,""     ,"MV_CHC","C"    ,10      ,0       ,0     ,"G" ,""    ,"MV_PAR12",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SED"})
aAdd(aRegs,{cPerg,"13"  ,"Da Emissao                "	,""      ,""     ,"MV_CHD","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR13",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"14"  ,"Ate a Emissao             "	,""      ,""     ,"MV_CHE","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR14",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"15"  ,"Do Vendedor1              "	,""      ,""     ,"MV_CHF","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR15",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SA3"})
aAdd(aRegs,{cPerg,"16"  ,"Ate Vendedor1             "	,""      ,""     ,"MV_CHG","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR16",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SA3"})
aAdd(aRegs,{cPerg,"17"  ,"Qual Moeda                "	,""      ,""     ,"MV_CHH","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par17","Moeda 1"  			,""      ,""      ,""   ,""         ,"Moeda 2"      		,""      ,""      ,""    ,""        ,"Moeda 3"      	,""      ,""     ,""     ,""       ,"Moeda 4"      ,""      ,""      ,""    ,""        ,"Moeda 5"     ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"18"  ,"Imprime provisorios       "	,""      ,""     ,"MV_CHI","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par18","Sim"      			,""      ,""      ,""   ,""         ,"Nao"          		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"19"  ,"Converte Venci pela       "	,""      ,""     ,"MV_CHJ","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par19","Data Base"			,""      ,""      ,""   ,""         ,"Data de Vencto"		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"20"  ,"Impr Tit em Descont       "	,""      ,""     ,"MV_CHK","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par20","Sim"      			,""      ,""      ,""   ,""         ,"Nao"          		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"21"  ,"Imprime Relatorio         "	,""      ,""     ,"MV_CHL","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par21","Analitico"			,""      ,""      ,""   ,""         ,"Sintetico"    		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"22"  ,"Compoe Saldo Retroativo?  "	,""      ,""     ,"MV_CHM","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par22","Sim"      			,""      ,""      ,""   ,""         ,"Nao"         		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"23"  ,"Consid Filiais abaixo?    "	,""      ,""     ,"MV_CHO","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par23","Sim"      			,""      ,""      ,""   ,""         ,"Nao"          		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"24"  ,"Da filial                 "	,""      ,""     ,"MV_CHP","C"    ,02      ,0       ,0     ,"G" ,""    ,"mv_par24",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"25"  ,"Ate flial                 "	,""      ,""     ,"MV_CHQ","C"    ,02      ,0       ,0     ,"G" ,""    ,"mv_par25",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
//	aAdd(aRegs,{cPerg,"26"  ,"Total de?                 "	,""      ,""     ,"MV_CHR","N"    ,20      ,2       ,0     ,"G" ,""    ,"MV_PAR26",""	            	,""      ,""      ,""   ,""         ,""	   				,""      ,""      ,""    ,""        ,""					,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
//	aAdd(aRegs,{cPerg,"27"  ,"Total ate?                "	,""      ,""     ,"MV_CHS","N"    ,20      ,2       ,0     ,"G" ,""    ,"MV_PAR27",""	            	,""      ,""      ,""   ,""         ,""   					,""      ,""      ,""    ,""        ,""					,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"26"  ,"Da loja                   "	,""      ,""     ,"MV_CHR","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR26",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"27"  ,"Ate a loja                "	,""      ,""     ,"MV_CHS","C"    ,02      ,0       ,0     ,"G" ,""    ,"mv_par27",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"28"  ,"Consid Adiantam.?         "	,""      ,""     ,"MV_CHT","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par28","Sim"      			,""      ,""      ,""   ,""         ,"Nao"          		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"29"  ,"Da data contab. ?         "	,""      ,""     ,"MV_CHU","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR29",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"30"  ,"Ate data contab.?         "	,""      ,""     ,"MV_CHV","D"    ,08      ,0       ,0     ,"G" ,""    ,"mv_par30",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"31"  ,"Imprime Nome    ?         "	,""      ,""     ,"MV_CHX","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par31","Nome Reduzido"	,""      ,""      ,""   ,""         ,"Razao Social"  		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"32"  ,"Outras Moedas   ?         "	,""      ,""     ,"MV_CHY","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par32","Converter"			,""      ,""      ,""   ,""         ,"Nao Imprimir"  		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"33"  ,"Imprimir os Tipos         "	,""      ,""     ,"MV_CHZ","C"    ,40      ,0       ,0     ,"G" ,""    ,"mv_par33",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"34"  ,"Nao Imprimir Tipos        "	,""      ,""     ,"MV_CHW","C"    ,40      ,0       ,0     ,"G" ,""    ,"Mv_par34",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"35"  ,"Abatimentos               "	,""      ,""     ,"MV_CHa","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par35","Listar"   			,""      ,""      ,""   ,""         ,"Nao Listar"    		,""      ,""      ,""    ,""        ,"Nao Considerar"	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"36"  ,"Somente Tit p/ Fluxo?     "	,""      ,""     ,"MV_CHb","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par36","Sim"         		,""      ,""      ,""   ,""         ,"Nao"           		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"37"  ,"Salta pagina p/ Cliente   "	,""      ,""     ,"MV_CHc","N"    ,01      ,0       ,0     ,"C" ,""    ,"mv_par37","Sim"      			,""      ,""      ,""   ,""         ,"Nao"          		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"38"  ,"Data Base                 "	,""      ,""     ,"MV_CHd","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR38",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"39"  ,"Compoe Saldo por:         "	,""      ,""     ,"MV_CHe","N"    ,01      ,0       ,0     ,"C" ,""    ,"MV_PAR39","Data da Baixa"	,""      ,""      ,""   ,""         ,"Data de Credito"	,""      ,""      ,""    ,""        ,"Data Digitacao"	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"40"  ,"Mostra Relatório?         "	,""      ,""     ,"MV_CHf","N"    ,01      ,0       ,0     ,"C" ,""    ,"MV_PAR40","Sim"	         	,""      ,""      ,""   ,""         ,"Nao"					,""      ,""      ,""    ,""        ,""					,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf
Next

DbSelectArea(_sAlias)

Return Nil
