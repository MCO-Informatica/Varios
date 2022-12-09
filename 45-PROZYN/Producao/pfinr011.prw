#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PFINR011   º Autor ³ Denis Varella      Data ³ 27/11/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de 1.	Relatório de Comissões - SE3              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn  			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PFINR011(_dDatade,_dDatate,_cVende,_cVenate)

Private _cRotina	:= "PFINR011"
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

  
	// Chamada da função pela rotina de recalculo de Comissão. 

	If Alltrim(FunName(1))= "RFINE010"
		cAmbiente := UPPER(ALLTRIM(GetEnvServer()))
		
		MV_PAR01:= 2
		MV_PAR02:=_dDatade
		MV_PAR03:=_dDatate
		MV_PAR04:=_cVende
		MV_PAR05:=_cVenate       
		MV_PAR07:= 2 // não gera linhas com 0 de comissao
			
		Processa({ || GeraExcel() },_cRotina,"Gerando Relatório de Comissão... Por favor aguarde!",.T.)
	
	Else
	
	//Chamada da função para geração do relatório     

		AjustaSx1(_cRotina)
		If Pergunte(_cRotina,.T.)  
		
			If MV_PAR06 == 1
				Processa({ || GeraPDF() },_cRotina,"Gerando Relatório de Comissão... Por favor aguarde!",.T.)
			Else 
				Processa({ || GeraExcel() },_cRotina,"Gerando Relatório de Comissão... Por favor aguarde!",.T.)
			EndIf
			
		EndIf
		
	Endif
				
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
local i:=0
Local j	:= 0

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
AADD(	aSx1,{ cPerg,"07","Itens 0% Comis?"				,"","","mv_par07" 	,"C",1,0,3, "C","",		"mv_par06","1 - SIM","","","","","2 - NAO","","","","","","","","","","","","","","","","","","","","",""})

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
	Local cQry		:= ''       
	Local cVend		:= ''

	//Montagem da consulta a ser realizada no banco de dados  
	cQry := " SELECT SE3.E3_VEND,SA3.A3_NOME,SE3.E3_SERIE, SE3.E3_NUM, SE3.E3_CODCLI, SE3.E3_CODCLI, A1_NREDUZ,SE3.E3_EMISSAO,SE3.E3_ICMS,SE3.E3_IPI,SE3.E3_PIS,SE3.E3_COFINS,SE3.E3_ACRVEN1,(SE3.E3_FRETENF + SE3.E3_FRETED1) E3_FRETE,SE3.E3_BASEBRU,SE3.E3_BASE,SE3.E3_PORC,SE3.E3_COMIS,C5_DTEXP "
	cQry += " FROM " + RetSqlName("SE3") + " SE3 "
	cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = SE3.E3_CODCLI AND A1_LOJA = SE3.E3_LOJA "
	cQry += " INNER JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD = SE3.E3_VEND AND SA3.A3_MSBLQL <> '1' AND SA3.D_E_L_E_T_ = '' "
	cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = ''
	cQry += " WHERE SE3.D_E_L_E_T_ = '' " 
	cQry += " AND SE3.E3_FILIAL='" + xFilial("SE3")+"' "
	cQry += " AND SE3.E3_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
	cQry += " AND SE3.E3_VEND BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
	If MV_PAR01 == 1  
	cQry += " AND SE3.E3_BAIEMI = 'E' "
	ElseIf MV_PAR01 == 2
	cQry += " AND SE3.E3_BAIEMI = 'B' "
	Endif
	IF	MV_PAR07 == 1
	cQry += " UNION ALL "
	cQry += " SELECT A3_COD E3_VEND, A3_NOME, TMP.E3_SERIE E3_SERIE, TMP.E3_DOC E3_NUM, TMP.E3_CLIENTE E3_CODCLI, TMP.E3_LOJA, A1_NREDUZ [NOM_CLI], TMP.E3_EMISSAO, SUM(TMP.E3_ICMS) E3_ICMS, SUM(TMP.E3_IPI) E3_IPI, SUM(TMP.E3_PIS) E3_PIS,SUM(TMP.E3_COFINS)E3_COFINS,''[E3_ACRVEN1],'' [E3_FRETE], SUM(TMP.E3_BASEBRU) E3_BASEBRU, SUM(TMP.E3_BASE)[E3_BASE], TMP.E3_PORC E3_PORC, '' [E3_COMIS],C5_DTEXP FROM( "
	cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND1 [F2_VEND], D2_COMIS1 [E3_PORC], '' [E3_COMIS],C5_DTEXP "
	cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
	cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
	cQry += " ON SF2.D_E_L_E_T_='' " 
	cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
	cQry += " AND SD2.D_E_L_E_T_='' "
	cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
	cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
	cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
	cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
	cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
	cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
	cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
	cQry += " AND SF2.F2_VEND1 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
	cQry += " AND SF2.F2_VEND1<>'' "
	cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
	cQry += " AND SD2.D2_COMIS1 = 0 "
	cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = F2_DOC AND C5_SERIE = F2_SERIE AND C5.D_E_L_E_T_ = ''
	cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
	cQry += " ON SF4.D_E_L_E_T_='' "
	cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"'" 
	cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
	cQry += " AND SF4.F4_DUPLIC='S' "
	cQry += " UNION ALL "
	cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND2 [F2_VEND], D2_COMIS2 [E3_PORC], '' [E3_COMIS],C5_DTEXP "
	cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
	cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
	cQry += " ON SF2.D_E_L_E_T_='' " 
	cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
	cQry += " AND SD2.D_E_L_E_T_='' "
	cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
	cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
	cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
	cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
	cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
	cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
	cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
	cQry += " AND SF2.F2_VEND2 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
	cQry += " AND SF2.F2_VEND2<>'' "
	cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
	cQry += " AND SD2.D2_COMIS2 = 0 "
	cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = F2_DOC AND C5_SERIE = F2_SERIE AND C5.D_E_L_E_T_ = ''
	cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
	cQry += " ON SF4.D_E_L_E_T_='' "
	cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
	cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
	cQry += " AND SF4.F4_DUPLIC='S' "
	cQry += " UNION ALL "
	cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND3 [F2_VEND], D2_COMIS3 [E3_PORC], '' [E3_COMIS],C5_DTEXP "
	cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
	cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
	cQry += " ON SF2.D_E_L_E_T_='' " 
	cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
	cQry += " AND SD2.D_E_L_E_T_='' "
	cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
	cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
	cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
	cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
	cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
	cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
	cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
	cQry += " AND SF2.F2_VEND3 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
	cQry += " AND SF2.F2_VEND3<>''"
	cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
	cQry += " AND SD2.D2_COMIS3 = 0 "
	cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = F2_DOC AND C5_SERIE = F2_SERIE AND C5.D_E_L_E_T_ = ''
	cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
	cQry += " ON SF4.D_E_L_E_T_='' "
	cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
	cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
	cQry += " AND SF4.F4_DUPLIC='S' "
	cQry += " UNION ALL "
	cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND4 [F2_VEND], D2_COMIS4 [E3_PORC], '' [E3_COMIS],C5_DTEXP "
	cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
	cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
	cQry += " ON SF2.D_E_L_E_T_='' " 
	cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
	cQry += " AND SD2.D_E_L_E_T_='' "
	cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
	cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
	cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
	cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
	cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
	cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
	cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
	cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
	cQry += " AND SF2.F2_VEND4 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
	cQry += " AND SF2.F2_VEND4<>'' "
	cQry += " AND SD2.D2_COMIS4 = 0 "
	cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = F2_DOC AND C5_SERIE = F2_SERIE AND C5.D_E_L_E_T_ = ''
	cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
	cQry += " ON SF4.D_E_L_E_T_='' "
	cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
	cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
	cQry += " AND SF4.F4_DUPLIC='S' "
	cQry += " UNION ALL "
	cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_VALBRUT) [E3_BASEBRU], F2_VEND5 [F2_VEND], D2_COMIS5 [E3_PORC], '' [E3_COMIS],C5_DTEXP "
	cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
	cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
	cQry += " ON SF2.D_E_L_E_T_='' " 
	cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
	cQry += " AND SD2.D_E_L_E_T_='' "
	cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
	cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
	cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
	cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
	cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
	cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
	cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
	cQry += " AND SF2.F2_VEND5 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
	cQry += " AND SF2.F2_VEND5<>'' "
	cQry += " AND SD2.D2_COMIS5 = 0 "
	cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
	cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = F2_DOC AND C5_SERIE = F2_SERIE AND C5.D_E_L_E_T_ = ''
	cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
	cQry += " ON SF4.D_E_L_E_T_='' "
	cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
	cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
	cQry += " AND SF4.F4_DUPLIC='S' "
	cQry += " ) TMP "
	cQry += " INNER JOIN " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) "
	cQry += " ON SA3.D_E_L_E_T_='' "
	cQry += " AND SA3.A3_FILIAL='" + xFilial("SA3")+"' " 
	cQry += " AND TMP.F2_VEND=SA3.A3_COD "
	cQry += " AND SA3.A3_MSBLQL<>'1' "
	cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) "
	cQry += " ON SA1.D_E_L_E_T_='' "
	cQry += " AND SA1.A1_FILIAL='" + xFilial("SA1")+"' " 
	cQry += " AND SA1.A1_COD=TMP.E3_CLIENTE "
	cQry += " AND SA1.A1_LOJA=TMP.E3_LOJA "
	cQry += " GROUP BY"
	cQry += " A3_COD, A3_NOME, A1_NREDUZ ,TMP.E3_SERIE,TMP.E3_DOC,TMP.E3_CLIENTE, TMP.E3_LOJA, TMP.E3_EMISSAO, TMP.F2_VEND, TMP.E3_PORC, C5_DTEXP "
	ENDIF
	cQry += " ORDER BY E3_VEND,E3_EMISSAO,E3_SERIE,E3_NUM "


	MemoWrite("PFINR011_pdf.txt",cQry)

	_cAliasTmp := GetNextAlias()

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),_cAliasTmp,.T.,.F.)
	
	FINR->(dbgotop()) 	
	While FINR->(!EOF())
		If cVend != FINR->E3_VEND
			aAdd(aItens,{})
			nVend++               
		EndIf  
		cVend := FINR->E3_VEND
		nItem++
		//Adiciona os itens em um array          
		aAdd(aItens[nVend],{nVend,;
		FINR->E3_VEND,;
		FINR->A3_NOME,;
		FINR->E3_SERIE,;
		FINR->E3_NUM,;
		FINR->E3_CODCLI,;
		FINR->A1_NREDUZ,;
		FINR->E3_EMISSAO,;
		FINR->E3_BASEBRU,;
		FINR->E3_ICMS,;
		FINR->E3_IPI,;
		FINR->E3_PIS,;
		FINR->E3_COFINS,;
		FINR->E3_ACRVEN1,;
		FINR->E3_FRETE,;
		FINR->E3_BASE,;
		FINR->E3_PORC,;
		FINR->E3_COMIS,;
		FINR->C5_DTEXP})
		dbskip()
	EndDo	 

	FINR->(DBCLOSEAREA())

	oPrn := FWMsPrinter():New(_cFile,_nTipoImp,_lPropTMS,,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)
	oPrn:SetResolution(72)
	oPrn:SetLandscape()	// Orientação do Papel (Paisagem)
	oPrn:SetPaperSize(9)
	//oPrn:cPathInServer(GetTempPath())
	oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior

	For nVend := 1 to len(aItens)
		oPrn:StartPage() 
		cabecalho(aItens,nVend)
		corpo(aItens,nVend)
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
	Local  _cArquivo  := CriaTrab(,.F.)
	Local oExcel := Fwmsexcel():new()
	Local aItens 	:= {}
	Local aItensEmiss := {}
	Local aDetalhe  := {}
	Local nVend		:= 0  
	Local cQry		:= ''       
	Local cVend		:= ''
	Local nJ		:= 0

	Private _nHandle  := FCreate(_cArquivo)

	//Montagem da consulta a ser realizada no banco de dados  
	IF MV_PAR07 == 1
		cQry := " SELECT SE3.E3_VEND,SA3.A3_NOME,SE3.E3_SERIE, SE3.E3_NUM, SE3.E3_CODCLI, SE3.E3_LOJA, A1_NREDUZ,SE3.E3_EMISSAO,SE3.E3_ICMS,SE3.E3_IPI,SE3.E3_PIS,SE3.E3_COFINS,SE3.E3_ACRVEN1,(SE3.E3_FRETENF + SE3.E3_FRETED1) E3_FRETE,SE3.E3_BASEBRU,SE3.E3_BASE,SE3.E3_PORC,SE3.E3_COMIS,C5_DTEXP,A4_COD,A4_NREDUZ,SE3.E3_XTPCOMI "
		cQry += " FROM " + RetSqlName("SE3") + " SE3 "
		cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = SE3.E3_CODCLI AND A1_LOJA = SE3.E3_LOJA "
		cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN " + RetSqlName("SA4") + " A4 ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''
		cQry += " INNER JOIN " + RetSqlName("SA3") + " SA3 ON A3_COD = SE3.E3_VEND "
		cQry += " AND SE3.D_E_L_E_T_ = '' "
		cQry += " AND SA3.A3_MSBLQL <> '1' " 
		cQry += " AND SE3.E3_FILIAL='" + xFilial("SE3")+"' "
		cQry += " AND SE3.E3_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
		cQry += " AND SE3.E3_VEND BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
		If MV_PAR01 == 1  
		cQry += " AND SE3.E3_BAIEMI = 'E' "
		ElseIf MV_PAR01 == 2
		cQry += " AND SE3.E3_BAIEMI = 'B' "
		Endif
		cQry += " UNION ALL "
		cQry += " SELECT A3_COD E3_VEND, A3_NOME, TMP.E3_SERIE E3_SERIE, TMP.E3_DOC E3_NUM, TMP.E3_CLIENTE E3_CODCLI, TMP.E3_LOJA, A1_NREDUZ [NOM_CLI], TMP.E3_EMISSAO, SUM(TMP.E3_ICMS) E3_ICMS, SUM(TMP.E3_IPI) E3_IPI, SUM(TMP.E3_PIS) E3_PIS,SUM(TMP.E3_COFINS)E3_COFINS,''[E3_ACRVEN1],'' [E3_FRETE], SUM (TMP.E3_BASEBRU) E3_BASEBRU, SUM(TMP.E3_BASE)[E3_BASE], TMP.E3_PORC E3_PORC, '' [E3_COMIS],C5_DTEXP,A4_COD,A4_NREDUZ,E3_XTPCOMI FROM( "
		cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_TOTAL) [E3_BASEBRU], F2_VEND1 [F2_VEND], D2_COMIS1 [E3_PORC], '' [E3_COMIS],C5_DTEXP,A4_COD,A4_NREDUZ, '' [E3_XTPCOMI] "
		cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
		cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
		cQry += " ON SF2.D_E_L_E_T_='' " 
		cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
		cQry += " AND SD2.D_E_L_E_T_='' "
		cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
		cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
		cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
		cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
		cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
		cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
		cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
		cQry += " AND SF2.F2_VEND1 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
		cQry += " AND SF2.F2_VEND1<>'' "
		cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
		cQry += " AND SD2.D2_COMIS1 = 0 "
		cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN " + RetSqlName("SA4") + " A4 ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''
		cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
		cQry += " ON SF4.D_E_L_E_T_='' "
		cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"'" 
		cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
		cQry += " AND SF4.F4_DUPLIC='S' "
		cQry += " UNION ALL "
		cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_TOTAL) [E3_BASEBRU], F2_VEND2 [F2_VEND], D2_COMIS2 [E3_PORC], '' [E3_COMIS],C5_DTEXP,A4_COD,A4_NREDUZ, '' [E3_XTPCOMI] "
		cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
		cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
		cQry += " ON SF2.D_E_L_E_T_='' " 
		cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
		cQry += " AND SD2.D_E_L_E_T_='' "
		cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
		cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
		cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
		cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
		cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
		cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
		cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
		cQry += " AND SF2.F2_VEND2 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
		cQry += " AND SF2.F2_VEND2<>'' "
		cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
		cQry += " AND SD2.D2_COMIS2 = 0 "
		cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN " + RetSqlName("SA4") + " A4 ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''
		cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
		cQry += " ON SF4.D_E_L_E_T_='' "
		cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
		cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
		cQry += " AND SF4.F4_DUPLIC='S' "
		cQry += " UNION ALL "
		cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_TOTAL) [E3_BASEBRU], F2_VEND3 [F2_VEND], D2_COMIS3 [E3_PORC], '' [E3_COMIS],C5_DTEXP,A4_COD,A4_NREDUZ,'' [E3_XTPCOMI] "
		cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
		cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
		cQry += " ON SF2.D_E_L_E_T_='' " 
		cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
		cQry += " AND SD2.D_E_L_E_T_='' "
		cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
		cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
		cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
		cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
		cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
		cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
		cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
		cQry += " AND SF2.F2_VEND3 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
		cQry += " AND SF2.F2_VEND3<>''"
		cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
		cQry += " AND SD2.D2_COMIS3 = 0 "
		cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN " + RetSqlName("SA4") + " A4 ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''
		cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
		cQry += " ON SF4.D_E_L_E_T_='' "
		cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
		cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
		cQry += " AND SF4.F4_DUPLIC='S' "
		cQry += " UNION ALL "
		cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_TOTAL) [E3_BASEBRU], F2_VEND4 [F2_VEND], D2_COMIS4 [E3_PORC], '' [E3_COMIS],C5_DTEXP,A4_COD,A4_NREDUZ, '' [E3_XTPCOMI] "
		cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
		cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
		cQry += " ON SF2.D_E_L_E_T_='' " 
		cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
		cQry += " AND SD2.D_E_L_E_T_='' "
		cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
		cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
		cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
		cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
		cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
		cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
		cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
		cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
		cQry += " AND SF2.F2_VEND4 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
		cQry += " AND SF2.F2_VEND4<>'' "
		cQry += " AND SD2.D2_COMIS4 = 0 "
		cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN " + RetSqlName("SA4") + " A4 ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''
		cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
		cQry += " ON SF4.D_E_L_E_T_='' "
		cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
		cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
		cQry += " AND SF4.F4_DUPLIC='S' "
		cQry += " UNION ALL "
		cQry += " SELECT SF2.F2_SERIE [E3_SERIE],  SF2.F2_DOC [E3_DOC], F2_CLIENTE [E3_CLIENTE], SF2.F2_LOJA [E3_LOJA], SF2.F2_EMISSAO [E3_EMISSAO] , D2_VALICM [E3_ICMS], D2_VALIPI [E3_IPI], D2_VALIMP5 [E3_COFINS], D2_VALIMP6 [E3_PIS],''[E3_ACRVEN1],'' [FRETE],  0 [E3_BASE], (D2_TOTAL) [E3_BASEBRU], F2_VEND5 [F2_VEND], D2_COMIS5 [E3_PORC], '' [E3_COMIS],C5_DTEXP,A4_COD,A4_NREDUZ,'' [E3_XTPCOMI] "
		cQry += " FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
		cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK)" 
		cQry += " ON SF2.D_E_L_E_T_='' " 
		cQry += " AND SF2.F2_FILIAL='" + xFilial("SF2")+"' " 
		cQry += " AND SD2.D_E_L_E_T_='' "
		cQry += " AND SD2.D2_FILIAL='" + xFilial("SD2")+"' "
		cQry += " AND SF2.F2_DOC=SD2.D2_DOC "
		cQry += " AND SF2.F2_SERIE=SD2.D2_SERIE "
		cQry += " AND SF2.F2_TIPO=SD2.D2_TIPO "
		cQry += " AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " 
		cQry += " AND SF2.F2_LOJA=SD2.D2_LOJA "
		cQry += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "
		cQry += " AND SF2.F2_VEND5 BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
		cQry += " AND SF2.F2_VEND5<>'' "
		cQry += " AND SD2.D2_COMIS5 = 0 "
		cQry += " AND SF2.F2_TIPO NOT IN ('D','B') "
		cQry += " LEFT JOIN " + RetSqlName("SC5") + " C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN " + RetSqlName("SA4") + " A4 ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''
		cQry += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
		cQry += " ON SF4.D_E_L_E_T_='' "
		cQry += " AND SF4.F4_FILIAL='" + xFilial("SF4")+"' " 
		cQry += " AND SD2.D2_TES=SF4.F4_CODIGO "
		cQry += " AND SF4.F4_DUPLIC='S' "
		cQry += " ) TMP "
		cQry += " INNER JOIN " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) "
		cQry += " ON SA3.D_E_L_E_T_='' "
		cQry += " AND SA3.A3_FILIAL='" + xFilial("SA3")+"' " 
		cQry += " AND TMP.F2_VEND=SA3.A3_COD "
		cQry += " AND SA3.A3_MSBLQL<>'1' "
		cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) "
		cQry += " ON SA1.D_E_L_E_T_='' "
		cQry += " AND SA1.A1_FILIAL='" + xFilial("SA1")+"' " 
		cQry += " AND SA1.A1_COD=TMP.E3_CLIENTE "
		cQry += " AND SA1.A1_LOJA=TMP.E3_LOJA "
		cQry += " GROUP BY"
		cQry += " A3_COD, A3_NOME, A1_NREDUZ ,TMP.E3_SERIE,TMP.E3_DOC,TMP.E3_CLIENTE, TMP.E3_LOJA, TMP.E3_EMISSAO, TMP.F2_VEND, TMP.E3_PORC,C5_DTEXP,A4_COD,A4_NREDUZ "    
		cQry += " ORDER BY E3_VEND,E3_EMISSAO,E3_SERIE,E3_NUM "
	
	
	ELSE

		cQry := " SELECT '1 - PRINCIPAL' TIPO,SE3.E3_VEND,SA3.A3_NOME,SE3.E3_SERIE, SE3.E3_NUM,'' ITEM,'' PRODUTO,'' DESCPROD, SE3.E3_CODCLI, SE3.E3_LOJA, A1_NREDUZ,SE3.E3_EMISSAO,SE3.E3_ICMS,SE3.E3_IPI,SE3.E3_PIS,SE3.E3_COFINS,SE3.E3_ACRVEN1,IsNull(C5_TPFRETE,'') C5_TPFRETE,(SE3.E3_FRETENF + SE3.E3_FRETED1) E3_FRETE,
		cQry += " Round(E3_BASE+E3_FRETED1+E3_FRETENF+E3_IPI+E3_ACRVEN1+E3_ICMS+E3_PIS+E3_COFINS,2) E3_BASEBRU,
		cQry += " SE3.E3_BASE,SE3.E3_PORC,SE3.E3_COMIS,C5_DTEXP,A4_COD,A4_NREDUZ,SE3.E3_XTPCOMI,'' [B1_COMOD],'' [A7_XTPNEGO], E1_BAIXA,E3_PARCELA,(SELECT MAX(E1_PARCELA) FROM SE1010 E12 WHERE E12.E1_NUM = E3_NUM AND E3_PREFIXO = E12.E1_PREFIXO AND E3_TIPO = E12.E1_TIPO AND E12.D_E_L_E_T_ = '') MAXPARCELA,F2_EMISSAO DOCEMIS
		cQry += " FROM "+RetSqlName("SE3")+" SE3  
		cQry += " INNER JOIN "+RetSqlName("SE1")+" E1 ON E1_NUM = E3_NUM AND E1_PARCELA = E3_PARCELA AND E3_PREFIXO = E1_PREFIXO AND E3_TIPO = E1_TIPO AND E1.D_E_L_E_T_ = ''
		cQry += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = SE3.E3_CODCLI AND A1_LOJA = SE3.E3_LOJA AND SA1.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN "+RetSqlName("SC5")+" C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = '' 
		cQry += " LEFT JOIN "+RetSqlName("SF2")+" F2 ON F2_DOC = C5_NOTA AND F2_SERIE = C5_SERIE AND F2.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN "+RetSqlName("SA4")+" A4 ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = '' 
		cQry += " INNER JOIN "+RetSqlName("SA3")+" SA3 ON A3_COD = SE3.E3_VEND  AND SA3.A3_MSBLQL <> '1'  AND SA3.D_E_L_E_T_ = ''
		cQry += " WHERE SE3.E3_FILIAL='" + xFilial("SE3")+"'  AND SE3.E3_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "'  
		cQry += " AND SE3.E3_VEND BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'  
		cQry += " AND SE3.E3_BAIEMI = '"+Iif(MV_PAR01 == 1, 'E','B')+"' AND SE3.D_E_L_E_T_ = ''

		cQry += " UNION ALL

		cQry += " SELECT '2 - ITEM VENDA',SE3.E3_VEND,SA3.A3_NOME,SE3.E3_SERIE, SE3.E3_NUM,D2_ITEM,D2_COD,B1_DESC,SE3.E3_CODCLI, SE3.E3_LOJA, A1_NREDUZ,SE3.E3_EMISSAO,
		cQry += " Round((SELECT SUM(E3_ICMS) FROM SE3010 WHERE E3_NUM = SE3.E3_NUM AND E3_PREFIXO = SE3.E3_PREFIXO AND E3_TIPO = SE3.E3_TIPO AND E3_VEND = SE3.E3_VEND AND E3_PARCELA = SE3.E3_PARCELA AND E3_BAIEMI = SE3.E3_BAIEMI AND D_E_L_E_T_ = '') * (D2_VALBRUT * 100 / F2_VALBRUT) / 100,2),
  		cQry += " Round((SELECT SUM(E3_IPI) FROM SE3010 WHERE E3_NUM = SE3.E3_NUM AND E3_PREFIXO = SE3.E3_PREFIXO AND E3_TIPO = SE3.E3_TIPO AND E3_VEND = SE3.E3_VEND AND E3_PARCELA = SE3.E3_PARCELA AND E3_BAIEMI = SE3.E3_BAIEMI AND D_E_L_E_T_ = '') * (D2_VALBRUT * 100 / F2_VALBRUT) / 100,2),
  		cQry += " Round((SELECT SUM(E3_PIS) FROM SE3010 WHERE E3_NUM = SE3.E3_NUM AND E3_PREFIXO = SE3.E3_PREFIXO AND E3_TIPO = SE3.E3_TIPO AND E3_VEND = SE3.E3_VEND AND E3_PARCELA = SE3.E3_PARCELA AND E3_BAIEMI = SE3.E3_BAIEMI AND D_E_L_E_T_ = '') * (D2_VALBRUT * 100 / F2_VALBRUT) / 100,2),
  		cQry += " Round((SELECT SUM(E3_COFINS) FROM SE3010 WHERE E3_NUM = SE3.E3_NUM AND E3_PREFIXO = SE3.E3_PREFIXO AND E3_TIPO = SE3.E3_TIPO AND E3_VEND = SE3.E3_VEND AND E3_PARCELA = SE3.E3_PARCELA AND E3_BAIEMI = SE3.E3_BAIEMI AND D_E_L_E_T_ = '') * (D2_VALBRUT * 100 / F2_VALBRUT) / 100,2),
  		cQry += " ROUND((SELECT SUM(E3_ACRVEN1) FROM SE3010 WHERE E3_NUM = SE3.E3_NUM AND E3_PREFIXO = SE3.E3_PREFIXO AND E3_TIPO = SE3.E3_TIPO AND E3_VEND = SE3.E3_VEND AND E3_PARCELA = SE3.E3_PARCELA AND E3_BAIEMI = SE3.E3_BAIEMI AND D_E_L_E_T_ = '') * (D2_VALBRUT * 100 / F2_VALBRUT) / 100, 2),
  		cQry += " ISNULL(C5_TPFRETE, ''),
  		cQry += " ROUND((SELECT SUM(E3_FRETED1 + E3_FRETENF) FROM SE3010 WHERE E3_NUM = SE3.E3_NUM AND E3_PREFIXO = SE3.E3_PREFIXO AND E3_TIPO = SE3.E3_TIPO AND E3_VEND = SE3.E3_VEND AND E3_PARCELA = SE3.E3_PARCELA AND E3_BAIEMI = SE3.E3_BAIEMI AND D_E_L_E_T_ = '') * (D2_VALBRUT * 100 / F2_VALBRUT) / 100, 2),
  		cQry += " ROUND((SELECT SUM(E3_BASEBRU) FROM SE3010 WHERE E3_NUM = SE3.E3_NUM AND E3_PREFIXO = SE3.E3_PREFIXO AND E3_TIPO = SE3.E3_TIPO AND E3_VEND = SE3.E3_VEND AND E3_PARCELA = SE3.E3_PARCELA AND E3_BAIEMI = SE3.E3_BAIEMI AND D_E_L_E_T_ = '') * (D2_VALBRUT * 100 / F2_VALBRUT) / 100, 2),
  		cQry += " ROUND((SELECT SUM(E3_BASE) FROM SE3010 WHERE E3_NUM = SE3.E3_NUM AND E3_PREFIXO = SE3.E3_PREFIXO AND E3_TIPO = SE3.E3_TIPO AND E3_VEND = SE3.E3_VEND AND E3_PARCELA = SE3.E3_PARCELA AND E3_BAIEMI = SE3.E3_BAIEMI AND D_E_L_E_T_ = '') * (D2_VALBRUT * 100 / F2_VALBRUT) / 100, 2),
  		cQry += " SE3.E3_PORC,
  		cQry += " ROUND((SELECT SUM(E3_COMIS) FROM SE3010 WHERE E3_NUM = SE3.E3_NUM AND E3_PREFIXO = SE3.E3_PREFIXO AND E3_TIPO = SE3.E3_TIPO AND E3_VEND = SE3.E3_VEND AND E3_PARCELA = SE3.E3_PARCELA AND E3_BAIEMI = SE3.E3_BAIEMI AND D_E_L_E_T_ = '') * (D2_VALBRUT * 100 / F2_VALBRUT) / 100, 2),
		cQry += " C5_DTEXP,A4_COD,A4_NREDUZ,SE3.E3_XTPCOMI,B1_COMOD,A7_XTPNEGO , E1_BAIXA,E3_PARCELA,(SELECT MAX(E1_PARCELA) FROM SE1010 E12 WHERE E12.E1_NUM = E3_NUM AND E3_PREFIXO = E12.E1_PREFIXO AND E3_TIPO = E12.E1_TIPO AND E12.D_E_L_E_T_ = '') MAXPARCELA, D2_EMISSAO 
		cQry += " FROM "+RetSqlName("SE3")+" SE3
		cQry += " INNER JOIN "+RetSqlName("SE1")+" E1 ON E1_NUM = E3_NUM AND E1_PARCELA = E3_PARCELA AND E3_PREFIXO = E1_PREFIXO AND E3_TIPO = E1_TIPO AND E1.D_E_L_E_T_ = ''
		cQry += " INNER JOIN "+RetSqlName("SD2")+" D2 ON D2_DOC = E3_NUM AND D2_SERIE = E3_SERIE AND D2_TIPO NOT IN ('D','B') AND D2.D_E_L_E_T_ = ''
		cQry += " INNER JOIN "+RetSqlName("SF2")+" F2 ON F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_TIPO = D2_TIPO AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2.D_E_L_E_T_ = ''
		cQry += " INNER JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO = D2_TES AND F4_DUPLIC = 'S' AND F4.D_E_L_E_T_ = ''
		cQry += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = D2_COD AND B1.D_E_L_E_T_ = ''
		cQry += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = SE3.E3_CODCLI AND A1_LOJA = SE3.E3_LOJA AND SA1.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN "+RetSqlName("SA7")+" A7 ON A7_CLIENTE = A1_COD AND A7_LOJA = A1_LOJA AND A7_PRODUTO = B1_COD AND A7.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN "+RetSqlName("SC5")+" C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = '' 
		cQry += " LEFT JOIN "+RetSqlName("SA4")+" A4 ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = '' 
		cQry += " INNER JOIN "+RetSqlName("SA3")+" SA3 ON A3_COD = SE3.E3_VEND  AND SA3.A3_MSBLQL <> '1'  AND SA3.D_E_L_E_T_ = ''
		cQry += " WHERE SE3.E3_FILIAL='" + xFilial("SE3")+"'  AND SE3.E3_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "'  
		cQry += " AND SE3.E3_VEND BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' AND Upper(E3_XTPCOMI) = Upper(CASE WHEN B1_COMOD = 'S' THEN 'COMMODITY' when A7_XTPNEGO != '' then 'NEGOCIACAO' else 'NORMAL' end)  
		cQry += " AND SE3.E3_BAIEMI = '"+Iif(MV_PAR01 == 1, 'E','B')+"' AND SE3.D_E_L_E_T_ = ''

		cQry += " UNION ALL

		cQry += " SELECT '3 - ITEM DEVOLUCAO',SE3.E3_VEND,SA3.A3_NOME,SE3.E3_SERIE, SE3.E3_NUM,D1_ITEM,D1_COD,B1_DESC,SE3.E3_CODCLI, SE3.E3_LOJA, A1_NREDUZ,SE3.E3_EMISSAO,-D1_VALICM,-D1_VALIPI,-D1_VALIMP6,-D1_VALIMP5,
		cQry += " Round(SE3.E3_ACRVEN1 * ((D1_TOTAL+D1_VALIPI) * 100 / (E3_BASE + E3_FRETED1 + E3_FRETENF + E3_IPI + E3_ACRVEN1 + E3_ICMS + E3_PIS + E3_COFINS)) / 100,2),
		cQry += " IsNull(C5_TPFRETE,''),
		cQry += " D1_VALFRE,
		cQry += " -D1_TOTAL,
		cQry += " -Round(E3_BASE * ((D1_TOTAL+D1_VALIPI) * 100 / (E3_BASE + E3_FRETED1 + E3_FRETENF + E3_IPI + E3_ACRVEN1 + E3_ICMS + E3_PIS + E3_COFINS)) / 100,2),
		cQry += " SE3.E3_PORC,
		cQry += " -Round(SE3.E3_COMIS * ((D1_TOTAL+D1_VALIPI) * 100 / (E3_BASE + E3_FRETED1 + E3_FRETENF + E3_IPI + E3_ACRVEN1 + E3_ICMS + E3_PIS + E3_COFINS)) / 100,2),
		cQry += " C5_DTEXP,A4_COD,A4_NREDUZ,SE3.E3_XTPCOMI,B1_COMOD,A7_XTPNEGO, E1_BAIXA,E3_PARCELA,(SELECT MAX(E1_PARCELA) FROM SE1010 E12 WHERE E12.E1_NUM = E3_NUM AND E3_PREFIXO = E12.E1_PREFIXO AND E3_TIPO = E12.E1_TIPO AND E12.D_E_L_E_T_ = '') MAXPARCELA, D2_EMISSAO
		cQry += " FROM "+RetSqlName("SE3")+" SE3
		cQry += " left JOIN "+RetSqlName("SE1")+" E1 ON E1_NUM = E3_NUM AND E1_PARCELA = E3_PARCELA AND E3_PREFIXO = E1_PREFIXO AND E3_TIPO = E1_TIPO AND E1.D_E_L_E_T_ = ''
		cQry += " INNER JOIN "+RetSqlName("SD1")+" D1 ON D1_DOC = E3_NUM AND D1_SERIE = E3_SERIE AND D1_TIPO = 'D' AND D1.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN "+RetSqlName("SD2")+" D2 ON D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND D2.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO = D1_TES AND F4_DUPLIC = 'S' AND F4.D_E_L_E_T_ = ''
		cQry += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = D1_COD AND B1.D_E_L_E_T_ = ''
		cQry += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = SE3.E3_CODCLI AND A1_LOJA = SE3.E3_LOJA AND SA1.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN "+RetSqlName("SA7")+" A7 ON A7_CLIENTE = A1_COD AND A7_LOJA = A1_LOJA AND A7_PRODUTO = B1_COD AND A7.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN "+RetSqlName("SC5")+" C5 ON C5_NOTA = E3_NUM AND C5_SERIE = E3_SERIE AND C5.D_E_L_E_T_ = '' 
		cQry += " LEFT JOIN "+RetSqlName("SA4")+" A4 ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = '' 
		cQry += " INNER JOIN "+RetSqlName("SA3")+" SA3 ON A3_COD = SE3.E3_VEND  AND SA3.A3_MSBLQL <> '1'  AND SA3.D_E_L_E_T_ = ''
		cQry += " WHERE SE3.E3_FILIAL='" + xFilial("SE3")+"'  AND SE3.E3_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "'  
		cQry += " AND SE3.E3_VEND BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'  
		cQry += " AND SE3.E3_BAIEMI = '"+Iif(MV_PAR01 == 1, 'E','B')+"' AND SE3.D_E_L_E_T_ = ''

		cQry += " ORDER BY E3_VEND,E3_EMISSAO,E3_SERIE,E3_NUM,TIPO

	EndIf

	MemoWrite("PFINR011_excel.txt",cQry)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"FINR",.T.,.F.)
		
	While FINR->(!EOF())
		If cVend != FINR->E3_VEND
			aAdd(aItens,{})
			aAdd(aItensEmiss, {})
			aAdd(aDetalhe, {})
			nVend++               
		EndIf
		cVend := FINR->E3_VEND
		lPorBaixa := .F.
		If Empty(FINR->C5_DTEXP)
			lPorBaixa := FINR->DOCEMIS > SuperGetMV("MV_LIMDTCO",,'20220720')
		Else
			lPorBaixa := FINR->C5_DTEXP > SuperGetMV("MV_LIMDTCO",,'20220720')
		EndIf
		If Trim(FINR->TIPO) == '1 - PRINCIPAL' .and. lPorBaixa
			//Adiciona os itens em um array          
			aAdd(aItens[nVend],{nVend,;
				FINR->E3_VEND,;
				FINR->A3_NOME,;
				FINR->E3_SERIE,;
				FINR->E3_NUM,;
				FINR->E3_CODCLI,;
				FINR->A1_NREDUZ,;
				FINR->E3_EMISSAO,;
				FINR->E3_BASE + FINR->E3_ICMS + FINR->E3_IPI + FINR->E3_PIS + FINR->E3_COFINS + FINR->E3_ACRVEN1 + FINR->E3_FRETE,;
				FINR->E3_ICMS,;
				FINR->E3_IPI,;
				FINR->E3_PIS,;
				FINR->E3_COFINS,;
				0,;	//FINR->E3_ACRVEN1,;
				FINR->E3_FRETE,;
				FINR->E3_BASE + FINR->E3_ACRVEN1,;	//FINR->E3_BASE,;
				FINR->E3_PORC,;
				FINR->E3_COMIS,;
				FINR->E3_LOJA,;
				FINR->C5_DTEXP,;
				FINR->A4_COD,;
				FINR->A4_NREDUZ,;
				FINR->C5_TPFRETE,;
				FINR->E3_XTPCOMI,;
				FINR->E1_BAIXA,;
				Iif(!empty(trim(FINR->E3_PARCELA)),FINR->E3_PARCELA+"/"+FINR->MAXPARCELA,'')})
		ElseIf Trim(FINR->TIPO) == '1 - PRINCIPAL' .and. !lPorBaixa
			//Adiciona os itens em um array          
			aAdd(aItensEmiss[nVend],{nVend,;
				FINR->E3_VEND,;
				FINR->A3_NOME,;
				FINR->E3_SERIE,;
				FINR->E3_NUM,;
				FINR->E3_CODCLI,;
				FINR->A1_NREDUZ,;
				FINR->E3_EMISSAO,;
				FINR->E3_BASE + FINR->E3_ICMS + FINR->E3_IPI + FINR->E3_PIS + FINR->E3_COFINS + FINR->E3_ACRVEN1 + FINR->E3_FRETE,;
				FINR->E3_ICMS,;
				FINR->E3_IPI,;
				FINR->E3_PIS,;
				FINR->E3_COFINS,;
				FINR->E3_ACRVEN1,;
				FINR->E3_FRETE,;
				FINR->E3_BASE,;
				FINR->E3_PORC,;
				FINR->E3_COMIS,;
				FINR->E3_LOJA,;
				FINR->C5_DTEXP,;
				FINR->A4_COD,;
				FINR->A4_NREDUZ,;
				FINR->C5_TPFRETE,;
				FINR->E3_XTPCOMI,;
				FINR->E1_BAIXA,;
				Iif(!empty(trim(FINR->E3_PARCELA)),FINR->E3_PARCELA+"/"+FINR->MAXPARCELA,'')})
		ElseIf lPorBaixa
			aAdd(aDetalhe[nVend],{nVend,;
				FINR->E3_VEND,;
				FINR->A3_NOME,;
				FINR->E3_SERIE,;
				FINR->E3_NUM,;
				FINR->E3_CODCLI,;
				FINR->A1_NREDUZ,;
				FINR->E3_EMISSAO,;
				FINR->E3_BASE + FINR->E3_ICMS + FINR->E3_IPI + FINR->E3_PIS + FINR->E3_COFINS + FINR->E3_ACRVEN1 + FINR->E3_FRETE,;
				FINR->E3_ICMS,;
				FINR->E3_IPI,;
				FINR->E3_PIS,;
				FINR->E3_COFINS,;
				0,;	//FINR->E3_ACRVEN1,;
				FINR->E3_FRETE,;
				FINR->E3_BASE + FINR->E3_ACRVEN1,;	//FINR->E3_BASE,;
				FINR->E3_PORC,;
				FINR->E3_COMIS,;
				FINR->E3_LOJA,;
				FINR->C5_DTEXP,;
				FINR->A4_COD,;
				FINR->A4_NREDUZ,;
				FINR->ITEM,;
				FINR->PRODUTO,;
				FINR->DESCPROD,;
				FINR->C5_TPFRETE,;
				FINR->E3_XTPCOMI,;
				FINR->B1_COMOD,;
				FINR->A7_XTPNEGO,;
				FINR->E1_BAIXA,;
				Iif(!empty(trim(FINR->E3_PARCELA)),FINR->E3_PARCELA+"/"+FINR->MAXPARCELA,'')})
		EndIf
		FINR->(dbskip())
	EndDo	 

	FINR->(DBCLOSEAREA())

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

		If len(aItens[1]) > 0

			For nVend := 1 to len(aItens)
				nTitulo := 0
				nBase 	:= 0
				nComis 	:= 0
				cVend := trim(aItens[nVend][1][3]) + " - RELATÓRIO DE COMISSÃO
				oExcel:AddworkSheet(cVend)
					oExcel:AddTable(cVend,cVend)
					oExcel:AddColumn(cVend,cVend,"Prefixo",1,1)
					oExcel:AddColumn(cVend,cVend,"Nº Título",1,1)
					oExcel:AddColumn(cVend,cVend,"Data da Baixa",1,1)
					oExcel:AddColumn(cVend,cVend,"Nº do Boleto",1,1)
					oExcel:AddColumn(cVend,cVend,"Cliente",1,1)
					oExcel:AddColumn(cVend,cVend,"Nome Fantasia",1,1)
					oExcel:AddColumn(cVend,cVend,"Data Comissão",1,1)
					oExcel:AddColumn(cVend,cVend,"Data Expedição",1,1)
					oExcel:AddColumn(cVend,cVend,"Valor Título",1,2)
					oExcel:AddColumn(cVend,cVend,"ICMS",1,2)
					oExcel:AddColumn(cVend,cVend,"IPI",1,2)
					oExcel:AddColumn(cVend,cVend,"PIS",1,2)
					oExcel:AddColumn(cVend,cVend,"COFINS",1,2)
					//oExcel:AddColumn(cVend,cVend,"Acresc Financeiro",1,2)
					oExcel:AddColumn(cVend,cVend,"TP Frete",1,2)
					oExcel:AddColumn(cVend,cVend,"Frete",1,2)
					oExcel:AddColumn(cVend,cVend,"Valor Base",1,2)
					oExcel:AddColumn(cVend,cVend,"%",1,2)
					oExcel:AddColumn(cVend,cVend,"Comissão",1,2)
					oExcel:AddColumn(cVend,cVend,"Transp.",1,1)
					oExcel:AddColumn(cVend,cVend,"Nome Transp.",1,1)
					nJ := 1
					For nJ := 1 to len(aItens[nVend])
						oExcel:AddRow(cVend,cVend,{aItens[nVend][nJ][4],;
						aItens[nVend][nJ][5],;
						Iif(!Empty(Trim(aItens[nVend][nJ][25])),DtoC(StoD(aItens[nVend][nJ][25])),''),;
						aItens[nVend][nJ][26],;
						aItens[nVend][nJ][6],;
						aItens[nVend][nJ][7],;
						DTOC(STOD(aItens[nVend][nJ][8])),;
						DTOC(STOD(aItens[nVend][nJ][20])),;
						Transform(aItens[nVend][nJ][9] ,"@E 999,999,999.99"),;
						Transform(aItens[nVend][nJ][10],"@E 999,999,999.99"),;
						Transform(aItens[nVend][nJ][11],"@E 999,999,999.99"),;
						Transform(aItens[nVend][nJ][12],"@E 999,999,999.99"),;
						Transform(aItens[nVend][nJ][13],"@E 999,999,999.99"),;	//Transform(aItens[nVend][nJ][14],"@E 999,999,999.99"),;
						aItens[nVend][nJ][23],;
						Transform(aItens[nVend][nJ][15],"@E 999,999,999.99"),;
						Transform(aItens[nVend][nJ][16],"@E 999,999,999.99"),;
						Transform(aItens[nVend][nJ][17],"@E 999,999,999.99"),;
						Transform(aItens[nVend][nJ][18],"@E 999,999,999.99"),;
						aItens[nVend][nJ][21],;
						aItens[nVend][nJ][22]})
						nTitulo += aItens[nVend][nJ][9]
						nBase 	+= aItens[nVend][nJ][16]
						nComis 	+= aItens[nVend][nJ][18]

					Next nJ 
					oExcel:AddRow(cVend,cVend,{'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					Transform(nTitulo,"@E 999,999,999.99"),;
					'',;
					'',;
					'',;
					'',;	//'',;
					'',;
					'',;
					Transform(nBase,"@E 999,999,999.99"),;
					'',;
					Transform(nComis,"@E 999,999,999.99"),;
					'',;
					''})


				If len(aDetalhe) > 0
					nTituloD := 0
					nBaseD 	:= 0
					nComisD := 0
					cVend := trim(aItens[nVend][1][3]) + " - DETALHAMENTO
					oExcel:AddworkSheet(cVend)
						oExcel:AddTable(cVend,cVend)
						oExcel:AddColumn(cVend,cVend,"Prefixo",1,1)
						oExcel:AddColumn(cVend,cVend,"Nº Título",1,1)
						oExcel:AddColumn(cVend,cVend,"Parcela",1,1)
						oExcel:AddColumn(cVend,cVend,"Cliente",1,1)
						oExcel:AddColumn(cVend,cVend,"Nome Fantasia",1,1)
						oExcel:AddColumn(cVend,cVend,"Item",1,1)
						oExcel:AddColumn(cVend,cVend,"Cód. Produto",1,1)
						oExcel:AddColumn(cVend,cVend,"Desc. Produto",1,1)
						oExcel:AddColumn(cVend,cVend,"Data Comissão",1,1)
						oExcel:AddColumn(cVend,cVend,"Data Expedição",1,1)
						oExcel:AddColumn(cVend,cVend,"Valor Título",1,2)
						oExcel:AddColumn(cVend,cVend,"ICMS",1,2)
						oExcel:AddColumn(cVend,cVend,"IPI",1,2)
						oExcel:AddColumn(cVend,cVend,"PIS",1,2)
						oExcel:AddColumn(cVend,cVend,"COFINS",1,2)
						//oExcel:AddColumn(cVend,cVend,"Acresc Financeiro",1,2)
						oExcel:AddColumn(cVend,cVend,"TP Frete",1,2)
						oExcel:AddColumn(cVend,cVend,"Frete",1,2)
						oExcel:AddColumn(cVend,cVend,"Valor Base",1,2)
						oExcel:AddColumn(cVend,cVend,"%",1,2)
						oExcel:AddColumn(cVend,cVend,"Comissão",1,2)
						oExcel:AddColumn(cVend,cVend,"Transp.",1,1)
						oExcel:AddColumn(cVend,cVend,"Nome Transp.",1,1)
						oExcel:AddColumn(cVend,cVend,"Commodity",1,1)
						oExcel:AddColumn(cVend,cVend,"Tipo de Negociação",1,1)
						oExcel:AddColumn(cVend,cVend,"Data da Baixa",1,1)

						For nJ := 1 to len(aDetalhe[nVend])
							oExcel:AddRow(cVend,cVend,{aDetalhe[nVend][nJ][4],;
							aDetalhe[nVend][nJ][5],;
							aDetalhe[nVend][nJ][31],;
							aDetalhe[nVend][nJ][6],;
							aDetalhe[nVend][nJ][7],;
							aDetalhe[nVend][nJ][23],;
							aDetalhe[nVend][nJ][24],;
							aDetalhe[nVend][nJ][25],;
							DTOC(STOD(aDetalhe[nVend][nJ][8])),;
							DTOC(STOD(aDetalhe[nVend][nJ][20])),;
							Transform(aDetalhe[nVend][nJ][9] ,"@E 999,999,999.99"),;
							Transform(aDetalhe[nVend][nJ][10],"@E 999,999,999.99"),;
							Transform(aDetalhe[nVend][nJ][11],"@E 999,999,999.99"),;
							Transform(aDetalhe[nVend][nJ][12],"@E 999,999,999.99"),;
							Transform(aDetalhe[nVend][nJ][13],"@E 999,999,999.99"),;	//Transform(aDetalhe[nVend][nJ][14],"@E 999,999,999.99"),;
							aDetalhe[nVend][nJ][26],;
							Transform(aDetalhe[nVend][nJ][15],"@E 999,999,999.99"),;
							Transform(aDetalhe[nVend][nJ][16],"@E 999,999,999.99"),;
							Transform(aDetalhe[nVend][nJ][17],"@E 999,999,999.99"),;
							Transform(aDetalhe[nVend][nJ][18],"@E 999,999,999.99"),;
							aDetalhe[nVend][nJ][21],;
							aDetalhe[nVend][nJ][22],;
							aDetalhe[nVend][nJ][28],;
							Iif(aDetalhe[nVend][nJ][29]=='B','BID',Iif(aDetalhe[nVend][nJ][29]=='S','SPOT','')),;
							Iif(!Empty(Trim(aDetalhe[nVend][nJ][30])),DtoC(StoD(aDetalhe[nVend][nJ][30])),'')})
							nTituloD += aDetalhe[nVend][nJ][9]
							nBaseD 	+= aDetalhe[nVend][nJ][16]
							nComisD 	+= aDetalhe[nVend][nJ][18]
						Next nJ
						oExcel:AddRow(cVend,cVend,{'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						Transform(nTituloD,"@E 999,999,999.99"),;
						'',;
						'',;
						'',;
						'',;
						'',;	//'',;
						'',;
						Transform(nBaseD,"@E 999,999,999.99"),;
						'',;
						Transform(nComisD,"@E 999,999,999.99"),;
						'',;
						'',;
						'',;
						'',;
						''})
				EndIf
			Next nVend
		EndIf

		nVend := 1

		If len(aItensEmiss[1]) > 0
			For nVend := 1 to len(aItensEmiss)
				If len(aItensEmiss[nVend]) > 0
				nTitulo := 0
				nBase 	:= 0
				nComis 	:= 0
				cVend := trim(aItensEmiss[nVend][1][3]) + " - PAGTO POR EXPEDIÇÃO
				oExcel:AddworkSheet(cVend)
					oExcel:AddTable(cVend,cVend)
					oExcel:AddColumn(cVend,cVend,"Prefixo",1,1)
					oExcel:AddColumn(cVend,cVend,"Nº Título",1,1)
					oExcel:AddColumn(cVend,cVend,"Data da Baixa",1,1)
					oExcel:AddColumn(cVend,cVend,"Nº do Boleto",1,1)
					oExcel:AddColumn(cVend,cVend,"Cliente",1,1)
					oExcel:AddColumn(cVend,cVend,"Nome Fantasia",1,1)
					oExcel:AddColumn(cVend,cVend,"Data Comissão",1,1)
					oExcel:AddColumn(cVend,cVend,"Data Expedição",1,1)
					oExcel:AddColumn(cVend,cVend,"Valor Título",1,2)
					oExcel:AddColumn(cVend,cVend,"ICMS",1,2)
					oExcel:AddColumn(cVend,cVend,"IPI",1,2)
					oExcel:AddColumn(cVend,cVend,"PIS",1,2)
					oExcel:AddColumn(cVend,cVend,"COFINS",1,2)
					oExcel:AddColumn(cVend,cVend,"Acresc Financeiro",1,2)
					oExcel:AddColumn(cVend,cVend,"TP Frete",1,2)
					oExcel:AddColumn(cVend,cVend,"Frete",1,2)
					oExcel:AddColumn(cVend,cVend,"Valor Base",1,2)
					oExcel:AddColumn(cVend,cVend,"%",1,2)
					oExcel:AddColumn(cVend,cVend,"Comissão",1,2)
					oExcel:AddColumn(cVend,cVend,"Transp.",1,1)
					oExcel:AddColumn(cVend,cVend,"Nome Transp.",1,1)
					nJ := 1
					For nJ := 1 to len(aItensEmiss[nVend])
						oExcel:AddRow(cVend,cVend,{aItensEmiss[nVend][nJ][4],;
						aItensEmiss[nVend][nJ][5],;
						Iif(!Empty(Trim(aItensEmiss[nVend][nJ][25])),DtoC(StoD(aItensEmiss[nVend][nJ][25])),''),;
						aItensEmiss[nVend][nJ][26],;
						aItensEmiss[nVend][nJ][6],;
						aItensEmiss[nVend][nJ][7],;
						DTOC(STOD(aItensEmiss[nVend][nJ][8])),;
						DTOC(STOD(aItensEmiss[nVend][nJ][20])),;
						Transform(aItensEmiss[nVend][nJ][9] ,"@E 999,999,999.99"),;
						Transform(aItensEmiss[nVend][nJ][10],"@E 999,999,999.99"),;
						Transform(aItensEmiss[nVend][nJ][11],"@E 999,999,999.99"),;
						Transform(aItensEmiss[nVend][nJ][12],"@E 999,999,999.99"),;
						Transform(aItensEmiss[nVend][nJ][13],"@E 999,999,999.99"),;
						Transform(aItensEmiss[nVend][nJ][14],"@E 999,999,999.99"),;
						aItensEmiss[nVend][nJ][23],;
						Transform(aItensEmiss[nVend][nJ][15],"@E 999,999,999.99"),;
						Transform(aItensEmiss[nVend][nJ][16],"@E 999,999,999.99"),;
						Transform(aItensEmiss[nVend][nJ][17],"@E 999,999,999.99"),;
						Transform(aItensEmiss[nVend][nJ][18],"@E 999,999,999.99"),;
						aItensEmiss[nVend][nJ][21],;
						aItensEmiss[nVend][nJ][22]})
						nTitulo += aItensEmiss[nVend][nJ][9]
						nBase 	+= aItensEmiss[nVend][nJ][16]
						nComis 	+= aItensEmiss[nVend][nJ][18]
						
					Next nJ 
					oExcel:AddRow(cVend,cVend,{'',;
					'',;
					'',;
					'',;
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
					'',;
					Transform(nBase,"@E 999,999,999.99"),;
					'',;
					Transform(nComis,"@E 999,999,999.99"),;
					'',;
					''})
				EndIf
			Next nVend
		EndIf


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
