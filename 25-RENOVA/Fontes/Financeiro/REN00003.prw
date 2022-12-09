#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ REN00003 บAutor  ณDanilo Jos้ Grodzickiบ Dataณ  22/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio dos registros com erro de incorpora็ใo.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova Energia S.A.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function REN00003()

Local cDesStatus

Private oReport
Private cCondicao
Private oSection
Private cPerg  := "REN00003"
Private aErros := {}

AjustaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return Nil
endif

if MV_PAR01 == 1
	cCondicao  := "ZZT_STATUS = 'NOK' OR ZZT_STACOM = 'NOK'"
	cDesStatus := "NOK"
elseif MV_PAR01 == 2
	cCondicao  := "ZZT_STATUS = 'OK' OR ZZT_STACOM = 'OK'"
	cDesStatus := "OK"
else
	cCondicao  := "ZZT_STATUS IN ('NOK','OK') OR ZZT_STACOM IN ('NOK','OK') OR ZZT_STATUS IS NULL"
	cDesStatus := "TODOS"
endif

Processa({ || ProcRegua( 0 ), BuscaErros()},"Aguarde...","Lendo registros do arquivo ZZT000.")

if Len(aErros) <= 0
	MsgStop("Nใo foram encontrados registros no arquivo ZZT000 para status igual a "+cDesStatus,"ATENวรO")
	Return Nil
endif

oReport := MontaRelat()
oReport:PrintDialog()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSX1 บAutor ณDanilo Jos้ Grodzickiบ Dataณ  26/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta arquivo SX1.                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova Energia S.A.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpEsp := {}

Aadd(aHelpPor,{"Escolha qual status."               })  // 01
Aadd(aHelpEng,{"Choose which status."               })  // 01
Aadd(aHelpEsp,{"Elija qu้ estado."                  })  // 01

//     cGrupo,cOrdem,cPergunt             ,cPergSpa                  ,cPergEng            ,cVar    ,cTipo,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3,cGrpSXG,cPyme,cVar01    ,cDef01  ,cDefSpa1,cDefEng1,cCnt01,cDef02  ,cDefSpa2,cDefEng2,cDef03  ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor    ,aHelpEng    ,aHelpSpa    )
PutSx1(cPerg ,"01"  ,"Listar qual status?","ฟQu้ estado de la lista?","Which list status?","MV_CH1","N"  ,01      ,0       ,0      ,"C" ,""    ,"" ,""     ,""   ,"MV_PAR01","NOK"   ,"NOK"   ,"NOK"   ,""    ,"OK"    ,"ALL"   ,"ALL"   ,"TODOS" ,"TODOS" ,"TODOS" ,""    ,""      ,""      ,""    ,""      ,""      ,aHelpPor[01],aHelpEng[01],aHelpEsp[01])

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BuscaErros บAutor ณDanilo Jos้ Grodzickiบ Dataณ 22/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ler os registros com erro de incorpora็ใo.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova Energia S.A.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BuscaErros()

Local cQuery
Local aInfo     := {}
Local aSize     := MsAdvSize(.T.)
Local cAliasTmp := GetNextAlias()

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }

cQuery := "SELECT * "
cQuery += "FROM ZZT000 "
cQuery += "WHERE "+cCondicao
cQuery := ChangeQuery(cQuery) 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.F.,.T.)
(cAliasTmp)->(DbGoTop())
while (cAliasTmp)->(!Eof())
	aadd( aErros, { (cAliasTmp)->ZZT_FILIAL, (cAliasTmp)->ZZT_NUM, (cAliasTmp)->ZZT_TIPO, (cAliasTmp)->ZZT_FORNEC, (cAliasTmp)->ZZT_LOJA,;
					  StoD((cAliasTmp)->ZZT_EMISSA), StoD((cAliasTmp)->ZZT_VENCTO), StoD((cAliasTmp)->ZZT_VENREA), (cAliasTmp)->ZZT_VALOR, (cAliasTmp)->ZZT_NATURE,;
					  (cAliasTmp)->ZZT_CCD, (cAliasTmp)->ZZT_CLASSE, (cAliasTmp)->ZZT_CAMADA, (cAliasTmp)->ZZT_PROJET, (cAliasTmp)->ZZT_CONTAD,;
					  (cAliasTmp)->ZZT_USUARI, StoD((cAliasTmp)->ZZT_DTINCL), (cAliasTmp)->ZZT_HRINCL, (cAliasTmp)->ZZT_STATUS, StoD((cAliasTmp)->ZZT_DTLEIT),;
					  (cAliasTmp)->ZZT_HRLEIT, (cAliasTmp)->ZZT_LOGERR })
	(cAliasTmp)->(DbSkip())
enddo
(cAliasTmp)->( dbCloseArea() )
If Select(cAliasTmp) == 0
	Ferase(cAliasTmp+GetDBExtension())
Endif  

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MontaRelat บAutor ณDanilo Jos้ Grodzickiบ Dataณ 26/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o relat๓rio.                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova Energia S.A.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaRelat()

Local cTitulo
Local cDescri

cTitulo := "Inconsist๊ncias da tabela tํtulos (ZZT000)."
cDescri := "Este Relat๓rio irแ imprimir as inconsist๊ncias da tabela tํtulos (ZZT000)."

oReport := TReport():New("REN00003",cTitulo,,{|oReport| PrintRelat(oReport)},cDescri,.T.,,.F.,,.T.)

oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait  := .F.
oReport:nFontBody        := 6
oReport:SetEdit(.F.)

oSection := TRSection():New(oReport,OemToAnsi(""),{},,,,,.T.)

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PrintRelat บAutor ณDanilo Jos้ Grodzickiบ Dataณ 26/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprimir o relat๓rio.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova Energia S.A.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintRelat(oReport)

Local nI

//       New(oParent  ,cName      ,cAlias,cTitle        ,cPicture              ,nSize,lPixel,bBlock,cAlign ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
TRCell():New(oSection,"ZZT_FILIAL",""    ,"FILIAL"      ,"@!"                  ,010  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_NUM"   ,""    ,"NUMERO"      ,"@!"                  ,010  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_TIPO"  ,""    ,"TIPO"        ,"@!"                  ,005  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_FORNEC",""    ,"COD. FORNEC.","@!"                  ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_LOJA"  ,""    ,"LOJA"        ,"@!"                  ,005  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_EMISSA",""    ,"DT. INCLUSAO",""                    ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_VENCTO",""    ,"DT. VENCTO"  ,""                    ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_VENREA",""    ,"DT.VENC.REAL",""                    ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_VALOR" ,""    ,"VALOR"       ,"@E 99,999,999,999.99",020  ,.T.   ,      ,"RIGHT",.F.       ,"RIGHT")
TRCell():New(oSection,"ZZT_NATURE",""    ,"NATUREZA"    ,"@!"                  ,010  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_CCD"   ,""    ,"CENTRO CUSTO","@!"                  ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_CLASSE",""    ,"CLASSE"      ,"@!"                  ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_CAMADA",""    ,"CAMADA"      ,"@!"                  ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_PROJET",""    ,"PROJETO"     ,"@!"                  ,010  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_CONTAD",""    ,"CTA.CONTABIL","@!"                  ,020  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_USUARI",""    ,"USUARIO"     ,"@!"                  ,025  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_DTINCL",""    ,"DT. INCLUSAO",""                    ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_HRINCL",""    ,"HR. INCLUSAO","@!"                  ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_STATUS",""    ,"STATUS"      ,"@!"                  ,010  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_DTLEIT",""    ,"DT. LEITURA" ,""                    ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_HRLEIT",""    ,"HR. LEITURA" ,"@!"                  ,015  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )
TRCell():New(oSection,"ZZT_LOGERR",""    ,"DESC. ERRO"  ,"@!"                  ,100  ,.T.   ,      ,"LEFT" ,.F.       ,"LEFT" )

oReport:SetMeter(Len(aErros))
oSection:Init()

For nI = 1 to Len(aErros)

	If oReport:Cancel()
		Exit
	EndIf
	
	oReport:IncMeter()

	oSection:Cell("ZZT_FILIAL"):SetBlock({||aErros[nI][01]})
	oSection:Cell("ZZT_NUM"   ):SetBlock({||aErros[nI][02]})
	oSection:Cell("ZZT_TIPO"  ):SetBlock({||aErros[nI][03]})
	oSection:Cell("ZZT_FORNEC"):SetBlock({||aErros[nI][04]})
	oSection:Cell("ZZT_LOJA"  ):SetBlock({||aErros[nI][05]})
	oSection:Cell("ZZT_EMISSA"):SetBlock({||aErros[nI][06]})
	oSection:Cell("ZZT_VENCTO"):SetBlock({||aErros[nI][07]})
	oSection:Cell("ZZT_VENREA"):SetBlock({||aErros[nI][08]})
	oSection:Cell("ZZT_VALOR" ):SetBlock({||aErros[nI][09]})
	oSection:Cell("ZZT_NATURE"):SetBlock({||aErros[nI][10]})
	oSection:Cell("ZZT_CCD"   ):SetBlock({||aErros[nI][11]})
	oSection:Cell("ZZT_CLASSE"):SetBlock({||aErros[nI][12]})
	oSection:Cell("ZZT_CAMADA"):SetBlock({||aErros[nI][13]})
	oSection:Cell("ZZT_PROJET"):SetBlock({||aErros[nI][14]})
	oSection:Cell("ZZT_CONTAD"):SetBlock({||aErros[nI][15]})
	oSection:Cell("ZZT_USUARI"):SetBlock({||aErros[nI][16]})
	oSection:Cell("ZZT_DTINCL"):SetBlock({||aErros[nI][17]})
	oSection:Cell("ZZT_HRINCL"):SetBlock({||aErros[nI][18]})
	oSection:Cell("ZZT_STATUS"):SetBlock({||aErros[nI][19]})
	oSection:Cell("ZZT_DTLEIT"):SetBlock({||aErros[nI][20]})
	oSection:Cell("ZZT_HRLEIT"):SetBlock({||aErros[nI][21]})
	oSection:Cell("ZZT_LOGERR"):SetBlock({||aErros[nI][22]})

	oSection:PrintLine()

Next

oSection:Finish()                                                      

Return Nil