#INCLUDE "PROTHEUS.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"                                    
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWPrintSetup.ch"              
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "TOTVS.CH"

User Function SPDFISBLCK()
Local aRet := {} 
Local dDataIni := PARAMIXB[1] 
Local dDataFin := PARAMIXB[2] 
Local cAlias0210 := '' 
Private cAliasK200 := '' 
Private cAliasK220 := '' 
Private cAliasK230 := '' 
Private cAliasK235 := '' 
Private cAliasK250 := '' 
Private cAliasK255 := '' 
Private cAliasK210 := '' 
Private cAliasK215 := ''
Private cAliasK260 := '' 
Private cAliasK265 := ''
Private cAliasK270 := ''
Private cAliasK275 := '' 
Private cAliasK280 :='' 
Private cAliasK290 :='' 
Private cAliasK291 :='' 
Private cAliasK292 :='' 
Private cAliasK300 :='' 
Private cAliasK301 :='' 
Private cAliasK302 :='' 

//----------------------------------------------------------------- 
//Cria alias e tabelas temporárias do bloco K 
//----------------------------------------------------------------- 
 xTmpBlcK(@cAlias0210,@cAliasK200,@cAliasK220,@cAliasK230,@cAliasK235,@cAliasK250,@cAliasK255,@cAliasK210, @cAliasK215, @cAliasK260, @cAliasK265, @cAliasK270,@cAliasK275,@cAliasK280,@cAliasK290,@cAliasK291,@cAliasK292,@cAliasK300,@cAliasK301,@cAliasK302 ) 

//---------------------------------------------------------------- 
//Adicionando informações no arquivo temporário para registro K200 
//---------------------------------------------------------------- 
REGK200(cAliasK200,dDataIni,dDataFin)



//---------------------------------------------------------------- 
//Adicionando informações no arquivo temporário para registro 0210 
//----------------------------------------------------------------

/* 
RecLock (cAlias0210, .T.) 
(cAlias0210)->FILIAL := 'D MG 01 ' // Exemplo de filial , devera informar a filial de seu ambiente que devera gerar o arquivo
(cAlias0210)->REG := '0210' 
(cAlias0210)->COD_ITEM := '500' //Exemplo de código de produto , devera ser informado um código valido em seu ambiente.
(cAlias0210)->COD_I_COMP := '600' 
(cAlias0210)->QTD_COMP := 4 
(cAlias0210)->PERDA := 0 
MsUnLock () 


//---------------------------------------------------------------- 
//Adicionando informações no arquivo temporário para registro K230 
//---------------------------------------------------------------- 
RecLock (cAliasK230, .T.) 
(cAliasK230)->FILIAL := 'D MG 01 ' 
(cAliasK230)->REG := 'K230' 
(cAliasK230)->DT_INI_OP := CtoD("01/01/2016") 
(cAliasK230)->DT_FIN_OP := "04012016" 
(cAliasK230)->COD_DOC_OP := '00005001001' 
(cAliasK230)->COD_ITEM := '500' 
(cAliasK230)->QTD_ENC := 2 
MsUnLock () 

//---------------------------------------------------------------- 
//Adicionando informações no arquivo temporário para registro K235 
//---------------------------------------------------------------- 
RecLock (cAliasK235, .T.) 
(cAliasK235)->FILIAL := 'D MG 01 ' 
(cAliasK235)->REG := 'K235' 
(cAliasK235)->DT_SAIDA := CtoD("01/01/2016") 
(cAliasK235)->COD_ITEM := '600' 
(cAliasK235)->QTD := 8 
(cAliasK235)->COD_INS_SU := '' 
(cAliasK235)->COD_DOC_OP := '00005001001' 
MsUnLock ()

*/
//Adiciona alias das tabelas temporárias criadas 
aAdd(aRet,cAlias0210) 
aAdd(aRet,cAliasK200) 
aAdd(aRet,cAliasK220) 
aAdd(aRet,cAliasK230) 
aAdd(aRet,cAliasK235) 
aAdd(aRet,cAliasK250) 
aAdd(aRet,cAliasK255) 
aAdd(aRet,cAliasK210)
aAdd(aRet,cAliasK215)
aAdd(aRet,cAliasK260)
aAdd(aRet,cAliasK265)
aAdd(aRet,cAliasK270)
aAdd(aRet,cAliasK275)
aAdd(aRet,cAliasK280) 
aAdd(aRet,cAliasK290) 
aAdd(aRet,cAliasK291) 
aAdd(aRet,cAliasK292)
aAdd(aRet,cAliasK300) 
aAdd(aRet,cAliasK301) 
aAdd(aRet,cAliasK302)

Return aRet 

//------------------------------------------------------------------- 
/*/{Protheus.doc} TmpBlcK 
Função para criação das tabelas temporárias para geração do bloco K 
/*/ 
//------------------------------------------------------------------- 
Static Function xTmpBlcK(cAlias0210,cAliasK200,cAliasK220,cAliasK230,cAliasK235,cAliasK250,cAliasK255,cAliasK210, cAliasK215, cAliasK260, cAliasK265, cAliasK270,cAliasK275,cAliasK280,cAliasK290,cAliasK291,cAliasK292,cAliasK300,cAliasK301,cAliasK302 ) 

Local aCampos := {} 
Local nTamFil := TamSX3("D1_FILIAL")[1] 
Local nTamDt := TamSX3("D1_DTDIGIT")[1] 
Local aTamQtd := TamSX3("B2_QATU") 
Local nTamOP := TamSX3("D3_OP")[1] 
Local nTamCod := TamSX3("B1_COD")[1] 
Local nTamChave := TamSX3("D1_COD")[1] + TamSX3("D1_SERIE")[1] + TamSX3("D1_FORNECE")[1] + TamSX3("D1_LOJA")[1]

Local nTamPar := TamSX3("A1_COD")[1] + TamSX3("A1_LOJA")[1]
Local nTamReg := 4 
Local cArq0210 := '' 
Local cArqK200 := '' 
Local cArqK220 := '' 
Local cArqK230 := '' 
Local cArqK235 := '' 
Local cArqK250 := '' 
Local cArqK255 := '' 
Local cArqK210 := '' 
Local cArqK215 := ''
Local cArqK260 := '' 
Local cArqK265 := ''
Local cArqK270 := ''
Local cArqK280 :='' 
Local cArqK290 :=''
Local cArqK291 :=''
Local cArqK292 :=''
Local cArqK300 :=''
Local cArqK301 :=''
Local cArqK302 :=''

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO 0210 
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Campo 01 do registro 0210
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //***Código do produto que fará o relacionamento com registro pai 0200
AADD(aCampos,{"COD_I_COMP" ,"C",nTamCod ,0}) //Campo 02 do registro 0210 
AADD(aCampos,{"QTD_COMP" ,"N",aTamQtd[1],aTamQtd[2]}) //Campo 03 do registro 0210
AADD(aCampos,{"PERDA" ,"N",5 ,2}) //Campo 04 do registro 0210 

cAlias0210 := '0210' 
cArq0210 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArq0210, cAlias0210, .T. ) 
DbSelectArea(cAlias0210) 
IndRegua(cAlias0210,cArq0210,"FILIAL+COD_ITEM+COD_I_COMP") 
DbSetOrder(1) 

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K200 
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Campo 01 do registro K200 
AADD(aCampos,{"DT_EST" ,"D",nTamDt ,0}) //Campo 02 do registro K200 
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Campo 03 do registro K200 
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2]}) //Campo 04 do registro K200 
AADD(aCampos,{"IND_EST" ,"C",1 ,0}) //Campo 05 do registro K200 
AADD(aCampos,{"COD_PART" ,"C",nTamPar,0}) //Campo 06 do registro K200 

cAliasK200 := 'K200' 
cArqK200 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK200, cAliasK200, .F., .F. ) 
IndRegua(cAliasK200,cArqK200,"FILIAL+DTOS(DT_EST)+COD_ITEM") 
DbSelectArea(cAliasK200) 
DbSetOrder(1) 

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K220 
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Campo 01 do registro K220 
AADD(aCampos,{"DT_MOV" ,"D",nTamDt ,0}) //Campo 02 do registro K220 
AADD(aCampos,{"COD_ITEM_O" ,"C",nTamCod ,0}) //Campo 03 do registro K220 
AADD(aCampos,{"COD_ITEM_D" ,"C",nTamCod ,0}) //Campo 04 do registro K220 
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2]}) //Campo 05 do registro K220 

cAliasK220 := 'K220' 
cArqK220 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK220, cAliasK220, .F., .F. ) 
IndRegua(cAliasK220,cArqK220,"FILIAL") 
DbSelectArea(cAliasK220) 
DbSetOrder(1) 
//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K230 
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Campo 01 do registro K230 
AADD(aCampos,{"DT_INI_OP" ,"D",nTamDt ,0}) //Campo 02 do registro K230 
AADD(aCampos,{"DT_FIN_OP" ,"C",nTamDt ,0}) //Campo 03 do registro K230 
AADD(aCampos,{"COD_DOC_OP" ,"C",nTamOP ,0}) //***Campo 04 do registro K230. Campo utilizado para fazer relacionamento com registro filho K230 
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Campo 05 do registro K230 
AADD(aCampos,{"QTD_ENC" ,"N",aTamQtd[1],aTamQtd[2]}) //Campo 06 do registro K230 

cAliasK230 := 'K230' 
cArqK230 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK230, cAliasK230, .F., .F. ) 
IndRegua(cAliasK230,cArqK230,"FILIAL+COD_DOC_OP") 
DbSelectArea(cAliasK230) 
DbSetOrder(1) 

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K235 
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Campo 01 do registro K235 
AADD(aCampos,{"DT_SAIDA" ,"D",nTamDt ,0}) //Campo 02 do registro K235 
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Campo 03 do registro K235 
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2]}) //Campo 04 do registro K235 
AADD(aCampos,{"COD_INS_SU" ,"C",nTamCod ,0}) //Campo 05 do registro K235 
AADD(aCampos,{"COD_DOC_OP" ,"C",nTamOP ,0}) //***Campo de ligação com registro K230, o relacionamento de K230 e K235 será feito por este campo 

cAliasK235 := 'K235' 
cArqK235 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArqK235, cAliasK235, .F., .F. ) 
IndRegua(cAliasK235,cArqK235,"FILIAL+COD_DOC_OP") 
DbSelectArea(cAliasK235) 
DbSetOrder(1) 

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K250 
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Campo 01 do registro K250 
AADD(aCampos,{"CHAVE" ,"C",nTamChave ,0}) //***Campo de ligação com registros filho K255 
AADD(aCampos,{"DT_PROD" ,"D",nTamDt ,0}) //Campo 02 do registro K250 
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Campo 03 do registro K250 
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2]}) //Campo 04 do registro K250 

cAliasK250 := 'K250' 
cArqK250 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArqK250, cAliasK250, .F., .F. ) 
IndRegua(cAliasK250,cArqK250,"FILIAL+DTOS(DT_PROD)+COD_ITEM") 
DbSelectArea(cAliasK250) 
DbSetOrder(1) 

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K255 
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Campo 01 do registro K255 
AADD(aCampos,{"CHAVE" ,"C",nTamChave ,0}) //***Campo de ligação com registros pai K250 
AADD(aCampos,{"DT_CONS" ,"D",nTamDt ,0}) //Campo 02 do registro K255 
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Campo 03 do registro K255 
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2]}) //Campo 04 do registro K255 
AADD(aCampos,{"COD_INS_SU" ,"C",nTamCod ,0}) //Campo 05 do registro K250 

cAliasK255 := 'K255' 
cArqK255 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArqK255, cAliasK255, .F., .F. ) 
IndRegua(cAliasK255,cArqK255,"FILIAL+CHAVE") 
DbSelectArea(cAliasK255) 
DbSetOrder(1)

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K210
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) //Filial
AADD(aCampos,{"DT_INI_OS" ,"C",nTamReg ,0}) //Campo 01 do Registro K210
AADD(aCampos,{"DT_FIN_OS" ,"C",nTamChave ,0}) //Campo 02 do Registro K210 
AADD(aCampos,{"COD_DOC_OS" ,"D",nTamDt ,0}) //Campo 03 do Registro K210
AADD(aCampos,{"COD_ITEM_O" ,"C",nTamCod ,0}) //Campo 04 do Registro K210 
AADD(aCampos,{"QTD_ORI" ,"N",aTamQtd[1],aTamQtd[2]}) //Campo 05 do Registro K210


cAliasK210 := 'K210'
cArqK210 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArqK210, cAliasK210, .F., .F. ) 
IndRegua(cAliasK210,cArqK210,"FILIAL+COD_ITEM_O") 
DbSelectArea(cAliasK210) 
DbSetOrder(1)

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K215
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) //Filial
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Campo 01 do Registro K215
AADD(aCampos,{"COD_DOC_OS" ,"C",nTamChave ,0}) // Campo chave de ligação com o registro pai K210
AADD(aCampos,{"COD_ITEM_D" ,"D",nTamDt ,0}) //Campo 02 do Registro K215
AADD(aCampos,{"QTD_DES" ,"C",nTamCod ,0}) //Campo 03 do Registro K215 


cAliasK215 := 'K215'
cArqK215 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArqK215, cAliasK215, .F., .F. ) 
IndRegua(cAliasK215,cArqK215,"FILIAL+COD_DOC_OS") 
DbSelectArea(cAliasK215) 
DbSetOrder(1)

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K260
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) //Filial
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K260" 
AADD(aCampos,{"COD_OP_OS" ,"C",nTamChave ,0}) // Código de identificação da ordem de produção, no reprocessamento, ou da ordem de serviço, no reparo
AADD(aCampos,{"COD_ITEM" ,"D",nTamDt ,0}) //Código do produto/insumo a ser reprocessado/reparado ou já reprocessado/reparado
AADD(aCampos,{"DT_SAIDA" ,"C",nTamCod ,0}) //Data de saída do estoque
AADD(aCampos,{"QTD_SAIDA" ,"C",nTamCod ,0}) //Quantidade de saída do estoque
AADD(aCampos,{"DT_RET" ,"C",nTamCod ,0}) //Data de retorno ao estoque (entrada) 
AADD(aCampos,{"QTD_RET" ,"C",nTamCod ,0}) //Quantidade de retorno ao estoque (entrada)

cAliasK260 := 'K260''

cArqK260 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArqK260, cAliasK260, .F., .F. ) 
IndRegua(cAliasK260,cArqK260,"FILIAL+COD_OP_OS") 
DbSelectArea(cAliasK260) 
DbSetOrder(1)

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K265
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) //Filial
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K265" 
AADD(aCampos,{"COD_OP_OS" ,"C",nTamChave ,0}) // Campo chave que liga ao registro Pai K260
AADD(aCampos,{"COD_ITEM" ,"D",nTamDt ,0}) //Código da mercadoria (campo 02 do Registro 0200) 
AADD(aCampos,{"QTD_CONS" ,"C",nTamCod ,0}) //Quantidade consumida – saída do estoque
AADD(aCampos,{"QTD_RET" ,"C",nTamCod ,0}) //Quantidade retornada – entrada em estoque 


cAliasK265 := 'K265''

cArqK265 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArqK265, cAliasK265, .F., .F. ) 
IndRegua(cAliasK265,cArqK265,"FILIAL+COD_OP_OS") 
DbSelectArea(cAliasK265) 
DbSetOrder(1)


//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K270
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) //Filial
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K270" 
AADD(aCampos,{"DT_INI_AP" ,"C",nTamChave ,0}) // Data inicial do período de apuração em que ocorreu o apontamento que está sendo corrigido
AADD(aCampos,{"DT_FIN_AP" ,"D",nTamDt ,0}) //Data final do período de apuração em que ocorreu o apontamento que está sendo corrigido
AADD(aCampos,{"COD_OP_OS" ,"C",nTamCod ,0}) //Código de identificação da ordem de produção ou da ordem de serviço que está sendo corrigida
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Código da mercadoria que está sendo corrigido (campo 02 do Registro 0200)
AADD(aCampos,{"QTD_COR_P" ,"C",nTamCod ,0}) //Quantidade de correção positiva de apontamento ocorrido em período de apuração anterior
AADD(aCampos,{"QTD_COR_N" ,"C",nTamCod ,0}) //Quantidade de correção negativa de apontamento ocorrido em período de apuração anterior
AADD(aCampos,{"ORIGEM " ,"C",nTamCod ,0}) //Origem da correção, conforme manual do Sped


cAliasK270 := 'K270''

cArqK270 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArqK270, cAliasK270, .F., .F. ) 
IndRegua(cAliasK270,cArqK270,"FILIAL+COD_OP_OS") 
DbSelectArea(cAliasK270) 
DbSetOrder(1)

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K275
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) //Filial
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K275" 
AADD(aCampos,{"COD_OP_OS" ,"C",nTamChave ,0}) // Campo chave que liga ao registro Pai K270
AADD(aCampos,{"COD_ITEM" ,"D",nTamDt ,0}) //Código da mercadoria (campo 02 do Registro 0200) 
AADD(aCampos,{"QTD_COR_P" ,"C",nTamCod ,0}) //Quantidade de correção positiva de apontamento ocorrido em período de apuração anterior
AADD(aCampos,{"QTD_COR_N" ,"C",nTamCod ,0}) //Quantidade de correção negativa de apontamento ocorrido em período de apuração anterior
AADD(aCampos,{"COD_INS_SU" ,"C",nTamCod ,0}) //Código do insumo que foi substituído, caso ocorra a substituição, relativo aos Registros K235/K255


cAliasK275 := 'K275''

cArqK275 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver, cArqK275, cAliasK275, .F., .F. ) 
IndRegua(cAliasK275,cArqK275,"FILIAL+COD_OP_OS") 
DbSelectArea(cAliasK275) 
DbSetOrder(1)


//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K280
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K280"
AADD(aCampos,{"DT_EST" ,"D",nTamDt ,0}) //Data do estoque final escriturado que está sendo corrigido 
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Código do item (campo 02 do Registro 0200) 
AADD(aCampos,{"QTD_COR_P" ,"C",nTamCod ,0}) //Quantidade de correção positiva de apontamento ocorrido em período de apuração anterior
AADD(aCampos,{"QTD_COR_N" ,"N",aTamQtd[1],aTamQtd[2]}) //Quantidade de correção negativa de apontamento ocorrido em período de apuração anterior 
AADD(aCampos,{"IND_EST" ,"N",aTamQtd[1],aTamQtd[2]}) //Indicador do tipo de estoque 
AADD(aCampos,{"COD_PART" ,"N",nTamPar ,0 }) //Código do participante 


cAliasK280 := 'K280' 
cArqK280 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK280, cAliasK280, .F., .F. ) 
IndRegua(cAliasK280,cArqK280,"FILIAL") 
DbSelectArea(cAliasK280) 
DbSetOrder(1)


//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K290
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K290"
AADD(aCampos,{"DT_INI_OP" ,"D",nTamDt ,0}) //Data de início da ordem de produção
AADD(aCampos,{"DT_FIN_OP" ,"D",nTamDt ,0}) //Data de conclusão da ordem de produção
AADD(aCampos,{"COD_DOC_OP" ,"C",nTamOP ,0}) //Código de identificação da ordem de produção


cAliasK290 := 'K290' 
cArqK290 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK290, cAliasK290, .F., .F. ) 
IndRegua(cAliasK290,cArqK290,"FILIAL+COD_DOC_OP") 
DbSelectArea(cAliasK290) 
DbSetOrder(1)


//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K291
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K291"
AADD(aCampos,{"COD_DOC_OP","C",nTamOP,0}) // Código de identificação da ordem de produção
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Código do item produzido (campo 02 do Registro 0200)
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2] ,0}) //Quantidade de produção acabada 


cAliasK291 := 'K291' 
cArqK291 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK291, cAliasK291, .F., .F. ) 
IndRegua(cAliasK291,cArqK291,"FILIAL+COD_DOC_OP+COD_ITEM") 
DbSelectArea(cAliasK291) 
DbSetOrder(1)


//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K292
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K292"
AADD(aCampos,{"COD_DOC_OP","C",nTamOP,0}) // Código de identificação da ordem de produção
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Código do item produzido (campo 02 do Registro 0200)
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2] ,0}) //Quantidade de produção acabada 


cAliasK292 := 'K292' 
cArqK292 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK292, cAliasK292, .F., .F. ) 
IndRegua(cAliasK292,cArqK292,"FILIAL+COD_DOC_OP+COD_ITEM") 
DbSelectArea(cAliasK292) 
DbSetOrder(1)


//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K300
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"CHAVE" ,"C",nTamChave ,0}) //Campo de ligação com registros K301 e K302
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K300"
AADD(aCampos,{"DT_PROD" ,"D",nTamDt ,0}) //Data do reconhecimento da produção ocorrida no terceiro


cAliasK300 := 'K300' 
cArqK300 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK300, cAliasK300, .F., .F. ) 
IndRegua(cAliasK300,cArqK300,"FILIAL+CHAVE") 
DbSelectArea(cAliasK300) 
DbSetOrder(1)


//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K301
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K301"
AADD(aCampos,{"CHAVE" ,"C",nTamChave,0}) // Campo de ligação com registro K300
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Código do item produzido (campo 02 do Registro 0200)
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2] ,0}) //Quantidade produzida

cAliasK301 := 'K301' 
cArqK301 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK301, cAliasK301, .F., .F. ) 
IndRegua(cAliasK301,cArqK301,"FILIAL+CHAVE") 
DbSelectArea(cAliasK301) 
DbSetOrder(1)

//-------------------------------------------- 
//Criacao do Arquivo de Trabalho - BLOCO K302
//-------------------------------------------- 
aCampos := {} 
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0}) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0}) //Texto fixo contendo "K302"
AADD(aCampos,{"CHAVE" ,"C",nTamChave,0}) // Campo de ligação com registro K300
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Código do item produzido (campo 02 do Registro 0200)
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2] ,0}) //Quantidade consumida

cAliasK302 := 'K302' 
cArqK302 := CriaTrab(aCampos) 
dbUseArea(.T.,__LocalDriver,cArqK302, cAliasK302, .F., .F. ) 
IndRegua(cAliasK302,cArqK302,"FILIAL+CHAVE") 
DbSelectArea(cAliasK302) 
DbSetOrder(1)

Return



/*

Este exemplo irá gerar o bloco K da seguinte maneira:



|K001|0|
|K100|01012016|31012016|
|K200|31012016|500|1,000|0||
|K200|31012016|600|2,000|0||
|K230|01012016|04012016|00005001001|500|2,000|
|K235|01012016|600|8,000||
|K990|7|

Neste exemplo o registro 0210 fica da seguinte maneira:

0210    600 4,000000    
0

*/


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ REGK200        ³ Autor ³ Materiais        ³ Data ³ 28/07/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao responsavel pela gravacao do Registro K200           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAliasTRB   = Alias do arquivo de trabalho do Bloco         ³±±
±±³          ³ dDataDe     = Data Inicial da Apuracao                      ³±±
±±³          ³ dDataAte    = Data Final da Apuracao                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function REGK200(cAliasK200,dDataDe,dDataAte)

Local cError		:= ""
Local aRecTHRs		:= {}
Local lRet			:= .T.
Local cAliProp		:= GetNextAlias()
Local cAliTerc		:= GetNextAlias()
Local nThread		:= If(SuperGetMV("MV_BLKMTHR",.F.,1) > 20, 20, SuperGetMV("MV_BLKMTHR",.F.,1))
Local nX

Private cName		:= "JobK200"
Private oIpc
Private cTipo00		:= If(SuperGetMv("MV_BLKTP00",.F.,"'ME','SD'")== " ","'ME','SD'", SuperGetMv("MV_BLKTP00",.F.,"'ME','SD'")) // 00: Mercadoria Revenda
Private cTipo01		:= If(SuperGetMv("MV_BLKTP01",.F.,"'MP','MT'")== " ","'MP','MT'", SuperGetMv("MV_BLKTP01",.F.,"'MP','MT'")) // 01: Materia-Prima
Private cTipo02		:= If(SuperGetMv("MV_BLKTP02",.F.,"'EM'")== " ","'EM'", SuperGetMv("MV_BLKTP02",.F.,"'EM'")) // 02: Embalagem
Private cTipo03		:= If(SuperGetMv("MV_BLKTP03",.F.,"'PP'")== " ","'PP'", SuperGetMv("MV_BLKTP03",.F.,"'PP'")) // 03: Produto em Processo
Private cTipo04		:= If(SuperGetMv("MV_BLKTP04",.F.,"'PA','FL','BN'")== " ","'PA','FL','BN'", SuperGetMv("MV_BLKTP04",.F.,"'PA','FL','BN'")) // 04: Produto Acabado
Private cTipo05		:= If(SuperGetMv("MV_BLKTP05",.F.,"'SP'")== " ","'SP'", SuperGetMv("MV_BLKTP05",.F.,"'SP'")) // 05: SubProduto
Private cTipo06		:= If(SuperGetMv("MV_BLKTP06",.F.,"'PI'")== " ","'PI'", SuperGetMv("MV_BLKTP06",.F.,"'PI'")) // 06: Produto Intermediario
Private cTipo10		:= If(SuperGetMv("MV_BLKTP10",.F.,"'OI'")== " ","'OI'", SuperGetMv("MV_BLKTP10",.F.,"'OI'")) // 10: Outros Insumos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o arquivo com os produtos que serao processados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Conout("###### Bloco K - K200|00: Lista SLD Proprio : " + Alltrim(DtoC(Date())) + " - " + Alltrim(Time()))
xGetListPrd(cAliasK200,dDataDe,dDataAte,.F.)

// GetListPrd(@cAliTerc,dDataAte,.T.)


Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GetListPrd ³Autor ³ TOTVS S/A            ³ Data ³29/08/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o arquivo de trabalho contendo a lista de produtos ³±±
±±³          ³ com saldo inicial e se houve movimentacao no periodo.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAliasTmp = Alias do arquivo de trabalho                   ³±±
±±³          ³ dDataAte  = Data do saldo                                  ³±±
±±³          ³ lTerc     = Monta o arquivo de trabalho para terceiros     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function xGetListPrd(cAliasK200,dDataDe,dDataAte,lTerc)

Local cQuery		:= ""
Local cArqTmp		:= ""
Local aTam			:= {}
Local aCampos		:= {}
Local cAlmTerc		:= GetAlmTerc()
Local cAliasTRB		:= GetNextAlias()
Local lSldTesN3	    := SuperGetMV("MV_SDTESN3",.F.,0) <> 0
Local dUlmes		:= GetUlMes(dDataAte)

Default lTerc		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                        OBSERVACAO IMPORTANTE!!!                       ³
//³ --------------------------------------------------------------------- ³
//³ A ordenacao dos registros nao pode ser alterada, pois ao processar o  ³
//³ Reg. K200 espera-se que Produtos com N Armazens estejam sequenciais.  ³
//³ Se a ordenacao for alterada o processamento do K200 ficara incorreto. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query dos produtos que foram movimentados entre dUlmes e dDataAte     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
x_Qry := "SELECT * FROM SB9010 SB9 "
x_Qry += " INNER JOIN SB1010 SB1 ON "
x_Qry += " B1_COD = B9_COD AND B1_TIPO NOT IN ('AI','GG','GN','MC','MO','SE','ST','SV') AND SB1.D_E_L_E_T_ = ' ' "
x_Qry += " WHERE SB9.D_E_L_E_T_ = ' ' "
x_Qry += " AND B9_DATA = '"  + Dtos(dUlmes) + "' "
x_Qry += " AND SUBSTRING(B9_COD,1,1) <> 'Z' "
x_Qry += " AND B9_QINI > 0 "
x_Qry += " ORDER BY B9_COD, B9_LOCAL "
*/

x_Qry := "SELECT * FROM SB2010 SB2 "
x_Qry += "INNER JOIN SB1010 SB1 ON " 
x_Qry += "B1_COD = B2_COD AND B1_TIPO NOT IN ('AI','GG','GN','MC','MO','SE','ST','SV') AND SB1.D_E_L_E_T_ = ' ' " 
x_Qry += "WHERE SB2.D_E_L_E_T_ = ' ' "
x_Qry += "AND SUBSTRING(B2_COD,1,1) <> 'Z' " 
x_Qry += "ORDER BY B2_COD, B2_LOCAL "


/*
x_Qry := "SELECT B9_COD, SUM(B9_QINI) B9_QINI FROM SB9010 SB9 "
x_Qry += " INNER JOIN SB1010 SB1 ON "
x_Qry += " B1_COD = B9_COD AND B1_TIPO NOT IN ('AI','GG','GN','MC','MO','SE','ST','SV') AND SB1.D_E_L_E_T_ = ' ' " 
x_Qry += " WHERE SB9.D_E_L_E_T_ = ' ' "
x_Qry += " AND B9_DATA = '"  + Dtos(dUlmes) + "' "
x_Qry += " AND SUBSTRING(B9_COD,1,1) <> 'Z' "
x_Qry += " AND B9_QINI > 0 "
x_Qry += " GROUP BY B9_COD "
*/

If Select("TK20") > 0
	TK20->(DbCloseArea())
EndIf	

TcQuery x_Qry New Alias "TK20"
dDataEst := dDataAte + 1
_cProd	 := ""

DbSelectArea("TK20")
TK20->(DbGoTop())

While ! TK20->(Eof())

	nSaldo := CalcEst(TK20->B2_COD,TK20->B2_LOCAL,dDataEst,Nil)[1]
	
	If nSaldo <= 0
		DbSelectArea("TK20")
		TK20->(DbSkip())
		Loop
	EndIf
	
	If TK20->B2_COD <> _cProd
		DbSelectArea(cAliasK200)
		RecLock (cAliasK200, .T.) 
		(cAliasK200)->FILIAL   := TK20->B2_FILIAL 
		(cAliasK200)->REG      := 'K200' 
		(cAliasK200)->DT_EST   := dDataAte 
		(cAliasK200)->COD_ITEM := TK20->B2_COD
		(cAliasK200)->QTD      := nSaldo // TK20->B9_QINI
		(cAliasK200)->IND_EST  := '0' 
		(cAliasK200)->COD_PART := ''     // OBS:Quando aplicável, informar um código de participante válido que exista na tabela SA1 (clientes) ou SA2 (Fornecedores) + Loja - Exemplo: SA1+ 000010 +01 = "SA100001001". Atentar-se ao tamanho do código do cliente e da loja.
		MsUnLock () 
	Else
		DbSelectArea(cAliasK200)
		RecLock (cAliasK200, .F.) 
		(cAliasK200)->QTD      := (cAliasK200)->QTD + nSaldo 
		MsUnLock () 
	EndIF

	DbSelectArea("TK20")
	TK20->(DbSkip())

	_cProd := TK20->B2_COD

EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava o Arquivo de Trabalho com os dados da Query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
While !(cAliasTRB)->(Eof())
	
	RecLock (cAliasK200, .T.) 
	(cAliasK200)->FILIAL   := (cAliasTRB)->B9_FILIAL 
	(cAliasK200)->REG      := 'K200' 
	(cAliasK200)->DT_EST   := StoD((cAliasTRB)->B9_DATA) 
	(cAliasK200)->COD_ITEM := (cAliasTRB)->B9_COD
	(cAliasK200)->QTD      := (cAliasTRB)->B9_QINI
	(cAliasK200)->IND_EST  := '0' 
	(cAliasK200)->COD_PART := '' //OBS:Quando aplicável, informar um código de participante válido que exista na tabela SA1 (clientes) ou SA2 (Fornecedores) + Loja - Exemplo: SA1+ 000010 +01 = "SA100001001". Atentar-se ao tamanho do código do cliente e da loja.
	MsUnLock () 
	/*
		AADD(aCampos,{"FILIAL"   ,"C",nTamFil ,0}) 
		AADD(aCampos,{"REG"      ,"C",nTamReg ,0}) //Campo 01 do registro K200 
		AADD(aCampos,{"DT_EST"   ,"D",nTamDt ,0}) //Campo 02 do registro K200 
		AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0}) //Campo 03 do registro K200 
		AADD(aCampos,{"QTD" ,"N" ,aTamQtd[1],aTamQtd[2]}) //Campo 04 do registro K200 
		AADD(aCampos,{"IND_EST"  ,"C",1 ,0}) //Campo 05 do registro K200 
		AADD(aCampos,{"COD_PART" ,"C",nTamPar,0}) //Campo 06 do registro K200 
		
	    RecLock(cAliasTmp,.T.)
	    (cAliasTmp)->B9_FILIAL	:= (cAliasTRB)->B9_FILIAL
	    (cAliasTmp)->STATS		:= (cAliasTRB)->STATS
	    (cAliasTmp)->B9_COD		:= (cAliasTRB)->B9_COD
	    (cAliasTmp)->B9_LOCAL	:= (cAliasTRB)->B9_LOCAL
	    (cAliasTmp)->B9_DATA	:= StoD((cAliasTRB)->B9_DATA)
	    (cAliasTmp)->B9_QINI	:= (cAliasTRB)->B9_QINI
	    (cAliasTmp)->(MsUnLock())
	*/    
/*
	(cAliasTRB)->(DbSkip())
EndDo
(cAliasTRB)->(dbCloseArea())
(cAliasTmp)->(dbGoTop())
*/
Return




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GetUlMes   ³Autor ³ TOTVS S/A            ³ Data ³22/12/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o Saldo DE ou Em Terceiros de um  produto.         ³±±
±±³          ³ Esta funcao foi baseada na SaldoTerc (SIGACUSA).           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dDataAte = Datra final do processamento                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetUlMes(dDataAte)

Local dRet
Local cQuery		:= ""
Local cAliasTRB		:= GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query que retorna a 1a data menor que a data Ate         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT SB9.B9_DATA "
cQuery += "FROM SB9010 SB9 "
cQuery += "WHERE SB9.B9_FILIAL = '"+ xFilial("SB9") + "' AND SB9.B9_DATA <= '"+ DtoS(dDataAte)+"' AND SB9.D_E_L_E_T_ = ' '"
cQuery += "ORDER BY 1 DESC "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)


dRet := StoD((cAliasTRB)->B9_DATA)

(cAliasTRB)->(dbCloseArea())

Return dRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GetAlmTerc ³Autor ³ TOTVS S/A            ³ Data ³21/01/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna os Armazens de Terceiros, caso o cliente utilize o ³±±
±±³          ³ conceito do parametro MV_CONTERC.                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetAlmTerc()

Local cRet			:= "''"
Local lConTerc		:= SuperGetMv("MV_CONTERC",.F.,.F.)
Local cAlmTerc		:= SuperGetMv("MV_ALMTERC",.F.,"")

If lConTerc .And. At("/",cAlmTerc) > 0
	cRet	:= "'" + SubStr(cAlmTerc,1,Len(cAlmTerc)-1) + "'"
	cRet	:= StrTran(cRet,"/","','")
EndIf

Return cRet