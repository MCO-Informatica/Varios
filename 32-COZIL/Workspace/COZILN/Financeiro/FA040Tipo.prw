//Bibliotecas
#Include "Totvs.ch"
#Include "Protheus.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA040Tipo ³ Autor ³ Marcos Souza 		³ Data ³ 30/04/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Checa o Tipo do titulo informado 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA040Tipo() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA040													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA040Tipo()
Local nOpca := 0
Local lRetorna := .T.
Local cAlias := GetNextAlias()
Local cQuery := ""
Local nRegistro
Local oDlg
Local nPos := 0
Local cTipo := ""
Local lInclTit	:= IIF(TYPE("INCLUI")<>"U",INCLUI,.F.)
Local oEspecie
Local lJurxFin  := ExistFunc("JurBnkNat") .And. SuperGetMV("MV_JURXFIN",,.F.)
Local lJFilBco  := ExistFunc("JurVldSA6") .And. SuperGetMv("MV_JFILBCO", .F., .F.) //Indica se filtra as contas correntes vinculadas ao escritório logado - SIGAPFS
Local cEscrit   := IIF(lJFilBco, JurGetDados("NS7", 4, xFilial("NS7") + cFilAnt + cEmpAnt, "NS7_COD"), "")
Local cF3Bco    := IIF(lJFilBco, "SA6JUR", "SA6")
Local cJADTTP    := Alltrim(GetMv("MV_JADTTP"))

Static __lEspec		:= .F.

If cPaisLoc == "BRA"
	If Type("aRecnoAdt") != "U" .and. (FunName() = "MATA410" .or. FunName() = "MATA460A" .or. FunName() = "MATA460B")
		If M->E1_TIPO <> cJADTTP
			Aviso("ATENCAO, TIPO "+M->E1_TIPO,"Por tratar-se de título para processo de adiantamento, é obrigatório que o tipo do título seja '"+cJADTTP+"'.",{ "Ok" })
			Return(.F.)
		Endif
	Endif
Endif

If ( lF040Auto ) .AND. cPaisLoc == "EQU" .and. !lInclTit //somente para equador.
	nPos := Ascan(aAutoCab,{|x| Alltrim(x[1]) == "E1_TIPO"})
	If nPos > 0
		cTipo := aAutoCab[nPos] [2]
	EndIf
	M->E1_PREFIXO 	:= SE1->E1_PREFIXO
	M->E1_NUM 		:= SE1->E1_NUM
	M->E1_TIPO 		:= cTipo
	M->E1_PARCELA 	:= SE1->E1_PARCELA
	M->E1_CLIENTE 	:= SE1->E1_CLIENTE
	M->E1_LOJA 		:= SE1->E1_LOJA
EndIF

lF040Auto	:= Iif(Type("lF040Auto") != "L", .F., lF040Auto )
nMoedAdt	:= Iif( Empty(nMoedAdt), M->E1_MOEDA, nMoedAdt )

dbSelectArea("SE1")
nRegistro:=Recno()
dbSetOrder(1)

dbSelectArea("SX5")
If !dbSeek(xFilial("SX5")+"05"+m->e1_tipo)
	Help(" ",1,"E1_TIPO")
	lRetorna := .F.
ElseIf lF040Auto .and. SE1->(DbSeek(xFilial("SE1")+m->e1_prefixo+m->e1_num+m->e1_parcela+m->e1_tipo)) .and. ALTERA
	lRetorna := .T.
ElseIf m->e1_tipo $ MVRECANT
	dbSelectArea("SE5")
	dbSetOrder(7)
	If dbSeek(xFilial("SE5")+m->e1_prefixo+m->e1_num+m->e1_parcela+m->e1_tipo)
		Help(" ",1,"RA_EXISTIU")
		lRetorna := .F.
	Endif
Elseif !NewTipCart(m->e1_tipo,"1")
	Help(" ",1,"TIPOCART")
	lRetorna := .F.
Else
	dbSelectArea("SE1")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se for abatimento, herda os dados do titulo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If m->e1_tipo $ MVABATIM .and. !Empty(m->e1_num)
		If !(dbSeek(xFilial("SE1")+m->e1_prefixo+m->e1_num+m->e1_parcela))
			Help(" ",1,"FA040TIT") // Não Existe Título com este Número para Abatimento.
			lRetorna:=.F.
		Else 
        	If FindFunction("FINTP01") .AND. FINTP01(.T.) // Não incluir titulo de abatimento caso titulo pai seja integração TIN - RM
            	lRetorna :=  .F.
			Endif
			cQuery := "SELECT COUNT(*) QTD FROM " + RetSQLName("SE1") + " "
			cQuery += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' AND E1_PREFIXO = '" + M->E1_PREFIXO + "' AND E1_NUM = '" + M->E1_NUM + "' AND E1_PARCELA = '" + M->E1_PARCELA + "'"
			cQuery += "AND E1_SALDO > '0' AND D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery( cQuery )
			
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAlias, .F., .T.)

			If (cAlias)->QTD == 0
				Help(" ",1,"FA040ABB")
				lRetorna:=.F.	
			EndIf

			(cAlias)->(dbCloseArea())
			dbSelectArea("SE1")

		Endif

		dbGoTo(nRegistro)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso seja titulo de adiantamento, nao posso gerar tit.abatimento ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lRetorna .and. m->e1_tipo $ MVABATIM
			dbSelectArea( "SE1" )
			lRet := .F.
			IF dbSeek(xFilial("SE1")+ m->e1_prefixo + m->e1_num + m->e1_parcela )
				While !Eof() .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA) == ;
								xFilial("SE1")+m->e1_prefixo+m->e1_num+m->e1_parcela
					If SE1->E1_TIPO $ MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT
						dbSkip()
						Loop
					Else
						lRet := .T.
						nRegistro:= SE1->(Recno())
						Exit
					Endif
				Enddo
			Endif
			If !lRet 
				Help(" ",1,"FA040TITAB")
				dbGoTo(nRegistro)
				lRetorna:=.F.
			Endif
		Endif
	EndIf
	If lRetorna .and. (dbSeek(xFilial("SE1")+m->e1_prefixo+m->e1_num+m->e1_parcela+m->e1_tipo))
		Help(" ",1,"FA040NUM")
		dbGoTo(nRegistro)
		lRetorna:=.F.
	Else
		dbGoTo(nRegistro)
		cTitPai:=SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
	Endif
	If lRetorna .and. !(SE1->E1_TIPO $ MVABATIM) .and. m->e1_tipo $ MVABATIM .and. SE1->E1_SALDO > 0
		dbSelectArea( "SE1" )
		lRet := .F.
		Fa040Herda()
		
		//Verifico se os dados herdados nao pertencem a um titulo de adiantamento
			dbGoTo(nRegistro)
			IF dbSeek(xFilial("SE1")+ m->e1_prefixo + m->e1_num + m->e1_parcela )
				While !Eof() .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA) == ;
								xFilial("SE1")+m->e1_prefixo+m->e1_num+m->e1_parcela
					If SE1->E1_TIPO $ MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT
						dbSkip()
						Loop
					Else
						lRet := .T.
						Exit
					Endif
				Enddo
			Endif
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CASO SEJA TITULO DE ADIANTAMENTO, NAO POSSO GERAR TIT.ABATIMENTO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SE1")
		If M->E1_TIPO $ MVABATIM .AND. (dbSeek(xFilial("SE1") + m->e1_prefixo + m->e1_num + m->e1_parcela + m->e1_tipo)) 
			Help("NOVO",1,,)
			m->e1_num := Space(6)
			dbGoTo(nRegistro)
			lRefresh	:= .T.
			lRetorna	:=.F.
		ElseIf (dbSeek(xFilial("SE1") + m->e1_prefixo + m->e1_num + m->e1_parcela + m->e1_tipo)) 
			Help(" ",1,"FA040NUM")
			m->e1_num := Space(6)
			dbGoTo(nRegistro)
			lRefresh	:= .T.
			lRetorna	:=.F.
		Else 
			dbGoTo(nRegistro)
			If !lRet .And. SE1->E1_TIPO $ MV_CRNEG+"/"+MVRECANT
				Help(" ",1,"FA040TITAB")
				lRetorna:=.F.
			Endif
		Endif
		
		If lRetorna
			dbGoTo(nRegistro)
			If FindFunction("FINTP01") .AND. FINTP01(.T.) // Não incluir titulo de abatimento cao titulo pai seja integração TIN - RM
            	lRetorna :=  .F.
        	Endif
		EndIf
	EndIf
	If lRetorna .and. (	m->e1_naturez$&(GetMv("MV_IRF"))		.or.;
								m->e1_naturez$&(GetMv("MV_ISS"))		.or.;
							 	m->e1_naturez$&(GetMv("MV_INSS"))		.or.;
								m->e1_naturez== GetMv("MV_CSLL")			.or.;
								m->e1_naturez== GetMv("MV_COFINS")		.or.;
								m->e1_naturez== GetMv("MV_PISNAT") )	.and.;
								!(m->e1_tipo $ MVTAXA)
		Help(" ",1,"E1_TIPO")
		lRetorna := .F.
	EndIf
	If m->e1_tipo $ MVPAGANT+"/"+MV_CPNEG .and. lRetorna
		Help(" ",1,"E1_TIPO")
		lRetorna := .F.
	EndIf
EndIf
If M->E1_TIPO $ MVRECANT .and. ! lF040Auto .and. lRetorna
	While .T.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mostra Get do Banco de Entrada								³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nOpca := 0
		DEFINE MSDIALOG oDlg FROM 100, 000 TO 250, 235 TITLE "Local de Entrada" PIXEL 
		@	006, 005 	Say "Banco : "   Of oDlg PIXEL 

		If cPaisLoc == "BRA"
			@	005, 040	MSGET cBancoAdt F3 cF3Bco Valid CarregaSa6( @cBancoAdt,,,,,,, @nMoedAdt ) Of oDlg HASBUTTON PIXEL
		Else
			@	005, 040	MSGET cBancoAdt F3 cF3Bco Valid CarregaSa6( @cBancoAdt ) Of oDlg HASBUTTON PIXEL
		EndIf

		@	021, 005 	Say "Agência : "  Of  oDlg PIXEL	
		@	020, 040	MSGET cAgenciaAdt Valid CarregaSa6(@cBancoAdt,@cAgenciaAdt) Of oDlg PIXEL
		@	036, 005 	Say "Conta : "  Of  oDlg PIXEL
		@	035, 040	MSGET cNumCon Picture "@S60" Valid CarregaSa6(@cBancoAdt,@cAgenciaAdt,@cNumCon,,,.T.) SIZE 75, 10 Of oDlg PIXEL

		If AliasInDic("FKF") .and. FKF->(ColumnPos("FKF_ESPEC")) > 0
			@	055, 005 SAY "Especie - DME" OF oDlg PIXEL	
			@	055, 040 CHECKBOX oEspecie VAR __lEspec PROMPT "" SIZE 12,12 OF oDlg PIXEL
		EndIf

		@	001, 001 TO 075, 120 OF oDlg PIXEL

		DEFINE SBUTTON FROM 060,092  TYPE 1 ACTION (nOpca := 1,If(!Empty(cBancoAdt).and. CarregaSa6(@cBancoAdt,@cAgenciaAdt,@cNumCon,,,.T.,, @nMoedAdt) .And. ;
						IIF(lJFilBco, JurVldSA6("3", {cEscrit, cBancoAdt, cAgenciaAdt, cNumCon}), IIF(lJurxFin, JurBnkNat(cBancoAdt, cAgenciaAdt, cNumCon), .T.)), oDlg:End(), nOpca:=0)) ENABLE OF oDlg PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

		IF nOpca != 0
			//Ajusta a modalidade de pagamento para 1 = STR. Adiantamento eh sempre STR
			If SpbInUse()
				m->e1_modspb := "1"
			Endif

			If cPaisLoc == "BRA"
				M->E1_MOEDA := nMoedAdt
			EndIf

			lRetorna := .T.
			Exit
		EndIF
	Enddo
EndIf
Return lRetorna

