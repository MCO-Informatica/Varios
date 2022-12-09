#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณRelStandby  บAutor  ณ Mateus Hengle      บData  ณ 21/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescric.  ณRelatorio que lista as OPs que estao em Stand by            บฑฑ
ฑฑบ          ณTOTVS TRIAH    											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RelEnd(cNota, cSerie)                                                       
	
Local cDesc1       	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3       	:= "Enderecamento dos produtos no estoque"
Local cPict        	:= ""
Local titulo       	:= "Enderecamento dos produtos no estoque"
Local nLin         	:= 80
Local Cabec1       	:= "Nota_Fiscal    Serie    Item_NF     Produto                Qtde      Num_Pedido     Item_PV       Endereco"
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd          := {}
Private nCont       := 0
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "RELEND" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RELEND" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg       := ""
Private cString     := "SD2"
Private nQtdeTot    := 0
Private nTotal1     := 0
Private nQtdeProd   := 0
Private nTotal2     := 0
Private a_Pos       := {} 

Private cNF    := cNota
Private cSerie := cSerie

dbSelectArea("SC2")
dbSetOrder(1)                 

Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ         
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return    

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

dbSelectArea(cString)
dbSetOrder(1)

SetRegua(RecCount())

cQry:= " SELECT D2_DOC, D2_SERIE, D2_ITEM, D2_COD, D2_QUANT, D2_PEDIDO, D2_ITEMPV, C6_XENDPRO" 
cQry+= " FROM "+RETSQLNAME("SD2")+" SD2"
cQry+= " INNER JOIN "+RETSQLNAME("SC6")+" SC6"
cQry+= " ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND D2_COD = C6_PRODUTO AND D2_CLIENTE = C6_CLI"
cQry+= " WHERE D2_DOC = '" +cNf+ "'
cQry+= " AND D2_SERIE = '" +cSerie+ "'
//cQry+= " AND C6_XENDPRO <> ''" // trazer apenas as NF que estao enderecadas
cQry+= " AND SC6.D_E_L_E_T_=''"
cQry+= " AND SD2.D_E_L_E_T_=''"
cQry+= " ORDER BY D2_DOC, D2_SERIE, D2_ITEM " 

If Select("TRD") > 0
	TRD->(dbCloseArea())
EndIf

TCQUERY cQry New Alias "TRD"

a_Pos := { 0, 17, 26, 36, 60, 71, 87, 108 }

While(TRD->(!EOF()))
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@nLin,a_Pos[1]  PSAY TRD->D2_DOC
	@nLin,a_Pos[2]  PSAY TRD->D2_SERIE
	@nLin,a_Pos[3]  PSAY TRD->D2_ITEM
	@nLin,a_Pos[4]  PSAY TRD->D2_COD
	@nLin,a_Pos[5]  PSAY TRD->D2_QUANT
	@nLin,a_Pos[6]  PSAY TRD->D2_PEDIDO
	@nLin,a_Pos[7]  PSAY TRD->D2_ITEMPV
	@nLin,a_Pos[8]  PSAY TRD->C6_XENDPRO 


	nLin++
	
	TRD->(DbSkip())
EndDo
   

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return Nil 