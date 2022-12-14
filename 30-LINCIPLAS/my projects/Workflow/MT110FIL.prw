/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MT110FIL  ?Autor  ?THIAGO COMELLI      ? Data ?  07/10/06   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?PONTO DE ENTRADA NO FILTRO DO MBROWE DE SOLICITACAO DE COMPR???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                              	                          ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function MT110FIL()

//GRAVA O NOME DA FUNCAO NA Z03
//U_CFGRD001(FunName())

cRet := ""
CPERG := "COMRD3"
                 
ValidPerg()
SetKey( 121 ,{|| Pergunte("COMRD3",.T.)})

Return (cRet)

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?ValidPerg ?Autor  ?Paulo Bindo         ? Data ?  12/01/05   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Cria pergunta no e o help do SX1                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

Static Function ValidPerg()

Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,CPERGunt             ,cPerSpa               ,cPerEng               ,cVar     ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02  ,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(CPERG,"01"   ,"N? de Pedidos?      ",""                    ,""                    ,"mv_ch1","N"   ,02      ,0       ,0      , "G",""    ,"" ,""         ,""   ,"mv_par01",""    	,""      ,""      ,""    ,""	   	,""     ,""      ,""    	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(CPERG,"02"   ,"N? de Fornecedores? ",""                    ,""                    ,"mv_ch2","N"   ,02      ,0       ,0      , "G",""    ,"" ,""         ,""   ,"mv_par02",""       ,""      ,""      ,""    ,""		,""     ,""      ,""		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
PutSx1(CPERG,"03"   ,"Fornec Prod/Grupo?  ",""                    ,""                    ,"mv_ch3","N"   ,01      ,0       ,0      , "C",""    ,"" ,""         ,""   ,"mv_par03","Produto",""      ,""      ,""    ,"Grupo" 	,""     ,""      ,""    	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(CPERG,"04"   ,"Aprova por Item/Sol?",""                    ,""                    ,"mv_ch4","N"   ,01      ,0       ,0      , "C",""    ,"" ,""         ,""   ,"mv_par04","Item"   	,""      ,""      ,""    ,"Solicita",""     ,""      ,""    	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

cKey     := "P.COMRD0301."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o n?mero de Pedidos que deseja ")
aAdd(aHelpPor,"imprimir.    ")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMRD0302."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o numero de Fornecedores que ")
aAdd(aHelpPor,"deseja imprimir.   ")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMRD0303."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Escolha se o Fornecedor ser? escolhido")
aAdd(aHelpPor,"por Produto ou Grupo")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMRD0304."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Escolha se a aprovacao da Solilita??o")
aAdd(aHelpPor,"ser? por ITEM ou por SOLICITA??O.")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return