#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT200   º Autor ³ Giane              º Data ³  05/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Consultas Especificas/Jucesp,Sintegra/Rec.Federalº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFAT200

	Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2     := "de acordo com os parametros informados pelo usuario."
	Local cDesc3     := "Relatório de Consultas Periódicas"
	Local cPict      := ""
	Local nLin       := 80     
	Local cPerg      := 'RFAT200'   
	Local cQuery     := ""
	Local Cabec1     := ""
	Local Cabec2   	 := ""
	Local imprime    := .T.
	Local aOrd       := {}    
	Local cEntid     := ""

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT200" , __cUserID )

	Private titulo       := "Relatório de Consultas Periódicas"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 80
	Private tamanho      := "M"
	Private nomeprog     := "RFAT200" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFAT200" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cAlias := "XCON"  

	If !Pergunte(cPerg)
		Return
	Endif   

	if MV_PAR01 == 1
		cEntid := "Cliente       "   
	Elseif MV_PAR01 == 2
		cEntid := "Fornecedor    "
	Else 
		cEntid := "Transportadora"
	Endif	  

	Cabec1 := cEntid + space(20) + "Consulta  Razão Social                                      Dt.Consulta  Validade  Prazo  Status"  
	//      "Transportadora                    Consulta  Razão Social                                      Dt.Consulta  Validade  Prazo  Status" 
	//         999999 99 12345678901234567890  Rec.Federal 12345678901234567890123456789012345678901234567890   99/99/99  99/99/99  99999  Inativo  
	//         12345678901234567890123456789012345678901234567890123456789012345678901234567801234567890123456789012345678901234567890123456789012
	//                  1         2         3         4         5         6         7         8         9         10        11       12        13

	if MV_PAR01 == 1
		cQuery := "SELECT "
		cQuery += "  SA1.A1_COD CODIGO, SA1.A1_LOJA LOJA, SA1.A1_NREDUZ NREDUZ, SA1.A1_RZSOCRF RZSOCRF, SA1.A1_CONSRF CONSRF, SA1.A1_VALIDRF VALIDRF, SA1.A1_STATRF STATRF,  "     
		cQuery += "  SA1.A1_RZSOCJ RZSOCJ , SA1.A1_CONSJ CONSJ, SA1.A1_VALIDJ VALIDJ, SA1.A1_STATJ STATJ, "  
		cQuery += "  SA1.A1_RZSOCSI RZSOCSI, SA1.A1_CONSSI CONSSI, SA1.A1_VALIDSI VALIDSI, SA1.A1_STATSI STATSI "
		cQuery += "FROM " + RetSQLName( "SA1" ) + " SA1 "  
		cQuery += "WHERE SA1.A1_FILIAL  = '" + xFilial( "SA1" ) + "' "     
		cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " 
		cQuery += "   AND SA1.A1_COD BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR04 + "' "
		cQuery += "   AND SA1.A1_LOJA BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR05 + "' "	
		cQuery += "ORDER BY A1_COD "
	Elseif MV_PAR01 == 2 
		cQuery := "SELECT "
		cQuery += "  SA2.A2_COD CODIGO, SA2.A2_LOJA LOJA, SA2.A2_NREDUZ NREDUZ, SA2.A2_RZSOCRF RZSOCRF, SA2.A2_CONSRF CONSRF, SA2.A2_VALIDRF VALIDRF, SA2.A2_STATRF STATRF,  "     
		cQuery += "  SA2.A2_RZSOCJ RZSOCJ, SA2.A2_CONSJ CONSJ, SA2.A2_VALIDJ VALIDJ, SA2.A2_STATJ STATJ, "  
		cQuery += "  SA2.A2_RZSOCSI RZSOCSI, SA2.A2_CONSSI CONSSI, SA2.A2_VALIDSI VALIDSI, SA2.A2_STATSI STATSI "
		cQuery += "FROM " + RetSQLName( "SA2" ) + " SA2 "  
		cQuery += "WHERE SA2.A2_FILIAL  = '" + xFilial( "SA2" ) + "' "     
		cQuery += "   AND SA2.D_E_L_E_T_ = ' ' "   
		cQuery += "   AND SA2.A2_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR08 + "' "
		cQuery += "   AND SA2.A2_LOJA BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR09 + "' "		
		cQuery += "ORDER BY A2_COD "
	Else 
		cQuery := "SELECT "
		cQuery += "  SA4.A4_COD CODIGO, ' ' LOJA, RPAD(SA4.A4_NREDUZ,20) NREDUZ, SA4.A4_RZSOCRF RZSOCRF, SA4.A4_CONSRF CONSRF, SA4.A4_VALIDRF VALIDRF, SA4.A4_STATRF STATRF,  "     
		cQuery += "  SA4.A4_RZSOCJ RZSOCJ, SA4.A4_CONSJ CONSJ, SA4.A4_VALIDJ VALIDJ, SA4.A4_STATJ STATJ, "  
		cQuery += "  SA4.A4_RZSOCSI RZSOCSI, SA4.A4_CONSSI CONSSI, SA4.A4_VALIDSI VALIDSI, SA4.A4_STATSI STATSI "
		cQuery += "FROM " + RetSQLName( "SA4" ) + " SA4 "  
		cQuery += "WHERE SA4.A4_FILIAL  = '" + xFilial( "SA4" ) + "' "     
		cQuery += "   AND SA4.D_E_L_E_T_ = ' ' "  
		cQuery += "   AND SA4.A4_COD BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR11 + "' "
		cQuery += "ORDER BY A4_COD "
	Endif 

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	TcSetField(cAlias,'CONSRF','D',8,0)
	TcSetField(cAlias,'VALIDRF','D',8,0) 
	TcSetField(cAlias,'CONSJ','D',8,0)
	TcSetField(cAlias,'VALIDJ','D',8,0)
	TcSetField(cAlias,'CONSSI','D',8,0)
	TcSetField(cAlias,'VALIDSI','D',8,0) 

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

	dbSelectArea(cAlias)

	SetRegua(RecCount())

	dbGoTop() 

	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif  

		If nLin > 59 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8  
		Endif     

		@ nLin,000 PSAY (cAlias)->CODIGO
		@ nLin,007 PSAY (cAlias)->LOJA
		@ nLin,010 PSAY (cAlias)->NREDUZ
		@ nLin,032 PSAY 'Rec.Federal'
		@ nLin,044 PSAY (cAlias)->RZSOCRF
		@ nLin,098 PSAY (cAlias)->CONSRF
		@ nLin,108 PSAY (cAlias)->VALIDRF
		If !empty((cAlias)->VALIDRF)
			@ nLin,118 PSAY ( (cAlias)->VALIDRF - dDataBase ) PICTURE "99999" 
		Endif
		@ nLin,125 PSAY iif( alltrim((cAlias)->STATRF) == 'A', 'Ativo  ', iif( alltrim((cAlias)->STATRF) == 'I' ,'Inativo','       ' ) )

		nLin := nLin + 1 
		@ nLin,032 PSAY 'S.Nacional '
		@ nLin,044 PSAY (cAlias)->RZSOCJ
		@ nLin,098 PSAY (cAlias)->CONSJ
		@ nLin,108 PSAY (cAlias)->VALIDJ  
		If !empty((cAlias)->VALIDJ)	
			@ nLin,118 PSAY ( (cAlias)->VALIDJ - dDataBase ) PICTURE "99999"   
		Endif   		
		@ nLin,125 PSAY iif( alltrim((cAlias)->STATJ) == 'A', 'Ativo  ', iif( alltrim((cAlias)->STATJ) == 'I' ,'Inativo','       ' ) )	

		nLin := nLin + 1 
		@ nLin,032 PSAY 'Sintegra   '
		@ nLin,044 PSAY (cAlias)->RZSOCSI
		@ nLin,098 PSAY (cAlias)->CONSSI
		@ nLin,108 PSAY (cAlias)->VALIDSI 
		If !empty((cAlias)->VALIDSI)	
			@ nLin,118 PSAY ( (cAlias)->VALIDSI - dDataBase ) PICTURE "99999"    
		Endif   		
		@ nLin,125 PSAY iif( alltrim((cAlias)->STATSI) == 'A', 'Ativo  ', iif( alltrim((cAlias)->STATSI) == 'I' ,'Inativo','       ' ) )	

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