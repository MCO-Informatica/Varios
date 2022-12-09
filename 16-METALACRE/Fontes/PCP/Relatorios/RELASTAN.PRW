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
User Function RelaStan()                                                       
	
Local cDesc1       	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3       	:= "Estoque disponivel em Stand By de todas as OPs, inclusive as jแ baixadas"
Local cPict        	:= ""
Local titulo       	:= "Estoque disponivel em Stand By de TODAS as OPs, incusive as jแ faturadas"
Local nLin         	:= 80
Local Cabec1       	:= "Cod_Lacre   Num_OP   Item_OP  Cliente   Descricao_Cliente                   Produto      Armazem  Qtde_Orig    Qtde_Prod    Saldo_SB8    Num_PV   Item_PV    Data_Emissao    Lacre_Ini    Lacre_Final"
Local Cabec2       	:= ""                                                                                                                                                            
Local imprime      	:= .T.
Local aOrd          := {}
Private nCont       := 0
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "G"
Private nomeprog    := "RELSTANDBY" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RELSTANDBY" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg       := "STANDBY"
Private cString     := "SC2"
Private nQtdeTot    := 0
Private nTotal1     := 0
Private nQtdeProd   := 0
Private nQtdeVen    := 0
Private nSaldo      := 0 
Private ncont       := 0 

Private a_Pos       := {}

dbSelectArea("SC2")
dbSetOrder(1)                 

Pergunte(cPerg,.T.)

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


// QUERY QUE TRAZ AS OPS REPETIDAS E QUE DEVE SOMAR APENAS O SALDO  - 42 REGISTROS
cQry1:= " SELECT DISTINCT C2_NUM,C2_QUANT,C2_QUJE,C2_XLACRE,C2_ITEM,C2_CLI,C2_PRODUTO,C2_LOCAL,C2_EMISSAO,C2_XLACINI,C2_XLACFIN, B8_SALDO, B8_LOTECTL"
cQry1+= " FROM "+RETSQLNAME("SC2")+" SC2"
cQry1+= " INNER JOIN "+RETSQLNAME("SB8")+" SB8"
cQry1+= " ON C2_FILIAL = B8_FILIAL AND C2_PRODUTO = B8_PRODUTO AND C2_NUM+C2_ITEM = B8_LOTECTL AND SB8.D_E_L_E_T_ = '' " // AND B8_LOCAL = C2_LOCAL 
cQry1+= " WHERE C2_NUM LIKE 'E%'"		
cQry1+= " AND C2_SEQUEN = '001'"		
cQry1+= " AND B8_SALDO <> 0 "				
cQry1+= " AND SC2.D_E_L_E_T_ = '' "				
cQry1+= " AND C2_CLI BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQry1+= " AND C2_XLACRE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'  "
cQry1+= " AND C2_NUM BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  " 
cQry1+= " ORDER BY C2_CLI,C2_NUM,C2_PRODUTO"

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
TCQUERY cQry1 New Alias "TRB"  

// QUERY QUE NAO TRAZ AS OP REPETIDAS E SOMA AS QUANTIDADES  - 36 REGISTROS
/*
cQry:= " SELECT DISTINCT C2_NUM,C2_QUANT,C2_QUJE,C2_XLACRE,C2_ITEM,C2_CLI,C2_PRODUTO,C2_LOCAL,C2_EMISSAO,C2_XLACINI,C2_XLACFIN"
cQry+= " FROM "+RETSQLNAME("SC2")+" SC2"
cQry+= " INNER JOIN "+RETSQLNAME("SB8")+" SB8"
cQry+= " ON C2_FILIAL = B8_FILIAL AND C2_PRODUTO = B8_PRODUTO AND C2_NUM+C2_ITEM = B8_LOTECTL AND B8_LOCAL = C2_LOCAL "  
cQry+= " WHERE C2_NUM LIKE 'E%'"		
cQry+= " AND B8_SALDO <> 0 "				
cQry+= " AND C2_CLI BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQry+= " AND C2_XLACRE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'  "
cQry+= " AND C2_NUM BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  " 
cQry+= " ORDER BY C2_CLI,C2_NUM,C2_PRODUTO"

If Select("TRX") > 0
	TRX->(dbCloseArea())
EndIf
TCQUERY cQry New Alias "TRX" 

  */
a_Pos := { 0, 12, 23, 30, 40, 78, 93, 101, 115, 127, 138, 150, 158, 175, 189 } 

While TRB->(!EOF())
	
	cMsmCLI  := TRB->C2_CLI
	cMsmPRO  := TRB->C2_PRODUTO
	
	While(TRB->(!EOF()) .And. (cMsmCLI == TRB->C2_CLI .AND. cMsmPRO == TRB->C2_PRODUTO))  
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		cCodCli := TRB->C2_CLI
		nDescri := GETADVFVAL("SA1","A1_NOME",xFilial("SA1")+ cCodCli, 1, "")
		
		cNum   := GETADVFVAL("SC6","C6_NUM",xFilial("SC6")+ TRB->C2_NUM + TRB->C2_ITEM, 7, "")
		cItem  := GETADVFVAL("SC6","C6_ITEM",xFilial("SC6")+ TRB->C2_NUM + TRB->C2_ITEM, 7, "")
		//cSaldo := GETADVFVAL("SB8","B8_SALDO",xFilial("SB8") + ALLTRIM(TRB->C2_PRODUTO) + ALLTRIM(TRB->C2_NUM + TRB->C2_ITEM), 6, 0) 
		
		@nLin,a_Pos[1]  PSAY TRB->C2_XLACRE
		@nLin,a_Pos[2]  PSAY TRB->C2_NUM
		@nLin,a_Pos[3]  PSAY TRB->C2_ITEM
		@nLin,a_Pos[4]  PSAY TRB->C2_CLI
		@nLin,a_Pos[5]  PSAY SUBSTR(nDescri, 1,35)
		@nLin,a_Pos[6]  PSAY Alltrim(TRB->C2_PRODUTO)
		@nLin,a_Pos[7]  PSAY TRB->C2_LOCAL
		@nLin,a_Pos[8]  PSAY cValtochar(TRB->C2_QUANT)
		@nLin,a_Pos[9]  PSAY cValtochar(TRB->C2_QUJE)
		@nLin,a_Pos[10] PSAY TRB->B8_SALDO
		@nLin,a_Pos[11] PSAY cNum
		@nLin,a_Pos[12] PSAY cItem
		@nLin,a_Pos[13] PSAY STOD(TRB->C2_EMISSAO)
		@nLin,a_Pos[14] PSAY TRB->C2_XLACINI
		@nLin,a_Pos[15] PSAY TRB->C2_XLACFIN
		
		nSaldo  += TRB->B8_SALDO 
		cProdxx := TRB->C2_PRODUTO
		
		/*Posicione("TRX",1,xFilial("TRX")+_cProd,"")
		nQtdeTot  += TRX->C2_QUANT    
		nQtdeProd += TRX->C2_QUJE*/ 
		
		nLin++
				
		TRB->(DbSkip())
	EndDo
	
	// Quando mudar o cliente pula 2 linhas e imprime o total daquele cliente
	//nLin+= 1
	//@nLin,a_Pos[1] PSAY "Qtdes Totais do Cliente: "
	//@nLin,a_Pos[4] PSAY nDescri
	//nLin+= 1
	//@nLin,a_Pos[1] PSAY "Qtde Original: "
	//@nLin,a_Pos[4] PSAY nQtdeTot
	//nLin++
	//@nLin,a_Pos[1] PSAY "Qtde Produzida: "
	//@nLin,a_Pos[4] PSAY nQtdeProd
	nLin+=2
	@nLin,a_Pos[1] PSAY "SALDO EM ESTOQUE DO PRODUTO :" +cProdXX
	@nLin,a_Pos[5] PSAY "= " +cvaltochar(nSaldo)+" 
	nLin++
	
	@nLin,a_Pos[1]  PSAY Replicate("-", 210)
	
	nLin+= 2
	
	//nQtdeTot  := 0
	//nQtdeProd := 0
	nSaldo    := 0
	
	//TRB->(DbSkip())
	
ENDDO


SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return Nil  


