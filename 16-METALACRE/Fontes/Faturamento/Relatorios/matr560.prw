#INCLUDE "MATR560.CH"
#Include "FIVEWIN.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATR560  � Autor � Marco Bianchi         � Data � 21/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Estatistica de Venda por Prazo de Pagamento                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT - R4                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function XMATR560()

Local oReport

//If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
//Else
//	MATR560R3()
//EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data �21/06/06  ���
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
Local oEstatFat
Local oPercent
Local oTemp

Local dDatAnt:= CTOD("  /  /  ")
Local cNotFat:= ""
Local nAd1   := 0
Local nAd2   := 0
Local nAd3   := 0
Local nAd4   := 0
Local nAd5   := 0
Local nAd6   := 0

Local cPrazo1 := "Prazo 1"
Local cPrazo2 := "Prazo 2"
Local cPrazo3 := "Prazo 3"
Local cPrazo4 := "Prazo 4"
Local cPrazo5 := "Prazo 5"
Local cPrazo6 := "Prazo 6"

Local lTotalSec := .T.
Local nTamData  := Len(DTOC(MsDate()))

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
oReport := TReport():New("MATR560",STR0021,"MTR560", {|oReport| ReportPrint(oReport,oEstatFat,oPercent,oTemp,@cPrazo1,@cPrazo2,@cPrazo3,@cPrazo4,@cPrazo5,@cPrazo6,@lTotalSec)},STR0022 + " " + STR0023 + " "  + STR0024)		// "** ESTATISTICA DO FATURAMENTO POR PRAZO DE PAGAMENTO **"###"Este relatorio ira emitir a relacao de Faturamento por"###"ordem de Prazo de Pagamento. Poderao ser escolhidos os inter-"###"valos atraves da opcao Parametros."
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)
                            
//������������������������������������������������������������������������Ŀ
//� Define TRsection                                                       �
//��������������������������������������������������������������������������
// Secao para impressao das notas e totais
oEstatFat := TRSection():New(oReport,STR0034,{"SE1","SD2","SF2"},{STR0025,STR0026},/*Campos do SX3*/,/*Campos do SIX*/)	// "** ESTATISTICA DO FATURAMENTO POR PRAZO DE PAGAMENTO **"###"Diario - Detalhado"###"Diario - Totalizado"
oEstatFat:SetTotalInLine(.F.)

TRCell():New(oEstatFat,"TEXTO"	    ,/*Tabela*/,STR0037,                            ,11								 ,/*lPixel*/,{|| SPACE(11)                        },,,,,,.F.)	// "Coluna em branco"
TRCell():New(oEstatFat,"EMISSAO"	,/*Tabela*/,STR0027,PesqPict("SE1","E1_EMISSAO"),nTamData								 ,/*lPixel*/,{|| dDatAnt                          })	// "Emissao"
TRCell():New(oEstatFat,"NOTA"		,/*Tabela*/,STR0028,PesqPict("SE1","E1_NUM"		),TamSX3("E1_NUM"		)[1],/*lPixel*/,{|| Substr(cNotFat,1,TamSX3("F2_DOC")[1])})           // "Nota Fiscal"
TRCell():New(oEstatFat,"CLIENTE"	,/*Tabela*/,'Nome Fantasia',PesqPict("SA1","A1_NREDUZ"		),TamSX3("A1_NREDUZ")[1],/*lPixel*/,{|| SA1->A1_NREDUZ })           // "Nota Fiscal"
TRCell():New(oEstatFat,"PRAZO1"		,/*Tabela*/,cPrazo1,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| nAd1                                 })            // Valor dentro do Prazo 1
TRCell():New(oEstatFat,"PRAZO2"		,/*Tabela*/,cPrazo2,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| nAd2                                 })			// Valor dentro do Prazo 2
TRCell():New(oEstatFat,"PRAZO3"		,/*Tabela*/,cPrazo3,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| nAd3                                 })			// Valor dentro do Prazo 3
TRCell():New(oEstatFat,"PRAZO4"		,/*Tabela*/,cPrazo4,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| nAd4                                 })			// Valor dentro do Prazo 4
TRCell():New(oEstatFat,"PRAZO5"		,/*Tabela*/,cPrazo5,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| nAd5                                 })			// Valor dentro do Prazo 5
TRCell():New(oEstatFat,"PRAZO6"		,/*Tabela*/,cPrazo6,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| nAd6                                 })			// Valor dentro do Prazo 6
TRCell():New(oEstatFat,"TOTAL"		,/*Tabela*/,STR0029,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| nAd1+nAd2+nAd3+nAd4+nAd5+nAd6       })		        // "Total" - Valor Total (Somatoria dos prazos)

// Totalizacao por Dia e Total Geral de acordo com a veriavel .TotalSec
TRFunction():New(oEstatFat:Cell("PRAZO1"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,lTotalSec/*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oEstatFat:Cell("PRAZO2"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,lTotalSec/*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oEstatFat:Cell("PRAZO3"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,lTotalSec/*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oEstatFat:Cell("PRAZO4"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,lTotalSec/*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oEstatFat:Cell("PRAZO5"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,lTotalSec/*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oEstatFat:Cell("PRAZO6"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,lTotalSec/*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oEstatFat:Cell("TOTAL") ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,lTotalSec/*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)


// Alinhamento a direita das colunas de valor
oEstatFat:Cell("PRAZO1"):SetHeaderAlign("RIGHT")
oEstatFat:Cell("PRAZO2"):SetHeaderAlign("RIGHT")
oEstatFat:Cell("PRAZO3"):SetHeaderAlign("RIGHT")
oEstatFat:Cell("PRAZO4"):SetHeaderAlign("RIGHT")
oEstatFat:Cell("PRAZO5"):SetHeaderAlign("RIGHT")
oEstatFat:Cell("PRAZO6"):SetHeaderAlign("RIGHT")
oEstatFat:Cell("TOTAL"):SetHeaderAlign("RIGHT")
// Secao para impressao dos Percentuais
oPercent := TRSection():New(oReport,STR0035,{"SD2","SD1","SF1","SF2"},{STR0025,STR0026},/*Campos do SX3*/,/*Campos do SIX*/)		// "** ESTATISTICA DO FATURAMENTO POR PRAZO DE PAGAMENTO **"###"Diario - Detalhado"###"Diario - Totalizado"
oPercent:SetTotalInLine(.F.)

// Secao para receber a Query das Devolucoes
oTemp := TRSection():New(oReport,"",,{STR0025,STR0026},/*Campos do SX3*/,/*Campos do SIX*/)	// "** ESTATISTICA DO FATURAMENTO POR PRAZO DE PAGAMENTO **"###"Diario - Detalhado"###"Diario - Totalizado"
oTemp:SetTotalInLine(.F.)

oReport:Section(1):SetEdit(.F.)
oReport:Section(2):SetEdit(.F.)
oReport:Section(3):SetEdit(.F.)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Marco Bianchi          � Data �04.05.2006���
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
Static Function ReportPrint(oReport,oEstatFat,oPercent,oTemp,cPrazo1,cPrazo2,cPrazo3,cPrazo4,cPrazo5,cPrazo6,lTotalSec)

Local dDatAnt	:= CTOD("  /  /  ")
Local cNotAnt	:= ""
Local nAc1 := nAc2 := nAc3 := nAc4 := nAc5 := nAc6 := 0
Local nAg1 := nAg2 := nAg3 := nAg4 := nAg5 := nAg6	:= 0
Local nSoma		:= 0
Local nDecs		:= msdecimais(mv_par09) //numero de decimais da moeda selecionda
Local nY		:= 0
Local cQuery    := ""
Local cWhere    := ""
Local cAliasSD1 := "SD1"
Local cDoc  	:= ""
Local cSerie	:= ""
Local cItem 	:= ""
Local cCod  	:= ""
Local nAgImpInc	:= 0
Local cChave    := ""
Local nRecnoSE1 := 0
Local lImpFat   := .F.
Local cNotFat   := ""
Local cFilSE1   := ""
Local cFilSF2   := ""
Local cFilSD2   := ""
Local aFaturas  := {}

oReport:Section(1):Cell("TEXTO"   ):SetTitle("")
oReport:Section(1):Cell("EMISSAO" ):SetBlock({|| dDatAnt })
oReport:Section(1):Cell("NOTA"    ):SetBlock({|| Substr(cNotFat,1,TamSX3("F2_DOC")[1]) })
oReport:Section(1):Cell("CLIENTE" ):SetBlock({|| SA1->A1_NREDUZ })
oReport:Section(1):Cell("PRAZO1"  ):SetBlock({|| nAd1 })
oReport:Section(1):Cell("PRAZO2"  ):SetBlock({|| nAd2 })
oReport:Section(1):Cell("PRAZO3"  ):SetBlock({|| nAd3 })
oReport:Section(1):Cell("PRAZO4"  ):SetBlock({|| nAd4 })
oReport:Section(1):Cell("PRAZO5"  ):SetBlock({|| nAd5 })
oReport:Section(1):Cell("PRAZO6"  ):SetBlock({|| nAd6 })
oReport:Section(1):Cell("TOTAL"   ):SetBlock({|| nAd1+nAd2+nAd3+nAd4+nAd5+nAd6 })
dDatAnt:= CTOD("  /  /  ")
cNotFat:= ""
nAd1 := nAd2:= nAd3:= nAd4:= nAd5:= nAd6:= 0

//��������������������������������������������������������������Ŀ
//� Prazos a serem impressos no cabecalho de acordo com parame-  �
//� tros inform,ado pelo usuario.                                �
//����������������������������������������������������������������
IF mv_par03 = 0
	cPrazo1 := STR0030			//"A Vista"
Else
	cPrazo1 := Space(04)+Str(mv_par03,3)
EndIF
cPrazo2 := Str(mv_par04,3) + STR0031		// " DIAS       "
cPrazo3 := Str(mv_par05,3) + STR0031		
cPrazo4 := Str(mv_par06,3) + STR0031		
cPrazo5 := Str(mv_par07,3) + STR0031		
cPrazo6 := Str(mv_par08,3) + STR0032		// " ou + DIAS"

oReport:Section(1):Cell("PRAZO1"):SetTitle(cPrazo1)
oReport:Section(1):Cell("PRAZO2"):SetTitle(cPrazo2)
oReport:Section(1):Cell("PRAZO3"):SetTitle(cPrazo3)
oReport:Section(1):Cell("PRAZO4"):SetTitle(cPrazo4)
oReport:Section(1):Cell("PRAZO5"):SetTitle(cPrazo5)
oReport:Section(1):Cell("PRAZO6"):SetTitle(cPrazo6)

//��������������������������������������������������������������Ŀ
//� Definicao celulas das Secoes                                 �
//����������������������������������������������������������������
// Altera o Titulo do Relatorio de acordo com Moeda escolhida
oReport:SetTitle(oReport:Title() + " - " + GetMv("MV_MOEDA"+STR(MV_PAR09,1)) )		// "** ESTATISTICA DO FATURAMENTO POR PRAZO DE PAGAMENTO **"

// Verifica se imprime total da secao ou nao
If oReport:Section(1):GetOrder() == 1		// Se Detalhado imprime Total da Secao e Geral
	lTotalSec := .T.						// Senao imprime apenas total geral
Else 
	lTotalSec := .F.
EndIf


//��������������������������������������������������������������Ŀ
//� Secao dos Porcentuais                                        �
//� As colunas EMISSAO, NOTA E TOTAL sao colocadas nesta seca    �
//� apenas para alinhas as colunas de percentuais                �
//� com as colunas de valores. Estas 3 colunas nao sao impressas �
//����������������������������������������������������������������
oPercent:SetHeaderSection(.F.)
TRCell():New(oPercent,STR0035	,/*Tabela*/,STR0027,/*Picture*/                  ,11						,/*lPixel*/,{|| STR0035} )								// "Emissao"
TRCell():New(oPercent,"EMISSAO"	,/*Tabela*/,STR0027,PesqPict("SE1","E1_EMISSAO"	),8						,/*lPixel*/,/*{|| code-block de impressao}*/	)		// "Emissao"
TRCell():New(oPercent,"NOTA"	,/*Tabela*/,STR0028,PesqPict("SE1","E1_NUM"		),TamSX3("E1_NUM"		)[1],/*lPixel*/,/*{|| code-block de impressao}*/	)		// "Nota Fiscal"
TRCell():New(oPercent,"CLIENTE"	,/*Tabela*/,'Nome Fantasia',PesqPict("SA1","A1_NREDUZ"		),TamSX3("A1_NREDUZ"		)[1],/*lPixel*/,/*{|| code-block de impressao}*/	)		// "Nota Fiscal"
TRCell():New(oPercent,"PERC1"	,/*Tabela*/,cPrazo1,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| (nAg1*100)/nSoma},,,"RIGHT"	)		// Percentual do Prazo 1 em relacao ao Total
TRCell():New(oPercent,"PERC2"	,/*Tabela*/,cPrazo2,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| (nAg2*100)/nSoma},,,"RIGHT"	)		// Percentual do Prazo 2 em relacao ao Total
TRCell():New(oPercent,"PERC3"	,/*Tabela*/,cPrazo3,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| (nAg3*100)/nSoma},,,"RIGHT"	)		// Percentual do Prazo 3 em relacao ao Total
TRCell():New(oPercent,"PERC4"	,/*Tabela*/,cPrazo4,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| (nAg4*100)/nSoma},,,"RIGHT"	)		// Percentual do Prazo 4 em relacao ao Total
TRCell():New(oPercent,"PERC5"	,/*Tabela*/,cPrazo5,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| (nAg5*100)/nSoma},,,"RIGHT"	)		// Percentual do Prazo 5 em relacao ao Total
TRCell():New(oPercent,"PERC6"	,/*Tabela*/,cPrazo6,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,{|| (nAg6*100)/nSoma},,,"RIGHT"	)		// Percentual do Prazo 6 em relacao ao Total
TRCell():New(oPercent,"TOTAL"	,/*Tabela*/,STR0029,PesqPict("SE1","E1_VALOR"	),TamSX3("E1_VALOR"		)[1],/*lPixel*/,/*{|| code-block de impressao}*/	)		// "Total"
oPercent:Cell("TOTAL"):SetHeaderAlign("RIGHT")

//��������������������������������������������������������������Ŀ
//� Cria Arquivo de Trabalho para Indexacao                      �
//����������������������������������������������������������������
oEstatFat:SetFilter(".T.","E1_FILIAL+DTOS(E1_EMISSAO)+E1_NUM+E1_PREFIXO+E1_TIPO",,"SE1")

//�������������������������������Ŀ
//� Inicializa variaveis.         �
//���������������������������������
nAgImpInc	:= 0
nAg1 := nAg2 := nAg3 := nAg4 := nAg5 := nAg6 := 0

If len(oReport:Section(1):GetAdvplExp("SE1")) > 0
	cFilSE1 := oReport:Section(1):GetAdvplExp("SE1")
EndIf
If len(oReport:Section(1):GetAdvplExp("SF2")) > 0
	cFilSF2 := oReport:Section(1):GetAdvplExp("SF2")
EndIf
If len(oReport:Section(1):GetAdvplExp("SD2")) > 0
	cFilSD2 := oReport:Section(1):GetAdvplExp("SD2")
EndIf

oReport:Section(1):Init()
oReport:SetMeter(SE1->(LastRec()))
cChave := (xFilial()+DTOS(mv_par01))
dbSelectArea("SE1")
MSSeek(cChave,.T.)

While !Eof() .And. E1_FILIAL == xFilial() .And. E1_EMISSAO >= mv_par01 .And. E1_EMISSAO <= mv_par02

	lImp := .F.	
	// Verifica filtro do usuario
	If !Empty(cFilSE1) .And. !(&cFilSE1)
		dbSelectArea("SE1")	
   	dbSkip()
	   Loop
	EndIf	
	
	//�������������������������������Ŀ
	//� Zera variaveis de impressao.  �
	//���������������������������������
	nDiant 		:= DAY(E1_EMISSAO)
	dDatAnt 	:= Ctod("  /  /  ")
	nAcImpInc	:= 0
	If oReport:Section(1):GetOrder() == 2
		nAc1 := nAc2 :=	nAc3 :=	nAc4 :=	nAc5 :=	nAc6 := 0
	EndIf	

	While !Eof() .And. xFilial() == E1_FILIAL .And. nDiant = DAY(E1_EMISSAO)
			
		//�������������������������������Ŀ
		//� Zera variaveis de impressao.  �
		//���������������������������������
		cNotAnt		:= E1_NUM+E1_SERIE
		nAdImpInc	:= 0
		nAd1 :=	nAd2 :=	nAd3 := nAd4 := nAd5 := nAd6 := 0
		
		//�����������������������������������������������������Ŀ
		//� Considera apenas titulos lancados pelo faturamento. �
		//�������������������������������������������������������
		If SE1->E1_TIPO != Substr(MVNOTAFIS,1,3)
			dbSkip()
			Loop
		Endif

		If !Empty(SE1->E1_FATURA) .And. AllTrim(SE1->E1_FATURA) == "NOTFAT"
			dbSkip()
			Loop
        EndIf

		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial()+cNotAnt)    
		
		// Verifica filtro do usuario
		If !Empty(cFilSF2) .And. !(&cFilSF2)
			dbSelectArea("SE1")	
  			dbSkip()
		   Loop
		EndIf	
		
		
		//�����������������������������Ŀ
		//� Trato a Devolu��o de Vendas �
		//�������������������������������
		nDevol    		:= 0
		nDevolIPI 		:= 0
		nDevolImpInc	:= 0
		nDevolImp1		:= 0
		nDevolImp2		:= 0
		nDevolImp3		:= 0
		nDevolImp4		:= 0
		nDevolImp5		:= 0
		nDevolImp6		:= 0
		
		If mv_par10 == 1
		
			dbSelectArea("SD2")
			dbSetOrder(3)
			dbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE)
				
			If IsRemito(1,"SF2->F2_TIPODOC")
				dBSkip()
				Loop
			Endif 
			While !Eof() .And. 	xFilial()+SF2->F2_DOC+SF2->F2_SERIE == xFilial()+SD2->D2_DOC+SD2->D2_SERIE

				#IFDEF SHELL
					If SD2->D2_CANCEL == "S"
						SD2->(DbSkip())
						Loop
					Endif
				#ENDIF

				If IsRemito(1,"SD2->D2_TIPODOC")
					dBSkip()
					Loop
				Endif 
				
				// Verifica filtro do usuario
				If !Empty(cFilSD2) .And. !(&cFilSD2)
					dbSelectArea("SD2")	
	   			dbSkip()
				   Loop
				EndIf	
				
				dbSelectArea("SD1")
				dbSetOrder(2)
				#IFDEF TOP
                                
                    cDoc   		:= SF2->F2_DOC
                    cSerie 		:= SF2->F2_SERIE
                    cItem  		:= SD2->D2_ITEM
                    cCod   		:= SD2->D2_COD
					cAliasSD1 	:= GetNextAlias()
					cQuery 		:= "%"
					
					If cPaisLoc<>"BRA"
						cQuery += ",D1_VALIMP1,D1_VALIMP2,D1_VALIMP3,D1_VALIMP4,D1_VALIMP5,D1_VALIMP6"
					EndIf
					#IFDEF SHELL
			 			cQuery += ",D1_CANCEL"
					#ENDIF
					cQuery += "%"
					
					cWhere := "%"
					#IFDEF SHELL
			 	 		cWhere += "AND D1_CANCEL<>'S'"
					#ENDIF
					cWhere += "%"
					cOrder := "%" + SqlOrder(SD1->(IndexKey())) + "%"

					oReport:Section(3):BeginQuery()	
					BeginSql Alias cAliasSD1
					SELECT D1_FILIAL,D1_COD,D1_DTDIGIT,D1_TIPODOC,D1_TIPO,D1_ITEMORI,D1_NFORI,D1_SERIORI
					,D1_TOTAL,D1_VALDESC,D1_VALFRE,D1_SEGURO,D1_DESPESA,D1_VALIPI
					%Exp:cQuery%
					FROM %Table:SD1% SD1
					WHERE D1_FILIAL = %xFilial:SD1% AND SD1.%notdel%
					AND D1_DTDIGIT >= %Exp:DTOS(MV_PAR01)%
					AND D1_DTDIGIT <= %Exp:DTOS(MV_PAR02)% 
					AND D1_NFORI =  %Exp:cDoc%
					AND D1_SERIORI = %Exp:cSerie%
					AND D1_ITEMORI = %Exp:cItem%
					AND D1_COD = %Exp:cCod%
					AND D1_TIPO ='D'
					%Exp:cWhere%
					ORDER BY %Exp:cOrder%
					EndSql       
					oReport:Section(3):EndQuery(/*Array com os parametros do tipo Range*/)
					
				#ELSE
					(cAliasSD1)->(dbSeek(xFilial()+SD2->D2_COD))
				#ENDIF
				
				//��������������������������Ŀ
				//� Soma Devolucoes          �
				//����������������������������
				While !Eof() .And. (cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_COD == xFilial("SD1")+SD2->D2_COD
					#IFNDEF TOP
						#IFDEF SHELL
							If (cAliasSD1)->D1_CANCEL == "S"
								(cAliasSD1)->(DbSkip())
								Loop
							Endif
						#ENDIF
					#ENDIF

					If (cAliasSD1)->D1_DTDIGIT >= MV_PAR01 .And. (cAliasSD1)->D1_DTDIGIT <= MV_PAR02 .And.; 
					   (cAliasSD1)->D1_TIPO=="D" .And.;
					   AllTrim((cAliasSD1)->D1_ITEMORI) == SD2->D2_ITEM  .And.;
					   (cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI ==;
					   xFilial("SD1")+SF2->F2_DOC+SF2->F2_SERIE
					   
						If !IsRemito(1,"SD1->D1_TIPODOC")
							nDevol+=(((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)+(cAliasSD1)->D1_VALFRE+(cAliasSD1)->D1_SEGURO+(cAliasSD1)->D1_DESPESA)
                            If ( cPaisLoc=="BRA" )
								nDevolIPI+= (cAliasSD1)->D1_VALIPI
							Else
                               	nImpInc:=0
								aImpostos:=TesImpInf(SD2->D2_TES)
								For nY:=1 to Len(aImpostos)
									cCampImp:="SD2->"+(aImpostos[nY][2])
									If ( aImpostos[nY][3]=="1" )
										nImpInc 	+= &cCampImp 
									EndIf
								Next
                        		nDevolImpInc+=nImpInc
								nDevolImp1+=(cAliasSD1)->D1_VALIMP1
								nDevolImp2+=(cAliasSD1)->D1_VALIMP2
								nDevolImp3+=(cAliasSD1)->D1_VALIMP3
								nDevolImp4+=(cAliasSD1)->D1_VALIMP4
								nDevolImp5+=(cAliasSD1)->D1_VALIMP5
								nDevolImp6+=(cAliasSD1)->D1_VALIMP6
							EndIf
						EndIf
				
					EndIf
					dbSkip()
				EndDo
				#IFDEF TOP
					dbSelectArea(cAliasSD1)
					dbCloseArea()
					dbSelectArea("SD1")
				#ENDIF
				dbSelectArea("SD2")
				dbSkip()
			EndDo

		EndIf
		
		DbSelectArea("SE4")
		SE4->(DbSetOrder(1)) // --E4_FILIAL+E4_CODIGO
		SE4->(DbSeek(xFilial("SE4")+SF2->F2_COND))
		
		If 	(SE4->E4_TIPO == "9" .And. mv_par10 == 2) .Or. (SE4->E4_TIPO <> "9")		
			aVenc  := Condicao(100,SF2->F2_COND)
			If ( cPaisLoc=="BRA" )
				nDevol := ( nDevol + nDevolIPI ) / Len(aVenc)
			Else
				nDevol := ( nDevol + nDevolImpInc ) / Len(aVenc)
			EndIf
		EndIf
		
		dbSelectArea("SE1")
		cNotFat := cNotAnt
		dDatAnt := E1_EMISSAO
		While !Eof() .And. xFilial()+cNotAnt = E1_FILIAL+E1_NUM+E1_SERIE
			
			oReport:IncMeter()
			
			//�����������������������������������������������������Ŀ
			//� Considera apenas titulos lancados pelo faturamento, �
			//� a nao ser faturas geradas a partir de titulos       �
			//� (tipo NF) vindos do faturamento                     �
			//�������������������������������������������������������
			If SE1->E1_TIPO != Substr(MVNOTAFIS,1,3)
				dbSkip()
				Loop
			Endif   
			
			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			
			//�����������������������������������������������������Ŀ
			//� Se gerou fatura a partir de uma duplicata vinda do  �
			//� faturamento, considera a fatura (tipo FT) e nao a   �
			//� duplicata (tipo NF)                                 �
			//�������������������������������������������������������
			If !Empty(SE1->E1_FATURA) .And. AllTrim(SE1->E1_FATURA) != "NOTFAT"
				
				//�����������������������������������������������������Ŀ
				//� Caso mais de uma parcela desta nota gerou fatura,   �
				//� calcula o valor das faturas apenas atraves da pri-  �
				//� meira  duplicata e desconsidera as outras parcelas  �
				//� parcelas desta nota.                                �
				//�������������������������������������������������������
				If aScan(aFaturas,xFilial("SE1")+DTOS(SE1->E1_BAIXA)+SE1->E1_FATURA+SE1->E1_FATPREF+SE1->E1_TIPOFAT) == 0
					lImpFat := .T.
					cChave  := xFilial("SE1")+DTOS(SE1->E1_BAIXA)+SE1->E1_FATURA+SE1->E1_FATPREF+SE1->E1_TIPOFAT
					AADD(aFaturas,cChave)
					SE1->(dbSkip())
					nRecnoSE1 := SE1->(Recno())
					
					// Busca todas as faturas gerdas a partir de uma duplicata vinda do faturamento (tipo NF)
					MsSeek(cChave)
					While !Eof() .And. cChave == xFilial("SE1")+DTOS(SE1->E1_EMISSAO)+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_TIPO
					
						C560Valor(@nAd1,@nAd2,@nAd3,@nAd4,@nAd5,@nAd6,nDevol,nDecs)
					
					   dbSelectArea("SE1")
					   dbSkip()
					EndDo      
					dbGoTo(nRecnoSE1)
				Else
					dbSkip()	
				EndIf
				
	       Else
	       	If ((SE4->E4_TIPO == "9" .And. mv_par10 == 2) .Or. (SE4->E4_TIPO == "9" .And. nDevol == 0) .Or. SE4->E4_TIPO <> "9") 
					C560Valor(@nAd1,@nAd2,@nAd3,@nAd4,@nAd5,@nAd6,nDevol,nDecs)
				EndIf
				dbSkip()				
			EndIf

		EndDo
                  
		// Imprime Detalhado
		If oReport:Section(1):GetOrder() == 1 .And. !Empty(dDatAnt)
			oEstatFat:Cell("NOTA"):Show()
			oReport:Section(1):PrintLine()
			lImp := .T.
		EndIf
		
		// Variaveis Acumulados por Dia
		If oReport:Section(1):GetOrder() == 2
			nAc1 += nAd1
			nAc2 += nAd2
			nAc3 += nAd3
			nAc4 += nAd4
			nAc5 += nAd5
			nAc6 += nAd6
		EndIf	

		// Variaveis do Total Geral
		nAg1 += nAd1
		nAg2 += nAd2
		nAg3 += nAd3
		nAg4 += nAd4
		nAg5 += nAd5
		nAg6 += nAd6
		nSoma := nAg1+nAg2+nAg3+nAg4+nAg5+nAg6
		
		dbSelectArea("SE1")
		If lImpFat
			lImpFat := .F.
		EndIf
	EndDo
	
	// Imprime Total do Dia
	If !Empty(dDatAnt)
		If oReport:Section(1):GetOrder() == 1
			If lImp
				oEstatFat:SetTotalText(STR0036)
				oReport:Section(1):Finish()						// Imprime Total da Secao
				oReport:Section(1):init()
			EndIf	
		Else
			nAd1 := nAc1
			nAd2 := nAc2
			nAd3 := nAc3
			nAd4 := nAc4
			nAd5 := nAc5
			nAd6 := nAc6
			oEstatFat:Cell("NOTA"):Hide()
			oReport:Section(1):PrintLine()
		EndIf	
	Endif
	
EndDo

// Imprime Total geral
oReport:Section(1):SetPageBreak(.T.)				// Imprime o Total Geral no Final do Relatorio

// Imprime Porcentuais
If nSoma != 0
    oReport:SkipLine()
	oReport:Section(2):Init()
	oReport:Section(2):PrintLine()
	oReport:Section(2):Finish()
EndIf

//��������������������������������������������������������������Ŀ
//� Restaura a integriade da rotina                              �
//����������������������������������������������������������������
dbSelectArea("SE1")
RetIndex("SE1")
dbClearFilter()
dbSetOrder(1)

dbSelectArea("SF2")
dbSetOrder(1)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR560  � Autor � Wagner Xavier         � Data � 14.04.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Estatistica de Venda por Prazo de Pagamento                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR560(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Ana Claudia  �17/12/98�XXXXXX�Inclusao de IFDEF SHELL                 ���
��� Edson   M.   �30/03/99�XXXXXX�Passar o tamanho na SetPrint.           ��� 
��� Marcello     �26/08/00�oooooo�Impressao de casas decimais de acordo   ���
���              �        �      �com a moeda selecionada.                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Matr560R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL aOrd := { OemToAnsi(STR0001), OemToAnsi(STR0002) }		//" Diario - Detalhado "###" Diario - Totalizado "
LOCAL CbTxt,wnRel
LOCAL titulo := OemToAnsi(STR0003)	//"Faturamento por Prazo de Pagamento"
LOCAL cDesc1 := OemToAnsi(STR0004)	//"Este relatorio ira emitir a relacao de Faturamento por"
LOCAL cDesc2 := OemToAnsi(STR0005)	//"ordem de Prazo de Pagamento. Poderao ser escolhidos os inter-"
LOCAL cDesc3 := OemToAnsi(STR0006)	//"valos atraves da opcao Parametros."
LOCAL tamanho:="M"
LOCAL limite :=132
LOCAL cString:="SE1"

PRIVATE aReturn := { OemToAnsi(STR0007), 1,OemToAnsi(STR0008), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR560"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="MTR560"
//�������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                          �
//���������������������������������������������������������������
Pergunte("MTR560",.F.)
//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                        �
//� mv_par01        	// A partir da data                     �
//� mv_par02        	// Ate a data                           �
//� mv_par03        	// 1� Intervalo                         �
//� mv_par04      	    // 2� Intervalo                         �
//� mv_par05      	    // 3� Intervalo                         �
//� mv_par06        	// 4� Intervalo                         �
//� mv_par07      	    // 5� Intervalo                         �
//� mv_par08			// 6� Intervalo                         �
//� mv_par09			// Qual Moeda                           �
//� mv_par10			// Inclui Devolu��o                     �
//� mv_par11			// Vencto. Real  SimXNao                �
//���������������������������������������������������������������
//�������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                       �
//���������������������������������������������������������������
wnrel := "MATR560"

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C560Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C560IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR560			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C560Imp(lEnd,WnRel,cString)

Local CbTxt
Local titulo := OemToAnsi(STR0003)	//"Faturamento por Prazo de Pagamento"
Local cDesc1 := OemToAnsi(STR0004)	//"Este relatorio ira emitir a relacao de Faturamento por"
Local cDesc2 := OemToAnsi(STR0005)	//"ordem de Prazo de Pagamento. Poderao ser escolhidos os inter-"
Local cDesc3 := OemToAnsi(STR0006)	//"valos atraves da opcao Parametros."
Local CbCont,cabec1,cabec2
Local nTipo,nOrdem,nY
Local tamanho:="M"
Local limite :=132
Local lContinua := .T.,cNotAnt,nDiAnt
Local nTotlinha,nAd1,nAd2,nAd3,nAd4,nAd5,nAd6
Local nAc1,nAc2,nAc3,nAc4,nAc5,nAc6
Local nAg1,nAg2,nAg3,nAg4,nAg5,nAg6
Local nSoma,cPeriodo1,cPeriodo2,cPeriodo3,cPeriodo4,cPeriodo5,cPeriodo6
Local aOrd := { OemToAnsi(STR0001), OemToAnsi(STR0002) }		//" Diario - Detalhado "###" Diario - Totalizado "
Local cChave
Local nDevol, nDevolIPI, aVenc := { }
Local nTamNf := TamSX3("F2_DOC")[1]
Local nDevolImp1,nDevolImp2,nDevolImp3,nDevolImp4,nDevolImp5,nDevolImp6,nDevolImpInc,nImpInc
Local cAliasSD1 := "SD1"
Local cQuery    := ""
Local nRecnoSE1 := 0
Local lImpFat   := .F.
Local cNotFat   := ""
Local aFaturas  := {}

// variaveis criadas para realinhamento das colunas para o Mexico (factura com 20 digitos)
Local aColuna   := IIf(cPaisLoc=="MEX",{33,47,61,75,89,103},{25,40,56,71,86,101})
Local aColPerc  := IIf(cPaisLoc=="MEX",{40,54,68,82,96,110},{33,48,64,79,94,109})
Local nTamVal   := IIf(cPaisLoc=="MEX",13,14)
Local cStr012   := Substr(STR0012,1,11)		

Private aImpostos:={}
Private nDecs:=msdecimais(mv_par09) //numero de decimais da moeda selecionda

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt := SPACE(10)
cbcont:= 0
li    := 80
m_pag := 1

//��������������������������������������������������������������Ŀ
//� Monta Periodos de acordo com escolha do usuario              �
//����������������������������������������������������������������
IF mv_par03 = 0
	cPeriodo1 := OemToAnsi(STR0009)	//"A Vista"
Else
	cPeriodo1 := Space(04)+Str(mv_par03,3)
EndIF

cPeriodo2 := Str(mv_par04,3)
cPeriodo3 := Str(mv_par05,3)
cPeriodo4 := Str(mv_par06,3)
cPeriodo5 := Str(mv_par07,3)
cPeriodo6 := Str(mv_par08,3)

//��������������������������������������������������������������Ŀ
//� Tipo de Impressao e Cabecalhos                               �
//����������������������������������������������������������������
nTipo := IIF(aReturn[4]=1,15,18)

nOrdem := aReturn[8]
titulo:= STR0010+ " - " + GetMv("MV_MOEDA"+STR(MV_PAR09,1)) // **  ESTATISTICA DO FATURAMENTO POR PRAZO DE PAGAMENTO **     "

If cPaisLoc <> "MEX"
	cabec1:= STR0011+cPeriodo1+"        "+cPeriodo2+STR0012+cPeriodo3+STR0012+cPeriodo4+STR0012+cPeriodo5+STR0012+cPeriodo6+ ;		//"EMISSAO    NOTA            "###" DIAS        "###" DIAS        "###" DIAS        "###" DIAS        "
				STR0013	//" ou + DIAS        T O T A L"
Else 
	cabec1:= STR0011+Space(7)+cPeriodo1+"      "+cPeriodo2+cStr012+cPeriodo3+cStr012+cPeriodo4+cStr012+cPeriodo5+cStr012+cPeriodo6+ ;		//"EMISSAO    NOTA            "###" DIAS        "###" DIAS        "###" DIAS        "###" DIAS        "
				STR0013	//" ou + DIAS        T O T A L"
EndIf				
cabec2:= STR0014	//"          FISCAL                                                                                                              "

//��������������������������������������������������������������Ŀ
//� Cria Arquivo de Trabalho para Indexacao                      �
//����������������������������������������������������������������
cNomArq := criatrab("",.f.)
dbSelectArea("SE1")
IndRegua("SE1",cNomArq,"E1_FILIAL+DTOS(E1_EMISSAO)+E1_NUM+E1_PREFIXO+E1_TIPO",,,STR0015)	//"Selecionando Registros..."

cChave := (xFilial()+DTOS(mv_par01))
dbSeek(cChave,.T.)

SetRegua(RecCount())		// Total de Elementos da regua
IncRegua()
//�������������������������������Ŀ
//� Inicializa variaveis.         �
//���������������������������������
nAgImpInc:=0
nAg1:=0
nAg2:=0
nAg3:=0
nAg4:=0
nAg5:=0
nAg6:=0

While !Eof() .And. lContinua  .And. E1_FILIAL == xFilial() ;
		.And. E1_EMISSAO >= mv_par01 ;
		.And. E1_EMISSAO <= mv_par02
	
	//�������������������������������Ŀ
	//� Zera variaveis de impressao.  �
	//���������������������������������
	nDiant := DAY(E1_EMISSAO)
	dDatAnt := Ctod("  /  /  ")
	nAcImpInc:=0
	nAc1:=0
	nAc2:=0
	nAc3:=0
	nAc4:=0
	nAc5:=0
	nAc6:=0
	
	While !Eof() .And. lContinua .And. xFilial() == E1_FILIAL ;
					.And. nDiant = DAY(E1_EMISSAO)
			
		//�������������������������������Ŀ
		//� Zera variaveis de impressao.  �
		//���������������������������������
		cNotAnt := E1_NUM+E1_SERIE
		nAdImpInc:=0
		nAd1:=0
		nAd2:=0
		nAd3:=0
		nAd4:=0
		nAd5:=0
		nAd6:=0
		
		IncRegua()
		
		//�����������������������������������������������������Ŀ
		//� Considera apenas titulos lancados pelo faturamento. �
		//�������������������������������������������������������
		If SE1->E1_TIPO != Substr(MVNOTAFIS,1,3)
			dbSkip()
			Loop
		Endif          
		
		If !Empty(SE1->E1_FATURA) .And. AllTrim(SE1->E1_FATURA) == "NOTFAT"
			dbSkip()
			Loop
        EndIf

		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial()+cNotAnt)    
		
		//�����������������������������Ŀ
		//� Trato a Devolu��o de Vendas �
		//�������������������������������
		nDevol    := 0
		nDevolIPI := 0
		nDevolImpInc:=0
		nDevolImp1:= 0
		nDevolImp2:= 0
		nDevolImp3:= 0
		nDevolImp4:= 0
		nDevolImp5:= 0
		nDevolImp6:= 0
		
		If mv_par10 == 1

			dbSelectArea("SD2")
			dbSetOrder(3)
			dbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE)
				
			If IsRemito(1,"SF2->F2_TIPODOC")
				dBSkip()
				Loop
			Endif 
			While !Eof() .And. ;
				xFilial()+SF2->F2_DOC+SF2->F2_SERIE == xFilial()+SD2->D2_DOC+SD2->D2_SERIE

				#IFDEF SHELL
					If SD2->D2_CANCEL == "S"
						SD2->(DbSkip())
						Loop
					Endif
				#ENDIF

				If IsRemito(1,"SD2->D2_TIPODOC")
					dBSkip()
					Loop
				Endif 

				dbSelectArea("SD1")
				dbSetOrder(2)
				#IFDEF TOP
					cAliasSD1 := GetNextAlias()
			
					cQuery := "SELECT D1_FILIAL,D1_COD,D1_DTDIGIT,D1_TIPODOC,D1_TIPO,D1_ITEMORI,D1_NFORI,D1_SERIORI"
					cQuery += ",D1_TOTAL,D1_VALDESC,D1_VALFRE,D1_SEGURO,D1_DESPESA,D1_VALIPI"
					If cPaisLoc<>"BRA"
						cQuery += ",D1_VALIMP1,D1_VALIMP2,D1_VALIMP3,D1_VALIMP4,D1_VALIMP5,D1_VALIMP6"
					EndIf
					#IFDEF SHELL
			 	 		cQuery += ",D1_CANCEL"
					#ENDIF
					cQuery += " FROM " + RetSqlName("SD1") + " SD1 "
					cQuery += "WHERE "
					cQuery += "D1_FILIAL='"+xFilial("SD1")+"' AND "
					cQuery += "D1_COD='"+SD2->D2_COD+"' AND "
					#IFDEF SHELL
			 	 		cQuery += "D1_CANCEL<>'S' AND "
					#ENDIF
					cQuery += "D1_DTDIGIT>='" +DTOS(MV_PAR01)	+"' AND "
					cQuery += "D1_DTDIGIT<='" +DTOS(MV_PAR02)	+"' AND "
					cQuery += "D1_TIPO='D' AND "
					cQuery += "D1_ITEMORI='"+SD2->D2_ITEM+"' AND "
					cQuery += "D1_SERIORI='"+SF2->F2_SERIE+"' AND "
					cQuery += "D1_NFORI='"+SF2->F2_DOC+"' AND "
					cQuery += "SD1.D_E_L_E_T_=' '"
					cQuery += " ORDER BY "+SqlOrder(SD1->(IndexKey()))

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.F.,.T.)
					
					TcSetField(cAliasSD1,"D1_DTDIGIT","D",TamSx3("D1_DTDIGIT")[1],TamSx3("D1_DTDIGIT")[2])
					TcSetField(cAliasSD1,"D1_TOTAL","N",TamSx3("D1_TOTAL")[1],TamSx3("D1_TOTAL")[2])
					TcSetField(cAliasSD1,"D1_VALDESC","N",TamSx3("D1_VALDESC")[1],TamSx3("D1_VALDESC")[2])
					TcSetField(cAliasSD1,"D1_VALFRE","N",TamSx3("D1_VALFRE")[1],TamSx3("D1_VALFRE")[2])
					TcSetField(cAliasSD1,"D1_SEGURO","N",TamSx3("D1_SEGURO")[1],TamSx3("D1_SEGURO")[2])
					TcSetField(cAliasSD1,"D1_DESPESA","N",TamSx3("D1_DESPESA")[1],TamSx3("D1_DESPESA")[2])
					TcSetField(cAliasSD1,"D1_VALIPI","N",TamSx3("D1_VALIPI")[1],TamSx3("D1_VALIPI")[2])
					If cPaisLoc<>"BRA"
						TcSetField(cAliasSD1,"D1_VALIMP1","N",TamSx3("D1_VALIMP1")[1],TamSx3("D1_VALIMP1")[2])
						TcSetField(cAliasSD1,"D1_VALIMP2","N",TamSx3("D1_VALIMP2")[1],TamSx3("D1_VALIMP2")[2])
						TcSetField(cAliasSD1,"D1_VALIMP3","N",TamSx3("D1_VALIMP3")[1],TamSx3("D1_VALIMP3")[2])
						TcSetField(cAliasSD1,"D1_VALIMP4","N",TamSx3("D1_VALIMP4")[1],TamSx3("D1_VALIMP4")[2])
						TcSetField(cAliasSD1,"D1_VALIMP5","N",TamSx3("D1_VALIMP5")[1],TamSx3("D1_VALIMP5")[2])
						TcSetField(cAliasSD1,"D1_VALIMP6","N",TamSx3("D1_VALIMP6")[1],TamSx3("D1_VALIMP6")[2])
					EndIf
				#ELSE
					(cAliasSD1)->(dbSeek(xFilial()+SD2->D2_COD))
				#ENDIF
				
				//��������������������������Ŀ
				//� Soma Devolucoes          �
				//����������������������������
				While !Eof() .And. (cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_COD == xFilial("SD1")+SD2->D2_COD
					#IFNDEF TOP
						#IFDEF SHELL
							If (cAliasSD1)->D1_CANCEL == "S"
								(cAliasSD1)->(DbSkip())
								Loop
							Endif
						#ENDIF
					#ENDIF

					If (cAliasSD1)->D1_DTDIGIT >= MV_PAR01 .And. (cAliasSD1)->D1_DTDIGIT <= MV_PAR02 .And.; 
					   (cAliasSD1)->D1_TIPO=="D" .And.;
					   AllTrim((cAliasSD1)->D1_ITEMORI) == SD2->D2_ITEM  .And.;
					   (cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI ==;
					   xFilial("SD1")+SF2->F2_DOC+SF2->F2_SERIE
					   
						If !IsRemito(1,"SD1->D1_TIPODOC")
							nDevol+=(((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)+(cAliasSD1)->D1_VALFRE+(cAliasSD1)->D1_SEGURO+(cAliasSD1)->D1_DESPESA)
                            If ( cPaisLoc=="BRA" )
								nDevolIPI+= (cAliasSD1)->D1_VALIPI
							Else
                               	nImpInc:=0
								aImpostos:=TesImpInf(SD2->D2_TES)
								For nY:=1 to Len(aImpostos)
									cCampImp:="SD2->"+(aImpostos[nY][2])
									If ( aImpostos[nY][3]=="1" )
										nImpInc 	+= &cCampImp 
									EndIf
								Next
                                nDevolImpInc+=nImpInc
								nDevolImp1+=(cAliasSD1)->D1_VALIMP1
								nDevolImp2+=(cAliasSD1)->D1_VALIMP2
								nDevolImp3+=(cAliasSD1)->D1_VALIMP3
								nDevolImp4+=(cAliasSD1)->D1_VALIMP4
								nDevolImp5+=(cAliasSD1)->D1_VALIMP5
								nDevolImp6+=(cAliasSD1)->D1_VALIMP6
							EndIf
						EndIf
				
					EndIf
					dbSkip()
				EndDo
				#IFDEF TOP
					dbSelectArea(cAliasSD1)
					dbCloseArea()
					dbSelectArea("SD1")
				#ENDIF
				dbSelectArea("SD2")
				dbSkip()
			EndDo
		EndIf
		
		DbSelectArea("SE4")
		SE4->(DbSetOrder(1)) // --E4_FILIAL+E4_CODIGO
		SE4->(DbSeek(xFilial("SE4")+SF2->F2_COND))
		
		If 	(SE4->E4_TIPO == "9" .And. mv_par10 == 2) .Or. (SE4->E4_TIPO <> "9")
			aVenc  := Condicao(100,SF2->F2_COND)		
			If ( cPaisLoc=="BRA" )
				nDevol := ( nDevol + nDevolIPI ) / Len(aVenc)
			Else
				nDevol := ( nDevol + nDevolImpInc ) / Len(aVenc)
			EndIf
		EndIf
		
		dbSelectArea("SE1")
		cNotFat := cNotAnt
		dDatAnt := E1_EMISSAO

		While !Eof() .And. lContinua .And. xFilial()+cNotAnt = E1_FILIAL+E1_NUM+E1_SERIE
								
			IF lEnd
				@PROW()+1,001 PSAY STR0016	//"CANCELADO PELO OPERADOR"
				lContinua := .F.
				EXIT
			ENDIF
			                   
			IncRegua()
			
			//�����������������������������������������������������Ŀ
			//� Considera apenas titulos lancados pelo faturamento, �
			//� a nao ser faturas geradas a partir de titulos       �
			//� (tipo NF) vindos do faturamento                     �
			//�������������������������������������������������������
			If SE1->E1_TIPO != Substr(MVNOTAFIS,1,3)
				dbSkip()
				Loop
			Endif
			
			//�����������������������������������������������������Ŀ
			//� Se gerou fatura a partir de uma duplicata vinda do  �
			//� faturamento, considera a fatura (tipo FT) e nao a   �
			//� duplicata (tipo NF)                                 �
			//�������������������������������������������������������
			If !Empty(SE1->E1_FATURA) .And. AllTrim(SE1->E1_FATURA) != "NOTFAT"
				
				//�����������������������������������������������������Ŀ
				//� Caso mais de uma parcela desta nota gerou fatura,   �
				//� calcula o valor das faturas apenas atraves da pri-  �
				//� meira  duplicata e desconsidera as outras parcelas  �
				//� parcelas desta nota.                                �
				//�������������������������������������������������������
				If aScan(aFaturas,xFilial("SE1")+DTOS(SE1->E1_BAIXA)+SE1->E1_FATURA+SE1->E1_FATPREF+SE1->E1_TIPOFAT) == 0
					lImpFat := .T.
					cChave  := xFilial("SE1")+DTOS(SE1->E1_BAIXA)+SE1->E1_FATURA+SE1->E1_FATPREF+SE1->E1_TIPOFAT
					AADD(aFaturas,cChave)
					SE1->(dbSkip())
					nRecnoSE1 := SE1->(Recno())
					
					// Busca todas as faturas gerdas a partir de uma duplicata vinda do faturamento (tipo NF)
					MsSeek(cChave)
					While !Eof() .And. cChave == xFilial("SE1")+DTOS(SE1->E1_EMISSAO)+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_TIPO
					
						C560Valor(@nAd1,@nAd2,@nAd3,@nAd4,@nAd5,@nAd6,nDevol,nDecs)
					
					   dbSelectArea("SE1")
					   dbSkip()
					EndDo      
					dbGoTo(nRecnoSE1)
				Else
					dbSkip()	
				EndIf
				
	       Else
	        	If ((SE4->E4_TIPO == "9" .And. mv_par10 == 2) .Or. (SE4->E4_TIPO == "9" .And. nDevol == 0) .Or. SE4->E4_TIPO <> "9")
					C560Valor(@nAd1,@nAd2,@nAd3,@nAd4,@nAd5,@nAd6,nDevol,nDecs)
				EndIf
				dbSkip()				
			EndIf			
			
		End

		IF li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			li--
		EndIF
		If nOrdem == 1 .AND. !Empty(dDatAnt)
			li++
			@li,  0 PSAY dDatAnt
			@li, 11 PSAY Substr(cNotFat,1,nTamNF)
			
			@li, aColuna[1] PSAY nAd1		PicTure tm(nAd1,nTamVal,nDecs)
			@li, aColuna[2] PSAY nAd2		PicTure tm(nAd2,nTamVal,nDecs)
			@li, aColuna[3] PSAY nAd3		PicTure tm(nAd3,nTamVal,nDecs)
			@li, aColuna[4] PSAY nAd4		PicTure tm(nAd4,nTamVal,nDecs)
			@li, aColuna[5] PSAY nAd5		PicTure tm(nAd5,nTamVal,nDecs)
			@li, aColuna[6] PSAY nAd6		PicTure tm(nAd6,nTamVal,nDecs)
				
			nTotLinha := nAd1+nAd2+nAd3+nAd4+nAd5+nAd6
			@li,116 PSAY nTotLinha	PicTure tm(nTotLinha,16,nDecs)
		EndIf
		nAc1 := nAc1 + nAd1
		nAc2 := nAc2 + nAd2
		nAc3 := nAc3 + nAd3
		nAc4 := nAc4 + nAd4
		nAc5 := nAc5 + nAd5
		nAc6 := nAc6 + nAd6
		dbSelectArea("SE1")
		If lImpFat
			lImpFat := .F.
		EndIf
	EndDo
	
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li--
	EndIF
	
	If !Empty(dDatAnt)
	
		li+=2
		If nOrdem == 2
			li--
		EndIf
		
		@li,  0 PSAY If( nOrdem == 1,STR0017, DTOC(dDatAnt)+STR0018 )		//" TOTAL DO DIA --> "###" TOTAL ->"
		@li, aColuna[1] PSAY nAc1	PicTure tm(nAc1,nTamVal,nDecs)
		@li, aColuna[2] PSAY nAc2  	PicTure tm(nAc2,nTamVal,nDecs)
		@li, aColuna[3] PSAY nAc3	PicTure tm(nAc3,nTamVal,nDecs)
		@li, aColuna[4] PSAY nAc4	PicTure tm(nAc4,nTamVal,nDecs)
		@li, aColuna[5] PSAY nAc5	PicTure tm(nAc5,nTamVal,nDecs)
		@li, aColuna[6] PSAY nAc6	PicTure tm(nAc6,nTamVal,nDecs)
		nTotLinha := nAc1+nAc2+nAc3+nAc4+nAc5+nAc6
		@li,116 PSAY nTotLinha	PicTure tm(nTotLinha,16,nDecs)
		li++
	Endif
	nAg1 += nAc1
	nAg2 += nAc2
	nAg3 += nAc3
	nAg4 += nAc4
	nAg5 += nAc5
	nAg6 += nAc6
EndDo

IF li != 80
	li++
	@li,  1 PSAY STR0019 	//"TOTAL GERAL ---> "
	@li, aColuna[1] PSAY nAg1		PicTure tm(nAg1,nTamVal,nDecs)
	@li, aColuna[2] PSAY nAg2		PicTure tm(nAg2,nTamVal,nDecs)
	@li, aColuna[3] PSAY nAg3		PicTure tm(nAg3,nTamVal,nDecs)
	@li, aColuna[4] PSAY nAg4		PicTure tm(nAg4,nTamVal,nDecs)
	@li, aColuna[5] PSAY nAg5		PicTure tm(nAg5,nTamVal,nDecs)
	@li, aColuna[6] PSAY nAg6		PicTure tm(nAg6,nTamVal,nDecs)
	nSoma := nAg1+nAg2+nAg3+nAg4+nAg5+nAg6
	@li,116 PSAY nSoma		PicTure tm(nSoma,16,nDecs)
	
	IF nSoma != 0
		
		li+=2
		@li,  1 PSAY STR0020	//"PORCENTUAIS --->"
		@li, aColPerc[1] PSAY (nAg1*100)/nSoma	PicTure "999.99"
		@li, aColPerc[2] PSAY (nAg2*100)/nSoma	PicTure "999.99"
		@li, aColPerc[3] PSAY (nAg3*100)/nSoma	PicTure "999.99"
		@li, aColPerc[4] PSAY (nAg4*100)/nSoma	PicTure "999.99"
		@li, aColPerc[5] PSAY (nAg5*100)/nSoma	PicTure "999.99"
		@li, aColPerc[6] PSAY (nAg6*100)/nSoma	PicTure "999.99"
		li++
	EndIF
	IF li != 80
		roda(cbcont,cbtxt,Tamanho)
	EndIF
EndIF

//��������������������������������������������������������������Ŀ
//� Restaura a integriade da rotina                              �
//����������������������������������������������������������������

dbSelectArea("SE1")
RetIndex("SE1")
dbClearFilter()
If File(cNomArq+OrdbagExt())
	fErase(cNomArq+OrdbagExt())
Endif
dbSetOrder(1)

dbSelectArea("SF2")
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return .T.


      
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C560Valor � Autor � Marco Bianchi         � Data � 02/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula valor a ser impresso                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR560			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C560Valor(nAd1,nAd2,nAd3,nAd4,nAd5,nAd6,nDevol,nDecs)

Local nValor := 0
Local dVencto := ctod("  /  /  ")
      
If mv_par11 == 1
	dVencto := E1_VENCREA
Else
	dVencto := E1_VENCTO
Endif

nValor := XMoeda(E1_VALOR,SE1->E1_MOEDA,MV_PAR09,dVencto,nDecs+1) - nDevol
Do Case
	Case dVencto-E1_EMISSAO <= mv_par03
		nAd1 += nValor
	Case dVencto-E1_EMISSAO <= mv_par04
		nAd2 += nValor
	Case dVencto-E1_EMISSAO <= mv_par05
		nAd3 += nValor
	Case dVencto-E1_EMISSAO <= mv_par06
		nAd4 += nValor
	Case dVencto-E1_EMISSAO <= mv_par07
		nAd5 += nValor
	OtherWise
		nAd6 += nValor
EndCase


Return