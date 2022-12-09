#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o     � MATR435  � Autor �Alexandre Inacio Lemes� Data �28/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o  � Kardex p/ Lote Sobre o SD5                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe    � MATR435(void)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso       � Generico                                                  ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function RMAT435()

	Local oReport

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RMAT435" , __cUserID )

	//If FindFunction("TRepInUse") .And. TRepInUse()
	//����������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                �
	//������������������������������������������������������������������������
	//	oReport:= U_ReportDef()
	//	oReport:PrintDialog()
	//Else
	U_RMAT435R3()
	//EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Inacio Lemes �Data  �28/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Kardex p/ Lote Sobre o SD5                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function ReportDef()

	Local cTitle      := "Kardex por Lote/Sub-Lote (por produto)"
	Local cPicSaldo   := PesqPict("SB8","B8_SALDO"  ,18)
	Local cPicEmpenho := PesqPict("SB8","B8_EMPENHO",18)
	Local oReport
	Local oSection1
	Local oSection2
	Local oSection3

	#IFDEF TOP
	Local cAliasSB8 := GetNextAlias()
	#ELSE
	Local cAliasSB8 := "SB8"
	#ENDIF

	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros                     	 �
	//� mv_par01       	// Do  Produto                         	 	 �
	//� mv_par02        // Ate Produto                         	 	 �
	//� mv_par03        // De  Lote                            	 	 �
	//� mv_par04        // Ate Lote			        			 	 �
	//� mv_par05        // De  Sub-Lote                          	 �
	//� mv_par06        // Ate Sub-Lote			        		 	 �
	//� mv_par07        // De  Local		        			 	 �
	//� mv_par08        // Ate Local							 	 �
	//� mv_par09        // De  Data			        			 	 �
	//� mv_par10        // Ate Data								 	 �
	//� mv_par11       	// Lotes/Sub S/ Movimentos (Lista/Nao Lista) �
	//� mv_par12       	// Lote/Sub Saldo Zerado   (Lista/Nao Lista) �
	//� mv_par13       	// QTDE. na 2a. U.M. ?     (Sim/Nao)         �
	//����������������������������������������������������������������

	Pergunte("MR435A",.F.)
	//������������������������������������������������������������������������Ŀ
	//�Criacao do componente de impressao                                      �
	//�                                                                        �
	//�TReport():New                                                           �
	//�ExpC1 : Nome do relatorio                                               �
	//�ExpC2 : Titulo                                                          �
	//�ExpC3 : Pergunte                                                        �
	//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
	//�ExpC5 : Descricao                                                       �
	//�                                                                        �
	//��������������������������������������������������������������������������
	//������������������������������������������������������������������������Ŀ
	//� Descricao do Relatorio                                                 �
	//�                                                                        �
	//� STR0001	//"Este programa emitir� um Kardex com todas as movimenta��es" �
	//� STR0002	//"do estoque por Lote/Sub-Lote, diariamente. Observa��o: o 1o"�
	//� STR0003	//"movimento de cada Lote/Sub-Lote se refere a cria��o do mesmo�
	//��������������������������������������������������������������������������
	oReport:= TReport():New("U_RMAT435",cTitle,"MR435A", {|oReport| U_ReportPrint(oReport,cAliasSB8)},"Kardex por lote")
	oReport:SetTotalInLine(.F.)
	oReport:SetPortrait()
	//������������������������������������������������������������������������Ŀ
	//�Criacao da secao utilizada pelo relatorio                               �
	//�                                                                        �
	//�TRSection():New                                                         �
	//�ExpO1 : Objeto TReport que a secao pertence                             �
	//�ExpC2 : Descricao da se�ao                                              �
	//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
	//�        sera considerada como principal para a se��o.                   �
	//�ExpA4 : Array com as Ordens do relat�rio                                �
	//�ExpL5 : Carrega campos do SX3 como celulas                              �
	//�        Default : False                                                 �
	//�ExpL6 : Carrega ordens do Sindex                                        �
	//�        Default : False                                                 �
	//�                                                                        �
	//��������������������������������������������������������������������������
	//������������������������������������������������������������������������Ŀ
	//�Criacao da celulas da secao do relatorio                                �
	//�                                                                        �
	//�TRCell():New                                                            �
	//�ExpO1 : Objeto TSection que a secao pertence                            �
	//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
	//�ExpC3 : Nome da tabela de referencia da celula                          �
	//�ExpC4 : Titulo da celula                                                �
	//�        Default : X3Titulo()                                            �
	//�ExpC5 : Picture                                                         �
	//�        Default : X3_PICTURE                                            �
	//�ExpC6 : Tamanho                                                         �
	//�        Default : X3_TAMANHO                                            �
	//�ExpL7 : Informe se o tamanho esta em pixel                              �
	//�        Default : False                                                 �
	//�ExpB8 : Bloco de c�digo para impressao.                                 �
	//�        Default : ExpC2                                                 �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oSection1:= TRSection():New(oReport,"Produtos",{"SB8","SB1","SB2"}) //"Produtos"
	oSection1:SetTotalInLine(.F.)
	oSection1:SetTotalText(" ")
	oSection1:SetLineStyle()
	oSection1:SetNoFilter("SB1")
	oSection1:SetNoFilter("SB2")

	TRCell():New(oSection1,"B8_PRODUTO","SB8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1_DESC"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1_TIPO"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1_UM"     ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(mv_par13 <> 1 ,SB1->B1_UM,SB1->B1_SEGUM)})
	TRCell():New(oSection1,"B2_LOCALIZ","SB2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	oSection2:= TRSection():New(oSection1,"Saldos por lote",{"SB8"}) //"Saldos por Lote"
	oSection2:SetTotalInLine(.F.)
	oSection2:SetTotalText(" ")
	oSection2:SetLineStyle()

	TRCell():New(oSection2,"B8_NUMLOTE","SB8","Sub Lote: "	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B8_LOTECTL","SB8","Lote: "	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"SP1"       ,"   "," "		,/*Picture*/,47			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"SALDO"     ,"   ","Saldo inicial: "	,cPicSaldo	,18			,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	oSection2:Cell("SP1"):HideHeader()
	oSection2:SetCharSeparator("")

	oSection3:= TRSection():New(oSection2,"Movimentos por lote",{"SD5","SB8"}) //"Movimentos por Lote"
	oSection3:SetTotalInLine(.F.)
	oSection3:SetHeaderPage()
	oSection3:SetNoFilter("SD5")

	TRCell():New(oSection3,"D5_LOCAL"  ,"SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"D5_DATA"   ,"SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"D5_DTVALID","SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"D5_OP"     ,"SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"NUMDOC"    ,"SD5","Documento     "	 ,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If( !Empty(SD5->D5_OP) , SD5->D5_OP , Left(SD5->D5_DOC, Min(12,Len(SD5->D5_DOC))) ) })

	If cPaisLoc != "BRA"
		TRCell():New(oSection3,"DESCDOC","   ","f",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If( AllTrim(SD5->D5_SERIE) == "X" , If(cPaisLoc == "CHI" ,"GUI","REM") , "FAC" ) })
	EndIf

	TRCell():New(oSection3,"D5_ORIGLAN","SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"D5_ESTORNO","SD5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"ENTRADA"   ,"   ","Entrada" 	 ,cPicSaldo  ,18		 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection3,"SAIDA"     ,"   ","Saida"	 ,cPicEmpenho,18		 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection3,"SALDO"     ,"   ","Saldo"	 ,cPicSaldo  ,18		 ,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �28/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Kardex p/ Lote Sobre o SD5                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function ReportPrint(oReport,cAliasSB8)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local oSection3 := oReport:Section(1):Section(1):Section(1)
	Local cCampo    := ""
	Local cCompara  := ""
	Local cLote     := ""
	Local cLocal    := ""
	Local cSubLote  := ""
	Local cProduto  := ""
	Local cProdAnt  := ""
	Local cCondicao := ""
	Local cWorkSD5  := ""
	Local cFilter   := ""
	Local cWhere    := ""
	Local lProd     := .T.
	Local lLote     := .T.
	Local lLoteZera := .T.
	Local lMovSD5   := .T.
	Local lOkSublote:= .F.
	Local lSeek     := .F.
	Local nEntrada  := 0
	Local nSaida    := 0
	Local nSaldo    := 0
	Local nSldLote  := 0
	Local nIndSD5   := 0
	Local nSD5Quant := 0

	Local oTotal_EN1,oTotal_SA1, oTotal_SL1
	Local oTotal_EN2,oTotal_SA2, oTotal_SL2

	dbSelectArea('SB1')
	dbSetOrder(1)

	dbSelectArea("SB8")
	//������������������������������������������������������������������������Ŀ
	//�Filtragem do relatorio                                                  �
	//��������������������������������������������������������������������������
	#IFDEF TOP

	//������������������������������������������������������������������������Ŀ
	//�Filtro utilizado na condicao Where                                      �
	//��������������������������������������������������������������������������
	cWhere := "%"
	If mv_par13 == 1
		If mv_par12 == 2
			cWhere += "B8_SALDO2 > 0 AND "
		Else
			cWhere += ""
		EndIf
	Else
		If mv_par12 == 2
			cWhere += "B8_SALDO > 0 AND "
		Else
			cWhere += ""
		EndIf
	EndIf
	cWhere += "%"

	MakeSqlExpr(oReport:uParam)

	oReport:Section(1):BeginQuery()

	BeginSql Alias cAliasSB8

		SELECT SB8.*

		FROM %table:SB8% SB8

		WHERE B8_FILIAL    = %xFilial:SB8% AND
		B8_PRODUTO  >= %Exp:mv_par01% AND
		B8_PRODUTO  <= %Exp:mv_par02% AND
		B8_LOTECTL  >= %Exp:mv_par03% AND
		B8_LOTECTL  <= %Exp:mv_par04% AND
		B8_NUMLOTE  >= %Exp:mv_par05% AND
		B8_NUMLOTE  <= %Exp:mv_par06% AND
		B8_LOCAL    >= %Exp:mv_par07% AND
		B8_LOCAL    <= %Exp:mv_par08% AND
		%Exp:cWhere%
		SB8.%NotDel%

		ORDER BY B8_PRODUTO,B8_LOTECTL,B8_LOCAL,B8_NUMLOTE

	EndSql

	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

	oSection2:SetParentQuery()

	#ELSE

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao Advpl                          �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:uParam)

	cCondicao := 'B8_FILIAL=="'        + xFilial('SB8') + '".And.'
	cCondicao += 'B8_PRODUTO>="'       + mv_par01       + '".And.B8_PRODUTO<="'         + mv_par02       + '".And.'
	cCondicao += 'B8_LOTECTL>="'       + mv_par03       + '".And.B8_LOTECTL<="'         + mv_par04       + '".And.'
	cCondicao += 'B8_NUMLOTE>="'       + mv_par05       + '".And.B8_NUMLOTE<="'         + mv_par06       + '".And.'
	cCondicao += 'B8_LOCAL>="'         + mv_par07       + '".And.B8_LOCAL<="'           + mv_par08       + '"'

	//������������������������������������������������������������������������Ŀ
	//�Tratamento para saldos na primeira e segunda unidade de medida          �
	//��������������������������������������������������������������������������
	If mv_par13 == 1
		If mv_par12 == 2
			cCondicao += " .And. B8_SALDO2 > 0 "
		EndIf
	Else
		If mv_par12 == 2
			cCondicao += " .And. B8_SALDO > 0 "
		EndIf
	EndIf


	oReport:Section(1):SetFilter(cCondicao,"B8_PRODUTO+B8_LOTECTL+B8_LOCAL+B8_NUMLOTE")

	#ENDIF

	//���������������������������������������������������Ŀ
	//� Cria arquivo de trabalho para a tabela SD5.       �
	//�����������������������������������������������������
	dbSelectArea("SD5")

	cWorkSD5:= CriaTrab("",.F.)
	cFilter := 'D5_FILIAL=="'+xFilial("SD5")+'".And.D5_PRODUTO>="'+mv_par01+'".And.D5_PRODUTO<="'+mv_par02+'".And.'
	cFilter += 'D5_LOTECTL>="'+mv_par03+'".And.D5_LOTECTL<="'+mv_par04+'".And.'
	cFilter += 'D5_NUMLOTE>="'+mv_par05+'".And.D5_NUMLOTE<="'+mv_par06+'".And.'
	cFilter += 'D5_LOCAL>="'  +mv_par07+'".And.D5_LOCAL<="'  +mv_par08+'".And.'
	cFilter += 'Dtos(D5_DATA)>="'+Dtos(mv_par09)+'".And.Dtos(D5_DATA)<="'+Dtos(mv_par10)+'"'

	IndRegua("SD5",cWorkSD5,"D5_PRODUTO+D5_LOCAL+D5_LOTECTL+Dtos(D5_DATA)+D5_NUMLOTE+D5_NUMSEQ",,cFilter,"Selecionado Registros...") //"Selecionando Registros..."

	nIndSD5 := RetIndex("SD5")
	#IFNDEF TOP
	dbSetIndex(cWorkSD5 + OrdBagExt())
	#ENDIF
	dbSetOrder(nIndSD5+1)
	dbGotop()

	oTotal_EN1 :=TRFunction():New(oSection3:Cell("ENTRADA"  ),"CALCENT1"	,"SUM"		,/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T./*lEndReport*/,.F./*lEndPage*/,,oSection1)
	oTotal_SA1 :=TRFunction():New(oSection3:Cell("SAIDA"    ),"CALCSAI1"	,"SUM"		,/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oSection1)
	oTotal_SL1 :=TRFunction():New(oSection3:Cell("SALDO"    ),NIL			,"ONPRINT"	,/*oBreak1*/,,/*cPicture*/,{|| ( oSection1:GetFunction("CALCENT1"):GetLastValue() - oSection1:GetFunction("CALCSAI1"):GetLastValue() ) },.T.,.F. ,,oSection1)

	oTotal_EN2 :=TRFunction():New(oSection3:Cell("ENTRADA"  ),"CALCENT2"	,"SUM"		,/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oSection2)
	oTotal_SA2 :=TRFunction():New(oSection3:Cell("SAIDA"    ),"CALCSAI2"	,"SUM"		,/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oSection2)
	oTotal_SL2 :=TRFunction():New(oSection3:Cell("SALDO"    ),NIL			,"ONPRINT"	,/*oBreak1*/,,/*cPicture*/,{|| ( oSection2:GetFunction("CALCENT2"):GetLastValue() - oSection2:GetFunction("CALCSAI2"):GetLastValue() ) },.T.,.F. ,,oSection2)

	If mv_par14 == 2
		oSection1:Cell("B2_LOCALIZ"):Disable()
	EndIf

	oReport:SetMeter(SB8->(LastRec()))
	dbSelectArea(cAliasSB8)

	While !oReport:Cancel() .And. !(cAliasSB8)->(Eof())

		oReport:IncMeter()
		If oReport:Cancel()
			Exit
		EndIf

		oSection1:Init()

		cProduto := (cAliasSB8)->B8_PRODUTO
		cLote    := (cAliasSB8)->B8_LOTECTL
		cSubLote := (cAliasSB8)->B8_NUMLOTE
		cLocal   := (cAliasSB8)->B8_LOCAL

		nSldLote :=CalcEstL(cProduto,cLocal,mv_par10+1,(cAliasSB8)->B8_LOTECTL,If(Rastro(cProduto,"S"),(cAliasSB8)->B8_NUMLOTE,NIL),' ')[If(mv_par13<>1,1,7)]

		lLoteZera:= If( mv_par12 == 1 , .T. , If( nSldLote == 0 , .F. , .T. ) )
		lProd    := AllTrim( cProdAnt) <> AllTrim( (cAliasSB8)->B8_PRODUTO )
		lLote 	 := .T.
		lMovSD5  := .T.

		dbSelectArea("SD5")
		If !dbSeek(cProduto + cLocal + cLote ,.T.)

			//���������������������������������������������Ŀ
			//� Verifica se Lista Lote/Sub Sem Movimentos   �
			//� 1 = Lista          2 = Nao Lista		    �
			//�����������������������������������������������
			lLote   := If( mv_par11 == 1 , .T. , .F. )
			lMovSD5 := If( mv_par12 == 1 .And. lLote , .T. , .F. )

		ElseIf Rastro(cProduto,"S")

			lOkSublote:=.F.

			While !Eof() .And. SD5->D5_PRODUTO+SD5->D5_LOCAL+SD5->D5_LOTECTL == cProduto+cLocal+cLote
				If  SD5->D5_NUMLOTE == cSubLote
					lOkSublote:=.T.
					Exit
				EndIf
				dbSelectArea("SD5")
				dbSkip()
			EndDo
			If !lOkSubLote
				lLote   := If(mv_par11 == 1, .T. , .F. )
				lMovSD5 := If(mv_par12 == 1 .And. lLote , .T. , .F. )
			EndIf
		EndIf

		//���������������������������������������������������Ŀ
		//� Considera no filtro o Lote/Sub com o Saldo Zerado �
		//� 1 = Lista          2 = Nao Lista		          �
		//�����������������������������������������������������
		If mv_par12 == 2 .And. nSldLote == 0 .And. !lMovSD5
			dbSelectArea(cAliasSB8)
			dbSkip()
		EndIf

		dbSelectArea("SD5")
		If (lSeek:=MsSeek(cProduto+cLocal+cLote, .F.)) .Or. lLote

			If lProd .And. lLote .And. lLoteZera

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+cProduto))

				If mv_par14 == 1
					SB2->(MsSeek(xFilial("SB2")+cProduto+cLocal))
				Endif

				oSection1:PrintLine()

				lProd    := .F.
				cProdAnt := cProduto

			EndIf

			If lLote .And. lLoteZera

				oSection2:Init()


				If SB1->B1_RASTRO == "S"
					oSection2:Cell("B8_NUMLOTE"):Enable()
					oSection2:Cell("SP1"):SetSize(60-Len("Sub-Lote: ")-Len("Lote: ")-TamSX3("B8_NUMLOTE")[1]-TamSX3("B8_LOTECTL")[1],.F./*lPixel*/) //"Sub-Lote: "###"Lote: "
				ElseIf SB1->B1_RASTRO == "L"
					oSection2:Cell("B8_NUMLOTE"):Disable()
					oSection2:Cell("SP1"):SetSize(61-Len("Lote: ")-TamSX3("B8_LOTECTL")[1],.F./*lPixel*/) //"Lote: "
				EndIf

				nSaldo:=CalcEstL(cProduto,cLocal,mv_par09,(cAliasSB8)->B8_LOTECTL,IF(Rastro(cProduto,"S"),(cAliasSB8)->B8_NUMLOTE,NIL),' ')[If(mv_par13<>1,1,7)]

				oSection2:Cell("SALDO"):SetValue(nSaldo)

				oSection2:PrintLine()

			EndIf
			//���������������������������������������Ŀ
			//� Zera os totais de cada Lote/SubLote   �
			//�����������������������������������������
			nEntrada := nSaida := 0

			cCampo	:= "D5_PRODUTO+D5_LOTECTL"
			cCompara:=	D5_PRODUTO+D5_LOTECTL
			//���������������������������������������Ŀ
			//� Impressao dos Movimentos do Lote/Sub  �
			//�����������������������������������������
			Do While !Eof() .And. &(cCampo) == cCompara .And. lLoteZera

				oSection3:Init()

				If  SD5->D5_LOCAL <> cLocal .Or. (Rastro(cProduto,"S") .And.  SD5->D5_NUMLOTE <> cSubLote)
					dbSkip()
					Loop
				EndIf

				nSD5Quant := If(mv_par13 <> 1, SD5->D5_QUANT,SD5->D5_QTSEGUM)

				If SD5->D5_ORIGLAN <= "500" .Or. Substr( SD5->D5_ORIGLAN,1,2) $ "DE/PR" .Or. SD5->D5_ORIGLAN == "MAN"

					oSection3:Cell("ENTRADA"):SetValue(nSD5Quant)
					oSection3:Cell("SAIDA"  ):SetValue(0)
					nEntrada+=nSD5Quant
					nSaldo  +=nSD5Quant

				Elseif SD5->D5_ORIGLAN > "500" .Or. Substr(SD5->D5_ORIGLAN,1,2) == "RE"

					oSection3:Cell("SAIDA"  ):SetValue(nSD5Quant)
					oSection3:Cell("ENTRADA"):SetValue(0)
					nSaida  +=nSD5Quant
					nSaldo  -=nSD5Quant

				EndIf

				oSection3:Cell("SALDO"):SetValue(nSaldo)

				oSection3:PrintLine()

				dbSkip()

			EndDo

			oSection3:Finish()

			If lLote .And. lLoteZera

				oTotal_EN1:HideHeader()
				oTotal_SA1:HideHeader()
				oTotal_SL1:HideHeader()

				oTotal_EN2:ShowHeader()
				oTotal_SA2:HideHeader()
				oTotal_SL2:HideHeader()

				oTotal_EN2:SetTitle(If(SB1->B1_RASTRO == "S" , "Total do Sub-Lote -> " , "Total do Lote -> " )) //"Total do Sub-Lote -> " # "Total do Lote -> "
				oSection2:Finish()

			Else
				lLote := .T.
			Endif

		EndIf

		dbSelectArea(cAliasSB8)
		If Rastro(cProduto,"L")
			Do While !Eof() .And. cProduto + cLocal == (cAliasSB8)->B8_PRODUTO + (cAliasSB8)->B8_LOCAL
				If cLote <> (cAliasSB8)->B8_LOTECTL
					Exit
				EndIf
				dbSkip()
			EndDo
		Else
			dbSkip()
		EndIf

		If ( cProduto <> (cAliasSB8)->B8_PRODUTO .And. If( !( mv_par12 == 1 ) ,nSaldo > 0 , .T. ) ) .And. lSeek

			oTotal_EN2:HideHeader()
			oTotal_SA2:HideHeader()
			oTotal_SL2:HideHeader()

			oTotal_EN1:ShowHeader()
			oTotal_SA1:HideHeader()
			oTotal_SL1:HideHeader()

			oTotal_EN1:SetTitle("Total")

			oSection1:Finish()

			lProd  := .T.

		EndIf

	EndDo

	//��������������������������������������������������������������Ŀ
	//� Devolve ordens originais da tabela e apaga indice de trabalho�
	//����������������������������������������������������������������
	RetIndex("SD5")
	dbSelectArea("SD5")
	dbSetOrder(1)
	dbClearFilter()

	If File(cWorkSD5+OrdBagExt())
		Ferase(cWorkSD5+OrdBagExt())
	EndIf

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR435R3� Autor � Rodrigo de A. Sartorio� Data � 11.05.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Kardex p/ Lote Sobre o SD5                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Rodrigo Sar.�26/05/98�XXXXX �Trocada pergunte p/ corrigir falha de     ���
���            �        �      �atualizacao de versao.                    ���
���Rodrigo Sar.�08/09/98�17321A�Corrigido while para lotes iguais         ���
���FernandoJoly�20/10/98�18410A�Inclus�o da Data de Validade e Documento. ���
���FernandoJoly�10/11/98�XXXXXX�Ajuste para o Ano 2000.                   ���
���Fernando J. �03/12/98�18813A�Impress�o correta do campo "Documento".   ���
���Cesar       �25/03/99�20051A�Alteracao do Lay-Out p/ Sair #OP Completa ���
���Cesar       �07/04/99�XXXXXX�Alteracao do Lay-Out p/ Tamanho M         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function U_RMAT435R3()
	//��������������������������������������������������������������Ŀ
	//� Define Variaveis                                             �
	//����������������������������������������������������������������
	LOCAL cDesc1    := "Este programa emitir� um Kardex com todas as movimenta��es"
	LOCAL cDesc2    := "do estoque por Lote/Sub-Lote, diariamente. Observa��o: o primeiro"
	LOCAL cDesc3    := "movimento de cada Lote/Sub-Lote se refere a cria��o do mesmo."
	LOCAL titulo	:= "Kardex por Lote/Sub-Lote (por produto)"
	LOCAL wnrel     := "RMAT435"
	LOCAL Tamanho   := "M"
	LOCAL cString   := "SB8"

	PRIVATE aReturn := {"Zebrado",1,"Administracao", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
	PRIVATE aLinha  := { },nLastKey := 0
	PRIVATE cPerg   := "MR435A"

	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros                     	 �
	//� mv_par01       	// Do  Produto                         	 	 �
	//� mv_par02        // Ate Produto                         	 	 �
	//� mv_par03        // De  Lote                            	 	 �
	//� mv_par04        // Ate Lote			        			 	 �
	//� mv_par05        // De  Sub-Lote                          	 �
	//� mv_par06        // Ate Sub-Lote			        		 	 �
	//� mv_par07        // De  Local		        			 	 �
	//� mv_par08        // Ate Local							 	 �
	//� mv_par09        // De  Data			        			 	 �
	//� mv_par10        // Ate Data								 	 �
	//� mv_par11       	// Lotes/Sub S/ Movimentos (Lista/Nao Lista) �
	//� mv_par12       	// Lote/Sub Saldo Zerado   (Lista/Nao Lista) �
	//� mv_par13       	// QTDE. na 2a. U.M. ?     (Sim/Nao)         �
	//����������������������������������������������������������������
	//��������������������������������������������������������������Ŀ
	//� Verifica as perguntas selecionadas                           �
	//����������������������������������������������������������������
	Pergunte("MR435A",.F.)
	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SETPRINT                        �
	//����������������������������������������������������������������
	wnrel :=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.f.,Tamanho)

	If nLastKey = 27
		dbClearFilter()
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		dbClearFilter()
		Return
	Endif

	RptStatus({|lEnd| u_C435Imp(@lEnd,wnRel,tamanho,titulo)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C435IMP  � Autor � Rodrigo de A. Sartorio� Data � 14.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR435			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function C435Imp(lEnd,WnRel,tamanho,titulo)
	LOCAL cCampo   := ""
	LOCAL cCompara := ""
	LOCAL cLote    := ""
	LOCAL cSubLote := ""
	LOCAL lOkSublote:=.F.
	LOCAL cProduto := ""
	LOCAL cIndexD5 := "D5_PRODUTO+D5_LOCAL+D5_LOTECTL+DTOS(D5_DATA)+D5_NUMLOTE+D5_NUMSEQ"
	LOCAL cIndexB8 := "B8_PRODUTO+B8_LOTECTL+B8_LOCAL+B8_NUMLOTE"
	LOCAL lProd    := .T.					// Flag do Subtitulo Produto
	LOCAL lLote    := .T.					// Flag do Subtitulo Lote
	LOCAL lTotal   := .F.					// Flag de Impressao do Total do relatorio
	LOCAL nEntrada := nSaida :=nSaldo  :=0 	// Totalizadores de Valor por Lote
	LOCAL nLentrada:= nLsaida:=nProduto:=0	// Totalizadores de Valor por Produto
	LOCAL nIndD5   := 0
	LOCAL nIndB8   := 0
	LOCAL nTipo    := 0
	LOCAL cProdAnt := ""
	LOCAL lLoteZera:= .T.                   // Flag para Listar Lote Zerado
	LOCAL nSD5Quant:= 0
	LOCAL lSeek    := .F.
	LOCAL	cCondD5:= 'D5_FILIAL=="'+xFilial("SD5")+'".And.D5_PRODUTO>="'+mv_par01+'".And.D5_PRODUTO<="'+mv_par02+'".And.'
	LOCAL	cCondB8:= 'B8_FILIAL=="'+xFilial("SB8")+'".And.B8_PRODUTO>="'+mv_par01+'".And.B8_PRODUTO<="'+mv_par02+'".And.'

	cCondD5 += 'D5_LOTECTL>="'+mv_par03+'".And.D5_LOTECTL<="'+mv_par04+'".And.'
	cCondD5 += 'D5_NUMLOTE>="'+mv_par05+'".And.D5_NUMLOTE<="'+mv_par06+'".And.'
	cCondD5 += 'D5_LOCAL>="'  +mv_par07+'".And.D5_LOCAL<="'  +mv_par08+'".And.'
	cCondD5 += 'DTOS(D5_DATA)>="'+DTOS(mv_par09)+'".And.DTOS(D5_DATA)<="'+DTOS(mv_par10)+'"'

	cCondB8 += 'B8_LOTECTL>="'+mv_par03+'".And.B8_LOTECTL<="'+mv_par04+'".And.'
	cCondB8 += 'B8_NUMLOTE>="'+mv_par05+'".And.B8_NUMLOTE<="'+mv_par06+'".And.'
	cCondB8 += 'B8_LOCAL>="'  +mv_par07+'".And.B8_LOCAL<="'  +mv_par08+'"'

	If !Empty(aReturn[7])
		cCondB8 += '.And.' + aReturn[7]
	EndIf

	//���������������������������������������������������Ŀ
	//� Pega o nome do arquivo de indice de trabalho      �
	//�����������������������������������������������������
	cNomArqD5 := CriaTrab("",.F.)
	cNomArqB8 := CriaTrab("",.F.)
	//���������������������������������������������������Ŀ
	//� Cria o indice de trabalho para o SD5              �
	//�����������������������������������������������������
	dbSelectArea("SD5")
	IndRegua("SD5",cNomArqD5,cIndexD5,,cCondD5,"Selecionando Registros...")
	nIndD5 := RetIndex('SD5')
	#IFNDEF TOP
	dbSetIndex(cNomArqD5 + OrdBagExt())
	#ENDIF
	dbSetOrder(nIndD5 + 1)
	dbGotop()
	//���������������������������������������������������Ŀ
	//� Cria o indice de trabalho para o SB8              �
	//�����������������������������������������������������
	dbSelectArea("SB8")
	IndRegua("SB8",cNomArqB8,cIndexB8,,cCondB8,"Selecionando Registros...")
	nIndB8 := RetIndex('SB8')
	#IFNDEF TOP
	dbSetIndex(cNomArqB8 + OrdBagExt())
	#ENDIF
	dbSetOrder(nIndB8 + 1)
	dbGotop()

	//���������������������������������������������������Ŀ
	//� Variaveis para Impressao do Cabecalho e Rodape    �
	//�����������������������������������������������������
	PRIVATE cbtxt := SPACE(10)
	PRIVATE cbcont:= 0
	PRIVATE li    := 80
	PRIVATE m_pag := 01

	PRIVATE cabec1  := 'Local   Data Movim.   Valid. Lote    Documento       Origem Lcto.    Estornado           Entrada             Saida             Saldo'
	PRIVATE cabec2  := ""
	//--						    99       99/99/9999    99/99/9999    999999999999         XXX            X        999999999.9999    999999999.9999    999999999.9999
	//--                            0         1         2         3         4         5         6         7         8         9        10        11        12        13
	//--                            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	dbSelectArea("SB8")
	SetRegua(LastRec())
	Do While !Eof()
		lProd    := allTrim(cProdAnt)#allTrim(B8_PRODUTO)
		cProduto := B8_PRODUTO
		cLote    := B8_LOTECTL
		cSubLote := B8_NUMLOTE
		cLocal   := B8_LOCAL
		lLote 	 := .T.
		lTotal   := .T.
		lMovSD5  := .T.

		IncRegua()

		If lEnd
			@PROW()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		EndIf

		If li > 56
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf

		nSldLote:=CalcEstL(cProduto,cLocal,mv_par10+1,B8_LOTECTL,IF(Rastro(cProduto,"S"),B8_NUMLOTE,NIL),' ')[If(mv_par13<>1,1,7)]

		lLoteZera := IF(mv_par12 == 1,.T.,IF(nSldLote == 0,.F.,.T.))

		dbSelectArea("SD5")
		If !dbSeek(cProduto+cLocal+cLote,.T.)
			//���������������������������������������������Ŀ
			//� Verifica se Lista Lote/Sub Sem Movimentos   �
			//� 1 = Lista          2 = Nao Lista		    �
			//�����������������������������������������������
			lLote  := If(mv_par11==1,.T.,.F.)
			lMovSD5:= If(mv_par12==1.And.lLote,.T.,.F.)
		ElseIf Rastro(cProduto,"S")
			lOkSublote:=.F.
			While !EOF() .And. D5_PRODUTO+D5_LOCAL+D5_LOTECTL == cProduto+cLocal+cLote
				If D5_NUMLOTE == cSubLote
					lOkSublote:=.T.
					Exit
				EndIf
				dbSkip()
			End
			If !lOkSubLote
				lLote  := If(mv_par11==1,.T.,.F.)
				lMovSD5:= If(mv_par12==1.And.lLote,.T.,.F.)
			EndIf
		EndIf

		//���������������������������������������������������Ŀ
		//� Considera no filtro o Lote/Sub com o Saldo Zerado �
		//� 1 = Lista          2 = Nao Lista		          �
		//�����������������������������������������������������
		If mv_par12 == 2 .And. nSldLote == 0 .And. !lMovSD5
			dbSelectArea("SB8")
			dbSkip()
		EndIf

		dbSelectArea("SD5")
		If (lSeek:=MsSeek(cProduto+cLocal+cLote, .F.)) .Or. lLote
			If lProd .And. lLote .And. lLoteZera

				If li > 56
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+cProduto))
				@ li,00 PSay "Produto: "+cProduto					//"Produto: "
				@ li,25 PSay "Descr.:"+Substr(SB1->B1_DESC,1,45)	//"Descr.: "
				@ li,82 PSay "Tipo: "+SB1->B1_TIPO				//"Tipo: "
				@ li,91 PSay "Unidade: "+If(mv_par13 <> 1 ,SB1->B1_UM,SB1->B1_SEGUM) //"Unidade: "
				If mv_par14 == 1
					If SB2->(MsSeek(xFilial("SB2")+cProduto+cLocal)) .And. !Empty(SB2->B2_LOCALIZ)
						@ li,104 PSay "Descr. Arm.: "+SB2->B2_LOCALIZ //"Descr. Arm.: "
					Endif
				Endif
				Li += 2
				lProd  := .F.
				lTotal := .T.
				cProdAnt := cProduto
			EndIf

			If lLote .And. lLoteZera
				If li > 56
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf

				If SB1->B1_RASTRO == "S"
					@ li,01 PSay "Sub-Lote: "+SB8->B8_NUMLOTE+"    "+"Lote: "+SB8->B8_LOTECTL	//"Sub-Lote: "###"Lote: "
				ElseIf SB1->B1_RASTRO == "L"
					@ li,01 PSay "Lote: "+SB8->B8_LOTECTL		//"Lote: "
				EndIf
				nSaldo:=CalcEstL(cProduto,cLocal,mv_par09,SB8->B8_LOTECTL,IF(Rastro(cProduto,"S"),SB8->B8_NUMLOTE,NIL),' ')[If(mv_par13<>1,1,7)]
				@ li,51 PSay "Saldo Inicial: "
				@ Li,82 pSay Transform(nSaldo,PesqPictQt('D5_QUANT',18))
				Li += 2
			EndIf
			//���������������������������������������Ŀ
			//� Zera os totais de cada Lote/SubLote   �
			//�����������������������������������������
			nEntrada := nSaida := 0

			cCampo	:= "D5_PRODUTO+D5_LOTECTL"
			cCompara:=	D5_PRODUTO+D5_LOTECTL
			//���������������������������������������Ŀ
			//� Impressao dos Movimentos do Lote/Sub  �
			//�����������������������������������������
			Do While !Eof() .And. &(cCampo) == cCompara .And. lLoteZera
				If D5_LOCAL # cLocal .Or. (Rastro(cProduto,"S") .And. D5_NUMLOTE # cSubLote)
					dbSkip()
					Loop
				EndIf
				If li > 56
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf
				@ Li, 00 pSay Left(SD5->D5_LOCAL, 02)
				@ Li, 09 pSay DtoC(SD5->D5_DATA)
				@ Li, 23 pSay DtoC(SD5->D5_DTVALID)
				@ Li, 37 pSay If(!Empty(SD5->D5_OP), SD5->D5_OP, ;
				Left(SD5->D5_DOC, Min(12,Len(SD5->D5_DOC))))
				If cPaisLoc != "BRA"
					If AllTrim(SD5->D5_SERIE) == "X"
						@ Li, 54 pSay If(cPaisLoc=="CHI","GUI","REM")
					Else
						@ Li, 54 pSay "FAC"
					EndIf
				EndIf
				@ Li, 58 pSay Left(SD5->D5_ORIGLAN, 03)
				@ Li, 73 pSay SD5->D5_ESTORNO
				nSD5Quant := If(mv_par13 <> 1,D5_QUANT,D5_QTSEGUM)
				If D5_ORIGLAN <= "500" .Or. Substr(D5_ORIGLAN,1,2) $ "DE/PR" .Or. D5_ORIGLAN == "MAN"
					@ Li, 82 pSay Transform(nSD5Quant, PesqPictQt('D5_QUANT',18))
					nEntrada+=nSD5Quant
					nSaldo  +=nSD5Quant
				Elseif D5_ORIGLAN > "500" .Or. Substr(D5_ORIGLAN,1,2) == "RE"
					@ Li, 100 pSay Transform(nSD5Quant, PesqPictQt('D5_QUANT',18))
					nSaida  +=nSD5Quant
					nSaldo  -=nSD5Quant
				EndIf
				@ Li, 118 pSay Transform(nSaldo, PesqPictQt('D5_QUANT',18))
				Li++
				dbSkip()

				IF li > 59
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIF

			EndDo

			If lLote .And. lLoteZera
				If nEntrada > 0 .And. nSaida > 0 .Or. nSaldo > 0
					If li > 56
						cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
					EndIf
					@ li,00 PSAY cLocal
					If SB1->B1_RASTRO == "S"
						@ li,03 PSay "Total do Sub-Lote -> "
					ElseIf SB1->B1_RASTRO == "L"
						@ li,03 PSay "Total do Lote -> "
					EndIf
					If nEntrada > 0
						@ Li, 82 pSay Transform(nEntrada, PesqPictQt('D5_QUANT',18))
					EndIf
					If nSaida > 0
						@ Li, 100 pSay Transform(nSaida, PesqPictQt('D5_QUANT',18))
					EndIf
					@ Li, 118 pSay Transform(nSaldo, PesqPictQt('D5_QUANT',18))
				EndIf
				nLentrada += nEntrada
				nLsaida   += nSaida
				nProduto  += nSaldo
				Li += 2
			Else
				lLote := .T.
			Endif
		EndIf

		dbSelectArea("SB8")
		If Rastro(cProduto,"L")
			Do While !Eof() .And. cProduto+cLocal == B8_PRODUTO+B8_LOCAL
				If cLote # B8_LOTECTL
					Exit
				EndIf
				dbSkip()
			EndDo
		Else
			dbSkip()
		EndIf

		If cProduto # B8_PRODUTO .And. if(!(mv_par12==1),nProduto > 0,.T.)
			If li > 56
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			If !(nLentrada <= 0 .And. nLsaida <= 0)
				@ li,00 PSay __PrtThinLine()
				Li++
				@ li,00 PSay "Total do Produto -> "
				If nLentrada > 0
					@ Li, 82 pSay Transform(nLentrada, PesqPictQt('D5_QUANT',18))
				EndIf
				If nLsaida > 0
					@ Li, 100 PSay Transform(nLsaida, PesqPictQt('D5_QUANT',18))
				EndIf
				@ Li, 118 pSay Transform(nProduto, PesqPictQt('D5_QUANT',18))
				Li++
				@ li,00 PSay __PrtThinLine()
				Li++
			ElseIf lLote .And. !lSeek
				Li++
				@ li,00 PSay __PrtThinLine()
				Li++
			EndIf
			//���������������������������������Ŀ
			//� Zera os Totais do Produto   	�
			//�����������������������������������
			nLentrada := nLsaida := nProduto :=0
			lProd  := .T.
			lTotal := .F.
		EndIf

	EndDo

	If lTotal .And. if(!(mv_par12==1),nProduto > 0,.T.)
		If li > 56
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		@ li,00 PSay __PrtThinLine()
		Li++
		@ li,00 PSay "Total do Produto -> "
		If nLentrada > 0
			@ Li, 82 pSay Transform(nLentrada, PesqPictQt('D5_QUANT',18))
		EndIf
		If nLsaida > 0
			@ Li, 100 PSay Transform(nLsaida, PesqPictQt('D5_QUANT',18))
		EndIf
		@ Li, 118 pSay Transform(nProduto, PesqPictQt('D5_QUANT',18))
		Li++
		@ li,00 PSay __PrtThinLine()
		Li++
		//���������������������������������Ŀ
		//� Zera os Totais do Produto   	�
		//�����������������������������������
		nLentrada := nLsaida := nProduto :=0
		IF li != 80
			roda(cbcont,cbtxt,Tamanho)
		EndIF
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Devolve as ordens originais do arquivo                       �
	//����������������������������������������������������������������
	RetIndex("SD5")
	dbClearFilter()
	RetIndex("SB8")
	dbClearFilter()

	//��������������������������������������������������������������Ŀ
	//� Apaga indice de trabalho                                     �
	//����������������������������������������������������������������
	cNomArqD5 += OrdBagExt()
	cNomArqB8 += OrdBagExt()
	Delete File &(cNomArqD5)
	Delete File &(cNomArqB8)

	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

return
