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
User Function Relsxx()

// Traz somente as OPs que jแ possuem PV e as que ainda nใo foram Faturadas 

Local cDesc1       	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3       	:= "Estoque disponivel em Stand By porem NรO TRAZ AS OPs que ainda nao possuem PEDIDO DE VENDA"
Local cPict        	:= ""
Local titulo       	:= "Estoque disponivel em Stand By das OPs que jแ possuem Pedido de Venda"
Local nLin         	:= 80
Local Cabec1       	:= "Cod_Lacre      Num_OP   Item_OP    Cliente        Descricao_Cliente                       Sequencia        Produto       Armazem       Qtde_Original   Qtde_Produzida   Data_Emissao    Lacre_Ini   Lacre_Fim  Pedido_Venda"
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
Private nTotal2     := 0
Private a_Pos       := {}

dbSelectArea("SC2")
dbSetOrder(1)                 

ValidPerg(cPerg)
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

// CAMPOS COD DO LACRE, NUMERO OP, ITEM OP, CLIENTE, SEQUENCIA, PRODUTO, ARMAZEM, QTDE, DATA EMISSAO, LACRE INICIAL, LACRE FINAL
cQry:= " SELECT C2_XLACRE,C2_NUM,C2_ITEM,C2_CLI,C2_SEQUEN,C2_PRODUTO,C2_LOCAL,C2_QUANT,C2_EMISSAO,C2_XLACINI,C2_XLACFIN,C2_QUJE,C6_XSTAND, C6_NOTA, C6_NUM" 
cQry+= " FROM "+RETSQLNAME("SC2")+" SC2"

cQry+= " INNER JOIN "+RETSQLNAME("SC6")+" SC6" 
cQry+= " ON C2_FILIAL = C6_FILIAL AND C2_NUM = C6_NUMOP AND C2_ITEM = C6_ITEMOP AND C2_PRODUTO = C6_PRODUTO" 

cQry+= " WHERE C6_NOTA = '' "  // AINDA NรO POSSUE NUMERO DE NOTA FISCAL, NAO FOI FATURADA
cQry+= " AND C6_XSTAND = '1' "

cQry+= " AND C2_QUJE <> '' "           // MOSTRA APENAS AS OPS QUE A QTDE PRODUZIDA EH MAIOR QUE ZERO
cQry+= " AND C2_NUM BETWEEN '" +MV_PAR01+ "'AND '"+MV_PAR02+ "'"
cQry+= " AND C2_XLACRE BETWEEN '" +MV_PAR03+ "'AND '"+MV_PAR04+ "'"
cQry+= " AND C2_CLI BETWEEN '" +MV_PAR05+ "'AND '"+MV_PAR06+ "'"
cQry+= " AND C2_XOP = '2'"     // SOMENTE PRODUTO ACABADO 
cQry+= " AND C2_SEQUEN = '001'" // SOMENTE SEQUENCIA 001
cQry+= " AND C2_XLACRE <> '' "  // NAO MOSTRA LACRE ZERADO

cQry+= " AND SC2.D_E_L_E_T_=''"
cQry+= " AND SC6.D_E_L_E_T_=''"
cQry+= " ORDER BY C2_CLI, C2_NUM" 

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY cQry New Alias "TRB"

a_Pos := { 0, 15, 26, 35, 50, 92, 107, 123, 140, 155, 170, 185, 197, 210, 60 }

TRB->(dbGoTop())
While TRB->(!EOF())
	
	cMsmCLI  := TRB->C2_CLI
	c_Quebra := "cMsmCLI == TRB->C2_CLI"

	While(TRB->(!EOF()) .And. &c_Quebra )
		
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
		
		@nLin,a_Pos[1]  PSAY TRB->C2_XLACRE
		@nLin,a_Pos[2]  PSAY TRB->C2_NUM
		@nLin,a_Pos[3]  PSAY TRB->C2_ITEM
		@nLin,a_Pos[4]  PSAY TRB->C2_CLI
		@nLin,a_Pos[5]  PSAY nDescri
		@nLin,a_Pos[6]  PSAY TRB->C2_SEQUEN
		@nLin,a_Pos[7]  PSAY Alltrim(TRB->C2_PRODUTO)
		@nLin,a_Pos[8]  PSAY TRB->C2_LOCAL
		@nLin,a_Pos[9]  PSAY cValtochar(TRB->C2_QUANT)
		@nLin,a_Pos[10]  PSAY cValtochar(TRB->C2_QUJE)
		@nLin,a_Pos[11] PSAY STOD(TRB->C2_EMISSAO)
		@nLin,a_Pos[12] PSAY TRB->C2_XLACINI
		@nLin,a_Pos[13] PSAY TRB->C2_XLACFIN
		@nLin,a_Pos[14] PSAY TRB->C6_NUM
		
		nQtdeTot  += TRB->C2_QUANT    // Enquanto for mesmo cliente vai somando as qtdes
		nQtdeProd += TRB->C2_QUJE
		
		nLin++
		
		TRB->(DbSkip())
	EndDo
	
	                           // Quando mudar o cliente pula 2 linhas e imprime o total daquele cliente
	nLin+= 1
	@nLin,a_Pos[1] PSAY "Qtdes Totais do Cliente: "
	@nLin,a_Pos[3] PSAY nDescri
	nLin+= 1
	@nLin,a_Pos[1] PSAY "Qtde Original: "
	@nLin,a_Pos[3] PSAY nQtdeTot
	nLin++
	@nLin,a_Pos[1] PSAY "Qtde Produzida: "
	@nLin,a_Pos[3] PSAY nQtdeProd 
	nLin++
	@nLin,a_Pos[1]  PSAY Replicate("-", 220)
	
	nLin+= 2
	
	nTotal1 += nQtdeTot
	nTotal2 += nQtdeProd
	
	nQtdeTot  := 0
	nQtdeProd := 0
		
	TRB->(DbSkip())
EndDo

nLin+= 2
@nLin,a_Pos[1] PSAY "Total Qtde Original: " 
@nLin,a_Pos[3] PSAY nTotal1

nLin+= 2
@nLin,a_Pos[1] PSAY "Total Qtde Produzida: " 
@nLin,a_Pos[3] PSAY nTotal2

    

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return Nil  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  16/01/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg(c_Perg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

c_Perg := c_Perg + Space(10 - Len(c_Perg))

dbSelectArea("SX1")
dbSetOrder(1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{c_Perg,"01","OP de ?  ","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
aAdd(aRegs,{c_Perg,"02","OP ate ? ","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
aAdd(aRegs,{c_Perg,"03","Lacre de ?     ","","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","Z01"})
aAdd(aRegs,{c_Perg,"04","Lacre at้ ?   ","","","mv_ch4","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","Z01"})
aAdd(aRegs,{c_Perg,"05","Cliente de ?        ","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{c_Perg,"06","Cliente at้ ?       ","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})

For i:=1 to Len(aRegs)
	If !dbSeek(c_Perg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)

Return Nil
		
	