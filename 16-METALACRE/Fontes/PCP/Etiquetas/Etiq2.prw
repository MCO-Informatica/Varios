#INCLUDE "Protheus.ch"
#include 'topconn.ch'
#include 'colors.ch'
#INCLUDE "common.ch"
#Define DMPAPER_A4 9

#Define CLIENTE	001
#Define PEDCLI  002
#Define CODCLI  003
#Define DESCEMB 004
#Define LACRE   005
#Define TIPO    006
#Define DESPRO  007
#Define QTD     008
#Define OPCIO   009
#Define OP      010
#Define LOTE    011
#Define QTDINI  012
#Define QTDFIM  013

#INCLUDE "Protheus.ch"
#include 'topconn.ch'
#include 'colors.ch'
#INCLUDE "common.ch"
#Define DMPAPER_A4 9

#Define CLIENTE	001
#Define PEDCLI  002
#Define CODCLI  003
#Define DESCEMB 004
#Define LACRE   005
#Define TIPO    006
#Define DESPRO  007
#Define QTD     008
#Define OPCIO   009
#Define OP      010
#Define LOTE    011
#Define QTDINI  012
#Define QTDFIM  013

User Function Etiq2()

Local nTotPag:=0
Local nTotCx:=0
Local oBrush

//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
Local oFnt08a  := TFont():New( "Arial",,6,,.T.,,,,,.f. )      	// Tam 7
Local oFnt08b  := TFont():New( "Arial",,8,,.T.,,,,,.f. )      	// Tam 7
Local oFnt12a  := TFont():New( "Arial",,12,,.t.,,,,,.f.,.t. )      // Tam 12   italico
Local oFnt12b  := TFont():New( "Arial",,12,,.t.,,,,,.f., )  		// Tam 12

Local x:=-30
Local y:=-6
Local nEtiq2:=1
Local qtdimp:=0
Local nQtEtiq1:=0
Local nz:=6
Local a:=0.00
Local b:= -0.10
Local cInic:=""
Local cFim:=""

Private cPerg:= PadR("ETIQ2",10)
Private oPrint

AjustaSx1(cPerg)
//Página tipo retrato

If !Pergunte(cPerg)
	Return
EndIf
nQtEtiqu :=mv_par03
nEspEtiq	:=	Iif(Empty(MV_PAR04),660,MV_PAR04)
oPrint:= TMSPrinter():New( "Etiqueta Metalacre 2" )
oPrint:SetpaperSize(9)
oPrint:SetPortrait()
/*If !oPrint:Setup()
	Return
Endif
*/

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
cQry+=" INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=C2_PRODUTO AND B1_FILIAL = " + xFilial("SB1") + " AND B1.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SC6")+" C6 ON C6_NUM=C2_PEDIDO AND C6_ITEM = C2_ITEM AND C6.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SA1")+" A1 ON A1_COD=C2_CLI AND A1_LOJA=C2_LOJA AND A1.D_E_L_E_T_<>'*'   AND A1.A1_FILIAL = '" + xFilial("SA1") + "' "  +CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z06")+" Z06 ON Z06_PROD=B1_COD AND Z06_OPCMAX+'/'=C2_OPC AND Z06.D_E_L_E_T_<>'*' AND Z06_EMBALA = C6_XEMBALA "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z00")+" Z00 ON Z00_COD=C2_XLACRE AND Z00.D_E_L_E_T_<>'*' " +CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z01")+" Z01 ON Z01_COD=C2_XLACRE AND Z01_PV=C2_NUM AND Z01_ITEMPV=C2_ITEM AND Z01.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SA7")+" A7 ON A7_CLIENTE=A1_COD AND A7_LOJA=A1_LOJA AND A7.D_E_L_E_T_<>'*' AND A7.A7_PRODUTO = C2.C2_PRODUTO " +CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SG1")+" G1 ON G1_COD=C2_PRODUTO AND G1_OPC=Z06_OPCMAX AND G1.D_E_L_E_T_<>'*' "   +CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SGA")+" GA ON GA_GROPC=LEFT(C2_OPC,2) AND GA_OPC=SUBSTRING(C2_OPC,4,4) AND GA.D_E_L_E_T_<>'*'  "   +CRLF
cQry+=" WHERE C2.D_E_L_E_T_<>'*' "+CRLF
cQry+=" AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '"+MV_PAR01+"' AND '" + MV_PAR02 + "' "+CRLF
cQry+=" AND C2_PEDIDO <> ''  "+CRLF
cQry+=" ORDER BY C2_NUM+C2_ITEM+C2_SEQUEN "

// Temp bruno
MemoWrite("C:\TotalSiga\Clientes\Metalacre\Fontes\Faturamento\Fontes\atualizados\Qrys\ETIQ2.txt", cQry)


DbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),"TRBB",.T.,.T.)

TRBB->(DbGoTop())
If TRBB->(EOF())
	MsgInfo("Ordem de produção não localizada.")
	Return
EndIf

aEtiquetas 	:= {}
nLote		:=  1
While TRBB->(!Eof())     
	nEtiq	:= 	CEILING((TRBB->C6_QTDVEN/nQtEtiqu))
	nQtdImp	:=	TRBB->C6_QTDVEN
	nQtdIni :=  TRBB->Z01_INIC
	
	If nLote > 1
		// Ajuste para Salto de Pagina a Cada Parcial
		AAdd(aEtiquetas,{	'pular',;
							'',;
							'',;
							'',;
							'',;
							'',;
							'',;
							0,;
							'',;         
							'',;
							'',;
							'',;
							''})
	Endif
			
	For nI := 1 To nEtiq
		cTipo := ''
		If TRBB->Z00_TIPO=='1'
			cTipo := 'Semi-Barreira'
		ElseIf TRBB->Z00_TIPO=='2'
			cTipo := 'Sinalizacao'
		Endif                    


		AAdd(aEtiquetas,{	TRBB->A1_NOME,;
							TRBB->C6_PEDCLI,;
							TRBB->A7_CODCLI,;
							TRBB->Z00_DESC,;
							TRBB->C6_XLACRE,;
							cTipo,;
							TRBB->B1_DESC,;
							Min(nQtdImp,nQtEtiqu),;
							TRBB->GA_DESCOPC,;         
							TRBB->C2_NUM + TRBB->C2_ITEM,;
							StrZero(nLote,6),;
							StrZero(nQtdIni,TRBB->Z00_TMLACR),;
							StrZero((nQtdIni+Min(nQtdImp,nQtEtiqu))-1,TRBB->Z00_TMLACR)})
							
		nQtdIni 	:=  (nQtdIni+Min(nQtdImp,nQtEtiqu))
		nQtdImp 	-=	nQtEtiqu
		nLote++
		If nQtdImp <= 0
			Exit
		Endif
	Next	
							
	TRBB->(dbSkip(1))
Enddo
TRBB->(dbCloseArea())

oPrint:StartPage()

For nIt	:=	1 To Len(aEtiquetas)
	If AllTrim(aEtiquetas[nIt,CLIENTE])=='pular'
		nEtiq2:=1
		oPrint:EndPage()
		oPrint:StartPage()
		x:=-30
		y:=1
		a:=0
		b:=-0.05
		Loop
	Endif

	//Cabeçalho
	oPrint:Say(y+100, x+135,"METALACRE IND.COM.LACRES LTDA",oFnt08a)    //LINHA1
	oPrint:Say(y+130, x+135,aEtiquetas[nIt,CLIENTE],oFnt08a)                       //LINHA2
	
	//Cabeçalho Lateral direita
	oPrint:Say(y+170, x+135,"Pedido de Compra:",oFnt08a)                //LINHA3
	oPrint:Say(y+170, x+400,aEtiquetas[nIt,PEDCLI],oFnt08a)
	oPrint:Say(y+170, x+700,"Codigo Material",oFnt08a)
	oPrint:Say(y+170, x+950,aEtiquetas[nIt,CODCLI],oFnt08a)
	oPrint:Say(y+210, x+135,"Personalização",oFnt08a)                  //LINHA4
	oPrint:Say(y+210, x+335,aEtiquetas[nIt,DESCEMB],oFnt08a)
	oPrint:Say(y+210, x+700,"Ano",oFnt08a)
	oPrint:Say(y+210, x+800,cValToChar(Year(DATE())),oFnt08a)
	oPrint:Say(y+250, x+135,"Codigo",oFnt08a)                          //LINHA5
	oPrint:Say(y+250, x+260,aEtiquetas[nIt,LACRE],oFnt08a)
	oPrint:Say(y+250, x+700,"Tipo",oFnt08a)
	oPrint:Say(y+250, x+800,aEtiquetas[nIt,TIPO],oFnt08a)
	oPrint:Say(y+290, x+135,"Ref./Cor",oFnt08a)
	oPrint:Say(y+290, x+260,aEtiquetas[nIt,DESPRO],oFnt08a)
	oPrint:Say(y+330, x+350,"Quantidade:",oFnt08a)
	oPrint:Say(y+330, x+500,cValTochar(aEtiquetas[nIt,QTD]),oFnt08a)
	oPrint:Say(y+330, x+700,aEtiquetas[nIt,OPCIO],oFnt08a)
	oPrint:Say(y+330, x+135,"OP:",oFnt08a)
	oPrint:Say(y+330, x+205,aEtiquetas[nIt,OP],oFnt08a)
	oPrint:Say(y+440, x+700,"Lote:",oFnt08a)
	oPrint:Say(y+520, x+840,aEtiquetas[nIt,LOTE],oFnt08a)
	
	oPrint:Say(y+440, x+135,"N.inicial:",oFnt08a)
	oPrint:Say(y+520, x+300,aEtiquetas[nIt,QTDINI],oFnt08a)
	oPrint:Say(y+580, x+135,"N.Final:",oFnt08a)
	oPrint:Say(y+680, x+300,aEtiquetas[nIt,QTDFIM],oFnt08a)
	
	//Codigo de barras   
	MSBAR("CODE128",a+3.6 ,b+2.2,aEtiquetas[nIt,QTDINI],oPrint,.F.,5,Nil,0.022,0.8,Nil,Nil,Nil,.F.,,"INT25")
	MSBAR("CODE128",a+3.6 ,b+6.9,aEtiquetas[nIt,LOTE]  ,oPrint,.F.,5,Nil,0.022,0.8,Nil,Nil,Nil,.F.)
	MSBAR("CODE128",a+5.1 ,b+2.2,aEtiquetas[nIt,QTDFIM],oPrint,.F.,5,Nil,0.022,0.8,Nil,Nil,Nil,.F.)
	
	nEtiq2+=1
	x+=1200
	y+=0
	a+=0.05
	b+=10.30
	
	If nEtiq2>10 .And. (nIt<Len(aEtiquetas))
		oPrint:EndPage()
		oPrint:StartPage()
		nEtiq2:=1
		x:=-30
		y:=1
		a:=0
		b:=-0.05
	Elseif MOD(nEtiq2,2)<>0
		x:=-30
		y+=nEspEtiq//660
		a+=5.50
		b:=-0.2
	EndIf
Next

oPrint:EndPage()

oPrint:Preview()

//Desativa Impressora
ms_flush()
Return


Static Function AjustaSx1(cPerg)
PutSx1(cPerg, "01","Ordem de Produção de" ," "," ","mv_ch1","C",11,0,0,"G","        "      , "SC2","","","mv_par01","","",""," ","","","" ,"","","","","","","",""," ")
PutSx1(cPerg, "02","Ordem de Produção Ate"," "," ","mv_ch2","C",11,0,0,"G","        "      , "SC2","","","mv_par02","","",""," ","","","" ,"","","","","","","",""," ")
PutSx1(cPerg, "03","Itens por Lote"       ," "," ","mv_ch3","N",05,0,0,"G","        "      , "   ","","","mv_par03","","",""," ","","","" ,"","","","","","","",""," ")
PutSx1(cPerg, "04","Linhas Entre Etiq"    ," "," ","mv_ch4","N",05,0,0,"G","        "      , "   ","","","mv_par04","","",""," ","","","" ,"","","","","","","",""," ")

Return
