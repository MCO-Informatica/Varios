#include "protheus.ch"

#define NAME_PROC    "Acertando"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AtuvalSX2 � Autor � Pedro Augusto         � Data �22/02/2011���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa para apontar as tabelas SY3, SAI, SAK, SAL        ���
���          � para a empresa 03 - RENOVA                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RENOVA                                                     ���
��������������������������������������������������������������������������ٱ�
*/
User Function AtuTabSX2()

cArqEmp := "SigaMat.Emp"
nModulo		:= 44
__cInterNet := Nil
PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd


#IFDEF TOP
	TCInternal(5,'*OFF') //-- Desliga Refresh no Lock do Top
#ENDIF

Set Dele On

OpenSm0()
DbGoTop()

If Aviso("Atualiza��o do Dicionario ","Esta Rotina tem o objetivo de alterar o direcinamento de algumas tabelas no SX2 (SY3,SAI,SAK,SAL) ",{"Continuar","Sair"})==1
	lEmpenho	:= .F.
	lAtuMnu		:= .F.

	DEFINE WINDOW oMainWnd FROM 0, 0 TO 1, 1 TITLE "Efetuando Atualizacao do Dicionario"+NAME_PROC

	ACTIVATE WINDOW oMainWnd ICONIZED ON INIT (lHistorico 	:= MsgYesNo("Sistema em modo exclusivo - Ok !"+CHR(13)+CHR(10)+"Deseja continuar com a atualizacao do Dicionario ", "Aten��o"),If(lHistorico,(Processa({|lEnd| UpdAtuSx2(@lEnd)},"Processando Atualiza��es "+NAME_PROC,"Aguarde, processando preparacao dos arquivos",.F.) , oMainWnd:End()),oMainWnd:End()))
EndIf																		

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Proc      � Autor �Paulo Augusto          � Data �18/07/05  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de processamento da gravacao dos arquivos           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function UpdAtuSx2(lEnd)
Local cTexto   := ''
Local cFile    :=""
Local cMask    := "Arquivos Texto (*.TXT) |*.txt|"
Local cCodigo  := "DM"
Local nRecno   := 0
Local nX       :=0

ProcRegua(1)
IncProc("Verificando integridade dos dicionarios....")

dbSelectArea("SM0")
dbGotop()
While !Eof()
	RpcSetType(2)
	RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	SM0->(dbSkip())
	nRecno := SM0->(Recno())
	SM0->(dbSkip(-1))
	RpcClearEnv()
//	OpenSm0Excl()
	SM0->(DbGoTo(nRecno))
EndDo
IncProc("Verificando integridade dos dicionarios....")
dbSelectArea("SM0")
dbGotop()
While !Eof()
		RpcSetType(2)
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
		cTexto += Replicate("-",128)+CHR(13)+CHR(10)
		cTexto += "Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME+CHR(13)+CHR(10)
				
		// atualiza SX2 - dicionario de dados
		IncProc("[" + AllTrim(SM0->M0_CODIGO) + "/" + AllTrim(SM0->M0_CODFIL) + "] " + ;
		        "Atualizando dicionario de dados...")		        
		cTexto += ActAtuSX2()
			
		SM0->(dbSkip())
		nRecno := SM0->(Recno())
		SM0->(dbSkip(-1))
		RpcClearEnv()
//		OpenSm0Excl()
		SM0->(DbGoTo(nRecno))
EndDo

dbSelectArea("SM0")
dbGotop()
RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,,,,, { "AE1" })

cTexto := "Log da atualizacao "+CHR(13)+CHR(10)+cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida." From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL 
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.T.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL 


ACTIVATE MSDIALOG oDlg CENTER


Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ActAtuSX3 � Autor �Paulo Augusto          � Data �18/07/05  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de processamento da gravacao do SX3                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ActAtuSX2()

Local aSX2   := {}


Local i      := 0
Local cTexto := ''
Local cAlias := ''
aAdd(aSX2, {'SY3','SY3030'})
aAdd(aSX2, {'SAI','SAI030'})                                  
aAdd(aSX2, {'SAK','SAK030'})
aAdd(aSX2, {'SAL','SAL030'})

ProcRegua(Len(aSX2))

dbSelectArea("SX2")
dbSetOrder(1)

For I :=1 to Len(aSX2)	
	If dbSeek(aSX2[i,1])	
		dbSelectArea("SX2")
		RecLock("SX2",.F.)
		Replace x2_arquivo with aSX2[i,2] 			
		cTexto += "Acertado a tabela " + aSX2[i] + Chr(13) + Chr(10)
		MsUnLock()
	EndIf
Next i

cTexto := "Tabelas atualizadas : " + cAlias + Chr(13) + Chr(10) + cTexto


Return cTexto
