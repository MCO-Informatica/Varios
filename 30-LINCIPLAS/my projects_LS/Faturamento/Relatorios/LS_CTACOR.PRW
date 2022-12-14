/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? FISTRFNFE? Autor ? Rafael Alencar     ? Data ?  22/07/12   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Ponto de Entrada para impressao da CC-e.                   ???
???          ? Layout nosso enquanto aguarda padrao da SEFAZ              ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?                                                            ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
/*/

User Function FISTRFNFE()

aadd(aRotina,{'Imprime CC-e' , 'U_LS_CTACOR' , 0 , 3,0,NIL})
aadd(aRotina,{'Reinicia TSS' , 'U_LS_TSS'    , 0 , 3,0,NIL})
Return Nil

User Function FISTRFCCE()

aadd(aRotina,{'Imprime CC-e','U_LS_CTACOR' , 0 , 3,0,NIL})
Return Nil

/////////////////////////////////////////////
User Function LS_CTACOR()
/////////////////////////////////////////////
#include "protheus.ch"
#include "rwmake.ch"
#include "font.ch"
#include "colors.ch"
#include "totvs.ch"
#Include "TOPCONN.CH"

Local   iw1,iw2,nLin
Local   xBitMap := FisxLogo("1")     ///Logotipo da empresa
Local   MMEMO1  := MMEMO2 := ""
Local   xCGC    := ""
Local   aArea   := GetArea()
Private cPerg   := "CPRNCCE   "
_aPergs := {mv_par01, mv_par02, mv_par03}
ValidPerg()

lRsp := Pergunte(cPerg,.T.)

IF ( !lRsp )
	mv_par01 := _aPergs[1]
	mv_par02 := _aPergs[2]
	mv_par03 := _aPergs[3]
	Return
ENDIF

If alltrim(mv_par01) == '8'
	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(xFilial("SF2")+mv_par02+mv_par01)
	cChvNfe  := SF2->F2_CHVNFE
	dEmissao := SF2->F2_EMISSAO
	
	If SF2->F2_TIPO $ 'BD'
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		xDestinatario := SA2->A2_NOME
		IF ( !EMPTY(SA2->A2_CGC) )
			xCGC := IIF(LEN(SA2->A2_CGC) > 11 , TRANSF(SA2->A2_CGC,"@R 99.999.999/9999-99") , TRANSF(SA2->A2_CGC,"@R 999.999.999-99") )
		ENDIF
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		xDestinatario := SA1->A1_NOME
		IF ( !EMPTY(SA1->A1_CGC) )
			xCGC := IIF(LEN(SA1->A1_CGC) > 11 , TRANSF(SA1->A1_CGC,"@R 99.999.999/9999-99") , TRANSF(SA1->A1_CGC,"@R 999.999.999-99") )
		ENDIF
	EndIf
	
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+mv_par02+mv_par01)
	cChvNfe  := SF1->F1_CHVNFE
	dEmissao := SF1->F1_EMISSAO
	
	If !(SF1->F1_TIPO $ 'BD')
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
		xDestinatario := SA2->A2_NOME
		IF ( !EMPTY(SA2->A2_CGC) )
			xCGC := IIF(LEN(SA2->A2_CGC) > 11 , TRANSF(SA2->A2_CGC,"@R 99.999.999/9999-99") , TRANSF(SA2->A2_CGC,"@R 999.999.999-99") )
		ENDIF
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
		xDestinatario := SA1->A1_NOME
		IF ( !EMPTY(SA1->A1_CGC) )
			xCGC := IIF(LEN(SA1->A1_CGC) > 11 , TRANSF(SA1->A1_CGC,"@R 99.999.999/9999-99") , TRANSF(SA1->A1_CGC,"@R 999.999.999-99") )
		ENDIF
	EndIf
	
EndIf

IF ( EOF() .OR. EMPTY(cChvNfe) )
	MsgStop("Aten??o! Nota Fiscal n?o existe ou Nota Fiscal Inutilizada.")
	RestArea(aArea)
	mv_par01 := _aPergs[1]
	mv_par02 := _aPergs[2]
	mv_par03 := _aPergs[3]
	Return
ENDIF

///
///TOP 1 - para pegar sempre a ultima carta de correcao da nf-e
///
cQry := "SELECT TOP 1 ID_EVENTO,TPEVENTO,SEQEVENTO,AMBIENTE,DATE_EVEN,TIME_EVEN,VERSAO,VEREVENTO,VERTPEVEN,VERAPLIC,CORGAO,CSTATEVEN,CORGAO, CMOTEVEN,"
cQry += "PROTOCOLO,NFE_CHV,ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_ERP)),'') AS TMEMO1,"
cQry += "ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_RET)),'') AS TMEMO2 "
cQry += "FROM SPED150 (NOLOCK)"
cQry += "WHERE D_E_L_E_T_ = ' ' AND STATUS = 6 "
cQry += "AND NFE_CHV = '"+cChvNfe+"' "
cQry += "ORDER BY LOTE DESC"

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","DATE_EVEN","D",08,0)

dbSelectArea("TMP")
dbGoTop()

IF ( EOF() )
	MsgStop("Aten??o! N?o existe Carta de Corre??o para a Nota Fiscal informada.")
	TMP->(dbCloseArea())
	RestArea(aArea)
	mv_par01 := _aPergs[1]
	mv_par02 := _aPergs[2]
	mv_par03 := _aPergs[3]
	Return
ENDIF

MMEMO1     := TMP->TMEMO1     ///Relativo ao envio
MMEMO2     := TMP->TMEMO2     ///Retorno da SEFAZ
MNFE_CHV   := TMP->NFE_CHV
MID_EVENTO := TMP->ID_EVENTO
MTPEVENTO  := STR(TMP->TPEVENTO,6)
MSEQEVENTO := STR(TMP->SEQEVENTO,1)
MAMBIENTE  := STR(TMP->AMBIENTE,1)+IIF(TMP->AMBIENTE==1," - Produ??o", IIF(TMP->AMBIENTE==2," - Homologa??o" , ""))
MDATE_EVEN := DTOC(TMP->DATE_EVEN)
MTIME_EVEN := TMP->TIME_EVEN
MVERSAO    := STR(TMP->VERSAO,4,2)
MVEREVENTO := STR(TMP->VEREVENTO,4,2)
MVERTPEVEN := STR(TMP->VERTPEVEN,4,2)
MVERAPLIC  := TMP->VERAPLIC
MCORGAO    := STR(TMP->CORGAO,2)+IIF(TMP->CORGAO==13 , " - AMAZONAS",IIF(TMP->CORGAO==35 , " - SAO PAULO" , ""))
MCSTATEVEN := STR(TMP->CSTATEVEN,3)
MCMOTEVEN  := TMP->CMOTEVEN
MPROTOCOLO := STR(TMP->PROTOCOLO,15)

TMP->(dbCloseArea())

RestArea(aArea)

xFone := RTRIM(SM0->M0_TEL)
xFone := STRTRAN(xFone,"(","")
xFone := STRTRAN(xFone,")","")
xFone := STRTRAN(xFone,"-","")
xFone := STRTRAN(xFone," ","")

xFax := RTRIM(SM0->M0_FAX)
xFax := STRTRAN(xFax,"(","")
xFax := STRTRAN(xFax,")","")
xFax := STRTRAN(xFax,"-","")
xFax := STRTRAN(xFax," ","")

xRazSoc := RTRIM(SM0->M0_NOMECOM)
xEnder  := RTRIM(SM0->M0_ENDENT) + " - " + RTRIM(SM0->M0_BAIRENT) + " - " + RTRIM(SM0->M0_CIDENT) + "/" + SM0->M0_ESTENT
xFone   := "Fone / Fax: " + TRANSF(xFone,"@R (99)9999-9999") + IIF(!EMPTY(SM0->M0_FAX) , " / " + TRANSF(xFax,"@R (99)9999-9999") , "" )
xCnpj   := "C.N.P.J.: " + TRANSF(SM0->M0_CGC,"@R 99.999.999/9999-99")
xIE     := "I.Estadual: "+SM0->M0_INSC

////
////Extrai dados do Memo
////
MDHEVENTO := ""
iw1 := AT("<dhRegEvento>" , MMEMO2 )
iw2 := AT("</dhRegEvento>" , MMEMO2 )
IF ( iw1 > 0 )
	iw3 := ( iw2 - iw1 )
	MDHEVENTO += SUBS(MMEMO2 , ( iw1+13 ) , ( iw2 - ( iw1 + 13 ) ) )
ENDIF
*
MDESCEVEN := ""
iw1 := AT("<xEvento>" , MMEMO2 )
iw2 := AT("</xEvento>" , MMEMO2 )
IF ( iw1 > 0 )
	iw3 := ( iw2 - iw1 )
	MDESCEVEN += SUBS(MMEMO2 , ( iw1+9 ) , ( iw2 - ( iw1 + 9 ) ) )
ENDIF
If alltrim(MTPEVENTO) == '110110'
	MDESCEVEN := 'Carta de Corre??o Registrada'
EndIf

aCorrec   := {}
MCORRECAO := ""
iw1 := AT("<xCorrecao>" , MMEMO1 )
iw2 := AT("</xCorrecao>" , MMEMO1 )
IF ( iw1 > 0 )
	iw3 := ( iw2 - iw1 )
	MCORRECAO += SUBS(MMEMO1 , ( iw1+11 ) , ( iw2 - ( iw1 + 11 ) ) )
	MCORRECAO += SPACE(10)
	iw1 := 1
	DO WHILE !EMPTY(SUBS(MCORRECAO,iw1,10))
		AADD(aCorrec , SUBS(MCORRECAO,iw1,105) )
		iw1 += 105     ///Nro de caracteres da linha - fica a criterio
	ENDDO
ENDIF
*
aCondic   := {}
MCONDICAO := ""
iw1 := AT("<xCondUso>" , MMEMO1 )
iw2 := AT("</xCondUso>" , MMEMO1 )
IF ( iw1 > 0 )
	///As linha comentadas abaixo retirei pois nao achei bom qdo impressa
	///
	//iw3 := ( iw2 - iw1 )
	//MCONDICAO += SUBS(MMEMO1 , ( iw1+10 ) , ( iw2 - ( iw1 + 10 ) ) )
	//MCONDICAO += SPACE(10)
	//iw1 := 1
	//DO WHILE !EMPTY(SUBS(MCONDICAO,iw1,10))
	//	AADD(aCondic , SUBS(MCONDICAO,iw1,137) )
	//	iw1 += 137     ///Nro de caracteres da linha
	//ENDDO
	AADD(aCondic , "A Carta de Corre??o ? disciplinada pelo par?grafo 1?-A do Art. 7? do Conv?nio S/N, de 15 de dezembro de 1970 e pode ser utilizada para" )
	AADD(aCondic , "regulariza??o  de  erro ocorrido na  emiss?o de  documento  fiscal, desde que o erro n?o esteja relacionado com:  I - as vari?veis que" )
	AADD(aCondic , "determinam o valor do imposto tais como: base de c?lculo, al?quota, diferenca de pre?o, quantidade, valor da opera??o ou da presta??o;" )
	AADD(aCondic , "II - a corre??o de dados cadastrais que implique mudan?a do remetente ou do destinat?rio; III - a data de emiss?o ou de sa?da.        " )
ENDIF


// Cria um novo objeto para impressao
oPrint := TMSPrinter():New("Impress?o da Carta de Corre??o Eletronica - CC-e")

// Cria os objetos com as configuracoes das fontes
//                                              Negrito  Subl  Italico
oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f.,.f. )
oFont08b := TFont():New( "Times New Roman",,08,,.t.,,,,,.f.,.f. )
oFont09  := TFont():New( "Times New Roman",,09,,.f.,,,,,.f.,.f. )
oFont10  := TFont():New( "Times New Roman",,10,,.f.,,,,,.f.,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f.,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f.,.f. )
oFont11  := TFont():New( "Times New Roman",,11,,.f.,,,,,.f.,.f. )
oFont11b := TFont():New( "Times New Roman",,11,,.t.,,,,,.f.,.f. )
oFont12  := TFont():New( "Times New Roman",,12,,.f.,,,,,.f.,.f. )
oFont12b := TFont():New( "Times New Roman",,12,,.t.,,,,,.f.,.f. )
oFont13b := TFont():New( "Times New Roman",,13,,.t.,,,,,.f.,.f. )
oFont14  := TFont():New( "Times New Roman",,14,,.f.,,,,,.f.,.f. )
oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f.,.f. )

// Mostra a tela de Setup
oPrint:Setup()

oPrint:SetPortrait()
oPrint:SetPaperSize(9)       ///(DMPAPER_A4)

// Inicia uma nova pagina
oPrint:StartPage()

oPrint:SetFont(oFont24b)
oPrint:SayBitMap(100,116,xBitMap,600,280)

oPrint:Say(120,780,xRazSoc,oFont13b ,140)
oPrint:Say(180,780,xEnder,oFont11 ,140)
oPrint:Say(230,780,xFone,oFont11 ,140)
oPrint:Say(280,780,xCnpj,oFont11 ,140)
oPrint:Say(330,780,xIE,oFont11 ,140)

oPrint:Box(390,0100,600,2400)

oPrint:Line(470,0100,470,2400)
oPrint:Say(410,1000,"Carta de Corre??o",oFont12b ,160)
oPrint:Say(490,0200,"N.Fiscal: "+mv_par02,oFont11b ,100)
oPrint:Say(490,0600,"S?rie: "+mv_par01,oFont11b ,100)
oPrint:Say(540,0200,"Dt.Emiss?o: "+DTOC(dEmissao),oFont11b ,100)

nLin := 200
oPrint:Box(nLin+420,100,nLin+2000,2400)

oPrint:Say(nLin+440,110,"Tipo do evento",oFont12b ,100)
oPrint:Say(nLin+440,850,"Data e hora",oFont12b ,100)
oPrint:Say(nLin+440,1890,"Protocolo",oFont12b ,100)
oPrint:Say(nLin+490,110,"Carta de Corre??o NFe",oFont11 ,100)
oPrint:Say(nLin+490,850,MDATE_EVEN+"  "+MTIME_EVEN,oFont11 ,140)
oPrint:Say(nLin+490,1890,MPROTOCOLO,oFont11 ,140)

oPrint:Say(nLin+580,110,"Identifica??o do destinat?rio",oFont11b ,200)
oPrint:Say(nLin+580,1430,"CNPJ/CPF",oFont11b ,200)
oPrint:Say(nLin+630,110,xDestinatario,oFont11b ,800)
oPrint:Say(nLin+630,1430,xCGC,oFont11b ,260)

oPrint:Say(nLin+740,110,"DADOS DO EVENTO DA CARTA DE CORRE??O",oFont11b ,250)
oPrint:Say(nLin+800,110,"Vers?o do evento",oFont11b ,100)
oPrint:Say(nLin+800,670,"Id evento",oFont11b ,100)
oPrint:Say(nLin+800,1890,"Tipo do evento",oFont11b ,100)
oPrint:Say(nLin+850,110,MVERSAO,oFont11 ,80)
oPrint:Say(nLin+850,670,MID_EVENTO,oFont11 ,400)
oPrint:Say(nLin+850,1890,MTPEVENTO,oFont11 ,120)

oPrint:Say(nLin+940,110,"Identifica??o do ambiente",oFont11b ,140)
oPrint:Say(nLin+940,670,"C?digo do ?rg?o de recep??o do evento",oFont11b ,240)
oPrint:Say(nLin+940,1430,"Chave de acesso da NF-e vinculada ao evento",oFont11b ,250)
oPrint:Say(nLin+990,110,MAMBIENTE,oFont11 ,80)
oPrint:Say(nLin+990,670,MCORGAO,oFont11 ,240)  /// estava comentado
oPrint:Say(nLin+990,1430,MNFE_CHV,oFont11 ,880)

oPrint:Say(nLin+1050,110,"Data e hora do recebimento do evento",oFont11b ,400)
oPrint:Say(nLin+1050,1430,"Sequencial do evento",oFont11b ,100)
oPrint:Say(nLin+1050,1890,"Vers?o do tipo do evento",oFont11b ,200)
oPrint:Say(nLin+1100,110,MDATE_EVEN+"  "+MTIME_EVEN,oFont11 ,200)
//oPrint:Say(1100,110,MDHEVENTO,oFont11 ,200)
oPrint:Say(nLin+1100,1430,MSEQEVENTO,oFont11 ,20)
oPrint:Say(nLin+1100,1890,MVERTPEVEN,oFont11 ,200)

oPrint:Say(nLin+1170,110,"Vers?o do aplicativo que",oFont11b ,100)
oPrint:Say(nLin+1210,110,"recebeu o evento",oFont11b ,100)
oPrint:Say(nLin+1170,670,"C?digo de status do registro do evento",oFont11b ,300)
oPrint:Say(nLin+1170,1430,"Descri??o literal do status de registro do evento",oFont11b ,300)
oPrint:Say(nLin+1260,110,MVERAPLIC,oFont11 ,80)
oPrint:Say(nLin+1220,670,MCSTATEVEN,oFont11 ,60)
oPrint:Say(nLin+1220,1430,MCMOTEVEN,oFont11 ,300)

oPrint:Say(nLin+1340,110,"Descri??o do evento",oFont11b ,100)
oPrint:Say(nLin+1390,110,MDESCEVEN,oFont11 ,100)

///
///Deixei um gap de 4 linhas para o texto - se o texto for maior ter? que alterar a linha onde comeca a Condicao de Uso
///
oPrint:Say(nLin+1450,110,"Texto da Carta de Corre??o",oFont11b ,300)
nLin += 1450
FOR iw1:=1 TO LEN(aCorrec)
	nLin += 50
	oPrint:Say(nLin,110,aCorrec[iw1],oFont11 ,2000)
NEXT

nLin += 250

oPrint:Say(nLin,110,"Condi??es de uso",oFont11b ,100)

FOR iw2:=1 TO LEN(aCondic)
	nLin += 50
	oPrint:Say(nLin,110,aCondic[iw2],oFont11 ,2000)
NEXT

oPrint:EndPage()

oPrint:Preview()

mv_par01 := _aPergs[1]
mv_par02 := _aPergs[2]
mv_par03 := _aPergs[3]

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
/////////////////////////////////////////////////////////
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={} //Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01          | DefSPA1 | DefEng1 | CNT01 | var02 | Def02           | DefSPA2 | DefEng2 | CNT02 | var03 | Def03    | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
aAdd(aRegs,{ cPerg,"01" , "S?rie                       ?",   ""   ,  ""    , "mv_ch1" , "C" ,   03   ,   0   ,   0   , "G" , "          "  , "mv_par01", "            " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
aAdd(aRegs,{ cPerg,"02" , "Nota Fiscal                 ?",   ""   ,  ""    , "mv_ch2" , "C" ,   09   ,   0   ,   0   , "G" , "          "  , "mv_par02", "            " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return


/*

oPrint:Line(150,1890,150,2400)
oPrint:Say(104,2020,"Carta de Corre??o",oFont11b ,160)
oPrint:Say(170,1920,"S?rie: "+mv_par01,oFont11b ,100)
oPrint:Say(240,1920,"N.Fiscal: "+mv_par02,oFont11b ,100)
oPrint:Say(310,1920,"Dt.Emiss?o: "+DTOC(dEmissao),oFont11b ,100)

oPrint:Box(420,100,2000,2400)

oPrint:Say(440,110,"Tipo do evento",oFont12b ,100)
oPrint:Say(440,850,"Data e hora",oFont12b ,100)
oPrint:Say(440,1890,"Protocolo",oFont12b ,100)
oPrint:Say(490,110,"Carta de Corre??o NFe",oFont11 ,100)
oPrint:Say(490,850,MDATE_EVEN+"  "+MTIME_EVEN,oFont11 ,140)
oPrint:Say(490,1890,MPROTOCOLO,oFont11 ,140)

oPrint:Say(580,110,"Identifica??o do destinat?rio",oFont11b ,200)
oPrint:Say(580,1430,"CNPJ/CPF",oFont11b ,200)
oPrint:Say(630,110,xDestinatario,oFont11b ,800)
oPrint:Say(630,1430,xCGC,oFont11b ,260)

oPrint:Say(740,110,"DADOS DO EVENTO DA CARTA DE CORRE??O",oFont11b ,250)
oPrint:Say(800,110,"Vers?o do evento",oFont11b ,100)
oPrint:Say(800,670,"Id evento",oFont11b ,100)
oPrint:Say(800,1890,"Tipo do evento",oFont11b ,100)
oPrint:Say(850,110,MVERSAO,oFont11 ,80)
oPrint:Say(850,670,MID_EVENTO,oFont11 ,400)
oPrint:Say(850,1890,MTPEVENTO,oFont11 ,120)

oPrint:Say(940,110,"Identifica??o do ambiente",oFont11b ,140)
oPrint:Say(940,670,"C?digo do ?rg?o de recep??o do evento",oFont11b ,240)
oPrint:Say(940,1430,"Chave de acesso da NF-e vinculada ao evento",oFont11b ,250)
oPrint:Say(990,110,MAMBIENTE,oFont11 ,80)
oPrint:Say(990,670,MCORGAO,oFont11 ,240)  /// estava comentado
oPrint:Say(990,1430,MNFE_CHV,oFont11 ,880)

oPrint:Say(1050,110,"Data e hora do recebimento do evento",oFont11b ,400)
oPrint:Say(1050,1430,"Sequencial do evento",oFont11b ,100)
oPrint:Say(1050,1890,"Vers?o do tipo do evento",oFont11b ,200)
oPrint:Say(1100,110,MDATE_EVEN+"  "+MTIME_EVEN,oFont11 ,200)
//oPrint:Say(1100,110,MDHEVENTO,oFont11 ,200)
oPrint:Say(1100,1430,MSEQEVENTO,oFont11 ,20)
oPrint:Say(1100,1890,MVERTPEVEN,oFont11 ,200)

oPrint:Say(1170,110,"Vers?o do aplicativo que",oFont11b ,100)
oPrint:Say(1210,110,"recebeu o evento",oFont11b ,100)
oPrint:Say(1170,670,"C?digo de status do registro do evento",oFont11b ,300)
oPrint:Say(1170,1430,"Descri??o literal do status de registro do evento",oFont11b ,300)
oPrint:Say(1260,110,MVERAPLIC,oFont11 ,80)
oPrint:Say(1220,670,MCSTATEVEN,oFont11 ,60)
oPrint:Say(1220,1430,MCMOTEVEN,oFont11 ,300)

oPrint:Say(1340,110,"Descri??o do evento",oFont11b ,100)
oPrint:Say(1390,110,MDESCEVEN,oFont11 ,100)

///
///Deixei um gap de 4 linhas para o texto - se o texto for maior ter? que alterar a linha onde comeca a Condicao de Uso
///
oPrint:Say(1450,110,"Texto da Carta de Corre??o",oFont11b ,300)
nLin := 1450
FOR iw1:=1 TO LEN(aCorrec)
	nLin += 50
	oPrint:Say(nLin,110,aCorrec[iw1],oFont11 ,2000)
NEXT
*
oPrint:Say(1700,110,"Condi??es de uso",oFont11b ,100)

*/