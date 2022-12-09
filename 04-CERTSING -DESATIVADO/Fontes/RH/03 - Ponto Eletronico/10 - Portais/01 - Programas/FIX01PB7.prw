#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"


User Function FIX01PB7()
/*+---------------------+-----------------------------------------------------------------------------------------------------------+
  | Rotina.: FIX01PB7() | Realiza recarga da tabela PB7 (Marcações no POrtal), com marcações faltantes que ainda estejam na SP8.    |
  +---------------------+-----------------------------------------------------------------------------------------------------------+
  | Objetivo.: "Rescaldo Portal".                                                                                                   |
  +---------------------------------------------------------------------------------------------------------------------------------+
  | Observacao.:                                                                                                                    |
  |                                                                                                                                 |
  +---------------------------------------------------------------------------------------------------------------------------------+
*/
Local cDescFun  := "FIX01PB7 - Complemento de Marcações no Portal"

TNewProcess():New("FIX01PB7", cDescFun, {|oSelf| fCharg1(oSelf)}, cDescFun,NIL, NIL, NIL, NIL, NIL, .T., .F.)

Return

Static Function fCharg1(oSelf)

Local aRet      := {}
Local cQuery    := ""
Local cArqTrb   := GetNextAlias()
Local aParamBox := {}
Local cPonMes   := ""

//              1 - MsGet  [2] : Descrição  [3]    : String contendo o inicializador do campo  [4] : String contendo a Picture do campo  [5] : String contendo a validação  [6] : Consulta F3  [7] : String contendo a validação When   [8] : Tamanho do MsGet   [9] : Flag .T./.F. Parâmetro Obrigatório ?
aAdd(aParamBox,{1              ,"Periodo Inicial"  ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Inicial
aAdd(aParamBox,{1              ,"Periodo Final"    ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Final
aAdd(aParamBox,{1              ,"Filial Inicial"   ,Space(02)                                      ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.F.}) // Filial Inicial
aAdd(aParamBox,{1              ,"Filial Final"     ,Replicate("Z",02)                              ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.T.}) // Filial Inicial
aAdd(aParamBox,{1              ,"Matricula Inicial",Space(        TAMSX3("RA_MAT")[1])             ,"@!"                                     ,""                                ,"SRA"             ,""                                      ,TAMSX3("RA_MAT")[1]     ,.F.}) // Matricula Inicial
aAdd(aParamBox,{1              ,"Matricula Final"  ,Replicate("Z",TAMSX3("RA_MAT")[1])             ,"@!"                                     ,""                                ,"SRA"             ,""                                      ,TAMSX3("RA_MAT")[1]     ,.T.}) // Matricula Final
aAdd(aParamBox,{1              ,"C. Custo inicial"   ,Space(        TAMSX3("CTT_CUSTO")[1])          ,"@!"                                     ,""                                ,"CTT"             ,""                                      ,TAMSX3("CTT_CUSTO")[1]  ,.F.}) // C. de Custo Inicial
aAdd(aParamBox,{1              ,"C. Custo Final"  ,Replicate("Z",TAMSX3("CTT_CUSTO")[1])          ,"@!"                                     ,""                                ,"CTT"             ,""                                      ,TAMSX3("CTT_CUSTO")[1]  ,.T.}) // C. de Custo Final

If Parambox(aParambox,"Parametros de Processamento",@aRet)

   cPonMes   := AllTrim( DToS(aRet[1]) + DToS(aRet[2]) )

   //->Recortando Marcações.
   cQuery := "SELECT P8_FILIAL     "+CRLF
   cQuery += "      ,P8_MAT        "+CRLF
   cQuery += "      ,P8_DATA       "+CRLF
   cQuery += "      ,PB7_VERSAO    "+CRLF
   cQuery += "      ,PB7_1E        "+CRLF
   cQuery += "      ,PB7_1S        "+CRLF
   cQuery += "      ,PB7_2E        "+CRLF
   cQuery += "      ,PB7_2S        "+CRLF
   cQuery += "      ,PB7_HRPOSV    "+CRLF
   cQuery += "      ,PB7_HRPOSE    "+CRLF
   cQuery += "      ,PB7_HRNEGV    "+CRLF
   cQuery += "      ,PB7_HRNEGE    "+CRLF
   cQuery += "      ,PB7_STATUS    "+CRLF
   cQuery += "      ,PB7_STAHE     "+CRLF
   cQuery += "      ,PB7_STAATR    "+CRLF
   cQuery += "      ,PB7_R_E_C     "+CRLF
   cQuery += "FROM (SELECT * FROM (SELECT P8_FILIAL               "+CRLF
   cQuery += "                           ,P8_MAT                  "+CRLF
   cQuery += "                           ,P8_DATA                 "+CRLF
   cQuery += "                           ,COUNT(*) AS NUMB        "+CRLF
   cQuery += "                     FROM "+RetSqlName("SP8")+" SP8 "+CRLF
   cQuery += "                     WHERE SP8.D_E_L_E_T_ <> '*'  "+CRLF
   cQuery += "                       AND P8_DATA   BETWEEN '"+DToS(aRet[1])+"' AND '"+DToS(aRet[2])+"' "+CRLF
   cQuery += "                       AND P8_FILIAL BETWEEN '"+     aRet[3] +"' AND '"+     aRet[4] +"' "+CRLF
   cQuery += "                       AND P8_MAT    BETWEEN '"+     aRet[5] +"' AND '"+     aRet[6] +"' "+CRLF
   cQuery += "                       AND P8_CC     BETWEEN '"+     aRet[7] +"' AND '"+     aRet[8] +"' "+CRLF
   cQuery += "                       AND P8_HORA > 0                                                   "+CRLF
   cQuery += "                       AND P8_MOTIVRG NOT LIKE '%EXCLUSAO%'                              "+CRLF
   cQuery += "                     GROUP BY P8_FILIAL, P8_MAT, P8_DATA                                 "+CRLF
   cQuery += "                     ORDER BY P8_FILIAL, P8_MAT, P8_DATA)                                "+CRLF
   cQuery += "      WHERE NUMB IN(2,4)             "+CRLF
   cQuery += "      ) SP8X                         "+CRLF
   cQuery += "INNER JOIN (SELECT PB7_FILIAL        "+CRLF
   cQuery += "                       ,PB7_MAT      "+CRLF
   cQuery += "                       ,PB7_DATA     "+CRLF
   cQuery += "                       ,PB7_VERSAO   "+CRLF
   cQuery += "                       ,PB7_1E       "+CRLF
   cQuery += "                       ,PB7_1S       "+CRLF
   cQuery += "                       ,PB7_2E       "+CRLF
   cQuery += "                       ,PB7_2S       "+CRLF
   cQuery += "                       ,PB7_HRPOSV   "+CRLF
   cQuery += "                       ,PB7_HRPOSE   "+CRLF
   cQuery += "                       ,PB7_HRNEGV   "+CRLF
   cQuery += "                       ,PB7_HRNEGE   "+CRLF
   cQuery += "                       ,PB7_STATUS   "+CRLF
   cQuery += "                       ,PB7_STAHE    "+CRLF
   cQuery += "                       ,PB7_STAATR   "+CRLF
   cQuery += "                       ,R_E_C_N_O_ AS PB7_R_E_C                     "+CRLF
   cQuery += "                 FROM "+RetSqlName("PB7")+" PB7                     "+CRLF
   cQuery += "                 INNER JOIN (SELECT PB7B.PB7_FILIAL      AS FIL     "+CRLF
   cQuery += "                                   ,PB7B.PB7_MAT         AS MAT     "+CRLF
   cQuery += "                                   ,PB7B.PB7_DATA        AS DTA     "+CRLF
   cQuery += "                                   ,MAX(PB7B.PB7_VERSAO) AS VRS     "+CRLF
   cQuery += "                             FROM "+RetSqlName("PB7")+" PB7B        "+CRLF
   cQuery += "                             WHERE  PB7B.D_E_L_E_T_ <> '*'   "+CRLF
   cQuery += "                             GROUP BY PB7B.PB7_FILIAL        "+CRLF
   cQuery += "                                     ,PB7B.PB7_MAT           "+CRLF
   cQuery += "                                     ,PB7B.PB7_DATA)         "+CRLF
   cQuery += "                 PB7B ON PB7B.FIL = PB7_FILIAL               "+CRLF
   cQuery += "                     AND PB7B.MAT = PB7_MAT                  "+CRLF
   cQuery += "                     AND PB7B.DTA = PB7_DATA                 "+CRLF
   cQuery += "                     AND PB7B.VRS = PB7_VERSAO               "+CRLF
   cQuery += "                 WHERE PB7.PB7_1E = ' '                      "+CRLF
   cQuery += "                   AND PB7.D_E_L_E_T_ <> '*'  ) A ON A.PB7_FILIAL = SP8X.P8_FILIAL AND A.PB7_MAT = SP8X.P8_MAT AND A.PB7_DATA = SP8X.P8_DATA "+CRLF
   cQuery += "ORDER BY P8_FILIAL, P8_MAT, P8_DATA "+CRLF
   cQuery := ChangeQuery( cQuery )

   dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cArqTrb, .F., .T.)

   oSelf:SetRegua1( (cArqTrb)->(RecCount()) )

   (cArqTrb)->(dbGoTop())

   While (cArqTrb)->(!EOF())

          oSelf:IncRegua1( "Carregando Funcionario.: "+(cArqTrb)->(P8_FILIAL+" - "+P8_MAT) )
       If oSelf:lEnd
          Break
       EndIf

       //-> Chama a rotina d egeração das marcações.
       U_CSRH012( (cArqTrb)->(P8_FILIAL), (cArqTrb)->(P8_MAT), cPonMes, " ", (cArqTrb)->(SToD(P8_DATA)), (cArqTrb)->(SToD(P8_DATA)) )

       (cArqTrb)->( dbSkip() )

   EndDo

   (cArqTrb)->( dbCloseArea() )

EndIf


Return



/*
Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet

aParametros : Array contendo os parâmetros

[1] Tipo do parâmetro  (numérico)
//--> Primeiro elemento nao se altera, é sempre o tipo
//--> Os demais se alteram conforme os tipos abaixo:

 1 - MsGet
  [2] : Descrição
  [3] : String contendo o inicializador do campo
  [4] : String contendo a Picture do campo
  [5] : String contendo a validação
  [6] : Consulta F3
  [7] : String contendo a validação When
  [8] : Tamanho do MsGet
  [9] : Flag .T./.F. Parâmetro Obrigatório ?

 2 - Combo
  [2] : Descrição
  [3] : Numérico contendo a opção inicial do combo
  [4] : Array contendo as opções do Combo
  [5] : Tamanho do Combo
  [6] : Validação
  [7] : Flag .T./.F. Parâmetro Obrigatório ?

 3 - Radio
  [2] : Descrição
  [3] : Numérico contendo a opção inicial do Radio
  [4] : Array contendo as opções do Radio
  [5] : Tamanho do Radio
  [6] : Validação
  [7] : Flag .T./.F. Parâmetro Obrigatório ?
  [8] : String contendo a validação When

 4 - CheckBox ( Com Say )
  [2] : Descrição
  [3] : Indicador Lógico contendo o inicial do Check
  [4] : Texto do CheckBox
  [5] : Tamanho do Radio
  [6] : Validação
  [7] : Flag .T./.F. Parâmetro Obrigatório ?

 5 - CheckBox ( linha inteira )
  [2] : Descrição
  [3] : Indicador Lógico contendo o inicial do Check
  [4] : Tamanho do Radio
  [5] : Validação
  [6] : Flag .T./.F. Indica se campo é editável ou não

 6 - File
  [2] : Descrição
  [3] : String contendo o inicializador do campo
  [4] : String contendo a Picture do campo
  [5] : String contendo a validação
  [6] : String contendo a validação When
  [7] : Tamanho do MsGet
  [8] : Flag .T./.F. Parâmetro Obrigatório ?
  [9] : Texto contendo os tipos de arquivo Ex.: "Arquivos .CSV |*.CSV"
  [10]: Diretório inicial do cGetFile
  [11]: PARAMETROS do cGETFILE

 7 - Montagem de expressão de filtro
  [2] : Descrição
  [3] : Alias da tabela
  [4] : Filtro inicial
  [5] : Opcional - Clausula When Botão Editar Filtro

 8 - MsGet Password
  [2] : Descrição
  [3] : String contendo o inicializador do campo
  [4] : String contendo a Picture do campo
  [5] : String contendo a validação
  [6] : Consulta F3
  [7] : String contendo a validação When
  [8] : Tamanho do MsGet
  [9] : Flag .T./.F. Parâmetro Obrigatório ?

 9 - MsGet Say
  [2] : String Contendo o Texto a ser apresentado
  [3] : Tamanho da String
  [4] : Altura da String
  [5] : Negrito (lógico)

 10- Range
  [2] : Descrição
  [3] : Range Inicial
  [4] : ConsultaF3
  [5] : Largo em pixels do Get
  [6] : Tipo
  [7] : Tamanho do campo (em chars)
  [8] : String contendo a validação When

11 - MultiGet (Memo)
  [2] : Descrição
  [3] : Inicializador padrao
  [4] : String contendo a validação
  [5] : String contendo a validação When
  [6] : Flag .T./.F. Parâmetro Obrigatório ?

 12 - Filtro de usuário por Rotina
  [2] : Titulo do filtro
  [3] : Alias da tabela aonde será aplicado o filtro
  [4] : Filtro inicial
  [5] : Validação When




Return
