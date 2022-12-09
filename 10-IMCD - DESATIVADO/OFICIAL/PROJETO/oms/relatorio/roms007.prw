#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROMS007   º Autor ³ Giane              º Data ³  02/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Autorizacao de Pagamentos de Fretes                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ROMS007

	Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2     := "de acordo com os parametros informados pelo usuario."
	Local cDesc3     := "Autorização de Pagamentos de Fretes"
	Local cPict      := ""
	Local nLin       := 80     
	Local cPerg      := 'ROMS007'   
	Local cQuery     := ""
	Local Cabec1     := ""
	Local Cabec2   	 := ""
	Local imprime    := .T.
	Local aOrd       := {}  

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "ROMS007" , __cUserID )

	Private titulo       := "Autorização de Pagamentos de Fretes"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 80
	Private tamanho      := "P"
	Private nomeprog     := "ROMS007" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "ROMS007" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cAlias := "XFRE"  

	If !Pergunte(cPerg)
		Return
	Endif   

	cProduto := AllTrim( GetMv( "MV_MKPRFR1" ) )

	cQuery := "SELECT "
	cQuery += "  DA3.DA3_PLACA, SUM(SC7.C7_TOTAL) TOTALFRE "
	cQuery += "FROM " + RetSQLName( "SC7" ) + " SC7 "  
	cQuery += " JOIN " + RetSqlName("DAK") + " DAK ON "  
	cQuery += "  DAK.DAK_PEDFRE = SC7.C7_NUM " 
	cQuery += "  AND DAK.DAK_FILIAL = '" + xFilial( "DAK" ) + "' "  
	cQuery += "  AND DAK.D_E_L_E_T_ = ' ' "   
	cQuery += " JOIN " + RetSqlName("DA3") + " DA3 ON "  
	cQuery += "  DAK.DAK_CAMINH = DA3.DA3_COD " 
	cQuery += "  AND DA3.DA3_FILIAL = '" + xFilial( "DA3" ) + "' "  
	cQuery += "  AND DA3.D_E_L_E_T_ = ' ' "   
	cQuery += " JOIN " + RetSqlName("DUT") + " DUT ON "  
	cQuery += "  DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " 
	cQuery += "  AND DUT.DUT_FILIAL = '" + xFilial( "DUT" ) + "' "  
	cQuery += "  AND DUT.D_E_L_E_T_ = ' ' "   
	cQuery += "WHERE SC7.C7_FILIAL  = '" + xFilial( "SC7" ) + "' "
	cQuery += "   AND SC7.C7_PRODUTO = '"  + cProduto + "' "     
	cQuery += "   AND SC7.C7_EMISSAO = '" + dtos(MV_PAR01) + "' "   
	cQuery += "   AND SC7.C7_FORNECE = '" + MV_PAR03 + "' AND C7_LOJA = '" + MV_PAR04 + "' "      
	cQuery += "   AND DUT.DUT_CARGA = '" + STR(MV_PAR05,1) + "' "
	cQuery += "   AND SC7.D_E_L_E_T_ = ' ' " 
	cQuery += "GROUP BY DA3_PLACA "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	TcSetField(cAlias,'TOTALFRE','N',15,2)

	dbSelectArea(cAlias)  


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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)   

	(cAlias)->(DbCloseArea())
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/02/10   º±±
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
	Local nTotFre := 0

	dbSelectArea(cAlias)

	SetRegua(RecCount())

	dbGoTop() 

	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif  

		If nLin > 54 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6  
			fCabec(@nLin) 
		Endif     

		@ nLin,001 PSAY (cAlias)->DA3_PLACA  

		@ nLin,030 PSAY Transform((cAlias)->TOTALFRE, "@E 999,999,999,999.99" )

		nLin := nLin + 1 

		nTotFre += (cAlias)->TOTALFRE

		dbSkip()     

	EndDo

	@nLin,013 PSAY 'Total de Fretes  ' + Transform(nTotFre, "@E 999,999,999,999.99" ) 

	if nLin < 58 
		nLin := 58
	Else
		nLin++
	Endif	

	@nLin,005 PSAY "______________________________"     

	@nLin,041 PSAY "______________________________"             
	nLin++
	@nLin,015 PSAY "Comprador" 
	@nLin,051 PSAY "Diretor"             

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return   

Static Function fCabec(nLin) 
	Local aArea := GetArea()

	@nLin,000 PSAY SM0->M0_NOMECOM
	nLin++
	@nLin,000 PSAY "CNPJ: 45.725.009/0005-21"       
	@nLin,050 PSAY "I.E.: 286.153.122.115"  
	nLin++
	@nLin,000 PSAY "Av.Presidente Juscelino, 570/578"
	@nLin,050 PSAY "Cep : 09950-370"  
	nLin++
	@nLin,000 PSAY "Piraporinha - Diadema - SP"
	@nLin,050 PSAY "Email: IMCDBRASIL@IMCDBRASIL.COM.BR" 
	nLin++
	@nLin,000 PSAY "Fone: (11)4360-6400"
	@nLin,050 PSAY "www.imcdgroup.com"
	nLin++
	@nLin,000 PSAY replicate('-',80)

	nLin++

	DbSelectArea("SA2")
	DbSetOrder(1)
	if Dbseek(xFilial("SA2") +  MV_PAR03 + MV_PAR04 )
		@nLin,000 PSAY "Fornecedor: " +  SA2->A2_NOME
		nLin++
		@nLin,000 PSAY "CNPJ/CPF  : " + SA2->A2_CGC
		@nLin,050 PSAY "I.E.: " + SA2->A2_INSCR
		nLin++
		@nLin,000 PSAY "Endereco  : " + alltrim(SA2->A2_END) + " " + alltrim(SA2->A2_NR_END)
		@nLin,050 PSAY "Bairro : " + alltrim(SA2->A2_BAIRRO) 
		nLin++
		@nLin,000 PSAY "Cidade/UF : " + alltrim(SA2->A2_MUN) +  ' - ' + SA2->A2_EST
		@nLin,050 PSAY "Cep.: " + SA2->A2_CEP
		nLin++
		@nLin,000 PSAY "DDD/Fone  : "  + alltrim(SA2->A2_DDD) + '/'+ alltrim(SA2->A2_TEL)
		@nLin,050 PSAY "Fax : " + alltrim(SA2->A2_FAX)  
		nLin++
		@nLin,000 PSAY "Contato   : " + alltrim(SA2->A2_CONTATO)   
		nLin++
		@nLin,000 PSAY replicate('-',80)
		nLin++
	Endif

	nLin++
	@ nLin,000 PSAY "Descrição:  " + Posicione("SB1", 1, xFilial("SB1") + cProduto, "B1_DESC" ) 
	nLin+= 2 

	@nLin,000 PSAY "Placa Veículo" 
	@nLin,037 PSAY "Valor Frete"  

	@nLin,055 PSAY 'Tipo Carga: ' +  iif(MV_PAR05 == 1, 'Seca ','Granel')
	nLin++

	RestArea(aArea)
Return