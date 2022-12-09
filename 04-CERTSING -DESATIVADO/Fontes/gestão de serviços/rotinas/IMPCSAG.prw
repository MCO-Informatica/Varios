#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPSCAG �Autor  �TSM (Claudio)       � Data �  25/11/16     ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao criada para tratar o legado das Os de Agendamento Ext���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function IMPSCAG

Local oDlg		:= NIL
Local cCaminho	:= ''
Local cGetFile 	:= ''
Local lRet		:= .F.

DEFINE MSDIALOG oDlg TITLE "Selecione o Arquivo do Banco de Conhecimento" FROM 0,0 TO 100,300 PIXEL
		
	@ 10,10 BUTTON "Abrir" SIZE 45,8 PIXEL OF oDlg ACTION cCaminho := cGetFile('Arquivo *|*.*|Arquivo TXT|*.txt','Selecione um arquivo',1,'C:\',.F.,GETF_LOCALHARD,.F.)
	
	//botao ok
	DEFINE SBUTTON FROM 30,60 TYPE 1 ACTION {|| lRet := .T., oDlg:End()} ENABLE OF oDlg
	//botao cancelar
	DEFINE SBUTTON FROM 30,100 TYPE 2 ACTION {|| lRet := .F., oDlg:End()} ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

If lRet 
	
	Processa( { || IMPPROCESS(cCaminho) } )
	
End If

Return 

Static Function IMPPROCESS(cCaminho)

Local lRet 			:= .T.
Local nTamDet 		:= 6
Local nQtdRec		:= 0
Local aOs			:= {}
Local aLog			:= {}

/*-----------------------------------------
Abre arquivo com a rela��o das OS
------------------------------------------*/
If !File(cCaminho)
	ApMsgAlert("Arquivo "+cCaminho+" n�o localizado. O sistema ser� abortado.")
	UserException("Arquivo "+cCaminho+" n�o localizado. O sistema foi abortado propositalmente. "+CRLF)
	lRet := .F.
	Return lRet
Else

	cArquivo := cCaminho
	If !File(cArquivo)
		nHdlRen := FRENAME(cCaminho,cArquivo)
		If nHdlRen < 0
			ApMsgAlert("Erro ao renomear arquivo "+cCaminho+" O sistema ser� abortado.")
			UserException("Erro ao renomear arquivo "+cCaminho+" O sistema foi abortado propositalmente. "+CRLF)
			lRet := .F.
			Return lRet
		EndIf
	Endif
	
	/*
	---------------------------------------
	Abre arquivo para leitura
	---------------------------------------*/
	nHdlOs := FOPEN(cArquivo)
	
	/*
	---------------------------------------
	Cria novo arquivo com as altera��es
	---------------------------------------*/
	cCaminho := FileNoExt(cCaminho)+"V"+".TXT"
	nHdlNew := FCREATE(cCaminho)
	If nHdlNew < 0
		ApMsgAlert("Erro ao criar arquivo "+cCaminho+" O sistema ser� abortado.")
		UserException("Erro ao renomear arquivo "+cCaminho+" O sistema foi abortado propositalmente. "+CRLF)
		lRet := .F.
		Return lRet
	EndIf

Endif

/*
-----------
Le arquivo 
-----------
*/

FSeek(nHdlOs,0,0)
nTamArq:=FSeek(nHdlOs,0,2)
FSeek(nHdlOs,0,0)

nNumSeq	:= 0

ProcRegua( Int(nTamArq/6) )

While .T.
	
	nQtdRec++
	IncProc( "Processando registro "+Alltrim(Str(nQtdRec)) )
	ProcessMessage()
	
	xBuffer:=Space(nTamDet)
	FREAD(nHdlOs,@xBuffer,nTamDet)
	
	If Empty(xBuffer)		//Fim do arquivo
		Exit
	EndIf
	
	aAdd(aOs,{xBuffer}) 
	
	nNumSeq++
	
End

For n := 1 To Len(aOs)

	dbSelectArea("PA0")
	dbSetOrder(1)
	dbSeek(xFilial("PA0")+aOs[n][1])
	
	If PA0->(Found()) .And. PA0->PA0_OS == aOs[n][1]
	
		BEGIN TRANSACTION                         
		
			RecLock("PA0",.F.)
			PA0->PA0_STATUS 		:= "3"
			PA0->PA0_DTINC 			:= PA0->PA0_DTAGEN
			PA0->PA0_EMAIL 			:= "ADM_AGENDAMENTO@CERTISIGN.COM.BR"
			PA0->PA0_DTEBOL			:= PA0->PA0_DTAGEN
			PA0->PA0_DTVBOL			:= PA0->PA0_DTAGEN
			PA0->PA0_DTABER			:= PA0->PA0_DTAGEN
			PA0->PA0_HORABR			:= PA0->PA0_HRAGEN
			PA0->PA0_TIPATE			:= "ADM"
			PA0->PA0_CONAGE			:= "ADM" 
			MsUnlock()
		
		END TRANSACTION	
		
		dbSelectArea("PA1")
		dbSetOrder(1)
		dbSeek(xFilial("PA1")+aOs[n][1])
		
		If PA1->(Found())
		
			While PA1->(!EOF()) .And. PA1->PA1_OS == aOs[n][1]
			
				If ALLTRIM(PA1->PA1_PRODUT) == "SV010001"
			
					BEGIN TRANSACTION 
				
						RecLock("PA1",.F.)
						PA1->PA1_FATURA 			:= "P"
		 				MsUnlock()
					
					END TRANSACTION
				
				End If
				
				PA1->(dbSkip())
					
			End
			
		Else
		
			aAdd(aLog,{aOs[n][1],"PA1 n�o atualizada"})
		
		End If
		
		aAdd(aLog,{aOs[n][1],"OS atualizada com sucesso"})
	
	Else
		
		aAdd(aLog,{aOs[n][1],"OS n�o atualizada"})
	
	End If
	
Next n

Return lRet