#INCLUDE "APDR030.CH"
#INCLUDE "Protheus.ch"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*+---------------------+--------------------------------------------------------------+------------+
  | Programa.: APDCRT02 | Calcula Media Final por Avaliado e Gera Relatorio de Ranking | 13.02.2017 |
  +---------------------+--------------------------------------------------------------+------------+
  | Autor.: Alexandre Alves - CERTISIGN.                                                            |
  +-------------------------------------------------------------------------------------------------+
  | Manutenção.:                                                                       | Data.:     |
  +------------------------------------------------------------------------------------+------------+
*/
User Function APDCRT02()

Local aArea     := GetArea()
Local oReport

Private TRB     := GetNextAlias()
Private aMedFim := {}

APDCT2X1()	//Criacao do Pergunte (SX1)

oReport:= ReportDef()   
oReport:PrintDialog()	

RestArea( aArea )

Return

/*+---------------------+--------------------------------------------------------------+------------+
  | Programa.: APDCRT02 | Calcula Media Final por Avaliado e Gera Relatorio de Ranking | 13.02.2017 |
  +---------------------+--------------------------------------------------------------+------------+
  | Autor.: Alexandre Alves - CERTISIGN.                                                            |
  +-------------------------------------------------------------------------------------------------+
  | Manutenção.:                                                                       | Data.:     |
  +------------------------------------------------------------------------------------+------------+
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local oSection4
Local aOrdem  := {"Por Filial + Avaliacao + Competencia + Avaliado + Item Competencia "}

oReport:=TReport():New("APDCRT02",STR0001,"APDCRT02",{|oReport| PrintReport(oReport)},STR0001+" "+STR0012)	//"Ranking Performance por Avaliado"#"Será impresso de acordo com os parametros solicitados pelo usuario"
oReport:SetTotalInLine(.F.)
oReport:SetPortrait()

Pergunte(oReport:uParam,.F.) 


//-------------------------------------------------------------------------------------------------------------------------------------
oSection1 := TRSection():New(oReport,STR0004,{TRB},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	//"Avaliacao"
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"CODAVA" ,TRB,STR0004 ,,10)	//Codigo da Avaliacao
TRCell():New(oSection1,"DESAVA" ,TRB," "     ,,40)	//Descricao da Avaliacao
TRCell():New(oSection1,"CODTIP" ,TRB,STR0007 ,,20)	//Codigo do Tipo da Avaliacao
TRCell():New(oSection1,"DESTIP" ,TRB," "     ,,40)	//Descricao do Tipo da Avaliacao
TRCell():New(oSection1,"CODMOD" ,TRB,STR0010 ,,30)	//Codigo do Modelo de Avaliacao
TRCell():New(oSection1,"DESMOD" ,TRB," "     ,,40)  //Descricao do Modelo de Avaliacao  

//-------------------------------------------------------------------------------------------------------------------------------------
oSection2 := TRSection():New(oReport,STR0008,{TRB},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Avaliado"	
oSection2:SetTotalInLine(.F.) 

TRCell():New(oSection2,"CODADO" ,TRB, "Avaliado" ,,06) //Codigo do Avaliado
TRCell():New(oSection2,"NOMADO" ,TRB, " "        ,,30) //Nome do Avaliado  
TRCell():New(oSection2,"CODCRG" ,TRB, "Cargo"    ,,05) //Cargo do Avaliado
TRCell():New(oSection2,"DESCRG" ,TRB, " "        ,,50) //Descricao do Cargo do Avaliado
TRCell():New(oSection2,"CODCCT" ,TRB, STR0006    ,,09) //Centro de Custo do Avaliado
TRCell():New(oSection2,"DESCCT" ,TRB, " "        ,,40) //Descricao do Centro de Custo

//------------------------------------------------------------------------------------------------------------------------------------- 
oSection3 := TRSection():New(oReport,"Competencias",{TRB},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Competencias"	
oSection3:SetTotalInLine(.F.) 

TRCell():New(oSection3,"CODCOM"  ,TRB, "Competencia"    ,,06) //Codigo Comptenecia
TRCell():New(oSection3,"DESCOM"  ,TRB, " "              ,,50) //Descrição Comptenecia
TRCell():New(oSection3,"ITECOM"  ,TRB, "Item"           ,,06) //Codigo Item Competencia.
TRCell():New(oSection3,"DESITE"  ,TRB, " "              ,,50) //Descrição Item Competencia.
TRCell():New(oSection3,"CONSENS" ,TRB, "Consenso"       ,,09) //Valor da Nota de Consenso
TRCell():New(oSection3,"IMPACTO" ,TRB, "Impacto"        ,,10) //Valor do Impacto
TRCell():New(oSection3,"GRORIEN" ,TRB, "Grau Orientação",,10) //Valor do Impacto
TRCell():New(oSection3,"MEDFIM"  ,TRB, "Media"          ,,10) //Media
TRCell():New(oSection3,"MEDFI2"  ,"" , ""," ",,,{|| fCalMed(oSection3)} )

//------------------------------------------------------------------------------------------------------------------------------------- 
oSection4 := TRSection():New(oReport,"Media Final",{TRB},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Media Final"	
oSection4:SetTotalInLine(.F.) 
oSection4:SetHeaderBreak(.F.)    
oSection4:SetPageBreak(.F.)    

TRCell():New(oSection4,"MEDIA0"  ,TRB, "Media Final"         ,,11) 
TRCell():New(oSection4,"MEDIA1"  ,TRB, Replicate('.',50)     ,,50) 
TRCell():New(oSection4,"MEDIA2"  ,TRB, Replicate('.',06)     ,,06) 
TRCell():New(oSection4,"XXXXX1"  ,TRB, Replicate('.',50)     ,,50)
TRCell():New(oSection4,"XXXXX2"  ,TRB, Replicate('.',09)     ,,09)
TRCell():New(oSection4,"XXXXX3"  ,TRB, Replicate('.',10)     ,,10)
TRCell():New(oSection4,"XXXXX4"  ,TRB, Replicate('.',09)+">" ,,10)
TRCell():New(oSection4,"MEDIA3"  ,"" , "",,,,{|| fMedFim() }) 
//TRCell():New(oSection4,"MEDIA3"  ,TRB, "Media","@R 99.99",,,{|| fMedFim() }) 


Return oReport


/*+---------------------+--------------------------------------------------------------+------------+
  | Programa.: APDCRT02 | Calcula Media Final por Avaliado e Gera Relatorio de Ranking | 13.02.2017 |
  +---------------------+--------------------------------------------------------------+------------+
  | Autor.: Alexandre Alves - CERTISIGN.                                                            |
  +-------------------------------------------------------------------------------------------------+
  | Manutenção.:                                                                       | Data.:     |
  +------------------------------------------------------------------------------------+------------+

mv_par01 => Filial De ?
mv_par02 => Filial Ate ?
mv_par03 => Avaliacao De ?
mv_par04 => Avaliacao Ate ?
mv_par05 => Avaliado De ?
mv_par06 => Avaliado Ate ?
mv_par07 => Competencia De ?
mv_par08 => Competencia Ate ?
mv_par09 => Item Competencia De ?
mv_par10 => Item Competencia Ate ?
mv_par11 => Tipos de Avaliações ?
mv_par12 => Dta. Inicio Aval. ?
mv_par13 => Dta. Final Aval. ?
*/
Static Function PrintReport(oReport)

Local cQuery    := ""
Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(2) 
Local oSection3 := oReport:Section(3) 
Local oSection4 := oReport:Section(4) 
Local cSect01   := "&&"
Local cSect02   := "&&"
Local cSect03   := "&&"
Local cSect04   := "&&"
Local aChvRD9   := {}

//-> Tratamento dos perguntes.
If SX2->( dbSeek("RDD") )
   If SX2->X2_MODO = "E"
      mv_par01 := If(Empty(mv_par01), Space(TAMSX3("RDD_FILIAL")[1]), AllTrim(mv_par01))
      mv_par02 := If(Empty(mv_par02),  AllTrim(Padr(mv_par02, TAMSX3("RDD_FILIAL")[1],'Z')), AllTRim(mv_par02))   
   Else
      mv_par01 :=             Space(TAMSX3("RDD_FILIAL")[1])
      mv_par02 := AllTrim( Padr("", TAMSX3("RDD_FILIAL")[1],'Z') )
   EndIf
EndIf

mv_par03 := If(Empty(mv_par03), Space(TAMSX3("RDD_CODAVA")[1]), AllTrim(mv_par03))
mv_par04 := If(Empty(mv_par04),  AllTrim(Padr(mv_par04, TAMSX3("RDD_CODAVA")[1],'Z')), AllTRim(mv_par04))
mv_par05 := If(Empty(mv_par05), Space(TAMSX3("RDD_CODADO")[1]), AllTrim(mv_par05))
mv_par06 := If(Empty(mv_par06),  AllTrim(Padr(mv_par06, TAMSX3("RDD_CODADO")[1],'Z')), AllTrim(mv_par06))
mv_par07 := If(Empty(mv_par07), Space(TAMSX3("RDD_CODCOM")[1]), AllTrim(mv_par07)) //
mv_par08 := If(Empty(mv_par08),  AllTrim(Padr(mv_par08, TAMSX3("RDD_CODCOM")[1],'Z')), AllTRim(mv_par08))
mv_par09 := If(Empty(mv_par09), Space(TAMSX3("RDD_ITECOM")[1]), AllTrim(mv_par09)) //
mv_par10 := If(Empty(mv_par10),  AllTrim(Padr(mv_par10, TAMSX3("RDD_ITECOM")[1],'Z')), AllTRim(mv_par10))
mv_par12 := If(Empty(mv_par12), CToD("  /  /    "            ), mv_par12)                       
mv_par13 := If(Empty(mv_par13), CToD("30/01/"+Year(dDataBase)), mv_par13)                       

mv_par03 := u_RemoveCaracEspecial(mv_par03)
mv_par04 := u_RemoveCaracEspecial(mv_par04)

If !Empty(mv_par05) .And. Len(mv_par05) > 6
   mv_par05 := Right(mv_par05,6)
EndIf

If !Empty(mv_par06) .And. Len(mv_par06) > 6
   mv_par06 := Right(mv_par06,6)
EndIf                           

cQuery := "SELECT FILIAL                               "+CRLF //--Filial                         
cQuery += "      ,CODAVA                               "+CRLF //--Cod. Avaliação.                
cQuery += "      ,RD6_DESC AS DESAVA                   "+CRLF //--Desc.Avaliação.                
cQuery += "      ,DTIAVA                               "+CRLF //--Dt Inicio Avaliação            
cQuery += "      ,DTFAVA                               "+CRLF //--Dt Fim Avaliação.              
cQuery += "      ,CODPRO                               "+CRLF //--Cod. Projeto                   
cQuery += "      ,CODTIP                               "+CRLF //--Cod. Tipo Avaliação.           
cQuery += "      ,RD5_DESC AS DESTIP                   "+CRLF //--Desc. Tipo Avaliação.          
cQuery += "      ,CODMOD                               "+CRLF //--Cod. Modelo Avaliação.         
cQuery += "      ,RD3_DESC AS DESMOD                   "+CRLF //--Desc.Modelo Avaliação.         
cQuery += "      ,CODNET                               "+CRLF //--Cod. Rede                      
cQuery += "      ,RD1_DESC AS DESNET                   "+CRLF //--Desc. Rede                     
cQuery += "      ,TIPOAV                               "+CRLF //--Tipo Avaliador                 
cQuery += "      ,CODADO                               "+CRLF //--Cod.Avaliado.                  
cQuery += "      ,RD0_NOME   AS NOMADO                 "+CRLF //--Nome Avaliado.                 
cQuery += "      ,RA_CARGO   AS CODCRG                 "+CRLF //--Cod. Cargo Avaliado            
cQuery += "      ,Q3_DESCSUM AS DESCRG                 "+CRLF //--Des. Cargo Avaliado            
cQuery += "      ,RD0_CC     AS CODCCT                 "+CRLF //--Cod. Centro de Custo Avaliado. 
cQuery += "      ,CTT_DESC01 AS DESCCT                 "+CRLF //--Des. Centro de Custo Avaliado. 
cQuery += "      ,CODCOM                               "+CRLF //--Cod. Comptencia.               
cQuery += "      ,RDM_DESC   AS DESCOM                 "+CRLF //--Des. Comptencia.               
cQuery += "      ,ITECOM                               "+CRLF //--Cod. Item Competencia.         
cQuery += "      ,RD2_DESC   AS DESITE                 "+CRLF //--Desc. Item Competencia.        
cQuery += "      ,SUMESC  AS CONSENS                   "+CRLF //--Escala                         
cQuery += "      ,SUMITE  AS IMPACTO                   "+CRLF //--Grau de Importancia            
cQuery += "      ,SUMRES  AS GRORIEN                   "+CRLF //--Grau de Orientação             
cQuery += "      ,Round((SUMRES / SUMITE),2) AS MEDFIM "+CRLF //--Media Final           
cQuery += "FROM (SELECT FILIAL                 "+CRLF //--Filial                 
cQuery += "            ,CODAVA                 "+CRLF //--Cod. Avaliação.
cQuery += "            ,DTIAVA                 "+CRLF //--Dt Inicio Avaliação
cQuery += "            ,DTFAVA                 "+CRLF //--Dt Fim Avaliação.
cQuery += "            ,CODPRO                 "+CRLF //--Cod. Projeto
cQuery += "            ,CODTIP                 "+CRLF //--Cod. Tipo Avaliação.
cQuery += "            ,CODMOD                 "+CRLF //--Cod. Modelo Avaliação.
cQuery += "            ,CODNET                 "+CRLF //--Cod. Rede
cQuery += "            ,TIPOAV                 "+CRLF //--Tipo Avaliador
cQuery += "            ,CODADO                 "+CRLF //--Cod.Avaliado.
cQuery += "            ,CODCOM                 "+CRLF //--Cod. Comptencia.
cQuery += "            ,ITECOM                 "+CRLF //--Cod. Item Competencia.
cQuery += "            ,SUM(ESCALA ) AS SUMESC "+CRLF //--Escala
cQuery += "            ,SUM(ITEESC)  AS SUMITE "+CRLF //--Grau de Importancia
cQuery += "            ,SUM(RESOBT)  AS SUMRES "+CRLF //--Grau de Orientação
cQuery += "      FROM (SELECT DISTINCT RDD_FILIAL AS FILIAL            "+CRLF
cQuery += "                            ,RDD_CODAVA          AS CODAVA  "+CRLF
cQuery += "                            ,RDD_DTIAVA          AS DTIAVA  "+CRLF
cQuery += "                            ,RDD_DTFAVA          AS DTFAVA  "+CRLF
cQuery += "                            ,RDD_CODPRO          AS CODPRO  "+CRLF
cQuery += "                            ,RDD_CODTIP          AS CODTIP  "+CRLF
cQuery += "                            ,RDB_CODMOD          AS CODMOD  "+CRLF
cQuery += "                            ,RDD_CODNET          AS CODNET  "+CRLF
cQuery += "                            ,RDD_TIPOAV          AS TIPOAV  "+CRLF
cQuery += "                            ,RDD_CODADO          AS CODADO  "+CRLF
cQuery += "                            ,RDD_CODCOM          AS CODCOM  "+CRLF
cQuery += "                            ,RDD_ITECOM          AS ITECOM  "+CRLF
cQuery += "                            ,RDB_CODQUE          AS QUERDB  "+CRLF
cQuery += "                            ,RDB_CODALT          AS ALTRDB  "+CRLF
cQuery += "                            ,QO_QUESTAO          AS QUESQO  "+CRLF
cQuery += "                            ,RBL_VALOR           AS ESCALA  "+CRLF
cQuery += "                            ,RDO_ITEESC          AS ITEESC  "+CRLF
cQuery += "                            ,RDB_RESOBT          AS RESOBT  "+CRLF
cQuery += "                            ,RDB_ID              AS ID      "+CRLF
cQuery += "            FROM "+RetSqlName("RDD")+" RDD                             "+CRLF
cQuery += "            INNER JOIN "+RetSqlName("RDB")+"  RDB ON RDB_CODAVA = RDD_CODAVA  "+CRLF
cQuery += "                                          AND RDB_CODADO = RDD_CODADO  "+CRLF
cQuery += "                                          AND RDB_CODPRO = RDD_CODPRO  "+CRLF
cQuery += "                                          AND RDB_TIPOAV = RDD_TIPOAV  "+CRLF
cQuery += "                                          AND RDB_DTIAVA = RDD_DTIAVA  "+CRLF
cQuery += "                                          AND RDB_DTFAVA = RDD_DTFAVA  "+CRLF
cQuery += "                                          AND RDB_CODCOM = RDD_CODCOM  "+CRLF
cQuery += "                                          AND RDB_ITECOM = RDD_ITECOM  "+CRLF
cQuery += "                                          AND RDB_CODTIP = RDB_CODTIP  "+CRLF
cQuery += "                                          AND RDB_CODNET = RDB_CODNET  "+CRLF
cQuery += "            INNER JOIN "+RetSqlName("RDO")+"  RDO ON RDO_FILIAL = RDB_FILIAL  "+CRLF
cQuery += "                                          AND RDO_CODMOD = RDB_CODMOD  "+CRLF
cQuery += "                                          AND RDO_CODCOM = RDB_CODCOM  "+CRLF
cQuery += "                                          AND RDO_ITECOM = RDB_ITECOM  "+CRLF
cQuery += "            INNER JOIN "+RetSqlName("SQO")+" SQO ON QO_QUESTAO = RDB_CODQUE AND SQO.D_E_L_E_T_ <> '*'  "+CRLF
cQuery += "            INNER JOIN "+RetSqlName("RBL")+" RBL ON RBL_ESCALA = QO_ESCALA AND RBL_ITEM = RDB_CODALT AND RBL.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "            WHERE RDD.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "              AND RDB.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "              AND RDO.D_E_L_E_T_ <> '*' "+CRLF

cQuery += "              AND RDD_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "+CRLF
cQuery += "              AND RDD_CODAVA BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+CRLF
cQuery += "              AND RDD_CODADO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "+CRLF
cQuery += "              AND RDD_CODCOM BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "+CRLF
cQuery += "              AND RDD_ITECOM BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "+CRLF
cQuery += "              AND RDD_DTIAVA >= '"+DToS(mv_par12)+"' "+CRLF
cQuery += "              AND RDD_DTFAVA <= '"+DToS(mv_par13)+"' "+CRLF
                         
                         If mv_par11 = 1 // 1 - Com consenso / 2 - Sem consenso 
                            cQuery += "  AND RDD_TIPOAV = '3'                "+CRLF
                         ElseIf mv_par11 = 2
                            cQuery += "  AND RDD_TIPOAV = '2'                "+CRLF
                            cQuery += "  AND NOT EXISTS(SELECT 1 FROM "+RetSqlName("RDD")+" RDX "+CRLF
                            cQuery += "                 WHERE RDX.D_E_L_E_T_ <> '*'             "+CRLF
                            cQuery += "                   AND RDX.RDD_CODAVA = RDD.RDD_CODAVA   "+CRLF
                            cQuery += "                   AND RDX.RDD_CODADO = RDD.RDD_CODADO   "+CRLF
                           cQuery += "                   AND RDD_TIPOAV = '3')                 "+CRLF
                         EndIf
cQuery += "            ORDER BY RDD_FILIAL "+CRLF
cQuery += "                   , RDD_CODAVA "+CRLF
cQuery += "                   , RDD_DTIAVA "+CRLF
cQuery += "                   , RDD_DTFAVA "+CRLF
cQuery += "                   , RDD_CODPRO "+CRLF
cQuery += "                   , RDD_CODTIP "+CRLF
cQuery += "                   , RDB_CODMOD "+CRLF
cQuery += "                   , RDD_CODNET "+CRLF
cQuery += "                   , RDD_TIPOAV "+CRLF
cQuery += "                   , RDD_CODADO "+CRLF
cQuery += "                   , RDD_CODCOM "+CRLF
cQuery += "                   , RDD_ITECOM "+CRLF
cQuery += "                   , RDB_CODQUE "+CRLF
cQuery += "           )                    "+CRLF
cQuery += "      GROUP BY FILIAL, CODAVA, DTIAVA, DTFAVA, CODPRO, CODTIP, CODMOD, CODNET, TIPOAV, CODADO, CODCOM, ITECOM "+CRLF
cQuery += "      ORDER BY FILIAL, CODAVA, DTIAVA, DTFAVA, CODPRO, CODTIP, CODMOD, CODNET, TIPOAV, CODADO, CODCOM, ITECOM "+CRLF
cQuery += "    )                                                                                                         "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD6")+" RD6 ON RD6_CODIGO = CODAVA     AND RD6_CODTIP = CODTIP AND RD6.D_E_L_E_T_ <> '*'   "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD5")+" RD5 ON RD5_CODTIP = CODTIP     AND RD5.D_E_L_E_T_ <> '*'                           "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD3")+" RD3 ON RD3_CODIGO = CODMOD     AND RD3.D_E_L_E_T_ <> '*'                           "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD1")+" RD1 ON RD1_CODIGO = CODNET     AND RD1.D_E_L_E_T_ <> '*'                           "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD0")+" RD0 ON RD0_CODIGO = CODADO     AND RD0.D_E_L_E_T_ <> '*'                           "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RDZ")+" RDZ ON RDZ_CODRD0 = RD0_CODIGO AND RDZ.D_E_L_E_T_ <> '*'                           "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SRA")+" SRA ON RA_FILIAL  = SUBSTR(RDZ_CODENT,1,2) AND RA_MAT = SUBSTR(RDZ_CODENT,3,6) AND SRA.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SQ3")+" SQ3 ON Q3_CARGO   = RA_CARGO   AND SQ3.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT_CUSTO  = RD0_CC     AND CTT.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RDM")+" RDM ON RDM_CODIGO = CODCOM     AND RDM.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD2")+" RD2 ON RD2_CODIGO = CODCOM     AND RD2_ITEM = ITECOM AND RD2.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "ORDER BY FILIAL, CODAVA, DTIAVA, DTFAVA, CODPRO, CODMOD, CODADO, CODCOM, ITECOM "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),TRB)


//-> Realiza a limpeza da RD9 - Medias.
oReport:SetMeter( (TRB)->(RecCount()) )
While (TRB)->(!Eof()) 
     oReport:IncMeter()
     
     If Ascan(aChvRD9,{|x| x[01] = (TRB)->(CODAVA + CODADO + CODPRO + DTIAVA) } ) = 0
     
        If RD9->( Dbseek( xFilial("RDD") + (TRB)->(CODAVA + CODADO + CODPRO + DTIAVA)))
           RD9->( RecLock("RD9",.F.) )
           RD9->RD9_MEDFIN := 0
           RD9->( MsUnlock() )          
        EndIf
        
        AADD(aChvRD9,{(TRB)->(CODAVA + CODADO + CODPRO + DTIAVA)})
     EndIf
     
     (TRB)->( dbSkip() )
EndDo

(TRB)->(dbGoTop())

oReport:SetMeter( (TRB)->(RecCount()) )

cSect01 := "&&"
cSect02 := "&&"
cSect03 := "&&"
cSect04 := "&&"
While (TRB)->(!Eof()) 

      oReport:IncMeter()

      //- Seção 1 - Informações da Avaliação.      
      If (TRB)->(CODAVA + CODTIP + CODMOD) <> cSect01

         //- Seção 4 - Media Final
         If cSect04 <> "&&" .And. !Empty(aMedFim)
            //oSection3:Finish()  
            oSection4:Init()	        
            oSection4:PrintLine()              
            oSection4:Finish()  
         EndIf
         cSect04 := (TRB)->(CODADO)         

         oSection3:Finish()  
         oSection2:Finish()  
         oSection1:Finish()  

         oSection1:Init()	        
         oSection1:PrintLine()     
         cSect01 := (TRB)->(CODAVA + CODTIP + CODMOD)
      EndIf

      //- Seção 2 - Informações do Avaliado.
      If (TRB)->(CODADO)  <> cSect02
      
         If cSect04 <> (TRB)->(CODADO)
            //- Seção 4 - Media Final
            oSection4:Init()	        
            oSection4:PrintLine()       
            oSection4:Finish()         
         EndIf
         cSect04 := (TRB)->(CODADO)

         oSection3:Finish()  
         oSection2:Finish()  

         oSection2:Init()	        
         oSection2:PrintLine()     
                                                                       
         cSect02 := (TRB)->(CODADO)
      EndIf

      //- Seção 3 - Informações das Competencias Avaliadas.
      If (TRB)->(CODADO + CODCOM + ITECOM ) <> cSect03

         oSection3:Init()	        
         oSection3:PrintLine()     
         
         cSect03 := (TRB)->(CODADO + CODCOM + ITECOM )
         
      EndIf
      
    
      (TRB)->(DbSkip()) 
      
EndDo

//- Seção 4 - Media Final
oSection4:Init()	        
oSection4:PrintLine()    

oSection4:Finish()  
oSection3:Finish()  
oSection2:Finish()  


(TRB)->( dbCloseArea() )
                 
oReport:SkipLine()    
oReport:SkipLine() 
oReport:SkipLine()    
oReport:SkipLine() 
oReport:PrintText("Legenda: 0 a 1 = Critico || 1,01 a 1,59 = Abaixo do Esperado || 1,6 a 2,79 = Esperado || 2,8 a 3,69 = Acima do Esperado || 3,7 a 4 = Referencia")   
oReport:SkipLine()              

	
Return Nil



/*+---------------------+--------------------------------------------------------------+------------+
  | Programa.: APDCRT02 | Calcula Media Final por Avaliado e Gera Relatorio de Ranking | 13.02.2017 |
  +---------------------+--------------------------------------------------------------+------------+
  | Autor.: Alexandre Alves - CERTISIGN.                                                            |
  +-------------------------------------------------------------------------------------------------+
  | Manutenção.:                                                                       | Data.:     |
  +------------------------------------------------------------------------------------+------------+
*/
Static Function APDCT2X1()             

Local aRegs := {} 
Local cPerg := "APDCRT02"  
Local cHelp := " "
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Aadd(aRegs,{cPerg	,"01"	,"Filial De?"	   		,"¿De Sucursal ?"     		,"From Branch ?"			,"mv_ch1"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par01"	,""					,""					,""					,"RDD_FILIAL"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"XM0"	,"","S"	,{}			,{}			,{}			,cHelp})

aHelp := {	"Informe a Filial Inicial para o processamento do relatorio." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHFILIAL."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"02"	,"Filial Ate?"	   		,"¿Hasta Sucursal ?"     	,"To Branch ?"				,"mv_ch2"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par02"	,""					,""					,""					,"RDD_FILIAL"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"XM0"	,"","S"	,{}			,{}			,{}			,cHelp})

aHelp := {	"Informe a Filial Final para o processamento do relatorio." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHFILIAL."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"03"	,"Avaliacao De?"    	,"¿De Evaluacion ?"   		,"From Evaluation ?"	 	,"mv_ch3"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par03"	,""			   		,""					,""					,"RDD_CODAVA"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RD6"	,"","S"	,{}			,{}			,{}			,cHelp})

aHelp := {	"Informe a Avaliação Inicial para impressão do relatório" }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHAVALR."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"04"	,"Avaliacao Ate?"    	,"¿Hasta Evaluacion ?"   	,"To Evaluation ?"	 	   ,"mv_ch4"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par04"	,""			   		,""					,""					,"RDD_CODAVA"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RD6"	,"","S"	,{}			,{}			,{}			,cHelp})

aHelp := {	"Informe a Avaliação Final para impressão do relatório" }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHAVALR."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"05"	,"Avaliado De?"  		,"¿De Evaluado ?"     		,"From Evaluated ?"		 ,"mv_ch5"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par05"	,""					,""					,""					,"RDD_CODADO"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RD0"	,"","S"	,{}			,{}			,{}			,cHelp})              

aHelp := {	"Informe o Avaliado Inicial para a impressão do relatório." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHADO."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"06"	,"Avaliado Ate?"  		,"¿Hsta Evaluado ?"     	,"To Evaluated ?"		 ,"mv_ch6"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par06"	,""					,""					,""					,"RDD_CODADO"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RD0"	,"","S"	,{}			,{}			,{}			,cHelp})              

aHelp := {	"Informe o Avaliado Final para a impressão do relatório." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHADO."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"07"	,"Competencia De?"	,"¿De Competencia ?"			,"From Competence ?"	 ,"mv_ch7"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par07"	,""					,""					,""					,"RDD_CODCOM"		,""		,""			   		,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RDM"	,"","S"	,{}			,{}			,{}			,cHelp})              

aHelp := {	"Informe a competencia inicial para impressão do relatório." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHCOMP."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"08"	,"Competencia Ate?"	,"¿Hasta Competencia ?"			,"To Competence ?"	   ,"mv_ch8"  	,"C"	,99			,0		,0		,"R"	,""			    ,"mv_par08"	,""					,""					,""					,"RDD_CODCOM"		,""		,""			   		,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RDM"	,"","S"	,{}			,{}			,{}			,cHelp})              

aHelp := {	"Informe a competencia final para impressão do relatório." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHCOMP."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"09"	,"Item Competencia De?","¿De Item competencia ?"	,"From Competence Item ?"	,"mv_ch9"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par09"	,""					,""					,""					,"RDD_ITECOM"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RD2"	,"","S",{}			,{}			,{}			,cHelp})              

aHelp := {	"Informe o iten de competencia inicial para impressão do relatório." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHICOM."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"10"	,"Item Competencia Ate?","¿Hasta Item competencia ?"	,"To Competence Item ?"	,"mv_cha"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par10"	,""					,""					,""					,"RDD_ITECOM"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RD2"	,"","S",{}			,{}			,{}			,cHelp})              

aHelp := {	"Informe o iten de competencia final para impressão do relatório." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHICOM."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"11"	,"Tipos de Avaliações ?","¿ Tipos de Avaliações ?"	,"Tipos de Avaliações ?"	,"mv_chb"  	,"N"	,01			,0		,0	,"C"  ,""		,"mv_par11"	 ,"Com Consenso" ,""		,""		,"RDD_ITECOM"	,""		,"Sem Consenso"	,""		  ,""			,""			,""		,""			,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	    ,""     ,"S"    ,{}			,{}			,{}			,cHelp})              

aHelp := {	"Selecione os tipos de avaliações que deseja para a impressão do relatorio." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHTIPA."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"12"   ,"Dta. Inicio Aval. ?"  ,"¿Fecha Inicio Eval. ?"    ,"Start Date Eval. ?"       ,"mv_chc"  	,"D"	,08			,0		,0	,"G"  ,""		,"mv_par12"	 ,"" ,""		,""		,"RDD_DTIAVA"	,""		,""	,""		  ,""			,""			,""		,""			,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	    ,""     ,"S"    ,{}			,{}			,{}			,cHelp})              

aHelp := {	"Data de inicio das avaliações para filtro." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHDTVI."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Aadd(aRegs,{cPerg	,"13"   ,"Dta. Final Aval. ?"  ,"¿Fecha Final Eval. ?"    ,"End Date Eval. ?"          ,"mv_chd"  	,"D"	,08			,0		,0	,"G"  ,""		,"mv_par13"	 ,"" ,""		,""		,"RDD_DTFAVA"	,""		,""	,""		  ,""			,""			,""		,""			,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	    ,""     ,"S"    ,{}			,{}			,{}			,cHelp})              

aHelp := {	"Data final das avaliações para filtro." }
aHelpE:= {	" " }
aHelpI:= {	" " }

cHelp := ".RHDTVF."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ValidPerg(aRegs,cPerg)

Return Nil


/*+---------------------+-----------------------------------------------+------------+
  | Programa.: fCalMed()| Acumula valores para o calculo da Media Final.| 13.02.2017 |
  +---------------------+-----------------------------------------------+------------+
  | Autor.: Alexandre Alves - CERTISIGN.                                             |
  +---------------------------------------------------------------------+------------+
  | Manutenção.:                                                        | Data.:     |
  +---------------------------------------------------------------------+------------+
*/
Static Function fCalMed(oSection3)

   //.....................=/ Chave de pesquisa /............../ Grau de Impacto/../Grau de Orientação/
   AADD(aMedFim,{ (TRB)->(CODAVA + CODADO + CODPRO + DTIAVA), (TRB)->(IMPACTO), (TRB)->(GRORIEN) })
   
   oSection3:Cell("MEDFI2"):Hide()

Return()


/*+---------------------+-----------------------------------------------+------------+
  | Programa.: fCalMed()| Acumula valores para o calculo da Media Final.| 13.02.2017 |
  +---------------------+-----------------------------------------------+------------+
  | Autor.: Alexandre Alves - CERTISIGN.                                             |
  +---------------------------------------------------------------------+------------+
  | Manutenção.:                                                        | Data.:     |
  +---------------------------------------------------------------------+------------+
*/
Static Function fMedFim()

Local nVlrGri  := 0 //-> Grau de Impacto
Local nVlrGro  := 0 //-> Grau de Orientação
Local nVlrMed  := 0 //-> Media Final
Local nX       := 0  
Local aMedClon := AClone(aMedFim)

   
For nX := 1 To Len(aMedFim)//(Len(aMedFim)-1)
    nVlrGri += aMedFim[nX][02]
    nVlrGro += aMedFim[nX][03]
Next nX

nVlrMed := Round( (nVlrGro/nVlrGri), 2)

//-> Atualizando RD9 - Itens Avaliacoes x Avaliados, com a media final por Avaliado.
   RD9->(Dbsetorder(1))                            //-> Cod.Avaliação  + Cod.Avaliado    + Cod. Projeto    + Dt. Inicio Avaliação.
If RD9->(Dbseek(xFilial("RDD") + aMedFim[01][01])) //(TRB)->(CODAVA + CODADO + CODPRO + DTIAVA)))
   RD9->( RecLock("RD9",.F.) )
   RD9->RD9_MEDFIN := nVlrMed
   RD9->( MsUnlock() )     
EndIf      

aMedFim := {}

Return nVlrMed


/*
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
