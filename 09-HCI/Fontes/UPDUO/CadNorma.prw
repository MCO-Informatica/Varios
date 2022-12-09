#Include 'Protheus.ch'

User Function CadNorma()
	Local cFilter     := ""
	Local aCores      := {}
	Private cCadastro := 'Norma Técnica'
	Private cDelFunc  := '.T.'
	Private aRotina   := {}
	Private cAlias    := 'SZN'

	aAdd( aRotina, { 'Pesquisar'  , 'AxPesqui', 0, 1 } )
	aAdd( aRotina, { "Visualizar" , "AxVisual", 0, 2 })
	aAdd( aRotina, { 'Incluir'    , 'U_MntNorma(1)', 0, 3 } )
	aAdd( aRotina, { 'Alterar'    , 'U_MntNorma(2)', 0, 4 } )
	aAdd( aRotina, { 'Excluir'    , 'U_MntNorma(3)', 0, 5 } )

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTop()
	mBrowse(10,10,60,120,cAlias,,,,,, aCores,,,,,,,,cFilter)

Return Nil

/*
nOpc => 1 - InclusÃ£o
        2 - AlteraÃ§Ã£o
        3 - ExclusÃ£o
*/
User Function MntNorma(nOpc)

	Static oDlg

	Local oButton1
	Local oButton2

	Local oSay
	Local oGet

	Local oGet29
	Local oGet30
	Local oGet31
	Local oGet32
	Local oGet33
	Local oGet34

	Local oGet45
	Local oGet46
	Local oGet47
	Local oGet48
	Local oGet49

	Local oMultiGe

	local nZUVALOR

	Local lHasButton := .F.
	Local lNoButton  := .T.

	Local bChange := {}

	Private aOperacao := {"Inclusao","Alteracao","Exclusao"}

	Private oFolder1
	Private lMarker     := .T.

	Private aCabec := {}
	Private aColsEd := {}
	Private aColsEx := {}

	Private aCabeCa := {}
	Private aColCaEd := {}
	Private aColCaEx := {}

	Private aCabeTt := {}
	Private aColTtEd := {}
	Private aColTtEx := {}

	Private aCabeMp := {}
	Private aColMpEd := {}
	Private aColMpEx := {}

	Private aCabeTc := {}
	Private aColTcEd := {}
	Private aColTcEx := {}

	Private aCabeTs := {}
	Private aColTsEd := {}
	Private aColTsEx := {}

  /* ---Preencher Campos-- */
	Default cZNIDNORMA:= space(04)
	Default cZNNORMA  := space(20)
	Default nZNTRACAO1	:= 0
	Default nZNTRACAO2	:= 0
	Default nZNESCOA1	:= 0
	Default nZNESCOA2	:= 0
	Default nZNALONG1	:= 0
	Default nZNALONG2	:= 0
	Default nZNESTRIC1	:= 0
	Default nZNESTRIC2	:= 0
	Default nZNDUREZ11	:= 0
	Default nZNDUREZ12	:= 0
	Default nZNDUREZ21	:= 0
	Default nZNDUREZ22	:= 0
	Default mZNOBSALON	:= ""
	Default nZNFASE1	:= 0
	Default nZNFASE2	:= 0
	Default nZNFASE3	:= 0
	Default nZNMEDIA	:= 0
	Default nZNTEMP	:= 0
	if nOpc != 1 .and. !szn->(eof())
		cZNIDNORMA	:= SZN->ZN_IDNORMA
		cZNNORMA    := SZN->ZN_NORMA
		nZNTRACAO1	:= SZN->ZN_TRACAO1
		nZNTRACAO2	:= SZN->ZN_TRACAO2
		nZNESCOA1	:= SZN->ZN_ESCOA1
		nZNESCOA2	:= SZN->ZN_ESCOA2
		nZNALONG1	:= SZN->ZN_ALONG1
		nZNALONG2	:= SZN->ZN_ALONG2
		nZNESTRIC1	:= SZN->ZN_ESTRIC1
		nZNESTRIC2	:= SZN->ZN_ESTRIC2
		nZNDUREZ11	:= SZN->ZN_DUREZ11
		nZNDUREZ12	:= SZN->ZN_DUREZ12
		nZNDUREZ21	:= SZN->ZN_DUREZ21
		nZNDUREZ22	:= SZN->ZN_DUREZ22
		mZNOBSALON	:= SZN->ZN_OBSALON
		nZNFASE1	:= SZN->ZN_FASE1
		nZNFASE2	:= SZN->ZN_FASE2
		nZNFASE3	:= SZN->ZN_FASE3
		nZNMEDIA	:= SZN->ZN_MEDIA
		nZNTEMP		:= SZN->ZN_TEMP
	endif

	//X3Titulo()	X3_CAMPO		X3_PICTURE      	X3_TAMANHO	X3_DECIMAL	    X3_VALID	X3_USADO    X3_TIPO		X3_F3	X3_CONTEXT	X3_CBOX	X3_RELACAO	X3_WHEN
	Aadd(aCabec, {"Item"    ,"ZT_ITEM"   ,	"@!",           	    02,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"Simbolo" ,"ZT_SIMBOLO",	"@!",         		    02,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"Elemento","ZT_NOME"   ,	"@!",         		    15,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"% Min"   ,"ZT_MIN"    ,	"@E 99,999,999.99999",	16,         5,	        "",			"",	        "N",        "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"% Max"   ,"ZT_MAX"    ,	"@E 99,999,999.99999",	16,         5,	        "",			"",	        "N",        "",     "R",        "",     "",         ""})
	aColsEd := {"ZT_SIMBOLO","ZT_MIN","ZT_MAX"}

	dbSelectArea("SZT")
	cSql := "select ZT_ITEM, ZT_SIMBOLO, substr(x5_descri,1,15) ZT_NOME, ZT_MIN, ZT_MAX from "+RetSQLName("SZT")+" zt "
	cSql += "inner join "+RetSQLName("SX5")+" x5 on x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TR' and x5_chave = zt_simbolo and x5.d_e_l_e_t_ = ' '"
	cSql += "where zt_filial = '"+xFilial("SZT")+"' and zt_idnorma = '"+cZNIDNORMA+"' and zt.d_e_l_e_t_ = ' '"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	if (ctrb)->( Eof() )
		Aadd(aColsEx, { '01',space(02),space(15),0,0,.f. })
	else
		while !(ctrb)->( Eof() )
			Aadd(aColsEx, { (ctrb)->ZT_ITEM, (ctrb)->ZT_SIMBOLO, (ctrb)->ZT_NOME, (ctrb)->ZT_MIN, (ctrb)->ZT_MAX, .f. })
			(ctrb)->( DbSkip() )
		End
	endif
	(ctrb)->( DbCloseArea() )

	//X3Titulo()				X3_CAMPO	X3_PICTURE      	X3_TAMANHO	X3_DECIMAL	    X3_VALID	X3_USADO    X3_TIPO		X3_F3	X3_CONTEXT	X3_CBOX	X3_RELACAO	X3_WHEN
	Aadd(aCabeCa, {"Ele"      ,	"ZF_ELEMEN","@!",          	      02,   0,	"",	"",	"C",  "",     "R",        "",     "",         ""})
	Aadd(aCabeCa, {"Seq"      ,	"ZF_SEQUEN","@!",          	      02,   0,	"",	"",	"C",  "",     "R",        "",     "",         ""})
	Aadd(aCabeCa, {"Descrição",	"ZF_DESCR" ,"@!",      		      80,   0,	"",	"",	"C",  "",     "R",        "",     "",         ""})
	Aadd(aCabeCa, {"Valor"    ,	"ZU_VALOR" ,"@E 99,999,999.99999",16,	5,	"",	"",	"N",  "",     "R",        "",     "",         ""})
	aColCaEd := {"ZU_VALOR"}
  	/*
  	aadd(aColCaEx, { .f.,'001','P/ Cada Reducao de 0.001% do C% Adiciona-se 0.06% do Mg% ate o limite de',0 })
  	aadd(aColCaEx, { .f.,'002','P/ Cu%+Ni%+Cr%+Mo%<=1', })
  	aadd(aColCaEx, { .f.,'003','P/ Cr%+Mo%<=0.32%', })
  	aadd(aColCaEx, { .f.,'004','P/ Carbono Equivalente (CE%) Max',0 })
  	aadd(aColCaEx, { .f.,'005','P/ Cu%+Ni%+Cr%+V%+No%<=1%', })
  	aadd(aColCaEx, { .f.,'006','P/ Material de partida (CHAPA) C% Max 0,35%', })
  	aadd(aColCaEx, { .f.,'007','P/ Material de partida (BARRA) Si% Max 0,35% s/ Valor Minimo', })
  	aadd(aColCaEx, { .f.,'008','P/ Material de partida (BARRA) Mg% Max 1,35%', })
  	aadd(aColCaEx, { .f.,'009','P/ Corpo de Prova (CIRCULAR) sentido (TRANVERSAL) o Alongamento Minimo',0 })
  	aadd(aColCaEx, { .f.,'010','P/ Corpo de Prova (CIRCULAR) sentido (LONGITUDINAL) o Alongamento Minimo',0 })
  	aadd(aColCaEx, { .f.,'011','P/ Corpo de Prova (RETANGULAR) sentido (TRANVERSAL) o Alongamento Minimo',0 })
  	aadd(aColCaEx, { .f.,'012','P/ Corpo de Prova (RETANGULAR) sentido (LONGITUDINAL) o Alongamento Minimo',0 })
  	*/
	dbSelectArea("SZU")
	cSql := "select zf_elemen,zf_sequen,zf_descri,zf_limexc,zu_sequen,zu_valor from "+RetSQLName("SZF")+" zf "
	cSql += "left join "+RetSQLName("SZU")+" zu on zu_filial = '"+xFilial("SZU")+"' and zu_idnorma = '"+cZNIDNORMA+"' "
	cSql += "and zu_elemen = zf_elemen and zu_sequen = zf_sequen and zu.d_e_l_e_t_ = ' ' "
	cSql += "where zf_filial = '"+xFilial("SZF")+"' and zf.d_e_l_e_t_ = ' ' order by zf_elemen,zf_sequen"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		nZUVALOR := Nil
		if alltrim((ctrb)->zf_limexc) == "##"
			if (ctrb)->zu_valor != nil
				nZUVALOR := (ctrb)->zu_valor
			else
				nZUVALOR := 0
			endif
		endif
		Aadd(aColCaEx, {  iif(empty(alltrim((ctrb)->zu_sequen)),.f.,.t.), (ctrb)->zf_elemen, (ctrb)->zf_sequen, (ctrb)->zf_descri, nZUVALOR })
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

	Aadd(aCabeTt, {"Id"       ,	"TX_ID"   ,	"@!",           	    03,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabeTt, {"Descrição",	"TX_DESCR",	"@!",         		    50,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	aColTtEd := {}
  	/*
  	aadd(aColTtEx, { .f.,'01','ST - Sem tratamento Termico' })
  	aadd(aColTtEx, { .f.,'02','NO - Normalizado' })
  	aadd(aColTtEx, { .f.,'03','RE - Recozido' })
  	aadd(aColTtEx, { .f.,'04','TR - Temperado e Revenido' })
  	aadd(aColTtEx, { .f.,'05','NT - Normalozado Temperado e Revenido' })
  	aadd(aColTtEx, { .f.,'06','SO - Solubilizado' })
  	aadd(aColTtEx, { .f.,'07','ATT - Alivio de tensoes -> P/ Material de Partida (TUBO C/C)' })
  	aadd(aColTtEx, { .f.,'08','ATC - Alivio de tensoes -> P/ Material de Partida (CHAPA)' })
  	aadd(aColTtEx, { .f.,'09','RV - Revenido' })
  	aadd(aColTtEx, { .f.,'10','RI - Recozimento Isotermico' })
  	aadd(aColTtEx, { .f.,'11','NR - Normalizado e Revenido' })
  	aadd(aColTtEx, { .f.,'12','ED - Esferodizacao' })
  	*/
	dbSelectArea("SZE")
	cSql := "select substr(x5_chave,1,3) TX_ITEM,x5_descri TX_NOME,ze_item from "+RetSQLName("SX5")+" x5 "
	cSql += "left join "+RetSQLName("SZE")+" ze on ze_filial = '"+xFilial("SZE")+"' and ze_idnorma = '"+cZNIDNORMA+"' and ze_tabsx5 = x5_tabela and ze_item = substr(x5_chave,1,3) and ze.d_e_l_e_t_ = ' ' "
	cSql += "where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TX' and x5.d_e_l_e_t_ = ' ' order by x5_chave"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		Aadd(aColTtEx, { iif(empty(alltrim((ctrb)->ze_item)),.f.,.t.), (ctrb)->tx_item, (ctrb)->tx_nome })
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )
  	/*********************************************************/
	//X3Titulo()	X3_CAMPO		X3_PICTURE      	X3_TAMANHO	X3_DECIMAL	    X3_VALID	X3_USADO    X3_TIPO		X3_F3	X3_CONTEXT	X3_CBOX	X3_RELACAO	X3_WHEN
	Aadd(aCabeMp, {"Id"       ,	"MP_ID"   ,	"@!",           	    03,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabeMp, {"Descrição",	"MP_DESCR",	"@!",         		    40,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	aColMpEd := {}
  	/*
  	aadd(aColMpEx, { .f.,'01','Barra' })
  	aadd(aColMpEx, { .f.,'02','Chapa' })
  	aadd(aColMpEx, { .f.,'03','Tubo' })
  	aadd(aColMpEx, { .f.,'04','Tubo Sem Costura' })
  	aadd(aColMpEx, { .f.,'05','Tubo Com Costura C/ Metal de Adicao' })
  	aadd(aColMpEx, { .f.,'06','Tubo Com Costura S/ Metal de Adicao' })
  	*/
	dbSelectArea("SZE")
	cSql := "select substr(x5_chave,1,3) MP_ITEM,x5_descri MP_NOME,ze_item from "+RetSQLName("SX5")+" x5 "
	cSql += "left join "+RetSQLName("SZE")+" ze on ze_filial = '"+xFilial("SZE")+"' and ze_idnorma = '"+cZNIDNORMA+"' and ze_tabsx5 = x5_tabela and ze_item = substr(x5_chave,1,3) and ze.d_e_l_e_t_ = ' ' "
	cSql += "where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'PM' and x5.d_e_l_e_t_ = ' ' order by x5_chave"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		Aadd(aColMpEx, {  iif(empty(alltrim((ctrb)->ze_item)),.f.,.t.), (ctrb)->mp_item, (ctrb)->mp_nome })
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

	//X3Titulo()	X3_CAMPO		X3_PICTURE      	X3_TAMANHO	X3_DECIMAL	    X3_VALID	X3_USADO    X3_TIPO		X3_F3	X3_CONTEXT	X3_CBOX	X3_RELACAO	X3_WHEN
	Aadd(aCabeTc, {"Id"       ,	"TO_ID"   ,	"@!",           	    03,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabeTc, {"Descrição",	"TO_DESCR",	"@!",         		    40,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	aColTcEd := {}
  	/*
  	aadd(aColTcEx, { .f.,'01','Circular' })
  	aadd(aColTcEx, { .f.,'02','Retangular/Quadrado' })
  	*/
	dbSelectArea("SZE")
	cSql := "select substr(x5_chave,1,3) TO_ITEM,x5_descri TO_NOME,ze_item from "+RetSQLName("SX5")+" x5 "
	cSql += "left join "+RetSQLName("SZE")+" ze on ze_filial = '"+xFilial("SZE")+"' and ze_idnorma = '"+cZNIDNORMA+"' and ze_tabsx5 = x5_tabela and ze_item = substr(x5_chave,1,3) and ze.d_e_l_e_t_ = ' ' "
	cSql += "where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TO' and x5.d_e_l_e_t_ = ' ' order by x5_chave"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		Aadd(aColTcEx, {  iif(empty(alltrim((ctrb)->ze_item)),.f.,.t.), (ctrb)->to_item, (ctrb)->to_nome })
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

	//X3Titulo()	X3_CAMPO		X3_PICTURE      	X3_TAMANHO	X3_DECIMAL	    X3_VALID	X3_USADO    X3_TIPO		X3_F3	X3_CONTEXT	X3_CBOX	X3_RELACAO	X3_WHEN
	Aadd(aCabeTs, {"Id"       ,	"SU_ID"   ,	"@!",           	    03,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabeTs, {"Descrição",	"SU_DESCR",	"@!",         		    40,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	aColTsEd := {}
  	/*
  	aadd(aColTsEx, { .f.,'01','Corpo de Prova Axial' })
  	aadd(aColTsEx, { .f.,'02','Corpo de Prova Longitudinal' })
  	aadd(aColTsEx, { .f.,'03','Corpo de Prova Radial' })
  	aadd(aColTsEx, { .f.,'04','Corpo de Prova Transversal' })
  	*/
	dbSelectArea("SZE")
	cSql := "select substr(x5_chave,1,3) SU_ITEM,x5_descri SU_NOME,ze_item from "+RetSQLName("SX5")+" x5 "
	cSql += "left join "+RetSQLName("SZE")+" ze on ze_filial = '"+xFilial("SZE")+"' and ze_idnorma = '"+cZNIDNORMA+"' and ze_tabsx5 = x5_tabela and ze_item = substr(x5_chave,1,3) and ze.d_e_l_e_t_ = ' ' "
	cSql += "where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'SU' and x5.d_e_l_e_t_ = ' ' order by x5_chave"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		Aadd(aColTsEx, {  iif(empty(alltrim((ctrb)->ze_item)),.f.,.t.), (ctrb)->su_item, (ctrb)->su_nome })
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

	DEFINE MSDIALOG oDlg TITLE "Cadastro de Norma - "+aOperacao[nOpc] FROM 000, 000  TO 700, 1035 COLORS 0, 16777215 PIXEL

	@ 003, 003 SAY oSay PROMPT "NORMA :" SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 003, 033 GET oGet VAR cZNNORMA SIZE 181, 010 OF oDlg COLORS 0, 16777215 PIXEL
	if nOpc != 1
		oGet:disable()
	endif
	//lin,col            col,lin
	oPnl := tPanel():New(020,003,,oDlg,,,,,,230,080)
	//oPnl:Align := CONTROL_ALIGN_ALLCLIENT
	//lin,col lin,col                                 Val da linha   Val todas linhas                          Val coluna         Val exclusao linha
	oBrw := MsNewGetDados():New( 001,001,080,230, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+ZT_ITEM", aColsEd,1, 99, "u_NCrtClEl(oBrw)", "", "AllwaysTrue", oPnl, aCabec, aColsEx)
	oBrw:SetArray(aColsEx,.T.)
	oBrw:Refresh()
	if nOpc == 3
		oBrw:disable()
	endif
    /*******************************************************/
	@ 014, 255 SAY oSay PROMPT "Limite" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 014, 295 SAY oSay PROMPT "Limite" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 014, 415 SAY oSay PROMPT "Dureza" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 014, 455 SAY oSay PROMPT "Dureza" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 020, 255 SAY oSay PROMPT "de Tracao" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 020, 295 SAY oSay PROMPT "Escoamento" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 020, 335 SAY oSay PROMPT "Alongamento" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 020, 375 SAY oSay PROMPT "Estriccao" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 020, 415 SAY oSay PROMPT "Brinnel 1" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 020, 455 SAY oSay PROMPT "Brinnel 2" SIZE 350, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 030, 235 SAY oSay PROMPT "Minimo" SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oGet29 := TGet():New(029,255,{|u|If(PCount()==0,nZNTRACAO1,nZNTRACAO1:= u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNTRACAO1",,,, lHasButton , lNoButton)
	oGet30 := TGet():New(029,295,{|u|If(PCount()==0,nZNESCOA1 ,nZNESCOA1 := u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNESCOA1" ,,,, lHasButton , lNoButton)
	oGet31 := TGet():New(029,335,{|u|If(PCount()==0,nZNALONG1 ,nZNALONG1 := u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNALONG1" ,,,, lHasButton , lNoButton)
	oGet32 := TGet():New(029,375,{|u|If(PCount()==0,nZNESTRIC1,nZNESTRIC1:= u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNESTRIC1",,,, lHasButton , lNoButton)
	oGet33 := TGet():New(029,415,{|u|If(PCount()==0,nZNDUREZ11,nZNDUREZ11:= u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNDUREZ11",,,, lHasButton , lNoButton)
	oGet34 := TGet():New(029,455,{|u|If(PCount()==0,nZNDUREZ12,nZNDUREZ12:= u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNDUREZ12",,,, lHasButton , lNoButton)
	@ 039, 235 SAY oSay PROMPT "Maximo" SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oGet35 := TGet():New(038,255,{|u|If(PCount()==0,nZNTRACAO2,nZNTRACAO2:= u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNTRACAO2",,,, lHasButton , lNoButton)
	oGet36 := TGet():New(038,295,{|u|If(PCount()==0,nZNESCOA2 ,nZNESCOA2 := u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNESCOA2" ,,,, lHasButton , lNoButton)
	oGet37 := TGet():New(038,335,{|u|If(PCount()==0,nZNALONG2 ,nZNALONG2 := u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNALONG2" ,,,, lHasButton , lNoButton)
	oGet38 := TGet():New(038,375,{|u|If(PCount()==0,nZNESTRIC2,nZNESTRIC2:= u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNESTRIC2",,,, lHasButton , lNoButton)
	oGet39 := TGet():New(038,415,{|u|If(PCount()==0,nZNDUREZ21,nZNDUREZ21:= u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNDUREZ21",,,, lHasButton , lNoButton)
	oGet40 := TGet():New(039,455,{|u|If(PCount()==0,nZNDUREZ22,nZNDUREZ22:= u)},oDlg,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZNDUREZ22",,,, lHasButton , lNoButton)
	if nOpc == 3
		oGet29:disable();  oGet30:disable();  oGet31:disable();  oGet32:disable();  oGet33:disable();  oGet34:disable()
		oGet35:disable();  oGet36:disable();  oGet37:disable();  oGet38:disable();  oGet39:disable();  oGet40:disable()
	endif
    /*******************************************************/

	@ 058, 255 SAY oSay PROMPT "Campo Memo para Alongamento" SIZE 090, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 065, 255 GET oMultiGe VAR mZNOBSALON OF oDlg MULTILINE SIZE 150, 035 COLORS 0, 16777215 HSCROLL PIXEL
	if nOpc == 3
		oMultiGe:disable()
	endif

	@ 065, 450 BUTTON oButton1 PROMPT "Fechar" SIZE 037, 012 action oDlg:End() OF oDlg PIXEL
	@ 080, 450 BUTTON oButton2 PROMPT "Confirmar" SIZE 037, 012 action iif(confNor(nOpc),oDlg:End(),.f.) OF oDlg PIXEL

    /*******************************************************/
	@ 100, 000 FOLDER oFolder1 SIZE 520, 250 OF oDlg ITEMS "C.COMPOSICAO QUIMICA","TRATAMENTO TERMICO","MATERIAL DE PARTIDA","TESTE DE IMPACTO/CORPO DE PROVA" COLORS 0, 16777215 PIXEL

	oBrwCa := fwBrowse():New()
	oBrwCa:setOwner( oFolder1:aDialogs[1] )
	oBrwCa:setDataArray()
	oBrwCa:setArray( aColCaEx )
	oBrwCa:disableConfig()
	oBrwCa:disableReport()
	oBrwCa:SetLocate() // Habilita a Localização de registros
	//Create Mark Column
	oBrwCa:AddMarkColumns({|| IIf(aColCaEx[oBrwCa:nAt,01], "LBOK", "LBNO")},; //Code-Block image
	{|| SelectOne(oBrwCa, aColCaEx, nOpc)},; //Code-Block Double Click
	{|| SelectAll(oBrwCa, 01, aColCaEx, nOpc) }) //Code-Block Header Click
	oBrwCa:addColumn({"Ele"         , {||aColCaEx[oBrwCa:nAt,02]}, "C", "@!"                     , 1,  02    ,  0  , .F. , , .F.,, "aColCaEx[oBrwCa:nAt,02]",, .F., .T.,  , "IdEl"   })
	oBrwCa:addColumn({"Seq"         , {||aColCaEx[oBrwCa:nAt,03]}, "C", "@!"                     , 1,  02    ,  0  , .F. , , .F.,, "aColCaEx[oBrwCa:nAt,03]",, .F., .T.,  , "IdSe"   })
	oBrwCa:addColumn({"Descrição"   , {||aColCaEx[oBrwCa:nAt,04]}, "C", "@!"                     , 1,  40    ,  0  , .F. , , .F.,, "aColCaEx[oBrwCa:nAt,04]",, .F., .T.,  , "DescCa" })
	oBrwCa:addColumn({"Valor"       , {||aColCaEx[oBrwCa:nAt,05]}, "N", "@E 99,999,999.99999"    , 2,  16    ,  5  , .T. , , .F.,, "aColCaEx[oBrwCa:nAt,05]",, .F., .T.,  , "VlrCa"  })
	oBrwCa:setEditCell( .T. , { || .T. } ) //activa edit and code block for validation
	//oBrwCa:acolumns[2]:ledit     := .F.
	//oBrwCa:acolumns[2]:cReadVar:= 'aColCaEx[oBrwCa:nAt,2]'
	//oBrwCa:setInsert(.T.)  // habilitar inserção
	//oBrwCa:SetDelete(.T.)  // habilitar deleção
	//oBrwCa:DelLine(.T.) // Para executar uma função
	//oBrwCa:LineOk(.T.)  // Para executar uma função
	oBrwCa:Activate(.T.)
    /*******************************************************/
	oBrwTt := fwBrowse():New()
	oBrwTt:setOwner( oFolder1:aDialogs[2] )
	oBrwTt:setDataArray()
	oBrwTt:setArray( aColTtEx )
	oBrwTt:disableConfig()
	oBrwTt:disableReport()
	oBrwTt:SetLocate() // Habilita a Localização de registros
	//Create Mark Column
	oBrwTt:AddMarkColumns({|| IIf(aColTtEx[oBrwTt:nAt,01], "LBOK", "LBNO")},; //Code-Block image
	{|| SelectOne(oBrwTt, aColTtEx, nOpc)},; //Code-Block Double Click
	{|| SelectAll(oBrwTt, 01, aColTtEx, nOpc) }) //Code-Block Header Click
	oBrwTt:addColumn({"Id"             , {||aColTtEx[oBrwTt:nAt,02]}, "C", "@!"                     , 1,  02    ,   , .F. , , .F.,, "aColTtEx[oBrwTt:nAt,02]",, .F., .T.,  , "IfTt"   })
	oBrwTt:addColumn({"Descrição"      , {||aColTtEx[oBrwTt:nAt,03]}, "C", "@!"                     , 1,  40    ,   , .F. , , .F.,, "aColTtEx[oBrwTt:nAt,03]",, .F., .T.,  , "DescTt" })
	oBrwTt:setEditCell( .T. , { || .T. } ) //activa edit and code block for validation
	//oBrwTt:acolumns[2]:ledit     := .T.
	//oBrwTt:acolumns[2]:cReadVar:= 'aColTtEx[oBrowse:nAt,2]'
	oBrwTt:Activate(.T.)
    /*******************************************************/
	oBrwMp := fwBrowse():New()
	oBrwMp:setOwner( oFolder1:aDialogs[3] )
	oBrwMp:setDataArray()
	oBrwMp:setArray( aColMpEx )
	oBrwMp:disableConfig()
	oBrwMp:disableReport()
	oBrwMp:SetLocate() // Habilita a Localização de registros
	//Create Mark Column
	oBrwMp:AddMarkColumns({|| IIf(aColMpEx[oBrwMp:nAt,01], "LBOK", "LBNO")},; //Code-Block image
	{|| SelectOne(oBrwMp, aColMpEx, nOpc)},; //Code-Block Double Click
	{|| SelectAll(oBrwMp, 01, aColMpEx, nOpc) }) //Code-Block Header Click
	oBrwMp:addColumn({"Id"             , {||aColMpEx[oBrwMp:nAt,02]}, "C", "@!"                     , 1,  02    ,   , .F. , , .F.,, "aColMpEx[oBrwMp:nAt,02]",, .F., .T.,  , "IdMp"    })
	oBrwMp:addColumn({"Descrição"      , {||aColMpEx[oBrwMp:nAt,03]}, "C", "@!"                     , 1,  40    ,   , .F. , , .F.,, "aColMpEx[oBrwMp:nAt,03]",, .F., .T.,  , "DescMp"  })
	oBrwMp:setEditCell( .T. , { || .T. } ) //activa edit and code block for validation
	//oBrwMp:acolumns[2]:ledit     := .T.
	//oBrwMp:acolumns[2]:cReadVar:= 'aColMpEx[oBrowse:nAt,2]'
	oBrwMp:Activate(.T.)
    /*******************************************************/
	@ 000, 000 FOLDER oFld4 SIZE 520, 250 OF oFolder1:aDialogs[4] ITEMS "TESTE DE IMPACTO","TIPO CORPO DE PROVA","SENTIDO DO CORPO DE PROVA" COLORS 0, 16777215 PIXEL
	//lin, col        col lin
	oPnl1Fld4 := tPanel():New(001,003,,oFld4:aDialogs[1],,,,,,220,040)
	oPnl1Fld4 := oFld4:aDialogs[1]

	@ 017, 040 SAY oSay PROMPT "Fase 1" SIZE 350, 010 OF oPnl1Fld4 COLORS 0, 16777215 PIXEL
	@ 017, 080 SAY oSay PROMPT "Fase 2" SIZE 350, 010 OF oPnl1Fld4 COLORS 0, 16777215 PIXEL
	@ 017, 120 SAY oSay PROMPT "Fase 3" SIZE 350, 010 OF oPnl1Fld4 COLORS 0, 16777215 PIXEL
	@ 017, 160 SAY oSay PROMPT "Media" SIZE 350, 010 OF oPnl1Fld4 COLORS 0, 16777215 PIXEL
	@ 017, 200 SAY oSay PROMPT "Temperatura" SIZE 350, 010 OF oPnl1Fld4 COLORS 0, 16777215 PIXEL

	@ 026, 005 SAY oSay PROMPT "Valor Minimo" SIZE 040,010 OF oPnl1Fld4 COLORS 0, 16777215 PIXEL
	bChange := {|| nZNMEDIA := round((nZNFASE1+nZNFASE2+nZNFASE3)/3,5) }
	oGet45 := TGet():New(025,040,{|u|If(PCount()==0,nZNFASE1,nZNFASE1:= u)},oPnl1Fld4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,bChange,.F./*lReadOnly*/,.F.,,"nZNFASE1",,,, lHasButton , lNoButton)
	oGet46 := TGet():New(025,080,{|u|If(PCount()==0,nZNFASE2,nZNFASE2:= u)},oPnl1Fld4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,bChange,.F./*lReadOnly*/,.F.,,"nZNFASE2",,,, lHasButton , lNoButton)
	oGet47 := TGet():New(025,120,{|u|If(PCount()==0,nZNFASE3,nZNFASE3:= u)},oPnl1Fld4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,bChange,.F./*lReadOnly*/,.F.,,"nZNFASE3",,,, lHasButton , lNoButton)
	oGet48 := TGet():New(025,160,{|u|If(PCount()==0,nZNMEDIA,nZNMEDIA:= u)},oPnl1Fld4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,       ,.T./*lReadOnly*/,.F.,,"nZNMEDIA",,,, lHasButton , lNoButton)
	oGet49 := TGet():New(025,200,{|u|If(PCount()==0,nZNTEMP ,nZNTEMP := u)},oPnl1Fld4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,       ,.F./*lReadOnly*/,.F.,,"nZNTEMP" ,,,, lHasButton , lNoButton)
	if nOpc == 3
		oGet45:disable();  oGet46:disable();  oGet47:disable();  oGet48:disable();  oGet49:disable()
	endif
    /*******************************************************/
	//lin, col        col lin
	oPnl2Fld4 := tPanel():New(051,003,,oFld4:aDialogs[1],,,,,,220,100)
	oPnl2Fld4 := oFld4:aDialogs[2]

	oBrwTc := fwBrowse():New()
	oBrwTc:setOwner( oPnl2Fld4 )
	//oBrwTc:setOwner( oFld4:aDialogs[1] )
	oBrwTc:setDataArray()
	oBrwTc:setArray( aColTcEx )
	oBrwTc:disableConfig()
	oBrwTc:disableReport()
	oBrwTc:SetLocate() // Habilita a Localização de registros
	//Create Mark Column
	oBrwTc:AddMarkColumns({|| IIf(aColTcEx[oBrwTc:nAt,01], "LBOK", "LBNO")},; //Code-Block image
	{|| SelectOne(oBrwTc, aColTcEx, nOpc)},; //Code-Block Double Click
	{|| SelectAll(oBrwTc, 01, aColTcEx, nOpc) }) //Code-Block Header Click
	oBrwTc:addColumn({"Id"             , {||aColTcEx[oBrwTc:nAt,02]}, "C", "@!"                     , 1,  02    ,   , .F. , , .F.,, "aColTcEx[oBrwTc:nAt,02]",, .F., .T.,  , "IdTc"    })
	oBrwTc:addColumn({"Descrição"      , {||aColTcEx[oBrwTc:nAt,03]}, "C", "@!"                     , 1,  40    ,   , .F. , , .F.,, "aColTcEx[oBrwTc:nAt,03]",, .F., .T.,  , "DescTc"  })
	oBrwTc:setEditCell( .T. , { || .T. } ) //activa edit and code block for validation
	//oBrwTc:acolumns[2]:ledit     := .T.
	//oBrwTc:acolumns[2]:cReadVar:= 'aColTcEx[oBrowse:nAt,2]'
	oBrwTc:Activate(.T.)
    /*******************************************************/
	//lin, col        col lin
	oPnl3Fld4 := tPanel():New(101,003,,oFld4:aDialogs[1],,,,,,220,200)
	oPnl3Fld4 := oFld4:aDialogs[3]

	oBrwTs := fwBrowse():New()
	oBrwTs:setOwner( oPnl3Fld4 )
	//oBrwTs:setOwner( oFld4:aDialogs[3] )
	oBrwTs:setDataArray()
	oBrwTs:setArray( aColTsEx )
	oBrwTs:disableConfig()
	oBrwTs:disableReport()
	oBrwTs:SetLocate() // Habilita a Localização de registros
	//Create Mark Column
	oBrwTs:AddMarkColumns({|| IIf(aColTsEx[oBrwTs:nAt,01], "LBOK", "LBNO")},; //Code-Block image
	{|| SelectOne(oBrwTs, aColTsEx, nOpc)},; //Code-Block Double Click
	{|| SelectAll(oBrwTs, 01, aColTsEx, nOpc) }) //Code-Block Header Click
	oBrwTs:addColumn({"Id"             , {||aColTsEx[oBrwTs:nAt,02]}, "C", "@!"                     , 1,  02    ,   , .F. , , .F.,, "aColTsEx[oBrwTs:nAt,02]",, .F., .T.,  , "IdTs"    })
	oBrwTs:addColumn({"Descrição"      , {||aColTsEx[oBrwTs:nAt,03]}, "C", "@!"                     , 1,  40    ,   , .F. , , .F.,, "aColTsEx[oBrwTs:nAt,03]",, .F., .T.,  , "DescTs"  })
	oBrwTs:setEditCell( .T. , { || .T. } ) //activa edit and code block for validation
	//oBrwTs:acolumns[2]:ledit     := .T.
	//oBrwTs:acolumns[2]:cReadVar:= 'aColTsEx[oBrowse:nAt,2]'
	oBrwTs:Activate(.T.)

	ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function SelectOne(oBrowse, aArquivo, nOpc)

	if nOpc == 3
		aArquivo[oBrowse:nAt,1] := aArquivo[oBrowse:nAt,1]
	else
		aArquivo[oBrowse:nAt,1] := !aArquivo[oBrowse:nAt,1]
	endif
	oBrowse:Refresh()
Return .T.

Static Function SelectAll(oBrowse, nCol, aArquivo, nOpc)

	Local _ni := 1
	if nOpc == 3
		For _ni := 1 to len(aArquivo)
			aArquivo[_ni,1] := aArquivo[_ni,1]
		Next
		lMarker:=lMarker
	else
		For _ni := 1 to len(aArquivo)
			aArquivo[_ni,1] := lMarker
		Next
		lMarker:=!lMarker
	endif
	oBrowse:Refresh()

Return .T.

User Function NCrtClEl(oObj)   // Manutenção norma crit elementos quimicos

	Local lRet := .T.
	Local nLin := oObj:nAt
	Local nCol := oObj:oBrowse:nColPos
//Local nTotLin := Len(oObj:aCols)
	Local nIx  := 0

	if nCol == 2
		cSql := "select * from "+RetSQLName("SX5")+" x5 where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TR' and x5_chave = '"+M->ZT_SIMBOLO+"' and x5.d_e_l_e_t_ = ' '"
		cSql := ChangeQuery( cSql )
		cTrb := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
		if (ctrb)->( Eof() )
			msginfo("Não encontrou elemento na Tabela elementos quimicos (SX5-TR) !")
			oObj:aCols[nLin,nCol+1] := " "
			lRet := .F.
		else
			oObj:aCols[nLin,nCol+1] := substr((ctrb)->X5_DESCRI,1,15)
		endif
		(ctrb)->( DbCloseArea() )

		for nIx := 1 to len(oObj:aCols)
			if M->ZT_SIMBOLO == oObj:aCols[nIx,2] .and. nLin != nIx
				msginfo("O mesmo símbolo já foi digitado !")
				oObj:aCols[nLin,nCol+1] := " "
				lRet := .F.
			endif
		next

		oObj:Refresh(.T.)
	elseif nCol == 4
		if m->zt_min < 0 .and. m->zt_min != -1
			msginfo("Único valor negativo que pode ser usado no percentual mínimo é o -1 !")
			lRet := .F.
		endif
	elseif nCol == 5
		if m->zt_max <= 0
			msginfo("Percentual máximo tem que ser maior que zero !")
			lRet := .F.
		endif
	endif

Return(lRet)

Static Function confNor(nOpc)

	Local lRet := .t.
	Local cSql := ""
	Local cTrb := ""
	Local nId  := 0
	Local nInc := 0
	Local lIncZT := .f.
	Local lIncZU := .f.
	Local lIncZE := .f.

	if nOpc < 0 .or. nOpc > 3
		MsgInfo("A operacao que esta sendo usada esta incorreta. Favor falar com responsavel sistema! ","Atencao")
		Return .f.
	endif

	if nOpc == 1
		if Empty(cZNNORMA)
			MsgInfo("O nome da Norma deve se preenchido! ","Atencao")
			Return .f.
		else
			SZN->(dbSetORder(1))
			If SZN->(dbSeek(xFilial("SZN") + cZNNORMA))
				MsgInfo("A descrição da Norma já foi utilizada! ","Atencao")
				Return .f.
			endif
		endif
	endif
	if nOpc == 1 .or. nOpc == 2
		if !(nZNFASE1 != 0 .and. nZNFASE2 != 0 .and. nZNFASE3 != 0 .and. nZNMEDIA != 0 .and. nZNTEMP != 0) .and. ;
				!(nZNFASE1 == 0 .and. nZNFASE2 == 0 .and. nZNFASE3 == 0 .and. nZNMEDIA == 0 .and. nZNTEMP == 0)
			MsgInfo("Todos os valores da pasta Teste de impacto devem estar preenchidos ou todos não preenchidos ! ","Atencao")
			Return .f.
		endif

		for nId := 1 to len(aColCaEx)
			sx5->(dbseek(xFilial("SX5")+'TQ'+aColCaEx[nId,2]))
			if aColCaEx[nId,1] .and. alltrim(sx5->x5_descspa) == '.T.' .and. aColCaEx[nId,4] == 0
				MsgInfo("Favor preencher o valor do item "+aColCaEx[nId,2]+" da aba Composição química ! ","Atencao")
				Return .f.
			endif
		Next

		for nId := 1 to len(oBrw:aCols)
			if !oBrw:aCols[nId,len(oBrw:aCols[nId])] .and. !empty(oBrw:aCols[nId,2])
				if (oBrw:aCols[nId,4] == -1 .or. oBrw:aCols[nId,4] >= 0) .and. oBrw:aCols[nId,5] > oBrw:aCols[nId,4]
					nInc += 1
				else
					MsgInfo("Verifique preenchimento do Componente químico item "+oBrw:aCols[nId,1]+" ! ","Atencao")
					Return .f.
				endif
			endif
		next
		if nInc <= 0
			MsgInfo("Pelo menos um Componente químico deve ser preenchido ! ","Atencao")
			Return .f.
		endif

	elseif nOpc == 3

		cSql := "select count(*) nreg from "+RetSQLName("SZS")+" zs where zs_filial = '"+xFilial("SZS")+"' and zs_idnorma = '"+cZNIDNORMA+"' and d_e_l_e_t_ = ' '"
		cSql := ChangeQuery( cSql )
		cTrb := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
		if !(ctrb)->( Eof() ) .and. (ctrb)->nreg > 0
			MsgInfo("Norma não pode ser excluida pois já é utilizada em uma corrida ! ","Atencao")
			Return .f.
		endif
		(ctrb)->( DbCloseArea() )

		for nId := 1 to len(oBrw:aCols)
			nInc += 1
		next

	endif

	if MsgYesNo("Confirma a "+aOperacao[nOpc]+" da Norma: "+alltrim(cZNNORMA)+" ?","ATENÇÃO","YESNO")

		if nOpc == 3
			if SZN->(RecLock("SZN",.f.))
				SZN->(DbDelete())
			else
				lRet := .f.
			endif
		else
			if nOpc == 1
				cSql := "select max(zn_idnorma) ProxId from "+RetSQLName("SZN")+" zn where zn_filial = '"+xFilial("SZN")+"' and d_e_l_e_t_ = ' '"
				cSql := ChangeQuery( cSql )
				cTrb := GetNextAlias()
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
				if !(ctrb)->( Eof() ) .and. !empty((ctrb)->ProxId)
					cZNIDNORMA := strzero((val((ctrb)->ProxId) + 1),4)
				else
					cZNIDNORMA := '0001'
				endif
				(ctrb)->( DbCloseArea() )
				if SZN->(RecLock("SZN",.t.))
					SZN->ZN_FILIAL  := SZN->(xfilial())
					SZN->ZN_IDNORMA := cZNIDNORMA
					SZN->ZN_NORMA   := cZNNORMA
				else
					lRet := .f.
				endif

			elseif nOpc == 2
				if !SZN->(RecLock("SZN",.f.))
					lRet := .f.
				endif
			endif
			if lRet
				SZN->ZN_TRACAO1 := nZNTRACAO1
				SZN->ZN_TRACAO2 := nZNTRACAO2
				SZN->ZN_ESCOA1 := nZNESCOA1
				SZN->ZN_ESCOA2 := nZNESCOA2
				SZN->ZN_ALONG1 := nZNALONG1
				SZN->ZN_ALONG2 := nZNALONG2
				SZN->ZN_ESTRIC1 := nZNESTRIC1
				SZN->ZN_ESTRIC2 := nZNESTRIC2
				SZN->ZN_DUREZ11 := nZNDUREZ11
				SZN->ZN_DUREZ12 := nZNDUREZ12
				SZN->ZN_DUREZ21 := nZNDUREZ21
				SZN->ZN_DUREZ22 := nZNDUREZ22
				SZN->ZN_OBSALON := mZNOBSALON
				SZN->ZN_FASE1 := nZNFASE1
				SZN->ZN_FASE2 := nZNFASE2
				SZN->ZN_FASE3 := nZNFASE3
				SZN->ZN_MEDIA := nZNMEDIA
				SZN->ZN_TEMP := nZNTEMP
			endif
		endif
		SZN->(MsUnLock())

		if lRet .and. nInc > 0
			SZT->(dbSetORder(2))
			for nId := 1 to len(oBrw:aCols)
				if !empty(oBrw:aCols[nId,2])
					lIncZT := .f.
					if !SZT->(dbSeek(xFilial("SZT") + cZNIDNORMA + oBrw:aCols[nId,1]))
						lIncZT := .t.
					endif
					if nOpc == 1 .or. lIncZT
						if !oBrw:aCols[nId,len(oBrw:aCols[nId])]
							if SZT->(RecLock("SZT",.t.))
								SZT->ZT_FILIAL  := SZT->(xfilial())
								SZT->ZT_IDNORMA := cZNIDNORMA
								SZT->ZT_ITEM    := oBrw:aCols[nId,1]
								SZT->ZT_SIMBOLO := oBrw:aCols[nId,2]
								SZT->ZT_MIN     := oBrw:aCols[nId,4]
								SZT->ZT_MAX     := oBrw:aCols[nId,5]
							else
								lRet := .f.
							endif
						endif
					elseif SZT->(RecLock("SZT",.f.))
						if nOpc == 3 .or. oBrw:aCols[nId,len(oBrw:aCols[nId])]
							SZT->(DbDelete())
						else
							SZT->ZT_SIMBOLO := oBrw:aCols[nId,2]
							SZT->ZT_MIN     := oBrw:aCols[nId,4]
							SZT->ZT_MAX     := oBrw:aCols[nId,5]
						endif
					else
						lRet := .f.
					endif
					SZT->(MsUnLock())
				endif
			next
		endif

		if lRet
			szu->(dbSetORder(1))
			for nId := 1 to len(aColCaEx)
				lIncZU := .f.
				if !szu->(dbSeek(xFilial()+SZN->ZN_IDNORMA+aColCaEx[nId,2]+aColCaEx[nId,3]))
					lIncZU := .t.
				endif
				if ( nOpc == 1 .or. lIncZU) .and. aColCaEx[nId,1]
					if SZU->(RecLock("SZU",.t.))
						SZU->ZU_FILIAL  := SZU->(xfilial())
						SZU->ZU_IDNORMA := SZN->ZN_IDNORMA
						SZU->ZU_ELEMEN  := aColCaEx[nId,2]
						SZU->ZU_SEQUEN  := aColCaEx[nId,3]
						SZU->ZU_VALOR   := aColCaEx[nId,5]
					else
						lRet := .f.
					endif
				elseif !lIncZU
					if SZU->(RecLock("SZU",.f.))
						if nOpc == 3 .or. !aColCaEx[nId,1]
							SZU->(DbDelete())
						else
							SZU->ZU_VALOR  := aColCaEx[nId,5]
						endif
					else
						lRet := .f.
					endif
				endif
				szu->(MsUnLock())
			next
		endif

		if lRet
			SZE->(dbSetORder(1))
			for nId := 1 to len(aColTtEx)
				lIncZE := .f.
				if !SZE->(dbSeek(xFilial("SZE") + SZN->ZN_IDNORMA + 'TX' + aColTtEx[nId,2]))
					lIncZE := .t.
				endif
				if ( nOpc == 1 .or. lIncZE) .and. aColTtEx[nId,1]
					if SZE->(RecLock("SZE",.t.))
						SZE->ZE_FILIAL  := SZE->(xfilial())
						SZE->ZE_IDNORMA := SZN->ZN_IDNORMA
						SZE->ZE_TABSX5  := 'TX'
						SZE->ZE_ITEM    := aColTtEx[nId,2]
					else
						lRet := .f.
					endif
				elseif !lIncZE
					if SZE->(RecLock("SZE",.f.))
						if nOpc == 3 .or. !aColTtEx[nId,1]
							SZE->(DbDelete())
						endif
					else
						lRet := .f.
					endif
				endif
				SZE->(MsUnLock())
			next
		endif

		if lRet
			SZE->(dbSetORder(1))
			for nId := 1 to len(aColMpEx)
				lIncZE := .f.
				if !SZE->(dbSeek(xFilial("SZE") + SZN->ZN_IDNORMA + 'PM' + aColMpEx[nId,2]))
					lIncZE := .t.
				endif
				if ( nOpc == 1 .or. lIncZE) .and. aColMpEx[nId,1]
					if SZE->(RecLock("SZE",.t.))
						SZE->ZE_FILIAL  := SZE->(xfilial())
						SZE->ZE_IDNORMA := SZN->ZN_IDNORMA
						SZE->ZE_TABSX5  := 'PM'
						SZE->ZE_ITEM    := aColMpEx[nId,2]
					else
						lRet := .f.
					endif
				elseif !lIncZE
					if SZE->(RecLock("SZE",.f.))
						if nOpc == 3 .or. !aColMpEx[nId,1]
							SZE->(DbDelete())
						endif
					else
						lRet := .f.
					endif
				endif
				SZE->(MsUnLock())
			next
		endif

		if lRet
			SZE->(dbSetORder(1))
			for nId := 1 to len(aColTcEx)
				lIncZE := .f.
				if !SZE->(dbSeek(xFilial("SZE") + SZN->ZN_IDNORMA + 'TO' + aColTcEx[nId,2]))
					lIncZE := .t.
				endif
				if ( nOpc == 1 .or. lIncZE) .and. aColTcEx[nId,1]
					if SZE->(RecLock("SZE",.t.))
						SZE->ZE_FILIAL  := SZE->(xfilial())
						SZE->ZE_IDNORMA := SZN->ZN_IDNORMA
						SZE->ZE_TABSX5  := 'TO'
						SZE->ZE_ITEM    := aColTcEx[nId,2]
					else
						lRet := .f.
					endif
				elseif !lIncZE
					if SZE->(RecLock("SZE",.f.))
						if nOpc == 3 .or. !aColTcEx[nId,1]
							SZE->(DbDelete())
						endif
					else
						lRet := .f.
					endif
				endif
				SZE->(MsUnLock())
			next
		endif

		if lRet
			SZE->(dbSetORder(1))
			for nId := 1 to len(aColTsEx)
				lIncZE := .f.
				if !SZE->(dbSeek(xFilial("SZE") + SZN->ZN_IDNORMA + 'SU' + aColTsEx[nId,2]))
					lIncZE := .t.
				endif
				if ( nOpc == 1 .or. lIncZE) .and. aColTsEx[nId,1]
					if SZE->(RecLock("SZE",.t.))
						SZE->ZE_FILIAL  := SZE->(xfilial())
						SZE->ZE_IDNORMA := SZN->ZN_IDNORMA
						SZE->ZE_TABSX5  := 'SU'
						SZE->ZE_ITEM    := aColTsEx[nId,2]
					else
						lRet := .f.
					endif
				elseif !lIncZE
					if SZE->(RecLock("SZE",.f.))
						if nOpc == 3 .or. !aColTsEx[nId,1]
							SZE->(DbDelete())
						endif
					else
						lRet := .f.
					endif
				endif
				SZE->(MsUnLock())
			next
		endif


		if !lRet
			MsgInfo("Problemas nas garavações das operações, favor verificar os dados da Norma ! ","Atencao")
		endif
	endif

Return lRet
