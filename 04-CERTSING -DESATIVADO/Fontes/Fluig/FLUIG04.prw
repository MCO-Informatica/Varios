#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO7     º Autor ³ AP6 IDE            º Data ³  17/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FLUIG04


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 58

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 58
Private tamanho          := "G"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FLUIG04" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg := "FLUIG04"

Private cString := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  17/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fluig - Controle de Treinamentos                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem
Local cDBOra 	:= GetNewPar("MV_FLUIGB","ORACLE/FLUIG_PRD")
Local cSrvOra := GetNewPar("MV_FLUIGT", "10.130.3.133")
Local nHndOra
Local cImpLin := ""
Local aTmp    := ""
Local cTmp    := ""
Local cDepto  := ""
Local aCabec  := {}
Local _aDados := {}
Local aPar	  := {}
Local aRet	  := {}
Local bValid  := {|| .T. }
Local cDepart := ""

aAdd( aPar,{ 2  ,"Departamento" ,"AUDITORIA INTERNA", {"Todos","AUDITORIA INTERNA","ADMINISTRACAO DE PESSOAL","AR","ASSESSORIA DE SUPORTE OPERACIONAL","ATENDIMENTO AO CLIENTE","ATENDIMENTO SAC","CANAIS","COBRANCA","COMPRAS","COMUNICACAO E MARKETING","CONTABILIDADE","CUSTOS CANAIS","DATA CENTER","DESENVOLVIMENTO","ESTOQUE E LOGISITCA","FACILITIES","FINANCEIRO","FISCAL E TRIBUTARIO","GESTAO ICP-BRASIL","INFRAESTRUTURA TI","INTELIGENCIA DE MERCADO","JURIDICO","LICITACAO","OPERACOES","PLANEJAMENTO FINANCEIRO","POSTO","PRODUTOS E SERVICOS","PROJETOS ESPECIAIS","QUALIDADE","R & S / T & D","SEGURANCA","SISTEMAS CORPORATIVOS","SUPORTE ADMINISTRATIVO DE VENDAS","TESOURARIA","VALIDACAO SSL","VENDAS CORPORATIVAS","VENDAS DIRETAS","VICE-PRESIDENCIA EXECUTIVA"}, 100,'.T.',.T.})

ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"FLUIG04" , .T., .F. )

If Select("TMPSRA") > 0
	DbSelectArea("TMPSRA")
	TMPSRA->(DbCloseArea())
EndIf

//Cria arquivo de dados para controle de informações do RH.
aTmp := {{"EMAIL" 	, "C", 50, 0},;
          {"DEPTO"	, "C", 50, 0}}

cTmp := criatrab(aTmp, .t.)
dbusearea(.t., , cTmp, "TMPSRA", .f.)

IndRegua("TMPSRA", cTmp, "EMAIL", , , "Selecionando Registros...")

If Select("TMP") > 0
	DbSelectArea("TMP")
	TMP->(DbCloseArea())
EndIf

//Renato Ruy - 31/05/2016
//Será necessário buscar os dados da SRA e por isso não pode ser na mesma consulta
cQuery := " SELECT RA_EMAIL, CTT_DESC01 RA_DESCCC, QB_DESCRIC RA_DDEPTO FROM SRA010 SRA "
cQuery += " LEFT JOIN CTT010 CTT ON CTT_FILIAL = ' ' AND CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN SQB010 SQB ON QB_FILIAL = ' ' AND QB_DEPTO = RA_DEPTO AND SQB.D_E_L_E_T_ = ' ' "
cQuery += " Where "
cQuery += " RA_SITFOLH != 'D' AND SRA.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery) "
If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf
dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),"TMP", .F., .T.) 

While !TMP->(EOF())
	
	TMPSRA->(RecLock("TMPSRA",.T.))
		TMPSRA->EMAIL := UPPER(AllTrim(TMP->RA_EMAIL))
		TMPSRA->DEPTO := TMP->RA_DDEPTO
	TMPSRA->(MsUnlock()) 
	
	TMP->(DbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//Faço Conexão com o banco do Fluig.
TCConType("TCPIP")

nHndOra := TcLink(cDbOra,cSrvOra,7890)

If nHndOra < 0
	UserException("Erro ("+str(nHndOra,4)+") ao conectar com "+cDbOra+" em "+cSrvOra)
Endif

cQuery := " SELECT NOME "
cQuery += "       ,EMAIL "
cQuery += "       ,COUNT(*) QUANT "
cQuery += " FROM DOCUMENT "
cQuery += " WHERE "
cQuery += " dateExecuted is null "
cQuery += " GROUP BY NOME, EMAIL "
cQuery += " ORDER BY NOME, EMAIL "

cQuery := ChangeQuery(cQuery) "

If Select("FLUIG04") > 0
	FLUIG04->(DbCloseArea())
EndIf

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),"FLUIG04", .F., .T.)

DbSelectArea("FLUIG04")
dbGoTop()

Cabec1 := PadR("Nome"		  ,40," ")
Cabec1 := PadR("Departamento" ,40," ")
Cabec1 += PadR("Quantidade"   ,15," ")

aAdd(_aDados, 	{   "Nome",;
					"Departamento",;
					"Quantidade"})

While !EOF("FLUIG04")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
    
    cDepto := ""
    
	TMPSRA->(DbSetOrder(1))
	If TMPSRA->(DbSeek(UPPER(AllTrim(FLUIG04->EMAIL))))
		cDepto  := TMPSRA->DEPTO
	EndIf
	
	If UPPER(ALLTRIM(aRet[1])) $ UPPER(cDepto) .OR. UPPER(ALLTRIM(aRet[1])) == "TODOS"

		cImpLin := PadR(FLUIG04->NOME						,40," ")
		cImpLin := PadR(cDepto								,40," ")
		cImpLin += PadR(AllTrim(Str(FLUIG04->QUANT))		,17," ")
		
		@nLin,00 PSAY cImpLin
		
		aAdd(_aDados, 	{   FLUIG04->NOME					,;
							cDepto							,;
							FLUIG04->QUANT					})
		
		nLin := nLin + 1 // Avanca a linha de impressao
    EndIf
	
	DbSelectArea("FLUIG04")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

// AADD(aCabec, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
AADD(aCabec, {"Nome" 		,"C", 40, 0})
AADD(aCabec, {"Departamento","C", 40, 0})
AADD(aCabec, {"Quantidade"  ,"C", 15, 2})

//Gera Excel
processa({||DlgToExcel({ {"ARRAY","Doctos. Fluig", aCabec,_aDados} }) }, "Exp. Treinamento Pendentes","Aguarde, exportando para Excel...",.T.)

TcUnlink(nHndOra)

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

Return