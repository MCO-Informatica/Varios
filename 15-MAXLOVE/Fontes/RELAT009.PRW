#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RBORDER1  ºAutor  ³ Luiz Torres (MCInfotec)     10/08/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório Back Order                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Alka                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RBORDER1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg 	 := PadR ("RBORDER1", Len (SX1->X1_GRUPO))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSx1(cPerg,"01","Periodo de?"  ,'','',"mv_ch1","D", 8 , 0,,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Periodo ate?" ,'','',"mv_ch2","D", 8 , 0,,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Cliente de?"  ,'','',"mv_ch3","C",TamSx3 ("A1_COD")[1] ,0,,"G","","SA1","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Loja de ?"    ,'','',"mv_ch4","C",TamSx3 ("A1_LOJA")[1] ,0,,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","Cliente ate?" ,'','',"mv_ch5","C",TamSx3 ("A1_COD")[1] ,0,,"G","","SA1","","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"06","Loja ate ?"   ,'','',"mv_ch6","C",TamSx3 ("A1_LOJA")[1] ,0,,"G","","","","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"07","Produto de?"  ,'','',"mv_ch7","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par07","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"08","Produto ate?" ,'','',"mv_ch8","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par08","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"09","Imprimir Tipos de Pendencias","","", "mv_ch9", "C", 50, 0, 0, "G", "", "", "", "", "mv_par09")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicoes/preparacao para impressao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ReportDef()
oReport:PrintDialog()

Return Nil


Static Function ReportDef()

oReport := TReport():New("RBORDER1","Back Order",cPerg,{|oReport| PrintReport(oReport)},"Relatório Back Order")
oReport:SetLandscape(.T.)

oSecCab := TRSection():New( oReport , "Pedidos", {"QRY"} )
 
TRCell():New( oSecCab, 'BACKORDER',	   	'QRY', 'Motivo Back Order',		    PesqPict( 'SA3', 'A3_NOME' ),	25,,	 						    { || QRY->X5_DESCRI } )
TRCell():New( oSecCab, "A1_EST"    , "QRY")
TRCell():New( oSecCab, 'NOMEVEN',	   	'QRY', 'Vendedor',		    PesqPict( 'SA3', 'A3_NOME' ),	15,,	 						    { || QRY->A3_NOME } )
TRCell():New( oSecCab, 'EMISSAO',	   	'QRY', 'Emissao',		    PesqPict( 'SC5', 'C5_EMISSAO' ),	8,,	 						    { || Substr(QRY->C5_EMISSAO,7,2)+"/"+Substr(QRY->C5_EMISSAO,5,2)+"/"+Substr(QRY->C5_EMISSAO,3,2) } )
TRCell():New( oSecCab, "C6_NUM"     , "QRY")
TRCell():New( oSecCab, "A1_COD"    , "QRY")  
TRCell():New( oSecCab, 'NOMECLI',	   	'QRY', 'Nome Cliente',		    PesqPict( 'SA1', 'A1_NOME' ),	20,,	 						    { || QRY->A1_NOME } )
TRCell():New( oSecCab, "C6_PRODUTO"    , "QRY")  
TRCell():New( oSecCab, "C6_DESCRI"    , "QRY")  
TRCell():New( oSecCab, "QTDVEN"       ,	"QRY", "Qtd.Vendida",  PesqPict( 'SC6', 'C6_QTDVEN' ),		12,, { || QRY->C6_QTDVEN } )
TRCell():New( oSecCab, "C6_QTDENT"    , "QRY")
TRCell():New( oSecCab, 'PREVFAT',	   	'QRY', 'Prev.Fatura',	    PesqPict( 'SC6', 'C6_DATFAT' ),	8,,	 						    { || Substr(QRY->C5_AKDTENT,7,2)+"/"+Substr(QRY->C5_AKDTENT,5,2)+"/"+Substr(QRY->C5_AKDTENT,3,2) } )
TRCell():New( oSecCab, "QTPEND"       ,	"QRY", "Qtd.Pendente",  PesqPict( 'SC6', 'C6_QTDVEN' ),		12,, { || (QRY->C6_QTDVEN-QRY->C6_QTDENT) } )
TRCell():New( oSecCab, "VLPEND"       ,	"QRY", "Vl.Pendente",  PesqPict( 'SC6', 'C6_VALOR' ),		12,, { || (QRY->C6_QTDVEN-QRY->C6_QTDENT)*QRY->C6_PRCVEN } )

Return Nil


Static Function PrintReport(oReport)

Local cQuery     := ""

Pergunte(cPerg,.F.)

cQuery := "	SELECT C6_NUM, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_QTDENT, C6_PRCVEN, C6_DATFAT, C5_TIPPEND, C5_EMISSAO, C5_AKDTENT, A1_COD, A1_NOME, A1_EST, C5_VEND1, A3_NOME, X5_DESCRI "
cQuery += "	FROM "+RETSQLNAME("SC6")+" SC6 "
cQuery += "	LEFT JOIN "+RETSQLNAME("SC5")+" SC5 ON SC5.D_E_L_E_T_='' AND C5_FILIAL='"+xFilial("SC5")+"' AND C5_NUM=C6_NUM "
cQuery += "	LEFT JOIN "+RETSQLNAME("SA1")+" SA1 ON SA1.D_E_L_E_T_='' AND A1_COD=C6_CLI AND A1_LOJA=C6_LOJA "
cQuery += "	LEFT JOIN "+RETSQLNAME("SA3")+" SA3 ON SA3.D_E_L_E_T_='' AND A3_COD=C5_VEND1 "
cQuery += "	LEFT JOIN "+RETSQLNAME("SX5")+" SX5 ON SX5.D_E_L_E_T_='' AND X5_TABELA='A8' AND X5_CHAVE=C5_TIPPEND "
cQuery += "	WHERE SC6.D_E_L_E_T_=' ' "
cQuery += "	AND C6_BLQ <> 'R' "
cQuery += "	AND C6_QTDVEN <> C6_QTDENT "
cQuery += "	AND C5_TIPPEND <> 'Z' "
cQuery += "	AND C5_TIPPEND <> 'L' "
cQuery += " AND C5_TIPO = 'N' "   
cQuery += " AND C5_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"
cQuery += " AND C5_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par05+"'"
cQuery += " AND C5_LOJACLI BETWEEN '"+mv_par04+"' AND '"+mv_par06+"'"
cQuery += " AND C6_PRODUTO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
If !Empty(Mv_par09) // Deseja imprimir os tipos de pendencia
	cQuery += " 		AND C5_TIPPEND IN "+FormatIn(mv_par09,";") 
Endif 
cQuery += "	ORDER BY C6_NUM, C6_ITEM "
 
If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQuery New Alias "QRY"

oSecCab:BeginQuery()
oSecCab:EndQuery({{"QRY"},cQuery})
oSecCab:Print()

Return Nil