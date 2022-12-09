#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri�ao � PLANO DE MELHORIA CONTINUA        �Programa     MATA340.PRX���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data                            ���
�������������������������������������������������������������������������Ĵ��
���      01  � Marcos V. Ferreira       � 07/04/2006 - Bops: 00000096660  ���
���      02  � Nereu Humberto Junior    � 10/02/2006                      ���
���      03  �                          �                                 ���
���      04  �                          �                                 ���
���      05  � Nereu Humberto Junior    � 08/05/2006 - Bops: 00000098187  ���
���      06  � Marcos V. Ferreira       � 07/04/2006 - Bops: 00000096660  ���
���      07  � Nereu Humberto Junior    � 08/05/2006 - Bops: 00000098187  ���
���      08  � Erike Yuri da Silva      � 08/02/2006                      ���
���      09  � Nereu Humberto Junior    � 10/02/2006                      ���
���      10  � Erike Yuri da Silva      � 08/02/2006                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA340  � Autor � Eveli Morasco         � Data � 11/03/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera requisicoes e devolucoes para acertar estoque de acor-���
���          � do com a digitacao do inventario                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Rodrigo Sart.�07/08/98�16465A�Acerto na gravacao da data do inventario���
��� Fernando Joly�01/02/99�19590A�Acerto na Impress�o do Relatorio.       ���
���Rodrigo Sart. �22/04/99�XXXXXX�Incluido tratamento p/ INTERNET         ���
���Rodrigo Sart. �13/05/99�21692A�Alterado programa para tratar corretamen���
���              �        �      �te saldos por Lote e Localizacao Fisica ���
���Rodrigo Sart. �01/07/99�22290A�Alterada chamada da funcao CalcEstL     ���
���Fernando Joly �04/08/99�23131A�Cria�ao do Ponto de Entrada MT340D3     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LS_M340(lBatch,cCodInv)
Local oDlg,nOpca:=0
Local lOk := .T.

PRIVATE nHdlPrv		// Endereco do arquivo de contra prova dos lanctos cont.
PRIVATE cLoteEst 	// Numero do lote para lancamentos do estoque
PRIVATE lLocCQ:=.T.	// Flag usado para indicar se criou IndRegua no SD7
PRIVATE cNomArq		// Nome do arquivo temporario criado pela IndRegua
PRIVATE nNewOrd

#IFDEF TOP
	TCInternal(5,"*OFF")   // Desliga Refresh no Lock do Top
#ENDIF

//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 -Pesquisa e Posiciona em um Banco de Dados              �
//�    2 -Simplesmente Mostra os Campos                          �
//�    3 -Inclui registros no Bancos de Dados                    �
//�    4 -Altera o registro corrente                             �
//�    5 -Estorna registro selecionado gerando uma contra-partida�
//����������������������������������������������������������������
PRIVATE aRotina := { {"Processar","MATA340" ,0 ,1 ,19}} //"Processar"

If lBatch
	nOpca := 1
EndIf

If __cInternet != Nil
	lBatch := .T.
EndIf

If !lBatch
//	If SubStr(cAcesso,19,1) == " "
//		Help ( " ", 1, "SEMPERM" )
//		Return .F.
//	EndIf
	DEFINE MSDIALOG oDlg FROM  96,4 TO 355,625 TITLE "Acerto do Invent�rio" PIXEL	//"Acerto do Invent�rio"
	@ 18, 9 TO 99, 300 LABEL "" OF oDlg  PIXEL
	@ 29, 15 Say OemToAnsi("Este programa ir� gerar movimenta��es de ajuste para corrigir o saldo do estoque.") SIZE 275, 10 OF oDlg PIXEL	//
	@ 38, 15 Say OemToAnsi("Estas movimenta��es ser�o baseadas nas contagens realizadas e cadastradas na Rotina Invent�rio.") SIZE 275, 10 OF oDlg PIXEL	//
	@ 48, 15 Say OemToAnsi("O programa dever� gerar uma Requisi��o ou uma Devolu��o autom�tica, dependendo da diferen�a encontrada.") SIZE 275, 10 OF oDlg PIXEL	//
	@ 58, 15 Say OemToAnsi("Nota: Ser� considerado apenas o estoque inventariado na data da sele��o (par�metros).") SIZE 255, 10 OF oDlg PIXEL	//
	@ 68, 15 Say OemToAnsi("Caso algum produto apresente diverg�ncias, ser� gerado um relat�rio.") SIZE 255, 10 OF oDlg PIXEL	//
	@ 78, 15 Say OemToAnsi("Se o almoxarifado inventariado for o almoxarifado do CQ, sera considerada como quantidade em estoque ")      SIZE 275, 10 OF oDlg PIXEL	// STR0008 
	@ 88, 15 Say OemToAnsi("a quantidade rejeitada.")	 SIZE 100, 10 OF oDlg PIXEL	// STR0009 
	
	DEFINE SBUTTON FROM 108,209 TYPE 5 ACTION Pergunte("MTA340",.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 108,238 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 108,267 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg
EndIf

If nOpca == 1
	//�����������������������������������������������������������������Ŀ
	//� Template acionando Ponto de Entrada                             �
	//�������������������������������������������������������������������
	If ExistTemplate("MT340IN")	
		lOk := ExecTemplate("MT340IN",.F.,.F.)
		If !(ValType(lOk) == "L")
			lOk := .T.
		EndIf
	EndIf

	//��������������������������������������������������������������Ŀ
	//� P.E. utilizado para validar Inicio do Processamento          �
	//����������������������������������������������������������������
	If (ExistBlock( "MT340IN" ) )
		lOK := ExecBlock("MT340IN",.F.,.F.)
		If !(ValType(lOk) == "L")
			lOk := .T.
		EndIf
	EndIf

	If lOk
		If lBatch
			MA340Process(lBatch,cCodInv)
		Else
			Processa({|lend| MA340Process(lBatch)},"Acerto do Invent�rio","Efetuando Acerto do Inventario...",.F.)	//###
		EndIf
	EndIf
EndIf

If !lLocCQ
	//��������������������������������������������������������������Ŀ
	//� Devolve as ordens originais do arquivo                       �
	//����������������������������������������������������������������
	RetIndex("SD7")
	dbClearFilter()
	//��������������������������������������������������������������Ŀ
	//� Apaga indice de trabalho                                     �
	//����������������������������������������������������������������
	cNomArq += OrdBagExt()
	Delete File &(cNomArq)
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MA340Process� Autor � Rodrigo de A. Sartorio� Data �28/11/95���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa o Acerto do Inventario.                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA340                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MA340Process(lBatch,cCodInv)
Local lOpca,cCod,cLocal,dData,nQuant,nQtSegUm
Local lPassou,cApropri,cNumSeq,aCM:={},aCusto:={},aCM1:={}
Local lDigita,lAglutina,lEstNeg :=If(GetMV('MV_ESTNEG')=='N',.F.,.T.)
Local aSaldo	:=Array(7)
Local aSaldoAtu	:=Array(7)
Local nDiferenca:=0
Local aLogs:={{}},i,z,cLog:=""
Local nAchou,lOkLote:=.F.,lLoteInv:=.T.,lGeraCQ0:=.F.
Local cLote:="",cLoteCtl:="",dDtValid:="",cNumSerie:="",cLocaliza:="",cEstFis:=''
Local cLocalCQ	:=GetMV("MV_CQ")
Local dDataFec	:=If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES"))
Local cCusMed 	:=GetMV("MV_CUSMED")
Local nEmpenho	:=0
Local cAliasSql	:="SB7",lQuery:=.F.
Local aStruSB7	:= {},cQuery:=""
Local cAliasCC 	:= If(CtbInUse(), "CTT", "SI3")
Local lMT340B2	:=ExistBlock("MT340B2")
Local lContagem	:=(SB7->(FieldPos("B7_CONTAGE")) > 0) .And. (SB7->(FieldPos("B7_ESCOLHA")) > 0) .And. (SB7->(FieldPos("B7_OK")) > 0) .And. SuperGetMv('MV_CONTINV',.F.,.F.)
Local lOK
Local l340SB7 	:= ExistBlock("MT340SB7")
Local lT340SB7	:= ExistTemplate("MT340SB7")
Local lCEmpInv	:= SuperGetMv("MV_CEMPINV",.F.,.T.) //Considera empenho na analise de divergencia entre SB2 e SBF
Local nTotEnd 	:= 0,nX:=0,nCampo:=0
Local cDocOri 	:="" 
Local aAreaSD5 	:= {}
Local cLotCtlQie:= ""
Local cNumLotQie:= ""
Local aRecCele  := {}
Local aEnvCele  := {} 
Local lExistNF  := SB7->(FieldPos("B7_NUMDOC")) <> 0
Local cNumDoc   := ""
Local cSerie    := ""
Local cFornece  := ""
Local cLoja     := ""

//�����������������������������������������������������������Ŀ
//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
//�������������������������������������������������������������
PcoIniLan("000153")

Do While .T.
	dbSelectArea("SB2")
	If lBatch
		Pergunte("MTA340",.F.)
		//��������������������������������������������������������������Ŀ
		//� Carrega as perguntas selecionadas                            �
		//����������������������������������������������������������������
		If cCodInv#NIL
			mv_par01 := SB7->B7_DATA
			mv_par03 := 2
			mv_par05 := SB7->B7_COD
			mv_par06 := SB7->B7_COD
			mv_par07 := SB7->B7_LOCAL
			mv_par08 := SB7->B7_LOCAL
			mv_par09 := Posicione('SB1',1, xFilial('SB1')+SB7->B7_COD,"B1_GRUPO")
			mv_par10 := mv_par09
			mv_par11 := cCodInv
			mv_par12 := cCodInv
		EndIf
	Else
		Pergunte("MTA340",.F.)
		lOpca:=.T.
	EndIf
	If mv_par01 <= dDataFec
		Help (' ', 1, 'FECHTO')
		Return
	EndIf
	If !Empty(mv_par02)
		(cAliasCC)->(dbSetOrder(1))
		If !(cAliasCC)->((dbSeek(xFilial(cAliasCC)+mv_par02)))
			mv_par02:=""
		EndIf
	EndIf
	//����������������������������������������������������������������Ŀ
	//� mv_par01 - Data a ser considerada                              �
	//� mv_par02 - Em qual centro de custo sera' jogada a diferenca    �
	//� mv_par03 - Se deve mostrar os lancamentos contabeis            �
	//� mv_par04 - Se deve aglutinar os lancamentos contabeis          �
	//� mv_par05 - De  Produto                                         �
	//� mv_par06 - Ate Produto                                         �
	//� mv_par07 - De  Local                                           �
	//� mv_par08 - Ate Local                                           �
	//� mv_par09 - De  Grupo                                           �
	//� mv_par10 - Ate Grupo                                           �
	//� mv_par11 - De  Documento                                       �
	//� mv_par12 - Ate Documento                                       �
	//� mv_par13 - Considerar empenhos                                 �
	//� mv_par14 - Atualiza Saldo do Fechamento                        �
	//������������������������������������������������������������������
	If lBatch
		lOpca := .T.
	EndIf

	If !lOpca
		Exit
	Else
		//��������������������������������������������������������������Ŀ
		//� Posiciona numero do Lote para Lancamentos do Faturamento     �
		//����������������������������������������������������������������
		dbSelectArea("SX5")
		dbSeek(xFilial("SX5")+"09EST")
		cLoteEst:=IIf(Found(),Trim(X5Descri()),"EST ")
		PRIVATE nTotal := 0 	// Total dos lancamentos contabeis
		PRIVATE cArquivo		// Nome do arquivo contra prova
		dbSelectArea("SB7")
		#IFDEF TOP
			If ( TcSrvType()!="AS/400" ) .And. !lT340SB7
				//������������������������������������������������������������������������Ŀ
				//� Totaliza registros de digitacao de inventario                          �
				//��������������������������������������������������������������������������
				lQuery   :=.T.
				cAliasSQL:= "SB7SQL"
				aStruSB7 := SB7->(dbStruct())
				cQuery := "SELECT SUM(SB7.B7_QUANT) TOTQUANT, SUM(SB7.B7_QTSEGUM) TOTQUANT2,"
				cQuery	 += " B7_FILIAL,B7_DATA,B7_COD,B7_LOCAL,B7_TPESTR,B7_LOCALIZ,B7_NUMSERI,B7_LOTECTL,B7_NUMLOTE,B7_DTVALID"
				If lContagem
					cQuery += ",B7_CONTAGE,B7_ESCOLHA "
				EndIf
				If lExistNF
					cQuery += ",B7_NUMDOC,B7_SERIE,B7_FORNECE,B7_LOJA "
				EndIf
				cQuery += " FROM "
				cQuery += RetSqlName("SB7")+" SB7 ,"
				cQuery += RetSqlName("SB1")+" SB1 ,"
				cQuery += " WHERE SB7.B7_FILIAL='"+xFilial("SB7")+"' AND"
				cQuery += " SB7.B7_DATA='"+DTOS(mv_par01)+"' AND"
				cQuery += " SB7.B7_COD>='"+mv_par05+"' AND SB7.B7_COD<='"+mv_par06+"' AND"
				cQuery += " SB7.B7_LOCAL>='"+mv_par07+"' AND SB7.B7_LOCAL<='"+mv_par08+"' AND"
				cQuery += " SB7.B7_DOC>='"+mv_par11+"' AND SB7.B7_DOC<='"+mv_par12+"' AND"
				If lContagem
					cQuery += " SB7.B7_ESCOLHA = 'S' AND"
				EndIf
				cQuery += " SB7.D_E_L_E_T_<>'*' AND"
				cQuery += " SB1.B1_FILIAL='"+xFilial("SB1")+"' AND"
				cQuery += " SB1.B1_COD=SB7.B7_COD AND"
				cQuery += " SB1.B1_GRUPO>='"+mv_par09+"' AND SB1.B1_GRUPO<='"+mv_par10+"' AND"
				cQuery += " SB1.D_E_L_E_T_<>'*' GROUP BY B7_FILIAL,B7_DATA,B7_COD,B7_LOCAL,B7_TPESTR,B7_LOCALIZ,B7_NUMSERI,B7_LOTECTL,B7_NUMLOTE,B7_DTVALID"
				If lContagem
					cQuery += ",B7_CONTAGE,B7_ESCOLHA"
				EndIf 
				If lExistNF
					cQuery += ",B7_NUMDOC,B7_SERIE,B7_FORNECE,B7_LOJA"
				EndIf
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSQL,.F.,.T.)
				For nX := 1 To Len(aStruSB7)
					If aStruSB7[nX][2]<>"C" .And. FieldPos(aStruSB7[nX][1])<>0
						TcSetField(cAliasSQL,aStruSB7[nX][1],aStruSB7[nX][2],aStruSB7[nX][3],aStruSB7[nX][4])
					EndIf
				Next nX
			Else
				cFilSB7 := 'DTOS(B7_DATA)=="'+dtos(mv_par01)+'".And.'
				cFilSB7 += 'B7_DOC>="'+mv_par11+'".And.B7_DOC<="'+mv_par12+'"'
				MsFilter(cFilSB7)
				dbSetOrder(1)
				dbSeek(xFilial("SB7")+dtos(mv_par01))
			EndIf
		#ELSE
			dbSetOrder(1)
			dbSeek(xFilial("SB7")+dtos(mv_par01))
		#ENDIF
		If !lBatch
			ProcRegua(LastRec(),21,6)
		EndIf
		While !EOF() .And. If(lQuery,.T.,B7_FILIAL+dtos(B7_DATA) == xFilial("SB7")+dtos(mv_par01))
			If !lBatch
				IncProc()
			EndIf
			If !lQuery
				//��������������������������������������������������������������Ŀ
				//� Filtra pelo documento digitado                               �
				//����������������������������������������������������������������
				If B7_DOC < mv_par11 .Or. B7_DOC > mv_par12
					dbSkip()
					Loop
				EndIf

				//��������������������������������������������������������������Ŀ
				//� Filtra pelo codigo do produto                                �
				//����������������������������������������������������������������
				If B7_COD < mv_par05 .Or. B7_COD > mv_par06
					dbSkip()
					Loop
				EndIf

				//��������������������������������������������������������������Ŀ
				//� Filtra pelo almoxarifado inventariado                        �
				//����������������������������������������������������������������
				If B7_LOCAL < mv_par07 .Or. B7_LOCAL > mv_par08
					dbSkip()
					Loop
				EndIf

				//��������������������������������������������������������������Ŀ
				//� Caso utilize contagem so considera a contagem escolhida      �
				//����������������������������������������������������������������
				If lContagem .And. B7_ESCOLHA <> 'S'
					dbSkip()
					Loop
				EndIf

			EndIf

			//�����������������������������������������������������������������Ŀ
			//� Template acionando Ponto de Entrada para validar SB7            �
			//�������������������������������������������������������������������
			If lT340SB7
				lOK := ExecTemplate("MT340SB7",.F.,.F.)
				If (ValType(lOk) == "L")
					If !lOK
						dbSkip()
						Loop
					EndIf
				EndIf
			EndIf

			//��������������������������������������������������������������Ŀ
			//� Ponto de Entrada para Validar o SB7                          �
			//����������������������������������������������������������������
			If l340SB7
				lOK := ExecBlock("MT340SB7",.F.,.F.)
				If (ValType(lOk) == "L")
					If !lOK
						dbSkip()
						Loop
					EndIf
				EndIf
			EndIf

			//��������������������������������������������������������������Ŀ
			//� Filtra itens com digitacao incorreta rastreabilidade         �
			//����������������������������������������������������������������
			If Rastro(B7_COD) .And. Empty(B7_LOTECTL) .Or. (Rastro(B7_COD,"S") .And. Empty(B7_NUMLOTE))
				dbSkip()
				Loop
			EndIf

			//��������������������������������������������������������������Ŀ
			//� Filtra itens com digitacao incorreta localizacao fisica      �
			//����������������������������������������������������������������
			If Localiza(B7_COD) .And. Empty(B7_LOCALIZ+B7_NUMSERI)
				dbSkip()
				Loop
			EndIf

			cCod     := B7_COD
			cLocal   := B7_LOCAL
			dData    := B7_DATA
			cLote	 := B7_NUMLOTE
			cLoteCtl := B7_LOTECTL
			dDtValid := B7_DTVALID
			nQuant   := 0
			nQtSegUm := 0
			nEmpenho := 0
			cLocaliza:=B7_LOCALIZ
			cNumSerie:=B7_NUMSERI
			cEstFis  :=B7_TPESTR
			cContagem:=If(lContagem,B7_CONTAGE,"")
			cLog     :=""
			If lExistNF
				cNumDoc  := B7_NUMDOC
				cSerie   := B7_SERIE
				cFornece := B7_FORNECE
				cLoja    := B7_LOJA
			EndIf

			SB1->(dbSeek(xFilial("SB1")+cCod))

			If !lQuery
				//��������������������������������������������������������������Ŀ
				//� Filtra pelo grupo do produto                                 �
				//����������������������������������������������������������������
				If SB1->B1_GRUPO < mv_par09 .Or. SB1->B1_GRUPO > mv_par10
					dbSkip()
					Loop
				EndIf

				Do While !Eof() .And. B7_FILIAL+dtos(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE+If(lContagem,B7_CONTAGE,"");
						== xFilial("SB7")+dtos(mv_par01)+cCod+cLocal+cLocaliza+cNumSerie+cLoteCtl+cLote+cContagem
					//��������������������������������������������������������������Ŀ
					//� Caso utilize contagem so considera a contagem escolhida      �
					//����������������������������������������������������������������
					If lContagem .And. B7_ESCOLHA <> 'S'
						dbSkip()
						Loop
					EndIf
					//��������������������������������������������������������������Ŀ
					//� Filtra pelo documento digitado                               �
					//����������������������������������������������������������������
					If B7_DOC >= mv_par11 .And. B7_DOC <= mv_par12
						nQuant	+=B7_QUANT
						nQtSegum+=B7_QTSEGUM
					EndIf
					dbSKip()
				EndDo
			Else
				nQuant   := (cAliasSQL)->TOTQUANT
				nQtSegum := (cAliasSQL)->TOTQUANT2
				(cAliasSQL)->(dbSkip())
			EndIf

			cApropri := "0"
			dbSelectArea("SB2")
			dbSetOrder(1)
			If !dbSeek(xFilial("SB2")+cCod+cLocal)
				CriaSB2(cCod,cLocal)
			EndIf
			If Localiza(cCod)
				nTotEnd := SaldoSBF(cLocal,"",cCod)
				If !lCEmpInv .And. Empty(SaldoSBF(cLocal,"",cCOD,NIL,NIL,NIL,.T.))
					If QtdComp(SB2->B2_QATU)-QtdComp(SB2->B2_QACLASS) # QtdComp(nTotEnd)
						cLog     := 'B2BF'
					EndIf
				Else
					//���������������������������������������������������������Ŀ
					//�Verifica se deve considerar somente os empenhos de todos �
					//�os empenhos da tabela de "Requisicoes empenhadas" (SD4). �
					//�����������������������������������������������������������
					If (mv_par13==2)
						If Empty(nTotEnd) 
							nTotEnd := SaldoSBF(cLocal,"",cCOD,NIL,NIL,NIL,.T.)
						Else
							nTotEnd += SaldoSBF(cLocal,"",cCOD,NIL,NIL,NIL,.T.)
						EndIf
						nTotEnd -= SldEmpSD4(cCod,cLocal)
					EndIf

					If QtdComp(SB2->B2_QATU)-QtdComp(SB2->B2_QACLASS)-QtdComp(SB2->B2_QEMP) # QtdComp(nTotEnd)
						cLog     := 'B2BF'
					EndIf
				EndIf
			EndIf
			If Empty(cLog)
				If Rastro(cCod) .Or. Localiza(cCod)
					aSaldo:=CalcEstL(cCod,cLocal,mv_par01+1,cLoteCtl,cLote,cLocaliza,cNumSerie)
					If IntDl(cCod)
						nEmpenho := SB2->B2_RESERVA
						cLog     := 'SB2E'
					Else
						If Localiza(cCod)
							nEmpenho:=EmpLocLz(cCod,cLocal,cLoteCTL,cLote,cLocaliza,cNumSerie)
							cLog:="SBF"
							aSaldo[7]:=ConvUm(SB1->B1_COD, aSaldo[1], aSaldo[7], 2)
						ElseIf Rastro(cCod)
							nEmpenho:=EmpLote(cCod,cLocal,cLoteCTL,cLote)
							cLog:="SB8"
						EndIf
					EndIf
					If Rastro(cCod) .And. cLocal == cLocalCQ
						lLoteInv := .T.
						lLoteInv := A340InvCQ(cCod,cLocal,cLoteCTL,cLote,cLocaliza,cNumSerie,mv_par01+1,nQuant,@aLogs,@lGeraCQ0)
					EndIf
				Else
					If cLocal == cLocalCQ
						aSaldo := A340QtdCQ(cCod,cLocal,mv_par01+1,"")
					Else
						aSaldo := CalcEst(cCod,cLocal,mv_par01+1)
						If !lEstNeg
							nEmpenho:=SB2->B2_RESERVA
							cLog:="SB2E"
						EndIf
					EndIf
				EndIf
				//--> Verifica se o saldo do produto no armazem esta disponivel
				If SB2->B2_STATUS $ "2"
					cLog := "SB2I"
				EndIf
				//�������������������������������������������������Ŀ
				//� Verifica se deve gravar a data do inventario    �
				//� independentemente do saldo em estoque           �
				//���������������������������������������������������
				Begin Transaction
					If SB2->B2_DINVENT <= mv_par01 .And. SB2->B2_STATUS # "2"
						dbSelectArea("SB2")
						RecLock("SB2",.F.)
						Replace B2_DINVENT With mv_par01
						MsUnlockAll()
					EndIf
					If (QtdComp(aSaldo[1]) != QtdComp(nQuant) .Or. QtdComp(aSaldo[7]) != QtdComp(nQtSegum)) .And. B2_DINVENT <= mv_par01 .And. QtdComp(nQuant-aSaldo[1]) != QtdComp(0) .And. lLoteInv
						// Calcula o saldo por lote / enderecamento quando inventaria para uma quantidade menor
						If !Empty(cLoteCtl+cLote+cLocaliza+cNumSerie) .And. (Qtdcomp(aSaldo[1]) > QtdComp(nQuant))
							aSaldoAtu:=CalcEstL(cCod,cLocal,CTOD("31/12/49","ddmmyy"),cLoteCtl,cLote,cLocaliza,cNumSerie)
							nDiferenca:=QtdComp(aSaldo[1])-QtdComp(nQuant)
							If nDiferenca  > QtdComp(aSaldoAtu[1])
								lOkLote:=.F.
							Else
								lOkLote:=.T.
							EndIf
							// Caso nao informe sobre lote / endereco
						Else
							lOkLote:=.T.
						EndIf
						If lOkLote

							If Rastro(cCod) .And. SB2->B2_STATUS # "2"
								nSomaSDD := 0
								nSaldSDD := 0
								aRecnSDD := {}
								SDD->(dbSetOrder(2))
								If SDD->(MsSeek(xFilial("SDD")+cCod+cLocal+cLoteCtl+cLote))
									While SDD->(!Eof()) .And. SDD->(DD_FILIAL+DD_PRODUTO+DD_LOCAL+DD_LOTECTL+DD_NUMLOTE) == xFilial("SDD")+cCod+cLocal+cLoteCtl+cLote
										If SDD->DD_QUANT > 0
											nSomaSDD += SDD->DD_QUANT
											AADD(aRecnSDD,SDD->(Recno()))
										EndIf
										SDD->(dbSkip())
									EndDo
									If QtdComp(nSomaSDD) == QtdComp(nEmpenho)
										nSaldSDD := nQuant/Len(aRecnSDD)
										For nX:= 1 To Len(aRecnSDD)
											SDD->(dbGoto(aRecnSDD[nX]))
											ProcSDD(.T.)
										Next
										For nX:= 1 To Len(aRecnSDD)
											aDados   := {}
											SDD->(dbGoto(aRecnSDD[nX]))
											For nCampo := 1 To SDD->(FCount())
												Aadd(aDados, SDD->(FieldGet(nCampo)))
											Next
											// Checa campo para chave
											dbSelectArea("SDD")
											cDocOri:=SDD->DD_DOC
											dbSetOrder(1)
											While dbSeek(xFilial("SDD")+cDocOri)
												cDocOri:=Soma1(cDocOri,Len(SDD->DD_DOC))
											End
											Reclock("SDD",.T.)
											For nCampo := 1 To SDD->(FCount())
												FieldPut(nCampo, aDados[nCampo])
											Next
											SDD->DD_DOC     := cDocOri
											SDD->DD_QUANT   := nSaldSDD
											SDD->DD_SALDO   := nSaldSDD
											SDD->DD_OBSERVA := "Registro Manipulado Inventario"
											MsUnLock()
											ProcSDD(.F.)
										Next
										nEmpenho := 0
									EndIf
								EndIf
							EndIf

							If QtdComp(nEmpenho) <= If(IntDl(cCod),QtdComp(0),QtdComp(nQuant)) .And. SB2->B2_STATUS # "2"

								If nHdlPrv == NIL
									//���������������������������������������������Ŀ
									//� Cria o cabecalho do arquivo de prova        �
									//�����������������������������������������������
									nHdlPrv := HeadProva(cLoteEst,"MATA340",left(cUserName,6),@cArquivo)
								EndIf
								//��������������������������������������������Ŀ
								//� Pega o numero sequencial do movimento      �
								//����������������������������������������������
								cNumseq := ProxNum()
								dbSelectArea("SD3")
								RecLock("SD3",.T.)
								Replace	D3_FILIAL  With xFilial("SD3"),	D3_COD     With cCod,;
										D3_DOC     With "INVENT" ,	D3_EMISSAO With mv_par01,;
										D3_CC      With mv_par02 ,	D3_GRUPO   With SB1->B1_GRUPO,;
										D3_LOCAL   With cLocal   ,	D3_UM      With SB1->B1_UM,;
										D3_NUMSEQ  With cNumSeq  ,	D3_SEGUM   With SB1->B1_SEGUM,;
										D3_CONTA   With SB1->B1_CONTA,;
										D3_QUANT   With Abs(nQuant - aSaldo[1]),;
										D3_QTSEGUM With Abs(nQtSegUm - aSaldo[7]),;
										D3_TIPO    With SB1->B1_TIPO,;
										D3_LOCALIZ With cLocaliza,;
										D3_TPESTR  With cEstFis,;
										D3_NUMSERI With cNumSerie,;
										D3_LOTECTL With cLoteCtl,;
										D3_NUMLOTE With cLote,;
										D3_USUARIO With upper(CUSERNAME),;
										D3_DTVALID With dDtValid
										If aSaldo[1] > nQuant
											Replace D3_TM With "999",D3_CF With "RE"+cApropri
										Else
											Replace D3_TM With "499",D3_CF With "DE"+cApropri
										EndIf
										Replace D3_CHAVE With SubStr(D3_CF,2,1)+IIF(D3_CF=="DE4","9","0")

								//�����������������������������������������������������Ŀ
								//�Template acionando Ponto de Entrada                  �
								//�������������������������������������������������������
								If ExistTemplate("MT340D3")
									ExecTemplate("MT340D3",.F.,.F.)
								EndIf
								If ExistBlock("MT340D3")
									ExecBlock("MT340D3",.F.,.F.)
								EndIf
								//�������������������������������������������������������Ŀ
								//� Atualiza o CQ dos Modulos de Materiais (SD7)          �
								//���������������������������������������������������������
								If lGeraCQ0
									fGeraCQ0('SD3', SD3->D3_COD, 'IN')
								EndIf
								If cCusMed == "O"
									//��������������������������������������������Ŀ
									//� Pega os custos medios atuais               �
									//����������������������������������������������
									aCM := PegaCMAtu(SD3->D3_COD,SD3->D3_LOCAL)
								Else
									//��������������������������������������������Ŀ
									//� Pega os custos medios finais               �
									//����������������������������������������������
									aCM := PegaCMFim(SD3->D3_COD,SD3->D3_LOCAL)
								EndIf
								//��������������������������������������������Ŀ
								//� Grava o custo da movimentacao              �
								//����������������������������������������������
								aCusto := GravaCusD3(aCM)
								//�������������������������������������������������������Ŀ
								//� Atualiza o saldo atual do estoque com os dados do SD3 �
								//� e caso retorne .T. grava o registro para log de saldo �
								//� negativo.                                             �
								//���������������������������������������������������������
								If	B2AtuComD3(aCusto,,.F.,,,,,,,,,,,,,,,,,,,,,.F.)
									If !lEstNeg
										For i:=1 to Len(aLogs)
											nAchou:=ASCAN(aLogs[i],{|x| x[1] == "SB2" .And. x[2]+x[3] == SD3->D3_COD+SD3->D3_LOCAL})
											If nAchou > 0
												Exit
											EndIf
										Next i
										If nAchou == 0
											//������������������������������������������������Ŀ
											//� Adiciona registro em array p/ baixar empenho.  �
											//��������������������������������������������������
											If Len(aLogs[Len(aLogs)]) > 4095
												AADD(aLogs,{})
											EndIf
											AADD(aLogs[Len(aLogs)],{"SB2",SD3->D3_COD,SD3->D3_LOCAL,"","","",""})
										EndIf
									EndIf
								EndIf

								//�������������������������������������������������������Ŀ
								//� Atualiza o saldo final do estoque com os dados do SD3 �
								//���������������������������������������������������������
								If mv_par14 == 1
									//�������������������������������������������������������Ŀ
									//� Atualiza o saldo final do estoque com os dados do SD3 �
									//���������������������������������������������������������
								B2FimComD3(aCusto)
								EndIf

								//�������������������������������������������������������Ŀ
								//� Cria inspe��o para produto inventariado maior q saldo �
								//���������������������������������������������������������
								If lGeraCQ0
									If aSaldo[1] < nQuant .and. SB1->B1_TIPOCQ=="Q" .and. lExistNF
										aAreaSD5 := SD5->(GetArea())
										SD5->(dbSetOrder(3))
										If SD5->(dbSeek(xFilial('SD5')+SD3->D3_NUMSEQ+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL, .F.))
											cLotCtlQie := SD5->D5_LOTECTL
											cNumLotQie := SD5->D5_NUMLOTE
										EndIf
										SD5->(dbSetOrder(aAreaSD5[2]))
										SD5->(dbGoto(aAreaSD5[3]))

										//Posiciona SD1 de acordo com a nota fiscal informada no SB7
										SD1->(dbSetOrder(2))
										If SD1->(dbSeek(xFilial("SD1")+SD3->D3_COD+cNumDoc+cSerie+cFornece+cLoja))

											//Quando a quantidade do saldo for menor que a quantidade inventariada e produto do tipo quality
											//gerar registro para inspe��o.
											aEnvCele := {	cNumDoc							,; //Numero da Nota Fiscal
															cSerie							,; //Serie da Nota Fiscal
															"N" 							,; //Tipo da Nota Fiscal
															SD1->D1_EMISSAO					,; //Data de Emissao da Nota Fiscal
															SD1->D1_DTDIGIT					,; //Data de Entrada da Nota Fiscal
															"IN"							,; //Tipo de Documento
															SD1->D1_ITEM    				,; //Item da Nota Fiscal
															Space(TamSX3("D1_REMITO")[1])	,; //Numero do Remito (Localizacoes)
															SD1->D1_PEDIDO					,; //Numero do Pedido de Compra
															SD1->D1_ITEMPC	 				,; //Item do Pedido de Compra
															cFornece						,; //Codigo Fornecedor/Cliente
															cLoja							,; //Loja Fornecedor/Cliente
															SD1->D1_LOTEFOR					,; //Numero do Lote do Fornecedor
															Space(6)						,; //Codigo do Solicitante
															SD3->D3_COD						,; //Codigo do Produto
															SD3->D3_LOCAL					,; //Local Origem
															cLotCtlQie  					,; //Numero do Lote
															cNumLotQie						,; //Sequencia do Sub-Lote
															SD3->D3_NUMSEQ					,; //Numero Sequencial
															SD7->D7_NUMERO					,; //Numero do CQ
															SD3->D3_QUANT					,; //Quantidade
															0			   					,; //Preco
															0								,; //Dias de atraso
															" "								,; //TES
															AllTrim(FunName())				,; //Origem
															" "								,; //Origem TXT
															PadR(SD3->D3_QUANT,15)}	  		   //Tamanho do lote original

											//��������������������������������������������������������������Ŀ
											//� Realiza a integracao Materiais x Inspecao de Entradas		 �
											//����������������������������������������������������������������
											aRecCele := qAtuMatQie(aEnvCele,1) 
										EndIf
									EndIf
								EndIf

								If nHdlPrv != NIL .And. (Valtype(nHdlPrv) == "N" .And. nHdlPrv > 0)
									//�������������������������������������������������Ŀ
									//� Gera o lancamento no arquivo de prova           �
									//���������������������������������������������������
									If SD3->D3_TM <= "500"
										nTotal+=DetProva(nHdlPrv,"676","MATA340",cLoteEst)
									Else
										nTotal+=DetProva(nHdlPrv,"674","MATA340",cLoteEst)
									EndIf
								EndIf
								//����������������������������������������������������������Ŀ
								//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
								//������������������������������������������������������������
								If SD3->D3_TM <= "500"
									PcoDetLan("000153","01","MATA340")
								Else
									PcoDetLan("000153","02","MATA340")
								EndIf
								aSaldo := CalcEst(SD3->D3_COD,SD3->D3_LOCAL,Ctod("31/12/49","ddmmyy"))
								RecLock("SB2")
								Replace B2_QATU  With aSaldo[1]
								Replace B2_VATU1 With aSaldo[2]
								Replace B2_VATU2 With aSaldo[3]
								Replace B2_VATU3 With aSaldo[4]
								Replace B2_VATU4 With aSaldo[5]
								Replace B2_VATU5 With aSaldo[6]
								MsUnlockAll()
								If lMT340B2
									ExecBlock("MT340B2",.F.,.F.)
								EndIf
							Else
								For i:=1 to Len(aLogs)
									nAchou:=ASCAN(aLogs[i],{|x| x[1] == cLog .And. x[2]+x[3]+x[4]+x[5]+x[6]+x[7] == cCod+cLocal+cLoteCtl+cLote+cLocaliza+cNumSerie})
									If nAchou > 0
										Exit
									EndIf
								Next i
								If nAchou == 0
									//������������������������������������������������Ŀ
									//� Adiciona registro em array p/ baixar empenho.  �
									//��������������������������������������������������
									If Len(aLogs[Len(aLogs)]) > 4095
										AADD(aLogs,{})
									EndIf
									AADD(aLogs[Len(aLogs)],{cLog,cCod,cLocal,cLoteCtl,cLote,cLocaliza,cNumSerie})
								EndIf
							EndIf
						Else
							cLog:="SLD"
							For i:=1 to Len(aLogs)
								nAchou:=ASCAN(aLogs[i],{|x| x[1] == cLog .And. x[2]+x[3]+x[4]+x[5]+x[6]+x[7] == cCod+cLocal+cLoteCtl+cLote+cLocaliza+cNumSerie})
								If nAchou > 0
									Exit
								EndIf
							Next i
							If nAchou == 0
								//������������������������������������������������Ŀ
								//� Adiciona registro em array p/ baixar empenho.  �
								//��������������������������������������������������
								If Len(aLogs[Len(aLogs)]) > 4095
									AADD(aLogs,{})
								EndIf
								AADD(aLogs[Len(aLogs)],{cLog,cCod,cLocal,cLoteCtl,cLote,cLocaliza,cNumSerie})
							EndIf
						EndIf
					EndIf
				End Transaction
			Else
				For i:=1 to Len(aLogs)
					nAchou:=ASCAN(aLogs[i],{|x| x[1] == cLog .And. x[2]+x[3]+x[4]+x[5]+x[6]+x[7] == cCod+cLocal+cLoteCtl+cLote+cLocaliza+cNumSerie})
					If nAchou > 0
						Exit
					EndIf
				Next i
				If nAchou == 0
					//������������������������������������������������Ŀ
					//� Adiciona registro em array p/ baixar empenho.  �
					//��������������������������������������������������
					If Len(aLogs[Len(aLogs)]) > 4095
						AADD(aLogs,{})
					EndIf
					AADD(aLogs[Len(aLogs)],{cLog,cCod,cLocal,cLoteCtl,cLote,cLocaliza,cNumSerie})
				EndIf
			EndIf
			dbSelectArea(cAliasSql)
		EndDo
		Exit
	EndIf
EndDo

//��������������������������������������������������������������Ŀ
//� Se ele criou o arquivo de prova ele deve gravar o rodape'    �
//����������������������������������������������������������������
If nHdlPrv != NIL .And. (Valtype(nHdlPrv) == "N" .And. nHdlPrv > 0)
	Pergunte("MTA340",.F.)
	//����������������������������������������������������������������Ŀ
	//� mv_par01 - Data a ser considerada                              �
	//� mv_par02 - Em qual centro de custo sera' jogada a diferenca    �
	//� mv_par03 - Se deve mostrar os lancamentos contabeis            �
	//� mv_par04 - Se deve aglutinar os lancamentos contabeis          �
	//� mv_par05 - De  Produto                                         �
	//� mv_par06 - Ate Produto                                         �
	//� mv_par07 - De  Local                                           �
	//� mv_par08 - Ate Local                                           �
	//� mv_par09 - De  Grupo                                           �
	//� mv_par10 - Ate Grupo                                           �
	//������������������������������������������������������������������
	lDigita   := Iif(mv_par03 == 1,.T.,.F.)
	lAglutina := Iif(mv_par04 == 1,.T.,.F.)
	RodaProva(nHdlPrv,nTotal)
	cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina)
EndIf

//�����������������������������������������������������������Ŀ
//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
//�������������������������������������������������������������
PcoFinLan("000153")

MsUnlockAll()

If lQuery
	dbSelectArea(cAliasSQL)
	dbCloseArea()
	dbSelectArea("SB7")
Else
	RETINDEX("SB7")
	dbClearFilter()
EndIf

If Len(aLogs[1]) > 0
	For i:=1 to Len(aLogs)
		For z:=1 to Len(aLogs[i])
			// Verifica saldo em estoque
			If aLogs[i,z,1] == "SB2"
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial("SB2")+aLogs[i,z,2]+aLogs[i,z,3])
					If B2_QATU > 0 .And. B2_STATUS # "2"
						aLogs[i,z,1] := "OK"
					EndIf
				EndIf
			EndIf
		Next z
	Next i
	A340LstNeg(aLogs)
EndIf
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A340LstNeg� Autor �Rodrigo de A. Sartorio � Data � 10/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Produtos que ficaram com o saldo negativo     ���
���          � ou tiveram itens que nao podem ser inventariados           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST/SIGAPCP                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A340LstNeg(aLogs)
//��������������������������������������������������������������Ŀ
//� Variaveis obrigatorias dos programas de relatorio            �
//����������������������������������������������������������������
LOCAL titulo   := "Itens nao Inventariados"
LOCAL cDesc1   := "O relatorio lista os produtos que nao puderam ser inventariados por "
LOCAL cDesc2   := "alguma situacao que impede a correta contagem de seus saldos e lista "
LOCAL cDesc3   := "tb produtos que continuam com saldo divergente apos o processamento."
LOCAL cString  := "SB2"
LOCAL wnrel    := "MATA340"

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
PRIVATE aReturn:= {"Zebrado",1,"Administracao", 2, 2, 1, "",1 }	//
PRIVATE nLastKey:= 0,cPerg:="      "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=	SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)
If nLastKey = 27
	dbClearFilter()
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	dbClearFilter()
	Return
EndIf

RptStatus({|lEnd| C340Imp(@lEnd,wnRel,titulo,aLogs)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C340IMP  � Autor � Rodrigo de A. Sartorio� Data � 10/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA340                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C340Imp(lEnd,WnRel,titulo,aLogs)
//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������
LOCAL Tamanho  := "P"
LOCAL nTipo    := 0
LOCAL cRodaTxt := "REGISTRO(S)"
LOCAL nCntImpr := 0
LOCAL i,z

//��������������������������������������������������������������Ŀ
//� Inicializa variaveis para controlar cursor de progressao     �
//����������������������������������������������������������������
SetRegua(Len(aLogs))

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIF(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
PRIVATE li := 80 ,m_pag := 1

//����������������������������������������������������������Ŀ
//� Cria o cabecalho.                                        �
//������������������������������������������������������������
cabec1 := "OCOR PRODUTO         DESCRICAO       LOCAL   QUANTIDADE     LOTE      SUB-LOTE"
cabec2 := "                                            LOCALIZACAO     NUMERO DE SERIE   "
//                   1234 123456789012345 12345678901234545 12   12345678901234  1234567890 123456
//                                                               123456789012345 12345678901234567890
//                   0         1         2         3         4         5         6         7         8
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890

SB1->(dbSetOrder(1))
SB2->(dbSetOrder(1))

For i:=1 to Len(aLogs)
	IncRegua()
	For z:=1 to Len(aLogs[i])
		If aLogs[i,z,1] != "OK"
			If li > 58
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			SB1->(dbSeek(xFilial("SB1")+aLogs[i,z,2]))
			SB2->(dbSeek(xFilial("SB2")+aLogs[i,z,2]+aLogs[i,z,3]))
			@ li,000 PSay aLogs[i,z,1]
			@ li,005 PSay aLogs[i,z,2] Picture PesqPict("SD3","D3_COD",15)
			@ li,021 PSay Left(SB1->B1_DESC,15) Picture PesqPict("SB1","B1_DESC",15)
			@ li,039 PSay aLogs[i,z,3] Picture PesqPict("SD3","D3_LOCAL",2)
			@ li,044 PSay SB2->B2_QATU	Picture PesqPictQt("B2_QATU",14)
			@ li,060 PSay aLogs[i,z,4]	Picture PesqPict("SB7","B7_LOTECTL",10)
			@ li,071 PSay aLogs[i,z,5]	Picture PesqPict("SB7","B7_NUMLOTE",8)
			If !Empty(aLogs[i,z,6]+aLogs[i,z,7])
				li++
				@ li,044 PSay aLogs[i,z,6]	Picture PesqPict("SB7","B7_LOCALIZ",15)
				@ li,060 PSay aLogs[i,z,7]	Picture PesqPict("SB7","B7_NUMSERI",20)
			EndIf
			li++
		EndIf
	Next z
Next i


If li != 80
	If li >= 50
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	Else
		li++
	EndIf
	@ li,10 PSay "Legenda das Ocorrencias"
	li++
	@ li,10 PSay "SB2  - > Itens com saldo negativo nos Saldos em estoque."
	li++
	@ li,10 PSay "SLD  - > O inventario comprometeria o saldo atual do produto"
	li++
	@ li,10 PSay "SB2E/SB8/SBF - > Itens empenhados / reservados no arquivo SB2/SB8/SBF"
	li++
	@ li,10 PSay "SB2I - > Itens com saldo Indisponivel nos Saldos em Estoque"
	li++
	@ li,10 PSay "B2BF - > Itens com saldo desbalanceado entre o SB2 e o SBF, favor"
	li++
	@ li,10 PSay "         verificar todos os processos pendentes para a tabela SBF "
	li++
	@ li,10 PSay "         como por exemplo: enderecamentos pendentes e empenhos para"
	li++
	@ li,10 PSay "         producao com enderecos pendentes."
	li++
	@ li,10 PSay "INV   - > Itens com movimentacoes de C.Q."
	li++
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

Set Device to Screen

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A340QtdCQ � Autor � Rodrigo de A. Sartorio� Data � 05/05/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calcula o saldo rejeitado do produto no almoxarifado de CQ. ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA340                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function  A340QtdCQ(cProduto,cLocal,dData,cLote)
Local cAlias:= Alias(), nOrdem := IndexOrd()
Local cCond
Local aQtd:={0,0,0,0,0,0,0}
dbSelectArea("SD7")
If lLocCQ
	cNomArq:= CriaTrab("",.F.)
	cCond:='D7_ESTORNO != "S" .And. D7_TIPO == 2 .And. DTOS(D7_DATA) < "'+DTOS(dData)+'"'
	IndRegua("SD7",cNomArq,"D7_FILIAL+D7_PRODUTO+D7_LOCAL+D7_NUMLOTE",,cCond,"Selecionando Registros...")
	nNewOrd:=RetIndex("SD7")
	DbSelectArea("SD7")
	#IFNDEF TOP
		DbSetIndex(cNomArq+OrdBagExt())
	#ENDIF
	lLocCQ:=.F.
	DbSetOrder(nNewOrd+1)
EndIf
dbGotop()
If Empty(cLote)
	dbSeek(xFilial("SD7")+cProduto+cLocal)
	Do While !Eof() .And. D7_FILIAL+D7_PRODUTO+D7_LOCAL == xFilial("SD7")+cProduto+cLocal
		aQtd[1] += SD7->D7_QTDE
		dbSkip()
	EndDo
Else
	dbSeek(xFilial("SD7")+cProduto+cLocal+cLote)
	Do While !Eof() .And. D7_FILIAL+D7_PRODUTO+D7_LOCAL+D7_NUMLOTE == xFilial("SD7")+cProduto+cLocal+cLote
		aQtd[1] += SD7->D7_QTDE
		dbSkip()
	EndDo
EndIf

If aQtd[1] > 0
	// Subtraio qtd. j� devolvida
	dbSelectArea("SD2")
	dbSetOrder(1)
	dbSeek(xFilial("SD2")+cProduto+cLocal)
	Do While !Eof() .And. D2_FILIAL+D2_COD+D2_LOCAL == xFilial("SD2")+cProduto+cLocal
		If D2_TIPO != "D"
			dbSkip()
			Loop
		EndIf
		dbSelectArea("SF4")
		dbSetOrder(1)
		If dbSeek(xFilial("SF4")+SD2->D2_TES) .And. F4_ESTOQUE == "S"
			aQtd[1] -= SD2->D2_QUANT
		EndIf
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+cProduto)
		aQtd[7]:= ConvUm(SB1->B1_COD,aQtd[1],aQtd[7],2)
	EndIf
EndIf
dbSelectArea(cAlias)
dbSetOrder(nOrdem)
Return aQtd

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A340InvCQ � Autor � Nereu Humberto Junior � Data � 13/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calcula o saldo do produto no almoxarifado de CQ.           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA340                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function  A340InvCQ(cCod,cLocal,cLoteCTL,cLote,cLocaliza,cNumSerie,dData,nQtdInv,aLogs,lGeraCQ0)

Local aArea    := GetArea()
Local cCond    := ""
Local cLog     := ""
Local aMov     := {}
Local aSaldoCQ := {}
Local aStruSD7 := {}
Local nQtde    := 0
Local nSaldo   := 0
Local nRecSD7  := 0,i:=0,nX:=0
Local lRet     := .T.
Local lQuery   := .F.
Local cAliasSD7:= "SD7"
lGeraCQ0 := .F.

dbSelectArea("SD7")
#IFDEF TOP
	If ( TcSrvType()!="AS/400" )
		lQuery   :=.T.
		cAliasSD7:= "SD7SQL"
		aStruSD7 := SD7->(dbStruct())
		cQuery := "SELECT D7_NUMERO, D7_PRODUTO, D7_LOCAL, D7_TIPO, D7_DATA, D7_LOTECTL, D7_NUMLOTE, R_E_C_N_O_ RECNOSD7"
		cQuery += " FROM "
		cQuery += RetSqlName("SD7")+" SD7 "
		cQuery += " WHERE D7_FILIAL='"+xFilial("SD7")+"' AND"
		cQuery += " D7_PRODUTO ='"+cCod+"' AND "
		cQuery += " D7_LOCAL ='"+cLocal+"' AND "
		cQuery += " D7_TIPO = 0 AND "
		cQuery += " D7_DATA <'"+DTOS(dData)+"' AND"
		cQuery += " D7_LOTECTL ='"+cLoteCTL+"' AND "
		If Rastro(cCod,"S")
			cQuery += " D7_NUMLOTE ='"+cLote+"' AND "
		EndIf
		cQuery += " D_E_L_E_T_<>'*' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD7,.F.,.T.)
		For nX := 1 To Len(aStruSD7)
			If aStruSD7[nX][2]<>"C" .And. FieldPos(aStruSD7[nX][1])<>0
				TcSetField(cAliasSD7,aStruSD7[nX][1],aStruSD7[nX][2],aStruSD7[nX][3],aStruSD7[nX][4])
			EndIf
		Next nX
	Else
#ENDIF
	cNomArq:= CriaTrab("",.F.)
	cCond:='D7_PRODUTO == "'+cCod+'" .And. D7_LOCAL == "'+cLocal+'" .And. D7_TIPO == 0'
	cCond+=' .And. DTOS(D7_DATA) < "'+DTOS(dData)+'"  .And. D7_LOTECTL == "'+cLoteCTL+'"'
	If Rastro(cCod,"S")
		cCond+=' .And. D7_NUMLOTE == "'+cLote+'"'
	EndIf

	IndRegua(cAliasSD7,cNomArq,"D7_FILIAL+D7_PRODUTO+D7_LOCAL+D7_NUMLOTE",,cCond,"Selecionando Registros...")
	nNewOrd:=RetIndex("SD7")
	DbSelectArea("SD7")
	DbSetIndex(cNomArq+OrdBagExt())
	dbSetOrder(nNewOrd+1)
	#IFDEF TOP
	EndIf
	#ENDIF

dbSelectArea(cAliasSD7)
dbGotop()

While (cAliasSD7)->(!Eof())
	aSaldoCQ := A175CalcQt((cAliasSD7)->D7_NUMERO,(cAliasSD7)->D7_PRODUTO,(cAliasSD7)->D7_LOCAL)
	nQtde  += aSaldoCQ[1]
	nSaldo += aSaldoCQ[6]
	If lQuery
		nRecSD7 := (cAliasSD7)->RECNOSD7
	Else
		nRecSD7 := (cAliasSD7)->(Recno())
	EndIf
	(cAliasSD7)->(dbSkip())
EndDo

If ( QtdComp(nQtde) == QtdComp(nSaldo) )
	If nRecSD7 # 0
		If QtdComp(nQtdInv) < QtdComp(nSaldo)
			dbSelectArea("SD7")
			SD7->(dbGoTo(nRecSD7))

			aAdd(aMov, {})
			aAdd(aMov[Len(aMov)], 2)
			aAdd(aMov[Len(aMov)], nSaldo-nQtdInv )
			aAdd(aMov[Len(aMov)], SD7->D7_LOCAL )
			aAdd(aMov[Len(aMov)], dDatabase )
			aAdd(aMov[Len(aMov)], "" )
			aAdd(aMov[Len(aMov)], "FH" )
			aAdd(aMov[Len(aMov)], "Registro Manipulado Inventario" )
			aAdd(aMov[Len(aMov)], ConvUm(SD7->D7_PRODUTO,(nSaldo-nQtdInv),0,2) )
			aAdd(aMov[Len(aMov)], cLocaliza )
			aAdd(aMov[Len(aMov)], cNumSerie )

			fGravaCQ(SD7->D7_PRODUTO, SD7->D7_NUMERO, .F., aMov, PegaCMD3(), Nil,0)
		ElseIf QtdComp(nQtdInv) > QtdComp(nSaldo)
			lGeraCQ0 := .T.
		EndIf
	EndIf
Else
	lRet := .F.
	cLog := "INV"
	For i:=1 to Len(aLogs)
		nAchou:=ASCAN(aLogs[i],{|x| x[1] == cLog .And. x[2]+x[3]+x[4]+x[5] == cCod+cLocal+cLoteCtl+cLote})
		If nAchou > 0
			Exit
		EndIf
	Next i
	If nAchou == 0
		If Len(aLogs[Len(aLogs)]) > 4095
			AADD(aLogs,{})
		EndIf
		AADD(aLogs[Len(aLogs)],{cLog,cCod,cLocal,cLoteCtl,cLote,"",""})
	EndIf
	cLog := ""
EndIf

If lQuery
	dbSelectArea(cAliasSD7)
	dbCloseArea()
Else
	dbSelectArea("SD7")
	RetIndex("SD7")
	dbClearFilter()
	Ferase(cNomArq+OrdBagExt())
EndIf

RestArea(aArea)

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SldEmpSD4 �Autor  �Erike Yuri da Silva � Data �  05/23/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calcula o saldo empenhado do produto no SD4                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA340                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SldEmpSD4(cProd,cLocal,cLocaliz,cNumSerie,cLoteCtl,cNumLote)
Local cAlias:=Alias(),nRecno:=Recno(),nOrder:=IndexOrd()
Local cAliasSD4	:= "SD4"
Local cSD4FilOld:= ""
Local cQuery	:= ""
Local nSaldo	:= 0
Local aSD4		:= {}
Local aTam		:= {}

cLocaliz	:= If(cLocaliz	== Nil .Or. Empty(cLocaliz)		, CriaVar('BF_LOCALIZ', .F.), cLocaliz)
cNumSerie	:= If(cNumSerie	== Nil .Or. Empty(cNumSerie)	, CriaVar('BF_NUMSERI', .F.), cNumSerie)
cLoteCtl	:= If(cLoteCtl	== Nil .Or. Empty(cLoteCtl)		, CriaVar('BF_LOTECTL', .F.), cLoteCtl)
cNumLote	:= If(cNumLote	== Nil .Or. Empty(cNumLote)		, CriaVar('BF_NUMLOTE', .F.), cNumLote)

DbSelectArea("SD4")
aSD4 := GetArea("SD4")
SD4->(DbSetOrder(3))

//�������������������������������������������������������������Ŀ
//�Para ambiente TOP nao sera usado filtro(MSFILTER) para ganho �
//�de performance utilizando os recursos do banco para soma.    �
//���������������������������������������������������������������
#IFDEF TOP
	cAliasSD4	:= "SALDOSD4"
	cQuery		:= "SELECT SUM(SD4.D4_QUANT) QTDSD4 FROM "+RetSqlName("SD4")+" SD4 "
	cQuery		+= " WHERE SD4.D4_FILIAL ='"+xFilial("SD4")+"' AND "
	cQuery		+= " SD4.D4_QUANT > 0 AND "
	// Considera endereco e numero de serie no filtro
	If !Empty(cLocaliz+cNumSerie)
		cQuery	+= "SD4.D4_LOCALIZ ='"+cLocaliza+"' AND SD4.D4_NUMSERI='"+cNumSerie+"' AND "
	EndIf
	// Considera Lote no filtro
	If !Empty(cLoteCtl)
		cQuery	+= "SD4.D4_LOTECTL ='"+cLoteCtl+"' AND "
	EndIf
	// Considera sub-lote no filtro
	If !Empty(cNumLote)
		cQuery	+= "SD4.D4_NUMLOTE ='"+cNumLote+"' AND "
	EndIf
	cQuery	+= "SD4.D4_COD ='"+cProd+"' AND SD4.D4_LOCAL='"+cLocal+"' AND SD4.D_E_L_E_T_=' '"
	cQuery	:= ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD4,.T.,.T.)
	aEval(SD4->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasSD4,x[1],x[2],x[3],x[4]),Nil)})

	aTam := TamSx3("D4_QUANT")
	TCSetField( cAliasSD4, "QTDSD4", "N",aTam[1] , aTam[2] )

	nSaldo := (cAliasSD4)->QTDSD4
	(cAliasSD4)->( DbCloseArea() )

#ELSE
	//Guarda Filtro caso exista
	cSD4FilOld := SD4->(DbFilter())

	cQuery	:= "D4_FILIAL=='" + xFilial( "SD4" ) + "' .And. "
	// Considera endereco e numero de serie no filtro
	If !Empty(cLocaliz+cNumSerie)
		cQuery	+= "D4_LOCALIZ =='"+cLocaliza+"' .And. D4_NUMSERI=='"+cNumSerie+"' .And. "
	EndIf
	// Considera Lote no filtro
	If !Empty(cLoteCtl)
		cQuery	+= "D4_LOTECTL =='"+cLoteCtl+"' .And. "	
	EndIf
	// Considera sub-lote no filtro
	If !Empty(cNumLote)
		cQuery	+= "D4_NUMLOTE =='"+cNumLote+"' .And. "	
	EndIf
	cQuery += "D4_COD=='" + cProd + "' .And. D4_LOCAL='"+cLocal+"'"

	If !Empty(cSD4FilOld)
		SD4->(DbClearFilter())
	EndIf

	//Filtra os dados
	SD4->(DbSetFilter( {|| &cQuery }, cQuery ))

	dbGotop()
	While SD4->(!Eof())
		nSaldo += SD4->D4_QUANT
		SD4->(DbSkip())
	EndDo

	//Restaura Filtro caso exista
	If Empty(cSD4FilOld)
		SD4->(DbClearFilter())
	Else
		SD4->(DbClearFilter())
		SD4->(DbSetFilter( {|| &cSD4FilOld }, cSD4FilOld ))
	EndIf
#ENDIF

//�����������������Ŀ
//�Restaura Ambiente�
//�������������������
SD4->( RestArea(aSD4) )
dbSelectArea(cAlias)
dbSetOrder(nOrder)
dbGoto(nRecno)

Return nSaldo

