/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPDGNRE01 ºAutor  ³Microsiga           º Data ³  08/26/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UPDGNRE01()

Local cModulo := "FIS"
Local bPrepar := {|| U_GNREUPD1() }
Local nVersao := 01

NGCriaUpd(cModulo,bPrepar,nVersao)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPDGNRE01 ºAutor  ³Microsiga           º Data ³  08/26/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GNREUpd1()

aSX3  := {}
aHelp := {}
aSX6  := {}
// SF6 - Guia de Recolhimento.
//-->> Criação do Campo SX3
//X3_ARQUIVO,X3_ORDEM,X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL,X3_TITULO,X3_TITSPA,X3_TITENG,X3_DESCRIC,X3_DESCSPA,X3_DESCENG,X3_PICTURE,X3_VALID,X3_USADO,X3_RELACAO,X3_F3,X3_NIVEL,X3_RESERV,X3_CHECK,X3_TRIGGER,X3_PROPRI,X3_BROWSE,X3_VISUAL,X3_CONTEXT,X3_OBRIGAT,X3_VLDUSER,X3_CBOX,X3_CBOXSPA,X3_CBOXENG,X3_PICTVAR,X3_WHEN,X3_INIBRW,X3_GRPSXG,X3_FOLDER,X3_PYME,X3_CONDSQL,X3_CHKSQL
AAdd(aSX3,{"SF6",NIL,"F6_XPROCES","C",01,0,"Importa GNRE","Importa GNRE","Importa GNRE","Importacao Gerada ?"   ,"Importacao Gerada ?"   ,"Importacao Gerada ?"   ,""  ,"Pertence('12')","€€€€€€€€€€€€€€","",""   ,0,"þÀ","","","U","N","A","R","","","1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao","","","","","","","","","","N","N","",""})
AAdd(aSX3,{"SF6",NIL,"F6_XARQGNR","C",20,0,"Arquivo GNRE","Arquivo GNRE","Arquivo GNRE","Arquivo Importado GNRE","Arquivo Importado GNRE","Arquivo Importado GNRE","@!",""              ,"€€€€€€€€€€€€€€","",""   ,0,"þÀ","","","U","N","A","R","","",""           ,""           ,""           ,"","","","","","","","","","N","N","",""})
AAdd(aSX3,{"SF6",NIL,"F6_XFORNEC","C",06,0,"Fornec. GNRE","Fornec. GNRE","Fornec. GNRE","Fornecedor GNRE"       ,"Fornecedor GNRE"       ,"Fornecedor GNRE"       ,"@!",""              ,"€€€€€€€€€€€€€€","","SA2",0,"þÀ","","","U","N","A","R","","",""           ,""           ,""           ,"","","","","","","","","","N","N","",""})
AAdd(aSX3,{"SF6",NIL,"F6_XLOJA"  ,"C",02,0,"Loja GNRE"   ,"Loja GNRE"   ,"Loja GNRE"   ,"Loja GNRE"             ,"Loja GNRE"             ,"Loja GNRE"             ,""  ,""              ,"€€€€€€€€€€€€€€","",""   ,0,"þÀ","","","U","N","A","R","","",""           ,""           ,""           ,"","","","","","","","","","N","N","",""})
AAdd(aHelp,{"F6_XPROCES","Importação Gerada ?."           })
AAdd(aHelp,{"F6_XARQGNR","Nome do Arquivo Importado GNRE."})
AAdd(aHelp,{"F6_XFORNEC","Fornecedor GNRE."               })
AAdd(aHelp,{"F6_XLOJA"  ,"Loja Fornecedor GNRE"           })
/*
SX3->X3_ARQUIVO   := aSX3[nX,01]
SX3->X3_ORDEM     := cOrdem
SX3->X3_CAMPO     := aSX3[nX,03]
SX3->X3_TIPO      := aSX3[nX,04]
SX3->X3_TAMANHO   := aSX3[nX,05]
SX3->X3_DECIMAL   := aSX3[nX,06]
SX3->X3_TITULO    := aSX3[nX,07]
SX3->X3_TITSPA    := If(Empty(aSX3[nX,08]),aSX3[nX,07],aSX3[nX,08])
SX3->X3_TITENG    := If(Empty(aSX3[nX,09]),aSX3[nX,07],aSX3[nX,09])
SX3->X3_DESCRIC   := aSX3[nX,10]
SX3->X3_DESCSPA   := If(Empty(aSX3[nX,11]),aSX3[nX,10],aSX3[nX,11])
SX3->X3_DESCENG   := If(Empty(aSX3[nX,12]),aSX3[nX,10],aSX3[nX,12])
SX3->X3_PICTURE   := aSX3[nX,13]
SX3->X3_VALID     := aSX3[nX,14]
SX3->X3_USADO     := aSX3[nX,15]
SX3->X3_RELACAO   := aSX3[nX,16]
SX3->X3_F3        := aSX3[nX,17]
SX3->X3_NIVEL     := aSX3[nX,18]
SX3->X3_RESERV    := aSX3[nX,19]
SX3->X3_CHECK     := aSX3[nX,20]
SX3->X3_TRIGGER   := aSX3[nX,21]
SX3->X3_PROPRI    := aSX3[nX,22]
SX3->X3_BROWSE    := aSX3[nX,23]
SX3->X3_VISUAL    := aSX3[nX,24]
SX3->X3_CONTEXT   := aSX3[nX,25]
SX3->X3_OBRIGAT   := aSX3[nX,26]
SX3->X3_VLDUSER   := If(Len(aSX3[nX]) >= 27,aSX3[nX,27],'')
SX3->X3_CBOX      := If(Len(aSX3[nX]) >= 28,aSX3[nX,28],'')
SX3->X3_CBOXSPA   := If(Len(aSX3[nX]) >= 29,aSX3[nX,29],'')
SX3->X3_CBOXENG   := If(Len(aSX3[nX]) >= 30,aSX3[nX,30],'')
SX3->X3_PICTVAR   := If(Len(aSX3[nX]) >= 31,aSX3[nX,31],'')
SX3->X3_WHEN      := If(Len(aSX3[nX]) >= 32,aSX3[nX,32],'')
SX3->X3_INIBRW    := If(Len(aSX3[nX]) >= 33,aSX3[nX,33],'')
SX3->X3_GRPSXG    := cGRPSXG
SX3->X3_FOLDER    := If(Len(aSX3[nX]) >= 35,aSX3[nX,35],'')
SX3->X3_PYME      := If(Len(aSX3[nX]) >= 36,aSX3[nX,36],'')
SX3->X3_CONDSQL   := If(Len(aSX3[nX]) >= 37,aSX3[nX,37],'')
SX3->X3_CHKSQL    := If(Len(aSX3[nX]) >= 38,aSX3[nX,38],'')
*/
//-->> Criação dos Parâmetros SX6
//{VAR,TIPO,DESCRIC,DSCSPA,DSCENG,DESC1,DSCSPA1,DSCENG1,DESC2,DSCSPA2,DSCENG2,DSCENG2,CONTEUD,CONTSPA,CONTENG,PROPRI,VALID}
//    01      02      03     04    05     06      07     08     09       10     11       12     13      14      15    16
AAdd(aSX6,{"MV_XTPOGNR","C","Tipo de Titulo para GNRE (E2_TIPO)"       ,"Tipo de Titulo para GNRE (E2_TIPO)"       ,"Tipo de Titulo para GNRE (E2_TIPO)"       ,"","","","","","","GNR"     ,"","","U",""})
AAdd(aSX6,{"MV_XNATGNR","C","Natureza do Titulo para GNRE (E2_NATUREZ)","Natureza do Titulo para GNRE (E2_NATUREZ)","Natureza do Titulo para GNRE (E2_NATUREZ)","","","","","","","SF420010","","","U",""})

/* Fonte Padrao que faz o tratamento da inclusão do Parâmetro
SX6->X6_VAR     := aSX6[x,1]
SX6->X6_TIPO    := aSX6[x,2]
SX6->X6_DESCRIC := aSX6[x,3]
SX6->X6_DSCSPA  := If(aSX6[x,4] <> Nil .Or. Empty(aSX6[x,4]),aSX6[x,3],aSX6[x,4])
SX6->X6_DSCENG  := If(aSX6[x,5] <> Nil .Or. Empty(aSX6[x,5]),aSX6[x,3],aSX6[x,5])
If aSX6[x,6] <> Nil
	SX6->X6_DESC1 := aSX6[x,6]
Endif
SX6->X6_DSCSPA1 := If(aSX6[x,7] = Nil .Or. Empty(aSX6[x,7]),SX6->X6_DESC1,aSX6[x,7])
SX6->X6_DSCENG1 := If(aSX6[x,8] = Nil .Or. Empty(aSX6[x,8]),SX6->X6_DESC1,aSX6[x,8])
If aSX6[x,9] <> Nil
	SX6->X6_DESC2 := aSX6[x,9]
Endif
SX6->X6_DSCSPA2 := If(aSX6[x,10] = Nil .Or. Empty(aSX6[x,10]),SX6->X6_DESC2,aSX6[x,10])
SX6->X6_DSCENG2 := If(aSX6[x,11] = Nil .Or. Empty(aSX6[x,11]),SX6->X6_DESC2,aSX6[x,11])
SX6->X6_CONTEUD := aSX6[x,12]
SX6->X6_CONTSPA := If(aSX6[x,13] = Nil .Or. Empty(aSX6[x,13]),SX6->X6_CONTEUD,aSX6[x,13])
SX6->X6_CONTENG := If(aSX6[x,14] = Nil .Or. Empty(aSX6[x,14]),SX6->X6_CONTEUD,aSX6[x,14])
SX6->X6_PROPRI  := If(aSX6[x,15] = Nil .Or. Empty(aSX6[x,15]),"S",aSX6[x,15])
SX6->X6_PYME    := 'N'
SX6->X6_VALID   := If(Len(aSX6[x]) > 15 .And. aSX6[x,16] <>  NIL ,aSX6[x,16]," ")
*/
Return