#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RNBFIN001   º Autor ³ Denis Varella      Data ³ 27/11/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de 1.	Relatório de Comissões		              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn  			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RNBF001()  

Private _cRotina	:= "RComis"
Private oPrn
Private cPerg		:= _cRotina
Private oBrush		:= TBrush():New(,CLR_HGRAY)
Private oFont01N	:= TFont():New( "Arial",,22,,.T.,,,,.F.,.F.) //Arial 18 - Negrito
Private oFont01		:= TFont():New( "Arial",,20,,.F.,,,,.F.,.F.) //Arial 18 - Negrito
Private oFont02		:= TFont():New( "Arial",,12,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
Private oFont03		:= TFont():New( "Arial",,09,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
Private oFont04		:= TFont():New( "Arial",,09,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private oFont04N	:= TFont():New( "Arial",,09,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
Private oFont05		:= TFont():New( "Arial",,14,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private _nLin		:= 080 //Linha inicial para impressão
Private _nLinFin	:= 770 //Linha final para impressão
Private _nEspPad	:= 020 //Espaçamento padrão entre linhas
Private _cEnter		:= CHR(13) + CHR(10)
Private _nMaxDesc	:= 32
Private _lPreview	:= .T.
Private _nPag       := 0

//Chamada da função para geração do relatório     

AjustaSx1(_cRotina)
If Pergunte(_cRotina,.T.)  


If MV_PAR06 == 1
	Processa({ |lEnd| GeraPDF(@lEnd) },_cRotina,"Gerando relatório... Por favor aguarde!",.T.)
Else 
	Processa({ |lEnd| GeraExcel(@lEnd) },_cRotina,"Gerando relatório... Por favor aguarde!",.T.)
EndIf

EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1(cPerg)

Local aRea	:= GetArea()
Local aSx1	:= {} 
local i		:=0
Local j 	:= 0

DBSelectArea("SX1")
SX1->(DBSetOrder(1))
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
SX1->(DBSeek(cPerg+"01"))       
AADD(	aSx1,{ cPerg,"01","Lista Pela:"					,"","","mv_par01" 	,"C",1,0,3, "C","",		"mv_par01","Emissão","","","","","Baixa","","","","","Ambos","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"02","Considera da data:"			,"","","mv_par02"	,"D",8,0,0, "G","", 	"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"03","Até a data:"					,"","","mv_par03"	,"D",8,0,0, "G","",		"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"04","Do vendedor:"				,"","","mv_par04"	,"C",6,0,0, "G","",		"mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})
AADD(	aSx1,{ cPerg,"05","Até o vendedor:"				,"","","mv_par05"	,"C",6,0,0, "G","",		"mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})
AADD(	aSx1,{ cPerg,"06","Imprimir em:"				,"","","mv_par06" 	,"C",1,0,3, "C","",		"mv_par06","1 - PDF","","","","","2 - Excel","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aSx1)
	If !dbSeek(cPerg+aSx1[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount() 
		
			If j <= Len(aSx1[i])
				FieldPut(j,aSx1[i,j])
			Else
				exit
			Endif
		Next
		MsUnlock()
	Endif                                                                          
Next

RestArea(aRea)

Return(cPerg)	
    

Static Function GeraPDF()

Local _cFile	:= _cRotina
Local _nTipoImp	:= IMP_PDF //IMP_SPOOL //
Local _lPropTMS	:= .F.
Local _lDsbSetup:= .T.
Local _lTReport	:= .F.
Local _cPrinter	:= ""
Local _lServer	:= .F.
Local _lPDFAsPNG:= .T.
Local _lRaw		:= .F.
Local _lViewPDF	:= .T.
Local _nQtdCopy	:= 1 
Local aItens 	:= {}
Local nItem		:= 0   
Local nVend		:= 0  
Local _cQry		:= ''       
Local cVend		:= ''

//Montagem da consulta a ser realizada no banco de dados  
_cQry := " SELECT SE3.E3_VEND,SA3.A3_NOME,SE3.E3_SERIE, SE3.E3_NUM, SE3.E3_CODCLI, SE3.E3_CODCLI, A1_NREDUZ,SE3.E3_EMISSAO,SE3.E3_ICMS,SE3.E3_IPI,SE3.E3_PIS,SE3.E3_COFINS,SE3.E3_ACRVEN1,(SE3.E3_FRETENF + SE3.E3_FRETED1) E3_FRETE,SE3.E3_BASEBRU,SE3.E3_BASE,SE3.E3_PORC,SE3.E3_COMIS "
_cQry += " FROM " + RetSqlName("SE3") + " SE3 "
_cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = SE3.E3_CODCLI AND A1_LOJA = SE3.E3_LOJA "
_cQry += " INNER JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD = SE3.E3_VEND "
_cQry += " AND SE3.D_E_L_E_T_ = '' "
_cQry += " AND SE3.E3_FILIAL='" + xFilial("SE3")+"' "
_cQry += " AND SE3.E3_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SE3.E3_VEND BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
If MV_PAR01 == 1  
_cQry += " AND SE3.E3_BAIEMI = 'E' "
ElseIf MV_PAR01 == 2
_cQry += " AND SE3.E3_BAIEMI = 'B' "
Endif
_cQry += " UNION ALL "
_cQry += " SELECT A3_COD E3_VEND, A3_NOME, TMP.E3_SERIE E3_SERIE, TMP.E3_DOC E3_NUM, TMP.E3_CLIENTE E3_CODCLI, TMP.E3_LOJA, A1_NREDUZ [NOM_CLI], TMP.E3_EMISSAO, SUM(TMP.E3_ICMS) E3_ICMS, SUM(TMP.E3_IPI) E3_IPI, SUM(TMP.E3_PIS) E3_PIS,SUM(TMP.E3_COFINS)E3_COFINS,''[E3_ACRVEN1],'' [E3_FRETE], SUM(TMP.E3_BASE)[E3_BASE], SUM (TMP.E3_BASEBRU) E3_BASEBRU, TMP.E3_PORC E3_PORC, '' [E3_COMIS] FROM( "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND1 [F2_VEND], D2_COMIS1 [E3_PORC], '' [E3_COMIS] "
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_VEND1 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND1<>'' "
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " AND SD2.D2_COMIS1 = 0 "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"'" 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " UNION ALL "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND2 [F2_VEND], D2_COMIS2 [E3_PORC], '' [E3_COMIS]"
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_VEND2 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND2<>'' "
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " AND SD2.D2_COMIS2 = 0 "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " UNION ALL "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND3 [F2_VEND], D2_COMIS3 [E3_PORC], '' [E3_COMIS]"
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_VEND3 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND3<>''"
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " AND SD2.D2_COMIS3 = 0 "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " UNION ALL "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND4 [F2_VEND], D2_COMIS4 [E3_PORC], '' [E3_COMIS]"
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " AND SF2.F2_VEND4 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND4<>'' "
_cQry += " AND SD2.D2_COMIS4 = 0 "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " UNION ALL "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND5 [F2_VEND], D2_COMIS5 [E3_PORC], '' [E3_COMIS]"
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_VEND5 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND5<>'' "
_cQry += " AND SD2.D2_COMIS5 = 0 "
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " ) TMP "
_cQry += " INNER JOIN " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) "
_cQry += " ON SA3.D_E_L_E_T_='' "
_cQry += " AND SA3.A3_FILIAL='" + xFilial("SA3")+"' " 
_cQry += " AND TMP.F2_VEND=SA3.A3_COD "
_cQry += " AND SA3.A3_MSBLQL<>'1' "
_cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) "
_cQry += " ON SA1.D_E_L_E_T_='' "
_cQry += " AND SA1.A1_FILIAL='" + xFilial("SA1")+"' " 
_cQry += " AND SA1.A1_COD=TMP.E3_CLIENTE "
_cQry += " AND SA1.A1_LOJA=TMP.E3_LOJA "
_cQry += " GROUP BY"
_cQry += " A3_COD, A3_NOME, A1_NREDUZ ,TMP.E3_SERIE,TMP.E3_DOC,TMP.E3_CLIENTE, TMP.E3_LOJA, TMP.E3_EMISSAO, TMP.F2_VEND, TMP.E3_PORC"
_cQry += " ORDER BY E3_VEND,E3_EMISSAO,E3_SERIE,E3_NUM "


MemoWrite("RComis.txt",_cQry)

_cAliasTmp := GetNextAlias()

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)

dbSelectArea(_cAliasTmp)
 
(_cAliasTmp)->(dbgotop()) 	
While (_cAliasTmp)->(!EOF())
	If cVend != (_cAliasTmp)->E3_VEND
		aAdd(aItens,{})
		nVend++               
	EndIf  
	cVend := (_cAliasTmp)->E3_VEND
	nItem++
	//Adiciona os itens em um array          
   	aAdd(aItens[nVend],{nVend,;
   	(_cAliasTmp)->E3_VEND,;
	(_cAliasTmp)->A3_NOME,;
	(_cAliasTmp)->E3_SERIE,;
	(_cAliasTmp)->E3_NUM,;
	(_cAliasTmp)->E3_CODCLI,;
	(_cAliasTmp)->A1_NREDUZ,;
	(_cAliasTmp)->E3_EMISSAO,;
	(_cAliasTmp)->E3_BASEBRU,;
	(_cAliasTmp)->E3_ICMS,;
	(_cAliasTmp)->E3_IPI,;
	(_cAliasTmp)->E3_PIS,;
	(_cAliasTmp)->E3_COFINS,;
	(_cAliasTmp)->E3_ACRVEN1,;
	(_cAliasTmp)->E3_FRETE,;
	(_cAliasTmp)->E3_BASE,;
	(_cAliasTmp)->E3_PORC,;
	(_cAliasTmp)->E3_COMIS})
	dbskip()
EndDo	 

(_cAliasTmp)->(DBCLOSEAREA())

oPrn := FWMsPrinter():New(_cFile,_nTipoImp,_lPropTMS,,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)
oPrn:SetResolution(72)
oPrn:SetLandscape()	// Orientação do Papel (Paisagem)
oPrn:SetPaperSize(9)
//oPrn:cPathInServer(GetTempPath())
oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior

For nVend := 1 to len(aItens)
	oPrn:StartPage() 
	cabecalho(aItens,nVend)
	corpo(aItens,nVend,_nLin)	
Next nVend
	        
oPrn:EndPage()
oPrn:Preview()

Return()   

Static Function cabecalho(aItens,nVend) 
Local _nLin := 90
Local _nCol := (0845 / 100) 

ImpLogo()
oPrn:Box( _nLin+26, 03, _nLin+27, _nCol*96, "-4")
oPrn:SayAlign(  _nLin+13 , 0005, "Vendedor: " + aItens[nVend][1][2] + " " + aItens[nVend][1][3], oFont02, 0845,0060,,0,0)

_nLin+=30
oPrn:SayAlign(  _nLin , _nCol, "Prefixo", 			oFont03, _nCol*6,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*6, "Nº Título", 		oFont03, _nCol*7,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*15, "Cliente", 		oFont03, _nCol*5,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*20, "Nome Fantasia", 	oFont03, _nCol*12,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*32, "Dt Comissão", 	oFont03, _nCol*6,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*38, "Vlr Título", 	oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*44, "ICMS", 			oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*50, "IPI", 			oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*56, "PIS", 			oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*62, "COFINS", 		oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*68, "Acresc Fin", 	oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*74, "Frete", 			oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*80, "Vlr Base", 		oFont03, _nCol*7,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*85, "%", 		   		oFont03, _nCol*5,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*90, "Comissão", 		oFont03, _nCol*5,0060,,1,0)

Return


Static Function corpo(aItens,nVend)

Local nTotal := 0        
Local cMoeda := '' 
Local _nCol := (0845 / 100)
Local _nLin := 120
Local nTitulo := 0 
Local nBase := 0 
Local nComis := 0 
Local nJ	:= 0

For nJ := 1 to len(aItens[nVend])   
	If _nLin >= 590
	oPrn:EndPage()
	_nLin := 120
	oPrn:StartPage()
	cabecalho(aItens,nVend) 
	EndIf
	_nLin+=15  
	oPrn:SayAlign(  _nLin , _nCol, 		aItens[nVend][nJ][4], oFont04, _nCol*6,0060,,0,0)
	oPrn:SayAlign(  _nLin , _nCol*6, 	aItens[nVend][nJ][5], oFont04, _nCol*7,0060,,0,0)
	oPrn:SayAlign(  _nLin , _nCol*15, 	aItens[nVend][nJ][6], oFont04, _nCol*5,0060,,0,0)
	oPrn:SayAlign(  _nLin , _nCol*20, 	aItens[nVend][nJ][7], oFont04, _nCol*12,0060,,0,0)
	oPrn:SayAlign(  _nLin , _nCol*32, 	DTOC(STOD(aItens[nVend][nJ][8])), oFont04, _nCol*6,0060,,0,0)
	oPrn:SayAlign(  _nLin , _nCol*38, 	trim(Transform(aItens[nVend][nJ][9],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*44, 	trim(Transform(aItens[nVend][nJ][10],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*50, 	trim(Transform(aItens[nVend][nJ][11],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*56, 	trim(Transform(aItens[nVend][nJ][12],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*62, 	trim(Transform(aItens[nVend][nJ][13],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*68, 	trim(Transform(aItens[nVend][nJ][14],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*74, 	trim(Transform(aItens[nVend][nJ][15],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*80, 	trim(Transform(aItens[nVend][nJ][16],"@E 999,999,999.99")), oFont04, _nCol*7,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*85, 	trim(Transform(aItens[nVend][nJ][17],"@E 999,999,999.99")), oFont04, _nCol*5,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*90, 	trim(Transform(aItens[nVend][nJ][18],"@E 999,999,999.99")), oFont04, _nCol*5,0060,,1,0) 
	nTitulo	+= aItens[nVend][nJ][9]
	nBase 	+= aItens[nVend][nJ][16]
	nComis 	+= aItens[nVend][nJ][18]
Next
	_nLin+=15  
	oPrn:Box( _nLin-1, 03, _nLin, _nCol*96, "-4")
	oPrn:SayAlign(  _nLin , _nCol*38, 	trim(Transform(nTitulo,"@E 999,999,999.99")),  oFont04N, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*80, 	trim(Transform(nBase,"@E 999,999,999.99")), oFont04N, _nCol*7,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*90, 	trim(Transform(nComis,"@E 999,999,999.99")), oFont04N, _nCol*5,0060,,1,0)  

oPrn:EndPage()
Return

Static Function ImpLogo()

	Local cLogo      	:= FisxLogo("1")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Logotipo                                     						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	cLogo := GetSrvProfString("Startpath","") + "Logoret.BMP"
	
	oPrn:SayBitmap(030,005,cLogo ,90,70)  
	oPrn:SayAlign(070 , 0005, "Relatório de Comissões", oFont01N, 0845,0060,,2,1)  

Return()      



Static Function GeraExcel()

Local _cPathExcel:="C:\TEMP\"
Local  _cPath 	  := AllTrim(GetTempPath())
Local  _cArquivo  := CriaTrab(,.F.)
Local oExcel := Fwmsexcel():new() 
Local oFWMsExcel
Local cURLXML:= ''
Local cQuery:=""
Local cVar := Alltrim(mv_par03)
Local aArray := {}
Local aItens 	:= {}
Local nItem		:= 0   
Local nVend		:= 0  
Local _cQry		:= ''       
Local cVend		:= ''
Local nJ		:= 0

Private _nHandle  := FCreate(_cArquivo)

//Montagem da consulta a ser realizada no banco de dados  
_cQry := " SELECT SE3.E3_VEND,SA3.A3_NOME,SE3.E3_SERIE, SE3.E3_NUM, SE3.E3_CODCLI, SE3.E3_CODCLI, A1_NREDUZ,SE3.E3_EMISSAO,SE3.E3_ICMS,SE3.E3_IPI,SE3.E3_PIS,SE3.E3_COFINS,SE3.E3_ACRVEN1,(SE3.E3_FRETENF + SE3.E3_FRETED1) E3_FRETE,SE3.E3_BASEBRU,SE3.E3_BASE,SE3.E3_PORC,SE3.E3_COMIS "
_cQry += " FROM " + RetSqlName("SE3") + " SE3 "
_cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = SE3.E3_CODCLI AND A1_LOJA = SE3.E3_LOJA "
_cQry += " INNER JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD = SE3.E3_VEND "
_cQry += " AND SE3.D_E_L_E_T_ = '' "
_cQry += " AND SE3.E3_FILIAL='" + xFilial("SE3")+"' "
_cQry += " AND SE3.E3_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SE3.E3_VEND BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
If MV_PAR01 == 1  
_cQry += " AND SE3.E3_BAIEMI = 'E' "
ElseIf MV_PAR01 == 2
_cQry += " AND SE3.E3_BAIEMI = 'B' "
Endif
_cQry += " UNION ALL "
_cQry += " SELECT A3_COD E3_VEND, A3_NOME, TMP.E3_SERIE E3_SERIE, TMP.E3_DOC E3_NUM, TMP.E3_CLIENTE E3_CODCLI, TMP.E3_LOJA, A1_NREDUZ [NOM_CLI], TMP.E3_EMISSAO, SUM(TMP.E3_ICMS) E3_ICMS, SUM(TMP.E3_IPI) E3_IPI, SUM(TMP.E3_PIS) E3_PIS,SUM(TMP.E3_COFINS)E3_COFINS,''[E3_ACRVEN1],'' [E3_FRETE], SUM(TMP.E3_BASE)[E3_BASE], SUM (TMP.E3_BASEBRU) E3_BASEBRU, TMP.E3_PORC E3_PORC, '' [E3_COMIS] FROM( "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND1 [F2_VEND], D2_COMIS1 [E3_PORC], '' [E3_COMIS] "
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_VEND1 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND1<>'' "
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " AND SD2.D2_COMIS1 = 0 "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"'" 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " UNION ALL "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND2 [F2_VEND], D2_COMIS2 [E3_PORC], '' [E3_COMIS]"
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_VEND2 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND2<>'' "
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " AND SD2.D2_COMIS2 = 0 "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " UNION ALL "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND3 [F2_VEND], D2_COMIS3 [E3_PORC], '' [E3_COMIS]"
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_VEND3 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND3<>''"
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " AND SD2.D2_COMIS3 = 0 "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " UNION ALL "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND4 [F2_VEND], D2_COMIS4 [E3_PORC], '' [E3_COMIS]"
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " AND SF2.F2_VEND4 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND4<>'' "
_cQry += " AND SD2.D2_COMIS4 = 0 "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " UNION ALL "
_cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  (D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND5 [F2_VEND], D2_COMIS5 [E3_PORC], '' [E3_COMIS]"
_cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
_cQry += " ON SF2.D_E_L_E_T_='' " 
_cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
_cQry += " AND SD2.D_E_L_E_T_='' "
_cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
_cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
_cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
_cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
_cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
_cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
_cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
_cQry += " AND SF2.F2_VEND5 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_cQry += " AND SF2.F2_VEND5<>'' "
_cQry += " AND SD2.D2_COMIS5 = 0 "
_cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
_cQry += " ON SF4.D_E_L_E_T_='' "
_cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
_cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
_cQry += " AND SF4.F4_DUPLIC='S' "
_cQry += " ) TMP "
_cQry += " INNER JOIN " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) "
_cQry += " ON SA3.D_E_L_E_T_='' "
_cQry += " AND SA3.A3_FILIAL='" + xFilial("SA3")+"' " 
_cQry += " AND TMP.F2_VEND=SA3.A3_COD "
_cQry += " AND SA3.A3_MSBLQL<>'1' "
_cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) "
_cQry += " ON SA1.D_E_L_E_T_='' "
_cQry += " AND SA1.A1_FILIAL='" + xFilial("SA1")+"' " 
_cQry += " AND SA1.A1_COD=TMP.E3_CLIENTE "
_cQry += " AND SA1.A1_LOJA=TMP.E3_LOJA "
_cQry += " GROUP BY"
_cQry += " A3_COD, A3_NOME, A1_NREDUZ ,TMP.E3_SERIE,TMP.E3_DOC,TMP.E3_CLIENTE, TMP.E3_LOJA, TMP.E3_EMISSAO, TMP.F2_VEND, TMP.E3_PORC"
_cQry += " ORDER BY E3_VEND,E3_EMISSAO,E3_SERIE,E3_NUM "

MemoWrite("RComis.txt",_cQry)

_cAliasTmp := GetNextAlias()

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)

dbSelectArea(_cAliasTmp)
 
(_cAliasTmp)->(dbgotop()) 	
While (_cAliasTmp)->(!EOF())
	If cVend != (_cAliasTmp)->E3_VEND
		aAdd(aItens,{})
		nVend++               
	EndIf  
	cVend := (_cAliasTmp)->E3_VEND
	nItem++
	//Adiciona os itens em um array          
   	aAdd(aItens[nVend],{nVend,;
   	(_cAliasTmp)->E3_VEND,;
	(_cAliasTmp)->A3_NOME,;
	(_cAliasTmp)->E3_SERIE,;
	(_cAliasTmp)->E3_NUM,;
	(_cAliasTmp)->E3_CODCLI,;
	(_cAliasTmp)->A1_NREDUZ,;
	(_cAliasTmp)->E3_EMISSAO,;
	(_cAliasTmp)->E3_BASEBRU,;
	(_cAliasTmp)->E3_ICMS,;
	(_cAliasTmp)->E3_IPI,;
	(_cAliasTmp)->E3_PIS,;
	(_cAliasTmp)->E3_COFINS,;
	(_cAliasTmp)->E3_ACRVEN1,;
	(_cAliasTmp)->E3_FRETE,;
	(_cAliasTmp)->E3_BASE,;
	(_cAliasTmp)->E3_PORC,;
	(_cAliasTmp)->E3_COMIS})
	dbskip()
EndDo	 

(_cAliasTmp)->(DBCLOSEAREA())

oExcel:AddworkSheet("PARÂMETROS")
oExcel:AddTable("PARÂMETROS","PARÂMETROS")
oExcel:AddColumn("PARÂMETROS","PARÂMETROS","PARAMETROS",1,1)
oExcel:AddColumn("PARÂMETROS","PARÂMETROS","VALOR",1,1)
oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Listar por:',;
Iif(MV_PAR01 == 1,'Emissão',Iif(MV_PAR01 == 2,'Baixa','Ambos'))})
oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Considera da data:',;
DTOC(mv_par02)})
oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Até a data:',;
DTOC(mv_par03)})
oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Do vendedor:',;
mv_par04})
oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Até o vendedor:',;
mv_par05})


For nVend := 1 to len(aItens)
nTitulo := 0
nBase 	:= 0
nComis 	:= 0
cVend := trim(aItens[nVend][1][3]) + " - RELATÓRIO DE COMISSÃO
oExcel:AddworkSheet(cVend)
oExcel:AddTable(cVend,cVend)
oExcel:AddColumn(cVend,cVend,"Prefixo",1,1)
oExcel:AddColumn(cVend,cVend,"Nº Título",1,1)
oExcel:AddColumn(cVend,cVend,"Cliente",1,1)
oExcel:AddColumn(cVend,cVend,"Nome Fantasia",1,1)
oExcel:AddColumn(cVend,cVend,"Data Comissão",1,1)
oExcel:AddColumn(cVend,cVend,"Valor Título",1,2)
oExcel:AddColumn(cVend,cVend,"ICMS",1,2)
oExcel:AddColumn(cVend,cVend,"IPI",1,2)
oExcel:AddColumn(cVend,cVend,"PIS",1,2)
oExcel:AddColumn(cVend,cVend,"COFINS",1,2)
oExcel:AddColumn(cVend,cVend,"Acresc Financeiro",1,2)
oExcel:AddColumn(cVend,cVend,"Frete",1,2)
oExcel:AddColumn(cVend,cVend,"Valor Base",1,2)
oExcel:AddColumn(cVend,cVend,"%",1,2)
oExcel:AddColumn(cVend,cVend,"Comissão",1,2)

For nJ := 1 to len(aItens[nVend])
oExcel:AddRow(cVend,cVend,{aItens[nVend][nJ][4],;
aItens[nVend][nJ][5],;
aItens[nVend][nJ][6],;
aItens[nVend][nJ][7],;
DTOC(STOD(aItens[nVend][nJ][8])),;
Transform(aItens[nVend][nJ][9] ,"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][10],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][11],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][12],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][13],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][14],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][15],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][16],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][17],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][18],"@E 999,999,999.99")})
nTitulo += aItens[nVend][nJ][9]
nBase 	+= aItens[nVend][nJ][16]
nComis 	+= aItens[nVend][nJ][18]
Next nJ 
oExcel:AddRow(cVend,cVend,{'',;
'',;
'',;
'',;
'',;
Transform(nTitulo,"@E 999,999,999.99"),;
'',;
'',;
'',;
'',;
'',;
'',;
Transform(nBase,"@E 999,999,999.99"),;
'',;
Transform(nComis,"@E 999,999,999.99")})
Next nVend

oExcel:Activate()
oExcel:GetXMLFile(_cArquivo+".xml")

__CopyFile(_cArquivo+".xml",_cPathExcel+_cArquivo+".xml")

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cPathExcel+_cArquivo+".xml") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf

Return