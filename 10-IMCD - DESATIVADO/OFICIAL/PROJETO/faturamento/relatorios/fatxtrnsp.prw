#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATxTRNSP �Autor  �LEANDRO DUARTE      � Data �  03/29/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �RELATORIO DE FATURAMENTO X TRANSPORTADORA                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 E P12                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


USER FUNCTION FATxTRNSP()
	Private oReport
	Private aSec := {}
	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �LEANDRO DUARTE      � Data �  03/29/14   ���
�������������������������������������������������������������������������͹��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������͹��
���Uso       � P11 E P12                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportDef()

	Local cTitulo	:= "RELATORIO DE FATURAMENTO X TRANSPORTADORAS X ESTADO"
	Private cPerg   :=PADR("FATXTRNSP",10)
	Private oEmpFil := nil
	
	pergunte(cPerg,.f.)
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
	oReport:= TReport():New("FATXTRNSP",cTitulo,cPerg, {|oReport| ReportPrint(oReport)},cTitulo)
	oReport:SetPortrait(.F.)
	oReport:SetLandscape(.T.)

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
	// regra para gravar a localiza��o do SIGAMAT.EMP


	aadd(aSec,'Sess�o unica')
	oEmpFil := TRSection():New(oReport,cTitulo,{"TRB"},{"Orgem Unica"},/*Campos do SX3*/,/*Campos do SIX*/)	// "INSTRUTOR + NOME INSTRUTOR + FILIAL DO PRF. + MATRICULA + CARGO + TURMA + DT INICIO + DT FIM + COD CURSO + NOME CURSO + PERIODO + CATEGORIA + LINHA + CH + TOT ALUNOS + ALUNOS PGTO + PESQ RESP"
	oEmpFil:SetTotalInLine(.F.)
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
	//�ExpL7 : Informe se o tamanho esta em pixel                              �
	//�        Default : False                                                 �
	//�ExpB8 : Bloco de c�digo para impressao.                                 �
	//�        Default : ExpC2                                                 �
	//�                                                                        �
	//��������������������������������������������������������������������������

	TRCell():New(oEmpFil,"F2_DOC"		,"SF2",/*TITULO*/,/*Picture*/,TamSx3("F2_DOC")[1]		,/*lPixel*/,{|| F2_DOC  })
	TRCell():New(oEmpFil,"F2_EMISSAO"	,"SF2",/*TITULO*/,/*Picture*/,TamSx3("F2_EMISSAO")[1]	,/*lPixel*/,{|| F2_EMISSAO  })
	TRCell():New(oEmpFil,"F2_CLIENTE"	,"SF2",/*TITULO*/,/*Picture*/,TamSx3("F2_CLIENTE")[1]	,/*lPixel*/,{|| F2_CLIENTE  })
	TRCell():New(oEmpFil,"A1_NOME" 		,"SA1",/*TITULO*/,/*Picture*/,TamSx3("A1_NOME")[1]		,/*lPixel*/,{|| A1_NOME  })
	TRCell():New(oEmpFil,"A1_MUN" 		,"SF2",/*TITULO*/,/*Picture*/,TamSx3("A1_MUN")[1]		,/*lPixel*/,{|| A1_MUN  })
	TRCell():New(oEmpFil,"F2_EST" 		,"SF2",/*TITULO*/,/*Picture*/,TamSx3("F2_EST")[1]		,/*lPixel*/,{|| F2_EST  })
	TRCell():New(oEmpFil,"B1_COD" 		,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_COD")[1]		,/*lPixel*/,{|| B1_COD  })
	TRCell():New(oEmpFil,"B1_DESC"		,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_DESC")[1]		,/*lPixel*/,{|| B1_DESC  })
	TRCell():New(oEmpFil,"B1_UM"		,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_UM")[1]		,/*lPixel*/,{|| B1_UM  })
	TRCell():New(oEmpFil,"B1_EMB"		,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_EMB")[1]		,/*lPixel*/,{|| B1_EMB  })
	TRCell():New(oEmpFil,"Z2_DESC"		,"SZ2",/*TITULO*/,/*Picture*/,TamSx3("Z2_DESC")[1]		,/*lPixel*/,{|| Z2_DESC  })
	TRCell():New(oEmpFil,"D2_QUANT"		,"SD2",/*TITULO*/,/*Picture*/,TamSx3("D2_QUANT")[1]	,/*lPixel*/,{|| D2_QUANT  })
	TRCell():New(oEmpFil,"D2_TOTAL" 	,"SD2",/*TITULO*/,/*Picture*/,TamSx3("D2_TOTAL")[1]	,/*lPixel*/,{|| D2_TOTAL  })
	TRCell():New(oEmpFil,"B1_CLARIS"	,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_CLARIS")[1]	,/*lPixel*/,{|| B1_CLARIS  })
	TRCell():New(oEmpFil,"B1_NUMRIS"	,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_NUMRIS")[1]	,/*lPixel*/,{|| B1_NUMRIS  })
	TRCell():New(oEmpFil,"B1__CODONU"	,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1__CODONU")[1]	,/*lPixel*/,{|| B1__CODONU  })
	TRCell():New(oEmpFil,"F2_TRANSP"	,"SF2",/*TITULO*/,/*Picture*/,TamSx3("F2_TRANSP")[1]	,/*lPixel*/,{|| F2_TRANSP  })
	TRCell():New(oEmpFil,"A4_NOME"		,"SA4",/*TITULO*/,/*Picture*/,TamSx3("A4_NOME")[1]		,/*lPixel*/,{|| A4_NOME  })
	TRCell():New(oEmpFil,"B1_POLFED"	,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_POLFED")[1]	,/*lPixel*/,{|| B1_POLFED  })
	TRCell():New(oEmpFil,"B1_POLCIV"	,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_POLCIV")[1]	,/*lPixel*/,{|| B1_POLCIV  })
	TRCell():New(oEmpFil,"B1_MINEXEC"	,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_MINEXEC")[1]	,/*lPixel*/,{|| B1_MINEXEC  })
	TRCell():New(oEmpFil,"B1_ANP"		,"SB1",/*TITULO*/,/*Picture*/,TamSx3("B1_ANP")[1]		,/*lPixel*/,{|| B1_ANP  })

	//������������������������������������������������������������������������Ŀ
	//� Impressao do Cabecalho no top da pagina                                �
	//��������������������������������������������������������������������������
	oReport:Section(1):SetHeaderPage()

	//������������������������������������������������������������������������Ŀ
	//� Verifica as perguntas selecionadas 									   �
	//��������������������������������������������������������������������������

	Pergunte(oReport:uParam,.F.)

Return(oReport)

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint�Autor  �LEANDRO DUARTE      � Data �  03/29/14   ���
��������������������������������������������������������������������������͹��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
��������������������������������������������������������������������������͹��
���Uso       � P11 E P12                                                   ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function ReportPrint(oReport)

	Local aQuery:= {}
	//������������������������������������������������������������������������Ŀ
	//� SetBlock: faz com que as variaveis locais possam ser                   �
	//� utilizadas em outras funcoes nao precisando declara-las                �
	//� como private.                                                          �
	//��������������������������������������������������������������������������
	oReport:Section(1):Cell("F2_DOC"):SetBlock({|| F2_DOC	})
	oReport:Section(1):Cell("F2_EMISSAO"):SetBlock({|| F2_EMISSAO	})
	oReport:Section(1):Cell("F2_CLIENTE"):SetBlock({|| F2_CLIENTE	})
	oReport:Section(1):Cell("A1_NOME"):SetBlock({|| A1_NOME	})
	oReport:Section(1):Cell("A1_MUN"):SetBlock({|| A1_MUN	})
	oReport:Section(1):Cell("F2_EST"):SetBlock({|| F2_EST	})
	oReport:Section(1):Cell("B1_COD"):SetBlock({|| B1_COD	})
	oReport:Section(1):Cell("B1_DESC"):SetBlock({|| B1_DESC	})
	oReport:Section(1):Cell("B1_UM"	):SetBlock({|| B1_UM  })
	oReport:Section(1):Cell("B1_EMB"):SetBlock({||  B1_EMB  })
	oReport:Section(1):Cell("Z2_DESC"):SetBlock({||  Z2_DESC  })
	oReport:Section(1):Cell("D2_QUANT"):SetBlock({|| D2_QUANT	})
	oReport:Section(1):Cell("D2_TOTAL"):SetBlock({|| D2_TOTAL	})
	oReport:Section(1):Cell("B1_CLARIS"):SetBlock({|| B1_CLARIS	})
	oReport:Section(1):Cell("B1_NUMRIS"):SetBlock({|| B1_NUMRIS	})
	oReport:Section(1):Cell("B1__CODONU"):SetBlock({|| B1__CODONU	})
	oReport:Section(1):Cell("F2_TRANSP"):SetBlock({|| F2_TRANSP	})
	oReport:Section(1):Cell("A4_NOME"):SetBlock({|| A4_NOME	})
	oReport:Section(1):Cell("B1_POLFED"):SetBlock({|| B1_POLFED  })
	oReport:Section(1):Cell("B1_POLCIV"	):SetBlock({|| B1_POLCIV  })
	oReport:Section(1):Cell("B1_MINEXEC"):SetBlock({|| B1_MINEXEC  })
	oReport:Section(1):Cell("B1_ANP"):SetBlock({|| B1_ANP  })


	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)

	//������������������������������������������������������������������������Ŀ
	//�Posiciona SB1 para antes da impressao                                   �
	//��������������������������������������������������������������������������
	//TRPosition():New(oReport:Section(1),"SB1",1,{|| xFilial("SB1") + TRB->D2_COD })

	cAliasTRB := GetNextAlias()

	oReport:Section(1):BeginQuery()

	BeginSql Alias cAliasTRB
		SELECT F2_DOC, F2_EMISSAO, F2_CLIENTE, A1_NOME, A1_MUN, F2_EST, B1_COD, B1_DESC, D2_QUANT, D2_TOTAL, B1_CLARIS, B1_NUMRIS, B1__CODONU, F2_TRANSP, A4_NOME, B1_ANP, B1_MINEXEC, B1_POLCIV, B1_POLFED, B1_UM, B1_EMB, Z2_DESC 
		FROM %table:SF2% A, %table:SA1% B, %table:SD2% C, %table:SA4% D, %table:SB1% E, %table:SZ2% F
		WHERE B.A1_FILIAL = %xfilial:SA1%
		AND D.A4_FILIAL = %xfilial:SA4%
		AND E.B1_FILIAL = %xfilial:SB1%
		AND F.Z2_FILIAL = %xfilial:SZ2%
		AND A.%notDel%
		AND B.%notDel%
		AND C.%notDel%
		AND D.%notDel%
		AND E.%notDel%
		AND F.%notDel%
		AND A.F2_DOC = C.D2_DOC
		AND A.F2_SERIE = C.D2_SERIE
		AND A.F2_CLIENTE = B.A1_COD
		AND A.F2_LOJA = B.A1_LOJA
		AND A.F2_TRANSP = D.A4_COD
		AND C.D2_COD = E.B1_COD
		AND F.Z2_COD = E.B1_EMB
		AND A.F2_EMISSAO >= %Exp:mv_par01%
		AND A.F2_EMISSAO <= %Exp:mv_par02%
		AND A.F2_FILIAL >= %Exp:mv_par03%
		AND A.F2_FILIAL <= %Exp:mv_par04%
		AND C.D2_FILIAL >= %Exp:mv_par03%
		AND C.D2_FILIAL <= %Exp:mv_par04%
		AND E.B1_COD >= %Exp:mv_par05%
		AND E.B1_COD <= %Exp:mv_par06%
		AND A.F2_EST >= %Exp:mv_par07%
		AND A.F2_EST <= %Exp:mv_par08% 
		ORDER BY 1,2,3,4,5,6
	EndSql

	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

	//������������������������������������������������������������������������Ŀ
	//� Gera Arqiuvo Temporario                                                �
	//��������������������������������������������������������������������������
	(cAliasTRB)->(dbGoTop())
	oReport:SetMeter(RecCount())
	oReport:Section(1):Init()
	While !oReport:Cancel() .And. (cAliasTRB)->(!Eof())
		//��������������������������������������������������������������Ŀ
		//�processo de alimentar as variaveis para adicionar no relatorio�
		//����������������������������������������������������������������
		F2_DOC		:= (cAliasTRB)->F2_DOC
		F2_EMISSAO	:= (cAliasTRB)->F2_EMISSAO
		F2_CLIENTE	:= (cAliasTRB)->F2_CLIENTE
		A1_NOME		:= (cAliasTRB)->A1_NOME
		A1_MUN		:= (cAliasTRB)->A1_MUN
		F2_EST		:= (cAliasTRB)->F2_EST
		B1_COD		:= (cAliasTRB)->B1_COD
		B1_DESC		:= (cAliasTRB)->B1_DESC
		D2_QUANT	:= (cAliasTRB)->D2_QUANT //transform((cAliasTRB)->D2_QUANT,"@E 999,999,999,999")
		D2_TOTAL	:= (cAliasTRB)->D2_TOTAL //transform((cAliasTRB)->D2_TOTAL,"@E 999,999,999,999.99")
		B1_CLARIS	:= (cAliasTRB)->B1_CLARIS
		B1_NUMRIS	:= (cAliasTRB)->B1_NUMRIS
		B1__CODONU	:= (cAliasTRB)->B1__CODONU
		F2_TRANSP	:= (cAliasTRB)->F2_TRANSP
		A4_NOME		:= (cAliasTRB)->A4_NOME
		B1_POLFED	:= (cAliasTRB)->B1_POLFED  
		B1_POLCIV	:= (cAliasTRB)->B1_POLCIV  
		B1_MINEXEC	:= (cAliasTRB)->B1_MINEXEC 
		B1_ANP		:= (cAliasTRB)->B1_ANP  
		B1_UM		:= (cAliasTRB)->B1_UM  
		B1_EMB		:= (cAliasTRB)->B1_EMB  
		Z2_DESC		:= (cAliasTRB)->Z2_DESC 


		oReport:Section(1):Cell("F2_DOC"):Show()//HIDE()"
		oReport:Section(1):Cell("F2_EMISSAO"):Show()//HIDE()"
		oReport:Section(1):Cell("F2_CLIENTE"):Show()//HIDE()"
		oReport:Section(1):Cell("A1_NOME"):Show()//HIDE()"
		oReport:Section(1):Cell("A1_MUN"):Show()//HIDE()"
		oReport:Section(1):Cell("F2_EST"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_COD"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_DESC"):Show()//HIDE()"
		oReport:Section(1):Cell("D2_QUANT"):Show()//HIDE()"
		oReport:Section(1):Cell("D2_TOTAL"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_CLARIS"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_NUMRIS"):Show()//HIDE()"
		oReport:Section(1):Cell("B1__CODONU"):Show()//HIDE()"
		oReport:Section(1):Cell("F2_TRANSP"):Show()//HIDE()"
		oReport:Section(1):Cell("A4_NOME"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_POLFED"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_POLCIV"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_MINEXEC"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_ANP"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_UM"):Show()//HIDE()"
		oReport:Section(1):Cell("B1_EMB"):Show()//HIDE()"
		oReport:Section(1):Cell("Z2_DESC"):Show()//HIDE()"

		oReport:Section(1):PrintLine()//imprime a linha

		oReport:IncMeter()

		//	oReport:ThinLine()


		(cAliasTRB)->(dbskip())
	End

	oReport:Section(1):SetTotalText("TOTAL")//+ " " + AllTrim(RetTitle(cVaria)) + " " + &cCampo)		// "TOTAL"
	oReport:Section(1):Finish()
	oReport:Section(1):SetPageBreak()
	(cAliasTRB)->(dbCloseArea())

Return