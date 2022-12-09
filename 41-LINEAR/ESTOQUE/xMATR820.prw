#INCLUDE "MATR820.CH"
#INCLUDE "FIVEWIN.CH"

Static cAliasTop

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR820  � Autor � Felipe Nunes Toledo   � Data � 26/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ordens de Producao                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function zMATR820()
Local oReport

//-- Checa versao do programa PCPXFUN
/*If !(FindFunction("PCPXFUN_V") .and. PCPXFUN_V() >= 20070105)
	Final(STR0054) //"Atualizar PCPXFUN.PRX!!!"
EndIf*/ 

//-- Verifica se o SH8 esta locado para atualizacao por outro processo                
If !IsLockSH8()
	
	If FindFunction("TRepInUse") .And. TRepInUse()
		//������������������������������������������������������������������������Ŀ
		//�Interface de impressao                                                  �
		//��������������������������������������������������������������������������
		oReport:= ReportDef()
		If !oReport:PrintDialog()
	   		dbSelectArea("SH8")
			dbClearFilter()
			dbCloseArea()
			Return Nil
		EndIf
	Else
		MATR820R3()
	EndIf

EndIf
	
Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Felipe Nunes Toledo    � Data �27/09/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR820                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local oReport
Local oSection1, oSection2, Section3
Local aOrdem	:= {STR0002,STR0003,STR0004,STR0005}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Local cTitle	:= STR0039 //"Ordens de Producao"

#IFDEF TOP
	cAliasTop := GetNextAlias()
#ELSE
	cAliasTop := "SC2"
#ENDIF

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
oReport:= TReport():New("XMATR820",cTitle,"MTR820", {|oReport| ReportPrint(oReport, cAliasTop)},OemToAnsi(STR0001)) //"Este programa ira imprimir a Rela��o das Ordens de Produ��o"
oReport:SetPortrait()     // Define a orientacao de pagina do relatorio como retrato.
oReport:HideParamPage()   // Desabilita a impressao da pagina de parametros.
oReport:nFontBody	:= 10 // Define o tamanho da fonte.
oReport:nLineHeight	:= 50 // Define a altura da linha.
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas - MTR820                  �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Da OP                                 �
//� mv_par02            // Ate a OP                              �
//� mv_par03            // Da data                               �
//� mv_par04            // Ate a data                            �
//� mv_par05            // Imprime roteiro de operacoes          �
//� mv_par06            // Imprime codigo de barras              �
//� mv_par07            // Imprime Nome Cientifico               �
//� mv_par08            // Imprime Op Encerrada                  �
//� mv_par09            // Impr. por Ordem de                    �
//� mv_par10            // Impr. OP's Firmes, Previstas ou Ambas �
//� mv_par11            // Impr. Item Negativo na Estrutura      �
//����������������������������������������������������������������
Pergunte(oReport:GetParam(),.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da secao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a secao.                   �
//�ExpA4 : Array com as Ordens do relatorio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oSection1)                                         �
//����������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0050,{"SC2","SB1","SC5","SA1"},aOrdem) // "Ordens de Produ��o"
oSection1:SetLineStyle() //Define a impressao da secao em linha

TRCell():New(oSection1,'C2_PRODUTO'	,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'Emissao'   	,'SC2',STR0040   ,PesqPict("SC2","C2_DATPRI"),TamSX3("C2_DATPRI")[1],/*lPixel*/,{|| dDataBase })
TRCell():New(oSection1,'C5_CLIENTE'	,'SC5',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C5_LOJACLI'	,'SC5',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'A1_NOME'  	,'SA1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'QtdeProd'	,'SC2',STR0041   ,PesqPict("SC2","C2_QUANT"),TamSX3("C2_QUANT")[1],/*lPixel*/,{|| aSC2Sld(cAliasTop) })
TRCell():New(oSection1,'C2_QUANT'	,'SC2',STR0042   ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'OpQuant'  	,'SC2',STR0043   ,PesqPict("SC2","C2_QUANT"),TamSX3("C2_QUANT")[1],/*lPixel*/,{|| (cAliasTop)->C2_QUANT - (cAliasTop)->C2_QUJE })
TRCell():New(oSection1,'B1_UM'	 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_CC'		,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_STATUS'	,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_DATPRI'	,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_DATPRF'	,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_DATAJI'	,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_DATAJF'	,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'RealIni'	,'SC2',STR0044   ,'@!',8,/*lPixel*/,{|| "__/__/__" })
TRCell():New(oSection1,'RealFim'	,'SC2',STR0045   ,'@!',8,/*lPixel*/,{|| "__/__/__" })
TRCell():New(oSection1,'C2_OBS'		,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection1:Cell('B1_DESC'  ):SetCellBreak()
oSection1:Cell('Emissao'  ):SetCellBreak()
oSection1:Cell('A1_NOME'  ):SetCellBreak()
oSection1:Cell('C2_QUANT' ):SetCellBreak()
oSection1:Cell('OpQuant'  ):SetCellBreak()
oSection1:Cell('B1_UM'    ):SetCellBreak()
oSection1:Cell('C2_CC'    ):SetCellBreak()
oSection1:Cell('C2_STATUS'):SetCellBreak()
oSection1:Cell('C2_DATPRF'):SetCellBreak()
oSection1:Cell('C2_DATAJF'):SetCellBreak()
oSection1:Cell('RealFim'  ):SetCellBreak()

//��������������������������������������������������������������Ŀ
//� Sessao 2 (oSection2)                                         �
//����������������������������������������������������������������
oSection2 := TRSection():New(oSection1,STR0051,{"SD4","SB1"},/*Ordem*/) //"Empenhos"
oSection2:SetHeaderBreak()

TRCell():New(oSection2,'D4_COD'	 	,'SD4',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_DESC' 	,'SB1',/*Titulo*/,/*Picture*/, 28        ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'D4_QUANT' 	,'SD4',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B1_UM'   	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'D4_LOCAL'	,'SD4',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'B2_LOCALIZ'	,'SB2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'D4_TRT'  	,'SD4',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'D4_OP'  	,'SD4',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

//��������������������������������������������������������������Ŀ
//� Sessao 3 (oSection3)                                         �
//����������������������������������������������������������������
oSection3 := TRSection():New(oSection1,STR0052,{"SG2","SH8","SH1","SH4"},/*Ordem*/) //"Opera��es"

TRCell():New(oSection3,'G2_RECURSO'	,'SG2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'H1_DESCRI'	,'SH1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'G2_FERRAM'	,'SG2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'H4_DESCRI'	,'SH4',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'G2_OPERAC'	,'SG2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'G2_DESCRI'	,'SG2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection3:Cell('H1_DESCRI'):HideHeader()
oSection3:Cell('H4_DESCRI'):HideHeader()
oSection3:Cell('G2_DESCRI'):HideHeader()

//��������������������������������������������������������������Ŀ
//� Sessao 4 (oSection4)                                         �
//����������������������������������������������������������������
oSection4 := TRSection():New(oSection3,STR0053,{"SG2","SH8","SH1","SH4"},/*Ordem*/) //"Tempo Rot. Oper."
oSection4:SetLineStyle() //Define a impressao da secao em linha

TRCell():New(oSection4,'H8_DTINI'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'H8_HRINI'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'H8_DTFIM'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'H8_HRFIM'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'IniAloc'	,'SH8',STR0046   ,'@!'  , 24        ,/*lPixel*/,{|| " ____/ ____/____ ___:___" })
TRCell():New(oSection4,'FimAloc'	,'SH8',STR0047   ,'@!'  , 24        ,/*lPixel*/,{|| " ____/ ____/____ ___:___" })
TRCell():New(oSection4,'H8_QUANT'	,'SH8',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,'QtdeProd'	,'SH8',STR0048   ,/*Picture*/, 12       ,/*lPixel*/,{|| Space(12) })
TRCell():New(oSection4,'QtdPerda'	,'SH8',STR0049   ,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| Space(12) })

oSection4:Cell('H8_HRFIM'):SetCellBreak()
oSection4:Cell('FimAloc' ):SetCellBreak()

oSection1:SetNoFilter({"SA1","SC5"})
oSection2:SetNoFilter({"SD4","SB1","SB2","SC2"})
oSection3:SetNoFilter({"SG2","SH8","SH1","SH4"})
oSection4:SetNoFilter({"SG2","SH8","SH1","SH4"})

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Felipe Nunes Toledo  � Data �27/09/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR820                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport, cAliasTop)
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(2)
Local oSection4	:= oReport:Section(1):Section(2):Section(1)
Local nOrdem    := oSection1:GetOrder()
Local oBreak
Local cIndex	:= ""
Local cCondicao	:= ""
Local cCode    	:= ""
Local nCntFor   := 0
Local nLinBar	:= 0
Local cWhere01, cWhere02, cWhere03, cWhere04, cWhere05, cWhere06, cWhere07, cWhere08, cWhere09
Local cOrderBy
Private aArray	 := {}
Private lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1

// Definindo quebra para secao 2 e ocultando celula utilizada somente para quebra
oBreak := TRBreak():New(oSection2,oSection2:Cell("D4_OP"),Nil,.F.)
oSection2:Cell("D4_OP"):HideHeader()
oSection2:Cell("D4_OP"):Hide()

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP

   	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:GetParam())
	
	//��������������������������������������������������������������Ŀ
	//� Condicao Where para filtrar OP's                             �
	//����������������������������������������������������������������
	cWhere01 := "%'"+Left(mv_par01,6)+"'%"
	cWhere02 := "%'"+Substr(mv_par01,7,2)+"'%"
	cWhere03 := "%'"+Substr(mv_par01,9,3)+"'%"
	cWhere04 := "%'"+SubStr(mv_par01,12,2)+"'%"

	cWhere05 := "%'"+Left(mv_par02,6)+"'%"
	cWhere06 := "%'"+Substr(mv_par02,7,2)+"'%"
	cWhere07 := "%'"+Substr(mv_par02,9,3)+"'%"
	cWhere08 := "%'"+SubStr(mv_par02,12,2)+"'%"
	
	cWhere09 := "%"
	If mv_par08 == 2
		cWhere09 += "AND SC2.C2_DATRF = ' '"
	Endif
	cWhere09 += "%"
	
	cOrderBy := "%"
	If nOrdem == 4
		cOrderBy += "SC2.C2_FILIAL, SC2.C2_DATPRF"
	Else                                  
		cOrderBy += SqlOrder(SC2->(IndexKey(nOrdem)))
	EndIf
	cOrderBy += "%"

	//������������������������������������������������������������������������Ŀ
	//�Query do relatorio da secao 1                                           �
	//��������������������������������������������������������������������������
	oSection1:BeginQuery()	
	BeginSql Alias cAliasTop

	SELECT SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF,
	       SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE,
	       SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF,
	       SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP, 
	       SC2.C2_DESCCLI, SC2.C2_MAQUINA, SC2.C2_CICLO, SC2.C2_CAVIDAD, SC2.C2_MOLDE, SC2.C2_PESO, SC2.C2_COR,
	       SC2.C2_UTILIZA, SC2.C2_CODCLI,
	       SC2.R_E_C_N_O_  SC2RECNO
	
	FROM %table:SC2% SC2
	
	WHERE SC2.C2_FILIAL = %xFilial:SC2% AND
		  SC2.C2_NUM >= %Exp:cWhere01% AND
		  SC2.C2_ITEM >= %Exp:cWhere02% AND
		  SC2.C2_SEQUEN >= %Exp:cWhere03% AND
		  SC2.C2_ITEMGRD >= %Exp:cWhere04% AND
	      SC2.C2_NUM <= %Exp:cWhere05% AND
	      SC2.C2_ITEM <= %Exp:cWhere06% AND
	      SC2.C2_SEQUEN <= %Exp:cWhere07% AND
          SC2.C2_ITEMGRD <= %Exp:cWhere08% AND
	      SC2.C2_DATPRF BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND
		  SC2.%NotDel%
		  %Exp:cWhere09%
	
	ORDER BY %Exp:cOrderby%
	
	EndSql
	oSection1:EndQuery()
	
#ELSE
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao ADVPL                          �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:GetParam())

	dbSelectArea(cAliasTop)
	
	If nOrdem == 4
		cIndex := "C2_FILIAL+DTOS(C2_DATPRF)"
	Else
		dbSetOrder(nOrdem)
	EndIf

	cCondicao := "C2_FILIAL=='"+xFilial("SC2")+"'"
	cCondicao += ".And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD>='"+mv_par01+"'"
	cCondicao += ".And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD<='"+mv_par02+"'"
	cCondicao += ".And.DTOS(C2_DATPRF)>='"+DTOS(mv_par03)+"'"
	cCondicao += ".And.DTOS(C2_DATPRF)<='"+DTOS(mv_par04)+"'"
	If mv_par08 == 2
		cCondicao += ".And.Empty(C2_DATRF)"
	EndIf

	oReport:Section(1):SetFilter(cCondicao,If(nOrdem==4,cIndex,IndexKey()))
#ENDIF
//��������������������������Ŀ
//�Posicionamento das tabelas�
//����������������������������
TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1")+(cAliasTop)->C2_PRODUTO })
TRPosition():New(oSection1,"SC5",1,{|| xFilial("SC5")+(cAliasTop)->C2_PEDIDO })
TRPosition():New(oSection1,"SA1",1,{|| xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI })

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������
oReport:SetMeter(SC2->(LastRec()))
oSection1:Init()
oSection2:Init()
oSection3:Init()
oSection4:Init()
dbSelectArea(cAliasTop)
While !oReport:Cancel() .And. !(cAliasTop)->(Eof())
	//-- Valida se a OP deve ser Impressa ou nao
	If !MtrAValOP(mv_par10,"SC2",cAliasTop)
		dbSkip()
		Loop
	EndIf    
	
	//Definindo a descricao do produto
	MR820Desc(oReport, cAliasTop)

	//���������������������������������������������������������Ŀ
	//� Desabilitando celulas que nao deverao serem impressas   �
	//�����������������������������������������������������������
	If (cAliasTop)->C2_DESTINA <> "P"
    	oSection1:Cell('C5_CLIENTE'):Disable()
    	oSection1:Cell('C5_LOJACLI'):Disable()
    	oSection1:Cell('A1_NOME'   ):Disable()
 	EndIf
	If Empty((cAliasTop)->C2_STATUS)
		oSection1:Cell("C2_STATUS"):SetValue("Normal")
	EndIf
	If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
		oSection1:Cell('OpQuant'):Disable()
	Else
		oSection1:Cell('QtdeProd'):Disable()
		oSection1:Cell('C2_QUANT'):Disable()
	Endif
	If (Empty((cAliasTop)->C2_OBS))
		oSection1:Cell('C2_OBS'):Disable()	
	EndIf

	//�������������������������������Ŀ
	//�Definindo o titulo do Relatorio�
	//���������������������������������
	oReport:SetTitle(STR0010+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)) //"        O R D E M   D E   P R O D U C A O       NRO :"

	If mv_par06 == 1 
		nLinBar := 0.95
		
		oReport:PrintText("")
		For nCntFor := 1 to 5
			oReport:SkipLine()
		Next nCntFor

		cCode := (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
		If oReport:lHeaderVisible
			nLinBar += 1
		Else
			nLinBar -= 0.2
		EndIf
		If oReport:GetOrientation()== 1
			nLinBar += 0.2
		EndIf
		MSBAR3("CODE128",nLinBar,0.5,Trim(cCode),@oReport:oPrint,Nil,Nil,Nil,Nil ,1.5 ,Nil,Nil,Nil,.F.)
	EndIf
	
	//Impressao da Section 1
	oSection1:PrintLine()
	oReport:IncMeter()

	//���������������������
	//�Habilitando celulas�
	//���������������������
	If (cAliasTop)->C2_DESTINA <> "P"
    	oSection1:Cell('C5_CLIENTE'):Enable()
    	oSection1:Cell('C5_LOJACLI'):Enable()
    	oSection1:Cell('A1_NOME'   ):Enable()
 	EndIf
	If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
		oSection1:Cell('OpQuant'):Enable()
	Else
		oSection1:Cell('QtdeProd'):Enable()
		oSection1:Cell('C2_QUANT'):Enable()
	Endif
	If (Empty((cAliasTop)->C2_OBS))
		oSection1:Cell('C2_OBS'):Enable()	
	EndIf
	
	//--- Inicio fluxo impressao secao 2
	SB1->(dbSeek(xFilial("SB1")+(cAliasTop)->C2_PRODUTO))
	
	aArray := {}
	MontStruc((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))
	
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	ENDIF
	                         
	For nCntFor := 1 TO Len(aArray)

	    SB1->(dbSetOrder(1))
	    SB1->(MsSeek(xFilial("SB1")+aArray[nCntFor][1]))

	    SD4->(dbSetOrder(2))
	    SD4->(MsSeek(xFilial("SD4")+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+aArray[nCntFor][1]+aArray[nCntFor][6]))

		oSection2:Cell("D4_COD"    ):SetValue(aArray[nCntFor][1])
		oSection2:Cell("B1_DESC"   ):SetValue(aArray[nCntFor][2])
		oSection2:Cell("D4_QUANT"  ):SetValue(aArray[nCntFor][5])
		oSection2:Cell("B1_UM"     ):SetValue(aArray[nCntFor][4])
		oSection2:Cell("D4_LOCAL"  ):SetValue(aArray[nCntFor][6])
		oSection2:Cell("B2_LOCALIZ"):SetValue(aArray[nCntFor][7])
		oSection2:Cell("D4_TRT"    ):SetValue(aArray[nCntFor][8])
		oSection2:Cell("D4_OP"     ):SetValue((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))

	    //Impressao da Section 2
		oSection2:PrintLine()
	Next nCntFor
	
	If mv_par05 == 1
		Mr820Ope(oReport, cAliasTop) //Impressao da Section 3 e Section 4
	EndIf

	oReport:EndPage() //-- Salta Pagina
	dbSelectArea(cAliasTop)
	dbSkip()

EndDo

oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()
(cAliasTop)->(DbCloseArea())
dbSelectArea("SH8")
dbClearFilter()
dbCloseArea()

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MR820Desc   � Autor �Felipe Nunes Toledo  � Data �28/09/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atribui a descricao do produto conforme opcao selecionada   ���
���          �no parametro mv_par07 (Descricao do Produto ?).             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �ExpC1: Alias do arquivo Ordem de Producao                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR820                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MR820Desc(oReport, cAliasTop)
Local oSection1 := oReport:Section(1)
Local lSB1Desc 	:= .T.
 
If mv_par07 == 1
	SB5->(dbSetOrder(1))
	If SB5->(dbSeek(xFilial("SB5")+(cAliasTop)->C2_PRODUTO) .And. !Empty(B5_CEME))
		oSection1:Cell("B1_DESC"):GetFieldInfo("B5_CEME")
		oSection1:Cell("B1_DESC"):SetValue(SB5->B5_CEME)
		lSB1Desc := .F.		
	EndIf
ElseIf mv_par07 == 3
	If (cAliasTop)->C2_DESTINA == "P"
		SC6->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial("SC6")+(cAliasTop)->C2_PEDIDO+(cAliasTop)->C2_ITEM))
			If !Empty(SC6->C6_DESCRI) .and. SC6->C6_PRODUTO == (cAliasTop)->C2_PRODUTO
				oSection1:Cell("B1_DESC"):GetFieldInfo("C6_DESCRI")
				oSection1:Cell("B1_DESC"):SetValue(SC6->C6_DESCRI)
				lSB1Desc := .F.
			EndIf
		EndIf
	EndIf
EndIf

If (mv_par07 <> 2) .And. lSB1Desc
	SB1->(dbSetOrder(1))
	If SB1->( dbSeek(xFilial("SB1")+(cAliasTop)->C2_PRODUTO) )
		oSection1:Cell("B1_DESC"):GetFieldInfo("B1_DESC")
		oSection1:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
	EndIf
EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � Mr820Ope � Autor � Felipe Nunes Toledo   � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � Mr820Ope()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function Mr820Ope(oReport, cAliasTop)
Local oSection3 := oReport:Section(1):Section(2)
Local oSection4	:= oReport:Section(1):Section(2):Section(1)
Local cRoteiro	:= ""
Local lSH8 		:= .F.
Local aArea   	:= GetArea()

//�����������������������������������������������������������Ŀ
//� Verifica se imprime ROTEIRO da OP ou PADRAO do produto    �
//�������������������������������������������������������������
If !Empty((cAliasTop)->C2_ROTEIRO)
	cRoteiro:=(cAliasTop)->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		If SG2->(dbSeek(xFilial("SG2")+(cAliasTop)->C2_PRODUTO+"01"))
			dbSelectArea("SB1")
			RecLock("SB1",.F.)
			Replace B1_OPERPAD With "01"
			MsUnLock()
			cRoteiro:="01"
		EndIf
	EndIf
EndIf

If SG2->(dbSeek(xFilial("SG2")+(cAliasTop)->C2_PRODUTO+cRoteiro))
	While SG2->(!Eof()) .And. SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO) = xFilial("SG2")+(cAliasTop)->C2_PRODUTO+cRoteiro
		SH8->(dbSetOrder(1))
		If SH8->(dbSeek(xFilial("SH8")+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC))
			lSH8 := .T.
		EndIf
		
		If lSH8
			While SH8->(!Eof()) .And. SH8->(H8_FILIAL+H8_OP+H8_OPER) == xFilial("SH8")+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC
				SH1->(dbSeek(xFilial("SH1")+SH8->H8_RECURSO))
				SH4->(dbSeek(xFilial("SH4")+SG2->G2_FERRAM))
				
				oSection3:Cell('G2_RECURSO'):SetValue(SH8->H8_RECURSO)
				oSection3:Cell('H1_DESCRI' ):SetValue(SH1->H1_DESCRI)
				oSection3:Cell('G2_FERRAM' ):SetValue(SG2->G2_FERRAM)
				oSection3:Cell('H4_DESCRI' ):SetValue(SH4->H4_DESCRI)
				oSection3:Cell('G2_OPERAC' ):SetValue(SG2->G2_OPERAC)
				oSection3:Cell('G2_DESCRI' ):SetValue(SG2->G2_DESCRI)

				oSection3:PrintLine()
				oSection4:PrintLine()
				oReport:ThinLine()
				SH8->(dbSkip())
			EndDo
		Else
			SH1->(dbSeek(xFilial("SH1")+SG2->G2_RECURSO))
			SH4->(dbSeek(xFilial("SH4")+SG2->G2_FERRAM))
		
			oSection3:Cell('G2_RECURSO'):SetValue(SG2->G2_RECURSO)
			oSection3:Cell('H1_DESCRI' ):SetValue(SH1->H1_DESCRI)
			oSection3:Cell('G2_FERRAM' ):SetValue(SG2->G2_FERRAM)
			oSection3:Cell('H4_DESCRI' ):SetValue(SH4->H4_DESCRI)
			oSection3:Cell('G2_OPERAC' ):SetValue(SG2->G2_OPERAC)
			oSection3:Cell('G2_DESCRI' ):SetValue(SG2->G2_DESCRI)
			oSection3:PrintLine()
			
			oSection4:Cell('H8_DTINI'):Disable()
			oSection4:Cell('H8_HRINI'):Disable()
			oSection4:Cell('H8_DTFIM'):Disable()
			oSection4:Cell('H8_HRFIM'):Disable()
			oSection4:Cell('H8_QUANT'):SetValue(aSC2Sld(cAliasTop))
			oSection4:PrintLine()
			oReport:ThinLine()

			oSection4:Cell('H8_DTINI'):Enable()
			oSection4:Cell('H8_HRINI'):Enable()
			oSection4:Cell('H8_DTFIM'):Enable()
			oSection4:Cell('H8_HRFIM'):Enable()
		Endif
		SG2->(dbSkip())
	EndDo
Endif

RestArea(aArea)
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR820  � Autor � Paulo Boschetti       � Data � 07.07.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ordens de Producao                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR820(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function MATR820R3()
Local titulo  := STR0039 //"Ordens de Producao"
Local cString := "SC2"
Local wnrel   := "MATR820"
Local cDesc   := STR0001	//"Este programa ira imprimir a Rela��o das Ordens de Produ��o"
Local aOrd    := {STR0002,STR0003,STR0004,STR0005}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Local tamanho := "M"

Private aReturn  := {STR0006,1,STR0007, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg    :="MTR820"
Private nLastKey := 0
Private lItemNeg := .F.

//-- Checa versao do programa PCPXFUN
/*If !(FindFunction("PCPXFUN_V") .and. PCPXFUN_V() >= 20070105)
	Final(STR0054) //"Atualizar PCPXFUN.PRX!!!"
EndIf*/

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("MTR820",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Da OP                                 �
//� mv_par02            // Ate a OP                              �
//� mv_par03            // Da data                               �
//� mv_par04            // Ate a data                            �
//� mv_par05            // Imprime roteiro de operacoes          �
//� mv_par06            // Imprime codigo de barras              �
//� mv_par07            // Imprime Nome Cientifico               �
//� mv_par08            // Imprime Op Encerrada                  �
//� mv_par09            // Impr. por Ordem de                    �
//� mv_par10            // Impr. OP's Firmes, Previstas ou Ambas �
//� mv_par11            // Impr. Item Negativo na Estrutura      �
//����������������������������������������������������������������
//-- Verifica se o SH8 esta locado para atualizacao por outro processo                
If !IsLockSH8()
	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SETPRINT                        �
	//����������������������������������������������������������������
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,.F.,Tamanho)
	
	lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1
	
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif
	
	RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

EndIf
	
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R820Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local CbCont,cabec1,cabec2
Local limite     := 80
Local nQuant     := 1
Local nomeprog   := "MATR820"
Local nTipo      := 18
Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
Local cQtd,i,nBegin
Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2

#IFDEF TOP
	Local bBlockFiltro := {|| .T.}
#ENDIF	

Private aArray   := {}
Private li       := 80
Private _nLin    := Li
Private _nOP     := ""

cAliasTop  := "SC2"

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 0
//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
cabec1 := ""
cabec2 := ""

dbSelectArea("SC2")

#IFDEF TOP
	cAliasTop := GetNextAlias()
	cQuery := "SELECT SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF, "
	cQuery += "SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE, "
	cQuery += "SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF, "
	cQuery += "SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP,"
	cQuery += "SC2.C2_DESCCLI, SC2.C2_MAQUINA, SC2.C2_CICLO, SC2.C2_CAVIDAD, SC2.C2_MOLDE, SC2.C2_PESO, SC2.C2_COR,"
	cQuery += "SC2.C2_UTILIZA, SC2.C2_CODCLI,"
	cQuery += "SC2.R_E_C_N_O_  SC2RECNO FROM "+RetSqlName("SC2")+" SC2 WHERE "
	cQuery += "SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
	If	Upper(TcGetDb()) $ 'ORACLE,DB2,POSTGRES,INFORMIX'
		cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD >= '" + mv_par01 + "' AND "
		cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD <= '" + mv_par02 + "' AND "
	Endif
	cQuery += "SC2.C2_DATPRF BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' "
	If mv_par08 == 2
		cQuery += "AND SC2.C2_DATRF = ' '"
	Endif	
	If aReturn[8] == 4
		cQuery += "ORDER BY SC2.C2_FILIAL, SC2.C2_DATPRF"
	Else
		cQuery += "ORDER BY " + SqlOrder(SC2->(IndexKey(aReturn[8])))
	EndIf
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SC2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
	dbSelectArea(cAliasTop)
#ELSE
	If aReturn[8] == 4
		IndRegua("SC2",cIndSC2,"C2_FILIAL+DTOS(C2_DATPRF)",,,STR0008)	//"Selecionando Registros..."
	Else
		dbSetOrder(aReturn[8])
	EndIf
	dbSeek(xFilial("SC2"))
#ENDIF

If ! Empty(aReturn[7])
	bBlockFiltro := &("{|| " + aReturn[7] + "}")
Endif	

SetRegua(SC2->(LastRec()))

While !Eof()
	
	IF lEnd
		@ Prow()+1,001 PSay STR0009	//"CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	

	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
		dbSkip()
		Loop
	EndIf   
		
	#IFNDEF TOP		
		If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
			dbSkip()
			Loop
		Endif
		
		If !(Empty(C2_DATRF)) .And. mv_par08 == 2
			dbSkip()
			Loop
		Endif
	#ENDIF

	If !Empty(aReturn[7])
		#IFDEF TOP
			SC2->(dbGoto((cAliasTop)->SC2RECNO))
		#ENDIF	

		If !(SC2->(Eval(bBlockFiltro)))
			(cAliasTop)->(dbSkip())
			Loop                 
		EndIf	
	Endif	

	//-- Valida se a OP deve ser Impressa ou n�o
	If !MtrAValOP(mv_par10,"SC2",cAliasTop)
		dbSkip()
		Loop
	EndIf
	
	cProduto  := C2_PRODUTO
	nQuant    := aSC2Sld(cAliasTop)
	
	dbSelectArea("SB1")
	dbSeek(xFilial()+cProduto)
	
	//��������������������������������������������������������������Ŀ
	//� Adiciona o primeiro elemento da estrutura , ou seja , o Pai  �
	//����������������������������������������������������������������
	AddAr820(nQuant)
	
	MontStruc((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),nQuant)
	
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	ENDIF
	
	//���������������������������������������������������������Ŀ
	//� Imprime cabecalho                                       �
	//�����������������������������������������������������������
	cabecOp(Tamanho)
	
	For I := 2 TO Len(aArray)
		
		@Li ,   0 PSay aArray[I][1]    	 				   	// CODIGO PRODUTO
		For nBegin := 1 To Len(Alltrim(aArray[I][2])) Step 41
			@li,016 PSay Substr(aArray[I][2],nBegin,41)
			li++
		Next nBegin
		Li--
		cQtd := Transform(aArray[I][5],PesqPictQt("D4_QUANT",14))
		@Li ,  59 PSay cQtd				                	// QUANTIDADE
		@Li ,  74 PSay aArray[I][4]     			    	// UNIDADE DE MEDIDA
	    
	    DBSELECTAREA("SB1")
	    dbsetorder(1)
	    DBGOTOP()
	    dbseek(xfilial("sb1")+ aArray[I][1]   )
	    _ntempo := SB1->B1_LTEMPO
	    _ntemperatura := SB1->B1_LTEMPER
	    @li ,  084 PSay _nTEMPO                    	// TEMPO ESTUFAGEM
	    @li ,  097 PSay _nTEMPERATURA                    	// TEMPERATURA
	    
	    DBSELECTAREA("SB2")
	    dbsetorder(1)
	    DBGOTOP()
	    dbseek(xfilial("SB2")+ aArray[I][1] + "01")
	    _ndisponivel := SB2->B2_QATU - SB2->B2_QEMP
	    

	    @li ,  112 PSay _ndisponivel                    	// quantidade disponivel
	    //   @li ,  84 PSay Substr(aArray[I][7],1,12)        	// LOCALIZACAO
	    //   @li ,  96 PSay aArray[I][8]                  	// SEQUENCIA
		Li++
//		@Li ,  00 PSay __PrtThinLine()
//		Li++
		   
		//���������������������������������������������������������Ŀ
		//� Se nao couber, salta para proxima folha                 �
		//�����������������������������������������������������������
		IF li > 53
			Li := 0
			CabecOp(Tamanho)		// imprime cabecalho da OP
		EndIF
		
	Next I
	
	If mv_par05 == 1
		RotOper()   	// IMPRIME ROTEIRO DAS OPERACOES
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  �
	//����������������������������������������������������������������
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SMX")
	If Found() .And. (cAliasTop)->C2_DESTINA == "P"
		R820Medidas()
	EndIf
	
*	m_pag++
    _nLin := Li
    _nOP  := (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
	Li := 0					// linha inicial - ejeta automatico
	aArray:={}

    Detalhes(_nLin,Tamanho,_nOP)
	
	dbSelectArea(cAliasTop)
	dbSkip()
	
EndDO

dbSelectArea("SH8")
dbCloseArea()

dbSelectArea("SC2")
#IFDEF TOP
	(cAliasTop)->(dbCloseArea())
#ELSE	
	If aReturn[8] == 4
		RetIndex("SC2")
		Ferase(cIndSC2+OrdBagExt())
	EndIf
#ENDIF
dbClearFilter()
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � AddAr820 � Autor � Paulo Boschetti       � Data � 07/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Adiciona um elemento ao Array                              ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � AddAr820(ExpN1)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Quantidade da estrutura                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function AddAr820(nQuantItem)
Local cDesc := SB1->B1_DESC
Local cRoteiro:=""
//�����������������������������������������������������������Ŀ
//� Verifica se imprime nome cientifico do produto. Se Sim    �
//� verifica se existe registro no SB5 e se nao esta vazio    �
//�������������������������������������������������������������
If mv_par07 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
	//�����������������������������������������������������������Ŀ
	//� Verifica se imprime descricao digitada ped.venda, se sim  �
	//� verifica se existe registro no SC6 e se nao esta vazio    �
	//�������������������������������������������������������������
	If (cAliasTop)->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO+(cAliasTop)->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO # SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
			EndIf
		EndIf
	EndIf
EndIf

//�����������������������������������������������������������Ŀ
//� Verifica se imprime ROTEIRO da OP ou PADRAO do produto    �
//�������������������������������������������������������������
If !Empty((cAliasTop)->C2_ROTEIRO)
	cRoteiro:=(cAliasTop)->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial()+(cAliasTop)->C2_PRODUTO+"01")
			RecLock("SB1",.F.)
			Replace B1_OPERPAD With "01"
			MsUnLock()
			cRoteiro:="01"
		EndIf
	EndIf
EndIf



dbSelectArea("SB2")
dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL)
dbSelectArea("SD4")
AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,D4_LOCAL,SB2->B2_LOCALIZ,D4_TRT,cRoteiro } )

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � MontStruc� Autor � Ary Medeiros          � Data � 19/10/93 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta um array com a estrutura do produto                  ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � MontStruc(ExpC1,ExpN1,ExpN2)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto a ser explodido                  ���
���          � ExpN1 = Quantidade base a ser explodida                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//���������������������������������������������������������Ŀ
	//� Posiciona no produto desejado                           �
	//�����������������������������������������������������������
	dbSelectArea("SB1")
	dbSeek(xFilial()+SD4->D4_COD)
	If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
		AddAr820(SD4->D4_QUANT)
	EndIf
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � CabecOp  � Autor � Paulo Boschetti       � Data � 07/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta o cabecalho da Ordem de Producao                     ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � CabecOp()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function CabecOp(Tamanho)

Local cCabec1 := SM0->M0_FILIAL+"        O R D E M   D E   P R O D U C A O       NRO :"	//"        O R D E M   D E   P R O D U C A O       NRO :"
Local cCabec2 := "  C O M P O N E N T E S                                                           E S T U F A G E M         SALDO   "				//"  C O M P O N E N T E S                                  |  |  |            |   "
Local cCabec3 := "CODIGO          DESCRICAO                                   QUANTIDADE    UM      TEMPO        TEMP.        DISPONIVEL               "                                          //CODIGO          DESCRICAO                      QUANTIDADE|UM|AL|LOCALIZACAO |SEQ"
//	              01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         			        1         2         3         4         5         6         7         8         9         10        11        12        13
Local nBegin

If li # 5
	li := 0
Endif

Cabec("","","","",Tamanho,18,{cCabec1+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)},.F.)

Li+=2
IF (mv_par06 == 1) .And. aReturn[5] # 1
	//���������������������������������������������������������Ŀ
	//� Imprime o codigo de barras do numero da OP              �
	//�����������������������������������������������������������
	oPr := ReturnPrtObj()   
	cCode := (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
	MSBAR3("CODE128",2.0,0.5,Alltrim(cCode),oPr,Nil,Nil,Nil,nil ,1.5 ,Nil,Nil,Nil)
	Li += 2 //5 // SE QUISER CODIGO DE BARRAS VOLTAR PARA 5
ENDIF
@Li,00 PSay "CLIENTE: "  + (cAliasTop)->C2_DESCCLI   	//CLIENTE
Li++
@Li,00 PSay "PRODUTO: " + aArray[1][1]+ " " +aArray[1][2]   	//"Produto: "
Li++
@Li,00 PSay "EMISSAO: " + DTOC(dDatabase)						//"Emissao:"
@Li,72 PSay "FOL: " + TRANSFORM(m_pag,'999') 
@Li,102 PSAY "MAQUINA: " + (cAliasTop)->C2_MAQUINA   				//"Fol:"
Li++

//���������������������������������������������������������Ŀ
//� Imprime nome do cliente quando OP for gerada            �
//� por pedidos de venda                                    �
//�����������������������������������������������������������
//If (cAliasTop)->C2_DESTINA == "P"
//	dbSelectArea("SC5")
//	dbSetOrder(1)
//	If dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO,.F.)
//		dbSelectArea("SA1")
//		dbSetOrder(1)
//		dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
//		@Li,00 PSay STR0016	//"Cliente :"
//		@Li,10 PSay SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+" "+A1_NOME
//		dbSelectArea("SG1")
//		Li++
//	EndIf
//EndIf

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
	@Li,00 PSay STR0017                 //"Qtde Prod.:"
	@Li,11 PSay aSC2Sld(cAliasTop)		PICTURE PesqPictQt("C2_QUANT",14)
	@Li,26 PSay STR0018                 //"Qtde Orig.:"
	@Li,37 PSay (cAliasTop)->C2_QUANT	PICTURE PesqPictQt("C2_QUANT",14)
Else
	@Li,00 PSay "QUANTIDADE: "  		//"Quantidade :"
	@Li,15 PSay (cAliasTop)->C2_QUANT - (cAliasTop)->C2_QUJE	PICTURE PesqPictQt("C2_QUANT",14)
Endif

//@Li,48 PSay STR0020	//"INICIO             F I M"
Li++
@Li,00 PSay "UNIDADE MEDIDA: " + aArray[1][4]			//"Unid. Medida : "
@Li,42 PSay "PREV. INI: " + DTOC((cAliasTop)->C2_DATPRI)	//"Prev. : "
@Li,72 PSay "PREV. FIM: " + DTOC((cAliasTop)->C2_DATPRF)	//"Prev. : "
NHORAS := 0
NHORAS := NHORAS + ((cAliasTop)->C2_QUANT / ((3600/(cAliasTop)->C2_CICLO)*(cAliasTop)->C2_CAVIDAD))
@Li,102 PSAY "HORAS NECES.: " + TRANSFORM(NHORAS,'999.99')

Li++

@Li,00 PSay "MOLDE: " + TRANSFORM((cAliasTop)->C2_MOLDE, '99999')			//"C.Custo: "
@Li,42 PSay "PESO : " + TRANSFORM((cAliasTop)->C2_PESO, '@E 99999.99999999')			//"C.Custo: "
@Li,72 PSay "COR  : " + (cAliasTop)->C2_COR			                        //"C.Custo: "

Li++


//@Li,00 PSay "C.CUSTO: " + (cAliasTop)->C2_CC			//"C.Custo: "
//@Li,42 PSay "AJUSTE: "  + DTOC((cAliasTop)->C2_DATAJI)	//"Ajuste: "
//@Li,62 PSay "AJUSTE: "  + DTOC((cAliasTop)->C2_DATAJF)	//"Ajuste: "
//Li++
//If (cAliasTop)->C2_STATUS == "S"
//	@Li,00 PSay "STATUS: OP SACRAMENTADA" 	//"Status: OP Sacramentada"
//ElseIf (cAliasTop)->C2_STATUS == "U"
//	@Li,00 PSay "STATUS: OP SUSPENSA"		//"Status: OP Suspensa"
//ElseIf (cAliasTop)->C2_STATUS $ " N"
//	@Li,00 PSay "STATUS: OP NORMAL"			//"Status: OP Normal"
//EndIf
//@Li,42 PSay "REAL  :   /  /      REAL  :   /  / "							//	"Real  :   /  /      Real  :   /  / "
//Li++
@Li,00 PSay "COD. CLIENTE:  " + (cAliasTop)->C2_CODCLI 
@Li,42 PSay "CICLO:  " +TRANSFORM((cAliasTop)->C2_CICLO, '99') 
@Li,72 PSay "CAVID. MOLDE:  "  + TRANSFORM((cAliasTop)->C2_CAVIDAD, '999')
@Li,102 PSAY "CAVID. PROD: " + TRANSFORM((cAliasTop)->C2_UTILIZA, '999')
Li++
If !(Empty((cAliasTop)->C2_OBS))
	@Li,00 PSay "OBSERVACAO: "						//"Observacao: "
	For nBegin := 1 To Len(Alltrim((cAliasTop)->C2_OBS)) Step 65
		@li,012 PSay Substr((cAliasTop)->C2_OBS,nBegin,65)
	Next nBegin
EndIf

@Li,102 PSay "APROVADO POR: "						//"Observacao: "

li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec2
Li++
@Li,00 PSay cCabec3
Li++
@Li,00 PSay __PrtFatLine()
Li++

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function RotOper()

dbSelectArea("SG2")
If dbSeek(xFilial()+aArray[1][1]+aArray[1][9],.F.)
	
	cRotOper()
	
	While !Eof() .And. G2_FILIAL+G2_PRODUTO+G2_CODIGO = xFilial()+aArray[1][1]+aArray[1][9]
		
		dbSelectArea("SH4")
		dbSeek(xFilial()+SG2->G2_FERRAM)
		
		dbSelectArea("SH8")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC)
		lSH8 := IIf(Found(),.T.,.F.)
		
		If lSH8
			While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == xFilial()+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC
				ImpRot(lSH8)
				dbSelectArea("SH8")
				dbSkip()
			End
		Else
			ImpRot(lSH8)
		Endif
		
		dbSelectArea("SG2")
		dbSkip()
		
	EndDo
	
Endif

Return Li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � ImpRot   � Autor � Marcos Bregantim      � Data � 10/07/95 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � ImpRot()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function ImpRot(lSH8)
Local nBegin

dbSelectArea("SH1")
dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

Verilim()

@Li,00 PSay IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25)
@Li,33 PSay SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20)
@Li,61 PSay SG2->G2_OPERAC

For nBegin := 1 To Len(Alltrim(SG2->G2_DESCRI)) Step 16
	@li,064 PSay Substr(SG2->G2_DESCRI,nBegin,50)
	li++

   IF li > 60
		Li := 0
		cRotOper()
	EndIF
Next nBegin

Li+=1
@Li,00 PSay STR0032+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+STR0033+" ____/ ____/____ ___:___"	//"INICIO  ALOC.: "###" INICIO  REAL :"
Li++
@Li,00 PSay STR0034+IIF(lSH8,DTOC(SH8->H8_DTFIM),Space(8))+" "+IIF(lSH8,SH8->H8_HRFIM,Space(5))+" "+STR0035+" ____/ ____/____ ___:___"	//"TERMINO ALOC.: "###" TERMINO REAL :"
Li++
@Li,00 PSay STR0019	//"Quantidade :"
@Li,13 PSay IIF(lSH8,SH8->H8_QUANT,aSC2Sld(cAliasTop)) PICTURE PesqPictQt("H8_QUANT",14)
@Li,28 PSay STR0036	//"Quantidade Produzida :               Perdas :"
Li++
@Li,00 PSay __PrtThinLine()
Li++

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function cRotOper()

Local cCabec1 := SM0->M0_NOME+STR0030	//"              ROTEIRO DE OPERACOES              NRO :"
Local cCabec2 := STR0031					//"RECURSO                       FERRAMENTA               OPERACAO"

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec1
@Li,67 PSay (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay STR0013+aArray[1][1]	//"Produto: "
ImpDescr(aArray[1][2])

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
	@Li,00 PSay STR0017                 //"Qtde Prod.:"
	@Li,11 PSay aSC2Sld(cAliasTop)      PICTURE PesqPictQt("C2_QUANT",14)
	@Li,26 PSay STR0018                 //"Qtde Orig.:"
	@Li,37 PSay (cAliasTop)->C2_QUANT   PICTURE PesqPictQt("C2_QUANT",14)
Else
	@Li,00 PSay STR0019            //"Quantidade :"
	@Li,15 PSay aSC2Sld(cAliasTop)	PICTURE PesqPictQt("C2_QUANT",14)
Endif

Li++
@Li,00 PSay STR0023+(cAliasTop)->C2_CC	//"C.Custo: "
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec2
Li++
@Li,00 PSay __PrtFatLine()
Li++
Return Li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � Verilim  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � Verilim()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 			                                          		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function Verilim()

//����������������������������������������������������������������������Ŀ
//� Verifica a possibilidade de impressao da proxima operacao alocada na �
//� mesma folha.																			 �
//� 7 linhas por operacao => (total da folha) 66 - 7 = 59					 �
//������������������������������������������������������������������������
IF Li > 59						// Li > 55
	Li := 0
	cRotOper(0)					// Imprime cabecalho roteiro de operacoes
Endif
Return Li

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � BARCODE  � Autor � Ricardo Dutra          � Data � 16/08/93 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Programa para imprimir codigo de barras                     ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � CodBar(ExpC1)								                        ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
#define ESC	27
Static Function BarCode(cCodigo)
Local nLargura := 40	// largura de impressao do codigo
Local i, j, l, k, nCarac, cTexto, cEsc, cCode, nLimite, nImp, nBorda, nLin
Local aV0 := { Replicate(Chr(0),7), Chr(0) + Chr(0) + Chr(0) }
Local aV1 := { Replicate(Chr(127),6), Chr(127) + Chr(127) }
Local aImp [50]

nLin := 0							// imprime codigo comeco formulario
cEsc := Chr(ESC)

//��������������������������������������������������������������������Ŀ
//� Reseta a impressora na posicao atual - comeco formulario           �
//����������������������������������������������������������������������
@ 0,0 PSay cEsc + "@"				// reseta a impressora nesta posicao

cTexto := cCodigo
cTexto := "*" + cTexto + "*"		// caracteres de inicio e fim

nImp := 1
aImp [nImp] := ""
nLimite := Len(cTexto)

FOR i := 1 TO nLimite
	nCarac := Asc (Substr (cTexto, i, 1))
	
	//����������������������������������������������������������Ŀ
	//� Atribui um codigo a cada caracter                        �
	//������������������������������������������������������������
	
	IF nCarac == 42					// *
		cCode := "2122121222"
	ELSEIF nCarac == 32				// branco
		cCode := "2112221222"
	ELSEIF nCarac == 48				// 0
		cCode := "2221121222"
	ELSEIF nCarac == 49				// 1
		cCode := "1221222212"
	ELSEIF nCarac == 50				// 2
		cCode := "2211222212"
	ELSEIF nCarac == 51				// 3
		cCode := "1211222222"
	ELSEIF nCarac == 52				// 4
		cCode := "2221122212"
	ELSEIF nCarac == 53				// 5
		cCode := "1221122222"
	ELSEIF nCarac == 54				// 6
		cCode := "2211122222"
	ELSEIF nCarac == 55				// 7
		cCode := "2221221212"
	ELSEIF nCarac == 56				// 8
		cCode := "1221221222"
	ELSEIF nCarac == 57				// 9
		cCode := "2211221222"
	ELSEIF nCarac == 65				// A
		cCode := "1222212212"
	ELSEIF nCarac == 66				// B
		cCode := "2212212212"
	ELSEIF nCarac == 67				// C
		cCode := "1212212222"
	ELSEIF nCarac == 68				// D
		cCode := "2222112212"
	ELSEIF nCarac == 69				// E
		cCode := "1222112222"
	ELSEIF nCarac == 70				// F
		cCode := "2212112222"
	ELSEIF nCarac == 71				// G
		cCode := "2222211212"
	ELSEIF nCarac == 72				// H
		cCode := "1222211222"
	ELSEIF nCarac == 73				// I
		cCode := "2212211222"
	ELSEIF nCarac == 74				// J
		cCode := "2222111222"
	ELSEIF nCarac == 75				// K
		cCode := "1222222112"
	ELSEIF nCarac == 76				// L
		cCode := "2212222112"
	ELSEIF nCarac == 77				// M
		cCode := "1212222122"
	ELSEIF nCarac == 78				// N
		cCode := "2222122112"
	ELSEIF nCarac == 79				// O
		cCode := "1222122122"
	ELSEIF nCarac == 80				// P
		cCode := "2212122122"
	ELSEIF nCarac == 81				// Q
		cCode := "2222221112"
	ELSEIF nCarac == 82				// R
		cCode := "1222221122"
	ELSEIF nCarac == 83				// S
		cCode := "2212221122"
	ELSEIF nCarac == 84				// T
		cCode := "2222121122"
	ELSEIF nCarac == 85				// U
		cCode := "1122222212"
	ELSEIF nCarac == 86				// V
		cCode := "2112222212"
	ELSEIF nCarac == 87				// W
		cCode := "1112222222"
	ELSEIF nCarac == 88				// X
		cCode := "2122122212"
	ELSEIF nCarac == 89				// Y
		cCode := "1122122222"
	ELSEIF nCarac == 90				// Z
		cCode := "2112122222"
	ENDIF
	
	//���������������������������������������������������������������Ŀ
	//� Adiciona barras ou espacos ao array de impressao, sendo :     �
	//� - barra grossa  = 6 * Chr(127)                				      �
	//� - barra fina    = 2 * Chr(127)								         �
	//� - espaco grosso = 7 * Chr(0)                                  �
	//� - espaco fino   = 3 * Chr(0) 								         �
	//�																               �
	//� As barras e espacos sao alocados de acordo com os caracteres  �
	//� de cCode, tomados 2 a 2, sendo que o primeiro designa as bar- �
	//� ras e o segundo, os espacos. 								         �
	//� Se o caracter for 1 => barra/espaco grosso					      �
	//� Se o caracter for 2 => barra/espaco fino					         �
	//�����������������������������������������������������������������
	FOR j := 1 to 9 STEP 2
		aImp[nImp] := aImp[nImp] + aV1 [val(substr(cCode,j,1))] + ;
		aV0 [val(substr(cCode,j + 1,1))]
	NEXT
	
	l := len(aImp[nImp])
	
	//����������������������������������������������������������������������Ŀ
	//�Se tamanho do string atual de impressao for maior que 120,				 �
	//�copia o que ultrapassou para o proximo string								 �
	//�Limita o string atual para 120 + caracteres de controle de imp grafica�
	//�Incrementa contador de strings													 �
	//������������������������������������������������������������������������
	IF l > 120
		aImp[nImp+1] := Right(aImp[nImp],l -120)
		aImp[nImp] := cEsc + "L" + Chr(120) + Chr(0) + Left(aImp[nImp],120)
		nImp++
	ENDIF
NEXT

j := Len(aImp[nImp])

//���������������������������������������������������Ŀ
//�Borda esquerda da etiqueta para centrar o codigo   �
//�����������������������������������������������������
nBorda := (nLargura - (j + (nImp - 1) * 120 ) / Len(cTexto)) / 2

IF nBorda < 0
	return -2		// Codigo muito grande p/largura especificada
ENDIF

//��������������������������������������������������������������Ŀ
//� Acrescenta caracteres de controle grafico ao ultimo string   �
//����������������������������������������������������������������
aImp[nImp] := cEsc + "L" + Chr(j)+Chr(0) + aImp[nImp] + cEsc + "3" + Chr(1)

FOR l := 1 to 4					// imprime quatro linhas
	FOR k := 1 to 3				// imprime tres vezes
		FOR i := 1 to nImp		// contador de strings
			@ nLin,nBorda+(i-1)*10 PSay aImp[i]
		NEXT
		nLin++
	NEXT
	
	//��������������������������������������������������������������Ŀ
	//� Seta tamanho de linha para posicionar para a proxima         �
	//����������������������������������������������������������������
	@ nLin,1 PSay cEsc + "3" + Chr(18)
	nLin++
NEXT

//��������������������������������������������������������������������Ŀ
//� Seta tamanho de linha p/ posicionar cursor proxima coluna de texto �
//����������������������������������������������������������������������
@ nLin,1 PSay  cEsc + "3" + Chr(24)
nLin++

@ nLin,1 PSay cEsc + "2"			// cancela espacamentos de linha progrados

//��������������������������������������������������������������������Ŀ
//� Imprime o numero da OP expandido e centralizado, embaixo do codigo �
//����������������������������������������������������������������������
cNumOp := Replicate(" ",3) + cTexto		// para centralizar
@ nLin,nBorda PSay Chr(14) + cNumOp	    // imprime expandido
nLin++
@ nLin,0 PSay Chr(20)					// volta ao normal

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpDescr � Autor � Marcos Bregantim      � Data � 31.08.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir descricao do Produto.                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpProd(Void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpDescr(cDescri)
Local nBegin

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
	@li,025 PSay Substr(cDescri,nBegin,50)
	li++
Next nBegin

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R820Medidas� Autor � Jose Lucas           � Data � 25.01.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o registros referentes as medidas do Pedido Filho. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R820Medidas(Void)                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820Medidas()
Local aArrayPro := {}, lImpItem := .T.
Local nCntArray := 0,a01 := "",a02 := ""
Local nX:=0,nI:=0,nL:=0,nY:=0
Local cNum:="", cItem:="",lImpCab := .T.
Local nBegin, cProduto:="", cDesc, cDescri, cDescri1, cDescri2

//������������������������������������������������������������Ŀ
//� Imprime Relacao de Medidas do cliente quando OP for gerada �
//� por pedidos de vendas.                                     �
//��������������������������������������������������������������
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO,.F.)
	cNum := (cAliasTop)->C2_NUM
	cItem := (cAliasTop)->C2_ITEM
	cProduto := (cAliasTop)->C2_PRODUTO
	//��������������������������������������������������������������Ŀ
	//� Imprimir somente se houver Observacoes.                      �
	//����������������������������������������������������������������
	IF !Empty(SC5->C5_OBSERVA)
		IF li > 53
			@ 03,001 PSay "HUNTER DOUGLAS DO BRASIL LTDA"
			@ 05,008 PSay "CONFIRMACAO DE PEDIDOS  -  "+IIF( SC5->C5_VENDA=="01","ASSESSORIA","DISTRIBUICAO")
			@ 05,055 PSay "No. RMP    : "+SC5->C5_NUM+"-"+SC5->C5_VENDA
			@ 06,055 PSay "DATA IMPRES: "+DTOC(dDataBase)
			li := 07
		EndIF
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
		cDescri := SC5->C5_OBSERVA
		@ li,001 PSay " OBSERVACAO: "
		@ li,018 PSay SubStr(cDescri,1,60)
		For nBegin := 61 To Len(Trim(cDescri)) Step 60
			li++
			cDesc:=Substr(cDescri,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		cDescri1 := SC5->C5_OBSERV1
		@ li,018 PSay SubStr(cDescri1,1,60)
		For nBegin := 61 To Len(Trim(cDescri1)) Step 60
			li++
			cDesc:=Substr(cDescri1,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		Li++
		cDescri2 := SC5->C5_OBSERV2
		@ li,018 PSay SubStr(cDescri2,1,60)
		For nBegin := 61 To Len(Trim(cDescri2)) Step 60
			li++
			cDesc:=Substr(cDescri2,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Carregar as medidas em array para impressao.                 �
	//����������������������������������������������������������������
	dbSelectArea("SMX")
	dbSetOrder(2)
	dbSeek(xFilial()+cNum+cProduto)
	While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
		IF M6_ITEM == cItem
			AADD(aArrayPro,M6_ITEM+" - "+M6_PRODUTO)
			nCntArray++
			cCnt := StrZero(nCntArray,2)
			aArray&cCnt := {}
			While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
				If M6_ITEM == cItem
					AADD(aArray&cCnt,{ Str(M6_QUANT,9,2)," PECAS COM ",M6_COMPTO})
				EndIf
				dbSkip()
			End
		Else
			dbSkip()
		EndIF
	End
	cCnt := StrZero(nCntArray+1,2)
	aArray&cCnt := {}
	
	For nX := 1 TO Len(aArrayPro)
		If li > 58
			R820CabMed()
		EndIF
		@ li,009 PSay aArrayPro[nx]
		Li++
		Li++
		dbSelectArea("SMX")
		dbSetOrder(2)
		dbSeek( xFilial()+cNum+Subs(aArrayPro[nX],06,15) )
		While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+Subs(aArrayPro[nX],06,15)
			If li > 58
				R820CabMed()
			EndIF
			IF M6_ITEM == Subs(aArrayPro[nX],1,2)
				@ li,002 PSay M6_QUANT
				@ li,013 PSay "PECAS COM"
				@ li,023 PSay M6_COMPTO
				@ li,035 PSay M6_OBS
				li ++
			EndIF
			dbSkip()
		End
		li++
	Next nX
	@ li,001 PSay "--------------------------------------------------------------------------------"
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R820CabMed � Autor � Jose Lucas           � Data � 25.01.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o cabecalho referentes as medidas do Pedido Filho. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R820CabMed(Void)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820CabMed()
Local cCabec1 := SM0->M0_NOME+STR0037	//"               RELACAO DE MEDIDAS             NRO :"

Li := 0

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec1
@Li,67 PSay (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Li++
@Li,00 PSay __PrtFatLine()
Li++
Li++
Return Nil
//
//
Static Function Detalhes(Li,Tamanho,_nOP)
Local _cCabec1 := SM0->M0_NOME+"        O R D E M   D E   P R O D U C A O       NRO :"	//"        O R D E M   D E   P R O D U C A O       NRO :"

Private _nN := 0
Private _nJ := 0

If Li > 52
    Li := 0
    Cabec("","","","",Tamanho,18,{_cCabec1+_nOP},.F.)
    Li := 10
EndIf

Li++
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay "|                                         |           SAIDA            |                                                                                            |"
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay "|          DATA         |     ENTRADA     |    MOIDO    |     NOVO     |     SALDO     | RASTREABILIDADE |  RESPONSAVEL                                             |"
Li++
@Li,00 PSay __PrtFatLine()

_nJ := 58 - Li

For _nN := 1  To  _nJ  Step 2
    @Li+_nN  ,00 PSay "|   _____/_____/_____   |                 |             |              |               |                 |                                                          |"
    @Li+_nN+1,00 PSay __PrtFatLine()
Next

Return