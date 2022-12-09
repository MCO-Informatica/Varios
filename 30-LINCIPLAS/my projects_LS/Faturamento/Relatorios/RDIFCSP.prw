#INCLUDE "rwmake.ch"
#Include "protheus.Ch"
#DEFINE CRLF Chr(13)+Chr(10)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � RDIFCSP � Autor � Thiago Queiroz	        � Data � 08/11/13 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � 08/11/13 � Imprime um relat�rio que ir� verificar  	      ���
���          �          � o valor lan�ado no pedido de venda/compra       ���
���          �          � para facilitar a identificacao de possiveis  	  ���
���          �          � diferencas com relacao ao XML processado.   	  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT - R4 - ESPECIFICO LA SELVA                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RDIFCSP()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Rodrigo Okamoto       � Data � 26/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local oFatVend
Local oTemp1
Local oTotal1
Local nSumTotal	:= 0

Private aTotvd	:= {}
Private cPerg	:= "RDIFCSP"
Private cRelDesc:= "Este relat�rio tem o objetivo de imprimir os totais por produto dos pedidos com rela��o do acerto, e destacar as poss�veis diferen�as"

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
oReport := TReport():New("RDIFCSP","Consigna��o Superpedidos" ,"RDIFCSP", {|oReport| ReportPrint(oReport,oFatVend,oTemp1)},cRelDesc)
//oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
ValiDPerg()
//Pergunte(oReport:uParam,.F.)

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
//�ExpL7 : ITforme se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oFatVend := TRSection():New(oReport,"Diferen�a de Valores",{"SZB"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oFatVend:SetTotalInLine(.F.)
//Dados cadastrais
TRCell():New(oFatVend,"ITEM"		,		,"Item"						,PesqPict("SZB","ZB_ITEM")		,TamSx3("ZB_ITEM")		[1]	,/*lPixel*/,/*{|| cVend }*/						)		// "Centro de Custo"
TRCell():New(oFatVend,"PRODUTO"		,		,"Produto"					,PesqPict("SZB","ZB_PRODUTO")	,TamSx3("ZB_PRODUTO")	[1]	,/*lPixel*/,/*{|| cLjCli }*/					)		// "Nome do funcionario"
TRCell():New(oFatVend,"PQTD"		,		,"Qtd."						,PesqPict("SZB","ZB_SALDO")		,TamSx3("ZB_SALDO")		[1]	,/*lPixel*/,/*{|| cUf }*/						)		// "Descri��o da fun��o"
//TRCell():New(oFatVend,"PVUNIT"	,		,"PV/PC V.Unit."			,PesqPict("SZB","ZB_SALDO")		,TamSx3("ZB_SALDO")		[1]	,/*lPixel*/,/*{|| cNome }*/						)		// "Salario base"
//TRCell():New(oFatVend,"PVTOTAL"	,		,"PV/PC V.Total"			,PesqPict("SZB","ZB_SALDO")		,TamSx3("ZB_SALDO")		[1]	,/*lPixel*/,/*{|| cUf }*/						)		// "Descri��o da fun��o"
//TRCell():New(oFatVend,"ZBQTD"		,		,"XML Qtd"					,PesqPict("SZB","ZB_SALDO")		,TamSx3("ZB_SALDO")		[1]	,/*lPixel*/,/*{|| cUf }*/						)		// "Descri��o da fun��o"
//TRCell():New(oFatVend,"ZBVUNIT"	,		,"XML V.Unit"				,PesqPict("SZB","ZB_SALDO")		,TamSx3("ZB_SALDO")		[1]	,/*lPixel*/,/*{|| cNome }*/						)		// "Salario base"
//TRCell():New(oFatVend,"ZBVTOTAL"	,		,"XML V.Total"				,PesqPict("SZB","ZB_SALDO")		,TamSx3("ZB_SALDO")		[1]	,/*lPixel*/,/*{|| cUf }*/						)		// "Descri��o da fun��o"
TRCell():New(oFatVend,"FINAL1"		,		,"PV Final"					,PesqPict("SZB","ZB_SALDO")		,TamSx3("ZB_SALDO")		[1]	,/*lPixel*/,/*{|| cNome }*/						)		// "Salario base"
TRCell():New(oFatVend,"FINAL2"		,		,"XML Final"				,PesqPict("SZB","ZB_SALDO")		,TamSx3("ZB_SALDO")		[1]	,/*lPixel*/,/*{|| cUf }*/						)		// "Descri��o da fun��o"
TRCell():New(oFatVend,"DIFF"		,		,"Diferenca"				,PesqPict("SZB","ZB_SALDO")		,TamSx3("ZB_SALDO")		[1]	,/*lPixel*/,/*{|| cNome }*/						)		// "Salario base"

// Totalizador por Centro de custo
//oTotal1  := TRFunction():New(oFatVend:Cell("DIFF"			),/* cID */,"ONPRINT",/*oBreak*/,/*cTitle*/,/*cPicture*/,{|| nSumTotal }/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
oTotal1  := TRFunction():New(oFatVend:Cell("DIFF"			),/* cID */,"SUM"    ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)

// Totalizadores Salario
//TRFunction():New(oFatVend:Cell("VALOR") 		,/* cID */,"ONPRINT",/*oBreak*/,"Total Credito"	/*cTitle*/,/*cPicture*/,{|| nSumCredit }	/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
//TRFunction():New(oFatVend:Cell("TB_VALOR02") ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

// Alinhamento das colunas de valor a direita
oFatVend:Cell("PQTD"):SetHeaderAlign("RIGHT")
//oFatVend:Cell("PVUNIT"):SetHeaderAlign("RIGHT")
//oFatVend:Cell("PVTOTAL"):SetHeaderAlign("RIGHT")
//oFatVend:Cell("ZBQTD"):SetHeaderAlign("RIGHT")
//oFatVend:Cell("ZBVUNIT"):SetHeaderAlign("RIGHT")
//oFatVend:Cell("ZBVTOTAL"):SetHeaderAlign("RIGHT")
oFatVend:Cell("FINAL1"):SetHeaderAlign("RIGHT")
oFatVend:Cell("FINAL2"):SetHeaderAlign("RIGHT")
oFatVend:Cell("DIFF"):SetHeaderAlign("RIGHT")
//oFatVend:Cell("TB_VALOR01"):SetHeaderAlign("RIGHT")

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Marco Bianchi          � Data � 26/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,oFatVend,oTemp1)

//��������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                      �
//����������������������������������������������������������������
Local aCampos 		:= {}
Local aTam	 		:= {}

Public nCont 		:= 1
Public nFatorMedia	:= 1

// TOTALIZADORES
Public nSumCredit	:= 0
Public nSumDebito	:= 0
Public nSumTotal	:= 0
Public nSumElse		:= 0
//GERAL
// Inicializa Valores
Public cMes			:= ""//SUBSTR(RDIFCSP->RD_DATARQ,5,2)
//cc / funcionario / desc fun��o
Public aRel			:= {}
Public cFunc		:= ""//RDIFCSP->RA_NOME
Public cDept		:= ""//RDIFCSP->CTT_DESC01

Private cCampImp
Private aTamVal		:= { 16, 2 }

//��������������������������������������������������������������Ŀ
//� SetBlock: faz com que as variaveis locais possam ser         �
//� utilizadas em outras funcoes nao precisando declara-las      �
//� como private											  	 �
//����������������������������������������������������������������
oReport:Section(1):Cell("ITEM" 		):SetBlock({|| ITEM 		})
oReport:Section(1):Cell("PRODUTO" 	):SetBlock({|| PRODUTO 		})
oReport:Section(1):Cell("PQTD" 		):SetBlock({|| PQTD 		})
oReport:Section(1):Cell("FINAL1" 	):SetBlock({|| FINAL1 		})
oReport:Section(1):Cell("FINAL2" 	):SetBlock({|| FINAL2 		})
oReport:Section(1):Cell("DIFF"	 	):SetBlock({|| DIFF 		})

//oReport:SetTitle("DRE - "+_cConta+" - "+_cDesc)

//��������������������������������������������������������������Ŀ
//� Cria array para gerar arquivo de trabalho                    �
//����������������������������������������������������������������
If Select("RDIFCSP") > 0
	dbselectArea("RDIFCSP")
	dbclosearea()
EndIf
//aTam:=TamSX3("ZB_HIST")//{20,0}//
AADD(aCampos,{ "ITEM" 		,"C",TamSX3("ZB_ITEM")[1]		,	TamSX3("ZB_ITEM")[2] 	} )
AADD(aCampos,{ "PRODUTO"  	,"C",TamSX3("ZB_PRODUTO")[1]	,	TamSX3("ZB_PRODUTO")[2]	} )
AADD(aCampos,{ "PQTD"		,"N",TamSX3("ZB_SALDO")[1]		,	TamSX3("ZB_SALDO")[2] 	} )
//AADD(aCampos,{ "PVUNIT"	,"N",TamSX3("ZB_SALDO")[1]		,	TamSX3("ZB_SALDO")[2] 	} )
//AADD(aCampos,{ "PVTOTAL"	,"N",TamSX3("ZB_SALDO")[1]		,	TamSX3("ZB_SALDO")[2] 	} )
//AADD(aCampos,{ "ZBQTD"	,"N",TamSX3("ZB_SALDO")[1]		,	TamSX3("ZB_SALDO")[2] 	} )
//AADD(aCampos,{ "ZBVUNIT"	,"N",TamSX3("ZB_SALDO")[1]		,	TamSX3("ZB_SALDO")[2] 	} )
//AADD(aCampos,{ "ZBVTOTAL"	,"N",TamSX3("ZB_SALDO")[1]		,	TamSX3("ZB_SALDO")[2] 	} )
AADD(aCampos,{ "FINAL1"		,"N",TamSX3("ZB_SALDO")[1]		,	TamSX3("ZB_SALDO")[2] 	} )
AADD(aCampos,{ "FINAL2"		,"N",TamSX3("ZB_SALDO")[1]		,	TamSX3("ZB_SALDO")[2] 	} )
AADD(aCampos,{ "DIFF"		,"N",TamSX3("ZB_SALDO")[1]		,	TamSX3("ZB_SALDO")[2] 	} )

//��������������������������������������������������������������Ŀ
//� Cria arquivo de trabalho                                     �
//����������������������������������������������������������������
cNomArq 	:= CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cNomArq,"RDIFCSP", .T. , .F. )

cNomArq1 := Subs(cNomArq,1,7)+"A"
IndRegua("RDIFCSP",cNomArq1,"PRODUTO",,,"Selecionando Registros...")		//"Selecionando Registros..."

//aTamVal 	:= TamSX3("F2_VALFAT")
//cNomArq2 := Subs(cNomArq,1,7)+"B"
//IndRegua("RDIFCSP",cNomArq2,"TB_CTTDESC+(STRZERO(TB_VALOR00,aTamVal[1],aTamVal[2]))",,,"Selecionando Registros...")		//"Selecionando Registros..."

dbClearIndex()
dbSetIndex(cNomArq1+OrdBagExt())
//dbSetIndex(cNomArq2+OrdBagExt())

//������������������������������������������������������������������������Ŀ
//� Geracao do Arquivo para Impressao                                      �
//��������������������������������������������������������������������������
cAlias := "TRBRDIFCSP"

IF EMPTY(MV_PAR01).OR.EMPTY(MV_PAR02).OR.EMPTY(MV_PAR03)
	MSGALERT("Preencha os parametros corretamente!")
	RETURN
ENDIF

IF MV_PAR03 == 1
	
	cQuery := " "
	cQuery += " SELECT C6_NUM "
	cQuery += " , ZB_ITEM "
	cQuery += " , C6_PRODUTO "
	cQuery += " , ZB_PRODUTO "
	cQuery += " , SUM(C6_QTDVEN)                       	AS PV_QTDVEN "
	cQuery += " , SUM(C6_PRCVEN)                       	AS PV_PRCVEN "
	cQuery += " , SUM(C6_VALOR)                        	AS PV_VAL_TOTAL "
	cQuery += " , SUM(C6_PRUNIT)                       	AS PV_VAL_TAB "
	cQuery += " , C6_DESCONT                           	AS PV_PORC_DESC "
	cQuery += " , SUM(C6_VALDESC)                      	AS PV_TOT_DESC "
	cQuery += " , SUM(ZB_QTDPAG)/COUNT(C6_PRODUTO)    	AS XML_QTDVEN "
	cQuery += " , SUM(ZB_VALPROD)/COUNT(C6_PRODUTO)  	AS XML_VAL_TOTAL "
	cQuery += " , SUM(ZB_DESPROD)/COUNT(C6_PRODUTO)   	AS XML_DESC "
	cQuery += " , ((SUM(ZB_VALPROD)/COUNT(C6_PRODUTO))*(SUM(ZB_QTDPAG)/COUNT(C6_PRODUTO)))-(( SUM(ZB_DESPROD)/COUNT(C6_PRODUTO) )*(SUM(ZB_QTDPAG)/COUNT(C6_PRODUTO)) ) AS XML_FINAL "
	cQuery += " , SUM(C6_VALOR)                         AS PV_FINAL "
	cQuery += " , (((SUM(ZB_VALPROD)/COUNT(C6_PRODUTO))*(SUM(ZB_QTDPAG)/COUNT(C6_PRODUTO)))-(( SUM(ZB_DESPROD)/COUNT(C6_PRODUTO) )*(SUM(ZB_QTDPAG)/COUNT(C6_PRODUTO)) ) ) - ( SUM(C6_VALOR) ) AS DIFERENCA "
	cQuery += " FROM SC6010 C6 (NOLOCK), SC5010 C5 (NOLOCK), SZB010 ZB (NOLOCK) "
	cQuery += " WHERE C5_NUMFEC			= '"+MV_PAR02+"' "
	cQuery += " AND ZB_NUMFEC			= C5_NUMFEC "
	cQuery += " AND ZB_PRODUTO			= C6_PRODUTO "
	cQuery += " AND C5_NUM				= C6_NUM "
	cQuery += " AND C5_FILIAL			= '"+MV_PAR01+"' "
	cQuery += " AND C6_FILIAL			= '"+MV_PAR01+"' "
	cQuery += " AND ZB_FILIAL			= '"+MV_PAR01+"' "
	cQuery += " AND C5.D_E_L_E_T_		= '' "
	cQuery += " AND C6.D_E_L_E_T_		= '' "
	cQuery += " AND ZB.D_E_L_E_T_		= '' "
	cQuery += " GROUP BY C6_FILIAL, C6_NUM, ZB_ITEM, C6_PRODUTO, ZB_PRODUTO, C6_DESCONT "
	cQuery += " ORDER BY ZB_ITEM, C6_PRODUTO "
ELSEIF MV_PAR03 == 2
	cQuery := " "
	cQuery += " SELECT C7_NUM   "
	cQuery += " , ZB_ITEM   "
	cQuery += " , C7_PRODUTO   "
	cQuery += " , ZB_PRODUTO   "
	cQuery += " , SUM(C7_QUANT)                       	AS PV_QTDVEN   "
	cQuery += " , SUM(C7_PRECO)                       	AS PV_PRCVEN   "
	cQuery += " , SUM(C7_TOTAL)                        	AS PV_VAL_TOTAL   "
	cQuery += " , SUM(0)                       			AS PV_VAL_TAB   "
	cQuery += " , C7_DESC1                           	AS PV_PORC_DESC   "
	cQuery += " , SUM(C7_VLDESC)                      	AS PV_TOT_DESC   "
	cQuery += " , SUM(ZB_QTDPAG)/COUNT(C7_PRODUTO)    	AS XML_QTDVEN   "
	cQuery += " , SUM(ZB_VALPROD)/COUNT(C7_PRODUTO)  	AS XML_VAL_TOTAL   "
	cQuery += " , SUM(ZB_DESPROD)/COUNT(C7_PRODUTO)   	AS XML_DESC   "
	cQuery += " , ((SUM(ZB_VALPROD)/COUNT(C7_PRODUTO))*(SUM(ZB_QTDPAG)/COUNT(C7_PRODUTO)))-(( SUM(ZB_DESPROD)/COUNT(C7_PRODUTO) )*(SUM(ZB_QTDPAG)/COUNT(C7_PRODUTO)) ) AS XML_FINAL   "
	cQuery += " , SUM(C7_TOTAL)                         AS PV_FINAL   "
	cQuery += " , (((SUM(ZB_VALPROD)/COUNT(C7_PRODUTO))*(SUM(ZB_QTDPAG)/COUNT(C7_PRODUTO)))-(( SUM(ZB_DESPROD)/COUNT(C7_PRODUTO) )*(SUM(ZB_QTDPAG)/COUNT(C7_PRODUTO)) ) ) - ( SUM(C7_TOTAL) ) AS DIFERENCA   "
	cQuery += " FROM SC7010 C7 (NOLOCK) "
	cQuery += " , SZB010 ZB (NOLOCK)   "
	cQuery += " WHERE C7_NUMFEC			= '"+MV_PAR02+"'   "
	cQuery += " AND ZB_NUMFEC			= C7_NUMFEC   "
	cQuery += " AND ZB_PRODUTO			= C7_PRODUTO  "
	cQuery += " AND C7_FILIAL			= '"+MV_PAR01+"'  "
	cQuery += " AND ZB_FILIAL			= '"+MV_PAR01+"'  "
	cQuery += " AND C7.D_E_L_E_T_		= ''  "
	cQuery += " AND ZB.D_E_L_E_T_		= ''  "
	cQuery += " GROUP BY C7_FILIAL, C7_NUM, ZB_ITEM, C7_PRODUTO, ZB_PRODUTO, C7_DESC1   "
	cQuery += " ORDER BY ZB_ITEM, C7_PRODUTO "
	
ENDIF

If Select(cAlias) > 0
	dbselectArea(cAlias)
	dbclosearea()
EndIf

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)

//������������������������������������������������������������������������Ŀ
//� Transforma parametros Range em expressao SQL                           �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//� Abre tabelas e indices a serem utilizados                              �
//��������������������������������������������������������������������������
dbSelectArea(cAlias)
//dbSetOrder(1)

oReport:SetMeter( (cAlias)->(LastRec() ))
//oReport:SetMeter( LEN(_aARRAY) )
//������������������������������������������������������������������������Ŀ
//�Processa Valores                                                    �
//��������������������������������������������������������������������������
lfirst	:= .T.
//dbSelectArea("TRBRDIFCSP")
WHILE !EOF()
	//FOR NX := 1 TO LEN(_aARRAY)
	//	RecLock("RDIFCSP",.T.)
	IF (cAlias)->DIFERENCA > 0
		
		dbSelectArea("RDIFCSP")
		RecLock("RDIFCSP",.T.)
		
		Replace ITEM  		With (cAlias)->ZB_ITEM 					// SUBSTR(_AARRAY[NX][1],1,6)+SUBSTR(_AARRAY[NX][1],9,2) //_AARRAY[NX][1]
		Replace PRODUTO		With (cAlias)->ZB_PRODUTO 				// ALLTRIM(_AARRAY[NX][2])
		Replace PQTD		With (cAlias)->PV_QTDVEN 					// ALLTRIM(_AARRAY[NX][3])
		//Replace PVUNIT	With (cAlias)->PV_PRCVEN 					// VAL(STRTRAN(STRTRAN(ALLTRIM(_AARRAY[NX][4]),".",""),",",".")) //_AARRAY[NX][4]
		//Replace PVTOTAL	With (cAlias)->PV_VAL_TOTAL 				// ALLTRIM(_AARRAY[NX][6])
		//Replace ZBQTD		With (cAlias)->XML_QTDVEN 				// ALLTRIM(_AARRAY[NX][3])
		//Replace ZBVUNIT	With (cAlias)->XML_VAL_TOTAL/XML_QTDVEN 	// VAL(STRTRAN(STRTRAN(ALLTRIM(_AARRAY[NX][4]),".",""),",",".")) //_AARRAY[NX][4]
		//Replace ZBVTOTAL	With (cAlias)->XML_VAL_TOTAL 				// ALLTRIM(_AARRAY[NX][6])
		Replace FINAL1		With (cAlias)->PV_FINAL 					// ALLTRIM(_AARRAY[NX][3])
		Replace FINAL2		With (cAlias)->XML_FINAL 					// VAL(STRTRAN(STRTRAN(ALLTRIM(_AARRAY[NX][4]),".",""),",",".")) //_AARRAY[NX][4]
		Replace DIFF		With (cAlias)->DIFERENCA 					// ALLTRIM(_AARRAY[NX][6])
		//TRANSFORM(VAL(STRTRAN(STRTRAN(ALLTRIM(_AARRAY[NX][4]),".",""),",",".")),"@E 999,999,999.99")
		
		/*
		IF ALLTRIM(_AARRAY[NX][6]) == "C"
		nSumCredit	:= nSumCredit+VAL(STRTRAN(STRTRAN(ALLTRIM(_AARRAY[NX][4]),".",""),",","."))
		ELSEIF ALLTRIM(_AARRAY[NX][6]) == "D"
		nSumDebito	:= nSumDebito+VAL(STRTRAN(STRTRAN(ALLTRIM(_AARRAY[NX][4]),".",""),",","."))
		ELSE
		nSumElse	:= nSumElse+VAL(STRTRAN(STRTRAN(ALLTRIM(_AARRAY[NX][4]),".",""),",","."))
		ENDIF
		*/
		MsUnlock()
	ENDIF
	
	dbSelectArea(cAlias)
	(cAlias)->(dbSkip())
	//NEXT NX
ENDDO
(cAlias)->(dbCloseArea())
/*
nSumTotal 		:= nSumCredit - nSumDebito

IF nSumTotal < 0
nSumTotal 	:= nSumTotal * -1
ELSE
nSumTotal	:= nSumTotal
ENDIF
*/

//������������������������������������������������������������������������Ŀ
//� Impressao do Relatorio                                                 �
//��������������������������������������������������������������������������
dbSelectArea("RDIFCSP")
dbSetOrder(1)
dbgotop()

nQtdFunc	:= 0
oReport:section(1):Init()
oReport:SetMeter(LastRec())
While !eof()
	
	oReport:IncMeter()
	
	ITEM		:= RDIFCSP->ITEM
	PRODUTO		:= RDIFCSP->PRODUTO
	PQTD	 	:= RDIFCSP->PQTD
	FINAL1		:= RDIFCSP->FINAL1
	FINAL2 		:= RDIFCSP->FINAL2
	DIFF		:= RDIFCSP->DIFF
	
	nQtdFunc++
	//oReport:Section(1):SetTotalText("TESTE")
	
	oReport:Section(1):Cell("ITEM"):GetWidth(.T.)
	oReport:Section(1):Cell("PRODUTO"):GetWidth(.T.)
	oReport:Section(1):Cell("PQTD"):GetWidth(.T.)
	oReport:Section(1):Cell("FINAL1"):GetWidth(.T.)
	oReport:Section(1):Cell("FINAL2"):GetWidth(.T.)
	oReport:Section(1):Cell("DIFF"):GetWidth(.T.)
	oReport:section(1):PrintLine()
	
	dbSelectArea("RDIFCSP")
	dbSkip()
	
	If EoF() //.or. cFuncAnt <> RDIFCSP->TB_NOME
		//����������������������������������������������������������Ŀ
		//� Imprime o total do centro de custo selecionado           � // ADICIONA TOTALIZADOR
		//������������������������������������������������������������
		//oReport:Section(1):SetTotalText("Total (Credito - Debito) - " + TRANSFORM(nSumTotal,"@E 999,999,999.99"))
		//oReport:Section(1):Say(oReport:Section(1):Row(),oReport:Section(1):Col(),"Total (Credito - Debito) - " + TRANSFORM(nSumTotal,"@E 999,999,999.99"))
		nLinha := oReport:Section(1):Row()
		//oReport:Section(1):PrintText("Total (Credito - Debito) - " + TRANSFORM(nSumTotal,"@E 999,999,999.99"),nLinha,10)
		oReport:Section(1):Finish()
		
		//nQtdFunc	:= 0
		oReport:section(1):Init()
	EndIf
	
EndDo

//oReport:Section(1):SetTotalText("Total (Credito - Debito) - " + TRANSFORM(nSumTotal,"@E 999,999,999.99"))
//oReport:Section(1):Finish()
//oReport:section(1):Init()

oReport:Section(1):PageBreak()

dbSelectArea( "RDIFCSP" )
dbCloseArea()
fErase(cNomArq+GetDBExtension())
fErase(cNomArq1+OrdBagExt())

//��������������������������������������������������������������Ŀ
//� Restaura a integridade dos dados                             �
//����������������������������������������������������������������
dbSelectArea("SZB")
dbClearFilter()
dbSetOrder(1)
dbCloseArea()

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �VALIDPERG � Autor � RAIMUNDO PEREIRA      � Data � 01/08/02 ���
�������������������������������������������������������������������������Ĵ��
���          � Verifica as perguntas inclu�ndo-as caso n"o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg()
_aAreaVP := GetArea()

DBSelectArea("SX1")
DBSetOrder(1)

cPerg  := PADR(cPerg,10)
aRegs  :={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
/*�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  Ordem Pergunta Portugues   Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  Tamanho Decimal Presel  GSC   Valid                 Var01     	 Def01      DefSPA1      DefEng1      Cnt01          					  Var02  Def02    DefSpa2  DefEng2	Cnt02  Var03 Def03  DefSpa3 DefEng3 Cnt03  Var04  Def04  DefSpa4    DefEng4  Cnt04 		 Var05  Def05  DefSpa5 DefEng5   Cnt05  	XF3  GrgSxg   cPyme   aHelpPor  aHelpEng	 aHelpSpa    cHelp      �
���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/

AADD(aRegs,{cPerg,"01","Filial "				,"","","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"02","Nro Acerto"				,"","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SZA"})
AADD(aRegs,{cPerg,"03","Tipo Pedido"		  	,"","","mv_ch3","C",1,0,0,"C","","mv_par03","Venda","","","","","Compra","","","","","","","","","","","","","","","","","","",""})

aHelpP := {}

For i:=1 to Len(aRegs)
	If !DBSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

RestArea(_aAreaVP)
Return
