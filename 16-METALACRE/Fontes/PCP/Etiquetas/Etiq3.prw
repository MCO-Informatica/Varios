#include "Protheus.CH"
#include 'topconn.ch'    
#include 'colors.ch'
#INCLUDE "common.ch"
#Define DMPAPER_A4 9


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Etiq3  บAutor  ณ                  ณ             13/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณETIQUETA DE NUMERACAO CAIXA/LOTE                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Etiq3()

Local nTotPag:=0
Local nTotCx:=0
Local oBrush

//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
Local oFnt08a  := TFont():New( "Arial",,10,,.F.,,,,,.f. )      	// Tam 7   
Local oFnt08b  := TFont():New( "Arial",,10,,.T.,,,,,.f. )      	// Tam 7   
Local oFnt12a  := TFont():New( "Arial",,12,,.t.,,,,,.f.,.t. )      // Tam 12   italico
Local oFnt12b  := TFont():New( "Arial",,11,,.t.,,,,,.f., )  		// Tam 12 
Local oFnt10b  := TFont():New( "Arial",,10,,.T.,,,,,.f. )      	// Tam 7   

Local x:=-30               
Local y:=10
Local nEtiq2:=1
Local qtdimp:=0
Local nQtEtiq1:=0
Local nz:=6
Local a:=0
Local b:=0
Local cInic:=""
Local cFim:=""

Private cPerg:= "PG1ET2"
Private oPrint

Pergunte("PG1ET2",.f.)  


	oPrint:= TMSPrinter():New( "Etiqueta Metalacre 3" )  
    
    AjustaSx1(cPerg)
	//Pแgina tipo retrato
 	oPrint:SetPortrait()
	
	oPrint:StartPage() 
    
    //Papel A4
   	oPrint:SetpaperSize(9) 
      
If !Pergunte("PG1ET2")  
	Return
EndIf
_cOrdProd:=Left(mv_par01,11)
nQtEtiqu :=mv_par03
nEspEtiq	:=	Iif(Empty(MV_PAR04),465,MV_PAR04)

/*
-----------------------------------
Ajustes Bruno Abrigo em 15.05.12; Desc.: Campos alterados na consulta da Query para integrar com OP;
C6_QTDVEN = C2_QUANT
C6_XLACRE = C2_XLACRE
C6_OPC    = C2_OPC
-----------------------------------
*/

cQry:=" SELECT	GA_GROPC, GA_DESCGRP, GA_OPC, GA_DESCOPC, GA_PRCVEN, GA_XDESCR2, GA_MARK, ISNULL(A1_NOME,'') A1_NOME, Z00_TMLACR, B1_COD, B1_DESC,  "+CRLF
cQry+=" A7_CODCLI = "+CRLF
cQry+=" 		CASE  "+CRLF
cQry+=" 		WHEN C6_XCODCLI <> '' THEN C6_XCODCLI "+CRLF
cQry+=" 		WHEN C6_XCODCLI = '' THEN A7_CODCLI "+CRLF
cQry+=" 		END, "+CRLF
cQry+=" 		A7_CODFORN, A1_COD, C2_QUANT AS 'C6_QTDVEN', "+CRLF
cQry+=" C2_XLACRE AS 'C6_XLACRE', C2_OPC AS 'C6_OPC', Z00_DESC, Z00_TIPO, Z00_DESC1,Z01_INIC,Z01_FIM,C6_PEDCLI, C2_NUM, C2_ITEM, Z06_EMBALA,Z06_DESCOP, " +CRLF
cQry+=" 		C2_NUM+C2_ITEM+C2_SEQUEN LOTE"+CRLF
cQry+=" FROM "+RetSqlName("SC2")+" C2 "
cQry+=" INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=C2_PRODUTO AND B1.D_E_L_E_T_<>'*' AND B1.B1_FILIAL = '" + xFilial("SB1") + "' "
cQry+=" LEFT  JOIN "+RetSqlName("SC6")+" C6 ON C6_NUM=C2_PEDIDO AND C6_ITEM = C2_ITEM AND C6.D_E_L_E_T_<>'*' AND C6.C6_FILIAL = '" + xFilial("SC6") + "' "
cQry+=" LEFT  JOIN "+RetSqlName("SA1")+" A1 ON A1_COD=C2_CLI AND A1_LOJA=C2_LOJA AND A1.D_E_L_E_T_<>'*'   AND A1.A1_FILIAL = '" + xFilial("SA1") + "' "
cQry+=" LEFT  JOIN "+RetSqlName("Z06")+" Z06 ON Z06_PROD=B1_COD AND Z06_COD = C6_XEMBALA AND Z06_OPCMAX+'/'=C2_OPC AND Z06.D_E_L_E_T_<>'*'  AND Z06.Z06_FILIAL = '" + xFilial("Z06") + "' "
cQry+=" LEFT  JOIN "+RetSqlName("Z00")+" Z00 ON Z00_COD=C2_XLACRE AND Z00.D_E_L_E_T_<>'*'  AND Z00.Z00_FILIAL = '" + xFilial("Z00") + "' " 
cQry+=" LEFT  JOIN "+RetSqlName("Z01")+" Z01 ON Z01_COD=C2_XLACRE AND Z01_PV=C2_NUM AND Z01_ITEMPV=C2_ITEM AND Z01.D_E_L_E_T_<>'*'  AND Z01.Z01_FILIAL = '" + xFilial("Z01") + "' "
//cQry+=" LEFT  JOIN "+RetSqlName("SA7")+" A7 ON A7_CLIENTE=A1_COD AND A7_LOJA=A1_LOJA AND A7_XOPC = C6_OPC AND A7.D_E_L_E_T_<>'*' AND A7.A7_PRODUTO = C2.C2_PRODUTO  AND A7.A7_FILIAL = '" + xFilial("SA7") + "' " 
cQry+=" LEFT  JOIN "+RetSqlName("SA7")+" A7 ON A7_CLIENTE=A1_COD AND A7_LOJA=A1_LOJA AND A7.A7_XOPC = C2_OPC AND A7.D_E_L_E_T_<>'*' AND A7.A7_PRODUTO = C2.C2_PRODUTO AND A7.A7_XLACRE IN('',C2_XLACRE) AND A7.A7_FILIAL = '" + xFilial("SA7") + "' " 

cQry+=" LEFT  JOIN "+RetSqlName("SG1")+" G1 ON G1_COD=C2_PRODUTO AND G1_OPC=Z06_OPCMAX AND G1.D_E_L_E_T_<>'*'  AND G1.G1_FILIAL = '" + xFilial("SG1") + "' "   
cQry+=" LEFT  JOIN "+RetSqlName("SGA")+" GA ON GA_GROPC=LEFT(C2_OPC,2) AND GA_OPC=SUBSTRING(C2_OPC,4,4) AND GA.D_E_L_E_T_<>'*'  "   
cQry+=" WHERE C2.D_E_L_E_T_<>'*' "
cQry+=" AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '"+MV_PAR01+"' AND '" + MV_PAR02 + "' "
cQry+=" AND C2_SEQUEN = '001' "
cQry+=" AND C2_FILIAL = '" + xFilial("SC2") + "' "
cQry+=" ORDER BY C2_NUM+C2_ITEM+C2_SEQUEN "
MemoWrite("c:\etiq.txt", cQry)

DbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),"TRB1",.T.,.T.)

TRB1->(DbGoTop())
If TRB1->(EOF())	
	MsgInfo("Ordem de produ็ใo nใo localizada.")
EndIf
	
nEtiq0:=1
nEtiq2:=1
While TRB1->(!Eof())
	nEtiq:= Int((TRB1->C6_QTDVEN/nQtEtiqu)+Iif(TRB1->C6_QTDVEN%nQtEtiqu>0,1,0))
	qtdimp:=TRB1->C6_QTDVEN-nQtEtiqu                           
	nQtEtiq1 := 0

	For i=1 to nEtiq
	    	
	    //Cabe็alho 
	 	oPrint:Say(y+170, x+135,"METALACRE IND.COM.LACRES LTDA",oFnt08a)    //LINHA1
   	    //oPrint:Say(y+210, x+135,"Ref:",oFnt12b)
   	    oPrint:Say(y+210, x+135,TRB1->B1_COD,oFnt12b)
   	    //oPrint:Say(y+255, x+135,"Pers:",oFnt12b)
   	    oPrint:Say(y+255, x+135,TRB1->Z00_DESC,Iif(Len(AllTrim(TRB1->Z00_DESC))>30,oFnt10b,oFnt12b))
   	    oPrint:Say(y+305, x+135,"OP:",oFnt08a)
   	    oPrint:Say(y+305, x+200,TRB1->C2_NUM+" "+TRB1->C2_ITEM,oFnt08a)
   	    oPrint:Say(y+305, x+600,"Lote:",oFnt08a)
   	    oPrint:Say(y+305, x+700,StrZero(nEtiq0,6),oFnt08a)
   	    oPrint:Say(y+350, x+135,"N.inicial:",oFnt12b) 
		oPrint:Say(y+350, x+320,StrZero(TRB1->Z01_INIC+nQtEtiq1,TRB1->Z00_TMLACR),oFnt12b)
		oPrint:Say(y+350, x+535,"N.Final:",oFnt12b)
		oPrint:Say(y+350, x+720,StrZero(Iif(i==nEtiq,TRB1->Z01_FIM,TRB1->Z01_FIM-qtdimp),TRB1->Z00_TMLACR),oFnt12b)
		oPrint:Say(y+410, x+135,"Quantidade",oFnt08a)        
   	    oPrint:Say(y+410, x+320,cValTochar(Iif(i==nEtiq,TRB1->C6_QTDVEN-nQtEtiq1,MV_PAR03)),oFnt08a)
   	 	oPrint:Say(y+450, x+135,TRB1->GA_DESCOPC,oFnt08a)

   	   	nEtiq2+=1
   	    qtdimp:=qtdimp-nQtEtiqu
   	    nQtEtiq1+=nQtEtiqu
   	    x+=1200
   	    y+=0
   	    

   	    If nEtiq2>14 
   	        oPrint:EndPage()
			oPrint:StartPage()
   	        nEtiq2:=1
   	    	x:=-30
   	    	y:=10
   	    Elseif MOD(nEtiq2,2)<>0
   	    	x:=-30
   	    	y+=nEspEtiq//465
   	    EndIf
   	   	
	    nEtiq0++
	     
	Next(i)

    cItem := TRB1->C2_ITEM
	
	TRB1->(dbSkip(1))
	
	If cItem <> TRB1->C2_ITEM .And. TRB1->(!Eof()) .And. !Empty(TRB1->C2_ITEM)
		nEtiq2 := 15
	Endif

	If nEtiq2>14 
        oPrint:EndPage()
		oPrint:StartPage()
		nEtiq2:=1
		x:=-30
		y:=10
	Endif

Enddo                       
oPrint:EndPage()    
oPrint:Preview()
ms_flush() 
dbCloseArea("TRB1")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FilEmb บAutor  ณLuiz Alberto Data ณ  13/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao Responsavel pelo Filtro do Campo C6_XEMBALA         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSx1(cPerg)
	PutSx1(cPerg, "01","Ordem de Produ็ใo De "," "," ","mv_ch1","C",11,0,0,"G","        "      , "SC2","","","mv_par01","","",""," ","","","" ,"","","","","","","",""," ")
	PutSx1(cPerg, "02","Ordem de Produ็ใo Ate"," "," ","mv_ch2","C",11,0,0,"G","        "      , "SC2","","","mv_par02","","",""," ","","","" ,"","","","","","","",""," ")
	PutSx1(cPerg, "03","Itens por Lote"  ," "," ","mv_ch3","N",05,0,0,"G","        "      , "   ","","","mv_par03","","",""," ","","","" ,"","","","","","","",""," ")
	PutSx1(cPerg, "04","Espa็o Entre Etiq"  ," "," ","mv_ch4","N",05,0,0,"G","        "      , "   ","","","mv_par04","","",""," ","","","" ,"","","","","","","",""," ")

Return
