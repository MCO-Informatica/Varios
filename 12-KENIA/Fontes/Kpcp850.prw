#INCLUDE "MATR850.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR850  � Autor � Marcos V. Ferreira    � Data � 08/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao Das Ordens de Producao                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function Kpcp850
Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	MATR850R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Marcos V. Ferreira     � Data �08/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local nTamOp  := TamSX3('D3_OP')[1]
Local nTamSld := TamSX3('C2_QUANT')[1]
Local cPictQtd:= PesqPictQt("C2_QUANT")
Local aOrdem  := {STR0003,STR0004,STR0005}
Local oReport
Local oOp

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
oReport:= TReport():New("MATR850",STR0001,"MTR850", {|oReport| ReportPrint(oReport)},STR0002) //"Este programa ira imprimir a Rela��o das Ordens de Produ��o."

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Da OP                                 �
//� mv_par02        	// Ate a OP                              �
//� mv_par03        	// Do Produto                            �
//� mv_par04        	// Ate o Produto                         �
//� mv_par05        	// Do Centro de Custo                    �
//� mv_par06        	// Ate o Centro de Custo                 �
//� mv_par07        	// Da data                               �
//� mv_par08        	// Ate a data                            �
//� mv_par09        	// 1-EM ABERTO 2-ENCERRADAS  3-TODAS     �
//� mv_par10        	// 1-SACRAMENTADAS 2-SUSPENSA 3-TODAS    �
//� mv_par11            // Impr. OP's Firmes, Previstas ou Ambas �
//����������������������������������������������������������������
Pergunte(oReport:uParam,.F.)
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
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oOp)                                               �
//����������������������������������������������������������������
oOp := TRSection():New(oReport,STR0030,{"SC2","SB1"},aOrdem) //"Ordens de Produ��o"
oOp:SetTotalInLine(.F.)

TRCell():New(oOp,'OP'			,'SC2',STR0019,/*Picture*/	,nTamOp		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOp,'C2_PRODUTO'	,'SC2',STR0020,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOp,'B1_DESC'		,'SB1',STR0021,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOp,'C2_CC'		,'SC2',STR0022,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOp,'C2_EMISSAO'	,'SC2',STR0023,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOp,'C2_DATPRF'	,'SC2',STR0024,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOp,'C2_DATRF'		,'SC2',STR0025,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOp,'C2_QUANT'		,'SC2',STR0026,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oOp,'SALDO'		,'SC2',STR0027,cPictQtd		,nTamSld	,/*lPixel*/,/*{|| code-block de impressao }*/)
If ! __lPyme
	TRCell():New(oOp,'C2_STATUS','SC2',STR0028,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oOp,'C2_TPOP'	,'SC2',STR0029,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
EndIf

oOp:SetHeaderPage()

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Marcos V. Ferreira   � Data �08/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)
Local oOp 	   := oReport:Section(1)
Local nOrdem   := oOp:GetOrder()
Local cAliasSC2:= "SC2"
Local oBreak
#IFDEF TOP
	Local cWhere01, cWhere02, cWhere05, cWhere06 := ""
	Local cWhere09, cWhere10, cWhere11 := ""
	Local cSpace   := Space(TamSx3("C2_DATRF")[1])
#ELSE
	Local cFiltro  := ""
	Local cStatus  := ""
#ENDIF

//��������������������������������������������������������������Ŀ
//� Acerta o titulo do relatorio                                 �
//����������������������������������������������������������������
oReport:SetTitle(oReport:Title()+IIf(nOrdem==1,STR0008,IIf(nOrdem==2,STR0009,STR0010))) //" - Por O.P."###" - Por Produto"###" - Por Centro de Custo"

//��������������������������������������������������������������Ŀ
//� Definicao da linha de SubTotal                               |
//����������������������������������������������������������������
If nOrdem == 2
	oBreak := TRBreak():New(oOp,oOp:Cell("C2_PRODUTO"),STR0014,.F.)
EndIf	

If nOrdem == 2
	TRFunction():New(oOp:Cell('C2_QUANT'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oOp:Cell('SALDO'		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
EndIf

//��������������������������������������������������������������Ŀ
//� Inicializa variavel para controle do filtro                  �
//����������������������������������������������������������������
#IFDEF TOP

	dbSelectArea("SC2")
	dbSetOrder(nOrdem)

	//��������������������������������������������������������������Ŀ
	//� Condicao Where para filtrar OP's                             �
	//����������������������������������������������������������������
	cWhere01 := "%'"+Left(mv_par01,6)+"'%"
	cWhere02 := "%"
	If !Empty( Substr(mv_par01,7,2) )
		cWhere02 += " SC2.C2_ITEM >= '"+Substr(mv_par01,7,2)+"' AND "
	EndIf
	If !Empty( Substr(mv_par01,9,3) )
		cWhere02 += " SC2.C2_SEQUEN >= '"+Substr(mv_par01,9,3)+"' AND "
	EndIf
	If !Empty( Substr(mv_par01,12,2) )
		cWhere02 += " SC2.C2_ITEMGRD >= '"+Substr(mv_par01,12,2)+"' AND "
	EndIf
	cWhere02 += "%"

	cWhere05 := "%'"+Left(mv_par02,6)+"'%"
	cWhere06 := "%"
	If !Empty( Substr(mv_par02,7,2) )
		cWhere06 += " SC2.C2_ITEM <= '"+Substr(mv_par02,7,2)+"' AND "
	EndIf
	If !Empty( Substr(mv_par02,9,3) )
		cWhere06 += " SC2.C2_SEQUEN <= '"+Substr(mv_par02,9,3)+"' AND "
	EndIf
	If !Empty( Substr(mv_par02,12,2) )
		cWhere06 += " SC2.C2_ITEMGRD <= '"+Substr(mv_par02,12,2)+"' AND "
	EndIf
	cWhere06 += "%"
	
	//��������������������������������������������������������������Ŀ
	//� Condicao Where para C2_STATUS                                �
	//����������������������������������������������������������������
	cWhere09 := "%"
	If mv_par10 == 1
		cWhere09 += "'S'"
	ElseIf mv_par10 == 2
		cWhere09 += "'U'"
	ElseIf mv_par10 == 3
		cWhere09 += "'S','U','D','N',' '"
	EndIf
	cWhere09 += "%"
	//��������������������������������������������������������������Ŀ
	//� Condicao Where para C2_TPOP                                  �
	//����������������������������������������������������������������
	cWhere10 := "%"
	If mv_par11 == 1
		cWhere10 += "'F'"
	ElseIf mv_par11 == 2
		cWhere10 += "'P'"
	ElseIf mv_par11 == 3
		cWhere10 += "'F','P'"
	EndIf	
	cWhere10 += "%"

	//����������������������������������������������������������������������������Ŀ
	//� Condicao Where para filtrar a condicao da OP(Em Aberto / Encerrada / Todas)�
	//������������������������������������������������������������������������������
	cWhere11 := "%"
	If mv_par09 == 1
		cWhere11 += " SC2.C2_DATRF =  '"+cSpace+"' AND "
	ElseIf mv_par09 == 2
		cWhere11 += " SC2.C2_DATRF <> '"+cSpace+"' AND "
	EndIf	
	cWhere11 += "%"

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)

	cAliasSC2 := GetNextAlias()    
		
	//������������������������������������������������������������������������Ŀ
	//�Inicio do Embedded SQL                                                  �
	//��������������������������������������������������������������������������
	BeginSql Alias cAliasSC2

		Column C2_DATPRF  as Date
		Column C2_DATRF   as Date
		Column C2_EMISSAO as Date		
		
		SELECT C2_FILIAL,C2_PRODUTO,C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_DATRF,C2_CC,
		       C2_EMISSAO,C2_DATPRF,C2_QUANT,C2_QUJE,C2_PERDA,C2_STATUS,C2_TPOP,
		       SC2.R_E_C_N_O_ SC2RECNO 
		
		FROM %table:SC2% SC2

		WHERE  SC2.C2_FILIAL    = %xFilial:SC2%  AND
		       SC2.C2_NUM      >= %Exp:cWhere01% AND
 		       %Exp:cWhere02%
	           SC2.C2_NUM      <= %Exp:cWhere05% AND
 		       %Exp:cWhere06%
		       SC2.C2_PRODUTO  >= %Exp:mv_par03% AND SC2.C2_PRODUTO <= %Exp:mv_par04% AND
		       SC2.C2_CC       >= %Exp:mv_par05% AND SC2.C2_CC      <= %Exp:mv_par06% AND
 		       SC2.C2_EMISSAO  >= %Exp:mv_par07% AND SC2.C2_EMISSAO <= %Exp:mv_par08% AND
			   SC2.C2_STATUS IN (%Exp:cWhere09%) AND SC2.C2_TPOP IN (%Exp:cWhere10%)  AND
 		       %Exp:cWhere11%
 		       SC2.%NotDel%
	
	   ORDER BY %Order:SC2%
	    
	EndSql
	
	oReport:Section(1):EndQuery()

	//��������������������������������������������������������������Ŀ
	//� Abertura do arquivo de trabalho                              |
	//����������������������������������������������������������������
	dbSelectArea(cAliasSC2)

#ELSE

	dbSelectArea("SC2")
	dbSetOrder(nOrdem)

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:uParam)

	If mv_par10 == 1
		cStatus := "S"
	ElseIf mv_par10 == 2
		cStatus := "U"
	ElseIf mv_par10 == 3
		cStatus := "SUDN "
	EndIf	
	cFiltro	:= "SC2->C2_FILIAL == '"+xFilial("SC2")+"' "

	cFiltro += ".And. C2_NUM >= '"+Left(mv_par01,6)+"' "
	If !Empty( Substr(mv_par01,7,2) )
		cFiltro += ".And. C2_ITEM >= '"+Substr(mv_par01,7,2)+"' "
	EndIf
	If !Empty( Substr(mv_par01,9,3) )
		cFiltro += ".And. C2_SEQUEN >= '"+Substr(mv_par01,9,3)+"' "
	EndIf
	If !Empty( Substr(mv_par01,12,2) )
		cFiltro += ".And. C2_ITEMGRD >= '"+Substr(mv_par01,12,2)+"' "
	EndIf
	cFiltro += ".And. C2_NUM <= '"+Left(mv_par02,6)+"' "
	If !Empty( Substr(mv_par02,7,2) )
		cFiltro += ".And. C2_ITEM <= '"+Substr(mv_par02,7,2)+"' "
	EndIf
	If !Empty( Substr(mv_par02,9,3) )
		cFiltro += ".And. C2_SEQUEN <= '"+Substr(mv_par02,9,3)+"' "
	EndIf
	If !Empty( Substr(mv_par02,12,2) )
		cFiltro += ".And. C2_ITEMGRD <= '"+Substr(mv_par02,12,2)+"' "
	EndIf

	cFiltro += ".And. C2_PRODUTO >= '"+mv_par03+"' "
	cFiltro += ".And. C2_PRODUTO <= '"+mv_par04+"' "
	cFiltro += ".And. C2_CC >= '"+mv_par05+"' "
	cFiltro += ".And. C2_CC <= '"+mv_par06+"' "
	cFiltro += ".And. DTOS(C2_EMISSAO) >= '"+DTOS(mv_par07)+"' "
	cFiltro += ".And. DTOS(C2_EMISSAO) <= '"+DTOS(mv_par08)+"' "
	cFiltro += ".And. C2_STATUS $ '"+cStatus+"' "
	If mv_par09 == 1  // O.P.s EM ABERTO
		cFiltro += ".And. Empty(C2_DATRF)"
	ElseIf mv_par09 == 2 //O.P.S ENCERRADAS
		cFiltro += ".And. !Empty(C2_DATRF)"
	EndIf

	oReport:Section(1):SetFilter(cFiltro,IndexKey())
		
#ENDIF

oReport:SetMeter(SC2->(LastRec()))

While !oReport:Cancel() .And. !Eof()

	oReport:IncMeter()

	//-- Valida se a OP deve ser Impressa ou n�o
	If !MtrAValOP(mv_par11,"SC2",cAliasSC2)
		dbSelectArea(cAliasSC2)
		dbSkip()
		Loop
	EndIf

    oOp:Init(.F.)
    
	Do While !oReport:Cancel() .And. !Eof() 
	
		oReport:IncMeter()

		//-- Valida se a OP deve ser Impressa ou n�o
		If !MtrAValOP(mv_par11,'SC2',cAliasSC2)
			dbSelectArea(cAliasSC2)
			dbSkip()
			Loop
		EndIf

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+(cAliasSC2)->C2_PRODUTO))

		oOp:Cell('OP'    ):SetValue((cAliasSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) 
		oOp:Cell('SALDO' ):SetValue(IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0)) 

		oOp:PrintLine()
		
		(cAliasSC2)->(dbSkip())

	EndDo

    oOp:Finish()

EndDo

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR850R3� Autor � Paulo Boschetti       � Data � 13.08.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relacao Das Ordens de Producao                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR850(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Edson   M.  �19/01/98�XXXXXX� Inclusao do Campo C2_SLDOP.              ���
���Edson   M.  �02/02/98�XXXXXX� Subst. do Campo C2_SLDOP p/ Funcao.      ���
���Rodrigo Sart�24/03/98�08929A� Inclusao da Coluna Termino Real da OP.   ���
���Rodrigo Sart�05/10/98�15995A� Acerto na filtragem das filiais          ���
���Rodrigo Sart�03/11/98�XXXXXX� Acerto p/ Bug Ano 2000                   ���
���Fernando J. �07/02/99�META  �Imprimir OP's Firmes, Previstas ou Ambas. ���
���Cesar       �31/03/99�XXXXXX�Manutencao na SetPrint()                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MATR850R3()
Local titulo 	:= STR0001 								//"Relacao Das Ordens de Producao"
Local cString	:= "SC2"
Local wnrel		:= "MATR850"
Local cDesc		:= STR0002								//"Este programa ira imprimir a Rela��o das Ordens de Produ��o."
Local aOrd    	:= {STR0003,STR0004,STR0005}			//"Por O.P.       "###"Por Produto    "###"Por Centro de Custo"
Local tamanho	:= "G"
Local lRet      := .T.
Private aReturn := {STR0006,1,STR0007, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg   := "MTR850"
Private nLastKey:= 0

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("MTR850",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Da OP                                 �
//� mv_par02        	// Ate a OP                              �
//� mv_par03        	// Do Produto                            �
//� mv_par04        	// Ate o Produto                         �
//� mv_par05        	// Do Centro de Custo                    �
//� mv_par06        	// Ate o Centro de Custo                 �
//� mv_par07        	// Da data                               �
//� mv_par08        	// Ate a data                            �
//� mv_par09        	// 1-EM ABERTO 2-ENCERRADAS  3-TODAS     �
//� mv_par10        	// 1-SACRAMENTADAS 2-SUSPENSA 3-TODAS    �
//� mv_par11            // Impr. OP's Firmes, Previstas ou Ambas �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,,Tamanho)

If aReturn[4] == 1
	Tamanho := "M"
EndIf
If nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet
	SetDefault(aReturn,cString)
EndIf

If lRet .And. nLastKey == 27
	Set Filter To
	lRet := .F.
EndIf

If lRet
	RptStatus({|lEnd| R850Imp(@lEnd,wnRel,titulo,tamanho)},titulo)
EndIf
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R850Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R850Imp(lEnd,wnRel,titulo,tamanho)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local CbTxt
Local CbCont,cabec1,cabec2
Local limite   := If(aReturn[4] == 1,132,180)
Local nomeprog := "MATR850"
Local nTipo    := 0
Local cProduto := Space(Len(SC2->C2_PRODUTO))
Local cStatus,nOrdem,cSeek
Local cTotal   := "",nTotOri:= 0,nTotSaldo:=0 // Totalizar qdo ordem for por produto
Local nTotal   := 0
Local nGeral   := 0
Local cQuery   := "",cIndex := CriaTrab("",.F.),nIndex:=0
Local lQuery   := .F.
Local aStruSC2 := {}
Local cAliasSC2:= "SC2"
Local cTPOP    := ""
Local lTipo    := .F.
#IFDEF TOP
	Local nX
#ENDIF

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt  := Space(10)
cbcont := 0
li     := 80
m_pag  := 1

nTipo  := IIf(aReturn[4]==1,15,18)
nOrdem := aReturn[8]
lTipo  := IIf(aReturn[4]==1,.T.,.F.)

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
titulo += IIf(nOrdem==1,STR0008,IIf(nOrdem==2,STR0009,STR0010))	//" - Por O.P."###" - Por Produto"###" - Por Centro de Custo"
cabec1 := If(!__lPyme, IIf(lTipo,STR0016,STR0011), IIf(lTipo,STR0018,STR0015))//"NUMERO         P R O D U T O                                                  CENTRO    EMISSAO      ENTREGA     ENTREGA       QUANTIDADE          SALDO A      ST TP"
cabec2 := IIf(lTipo,STR0017,STR0012)	//"                                                                            DE CUSTO                PREVISTA        REAL         ORIGINAL         ENTREGAR"
//					   1234567890123  123456789012345  1234567890123456789012345678901234567890  1234567890  1234567890  1234567890  1234567890  123456789012345  123456789012345       1  1
//                               1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17
//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
// 1a Linha Posicoes:000/015/032/074/086/098/110/122/139/161/164

dbSelectArea("SC2")
dbSetOrder( nOrdem )

//��������������������������������������������������������������Ŀ
//� Inicializa variavel para controle do filtro                  �
//����������������������������������������������������������������
#IFDEF TOP
	If mv_par10 == 1
		cStatus := "'S'"
	ElseIf mv_par10 == 2
		cStatus := "'U'"
	ElseIf mv_par10 == 3
		cStatus := "'S','U','D','N',' '"
	EndIf
	If mv_par11 == 1
		cTPOP := "'F'"
	ElseIf mv_par11 == 2
		cTPOP := "'P'"
	ElseIf mv_par11 == 3
		cTPOP := "'F','P'"
	EndIf	
	lQuery 	  := .T.
	aStruSC2  := SC2->(dbStruct())
	cAliasSC2 := "R850IMP"
	cQuery    := "SELECT SC2.C2_FILIAL,SC2.C2_PRODUTO,SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN,SC2.C2_ITEMGRD, "
	cQuery    += "SC2.C2_DATRF,SC2.C2_CC,SC2.C2_EMISSAO,SC2.C2_DATPRF,SC2.C2_QUANT,SC2.C2_QUJE,SC2.C2_PERDA, "
	cQuery    += "SC2.C2_STATUS,SC2.C2_TPOP, "
	cQuery    += "SC2.R_E_C_N_O_ SC2RECNO "
	cQuery    += "FROM "
	cQuery    += RetSqlName("SC2")+" SC2 "
	cQuery    += "WHERE "
	cQuery    += "SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND "

	//��������������������������������������������������������������Ŀ
	//� Condicao para filtrar OP's                           		 �
	//����������������������������������������������������������������
	cQuery += 	  "SC2.C2_NUM >= '"+Left(mv_par01,6)+"' AND "
	If !Empty( Substr(mv_par01,7,2) )
		cQuery += "SC2.C2_ITEM >= '"+Substr(mv_par01,7,2)+"' AND "
	EndIf
	If !Empty( Substr(mv_par01,9,3) )
		cQuery += "SC2.C2_SEQUEN >= '"+Substr(mv_par01,9,3)+"' AND "
	EndIf
	If !Empty( Substr(mv_par01,12,2) )
		cQuery += "SC2.C2_ITEMGRD >= '"+Substr(mv_par01,12,2)+"' AND "
	EndIf

	cQuery += 	  "SC2.C2_NUM <= '"+Left(mv_par02,6)+"' AND "
	If !Empty( Substr(mv_par02,7,2) )
		cQuery += "SC2.C2_ITEM <= '"+Substr(mv_par02,7,2)+"' AND "
	EndIf
	If !Empty( Substr(mv_par02,9,3) )
		cQuery += "SC2.C2_SEQUEN <= '"+Substr(mv_par02,9,3)+"' AND "
	EndIf
	If !Empty( Substr(mv_par02,12,2) )
		cQuery += "SC2.C2_ITEMGRD <= '"+Substr(mv_par02,12,2)+"' AND "
	EndIf

	cQuery    += "SC2.C2_PRODUTO >= '"+mv_par03+"' And SC2.C2_PRODUTO <= '"+mv_par04+"' And "
	cQuery    += "SC2.C2_CC  >= '"+mv_par05+"' And SC2.C2_CC  <= '"+mv_par06+"' And "
	cQuery    += "SC2.C2_EMISSAO  >= '"+DtoS(mv_par07)+"' And SC2.C2_EMISSAO  <= '"+DtoS(mv_par08)+"' And "
	cQuery    += "SC2.C2_STATUS IN ("+cStatus+") And "
	cQuery    += "SC2.C2_TPOP IN ("+cTPOP+") And "
	cQuery    += "SC2.D_E_L_E_T_ = ' ' "

	cQuery    += "ORDER BY "+SqlOrder(SC2->(IndexKey()))

	cQuery    := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC2,.T.,.T.)

	For nX := 1 To Len(aStruSC2)
		If ( aStruSC2[nX][2] <> "C" ) .And. FieldPos(aStruSC2[nX][1]) > 0
			TcSetField(cAliasSC2,aStruSC2[nX][1],aStruSC2[nX][2],aStruSC2[nX][3],aStruSC2[nX][4])
		EndIf
	Next nX
#ELSE
	If mv_par10 == 1
		cStatus := "S"
	ElseIf mv_par10 == 2
		cStatus := "U"
	ElseIf mv_par10 == 3
		cStatus := "SUDN "
	EndIf	
	cQuery 	:= "C2_FILIAL=='"+xFilial("SC2")+"'"
	cQuery += ".And. C2_NUM >= '"+Left(mv_par01,6)+"' "
	If !Empty( Substr(mv_par01,7,2) )
		cQuery += ".And. C2_ITEM >= '"+Substr(mv_par01,7,2)+"' "
	EndIf
	If !Empty( Substr(mv_par01,9,3) )
		cQuery += ".And. C2_SEQUEN >= '"+Substr(mv_par01,9,3)+"' "
	EndIf
	If !Empty( Substr(mv_par01,12,2) )
		cQuery += ".And. C2_ITEMGRD >= '"+Substr(mv_par01,12,2)+"' "
	EndIf
	cQuery += ".And. C2_NUM <= '"+Left(mv_par02,6)+"' "
	If !Empty( Substr(mv_par02,7,2) )
		cQuery += ".And. C2_ITEM <= '"+Substr(mv_par02,7,2)+"' "
	EndIf
	If !Empty( Substr(mv_par02,9,3) )
		cQuery += ".And. C2_SEQUEN <= '"+Substr(mv_par02,9,3)+"' "
	EndIf
	If !Empty( Substr(mv_par02,12,2) )
		cQuery += ".And. C2_ITEMGRD <= '"+Substr(mv_par02,12,2)+"' "
	EndIf
	cQuery  += ".And.C2_PRODUTO>='"+mv_par03+"'.And.C2_PRODUTO<='"+mv_par04+"'"
	cQuery  += ".And.C2_STATUS$'"+cStatus+"'
	cQuery  += ".And.C2_CC>='"+mv_par05+"'.And.C2_CC<='"+mv_par06+"'"
	cQuery  += ".And.DtoS(C2_EMISSAO)>='"+DtoS(mv_par07)+"'.And.DtoS(C2_EMISSAO)<='"+DtoS(mv_par08)+"'"
	IndRegua("SC2",cIndex,IndexKey(),,cQuery)
	nIndex := RetIndex("SC2")
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
	cAliasSC2 := "SC2"
#ENDIF

SetRegua(RecCount())		// Total de Elementos da regua
dbGoTop()
While !Eof()
	IncRegua()
	If lEnd
		@ Prow()+1,001 PSay STR0013	//	"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
		dbSkip()
		Loop
	EndIf

	If mv_par09 == 1  // O.P.s EM ABERTO
		If !Empty(C2_DATRF)
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par09 == 2 //O.P.S ENCERRADAS
		If Empty(C2_DATRF)
			dbSkip()
			Loop
		EndIf
	EndIf

	//-- Valida se a OP deve ser Impressa ou n�o
	#IFDEF TOP
		If	! Empty(aReturn[7])
			SC2->(MsGoTo((cAliasSC2)->SC2RECNO))
			If SC2->( ! &(aReturn[7]) )
				(cAliasSC2)->(DbSkip())
				Loop
			EndIf
		EndIf			
	#ELSE
		If !MtrAValOP(mv_par11, 'SC2')
			dbSkip()
			Loop
		EndIf
		//�������������������Ŀ
		//� Filtro do Usuario �
		//���������������������
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			EndIf
		EndIf
	#ENDIF	


	//��������������������������������������������������������������Ŀ
	//� Termina filtragem e grava variavel p/ totalizacao            �
	//����������������������������������������������������������������
	cTotal  := IIf(nOrdem==2,xFilial("SC2")+C2_PRODUTO,xFilial("SC2"))
	nTotOri := nTotSaldo:=0
	nGeral  := (nGeral+nTotsaldo)  
	Do While !Eof() .And. cTotal == IIf(nOrdem==2,C2_FILIAL+C2_PRODUTO,C2_FILIAL)
		IncRegua()

		If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
			dbSkip()
			Loop
		EndIf

		If mv_par09 == 1  // O.P.s EM ABERTO
			If !Empty(C2_DATRF)
				dbSkip()
				Loop
			EndIf
		Elseif mv_par09 == 2 //O.P.S ENCERRADAS
			If Empty(C2_DATRF)
				dbSkip()
				Loop
			EndIf
		EndIf

		//-- Valida se a OP deve ser Impressa ou n�o
		#IFDEF TOP
			If	! Empty(aReturn[7])
				SC2->(MsGoTo((cAliasSC2)->SC2RECNO))
				If SC2->( ! &(aReturn[7]) )
					(cAliasSC2)->(DbSkip())
					Loop
				EndIf
			EndIf
		#ELSE
			If !MtrAValOP(mv_par11, 'SC2')
				dbSkip()
				Loop
			EndIf
			//�������������������Ŀ
			//� Filtro do Usuario �
			//���������������������
			If !Empty(aReturn[7])
				If !&(aReturn[7])
					dbSkip()
					Loop
				EndIf
			EndIf
		#ENDIF


		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+(cAliasSC2)->C2_PRODUTO))
        
        nTotal:= C2_QUANT
	    nGeral:= nTotal
	 
		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIf
        
		// 1a Linha Posicoes:000/015/032/074/086/098/110/122/139/161/164
		@Li ,000 PSay C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
		@Li ,015 PSay C2_PRODUTO
		If lTipo
			@Li ,032 PSay SubStr(SB1->B1_DESC,1,25)
			@Li ,058 PSay C2_CC
			@Li ,068 PSay C2_EMISSAO
			@Li ,077 PSay C2_DATPRF
			@Li ,086 PSay C2_DATRF
			@Li ,097 PSay C2_QUANT Picture PesqPictQt("C2_QUANT",15)
			@Li ,112 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",15)
		Else
			@Li ,032 PSay SubStr(SB1->B1_DESC,1,40)
			@Li ,074 PSay C2_CC
			@Li ,086 PSay C2_EMISSAO
			@Li ,099 PSay C2_DATPRF
			@Li ,111 PSay C2_DATRF
			@Li ,125 PSay C2_QUANT Picture PesqPictQt("C2_QUANT",15)
			@Li ,142 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",15)
		EndIf
	    
		
			If ! __lPyme
			IF lTipo
				@Li ,126 PSay C2_STATUS
				@Li ,129 PSay C2_TPOP
			Else
				@Li ,161 PSay C2_STATUS
				@Li ,164 PSay C2_TPOP
			EndIf
		EndIf
		Li++
		If nOrdem # 2 .And. !lTipo
			@Li ,  0 PSay __PrtThinLine()
			Li++
		Else
			nTotOri	 += C2_QUANT
			nTotSaldo+= IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0)
		EndIf
		dbSkip()
	EndDo
	If nOrdem == 2
		Li++
		@Li ,000 PSay STR0014	//"Total ---->"
		@Li ,015 PSay Substr(cTotal,3)
		If lTipo
			@Li ,097 PSay nTotOri	Picture PesqPictQt("C2_QUANT",15)
			@Li ,112 PSay nTotSaldo	Picture PesqPictQt("C2_QUANT",15)
			Li++
			@Li ,  0 PSay __PrtThinLine()
		Else
			@Li ,125 PSay nTotOri	Picture PesqPictQt("C2_QUANT",15)
			@Li ,142 PSay nTotSaldo	Picture PesqPictQt("C2_QUANT",15)
			Li++
			
			@Li ,  0 PSay __PrtThinLine()
		EndIf
		Li++
		
        nTotal:= C2_QUANT
	    nGeral:= (nTotal+nGeral)
	    //@Li,00 PSAY ("Total: " + Transform(nTotal,"@R 99,999.99"))
	EndIf
  	   
EndDo 
   
     @(Li+1),00 PSAY ("Total Geral: " + Transform(nGeral,"@R 999,999,999.999999"))
     @(Li+2),00 PSAY (replicate("_",120))



If Li != 80
	Roda(cbcont,cbtxt)
EndIf

If lQuery
	dbSelectArea(cAliasSC2)
	dbCloseArea()
EndIf

dbSelectArea("SC2")
Set Filter To
dbSetOrder(1)

If File(cIndex+OrdBagExt())
	Ferase(cIndex+OrdBagExt())
EndIf

If aReturn[5] == 1
	Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH()
Return NIL
