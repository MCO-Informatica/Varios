#include "rwmake.ch"  

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR02  ³ Autor ³Ilidio F. Abreu        ³ Data ³ 21/11/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exportação dos dados do Ctas. a Pagar para Excel conforme  .³±±
±±³          ³conforme parâmetros selecionados pelo usuário               ´±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico: Laselva                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                         

/*
MV_PAR01 - Emissão de:
MV_PAR02 - Emissão até:
MV_PAR03 - Vencimento de:
MV_PAR04 - Vencimento até:
MV_PAR05 - Cond. Pagamento de:
MV_PAR06 - Cond. Pagamento até:
MV_PAR07 - Filial Origem de:
MV_PAR08 - Filial Origem até:
*/   

user Function FINR02

//________________________________________________cNome := UsrRetName(SC7->C7_USER)

Local cPerg := "FINR02"
If !Pergunte(cPerg,.T.)
	Return
Endif  


cQuery := " SELECT "


cQuery += "SE2.E2_LOJA,SE2.E2_EMISSAO,SE2.E2_VENCTO,SE2.E2_VENCREA,SE2.E2_NATUREZ,SE2.E2_CLASS,SE2.E2_HIST,SE2.E2_PORTADO,"
cQuery += "SE2.E2_ISS,SE2.E2_IRRF,SE2.E2_SALDO,SE2.E2_DESCONT,SE2.E2_MULTA,SE2.E2_JUROS,SE2.E2_TITORIG,SE2.E2_INSS,"
cQuery += "SE2.E2_ACRESC,SE2.E2_DECRESC,SE2.E2_PIS,SE2.E2_COFINS,SE2.E2_CSLL,SE2.E2_CCD,SE2.E2_CCC,SE2.E2_PIS FROM "
cQuery += RetSqlName("SE2")+" SE2,"+RetSqlName("SF1")+" SF1" 
cQuery += " WHERE SE2.E2_FILORIG >= '"+MV_PAR07+"' AND SE2.E2_FILORIG <= '"+MV_PAR08+"' AND"
cQuery += " SE2.E2_EMISSAO >= "+DTOS(MV_PAR01)+" AND SE2.E2_EMISSAO <= "+DTOS(MV_PAR02)+" AND"  
cQuery += " SE2.E2_VENCTO >= "+DTOS(MV_PAR03)+" AND SE2.E2_VENCTO <= "+DTOS(MV_PAR04)+" AND" 
cQuery += " SE2.E2_FILIAL = SF1.F1_FILIAL AND SE2.E2_EMISSAO = SF1.F1_EMISSAO AND"
cQuery += " SF1.F1_DUPL = SE2.E2_NUM AND SF1.F1_EMISSAO = SE2.E2_EMISSAO AND SF1.F1_FORNECE = SE2.E2_FORNECE AND" 
cQuery += " SE2.E2_LOJA =  SF1.F1_LOJA AND SF1.F1_COND >= '"+MV_PAR05+"' AND SF1.F1_COND <= '"+MV_PAR06+"'"
cQuery += " ORDER BY SE2.E2_FORNECE


RETURN
  /*                                     
SELECT SF1.F1_COND AS COND_PAGTO,SE4.E4_DESCRI,SE2.E2_FILORIG,SE2.E2_FILIAL,SE2.E2_MATRIZ,SE2.E2_FORNECE, SE2.E2_LOJA,;
SE2.E2_NOMFOR,SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA,;
(CONVERT(varchar(8),(SE2.E2_EMISSAO),103)) EMISSAO,;
(CONVERT(varchar(8),(SE2.E2_VENCTO),103)) VENCTO,   ;
(CONVERT(varchar(8),(SE2.E2_VENCREA),103)) VENCTO_REAL,;
(CONVERT(varchar(8),(SF1.F1_DTDIGIT),113)) DATA_DIG,    ;
SE2.E2_VALOR,SE2.E2_SALDO,SE2.E2_BAIXA,SE2.E2_NATUREZ,SE2.E2_CLASS,SE2.E2_HIST,SE2.E2_PORTADO,SE2.E2_ISS, ;
SE2.E2_IRRF,SE2.E2_DESCONT,SE2.E2_MULTA,SE2.E2_JUROS,                                                      ;
SE2.E2_TITORIG,SE2.E2_INSS,SE2.E2_ACRESC,SE2.E2_DECRESC,SE2.E2_PIS,SE2.E2_COFINS,SE2.E2_CSLL,SE2.E2_CCD,SE2.E2_CCC;
FROM SE2010 SE2,SF1010 SF1, SE4010 SE4 WHERE SE2.E2_FILORIG >= '  ' AND SE2.E2_FILORIG <= 'ZZ' ;
AND SF1.D_E_L_E_T_ 		= '' ;
AND SE2.D_E_L_E_T_ 		= '' ;
AND SE2.E2_EMISSAO >= 20090101 AND SE2.E2_EMISSAO <= 20210101 AND SE2.E2_VENCTO >= 20140101 AND SE2.E2_VENCTO <= 20141231 ;
AND SF1.F1_FORNECE = SE2.E2_FORNECE;
AND SE2.E2_LOJA = SF1.F1_LOJA       ;
AND SF1.F1_DUPL = SE2.E2_NUM         ;
AND SE2.E2_EMISSAO = SF1.F1_EMISSAO   ;
AND SF1.F1_COND >= '    '  AND SF1.F1_COND <=  '999' AND SE4.E4_CODIGO = SF1.F1_COND
*/