#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*****************************************************************************/
User Function DHESTR02()

Local oReport
Private aProdutos := {}
Private cPerg     := "DHESTR02"

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()

Return

/*****************************************************************************/
Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("DHESTR02","Etiqueta de Produtos","DHESTR02",{|oReport| PrintReport(oReport)},"")
oReport:lHeaderVisible:= .F.
oReport:lFooterVisible:= .F.
   
Pergunte(cPerg,.F.)

Return oReport

/*****************************************************************************/
Static Function PrintReport(oReport)

Local aFiliais := {}
Local nCount   := 0
Local oTFont   := TFont():New('Courier new',,-11,.T.)
Local oTFont1  := TFont():New('Courier new',,-10,.T.)
Local oTFont3  := TFont():New('Courier new',,-8,.T.)
Local nLin     := 113 //110
Local nCol     := 50 //100   
Local nQbr     := 0
Local nQbr1     := 0 
Local nX		:= 0

cQuery := "SELECT DA1_CODPRO,DA1_CODTAB,DA1_PRCVEN, DA1_VLRDES, DA1_DESC, DA0_FILIAL,DA0_CODTAB, "+CRLF
cQuery += "       B1_GRUPO,  B1_COD,    B1_DHQE,    B1_UM "+CRLF
cQuery += "FROM  "+RetSqlName("DA1")+" DA1,"+RetSQLName("DA0")+" DA0,"+Retsqlname("SB1")+" SB1 "+CRLF
cQuery += "WHERE DA1.D_E_L_E_T_ = ' '"+CRLF
cQuery += "AND  DA0.D_E_L_E_T_ = ' '"+CRLF  
cQuery += "AND  SB1.D_E_L_E_T_ = ' '"+CRLF  
cQuery += "AND DA1_CODTAB = DA0_CODTAB "+CRLF
cQuery += "AND DA1_CODPRO = B1_COD "+CRLF
cQuery += "AND DA1_CODPRO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "+CRLF
cQuery += "AND B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CRLF 
cQuery += "AND DA0_CODTAB BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "+CRLF
cQuery += "AND DA0_FILIAL = '"+MV_PAR08+"' "+CRLF
cQuery += "AND DA1_FILIAL = '"+MV_PAR08+"' "+CRLF
If MV_PAR05 == 1 .Or. MV_PAR05 == 2
	cQuery += "AND SB1.B1_DHABSM = '"+IIF( MV_PAR05 == 1 , "T" , "F" ) + "' "+CRLF
Endif                                                                     
cQuery += "ORDER BY DA1_CODPRO "+CRLF

If Select("TMPDA1") > 0
   	TMPDA1->( dbCloseArea() )
EndIf

cQuery := ChangeQuery(cQuery)
TcQuery cQuery NEW ALIAS "TMPDA1"

dbSelectArea("TMPDA1")
dbGoTop()

oReport:SetMeter(0)                       
//Monta Array com as contas SINTETICAS E ANALITICAS
While !Eof()
	If TMPDA1->DA1_DESC > 0
		AAdd(aProdutos, {TMPDA1->B1_COD,TMPDA1->B1_DHQE,TMPDA1->B1_UM,TMPDA1->DA1_PRCVEN,(TMPDA1->DA1_PRCVEN - TMPDA1->DA1_VLRDES) })
	Else
		AAdd(aProdutos, {TMPDA1->B1_COD,TMPDA1->B1_DHQE,TMPDA1->B1_UM,TMPDA1->DA1_PRCVEN, 0 })
	EndIf
    dbSkip()
End
                                           
TMPDA1->( dbCloseArea() )

oReport:SetMeter(Len(aProdutos))                       
oReport:StartPage()
//oReport:SetPaperSize(9)

For nX := 1 To Len(aProdutos)

	oReport:IncMeter()                       
	
   	nQbr++
	nQbr1++
	
	If nQbr > 5 
		nQbr := 1
		nLin += 255//265		
		nCol := 50
	EndIf                      
	
    If  nLin > 3173 //nQbr1 == 65 //,3290 ,nLin > 3170
	   	oReport:EndPage() 
	   	nQbr := 0
	   	nLin := 113
		nCol := 50
	EndIf
		
	cDescUm := POSICIONE("SAH",1,xFilial("SAH")+aProdutos[nX][3],"AH_UMRES")
	oReport:Say ( nLin    , nCol , "Ref.:" + aProdutos[nX][1], oTFont , ,  , )                                           
	oReport:Say ( nLin+53 , nCol , "Emb.:" + Alltrim(aProdutos[nX][2])+" "+ cDescUm, oTFont1 ,  ,  , )	  // aProdutos[nX][3]
    oReport:Say ( nLin+100 , nCol , "R$.:",oTFont , ,  , )    
    oReport:Say ( nLin+100 , nCol+50,Transform(aProdutos[nX][4],PesqPict("DA1","DA1_PRCVEN")),oTFont , ,  , )
    If aProdutos[nX][5] > 0 
	    oReport:Say ( nLin+150 , nCol , "Promoção:",oTFont1 , ,CLR_HRED, )
	    oReport:Say ( nLin+150 , nCol+100,Transform(aProdutos[nX][5],PesqPict("DA1","DA1_PRCVEN")),oTFont1,,CLR_HRED,)
	Else
		oReport:Say ( nLin+150 , nCol , " ",oTFont1 , ,  , )	 
	EndIf
    nCol += 480//480,500
        	    
Next nX

oReport:EndPage()

Return()  

/*************************************************************************
Função....: AjustaSX1
Autor.....: vinicius matos
Data......: 12/08/09                                                                            
Descrição.: Ajusta o dicionario de perguntas (SX1)

Parâmetros: cPerg    => Grupo de Pergunta que está sendo ajustado
Retorno   : Nenhum
**************************************************************************/
Static Function AjustaSX1(cPerg)

PutSx1( cPerg, "01", "Produto de ?" 		,""	,"","mv_ch1", "C", 15, 0, 0, "G", "","SB1", "", "", "mv_par01",,,,,,,,,,,,,,,,,{"Codigo Produto Inicial", "para considerar na", "geração do relatório."},{},{} )
PutSx1( cPerg, "02", "Produto Até ?"		,""	,"","mv_ch2", "C", 15, 0, 0, "G", "","SB1", "", "", "mv_par02",,,,,,,,,,,,,,,,,{"Codigo Produto Final",   "para considerar na", "geração do relatório."},{},{} )
PutSx1( cPerg, "03", "Grupo de ?"			,""	,"","mv_ch3", "C", 04, 0, 0, "G", "","SBM", "", "", "mv_par03",,,,,,,,,,,,,,,,,{"Grupo De",               	"para considerar na", "geração do relatório."},{},{} )
PutSx1( cPerg, "04", "Grupo Até ?"			,""	,"","mv_ch4", "C", 04, 0, 0, "G", "","SBM", "", "", "mv_par04",,,,,,,,,,,,,,,,,{"Grupo Ate",              	"para considerar na", "geração do relatório."},{},{} )
PutSx1( cPerg, "05", "Imprime Abismo ?"		,""	,"","mv_ch5", "N", 01, 0, 1, "C", "","","", "","mv_par05","Sim","Sim","Sim",'',"Não","Não","Não","Ambos","Ambos","Ambos",,,,'','','',{"Com ou Sem Abismo",      "para considerar na", "geração do relatório."},{},{} )
PutSx1( cPerg, "06", "Tabela\preço De ?"	,""	,"","mv_ch6", "C", 04, 0, 0, "G", "","DA0", "", "", "mv_par06",,,,,,,,,,,,,,,,,{"Tabela\preço De",         "para considerar na", "geração do relatório."},{},{} )
PutSx1( cPerg, "07", "Tabela\preço Até"		,""	,"","mv_ch7", "C", 04, 0, 0, "G", "","DA0", "", "", "mv_par07",,,,,,,,,,,,,,,,,{"Tabela\preço Até",        "para considerar na", "geração do relatório."},{},{} )
PutSx1( cPerg, "08", "Filial"				,""	,"","mv_ch8", "C",  2, 0, 0, "G", "","", "", "", "mv_par08",,,,,,,,,,,,,,,,,{"Filial",        "para considerar na", "geração do relatório."},{},{} )

Return (.T. )