#INCLUDE "Totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPR130   บ Autor ณ Renato Ruy         บ Data ณ  21/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CRPR130


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
Private nomeprog     := "CRPA130" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "CRP130"
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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
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
Local _aDados 	:= {}
Local aCabec  	:= {}
Local cCCRAnt 	:= ""
Local cWhere  	:= " "
Local cWhere2 	:= " "
Local nBasCom 	:= 0
Local nValPro 	:= 0
Local nComPro 	:= 0
Local nConCer 	:= 0
Local cArq 	  	:= ""
Local cColor  	:= ""
Local cNomArq 	:= ""
Local cNomRed 	:= ""
Local cTipEnt 	:= ""
Local nHdl    	:= 0
Local nFeder  	:= 0
Local oExcel  	:= FWMSEXCEL():New()
Local cCodCCR 	:= ""
Local cPeriodo	:= ""
Local cTimeIni	:= ""
Local cSubQry 	:= ""

//SubTotal
Local nCONPED	:= 0
Local nVALSW 	:= 0
Local nVALHW	:= 0
Local nVALPRD	:= 0
Local nCOMSW	:= 0
Local nCOMHW	:= 0
Local nVALCOM	:= 0
Local nVALFED	:= 0
Local nVALCAM	:= 0
Local nVALVIS 	:= 0
Local nVALAR	:= 0
Local nVALTOT 	:= 0
Local nBaseSw	:= 0
Local nBaseHw	:= 0
Local nSBaseSw	:= 0
Local nSBaseHw	:= 0
Local nQtdRev 	:= 0
Local nValSwR	:= 0
Local nValHwR 	:= 0
Local nValPrR	:= 0	

//Total Geral
Local nCONPEDT	:= 0
Local nVALSWT 	:= 0
Local nVALHWT	:= 0
Local nVALPRDT	:= 0
Local nCOMSWT	:= 0
Local nCOMHWT	:= 0
Local nVALCOMT	:= 0
Local nVALFEDT	:= 0
Local nVALCAMT	:= 0
Local nVALVIST 	:= 0
Local nVALART	:= 0
Local nVALTOTT 	:= 0
Local nTBaseSw	:= 0
Local nTBaseHw	:= 0
Local nQtdRevT 	:= 0
Local nValSwRT	:= 0
Local nValHwRT 	:= 0
Local nValPrRT	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//SetRegua(RecCount()) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ BEGINSQL -> Busco dados Agrupados de Remunera็ใo					ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  

If MV_PAR04 == 1
	cWhere := "% %"
Elseif MV_PAR04 == 2 .And. MV_PAR05 == 0
	cWhere := "% (ZZ6_PEDIDO = ' ' OR D1_EMISSAO IS NULL) AND %"
Else
	cWhere2 := DtoS(StoD(MV_PAR01+"01") - MV_PAR05)
	cWhere := "% (ZZ6_PEDIDO = ' ' OR D1_EMISSAO >= '"+cWhere2+"') AND %"
EndIf

cTimeIni := Time()

If Select("QCRPR130") > 0
	QCRPR130->(DbCloseArea())
EndIf

	BeginSql Alias "QCRPR130"

		SELECT * FROM (
                SELECT  ZZ6_PERIOD PERIODO,
                        ZZ6_CODAC  REDE	  ,
                        CASE
                        WHEN Z3_TIPENT = '9' THEN '1'
                        WHEN Z3_TIPENT = '7' OR Z3_TIPENT IS NULL THEN '2'
                        WHEN Z3_TIPENT = '1' THEN '3'
                        WHEN Z3_TIPENT IN ('2','5') THEN '4'
                        END  TIPOENT,
                        ZZ6_CODENT CODENT,
                        ZZ6_DESENT DESENT,
                        ZZ6_QTDPED CONPED,
                        ZZ6_VALSW  VALSW,
                        ZZ6_VALHW  VALHW,
                        ZZ6_VALFAT VALPRD,
                        ZZ6_COMSW  COMSW,
                        ZZ6_COMHW  COMHW,
                        ZZ6_COMTOT VALCOM,
                        ZZ6_FEDSW FEDSW,
				        ZZ6_FEDHW FEDHW,
                        ZZ6_VALFED VALFED,
                        ZZ6_CAMPSW CAMPSW,
				        ZZ6_CAMPHW CAMPHW,
                        ZZ6_VALCAM VALCAMP,
                        ZZ6_POSSW  POSSW,
                        ZZ6_POSHW  POSHW,
                        ZZ6_VALPOS VALPOS,
                        ZZ6_VALVIS VALVIS,
                        ZZ6_PEDIDO PEDCOM,
                        ZZ6_COMTOT + ZZ6_VALFED + ZZ6_VALPOS + ZZ6_VALCAM + ZZ6_VALVIS + ZZ6_VALAR TOTAL,
                        SUBSTR(ZZ6_DATGER,7,2)||'/'||SUBSTR(ZZ6_DATGER,5,2)||'/'||SUBSTR(ZZ6_DATGER,1,4) DATGER,
                        D1_DOC NOTA,
                        SUBSTR(D1_EMISSAO,7,2)||'/'||SUBSTR(D1_EMISSAO,5,2)||'/'||SUBSTR(D1_EMISSAO,1,4) DT_EMISSAO,
                        //Renato Ruy - 12/09/2017
                        //Adiciona novos campos de valor de AR
                        ZZ6_VALAR,
                        ZZ6_ARSW,
                        ZZ6_ARHW
                FROM %Table:ZZ6% ZZ6
				LEFT JOIN %Table:SZ3% SZ3
				ON Z3_FILIAL = %Exp:xFilial("SZ3")% AND Z3_CODENT = ZZ6_CODENT AND Z3_TIPENT IN ('1','2','7','9') AND SZ3.%NOTDEL%
                LEFT JOIN %Table:SD1% SD1 
                ON D1_FILIAL = %Exp:xFilial("SD1")% AND D1_PEDIDO = ZZ6_PEDIDO AND D1_PEDIDO > ' ' AND D1_CC = '80000000' AND SD1.%NOTDEL%
                WHERE
				ZZ6_FILIAL = %Exp:xFilial("SZ3")% AND
				ZZ6_PERIOD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND 
				ZZ6_TIPPED = 'P' AND
                %Exp:cWhere%
				ZZ6.%NOTDEL%
				UNION
                SELECT  ZZ6_PERIOD PERIODO,
                        ZZ6_CODAC  REDE	  ,
                        CASE
                        WHEN Z3_TIPENT = '9' THEN '1'
                        WHEN Z3_TIPENT = '7' OR Z3_TIPENT IS NULL THEN '2'
                        WHEN Z3_TIPENT = '1' THEN '3'
                        WHEN Z3_TIPENT IN ('2','5') THEN '4'
                        END  TIPOENT,
                        ZZ6_CODENT CODENT,
                        ZZ6_DESENT DESENT,
                        ZZ6_QTDPED CONPED,
                        ZZ6_VALSW  VALSW,
                        ZZ6_VALHW  VALHW,
                        ZZ6_VALFAT VALPRD,
                        ZZ6_COMSW  COMSW,
                        ZZ6_COMHW  COMHW,
                        ZZ6_COMTOT VALCOM,
                        ZZ6_FEDSW FEDSW,
				        ZZ6_FEDHW FEDHW,
                        ZZ6_VALFED VALFED,
                        ZZ6_CAMPSW CAMPSW,
				        ZZ6_CAMPHW CAMPHW,
                        ZZ6_VALCAM VALCAMP,
                        ZZ6_POSSW  POSSW,
                        ZZ6_POSHW  POSHW,
                        ZZ6_VALPOS VALPOS,
                        ZZ6_VALVIS VALVIS,
                        ZZ6_PEDIDO PEDCOM,
                        ZZ6_COMTOT + ZZ6_VALFED + ZZ6_VALPOS + ZZ6_VALCAM + ZZ6_VALVIS + ZZ6_VALAR TOTAL,
                        SUBSTR(ZZ6_DATGER,7,2)||'/'||SUBSTR(ZZ6_DATGER,5,2)||'/'||SUBSTR(ZZ6_DATGER,1,4) DATGER,
                        D1_DOC NOTA,
                        SUBSTR(D1_EMISSAO,7,2)||'/'||SUBSTR(D1_EMISSAO,5,2)||'/'||SUBSTR(D1_EMISSAO,1,4) DT_EMISSAO,
                        //Renato Ruy - 12/09/2017
                        //Adiciona novos campos de valor de AR
                        ZZ6_VALAR,
                        ZZ6_ARSW,
                        ZZ6_ARHW
				FROM %Table:ZZ6% ZZ6
				LEFT JOIN %Table:SZ3% SZ3
				ON Z3_FILIAL = %Exp:xFilial("SZ3")% AND Z3_CODENT = ZZ6_CODENT AND Z3_TIPENT IN ('1','2','7','9') AND SZ3.%NOTDEL%
                LEFT JOIN %Table:CND% CND 
                ON CND_FILIAL = %Exp:xFilial("CND")% AND CND_NUMMED = ZZ6_PEDIDO AND CND.%NOTDEL%
                LEFT JOIN %Table:SD1% SD1 
                ON D1_FILIAL = %Exp:xFilial("SD1")% AND D1_PEDIDO = CND_PEDIDO AND D1_PEDIDO > ' ' AND D1_CC = '80000000' AND SD1.%NOTDEL%
                WHERE
                ZZ6_FILIAL = %Exp:xFilial("SZ3")% AND
				ZZ6_PERIOD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND 
				ZZ6_TIPPED = 'M' AND
				%Exp:cWhere%
				ZZ6.%NOTDEL%
                UNION
                SELECT  ZZ6_PERIOD PERIODO,
                        ZZ6_CODAC  REDE	  ,
                        CASE
                        WHEN Z3_TIPENT = '9' THEN '1'
                        WHEN Z3_TIPENT = '7' OR Z3_TIPENT IS NULL THEN '2'
                        WHEN Z3_TIPENT = '1' THEN '3'
                        WHEN Z3_TIPENT IN ('2','5') THEN '4'
                        END  TIPOENT,
                        ZZ6_CODENT CODENT,
                        ZZ6_DESENT DESENT,
                        ZZ6_QTDPED CONPED,
                        ZZ6_VALSW  VALSW,
                        ZZ6_VALHW  VALHW,
                        ZZ6_VALFAT VALPRD,
                        ZZ6_COMSW  COMSW,
                        ZZ6_COMHW  COMHW,
                        ZZ6_COMTOT VALCOM,
                        ZZ6_FEDSW FEDSW,
				        ZZ6_FEDHW FEDHW,
                        ZZ6_VALFED VALFED,
                        ZZ6_CAMPSW CAMPSW,
				        ZZ6_CAMPHW CAMPHW,
                        ZZ6_VALCAM VALCAMP,
                        ZZ6_POSSW  POSSW,
                        ZZ6_POSHW  POSHW,
                        ZZ6_VALPOS VALPOS,
                        ZZ6_VALVIS VALVIS,
                        ZZ6_PEDIDO PEDCOM,
                        ZZ6_COMTOT + ZZ6_VALFED + ZZ6_VALPOS + ZZ6_VALCAM + ZZ6_VALVIS + ZZ6_VALAR TOTAL,
                        SUBSTR(ZZ6_DATGER,7,2)||'/'||SUBSTR(ZZ6_DATGER,5,2)||'/'||SUBSTR(ZZ6_DATGER,1,4) DATGER,
                        ' ' NOTA,
                        ' / / ' DT_EMISSAO,
                        //Renato Ruy - 12/09/2017
                        //Adiciona novos campos de valor de AR
                        ZZ6_VALAR,
                        ZZ6_ARSW,
                        ZZ6_ARHW
                FROM %Table:ZZ6% ZZ6
				LEFT JOIN %Table:SZ3% SZ3
				ON Z3_FILIAL = %Exp:xFilial("SZ3")% AND Z3_CODENT = ZZ6_CODENT AND Z3_TIPENT IN ('1','2','7','9') AND SZ3.%NOTDEL%
                WHERE
				ZZ6_FILIAL = %Exp:xFilial("SZ3")% AND
				ZZ6_PERIOD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND 
				ZZ6_CODENT != 'CA0009' AND
				ZZ6_TIPPED = ' ' AND
				ZZ6.%NOTDEL%)
		ORDER BY PERIODO, TIPOENT, REDE
		
	EndSql

QCRPR130->(dbGoTop())
  
SetRegua(QCRPR130->(RecCount()))         

//Alimento a variavel com o c๓digo do pedido para fazer compara็ใo
cNomArq := ""
cNomRed := QCRPR130->REDE
cTipEnt := QCRPR130->TIPOENT

While !QCRPR130->(EOF())

	cCodCCR		:= QCRPR130->CODENT
	cPeriodo	:= QCRPR130->PERIODO
	
	dbSelectArea("SZ3")
	SZ3->(dbSetOrder(1))
	If SZ3->(dbSeek(xFilial("SZ3") + cCodCCR))
		If Empty(SZ3->Z3_CODPAR)
			cCodPar := ""
		Else
			cCodPar := FormatIn(AllTrim(SZ3->Z3_CODPAR) + Iif(!Empty(SZ3->Z3_CODPAR2), ","+AllTrim(SZ3->Z3_CODPAR2),""),",")
		EndIf
	EndIf
	
	If Select("TRBSUM") > 0
		TRBSUM->(dbCloseArea())
	EndIf

	IncProc("Processando CCR " + cCodCCR)
	ProcessMessage()
		
	cSubQry := " SELECT" + CRLF 
    cSubQry += " SUM(CONT_CER) CONTADOR,"  + CRLF 
    cSubQry += " SUM(VALOR_PRODUTO) VALOR_PRODUTO,"  + CRLF 
    cSubQry += " SUM(VALOR_COMISSAO) VALOR_COMISSAO,"  + CRLF 
    cSubQry += " SUM(VALOR_SOFTWARE) VALOR_SOFTWARE,"  + CRLF 
    cSubQry += " SUM(VALOR_HARDWARE) VALOR_HARDWARE"  + CRLF
	cSubQry += " FROM("  + CRLF
	cSubQry += " 	SELECT"  + CRLF
	cSubQry += " 		CASE WHEN  SUM(Z6_VLRPROD) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CER,"  + CRLF
	cSubQry += " 		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALOR_HARDWARE,"  + CRLF
	cSubQry += " 		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASE_HARDWARE," + CRLF
	cSubQry += " 		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) COMHAR," + CRLF
	cSubQry += " 		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALOR_SOFTWARE," + CRLF
	cSubQry += " 		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASE_SOFTWARE," + CRLF
	cSubQry += " 		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) COMSOF," + CRLF
	cSubQry += " 		SUM(Z6_VLRPROD) VALOR_PRODUTO," + CRLF
	cSubQry += " 		SUM(Z6_VALCOM) VALOR_COMISSAO" + CRLF
	cSubQry += " 	FROM SZ6010 SZ6" + CRLF
/*  	cSubQry += " 	LEFT JOIN SZF010 SZF ON ZF_FILIAL = ' ' AND ZF_COD = Z6_CODVOU AND SZF.D_E_L_E_T_ = ' '  AND Trim(ZF_PDESGAR) = Trim(Z6_PRODUTO) AND ZF_SALDO = 0" + CRLF
	cSubQry += " 	LEFT JOIN SZ5010 SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR > '0' AND SZ5.Z5_PEDGAR = regexp_replace(ZF_PEDIDO,'[[:punct:]]',' ') AND SZ5.D_E_L_E_T_ = ' '" + CRLF
	cSubQry += " 	LEFT JOIN SZH010 SZH ON ZH_FILIAL = ' ' AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '" + CRLF*/
	cSubQry += " 	WHERE" + CRLF
	cSubQry += " 		SZ6.D_E_L_E_T_ = ' '" + CRLF 
	cSubQry += " 		AND Z6_FILIAL = ' '" + CRLF 
	cSubQry += " 		AND Z6_PERIODO = '" + cPeriodo + "'" + CRLF
	If Empty(cCodPar)
		cSubQry += " 		AND Z6_CODCCR = '" + cCodCCR + "'" + CRLF
	Else
		cSubQry += " 		AND Z6_CODENT IN " + cCodPar + CRLF
	EndIf
	cSubQry += " 		AND z6_tpentid = '7'" + CRLF
	cSubQry += " 	GROUP BY Z6_FILIAL,Z6_PERIODO,Z6_TIPO,Z6_CODENT,Z6_DESENT,Z6_TPENTID,Z6_PRODUTO,Z6_DESCRPR,Z6_DTPEDI,Z6_VERIFIC,Z6_VALIDA,Z6_DTEMISS,Z6_CODVEND,Z6_NOMVEND,Z6_RECORI,Z6_PEDORI," + CRLF
	cSubQry += " 	Z6_CODCCR,Z6_CCRCOM,Z6_CODAC,Z6_PEDSITE,Z6_PEDGAR,Z6_NCLIENT,Z6_TIPVOU,Z6_CODVOU,Z6_DESCVOU,Z6_GRUPO,Z6_DESGRU,Z6_NTITULA,Z6_CODAGE," + CRLF
	cSubQry += " 	Z6_NOMEAGE,Z6_AGVER,Z6_NOAGVER,Z6_CODPOS,Z6_DESREDE)" //Z5_CODAGE,Z5_NOMAGE,Z5_CODPOS,ZH_DESCRI
	
	MsAguarde({|| dbUseArea(.T., "TOPCONN", TcGenQry(,,cSubQry), "TRBSUM", .T., .T.)},"","Carregando registros do CCR " + cCodCCR)
	
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
    	
	If cNomArq <> QCRPR130->PERIODO
	    
		//Armazeno dados para quebra
		cNomArq := QCRPR130->PERIODO
		cNomRed := QCRPR130->REDE
		cTipEnt := QCRPR130->TIPOENT
		
		oExcel:AddworkSheet(cNomArq)
		oExcel:AddTable (cNomArq, cNomArq)
	
		oExcel:AddColumn(cNomArq, cNomArq, "Rede" 				, 2, 1, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Cod.Ent." 			, 2, 1, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Desc.Ent" 			, 2, 1, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "CNPJ / CPF"			, 2, 1, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Contagem Pedidos"	, 2, 1, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor SW"			, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor HW"			, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor Produto"		, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Quantidade"			, 2, 1, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor SW Revenda"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor HW Revenda"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Val. Prod. Revenda" , 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Comissใo SW"		, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Comissใo HW"		, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor Comissใo"		, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Val. SW Federa็ใo"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Val. HW Federa็ใo"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor Federa็ใo"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Val. SW Campanha"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Val. HW Campanha"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor Campanha"		, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Val. SW AR"			, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Val. HW AR"			, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor AR"			, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Val.Extra Posto SW"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Val.Extra Posto HW"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor Extra Posto"	, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Visita Externa"		, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Valor Total"		, 2, 3, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Pedido Compras"		, 2, 1, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Dt. Emissใo Pedido"	, 2, 1, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Nota de Entrada"	, 2, 1, .F. )
		oExcel:AddColumn(cNomArq, cNomArq, "Emissใo Nota"		, 2, 1, .F. )
	
	EndIf
	
	If (Substr(cNomRed,1,4) <> Substr(QCRPR130->REDE,1,4) .OR. cTipEnt <> QCRPR130->TIPOENT)
	    
		oExcel:AddRow(cNomArq, cNomArq,{"Subtotal" 				,;
										""						,;
								       	"GRUPO-> "+ Substr(cNomRed,1,4),;
								       	""						,;
								       	Str(nCONPED)			,;
										nVALSW					,;
										nVALHW					,;
										nVALPRD					,;
										nQtdRev 				,;
										nValSwR					,;
										nValHwR 				,;
										nValPrR					,;
										nCOMSW					,;
										nCOMHW					,;
										nVALCOM					,;
										""						,;
										""						,;
										nVALFED					,;
										""						,;
										""						,;
										nVALCAM					,;
										""						,;
										""						,;
										nVALAR					,;
										""						,;
										""						,;
										""						,;
										nVALVIS					,;
										nVALTOT					,;
										""						,;
										""						,;
										""						,;
										""						})
			
		//Zero subtotais		
		nCONPED	:= 0
		nVALSW 	:= 0
		nVALHW	:= 0
		nVALPRD	:= 0
		nCOMSW	:= 0
		nCOMHW	:= 0
		nVALCOM	:= 0
		nVALFED	:= 0
		nVALCAM := 0
		nVALVIS := 0
		nVALAR	:= 0
		nVALTOT := 0
		nQtdRev := 0
		nValSwR	:= 0
		nValHwR := 0
		nValPrR	:= 0	
		
		//Armazeno a nova rede		
		cNomRed := QCRPR130->REDE
		cTipEnt := QCRPR130->TIPOENT
		
	EndIf
			
	/*SZ3->(DbSetOrder(1))
	SZ3->(DbSeek( xFilial("SZ3") + QCRPR130->CODENT))
	
	SZ6->(dbSetOrder(7)) //SZ6_07    
	SZ6->(dbSeek(xFilial("SZ6") + QCRPR130->PERIODO + QCRPR130->CODENT))
	
	nBaseSW := 0
	nBaseHW := 0
	
	While AllTrim(SZ6->Z6_FILIAL) + AllTrim(SZ6->Z6_PERIODO) + AllTrim(SZ6->Z6_CODENT) == AllTrim(xFilial("SZ6")) + AllTrim(QCRPR130->PERIODO) + AllTrim(QCRPR130->CODENT)
		nBaseHw += Iif(SZ6->Z6_CATPROD == "1",SZ6->Z6_BASECOM,0)
		nBaseSw += Iif(SZ6->Z6_CATPROD == "2",SZ6->Z6_BASECOM,0)
		SZ6->(dbSkip())
	EndDo
	
	If nBaseSW + nBaseHW == 0
		
		If Select("Q130_SUM") > 0
			Q130_SUM->(dbCloseArea())
		EndIF
		
		BeginSql Alias "Q130_SUM"
		 	SELECT SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_BASECOM ELSE 0 END) BASEHW,
		 	       SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_BASECOM ELSE 0 END) BASESW 
		 	FROM %Table:SZ6% SZ6 
		 	WHERE Z6_CODENT = %Exp:QCRPR130->REDE%
		 	AND Z6_FILIAL = %Exp:xFilial("SZ6")% 
		 	AND Z6_PERIODO = %Exp:QCRPR130->PERIODO% 
		 	AND Z6_CODCCR = %Exp:QCRPR130->CODENT% 
		 	AND SZ6.%NotDel% 
		 EndSql
		 
		 nBaseHw := Q130_SUM->BASEHW
		 nBaseSw := Q130_SUM->BASESW
		 
		 Q130_SUM->(dbCloseArea())
		 
	EndIf*/
			
	oExcel:AddRow(cNomArq, cNomArq,{QCRPR130->REDE 	,;
									QCRPR130->CODENT,;
							       	QCRPR130->DESENT,;
							       	SZ3->Z3_CGC		,;
							       	Iif(QCRPR130->CODENT != "073322",Str(QCRPR130->CONPED),"0"),;
									Iif(QCRPR130->CODENT != "073322",QCRPR130->VALSW	  ,0  ),;
									Iif(QCRPR130->CODENT != "073322",QCRPR130->VALHW	  ,0  ),;
									Iif(QCRPR130->CODENT != "073322",QCRPR130->VALPRD	  ,0  ),;
									TRBSUM->CONTADOR,;
									TRBSUM->VALOR_SOFTWARE,;
									TRBSUM->VALOR_HARDWARE,;
									TRBSUM->VALOR_PRODUTO,;
									QCRPR130->COMSW	,;
									QCRPR130->COMHW ,;
									QCRPR130->VALCOM,;
									QCRPR130->FEDSW,;
									QCRPR130->FEDHW,;
									QCRPR130->VALFED,;
									QCRPR130->CAMPSW,;
									QCRPR130->CAMPHW,;
									QCRPR130->VALCAMP,;
									QCRPR130->ZZ6_ARSW,;
									QCRPR130->ZZ6_ARHW,;
									QCRPR130->ZZ6_VALAR,;
									QCRPR130->POSSW,;
									QCRPR130->POSHW,;
									QCRPR130->VALPOS,;
									QCRPR130->VALVIS,;
									QCRPR130->TOTAL,;
									QCRPR130->PEDCOM,;
									QCRPR130->DATGER,;
									QCRPR130->NOTA,;
									QCRPR130->DT_EMISSAO})

											
	nCONPED	+= Iif(QCRPR130->CODENT != "073322",QCRPR130->CONPED 	  ,0  )
	nVALSW 	+= Iif(QCRPR130->CODENT != "073322",QCRPR130->VALSW	  	  ,0  )
	nVALHW	+= Iif(QCRPR130->CODENT != "073322",QCRPR130->VALHW	  	  ,0  )
	nVALPRD	+= Iif(QCRPR130->CODENT != "073322",QCRPR130->VALPRD	  ,0  )
	nCOMSW	+= QCRPR130->COMSW
	nCOMHW	+= QCRPR130->COMHW
	nVALCOM	+= QCRPR130->VALCOM
	nVALFED	+= QCRPR130->VALFED
	nVALCAM += QCRPR130->VALCAMP
	nVALVIS += QCRPR130->VALVIS
	nVALAR	+= QCRPR130->ZZ6_VALAR
	nVALTOT += QCRPR130->TOTAL
	nQtdRev += TRBSUM->CONTADOR
	nValSwR	+= TRBSUM->VALOR_SOFTWARE
	nValHwR += TRBSUM->VALOR_HARDWARE
	nValPrR	+= TRBSUM->VALOR_PRODUTO	
	
	
	//Armazena total geral
	nCONPEDT	+= QCRPR130->CONPED
	nVALSWT 	+= QCRPR130->VALSW
	nVALHWT		+= QCRPR130->VALHW
	nVALPRDT	+= QCRPR130->VALPRD
	nCOMSWT		+= QCRPR130->COMSW
	nCOMHWT		+= QCRPR130->COMHW
	nVALCOMT	+= QCRPR130->VALCOM
	nVALFEDT	+= QCRPR130->VALFED
	nVALCAMT	+= QCRPR130->VALCAMP
	nVALVIST	+= QCRPR130->VALVIS
	nVALART		+= QCRPR130->ZZ6_VALAR
	nVALTOTT	+= QCRPR130->TOTAL
	nQtdRevT 	+= TRBSUM->CONTADOR
	nValSwRT	+= TRBSUM->VALOR_SOFTWARE
	nValHwRT 	+= TRBSUM->VALOR_HARDWARE
	nValPrRT	+= TRBSUM->VALOR_PRODUTO
	
	QCRPR130->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	
	TRBSUM->(dbCloseArea())
	
	If cNomArq <> QCRPR130->PERIODO
		//Gravo os totais
		oExcel:AddRow(cNomArq, cNomArq,{"Subtotal" 				,;
								""						,;
						       	"GRUPO-> "+ Substr(cNomRed,1,4),;
						       	""						,;
						       	Str(nCONPED)			,;
								nVALSW					,;
								nVALHW					,;
								nVALPRD					,;
								nQtdRev 				,;
								nValSwR					,;
								nValHwR 				,;
								nValPrR					,;
								nCOMSW					,;
								nCOMHW					,;
								nVALCOM					,;
								""						,;
								""						,;
								nVALFED					,;
								""						,;
								""						,;
								nVALCAM					,;
								""						,;
								""						,;
								nVALAR					,;
								""						,;
								""						,;
								""						,;
								nVALVIS					,;
								nVALTOT					,;
								""						,;
								""						,;
								""						,;
								""						})
										
		oExcel:AddRow(cNomArq, cNomArq,{"Total Geral"			,;
										""						,;
										"------------------> "	,;
								       	""						,;
								       	Str(nCONPEDT)				,;
										nVALSWT					,;
										nVALHWT					,;
										nVALPRDT				,;
										nQtdRevT 				,;
										nValSwRT				,;
										nValHwRT 				,;
										nValPrRT				,;
										nCOMSWT					,;
										nCOMHWT					,;
										nVALCOMT				,;
										""						,;
										""						,;
										nVALFEDT				,;
										""						,;
										""						,;
										nVALCAMT				,;
										""						,;
										""						,;
										nVALART					,;
										""						,;
										""						,;
										""						,;
										nVALVIST				,;
										nVALTOTT				,;
										""						,;
										""						,;
										""						,;
										""						})								
			
		//Zero subtotais		
		nCONPED	:= 0
		nVALSW 	:= 0
		nVALHW	:= 0
		nVALPRD	:= 0
		nCOMSW	:= 0
		nCOMHW	:= 0
		nVALCOM	:= 0
		nVALFED	:= 0
		nVALCAM := 0
		nVALVIS := 0
		nVALAR	:= 0
		nVALTOT := 0
		nSBaseSw	:= 0 
		nSBaseHw	:= 0
		nQtdRev := 0
		nValSwR	:= 0
		nValHwR := 0
		nValPrR	:= 0
			
	EndIf
	
EndDo
                                   
oExcel:Activate()
oExcel:GetXMLFile(AllTrim(MV_PAR03) + "Relatorio_Notas.XML")


MsgInfo("O relat๓rio foi gerado: " + AllTrim(MV_PAR03) + "Relatorio_Notas.XML" +CRLF+ "Elapsed Time: " + ElapTime(cTimeIni, Time()))

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
PutSX1(	cPerg		,"01" 		,"Periodo de?"	   			,"Periodo de?" 	  	 		,"Periodo de?" 		 		,"mv_ch1" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"Periodo Ate?"	   			,"Periodo Ate?"	  	 		,"Periodo Ate?"		 		,"mv_ch2" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"Diretorio ?"	  			,"Diretorio ?"		  		,"Diretorio ?"		  		,"mv_ch3" 	,"C" 		,75     		,0      		,0     		,"C"		,"U_CRPR130A",""	    ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"Tipo ?"			  		,"Tipo ?"			  		,"Tipo ?"			  		,"mv_ch4" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par04"	,"Geral"   			,"Geral"   			,"Geral"   			,""   		,"Provisใo"  	,"Provisใo"   	,"Provisใo"	    ,""			,"" 		,""			  	,""    		,""		        ,""		        ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"05" 		,"Qtde. Provisใo ?"			,"Qtde. Provisใo ?"	  		,"Qtde. Provisใo ?"	  		,"mv_ch5" 	,"N" 		,03     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par04"	,""		   			,""		   			,""		   			,""   		,""			  	,""			   	,""			    ,""			,"" 		,""			  	,""    		,""		        ,""		        ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

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
User Function CRPR130A()
Local cAux := ""
Local cDirIn := ""

MV_PAR03 := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

Return(.T.)
