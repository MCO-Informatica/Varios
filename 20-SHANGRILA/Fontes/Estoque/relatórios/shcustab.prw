#INCLUDE "rwmake.ch"              
//#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CUSTAB   º Autor ³ Marcos M. Neto	 º Data ³  02/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de analise do Custo Standard x Tabela (CUSTAB)   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Shangri-lá                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CusTab()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cArqTR1
Local cArqTR2
Local cIndTR1, cIndTR2
Local aStruTR1      := {}
Local aStruTR2      := {}

Local titulo  := OemToAnsi("Custo Standard x Custo Tabela")                                     
Local cDesc1  := OemToAnsi("Este programa ira emitir a relacao dos Produtos com custo standard e")
Local cDesc2  := OemToAnsi("o custo da tabela.")
Local cDesc3  := ""
Local nOpca
Local cString := "SB1"
Local cPict   := ""
Local nLin    := 80
Local nMoeda

//		                         0         0         0         0         0         0         0         0         0         0         1         1         1         1         1         1         1         1         1         1         2
//	   	                         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
//			                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Private Cabec1 	   := OemToAnsi("                                                            Data de       Custo    Custo    %       Custo    %       %    M ")
Private Cabec2     := OemToAnsi("     Codigo     Descricao                                UM Referencia   Tabela Standard TabXStd    Medio TabXMed StdXMed $ ")
//	  		                          9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99 99/99/9999 9,999.99 9,999.99 9999,99 9,999.99 9999,99 9999,99 9
//	        	                 0         0         0         0         0         0         0         0         0         0         1         1         1         1         1         1         1         1         1         1         2
//	   	                         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
//			                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//old 		                          9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99 99/99/9999 9,999,999.99 9,999,999.99 9999,99 999,999,999.99 9999,99 9999,99 9

Private imprime    := .T.
Private nOrdem	   := 0
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220	//Private limite     := 220		// 80,132,220 
Private tamanho    := "G"	//Private tamanho    := "G"		// P,M,G
Private nomeprog   := "CUSTAB" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := {OemToAnsi("Zebrado"),1,OemToAnsi("Administracao"),1,1,1,"",1}  //"Zebrado"###"Administracao"  ////Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}	// areturn[4] 1- retrato, 2 - Paisagem
/*
	aReturn[1] => Reservado para Formulário
	aReturn[2] => Reservado para Nº de Vias
	aReturn[3] => Destinatário
	aReturn[4] => Formato => 1-Comprimido 2-Normal // 1-retrato, 2-Paisagem
	aReturn[5] => Mídia => 1-Disco 2-Impressora
	aReturn[6] => Porta ou Arquivo 1-LPT1... 4-COM1...
	aReturn[7] => Expressão do Filtro
	aReturn[8] => Ordem a ser selecionada // nOrden
	[9]..[10]..[n] Campos a Processar (se houver)
*/
//Private aOrd       :={OemToAnsi("Por Código                         "),OemToAnsi("Por Vendedor                       "),OemToAnsi("Por Vendido          (Base Emissão)"),OemToAnsi("Por Vendido          (Base Entrega)"),OemToAnsi("Por Faturado         (Base Emissão)"),OemToAnsi("Por Faturado Liquido (Base Emissão)") }  //"Por Codigo"###"Por Nome"
Private aOrd       := {}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CUSTAB" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := PadR("CUSTAB",Len(SX1->X1_GRUPO))
//Private cAgeIni    := Space(06)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Do Grupo                             ³
//³ mv_par02             // Ate o Grupo                          ³
//³ mv_par03             // Do Tipo                              ³
//³ mv_par04             // Ate o Tipo                           ³
//³ mv_par05             // Referencia (CUSTAB)                  ³
//³ mv_par06             // Valor de Referencia                  ³
//³ mv_par09             // Tipo de Relatorio Sintetico/A01/A02  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString := "SB1"

dbSelectArea("SB1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//nTipo := If(aReturn[4]==1,15,18)
nTipo := 15

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|lEnd| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem        := aReturn[8]
Local aStruTR1      := {}
Local TempCod	 	:= "      "
Local TempTotal  	:= 0

//-----------------------------------------------------------------------------------------------------------------------------
	cQuery := "SELECT SB1.B1_GRUPO, SB1.B1_TIPO, SB1.B1_COD, SB1.B1_DESC, SB1.B1_UM, SB1.B1_CUSTAB, SB1.B1_DATREF, SB1.B1_CUSTD, SB1.B1_MCUSTD, SB2.B2_CM1 "
	cQuery += "from " + RetSqlName("SB1") + " SB1 LEFT JOIN " + RetSqlName("SB2") + " SB2 ON ((SB1.B1_COD=SB2.B2_COD) and (SB1.B1_LOCPAD=SB2.B2_LOCAL)) "
	cQuery += "WHERE SB1.B1_FILIAL = '" +xFilial("SB1")+"' AND "
	cQuery += "SB2.B2_FILIAL = '" +xFilial("SB2")+"' AND "
	cQuery += "SB1.B1_GRUPO BETWEEN '"+ mv_par01 +"' AND '"+mv_par02+"' AND "
	cQuery += "SB1.B1_TIPO  BETWEEN '"+ mv_par03 +"' AND '"+mv_par04+"' AND "
	if mv_par05=2
		cQuery += "SB1.B1_CUSTAB <> 0 AND "
	Endif
	cQuery += "SB1.D_E_L_E_T_ <> '*' AND "
	cQuery += "SB2.D_E_L_E_T_ <> '*' "
	cQuery += "order by SB1.B1_GRUPO, SB1.B1_COD "
	cQuery := ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'PRODUT', .F., .T.)},"Selecionado Produtos...")
//-----------------------------------------------------------------------------------------------------------------------------
		
	DbSelectArea("PRODUT")
	Dbgotop()
	
//	msginfo(areturn[4])		
//	msginfo(tamanho)
//	msginfo(nTipo)
	
//	nMaxLin := If(aReturn[4]==1,80,68)	
    nMaxLin = 68
	nLin = 82
	GRUPO = ""
	
	Do While !("PRODUT")->(Eof())
		CONDI = ""
		if PRODUT->B1_CUSTAB<>0
			TabXStd = ((PRODUT->B1_CUSTD/PRODUT->B1_CUSTAB)-1)*100
			TabXMed = ((PRODUT->B2_CM1/PRODUT->B1_CUSTAB)-1)*100
		  else	
		  	TabXStd = 0
			TabXMed = 0
		endif
	    if (mv_par05=3) .and. (TabXStd<mv_par06)
			CONDI = "FORA"
	    Endif
	    if (mv_par05=4) .and. (TabXStd>(-1*mv_par06))
			CONDI = "FORA"
	    Endif
	    if CONDI <> "FORA"
			if PRODUT->B1_CUSTD<>0
				StdXMed = ((PRODUT->B2_CM1/PRODUT->B1_CUSTD)-1)*100
			  else	
				StdXMed = 0
			endif	
		    if nLin > nMaxLin
		       //Roda(,,Tamanho)    
		 	   @ nLin,000 PSAY __PrtFatLine()
			   nLin = Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		       nLin = 9
		    endif
			if PRODUT->B1_GRUPO <> GRUPO
				nLin := nLin + 1
		 	   @ nLin,000 PSAY __PrtFatLine()
				nLin := nLin + 1
				@ nLin,000 Psay " Grupo ---> "+Trim(PRODUT->B1_GRUPO)
				nLin := nLin + 1
				@ nLin,000 PSAY __PrtThinLine()
				nLin := nLin + 1
				GRUPO = PRODUT->B1_GRUPO
			endif
			@ nLin,005 Psay Trim(PRODUT->B1_COD)
			@ nLin,016 Psay Trim(PRODUT->B1_DESC)
			@ nLin,057 Psay Trim(PRODUT->B1_UM)
			@ nLin,060 Psay SubStr(PRODUT->B1_DATREF,7,2)+"/"+SubStr(PRODUT->B1_DATREF,5,2)+"/"+SubStr(PRODUT->B1_DATREF,1,4)
			@ nLin,071 Psay Transform(PRODUT->B1_CUSTAB,"@E 9,999.99")
			@ nLin,080 Psay Transform(PRODUT->B1_CUSTD,"@E 9,999.99")
			@ nLin,089 Psay Transform(TabXStd,"@E 9999.99")
			@ nLin,097 Psay Transform(PRODUT->B2_CM1,"@E 9,999.99")
			@ nLin,106 Psay Transform(TabXMed,"@E 9999.99")
			@ nLin,114 Psay Transform(StdXMed,"@E 9999.99")
			@ nLin,122 Psay PRODUT->B1_MCUSTD
			nLin = nLin + 1
		endif	
		PRODUT->(dbSkip())
	Enddo

	nLin := nLin + 1
	@ nLin,000 PSAY __PrtThinLine()
    dbSelectArea("PRODUT")
	dbCloseArea()
    
SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return