#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EstVen    º Autor ³ Luiz Fernando      º Data ³  21/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime as informacoes dos itens de vendas por Vendedor    º±±
±±º          ³ sumarizando o valor total e as comissoes de vendedores     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ IORGA                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EstVen()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL titulo := "Faturamento Vendedor "
LOCAL cDesc1 := "Este programa ira emitir a relacao das vendas efetuadas pelo Vendedor,"
LOCAL cDesc2 := "totalizando por produto e escolhendo a moeda forte para os Valores."
LOCAL cDesc3 := ""
Local cPict  := ""
Local nLin   := 80
Local nSomaTotNF  := 0

Local Cabec1 	   := "Cod Vend           Nome Vendedor"
Local Cabec2       := "Cliente   Razao Social                              Cod. Produto      Descricao                                           N.Fisc  Pedido  Emissao   Vencto    %ComItem    Qtde           Valor Total "
Local imprime      := .T.
Local aOrd 		   := {}
Local FilSD2       := " "
Local FilSF2       := " "
Local FilSD1       := " "

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "EstVen" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "EstVen" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      :="ESTVEN"
Private cAgeIni    :=Space(06)


SF2->(dbsetorder(1))
SD2->(dbsetorder(1))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(PADR("ESTVEN",LEN(SX1->X1_GRUPO)),.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Cliente                           ³
//³ mv_par02             // Ate Cliente                          ³
//³ mv_par03             // De Data                              ³
//³ mv_par04             // Ate a Data                           ³
//³ mv_par05             // De Produto                           ³
//³ mv_par06             // Ate o Produto                        ³
//³ mv_par07             // Do Vendedor                          ³
//³ mv_par08             // Ate Vendedor                         ³
//³ mv_par09             // Tipo de Relatorio Sintetico/A01/A02  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par09 == 3  //// Analiticos 01 e 02
	Cabec1 	 := "Cod Vend           Nome Vendedor"
	Cabec2     := "Cliente   Razao Social                              Cod. Produto      Descricao                                      N.Fisc  Pedido  Emissao   Qtde           Vlr Unit          Vlr Total"
Else
	Cabec1 	 := "Cod Vend           Nome Vendedor                    Total Venda       Total Devol     Liq. Receb."
	Cabec2     := " "
	limite     := 80
	tamanho    := "M"
Endif
Do Case
	Case mv_par09 == 1
		titulo := titulo + "( SINTETICO ) de " + DtoC(mv_par03) + " até " + DtoC(mv_par04)
	Case mv_par09 == 2
		titulo := titulo + "( ANALITICO 01 CLIENTE SEM PRODUTOS ) de " + DtoC(mv_par03) + " até " + DtoC(mv_par04)
	Case mv_par09 == 3
		titulo := titulo + "( ANALITICO 02 CLIENTE COM PRODUTOS ) de " + DtoC(mv_par03) + " até " + DtoC(mv_par04)
EndCase

//            123456789012345 123456789012345678901234567890 123456/123 12/12/1234 123456789012 1234567890123456 1234567890123456 123456/123456/123456/123456/123456

If mv_par07 == Space(06)
	cAgeIni    :="0     "
Else
	cAgeIni    :=mv_par07
Endif

Private cString := "SF2"

dbSelectArea("SF2")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/03/07   º±±
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

Local nOrdem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

***** Filtrando Informacoes no arquivo Principal ( Cabec NF Saida ) *********
DbSelectArea("SD1")
cArqTrabD1 := CriaTrab( "" , .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query para SQL                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSD1   := "SD1TMP"
aStru  := dbStruct()
cQuery := "SELECT * FROM "          + RetSqlName("SD1") + " SD1 "
cQuery += "WHERE SD1.D1_FILIAL = '" +xFilial("SD1")+"' AND "
cQuery += "SD1.D1_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "  // <---------
cQuery += "SD1.D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "SD1.D1_COD     BETWEEN '"+ mv_par05 +"' AND '"+mv_par06+"' AND "
cQuery += "SD1.D1_NFORI <> '      ' AND "
cQuery += "SD1.D_E_L_E_T_ <> '*' "

cQuery += "ORDER BY SD1.D1_FILIAL,SD1.D1_NFORI,SD1.D1_COD"
//cQuery += "ORDER BY SD1.D1_FILIAL,SD1.D1_NFORI,SD1.D1_COD"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD1TRB', .F., .T.)},"Seleccionado Inf.Devolucao (SD1)")
For nj := 1 to Len(aStru)
	If aStru[nj,2] != 'C'
		TCSetField('SD1TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
	EndIf
Next nj

AEstVenCriaTmp(cArqTrabD1, aStru, cSD1, "SD1TRB")
IndRegua(cSD1,cArqTrabD1,"D1_FILIAL+D1_NFORI+D1_COD",,".T.","Indexando Devol.")
//IndRegua(cSD1,cArqTrabD1,"D1_FILIAL+D1_NFORI+D1_COD",,".T.","Indexando Devol.")
dbSetIndex(cArqTrabD1+ordBagExt())
*****************************************************************************
FilSD1 := SD1->D1_FILIAL

***** Filtrando Informacoes no arquivo Principal ( Cabec NF Saida ) *********
DbSelectArea("SF2")
cArqTrabF2 := CriaTrab( "" , .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query para SQL                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSF2   := "SF2TMP"
aStru  := dbStruct()
cQuery := "SELECT * FROM "          + RetSqlName("SF2") + " SF2 "
cQuery += "WHERE SF2.F2_FILIAL = '" +xFilial("SF2")+"' AND "
cQuery += "SF2.F2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "SF2.F2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += "SF2.F2_VEND1   BETWEEN '"+ cAgeIni +"' AND '"+mv_par08+"' AND "
cQuery += "SF2.F2_TIPO <> 'B' AND SF2.F2_TIPO <> 'D' AND "
cQuery += "SF2.F2_TIPO <> 'C' AND SF2.F2_TIPO <> 'I' AND SF2.F2_TIPO <> 'P' AND "
cQuery += "SF2.D_E_L_E_T_ <> '*' "

cQuery += "ORDER BY SF2.F2_FILIAL,SF2.F2_VEND1,SF2.F2_CLIENTE,SF2.F2_LOJA"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SF2TRB', .F., .T.)},"Seleccionado Inf.Vendas Capa (SF2)")
For nj := 1 to Len(aStru)
	If aStru[nj,2] != 'C'
		TCSetField('SF2TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
	EndIf
Next nj

AEstVenCriaTmp(cArqTrabF2, aStru, cSF2, "SF2TRB")
IndRegua(cSF2,cArqTrabF2,"F2_FILIAL+F2_VEND1+F2_CLIENTE+F2_LOJA",,".T.","Indexando Vendas")
dbSetIndex(cArqTrabF2+ordBagExt())
*****************************************************************************
FilSF2 := SF2->F2_FILIAL


***** Filtrando Informacoes no arquivo Secundario ( Itens NF Saida ) *********
DbSelectArea("SD2")
cArqTrab2  := CriaTrab( "" , .F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query para SQL                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSD2   := "SD2TMP"
aStru  := dbStruct()
cQuery := "SELECT * FROM "          + RetSqlName("SD2") + " SD2 "
cQuery += "WHERE SD2.D2_FILIAL = '" +xFilial("SD2")+"' AND "
cQuery += "SD2.D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += "SD2.D2_COD     BETWEEN '"+ mv_par05+"' AND '"+mv_par06+"' AND "
cQuery += "SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND "
cQuery += "SD2.D2_TIPO <> 'C' AND SD2.D2_TIPO <> 'I' AND SD2.D2_TIPO <> 'P' AND "
// cQuery += " NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ") AND "
cQuery += "SD2.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_DOC,SD2.D2_COD,SD2.D2_ITEM"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD2TRB', .F., .T.)},"Seleccionado Itens Venda (SD2)") //"Seleccionado registros"
For nj := 1 to Len(aStru)
	If aStru[nj,2] != 'C'
		TCSetField('SD2TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
	EndIf
Next nj

AEstVenCriaTmp(cArqTrab2, aStru, cSD2, "SD2TRB")
IndRegua(cSD2,cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_DOC+D2_COD+D2_ITEM",,,"Indexando Itens Vendas")		//"Selecionando Registros..."
dbSetIndex(cArqTrab2+ordBagExt())
*****************************************************************************
FilSD2 := SD2->D2_FILIAL

DbSelectArea(cSF2)

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea(cSD2)
dbGoTop()

DbSelectArea(cSD1)
dbGoTop()

DbSelectArea(cSF2)
dbGoTop()

cVend1   := (cSF2)->F2_VEND1
nTotFat  := 0
nTotComis:= 0
nTotDev  := 0

nTotGerFat  := 0
nTotGerDev  := 0
nSomaTotNF  := 0

nTotFatCli := 0
nTotDevCli := 0


While !Eof() .AND. ((FilSF2+(cSF2)->F2_VEND1) == (FilSF2+cVend1))

    If !Empty(mv_par05) .and. Upper(mv_par06) != "ZZZZZZZZZZZZZZZ"
        cClieAnt := (cSF2)->F2_CLIENTE
        DbSelectArea(cSD2)
		If !DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
 		  DbSelectArea(cSF2)
 		  DbSkip()
          cClieAnt := (cSF2)->F2_CLIENTE
          cVend1   := (cSF2)->F2_VEND1
		  Loop
		Endif
    Endif
	
	IncRegua()
	
	cClieAnt := (cSF2)->F2_CLIENTE
	cLojaAnt := (cSF2)->F2_LOJA
	cNf      := (cSF2)->F2_DOC
	cSerie   := (cSF2)->F2_SERIE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 61 // Salto de Página. Neste caso o formulario tem 61 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		If mv_par09 == 3  //// Analiticos 02
			nLin := 8
		Else
			nLin := 8
		Endif
		@ nLin,000 Psay "  "
		nLin := nLin + 1
		cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
		@ nLin,000 Psay "Vend.--> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
	Endif
	
	If mv_par09 != 1
		nLin := nLin + 1 // Avanca a linha de impressao
	Endif
	
	If mv_par09 == 3  //// Analiticos 02
		
		DbSelectArea(cSD2)
		If DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			If nSomaTotNF != 0
		 	   nLin := nLin - 1
             @ nLin,148 Psay "Total Nota Fiscal --->"
             @ nLin,171 Psay Transform(nSomaTotNF ,"@E 999,999,999.99")
              nSomaTotNF := 0
     		   nLin := nLin + 1 
            Endif  
			@ nLin,000 Psay Repli('-',220)
			nLin := nLin + 1
			
			@ nLin,000 PSay cClieAnt
			@ nLin,010 PSay Substr(Posicione( "SA1" , 1 , xFilial("SA1")+cClieAnt+cLojaAnt , "A1_NOME" ),1,40)
			
			DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			While (cSD2)->D2_CLIENTE == cClieAnt .and. (cSD2)->D2_DOC == (cSF2)->F2_DOC .and. !Eof()
				@ nLin,052 Psay (cSD2)->D2_COD
				@ nLin,070 Psay Substr(Posicione( "SB1" , 1 , xFilial("SB1")+(cSD2)->D2_COD , "B1_DESC" ),1,45)
				@ nLin,117 Psay (cSD2)->D2_DOC
				@ nLin,125 Psay (cSD2)->D2_PEDIDO
				@ nLin,133 Psay (cSD2)->D2_EMISSAO
				@ nLin,143 Psay Transform((cSD2)->D2_QUANT,"@E 9999.999")
				@ nLin,152 Psay Transform((cSD2)->D2_PRCVEN,"@E 999,999,999.99")				
				@ nLin,171 Psay Transform((cSD2)->D2_TOTAL ,"@E 999,999,999.99")
				**** Totalizando Valores
				nTotGerFat:= nTotGerFat + (cSD2)->D2_TOTAL
				nSomaTotNF:= nSomaTotNF + (cSD2)->D2_TOTAL
				DbSelectArea(cSD1)
				If DbSeek(FilSD1+(cSF2)->F2_DOC+(cSD2)->D2_COD)
					@ nLin,191 Psay "("+Transform((cSD1)->D1_QUANT,"@E 9999.999")+") Devolucao"
					nTotGerDev := nTotGerDev + (cSD1)->D1_TOTAL
				Endif
				
				DbSelectArea(cSD2)
				
				
				DbSkip()
				
				nLin := nLin + 1
				
				If nLin > 61
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
					@ nLin,000 Psay "  "
					nLin := nLin + 1
					cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
					@ nLin,000 Psay "Vend.--> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
					nLin := nLin + 1
					@ nLin,000 Psay Repli('-',220)
					nLin := nLin + 1
				Endif
				
			Enddo
			
		Endif
		
	Endif
	
	If mv_par09 == 2  //// Analiticos 01
		
		DbSelectArea(cSD2)
		If DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			
			@ nLin,000 Psay Repli('-',130)
			nLin := nLin + 1
			
			@ nLin,000 PSay cClieAnt
			@ nLin,010 PSay Substr(Posicione( "SA1" , 1 , xFilial("SA1")+cClieAnt+cLojaAnt , "A1_NOME" ),1,35)
			
			DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			While (cSD2)->D2_CLIENTE == cClieAnt .and. (cSD2)->D2_DOC == (cSF2)->F2_DOC .and. !Eof()
				
				**** Totalizando Valores
				nTotFatCli:= nTotFatCli + (cSD2)->D2_TOTAL
				
				DbSelectArea(cSD1)
				If DbSeek(FilSD1+(cSF2)->F2_DOC+(cSD2)->D2_COD)
					nTotDevCli := nTotDevCli + (cSD1)->D1_TOTAL
				Endif
				
				DbSelectArea(cSD2)
				
				DbSkip()
				
			Enddo
			
			@ nLin,050 Psay Transform(nTotFatCli,"@E 999,999,999.99")
			@ nLin,066 Psay "("+Transform(nTotDevCli,"@E 999,999,999.99")+")"
			@ nLin,082 Psay Transform((nTotFatCli - nTotDevCli),"@E 999,999,999.99")
			
			//nLin := nLin + 1
			
			If nLin > 61
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 7
				@ nLin,000 Psay "  "
				nLin := nLin + 1
				cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
				@ nLin,000 Psay "Vend.--> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			Endif
			
			nTotFat := nTotFat + nTotFatCli
			nTotDev := nTotDev + nTotDevCli
			nTotFatCli := 0
			nTotDevCli := 0
			
		Endif
		
	Endif
	
	If mv_par09 == 1 /// Sintético
		
		DbSelectArea(cSD2)
		
		If DbSeek(FilSD2+cClieAnt+(cSF2)->F2_DOC)
			
			While (cSD2)->D2_CLIENTE == cClieAnt .and. (cSD2)->D2_DOC == (cSF2)->F2_DOC .and. !Eof()
				
				**** Totalizando Valores
				nTotFat:= nTotFat + (cSD2)->D2_TOTAL
				
				DbSelectArea(cSD1)
				If DbSeek(FilSD1+(cSD2)->D2_DOC+(cSD2)->D2_COD)
					nTotDev := nTotDev + (cSD1)->D1_TOTAL
				Endif
				
				DbSelectArea(cSD2)
				DbSkip()
			Enddo
			
			
		Endif
		
	Endif
	
	DbSelectArea(cSF2)
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
	cClieAnt := (cSF2)->F2_CLIENTE
	cLojaAnt := (cSF2)->F2_LOJA
	
	If mv_par09 == 1
		
		If (cSF2)->F2_VEND1 != cVend1
			***** Imprime o Total da Venda do Vendedor
			@ nLin,050 Psay Transform(nTotFat,"@E 999,999,999.99")
			@ nLin,066 Psay "("+Transform(nTotDev,"@E 999,999,999.99")+")"
			@ nLin,082 Psay Transform((nTotFat - nTotDev),"@E 999,999,999.99")
			nLin := nLin + 1
			
			nTotGerFat:= nTotGerFat + nTotFat
			nTotGerDev:= nTotGerDev + nTotDev
			
			nTotFat:= 0
			nTotDev:= 0
			
			***** Incrementou o Vendedor
			cVend1   := (cSF2)->F2_VEND1
			cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
			If !Empty(cVend1)
				@ nLin,000 Psay "Vend --> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			Endif
		Endif
		
	Endif
	
	If mv_par09 == 2 // Sintetico e Analitico 01
		
		If (cSF2)->F2_VEND1 != cVend1
			***** Imprime o Total da Venda do Vendedor
			nLin := nLin + 1
			@ nLin,000 Psay Repli('-',130)
			nLin := nLin + 1
			@ nLin,000 Psay "Total Vend. --> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			@ nLin,051 Psay Transform(nTotFat,"@E 999,999,999.99")
			@ nLin,067 Psay "("+Transform(nTotDev,"@E 999,999,999.99")+")"
			@ nLin,083 Psay Transform((nTotFat - nTotDev),"@E 999,999,999.99")
			nLin := nLin + 1
			@ nLin,000 Psay Repli('-',130)
			nLin := nLin + 2
			
			nTotGerFat:= nTotGerFat + nTotFat
			nTotGerDev:= nTotGerDev + nTotDev
			
			nTotFat:= 0
			nTotDev:= 0
			
			***** Incrementou o Vendedor
			cVend1   := (cSF2)->F2_VEND1
			cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
			If !Empty(cVend1)
				@ nLin,000 Psay "Vend --> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			Endif
		Endif
	Endif
	

	If mv_par09 == 3 // Sintetico e Analitico 02
		If (cSF2)->F2_VEND1 != cVend1
			***** Imprime o Total da Venda do Vendedor
			nLin := nLin + 1
			
			***** Incrementou o Vendedor
			cVend1   := (cSF2)->F2_VEND1
			cComis :=  Transform(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_COMIS" ) ,"@E 999.99")
			If !Empty(cVend1)
				@ nLin,000 Psay "Vend --> " + cVend1 + " - " + Substr(Posicione( "SA3" , 1 , xFilial("SA3")+cVend1 , "A3_NOME" ),1,36)
			Endif
		Endif
	Endif

	cVend1   := (cSF2)->F2_VEND1
	
EndDo

nLin := nLin + 1
@ nLin,000 Psay Repli('=',220)
nLin := nLin + 1
@ nLin,030 Psay "Total Geral ---->"
@ nLin,050 Psay Transform(nTotGerFat,"@E 999,999,999.99")
@ nLin,066 Psay "("+Transform(nTotGerDev,"@E 999,999,999.99")+")"
@ nLin,082 Psay Transform((nTotGerFat - nTotGerDev),"@E 999,999,999.99")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

(cSF2)->(DbCloseArea())
(cSD2)->(DbCloseArea())
(cSD1)->(DbCloseArea())
fErase(cArqTrabF2+OrdBagExt())
fErase(cArqTrab2+OrdBagExt())
fErase(cArqTrabD1+OrdBagExt())
#IFDEF TOP
	fErase(cArqTrabF2+GetDbExtension())
	fErase(cArqTrab2+GetDbExtension())
	fErase(cArqTrabD1+GetDbExtension())
#ENDIF

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AEstVenCriaTmp³ Autor ³ Microsiga          ³ Data ³ 04/07/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria temporario a partir da consulta corrente (TOP)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATR780 (TOPCONNECT)                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Substituido pelo assistente de conversao do AP6 IDE em 21/03/07 ==> Function A780CriaTmp(cArqTmp, aStruTmp, cAliasTmp, cAlias)
Static Function AEstVenCriaTmp(cArqTmp, aStruTmp, cAliasTmp, cAlias)
Local nI, nF, nPos
Local cFieldName := ""
nF := (cAlias)->(Fcount())
dbCreate(cArqTmp,aStruTmp)
DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
(cAlias)->(DbGoTop())
While ! (cAlias)->(Eof())
	(cAliasTmp)->(DbAppend())
	For nI := 1 To nF
		cFieldName := (cAlias)->( FieldName( ni ))
		If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
			(cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
		EndIf
	Next
	(cAlias)->(DbSkip())
End
(cAlias)->(dbCloseArea())
DbSelectArea(cAliasTmp)
Return Nil