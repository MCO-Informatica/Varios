#INCLUDE "rwmake.ch" 
#INCLUDE "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณROMS006   บ Autor ณ Giane              บ Data ณ  15/03/11   บฑฑ                     
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Planejamento de Recebimentos                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni /                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ROMS006

	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "Planejamento de Recebimentos de Produtos"
	Local cPict        := ""
	Local titulo       := "Planejamento de Recebimentos de Produtos"
	Local nLin         := 80    
	Local cPerg        := 'ROMS006'                       
	Local Cabec1       := "Data     Produto         Descri็ใo                                                                   Quantidade  Fornecedor                   "
	// 99/99/99 123456789012345 1234567890123456789012345678901234567890123456789012345678901234567890  999,999,999.99  123456 99 12345678901234567890       
	// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        17
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd         := {} 
	Local cQuery       := ""      
	Local aAreaAnt     := GetArea()

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "ROMS006" , __cUserID )

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "ROMS006" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "ROMS006" 

	Private cString := "XREC"         

	if !Pergunte(cPerg)
		Return
	Endif     

	cString := "XREC"                                                                                                   
	If Select(cString) > 0
		(cString)->(DbCloseArea())
	EndIf

	cQuery := MontaQry()

	cQuery := ChangeQuery(cQuery) 

	MsgRun("Selecionando registros, aguarde...","Relat๓rio Planejamento de Recebimentos", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cString,.T.,.T.) })    

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)   

	If Select(cString) > 0
		(cString)->(DbCloseArea())
	EndIf

	RestArea(aAreaAnt)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaQry  บ Autor ณ Giane              บ Data ณ  23/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Monta query para imprimir relatorio                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni /                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaQry()  
	Local cQuery := ""   

	cQuery := "SELECT "    
	cQuery += "  SC7.C7_DATPRF DATA, SC7.C7_PRODUTO PRODUTO, SB1.B1_DESC DESCRICAO, (SC7.C7_QUANT - SC7.C7_QUJE) XQTD, SC7.C7_FORNECE FORNEC, SC7.C7_LOJA LOJA, SA2.A2_NREDUZ NREDUZ, '9' XTIPO " 
	cQuery += "FROM " 
	cQuery +=    RetSqlName("SC7") + " SC7 " 
	cQuery += "JOIN "
	cQuery +=    RetSqlName("SB1") + " SB1 ON "
	cQuery += "  SB1.B1_FILIAL = '" + xFilial("SB1") + "'  "  
	cQuery += "  AND SB1.B1_COD = SC7.C7_PRODUTO "
	cQuery += "  AND SB1.D_E_L_E_T_ = ' ' "   
	cQuery += "JOIN "
	cQuery +=    RetSqlName("SA2") + " SA2 ON "
	cQuery += "  SA2.A2_FILIAL = '" + xFilial("SA2") + "'  "  
	cQuery += "  AND SA2.A2_COD = SC7.C7_FORNECE "
	cQuery += "  AND SA2.A2_LOJA = SC7.C7_LOJA  AND SA2.D_E_L_E_T_ = ' ' "   
	cQuery += "WHERE "
	cQuery += "  SC7.C7_FILIAL = '" + xFilial("SC7") +  "' AND SC7.D_E_L_E_T_ = ' ' "    
	cQuery += "  AND SC7.C7_DATPRF BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	cQuery += "  AND SB1.B1_NACION = '2' "  //MERCADO INTERNO
	cQuery += "  AND SB1.B1_TIPCAR = '000001' " //granel  
	cQuery += "  AND SC7.C7_QUJE < SC7.C7_QUANT AND SC7.C7_RESIDUO <> 'S'  "
	cQuery += "  AND SC7.C7_ENCER <> 'E' "
	cQuery += "  AND SUBSTR(SC7.C7_ORIGEM,1,3) <> 'EIC' " //tirar os pedidos de produtos importados, pois o Darci ira lancar separado na rotina AOMS002()   

	cQuery += "UNION ALL "

	cQuery += "SELECT "
	cQuery += "  ZA9_DTENTR DATA, ZA9_PROD PRODUTO, ZA9_DESCR DESCRICAO, ZA9_QUANT XQTD, ZA9_FORNEC FORNEC, ZA9_LOJA LOJA, ZA9_NOMEF NREDUZ, ZA9_TIPO XTIPO " 
	cQuery += "FROM "
	cQuery +=    RetSqlName("ZA9") + " ZA9 " 
	cQuery += "WHERE "
	cQuery += "  ZA9.ZA9_FILIAL = '" + xFilial("ZA9") +  "' AND ZA9.D_E_L_E_T_ = ' ' "    
	cQuery += "  AND ZA9.ZA9_DTENTR BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "  
	cQuery += "ORDER BY XTIPO, DATA, PRODUTO, FORNEC, LOJA "  

	//memowrite('c:\ROMS006.sql',cquery)

Return cQuery

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  18/11/09   บฑฑ
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
	Local cTipo := ""   

	dbSelectArea(cString)

	While !eof()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif   

		If nLin > 63 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif 	

		cTipo := (cString)->XTIPO 
		if nLin > 8; nLin++; endif

		Do case
			Case cTipo == '1'
			@nLin, 000 PSAY 'IMPORTAวีES'
			Case cTipo == '2'
			@nLin, 000 PSAY 'RETORNO DE TERCEIROS'
			Case cTipo == '9'
			@nLin, 000 PSAY 'PEDIDOS DE COMPRA' 
		Endcase

		nLin++

		Do While !eof() .and. (cString)->XTIPO == cTipo 
			If nLin > 63 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif 		

			@nLin, 000 PSAY STOD((cString)->DATA)
			@nLin, 009 PSAY (cString)->PRODUTO
			@nLin, 025 PSAY (cString)->DESCRICAO
			@nLin, 097 PSAY Transform( (cString)->XQTD, "@E 999,999,999.99" )
			@nLin, 113 PSAY (cString)->FORNEC
			@nLin, 120 PSAY (cString)->LOJA
			@nLin, 123 PSAY (cString)->NREDUZ 

			nLin++
			dbSkip()  

		Enddo          

	Enddo

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return