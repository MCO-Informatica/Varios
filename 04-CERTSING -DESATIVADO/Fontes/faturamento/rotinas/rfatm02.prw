#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATM02   � Autor �Cristian Gutierrez  � Data �  19/01/07   ���
�������������������������������������������������������������������������͹��
���Descricao �Programa para exportacao de dados referentes a NFe Estado de���
���          �Sao Paulo - geracao de arquivo texto conf.lay-out especifico���
�������������������������������������������������������������������������͹��
���Uso       � Uso exclusivo para o cliente Certisign                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFATM02
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private oGeraTxt
Private cString 	:= "SF2"
Private cPerg		:= "FATM02"
//���������������������������������������������������������������������Ŀ
//� Valida a existencia de perguntas e alimenta em memoria	            �
//�����������������������������������������������������������������������
ValidPerg(cPerg)
Pergunte(cPerg,.F.)
//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera��o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " Export��o das notas fiscais eletronicas                       "

@ 60,078 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 60,108 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,138 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor �Cristian Gutierrez  � Data �  21/01/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OkGeraTxt
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cQuery		:= ""            
Local cSelect		:= ""
Local cQry			:= ""
Local cSeleCount	:= ""
Local nTotRegs		:= 0

//���������������������������������������������������������������������������������Ŀ
//�Monta query para exportacao das notas fiscais de SAIDA conforme parametros		  	�
//�����������������������������������������������������������������������������������
cSelect		:= " SELECT F2_DOC AS NOTA, F2_SERIE AS SERIE, F2_CLIENTE AS CLIENTE, F2_LOJA AS LOJA, F2_TIPO AS TIPO, F2_EMISSAO AS EMISSAO "
cSeleCount	:= " SELECT COUNT(*) AS NTOTREGS "
cQuery 		:= " FROM " + RetSqlName("SF2")
cQuery 		+= " WHERE F2_FILIAL = '"+ xFilial("SF2") +"' 														"
cQuery 		+= "   AND F2_DOC 		BETWEEN '"+ mv_par03 			+"' AND '"+ mv_par04 		+"' 	"
cQuery 		+= "   AND F2_SERIE 		BETWEEN '"+ mv_par01 			+"' AND '"+ mv_par02 		+"' 	"
cQuery 		+= "   AND F2_EMISSAO 	BETWEEN '"+ DtoS(mv_par05)		+"' AND '"+ DtoS(mv_par06)	+"' 	"
cQuery 		+= "   AND D_E_L_E_T_ = ' ' "

//���������������������������������������������������������������������������������Ŀ
//�Executa query para contagem dos registros a serem exportados (NF Saida)   		  	�
//�����������������������������������������������������������������������������������
cQry := cSeleCount + cQuery

If Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()                                                                          	
EndIf

MemoWrite("rfatm02_sf2a.sql",cQuery)
TcQuery cQry New Alias "TMP"

nTotRegs	:= TMP->NTOTREGS
//���������������������������������������������������������������������������������Ŀ
//�Executa query para selecao  dos registros a serem exportados (NF Saida)   		  	�
//�����������������������������������������������������������������������������������
cQry := cSelect + cQuery

If Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()                                                                          	
EndIf

MemoWrite("rfatm02_sf2b.sql",cQuery)
TcQuery cQry New Alias "TMP"

//���������������������������������������������������������������������Ŀ
//� Chamada da funcao de exportacao e regua de processamento            �
//�����������������������������������������������������������������������
Processa({|| ExpNFE(nTotRegs, "S") },"Exportando Documentos de Saida...")

//�������������������������������������������������������������������������������������Ŀ
//�Monta query para exportacao das notas fiscais de ENTRADA conforme parametros  	  	 �
//���������������������������������������������������������������������������������������
cSelect		:= " SELECT F1_DOC AS NOTA, F1_SERIE AS SERIE, F1_FORNECE AS CLIENTE, F1_LOJA AS LOJA, F1_TIPO AS TIPO, F1_EMISSAO AS EMISSAO "
cSeleCount	:= " SELECT COUNT(*) AS NTOTREGS "
cQuery 		:= " FROM " + RetSqlName("SF1")
cQuery 		+= " WHERE F1_FILIAL = '"+ xFilial("SF1") +"' 							 						"
cQuery 		+= "   AND F1_DOC 		BETWEEN '"+ mv_par03 		+"' AND '"+ mv_par04 		+"' 	"
cQuery 		+= "   AND F1_SERIE 		BETWEEN '"+ mv_par01 		+"' AND '"+ mv_par02 		+"' 	"
cQuery 		+= "   AND F1_EMISSAO 	BETWEEN '"+ DtoS(mv_par05)	+"' AND '"+ DtoS(mv_par06)	+"' 	"
cQuery 		+= "   AND F1_FORMUL = 'S' "
cQuery 		+= "   AND D_E_L_E_T_ = ' ' "

//���������������������������������������������������������������������������������Ŀ
//�Executa query para contagem dos registros a serem exportados (NF Saida)   		  	�
//�����������������������������������������������������������������������������������
cQry := cSeleCount + cQuery

If Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()                                                                          	
EndIf

MemoWrite("rfatm02_sf1a.sql",cQuery)
TcQuery cQry New Alias "TMP"

nTotRegs	:= TMP->NTOTREGS
//���������������������������������������������������������������������������������Ŀ
//�Executa query para selecao  dos registros a serem exportados (NF Saida)   		  	�
//�����������������������������������������������������������������������������������
cQry := cSelect + cQuery

If Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()                                                                          	
EndIf

MemoWrite("rfatm02_sf1B.sql",cQuery)
TcQuery cQry New Alias "TMP"

//���������������������������������������������������������������������Ŀ
//� Chamada da funcao de exportacao e regua de processamento            �
//�����������������������������������������������������������������������
Processa({|| ExpNFE(nTotRegs, "E") },"Exportando Documentos de Entrada...")

Close(oGeraTxt)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � EXPNFE   � Autor �Cristian Gutierrez  � Data �  21/01/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ExpNfe( nTotRegs,cTipoNF)
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cEol			:= "" 
Local cArqTxt		:= ""
Local nHdl			:= -1
Local aArea			:= GetArea()
Local aAreaSF2		:= SF2->(GetArea())
Local aAreaSD2		:= SD2->(GetArea())
Local aAreaSC5		:= SC5->(GetArea())
Local aAreaSC6		:= SC6->(GetArea())
Local aAreaSA1		:= SA1->(GetArea())
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaSF1		:= SF1->(GetArea())
Local aAreaSD1		:= SD1->(GetArea())
Local cLin			:= ""
Local cAliasNF		:= ""
Local cAliasItNF	:= ""
Local cAliasCli	:= ""
Local cCampo		:= ""
Local cNotaLoop	:= ""
Local cSerieLoop	:= ""
Local cCliLoop		:= ""
Local cLojaLoop	:= ""
Local cPedido		:= ""
Local cFone			:= ""
Local nX			:= 0
Local cIE			:= ""
//���������������������������������������������������������������������Ŀ
//� Define final de linha                                               �
//�����������������������������������������������������������������������
cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

//���������������������������������������������������������������������Ŀ
//�Posiciona no temporario para geracao dos arquivos de exportacao      �
//�����������������������������������������������������������������������
dbSelectArea("TMP")
dbGoTop()

ProcRegua(nTotRegs) //inicializa regua...

While !(TMP->(EOF()))
    //���������������������������������������������������������������������Ŀ
    //� Incrementa a regua                                                  �
    //�����������������������������������������������������������������������
    IncProc(TMP->SERIE + TMP->NOTA)

	//���������������������������������������������������������������������Ŀ
	//� Cria o arquivo texto                                                �
	//�����������������������������������������������������������������������
	cArqTxt	:= AllTrim(mv_par07)
	cArqTxt	+= TMP->SERIE + TMP->NOTA + ".nfe"
	nHdl    := fCreate(cArqTxt)

	//���������������������������������������������������������������������Ŀ
	//� Verifica se o arquivo foi gerado                                    �
	//�����������������������������������������������������������������������
	If nHdl == -1
	    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")	    
	    Return
	Endif
	//���������������������������������������������������������������������Ŀ
	//�Posiciona nas tabelas do sistema conforme registro (saidas)          �
	//�����������������������������������������������������������������������
	If cTipoNF == "S" //verifica se sao notas de saida
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial("SF2") + TMP->	NOTA + TMP->SERIE + TMP->CLIENTE + TMP->LOJA)
		cAliasNF := "SF2->F2_"
		
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2") + TMP->	NOTA + TMP->SERIE + TMP->CLIENTE + TMP->LOJA)
		cAliasItNf	:= "SD2->D2_"
		cPedido		:= SD2->D2_PEDIDO

		If TMP->TIPO $ "B#D" //caso notas de devolucao ou beneficiamento utiliza cadastro de fornecedores

			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2") + TMP->CLIENTE + TMP->LOJA)
			cAliasCli := "SA2->A2_"

		Else	//demais notas utiliza cadastro de clientes
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1") + TMP->CLIENTE + TMP->LOJA)
			cAliasCli := "SA1->A1_"
		EndIf	
	//���������������������������������������������������������������������Ŀ
	//�Posiciona nas tabelas do sistema conforme registro (entradas)        �
	//�����������������������������������������������������������������������
	Else
		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSeek(xFilial("SF1") + TMP->	NOTA + TMP->SERIE + TMP->CLIENTE + TMP->LOJA)
		cAliasNF := "SF1->F1_"
		
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbSeek(xFilial("SD1") + TMP->	NOTA + TMP->SERIE + TMP->CLIENTE + TMP->LOJA)
		cAliasItNf	:= "SD1->D1_"
		
		If TMP->TIPO $ "B#D" //caso notas de devolucao ou beneficiamento utiliza cadastro de fornecedores

			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1") + TMP->CLIENTE + TMP->LOJA)
			cAliasCli := "SA1->A1_"

		Else	//demais notas utiliza cadastro de clientes
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2") + TMP->CLIENTE + TMP->LOJA)
			cAliasCli := "SA2->A2_"
		EndIf	
	EndIf	
	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 001                              �
	//�����������������������������������������������������������������������
	cLin 		:= "001"
	cCampo 	:= cAliasItNF + "CF" 		//cfop da nf
	cLin 		+= Padr(AllTrim(Tabela("13", &(cCampo))),60) //descricao da natureza de operacao da NF
	cLin		+= "0" 							//condicao de pagamento 0=a vista, 1= a prazo
//	cLin		+= Padr(TMP->SERIE,3)  		//serie do documento
	cLin		+= "000"					//serie quando unica ou branco conforme lay-out IOCERT
	cLin		+= StrZero(Val(TMP->NOTA),9)		//numero da nota
	cCampo	:= TMP->EMISSAO
	cLin		+= Substr(cCampo,1,4)+"-"+Substr(cCampo,5,2)+"-"+Substr(cCampo,7,2)	//data do documento padrao aaaammdd
	cLin		+= Substr(cCampo,1,4)+"-"+Substr(cCampo,5,2)+"-"+Substr(cCampo,7,2)	//data do entrada da mercadoria padrao aaaammdd
	cLin		+= IIF(cTipoNF == "E", "0", "1")	//Tipo da nf, 0 = entrada, 1= saida, 2=avulsa
	cCampo	:= cAliasCli + "CGC"
	cLin		+= StrZero(Val(SM0->M0_CGC),14) // CGC Do emitente 
	cLin		+= Space(11)	//cpf emitente.
	cCampo	:= cAliasCli + "NOME"
	cLin		+= Padr(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_NOMECOM),60) // RAZAO SOCIAL Do emitente 
	cLin		+= Padr(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_NOMECOM),60) // nome fantasia Do emitente 
	cCampo	:= cAliasCli + "END"
	cLin		+= Padr(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_ENDCOB),60) // ENDERECO do emitente
	cLin		+= Space(60) // complemento de endereco
	cLin		+= Padr(IIF(cTipoNF == "E", Space(60), SM0->M0_COMPCOB),60) // COMPLEMENTO DO ENDERECO do emitente
	cCampo	:= cAliasCli + "BAIRRO"
	cLin		+= Padr(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_BAIRCOB),60) // BAIRRO do emitente
	cLin		+= Padr(IIF(cTipoNF == "E", Space(7), "3550308"),7) //CODIGO IBGE FIXO
	cCampo	:= cAliasCli + "MUN"
	cLin		+= Padr(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_CIDCOB),60) // CIDADE do emitente
	cCampo	:= cAliasCli + "EST"                                                                                                                        
	cLin		+= Padr(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_ESTCOB),2) // ESTADO do emitente
	cCampo	:= cAliasCli + "CEP"
	cLin		+= Padr(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_CEPCOB),8) // CEP do emitente
	cLin		+= " 1058" //CODIGO DO PAIS - TABELA DO BACEN - CAMPO FIXO
	cLin		+= Padr("BRASIL",60) // Nome do Pais emitente
	//���������������������������������������������������������������������Ŀ
	//�tratamento para o telefone, exportar apenas numeros                  �
	//�����������������������������������������������������������������������	
	cCampo	:= cAliasCli + "TEL"
	cFone	:= AllTrim(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_TEL)) // fone do emitente
	cCampo:= ""
	For nX := 1 to Len(cFone)                         
		cCampo := ""
		If Substr(cFone,nX,1) $ "0#1#2#3#4#5#6#7#8#9#"
			cCampo += Substr(cFone,nX,1)
		EndIf	
	Next nX
	cLin		+= IIF(EMPTY(cCampo),SPACE(10),Padr(cCampo,10))
	cCampo	:= cAliasCli + "INSCR"
	cLin		+= Padr(AllTrim(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_INSC)),14) // IE do emitente
	cLin		+= Space(14) // ie do substituto tribuitario
	cCampo	:= cAliasCli + "INSCRM"
	cLin		+= Padr(AllTrim(IIF(cTipoNF == "E", Posicione(cAliasCli, 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, &(cCampo)), SM0->M0_INSCM)),15) // IM do emitente
	cLin		+= cEOL
	//���������������������������������������������������������������������Ŀ
	//�Gravacao da linha de registros tipo 001                              �
	//�����������������������������������������������������������������������	
	fWrite(nHdl,cLin,Len(cLin))
	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 002                              �
	//�����������������������������������������������������������������������	
	cLin		:= "002" 
	cCampo	:= cAliasCli + "CGC"
	cCampo	:= AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)) 
	cLin		+= IIF(Len(cCampo) == 14, cCampo, Space(14)) 				// cgc do destinatario
	cLin		+= Padr(IIF(Len(cCampo) < 14, cCampo, Space(11)),11)    // cpf do destinatario
	cCampo	:= cAliasCli + "NOME"
	cLin		+= Padr(AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)),60) // RAZAO SOCIAL DESTINATARIO
	cCampo	:= cAliasCli + "END"
	cLin		+= Padr(AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)),60) // ENDERECO DESTINATARIO
	cLin		+= Space(60) //compl.end.
	cLin		+= Space(60) //compl.end.
	cCampo	:= cAliasCli + "BAIRRO"
	cLin		+= Padr(AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)),60) // bairro DESTINATARIO
	cLin		+= "3550308" //codigo ibge municipio
	cCampo	:= cAliasCli + "MUN"
	cLin		+= Padr(AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)),60) // CIDADE DESTINATARIO
	cCampo	:= cAliasCli + "EST"
	cLin		+= Padr(AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)),2) // ESTADO DESTINATARIO
	cCampo	:= cAliasCli + "CEP"
	cLin		+= Padr(AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)),8) // CEP DESTINATARIO
	cCampo	:= cAliasCli + "PAIS"
	cLin		+= Padr(AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)),5) // COD PAIS DESTINATARIO
//	cCampo	:= cAliasCli + "PAISDES"
//	cLin		+= Padr(AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)),60) // NOME PAIS DESTINATARIO
	cLin		+= Space(60)  ///descricao do pais
	cCampo	:= cAliasCli + "TEL"
	cLin		+= Padr(AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)),10) // TELEFONE DESTINATARIO
	//���������������������������������������������������������������������Ŀ
	//�tratamento para o IE, exportar apenas numeros  		                �
	//�����������������������������������������������������������������������	
	cCampo	:= cAliasCli + "INSCR"
    cIE		:=  AllTrim(Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo)) // INSCR.EST. DESTINATARIO
	For nX := 1 to Len(cIE)                         
		cCampo := ""
		If Substr(cIE,nX,1) $ "0#1#2#3#4#5#6#7#8#9#"
			cCampo += Substr(cIE,nX,1)
		EndIf	
	Next nX
	cLin		+= Padr(cCampo,14)
	cCampo	:= cAliasCli + "SUFRAMA"
	cLin		+= Padr(AllTrim(IIF(Substr(cAliasCli,1,3) == "SA1",Posicione(Substr(cAliasCli,1,3), 1, xFilial(Substr(cAliasCli,1,3)) + TMP->CLIENTE + TMP->LOJA, cCampo),"")),9) // cod.suframa DESTINATARIO
	cLin		+= Space(14) //cgc retirada
	cLin		+= Space(60) //end retirada
	cLin		+= Space(60) //compl.end retirada
	cLin		+= Space(60) //compl.end retirada
	cLin		+= Space(60) //bairro
	cLin		+= Space(07)  //cod.mun retirada
	cLin		+= Space(60) //cidade retirada
	cLin		+= Space(02) //estado retirada
	cLin		+= cEOL
	//���������������������������������������������������������������������Ŀ
	//�Gravacao da linha de registros tipo 002                              �
	//�����������������������������������������������������������������������	
	fWrite(nHdl,cLin,Len(cLin))
	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 003                              �
	//�����������������������������������������������������������������������	
	cLin		:= "003" 
	cLin		+= Space(14) //cgc entrega
	cLin		+= Space(60) //end entrega
	cLin		+= Space(60) //compl.end entrega
	cLin		+= Space(60) //compl.end entrega
	cLin		+= Space(60) //bairro
	cLin		+= Space(07)  //cod.mun entrega
	cLin		+= Space(60) //cidade entrega
	cLin		+= Space(02) //estado entrega
	cLin		+= cEOL	
	//���������������������������������������������������������������������Ŀ
	//�Gravacao da linha de registros tipo 003                              �
	//�����������������������������������������������������������������������	
	fWrite(nHdl,cLin,Len(cLin))
	//���������������������������������������������������������������������Ŀ
	//�Cria variaveis para controle do loop sobre itens de notas            �
	//�����������������������������������������������������������������������	
	cNotaLoop	:= cAliasItNF + "DOC"
	cSerieLoop	:= cAliasItNF + "SERIE"
	cCliLoop		:= If(cTipoNF == "E",cAliasItNF + "FORNECE", cAliasItNF + "CLIENTE")
	cLojaLoop	:= cAliasItNF + "LOJA"	
	//���������������������������������������������������������������������Ŀ
	//�Selecao de area e indice conforme tipo de nota entrada/saida         �
	//�����������������������������������������������������������������������	
	dbSelectArea(Substr(cAliasItNF,1,3))
	//���������������������������������������������������������������������Ŀ
	//�Loop para exportar os itens do documento                             �
	//�����������������������������������������������������������������������	
	While !EOF() .and. TMP->NOTA + TMP->SERIE + TMP->CLIENTE + TMP->LOJA == &(cNotaLoop) + &(cSerieLoop) + &(cCliLoop) + &(cLojaLoop)
		//���������������������������������������������������������������������Ŀ
		//�Posiciona no cadastro do produto utilizado no item da NF             �
		//�����������������������������������������������������������������������	
		cCampo := cAliasItNF + "COD"
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1") + &(cCampo))
		
		//���������������������������������������������������������������������Ŀ
		//�Montagem da linha de registros tipo 004                              �
		//�����������������������������������������������������������������������	
		cLin	:= "004"             				//tipo registro  
		cLin	+= Padr(SB1->B1_COD		,060)		//codigo do produto
		cLin	+= Space(60) //Padr(SB1->B1_CODBAR	,060)  	//codigo de barras
		cLin	+= Padr(SB1->B1_DESC		,120)		// descricao do produto
		cLin	+= Padr(SB1->B1_POSIPI	,008)		//codigo ipi conforme NCM
		cLin	+= Padr(SB1->B1_EX_NCM 	,003)		//codigo tipo EX da TIPI
		cLin	+= Space(2) // genero
		cCampo:= cAliasItNF + "CF"
		cLin	+= Padr(&(cCampo)			,004)		//codigo CFOP
		cCampo:= cAliasItNF + "UM"
		cLin	+= Padr(&(cCampo)			,006)		//unidade tributavel
		cLin	+= Padr(&(cCampo)			,006)		//unidade comercial
		cCampo:= cAliasItNF + "QUANT"
		cLin	+= TRANSFORM(Round(&(cCampo),3),"99999999999.999")	//qtde tributavel
		cCampo:= cAliasItNF + "QUANT"
		cLin	+= TRANSFORM(Round(&(cCampo),3),"99999999999.999")	//qtde comercial
		cCampo:= cAliasItNF + "TOTAL"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//VALOR BRUTO
		cCampo:= cAliasItNF + "VALFRE"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//FRETE
		cCampo:= cAliasItNF + "SEGURO"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//SEGURO
		cCampo:= cAliasItNF + IIF(cTipoNF == "E", "VALDESC","DESCON")
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//DESCONTO
		cLin	+= Space(10) //DI
		cLin	+= Space(10) //data da di
		cLin	+= Space(60) //local desembaraco aduaneiro
		cLin	+= Space(02) //estado
		cLin	+= Space(10) //data
		cLin	+= Space(60) //codigo exportador
		cLin	+= Space(03) //nro adicao
		cLin	+= Space(02) //item adicao 
		cLin	+= Space(60) //codigo do fabricante estrangeiro
		cLin	+= Space(15) //desconto adicao
		cLin	+= SB1->B1_ORIGEM	// ORIGEM DO PRODUTO
		cLin	+= "00"				//TRIbutacao icms - 00= integral
		cLin	+= "3"				//modalidade tributacao, 3= valor da operacao
		cCampo:= cAliasItNF + "BASEICM"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")		//BASE DO ICMS
		cCampo:= cAliasItNF + "PICM"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"99.99")		//PERCENTUAL ICMS
		cCampo:= cAliasItNF + "VALICM"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//VALOR ICMS
		cLin	+= Space(01) // ORIGEM DO PRODUTO		
		cLin	+= Space(02) //TRIBUTACAO Pelo icms 10
		cLin	+= Space(01) //tipo tributacao
		cLin	+= Space(15) //valor base     
		cLin	+= Space(05) //aliquota
		cLin	+= Space(15) //valor icms
		cLin	+= Space(01) //modalidade calculo icms
		cLin	+= Space(05) //percentual margem
		cLin	+= Space(05) //reducao percentual de base
		cLin	+= Space(15) //base substituicao trib.
		cLin	+= Space(05) //aliq.substituicao trib
		cLin	+= Space(15) //VALOR icms substituicao trib
		cLin	+= Space(01) // ORIGEM DO PRODUTO		
		cLin	+= Space(02) //TRIBUTACAO Pelo icms 20
		cLin	+= Space(01) //tipo tributacao       
		cLin	+= Space(05) //reducao percentual de base
		cLin	+= Space(15) //valor base     
		cLin	+= Space(05) //aliquota
		cLin	+= Space(15) //valor icms
		cLin	+= Space(01) // ORIGEM DO PRODUTO		
		cLin	+= Space(02) //TRIBUTACAO Pelo icms 30	
		cLin	+= Space(01) //tipo tributacao        
		cLin	+= Space(05) //percentual margem
		cLin	+= Space(05) //reducao percentual de base
		cLin	+= Space(15) //valor base     
		cLin	+= Space(05) //aliquota
		cLin	+= Space(15) //valor icms
		cLin	+= Space(01) // ORIGEM DO PRODUTO		
		cLin	+= Space(02) //coluna 813 do lay-out
		cLin	+= Space(01) // ORIGEM DO PRODUTO		
		cLin	+= Space(02) //TRIBUTACAO Pelo icms 70
		cLin	+= Space(01) //tipo tributacao        
		cLin	+= Space(05) //reducao percentual de base
		cLin	+= Space(15) //valor base     
		cLin	+= Space(05) //aliquota
		cLin	+= Space(15) //valor icms
		cLin	+= Space(01) //tipo tributacao COLUNA 859 LAY OUT
		cLin	+= Space(05) //percentual margem
		cLin	+= Space(05) //reducao percentual de base
		cLin	+= Space(15) //valor base     
		cLin	+= Space(05) //aliquota
		cLin	+= Space(15) //valor icms
		cLin	+= Space(01) // ORIGEM DO PRODUTO		
		cLin	+= Space(02) //TRIBUTACAO Pelo icms 90
		cLin	+= Space(01) //tipo tributacao       
		cLin	+= Space(05) //reducao percentual de base
		cLin	+= Space(15) //valor base     
		cLin	+= Space(05) //aliquota
		cLin	+= Space(15) //valor icms
		cLin	+= Space(01) //tipo tributacao COLUNA 949
		cLin	+= Space(05) //percentual margem
		cLin	+= Space(05) //reducao percentual de base
		cLin	+= Space(15) //valor base     
		cLin	+= Space(05) //aliquota
		cLin	+= Space(15) //valor icms
		cLin	+= Space(05) //CLASSE IPI
		cLin	+= Space(14) //CNPJ PRODUTOR
		cLin	+= Space(60) //SELO IPI
		cLin	+= Space(12) //QTDE DE SELOS
		cLin	+= Space(03) //COD.IPI PELA RFB
		cLin	+= "99" 			//codigo IPI
		cCampo:= cAliasItNF + "IPI"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"99.99")	//PERCENTUAL IPI
		cCampo:= cAliasItNF + "BASEIPI"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//VALOR BASE IPI
		If	Round(&(cCampo),2) > 0 //QUANTIDADE SOMENTE SE HOUVER BASE DE CALCULO
			cCampo:= cAliasItNF + "QUANT"
			cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//QTDE TRIBUTAVEL
		Else
			cLin	+= Space(15)
		EndIf
		cLin += Space(15) //ipi de pauta	
		cCampo:= cAliasItNF + "VALIPI"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//VALOR IPI
		cLin	+= Space(02) 	//COD.SIT.TRIB. IPI
		cLin	+= Space(15) 	//BASE IMPORTACAO
		cLin	+= Space(15) 	//DESPESAS ADUANEIRAS
		cLin	+= Space(15) 	//IMPOSTO IMPORT.
		cLin	+= Space(15) 	//IOF		
		cLin	+= "01"			//SIT.TRIB. PIS - 01 = OPERACAO TRIBUTADA
		cCampo:= cAliasItNF + "BASIMP6"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")		//BASE DO pis
		cCampo:= cAliasItNF + "ALQIMP6"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"99.99")		//PERCENTUAL PIS
		cCampo:= cAliasItNF + "VALIMP6"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")		//VALOR PIS
		cLin	+= Space(02) 	//"C�digo da situa��o tribut�ria do PIS 03-Opera��o tribut�vel - Base de c�lculo=quantidadevendida x Al�quota por unidade de produto"
		cLin	+= Space(15) 	//Quantidade vendida
		cLin	+= Space(15) 	//Al�quota do PIS (em reais)
		cLin	+= Space(15) 	//Valor do PIS
		cLin	+= Space(02) 	//"C�digo da situa��o tibut�ria do PIS 
		cLin	+= Space(02) 	//C�digo da situa��o tribut�ria do PIS '99'
		cLin	+= Space(15) 	//Valor da base de c�lculo do PIS
		cLin	+= Space(05) 	//Al�quota do PIS (%)
		cLin	+= Space(15) 	//Quantidade vendida
		cLin	+= Space(15) 	//Al�quota do PIS (em reais)
		cLin	+= Space(15) 	//Valor do PIS
		cLin	+= Space(15) 	//Valor da base de c�lculo do PIS
		cLin	+= Space(05) 	//Al�quota do PIS (%)
		cLin	+= Space(15) 	//Quantidade vendida
		cLin	+= Space(15) 	//Al�quota do PIS (em reais)
		cLin	+= Space(15) 	//Valor do PIS
		cLin 	+= "01"			//"C�digo da situa��o tribut�ria da COFINS
		cCampo:= cAliasItNF + "BASIMP5"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")		//BASE DO COFINS
		cCampo:= cAliasItNF + "ALQIMP5"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"99.99")		//PERCENTUAL COFINS
		cCampo:= cAliasItNF + "VALIMP5"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//VALOR COFINS
		cLin	+= Space(02) 	//"C�digo da situa��o tribut�ria da COFINS
		cLin	+= Space(15) 	//Quantidade vendida
		cLin	+= Space(15) 	//Al�quota da COFINS (em reais)
		cLin	+= Space(15) 	//Valor da COFINS
		cLin	+= Space(02) 	//"C�digo da situa��o tibut�ria da COFINS
		cLin	+= Space(02) 	//"C�digo da situa��o tribut�rias da COFINS
		cLin	+= Space(15) 	//Valor da base de c�lculo da COFINS
		cLin	+= Space(05) 	//Al�quota da COFINS (%)
		cLin	+= Space(15) 	//Quantidade vendida
		cLin	+= Space(15) 	//Al�quota da COFINS (em reais)
		cLin	+= Space(15) 	//Valor da COFINS
		cLin	+= Space(15) 	//Valor da base de c�lculo da COFINS
		cLin	+= Space(05) 	//Al�quota da COFINS (%)
		cLin	+= Space(15) 	//Quantidade vendida
		cLin	+= Space(15) 	//Al�quota da COFINS (em reais)
		cLin	+= Space(15) 	//Valor da COFINS
		cLin	+= Space(15) 	//Valor da base de c�lculo do ISSQN
		cLin	+= Space(05) 	//Al�quota do ISSQN
		cLin	+= Space(15) 	//Valor do ISSQN
		cLin	+= Space(07) 	//Munic�pio de ocorr�ncia do fato gerador do ISSQN - Tabela IBGE
		cLin	+= Space(500) //Informa��es adicionais do produt (norma referenciada, inf. complementares, etc)
		cLin	+= Space(01) 	//"Origem da mercadoria:1-Estrangeira (Importa��o direta);2-Estrangeira (Adquirida no mercado interno)"
		cLin	+= Space(15) 	//Valor da BC do ICMS ST retido anteriormente
		cLin	+= Space(15) 	//Valor do ICMS ST retido anteriormente
		cCampo:= cAliasItNF + IIF(cTipoNF == "E","VUNIT","PRCVEN")
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")//Valor unit�rio do produto - n�o vai no xml, somnete para imprimir no DANFE
		cLin	+= cEOL
		//���������������������������������������������������������������������Ŀ
		//�Gravacao da linha de registros tipo 004                              �
		//�����������������������������������������������������������������������	
		fWrite(nHdl,cLin,Len(cLin))
		//���������������������������������������������������������������������Ŀ
		//�Salta registro no item da nf para exportar "n" itens tipo 004        �
		//�����������������������������������������������������������������������	
		cCampo := Substr(cAliasItNF,1,5) + "(dbSkip())"

		&(cCampo)
	EndDo
	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 005                              �
	//�����������������������������������������������������������������������	
	cLin		:= "005" 
	cCampo:= cAliasNF + "BASEICM"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")		//Base de c�lculo do ICMS
	cCampo:= cAliasNF + "VALICM"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//Valor total do ICMS
	cLin	+= Space(15) 	//Base de c�lculo do ICMS Substitui��o Tribut�ria
	cLin	+= Space(15) 	//Valor total do ICMS Substitui��o Tribut�ria
	cCampo:= cAliasNF + "VALMERC"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//Valor total dos produtos e servi�os
	cCampo:= cAliasNF + "FRETE"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//Valor total do frete
	cCampo:= cAliasNF + "SEGURO"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//Valor total do seguro
	cCampo:= cAliasNF + "DESCONT"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//Valor total do desconto
	cLin	+= Space(15) 	//Valor total do imposto de importa��o
	cCampo:= cAliasNF + "VALIPI"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")		//Valor total do IPI
	cCampo:= cAliasNF + "VALIMP6"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")		//Valor total do PIS
	cCampo:= cAliasNF + "VALIMP5"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")		//Valor da COFINS
	cLin	+= Space(15) 	//Outras despesas acess�rias
	cCampo:= cAliasNF + "VALBRUT"
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")		//Valor total da NFe
	cLin	+= Space(15) 	//Valor total dos servi�os sob n�o incid�ncia ou n�o tributados pelo ICMS
	If	cTipoNF == "S" //SOMENTE NF SAIDA
		cCampo:= cAliasItNF + "BASEISS"
		cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//Base de c�lculo do ISS
	Else
		cLin	+= Space(15)
	EndIf
	cCampo:= cAliasNF + IIF(cTipoNF == "S","VALISS","ISS") 
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	////Valor total do ISS
	cLin	+= Space(15) 	//Valor do PIS sobre servi�os
	cLin	+= Space(15) 	//Valor da COFINS sobre servi�os
	cLin	+= Space(15) 	//Valor retido de PIS
	cLin	+= Space(15) 	//Valor retido de COFINS
	cLin	+= Space(15) 	//Valor retido de CSLL
	cLin	+= Space(15) 	//Base de C�lculo do IRRF
	cCampo:= cAliasNF + IIF(cTipoNF == "S","VALIRRF","IRRF") 
	cLin	+= TRANSFORM(Round(&(cCampo),2),"999999999999.99")	//Valor retido de IRRF
	cLin	+= Space(15) 	//Base de C�lculo da Reten��o da Previd�ncia Social
	cLin	+= Space(15) 	//Valor da Reten��o da Previd�ncia Social
	If cTipoNF == "E" //verifica tipo do frete envolvido na operacao
		cCampo	:= "0" //nf entrada
	Else
		cCampo	:= Posicione("SC5",1, xFilial("SC5") + cPedido, "C5_TPFRETE")		//nf saida
	EndIf
	cLin	+= cCampo  	//Modalidade do frete. 0-por conta do emitente; 1-por conta do destinat�rio
	If	cTipoNF == "S" //SOMENTE NF SAIDA
		dbSelectArea("SA4")
		dbSetOrder(1)
		dbSeek(xFilial("SA4") + SF2->F2_TRANSP)

		cLin	+= Padr(AllTrim(SA4->A4_CGC		),014)	//CNPJ do transportador
		cLin	+= Space(11)	//CPF do transportador
		cLin	+= Padr(AllTrim(SA4->A4_NOME		),060)	//Raz�o social ou nome do transportador
		cLin	+= Padr(AllTrim(SA4->A4_INSEST	),014)	//Inscri��o estadual do transportador
		cLin	+= Padr(AllTrim(SA4->A4_END 		),060)	//Endere�o completo do transportador
		cLin	+= Padr(AllTrim(SA4->A4_MUN		),060)	//Nome do munic�pio do transportador
		cLin	+= Padr(AllTrim(SA4->A4_EST		),002)	//Sigla da UF do transportadoR
	Else
		cLin	+= Space(14)	//CNPJ do transportador
		cLin	+= Space(11)	//CPF do transportador
		cLin	+= Space(60)	//Raz�o social ou nome do transportador
		cLin	+= Space(14)	//Inscri��o estadual do transportador
		cLin	+= Space(60)	//Endere�o completo do transportador
		cLin	+= Space(60)	//Nome do munic�pio do transportador
		cLin	+= Space(02)	//Sigla da UF do transportador	EndIf
	EndIf
	cLin	+= Space(15) 	//Valor do servi�o
	cLin	+= Space(15) 	//Base de C�lculo da reten��o do ICMS
	cLin	+= Space(05) 	//Al�quota da reten��o
	cLin	+= Space(15) 	//Valor do ICMS retido
	cLin	+= Space(04) 	//C�digo fiscal de opera��es e presta��es
	cLin	+= Space(07) 	//C�digo do munic�pio de ocorr�ncia do fato gerador - Tabela IBGE
	cLin	+= Space(08) 	//Placa do ve�culo
	cLin	+= Space(02) 	//Sigla da UF da placa
	cLin	+= Space(20) 	//Registro Nacional do Transportador de Carga (ANTT)
	cLin	+= cEOL
	//���������������������������������������������������������������������Ŀ
	//�Gravacao da linha de registros tipo 005                              �
	//�����������������������������������������������������������������������	
	fWrite(nHdl,cLin,Len(cLin))
	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 006                              �
	//�����������������������������������������������������������������������	
	cLin		:= "006" 				
	cLin	+= Space(08) 	//Placa do reboque
	cLin	+= Space(02) 	//Sigla da UF da placa
	cLin	+= Space(20) 	//Registro Nacional do Transportador de Carga (ANTT)
	cLin	+= cEOL	
	//���������������������������������������������������������������������Ŀ
	//�Gravacao da linha de registros tipo 006                              �
	//�����������������������������������������������������������������������	
	fWrite(nHdl,cLin,Len(cLin))
	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 007                              �
	//�����������������������������������������������������������������������	
	cLin		:= "007" 				
	If	cTipoNF == "S" //SOMENTE NF SAIDA
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("C5") + cPedido)
      
		cCampo	:= SC5->(C5_VOLUME1+ C5_VOLUME2+ C5_VOLUME3+ C5_VOLUME4)
		cLin		+= TRANSFORM(Round(cCampo,0),"999999999999999")		//Quantidade de volumes transportados
		cCampo 	:= SC5->(C5_ESPECI1+ C5_ESPECI2+ C5_ESPECI3+ C5_ESPECI4)
		cLin		+= Padr(AllTrim(cCampo),060)										//Esp�cie dos volumes transportados
		cLin		+= Space(60)															//Marca dos volumes transportados
		cLin		+= Space(60)															//Numera��o dos volumes transportados			
		cLin		+= TRANSFORM(Round(SC5->C5_PESOL,3 ),"99999999999.999")		//Peso l�quido (Kg)
		cLin		+= TRANSFORM(Round(SC5->C5_PBRUTO,3),"99999999999.999")	//Peso bruto (Kg)
		cLin		+= Space(01) 															//N�mero do lacre, m�ltiplas, separar cada um com espa�o a partir da coluna 229
  		cLin		+= cEOL
	Else
		cLin		+= Space(15)	//Quantidade de volumes transportados
		cLin		+= Space(60)	//Esp�cie dos volumes transportados
		cLin		+= Space(60)	//Marca dos volumes transportados
		cLin		+= Space(60)	//Numera��o dos volumes transportados	
		cLin		+= Space(15)	//Peso l�quido (Kg)
		cLin		+= Space(15)	//Peso bruto (Kg)
		cLin		+= Space(01)	//N�mero do lacre, m�ltiplas, separar cada um com espa�o a partir da coluna 229
  		cLin		+= cEOL
	EndIf
	//���������������������������������������������������������������������Ŀ
	//�Gravacao da linha de registros tipo 007                              �
	//�����������������������������������������������������������������������	
	fWrite(nHdl,cLin,Len(cLin))
	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 008                              �
	//�����������������������������������������������������������������������	
	cLin		:= "008" 				
	If	cTipoNF == "S" //SOMENTE NF SAIDA
		cLin	+= Padr(SF2->F2_DOC,60)															//N�mero da fatura
		cLin	+= TRANSFORM(Round(SF2->F2_VALBRUT,2),"999999999999.99")			//Valor original da fatura
		cLin	+= TRANSFORM(Round(SF2->F2_DESCONT,2),"999999999999.99")			//Valor do desconto
		cLin	+= TRANSFORM(Round(SF2->(F2_VALBRUT-F2_DESCONT),2),"999999999999.99")	//Valor l�quido da fatura
  		cLin	+= cEOL		
	Else
		cLin	+= Space(60)	//N�mero da fatura
		cLin	+= Space(15)	//Valor original da fatura
		cLin	+= Space(15)	//Valor do desconto
		cLin	+= Space(15)	//Valor l�quido da fatura
  		cLin	+= cEOL		
	EndIf
	//���������������������������������������������������������������������Ŀ
	//�Gravacao da linha de registros tipo 008                              �
	//�����������������������������������������������������������������������	
	fWrite(nHdl,cLin,Len(cLin))
	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 009                              �
	//�����������������������������������������������������������������������	
	If	cTipoNF == "S" //SOMENTE NF SAIDA
		dbSelectArea("SE1")
		dbSetOrder(2)
		If dbSeek(xFilial("SE1") + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_PREFIXO + SF2->F2_DUPL,.T.)
			While !(SE1->(EOF())) .and. SF2->(F2_CLIENTE + F2_LOJA + F2_PREFIXO + F2_DUPL) == SE1->(E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM)
				cLin	:= "009" 				
				cLin	+= Padr(SE1->(E1_PREFIXO + E1_NUM + E1_PARCELA),60)							//Numero da duplicata
				cCampo:= DtoS(SE1->E1_VENCREA)
				cLin	+= Substr(cCampo,1,4)+"-"+Substr(cCampo,5,2)+"-"+Substr(cCampo,7,2)	//	Data de vencimento (AAAA-MM-DD)
				cLin	+= TRANSFORM(Round(SE1->E1_VALOR,2),"999999999999.99")					//	Valor da duplicata
		  		cLin	+= cEOL		                                                                                          
				//���������������������������������������������������������������������Ŀ
				//�Gravacao da linha de registros tipo 009                              �
				//�����������������������������������������������������������������������	
				fWrite(nHdl,cLin,Len(cLin))
			
				SE1->(dbSkip())
			EndDo
		Else //nota de saida sem duplicata
			cLin	:= "009" 				
			cLin	+= Space(60)	//N�mero da duplicata
			cLin	+= Space(10)	//	Data de vencimento (AAAA-MM-DD)
			cLin	+= Space(15)	//	Valor da duplicata
  			cLin	+= cEOL		
			//���������������������������������������������������������������������Ŀ
			//�Gravacao da linha de registros tipo 009                              �
			//�����������������������������������������������������������������������	
			fWrite(nHdl,cLin,Len(cLin))
		EndIf
	Else //nota de entrada
		cLin	:= "009" 				
		cLin	+= Space(60)	//N�mero da duplicata
		cLin	+= Space(10)	//	Data de vencimento (AAAA-MM-DD)
		cLin	+= Space(15)	//	Valor da duplicata
		cLin	+= cEOL		
		//���������������������������������������������������������������������Ŀ
		//�Gravacao da linha de registros tipo 009                              �
		//�����������������������������������������������������������������������	
		fWrite(nHdl,cLin,Len(cLin))
	EndIf			

	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 010                              �
	//�����������������������������������������������������������������������	
	cLin	:= "010" 				
	cLin	+= Space(0256)	//Informa��es adicionais de interesse do fisco
	cLin	+= Space(5000)	//Informa��es complementares de interesse do Contribuinte
	cLin	+= cEOL		
	//���������������������������������������������������������������������Ŀ
	//�Gravacao da linha de registros tipo 010                              �
	//�����������������������������������������������������������������������	
	fWrite(nHdl,cLin,Len(cLin))
	//���������������������������������������������������������������������Ŀ
	//�Montagem da linha de registros tipo 011                              �
	//�����������������������������������������������������������������������	
	cLin	:= "011" 				
	cLin	+= Space(02)//Sigla da UF onde ocorrer� o embarque dos produtos
	cLin	+= Space(60)//Local onde ocorrer� o embarque dos produtos
	cLin	+= cEOL		
	//���������������������������������������������������������������������Ŀ
	//�Gravacao da linha de registros tipo 011                              �
	//�����������������������������������������������������������������������	
	fWrite(nHdl,cLin,Len(cLin))
	//���������������������������������������������������������������������Ŀ
	//�Fecha arquivo gerado                                                 �
	//�����������������������������������������������������������������������	
	fClose(nHdl)
	TMP->(dbSkip())
EndDo

RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aAreaSF1)
RestArea(aAreaSD1)
RestArea(aArea)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � Cristian Gutierrez � Data �  26/06/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg(cPerg)
//�������������������������Ŀ
//� Definicoes de variaveis �
//���������������������������
Local aArea   := GetArea()
Local aRegs   := {}
//���������������������������������Ŀ
//�Array contendo as perguntas 		|
//�����������������������������������
aAdd(aRegs,{cPerg,"01","Serie de           ?","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Serie at�          ?","","","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Documento de       ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Documento at�      ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Data de            ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Data at�           ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Diret�rio arquivo  ?","","","mv_ch7","C",50,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
//��������������������������������������������Ŀ
//�Atualizacao do SX1 com os parametros criados�
//����������������������������������������������
DbSelectArea("SX1")
DbSetorder(1)

For nX:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[nX,2])
		RecLock("SX1",.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				FieldPut(nY,aRegs[nX,nY])
			EndIf
		Next
		SX1->(MsUnlock())
	EndIf
Next
//�������������������������Ŀ
//�Retorna ambiente original�
//���������������������������
RestArea(aArea)
Return(Nil)