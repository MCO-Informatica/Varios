#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RNFINR02  � Impress�o individual do titulo a receber                    ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 04.12.17 � Departamento de sistemas / TI - Renova                       ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 04.12.17 � Fabio Jadao Caires - TRIYO Tecnologia                        ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Impressao individual de um titulo a receber                             ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 04.12.17 - Fabio Jadao Caires - Criacao do relatorio                    ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function RNFINR02()

//�����������������������������������������������������������������������������������������Ŀ
//� Declara��o das vari�veis do progra                                                      �
//�������������������������������������������������������������������������������������������
//Local aDadImp		:= {}
Local aRegs			:= {}
Local lEnd			:= .F.
Local cPerg  		:= "RNFINR02"
Local cQuery        := ''
Local cSql1			:= ""			//trecho de query, implementado de acordo com a condicao utilizada

Private cAliasQry   := GetNextAlias()
Private oPrint
Private nLin		:= 080
Private nCol		:= 200
Private nPagina		:= 0

//�����������������������������������������������������������������������������������������Ŀ
//� Par�metros da Rotina                                                                    �
//� mv_par01   Prefixo do Titulo                                                            �
//� mv_par02   Numero de                                                                       �
//� mv_par03   Numero at�                                                                      �
//� mv_par04   Parcela                                                                      �
//� mv_par05   Tipo
//� mv_par06   Banco  			     		                                                �
//� mv_par07   Agencia	    		 		                                                �
//� mv_par09   Digito Agencia	     		                                                �
//� mv_par09   Conta	     				                                                �
//� mv_par10   Digito Conta 	     		                                                �
//� mv_par11   Imprime Recibo	     		                                                �
//�������������������������������������������������������������������������������������������

aAdd(aRegs,{	cPerg,;										// Grupo de perguntas
"01",;										// Sequencia
"Prefixo de?",;								// Nome da pergunta
"",;										// Nome da pergunta em espanhol
"",;										// Nome da pergunta em ingles
"mv_ch1",;									// Vari�vel
"C",;										// Tipo do campo
03,;										// Tamanho do campo
0,;											// Decimal do campo
0,;											// Pr�-selecionado quando for choice
"G",;										// Tipo de sele��o (Get ou Choice)
"",;										// Valida��o do campo
"MV_PAR01",;								// 1a. Vari�vel dispon�vel no programa
"",;		  								// 1a. Defini��o da vari�vel - quando choice
"",;										// 1a. Defini��o vari�vel em espanhol - quando choice
"",;										// 1a. Defini��o vari�vel em ingles - quando choice
"",;										// 1o. Conte�do vari�vel
"",;										// 2a. Vari�vel dispon�vel no programa
"",;										// 2a. Defini��o da vari�vel
"",;										// 2a. Defini��o vari�vel em espanhol
"",;										// 2a. Defini��o vari�vel em ingles
"",;										// 2o. Conte�do vari�vel
"",;										// 3a. Vari�vel dispon�vel no programa
"",;										// 3a. Defini��o da vari�vel
"",;										// 3a. Defini��o vari�vel em espanhol
"",;										// 3a. Defini��o vari�vel em ingles
"",;										// 3o. Conte�do vari�vel
"",;								  		// 4a. Vari�vel dispon�vel no programa
"",;										// 4a. Defini��o da vari�vel
"",;										// 4a. Defini��o vari�vel em espanhol
"",;										// 4a. Defini��o vari�vel em ingles
"",;										// 4o. Conte�do vari�vel
"",;										// 5a. Vari�vel dispon�vel no programa
"",;										// 5a. Defini��o da vari�vel
"",;										// 5a. Defini��o vari�vel em espanhol
"",;										// 5a. Defini��o vari�vel em ingles
"",;										// 5o. Conte�do vari�vel
"",;										// F3 para o campo
"",;										// Identificador do PYME
"",;										// Grupo do SXG
"",;										// Help do campo
"" })										// Picture do campo
aAdd(aRegs,{cPerg,"02","Prefixo ate?" 				,"","","mv_ch2","C",03,0,0,"G",""				,"MV_PAR02","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"03","Numero de?"    				,"","","mv_ch3","C",09,0,0,"G",""				,"MV_PAR03","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"04","Numero ate?"   				,"","","mv_ch4","C",09,0,0,"G",""				,"MV_PAR04","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"05","Parcela de?"       			,"","","mv_ch5","C",03,0,0,"G",""				,"MV_PAR05","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"06","Parcela ate?"      			,"","","mv_ch6","C",03,0,0,"G",""				,"MV_PAR06","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"07","Natureza de?"      			,"","","mv_ch7","C",06,0,0,"G",""		    	,"MV_PAR07","",			"","","","","","","","","","","","","","","","","","","","","","","","SED"	,"","","","" })
aAdd(aRegs,{cPerg,"08","Natureza ate?"     			,"","","mv_ch8","C",06,0,0,"G",""	    		,"MV_PAR08","",			"","","","","","","","","","","","","","","","","","","","","","","","SED"	,"","","","" })
aAdd(aRegs,{cPerg,"09","Tipo"             			,"","","mv_ch9","C",40,0,0,"G",""				,"MV_PAR09","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"10","Banco"        				,"","","mv_cha","C",03,0,0,"G","U_FNR01BC2()"	,"MV_PAR10","",			"","","","","","","","","","","","","","","","","","","","","","","","SA6"	,"","","","" })
aAdd(aRegs,{cPerg,"11","Agencia"           			,"","","mv_chb","C",05,0,0,"G",""				,"MV_PAR11","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"12","Dig.Age"           			,"","","mv_chc","C",01,0,0,"G",""				,"MV_PAR12","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"13","Conta"             			,"","","mv_chd","C",10,0,0,"G",""				,"MV_PAR13","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"14","Dig.CC."           			,"","","mv_che","C",01,0,0,"G",""				,"MV_PAR14","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
//Incluido Ronaldo Bicudo - Analista Totvs - 20/03/2018
aAdd(aRegs,{cPerg,"15","Imprime Recibo?"   			,"","","mv_chf","N",01,0,2,"C",""				,"MV_PAR15","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","     ","","","","","","!@"})
aAdd(aRegs,{cPerg,"16","Emissao de?"                ,"","","mv_chg","D",08,00,00,"G","","","",""    ,"MV_PAR16","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })
aAdd(aRegs,{cPerg,"17","Ate Emissao?"               ,"","","mv_chh","D",08,00,00,"G","","","",""    ,"MV_PAR17","",			"","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","" })


//Fim da Inclus�o

//�����������������������������������������������������������������������������������������Ŀ
//� Cria as perguntas se necess�rio                                                         �
//�������������������������������������������������������������������������������������������
CriaSx1(aRegs)

Pergunte(cPerg,.T.)

//�����������������������������������������������������������������������������������������Ŀ
//� Query para sele��o dos titulos a pagar
//�������������������������������������������������������������������������������������������
DbSelectArea( "SA6" )
SA6->( DbSetorder(1) )	// A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
If SA6->( DbSeek( xFilial("SA6") + mv_par10 + mv_par11 + mv_par13,.T. ) )
	If !Empty(MV_PAR09) // Deseja imprimir apenas os tipos do parametro 09
		cSql1 := "E1_TIPO IN " + FormatIn(MV_PAR09,";") + " AND "
	Endif
	
	cSql1 := "%"+cSql1+"%"   
		
	BeginSQL Alias cAliasQry
		SELECT	E1_PREFIXO,	E1_NUM, E1_PARCELA,	E1_TIPO, E1_CLIENTE, E1_LOJA,  E1_EMISSAO,  E1_VENCREA, E1_VLCRUZ, TRIM(utl_raw.cast_to_varchar2(E1_XOBS)) AS E1_XOBS
		FROM  %Table:SE1% SE1
		WHERE E1_FILIAL = %XFilial:SE1%
		AND E1_PREFIXO  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND E1_NUM	    BETWEEN	%Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND E1_PARCELA  BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND E1_NATUREZ  BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		AND E1_EMISSAO  BETWEEN %Exp:MV_PAR16% AND %Exp:MV_PAR17%  //WELLINGTON MENDES
		AND %exp:cSql1%
		SE1.%NotDel%
	EndSQL
Else
	Alert("Banco/Agencia/Conta n�o cadastrado. Por favor verifique.")
	Return( nil )
EndIf

DbSelectArea( "SA1")
SA1->( DbSetorder(1) )	// A1_FILIAL + A1_COD + A1_LOJA

//SE1->( DbSetOrder(1))	// E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
//lEnd := !( SE1->( DbSeek( xFilial("SE1") + mv_par01 + mv_par02 + mv_par04 + mv_par05 ) ) )

//�����������������������������������������������������������������������������������������Ŀ
//� Inicializacao do objeto grafico                                                         �
//�������������������������������������������������������������������������������������������
oPrint 	:= TMSPrinter():New("Titulo a Receber")
oPrint:Setup()
oPrint:SetPortrait()
//oBrush	:= TBrush():New( , CLR_LIGHTGRAY)

//�����������������������������������������������������������������������������������������Ŀ
//� Verifica se tem impressora ativa                                                        �
//�������������������������������������������������������������������������������������������
If 	oPrint:IsPrinterActive()
	
	//���������������������������������������������������������������������������������Ŀ
	//� Inicializa a p�gina                                                             �
	//�����������������������������������������������������������������������������������
	oPrint:StartPage()
	
	//�����������������������������������������������������������������������������������������Ŀ
	//� Se n�o abortar a rotina, chama a fun��o de impress�o                                    �
	//�������������������������������������������������������������������������������������������
	While (cAliasQry)->(!EOF())
		//�������������������������������������������������������������������������������������Ŀ
		//� Se encontrou dados a serem processados faz a interface com o usu�rio                �
		//���������������������������������������������������������������������������������������
		RptStatus( { |lEnd| RunRepo2(@lEnd) }, "Aguarde...", "Imprimindo T�tulo..."+'/'+(cAliasQry)->(E1_PREFIXO)+'-'+(cAliasQry)->(E1_NUM), .T. )
		
		//���������������������������������������������������������������������������������Ŀ
		//� Finaliza a p�gina                                                               �
		//�����������������������������������������������������������������������������������
		oPrint:EndPage()
		nLin := 0080
		
		(cAliasQry)->(DbSkip())
	EndDo
EndIF   

//�����������������������������������������������������������������������������������������Ŀ
//�Finaliza a Impress�o                                                                     �
//�������������������������������������������������������������������������������������������
oPrint:Preview()

(cAliasQry)->(DbCloseArea())

Return( Nil )

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RunRepo2� Efetua a impress�o do titulo a receber                       ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 04.12.17 � Implanta��o                                                  ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 04.12.17 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpL1 - Vari�vel de controle de cancelamento da fun��o                  ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 04.12.17 - Fabio Jadao Caires - Criacao da funcao                       ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function RunRepo2(lEnd)

//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis da funcao                                                           �
//�������������������������������������������������������������������������������������������
//Local oBrush
Local oFont07		:= TFont():New("Verdana",07,10,,.F.,,,,.T.,.F.)
Local oFont09		:= TFont():New("Verdana",09,09,,.F.,,,,.T.,.F.)
Local oFont10		:= TFont():New("Verdana",10,10,,.F.,,,,.T.,.F.)
Local oFont10n		:= TFont():New("Verdana",10,10,,.T.,,,,.T.,.F.)
Local oFont12		:= TFont():New("Verdana",12,12,,.F.,,,,.T.,.F.)
Local oFont12n		:= TFont():New("Verdana",12,12,,.T.,,,,.T.,.F.)
Local oFont11n		:= TFont():New("Verdana",11,11,,.T.,,,,.T.,.F.)
Local oFont15		:= TFont():New("Verdana",15,15,,.F.,,,,.T.,.F.)
Local oFont15n		:= TFont():New("Verdana",15,15,,.T.,,,,.T.,.F.)
Local oFont21n		:= TFont():New("Verdana",21,21,,.T.,,,,.T.,.F.)
Local nLoop1		:= 0
Local nLoop2		:= 0
Local nLoop3		:= 0
Local nLoop4		:= 0
Local nQdeLnh		:= 0
Local cBmp			:= ""
Local cStartPath	:= AllTrim( GetSrvProfString( "StartPath", "" ) )
Local aDiaSemana	:= {"domingo","segunda-feira","ter�a-feira","quarta-feira","quinta-feira","sexta-feira","s�bado"}
Local aMes			:= {"Janeiro","Fevereiro","Mar�o","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

//�����������������������������������������������������������������������������������������Ŀ
//� Faz ajueste no path se necess�rio                                                       �
//�������������������������������������������������������������������������������������������
//If SubStr( cStartPath, Len( cStartPath ), 1 ) != "\"
//	cStartPath += "\"
//EndIf

//�����������������������������������������������������������������������������������������Ŀ
//� Define a regua de impress�o                                                             �
//�������������������������������������������������������������������������������������������
//SetRegua( Len( aDadImp ) )


//���������������������������������������������������������������������������������Ŀ
//� Definicao do Box principal                                                      �
//�����������������������������������������������������������������������������������
//oPrint:Box(nLin,nCol,3100,2350)
//oPrint:Say(3105,nCol, "P�gina " + AllTrim( Str( nPagina ) ), oFont07)
nLin := IncLinha2(nLin,060)

//���������������������������������������������������������������������������������Ŀ
//� Inclusao do logotipo da filial de faturamento                                   �
//�����������������������������������������������������������������������������������
cBmp	:= "\logo\renova_logo_490_250.bmp"	// "C:\Temp\renova_logo_490_250.bmp"
If File( cBmp )
	oPrint:SayBitmap(nLin,nCol+0020,cBmp,490,250)
EndIf

//���������������������������������������������������������������������������������Ŀ
//� Definicao do Quadro Dados da Empresa                                            �
//�����������������������������������������������������������������������������������
oPrint:Say(nLin,nCol+0600, Capital(OemtoAnsi(SM0->M0_NOMECOM)), oFont15n)
nLin := IncLinha2(nLin,60)
oPrint:Say(nLin,nCol+0600, Capital(AllTrim(SM0->M0_ENDCOB)) + " " + AllTrim(SM0->M0_COMPCOB) + " " + Capital( AllTrim(SM0->M0_BAIRCOB) ), oFont10)
nLin := IncLinha2(nLin,40)
oPrint:Say(nLin,nCol+0600, "CEP  : " + Transform(SM0->M0_CEPCOB, "@R 99999-999") + " - " + AllTrim(SM0->M0_CIDCOB) + " - " + SM0->M0_ESTCOB, oFont10)
nLin := IncLinha2(nLin,40)
oPrint:Say(nLin,nCol+0600, "CNPJ : " + Transform(SM0->M0_CGC, "@R 99.999.999/9999-99") , oFont10)
nLin := IncLinha2(nLin,40)
oPrint:Say(nLin,ncol+0600, "Insc.Mun: " + Transform(SM0->M0_INSC, "@R 9.999" ), oFont10)
nLin := IncLinha2(nLin,50)

/*
oPrint:Say(nLin,nCol+1610, "ORDEM DE SERVI�O",oFont15n)
nLin := IncLinha2(nLin,60)
If nLoop4 == 1
oPrint:Say(nLin,nCol+0800, "1a. via - Cliente", oFont10)
Else
oPrint:Say(nLin,nCol+0800, "2a. via - Prestador", oFont10)
EndIf
oPrint:Say(nLin,nCol+1710, "Impress�o: "+DToC(Date()), oFont10)
nLin := IncLinha2(nLin,50)
*/

//oPrint:Line(nLin,nCol,nLin,2350)
nLin := IncLinha2(nLin,100)

//���������������������������������������������������������������������������������Ŀ
//� Definicao do Quadro de Dados do Projeto/Cliente/T�cnico                         �
//�����������������������������������������������������������������������������������

oPrint:Box(nLin,nCol+1300,nLin+50,nCol+1700)
oPrint:Box(nLin,nCol+1700,nLin+50,nCol+2100)

oPrint:Say(nLin,nCol+1400, "Nro. T�tulo ", oFont10n)
oPrint:Say(nLin,nCol+1800, "Data Emiss�o", oFont10n)
nLin := IncLinha2(nLin,50)

oPrint:Box(nLin,nCol+1300,nLin+50,nCol+1700)
oPrint:Box(nLin,nCol+1700,nLin+50,nCol+2100)

oPrint:Say(nLin,nCol+1400, (cAliasQry)->(E1_PREFIXO) + "-" + (cAliasQry)->(E1_NUM), oFont10)
oPrint:Say(nLin,nCol+1800, SUBSTR((cAliasQry)->(E1_EMISSAO),7,2) + "/" + SUBSTR((cAliasQry)->(E1_EMISSAO),5,2) + "/" +SUBSTR((cAliasQry)->(E1_EMISSAO),1,4), oFont10 )


nLin := IncLinha2(nLin,150)

oPrint:Box(nLin,nCol,nLin+50,nCol+1700)
//oPrint:Box(nLin,nCol,3100,2350)
oPrint:Box(nLin,nCol+1700,nLin+50,nCol+2100)

oPrint:Box(nLin+50,nCol,nLin+400,nCol+1700)
oPrint:Box(nLin+50,nCol+1700,nLin+400,nCol+2100)

oPrint:Box(nLin+400,nCol,nLin+450,nCol+1700)
oPrint:Box(nLin+400,nCol+1700,nLin+450,nCol+2100)


oPrint:Say(nLin,nCol+0600, " Descri��o da cobran�a ", oFont10n)
oPrint:Say(nLin,nCol+1800, "Valor R$", oFont10n)
nLin := IncLinha2(nLin,200)
//oPrint:Say(nLin,nCol+0050, (cAliasQry)->(E1_XOBS)		, oFont10 )
//Tratamento para quebra de linhas do campo memo- Gileno
oPrint:Say(nLin,nCol+010, Substr ( (cAliasQry)->(E1_XOBS),1,80)		, oFont10 )
nLin := IncLinha2(nLin,50)
oPrint:Say(nLin,nCol+0060, Substr ( (cAliasQry)->(E1_XOBS),81,150)		, oFont10 )

oPrint:Say(nLin,nCol+1800, Transform((cAliasQry)->(E1_VLCRUZ), "@E 999,999,999.99")	, oFont10 )
;nLin := IncLinha2(nLin,200)
nLin := IncLinha2(nLin,-40)

oPrint:Say(nLin,nCol+0600, " Total da cobran�a ", oFont10n )
oPrint:Say(nLin,nCol+1800, Transform((cAliasQry)->(E1_VLCRUZ), "@E 999,999,999.99")	, oFont10 )

nLin := IncLinha2(nLin,150)

oPrint:Box(nLin    ,nCol,nLin+ 50,nCol+2100)
oPrint:Box(nLin+ 50,nCol,nLin+100,nCol+2100)

oPrint:Box(nLin+ 50,nCol + 350,nLin+150,nCol+1700)
oPrint:Box(nLin+ 50,nCol + 750,nLin+150,nCol+1100)

oPrint:Box(nLin+100,nCol,nLin+150,nCol+2100)

oPrint:Say(nLin,nCol+0750, " Dados banc�rios para pagamento: ", oFont10n )

nLin := IncLinha2(nLin,50)
oPrint:Say(nLin,nCol+0150, "Banco"			, oFont10n )
oPrint:Say(nLin,nCol+0500, "Agencia"		, oFont10n )
oPrint:Say(nLin,nCol+0850, "Conta"			, oFont10n )
oPrint:Say(nLin,nCol+1200, "Vencimento"		, oFont10n )
oPrint:Say(nLin,nCol+1800, "Valor R$"		, oFont10n )

nLin := IncLinha2(nLin,50)
oPrint:Say(nLin,nCol+0150, SA6->A6_COD		, oFont10 )
oPrint:Say(nLin,nCol+0500, Alltrim(SA6->A6_AGENCIA) + "-" + Alltrim(SA6->A6_DVAGE)	, oFont10 )
oPrint:Say(nLin,nCol+0850, Alltrim(SA6->A6_NUMCON ) + "-" + Alltrim(SA6->A6_DVCTA)	, oFont10 )
oPrint:Say(nLin,nCol+1200, SUBSTR((cAliasQry)->(E1_VENCREA),7,2) + "/" + SUBSTR((cAliasQry)->(E1_VENCREA),5,2) + "/" +SUBSTR((cAliasQry)->(E1_VENCREA),1,4)	, oFont10 )
oPrint:Say(nLin,nCol+1800, Transform((cAliasQry)->(E1_VLCRUZ), "@E 999,999,999.99")	, oFont10 )

nLin := IncLinha2(nLin,150)

oPrint:Box(nLin    ,nCol,nLin+ 50,nCol+2100)
oPrint:Box(nLin+ 50,nCol,nLin+450,nCol+2100)

//�����������������������������������������������������������������������������������������Ŀ
//� Posicionando no cliente
//�������������������������������������������������������������������������������������������
SA1->( DbGoTop())
SA1->( DbSeek( xFilial("SA1") + (cAliasQry)->(E1_CLIENTE)+(cAliasQry)->(E1_LOJA) ) )

oPrint:Say(nLin,nCol+0850, " Dados do Sacado ", oFont10n )
nLin := IncLinha2(nLin,100)

oPrint:Say(nLin,nCol+0050, "Sacado  : " + SA1->A1_NOME		, oFont10 )
nLin := IncLinha2(nLin,50)

oPrint:Say(nLin,nCol+0050, "CNPJ    : " + Transform(SA1->A1_CGC, "@R 99.999.999/9999-99")		, oFont10 )
nLin := IncLinha2(nLin,50)

oPrint:Say(nLin,nCol+0050, "Endere�o: " + Alltrim(SA1->A1_END) + Iif( !Empty(SA1->A1_XNUMERO),", " + Alltrim(SA1->A1_XNUMERO),", ") + ;
Iif( !Empty(SA1->A1_COMPLEM),", " + Alltrim(SA1->A1_COMPLEM),""  )	, oFont10 )
nLin := IncLinha2(nLin,50)

oPrint:Say(nLin,nCol+0050, "Bairro  : " + Alltrim(SA1->A1_BAIRRO), oFont10 )
nLin := IncLinha2(nLin,50)

oPrint:Say(nLin,nCol+0050, "CEP     : " + Transform(SA1->A1_CEP, "@R 99999-99"), oFont10 )
nLin := IncLinha2(nLin,50)

oPrint:Say(nLin,nCol+0050, "Cidade  : " + SA1->A1_MUN + "     Estado: " + SA1->A1_EST , oFont10 )

nLin := IncLinha2(nLin,200)

If MV_PAR15 = 1
	oPrint:Box(nLin    ,nCol,nLin+ 50,nCol+2100)
	oPrint:Box(nLin+ 50,nCol,nLin+650,nCol+2100)
	
	
	oPrint:Say(nLin,nCol+0900, " RECIBO ", oFont10n )
	nLin := IncLinha2(nLin,100)
	
	oPrint:Say(nLin,nCol+0050, "Recebemos a import�ncia de " + Transform((cAliasQry)->(E1_VLCRUZ), "@E 999,999,999.99") , oFont10 )
	nLin := IncLinha2(nLin,50)
	
	//oPrint:Say(nLin,nCol+0050, "referente a " + Substr( (cAliasQry)->(E1_XOBS) , oFont10 )
	//Tratamento para quebra de linhas do campo memo- Gileno
	oPrint:Say(nLin,nCol+0050, "referente a " + Substr ( (cAliasQry)->(E1_XOBS),1,120)		, oFont10 )
	nLin := IncLinha2(nLin,40)
	oPrint:Say(nLin,nCol+0050, Substr ( (cAliasQry)->(E1_XOBS),121,200)		, oFont10 )
		
	nLin := IncLinha2(nLin,160)
	oPrint:Say(nLin,nCol+0200, "S�o Paulo, " + aDiaSemana[ dow(STOD((cAliasQry)->(E1_EMISSAO))) ] + ", " + Substr( (cAliasQry)->(E1_EMISSAO),7,2 ) + " de " + aMes[ Val(Substr( (cAliasQry)->(E1_EMISSAO),5,2 ))] + " de " + Substr( (cAliasQry)->(E1_EMISSAO),1,4 ) , oFont10 )    
//	oPrint:Say(nLin,nCol+0200, "S�o Paulo, " + aDiaSemana[dow(SE1->E1_EMISSAO)]                  + ", " + Substr( DTOC(SE1->E1_EMISSAO),1,2 )     + " de " + aMes[ Val(Substr( DTOS(SE1->E1_EMISSAO),5,2 )) ]    + " de " + Substr( DTOS(SE1->E1_EMISSAO),1,4 )     , oFont10 )
	nLin := IncLinha2(nLin,160)
	oPrint:Say(nLin,nCol+0200, "____________________________________________________" , oFont10 )
	nLin := IncLinha2(nLin,50)
	oPrint:Say(nLin,nCol+0300, Capital(OemtoAnsi(SM0->M0_NOMECOM)), oFont10 )
	
EndIf

Return( Nil )

Static Function IncLinha2(nLin,nQdeLin)

Local oFont07		:= TFont():New("Verdana",07,10,,.F.,,,,.T.,.F.)

If nLin >= 3020
	nLin := 80
	nPagina++
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:Box(nLin,nCol,3100,2350)
	oPrint:Say(3105,nCol, "P�gina " + AllTrim( Str( nPagina ) ), oFont07)
	nLin += 40
Else
	nLin+= nQdeLin
EndIf

Return(nLin)

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CriaSx1  � Verifica e cria um novo grupo de perguntas com base nos      ���
���             �          � par�metros fornecidos                                        ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function CriaSx1(aRegs)

//�������������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis         										  	  �
//���������������������������������������������������������������������������������
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)

// Funcao   : U_FNR01BC2	| Autor: Fabio Jadao Caires		| Data: 09/01/2018
// Descricao: Chamada pelo X1_VALID da pergunta 05 - Banco (F3: SA6) para alimentar a agencia, dv da agencia, conta e dv da conta.
User Function FNR01BC2()

Local nRecSA6 := 0

mv_par11	:= SA6->A6_AGENCIA
mv_par12	:= SA6->A6_DVAGE
mv_par13	:= SA6->A6_NUMCON
mv_par14	:= SA6->A6_DVCTA


Return 