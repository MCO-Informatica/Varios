#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥DHESTR03  ∫ Autor ≥ SERGIO LACERDA - SNL SISTEMAS ∫ Data ≥  24/06/13   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Codigo gerado pelo AP6 IDE.                                           ∫±±
±±∫          ≥                                                                       ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6 IDE                                                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function DHESTR03()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Declaracao de Variaveis                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "Relatorio de Custo Medio por Entrada"
Local cPict			:= ""
Local titulo		:= "Relatorio de Custo Medio por Entrada"
Local nLin			:= 80
//						          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21       22
//						01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1		:= "NFISCAL    PRODUTO        QUANTIDADE         CUSTO UNI ENT    CUSTO TOTAL ENT  % NOTA      TOT COMPL.       UNIT COMPL.    UNITARIO TOTAL SLD ANTERIOR     $ UNI. ANTERIOR  $ TOT. ANTERIOR  CUSTO MEDIO      UNITARIO MEDIO"
Local Cabec2		:= ""
Local imprime		:= .T.
Local aOrd 			:= {}
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private CbTxt		:= ""
Private limite		:= 220
Private tamanho		:= "G"
Private nomeprog	:= "DHESTR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo		:= 15
Private aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey	:= 0
Private cPerg       := PADR("DHESTR03",10)
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "DHESTR03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	:= ""

ValidPerg(cPerg)
pergunte(cPerg,.F.)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta a interface padrao com o usuario...                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Processamento. RPTSTATUS monta janela com a regua de processamento. ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥RUNREPORT ∫ Autor ≥ AP6 IDE            ∫ Data ≥  24/06/13   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ∫±±
±±∫          ≥ monta a janela com a regua de processamento.               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Programa principal                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQrySd1	:= ""
Local cNotaFis	:= ""
Local nTotCusto	:= 0
Local nTotCompl	:= 0
Local lAgain	:= .F.

cQrySd1	:= "SELECT	A1 , " + Chr(13)
cQrySd1	+= "		B1 , " + Chr(13) 
cQrySd1	+= "		C1 , " + Chr(13)
cQrySd1	+= "		D1 , " + Chr(13)
cQrySd1	+= "		E1 , " + Chr(13)
cQrySd1	+= "		F1 , " + Chr(13)
cQrySd1	+= "		G1 , " + Chr(13)
cQrySd1	+= "		H1 , " + Chr(13)
cQrySd1	+= "		J1 ,  " + Chr(13)
cQrySd1	+= "		L1 ,  " + Chr(13)
cQrySd1	+= "		D1_FILIAL , " + Chr(13)
cQrySd1 += "		D1_DTDIGIT , " + Chr(13)

cQrySd1	+= "		(	(	SELECT	COUNT(*) " + Chr(13)
cQrySd1	+= "				FROM	" + RetSqlName("SD2") + " SD2 " + Chr(13)
cQrySd1	+= "				WHERE	SD2.D_E_L_E_T_ = '' " + Chr(13)
cQrySd1	+= "						AND SD2.D2_FILIAL = D1_FILIAL " + Chr(13)
cQrySd1	+= "						AND SD2.D2_COD = B1 " + Chr(13)
cQrySd1	+= "						AND SD2.D2_EMISSAO = D1_DTDIGIT) +  " + Chr(13)
cQrySd1	+= "			(	SELECT	COUNT(*) " + Chr(13)
cQrySd1	+= "				FROM	" + RetSqlName("SD3") + " SD3 " + Chr(13)
cQrySd1	+= "				WHERE	SD3.D_E_L_E_T_ = '' " + Chr(13)
cQrySd1	+= "						AND SD3.D3_FILIAL = D1_FILIAL " + Chr(13)
cQrySd1	+= "						AND SD3.D3_COD = B1 " + Chr(13)
cQrySd1	+= "						AND SD3.D3_EMISSAO = D1_DTDIGIT " + Chr(13)
cQrySd1	+= "						AND SD3.D3_ESTORNO = '')) AS 'Z1' , " + Chr(13)
cQrySd1	+= "		D1_R_E_C_N_O_ " + Chr(13)

cQrySd1	+= "FROM  " + Chr(13)
cQrySd1	+= "(SELECT	SD1.D1_DOC AS 'A1' ,  -- NOTA FISCAL  " + Chr(13)
cQrySd1	+= "		SD1.D1_COD AS 'B1', -- CODIGO DO PRODUTO " + Chr(13)
cQrySd1	+= "		(CASE WHEN SD1.D1_QUANT > 0 " + Chr(13)
cQrySd1	+= "				THEN SD1.D1_QUANT " + Chr(13)
cQrySd1	+= "				ELSE 1 " + Chr(13)
cQrySd1	+= "				END ) AS 'C1', -- QUANTIDADE DA NOTA " + Chr(13)
cQrySd1	+= "		(SD1.D1_CUSTO / (CASE WHEN SD1.D1_QUANT > 0 " + Chr(13)
cQrySd1	+= "				THEN SD1.D1_QUANT " + Chr(13)
cQrySd1	+= "				ELSE 1 " + Chr(13)
cQrySd1	+= "				END )) AS 'D1', -- CUSTO UNITARIO DE ENTRADA " + Chr(13)
cQrySd1	+= "		SD1.D1_CUSTO AS 'E1' , -- CUSTO TOTAL DE ENTRADA " + Chr(13)
cQrySd1	+= "		ISNULL((SD1.D1_CUSTO / (	SELECT	SUM(SD12.D1_CUSTO) " + Chr(13)
cQrySd1	+= "									FROM	" + RetSqlName("SD1") + " SD12 " + Chr(13)
cQrySd1	+= "									WHERE	SD12.D_E_L_E_T_		= '' " + Chr(13)
cQrySd1	+= "											AND SD12.D1_FILIAL	= SD1.D1_FILIAL " + Chr(13)
cQrySd1	+= "											AND SD12.D1_DOC		= SD1.D1_DOC " + Chr(13)
cQrySd1	+= "											AND SD12.D1_SERIE	= SD1.D1_SERIE " + Chr(13)
cQrySd1	+= "											AND SD12.D1_TIPO	= SD1.D1_TIPO " + Chr(13)
cQrySd1	+= "											AND SD12.D1_FORNECE = SD1.D1_FORNECE " + Chr(13)
cQrySd1	+= "											AND SD12.D1_LOJA	= SD1.D1_LOJA)) * 100,0) 'F1', -- PERCENTUAL DE REPRESENTATIVIDADE DO ITEM NA NOTA " + Chr(13)
cQrySd1	+= "		ISNULL(((SD1.D1_QUANT ) / " + Chr(13)
cQrySd1	+= "				(	SELECT	SUM(SD1Z.D1_QUANT)" + Chr(13)
cQrySd1	+= "					FROM	" + RetSqlName("SD1") + " SD1Z" + Chr(13)
cQrySd1	+= "					WHERE	SD1Z.D_E_L_E_T_ = ''" + Chr(13)
cQrySd1	+= "							AND SD1Z.D1_FILIAL = SD1.D1_FILIAL" + Chr(13)
cQrySd1	+= "							AND SD1Z.D1_DOC = SD1.D1_DOC" + Chr(13)
cQrySd1	+= "							AND SD1Z.D1_SERIE = SD1.D1_SERIE" + Chr(13)
cQrySd1	+= "							AND SD1Z.D1_COD = SD1.D1_COD)) *" + Chr(13)
cQrySd1	+= "				(	SELECT	SUM(SD12.D1_CUSTO) " + Chr(13)
cQrySd1	+= "					FROM	" + RetSqlName("SD1") + "  SD12 " + Chr(13)
cQrySd1	+= "					WHERE	SD12.D_E_L_E_T_		= '' " + Chr(13)
cQrySd1	+= "							AND SD12.D1_FILIAL	+ SD12.D1_DOC + SD12.D1_SERIE + SD12.D1_FORNECE + SD12.D1_LOJA =  " + Chr(13)
cQrySd1	+= "							(	SELECT	DISTINCT(SF8.F8_FILIAL + SF8.F8_NFDIFRE + SF8.F8_SEDIFRE + SF8.F8_TRANSP + SF8.F8_LOJTRAN) " + Chr(13)
cQrySd1	+= "										FROM	SF8010 SF8 " + Chr(13)
cQrySd1	+= "										WHERE	SF8.D_E_L_E_T_ = '' " + Chr(13)
cQrySd1	+= "												AND SF8.F8_FILIAL = SD1.D1_FILIAL " + Chr(13)
cQrySd1	+= "												AND SF8.F8_NFORIG = SD1.D1_DOC " + Chr(13)
cQrySd1	+= "												AND SF8.F8_SERORIG = SD1.D1_SERIE " + Chr(13)
cQrySd1	+= "												AND SF8.F8_FORNECE = SD1.D1_FORNECE " + Chr(13)
cQrySd1	+= "												AND SF8.F8_LOJA = SD1.D1_LOJA)  " + Chr(13)
cQrySd1	+= "							AND SD12.D1_COD = SD1.D1_COD),0) AS 'G1', -- CUSTO TOTAL DO ITEM NA NOTA FISCAL COMPLEMENTAR  " + Chr(13)
cQrySd1	+= "		ISNULL((	SELECT	SUM(SD12.D1_CUSTO) " + Chr(13)
cQrySd1	+= "					FROM	" + RetSqlName("SD1") + "  SD12 " + Chr(13)
cQrySd1	+= "					WHERE	SD12.D_E_L_E_T_		= '' " + Chr(13)
cQrySd1	+= "							AND SD12.D1_FILIAL	+ SD12.D1_DOC + SD12.D1_SERIE + SD12.D1_FORNECE + SD12.D1_LOJA =  " + Chr(13)
cQrySd1	+= "							(	SELECT	DISTINCT(SF8.F8_FILIAL + SF8.F8_NFDIFRE + SF8.F8_SEDIFRE + SF8.F8_TRANSP + SF8.F8_LOJTRAN) " + Chr(13)
cQrySd1	+= "										FROM	" + RetSqlName("SF8") + " SF8 " + Chr(13)
cQrySd1	+= "										WHERE	SF8.D_E_L_E_T_ = '' " + Chr(13)
cQrySd1	+= "												AND SF8.F8_FILIAL = SD1.D1_FILIAL " + Chr(13)
cQrySd1	+= "												AND SF8.F8_NFORIG = SD1.D1_DOC " + Chr(13)
cQrySd1	+= "												AND SF8.F8_SERORIG = SD1.D1_SERIE " + Chr(13)
cQrySd1	+= "												AND SF8.F8_FORNECE = SD1.D1_FORNECE " + Chr(13)
cQrySd1	+= "												AND SF8.F8_LOJA = SD1.D1_LOJA)  " + Chr(13)
cQrySd1	+= "												AND SD12.D1_COD = SD1.D1_COD) / (	CASE 	WHEN SD1.D1_QUANT > 0 " + Chr(13)
cQrySd1	+= "																							THEN SD1.D1_QUANT " + Chr(13)
cQrySd1	+= "																							ELSE 1 " + Chr(13)
cQrySd1	+= "																							END ),0) AS 'H1' , -- CUSTO UNITARIO DO ITEM NA NOTA FISCAL COMPLEMENTAR " + Chr(13)
cQrySd1	+= "		SD1.D1_SLDSB2 'J1' ,  " + Chr(13)
If MV_PAR19 == 1
	cQrySd1	+= "		ISNULL((	SELECT	TOP 1 DA1.DA1_PRCVEN " + Chr(13)
	cQrySd1	+= "					FROM	" + RetSqlName("DA1") + " DA1 " + Chr(13)
	cQrySd1	+= "					WHERE	DA1.D_E_L_E_T_ = '' " + Chr(13)
	cQrySd1	+= "							AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "' " + Chr(13)
	cQrySd1	+= "							AND DA1.DA1_CODTAB = '" + MV_PAR20 + "' " + Chr(13)
	cQrySd1	+= "							AND DA1.DA1_CODPRO = SD1.D1_COD),0) 'L1' ,  " + Chr(13)
Else
	/*
	cQrySd1	+= "			ISNULL((SELECT	SD12.D1_CUSTO / (CASE	WHEN SD12.D1_QUANT > 0 " + Chr(13)
	cQrySd1	+= "													THEN SD12.D1_QUANT " + Chr(13)
	cQrySd1	+= "													ELSE SD1.D1_QUANT " + Chr(13)
	cQrySd1	+= "											END)	 " + Chr(13)
	cQrySd1	+= "					FROM	" + RetSqlName("SD1") + " SD12 " + Chr(13)
	cQrySd1	+= "					WHERE	SD12.R_E_C_N_O_ =  " + Chr(13)
	cQrySd1	+= "				(	SELECT	MAX(SD12.R_E_C_N_O_) " + Chr(13)
	cQrySd1	+= "					FROM	SD1010 SD12 " + Chr(13)
	cQrySd1	+= "					WHERE	SD12.D_E_L_E_T_ = '' " + Chr(13)
	cQrySd1	+= "							AND SD12.D1_FILIAL = SD1.D1_FILIAL " + Chr(13)
	cQrySd1	+= "							AND SD12.D1_COD = SD1.D1_COD " + Chr(13)
	cQrySd1	+= "							AND SD12.D1_DTDIGIT < SD1.D1_DTDIGIT " + Chr(13)
	cQrySd1	+= "							AND SD12.D1_QUANT > 0)),0) 'L1' ,  " + Chr(13)
	*/
	cQrySd1 += "	0 AS 'L1' ,  " + chr(13)
Endif

cQrySd1	+= "		ISNULL((SD1.D1_SLDSB2 *  " + Chr(13)
If MV_PAR19 == 1
	cQrySd1	+= "				(	SELECT	TOP 1 DA1.DA1_PRCVEN " + Chr(13)
	cQrySd1	+= "					FROM	" + RetSqlName("DA1") + " DA1 " + Chr(13)
	cQrySd1	+= "					WHERE	DA1.D_E_L_E_T_ = '' " + Chr(13)
	cQrySd1	+= "							AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "' " + Chr(13)
	cQrySd1	+= "							AND DA1.DA1_CODTAB = '" + MV_PAR20 + "' " + Chr(13)
	cQrySd1	+= "							AND DA1.DA1_CODPRO = SD1.D1_COD)),0) 'M1' , " + Chr(13)
Else
	/*
	cQrySd1	+= "			(SELECT	SD12.D1_CUSTO / (CASE	WHEN SD12.D1_QUANT > 0 " + Chr(13)
	cQrySd1	+= "													THEN SD12.D1_QUANT " + Chr(13)
	cQrySd1	+= "													ELSE SD1.D1_QUANT " + Chr(13)
	cQrySd1	+= "											END)	 " + Chr(13)
	cQrySd1	+= "					FROM	" + RetSqlName("SD1") + " SD12 " + Chr(13)
	cQrySd1	+= "					WHERE	SD12.R_E_C_N_O_ =  " + Chr(13)
	cQrySd1	+= "				(	SELECT	MAX(SD12.R_E_C_N_O_) " + Chr(13)
	cQrySd1	+= "					FROM	SD1010 SD12 " + Chr(13)
	cQrySd1	+= "					WHERE	SD12.D_E_L_E_T_ = '' " + Chr(13)
	cQrySd1	+= "							AND SD12.D1_FILIAL = SD1.D1_FILIAL " + Chr(13)
	cQrySd1	+= "							AND SD12.D1_COD = SD1.D1_COD " + Chr(13)
	cQrySd1	+= "							AND SD12.D1_DTDIGIT < SD1.D1_DTDIGIT " + Chr(13)
	cQrySd1	+= "							AND SD12.D1_QUANT > 0))),0) [CUSTO_TOTAL_ANTERIOR] , " + Chr(13)
	*/
	cQrySd1 += "	0),0) [CUSTO_TOTAL_ANTERIOR] , " + Chr(13)
Endif	

cQrySd1	+= "	SD1.D1_FILIAL , " + Chr(13)
cQrySd1	+= "	SD1.D1_DTDIGIT ,  " + Chr(13)
cQrySd1	+= "	SD1.R_E_C_N_O_ D1_R_E_C_N_O_ " + Chr(13)

cQrySd1	+= "FROM	" + RetSqlName("SD1") + "  SD1 " + Chr(13)
cQrySd1	+= "		INNER JOIN " + RetSqlName("SF4") + " SF4 ON SF4.F4_CODIGO = SD1.D1_TES " + Chr(13)
cQrySd1	+= "		INNER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_COD = SD1.D1_FORNECE AND SA2.A2_LOJA = SD1.D1_LOJA " + Chr(13)
cQrySd1	+= "WHERE	SD1.D_E_L_E_T_ = '' " + Chr(13)
cQrySd1	+= "		AND SA2.D_E_L_E_T_ = '' " + Chr(13)
cQrySd1	+= "		AND SF4.D_E_L_E_T_ = '' " + Chr(13)
//cQrySd1	+= "		AND SA2.A2_EST = 'EX' " + Chr(13) // Somente fornecedores Estrangeiros
cQrySd1	+= "		AND SD1.D1_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + Chr(13)
cQrySd1	+= "		AND SD1.D1_DTDIGIT BETWEEN '" + Dtos(MV_PAR03) + "' AND '" + Dtos(MV_PAR04) + "' " + Chr(13)
cQrySd1	+= "		AND SD1.D1_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "' " + Chr(13)
cQrySd1	+= "		AND SD1.D1_DOC BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR09 + "' " + Chr(13)
cQrySd1	+= "		AND SD1.D1_SERIE BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR10 + "' " + Chr(13)
cQrySd1	+= "		AND SD1.D1_FORNECE BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR17 + "' " + Chr(13)
cQrySd1	+= "		AND SD1.D1_LOJA BETWEEN '" + MV_PAR16 + "' AND '" + MV_PAR18 + "' " + Chr(13)
cQrySd1	+= "		AND SD1.D1_COD BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' " + Chr(13)
cQrySd1	+= "		AND SD1.D1_GRUPO BETWEEN '" + MV_PAR13 + "' AND '" + MV_PAR14 + "' " + Chr(13)
cQrySd1	+= "		AND SF4.F4_XRELCUS	= '1' " + Chr(13)

If MV_PAR23 == 1
	cQrySd1	+= "		AND SF4.F4_DUPLIC = 'S' " + Chr(13)
Elseif MV_PAR23 == 2
	cQrySd1	+= "		AND SF4.F4_DUPLIC = 'N'	" + Chr(13)
Endif

If MV_PAR24 == 1
	cQrySd1	+= "		AND SF4.F4_ESTOQUE = 'S' " + Chr(13)
Elseif MV_PAR24 == 2
	cQrySd1	+= "		AND SF4.F4_ESTOQUE = 'N' " + Chr(13)
Endif

cQrySd1	+= "		) AS TAB1 " + Chr(13)
cQrySd1	+= "ORDER BY A1,B1 " + Chr(13)

If Select("TMPCUSTO") > 0
	TMPCUSTO->(DbCloseArea())
Endif

Tcquery cQrySd1 New Alias "TMPCUSTO"

nRegs	:= 0

Count To nRegs

If MV_PAR21 <> 3

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ SETREGUA -> Indica quantos registros serao processados para a regua ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	
	SetRegua(nRegs)
	
	TMPCUSTO->(dbGoTop())
	While !TMPCUSTO->(EOF())
		
		IncRegua()
	
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Verifica o cancelamento pelo usuario...                             ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
	
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Impressao do cabecalho do relatorio. . .                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	
		If nLin > 55 // Salto de P·gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		If TMPCUSTO->Z1 > 0
			cAsterisco	:= "*"
		Else
			cAsterisco	:= ""
		Endif	
		
		@ nLin , 000 PSAY TMPCUSTO->A1 // Nota Fiscal
		@ nLin , 011 PSAY Alltrim(TMPCUSTO->B1) + cAsterisco // Codigo do Produto
		@ nLin , 028 PSAY TMPCUSTO->C1 Picture PesqPict("SD1", "D1_QUANT",,) 	// Quantidade da NF
		@ nLin , 045 PSAY TMPCUSTO->D1 Picture PesqPict("SD1", "D1_CUSTO",,) 	// CUSTO UNITARIO DE ENTRADA
		@ nLin , 062 PSAY TMPCUSTO->E1 Picture PesqPict("SD1", "D1_CUSTO",,) 	// CUSTO TOTAL DE ENTRADA
		@ nLin , 079 PSAY TMPCUSTO->F1 Picture "@E 999.99"						// PERCENTUAL DE REPRESENTATIVIDADE DO ITEM NA NOTA
		@ nLin , 087 PSAY TMPCUSTO->G1 Picture PesqPict("SD1", "D1_CUSTO",,)	// CUSTO TOTAL DO ITEM NA NOTA FISCAL COMPLEMENTAR
		@ nLin , 104 PSAY TMPCUSTO->H1 Picture PesqPict("SD1", "D1_VUNIT",,)	// CUSTO UNITARIO DO ITEM NA NOTA FISCAL COMPLEMENTAR
		@ nLin , 121 PSAY (TMPCUSTO->D1+TMPCUSTO->H1) Picture PesqPict("SD1", "D1_VUNIT",,) 	// CUSTO UNITARIO TOTAL
		@ nLin , 138 PSAY TMPCUSTO->J1 Picture PesqPict("SD1", "D1_QUANT",,)	// SALDO ANTERIOR
		@ nLin , 155 PSAY TMPCUSTO->L1 Picture PesqPict("SD2", "D2_PRCVEN",,) 	// PRECO ANTERIOR
		@ nLin , 172 PSAY TMPCUSTO->M1 Picture PesqPict("SD1", "D1_TOTAL",,)	// VALOR ESTOQUE ANTERIOR
		@ nLin , 189 PSAY TMPCUSTO->N1 Picture PesqPict("SD1", "D1_CUSTO",,)	// CUSTO MEDIO CALCULADO
		@ nLin , 206 PSAY TMPCUSTO->O1 Picture PesqPict("SD1", "D1_CUSTO",,)	// CUSTO MEDIO CALCULADO
		
		nTotCusto	+= TMPCUSTO->E1
		nTotCompl	+= TMPCUSTO->G1
	
		nLin := nLin + 1 // Avanca a linha de impressao
		
		TMPCUSTO->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		
		If Empty(cNotaFis)
			cNotaFis	:= TMPCUSTO->A1
			_cxFilial	:= TMPCUSTO->D1_FILIAL
			cDtDigit	:= Dtoc(Stod(TMPCUSTO->D1_DTDIGIT))
		Elseif cNotaFis <> TMPCUSTO->A1
		
			@ nLin , 000 PSAY "T O T A L  D A  N O T A  F I S C A L "
			@ nLin , 062 PSAY nTotCusto	Picture PesqPict("SD1", "D1_CUSTO",,)
			@ nLin , 087 PSAY nTotCompl Picture PesqPict("SD1", "D1_CUSTO",,)
			@ nLin , 107 PSAY "FILIAL: " + _cxFilial + " DT ENTRADA: " + cDtDigit

			nLin := nLin + 2 // Avanca a linha de impressao
			
			If nLin > 55 // Salto de P·gina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif			
		
			nTotCusto	:= 0
			nTotCompl	:= 0
			cNotaFis	:= TMPCUSTO->A1							
			_cxFilial	:= TMPCUSTO->D1_FILIAL
			cDtDigit	:= Dtoc(Stod(TMPCUSTO->D1_DTDIGIT))
		Endif		
	EndDo
	
	@ nLin , 000 PSAY "T O T A L  D A  N O T A  F I S C A L "
	@ nLin , 062 PSAY nTotCusto	Picture PesqPict("SD1", "D1_CUSTO",,)
	@ nLin , 087 PSAY nTotCompl Picture PesqPict("SD1", "D1_CUSTO",,)	
	@ nLin , 107 PSAY "FILIAL: " + _cxFilial + " DT ENTRADA: " + cDtDigit	
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Finaliza a execucao do relatorio...                                 ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	
	SET DEVICE TO SCREEN
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Se impressao em disco, chama o gerenciador de impressao...          ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	
	If lAgain
		Aviso("Aviso","Foram identificadas inconsistencias nos dados, favor emitir o relatorio novamente",{"OK"})
	Endif
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
Endif

If MV_PAR21 <> 2
	cNotaFis	:= ""
	nTotCusto	:= 0
	nTotCompl	:= 0
	aDados		:= {}
	
	SetRegua(nRegs)
	
	TMPCUSTO->(dbGoTop())
	While !TMPCUSTO->(EOF())
		IncRegua()
		
		If TMPCUSTO->J1 <= 0
			DbSelectArea("SB1")
			DbSetOrder(1)
			If DbSeek(xFilial("SB1") + TMPCUSTO->B1)
				cFilOld	:= TMPCUSTO->D1_FILIAL
				cFilAnt	:= TMPCUSTO->D1_FILIAL
				aSaldoDisp	:= CalcEst(SB1->B1_COD,SB1->B1_LOCPAD,Stod(TMPCUSTO->D1_DTDIGIT),,.F.,.F.)
				nSaldoDisp 	:= aSaldoDisp[1]  
				cFilAnt		:= cFilOld 
				
				If nSaldoDisp <> TMPCUSTO->J1
					DbSelectArea("SD1")	
					DbGoTo(TMPCUSTO->D1_R_E_C_N_O_)
					If RecLock("SD1",.F.)
						SD1->D1_SLDSB2	:= nSaldoDisp
						SD1->(Msunlock())
						lAgain	:= .T.
					Endif
				Endif	
			Endif	
		Endif	
		
		If Empty(cNotaFis)
			cNotaFis	:= TMPCUSTO->A1
			nTotCusto	:= 0
			nTotCompl	:= 0		
		Elseif cNotaFis <> TMPCUSTO->A1
			aAdd(aDados,{	"TOTAL DA NF " + cNotaFis		,;
							""								,;
							""								,;
							""								,;
							""		   						,;
							nTotCusto						,;
							""								,;
							nTotCompl						,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								})

			aAdd(aDados,{	" "								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								,;
							""								})
							
			cNotaFis	:= TMPCUSTO->A1							
			nTotCusto	:= 0
			nTotCompl	:= 0			
		Endif
		
		If TMPCUSTO->Z1 > 0
			cAsterisco	:= "*"
		Else
			cAsterisco	:= ""
		Endif		
		
		/*
		aAdd(aDados,{	TMPCUSTO->A1	,;
						TMPCUSTO->B1	,;
						cAsterisco		,;
						TMPCUSTO->C1	,;
						TMPCUSTO->D1	,;
						TMPCUSTO->E1	,;
						TMPCUSTO->F1	,;
						TMPCUSTO->G1	,;
						TMPCUSTO->H1	,;
						TMPCUSTO->I1	,;
						TMPCUSTO->J1	,;
						TMPCUSTO->L1	,;
						TMPCUSTO->M1	,;
						TMPCUSTO->N1	,;
						TMPCUSTO->O1	})
		*/
		
		aAdd(aDados,{	TMPCUSTO->A1	,;
						TMPCUSTO->B1	,;
						cAsterisco		,;
						TMPCUSTO->C1	,;
						TMPCUSTO->D1	,;
						TMPCUSTO->E1	,;
						TMPCUSTO->F1	,;
						TMPCUSTO->G1	,;
						TMPCUSTO->H1	,;
						(TMPCUSTO->D1+TMPCUSTO->H1),;
						(TMPCUSTO->D1+TMPCUSTO->H1) * TMPCUSTO->C1,;
						TMPCUSTO->J1	,;
						TMPCUSTO->L1	,;
						(TMPCUSTO->J1*TMPCUSTO->L1)	,;
						TMPCUSTO->E1+TMPCUSTO->G1+(TMPCUSTO->J1*TMPCUSTO->L1),;
						(TMPCUSTO->E1+TMPCUSTO->G1+(TMPCUSTO->J1*TMPCUSTO->L1))/(TMPCUSTO->C1+TMPCUSTO->J1)})
						
		nTotCusto	+= TMPCUSTO->E1
		nTotCompl	+= TMPCUSTO->G1
	
		TMPCUSTO->(DbSkip())
	Enddo
	
	aAdd(aDados,{	"TOTAL DA NF " + cNotaFis		,;
					""								,;
					""								,;
					""								,;
					""		   						,;
					nTotCusto						,;
					""								,;
					nTotCompl						,;
					""								,;
					""								,;
					""								,;
					""								,;
					""								,;
					""								,;
					""								,;
					""								})	
	
	If lAgain
		Aviso("Aviso","Foram identificadas inconsistencias nos dados, favor emitir o relatorio novamente",{"OK"})
	Endif	
	
	If Len(aDados) > 0
		//			A			 B			C				D					  E					 F					G								H						I				J				L					                  M                             N                   O
		//aCabec 	:= {"Nota Fiscal","Produto","Quantidade NF","Custo Total do Item","% DO CUSTO TOTAL","NF COMPLEMENTAR","Custo complementar unit·rio","Custo unit·rio total","ESTOQUE ANTERIOR","tab inventario (preÁo anterior)","custo total anterior","Custo total nf entrada","Soma dos custos","Custo mÈdio atual"}
		//aCabec	:= {"NFISCAL","PRODUTO","QUANTIDADE","CUSTO UNI ENT","CUSTO TOTAL ENT","% NOTA","TOT COMPL.","UNIT COMPL.","UNITARIO TOTAL","SLD ANTERIOR","$ UNI. ANTERIOR","$ TOT. ANTERIOR","CUSTO MEDIO","UNITARIO MEDIO","TOTAL VLR SALDO","OBS"}
		//aCabec	:= {"NFISCAL","PRODUTO","OBS","QUANTIDADE","CUSTO UNI ENT","CUSTO TOTAL ENT","% NOTA","TOT COMPL.","UNIT COMPL.","UNITARIO TOTAL","SLD ANTERIOR","$ UNI. ANTERIOR","$ TOT. ANTERIOR","CUSTO MEDIO","UNITARIO MEDIO","TOTAL VLR SALDO"}
		aCabec	:= {"NFISCAL","PRODUTO","OBS","QUANTIDADE","CUSTO UNI ENT","CUSTO TOTAL ENT","% NOTA","TOT COMPL.","UNIT COMPL.","UNITARIO TOTAL","CUSTO TOTAL NOVO","SLD ANTERIOR","$ UNI. ANTERIOR","$ TOT. ANTERIOR","CUSTO MEDIO","UNITARIO MEDIO"}
		 
		If !ApOleClient("MSExcel")
			MsgAlert("Microsoft Excel n„o instalado!")
			Return
		EndIf
		 
		DlgToExcel({ {"ARRAY", "Exportacao para o Excel", aCabec, aDados} })
	Endif
Endif



Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ ValidPerg   ≥Descriá„o≥Verifica o Arquivo Sx1, criando as  ≥±±
±±≥          ≥             ≥         ≥Perguntas se necessario.            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ValidPerg(cPerg)

Local APERG 	:= 	{}
Local AALIASSX1	:=	GETAREA()

//     "X1_GRUPO"	,"X1_ORDEM"	,"X1_PERGUNT"      			,"X1_PERSPA"				,"X1_PERENG"				,"X1_VARIAVL"	,"X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"	,"X1_VALID"	,"X1_VAR01"	,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,"X1_VAR02"	,"X1_DEF02"	,"X1_DEFSPA2"	,"X1_DEFENG2"	,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,"X1_VAR04"	,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,"X1_VAR05"	,"X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,"X1_F3"	,"X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"
AADD(APERG,{CPERG  ,"01"		,"Filial De"     			,"Filial De"     	    	,"Filial De"     			,"mv_ch1"		,"C"		,2 				,0 				,0 				,"G"		,""			,"mv_par01"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"02"		,"Filial Ate"	     		,"Filial Ate"	        	,"Filial Ate"	    		,"mv_ch2"		,"C"		,2 				,0 				,0 				,"G"		,""			,"mv_par02"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"03"		,"Dt. Digit. De"     		,"Dt. Digit. De"    	    ,"Dt. Digit. De"    		,"mv_ch3"		,"D"		,8 				,0 				,0 				,"G"		,""			,"mv_par03"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"04"		,"Dt. Digit. Ate"	     	,"Dt. Digit. Ate"	    	,"Dt. Digit. Ate"			,"mv_ch4"		,"D"		,8 				,0 				,0 				,"G"		,""			,"mv_par04"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"05"		,"Dt. Emissao De"     		,"Dt. Emissao De"       	,"Dt. Emissao De"   		,"mv_ch5"		,"D"		,8 				,0 				,0 				,"G"		,""			,"mv_par05"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"06"		,"Dt. Emissao Ate"	     	,"Dt. Emissao Ate"	    	,"Dt. Emissao Ate"			,"mv_ch6"		,"D"		,8 				,0 				,0 				,"G"		,""			,"mv_par06"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"07"		,"Nota Fiscal De"     		,"Nota Fiscal De"       	,"Nota Fiscal De"   		,"mv_ch7"		,"C"		,9 				,0 				,0 				,"G"		,""			,"mv_par07"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"08"		,"Serie De"	     			,"Serie De"	     	    	,"Serie De"	     			,"mv_ch8"		,"C"		,3 				,0 				,0 				,"G"		,""			,"mv_par08"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"09"		,"Nota Fiscal Ate"     		,"Nota Fiscal Ate"      	,"Nota Fiscal Ate"  		,"mv_ch9"		,"C"		,9 				,0 				,0 				,"G"		,""			,"mv_par09"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"10"		,"Serie Ate"	     		,"Serie Ate"	        	,"Serie Ate"	    		,"mv_cha"		,"C"		,3 				,0 				,0 				,"G"		,""			,"mv_par10"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"11"		,"Produto De"     			,"Produto De"     	    	,"Produto De"     			,"mv_chb"		,"C"		,15				,0 				,0 				,"G"		,""			,"mv_par11"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"SB1" 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"12"		,"Produto Ate"	     		,"Produto Ate"	        	,"Produto Ate"	    		,"mv_chc"		,"C"		,15				,0 				,0 				,"G"		,""			,"mv_par12"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"SB1" 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"13"		,"Grupo De"     			,"Grupo De"     	    	,"Grupo De"     			,"mv_chd"		,"C"		,4 				,0 				,0 				,"G"		,""			,"mv_par13"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"SBM" 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"14"		,"Grupo Ate"	     		,"Grupo Ate"	        	,"Grupo Ate"	    		,"mv_che"		,"C"		,4 				,0 				,0 				,"G"		,""			,"mv_par14"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"SBM" 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"15"		,"Fornecedor De"     		,"Fornecedor De"        	,"Fornecedor De"    		,"mv_chf"		,"C"		,6 				,0 				,0 				,"G"		,""			,"mv_par15"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"SA2" 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"16"		,"Loja De"	     			,"Loja De"	     	    	,"Loja De"	     			,"mv_chg"		,"C"		,2 				,0 				,0 				,"G"		,""			,"mv_par16"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"17"		,"Fornecedor Ate"     		,"Fornecedor Ate"       	,"Fornecedor Ate"   		,"mv_chh"		,"C"		,6 				,0 				,0 				,"G"		,""			,"mv_par17"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"SA2" 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"18"		,"Loja Ate"	     			,"Loja Ate"	     	    	,"Loja Ate"	     			,"mv_chi"		,"C"		,2 				,0 				,0 				,"G"		,""			,"mv_par18"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"19"		,"Ut. Preco Anterior?"		,"Ut. Preco Anterior?"    	,"Ut. Preco Anterior?"		,"mv_chj"		,"N"		,1 				,0 				,0 				,"C"		,""			,"mv_par19"	,"Sim"		,"Sim"			,"Sim"			,""			,""			,"Nao"		,"Nao"			,"Nao"			,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"20"		,"Tab Preco Anterior"  		,"Tab Preco Anterior"      	,"Tab Preco Anterior"  		,"mv_chk"		,"C"		,3 				,0 				,0 				,"G"		,""			,"mv_par20"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"DA0" 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"21"		,"Export. Excel?"			,"Export. Excel?"	    	,"Export. Excel?"			,"mv_chl"		,"N"		,1 				,0 				,0 				,"C"		,""			,"mv_par21"	,"Sim"		,"Sim"			,"Sim"			,""			,""			,"Nao"		,"Nao"			,"Nao"			,""			,""			,"Somente"	,"Somente"		,"Somente"		,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"22"		,"Totaliza por NF?"			,"Totaliza por NF?"	    	,"Totaliza por NF?"			,"mv_chm"		,"N"		,1 				,0 				,0 				,"C"		,""			,"mv_par22"	,"Sim"		,"Sim"			,"Sim"			,""			,""			,"Nao"		,"Nao"			,"Nao"			,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"23"		,"Tes Financeiro?"			,"Tes Financeiro?"	    	,"Tes Financeiro?"			,"mv_chn"		,"N"		,1 				,0 				,0 				,"C"		,""			,"mv_par23"	,"Sim"		,"Sim"			,"Sim"			,""			,""			,"Nao"		,"Nao"			,"Nao"			,""			,""			,"Ambos"	,"Ambos"		,"Ambos"		,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"23"		,"Tes Financeiro?"			,"Tes Financeiro?"	    	,"Tes Financeiro?"			,"mv_chn"		,"N"		,1 				,0 				,0 				,"C"		,""			,"mv_par23"	,"Gera"		,"Gera"			,"Gera"			,""			,""			,"Nao Gera"	,"Nao Gera"		,"Nao Gera"		,""			,""			,"Ambos"	,"Ambos"		,"Ambos"		,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"24"		,"Tes Estoque?"				,"Tes Estoque?"		    	,"Tes Estoque?"				,"mv_cho"		,"N"		,1 				,0 				,0 				,"C"		,""			,"mv_par24"	,"Gera"		,"Gera"			,"Gera"			,""			,""			,"Nao Gera"	,"Nao Gera"		,"Nao Gera"		,""			,""			,"Ambos"	,"Ambos"		,"Ambos"		,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"   " 		,"S"		,""				,""})

//
DBSELECTAREA("SX1")
DBSETORDER(1)
//

FOR I := 1 TO LEN(APERG)
	IF  !DBSEEK(CPERG+APERG[I,2])
		RECLOCK("SX1",.T.)
		FOR J := 1 TO FCOUNT()
			IF  j <= LEN(APERG[I])
				FIELDPUT(J,APERG[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT

RESTAREA(AALIASSX1)

RETURN()