#INCLUDE "Totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPR101   º Autor ³ Renato Ruy         º Data ³  21/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPR101


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório de Lançamentos de Remuneração"
Local cPict          := ""
Local titulo         := "Relatório de Lançamentos de Remuneração"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Local nAttempt		 := 0
Private lEnd         := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "CRP100" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "CRP100"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ6"

dbSelectArea("SZ6")
dbSetOrder(1)

ValidPerg()
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
Processa( {|| RunReport(Cabec1,Cabec2,Titulo,nLin)  }, "Gerando Relatório...")

MsgInfo("O arquivo foi gerado com sucesso!")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/05/15   º±±
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
Local _aDados := {}
Local aCabec  := {}
Local aRetorno:= {}
Local cCCRAnt := ""
Local cPosAnt := ""
Local cPosPai := ""
Local cQuebra := "1"
Local cWhere  := " "
Local cLin	  := " "
Local cLinFw  := " "
Local nContFw := 0
Local nContMsg:= 0
Local nBasCom := 0
Local nBasSof := 0
Local nBasHar := 0
Local nAbtVal := 0
Local nValPro := 0
Local nValSof := 0
Local nValHar := 0
Local nComPro := 0
Local nComSof := 0 
Local nComHar := 0
Local nValFed := 0
Local nFedera := 0
Local nComFed := 0
Local nConCer := 0
Local nConHar := 0
Local nConSof := 0
Local nContBio:= 0
Local nTotBio := 0
Local nContar := 0 
Local cPedAnt := ""
Local dDatAnt := CtoD("  /  /  ")
Local cArq 	  := ""
Local cVisita := "--</td>"
Local nVisita := 0
Local cNomArq := ""
Local nCA0009 := 0
Local nHdl    := -1
Local lReemb  := .T. //Verifica se e um reembolso ou reembolso parcial. (.T. - Reembolso Total ou .F. - Reembolso parcial)
Local lBioIFEN	:= Iif(AllTrim(MV_PAR01) > AllTrim(GetNewPar("MV_C101BIO","201903")), .F., .T.)
Local lMktFund	:= Iif(AllTrim(MV_PAR01) > AllTrim(GetNewPar("MV_C101MKT","201812")), .F., .T.)
Local nAttempt	:= 0
Private cEOL    := "CHR(13)+CHR(10)"
Private lAbortPrint  := .F.

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//Faço condição para alimentar o where
If 	   MV_PAR06 == 1
	cWhere := "% IN ('4','3') %"
	cNomArq:= "Geral Posto"
ElseIf MV_PAR06 == 2
	cWhere := "% = '2' %"
	cNomArq:= "Geral AC"
ElseIf MV_PAR06 == 3
	cWhere := "% = '1' %"
	cNomArq:= "Geral Canal"
	
	If AllTrim(MV_PAR04) == "CA0029" .And. AllTrim(MV_PAR05) == "CA0029"
		cWhere := "% = '1' AND Z6_CODCCR <> '070863' %"
	EndIf
	
Else
	cWhere := "% = '8' %"
	cNomArq:= "Geral Federacao"
EndIf

//Renato Ruy - 15/07/2016
//Viabilizar consulta em mais de um periodo.
If Len(AllTrim(MV_PAR01)) == 6
	cPeriodo := "% AND Z6_PERIODO = '"+AllTrim(MV_PAR01)+"' %"
ElseIf Len(AllTrim(MV_PAR01)) < 13
	Alert("O periodo informado está incorreto")
	Return .F.
Elseif "-" $ AllTrim(MV_PAR01)
	cPeriodo := "% AND Z6_PERIODO Between '"+SubStr(MV_PAR01,1,6)+"' And '" + SubStr(MV_PAR01,8,6) + "' %"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BEGINSQL -> Busco dados Agrupados de Remuneração					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

If Select("QCRPR101") > 0
	DbSelectArea("QCRPR101")
	QCRPR101->(DbCloseArea())
EndIf

IncProc( "Consultando dados " + SubStr(cNomArq,7,10))
ProcessMessage()

If MV_PAR06 == 2
	BeginSql Alias "QCRPR101"
		Column Z6_DTPEDI	As Date
		Column Z6_VERIFIC	As Date
		Column Z6_VALIDA	As Date
		Column Z6_DTEMISS	As Date
		Column Z6_DTPGTO	As Date
		Column DT_PEDANT	As Date
		
		%NoParser%
		
		SELECT
		Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		SZ3.Z3_CODENT ,
		SZ3.Z3_DESENT,
	    Z6_TIPED,
	    DECODE(Z6_TIPO,    	'RECANT','RECEBIDO ANTERIORMENTE',
							'REEMBO', 'REEMBOLSO',
							'NAOPAG', 'VOUCHER ORIGEM NAO REMUNERADO',
							'PNOPAG', 'PEDIDO NAO REMUNERADO',	
							'RETIFI', 'RETIFICACAO',
		    				'RENOVA','RENOVACAO',
		    				'ENTHAR', 'HARDWARE AVULSO',
		    				'SERVER', 'PRODUTO SERVIDOR',
		    				'PAGANT', 'PAGO ANTERIORMENTE',
		    				'VERIFI', 'VERIFICACAO') STATPED,
	    CASE WHEN  (SUM(Z6_VLRPROD) = 0 AND SUM(Z6_VALCOM) = 0) OR Z6_TIPO IN ('RETIFI','PAGANT','EXTRA') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CER,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0 WHEN Z6_TIPO = 'REEMBO' THEN -1  ELSE 1 END CONT_CERHW,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT','ENTHAR') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CERSW,
		SZ3.Z3_CODFED,
		SZ3.Z3_DESFED,
		SZ3.Z3_CODCAN,
		SZ3.Z3_DESCAN,
		SZ3.Z3_CODCAN2,
		SZ3.Z3_DESCAII,
		SZ3.Z3_CODAC,
		SZ3.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_DESAR,
		SZ3.Z3_CODCCR,
		SZ33.Z3_DESENT Z3_CCRCOM,
		Z6_TPENTID,
		Z6_PRODUTO,
		Z6_DESCRPR,
		Z6_DTPEDI,
		Z6_VERIFIC,
		Z6_VALIDA,
		Z6_DTEMISS,
		Z6_CODVEND,
		Z6_NOMVEND,
		Z6_RECORI,
		Z6_PEDORI,
		Z6_CODCCR,
		Z6_CCRCOM,
		Z6_PEDSITE,
		Z6_PEDGAR,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Z6_GRUPO,
		Z6_DESGRU,
		SUM(DECODE(Z6_CATPROD,'1',Z6_VLRPROD,0)) VALOR_HARDWARE,
		SUM(DECODE(Z6_CATPROD,'1',Z6_BASECOM,0)) BASE_HARDWARE,
		SUM(DECODE(Z6_CATPROD,'1',Z6_VALCOM ,0)) COMHAR,
		SUM(DECODE(Z6_CATPROD,'2',Z6_VLRPROD,0)) VALOR_SOFTWARE,
		SUM(DECODE(Z6_CATPROD,'2',Z6_BASECOM,0)) BASE_SOFTWARE,
		SUM(DECODE(Z6_CATPROD,'2',Z6_VALCOM ,0)) COMSOF,
		SUM(Z6_VLRABT) VLR_ABATIMENTO,
		SUM(Z6_VLRPROD) VALOR_PRODUTO,
		SUM(Z6_BASECOM) BASE_COMISSAO,
		SUM(Z6_VALCOM) VALOR_COMISSAO,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    SZ32.Z3_ESTADO,
	    SZ32.Z3_CODENT CODENT,
	    SZ32.Z3_DESENT DESENT,
	    DECODE(SZ32.Z3_ESTADO, 'AC','Norte','RO','Norte','AM','Norte','PA','Norte','TO','Norte','RR','Norte','AP', 'Norte',
                          'MA','Nordeste','PI','Nordeste','CE','Nordeste','RN','Nordeste','PB','Nordeste','PE','Nordeste','AL','Nordeste','SE','Nordeste','BA','Nordeste',
                          'MT','Centro-Oeste','GO','Centro-Oeste','DF','Centro-Oeste','MS','Centro-Oeste',
                          'ES','Sudeste','MG','Sudeste','SP','Sudeste','RJ','Sudeste',
                          'PR','Sul','SC','Sul','RS','Sul',
                          'Nao Informado') REGIAO,
       Z6_DESREDE
		FROM %Table:SZ6% SZ6
	  	JOIN %Table:SZ3% SZ3 ON SZ3.Z3_FILIAL = %xFilial:SZ3% AND Z6_CODAC = SZ3.Z3_CODENT AND SZ3.Z3_TIPENT = '2' AND SZ3.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = %xFilial:SZH% AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ3% SZ32 ON SZ32.Z3_FILIAL = %xFilial:SZ3% AND Z6_CODPOS = SZ32.Z3_CODGAR AND SZ32.Z3_CODGAR > '0' AND SZ32.Z3_TIPENT = '4' AND SZ32.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ3%  SZ33 ON SZ33.Z3_FILIAL = ' ' AND Z6_CODCCR = SZ33.Z3_CODENT AND SZ33.D_E_L_E_T_ = ' '
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = %xFilial:SZ6% 
		%Exp:cPeriodo% 
		AND SubStr(Z6_CODAC,1,4)   Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND z6_tpentid IN ('2','5') 
		GROUP BY
		Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		SZ3.Z3_CODENT ,
	    SZ3.Z3_DESENT,
	    Z6_TIPED,
		SZ3.Z3_CODFED,
		SZ3.Z3_DESFED,
		SZ3.Z3_CODCAN,
		SZ3.Z3_DESCAN,
		SZ3.Z3_CODCAN2,
		SZ3.Z3_DESCAII,
		SZ3.Z3_CODAC,
		SZ3.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_DESAR,
		SZ3.Z3_CODCCR,
    	SZ33.Z3_DESENT,
		Z6_TPENTID,
		Z6_PRODUTO,
		Z6_DESCRPR,
		Z6_DTPEDI,
		Z6_VERIFIC,
		Z6_VALIDA,
		Z6_DTEMISS,
		Z6_CODVEND,
		Z6_NOMVEND,
		Z6_RECORI,
		Z6_PEDORI,
		Z6_CODCCR,
		Z6_CCRCOM,
		Z6_PEDSITE,
		Z6_PEDGAR,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU, 
		Z6_CODAGE,
		Z6_NOMEAGE,
		Z6_GRUPO,
		Z6_DESGRU,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    SZ32.Z3_ESTADO,
		SZ32.Z3_CODENT,
	    SZ32.Z3_DESENT,
	    Z6_DESREDE
		ORDER BY SZ3.Z3_CODENT
		
	EndSql
ElseIf MV_PAR06 == 1
		BeginSql Alias "QCRPR101"
		Column Z6_DTPEDI	As Date
		Column Z6_VERIFIC	As Date
		Column Z6_VALIDA	As Date
		Column Z6_DTEMISS	As Date
		Column Z6_DTPGTO	As Date
		Column DT_PEDANT	As Date
		
		%NoParser%
		
		WITH QFED1 AS
		(SELECT Z6_FILIAL FILIAL1, Z6_PEDGAR PEDGAR, SUM(Z6_VALCOM) VALOR FROM %Table:SZ6% Z6 JOIN %Table:SZ3% Z3 ON Z3_FILIAL = ' ' AND
		 Z3_CODENT = Z6.Z6_CODFED AND Z3_RETPOS != 'N' AND Z6.D_E_L_E_T_ = ' 'WHERE Z6_FILIAL = ' ' %Exp:cPeriodo%  AND Z6.D_E_L_E_T_ = ' ' AND Z6_TIPO != 'DESCON'
		 AND Z6_TPENTID = '8' AND Z6_PEDGAR > '0'
		 GROUP BY Z6_FILIAL, Z6_PEDGAR),
		 QFED2 AS
		(SELECT Z6_FILIAL FILIAL2, Z6_PEDSITE PEDSITE, Z6_PRODUTO PRODUTO, SUM(Z6_VALCOM) VALOR FROM %Table:SZ6% Z6 JOIN %Table:SZ3% Z3 ON Z3_FILIAL = ' ' AND
		 Z3_CODENT = Z6.Z6_CODFED AND Z3_RETPOS != 'N' AND Z6.D_E_L_E_T_ = ' 'WHERE Z6_FILIAL = ' ' %Exp:cPeriodo%  AND Z6.D_E_L_E_T_ = ' '
		 AND Z6_TPENTID = '8' AND Z6_PEDSITE > '0'
		 GROUP BY Z6_FILIAL, Z6_PEDSITE, Z6_PRODUTO)
		
		SELECT
		Z6_TIPO ,
		SZ3.Z3_CODENT ,
		SZ3.Z3_DESENT,
		SZ3.Z3_TIPENT,
	    DECODE(Z6_TIPO,    	'RECANT','RECEBIDO ANTERIORMENTE',
							'REEMBO', 'REEMBOLSO',
							'NAOPAG', 'VOUCHER ORIGEM NAO REMUNERADO',
							'PNOPAG', 'PEDIDO NAO REMUNERADO',	
							'RETIFI', 'RETIFICACAO',
		    				'RENOVA','RENOVACAO',
		    				'ENTHAR', 'HARDWARE AVULSO',
		    				'SERVER', 'PRODUTO SERVIDOR',
		    				'PAGANT', 'PAGO ANTERIORMENTE',
		    				'VERIFI', 'VERIFICACAO') STATPED,
	    CASE WHEN  (SUM(Z6_VLRPROD) = 0 AND SUM(Z6_VALCOM) = 0) OR Z6_TIPO IN ('RETIFI','PAGANT','EXTRA') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CER,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0 WHEN Z6_TIPO = 'REEMBO' THEN -1  ELSE 1 END CONT_CERHW,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT','ENTHAR') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CERSW,
		SZ3.Z3_CODFED,
		SZ32.Z3_CODAC,
		SZ32.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_GRUPOIT,
		SZ32.Z3_DESENT Z3_CCRCOM,
		Z6_CODPOS,
		Z6_PRODUTO,
		Z6_DESCRPR,
		Z6_DTPEDI,
		Z6_VERIFIC,
		Z6_VALIDA,
		Z6_DTEMISS,
		Z6_PEDORI,
		Z6_CODCCR,
		Z6_CCRCOM,
		Z6_PEDSITE,
		Z6_PEDGAR,
		ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Z6_DESGRU,
		SUM(DECODE(Z6_CATPROD,'1',Z6_VLRPROD,0)) VALOR_HARDWARE,
		SUM(DECODE(Z6_CATPROD,'1',Z6_BASECOM,0)) BASE_HARDWARE,
		SUM(DECODE(Z6_CATPROD,'1',Z6_VALCOM ,0)) COMHAR,
		SUM(DECODE(Z6_CATPROD,'2',Z6_VLRPROD,0)) VALOR_SOFTWARE,
		SUM(DECODE(Z6_CATPROD,'2',Z6_BASECOM,0)) BASE_SOFTWARE,
		SUM(DECODE(Z6_CATPROD,'2',Z6_VALCOM ,0)) COMSOF,
		SUM(Z6_VLRABT) VLR_ABATIMENTO,
		SUM(Z6_VLRPROD) VALOR_PRODUTO,
		SUM(Z6_BASECOM) BASE_COMISSAO,
		SUM(Z6_VALCOM) VALOR_COMISSAO,
		Z6_NTITULA,
	    Z6_NOMEAGE,
	    SZ3.Z3_ESTADO,
	    SZ3.Z3_QUEBRA,
	    SZ32.Z3_CODENT CODENT,
	    SZ32.Z3_DESENT DESENT,
	    qfed1.VALOR valor1,
	    qfed2.VALOR valor2,
	    DECODE(SZ3.Z3_ESTADO, 'AC','Norte','RO','Norte','AM','Norte','PA','Norte','TO','Norte','RR','Norte','AP', 'Norte',
                          'MA','Nordeste','PI','Nordeste','CE','Nordeste','RN','Nordeste','PB','Nordeste','PE','Nordeste','AL','Nordeste','SE','Nordeste','BA','Nordeste',
                          'MT','Centro-Oeste','GO','Centro-Oeste','DF','Centro-Oeste','MS','Centro-Oeste',
                          'ES','Sudeste','MG','Sudeste','SP','Sudeste','RJ','Sudeste',
                          'PR','Sul','SC','Sul','RS','Sul',
                          'Nao Informado') REGIAO,
       Z6_DESREDE
		FROM %Table:SZ6% SZ6
	  	JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = %xFilial:SZ3% AND Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' '
	  	LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = %xFilial:SZH% AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ3% SZ32 ON SZ32.Z3_FILIAL = %xFilial:SZ3% AND Z6_CODCCR = SZ32.Z3_CODENT AND SZ32.D_E_L_E_T_ = ' '
		LEFT JOIN QFED1 QFED1 ON QFED1.PEDGAR = Z6_PEDGAR
    	LEFT JOIN QFED2 QFED2 ON QFED2.PEDSITE = Z6_PEDSITE AND QFED2.PRODUTO = Z6_PRODUTO
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = %xFilial:SZ6%
		%Exp:cPeriodo%                            
		AND SubStr(Z6_CODAC,1,4)   Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND Z6_CODCCR  Between %Exp:MV_PAR07% And %Exp:MV_PAR08% 
		AND z6_tpentid %Exp:cWhere%
		GROUP BY
		Z6_TIPO ,
		SZ3.Z3_CODENT ,
		SZ3.Z3_DESENT,
		SZ3.Z3_TIPENT,
		SZ3.Z3_CODFED,
		SZ32.Z3_CODAC,
		SZ32.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_GRUPOIT,
		SZ32.Z3_DESENT,
		Z6_CODPOS,
		Z6_PRODUTO,
		Z6_DESCRPR,
		Z6_DTPEDI,
		Z6_VERIFIC,
		Z6_VALIDA,
		Z6_DTEMISS,
		Z6_CODVEND,
		Z6_NOMVEND,
		Z6_PEDORI,
		Z6_CODCCR,
		Z6_CCRCOM,
		Z6_PEDSITE,
		Z6_PEDGAR,
		ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU, 
		Z6_CODAGE,
		Z6_NOMEAGE,
		Z6_DESGRU,
		Z6_NTITULA,
	    Z6_NOMEAGE,
	    SZ32.Z3_CODENT,
	    SZ32.Z3_DESENT,
	    qfed1.VALOR,
	    qfed2.VALOR,
	    SZ3.Z3_ESTADO,
	    SZ3.Z3_QUEBRA,
	    Z6_DESREDE
		ORDER BY SZ6.Z6_CODCCR, SZ3.Z3_QUEBRA, SZ3.Z3_GRUPOIT, SZ3.Z3_CODENT
		
	EndSql
Else
BeginSql Alias "QCRPR101"
		Column Z6_DTPEDI	As Date
		Column Z6_VERIFIC	As Date
		Column Z6_VALIDA	As Date
		Column Z6_DTEMISS	As Date
		Column Z6_DTPGTO	As Date
		Column DT_PEDANT	As Date
		
		%NoParser%
		
		SELECT
		Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		SZ3.Z3_CODENT ,
		SZ3.Z3_DESENT,
	    Z6_TIPED,
	    DECODE(Z6_TIPO,    	'RECANT','RECEBIDO ANTERIORMENTE',
							'REEMBO', 'REEMBOLSO',
							'NAOPAG', 'VOUCHER ORIGEM NAO REMUNERADO',
							'PNOPAG', 'PEDIDO NAO REMUNERADO',	
							'RETIFI', 'RETIFICACAO',
		    				'RENOVA','RENOVACAO',
		    				'ENTHAR', 'HARDWARE AVULSO',
		    				'SERVER', 'PRODUTO SERVIDOR',
		    				'PAGANT', 'PAGO ANTERIORMENTE',
		    				'VERIFI', 'VERIFICACAO') STATPED,
	    CASE WHEN (SUM(Z6_VLRPROD) = 0 AND SUM(Z6_VALCOM) = 0) OR Z6_TIPO IN ('RETIFI','PAGANT','EXTRA') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CER,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0 WHEN Z6_TIPO = 'REEMBO' THEN -1  ELSE 1 END CONT_CERHW,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT','ENTHAR') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CERSW,
		SZ3.Z3_CODFED,
		SZ3.Z3_DESFED,
		SZ3.Z3_CODCAN,
		SZ3.Z3_DESCAN,
		SZ3.Z3_CODCAN2,
		SZ3.Z3_DESCAII,
		SZ3.Z3_CODAC,
		SZ3.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_DESAR,
		SZ3.Z3_CODCCR,
		SZ33.Z3_DESENT Z3_CCRCOM,
		Z6_TPENTID,
		Z6_PRODUTO,
		Z6_DESCRPR,
		Z6_DTPEDI,
		Z6_VERIFIC,
		Z6_VALIDA,
		Z6_DTEMISS,
		Z6_CODVEND,
		Z6_NOMVEND,
		Z6_RECORI,
		Z6_PEDORI,
		Z6_CODCCR,
		Z6_CCRCOM,
		Z6_PEDSITE,
		Z6_PEDGAR,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Z6_GRUPO,
		Z6_DESGRU,
		SUM(DECODE(Z6_CATPROD,'1',Z6_VLRPROD,0)) VALOR_HARDWARE,
		SUM(DECODE(Z6_CATPROD,'1',Z6_BASECOM,0)) BASE_HARDWARE,
		SUM(DECODE(Z6_CATPROD,'1',Z6_VALCOM ,0)) COMHAR,
		SUM(DECODE(Z6_CATPROD,'2',Z6_VLRPROD,0)) VALOR_SOFTWARE,
		SUM(DECODE(Z6_CATPROD,'2',Z6_BASECOM,0)) BASE_SOFTWARE,
		SUM(DECODE(Z6_CATPROD,'2',Z6_VALCOM ,0)) COMSOF,
		SUM(Z6_VLRABT) VLR_ABATIMENTO,
		SUM(Z6_VLRPROD) VALOR_PRODUTO,
		SUM(Z6_BASECOM) BASE_COMISSAO,
		SUM(Z6_VALCOM) VALOR_COMISSAO,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    SZ32.Z3_ESTADO,
	    SZ32.Z3_CODENT CODENT,
	    SZ32.Z3_DESENT DESENT,
	    DECODE(SZ32.Z3_ESTADO, 'AC','Norte','RO','Norte','AM','Norte','PA','Norte','TO','Norte','RR','Norte','AP', 'Norte',
                          'MA','Nordeste','PI','Nordeste','CE','Nordeste','RN','Nordeste','PB','Nordeste','PE','Nordeste','AL','Nordeste','SE','Nordeste','BA','Nordeste',
                          'MT','Centro-Oeste','GO','Centro-Oeste','DF','Centro-Oeste','MS','Centro-Oeste',
                          'ES','Sudeste','MG','Sudeste','SP','Sudeste','RJ','Sudeste',
                          'PR','Sul','SC','Sul','RS','Sul',
                          'Nao Informado') REGIAO,
       Z6_DESREDE
		FROM %Table:SZ6% SZ6
	  	JOIN %Table:SZ3% SZ3 ON SZ3.Z3_FILIAL = %xFilial:SZ3% AND Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ3% SZ32 ON SZ32.Z3_FILIAL = %xFilial:SZ3% AND Z6_CODPOS = SZ32.Z3_CODGAR AND SZ32.Z3_CODGAR > '0' AND SZ32.Z3_TIPENT = '4' AND SZ32.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZ3% SZ33 ON SZ33.Z3_FILIAL = ' ' AND Z6_CODCCR = SZ33.Z3_CODENT AND SZ33.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = %xFilial:SZH% AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = %xFilial:SZ6%
		%Exp:cPeriodo% 
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND Z6_TPENTID %Exp:cWhere%
		GROUP BY
		Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		SZ3.Z3_CODENT ,
	    SZ3.Z3_DESENT,
	    Z6_TIPED,
		SZ3.Z3_CODFED,
		SZ3.Z3_DESFED,
		SZ3.Z3_CODCAN,
		SZ3.Z3_DESCAN,
		SZ3.Z3_CODCAN2,
		SZ3.Z3_DESCAII,
		SZ3.Z3_CODAC,
		SZ3.Z3_DESAC,
		SZ3.Z3_CODAR,
		SZ3.Z3_DESAR,
		SZ3.Z3_CODCCR,
    	SZ33.Z3_DESENT,
		Z6_TPENTID,
		Z6_PRODUTO,
		Z6_DESCRPR,
		Z6_DTPEDI,
		Z6_VERIFIC,
		Z6_VALIDA,
		Z6_DTEMISS,
		Z6_CODVEND,
		Z6_NOMVEND,
		Z6_RECORI,
		Z6_PEDORI,
		Z6_CODCCR,
		Z6_CCRCOM,
		Z6_PEDSITE,
		Z6_PEDGAR,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU, 
		Z6_CODAGE,
		Z6_NOMEAGE,
		Z6_GRUPO,
		Z6_DESGRU,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    SZ32.Z3_ESTADO,
		SZ32.Z3_CODENT,
	    SZ32.Z3_DESENT,
	    Z6_DESREDE
		ORDER BY SZ3.Z3_CODENT
		
	EndSql
EndIf

QCRPR101->(dbGoTop())

MemoWrite("C:\DATA\a\CRPR101.sql", GetLastQuery()[2])

//Tratamento para consulta e gerar barra de processamento no relatorio.
If Select("QCRPR110") > 0
	DbSelectArea("QCRPR110")
	QCRPR110->(DbCloseArea())
EndIf

If MV_PAR06 == 2
	BeginSql Alias "QCRPR110"
	SELECT COUNT(*) CONTAR  FROM (
							SELECT Z6_PEDGAR, Z6_PEDSITE
							FROM %Table:SZ6% SZ6
							WHERE
							SZ6.%Notdel%
							AND Z6_FILIAL = %xFilial:SZ6%
							%Exp:cPeriodo% 
							AND SubStr(Z6_CODAC,1,4)   Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
							AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
							AND z6_tpentid IN ('2','5') 
							GROUP BY Z6_PEDGAR, Z6_PEDSITE)
	EndSql
ElseIf MV_PAR06 == 1
	BeginSql Alias "QCRPR110"
	SELECT COUNT(*) CONTAR  FROM (
							SELECT Z6_PEDGAR, Z6_PEDSITE
							FROM %Table:SZ6% SZ6
							WHERE
							SZ6.%Notdel%
							AND Z6_FILIAL = %xFilial:SZ6%
							%Exp:cPeriodo%                            
							AND SubStr(Z6_CODAC,1,4)   Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
							AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
							AND Z6_CODCCR  Between %Exp:MV_PAR07% And %Exp:MV_PAR08% 
							AND z6_tpentid %Exp:cWhere%
							GROUP BY Z6_PEDGAR, Z6_PEDSITE)
	EndSql
Else
	BeginSql Alias "QCRPR110"
	SELECT COUNT(*) CONTAR  FROM (
							SELECT Z6_PEDGAR, Z6_PEDSITE
							FROM %Table:SZ6% SZ6
							WHERE
							SZ6.%Notdel%
							AND Z6_FILIAL = %xFilial:SZ6%
							%Exp:cPeriodo% 
							AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
							AND Z6_TPENTID %Exp:cWhere%
							GROUP BY Z6_PEDGAR, Z6_PEDSITE)
	
	EndSql
Endif 

nContar := QCRPR110->CONTAR

ProcRegua(nContar)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Alimento a variavel com o código do pedido para fazer comparação
If MV_PAR06 == 1
	cCCRAnt := QCRPR101->Z6_CODCCR
	cPosAnt := QCRPR101->Z3_CODENT
	cPosPai := QCRPR101->Z3_GRUPOIT
	cQuebra := QCRPR101->Z3_QUEBRA
Else
	cCCRAnt := QCRPR101->Z3_CODENT
EndIf

If MV_PAR09 == 1 .And. cQuebra != "2"
	cNomArq := AllTrim(Posicione("SZ3",1,xFilial("SZ3")+cCCRAnt,"Z3_DESENT"))+" - "+AllTrim(cCCRAnt)
Elseif MV_PAR09 == 1 .And. cQuebra == "2"
	cNomArq := AllTrim(Posicione("SZ3",1,xFilial("SZ3")+cPosAnt,"Z3_DESENT"))+" - "+AllTrim(cCCRAnt)
EndIf

//Tenta corrigir espaços tabulados no nome
If At(CHR(9),cNomArq) > 0
	cNomArq := StrTran(cNomArq,CHR(9),"")
EndIf

//Armazena o caminho para gravação.
cArq    := AllTrim(MV_PAR10) + StrTran(cNomArq,"/", " ") +".htm"

//Evita que o arquivo não seja gerado
While nHdl < 0 .And. nAttempt <= 10
	If File(cArq)
		If fErase(cArq) != 0
			Alert("Não foi possível excluir o arquivo já existente na pasta Temp " + cArq + cEOL + "Por gentileza, limpe os arquivos da pasta %TEMP% e tente novamente")
			Return {" "," ",0}
		EndIf
	EndIf
	
	nHdl := fCreate(cArq)
	Sleep(2000)
	nAttempt++
EndDo

If valtype(MV_PAR10) == "N"
	Alert("A pasta deve ser informada para gravação!")
	Return {" "," ",0}
ElseIf nHdl == -1
	Alert("O Sistema não pode gerar o arquivo: "+cArq+", porque o arquivo esta aberto ou a pasta destino sem permissão a gravar arquivos!"+cEOL+"O Processo não continuará!")
	Return {" "," ",0}
Endif

//Adiciono o cabeçalho para o relatório.
If nHdl != -1
	cLin := "<table border='1'><tr><td>Cod.Ent.</td>"
	cLin += "<td width='800'>Des. Entidade</td>"
	cLin += "<td width='800'>Desc. Agente Val.</td>"
	cLin += "<td>Cod. Produto</td>"
	cLin += "<td width='800'>Produto</td>"
	cLin += "<td>Pedido</td>"
	cLin += "<td>Status Pedido</td>"
	cLin += "<td>Dt.Pedido</td>"
	cLin += "<td>Dt.Validação</td>"
	cLin += "<td>Dt.Verificação</td>"
	cLin += "<td>Dt.Emissão/Renovação</td>"
	cLin += "<td width='800'>Nome Cliente</td>"
	//18/12/15 - Retirada validação de federação.
	//If cWhere <> "8"
		cLin += "<td>Valot Tot. Base</td>"
		cLin += "<td>Base Software</td>"
		cLin += "<td>Base Hardware</td>"
	//Else
	//	cLin += "<td>Valor Faturado</td>"
	//EndIf 
	cLin += "<td>Tipo Voucher</td>"
	cLin += "<td>Ped. Anterior</td>"
	cLin += "<td>Dt.Pedido Anterior</td>"
	cLin += "<td width='800'>Desc. CCR</td>"
	cLin += "<td>Cód. AC</td>"
	cLin += "<td width='800'>Desc. AC</td>"
	cLin += "<td width='800'>Desc. Grupo</td>"
	//If cWhere <> "8"
		cLin += "<td>Val. Abatimento</td>"
		cLin += "<td>Val. Bruto Soft</td>"
		cLin += "<td>Val. Bruto Hard</td>"
	//EndIf
	//If cWhere <> "8"
		cLin += "<td>Valor Bruto Total</td>"
		cLin += "<td>Val. Comiss. Soft</td>"
		cLin += "<td>Val. Comiss. Hard</td>"
		cLin += "<td>Valor Tot. Comiss.</td>"
		cLin += "<td>Val. Comissão Fed.</td>"
		cLin += "<td>Val. Tot. Comiss+Fed.</td>"
	//Else
	//	cLin += "<td>Val. Tot. Comiss.Fed.</td>"
	//EndIf
	cLin += "<td>Contagem Geral</td>"
	//If cWhere <> "8"
		cLin += "<td>Contagem Soft.</td>"
		cLin += "<td>Contagem Hard.</td>"
	//EndIf
	//Solicitante: Priscila Kuhn - 12/01/16
	//Biometria IFEN
	If MV_PAR06 == 3
		cLin += "<td>Contagem Biometria</td>"
	EndIf
	If AllTrim(Str(MV_PAR06)) $ "1/2/3/4" .And. MV_PAR11 == 1
		cLin += "<td>Cod.Posto Val.</td>"
		cLin += "<td>Desc.Posto Val.</td>"	
		cLin += "<td>Link Campanha</td>"	
	EndIf
	cLin += "<td>UF</td>"
	cLin += "<td>REGIAO</td></tr>"
	
	cLin := cLin + cEOL
	
	//Efetuo gravação de dados do relatório em arquivo.
	fWrite(nHdl,cLin)
EndIf

While !QCRPR101->(EOF())

	//Incrementa regua
	//SetRegua(QCRPR101->(LastRec()))
	//IncRegua()
	IncProc( "Exportando --> " + Iif(!Empty(QCRPR101->Z6_PEDGAR),"Pedido GAR: " + QCRPR101->Z6_PEDGAR, "Pedido SITE: " + QCRPR101->Z6_PEDSITE ) )
	If nContMsg >= 80
		nContMsg := 0
		ProcessMessage()
	Else
		nContMsg++
	Endif
	
	//Renato Ruy - 06/09/17
	//Novo tratamento para quebra por IT
	If MV_PAR06 == 1
		cQuebra := QCRPR101->Z3_QUEBRA
	Endif 
	
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
		//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If 	(AllTrim(cCCRAnt) <> AllTrim(QCRPR101->Z6_CODCCR) .And. MV_PAR09 == 1 .And. MV_PAR06 == 1) .OR.;
	 	(AllTrim(cCCRAnt) <> AllTrim(QCRPR101->Z3_CODENT) .And. MV_PAR09 == 1 .And. MV_PAR06 != 1) .OR.;
	 	(AllTrim(cPosAnt) <> AllTrim(QCRPR101->Z3_CODENT)  .And. (Empty(cPosPai) .Or. AllTrim(cPosPai) <> AllTrim(QCRPR101->Z3_GRUPOIT));
	 	 .And. MV_PAR09 == 1 .And. MV_PAR06 == 1 .And. QCRPR101->Z3_QUEBRA == "2")  
		
		//Grava Totais
		If nHdl != -1
		
			//Gravo se faltou linhas na memoria
			If nContFw > 0
				fWrite(nHdl,cLinFw)
				cLinFw  := " "
				nContFw := 0
			EndIf
		
			cLin := "<tr><td>"+Iif(MV_PAR06 == 1 .Or. (cCCRAnt == "CA0009" .And. lBioIFEN).Or. AllTrim(cCCRAnt) == "FEN"," Subtotal </td>"," Total Geral </td>")
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td>"+TRANSFORM(nBasCom, "@E 999,999,999.99")+"</td>"
			//If cWhere <> "8"
				cLin += "<td>"+TRANSFORM(nBasSof, "@E 999,999,999.99")+"</td>"
				cLin += "<td>"+TRANSFORM(nBasHar, "@E 999,999,999.99")+"</td>"
			//EndIf
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			//If cWhere <> "8"
				cLin += "<td>"+TRANSFORM(nAbtVal, "@E 999,999,999.99")+"</td>"
				cLin += "<td>"+TRANSFORM(nValSof, "@E 999,999,999.99")+"</td>"
				cLin += "<td>"+TRANSFORM(nValHar, "@E 999,999,999.99")+"</td>"
				cLin += "<td>"+TRANSFORM(nValPro, "@E 999,999,999.99")+"</td>"
				cLin += "<td>"+TRANSFORM(nComSof, "@E 999,999,999.99")+"</td>"
				cLin += "<td>"+TRANSFORM(nComHar, "@E 999,999,999.99")+"</td>"
			//EndIf
			cLin += "<td>"+TRANSFORM(nComPro, "@E 999,999,999.99")+"</td>"
			//If cWhere <> "8"
				cLin += "<td>"+TRANSFORM(nValFed, "@E 999,999,999.99")+"</td>"
				cLin += "<td>"+TRANSFORM(nComFed, "@E 999,999,999.99")+"</td>"
			//EndIf
			cLin += "<td>"+TRANSFORM(nConCer, "@E 999,999,999.99")+"</td>"
			//If cWhere <> "8"
				cLin += "<td>"+TRANSFORM(nConSof, "@E 999,999,999.99")+"</td>"
				cLin += "<td>"+TRANSFORM(nConHar, "@E 999,999,999.99")+"</td>"				
			//EndIf
			If MV_PAR06 == 3
				cLin += "<td>"+TRANSFORM(nTotBio, "@E 999,999,999.99")+";
			EndIf
			If AllTrim(Str(MV_PAR06)) $ "1/2/3/4" .And. MV_PAR11 == 1
				cLin += "<td>--</td>"
				cLin += "<td>--</td>"
				cLin += "<td>--</td>"
			EndIf
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td></tr>"
			
			cLin := cLin + cEOL
			
			//Efetuo gravação de dados do relatório em arquivo.
			fWrite(nHdl,cLin)  
			
			If MV_PAR06 == 2 .And. AllTrim(cCCRAnt) == "FEN"
				
				If Select("TMPFEN") > 0
					DbSelectArea("TMPFEN")
					TMPFEN->(DbCloseArea())
				EndIf

				BeginSql Alias "TMPFEN"
				
					SELECT COUNT(*) NUMGAR, SUM(VALFAT) VALFAT, SUM(VALIFEN) VALIFEN FROM (
					SELECT Z6_PEDGAR PEDGAR, SUM(Z6_VLRPROD) VALFAT, SUM(Z6_VLRPROD) * 0.02 VALIFEN 
					FROM %Table:SZ6% SZ6 
					WHERE 
					Z6_FILIAL = ' ' 
					%Exp:cPeriodo%
					AND Z6_CODENT = 'CA0009' AND 
					SZ6.%NotDel%
					GROUP BY Z6_PEDGAR)
				
				Endsql
				
				If lMktFund
					cLin := "<tr><td> FUNDOS DE MARKETING -> </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> QUANTIDADE PEDIDOS: " + AllTrim(Str(TMPFEN->NUMGAR)) + "  </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td>"+TRANSFORM(TMPFEN->VALFAT, "@E 999,999,999.99") + "  </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td>"+TRANSFORM(TMPFEN->VALIFEN, "@E 999,999,999.99")+"</td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td></tr>""
					
					//Armazena o valor para ser exibido no totalizador.
					nComPro += TMPFEN->VALIFEN
					
					cLin := cLin + cEOL
					
					//Efetuo gravação de dados do relatório em arquivo.
					fWrite(nHdl,cLin)
				EndIf
				
				cLin := "<tr><td> Total Geral </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td>"+TRANSFORM(nComPro, "@E 999,999,999.99")+"</td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td></tr></table>"
				
				cLin := cLin + cEOL
				
				//Efetuo gravação de dados do relatório em arquivo.
				fWrite(nHdl,cLin)
			
			EndIf
			
			nVisita := 0
			nPortal := 0
			
			If MV_PAR06 == 1 .And. MV_PAR09 == 1
			
				cQuery := "SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSqlName("SZ6") + " WHERE Z6_TIPO = 'PORTAL' AND Z6_PEDGAR = 'PORTALASSI' "+ StrTran(cPeriodo,"%","") +" AND D_E_L_E_T_ = ' ' AND Z6_CODENT = '" + cCCRAnt + "'"
				
				If Select("TMPSIGN") > 0
					TMPSIGN->(dbCloseArea())
				EndIf
				
				PLSQuery( cQuery, "TMPSIGN" )
				
				If TMPSIGN->(!EOF())
	
						nPortal += TMPSIGN->Z6_VALCOM
						
						cLin := "<tr><td>Portal de Assinatura #1 - </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td>" + TRANSFORM(TMPSIGN->Z6_VALCOM, "@E 999,999,999.99")+"</td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						cLin += "<td> -- </td>"
						If MV_PAR12 == 1
							cLin += "<td> -- </td>"
							cLin += "<td> -- </td>"
							cLin += "<td> -- </td>"
						EndIf	
						
						cLin += "</tr>"
						
						cLin := cLin + cEOL
						
						//Efetuo gravação de dados do relatório em arquivo.
						fWrite(nHdl,cLin)
						TMPSIGN->(DbSkip())
				EndIf
			
			
				cQuery := " SELECT Z6_DESGRU, SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' "+ StrTran(cPeriodo,"%","") +" AND Z6_PRODUTO = 'VISITAEXTERNA' AND Z6_CODENT = '"+cCCRAnt+"' AND z6_tpentid = 'B' GROUP BY Z6_DESGRU"
				
				If Select("TMP") > 0
					DbSelectArea("TMP")
					TMP->(DbCloseArea())
				EndIf
				PLSQuery( cQuery, "TMP" )
				
				While !TMP->(EOF())
					
					nVisita += TMP->Z6_VALCOM
									
					cLin += "<tr><td> Visita Externa - "+ Iif("-"$TMP->Z6_DESGRU,"Sem Projeto", AllTrim(TMP->Z6_DESGRU))+ "</td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td>"+Iif(Select("TMP") > 0, TRANSFORM(TMP->Z6_VALCOM, "@E 999,999,999.99")+"</td>"," --  </td>")
					cLin += "<td> -- </td>"
					cLin += "<td>"+Iif(Select("TMP") > 0, TRANSFORM(TMP->Z6_VALCOM, "@E 999,999,999.99")+"</td>"," --  </td>")
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td></tr>"
					
					cLin := cLin + cEOL
					
					//Efetuo gravação de dados do relatório em arquivo.
					fWrite(nHdl,cLin)
					TMP->(DbSkip())
				Enddo
				
				nCA0009 := 0
				
				If MV_PAR06 == 3 .And. cCCRAnt == "CA0009" .And. lBioIFEN
				
					nCA0009 := nTotBio * 3
					
					cLin += "<tr><td> BIOMETRIA IFEN -> </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> QUANTIDADE PEDIDOS: " + AllTrim(Str(nTotBio)) + "  </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					//Multiplico o valor por R$ 3,00 - valor do certificado
					cLin += "<td>"+Iif(Select("TMP") > 0 .And. nComFed == 0, TRANSFORM(nCA0009, "@E 999,999,999.99")+"</td>"," --  </td>")
					cLin += "<td> -- </td>"
					cLin += "<td>"+Iif(Select("TMP") > 0 .And. nComFed > 0, TRANSFORM(nCA0009, "@E 999,999,999.99")+"</td>"," --  </td>")
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td></tr>"
					
					cLin := cLin + cEOL
					
					//Efetuo gravação de dados do relatório em arquivo.
					fWrite(nHdl,cLin)
						
				EndIf
				
				cLin := "<tr><td> Total Geral </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td>"+Iif(Select("TMP") > 0 .And. nComFed == 0, TRANSFORM(nComPro+Iif(lBioIFEN,nCA0009,0), "@E 999,999,999.99")+"</td>"," --  </td>")
				cLin += "<td> -- </td>"
				cLin += "<td>"+Iif(Select("TMP") > 0 .And. nComFed > 0, TRANSFORM(nComFed+Iif(lBioIFEN,nCA0009,0), "@E 999,999,999.99")+"</td>"," --  </td>")
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td></tr></table>"
				
				cLin := cLin + cEOL
				
				//Efetuo gravação de dados do relatório em arquivo.
				fWrite(nHdl,cLin)
				
			EndIf
			
			
		EndIf
		
		//Fecho o arquivo anterior
		fClose(nHdl)
		
		//Renato Ruy - 25/07/2018
		//Validar se existe arquivos e apaga
		If FILE(AllTrim(MV_PAR10)+cNomArq+".xls")
			FERASE(AllTrim(MV_PAR10)+cNomArq+".xls")
		Endif
		
		//Renato Ruy - Novo processo para converter em excel
		U_CRPR102(MV_PAR10, cNomArq)
		
		If MV_PAR06 == 1
			cCCRAnt := QCRPR101->Z6_CODCCR
			cPosAnt := QCRPR101->Z3_CODENT
			cPosPai := QCRPR101->Z3_GRUPOIT
			cQuebra := QCRPR101->Z3_QUEBRA
		Else
			cCCRAnt := QCRPR101->Z3_CODENT
		EndIf
		
		//Armazena o caminho para gravação.
		If cQuebra == "2"
			cNomArq := StrTran(AllTrim(Posicione("SZ3",1,xFilial("SZ3")+cPosAnt,"Z3_DESENT")),"/", " ")+" - "+AllTrim(cPosAnt)
			
			//Tenta corrigir espaços tabulados no nome
			If At(CHR(9),cNomArq) > 0
				cNomArq := StrTran(cNomArq,CHR(9),"")
			EndIf
			
			cArq    := AllTrim(MV_PAR10) + cNomArq +".htm"
		Else
			cNomArq := StrTran(AllTrim(Posicione("SZ3",1,xFilial("SZ3")+cCCRAnt,"Z3_DESENT")),"/", " ")+" - "+AllTrim(cCCRAnt)
			
			//Tenta corrigir espaços tabulados no nome
			If At(CHR(9),cNomArq) > 0
				cNomArq := StrTran(cNomArq,CHR(9),"")
			EndIf
			
			cArq    := AllTrim(MV_PAR10) + cNomArq +".htm"
		EndIf
		nHdl    := fCreate(cArq)
		
		If nHdl == -1
			Alert("O Sistema não pode gerar o arquivo: "+cArq+", porque o arquivo esta aberto ou a pasta destino sem permissão a gravar arquivos!"+cEOL+"O Processo não continuará!")
		Endif
		
		If nHdl != -1
			cLin := "<table><tr><td>Cod.Ent.</td>"
			cLin += "<td width='800'>Des. Entidade</td>"
			cLin += "<td width='800'>Desc. Agente Val.</td>"
			cLin += "<td>Cod. Produto</td>"
			cLin += "<td width='800'>Produto</td>"
			cLin += "<td>Pedido</td>"
			cLin += "<td>Status Pedido</td>"
			cLin += "<td>Dt.Pedido</td>"
			cLin += "<td>Dt.Validação</td>"
			cLin += "<td>Dt.Verificação</td>"
			cLin += "<td>Dt.Emissão/Renovação</td>"
			cLin += "<td width='800'>Nome Cliente</td>"
			cLin += "<td>Valot Tot. Base</td>"
			//If cWhere <> "8"
				cLin += "<td>Base Software</td>"
				cLin += "<td>Base Hardware</td>"
			//EndIf 
			cLin += "<td>Tipo Voucher</td>"
			cLin += "<td>Ped. Anterior</td>"
			cLin += "<td>Dt.Pedido Anterior</td>"
			cLin += "<td width='800'>Desc. CCR</td>"
			cLin += "<td>Cód. AC</td>"
			cLin += "<td>Desc. AC</td>"
			cLin += "<td width='800'>Desc. Grupo</td>"
			//If cWhere <> "8"
				cLin += "<td>Val. Abatimento</td>"
				cLin += "<td>Val. Bruto Soft</td>"
				cLin += "<td>Val. Bruto Hard</td>"
			//EndIf
			//If cWhere <> "8"
				cLin += "<td>Valor Bruto Total</td>"
				cLin += "<td>Val. Comiss. Soft</td>"
				cLin += "<td>Val. Comiss. Hard</td>"
				cLin += "<td>Valor Tot. Comiss.</td>"
				cLin += "<td>Val. Comissão Fed.</td>"
				cLin += "<td>Val. Tot. Comiss+Fed	.</td>"
			//Else
			//	cLin += "<td>Val. Tot. Comiss.Fed.</td>"
			//EndIf
			cLin += "<td>Contagem Geral</td>"
			//If cWhere <> "8"
				cLin += "<td>Contagem Soft.</td>"
				cLin += "<td>Contagem Hard.</td>"
			//EndIf
			If MV_PAR06 == 3
				cLin += "<td>Contagem Biometria</td>"
			EndIf
			If  AllTrim(Str(MV_PAR06)) $ "1/2/3/4" .And. MV_PAR11 == 1
				cLin += "<td>Cod.Posto Val.</td>"
				cLin += "<td>Desc.Posto Val.</td>"
				cLin += "<td>Link Campanha</td>"
			EndIf
			cLin += "<td>UF</td>"
			cLin += "<td>REGIAO</td></tr>"
			
			cLin := cLin + cEOL
			
			//Efetuo gravação de dados do relatório em arquivo.
			fWrite(nHdl,cLin)
		EndIf
		
		
		//Reinicia Totalizador
		nBasCom := 0
		nBasSof := 0
		nBasHar := 0
		nAbtVal := 0
		nValPro := 0
		nValSof := 0
		nValHar := 0
		nComPro := 0
		nComSof := 0
		nComHar := 0
		nValFed := 0
		nComFed := 0
		nConCer := 0
		nConHar := 0
		nConSof := 0
		nContBio:= 0
	EndIf
	
	If MV_PAR06 == 1	
		nFedera := QCRPR101->VALOR1 + QCRPR101->VALOR2
    EndIf
    
    //Fim da alteração - melhoria na busca de valores federação.
	
	//Alimenta totalizadores
	nBasCom += QCRPR101->BASE_COMISSAO
	nBasSof += QCRPR101->BASE_SOFTWARE
	nBasHar += QCRPR101->BASE_HARDWARE
	nAbtVal += QCRPR101->VLR_ABATIMENTO
	nValPro += QCRPR101->VALOR_PRODUTO
	nValSof += QCRPR101->VALOR_SOFTWARE
	nValHar += QCRPR101->VALOR_HARDWARE
	nComPro += QCRPR101->VALOR_COMISSAO
	nComSof += QCRPR101->COMSOF
	nComHar += QCRPR101->COMHAR
	nValFed += Iif(MV_PAR06 == 1 ,nFedera,0)
	nComFed += Iif(MV_PAR06 == 1 ,nFedera+QCRPR101->VALOR_COMISSAO,0)
	
	//Renato Ruy - 16/03/17
	//Valida quando tem reembolso, para verificar se e parcial ou integral. 
	lReemb := .T.
	If "REEMBOLSO" $ QCRPR101->STATPED
		SZ5->(DbSetOrder(1))
		SZ5->(DbSeek(xFilial("SZ5")+QCRPR101->Z6_PEDGAR))
		If (0-(SZ5->Z5_VALORSW+SZ5->Z5_VALORHW)) != QCRPR101->VALOR_SOFTWARE+QCRPR101->VALOR_HARDWARE .And. (0-(SZ5->Z5_VALORSW)) != QCRPR101->VALOR_SOFTWARE .And. QCRPR101->BASE_COMISSAO != 0 
			lReemb := .F.
		Endif
	Endif
	
	//Somente faz a contagem se e reembolso total, pedido de verificacao, renovacao e hw avulso.
	If lReemb
		nConCer += QCRPR101->CONT_CER
		nConHar += QCRPR101->CONT_CERHW
		nConSof += QCRPR101->CONT_CERSW
	EndIf
	
	If MV_PAR06 == 3 .And. cCCRAnt == "CA0009"
		nContBio:= 0
		If QCRPR101->Z6_DTPEDI >= StoD('20151201') .AND.(QCRPR101->BASE_COMISSAO > 0 .OR. AllTrim(QCRPR101->Z6_PRODUTO) == 'IFENSRFA3PFCPC1AHV2') .AND.;
		 !('18' $ QCRPR101->Z6_PRODUTO) .And. !('SIMPLES' $ UPPER(QCRPR101->Z6_DESCRPR))
			nContBio:= 1
			nTotBio += 1
		EndIf
	EndIf 
	
	//Faco tratamento do voucher no programa, na consulta(Query) causou lentidao.
	If !Empty(QCRPR101->Z6_CODVOU)
		
		If AllTrim(QCRPR101->Z6_TIPVOU) $ "A/2/K/L"
			SZF->(DbSetOrder(2))
			If SZF->(DbSeek(xFilial("SZF")+QCRPR101->Z6_CODVOU))
			
				SZ5->(DbSetOrder(1))
				If SZ5->(DbSeek(xFilial("SZ5")+SZF->ZF_PEDIDO))
					
					cPedAnt := SZ5->Z5_PEDGAR
					dDatAnt := Iif(Empty(SZ5->Z5_PEDGANT),SZ5->Z5_DATVER,SZ5->Z5_DATEMIS)
					
				EndIf
			
			EndIf
		
		EndIf
		
	ElseIf !Empty(QCRPR101->Z6_PEDORI)
	
		SZ5->(DbSetOrder(1))
		If SZ5->(DbSeek(xFilial("SZ5")+QCRPR101->Z6_PEDORI))
			
			cPedAnt := SZ5->Z5_PEDGAR
			dDatAnt := SZ5->Z5_DATEMIS
			
		EndIf
	
	EndIf
	
	//Grava linhas através da divisão por código de CCR
	cLin := "<tr><td>"+AllTrim(QCRPR101->Z3_CODENT) +"</td>"
	cLin += "<td width='800'>"+AllTrim(QCRPR101->Z3_DESENT) +"</td>"
	cLin += "<td width='800'>"+ AllTrim(QCRPR101->Z6_NOMEAGE)+"</td>"
	cLin += "<td>"+ AllTrim(QCRPR101->Z6_PRODUTO)+"</td>"
	cLin += "<td width='800'>"+ AllTrim(QCRPR101->Z6_DESCRPR)+"</td>"
	cLin += "<td>"+ AllTrim(Iif(Empty(QCRPR101->Z6_PEDGAR),QCRPR101->Z6_PEDSITE,QCRPR101->Z6_PEDGAR)) +"</td>"
	cLin += "<td>"+ iif(lReemb,AllTrim(QCRPR101->STATPED),"REEMBOLSO PARCIAL")+"</td>"
	cLin += "<td>"+ DtoC(QCRPR101->Z6_DTPEDI)	 +"</td>"
	cLin += "<td>"+ DtoC(QCRPR101->Z6_VALIDA)	 +"</td>"
	cLin += "<td>"+ DtoC(QCRPR101->Z6_VERIFIC)	 +"</td>"
	cLin += "<td>"+ DtoC(QCRPR101->Z6_DTEMISS)	 +"</td>"
	cLin += "<td width='800'>"+ AllTrim(QCRPR101->Z6_NTITULA)+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->BASE_COMISSAO, "@E 999,999,999.99"))+"</td>"
	//If cWhere <> "8"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->BASE_SOFTWARE, "@E 999,999,999.99"))+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->BASE_HARDWARE, "@E 999,999,999.99"))+"</td>"
	//EndIf
	cLin += "<td>"+ AllTrim(QCRPR101->ZH_DESCRI)+"</td>"
	cLin += "<td>"+ AllTrim(Iif(Empty(QCRPR101->Z6_PEDORI),cPedAnt,QCRPR101->Z6_PEDORI))   +"</td>"  //BUSCAR NA SZF - QCRPR101->DT_PEDANT - MELHORIA DE PERFORMANCE.
	cLin += "<td>"+	 DtoC(dDatAnt)								 +"</td>"                         	  //  DtoC("  /  /  ") - BUSCAR NA SZF - QCRPR101->DT_PEDANT - MELHORIA DE PERFORMANCE.
	cLin += "<td>"+ AllTrim(Iif(Empty(QCRPR101->Z6_CCRCOM),QCRPR101->Z3_CCRCOM,QCRPR101->Z6_CCRCOM))+"</td>"
	cLin += "<td>"+ AllTrim(QCRPR101->Z3_CODAC) +"</td>"
	cLin += "<td width='800'>"+ AllTrim(QCRPR101->Z3_DESAC) +"</td>"
	cLin += "<td width='800'>"+ AllTrim(QCRPR101->Z6_DESGRU)+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->VLR_ABATIMENTO, "@E 999,999,999.99"))+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->VALOR_SOFTWARE, "@E 999,999,999.99"))+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->VALOR_HARDWARE, "@E 999,999,999.99"))+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->VALOR_PRODUTO , "@E 999,999,999.99"))+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->COMSOF        , "@E 999,999,999.99"))+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->COMHAR        , "@E 999,999,999.99"))+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->VALOR_COMISSAO, "@E 999,999,999.99"))+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(Iif(MV_PAR06 == 1 ,nFedera,0), "@E 999,999,999.99"))+"</td>"
	//cLin += "<td>"+ AllTrim(TRANSFORM(Iif(MV_PAR06 == 1 .And. nFedera != 0,nFedera+QCRPR101->VALOR_COMISSAO,0), "@E 999,999,999.99"))+"</td>"
	cLin += "<td>"+ AllTrim(TRANSFORM(nFedera+QCRPR101->VALOR_COMISSAO, "@E 999,999,999.99"))+"</td>"

	//Renato Ruy - 16/03/17
	//Valida quando tem reembolso, para verificar se e parcial ou integral.
	If lReemb
		cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->CONT_CER	  , "@E 999,999,999.99"))+"</td>"	
		cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->CONT_CERSW	  , "@E 999,999,999.99"))+"</td>"
		cLin += "<td>"+ AllTrim(TRANSFORM(QCRPR101->CONT_CERHW	  , "@E 999,999,999.99"))+"</td>"
	Else
		cLin += "<td>"+ AllTrim(TRANSFORM(0	, "@E 999,999,999.99"))+"</td>"	
		cLin += "<td>"+ AllTrim(TRANSFORM(0	, "@E 999,999,999.99"))+"</td>"
		cLin += "<td>"+ AllTrim(TRANSFORM(0	, "@E 999,999,999.99"))+"</td>"
	EndIf

	If MV_PAR06 == 3
		cLin += "<td>"+ AllTrim(TRANSFORM(nContBio	  , "@E 999,999,999.99"))+"</td>"
	EndIf
	If AllTrim(Str(MV_PAR06)) $ "2/3/4" .And. MV_PAR11 == 1
		cLin += "<td>"+ AllTrim(QCRPR101->CODENT) +"</td>"
		cLin += "<td width='800'>"+ AllTrim(QCRPR101->DESENT) +"</td>"
		cLin += "<td width='800'>"+ AllTrim(QCRPR101->Z6_DESREDE) +"</td>"
	Elseif AllTrim(Str(MV_PAR06)) $ "1" .And. MV_PAR11 == 1 
		If QCRPR101->Z3_TIPENT == "3"
			SZ3->(DbSetOrder(4))
			SZ3->(DbSeek(xFilial("SZ3")+QCRPR101->Z6_CODPOS))
			cLin += "<td width='800'>"+ AllTrim(SZ3->Z3_CODENT)+"</td>"
			cLin += "<td width='800'>"+ AllTrim(SZ3->Z3_DESENT) +"</td>"
			cLin += "<td width='800'>"+ AllTrim(QCRPR101->Z6_DESREDE)+"</td>"
		Else
			cLin += "<td></td>"
			cLin += "<td>MESMA ENTIDADE</td>"
		Endif
	EndIf
	cLin += "<td>"+ AllTrim(QCRPR101->Z3_ESTADO)  +"</td>"
	cLin += "<td>"+ AllTrim(QCRPR101->REGIAO)     +"</td></tr>"
	
	cLin := cLin + cEOL
	
	//Efetuo gravação de dados do relatório em arquivo.
	If nHdl != -1
		//Faco tratamento para melhorar performance na gravacao em arquivo.
		If nContFw >= 250
			fWrite(nHdl,cLinFw+cLin)
			cLinFw  := " "
			nContFw := 0
		Else
			cLinFw  += cLin
			nContFw += 1
		EndIf
	EndIf
	
	//Zera informacao do voucher atual.
	cPedAnt := ""
	dDatAnt := CtoD("  /  /  ")
	
	QCRPR101->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

//Grava Totais
If nHdl != -1

	//Gravo se faltou linhas na memoria
	If nContFw > 0
		fWrite(nHdl,cLinFw)
		cLinFw  := " "
		nContFw := 0
	EndIf

	cLin := "<tr><td>"+Iif(MV_PAR06 == 1 .Or. cCCRAnt == "CA0009" .Or. AllTrim(cCCRAnt) == "FEN"," Subtotal </td>"," Total Geral </td>")
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td>"+ TRANSFORM(nBasCom, "@E 999,999,999.99")+"</td>"
	//If cWhere <> "8"
		cLin += "<td>"+ TRANSFORM(nBasSof, "@E 999,999,999.99")+"</td>"
		cLin += "<td>"+ TRANSFORM(nBasHar, "@E 999,999,999.99")+"</td>"
	//EndIf
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td>"
	//If cWhere <> "8"
		cLin += "<td>"+ TRANSFORM(nAbtVal, "@E 999,999,999.99")+"</td>"
		cLin += "<td>"+ TRANSFORM(nValSof, "@E 999,999,999.99")+"</td>"
		cLin += "<td>"+ TRANSFORM(nValHar, "@E 999,999,999.99")+"</td>"
		cLin += "<td>"+ TRANSFORM(nValPro, "@E 999,999,999.99")+"</td>"
		cLin += "<td>"+ TRANSFORM(nComSof, "@E 999,999,999.99")+"</td>"
		cLin += "<td>"+ TRANSFORM(nComHar, "@E 999,999,999.99")+"</td>"
	//EndIf
	cLin += "<td>"+ TRANSFORM(nComPro, "@E 999,999,999.99")+"</td>"
	//If cWhere <> "8"
		cLin += "<td>"+ TRANSFORM(nValFed, "@E 999,999,999.99")+"</td>"
		cLin += "<td>"+ TRANSFORM(nComFed, "@E 999,999,999.99")+"</td>"
	//EndIf
	cLin += "<td>"+ TRANSFORM(nConCer, "@E 999,999,999.99")+"</td>"
	//If cWhere <> "8"
		cLin += "<td>"+ TRANSFORM(nConSof, "@E 999,999,999.99")+"</td>"
		cLin += "<td>"+ TRANSFORM(nConHar, "@E 999,999,999.99")+"</td>"
	//EndIf
	If MV_PAR06 == 3
		cLin += "<td>"+ TRANSFORM(nTotBio, "@E 999,999,999.99")+";
	EndIf
	If AllTrim(Str(MV_PAR06)) $ "1/2/3/4" .And. MV_PAR11 == 1
		cLin += "<td>--</td>"
		cLin += "<td>--</td>"
		cLin += "<td>--</td>"
	EndIf
	cLin += "<td> -- </td>"
	cLin += "<td> -- </td></tr>"
	
	cLin := cLin + cEOL
	
	//Efetuo gravação de dados do relatório em arquivo.
	fWrite(nHdl,cLin)
	
	If MV_PAR06 == 2 .And. AllTrim(cCCRAnt) == "FEN"
				
		If Select("TMPFEN") > 0
			DbSelectArea("TMPFEN")
			TMPFEN->(DbCloseArea())
		EndIf

		BeginSql Alias "TMPFEN"
		
			SELECT COUNT(*) NUMGAR, SUM(VALFAT) VALFAT, SUM(VALIFEN) VALIFEN FROM (
			SELECT Z6_PEDGAR PEDGAR, SUM(Z6_VLRPROD) VALFAT, SUM(Z6_VLRPROD) * 0.02 VALIFEN 
			FROM %Table:SZ6% SZ6 
			WHERE 
			Z6_FILIAL = ' ' 
			%Exp:cPeriodo%
			AND Z6_CODENT = 'CA0009' AND 
			SZ6.%NotDel%
			GROUP BY Z6_PEDGAR)
			
		Endsql
		
		If lMktFund
			cLin += "<tr><td> FUNDOS DE MARKETING -> </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> QUANTIDADE PEDIDOS: " + AllTrim(Str(TMPFEN->NUMGAR)) + "  </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td>"+ TRANSFORM(TMPFEN->VALFAT, "@E 999,999,999.99") + "  </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td>"+ TRANSFORM(TMPFEN->VALIFEN, "@E 999,999,999.99")+"</td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>"
			cLin += "<td> -- </td>" 
			cLin += "<td> -- </td></tr>"
			
			//Armazena o valor para ser exibido no totalizador.
			nComPro += TMPFEN->VALIFEN
			
			cLin := cLin + cEOL
			
			//Efetuo gravação de dados do relatório em arquivo.
			fWrite(nHdl,cLin)
		EndIf
		
		cLin := "<tr><td> Total Geral </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td>"+ TRANSFORM(nComPro, "@E 999,999,999.99")+"</td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td></tr>"
		
		cLin := cLin + cEOL
		
		//Efetuo gravação de dados do relatório em arquivo.
		fWrite(nHdl,cLin)
	
	EndIf
	
	nCA0009 := 0
				
	If MV_PAR06 == 3 .And. cCCRAnt == "CA0009" .And. lBioIFEN
	
		nCA0009 := nTotBio * 3
		
		cLin += "<tr><td> BIOMETRIA IFEN -> </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> QUANTIDADE PEDIDOS: " + AllTrim(Str(nTotBio)) + "  </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		//Multiplico o valor por R$ 3,00 - valor do certificado
		cLin += "<td>"+ TRANSFORM(nCA0009, "@E 999,999,999.99")+"</td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td></tr>"
		cLin := cLin + cEOL
		
		//Efetuo gravação de dados do relatório em arquivo.
		fWrite(nHdl,cLin)
		
		cLin := "<tr><td> Total Geral </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td>"+ TRANSFORM(nComPro+nCA0009, "@E 999,999,999.99")+"</td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td></tr>"
		
		cLin := cLin + cEOL
		
		//Efetuo gravação de dados do relatório em arquivo.
		fWrite(nHdl,cLin)
			
	EndIf
	
	nVisita := 0
	nPortal := 0
	If MV_PAR06 == 1 .And. MV_PAR09 == 1
	
		cQuery := "SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSqlName("SZ6") + " WHERE Z6_TIPO = 'PORTAL' AND Z6_PEDGAR = 'PORTALASSI' "+ StrTran(cPeriodo,"%","") +" AND D_E_L_E_T_ = ' ' AND Z6_CODENT = '" + cCCRAnt + "'"
			
		If Select("TMPSIGN") > 0
			TMPSIGN->(dbCloseArea())
		EndIf
		
		PLSQuery( cQuery, "TMPSIGN" )
		
		If TMPSIGN->(!EOF()) .And. TMPSIGN->Z6_VALCOM > 0

				nPortal += TMPSIGN->Z6_VALCOM
				
				cLin := "<tr><td>Portal de Assinatura #2 - </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td>" + TRANSFORM(TMPSIGN->Z6_VALCOM, "@E 999,999,999.99")+"</td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				cLin += "<td> -- </td>"
				If MV_PAR12 == 1
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
				EndIf	
				
				cLin += "</tr>"
				
				cLin := cLin + cEOL
				
				//Efetuo gravação de dados do relatório em arquivo.
				fWrite(nHdl,cLin)
				TMPSIGN->(DbSkip())
		EndIf
	
			
		cQuery := " SELECT Z6_DESGRU, SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' "+ StrTran(cPeriodo,"%","") +" AND Z6_PRODUTO = 'VISITAEXTERNA' AND Z6_CODENT = '"+cCCRAnt+"' AND z6_tpentid = 'B' GROUP BY Z6_DESGRU"
				
				If Select("TMP") > 0
					DbSelectArea("TMP")
					TMP->(DbCloseArea())
				EndIf
				PLSQuery( cQuery, "TMP" )
				
				While !TMP->(EOF())
					nVisita += TMP->Z6_VALCOM
					
					cLin += "<tr><td> Visita Externa - "+ Iif("-"$TMP->Z6_DESGRU,"Sem Projeto", AllTrim(TMP->Z6_DESGRU))+ "</td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td>"+Iif(Select("TMP") > 0, TRANSFORM(TMP->Z6_VALCOM, "@E 999,999,999.99")+"</td>"," --  </td>")
					cLin += "<td> -- </td>"
					cLin += "<td>"+Iif(Select("TMP") > 0, TRANSFORM(TMP->Z6_VALCOM, "@E 999,999,999.99")+"</td>"," --  </td>")
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td>"
					cLin += "<td> -- </td></tr>"
					
					cLin := cLin + cEOL
					
					//Efetuo gravação de dados do relatório em arquivo.
					fWrite(nHdl,cLin)
					TMP->(DbSkip())
				Enddo
		
		cLin := "<tr><td> Total Geral </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		//Rafael Beghini 17.03.2016 |Solicitação de Valquiria|
		//Deve somar o valor de comissão + visita externa para mostrar no totalizador
		cLin += "<td>"+Iif(Select("TMP") > 0 , TRANSFORM(nVisita + nComPro, "@E 999,999,999.99")+"</td>"," --  </td>")
		cLin += "<td> -- </td>"
		cLin += "<td>"+Iif(Select("TMP") > 0 , TRANSFORM(nVisita + nComPro + nvalfed, "@E 999,999,999.99")+"</td>"," --  </td>")
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td>"
		cLin += "<td> -- </td></tr></table>"
		
		cLin := cLin + cEOL
		
		//Efetuo gravação de dados do relatório em arquivo.
		fWrite(nHdl,cLin)
		
	EndIf  
	
	
EndIf

//Fecho o arquivo anterior
fClose(nHdl)

//Renato Ruy - 25/07/2018
//Validar se existe arquivos e apaga
If FILE(AllTrim(MV_PAR10)+cNomArq+".xls")
	FERASE(AllTrim(MV_PAR10)+cNomArq+".xls")
Endif

//Renato Ruy - Novo processo para converter em excel
U_CRPR102(MV_PAR10, cNomArq)

//Dados para retorno
AADD(aRetorno,AllTrim(MV_PAR10)+cNomArq+".xls")	//Caminho Completo do arquivo
AADD(aRetorno,cNomArq+".xls")						//Nome do Arquivo 
AADD(aRetorno,nVisita + nComPro + nvalfed)		//Valor total arquivo

Return aRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ValidPerg ºAutor  ³Renato Ruy Bernardo    º Data ³  04/06/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função Responsavel por criar as perguntas utilizadas no    º±±
±±º          ³ Relatório.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Periodo  ?"	   			,"Periodo  ?"  	  	 		,"Periodo  ?"  		 		,"mv_ch1" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"AC De?"	 		  		,"AC De?"	 		  		,"AC De?"	 		  		,"mv_ch2" 	,"C" 		,04     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"AC Ate?"	 		  		,"AC Ate?"	 		  		,"AC Ate?"	 		  		,"mv_ch3" 	,"C" 		,04     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"Entidade De ?"   	  		,"Entidade De ?"   	  		,"Entidade De ?"   	  		,"mv_ch4" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par04"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"05" 		,"Entidade Ate ?"  	  		,"Entidade Ate ?"  	  		,"Entidade Ate ?"  	  		,"mv_ch5" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par05"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"06" 		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"mv_ch6" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par06"	,"Posto"   			,"Posto"   			,"Posto"   			,""   		,"AC"           ,"AC"           ,"AC"           ,"Canal"    ,"Canal"    ,"Canal"    	,"Federação","Federação"	,"Federação"	,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"07" 		,"Cod.CCR De ?"   	  		,"Cod.CCR De ?"   	  		,"Cod.CCR De ?"   	  		,"mv_ch7" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par07"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"08" 		,"Cod.CCR Ate ?"  	  		,"Cod.CCR Ate ?"  	  		,"Cod.CCR Ate ?"  	  		,"mv_ch8" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par08"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"09" 		,"Quebra CCR ?"	  			,"Quebra CCR ?"		  		,"Quebra CCR ?"		  		,"mv_ch9" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par09"	,"Sim"   			,"Sim"   			,"Sim"   			,""   		,"Não"          ,"Não"          ,"Não"          ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"10" 		,"Diretorio ?"	  			,"Diretorio ?"		  		,"Diretorio ?"		  		,"mv_chA" 	,"C" 		,75     		,0      		,0     		,"C"		,"U_CRPR101A",""	    ,""         ,"S"        ,"mv_par10"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"11" 		,"Gera info Posto?"			,"Gera info Posto?"	  		,"Gera info Posto?"	 		,"mv_chB" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par11"	,"Sim"   			,"Sim"   			,"Sim"   			,""   		,"Não"          ,"Não"          ,"Não"          ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSA01   ºAutor  ³Microsiga           º Data ³  01/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRPR101A()
Local cAux 	:= ""
Local cDirIn:= ""

MV_PAR10 := IIF(!Empty(cAux:=(cGetFile("\", "Diretórios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

Return(.T.) 