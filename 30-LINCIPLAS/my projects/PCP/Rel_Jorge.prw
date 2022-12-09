#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REL_JORGE º Autor ³Alessandra Costa    ºData  ³  04/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ 							                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Impressão de relatorio especifico Jorge (producao)         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function REL_JORGE()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir os "
Local cDesc2         := " relatórios utilizados na Produção."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Relatorio Producão"
Local nLin           := 80
Local nFARQ          := 0
Local cCheque        := "  "
Local cBanco 		 := "  "
Local cAgencia 		 := "  "
Local cConta         := " "
Local imprime        := .T.
Local aOrd 			 := {}
Local cSaldoBanco    := 00
Local cQuery  		 := ""
Local aItensExcel 	 := {}
Local aDbStru		 := {}
Local aDbStru1		 := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "G"
Private nomeprog     := "Impressão Producao" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RELOP
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELJORGE" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := "SC2"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	AjustaSx1()

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento do relatório											³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


// Estrutura do Arquivo que irá para o Excel

AADD(aDbStru,{"C2_NUM","C",6,0})			//01
AADD(aDbStru,{"C2_ITEM","C",2,0})			//02
AADD(aDbStru,{"C2_SEQUEN","C",3,0})		//03
AADD(aDbStru,{"C2_PRODUTO","C",15,0})		//04
AADD(aDbStru,{"C2_DESCPRO","C",30,0})		//05
AADD(aDbStru,{"C2_EMISSAO","D",8,0})		//06
AADD(aDbStru,{"C2_DATPRF","D",8,0})		//07
AADD(aDbStru,{"C2_QUANT","N",12,0})		//08


AADD(aDbStru1,{"OP","C",11,0})					//01
AADD(aDbStru1,{"COD","C",7,0})					//02
AADD(aDbStru1,{"COR","C",9,0})					//03
AADD(aDbStru1,{"PRODUTO","C",30,0})			//04
AADD(aDbStru1,{"EMISSAO","D",8,0})				//05
AADD(aDbStru1,{"ENTREGA","D",8,0})				//06
AADD(aDbStru1,{"QUANT ORIGINAL","N",12,0})		//07
AADD(aDbStru1,{"PRODUZIDO","N",12,0})			//08
AADD(aDbStru1,{"SALDO","N",12,0})				//09
AADD(aDbStru1,{"NUMERO SELO","C",30,0})		//10
AADD(aDbStru1,{"OPERADOR","C",1,0})			//11
AADD(aDbStru1,{"RESPONSAVEL","C",30,0})		//12


//CRIA ARQ TEMPORARIO COMO DBF PARA O EXCEL PODER ABRIR
CNOMEDBF := "RELJORGE"
DBCREATE(CNOMEDBF,aDbStru,"DBFCDXADS")
DbUseArea(.T.,"DBFCDXADS","SYSTEM\" + CNOMEDBF,"XLS",.T.,.F.)


//////////////////////////////////////////////////

If Select("TRB1") > 0
	dbSelectArea("TRB1")
	dbCloseArea()
Endif

cQuery:=" SELECT * FROM " + RetSqlName("SC2") + " C2"
cQuery+=" WHERE C2.D_E_L_E_T_ <> '*' "
cQuery+=" AND C2_FILIAL = '"+xFilial("SC2")+"' "
cQuery+=" AND LTRIM(RTRIM(C2_NUM))+LTRIM(RTRIM(C2_ITEM))+LTRIM(RTRIM(C2_SEQUEN)) >= '"+MV_PAR01+"' "
cQuery+=" AND LTRIM(RTRIM(C2_NUM))+LTRIM(RTRIM(C2_ITEM))+LTRIM(RTRIM(C2_SEQUEN)) <= '"+MV_PAR02+"' "
cQuery+=" ORDER BY C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN "
cQuery := ChangeQuery(cQuery)


dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)

MsgRun ("Favor aguardar ...", "Selecionando Registros",{||GProcItens(aDbStru, @aItensExcel)})
MsgRun ("Favor aguardar ...", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS","Producão",aDbStru1, aItensExcel}})})

TRB1->(DBCLOSEAREA())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRESSAO EXCEL							                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

XLS->(DBGOTOP())
TRB->(DBGOTOP())
CpyS2T( "\SYSTEM\" + CNOMEDBF +".DBF" , "C:\RELATORIOS\" , .F. )
Alert("Arquivo salvo em C:\Relatorios\" + CNOMEDBF + ".DBF" )

If ! ApOleClient( 'MsExcel' )
	MsgStop( 'MsExcel nao instalado' )
	//	Return
ELSE
	//EndIf
	
	DbSelectArea("TRB")
	DbCloseArea()
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( "C:\RELATORIOS\" + CNOMEDBF +".DBF" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	XLS->(DBCLOSEAREA())
	
	//ENDIF
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()


Return

//////////////////////////////////////////////////////////////////////

Static Function GProcItens (aHeader, aCols)

Local aItem
Local nX,  nY

dbSelectArea("TRB1")
dbGoTop()

if TRB1->(EOF())
	Aviso("Atenção!","Nenhum registro selecionado",{"OK"})
	TRB1->(Dbclosearea())
	Return
EndIf

While TRB1->(!EOF())
	aItem := Array(Len(aHeader)+5)
	nY := 1
	for nX := 1 to len(aHeader)
		Do case
			Case aHeader[nX][1] == "C2_ITEM"
				aItem[nY] := (aItem[nY-1]) + TRB1->&(aHeader[nX][1])
			Case aHeader[nX][1] == "C2_SEQ"
				aItem[nY] := (aItem[nY-1]) + TRB1->&(aHeader[nX][1])
				nY++
			Case aHeader[nX][1] == "C2_PRODUTO"
				aItem[nY] := substr(TRB1->&(aHeader[nX][1]),1,7)
				nY++
				aItem[nY] := substr(TRB1->&(aHeader[nX][1]),8,9)
				nY++
			OtherWise
				aItem[nY] := TRB1->&(aHeader[nX][1])
				nY++
		EndCase
	next nX
	
	for nX := (len(aHeader)+1) to len(aItem)
		aItem[nX] := ""
	next nX
	
	
	AADD(aCols,aItem)
	aItem := {}
	
	TRB1->(DBSKIP())
EndDo




Return
