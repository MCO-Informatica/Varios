#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  23/04/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ZFATF01


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := "SC5"
Private oGeraTxt

Private cString := "SC5"

dbSelectArea("SC5")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera��o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira exportar o pedido de vendas "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " SC5                                                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  23/04/13   ���
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
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������

Private cArqTxt := "C:\PEDIDO_001213.TXT"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  23/04/13   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

Local nTamLin, cLin, cCpo


//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� programa.  Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

dbSelectArea("SC5")
dbSetorder(1)
dbSeek(XFILIAL("SC5")+"001213")

IF Found()
	
	ProcRegua(RecCount()) // Numero de registros a processar
	
	
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	
	IncProc()
	
	//�����������������������������������������������������������������ͻ
	//� Lay-Out do arquivo Texto gerado:                                �
	//�����������������������������������������������������������������͹
	//�Campo           � Inicio � Tamanho                               �
	//�����������������������������������������������������������������Ķ
	//� ??_FILIAL     � 01     � 02                                    �
	//�����������������������������������������������������������������ͼ
	
	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
	
	//���������������������������������������������������������������������Ŀ
	//� Substitui nas respectivas posicioes na variavel cLin pelo conteudo  �
	//� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
	//� string dentro de outra string.                                      �
	//�����������������������������������������������������������������������
	
	cLin := SC5->C5_FILIAL			+"#"	//001-004
	cLin += SC5->C5_NUM				+"#"	//006-011
	cLin += SC5->C5_TIPO			+"#"	//013
	cLin += SC5->C5_CLIENTE			+"#"	//015-020
	cLin += SC5->C5_LOJACLI			+"#"	//022-023
	cLin += SC5->C5_X_NOME			+"#"	//025-064
	cLin += SC5->C5_LOJAENT			+"#"	//066-067
	cLin += SC5->C5_CLIENT			+"#"	//069-074
	cLin += SC5->C5_TRANSP			+"#"	//076-081
	cLin += SC5->C5_TIPOCLI			+"#"	//083
	cLin += SC5->C5_CONDPAG			+"#"	//085-087
	cLin += SC5->C5_TABELA			+"#"  	//089-091
	cLin += SC5->C5_VEND1			+"#" 	//093-098
	cLin += dtos(SC5->C5_EMISSAO)	+"#"	//103-107
	cLin += TRANSFORM(SC5->C5_PARC1*100,"@E 99999999999999")	+"#"	//109-122
	cLin += TRANSFORM(SC5->C5_PARC2*100,"@E 99999999999999")	+"#"	//124-137
	cLin += TRANSFORM(SC5->C5_PARC3*100,"@E 99999999999999")	+"#"	//139-152
	cLin += TRANSFORM(SC5->C5_PARC4*100,"@E 99999999999999")	+"#"	//154-167
	cLin += DTOS(SC5->C5_DATA1)		+"#"	//169-176
	cLin += DTOS(SC5->C5_DATA2)		+"#"	//178-185
	cLin += DTOS(SC5->C5_DATA3)		+"#"	//187-194
	cLin += DTOS(SC5->C5_DATA4)		+"#"	//196-203
	cLin += SC5->C5_TPFRETE			+"#"	//205
	cLin += TRANSFORM(SC5->C5_PESOL*100,"@E 99999999999999")	+"#"	//207-220
	cLin += TRANSFORM(SC5->C5_PBRUTO*100,"@E 99999999999999")	+"#"	//222-235
	cLin += TRANSFORM(SC5->C5_VOLUME1,"@E 99999999999999")	+"#"	//237-250
	cLin += SC5->C5_ESPECI1			+"#"	//252-261
	cLin += SC5->C5_X_FPAGT			+"#"	//263
	cLin += TRANSFORM(SC5->C5_X_TOTQT,"@E 99999999999999")	+"#"	//265-278
	cLin += SC5->C5_PDEST1			+"#"	//280-294
	cLin += SC5->C5_PDEST2			+"#"	//296-310
	cLin += SC5->C5_PDEST3			+"#"	//312-326
	cLin += SC5->C5_PDEST4			+"#"	//328-342
	cLin += SC5->C5_PDEST5			+"#" 	//344-358
	
	cLin += cEol 							//Pula linha
	
	dbSelectArea("SC6")
	dbSetorder(1)
	dbSeek(XFILIAL("SC6")+"001213")
	
	IF Found()
		
		While Alltrim(SC6->C6_NUM) == "001213"
			cLin += SC6->C6_FILIAL			+"#" 	//001-004
			cLin += SC6->C6_ITEM			+"#" 	//006-007
			cLin += SC6->C6_PRODUTO			+"#" 	//009-023
			cLin += SC6->C6_UM				+"#" 	//025-026
			cLin += TRANSFORM(SC6->C6_QTDVEN*100,"@E 999999999999999999")	+"#" 	//028-045
			cLin += TRANSFORM(SC6->C6_PRCVEN*100,"@E 999999999999999999")	+"#" 	//047-064
			cLin += TRANSFORM(SC6->C6_VALOR*100 ,"@E 9999999999999999999")	+"#" 	//066-084
			cLin += SC6->C6_TES				+"#" 	//086-088
			cLin += SC6->C6_LOCAL			+"#" 	//090-091
			cLin += SC6->C6_CF				+"#" 	//093-097
			cLin += SC6->C6_CLI				+"#" 	//099-104
			cLin += TRANSFORM(SC6->C6_DESCONT*100,"@E 999999999999999")+"#" 	//106-120
			cLin += TRANSFORM(SC6->C6_VALDESC*100,"@E 999999999999999")+"#" 	//122-136
			cLin += DTOS(SC6->C6_ENTREG)	+"#" 	//138-145
			cLin += SC6->C6_LOJA			+"#" 	//147-148
			cLin += SC6->C6_NUM				+"#" 	//150-155
			cLin += SC6->C6_DESCRI			+"#" 	//157-217
			cLin += TRANSFORM(SC6->C6_PRUNIT*100 ,"@E 99999999999999")	+"#" 	//218-231
			cLin += SC6->C6_CLASFIS 		+"#" 	//233-235
			cLin += SC6->C6_TPOP 			+"#" 	//237
			cLin += DTOS(SC6->C6_SUGENTR)	+"#" 	//239-246
			cLin += SC6->C6_RATEIO    		+"#" 	//248
			
			cLin += cEol 							//Pula linha
			dbSkip()
		Enddo
		
		//���������������������������������������������������������������������Ŀ
		//� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
		//� linha montada.                                                      �
		//�����������������������������������������������������������������������
		
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				//Exit
			Endif
		Endif
		
		//���������������������������������������������������������������������Ŀ
		//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
		//� cao anterior.                                                       �
		//�����������������������������������������������������������������������
		
		fClose(nHdl)
		Close(oGeraTxt)
	Endif
Endif

Return
