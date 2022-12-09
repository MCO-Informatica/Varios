#Include "Protheus.ch"
#Include "RwMake.ch"

#Define Enter Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFINM01  ºAutor  ³ Montes             º Data ³  05/28/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Conciliação Protheus x GESTOQ                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Thermoglass                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFINM01()   

Local	oSay	
Local 	aParamBox := {}

Private cCodVend  := ""
Private	aRet 	  := {} 
Private aDados	  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria os Parametros do Relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa o Parambox, mostrando para o usuario as perguntas do ³
//³relatorio.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ParamBox(aParamBox,"Relatorio de Conciliação Protheus x GESTOQ (RFINM01)...",@aRet)
   Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta Layout do Relatorio em Excel e adiciona os dados ³
//³no Relatorio.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FWMsgRun(, {|oSay| GeraRel(oSay)})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³ GeraRel  ºAutor  ³ Montes             º Data ³  05/28/19   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Monta o Layout e adciona os dados do banco ao relatorio    º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraRel(oSay)

Local lImpCabec := .T. 	//controle de impressão do cabecalho
Local nFolder	:= 1	// Controla a Quantidade de Folders do Relatorio em Excel
Local aFolder	:= {"Contas a Receber","Contas a Pagar"}
Local cDirLocal := GetTempPath()
Local cArquivo	:= cDirLocal+"\RFINM01_"+STRTRAN(DTOC(DATE()),"/","")+"_"+STRTRAN(LEFT(TIME(),5),":","_")+".XLS"
Local oExcelApp

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis Private.³
//³Estilos Excel     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Private oNumPar := CellStyle():New("oNumPar")
		oNumPar:SetHAlign("Right")
		oNumPar:SetFont("Calibri", 8, "#000000", .T.)
		oNumPar:SetInterior("#D9D9F3", "Solid")
		oNumPar:SetBorder("Top")
		oNumPar:SetBorder("Right")
		oNumPar:SetBorder("Left") 
		oNumPar:SetBorder("Bottom")   
		oNumPar:SetNumberFormat("##,###,###,##0.00")             // Formato Numero  
		
Private oNumParTot := CellStyle():New("oNumParTot")
		oNumParTot:SetHAlign("Right")
		oNumParTot:SetFont("Calibri", 8, "#FF0000", .T.)    //Fonte vermelho
		oNumParTot:SetInterior("#D9D9F3", "Solid")
		oNumParTot:SetBorder("Top")
		oNumParTot:SetBorder("Right")
		oNumParTot:SetBorder("Left") 
		oNumParTot:SetBorder("Bottom")   
		oNumParTot:SetNumberFormat("##,###,###,##0.00")             // Formato Numero  
						
Private oNumImp := CellStyle():New("oNumImp")
		oNumImp:SetHAlign("Right")
		oNumImp:SetFont("Calibri", 8, "#000000", .T.)
		oNumImp:SetInterior("#ADD8E6", "Solid") //#98FB98
		oNumImp:SetBorder("Top")
		oNumImp:SetBorder("Right")
		oNumImp:SetBorder("Left") 
		oNumImp:SetBorder("Bottom")		
		oNumImp:SetNumberFormat("##,###,###,##0.00")             // Formato Numero

Private oNumImpTot := CellStyle():New("oNumImpTot")
		oNumImpTot:SetHAlign("Right")
		oNumImpTot:SetFont("Calibri", 8, "#FF0000", .T.)    //Fonte vermelho
		oNumImpTot:SetInterior("#ADD8E6", "Solid") //#98FB98
		oNumImpTot:SetBorder("Top")
		oNumImpTot:SetBorder("Right")
		oNumImpTot:SetBorder("Left") 
		oNumImpTot:SetBorder("Bottom")		
		oNumImpTot:SetNumberFormat("##,###,###,##0.00")             // Formato Numero

Private oDtPar := CellStyle():New("oDtPar")
		oDtPar:SetHAlign("Left")
		oDtPar:SetFont("Calibri", 8, "#000000", .T.)
		oDtPar:SetInterior("#D9D9F3", "Solid")
		oDtPar:SetBorder("Top")
		oDtPar:SetBorder("Right")
		oDtPar:SetBorder("Left") 
		oDtPar:SetBorder("Bottom")   
		oDtPar:SetNumberFormat("dd/mm/yyyy")             // Formato Data

Private oDtImp := CellStyle():New("oDtImp")
		oDtImp:SetHAlign("Left")
		oDtImp:SetFont("Calibri", 8, "#000000", .T.)
		oDtImp:SetInterior("#ADD8E6", "Solid")
		oDtImp:SetBorder("Top")
		oDtImp:SetBorder("Right")
		oDtImp:SetBorder("Left") 
		oDtImp:SetBorder("Bottom")   
		oDtImp:SetNumberFormat("dd/mm/yyyy")             // Formato Data 

Private oStrPar := CellStyle():New("oStrPar")
		oStrPar:SetHAlign("Left")
		oStrPar:SetFont("Calibri", 8, "#000000", .T.)
		oStrPar:SetInterior("#D9D9F3", "Solid")
		oStrPar:SetBorder("Top")
		oStrPar:SetBorder("Right")
		oStrPar:SetBorder("Left") 
		oStrPar:SetBorder("Bottom")   

Private oStrImp := CellStyle():New("oStrImp")
		oStrImp:SetHAlign("Left")
		oStrImp:SetFont("Calibri", 8, "#000000", .T.)
		oStrImp:SetInterior("#ADD8E6", "Solid")
		oStrImp:SetBorder("Top")
		oStrImp:SetBorder("Right")
		oStrImp:SetBorder("Left") 
		oStrImp:SetBorder("Bottom")   

Private oCabec := CellStyle():New("oCabec") // Azul fundo e Preto letra
		oCabec:SetHAlign("Center")
		oCabec:SetFont("Calibri", 11, "#000000", .T.)
		oCabec:SetInterior("#6495ED", "Solid")  //#000080
		oCabec:SetBorder("Top")
		oCabec:SetBorder("Right")
		oCabec:SetBorder("Left") 
		oCabec:SetBorder("Bottom") 

Private oCabec2 := CellStyle():New("oCabec2") // Laranja fundo e preto letra
		oCabec2:SetHAlign("Center")
		oCabec2:SetFont("Calibri", 09, "#000000", .T.)
		oCabec2:SetInterior("#FF8C00", "Solid")  
		oCabec2:SetBorder("Top")
		oCabec2:SetBorder("Right")
		oCabec2:SetBorder("Left") 
		oCabec2:SetBorder("Bottom")   

Private oCabec3 := CellStyle():New("oCabec3") // Laranja fundo e preto letra
		oCabec3:SetHAlign("Center")
		oCabec3:SetFont("Calibri", 09, "#000000", .T.)
		oCabec3:SetInterior("#CDBA96", "Solid")  
		oCabec3:SetBorder("Top")
		oCabec3:SetBorder("Right")
		oCabec3:SetBorder("Left") 
		oCabec3:SetBorder("Bottom")   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a pasta de destino existe do relatório Estoque                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ExistDir(cDirLocal)    
	MakeDir(cDirLocal)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Incializa o objeto do Excel³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oXML := ExcelXML():New()
oXML:SetPageSetup(3,.T.,.F.,0,0,0,0,0,0)
oXML:SetPrintSetup(9,43) //  Define a impressao / tamanho da escala

oXML:SetFolder(2/*nFolder*/) 

For nFolder := 1 To 2

    oXML:SetFolderName(aFolder[nFolder]) // nome para a folder.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³DEFINICAO DO TAMANHO DE CADA COLUNA³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aColSize := { "20.0", "30.0", "30.0", "50.0", "20.0", "30.0", "20.0", "30.0", "30.0", "90.0", "90.0", "20.0", "90.0", "90.0", "50.0" }
    oXML:SetColSize( aColSize )

    aCabec1 := {,"Filial","Prefixo","Numero","Parcela","Cliente","Loja","Emissão","Vencto.","Val.Protheus","Sld.Protheus","Orig.BD","Val.GESTOQ","Sld.GESTOQ","ID GESTOQ"}

    oXML:SkipLine("12",,1)	   

    aCabec1 := {,"Relatorio Conciliação Protheus x GESTOQ"+aFolder[nFolder],,,,,,,,,,,,,,}
    aCabec2 := {,oCabec,,,,,,,,,,,,,,}

    oXML:AddRow( "20" ,	aCabec1 ,; 
			            aCabec2)

    oXML:SetMerge( , 2 , , LEN(aCabec1)-2 )
		
    oXML:SkipLine("12",,1)  

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Cria as Box dos campos			³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aCabec1 := {,"Filial","Prefixo","Numero","Parcela","Cliente","Loja","Emissão","Vencto.","Val.Protheus","Sld.Protheus","Orig.BD","Val.GESTOQ","Sld.GESTOQ","ID GESTOQ"}
    aCabec2 := {,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3,oCabec3}

    oXML:AddRow( "20" ,	aCabec1 ,; 
			            aCabec2 ) 

    oXML:SkipLine("12",,1)  


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia mensagem ao usuário de processamento.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oSay:cCaption := "Buscando dados do Contas a "+IIF(nFolder=1,"Receber","Pagar")+"....."
    ProcessMessages()  
    
    BuscaDados(oSay,nFolder)

    For i := 1 to Len(aDados)

	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³Envia mensagem ao usuário de processamento.³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    oSay:cCaption := "Gerando o Relatório em Excel....."
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
       
        aLinha2a := {,oStrPar,oStrPar,oStrPar,oStrPar,oStrPar,oStrPar,oDtPar,oDtPar,oNumPar,oNumPar,oStrPar,oNumPar,oNumPar,oStrPar} 
        aLinha2b := {,oStrImp,oStrImp,oStrImp,oStrImp,oStrImp,oStrImp,oDtImp,oDtImp,oNumImp,oNumImp,oStrImp,oNumImp,oNumImp,oStrImp}
			
	    oXML:AddRow( "12" ,	aLinha1 , IIF(Mod(i,2) == 0,aLinha2a,aLinha2b) ) 

    Next i

Next nFolder

oXML:GetXML(cArquivo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre o arquivo Excel automaticamente.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
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
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³BuscaDadosºAutor  ³ Montes             º Data ³  05/16/19   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³Busca os dados necessarios no banco para montar o relatorio º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaDados(oSay,nFolder)

Local cQuery	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia mensagem ao usuário de processamento.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSay:cCaption := "Buscando dados do Relatório de "+IIF(nFolder,"Contas a Receber","Contas a Pagar")
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a area de trabalho QUERY esta sendo usada.³
//³Se tiver, fecha.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("QUERY") > 0
	dbSelectArea("QUERY")
	QUERY->(dbCloseArea())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a Query criada acima.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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