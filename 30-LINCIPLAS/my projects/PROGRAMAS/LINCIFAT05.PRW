#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLINCIFAT05บ Autor ณ Rodrigo Demetrios  บ Data ณ  07/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelatorio de Inclusao de Pedidos                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LIFAT05()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Local cInd
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Pedidos Emitidos"
Local cPict          := ""
Local titulo         := "Pedidos Emitidos"
Local nLin           := 80

Local Cabec1       := " Pedido   Data      Produto     Descri็ใo do Produto                Cliente   Nome do Cliente                         Valor            Valor            Valor        Entrega"
Local Cabec2       := "          Emissao                                                                                                     S/ IPI           IPI              C/ IPI              "
Local imprime      := .T.
Local aOrd := {}


Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "LIFAT05" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "LIFAT5"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "LIFAT05" // Coloque aqui o nome do arquivo usado para impressao em disco

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

dbSelectArea("SC5")
cFilTrab   := CriaTrab(NIL,.F.)
cCondicao  := "C5_FILIAL == '"+xFilial("SC5")+"'.And."
cCondicao  += "Dtos(C5_EMISSAO)>='"+Dtos(CDATADE)+"'.And.Dtos(C5_EMISSAO)<='"+Dtos(CDATAATE)+"'"
IndRegua("SC5",cFilTrab,"C5_FILIAL+DTOS(C5_EMISSAO)",,cCondicao,"Filtrando")    // "Selecionando Registros..."
DbGoTop()
SetRegua(RecCount())

//dbSelectArea("SZ2")
//dbSetOrder(2)
//dbseek(xfilial("SZ2") + DTOS(MV_PAR01))
NTOTGER := 0  //TOTAL GERAL SEM IPI
NTOTGIPI := 0 //TOTAL DO IPI
NTOTGCIPI := 0//TOTAL GERAL COM IPI
 
_CONTROLE := "2"

While !EOF() //.And. xFilial("SZ2") == Z2_FILIAL .And. DTOS(Z2_DTCANCE) >= DTOS(CDATADE) .AND. DTOS(Z2_DTCANCE) <= DTOS(CDATAATE)
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbseek(xfilial("SC6") + SC5->C5_NUM )
	NTOTPED := 0 //TOTAL PEDIDO SEM IPI
	NTOTIPI := 0 //TOTAL IPI
	NTOTCIPI:= 0 //TOTAL PEDIDO COM IPI  
	
	
	While !EOF() .AND. SC6->C6_NUM == SC5->C5_NUM
		
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
		
		
		IF !(C6_TES $ '501/502/504/506/507/528/534/535/536/541/542/543/545/547/552/554/555/557/559/561/562/564') .AND. C6_BLQ <> 'R '  
		    _CONTROLE := "1"
		    DBSELECTAREA("SC5")
		    DBSKIP()
		    dbSelectArea("SC6")
			dbSetOrder(1)
			dbseek(xfilial("SC6") + SC5->C5_NUM )
		    LOOP	
		ELSE
		   _CONTROLE := "2" 
		Endif 
		
    	IF Dtos(C6_ENTREG)>= Dtos(CENTDE) .And. Dtos(C6_ENTREG) <= Dtos(CENTATE)
		    _CONTROLE := "2"
		ELSE
		    _CONTROLE := "1"
		    DBSELECTAREA("SC5")
		    DBSKIP()
		    dbSelectArea("SC6")
			dbSetOrder(1)
			dbseek(xfilial("SC6") + SC5->C5_NUM )
		    LOOP	
		Endif
				
		IF _CONTROLE == "2"
	
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbseek(xfilial("SB1") + SC6->C6_PRODUTO )
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbseek(xfilial("SA1") + SC6->C6_CLI)
		
		// Pedido   Data      Produto          Descri็ใo do Produto             Cliente   Nome do Cliente                  Valor            Valor            Valor            Entrega
		//          Emissao                                                                                "  1            S/ IPI           IPI              C/ IPI
		// 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6
		@nLin,01 PSAY SC6->C6_NUM
		@nLin,10 PSAY SC5->C5_EMISSAO
		@nLin,20 PSAY SC6->C6_PRODUTO + " - " + SB1->B1_DESC
		@nLin,70 PSAY SC6->C6_CLI + " - " + SUBSTR(SA1->A1_NOME,1,20)
		@nLin,113 PSAY SC6->C6_VALOR PICTURE "@E 99,999,999.99"
		nValIPI := ((SC6->C6_VALOR * SB1->B1_IPI)/100)
		@nLin,130 PSAY nValIPI PICTURE "@E 99,999,999.99"
		nValTOTAL := nValIPI + SC6->C6_VALOR
		@nLin,147 PSAY nValTOTAL PICTURE "@E 99,999,999.99"
    	@nLin,164 PSAY SC6->C6_ENTREG 
		
		
        //_CONTROLE := "2"
		NTOTPED := NTOTPED + SC6->C6_VALOR
		NTOTIPI := NTOTIPI + NVALIPI
		NTOTCIPI:= NTOTCIPI + NVALTOTAL
		
		nLin := nLin + 1 // Avanca a linha de impressao
	
	    ENDIF
		dbSelectArea("SC6")
		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo
	
	IF _CONTROLE == "2"
		@nLin,000 PSAY "TOTAL PEDIDO" + " --------------------------------------------------> "
		@nLin,112 PSAY NTOTPED PICTURE "@E 99,999,999.99"
		@nLin,129 PSAY NTOTIPI PICTURE "@E 99,999,999.99"
		@nLin,146 PSAY NTOTCIPI PICTURE "@E 99,999,999.99"
		
		nLin := nLin + 1
		nLin := nLin + 1
		nTotGER  +=  NTOTPED 
		NTOTGIPI  += NTOTIPI
		NTOTGCIPI += NTOTCIPI
 
	ENDIF
	

	
	dbSelectArea("SC5")
	dbSkip() // Avanca o ponteiro do registro no arquivo
ENdDo

nLin := nLin + 1
nLin := nLin + 1

@nLin,000 PSAY "TOTAL GERAL" + " --------------------------------------------------> "
@nLin,112 PSAY nTotGER PICTURE "@E 99,999,999.99"
@nLin,129 PSAY NTOTGIPI PICTURE "@E 99,999,999.99"
@nLin,146 PSAY NTOTGCIPI PICTURE "@E 99,999,999.99"


dbSelectArea("SC6")
//dbClearFilter()
retindex()
dbsetorder(1)

dbSelectArea("SC5")
//dbClearFilter()
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

