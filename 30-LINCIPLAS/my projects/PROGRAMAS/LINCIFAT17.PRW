#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLINCIFAT17บ Autor ณ Rodrigo Demetrios  บ Data ณ  07/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelatorio de Pedidos Entregues fora da data                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LIFAT17()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Local cInd
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Pedidos Entregues fora da data"
Local cPict          := ""
Local titulo         := "Pedidos Entregues Fora da Data"
Local nLin           := 80

Local Cabec1       := " Pedido   Data      Produto          Descri็ใo do Produto            Cliente   Nome do Cliente                      Quantidade       Quantidade       Valor       Entrega     Nota      Data         Dias"
Local Cabec2       := "          Emissao                                                                                                   Vendida          Entregue         C/ IPI      Prevista    Fiscal    Realizada    Atraso"
Local imprime      := .T.
Local aOrd := {}


Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "LIFAT17" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "LIFA17"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "LIFAT17" // Coloque aqui o nome do arquivo usado para impressao em disco

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

cdatade := mv_par01
cdataate := mv_par02
centde := mv_par03
centate := mv_par04

dbSelectArea("SC6")
//dbSetOrder(1)
cFilTrab   := CriaTrab("",.F.)
cCondicao  := "C6_FILIAL=='"+xFilial("SC6")+"'.And."
cCondicao  += "Dtos(C6_ENTREG)>='"+Dtos(MV_PAR03)+"'.And.Dtos(C6_ENTREG)<='"+Dtos(MV_PAR04)+"'"
IndRegua("SC6",cFilTrab,"C6_FILIAL+C6_NUM+C6_ITEM",,cCondicao,"Filtrando")    // "Selecionando Registros..."

COPY TO TESTE.DBF
DbGoTop()
SetRegua(RecCount())

While !Eof()
	IncRegua()
	
	_cNUM := sc6->c6_NUM
	_cITEMPV := sc6->c6_item
	_NCONTOLE := 0
	While !EOF() .AND.  _cNUM == sc6->c6_NUM .and. _cITEMPV == sc6->c6_item
		
		IF (C6_TES $ '501/502/504/506/507/528/534/535/536/541/542/543/545/547/552/554/555/557/559/561/562/564')
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
			dbseek(xfilial("SB1") + SC6->C6_PRODUTO )
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbseek(xfilial("SA1") + SC6->C6_CLI)
			
			dbSelectArea("SC5")
			dbSetOrder(1)
			dbseek(xfilial("SC5") + SC6->C6_NUM)
			
			// Pedido   Data      Produto          Descri็ใo do Produto             Cliente   Nome do Cliente                  Valor            Valor            Valor            Entrega     Nota      Data         Dias
			//          Emissao                                                                                "  1            S/ IPI           IPI              C/ IPI           Prevista    Fiscal    Realizada    Atraso
			// 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			//          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6        17        18        19        20         21       22
			
			@nLin,01 PSAY SC6->C6_NUM                                                                                                                                           //99/99/99    999999    99/99/99     999
			@nLin,10 PSAY SC5->C5_EMISSAO
			@nLin,20 PSAY SC6->C6_PRODUTO + " - " + SB1->B1_DESC
			@nLin,70 PSAY SC6->C6_CLI + " - " + SUBSTR(SA1->A1_NOME,1,20)
			@nLin,113 PSAY  SC6->C6_QTDVEN PICTURE "@E 99,999,999"
			//@nLin,113 PSAY SC6->C6_VALOR PICTURE "@E 99,999,999.99"
			nValIPI := ((SC6->C6_VALOR * SB1->B1_IPI)/100)
			@nLin,130 PSAY SC6->C6_QTDENT PICTURE "@E 99,999,999"
			//@nLin,130 PSAY nValIPI PICTURE "@E 99,999,999.99"
			nValTOTAL := nValIPI + SC6->C6_VALOR
			@nLin,147 PSAY nValTOTAL PICTURE "@E 99,999,999.99"
			@nLin,164 PSAY SC6->C6_ENTREG
			@nLin,176 PSAY SC6->C6_NOTA
			@nLin,186 PSAY SC6->C6_DATFAT
			@nLin,199 PSAY SC6->C6_DATFAT - SC6->C6_ENTREG
			
			nLin := nLin + 1 // Avanca a linha de impressao
			_NCONTOLE := 1


		//	dbSelectArea("SD2")
		//	cFilSD2   := CriaTrab(NIL,.F.)
		//	cConSD2  := "D2_FILIAL == '"+xFilial("SD2")+"'"
		//	IndRegua("SD2",cFilSD2,"D2_FILIAL+D2_PEDIDO+D2_ITEMPV",,cConSD2,"Filtrando")    // "Selecionando Registros..."
		//	DbGoTop()
			
			DbSelectArea("SD2")
			DBSETORDER(8)
			Dbseek(xfilial("SD2") + SC6->C6_NUM + SC6->C6_ITEM )
			
				_CPEDIDO := SD2->D2_PEDIDO
				_CITEMPV    := SD2->D2_ITEMPV   //INCLUIDO DIA 21/02/07 SOLICITADO POR EVERALDO PARA QUANDO O PEDIDO TIVER DOIS ITENS IGUAIS.
				NQUANT := 0
				_LPRI := .T.
				DbSelectArea("SD2")
				
				While !EOF() .AND. SD2->D2_PEDIDO == _CPEDIDO  .AND. _CITEMPV == SD2->D2_ITEMPV //INCLUIDO DIA 21/02/07 SOLICITADO POR EVERALDO PARA QUANDO O PEDIDO TIVER DOIS ITENS IGUAIS.
					
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
					
					If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 10
					Endif
					
					IF  _LPRI
					nLin := nLin + 1
					@nLin,01 PSAY "Nota     Data      Produto          Descri็ใo do Produto                 Valor            Valor            Valor       Entrega   ----------------- Quantidades ----------------"
					nLin := nLin + 1 // Avanca a linha de impressao
					@nLin,01 PSAY "         Emissao                                                         S/ IPI           IPI              C/ IPI                     Original      Ja Entregue           Saldo"
					// 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
					//          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7
					nLin := nLin + 1 // Avanca a linha de impressao
					_LPRI := .F.
					ENDIF
					@nLin,01 PSAY SD2->D2_DOC                                                                                                        // 99,999,999.99    99,999,999.99   99,999,999.99
					@nLin,10 PSAY SD2->D2_EMISSAO
					@nLin,20 PSAY SD2->D2_COD + " - " + SUBSTR(SB1->B1_DESC,1,38)
					@nLin,70 PSAY SD2->D2_TOTAL PICTURE "@E 99,999,999.99"
					@nLin,87 PSAY SD2->D2_VALIPI PICTURE "@E 99,999,999.99"
					nValTOTAL := SD2->D2_TOTAL + SD2->D2_VALIPI
					@nLin,104 PSAY nValTOTAL PICTURE "@E 99,999,999.99"
					
					
					@nLin,121 PSAY SC6->C6_ENTREG //SD2->D2_EMISSAO //SC6->C6_ENTREG
					@nLin,131 PSAY SC6->C6_QTDVEN PICTURE "@E 99,999,999.99"
					@nLin,148 PSAY SD2->D2_QUANT PICTURE "@E 99,999,999.99"
					NQUANT := NQUANT + SD2->D2_QUANT
					NSALDOQ   := (SC6->C6_QTDVEN - NQUANT)
					@nLin,164 PSAY NSALDOQ PICTURE "@E 99,999,999.99"
					
					nLin := nLin + 1 // Avanca a linha de impressao
					
					dbSelectArea("SD2")
					dbSkip()
				EndDo
			nLin := nLin + 1
			dbSelectArea("SC6")
		ENDIF
		dbSelectArea("SC6")
		dbSkip() // Avanca o ponteiro do registro no arquivo
	END	
	IF _NCONTOLE == 1
		@nLin,000 PSAY REPLICATE("-",220)
		
		nLin := nLin + 2
	ENDIF
	dbSelectArea("SC6")
ENdDo


dbSelectArea("SD2")
retindex()
dbsetorder(1)

dbSelectArea("SC5")
retindex()
dbsetorder(1)

dbSelectArea("SC6")
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

