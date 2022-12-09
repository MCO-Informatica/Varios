#INCLUDE "Totvs.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRPR100   � Autor � Renato Ruy         � Data �  21/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CRPR220()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat�rio de Lan�amentos de Remunera��o - SAGE"
Local cPict          := ""
Local titulo         := "Relat�rio de Lan�amentos de Remunera��o - SAGE"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "CRP220" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "CRP220"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELSAGE" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ6"

dbSelectArea("SZ6")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
Processa( {|| RunReport(Cabec1,Cabec2,Titulo,nLin)  }, "Gerando Relat�rio...")

//RptStatus({|| },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  21/05/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _aDados := {}
Local aCabec  := {}
Local cCCRAnt := ""
Local cPosAnt := ""
Local cPosPai := ""
Local cQuebra := "1"
Local cWhere  := " "
Local cLin	  := " "
Local cLinFw  := " "
Local nContFw := 0
Local nContMsg:= 0
Local nBasCom := 0
Local nBasSof := 0
Local nBasHar := 0
Local nAbtVal := 0
Local nValPro := 0
Local nValSof := 0
Local nValHar := 0
Local nComPro := 0
Local nComSof := 0 
Local nComHar := 0
Local nValFed := 0
Local nFedera := 0
Local nComFed := 0
Local nConCer := 0
Local nConHar := 0
Local nConSof := 0
Local nContBio:= 0
Local nTotBio := 0
Local nContar := 0 
Local cPedAnt := ""
Local dDatAnt := CtoD("  /  /  ")
Local cArq 	  := ""
Local cVisita := "--;"
Local nVisita := 0
Local cNomArq := ""
Local nCA0009 := 0
Local nHdl    := 0
Local lReemb  := .T. //Verifica se e um reembolso ou reembolso parcial. (.T. - Reembolso Total ou .F. - Reembolso parcial)
Local aLastQuery := {}
Local cLastQuery := ""
Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif
Alert(ValType(MV_PAR06))
//Fa�o condi��o para alimentar o where
If MV_PAR06 == 1
	cWhere := "% IN ('4','3') %"
	cNomArq:= "SAGE - Geral Posto"
ElseIf MV_PAR06 == 2
	cWhere := "% = '2' %"
	cNomArq:= "SAGE - Geral AC"
ElseIf MV_PAR06 == 3
	cWhere := "% = '1' %"
	cNomArq:= "SAGE - Geral Canal"
Else
	cWhere := "% = '8' %"
	cNomArq:= "SAGE - Geral Federacao"
EndIf

//Renato Ruy - 15/07/2016
//Viabilizar consulta em mais de um periodo.
If Len(AllTrim(MV_PAR01)) == 6
	cPeriodo := "% AND Z6_PERIODO = '"+AllTrim(MV_PAR01)+"' %"
ElseIf Len(AllTrim(MV_PAR01)) < 13
	Alert("O periodo informado est� incorreto")
	Return .F.
Elseif "-" $ AllTrim(MV_PAR01)
	cPeriodo := "% AND Z6_PERIODO Between '"+SubStr(MV_PAR01,1,6)+"' And '" + SubStr(MV_PAR01,8,6) + "' %"
EndIf

//���������������������������������������������������������������������Ŀ
//� BEGINSQL -> Busco dados Agrupados de Remunera��o					�
//�����������������������������������������������������������������������  

If Select("QCRPR220") > 0
	DbSelectArea("QCRPR220")
	QCRPR220->(DbCloseArea())
EndIf

IncProc( "Consultando dados " + SubStr(cNomArq,7,10))
ProcessMessage()

BeginSql Alias "QCRPR220"
	Column Z6_DTPEDI	As Date
	Column Z6_VERIFIC	As Date
	Column Z6_VALIDA	As Date
	Column Z6_DTEMISS	As Date
	Column Z6_DTPGTO	As Date
	Column DT_PEDANT	As Date
	
	%NoParser%
	
	WITH QFED1 AS
	(SELECT Z6_FILIAL FILIAL1, Z6_PEDGAR PEDGAR, SUM(Z6_VALCOM) VALOR FROM %Table:SZ6% Z6 JOIN %Table:SZ3% Z3 ON Z3_FILIAL = ' ' AND
	 Z3_CODENT = Z6.Z6_CODFED AND Z3_RETPOS != 'N' AND Z6.D_E_L_E_T_ = ' 'WHERE Z6_FILIAL = ' ' %Exp:cPeriodo%  AND Z6.D_E_L_E_T_ = ' '
	 AND Z6_TPENTID = '8' AND Z6_PEDGAR > '0'
	 GROUP BY Z6_FILIAL, Z6_PEDGAR),
	 QFED2 AS
	(SELECT Z6_FILIAL FILIAL2, Z6_PEDSITE PEDSITE, Z6_PRODUTO PRODUTO, SUM(Z6_VALCOM) VALOR FROM %Table:SZ6% Z6 JOIN %Table:SZ3% Z3 ON Z3_FILIAL = ' ' AND
	 Z3_CODENT = Z6.Z6_CODFED AND Z3_RETPOS != 'N' AND Z6.D_E_L_E_T_ = ' 'WHERE Z6_FILIAL = ' ' %Exp:cPeriodo%  AND Z6.D_E_L_E_T_ = ' '
	 AND Z6_TPENTID = '8' AND Z6_PEDSITE > '0'
	 GROUP BY Z6_FILIAL, Z6_PEDSITE, Z6_PRODUTO)
	
	SELECT
	Z6_TIPO ,
	SZ3.Z3_CODENT ,
	SZ3.Z3_DESENT,
	SZ3.Z3_TIPENT,
    DECODE(Z6_TIPO,    	'RECANT','RECEBIDO ANTERIORMENTE',
						'REEMBO', 'REEMBOLSO',
						'NAOPAG', 'VOUCHER ORIGEM NAO REMUNERADO',
						'RETIFI', 'RETIFICACAO',
	    				'RENOVA','RENOVACAO',
	    				'ENTHAR', 'HARDWARE AVULSO',
	    				'SERVER', 'PRODUTO SERVIDOR',
	    				'PAGANT', 'PAGO ANTERIORMENTE',
	    				'VERIFI', 'VERIFICACAO') STATPED,
    CASE WHEN  (SUM(Z6_VLRPROD) = 0 AND SUM(Z6_VALCOM) = 0) OR Z6_TIPO IN ('RETIFI','PAGANT','EXTRA') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CER,
    CASE WHEN SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0 WHEN Z6_TIPO = 'REEMBO' THEN -1  ELSE 1 END CONT_CERHW,
    CASE WHEN SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT','ENTHAR') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CERSW,
	SZ3.Z3_CODFED,
	SZ32.Z3_CODAC,
	SZ32.Z3_DESAC,
	SZ3.Z3_CODAR,
	SZ3.Z3_GRUPOIT,
	SZ32.Z3_DESENT Z3_CCRCOM,
	Z6_CODPOS,
	Z6_PRODUTO,
	Z6_DESCRPR,
	Z6_DTPEDI,
	Z6_VERIFIC,
	Z6_VALIDA,
	Z6_DTEMISS,
	Z6_PEDORI,
	Z6_CODCCR,
	Z6_CCRCOM,
	Z6_PEDSITE,
	Z6_PEDGAR,
	ZH_DESCRI,
	Z6_TIPVOU,
	Z6_CODVOU,
	Z6_DESCVOU,
	Z6_DESGRU,
	SUM(DECODE(Z6_CATPROD,'1',Z6_VLRPROD,0)) VALOR_HARDWARE,
	SUM(DECODE(Z6_CATPROD,'1',Z6_BASECOM,0)) BASE_HARDWARE,
	SUM(DECODE(Z6_CATPROD,'1',Z6_VALCOM ,0)) COMHAR,
	SUM(DECODE(Z6_CATPROD,'2',Z6_VLRPROD,0)) VALOR_SOFTWARE,
	SUM(DECODE(Z6_CATPROD,'2',Z6_BASECOM,0)) BASE_SOFTWARE,
	SUM(DECODE(Z6_CATPROD,'2',Z6_VALCOM ,0)) COMSOF,
	SUM(Z6_VLRABT) VLR_ABATIMENTO,
	SUM(Z6_VLRPROD) VALOR_PRODUTO,
	SUM(Z6_BASECOM) BASE_COMISSAO,
	SUM(Z6_VALCOM) VALOR_COMISSAO,
	Z6_NTITULA,
    Z6_NOMEAGE,
    SZ3.Z3_ESTADO,
    SZ3.Z3_QUEBRA,
    SZ32.Z3_CODENT CODENT,
    SZ32.Z3_DESENT DESENT,
    qfed1.VALOR valor1,
    qfed2.VALOR valor2,
    DECODE(SZ3.Z3_ESTADO, 'AC','Norte','RO','Norte','AM','Norte','PA','Norte','TO','Norte','RR','Norte','AP', 'Norte',
                      'MA','Nordeste','PI','Nordeste','CE','Nordeste','RN','Nordeste','PB','Nordeste','PE','Nordeste','AL','Nordeste','SE','Nordeste','BA','Nordeste',
                      'MT','Centro-Oeste','GO','Centro-Oeste','DF','Centro-Oeste','MS','Centro-Oeste',
                      'ES','Sudeste','MG','Sudeste','SP','Sudeste','RJ','Sudeste',
                      'PR','Sul','SC','Sul','RS','Sul',
                      'Nao Informado') REGIAO,
    Z6_DESREDE,
    C5_CTRSAGE
	FROM %Table:SZ6% SZ6
  	JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = %xFilial:SZ3% AND Z6_CODENT = SZ3.Z3_CODENT AND SZ3.D_E_L_E_T_ = ' '
  	LEFT JOIN %Table:SC5% SC5 ON C5_FILIAL = '  ' AND C5_CHVBPAG = Z6_PEDGAR AND SC5.D_E_L_E_T_ = ' ' 
  	LEFT JOIN %Table:SZH% SZH ON ZH_FILIAL = %xFilial:SZH% AND ZH_TIPO = Z6_TIPVOU AND SZH.D_E_L_E_T_ = ' '
	LEFT JOIN %Table:SZ3% SZ32 ON SZ32.Z3_FILIAL = %xFilial:SZ3% AND Z6_CODCCR = SZ32.Z3_CODENT AND SZ32.D_E_L_E_T_ = ' '
	LEFT JOIN QFED1 QFED1 ON QFED1.PEDGAR = Z6_PEDGAR
	LEFT JOIN QFED2 QFED2 ON QFED2.PEDSITE = Z6_PEDSITE AND QFED2.PRODUTO = Z6_PRODUTO
	WHERE
	SZ6.D_E_L_E_T_ = ' ' 
	AND Z6_FILIAL = %xFilial:SZ6%
	%Exp:cPeriodo%                            
	AND SubStr(Z6_CODAC,1,4)   Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
	AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
	AND Z6_CODCCR  Between %Exp:MV_PAR07% And %Exp:MV_PAR08% 
	AND z6_tpentid %Exp:cWhere%
	AND Z6_PRODUTO = 'SRFA1PJEMISSORSAGEHV5'
	GROUP BY
	Z6_TIPO ,
	SZ3.Z3_CODENT ,
	SZ3.Z3_DESENT,
	SZ3.Z3_TIPENT,
	SZ3.Z3_CODFED,
	SZ32.Z3_CODAC,
	SZ32.Z3_DESAC,
	SZ3.Z3_CODAR,
	SZ3.Z3_GRUPOIT,
	SZ32.Z3_DESENT,
	Z6_CODPOS,
	Z6_PRODUTO,
	Z6_DESCRPR,
	Z6_DTPEDI,
	Z6_VERIFIC,
	Z6_VALIDA,
	Z6_DTEMISS,
	Z6_CODVEND,
	Z6_NOMVEND,
	Z6_PEDORI,
	Z6_CODCCR,
	Z6_CCRCOM,
	Z6_PEDSITE,
	Z6_PEDGAR,
	ZH_DESCRI,
	Z6_TIPVOU,
	Z6_CODVOU,
	Z6_DESCVOU, 
	Z6_CODAGE,
	Z6_NOMEAGE,
	Z6_DESGRU,
	Z6_NTITULA,
    Z6_NOMEAGE,
    SZ32.Z3_CODENT,
    SZ32.Z3_DESENT,
    qfed1.VALOR,
    qfed2.VALOR,
    SZ3.Z3_ESTADO,
    SZ3.Z3_QUEBRA,
    Z6_DESREDE,
    C5_CTRSAGE
	ORDER BY SZ6.Z6_CODCCR, SZ3.Z3_QUEBRA, SZ3.Z3_GRUPOIT, SZ3.Z3_CODENT
	
EndSql

aLastQuery := GetLastQuery()
cLastQuery := aLastQuery[2]

QCRPR220->(dbGoTop())

//Tratamento para consulta e gerar barra de processamento no relatorio.
If Select("CCRPR220") > 0
	DbSelectArea("CCRPR220")
	CCRPR220->(DbCloseArea())
EndIf

BeginSql Alias "CCRPR220"
SELECT COUNT(*) CONTAR  FROM (
						SELECT Z6_PEDGAR, Z6_PEDSITE
						FROM %Table:SZ6% SZ6
						WHERE
						SZ6.%Notdel%
						AND Z6_FILIAL = %xFilial:SZ6%
						%Exp:cPeriodo%                            
						AND SubStr(Z6_CODAC,1,4)   Between %Exp:MV_PAR02% AND %Exp:MV_PAR03%
						AND Z6_CODENT  Between %Exp:MV_PAR04% And %Exp:MV_PAR05%
						AND Z6_CODCCR  Between %Exp:MV_PAR07% And %Exp:MV_PAR08% 
						AND z6_tpentid %Exp:cWhere%
						GROUP BY Z6_PEDGAR, Z6_PEDSITE)
EndSql

nContar := CCRPR220->CONTAR

ProcRegua(nContar)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

//Alimento a variavel com o c�digo do pedido para fazer compara��o
If MV_PAR06 == 1
	cCCRAnt := QCRPR220->Z6_CODCCR
	cPosAnt := QCRPR220->Z3_CODENT
	cPosPai := QCRPR220->Z3_GRUPOIT
	cQuebra := QCRPR220->Z3_QUEBRA
Else
	cCCRAnt := QCRPR220->Z3_CODENT
EndIf

If MV_PAR09 == 1 .And. cQuebra != "2"
	cNomArq := AllTrim(Posicione("SZ3",1,xFilial("SZ3")+cCCRAnt,"Z3_DESENT"))+" - "+AllTrim(cCCRAnt)
Elseif MV_PAR09 == 1 .And. cQuebra == "2"
	cNomArq := AllTrim(Posicione("SZ3",1,xFilial("SZ3")+cPosAnt,"Z3_DESENT"))+" - "+AllTrim(cCCRAnt)
EndIf

//Armazena o caminho para grava��o.
cArq    := AllTrim(MV_PAR10) + StrTran(cNomArq,"/", " ") +".csv"
nHdl    := fCreate(cArq)

If valtype(MV_PAR10) == "N"
	Alert("A pasta deve ser informada para grava��o!")
	Return
ElseIf nHdl == -1
	Alert("O Sistema n�o pode gerar o arquivo: "+cArq+", porque o arquivo esta aberto ou a pasta destino sem permiss�o a gravar arquivos!"+cEOL+"O Processo n�o continuar�!")
	Return
Endif

//Adiciono o cabe�alho para o relat�rio.
If nHdl != -1
	cLin := "Cod.Ent.;"
	cLin += "Des. Entidade;"
	cLin += "Desc. Agente Val.;"
	cLin += "Cod. Produto;"
	cLin += "Desc.Produto;"
	cLin += "Pedido;"
	cLin += "Status Pedido;"
	cLin += "Dt.Pedido;"
	cLin += "Dt.Valida��o;"
	cLin += "Dt.Verifica��o;"
	cLin += "Dt.Emiss�o/Renova��o;"
	cLin += "Nome Cliente;"
	//18/12/15 - Retirada valida��o de federa��o.
	//If cWhere <> "8"
		cLin += "Valot Tot. Base;"
		cLin += "Base Software;"
		cLin += "Base Hardware;"
	//Else
	//	cLin += "Valor Faturado;"
	//EndIf 
	cLin += "Tipo Voucher;"
	cLin += "Ped. Anterior;"
	cLin += "Dt.Pedido Anterior;"
	cLin += "Desc. CCR;"
	cLin += "C�d. AC;"
	cLin += "Desc. AC;"
	cLin += "Desc. Grupo;"
	//If cWhere <> "8"
		cLin += "Val. Abatimento;"
		cLin += "Val. Bruto Soft;"
		cLin += "Val. Bruto Hard;"
	//EndIf
	//If cWhere <> "8"
		cLin += "Valor Bruto Total;"
		cLin += "Val. Comiss. Soft;"
		cLin += "Val. Comiss. Hard;"
		cLin += "Valor Tot. Comiss.;"
		cLin += "Val. Comiss�o Fed.;"
		cLin += "Val. Tot. Comiss+Fed.;"
	//Else
	//	cLin += "Val. Tot. Comiss.Fed.;"
	//EndIf
	cLin += "Contagem Geral;"
	//If cWhere <> "8"
		cLin += "Contagem Soft.;"
		cLin += "Contagem Hard.;"
	//EndIf
	//Solicitante: Priscila Kuhn - 12/01/16
	//Biometria IFEN
	If MV_PAR06 == 3
		cLin += "Contagem Biometria;"
	EndIf
	If AllTrim(Str(MV_PAR06)) $ "1/2/3/4" .And. MV_PAR11 == 1
		cLin += "Cod.Posto Val.;"
		cLin += "Desc.Posto Val.;"
		//cLin += "Link Campanha;"
	EndIf
	cLin += "UF;"
	cLin += "REGIAO;"
	cLin += "Contrato SAGE"
	
	cLin := cLin + cEOL
	
	//Efetuo grava��o de dados do relat�rio em arquivo.
	fWrite(nHdl,cLin)
EndIf

While !QCRPR220->(EOF())

	//Incrementa regua
	//SetRegua(QCRPR220->(LastRec()))
	//IncRegua()
	IncProc( "Exportando --> " + Iif(!Empty(QCRPR220->Z6_PEDGAR),"Pedido GAR: " + QCRPR220->Z6_PEDGAR, "Pedido SITE: " + QCRPR220->Z6_PEDSITE ) )
	If nContMsg >= 80
		nContMsg := 0
		ProcessMessage()
	Else
		nContMsg++
	Endif
	
	//Renato Ruy - 06/09/17
	//Novo tratamento para quebra por IT
	If MV_PAR06 == 1
		cQuebra := QCRPR220->Z3_QUEBRA
	Endif 
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If 	(AllTrim(cCCRAnt) <> AllTrim(QCRPR220->Z6_CODCCR) .And. MV_PAR09 == 1 .And. MV_PAR06 == 1) .OR.;
	 	(AllTrim(cCCRAnt) <> AllTrim(QCRPR220->Z3_CODENT) .And. MV_PAR09 == 1 .And. MV_PAR06 != 1) .OR.;
	 	(AllTrim(cPosAnt) <> AllTrim(QCRPR220->Z3_CODENT)  .And. (Empty(cPosPai) .Or. AllTrim(cPosPai) <> AllTrim(QCRPR220->Z3_GRUPOIT));
	 	 .And. MV_PAR09 == 1 .And. MV_PAR06 == 1 .And. QCRPR220->Z3_QUEBRA == "2")  
		
		//Grava Totais
		If nHdl != -1
		
			//Gravo se faltou linhas na memoria
			If nContFw > 0
				fWrite(nHdl,cLinFw)
				cLinFw  := " "
				nContFw := 0
			EndIf
		
			cLin := Iif(MV_PAR06 == 1 .Or. cCCRAnt == "CA0009" .Or. AllTrim(cCCRAnt) == "FEN"," Subtotal ;"," Total Geral ;")
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += TRANSFORM(nBasCom, "@E 999,999,999.99")+";"
			//If cWhere <> "8"
				cLin += TRANSFORM(nBasSof, "@E 999,999,999.99")+";"
				cLin += TRANSFORM(nBasHar, "@E 999,999,999.99")+";"
			//EndIf
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- ;"
			//If cWhere <> "8"
				cLin += TRANSFORM(nAbtVal, "@E 999,999,999.99")+";"
				cLin += TRANSFORM(nValSof, "@E 999,999,999.99")+";"
				cLin += TRANSFORM(nValHar, "@E 999,999,999.99")+";"
				cLin += TRANSFORM(nValPro, "@E 999,999,999.99")+";"
				cLin += TRANSFORM(nComSof, "@E 999,999,999.99")+";"
				cLin += TRANSFORM(nComHar, "@E 999,999,999.99")+";"
			//EndIf
			cLin += TRANSFORM(nComPro, "@E 999,999,999.99")+";"
			//If cWhere <> "8"
				cLin += TRANSFORM(nValFed, "@E 999,999,999.99")+";"
				cLin += TRANSFORM(nComFed, "@E 999,999,999.99")+";"
			//EndIf
			cLin += TRANSFORM(nConCer, "@E 999,999,999.99")+";"
			//If cWhere <> "8"
				cLin += TRANSFORM(nConSof, "@E 999,999,999.99")+";"
				cLin += TRANSFORM(nConHar, "@E 999,999,999.99")+";"				
			//EndIf
			If MV_PAR06 == 3
				cLin += TRANSFORM(nTotBio, "@E 999,999,999.99")+";
			EndIf
			If AllTrim(Str(MV_PAR06)) $ "1/2/3/4" .And. MV_PAR11 == 1
				cLin += "--;"
				cLin += "--;"
				//cLin += "--;"
			EndIf
			cLin += " -- ;"
			cLin += " -- ;"
			cLin += " -- "
			
			cLin := cLin + cEOL
			
			//Efetuo grava��o de dados do relat�rio em arquivo.
			fWrite(nHdl,cLin)  
			
			If MV_PAR06 == 2 .And. AllTrim(cCCRAnt) == "FEN"
				
				If Select("TMPFEN") > 0
					DbSelectArea("TMPFEN")
					TMPFEN->(DbCloseArea())
				EndIf

				BeginSql Alias "TMPFEN"
				
					SELECT COUNT(*) NUMGAR, SUM(VALFAT) VALFAT, SUM(VALIFEN) VALIFEN FROM (
					SELECT Z6_PEDGAR PEDGAR, SUM(Z6_VLRPROD) VALFAT, SUM(Z6_VLRPROD) * 0.02 VALIFEN 
					FROM %Table:SZ6% SZ6 
					WHERE 
					Z6_FILIAL = ' ' 
					%Exp:cPeriodo%
					AND Z6_CODENT = 'CA0009' AND 
					SZ6.%NotDel%
					GROUP BY Z6_PEDGAR)
				
				Endsql
				
				cLin := " FUNDOS DE MARKETING -> ;"
				cLin += " -- ;"
				cLin += " QUANTIDADE PEDIDOS: " + AllTrim(Str(TMPFEN->NUMGAR)) + "  ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += TRANSFORM(TMPFEN->VALFAT, "@E 999,999,999.99") + "  ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += TRANSFORM(TMPFEN->VALIFEN, "@E 999,999,999.99")+";"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- "
				
				//Armazena o valor para ser exibido no totalizador.
				nComPro += TMPFEN->VALIFEN
				
				cLin := cLin + cEOL
				
				//Efetuo grava��o de dados do relat�rio em arquivo.
				fWrite(nHdl,cLin)
				
				cLin := " Total Geral ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += TRANSFORM(nComPro, "@E 999,999,999.99")+";"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- "
				
				cLin := cLin + cEOL
				
				//Efetuo grava��o de dados do relat�rio em arquivo.
				fWrite(nHdl,cLin)
			
			EndIf
			
			nVisita := 0
			
			If MV_PAR06 == 1 .And. MV_PAR09 == 1
			
				cQuery := " SELECT Z6_DESGRU, SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' "+ StrTran(cPeriodo,"%","") +" AND Z6_PRODUTO = 'VISITAEXTERNA' AND Z6_CODENT = '"+cCCRAnt+"' AND z6_tpentid = 'B' GROUP BY Z6_DESGRU"
				
				If Select("TMP") > 0
					DbSelectArea("TMP")
					TMP->(DbCloseArea())
				EndIf
				PLSQuery( cQuery, "TMP" )
				
				While !TMP->(EOF())
					
					nVisita += TMP->Z6_VALCOM
									
					cLin := " Visita Externa - "+ Iif("-"$TMP->Z6_DESGRU,"Sem Projeto", AllTrim(TMP->Z6_DESGRU))+ ";"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += Iif(Select("TMP") > 0, TRANSFORM(TMP->Z6_VALCOM, "@E 999,999,999.99")+";"," --  ;")
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- "
					
					cLin := cLin + cEOL
					
					//Efetuo grava��o de dados do relat�rio em arquivo.
					fWrite(nHdl,cLin)
					TMP->(DbSkip())
				Enddo
				
				nCA0009 := 0
				
				If MV_PAR06 == 3 .And. cCCRAnt == "CA0009"
				
					nCA0009 := nTotBio * 3
					
					cLin := " BIOMETRIA IFEN -> ;"
					cLin += " -- ;"
					cLin += " QUANTIDADE PEDIDOS: " + AllTrim(Str(nTotBio)) + "  ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					//Multiplico o valor por R$ 3,00 - valor do certificado
					cLin += Iif(Select("TMP") > 0 .And. nComFed == 0, TRANSFORM(nCA0009, "@E 999,999,999.99")+";"," --  ;")
					cLin += " -- ;"
					cLin += Iif(Select("TMP") > 0 .And. nComFed > 0, TRANSFORM(nCA0009, "@E 999,999,999.99")+";"," --  ;")
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- "
					
					cLin := cLin + cEOL
					
					//Efetuo grava��o de dados do relat�rio em arquivo.
					fWrite(nHdl,cLin)
						
				EndIf
				
				cLin := " Total Geral ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += Iif(Select("TMP") > 0 .And. nComFed == 0, TRANSFORM(nVisita+nComPro+nCA0009, "@E 999,999,999.99")+";"," --  ;")
				cLin += " -- ;"
				cLin += Iif(Select("TMP") > 0 .And. nComFed > 0, TRANSFORM(nVisita+nComFed+nCA0009, "@E 999,999,999.99")+";"," --  ;")
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- ;"
				cLin += " -- "
				
				cLin := cLin + cEOL
				
				//Efetuo grava��o de dados do relat�rio em arquivo.
				fWrite(nHdl,cLin)
				
			EndIf
			
			
		EndIf
		
		//Fecho o arquivo anterior
		fClose(nHdl)
		
		If MV_PAR06 == 1
			cCCRAnt := QCRPR220->Z6_CODCCR
			cPosAnt := QCRPR220->Z3_CODENT
			cPosPai := QCRPR220->Z3_GRUPOIT
			cQuebra := QCRPR220->Z3_QUEBRA
		Else
			cCCRAnt := QCRPR220->Z3_CODENT
		EndIf
		
		//Armazena o caminho para grava��o.
		If cQuebra == "2"
			cArq    := AllTrim(MV_PAR10) + StrTran(AllTrim(Posicione("SZ3",1,xFilial("SZ3")+cPosAnt,"Z3_DESENT")),"/", " ")+" - "+AllTrim(cPosAnt)+".csv"
		Else
			cArq    := AllTrim(MV_PAR10) + StrTran(AllTrim(Posicione("SZ3",1,xFilial("SZ3")+cCCRAnt,"Z3_DESENT")),"/", " ")+" - "+AllTrim(cCCRAnt)+".csv"
		EndIf
		nHdl    := fCreate(cArq)
		
		If nHdl == -1
			Alert("O Sistema n�o pode gerar o arquivo: "+cArq+", porque o arquivo esta aberto ou a pasta destino sem permiss�o a gravar arquivos!"+cEOL+"O Processo n�o continuar�!")
		Endif
		
		If nHdl != -1
			cLin := "Cod.Ent.;"
			cLin += "Des. Entidade;"
			cLin += "Desc. Agente Val.;"
			cLin += "Cod. Produto;"
			cLin += "Desc.Produto;"
			cLin += "Pedido;"
			cLin += "Status Pedido;"
			cLin += "Dt.Pedido;"
			cLin += "Dt.Valida��o;"
			cLin += "Dt.Verifica��o;"
			cLin += "Dt.Emiss�o/Renova��o;"
			cLin += "Nome Cliente;"
			cLin += "Valot Tot. Base;"
			//If cWhere <> "8"
				cLin += "Base Software;"
				cLin += "Base Hardware;"
			//EndIf 
			cLin += "Tipo Voucher;"
			cLin += "Ped. Anterior;"
			cLin += "Dt.Pedido Anterior;"
			cLin += "Desc. CCR;"
			cLin += "C�d. AC;"
			cLin += "Desc. AC;"
			cLin += "Desc. Grupo;"
			//If cWhere <> "8"
				cLin += "Val. Abatimento;"
				cLin += "Val. Bruto Soft;"
				cLin += "Val. Bruto Hard;"
			//EndIf
			//If cWhere <> "8"
				cLin += "Valor Bruto Total;"
				cLin += "Val. Comiss. Soft;"
				cLin += "Val. Comiss. Hard;"
				cLin += "Valor Tot. Comiss.;"
				cLin += "Val. Comiss�o Fed.;"
				cLin += "Val. Tot. Comiss+Fed	.;"
			//Else
			//	cLin += "Val. Tot. Comiss.Fed.;"
			//EndIf
			cLin += "Contagem Geral;"
			//If cWhere <> "8"
				cLin += "Contagem Soft.;"
				cLin += "Contagem Hard.;"
			//EndIf
			If MV_PAR06 == 3
				cLin += "Contagem Biometria;"
			EndIf
			If  AllTrim(Str(MV_PAR06)) $ "1/2/3/4" .And. MV_PAR11 == 1
				cLin += "Cod.Posto Val.;"
				cLin += "Desc.Posto Val.;"
				//cLin += "Link Campanha;"
			EndIf
			cLin += "UF;"
			cLin += "REGIAO;"
			cLin += "Contrato SAGE"
			
			cLin := cLin + cEOL
			
			//Efetuo grava��o de dados do relat�rio em arquivo.
			fWrite(nHdl,cLin)
		EndIf
		
		
		//Reinicia Totalizador
		nBasCom := 0
		nBasSof := 0
		nBasHar := 0
		nAbtVal := 0
		nValPro := 0
		nValSof := 0
		nValHar := 0
		nComPro := 0
		nComSof := 0
		nComHar := 0
		nValFed := 0
		nComFed := 0
		nConCer := 0
		nConHar := 0
		nConSof := 0
		nContBio:= 0
	EndIf
	
	If MV_PAR06 == 1	
		nFedera := QCRPR220->VALOR1 + QCRPR220->VALOR2
    EndIf
    
    //Fim da altera��o - melhoria na busca de valores federa��o.
	
	//Alimenta totalizadores
	nBasCom += QCRPR220->BASE_COMISSAO
	nBasSof += QCRPR220->BASE_SOFTWARE
	nBasHar += QCRPR220->BASE_HARDWARE
	nAbtVal += QCRPR220->VLR_ABATIMENTO
	nValPro += QCRPR220->VALOR_PRODUTO
	nValSof += QCRPR220->VALOR_SOFTWARE
	nValHar += QCRPR220->VALOR_HARDWARE
	nComPro += QCRPR220->VALOR_COMISSAO
	nComSof += QCRPR220->COMSOF
	nComHar += QCRPR220->COMHAR
	nValFed += Iif(MV_PAR06 == 1 ,nFedera,0)
	nComFed += Iif(MV_PAR06 == 1 ,nFedera+QCRPR220->VALOR_COMISSAO,0)
	
	//Renato Ruy - 16/03/17
	//Valida quando tem reembolso, para verificar se e parcial ou integral. 
	lReemb := .T.
	If "REEMBOLSO" $ QCRPR220->STATPED
		SZ5->(DbSetOrder(1))
		SZ5->(DbSeek(xFilial("SZ5")+QCRPR220->Z6_PEDGAR))
		If (0-(SZ5->Z5_VALORSW+SZ5->Z5_VALORHW)) != QCRPR220->VALOR_SOFTWARE+QCRPR220->VALOR_HARDWARE .And. (0-(SZ5->Z5_VALORSW)) != QCRPR220->VALOR_SOFTWARE .And. QCRPR220->BASE_COMISSAO != 0 
			lReemb := .F.
		Endif
	Endif
	
	//Somente faz a contagem se e reembolso total, pedido de verificacao, renovacao e hw avulso.
	If lReemb
		nConCer += QCRPR220->CONT_CER
		nConHar += QCRPR220->CONT_CERHW
		nConSof += QCRPR220->CONT_CERSW
	EndIf
	
	If MV_PAR06 == 3 .And. cCCRAnt == "CA0009"
		nContBio:= 0
		If QCRPR220->Z6_DTPEDI >= StoD('20151201') .AND.(QCRPR220->BASE_COMISSAO > 0 .OR. AllTrim(QCRPR220->Z6_PRODUTO) == 'IFENSRFA3PFCPC1AHV2') .AND.;
		 !('18' $ QCRPR220->Z6_PRODUTO) .And. !('SIMPLES' $ UPPER(QCRPR220->Z6_DESCRPR))
			nContBio:= 1
			nTotBio += 1
		EndIf
	EndIf 
	
	//Faco tratamento do voucher no programa, na consulta(Query) causou lentidao.
	If !Empty(QCRPR220->Z6_CODVOU)
		
		If AllTrim(QCRPR220->Z6_TIPVOU) $ "A/2/K/L"
			SZF->(DbSetOrder(2))
			If SZF->(DbSeek(xFilial("SZF")+QCRPR220->Z6_CODVOU))
			
				SZ5->(DbSetOrder(1))
				If SZ5->(DbSeek(xFilial("SZ5")+SZF->ZF_PEDIDO))
					
					cPedAnt := SZ5->Z5_PEDGAR
					dDatAnt := Iif(Empty(SZ5->Z5_PEDGANT),SZ5->Z5_DATVER,SZ5->Z5_DATEMIS)
					
				EndIf
			
			EndIf
		
		EndIf
		
	ElseIf !Empty(QCRPR220->Z6_PEDORI)
	
		SZ5->(DbSetOrder(1))
		If SZ5->(DbSeek(xFilial("SZ5")+QCRPR220->Z6_PEDORI))
			
			cPedAnt := SZ5->Z5_PEDGAR
			dDatAnt := SZ5->Z5_DATEMIS
			
		EndIf
	
	EndIf
	
	//Grava linhas atrav�s da divis�o por c�digo de CCR
	cLin := AllTrim(QCRPR220->Z3_CODENT) +";"
	cLin += AllTrim(QCRPR220->Z3_DESENT) +";"
	cLin += AllTrim(QCRPR220->Z6_NOMEAGE)+";"
	cLin += AllTrim(QCRPR220->Z6_PRODUTO)+";"
	cLin += AllTrim(QCRPR220->Z6_DESCRPR)+";"
	cLin += AllTrim(Iif(Empty(QCRPR220->Z6_PEDGAR),QCRPR220->Z6_PEDSITE,QCRPR220->Z6_PEDGAR)) +";"
	cLin += iif(lReemb,AllTrim(QCRPR220->STATPED),"REEMBOLSO PARCIAL")+";"
	cLin += DtoC(QCRPR220->Z6_DTPEDI)	 +";"
	cLin += DtoC(QCRPR220->Z6_VALIDA)	 +";"
	cLin += DtoC(QCRPR220->Z6_VERIFIC)	 +";"
	cLin += DtoC(QCRPR220->Z6_DTEMISS)	 +";"
	cLin += AllTrim(QCRPR220->Z6_NTITULA)+";"
	cLin += AllTrim(TRANSFORM(QCRPR220->BASE_COMISSAO, "@E 999,999,999.99"))+";"
	//If cWhere <> "8"
	cLin += AllTrim(TRANSFORM(QCRPR220->BASE_SOFTWARE, "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(QCRPR220->BASE_HARDWARE, "@E 999,999,999.99"))+";"
	//EndIf
	cLin += AllTrim(QCRPR220->ZH_DESCRI)+";"
	cLin += AllTrim(Iif(Empty(QCRPR220->Z6_PEDORI),cPedAnt,QCRPR220->Z6_PEDORI))   +";"  //BUSCAR NA SZF - QCRPR220->DT_PEDANT - MELHORIA DE PERFORMANCE.
	cLin +=	 DtoC(dDatAnt)								 +";"                         	  //  DtoC("  /  /  ") - BUSCAR NA SZF - QCRPR220->DT_PEDANT - MELHORIA DE PERFORMANCE.
	cLin += AllTrim(Iif(Empty(QCRPR220->Z6_CCRCOM),QCRPR220->Z3_CCRCOM,QCRPR220->Z6_CCRCOM))+";"
	cLin += AllTrim(QCRPR220->Z3_CODAC) +";"
	cLin += AllTrim(QCRPR220->Z3_DESAC) +";"
	cLin += AllTrim(QCRPR220->Z6_DESGRU)+";"
	cLin += AllTrim(TRANSFORM(QCRPR220->VLR_ABATIMENTO, "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(QCRPR220->VALOR_SOFTWARE, "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(QCRPR220->VALOR_HARDWARE, "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(QCRPR220->VALOR_PRODUTO , "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(QCRPR220->COMSOF        , "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(QCRPR220->COMHAR        , "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(QCRPR220->VALOR_COMISSAO, "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(Iif(MV_PAR06 == 1 ,nFedera,0), "@E 999,999,999.99"))+";"
	//cLin += AllTrim(TRANSFORM(Iif(MV_PAR06 == 1 .And. nFedera != 0,nFedera+QCRPR220->VALOR_COMISSAO,0), "@E 999,999,999.99"))+";"
	cLin += AllTrim(TRANSFORM(nFedera+QCRPR220->VALOR_COMISSAO, "@E 999,999,999.99"))+";"

	//Renato Ruy - 16/03/17
	//Valida quando tem reembolso, para verificar se e parcial ou integral.
	If lReemb
		cLin += AllTrim(TRANSFORM(QCRPR220->CONT_CER	  , "@E 999,999,999.99"))+";"	
		cLin += AllTrim(TRANSFORM(QCRPR220->CONT_CERSW	  , "@E 999,999,999.99"))+";"
		cLin += AllTrim(TRANSFORM(QCRPR220->CONT_CERHW	  , "@E 999,999,999.99"))+";"
	Else
		cLin += AllTrim(TRANSFORM(0	, "@E 999,999,999.99"))+";"	
		cLin += AllTrim(TRANSFORM(0	, "@E 999,999,999.99"))+";"
		cLin += AllTrim(TRANSFORM(0	, "@E 999,999,999.99"))+";"
	EndIf

	If MV_PAR06 == 3
		cLin += AllTrim(TRANSFORM(nContBio	  , "@E 999,999,999.99"))+";"
	EndIf
	If AllTrim(Str(MV_PAR06)) $ "2/3/4" .And. MV_PAR11 == 1
		cLin += AllTrim(QCRPR220->CODENT) +";"
		cLin += AllTrim(QCRPR220->DESENT) +";"
		//cLin += AllTrim(QCRPR220->Z6_DESREDE) +";"
	Elseif AllTrim(Str(MV_PAR06)) $ "1" .And. MV_PAR11 == 1 
		If QCRPR220->Z3_TIPENT == "3"
			SZ3->(DbSetOrder(4))
			SZ3->(DbSeek(xFilial("SZ3")+QCRPR220->Z6_CODPOS))
			cLin += AllTrim(SZ3->Z3_CODENT)+";"
			cLin += AllTrim(SZ3->Z3_DESENT) +";"
		Else
			cLin += ";"
			cLin += "MESMA ENTIDADE;"
		Endif
	EndIf
	cLin += AllTrim(QCRPR220->Z3_ESTADO)  +";"
	cLin += AllTrim(QCRPR220->REGIAO)     +";"
	cLin += AllTrim(QCRPR220->C5_CTRSAGE) +";"
	
	cLin := cLin + cEOL
	
	//Efetuo grava��o de dados do relat�rio em arquivo.
	If nHdl != -1
		//Faco tratamento para melhorar performance na gravacao em arquivo.
		If nContFw >= 500
			fWrite(nHdl,cLinFw+cLin)
			cLinFw  := " "
			nContFw := 0
		Else
			cLinFw  += cLin
			nContFw += 1
		EndIf
	EndIf
	
	//Zera informacao do voucher atual.
	cPedAnt := ""
	dDatAnt := CtoD("  /  /  ")
	
	QCRPR220->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

//Grava Totais
If nHdl != -1

	//Gravo se faltou linhas na memoria
	If nContFw > 0
		fWrite(nHdl,cLinFw)
		cLinFw  := " "
		nContFw := 0
	EndIf

	cLin := Iif(MV_PAR06 == 1 .Or. cCCRAnt == "CA0009" .Or. AllTrim(cCCRAnt) == "FEN"," Subtotal ;"," Total Geral ;")
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += TRANSFORM(nBasCom, "@E 999,999,999.99")+";"
	//If cWhere <> "8"
		cLin += TRANSFORM(nBasSof, "@E 999,999,999.99")+";"
		cLin += TRANSFORM(nBasHar, "@E 999,999,999.99")+";"
	//EndIf
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- ;"
	//If cWhere <> "8"
		cLin += TRANSFORM(nAbtVal, "@E 999,999,999.99")+";"
		cLin += TRANSFORM(nValSof, "@E 999,999,999.99")+";"
		cLin += TRANSFORM(nValHar, "@E 999,999,999.99")+";"
		cLin += TRANSFORM(nValPro, "@E 999,999,999.99")+";"
		cLin += TRANSFORM(nComSof, "@E 999,999,999.99")+";"
		cLin += TRANSFORM(nComHar, "@E 999,999,999.99")+";"
	//EndIf
	cLin += TRANSFORM(nComPro, "@E 999,999,999.99")+";"
	//If cWhere <> "8"
		cLin += TRANSFORM(nValFed, "@E 999,999,999.99")+";"
		cLin += TRANSFORM(nComFed, "@E 999,999,999.99")+";"
	//EndIf
	cLin += TRANSFORM(nConCer, "@E 999,999,999.99")+";"
	//If cWhere <> "8"
		cLin += TRANSFORM(nConSof, "@E 999,999,999.99")+";"
		cLin += TRANSFORM(nConHar, "@E 999,999,999.99")+";"
	//EndIf
	If MV_PAR06 == 3
		cLin += TRANSFORM(nTotBio, "@E 999,999,999.99")+";
	EndIf
	If AllTrim(Str(MV_PAR06)) $ "1/2/3/4" .And. MV_PAR11 == 1
		cLin += "--;"
		cLin += "--;"
		//cLin += "--;"
	EndIf
	cLin += " -- ;"
	cLin += " -- ;"
	cLin += " -- "
	
	cLin := cLin + cEOL
	
	//Efetuo grava��o de dados do relat�rio em arquivo.
	fWrite(nHdl,cLin)
	
	If MV_PAR06 == 2 .And. AllTrim(cCCRAnt) == "FEN"
				
		If Select("TMPFEN") > 0
			DbSelectArea("TMPFEN")
			TMPFEN->(DbCloseArea())
		EndIf

		BeginSql Alias "TMPFEN"
		
			SELECT COUNT(*) NUMGAR, SUM(VALFAT) VALFAT, SUM(VALIFEN) VALIFEN FROM (
			SELECT Z6_PEDGAR PEDGAR, SUM(Z6_VLRPROD) VALFAT, SUM(Z6_VLRPROD) * 0.02 VALIFEN 
			FROM %Table:SZ6% SZ6 
			WHERE 
			Z6_FILIAL = ' ' 
			%Exp:cPeriodo%
			AND Z6_CODENT = 'CA0009' AND 
			SZ6.%NotDel%
			GROUP BY Z6_PEDGAR)
			
		Endsql
		
		cLin := " FUNDOS DE MARKETING -> ;"
		cLin += " -- ;"
		cLin += " QUANTIDADE PEDIDOS: " + AllTrim(Str(TMPFEN->NUMGAR)) + "  ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += TRANSFORM(TMPFEN->VALFAT, "@E 999,999,999.99") + "  ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += TRANSFORM(TMPFEN->VALIFEN, "@E 999,999,999.99")+";"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;" 
		cLin += " -- "
		
		//Armazena o valor para ser exibido no totalizador.
		nComPro += TMPFEN->VALIFEN
		
		cLin := cLin + cEOL
		
		//Efetuo grava��o de dados do relat�rio em arquivo.
		fWrite(nHdl,cLin)
		
		cLin := " Total Geral ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += TRANSFORM(nComPro, "@E 999,999,999.99")+";"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- "
		
		cLin := cLin + cEOL
		
		//Efetuo grava��o de dados do relat�rio em arquivo.
		fWrite(nHdl,cLin)
	
	EndIf
	
	nCA0009 := 0
				
	If MV_PAR06 == 3 .And. cCCRAnt == "CA0009"
	
		nCA0009 := nTotBio * 3
		
		cLin := " BIOMETRIA IFEN -> ;"
		cLin += " -- ;"
		cLin += " QUANTIDADE PEDIDOS: " + AllTrim(Str(nTotBio)) + "  ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		//Multiplico o valor por R$ 3,00 - valor do certificado
		cLin += TRANSFORM(nCA0009, "@E 999,999,999.99")+";"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- "
		cLin := cLin + cEOL
		
		//Efetuo grava��o de dados do relat�rio em arquivo.
		fWrite(nHdl,cLin)
		
		cLin := " Total Geral ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += TRANSFORM(nComPro+nCA0009, "@E 999,999,999.99")+";"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- "
		
		cLin := cLin + cEOL
		
		//Efetuo grava��o de dados do relat�rio em arquivo.
		fWrite(nHdl,cLin)
			
	EndIf
	
	nVisita := 0
	If MV_PAR06 == 1 .And. MV_PAR09 == 1
			
		cQuery := " SELECT Z6_DESGRU, SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' "+ StrTran(cPeriodo,"%","") +" AND Z6_PRODUTO = 'VISITAEXTERNA' AND Z6_CODENT = '"+cCCRAnt+"' AND z6_tpentid = 'B' GROUP BY Z6_DESGRU"
				
				If Select("TMP") > 0
					DbSelectArea("TMP")
					TMP->(DbCloseArea())
				EndIf
				PLSQuery( cQuery, "TMP" )
				
				While !TMP->(EOF())
					nVisita += TMP->Z6_VALCOM
					
					cLin := " Visita Externa - "+ Iif("-"$TMP->Z6_DESGRU,"Sem Projeto", AllTrim(TMP->Z6_DESGRU))+ ";"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += Iif(Select("TMP") > 0, TRANSFORM(TMP->Z6_VALCOM, "@E 999,999,999.99")+";"," --  ;")
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- ;"
					cLin += " -- "
					
					cLin := cLin + cEOL
					
					//Efetuo grava��o de dados do relat�rio em arquivo.
					fWrite(nHdl,cLin)
					TMP->(DbSkip())
				Enddo
		
		cLin := " Total Geral ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		//Rafael Beghini 17.03.2016 |Solicita��o de Valquiria|
		//Deve somar o valor de comiss�o + visita externa para mostrar no totalizador
		cLin += Iif(Select("TMP") > 0 , TRANSFORM(nVisita + nComPro, "@E 999,999,999.99")+";"," --  ;")
		cLin += " -- ;"
		cLin += Iif(Select("TMP") > 0 , TRANSFORM(nVisita + nComPro + nvalfed, "@E 999,999,999.99")+";"," --  ;")
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- ;"
		cLin += " -- "
		
		cLin := cLin + cEOL
		
		//Efetuo grava��o de dados do relat�rio em arquivo.
		fWrite(nHdl,cLin)
		
	EndIf  
	
	
EndIf

//Fecho o arquivo anterior
fClose(nHdl)
		
MsgInfo("O arquivo foi gerado com sucesso!")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa ValidPerg �Autor  �Renato Ruy Bernardo    � Data �  04/06/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o Responsavel por criar as perguntas utilizadas no    ���
���          � Relat�rio.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Periodo  ?"	   			,"Periodo  ?"  	  	 		,"Periodo  ?"  		 		,"mv_ch1" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"AC De?"	 		  		,"AC De?"	 		  		,"AC De?"	 		  		,"mv_ch2" 	,"C" 		,04     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"AC Ate?"	 		  		,"AC Ate?"	 		  		,"AC Ate?"	 		  		,"mv_ch3" 	,"C" 		,04     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"Entidade De ?"   	  		,"Entidade De ?"   	  		,"Entidade De ?"   	  		,"mv_ch4" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par04"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"05" 		,"Entidade Ate ?"  	  		,"Entidade Ate ?"  	  		,"Entidade Ate ?"  	  		,"mv_ch5" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par05"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"07" 		,"Cod.CCR De ?"   	  		,"Cod.CCR De ?"   	  		,"Cod.CCR De ?"   	  		,"mv_ch7" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par07"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"08" 		,"Cod.CCR Ate ?"  	  		,"Cod.CCR Ate ?"  	  		,"Cod.CCR Ate ?"  	  		,"mv_ch8" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par08"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"09" 		,"Quebra CCR ?"	  			,"Quebra CCR ?"		  		,"Quebra CCR ?"		  		,"mv_ch9" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par09"	,"Sim"   			,"Sim"   			,"Sim"   			,""   		,"N�o"          ,"N�o"          ,"N�o"          ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"10" 		,"Diretorio ?"	  			,"Diretorio ?"		  		,"Diretorio ?"		  		,"mv_chA" 	,"C" 		,75     		,0      		,0     		,"C"		,"U_CRPR100A",""	    ,""         ,"S"        ,"mv_par10"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"11" 		,"Gera info Posto?"			,"Gera info Posto?"	  		,"Gera info Posto?"	 		,"mv_chB" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par11"	,"Sim"   			,"Sim"   			,"Sim"   			,""   		,"N�o"          ,"N�o"          ,"N�o"          ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return
