#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

//Constantes
#Define STR_PULA    Chr(13)+Chr(10)
 
User Function VQRDNIT()
PERGUNTE("VQDNIT", .T.)
MSAGUARDE({|| DBGRDNIT()}, "GERANDO RELATÓRIO DNIT " + CVALTOCHAR(MV_PAR01))
Return

Static Function DBGRDNIT()
    Local aArea        := GetArea()
    Local cQryCol      := ""
    Local cQryPro      := ""
    Local cQryVen      := ""
    Local nAux         := 0
    Local oFWMsExcel
    Local oExcel
    Local cArquivo     := 'c:\temp\DNIT_'+CVALTOCHAR(MV_PAR01)+'.xml'
    Local cWorkSheet   := "DNIT - "  + CVALTOCHAR(MV_PAR01)
    Local cTable       := "RELATÓRIO DNIT - " + CVALTOCHAR(MV_PAR01) 
    Local aColunas     := {}
    Local aLinhaAux    := {}
     
    aAdd(aColunas, "ANO")
    aAdd(aColunas, "COD.CLIENTE")
    aAdd(aColunas, "LOJ.CLIENTE")
    aAdd(aColunas, "CLIENTE")
    aAdd(aColunas, "ENDERECO")
    aAdd(aColunas, "BAIRRO")
    aAdd(aColunas, "CEP")
    aAdd(aColunas, "MUNICIPIO")
    aAdd(aColunas, "ESTADO")
    aAdd(aColunas, "UN.MEDIDA1")
    aAdd(aColunas, "UM.QUANTIDADE1")
    aAdd(aColunas, "UN.MEDIDA2")
    aAdd(aColunas, "UM.QUANTIDADE2")
    aAdd(aColunas, "ONU")
    aAdd(aColunas, "RISCO")
    aAdd(aColunas, "GRUPO_EMBALAGEM")
   
   
cQryPro := "  SELECT " 
cQryPro += " 	ANO "
cQryPro += " 	,CLIENTE_SD2 "
cQryPro += "   ,CLIENTE_LOJA "
cQryPro += "   ,NOME_CLIENTE "
cQryPro += "   ,ENDERECO_CLIENTE "
cQryPro += "   ,BAIRRO_CLIENTE "
cQryPro += "   ,CEP_CLIENTE "
cQryPro += "   ,MUNICIPIO_CLIENTE "
cQryPro += "   ,ESTADO_CLIENTE "
cQryPro += "   ,UNIDADE_MEDIDA_1 "
//cQryPro += "   ,to_CHAR(SUM(QUANTIDADE_UNIDADE_MEDIDA_1),'FM999G999G999D90', 'nls_numeric_characters='',.''') AS QTD_UM1 "
cQryPro += "   ,CAST(SUM(QUANTIDADE_UNIDADE_MEDIDA_1) AS VARCHAR(18) ) AS QTD_UM1 "
cQryPro += "   ,UNIDADE_MEDIDA_2 "
//cQryPro += "   ,to_CHAR(SUM(QUANTIDADE_UNIDADE_MEDIDA_2),'FM999G999G999D90', 'nls_numeric_characters='',.''') AS QTD_UM2 "
cQryPro += "   ,CAST(SUM(QUANTIDADE_UNIDADE_MEDIDA_2) AS VARCHAR(18) ) AS QTD_UM2 "
cQryPro += "   ,ONU "
cQryPro += "   ,RISCO " 
cQryPro += "   ,GRUPO_EMBALAGEM "
cQryPro += " FROM ( "
cQryPro += "  SELECT  "
cQryPro += "  	SUBSTRING(SF2010.F2_EMISSAO,1,4) AS ANO, "
cQryPro += "     F2_EST            AS ESTADO, "
cQryPro += "     D2_CLIENTE        AS CLIENTE_SD2, "
cQryPro += "     D2_LOJA		      AS CLIENTE_LOJA, "
cQryPro += "     A1_NOME           AS NOME_CLIENTE, "
cQryPro += "     A1_END			  AS ENDERECO_CLIENTE, "
cQryPro += "     A1_BAIRRO         AS BAIRRO_CLIENTE, "
cQryPro += "     A1_CEP            AS CEP_CLIENTE, "
cQryPro += "     A1_EST            AS ESTADO_CLIENTE, "
cQryPro += "     A1_MUN            AS MUNICIPIO_CLIENTE, "
cQryPro += "     D2_UM             AS UNIDADE_MEDIDA_1, "
cQryPro += "     SUM(D2_QUANT)     AS QUANTIDADE_UNIDADE_MEDIDA_1, "
cQryPro += "     D2_SEGUM          AS UNIDADE_MEDIDA_2, "
cQryPro += "     SUM(D2_QTSEGUM)   AS QUANTIDADE_UNIDADE_MEDIDA_2, "
cQryPro += "     DY3_ONU         AS ONU, "
cQryPro += "     DY3_NRISCO      AS RISCO, " 
cQryPro += "     DY3_GRPEMB    AS GRUPO_EMBALAGEM "
cQryPro += "     FROM SF2010 "
cQryPro += "     INNER JOIN SA4010 	ON (SA4010.D_E_L_E_T_ <> '*' AND F2_TRANSP = A4_COD) "
cQryPro += "     INNER JOIN SD2010 	ON (SD2010.D_E_L_E_T_ <> '*' AND D2_FILIAL = '01' AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE) "
cQryPro += "     INNER JOIN SA1010 	ON (SA1010.D_E_L_E_T_ <> '*' AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA) "
cQryPro += "     INNER JOIN SB1010 	ON (SB1010.D_E_L_E_T_ <> '*' AND B1_COD = D2_COD) "
cQryPro += "     INNER JOIN SB5010 	ON (SB5010.D_E_L_E_T_ <> '*' AND B1_COD = B5_COD) "
cQryPro += "     LEFT JOIN DY3010 	ON (DY3010.D_E_L_E_T_ <> '*' AND B5_ONU = DY3_ONU AND B5_ITEM = DY3_ITEM) "
cQryPro += "    WHERE "
cQryPro += "    		SF2010.F2_FILIAL = '01' AND "
cQryPro += "    		SF2010.D_E_L_E_T_ <> '*' AND "
cQryPro += "    		SD2010.D2_QUANT > 1 AND "
cQryPro += "     	SUBSTRING(SF2010.F2_EMISSAO,1,4) = '"+CVALTOCHAR(MV_PAR01)+"' AND "
cQryPro += "     	SB5010.B5_ONU <> '    ' "
cQryPro += "    GROUP BY  "
cQryPro += "    SUBSTRING(SF2010.F2_EMISSAO,1,4), "
cQryPro += "     SUBSTRING(F2_EMISSAO,1,4), "
cQryPro += "     F2_EST          , "
cQryPro += "     D2_CLIENTE      , "
cQryPro += "     D2_LOJA			, "
cQryPro += "     A1_NOME         , "
cQryPro += "     A1_END			, "
cQryPro += "     A1_BAIRRO       , "
cQryPro += "     A1_CEP          , "
cQryPro += "     A1_EST          ,  "
cQryPro += "     A1_MUN          , "
cQryPro += "     D2_COD          , "
cQryPro += "     B1_DESC         , "
cQryPro += "     B1_VQ_EM        , "
cQryPro += "     D2_UM           , "
cQryPro += "     D2_SEGUM        , "
cQryPro += "     DY3_ONU    		, "
cQryPro += "     DY3_NRISCO 		, "
cQryPro += "     DY3_GRPEMB   	 "
cQryPro += " ) VENDAS GROUP BY  "
cQryPro += "   ANO "
cQryPro += "   ,ESTADO "
cQryPro += "   ,CLIENTE_SD2 "
cQryPro += "   ,CLIENTE_LOJA "
cQryPro += "   ,NOME_CLIENTE "
cQryPro += "   ,ENDERECO_CLIENTE "
cQryPro += "   ,BAIRRO_CLIENTE "
cQryPro += "   ,CEP_CLIENTE "
cQryPro += "   ,ESTADO_CLIENTE "
cQryPro += "   ,MUNICIPIO_CLIENTE "
cQryPro += "   ,UNIDADE_MEDIDA_1 "
cQryPro += "   ,UNIDADE_MEDIDA_2 "
cQryPro += "   ,ONU "
cQryPro += "   ,RISCO " 
cQryPro += "   ,GRUPO_EMBALAGEM "
cQryPro += "   ORDER BY CLIENTE_LOJA"

MemoWrite("C:\TEMP\VQRDNIT.txt",cQryPro)

TCQuery cQryPro New Alias "QRY_PRO"


    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
    oFWMsExcel:AddworkSheet(cWorkSheet) //Não utilizar número junto com sinal de menos. Ex.: 1-
         
        //Criando a Tabela
        oFWMsExcel:AddTable(cWorkSheet, cTable)
         
        //Criando Colunas
        For nAux := 1 To Len(aColunas)
            oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
        Next
        

        While !QRY_PRO->(EoF())
        	MsProcTxt("Lendo: " + QRY_PRO->NOME_CLIENTE )
            aLinhaAux := Array(Len(aColunas))
            aLinhaAux[1] := QRY_PRO->ANO
            aLinhaAux[2] := QRY_PRO->CLIENTE_SD2
            aLinhaAux[3] := QRY_PRO->CLIENTE_LOJA
            aLinhaAux[4] := QRY_PRO->NOME_CLIENTE
            aLinhaAux[5] := QRY_PRO->ENDERECO_CLIENTE
            aLinhaAux[6] := QRY_PRO->BAIRRO_CLIENTE
            aLinhaAux[7] := QRY_PRO->CEP_CLIENTE
            aLinhaAux[8] := QRY_PRO->MUNICIPIO_CLIENTE
            aLinhaAux[9] := QRY_PRO->ESTADO_CLIENTE
            aLinhaAux[10] := QRY_PRO->UNIDADE_MEDIDA_1
            aLinhaAux[11] := QRY_PRO->QTD_UM1
            aLinhaAux[12] := QRY_PRO->UNIDADE_MEDIDA_2
            aLinhaAux[13] := QRY_PRO->QTD_UM2
            aLinhaAux[14] := QRY_PRO->ONU
            aLinhaAux[15] := QRY_PRO->RISCO
            aLinhaAux[16] := QRY_PRO->GRUPO_EMBALAGEM
            
            //Adiciona a linha no Excel
            oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)
            QRY_PRO->(DbSkip())
        EndDo
                  
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
     
    QRY_PRO->(DbCloseArea())
    RestArea(aArea)
Return

static function ajustaSx1(cPerg)
	putSx1(cPerg, "01", "ANO BASE (YYYY)"	  		, "", "", "mv_ch1", "N",4,0,0,"G","", "", "", "", "mv_par01")
return    
