#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ           บ Autor ณ                   บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Demonstrativo de IPI.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IPIDEMO()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de Demonstrativo de IPI de acordo com os parametros"
Local cDesc3       := "Demonstrativo de IPI."
Local cPict        := ""
Local titulo       := "Demonstrativo de IPI"
Local nLin         := 132
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd 		   := {}

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "M"
Private nomeprog   := "IPIDEMO" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "FATR11"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private cString    := "SD2"
Private wnrel      := "IPIDEMO" // Coloque aqui o nome do arquivo usado para impressao em disco

/*
mv_par01			Cliente de
mv_par02			Cliente ate
mv_par03			Emissao de
mv_par04			Emissao ate
*/
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

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

RptStatus({|| RunReportIPI(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReportIPI(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem, cQuery, cNF
Local nTotMerc  := 0.00
Local nTotQtd   := 0.00
Local nTotIPI   := 0.00
Local nAcumMerc := 0
Local nAcumQtd  := 0
Local nAcumIPI  := 0
titulo          := "Demonstrativo de IPI ("+DTOC(mv_par03)+" - "+DTOC(mv_par04)+")"
cString := "TRB"
/*
cQuery := "SELECT D2_DOC, D2_SERIE, D2_EMISSAO, A1_NOME, B1_POSIPI, D2_IPI, SUM(D2_TOTAL) AS D2_TOTAL, SUM(D2_QUANT) AS D2_QUANT, SUM(D2_VALIPI) AS D2_VALIPI "
cQuery += " FROM "+RETSQLNAME("SD2")+", "+RETSQLNAME("SA1")+", "+RETSQLNAME("SB1")+" "
cQuery += " WHERE A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND B1_COD=D2_COD AND "
cQuery += " D2_FILIAL="+xFilial("SD2")+" AND D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += " D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += " D2_SERIE = 'UNI' AND "
cQuery += " "+RETSQLNAME("SD2")+".D_E_L_E_T_<>'*' AND "
cQuery += " "+RETSQLNAME("SA1")+".D_E_L_E_T_<>'*' AND "
cQuery += " "+RETSQLNAME("SB1")+".D_E_L_E_T_<>'*' "
cQuery += " GROUP BY D2_DOC, D2_SERIE, D2_EMISSAO, A1_NOME, B1_POSIPI, D2_IPI "
cQuery += " ORDER BY D2_DOC, D2_SERIE, D2_EMISSAO, B1_POSIPI "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cString,.F.,.T.)
TCSETFIELD(cString,"D2_TOTAL","N",14,2)
TCSETFIELD(cString,"D2_QUANT","N",9,2)
TCSETFIELD(cString,"D2_IPI","N",5,2)
TCSETFIELD(cString,"D2_VALIPI","N",9,2)
TCSETFIELD(cString,"D2_EMISSAO","D",8,0)
 */
dbSelectArea("SD2")
dbSetOrder(5)   // Ordem de emissao 
dbSeek(xFilial("SD2")+DTOS(MV_PAR03),.T.)


SetRegua(RecCount())


While !EOF() .AND. SD2->D2_EMISSAO <= MV_PAR04
    IncRegua()
    
    dbSelectArea("SA1")
    dbSetOrder(1)
    dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
    
    


	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	Cabec1 := "Classificacao    Valor Mercadorias    Quantidades   Aliquota IPI(%)   Valor IPI"
	Cabec2 := ""
	//         0         1         2         3         4         5         6         7         8         9        10        11        12        13
	//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//         9999.99.99       99.999.999.999,99     999.999,99             99,99   999.999,99
    //                         999,999,999,999.99 999,999,999.99                     999,999.99

	cNF := SD2->D2_DOC
	nTotFrete := 0
	nTotV1 := 0
	nTotV2 := 0
	nTotV3 := 0	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	@ nLin, 000 PSAY "NF: "+SD2->D2_DOC+"   Emissao: "+DTOC(SD2->D2_EMISSAO)+"   Razao Social: "+SA1->A1_NOME
	nLin += 1	
	While cNF == SD2->D2_DOC

	    dbSelectArea("SB1")
    	dbSetOrder(1)
	    dbSeek(xFilial("SB1")+SD2->D2_COD)

		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		@ nLin, 000 PSAY Transform(SB1->B1_POSIPI,"@ 9999,99,99")
		@ nLin, 017 PSAY Transform(SD2->D2_TOTAL,"@E 99,999,999,999.99")
		@ nLin, 039 PSAY Transform(SD2->D2_QUANT,"@E 999,999.99")
		@ nLin, 062 PSAY Transform(SD2->D2_IPI,"@E 99.99")
		@ nLin, 070 PSAY Transform(SD2->D2_VALIPI,"@E 999,999.99")
		nLin += 1 // Avanca a linha de impressao
		nTotMerc := SD2->D2_TOTAL  // += //  ALTERADO 
		nTotQtd := SD2->D2_QUANT   // +=
		nTotIPI := SD2->D2_VALIPI  // +=

  	    nTotV1 += SD2->D2_TOTAL  // += //  ALTERADO
		nTotV2 += SD2->D2_QUANT   // +=
		nTotV3 += SD2->D2_VALIPI  // +=		
		
		dbSelectArea("SD2")
		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo
	@ nLin, 020 PSAY replicate('-',80)
	nLin += 1
	@ nLin, 000 PSAY "Totais da Nota :"
	@ nLin, 017 PSAY Transform(nTotV1,"@E 99,999,999,999.99")
	@ nLin, 039 PSAY Transform(nTotV2,"@E 999,999.99")
	@ nLin, 070 PSAY Transform(nTotV3,"@E 999,999.99")
	nLin += 2
	nAcumMerc+= nTotMerc
	nAcumQtd += nTotQtd
	nAcumIPI := nAcumIPI + nTotV3    //  ALTERADO 
EndDo

	@ nLin, 020 PSAY replicate('-',80)
	nLin += 4
	@ nLin, 000 PSAY "Totais Gerais:"
	@ nLin, 017 PSAY Transform(nAcumMerc,"@E 99,999,999,999.99")
	@ nLin, 035 PSAY Transform(nAcumQtd,"@E 999,999,999.99")
	@ nLin, 070 PSAY Transform(nAcumIpI,"@E 999,999.99")     //  ALTERADO 
	nLin += 2                         
	
	@ nLin, 020 PSAY replicate('-',80)	
	
	@ nLin, 000 PSAY SPACE(070)
    @ nLin+1, 000 PSAY CHR(13)       // OU USA-SE CHR(18) - ENTER NO FINAL DA LINHA PARA FINALIZAR A IMPRESSAO

dbSelectArea("SD2")


//SETPRC(0,0)       //   ALTERADO PARA ZERAR FORMULARIO

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return()
/*
mv_par01			Cliente de
mv_par02			Cliente ate
mv_par03			Emissao de
mv_par04			Emissao ate
*/