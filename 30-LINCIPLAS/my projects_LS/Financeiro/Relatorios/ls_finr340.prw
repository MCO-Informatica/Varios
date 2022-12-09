#INCLUDE "TOPCONN.CH"
#Include "FINR340.CH"
#Include "PROTHEUS.CH"
#Include "rwmake.CH"
#Define I_CORRECAO_MONETARIA         1
#Define I_DESCONTO                   2
#Define I_JUROS                      3
#Define I_MULTA                      4
#Define I_VALOR_RECEBIDO             5
#Define I_VALOR_PAGO                 6
#Define I_RECEB_ANT                  7
#Define I_PAGAM_ANT                  8
#Define I_MOTBX                      9

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR340  � Autor � Paulo Boschetti       � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posicao dos Clientes                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FINR340(void)                                              ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGAFIN													  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��� Mauricio   �21/11/97�13526 � Nao imprimir subtotal com valores zerados���
��� Mauricio   �08/12/97�xxxxx � Corrigir array de situacao de titulos    ���
��� Mauricio   �28/06/98�xxxxx � Considerar numero titulos c/12 posicoes  ���
��� Mauricio   �02/07/98�xxxxx � Alinhar relatorio                        ���
��� Andreia    �05/10/98�xxxxx � Ajustar lay-out para ativar Set Century  ���
��� Wagner     �27/11/98�xxxxx � Acerto cabecalho                         ���
��� Andreia    �11/01/99�xxxxx � Ordenacao por ordem alfabetica.          ���
��� Julio      �24.06.99�22201A� Valores significativos impressos entre   ���
���            �        �      � par�nteses caso Valor < 0                ���
��� Julio      �29.07.99�META  � Interpretar MV_CRNEG                     ���
��� Mauricio   �10/08/99�23192A� Considerar Cliente/Loja na verificacao   ���
���            �        �      � de baixas do titulo.                     ���
��� Pilar	   �04/10/99�      � Melhoria de Performance                  ���
��� Julio W	   �30.11.99�META  � Interpretar filtro do usuario            ���
��� MAURICIO   �09.12.99�xxxxxx�Corrigir filtro usuario                   ���
��� Bruno      �10.02.00�xxxxx �Corrigir o saldo en moeda > 1 (usar nSaldo���
���            �        �      � que � o certo r n�o SE1->E1_SALDO).      ���
���            �        �      �Substarir nos Subtotais o valor pago, usar���
���            �        �      � o ABS na chamada da ImpSubTot().         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LS_FinR340()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return FinR340R3() // Executa vers�o anterior do fonte
Endif

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ReportDef � Autor � Marcio Menon		   � Data �  16/08/06  ���
�������������������������������������������������������������������������͹��
���Descricao � Definicao do objeto do relatorio personalizavel e das      ���
���          � secoes que serao utilizadas.                               ���
�������������������������������������������������������������������������͹��
���Parametros� EXPC1 - Grupo de perguntas do relatorio                    ���
�������������������������������������������������������������������������͹��
���Uso       � 												                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local cReport 	:= "FINR340"	// Nome do relatorio
Local cDescri 	:= OemToAnsi(STR0001)+ OemToAnsi(STR0002)	//"Este programa ir� emitir a posi��o de clientes " "referente a data base do sistema."
Local cTitulo 	:= OemToAnsi(STR0005)	//"Posicao dos Clientes "
Local cPerg		:= "FIN340"	// Nome do grupo de perguntas
Local aOrdem	:= {OemToAnsi(STR0020),OemToAnsi(STR0021)}	//"Por Codigo"###"Por Nome"
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������

oReport := TReport():New(cReport, cTitulo + " - ", cPerg, {|oReport| ReportPrint(oReport, cTitulo)}, cDescri)

pergunte("FIN340",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // do Cliente                            �
//� mv_par02            // Ate o Cliente                         �
//� mv_par03            // Da Loja                               �
//� mv_par04            // Ate a Loja                            �
//� mv_par05            // Da Emissao                            �
//� mv_par06            // Ate a Emissao                         �
//� mv_par07            // Do Vencimento                         �
//� mv_par08            // Ate o Vencimento                      �
//� mv_par09            // Imprime os t�tulos provis�rios        �
//� mv_par10            // Qual a moeda                          �
//� mv_par11            // Reajusta pela DataBase ou Vencto      �
//� mv_par12            // Considera Faturados                   �
//� mv_par13            // Imprime Outras Moedas                 �
//� mv_par14            // Considera Data Base                   �
//� mv_par15            // Imprime Nome? (Razao Social/N.Reduzid)�
//� mv_par16            // Natureza De ?                         �
//� mv_par17            // Natureza Ate?                         �
//� mv_par18            // Considera Liquidados?                 �
//� mv_par19            // Cons. Baixas por Recibo?              �
//� mv_par20		 	// Consid Filiais  ?  					�
//� mv_par21		 	// da filial							�
//� mv_par22		 	// a flial 								�
//����������������������������������������������������������������

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

oReport:SetLandscape() 		//Imprime o relatorio no formato paisagem

//������������������������������������������������������������������������Ŀ
//�                                                                        �
//�                      Definicao das Secoes                              �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//� Secao 01                                                               �
//��������������������������������������������������������������������������
oSection1 := TRSection():New(oReport, STR0034,"SA1", aOrdem) //"Dados do Cliente"

TRCell():New(oSection1,"TXTCLI"  ,     , STR0035	,									,10						,/*lPixel*/,{|| STR0015 })	//"Cliente ## CLIENTE : "
TRCell():New(oSection1,"A1_COD"  ,"SA1",  			,PesqPict("SA1","A1_COD" ),TamSX3("A1_COD" )[1],/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"A1_LOJA" ,"SA1",			,PesqPict("SA1","A1_LOJA"),TamSX3("A1_LOJA")[1],/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"A1_NOME" ,"SA1",			,PesqPict("SA1","A1_NOME"),TamSX3("A1_NOME")[1],/*lPixel*/,{|| IIF(mv_par15 == 1, SA1->A1_NOME, SA1->A1_NREDUZ) } )

oSection1:SetHeaderSection(.F.)	//Nao imprime o cabe�alho da secao

//������������������������������������������������������������������������Ŀ
//� Secao 02                                                               �
//��������������������������������������������������������������������������
oSection2 := TRSection():New(oSection1, STR0036,{"SE1","SED"}, aOrdem) //"Titulos"

TRCell():New(oSection2,"E1_PREFIXO"	, "SE1" , STR0037	, PesqPict("SE1","E1_PREFIXO") 	, TamSX3("E1_PREFIXO")[1] ,/*lPixel*/,{ || SE1->E1_PREFIXO })//"Prf"
TRCell():New(oSection2,"E1_NUM"	  	, "SE1" , STR0038 	, PesqPict("SE1","E1_NUM") 	 	, TamSX3("E1_NUM")[1]     ,/*lPixel*/,{ || SE1->E1_NUM 		})//"Numero"
TRCell():New(oSection2,"E1_PARCELA"	, "SE1" , STR0039	, PesqPict("SE1","E1_PARCELA")	, TamSX3("E1_PARCELA")[1] ,/*lPixel*/,{ || SE1->E1_PARCELA })//"PC"
TRCell():New(oSection2,"E1_TIPO"  	, "SE1" ,			, PesqPict("SE1","E1_TIPO")    	, TamSX3("E1_TIPO")[1]    ,/*lPixel*/,{ || SE1->E1_TIPO		})
TRCell():New(oSection2,"VALOR"	   	,       , STR0040 	, 								, 15 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Original"
TRCell():New(oSection2,"E1_EMISSAO", "SE1" , STR0041 	, PesqPict("SE1","E1_EMISSAO") 	, 10 ,/*lPixel*/,{ || SE1->E1_EMISSAO })//"Emissao"
TRCell():New(oSection2,"E1_VENCREA", "SE1" , STR0042 	, PesqPict("SE1","E1_VENCREA") 	, 10 ,/*lPixel*/,{ || SE1->E1_VENCREA })//"Vencto"
TRCell():New(oSection2,"BAIXA" 		,  	 	, STR0043	, PesqPict("SE1","E1_BAIXA")   	, 10 ,/*lPixel*/,/*CodeBlock*/)	//"Baixa"
TRCell():New(oSection2,"DESCON" 	,       , STR0044	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection2,"ABATIM" 	,       , STR0045	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Abatimentos"
TRCell():New(oSection2,"JUROS" 		,       , STR0046	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Juros"
TRCell():New(oSection2,"MULTA" 		,       , STR0047	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Multa"
TRCell():New(oSection2,"CMONE" 		,       , STR0048	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Corr. Monet."
TRCell():New(oSection2,"VLRBAIXA"	,       , STR0049	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"
TRCell():New(oSection2,"RECANTEC" 	,       , STR0050	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Rec. Antecip."
TRCell():New(oSection2,"E1_ACRESC"	, "SE1" , 			, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"E1_DECRESC"	, "SE1" , 			, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New(oSection2,"SALDO" 		,       , STR0051	, 								, 15 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Saldo Atual"
TRCell():New(oSection2,"MOTIVO" 	,       , STR0052	, 								, 15 ,/*lPixel*/,/*CodeBlock*/) //"Motivo"
TRCell():New(oSection2,"SITUACAO"	,       , STR0053	, 								, 10 ,/*lPixel*/,/*CodeBlock*/) //"Situacao"
TRCell():New(oSection2,"E1_PORTADO", "SE1" , STR0054	, 								, 03 ,/*lPixel*/,{ || SE1->E1_PORTADO })	//"Port."

//Faz o alinhamento do cabecalho das celulas
oSection2:Cell("DESCON"	 ):SetHeaderAlign("RIGHT")
oSection2:Cell("ABATIM"	 ):SetHeaderAlign("RIGHT")
oSection2:Cell("JUROS"	 ):SetHeaderAlign("RIGHT")
oSection2:Cell("MULTA"	 ):SetHeaderAlign("RIGHT")
oSection2:Cell("CMONE"	 ):SetHeaderAlign("RIGHT")
oSection2:Cell("VLRBAIXA"):SetHeaderAlign("RIGHT")
oSection2:Cell("RECANTEC"):SetHeaderAlign("RIGHT")
oSection2:Cell("SALDO"	 ):SetHeaderAlign("RIGHT")

oSection2:SetLineBreak(.T.)

//������������������������������������������������������������������������Ŀ
//� Secao 03                                                               �
//��������������������������������������������������������������������������
oSection3 := TRSection():New(oSection2, STR0055) //"Totais"

TRCell():New(oSection3,"TXTTOTAL"	,       , STR0055	,						    , 19 ,/*lPixel*/,/*CodeBlock*/) //"Totais"
TRCell():New(oSection3,"VALOR"	 	,		, STR0040 , PesqPict("SE1","E1_VALOR") 	, 17 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")//"Valor Original"
TRCell():New(oSection3,"E1_EMISSAO", "SE1" , STR0041	, 							, 10 ,/*lPixel*/,/*CodeBlock*/) //"Emissao"
TRCell():New(oSection3,"E1_VENCREA", "SE1" , STR0042 	,							, 10 ,/*lPixel*/,/*CodeBlock*/) //"Vencto"
TRCell():New(oSection3,"E1_BAIXA"  , "SE1" , STR0043 	, 							, 10 ,/*lPixel*/,/*CodeBlock*/) //"Baixa"
TRCell():New(oSection3,"DESCON"		,       , STR0044 	, Tm(0,13)           	   	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection3,"ABATIM"		, 	    , STR0045	, Tm(0,13)              	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Abatimentos"
TRCell():New(oSection3,"JUROS" 		,       , STR0046	, Tm(0,13)                 	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Juros"
TRCell():New(oSection3,"MULTA" 		,       , STR0047	, Tm(0,13)                 	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Multa"
TRCell():New(oSection3,"CMONE" 		,       , STR0048	, Tm(0,13)                 	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Corr. Monet."
TRCell():New(oSection3,"VLRBAIXA"	,    	, STR0049	, Tm(0,13)                 	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"
TRCell():New(oSection3,"RECANTEC" 	,  	  	, STR0050	, Tm(0,13)					, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Rec. Antecip."
TRCell():New(oSection3,"E1_ACRESC"	, "SE1" , 			, Tm(0,13) 					, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Acrescimo"
TRCell():New(oSection3,"E1_DECRESC"	, "SE1" , 			, Tm(0,13) 					, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Decrescimo"
TRCell():New(oSection3,"SALDO" 		, 	    , STR0051	, Tm(0,15) 					, 15 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Saldo Atual"

//Oculta as celulas
oSection3:Cell("E1_EMISSAO"):Hide()
oSection3:Cell("E1_VENCREA"):Hide()
oSection3:Cell("E1_BAIXA"  ):Hide()

oSection3:SetLinesBefore(0.5)
oSection3:SetHeaderSection(.F.)	//Nao imprime o cabe�alho da secao

//������������������������������������������������������������������������Ŀ
//� Secao 04                                                               �
//��������������������������������������������������������������������������
oSection4 := TRSection():New(oSection3, STR0057) //"Totais/Filial"

TRCell():New(oSection4,"TXTTOTAL"	,       , STR0055	,								, 42 ,/*lPixel*/,/*CodeBlock*/) //"Totais"
TRCell():New(oSection4,"VALOR"	   	,		, STR0040 	, PesqPict("SE1","E1_VALOR") 	, 17 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")//"Valor Original"
TRCell():New(oSection4,"DESCON" 	,       , STR0044 	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Descontos"
TRCell():New(oSection4,"ABATIM" 	, 	   	, STR0045	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Abatimentos"
TRCell():New(oSection4,"JUROS" 		,       , STR0046	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Juros"
TRCell():New(oSection4,"MULTA" 		,       , STR0047	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Multa"
TRCell():New(oSection4,"CMONE" 		,       , STR0048	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Corr. Monet."
TRCell():New(oSection4,"VLRBAIXA"	,    	, STR0049	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Valor Baixado"
TRCell():New(oSection4,"RECANTEC" 	,  	  	, STR0050	, Tm(0,13)						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Rec. Antecip."
TRCell():New(oSection4,"E1_ACRESC"	, "SE1" , 			, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Acrescimo"
TRCell():New(oSection4,"E1_DECRESC"	, "SE1" , 			, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT") //"Decrescimo"
TRCell():New(oSection4,"SALDO" 		, 	   	, STR0051	, Tm(0,15) 						, 15 ,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	 //"Saldo Atual"

oSection4:SetHeaderSection(.F.)	//Nao imprime o cabe�alho da secao

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint �Autor� Marcio Menon       � Data �  16/08/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Imprime o objeto oReport definido na funcao ReportDef.     ���                                                           ���
�������������������������������������������������������������������������͹��
���Parametros� oReport - Objeto TReport do relatorio                      ���
���          � cTitulo - Titulo do relatorio										  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportPrint(oReport,cTitulo)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local oSection3 := oReport:Section(1):Section(1):Section(1)
Local oSection4 := oReport:Section(1):Section(1):Section(1):Section(1)
Local nOrdem	 := oReport:Section(1):GetOrder()
Local lTotGer   := .F.

Local nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0,nTit6:=0,nTit7:=0,nTit8:=0,nTit9:=0,nTit10:=0,nTit11:=0
Local nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTot5:=0,nTot6:=0,nTot7:=0,nTot8:=0,nTot9:=0,nTot10:=0,nTot11:=0
Local nTotAbat	 := 0
Local cForAnt	 := Space(6)
Local lContinua := .T.
Local aValor	 := {0,0,0,0,0,0,0,0,""}
Local nSaldo	 := 0
Local nMoeda	 := mv_par10
Local dDataMoeda:= dDataBase
Local aSituacao := {STR0007,STR0008,STR0009,STR0010,;	//"Carteira"###"Simples"###"Descontada"###"Caucionada"
STR0011,STR0012,STR0013,STR0018,;	//"Vinculada"###"Advogado"###"Judicial###Caucao Desc."
STR0031,STR0032,STR0033 } 				//"Protesto"###"Acordo"###"Cartorio"
Local ndecs 	 := Msdecimais(mv_par10)
Local cMotivo	 := " "
Local aMotBx 	 := {}
Local nValor	 := 0
Local nPos 		 := 0
Local cAliasSA1 := "SA1"
Local cSitCobr  := " "
Local cCond1,cCond2,cChave,cIndex,cChaveE1,cChaveE2
Local cTipoant	 := ""
Local ntotaltipo:= 0
Local i        :=0
Local nTotFil1 :=0
Local nTotFil2 :=0
Local nTotFil3 :=0
Local nTotFil4 :=0
Local nTotFil5 :=0
Local nTotFil6 :=0
Local nTotFil7 :=0
Local nTotFil8 :=0
Local nTotFil9 :=0
Local nTotFil10:=0
Local nTotFil11:=0
Local lCancelado := .F.
Local aFiliais := {}
Local lVerFil  := .F.
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0()
Local cFilOld	:= cFilAnt
Local lSai		:= .F.
Local aCelulas := aClone(oReport:aSection[1]:aCell[4]:oParent:aSection[1]:aCell)
Local nX       := 0


#IFDEF TOP
	Local aStru  := SE1->(dbStruct()), ni
	Local cOrder
	Local cFiltSA1 := oReport:Section(1):GetSqlExp("SA1")
	Local cFiltSE1 := oReport:Section(1):GetSqlExp("SE1")
#ENDIF

Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE cFilDe,cFilAte

//����������������������������������������Ŀ
//� Definicoes da secao 2. (Titulos)		 �
//������������������������������������������
oSection2:Cell("VALOR"	 	):SetBlock( { || SayValor(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),14,;
alltrim(SE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,nDecs) } )
oSection2:Cell("BAIXA"	 	):SetBlock( { || If(dDataBase >= SE1->E1_BAIXA .Or. (mv_par14 == 2 .And. !Empty(SE1->E1_BAIXA)), IIF(!Empty(SE1->E1_BAIXA),SE1->E1_BAIXA," "), ) } )
oSection2:Cell("DESCON"	 	):SetBlock( { || aValor[I_DESCONTO] 			} )
oSection2:Cell("ABATIM"	 	):SetBlock( { || nTotAbat 						} )
oSection2:Cell("JUROS"	 	):SetBlock( { || aValor[I_JUROS] 				} )
oSection2:Cell("MULTA"	 	):SetBlock( { || aValor[I_MULTA] 				} )
oSection2:Cell("CMONE"	 	):SetBlock( { || aValor[I_CORRECAO_MONETARIA]	} )
oSection2:Cell("VLRBAIXA"	):SetBlock( { || aValor[I_VALOR_RECEBIDO] 		} )
oSection2:Cell("RECANTEC"	):SetBlock( { || aValor[I_RECEB_ANT] 			} )
oSection2:Cell("E1_ACRESC"  ):SetBlock( { || SE1->E1_SDACRES 				} )
oSection2:Cell("E1_DECRESC" ):SetBlock( { || SE1->E1_SDDECRE 				} )
oSection2:Cell("SALDO"	 	):SetBlock( { || SayValor(nSaldo,15,alltrim(SE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,nDecs)	} )
oSection2:Cell("MOTIVO"	 	):SetBlock( { || Pad(aValor[I_MOTBX],15)		} )
oSection2:Cell("SITUACAO"	):SetBlock( { || cSitCobr 						} )

oSection2:Cell("DESCON"	 	):Picture( TM(aValor[I_DESCONTO],13,nDecs				))
oSection2:Cell("ABATIM"	 	):Picture( TM(nTotAbat,13,nDecs							))
oSection2:Cell("JUROS"	 	):Picture( TM(aValor[I_JUROS],13,nDecs					))
oSection2:Cell("MULTA"	 	):Picture( TM(aValor[I_MULTA],13,nDecs					))
oSection2:Cell("CMONE"	 	):Picture( TM(aValor[I_CORRECAO_MONETARIA],13,nDecs	))
oSection2:Cell("VLRBAIXA"	):Picture( TM(aValor[I_VALOR_RECEBIDO],15,nDecs		))
oSection2:Cell("RECANTEC"	):Picture( TM(aValor[I_RECEB_ANT],13,nDecs				))
oSection2:Cell("E1_ACRESC"	):Picture( TM(SE1->E1_SDACRES,13,nDecs					))
oSection2:Cell("E1_DECRESC"	):Picture( TM(SE1->E1_SDDECRE,13,nDecs					))

oSection2:SetHeaderPage()	//Define o cabecalho da secao como padrao

//����������������������������������������Ŀ
//� Definicoes da secao 3.	(Totais)	   �
//������������������������������������������
oSection3:Cell("TXTTOTAL"	):SetBlock( { || If (!lTotGer, OemToAnsi(STR0016), OemToAnsi(STR0017)) } )	//"Totais : " ### "TOTAL GERAL : "
oSection3:Cell("VALOR"	 	):SetBlock( { || If (!lTotGer, nTit1, nTot1  ) } )
oSection3:Cell("DESCON"	 	):SetBlock( { || If (!lTotGer, nTit2, nTot2  ) } )
oSection3:Cell("ABATIM"	 	):SetBlock( { || If (!lTotGer, nTit3, nTot3  ) } )
oSection3:Cell("JUROS"	 	):SetBlock( { || If (!lTotGer, nTit4, nTot4  ) } )
oSection3:Cell("MULTA"	 	):SetBlock( { || If (!lTotGer, nTit5, nTot5  ) } )
oSection3:Cell("CMONE"	 	):SetBlock( { || If (!lTotGer, nTit6, nTot6  ) } )
oSection3:Cell("VLRBAIXA"	):SetBlock( { || If (!lTotGer, nTit7, nTot7  ) } )
oSection3:Cell("RECANTEC"	):SetBlock( { || If (!lTotGer, nTit8, nTot8  ) } )
oSection3:Cell("SALDO"	 	):SetBlock( { || If (!lTotGer, nTit9, nTot9  ) } )
oSection3:Cell("E1_ACRESC"	):SetBlock( { || If (!lTotGer, nTit10, nTot10) } )
oSection3:Cell("E1_DECRESC"	):SetBlock( { || If (!lTotGer, nTit11, nTot11) } )

//����������������������������������������Ŀ
//� Definicoes da secao 4.	(Totais/Filial)�
//������������������������������������������
oSection4:Cell("TXTTOTAL"	):SetBlock( { || STR0058 +" "+Iif(mv_par20==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")})  //"T O T A L   F I L I A L ----> "
oSection4:Cell("VALOR"	 	):SetBlock( { || nTotFil1  } )
oSection4:Cell("DESCON"	 	):SetBlock( { || nTotFil2  } )
oSection4:Cell("ABATIM"	 	):SetBlock( { || nTotFil3  } )
oSection4:Cell("JUROS"	 	):SetBlock( { || nTotFil4  } )
oSection4:Cell("MULTA"	 	):SetBlock( { || nTotFil5  } )
oSection4:Cell("CMONE"	 	):SetBlock( { || nTotFil6  } )
oSection4:Cell("VLRBAIXA"	):SetBlock( { || nTotFil7  } )
oSection4:Cell("RECANTEC"	):SetBlock( { || nTotFil8  } )
oSection4:Cell("SALDO"	 	):SetBlock( { || nTotFil9  } )
oSection4:Cell("E1_ACRESC"  ):SetBlock( { || nTotFil10 } )
oSection4:Cell("E1_DECRESC"	):SetBlock( { || nTotFil11 } )

//��������������������������������������������������������������Ŀ
//� Defini��o dos cabe�alhos                                     �
//����������������������������������������������������������������
cTitulo := oReport:Title() + " " + GetMv("MV_MOEDA"+Str(mv_par10,1))
oReport:SetTitle(cTitulo)

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
If mv_par20 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par21	// Todas as filiais
	cFilAte:= mv_par22
Endif

aFiliais := FinRetFil()

oReport:NoUserFilter()

For nInc := 1 To Len( aSM0 )
	
	If aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte)
		cFilAnt := aSM0[nInc][2]
		
		dbSelectArea("SE1")
		IF nOrdem == 1
			dbSetOrder(2)
			cChave := IndexKey()
			dbSeek(xFilial("SE1")+mv_par01+mv_par03,.T.)
			cCond1 := "SE1->E1_CLIENTE+SE1->E1_LOJA <= '"+mv_par02+mv_par04+"' .and. SE1->E1_FILIAL == '"+xFilial("SE1")+"'"
			cCond2 := "SE1->E1_CLIENTE+SE1->E1_LOJA"
			#IFDEF TOP
				cOrder := SqlOrder(cChave)
			#ENDIF
		Else
			If MV_PAR15=1
				cChave  := "E1_FILIAL+A1_NOME+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			Else
				cChave  := "E1_FILIAL+A1_NREDUZ+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			EndIf
			
			#IFDEF TOP
				If TCSrvType() == "AS/400"
					cIndex	:= CriaTrab(nil,.f.)
					dbSelectArea("SE1")
					IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
					nIndex	:= RetIndex("SE1")
					dbSetOrder(nIndex+1)
				Else
					cOrder := SqlOrder(cChave)
				EndIf
			#ELSE
				cIndex	:= CriaTrab(nil,.f.)
				dbSelectArea("SE1")
				IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
				nIndex	:= RetIndex("SE1")
				dbSetOrder(nIndex+1)
			#ENDIF
			cCond1 := ".T."
			cCond2 := "SE1->E1_NOMCLI+SE1->E1_CLIENTE+SE1->E1_LOJA"
			SE1->(dbGoTop())
		EndIf
		
		oReport:SetMeter(SE1->(LastRec()))
		
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				
				If Select("NEWSE1") > 0
					dbSelectArea("NEWSE1")
					dbCloseArea()
				Endif
				ChkFile("SE1",.F.,"NEWSE1")
				
				dbSelectArea("SE1")
				aStru := dbStruct()
				
				// Montagem do SELECT apenas com os campos necessarios ao relatorio
				cQuery := "SELECT DISTINCT "
				
				if nOrdem == 1
					cQuery += " SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_NOMCLI, "
				else
					cQuery += " SE1.E1_FILIAL, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "
				endif
				
				cQuery += " SE1.E1_NATUREZ, SE1.E1_SITUACA, SE1.E1_PORTADO, SE1.E1_SALDO, SE1.E1_MOEDA, SE1.E1_RECIBO, SE1.E1_ORIGEM, "
				cQuery += " SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA, SE1.E1_FATURA, SE1.E1_DTFATUR, SE1.E1_VALLIQ,"
				cQuery += " SE1.E1_VALOR,SE1.E1_SDACRES,SE1.E1_SDDECRE,SE1.E1_TXMOEDA,SE1.E1_ACRESC,SE1.E1_DECRESC,SE1.R_E_C_N_O_ RECNO, "
				cQuery += " SE1.E1_INSS, SE1.E1_CSLL, SE1.E1_COFINS, SE1.E1_PIS, SE1.E1_IRRF, "
				cQuery += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SE1.E1_MATRIZ "
				
				For nx := 1 To Len(aCelulas)
					If !(aCelulas[nX]:cName $ cQuery) .And. (Substr(aCelulas[nX]:cName,1,2) == "E1" .Or. Substr(aCelulas[nX]:cName,1,2) == "A1")
						If Substr(aCelulas[nX]:cName,1,2) == "E1"
							cQuery += ",SE1." + aCelulas[nX]:cName + " "
						Else
							cQuery += ",SA1." + aCelulas[nX]:cName + " "
						EndIf
					EndIf
				Next nX
				
				cQuery += " FROM " + RetSqlName("SE1") +" SE1 (nolock)"
				
				cQuery += " JOIN " + RetSQLName("SE5") + " SE5 (nolock) "
				cQuery += "   ON  SE5.E5_FILIAL  = '" + xFilial("SE5") + "' AND "
				cQuery += "       SE5.E5_PREFIXO = SE1.E1_PREFIXO AND "
				cQuery += "       SE5.E5_NUMERO  = SE1.E1_NUM     AND "
				cQuery += "       SE5.E5_PARCELA = SE1.E1_PARCELA AND "
				cQuery += "       SE5.E5_TIPO    = SE1.E1_TIPO   AND "
				cQuery += "       SE5.E5_MOTBX   <> 'DSD'        AND "
				cQuery += "       SE5.E5_RECPAG  = 'R'           AND "
				If mv_par18 == 2
					cQuery += "    SE5.E5_MOTBX   <> 'LIQ'        AND "
				EndIf
				cQuery += "       SE5.D_E_L_E_T_ = ' ' "
				
				cQuery += " JOIN " + RetSqlName("SA1") + " SA1 (nolock) "
				cQuery += "   ON  SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
				cQuery += "       SA1.A1_COD = SE1.E1_CLIENTE AND "
				cQuery += "       SA1.A1_LOJA = SE1.E1_LOJA  AND "
				cQuery += "       SA1.D_E_L_E_T_ = ' ' "
				
				cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
				cQuery += " AND SE1.E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
				cQuery += " AND SE1.E1_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
				cQuery += " AND SE1.E1_EMISSAO between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
				cQuery += " AND SE1.E1_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
				cQuery += " AND SE1.E1_TIPO NOT LIKE '%-' "
				cQuery += " AND SE1.E1_EMISSAO <=  '"     + DTOS(dDataBase) + "'"
				cQuery += " AND SE1.E1_NATUREZ between '" + mv_par16        + "' AND '" + mv_par17       + "'"
				If cPaisLoc<>"BRA"
					cQuery += "AND SE1.E1_TIPO<>'CH' AND SE1.E1_TIPO<>'TF'"
				EndIf
				If mv_par09 == 2
					cQuery += " AND SE1.E1_TIPO <> '"+MVPROVIS+"'"
				EndIf
				If mv_par12 == 2
					cQuery += " AND SE1.E1_FATURA IN('"+Space(Len(E1_FATURA))+"','NOTFAT') "
				Endif
				
				If mv_par19 == 2
					cQuery += "AND (( SE1.E1_RECIBO <> '"+Space(Len(SE1->E1_RECIBO))+"'"
					cQuery += "AND SE1.E1_ORIGEM = 'FINA087A') OR (SE1.E1_RECIBO = '"+Space(Len(SE1->E1_RECIBO))+"') )"
				Endif
				
				cQuery += " AND SE1.D_E_L_E_T_ = ' '"
				
				//Adiciono filtro do usuario na Query
				If !Empty(cFiltSA1)
					cQuery += " AND " + cFiltSA1
				EndIf
				
				//Adiciono filtro do usuario na Query
				If !Empty(cFiltSE1)
					cQuery += " AND " + cFiltSE1
				EndIf
				
				cQuery2 := " UNION SELECT "
				
				if nOrdem == 1
					cQuery2 += " SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_NOMCLI, "
				else
					cQuery2 += " SE1.E1_FILIAL, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "
				endif
				
				cQuery2 += " SE1.E1_NATUREZ, SE1.E1_SITUACA, SE1.E1_PORTADO, SE1.E1_SALDO, SE1.E1_MOEDA, SE1.E1_RECIBO, SE1.E1_ORIGEM, "
				cQuery2 += " SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA, SE1.E1_FATURA, SE1.E1_DTFATUR, SE1.E1_VALLIQ,"
				cQuery2 += " SE1.E1_VALOR,SE1.E1_SDACRES,SE1.E1_SDDECRE,SE1.E1_TXMOEDA,SE1.E1_ACRESC,SE1.E1_DECRESC,SE1.R_E_C_N_O_ RECNO, "
				cQuery2 += " SE1.E1_INSS, SE1.E1_CSLL, SE1.E1_COFINS, SE1.E1_PIS, SE1.E1_IRRF, "
				cQuery2 += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SE1.E1_MATRIZ " "
				
				For nx := 1 To Len(aCelulas)
					If !(aCelulas[nX]:cName $ cQuery2) .And. (Substr(aCelulas[nX]:cName,1,2) == "E1" .Or. Substr(aCelulas[nX]:cName,1,2) == "A1")
						If Substr(aCelulas[nX]:cName,1,2) == "E1"
							cQuery2 += ",SE1." + aCelulas[nX]:cName + " "
						Else
							cQuery2 += ",SA1." + aCelulas[nX]:cName + " "
						EndIf
					EndIf
				Next nX
				
				cQuery += cQuery2
				
				cQuery += " FROM " + RetSqlName("SE1") +" SE1 (nolock) "
				
				cQuery += " JOIN " + RetSqlName("SA1") + " SA1 (nolock) "
				cQuery += "   ON  SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
				cQuery += "       SA1.A1_COD = SE1.E1_CLIENTE AND "
				cQuery += "       SA1.A1_LOJA = SE1.E1_LOJA  AND "
				cQuery += "       SA1.D_E_L_E_T_ = ' ' "
				cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
				cQuery += " AND SE1.E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
				cQuery += " AND SE1.E1_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
				cQuery += " AND SE1.E1_EMISSAO between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
				cQuery += " AND SE1.E1_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
				cQuery += " AND SE1.E1_TIPO NOT LIKE '%-' "
				cQuery += " AND SE1.E1_TIPO NOT LIKE 'RA' "
				cQuery += " AND SE1.E1_EMISSAO <=  '"     + DTOS(dDataBase) + "'"
				cQuery += " AND SE1.E1_NATUREZ between '" + mv_par16        + "' AND '" + mv_par17       + "'"
				If cPaisLoc<>"BRA"
					cQuery += "AND SE1.E1_TIPO<>'CH' AND SE1.E1_TIPO<>'TF'"
				EndIf
				If mv_par09 == 2
					cQuery += " AND SE1.E1_TIPO <> '"+MVPROVIS+"'"
				EndIf
				If mv_par12 == 2
					cQuery += " AND SE1.E1_FATURA IN('"+Space(Len(E1_FATURA))+"','NOTFAT') "
				Endif
				
				If mv_par19 == 2
					cQuery += "AND (( SE1.E1_RECIBO <> '"+Space(Len(SE1->E1_RECIBO))+"'"
					cQuery += "AND SE1.E1_ORIGEM = 'FINA087A') OR (SE1.E1_RECIBO = '"+Space(Len(SE1->E1_RECIBO))+"') )"
				Endif
				
				cQuery += " AND SE1.E1_SALDO = SE1.E1_VALOR "
				cQuery += " AND SE1.D_E_L_E_T_ = ' '"
				
				//Adiciono filtro do usuario na Query
				If !Empty(cFiltSA1)
					cQuery += " AND " + cFiltSA1
				EndIf
				
				//Adiciono filtro do usuario na Query
				If !Empty(cFiltSE1)
					cQuery += " AND " + cFiltSE1
				EndIf
				
				cQuery += " ORDER BY " + cOrder
				
				dbSelectArea("SE1")
				dbCloseArea()
				
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .T., .T.)
				count to _nLastRec
				ProcRegua(_nLastRec)
				DbGoTop()
				
				For ni := 1 to Len(aStru)
					If aStru[ni,2] != 'C' .and. FieldPos(aStru[ni,1]) > 0
						TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
					Endif
				Next
				
				//Desabilita o filtro no tratamento da Printline()
				oReport:NoUserFilter()
				
				If (SE1->(EOF()))
					lContinua := .F.
				Else
					lContinua := .T.
				EndIf
				cAliasSA1 := "SE1"
			EndIf
		#ENDIF
		
		While SE1->(!Eof()) .And. lContinua .And. &cCond1 .And. !oReport:Cancel()
			
			If oReport:Cancel()
				lContinua := .F.
				Exit
			EndIf
			
			
			#IFNDEF TOP
				// Nao considera Ti. Liquidados ou geradores de liquidacao
				dbSelectArea("SE5")
				dbSetorder(5)
				
				IF SE5->(MsSeek(xFilial('SE5')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
					
					cChaveE1 := "xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO"
					cChaveE5 := "xFilial('SE5')+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO"
					
					While !EOF() .And. (&(cChaveE1) == &(cChaveE5))
						If (mv_par18 == 2 .AND. SE5->E5_MOTBX == "LIQ" ) .OR. SE5->E5_MOTBX == "DSD"
							lSai := .T.
							Exit
						EndIf
						SE5->(dbSkip())
					Enddo
					If lSai
						SE1->(dbSkip())
						Loop
					Endif
					
				Endif
				dbSelectArea("SE1")
				
			#ENDIF
			
			//��������������������������������������������������������������Ŀ
			//� Considera filtro do usuario                                  �
			//����������������������������������������������������������������
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("NEWSE1")
					dbGoto(SE1->RECNO)
				Endif
			#Endif
			
			dbSelectArea("SE1")
			
			nCont := 1
			nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=nTit10:=nTit11:=0
			cForAnt:= &cCond2
			
			While &cCond2 == cForAnt .And. lContinua .And. &cCond1 .And. !Eof()
				
				#IFNDEF TOP
					If mv_par19 == 2
						If (!Empty(SE1->E1_RECIBO) .And. SE1->E1_ORIGEM <> "FINA087A")
							SE1->( dbSkip() )
							Loop
						Endif
					Endif
				#ENDIF
				
				If oReport:Cancel()
					lContinua := .F.
					Exit
				EndIf
				
				oReport:IncMeter()
				
				//��������������������������������������������������������������Ŀ
				//� Considera filtro do usuario                                  �
				//����������������������������������������������������������������
				#IFDEF TOP
					If TcSrvType() != "AS/400"
						dbSelectArea("NEWSE1")
						dbGoto(SE1->RECNO)
					Endif
				#Endif
				
				If !Fr340Skip("SE1")
					dbSelectArea("SE1")
					dbSkip()
					Loop
				EndIf
				
				//��������������������������������������������������������������Ŀ
				//� Imprime os dados dos clientes.                               �
				//����������������������������������������������������������������
				dbSelectArea("SA1")
				dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				If nCont = 1
					oSection1:Init()
					oSection1:PrintLine()
					oSection1:Finish()
					nCont++
				Endif
				
				dbSelectArea("SE1")
				
				IF mv_par11 == 1
					dDataMoeda	:=	dDataBase
				Else
					dDataMoeda	:=	SE1->E1_VENCREA
				Endif
				
				aValor := Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,nMoeda,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA,,,,mv_par14 == 1, @lCancelado)
				
				If lCancelado
					SE1->( DbSkip() )
					Loop
				EndIf
				
				// Indica se deve checar outras filiais
				lVerFil := (!Empty(xFilial("SE1")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1)
				
				// Caso o titulo tenha baixa e a mesma nao conste para a filial corrente (vetor aValor acima), verifica se existem baixas em oturas filiais
				If lVerFil .And. !Empty(SE1->E1_BAIXA) .And. aValor[11] == 0
					F340VerBxFil( @aValor, aFiliais, nMoeda )
				EndIf
				
				If mv_par14 == 1
					nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,nMoeda,dDataMoeda,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					// Verifica se existem compensacoes em outras filiais para descontar do saldo, pois a SaldoTit() verifica
					// somente as movimentacoes da filial corrente.
					If lVerFil .And. nSaldo > 0
						nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,,aFiliais),;
						SE1->E1_MOEDA,mv_par10,dDataMoeda,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0) ),;
						nDecs+1),nDecs)
					EndIf
				Else
					nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par10,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				Endif
				
				If SE1->E1_VALOR <> SE1->E1_VALLIQ .Or. SE1->(E1_CSLL+E1_COFINS+E1_PIS+E1_IRRF+E1_INSS) > 0
					nTotAbat := SomaAbat ( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, "R", nMoeda )
				Else
					nTotAbat := 0
				EndIf
				
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
					! ( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nSaldo -= nTotAbat
				EndIf
				
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
					aValor[I_DESCONTO] += SE1->E1_DECRESC
					nSaldo -= SE1->E1_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					aValor[I_JUROS] += SE1->E1_ACRESC
					nSaldo += SE1->E1_ACRESC
				Endif
				
				If SE1->E1_SALDO > 0 .And. Empty(SE1->E1_BAIXA)
					aValor[I_JUROS] += SE1->E1_ACRESC
					aValor[I_DESCONTO] += SE1->E1_DECRESC
				Else
					aValor[I_JUROS] += SE1->E1_SDACRES
					aValor[I_DESCONTO] += SE1->E1_SDDECRE
				EndIf
				
				Do Case
					Case SE1->E1_SITUACA $ "01234567"
						cSitCobr := aSituacao[Val(SE1->E1_SITUACA)+1]
					Case SE1->E1_SITUACA == "F"	//Carteira Protesto
						cSitCobr := aSituacao[9]
					Case SE1->E1_SITUACA == "G"	//Carteira Acordo
						cSitCobr := aSituacao[10]
					Case SE1->E1_SITUACA == "H"	//Cartorio
						cSitCobr := aSituacao[11]
					OtherWise
						cSitCobr := " "
				EndCase
				
				If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
					nTit1 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit7 += aValor[I_VALOR_RECEBIDO]
					nTit9 += nSaldo
				Else
					nTit1 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit7 -= aValor[I_VALOR_RECEBIDO]
					nTit9 -= nSaldo
				Endif
				
				nTit2 += aValor[I_DESCONTO]
				nTit3 += nTotAbat
				nTit4 += aValor[I_JUROS]
				nTit5 += aValor[I_MULTA]
				nTit6 += aValor[I_CORRECAO_MONETARIA]
				nTit8 += aValor[I_RECEB_ANT]
				nTit10 += SE1->E1_SDACRES
				nTit11 += SE1->E1_SDDECREC
				
				If cPaisLoc <> "BRA"
					cMotivo := SE1->E1_TIPO+"   "+ Substr(aValor[I_MOTBX],1,10)
					nvalor  := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nPos    := aScan(aMotBx,{|X| x[1]== cMotivo})
					
					If nPos > 0
						aMotBx[nPos][2] += nvalor
					else
						Aadd(aMotBx,{cMotivo,nvalor})
					Endif
				Endif
				
				//��������������������������������������������������������������Ŀ
				//� Imprime os titulos dos clientes.                             �
				//����������������������������������������������������������������
				oSection2:Init()
				oSection2:PrintLine()
				
				dbSelectArea("SE1")
				dbSkip()
			Enddo
			
			oSection2:Finish()
			
			//��������������������������������������������������������������Ŀ
			//� Imprime os totais.						                          �
			//����������������������������������������������������������������
			oSection3:Init()
			
			If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+;
				ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9)+ABS(nTit10)+ABS(nTit11) > 0 )
				
				nTot1  += nTit1
				nTot2  += nTit2
				nTot3  += nTit3
				nTot4  += nTit4
				nTot5  += nTit5
				nTot6  += nTit6
				nTot7  += nTit7
				nTot8  += nTit8
				nTot9  += nTit9
				nTot10 += nTit10
				nTot11 += nTit11
				
				nTotFil1  += nTit1
				nTotFil2  += nTit2
				nTotFil3  += nTit3
				nTotFil4  += nTit4
				nTotFil5  += nTit5
				nTotFil6  += nTit6
				nTotFil7  += nTit7
				nTotFil8  += nTit8
				nTotFil9  += nTit9
				nTotFil10 += nTit10
				nTotFil11 += nTit11
				
				oSection3:PrintLine()
			EndIf
			oSection3:Finish()
			oReport:ThinLine()
		Enddo
		
		SE1->(DbCloseArea())
		
		//����������������������������������������Ŀ
		//� Imprimir TOTAL por filial somente quan-�
		//� do houver mais do que 1 filial.        �
		//������������������������������������������
		if mv_par20 == 1 .and. Len( aSM0 ) > 1
			oSection4:Init()
			oSection4:PrintLine()
			oSection4:Finish()
			oReport:ThinLine()
			
		Endif
		
		Store 0 To nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nTotFil10,nTotFil11
	EndIf
Next

cFilAnt := cFilOld

//��������������������������������������������������������������Ŀ
//� Imprime o Total Geral.					                     �
//����������������������������������������������������������������
lTotGer := .T.

oSection3:Init()
oSection3:PrintLine()
oSection3:Finish()

If cPaisLoc <> "BRA"
	oSection3:Cell("DESCON"	 ):Disable()
	oSection3:Cell("ABATIM"	 ):Disable()
	oSection3:Cell("JUROS"	 ):Disable()
	oSection3:Cell("MULTA"	 ):Disable()
	oSection3:Cell("CMONE"	 ):Disable()
	oSection3:Cell("VLRBAIXA"):Disable()
	oSection3:Cell("RECANTEC"):Disable()
	oSection3:Cell("SALDO"	 ):Disable()
	oSection3:Init()
	oReport:PrintText(OemToAnsi(STR0027))		//"TOTAL POR MOTIVO : "
	
	For i:=1 to Len(aMotBx)
		If cTipoant==" "
			cTipoant:=subs(aMotBX[i][1],1,3)
		Endif
		If  ctipoant	== subs(aMotBX[i][1],1,3)
			oSection3:Cell("TXTTOTAL"):SetBlock( { || aMotBX[i] [1] } )
			oSection3:Cell("VALOR"	 ):SetBlock( { || aMotBX[i] [2] } )
			oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
			oSection3:PrintLine()
			ntotaltipo += aMotBX[i] [2]
			ctipoant	  := subs(aMotBX[i][1],1,3)
		else
			oSection3:Cell("TXTTOTAL"):SetBlock( { || OemToAnsi(STR0016) + ctipoant } )
			oSection3:Cell("VALOR"	 ):SetBlock( { || ntotaltipo } )
			oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
			ntotaltipo := 0
			oSection3:PrintLine()
			oReport:PrintText("")
			oSection3:Cell("TXTTOTAL"):SetBlock( { || aMotBX[i] [1] } )
			oSection3:Cell("VALOR"	 ):SetBlock( { || aMotBX[i] [2] } )
			oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
			oSection3:PrintLine()
			ntotaltipo += aMotBX[i] [2]
			ctipoant   := subs(aMotBX[i][1],1,3)
		Endif
	Next i
	oSection3:Cell("TXTTOTAL"):SetBlock( { || OemToAnsi(STR0016) + ctipoant } )
	oSection3:Cell("VALOR"	 ):SetBlock( { || ntotaltipo } )
	oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
	oSection3:PrintLine()
	oSection3:Finish()
EndIf

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	If TcSrvType() != "AS/400"
		If Select("NEWSE1") > 0
			dbSelectArea("NEWSE1")
			dbCloseArea()
		Endif
		dbSelectArea("SE1")
		dbCloseArea()
		ChkFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	else
		dbSelectArea("SE1")
		dbClearFil()
		RetIndex( "SE1" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF

Return

/*
---------------------------------------------- Release 3 ---------------------------------------------------------
*/
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR340  � Autor � Paulo Boschetti       � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posicao dos Clientes                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FINR340(void)                                              ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGAFIN																	  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��� Mauricio   �21/11/97�13526 � Nao imprimir subtotal com valores zerados���
��� Mauricio   �08/12/97�xxxxx � Corrigir array de situacao de titulos    ���
��� Mauricio   �28/06/98�xxxxx � Considerar numero titulos c/12 posicoes  ���
��� Mauricio   �02/07/98�xxxxx � Alinhar relatorio                        ���
��� Andreia    �05/10/98�xxxxx � Ajustar lay-out para ativar Set Century  ���
��� Wagner     �27/11/98�xxxxx � Acerto cabecalho                         ���
��� Andreia    �11/01/99�xxxxx � Ordenacao por ordem alfabetica.          ���
��� Julio      �24.06.99�22201A� Valores significativos impressos entre   ���
���            �        �      � par�nteses caso Valor < 0                ���
��� Julio      �29.07.99�META  � Interpretar MV_CRNEG                     ���
��� Mauricio   �10/08/99�23192A� Considerar Cliente/Loja na verificacao   ���
���            �        �      � de baixas do titulo.                     ���
��� Pilar	   �04/10/99�      � Melhoria de Performance                  ���
��� Julio W	   �30.11.99�META  � Interpretar filtro do usuario            ���
��� MAURICIO   �09.12.99�xxxxxx�Corrigir filtro usuario                   ���
��� Bruno      �10.02.00�xxxxx �Corrigir o saldo en moeda > 1 (usar nSaldo���
���            �        �      � que � o certo r n�o SE1->E1_SALDO).      ���
���            �        �      �Substarir nos Subtotais o valor pago, usar���
���            �        �      � o ABS na chamada da ImpSubTot().         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function  FinR340R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local cDesc1 :=OemToAnsi(STR0001)  //"Este programa ir� emitir a posi��o de clientes "
Local cDesc2 :=OemToAnsi(STR0002)  //"referente a data base do sistema."
Local cDesc3 :=""
Local cString:="SE1"

Private aLinha:={}
Private aReturn:={ OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private cPerg:="FIN340"
Private cabec1,cabec2,titulo,wnrel,tamanho:="G",nomeprog:="FINR340"
Private nLastKey := 0
Private aOrd :={OemToAnsi(STR0020),OemToAnsi(STR0021) }  //"Por Codigo"###"Por Nome"

//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������
titulo:= OemToAnsi(STR0005)  //"Posicao dos Clientes "
cabec1:= OemToAnsi(STR0006)  //"Prf Numero      PC  Tip Valor Original Emissao   Vencto   Baixa                               R  E  C  E  B  I  M  E  N  T  O  S                                                                       "
cabec2:= OemToAnsi(STR0019) //"                                                                   Descontos    Abatimentos          Juros          Multa    Corr. Monet     Valor Baixado   Rec.Antecipado    Saldo Atual  Motivo          Situacao     Port."


//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("FIN340",.F.)


//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // do Cliente                            �
//� mv_par02            // Ate o Cliente                         �
//� mv_par03            // Da Loja                               �
//� mv_par04            // Ate a Loja                            �
//� mv_par05            // Da Emissao                            �
//� mv_par06            // Ate a Emissao                         �
//� mv_par07            // Do Vencimento                         �
//� mv_par08            // Ate o Vencimento                      �
//� mv_par09            // Imprime os t�tulos provis�rios        �
//� mv_par10            // Qual a moeda                          �
//� mv_par11            // Reajusta pela DataBase ou Vencto      �
//� mv_par12            // Considera Faturados                   �
//� mv_par13            // Imprime Outras Moedas                 �
//� mv_par14            // Considera Data Base                   �
//� mv_par15            // Imprime Nome? (Razao Social/N.Reduzid)�
//� mv_par16            // Natureza De ?                         �
//� mv_par17            // Natureza Ate?                         �
//� mv_par18            // Considera Liquidados?                 �
//� mv_par20			// Consid Filiais  ?  					�
//� mv_par21			// da filial							�
//� mv_par22			// a flial 								�
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="FINR340"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif
      
fErase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa340Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA340Imp � Autor � Paulo Boschetti       � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posicao dos Clientes                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA340Imp(lEnd,wnRel,cString)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd    - A��o do Codeblock                                ���
���          � wnRel   - T�tulo do relat�rio                              ���
���          � cString - Mensagem                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FA340Imp(lEnd,wnRel,cString)

Local CbTxt,cbCont
Local nTotAbat:=0,nOrdem
Local nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0,nTit6:=0,nTit7:=0,nTit8:=0,nTit9:=0
Local nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTot5:=0,nTot6:=0,nTot7:=0,nTot8:=0,nTot9:=0
Local cForAnt:=Space(6)
Local lContinua := .T.
Local aValor:={0,0,0,0,0,0,0,0,""}
Local nSaldo:=0
Local nMoeda:=0
Local dDataMoeda:=dDataBase
Local aSituacao :={STR0007,STR0008,STR0009,STR0010,;		//"Carteira"###"Simples"###"Descontada"###"Caucionada"
STR0011,STR0012,STR0013,STR0018,;	//"Vinculada"###"Advogado"###"Judicial###Caucao Desc."
STR0031,STR0032,STR0033 } //"Protesto"###"Acordo"###"Cartorio"

LOCAL cCond1,cCond2,cChave,cIndex

#IFDEF TOP
	Local aStru 	:= SE1->(dbStruct()), ni
	Local cOrder
#ENDIF
Local cFilterUser := aReturn[7]
Local ndecs :=Msdecimais(mv_par10)
Local cMotivo:= " "
Local aMotBx := {}
Local nValor:= 0
Local nPos := 0
Local cAliasSA1 := "SA1"
Local cSitCobr := " "
Local nTotFil1:=0
Local nTotFil2:=0
Local nTotFil3:=0
Local nTotFil4:=0
Local nTotFil5:=0
Local nTotFil6:=0
Local nTotFil7:=0
Local nTotFil8:=0
Local nTotFil9:=0
Local aFiliais:= {}
Local lVerFil := .F.
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0()
Local cFilOld	:= cFilAnt

PRIVATE cFilDe,cFilAte

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
If mv_par20 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par21	// Todas as filiais
	cFilAte:= mv_par22
Endif

aFiliais := FinRetFil()

For nInc := 1 To Len( aSM0 )
	If aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte)
		cFilAnt := aSM0[nInc][2]
		
		nMoeda := mv_par10
		Titulo += " - " + GetMv("MV_MOEDA"+Str(nMoeda,1))
		nOrdem := aReturn[8]
		
		dbSelectArea("SE1")
		IF nOrdem = 1
			dbSetOrder(2)
			cChave := IndexKey()
			dbSeek(xFilial("SE1")+mv_par01+mv_par03,.t.)
			cCond1 := 'SE1->E1_CLIENTE+SE1->E1_LOJA <= mv_par02+mv_par04 .and. SE1->E1_FILIAL == xFilial("SE1")'
			cCond2 := "SE1->E1_CLIENTE+SE1->E1_LOJA"
			#IFDEF TOP
				cOrder := SqlOrder(cChave)
			#ENDIF
		Else
			If MV_PAR15=1
				cChave  := "E1_FILIAL+A1_NOME+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			Else
				cChave  := "E1_FILIAL+A1_NREDUZ+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
			EndIf
			
			#IFDEF TOP
				If TCSrvType() == "AS/400"
					cIndex	:= CriaTrab(nil,.f.)
					dbSelectArea("SE1")
					IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
					nIndex	:= RetIndex("SE1")
					dbSetOrder(nIndex+1)
				Else
					cOrder := SqlOrder(cChave)
				EndIf
			#ELSE
				cIndex	:= CriaTrab(nil,.f.)
				dbSelectArea("SE1")
				IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
				nIndex	:= RetIndex("SE1")
				dbSetIndex(cIndex+OrdBagExt())
				dbSetOrder(nIndex+1)
			#ENDIF
			cCond1 := ".T."
			cCond2 := "SE1->E1_NOMCLI+SE1->E1_CLIENTE+SE1->E1_LOJA"
			SE1->( dbGoTop() )
		EndIf
		SetRegua(RecCount())
		
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				
				If Select("NEWSE1") > 0
					dbSelectArea("NEWSE1")
					dbCloseArea()
				Endif
				ChkFile("SE1",.F.,"NEWSE1")
				
				dbSelectArea("SE1")
				aStru := dbStruct()
				
				// Montagem do SELECT apenas com os campos necessarios ao relatorio
				cQuery := "SELECT DISTINCT "
				
				if nOrdem == 1
					cQuery += " SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_NOMCLI, "
				else
					cQuery += " SE1.E1_FILIAL, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "
				endif
				
				cQuery += " SE1.E1_NATUREZ, SE1.E1_SITUACA, SE1.E1_PORTADO, SE1.E1_SALDO, SE1.E1_MOEDA, SE1.E1_RECIBO, SE1.E1_ORIGEM, "
				cQuery += " SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA, SE1.E1_FATURA, SE1.E1_DTFATUR, SE1.E1_VALLIQ,"
				cQuery += " SE1.E1_VALOR,SE1.E1_SDACRES,SE1.E1_SDDECRE,SE1.E1_TXMOEDA,SE1.E1_ACRESC,SE1.E1_DECRESC,SE1.R_E_C_N_O_ RECNO, "
				cQuery += " SE1.E1_INSS, SE1.E1_CSLL, SE1.E1_COFINS, SE1.E1_PIS, SE1.E1_IRRF, "
				cQuery += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SE1.E1_MATRIZ "
				
				cQuery += " FROM " + RetSqlName("SE1") +" SE1 "
				
				cQuery += " JOIN " + RetSQLName("SE5") + " SE5 "
				cQuery += "   ON  SE5.E5_FILIAL  = '" + xFilial("SE5") + "' AND "
				cQuery += "       SE5.E5_PREFIXO = SE1.E1_PREFIXO AND "
				cQuery += "       SE5.E5_NUMERO  = SE1.E1_NUM     AND "
				cQuery += "       SE5.E5_PARCELA = SE1.E1_PARCELA AND "
				cQuery += "       SE5.E5_TIPO    = SE1.E1_TIPO   AND "
				cQuery += "       SE5.E5_RECPAG  = 'R'           AND "
				cQuery += "       SE5.E5_MOTBX   <> 'DSD'        AND "
				If mv_par18 == 2
					cQuery += "    SE5.E5_MOTBX   <> 'LIQ'        AND "
				EndIf
				cQuery += "       SE5.D_E_L_E_T_ = ' ' "
				
				cQuery += " JOIN " + RetSqlName("SA1") + " SA1 "
				cQuery += "   ON  SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
				cQuery += "       SA1.A1_COD = SE1.E1_CLIENTE AND "
				cQuery += "       SA1.A1_LOJA = SE1.E1_LOJA  AND "
				cQuery += "       SA1.D_E_L_E_T_ = ' ' "
				
				cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
				cQuery += " AND SE1.E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
				cQuery += " AND SE1.E1_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
				cQuery += " AND SE1.E1_EMISSAO between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
				cQuery += " AND SE1.E1_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
				cQuery += " AND SE1.E1_TIPO NOT LIKE '%-' "
				cQuery += " AND SE1.E1_EMISSAO <=  '"     + DTOS(dDataBase) + "'"
				cQuery += " AND SE1.E1_NATUREZ between '" + mv_par16        + "' AND '" + mv_par17       + "'"
				If cPaisLoc<>"BRA"
					cQuery += "AND SE1.E1_TIPO<>'CH' AND SE1.E1_TIPO<>'TF'"
				EndIf
				If mv_par09 == 2
					cQuery += " AND SE1.E1_TIPO <> '"+MVPROVIS+"'"
				EndIf
				If mv_par12 == 2
					cQuery += " AND SE1.E1_FATURA IN('"+Space(Len(E1_FATURA))+"','NOTFAT') "
				Endif
				
				If mv_par19 == 2
					cQuery += "AND (( SE1.E1_RECIBO <> '"+Space(Len(SE1->E1_RECIBO))+"'"
					cQuery += "AND SE1.E1_ORIGEM = 'FINA087A') OR (SE1.E1_RECIBO = '"+Space(Len(SE1->E1_RECIBO))+"') )"
				Endif
				
				cQuery += " AND SE1.D_E_L_E_T_ = ' '"
				
				cQuery += " UNION SELECT "
				
				if nOrdem == 1
					cQuery += " SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_NOMCLI, "
				else
					cQuery += " SE1.E1_FILIAL, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "
				endif
				
				cQuery += " SE1.E1_NATUREZ, SE1.E1_SITUACA, SE1.E1_PORTADO, SE1.E1_SALDO, SE1.E1_MOEDA, SE1.E1_RECIBO, SE1.E1_ORIGEM, "
				cQuery += " SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA, SE1.E1_FATURA, SE1.E1_DTFATUR, SE1.E1_VALLIQ,"
				cQuery += " SE1.E1_VALOR,SE1.E1_SDACRES,SE1.E1_SDDECRE,SE1.E1_TXMOEDA,SE1.E1_ACRESC,SE1.E1_DECRESC,SE1.R_E_C_N_O_ RECNO, "
				cQuery += " SE1.E1_INSS, SE1.E1_CSLL, SE1.E1_COFINS, SE1.E1_PIS, SE1.E1_IRRF, "
				cQuery += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SE1.E1_MATRIZ "
				
				cQuery += " FROM " + RetSqlName("SE1") +" SE1 "
				
				cQuery += " JOIN " + RetSqlName("SA1") + " SA1 "
				cQuery += "   ON  SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
				cQuery += "       SA1.A1_COD = SE1.E1_CLIENTE AND "
				cQuery += "       SA1.A1_LOJA = SE1.E1_LOJA  AND "
				cQuery += "       SA1.D_E_L_E_T_ = ' ' "
				cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
				cQuery += " AND SE1.E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
				cQuery += " AND SE1.E1_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
				cQuery += " AND SE1.E1_EMISSAO between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
				cQuery += " AND SE1.E1_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
				cQuery += " AND SE1.E1_TIPO NOT LIKE '%-' "
				cQuery += " AND SE1.E1_TIPO NOT LIKE 'RA' "
				cQuery += " AND SE1.E1_EMISSAO <=  '"     + DTOS(dDataBase) + "'"
				cQuery += " AND SE1.E1_NATUREZ between '" + mv_par16        + "' AND '" + mv_par17       + "'"
				If cPaisLoc<>"BRA"
					cQuery += "AND SE1.E1_TIPO<>'CH' AND SE1.E1_TIPO<>'TF'"
				EndIf
				If mv_par09 == 2
					cQuery += " AND SE1.E1_TIPO <> '"+MVPROVIS+"'"
				EndIf
				If mv_par12 == 2
					cQuery += " AND SE1.E1_FATURA IN('"+Space(Len(E1_FATURA))+"','NOTFAT') "
				Endif
				
				If mv_par19 == 2
					cQuery += "AND (( SE1.E1_RECIBO <> '"+Space(Len(SE1->E1_RECIBO))+"'"
					cQuery += "AND SE1.E1_ORIGEM = 'FINA087A') OR (SE1.E1_RECIBO = '"+Space(Len(SE1->E1_RECIBO))+"') )"
				Endif
				
				cQuery += " AND SE1.E1_SALDO = SE1.E1_VALOR "
				cQuery += " AND SE1.D_E_L_E_T_ = ' '"
				
				cQuery += " ORDER BY " + cOrder
				
				
				dbSelectArea("SE1")
				dbCloseArea()
				
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .T., .T.)
				count to _nLastRec
				ProcRegua(_nLastRec)
				DbGoTop()
				For ni := 1 to Len(aStru)
					If aStru[ni,2] != 'C' .and. FieldPos(aStru[ni,1]) > 0
						TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
					Endif
				Next
				
				If (SE1->(EOF()))
					lContinua := .F.
				Else
					lContinua := .T.
				EndIf
				cAliasSA1 := "SE1"
			EndIf
		#ENDIF
		
		While !Eof() .And. lContinua .And. &cCond1
			
			#IFNDEF TOP
				// Nao considera Ti. Liquidados ou geradores de liquidacao
				dbSelectArea("SE5")
				dbSetorder(5)
				
				IF SE5->(MsSeek(xFilial('SE5')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
					
					cChaveE1 := "xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO"
					cChaveE5 := "xFilial('SE5')+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO"
					
					While !EOF() .And. (&(cChaveE1) == &(cChaveE5))
						If (mv_par18 == 2 .AND. SE5->E5_MOTBX == "LIQ" ) .OR. SE5->E5_MOTBX == "DSD"
							lSai := .T.
							Exit
						EndIf
						SE5->(dbSkip())
					Enddo
					If lSai
						SE1->(dbSkip())
						Loop
					Endif
					
				Endif
				dbSelectArea("SE1")
				
			#ENDIF
			
			If lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0014)  //"CANCELADO PELO OPERADOR"
				Exit
			Endif
			
			//��������������������������������������������������������������Ŀ
			//� Considera filtro do usuario                                  �
			//����������������������������������������������������������������
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("NEWSE1")
					dbGoto(SE1->RECNO)
				Endif
			#Endif
			
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SE1")
			
			nCont:=1
			nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=0
			cForAnt:= &cCond2
			
			While &cCond2 == cForAnt .And. lContinua .And. &cCond1 .And. !Eof()
				
				#IFNDEF TOP
					
					If mv_par19 == 2
						If (!Empty(SE1->E1_RECIBO) .And. SE1->E1_ORIGEM <> "FINA087A")
							SE1->( dbSkip() )
							Loop
						Endif
					Endif
					
				#ENDIF
				
				
				If lEnd
					@PROW()+1,001 PSAY OemToAnsi(STR0014)  //"CANCELADO PELO OPERADOR"
					lContinua := .F.
					Exit
				Endif
				
				IncRegua()
				//��������������������������������������������������������������Ŀ
				//� Considera filtro do usuario                                  �
				//����������������������������������������������������������������
				#IFDEF TOP
					If TcSrvType() != "AS/400"
						dbSelectArea("NEWSE1")
						dbGoto(SE1->RECNO)
					Endif
				#Endif
				
				If !Empty(cFilterUser).and.!(&cFilterUser)
					dbSelectArea("SE1")
					dbSkip()
					Loop
				Endif
				
				dbSelectArea("SE1")
				
				If !Fr340Skip("SE1")
					dbSelectArea("SE1")
					dbSkip()
					Loop
				EndIf
				
				#IFDEF TOP
					If TcSrvType() == "AS/400"
						dbSelectArea(cAliasSA1)
						dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
					Endif
				#ELSE
					dbSelectArea(cAliasSA1)
					dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				#ENDIF
				
				IF li > 58
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
				EndIF
				
				If nCont = 1
					@li,0 PSAY OemToAnsi(STR0015)+(cAliasSA1)->A1_COD+"-"+(cAliasSA1)->A1_LOJA+" "+IIF(mv_par15 == 1, (cAliasSA1)->A1_NOME,(cAliasSA1)->A1_NREDUZ)  //"CLIENTE : "
					Li+= 2
					nCont++
				Endif
				
				dbSelectArea("SE1")
				
				IF mv_par11 == 1
					dDataMoeda	:=	dDataBase
				Else
					dDataMoeda	:=	SE1->E1_VENCREA
				Endif
				
				// Indica se deve checar outras filiais
				lVerFil := (!Empty(xFilial("SE1")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1)
				
				aValor := Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,nMoeda,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA,,,,mv_par14 == 1)
				
				// Caso o titulo tenha baixa e a mesma nao conste para a filial corrente (vetor aValor acima), verifica se existem baixas em oturas filiais
				If lVerFil .And. !Empty(SE1->E1_BAIXA) .And. aValor[11] == 0
					F340VerBxFil( @aValor, aFiliais, nMoeda )
				EndIf
				
				If mv_par14 == 1
					nSaldo:=SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,nMoeda,dDataMoeda,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					// Verifica se existem compensacoes em outras filiais para descontar do saldo, pois a SaldoTit() verifica
					// somente as movimentacoes da filial corrente.
					If lVerFil .And. nSaldo > 0
						nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("R",SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,,aFiliais),;
						SE1->E1_MOEDA,mv_par10,dDataMoeda,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0) ),;
						nDecs+1),nDecs)
					EndIf
				Else
					nSaldo:=xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par10,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				Endif
				
				If SE1->E1_VALOR <> SE1->E1_VALLIQ .Or. SE1->(E1_CSLL+E1_COFINS+E1_PIS+E1_IRRF+E1_INSS) > 0
					nTotAbat := SomaAbat ( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, "R", nMoeda )
				Else
					nTotAbat := 0
				EndIf
				
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
					aValor[I_DESCONTO] += SE1->E1_DECRESC
					nSaldo -= SE1->E1_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					aValor[I_JUROS] += SE1->E1_ACRESC
					nSaldo += SE1->E1_ACRESC
				Endif
				
				If SE1->E1_SALDO > 0 .And. Empty(SE1->E1_BAIXA)
					aValor[I_JUROS] += SE1->E1_ACRESC
					aValor[I_DESCONTO] += SE1->E1_DECRESC
				Else
					aValor[I_JUROS] += SE1->E1_SDACRES
					aValor[I_DESCONTO] += SE1->E1_SDDECRE
				EndIf
				
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
					! ( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nSaldo -= nTotAbat
				EndIf
				
				Do Case
					Case SE1->E1_SITUACA $ "01234567"
						cSitCobr := aSituacao[Val(SE1->E1_SITUACA)+1]
					Case SE1->E1_SITUACA == "F"	//Carteira Protesto
						cSitCobr := aSituacao[9]
					Case SE1->E1_SITUACA == "G"	//Carteira Acordo
						cSitCobr := aSituacao[10]
					Case SE1->E1_SITUACA == "H"	//Cartorio
						cSitCobr := aSituacao[11]
					OtherWise
						cSitCobr := " "
				EndCase
				
				@li,  0 PSAY SE1->E1_PREFIXO+"-"+SE1->E1_NUM
				// Em ambiente Portugal, pula linha se utilizada numeracao de nota maior que 12 posicoes
				If cPaisLoc == "PTG" .And. TamSX3("E1_NUM")[1] > 12
					li++
				EndIf
				@li, 16 PSAY SE1->E1_PARCELA
				@li, 20 PSAY SE1->E1_TIPO
				
				@li, 24 PSAY SayValor(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),14,;
				alltrim(SE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,nDecs)
				
				@li, 39 PSAY SE1->E1_EMISSAO
				@li, 50 PSAY SE1->E1_VENCREA
				IF dDataBase >= SE1->E1_BAIXA .Or. (mv_par14 == 2 .And. !Empty(SE1->E1_BAIXA))
					@li, 61 PSAY IIF(!Empty(SE1->E1_BAIXA),SE1->E1_BAIXA," ")
				Endif
				@li, 72 PSAY aValor[I_DESCONTO]               Picture TM(aValor[I_DESCONTO]			 ,13,nDecs)
				@li, 85 PSAY nTotAbat                         Picture TM(nTotAbat					 ,13,nDecs)
				@li, 98 PSAY aValor[I_JUROS]                  Picture TM(aValor[I_JUROS]			 ,13,nDecs)
				@li,111 PSAY aValor[I_MULTA]                  Picture TM(aValor[I_MULTA]			 ,13,nDecs)
				@li,124 PSAY aValor[I_CORRECAO_MONETARIA]     Picture TM(aValor[I_CORRECAO_MONETARIA],13,nDecs)
				@li,138 PSAY aValor[I_VALOR_RECEBIDO]         Picture TM(aValor[I_VALOR_RECEBIDO]	  ,15,nDecs)
				@li,155 PSAY aValor[I_RECEB_ANT]              Picture TM(aValor[I_RECEB_ANT]		  ,13,nDecs)
				
				@li,169 PSAY SayValor(nSaldo,15,alltrim(SE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,nDecs)
				@li,186 PSAY Pad(aValor[I_MOTBX],15)
				@li,203 PSAY SUBSTR(cSitCobr,1,10)
				@li,214 PSAY SE1->E1_PORTADO
				
				If ! ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG )
					nTit1+= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit7+=aValor[I_VALOR_RECEBIDO]
					nTit9+=nSaldo
				Else
					nTit1-= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit7-=aValor[I_VALOR_RECEBIDO]
					nTit9-=nSaldo
				Endif
				
				nTit2+=aValor[I_DESCONTO]
				nTit3+=nTotAbat
				nTit4+=aValor[I_JUROS]
				nTit5+=aValor[I_MULTA]
				nTit6+=aValor[I_CORRECAO_MONETARIA]
				nTit8+=aValor[I_RECEB_ANT]
				
				If cPaisLoc<>"BRA"
					cMotivo:= SE1->E1_TIPO+"   "+ Substr(aValor[I_MOTBX],1,10)
					nvalor:=xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nPos := aScan(aMotBx,{|X| x[1]== cMotivo})
					
					If nPos > 0
						aMotBx[nPos][2]+= nvalor
					else
						Aadd(aMotBx,{cMotivo,nvalor})
					Endif
				Endif
				dbSelectArea("SE1")
				dbSkip()
				li++
			Enddo
			
			If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9) > 0 )
				ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9,nDecs)
				li++
				nTot1 += nTit1
				nTot2 += nTit2
				nTot3 += nTit3
				nTot4 += nTit4
				nTot5 += nTit5
				nTot6 += nTit6
				nTot7 += nTit7
				nTot8 += nTit8
				nTot9 += nTit9
				
				nTotFil1 += nTit1
				nTotFil2 += nTit2
				nTotFil3 += nTit3
				nTotFil4 += nTit4
				nTotFil5 += nTit5
				nTotFil6 += nTit6
				nTotFil7 += nTit7
				nTotFil8 += nTit8
				nTotFil9 += nTit9
			Endif
		Enddo
		
		SE1->(DbCloseArea())
		
		//����������������������������������������Ŀ
		//� Imprimir TOTAL por filial somente quan-�
		//� do houver mais do que 1 filial.        �
		//������������������������������������������
		if mv_par20 == 1 .and. Len( aSM0 ) > 1
			ImpFil340(nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nDecs)
		Endif
		Store 0 To nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9
		If Empty(xFilial("SE1"))
			Exit
		Endif
	EndIf
Next

cFilAnt := cFilOld

IF li > 55 .and. li != 80
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
End

IF li != 80
	If cPaisLoc<>"BRA"
		ImpTotG(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,aMotBx,nDecs)
	else
		ImpTotG(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,,nDecs)
	Endif
	roda(cbcont,cbtxt,tamanho)
EndIF

Set Device TO Screen

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		If Select("NEWSE1") > 0
			dbSelectArea("NEWSE1")
			dbCloseArea()
		Endif
		dbSelectArea("SE1")
		dbCloseArea()
		ChkFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	else
		dbSelectArea("SE1")
		dbClearFil()
		RetIndex( "SE1" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpSubTot � Autor � Paulo Boschetti       � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao da Linha de SubTotal do Relatorio                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpSubTot()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9,nDecs)

li++
@li,  0 PSAY OemToAnsi(STR0016)  //"Totais : "
@li,021 PSAY nTit1   Picture TM(nTit1,17,nDecs)
@li,072 PSAY nTit2   Picture TM(nTit2,13,nDecs)
@li,085 PSAY nTit3   Picture TM(nTit3,13,nDecs)
@li,098 PSAY nTit4   Picture TM(nTit4,13,nDecs)
@li,111 PSAY nTit5   Picture TM(nTit5,13,nDecs)
@li,124 PSAY nTit6   Picture TM(nTit6,13,nDecs)
@li,138 PSAY nTit7   Picture TM(nTit7,15,nDecs)
@li,155 PSAY nTit8   Picture TM(nTit8,13,nDecs)
@li,169 PSAY nTit9   Picture TM(nTit9,15,nDecs)
li++
@li,000 PSAY Replicate("-",220)
li++
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpTotg  � Autor � Paulo Boschetti       � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao da linha de Total                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpTotG()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpTotg(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,aMotBx,nDecs)
Local ntotaltipo:=0
Local cTipoant:=" "
Local i
li++
@li,0 PSAY OemToAnsi(STR0017)  //"TOTAL GERAL : "
@li,021 PSAY nTot1   Picture TM(nTot1,17,nDecs)
@li,072 PSAY nTot2   Picture TM(nTot2,13,nDecs)
@li,085 PSAY nTot3   Picture TM(nTot3,13,nDecs)
@li,098 PSAY nTot4   Picture TM(nTot4,13,nDecs)
@li,111 PSAY nTot5   Picture TM(nTot5,13,nDecs)
@li,124 PSAY nTot6   Picture TM(nTot6,13,nDecs)
@li,138 PSAY nTot7   Picture TM(nTot7,15,nDecs)
@li,155 PSAY nTot8   Picture TM(nTot8,13,nDecs)
@li,169 PSAY nTot9   Picture TM(nTot9,15,nDecs)
li++

If cPaisLoc<>"BRA"
	@li,0 PSAY OemToAnsi(STR0027)     //"TOTAL POR MOTIVO : "
	li:=li+2
	
	aMotBX:=asort(aMotBX,,,{|x,y| x[1] < y[1]})
	For i:=1 to Len(aMotBx)
		If cTipoant==" "
			cTipoant:=subs(aMotBX[i][1],1,3)
		Endif
		If  ctipoant	== subs(aMotBX[i][1],1,3)
			@ Li,001 PSAY aMotBX[i] [1]
			@ Li,025 PSAY aMotBX[i] [2] Picture PesqPict("SE1","E1_VALOR",17,MV_PAR10)
			ntotaltipo += aMotBX[i] [2]
			ctipoant:=subs(aMotBX[i][1],1,3)
		else
			@ Li,001 PSAY OemToAnsi(STR0016) + ctipoant
			@ Li,025 PSAY ntotaltipo PicTure PesqPict("SE1","E1_VALOR",17,MV_PAR10)
			ntotaltipo:=0
			li:=li+2
			@ Li,001 PSAY aMotBX[i] [1]
			@ Li,025 PSAY aMotBX[i] [2] Picture PesqPict("SE1","E1_VALOR",17,MV_PAR10)
			ntotaltipo += aMotBX[i] [2]
			ctipoant:=subs(aMotBX[i][1],1,3)
		Endif
		IF li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		End
		Li++
	Next i
	@ Li,001 PSAY OemToAnsi(STR0016) + ctipoant
	@ Li,025 PSAY ntotaltipo PicTure PesqPict("SE1","E1_VALOR",17,MV_PAR10)
Endif
Return(.T.)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �FR340FIL  � Autor � Andreia           	� Data � 11.01.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Monta Indregua para impressao do relat�rio				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FR340FIL()
Local cString

cString := 'E1_FILIAL="'+xFilial()+'".And.'
cString += 'dtos(E1_EMISSAO)>="'+dtos(mv_par05)+'".and.dtos(E1_EMISSAO)<="'+dtos(mv_par06)+'".And.'
cString += 'dtos(E1_VENCREA)>="'+dtos(mv_par07)+'".and.dtos(E1_VENCREA)<="'+dtos(mv_par08)+'".And.'
cString += 'E1_CLIENTE>="'+mv_par01+'".and.E1_CLIENTE<="'+mv_par02+'".And.'
cString += 'E1_LOJA>="'+mv_par03+'".and.E1_LOJA<="'+mv_par04+'".and.'
cString += 'E1_NATUREZ>="'+mv_par16+'".and.E1_NATUREZ<="'+mv_par17+'"'
If cPaisLoc<>"BRA"
	cString +='.and. !(E1_TIPO$"TF~CH")'
EndIf

Return cString

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �SayValor  � Autor � J�lio Wittwer    	    � Data � 24.06.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna String de valor entre () caso Valor < 0			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINR340.PRX												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SayValor(nNum,nTam,lInvert,nDecs)
Local cPicture,cRetorno
cPicture := tm(nNum,nTam,nDecs)
cRetorno := Transform(nNum,cPicture)
IF nNum<0 .or. lInvert
	cPicture := tm(nNum,nTam-2,nDecs)
	cRetorno := Transform(nNum,cPicture)
	cRetorno := Right(Space(10)+"("+Alltrim(StrTran(cRetorno,"-",""))+")",nTam+1)
Endif
Return cRetorno

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Fr340Skip � Autor � Pilar S. Albaladejo	� Data � 13.10.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINR340.PRX												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fr340Skip()

Local lRet := .T.
//��������������������������������������������������������������Ŀ
//� Verifica se esta dentro dos parametros                       �
//����������������������������������������������������������������
IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
	SE1->E1_LOJA    < mv_par03 .OR. SE1->E1_LOJA    > mv_par04 .OR. ;
	SE1->E1_EMISSAO < mv_par05 .OR. SE1->E1_EMISSAO > mv_par06 .OR. ;
	SE1->E1_VENCREA < mv_par07 .OR. SE1->E1_VENCREA > mv_par08 .OR. ;
	SE1->E1_NATUREZ < mv_par16 .OR. SE1->E1_NATUREZ > mv_par17 .OR. ;
	SE1->E1_TIPO $ MVABATIM
	lRet := .F.
	
ElseIF SE1->E1_EMISSAO > dDataBase
	lRet := .F.
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se o t�tulo � provis�rio                            �
	//����������������������������������������������������������������
ElseIf (SE1->E1_TIPO $ MVPROVIS .and. mv_par09==2)
	lRet := .F.
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se o t�tulo foi aglutinado em uma fatura            �
	//����������������������������������������������������������������
ElseIf !Empty(SE1->E1_FATURA) .and. Substr(SE1->E1_FATURA,1,6) != "NOTFAT"
	lRet := IIF(mv_par12 == 1, .T., .F.)	// Considera Faturados = mv_par12
	//����������������������������������������Ŀ
	//� Verifica se deve imprimir outras moedas�
	//������������������������������������������
Elseif mv_par13 == 2 // nao imprime
	If SE1->E1_MOEDA != mv_par10 //verifica moeda do campo=moeda parametro
		lRet	:= .F.
	Endif
Endif

Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � ImpFil340� Autor � Adrianne Furtado 	  	� Data � 27.10.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir total do relatorio										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpFil340()																  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�																				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	    � Generico																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function ImpFil340(nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nDecs)
DEFAULT nDecs := Msdecimais(mv_par15)

li--
IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
EndIF

@li,000 PSAY OemToAnsi(STR0056)+" "+Iif(mv_par20==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")  //"T O T A L   F I L I A L ----> "
@li,050 PSAY nTotFil1 Picture TM(nTotFil1,14,nDecs)
@li,075 PSAY nTotFil2 Picture TM(nTotFil2,10,nDecs)
@li,088 PSAY nTotFil3 Picture TM(nTotFil3,10,nDecs)
@li,101 PSAY nTotFil4 Picture TM(nTotFil4,10,nDecs)
@li,114 PSAY nTotFil5 Picture TM(nTotFil5,10,nDecs)
@li,127 PSAY nTotFil6 Picture TM(nTotFil6,10,nDecs)
@li,143 PSAY nTotFil7 Picture TM(nTotFil7,10,nDecs)
@li,158 PSAY nTotFil8 Picture TM(nTotFil8,10,nDecs)
@li,174 PSAY nTotFil9 Picture TM(nTotFil9,10,nDecs)
li++
@li,000 PSAY Replicate("-",220)
li+=2
Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F340VerBxFil �Autor � Gustavo Henrique � Data �  21/04/09  ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica se existem baixas em outras filiais para o titulo ���
���          � posicionado para impressao.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro - Relatorio Posicao Clientes                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F340VerBxFil( aValor, aFiliais, nMoeda )

Local aTmpValor := {}
Local nX		:= 0
Local nY		:= 0

// Pesquisa baixas do titulo em outras filiais
For nX := 1 To Len(aFiliais)
	If aFiliais[nX] <> SE1->E1_FILIAL
		AAdd( aTmpValor, Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,nMoeda,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA,aFiliais[nX],,,mv_par14 == 1) )
	EndIf
Next nX

// Atualiza valores das baixas em outras filiais no vetor definitivo aValor
For nX := 1 To Len(aTmpValor)
	For nY := 1 To Len(aValor)
		If nY <> 9	// Nao soma historico de baixa
			aValor[nY] += aTmpValor[nX,nY]
		EndIf
	Next nY
Next nX

// Para impressao, guarda o historico da primeira baixa encontrada
aValor[9] := aTmpValor[1,9]

Return( aValor )

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
Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )

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
