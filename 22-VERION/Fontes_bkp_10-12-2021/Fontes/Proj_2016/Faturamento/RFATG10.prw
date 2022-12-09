#include "PROTHEUS.ch"
#include "RwMake.ch"
#include "TopConn.ch"
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RFATG10   ∫Autor  ≥CAVALINI            ∫ Data ≥ 01/10/2013  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Relatorio Analisis Proveedor - Faturamentos e DevoluÁıes   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico Verion                                          ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ

#############################################################################
## ImplementaÁıes realizados desde sua construÁ„o                          ##
## ======================================================================  ##
## DATA: 12/02/2013, AÁ„o: Convertido para TREPORT                         ##
##    Realizado por: Mauricio Mirotti - SIGATEK Inform·tica                ##
## ======================================================================  ##
## DATA: 12/02/2013, AÁ„o: Ajuste nas notas de devoluÁıes de Vendas        ##
## Ajustada Query de consulta para trazer todas as devoluÁıes de vendas    ##
## do periodo selecionado e n„o somente das vendas realizadas no periodo.  ##
##    Realizado por: Mauricio Mirotti - SIGATEK Inform·tica                ##
#############################################################################
*/
User Function RFATG10()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Declaracao de Variaveis                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Local oReport

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Interface de impressao                                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oReport:= ReportDef()
oReport:PrintDialog()

Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ReportDef ≥ Autor ≥Mauricio Mirotti       ≥ Data ≥28/01/2012≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriÁ„o ≥A funcao estatica ReportDef devera ser criada para todos os ≥±±
±±≥          ≥relatorios que poderao ser agendados pelo usuario.          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥Nenhum                                                      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ RFATG10                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ReportDef()

Local aOrdem    := {}
Local oLinha
Local titulo      := "Relatorio Analisis Proveedor"
Local nTamSN4  := TamSX3("D2_TOTAL"  )[1]
Local cPerg		:= "RFATG10"
Local cPictVal	:= "@e 999,999,999.99"
Local cPictPer	:= "@e 99,999.99"

Local cAliasTop := GetNextAlias()    

oReport:= TReport():New("RFATG10",titulo,"RFATG10", {|oReport| ReportPrint(oReport,aOrdem,cAliasTop)},"Este programa tem como objetivo imprimir o Relatorio de Analisis Proveedor.")
oReport:SetLandscape()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Verifica as Perguntas Seleciondas                                    ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
AjustaSX1(cPerg)
Pergunte(oReport:uParam,.F.)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Criacao da Sessao 1                    
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oLinha:= TRSection():New(oReport,titulo,{"SD2","SD1"},aOrdem,/*lLoadCells*/,/*lLoadOrder*/,,,,,,,,,,.F. /*AutoSize*/)
oLinha:SetTotalInLine(.F.)

TRCell():New(oLinha,'COL01'	,''	,"Rubro"				,/*Picture*/	,18			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COLPR'	,''	,"Produto"				,"@!"			,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL02'	,''	,"Coef.Lista Pcio"		,"@e 9,999"		,8			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COLDL'	,''	,"Dolar"				,cPictVal		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COLEU'	,''	,"Euro"					,cPictVal		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL03'	,''	,"Venta $"				,cPictVal		,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL04'	,''	,"Venta USD"			,cPictVal		,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL05'	,''	,"% Particip"			,cPictPer		,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL06'	,''	,"% Particip Acum."		,cPictPer		,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COLQT'	,''	,"Qtde Vdas"			,cPictVal		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COLMO'	,''	,"Moeda"				,				,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COLVL'	,''	,"Vlr Compra"			,cPictVal		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL07'	,''	,"Costo USD"			,cPictVal		,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL08'	,''	,"Margem USD"			,cPictVal		,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL09'	,''	,"Margem %"				,cPictPer		,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COLQD'	,''	,"Qtde Stock"			,cPictVal		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL10'	,''	,"Stock Dolarizado"+CRLF+Dtoc(mv_par14)	,cPictVal	,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL11'	,''	,"Rentabilidade %"						,/*Picture*/,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL12'	,''	,"Rotacion"+CRLF+"Productos DIAS"		,cPictPer	,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL13'	,''	,"Rotacion"+CRLF+"Financiero DIAS"		,cPictPer	,nTamSN4	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,'COL14'	,''	,"Observaciones s/"+CRLF+"Margen de Venta",/*Picture*/,30		,/*lPixel*/,/*{|| code-block de impressao }*/)

oLinha:SetHeaderPage()
oLinha:SetReadOnly()

Return(oReport)


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ReportPrint ≥ Autor ≥Mauricio Mirotti     ≥ Data ≥28/01/2012≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriÁ„o ≥A funcao estatica ReportPrint devera ser criada para todos  ≥±±
±±≥          ≥os relatorios que poderao ser agendados pelo usuario.       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥Nenhum                                                      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ExpO1: Objeto Report do Relatorio                           ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ RFATG10			                                          ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasTop)

Local oLinha 	:= oReport:Section(1)

Local cTxt,nRegCount,cVend1,cVend2,cChave,nValLiq,nValBru,cQuery,cFilDe,cFilAte,cDocDe,cDocAte,cSerDe,cSerAte,cCliDe,cCliAte,cLjDe,cLjAte,cDtDe,cDtAte,cProdDe,cProdAte,cFiltro,cCFDe,cCFAte,nUsaFil,nAnaSin,cData,cRazao
Local cgrupo,cmoedg,cDesMo,nfator,nVlCom,nVlVen,cFiltr0,cFiltr1,cFiltr2
Local cCFODev	:= SuperGetMV("ES_CFOPDEV",.f.,"'1201','1202','2201','2202','3201','3202'")

cFilDe  := MV_PAR01
cFilAte := MV_PAR02
cDocDe  := MV_PAR03
cDocAte := MV_PAR04
cSerDe  := MV_PAR05
cSerAte := MV_PAR06
cCliDe  := MV_PAR07
cCliAte := MV_PAR08
cLjDe   := MV_PAR09
cLjAte  := MV_PAR10
cProdDe := MV_PAR11
cProdAte:= MV_PAR12
cDtDe   := MV_PAR13
cDtAte  := MV_PAR14
cCFDe   := MV_PAR15
cCFAte  := MV_PAR16
nUsaFil := MV_PAR17
cFiltro := MV_PAR18
cFiltr1 := MV_PAR25
cFiltr2 := MV_PAR26
CDOALM  := MV_PAR20
CATALM  := MV_PAR21
CDOGRPO := MV_PAR22
CATGRPO := MV_PAR23
cAnaSin := MV_PAR19

cTxt      := ""
cChave    := ""
nRegCount := 0

If Select("WorkS") > 0
	WorkS->(dbCloseArea())
EndIf


cQuery := "Select "+CRLF
cQuery += " B1_GRUPO,BM_DESC,BM_FATOR,SUM(D2_QUANT) as D2_QUANT, SUM(D2_VALBRUT) AS D2_VALBRUT ,B1_VERCOM,B1_UPRC,D2_COD,BM_MOEDA "+CRLF
cQuery += " From (" +CRLF

cQuery += " SELECT B1_GRUPO,BM_DESC,BM_FATOR,D2_QUANT,D2_VALBRUT,B1_VERCOM,B1_UPRC,D2_COD,BM_MOEDA"+CRLF
cQuery += "  FROM " +RetSqlName("SD2") + " SD2"+CRLF
cQuery += "  INNER JOIN " +RetSqlName("SB1") + " SB1 ON B1_FILIAL = D2_FILIAL AND "+CRLF
cQuery += "                           					B1_COD = D2_COD       AND "+CRLF
cQuery += "                                             B1_GRUPO BETWEEN '"+CDOGRPO+"' AND '"+CATGRPO+"' AND "+CRLF
cQuery += "      					                    SB1.D_E_L_E_T_ = ''"+CRLF
cQuery += "  INNER JOIN " +RetSqlName("SBM") + " SBM ON BM_FILIAL = D2_FILIAL AND "+CRLF
cQuery += "                           					BM_GRUPO  = B1_GRUPO  AND "+CRLF
cQuery += "                           					SBM.D_E_L_E_T_ = ''"+CRLF
cQuery += " WHERE D2_FILIAL BETWEEN '"+cFilDe+"'      AND '"+cFilAte+"' "+CRLF
cQuery += " AND D2_DOC BETWEEN      '"+cDocDe+"'      AND '"+cDocAte+"' "+CRLF
cQuery += " AND D2_SERIE BETWEEN    '"+cSerDe+"'      AND '"+cSerAte+"' "+CRLF
cQuery += " AND D2_CLIENTE BETWEEN  '"+cCliDe+"'      AND '"+cCliAte+"' "+CRLF
cQuery += " AND D2_LOJA BETWEEN     '"+cLjDe+"'       AND '"+cLjAte+"' "+CRLF
cQuery += " AND D2_EMISSAO BETWEEN  '"+DtoS(cDtDe)+"' AND '"+DtoS(cDtAte)+"' "+CRLF
cQuery += " AND D2_COD BETWEEN      '"+cProdDe+"'     AND '"+cProdAte+"' "+CRLF
Iif((nUsaFil)==2,cQuery += " AND D2_CF BETWEEN '"+cCFDe+"' AND '"+cCFAte+"' "+CRLF,)  // Utiliza Filtro? (NAO)
IF (nUsaFil)==1
   IF !EMPTY(AllTrim(cFiltro))
      cFiltr0 := Alltrim(cFiltro)
   ENDIF
   IF !EMPTY(AllTrim(cFiltr1))
      cFiltr0 := cFiltr0+","+Alltrim(cFiltr1)
   ENDIF
   //IF !EMPTY(AllTrim(cFiltr2))
   //   cFiltr0 := cFiltr0+","+cFiltr2
   //ENDIF
   cQuery += " AND D2_CF IN ("+AllTrim(cFiltr0)+") "+CRLF
ENDIF
cQuery += " AND SD2.D_E_L_E_T_=' ' "+CRLF

//##################################################
//## Inclui DevoluÁ„o
IF MV_PAR24 = 1
	cQuery += "Union All "+CRLF
	
	cQuery += "SELECT B1_GRUPO,BM_DESC,BM_FATOR,D1_QUANT*(-1) as D2_QUANT,D1_TOTAL*(-1) as D2_VALBRUT,B1_VERCOM,B1_UPRC,D1_COD as D2_COD,BM_MOEDA"+CRLF
	cQuery += " FROM " + RetSqlName("SD1") + " SD1 " 
	cQuery += "  INNER JOIN " +RetSqlName("SB1") + " SB1 ON B1_FILIAL = D1_FILIAL AND "+CRLF
	cQuery += "                           					B1_COD = D1_COD       AND "+CRLF
	cQuery += "                                             B1_GRUPO BETWEEN '"+CDOGRPO+"' AND '"+CATGRPO+"' AND "+CRLF
	cQuery += "      					                    SB1.D_E_L_E_T_ = ''"+CRLF
	cQuery += "  INNER JOIN " +RetSqlName("SBM") + " SBM ON BM_FILIAL = D1_FILIAL AND "+CRLF
	cQuery += "                           					BM_GRUPO  = B1_GRUPO  AND "+CRLF
	cQuery += "                           					SBM.D_E_L_E_T_ = ''"+CRLF
	cQuery += " WHERE SD1.D1_FILIAL  = '" + xFilial("SD1") + "'"
	cQuery += " AND D1_DOC BETWEEN      '"+cDocDe+"'      AND '"+cDocAte+"' "+CRLF
	cQuery += " AND D1_SERIE BETWEEN    '"+cSerDe+"'      AND '"+cSerAte+"' "+CRLF
	cQuery += " AND D1_FORNECE BETWEEN  '"+cCliDe+"'      AND '"+cCliAte+"' "+CRLF
	cQuery += " AND D1_LOJA BETWEEN     '"+cLjDe+"'       AND '"+cLjAte+"' "+CRLF
	cQuery += " AND D1_EMISSAO BETWEEN  '"+DtoS(cDtDe)+"' AND '"+DtoS(cDtAte)+"' "+CRLF
	cQuery += " AND D1_COD BETWEEN      '"+cProdDe+"'     AND '"+cProdAte+"' "+CRLF
	cQuery += " AND SD1.D1_TIPO = 'D'"+CRLF
	If !Empty(cFiltr2)
		cQuery += " AND SD1.D1_CF IN ("+cFiltr2+") "+CRLF
	Endif
	cQuery += " AND SD1.D_E_L_E_T_ = ' '"+CRLF
Endif
	
cQuery += " ) TRB "+CRLF
cQuery += "Group By B1_GRUPO,BM_DESC,BM_FATOR,B1_VERCOM,B1_UPRC,D2_COD,BM_MOEDA "+CRLF
cQuery += " ORDER BY B1_GRUPO,D2_COD"+CRLF

MEMOWRIT("RFATG10_1.SQL",cQuery)
tcQuery cQuery New Alias "WorkS"

oReport:SetMeter(WorkS->(RecCount()))

dbSelectArea("WorkS")
WorkS->(dbGoTop())
_cGrupo  := WorkS->B1_GRUPO
_NQTDE   := 0   // SOMA QTDADE
_NVLRV   := 0   // SOMA VALOR BRUTO
_NPARC   := 0   // % PARTICIP
_NPARA   := 0   // % PARTICIP ACUM
_NLPRD   := 0   // QTDADDE LINHAS POR PRODUTO
_NVLCP   := 0   // SOMA VALOR DE COMPRA
_NCOST   := 0   // COSTO USD
_NMRUS   := 0   // MARGEM USD
_NPCMR   := 0   // MARGEM %
_CPREST  := ""  // PRODUTO PARA ANALISE DE ESTOQUE NO GRUPO
_NQTDEST := 0   // QTDADE DO ESTOQUE
_NVLREST := 0   // VALOR DO ESTOQUE
_NRENTAB := 0   // RENTABILIDADE %
_CDEGRU  := ""  // DESCRICAO DO GRUPO
NFATOR   := 0   // BM_FATOR
cmoedg   := ""  // BM_MOEDA
nDola    := 0   // M2_MOEDA2
nEuro    := 0   // M2_MOEDA4
nReal    := 0   // B1_UPRC 
_NVLQDEV := 0
_NVLRDEV := 0
nDola    := IIF(Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA2") > 0,Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA2"),1)

While WorkS->(!EOF())

		_NVLRV   += (WorkS->D2_VALBRUT * NDOLA) // SOMA VALOR BRUTO EM DOLAR

		IF _CPREST <> WorkS->D2_COD

           // DEVOLUCAO 
           //IF MV_PAR24 = 1     
           //   _ADEVG10 := PRCDVG10(WorkS->D2_COD)
           //   _NVLQDEV += IIF(cmoedg="R",((_ADEVG10[1]*nReal)/nDola) ,IIF(cmoedg="D",(_ADEVG10[1]*WorkS->B1_VERCOM),((_ADEVG10[1]*(WorkS->B1_VERCOM*nEuro))/nDola)))  // VALOR QTDE DEV
           //   _NVLRDEV += _ADEVG10[2] // VALOR DEVOLUCAO
           //ENDIF  

		   _CPREST  := WorkS->D2_COD

		ENDIF

		WorkS->(dbSkip())
		LOOP
		nRegCount++
End

// DEVOLUCAO 
//IF MV_PAR24 = 1     
//	_NVLRV  -= _NVLRDEV 
//ENDIF  

oLinha:Init()
IF MV_PAR19 = 1  // SINTETICO
	
	dbSelectArea("WorkS")
	WorkS->(dbGoTop())

	oLinha:Cell("COLPR"):Disable()
	oLinha:Cell("COLDL"):Disable()
	oLinha:Cell("COLEU"):Disable()
	oLinha:Cell("COLQT"):Disable()
	oLinha:Cell("COLMO"):Disable()
	oLinha:Cell("COLVL"):Disable()
	oLinha:Cell("COLQD"):Disable()

	While WorkS->(!EOF())
		oReport:IncMeter()
		
		_cGrupo  := WorkS->B1_GRUPO
		_NQTDE   := 0   // SOMA QTDADE
		_NVLRT   := 0   // SOMA VALOR BRUTO
		_NPARC   := 0   // % PARTICIP
//		_NPARA   := 0   // % PARTICIP ACUM
		_NLPRD   := 0   // QTDADDE LINHAS POR PRODUTO
		_NVLCP   := 0   // SOMA VALOR DE COMPRA
		_NCOST   := 0   // COSTO USD
		_NMRUS   := 0   // MARGEM USD
		_NPCMR   := 0   // MARGEM %
		_CPREST  := ""  // PRODUTO PARA ANALISE DE ESTOQUE NO GRUPO
		_NQTDEST := 0   // QTDADE DO ESTOQUE
		_NVLREST := 0   // VALOR DO ESTOQUE
		_NRENTAB := 0   // RENTABILIDADE %
		_CDEGRU  := ""  // DESCRICAO DO GRUPO
		NFATOR   := 0   // BM_FATOR
		cmoedg   := ""  // BM_MOEDA
		nDola    := 0   // M2_MOEDA2
		nEuro    := 0   // M2_MOEDA4
		nReal    := 0   // B1_UPRC 
        _ADEVG10 := {}
        _NVLQDEV := 0
        _NVLRDEV := 0
		
		_CDEGRU  := WorkS->B1_GRUPO+" "+WorkS->BM_DESC
		NFATOR   := WorkS->BM_FATOR
		cmoedg   := WorkS->BM_MOEDA
		nDola    := IIF(Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA2") > 0,Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA2"),1)
		nEuro    := IIF(Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA4") > 0,Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA4"),1)
		
		WHILE _CGRUPO == WorkS->B1_GRUPO

			nReal    := IIF(WorkS->B1_UPRC > 0,WorkS->B1_UPRC,1)
			_NVLRT   += WorkS->D2_VALBRUT  // SOMA VALOR BRUTO
		    _NVLCP   += IIF(cmoedg="R",((WorkS->D2_QUANT*nReal)/nDola) ,IIF(cmoedg="D",(WorkS->D2_QUANT*WorkS->B1_VERCOM),((WorkS->D2_QUANT*(WorkS->B1_VERCOM*nEuro))/nDola)))  // VALOR DE COMPRA CONFORME VAN...		
			
			IF _CPREST <> WorkS->D2_COD
				_NQTDEST := EstoqueINI(WorkS->D2_COD,MV_PAR14)
				_NVLREST += IIF(cmoedg="R",((_NQTDEST*nReal)/nDola) ,IIF(cmoedg="D",(_NQTDEST*WorkS->B1_VERCOM),((_NQTDEST*(WorkS->B1_VERCOM*nEuro))/nDola)))  // VALOR DO ESTOQUE

                // DEVOLUCAO 
                //IF MV_PAR24 = 1     
                //  _ADEVG10 :=  PRCDVG10(WorkS->D2_COD)
                //  _NVLQDEV += IIF(cmoedg="R",((_ADEVG10[1]*nReal)/nDola) ,IIF(cmoedg="D",(_ADEVG10[1]*WorkS->B1_VERCOM),((_ADEVG10[1]*(WorkS->B1_VERCOM*nEuro))/nDola)))  // VALOR QTDE DEV
                //  _NVLRDEV +=_ADEVG10[2] // VALOR DEVOLUCAO
                //ENDIF  

				_CPREST  := WorkS->D2_COD
			ENDIF
			
			
			WorkS->(dbSkip())
			LOOP
		End

        // DEVOLUCAO 
        //IF MV_PAR24 = 1
        //   _NVLCP -= _NVLQDEV
        //   _NVLRT -= _NVLRDEV              
        //ENDIF  

		_NCOST   := ROUND(_NVLCP,2)                                      // COSTO USD  ==> ((QTDE VENDA X (VALOR COMPRA X DOLAR OU EURO DO ULTIMO DIA)/ DOLAR DO ULTIMO DIA)
		_NMRUS   := ROUND(((_NVLRT*NDOLA)-_NCOST),2)                     // MARGEM USD ==> VENTA USD - COSTO USD
		_NPCMR   := ROUND(((_NMRUS/(_NVLRT*NDOLA))*100),2)               // MARGEM %
		_NRENTAB := ROUND(((_NMRUS/_NVLREST)*100),2)                     // RENTABILIDADE %
		_NPRDDIA := ROUND(((_NVLREST/_NCOST)*30),2)                      // Rotacion Productos DIAS
		_NFINDIA := ROUND(((_NVLREST/(_NVLRT*NDOLA))*30),2)              // Rotacion FINANC DIAS
		_NPARC   := ROUND((((_NVLRT*NDOLA)/_NVLRV)*100) ,2)
		_NPARA   += ROUND((((_NVLRT*NDOLA)/_NVLRV)*100) ,2)
		
		oLinha:Cell('COL01'		):SetValue( _CDEGRU )
		oLinha:Cell('COL02'		):SetValue( NFATOR )
		oLinha:Cell('COL03'		):SetValue( _NVLRT )
		oLinha:Cell('COL04'		):SetValue( _NVLRT*NDOLA )
		oLinha:Cell('COL05'		):SetValue( _NPARC )
		oLinha:Cell('COL06'		):SetValue( _NPARA )
		oLinha:Cell('COL07'		):SetValue( _NCOST )
		oLinha:Cell('COL08'		):SetValue( _NMRUS )
		oLinha:Cell('COL09'		):SetValue( _NPCMR )
		oLinha:Cell('COL10'		):SetValue( _NVLREST )
		oLinha:Cell('COL11'		):SetValue( _NRENTAB )
		oLinha:Cell('COL12'		):SetValue( _NPRDDIA )
		oLinha:Cell('COL13'		):SetValue( _NFINDIA )
		oLinha:Cell('COL14'		):SetValue( "" )

		oLinha:PrintLine()

	End

ELSE

	dbSelectArea("WorkS")
	WorkS->(dbGoTop())
	While WorkS->(!EOF())
		oReport:IncMeter()
		
		_cGrupo  := WorkS->B1_GRUPO
		_CCDPRD  := WorkS->D2_COD
		_NQTDE   := 0   // SOMA QTDADE
		_NVLRT   := 0   // SOMA VALOR BRUTO
		_NPARC   := 0   // % PARTICIP
//		_NPARA   := 0   // % PARTICIP ACUM
		_NLPRD   := 0   // QTDADDE LINHAS POR PRODUTO
		_NVLCP   := 0   // SOMA VALOR DE COMPRA
		_NCOST   := 0   // COSTO USD
		_NMRUS   := 0   // MARGEM USD
		_NPCMR   := 0   // MARGEM %
		_CPREST  := ""  // PRODUTO PARA ANALISE DE ESTOQUE NO GRUPO
		_NQTDEST := 0   // QTDADE DO ESTOQUE
		_NVLREST := 0   // VALOR DO ESTOQUE
		_NRENTAB := 0   // RENTABILIDADE %
		_NVLCMPO := 0   //  VALOR DE COMPRA
		_CDEGRU  := ""  // DESCRICAO DO GRUPO
		NFATOR   := 0   // BM_FATOR
		cmoedg   := ""  // BM_MOEDA
		nDola    := 0   // M2_MOEDA2
		nEuro    := 0   // M2_MOEDA4
		nReal    := 0   // B1_UPRC 
        _ADEVG10 := {}
        _NVLQDEV := 0
        _NVLRDEV := 0

		
		_CDEGRU  := WorkS->B1_GRUPO+" "+WorkS->BM_DESC
		NFATOR   := WorkS->BM_FATOR
		cmoedg   := WorkS->BM_MOEDA
		nDola    := IIF(Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA2") > 0,Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA2"),1)
		nEuro    := IIF(Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA4") > 0,Posicione("SM2",1,DTOS(MV_PAR14),"M2_MOEDA4"),1)
		nReal    := IIF(WorkS->B1_UPRC > 0,WorkS->B1_UPRC,1)
		
		WHILE _CGRUPO == WorkS->B1_GRUPO .AND. _CCDPRD == WorkS->D2_COD
			_NQTDE   += WorkS->D2_QUANT    // SOMA QTDADE
			_NVLRT   += WorkS->D2_VALBRUT  // SOMA VALOR BRUTO
			
			IF _CPREST <> WorkS->D2_COD
				_NQTDEST := EstoqueINI(WorkS->D2_COD,MV_PAR14)
				_NVLREST += IIF(cmoedg="R",((_NQTDEST*nReal)/nDola) ,IIF(cmoedg="D",(_NQTDEST*WorkS->B1_VERCOM),((_NQTDEST*(WorkS->B1_VERCOM*nEuro))/nDOLA)))  // VALOR DO ESTOQUE
 		        _NVLCMPO := IIF(cmoedg="R",nReal,WorkS->B1_VERCOM)  //  VALOR DE COMPRA

                // DEVOLUCAO 
                //IF MV_PAR24 = 1     
                //  _ADEVG10 :=  PRCDVG10(WorkS->D2_COD)
                //  _NVLQDEV := IIF(cmoedg="R",((_ADEVG10[1]*nReal)/nDola) ,IIF(cmoedg="D",(_ADEVG10[1]*WorkS->B1_VERCOM),((_ADEVG10[1]*(WorkS->B1_VERCOM*nEuro))/nDola)))  // VALOR QTDE DEV
                //  _NVLRDEV :=_ADEVG10[2] // VALOR DEVOLUCAO
                //ENDIF  
				_CPREST  := WorkS->D2_COD
			ENDIF
			
			WorkS->(dbSkip())
			LOOP
		End

        // DEVOLUCAO 
        //IF MV_PAR24 = 1
        //   _NVLCP -= _NVLQDEV
        //   _NVLRT -= _NVLRDEV              
        //ENDIF  

		_NVLCP   := IIF(cmoedg="R",((_NQTDE*_NVLCMPO)/nDola) ,IIF(cmoedg="D",(_NQTDE*_NVLCMPO),((_NQTDE*(_NVLCMPO*nEuro))/nDola)))  // VALOR DE COMPRA CONFORME VAN...		
		_NCOST   := ROUND(_NVLCP,2)                                      // COSTO USD  ==> ((QTDE VENDA X (VALOR COMPRA X DOLAR OU EURO DO ULTIMO DIA)/ DOLAR DO ULTIMO DIA)
		_NMRUS   := ROUND(((_NVLRT*NDOLA)-_NCOST),2)                     // MARGEM USD ==> VENTA USD - COSTO USD
		_NPCMR   := ROUND(((_NMRUS/(_NVLRT*NDOLA))*100),2)               // MARGEM %
		_NRENTAB := ROUND(((_NMRUS/_NVLREST)*100),2)                     // RENTABILIDADE %
		_NPRDDIA := ROUND(((_NVLREST/_NCOST)*30),2)                      // Rotacion Productos DIAS
		_NFINDIA := ROUND(((_NVLREST/(_NVLRT*NDOLA))*30),2)              // Rotacion FINANC DIAS
		_NPARC   := ROUND((((_NVLRT*NDOLA)/_NVLRV)*100) ,2)
		_NPARA   += ROUND((((_NVLRT*NDOLA)/_NVLRV)*100) ,2)

		
		oLinha:Cell('COL01'		):SetValue( _CDEGRU )
		oLinha:Cell('COLPR'		):SetValue( _CCDPRD )
		oLinha:Cell('COL02'		):SetValue( NFATOR )
		oLinha:Cell('COLDL'		):SetValue( NDOLA )
		oLinha:Cell('COLEU'		):SetValue( NEURO )
		oLinha:Cell('COL03'		):SetValue( _NVLRT )
		oLinha:Cell('COL04'		):SetValue( _NVLRT*NDOLA )
		oLinha:Cell('COL05'		):SetValue( _NPARC )
		oLinha:Cell('COL06'		):SetValue( _NPARA )

		oLinha:Cell('COLQT'		):SetValue( _NQTDE )
		oLinha:Cell('COLMO'		):SetValue( cmoedg )
		oLinha:Cell('COLVL'		):SetValue( _NVLCMPO )
		
		oLinha:Cell('COL07'		):SetValue( _NCOST )
		oLinha:Cell('COL08'		):SetValue( _NMRUS )
		oLinha:Cell('COL09'		):SetValue( _NPCMR )
		oLinha:Cell('COLQD'		):SetValue( _NQTDEST )
		oLinha:Cell('COL10'		):SetValue( _NVLREST )
		oLinha:Cell('COL11'		):SetValue( _NRENTAB )
		oLinha:Cell('COL12'		):SetValue( _NPRDDIA )
		oLinha:Cell('COL13'		):SetValue( _NFINDIA )
		oLinha:Cell('COL14'		):SetValue( "" )

		oLinha:PrintLine()
	End
	
ENDIF

oLinha:Finish()

Return(Nil)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AjustaSX1 ∫Autor  ≥Mauricio Mirotti    ∫ Data ≥  09/28/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AjustaSX1(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01"  ,"Da Filial                 "	,""      ,""     ,"MV_CH1","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR01",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"02"  ,"Ate Filial                "	,""      ,""     ,"MV_CH2","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR02",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"03"  ,"Da NF Entrada/SaÌda       "	,""      ,""     ,"MV_CH3","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR03",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"04"  ,"Ate NF Entrada/SaÌda      "	,""      ,""     ,"MV_CH4","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR04",""         			,""      ,""      ,""   ,""         ,""            	    	,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"05"  ,"Da Serie NF Entrada/SaÌda "	,""      ,""     ,"MV_CH5","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR05",""         			,""      ,""      ,""   ,""         ,""            		    ,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"06"  ,"Ate Serie NF Entrada/SaÌda"	,""      ,""     ,"MV_CH6","C"    ,03      ,0       ,0     ,"G" ,""    ,"MV_PAR06",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"07"  ,"Do Fornecedor/Cliente     "	,""      ,""     ,"MV_CH7","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR07",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"08"  ,"Ate Fornecedor/Cliente    "	,""      ,""     ,"MV_CH8","C"    ,06      ,0       ,0     ,"G" ,""    ,"MV_PAR08",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"09"  ,"Da Loja                   "	,""      ,""     ,"MV_CH9","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR09",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"10"  ,"Ate Loja                  "	,""      ,""     ,"MV_CHA","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR10",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""            	    ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"11"  ,"Do Produto                "	,""      ,""     ,"MV_CHB","C"    ,15      ,0       ,0     ,"G" ,""    ,"MV_PAR11",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SB1"})
aAdd(aRegs,{cPerg,"12"  ,"Ate Produto               "	,""      ,""     ,"MV_CHC","C"    ,15      ,0       ,0     ,"G" ,""    ,"MV_PAR12",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SB1"})
aAdd(aRegs,{cPerg,"13"  ,"Da DigitaÁ„o/Emiss„o      "	,""      ,""     ,"MV_CHD","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR13",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"14"  ,"Ate DigitaÁ„o/Emiss„o     "	,""      ,""     ,"MV_CHE","D"    ,08      ,0       ,0     ,"G" ,""    ,"MV_PAR14",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"15"  ,"Da CFOP                   "	,""      ,""     ,"MV_CHF","C"    ,04      ,0       ,0     ,"G" ,""    ,"MV_PAR15",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"16"  ,"Ate CFOP                  "	,""      ,""     ,"MV_CHG","C"    ,04      ,0       ,0     ,"G" ,""    ,"MV_PAR16",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"17"  ,"Utiliza Filtro?           "	,""      ,""     ,"MV_CHH","N"    ,01      ,0       ,0     ,"C" ,""    ,"MV_PAR17","Sim"      			,""      ,""      ,""   ,""         ,"N„o"             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"18"  ,"Filtro CFOP Vda:          "	,""      ,""     ,"MV_CHI","C"    ,99      ,0       ,0     ,"G" ,""    ,"MV_PAR18",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"19"  ,"AnalÌtico/SintÈtico       "	,""      ,""     ,"MV_CHJ","N"    ,01      ,0       ,0     ,"C" ,""    ,"MV_PAR19","SintÈtico"        	,""      ,""      ,""   ,""         ,"AnalÌtico"         	,""      ,""      ,""    ,""        ,""                	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"20"  ,"Do Almox                  "	,""      ,""     ,"MV_CHK","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR20",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"21"  ,"Ate Almox                 "	,""      ,""     ,"MV_CHL","C"    ,02      ,0       ,0     ,"G" ,""    ,"MV_PAR21",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"22"  ,"Do Grupo                  "	,""      ,""     ,"MV_CHM","C"    ,04      ,0       ,0     ,"G" ,""    ,"MV_PAR22",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SBM"})
aAdd(aRegs,{cPerg,"23"  ,"Ate Grupo                 "	,""      ,""     ,"MV_CHN","C"    ,04      ,0       ,0     ,"G" ,""    ,"MV_PAR23",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,"SBM"})
aAdd(aRegs,{cPerg,"24"  ,"Considera Devolucao       "	,""      ,""     ,"MV_CHO","N"    ,01      ,0       ,0     ,"C" ,""    ,"MV_PAR24","Sim"              	,""      ,""      ,""   ,""         ,"Nao"               	,""      ,""      ,""    ,""        ,""                	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"25"  ,"Filtro CFOP Vda:          "	,""      ,""     ,"MV_CHP","C"    ,99      ,0       ,0     ,"G" ,""    ,"MV_PAR25",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })
aAdd(aRegs,{cPerg,"26"  ,"Filtro CFOP Dev:          "	,""      ,""     ,"MV_CHQ","C"    ,99      ,0       ,0     ,"G" ,""    ,"MV_PAR26",""         			,""      ,""      ,""   ,""         ,""             		,""      ,""      ,""    ,""        ,""             	,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,""    ,""   })

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf
Next

DbSelectArea(_sAlias)

Return Nil


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥EstoqueINI∫Autor  ≥Microsiga           ∫ Data ≥  10/26/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function EstoqueINI(CPRODT,_DDTSLD)
Local aArea    := GetArea()
Local aRet	   := { '', 0 }
Local dData    :=  _DDTSLD
Local cProduto :=  CPRODT

cRet := 0

DbSelectArea("SB2")
DbSetOrder(1)
dbgotop()
IF DbSeek( xFilial("SB2") + alltrim(cProduto) )
	While !Eof() .and. alltrim(cProduto) == alltrim(SB2->B2_COD)
		
		If SB2->B2_LOCAL < MV_PAR20 .or. SB2->B2_LOCAL > MV_PAR21
			DbSkip()
			Loop
		Endif
		
		cRet += CalcEst(cProduto,SB2->B2_LOCAL, dData  )[1]
		
		DbSelectArea('SB2')
		DbSkip()
	End
ENDIF

RestArea( aArea )
return(cRet)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PRCDVG10  ∫Autor  ≥Microsiga           ∫ Data ≥  10/26/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ FUNCAO PARA TRATAMENTO DE DEVOLUCAO                        ∫±±
±±∫          ≥ FUN«√O DESABILITADA POIS AS DEVOLU«’ES ESTAO SENDO BUSCADAS∫±±
±±∫          ≥ NA QUERY (Mauricio Mirotti - 17/02/2014)                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
STATIC FUNCTION PRCDVG10(CPROD)
_AMOVDEV := {0,0}
cQuery   := ""

If Select("WorkE") > 0
   WorkE->(dbCloseArea())
EndIf

cQuery := "SELECT D1_COD,SUM(D1_QUANT) QTDE, SUM(D1_TOTAL) VLR " 
cQuery += " FROM " + RetSqlName("SD1") + " SD1 " 
cQuery += " WHERE SD1.D1_FILIAL  = '" + xFilial("SD1") + "'"
cQuery += " AND   SD1.D1_COD     = '" + CPROD + "'"
cQuery += " AND   SD1.D1_DTDIGIT between '" + DTOS(MV_PAR13) + "' and '" + DTOS(MV_PAR14) + "'"
cQuery += " AND   SD1.D1_TIPO = 'D'"
cQuery += " AND   SD1.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY D1_COD"
cQuery += " ORDER BY SD1.D1_COD"

tcQuery cQuery New Alias "WorkE"

dbSelectArea("WorkE")
WorkE->(dbGoTop())
_AMOVDEV := {WorkE->QTDE,WorkE->VLR}
WorkE->(dbCloseArea())

RETURN(_AMOVDEV)

