#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*
+-----------------------+-----------------------------+---------------------+
|Programa.:   CTPONX02  | Autor.: Alexandre AS.       | Data.: 13/06/2018   |
+-----------------------+-----------------------------+---------------------+
|Descricao.: Gera CSV com Visão dos Funcionarios por Nivel de Aprovação.    |
+---------------------------------------------------------------------------+
*/
User Function CTPONX02()

Local bProcesso := {|oSelf| fProcessa( oSelf )}

Private cCadastro  := "Planilha com Informações de Colaboradores, Grupos de Aprovação e Aprovadores."
Private cStartPath := GetSrvProfString("StartPath","")
Private cDescricao := "Esta rotina irá gerar arquivo Excel com informações de Funcionários, Grupos de Aprovação e Aprovadores."

tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao ,,,,,,.T.,.F. ) 	

Return

/*
+---------------------------------------------------------------------------+
|Funcao.: fProcessa  | Autor.: Alexandre Alves          | Data.: 06/06/2016 |
+--------------------+----------------------------------+-------------------+
|Descricao.: Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA      |
|            monta a janela com a regua de processamento.                   |
+---------------------------------------------------------------------------+

*/
Static Function fProcessa( oSelf )

Local lSetCentury := __SetCentury( "on" )
Local cPath       := AllTrim( GetTempPath() )
Local nTotReg     := 0
Local cNomeArq    := ""

Local cLin
Local nPos, nX
Local aParamBox := {}

Local lErrInc   := .F.
Local lErrExc   := .F.

Private nHdl
Private aRet       := {}

//              1 - MsGet  [2] : Descrição  [3]    : String contendo o inicializador do campo  [4] : String contendo a Picture do campo  [5] : String contendo a validação  [6] : Consulta F3  [7] : String contendo a validação When   [8] : Tamanho do MsGet   [9] : Flag .T./.F. Parâmetro Obrigatório ? 
aAdd(aParamBox,{1              ,"Filial Inicial"   ,Space(02)                                  ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.F.}) // Filial Inicial
aAdd(aParamBox,{1              ,"Filial Final"     ,Replicate("Z",02)                          ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.T.}) // Filial Inicial
aAdd(aParamBox,{1              ,"Periodo Inicial"  ,CToD("  /  /    ")                         ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,10                      ,.T.}) // Periodo Inicial
aAdd(aParamBox,{1              ,"Periodo Final"    ,CToD("  /  /    ")                         ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,10                      ,.T.}) // Periodo Final

If !(Parambox(aParambox,"Parametros de Processamento",@aRet))
   Return
EndIf

cNomeArq  := CriaTrab(,.F.) + ".CSV"

// Cria Arquivo Texto
cPath    := cPath + If(Right(cPath,1) <> "\","\","")
cNomeArq := cPath + cNomeArq
nHdl     := fCreate( cNomeArq )

If nHdl == -1
   MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
   Return
EndIf

SRA->(dbSetOrder( 1 ))

// Monta Query Principal
MsAguarde( {|| fMtaQuery()}, "Processando...", "Selecionado Registros no Banco de Dados..." )

dbSelectArea( "WFUN" )
Count To nTotReg
If nTotReg <= 0
   Aviso("ATENCAO","Nao Existem Dados para Este Relatorio",{"Sair"})
   Return
EndIf

dbGoTop()
oSelf:SetRegua1( RecCount() )

// Grava Cabecalho do Arquivo Texto
fGrvCab()

Do While !Eof()
   oSelf:IncRegua1( WFUN->(FILIAL + " - " + MATRICULA + " - " + NOME) )
   If oSelf:lEnd 
      Break
   EndIf
   
   SRA->(dbSeek( WFUN->(FILIAL + MATRICULA) ))
   
   cLin := '="' + WFUN->NV1_APROV + '"'        + cSep  //-> Codigo de Participante do Aprovador de Nivel 1.
   cLin +=        WFUN->NV1_NOME_APROVADOR     + cSep  //-> Nome do Aprovador de Nivel 1.                  
   cLin += '="' + WFUN->NV2_APROV + '"'        + cSep  //-> Codigo de Participante do Aprovador de Nivel 2.
   cLin +=        WFUN->NV2_NOME_APROVADOR     + cSep  //-> Nome do Aprovador de Nivel 2.                  
   cLin += '="' + WFUN->NV3_APROV + '"'        + cSep  //-> Codigo de Participante do Aprovador de Nivel 3.
   cLin +=        WFUN->NV3_NOME_APROVADOR     + cSep  //-> Nome do Aprovador de Nivel 3.                  
   cLin += '="' + WFUN->NV4_APROV + '"'        + cSep  //-> Codigo de Participante do Aprovador de Nivel 4.
   cLin +=        WFUN->NV4_NOME_APROVADOR     + cSep  //-> Nome do Aprovador de Nivel 4.                  
   cLin += '="' + WFUN->FILIAL    + '"'        + cSep  //-> Filial.                                        
   cLin +=        WFUN->COD_CUSTO              + cSep  //-> Codigo Centro de Custo.                        
   cLin += '="' + WFUN->MATRICULA + '"'        + cSep  //-> Matricula Funcionario.                         
   cLin +=        WFUN->NOME                   + cSep  //-> Nome Funcionario.                              
   cLin +=        WFUN->SITUACAO               + cSep  //-> Situação do Funcionario na Folha.              
   cLin +=        WFUN->( DToC(ADMISSAO) )     + cSep  //-> Data de Admissão.                              
   cLin +=        WFUN->( DToC(DEMISSAO) )     + cSep  //-> Data de Demissão.                              
   cLin +=        WFUN->( Str(QTD_MARCACOES) ) + cSep  //-> Quantidade de Marcações Existentes no Ponto.   
   cLin += '="' + WFUN->GRUPO     + '"'        + cSep  //-> Quantidade de Marcações Existentes no Ponto.
   cLin += cEol
   fGravaTxt( cLin )
   dbSkip()
EndDo 

If !lSetCentury
   __SetCentury( "off" )
EndIf

WFUN->(dbCloseArea())  
fClose( nHdl )

// Integra Planilha ao Excel
MsAguarde( {|| fStartExcel( cNomeArq )}, "Aguarde...", "Integrando Planilha ao Excel..." )



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGPEM02   ºAutor  ³Microsiga           º Data ³  01/25/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fGravaTxt( cLin )

 If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
    If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
       Return
    Endif
 Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GPCNF01  ºAutor  ³Microsiga           º Data ³  12/13/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fGrvCab()

Local cLin
 
cLin := "NV1_APROV"          + cSep //-> Codigo de Participante do Aprovador de Nivel 1.
cLin += "NV1_NOME_APROVADOR" + cSep //-> Nome do Aprovador de Nivel 1.
cLin += "NV2_APROV"          + cSep //-> Codigo de Participante do Aprovador de Nivel 2.
cLin += "NV2_NOME_APROVADOR" + cSep //-> Nome do Aprovador de Nivel 2.
cLin += "NV3_APROV"          + cSep //-> Codigo de Participante do Aprovador de Nivel 3.
cLin += "NV3_NOME_APROVADOR" + cSep //-> Nome do Aprovador de Nivel 3.
cLin += "NV4_APROV"          + cSep //-> Codigo de Participante do Aprovador de Nivel 4.
cLin += "NV4_NOME_APROVADOR" + cSep //-> Nome do Aprovador de Nivel 4.
cLin += "FILIAL"             + cSep //-> Filial.
cLin += "COD_CUSTO"          + cSep //-> Codigo Centro de Custo.
cLin += "MATRICULA"          + cSep //-> Matricula Funcionario.
cLin += "NOME"               + cSep //-> Nome Funcionario.
cLin += "SITUACAO"           + cSep //-> Situação do Funcionario na Folha.
cLin += "ADMISSAO"           + cSep //-> Data de Admissão.
cLin += "DEMISSAO"           + cSep //-> Data de Demissão.
cLin += "QTD_MARCACOES"      + cSep //-> Quantidade de Marcações Existentes no Ponto.
cLin += "GRUPO"              + cSep //-> Grupo de Aprovação do Funcionario.
cLin += cEol
fGravaTxt( cLin )
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GPCNF01  ºAutor  ³Microsiga           º Data ³  12/26/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TLGPEM23  ºAutor  ³Microsiga           º Data ³  04/26/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fMtaQuery()

Local nX       := 0
Local cQuery   := ""

//-> Visão dos Funcionarios por Nivel de Aprovação.

cQuery := "SELECT NV1_APROV                                                "+CRLF
cQuery += "     , NV1_NOME_APROVADOR                                       "+CRLF
cQuery += "     , NV2_APROV                                                "+CRLF
cQuery += "     , NV2_NOME_APROVADOR                                       "+CRLF
cQuery += "     , NV3_APROV                                                "+CRLF
cQuery += "     , NV3_NOME_APROVADOR                                       "+CRLF
cQuery += "     , NV4_APROV                                                "+CRLF
cQuery += "     , NV4_NOME_APROVADOR                                       "+CRLF
cQuery += "     , FUN.*                                                    "+CRLF
cQuery += "FROM (                                                          "+CRLF
cQuery += "       SELECT RA_FILIAL   AS FILIAL                             "+CRLF
cQuery += "            , RA_CC       AS COD_CUSTO                          "+CRLF
cQuery += "            , RA_MAT      AS MATRICULA                          "+CRLF
cQuery += "            , RA_NOME     AS NOME                               "+CRLF
cQuery += "            , RA_SITFOLH  AS SITUACAO                           "+CRLF
cQuery += "            , RA_ADMISSA  AS ADMISSAO                           "+CRLF
cQuery += "            , RA_DEMISSA  AS DEMISSAO                           "+CRLF
cQuery += "            , (                                                 "+CRLF
cQuery += "               SELECT COUNT (*)                                 "+CRLF
cQuery += "               FROM "+RetSqlName("SP8")+"                       "+CRLF
cQuery += "               WHERE D_E_L_E_T_ <> '*'                          "+CRLF
cQuery += "                 AND P8_FILIAL = RA_FILIAL                      "+CRLF
cQuery += "                 AND P8_MAT    = RA_MAT                         "+CRLF
cQuery += "                 AND P8_DATA BETWEEN '"+DToS(aRet[3])+"' AND '"+DToS(aRet[4])+"'  "+CRLF
cQuery += "               )          AS QTD_MARCACOES                      "+CRLF
cQuery += "            , RD0_GRPAPV  AS GRUPO                              "+CRLF
cQuery += "       FROM "+RetSqlName("SRA")+" SRA                           "+CRLF
cQuery += "       RIGHT JOIN "+RetSqlName("RDZ")+" RDZ ON SUBSTR(RDZ_CODENT,1,2) = RA_FILIAL AND SUBSTR(RDZ_CODENT,3,6) = RA_MAT "+CRLF
cQuery += "       INNER JOIN "+RetSqlName("RD0")+" RD0 ON RD0_CODIGO = RDZ_CODRD0         "+CRLF
cQuery += "       WHERE SRA.D_E_L_E_T_ <> '*'                                             "+CRLF
cQuery += "         AND RDZ.D_E_L_E_T_ <> '*'                                             "+CRLF
cQuery += "         AND RD0.D_E_L_E_T_ <> '*'                                             "+CRLF
cQuery += "         AND RA_FILIAL BETWEEN '"+aRet[1]+"' AND '"+aRet[2]+"'                 "+CRLF
cQuery += "         AND (RA_DEMISSA = ' ' OR RA_DEMISSA > '"+DToS(aRet[3])+"')            "+CRLF
cQuery += "         AND RA_REGRA <> '99'                                                  "+CRLF
cQuery += "     ) FUN                                                                     "+CRLF
cQuery += "                                                                               "+CRLF
cQuery += "LEFT JOIN (                                                                    "+CRLF
cQuery += "            SELECT PBD_GRUPO   AS NV1_GRUPO                                    "+CRLF
cQuery += "                 , PBD_APROV   AS NV1_APROV                                    "+CRLF
cQuery += "                 , RD0_NOME    AS NV1_NOME_APROVADOR                           "+CRLF
cQuery += "            FROM "+RetSqlName("PBD")+" PBD                                     "+CRLF
cQuery += "            INNER JOIN "+RetSqlName("RD0")+" RD0 ON RD0_CODIGO = PBD_APROV     "+CRLF
cQuery += "            WHERE PBD.D_E_L_E_T_ <> '*'                                        "+CRLF
cQuery += "              AND RD0.D_E_L_E_T_ <> '*'                                        "+CRLF
cQuery += "              AND PBD_NIVEL = '1'                                              "+CRLF
cQuery += "              AND PBD_STATUS = '1'                                             "+CRLF
cQuery += "            )                                                                  "+CRLF
cQuery += "NIVEL1 ON NV1_GRUPO = FUN.GRUPO                                                "+CRLF
cQuery += "                                                                               "+CRLF
cQuery += "LEFT JOIN(                                                                     "+CRLF
cQuery += "           SELECT PBD_GRUPO   AS NV2_GRUPO                                     "+CRLF
cQuery += "                , PBD_APROV   AS NV2_APROV                                     "+CRLF
cQuery += "                , RD0_NOME    AS NV2_NOME_APROVADOR                            "+CRLF
cQuery += "           FROM "+RetSqlName("PBD")+" PBD                                      "+CRLF
cQuery += "           INNER JOIN "+RetSqlName("RD0")+" RD0 ON RD0_CODIGO = PBD_APROV      "+CRLF
cQuery += "           WHERE PBD.D_E_L_E_T_ <> '*'                                         "+CRLF
cQuery += "             AND RD0.D_E_L_E_T_ <> '*'                                         "+CRLF
cQuery += "             AND PBD_NIVEL = '2'                                               "+CRLF
cQuery += "             AND PBD_STATUS = '1'                                              "+CRLF
cQuery += "          )                                                                    "+CRLF
cQuery += "NIVEL2 ON NV2_GRUPO = FUN.GRUPO                                                "+CRLF
cQuery += "                                                                               "+CRLF
cQuery += "LEFT JOIN(                                                                     "+CRLF
cQuery += "           SELECT PBD_GRUPO   AS NV3_GRUPO                                     "+CRLF
cQuery += "                , PBD_APROV   AS NV3_APROV                                     "+CRLF
cQuery += "                , RD0_NOME    AS NV3_NOME_APROVADOR                            "+CRLF
cQuery += "           FROM "+RetSqlName("PBD")+" PBD                                      "+CRLF
cQuery += "           INNER JOIN "+RetSqlName("RD0")+" RD0 ON RD0_CODIGO = PBD_APROV      "+CRLF
cQuery += "           WHERE PBD.D_E_L_E_T_ <> '*'                                         "+CRLF
cQuery += "             AND RD0.D_E_L_E_T_ <> '*'                                         "+CRLF
cQuery += "             AND PBD_NIVEL = '3'                                               "+CRLF
cQuery += "             AND PBD_STATUS = '1'                                              "+CRLF
cQuery += "          )                                                                    "+CRLF
cQuery += "NIVEL3 ON NV3_GRUPO = FUN.GRUPO                                                "+CRLF
cQuery += "                                                                               "+CRLF
cQuery += "LEFT JOIN(                                                                     "+CRLF
cQuery += "           SELECT PBD_GRUPO   AS NV4_GRUPO                                     "+CRLF
cQuery += "                , PBD_APROV   AS NV4_APROV                                     "+CRLF
cQuery += "                , RD0_NOME    AS NV4_NOME_APROVADOR                            "+CRLF
cQuery += "           FROM "+RetSqlName("PBD")+" PBD                                      "+CRLF
cQuery += "           INNER JOIN "+RetSqlName("RD0")+" RD0 ON RD0_CODIGO = PBD_APROV      "+CRLF
cQuery += "           WHERE PBD.D_E_L_E_T_ <> '*'                                         "+CRLF
cQuery += "             AND RD0.D_E_L_E_T_ <> '*'                                         "+CRLF
cQuery += "             AND PBD_NIVEL = '4'                                               "+CRLF
cQuery += "             AND PBD_STATUS = '1'                                              "+CRLF
cQuery += "          )                                                                    "+CRLF
cQuery += "NIVEL4 ON NV4_GRUPO = FUN.GRUPO                                                "+CRLF
cQuery += "                                                                               "+CRLF
cQuery += "ORDER BY FUN.FILIAL, FUN.GRUPO                                                 "+CRLF

cQuery := ChangeQuery( cQuery )

TCQuery cQuery New Alias "WFUN"
TcSetField( "WFUN" , "ADMISSAO",        "D", 08, 0 )
TcSetField( "WFUN" , "DEMISSAO",        "D", 08, 0 )
 
Return
