#INCLUDE "MATR235.CH"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MATR235   � Autor �Felipe Nunes Toledo    � Data � 12/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio de Perda.                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MATR235X()
Local   oReport
Private cAliasSBC

//If TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
/*Else
	MATR235R3()
EndIf
*/
Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Felipe Nunes Toledo    � Data �12/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR235			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local oReport
Local oSection
Local aOrdem

//��������������������������������������������������������������Ŀ
//� Tratamento da Ordem para utilizacao do Siga Pyme             �
//����������������������������������������������������������������
If !__lPyme
	aOrdem := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010)}    //"Por OP"###"Por Recurso"###"Por Motivo"###"Por Produto"###"Por Data"###"Por Operador"
Else
	aOrdem := {OemToAnsi(STR0005),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010)}    //"Por OP"###"Por Motivo"###"Por Produto"###"Por Data"###"Por Operador"
EndIf

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
oReport:= TReport():New("MATR235",OemToAnsi(STR0001),"MTR235", {|oReport| ReportPrint(oReport)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)+" "+OemToAnsi(STR0004)) //##"Emite a relacao das perdas em producao no sistema, de acordo com a ordem selecionada pelo usuario. Relaciona as perdas de Scrap e Refugo que foram classificadas."
If(TamSX3("BC_PRODUTO")[1]<=15,oReport:SetPortrait(),oReport:SetLandscape())  //Define a orientacao de pagina.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // De  OP								         �
//� mv_par02     // Ate OP									     �
//� mv_par03     // De  Produto                                  �
//� mv_par04     // Ate Produto                                  �
//� mv_par05     // De  Recurso                                  �
//� mv_par06     // Ate Recurso                                  �
//� mv_par07     // De  Motivo                                   �
//� mv_par08     // Ate Motivo                                   �
//� mv_par09     // De  Data                                     �
//� mv_par10     // Ate Data                                     �
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
//� Sessao 1 (oSection)                                          �
//����������������������������������������������������������������
oSection := TRSection():New(oReport,OemToAnsi(STR0001),{"SBC"},aOrdem) //"Relatorio de Perda"
oSection:SetHeaderPage()
oSection:SetTotalInLine(.F.)

TRCell():New(oSection,'BC_TIPO'	 	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_OP'	  	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_PRODUTO' 	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_QUANT'  	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_LOCORIG' 	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_MOTIVO'  	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection,'Motivo'	    ,'SBC',STR0025,/*Picture*/, 25        ,/*lPixel*/,{|| a235refugo((cAliasSBC)->BC_MOTIVO) })

TRCell():New(oSection,'BC_CODDEST'	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_QTDDEST'	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_DATA'		,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_RECURSO'	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_OPERAC' 	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_OPERADO'	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'CUSTO'		,'SBC','Custo Perda','@E 9,999.999999',10,/*lPixel*/,{|| fCusto((cAliasSBC)->BC_SEQSD3 ) })

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Felipe Nunes Toledo  � Data �12/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR825			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)
Local oSection  := oReport:Section(1)
Local nOrdem    := oSection:GetOrder()
Local oBreak
Local oFunction
Local cOrderBy
Local cIndex

//�������������������Ŀ
//�Defininco a Quebra �
//���������������������
If !__lPyme
	//"Por OP"###"Por Recurso"###"Por Motivo"###"Por Produto"###"Por Data"###"Por Operador"
	If nOrdem == 1
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_OP"),STR0023+STR0014,.T.) // "Total da OP:"
	Elseif nOrdem == 2
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_RECURSO"),STR0023+STR0015,.T.)// "Total do Recurso:"
	Elseif nOrdem == 3
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_MOTIVO"),STR0023+STR0016,.T.)// "Total do Motivo:"
	Elseif nOrdem == 4
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_PRODUTO"),STR0023+STR0017,.T.) // "Total da Produto:"
	Elseif nOrdem == 5
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_DATA"),STR0023+STR0018,.T.) // "Total da Data:"
	ElseIf nOrdem == 6 // Opcao nao habilitada no Prothes Start
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_OPERADO"),STR0023+STR0019,.T.) // "Total do Operador:"
	EndIf
Else
	//"Por OP"###"Por Motivo"###"Por Produto"###"Por Data"###"Por Operador"
	If nOrdem == 1
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_OP"),STR0023+STR0014,.T.) // "Total da OP:"
	Elseif nOrdem == 2
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_MOTIVO"),STR0023+STR0016,.T.)// "Total do Motivo:"
	Elseif nOrdem == 3
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_PRODUTO"),STR0023+STR0017,.T.) // "Total da Produto:"
	Elseif nOrdem == 4
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_DATA"),STR0023+STR0018,.T.) // "Total da Data:"
	Elseif nOrdem == 5
		oBreak := TRBreak():New(oSection,oSection:Cell("BC_OPERADO"),STR0023+STR0019,.T.) // "Total do Operador:"
	Endif
Endif

//����������������������������������������������������������������Ŀ
//�Totalizando as Horas Produtivas / Improdutivas conforme a Quebra�
//������������������������������������������������������������������
oFunction := TRFunction():New(oSection:Cell('BC_QUANT'),NIL,"SUM",oBreak,/*Titulo*/,/*Picture*/,/*uFormula*/,.F.,.F.) // Total Origem
oFunction := TRFunction():New(oSection:Cell('BC_QTDDEST'),NIL,"SUM",oBreak,/*Titulo*/,/*Picture*/,/*uFormula*/,.F.,.F.) // Total Destino
oFunction := TRFunction():New(oSection:Cell('CUSTO'),NIL,"SUM",oBreak,'Total Perda','@E 99,999.999999',/*uFormula*/,.F.,.F.) // Total Destino

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Query do relatorio da secao 1                                           �
//��������������������������������������������������������������������������

oSection:BeginQuery()

cAliasSBC := GetNextAlias()

//��������������������������������������������������������������Ŀ
//� Order by de acordo com a ordem selecionada.                  �
//����������������������������������������������������������������

cOrderBy := "%"
If !__lPyme
	//"Por OP"###"Por Recurso"###"Por Motivo"###"Por Produto"###"Por Data"###"Por Operador"
	If nOrdem == 1
		cOrderBy += " BC_FILIAL, BC_OP, BC_OPERAC, BC_RECURSO "	//"da OP:"
	ElseIf nOrdem == 2
		cOrderBy += " BC_FILIAL, BC_RECURSO, BC_OPERAC, BC_MOTIVO, BC_PRODUTO " //"do Recurso:"
	ElseIf nOrdem == 3
		cOrderBy += " BC_FILIAL, BC_MOTIVO, BC_PRODUTO " //"do Motivo:"
	ElseIf nOrdem == 4
		cOrderBy += " BC_FILIAL, BC_PRODUTO, BC_MOTIVO " //"do Produto:"
	ElseIf nOrdem == 5
		cOrderBy += " BC_FILIAL, BC_DATA, BC_PRODUTO, BC_MOTIVO " //"da Data:"
	ElseIf nOrdem == 6 // Opcao nao habilitada no Prothes Start
		cOrderBy += " BC_FILIAL, BC_OPERADO, BC_MOTIVO " //"do Operador:"
	Endif
Else
	//"Por OP"###"Por Motivo"###"Por Produto"###"Por Data"###"Por Operador"
	If nOrdem == 1
		cOrderBy += " BC_FILIAL, BC_OP, BC_OPERAC, BC_RECURSO "	//"da OP:"
	ElseIf nOrdem == 2
		cOrderBy += " BC_FILIAL, BC_MOTIVO, BC_PRODUTO " //"do Motivo:"
	ElseIf nOrdem == 3
		cOrderBy += " BC_FILIAL, BC_PRODUTO, BC_MOTIVO " //"do Produto:"
	ElseIf nOrdem == 4
		cOrderBy += " BC_FILIAL, BC_DATA, BC_PRODUTO, BC_MOTIVO " //"da Data:"
	ElseIf nOrdem == 5
		cOrderBy += " BC_FILIAL, BC_OPERADO, BC_MOTIVO " //"do Operador:"
	EndIf
Endif
cOrderBy += "%"

   	BeginSql Alias cAliasSBC

SELECT SBC.*

FROM %table:SBC% SBC

WHERE BC_FILIAL = %xFilial:SBC%		 AND
  		  BC_OP    	  >= %Exp:mv_par01%	 AND
 	  BC_OP       <= %Exp:mv_par02%	 AND
 	  BC_PRODUTO  >= %Exp:mv_par03%	 AND
 	  BC_PRODUTO  <= %Exp:mv_par04%	 AND
 	  BC_RECURSO  >= %Exp:mv_par05%	 AND
 	  BC_RECURSO  <= %Exp:mv_par06%	 AND
	  BC_MOTIVO   >= %Exp:mv_par07%	 AND
	  BC_MOTIVO   <= %Exp:mv_par08%	 AND
 		  BC_DATA     >= %Exp:mv_par09%	 AND
 		  BC_DATA     <= %Exp:mv_par10%	 AND
 		  SBC.%NotDel%

ORDER BY %Exp:cOrderBy%

EndSql

oSection:EndQuery()


//��������������������������������Ŀ
//�Inicio da impressao do relatorio�
//����������������������������������
oReport:Section(1):Print()

//-- Devolve a condicao original do arquivo principal
dbSelectArea('SBC')
dbSetOrder(1)
Set Filter To

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C235IMP  � Autor � Rodrigo de A. Sartorio� Data � 18/12/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR235  			                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C235Imp(aOrd,lEnd,WnRel,titulo,Tamanho)
//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������

LOCAL nTipo    := 0
LOCAL cRodaTxt := OemToAnsi(STR0013)   //"REGISTRO(S)"
LOCAL nCntImpr := 0
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas na totalizacao do relatorio             �
//����������������������������������������������������������������
LOCAL nTotal:=0,nTotalDest:=0
LOCAL cQuebra,cCampo,cMens
LOCAL cIndex
//��������������������������������������������������������������Ŀ
//� Condicao de Filtragem do SBC                                 �
//����������������������������������������������������������������
LOCAL cCond := 'BC_PRODUTO>="'+mv_par03+'".And.BC_PRODUTO<="'+mv_par04+'".And.'
		cCond += 'BC_RECURSO>="'+mv_par05+'".And.BC_RECURSO<="'+mv_par06+'".And.'
		cCond += 'BC_MOTIVO>="'+mv_par07+'".And.BC_MOTIVO<="'+mv_par08+'".And.'
		cCond += 'DTOS(BC_DATA)>="'+DTOS(MV_PAR09)+'".And.DTOS(BC_DATA)<="'+DTOS(mv_par10)+'"'

//��������������������������������������������������������������Ŀ
//� Indice Condicional de acordo com a ordem selecionada.        �
//� Tratamento da Ordem para utilizacao do Siga Pyme             �
//����������������������������������������������������������������
If !__lPyme
	//"Por OP"###"Por Recurso"###"Por Motivo"###"Por Produto"###"Por Data"###"Por Operador"
	If aReturn[8] = 1
		cIndex:="BC_FILIAL+BC_OP+BC_OPERAC+BC_RECURSO"
		cCampo:="BC_FILIAL+BC_OP"
		cMens:=OemToAnsi(STR0014)	//"Por OP:"
	ElseIf aReturn[8] = 2
		cIndex:="BC_FILIAL+BC_RECURSO+BC_OPERAC+BC_MOTIVO+BC_PRODUTO"
		cCampo:="BC_FILIAL+BC_RECURSO"
		cMens:=OemToAnsi(STR0015)	//"Por Recurso:"
	ElseIf aReturn[8] = 3
		cIndex:="BC_FILIAL+BC_MOTIVO+BC_PRODUTO"
		cCampo:="BC_FILIAL+BC_MOTIVO"
		cMens:=OemToAnsi(STR0016)	//"Por Motivo:"
	ElseIf aReturn[8] = 4
		cIndex:="BC_FILIAL+BC_PRODUTO+BC_MOTIVO"
		cCampo:="BC_FILIAL+BC_PRODUTO"
		cMens:=OemToAnsi(STR0017)	//"Por Produto:"
	ElseIf aReturn[8] = 5
		cIndex:="BC_FILIAL+DTOS(BC_DATA)+BC_PRODUTO+BC_MOTIVO"
		cCampo:="BC_FILIAL+DTOS(BC_DATA)"
		cMens:=OemToAnsi(STR0018)	//"Por Data:"
	ElseIf aReturn[8] = 6 // Opcao nao habilitada no Prothes Start
		cIndex:="BC_FILIAL+BC_OPERADO+BC_MOTIVO"
		cCampo:="BC_FILIAL+BC_OPERADO"
		cMens:=OemToAnsi(STR0019)	//"Por Operador:"
	EndIf
Else
	//"Por OP"###"Por Motivo"###"Por Produto"###"Por Data"###"Por Operador"
	If aReturn[8] = 1
		cIndex:="BC_FILIAL+BC_OP+BC_OPERAC+BC_RECURSO"
		cCampo:="BC_FILIAL+BC_OP"
		cMens:=OemToAnsi(STR0014)	//"da OP:"
	ElseIf aReturn[8] = 2
		cIndex:="BC_FILIAL+BC_MOTIVO+BC_PRODUTO"
		cCampo:="BC_FILIAL+BC_MOTIVO"
		cMens:=OemToAnsi(STR0016)	//"do Motivo:"
	ElseIf aReturn[8] = 3
		cIndex:="BC_FILIAL+BC_PRODUTO+BC_MOTIVO"
		cCampo:="BC_FILIAL+BC_PRODUTO"
		cMens:=OemToAnsi(STR0017)	//"do Produto:"
	ElseIf aReturn[8] = 4
		cIndex:="BC_FILIAL+DTOS(BC_DATA)+BC_PRODUTO+BC_MOTIVO"
		cCampo:="BC_FILIAL+DTOS(BC_DATA)"
		cMens:=OemToAnsi(STR0018)	//"da Data:"
	ElseIf aReturn[8] = 5
		cIndex:="BC_FILIAL+BC_OPERADO+BC_MOTIVO"
		cCampo:="BC_FILIAL+BC_OPERADO"
		cMens:=OemToAnsi(STR0019)	//"do Operador:"
	EndIf
Endif

//����������������������������������������������������������Ŀ
//� Pega o nome do arquivo de indice de trabalho             �
//������������������������������������������������������������
cNomArq := CriaTrab("",.F.)

//����������������������������������������������������������Ŀ
//� Cria o indice de trabalho                                �
//������������������������������������������������������������
dbSelectArea("SBC")
IndRegua("SBC",cNomArq,cIndex,,cCond,OemToAnsi(STR0020))   //"Selecionando Registros..."
dbSeek(xFilial())

//��������������������������������������������������������������Ŀ
//� Inicializa variaveis para controlar cursor de progressao     �
//����������������������������������������������������������������
SetRegua(LastRec())

//������������������������������������������������������������Ŀ
//� Adiciona a ordem escolhida ao titulo do relatorio          �
//��������������������������������������������������������������
titulo+=" "+aOrd[aReturn[8]]

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
cabec1 := OemToAnsi(If(! __lPyme, STR0021, STR0024))	//"TP  ORDEM DE   ___________ORIGEM__________ MOTIVO                         __________DESTINO__________   DATA     RECUR. OP  OPERADOR "
cabec2 := OemToAnsi(STR0022)	//"    PRODUCAO      PRODUTO      QUANTIDADE                                     PRODUTO     QUANTIDADE                                 "
//                               9  99999999999 999999999999999 99999999999 99 - XXXXXXXXXXXXXXXXXXXXXXXXX 999999999999999 99999999999 99/99/9999 999999 99 9999999999
//                               0         1         2         3         4         5         6         7         8         9        10        11        12        13
//                               0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

Do While !Eof() .And. BC_FILIAL == xFilial()
	If BC_OP < mv_par01 .Or. BC_OP > mv_par02
		IncRegua()
		dbSkip()
		Loop
	EndIf
	nTotal:=0;nTotalDest:=0
	cQuebra:=&(cCampo)
	Do While !Eof() .And. &(cCampo) == cQuebra
		IncRegua()
		If BC_OP < mv_par01 .Or. BC_OP > mv_par02
			IncRegua()
			dbSkip()
			Loop
		EndIf
		If li > 58
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		@ li,000 PSay BC_TIPO 			Picture PesqPict("SBC","BC_TIPO",1)
		@ li,002 PSay BC_OP   			Picture PesqPict("SBC","BC_OP",11)
		@ li,015 PSay BC_PRODUTO		Picture PesqPict("SBC","BC_PRODUTO",15)
		@ li,031 PSay BC_QUANT			Picture PesqPictQt("BC_QUANT",15)
		@ li,048 PSay BC_MOTIVO			Picture PesqPict("SBC","BC_MOTIVO",2)
		@ li,051 pSay '-'
		cMotivo:= a235refugo(BC_MOTIVO)
		@ li,053 PSay Substr(cMotivo,1,16)
		dbSelectArea("SBC")		
		@ li,070 PSay BC_CODDEST		Picture PesqPict("SBC","BC_CODDEST",15)
		@ li,085 PSay BC_QTDDEST		Picture PesqPictQt("BC_QTDDEST",15)
		@ li,101 PSay BC_DATA			Picture PesqPict("SBC","BC_DATA",8)
		@ li,112 PSay BC_RECURSO		Picture PesqPict("SBC","BC_RECURSO",6)
		@ li,119 PSay BC_OPERAC			Picture PesqPict("SBC","BC_OPERAC",2)
		@ li,122 PSay BC_OPERADO		Picture PesqPict("SBC","BC_OPERADO",7)
		nTotal+=BC_QUANT
		nTotalDest+=BC_QTDDEST
		li++
		dbSkip()
	EndDo
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	@ li,00 PSay OemToAnsi(STR0023)+cMens  //"Total "
	@ li,31 PSay nTotal     Picture PesqPictQt("BC_QUANT",15)
	@ li,85 PSay nTotalDest Picture PesqPictQt("BC_QTDDEST",15)
	li++;li++
EndDo

IF li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF

//��������������������������������������������������������������Ŀ
//� Devolve as ordens originais do arquivo                       �
//����������������������������������������������������������������
RetIndex("SBC")
Set Filter to

//��������������������������������������������������������������Ŀ
//� Apaga indice de trabalho                                     �
//����������������������������������������������������������������
cNomArq += OrdBagExt()
Delete File &(cNomArq)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()


//Busca a descri��o do motivo de refugo.
//Se o cliente tem os campos novos da CYO, ent�o ele tem a melhoria em que foi retirada
//o cadastro de refugo da SX5 e transferido para o SFCA003

Static Function a235refugo(codMotivo)
Local aTabGen := {}
Local nI      := 0
Local nTamNum	:= TamSX3("X5_CHAVE")[1]
Local cMotivo := ''  

If campoCYO()
	CYO->(DbSetOrder(1))
	If CYO->(dbSeek(xFilial("CYO")+codMotivo))
		cMotivo := CYO->CYO_DSRF 
	EndIF
Else
	aTabGen := FWGetSX5('43')

	nI := ASCAN(aTabGen, {|x| x[3]==Padr(codMotivo,nTamNum)}) 

	If nI > 0 
		cMotivo := aTabGen[nI][4]
	Else
		cMotivo := ' '
	Endif
EndIF

Return cMotivo


Static Function fCusto(cSeqSD3)
Local aArea := GetArea()

If SD3->(dbSetOrder(4), dbSeek(xFilial("SD3")+cSeqSD3))
	nCusto := SD3->D3_CUSTO1
Else
	nCusto := 0.00
Endif

RestArea(aArea)
Return nCusto
