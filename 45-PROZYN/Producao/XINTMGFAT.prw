#INCLUDE "rwmake.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"

USER FUNCTION XINTREC(aDados) 
	
	Local x := 0
	Default aDados := {"01","01"}

	RPCSetType(3)
	RpcSetEnv ( aDados[01], aDados[01],,,"FIN",, {"SZR"} ) 

	For x := 1 to Len(ProcName())
		If Alltrim(ProcName(X))!="XINTMGFAT"
			U_XINTMGFAT()
		else
			conout("XINTMGFAT: NAO PERMITIDA EXECUCAO SIMULTANEA")
		Endif               
	Next

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXINTMGFAT บ Autor ณ Daniel Paulo       บ Data ณ  02/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera registros em tabela do Protheus para uso no BI        บฑฑ
ฑฑบ          ณ Esta rotina serแ chamada dentro do JOB                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JOB para exporta็ใo de dados para o BI                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function XINTMGFAT()
	Processa( {|| U_JINTMGFAT(.F.)},"Aguarde", "Gerando tabela SZR...")
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXINTMGFAT บ Autor ณ Daniel Paulo       บ Data ณ  02/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera registros em tabela do Protheus para uso no BI        บฑฑ
ฑฑบ          ณ Esta rotina serแ chamada dentro do JOB                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JOB para exporta็ใo de dados para o BI                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function JBMAILSZR()
	U_JINTMGFAT(.T.)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXINTMGFAT บ Autor ณ Daniel Paulo       บ Data ณ  02/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera registros em tabela do Protheus para uso no BI        บฑฑ
ฑฑบ          ณ Esta rotina serแ chamada dentro do JOB                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JOB para exporta็ใo de dados para o BI                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function JINTMGFAT(lEnvMail)
	Local cQuery	:= ""
	Local CR      	:= Chr(13)+Chr(10)
	Local aFil    	:= {'01'}
	Local nFil    	:= 1 
	Local _cRemet 	:= ''
	Local _cDest  	:= ''
	Local _cAssunto	:= ''
	Local _cMsg   	:= ''
	Local _aAnexos	:= {}
	Local _cPasta 	:= ''
	Local _dtInicio	:= ''
	Local _nC     	:= 0
	Local cOrigem	:= ''
	Local nConimp	:= 0
	Local cCodTran	:= ''
	Local cNomTran	:= ''
	Local cEmissao	:= ''
	Local cVend1	:= ''
	Local nGGFFixo := 0
	Local nTxMoeda := 0
	Local aGGFs := {}
	
	Default lEnvMail := .F.

	RPCSetType(3)
	RpcSetEnv ( "01", aFil[nFil],,,"FIN",, {"SZR"} )

	nGGFFixo := SuperGetMv("MV_GGFFIXO",,0.25)
	nTxMoeda := U_GetMoeda()

	// Variaveis para envio do email.
	_cRemet	  := Trim(GetMV("MV_RELACNT"))	
	_cDest    := SuperGetMv('MV_EMAITRG',, '')
	_cAssunto := 'NFดS de Fat. Operac. Triang sem ref com NFดS de Remessa em ' + DToC(dDataBase)
	// Variaveis para filtro na queries
	_dtInicio := DTOS(SuperGetMv('MV_INIMARG',, '31/12/2016'))
	_cExcCfop := SuperGetMv('MV_EXCMARG',, '5551')
	_cCfvtrg  := SuperGetMv('MV_CFVTRG',, '5122;6122')

	// GERA MASSA DE DADOS DOS PEDIDOS EM CARTEIRA

	cQueryP	:=" SELECT 'P' as ZR_TPOPER, A1_COD ,A1_LOJA, A1_REGIAO,A1_NREDUZ, A1_MUN, C6_ENTREG, A1_VEND, " + CR 
	cQueryP	+=" AOV_DESSEG, A1_EST, AOV_CODSEG, A1_CDRDES, C6_NUM, A3_COD, A3_NREDUZ, E4_DESCRI,  " + CR 
	cQueryP	+=" E4_ACRVEN1, B1_DESCINT, C6_QTDVEN, C6_PRCVEN, C6_VALOR, F4_DUPLIC , F4_ESTOQUE, 
	cQueryP	+=" C6_CF, C6_PRODUTO, A3_NOME, B1_COMOD, A3_NOME, C5_MOEDA, " + CR         
	//Tratamento da Moeda de Faturamento  -  28/11/2018
	cQueryP	+="	(CASE  " + CR 

	//cQueryP	+="	WHEN C5.C5_MOEDA <>'1' AND C5.C5_TXREF <> 0 THEN C5.C5_TXREF " + CR  
	//cQueryP	+="	WHEN C5.C5_MOEDA = '1' THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE C5.C5_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR 
	//cQueryP	+="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA = 0) THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE C5.C5_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR 

	cQueryP +="	WHEN C5.C5_MOEDA IN ('1','0') THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE C5.C5_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR
	cQueryP +="	WHEN C5.C5_MOEDA = '2' AND C5.C5_TXREF <> 0 THEN C5.C5_TXREF " + CR //Alterado por Denis Varella ~ 27/05/21
	cQueryP +="	WHEN C5.C5_MOEDA = '2' AND C5.C5_TXREF = 0 THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE C5.C5_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR //Alterado por Denis Varella ~ 27/05/21
	// cQueryP +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF <> 0 AND C5.C5_TXMOEDA = 0)  THEN C5.C5_TXREF " + CR 
	// cQueryP +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA = 0) THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE C5.C5_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR 
	// cQueryP +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA <> 0) THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE C5.C5_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR 
	cQueryP +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXREF <> 0 AND C5.C5_TXMOEDA = 0) THEN C5.C5_TXREF * 0.88 " + CR      
	//  cQueryP +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXMOEDA <> 0 AND C5.C5_TXREF = 0) THEN C5.C5_TXMOEDA * 0.88 " + CR
	cQueryP +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXMOEDA <> 0 AND C5.C5_TXREF = 0) THEN (SELECT M2_MOEDA4 FROM " + RetSqlName("SM2") + " M2 WHERE C5.C5_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') * 0.88  " + CR 
	cQueryP +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA = 0) THEN (SELECT M2_MOEDA4 FROM " + RetSqlName("SM2") + " M2 WHERE C5.C5_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') * 0.88 " + CR

	//cQueryP	+="	ELSE C5_TXMOEDA END ) AS C5_TXMOEDA, " + CR 
	cQueryP	+="	ELSE 3.6 END ) AS C5_TXMOEDA, " + CR 
	//Tratamento da Moeda de Faturamento  -  28/11/2018
	cQueryP	+=" A1_GRPVEN, ACY_DESCRI, A1_PAIS, YA_DESCR, B1_GRUPO, BM_DESC, A1_UNIDVEN, ADK_NOME, B1_POSIPI, " + CR 
	cQueryP	+=" ( SELECT A4_COD FROM SA4010 WHERE A4_COD = C5_TRANSP) A4_COD, " + CR
	cQueryP	+=" ( SELECT A4_NOME FROM SA4010 WHERE A4_COD = C5_TRANSP) A4_NOME, B1_TIPO, C6_FCICOD, C5_EMISSAO, C5_VEND1,ISNULL(SEG.ZA1_DESC,'') SEGMENTO,ISNULL(LIN.ZA1_DESC,'') LINHA,C5_TPFRETE TPFRETE  " + CR
	cQueryP	+=" FROM " + RetSqlName("SC6") + " C6 " + CR  
	cQueryP	+=" INNER JOIN " + RetSqlName("SA1") + " A1 ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA " + CR 
	cQueryP	+=" LEFT JOIN " + RetSqlName("SA3") + " A3 ON A1_VEND = A3_COD AND A3.D_E_L_E_T_ = ''  " + CR 
	cQueryP	+=" LEFT JOIN " + RetSqlName("ACY") + " CY ON A1_GRPVEN = ACY_GRPVEN AND CY.D_E_L_E_T_ = ''      " + CR 
	cQueryP	+=" LEFT JOIN " + RetSqlName("ADK") + " DK ON A1_UNIDVEN = ADK_COD AND DK.D_E_L_E_T_ = ''  " + CR 
	cQueryP	+=" LEFT JOIN " + RetSqlName("SYA") + " YA ON A1_PAIS = YA_CODGI AND YA.D_E_L_E_T_ = ''   " + CR 
	cQueryP	+=" LEFT JOIN " + RetSqlName("SA7") + " A7 ON C6_CLI = A7_CLIENTE AND C6_LOJA = A7_LOJA AND C6_PRODUTO = A7_PRODUTO AND A7.D_E_L_E_T_ = '' " + CR 
	cQueryP +=" LEFT JOIN " + RetSqlName("ZA1") + " SEG ON SEG.ZA1_COD = A7_XSEG2 AND SEG.ZA1_TIPO = 'SEG' AND SEG.D_E_L_E_T_ = ''
	cQueryP +=" LEFT JOIN " + RetSqlName("ZA1") + " LIN ON LIN.ZA1_COD = A7_XLP AND LIN.ZA1_TIPO = 'LDP' AND LIN.D_E_L_E_T_ = ''
	cQueryP	+=" LEFT JOIN " + RetSqlName("AOV") + " OV ON AOV_CODSEG = A7_XSEGMEN AND OV.D_E_L_E_T_ = '' " + CR 
	cQueryP	+=" INNER JOIN " + RetSqlName("SB1") + " B1 ON C6_PRODUTO = B1_COD" + CR 
	cQueryP	+=" INNER JOIN " + RetSqlName("SC5") + " C5 ON C6_NUM = C5_NUM " + CR 
	cQueryP	+=" LEFT JOIN " + RetSqlName("SBM") + " BM ON B1_GRUPO = BM_GRUPO AND BM.D_E_L_E_T_ = ''" + CR 
	cQueryP	+=" LEFT JOIN " + RetSqlName("SE4") + " E4 ON E4_CODIGO = C5_CONDPAG" + CR 
	cQueryP	+=" INNER JOIN " + RetSqlName("SF4") +"  F4 ON C6_TES = F4_CODIGO" + CR 
	cQueryP	+=" WHERE " + CR 
	cQueryP	+="   C6_ENTREG BETWEEN '"+_dtInicio+"' AND '20491231' AND  " + CR   
	cQueryP	+="   F4_DUPLIC = 'S' AND  " + CR 
	cQueryP	+="   C6_NOTA = '' AND " + CR   
	cQueryP +="   C6_CF NOT IN " +FormatIn(_cExcCfop,";")+ " AND " + CR
	cQueryP	+="   A1_COD BETWEEN '      ' AND 'ZZZZZZ' AND  " + CR 
	cQueryP	+="   A1_VEND BETWEEN '      ' AND 'ZZZZZZ' AND " + CR  
	cQueryP	+="   A7_XSEGMEN BETWEEN '                    ' AND 'ZZZZZZZZZZZZZZZZZZZZ' AND  " + CR 
	cQueryP	+="   A1_CDRDES BETWEEN '          ' AND 'ZZZZZZZZZZ' AND " + CR  
	cQueryP	+="   A1_EST BETWEEN '  ' AND 'ZZ' AND " + CR 
	cQueryP	+="   A1.D_E_L_E_T_=' ' AND  B1.D_E_L_E_T_=' ' AND  C5.D_E_L_E_T_=' ' AND  " + CR 
	cQueryP	+="   C6.D_E_L_E_T_=' ' AND  F4.D_E_L_E_T_=' '" + CR 

	memowrite("GERSZRPQ",cQueryP)
	//cQueryP	+="   AND C6_PRODUTO = '007392         '  

	If Select("QRYP") > 0
		QRYP->( dbCloseArea() )
	EndIf

	// Limpeza do registro da tabela
	TCSQLExec( "DELETE FROM SZR010 WHERE ZR_EMISSAO >= '"+_dtInicio+"' AND ZR_TPOPER = 'P' OR ZR_DOC = '' "   )

	dbUseArea( .T., "TopConn", TCGenQry(,,cQueryP), "QRYP", .F., .F. ) /// Abre a conexao


	DbSelectArea("CFD")
	CFD->(DbSetOrder(2))

	If Select("QRYP") > 0
		dbSelectArea("SZR")
		dbSetOrder(1)
		QRYP->( dbGoTop() )
		While QRYP->( !Eof() )

			/* Verifica se tem codigo FCI
			------------------------------*/
			If CFD->(DbSeek(xFilial("CFD") + QRYP->C6_PRODUTO + SUBSTR(QRYP->C5_EMISSAO,5,2) + LEFT(QRYP->C5_EMISSAO,4)))   
				cOrigem := CFD->CFD_ORIGEM
				nConimp := CFD->CFD_CONIMP
			Endif
			nTxMoeda := Iif(QRYP->C5_MOEDA != 1,QRYP->C5_TXMOEDA,1)
			SZR->(dbAppend(),.T.)  
			SZR->ZR_FILIAL 	:= "  "  
			SZR->ZR_TPOPER    	:= QRYP->ZR_TPOPER
			// SZR->ZR_TOTAL1	:= "  "
			SZR->ZR_COD		:= QRYP->A1_COD     
			SZR->ZR_LJCLIFO   	:= QRYP->A1_LOJA
			SZR->ZR_NREDUZ  	:= QRYP->A1_NREDUZ
			SZR->ZR_MUN  		:= QRYP->A1_MUN 
			SZR->ZR_DTPED 		:= STOD(QRYP->C5_EMISSAO)
			SZR->ZR_EMISSAO 	:= STOD(QRYP->C6_ENTREG)
			//SZR->ZR_PICM 	:= ""
			SZR->ZR_DESSEG		:= QRYP->AOV_DESSEG
			SZR->ZR_REGIAO		:= QRYP->A1_REGIAO
			SZR->ZR_EST 		:= QRYP->A1_EST
			SZR->ZR_CODSEG		:= QRYP->AOV_CODSEG
			SZR->ZR_CDRDES 	:= QRYP->A1_CDRDES
			SZR->ZR_DOC 		:= QRYP->C6_NUM
			SZR->ZR_VCOD		:= QRYP->C5_VEND1  ///QRYP->A3_COD	
			SZR->ZR_VATU		:= QRYP->A3_COD
			SZR->ZR_VREDUZ		:= QRYP->A3_NREDUZ
			//SZR->ZR_DESCRI	:= "  " 
			//SZR->ZR_ACRVEN1:= "  "
			SZR->ZR_DESCINT	:= QRYP->B1_DESCINT 
			SZR->ZR_QUANT		:= QRYP->C6_QTDVEN
			SZR->ZR_PRCVEN		:= QRYP->C6_PRCVEN * nTxMoeda
			//SZR->ZR_VALIPI	:= QRYD->D1_VALIPI 
			//SZR->ZR_VALFRE	:= QRYD->D1_VALFRE 
			//SZR->ZR_VALIMP5:= QRYD->D1_VALIMP5 
			//SZR->ZR_VALIMP6:= QRYD->D1_VALIMP6 
			//SZR->ZR_DIFAL	:= "  "
			//SZR->ZR_ICMSCOM:= QRYD->D1_ICMSCOM 
			//SZR->ZR_VALICM	:= QRYD->D1_VALICM 
			SZR->ZR_TOTAL		:= QRYP->C6_VALOR * nTxMoeda
			//SZR->ZR_CUSTO1	:= QRYD->D1_CUSTO  
			SZR->ZR_DUPLIC 	:= QRYP->F4_DUPLIC 
			SZR->ZR_ESTOQUE	:= QRYP->F4_ESTOQUE   
			SZR->ZR_CF	   		:= QRYP->C6_CF 
			//SZR->ZR_XNFVEN	:= "  "  
			//SZR->ZR_XNFVITE:= "  "
			SZR->ZR_CODPROD	:= QRYP->C6_PRODUTO 
			//SZR->ZR_LOTECTL:= QRYD->D1_LOTECTL
			// SZR->ZR_DTVALID:= STOD(QRYD->D1_DTVALID)
			SZR->ZR_VNOME		:= QRYP->A3_NOME
			SZR->ZR_COMOD		:= QRYP->B1_COMOD
			SZR->ZR_GRPVEN		:= QRYP->A1_GRPVEN
			SZR->ZR_DESCGV		:= QRYP->ACY_DESCRI
			SZR->ZR_PAIS		:= QRYP->A1_PAIS
			SZR->ZR_DSCPAIS	:= QRYP->YA_DESCR
			SZR->ZR_CODGRPR	:= QRYP->B1_GRUPO
			SZR->ZR_DESCGRP	:= QRYP->BM_DESC
			SZR->ZR_MOEDA		:= QRYP->C5_MOEDA
			SZR->ZR_TXMOEDA	:= QRYP->C5_TXMOEDA
			//SZR->ZR_DESCON	:= QRYD->D1_VALDESC
			//SZR->ZR_DESCZFC:= " "
			//SZR->ZR_DESCZFP:= " "
			//SZR->ZR_DESCZFR:= " "
			SZR->ZR_UNIDVEN	:= QRYP->A1_UNIDVEN
			SZR->ZR_DECUNVN	:= QRYP->ADK_NOME  
			SZR->ZR_NCM		:= QRYP->B1_POSIPI
			//SZR->ZR_DESPESA:= QRYD->D1_DESPESA 
			//SZR->ZR_SEGURO := QRYD->D1_SEGURO  
			SZR->ZR_CODTRAN	:= QRYP->A4_COD
			SZR->ZR_NOMTRAN	:= QRYP->A4_NOME
			SZR->ZR_FCICOD		:= QRYP->C6_FCICOD 
			SZR->ZR_TIPPROD	:= QRYP->B1_TIPO
			SZR->ZR_ORIGEM		:= cOrigem
			SZR->ZR_CONIMP		:= nConimp
			
			/* Novos campos BI - Denis Varella 17/05/22 */
			nTotalFat := SZR->ZR_TOTAL + SZR->ZR_VALIPI
			nImpostos := (SZR->ZR_VALICM + SZR->ZR_VALIMP5 + SZR->ZR_VALIMP6 + SZR->ZR_DIFAL + SZR->ZR_ICMSCOM)
			nNetSales := nTotalFat - nImpostos
			If nTotalFat > 9999999
				nTotalFat := nTotalFat
			EndIf
			SZR->ZR_VLBRUTO := nTotalFat
			SZR->ZR_MRGBRUT := nNetSales - (SZR->ZR_CUSTO1 + SZR->ZR_FRETCIF + SZR->ZR_CUSTFIN)

			SZR->ZR_TIPOFRE := QRYP->TPFRETE
			SZR->ZR_SGMTACA := QRYP->SEGMENTO
			SZR->ZR_LINHA := QRYP->LINHA
			/* Novos campos BI - Denis Varella 17/05/22 */

			SZR->(MSUNLOCK())
			QRYP->( dbSkip() )
		Enddo		
	EndIf

	If Select("QRYP") > 0
		QRYP->( dbCloseArea() )
	EndIf 

	//------


	// GERA MASSA DE DADOS DAS NOTAS DE ENTRADA DEVOLUวรO

	cQueryD	:=" SELECT 'D' as ZR_TPOPER,A1_COD,A1_LOJA,A1_NREDUZ, A1_REGIAO,A1_MUN, F1_EST, AOV_CODSEG, A1_CDRDES, A1_VEND, " + CR 
	cQueryD	+=" F1_DTDIGIT,AOV_DESSEG,A3_COD, A3_NREDUZ,B1_DESCINT,D1_DOC,(D1_QUANT*-1) AS D1_QUANT ,(D1_VUNIT*-1) as D1_VUNIT, " + CR 
	cQueryD	+=" (D1_VALFRE*-1)AS D1_VALFRE,D1_PICM, (D1_VALIPI*-1)AS D1_VALIPI, (D1_VALICM*-1)AS D1_VALICM, (D1_VALIMP5*-1)AS D1_VALIMP5, (D1_VALIMP6*-1)AS D1_VALIMP6, (D1_ICMSCOM*-1)AS D1_ICMSCOM, " + CR 
	cQueryD	+="   F4_DUPLIC, F4_ESTOQUE,D1_CF,(D1_CUSTO*-1)AS D1_CUSTO,D1_COD, (D1_TOTAL*-1) AS D1_TOTAL, D1_LOTECTL, D1_DTVALID, A3_NOME, B1_COMOD, A1_GRPVEN, ACY_DESCRI, A1_PAIS, YA_DESCR, B1_GRUPO, BM_DESC, 

	// Tratamento da moeda de faturamento  - 28/11/2018

	cQueryD	+=" ISNULL((SELECT DISTINCT C5_MOEDA FROM " + RetSqlName("SD1") + " D12 
	cQueryD	+=" INNER JOIN " + RetSqlName("SD2") + " DY ON
	cQueryD	+=" D1.D1_NFORI = DY.D2_DOC AND
	cQueryD	+=" DY.D_E_L_E_T_<> '*'
	cQueryD	+=" INNER JOIN " + RetSqlName("SC5") + " C5 ON C5_NUM = D2_PEDIDO AND
	cQueryD	+=" C5.D_E_L_E_T_<> '*'
	cQueryD	+=" WHERE
	cQueryD	+=" D12.D1_DOC = D1.D1_DOC AND
	cQueryD	+=" D12.D1_SERIE = D1.D1_SERIE AND
	cQueryD	+=" D12.D_E_L_E_T_<> '*' AND
	cQueryD	+=" D12.D1_TIPO = 'D'),0) AS F1_MOEDA,

	cQueryD	+=" ISNULL((SELECT DISTINCT C5_EMISSAO FROM " + RetSqlName("SD1") + " D12 
	cQueryD	+=" INNER JOIN " + RetSqlName("SD2") + " DY ON
	cQueryD	+=" D1.D1_NFORI = DY.D2_DOC AND
	cQueryD	+=" DY.D_E_L_E_T_<> '*'
	cQueryD	+=" INNER JOIN " + RetSqlName("SC5") + " C5 ON C5_NUM = D2_PEDIDO AND
	cQueryD	+=" C5.D_E_L_E_T_<> '*'
	cQueryD	+=" WHERE
	cQueryD	+=" D12.D1_DOC = D1.D1_DOC AND
	cQueryD	+=" D12.D1_SERIE = D1.D1_SERIE AND
	cQueryD	+=" D12.D_E_L_E_T_<> '*' AND
	cQueryD	+=" D12.D1_TIPO = 'D'),0) AS C5_EMISSAO,


	cQueryD	+=" (ISNULL((SELECT DISTINCT CASE   " + CR  
	//cQueryD	+="	WHEN C5.C5_MOEDA <>'1' AND C5.C5_TXREF <> 0 THEN C5.C5_TXREF  " + CR 
	//cQueryD	+="	WHEN C5.C5_MOEDA = '1' THEN (SELECT DISTINCT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE DY.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*')  " + CR 
	//cQueryD	+="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA = 0) THEN (SELECT DISTINCT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE DY.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*')  " + CR 


	cQueryD +="	WHEN C5.C5_MOEDA IN ('1','0') THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE DY.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR
	// cQueryD +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF <> 0 AND C5.C5_TXMOEDA = 0)  THEN C5.C5_TXREF " + CR 
	// cQueryD +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA = 0) THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE DY.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR  
	// cQueryD +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA <> 0) THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE DY.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR 
	cQueryD +="	WHEN C5.C5_MOEDA = '2' AND C5.C5_TXREF <> 0 THEN C5.C5_TXREF " + CR //Alterado por Denis Varella ~ 27/05/21
	cQueryD +="	WHEN C5.C5_MOEDA = '2' AND C5.C5_TXREF = 0 THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE DY.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR //Alterado por Denis Varella ~ 27/05/21
	cQueryD +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXREF <> 0 AND C5.C5_TXMOEDA = 0) THEN C5.C5_TXREF * 0.88 " + CR      
	//  cQueryD +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXMOEDA <> 0 AND C5.C5_TXREF = 0) THEN C5.C5_TXMOEDA * 0.88 " + CR   
	cQueryD +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXMOEDA <> 0 AND C5.C5_TXREF = 0) THEN (SELECT M2_MOEDA4 FROM " + RetSqlName("SM2") + " M2 WHERE DY.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') * 0.88 " + CR
	cQueryD +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA = 0) THEN (SELECT M2_MOEDA4 FROM " + RetSqlName("SM2") + " M2 WHERE DY.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') * 0.88 " + CR

	cQueryD	+="	ELSE  " + CR 
	//cQueryD	+="	C5_TXMOEDA END    " + CR  
	cQueryD	+="	3.6 END    " + CR 
	cQueryD	+=" FROM " + RetSqlName("SD1") + " D12  " + CR 
	cQueryD	+=" INNER JOIN " + RetSqlName("SD2") + " DY ON  " + CR 
	cQueryD	+=" D12.D1_NFORI = DY.D2_DOC AND  " + CR 
	cQueryD	+=" D12.D1_SERIORI = DY.D2_SERIE AND  " + CR 
	//  cQueryD	+=" D12.D1_ITEMORI = DY.D2_ITEM AND  " + CR 
	cQueryD	+=" DY.D_E_L_E_T_<> '*'  " + CR 
	cQueryD	+=" INNER JOIN " + RetSqlName("SC5") + " C5 ON C5_NUM = D2_PEDIDO AND  " + CR 
	cQueryD	+=" C5.D_E_L_E_T_<> '*'  " + CR 
	cQueryD	+=" WHERE  " + CR 
	cQueryD	+=" D12.D1_DOC = D1.D1_DOC AND  " + CR 
	cQueryD	+=" D12.D1_SERIE = D1.D1_SERIE AND  " + CR 
	cQueryD	+=" D12.D1_ITEM = D1.D1_ITEM AND  " + CR 
	cQueryD	+=" D12.D_E_L_E_T_<> '*' AND  " + CR 
	cQueryD	+=" D12.D1_TIPO = 'D'),3.6))*-1 AS F1_TXMOEDA,  " + CR        // CASO O VALOR SEJA 0, ASSUMIR 3.60

	// Tratamento da moeda de faturamento  - 28/11/2018 

	cQueryD	+=" (D1_VALDESC*-1) AS D1_VALDESC, A1_UNIDVEN, ADK_NOME, B1_POSIPI, D1_DESPESA, D1_SEGURO,ISNULL(SEG.ZA1_DESC,'') SEGMENTO,ISNULL(LIN.ZA1_DESC,'') LINHA  " + CR 
	cQueryD	+="   FROM " + RetSqlName("SD1") + " D1 " + CR  
	cQueryD	+="   INNER JOIN " + RetSqlName("SA1") + " A1 ON D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA  " + CR 
	cQueryD	+="   LEFT JOIN " + RetSqlName("SA3") + " A3 ON A1_VEND = A3_COD AND A3.D_E_L_E_T_ = '' " + CR   
	cQueryD	+="   LEFT JOIN " + RetSqlName("ACY") + " CY ON A1_GRPVEN = ACY_GRPVEN AND CY.D_E_L_E_T_ = '' " + CR     
	cQueryD	+="   LEFT JOIN " + RetSqlName("SYA") + " YA ON A1_PAIS = YA_CODGI AND YA.D_E_L_E_T_ = '' " + CR            
	cQueryD	+="   LEFT JOIN " + RetSqlName("ADK") + " DK ON A1_UNIDVEN = ADK_COD AND DK.D_E_L_E_T_ = '' " + CR  
	cQueryD	+="   LEFT JOIN " + RetSqlName("SA7") + " A7 ON D1_FORNECE = A7_CLIENTE AND D1_LOJA = A7_LOJA AND D1_COD = A7_PRODUTO AND A7.D_E_L_E_T_ = ''    " + CR 
	cQueryD	+="   LEFT JOIN " + RetSqlName("ZA1") + " SEG ON SEG.ZA1_COD = A7_XSEG2 AND SEG.ZA1_TIPO = 'SEG' AND SEG.D_E_L_E_T_ = ''
	cQueryD	+="   LEFT JOIN " + RetSqlName("ZA1") + " LIN ON LIN.ZA1_COD = A7_XLP AND LIN.ZA1_TIPO = 'LDP' AND LIN.D_E_L_E_T_ = ''
	cQueryD	+="   LEFT JOIN " + RetSqlName("AOV") + " OV ON AOV_CODSEG = A7_XSEGMEN AND OV.D_E_L_E_T_ = ''    " + CR 
	cQueryD	+="   INNER JOIN " + RetSqlName("SB1") + " B1 ON D1_COD = B1_COD  " + CR    
	cQueryD	+="   LEFT JOIN " + RetSqlName("SBM") + " BM ON B1_GRUPO = BM_GRUPO AND BM.D_E_L_E_T_ = '' " + CR   
	cQueryD	+="   INNER JOIN " + RetSqlName("SF1") + " F1 ON D1_DOC = F1_DOC and D1_SERIE = F1_SERIE  " + CR 
	cQueryD	+="   INNER JOIN " + RetSqlName("SF4") + " F4 ON D1_TES = F4_CODIGO " + CR  
	cQueryD	+="   WHERE   " + CR 
	cQueryD	+="   D1_TIPO = 'D' AND  D1_DTDIGIT BETWEEN '"+_dtInicio+"' AND '20491231' AND  " + CR   
	cQueryD	+="   F4_DUPLIC = 'S' AND  " + CR 
	cQueryD	+="   A1_COD BETWEEN '      ' AND 'ZZZZZZ' AND  " + CR 
	cQueryD	+="   A1_VEND BETWEEN '      ' AND 'ZZZZZZ' AND " + CR  
	cQueryD	+="   A7_XSEGMEN BETWEEN '                    ' AND 'ZZZZZZZZZZZZZZZZZZZZ' AND  " + CR 
	cQueryD	+="   A1_CDRDES BETWEEN '          ' AND 'ZZZZZZZZZZ' AND " + CR  
	cQueryD	+="   F1_EST BETWEEN '  ' AND 'ZZ' AND " + CR 
	cQueryD	+="   A1.D_E_L_E_T_=' ' AND  B1.D_E_L_E_T_=' ' AND  D1.D_E_L_E_T_=' ' AND  " + CR 
	cQueryD	+="   F1.D_E_L_E_T_=' ' AND  F4.D_E_L_E_T_=' '" + CR   

	memowrite("GERSZRENT",cQueryD)

	If Select("QRYD") > 0
		QRYD->( dbCloseArea() )
	EndIf

	// Limpeza do registro da tabela
	TCSQLExec( "DELETE FROM SZR010 WHERE ZR_EMISSAO >= '"+_dtInicio+"' AND ZR_TPOPER = 'D' OR ZR_DOC = '' "   )


	dbUseArea( .T., "TopConn", TCGenQry(,,cQueryD), "QRYD", .F., .F. ) /// Abre a conexao

	If Select("QRYD") > 0
		dbSelectArea("SZR")
		dbSetOrder(1)
		QRYD->( dbGoTop() )
		While QRYD->( !Eof() )
			SZR->(dbAppend(),.T.)  
			SZR->ZR_FILIAL 	:= "  "  
			SZR->ZR_TPOPER     := QRYD->ZR_TPOPER
			// SZR->ZR_TOTAL1		:= "  "
			SZR->ZR_COD		:= QRYD->A1_COD     
			SZR->ZR_LJCLIFO    := QRYD->A1_LOJA
			SZR->ZR_NREDUZ  	:= QRYD->A1_NREDUZ
			SZR->ZR_MUN  		:= QRYD->A1_MUN 
			SZR->ZR_DTPED		:= STOD(QRYD->C5_EMISSAO)
			SZR->ZR_EMISSAO 	:= STOD(QRYD->F1_DTDIGIT)
			SZR->ZR_PICM 		:= QRYD->D1_PICM
			SZR->ZR_DESSEG		:= QRYD->AOV_DESSEG
			SZR->ZR_REGIAO		:= QRYD->A1_REGIAO
			SZR->ZR_EST 		:= QRYD->F1_EST
			SZR->ZR_CODSEG		:= QRYD->AOV_CODSEG
			SZR->ZR_CDRDES 	:= QRYD->A1_CDRDES
			SZR->ZR_DOC 		:= QRYD->D1_DOC
			SZR->ZR_VCOD		:= QRYD->A3_COD	
			SZR->ZR_VATU		:= QRYD->A3_COD
			SZR->ZR_VREDUZ		:= QRYD->A3_NREDUZ
			//SZR->ZR_DESCRI 	:= "  " 
			//SZR->ZR_ACRVEN1	:= "  "
			SZR->ZR_DESCINT	:= QRYD->B1_DESCINT 
			SZR->ZR_QUANT		:= QRYD->D1_QUANT
			SZR->ZR_PRCVEN		:= QRYD->D1_VUNIT
			SZR->ZR_VALIPI		:= QRYD->D1_VALIPI 
			SZR->ZR_VALFRE		:= QRYD->D1_VALFRE 
			SZR->ZR_VALIMP5	:= QRYD->D1_VALIMP5 
			SZR->ZR_VALIMP6	:= QRYD->D1_VALIMP6 
			//SZR->ZR_DIFAL		:= "  "
			SZR->ZR_ICMSCOM	:= QRYD->D1_ICMSCOM 
			SZR->ZR_VALICM		:= QRYD->D1_VALICM 
			SZR->ZR_TOTAL		:= QRYD->D1_TOTAL 
			SZR->ZR_CUSTO1		:= QRYD->D1_CUSTO  
			SZR->ZR_DUPLIC 	:= QRYD->F4_DUPLIC 
			SZR->ZR_ESTOQUE	:= QRYD->F4_ESTOQUE   
			SZR->ZR_CF	   		:= QRYD->D1_CF 
			//SZR->ZR_XNFVEN		:= "  "  
			//SZR->ZR_XNFVITE	:= "  "
			SZR->ZR_CODPROD	:= QRYD->D1_COD 
			SZR->ZR_LOTECTL	:= QRYD->D1_LOTECTL
			SZR->ZR_DTVALID	:= STOD(QRYD->D1_DTVALID)
			SZR->ZR_VNOME		:= QRYD->A3_NOME
			SZR->ZR_COMOD		:= QRYD->B1_COMOD
			SZR->ZR_GRPVEN		:= QRYD->A1_GRPVEN
			SZR->ZR_DESCGV		:= QRYD->ACY_DESCRI
			SZR->ZR_PAIS		:= QRYD->A1_PAIS
			SZR->ZR_DSCPAIS	:= QRYD->YA_DESCR
			SZR->ZR_CODGRPR	:= QRYD->B1_GRUPO
			SZR->ZR_DESCGRP	:= QRYD->BM_DESC
			SZR->ZR_MOEDA		:= QRYD->F1_MOEDA
			SZR->ZR_TXMOEDA	:= QRYD->F1_TXMOEDA
			SZR->ZR_DESCON		:= QRYD->D1_VALDESC
			//SZR->ZR_DESCZFC	:= " "
			//SZR->ZR_DESCZFP	:= " "
			//SZR->ZR_DESCZFR	:= " "
			SZR->ZR_UNIDVEN	:= QRYD->A1_UNIDVEN
			SZR->ZR_DECUNVN	:= QRYD->ADK_NOME  
			SZR->ZR_NCM		:= QRYD->B1_POSIPI
			SZR->ZR_DESPESA	:= QRYD->D1_DESPESA 
			SZR->ZR_SEGURO 	:= QRYD->D1_SEGURO   
			

			/* Novos campos BI - Denis Varella 17/05/22 */
			nTotalFat := SZR->ZR_TOTAL + SZR->ZR_VALIPI
			nImpostos := (SZR->ZR_VALICM + SZR->ZR_VALIMP5 + SZR->ZR_VALIMP6 + SZR->ZR_ICMSCOM) // + SZR->ZR_DIFAL
			nNetSales := nTotalFat - nImpostos
			
			nCustoB9 := QRYD->D1_CUSTO / QRYD->D1_QUANT

			SZR->ZR_VLBRUTO := nTotalFat
			SZR->ZR_IMPOSTO := nImpostos

			SZR->ZR_MOEDAMD := nTxMoeda
			SZR->ZR_GGF := 0
			SZR->ZR_GGFFIXO := 0
			SZR->ZR_CPVKG := nCustoB9

			SZR->ZR_PRCNET := nTotalFat - nImpostos
			SZR->ZR_CUSTFIN := 0
			SZR->ZR_FRETCIF := 0

			SZR->ZR_MRGBRUT := nNetSales - (SZR->ZR_CUSTO1 + SZR->ZR_FRETCIF + SZR->ZR_CUSTFIN)
			SZR->ZR_PORCMRG := SZR->ZR_MRGBRUT * 100 / nNetSales
			SZR->ZR_CUSTKG := nCustoB9 + ((SZR->ZR_FRETCIF + SZR->ZR_CUSTFIN) / SZR->ZR_QUANT)
			SZR->ZR_XCTKGAN := (SZR->ZR_CUSTO1 + SZR->ZR_FRETCIF + SZR->ZR_CUSTFIN) / SZR->ZR_QUANT

			SZR->ZR_SGMTACA := QRYD->SEGMENTO
			SZR->ZR_LINHA := QRYD->LINHA
			
			/* Fim - Denis Varella 17/05/22 */
			
			SZR->(MSUNLOCK())
			QRYD->( dbSkip() )
		Enddo		
	EndIf

	If Select("QRYD") > 0
		QRYD->( dbCloseArea() )
	EndIf 

	//------


	// GERA MASSA DE DADOS DAS NOTAS DE SAIDA

	cQuery	:=" SELECT 'V' as ZR_TPOPER, A1_COD ,A1_LOJA, A1_REGIAO,A1_NREDUZ, A1_MUN, A1_VEND, F2_EMISSAO, D2_PICM," + CR  
	cQuery	+=" (SELECT SUM(D1_TOTAL) FROM SD1010 D1 WHERE D2_DOC = D1_NFSAIDA AND D1_TIPO <> 'D' AND D1.D_E_L_E_T_ <> '*' ) AS ZR_TTFRT, " + CR 
	cQuery	+=" (SELECT SUM(D2_TOTAL + D2_VALIPI) FROM SD2010 DX WHERE DX.D2_DOC = D2.D2_DOC AND DX.D2_SERIE = D2.D2_SERIE AND DX.D_E_L_E_T_=' ')AS ZR_TTITNF, " + CR 
	cQuery +=" AOV_DESSEG, F2_EST, AOV_CODSEG, A1_CDRDES, D2_DOC, A3_COD, A3_NREDUZ, E4_DESCRI, " + CR
	cQuery +=" E4_ACRVEN1, B1_DESCINT, D2_QUANT, D2_PRCVEN, D2_VALIPI, D2_VALFRE, D2_VALIMP5," + CR
	cQuery +=" D2_VALIMP6, D2_DIFAL, D2_ICMSCOM, D2_VALICM, D2_TOTAL, D2_CUSTO1, F4_DUPLIC , F4_ESTOQUE,  " + CR
	cQuery +=" D2_CF, D2_XNFVEN, D2_XNFVITE, D2_COD, D2_LOTECTL, D2_DTVALID, A3_NOME, B1_COMOD, A1_GRPVEN, ACY_DESCRI, A1_PAIS, YA_DESCR, B1_GRUPO, BM_DESC, " + CR

	// Tratamento da moeda de faturamento  - 28/11/2018 

	cQuery +=" (SELECT C5.C5_MOEDA FROM " + RetSqlName("SC5") + " C5 WHERE C5.C5_NUM = D2.D2_PEDIDO AND  C5.D_E_L_E_T_<> '*') AS F2_MOEDA, " + CR

	cQuery +="	ISNULL((SELECT CASE " + CR
	cQuery +="	WHEN C5.C5_MOEDA IN ('1','0') THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE D2.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR
	// cQuery +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF <> 0 AND C5.C5_TXMOEDA = 0)  THEN C5.C5_TXREF " + CR
	//cQuery +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF <> 0 AND C5.C5_TXMOEDA <> 0)  THEN C5.C5_TXREF " + CR   -Bruno Rian 21/12
	// cQuery +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA = 0) THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE D2.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR 
	// cQuery +="	WHEN C5.C5_MOEDA = '2' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA <> 0) THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE D2.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR 
	cQuery +="	WHEN C5.C5_MOEDA = '2' AND C5.C5_TXREF <> 0 THEN C5.C5_TXREF " + CR //Alterado por Denis Varella ~ 27/05/21
	cQuery +="	WHEN C5.C5_MOEDA = '2' AND C5.C5_TXREF = 0 THEN (SELECT M2_MOEDA2 FROM " + RetSqlName("SM2") + " M2 WHERE D2.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') " + CR //Alterado por Denis Varella ~ 27/05/21
	cQuery +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXREF <> 0 AND C5.C5_TXMOEDA = 0) THEN C5.C5_TXREF * 0.88 " + CR      
	//cQuery +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXMOEDA <> 0 AND C5.C5_TXREF = 0) THEN C5.C5_TXMOEDA * 0.88 " + CR
	cQuery +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXMOEDA <> 0 AND C5.C5_TXREF = 0) THEN (SELECT M2_MOEDA4 FROM " + RetSqlName("SM2") + " M2 WHERE D2.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') * 0.88 " + CR
	cQuery +="	WHEN C5.C5_MOEDA = '4' AND (C5.C5_TXREF = 0 AND C5.C5_TXMOEDA = 0) THEN (SELECT M2_MOEDA4 FROM " + RetSqlName("SM2") + " M2 WHERE D2.D2_EMISSAO = M2_DATA AND M2.D_E_L_E_T_<> '*') * 0.88 " + CR
	//cQuery +="	ELSE C5_TXMOEDA END FROM SC5010 C5 WHERE C5.C5_NUM = D2.D2_PEDIDO AND  C5.D_E_L_E_T_<> '*'),3.60) AS F2_TXMOEDA, " + CR  
	cQuery +="	ELSE 3.6 END FROM SC5010 C5 WHERE C5.C5_NUM = D2.D2_PEDIDO AND  C5.D_E_L_E_T_<> '*'),3.60) AS F2_TXMOEDA, " + CR

	// Tratamento da moeda de faturamento  - 28/11/2018  

	cQuery +=" D2_DESCON, D2_DESCZFC, D2_DESCZFP, D2_DESCZFR,A1_UNIDVEN, ADK_NOME, " + CR
	cQuery +=" B1_POSIPI, D2_DESPESA, D2_SEGURO, D2_PEDIDO, D2_FCICOD, B1_TIPO,F2_VEND1,ISNULL(SEG.ZA1_DESC,'') SEGMENTO,ISNULL(LIN.ZA1_DESC,'') LINHA,CASE WHEN F2_TPFRETE IS NULL THEN PED.C5_TPFRETE ELSE F2_TPFRETE END TPFRETE " + CR
	cQuery +=" FROM " + RetSqlName("SD2") + " D2 " + CR
	cQuery +=" INNER JOIN " + RetSqlName("SA1") + " A1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA  " + CR
	cQuery +=" LEFT JOIN " + RetSqlName("SC5") + "  PED ON PED.C5_NUM = D2.D2_PEDIDO AND  PED.D_E_L_E_T_ = ''   " + CR
	cQuery +=" LEFT JOIN " + RetSqlName("SA3") + "  A3 ON A1_VEND = A3_COD AND A3.D_E_L_E_T_ = ''   " + CR
	cQuery	+=" LEFT JOIN " + RetSqlName("ACY") + " CY ON A1_GRPVEN = ACY_GRPVEN AND CY.D_E_L_E_T_ = '' " + CR      
	cQuery	+=" LEFT JOIN " + RetSqlName("ADK") + " DK ON A1_UNIDVEN = ADK_COD AND DK.D_E_L_E_T_ = '' " + CR  
	cQuery	+=" LEFT JOIN " + RetSqlName("SYA") + " YA ON A1_PAIS = YA_CODGI AND YA.D_E_L_E_T_ = '' " + CR  
	cQuery 	+=" LEFT JOIN " + RetSqlName("SA7") + "  A7 ON D2_CLIENTE = A7_CLIENTE AND D2_LOJA = A7_LOJA AND D2_COD = A7_PRODUTO AND A7.D_E_L_E_T_ = ''    " + CR
	cQuery 	+=" LEFT JOIN " + RetSqlName("ZA1") + " SEG ON SEG.ZA1_COD = A7_XSEG2 AND SEG.ZA1_TIPO = 'SEG' AND SEG.D_E_L_E_T_ = ''
	cQuery 	+=" LEFT JOIN " + RetSqlName("ZA1") + " LIN ON LIN.ZA1_COD = A7_XLP AND LIN.ZA1_TIPO = 'LDP' AND LIN.D_E_L_E_T_ = ''
	cQuery +=" LEFT JOIN " + RetSqlName("AOV") + "  OV ON AOV_CODSEG = A7_XSEGMEN AND OV.D_E_L_E_T_ = ''    " + CR
	cQuery +=" INNER JOIN " + RetSqlName("SB1") + " B1 ON D2_COD = B1_COD  " + CR
	cQuery +=" INNER JOIN " + RetSqlName("SF2") + " F2 ON D2_DOC = F2_DOC and D2_SERIE = F2_SERIE  " + CR
	cQuery	+=" LEFT JOIN " + RetSqlName("SBM") + " BM ON B1_GRUPO = BM_GRUPO AND BM.D_E_L_E_T_ = '' " + CR   
	cQuery +=" LEFT JOIN " + RetSqlName("SE4") + "  E4 ON E4_CODIGO = F2_COND  " + CR
	cQuery +=" INNER JOIN " + RetSqlName("SF4") + " F4 ON D2_TES = F4_CODIGO  " + CR
	// cQuery +=" LEFT JOIN " + RetSqlName("SD1") + "  D1 ON D2_DOC = D1_NFSAIDA AND D1_TIPO <> 'D' AND D1.D_E_L_E_T_ <> '*'  " + CR
	cQuery +=" WHERE " + CR
	cQuery +=" D2_EMISSAO BETWEEN '"+_dtInicio+"' AND '20491231' AND " + CR  
	cQuery	+=" F4_DUPLIC = 'S' AND  " + CR 
	cQuery +=" D2_TIPO <> 'D' AND	" + CR 
	cQuery +=" D2_CF NOT IN " +FormatIn(_cExcCfop,";")+ " AND" + CR
	cQuery +=" A1_COD BETWEEN '      ' AND 'ZZZZZZ' AND  " + CR
	cQuery +=" A1_VEND BETWEEN '      ' AND 'ZZZZZZ' AND  " + CR
	cQuery +=" A7_XSEGMEN BETWEEN '                    ' AND 'ZZZZZZZZZZZZZZZZZZZZ' AND  " + CR
	cQuery +=" A1_REGIAO BETWEEN '          ' AND 'ZZZZZZZZZZ' AND  " + CR
	cQuery +=" F2_EST BETWEEN '  ' AND 'ZZ' AND " + CR
	cQuery +=" A1.D_E_L_E_T_=' ' AND A3.D_E_L_E_T_=' ' AND   A7.D_E_L_E_T_=' ' AND   B1.D_E_L_E_T_=' ' AND " + CR 
	cQuery +=" D2.D_E_L_E_T_=' ' AND E4.D_E_L_E_T_=' ' AND   F2.D_E_L_E_T_=' ' AND   F4.D_E_L_E_T_=' ' " + CR 

	memowrite("GERSZRSAI",cQuery)

	If Select("QRY") > 0
		QRY->( dbCloseArea() )
	EndIf

	// Limpeza do registro da tabela
	TCSQLExec( "DELETE FROM SZR010 WHERE ZR_EMISSAO >= '"+_dtInicio+"' AND ZR_TPOPER = 'V' OR ZR_DOC = '' ")

	// tratar dele็ใo conforme parametro MV_

	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. ) /// Abre a conexao


	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	DbSelectArea("SA4")
	SA4->(DbSetOrder(1))


	If Select("QRY") > 0
		dbSelectArea("SZR")
		dbSetOrder(1)
		QRY->( dbGoTop() )
		While QRY->( !Eof() )

			If SC5->(DbSeek(xFilial("SC5") + QRY->D2_PEDIDO )) 
				cVend1:= SC5->C5_VEND1
				If SA4->(DbSeek(xFilial("SA4") + SC5->C5_TRANSP ))
					cCodTran	:= SA4->A4_COD
					cNomTran	:= SA4->A4_NOME 
					cEmissao	:= DTOS(SC5->C5_EMISSAO)
				Endif 
				If CFD->(DbSeek(xFilial("CFD") + QRY->D2_COD + SUBSTR(cEmissao,5,2) + LEFT(cEmissao,4)))   
					cOrigem := CFD->CFD_ORIGEM
					nConimp := CFD->CFD_CONIMP
				Endif
			Endif

			SZR->(dbAppend(),.T.)  
			SZR->ZR_FILIAL 		:= "  "  
			SZR->ZR_TPOPER     	:= QRY->ZR_TPOPER
			//SZR->ZR_TOTAL1 	:= QRY->D1_TOTAL
			SZR->ZR_COD		   	:= QRY->A1_COD     
			SZR->ZR_LJCLIFO   	:= QRY->A1_LOJA
			SZR->ZR_NREDUZ  	:= QRY->A1_NREDUZ
			SZR->ZR_MUN  		:= QRY->A1_MUN 
			SZR->ZR_DTPED 		:= SC5->C5_EMISSAO
			SZR->ZR_EMISSAO 	:= STOD(QRY->F2_EMISSAO)
			SZR->ZR_PICM 		:= QRY->D2_PICM
			SZR->ZR_DESSEG		:= QRY->AOV_DESSEG
			SZR->ZR_EST 		:= QRY->F2_EST 
			SZR->ZR_REGIAO		:= QRY->A1_REGIAO
			SZR->ZR_CODSEG		:= QRY->AOV_CODSEG
			SZR->ZR_CDRDES 		:= QRY->A1_CDRDES
			SZR->ZR_DOC 		:= QRY->D2_DOC   
			SZR->ZR_VCOD		:= cVend1 //QRY->A3_COD	
			SZR->ZR_VATU		:= QRY->A3_COD
			SZR->ZR_VREDUZ		:= QRY->A3_NREDUZ
			SZR->ZR_DESCRI 		:= QRY->E4_DESCRI 
			SZR->ZR_ACRVEN1		:= QRY->E4_ACRVEN1
			SZR->ZR_DESCINT		:= QRY->B1_DESCINT 
			SZR->ZR_QUANT		:= QRY->D2_QUANT
			SZR->ZR_PRCVEN		:= QRY->D2_PRCVEN
			SZR->ZR_VALIPI		:= QRY->D2_VALIPI 
			SZR->ZR_VALFRE		:= QRY->D2_VALFRE 
			SZR->ZR_VALIMP5		:= QRY->D2_VALIMP5 
			SZR->ZR_VALIMP6		:= QRY->D2_VALIMP6 
			SZR->ZR_DIFAL		:= QRY->D2_DIFAL 
			SZR->ZR_ICMSCOM		:= QRY->D2_ICMSCOM 
			SZR->ZR_VALICM		:= QRY->D2_VALICM 
			SZR->ZR_TOTAL		:= QRY->D2_TOTAL 
			SZR->ZR_CUSTO1		:= QRY->D2_CUSTO1  
			SZR->ZR_DUPLIC 		:= QRY->F4_DUPLIC 
			SZR->ZR_ESTOQUE		:= QRY->F4_ESTOQUE   
			SZR->ZR_CF	   		:= QRY->D2_CF 
			SZR->ZR_XNFVEN		:= QRY->D2_XNFVEN  
			SZR->ZR_XNFVITE		:= QRY->D2_XNFVITE 
			SZR->ZR_CODPROD		:= QRY->D2_COD 
			//SZR->ZR_FRTCIF		:= QRY->ZR_FRTCIF 
			SZR->ZR_LOTECTL		:= QRY->D2_LOTECTL
			SZR->ZR_DTVALID		:= STOD(QRY->D2_DTVALID)
			SZR->ZR_VNOME		:= QRY->A3_NOME
			SZR->ZR_COMOD		:= QRY->B1_COMOD
			SZR->ZR_GRPVEN		:= QRY->A1_GRPVEN
			SZR->ZR_DESCGV		:= QRY->ACY_DESCRI
			SZR->ZR_PAIS		:= QRY->A1_PAIS
			SZR->ZR_DSCPAIS		:= QRY->YA_DESCR
			SZR->ZR_CODGRPR		:= QRY->B1_GRUPO
			SZR->ZR_DESCGRP		:= QRY->BM_DESC
			SZR->ZR_MOEDA		:= QRY->F2_MOEDA
			SZR->ZR_TXMOEDA		:= QRY->F2_TXMOEDA
			SZR->ZR_DESCON		:= QRY->D2_DESCON
			SZR->ZR_DESCZFC		:= QRY->D2_DESCZFC
			SZR->ZR_DESCZFP		:= QRY->D2_DESCZFP
			SZR->ZR_DESCZFR		:= QRY->D2_DESCZFR
			SZR->ZR_UNIDVEN		:= QRY->A1_UNIDVEN
			SZR->ZR_DECUNVN		:= QRY->ADK_NOME  
			SZR->ZR_NCM			:= QRY->B1_POSIPI
			SZR->ZR_DESPESA		:= QRY->D2_DESPESA
			SZR->ZR_SEGURO		:= QRY->D2_SEGURO
			SZR->ZR_TTFRT		:= QRY->ZR_TTFRT
			SZR->ZR_TTITNF		:= QRY->ZR_TTITNF
			SZR->ZR_CODTRAN		:= cCodTran
			SZR->ZR_NOMTRAN		:= cNomTran
			SZR->ZR_FCICOD		:= QRY->D2_FCICOD
			SZR->ZR_TIPPROD		:= QRY->B1_TIPO
			SZR->ZR_ORIGEM		:= cOrigem
			SZR->ZR_CONIMP		:= nConimp

			/* Novos campos BI - Denis Varella 17/05/22 */
			nTotalFat := SZR->ZR_TOTAL + SZR->ZR_VALIPI
			nImpostos := (SZR->ZR_VALICM + SZR->ZR_VALIMP5 + SZR->ZR_VALIMP6 + SZR->ZR_DIFAL + SZR->ZR_ICMSCOM)
			nNetSales := nTotalFat - nImpostos
			
			nPos := aScan(aGGFs, {|x| AllTrim(Upper(x[1])) == AllTrim(Upper(SZR->ZR_CODPROD))})
			nCustoB9 := GetB9Custo(SZR->ZR_CODPROD,SZR->ZR_DOC,SZR->ZR_TPOPER)
			If nPos > 0
				nGGF := aGGFs[nPos][2]
			Else
				nGGF := U_GetGGF(SZR->ZR_CODPROD, SZR->ZR_LOTECTL, SZR->ZR_EMISSAO)
				aAdd(aGGFs, {SZR->ZR_CODPROD,nGGF})
			EndIf

			If !(SZR->ZR_TIPPROD $ 'ME') //Apenas para produtos que nใo sใo de revenda
				nCustoB9 := nCustoB9 - nGGF + (nGGFFixo * nTxMoeda)
			EndIf

			SZR->ZR_VLBRUTO := nTotalFat
			SZR->ZR_IMPOSTO := nImpostos

			SZR->ZR_MOEDAMD := nTxMoeda
			SZR->ZR_GGF := nGGF
			SZR->ZR_GGFFIXO := nGGFFixo
			SZR->ZR_CPVKG := nCustoB9

			SZR->ZR_PRCNET := nTotalFat - nImpostos
			SZR->ZR_CUSTFIN := nTotalFat * SZR->ZR_ACRVEN1 / 100
			SZR->ZR_FRETCIF := SZR->ZR_TTFRT * nTotalFat / SZR->ZR_TTITNF

			SZR->ZR_MRGBRUT := nNetSales - (SZR->ZR_CUSTO1 + SZR->ZR_FRETCIF + SZR->ZR_CUSTFIN)
			SZR->ZR_PORCMRG := SZR->ZR_MRGBRUT * 100 / nNetSales
			SZR->ZR_CUSTKG := nCustoB9 + ((SZR->ZR_FRETCIF + SZR->ZR_CUSTFIN) / SZR->ZR_QUANT)
			SZR->ZR_XCTKGAN := (SZR->ZR_CUSTO1 + SZR->ZR_FRETCIF + SZR->ZR_CUSTFIN) / SZR->ZR_QUANT

			SZR->ZR_VENDPED	:= Posicione("SA3",1,xFilial("SA3")+QRY->F2_VEND1,"A3_NREDUZ") //Vendedor da NF-e

			SZR->ZR_TIPOFRE := QRY->TPFRETE
			SZR->ZR_SGMTACA := QRY->SEGMENTO
			SZR->ZR_LINHA := QRY->LINHA
			
			/* Fim - Denis Varella 17/05/22 */

			SZR->(MsUnlock())
			QRY->( dbSkip() )
		Enddo		
	EndIf

	If Select("QRY") > 0
		QRY->( dbCloseArea() )
	EndIf 

	cQuery2	:="SELECT ROUND(((D2_CUSTO1/D2_QUANT)*ZR_QUANT),5)AS ZR_CUSTO1, ZR.R_E_C_N_O_ AS RECSZR, * FROM " + RetSqlName("SZR") + " ZR  " + CR
	cQuery2	+="LEFT JOIN " + RetSqlName("SD2") + " D2 ON  " + CR
	cQuery2	+="RTRIM(D2_COD)+D2_DOC+D2_ITEM = RTRIM(ZR_CODPROD)+ZR_XNFVEN+ZR_XNFVITE AND " + CR
	cQuery2	+="D2.D_E_L_E_T_ <> '*' " + CR
	cQuery2	+="where " + CR
	cQuery2	+="ZR_CF IN" +FormatIn(_cCfvtrg,";") + CR

	// TRATAR PARAMETRO DE EXCESSOES


	If Select("QRY2") > 0
		QRY2->( dbCloseArea() )
	EndIf

	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), "QRY2", .F., .F. ) /// Abre a conexao

	// ACHEI AS NOTAS DE FATURAMENTO DE TRIANGULAวรO CFOP '5122' E '6122'

	_aProd:={} // ARRAY QUE RECEBERม AS NOTAS SEM AMARRAวรO

	If Select("QRY2") > 0
		dbSelectArea("SZR")
		dbSetOrder(1)      
		QRY2->( dbGoTop() )
		While QRY2->( !Eof() )
			// VERIFICAR SE EXISTE AMARRAวรO COM NF DE REMESSA

			IF EMPTY(QRY2->ZR_XNFVEN) 

				Aadd(_aProd, {QRY2->ZR_DOC,QRY2->ZR_CODPROD,QRY2->ZR_DESCINT,QRY2->ZR_EMISSAO })

			ELSE 	
				SZR->(DbGoTo(QRY2->RECSZR))	

				/* Novos campos BI - Denis Varella 17/05/22 */
				nTotalFat := SZR->ZR_TOTAL + SZR->ZR_VALIPI
				nImpostos := (SZR->ZR_VALICM + SZR->ZR_VALIMP5 + SZR->ZR_VALIMP6 + SZR->ZR_DIFAL + SZR->ZR_ICMSCOM)
				nNetSales := nTotalFat - nImpostos
				/* FIM */

				RecLock("SZR",.F.) 
				SZR->ZR_CUSTO1:= QRY2->ZR_CUSTO1
				SZR->ZR_MRGBRUT := nNetSales - (SZR->ZR_CUSTO1 + SZR->ZR_FRETCIF + SZR->ZR_CUSTFIN)
				SZR->ZR_PORCMRG := SZR->ZR_MRGBRUT * 100 / nNetSales
				SZR->ZR_XCTKGAN := (SZR->ZR_CUSTO1 + SZR->ZR_FRETCIF + SZR->ZR_CUSTFIN) / SZR->ZR_QUANT
				msunlock()

			ENDIF
			QRY2->( dbSkip() )
		Enddo		

		dData:= DTOC(STOD(_dtInicio))

		_cMsg += '<br>'       

		_cMsg += 'Data inicial de Gera็ใo. --> ' +dData

		_cMsg += '<br>'       

		For _nC := 1 To Len(_aProd)

			_cMsg += 'Nota Fiscal No. --> ' +   _aProd[_nC][1]   + ' Cod Produto ' +  _aProd[_nC][2]   + ' Descri็ใo ' +   _aProd[_nC][3]  + ' Emissใo:  ' +  _aProd[_nC][4]
			_cMsg += '<br>'                    

		Next _nC
		
		If lEnvMail
			U_ENVMAIL(_cRemet, _cDest, _cAssunto, _cMsg, _aAnexos, _cPasta)
		EndIf	


	EndIf      

Return


Static Function GetB9Custo(cCod,cDoc,cOper)
    Local nCusto := 0
	Local dUlMes := SuperGetMV("MV_ULMES",,CtoD("30/09/2021"))
    Default cCod := ""
    Default cDoc := ""
	

    If cOper == 'D'
        DbSelectArea("SD1")
        SD1->(DbSetOrder(2))
        If SD1->(DbSeek(xFilial("SD2")+cCod+cDoc))

            DbSelectArea("SB9")
            SB9->(DbSetOrder(1))
            If SB9->(DbSeek(xFilial("SB9")+cCod+SD1->D1_LOCAL+DtoS(dUlMes)))
                nCusto := SB9->B9_CM1
            EndIf

        EndIf
    Else
        DbSelectArea("SD2")
        SD2->(DbSetOrder(21))
        If SD2->(DbSeek(xFilial("SD2")+cDoc+cCod))

            DbSelectArea("SB9")
            SB9->(DbSetOrder(1))
            If SB9->(DbSeek(xFilial("SB9")+cCod+SD2->D2_LOCAL+DtoS(dUlMes)))
                nCusto := SB9->B9_CM1
            EndIf

        EndIf
    EndIf



Return nCusto

