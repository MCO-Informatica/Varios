#INCLUDE "rwmake.ch"
#Include "Protheus.ch"
#Include "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ RODRIGO ALEXANDRE  º Data ³  28/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LS_SLWMOV2


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "SlowMov - Supr."
Local cPict          := ""
Local titulo       := "SlowMoving - Suprimentos"
Local nLin         := 80

Local Cabec1       := "Material         Descrição                                 Fantasia                                  Saída  Saída  Saída    Ped.   Ped.   Ped.   Stk. Assunto"
Local Cabec2       := "                                                                                                       30     60     90      30     60     90"
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "LS_SLOWMOV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "SLWMOV"

//ValidPerg()

Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "LS_SLOWMOV" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SB1"

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  08/12/10   º±±
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


// _cQuery :="DECLARE @DATA SMALLDATETIME SET @DATA = GETDATE()
if empty(MV_PAR01)
	
	MV_PAR01 := dDataBase
	
EndIf

_cTemp1 := CriaTrab(,.f.)
_cQuery :=" SELECT DISTINCT BZ_COD INTO " + _cTemp1 + " FROM SBZ010 BZ WITH(NOLOCK) INNER JOIN SB1010 B1 WITH(NOLOCK) ON B1_COD=BZ_COD AND B1_GRUPO in ('0540', '0009') AND B1_MSBLQL=2 AND B1.D_E_L_E_T_='' "
_cQuery +=" WHERE  BZ.D_E_L_E_T_='' AND BZ_UCOM > CONVERT(VARCHAR(10),DATEADD(yy,-1,GETDATE()),112) "
TcSqlExec(_cQuery)

_cQuery :=" SELECT DENSE_RANK() OVER(ORDER BY "
_cQuery += " (SELECT SUM(D2_QUANT) FROM SD2010 D2 WITH(NOLOCK) WHERE D2_CLIENTE <= '000009' AND D2_COD=B1_COD AND D2_FILIAL IN ('55') AND D_E_L_E_T_ = '' AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR01 - 30) + "' "
_cQuery += " AND '" + DTOS(MV_PAR01) + "')		DESC, " /*30 DIAS*/
_cQuery += " (SELECT SUM(D2_QUANT) FROM SD2010 D2 WITH(NOLOCK) WHERE D2_CLIENTE <= '000009' AND D2_COD=B1_COD AND D2_FILIAL IN ('55') AND D_E_L_E_T_ = '' AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR01 - 60) + "' AND '" + DTOS(MV_PAR01 - 30) + "')	DESC, " /*60 DIAS*/
_cQuery += " (SELECT SUM(D2_QUANT) FROM  SD2010 D2 WITH(NOLOCK) WHERE D2_CLIENTE <= '000009' AND D2_COD=B1_COD AND D2_FILIAL IN ('55') AND D_E_L_E_T_ = '' AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR01 - 90) + "' AND '" + DTOS(MV_PAR01 - 60) + "')	DESC,B1_COD) " /*90 DIAS*/
_cQuery +=" 			AS 'Rank', "
_cQuery +=" B1_COD		AS 'Material', "
_cQuery +=" B1_DESC		As 'Descricao',"
_cQuery +=" B1_CODBAR	AS 'MaterialBarras', "
_cQuery +=" B1_PROC		AS 'Fornecedor', "
_cQuery +=" A2_NOME		AS 'Fantasia', "
_cQuery +=" A2_LOJA		AS 'LojaForn',"
_cQuery +=" B1_CONV		AS 'FatorConv',"
_cQuery +=" ISNULL((SELECT SUM(BZ_EMAX) FROM  SBZ010 BZ WITH(NOLOCK) WHERE BZ_COD=B1_COD	AND D_E_L_E_T_ = '' AND BZ_FILIAL IN ('55')),0) AS 'Rep_Max', "
_cQuery +=" ISNULL((SELECT SUM(D2_QUANT) FROM  SD2010 D2 WITH(NOLOCK) WHERE D2_CLIENTE <= '000009' AND D2_COD=B1_COD AND D2_FILIAL IN ('55') AND D_E_L_E_T_ = '' AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR01 - 30) + "' AND '" + DTOS(MV_PAR01) + "'),0) AS 'S_30', "
_cQuery +=" ISNULL((SELECT SUM(D2_QUANT) FROM  SD2010 D2 WITH(NOLOCK) WHERE D2_CLIENTE <= '000009' AND D2_COD=B1_COD AND D2_FILIAL IN ('55') AND D_E_L_E_T_ = '' AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR01 - 60) + "' AND '" + DTOS(MV_PAR01 - 30) + "'),0) AS 'S_60', "
_cQuery +=" ISNULL((SELECT SUM(D2_QUANT) FROM  SD2010 D2 WITH(NOLOCK) WHERE D2_CLIENTE <= '000009' AND D2_COD=B1_COD AND D2_FILIAL IN ('55') AND D_E_L_E_T_ = '' AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR01 - 90) + "' AND '" + DTOS(MV_PAR01 - 60) + "'),0) AS 'S_90', "
_cQuery +=" ISNULL((SELECT SUM(C7_QUANT) FROM  SC7010 C7 WITH(NOLOCK) WHERE C7_PRODUTO=B1_COD  AND C7.D_E_L_E_T_ = '' AND C7_CONAPRO ='L' AND C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01 - 30) + "' AND '" + DTOS(MV_PAR01) + "'),0) AS 'P_30', "
_cQuery +=" ISNULL((SELECT SUM(C7_QUANT) FROM  SC7010 C7 WITH(NOLOCK) WHERE C7_PRODUTO=B1_COD  AND C7.D_E_L_E_T_ = '' AND C7_CONAPRO ='L' AND C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01 - 60) + "' AND '" + DTOS(MV_PAR01 - 30) + "'),0) AS 'P_60', "
_cQuery +=" ISNULL((SELECT SUM(C7_QUANT) FROM  SC7010 C7 WITH(NOLOCK) WHERE C7_PRODUTO=B1_COD AND C7.D_E_L_E_T_ = '' AND C7_CONAPRO ='L' AND C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01 - 90) + "' AND '" + DTOS(MV_PAR01 - 60) + "'),0) AS 'P_90', "
_cQuery +=" ISNULL((SELECT SUM(B2_QATU) FROM  SB2010 B2 WITH(NOLOCK) WHERE B2_COD=B1_COD AND B2_FILIAL IN ('55') AND D_E_L_E_T_ = ''),0) AS 'Stk_Cd', "
_cQuery +=" B1_CODASS	AS 'CodAssunto', "
_cQuery +=" COALESCE(Z1_DESC,'SEM ASSUNTO')		AS 'Assunto', "
_cQuery +=" B1_UPRC		AS 'Ult_Cus', "
_cQuery +=" (SELECT CONVERT(SMALLDATETIME,C7_DATPRF,121) FROM "
_cQuery +=" (SELECT DENSE_RANK() OVER(PARTITION BY C7_PRODUTO ORDER BY C7_DATPRF DESC,C7_NUM ASC) AS 'RANK',C7_DATPRF "
_cQuery +=" FROM  SC7010 C7 WITH(NOLOCK) WHERE C7.C7_PRODUTO =B1_COD AND C7_CONAPRO = 'L' AND C7.D_E_L_E_T_='' "
_cQuery +=" AND C7_DATPRF IN (SELECT TOP 1 C7_DATPRF FROM  SC7010 c WITH(NOLOCK) WHERE C7.C7_PRODUTO = c.C7_PRODUTO AND C7_CONAPRO = 'L' ORDER BY C7_DATPRF DESC) "
_cQuery +=" GROUP BY C7_PRODUTO,C7_DATPRF,C7_NUM) AS SUB WHERE RANK = 1) AS 'DAT_ULT_PED', "
_cQuery +=" (SELECT C7_NUM FROM "
_cQuery +=" (SELECT DENSE_RANK() OVER(PARTITION BY C7_PRODUTO ORDER BY C7_DATPRF DESC,C7_NUM ASC) AS 'RANK',C7_NUM "
_cQuery +=" FROM  SC7010 C7 WITH(NOLOCK) WHERE C7.C7_PRODUTO =B1_COD AND C7_CONAPRO = 'L' AND C7.D_E_L_E_T_='' "
_cQuery +=" AND C7_DATPRF IN (SELECT TOP 1 C7_DATPRF FROM  SC7010 c WITH(NOLOCK) WHERE C7.C7_PRODUTO = c.C7_PRODUTO AND C7_CONAPRO = 'L' ORDER BY C7_DATPRF DESC) "
_cQuery +=" GROUP BY C7_PRODUTO,C7_DATPRF,C7_NUM) AS SUB WHERE RANK = 1) AS 'NUM_ULT_PED', "
_cQuery +=" (SELECT C7_QUANT FROM "
_cQuery +=" (SELECT DENSE_RANK() OVER(PARTITION BY C7_PRODUTO ORDER BY C7_DATPRF DESC,C7_NUM ASC) AS 'RANK',SUM(C7_QUANT) AS 'C7_QUANT' "
_cQuery +=" FROM  SC7010 C7 WITH(NOLOCK) WHERE C7.C7_PRODUTO =B1_COD AND C7_CONAPRO = 'L' AND C7.D_E_L_E_T_='' "
_cQuery +=" AND C7_DATPRF IN (SELECT TOP 1 C7_DATPRF FROM  SC7010 c WITH(NOLOCK) WHERE C7.C7_PRODUTO = c.C7_PRODUTO AND C7_CONAPRO = 'L' ORDER BY C7_DATPRF DESC) "
_cQuery +=" GROUP BY C7_PRODUTO,C7_DATPRF,C7_NUM) AS SUB WHERE RANK = 1) AS 'QTD_ULT_PED', "
_cQuery +=" (SELECT CONVERT(SMALLDATETIME,C7_DATPRF,121) FROM "
_cQuery +=" (SELECT DENSE_RANK() OVER(PARTITION BY C7_PRODUTO ORDER BY C7_DATPRF DESC,C7_NUM ASC) AS 'RANK',C7_DATPRF "
_cQuery +=" FROM  SC7010 C7 WITH(NOLOCK) WHERE C7.C7_PRODUTO =B1_COD AND C7_CONAPRO = 'L' AND C7.D_E_L_E_T_=''"
_cQuery +=" AND C7_DATPRF IN (SELECT TOP 2 C7_DATPRF FROM  SC7010 c WITH(NOLOCK) WHERE C7.C7_PRODUTO = c.C7_PRODUTO AND C7_CONAPRO = 'L' ORDER BY C7_DATPRF DESC) "
_cQuery +=" GROUP BY C7_PRODUTO,C7_DATPRF,C7_NUM) AS SUB WHERE RANK = 2) AS 'DAT_PEN_PED', "
_cQuery +=" (SELECT C7_NUM FROM "
_cQuery +=" (SELECT DENSE_RANK() OVER(PARTITION BY C7_PRODUTO ORDER BY C7_DATPRF DESC,C7_NUM ASC) AS 'RANK',C7_NUM "
_cQuery +=" FROM  SC7010 C7 WITH(NOLOCK) WHERE C7.C7_PRODUTO =B1_COD AND C7_CONAPRO = 'L' AND C7.D_E_L_E_T_='' "
_cQuery +=" AND C7_DATPRF IN (SELECT TOP 2 C7_DATPRF FROM  SC7010 c WITH(NOLOCK) WHERE C7.C7_PRODUTO = c.C7_PRODUTO AND C7_CONAPRO = 'L' ORDER BY C7_DATPRF DESC) "
_cQuery +=" GROUP BY C7_PRODUTO,C7_DATPRF,C7_NUM) AS SUB WHERE RANK = 2) AS 'NUM_PEN_PED', "
_cQuery +=" (SELECT C7_QUANT FROM "
_cQuery +=" (SELECT DENSE_RANK() OVER(PARTITION BY C7_PRODUTO ORDER BY C7_DATPRF DESC,C7_NUM ASC) AS 'RANK',SUM(C7_QUANT) AS 'C7_QUANT' "
_cQuery +=" FROM  SC7010 C7 WITH(NOLOCK) WHERE C7.C7_PRODUTO =B1_COD AND C7_CONAPRO = 'L' AND C7.D_E_L_E_T_='' "
_cQuery +=" AND C7_DATPRF IN (SELECT TOP 2 C7_DATPRF FROM  SC7010 c WITH(NOLOCK) WHERE C7.C7_PRODUTO = c.C7_PRODUTO AND C7_CONAPRO = 'L' ORDER BY C7_DATPRF DESC) "
_cQuery +=" GROUP BY C7_PRODUTO,C7_DATPRF,C7_NUM) AS SUB WHERE RANK = 2) AS 'QTD_PEN_PED', "
_cQuery +=" (SELECT CONVERT(SMALLDATETIME,C7_DATPRF,121) FROM "
_cQuery +=" (SELECT DENSE_RANK() OVER(PARTITION BY C7_PRODUTO ORDER BY C7_DATPRF DESC,C7_NUM ASC) AS 'RANK',C7_DATPRF "
_cQuery +=" FROM  SC7010 C7 WITH(NOLOCK) WHERE C7.C7_PRODUTO =B1_COD AND C7_CONAPRO = 'L' AND C7.D_E_L_E_T_='' "
_cQuery +=" AND C7_DATPRF IN (SELECT TOP 3 C7_DATPRF FROM  SC7010 c WITH(NOLOCK) WHERE C7.C7_PRODUTO = c.C7_PRODUTO AND C7_CONAPRO = 'L' ORDER BY C7_DATPRF DESC) "
_cQuery +=" GROUP BY C7_PRODUTO,C7_DATPRF,C7_NUM) AS SUB WHERE RANK = 3) AS 'DAT_ANTPEN_PED', "
_cQuery +=" (SELECT C7_NUM FROM "
_cQuery +=" (SELECT DENSE_RANK() OVER(PARTITION BY C7_PRODUTO ORDER BY C7_DATPRF DESC,C7_NUM ASC) AS 'RANK',C7_NUM "
_cQuery +=" FROM  SC7010 C7 WITH(NOLOCK) WHERE C7.C7_PRODUTO =B1_COD AND C7_CONAPRO = 'L' AND C7.D_E_L_E_T_='' "
_cQuery +=" AND C7_DATPRF IN (SELECT TOP 3 C7_DATPRF FROM  SC7010 c WITH(NOLOCK) WHERE C7.C7_PRODUTO = c.C7_PRODUTO AND C7_CONAPRO = 'L' ORDER BY C7_DATPRF DESC) "
_cQuery +=" GROUP BY C7_PRODUTO,C7_DATPRF,C7_NUM) AS SUB WHERE RANK = 3) AS 'NUM_ANTPEN_PED', "
_cQuery +=" (SELECT C7_QUANT FROM "
_cQuery +=" (SELECT DENSE_RANK() OVER(PARTITION BY C7_PRODUTO ORDER BY C7_DATPRF DESC,C7_NUM ASC) AS 'RANK',SUM(C7_QUANT) AS 'C7_QUANT' "
_cQuery +=" FROM  SC7010 C7 WITH(NOLOCK) WHERE C7.C7_PRODUTO =B1_COD AND C7_CONAPRO = 'L' AND C7.D_E_L_E_T_='' "
_cQuery +=" AND C7_DATPRF IN (SELECT TOP 3 C7_DATPRF FROM  SC7010 c WITH(NOLOCK) WHERE C7.C7_PRODUTO = c.C7_PRODUTO AND C7_CONAPRO = 'L' ORDER BY C7_DATPRF DESC) "
_cQuery +=" GROUP BY C7_PRODUTO,C7_DATPRF,C7_NUM) AS SUB WHERE RANK = 3) AS 'QTD_ANTPEN_PED' "
_cQuery +=" FROM		 SB1010 B1	WITH(NOLOCK) "
_cQuery +=" INNER JOIN	 SA2010 A2	WITH(NOLOCK) ON A2_COD = B1_PROC	AND A2_LOJA = B1_LOJPROC AND A2.D_E_L_E_T_ = '' "
_cQuery +=" LEFT JOIN	 SZ1010 Z1	WITH(NOLOCK) ON Z1_CODIGO = B1_CODASS AND Z1.D_E_L_E_T_ = '' "
_cQuery +=" INNER JOIN	" + _cTemp1 + " ON BZ_COD=B1_COD "
_cQuery +=" WHERE B1_GRUPO in  ('0540', '0009') AND B1.D_E_L_E_T_='' AND B1_MSBLQL = 2 "
_cQuery +=" ORDER BY 10 DESC,11 DESC,12 DESC,2 DESC "

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)

// TcSqlExec('DROP TABLE ' + _cTemp1)

count to _nLastRec
SetRegua(_nLastRec)

dbGoTop()

If MV_PAR02 == 1
	
	While !EOF()
		
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
		
		@++nLin,00 PSAY Trans(TRB->Material, "@E 999999999999999") + '  ' + left(TRB->Descricao,40) + '  '  + left(TRB->Fantasia,40)  + '  ' + Trans(TRB->S_30, "@E 99999") + '  ' + Trans(TRB->S_60, "@E 99999") + '  ' + Trans(TRB->S_90, "@E 99999") + '  ' + Trans(TRB->P_30, "@E 99999") + '  ' + Trans(TRB->P_60, "@E 99999") + '  ' + Trans(TRB->P_90, "@E 99999") + '  ' + Trans(TRB->Stk_Cd, "@E 99999") + '  ' + TRB->Assunto
		
		DbSkip()
		IncRegua()
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,01 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	EndDo
	
	dbClosearea()
	TcDelFile(_cTemp1)
	
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
	
Else
	
	
	If !ApOleClient("MsExcel")
		MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
		Return
	EndIf
	
	_cCabec1 := 'Material;Descrição;Fantasia;Saída 30; Saída 60; Saída 90;Ped. 30;Ped. 60;Ped. 90;Stk;Assunto' + _cEnter
	_nHdl := fCreate('C:\SPOOL\SLOWMOVING.CSV')
	If _nHdl < 0
		MsgBox('Não foi possível criar o arquivo C:\SPOOL\SLOWMOVING.CSV','ATENÇÃO!!!','ALERT')
		Return()
	EndIf
	
	DbSelectArea("TRB")
	If eof()
		fClose(_nHdl)
		MsgBox('Arquivo C:\SPOOL\SLOWMOVING.CSV sem dados para consulta','ATENÇÃO!!!','ALERT')
		Return()
	EndIf
	fWrite(_nHdl,_cCabec1,Len(_cCabec1))
	
	Do While TRB->(!Eof())
		
		_cLinha := TRB->Material + ';' + strtran(TRB->Descricao,';',',') + ';' + strtran(TRB->Fantasia,';',',') + ';' + Trans(TRB->S_30	, '@E 99999') + ';' + Trans(TRB->S_60	, '@E 99999') + ';'
		_cLinha += Trans(TRB->S_90	, '@E 99999') + ';' + Trans(TRB->P_30	, '@E 99999') + ';' + Trans(TRB->P_60	, '@E 99999') + ';' + Trans(TRB->P_90	, '@E 99999') + ';'
		_cLinha += Trans(TRB->Stk_Cd, '@E 99999') + ';' + strtran(TRB->Assunto,';',',') + _cEnter
		
		fWrite(_nHdl,_cLinha,Len(_cLinha))
		
		TRB->(DbSkip())
		IncRegua()
		
	Enddo
	
	TRB->(dbClosearea())
	TcDelFile(_cTemp1)
	fClose(_nHdl)
	
	oExcelApp:= MsExcel():New()
	oExcelApp:WorkBooks:Open('C:\SPOOL\SLOWMOVING.CSV')
	oExcelApp:SetVisible(.T.)
	
Endif
Return

/*
// lsv ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////

_aAlias := GetArea()
aPerg   := {}

//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Data ?","","", "mv_ch1", "D",  8 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

DbSelectArea("SX1")
DbSetOrder(1)

For i:=1 to len(aPerg)
RecLock("SX1",!DbSeek(cPerg + aPerg[i, 2]))
For j := 1 to (FCount())
If j <= len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
FieldPut(j, aPerg[i, j])
Endif
Next
MsUnlock()
Next
RestArea(_aAlias)

Return
*/
