#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ RELMULTAS                                              บ Data ณ 19/07/2017 บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Autor     ณ Adriano Sato                                                               บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Descricao ณ Relatorio de Multas.                                                       บฑฑ
ฑฑบ           ณ                                                                            บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Sintaxe   ณ RELMULTAS()                                                                บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno   ณ nil                                                                        บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ MINEXCO                                                                    บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/ 
User Function RELMULTAS()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg 	 := PadR ("RELMULTAS", Len (SX1->X1_GRUPO))
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao e apresentacao das perguntas      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ValidPerg(cPerg)

Pergunte(cPerg,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicoes/preparacao para impressao      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ReportDef()
oReport:PrintDialog()

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ ReportDef                                              บ Data ณ 19/07/2017 บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Autor     ณ Adriano Sato                                                               บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Descricao ณ Defini็ใo da estrutura do relat๓rio.                                       บฑฑ
ฑฑบ           ณ                                                                            บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Sintaxe   ณ ReportDef()                                                                บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno   ณ nil                                                                        บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ MINEXCO                                                                    บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportDef()

oReport := TReport():New("RELMULTAS","Relat๓rio de Multas",cPerg,{|oReport| PrintReport(oReport)},"Impressใo Multas.")
oReport:SetLandScape(.T.)
oreport:nfontbody:=8
oreport:cfontbody:="Arial"

oSecCab := TRSection():New( oReport , "Multas", {"QRY"} )
//TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
TRCell():New( oSecCab, "E1_PREFIXO" , "QRY","Prefixo")
TRCell():New( oSecCab, "E1_NUM"     , "QRY","Numero")
TRCell():New( oSecCab, "E1_PARCELA" , "QRY","Parc")
TRCell():New( oSecCab, "E1_EMISSAO" , "QRY","Dt Emissao"   ,,20)
TRCell():New( oSecCab, "E1_VENCTO"  , "QRY","Dt Vencimento",,20)
TRCell():New( oSecCab, "E1_VENCORI" , "QRY","Dt Venc Real" ,,20)
TRCell():New( oSecCab, "E1_MOVIMEN" , "QRY","Dt Movimento" ,,20)
TRCell():New( oSecCab, "E1_BAIXA"   , "QRY","Dt da Baixa"  ,,20)
TRCell():New( oSecCab, "E1_MULTA"   , "QRY")
TRCell():New( oSecCab, "E1_JUROS"   , "QRY")


//TRFunction():New(/*Cell*/             ,/*cId*/,/*Function*/,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/,/*Section*/)
TRFunction():New(oSecCab:Cell("E1_MULTA"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSecCab)

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ PrintReport                                            บ Data ณ 19/07/2017 บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Autor     ณ Adriano Sato                                                               บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Descricao ณ Impressใo do relat๓rio.                                                    บฑฑ
ฑฑบ           ณ                                                                            บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Sintaxe   ณ PrintReport(oReport)                                                       บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno   ณ nil                                                                        บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ MINEXCO                                                                    บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PrintReport(oReport)

Local cQuery := ""

//cQuery += "SELECT E1_NUM, E1_PREFIXO, E1_EMISSAO, E1_VENCTO, E1_VENCORI, E1_MOVIMEN, E1_BAIXA, E1_MULTA, E1_JUROS " + CRLF
//cQuery += "   FROM " + RetSqlName("SE1") + " SE1 " + CRLF 
//cQuery += "   WHERE E1_BAIXA BETWEEN '" + substr(DTOC(mv_par01),7,4)+substr(DTOC(mv_par01),4,2)+substr(DTOC(mv_par01),1,2) + "' AND '" + substr(DTOC(mv_par02),7,4)+substr(DTOC(mv_par02),4,2)+substr(DTOC(mv_par02),1,2) + "' " + CRLF
//cQuery += "     AND E1_MULTA <> '' " + CRLF
//cQuery += "     AND E1_VENCORI BETWEEN '" + substr(DTOC(mv_par03),7,4)+substr(DTOC(mv_par03),4,2)+substr(DTOC(mv_par03),1,2) + "' AND '" + substr(DTOC(mv_par04),7,4)+substr(DTOC(mv_par04),4,2)+substr(DTOC(mv_par04),1,2) + "' " + CRLF
//cQuery += "     AND D_E_L_E_T_ = '' " + CRLF
//cQuery += "  ORDER BY E1_PREFIXO " + CRLF

//cQuery := ChangeQuery(cQuery)

//If Select("QRY") > 0
//	Dbselectarea("QRY")
//	QRY->(DbClosearea())
//EndIf

//TcQuery cQuery New Alias "QRY"

//oSecCab:BeginQuery()
//oSecCab:EndQuery({{"QRY"},cQuery}) - linha comentada pois nใo aceita mais esses parametros
//oSecCab:EndQuery()
//oSecCab:Print()

//** Luiz
cBaixaIni := DtoS(mv_par01)
cBaixaFin := DtoS(mv_par02)
cVencOIni := DtoS(mv_par03)
cVencOFin := DtoS(mv_par04) 

If Select("QRY") > 0
   Dbselectarea("QRY")
   QRY->(DbClosearea())
EndIf

oSecCab:BeginQuery()
 BEGINSQL ALIAS "QRY"
   SELECT SE1.E1_NUM, SE1.E1_PREFIXO, SE1.E1_PARCELA, SE1.E1_EMISSAO, SE1.E1_VENCTO, SE1.E1_VENCORI, SE1.E1_MOVIMEN, SE1.E1_BAIXA, SE1.E1_MULTA, SE1.E1_JUROS
   FROM %TABLE:SE1% SE1 
   WHERE (SE1.E1_BAIXA BETWEEN %exp:cBaixaIni% AND %exp:cBaixaFin%) 
     AND SE1.E1_MULTA <> ''
     AND (SE1.E1_VENCORI BETWEEN %exp:cVencOIni% AND %exp:cVencOFin%)
     AND SE1.%NOTDEL%
   ORDER BY SE1.E1_PREFIXO, SE1.E1_NUM
 ENDSQL
oSecCab:EndQuery() 

oSecCab:Print()

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ ValidPerg                                              บ Data ณ 19/07/2017 บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Autor     ณ Adriano Sato                                                               บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Descricao ณ Cria็ใo dos parametros.                                                    บฑฑ
ฑฑบ           ณ                                                                            บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Sintaxe   ณ ValidPerg(cPerg)                                                           บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno   ณ nil                                                                        บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ MINEXCO                                                                    บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg(cPerg)

Local sAlias := Alias()
Local aRegs := {}
Local i := j := 0

dbSelectArea("SX1")
SX1->( dbSetOrder(1) )

AADD(aRegs,{cPerg,"01","Data Baixa de ?"       ,"","","mv_ch1","D",TamSx3 ("E1_BAIXA")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data Baixa At้ ?"      ,"","","mv_ch2","D",TamSx3 ("E1_BAIXA")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Data Vencimento de ?"  ,"","","mv_ch3","D",TamSx3 ("E1_VENCORI")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Data Vencimento At้ ?" ,"","","mv_ch4","D",TamSx3 ("E1_VENCORI")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If SX1->( !dbSeek(cPerg+aRegs[i,2]) )
		SX1->( RecLock("SX1",.T.) )
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next j
		SX1->( MsUnlock() )
	Endif
Next i

dbSelectArea(sAlias)

Return