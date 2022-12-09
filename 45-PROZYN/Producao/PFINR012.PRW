#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PFINR012   º Autor ³ Denis Varella      Data ³ 27/11/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de 1.	Detalham apuração de Margens - Comissão   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn  			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PFINR012(_dDatade,_dDatate,_cVende,_cVenate)  

Private _cRotina	:= "PFINR012"
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
		
					MV_PAR01:=_dDatade
		    		MV_PAR02:=_dDatate
		    		MV_PAR03:=_cVende
		    		MV_PAR04:=_cVenate       
		    
		    	Processa({ |lEnd| GeraExcel(@lEnd) },_cRotina,"Gerando Apuração de Margem... Por favor aguarde!",.T.)
			
		  Else       
			//Chamada da função para geração do relatório     
		   
			AjustaSx1(_cRotina)
			If Pergunte(_cRotina,.T.)  
							
						If MV_PAR05 == 1
					   		Processa({ |lEnd| GeraPDF(@lEnd) },_cRotina,"Gerando Apuração de Margem... Por favor aguarde!",.T.)
						Else 
							Processa({ |lEnd| GeraExcel(@lEnd) },_cRotina,"Gerando Apuração de Margem... Por favor aguarde!",.T.)
						EndIf
			
			Endif
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
AADD(	aSx1,{ cPerg,"01","Considera da data:"			,"","","mv_par01"	,"D",8,0,0, "G","", 	"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"02","Até a data:"					,"","","mv_par02"	,"D",8,0,0, "G","",		"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(	aSx1,{ cPerg,"03","Do vendedor:"				,"","","mv_par03"	,"C",6,0,0, "G","",		"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})
AADD(	aSx1,{ cPerg,"04","Até o vendedor:"				,"","","mv_par04"	,"C",6,0,0, "G","",		"mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})
AADD(	aSx1,{ cPerg,"05","Imprimir em:"				,"","","mv_par05" 	,"C",1,0,3, "C","",		"mv_par05","1 - PDF","","","","","2 - Excel","","","","","","","","","","","","","","","","","","","","",""})

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

//Consulta no banco de dados para retornar todos os itens que geraram financeiro, para revisão dos percentuais de comissão
_cQry += "SELECT TMP.*, B1_DESC, A3_CODREG [REGRA], ISNULL(ZS_PCOMISS,0) [COMIS_NEW], A3_NOME, A1_NREDUZ [NOM_CLI] FROM ( " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND1 [F2_VEND], D2_COMIS1 [D2_COMIS], 1 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND1<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM1='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND2 [F2_VEND], D2_COMIS2 [D2_COMIS], 2 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM] " + _cEnter
_cQry += ",'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND2 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND2<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM2='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND3 [F2_VEND], D2_COMIS3 [D2_COMIS], 3 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND3 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter	
_cQry += "AND SF2.F2_VEND3<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM3='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND4 [F2_VEND], D2_COMIS4 [D2_COMIS], 4 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND4 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND4<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM4='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND5 [F2_VEND], D2_COMIS5 [D2_COMIS], 5 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND5 BETWEEN '" + MV_PAR03 + "'	AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND5<>'' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += ") TMP " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) " + _cEnter
_cQry += "ON SB1.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SB1.B1_FILIAL='" +  xFilial("SB1") + "' " + _cEnter
_cQry += "AND TMP.D2_COD=SB1.B1_COD " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + _cEnter
_cQry += "ON SA3.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SA3.A3_FILIAL='" + xFilial("SA3") + "' " + _cEnter
_cQry += "AND TMP.F2_VEND=SA3.A3_COD " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " + _cEnter
_cQry += "ON SA1.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnter
_cQry += "AND SA1.A1_COD=TMP.F2_CLIENTE " + _cEnter
_cQry += "AND SA1.A1_LOJA=TMP.F2_LOJA " + _cEnter
_cQry += "AND TMP.F2_TIPO NOT IN ('D','B') " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZS") + " ZS WITH (NOLOCK) " + _cEnter
_cQry += "ON ZS.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += " TMP.MARGEM>= ZS_MRGMIN AND " + _cEnter
_cQry += " TMP.MARGEM <= ZS_MRGMAX AND " + _cEnter
_cQry += " A3_CODREG = ZS_CODREG " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SF4") + " SF4 " + _cEnter
_cQry += "ON SF4.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF4.F4_FILIAL='" + xFilial("SF4") + "' " + _cEnter
_cQry += "AND TMP.D2_TES=SF4.F4_CODIGO " + _cEnter
_cQry += "AND SF4.F4_DUPLIC='S' " + _cEnter
_cQry += "ORDER BY F2_VEND, F2_EMISSAO, F2_SERIE, F2_DOC "

MemoWrite("PFINR012_pdf.txt",_cQry)

_cAliasTmp := GetNextAlias()

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)

dbSelectArea(_cAliasTmp)
 
(_cAliasTmp)->(dbgotop()) 	
While (_cAliasTmp)->(!EOF())
	If cVend != (_cAliasTmp)->F2_VEND
		aAdd(aItens,{})
		nVend++               
	EndIf  
	cVend := (_cAliasTmp)->F2_VEND
	nItem++
	//Adiciona os itens em um array 
    aAdd(aItens[nVend],{nVend,;
   	(_cAliasTmp)->F2_VEND,;
	(_cAliasTmp)->A3_NOME,;
	(_cAliasTmp)->F2_SERIE,;
	(_cAliasTmp)->F2_DOC,;
	(_cAliasTmp)->F2_CLIENTE,;
	(_cAliasTmp)->NOM_CLI,;
	(_cAliasTmp)->F2_EMISSAO,;
	(_cAliasTmp)->D2_COD,; //9
	(_cAliasTmp)->B1_DESC,;//10
	(_cAliasTmp)->D2_QUANT,;//11
	(_cAliasTmp)->D2_PRCVEN,;//12
   	(_cAliasTmp)->D2_TOTAL,; //13
	(_cAliasTmp)->MARGEM,; //14
	(_cAliasTmp)->REGRA,;  //15
	(_cAliasTmp)->D2_COMIS}) //16
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
oPrn:SayAlign(  _nLin , _nCol, "Série", 			oFont03, _nCol*6,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*6, "Nº NFiscal", 		oFont03, _nCol*7,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*15, "Cliente", 		oFont03, _nCol*5,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*20, "Nome Fantasia", 	oFont03, _nCol*12,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*32, "Dt Emissão", 	oFont03, _nCol*6,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*38, "Cod. Prod.", 	oFont03, _nCol*6,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*44, "Descrição", 		oFont03, _nCol*16,0060,,0,0)
oPrn:SayAlign(  _nLin , _nCol*60, "Quantidade", 	oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*66, "Preç. Vend.", 	oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*72, "Vlr Total", 		oFont03, _nCol*6,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*78, "Margem", 		oFont03, _nCol*5,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*83, "Regra", 			oFont03, _nCol*5,0060,,1,0)
oPrn:SayAlign(  _nLin , _nCol*88, "% Comiss", 		oFont03, _nCol*6,0060,,1,0)

Return


Static Function corpo(aItens,nVend)

Local nTotal := 0        
Local cMoeda := '' 
Local _nCol := (0845 / 100)
Local _nLin := 120
Local nTitulo := 0 
Local nBase := 0 
Local nComis := 0 
Local nJ	:=0 

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
	oPrn:SayAlign(  _nLin , _nCol*38, 	aItens[nVend][nJ][9], oFont04, _nCol*6,0060,,0,0)
	oPrn:SayAlign(  _nLin , _nCol*44, 	aItens[nVend][nJ][10],oFont04, _nCol*16,0060,,0,0)
	oPrn:SayAlign(  _nLin , _nCol*60, 	trim(Transform(aItens[nVend][nJ][11],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*66, 	trim(Transform(aItens[nVend][nJ][12],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*72, 	trim(Transform(aItens[nVend][nJ][13],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*78, 	trim(Transform(aItens[nVend][nJ][14],"@E 999,999,999.99")), oFont04, _nCol*5,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*83, 	aItens[nVend][nJ][15], oFont04, _nCol*5,0060,,1,0)
	oPrn:SayAlign(  _nLin , _nCol*88, 	trim(Transform(aItens[nVend][nJ][16],"@E 999,999,999.99")), oFont04, _nCol*6,0060,,1,0)
	nTitulo	+= aItens[nVend][nJ][13]
Next
	_nLin+=15  
	oPrn:Box( _nLin-1, 03, _nLin, _nCol*96, "-4")
	oPrn:SayAlign(  _nLin , _nCol*72, 	trim(Transform(nTitulo,"@E 999,999,999.99")),  oFont04N, _nCol*6,0060,,1,0)

oPrn:EndPage()
Return

Static Function ImpLogo()

	Local cLogo      	:= FisxLogo("1")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Logotipo                                     						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	cLogo := GetSrvProfString("Startpath","") + "Logoret.BMP"
	
	oPrn:SayBitmap(030,005,cLogo ,90,70)  
	oPrn:SayAlign(070 , 0005, "Detalhamento Apuração de Margens de Comissões", oFont01N, 0845,0060,,2,1)  

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

//Consulta no banco de dados para retornar todos os itens que geraram financeiro, para revisão dos percentuais de comissão
_cQry += "SELECT TMP.*, B1_DESC, A3_CODREG [REGRA], ISNULL(ZS_PCOMISS,0) [COMIS_NEW], A3_NOME, A1_NREDUZ [NOM_CLI] FROM ( " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND1 [F2_VEND], D2_COMIS1 [D2_COMIS], 1 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND1<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM1='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND2 [F2_VEND], D2_COMIS2 [D2_COMIS], 2 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM] " + _cEnter
_cQry += ",'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND2 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND2<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM2='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND3 [F2_VEND], D2_COMIS3 [D2_COMIS], 3 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND3 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter	
_cQry += "AND SF2.F2_VEND3<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM3='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND4 [F2_VEND], D2_COMIS4 [D2_COMIS], 4 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND4 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND4<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM4='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND5 [F2_VEND], D2_COMIS5 [D2_COMIS], 5 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "D2_VALICM, D2_VALIPI, D2_VALIMP5, D2_VALIMP6,(D2_VALBRUT)-((D2_VALICM)+(D2_VALIPI)+(D2_VALIMP5)+(D2_VALIMP6)) [D2_VALIQ], D2_VALBRUT, " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND5 BETWEEN '" + MV_PAR03 + "'	AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND5<>'' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += ") TMP " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) " + _cEnter
_cQry += "ON SB1.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SB1.B1_FILIAL='" +  xFilial("SB1") + "' " + _cEnter
_cQry += "AND TMP.D2_COD=SB1.B1_COD " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + _cEnter
_cQry += "ON SA3.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SA3.A3_FILIAL='" + xFilial("SA3") + "' " + _cEnter
_cQry += "AND TMP.F2_VEND=SA3.A3_COD " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " + _cEnter
_cQry += "ON SA1.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnter
_cQry += "AND SA1.A1_COD=TMP.F2_CLIENTE " + _cEnter
_cQry += "AND SA1.A1_LOJA=TMP.F2_LOJA " + _cEnter
_cQry += "AND TMP.F2_TIPO NOT IN ('D','B') " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZS") + " ZS WITH (NOLOCK) " + _cEnter
_cQry += "ON ZS.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += " TMP.MARGEM>= ZS_MRGMIN AND " + _cEnter
_cQry += " TMP.MARGEM <= ZS_MRGMAX AND " + _cEnter
_cQry += " A3_CODREG = ZS_CODREG " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SF4") + " SF4 " + _cEnter
_cQry += "ON SF4.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF4.F4_FILIAL='" + xFilial("SF4") + "' " + _cEnter
_cQry += "AND TMP.D2_TES=SF4.F4_CODIGO " + _cEnter
_cQry += "AND SF4.F4_DUPLIC='S' " + _cEnter
_cQry += "ORDER BY F2_VEND, F2_EMISSAO, F2_SERIE, F2_DOC "

MemoWrite("PFINR012_Excel.txt",_cQry)

_cAliasTmp := GetNextAlias()

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)


dbSelectArea(_cAliasTmp)
 
(_cAliasTmp)->(dbgotop()) 	
While (_cAliasTmp)->(!EOF())
	If cVend != (_cAliasTmp)->F2_VEND
		aAdd(aItens,{})
		nVend++               
	EndIf  
	cVend := (_cAliasTmp)->F2_VEND
	nItem++
	//Adiciona os itens em um array 
    aAdd(aItens[nVend],{nVend,;
   	(_cAliasTmp)->F2_VEND,;
	(_cAliasTmp)->A3_NOME,;
	(_cAliasTmp)->F2_SERIE,;
	(_cAliasTmp)->F2_DOC,;
	(_cAliasTmp)->F2_CLIENTE,;
	(_cAliasTmp)->NOM_CLI,;
	(_cAliasTmp)->F2_EMISSAO,;
	(_cAliasTmp)->D2_COD,; //9
	(_cAliasTmp)->B1_DESC,;//10
	(_cAliasTmp)->D2_QUANT,;//11
	(_cAliasTmp)->D2_PRCVEN,;//12
   	(_cAliasTmp)->D2_TOTAL,; //13
	(_cAliasTmp)->MARGEM,; //14
	(_cAliasTmp)->REGRA,;  //15
	(_cAliasTmp)->D2_COMIS}) //16
	dbskip()
EndDo	 

(_cAliasTmp)->(DBCLOSEAREA())

oExcel:AddworkSheet("PARÂMETROS")
oExcel:AddTable("PARÂMETROS","PARÂMETROS")
oExcel:AddColumn("PARÂMETROS","PARÂMETROS","PARAMETROS",1,1)
oExcel:AddColumn("PARÂMETROS","PARÂMETROS","VALOR",1,1)
//oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Listar por:',;
//Iif(MV_PAR01 == 1,'Emissão',Iif(MV_PAR01 == 2,'Baixa','Ambos'))})
oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Considera da data:',;
DTOC(mv_par01)})
oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Até a data:',;
DTOC(mv_par02)})
oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Do vendedor:',;
mv_par03})
oExcel:AddRow("PARÂMETROS","PARÂMETROS",{'Até o vendedor:',;
mv_par04})

          
For nVend := 1 to len(aItens)
nTitulo := 0
cVend := trim(aItens[nVend][1][3]) + " - Apuração de Margem
oExcel:AddworkSheet(cVend)
oExcel:AddTable(cVend,cVend)
oExcel:AddColumn(cVend,cVend,"Série",1,1)
oExcel:AddColumn(cVend,cVend,"Nº NFiscal",1,1)
oExcel:AddColumn(cVend,cVend,"Cliente",1,1)
oExcel:AddColumn(cVend,cVend,"Nome Fantasia",1,1)
oExcel:AddColumn(cVend,cVend,"Dt Emissão",1,1)
oExcel:AddColumn(cVend,cVend,"Cod. Prod.",1,1)    
oExcel:AddColumn(cVend,cVend,"Descrição",1,1)
oExcel:AddColumn(cVend,cVend,"Quantidade",1,2)
oExcel:AddColumn(cVend,cVend,"Preç. Vend.",1,2)
oExcel:AddColumn(cVend,cVend,"Vlr Total",1,2)
oExcel:AddColumn(cVend,cVend,"Margem",1,2)
oExcel:AddColumn(cVend,cVend,"Regra",1,1)
oExcel:AddColumn(cVend,cVend,"% Comiss",1,2)
                               

For nJ := 1 to len(aItens[nVend])
oExcel:AddRow(cVend,cVend,{aItens[nVend][nJ][4],;
aItens[nVend][nJ][5],;
aItens[nVend][nJ][6],;
aItens[nVend][nJ][7],;
DTOC(STOD(aItens[nVend][nJ][8])),;
aItens[nVend][nJ][9],;
aItens[nVend][nJ][10],;
Transform(aItens[nVend][nJ][11],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][12],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][13],"@E 999,999,999.99"),;
Transform(aItens[nVend][nJ][14],"@E 999,999,999.99"),;
aItens[nVend][nJ][15],;
Transform(aItens[nVend][nJ][16],"@E 999,999,999.99")})
nTitulo += aItens[nVend][nJ][13]
Next nJ                              
/*
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
'',;
'',;
Transform(nTitulo,"@E 999,999,999.99"),;
'',;
''})
*/
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