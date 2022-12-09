#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT321   บ Autor ณ Giane              บ Data ณ  25/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Visitas                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RFAT321

	Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2     := "de acordo com os parametros informados pelo usuario."
	Local cDesc3     := "Relat๓rio de Visitas por Vendedor"
	Local cPict      := ""
	Local nLin       := 80     
	Local cPerg      := 'RFAT321'   
	Local cQuery     := ""
	Local Cabec1     := "Data     Hora  Cliente   Nome Fantasia        Assunto                    Apontada"
	//      99/99/99 99:99 123456 78 123457890123457890 123457890123457890123457890    Sim  
	//      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//               1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        2         21        220
	Local Cabec2   := ""
	Local imprime  := .T.
	Local aOrd     := {}  

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT321" , __cUserID )

	Private titulo       := "Relat๓rio de Visitas por Vendedor"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 80
	Private tamanho      := "P"
	Private nomeprog     := "RFAT321" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFAT321" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cAlias := "XVIS"  


	If !Pergunte(cPerg)
		Return
	Endif   

	cQuery := "SELECT DISTINCT "
	cQuery += "  AD7.AD7_VEND, AD7.AD7_DATA, AD7.AD7_HORA1, AD7.AD7_CODCLI, AD7.AD7_LOJA, SA1.A1_NREDUZ, AD7.AD7_TOPICO, "
	cQuery += "  CASE WHEN AD7.AD7_VENDAP <> ' ' THEN 'Sim' ELSE 'Nใo' END XSITUA "  
	cQuery += "FROM " + RetSQLName( "AD7" ) + " AD7 "        
	cQuery += "  JOIN " + RetSqlName("SA3") + " SA3 ON "
	cQuery += "    SA3.A3_FILIAL = '" + xFilial( "SA3" ) + "' "   
	cQuery += "    AND SA3.A3_COD = AD7.AD7_VEND "
	cQuery += "    AND SA3.D_E_L_E_T_ = ' ' "  
	cQuery += "  JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "    SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' "   
	cQuery += "    AND SA1.A1_COD = AD7.AD7_CODCLI AND SA1.A1_LOJA = AD7.AD7_LOJA "
	cQuery += "    AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "  WHERE AD7_FILIAL  = '" + xFilial( "AD7" ) + "' "
	cQuery += "    AND AD7.AD7_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery += "    AND AD7.AD7_DATA BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DTOS(MV_PAR02) + "' "   
	cQuery += "    AND SA3.A3_GRPVEN BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "   
	If MV_PAR07 == 1
		cQuery += "   AND AD7.AD7_VENDAP = ' ' "   //NAO foi apontada
	Elseif MV_PAR07 == 2 
		cQuery += "   AND AD7.AD7_VENDAP <> ' ' "   // foi apontada   
	Endif
	cQuery += "   AND AD7.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY AD7_VEND, AD7_DATA, AD7_HORA1 "


	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	TcSetField(cAlias,'AD7_DATA','D',8,0)

	dbSelectArea(cAlias)  

	If MV_PAR08 == 2
		MsgRun("Processando Relat๓rio de Visitas em excel, aguarde...","",{|| R321Excel() })
	Else

		wnrel := SetPrint(cAlias,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

		If nLastKey == 27
			(cAlias)->(DbCloseArea())
			Return
		Endif

		SetDefault(aReturn,cAlias)

		If nLastKey == 27
			(cAlias)->(DbCloseArea())
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)   

	Endif

	(cAlias)->(DbCloseArea())
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  01/02/10   บฑฑ
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
	Local cVendedor := ""

	dbSelectArea(cAlias)

	SetRegua(RecCount())

	dbGoTop() 

	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif  

		If nLin > 59 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif     

		@nLin,000 PSAY 'Vendedor: ' + AD7_VEND + SPACE(02) + Posicione("SA3",1,xFilial("SA3") + AD7_VEND, "A3_NREDUZ") 
		nLin += 2  

		cVendedor := AD7_VEND 

		Do While !eof() .and. AD7_VEND == cVendedor

			if nLin > 59 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8 
				@nLin,000 PSAY 'Vendedor: ' + AD7_VEND + SPACE(02) + Posicione("SA3",1,xFilial("SA3") + AD7_VEND, "A3_NREDUZ") 
				nLin += 2   			
			Endif     


			@ nLin,000   PSAY (cAlias)->AD7_DATA  
			@ nLin,009   PSAY (cAlias)->AD7_HORA1
			@ nLin,015   PSAY (cAlias)->AD7_CODCLI
			@ nLin,022   PSAY (cAlias)->AD7_LOJA
			@ nLin,025   PSAY (cAlias)->A1_NREDUZ
			@ nLin,047   PSAY (cAlias)->AD7_TOPICO	  
			@ nLin,078   PSAY (cAlias)->XSITUA
			nLin := nLin + 1 

			dbSkip()    
		Enddo    

		nLin++   

	EndDo

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณR321EXCEL Autor ณ                       ณ Data ณ04.02.2010ณ  ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณImprime relatorio na versao excel                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function R321EXCEL()
	Local aCabec := {}
	Local aItens := {} 
	Local cVendedor := ""                     

	aadd(aCabec, "Vendedor")
	aadd(aCabec, "Nome Vendedor")
	aadd(aCabec, "Data"  )
	aadd(aCabec, "Hora")
	aadd(aCabec, "Cliente" )
	aadd(aCabec, "Loja"  )
	aadd(aCabec, "Nome Fantasia" )  
	aadd(aCabec, "Assunto"  )
	aadd(aCabec, "Apontada"  )

	dbSelectArea(cAlias) 

	(cAlias)->(DbGotop())

	While !EOF()   

		cVendedor := (cAlias)->AD7_VEND
		Do While !eof() .and. (cAlias)->AD7_VEND  = cVendedor 
			aadd(aItens, { '="'+(cAlias)->AD7_VEND + '" '  ,  Posicione("SA3",1,xFilial("SA3") + (cAlias)->AD7_VEND, "A3_NREDUZ"),;
			(cAlias)->AD7_DATA   ,  (cAlias)->AD7_HORA1 ,;
			'="'+(cAlias)->AD7_CODCLI + '" ' ,  '="'+ (cAlias)->AD7_LOJA + '" ' ,;
			(cAlias)->A1_NREDUZ  ,  (cAlias)->AD7_TOPICO,;
			(cAlias)->XSITUA } )              
			Dbskip() 
		Enddo

		aadd(aItens, { } )

	Enddo

	If len(aItens) == 0            
		MsgInfo("Nใo existem dados a serem impressas, de acordo com os parโmetros informados!","Aten็ใo")
	Else  
		DlgToExcel({ {"ARRAY", titulo, aCabec, aItens} }) 
	Endif       


Return