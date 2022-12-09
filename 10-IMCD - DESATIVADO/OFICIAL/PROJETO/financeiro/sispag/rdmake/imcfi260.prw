#include 'protheus.ch'


Static _oFINA2601

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FINA260   � Autor � Mauricio Pequim Jr    � Data � 01/10/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Conciliacao DDA - Debito Direto Autorizado                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FINA260()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINA260                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user function IMCFI260(nPosArotina, lAutomato)

Local nSavInd := IndexOrd()
Local nSavRec	:= Recno()

//��������������������������Ŀ
//� Define Vari�veis 		  �
//����������������������������
Private aRotina := MenuDef()

//������������������������������������������������Ŀ
//� Define o cabe�alho da tela de baixas				�
//��������������������������������������������������
Private cCadastro := "Concilia��o DDA"

Default nPosArotina := 0 //Vari�vel criada para teste de automa��o
Default lAutomato := .F. //Vari�vel criada para teste de automa��o

If !FDdaInUse() .and. !lAutomato 
	Alert ("O tratamento para DDA - D�bito Direto Autorizado n�o est� corretamente implementado."+CHR(13)+;  
		    "Por favor, execute o atualizador U_UPDFIN com data posterior a 01/10/09.")
	Return
Endif

dbSelectArea("FIG")
dbSetOrder(1)
dbGoTop()

//���������������������������������������Ŀ
//� Endere�a a Fun��o de BROWSE				�
//�����������������������������������������
If nPosArotina > 0
	bBlock := &( "{ |x,y,z,k| " + aRotina[ nPosArotina,2 ] + "(x,y,z,k) }" )
	dbSelectArea("FIG")
	Eval( bBlock,Alias(),FIG->(Recno()),nPosArotina,lAutomato)  
Else
	mBrowse( 6, 1,22,75,"FIG",,,,,,U_IMC260LE())
	SET KEY VK_F12 TO
EndIf

dbSelectArea("FIG")
dbSetOrder(nSavInd)
dbGoTo(nSavRec)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �IMC260CO  � Autor � Mauricio Pequim Jr    � Data � 01/10/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Conciliacao DDA - Debito Direto Autorizado                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � IMC260CO()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINA260                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user function IMC260CO(cAlias,nReg,nOpcx,lAutomato)

Local aArea		:= GetArea()
Local lOk		:= .F.
Local aSays		:= {}
Local aButtons	:= {}
Local cPerg		:= "FIN260"

Default lAutomato	   := .F.


//��������������������������������������������������������������Ŀ
//�                    P A R A M E T R O S                       �
//�--------------------------------------------------------------�
//�MV_PAR01: Considera Filiais Abaixo                            �
//�MV_PAR02: Filial De                                           �
//�MV_PAR03: Filial Ate                                          �
//�MV_PAR04: Fornecedor De                                       �
//�MV_PAR05: Fornecedor Ate                                      �
//�MV_PAR06: Loja De			                                      �
//�MV_PAR07: Loja Ate		                                      �
//�MV_PAR08: Considera Vencto ou Vencto Real                     �
//�MV_PAR09: Vencto De                                           �
//�MV_PAR10: Vencto Ate                                          �
//�MV_PAR11: Dt. de Processamento do Arquivo DDA De              �
//�MV_PAR12: Dt. de Processamento do Arquivo DDA Ate             �
//�MV_PAR13: Avancar Dias (Vencto + nDias)                       �
//�MV_PAR14: Retroceder Dias (Vencto - nDias)                    �
//�MV_PAR15: Diferenca a Menor                                   �
//�MV_PAR16: Diferenca a Maior                                   �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Carrega fun��o Pergunte                                      �
//����������������������������������������������������������������
pergunte("FIN260",.F.)
If !lAutomato
	aADD(aSays,"Esta rotina tem como objetivo a concilia��o das informa��es importadas atrav�s de") 
    aADD(aSays,"processamento de arquivo de retorno DDA com os dados dos regitros de t�tulos de  ") 
	aADD(aSays,"contas a pagar(tabela SE2) para obten��o dos c�digos de barra dos boletos banc�rios.") 
	
	aADD(aButtons, { 5,.T.,{|| Pergunte("FIN260",.T. ) } } )
	aADD(aButtons, { 1,.T.,{|| lOk := .T.,FechaBatch()}} )
	aADD(aButtons, { 2,.T.,{|| FechaBatch() }} )
	FormBatch( cCadastro, aSays, aButtons ,,,535)
Else
	lOk := .T.
Endif			

If lOk
	Processa({|lEnd| U_IMC260GE(lAutomato)})  // Chamada com regua
Endif

RestArea(aArea)

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � IMC260GE � Autor � Mauricio Pequim Jr    � Data � 01/10/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Conciliacao DDA - Debito Direto Autorizado                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � IMC260GE()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINA260                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IMC260GE(lAutomato)

Local lPanelFin := IsPanelFin()

Local cRecTRB
Local nSavRecno:= Recno()
Local nPos		:= 0
Local aTabela 	:= {}
Local cIndex	:= " "
Local nSeq		:= 0						// controle sequencial de lancto do Banco
Local lSaida	:= .F.
Local nOpca		:= 0
Local aCores 	:= {}
Local nCont		:= 0
Local li
Local cVarQ := "  "
Local oTitulo
Local oBtn
Local oDlg
Local dDtIni	:= CTOD("01/01/1980","ddmmyy")
Local dDtFin	:= CTOD("01/01/1980","ddmmyy")
Local nTamCodBar	:= TAMSX3("FIG_CODBAR")[1]
Local nTamIdCnab	:= TAMSX3("E2_IDCNAB")[1]
Local lQuery	:= .F.
Local cQuery := ""
Local cAliasFIG := ""
Local cAliasSE2 := ""
Local cCampos := ""
Local nX := 0
Local cFilSE2 	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cNum		:= ""
Local cTipo		:= ""
Local cVencto	:= ""
Local cVencMin	:= ""
Local cVencMax	:= ""
Local cValor	:= ""
Local cValorMin:= ""
Local cValorMax:= ""
Local nValpis := 0
Local nValCof := 0
Local nValCsl := 0
Local nValIrf := 0
Local nValIns := 0
Local nValIss := 0
Local nValImp	:= 0
Local cTitSE2	:= ""
Local cSeqSe2  := ""
Local nValor	:= 0
Local nValorMin:= 0
Local nValorMax:= 0
Local nRecSe2	:= 0
Local nRecDDA	:= 0
Local nRecTrb  := 0
Local dVencMin	:= CTOD("//")
Local dVencMax	:= CTOD("//")
Local cChave	:= ""
Local cCPNEG	:=	MV_CPNEG
Local lPCCBaixa  	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"
Local lInssBx		:= SuperGetMv("MV_INSBXCP",.F.,"2") == "1"
Local lCalcIssBx	:= SuperGetMV("MV_MRETISS",.T.,"1") == "2"
Local lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 

Local oOk	:= LoadBitmap( GetResources(), "ENABLE"		)	//Nivel 1
Local oN2	:= LoadBitmap( GetResources(), "BR_AZUL"		)	//Nivel 2
Local oN3	:= LoadBitmap( GetResources(), "BR_PRETO"		)	//Nivel 3
Local oN4	:= LoadBitmap( GetResources(), "BR_CINZA"		)	//Nivel 4
Local oN5	:= LoadBitmap( GetResources(), "BR_BRANCO"	)	//Nivel 5
Local oN6	:= LoadBitmap( GetResources(), "BR_AMARELO"	)	//Nivel 6
Local oN7	:= LoadBitmap( GetResources(), "BR_LARANJA"	)	//Nivel 7
Local oN8	:= LoadBitmap( GetResources(), "BR_PINK"		)	//Nivel 8
Local oNo	:= LoadBitmap( GetResources(), "DISABLE"		)	//Nivel 9
Local nScan := 0
Local lOk := nil
Local aTab := {}
Local lDup := .F.

Local nNivel:= 9 
Local lF260CHPESQ := Existblock("F260CHPESQ") //esse ponto de entrada � usado como auxilio ao P.E F430GRAFIL da rotina fina430
Local lF260DUPL := Existblock("F260DUPL") //Ponto de Entrada para tratamento de Duplicidades na tabela TRB
Local lChave := .F. //para verificar se a conc ser� usado a condicional de filial de filial de origem.
Local cFilOSE2 := ""
Local lF260LJCON := Existblock("F260LJCON") //Esse ponto de entrada tem por finalidade permitir alterar a loja da tabela FIG 
Local nRecFIG := 0
Local aAreaFIG := {}
Local cLojaFIG := ""
Local lFA260GRS := ExistBlock("FA260GRSE2")
Local lFA260GRF := ExistBlock("FA260GRFIG")

Aadd(aCores,oOk)
Aadd(aCores,oN2)
Aadd(aCores,oN3)
Aadd(aCores,oN4)
Aadd(aCores,oN5)
Aadd(aCores,oN6)
Aadd(aCores,oN7)
Aadd(aCores,oN8)
Aadd(aCores,oNo)

//Array que conterao os registros lockados com o usuario
Private aRLocksSE2 := {}
Private aRLocksFIG := {}

Default lAutomato		:= .F.

//Tratamento para adiantamento tipo NCC
If "|" $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,"|","")
ElseIf "," $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,",","")
Endif
If Mod(Len(cCPNEG),3) > 0
	cCPNEG	+=	Replicate(" ",3-Mod(Len(cCPNEG),3))
Endif

//Verifico se o parametro Vencto de/Ate nao esta vazio
dDtIni	:= Max(dDtIni,Iif(Empty(mv_par09),dDtIni,mv_par09))
dDtFin	:= Max(dDtFin,Iif(Empty(mv_par10),dDtFin,mv_par10))

// Acrescento/diminuo das variaveis para abrir periodo
dDtIni	:= dDtIni - mv_par14
dDtFin	:= dDtFin + mv_par13

#IFDEF TOP
	If TcSrvType() == "AS/400"
		lQuery := .F.
	Else
		lQuery := .T.
	Endif
#ENDIF

//���������������������������������������������������������Ŀ
//� Cria arquivo de trabalho                                �
//�����������������������������������������������������������
F260CRIARQ()

//Filtra dados do FIG - Conciliacao DDA
If lQuery

	FIG->(dbSetOrder(2)) //Filial+Fornecedor+Loja+Vencto+Titulo
   cChave		:= FIG->(IndexKey())
	cAliasFIG	:= GetNextAlias()
	aStru			:= FIG->(dbStruct())
	cCampos		:= ""
	cFilIn 		:= F260Filial()

	aEval(aStru,{|x| cCampos += ","+AllTrim(x[1])})
	cQuery := "SELECT "+SubStr(cCampos,2) + ", R_E_C_N_O_ RECNOFIG "
	cQuery += "FROM " + RetSqlName("FIG") + " FIG  WHERE "
	cQuery +=		"FIG_FILIAL IN "	+ FormatIn(cFilIn,"/") + " AND "
	cQuery += 		"FIG_FORNEC  >= '"+ mv_par04 + "' AND "
	cQuery += 		"FIG_FORNEC  <= '"+ mv_par05 + "' AND "
	cQuery += 		"FIG_LOJA >= '"	+ mv_par06 + "' AND "
	cQuery += 		"FIG_LOJA <= '"	+ mv_par07 + "' AND "
	cQuery +=		"FIG_VENCTO >= '"	+ DTOS(dDtIni) + "' AND "
	cQuery +=		"FIG_VENCTO <= '"	+ DTOS(dDtFin) + "' AND "
	cQuery +=		"FIG_DATA >= '"	+ DTOS(mv_par11) + "' AND "
	cQuery +=		"FIG_DATA <= '"	+ DTOS(mv_par12) + "' AND "
	cQuery += 		"FIG_VALOR > 0 AND "
	cQuery +=		"FIG_CONCIL = '2' AND "
	cQuery +=		"FIG_CODBAR <> '"	+ Space(nTamCodbar) + "' AND "
	cQuery +=		"D_E_L_E_T_ = ' ' "
	cQuery +=	"ORDER BY " + SqlOrder(cChave)

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasFIG,.T.,.T.)

	For nX :=  1 To Len(aStru)
		If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0
			TcSetField(cAliasFIG,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX

Else
	//CODEBASE
	cAliasFIG := "NEWFIG"
	//��������������������������������������������������������������Ŀ
	//� Filtra o SE5 por Banco/Ag./Cta                               �
	//����������������������������������������������������������������
	If Select(cAliasFIG) == 0
		ChkFile("FIG",.F.,cAliasFIG)
	Else
		DbSelectArea(cAliasFIG)
	EndIf
	DbSetOrder(1)
	cChave	:= IndexKey()
	cIndex	:= CriaTrab(nil,.f.)
	If mv_par01 == 1  //Considera filiais
		cQuery +=	"FIG_FILIAL >= '"	+ mv_par02 + "' .AND. "
		cQuery +=	"FIG_FILIAL <= '"	+ mv_par03 + "' .AND. "
	Else
		cQuery +=	"FIG_FILIAL == '"	+ xFilial("FIG") + "' .AND. "
	Endif
	cQuery += 	"FIG_FORNEC  >= '"+ mv_par04 + "' .and. "
	cQuery += 	"FIG_FORNEC  <= '"+ mv_par05 + "' .and. "
	cQuery += 	"FIG_LOJA >= '"	+ mv_par06 + "' .and. "
	cQuery += 	"FIG_LOJA <= '"	+ mv_par07 + "' .and. "
	cQuery +=	"DTOS(FIG_VENCTO) >= '"	+ DTOS(dDtIni) + "' .and. "
	cQuery +=	"DTOS(FIG_VENCTO) <= '"	+ DTOS(dDtFin) + "' .and. "
	cQuery +=	"DTOS(FIG_DATA) >= '"	+ DTOS(mv_par11) + "' .and. "
	cQuery +=	"DTOS(FIG_DATA) <= '"	+ DTOS(mv_par12) + "' .and. "
	cQuery += 	"FIG_VALOR > 0 .and. "
	cQuery +=	"FIG_CONCIL = '2' .and. "
	cQuery +=	"FIG_CODBAR <> '"	+ Space(nTamCodbar) + "'"

	IndRegua("NEWFIG",cIndex,cChave,,cQuery, "Selecionando Registros...") 
	DbSelectArea("NEWFIG")
	nIndexFIG :=RetIndex("FIG","NEWFIG")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetorder(nIndexFig+1)
	dbGoTop()
EndIf
		
If ((cAliasFIG)->(Bof()) .or. (cAliasFIG)->(Eof())) .and. !lAutomato 
	Help(" ",1,"NORECFIG",,"Nenhum registro DDA encontrado"+CHR(10)+"Por favor, verifique parametriza��o",1,0) 
	lSaida := .T.
Else

	While !((cAliasFIG)->(Eof()))

		If !U_IMC260VF(cAliasFIG)
			//�����������������������������������Ŀ
			//� Grava dados no arquivo de trabalho�
			//�������������������������������������
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			cRecTRB := STRZERO(TRB->(Recno()))
			
			nRecFIG := If(lQuery,(cAliasFIG)->RECNOFIG,(cAliasFIG)->(Recno())) 
			cLojaFIG := (cAliasFIG)->FIG_LOJA
			
			If lF260LJCON				
				cLojaFIG := ExecBlock("F260LJCON",.F.,.F., {nRecFIG, cLojaFIG}) 				
			EndIf 

			TRB->SEQMOV 	:= SUBSTR(cRecTRB,-5)
			TRB->SEQCON		:= ""
			TRB->FIL_DDA	:= (cAliasFIG)->FIG_FILIAL
			TRB->FOR_DDA	:= (cAliasFIG)->FIG_FORNEC
			TRB->NOM_DDA    := (cAliasFIG)->FIG_NOMFOR
			TRB->LOJ_DDA	:= cLojaFIG
			TRB->TIT_DDA	:= (cAliasFIG)->FIG_TITULO+"000000"
			TRB->TIP_DDA	:= (cAliasFIG)->FIG_TIPO
			TRB->DTV_DDA	:= (cAliasFIG)->FIG_VENCTO
			TRB->VLR_DDA	:= Transform((cAliasFIG)->FIG_VALOR,"@E 999,999,999,999.99")
			TRB->REC_DDA	:= nRecFIG
			TRB->OK     	:= 9		// NAO CONCILIADO
			TRB->CODBAR		:= (cAliasFIG)->FIG_CODBAR
			MsUnlock()
		Endif
		(cAliasFIG)->(dbSkip())
	Enddo

Endif


//Filtra dados do SE2 - Contas a Pagar
If !lSaida

	//Filtra dados do SE2 - Conciliacao DDA
	If lQuery
		cAliasSE2 := GetNextAlias()
		aStru  := SE2->(dbStruct())
		cCampos := ""
		cFilIn := F260Filial()

		cQuery := "SELECT "
		cQuery +=		"E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,"
		cQuery +=		"E2_VENCTO,E2_VENCREA,E2_VALOR,E2_EMIS1,E2_HIST,E2_SALDO,E2_ACRESC,E2_ORIGEM,E2_TXMOEDA,"
		cQuery +=		"E2_SDACRES,E2_DECRESC,E2_SDDECRE,E2_IDCNAB,E2_FILORIG,E2_CODBAR,E2_STATUS,E2_DTBORDE,E2_PIS,E2_COFINS,E2_CSLL,E2_IRRF,E2_INSS,E2_ISS,"
		cQuery +=		"R_E_C_N_O_ RECNOSE2 "
		cQuery += "FROM " + RetSqlName("SE2") + " SE2  WHERE "
		cQuery +=		"E2_FILIAL IN "	+ FormatIn(cFilIn,"/") + " AND "
		cQuery += 		"E2_FORNECE  >= '"+ mv_par04 + "' AND "
		cQuery += 		"E2_FORNECE  <= '"+ mv_par05 + "' AND "
		cQuery += 		"E2_LOJA >= '"	+ mv_par06 + "' AND "
		cQuery += 		"E2_LOJA <= '"	+ mv_par07 + "' AND "
		//Considera Vencto do titulo
		If mv_par08 == 1
			cQuery +=	"E2_VENCTO >= '"	+ DTOS(dDtIni) + "' AND "
			cQuery +=	"E2_VENCTO <= '"	+ DTOS(dDtFin) + "' AND "

			cChave := "E2_FORNECE+E2_LOJA+DTOS(E2_VENCTO)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"

		//Considera Vencto do titulo
		Else
			cQuery +=	"E2_VENCREA >= '"	+ DTOS(dDtIni) + "' AND "
			cQuery +=	"E2_VENCREA <= '"	+ DTOS(dDtFin) + "' AND "

			cChave := "E2_FORNECE+E2_LOJA+DTOS(E2_VENCREA)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"

		Endif
		cQuery += 		"E2_SALDO > 0 AND "
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(cCPNEG+MVPAGANT,,3) + " AND "
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(MVABATIM,'|') + " AND "
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(MVTXA+"INA",,3) + " AND "
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(MVTAXA,,3) + " AND "
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(MVPROVIS,,3) + " AND "
		cQuery +=		"E2_CODBAR = '"	+ Space(nTamCodbar) + "' AND "
		cQuery +=		"E2_IDCNAB = '"	+ Space(nTamIdCnab) + "' AND "
		cQuery +=		"D_E_L_E_T_ = ' ' "
		cQuery +=	"ORDER BY " + SqlOrder(cChave)

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)

		For nX :=  1 To Len(aStru)
			If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0
				TcSetField(cAliasSE2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	Else
		//CODEBASE
		cAliasSE2 := "NEWSE2"
		//��������������������������������������������������������������Ŀ
		//� Filtra o SE5 por Banco/Ag./Cta                               �
		//����������������������������������������������������������������
		If Select(cAliasSE2) == 0
			ChkFile("SE2",.F.,cAliasSE2)
		Else
			DbSelectArea(cAliasSE2)
		EndIf

		cIndex	:= CriaTrab(nil,.f.)

		If mv_par01 == 1  //Considera filiais
			cQuery :=	"E2_FILIAL >= '"	+ mv_par02 + "' .AND. "
			cQuery +=	"E2_FILIAL <= '"	+ mv_par03 + "' .AND. "
		Else
			cQuery :=	"E2_FILIAL == '"	+ xFilial("SE2") + "' .AND. "
		Endif
		cQuery += 	"E2_FORNECE >= '"+ mv_par04 + "' .and. "
		cQuery += 	"E2_FORNECE <= '"+ mv_par05 + "' .and. "
		cQuery += 	"E2_LOJA >= '"	+ mv_par06 + "' .and. "
		cQuery += 	"E2_LOJA <= '"	+ mv_par07 + "' .and. "
		If mv_par08 == 1
			cQuery +=	"DTOS(E2_VENCTO) >= '"	+ DTOS(dDtIni) + "' .and. "
			cQuery +=	"DTOS(E2_VENCTO) <= '"	+ DTOS(dDtFin) + "' .and. "

			cChave := "E2_FORNECE+E2_LOJA+DTOS(E2_VENCTO)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		Else
			cQuery +=	"DTOS(E2_VENCREA) >= '"	+ DTOS(dDtIni) + "' .and. "
			cQuery +=	"DTOS(E2_VENCREA) <= '"	+ DTOS(dDtFin) + "' .and. "

			cChave := "E2_FORNECE+E2_LOJA+DTOS(E2_VENCREA)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		Endif
		cQuery += 	"E2_SALDO > 0 .and. "
		cQuery +=	"E2_CODBAR = '"	+ Space(nTamCodbar) + "'.And."
		cQuery += 	"!(E2_TIPO $ '" + MV_CPNEG +"/"+MVPAGANT+"/"+ MVABATIM+"/"+MVTXA+"/"+"INA"+"/"+MVTAXA+"/"+MVPROVIS+"')"


		IndRegua("NEWSE2",cIndex,cChave,,cQuery, "Selecionando Registros...") 
		DbSelectArea("NEWSE2")
		nIndexSE2 :=RetIndex("SE2","NEWSE2")
		#IFNDEF TOP
			dbSetIndex(cIndex+OrdBagExt())
		#ENDIF
		dbSetorder(nIndexSE2+1)
		dbGoTop()
	EndIf

	WHILE (cAliasSE2)->(!Eof())
		aAdd(aTab,{	(cAliasSE2)->E2_FILIAL,;
		            (cAliasSE2)->E2_FORNECE,;
		            (cAliasSE2)->E2_LOJA,;
		            If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA ),;
		            Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99"),;
		            If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))})   
		DbSkip()
	EndDo
	dbGoTop()
	If ((cAliasSE2)->(Bof()) .or. (cAliasSE2)->(Eof())) .and. !lAutomato
		Help(" ",1,"NORECSE2",,"Nenhum registro encontrado no arquivo de contas a pagar (SE2)"+CHR(10)+"Por favor, verifique parametriza��o",1,0)
		lSaida := .T.
	Else
		dbSelectArea(cAliasSE2)
		While !((cAliasSE2)->(Eof()))

			nValImp := (cAliasSE2)->E2_VALOR
			// Grava dados do SE2 no arquivo de trabalho
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			cRecTRB := STRZERO(TRB->(Recno()))

			TRB->SEQMOV 	:= SUBSTR(cRecTRB,-5)
			TRB->SEQCON		:= ""
			TRB->FIL_SE2	:= (cAliasSE2)->E2_FILIAL
			TRB->FOR_SE2	:= (cAliasSE2)->E2_FORNECE
			TRB->LOJ_SE2	:= (cAliasSE2)->E2_LOJA
			TRB->NOM_SE2    := (cAliasSE2)->E2_NOMFOR
			TRB->TIT_SE2	:= (cAliasSE2)->(E2_PREFIXO+"-"+E2_NUM+"-"+E2_PARCELA)
			TRB->KEY_SE2	:= (cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA)
			TRB->TIP_SE2	:= (cAliasSE2)->E2_TIPO
			TRB->DTV_SE2	:= If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA )
			TRB->VLR_SE2	:= Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99")
			TRB->PIS_SE2	:= (cAliasSE2)->E2_PIS
			TRB->COF_SE2	:= (cAliasSE2)->E2_COFINS
			TRB->CSL_SE2	:= (cAliasSE2)->E2_CSLL
			TRB->IRF_SE2	:= (cAliasSE2)->E2_IRRF
			TRB->INS_SE2	:= (cAliasSE2)->E2_INSS
			TRB->ISS_SE2	:= (cAliasSE2)->E2_ISS
			TRB->VLQ_SE2	:= Transform((cAliasSE2)->E2_VALOR-(cAliasSE2)->(E2_PIS+E2_COFINS+E2_CSLL),"@E 999,999,999,999.99")
			TRB->REC_SE2	:= If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))
			TRB->OK     	:= 9		// N�O CONCILIADO
			MsUnlock()

         cFilSE2 	:= TRB->FIL_SE2
         cFornece	:= TRB->FOR_SE2
         cLoja		:= TRB->LOJ_SE2
         cNum		:= TRB->KEY_SE2
         cTipo		:= TRB->TIP_SE2
         cVencto	:= DTOS(TRB->DTV_SE2)
		 dVencMin	:= TRB->DTV_SE2- mv_par14
		 dVencMax	:= TRB->DTV_SE2+ mv_par13
		 cVencMin	:= DTOS(dVencMin)
		 cVencMax	:= DTOS(dVencMax)
			
         nValpis 	:= TRB->PIS_SE2
         nValCof 	:= TRB->COF_SE2
         nValCsl 	:= TRB->CSL_SE2
         nValIrf 	:= TRB->IRF_SE2
         nValIns 	:= TRB->INS_SE2
         nValIss 	:= TRB->ISS_SE2  
       
         nValImp -= IIF(lPccBaixa,nValpis+nValCof+nValCsl,0) 

         
         cValor := Transform(nValImp,"@E 999,999,999,999.99")
         
		 nValorMin:= (cAliasSE2)->E2_VALOR - mv_par15
		 nValorMax:= (cAliasSE2)->E2_VALOR + mv_par16
		 cValorMin:= Transform(nValorMin,"@E 999,999,999,999.99")
		 cValorMax:= Transform(nValorMax,"@E 999,999,999,999.99")
		 cTitSE2	:= TRB->TIT_SE2
         nRecSe2	:= TRB->REC_SE2
         cSeqSe2  := TRB->SEQMOV
         nRecTrb  := TRB->(Recno())

			//�����������������������������������������������������������������Ŀ
			//� Tento pre-reconciliacao dentro da 					  					  �
			//� Filial + Fornecedor + Loja + Data Vencto + Valor + Ttulo	     �
			//�������������������������������������������������������������������
			DbSelectArea("TRB")
			DbSetOrder(1)	//FOR_DDA+LOJ_DDA+DTV_DDA+TIT_DDA"
			nRecno := Recno()

			//***************************************************
			// Incluido Data de vencimento  no seek para deixar *
			// a chave de pesquisa mais forte. Caso a mesma nao *
			// seja encontrada a chave sera Forncedeor e Loja   *
			//***************************************************

			IF ((nScan := aScan(aTab,{|x| x[1]==(cAliasSE2)->E2_FILIAL .AND. ;
					x[4]== If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA )  .and.;
					x[5] == Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99") .and. ;
					x[2]+x[3] == (cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA .and. ; 
					x[6] <> If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno())) }))) > 0
				lDup := .T.

				If lF260DUPL
					lDup := ExecBlock("F260DUPL",.F.,.F.,{'ONBUILDTRB','TRB',TRB->SEQMOV,If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))})
				Else
					lDup := .T.
				EndIf
				
				If lDup
					(cAliasSE2)->(dbskip())
					Loop
				EndIf

			ENDIF


			If DbSeek(cFornece + cLoja + cVencto ) .and. ;
				cFilSe2 == TRB->FIL_DDA .and. ;
				Empty(TRB->SEQCON) .and. ;
				TRB->VLR_DDA == cValor .and. ;
				F260Lock(.T.,aRLocksSE2,aRLocksFIG,nRecSe2,TRB->REC_DDA)

				nNivel := 1
				nRecno := Recno()

				DbGoTo(nRecTrb)
				dbDelete()
				dbGoto(nRecno)
				RecLock("TRB")
				TRB->SEQCON 	:= SUBSTR(cRecTRB,-5)
				TRB->FIL_SE2	:= (cAliasSE2)->E2_FILIAL
				TRB->FOR_SE2	:= (cAliasSE2)->E2_FORNECE
				TRB->LOJ_SE2	:= (cAliasSE2)->E2_LOJA
				TRB->NOM_SE2    := (cAliasSE2)->E2_NOMFOR
				TRB->TIT_SE2	:= (cAliasSE2)->(E2_PREFIXO+"-"+E2_NUM+"-"+E2_PARCELA)
				TRB->KEY_SE2	:= (cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA)
				TRB->TIP_SE2	:= (cAliasSE2)->E2_TIPO
				TRB->DTV_SE2	:= If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA )
				TRB->VLR_SE2	:= Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99")
				TRB->VLQ_SE2	:= Transform((cAliasSE2)->E2_VALOR-(cAliasSE2)->(E2_PIS+E2_COFINS+E2_CSLL),"@E 999,999,999,999.99")
				TRB->REC_SE2	:= If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))
				TRB->OK     	:= nNivel	// NIVEL DE CONCILIACAO
				MsUnlock()

			ElseIf DbSeek(cFornece /*+ cLoja*/)
				nRecno := Recno()

				While !(TRB->(Eof())) .and. TRB->(FOR_DDA) == cFornece

					nNivel:= 9 //Nao conciliado

					//------------------------------------------------
					//Chave exata
					//Filial - OK
					//Data Vencto - OK
					//Valor - OK
					If cFilSe2 == TRB->FIL_DDA	 .and. ;
						TRB->VLR_DDA == cValor .and. ;
						DTOS(TRB->DTV_DDA) == cVencto .and.;
						Empty(TRB->SEQCON)
						nNivel := 1
						nRecno := Recno()
						Exit

					//------------------------------------------------
					//Filial - OK
					//Data Vencto - OK
					//Valor - Intervalo
					ElseIf cFilSe2 == TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) == cVencto .and.  ;
							TRB->VLR_DDA >= cValorMin .and. ;
							TRB->VLR_DDA <= cValorMax .and.;
							Empty(TRB->SEQCON)
						nNivel := 2
						nRecno := Recno()
						Exit

					//------------------------------------------------
					//Filial - OK
					//Data Vencto - Intervalo
					//Valor - OK
					ElseIf cFilSe2 == TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) >= cVencMin .and.;
							DTOS(TRB->DTV_DDA) <= cVencMax .and.;
							TRB->VLR_DDA == cValor .and.;
							Empty(TRB->SEQCON)
						nNivel := 3
						nRecno := Recno()
						Exit

					//------------------------------------------------
					//Filial - OK
					//Data Vencto - Intervalo
					//Valor - Intervalo
					ElseIf cFilSe2 == TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) >= cVencMin .and.;
							DTOS(TRB->DTV_DDA) <= cVencMax .and.;
							TRB->VLR_DDA >= cValorMin .and.;
							TRB->VLR_DDA <= cValorMax  .and.;
							Empty(TRB->SEQCON)
						nNivel := 4
						nRecno := Recno()
						Exit

					//------------------------------------------------
					//Filial - Diferente
					//Data Vencto - OK
					//Valor - OK
					ElseIf cFilSe2 != TRB->FIL_DDA	 .and. ;
							TRB->VLR_DDA == cValor .and. ;
							DTOS(TRB->DTV_DDA) == cVencto .and.;
							Empty(TRB->SEQCON)
						nNivel := 5
						nRecno := Recno()
						Exit

					//------------------------------------------------
					//Filial - Diferente
					//Data Vencto - OK
					//Valor - Intervalo
					ElseIf cFilSe2 != TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) == cVencto .and.  ;
							TRB->VLR_DDA >= cValorMin .and. ;
							TRB->VLR_DDA <= cValorMax .and.;
							Empty(TRB->SEQCON)
						nNivel := 6
						nRecno := Recno()
						Exit

					//------------------------------------------------
					//Filial - Diferente
					//Data Vencto - intevalo
					//Valor - OK
					ElseIf cFilSe2 != TRB->FIL_DDA .and. ;
							TRB->VLR_DDA == cValor  .and.  ;
							DTOS(TRB->DTV_DDA) >= cVencMin .and. ;
							DTOS(TRB->DTV_DDA) <= cVencMax .and.;
							Empty(TRB->SEQCON)
						nNivel := 7
						nRecno := Recno()
						Exit

					//------------------------------------------------
					//Filial - Diferente
					//Data Vencto - intervalo
					//Valor - Intervalo
					ElseIf cFilSe2 != TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) >= cVencMin .and.;
							DTOS(TRB->DTV_DDA) <= cVencMax .and.;
							TRB->VLR_DDA >= cValorMin .and.;
							TRB->VLR_DDA <= cValorMax .and.;
							Empty(TRB->SEQCON)
						nNivel := 8
						nRecno := Recno()
						Exit

					Else
						TRB->(dbSkip())
						Loop
					Endif

				Enddo
				IIF(nNivel<9 .and. ValType('lOk')=="U",lOk:=.T.,Nil)
				//Caso houve algum tipo de possibilidade de conciliacao
				If nNivel < 9

					//Caso tenho conseguido travar os registros do SE2 e FIG
					If F260Lock(.T.,aRLocksSE2,aRLocksFIG,nRecSe2,TRB->REC_DDA)   .and. lOk
						DbGoTo(nRecTrb)
						dbDelete()
						dbGoto(nRecno)
						RecLock("TRB")
						TRB->SEQCON 	:= SUBSTR(cRecTRB,-5)
						TRB->FIL_SE2	:= (cAliasSE2)->E2_FILIAL
						TRB->FOR_SE2	:= (cAliasSE2)->E2_FORNECE
						TRB->LOJ_SE2	:= (cAliasSE2)->E2_LOJA
						TRB->NOM_SE2    := (cAliasSE2)->E2_NOMFOR
						TRB->TIT_SE2	:= (cAliasSE2)->(E2_PREFIXO+"-"+E2_NUM+"-"+E2_PARCELA)
						TRB->KEY_SE2	:= (cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA)
						TRB->TIP_SE2	:= (cAliasSE2)->E2_TIPO
						TRB->DTV_SE2	:= If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA )
						TRB->VLR_SE2	:= Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99")
						TRB->VLQ_SE2	:= Transform((cAliasSE2)->E2_VALOR-(cAliasSE2)->(E2_PIS+E2_COFINS+E2_CSLL),"@E 999,999,999,999.99")
						TRB->REC_SE2	:= If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))
						TRB->OK     	:= nNivel	// NIVEL DE CONCILIACAO
						MsUnlock()
					Endif
					lOk := .T.
				Endif

			Endif
			(cAliasSE2)->(dbSkip())

		Enddo
		
		
		If lDup
			If !lAutomato
				Alert("Existe mais de uma chave possivel para a concilia��o autom�tica, por este motivo a concilia��o de alguns t�tulos dever� ser feita de forma manual.")
			EndIf
			If lF260DUPL
				ExecBlock("F260DUPL",.F.,.F.,{'AFTERBUILDTRB','TRB',NIL,NIL})
			EndIf
		EndIf

		dbSelectArea("TRB")
		DbSetOrder(7)	//SEQMOV+FOR_DDA+LOJ_DDA+DTV_DDA+TIT_DDA"
		dbGoTop()
		
		If !lAutomato //Abre interface s� caso n�o for processo automatico 
		
			//������������������������������������������������������Ŀ
			//� Faz o calculo automatico de dimensoes de objetos     �
			//��������������������������������������������������������
			aSize := MSADVSIZE()
	
			DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
			oDlg:lMaximized := .T.
	
			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,30,30,.T.,.T. )
	
			DEFINE SBUTTON FROM 10,250 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oPanel
			DEFINE SBUTTON FROM 10,280 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oPanel
			DEFINE SBUTTON oBtn  FROM 10,310	TYPE 15 ACTION (U_IMC260PE(oTitulo))		ENABLE OF oPanel
			DEFINE SBUTTON oBtn2 FROM 10,340 TYPE 11 ACTION (U_IMC260LT())		ENABLE PIXEL OF oPanel
	
			oBtn:cToolTip	:= "Pesquisa"
			oBtn:cCaption	:= "Pesquisa" 
			oBtn2:cToolTip	:= "Legenda" 
			oBtn2:cCaption	:= "Legenda" 
			oPanel:Align	:= CONTROL_ALIGN_BOTTOM
	
	
			@ 01.0,.5 	LISTBOX oTitulo VAR cVarQ FIELDS ;
					 		HEADER "", 	"Seq."      ,;
										"Filial DDA",;
								 		"Fornec.DDA",;
										"Loja DDA",;
										"Nome For. DDA",;
										"Titulo DDA",;
										"Tipo DDA",;
										"Vencto.DDA",;
										"Valor DDA",;
										"Filial SE2",;
										"Fornec.SE2",;
										"Loja SE2",;
										"Nome For. SE2",;
										"Titulo SE2",;
										"Tipo SE2",;
										"Vencto.SE2",;
										"Valor SE2",;
										"Valor Liq",;
							 COLSIZES 12,GetTextWidth(0,"BBBB"),; 			//SEQ
						 	 			 GetTextWidth(0,"BBBB"),;			//Filial
										 GetTextWidth(0,"BBBBB"),;			//Fornecedor
										 GetTextWidth(0,"BBBB"),;			//Loja
										 GetTextWidth(0,"BBBBBBBBBBBBB"),;//Nome 
										 GetTextWidth(0,"BBBBBBBB"),;		//Titulo
										 GetTextWidth(0,"BBBB"),;			//Tipo
										 GetTextWidth(0,"BBBBBB"),;			//Vencto
										 GetTextWidth(0,"BBBBBBBBB"),;		//Valor
						 	 			 GetTextWidth(0,"BBBB"),;			//Filial
										 GetTextWidth(0,"BBBBB"),;			//Fornecedor
										 GetTextWidth(0,"BBBB"),;			//Loja
										 GetTextWidth(0,"BBBBBBBBBBBBB"),;//Nome 
										 GetTextWidth(0,"BBBBBBBBBBB"),;	//Titulo
										 GetTextWidth(0,"BBBB"),;			//Tipo
										 GetTextWidth(0,"BBBBBB"),;			//Vencto
										 GetTextWidth(0,"BBBBBBBBB"),;		//Valor
										 GetTextWidth(0,"BBBBBBBBB");		//Valor Liq
			SIZE 345,400 ON DBLCLICK	(F260Marca(oTitulo),oTitulo:Refresh()) NOSCROLL
	
			oTitulo:bLine := { || {aCores[TRB->OK],;
											TRB->SEQMOV 	,;
											TRB->FIL_DDA	,;
											TRB->FOR_DDA	,;
											TRB->LOJ_DDA	,;
											TRB->NOM_DDA	,;
											TRB->TIT_DDA	,;
											TRB->TIP_DDA	,;
											TRB->DTV_DDA	,;
											PADR(TRB->VLR_DDA,18),;
											TRB->FIL_SE2	,;
											TRB->FOR_SE2	,;
											TRB->LOJ_SE2	,;
											TRB->NOM_SE2	,;
											TRB->TIT_SE2	,;
											TRB->TIP_SE2	,;
											TRB->DTV_SE2	,;
											PADR(TRB->VLR_SE2,18),;
											PADR(TRB->VLQ_SE2,18) }}
	
			oTitulo:Align := CONTROL_ALIGN_ALLCLIENT
	
			ACTIVATE MSDIALOG oDlg CENTERED
        Else
          nOpca := 1
        Endif     

		If nOpca == 1 .or. lAutomato

			BEGIN TRANSACTION

			dbSelectArea("TRB")
			dbGoTop()
			While !(TRB->(Eof()))
				nRecSE2 := TRB->REC_SE2
				nRecDDA := TRB->REC_DDA

				//Se houve cociliacao
				//Gravo os dados do codigo de barras no SE2
				//Gravo os dados do titulo SE2 na tabela DDA (FIG)
				If nRecSE2 > 0 .and. nRecDDA > 0

					dbSelectArea("SE2")
					dbGoto(nRecSE2)
					If RecLock("SE2",.F.)
						SE2->E2_CODBAR	:= TRB->CODBAR
						cTitSE2			:= SE2->E2_FILIAL+"|"+;
												SE2->E2_PREFIXO+"|"+;
												SE2->E2_NUM+"|"+;
												SE2->E2_PARCELA+"|"+;
												SE2->E2_TIPO+"|"+;
												SE2->E2_FORNECE+"|"+;
												SE2->E2_LOJA+"|"
						//�����������������������������������������������Ŀ
						//�Ponto de Entrada para gravacao complementar SE2�
						//�������������������������������������������������
						If lFA260GRS
							ExecBlock("FA260GRSE2",.F.,.F.)
						Endif

					Endif

					dbSelectArea("FIG")
					dbGoto(nRecDDA)
					If RecLock("FIG",.F.)
						FIG->FIG_DDASE2	:= cTitSE2		//Chave do SE2 com o qual foi conciliado
						FIG->FIG_CONCIL	:= "1" 			//Conciliado
						FIG->FIG_DTCONC	:= dDatabase	//Data da Conciliacao
						FIG->FIG_USCONC	:= cUsername	//Usuario responsavel pela conciliacao

						//�����������������������������������������������Ŀ
						//�Ponto de Entrada para gravacao complementar FIG�
						//�������������������������������������������������
						If lFA260GRF
							ExecBlock("FA260GRFIG",.F.,.F.)
						Endif
					Endif
				EndIf
				dbSelectArea("TRB")
				dbSkip()
				Loop
			Enddo

			END TRANSACTION

		EndIf
	Endif
Endif

//Destravar os registros do SE2 e FIG antes de sair
F260Lock(.F.,aRLocksSE2,aRLocksFIG,,,,.T.)

//Finalizar o arquivo de trabalho
dbSelectArea("TRB")
Set Filter To
dbCloseArea()

//Deleta tabela tempor�ria criada no banco de dados
If _oFINA2601 <> Nil
	_oFINA2601:Delete()
	_oFINA2601 := Nil
Endif

IF SELECT("NEWFIG") != 0
   dbSelectArea( "NEWFIG" )
   dbCloseArea()
   If !Empty(cIndex)
	   FErase (cIndex+OrdBagExt())
   Endif
ENDIF
IF SELECT("NEWSE2") != 0
   dbSelectArea( "NEWSE2" )
   dbCloseArea()
   If !Empty(cIndex)
	   FErase (cIndex+OrdBagExt())
   Endif
ENDIF

dbSelectArea("FIG")
dbSetOrder(1)

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �F260CriArq� Autor � Mauricio Pequim Jr    � Data � 01/10/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria Estrutura do arquivo de trabalho   						  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �F260CriArq() 															  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Nome do indice 1 (passado por referenc)				  ���
���			 � ExpC2 = Nome do indice 2 (passado por referenc)				  ���
���			 � ExpC3 = Nome do indice 3 (passado por referenc)				  ���
���			 � ExpC4 = Nome do indice 4 (passado por referenc)				  ���
���			 � ExpC5 = Nome do indice 5 (passado por referenc)				  ���
���			 � ExpC6 = Nome do indice 6 (passado por referenc)				  ���
���			 � ExpC7 = Nome do indice 7 (passado por referenc)				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 �Generico																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F260CriArq()

Local aDbStru := {}
Local nTamFil := TamSX3("E2_FILIAL")[1]
Local nTamTip := TamSX3("E2_TIPO")[1]
Local nTamFor := TamSX3("E2_FORNECE")[1]
Local nTamLoj := TamSX3("E2_LOJA")[1]
//Ao tamanho do titulo ser�o somados os separadores
Local nTamTit := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]+nTamFil+5
Local nTamKey := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]+nTamTip+nTamFil

//Arquivo de reconciliacao
//Campos de sequencia de conciliacao
aadd(aDbStru,{"SEQMOV","C",05,0})
aadd(aDbStru,{"SEQCON","C",05,0})

//Campos do FIG - Conciliacao DDA
aadd(aDbStru,{"FIL_DDA","C",nTamFil,0})
aadd(aDbStru,{"FOR_DDA","C",nTamFor,0})
aadd(aDbStru,{"LOJ_DDA","C",nTamLoj,0})
aadd(aDbStru,{"NOM_DDA","C",tamSx3("FIG_NOMFOR")[1],0})
aadd(aDbStru,{"TIT_DDA","C",15,0})
aadd(aDbStru,{"TIP_DDA","C",nTamTip,0})
aadd(aDbStru,{"DTV_DDA","D",08,0})
aadd(aDbStru,{"VLR_DDA","C",18,0})


//Campos do SE2 - Cadastro Conta a Pagar
aadd(aDbStru,{"FIL_SE2","C",nTamFil,0})
aadd(aDbStru,{"FOR_SE2","C",nTamFor,0})
aadd(aDbStru,{"LOJ_SE2","C",nTamLoj,0})
aadd(aDbStru,{"NOM_SE2","C",tamSx3("E2_NOMFOR")[1],0})
aadd(aDbStru,{"TIT_SE2","C",nTamTit,0})  //Numero do titulo com separadores (para visualizacao)
aadd(aDbStru,{"TIP_SE2","C",nTamTip,0})
aadd(aDbStru,{"DTV_SE2","D",08,0})
aadd(aDbStru,{"VLR_SE2","C",18,0})
aadd(aDbStru,{"VLQ_SE2","C",18,0})

aadd(aDbStru,{"PIS_SE2","N",18,2})
aadd(aDbStru,{"COF_SE2","N",18,2})
aadd(aDbStru,{"CSL_SE2","N",18,2})
aadd(aDbStru,{"IRF_SE2","N",18,2})
aadd(aDbStru,{"INS_SE2","N",18,2})
aadd(aDbStru,{"ISS_SE2","N",18,2})

aadd(aDbStru,{"KEY_SE2","C",nTamKey,0}) //Numero do titulo sem separadores (para comparacao)

//Campos auxiliares
aadd(aDbStru,{"REC_DDA","N",09,0})
aadd(aDbStru,{"REC_SE2","N",09,0})
aadd(aDbStru,{"OK","N",01,0})
aadd(aDbStru,{"CODBAR","C",44,0})

//------------------
//Cria��o da tabela temporaria 
//------------------
If _oFINA2601 <> Nil
	_oFINA2601:Delete()
	_oFINA2601 := Nil
Endif

_oFINA2601 := FWTemporaryTable():New( "TRB" )  
_oFINA2601:SetFields(aDbStru) 	
_oFINA2601:AddIndex("1", {"FOR_DDA","LOJ_DDA","DTV_DDA","TIT_DDA"}) 	
_oFINA2601:AddIndex("2", {"FOR_DDA","LOJ_DDA","TIT_DDA","DTV_DDA"}) 
_oFINA2601:AddIndex("3", {"TIT_DDA"}) 	
_oFINA2601:AddIndex("4", {"FOR_SE2","LOJ_SE2","DTV_SE2","KEY_SE2"}) 	
_oFINA2601:AddIndex("5", {"FOR_SE2","LOJ_SE2","KEY_SE2","DTV_SE2"}) 
_oFINA2601:AddIndex("6", {"KEY_SE2"}) 	
_oFINA2601:AddIndex("7", {"SEQMOV","FOR_DDA","LOJ_DDA","DTV_DDA","TIT_DDA"}) 	
_oFINA2601:Create()	

Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �F260Marca � Autor � Mauricio Pequim Jr	  � Data � 02/10/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Troca o flag para marcado ou nao,aceitando valor.			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto da ListBox da conciliacao DDA   				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � F260Marca 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F260Marca(oTitulo)
Local oDlg1
Local lRet		:= .T.
Local lIsDDa	:= .F.
Local nOpca1 	:= 0
Local nSequen 	:= 0
Local nRecTRB	:= 0
Local nRecSE2	:= 0
Local nRecDDA	:= 0
Local nRecOrig := 0
Local nValorMin:= 0
Local nValorMax:= 0
Local nReconc	:= TRB->OK
Local cFilTrb 	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cNum		:= ""
Local cTipo		:= ""
Local dVencto	:= ""
Local cValor	:= ""
Local cTitSE2	:= ""
Local cSeqMov  := ""
Local cVencMin	:= ""
Local cVencMax	:= ""
Local cValorMin:= ""
Local cValorMax:= ""
Local cRecTRB	:= ""
Local dVencMin	:= CTOD("//")
Local dVencMax	:= CTOD("//")

If nReconc == 9   // Se n�o reconciliado

	DEFINE MSDIALOG oDlg1 FROM  69,70 TO 160,331 TITLE "Concilia��o DDA" PIXEL 

	@ 0, 2 TO 22, 165 OF oDlg1 PIXEL
	@ 7, 98 MSGET nSequen Picture "99999" VALID (nSequen <= TRB->(RecCount())) .and. (nSequen > 0) SIZE 20, 10 OF oDlg1 PIXEL
	@ 8, 08 SAY  "Sequ�ncia a Conciliar"  SIZE 90, 7 OF oDlg1 PIXEL 
	DEFINE SBUTTON FROM 29, 71 TYPE 1 ENABLE ACTION (nOpca1:=1,If((nSequen <= TRB->(RecCount())) .and. (nSequen > 0),oDLg1:End(),nOpca1:=0)) OF oDlg1
	DEFINE SBUTTON FROM 29, 99 TYPE 2 ENABLE ACTION (oDlg1:End()) OF oDlg1

	ACTIVATE MSDIALOG oDlg1 CENTERED

	IF	nOpca1 == 1

		// Obtenho os dados do registro a conciliar
		cFilTrb 	:= IIF(!Empty(TRB->FIL_DDA),TRB->FIL_DDA,TRB->FIL_SE2)
		cFornece	:= IIF(!Empty(TRB->FOR_DDA),TRB->FOR_DDA,TRB->FOR_SE2)
		cLoja		:= IIF(!Empty(TRB->LOJ_DDA),TRB->LOJ_DDA,TRB->LOJ_SE2)
		cNum		:= IIF(!Empty(TRB->TIT_DDA),TRB->TIT_DDA,TRB->KEY_SE2)
		cTipo		:= IIF(!Empty(TRB->TIP_DDA),TRB->TIP_DDA,TRB->TIP_SE2)
		dVencto	:= IIF(!Empty(TRB->DTV_DDA),TRB->DTV_DDA,TRB->DTV_SE2)
		cValor	:= IIF(!Empty(TRB->VLR_DDA),TRB->VLR_DDA,TRB->VLR_SE2)
		nRecno	:= IIF(!Empty(TRB->REC_DDA),TRB->REC_DDA,TRB->REC_SE2)
		cTitSE2	:= TRB->TIT_SE2
		cSeqMov  := TRB->SEQMOV
		nRecTrb  := TRB->(Recno())
		nRecOrig := Val(TRB->SEQMOV)
		dVencMin	:= dVencto - mv_par14
		dVencMax	:= dVencto + mv_par13
		cVencMin	:= DTOS(dVencMin)
		cVencMax	:= DTOS(dVencMax)
		nValorMin:= DesTrans(cValor) - mv_par15
		nValorMax:= DesTrans(cValor) + mv_par16
		cValorMin:= Transform(nValorMin,"@E 999,999,999,999.99")
		cValorMax:= Transform(nValorMax,"@E 999,999,999,999.99")

		//Verifico se o registro eh DDA ou SE2
		If !Empty(TRB->REC_DDA)
			lIsDDA := .T.
		Endif

		//Posiciono no registro que desejo conciliar
		dbSelectArea("TRB")
		dbGoto(nSequen)

		//Obtenho os recnos originais de cada tabela
		//FIG = nRecDDA
		//SE2 = nRecSE2
		If lIsDDa
			nRecDDA	:= nRecno
			nRecSE2	:= TRB->REC_SE2
		Else
			nRecDDA	:= TRB->REC_DDA
			nRecSE2	:= nRecno
		Endif

		If TRB->OK < 9
			Help(" ",1,"JACONCIL",,"Tentativa de conciliar com movimento j� conciliado",1,0) 
			dbGoto(nRecOrig)
			oTitulo:Refresh()
			lRet := .F.
		Endif

		//Verifica tentativa de conciliar DDA x DDA ou SE2 x SE2
		If lRet .and. ((lIsDDA .and. !Empty(TRB->TIT_DDA)) .or. (!lIsDDA .and. !Empty(TRB->TIT_SE2)))
			Help(" ",1,"NOCONCMT",,"N�o � possivel conciliar registros DDA x DDA ou SE2 x SE2",1,0)
			dbGoto(nRecOrig)
			oTitulo:Refresh()
			lRet := .F.
		Endif


		//Caso consiga reservar os registros nas tabelas originais (SE2 e FIG)
		If lRet .and. F260Lock(.T.,aRLocksSE2,aRLocksFIG,nRecSe2,nRecDDA,.T.)

			If lRet .and. ( IIf (lIsDDA , TRB->(FOR_SE2+LOJ_SE2) != cFornece+cLoja , TRB->(FOR_DDA+LOJ_DDA) != cFornece+cLoja))

				Help(" ",1,"NOCONCFL",,"Fornecedor e Loja dos movimentos n�o conferem",1,0) 
				F260Lock(.F.,aRLocksSE2,aRLocksFIG,nRecSE2,nRecDDA)
				dbGoto(nRecOrig)
				oTitulo:Refresh()
				lRet := .F.
			Endif

			If lRet .and. ( IIf (lIsDDA , ;
				(TRB->(VLR_SE2) < cValorMin .or. TRB->(VLR_SE2) > cValorMax) ,;
				(TRB->(VLR_DDA) < cValorMin .or. TRB->(VLR_DDA) > cValorMax) ))

				Help(" ",1,"NOCONCVL",,"Os valores dos movimentos n�o conferem ou n�o est�o dentro da toler�ncia de valores parametrizada",1,0) 
				F260Lock(.F.,aRLocksSE2,aRLocksFIG,nRecSE2,nRecDDA)
				dbGoto(nRecOrig)
				oTitulo:Refresh()
				lRet := .F.
			Endif

			If  lRet .and. ( IIf (lIsDDA , ;
				( DTOS(TRB->(DTV_SE2)) < cVencMin  .or. DTOS(TRB->(DTV_SE2)) > cVencMax ) ,;
				( DTOS(TRB->(DTV_DDA)) < cVencMin  .or. DTOS(TRB->(DTV_DDA)) > cVencMax ) ) )

				Help(" ",1,"NOCONCDT",,"As datas dos movimentos n�o conferem ou n�o est�o dentro da toler�ncia de datas parametrizada",1,0) 
				F260Lock(.F.,aRLocksSE2,aRLocksFIG,nRecSE2,nRecDDA)
				dbGoto(nRecOrig)
				oTitulo:Refresh()
				lRet := .F.
			Endif

			If lRet
				//Se partiu de um movimetno DDA
				If lIsDDA

					//Pego os dados do titulo SE2
					cFilTrb 	:= TRB->FIL_SE2
					cFornece	:= TRB->FOR_SE2
					cLoja		:= TRB->LOJ_SE2
					cNum		:= TRB->KEY_SE2
					cTipo		:= TRB->TIP_SE2
					dVencto	:= TRB->DTV_SE2
					cValor	:= TRB->VLR_SE2
					nRecTRB	:= TRB->REC_SE2
					cSeqMov	:= TRB->SEQMOV
					cTitSE2	:= TRB->TIT_SE2

					DbSelectArea("TRB")
					dbDelete()

					dbGoTo(nRecOrig)
					//Gravo os dados SE2 no registro a conciliar (digitado)
					RecLock("TRB")
					TRB->SEQCON 	:= cSeqMov
					TRB->FIL_SE2	:= cFilTrb
					TRB->FOR_SE2	:= cFornece
					TRB->LOJ_SE2	:= cLoja
					TRB->TIT_SE2	:= cTitSE2	//Com separador
					TRB->KEY_SE2	:= cNum		//Sem separador
					TRB->TIP_SE2	:= cTipo
					TRB->DTV_SE2	:= dVencto
					TRB->VLR_SE2	:= cValor
					TRB->REC_SE2	:= nRecSE2
					TRB->OK     	:= 1	// NIVEL DE CONCILIACAO - Conciliado pelo Usu�rio
					MsUnlock()

	         Else

					//Gravo os dados DDA no registro a conciliar (digitado)
					RecLock("TRB")
					TRB->SEQCON 	:= cSeqMov
					TRB->FIL_SE2	:= cFilTrb
					TRB->FOR_SE2	:= cFornece
					TRB->LOJ_SE2	:= cLoja
					TRB->KEY_SE2	:= cNum		//Sem separador
					TRB->TIT_SE2	:= cTitSE2	//Com separador
					TRB->TIP_SE2	:= cTipo
					TRB->DTV_SE2	:= dVencto
					TRB->VLR_SE2	:= cValor
					TRB->VLQ_SE2	:= Transform(0.00,"@E 999,999,999,999.99")
					TRB->REC_SE2	:= nRecSE2
					TRB->OK     	:= 1	// NIVEL DE CONCILIACAO - Conciliado pelo Usu�rio
					MsUnlock()

					//Deleto o registro
					dbGoTo(nRecOrig)
					dbDelete()
					MsUnlock()

					//Atualizo a tela
					dbGoto(nSequen)
					oTitulo:Refresh()
				Endif
			Endif
		Endif
	Endif
Else
	DEFINE MSDIALOG oDlg1 FROM  69,70 TO 165,331 TITLE  "Concilia��o DDA" PIXEL 
	@  0, 2 TO 28, 128 OF oDlg1	PIXEL
	@  7.5,  9 SAY  "Esta movimenta��o j� se encontra conciliada"  SIZE 115, 7 OF oDlg1 PIXEL 
	@ 14  ,  9 SAY  "Deseja cancelar a concilia��o ?"  SIZE 100, 7 OF oDlg1 PIXEL 
	DEFINE SBUTTON FROM 32, 71 TYPE 1 ENABLE ACTION (nOpca1:=1,oDlg1:End()) OF oDlg1
	DEFINE SBUTTON FROM 32, 99 TYPE 2 ENABLE ACTION (oDlg1:End()) OF oDlg1

	ACTIVATE MSDIALOG oDlg1 CENTERED

	IF	nOpca1 == 1
		//��������������������������������������������������������������Ŀ
		//� Cancela reconcilia��o                               			  �
		//����������������������������������������������������������������
		nRecOrig := VAL(TRB->SEQMOV)
		nSeqSE2	:= VAL(TRB->SEQCON)
		nRecSE2	:= TRB->REC_SE2
		nRecDDA	:= TRB->REC_DDA

		//Limpo os dados do registro de SE2 conciliado
		dbSelectArea("TRB")
		TRB->FIL_SE2 	:= Space(Len(TRB->FIL_SE2))
		TRB->FOR_SE2 	:= Space(Len(TRB->FOR_SE2))
		TRB->LOJ_SE2 	:= Space(Len(TRB->LOJ_SE2))
		TRB->TIT_SE2 	:= Space(Len(TRB->TIT_SE2))
		TRB->TIP_SE2 	:= Space(Len(TRB->TIP_SE2))
		TRB->DTV_SE2 	:= CTOD("//")
		TRB->VLR_SE2 	:= Space(Len(TRB->VLR_SE2))
		TRB->VLQ_SE2 	:= Space(Len(TRB->VLQ_SE2))
		TRB->KEY_SE2 	:= Space(Len(TRB->KEY_SE2))
		TRB->REC_SE2	:= 0
		TRB->SEQCON		:= Space(5)
		TRB->OK			:= 9

		//Recupera o Registro Deletado
		SET DELETED OFF
		dbGoTo(nSeqSE2)
		dbRecall()
		TRB->OK := 9
		SET DELETED ON
		dbGoto(nRecOrig)

		//Destrava registros nas tabelas originais (SE2 e FIG)
		F260Lock(.F.,aRLocksSE2,aRLocksFIG,nRecSE2,nRecDDA)

	Endif
Endif
oTitulo:Refresh()

Return lRet



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �F260Canc  � Autor � Mauricio Pequim Jr    � Data � 03/10/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de cancelamento de conciliacao DDA					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � F260Canc(ExpC1,ExpN1,ExpN2)										  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo											  ���
���			 � ExpN1 = Numero do registro 										  ���
���			 � ExpN2 = Numero da opcao selecionada 							  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user Function IMC260CA(cAlias,nReg,nOpc,lAutomato)

Local nOpcA			:= 0
Local nSavRec		:= (cAlias)->(RecNo())
Local oDlg
Local nX				:= 0
Local aDadosSE2	:= {}
Local lRet			:= .T.
Local lF260Comp := Existblock("F260COMP")

Default lAutomato := .F.

dbSelectArea(cAlias)

//������������������������������������������������Ŀ
//� Limpa aGet e aTela              					�
//��������������������������������������������������
aGets := { }
aTela := { }

If !lAutomato
	//Registro n�o relacionado
	If Empty(FIG->FIG_DDASE2)
		MsgAlert("Registro n�o conciliado.") 
		lRet := .F.
	Endif
	
	//Registro relacionado porem o registro do SE2 foi excluido
	If lRet
		aDadosSE2 := STRTOKARR(FIG->FIG_DDASE2,"|")
		dbSelectArea("SE2")
		dbSetOrder(1)		//Filial+Prefixo+Numero+Parcela+Tipo+Fornecedor+Loja
		If !MsSeek(aDadosSe2[1]+aDadosSe2[2]+aDadosSe2[3]+aDadosSe2[4]+aDadosSe2[5]+aDadosSe2[6]+aDadosSe2[7])
			MsgAlert("Registro de Contas a pagar n�o encontrado. N�o ser� possivel cancelar esta concilia��o.") 
			lRet := .F.
		Endif
	Endif
	
	//Validar se titulo totalmente baixado
	If lRet .and. SE2->E2_SALDO == 0
		MsgAlert ("O titulo relacionado a esta concilia��o se encontra totalmente baixado."+CHR(13)+"N�o ser� possivel o cancelamento da concilia��o.") 
		lRet := .F.
	Endif
Endif

If lRet
	dbSelectArea(cAlias)
	If !SoftLock(cAlias)
		lRet := .F.
	EndIf
Endif


If lRet
	aSize := MsAdvSize()
	DEFINE MSDIALOG oDlg TITLE "Cancelamento Conciliacao DDA" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL 
	oDlg:lMaximized := .T.

	dbSelectArea("FIG")
	RegToMemory("FIG",.F.)

	/////////////////
	// painel 1 - MSMGET - Dados do registro DDA

	oPanel1 := TPanel():New(0,0,'Dados DDA',oDlg,, .T., .T.,CLR_WHITE,CLR_BLUE,10,10,.F.,.F.)
	oPanel1:Align := CONTROL_ALIGN_TOP

	oPanel2 := TPanel():New(0,0,'Dados DDA',oDlg,, .T., .T.,, ,110,110,.F.,.F.)
	oPanel2:Align := CONTROL_ALIGN_TOP

	oEnch2:= MsMGet():New( cAlias, nReg, 2,,"AC",,,,,,,,,oPanel2)
	oEnch2:oBox:Align := CONTROL_ALIGN_ALLCLIENT

	/////////////////
	// painel 2 - MsGetDados - Dados dos titulos gerados pelo desdobramento
	// painel 2 - MSMGET - Dados do registro SE2 relacionado
	aGets := { }
	aTela := { }

	If !lAutomato
		dbSelectArea("SE2")
		RegToMemory("SE2",.F.,,,,FunName())
	Endif
	
	If !SoftLock("SE2")
		Return
	EndIf
	
	If !lAutomato
	
		oPanel3 := TPanel():New(0,0,'Dados SE2',oDlg,, .T., .T.,CLR_WHITE,CLR_BLUE,10,10,.F.,.F.)
		oPanel3:Align := CONTROL_ALIGN_TOP

		oPanel4 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,25,25,.F.,.F.)  //'Dados do Rastreamento'
		oPanel4:Align := CONTROL_ALIGN_ALLCLIENT

		oEnch4 := MsMGet():New( "SE2", SE2->(recno()),2,,"AC",,,,,,,,,oPanel4)
		oEnch4:oBox:Align := CONTROL_ALIGN_ALLCLIENT

		nOpca := 0
	
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 0,oDlg:End()}) CENTER
	Else
		nOpcA := 1
	Endif 	

	If nOpcA == 1

		//VALIDAR SE SE2 n�o tem IDCNAB (enviado ao banco)
		If !Empty(SE2->E2_IDCNAB) .and. !lAutomato
			If !MsgYesNo("Este t�tulo possui IDCNAB preenchido e pode ter sido enviado para pagamento via CNAB. Confirma cancelamento?","Aten��o")
				lRet := .F.
			Endif
		Endif

		If lRet

			BEGIN TRANSACTION

			//Limpa codigo de barras na tabela SE2
			Reclock("SE2")
			SE2->E2_CODBAR := Space(TamSx3("E2_CODBAR")[1])
			MsUnlock()

			//Limpa dados da conciliacao DDA na tabela FIG
			Reclock("SE2")
			FIG->FIG_CONCIL	:= "2"
			FIG->FIG_DTCONC	:= CTOD("//")
			FIG->FIG_USCONC	:= Space(TamSx3("FIG_USCONC")[1])
			FIG->FIG_DDASE2	:= ""
			MsUnlock()

			END TRANSACTION
		Endif

		If lF260Comp
			Execblock("F260COMP",.F.,.F.)
		EndIf

	Endif
Endif
MsUnlock()

dbSelectArea(cAlias)
(cAlias)->(dbGoTo(nSavRec))

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �FIMC260AL  � Autor � Mauricio Pequim Jr    � Data � 03/10/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Alteracao da Conciliacao DDA   					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � FIMC260AL(ExpC1,ExpN1,ExpN2)										  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo											  ���
���			 � ExpN1 = Numero do registro 										  ���
���			 � ExpN2 = Numero da opcao selecionada 							  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user Function IMC260AL(cAlias,nReg,nOpc)

Local aCpos	:= {}
Local cTudoOK := ".T."

If FIG->( EOF()) .or. xFilial("FIG") # FIG->FIG_FILIAL
	Help(" ",1,"ARQVAZIO")
	Return .T.
Endif

If !U_IMC260VF()
	Help(" ",1,"NOALTER",,"Este registro n�o permite altera��es. Apenas titulos com dados a verificar podem sofrer altera��o. Vide Legenda.",1,0)
	Return .T.
Endif

Aadd(aCpos,"FIG_FORNEC")
Aadd(aCpos,"FIG_LOJA")
Aadd(aCpos,"FIG_NOMFOR")
Aadd(aCpos,"FIG_CODBAR")
Aadd(aCpos,"FIG_TITULO")
Aadd(aCpos,"FIG_VENCTO")

lAltera:=.T.

nOpca := AxAltera(cAlias,nReg,nOpc,,aCpos,4,,cTudoOK)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �IMC260PE  � Autor � Mauricio Pequim Jr.   � Data �04.10.09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela de pesquisa           										  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto da ListBox da conciliacao DDA   				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IMC260PE(oTitulo)

Local nRecno		:= 0
Local aPesqui		:={}
Local cSeek			:= ""
Local nIndex		:= 1

dbSelectArea("TRB")
nRecno	:= Recno()
nIndex	:= IndexOrd()

aAdd(aPesqui,{"Fornecedor DDA + Loja DDA + Vencto. DDA + Titulo DDA",1})
aAdd(aPesqui,{"Fornecedor DDA + Loja DDA + Titulo DDA + Vencto. DDA",2})
aAdd(aPesqui,{"Titulo DDA",3})
aAdd(aPesqui,{"Fornecedor SE2 + Loja SE2 + Vencto. SE2 + Titulo SE2",4})
aAdd(aPesqui,{"Fornecedor SE2 + Loja SE2 + Titulo SE2 + Vencto. SE2",5})
aAdd(aPesqui,{"Titulo SE2",6})

WndxPesqui(,aPesqui,cSeek,.F.)

dbSelectArea("TRB")
dbSetOrder(nIndex)

//Caso n�o tenha achado, volto para o registro de partida
IF TRB->(EOF())
	TRB->(dbgoto(nRecno))
Endif

oTitulo:Refresh()

Return Nil


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �IMC260LE()� Autor � Mauricio Pequim Jr.   � Data �04.10.09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela de Legenda - Browse   										  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Recno do registro posicionado no browse				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IMC260LE(nReg)

Local uRetorno := {}
Local aLegenda := {}

Aadd(aLegenda, {"ENABLE" , "DDA Conciliado"})
Aadd(aLegenda, {"DISABLE", "DDA N�o Conciliado"})
Aadd(aLegenda, {"BR_AMARELO","DDA Verificar dados"})


If nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
	uRetorno := {}

	Aadd(uRetorno, { 'U_IMC260VF()'				, aLegenda[3][1] } )
	Aadd(uRetorno, { 'FIG->FIG_CONCIL == "1"'	, aLegenda[1][1] } )
	Aadd(uRetorno, { 'FIG->FIG_CONCIL == "2"'	, aLegenda[2][1] } )

Else

	BrwLegenda(cCadastro, "Legenda", aLegenda)
Endif

Return uRetorno


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �IMC260LT� Autor � Mauricio Pequim Jr.   � Data �04.10.09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela de Legenda - Tela Conciliacao								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 																			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IMC260LT()

Local aLegenda := {}
Local nY     	:= 0
Local nX     	:= 0
Local aBmp[9]
Local aSays[9]
Local oDlgLeg

Aadd(aLegenda, {"ENABLE"		, "Conciliado: Fornecedor + Loja OK, Filial OK, Valor OK, Vencimento OK"})	//"Conciliado: Fornecedor + Loja OK, Filial OK, Valor OK, Vencimento OK"
Aadd(aLegenda, {"BR_AZUL"		, "Conciliado: Fornecedor + Loja OK, Filial OK, Valor IN, Vencimento OK"})	//"Conciliado: Fornecedor + Loja OK, Filial OK, Valor IN, Vencimento OK"
Aadd(aLegenda, {"BR_PRETO"		, "Conciliado: Fornecedor + Loja OK, Filial OK, Valor OK, Vencimento IN"})	//"Conciliado: Fornecedor + Loja OK, Filial OK, Valor OK, Vencimento IN"
Aadd(aLegenda, {"BR_CINZA"		, "Conciliado: Fornecedor + Loja OK, Filial OK, Valor IN, Vencimento IN"})	//"Conciliado: Fornecedor + Loja OK, Filial OK, Valor IN, Vencimento IN"
Aadd(aLegenda, {"BR_BRANCO"	    , "Conciliado: Fornecedor + Loja OK, Filial IN, Valor OK, Vencimento OK"})	//"Conciliado: Fornecedor + Loja OK, Filial IN, Valor OK, Vencimento OK"
Aadd(aLegenda, {"BR_AMARELO"	, "Conciliado: Fornecedor + Loja OK, Filial IN, Valor IN, Vencimento OK"})	//"Conciliado: Fornecedor + Loja OK, Filial IN, Valor IN, Vencimento OK"
Aadd(aLegenda, {"BR_LARANJA"	, "Conciliado: Fornecedor + Loja OK, Filial IN, Valor OK, Vencimento IN"})	//"Conciliado: Fornecedor + Loja OK, Filial IN, Valor OK, Vencimento IN"
Aadd(aLegenda, {"BR_PINK"		, "Conciliado: Fornecedor + Loja OK, Filial IN, Valor IN, Vencimento IN"})	//"Conciliado: Fornecedor + Loja OK, Filial IN, Valor IN, Vencimento IN"
Aadd(aLegenda, {"DISABLE"		, "N�o Conciliado"})	//"N�o Conciliado"

DEFINE MSDIALOG oDlgLeg FROM 0,0 TO (Len(aLegenda)*20)+110, 500 TITLE cCadastro OF oMainWnd PIXEL

	//�����������������������������������������Ŀ
	//�No onclick do usuario a tela sera fechada�
	//�������������������������������������������
	oDlgLeg:bLClicked:= {||oDlgLeg:End()}

	//����������������������������������������������Ŀ
	//�Fonte especifico para a descricao das legendas�
	//������������������������������������������������
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	DEFINE FONT oBold2 NAME "Arial" SIZE 0, -11 BOLD

	//������������������
	//�Desenho de fundo�
	//������������������
	@ 0, 0 BITMAP RESNAME "PROJETOAP" OF oDlgLeg SIZE 35,155 NOBORDER WHEN .F. PIXEL

	@ 11,35 TO 013,400 LABEL '' OF oDlgLeg PIXEL
	@ 03,37 SAY "Legenda" OF oDlgLeg PIXEL SIZE 150,009 FONT oBold		//"Legenda"
	For nX := 1 to Len(aLegenda)
		@ 20+((nX-1)*10),43 BITMAP aBmp[nX] RESNAME aLegenda[nX][1] OF oDlgLeg SIZE 20,10 PIXEL NOBORDER
		@ 20+((nX-1)*10),53 SAY If((nY+=1)==nY,aLegenda[nY][2]+If(nY==Len(aLegenda),If((nY:=0)==nY,"",""),""),"") OF oDlgLeg PIXEL
	Next nX
	nY := 0
	@ 120,37 SAY "OK - Valor Exato" OF oDlgLeg PIXEL SIZE 150,009 FONT oBold2 		//"OK - Valor Exato"
	@ 130,37 SAY "IN - Valor dentro do intervalo definido" OF oDlgLeg PIXEL SIZE 150,009 FONT oBold2 		//"IN - Valor dentro do intervalo definido"

ACTIVATE MSDIALOG oDlgLeg CENTERED

Return(NIL)

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �IMC260VF � Autor � Mauricio Pequim Jr.   � Data �04.10.09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verificacao de status do registro DDA com necessidade de   ���
���          � de verificacao de dados                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do FIG (arquivo de dados DDA)					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IMC260VF(cAliasFIG)

Local lRet := .F.

DEFAULT cAliasFIG := "FIG"


If Empty((cAliasFIG)->FIG_FORNEC) .OR. Empty((cAliasFIG)->FIG_CODBAR) .OR. ;
	Empty((cAliasFIG)->FIG_TITULO) .OR. Empty((cAliasFIG)->FIG_VENCTO) .OR. ;
	Empty((cAliasFIG)->FIG_VALOR)  .OR. Empty((cAliasFIG)->FIG_CNPJ)
	lRet := .T.
Endif

Return lRet


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �F260Filial� Autor � Mauricio Pequim Jr.   � Data �04.10.09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Montagem da String de filiais a serem utilizadas no 		  ���
���          � processo de filtragem dados - TOP                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                            					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function F260Filial()
Local cFilIn	:= ""
Local nInc		:= 0
Local aSM0		:= aSM0 := AdmAbreSM0()

//Considero filiais do intervalo e arquivos exclusivos
If mv_par01 == 1 .and. !Empty(xFilial("SE2"))
	//Arquivos Exclusivos
	For nInc := 1 To Len( aSM0 )
		If aSM0[nInc][2] >= mv_par02 .and. aSM0[nInc][2] <= mv_par03
			cFilIn += aSM0[nInc][2] + "/"
		EndIf
	Next
Else
	cFilIn := xFilial("SE2")
Endif

Return cFilIn


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �F260Lock  � Autor � Mauricio Pequim Jr.   � Data �04.10.09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para controle de travamento e destravamento dos     ���
���          � registros utilizados por um determinado usuario            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 = Rotina para travamento dos registros do SE2 e FIG  ���
���          � ExpA2 = Array p/ guardar registros SE2 em uso pelo usuario ���
���          � ExpA3 = Array p/ guardar registros FIG em uso pelo usuario ���
���          � ExpN4 = Numero do registro do SE2 que se quer travar       ���
���          � ExpN5 = Numero do registro do FIG que se quer travar       ���
���          � ExpL6 = Mostra Help em caso de nao travamento do registro  ���
���          � ExpL7 = Destravamento de todos os registros                ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function F260Lock(lLock,aRLocksSE2,aRLocksFIG,nRecnoSE2,nRecnoFIG,lHelp,lTodos)

Local aArea	:= GetArea()
Local nPosRec
Local lSE2	:= .F.
Local	lFIG	:= .F.
Local lRet	:= .F.

DEFAULT lLock := .F.		//Travamento ou destravamento dos registros
DEFAULT lHelp := .F.		//Mostra help ou nao
DEFAULT lTodos:= .F.		//Libera todos os registros
DEFAULT aRLocksSE2:={}	//Array de registros do SE2 lockados com o usuario
DEFAULT aRLocksFIG:={}	//Array de registros do FIG lockados com o usuario

If lTodos
	//Destrava todos os registros - Final do processamento
	AEval(aRLocksSE2,{|x,y| SE2->(MsRUnlock(x))})
	aRLocksSE2:={}

	AEval(aRLocksFIG,{|x,y| FIG->(MsRUnlock(x))})
	aRLocksFIG:={}

Else
	//Controle de marcacao ou desmarcaao dos titulos
	If nRecnoSE2 <> Nil
		SE2->(MsGoto(nRecnoSE2))
		lSE2	:= .T.
	Endif

	If nRecnoFIG <> Nil
		FIG->(MsGoto(nRecnoFIG))
		lFIG	:= .T.
	Endif

	If lLock //Rotina chamada para travamento dos registros do SE2 e FIG

		//A conciliacao somente sera permitida quando os registros do SE2 e FIG puderem ser travados
		//Caso um deles esteja em uso por outro terminal, nao sera permitida a conciliacao
		If lSE2 .and. lFIG
			If SE2->(MsRLock()) .and. FIG->(MsRLock())
				AAdd(aRLocksSE2, SE2->(Recno()))
				AAdd(aRLocksFIG, FIG->(Recno()))
				lRet	:=	.T.
			ElseIf lHelp
				MsgAlert("Um dos registros re�acionados est� sendo utilizado em outro terminal e n�o pode ser utilizado na Concilia��o DDA")	
			Endif
		Endif
	Else
		If lSE2 .and. lFIG
			//Destravo registro no SE2
			SE2->(MsRUnlock(SE2->(Recno())))
			If (nPosRec:=Ascan(aRlocksSE2,SE2->(Recno()))) > 0
				Adel(aRlocksSE2,nPosRec)
				aSize(aRlocksSE2,Len(aRlocksSE2)-1)
			Endif
			//Destravo registro no FIG
			FIG->(MsRUnlock(FIG->(Recno())))
			If (nPosRec:=Ascan(aRlocksFIG,FIG->(REcno()))) > 0
				Adel(aRlocksFIG,nPosRec)
				aSize(aRlocksFIG,Len(aRlocksFIG)-1)
			Endif
		Endif
	Endif
Endif

If aArea <> Nil
	RestArea(aArea)
Endif

Return lRet




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �FDDAInUse	�Autor  �Mauricio Pequim Jr. � Data �  28/09/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para verificar o tratamento de DDA						  ���
�������������������������������������������������������������������������͹��
���Uso       � Generico - DDA				                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FDdaInUse()

//Controla o uso do DDA - Debito Direto Autorizado no Sistema)
Local lDdaInUse := cPaisLoc == "BRA"

Return lDdaInUse


/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Mauricio Pequim Jr    � Data �29/09/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
Local aRotina       := {	{ "Pesquisar"	,"AxPesqui"	, 0 , 1 , ,.F. }	,;  //"Pesquisar"
							{ "Visualizar"	,"AxVisual"	, 0 , 2 }       	,;	//"Visualizar"
							{ "Conciliar"	,"U_IMC260CO"	, 0 , 3 }	    ,;	//"Conciliar"
							{ "Alterar"	    ,"U_IMC260AL"	, 0 , 4 }		,;	//"Alterar"
							{ "Cancelar"	,"U_IMC260CA"	, 0 , 5 }		,;	//"Cancelar"
							{ "Legenda"	    ,"U_IMC260LE"	, 0 , 6 , ,.F. } }  //"Legenda"

	IF ExistBlock("F260BUT")
  		aRotina := ExecBlock("F260BUT",.F.,.F.,aRotina)
	Endif
Return(aRotina)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AdmAbreSM0� Autor � Orizio                � Data � 22/01/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna um array com as informacoes das filias das empresas ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AdmAbreSM0()
	Local aArea			:= SM0->( GetArea() )
	Local aAux			:= {}
	Local aRetSM0		:= {}
	Local lFWLoadSM0	:= .T.
	Local lFWCodFilSM0 	:= .T.

	If lFWLoadSM0
		aRetSM0	:= FWLoadSM0()
	Else
		DbSelectArea( "SM0" )
		SM0->( DbGoTop() )
		While SM0->( !Eof() )
			aAux := { 	SM0->M0_CODIGO,;
						IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
						"",;
						"",;
						"",;
						SM0->M0_NOME,;
						SM0->M0_FILIAL }

			aAdd( aRetSM0, aClone( aAux ) )
			SM0->( DbSkip() )
		End
	EndIf

	RestArea( aArea )
Return aRetSM0

