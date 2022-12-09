#INCLUDE "Totvs.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPR100   บ Autor ณ Renato Ruy         บ Data ณ  21/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CRPR110


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat๓rio de Lan็amentos de Remunera็ใo"
Local cPict          := ""
Local titulo         := "Relat๓rio de Lan็amentos de Remunera็ใo"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "CRP110"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CAMPAN" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ6"

dbSelectArea("SZ6")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Processa( {|| RunReport(Cabec1,Cabec2,Titulo,nLin)  }, "Gerando Relat๓rio...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  21/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _aDados := {}
Local aCabec  := {}
Local cCCRAnt := ""
Local cWhere  := " "
Local cWhere2 := " "
Local cPeriodo:= " "
Local nBasCom := 0
Local nValPro := 0
Local nComPro := 0
Local nConCer := 0
Local nContar := 0
Local cArq 	  := ""
Local cNomArq := ""
Local cOrdem  := ""
Local nHdl    := 0
Local cLin		:= ""
Local nContMsg:= 0
Local cLinFw  := " "
Local nContFw := 0
Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//Fa็o condi็ใo para alimentar o where
If 	   MV_PAR06 == 1
	cWhere := "7"
	cTipo  := "Geral - Campanha Contador"
Else
	cWhere := "10"
	cTipo  := "Geral - Clube do Revendedor"
EndIf

If 	MV_PAR10 == 1
	cOrdem := "%Z6_DESENT%"
	cWhere2:= "ZZZ"
ElseIf 	MV_PAR07 == 2
	cOrdem := "%Z6_CODENT%"
	cWhere2:= "ICP"
Else
	cOrdem := "%Z6_DESREDE%"
	cWhere2:= "ZZZ"
EndIf

//Renato Ruy - 15/07/2016
//Viabilizar consulta em mais de um periodo.
If Len(AllTrim(MV_PAR01)) == 6
	cPeriodo := "% AND Z6_PERIODO = '"+AllTrim(MV_PAR01)+"' %"
ElseIf Len(AllTrim(MV_PAR01)) < 13
	Alert("O periodo informado estแ incorreto")
	Return .F.
Elseif "-" $ AllTrim(MV_PAR01)
	cPeriodo := "% AND Z6_PERIODO Between '"+SubStr(MV_PAR01,1,6)+"' And '" + SubStr(MV_PAR01,8,6) + "' %"
EndIf

IncProc( "Consultando dados " + SubStr(cTipo,9,18))
ProcessMessage()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ BEGINSQL -> Busco dados Agrupados de Remunera็ใo					ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  

If Select("QCRPR070") > 0
	DbSelectArea("QCRPR070")
	QCRPR070->(DbCloseArea())
EndIf

If 	   MV_PAR06 == 1
	BeginSql Alias "QCRPR070"
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
		Z6_CODENT ,
		Z6_DESENT,
		DECODE(Z6_TIPO,    	'RECANT','RECEBIDO ANTERIORMENTE',
							'REEMBO', 'REEMBOLSO',
							'NAOPAG', 'VOUCHER ORIGEM NAO REMUNERADO',
							'PNOPAG', 'PEDIDO NAO REMUNERADO',	
							'RETIFI', 'RETIFICACAO',
		    				'RENOVA','RENOVACAO',
		    				'ENTHAR', 'HARDWARE AVULSO',
		    				'PAGANT', 'PAGO ANTERIORMENTE',
		    				'VERIFI', 'VERIFICACAO') STATPED,
		CASE WHEN  SUM(Z6_VLRPROD) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CER,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0 WHEN Z6_TIPO = 'REEMBO' THEN -1  ELSE 1 END CONT_CERHW,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT','ENTHAR') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CERSW,
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
		MAX((SELECT Z3_DESENT FROM SZ3010 WHERE Z3_FILIAL = ' ' AND Z3_CODENT = (SZ6.Z6_CODCCR) AND Z3_TIPENT = '9' AND D_E_L_E_T_ = ' ')) Z6_CCRCOM,
		Z6_CODAC,
		Z6_PEDSITE,
		Z6_PEDGAR,
		Case When MAX(Z6_PEDSITE) = ' ' then MAX(Z6_PEDGAR) Else MAX(Z6_PEDSITE) End Cd_Pedido,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Case when Max(Z6_PEDORI) != ' ' Then Max(Z6_PEDORI) Else Max(ZF_PEDIDO) End PEDANT,
	 	Case when Max(Z6_TIPO) = 'ENTHAR' AND SUM(Z6_VLRPROD) = 0 THEN Max(Z5_EMISSAO) when Max(Z6_PEDORI) > '0' AND SUM(Z6_VLRPROD) = 0 THEN Max((SELECT MAX(Z5_DATEMIS) FROM SZ5010 SZ56 WHERE Z5_FILIAL = ' ' AND Z5_PEDGAR > '0' AND Z5_PEDGAR = SZ6.Z6_PEDORI AND D_E_L_E_T_ = ' ')) WHEN  SUM(Z6_VLRPROD) = 0 And Max(Z5_PEDGANT) > ' ' Then Max(Z5_DATEMIS) WHEN  SUM(Z6_VLRPROD) = 0 Then Max(Z5_DATVER) END DT_PEDANT,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z5_CODPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALOR_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) COMHAR,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALOR_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) COMSOF,
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
	    Z6_DESREDE,
	    Z5_CODRD
		FROM %Table:SZ6% SZ6
	  	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND SZF.D_E_L_E_T_ = ' '  AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0
		LEFT JOIN %Table:SZ5% SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ') AND SZ5.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = ' ' 
		%Exp:cPeriodo% 
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND SubStr(Z6_CODAC,1,4) Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
		AND z6_tpentid = %Exp:cWhere% 
		AND Z6_CODAC != %Exp:cWhere2%
		GROUP BY Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		Z6_CODENT ,
		Z6_DESENT,
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
		Z6_CODAC,
		Z6_PEDSITE,
		Z6_PEDGAR,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z5_CODPOS,
		Z6_GRUPO,
		Z6_DESGRU,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    Z6_DESREDE,
	    Z5_CODRD
		
		ORDER BY %Exp:cOrdem%
		
	EndSql
Else
	BeginSql Alias "QCRPR070"
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
		Z6_CODENT ,
		Z6_DESENT,
		DECODE(Z6_TIPO,    	'RECANT','RECEBIDO ANTERIORMENTE',
							'REEMBO', 'REEMBOLSO',
							'NAOPAG', 'VOUCHER ORIGEM NAO REMUNERADO',
							'PNOPAG', 'PEDIDO NAO REMUNERADO',	
							'RETIFI', 'RETIFICACAO',
		    				'RENOVA','RENOVACAO',
		    				'ENTHAR', 'HARDWARE AVULSO',
		    				'PAGANT', 'PAGO ANTERIORMENTE',
		    				'VERIFI', 'VERIFICACAO') STATPED,
		CASE WHEN  SUM(Z6_VLRPROD) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CER,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0 WHEN Z6_TIPO = 'REEMBO' THEN -1  ELSE 1 END CONT_CERHW,
        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT','ENTHAR') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CERSW,
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
		MAX((SELECT Z3_DESENT FROM SZ3010 WHERE Z3_FILIAL = ' ' AND Z3_CODENT = (SZ6.Z6_CODCCR) AND Z3_TIPENT = '9' AND D_E_L_E_T_ = ' ')) Z6_CCRCOM,
		Z6_PEDSITE,
		Z6_PEDGAR,
		Case When MAX(Z6_PEDSITE) = ' ' then MAX(Z6_PEDGAR) Else MAX(Z6_PEDSITE) End Cd_Pedido,
		Z6_NCLIENT,
	  	ZH_DESCRI,
		Z6_TIPVOU,
		Z6_CODVOU,
		Z6_DESCVOU,
		Case when Max(Z6_PEDORI) != ' ' Then Max(Z6_PEDORI) Else Max(ZF_PEDIDO) End PEDANT,
	 	Case when Max(Z6_TIPO) = 'ENTHAR' AND SUM(Z6_VLRPROD) = 0 THEN Max(Z5_EMISSAO) when Max(Z6_PEDORI) > '0' AND SUM(Z6_VLRPROD) = 0 THEN Max((SELECT MAX(Z5_DATEMIS) FROM SZ5010 SZ56 WHERE Z5_FILIAL = ' ' AND Z5_PEDGAR > '0' AND Z5_PEDGAR = SZ6.Z6_PEDORI AND D_E_L_E_T_ = ' ')) WHEN  SUM(Z6_VLRPROD) = 0 And Max(Z5_PEDGANT) > ' ' Then Max(Z5_DATEMIS) WHEN  SUM(Z6_VLRPROD) = 0 Then Max(Z5_DATVER) END DT_PEDANT,
		Z5_CODAGE,
		Z5_NOMAGE,
		Z5_CODPOS,
		Z6_CODAC,
		Z6_GRUPO,
		Z6_DESGRU,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALOR_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE,
		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) COMHAR,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALOR_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE,
		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) COMSOF,
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
	    Z6_DESREDE,
	    Z5_CODRD
		FROM %Table:SZ6% SZ6
	  	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND SZF.D_E_L_E_T_ = ' '  AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0
		LEFT JOIN %Table:SZ5% SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ')  AND SZ5.D_E_L_E_T_ = ' '
		LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
		WHERE
		SZ6.D_E_L_E_T_ = ' ' 
		AND Z6_FILIAL = ' ' 
		%Exp:cPeriodo%
		AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
		AND z6_tpentid = %Exp:cWhere%
		GROUP BY Z6_FILIAL,
		Z6_PERIODO,
		Z6_TIPO ,
		Z6_CODENT ,
		Z6_DESENT,
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
		Z5_CODAGE,
		Z5_NOMAGE,
		Z5_CODPOS,
		Z6_CODAC,
		Z6_GRUPO,
		Z6_DESGRU,
		Z6_NTITULA,
	 	Z6_CODAGE,
	    Z6_NOMEAGE,
	    Z6_AGVER,
	    Z6_NOAGVER,
	    Z6_CODPOS,
	    Z6_DESREDE,
	    Z5_CODRD
	    
		ORDER BY %Exp:cOrdem%
		
	EndSql
EndIf

If Select("QCRPR110") > 0
	DbSelectArea("QCRPR110")
	QCRPR110->(DbCloseArea())
EndIf

If MV_PAR06 == 1
	BeginSql Alias "QCRPR110"
	SELECT COUNT(*) CONTAR  FROM (
							SELECT Z6_PEDGAR, Z6_PEDSITE
							FROM %Table:SZ6% SZ6
							WHERE
							SZ6.D_E_L_E_T_ = ' ' 
							AND Z6_FILIAL = ' ' 
							%Exp:cPeriodo% 
							AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
							AND SubStr(Z6_CODAC,1,4) Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
							AND z6_tpentid = %Exp:cWhere% 
							AND Z6_CODAC != %Exp:cWhere2%
							GROUP BY Z6_PEDGAR, Z6_PEDSITE)
	EndSql
Else
	BeginSql Alias "QCRPR110"
	SELECT COUNT(*) CONTAR  FROM (
							SELECT Z6_PEDGAR, Z6_PEDSITE
							FROM %Table:SZ6% SZ6
							WHERE
							SZ6.%Notdel%
							AND Z6_FILIAL = ' ' 
							%Exp:cPeriodo%
							AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
							AND z6_tpentid = %Exp:cWhere%
							GROUP BY Z6_PEDGAR, Z6_PEDSITE)
	
	EndSql
Endif
	
nContar := QCRPR110->CONTAR

ProcRegua(nContar)

//Alimento a variavel com o c๓digo do pedido para fazer compara็ใo
If MV_PAR10 == 1
	cCCRAnt := QCRPR070->Z6_DESENT
	cNomArq := Iif(MV_PAR06 == 1,"CCR CAMPANHA - ","CLUBE - ")+AllTrim(QCRPR070->Z6_DESENT)
ElseIf MV_PAR09 == 2
	cNomArq := cTipo
ElseIf Mv_par07 == 2
	cCCRAnt := QCRPR070->Z6_CODENT
	cNomArq := Iif(MV_PAR06 == 1,"CCR CAMPANHA - ","CLUBE - ")+AllTrim(QCRPR070->Z6_DESENT) + " - " + QCRPR070->Z6_CODENT
Else
	cCCRAnt := QCRPR070->Z6_DESREDE
	cNomArq := Iif(MV_PAR06 == 1,"CAMPANHA - ","CLUBE - ")+AllTrim(QCRPR070->Z6_DESREDE)
EndIf

//Tenta corrigir espa็os tabulados no nome
If At(CHR(9),cNomArq) > 0
	cNomArq := StrTran(cNomArq,CHR(9),"")
EndIf

//Armazena o caminho para grava็ใo.
cArq    := AllTrim(MV_PAR08) + StrTran(cNomArq,"/", " ") +".CSV"
nHdl    := fCreate(cArq)

If nHdl == -1
	Alert("O Sistema nใo pode gerar o arquivo: "+cArq+", porque o arquivo esta aberto ou a pasta destino sem permissใo a gravar arquivos!"+cEOL+"O Processo nใo continuarแ!")
	Return
Endif

//Adiciono o cabe็alho para o relat๓rio.
If nHdl != -1
	cLin := "Cod.Ent.;"
	cLin += "Des. Entidade;"
	cLin += "Cod.Vendedor;"
	cLin += "Nome Vendedor;"
	cLin += "Desc. Agente Val.;"
	cLin += "Cod.Produto;"
	cLin += "Desc.Produto;"
	cLin += "Pedido;"
	cLin += "Status Pedido;"
	cLin += "Dt.Pedido;"
	cLin += "Dt.Valida็ใo;"
	cLin += "Dt.Verifica็ใo;"
	cLin += "Dt.Emissใo/Renova็ใo;"
	cLin += "Nome Cliente;"
	cLin += "Tipo Voucher;"
	cLin += "Ped. Anterior;"
	cLin += "Dt.Pedido Anterior;"
	cLin += "C๓d. AC;"
	cLin += "Desc. Grupo;"
	cLin += "Link;"
	cLin += "Val. Bruto;"
	cLin += "Val. Faturamento;"
	cLin += "Valor Tot. Comiss.;"
	cLin += "Contagem;"
	cLin += "C๓d. RD"
		
	cLin := cLin + cEOL
	
	//Efetuo grava็ใo de dados do relat๓rio em arquivo.
	fWrite(nHdl,cLin)
EndIf

While !QCRPR070->(EOF())

	IncProc( "Exportando --> " + Iif(!Empty(QCRPR070->Z6_PEDGAR),"Pedido GAR: " + QCRPR070->Z6_PEDGAR, "Pedido SITE: " + QCRPR070->Z6_PEDSITE ) )
	If nContMsg >= 80
		nContMsg := 0
		ProcessMessage()
	Else
		nContMsg++
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If (AllTrim(cCCRAnt) <> AllTrim(QCRPR070->Z6_CODENT) .And. MV_PAR09 == 1 .And. MV_PAR07 == 2) .Or. (AllTrim(cCCRAnt) <> AllTrim(QCRPR070->Z6_DESREDE) .And. MV_PAR09 == 1 .And. MV_PAR07 == 1) .OR.;
	   (MV_PAR10 == 1 .AND. AllTrim(cCCRAnt) <> AllTrim(QCRPR070->Z6_DESENT))
		
		//Grava Totais
		If nHdl != -1 
			
			//Gravo se faltou linhas na memoria
			If nContFw > 0
				fWrite(nHdl,cLinFw)
				cLinFw  := " "
				nContFw := 0
			EndIf
			
			cLin := " Total Geral ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += " --  ;"
			cLin += TRANSFORM(nBasCom	, "@E 999,999,999.99")+";"
			cLin += TRANSFORM(nValPro	, "@E 999,999,999.99")+";"
			cLin += TRANSFORM(nComPro	, "@E 999,999,999.99")+";"
			cLin += TRANSFORM(nConCer	, "@E 999,999,999")	+";"
			cLin += " --  ;"
			
			cLin := cLin + cEOL
			
			//Efetuo grava็ใo de dados do relat๓rio em arquivo.
			fWrite(nHdl,cLin)
		EndIf                         	
		
		//Fecho o arquivo anterior
		fClose(nHdl)
		
		//Alimento a variavel com o c๓digo do pedido para fazer compara็ใo
		If MV_PAR10 == 1
			cCCRAnt := QCRPR070->Z6_DESENT
			cNomArq := Iif(MV_PAR06 == 1,"CCR CAMPANHA - ","CLUBE - ")+AllTrim(QCRPR070->Z6_DESENT)
		ElseIf Mv_par07 == 2
			cCCRAnt := QCRPR070->Z6_CODENT
			cNomArq := Iif(MV_PAR06 == 1,"CCR CAMPANHA - ","CLUBE - ") + AllTrim(QCRPR070->Z6_DESENT) + " - " +QCRPR070->Z6_CODENT
		Else
			cCCRAnt := QCRPR070->Z6_DESREDE
			cNomArq := Iif(MV_PAR06 == 1,"CAMPANHA - ","CLUBE - ") + AllTrim(QCRPR070->Z6_DESREDE)
		EndIf
		
		//Tenta corrigir espa็os tabulados no nome
		If At(CHR(9),cNomArq) > 0
			cNomArq := StrTran(cNomArq,CHR(9),"")
		EndIf
		
		//Armazena o caminho para grava็ใo.
		cArq    := AllTrim(MV_PAR08) + StrTran(cNomArq,"/", " ") +".CSV"
		nHdl    := fCreate(cArq)
		
		If nHdl == -1
			Alert("O Sistema nใo pode gerar o arquivo: "+cArq+", porque o arquivo esta aberto ou a pasta destino sem permissใo a gravar arquivos!"+cEOL+"O Processo nใo continuarแ!")
		Endif
		
		If nHdl != -1
			cLin := "Cod.Ent.;"
			cLin += "Des. Entidade;"
			cLin += "Cod.Vendedor;"
			cLin += "Nome Vendedor;"
			cLin += "Desc. Agente Val.;"
			cLin += "Cod.Produto;"
			cLin += "Desc.Produto;"
			cLin += "Pedido;"
			cLin += "Status Pedido;"
			cLin += "Dt.Pedido;"
			cLin += "Dt.Valida็ใo;"
			cLin += "Dt.Verifica็ใo;"
			cLin += "Dt.Emissใo/Renova็ใo;"
			cLin += "Nome Cliente;"
			cLin += "Tipo Voucher;"
			cLin += "Ped. Anterior;"
			cLin += "Dt.Pedido Anterior;"
			cLin += "C๓d. AC;"
			cLin += "Desc. Grupo;"
			cLin += "Link;"
			cLin += "Val. Bruto;"
			cLin += "Val. Faturamento;"
			cLin += "Valor Tot. Comiss.;"
			cLin += "Contagem;"
			cLin += "Cod. RD"
	
			cLin := cLin + cEOL
			
			//Efetuo grava็ใo de dados do relat๓rio em arquivo.
			fWrite(nHdl,cLin)
		EndIf
		
		
		//Reinicia Totalizador
		nBasCom := 0
		nValPro := 0
		nComPro := 0
		nConCer := 0
	EndIf
	
	//Valida quando tem reembolso, para verificar se e parcial ou integral. 
	lReemb := .T.
	If "REEMBOLSO" $ QCRPR070->STATPED
		SZ5->(DbSetOrder(1))
		SZ5->(DbSeek(xFilial("SZ5")+QCRPR070->Z6_PEDGAR))
		If (0-(SZ5->Z5_VALORSW+SZ5->Z5_VALORHW)) != QCRPR070->VALOR_SOFTWARE+QCRPR070->VALOR_HARDWARE .And. (0-(SZ5->Z5_VALORSW)) != QCRPR070->VALOR_SOFTWARE .And. QCRPR070->BASE_COMISSAO != 0 
			lReemb := .F.
		Endif
	Endif
	
	//Alimenta totalizadores
	nBasCom += QCRPR070->BASE_COMISSAO
	nValPro += QCRPR070->VALOR_PRODUTO
	nComPro += QCRPR070->VALOR_COMISSAO
	If lReemb
		nConCer += QCRPR070->CONT_CER
	Endif
	
	//Grava linhas atrav้s da divisใo por c๓digo de CCR 
	// Tratamento do <![CDATA[]]>   
	//Grava linhas atrav้s da divisใo por c๓digo de CCR
	cLin := AllTrim(QCRPR070->Z6_CODENT)+";"
	cLin += StrTran(AllTrim(QCRPR070->Z6_DESENT),";","")+";"
	cLin += AllTrim(QCRPR070->Z6_CODVEND)+";"
	cLin += StrTran(AllTrim(QCRPR070->Z6_NOMVEND),";","")+";"
	cLin += StrTran(AllTrim(QCRPR070->Z6_NOMEAGE),";","")+";"
	cLin += AllTrim(QCRPR070->Z6_PRODUTO)+";"
	cLin += AllTrim(QCRPR070->Z6_DESCRPR)+";"
	cLin += AllTrim(QCRPR070->Cd_Pedido)+";"
	cLin += Iif(lReemb,AllTrim(QCRPR070->STATPED),"REEMBOLSO PARCIAL")+";"
	cLin += DtoC(QCRPR070->Z6_DTPEDI)+";"
	cLin += DtoC(QCRPR070->Z6_VALIDA)+";"
	cLin += DtoC(QCRPR070->Z6_VERIFIC)+";"
	cLin += DtoC(QCRPR070->Z6_DTEMISS)+";"
	cLin += AllTrim(QCRPR070->Z6_NTITULA)+";"
	cLin += AllTrim(QCRPR070->ZH_DESCRI)+";"
	cLin += AllTrim(QCRPR070->PEDANT)+";"
	cLin += AllTrim(DtoC(QCRPR070->DT_PEDANT))+";"
	cLin += AllTrim(Iif(MV_PAR06 == 1,QCRPR070->Z6_CODAC,""))+";"
	cLin += AllTrim(QCRPR070->Z6_DESGRU)+";"
	cLin += AllTrim(QCRPR070->Z6_DESREDE)+";"
	cLin += AllTrim(TRANSFORM(QCRPR070->VALOR_PRODUTO	, "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(QCRPR070->BASE_COMISSAO	, "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(QCRPR070->VALOR_COMISSAO	, "@E 999,999,999.99"))+";"
	If lReemb
		cLin += AllTrim(TRANSFORM(QCRPR070->CONT_CER		, "@E 999,999,999"))	+";"
	Else
		cLin += AllTrim(TRANSFORM(0 , "@E 999,999,999"))	+";"
	EndIf
	cLin += Iif("FACESP" $ QCRPR070->Z6_DESREDE,AllTrim(QCRPR070->Z5_CODRD),"") + ";"
	
	cLin := cLin + cEOL
	
	//Efetuo grava็ใo de dados do relat๓rio em arquivo.
	If nHdl != -1
		//Faco tratamento para melhorar performance na gravacao em arquivo.
		If nContFw >= 500
			fWrite(nHdl,cLinFw+cLin)
			cLinFw  := " "
			nContFw := 0
		Else
			cLinFw  += cLin
			nContFw += 1
		EndIf
	EndIf
	
	QCRPR070->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

If nHdl != -1
	//Gravo se faltou linhas na memoria
	If nContFw > 0
		fWrite(nHdl,cLinFw)
		cLinFw  := " "
		nContFw := 0
	EndIf
Endif

//Grava Totais
If nHdl != -1

	cLin := " Total Geral ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += " --  ;"
	cLin += TRANSFORM(nBasCom	, "@E 999,999,999.99")+";"
	cLin += TRANSFORM(nValPro	, "@E 999,999,999.99")+";"
	cLin += TRANSFORM(nComPro	, "@E 999,999,999.99")+";"
	cLin += TRANSFORM(nConCer	, "@E 999,999,999")	+";"
	cLin += " --  ;"

	cLin := cLin + cEOL
	
	//Efetuo grava็ใo de dados do relat๓rio em arquivo.
	If nHdl != -1
		fWrite(nHdl,cLin)
	EndIf
	
EndIf

//Fecho o arquivo anterior
fClose(nHdl)

MsgInfo("Arquivo gerado com sucesso!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ValidPerg บAutor  ณRenato Ruy Bernardo    บ Data ณ  04/06/2013บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo Responsavel por criar as perguntas utilizadas no    บฑฑ
ฑฑบ          ณ Relat๓rio.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Periodo  ?"	   			,"Periodo  ?"  	  	 		,"Periodo  ?"  		 		,"mv_ch1" 	,"C" 		,13     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"AC De?"	 		  		,"AC De?"	 		  		,"AC De?"	 		  		,"mv_ch2" 	,"C" 		,04     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"AC Ate?"	 		  		,"AC Ate?"	 		  		,"AC Ate?"	 		  		,"mv_ch3" 	,"C" 		,04     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"Entidade De ?"   	  		,"Entidade De ?"   	  		,"Entidade De ?"   	  		,"mv_ch4" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par04"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"05" 		,"Entidade Ate ?"  	  		,"Entidade Ate ?"  	  		,"Entidade Ate ?"  	  		,"mv_ch5" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par05"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"06" 		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"mv_ch6" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par06"	,"Camp.Contador"	,"Camp.Contador"	,"Camp.Contador"	,""   		,"Clube Rev."   ,"Clube Rev."   ,"Clube Rev."   ,""		    ,""		    ,""		    	,""		    ,""		    	,""		    	,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"07" 		,"Ordena por Link ?"  		,"Ordem por Link ?"  		,"Ordena por Link ?"  		,"mv_ch7" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par07"	,"Sim"				,"Sim"				,"Sim"				,""   		,"Nใo"			,"Nใo"		    ,"Nใo"		    ,""		    ,""		    ,""		    	,""		    ,""		    	,""		    	,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"08" 		,"Diretorio ?"	  			,"Diretorio ?"		  		,"Diretorio ?"		  		,"mv_ch8" 	,"C" 		,75     		,0      		,0     		,"C"		,"U_CRPR110A",""	    ,""         ,"S"        ,"mv_par08"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"09" 		,"Quebra CCR ?"	  			,"Quebra CCR ?"		  		,"Quebra CCR ?"		  		,"mv_ch9" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par09"	,"Sim"   			,"Sim"   			,"Sim"   			,""   		,"Nใo"          ,"Nใo"          ,"Nใo"          ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"10" 		,"Quebra Descri็ใo ?"		,"Quebra Descri็ใo ?"  		,"Quebra Descri็ใo ?"  		,"mv_chA" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par10"	,"Sim"   			,"Sim"   			,"Sim"   			,""   		,"Nใo"          ,"Nใo"          ,"Nใo"          ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CRPR110A()
Local cAux := ""
Local cDirIn := ""

MV_PAR08 := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

Return(.T.)