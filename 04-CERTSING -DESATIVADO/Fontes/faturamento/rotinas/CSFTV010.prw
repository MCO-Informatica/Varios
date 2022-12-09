#Include 'Protheus.ch'
#Include 'TbiConn.ch'
#Include 'RwMake.ch'
#Include 'Font.ch'
#Include 'Colors.ch'

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFTV010 |Autor: |David Alves dos Santos |Data: |21/12/2016   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Funcao de validacao do campo AD1_CNPJ.                        |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |CS  = Certisign.                                              |
//|do codigo    |FT  = Modulo faturamento SIGAFAT.                             |
//|fonte.       |V   = Validacao.                                              |
//|             |010 = Numero sequencial.                                      |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFTV010()
	
	Local lVldCnpj := .T.
	Local lRet     := .T.
	Local nTamCGC  := TamSX3("AD1_CNPJ")[1]	//-- Captura o tamanho do campo A1_CGC.
	Local cQuery   := ""
	Local cTmpSA1  := GetNextAlias()			//-- Tabela temporaria SA1.
	Local cTmpSUS  := GetNextAlias()			//-- Tabela temporaria SUS.
	Local cRet     := ""
	
	If Empty(FWFldGet("AD1_CNPJ"))
		//-- Limpa as informacoes do cliente caso tenha preenchido.	
		If !Empty(FWFldGet("AD1_TPRECE"))
			FWFldPut("AD1_TPRECE", "")
			FWFldPut("AD1_PROSPE", "")
			FWFldPut("AD1_LOJPRO", "")
			FWFldPut("AD1_NOMPRO", "")
			FWFldPut("AD1_CODCLI", "")
			FWFldPut("AD1_NOMCLI", "")
			FWFldPut("AD1_XGRPVE", "")
			FWFldPut("AD1_XDESGV", "")
		EndIf
		Return .T.
	EndIf
	
	If Len(AllTrim(FWFldGet("AD1_CNPJ"))) >= 11
		//-- Verifica se o CPF/CNPJ eh valido.
		lVldCnpj := CGC(AllTrim(FWFldGet("AD1_CNPJ")))
	Else
		lVldCnpj := .F.
	EndIf
	
	If lVldCnpj
		
		//-- Montagem da query.
		cQuery := " SELECT a1_filial, " 
		cQuery += "        a1_cod, " 
		cQuery += "        a1_loja, "
		cQuery += "        a1_nome, " 
		cQuery += "        a1_cgc " 
		cQuery += " FROM   sa1010 "  
		cQuery += " WHERE  a1_filial = '" + xFilial("SA1") + "' " 
		cQuery += "        AND a1_cgc = '" + AllTrim(FWFldGet("AD1_CNPJ")) + "' " 
		cQuery += "        AND d_e_l_e_t_ = ' ' "	
	
		//-- Verifica se a tabela esta aberta.
		If Select(cTmpSA1) > 0
			cTmpSA1->(DbCloseArea())				
		EndIf
			
		//-- Execucao da query.
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmpSA1,.F.,.T.)
		
		//-- Se retornar valor, pesquisa na tabela de clientes.
		//-- Caso contrario na tabela de prospect.
		If !Empty((cTmpSA1)->(A1_COD))
			
			//-- Gatilha as informacoes do cliente
			FWFldPut("AD1_CODCLI", (cTmpSA1)->A1_COD,,,,.T.)
			FWFldPut("AD1_NOMCLI", Left((cTmpSA1)->(A1_NOME), TamSX3("AD1_NOMCLI")[1]))
			FWFldPut("AD1_LOJCLI", (cTmpSA1)->A1_LOJA,,,,.T.)
			FWFldPut("AD1_XGRPVE", Posicione( "SA1", 3, xFilial( "SA1" ) + (cTmpSA1)->(A1_CGC), "A1_GRPVEN" ),,,,.T.)			
			FWFldPut("AD1_XDESGV", Posicione( "ACY", 1, xFilial( "ACY" ) + FWFldGet("AD1_XGRPVE"), "ACY_DESCRI" ),,,,.T.)
			FWFldPut("AD1_TPRECE", "2")
			
			//-- Limpa as informacoes do propect caso tenha preenchido.
			If !Empty(FWFldGet("AD1_PROSPE"))
				FWFldPut("AD1_PROSPE", CriaVar("AD1_PROSPE"))
				FWFldPut("AD1_NOMPRO", CriaVar("AD1_NOMPRO"))
			EndIf 
			
		Else
			
			//-- Montagem da query.
			cQuery := " SELECT us_filial, " 
			cQuery += "        us_cod, "
			cQuery += "        us_loja, " 
			cQuery += "        us_nome "
			cQuery += " FROM   sus010 "
			cQuery += " WHERE  us_filial = '" + xFilial("SUS") + "' " 
			cQuery += "        AND us_cgc = '" + AllTrim(M->AD1_CNPJ) + "' "
			cQuery += "        AND us_msblql = '2' " 
			cQuery += "        AND d_e_l_e_t_ = ' ' "
			
			//-- Verifica se a tabela esta aberta.
			If Select(cTmpSUS) > 0
				cTmpSUS->(DbCloseArea())				
			EndIf
			
			//-- Execucao da query.
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmpSUS,.F.,.T.)
				
			If !Empty((cTmpSUS)->(US_COD))
				//-- Gatilha informacoes do Prospect.
				FWFldPut("AD1_PROSPE", (cTmpSUS)->(US_COD),,,,.T.)
				FWFldPut("AD1_LOJPRO", (cTmpSUS)->(US_LOJA),,,,.T.)
				FWFldPut("AD1_NOMPRO", Left((cTmpSUS)->(US_NOME), TamSX3("AD1_NOMPRO")[1]),,,,.T.)
				FWFldPut("AD1_TPRECE", "1")
				//-- Limpa as informacoes do cliente caso tenha preenchido.
				If !Empty(FWFldGet("AD1_PROSPE"))
					FWFldPut("AD1_CODCLI", CriaVar("AD1_CODCLI"))
					FWFldPut("AD1_NOMCLI", CriaVar("AD1_NOMCLI"))
					FWFldPut("AD1_XGRPVE", CriaVar("AD1_XGRPVE"))
					FWFldPut("AD1_XDESGV", CriaVar("AD1_XDESGV"))
				EndIf
			Else
				//-- Verifica se o campo CNPJ nao esta vazio.
				If !Empty(FWFldGet("AD1_CNPJ"))
					//-- Rotina para cadastrar o novo prospect.
					FTM010CAD()
				EndIf
			EndIf	
				
		EndIf
		 
	Else
		
		//-- Mensagem de erro referente ao CNPJ.
		MsgStop("CNPJ incorreto. Favor informar um CNPJ válido!", "ERRO-001 | CSFTV010")
		lRet := .F.
		 
	EndIf

Return( lRet )


//+-------------+----------+-------+-----------------------+------+------------+
//|Programa:    |FTM010CAD |Autor: |David Alves dos Santos |Data: |20/12/2016  |
//|-------------+----------+-------+-----------------------+------+------------|
//|Descricao:   |Montagem da tela de cadastro caso o registro nao exista nas   |
//|             |tabelas SA1 ou SUS.                                           |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function FTM010CAD()

	Local oGroupPros
	Local oSayCod
	Local oGetCod
	Local cGetCod    := GetSx8Num('SUS','US_COD')
	Local oSayLoj
	Local oGetLoj
	Local cGetLoj    := "01"
	Local oSayCnpj
	Local oGetCnpj
	Local cGetCnpj   := FWFldGet("AD1_CNPJ")
	Local oSayFJ
	Local oComboFJ
	Local nComboFJ   := Iif(Len(cGetCnpj) == 14, 2, 1)
	Local oSayNom
	Local oGetNom
	Local cGetNom    := Space(TamSX3("US_NOME")[1])
	Local oSayEnd
	Local oGetEnd
	Local cGetEnd    := Space(TamSX3("US_END")[1])
	Local oSayEst
	Local oGetEst
	Local cGetEst    := Space(TamSX3("US_EST")[1])
	Local oSayMun
	Local oGetMun
	Local cGetMun    := Space(TamSX3("US_MUN")[1])
	Local oSayTip
	Local oComboTip
	Local nComboTip  := 1
	Local oSayDDD
	Local oGetDDD
	Local cGetDDD    := Space(TamSX3("US_DDD")[1])
	Local oGetTel
	Local cGetTel    := Space(TamSX3("US_TEL")[1])
	Local oSayGrpV
	Local oGetGrpV
	Local cGetGrpV   := Space(TamSX3("US_GRPVEN")[1])
	Local oSayTel
	Local oSBtnCanc
	Local oSBtnOK
	
	//-- Lista de opcoes.
	Local aItensTip  := {" ", "F=Cons.Final", "L=Produtor Rural", "R=Revendedor", "S=Solidario", "X=Exportacao"}
	Local aItensFJ   := {"F=Fisica", "J=Juridica"}
	Local aDados     := {}
	Local lRet       := .T.
	
	Static oDlg
	
	//-- Montagem da tela de cadastro.
  	DEFINE MSDIALOG oDlg TITLE "Inclusao de Prospect" FROM 000, 000  TO 370, 500 PIXEL
		
		//-- Grupo de componentes.
    	@ 004, 004 GROUP oGroupPros TO 165, 244 PROMPT " Inclusão de Prospect: " OF oDlg PIXEL
    	
    	//-- Campos.
    	@ 022, 038 MSGET oGetCod  VAR cGetCod  SIZE 060, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_COD"  	) WHEN .F. PIXEL
    	@ 022, 155 MSGET oGetLoj  VAR cGetLoj  SIZE 072, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_LOJA" 	)          PIXEL
    	@ 042, 038 MSGET oGetCnpj VAR cGetCnpj SIZE 060, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_CGC"  	) WHEN .F. PIXEL
    	@ 062, 038 MSGET oGetNom  VAR cGetNom  SIZE 196, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_NOME" 	)          PIXEL
    	@ 082, 038 MSGET oGetEnd  VAR cGetEnd  SIZE 143, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_END"  	)          PIXEL
    	@ 082, 211 MSGET oGetEst  VAR cGetEst  SIZE 022, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_EST"  	) F3 "12"  PIXEL
    	@ 102, 038 MSGET oGetMun  VAR cGetMun  SIZE 060, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_MUN"  	)          PIXEL
    	@ 122, 038 MSGET oGetDDD  VAR cGetDDD  SIZE 060, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_DDD"  	)          PIXEL
    	@ 122, 155 MSGET oGetTel  VAR cGetTel  SIZE 072, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_TEL"  	)          PIXEL
    	@ 142, 038 MSGET oGetGrpV VAR cGetGrpV SIZE 060, 010 OF oDlg PICTURE PesqPict( "SUS" ,"US_GRPVEN"	) F3 "ACY" PIXEL
    	
    	//-- Rotulos.
    	@ 022, 010 SAY oSayCod  PROMPT "*Código:"        SIZE 019, 007 OF oDlg COLOR CLR_HBLUE PIXEL
    	@ 022, 117 SAY oSayLoj  PROMPT "*Loja:"          SIZE 013, 007 OF oDlg COLOR CLR_HBLUE PIXEL
    	@ 042, 010 SAY oSayCnpj PROMPT "*CNPJ:"          SIZE 016, 007 OF oDlg COLOR CLR_HBLUE PIXEL
    	@ 082, 010 SAY oSayEnd  PROMPT "Endereço:"       SIZE 026, 007 OF oDlg                 PIXEL
    	@ 062, 010 SAY oSayNom  PROMPT "*Nome:"          SIZE 025, 007 OF oDlg COLOR CLR_HBLUE PIXEL
    	@ 082, 188 SAY oSayEst  PROMPT "*Estado:"        SIZE 021, 007 OF oDlg COLOR CLR_HBLUE PIXEL
    	@ 102, 010 SAY oSayMun  PROMPT "Municipio:"      SIZE 026, 007 OF oDlg                 PIXEL
    	@ 102, 117 SAY oSayTip  PROMPT "Tipo:"           SIZE 017, 007 OF oDlg                 PIXEL
    	@ 122, 010 SAY oSayDDD  PROMPT "*DDD:"           SIZE 025, 007 OF oDlg COLOR CLR_HBLUE PIXEL
    	@ 122, 117 SAY oSayTel  PROMPT "*Telefone:"      SIZE 028, 007 OF oDlg COLOR CLR_HBLUE PIXEL
    	@ 042, 117 SAY oSayFJ   PROMPT "*Fisica/Jurid.:" SIZE 029, 007 OF oDlg COLOR CLR_HBLUE PIXEL
    	@ 142, 010 SAY oSayGrpV PROMPT "*Grp.Ven.:"      SIZE 029, 007 OF oDlg COLOR CLR_HBLUE PIXEL
    	
    	//-- Combos.
    	@ 102, 155 MSCOMBOBOX oComboTip VAR nComboTip ITEMS aItensTip SIZE 072, 010 OF oDlg PIXEL
    	@ 042, 155 MSCOMBOBOX oComboFJ  VAR nComboFJ  ITEMS aItensFJ  SIZE 072, 010 OF oDlg PIXEL
    	
    	//-- Dados para ser enviados para o Execauto.
    	//aDados := {cGetCod, cGetLoj, cGetCnpj, cGetNom, cGetEnd, cGetEst, cGetMun, cGetDDD, cGetTel, nComboTip, nComboFJ}
		    	
    	//-- Botoes.
		DEFINE SBUTTON oSBtnOK   FROM 170, 165 TYPE 01 OF oDlg ENABLE ACTION {|| lRet := FTM010Prc( {	cGetCod   ,;
																													cGetLoj   ,;
																													cGetNom   ,;
																													nComboTip ,;
																													cGetEnd   ,;
																													cGetMun   ,;
																													cGetEst   ,;
																													cGetDDD   ,;
																													cGetTel   ,;
																													nComboFJ  ,;
																													cGetCnpj  ,;
																													cGetGrpV  }), Iif(lRet,oDlg:End(),"")}
    	DEFINE SBUTTON oSBtnCanc FROM 170, 218 TYPE 02 OF oDlg ENABLE ACTION {|| oDlg:End()}
    	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return


//+-------------+----------+-------+-----------------------+------+------------+
//|Programa:    |FTM010Prc |Autor: |David Alves dos Santos |Data: |22/12/2016  |
//|-------------+----------+-------+-----------------------+------+------------|
//|Descricao:   |Processa a inclusao do Prospect na tabela SUS.                |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function FTM010Prc(aDados)

	Local aVetor        := {}
	Local lRet          := .T.
	
	PRIVATE lMsErroAuto := .F.
			
	//-- Tratamento de erro de campos obrigatorios no cadatro de prospect.
	Do Case
  		Case Empty(aDados[1])	//-- Codigo
  			lRet := .F.
     		MsgStop("Campo CODIGO vazio, Favor informar um conteúdo válido!","ERRO-002 | CSFTV010")
     	Case Empty(aDados[2])	//-- Loja
     		lRet := .F.
     		MsgStop("Campo LOJA vazio, Favor informar um conteúdo válido!","ERRO-003 | CSFTV010")
     	Case Empty(aDados[3])	//-- Nome
     		lRet := .F.
     		MsgStop("Campo NOME vazio, Favor informar um conteúdo válido!","ERRO-004 | CSFTV010")
     	Case Empty(aDados[7])	//-- Estado
     		lRet := .F.
     		MsgStop("Campo ESTADO vazio, Favor informar um conteúdo válido!","ERRO-005 | CSFTV010")
     	Case Empty(aDados[8])	//-- DDD
     		lRet := .F.
     		MsgStop("Campo DDD vazio, Favor informar um conteúdo válido!","ERRO-006 | CSFTV010")
     	Case Empty(aDados[9])	//-- Telefone
     		lRet := .F.
     		MsgStop("Campo TELEFONE vazio, Favor informar um conteúdo válido!","ERRO-007 | CSFTV010")
     	Case Empty(aDados[10])	//-- Fisica/Juridica
     		lRet := .F.
     		MsgStop("Campo FISICA/JURID vazio, Favor informar um conteúdo válido!","ERRO-008 | CSFTV010")
     	Case Empty(aDados[11])	//-- CNPJ
     		lRet := .F.
     		MsgStop("Campo CNPJ vazio, Favor informar um conteúdo válido!","ERRO-009 | CSFTV010")
     	Case Empty(aDados[12])	//-- Grupo de Venda
     		lRet := .F.
     		MsgStop("Campo Grp.Ven. vazio, Favor informar um conteúdo válido!","ERRO-010 | CSFTV010")
	EndCase	
 	
	//-- Se nao houver erro segue o processo.
	If lRet		
		//+----------------------------------------------+
		//| Realiza o tratamento da variaveis numericas. |
		//+----------------------------------------------+
		aDados[10] := Iif(aDados[10] == 1, "F", "J")
		Do Case
	  		Case aDados[4] == Iif(ValType(aDados[4])=="N",1,"1")
     			aDados[4] := "F"
     		Case aDados[4] == Iif(ValType(aDados[4])=="N",2,"2")
	     		aDados[4] := "L"
     		Case aDados[4] == Iif(ValType(aDados[4])=="N",3,"3")
	     		aDados[4] := "R"
     		Case aDados[4] == Iif(ValType(aDados[4])=="N",4,"4")
	     		aDados[4] := "S"
     		Case aDados[4] == Iif(ValType(aDados[4])=="N",5,"5")
	     		aDados[4] := "X"
		EndCase
		
		BEGIN TRANSACTION
			//-- Grava o Prospect na tabela SUS.
			RecLock("SUS", .T.)
				SUS->US_COD    := aDados[1]
				SUS->US_LOJA   := aDados[2]
				SUS->US_NOME   := aDados[3]
				SUS->US_NREDUZ := aDados[3]
				SUS->US_TIPO   := aDados[4]
				SUS->US_END    := aDados[5]
				SUS->US_MUN    := aDados[6]
				SUS->US_EST    := aDados[7]
				SUS->US_DDD    := aDados[8]
				SUS->US_TEL    := aDados[9]
				SUS->US_PESSOA := aDados[10]
				SUS->US_CGC    := aDados[11]
				SUS->US_GRPVEN := aDados[12]
				SUS->US_MSBLQL := "2"
			SUS->(MsUnLock())
		END TRANSACTION
		
		//-- Gatilha informacoes do Prospect.
		FWFldPut("AD1_PROSPE", aDados[1])
		FWFldPut("AD1_LOJPRO", aDados[2])
		FWFldPut("AD1_NOMPRO", aDados[3])
		FWFldPut("AD1_TPRECE", "1")
		
		//-- Confirma numeracao automatica e apresenta mensagem de sucesso.
		ConfirmSX8()
		MsgInfo("Registro incluido com sucesso!")
		
	EndIf
			
Return( lRet )


//+-------------+----------+-------+-----------------------+------+------------+
//|Programa:    |FTV10CGC  |Autor: |David Alves dos Santos |Data: |01/02/2017  |
//|-------------+----------+-------+-----------------------+------+------------|
//|Descricao:   |Rotina para verificar se o CNPJ informado na oportunidade     |
//|             |existe. O retorno é .T. pois ainda não deve-se bloquear.      |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function FTV10CGC()
	
	Local lRet        := .T.
	Local lCNPJ       := .F.
	Local cSQL        := ''
	Local cTRB        := ''
	Local cAD1_NROPOR := ''
	Local cCampo      := ''
	Local cAux        := ''
	Local cTexto      := ''
	Local aArea       := {}
	Local cDescPro    := ''
	
	aArea  := GetArea()
	cCampo := ReadVar()
	
	If 'AD1_CNPJ' $ cCampo .And. !Empty( AllTrim(FWFldGet("AD1_CNPJ")) )
		If !Empty( cCampo )
			cAux := &( cCampo )
			If Len( cAux ) == 14
				lCNPJ := .T.
				cAux := Left( cAux, 8 ) + '%'
			Endif
			cSQL := "SELECT AD1_NROPOR, AD1_DTINI, AD1_CNPJ, AD1_CODPRO, AD1_STAGE, AD1_DESCRI "
			cSQL += "FROM   " + RetSqlName("AD1") + " AD1 "
			cSQL += "WHERE  AD1_FILIAL = " + ValToSql( xFilial( "AD1" ) ) + " "
			If lCNPJ
				cSQL += "       AND AD1_CNPJ LIKE " + ValToSql( cAux ) + " "
			Else
				cSQL += "       AND AD1_CNPJ = " + ValToSql( cAux ) + " "
			Endif
			cSQL += "       AND SUBSTR(AD1_STAGE,1,3) NOT IN ('005','006') "
			cSQL += "       AND AD1.D_E_L_E_T_ = ' ' "
			cSQL += "ORDER  BY AD1_NROPOR "
			cSQL := ChangeQuery( cSQL )
			cTRB := GetNextAlias()
			dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
			If (cTRB)->( .NOT. BOF() ) .And. (cTRB)->( .NOT. EOF() )
				While (cTRB)->( .NOT. EOF() )
					cDescPro := Posicione( "SX5", 1, xFilial( "SX5" ) + "Z3" + (cTRB)->(AD1_CODPRO), "X5_DESCRI" )					
					cDtIni   := SubStr((cTRB)->(AD1_DTINI),7,2) + "/" + SubStr((cTRB)->(AD1_DTINI),5,2) + "/" + SubStr((cTRB)->(AD1_DTINI),1,4)
					cAD1_NROPOR += 	' Oportunidade: '           + (cTRB)->(AD1_NROPOR) + Chr(13) + Chr(10) +;
									' Desc.Oportunidade: '      + (cTRB)->(AD1_DESCRI) + Chr(13) + Chr(10) +;
									' Estagio: '                + (cTRB)->(AD1_STAGE)  + Chr(13) + Chr(10) +;
									' Produto Principal: '      + cDescPro             + Chr(13) + Chr(10) +;
									' Data de Abertura: '       + cDtIni               + Chr(13) + Chr(10) +;
									'========================================'         + Chr(13) + Chr(10)
					(cTRB)->( dbSkip() )
				End
				If lCNPJ
					cTexto := 'Abaixo Oportunidade(s) com este prefixo de CNPJ ' + Left(TransForm(&(cCampo),'@R 99.999.999/9999-99'),10) + Chr(13)+Chr(10)
				Else
					cTexto := 'Abaixo Oportunidade(s) com este CNPJ/CPF ' + &(cCampo) + Chr(13)+Chr(10)
				Endif
				lRet := FTV010Val(cTexto, cAD1_NROPOR)
			Endif
			(cTRB)->( dbCloseArea() )
		Endif
	Endif
	
	RestArea( aArea )
	
Return( lRet )


//+-------------+----------+-------+-----------------------+------+------------+
//|Programa:    |FTV010Val |Autor: |David Alves dos Santos |Data: |01/02/2017  |
//|-------------+----------+-------+-----------------------+------+------------|
//|Descricao:   |Monta a tela e lista as informacoes de oportunidades          |
//|             |utilizando o mesmo prefixo de CNPJ.                           |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function FTV010Val(cTitGrp, cDados)

	Local lRet := .T.
	
	//-- Declaracao de variaveis privadas.
	SetPrvt("oFontBold","oFontSize","oDlg1","oSay1","oSay2","oSay3","oGrp1","oMGet1","oBtn1","oBtn2")
	
	//-- Propriedades de fonts
	oFontBold  := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	oFontSize  := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
	//-- Janela
	oDlg1      := MSDialog():New( 082,227,519,756,"Aviso de Validação",,,.F.,,,,,,.T.,,,.T. )
	//-- Labels
	oSay1      := TSay():New( 008,004,{||"Identificamos que já existem registros de oportunidade para este cliente. "},oDlg1,,oFontBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
	oSay2      := TSay():New( 016,004,{||"Você deseja continuar a criação deste registro, antes de verificar se há"},oDlg1,,oFontBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
	oSay3      := TSay():New( 024,004,{||"duplicidade?"},oDlg1,,oFontBold,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
	//-- Grupo
	oGrp1      := TGroup():New( 044,004,188,256," " + cTitGrp + " ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//-- Campo Memo
	oMGet1     := TMultiGet():New( 060,012,{|| cDados },oGrp1,236,120,oFontSize,,CLR_BLUE,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
	//-- Botoes
	oBtn1      := TButton():New( 196,164,"Sim",oDlg1,{||lRet := .T., oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 196,218,"Não",oDlg1,{||lRet := .F., oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
	//-- Ativacao da tela.
	oDlg1:Activate(,,,.T.)

Return( lRet )