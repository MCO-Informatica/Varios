#Include "Protheus.ch"
#Include "RwMake.ch"

#Define Enter Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFINM01  บAutor  ณ Montes             บ Data ณ  05/28/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Concilia็ใo Protheus x GESTOQ                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Thermoglass                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFINM01()   

Local	oSay	
Local 	aParamBox := {}

Private cCodVend  := ""
Private	aRet 	  := {} 
Private aDados	  := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria os Parametros do Relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta o Parambox, mostrando para o usuario as perguntas do ณ
//ณrelatorio.                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !ParamBox(aParamBox,"Relatorio de Concilia็ใo Protheus x GESTOQ (RFINM01)...",@aRet)
   Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta Layout do Relatorio em Excel e adiciona os dados ณ
//ณno Relatorio.                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FWMsgRun(, {|oSay| GeraRel(oSay)})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออป
บPrograma  ณ GeraRel  บAutor  ณ Montes             บ Data ณ  05/28/19   บ
ฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออน
บDesc.     ณ Monta o Layout e adciona os dados do banco ao relatorio    บ
ศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraRel(oSay)

Local lImpCabec := .T. 	//controle de impressใo do cabecalho
Local nFolder	:= 1	// Controla a Quantidade de Folders do Relatorio em Excel
Local aFolder	:= {"Contas a Receber","Contas a Pagar"}
Local cDirLocal := GetTempPath()
Local cArquivo	:= cDirLocal+"\RFINM01_"+STRTRAN(DTOC(DATE()),"/","")+"_"+STRTRAN(LEFT(TIME(),5),":","_")+".XLS"
Local oFWMsExcel

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se a pasta de destino existe do relat๓rio Estoque                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !ExistDir(cDirLocal)    
	MakeDir(cDirLocal)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIncializa o objeto do Excelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Criando o objeto que irแ gerar o conte๚do do Excel
oFWMsExcel := FWMSExcel():New()
     

For nFolder := 1 To 2

    cWorkSheet := IIF(nFolder=1,"Receber","Pagar") 
    cTable     := aFolder[nFolder]

    oFWMsExcel:AddworkSheet(cWorkSheet) //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
         
    //Criando a Tabela
    oFWMsExcel:AddTable(cWorkSheet, cTable)

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณCria as Box dos campos			ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    aCabec1 := {"","Filial","Prefixo","Numero","Parcela","Cliente","Loja","Emissใo","Vencto.","Val.Protheus","Sld.Protheus","Orig.BD","Val.GESTOQ","Sld.GESTOQ","ID GESTOQ"}
         
    //Criando Colunas
    For nAux := 1 To Len(aCabec1)
        oFWMsExcel:AddColumn(cWorkSheet, cTable, aCabec1[nAux], 1, 1)
    Next
                                             
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEnvia mensagem ao usuแrio de processamento.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    oSay:cCaption := "Buscando dados do Contas a "+IIF(nFolder=1,"Receber","Pagar")+"....."
    ProcessMessages()  
    
    BuscaDados(oSay,nFolder)

    For i := 1 to Len(aDados)

	    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	    //ณEnvia mensagem ao usuแrio de processamento.ณ
	    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    oSay:cCaption := "Gerando o Relat๓rio em Excel....."
	    ProcessMessages()  

        aLinha1 := {,	aDados[i,1],;
	                aDados[i,2],;
					aDados[i,3],;
					aDados[i,4],;
					aDados[i,5],; 
		 			aDados[i,6],;
					aDados[i,7],;
					aDados[i,8],;
					aDados[i,9],;
					aDados[i,10],;
					aDados[i,11],;
					aDados[i,12],;
					aDados[i,13],;
					aDados[i,14];
			   }
       
        //Adiciona a linha no Excel
        oFWMsExcel:AddRow(cWorkSheet, cTable, aLinha1)

    Next i

Next nFolder


//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)         
         
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre o arquivo Excel automaticamente.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
If ! ApOleClient( 'MsExcel' )
	MsgStop( 'MsExcel nao instalado' ) 
    Return Nil
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cArquivo ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออป
บPrograma  ณBuscaDadosบAutor  ณ Montes             บ Data ณ  05/16/19   บ
ฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออน
บDesc.     ณBusca os dados necessarios no banco para montar o relatorio บ
ศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BuscaDados(oSay,nFolder)

Local cQuery	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEnvia mensagem ao usuแrio de processamento.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oSay:cCaption := "Buscando dados do Relat๓rio de "+IIF(nFolder,"Contas a Receber","Contas a Pagar")
ProcessMessages()

If nFolder = 1 //Contas a Receber

   cQuery	:= "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA,E1_EMISSAO,E1_VENCTO,SUM(E1_VALOR) E1_VALOR,SUM(E1_SALDO) E1_SALDO,E1_ORIGBD,SUM(VALOR_GSTQ) VALOR_GSTQ,SUM(SALDO_GSTQ) SALDO_GSTQ, MAX(ID_TITULO) ID_TITULO FROM "+Enter
   cQuery	+= "( "+Enter
   cQuery	+= " "+Enter
   cQuery	+= "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA,E1_EMISSAO,E1_VENCTO,E1_VALOR,E1_SALDO,E1_ORIGBD,0 VALOR_GSTQ,0 SALDO_GSTQ, 0 ID_TITULO "+Enter
   cQuery	+= "FROM SE1010 SE1 "+Enter
   cQuery	+= "WHERE E1_SALDO <> 0 AND D_E_L_E_T_ = ' ' "+Enter
   cQuery	+= " "+Enter
   cQuery	+= "UNION ALL "+Enter
   cQuery	+= " "+Enter
   cQuery	+= "SELECT EMPRESA.XFILIAL COLLATE DATABASE_DEFAULT E1_FILIAL, "+Enter
   cQuery	+= "  CAST(CASE NOTA.SERIE WHEN '' THEN CASE NOTA.ID_EMPRESA WHEN 12 THEN '3' ELSE '' END ELSE NOTA.SERIE END AS CHAR(3)) COLLATE DATABASE_DEFAULT E1_SERIE, "+Enter
   cQuery	+= "  RIGHT('000000000'+RTRIM(LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -2)),9) COLLATE DATABASE_DEFAULT E1_NUM, "+Enter
   cQuery	+= "  CAST(RIGHT(VENCTIT.DOC, 3 ) AS CHAR(1)) COLLATE DATABASE_DEFAULT E1_PARCELA, "+Enter
   cQuery	+= "  A1_COD E1_CLIENTE, "+Enter
   cQuery	+= "  A1_LOJA E1_LOJA, "+Enter
   cQuery	+= "  CONVERT(CHAR(8),VENCTIT.EMISSAO,112) E2_EMISSAO, "+Enter
   cQuery	+= "  CONVERT(CHAR(8),VENCTIT.VENCIMENTO,112) E2_VENCTO, "+Enter
   cQuery	+= "  0 E1_VALOR, "+Enter
   cQuery	+= "  0 E1_SALDO, "+Enter
   cQuery	+= "  'G' E1_ORIGDB, "+Enter
   cQuery	+= "  VENCTIT.VALOR VALOR_GSTQ, "+Enter
   cQuery	+= "  VENCTIT.SALDO SALDO_GSTQ, "+Enter
   cQuery	+= "  TITULO.ID_TITULO "+Enter
   cQuery	+= "  FROM [TPCP].[dbo].[VENCTITULO] VENCTIT "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TPCP].[dbo].[TITULO] ON TITULO.ID_TITULO = VENCTIT.ID_TITULO "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TPCP].[dbo].[NOTA] NOTA ON (NOTA.ID_TITULO = TITULO.ID_TITULO) AND (NOTA.ID_EMPRESA = TITULO.ID_EMPRESA) "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TOTVSIPFSC].[dbo].[SA1010] SA1 ON ( CAST( SA1.A1_COD AS INT)  = TITULO.ID_CLIENTE) "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TPCP].[dbo].[EMPRESA] ON EMPRESA.ID_EMPRESA = TITULO.ID_EMPRESA "+Enter
   cQuery	+= "  WHERE VENCTIT.SALDO <> 0 "+Enter
   cQuery	+= "  AND TITULO.TIPOTITULO = 1  "+Enter //1=CONTAS A RECEBER
   cQuery	+= "  AND VENCTIT.PAGO <> 'C' "+Enter
   cQuery	+= "  AND NOT ( VENCTIT.SALDO < 0 AND ABS(VENCTIT.SALDO) = VENCTIT.DESCONTO ) "+Enter
   cQuery	+= " "+Enter
   cQuery	+= "UNION ALL "+Enter
   cQuery	+= " "+Enter
   cQuery	+= "SELECT CONVERT(CHAR(8),VENCTIT.EMISSAO,112),EMPRESA.XFILIAL COLLATE DATABASE_DEFAULT  E1_FILIAL, "+Enter
   cQuery	+= "  CASE ISNULL(NOTA.SERIE, ' ') WHEN ' ' THEN CASE SUBSTRING( VENCTIT.DOC,1,2) WHEN '10' THEN '1  ' ELSE CAST(ISNULL(PRENOT.SERIE,'3') AS CHAR(3)) END ELSE CAST(NOTA.SERIE AS CHAR(3)) END COLLATE DATABASE_DEFAULT E1_SERIE, "+Enter
   cQuery	+= "  RIGHT('000000000'+RTRIM(CAST(CASE WHEN SUBSTRING( VENCTIT.DOC,1,2) = '10' OR SUBSTRING( VENCTIT.DOC,1,2) = '20' "+Enter
   cQuery	+= "  THEN SUBSTRING( LTRIM(REPLACE(VENCTIT.DOC,'/','')), 3, LEN(LTRIM(REPLACE(VENCTIT.DOC,'/',''))) + -4) "+Enter
   cQuery	+= "  ELSE LEFT( LTRIM(REPLACE(VENCTIT.DOC,'/','')), LEN(LTRIM(REPLACE(VENCTIT.DOC,'/',''))) + -2) "+Enter
   cQuery	+= "  END AS VARCHAR(15) )),9) COLLATE DATABASE_DEFAULT E1_NUM, "+Enter
   cQuery	+= "  CAST(RIGHT(VENCTIT.DOC, 3 ) AS CHAR(1)) COLLATE DATABASE_DEFAULT E1_PARCELA, "+Enter
   cQuery	+= "  A1_COD E1_CLIENTE, "+Enter
   cQuery	+= "  A1_LOJA E1_LOJA, "+Enter
   cQuery	+= "  CONVERT(CHAR(8),VENCTIT.EMISSAO,112) E1_EMISSAO, "+Enter
   cQuery	+= "  CONVERT(CHAR(8),VENCTIT.VENCIMENTO,112) E1_VENCTO, "+Enter
   cQuery	+= "  0 E1_VALOR, "+Enter
   cQuery	+= "  0 E1_SALDO, "+Enter
   cQuery	+= "  'B' E1_ORIGDB, "+Enter
   cQuery	+= "  VENCTIT.VALOR VALOR_GSTQ, "+Enter
   cQuery	+= "  VENCTIT.SALDO SALDO_GSTQ, "+Enter
   cQuery	+= "  TITULO.ID_TITULO "+Enter
   cQuery	+= "  FROM [192.168.0.7].[BV].[dbo].[VENCTITULO] VENCTIT "+Enter
   cQuery	+= "   LEFT OUTER JOIN [192.168.0.7].[BV].[dbo].[TITULO] ON TITULO.ID_TITULO = VENCTIT.ID_TITULO "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TPCP].[dbo].[NOTA] NOTA ON (NOTA.ID_TITULO = TITULO.ID_TITULO) AND (NOTA.ID_EMPRESA = TITULO.ID_EMPRESA) "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TPCP].[dbo].[PRE_NOTA] PRENOT ON (PRENOT.NRO_NF = LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -2)) AND (CONVERT(CHAR(8),PRENOT.EMISSAO,112) = CONVERT(CHAR(8),VENCTIT.EMISSAO,112)) "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TOTVSIPFSC].[dbo].[SA1010] SA1 ON ( CAST( SA1.A1_COD AS INT)  = TITULO.ID_CLIENTE) "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TPCP].[dbo].[EMPRESA] ON EMPRESA.ID_EMPRESA = TITULO.ID_EMPRESA "+Enter
   cQuery	+= "  WHERE VENCTIT.SALDO <> 0 "+Enter
   cQuery	+= "  AND TITULO.TIPOTITULO = 1  "+Enter //1=CONTAS A RECEBER
   cQuery	+= "  AND VENCTIT.PAGO <> 'C' "+Enter
   cQuery	+= "  AND NOT ( VENCTIT.SALDO < 0 AND ABS(VENCTIT.SALDO) = VENCTIT.DESCONTO ) "+Enter
   cQuery	+= "  AND CONVERT(CHAR(8),VENCTIT.EMISSAO,112) > '20161231' "+Enter
   cQuery	+= " "+Enter
   cQuery	+= ") TMP "+Enter
   cQuery	+= "GROUP BY E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA,E1_EMISSAO,E1_VENCTO,E1_ORIGBD "+Enter
   cQuery	+= "HAVING ( SUM(E1_VALOR) <> SUM(VALOR_GSTQ) OR SUM(E1_SALDO) <> SUM(SALDO_GSTQ) OR SUM(E1_VALOR) IS NULL OR SUM(VALOR_GSTQ) IS NULL ) "+Enter
   cQuery	+= "AND E1_PREFIXO <> 'PRE' "+Enter
   cQuery	+= "ORDER BY E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA "+Enter

Else

   cQuery	:= "SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_LOJA,E2_EMISSAO,E2_VENCTO,SUM(E2_VALOR) E2_VALOR,SUM(E2_SALDO) E2_SALDO,E2_ORIGBD,SUM(VALOR_GSTQ) VALOR_GSTQ,SUM(SALDO_GSTQ) SALDO_GSTQ, MAX(ID_TITULO) ID_TITULO FROM "+Enter
   cQuery	+= "( "+Enter
   cQuery	+= " "+Enter
   cQuery	+= "SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_LOJA,E2_EMISSAO,E2_VENCTO,E2_VALOR,E2_SALDO,(CASE WHEN E2_ORIGBD = ' ' THEN 'G' ELSE E2_ORIGBD END) E2_ORIGBD,0 VALOR_GSTQ,0 SALDO_GSTQ, 0 ID_TITULO "+Enter
   cQuery	+= "FROM SE2010 SE2 "+Enter
   cQuery	+= "WHERE E2_SALDO <> 0 AND D_E_L_E_T_ = ' ' "+Enter
   cQuery	+= " "+Enter
   cQuery	+= "UNION ALL "+Enter 
   cQuery	+= " "+Enter
   cQuery	+= "SELECT EMPRESA.XFILIAL COLLATE DATABASE_DEFAULT E2_FILIAL, "+Enter
   cQuery	+= "  ISNULL(CAST(NOTA.SERIE AS CHAR(3)), ' ') COLLATE DATABASE_DEFAULT E2_PREFIXO, "+Enter
   cQuery	+= "  RIGHT('000000000'+RTRIM(CAST( CASE "+Enter
   cQuery	+= "  WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -4) "+Enter
   cQuery	+= "  WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -4) "+Enter
   cQuery	+= "  WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -3) "+Enter 
   cQuery	+= "  WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -3) "+Enter 
   cQuery	+= "  WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -4) "+Enter 
   cQuery	+= "  WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN LEFT(REPLACE(VENCTIT.DOC,'/',''),LEN(REPLACE(VENCTIT.DOC,'/','')) + -2) ELSE VENCTIT.DOC "+Enter
   cQuery	+= "  END AS VARCHAR(10))),9) COLLATE DATABASE_DEFAULT E2_NUM, "+Enter
   cQuery	+= " "+Enter
   cQuery	+= "  CASE "+Enter 
   cQuery	+= "   WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'IRRF' ) <> 0 THEN ' ' "+Enter
   cQuery	+= "   WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 4 ), 'INSS' ) <> 0 THEN ' ' "+Enter
   cQuery	+= "   WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'ISS' )  <> 0 THEN ' ' "+Enter
   cQuery	+= "   WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'PCC' )  <> 0 THEN ' ' "+Enter
   cQuery	+= "   WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 3 ), 'GNRE' ) <> 0 THEN ' ' "+Enter
   cQuery	+= "   WHEN CHARINDEX(RIGHT(VENCTIT.DOC, 1 ), 'ABCDEFGHIJKLMNOPQRSTUWYXZ' ) <> 0 THEN "+Enter
   cQuery	+= "   CASE "+Enter
   cQuery	+= "   WHEN RIGHT(VENCTIT.DOC, 1) = 'A' THEN RIGHT(VENCTIT.DOC, 1) "+Enter
   cQuery	+= "   ELSE "+Enter
   cQuery	+= "   CASE ISNUMERIC( SUBSTRING(RIGHT(VENCTIT.DOC, 2),1,1) ) WHEN 0 "+Enter
   cQuery	+= "   THEN "+Enter 
   cQuery	+= "   CASE "+Enter
   cQuery	+= "   WHEN ISNULL(NOTA.ID_NOTA_COMPRA,0) <> 0 THEN RIGHT(VENCTIT.DOC, 1) "+Enter
   cQuery	+= "   WHEN CONVERT(CHAR(8),VENCTIT.CADASTRO,112) > '20160604' AND VENCTIT.ID_TITULO NOT IN (109070,109062,108822) THEN RIGHT(VENCTIT.DOC, 1) "+Enter
   cQuery	+= "   ELSE SUBSTRING(RIGHT(VENCTIT.DOC, 2),1,1) "+Enter
   cQuery	+= "   END "+Enter
   cQuery	+= "   ELSE RIGHT(VENCTIT.DOC, 1) "+Enter
   cQuery	+= "   END "+Enter
   cQuery	+= "   END "+Enter
   cQuery	+= " ELSE ' ' "+Enter
   cQuery	+= " END COLLATE DATABASE_DEFAULT E2_PARCELA, "+Enter
   cQuery	+= "  A2_COD E2_FORNECE, "+Enter
   cQuery	+= "  A2_LOJA E2_LOJA, "+Enter
   cQuery	+= "  CONVERT(CHAR(8),VENCTIT.EMISSAO,112) E2_EMISSAO, "+Enter
   cQuery	+= "  CONVERT(CHAR(8),VENCTIT.VENCIMENTO,112) E2_VENCTO, "+Enter
   cQuery	+= "  0 E2_VALOR, "+Enter                                              
   cQuery	+= "  0 E2_SALDO, "+Enter
   cQuery	+= "  'G' E2_ORIGDB, "+Enter
   cQuery	+= "  VENCTIT.VALOR VALOR_GSTQ, "+Enter
   cQuery	+= "  VENCTIT.SALDO SALDO_GSTQ, "+Enter
   cQuery	+= "  TITULO.ID_TITULO  "+Enter 
   cQuery	+= "  FROM [TPCP].[dbo].[VENCTITULO] VENCTIT "+Enter 
   cQuery	+= "   LEFT OUTER JOIN [TPCP].[dbo].[TITULO] ON TITULO.ID_TITULO = VENCTIT.ID_TITULO "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TPCP].[dbo].[NOTA_COMPRA] NOTA ON (NOTA.ID_TITULO = TITULO.ID_TITULO) AND (NOTA.ID_EMPRESA = TITULO.ID_EMPRESA) "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TOTVSIPFSC].[dbo].[SA2010] SA2 ON NOT A2_COD IN ('"+'"'+"00687','MUNIC ','UNIAO ','INPS  ') AND ( CAST( SA2.A2_COD AS INT)  = TITULO.ID_CLIENTE) AND NOT (A2_COD = '014108' AND A2_LOJA = '01') "+Enter
   cQuery	+= "   LEFT OUTER JOIN [TPCP].[dbo].[EMPRESA] ON EMPRESA.ID_EMPRESA = TITULO.ID_EMPRESA "+Enter
   cQuery	+= "  WHERE VENCTIT.SALDO <> 0 "+Enter
   cQuery	+= "  AND TITULO.TIPOTITULO = 0 "+Enter //0=CONTAS A PAGAR
   cQuery	+= "  AND VENCTIT.PAGO <> 'C' "+Enter
   cQuery	+= "  AND NOT ( VENCTIT.SALDO < 0 AND ABS(VENCTIT.SALDO) = VENCTIT.DESCONTO ) "+Enter
   cQuery	+= "  "+Enter
   cQuery	+= ") TMP "+Enter
   cQuery	+= "GROUP BY E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_LOJA,E2_EMISSAO,E2_VENCTO,E2_ORIGBD "+Enter
   cQuery	+= "HAVING ( SUM(E2_VALOR) <> SUM(VALOR_GSTQ) OR SUM(E2_SALDO) <> SUM(SALDO_GSTQ) OR SUM(E2_VALOR) IS NULL OR SUM(VALOR_GSTQ) IS NULL ) "+Enter
   cQuery	+= "ORDER BY E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA "+Enter

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se a area de trabalho QUERY esta sendo usada.ณ
//ณSe tiver, fecha.                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("QUERY") > 0
	dbSelectArea("QUERY")
	QUERY->(dbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a Query criada acima.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QUERY", .T., .T.)   

dbSelectArea("QUERY")
QUERY->(dbGoTop())

While !QUERY->(Eof())

     If nFolder = 1 //Contas a Receber
	
	aLinha1 := { QUERY->E1_FILIAL,;
				 QUERY->E1_PREFIXO,;
				 QUERY->E1_NUM,;
				 QUERY->E1_PARCELA,;
				 QUERY->E1_FORNECE,; 
				 QUERY->E1_LOJA,; 
				 STOD(QUERY->E1_EMISSAO),; 
				 STOD(QUERY->E1_VENCTO),; 
				 QUERY->E1_VALOR,;
				 QUERY->E1_SALDO,;
				 QUERY->E1_ORIGBD,;
				 QUERY->VALOR_GSTQ,;               
				 QUERY->SALDO_GSTQ,;               
				 QUERY->ID_TITULO }               
     Else

	aLinha1 := { QUERY->E2_FILIAL,;
				 QUERY->E2_PREFIXO,;
				 QUERY->E2_NUM,;
				 QUERY->E2_PARCELA,;
				 QUERY->E2_FORNECE,; 
				 QUERY->E2_LOJA,; 
				 STOD(QUERY->E2_EMISSAO),; 
				 STOD(QUERY->E2_VENCTO),; 
				 QUERY->E2_VALOR,;
				 QUERY->E2_SALDO,;
				 QUERY->E2_ORIGBD,;
				 QUERY->VALOR_GSTQ,;               
				 QUERY->SALDO_GSTQ,;               
				 QUERY->ID_TITULO }               

     EndIf
					
     aAdd( aDados, ACLONE(aLinha1) )
    
     QUERY->(dbSkip())
EndDo

dbSelectArea("QUERY")
QUERY->(dbCloseArea())

Return Nil