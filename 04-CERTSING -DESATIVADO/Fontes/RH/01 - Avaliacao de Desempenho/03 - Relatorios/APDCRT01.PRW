#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*
+------------------+-----------------------------------+-----------------------+
|Funcao.: APDCRT01 | Autor.: Alexandre Alves           | Data.: 03/02/2017     |
+------------------+-----------------------------------+-----------------------+
|Descricao.: Planilha com Respostas Dissertativas das Avaliações.              |
+------------------------------------------------------------------------------+
*/
User Function APDCRT01()

Local bProcesso := {|oSelf| APDCTA01( oSelf )}

Private cCadastro  := "Respostas Dissertativas das Avalaições."
Private cDescricao := "Gera planilha com as respostas dissertativas das avaliações."
Private aLog1      := {} //-> Planilha com cenario dos colaboradors.
Private cPerg      := "APDCRT01"

APD01SX1(cPerg)
Pergunte(cPerg,.F.)

tNewProcess():New( "APDCRT01" , cCadastro , bProcesso , cDescricao ,cPerg ,,,,,.T.,.F. ) 	

//-> Gera planilha para conferencia.
fPlanLOG()

Return

/*
+------------------+-----------------------------------+-----------------------+
|Funcao.: APDCTA01 | Autor.: Alexandre Alves           | Data.: 03/02/2017     |
+------------------+-----------------------------------+-----------------------+
|Descricao.: Planilha com Respostas Dissertativas das Avaliações.              |
+------------------------------------------------------------------------------+

mv_par01 -> Avaliacao De ?
mv_par02 -> Avaliacao Ate ?
mv_par03 -> Avaliado De ?
mv_par04 -> Avaliado Ate ?
mv_par05 -> Dta. Inicio Aval. ?
mv_par06 -> Dta. Final Aval. ?
*/
Static Function APDCTA01(oSelf)

Local cQuery  := ""
Local cAlsMix := GetNextAlias()

//-> Tratamento dos perguntes.
mv_par01 := If(Empty(mv_par01), Space(TAMSX3("RDD_CODAVA")[1]), AllTrim(mv_par01))
mv_par02 := If(Empty(mv_par02),  AllTrim(Padr(mv_par02, TAMSX3("RDD_CODAVA")[1],'Z')), AllTRim(mv_par02))
mv_par03 := If(Empty(mv_par03), Space(TAMSX3("RDD_CODADO")[1]), AllTrim(mv_par03))
mv_par04 := If(Empty(mv_par04),  AllTrim(Padr(mv_par04, TAMSX3("RDD_CODADO")[1],'Z')), AllTrim(mv_par04))
mv_par05 := If(Empty(mv_par05), CToD("  /  /    "), mv_par05)                       
mv_par06 := If(Empty(mv_par06), CToD("30/01/"+Year(dDataBase)), mv_par06)                       

cQuery := "SELECT  RA_FILIAL     AS FILIAL "+CRLF  //-> Filia.
cQuery += "       ,RDD_CODAVA    AS CODAVA "+CRLF  //-> Cod. Avaliação.
cQuery += "       ,RD6_DESC      AS DESAVA "+CRLF  //-> Desc. Avaliação.
cQuery += "       ,RDD_CODTIP    AS TIPAVA "+CRLF  //-> Codigo Tipo de Avaliacao 
cQuery += "       ,RD5_DESC      AS DESTIP "+CRLF  //-> Desc. Tipo de Avaliacao 
cQuery += "       ,RD5_TIPO      AS CDTIPO "+CRLF  //-> Avaliacäo ou Pesquisa
cQuery += "       ,RD6_CODMOD    AS CODMOD "+CRLF  //-> Codigo Modelo Avaliacao  
cQuery += "       ,RD3_DESC      AS DESMOD "+CRLF  //-> Desc. Modelo Avaliacao  
cQuery += "       ,RD6_CODVIS    AS CODVIS "+CRLF  //-> Cod. Visao Padrao             
cQuery += "       ,RDK_DESC      AS DESVIS "+CRLF  //-> Desc. Visao Padrao             
cQuery += "       ,RD6_DTINI     AS DATINI "+CRLF  //-> Data Inicio da Avaliação
cQuery += "       ,RD6_DTFIM     AS DATFIM "+CRLF  //-> Data Final da Avaliação
cQuery += "       ,RDD_CODPRO    AS CDPROJ "+CRLF  //-> Codigo do Projeto        
cQuery += "       ,RDD_CODCOM    AS CDCOMP "+CRLF  //-> Codigo Competencia              
cQuery += "       ,RDM_DESC      AS DSCOMP "+CRLF  //-> Descricao Competencia    
cQuery += "       ,RD0_CODIGO    AS CODPAR "+CRLF  //-> Codigo Participante
cQuery += "       ,RD0_NOME      AS NOMPAR "+CRLF  //-> Nome Participante
cQuery += "       ,RD0_MAT       AS RD0MAT "+CRLF  //-> Matricula do Funcionario na RD0
cQuery += "       ,RA_MAT        AS SRAMAT "+CRLF  //-> Matricula do Funcionario na SRA
cQuery += "       ,RA_NOME       AS NOMPAR "+CRLF  //-> Nome do Funcionario na SRA
cQuery += "       ,RDD_CODNET    AS CODNET "+CRLF  //-> Codigo da Rede           
cQuery += "       ,RD1_DESC      AS DESNET "+CRLF  //-> Descricao da Rede        
cQuery += "       ,RDD_ITECOM    AS CDITAV "+CRLF  //-> Cod. Item da Competencia      
cQuery += "       ,RD2_DESC      AS DSITAV "+CRLF  //-> Des. Item da Competencia      
cQuery += "       ,RDB_TIPOAV    AS TPAVDO "+CRLF  //-> Tipo do Avaliador        
cQuery += "       ,RDB_ESCALA    AS ESCALA "+CRLF  //-> Codigo Escala/Importancia
cQuery += "       ,RDB_CODALT    AS CODALT "+CRLF  //-> Codigo da Alternativa    
cQuery += "       ,RDB_ITEESC    AS ITESCA "+CRLF  //-> Item Escala/Importancia  
cQuery += "       ,RDB_RESOBT    AS RESULT "+CRLF  //-> Resultado Obtido Questao 
cQuery += "       ,RDB_CODQUE    AS CDQUES "+CRLF  //-> Codigo da Questao        
cQuery += "       ,QO_QUES_      AS DSQUES "+CRLF  //-> Desc Questao             
cQuery += "       ,QO_ESCALA     AS ESCQUE "+CRLF  //-> Alternativa ( Escala )   
cQuery += "       ,RDB_CODMEM    AS CDMEMO "+CRLF  //-> Codigo MEMO da resposta.
cQuery += "       ,QO_PONTOS     AS PTOQUE "+CRLF  //-> Pontos da Questao        
cQuery += "       ,RDD_RESOBT    AS RSUOBT "+CRLF  //-> Resultado Obtido         
cQuery += "       ,RD9_MEDFIN    AS MEDFIN "+CRLF  //-> Media Final - Consenso   
cQuery += "       ,RDD_CODPRO    AS RDDPRJ "+CRLF  //-> Codigo do Projeto        
cQuery += "       ,RDN_DESC      AS DSCPRJ "+CRLF  //-> Descricao do Projeto     
cQuery += "       ,RDN_DTIPRO    AS DTIPRJ "+CRLF  //-> Data Inicial do Projeto
cQuery += "       ,RDN_DTFPRO    AS DTFPRJ "+CRLF  //-> Data Final do Projeto               
cQuery += "       ,NOMITVS       AS NMITVS "+CRLF  //-> Nome do Item de Visão.
cQuery += "       ,DSNVSUP       AS DSNVSP "+CRLF  //-> Nome do Item de Visão Superior.
cQuery += "FROM "+RetSqlName("RDD")+" RDD "+CRLF
cQuery += "LEFT OUTER JOIN "+RetSqlName("RDN")+" RDN ON RDD_CODPRO = RDN_CODIGO AND RDN.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD6")+" RD6 ON RD6_CODIGO = RDD_CODAVA AND RD6_CODTIP = RDD_CODTIP    "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD5")+" RD5 ON RD5_CODTIP = RDD_CODTIP                                "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD3")+" RD3 ON RD3_CODIGO = RD6_CODMOD                                "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RDK")+" RDK ON RDK_CODIGO = RD6_CODVIS                                "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD0")+" RD0 ON RD0_CODIGO = RDD_CODADO                                "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RDZ")+" RDZ ON RDZ_CODRD0 = RD0_CODIGO                                "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SRA")+" SRA ON RA_FILIAL  = SUBSTR(RDZ_CODENT,1,2) AND RA_MAT = SUBSTR(RDZ_CODENT,3,6) "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD9")+" RD9 ON RD9_CODAVA = RDD_CODAVA AND RD9_CODADO = RDD_CODADO                     "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RDM")+" RDM ON RDM_CODIGO = RDD_CODCOM                                                 "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD2")+" RD2 ON RD2_CODIGO = RDD_CODCOM AND RD2_ITEM = RDD_ITECOM                       "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RD1")+" RD1 ON RD1_CODIGO = RDD_CODNET                                                 "+CRLF
cQuery += "INNER JOIN "+RetSqlName("RDB")+" RDB ON RDB_CODAVA = RDD_CODAVA AND RDB_CODADO = RDD_CODADO AND RDB_CODCOM = RDD_CODCOM AND RDB_ITECOM = RDD_ITECOM "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SQO")+" SQO ON QO_QUESTAO = RDB_CODQUE "+CRLF
cQuery += "INNER JOIN ("+CRLF
cQuery += " SELECT TMP.*, RD4_DESC AS DSNVSUP FROM "+RetSqlName("RD4")+" RD4,"+CRLF
cQuery += " (SELECT RDE_CODPAR AS CODPAR,"+CRLF
cQuery += "        (SELECT RD0_NOME FROM "+RetSqlName("RD0")+"  WHERE D_E_L_E_T_ <> '*' AND RD0_CODIGO = RDE_CODPAR) NOMPAR,"+CRLF
cQuery += "         RDE_CODVIS AS CODVIS,"+CRLF
cQuery += "        (SELECT SUBSTR(RDK_DESC,1,LENGTH(RDK_DESC)) FROM "+RetSqlName("RDK")+" WHERE D_E_L_E_T_ <> '*' AND RDK_CODIGO = RDE_CODVIS) NOMVIS,"+CRLF
cQuery += "         RDE_ITEVIS AS ITEVIS,"+CRLF
cQuery += "        (SELECT RD4_DESC FROM "+RetSqlName("RD4")+"  WHERE D_E_L_E_T_ <> '*' AND RD4_CODIGO = RDE_CODVIS AND RD4_ITEM = RDE_ITEVIS) NOMITVS,"+CRLF
cQuery += "        (SELECT RD4_TREE FROM "+RetSqlName("RD4")+"  WHERE D_E_L_E_T_ <> '*' AND RD4_CODIGO = RDE_CODVIS AND RD4_ITEM = RDE_ITEVIS) NIVSUP,"+CRLF
cQuery += "         RDE_DATA   AS DATA,"+CRLF
cQuery += "         RDE_STATUS AS STATUS "+CRLF
cQuery += "  FROM "+RetSqlName("RDE")+" RDE "+CRLF
cQuery += "  WHERE RDE.D_E_L_E_T_ <> '*' AND RDE_STATUS = '1' "+CRLF
cQuery += " ) TMP "+CRLF
cQuery += " WHERE RD4.D_E_L_E_T_ <> '*' AND RD4_CODIGO = TMP.CODVIS AND RD4_ITEM = TMP.NIVSUP "+CRLF
cQuery += ") QRYVIS ON QRYVIS.CODPAR = RDD_CODADO AND QRYVIS.CODVIS = RD6_CODVIS "+CRLF
cQuery += "  AND RDD.D_E_L_E_T_ <> '*' "+CRLF
cQuery += "  AND RD6.D_E_L_E_T_ <> '*' "+CRLF
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
cQuery += "  AND RDD_CODAVA BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "+CRLF
cQuery += "  AND RDD_CODADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "+CRLF
cQuery += "  AND RDD_DTIAVA >= '"+DToS(mv_par05)+"' "+CRLF
cQuery += "  AND RDD_DTFAVA <= '"+DToS(mv_par06)+"' "+CRLF
cQuery += "  AND QO_TIPOOBJ = '3' "+CRLF //-> Somente questões do tipo Dissertativa.
cQuery += "  AND RDB_TIPOAV = '3' "+CRLF //-> Somente respostas com consenso.
cQuery += "ORDER BY RA_FILIAL, RDD_CODAVA, RDD_CODADO, RDD_ITECOM, RDB_TIPOAV, RD0_CODIGO, RDB_CODQUE "+CRLF
  
cQuery := ChangeQuery(cQuery)
 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlsMix)

(cAlsMix)->(dbGoTop())

oSelf:SetRegua1( (cAlsMix)->(RecCount()) )

While (cAlsMix)->(!Eof()) 

       oSelf:IncRegua1( "Processando REGISTRO..."+(cAlsMix)->(FILIAL+" - "+SRAMAT+" - "+NOMPAR)+" .Aguarde.")
       If oSelf:lEnd 
          Break
       EndIf 

       cTextMen := " "       
       
             RDY->( dbSeek(xFilial("RDY")+(cAlsMix)->CDMEMO+"001") ) //Indice 1 = RDY_FILIAL+RDY_CHAVE+RDY_SEQ
       While RDY->( !EOF() ) .And. RDY->(RDY_FILIAL+RDY_CHAVE) = (xFilial("RDY")+(cAlsMix)->CDMEMO) .And. RDY->RDY_CAMPO = "RDB_CODMEM"
       
             cTextMen += AllTrim(RDY->RDY_TEXTO)
             RDY->( dbSkip() )
       EndDo

       
       If Empty(aLog1)
       
          AADD(aLog1,{"FILIAL",;  //-> Filial.
                      "CODAVA",;  //-> Cod. Avaliação.
                      "DESAVA",;  //-> Desc. Avaliação.
                      "TIPAVA",;  //-> Codigo Tipo de Avaliacao 
                      "DESTIP",;  //-> Desc. Tipo de Avaliacao 
                      "CDTIPO",;  //-> Avaliacäo ou Pesquisa
                      "CODMOD",;  //-> Codigo Modelo Avaliacao  
                      "DESMOD",;  //-> Desc. Modelo Avaliacao  
                      "CODVIS",;  //-> Cod. Visao Padrao             
                      "DESVIS",;  //-> Desc. Visao Padrao             
                      "CDCOMP",;  //-> Codigo Competencia              
                      "DSCOMP",;  //-> Descricao Competencia    
                      "CODPAR",;  //-> Codigo Participante
                      "NOMPAR",;  //-> Nome Participante
                      "CODNET",;  //-> Codigo da Rede           
                      "DESNET",;  //-> Descricao da Rede        
                      "CDITAV",;  //-> Cod. Item da Competencia      
                      "DSITAV",;  //-> Des. Item da Competencia      
                      "CDQUES",;  //-> Codigo da Questao        
                      "DSQUES",;  //-> Desc Questao             
                      "NMITVS",;  //-> Nome do Item de Visão.
                      "DSNVSP",;   //-> Nome do Item de Visão Superior.
                      "Respos";    //-> Texto da resposta.
                     };
              )
       EndIf

       AADD(aLog1,{(cAlsMix)->FILIAL,;  //-> Filia.
                   (cAlsMix)->CODAVA,;  //-> Cod. Avaliação.
                   (cAlsMix)->DESAVA,;  //-> Desc. Avaliação.
                   (cAlsMix)->TIPAVA,;  //-> Codigo Tipo de Avaliacao 
                   (cAlsMix)->DESTIP,;  //-> Desc. Tipo de Avaliacao 
                   (cAlsMix)->CDTIPO,;  //-> Avaliacäo ou Pesquisa
                   (cAlsMix)->CODMOD,;  //-> Codigo Modelo Avaliacao  
                   (cAlsMix)->DESMOD,;  //-> Desc. Modelo Avaliacao  
                   (cAlsMix)->CODVIS,;  //-> Cod. Visao Padrao             
                   (cAlsMix)->DESVIS,;  //-> Desc. Visao Padrao             
                   (cAlsMix)->CDCOMP,;  //-> Codigo Competencia              
                   (cAlsMix)->DSCOMP,;  //-> Descricao Competencia    
                   (cAlsMix)->CODPAR,;  //-> Codigo Participante
                   (cAlsMix)->NOMPAR,;  //-> Nome Participante
                   (cAlsMix)->CODNET,;  //-> Codigo da Rede           
                   (cAlsMix)->DESNET,;  //-> Descricao da Rede        
                   (cAlsMix)->CDITAV,;  //-> Cod. Item da Competencia      
                   (cAlsMix)->DSITAV,;  //-> Des. Item da Competencia      
                   (cAlsMix)->CDQUES,;  //-> Codigo da Questao        
                   (cAlsMix)->DSQUES,;  //-> Desc Questao             
                   (cAlsMix)->NMITVS,;  //-> Nome do Item de Visão.
                   (cAlsMix)->DSNVSP,;   //-> Nome do Item de Visão Superior.
                   cTextMen;             //-> Resposta.
                   };
             )
             
        
       (cAlsMix)->( dbSkip() ) 
EndDo

Return

/*
+--------------------+-----------------------------------+-----------------------+
|Funcao.: fPlanLOG   | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+--------------------+-----------------------------------+-----------------------+
|Descricao.: Funcao auxiliar para geracao de planilha de conferencia do calculo. |
+--------------------------------------------------------------------------------+
*/
Static Function fPlanLOG()

Local lSetCentury := __SetCentury( "on" )
Local cPath       := AllTrim( GetTempPath() )
Local nTotReg     := 0
Local cNomArq1    := ""

Local cLin1
Local nPos, nX, nY

Local lErrInc   := .F.
Local lErrExc   := .F.

Private nHdl1

If !Empty(aLog1)
   cNomArq1  := CriaTrab(,.F.) + ".CSV"

   //Cria Arquivo Texto
   cPath    := cPath + If(Right(cPath,1) <> "\","\","")
   cNomArq1 := cPath + cNomArq1

   nHdl1     := fCreate( cNomArq1 )

   If nHdl1 == -1
      MsgAlert("O arquivo de nome "+cNomArq1+" nao pode ser executado! Verifique os parametros.","Atencao!")
      Return
   EndIf

   //---------------------------------------------------------------------------------

   //-> Gravando Cabecalho Log1.
   For nX := 1 To Len(aLog1[1]) 
    If nX = 1
       cLin1 := aLog1[1][nX] + cSep
    Else
       cLin1 += aLog1[1][nX] + cSep
    EndIf
   Next 
   cLin1 += cEol

   If fWrite(nHdl1,cLin1,Len(cLin1)) != Len(cLin1)
      If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
         Return
      Endif
   Endif

   //---------------------------------------------------------------------------------

   //-> Gravando Dados do Log1.

   ProcRegua( Len(aLog1) )    

   For nX := 2 To Len(aLog1)

	IncProc(OemToAnsi("Carregando dados para a planilha.Lendo registro..: ")+AllTrim(Str(nX))+" - "+ AllTrim( Str(Len(aLog1) ) )+" .Aguarde.")
    
    For nY := 1 To Len(aLog1[nX])
        If nY = 1
           cLin1 := If( ValType( aLog1[nX][nY] ) = "N", AllTrim( Str(aLog1[nX][nY]) ), aLog1[nX][nY] ) + cSep
        Else 
           cLin1 += If( ValType( aLog1[nX][nY] ) = "N", AllTrim( Str(aLog1[nX][nY]) ), aLog1[nX][nY] ) + cSep
        EndIf
    Next nY
    cLin1 += cEol
    
    If fWrite(nHdl1,cLin1,Len(cLin1)) != Len(cLin1)
       If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
          Return
       Endif
    Endif

   Next nX

   //--------------------------------------------------------------------------------- 

   If !lSetCentury
      __SetCentury( "off" )
   EndIf

   fClose( nHdl1 )

   //Integra Planilha 1 ao Excel
   MsAguarde( {|| fStartExcel( cNomArq1 )}, "Aguarde...", "Integrando Planilha ao Excel..." )

EndIf

Return

/*
+---------------------+-----------------------------------+-----------------------+
|Funcao.: fStartExcel | Autor.: Alexandre Alves           | Data.: 06/06/2016     |
+---------------------+-----------------------------------+-----------------------+
|Descricao.: Integra os dados gerados com uma planilha no Excel.                  |
+---------------------------------------------------------------------------------+
*/
Static Function fStartExcel( cNomeArq )

 If !ApOleClient( 'MsExcel' )
    MsgAlert( 'MsExcel nao instalado' )
 Else
    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open( cNomeArq ) // Abre uma planilha
    oExcelApp:SetVisible(.T.)
    oExcelApp:Destroy()
 EndIf

Return


/*----------+----------------------------+------------+-----------------------------+
 |APD01SX1  | Monta Perguntas da Rotina. | 14.01.2017 | Alexandre Alves - CERTISIGN |
 +----------+----------------------------+------------+-----------------------------+
*/
Static Function APD01SX1(cPerg)

Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
PutSX1(cPerg,"01","Avaliacao De ?"         ,"¿De Evaluacion ?"      ,"From evaluation ?"       ,"mv_ch1" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RD6",""   ,""     ,"mv_par01","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliacao inicial para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0001.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"02","Avaliacao Ate ?"        ,"¿Hasta Evaluacion ?"    ,"To evaluation ?"        ,"mv_ch2" ,"C" ,06     ,0      ,0    ,"G" ,""	,"RD6",""   ,""     ,"mv_par02","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliação final para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0002.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"03","Avaliado De ?"       ,"¿De Evaluado ?"    ,"From evaluated ?"    ,"mv_ch3" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RD0",""   ,""		,"mv_par03","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliado inicial para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0003.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"04","Avaliado Ate ?"      ,"¿Hasta Evaluado ?"  ,"To evaluated ?"      ,"mv_ch4" ,"C" ,06     ,0      ,0    ,"G" ,""   ,"RD0",""   ,""		,"mv_par04","","","","","","","","","","","","","","","","")

aHelp := {	"Avaliado final para o processamento." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0004.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"05","Dta. Inicio Aval. ?"  ,"¿Fecha Inicio Eval. ?","Start Date Eval. ?"   ,"mv_ch5" ,"D" ,08     ,0      ,0    ,"G" ,""   ,""   ,""   ,""	    ,"mv_par05",""    ,""      ,""      ,""   ,""    ,""      ,""      ,"","","","","","","","","")

aHelp := {	"Data de inicio das avaliações para filtro." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0005.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PutSX1(cPerg,"06","Dta. Final Aval. ?"   ,"¿Fecha Fim Eval. ?"   ,"End Date Eval. ?"	    ,"mv_ch6" ,"D" ,08     ,0      ,0    ,"G" ,""   ,""   ,""   ,""     ,"mv_par06",""    ,""      ,""      ,""   ,""    ,""      ,""      ,"","","","","","","","","")

aHelp := {	"Data final das avaliações para filtro." }
aHelpE:= {	" " }
aHelpI:= {	" " }

PutSX1Help("P.CSAD0006.",aHelp,aHelpI,aHelpE)	 
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Return