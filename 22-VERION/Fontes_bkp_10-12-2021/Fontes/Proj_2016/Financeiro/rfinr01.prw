#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "AvPrint.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RFINR01  � Impressao de Recibo Financeiro                               ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 03.01.07 � Vanderleia                                                   ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 04.01.07 � Top Consulting                                               ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � 99.99.99 � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99/99/99 - Consultor - Descricao da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function RFINR01(cPrefixo,cNumero,cParcela,cTipo,cCliente,cLoja)

Local oFont07		:= TFont():New("Courier New",07,10,,.F.,,,,.T.,.F.)
Local oFont09		:= TFont():New("Courier New",09,09,,.F.,,,,.T.,.F.)
Local oFont10		:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
Local oFont10n		:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
Local oFont12		:= TFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)
Local oFont12n		:= TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)
Local oFont15		:= TFont():New("Courier New",15,15,,.F.,,,,.T.,.F.)
Local oFont15n		:= TFont():New("Courier New",15,15,,.T.,,,,.T.,.F.)
Local oFont21n		:= TFont():New("Courier New",21,21,,.T.,,,,.T.,.F.)
Local aRegs			:= {}
Local aAreaAtu		:= GetArea()
Local aAreaSE1		:= SE1->(GetArea())
Local aCheques		:= {}
Local lProcessa		:= .T.
Local nLin			:= 80
Local nCol			:= 200
Local nDescon		:= 0
Local nJuros		:= 0
Local nMulta		:= 0
Local nValLiq		:= 0
Local nValor  		:= 0
Local nValBas		:= 0
Local nLoop			:= 0
Local cCadastro		:= "Recibo de Pagamento"
Local cStartPath	:= GetSrvProfString("StartPath","")
Local cBmp			:= ""
Local cPerg  		:=	"FINR01    "
Local cTexto		:= ""

Private oPrint

Default cPrefixo	:= ""
Default cNumero		:= ""
Default cParcela	:= ""
Default cTipo		:= ""
Default cCliente	:= ""
Default cLoja		:= ""

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01   Prefixo      				                     �
//� mv_par02   N�mero                		                     �
//� mv_par03   Parcela               		                     �
//� mv_par04   Tipo                  		                     �
//� mv_par05   Cliente                		                     �
//� mv_par06   Loja                 		                     �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Monta array com as perguntas                                 �
//����������������������������������������������������������������
aAdd(aRegs,{	cPerg,;										// Grupo de perguntas
				"01",;										// Sequencia
				"Prefixo",;									// Nome da pergunta
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
aAdd(aRegs,{cPerg,"02","Numero",		"","","mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","",	"","","","","","","","","","","","","","",		"","","","" })
aAdd(aRegs,{cPerg,"03","Parcela",		"","","mv_ch3","C",01,0,0,"G","","MV_PAR03","","","","","","","","","","","",	"","","","","","","","","","","","","","",		"","","","" })
aAdd(aRegs,{cPerg,"04","Tipo",			"","","mv_ch4","C",03,0,0,"G","","MV_PAR04","","","","","","","","","","","",	"","","","","","","","","","","","","","",		"","","","" })
aAdd(aRegs,{cPerg,"05","Cliente",		"","","mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","",	"","","","","","","","","","","","","","SA1",	"","","","" })
aAdd(aRegs,{cPerg,"06","Loja",			"","","mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","","","","","","","","",	"","","","","","","","","","","","","","",		"","","","" })

// U_CriaSX1(aRegs)

//������������������������������������Ŀ
//� Verifica as perguntas selecionadas �
//��������������������������������������
Pergunte( cPerg,.F.)

//����������������������������������������������������������������������������������������������������Ŀ
//� Inicializa as variaveis com o conteudo do parametro, caso o relatorio nao seja solicitado via menu �
//������������������������������������������������������������������������������������������������������
If Empty(cPrefixo+cNumero+cParcela+cTipo+cCliente+cLoja)
	Pergunte( cPerg, .T.)
Else
	Pergunte( cPerg, .F.)
	mv_par01	:= cPrefixo
	mv_par02	:= cNumero
	mv_par03	:= cParcela
	mv_par04	:= cTipo
	mv_par05	:= cCliente
	mv_par06	:= cLoja
EndIf

//����������������������Ŀ
//� Pesquisa se o t�tulo �
//������������������������
dbSelectArea("SE1")
dbSetOrder(2)		// FILIAL+CLIENTE+LOJA+PREFIXO+NUM+PARCELA+TIPO
If !MsSeek(xFilial("SE1")+mv_par05+mv_par06+mv_par01+mv_par02+mv_par03+mv_par04)
	Aviso(	cCadastro,;
			"T�tulo: "+mv_par01+"/"+mv_par02+"/"+mv_par03+"/"+mv_par04+Chr(13)+Chr(10)+;
			"Cliente/Loja: "+mv_par05+"/"+mv_par06+Chr(13)+Chr(10)+;
			"O t�tulo para o cliente informado n�o foi localizado no contas a receber."+Chr(13)+Chr(10)+;
			"N�o � poss�vel efetuar a impress�o, verifique os par�metros.",;
			{"&Continua"},,;
			"T�tulo n�o localizado" )
	lProcessa	:= .F.
EndIf

If lProcessa
	//������������������������������������������Ŀ
	//� Procura por cheques associados ao t�tulo �
	//��������������������������������������������
	Processa( { |lEnd| aCheques := CallChq() }, "Selecionando Registros" )

	//��������������������Ŀ
	//� Ajusta o startpath �
	//����������������������
	cStarPath	:= Alltrim(cStartPath)
	If SubStr(cStartPath,Len(cStartPath),1) != "\"
		cStartPath += "\"
	EndIf

	//�����������������������������Ŀ
	//� Inicializa o objeto grafico �
	//�������������������������������
	oPrint 	:= TMSPrinter():New("Recibo de Pagamento")
	cBmp	:= cStartPath + AllTrim(SuperGetMv("MV_LOGOREC",.F.,"LOGOREC.BMP"))
	oPrint:Setup()
	oPrint:SetPortrait()

	//���������������������Ŀ
	//� Composi��o do Valor �
	//�����������������������
	nDescon	:= SE1->E1_DESCONT
	nJuros	:= SE1->E1_JUROS
	nMulta	:= SE1->E1_MULTA
	//nValLiq	:= SE1->E1_VALLIQ

	nValor  := SE1->E1_VALOR
	nValBas	:= nValor - nDescon + nJuros + nMulta
	nValLiq := nValBas - SE1->E1_SALDO
		                                       
	//���������������������Ŀ
	//� Numero do Recibo	�
	//�����������������������
	If Empty(SE1->E1_XRECIBO)
	   cRecibo := Soma1(GetMV("MV_XRECIBO"))
	   RecLock("SE1",.F.)
	   SE1->E1_XRECIBO	:= cRecibo+"/"+SubStr(DtoS(Date()),3,2)
	   MSUnLock()
	   PutMV("MV_XRECIBO",cRecibo)
	EndIf

	If oPrint:IsPrinterActive()
	
		oPrint:StartPage()
		//����������������������������Ŀ
		//� Definicao do Box principal �
		//������������������������������
		oPrint:Box(nLin,nCol,3100,2350)
		IncLinha(@nLin,20)

		//����������������������Ŀ
		//� Inclusao do logotipo �
		//������������������������
		If File(cBmp)
			oPrint:SayBitmap(nLin,nCol+120,cBmp,250,250)
		EndIf
		
		//����������������������������������Ŀ
		//� Definicao do Quadro de Cabe�alho �
		//������������������������������������
		oPrint:Say(nLin,nCol+0550, SM0->M0_NOMECOM, oFont15n)
		IncLinha(@nLin,60)
		oPrint:Say(nLin,nCol+0550, AllTrim(SM0->M0_ENDENT)+If(!Empty(SM0->M0_COMPENT)," "+AllTrim(SM0->M0_COMPENT),"")+If(!Empty(SM0->M0_BAIRENT)," "+AllTrim(SM0->M0_BAIRENT),""), oFont10n)
		IncLinha(@nLin,40)
		oPrint:Say(nLin,nCol+0550, Transform(SM0->M0_CEPENT, "@R 99999-999")+" - "+AllTrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT, oFont10n)
		IncLinha(@nLin,40)
		oPrint:Say(nLin,nCol+0550, "C.N.P.J.: "+Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")+" - Insc.Estadual: "+SM0->M0_INSC, oFont10n)
		IncLinha(@nLin,40)
		oPrint:Say(nLin,nCol+0550, "Telefone: ++55 "+SM0->M0_TEL+" - Fax: ++55 "+SM0->M0_FAX, oFont10n)
		IncLinha(@nLin,200)

		//�������������������������������Ŀ
		//� Definicao do Numero do Recibo �
		//���������������������������������
		oPrint:Say(nLin,nCol+1000, "RECIBO No.:",			oFont21n)
//		oPrint:Say(nLin,nCol+1600, SE1->E1_NUM,			oFont21n)
		oPrint:Say(nLin,nCol+1600, SE1->E1_XRECIBO,		oFont21n)
		IncLinha(@nLin,70)
		oPrint:Say(nLin,nCol+1000, "Emiss�o: ",				oFont15n)
		oPrint:Say(nLin,nCol+1600, DToC(dDataBase),		oFont15n)
		IncLinha(@nLin,200)
		
		//����������������������������������������Ŀ
		//� Definicao do Quadro de Dados do t�tulo �
		//������������������������������������������
		cTexto	:= "Recebemos de "
		cTexto	+= Alltrim(GetAdvFVal("SA1", "A1_NOME", xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA, 1, ""))
		cTexto	+= " a import�ncia de R$ "
//		cTexto	+= AllTrim(Transform(nValor, "@E 999,999,999.99"))
		cTexto	+= AllTrim(Transform(nValLiq, "@E 999,999,999.99"))
		oPrint:Say(nLin,nCol+0020, cTexto,								oFont10)
		IncLinha(@nLin,40)
//		cTexto	:= "(" + AllTrim(Extenso(nValor))
		cTexto	:= "(" + AllTrim(Extenso(nValLiq))
		cTexto	+= Replic("*", 194 - Len(cTexto) ) + ")"
		oPrint:Say(nLin,nCol+0020, SubStr(cTexto,001,095),				oFont10)
		IncLinha(@nLin,40)
		oPrint:Say(nLin,nCol+0020, SubStr(cTexto,101,095),				oFont10)
		IncLinha(@nLin,40)
		cTexto	:= "Referente a Nota Fiscal n�mero "
		cTexto	+= SE1->E1_NUM + " S�rie " + AllTrim(SE1->E1_PREFIXO)
		cTexto	+= " Emitida em " + DToC(SE1->E1_EMISSAO)
		cTexto	+= " Vencendo em " + DToC(SE1->E1_VENCREA)
		oPrint:Say(nLin,nCol+0020, cTexto,								oFont10)
		IncLinha(@nLin,80)

		//�������������������������������������������Ŀ
		//� Definicao do Quadro de Composi��o Valores �
		//���������������������������������������������
		oPrint:Say(nLin,nCol+1220, "Composi��o dos Valores",						oFont10n)
		IncLinha(@nLin,40)
		oPrint:Say(nLin,nCol+1220, "(+) Valor Base",								oFont10n)
		oPrint:Say(nLin,nCol+1720, Transform(nValor, "@E 999,999,999.99"), 		oFont10)
		IncLinha(@nLin,40)
		If nDescon > 0
			oPrint:Say(nLin,nCol+1220, "(-) Desconto Concedido",					oFont10n)
			oPrint:Say(nLin,nCol+1720, Transform(nDescon, "@E 999,999,999.99"),	oFont10)
			IncLinha(@nLin,40)
		EndIf
		If nMulta > 0
			oPrint:Say(nLin,nCol+1220, "(+) Multa por atraso",						oFont10n)
			oPrint:Say(nLin,nCol+1720, Transform(nMulta, "@E 999,999,999.99"),		oFont10)
			IncLinha(@nLin,40)
		EndIf
		If nJuros > 0
			oPrint:Say(nLin,nCol+1220, "(+) Juros de Mora",							oFont10n)
			oPrint:Say(nLin,nCol+1720, Transform(nJuros, "@E 999,999,999.99"),		oFont10)
			IncLinha(@nLin,40)
		EndIf
		oPrint:Say(nLin,nCol+1220, "(=) Valor Pago",								oFont10n)
//		oPrint:Say(nLin,nCol+1720, Transform(nValor, "@E 999,999,999.99"),		oFont10)
		oPrint:Say(nLin,nCol+1720, Transform(nValLiq, "@E 999,999,999.99"),		oFont10)
		IncLinha(@nLin,80)

		//������������������������������������������Ŀ
		//� Definicao do Quadro de Cheques s/ T�tulo �
		//��������������������������������������������
		If Len(aCheques) > 0
			oPrint:Say(nLin,nCol+0020, "Banco/Agencia/Conta/Cheque                 Valor       Emiss�o    Data Boa    Emitente                    CPF/CNPJ",	oFont10n)
			IncLinha(@nLin,40)
			For nLoop := 1 To Len(aCheques)
				cTexto	:= AllTrim(aCheques[nLoop,01])+"/"+AllTrim(aCheques[nLoop,02])+"/"+AllTrim(aCheques[nLoop,03])+"/"+AllTrim(aCheques[nLoop,04])
				oPrint:Say(nLin,nCol+0020, cTexto,						oFont10)
				cTexto	:= Transform(aCheques[nLoop,11], "@E 999,999,999.99")
//				cTexto	:= Transform(aCheques[nLoop,05], "@E 999,999,999.99")
				oPrint:Say(nLin,nCol+0585, cTexto,						oFont10)
				cTexto	:= DToC(aCheques[nLoop,06])
				oPrint:Say(nLin,nCol+0920, cTexto,						oFont10)
				cTexto	:= DToC(aCheques[nLoop,07])
				oPrint:Say(nLin,nCol+1115, cTexto,						oFont10)
				cTexto	:= aCheques[nLoop,08]
				oPrint:Say(nLin,nCol+1335, cTexto,						oFont10)
				cTexto	:= Transform(aCheques[nLoop,10], If(Len(AllTrim(aCheques[nLoop,10])) > 11, "@R 99.999.999/9999-99", "@R 999.999.999-99") )
				oPrint:Say(nLin,nCol+1760, cTexto,						 oFont10)
				IncLinha(@nLin,40)
			Next nLoop
			IncLinha(@nLin,40)
			oPrint:Say(nLin,nCol+0020, "Aten��o: A quita��o s� ser� v�lida ap�s a compensa��o dos Cheques.",oFont10n)
			IncLinha(@nLin,80)
		EndIf

		//������������������������������������������Ŀ
		//� Verifica se estourou o tamanho da p�gina �
		//��������������������������������������������
		If nLin >= 2740
			nLin := 80
			oPrint:EndPage()
			oPrint:StartPage()
			oPrint:Box(nLin,nCol,3100,2350)
		EndIf

		//������������������������������������Ŀ
		//� Defini��o do Quandro de Aprova��es �
		//��������������������������������������
		nLin	:= 2740
		oPrint:Say(nLin,nCol+0100, "_________________________       _________________________       _________________________",oFont10n)
		nLin+= 40
		oPrint:Say(nLin,nCol+0100, "      Recebido Por                     Revisado Por                   Conferido Por      ",oFont10n)

		//�������������������Ŀ
		//� Finaliza a pagina �
		//���������������������
		oPrint:EndPage()
	EndIf

	//����������������������Ŀ
	//� Finaliza a Impress�o �
	//������������������������
	oPrint:Preview()

EndIf

Return(Nil)


Static Function CallChq()

Local aAreaAtu	:= GetArea()
Local aRet		:= {}
Local nCnt		:= 0
Local cQry		:= ""

cQry	:= " SELECT SEF.EF_BANCO,SEF.EF_AGENCIA,SEF.EF_CONTA,SEF.EF_NUM,SEF.EF_CPFCNPJ,"
cQry	+= " SEF.EF_VALORBX,SEF.EF_DATA,SEF.EF_VENCTO,SEF.EF_EMITENT,SEF.EF_HIST,SEF.EF_VALOR"
cQry	+= " FROM "+RetSqlName("SEF")+" SEF (NOLOCK)"
cQry	+= " WHERE SEF.EF_FILIAL = '"+xFilial("SEF")+"'"
cQry	+= " AND SEF.EF_CART = 'R'"
cQry	+= " AND SEF.EF_PREFIXO = '"+mv_par01+"'"
cQry	+= " AND SEF.EF_TITULO = '"+mv_par02+"'"
cQry	+= " AND SEF.EF_PARCELA = '"+mv_par03+"'"
cQry	+= " AND SEF.EF_TIPO = '"+mv_par04+"'"
cQry	+= " AND SEF.EF_CLIENTE = '"+mv_par05+"'"
cQry	+= " AND SEF.EF_LOJACLI = '"+mv_par06+"'"
cQry	+= " AND SEF.D_E_L_E_T_ <> '*'"

If Select("RFINR01A") > 0
	dbSelectArea("RFINR01A")
	dbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "RFINR01A"

TCSETFIELD("RFINR01A",	"EF_VALORBX",	"N", 16,02)
TCSETFIELD("RFINR01A",	"EF_DATA", 		"D", 08,00)
TCSETFIELD("RFINR01A",	"EF_VENCTO",	"D", 08,00)

dbSelectArea("RFINR01A")
dbGoTop()
RFINR01A->(dbEval( { || nCnt++ },,{ || !Eof() } ) )
dbGoTop()
ProcRegua(nCnt)

While !Eof()
	IncProc( "Selecionando Cheque: "+RFINR01A->EF_BANCO+"/"+RFINR01A->EF_AGENCIA+"/"+RFINR01A->EF_CONTA+"/"+RFINR01A->EF_NUM )
	aAdd( aRet, {	RFINR01A->EF_BANCO,;							// 1-Banco
					RFINR01A->EF_AGENCIA,;							// 2-Agencia
					RFINR01A->EF_CONTA,;							// 3-Conta
					RFINR01A->EF_NUM,;								// 4-N�mero
					RFINR01A->EF_VALORBX,;							// 5-Valor Baixado
					RFINR01A->EF_DATA,;								// 6-Data Emiss�o
					RFINR01A->EF_VENCTO,;							// 7-Data Boa
					Substr(RFINR01A->EF_EMITENT,1,18),; 			// 8-Emitente
					RFINR01A->EF_HIST,;								// 9-Hist�rico
					RFINR01A->EF_CPFCNPJ, ;							//10-CPF/CNPJ
					RFINR01A->EF_VALOR ;							//11-Valor
					})
	dbSkip()
EndDo
dbSelectArea("RFINR01A")
dbCloseArea()



// add para baixa = dinheiro
cQry	:= " SELECT SE5.E5_RECPAG,SE5.E5_BANCO,SE5.E5_AGENCIA,SE5.E5_CONTA,SE5.E5_NUMERO,SE5.E5_PREFIXO,"
cQry	+= " SE5.E5_VALOR,SE5.E5_DATA,SE5.E5_LOJA,SE5.E5_CLIFOR,SE5.E5_HISTOR,SE5.E5_MOTBX"
cQry	+= " FROM "+RetSqlName("SE5")+" SE5 (NOLOCK)"
cQry	+= " WHERE SE5.E5_FILIAL = '"+xFilial("SE5")+"'"
cQry	+= " AND SE5.E5_RECPAG = 'R'"    
cQry	+= " AND SE5.E5_TIPODOC = 'VL'" 
cQry	+= " AND SE5.E5_PREFIXO = '"+mv_par01+"'"
cQry	+= " AND SE5.E5_NUMERO 	= '"+mv_par02+"'"
cQry	+= " AND SE5.E5_PARCELA = '"+mv_par03+"'"
cQry	+= " AND SE5.E5_TIPO 	= '"+mv_par04+"'"
cQry	+= " AND SE5.E5_CLIFOR 	= '"+mv_par05+"'"
cQry	+= " AND SE5.E5_LOJA 	= '"+mv_par06+"'"
cQry	+= " AND SE5.D_E_L_E_T_ <> '*'"          
cQry	+= " AND SE5.E5_MOTBX IN ('DIN','DEP','CCD','CCR','NOR','DEB')"          


If Select("RFINR01B") > 0
	dbSelectArea("RFINR01B")
	dbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "RFINR01B"

TCSETFIELD("RFINR01B",	"E5_VALOR",	"N", 16,02)
TCSETFIELD("RFINR01B",	"E5_DATA", 		"D", 08,00)
//TCSETFIELD("RFINR01B",	"EF_VENCTO",	"D", 08,00)


dbSelectArea("RFINR01B")
dbGoTop()

While !Eof()
	IncProc( "Selecionando Baixas: "+RFINR01B->E5_NUMERO )
	aAdd( aRet, {	RFINR01B->E5_BANCO,;										// 1-Banco
					RFINR01B->E5_AGENCIA,;										// 2-Agencia
					RFINR01B->E5_CONTA,;										// 3-Conta
					iif (RFINR01B->E5_MOTBX = 'DIN'," DINHEIRO",;
					iif (RFINR01B->E5_MOTBX = 'DEP'," DEPOSITO",;
					iif (RFINR01B->E5_MOTBX = 'CCR'," C. CREDITO",;      
					iif (RFINR01B->E5_MOTBX = 'CCD'," C. DEBITO"," DEBITO")))),;	// 4-N�mero
					RFINR01B->E5_VALOR,;										// 5-Valor Baixado
					RFINR01B->E5_DATA,;											// 6-Data Emiss�o
					stod(""),;																					// 7-Data Boa RFINR01B->E5_DATAO
					"      ",; 																					// 8-Emitente  Substr(RFINR01A->EF_EMITENT,1,18)
					RFINR01B->E5_HISTOR,;																		// 9-Hist�rico
					Alltrim(GetAdvFVal("SA1", "A1_CGC", xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA, 1, "")), ;													//10-CPF/CNPJ  RFINR01B->EF_CPFCNPJ
					RFINR01B->E5_VALOR ;																		//11-Valor  RFINR01B->EF_VALOR
					})
	dbSkip()
EndDo

// FIM


dbSelectArea("RFINR01B")
dbCloseArea()

RestArea(aAreaAtu)

Return(aRet)


Static Function IncLinha(nLin,nQdeLin)

If nLin >= 2740
	nLin := 80
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:Box(nLin,nCol,3100,2350)
	nLin += 40
Else
	nLin+= nQdeLin
EndIf

Return(Nil)
