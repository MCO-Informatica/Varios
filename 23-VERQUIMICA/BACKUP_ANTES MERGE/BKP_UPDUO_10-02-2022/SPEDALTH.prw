#Include 'Totvs.ch'

User Function SPEDALTH() 
Local dDataFec := PARAMIXB[1]
Local cMotInv := PARAMIXB[2]
Local cAliBLH := ''
Local cArqP7 := ''
Local nH
Local nTamCli := TamSX3("A1_COD" )[1] 
Local nTamLoj := TamSX3("A1_LOJA")[1] 
Local cCliefor := ""
Local cLoja := ""
Local cAlias := ""
Local cIndTmp1 := ""

//Cria Temporario H010 
CriaTRBH("H010",@cAliBLH)


//Alimenta arquivo temporario

// //0 - Item de propriedade do informante e em seu poder;
RecLock(cAliBLH,.T.)

(cAliBLH)->FILIAL := "01"
(cAliBLH)->REG := "H010"
(cAliBLH)->COD_ITEM := "001"
(cAliBLH)->UNID := "UN"
(cAliBLH)->QTD := 1
(cAliBLH)->VL_UNIT := 1007.5
(cAliBLH)->VL_ITEM := 1007.5

//0 - Item de propriedade do informante e em seu poder;
//1 - Item de propriedade do informante em posse de terceiros
//2 - Item de propriedade de terceiros em posse do informante
(cAliBLH)->IND_PROP := '0'

//Tratamento para poder de terceiros
(cAliBLH)->COD_PART := ""

//Dados do produto 
(cAliBLH)->COD_CTA := "1310304"
(cAliBLH)->VL_ITEM_IR := 1007.5

(cAliBLH)->ALQ_PICM := 18
(cAliBLH)->COD_ORIG :="0"
(cAliBLH)->CL_CLASS :="10"

(cAliBLH)->(MsUnLock())

//1 - Item de propriedade do informante em posse de terceiros
RecLock(cAliBLH,.T.)

(cAliBLH)->FILIAL := "01"
(cAliBLH)->REG := "H010"
(cAliBLH)->COD_ITEM := "003"
(cAliBLH)->UNID := "UN"
(cAliBLH)->QTD := 10
(cAliBLH)->VL_UNIT := 100
(cAliBLH)->VL_ITEM := 1000

//0 - Item de propriedade do informante e em seu poder;
//1 - Item de propriedade do informante em posse de terceiros
//2 - Item de propriedade de terceiros em posse do informante
(cAliBLH)->IND_PROP := '1'

//Tratamento para poder de terceiros
cCliefor := PadR(Alltrim("001"),nTamCli)
cLoja := PadR(Alltrim("01"),nTamLoj)
(cAliBLH)->COD_PART := "SA1"+cCliefor+cLoja


//Dados do produto 
(cAliBLH)->COD_CTA := "1310305"
(cAliBLH)->VL_ITEM_IR := 1000

(cAliBLH)->ALQ_PICM := 18
(cAliBLH)->COD_ORIG :="0"
(cAliBLH)->CL_CLASS :="00"

(cAliBLH)->(MsUnLock())


//2 - Item de propriedade de terceiros em posse do informante
RecLock(cAliBLH,.T.)

(cAliBLH)->FILIAL := "01"
(cAliBLH)->REG := "H010"
(cAliBLH)->COD_ITEM := "002"
(cAliBLH)->UNID := "G"
(cAliBLH)->QTD := 10
(cAliBLH)->VL_UNIT := 200
(cAliBLH)->VL_ITEM := 2000

//0 - Item de propriedade do informante e em seu poder;
//1 - Item de propriedade do informante em posse de terceiros
//2 - Item de propriedade de terceiros em posse do informante
(cAliBLH)->IND_PROP := '2'

//Tratamento para poder de terceiros
cCliefor := PadR(Alltrim("001"),nTamCli)
cLoja := PadR(Alltrim("02"),nTamLoj)
(cAliBLH)->COD_PART := "SA2"+cCliefor+cLoja


//Dados do produto 
(cAliBLH)->COD_CTA := "1310308"
(cAliBLH)->VL_ITEM_IR := 2000

(cAliBLH)->ALQ_PICM := 18
(cAliBLH)->COD_ORIG :="0"
(cAliBLH)->CL_CLASS :="00"

(cAliBLH)->(MsUnLock())

Return {}// Retorna Alias do arquivo


//------------------------------Criar temporario------------------------
Static Function CriaTRBH(cBloco,cAliasTRB)

Local nX
Local aIndice := {}
Local aLayout := {}
Local cDirSPDK := GetSrvProfString("Startpath","")

Default cAliasTRB := ""
Default cBloco := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicoes: [1]Campos / [2]Indices ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aLayout := BlocH010(cBloco)

If !ExistDir(cDirSPDK)
MakeDir(cDirSPDK)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao do Arquivo de Trabalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cBloco)
cAliasTRB := UPPER(cBloco)+"_"+CriaTrab(,.F.)
DbCreate(cDirSPDK+cAliasTRB,aLayout[1],__LocalDriver)
dbUseArea(.T.,__LocalDriver,cDirSPDK+cAliasTRB,cAliasTRB,.T.)
DbSelectArea(cAliasTRB)
For nX := 1 to Len(aLayout[2])
Aadd(aIndice,"k_"+CriaTrab(Nil,.F.))
Next nX
For nX := 1 to Len(aLayout[2])
INDEX ON &(aLayout[2][nX]) TO (aIndice[nX] + OrdBagExt())
Next nX
dbClearIndex()
For nX := 1 to Len(aLayout[2])
dbSetIndex(aIndice[nX] + OrdBagExt())
Next nX
DbSetOrder(1)
EndIf

Return aIndice


//-------------------Leiaute SPED FISCAL--------------------------------------------------------------


Static Function BlocH010(cBloco)

Local aCampos := {}
Local aIndices := {}
Local nTamFil := TamSX3("D1_FILIAL" )[1]
Local nTamCod := TamSX3("B1_COD" )[1]
Local nTamUNID := TamSX3("B1_UM" )[1]
Local nTamCC := TamSX3("B1_CONTA" )[1] 
Local aTamPic := TamSX3("B1_PICM" )
Local nTamOri := TamSX3("B1_ORIGEM" )[1] 
Local nTamClF := TamSX3("B1_CLASFIS")[1] 
Local nTamReg := 4
Local aTamQtd := {16,3}
Local aTamVlr := {16,2}
Local aTmVlUn := {16,6}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao do Arquivo de Trabalho - BLOCO H010 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{"FILIAL" ,"C",nTamFil ,0 }) 
AADD(aCampos,{"REG" ,"C",nTamReg ,0 })
AADD(aCampos,{"COD_ITEM" ,"C",nTamCod ,0 })
AADD(aCampos,{"UNID" ,"C",nTamUNID ,0 })
AADD(aCampos,{"QTD" ,"N",aTamQtd[1],aTamQtd[2] })
AADD(aCampos,{"VL_UNIT" ,"N",aTmVlUn[1],aTmVlUn[2] })
AADD(aCampos,{"VL_ITEM" ,"N",aTamVlr[1],aTamVlr[2] })
AADD(aCampos,{"IND_PROP" ,"C",1 ,0 })
AADD(aCampos,{"COD_PART" ,"C",60 ,0 })
AADD(aCampos,{"COD_CTA" ,"C",nTamCC ,0 })
AADD(aCampos,{"VL_ITEM_IR" ,"N",aTamVlr[1],aTamVlr[2] })
AADD(aCampos,{"ALQ_PICM" ,"N",aTamPic[1],aTamPic[2] })
AADD(aCampos,{"COD_ORIG" ,"C",nTamOri })
AADD(aCampos,{"CL_CLASS" ,"C",nTamClF })

// Indices
AADD(aIndices,"FILIAL+COD_ITEM+IND_PROP+COD_PART")

Return {aCampos,aIndices}

//---------------------------------------------------------------------------------

Return cAlias