#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLINCIFAT10บ Autor ณ Rodrigo Demetrios  บ Data ณ  26/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelatorio de Pedidos demonstrando suas notas fiscais.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LIFAT10()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Local cInd
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Demonstrativo de Pedidos e Notas Fiscais"
Local cPict          := ""
Local titulo         := "Demonstrativo de Pedidos e Notas Fiscais"
Local nLin           := 80

Local Cabec1       := " Nota     Data      Produto           Descri็ใo do Produto                  ------------------ Valores -------------     Entrega   ----------------- Quantidades ----------------"
Local Cabec2       := " Fiscal   Fatura                                                            S/ IPI           IPI              C/ IPI                   Original      Ja Entregue           Saldo"
Local imprime      := .T.
Local aOrd := {}


Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "LIFAT10" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "LIFA10"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "LIFAT10" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC5"

pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  07/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

cPedde := mv_par01
cPedate := mv_par02

dbSelectArea("SC5")
cFilTrab   := CriaTrab(NIL,.F.)
cCondicao  := "C5_FILIAL == '"+xFilial("SC5")+"'.And."
cCondicao  += "C5_NUM >= '"+CPEDDE+"'.And.C5_NUM <= '"+CPEDATE+"'"
IndRegua("SC5",cFilTrab,"C5_FILIAL+C5_NUM",,cCondicao,"Filtrando")    // "Selecionando Registros..."
DbGoTop()
SetRegua(RecCount())

NTOTGER  :=  0
NTOTGIPI  := 0
NTOTGCIPI := 0

While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 10
	Endif
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	Dbseek(xfilial("SA1") + SC5->C5_CLIENTE)
	
	// Pedido   Data      Cliente   Nome do Cliente
	//          Emissao
	// 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6
	
	@nLin,01 PSAY "PEDIDO:  " +  SC5->C5_NUM
	@nLin,20 PSAY SC5->C5_EMISSAO
	@nLin,30 PSAY SC5->C5_CLIENTE + " - " + SA1->A1_NOME
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
	
	dbSelectArea("SD2")
	cFilSD2   := CriaTrab(NIL,.F.)
	cConSD2  := "D2_FILIAL == '"+xFilial("SD2")+"'"
	IndRegua("SD2",cFilSD2,"D2_FILIAL+D2_PEDIDO+D2_COD",,cConSD2,"Filtrando")    // "Selecionando Registros..."
	DbGoTop()
	
	DbSelectArea("SD2")
	Dbseek(xfilial("SD2") + SC5->C5_NUM )
	
	While !EOF() .AND. SD2->D2_PEDIDO == SC5->C5_NUM
		NTOTPED := 0 //TOTAL PEDIDO SEM IPI
		NTOTIPI := 0 //TOTAL IPI
		NTOTCIPI:= 0 //TOTAL PEDIDO COM IPI		
		_CPRODUTO := SD2->D2_COD
		_CITEMPV    := SD2->D2_ITEMPV   //INCLUIDO DIA 21/02/07 SOLICITADO POR EVERALDO PARA QUANDO O PEDIDO TIVER DOIS ITENS IGUAIS.
		NQUANT := 0
		
		dbSelectArea("SC6")
		dbSetOrder(2)
		dbseek(xfilial("SC6") + SD2->D2_COD + SD2->D2_PEDIDO + SD2->D2_ITEMPV) //INCLUIDO DIA 21/02/07 SOLICITADO POR EVERALDO PARA QUANDO O PEDIDO TIVER DOIS ITENS IGUAIS.
    	
    	DbSelectArea("SD2")
		
		While !EOF() .AND. SD2->D2_PEDIDO == SC5->C5_NUM .AND. SD2->D2_COD == _CPRODUTO .AND. SD2->D2_ITEMPV == _CITEMPV  //INCLUIDO DIA 21/02/07 SOLICITADO POR EVERALDO PARA QUANDO O PEDIDO TIVER DOIS ITENS IGUAIS.
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do cabecalho do relatorio. . .                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 10
			Endif
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbseek(xfilial("SB1") + SD2->D2_COD )
			
			// Pedido   Data      Produto          Descri็ใo do Produto             Valor            Valor            Valor            Entrega   ----------------- Quantidades ----------------
			//          Emissao                                                     S/ IPI           IPI              C/ IPI                          Original      Ja Entregue           Saldo
			// 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
			//          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7
			@nLin,01 PSAY SD2->D2_DOC                                                                                                        // 99,999,999.99    99,999,999.99   99,999,999.99
			@nLin,10 PSAY SD2->D2_EMISSAO
			@nLin,20 PSAY SD2->D2_COD + " - " + SUBSTR(SB1->B1_DESC,1,38)
			@nLin,70 PSAY SD2->D2_TOTAL PICTURE "@E 99,999,999.99"
			@nLin,87 PSAY SD2->D2_VALIPI PICTURE "@E 99,999,999.99"
			nValTOTAL := SD2->D2_TOTAL + SD2->D2_VALIPI
			@nLin,104 PSAY nValTOTAL PICTURE "@E 99,999,999.99"
			
		//	dbSelectArea("SC6")
		//	dbSetOrder(2)
		//	dbseek(xfilial("SC6") + SD2->D2_COD + SD2->D2_PEDIDO )
			@nLin,121 PSAY SC6->C6_ENTREG //SD2->D2_EMISSAO //SC6->C6_ENTREG
			@nLin,131 PSAY SC6->C6_QTDVEN PICTURE "@E 99,999,999.99"
			@nLin,148 PSAY SD2->D2_QUANT PICTURE "@E 99,999,999.99"
			NQUANT := NQUANT + SD2->D2_QUANT
			NSALDOQ   := (SC6->C6_QTDVEN - NQUANT)
			@nLin,164 PSAY NSALDOQ PICTURE "@E 99,999,999.99"
			
			NTOTPED := NTOTPED + SD2->D2_TOTAL
			NTOTIPI := NTOTIPI + SD2->D2_VALIPI
			NTOTCIPI:= NTOTCIPI + NVALTOTAL
			nLin := nLin + 1
			
			dbSelectArea("SD2")
			dbSkip()
		EndDo
		
		@nLin,000 PSAY "TOTAL PRODUTO" + " --------------------------------------------------> "
		@nLin,069 PSAY NTOTPED PICTURE "@E 99,999,999.99"
		@nLin,086 PSAY NTOTIPI PICTURE "@E 99,999,999.99"
		@nLin,103 PSAY NTOTCIPI PICTURE "@E 99,999,999.99"
		
		nTotGER  +=  NTOTPED
		NTOTGIPI  += NTOTIPI
		NTOTGCIPI += NTOTCIPI 
        nLin := nLin + 1
	//	dbSelectArea("SD2")
	//	dbSkip()
	EndDo

	dbSelectArea("SC5")
	dbSkip() // Avanca o ponteiro do registro no arquivo
ENdDo

nLin := nLin + 1
nLin := nLin + 1

@nLin,000 PSAY "TOTAL GERAL" + " --------------------------------------------------> "
@nLin,069 PSAY nTotGER PICTURE "@E 99,999,999.99"
@nLin,086 PSAY NTOTGIPI PICTURE "@E 99,999,999.99"
@nLin,103 PSAY NTOTGCIPI PICTURE "@E 99,999,999.99"


dbSelectArea("SD2")
retindex()
dbsetorder(1)

dbSelectArea("SC5")
retindex()
dbsetorder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

