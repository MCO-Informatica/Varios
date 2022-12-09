
#Include "MATR895.CH"
#INCLUDE "FIVEWIN.CH"

Static cTipoTemp
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MATR895   � Autor �Felipe Nunes Toledo    � Data � 03/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio Comparativo Real X Previsto.                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������           
*/
User Function XMATR895()
Local   oReport
Private aOrdem  := {STR0005,STR0006,STR0007,STR0008}	//"Por OP"###"Por Recurso"###"Por Data"###"Por Operador" 

//If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
//Else
//	MATR895R3()
//EndIf

Return NIL
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Felipe Nunes Toledo    � Data �03/07/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATR895			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local oReport
Local oSection1    // Secao 1
Local oSection2    // Secao 2
Local oSection3    // Secao 2
Local cTitle    := OemToAnsi(STR0001) //"Relatorio Comparativo Real X Previsto"
Local cPict     := TimePict()
Local cAliasSH6 := "SH6"
Local lQuery    := .F. 

#IFDEF TOP
	cAliasSH6 := GetNextAlias()
	lQuery    := .T.
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
oReport:= TReport():New("MATR895",cTitle,"MTR895", {|oReport| ReportPrint(oReport,cAliasSH6,lQuery, cTitle)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)+" "+OemToAnsi(STR0004)) //##"Comparativo entre o apontamento real da producao e o planejado,"##"baseando-se no Roteiro de Opera��es.Os valores referentes aos "##"tempos est�o convertidos conforme o parametro MV_TPHR."
oReport:SetLandscape() //Define a orientacao de pagina do relatorio como paisagem.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas (MTR895)                  �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // De  OP									     �
//� mv_par02     // Ate OP									     �
//� mv_par03     // De  Recurso                                  �
//� mv_par04     // Ate Recurso                                  �
//� mv_par05     // De  Data                                     �
//� mv_par06     // Ate Data                                     �
//� mv_par07     // De  Operador                                 �
//� mv_par08     // Ate Operador                                 �
//����������������������������������������������������������������
Pergunte(oReport:GetParam(),.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao das secoes utilizadas pelo relatorio                            �
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

//�������������������������������������������������������������Ŀ
//� Secao 1 (oSection1)                                         �
//���������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0022,{"SH6","SC2","SB1","SH1","SH4","SG2"},aOrdem)
oSection1:SetHeaderPage()

TRCell():New(oSection1,'H6_OP'	    ,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H6_PRODUTO'	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H6_OPERAC'	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'G2_DESCRI'	,'SG2',/*Titulo*/,/*Picture*/, 15        ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H6_RECURSO'	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H1_DESCRI'	,'SH1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H6_FERRAM' 	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H4_DESCRI' 	,'SH4',/*Titulo*/,/*Picture*/, 18        ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H6_OPERADO'	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'C2_QUANT'	,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H6_QTDPROD'	,'SH6',"(*)"+RetTitle("H6_QTDPROD"),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H6_QTDPERD'	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'HoraPrev'	,'SH6', STR0020  , cPict     ,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'HoraReal'	,'SH6', STR0021  , cPict     ,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'H6_DTAPONT'	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)


//�������������������������������������������������������������Ŀ
//� Secao 2 (oSection3) Detalhe Operadores Tabela PWI                                          �
//���������������������������������������������������������������
oSection3 := TRSection():New(oReport,'Detalhe Operadores',{"PWI"},/*Ordem*/) //"Apontamento de produ��o PCP"
oSection3:SetHeaderPage()

TRCell():New(oSection3,'' 	,'PWI','',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'' 	,'PWI','',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'' 	,'PWI','',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'' 	,'PWI','',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'' 	,'PWI','',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'' 	,'PWI','',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'' 	,'PWI','',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'PWI_CODOPE' 	,'PWI','Cod Oper',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'PWI_NOMOPE' 	,'PWI','Nome',/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'PWI_DTINI'   	,'PWI','Dt Inicio',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'PWI_HRINI'   	,'PWI','Hr Inicio',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'PWI_DTFIM'   	,'PWI','Dt Final',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'PWI_HRFIM'   	,'PWI','Hr Final',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'PWI_QTDPRD'   	,'PWI','Qtd Prod',,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'PWI_LINPRD'   	,'PWI','L.Producao?',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

//�������������������������������������������������������������Ŀ
//� Secao 2 (oSection2) - Totalizadora                          �
//���������������������������������������������������������������
oSection2 := TRSection():New(oSection1,STR0019,{"SH6","SC2","SH1","SH4","SG2"},/*aOrdem*/) //"Relatorio Comparativo Real X Previsto"
oSection2:SetHeaderPage(.F.)                 
oSection2:SetHeaderSection(.F.)              

TRCell():New(oSection2,'DescrTot'	,'SH6',STR0019+" "+STR0006,/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'C2_QUANT'	,'SC2',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'H6_QTDPROD'	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'H6_QTDPERD'	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'HoraPrev'	,'SH6', STR0020  , cPict     ,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'HoraReal'	,'SH6', STR0021  , cPict     ,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Felipe Nunes Toledo  � Data �03/07/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �ExpO2: Alias da tabela SH6                                  ���
���          �ExpO3: Define se ira utilizar Query (Top)                   ���
���          �ExpO4: Titulo do Relatorio                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR895	   		                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport, cAliasSH6, lQuery, cTitle)
Local oSection1   := oReport:Section(1)
Local oSection3   := oReport:Section(2)
Local oSection2   := oReport:Section(1):Section(1)
Local nOrdem      := oSection1:GetOrder()
Local cOrderBy
Local cCondicao
Local cCampo
Local cQuebra
Local cRoteiro
Local cHrPrev, cHrReal
Local nTotQtdOp, nTotQtdPrd, nTotQtdPer, nTotHrPrev, nTotHrReal
Local cWhere01

//����������������������������������������������������������������������������������������������Ŀ
//�Definindo a chave de indice para Quebra e o titulo do Relatorio, conforme a Ordem selecionada �
//������������������������������������������������������������������������������������������������
If nOrdem == 1 //"Por OP"
	cOrderBy := If(lQuery,"% H6_FILIAL, H6_OP, H6_DTAPONT %"     ,"H6_FILIAL+H6_OP+DTOS(H6_DTAPONT)"     )
	cCampo   := "H6_FILIAL+H6_OP"
	oReport:SetTitle(cTitle+"   "+"("+STR0005+")") //"Relatorio Comparativo Real X Previsto"##"Por OP"
Elseif nOrdem == 2 //"Por Recurso"
	cOrderBy := If(lQuery,"% H6_FILIAL, H6_RECURSO, H6_DTAPONT %","H6_FILIAL+H6_RECURSO+DTOS(H6_DTAPONT)")
	cCampo   := "H6_FILIAL+H6_RECURSO"
	oReport:SetTitle(cTitle+"   "+"("+STR0006+")") //"Relatorio Comparativo Real X Previsto"##"Por Recurso"
Elseif nOrdem == 3 //"Por Data" 
	cOrderBy := If(lQuery,"% H6_FILIAL, H6_DTAPONT, H6_RECURSO %","H6_FILIAL+DTOS(H6_DTAPONT)+H6_RECURSO")
	cCampo   := "H6_FILIAL+DTOS(H6_DTAPONT)"
	oReport:SetTitle(cTitle+"   "+"("+STR0007+")") //"Relatorio Comparativo Real X Previsto"##"Por Data"
Elseif nOrdem == 4 //"Por Operador"
	cOrderBy := If(lQuery,"% H6_FILIAL, H6_OPERADO, H6_DTAPONT %","H6_FILIAL+H6_OPERADO+DTOS(H6_DTAPONT)")
	cCampo   := "H6_FILIAL+H6_OPERADO"
	oReport:SetTitle(cTitle+"   "+"("+STR0008+")") //"Relatorio Comparativo Real X Previsto"##"Por Operador"	
Endif

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������
If lQuery == .T.
	
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:GetParam())

	//��������������������������������������������������������������Ŀ
	//� Condicao Where para filtrar OP's                             �
	//����������������������������������������������������������������
	cWhere01 := "%"
	If	Upper(TcGetDb()) $ 'ORACLE,DB2,POSTGRES,INFORMIX'
		cWhere01  += "SC2.C2_ITEM = SUBSTR(SH6.H6_OP,7,2) AND "
		cWhere01  += "SC2.C2_SEQUEN = SUBSTR(SH6.H6_OP,9,3) AND "
		cWhere01  += "SC2.C2_ITEMGRD = SUBSTR(SH6.H6_OP,12,2)"
	Else
		cWhere01  += "SC2.C2_ITEM = SUBSTRING(SH6.H6_OP,7,2) AND "
		cWhere01  += "SC2.C2_SEQUEN = SUBSTRING(SH6.H6_OP,9,3) AND "
		cWhere01  += "SC2.C2_ITEMGRD = SUBSTRING(SH6.H6_OP,12,2)"
	EndIf
	cWhere01 += "%"

	//������������������������������������������������������������������������Ŀ
	//�Query do relatorio                                                      �
	//��������������������������������������������������������������������������

 	BEGIN REPORT QUERY oSection1
 	BeginSql Alias cAliasSH6

	SELECT SH6.H6_FILIAL, SH6.H6_OP, SH6.H6_PRODUTO, SH6.H6_OPERAC, SH6.H6_RECURSO, SH6.H6_FERRAM, SH6.H6_OPERADO,
       SH6.H6_QTDPROD, SH6.H6_QTDPERD, SH6.H6_DTAPONT, SH6.H6_TIPO, SH6.H6_TEMPO, SH6.H6_TIPOTEM,
       SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_QUANT, SC2.C2_ROTEIRO,
       SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_OPERPAD,
       SH1.H1_FILIAL, SH1.H1_CODIGO, SH1.H1_DESCRI, SH1.H1_MAOOBRA,
       SH4.H4_FILIAL, SH4.H4_CODIGO, SH4.H4_DESCRI, SH6.R_E_C_N_O_ 

		FROM %table:SH6% SH6
		
		LEFT JOIN %table:SC2% SC2 ON
  		SC2.C2_FILIAL = %xFilial:SC2% AND SC2.C2_NUM = SUBSTRING(SH6.H6_OP,1,6) AND %Exp:cWhere01% AND	SC2.%NotDel%
		
		LEFT JOIN %table:SB1% SB1 ON
  		SB1.B1_FILIAL = %xFilial:SB1% AND SB1.B1_COD = SH6.H6_PRODUTO AND SB1.%NotDel%
		
		LEFT JOIN %table:SH1% SH1 ON
  		SH1.H1_FILIAL = %xFilial:SH1% AND SH1.H1_CODIGO = SH6.H6_RECURSO AND SH1.%NotDel%
		
		LEFT JOIN %table:SH4% SH4 ON
  		SH4.H4_FILIAL = %xFilial:SH4% AND SH4.H4_CODIGO = SH6.H6_FERRAM AND SH4.%NotDel%
		
		WHERE SH6.H6_FILIAL  = %xFilial:SH6% AND
  		SH6.H6_OP >= %Exp:mv_par01% AND
 		SH6.H6_OP <= %Exp:mv_par02% AND
		SH6.H6_RECURSO >= %Exp:mv_par03% AND
		SH6.H6_RECURSO <= %Exp:mv_par04% AND
		SH6.H6_DTAPONT >= %Exp:mv_par05% AND
		SH6.H6_DTAPONT <= %Exp:mv_par06% AND
		SH6.H6_OPERADO >= %Exp:mv_par07% AND
		SH6.H6_OPERADO <= %Exp:mv_par08% AND
		SH6.H6_TIPO In ('P',' ' ) AND
		SH6.%NotDel%

		ORDER BY %Exp:cOrderBy%

	EndSql 
	END REPORT QUERY oSection1 

Else
    
	dbSelectArea(cAliasSH6)
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao ADVPL                          �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:GetParam())
	
	//��������������������������������������������������������������Ŀ
	//� Condicao de Filtragem do SH6                                 �
	//����������������������������������������������������������������
	cCondicao := 'H6_FILIAL=="'+xFilial("SH6")+'".And.H6_TIPO$" P".And.'
	cCondicao += 'H6_OP>="'+mv_par01+'".And.H6_OP<="'+mv_par02+'".And.'
	cCondicao += 'H6_RECURSO>="'+mv_par03+'".And.H6_RECURSO<="'+mv_par04+'".And.'
	cCondicao += 'DTOS(H6_DTAPONT)>="'+DTOS(mv_par05)+'".And.DTOS(H6_DTAPONT)<="'+DTOS(mv_par06)+'".And.'
	cCondicao += 'H6_OPERADO>="'+mv_par07+'".And.H6_OPERADO<="'+mv_par08+'"'

	oSection1:SetFilter(cCondicao,cOrderBy)
	
	//�����������������������������Ŀ
	//�Posicionamento das tabelas   �
	//�������������������������������
	TRPosition():New(oSection1,"SC2",1,{|| xFilial("SC2")+(cAliasSH6)->H6_OP      })
	TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1")+(cAliasSH6)->H6_PRODUTO })
	TRPosition():New(oSection1,"SH1",1,{|| xFilial("SH1")+(cAliasSH6)->H6_RECURSO })
	TRPosition():New(oSection1,"SH4",1,{|| xFilial("SH4")+(cAliasSH6)->H6_FERRAM  })

EndIf

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������
oReport:SetMeter( SH6->(LastRec()) )
oSection1:Init()
oSection3:Init()
oSection2:Init()
dbSelectArea(cAliasSH6)
While !oReport:Cancel() .And. !(cAliasSH6)->(Eof())
	nTotQtdOp	:= 0
	nTotQtdPrd	:= 0
	nTotQtdPer	:= 0
	nTotHrPrev	:= 0	
	nTotHrReal	:= 0
	cQuebra:=&(cCampo)
	Do While !Eof() .And. &(cCampo) == cQuebra
		If !lQuery
			dbSelectArea("SC2")
			dbSeek(xFilial("SC2")+(cAliasSH6)->H6_OP)
		EndIf
		If !Empty(C2_ROTEIRO)
			cRoteiro:=C2_ROTEIRO
		Else
			If !lQuery
				dbSelectArea("SB1")
				dbSeek(xFilial("SB1")+(cAliasSH6)->H6_PRODUTO)
			EndIf
			cRoteiro:=B1_OPERPAD
		EndIf		
		
		If Empty(cRoteiro)
			cRoteiro := StrZero(1, Len(SG2->G2_CODIGO))
		Endif	

		dbSelectArea("SG2")    
		a630SeekSG2(1,(cAliasSH6)->H6_PRODUTO,xFilial("SG2")+(cAliasSH6)->(H6_PRODUTO+cRoteiro+H6_OPERAC))
		dbSelectArea(cAliasSH6)
		
		cHrPrev		:= R895Calc(cAliasSH6)
		cHrReal		:= TimeH6(NIL, NIL, cAliasSH6)
		If cTipoTemp == "C"
			cHrReal := Val(StrTran(cHrReal, ":", "."))
		EndIf
		oSection1:Cell("G2_DESCRI"):SetValue( SG2->G2_DESCRI )
		oSection1:Cell("HoraPrev"):SetValue( cHrPrev )
		oSection1:Cell("HoraReal"):SetValue( cHrReal )
        
		// Definindo os totalizadores	
		nTotQtdOp	+= If(lQuery,(cAliasSH6)->C2_QUANT,SC2->C2_QUANT)
		nTotQtdPrd	+= (cAliasSH6)->H6_QTDPROD
		nTotQtdPer	+= (cAliasSH6)->H6_QTDPERD
		nTotHrPrev	+= If(cTipoTemp=="N",Val(StrTran(A680ConvHora(cHrPrev, "N", "C"), ":", ".")),cHrPrev)
		nTotHrReal	+= If(cTipoTemp=="N",Val(StrTran(A680ConvHora(cHrReal, "N", "C"), ":", ".")),cHrReal)

		oReport:IncMeter()
		oSection1:PrintLine() // Impressao da secao 1		


		If PWI->(dbSetOrder(1), DbSeek(xFilial('PWI')+StrZero((cAliasSH6)->R_E_C_N_O_,10)))
			oReport:SkipLine()                                        
			While PWI->(!Eof()) .And. PWI->PWI_FILIAL == xFilial("PWI") .And. PWI->PWI_RECSH6 == StrZero((cAliasSH6)->R_E_C_N_O_,10)

				oSection3:Cell('PWI_CODOPE'):SetValue(PWI->PWI_CODOPE)			
				oSection3:Cell('PWI_NOMOPE'):SetValue(PWI->PWI_NOMOPE)			
				oSection3:Cell('PWI_DTINI'):SetValue(DtoC(PWI->PWI_DTINI))			
				oSection3:Cell('PWI_HRINI'):SetValue(PWI->PWI_HRINI)			
				oSection3:Cell('PWI_DTFIM'):SetValue(DtoC(PWI->PWI_DTFIM))			
				oSection3:Cell('PWI_HRFIM'):SetValue(PWI->PWI_HRFIM)			
				oSection3:Cell('PWI_QTDPRD'):SetValue(TransForm(PWI->PWI_QTDPRD,"9999999"))			
				oSection3:Cell('PWI_LINPRD'):SetValue(Iif(PWI->PWI_LINPRD=='S','Sim','Nao'))			

				oSection3:PrintLine()
				
				PWI->(dbSkip(1))
			Enddo
			oReport:SkipLine()                                        
		Endif

		dbSkip()
	EndDo
	oReport:SkipLine()
           
    oSection2:Cell('C2_QUANT'  ):SetValue( nTotQtdOp  )
    oSection2:Cell('H6_QTDPROD'):SetValue( nTotQtdPrd ) 
    oSection2:Cell('H6_QTDPERD'):SetValue( nTotQtdPer )                       
    oSection2:Cell('HoraPrev'  ):SetValue(If(cTipoTemp=="N",AjustaHora(A680ConvHora(AllTrim(Str(nTotHrPrev)), "C", "N"),9),nTotHrPrev))
    oSection2:Cell('HoraReal'  ):SetValue(If(cTipoTemp=="N",AjustaHora(A680ConvHora(AllTrim(Str(nTotHrReal)), "C", "N"),9),nTotHrReal))
    oSection2:Cell('DescrTot'  ):SetValue( STR0019+" "+aOrdem[nOrdem]+":"  ) 
    
    
	If oSection1:Cell('C2_QUANT'):lVisible 
		oSection2:Cell('C2_QUANT'  ):nCol := oSection1:Cell('C2_QUANT'  ):nCol	
		oSection2:Cell('DescrTot'  ):nCol := oSection1:Cell('C2_QUANT'  ):nCol - 350
	EndIf
	
	If oSection1:Cell('H6_QTDPROD'  ):lVisible
		oSection2:Cell('H6_QTDPROD'  ):nCol := oSection1:Cell('H6_QTDPROD'  ):nCol
	EndIf
	
	If oSection1:Cell('H6_QTDPERD'  ):lVisible
		oSection2:Cell('H6_QTDPERD'  ):nCol := oSection1:Cell('H6_QTDPERD'  ):nCol
	EndIf
	
	If oSection1:Cell('HoraPrev'  ):lVisible
		oSection2:Cell('HoraPrev'  ):nCol := oSection1:Cell('HoraPrev'  ):nCol
	EndIf	
	
	If oSection1:Cell("HoraReal"  ):lVisible
		oSection2:Cell("HoraReal"  ):nCol := oSection1:Cell("HoraReal"  ):nCol
	EndIf
		
	oSection2:PrintLine() // Impressao da secao 2
	If !(cAliasSH6)->(Eof())
   		oReport:SkipLine()
		oReport:ThinLine()
	EndIf
EndDo

If !oReport:Cancel()
	oReport:SkipLine()
	oReport:PrintText("(*)"+STR0023, oReport:Row(), 000 ) // "Total QUANTIDADE PRODUZIDA � igual a somat�ria de todos os"
	oReport:SkipLine()
	oReport:PrintText("   "+STR0024, oReport:Row(), 000 ) // "apontamentos, conforme a quebra definida para impress�o"
EndIf

oSection1:Finish()
oSection2:Finish()
oSection3:Finish()
(cAliasSH6)->(DbCloseArea())

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA                                 ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data         |BOPS:		      ���
�������������������������������������������������������������������������Ĵ��
���      01  �                          �              |                  ���
���      02  �Erike Yuri da Silva       �07/02/2006    |00000092906       ���
���      03  �Erike Yuri da Silva       �22/03/2006    |00000095536       ���
���      04  �                          �              |                  ���
���      05  �                          �              |                  ���
���      06  �                          �              |                  ���
���      07  �                          �              |                  ���
���      08  �                          �              |                  ���
���      09  �Erike Yuri da Silva       �07/02/2006    |00000092906       ���
���      10  �Erike Yuri da Silva       �22/03/2006    |00000095536       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/	

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR895  � Autor �Rodrigo de A. Sartorio � Data � 14/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio Comparativo Real X Previsto                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPCP                                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Rodrigo Sart�26/10/98�16974A� Acerto na impressao do tempo previsto    ���
���Rodrigo Sart�04/11/98�XXXXXX� Acerto p/ Bug Ano 2000                   ���
���Cesar       �31/03/99�XXXXXX�Manutencao na SetPrint()                  ���
���Patricia Sal�18/04/00�003265�Imprimir Cod/Descr. da Ferramenta.        ���
���Iuspa       �03/10/00�005389�Imprimir Quantidade de Perda da Produ��o  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MATR895R3()
//��������������������������������������������������������������Ŀ
//� Variaveis obrigatorias dos programas de relatorio            �
//����������������������������������������������������������������
LOCAL Tamanho  := "G"
LOCAL titulo   := STR0001	//"Relatorio Comparativo Real X Previsto"
LOCAL cDesc1   := STR0002	//"Comparativo entre o apontamento real da producao e o planejado,"
LOCAL cDesc2   := STR0003	//"baseando-se no Roteiro de Opera��es.Os valores referentes aos "
LOCAL cDesc3   := STR0004	//"tempos est�o convertidos conforme o parametro MV_TPHR."
LOCAL cString  := "SH6"
LOCAL aOrd     := {STR0005,STR0006,STR0007,STR0008}	//"Por OP"###"Por Recurso"###"Por Data"###"Por Operador"
LOCAL wnrel    := "MATR895"

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
PRIVATE aReturn:= {STR0009,1,STR0010, 2, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0 ,cPerg := "MTR895"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas - MTR895                  �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // De  OP									     �
//� mv_par02     // Ate OP									     �
//� mv_par03     // De  Recurso                                  �
//� mv_par04     // Ate Recurso                                  �
//� mv_par05     // De  Data                                     �
//� mv_par06     // Ate Data                                     �
//� mv_par07     // De  Operador                                 �
//� mv_par08     // Ate Operador                                 �
//����������������������������������������������������������������
pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C895Imp(aOrd,@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C895IMP  � Autor � Rodrigo de A. Sartorio� Data � 14/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR895  			                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C895Imp(aOrd,lEnd,WnRel,titulo,Tamanho)
//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������

LOCAL nTipo    := 0
LOCAL cRodaTxt := STR0011	//"REGISTRO(S)"
LOCAL nCntImpr := 0
LOCAL cQuebra,cCampo,cMens
LOCAL cIndex,cRoteiro
LOCAL cHrReal	:= "0000:00"
LOCAL cHrPrev	:= "0000:00"
LOCAL nTotHrReal:= 0
LOCAL nTotHrPrev:= 0
LOCAL nTotQtdOp	:= 0
LOCAL nTotQtdPrd:= 0
LOCAL nTotQtdPer:= 0

//��������������������������������������������������������������Ŀ
//� Condicao de Filtragem do SH6                                 �
//����������������������������������������������������������������
LOCAL cCond := 'H6_FILIAL=="'+xFilial("SH6")+'".And.H6_TIPO$" P".And.'
		cCond += 'H6_OP>="'+mv_par01+'".And.H6_OP<="'+mv_par02+'".And.'
		cCond += 'H6_RECURSO>="'+mv_par03+'".And.H6_RECURSO<="'+mv_par04+'".And.'
		cCond += 'DTOS(H6_DTAPONT)>="'+DTOS(mv_par05)+'".And.DTOS(H6_DTAPONT)<="'+DTOS(mv_par06)+'"'
//��������������������������������������������������������������Ŀ
//� Indice Condicional de acordo com a ordem selecionada.        �
//����������������������������������������������������������������
If aReturn[8] = 1
	cIndex:="H6_FILIAL+H6_OP+DTOS(H6_DTAPONT)"
	cCampo:="H6_FILIAL+H6_OP"
	cMens:=STR0012	//"da OP:"
ElseIf aReturn[8] = 2
	cIndex:="H6_FILIAL+H6_RECURSO+DTOS(H6_DTAPONT)"
	cCampo:="H6_FILIAL+H6_RECURSO"
	cMens:=STR0013	//"do Recurso:"
ElseIf aReturn[8] = 3
	cIndex:="H6_FILIAL+DTOS(H6_DTAPONT)+H6_RECURSO"
	cCampo:="H6_FILIAL+DTOS(H6_DTAPONT)"
	cMens:=STR0014	//"da Data:"
ElseIf aReturn[8] = 4
	cIndex:="H6_FILIAL+H6_OPERADO+DTOS(H6_DTAPONT)"
	cCampo:="H6_FILIAL+H6_OPERADO"
	cMens:=STR0015	//"do Operador:"
EndIf

//����������������������������������������������������������Ŀ
//� Pega o nome do arquivo de indice de trabalho             �
//������������������������������������������������������������
cNomArq := CriaTrab("",.F.)

If cTipoTemp == Nil
	cTipoTemp:=GetMV("MV_TPHR")
EndIf

//����������������������������������������������������������Ŀ
//� Cria o indice de trabalho                                �
//������������������������������������������������������������
dbSelectArea("SH6")
IndRegua("SH6",cNomArq,cIndex,,cCond,STR0016)	//"Selecionando Registros..."
dbGoTop()

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
cabec1 := STR0017  // "ORDEM DE      PRODUTO         OPERACAO DESCRICAO          RECURSO                                FERRAMENTA                OPERADOR     QUANTIDADE     (*)QUANTIDADE        QUANTIDADE        TEMPO     TEMPO   DATA DO"
cabec2 := STR0018  //"PRODUCAO                               DA OPERACAO                                                                                      TOTAL DA OP       PRODUZIDA         PERDA             ESTIMADO  REAL    APONTAMENTO"

*****                 1234567890123 123456789012345    12    123456789012345678 123456 123456789012345678901234567890  123456 123456789012345678 1234567890   1234567890123456  1234567890123456  1234567890123456  123456    123456  1234567890
*****                 0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
*****                 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

//���������������������������������������������������������������������Ŀ
//� Posiciona os arquivos que serao utilizados na ordem correta para    �
//� listar o relatorio.                                                 �
//�����������������������������������������������������������������������
dbSelectArea("SC2")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SH6")

Do While !Eof()
	If H6_OPERADO < mv_par07 .Or. H6_OPERADO > mv_par08
		dbSkip()
		Loop
	EndIf	
	cHrReal		:= If(cTipoTemp=="N","0000:00",0)
	cHrPrev		:= cHrReal
	nTotHrReal	:= 0
	nTotHrPrev	:= 0	
	nTotQtdOp	:= 0
	nTotQtdPrd	:= 0
	nTotQtdPer	:= 0
	cQuebra:=&(cCampo)
	Do While !Eof() .And. &(cCampo) == cQuebra
		If H6_OPERADO < mv_par07 .Or. H6_OPERADO > mv_par08
			dbSkip()
			Loop
		EndIf
		If li > 58
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		dbSelectArea("SH1")
		dbSeek(xFilial("SH1")+SH6->H6_RECURSO)
		dbSelectArea("SH4")
		dbSeek(xFilial("SH4")+SH6->H6_FERRAM)		
		dbSelectArea("SC2")
		dbSeek(xFilial("SC2")+SH6->H6_OP)
		If !Empty(C2_ROTEIRO)
			cRoteiro:=C2_ROTEIRO
		Else
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SH6->H6_PRODUTO)
			cRoteiro:=B1_OPERPAD
		EndIf		

		If Empty(cRoteiro)
			cRoteiro := StrZero(1, Len(SG2->G2_CODIGO))
		Endif	

		dbSelectArea("SG2")
		a630SeekSG2(1,SH6->H6_PRODUTO,xFilial("SG2")+SH6->H6_PRODUTO+cRoteiro+SH6->H6_OPERAC)
		dbSelectArea("SH6")
		cHrReal		:= R895Calc()
		cHrPrev		:= TimeH6()
		If cTipoTemp == "C"
			cHrPrev := Val(StrTran(cHrPrev, ":", "."))
		EndIf

		@ li,000 PSay Substr(H6_OP,1,13)				Picture PesqPict("SH6","H6_OP",13)
		@ li,014 PSay Substr(H6_PRODUTO,1,15)    		Picture PesqPict("SH6","H6_PRODUTO",15)
		@ li,033 PSay Substr(H6_OPERAC,1,2)				Picture PesqPict("SH6","H6_OPERAC",2)
		@ li,039 PSay Substr(SG2->G2_DESCRI,1,18)		Picture PesqPict("SG2","G2_DESCRI",20)
		@ li,058 PSay H6_RECURSO						Picture PesqPict("SH6","H6_RECURSO",6)
		@ li,065 PSay Substr(SH1->H1_DESCRI,1,30)
		@ li,097 Psay H6_FERRAM                         Picture PesqPict("SH6", "H6_FERRAM")
		@ li,104 PSay Substr(SH4->H4_DESCRI,1,18)
		@ li,123 PSay Substr(SH6->H6_OPERADO,1,10)      Picture PesqPict("SH6", "H6_OPERADO")
		@ li,136 PSay SC2->C2_QUANT						Picture PesqPictQt("C2_QUANT",16)
		@ li,154 PSay H6_QTDPROD             			Picture PesqPictQt("H6_QTDPROD",16)
		@ li,172 PSay H6_QTDPERD             			Picture PesqPictQt("H6_QTDPERD",16)
		@ li,190 PSay cHrReal							Picture TimePict()
		@ li,200 PSay cHrPrev							Picture If(cTipoTemp == "C",TimePict(),"@!")    // Converte campo H6_TEMPO para normal
		@ li,208 PSay H6_DTAPONT						Picture PesqPict("SH6","H6_DTAPONT",8)

		nTotHrReal	+= If(cTipoTemp=="N", Val(StrTran(A680ConvHora(cHrReal, "N", "C"), ":", ".")),cHrReal)
		nTotHrPrev	+= If(cTipoTemp=="N",Val(StrTran(A680ConvHora(cHrPrev, "N", "C"), ":", ".")),cHrPrev)

		nTotQtdOp	+= SC2->C2_QUANT	    	
		nTotQtdPrd	+= H6_QTDPROD
		nTotQtdPer	+= H6_QTDPERD		
		li++
		dbSkip()
	EndDo

	If !Empty(nTotQtdOp+nTotQtdPrd+nTotQtdPer)
		li++
		@ li,110 PSay STR0019+cMens   //"Totalizador "
		@ li,136 PSay nTotQtdOp					Picture PesqPictQt("C2_QUANT",16)
		@ li,154 PSay nTotQtdPrd            	Picture PesqPictQt("H6_QTDPROD",16)
		@ li,172 PSay nTotQtdPer            	Picture PesqPictQt("H6_QTDPERD",16)
		@ li,190 PSay If(cTipoTemp=="N",AjustaHora(A680ConvHora(AllTrim(Str(nTotHrReal)), "C", "N"),9),nTotHrReal)		Picture TimePict()
		@ li,200 PSay If(cTipoTemp=="N",AjustaHora(A680ConvHora(AllTrim(Str(nTotHrPrev)), "C", "N"),9),nTotHrPrev)		Picture TimePict()
		li+=3
	Else			
		li++
	EndIf
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
EndDo

IF li != 80
	@ 55,000 PSay "(*)"+STR0023 // "Total QUANTIDADE PRODUZIDA � igual a somat�ria de todos os"
	@ 56,000 PSay "   "+STR0024 // "apontamentos, conforme a quebra definida para impress�o"
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF

//��������������������������������������������������������������Ŀ
//� Devolve as ordens originais do arquivo                       �
//����������������������������������������������������������������
RetIndex("SH6")
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R895Calc � Autor �Rodrigo de A. sartorio � Data � 14/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Soma tempo do totalizador                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R895Calc(cAliasSH6)
Local nLotPad := If(SG2->G2_LOTEPAD==0,1,SG2->G2_LOTEPAD)
Local nTemPad := If(SG2->G2_TEMPAD ==0,1,SG2->G2_TEMPAD)
Local nTempo  := Nil
Local cTime   := Nil
Local nQuant

Default cAliasSH6 := "SH6"

nQuant  := (cAliasSH6)->(H6_QTDPROD+H6_QTDPERD)

If cTipoTemp == Nil
	cTipoTemp:=GetMV("MV_TPHR")
EndIf

//��������������������������������������������������������������������Ŀ
//� Se MV_TPHR for N (Normal) devo converter G2_TEMPAD para            �
//� centesimal para permitir multiplicar pela quantidade produzida     �
//����������������������������������������������������������������������
If cTipoTemp == "N"
	nTemPad := Int(nTemPad) + (Mod(nTemPad, 1) / 0.6)
Endi

// Calcula Tempo de Dura��o baseado no Tipo de Operacao
If SG2->G2_TPOPER $ " 1"
	nTempo := nQuant * nTemPad / nLotPad
	dbSelectArea("SH1")
	dbSeek(xFilial("SH1")+(cAliasSH6)->H6_RECURSO)
	If Found() .And. SH1->H1_MAOOBRA # 0
		nTempo :=Round( nTempo / H1_MAOOBRA,5)
	EndIf
	dbSelectArea(cAliasSH6)
ElseIf SG2->G2_TPOPER == "4"
	nQuantAloc:= nQuant % nLotPad
	nQuantAloc:= Int(nQuant)+If(nQuantAloc>0,nLotPad-nQuantAloc,0)
	nTempo := Round(nQuantAloc * ( nTemPad / nLotPad ),5)
	dbSelectArea("SH1")
	dbSeek(xFilial("SH1")+(cAliasSH6)->H6_RECURSO)
	If Found() .And. SH1->H1_MAOOBRA # 0
		nTempo :=Round( nTempo / H1_MAOOBRA,5)
	EndIf
	dbSelectArea(cAliasSH6)
ElseIf SG2->G2_TPOPER == "2" .Or. SG2->G2_TPOPER == "3"
	nTempo := nTemPad
EndIf

If cTipoTemp == "N"
	cTime  := StrZero(Int(nTempo), 3) + ":" + StrZero(Mod(nTempo, 1) * 100, 2)
	cTime := A680ConvHora(cTime, "C", "N")
Endif

Return IF(cTipoTemp=="N",cTime,nTempo)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AjustaHora� Autor �Erike Yuri da Silva    � Data � 22/03/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retira zeros a esquerda da hora, limitando a var. nTam     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaHora(cHora,nTam)
Local nLen := Len(cHora) - nTam
While nLen > 0
	nLen--
	If SubStr(cHora,1,1)<>"0"
		Exit
	EndIf
	cHora := Substr(cHora,2,Len(cHora))
EndDo
Return cHora
