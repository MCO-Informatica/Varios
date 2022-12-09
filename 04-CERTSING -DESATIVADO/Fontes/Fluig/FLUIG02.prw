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

User Function FLUIG02


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
Private wnrel      := "FLUIG02" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg := "FLUIG02"

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
±±ºUso       ³ Programa principal                                         º±±
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

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Treinado de " ,Ctod(Space(8)),"","","","",50,.F.})
aAdd( aPar,{ 1  ,"Treinado Até" ,Ctod(Space(8)),"","","","",50,.F.})
aAdd( aPar,{ 1  ,"Criado de "	,Ctod(Space(8)),"","","","",50,.F.})
aAdd( aPar,{ 1  ,"Criado Até"	,Ctod(Space(8)),"","","","",50,.F.})
aAdd( aPar,{ 2  ,"Departamento" ,"AUDITORIA INTERNA", {"Todos","AUDITORIA INTERNA","ADMINISTRACAO DE PESSOAL","AR","ASSESSORIA DE SUPORTE OPERACIONAL","ATENDIMENTO AO CLIENTE","ATENDIMENTO SAC","CANAIS","COBRANCA","COMPRAS","COMUNICACAO E MARKETING","CONTABILIDADE","CUSTOS CANAIS","DATA CENTER","DESENVOLVIMENTO","ESTOQUE E LOGISITCA","FACILITIES","FINANCEIRO","FISCAL E TRIBUTARIO","GESTAO ICP-BRASIL","INFRAESTRUTURA TI","INTELIGENCIA DE MERCADO","JURIDICO","LICITACAO","OPERACOES","PLANEJAMENTO FINANCEIRO","POSTO","PRODUTOS E SERVICOS","PROJETOS ESPECIAIS","QUALIDADE","R & S / T & D","SEGURANCA","SISTEMAS CORPORATIVOS","SUPORTE ADMINISTRATIVO DE VENDAS","TESOURARIA","VALIDACAO SSL","VENDAS CORPORATIVAS","VENDAS DIRETAS","VICE-PRESIDENCIA EXECUTIVA"}, 100,'.T.',.T.})
//aAdd( aPar,{ 1, 'Valor Prod.',0,"@E 9,999.99",,"","",20,.F.})
//aAdd( aPar,{ 1  ,"Dt. Pedido",Ctod(Space(8)),"","","","",50,.F.})

ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"FLUIG02" , .T., .F. )

/*
1-"AUDITORIA INTERNA",
2-"ADMINISTRACAO DE PESSOAL"
3-AR
4-ASSESSORIA DE SUPORTE OPERACIONAL
5-ATENDIMENTO AO CLIENTE
6-ATENDIMENTO SAC
7-CANAIS
8-COBRANCA
9-COMPRAS
10-COMUNICACAO E MARKETING
11-CONTABILIDADE
12-CUSTOS CANAIS
13-DATA CENTER
14-DESENVOLVIMENTO
15-ESTOQUE E LOGISITCA
16-FACILITIES
17-FINANCEIRO
18-FISCAL E TRIBUTARIO
19-GESTAO ICP-BRASIL
20-INFRAESTRUTURA TI
21-INTELIGENCIA DE MERCADO
22-JURIDICO
23-LICITACAO
24-OPERACOES
25-PLANEJAMENTO FINANCEIRO
26-POSTO
27-PRODUTOS E SERVICOS
28-PROJETOS ESPECIAIS
29-QUALIDADE
30-R & S / T & D
31-SEGURANCA
32-SISTEMAS CORPORATIVOS
33-SUPORTE ADMINISTRATIVO DE VENDAS
34-TESOURARIA
35-VALIDACAO SSL
36-VENDAS CORPORATIVAS
37-VENDAS DIRETAS
38-VICE-PRESIDENCIA EXECUTIVA
*/

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
cQuery := " SELECT RA_EMAIL, CTT_DESC01 RA_DESCCC, QB_DESCRIC RA_DDEPTO FROM PROTHEUS.SRA010 SRA "
cQuery += " LEFT JOIN PROTHEUS.CTT010 CTT ON CTT_FILIAL = ' ' AND CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN PROTHEUS.SQB010 SQB ON QB_FILIAL = ' ' AND QB_DEPTO = RA_DEPTO AND SQB.D_E_L_E_T_ = ' ' "
cQuery += " Where "
cQuery += " RA_SITFOLH != 'D' AND SRA.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery)
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

cQuery := " SELECT documentId "
cQuery += "       ,version "
cQuery += "       ,TO_CHAR(dateExecuted) dateExecuted "
cQuery += "       ,tenantId "
cQuery += "       ,TO_CHAR(DT_APROVACAO) DT_APROVACAO "
cQuery += "       ,TO_CHAR(DT_CRIACAO)  DT_CRIACAO "
cQuery += "       ,DS_PRINCIPAL_DOCUMENTO "
cQuery += "       ,DATA_VALUE "
cQuery += "       ,USER_CODE "
cQuery += "       ,NOME "
cQuery += "       ,EMAIL "
cQuery += "       ,USER_STATE "
cQuery += " FROM DOCUMENT "
cQuery += " WHERE "
cQuery += " DT_APROVACAO > TO_DATE('01/01/2001','DD/MM/YYYY') "

//Filtro data do treinamento
If !Empty(aRet[1])
	cQuery += " AND dateExecuted Between TO_DATE('" + DtoC(aRet[1]) + "','DD/MM/YYYY') And TO_DATE('" + DtoC(aRet[2]) + "','DD/MM/YYYY') "
EndIf

//Filtro data da criação
If !Empty(aRet[3])
	cQuery += " AND DT_CRIACAO Between TO_DATE('" + DtoC(aRet[3]) + "','DD/MM/YYYY') And TO_DATE('" + DtoC(aRet[4]) + "','DD/MM/YYYY') "
EndIf

//Filtro departamento
//Renato Ruy - 31/05/2016
//Retirado Filtro - Passara a utilizar do Protheus
//If Valtype(aRet[5]) == "N"
//	cQuery += " AND UPPER(DATA_VALUE) LIKE '%AUDITORIA INTERNA%' "
//ElseIf aRet[5] != "Todos"
//	cQuery += " AND UPPER(DATA_VALUE) LIKE '%" + UPPER(ALLTRIM(aRet[5])) + "%' "
//EndIf

//cQuery += " Group by tenantId, DS_PRINCIPAL_DOCUMENTO ,DATA_VALUE, USER_CODE, NOME ,USER_STATE "
cQuery += " ORDER BY DS_PRINCIPAL_DOCUMENTO, NOME "

//cQuery := ChangeQuery(cQuery) "

If Select("QCRPR060") > 0
	QCRPR060->(DbCloseArea())
EndIf

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),"QCRPR060", .F., .T.)

DbSelectArea("QCRPR060")
dbGoTop()

Cabec1 := PadR("Id Docto"	  ,15," ")
Cabec1 += PadR("Versão"        ,12," ")
Cabec1 += PadR("Desc.Docto"    ,43," ")
Cabec1 += PadR("Nome"		  ,40," ")
Cabec1 += PadR("Departamento"  ,30," ")
Cabec1 += PadR("Dt.Criação"    ,17," ")
Cabec1 += PadR("Dt.Aprovação"  ,17," ")
Cabec1 += PadR("Dt.Treinamento",17," ")

aAdd(_aDados, 	{   "Id Documento",;
"Versão",;
"Desc.Documento",;
"Nome",;
"Departamento",;
"Dt.Criação",;
"Dt.Aprovação",;
"Dt.Treinamento";
})

While !EOF("QCRPR060")
	
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
	If TMPSRA->(DbSeek(UPPER(AllTrim(QCRPR060->EMAIL))))
		cDepto  := TMPSRA->DEPTO
	EndIf
	
	If UPPER(ALLTRIM(aRet[5])) $ UPPER(cDepto) .OR. UPPER(ALLTRIM(aRet[5])) == "TODOS"
	
		cImpLin := PadR(AllTrim(Str(QCRPR060->documentId))	,15," ")
		cImpLin += PadR(AllTrim(Str(QCRPR060->version))		,12," ")
		cImpLin += PadR(QCRPR060->DS_PRINCIPAL_DOCUMENTO	,40," ") + Space(3)
		cImpLin += PadR(QCRPR060->NOME						,40," ")
		cImpLin += PadR(cDepto								,30," ")
		cImpLin += PadR(QCRPR060->DT_CRIACAO				,17," ")
		cImpLin += PadR(QCRPR060->DT_APROVACAO				,17," ")
		cImpLin += PadR(QCRPR060->dateExecuted				,17," ")
		
		@nLin,00 PSAY cImpLin
		
		aAdd(_aDados, 	{   AllTrim(Str(QCRPR060->documentId)),;
		AllTrim(Str(QCRPR060->version)) ,;
		QCRPR060->DS_PRINCIPAL_DOCUMENTO,;
		QCRPR060->NOME					,;
		cDepto							,; 
		QCRPR060->DT_CRIACAO			,;
		QCRPR060->DT_APROVACAO			,;
		QCRPR060->dateExecuted			})
		
		nLin := nLin + 1 // Avanca a linha de impressao
	
	EndIf

	DbSelectArea("QCRPR060")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

// AADD(aCabec, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
AADD(aCabec, {"Id Docto" 	,"C", 15, 0})
AADD(aCabec, {"Versão" 		,"C", 12, 0})
AADD(aCabec, {"Desc.Docto" 	,"C", 143, 0})
AADD(aCabec, {"Nome" 		,"C", 40, 0})
AADD(aCabec, {"Departamento","C", 30, 2})
//AADD(aCabec, {"Dt.Criação"	,"C", 17, 0})
//AADD(aCabec, {"Dt.Aprovação","C", 17, 0})
//AADD(aCabec, {"Dt.Treinamento","C",17,0})

//Gera Excel
processa({||DlgToExcel({ {"ARRAY","Doctos. Fluig", aCabec,_aDados} }) }, "Exp. Treinamentos","Aguarde, exportando para Excel...",.T.)

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