#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "PROTHEUS.CH"                                  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT092   บ Autor ณ Giane              บ Data ณ  12/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Clientes com Filtros                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RFAT092
	Local aArea := GetArea()
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Relat๓rio de Clientes com Filtros"
	Local cPict          := ""
	Local titulo         := "Relatorio de Clientes com Filtros"
	Local nLin           := 80    
	Local cQuery         := ""

	Local Cabec1         := ""
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd           := {}        
	Local cPerg          := "RFAT092"
	Local cOrder         := "" 
	Local dData          := ctod('') 
	Local aConf          := {}
	Local lGerente       := .f.
	Local lVendedor      := .f.    
	Local cGrpAcesso     := ""

	// oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT092" , __cUserID )

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RFAT092" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RFAT092" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cAlias       := "SA1" 

	//=========== Regra de Confidencialidade =====================================  
	aConf := U_ChkConfig(__cUserId)
	cGrpAcesso:= aConf[1]   

	If Empty(cGrpAcesso)  
		MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","Aten็ใo!") 
		RestArea( aArea )
		Return 
	Endif 

	//============================================================================	

	if !Pergunte(cPerg)
		return
	Endif

	lGerente := aConf[2] 
	lVendedor := aConf[4]    

	If MV_PAR26 <> 1
		wnrel := SetPrint(cAlias,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.f.) 
		If nLAstKey == 27
			Return
		Endif
	Endif

	cAlias := "XSA1"	

	cQuery := "SELECT DISTINCT "
	cQuery += "  A1_SATIV1 , A1_COD , A1_LOJA , A1_NREDUZ, A1_DATAI , A1_CGC    , A1_INSCR, A1_VEND, SA3.A3_NREDUZ AS NOMREPR, "
	cQuery += "  A1_VENDINT, XSA3.A3_NREDUZ AS NOMVENDI, A1_ULTCOM, A1_ULTVIS, A1_END   , A1_BAIRRO, A1_COD_MUN, A1_GRPVEN,  "
	cQuery += "  ACY.ACY_DESCRI, A1_MUN    , A1_EST , A1_CEP, A1_FAX, A1_ATIVO, ACY_GRPSUP, ACY_XDESC, "   
	cQuery += "  (SELECT MAX(SUA.UA_EMISSAO) "                                                                              
	cQuery += "   FROM " + RetSqlName("SUA") + " SUA "      
	cQuery += "   WHERE "
	cQuery += "     SUA.UA_CLIENTE = SA1.A1_COD AND SUA.UA_LOJA = SA1.A1_LOJA AND SUA.UA_FILIAL = '" + xFilial("SUA") + "' "
	cQuery += "     AND SUA.D_E_L_E_T_ = ' ' ) AS ULTCOTACAO "
	cQuery += "FROM " + RetSqlName("SA1") + " SA1 "   
	cQuery += "  LEFT JOIN " + RetSqlName("ACY") + " ACY ON "  
	cQuery += "    ACY.ACY_FILIAL = '" + xFilial("ACY") + "' AND "
	cQuery += "    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
	cQuery += "    ACY.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " SA3 ON "  
	cQuery += "    SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND "
	cQuery += "    SA3.A3_COD = SA1.A1_VEND AND "   
	cQuery += "    SA3.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " XSA3 ON "  
	cQuery += "    XSA3.A3_FILIAL = '" + xFilial("SA3") + "' AND "
	cQuery += "    XSA3.A3_COD = SA1.A1_VENDINT AND "   
	cQuery += "    XSA3.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE "     
	cQuery += " A1_COD >= '" + MV_PAR02 + "' AND A1_COD <= '" + MV_PAR04 + "' AND "  
	cQuery += " A1_LOJA >= '" + MV_PAR03 + "' AND A1_LOJA <= '" + MV_PAR05 + "' AND "
	cQuery += " A1_SATIV1 >= '" + MV_PAR08 + "' AND A1_SATIV1 <= '" + MV_PAR09 + "' AND "
	cQuery += " A1_VEND >= '" + MV_PAR10 + "' AND A1_VEND <= '" + MV_PAR11 + "' AND "
	cQuery += " A1_VENDINT >= '" + MV_PAR12 + "' AND A1_VENDINT <= '" + MV_PAR13 + "' AND "
	cQuery += " A1_GRPVEN >= '" + MV_PAR14 + "' AND A1_GRPVEN <= '" + MV_PAR15 + "' AND "   
	If lGerente .or. lVendedor
		cQuery += " A1_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + " AND "
	endif               
	If !empty(MV_PAR16) .and. !empty(MV_PAR17)
		cQuery += " A1_DATAI >= '" + DTOS(MV_PAR16) + "' AND A1_DATAI <= '" + DTOS(MV_PAR17) + "' AND " 
	Endif
	If !empty(MV_PAR18) .and. upper(MV_PAR18) != "ZZ"
		cQuery += " A1_EST = '" + upper(MV_PAR18) + "' AND "
	Endif   
	IF (!EMPTY(MV_PAR27) .AND. MV_PAR28 == 'ZZZZZZ') .OR. (!EMPTY(MV_PAR27) .AND. MV_PAR28 <> 'ZZZZZZ')
		cQuery += " ACY.ACY_GRPSUP >= '" + MV_PAR27 + "' AND ACY.ACY_GRPSUP <= '" + MV_PAR28 + "' AND  "
	ENDIF	  
	cQuery += " A1_COD_MUN >= '" + MV_PAR19 + "' AND A1_COD_MUN <= '" + MV_PAR20 + "' AND "
	cQuery += " A1_CEP >= '" + MV_PAR21 + "' AND A1_CEP <= '" + MV_PAR22 + "' AND "
	If MV_PAR23 == 2 //nao listar clientes inativos   
		cQuery += " A1_ATIVO = '1' AND "
	Endif
	cQuery += " SA1.D_E_L_E_T_ = ' ' "  

	If MV_PAR06 > 0
		//LISTAR SOMENTE OS CLIENTES QUE NAO POSSUEM MOVIMENTO DE COMPRA A MAIS DE ... DIAS
		dData := (dDataBase - MV_PAR06) 

		/*cQuery += " AND NOT EXITS "
		cQuery += "  ( SELECT SF2.F2_EMISSAO FROM " + RetSqlName("SF2") + " SF2 "
		cQuery += "    WHERE SF2.F2_EMISSAO >= '" + DTOS(dData) + "' AND "
		cQuery += "    SF2.F2_CLIENTE = SA1.A1_COD AND SDF.F2_LOJA = SA1.A1_LOJA AND "
		cQuery += "    SF2.D_E_L_E_T_ = ' ' ) "  
		*/
		cQuery += " AND SA1.A1_ULTCOM <= '" + dtos(dData) + "' "
	Endif

	If !empty(MV_PAR07)    
		cQuery += " AND SA1.A1_ULTCOM > '" + dtos(MV_PAR07) + "' "
	Endif

	//monta o order by  
	If MV_PAR01 == 1 //agrupar por GRUPO vendas   
		cOrder := " ORDER BY A1_GRPVEN, "  
	ElseiF MV_PAR01 == 2               
		cOrder := " ORDER BY A1_VEND, "   
	Else
		cOrder := " ORDER BY A1_SATIV1, "   
	Endif              
	if MV_PAR25 == 1   
		cOrder += "A1_NREDUZ "
	Else
		cOrder += "A1_DATAI, A1_NREDUZ "
	Endif

	cQuery += cOrder

	cQuery := ChangeQuery(cQuery)

	MsgRun("Selecionando registros, aguarde...","Relat๓rio Clientes com Filtro", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })    

	dbSelectArea(cAlias)  
	DbGotop()     

	If MV_PAR26 == 2 

		If MV_PAR24 == 2
			Cabec1 := "Cliente                        Municipio         UF  Dt.Cadastro  Ult.Cota็ใo  Ult.Compra  Ult.Visita Representante/             Contato                         DDD/Fone       Email"
			If MV_PAR01 == 1
				Cabec2 := "                                                                                                      Segto.Vendas"
			Else 
				Cabec2 := "                                                                                                      Grupo Vendas"        
			Endif
		Endif

		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cAlias)

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)  

	Else 
		//EXPORTAR PARA EXCEL    
		MsgRun("Processando relat๓rio em Excel, aguarde...","Relat๓rio Clientes com Filtro",{|| CliExcel()}  )
	Endif

	(cAlias)->(DbCloseArea())

	RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  04/03/10   บฑฑ
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
	Local cSegVend := "" 
	Local cRepres  := ""   
	Local cGrupVen := ""   
	Local cCondicao:= ""  
	Local cSubTit  := ""
	Local nTot := 0

	DbSelectArea("SX5")
	DbSetOrder(1)

	dbSelectArea(cAlias) 
	SetRegua(RecCount()) 

	dbGoTop()
	While !EOF()    

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		cDescr := ""           
		If SX5->(DbSeek(xFilial("SX5")+"T3"+(cAlias)->A1_SATIV1) )
			cDescr:= SX5->(X5DESCRI())
		Endif          	        

		If MV_PAR01 == 1 
			cCondicao := (cAlias)->A1_GRPVEN <> cGrupVen  
			cSubTit   := "Grupo Vendas => " + (cAlias)->A1_GRPVEN + space(02) + (cAlias)->ACY_DESCRI	      
		ElseIf MV_PAR01 == 2
			cCondicao := (cAlias)->A1_VEND <> cRepres 
			cSubTit   := "Representante => " + (cAlias)->A1_VEND + space(02) + (cAlias)->NOMREPR            
		Else
			cCondicao := (cAlias)->A1_SATIV1 <> cSegVend  
			cSubTit   := "Segmento Vendas => " + (cAlias)->A1_SATIV1 + space(02) +  cDescr  		        
		Endif   


		If MV_PAR24 == 1 
			//layout Completo   

			if nTot > 0 .and. cCondicao //(cAlias)->A1_GRPVEN <> cGrupVen
				@nLin,020 PSAY "Total de Clientes => " + strzero(nTot,3)
				nLin:= nLin + 2  
				nTot := 0
			endif        

			If nLin > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 6
			Endif 	   	   

			If cCondicao .or. (nLin == 6)  
				If nLin > 62
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 6
				Endif 
				@nLin,000 PSAY cSubTit      

				If MV_PAR01 == 1    
					cGrupVen := (cAlias)->A1_GRPVEN
				ElseIf MV_PAR01 == 2 
					cRepres  := (cAlias)->A1_VEND 
				Else
					cSegVend := (cAlias)->A1_SATIV1  
				Endif
				nLin++	        
				@nLin,000 PSAY replicate('-',70)	         
				nLin++   	         
			Endif   


			@nLin,000 PSAY "Cliente: " + (cAlias)->A1_COD + space(01) + (cAlias)->A1_LOJA + space(01) + ALLTRIM( (cAlias)->A1_NREDUZ )
			@nLin,042 PSAY "Dt.Cadastro: " 
			@nLin,055 PSAY STOD( (cAlias)->A1_DATAI )
			@nLin,065 PSAY "CNPJ: " + ALLTRIM( (cAlias)->A1_CGC )
			@nLin,093 PSAY "I.E: " + ALLTRIM( (cAlias)->A1_INSCR )
			If MV_PAR01 == 2	 
				@nLin,117 PSAY "Segto. Vendas: " + ALLTRIM(cDescr )	   
			Else 
				@nLin,117 PSAY "Representante: " + ALLTRIM( (cAlias)->NOMREPR )
			Endif
			@nLin,173 PSAY "Vend.Interno: " + ALLTRIM( (cAlias)->NOMVENDI )    
			@nLin,215 PSAY IIF( (cAlias)->A1_ATIVO == '1', 'Ativo','Inativo')  
			nLin++     
			if MV_PAR01 <> 01
				@nLin,000 PSAY "Grp.Vend: " + (cAlias)->ACY_DESCRI
			Else  
				@nLin,000 PSAY "Seg.Vend: " + LEFT(cDescr,30 )	      
			Endif
			@nLin,042 PSAY "Ult.Cota็ใo: " 
			@nLin,055 PSAY STOD( (cAlias)->ULTCOTACAO )
			@nLin,065 PSAY "Ult.Compra: " 
			@nLin,077 PSAY STOD( (cAlias)->A1_ULTCOM )
			@nLin,093 PSAY Strzero ( (dDataBase - STOD((cAlias)->A1_ULTCOM)), 5) +  " Dias Sem Mov." 	   

			nCont := U_fContatos((cAlias)->A1_COD ,(cAlias)->A1_LOJA)


			@nLin,117 PSAY "Contato: "    
			if nCont > 0
				@nLin,126 PSAY ALLTRIM( XCON->U5_CONTAT  )
			endif   
			@nLin,173 PSAY "Contato: "    
			if nCont > 1 	
				XCON->(DbSkip())
				@nLin,182 PSAY  ALLTRIM( XCON->U5_CONTAT )
			Endif   

			nLin++
			@nLin,000 PSAY "Endere็o: " + LEFT( (cAlias)->A1_END ,50)
			@nLin,065 PSAY "Bairro: " + LEFT( (cAlias)->A1_BAIRRO,30 )
			@nLin,117 PSAY "DDD/Fone: "                                 
			if nCont > 0 
				XCON->(DbGotop())
				@nLin,127 PSAY ALLTRIM(XCON->U5_DDD) + SPACE(02) + ALLTRIM(XCON->U5_FCOM1)
			endif
			@nLin,173 PSAY "DDD/Fone: "   
			if nCont > 1 	
				XCON->(DbSkip())
				@nLin,183 PSAY ALLTRIM(XCON->U5_DDD) + SPACE(02) + ALLTRIM(XCON->U5_FCOM1)
			Endif 

			nLin++
			@nLin,000 PSAY "Municipio: " + ALLTRIM( (cAlias)->A1_MUN )
			@nLin,042 PSAY "Cep: " + ALLTRIM( (cAlias)->A1_CEP )
			@nLin,065 PSAY "UF: " + ALLTRIM( (cAlias)->A1_EST )
			@nLin,073 PSAY "Fax: " + (cAlias)->A1_FAX   
			@nLin,093 PSAY "Ult.Visita: " 
			@nLin,105 PSAY STOD( (cAlias)->A1_ULTVIS )	   
			@nLin,117 PSAY "Email: "  
			if nCont > 0 
				XCON->(DbGotop())
				@nLin,124 PSAY ALLTRIM( XCON->U5_EMAIL )
			endif      
			@nLin,173 PSAY "Email: "   
			if nCont > 1 	
				XCON->(DbSkip())
				@nLin,180 PSAY ALLTRIM( XCON->U5_EMAIL )
			Endif             

			nLin:= nLin + 2   

		Else
			//LAYOUT REDUZIDO

			If nLin > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
				nLin := 8
			Endif 

			If nTot > 0 .and. cCondicao 
				nLin++
				@nLin,020 PSAY "Total de Clientes => " + strzero(nTot,3)
				nTot := 0
				nLin := nLin + 2
			Else	          
				if nLin > 8; nLin++; endif		   
			Endif

			If cCondicao .or. (nLin == 8)  
				If nLin > 62
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin:= 8 
				Endif 
				@nLin,000 PSAY  cSubTit    
				If MV_PAR01 == 1    
					cGrupVen := (cAlias)->A1_GRPVEN
				ElseIf MV_PAR01 == 2 
					cRepres  := (cAlias)->A1_VEND 
				Else
					cSegVend := (cAlias)->A1_SATIV1  
				Endif

				nLin:=nLin+2
			Endif  

			@nLin,000 Psay (cAlias)->A1_COD + space(01) + (cAlias)->A1_LOJA + space(02) + ALLTRIM( (cAlias)->A1_NREDUZ )
			@nLin,031 PSAY ALLTRIM( (cAlias)->A1_MUN )  
			@nLin,049 PSAY ALLTRIM( (cAlias)->A1_EST ) 
			@nLin,055 PSAY STOD( (cAlias)->A1_DATAI ) 
			@nLin,068 PSAY STOD( (cAlias)->ULTCOTACAO ) 
			@nLin,080 PSAY STOD( (cAlias)->A1_ULTCOM )  
			@nLin,092 PSAY STOD( (cAlias)->A1_ULTVIS )
			@nLin,102 PSAY ALLTRIM( (cAlias)->NOMREPR )  

			nCont := U_fContatos((cAlias)->A1_COD ,(cAlias)->A1_LOJA)	      

			if nCont > 0
				@nLin,129 PSAY ALLTRIM( XCON->U5_CONTAT  )
				@nLin,161 PSAY ALLTRIM(XCON->U5_DDD) + SPACE(02) + ALLTRIM(XCON->U5_FCOM1) 
				@nLin,176 PSAY ALLTRIM( XCON->U5_EMAIL )	      
			endif   

			nLin++         
			@nLin,080 PSAY STRZERO( (dDatabase - STOD((cAlias)->A1_ULTCOM )),5) + " Dias"   

			If MV_PAR01 <> 1  
				@nLin,102 PSAY LEFT( (cAlias)->ACY_DESCRI,25 )  
			Else  
				@nLin,102 PSAY LEFT(cDescr,25)
			Endif

			if nCont > 1
				XCON->(DbSkip())

				@nLin,129 PSAY ALLTRIM( XCON->U5_CONTAT  )
				@nLin,161 PSAY ALLTRIM(XCON->U5_DDD) + SPACE(02) + ALLTRIM(XCON->U5_FCOM1) 
				@nLin,176 PSAY ALLTRIM( XCON->U5_EMAIL )	      
			endif 
			nLin++	   
		Endif	

		nTot++
		dbSkip() 
	EndDo

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

	If Select("XCON") > 0
		XCON->( dbCloseArea() )
	EndIf  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaExcelบAutor  ณGiane               บ Data ณ  20/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o arquivo excel com todos os registros referente aos  บฑฑ
ฑฑบ          ณparametros digitados pelo usuแrio.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CliExcel()  

	Local nHandle   := 0
	Local cArquivo  := CriaTrab(,.F.) 
	Local cDirDocs  := MsDocPath()  
	Local cPath     := AllTrim(GetTempPath())    
	Local cDescr
	Local aCabec := {}
	Local cBuffer 
	Local nQtdReg
	Local cSegVend := "" 
	Local cRepres := "" 
	Local nCont := 0
	Local nX := 0

	cArquivo += ".CSV"

	nHandle := FCreate(cDirDocs + "\" + cArquivo)

	If nHandle == -1
		MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema") 
		Return
	EndIf

	DbSelectArea("SX5")
	DbSetOrder(1)

	DbSelectArea(cAlias)
	COUNT TO nQtdReg                       
	ProcRegua(nQtdReg)
	dbGotop()               

	If MV_PAR01 == 1  
		Titulo := "Relatorio de Clientes por Grupo de Vendas" 
		If MV_PAR24 == 1 
			Acabec := {"Grupo Superior","Descri็ใo","Grupo Vendas","Descri็ใo","Cliente","Loja","Nome Fantasia","CNPJ","I.Estadual","Endereco","Bairro","Municipio","UF","Cep","Dt.Cadastro",;     
			"Segmento Vendas","Representante","Vendedor Interno","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Fax","Situacao","Ult.Cota็ใo","Ult.Compra","Dias Sem Mov.","Ult.Visita"} 
			Titulo += " - Completo"

		Else 
			Titulo += " - Reduzido"  
			Acabec := {"Grupo Superior","Descri็ใo","Cliente","Loja","Nome Fantasia","Municipio","UF","Segmento Vendas","Representante","Dt.Cadastro",;
			"Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Ult.Cota็ใo","Ult.Compra","Dias Sem Mov.","Ult.Visita"} 
		endif       


	Elseif MV_PAR01 == 2
		Titulo := "Relatorio de Clientes por Representante"
		If MV_PAR24 == 1 
			Acabec := {"Vendedor","Cliente","Loja","Nome Fantasia","CNPJ","I.Estadual","Endereco","Bairro","Municipio","UF","Cep","Situacao","Dt.Cadastro",;                
			"Grupo Vendas","Segmento Vendas","Vendedor Interno","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Fax", "Ult.Cota็ใo","Ult.Compra","Dias Sem Mov.", "Ult.Visita"} 
			Titulo += " - Completo" 
		Else  
			Titulo += " - Reduzido"  
			Acabec := {"Representante","Cliente","Loja","Nome Fantasia","Municipio","UF","Grupo Vendas","Segmento Vendas","Dt.Cadastro",;
			"Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Ult.Cota็ใo","Ult.Compra","Dias Sem Mov.","Ult.Visita"}            

		endif          
	Else
		Titulo := "Relatorio de Clientes por Segmento de Vendas" 
		If MV_PAR24 == 1 
			Acabec := {"Grupo Superior","Descri็ใo","Seg.Vendas","Descri็ใo","Cliente","Loja","Nome Fantasia","CNPJ","I.Estadual","Endereco","Bairro","Municipio","UF","Cep",;      
			"Grupo Vendas","Representante","Vendedor Interno","Dt.Cadastro","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Fax","Situacao",;
			"Ult.Cota็ใo","Ult.Compra","Dias Sem Mov.","Ult.Visita"} 
			Titulo += " - Completo"

		Else 

			Titulo += " - Reduzido"  
			Acabec := {"Grupo Superior","Descri็ใo","Seg.Vendas","Descri็ใo","Cliente","Loja","Nome Fantasia","Municipio","UF","Dt.Cadastro","Grupo Vendas","Representante","Contato",;
			"DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Contato","DDD/Fone","Email","Ult.Cota็ใo","Ult.Compra","Dias Sem Mov.","Ult.Visita"}         
		endif    
	Endif 

	FWrite(nHandle, Titulo) //imprime titulo do relatorio
	FWrite(nHandle, CRLF)
	FWrite(nHandle, CRLF) 

	cBuffer := "" 
	//imprime o cabecalho
	For nx := 1 To Len(aCabec)
		If nx == Len(aCabec)
			cBuffer += aCabec[nx]
		Else
			cBuffer += aCabec[nx] + ";"
		EndIf
	Next nx

	FWrite(nHandle, cBuffer)
	FWrite(nHandle, CRLF)   

	dbGoTop()
	While !EOF()        

		cDescr := ""           
		If SX5->(DbSeek(xFilial("SX5")+"T3"+(cAlias)->A1_SATIV1) )
			cDescr:= SX5->(X5DESCRI())
		Endif

		nCont := U_fContatos((cAlias)->A1_COD ,(cAlias)->A1_LOJA)	           

		If MV_PAR24 == 1 
			//layout Completo 
			If MV_PAR01 == 1 //agrupa por grupo vendas  
				cBuffer :=  '="' + (cAlias)->ACY_GRPSUP +'"'  + ";" + (cAlias)->ACY_XDESC  + ";"          
				cBuffer +=  '="' + (cAlias)->A1_GRPVEN +'"'  + ";" + (cAlias)->ACY_DESCRI  + ";" 
			Elseif MV_PAR01 == 2 
				cBuffer :=  (cAlias)->NOMREPR + ";"  //+ (cAlias)->A1_VEND + '"' + ";" + (cAlias)->NOMREPR + ";" 
			Else
				cBuffer :=  '="' + (cAlias)->ACY_GRPSUP +'"'  + ";" + (cAlias)->ACY_XDESC  + ";"       
				cBuffer +=  '="' + (cAlias)->A1_SATIV1 +'"'  + ";" + cDescr  + ";"       
			Endif 

			cBuffer +=  '="' + (cAlias)->A1_COD + '"' +  ";" 
			cBuffer +=  '="' + (cAlias)->A1_LOJA + '"' + ";" 
			cBuffer +=  '="' + (cAlias)->A1_NREDUZ + '"' + ";"          

			cBuffer += '="' + (cAlias)->A1_CGC + '"'  + ";" 
			cBuffer += '="' + (cAlias)->A1_INSCR + '"' + ";"  
			cBuffer += (cAlias)->A1_END + ";"
			cBuffer += (cAlias)->A1_BAIRRO + ";" 
			cBuffer += (cAlias)->A1_MUN + ";"
			cBuffer += (cAlias)->A1_EST + ";" 
			cBuffer += (cAlias)->A1_CEP + ";"         

			If MV_PAR01 == 1 
				cBuffer += dtoc( STOD((cAlias)->A1_DATAI) ) + ";"  
				cBuffer += cDescr + ";" 
				cBuffer += (cAlias)->NOMREPR + ";"    
			ElseIf MV_PAR01 == 2      
				cBuffer +=  IIF( (cAlias)->A1_ATIVO == '1', 'Ativo','Inativo')   + ";"         
				cBuffer += dtoc( STOD((cAlias)->A1_DATAI) ) + ";"  
				cBuffer += (cAlias)->ACY_DESCRI + ";"           
				cBuffer += cDescr + ";"               
			Else
				cBuffer += (cAlias)->ACY_DESCRI + ";" 
				cBuffer += (cAlias)->NOMREPR + ";"           
			Endif                                    

			cBuffer += (cAlias)->NOMVENDI + ";"                  
			if MV_PAR01 == 3
				cBuffer += dtoc( STOD((cAlias)->A1_DATAI) ) + ";"  
			endif   	   
			if nCont > 0
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) +  ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL )	+ ";"     
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif        
			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;"  
			endif 

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;"  
			endif 

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;"  
			endif 

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;"  
			endif 

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;"  
			endif 

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;"  
			endif 

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;"  
			endif 

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;"  
			endif 

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;"  
			endif 


			cBuffer += '="' + (cAlias)->A1_FAX + '"' + ";"    
			if MV_PAR01 != 2
				cBuffer +=  IIF( (cAlias)->A1_ATIVO == '1', 'Ativo','Inativo')   + ";" 
			endif         
			cBuffer += DTOC( stod((cAlias)->ULTCOTACAO) ) + ";" 
			cBuffer += DTOC( stod((cAlias)->A1_ULTCOM) ) + ";"  
			cBuffer += STR( (dDatabase - STOD((cAlias)->A1_ULTCOM )),5) + ";"     
			cBuffer += DTOC( stod((cAlias)->A1_ULTVIS) ) + ";"        
		Else   

			If MV_PAR01 == 1 //agrupa por grupo vendas  
				cBuffer :=  '="' + (cAlias)->A1_GRPVEN +'"'  + ";" + (cAlias)->ACY_DESCRI  + ";" 
			Elseif MV_PAR01 == 2 
				cBuffer :=  (cAlias)->NOMREPR + ";"  //(cAlias)->A1_VEND + '"' + ";" +
			Else
				cBuffer :=  '="' + (cAlias)->A1_SATIV1 +'"'  + ";" + cDescr  + ";"       
			Endif 

			cBuffer +=  '="' + (cAlias)->A1_COD + '"' +  ";" 
			cBuffer +=  '="' + (cAlias)->A1_LOJA + '"' + ";" 
			cBuffer +=  '="' + (cAlias)->A1_NREDUZ + '"' + ";"        
			cBuffer += (cAlias)->A1_MUN + ";"
			cBuffer += (cAlias)->A1_EST + ";"      

			If MV_PAR01 == 1
				cBuffer += cDescr + ";" 
				cBuffer += (cAlias)->NOMREPR + ";"   
				cBuffer += dtoc( STOD((cAlias)->A1_DATAI) ) + ";"              
			ElseIf MV_PAR01 == 2
				cBuffer += (cAlias)->ACY_DESCRI + ";"           
				cBuffer += cDescr + ";" 
				cBuffer += dtoc( STOD((cAlias)->A1_DATAI) ) + ";"                       
			Else      
				cBuffer += dtoc( STOD((cAlias)->A1_DATAI) ) + ";"  
				cBuffer += (cAlias)->ACY_DESCRI + ";" 
				cBuffer += (cAlias)->NOMREPR + ";"           
			Endif        

			if nCont > 0
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) + SPACE(02) + ALLTRIM(XCON->U5_FCOM1) +  ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL )	+ ";"     
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif        

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif   

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif   

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif   

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif   

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif   

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif   

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif   

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif   

			if nCont > 1
				XCON->(DbSkip())	                      
				cBuffer +=  ALLTRIM( XCON->U5_CONTAT  ) + ";"
				cBuffer +=  ALLTRIM(XCON->U5_DDD) +  SPACE(02) +  ALLTRIM(XCON->U5_FCOM1) + ";"
				cBuffer +=  ALLTRIM( XCON->U5_EMAIL ) + ";"	      
			else
				cBuffer += " ;  ;  ;  ;  ;  ;  ;  ;  ;  ;  ;" 
			endif   

			cBuffer += DTOC( stod((cAlias)->ULTCOTACAO) ) + ";" 
			cBuffer += DTOC( stod((cAlias)->A1_ULTCOM) ) + ";" 
			cBuffer += STR( (dDatabase - STOD((cAlias)->A1_ULTCOM )),5) + ";"  
			cBuffer += DTOC( stod((cAlias)->A1_ULTVIS) ) + ";"  

		Endif   

		FWrite(nHandle, cBuffer)  //imprime a linha completa do Item
		FWrite(nHandle, CRLF) //caso mude o cliente e a loja, pula uma linha em branco   

		Dbskip()
	Enddo

	FClose(nHandle)

	If Select("XCON") > 0
		XCON->( dbCloseArea() )
	EndIf  

	// copia o arquivo do servidor para o remote
	CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath + cArquivo)
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfContatos บ Autor ณ Giane              บ Data ณ  16/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Retorna os dois primeiros contatos cadastrados para o cli- บฑฑ
ฑฑบ          ณ ente que esta sendo impresso no relatorio.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function fContatos(cCliente, cLoja) 
	Local cSql := ""  
	Local nContato := 0

	If Select("XCON") > 0
		XCON->( dbCloseArea() )
	EndIf    

	cSql := "SELECT SU5.U5_CONTAT, SU5.U5_DDD, SU5.U5_FCOM1, SU5.U5_EMAIL " 
	cSql += "FROM "
	cSql += "  " + RetSqlName("SU5") + " SU5 JOIN " + RetSqlName("AC8") + " AC8 ON "
	cSql += "    SU5.U5_FILIAL  = '" + xFilial("SU5") + "'    AND "
	cSql += "    SU5.D_E_L_E_T_ = ' '    AND "
	cSql += "    AC8.AC8_FILIAL = '" + xFilial("SU5") + "'    AND "
	cSql += "    AC8.D_E_L_E_T_ = ' '    AND "
	cSql += "    SU5.U5_CODCONT = AC8.AC8_CODCON "
	cSql += "WHERE "
	cSql += "	 AC8.AC8_ENTIDA = 'SA1' "
	cSql += "  AND AC8.AC8_CODENT = '" + cCliente + cLoja + "' " 
	cSql += "  AND ROWNUM < 11"    

	cSql := ChangeQuery(cSql)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"XCON",.T.,.F.)

	dbSelectArea("XCON")     
	Count to nContato 
	DbGotop()

	DbSelectArea(cAlias)

Return(nContato)
