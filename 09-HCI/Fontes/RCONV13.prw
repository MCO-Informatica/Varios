#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCONV13   � Autor � OSMIL SQUARCINE    � Data �  16/02/07   ���
�������������������������������������������������������������������������͹��
���Descricao � PROGRAMA PARA CONVERTER O ARQUIVO AK5                      ���
���          � (CADASTRO DE CONTAS ORCAMENTARIAS                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP8 - Uso Especifico do Dersa                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RCONV13()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oLeTxt

Private cString := "AK5"
Private cPerg	:= "RCNV13"
Private aRegs	:= {}


dbSelectArea("CTT")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " AK5 - Contas Or�ament�rias.                                   "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � OSMIL SQUARCINE    � Data �  01/12/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01   ARQUIVO ?       				                     �
//����������������������������������������������������������������
// Monta array com as perguntas

aAdd(aRegs,{	cPerg,;						// Grupo de perguntas
"01",;										// Sequencia
"Arquivo ?   ",;							// Nome da pergunta
"",;										// Nome da pergunta em espanhol
"",;										// Nome da pergunta em ingles
"mv_ch1",;									// Vari�vel
"C",;										// Tipo do campo
68,;										// Tamanho do campo
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
"DIR",;									    // F3 para o campo
"",;										// Identificador do PYME
"",;										// Grupo do SXG
"",;										// Help do campo
"" })										// Picture do campo

U_CriaSX1(aRegs)

//�������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                          �
//���������������������������������������������������������������

If !Pergunte( cPerg,.T.)
	Return(Nil)
EndIf


//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

Private nHdl    := fOpen(mv_par01,68)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser aberto! Verifique os parametros.","Atencao!")
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
���Fun��o    � RUNCONT  � Autor � OSMIL SQUARCINE    � Data �  01/12/06   ���
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

Local nTamFile, nTamLin, cBuffer, nBtLidos

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 77+Len(cEOL)   // Tamanho da Linha do Arquivo Texto
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua( RecCount() )

While nBtLidos >= nTamLin
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	
	IncProc()
	
	//���������������������������������������������������������������������Ŀ
	//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	//�����������������������������������������������������������������������
	
	dbSelectArea(cString)
	RecLock(cString,.T.)
	
	AK5->AK5_FILIAL		:= 	xFilial("AK5")
	AK5->AK5_CODIGO		:=	Substr(cBuffer,01,06)
	AK5->AK5_DESCRI		:=	Substr(cBuffer,07,60)
	AK5->AK5_TIPO		:= 	"2"
	AK5->AK5_DEBCRE		:=	"2"
	AK5->AK5_DTINC		:= dDataBase
	AK5->AK5_DTINI      := dDataBase
	AK5->AK5_MSBLQL		:= "2"
                                       	
	
	MSUnLock()
	
	//���������������������������������������������������������������������Ŀ
	//� Leitura da proxima linha do arquivo texto.                          �
	//�����������������������������������������������������������������������
	
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	
	dbSkip()
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
Close(oLeTxt)

MsgAlert("O arquivo de nome "+mv_par01+" foi migrado corretamente.","Aviso !")

Return



/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CriaSx1  � Verifica e cria um novo grupo de perguntas com base nos      ���
���             �          � par�metros fornecidos                                        ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 05.12.06 � Modelagem de Dados                                           ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 05.12.06 � TI2238 - Osmil Squarcine de Souza Leite                      ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � 99.99.99 � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpA1 = array com o conte�do do grupo de perguntas (SX1)                ���
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
User Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
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