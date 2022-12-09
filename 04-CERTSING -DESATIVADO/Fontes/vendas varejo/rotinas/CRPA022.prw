#INCLUDE "Totvs.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRPA022   � Autor � Renato Ruy	     � Data �  12/12/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para importa��o de dados que ser�o usado para     ���
���          � calculo do remunera��o de parceiros.                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CRPA022


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local oDlg
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
Local aDirIn	:= {}
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.
Private cForca
Private aForca    := {"1=N�o",;
					"2=Sim"}

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Leitura de Dados do GAR e Atualiza��o via WebService" PIXEL

@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 22,10 SAY "For�a Atualiza��o:" OF oDlg PIXEL
@ 22,70 ComboBox cForca Items aForca Size 072,010 PIXEL OF oDlg

@ 45,010 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CRPA022A(@aDirIn,@cDirIn)
@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1
	Return(.F.)
EndIf

If len(aDirIn) = 0
	MsgAlert("N�o Foram encontrados Arquivos para processamento!")
	Return(.F.)
EndIf

Proc2BarGauge({|| OkLeTxt(cDirIn,aDirIn) },"Processamento de Arquivo TXT")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  12/12/14   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt(cDirIn,aDirIn)

Local nI := 0

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

Private cArqTxt := ""
Private nHdl    := ""

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

For nI:= 1 to len(aDirIn)
	cArqTxt := cDirIn+aDirIn[nI][1]
	nHdl    := fOpen(cArqTxt,68)
	//	If nHdl == -1
	//    	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	//	Endif
	IncProcG1("Proc. Arquivo "+aDirIn[nI][1])
	ProcessMessage()
	RunCont()
Next

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  12/12/14   ���
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

Local nTamFile, nTamLin, cBuffer, nBtLidos, xBuff, aLin, cTipLin
Local nValSoft 		:= 0
Local nValHard 		:= 0
Local nValTotHW		:= 0
Local nValTotSW		:= 0
Local nValTot		:= 0
Local cTabela		:= ""
Local nRecAtu 		:= 0
Local cCodCombo		:= ""
Local cCategoSFW	:= GetNewPar("MV_GARSFT", "2")
Local cCategoHRD	:= GetNewPar("MV_GARHRD", "1")
Local lTipVou		:= .T.
Local lImporta		:= .T.
Local lHardFix		:= .F.
Local cVouAnt		:= ""
Local cProduto		:= ""
Local cPosto		:= ""
Local nRecno		:= 0
Local cPedAnt		:= ""
Local cCodSoft 		:= ""
Local cCodHard 		:= "" 
Local cPedido		:= ""
Local nThread 		:= 0
Local aUsers		:= {}
Local aPedidos		:= {}
Local lNaoPagou		:= .T.
private cArqLog 	:= SubStr(cArqTxt,1,Len(cArqTxt)-4)+".Log"
private nHdlLog  	:= fCreate(cArqLog)
private cEOL    	:= "CHR(13)+CHR(10)"
private nTamLin, cLin, cCpo

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdlLog != -1
	cLin := "Ped.GAR;Cod. Voucher Ped.;Tipo Voucher Pedido;Cod.Voucher Origem;Tipo Voucher Origem;Valor Software;Valor Hardware;Valor Total"+cEOL
	fWrite(nHdlLog,cLin)
Endif

//�����������������������������������������������������������������ͻ
//� Lay-Out do arquivo Texto gerado:                                �
//�����������������������������������������������������������������͹
//�Campo           � Inicio � Tamanho                               �
//�����������������������������������������������������������������Ķ
//� ??_FILIAL      � 01     � 02                                    �
//�����������������������������������������������������������������ͼ

FT_FUSE(cArqTxt)

nTotRec := FT_FLASTREC()

FT_FGOTOP() 

IncprocG2( "Processando Registro "+AllTrim(Str(nRecAtu))+" de "+AllTrim(Str(nTotRec)) )
ProcessMessage()

While !FT_FEOF()
	
	//Faz distribui��o e monitora a quantidade de thread em execu��o
	nThread := 0
	aUsers 	:= Getuserinfoarray()
	aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA027B",nThread++,nil )  })
	
	//Limita a quantidade de Threads.
	If nThread < 10
		
		nContador := 0
		aPedidos  := {}
		
		//Envio para processamento de 10 em 10 pedidos.
		While !FT_FEOF() .And. nContador < 100
			//Leio a linha e gero array com os dados
			xBuff	:= alltrim(FT_FREADLN())
			aLin 	:= StrTokArr(xBuff,";")
			
			//Adiciono o conte�do em uma variavel para enviar para o array
			cPedido := iif(Len(aLin)>0,StrTran(aLin[1],'"',''),"")
			
			//Se n�o estiver vazio adiciono no array
			If !Empty(cPedido)
				Aadd(aPedidos,{cPedido,0,""})
				nContador += 1
			EndIf
						
			//Pulo para a pr�xima linha.
			FT_FSKIP()
		EndDo
		
		//Envio o conte�do para Thread se o array for maior que um
		If Len(aPedidos) > 0                                      
			nRecAtu += nContador
			IncprocG2( "Processando Registro "+AllTrim(Str(nRecAtu))+" de "+AllTrim(Str(nTotRec)) )
			ProcessMessage()
			
			StartJob("U_CRPA027B",GetEnvServer(),.F.,'01','02',aPedidos,cForca)
			//U_CRPA027B('01','02',aPedidos,cForca) //Fazer Debug
		EndIf
		
	EndIf

	If nThread >= 10
		Sleep( 10000 )	
		DelClassIntf()
	EndIf
	
Enddo

FT_FUSE()


fClose(nHdl)

MsgInfo("Importa��o finalizada com sucesso!")

FT_FUSE()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA01    �Autor  �Microsiga           � Data �  01/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CRPA022A(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret�rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.TXT")

Return(.T.)

Return
