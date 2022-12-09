#INCLUDE "APDR010.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*+--------------------+--------------------+----------------------------------------------------------+
  | Programa.: APDR010 | Autor.: Eduardo Ju | Data.: 17/07/06                                          |
  +--------------------+--------------------+----------------------------------------------------------+
  | Objetivo.: Emitir o relatrorio com os resultados das avaliações.                                   |
  +----------------------------------------------------------------------------------------------------+
  | Parametros.:                                                                                       |
  +----------------------------------------------------------------------------------------------------+
  |                                     Atualizações Sofridos                                          |
  +-------------------------+----------+------------------+--------------------------------------------+
  | Responsasavel           | Data     | Documento        | Motivo                                     | 
  +-------------------------+----------+------------------+--------------------------------------------+
  | Eduardo Ju              | 23/04/07 | 122780           | Correcao do Filtro do Relatorio R3.        |
  +-------------------------+----------+------------------+--------------------------------------------+
  | Leandro Dr              | 08/12/08 | 008740           | Ajuste na impressao do grau de importancia.|
  +-------------------------+----------+------------------+--------------------------------------------+
  | Mariella Garagatti      | 19/06/12 | Opvs             | Criacao da funcao Vlrquest: lista a media  |
  |                         |          |                  | final da avaliacao do funcionario          |
  +-------------------------+----------+------------------+--------------------------------------------+
  | Mariella Garagatti      | 16/11/12 | Opvs             | Tratativa na funcao Ap010PrintI para nao   |
  |                         |          |                  | imprimir questoes dissertativas (Tipo 3)   |
  +-------------------------+----------+------------------+--------------------------------------------+
  | Alexandre Alves         | 12.01.17 | CERTISIGN        | Rotina totalmente remodelada. Eliminados os|
  |                         |          |                  | bugs da rotina. Incluida a query a fim de  |
  |                         |          |                  | os filtros padroes do TREPORT que causam   |
  |                         |          |                  | lentidao em todo o processo.               |
  +-------------------------+----------+------------------+--------------------------------------------+
*/
User Function APDR01C()

Local oReport
Local aArea  := GetArea()

Private cAlsPrc := GetNextAlias()

APD10RSX1()

oReport := ReportDef()
oReport:PrintDialog()	

RestArea( aArea )

Return

/*+----------------------+---------------------+-----------------+
  | Funcao.: ReportDef() | Autor.: Eduardo Ju  | Data.: 17.07.06 |
  +----------------------+---------------------+-----------------+
  | Objetivo.: Definicao do Componente de Impressao do Relatorio |
  +--------------------------------------------------------------+
  | Parametros.:                                                 |
  +--------------------------------------------------------------+
  | Uso.:                                                        |
  +--------------------------------------------------------------+
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3	
Local oSection4
Local oSection5
Local aOrdem  := {"Por Filial + Avaliacao + Competencia + Avaliado + Item Competencia "}

oReport:=TReport():New("APDR01C",STR0001,"APDR01C",{|oReport| PrintReport(oReport)},STR0024)	//"Resultado Global"#"Será impresso de acordo com os parametros solicitados pelo usuario"
oReport:SetTotalInLine(.F.)                                                                 //Totaliza em linha    
oReport:SetPortrait()                                                                       //Define a orientacao de pagina do relatorio como retrato.

Pergunte(oReport:uParam,.F.) 

/*+------------------------------------------------------------------------------------+
  | mv_par01-> Filial De                                                               |
  | mv_par02-> Filial Ate                                                              |
  | mv_par03-> Avaliacao De                                                            |
  | mv_par04-> Avaliacao Ate                                                           |
  | mv_par05-> Avaliado De                                                             |
  | mv_par06-> Avaliado Ate                                                            |
  | mv_par07-> Projeto De                                                              |
  | mv_par08-> Projeto Ate                                                             |
  | mv_par09-> Competencia De                                                          |
  | mv_par10-> Competencia Ate                                                         |
  | mv_par11-> Tipo de Avaliação ( 1 = Somente Consenso / 2 = Sem Consenso / 3 = Ambas)|
  | mv_par12-> Dt.Inicio Avaliações                                                    |
  | mv_par13-> Dt.Final Avaliações                                                     |
  | mv_par14-> C. de Custo De                                                          |
  | mv_par15-> C. de Custo Ate                                                         |
  +------------------------------------------------------------------------------------+*/


//------------------------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Primeira Secao: Avaliacao.
oSection1 := TRSection():New(oReport,STR0004,{cAlsPrc},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	//"Avaliacao"
oSection1:SetTotalInLine(.F.)
oSection1:SetAutoSize()		  //Ajuste Automatico do Tamanho do Cabecalho da Secao
oSection1:SetHeaderBreak(.T.)  
oSection1:SetPageBreak(.T.)  

TRCell():New(oSection1,"RDB_CODAVA",cAlsPrc,STR0004)	//Codigo da Avaliacao
TRCell():New(oSection1,"RD6_DESC"  ,cAlsPrc,"",, 30)	//Descricao da Avaliacao
TRCell():New(oSection1,"RDB_CODTIP",cAlsPrc,STR0021)	//Codigo do Tipo da Avaliacao
TRCell():New(oSection1,"RD5_DESC"  ,cAlsPrc,"", ,30)	//Descricao do Tipo da Avaliacao
TRCell():New(oSection1,"RD6_CODMOD",cAlsPrc,STR0022)	//Codigo do Modelo de Avaliacao
TRCell():New(oSection1,"RD3_DESC"  ,cAlsPrc,"", ,30)	//Descricao do Modelo de Avaliacao  
TRCell():New(oSection1,"RD6_CODVIS",cAlsPrc,STR0006)	//Codigo da Visao Padrao
TRCell():New(oSection1,"RDK_DESC"  ,cAlsPrc,"", ,30) 	//Descricao da Visao Padrao
TRCell():New(oSection1,"RD6_DTINI" ,cAlsPrc,STR0008)	//Data Inicio
TRCell():New(oSection1,"RD6_DTFIM" ,cAlsPrc,STR0009)	//Data Fim


//------------------------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Segunda Secao: Lotação.
oSection2 := TRSection():New(oReport,"Lotação",{cAlsPrc},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Lotação"
oSection2:SetTotalInLine(.F.) 
oSection2:SetHeaderBreak(.T.)  
oSection2:SetPageBreak(.T.)  
oSection2:SetLeftMargin(1)	//Identacao da Secao
//oSection2:SetParentQuery(.T.)

TRCell():New(oSection2,"RA_FILIAL" ,cAlsPrc,"Filial"         ) //Filial.
TRCell():New(oSection2,"M0_FILIAL" ,"SM0","",,,,{|| Posicione("SM0",1,cEmpAnt+(cAlsPrc)->(RA_FILIAL),"M0_FILIAL")}) //Descrição da Filial.
TRCell():New(oSection2,"RA_CC"     ,cAlsPrc,"Centro de Custo") //Centro de Custo.
TRCell():New(oSection2,"CTT_DESC01",cAlsPrc,"Desc. C. Custo" ) //Descrição Centro de Custo.

////oSection2:Cell("RA_FILIAL"):SetLineBreak()
//oSection2:Cell("RA_CC"):SetLineBreak() 


//------------------------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Terceira Secao: Avaliado.

oSection3 := TRSection():New(oReport,STR0011,{cAlsPrc},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Avaliado"
oSection3:SetTotalInLine(.F.) 
oSection3:SetHeaderBreak(.T.)  
oSection3:SetPageBreak(.T.)  
oSection3:SetLeftMargin(2)	//Identacao da Secao
//oSection3:SetParentQuery(.T.)

TRCell():New(oSection3,"RD0_CODIGO",cAlsPrc        ) //Codigo do Avaliado 
TRCell():New(oSection3,"RD0_NOME"  ,cAlsPrc,""     ) //Nome do Avaliado
TRCell():New(oSection3,"RDB_CODPRO",cAlsPrc,STR0010) //Codigo do Projeto
TRCell():New(oSection3,"RDN_DESC"  ,cAlsPrc,""     ) //Descricao do Projeto
TRCell():New(oSection3,"RDN_DTIPRO",cAlsPrc        ) //Data Inicio do Projeto    
TRCell():New(oSection3,"RDN_DTFPRO",cAlsPrc        ) //Data Fim do Projeto     

//oSection3:Cell("RD0_CODIGO"):SetLineBreak()
//oSection3:Cell("RDB_CODPRO"):SetLineBreak() 

//------------------------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Quarta Secao: Competencia.
oSection4 := TRSection():New(oReport,STR0007,{cAlsPrc},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Competencia"
oSection4:SetTotalInLine(.F.) 
oSection4:SetHeaderBreak(.T.)  
oSection4:SetPageBreak(.T.)  
oSection4:SetLeftMargin(3)	//Identacao da Secao
//oSection4:SetParentQuery(.T.)
  
TRCell():New(oSection4,"RDB_CODCOM",cAlsPrc   ) //Codigo da Competencia
TRCell():New(oSection4,"RDM_DESC"  ,cAlsPrc,"") //Descricao da Competencia

//oSection4:Cell("RDB_CODCOM"):SetLineBreak()

//------------------------------------------------------------------------------------------------------------------------------------------------------------
//-> Criacao da Quinta Secao: Item de Competencia.
//oSection5 := TRSection():New(oReport,STR0012,{cAlsPrc,"RBL"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Item de Competencia"	
oSection5 := TRSection():New(oReport,STR0012,{cAlsPrc},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Item de Competencia"	
oSection5:SetTotalInLine(.F.)  
oSection5:SetHeaderBreak(.F.)    
oSection5:SetPageBreak(.F.)    
oSection5:SetLeftMargin(4)	//Identacao da Secao
//oSection5:SetParentQuery(.T.)

TRCell():New(oSection5,"RDB_ITECOM",cAlsPrc                                                                        ) //Codigo do Item de Competencia
TRCell():New(oSection5,"RD2_DESC"  ,cAlsPrc,""                                                                     ) //Descricao do Item de Competencia 
TRCell():New(oSection5,"RDB_CODQUE",cAlsPrc,"Questao"                                                              ) //Codigo da Questao
TRCell():New(oSection5,"QO_QUES_"  ,cAlsPrc,""                                                                     ) //Descricao da Questao
TRCell():New(oSection5,"RDB_TIPOAV",cAlsPrc,"Tipo Avaliacao",  ,,,{||fDscAprv() }                                  ) //Tipo Avaliacao
TRCell():New(oSection5,"RBL_VALOR" ,cAlsPrc,STR0014,"@R 999.99",,,{|| Ap010Grau() }                                ) //Valor do Grau de Importancia (Impacto)
TRCell():New(oSection5,"VALOR1"    ,cAlsPrc,"Escala","@R 999.99",,,{|| VlrQuest() }                                ) //Escala      
TRCell():New(oSection5,"RDB_RESOBT",cAlsPrc,"Grau de Orientacao"                                                   ) //Resultado Obtido

//oSection5:Cell("RDB_ITECOM"):SetLineBreak()
//oSection5:Cell("RDB_CODQUE"):SetLineBreak()
//oSection5:Cell("RDB_TIPOAV"):SetLineBreak()

Return oReport

/*+------------------------+---------------------+-----------------+
  | Funcao.: PrintReport() | Autor.: Eduardo Ju  | Data.: 17.07.06 |
  +------------------------+---------------------+-----------------+
  | Objetivo.: Impressao do Relatorio (Resultado Global)           |
  +----------------------------------------------------------------+
  | Parametros.:                                                   |
  +----------------------------------------------------------------+
  | Uso.:                                                          |
  +----------------------------------------------------------------+
*/
Static Function PrintReport(oReport)

Local cQuery    := ""
Local cLogHour  := "Hora Inicio..: "+Time()+" | Hora Fim..: "
Local nCntPrc   := 0
Local cCvSect1  := "@@"
Local cCvSect2  := "@@"
Local cCvSect3  := "@@"
Local cCvSect4  := "@@"
Local cCvSect5  := "@@"
Local oSection1 := oReport:Section(1) //-> Avaliação.
Local oSection2 := oReport:Section(2) //-> Lotação
Local oSection3 := oReport:Section(3) //-> Avaliado.
Local oSection4 := oReport:Section(4) //-> Competencia.
Local oSection5 := oReport:Section(5) //-> Item de Competencia.

Private cIteCom  := ""
Private aItem2Bk := {}
Private aItem3Bk := {}

//-> Tratamento dos perguntes.
mv_par01 := If(Empty(mv_par01), Space(TAMSX3("RA_FILIAL")[1]), AllTrim(mv_par01))
mv_par02 := If(Empty(mv_par02),  AllTrim(Padr(mv_par02, TAMSX3("RA_FILIAL")[1],'Z')), AllTrim(mv_par02))
mv_par03 := If(Empty(mv_par03), Space(TAMSX3("RDB_CODAVA")[1]), AllTrim(mv_par03))
mv_par04 := If(Empty(mv_par04),  AllTrim(Padr(mv_par04, TAMSX3("RDB_CODAVA")[1],'Z')), AllTRim(mv_par04))
mv_par05 := If(Empty(mv_par05), Space(TAMSX3("RDB_CODADO")[1]), AllTrim(mv_par05))
mv_par06 := If(Empty(mv_par06),  AllTrim(Padr(mv_par06, TAMSX3("RDB_CODADO")[1],'Z')), AllTrim(mv_par06))
mv_par07 := If(Empty(mv_par07), Space(TAMSX3("RDB_CODPRO")[1]), AllTrim(mv_par07))
mv_par08 := If(Empty(mv_par08),  AllTrim(Padr(mv_par08, TAMSX3("RDB_CODPRO")[1],'Z')), AllTrim(mv_par08))
mv_par09 := If(Empty(mv_par09), Space(TAMSX3("RDB_CODCOM")[1]), AllTrim(mv_par09))
mv_par10 := If(Empty(mv_par10),  AllTrim(Padr(mv_par10, TAMSX3("RDB_CODCOM")[1],'Z')), AllTrim(mv_par10))
mv_par12 := If(Empty(mv_par12), CToD("  /  /    "), mv_par12)                       
mv_par13 := If(Empty(mv_par13), CToD("30/"+Month(dDataBase)+"/"+Year(dDataBase)), mv_par13)                       
mv_par14 := If(Empty(mv_par14), Space(TAMSX3("CTT_CUSTO")[1]), AllTrim(mv_par14))
mv_par15 := If(Empty(mv_par15),  AllTrim(Padr(mv_par15, TAMSX3("CTT_CUSTO")[1],'Z')), AllTrim(mv_par15))

//-> Transforma parametros Range em expressao (intervalo).
//MakeAdvplExpr("APD10R")	 

cQuery += "SELECT DISTINCT RA_FILIAL   "+CRLF
cQuery += "               ,RA_CC       "+CRLF
cQuery += "               ,CTT_DESC01  "+CRLF
cQuery += "               ,RDB_CODAVA  "+CRLF
cQuery += "               ,RD6_DESC    "+CRLF
cQuery += "               ,RDB_CODTIP  "+CRLF
cQuery += "               ,RD5_DESC    "+CRLF
cQuery += "               ,RD5_TIPO    "+CRLF
cQuery += "               ,RDB_CODMOD  "+CRLF
cQuery += "               ,RD3_DESC    "+CRLF
cQuery += "               ,RD6_CODVIS  "+CRLF
cQuery += "               ,RDK_DESC    "+CRLF
cQuery += "               ,RD6_DTINI   "+CRLF
cQuery += "               ,RD6_DTFIM   "+CRLF
cQuery += "               ,RDB_CODPRO  "+CRLF
cQuery += "               ,RDN_DESC    "+CRLF
cQuery += "               ,RDN_DTIPRO  "+CRLF
cQuery += "               ,RDN_DTFPRO  "+CRLF
cQuery += "               ,RD0_CODIGO  "+CRLF
cQuery += "               ,RD0_NOME    "+CRLF
cQuery += "               ,RD0_MAT     "+CRLF
cQuery += "               ,RA_MAT      "+CRLF
cQuery += "               ,RA_NOME     "+CRLF
cQuery += "               ,RDB_CODNET  "+CRLF
cQuery += "               ,RD1_DESC    "+CRLF
cQuery += "               ,RDB_CODCOM  "+CRLF
cQuery += "               ,RDM_DESC    "+CRLF
cQuery += "               ,RDB_ITECOM  "+CRLF
cQuery += "               ,RD2_DESC    "+CRLF
cQuery += "               ,RDB_TIPOAV  "+CRLF
cQuery += "               ,RDB_CODALT  "+CRLF
cQuery += "               ,RDB_ESCALA  "+CRLF
cQuery += "               ,RDB_ITEESC  "+CRLF
cQuery += "               ,RDB_CODQUE  "+CRLF
cQuery += "               ,QO_QUES_    "+CRLF
cQuery += "               ,RDB_RESOBT  "+CRLF
cQuery += "               ,RD9_MEDFIN  "+CRLF
cQuery += "FROM "+RetSqlName("RDB")+" RDB    "+CRLF
cQuery += "LEFT OUTER JOIN "+RetSqlName("RDN")+" RDN ON RDB_CODPRO = RDN_CODIGO AND RDN.D_E_L_E_T_ <> '*'   "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD6")+" RD6      ON RD6_CODIGO = RDB_CODAVA AND RD6_CODTIP = RDB_CODTIP "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD5")+" RD5      ON RD5_CODTIP = RDB_CODTIP                             "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD3")+" RD3      ON RD3_CODIGO = RD6_CODMOD                             "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RDK")+" RDK      ON RDK_CODIGO = RD6_CODVIS                             "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD0")+" RD0      ON RD0_CODIGO = RDB_CODADO                             "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RDZ")+" RDZ      ON RDZ_CODRD0 = RD0_CODIGO                             "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SRA")+" SRA      ON RA_FILIAL  = SUBSTR(RDZ_CODENT,1,2) AND RA_MAT = SUBSTR(RDZ_CODENT,3,6) "+CRLF
cQuery += "INNER JOIN "+RetSqlName("CTT")+" CTT      ON CTT_CUSTO  = RA_CC                                  "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD9")+" RD9      ON RD9_CODAVA = RDB_CODAVA AND RD9_CODADO = RDB_CODADO "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RDM")+" RDM      ON RDM_CODIGO = RDB_CODCOM                             "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD2")+" RD2      ON RD2_CODIGO = RDB_CODCOM AND RD2_ITEM = RDB_ITECOM   "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD1")+" RD1      ON RD1_CODIGO = RDB_CODNET                             "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SQO")+" SQO      ON QO_QUESTAO = RDB_CODQUE                             "+CRLF
cQuery += "WHERE RD6.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RD5.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RD3.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RDK.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RD0.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RDZ.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND SRA.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RD9.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RDM.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RD2.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RD1.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RDB.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND SQO.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND CTT.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RA_FILIAL  BETWEEN '"+mv_par01  + "' AND '"+mv_par02+"' "+CRLF
cQuery += "  AND RDB_CODAVA BETWEEN '"+mv_par03  + "' AND '"+mv_par04+"' "+CRLF
cQuery += "  AND RDB_CODADO BETWEEN '"+mv_par05  + "' AND '"+mv_par06+"' "+CRLF
cQuery += "  AND RDB_CODPRO BETWEEN '"+mv_par07  + "' AND '"+mv_par08+"' "+CRLF
cQuery += "  AND RDB_CODCOM BETWEEN '"+mv_par09  + "' AND '"+mv_par10+"' "+CRLF
cQuery += "  AND RDB_DTIAVA >= '"+DToS(mv_par12) + "' "+CRLF
cQuery += "  AND RDB_DTFAVA <= '"+DToS(mv_par13) + "' "+CRLF
cQuery += "  AND RA_CC      BETWEEN '"+mv_par14  + "' AND '"+mv_par15+"' "+CRLF
cQuery += "  AND RDB_CODALT <> ' ' "+CRLF
cQuery += "  AND RDB_ESCALA <> ' ' "+CRLF
//cQuery += "  AND RDB_ITEESC <> ' ' "+CRLF //=> Comentado porque haviam perguntadas cadastradas em modelos de avaliações, sem definição do Item/Escala de Relevancia.

//mv_par11-> Tipo de Avaliação ( 1 = Somente Consenso / 2 = Sem Consenso / 3 = Ambas)|
If mv_par11 = 1 
   cQuery += "  AND RDB_TIPOAV = '3'                "+CRLF
ElseIf mv_par11 = 2
   cQuery += "  AND RDB_TIPOAV = '2'                                "+CRLF
   cQuery += "  AND NOT EXISTS(SELECT 1 FROM "+RetSqlName("RDD")+"  "+CRLF
   cQuery += "                 WHERE D_E_L_E_T_ <> '*'              "+CRLF
   cQuery += "                   AND RDD_CODAVA = RDB.RDD_CODAVA    "+CRLF
   cQuery += "                   AND RDD_CODADO = RDB.RDD_CODADO    "+CRLF
   cQuery += "                   AND RDD_TIPOAV = '3')              "+CRLF
EndIf

cQuery += "ORDER BY RA_FILIAL, RDB_CODAVA, RA_CC, RD0_CODIGO, RDB_CODCOM, RDB_ITECOM, RDB_CODQUE, RDB_TIPOAV "+CRLF

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlsPrc)     

TCSetField( cAlsPrc, "RD6_DTINI",  "D", 8 )
TCSetField( cAlsPrc, "RD6_DTFIM",  "D", 8 )
TCSetField( cAlsPrc, "RDN_DTIPRO", "D", 8 )
TCSetField( cAlsPrc, "RDN_DTFPRO", "D", 8 )

oReport:SetMeter( (cAlsPrc)->(RecCount()) )

      (cAlsPrc)->( dbGoTop() )
While (cAlsPrc)->(!EOF())

    nCntPrc++

    oReport:IncMeter(nCntPrc)

   //-> Imprime Section 1 - Avaliação.
   If (cAlsPrc)->(RDB_CODAVA + RDB_CODTIP + RDB_CODMOD + RD6_CODVIS + DTOS(RD6_DTINI) + DTOS(RD6_DTFIM)) <> cCvSect1
   
      oSection5:Finish()  
      oSection4:Finish()  
      oSection3:Finish()  
      oSection2:Finish()  
      oSection1:Finish()  
 
      oSection1:Init()	        
      oSection1:PrintLine()           

      cCvSect1 := (cAlsPrc)->(RDB_CODAVA + RDB_CODTIP + RDB_CODMOD + RD6_CODVIS + DTOS(RD6_DTINI) + DTOS(RD6_DTFIM))
   EndIf

   //-> Imprime Section 2 - Lotação.
   If (cAlsPrc)->(RA_FILIAL + RA_CC) <> cCvSect2
   
      oSection5:Finish()  
      oSection4:Finish()  
      oSection3:Finish()  
      oSection2:Finish()  
                  
      oSection2:Init()	        
      oSection2:PrintLine()           

      cCvSect2 := (cAlsPrc)->(RA_FILIAL + RA_CC)
   EndIf       

   //-> Imprime Section 3 - Avaliado.
   If (cAlsPrc)->(RD0_CODIGO + RDB_CODPRO + DTOS(RDN_DTIPRO) + DTOS(RDN_DTFPRO)) <> cCvSect3
   
      oSection5:Finish()  
      oSection4:Finish()  
      oSection3:Finish()  
            
      oSection3:Init()	        
      oSection3:PrintLine()           

      cCvSect3 := (cAlsPrc)->(RD0_CODIGO + RDB_CODPRO + DTOS(RDN_DTIPRO) + DTOS(RDN_DTFPRO))
   EndIf              
   
   //-> Imprime Section 4 - Competencia.
   If (cAlsPrc)->(RDB_CODCOM + RD0_CODIGO) <> cCvSect4
   
      oSection5:Finish()  
      oSection4:Finish()  
      
      oSection4:Init()	        
      oSection4:PrintLine()           

      cCvSect4 := (cAlsPrc)->(RDB_CODCOM + RD0_CODIGO)
   EndIf              

   //-> Imprime Section 5 - Item da Competencia. - Questões.
   If (cAlsPrc)->(RD0_CODIGO + RDB_CODCOM + RDB_ITECOM + RDB_CODQUE + RDB_TIPOAV) <> cCvSect5
   
      oSection5:Init()	        
      oSection5:PrintLine()           
            
      cCvSect5 := (cAlsPrc)->(RD0_CODIGO + RDB_CODCOM + RDB_ITECOM + RDB_CODQUE + RDB_TIPOAV)
   EndIf              

   (cAlsPrc)->(dbSkip())
EndDo

(cAlsPrc)->( dbCloseArea() )

cLogHour  += Time()

MsgStop("Tempo de execução.: "+cLogHour)

Return Nil

/*+------------------------+---------------------+-----------------+
  | Funcao.: Ap010Grau()   | Autor.: Eduardo Ju  | Data.: 17.07.06 |
  +------------------------+---------------------+-----------------+
  | Objetivo.: Valor do Grau de Importancia do Item de Competencia.|
  +----------------------------------------------------------------+
  | Parametros.:                                                   |
  +----------------------------------------------------------------+
  | Uso.: APDR010                                                  |
  +----------------------------------------------------------------+
*/
Static Function Ap010Grau() 
                    //          Avaliacao  + Avaliado   + Competencia + Item Competencia 
Local cKeySeek 	:= (cAlsPrc)->( RDB_CODAVA + RDB_CODAVA + RDB_CODCOM  + RDB_ITECOM ) 
Local nGrauIm	:= 0 
Local cQuery    := ""
Local cAlsTb    := GetNextAlias()

//RD7: Itens refinamentos avaliações 
RD7->( dbSetOrder(1) ) //-> RD7_FILIAL+RD7_CODAVA+RD7_CODADO+RD7_CODCOM+RD7_ITECOM

//RBL: Itens Escala/Importancia
RBL->( dbSetOrder(1) ) //-> RBL_FILIAL+RBL_ESCALA+RBL_ITEM

If 	RD7->( dbSeek( xFilial("RD7") + cKeySeek ) ) .And.;            
	RBL->( dbSeek( xFilial("RBL") + RD7->( RD7_ESCALA+RD7_ITEESC ) ) )   
	
	nGrauIm := RBL->RBL_VALOR 		 
Else

    cQuery := "SELECT RDO_ESCALA, RDO_ITEESC "
    cQuery += "      ,(SELECT RBL_VALOR "
    cQuery += "        FROM "+RetSqlName("RBL")+" "
    cQuery += "        WHERE D_E_L_E_T_ <> '*' "
    cQuery += "          AND RBL_ESCALA = RDO_ESCALA "
    cQuery += "          AND RBL_ITEM   = RDO_ITEESC) VLRGIP " 
    cQuery += "FROM "+RetSqlName("RDO")+" "
    cQuery += "WHERE D_E_L_E_T_ <> '*' "
    cQuery += "  AND RDO_CODMOD = '"+(cAlsPrc)->RDB_CODMOD+"' "
    cQuery += "  AND RDO_CODCOM = '"+(cAlsPrc)->RDB_CODCOM+"' "
    cQuery += "  AND RDO_ITECOM = '"+(cAlsPrc)->RDB_ITECOM+"' "
    cQuery := ChangeQuery(cQuery)

    TCQUERY cQuery NEW ALIAS cAlsTb

    cAlsTb->(dbGoTop())    
    
    nGrauIm := cAlsTb->VLRGIP
    
    cAlsTb->(dbCloseArea())

    //Alteracao para considerar o valor do impacto do Fator de Desempenho (RDO_ITEESC) e nao da questao (RD8_ITEESC) 	  
    //nGrauIm := Posicione("RBL",1,xFilial("RBL")+(cAlsPrc)->RDB_ESCALA+;
     //           Posicione("RDO",1,xFilial("RDO")+(cAlsPrc)->(RD6_CODMOD+RDD_CODCOM+RDD_ITECOM),"RDO_ITEESC"),"RBL_VALOR") 	
EndIf   

Return nGrauIm

/*+------------------------+----------------------------+-----------------+
  | Funcao.: VlrQuest      | Autor.: Mariella Garagatti | Data.: 19.06.12 |
  +------------------------+----------------------------+-----------------+
  | Objetivo.: Valor das questoes.                                        |
  +-----------------------------------------------------------------------+
  | Parametros.:                                                          |
  +-----------------------------------------------------------------------+
  | Uso.: APDR01C                                                         |
  +-----------------------------------------------------------------------+
*/
Static Function VlrQuest() 
                              //    Avaliacao  + Avaliado   + Competencia+ Item Competencia 
Local _cKeySeek 	:= (cAlsPrc)->( RDB_CODAVA + RD0_CODIGO + RDB_CODCOM + RDB_ITECOM ) 
Local _nVlrQuest	:= 0         
Local _nGrauIm      := 0
Local cQuery        := ""
Local cAlsTb        := GetNextAlias()
 
If 	RD7->( dbSeek( xFilial("RD7") + _cKeySeek ) ) .And.;            //RD7: Itens refinamentos avaliações
	RBL->( dbSeek( xFilial("RBL") + RD7->( RD7_ESCALA+RD7_ITEESC ) ) )   //RBL: Itens Escala/Importancia
	
	_nGrauIm := RBL->RBL_VALOR 		 

Else
	_nGrauIm := Ap010Grau()	  
EndIf            

cQuery := "SELECT  QO_QUESTAO "
cQuery += "       ,QO_ESCALA  "
cQuery += "       ,RBL_VALOR VLRQST "
cQuery += "FROM "+RetSqlName("SQO")+" SQO "
cQuery += "INNER JOIN "+RetSqlName("RBL")+" RBL ON RBL_ESCALA = QO_ESCALA AND RBL_ITEM   = '"+(cAlsPrc)->RDB_CODALT+"' "
cQuery += "WHERE SQO.D_E_L_E_T_ <> '*' "
cQuery += "  AND RBL.D_E_L_E_T_ <> '*' "
cQuery += "  AND QO_QUESTAO = '"+(cAlsPrc)->RDB_CODQUE+"' "
cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS cAlsTb

cAlsTb->(dbGoTop())    

_nVlrQuest	:= cAlsTb->VLRQST

cAlsTb->( dbCloseArea() )

/*   
If  _nGrauIm  > 0
   _nVlrQuest := round((cAlsPrc)->RDD_RESOBT/ _nGrauIm,2)    
Else
   _nVlrQuest := 0
Endif    
*/
   
Return  _nVlrQuest

/*+------------------------+---------------------+-----------------+
  | Funcao.: Ap010PrintI() | Autor.: Eduardo Ju  | Data.: 17.07.06 |
  +------------------------+---------------------+-----------------+
  | Objetivo.: Tratamento da Impressao do Item de Competencia      |
  +----------------------------------------------------------------+
  | Parametros.: oSection5                                         |
  +----------------------------------------------------------------+
  | Uso.: APDR010                                                  |
  +----------------------------------------------------------------+
*/
Static Function Ap010PrintI(oSection5)

Local _nGrau := Ap010Grau()   
Local _cTipo := ""
Local cQuery := ""
Local cAlSQO := GetNextAlias()

cQuery := "SELECT RDB_CODQUE, QO_TIPOOBJ "
cQuery += "FROM "+RetSqlName("RDB")+" RDB "
cQuery += "INNER JOIN "+RetSqlName("SQO")+" SQO ON QO_QUESTAO = RDB_CODQUE " 
cQuery += "WHERE RDB.D_E_L_E_T_ <> '*' "
cQuery += "  AND SQO.D_E_L_E_T_ <> '*' "
cQuery += "  AND RDB_CODAVA = '"+(cAlsPrc)->RDB_CODAVA+"' "
cQuery += "  AND RDB_CODADO = '"+(cAlsPrc)->RD0_CODIGO+"' "
cQuery += "  AND RDB_CODCOM = '"+(cAlsPrc)->RDB_CODCOM+"' "
cQuery += "  AND RDB_ITECOM = '"+(cAlsPrc)->RDB_ITECOM+"' "
cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS cAlSQO

cAlSQO->(dbGoTop())

_cTipo := cAlSQO->QO_TIPOOBJ

cAlSQO->(dbCloseArea())
     
//Para o tipo de questao dissertativa nao imprime 
If _cTipo == "3"
   oSection5:Cell("RDB_ITECOM"):Hide()
   oSection5:Cell("RD2_DESC"  ):Hide() 
   oSection5:Cell("RDB_CODQUE"):Hide() 
   oSection5:Cell("QO_QUES_"  ):Hide() 
   oSection5:Cell("RDB_TIPOAV"):Hide()
   oSection5:Cell("RBL_VALOR" ):Hide()
   oSection5:Cell("VALOR1")    :Hide()  
   oSection5:Cell("RDB_RESOBT"):Hide()  
   cIteCom := (cAlsPrc)->RDB_ITECOM      
EndIf 


If (cAlsPrc)->RDB_ITECOM  == cIteCom     
   oSection5:Cell("RDB_ITECOM"):Hide()
   oSection5:Cell("RD2_DESC"):Hide()        
   cIteCom := (cAlsPrc)->RDB_ITECOM 
Else
   oSection5:Cell("RDB_ITECOM"):Show()
   oSection5:Cell("RD2_DESC"  ):Show()
   oSection5:Cell("RDB_CODQUE"):Show()
   oSection5:Cell("QO_QUES_"  ):Show()
   oSection5:Cell("RDB_TIPOAV"):Show()
   oSection5:Cell("RBL_VALOR" ):Show()
   oSection5:Cell("VALOR1")    :Show()
   oSection5:Cell("RDB_RESOBT"):Show()
   cIteCom := (cAlsPrc)->RDB_ITECOM      
EndIf       

Return .T.                    


/*+------------------------+----------------------------+-----------------+
  | Funcao.: fDscAprv()    | Autor.: Alexandre AS.      | Data.: 10.03.17 |
  +------------------------+----------------------------+-----------------+
  | Objetivo.: Retorna a descrição do tipo de avaliador.                  |
  +-----------------------------------------------------------------------+
  | Parametros.:                                                          |
  +-----------------------------------------------------------------------+
  | Uso.: APD10RSX1                                                       |
  +-----------------------------------------------------------------------+
*/
Static Function fDscAprv()

Local cTpAvldr := If((cAlsPrc)->RDB_TIPOAV = '3', 'Consenso',;
                  If((cAlsPrc)->RDB_TIPOAV = '2', 'Avaliador', 'Avaliado'))

Return cTpAvldr


/*+------------------------+----------------------------+-----------------+
  | Funcao.: APD10RSX1     | Autor.: Eduardo Ju         | Data.: 19.06.12 |
  +------------------------+----------------------------+-----------------+
  | Objetivo.: Criacao do Pergunte APD10R no Dicionario SX1.              |
  +-----------------------------------------------------------------------+
  | Parametros.:                                                          |
  +-----------------------------------------------------------------------+
  | Uso.: APD10RSX1                                                       |
  +-----------------------------------------------------------------------+
*/
Static Function APD10RSX1()             

Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   
Local cPerg     := "APDR01C"

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
PutSX1(cPerg,"01","Filial De  ?"         ,"¿Del Sucursal ?"      ,"From Branch ?"        ,"mv_ch1" ,"C" ,02     ,0      ,0    ,"G" ,""   ,"XM0",""   ,""     ,"mv_par01","","","","","","","","","","","","","","","","")

aHelp := {	"Filial inicial para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R01.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"02","Filial Ate ?"         ,"¿Hasta Sucursal ?"    ,"To Branch ?"          ,"mv_ch2" ,"C" ,02     ,0      ,0    ,"G" ,""	,"XM0",""   ,""     ,"mv_par02","","","","","","","","","","","","","","","","")

aHelp := {	"Filial final para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R02.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"03","Avaliacao De ?"       ,"¿Del Evaluacion ?"    ,"From Evaluation ?"    ,"mv_ch3" ,"C" ,99     ,0      ,0    ,"G" ,""   ,"RD6",""   ,""		,"mv_par03","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliação inicial para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R03.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"04","Avaliacao Ate ?"      ,"¿Hasta Evaluacion ?"  ,"To Evaluation ?"      ,"mv_ch4" ,"C" ,99     ,0      ,0    ,"G" ,""   ,"RD6",""   ,""		,"mv_par04","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliação final para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R04.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


PutSX1(cPerg,"05","Avaliado De ?"        ,"¿Del Evaluado ?"      ,"From Evaluated ?"     ,"mv_ch5" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RD0",""   ,""   	,"mv_par05","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliado inicial para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R05.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


PutSX1(cPerg,"06","Avaliado Ate ?"       ,"¿Hasta Evaluado ?"    ,"To Evaluated ?"       ,"mv_ch6" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RD0",""   ,""  	,"mv_par06","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliado final para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R06.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


PutSX1(cPerg,"07","Projeto De ?"         ,"¿Del Diseno ?"        ,"From Project ?"       ,"mv_ch7" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RDN",""   ,""     ,"mv_par07","","","","","","","","","","","","","","","","")

aHelp := {	"Projeto inicial para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R07.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"08","Projeto Ate ?"        ,"¿Hasta Diseno ?"      ,"To Project ?"         ,"mv_ch8" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RDN",""   ,""		,"mv_par08","","","","","","","","","","","","","","","","")

aHelp := {	"Projeto final para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R08.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"09","Competencia De ?"     ,"¿Del Competencia ?"   ,"From Competence ?"    ,"mv_ch9" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RDM",""   ,""  	,"mv_par09","","","","","","","","","","","","","","","","")
                                                                                                                                                                                                                                                                                          
aHelp := {	"Competencia inicial para processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R09.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"10","Competencia Ate ?"    ,"¿Hasta Competencia ?" ,"To Competence ?"	    ,"mv_cha" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RDM",""   ,""     ,"mv_par10","","","","","","","","","","","","","","","","")
                                                                                                                                                                                                                                                                                          
aHelp := {	"Competencia final para processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R10.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"11","Tipo Avaliacao ?"     ,"¿Tipo de Evaluacion ?" ,"Evaluation Type ?" ,"mv_chb" ,"N" ,01     ,0      ,0    ,"C" ,""   ,""   ,""   ,""       ,"mv_par11" ,"Somente Consenso"  ,"Unico Consenso"  ,"Consensus Only" ,""     ,"Sem Consenso"  ,"No hay Consenso" ,"No consensus"  ,"Ambas"  ,"Ambos"    ,"Both","","","","","","")

aHelp := {	"Informe se deseja visualizar apenas avaliações com consenso." }
aHelpE:= {	"Indique si desea ver solo comentarios con el consenso." }
aHelpI:= {	"Indicate whether you want to view only reviews with consensus." }

PutSX1Help("P.APD10R11.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"12","Dta. Inicio Aval. ?"  ,"¿Fecha Inicio Eval. ?" ,"Start Date Eval. ?","mv_chc" ,"D" ,08     ,0      ,0    ,"G" ,""   ,""   ,""   ,""	    ,"mv_par12",""    ,""      ,""      ,""   ,""    ,""      ,""      ,"","","","","","","","","")

aHelp := {	"Data de inicio das avaliações para filtro." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R12.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"13","Dta. Final Aval. ?"   ,"¿Fecha Fim Eval. ?"   ,"End Date Eval. ?"	    ,"mv_chd" ,"D" ,08     ,0      ,0    ,"G" ,""   ,""   ,""   ,""     ,"mv_par13",""    ,""      ,""      ,""   ,""    ,""      ,""      ,"","","","","","","","","")

aHelp := {	"Data final das avaliações para filtro." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R13.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"14","C. de Custo De  ?"    ,"¿Del C. de Coste ?"   ,"From Cost Center ?"   ,"mv_che" ,"C" ,09     ,0      ,0    ,"G" ,""   ,"CTT",""   ,""     ,"mv_par14","","","","","","","","","","","","","","","","")

aHelp := {	"Centro de Custo inicial para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R14.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"15","C. de Custo Ate ?"    ,"¿Hasta C. de Coste ?" ,"To Cost Center ?"     ,"mv_chf" ,"C" ,09     ,0      ,0    ,"G" ,""	,"CTT",""   ,""     ,"mv_par15","","","","","","","","","","","","","","","","")

aHelp := {	"Centro de Custo final para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.APD10R15.",aHelp,aHelpI,aHelpE)	 

Return

/*
//TCSetField( < cAlias >, < cField >     , < cType >      , [ nSize ]      , [ nPrecision ] )
  TcSetField( "SRA"     , aStruSRA[nX,1] , aStruSRA[nX,2] , aStruSRA[nX,3] , aStruSRA[nX,4] )

cAlias - caractere -  Indica o alias da query.

cField - caractere -  Indica o nome do campo/coluna de retorno.
 
cType  - caractere -  Indica o tipo de dado a ser retornado através deste campo/coluna, que pode ser: D (Data), N (Numérico) ou L (Lógico).

nSize  - numérico  -  Indica o tamanho do campo. Valor padrão: 0 (zero).
 
nPrecision - numérico - Indica a quantidade de decimais do campo. Valor padrão: 0 (zero).
 
----------------------------------------------------------------------------------------------------------------------------------------------------------
// TRCell():New( ExpO1 : Objeto TSection que a secao pertence
                 ExpC2 : Nome da celula do relatório. O SX3 será consultado
                 ExpC3 : Nome da tabela de referencia da celula
                 ExpC4 : Titulo da celula x
                 Default : X3Titulo()
                 ExpC5 : Picture
                 Default : X3_PICTURE
                 ExpC6 : Tamanho
                 Default : X3_TAMANHO
                 ExpL7 : Informe se o tamanho esta em pixel
                 Default : False
                 ExpB8 : Bloco de código para impressao.
                 Default : ExpC2
                 )
*/