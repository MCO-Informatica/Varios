#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREST004   บ Autor ณ Giane              บ Data ณ  23/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelatorio imprimi os produtos que nao possuem nenhuma conta บฑฑ
ฑฑบ          ณgem de inventario, para conferencia.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function REST004

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Itens nใo inventariados"
	Local cPict          := ""
	Local titulo         := "Itens nใo inventariados"
	Local nLin           := 80

	Local Cabec1         := "Produto         Descricao                                                             Tipo  UM Armaz Endereco          Qtde.Estoque"    
	// 012345678901234 123456789012345678901234567890123456789012345678901234567890123456789  99  99  99   123456789012345 999,999,999.99
	// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//          1         2         3         4         5         6         7         8         9         10        11        12        13

	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd := {}
	Local cPerg := "REST004"

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "REST004" , __cUserID )

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 132
	Private tamanho          := "M"
	Private nomeprog         := "REST004" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 15
	Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "REST004" // Coloque aqui o nome do arquivo usado para impressao em disco        

	Private cString := "SB2"     
	Private cAlias := "XSB2"

	dbSelectArea("SB2")
	dbSetOrder(1)   

	Pergunte(cPerg,.f.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	//nTipo := If(aReturn[4]==1,15,18)

	cQuery := "SELECT * FROM "
	cQuery +=    RetSqlName("SB2") + " SB2 "
	cQuery += "WHERE SB2.D_E_L_E_T_  = ' ' AND "
	cQuery += "   NOT EXISTS "
	cQuery += "   ( "
	cQuery += "   SELECT '*' FROM " 
	cQuery +=        RetSqlName("SB7") + " SB7 "
	cQuery += "   WHERE "
	cQuery += "      SB7.B7_FILIAL = '" + XFILIAL("SB7") + "' AND "
	cQuery += "      SB7.B7_COD = SB2.B2_COD AND "
	cQuery += "      SB7.B7_LOCAL = SB2.B2_LOCAL AND "
	cQuery += "      SB7.B7_CONTAGE <> '0  ' AND "
	cQuery += "      SB7.B7_DOC LIKE '" + MV_PAR01 + "%' AND   "  
	cQuery += "      SB7.B7_DATA = '" + DTOS(MV_PAR02) + "' AND  "
	cQuery += "      SB7.D_E_L_E_T_  = ' '        
	cQuery += "    )"   
	cQuery += "ORDER BY B2_FILIAL, B2_COD, B2_LOCAL, B2_LOCALIZ "

	cQuery := ChangeQuery(cQuery) 

	cAlias := "XSB2"
	If Select(cAlias) > 0                                   
		(cAlias)->(DbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)


	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

	(cAlias)->(DbCloseArea())
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  23/03/10   บฑฑ
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

	Titulo += " Inventario " + MV_PAR01 + " de " + DTOC(MV_PAR02)
	dbSelectArea(cAlias)

	SetRegua(RecCount())

	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 57 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin,000 PSAY (cAlias)->B2_COD
		@nLin,017 PSAY Posicione("SB1",1,xFilial("SB1")+(cAlias)->B2_COD,"B1_DESC")
		@nLin,088 PSAY Posicione("SB1",1,xFilial("SB1")+(cAlias)->B2_COD,"B1_TIPO") 
		@nLin,092 PSAY Posicione("SB1",1,xFilial("SB1")+(cAlias)->B2_COD,"B1_UM")
		@nLin,096 PSAY (cAlias)->B2_LOCAL
		@nLin,101 PSAY (cAlias)->B2_LOCALIZ 
		@nLin,117 PSAY Transform((cAlias)->B2_QATU,"@E 999,999,999.99")

		nLin := nLin + 1 

		dbSkip() 
	EndDo


	SET DEVICE TO SCREEN


	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return
