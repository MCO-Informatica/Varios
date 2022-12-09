#INCLUDE "Totvs.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRPA023    � Autor � Renato Ruy	     � Data �  12/12/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Exclui lan�amentos da SZ5, usado para limpar lan�amento de ���
���          � vendedor inativo.					                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CRPA023


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

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Exclusao de Lan�amentos" PIXEL

@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

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

Local Ni

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

Local nTamFile, nTamLin, cBuffer, nBtLidos, xBuff, aLin, cTipo, cTipPed
Local  nRecAtu := 0

Private cRemPer		:= GetMV("MV_REMMES") // PERIODO DE CALCULO EM ABERTO

//�����������������������������������������������������������������ͻ
//� Lay-Out do arquivo Texto gerado:                                �
//�����������������������������������������������������������������͹
//�Campo           � Inicio � Tamanho                               �
//�����������������������������������������������������������������Ķ
//� ??_FILIAL     � 01     � 02                                    �
//�����������������������������������������������������������������ͼ

FT_FUSE(cArqTxt)

nTotRec := FT_FLASTREC()
BarGauge2Set( nTotRec )

FT_FGOTOP()

While !FT_FEOF()
	
	xBuff	:= alltrim(FT_FREADLN())
	aLin 	:= StrTokArr(xBuff,";")		
	cTipo 	:= iif(Len(aLin)>1,aLin[2],"")
	cTipPed := iif(Len(aLin)>2,aLin[3],"")
	
	If Empty(cTipo)
		MsgInfo("Efetue o preenchimento do campo tipo na planilha, rotina cancelada!")
		Return
	Elseif Empty(cTipPed)
		MsgInfo("O tipo de pedido de dever ser informado na terceiro coluna. G = Pedido Gar e S = Pedido Site")
		Return
	EndIf
	
	If AllTrim(cTipo) == "A"
		cTipo := "2/5"
	Elseif AllTrim(cTipo) == "P"
		cTipo := "4"
	Elseif AllTrim(cTipo) == "C"
		cTipo := "1"
	Elseif AllTrim(cTipo) == "F"
		cTipo := "8"
	Elseif AllTrim(cTipo) == "R"
		cTipo := "10"
	Elseif AllTrim(cTipo) == "S"
		cTipo := "7"
	Elseif AllTrim(cTipo) == "T"
		cTipo := "1/2/4/5/7/8/10/B"
	Endif
	
	IncprocG2( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
	ProcessMessage()
	
	If ValType(aLin[1]) <> "U"
	    
		// Verifico para se o conte�do n�o � Texto.
		If aLin[1] < "9999999999"
		    
		    If AllTrim(cTipPed) == "G"
				DbSelectArea("SZ6")
				DbSetOrder(1)
				If DbSeek( xFilial("SZ6") + AllTrim(aLin[1]) )
				    
				    While AllTrim(aLin[1]) == AllTrim(SZ6->Z6_PEDGAR)
				    	//Yuri Volpe - 03/12/2018
				    	//OTRS 2018112610000585 - Remover bloqueio de calculo para produtos IFEN 
						If AllTrim(SZ6->Z6_TPENTID) $ cTipo .And. cRemPer == SZ6->Z6_PERIODO .And. Substr(AllTrim(SZ6->Z6_PRODUTO),1,4) != "IFEN" .And. SZ6->Z6_TIPO != "RETIFI"
						
							//Renato Ruy - 22/03/2018
							//Bloqueio de recalculo de faixa quando existe planilha ativa
							ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
							If ZZG->(DbSeek(xFilial("ZZG")+SZ6->Z6_PERIODO+SZ6->Z6_CODCCR+"1")) .And. AllTrim(SZ6->Z6_TPENTID) $ "4/8"
								MsgInfo("O Pedido n�o poder� ser excluido, j� existe planilha ativa no portal da rede!")
								Return	.F.
							Elseif ZZG->(DbSeek(xFilial("ZZG")+SZ6->Z6_PERIODO+SZ6->Z6_CODCCR+"1")) .And. AllTrim(SZ6->Z6_TPENTID) $ "1/2/5/10"
								MsgInfo("O Pedido n�o poder� ser excluido, j� existe planilha ativa no portal da rede!")
								Return	.F.
							Elseif AllTrim(SZ6->Z6_TPENTID) == "7"
								//Buscar entidade pai
								Beginsql Alias "TMPPOR"
									SELECT Z3_CODENT CODCCR FROM %Table:SZ3%
									WHERE
									Z3_FILIAL = ' ' AND
									(Z3_CODPAR LIKE %Exp:AllTrim(Z6_CODENT)% OR Z3_CODPAR2 LIKE %Exp:AllTrim(Z6_CODENT)%) AND
									Z3_TIPENT = '9' AND
									%NOTDEL%
								Endsql
								
								If ZZG->(DbSeek(xFilial("ZZG")+SZ6->Z6_PERIODO+TMPPOR->CODCCR+"1")) .And. AllTrim(SZ6->Z6_TPENTID) $ "1/2/5/10"
									MsgInfo("O Pedido n�o poder� ser excluido, j� existe planilha ativa no portal da rede!")
									Return	.F.
								Endif
								
								TMPPOR->(DbCloseArea())
							Endif
							
							RecLock("SZ6",.F.)
								SZ6->(dbDelete())
							SZ6->(MsUnLock())
			
						EndIf
						SZ6->(DbSkip())
					EndDo
				
				EndIf
			Elseif AllTrim(cTipPed) == "S"
				DbSelectArea("SZ6")
				DbSetOrder(4)
				If DbSeek( xFilial("SZ6") + AllTrim(aLin[1]) )
				    
				    While AllTrim(aLin[1]) == AllTrim(SZ6->Z6_PEDSITE)
						If AllTrim(SZ6->Z6_TPENTID) $ cTipo .And. cRemPer == SZ6->Z6_PERIODO 
						
							RecLock("SZ6",.F.)
								SZ6->(dbDelete())
							SZ6->(MsUnLock())
			
						EndIf
						SZ6->(DbSkip())
					EndDo
				
				EndIf
			EndIf
		EndIf
	
	EndIf
	

	FT_FSKIP()
Enddo

FT_FUSE()


fClose(nHdl)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA01   �Autor  �Microsiga           � Data �  01/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CRPA022A(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret�rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.CSV")

Return(.T.)

