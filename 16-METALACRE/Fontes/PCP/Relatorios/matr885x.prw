#INCLUDE "matr885.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MATR885   � Autor �Felipe Nunes Toledo    � Data � 24/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio de Produtividade.                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������           
*/
User Function XMATR885()
Local   oReport
Private cAliasSH6
Private cTpHr     := GetMV("MV_TPHR")
Private bConv     := {|x| A680ConvHora(x,"C",cTpHr) }

//If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
//Else
//	MATR885R3()
//EndIf

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Felipe Nunes Toledo    � Data �24/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATR885			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local oReport
Local oSection
Local oSection2
Local oSection3

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
oReport:= TReport():New("MATR885",OemToAnsi(STR0001),"MTR885", {|oReport| ReportPrint(oReport)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)+" "+OemToAnsi(STR0004)) //##"Emite a rela��o de produtividade por operador, de acordo com o c�lculo de percentual que pode ser alterado pelo usuario, j� que a rotina � RDMAKE."
oReport:SetPortrait() //Define a orientacao de pagina do relatorio como retrato.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas (MTR860)                  �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Horas Trabalhadas/Dia					     �
//� mv_par02     // De  Operador							     �
//� mv_par03     // Ate Operador                                 �
//� mv_par04     // De  Data                                     �
//� mv_par05     // Ate Data                                     �
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

//�������������������������������������������������������������Ŀ
//� Secao 1 (oSection)                                          �
//���������������������������������������������������������������
oSection := TRSection():New(oReport,STR0018,{"SH6","SC2"},/*Ordem*/) //"Apontamento de produ��o PCP"
oSection:SetHeaderPage()

TRCell():New(oSection,'H6_OPERADO' 	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'H6_DTAPONT' 	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'HrPadrao'  	,'SH6', STR0014  ,PesqPict("SH6","H6_TEMPO",6),/*Tamanho*/,/*lPixel*/,{|| mv_par01 } )
TRCell():New(oSection,'H6_TEMPO'   	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'H6_OP'   	,'SH6',/*Titulo*/,PesqPict("SH6","H6_OP",11),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'H6_PRODUTO' 	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'H6_RECURSO' 	,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'C2_QUANT'   	,'SC2', STR0015  ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'QtdReal'  	,'SD3', STR0016  ,PesqPictQt("H6_QTDPROD",16),/*Tamanho*/,/*lPixel*/, {|| (cAliasSH6)->H6_QTDPROD+(cAliasSH6)->H6_QTDPERD } )
TRCell():New(oSection,'Eficiencia' 	,'SD3', STR0017  , '',/*Tamanho*/,/*lPixel*/, {|| StrZero((((cAliasSH6)->H6_QTDPROD+(cAliasSH6)->H6_QTDPERD)/If(cAliasSH6=='SH6',SC2->C2_QUANT,(cAliasSH6)->C2_QUANT))*100,6,2) } )

//�������������������������������������������������������������Ŀ
//� Secao 2 (oSection3) Detalhe Operadores Tabela PWI                                          �
//���������������������������������������������������������������
oSection3 := TRSection():New(oReport,'Detalhe Operadores',{"PWI"},/*Ordem*/) //"Apontamento de produ��o PCP"
oSection3:SetHeaderPage()

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

//��������������������������������������������������������������Ŀ
//� Secao 2 (oSection2) - Totais por Operador                    �
//����������������������������������������������������������������
oSection2:=TRSection():New(oSection,STR0019,{"SH6"},/*aOrdem*/)  //"Totais por Operador"
oSection2:SetHeaderPage(.F.)
oSection2:SetHeaderSection(.F.)
TRCell():New(oSection2,'H6_OPERADO'	 ,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'txtHora'	 ,'SH6',/*Titulo*/,/*Picture*/, 11        ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'TEMPOPADRAO' ,'SH6', STR0014  ,PesqPict("SH6","H6_TEMPO",6),/*Tamanho*/,/*lPixel*/,{|| mv_par01 } )
TRCell():New(oSection2,'TEMPOREAL' 	 ,'SH6','Tempo Real',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'Produtivi'	 ,'SH6',/*Titulo*/,/*Picture*/, 20        ,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Felipe Nunes Toledo  � Data �24/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR885			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)
Local oSection  := oReport:Section(1)
Local oSection3 := oReport:Section(2)
Local oSection2 := oReport:Section(1):Section(1)
Local nTotHr    := 0
Local lFirst    := .T.
Local dDia
Local cOperador
Local oBreak
Local cWhere01  := ""

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas na totalizacao do relatorio             �
//����������������������������������������������������������������
Private cTotProd		:="000:00"
Private cPerc			:="0 %"
Private cHorasDia   	:=mv_par01
Private nDias			:=0

//�����������������������������������������Ŀ
//�Definindo a Quebra Por Operador          �
//�������������������������������������������
oBreak := TRBreak():New(oSection,oSection:Cell('H6_OPERADO'),NIL,.T.)

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP
	
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)

	//��������������������������������������������������������������Ŀ
	//� Condicao Where para filtrar OP's                             �
	//����������������������������������������������������������������
	cWhere01 := "%"
	If	Upper(TcGetDb()) $ 'ORACLE,DB2,POSTGRES,INFORMIX'
		cWhere01  += "SC2.C2_NUM = SUBSTR(SH6.H6_OP,1,6) AND "
		cWhere01  += "SC2.C2_ITEM = SUBSTR(SH6.H6_OP,7,2) AND "
		cWhere01  += "SC2.C2_SEQUEN = SUBSTR(SH6.H6_OP,9,3) AND "
		cWhere01  += "SC2.C2_ITEMGRD = SUBSTR(SH6.H6_OP,12,2)"
	Else
		cWhere01  += "SC2.C2_NUM = SUBSTRING(SH6.H6_OP,1,6) AND "
		cWhere01  += "SC2.C2_ITEM = SUBSTRING(SH6.H6_OP,7,2) AND "
		cWhere01  += "SC2.C2_SEQUEN = SUBSTRING(SH6.H6_OP,9,3) AND "
		cWhere01  += "SC2.C2_ITEMGRD = SUBSTRING(SH6.H6_OP,12,2)"
	EndIf
	cWhere01 += "%"
	
	//������������������������������������������������������������������������Ŀ
	//�Query do relatorio da secao 1                                           �
	//��������������������������������������������������������������������������
	
	oSection:BeginQuery()	
	
	cAliasSH6 := GetNextAlias()
	
 	BeginSql Alias cAliasSH6

	SELECT SH6.*,
	       SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_QUANT 

	FROM %table:SH6% SH6, %table:SC2% SC2

	WHERE SH6.H6_FILIAL = %xFilial:SH6% AND
	      SC2.C2_FILIAL = %xFilial:SC2% AND
  		  SH6.H6_OPERADO >= %Exp:mv_par02% AND
  		  SH6.H6_OPERADO <= %Exp:mv_par03% AND
	 	  SH6.H6_DTAPONT >= %Exp:mv_par04% AND
	 	  SH6.H6_DTAPONT <= %Exp:mv_par05% AND
		  SH6.H6_TIPO In ('P',' ') AND
		  SH6.%NotDel% AND
		  SC2.%NotDel% AND
		  %Exp:cWhere01%
						 

	ORDER BY H6_FILIAL, H6_OPERADO, H6_DTAPONT

	EndSql 

	oSection:EndQuery()
#ELSE
	cAliasSH6 := "SH6"
	dbSelectArea(cAliasSH6)    

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao ADVPL                          �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:uParam)

	//��������������������������������������������������������������Ŀ
	//� Condicao de Filtragem do SH6                                 �
	//����������������������������������������������������������������
	cCondicao := 'H6_FILIAL=="'+xFilial("SH6")+'".And.H6_TIPO$"P ".And.'
	cCondicao += 'H6_OPERADO>="'+mv_par02+'".And.H6_OPERADO<="'+mv_par03+'".And.'
	cCondicao += 'DTOS(H6_DTAPONT)>="'+DTOS(mv_par04)+'".And.DTOS(H6_DTAPONT)<="'+DTOS(mv_par05)+'"'
	
	oReport:Section(1):SetFilter(cCondicao,"H6_FILIAL+H6_OPERADO+DTOS(H6_DTAPONT)")

	//�����������������������������Ŀ
	//�Posicionamento da tabela SC2 �
	//�������������������������������
	TRPosition():New(oSection,"SC2",1,{|| xFilial("SC2") + (cAliasSH6)->H6_OP})
#ENDIF

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������
oReport:SetMeter(SH6->(LastRec()))
oSection:Init()
oSection2:Init()
oSection3:Init()
dbSelectArea(cAliasSH6)
While !oReport:Cancel() .And. !(cAliasSH6)->(Eof())
	cOperador := (cAliasSH6)->H6_OPERADO
	While (cAliasSH6)->H6_FILIAL+(cAliasSH6)->H6_OPERADO == xFilial("SH6")+cOperador
		If lFirst .Or. H6_DTAPONT != dDia
			dDia	:=H6_DTAPONT
			nDias	:=nDias+1
			lFirst:=.F.
		EndIf

		oSection:Cell('H6_TEMPO'):SetValue(TimeH6(NIL, NIL, cAliasSH6))
		If H6_TIPOTEM == 1
			nTotHr += Val(StrTran(A680ConvHora((cAliasSH6)->H6_TEMPO,"N","C"),':','.'))
		ElseIf H6_TIPOTEM == 2
			nTotHr += Val(StrTran((cAliasSH6)->H6_TEMPO,':','.'))
		EndIf
		oReport:IncMeter()
		oSection:PrintLine()                                        
		
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
	// --- Oculta coluna
	oSection2:Cell('H6_OPERADO'):Hide()

	cTotProd := StrTran(StrZero(nTotHr,6,2),".",":")
	R885Perc() // Calcula o Percetual de eficiencia
	oSection2:Cell('txtHora'):SetValue(STR0012)
    oSection2:Cell('TEMPOREAL'):SetValue(Eval(bConv,cTotProd))
    oSection2:Cell('Produtivi'):SetValue(STR0013+cPerc)  //"Produtividade "
    // --- Imprime os Totalizadores por Operador
    oSection2:PrintLine()
    nTotHr := 0
    
    // --- Habilita coluna
    oSection2:Cell('H6_OPERADO'):Show()
EndDo

oSection3:Finish()
oSection2:Finish()
oSection:Finish()
(cAliasSH6)->(DbCloseArea())

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR885  � Autor �Rodrigo de A. Sartorio � Data � 13/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Produtividade                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST/SIGAPCP                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MATR885R3()
//��������������������������������������������������������������Ŀ
//� Variaveis obrigatorias dos programas de relatorio            �
//����������������������������������������������������������������
Local titulo   := STR0001 //"Relatorio de Produtividade"
Local cDesc1   := STR0002 //"Emite a rela��o de produtividade por operador, de acordo com o"
Local cDesc2   := STR0003 //"c�lculo de percentual que pode ser alterado pelo usuario, j� que"
Local cDesc3   := STR0004 //"a rotina � RDMAKE."
Local Tamanho  := "M"
Local cString  := "SH6"
Local wnrel    := "MATR885"
Local aOrd     := {}

//��������������������������������������������������������������Ŀ
//� Variaveis padrao de todos os relatorios         				  �
//����������������������������������������������������������������
Private aReturn:= { STR0005, 1,STR0006, 2, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private nLastKey:= 0
Private cPerg := "MTR885"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Horas Trabalhadas/Dia					     �
//� mv_par02     // De  Operador							     �
//� mv_par03     // Ate Operador                                 �
//� mv_par04     // De  Data                                     �
//� mv_par05     // Ate Data                                     �
//����������������������������������������������������������������
pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

nLastKey:=IIf(LastKey()==27,27,nLastKey)
If nLastKey == 27
   	Return
Endif
SetDefault(aReturn,cString)
nLastKey:=IIf(LastKey()==27,27,nLastKey)
If nLastKey == 27
  	Return
Endif

RptStatus({|lEnd| C885Imp(@lEnd,wnrel,tamanho,titulo)},titulo)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C885IMP  � Autor � Rodrigo de A. Sartorio� Data � 13/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR885  			                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C885Imp(lEnd,wnrel,tamanho,titulo)
//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������

Local nTipo    := 0
Local cRodaTxt := STR0007 //"REGISTRO(S)"
Local nCntImpr := 0
Local cQuebra		:=""
Local lFirst		:=.T.
Local lOperador   :=.T.
Local cCond, dDia
Local cNomArq := CriaTrab("",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas na totalizacao do relatorio             �
//����������������������������������������������������������������
Private cTotProd		:="000:00"
Private cPerc			:="0 %"
Private cHorasDia   	:=mv_par01
Private nDias			:=0


//��������������������������������������������������������������Ŀ
//� Condicao de Filtragem do SH6                                 �
//����������������������������������������������������������������
cCond := 'H6_FILIAL=="'+xFilial("SH6")+'".And.H6_TIPO$"P ".And.'
cCond += 'H6_OPERADO>="'+mv_par02+'".And.H6_OPERADO<="'+mv_par03+'".And.'
cCond += 'DTOS(H6_DTAPONT)>="'+DTOS(mv_par04)+'".And.DTOS(H6_DTAPONT)<="'+DTOS(mv_par05)+'"'



//����������������������������������������������������������Ŀ
//� Cria o indice de trabalho                                �
//������������������������������������������������������������
dbSelectArea("SH6")
IndRegua("SH6",cNomArq,"H6_FILIAL+H6_OPERADO+DTOS(H6_DTAPONT)",,cCond,STR0008) //"Selecionando Registros..."
dbGoTop()

//��������������������������������������������������������������Ŀ
//� Inicializa variaveis para controlar cursor de progressao     �
//����������������������������������������������������������������
SetRegua(LastRec())

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIF(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
li := 80
m_pag := 1

//����������������������������������������������������������Ŀ
//� Cria o cabecalho.                                        �
//������������������������������������������������������������
cabec1 := STR0009 //"DATA     HORAS   HORAS       ORDEM DE    PRODUTO         RECURSO   QUANTIDADE        QUANTIDADE      EFICIENCIA"
cabec2 := STR0010 //"         PADRAO  TRABALHADAS PRODUCAO                              PREVISTA          REAL                %"
*****      XXXXXXXX XXX:XX  XXX:XX      XXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXX  XXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXX     XXX
*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13
*****      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

//����������������������������������������������������������Ŀ
//� Posiciona o Arquivo de OP's na ordem correta.		     �
//������������������������������������������������������������
dbSelectArea("SC2")
dbSetOrder(1)
dbSelectArea("SH6")

Do While !Eof()
	cPerc		:="0 %"
	cTotProd	:="000:00"
	cQuebra	:= H6_FILIAL+H6_OPERADO
	lOperador:=.T.
	Do While !Eof() .And. H6_FILIAL+H6_OPERADO == cQuebra
		If lFirst .Or. H6_DTAPONT != dDia
			dDia	:=H6_DTAPONT
			nDias	:=nDias+1
			lFirst:=.F.
		EndIf
		IncRegua()
		If li > 58
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		If lOperador
			@ li,000 PSay STR0011+H6_OPERADO //"Operador :"
			lOperador:=.F.
			li:=li+1
		EndIf
		@ li,000 PSay H6_DTAPONT					Picture PesqPict("SH6","H6_DTAPONT",8)
		@ li,009 PSay mv_par01						Picture PesqPict("SH6","H6_TEMPO",6)
		@ li,017 PSay TimeH6()						Picture PesqPict("SH6","H6_TEMPO",6)  // Converte H6_TEMPO de acordo com MV_TPHR
		@ li,029 PSay H6_OP							Picture PesqPict("SH6","H6_OP",11)
		@ li,041 PSay H6_PRODUTO					Picture PesqPict("SH6","H6_PRODUTO",15)
		@ li,057 PSay H6_RECURSO					Picture PesqPict("SH6","H6_RECURSO",6)
		dbSelectArea("SC2")
		dbSeek(xFilial()+SH6->H6_OP)
		dbSelectArea("SH6")
		@ li,065 PSay SC2->C2_QUANT				Picture PesqPictQt("C2_QUANT",16)
		@ li,083 PSay H6_QTDPROD+H6_QTDPERD		Picture PesqPictQt("H6_QTDPROD",16)
		@ li,103 PSay StrZero(((H6_QTDPROD+H6_QTDPERD)/SC2->C2_QUANT)*100,6,2)
		R885Calc()
		li:=li+1
		dbSkip()
	EndDo
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	R885Perc()
	@ li,000 PSay STR0012 //"Horas:"
	@ li,009 PSay cHorasDia
	@ li,017 PSay A680ConvHora(cTotProd, "C", GetMv("MV_TPHR"))
	@ li,029 PSay STR0013+cPerc //"Produtividade "
	li:=li+2
EndDo

IF li != 80
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
cNomArq :=cNomArq+ OrdBagExt()
Delete File &(cNomArq)

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R885Calc � Autor �Rodrigo de A. sartorio � Data � 13/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Soma tempo do totalizador                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R885Calc()
Local nHORAFIN	:=0
Local nHORAINI	:=0
Local nMinutos	:=0
Local nHoras	:=0
Local cTime		:=""
Local cH6Time   :=TimeH6("C")
nHORAINI := Val(Substr(cTotProd,1,3)+"."+Substr(cTotProd,5,2))
nHORAFIN := Val(Substr(cH6Time ,1,3)+"."+Substr(cH6Time ,5,2))
nMinutos := ((nHORAFIN-Int(nHORAFIN))+(nHORAini-Int(nHORAini)))*100
If Int(nMinutos) < 0
	nMinutos:=60 + nMinutos
	nHoras:=nHoras-1
EndIf
nHoraIni:=Int(nHoraIni)
nHoraFin:=Int(nHoraFin)
nHoras+=Int(nMinutos/100)
nMinutos:=nMinutos%100
cTime := StrZero(((nHoraFin+nHoraIni)+nHoras),3)+":"+StrZero(nMinutos,2)
cTotProd:=cTime

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R885Perc  � Autor �Rodrigo de A. Sartorio � Data � 13/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula percentual de eficiencia                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R885Perc()
Local nHoraProd	    :=0
Local nHoraTot	    :=0

nHoraProd 	:= Val(Substr(cTotProd,1,3)+"."+Substr(cTotProd,5,2))
nHoraTot 	              := Val(Substr(cHorasDia,1,3)+"."+Substr(cHorasDia,5,2))*nDias

cPerc		:= StrZero(((nHoraProd *100)/nHoraTot),3,0)+" %"

Return
