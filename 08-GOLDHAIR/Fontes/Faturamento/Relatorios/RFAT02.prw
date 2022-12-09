#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO7     º Autor ³ AP6 IDE            º Data ³  28/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFAT02


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³                                                                                                                                             
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RFAT02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFAT02" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := PADR("RFAT02",10)
Private cString := "SD2"
Private nMVPerc  := 100/GETMV("MV_X_PERC")     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida o uso da rotina                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If GetMv("ES_LIBGONC",,"N") == "N"
	If dtos(dDataBase) >= GetMv("ES_LIBDATA",,"20140115")
		MSGInfo("Prazo de validação expirado, entre em contato com a consultoria contratada","Atenção")
		Return Nil
	EndIf
EndIf

Ajustasx1()
Pergunte(cPerg,.F.)
dbSelectArea("SD2")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQuery := ""                                                                                               
local ENTER := CHR(13)+CHR(10)
Private cDirDocs := "\spool\"
Private cArquivo := CriaTrab(nil, .F.)
Private cPath  := AllTrim(GetTempPath())
Private oExcelApp
Private nHandle := 0
Private cCrLf  := Chr(13) + Chr(10)
Private aCampos := {}
Private nTotal := 0
Private	aStru := {{"DATA EMISSAO"    , "D", 8, 0}, ;
	   			{"COD CLIENTE"    , "C", 06, 0}, ;
	   			{"NOME CLIENTE"    , "C", 50, 0}, ;
				{"ESTADO"    , "C", 02, 0}, ;
				{"NOTA FISCAL"    , "C", 09, 0}, ;
				{"SERIE"    , "C", 03, 0}, ;
				{"ITEM"    , "C", 4, 0}, ;
				{"PEDIDO"    , "C", 6, 0}, ;
				{"ITEM PV"    , "C", 2, 0}, ;
				{"EMPRESA"    , "C", 15, 0}, ;
                {"COD PRODUTO", "C", 15, 0},;
                {"DESC PRODUTO", "C", 40, 0},;
                {"QUANTIDADE", "N", 14, 2},;
                {"PREÇO LISTA", "N", 14, 2},;
                {"PREÇO NOTA", "N", 14, 2},;
				{"TOTAL"    , "N", 14, 2},;
				{"% DESCONTO"    , "N", 14, 2}}         

IF .T.//MV_PAR11 == 1
	nHandle := MsfCreate(cDirDocs + "\" + cArquivo + ".CSV", 0)
	IF nHandle > 0
		 // Grava o cabecalho do arquivo
		 aEval(aStru, {|e, nX| fWrite(nHandle, e[1] + Iif(nX < Len(aStru), ";", "") ) } )
		 fWrite(nHandle, cCrLf) // Pula linha    
	ENDIF		 
ENDIF



CQUERY := " SELECT D2_EMISSAO, D2_DOC, D2_SERIE, D2_ITEM, D2_CLIENTE, A1_NOME,D2_PEDIDO,D2_ITEMPV,B1_GRUPO, A1_EST, D2_COD,B1_DESC, D2_QUANT,B1_CUSTD PRCLISTA, (D2_PRCVEN*"+str(nMVPerc)+") PRCTAB,(D2_TOTAL*"+str(nMVPerc)+") TOTAL ,D2_DESC "+ENTER
CQUERY += " FROM SD2010 SD2,SB1010 SB1, SF4010 SF4, SA1010 SA1 WHERE D2_COD = B1_COD AND F4_CODIGO = D2_TES"+ENTER
CQUERY += " AND F4_DUPLIC = 'S' AND A1_COD+A1_LOJA = D2_CLIENTE+D2_LOJA AND D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+ENTER
CQUERY += " AND D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+ENTER
CQUERY += " AND SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' "+ENTER
CQUERY += " AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
CQUERY += " ORDER BY D2_EMISSAO"

DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"TRAB1", .F., .T.)

dbselectarea("TRAB1")
dbGoTop()

While !TRAB1->(EOF())
dbselectarea("SBM")
dbgotop()
dbsetorder(1)
dbseek(xFilial("SBM")+TRAB1->B1_GRUPO)
	Fwrite(nHandle, TRAB1->D2_EMISSAO+";" )
	Fwrite(nHandle, TRAB1->D2_CLIENTE+";" )
	Fwrite(nHandle, TRAB1->A1_NOME+";" )
	Fwrite(nHandle, TRAB1->A1_EST+";" )
	Fwrite(nHandle, TRAB1->D2_DOC+";" )
	Fwrite(nHandle, TRAB1->D2_SERIE+";" )
	Fwrite(nHandle, TRAB1->D2_ITEM+";" )
	Fwrite(nHandle, TRAB1->D2_PEDIDO+";" )
	Fwrite(nHandle, TRAB1->D2_ITEMPV+";" )
	Fwrite(nHandle, SBM->BM_DESC+";" )
	Fwrite(nHandle, TRAB1->D2_COD+";" )
	Fwrite(nHandle, TRAB1->B1_DESC+";" )
	Fwrite(nHandle, TRANSFORM(TRAB1->D2_QUANT,"@E 999,999,999.99")+ ";" )
	Fwrite(nHandle, TRANSFORM(TRAB1->PRCLISTA,"@E 999,999,999.99")+ ";" )
	Fwrite(nHandle, TRANSFORM(TRAB1->PRCTAB,"@E 999,999,999.99")+ ";" )
	Fwrite(nHandle, TRANSFORM(TRAB1->TOTAL,"@E 999,999,999.99")+ ";" )
	Fwrite(nHandle, TRANSFORM(TRAB1->D2_DESC,"@E 999.99")+ ";" )
	Fwrite(nHandle, cCrLf ) // Pula linha
	
	nTotal += TRAB1->TOTAL

   TRAB1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   loop
EndDo
                                                                      
Fwrite(nHandle, ";;;;;;;;;;;;;;;"+TRANSFORM(nTotal,"@E 999,999,999.99")+ ";" )

IF .T.//MV_PAR11 == 1
	Fclose(nHandle)
	CpyS2T( cDirDocs + "\" + cArquivo + ".CSV", cPath, .T. )
	FErase( cDirDocs + "\" + cArquivo + ".CSV")
	
	IF !ApOleClient('MsExcel')
		MsgAlert('MsExcel nao instalado')
		RETURN
	ENDIF
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath + cArquivo + ".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.) 
	
	If MsgYesNo("Fecha o Excel e Corta o Link ?")
		oExcelApp:Quit()
		oExcelApp:Destroy()
	Endif

ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
*/
Return

***************************************************************************
Static Function AjustaSX1()                                                
***************************************************************************

Local aArea := GetArea()
PutSx1(cPerg,"01","Data de             ?"," "," ","mv_ch1","D",08,0,0,	"G","","   ","","","MV_PAR01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
PutSx1(cPerg,"02","Data Ate            ?"," "," ","mv_ch2","D",08,0,0,	"G","","   ","","","MV_PAR02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
PutSx1(cPerg,"03","Cliente de          ?"," "," ","mv_ch3","C",06,0,0,	"G","","SA1","","","MV_PAR03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
PutSx1(cPerg,"04","Cliente Ate   	   ?"," "," ","mv_ch4","C",06,0,0,	"G","","SA1","","","MV_PAR04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
PutSx1(cPerg,"05","Produto de          ?"," "," ","mv_ch5","C",15,0,0,	"G","","SB1","","","MV_PAR05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
PutSx1(cPerg,"06","Produto Ate   	   ?"," "," ","mv_ch6","C",15,0,0,	"G","","SB1","","","MV_PAR06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
PutSx1(cPerg,"07","Exporta Excel       ?"," "," ","mv_ch7","C",60,0,0,	"G","","   ","","","MV_PAR07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
/*PutSx1(cPerg,"08","Observação 3 ?"," "," ","mv_ch8","C",60,0,0,	"G","","   ","","","MV_PAR08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
PutSx1(cPerg,"09","Observação 4 ?"," "," ","mv_ch9","C",60,0,0,	"G","","   ","","","MV_PAR09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
PutSx1(cPerg,"10","Observação 5 ?"," "," ","mv_chA","C",60,0,0,	"G","","   ","","","MV_PAR10"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ","","","")
*/
RestArea(aArea)

Return