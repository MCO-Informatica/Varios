/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ZFATF02 � Autor �                        � Data � 00/00/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �      			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#INCLUDE "PRTOPDEF.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function ZFATF02(aCabec,aItens)

Local bRet 			:= .T.
Private LMSERROAUTO := .F.
/*
RPCSETTYPE(3)
RPCSETENV("01","01",,,"SIGAFAT","TESTE",)  
Sleep( 1000 )     // aguarda 1 segundo para que as jobs IPC subam.
MsExecAuto ( {|x,y,z| MATA410(x,y,z) }, aCabec,aItens, 3)

IF LMSERROAUTO

	conout("Erro 001")
	cMotivo := "Erro 001"  // Variavel necessaria para o GravaLog()
	__CopyFile(NomeAutoLog(),"erro001.log")
	Gravalog()
	bRet := .F.
	
ELSE

	bRet := .T.

ENDIF

RpcClearEnv( )
*/
return(bRet)