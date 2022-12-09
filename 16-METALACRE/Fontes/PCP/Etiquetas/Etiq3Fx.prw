#include 'Protheus.ch'
#include 'topconn.ch'
#include 'colors.ch'
#INCLUDE "common.ch"
#Define DMPAPER_A4 9



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณETIQ3     บAutor  ณBruno Daniel Abrigo บ Data ณ  03/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime Etiqueta Metalacre 3                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Etiq3FX()

RptStatus( {||  Ajuste()() }, "Aguarde recalculando...","Ajustando Itens deletados...", .T. ) &&Bruno Abrigo em 19\03\2012

Return

Static Function Ajuste()

Local nTotPag:=0
Local nTotCx:=0
Local oBrush

//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
Local oFnt08a  := TFont():New( "Arial",,10,,.F.,,,,,.f. )      	// Tam 7
Local oFnt08b  := TFont():New( "Arial",,10,,.T.,,,,,.f. )      	// Tam 7
Local oFnt12a  := TFont():New( "Arial",,12,,.t.,,,,,.f.,.t. )      // Tam 12   italico
Local oFnt12b  := TFont():New( "Arial",,11,,.t.,,,,,.f., )  		// Tam 12

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
Local nCnt:=0 && Bruno Abrigo em 19\03\2012

&&Private cPerg:= "PG1ET2"
Private cPerg:= "Etiq3FX"&& Bruno ABrigo em 19\03\2012
Private oPrint

oPrint:= TMSPrinter():New( "Etiqueta Metalacre 3" )

AjustaSx1(cPerg)
//Pแgina tipo retrato
oPrint:SetPortrait()

oPrint:StartPage()

//Papel A4
oPrint:SetpaperSize(9)

If !Pergunte("Etiq3FX")
	Return
EndIf
&&_cOrdProd:=Left(mv_par01,11) comentado por Bruno Abrigo em 19\03\2012
&&nQtEtiqu :=mv_par02
nQtEtiqu :=mv_par03 && Bruno Abrigo em 19\03\2012

/*
-----------------------------------
Ajustes Bruno Abrigo em 15.05.12; Desc.: Campos alterados na consulta da Query para integrar com OP;
C6_QTDVEN = C2_QUANT
C6_XLACRE = C2_XLACRE
C6_OPC    = C2_OPC
-----------------------------------
*/

cQry:=" SELECT	GA.*, ISNULL(A1_NOME,'') A1_NOME, Z00_TMLACR, B1_COD, B1_DESC,  "+CRLF
cQry+=" A7_CODCLI = "+CRLF
cQry+=" 		CASE  "+CRLF
cQry+=" 		WHEN C6_XCODCLI <> '' THEN C6_XCODCLI "+CRLF
cQry+=" 		WHEN C6_XCODCLI = '' THEN A7_CODCLI "+CRLF
cQry+=" 		END, "+CRLF
cQry+=" 		A7_CODFORN, A1_COD, C2_QUANT AS 'C6_QTDVEN', "+CRLF
cQry+=" C2_XLACRE AS 'C6_XLACRE', C2_OPC AS 'C6_OPC', Z00_DESC, Z00_TIPO, Z00_DESC1,Z01_INIC,Z01_FIM,C6_PEDCLI, C2_NUM, C2_ITEM, Z06_EMBALA,Z06_DESCOP, " +CRLF
cQry+=" 		C2_NUM+C2_ITEM+C2_SEQUEN LOTE"+CRLF
cQry+=" FROM "+RetSqlName("SC2")+" C2 "+CRLF

/*
cQry:=" SELECT	GA.*, ISNULL(A1_NOME,'') A1_NOME, Z00_TMLACR, B1_COD, B1_DESC,  A7_CODCLI, A7_CODFORN, A1_COD, C6_QTDVEN, "
cQry+=" C6_XLACRE, C6_OPC, Z00_DESC, Z00_TIPO, Z00_DESC1,Z01_INIC,Z01_FIM,C6_PEDCLI, C2_NUM, C2_ITEM, Z06_EMBALA,Z06_DESCOP, "
cQry+=" 		C2_NUM+C2_ITEM+C2_SEQUEN LOTE"
cQry+=" FROM "+RetSqlName("SC2")+" C2 "
*/

cQry+=" INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=C2_PRODUTO AND B1.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SC6")+" C6 ON C6_NUM=C2_PEDIDO AND C6_ITEM = C2_ITEM AND C6.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SA1")+" A1 ON A1_COD=C2_CLI AND A1_LOJA=C2_LOJA AND A1.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z06")+" Z06 ON Z06_PROD=B1_COD AND Z06_OPCMAX+'/'=C2_OPC AND Z06.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z00")+" Z00 ON Z00_COD=C2_XLACRE AND Z00.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z01")+" Z01 ON Z01_COD=C2_XLACRE AND Z01_PV=C2_NUM AND Z01_ITEMPV=C2_ITEM AND Z01.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SA7")+" A7 ON A7_CLIENTE=A1_COD AND A7_LOJA=A1_LOJA AND A7.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SG1")+" G1 ON G1_COD=C2_PRODUTO AND G1_OPC=Z06_OPCMAX AND G1.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SGA")+" GA ON GA_GROPC=LEFT(C2_OPC,2) AND GA_OPC=SUBSTRING(C2_OPC,4,4) AND GA.D_E_L_E_T_<>'*'  "+CRLF
cQry+=" WHERE C2.D_E_L_E_T_<>'*' "+CRLF
&&cQry+=" AND C2_NUM+C2_ITEM+C2_SEQUEN='"+_cOrdProd+"' "
cQry+=" AND C2_NUM+C2_ITEM+C2_SEQUEN Between '"+Left(Alltrim(MV_PAR01),11)+"' and '"+Left(Alltrim(MV_PAR02),11)+"' and C2_DATPRF Between '"+DTOS(MV_PAR04)+"' and '"+DTOS(MV_PAR05)+"' "+CRLF && Bruno Abrigo em 19\03\2012

// Temp bruno
MemoWrite("C:\TotalSiga\Clientes\Metalacre\Fontes\Faturamento\Fontes\atualizados\Qrys\ETIQ3FX.txt", cQry)

DbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),"TRB1",.T.,.T.)

TRB1->(DbGoTop())
If TRB1->(EOF())
	MsgInfo("Ordem de produ็ใo nใo localizada.")
	//	Return
	
Else && Bruno Abrigo em 19\03\2012
	While !TRB1->(EOF())
		nCnt++
		TRB1->(dbSkip())
	Enddo
	
EndIf

SetRegua(nCnt)	&& Bruno Abrigo em 19\03\2012
TRB1->(DbGoTop())	&& Bruno Abrigo em 19\03\2012

nEtiq:= Int((TRB1->C6_QTDVEN/nQtEtiqu)+Iif(TRB1->C6_QTDVEN%nQtEtiqu>0,1,0))
qtdimp:=TRB1->C6_QTDVEN-nQtEtiqu

While !TRB1->(EOF())&& Bruno Abrigo em 19\03\2012
	
	For i=1 to nEtiq
		
		nEtiq0:=Strzero(i,6)
		//Cabe็alho
		oPrint:Say(y+170, x+135,"METALACRE IND.COM.LACRES LTDA",oFnt08a)    //LINHA1
		//oPrint:Say(y+210, x+135,"Ref:",oFnt12b)
		oPrint:Say(y+210, x+135,TRB1->B1_COD,oFnt12b)
		//oPrint:Say(y+255, x+135,"Pers:",oFnt12b)
		oPrint:Say(y+255, x+135,TRB1->Z00_DESC,oFnt12b)
		oPrint:Say(y+305, x+135,"OP:",oFnt08a)
		oPrint:Say(y+305, x+200,TRB1->C2_NUM+" "+TRB1->C2_ITEM,oFnt08a)
		oPrint:Say(y+305, x+600,"Lote:",oFnt08a)
		oPrint:Say(y+305, x+700,cValtoChar(nEtiq0),oFnt08a)
		oPrint:Say(y+350, x+135,"N.inicial:",oFnt12b)
		oPrint:Say(y+350, x+320,PadL(AllTrim(cValToChar(TRB1->Z01_INIC+nQtEtiq1)),TRB1->Z00_TMLACR,"0"),oFnt12b)
		oPrint:Say(y+350, x+535,"N.Final:",oFnt12b)
		oPrint:Say(y+350, x+720,PadL(AllTrim(cValToChar( Iif(i==nEtiq,TRB1->Z01_FIM,TRB1->Z01_FIM-qtdimp) )),TRB1->Z00_TMLACR,"0"),oFnt12b)
		oPrint:Say(y+410, x+135,"Quantidade",oFnt08a)
		oPrint:Say(y+410, x+320,cValTochar(Iif(i==nEtiq,TRB1->C6_QTDVEN%nQtEtiqu,MV_PAR02)),oFnt08a)
		//oPrint:Say(y+450, x+135,"Tam:",oFnt08b)
		//oPrint:Say(y+450, x+205,TRB1->GA_OPC+"M",oFnt08a)
		//oPrint:Say(y+450, x+400,"Grupo:",oFnt08b)
		oPrint:Say(y+450, x+135,TRB1->GA_DESCOPC,oFnt08a)
		
		nEtiq2+=1
		qtdimp:=qtdimp-nQtEtiqu
		nQtEtiq1+=nQtEtiqu
		x+=1200
		y+=0
		//a+=0
		//b+=10.2
		
		
		If nEtiq2>14
			oPrint:EndPage()
			oPrint:StartPage()
			nEtiq2:=1
			x:=-30
			y:=10
			//	a:=0
			//b:=0
		Elseif MOD(nEtiq2,2)<>0
			x:=-30
			y+=465
			//a+=5.76
			//b:=0
		EndIf
		
		
	Next(i)
	IncRegua() &&  Bruno Abrigo em 19\03\2012
	TRB1->(dbSkip())&& Bruno Abrigo em 19\03\2012
Enddo&& Bruno Abrigo em 19\03\2012

oPrint:EndPage()

oPrint:Preview()

//Desativa Impressora
ms_flush()
dbCloseArea("TRB1")
Return

&& Bruno Abrigo em 19\03\2012 - TODO COMANDO ABAIXO
Static Function AjustaSx1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Bruno Daniel Abrigo acertos em 14\03\2012	- Ajuste perguntas		   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aRegs:={}


AADD(aRegs,{cPerg,"01","Ordem de Produ็ใo       ?","","","mv_ch1","C",11,0,0 ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Ordem de Produ็ใo?","","","mv_ch2","C",11,0,0 ,"G","naovazio()","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","","",""})

AADD(aRegs,{cPerg,"03","Itens por Lote","","","mv_ch3","N",5,0,0 ,"G","naovazio()","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AADD(aRegs,{cPerg,"04","Dta Entreg.Inicial?","","","mv_ch4","D",8,0,0 ,"G","naovazio()","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Dta Entreg.Final  ?","","","mv_ch5","D",8,0,0 ,"G","naovazio()","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

DbSelectArea("SX1")
SX1->(DbSetOrder(1))
SX1->(DbGotop())
if !SX1->(dbSeek(cPerg))
	For i:=1 to Len(aRegs)
		If !SX1->(dbSeek(cPerg+aRegs[i,2]))
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			SX1->(MsUnlock())
			dbCommit()
		Endif
	Next
Endif

&&	PutSx1(cPerg, "01","Ordem de Produ็ใo"," "," ","mv_ch1","C",11,0,0,"G","        "      , "SC2","","","mv_par01","","",""," ","","","" ,"","","","","","","",""," ")
&&	PutSx1(cPerg, "02","Itens por Lote"  ," "," ","mv_ch2","N",05,0,0,"G","        "      , "   ","","","mv_par02","","",""," ","","","" ,"","","","","","","",""," ")

Return
