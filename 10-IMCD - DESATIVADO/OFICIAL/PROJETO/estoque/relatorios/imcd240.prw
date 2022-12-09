#INCLUDE "MATR240.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR240  � Autor � Ricardo Berti		    � Data �10/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Saldos em Estoques                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IMCD240()

Local oReport

//-- Interface de impressao�
oReport:= ReportDef()
oReport:PrintDialog()

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Ricardo Berti		    � Data �10/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Objeto Report do Relatorio                          		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR240			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local cAliasTOP	:= "SB1"
Local cAliasSB2	:= "SB2"
Local cAliasSB5	:= "SB5"
Local aOrdem    := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007)} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '
Local lVEIC		:= UPPER(GETMV("MV_VEICULO"))=="S"
Local cPerg		:= "MTR240"
Local cPict		:= ''

Local oSection

Local aSizeQT	:= TamSX3("B2_QATU")
Local aSizeQTF  := TamSX3("B2_QFIM")

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//��������������������������������������������������������������������������
oReport:= TReport():New("MATR240",STR0001,cPerg, {|oReport| ReportPrint(oReport,@cAliasTOP,@cAliasSB2,lVeic,aOrdem,@cAliasSB5)},STR0002+" "+STR0003) //'Saldos em Estoque'##"Este programa ira' emitir um resumo dos saldos, em quantidade,"##'dos produtos em estoque.'
oReport:SetPortrait() //Define a orientacao default de pagina do relatorio como retrato.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//�����������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                  �
//� mv_par01     // Aglutina por: Almoxarifado / Filial / Empresa         �
//� mv_par02     // Filial de                                             �
//� mv_par03     // Filial ate                                            �
//� mv_par04     // Almoxarifado de                                       �
//� mv_par05     // Almoxarifado ate                                      �
//� mv_par06     // Produto de                                            �
//� mv_par07     // Produto ate                                           �
//� mv_par08     // tipo de                                               �
//� mv_par09     // tipo ate                                              �
//� mv_par10     // grupo de                                              �
//� mv_par11     // grupo ate                                             �
//� mv_par12     // descricao de                                          �
//� mv_par13     // descricao ate                                         �
//� mv_par14     // imprime qtde zeradas                                  �
//� mv_par15     // Saldo a considerar : Atual / Fechamento / Movimento   �
//� mv_par16     // Lista Somente Saldos Negativos                 		  �
//� mv_par17     // Descricao Produto : Cientifica / Generica      		  �
//� mv_par18   	 // QTDE. na 2a. U.M. ?     (Sim/Nao)                     �
//� mv_par19   	 // Imprime descricao do Armazem ? (Sim/Nao)              �
//� mv_par20   	 // Filtro por principal               �
//�������������������������������������������������������������������������
Pergunte(oReport:uParam,.F.)

If ( cPaisLoc=="CHI" )
	cPict   := "@E 999,999,999.99"
Else
	cPict	:= PesqPictQt(If(mv_par15==1,'B2_QATU','B2_QFIM'),If(mv_par15==1, aSizeQT[1], aSizeQTF[1]))
EndIf
//��������������������������������������������������������������Ŀ
//� Criacao da Secao 1                                           �
//����������������������������������������������������������������
oSection := TRSection():New(oReport,STR0001,{"SB1","SB2","NNR"},aOrdem) //'Saldos em Estoque'
oSection:SetHeaderPage()
oSection:SetTotalInLine(.F.)
oSection:SetReadOnly()  // Desabilita a edicao das celulas permitindo filtro

TRCell():New(oSection,'B1_CODITE'	, 'SB1')
TRCell():New(oSection,'B2_COD'		,'SB2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'B1_TIPO'		,'SB1')
TRCell():New(oSection,'B1_GRUPO'	,'SB1')
TRCell():New(oSection,'B1_DESC'		,'SB1',,,,,{ || If(mv_par17 == 1 .And. !Empty((cAliasSB5)->B5_CEME),(cAliasSB5)->B5_CEME,(cAliasTOP)->B1_DESC) })
TRCell():New(oSection,'B1_UM'		,'SB1')
TRCell():New(oSection,'B2_FILIAL'	,'SB2')
TRCell():New(oSection,'B2_LOCAL'	,'SB2')
TRCell():New(oSection,'QUANT'		,'SB2')
oSection:Cell("QUANT"):GetFieldInfo(If(mv_par15==1,'B2_QATU','B2_QFIM'))
oSection:Cell("QUANT"):SetTitle(STR0022) //STR0022  "Qtde.1a.U.M."
oSection:Cell("QUANT"):SetPicture(cPict)  
oSection:Cell("QUANT"):SetSize(42+len(STR0022))
TRCell():New(oSection,'B1_SEGUM'	,'SB1')
TRCell():New(oSection,'QUANT2'		,'SB2')
oSection:Cell("QUANT2"):GetFieldInfo('B2_QTSEGUM')
oSection:Cell("QUANT2"):SetTitle('.'+SPACE(30)+STR0023) //"Qtde.2a.U.M."
oSection:Cell("QUANT2"):SetPicture(cPict)
TRCell():New(oSection,'DISPON'		,'',Left(STR0018,1)+'/'+Left(STR0019,1),,,,{ || Left( If(SubStr((cAliasSB2)->B2_STATUS,1,1)$"2",STR0019,STR0018) ,1) }) //"Disponivel   "##"Indisponivel"
TRCell():New(oSection,'NNR_DESCRI'	,"NNR")


Return(oReport)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor � Ricardo Berti	    � Data �10/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �ExpC1: Alias do arquivo principal							  ���
���          �ExpC2: Alias do arquivo SB2								  ���
���          �ExpL1: indica utilizacao de SIGAVEI, SIGAPEC e SIGAOFI	  ���
���          �ExpA1: Array das ordens do relatorio						  ���
���          �ExpC3: Alias do arquivo SB5								  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR240			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasTOP,cAliasSB2,lVeic,aOrdem,cAliasSB5)

Local oSection   := oReport:Section(1)
Local nOrdem     := oSection:GetOrder()
Local oTotaliz
Local oBreak

//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������
Local nX         := 0
Local nRegM0     := 0
Local nQtdProd   := 0
Local cCampo     := ''
Local cMens      := ''
Local aArea
Local cFilOld    := '��'
Local cCodAnt    := '��'
Local nQuant     := 0.00
Local nQuant2    := 0.00
Local aFiliais   := {}
Local cNomArqB2  := ''
Static cCompFil  := ''
//��������������������������������������������������������������Ŀ
//� Variaveis Locais utilizadas na montagem das Querys           �
//����������������������������������������������������������������
Local cWhere	:= ""
Local cSelect	:= ""
Local cOrderBy  := ""
Local cGroupBy  := ""
Local cJoin		:= ""


//��������������������������������������������������������������Ŀ
//� Ajustar variaveis LOCAIS para SIGAVEI, SIGAPEC e SIGAOFI     �
//����������������������������������������������������������������
Local cCodite    := ''

//��������������������������������������������������������������Ŀ
//� Ajustar variaveis PRIVATE para SIGAVEI, SIGAPEC e SIGAOFI    �
//����������������������������������������������������������������
PRIVATE XSB1			:= XFILIAL('SB1')
PRIVATE XSB2			:= XFILIAL('SB2')
PRIVATE XSB5			:= XFILIAL('SB5')

//������������������������������������������������������������Ŀ
//� Adiciona a ordem escolhida ao Titulo do relatorio          �
//��������������������������������������������������������������
oReport:SetTitle(oReport:Title()+" - ("+AllTrim(aOrdem[nOrdem])+")")

//Quebra de linha
oSection:Cell('B2_COD'):SetAutoSize(.T.) 		
oSection:Cell('B2_COD'):SetLineBreak(.T.) 		
oSection:Cell('B1_DESC'):SetAutoSize(.T.) 		
oSection:Cell('B1_DESC'):SetLineBreak(.T.) 

//��������������������������������������������������������������Ŀ
//� Definicao da linha de SubTotal                               |
//����������������������������������������������������������������
If nOrdem == 1 		//-- SubTotal por Codigo
	oBreak := TRBreak():New(oSection,oSection:Cell("B2_COD"),/*STR0014*/,.f.)				//"Total do Produto"
ElseIf nOrdem == 2 		//-- SubTotal por Tipo
	oBreak := TRBreak():New(oSection,oSection:Cell("B1_TIPO"),STR0016+" "+STR0011,.F.)	//"Total do "##"Tipo.........."
ElseIf nOrdem == 3 		//-- SubTotal por Descricao
	oBreak := TRBreak():New(oSection,oSection:Cell("B1_DESC"),/*STR0014*/,.f.)				//"Total do Produto"
ElseIf nOrdem == 4		//-- SubTotal por Grupo
	oBreak := TRBreak():New(oSection,oSection:Cell("B1_GRUPO"),STR0016+" "+STR0012,.F.)	//"Total do "##"Grupo........."
EndIf

If nOrdem == 1 .Or. nOrdem == 3  //-- SubTotal por Codigo ou Descricao

	// Subtotais do produto impressos em colunas: alguns totalizadores imprimirao os titulos a esquerda (porque ha' 3 linhas de totais)
	oTotaliz := TRFunction():New(oSection:Cell('QUANT'),"DISP1"/*cID*/,"SUM",oBreak,"(" + Substr(STR0018,1,1)+ ") = " + STR0017 + STR0018/*Titulo*/,/*cPicture*/, /*uFormula*/,.F.,.F./*lEndPage*/,/*Obj*/) //"Qtde. "##"Disponivel   "
	oTotaliz:SetCondition({ || SubStr((cAliasSB2)->B2_STATUS,1,1)<>"2"})

	If mv_par18 == 1 // 2a.U.M.
		oTotaliz := TRFunction():New(oSection:Cell('QUANT2'),"DISP2","SUM",oBreak,"(" + Substr(STR0018,1,1)+ ") = " + STR0017 + STR0018 /* + ' 2a.U.M.'Titulo*/,,,.F.,.F.,/*Obj*/) //"Qtde. "##"Disponivel   "
		oTotaliz:SetCondition({ || SubStr((cAliasSB2)->B2_STATUS,1,1)<>"2"})
	EndIf
	oTotaliz := TRFunction():New(oSection:Cell('QUANT'),"INDISP1","SUM",oBreak,"(" + SubStr(STR0019,1,1)+ ") = " + STR0017 + STR0019,,,.F.,.F.,/*Obj*/)		 //"Qtde. "##"Indisponivel "
	oTotaliz:SetCondition({ || SubStr((cAliasSB2)->B2_STATUS,1,1)$"2"})

	If mv_par18 == 1 // 2a.U.M.
		oTotaliz := TRFunction():New(oSection:Cell('QUANT2'),"INDISP2","SUM",oBreak,"(" + SubStr(STR0019,1,1)+ ") = " + STR0017 + STR0019 /*+ ' 2a.U.M.'Titulo*/,,,.F.,.F.,/*Obj*/) //"Qtde. "##"Indisponivel "
		oTotaliz:SetCondition({ || SubStr((cAliasSB2)->B2_STATUS,1,1)$"2"})
	EndIf

EndIf

oTotaliz := TRFunction():New(oSection:Cell('QUANT'),"QT1","SUM",oBreak,If(Alltrim(Str(nOrdem)) $ "1|3",STR0014,),,,.F.,.F.,/*Obj*/) 	//"Total do Produto"
If mv_par18 == 1
	oTotaliz := TRFunction():New(oSection:Cell('QUANT2'),"QT2","SUM",oBreak,,,,.F.,.F.,/*Obj*/)
EndIf

//-- Alimenta Array com Filiais a serem Pesquisadas
aFiliais := {}
nRegM0   := SM0->(Recno())
SM0->(DBSeek(cEmpAnt, .T.))
Do While !SM0->(Eof()) .And. SM0->M0_CODIGO == cEmpAnt
	If SM0->M0_CODFIL >= mv_par02 .And. SM0->M0_CODFIL <= mv_par03
		aAdd(aFiliais, SM0->M0_CODFIL)
	EndIf
	SM0->(dbSkip())
EndDo
SM0->(dbGoto(nRegM0))

//���������������������������������������������������������������Ŀ
//�	Visualizacao de colunas conforme parametrizacao				  �
//�����������������������������������������������������������������
If mv_par18 == 2
	oSection:Cell('B1_SEGUM'):Disable()
	oSection:Cell('QUANT2'):Disable()
EndIf	
If ! lVeic
	oSection:Cell('B1_CODITE'):Disable()
EndIf

If ! (mv_par19 == 1 .And. mv_par01==1)
	oSection:Cell('NNR_DESCRI'):Disable()
EndIf
//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �	
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//� Clausula LEFT JOIN p/ Descr.Cientifica (SB5)                           |
//��������������������������������������������������������������������������
cJoin := "%"
cJoin += "   JOIN " + RetSqlName("SB1") + " SB1 ON "

If FWModeAccess("SB1") == "E" .And. FWModeAccess("SB2") == "E"
	cJoin += "  SB1.B1_FILIAL =  SB2.B2_FILIAL AND "
EndIf
 	
If FWModeAccess("SB1",3) == "E"
	cJoin += " SB1.B1_FILIAL >= '" + mv_par02 + "' AND "
	cJoin += " SB1.B1_FILIAL <= '" + mv_par03 + "' AND "
ElseIf FWModeAccess("SB1",2) == "E"
	cJoin += " SB1.B1_FILIAL >= '" + PadR(Substr(MV_PAR02,1,Len(FWSM0Layout(,1)) +Len(FWSM0Layout(,2))),FWSizeFilial()) + "' AND "
	cJoin += " SB1.B1_FILIAL <= '" + PadR(Substr(MV_PAR03,1,Len(FWSM0Layout(,1)) +Len(FWSM0Layout(,2))),FWSizeFilial()) + "' AND "
ElseIf FWModeAccess("SB1",1) == "E"
	cJoin += " SB1.B1_FILIAL >= '" + PadR(Substr(MV_PAR02,1,Len(FWSM0Layout(,1))),FWSizeFilial()) + "' AND "
	cJoin += " SB1.B1_FILIAL <= '" + PadR(Substr(MV_PAR03,1,Len(FWSM0Layout(,1))),FWSizeFilial()) + "' AND "
Else
	cJoin += " SB1.B1_FILIAL >= '" + Space(FWSizeFilial()) + "' AND "
	cJoin += " SB1.B1_FILIAL <= '" + Space(FWSizeFilial()) + "' AND "
EndIf

cJoin += " SB1.B1_COD    = SB2.B2_COD AND "
cJoin += " SB1.B1_TIPO  >= '" + mv_par08 + "' AND "
cJoin += " SB1.B1_TIPO  <= '" + mv_par09 + "' AND "
cJoin += " SB1.B1_GRUPO >= '" + mv_par10 + "' AND "
cJoin += " SB1.B1_GRUPO <= '" + mv_par11 + "' AND "
cJoin += " SB1.B1_DESC  >= '" + mv_par12 + "' AND "
cJoin += " SB1.B1_DESC  <= '" + mv_par13 + "' AND "
cJoin += " SB1.B1_X_PRINC BETWEEN '" + Alltrim(mv_par20) + "' AND '" + Alltrim(mv_par21) + "' " 

cJoin += " AND SB1.D_E_L_E_T_ = ' ' "
If mv_par17 == 1
	cJoin += " LEFT JOIN " + RetSqlName("SB5") + " SB5 "
	cJoin += "     ON  SB5.B5_FILIAL = '" + xFilial("SB5") + "' "
	cJoin += "     AND SB5.B5_COD    = SB1.B1_COD "
	cJoin += "     AND SB5.D_E_L_E_T_ = ' ' "
EndIf	
If  mv_par19 == 1 .And. mv_par01==1
	cJoin += " LEFT JOIN " + RetSqlName("NNR") + " NNR "
	cJoin += "     ON  NNR.NNR_FILIAL = '" + xFilial("NNR") + "' "
	cJoin += "     AND NNR.NNR_CODIGO = SB2.B2_LOCAL "
	cJoin += "     AND NNR.D_E_L_E_T_ = ' ' "
EndIf	
cJoin += "%"
//������������������������������������������������������������������������Ŀ
//� Filtro adicional no clausula Where                                     |
//��������������������������������������������������������������������������

cSelect := "%"
If mv_par18 == 1	//-- 2a.U.M.
	cSelect += ", SB1.B1_SEGUM SEGUM"
EndIf
If lVeic
	cSelect += ", SB1.B1_CODITE CODITE"
EndIf
If mv_par01 == 1 //-- Aglutina por Armazem
	cSelect += ", SB2.B2_LOCAL LOC, SB2.B2_FILIAL FILIAL"
Else  //-- Aglutina por Filial ou por Empresa
	cSelect += ", '**' LOC"
EndIf	
If  mv_par01 == 2 //-- Aglutina por Filial
	cSelect += ", SB2.B2_FILIAL FILIAL"
EndIf 	
If mv_par01 == 3  //-- Aglutina por Empresa
	cSelect += ", '**' FILIAL"
EndIf
If mv_par19 == 1 .And. mv_par01==1
	cSelect += ", NNR.NNR_DESCRI DESCARM"
EndIf	
If mv_par17 == 1 // Desc. Cientifica
	cSelect += ", SB5.B5_CEME"
EndIf
cSelect += "%"

cWhere += "%"
If lVeic
	cWhere += " AND SB1.B1_CODITE >= '" + mv_par06 + "' AND SB1.B1_CODITE <='" + mv_par07 + "' "
Else
	cWhere += " AND SB1.B1_COD >= '" + mv_par06 + "' AND SB1.B1_COD <='" + mv_par07 + "' "
EndIf
If mv_par16 == 1 .And. mv_par01 == 1//-- Somente Negativos
	If mv_par14 == 2 //-- Imprime Zerados
		If mv_par15 == 1 //-- Saldo Atual
			cWhere += " AND (SB2.B2_QATU < 0)"
		ElseIf mv_par15 == 2 //-- Saldo Final
			cWhere += " AND (SB2.B2_QFIM < 0)"
		EndIf
	Else //-- Nao Imprime Zerados
		If mv_par15== 1 //-- Saldo Atual
			cWhere += " AND (SB2.B2_QATU <= 0)"
		ElseIf mv_par15 == 2 //-- Saldo Final
			cWhere += " AND (SB2.B2_QFIM <= 0)"
		EndIf
	EndIf	
ElseIf mv_par14 == 2 .And. mv_par01 == 1//-- Nao Imprime Zerados
	If mv_par15 == 1 //-- Saldo Atual
		cWhere += " AND (SB2.B2_QATU <> 0)"
	ElseIf mv_par15 == 2 //-- Saldo Final
		cWhere += " AND (SB2.B2_QFIM <> 0)"
	EndIf
EndIf
cWhere += "%"

cGroupBy := "%"
If ! lVEIC
	cGroupBy += " SB2.B2_COD, SB1.B1_TIPO, SB1.B1_GRUPO"
Else	
	cGroupBy += " SB1.B1_CODITE, SB2.B2_COD, SB1.B1_TIPO, SB1.B1_GRUPO"
EndIf
cGroupBy += ", SB1.B1_DESC"
cGroupBy += ", SB1.B1_UM"
If mv_par18 == 1
	cGroupBy += ", SB1.B1_SEGUM"
EndIf
If mv_par01 == 1 //-- Aglutina por Armazem
	cGroupBy += ", SB2.B2_LOCAL, SB2.B2_FILIAL"
EndIf
If mv_par01 == 2 //-- Aglutina por Filial
	cGroupBy += ", SB2.B2_FILIAL"
EndIf	
If mv_par01 == 3 //-- Aglutina por Empresa
	cGroupBy += " "
EndIf	
cGroupBy += ", SB2.B2_STATUS"
If mv_par19 == 1 .And. mv_par01==1
	cGroupBy += ", NNR.NNR_DESCRI"
EndIf	
If mv_par17 == 1
	cGroupBy += ", SB5.B5_CEME "  // SQL requer
EndIf
cGroupBy += "%"

cOrderBy := "%"
If ! lVEIC
	If nOrdem == 4
		cOrderBy += " GRUPO, COD"   // Por Grupo, Codigo
		cCampo := 'B1_GRUPO'
		cMens  := OemToAnsi(STR0012) // 'Grupo.........'
	ElseIf nOrdem == 3
		cOrderBy += " B1_DESC, COD"   // Por Descricao, Codigo
		cCampo := .T.
	ElseIf nOrdem == 2
		cOrderBy += " TIPO, COD"   // Por Tipo, Codigo
		cCampo := 'B1_TIPO'
		cMens  := OemToAnsi(STR0011) // 'Tipo..........'
	Else
		cOrderBy += " COD"      // Por Codigo
		cCampo := .T.
	EndIf
Else
	If nOrdem == 4
		cOrderBy += " GRUPO, CODITE"   // Por Grupo, Codite
		cCampo := 'B1_GRUPO'
		cMens  := OemToAnsi(STR0012) // 'Grupo.........'
	ElseIf nOrdem == 3
		cOrderBy += " B1_DESC, CODITE"   // Por Descricao, Codite
		cCampo := .T.
	ElseIf nOrdem == 2
		cOrderBy += " TIPO, CODITE"   // Por Tipo, Codite
		cCampo := 'B1_TIPO'
		cMens  := OemToAnsi(STR0011) // 'Tipo..........'
	Else
		cOrderBy += " CODITE"      // Por Codite
		cCampo := .T.
	Endif
EndIf
cOrderBy += "%"

//������������������������������������������������������������������������Ŀ
//�Query do relatorio da secao 1                                           �
//��������������������������������������������������������������������������
oReport:Section(1):BeginQuery()	

cAliasTOP := GetNextAlias()
cAliasSB2 := cAliasTOP
cAliasSB5 := cAliasTOP

	If FWModeAccess("SB1",3) == "E"
		cCompFil := "% SB1.B1_FILIAL = SB2.B2_FILIAL AND %"
	Else
		cCompFil := "% SB1.B1_FILIAL =  '"+xFilial("SB1")+"' AND %" 
	EndIf
		
BeginSql Alias cAliasTOP

	SELECT SB2.B2_COD COD
	,SB1.B1_TIPO TIPO, SB1.B1_GRUPO GRUPO, SB1.B1_DESC, SB1.B1_UM UM
	,SUM(SB2.B2_QATU) QATU, SUM(SB2.B2_QFIM) QFIM, SB2.B2_STATUS
	,SUM(SB2.B2_QTSEGUM) QTSEGUM, SUM(SB2.B2_QFIM2) QFIM2
	%Exp:cSelect%

	FROM %table:SB2% SB2
	%Exp:cJoin%

	WHERE
		%Exp:cCompFil%
	SB2.B2_LOCAL >= %Exp:mv_par04%
	AND	SB2.B2_LOCAL <= %Exp:mv_par05%
	AND SB2.B2_FILIAL  >= %Exp:mv_par02%
	AND SB2.B2_FILIAL  <= %Exp:mv_par03%
	AND SB2.%NotDel%
	%Exp:cWhere%

	GROUP BY %Exp:cGroupBy%

	ORDER BY %Exp:cOrderBy%

	EndSql
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relatorio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

	//������������������������������������������������������������������������Ŀ
	//�Inicio do Fluxo do Relatorio					                           �
	//��������������������������������������������������������������������������
	//-- Inicializa Variaveis e Contadores
	cFilOld		:= (cAliasTOP)->FILIAL
	cCodAnt		:= (cAliasTOP)->COD
	cTipoAnt	:= (cAliasTOP)->TIPO
	cGrupoAnt	:= (cAliasTOP)->GRUPO

	If lVEIC
		cCodite    := (cAliasTOP)->CODITE
	EndIf		
	nQtdProd   := 0
	nTotProd   := 0
	nTotProd2  := 0	
	nTotProdBl := 0
	nTotProdB2 := 0
	nTotQuebra := 0
	nTotQuebr2 := 0 // 2a.UM

	dbSelectArea(cAliasTOP)
	oReport:SetMeter(SB2->(LastRec()))

	oSection:Init()
	While !oReport:Cancel() .And. !(cAliasTOP)->(Eof())
		If oReport:Cancel()
			Exit
		EndIf

		nQuant := 0.00
		nQuant2:= 0.00
		If mv_par15 == 3 // MOVIMENTACAO
			If AllTrim((cAliasTOP)->FILIAL) == '**'
				For nX := 1 to Len(aFiliais)
					cFilAnt := aFiliais[nX]
					If Alltrim((cAliasTOP)->LOC) == '**'
						aArea:=GetArea()
						dbSelectArea("SB2")
						dbSetOrder(1)
						dbSeek(cFilAnt + (cAliasTOP)->COD)
						While !Eof() .And. B2_FILIAL == cFilAnt .And. B2_COD == (cAliasTOP)->COD
							If SB2->B2_LOCAL >= mv_par04  .And. SB2->B2_LOCAL <= mv_par05
								nQuant += CalcEst((cAliasTOP)->COD,SB2->B2_LOCAL,dDataBase + 1, B2_FILIAL)[1]
								If mv_par18==1
									nQuant2+= CalcEst((cAliasTOP)->COD,SB2->B2_LOCAL,dDataBase + 1, B2_FILIAL)[7]
								EndIf	
							EndIf
							dbSkip()
						EndDo
						RestArea(aArea)
					Else
						nQuant += CalcEst((cAliasTOP)->COD, (cAliasTOP)->LOC, dDataBase+1)[1]
						If mv_par18==1
							nQuant2+= CalcEst((cAliasTOP)->COD, (cAliasTOP)->LOC, dDataBase+1)[7]
						EndIf	
					EndIf
				Next nX
			Else
				If Alltrim((cAliasTOP)->LOC) == '**'
					aArea:=GetArea()
					cFilAnt := (cAliasTOP)->FILIAL
					dbSelectArea("SB2")
					dbSetOrder(1)
					dbSeek(cSeek:=(cAliasTOP)->FILIAL + (cAliasTOP)->COD)
					While !Eof() .And. B2_FILIAL + B2_COD == cSeek
						If SB2->B2_LOCAL >= mv_par04  .And. SB2->B2_LOCAL <= mv_par05
							nQuant += CalcEst((cAliasTOP)->COD,SB2->B2_LOCAL,dDataBase + 1, B2_FILIAL)[1]
							If mv_par18==1
								nQuant2+= CalcEst((cAliasTOP)->COD,SB2->B2_LOCAL,dDataBase + 1, B2_FILIAL)[7]
							EndIf	
						EndIf
						dbSkip()
					EndDo
					RestArea(aArea)
				Else
					nQuant := CalcEst((cAliasTOP)->COD, (cAliasTOP)->LOC, dDataBase+1,(cAliasTOP)->FILIAL)[1]
					If mv_par18==1
						nQuant2:= CalcEst((cAliasTOP)->COD, (cAliasTOP)->LOC, dDataBase+1,(cAliasTOP)->FILIAL)[7]
					EndIf	
				EndIf
			EndIf
		Else
			nQuant := If(mv_par15==1,(cAliasTOP)->QATU, (cAliasTOP)->QFIM)
			If mv_par18==1
				nQuant2:= If(mv_par15==1,(cAliasTOP)->QTSEGUM, (cAliasTOP)->QFIM2)
			EndIf	
		EndIf	

		//����������������������������������������������������������������������������Ŀ
		//� Verifica se deverao ser impressos itens zerados  (mv_par14 - 1=SIM/2=NAO)  �
		//� / somente negativos 							 (mv_par16 - 1=SIM/2=NAO)  �
		//������������������������������������������������������������������������������
		If (mv_par14 == 1 .Or. ( mv_par14 <> 1 .and. QtdComp(nQuant) <> QtdComp(0))) .And. ;
				(mv_par16 <> 1 .Or. ( mv_par16 == 1 .and. If(mv_par14 <> 1, QtdComp(nQuant) < QtdComp(0),QtdComp(nQuant) <= QtdComp(0) )))

			If  lVEIC
				oSection:Cell("B1_CODITE"):SetValue((cAliasTOP)->CODITE)
			EndIf	
			oSection:Cell("B2_COD"):SetValue((cAliasTOP)->COD)
			oSection:Cell("B1_TIPO"):SetValue((cAliasTOP)->TIPO)
			oSection:Cell("B1_GRUPO"):SetValue((cAliasTOP)->GRUPO)
			oSection:Cell("B1_UM"):SetValue((cAliasTOP)->UM)
			oSection:Cell("B2_FILIAL"):SetValue((cAliasTOP)->FILIAL)
			oSection:Cell("B2_LOCAL"):SetValue((cAliasTOP)->LOC)
			oSection:Cell("QUANT"):SetValue(nQuant)
			If mv_par18==1
				oSection:Cell("B1_SEGUM"):SetValue((cAliasTop)->SEGUM)
				oSection:Cell("QUANT2"):SetValue(nQuant2)
			EndIf
			If mv_par19 == 1 .And. mv_par01==1
				oSection:Cell("NNR_DESCRI"):SetValue((cAliasTop)->DESCARM)
			EndIf	

			oSection:PrintLine()

			nQtdProd   ++
			nTotProd   += nQuant	//1a. UM
			nTotProd2  += nQuant2	//2a. UM
			nTotProdBl += If(SubStr((cAliasTOP)->B2_STATUS,1,1) $'2', nQuant,  0)	//1a. UM
			nTotProdB2 += If(SubStr((cAliasTOP)->B2_STATUS,1,1) $'2', nQuant2, 0)	//2a. UM
			nTotQuebra += nQuant	//1a.UM
			nTotQuebr2 += nQuant2	//2a.UM

			//���������������������������������Ŀ
			//� Atualiza Variaveis e Contadores �
			//�����������������������������������
			cFilOld	   := (cAliasTOP)->FILIAL
			cCodAnt    := (cAliasTOP)->COD
			cTipoAnt   := (cAliasTOP)->TIPO
			cGrupoAnt  := (cAliasTOP)->GRUPO

			If lVEIC
				cCodite    := (cAliasTop)->CODITE
			EndIf		

		EndIf

		(cAliasTop)->(dbSkip())
		oReport:IncMeter()

		If  ( (!lVEIC) .and. (!(cCodAnt == (cAliasTop)->COD)  )) .Or. ( ( lVEIC) .and. (!((cCodite + cCodAnt) == (cAliasTop)->(CODITE + cod))))
			If Alltrim(Str(nOrdem)) $ "1|3" //-- So' totaliza Produto se houver mais de 1
				If nQtdProd > 1 .And. (!(nTotProd==0).Or.!(nTotProdBl==0))
					oSection:GetFunction("DISP1"):Enable()
					oSection:GetFunction("DISP1"):ShowHeader()

					If mv_par18 == 1 // 2a.U.M.
						oSection:GetFunction("DISP2"):Enable()
						oSection:GetFunction("INDISP2"):Enable()
						oSection:GetFunction("QT2"):Enable()
                        EndIf
                        
					oSection:GetFunction("INDISP1"):Enable()
					oSection:GetFunction("INDISP1"):ShowHeader()
					oSection:GetFunction("QT1"):Enable()
					oSection:GetFunction("QT1"):ShowHeader()
					oBreak:ShowHeader()
				Else
					oSection:GetFunction("DISP1"):Disable()
					oSection:GetFunction("DISP1"):HideHeader()

					If mv_par18 == 1 // 2a.U.M.
						oSection:GetFunction("DISP2"):Disable()
						oSection:GetFunction("INDISP2"):Disable()
						oSection:GetFunction("QT2"):Disable()
                    EndIf
                    
					oSection:GetFunction("INDISP1"):Disable()
					oSection:GetFunction("INDISP1"):HideHeader()
					oSection:GetFunction("QT1"):Disable()
					oSection:GetFunction("QT1"):HideHeader()
					oBreak:HideHeader()
				EndIf								
			EndIf

			nQtdProd   := 0
			nTotProd   := 0 //1a.UM
			nTotProd2  := 0 //2a.UM
			nTotProdBl := 0 //1a.UM
			nTotProdB2 := 0 //2a.UM
		EndIf

	EndDo
	oSection:Finish()


//-- Retorna a Posi��o Correta do SM0
SM0->(dbGoto(nRegM0))
//-- Reinicializa o Conteudo da Variavel cFilAnt
If !(cFilAnt==SM0->M0_CODFIL)	
	cFilAnt := SM0->M0_CODFIL
EndIf	

//��������������������������������������������������������������Ŀ
//� Devolve as ordens originais dos arquivos                     �
//����������������������������������������������������������������
dbSelectArea("SB2")
dbClearFilter()
RetIndex('SB2')
dbSetOrder(1)

dbSelectArea("SB1")
dbClearFilter()
RetIndex('SB1')
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Apaga indices de trabalho                                    �
//����������������������������������������������������������������
If File(cNomArqB2 += OrdBagExt())
	fErase(cNomArqB2)
EndIf	

Return NIL