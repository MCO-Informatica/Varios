#Include "RwMake.ch"
#Include "Protheus.ch"                         
#Include "Topconn.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RFAT019   ∫ Autor ≥ Mauro Nagata       ∫ Data ≥  01/06/2012 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Relatorio de Despesas Orcadas e Realizadas               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Lisonda - Actual Trend                                     ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±                                                 	
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function RFIN019()                                    

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Declaracao de Variaveis                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio"
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Despesas OrÁadas vs Realizadas"
Local cPict         := ""
Local titulo        := "Despesas OrÁadas vs Realizadas"
Local nLin          := 80
Local imprime       := .T.
                        //          1         2         3         4         5         6         7         8         9        10         1         2         3         4         5         6         7         8         9        20       21        22
                        //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234578901234567890         
Local Cabec1         :=  "Obra      | DescriÁ„o                  | Valor   | Valor     |   Saldo  |"
Local Cabec2         :=  "Natureza  |                            | Orcado  | Realizado |          |"
                                                                                                      	
Private aOrd        := {}
Private lEnd        := .F.                                            
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "RFIN019" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RFIN019"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFIN019" // nome do arquivo usado para impressao em disco
Private cArqTrab                                          	
Private cString     := "AF8"		
Private cArqtmp     := ""

ValidPerg()
			
Pergunte(cPerg,.F.)
                          		
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
                                                                                                                                                                            		
//nTipo := If(aReturn[4]==1,15,18)    

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Processamento. RPTSTATUS monta janela com a regua de processamento. ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo) 

Roda(cbcont,cbtxt,tamanho)
		
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Finaliza a execucao do relatorio...                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

SET DEVICE TO SCREEN

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Se impressao em disco, chama o gerenciador de impressao...          ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

If aReturn[5]==1
	DbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)     
	If Select("TMP") > 0                                                                                                                                               		   
	   TMP->(DbCloseArea())	
	   If MsgYesNo("Deseja gerar planilha excel ?")		
		  cExcel :=  AllTrim(GetTempPath())+"Despesa_Orcado_vs_Realizado_"+StrTran(Dtoc(dDatabase),"/","")+".XLS"			
		  fErase(cExcel)
		  __CopyFile(cArqTMP+".DBF",cExcel)
		  fErase(cArqTMP+".*")
			
		  oExcelApp:= MsExcel():New()                        	
		  oExcelApp:WorkBooks:Open(cExcel)
		  oExcelApp:SetVisible(.T.) 
		  lExcel := .T.
		  //Return
		EndIf  
	EndIf      
Endif

MS_FLUSH()

Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥RUNREPORT ∫ Autor ≥ Mauro Nagata       ∫ Data ≥  24/03/11   ∫±±
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
Local cObra := ""
Local cDesc := ""                                                                                                                      
Local oProcess	                    

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ SETREGUA -> Indica quantos registros serao processados para a regua ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

cDAOBRA    = MV_PAR01   //'11P034    '  --Da Obra
cATEOBRA   = MV_PAR02   //'11P034    '  --Ate a Obra
cCONSBLOQ  = If(MV_PAR04=1,'SIM',If(MV_PAR04=2,'NAO','SOBLQ'))         //SIM, considerao as obras bloqueadas e NAO, nao considera.

cHOSPED     = '000203         '  //hospedagem
cFRETE      = '000201         '  //frete
cTRASLADO   = '000200         '  //traslado
cREFEICAO   = '000202         '  //refeicao
cNATHOSP    = '2616' 
cNATFRETE   = '2224' 
cNATKMROD   = '2620' 
cNATPEDAG   = '2612' 
cNATPASSA   = '2614' 
cNATPASST   = '2622'
cNATREFEI   = '2618' 
cNATSVEMP   = '2202'
cNATSRVPF   = '2302'
cNATSRVTE   = '2304'
cNATTRASL   = 'TRAS'
cNATMOUTIL  = 'MOU' 
cDESCFRETE  = 'FRETE'
cDESCHOSP   = 'HOSPEDAGEM'
cDESCREFEI  = 'REFEICAO'
cDESCKMROD  = 'KM RODADO'
cDESCPEDAG  = 'PEDAGIO'
cDESCPASSA  = 'PASSAGEM AEREA'
cDESCPASST  = 'PASSAGEM TERRESTRE'
cDESCTRASL  = 'TRASLADO'  //traslado eh composto pelas naturezas pedagio, km rodado, passagem aerea, passagem terrestre
cDESCMOUTI  = 'MAO DE OBRA UTILIZADA'
cDESCSVEMP  = 'SERVICO SUB EMPREITEIRO'
cDESCSRVPF  = 'SERVICO PROFIS.PES.FISICA'
cDESCSRVTE  = 'SERVICO PROFIS.TEMPORARIO'


cQuery := "SELECT OBRA, CTT_DESC01 AS DESCR, NATUREZ, " + Chr(13)+Chr(10)
cQuery += "       (CASE WHEN NATUREZ = '"+cNATSVEMP+"' AND DESCRNAT = '' " + Chr(13)+Chr(10)
cQuery += "             THEN '"+cDESCSVEMP+"' " + Chr(13)+Chr(10)
cQuery += "             ELSE  " + Chr(13)+Chr(10)
cQuery += "             (CASE WHEN NATUREZ = '"+cNATSRVPF+"'  AND DESCRNAT = '' " + Chr(13)+Chr(10)
cQuery += "                   THEN '"+cDESCSRVPF+"' " + Chr(13)+Chr(10)
cQuery += "                   ELSE " + Chr(13)+Chr(10)
cQuery += "                   (CASE WHEN NATUREZ = '"+cNATSRVTE+"'  AND DESCRNAT = '' " + Chr(13)+Chr(10)
cQuery += "                         THEN '"+cDESCSRVTE+"' " + Chr(13)+Chr(10)
cQuery += "                         ELSE  " + Chr(13)+Chr(10)
cQuery += "                         (CASE WHEN NATUREZ = '"+cNATPEDAG+"' AND DESCRNAT = '' " + Chr(13)+Chr(10)
cQuery += "                               THEN '"+cDESCPEDAG+"' " + Chr(13)+Chr(10)
cQuery += "                               ELSE DESCRNAT " + Chr(13)+Chr(10)
cQuery += "                         END)       " + Chr(13)+Chr(10)
cQuery += "                   END) " + Chr(13)+Chr(10)
cQuery += "              END)            " + Chr(13)+Chr(10)
cQuery += "        END) DESCRNAT, ROUND(SUM(VLR_ORCA),2) AS VLR_ORCA, ROUND(SUM(VLR_REAL),2) AS VLR_REAL " + Chr(13)+Chr(10)
cQuery += "FROM ( " + Chr(13)+Chr(10)
cQuery += "		SELECT OBRA, NATUREZ,  " + Chr(13)+Chr(10)
cQuery += "			   CASE WHEN NATUREZ = '"+cNATHOSP+"' " + Chr(13)+Chr(10)
cQuery += "					THEN '"+cDESCHOSP+"' " + Chr(13)+Chr(10)
cQuery += "					ELSE " + Chr(13)+Chr(10)
cQuery += "					(CASE WHEN NATUREZ = '"+cNATREFEI+"' " + Chr(13)+Chr(10)
cQuery += "						  THEN '"+cDESCREFEI+"' " + Chr(13)+Chr(10)
cQuery += "						  ELSE  " + Chr(13)+Chr(10)
cQuery += "						  (CASE WHEN NATUREZ = '"+cNATFRETE+"' " + Chr(13)+Chr(10)
cQuery += "								THEN '"+cDESCFRETE+"' " + Chr(13)+Chr(10)
cQuery += "								ELSE " + Chr(13)+Chr(10)
cQuery += "								(CASE WHEN NATUREZ = '"+cNATKMROD+"' " + Chr(13)+Chr(10)
cQuery += "									  THEN '"+cDESCKMROD+"' " + Chr(13)+Chr(10)
cQuery += "									  ELSE " + Chr(13)+Chr(10)
cQuery += "									  (CASE WHEN NATUREZ = '"+cNATPASSA+"' " + Chr(13)+Chr(10)
cQuery += "											THEN '"+cDESCPASSA+"' " + Chr(13)+Chr(10)
cQuery += "											ELSE " + Chr(13)+Chr(10)
cQuery += "											(CASE WHEN NATUREZ = '"+cNATPASST+"' " + Chr(13)+Chr(10)
cQuery += "												  THEN '"+cDESCPASST+"' " + Chr(13)+Chr(10)
cQuery += "												  ELSE  " + Chr(13)+Chr(10)
cQuery += "												  (CASE WHEN NATUREZ = '"+cNATTRASL+"' " + Chr(13)+Chr(10)
cQuery += "														THEN '"+cDESCTRASL+"' " + Chr(13)+Chr(10)
cQuery += "														ELSE  " + Chr(13)+Chr(10)
cQuery += "														(CASE WHEN NATUREZ = '"+cNATMOUTIL+"' " + Chr(13)+Chr(10)
cQuery += "															  THEN '"+cDESCMOUTI+"' " + Chr(13)+Chr(10)
cQuery += "															  ELSE '' " + Chr(13)+Chr(10)                                                      
cQuery += "														END) " + Chr(13)+Chr(10)
cQuery += "												  END) " + Chr(13)+Chr(10)
cQuery += "											END) " + Chr(13)+Chr(10)
cQuery += "									  END) " + Chr(13)+Chr(10)
cQuery += "								END) " + Chr(13)+Chr(10)
cQuery += "						  END) " + Chr(13)+Chr(10)
cQuery += "					END) " + Chr(13)+Chr(10)
cQuery += "			  END AS DESCRNAT, " + Chr(13)+Chr(10)
cQuery += "			  VLR_ORCA, VLR_REAL " + Chr(13)+Chr(10)
cQuery += "		FROM ( " + Chr(13)+Chr(10)
cQuery += "				SELECT AF8_CODOBR AS OBRA,  " + Chr(13)+Chr(10)
cQuery += "					   CASE WHEN AFA_PRODUT = '"+cFRETE+"' " + Chr(13)+Chr(10)
cQuery += "							THEN '"+cNATFRETE+"' " + Chr(13)+Chr(10)
cQuery += "							ELSE " + Chr(13)+Chr(10)
cQuery += "							    (CASE WHEN AFA_PRODUT = '"+cHOSPED+"' " + Chr(13)+Chr(10)
cQuery += "								      THEN '"+cNATHOSP+"' " + Chr(13)+Chr(10)
cQuery += "								      ELSE " + Chr(13)+Chr(10)
cQuery += "								          (CASE WHEN AFA_PRODUT = '"+cTRASLADO+"' " + Chr(13)+Chr(10)
cQuery += "										        THEN '"+cNATTRASL+"' " + Chr(13)+Chr(10)
cQuery += "									    	    ELSE  " + Chr(13)+Chr(10)
cQuery += "										            (CASE WHEN AFA_PRODUT = '' AND AFA_RECURS <> '' " + Chr(13)+Chr(10)
cQuery += "											              THEN '"+cNATMOUTIL+"' " + Chr(13)+Chr(10)
cQuery += "											              ELSE '"+cNATREFEI+"' " + Chr(13)+Chr(10)
cQuery += "											        END) " + Chr(13)+Chr(10)
cQuery += "										  END) " + Chr(13)+Chr(10)
cQuery += "								END) " + Chr(13)+Chr(10)
cQuery += "					   END AS NATUREZ, " + Chr(13)+Chr(10)
cQuery += "					   AFA_QUANT*AFA_CUSTD AS VLR_ORCA, 0 AS VLR_REAL " + Chr(13)+Chr(10)
cQuery += "				FROM AFA010 AFA " + Chr(13)+Chr(10)
cQuery += "				INNER JOIN AF8010 AF8 " + Chr(13)+Chr(10)
cQuery += "					  ON AF8_PROJET =  AFA_PROJET  " + Chr(13)+Chr(10)
cQuery += "					     AND AF8_CODOBR BETWEEN '"+cDAOBRA+"' AND '"+cATEOBRA+"' " + Chr(13)+Chr(10)
cQuery += "						 AND AF8.D_E_L_E_T_<>'*'     " + Chr(13)+Chr(10)
cQuery += "				WHERE AFA.D_E_L_E_T_<>'*' " + Chr(13)+Chr(10)
cQuery += "					  AND (AFA_PRODUT IN ('"+cHOSPED+"','"+cFRETE+"','"+cTRASLADO+"','"+cREFEICAO+"') OR (AFA_PRODUT = '' AND AFA_RECURS <> '') ) " + Chr(13)+Chr(10)
cQuery += "					  AND AFA_REVISA = '0001'							   " + Chr(13)+Chr(10)
					  
cQuery += "				UNION ALL " + Chr(13)+Chr(10)

cQuery += "				SELECT E2_XCC AS OBRA,  " + Chr(13)+Chr(10)
cQuery += "				       CASE WHEN SUBSTRING(E2_NATUREZ,1,4) IN ('"+cNATKMROD+"','"+cNATPASSA+"','"+cNATPASST+"','"+cNATPEDAG+"') " + Chr(13)+Chr(10)
cQuery += "				            THEN '"+cNATTRASL+"' " + Chr(13)+Chr(10)
cQuery += "				            ELSE  " + Chr(13)+Chr(10)
cQuery += "				            (CASE WHEN SUBSTRING(E2_NATUREZ,1,4) IN ('"+cNATSVEMP+"','"+cNATSRVPF+"','"+cNATSRVTE+"') " + Chr(13)+Chr(10)
cQuery += "				                  THEN '"+cNATMOUTIL+"' " + Chr(13)+Chr(10)
cQuery += "				                  ELSE SUBSTRING(E2_NATUREZ,1,4) " + Chr(13)+Chr(10)
cQuery += "				            END) " + Chr(13)+Chr(10)
cQuery += "				       END AS NATUREZ,  " + Chr(13)+Chr(10)
cQuery += "				       0 AS VLR_ORCA, E2_VALOR AS VLR_REAL " + Chr(13)+Chr(10)
cQuery += "				FROM (       " + Chr(13)+Chr(10)
cQuery += "						SELECT Isnull(EZ_CCUSTO, E2_XCC)                   AS E2_XCC,  " + Chr(13)+Chr(10)
cQuery += "							   Isnull(EV_NATUREZ, E2_NATUREZ)              AS E2_NATUREZ,   " + Chr(13)+Chr(10)
cQuery += "							   Isnull(EZ_VALOR,Isnull(EV_VALOR, E2_VALOR)) AS E2_VALOR, " + Chr(13)+Chr(10)
cQuery += "							   E2_NUM, E2_FILIAL, IsNull(EZ_PERC,1)        AS EZ_PERC,  " + Chr(13)+Chr(10)
cQuery += "							   IsNull(EV_PERC,1)                           AS EV_PERC  " + Chr(13)+Chr(10)
cQuery += "						FROM SE2010 SE2 " + Chr(13)+Chr(10)
cQuery += "						LEFT JOIN SEV010 SEV " + Chr(13)+Chr(10)
cQuery += "							 ON EV_FILIAL = E2_FILIAL  " + Chr(13)+Chr(10)
cQuery += "								AND EV_PREFIXO  = E2_PREFIXO " + Chr(13)+Chr(10)
cQuery += "								AND EV_NUM      = E2_NUM  " + Chr(13)+Chr(10)
cQuery += "								AND EV_PARCELA  = E2_PARCELA  " + Chr(13)+Chr(10)
cQuery += "								AND EV_TIPO     = E2_TIPO  " + Chr(13)+Chr(10)
cQuery += "								AND EV_CLIFOR   = E2_FORNECE  " + Chr(13)+Chr(10)
cQuery += "								AND EV_LOJA     = E2_LOJA  " + Chr(13)+Chr(10)
cQuery += "								AND SEV.D_E_L_E_T_ <> '*'  " + Chr(13)+Chr(10)
cQuery += "						LEFT JOIN SEZ010 SEZ " + Chr(13)+Chr(10)
cQuery += "							 ON EZ_FILIAL   = EV_FILIAL  " + Chr(13)+Chr(10)
cQuery += "								AND EZ_PREFIXO  = EV_PREFIXO  " + Chr(13)+Chr(10)
cQuery += "								AND EZ_NUM      = EV_NUM  " + Chr(13)+Chr(10)
cQuery += "								AND EZ_PARCELA  = EV_PARCELA  " + Chr(13)+Chr(10)
cQuery += "								AND EZ_TIPO     = EV_TIPO  " + Chr(13)+Chr(10)
cQuery += "								AND EZ_CLIFOR   = EV_CLIFOR  " + Chr(13)+Chr(10)
cQuery += "								AND EZ_LOJA     = EV_LOJA  " + Chr(13)+Chr(10)
cQuery += "								AND EZ_NATUREZ  = EV_NATUREZ  " + Chr(13)+Chr(10)
cQuery += "								AND SEZ.D_E_L_E_T_ <> '*'  " + Chr(13)+Chr(10)
cQuery += "						WHERE SE2.D_E_L_E_T_ <> '*'  " + Chr(13)+Chr(10)
cQuery += "							  AND E2_DTFATUR = ''       ) AS A " + Chr(13)+Chr(10)
cQuery += "				WHERE E2_XCC BETWEEN '"+cDAOBRA+"' AND '"+cATEOBRA+"' " + Chr(13)+Chr(10)
cQuery += "					  AND (E2_NATUREZ LIKE '"+cNATFRETE+"%' OR " + Chr(13)+Chr(10)
cQuery += "						   E2_NATUREZ LIKE '"+cNATHOSP +"%' OR " + Chr(13)+Chr(10)
cQuery += "						   E2_NATUREZ LIKE '"+cNATKMROD+"%' OR " + Chr(13)+Chr(10)
cQuery += "						   E2_NATUREZ LIKE '"+cNATPASSA+"%' OR " + Chr(13)+Chr(10)
cQuery += "						   E2_NATUREZ LIKE '"+cNATPEDAG+"%' OR " + Chr(13)+Chr(10)
cQuery += "						   E2_NATUREZ LIKE '"+cNATREFEI+"%' OR " + Chr(13)+Chr(10)
cQuery += "						   E2_NATUREZ LIKE '"+cNATSVEMP+"%' OR " + Chr(13)+Chr(10)
cQuery += "						   E2_NATUREZ LIKE '"+cNATSRVPF+"%' OR " + Chr(13)+Chr(10)
cQuery += "						   E2_NATUREZ LIKE '"+cNATSRVTE+"%' ) " + Chr(13)+Chr(10)
cQuery += "				UNION ALL " + Chr(13)+Chr(10)
				
cQuery += "				SELECT ZC_OBRA AS OBRA, '"+cNATMOUTIL+"' AS NATUREZ, 0 AS VLR_ORCA, AE8_CUSTOM/22 AS VLR_REAL " + Chr(13)+Chr(10)
cQuery += "				FROM SZC010 AS SZC " + Chr(13)+Chr(10)
cQuery += "				INNER JOIN AE8010 AS AE8 " + Chr(13)+Chr(10)
cQuery += "					  ON ZC_RECURSO = AE8_RECURS " + Chr(13)+Chr(10)
cQuery += "						 AND  AE8.D_E_L_E_T_ <> '*' " + Chr(13)+Chr(10)
cQuery += "				WHERE ZC_OBRA BETWEEN '"+cDAOBRA+"' AND '"+cATEOBRA+"' " + Chr(13)+Chr(10)
cQuery += "					  AND SZC.D_E_L_E_T_ <> '*' " + Chr(13)+Chr(10)
				      
cQuery += "				 ) B				 " + Chr(13)+Chr(10)
cQuery += "			     ) C			   		 " + Chr(13)+Chr(10)
cQuery += " INNER JOIN CTT010 CTT " + Chr(13)+Chr(10)
cQuery += "	  ON CTT.D_E_L_E_T_<>'*' " + Chr(13)+Chr(10)
cQuery += "		 AND CTT_CUSTO = OBRA " + Chr(13)+Chr(10)
cQuery += "		 AND CTT_FILIAL = '  ' " + Chr(13)+Chr(10)
cQuery += "		 AND CTT_CUSTO NOT IN ('000       ','100       ','200       ','300       ', '400       ', " + Chr(13)+Chr(10)
cQuery += "							   '500       ','600       ','700       ','800       ','900       ')   " + Chr(13)+Chr(10)
//cQuery += "		 AND ((CTT_MSBLQL <> '1' AND '"+cCONSBLOQ+"' = 'NAO') OR '"+cCONSBLOQ+"' = 'SIM') "  + Chr(13)+Chr(10) 
//substituido linha acima pelo bloco abaixo [Mauro Nagata, Actual Trend, 18/04/2013]
If cConsBloq != "SOBLQ"
   cQuery += "		 AND ((CTT_MSBLQL <> '1' AND '"+cCONSBLOQ+"' = 'NAO') OR '"+cCONSBLOQ+"' = 'SIM') "  + Chr(13)+Chr(10)
Else          //quando for as obras bloqueadas
   cQuery += "     AND ('"+cCONSBLOQ+"' = 'SOBLQ' AND CTT_MSBLQL = '1' )"+ Chr(13)+Chr(10)
EndIf   
//fim bloco [Mauro Nagata, Actual Trend, 18/04/2013]
cQuery += "GROUP BY OBRA, CTT_DESC01,NATUREZ,DESCRNAT  " + Chr(13)+Chr(10)
cQuery += "ORDER BY OBRA, NATUREZ " + Chr(13)+Chr(10)

memoWrite('RFIN019.sql', cQuery)

If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
EndIf
TcQuery cQuery New Alias "QRY"


//SetRegua(RecCount())                                                                     
nCountReg := 0
DbEval({|| nCountReg++})
SetRegua(nCountReg)           

// ************************ Monta Estrutura do Temporario Excel
_aStruct := {} 
aAdd(_aStruct,{"OBRA"     ,"C",09,0})    //Codigo da Obra
aAdd(_aStruct,{"NOMEOBRA" ,"C",40,0})    //DescriÁ„o da Obra
aAdd(_aStruct,{"NATUREZA" ,"C",10,0})    //Natureza 
aAdd(_aStruct,{"DESCRNAT" ,"C",30,0})    //Descricao da Natureza
aAdd(_aStruct,{"ORCADO"   ,"N",08 ,0})    //Valor Orcado
aAdd(_aStruct,{"REALIZADO","N",08 ,0})    //Valor Realizado
aAdd(_aStruct,{"SALDO"    ,"N",08 ,0})    //Saldo
                                                                                        
cArqTMP	:= CriaTrab(_aStruct)   

DbUseArea( .T.,, cArqTmp, "TMP", if(.F. .OR. .F., !.F., NIL), .F. )          //__LocalDriver                                                 
                       
lIp := .T.

DbSelectArea("QRY") 
DbGoTop()
              
Do While !Eof()  
   If Prow()>55.Or.lIp
   	  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	  lIp := .F.
   EndIf  
   cObra := QRY->OBRA
   @ Prow()+2,00 PSay cObra
   @ Prow(),Pcol()+1 PSay "- "+QRY->DESCR        
   @ Prow()+1,00 PSay ""
   Do While !Eof().And.QRY->OBRA = cObra
	
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Verifica o cancelamento pelo usuario...                             ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ				
		If lAbortPrint
			@Prow()+1,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif                                                                                                                                    		
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Impressao do cabecalho do relatorio. . .                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		
		If Prow()>55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		EndIf        
	
		IncRegua()    
		nSaldo := VLR_ORCA - VLR_REAL
		If MV_PAR03 = 1.Or.(MV_PAR03 = 2 .And.nSaldo < 0)             //1, qualquer saldo ou 2,somente saldo negativo
		   @ Prow()+1,01     PSay NATUREZ                             //codigo natureza
		   @ Prow(),Pcol()+7 PSay DESCRNAT                            //descricao natureza
		   @ Prow(),Pcol()+1 PSay VLR_ORCA PICTURE "@RE 99,999,999"   //valor orcado
		   @ Prow(),Pcol()+1 PSay VLR_REAL PICTURE "@RE 99,999,999"   //valor realizado		
		   @ Prow(),Pcol()+1 PSay nSaldo   PICTURE "@RE 99,999,999"   
		   
		   DbSelectArea("TMP")
		   RecLock("TMP",.T.)
		   OBRA      := QRY->OBRA
		   NOMEOBRA  := QRY->DESCR
		   NATUREZA  := QRY->NATUREZ
		   DESCRNAT  := QRY->DESCRNAT
		   ORCADO    := QRY->VLR_ORCA
		   REALIZADO := QRY->VLR_REAL
		   SALDO     := nSaldo
		   TMP->(MsUnLock())
		   
		EndIf   
		    
		DbSelectArea("QRY")
	 	DbSkip()
   EndDo	 	                
   @ Prow()+2,00 PSay Replicate("-",80)
EndDo
                 
QRY->(DbCloseArea())
	    
Return   


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Funcao    ≥ValidPerg ∫Autor  ≥Cosme da Silva Nunes∫Data  ≥13.11.2007   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥                              							  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ValidPerg()

Local aRegs   := {}

cPerg := PADR(cPerg,10)
//			Grupo 	/Ordem	/Pergunta				/Pergunta Espanhol	/Pergunta Ingles	/Variavel	/Tipo	/Tamanho	/Decimal/Presel	/GSC	/Valid	/Var01		/Def01	    /DefSpa1/DefEng1/Cnt01	/Var02	/Def02	      /DefSpa2/DefEng2/Cnt02	/Var03	/Def03	/DefSpa3/DefEng3/Cnt03	/Var04	/Def04	/DefSpa4/DefEng4/Cnt04	/Var05	/Def05	/DefSpa5/DefEng5/Cnt05	/F3		/GRPSX6
Aadd(aRegs,{cPerg	,"01"	,"Obra de          ?"	,""					,""					,"mv_ch1"	,"C"	,09			,00		,0		,"G"	,""		,"mv_par01"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"CTT"	,""		})
Aadd(aRegs,{cPerg	,"02"	,"Obra AtÈ         ?"	,""					,""					,"mv_ch2"	,"C"	,09			,00		,0		,"G"	,""		,"mv_par02"	,""		    ,""		,""		,""		,""		,""		     ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"CTT"	,""		})
Aadd(aRegs,{cPerg	,"03"	,"Saldo            ?"	,""					,""					,"mv_ch3"	,"C"	,01			,00		,0		,"C"	,""		,"mv_par03"	,"Ambas"    ,""		,""		,""		,""		,"Negativo"  ,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""	    ,""		})
Aadd(aRegs,{cPerg	,"04"	,"Consid.Bloqueadas?"	,""					,""					,"mv_ch4"	,"C"	,01			,00		,0		,"C"	,""		,"mv_par04"	,"Sim"      ,""		,""		,""		,""		,"Nao"       ,""		,""		,""		,""		,"So Bloq"		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""	    ,""		})

LValidPerg( aRegs )

Return