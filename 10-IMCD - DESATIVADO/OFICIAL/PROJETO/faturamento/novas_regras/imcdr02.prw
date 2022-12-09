#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PV     ³ Autor ³ Luiz A. Oliveira        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressão de ORÇAMENTO                                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#DEFINE IMP_SPOOL 2

//ORÇAMENTO --------------------------------------------------------------------------------------------------------------------------------

User Function IMCDR02()

//Pergunta
Local cPerg := 'CNTR02'
Local aArea := GetArea()
Local lConf := .F.
Local nI := 0 
Local nX := 0
Private oPrn

Private nLin := 0
//Fontes
Private oFont0	:= TFont():New( "Arial",,07,,.F.,,,,,.F.)
Private oFont0N	:= TFont():New( "Arial",,07,,.T.,,,,,.F.)
Private oFont1	:= TFont():New( "Arial",,08,,.F.,,,,,.F.)
Private oFont1N	:= TFont():New( "Arial",,08,,.T.,,,,,.F.)
Private oFont2	:= TFont():New( "Arial",,10,,.F.,,,,,.F.)
Private oFont2N	:= TFont():New( "Arial",,10,,.T.,,,,,.F.)
Private oFont3	:= TFont():New( "Arial",,12,,.F.,,,,,.F.)
Private oFont3N	:= TFont():New( "Arial",,12,,.T.,,,,,.F.)
Private oFont4	:= TFont():New( "Arial",,18,,.F.,,,,,.F.)
Private oFont4N	:= TFont():New( "Arial",,18,,.T.,,,,,.F.)
Private cStartPath := GetSrvProfString("Startpath","")

If oPrn == Nil
	lPreview := .T.
	cNome := substr(Time(),7,2)+substr(Time(),4,2)
	oPrn  := FWMSPrinter():New('imcdr01'+cNome,6,.F.,,.T.)
	oPrn:SetPortrait()
	oPrn:SetPaperSize(9)
	oPrn:Setup()
	oPrn:SetMargin(20,20,20,20)
	oPrn:cPathPDF :="C:\TEMP\"
EndIf

If Select("RMIN") > 0
	RMIN->( dbCloseArea() )
EndIf

oPrn:StartPage()

cQueryP := " SELECT * "
cQueryP += " FROM "+RetSqlName("SCJ")+" SCJ "
cQueryP += " WHERE SCJ.CJ_NUM = '" + SCJ->CJ_NUM + "' "
cQueryP += " AND CJ_FILIAL = '"+XFILIAL("SCJ")+"' "
cQueryP += " ORDER BY CJ_NUM "

TCQUERY cQueryP NEW ALIAS "RMIN"

DbSelectArea("RMIN")
DbGotop()

//CLIENTE
dbselectarea("SA1")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SA1")+ RMIN->CJ_CLIENTE+ RMIN->CJ_LOJA )

//vendedor
dbselectarea("SA3")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SA3")+ SA1->A1_VEND )

//DADOS DO MUNICIPIO
dbselectarea("CC2")
dbsetorder(2)
dbgotop()
dbseek(xfilial("CC2")+ SA1->A1_CODMUNE )

//CONDIÇÃO DE PAGAMENTO
dbselectarea("SE4")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SE4")+ RMIN->CJ_CONDPAG )

//TRANSPORTADORA
dbselectarea("SA4")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SA4")+ RMIN->CJ_XTRANSP )


dbselectarea("SCK")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SCK")+ RMIN->CJ_NUM )

// IMPRIMIR CABEçALHO

nLin := PRINTCABEC( 1 )

_nValIcm := _nValIpi := _nValPis := _nValCof := 0

vTotProd := vTotIpi := vTotICM := vTotLiq := vTotserv := vTotPis := vTotCof := Taxamoe := vTotReal := 0

While RMIN->CJ_NUM == SCK->CK_NUM
	
	// Calculo ST e Outros Impostos
	MaFisIni(SCJ->CJ_CLIENTE,SCJ->CJ_LOJA,"C","N",SA1->A1_TIPO,MaFisRelImp("MTR700",{"SCJ","SCK"}),,,"SB1","MTR700")
	MaFisAdd( SCK->CK_PRODUTO,;
	SCK->CK_TES,;
	SCK->CK_QTDVEN,;
	SCK->CK_PRUNIT,;
	SCK->CK_VALDESC,;
	"",;
	"",;
	0,;
	0,;
	0,;
	0,;
	0,;
	(SCK->CK_QTDVEN*SCK->CK_PRUNIT),;
	0,;
	0,;
	0)
	
	_nAliqIcm	:= MaFisRet(1,"IT_ALIQICM")
	_nAliqIpi	:= MaFisRet(1,"IT_ALIQIPI")
	_nAliqPis	:= MaFisRet(1,"IT_ALIQPS2") //MaFisRet(1,"IT_ALIQPIS")
	_nAliqCof	:= MaFisRet(1,"IT_ALIQCF2") //MaFisRet(1,"IT_ALIQCOF")
	
	
	cDescProd := alltrim(SCK->CK_DESCRI)
	
	oPrn:Say(nLin,0040, alltrim(SCK->CK_PRODUTO) ,oFont0,100)
	oPrn:Say(nLin,0100, SubStr( cDescProd, 1, 40) ,oFont0,100)
	oPrn:Say(nLin,0250, DTOC(SCK->CK_ENTREG) ,oFont0,100)
	oPrn:Say(nLin,0300, ALLTRIM(STR(SCK->CK_QTDVEN))+" "+SCK->CK_UM ,oFont0,100)
	oPrn:Say(nLin,0340,  IF(SCK->CK_XMOEDA = 1,"R$",IF(SCK->CK_XMOEDA = 4,"EUR","US$"))   ,oFont0,100)
	
	Taxamoe :=  IF(SCK->CK_XMOEDA = 1,1,SCK->CK_XTAXA )

	nPrcUni		:=	ROUND(SCK->CK_PRCVEN / Taxamoe,2)
	nPrcTot		:=	ROUND(nPrcUni * SCK->CK_QTDVEN,2)
	nPrcReal    :=  ROUND(SCK->CK_PRCVEN * SCK->CK_QTDVEN,2 )
	_nValIcm	:=	round(MaFisRet(1,"IT_VALICM") / Taxamoe,2)
	_nValIpi	:=	round(MaFisRet(1,"IT_VALIPI") / Taxamoe,2)
	_nValPis	:=	round(MaFisRet(1,"IT_VALPS2") / Taxamoe,2)
	_nValCof	:=	round(MaFisRet(1,"IT_VALCF2") / Taxamoe,2)
	
	
	MaFisEnd()
	
	oPrn:Say(nLin,0370,  ALLTRIM(STR(nPrcUni,10,2)) , oFont0,100)
	oPrn:Say(nLin,0420,  ALLTRIM(STR(nPrcTot,10,2)) , oFont0,100)
	oPrn:Say(nLin,0460,  ALLTRIM(STR(nPrcReal,10,2)) , oFont0,100)
	oPrn:Say(nLin,0500,  ALLTRIM(STR(_nAliqIcm)),oFont0,100)
	oPrn:Say(nLin,0525,  ALLTRIM(STR(_nAliqIpi)),oFont0,100)
	
	
	For nI := 41 To Len(cDescProd) Step 60
		nLin += 15
		oPrn:Say(nLin,0080, AllTrim(SubStr( cDescProd, nI, 60)) ,oFont0,100)
	Next

	dbselectarea("SB1")
	dbsetorder(1)
	dbgotop()
	dbseek(xfilial("SB1")+ SCK->CK_PRODUTO )
	
	cFabr := ""
	cOrigem := ""
	
	BSCFABR(SCK->CK_PRODUTO,@cFabr,@cOrigem)
	
	cEmb := Alltrim(POSICIONE("SZ2", 1, xFilial("SB1") + SB1->B1_EMB , "Z2_DESC" ))

	nLin += 15

	//oPrn:Say(nLin,0080 , "Fabricante:  "+ cFabr +" - Origem:  "+cOrigem   ,oFont1,100)
	oPrn:Say(nLin,0080 , "Embalagem:   "+ cEmb +" "+  Transform(SB1->B1_QE,"@E 999,999.99" )+SB1->B1_UM  ,oFont1,100)
	
	vTotProd += nPrcTot
	vTotReal += nPrcReal
	vTotIpi += _nValIpi
	vTotICM += _nValIcm
	vTotLiq += nPrcTot
	vTotserv := 0.0
	vTotCof += _nValCof
	vTotPis += _nValPis
	
	nLin := nLin + 15
	
	DbSelectArea("SCK")
	dbSkip()
	
	
	If nLin > 440
		PRINTRODAPE()
		
		oPrn:EndPage()
		oPrn:StartPage()
		
		// IMPRIMIR CABEçALHO
		nLin := PRINTCABEC( 1 )
		
	Endif
Enddo


nLin := nLin + 15

oPrn:Say(nLin,0040, "Valor Produtos " ,oFont1N,100)
oPrn:Say(nLin,0180, Transform(vTotProd,"@E 999,999.99" ) ,oFont1N,100)

nLin := nLin + 15
oPrn:Say(nLin,0040, "Valor Total em Reais R$ " ,oFont1N,100)
oPrn:Say(nLin,0180, Transform(vTotReal,"@E 999,999.99" ) ,oFont1N,100)

nLin := nLin + 15
oPrn:Say(nLin,0040, "Valor IPI " ,oFont1N,100)
oPrn:Say(nLin,0180, Transform(vTotIpi ,"@E 999,999.99" ) ,oFont1N,100)

nLin := nLin + 15
oPrn:Say(nLin,0040, "Valor ICM " ,oFont1N,100)
oPrn:Say(nLin,0180, Transform(vTotIcm ,"@E 999,999.99" ) ,oFont1N,100)

nLin := nLin + 15
oPrn:Say(nLin,0040, "Valor Liquido " ,oFont1N,100)
oPrn:Say(nLin,0180, Transform(vTotLiq,"@E 999,999.99" ) ,oFont1N,100)

nLin := nLin - 55
oPrn:Say(nLin,0300, "Valor Servico " ,oFont1N,100)
oPrn:Say(nLin,0440, Transform(vTotServ,"@E 999,999.99" ) ,oFont1N,100)

nLin := nLin + 15
oPrn:Say(nLin,0300, "Valor PIS " ,oFont1N,100)
oPrn:Say(nLin,0440, Transform(vTotPis ,"@E 999,999.99" ) ,oFont1N,100)

nLin := nLin + 15
oPrn:Say(nLin,0300, "Valor COFINS " ,oFont1N,100)
oPrn:Say(nLin,0440, Transform(vTotCof,"@E 999,999.99" ) ,oFont1N,100)

nLin := nLin + 15
oPrn:Say(nLin,0300, "Taxa Moeda " ,oFont1N,100)
oPrn:Say(nLin,0440, Transform(TaxaMoe ,"@E 9,999.9999" ) ,oFont1N,100)

nLin := nLin + 20
oPrn:Say(nLin,0040, "Obs/Pedido " ,oFont1N,100)
nLin := nLin + 10

aDados := zQLinha(ALLTRIM(SA1->A1_XOBSMTG), 150, , .T.)
For nX := 1 To Len(aDados)
        oPrn:Say(nLin, 0040, aDados[nX], oFont1,100)
        nLin := nLin + 10
Next

IF SCJ->CJ_XTPFRETE = "C"
	oPrn:Say(nLin,0040, "FRETE CIF",oFont1,100)
ELSEIF SCJ->CJ_XTPFRETE = "F"
	oPrn:Say(nLin,0040, "FRETE FOB",oFont1,100)
ELSEIF SCJ->CJ_XTPFRETE = "T"
	oPrn:Say(nLin,0040, "FRETE POR CONTA DE TERCEIROS",oFont1,100)
ELSE 
	oPrn:Say(nLin,0040, "SEM FRETE",oFont1,100)
ENDIF
nLin := nLin + 10

aDados := zQLinha(Alltrim(SCJ->CJ_XOBSFAT), 150, , .T.)
For nX := 1 To Len(aDados)
        oPrn:Say(nLin, 0040, aDados[nX], oFont1,100)
        nLin := nLin + 10
Next

nLin := nLin + 10
nLin := nLin + 45
nLin := nLin + 15

/*
DbSelectArea("RMIN")
DbGotop()

dbselectarea("SCK")
dbsetorder(1)
dbgotop()
dbseek(xfilial("SCK")+ RMIN->CJ_NUM )

While RMIN->CJ_NUM == SCK->CK_NUM
	
	dbselectarea("SB1")
	dbsetorder(1)
	dbgotop()
	dbseek(xfilial("SB1")+ SCK->CK_PRODUTO )
		
	oPrn:Say(nLin,0040, "Fabricante: Produto:  " + Alltrim(SCK->CK_PRODUTO) + "  -  Origem:  " + Alltrim(POSICIONE("SA2", 1, xFilial("SA2") + SB1->B1_FABRIC, "A2_NOME")) ,oFont1,100)
	nLin := nLin + 15
	oPrn:Say(nLin,040, "Embalagem: Produto:  " + Alltrim(SCK->CK_PRODUTO) + "  Saco(s) c/  " +  Transform(SB1->B1_QE,"@E 999,999.99" )  ,oFont1,100)
	
	nLin := nLin + 10
	oPrn:Line(nLin, 0040, nLin, 570, 0, "-1")
	nLin := nLin + 15
	
	DbSelectArea("SCK")
	dbSkip()
	
	
	If nLin > 650
		
		PRINTRODAPE()
		
		oPrn:EndPage()
		oPrn:StartPage()
		
		nLin := PRINTCABEC( 2 )
		
		nLin := 165
		
		oPrn:Say(nLin,0040, "Fabricante: Produto:  " + Alltrim(SCK->CK_PRODUTO) + "  -  Origem:  " + Alltrim(POSICIONE("SA2", 1, xFilial("SA2") + SB1->B1_FABRIC, "A2_NOME")) ,oFont1,100)
		
		nLin := nLin + 15
		
		oPrn:Say(nLin,040, "Embalagem: Produto:  " + Alltrim(SCK->CK_PRODUTO) + "  Saco(s) c/  " +  Transform(SB1->B1_QE,"@E 999,999.99" )  ,oFont1,100)
		
		nLin := nLin + 10
		oPrn:Line(nLin, 0040, nLin, 570, 0, "-1")
		nLin := nLin + 15
		
		DbSelectArea("SCK")
		dbSkip()
		
		
	Endif
	
Enddo
*/

PRINTRODAPE()

oPrn:EndPage()
RestArea(aArea)

If lPreview
	oPrn:Preview()
EndIf

FreeObj(oPrn)
oPrn := Nil

Return()


Static Function PRINTCABEC( nTipo )

Default nTipo := 1

oPrn:Say(0050,0150, AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ,oFont3N,100)
oPrn:Say(0065,0150, Capital( SM0->M0_ENDCOB ) ,oFont2N,100)
oPrn:Say(0080,0150, Alltrim(SM0->M0_CIDCOB) + " - "+SM0->M0_ESTCOB ,oFont2N,100)
oPrn:Say(0095,0150, "CNPJ..: "+	Transform(SM0->M0_CGC,"@r 99.999.999/9999-99")  ,oFont2N,100)
oPrn:Say(0110,0150, "Fone..: "+SM0->M0_TEL ,oFont2N,100)

oPrn:Say(0065,0420, "CEP.......: "+SM0->M0_CEPCOB ,oFont2N,100)
oPrn:Say(0095,0420, "Inscr.Est.: "+Transform(SM0->M0_INSC,"@r 999.999.999.99") ,oFont2N,100)
//oPrn:Say(0110,0420, "Fax.......: "+SM0->M0_TEL ,oFont2N,100)

oPrn:SayBitmap(0040, 0040,cStartPath+"FLWIMCDLG.bmp", 090, 0030)    //LOGO DA EMPRESA
oPrn:Line( 00125, 0040, 0125, 570, 0, "-1")

oPrn:Say(0140,0100, "ORÇAMENTO Nº.: " + ALLTRIM(SCJ->CJ_NUM) ,oFont3N,100)
oPrn:Say(0140,0380, "Emissão:  " + DTOC(SCJ->CJ_EMISSAO) ,oFont3N,100)
oPrn:Line( 00145, 0040, 0145, 570, 0, "-1")

nLin := 0

if nTipo == 1
	oPrn:Say(0165+nLin,0040, "Cliente       :    ["+SA1->A1_COD+"-"+SA1->A1_LOJA+"] "+Alltrim(SA1->A1_NOME) ,oFont2,100)
	oPrn:Say(0180+nLin,0040, "Endereço   :    " + Alltrim(SA1->A1_END)  ,oFont2,100)
	oPrn:Say(0195+nLin,0040, "Cidade       :    " + Alltrim(SA1->A1_MUN)  ,oFont2,100)
	
	oPrn:Say(0165+nLin,0380, "CNPJ     :    " + Alltrim(SA1->A1_CGC) ,oFont2,100)
	oPrn:Say(0180+nLin,0380, "BAIRRO :    " + Alltrim(SA1->A1_BAIRRO)  ,oFont2,100)
	oPrn:Say(0195+nLin,0380, "CEP       :    " + Alltrim(SA1->A1_CEP)+ " - "+ "ESTADO :" + Alltrim(SA1->A1_EST)  ,oFont2,100)
	
	oPrn:Say(0210+nLin,0040, "Fone          :    " + Alltrim(SA1->A1_DDD)+ "-" + Alltrim(SA1->A1_TEL)  ,oFont2,100)
	oPrn:Say(0225+nLin,0040, "Vendedor   :    " + Alltrim(SA3->A3_NOME) ,oFont2,100)
	oPrn:Say(0240+nLin,0040, "Cond.Pagto:    " + Alltrim(SE4->E4_DESCRI) ,oFont2,100)
	
	oPrn:Say(0255+nLin,0040, "Cobrança    :   " + If(!empty(SA1->A1_ENDCOB),Alltrim(SA1->A1_ENDCOB)+", " + Alltrim(SA1->A1_BAIRROC)+ ", " + Alltrim(SA1->A1_MUNC) + "-" + Alltrim(SA1->A1_ESTC)+", "+ Alltrim(SA1->A1_CEPC)," ") ,oFont2,100)
	
	oPrn:Say(0270+nLin,0040, "Local de Entrega  : " + If(!empty(SA1->A1_ENDENT),Alltrim(SA1->A1_ENDENT)+", "+ Alltrim(SA1->A1_BAIRROE)+", "+ Alltrim(SA1->A1_MUNE)+"-"+Alltrim(SA1->A1_ESTE)+", "+ Alltrim(SA1->A1_CEPE)," ") ,oFont2,100)
	oPrn:Say(0300+nLin,0040, "Transportadora    : ["+SA4->A4_COD+"] "+Alltrim(SA4->A4_NOME),oFont2,100)
	//oPrn:Say(0315+nLin,0040, "Pedido do Cliente : " + Alltrim(SCJ->CJ_COTCLI),oFont2,100)
	
	oPrn:Line( 00340+nLin, 0040, 0340+nLin, 570, 0, "-1")
	
	oPrn:Say(0350+nLin,0040, "Codigo        Descrição                                                                   Data              Qtde          Tipo             Preço               Valor        Valor           ICMS          IPI" ,oFont1N,100)
	oPrn:Say(0360+nLin,0040, "Produto       Produto                                                                    Entrega          Pedido      Moeda        Unitário           Produto        em Reais              %             %" ,oFont1N,100)
	
	oPrn:Line( 00365+nLin, 0040, 0365+nLin, 570, 0, "-1")
Endif
nLin := 380

RETURN(nLin)


Static Function PRINTRODAPE()
nLin := 0780
oPrn:Say( nLin ,0040, "Vendas/Pedido - "+ dtoc(DATE()) +" - "+ TIME() + SPACE(30) + "Usuário: " + LogUserName() ,oFont0,100)

Return()

Static Function	BSCFABR( cPrd,cFabr,cOrigem)
Local cAlias := GetNextAlias()

BeginSql Alias cAlias
	
	SELECT
	A5_FABR,A5_FALOJA, A2_COD,A2_LOJA , A2_NREDUZ ,A2_PAIS, YA_DESCR
	FROM %Table:SA5% PRDFAB, %Table:SA2% FAB
	LEFT JOIN %Table:SYA% PAIS ON  YA_FILIAL = %xFilial:SYA% AND YA_CODGI = A2_PAIS AND PAIS.%NotDel%
	WHERE A5_FILIAL = %xFilial:SA5%
	AND A5_PRODUTO = %Exp:cPrd%
	AND PRDFAB.%NotDel%
	AND A2_FILIAL = %xFilial:SA2%
	AND A2_COD||A2_LOJA = A5_FABR||A5_FALOJA
	AND FAB.%NotDel%
	
EndSql

dbSelectArea(cAlias)
dbGoTop()

cFabr := (cAlias)->A2_NREDUZ
cOrigem := (cAlias)->YA_DESCR

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

Return Nil


Static Function zQLinha(cTexto, nMaxCol, cQuebra, lTiraBra)
    Local aArea     := GetArea()
    Local aTexto    := {}
    Local aAux      := {}
    Local nAtu      := 0
    Default cTexto  := ''
    Default nMaxCol := 80
    Default cQuebra := ';'
    Default lTiraBra:= .T.
 
    //Quebrando o Array, conforme -Enter-
    aAux:= StrTokArr(cTexto,Chr(13))
     
    //Correndo o Array e retirando o tabulamento
    For nAtu:=1 TO Len(aAux)
        aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
    Next
     
    //Correndo as linhas quebradas
    For nAtu:=1 To Len(aAux)
     
        //Se o tamanho de Texto, for maior que o número de colunas
        If (Len(aAux[nAtu]) > nMaxCol)
         
            //Enquanto o Tamanho for Maior
            While (Len(aAux[nAtu]) > nMaxCol)
                //Pegando a quebra conforme texto por parâmetro
                nUltPos:=RAt(cQuebra,SubStr(aAux[nAtu],1,nMaxCol))
                 
                //Caso não tenha, a última posição será o último espaço em branco encontrado
                If nUltPos == 0
                    nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))
                EndIf
                 
                //Se não encontrar espaço em branco, a última posição será a coluna máxima
                If(nUltPos==0)
                    nUltPos:=nMaxCol
                EndIf
                 
                //Adicionando Parte da String (de 1 até a Úlima posição válida)
                aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))
                 
                //Quebrando o resto da String
                aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))
            EndDo
             
            //Adicionando o que sobrou
            aAdd(aTexto,aAux[nAtu])
        Else
            //Se for menor que o Máximo de colunas, adiciona o texto
            aAdd(aTexto,aAux[nAtu])
        EndIf
    Next
     
    //Se for para tirar os brancos
    If lTiraBra
        //Percorrendo as linhas do texto e aplica o AllTrim
        For nAtu:=1 To Len(aTexto)
            aTexto[nAtu] := Alltrim(aTexto[nAtu])
        Next
    EndIf
     
    RestArea(aArea)
Return aTexto
