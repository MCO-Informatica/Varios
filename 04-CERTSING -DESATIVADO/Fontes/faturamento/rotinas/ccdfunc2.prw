#Include "Fivewin.ch"
#Include "Tbiconn.ch"
#Include "Colors.ch"
#Include "Font.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CCDFUNC2  � Autor �Henio Brasil Claudino  � Data � 02/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Chamada das funcoes de Interface de Clientes e depois a     ���
���          �interface de Notas Fiscais.                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CALLJOB1  � Autor �Henio Brasil Claudino  � Data � 02/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Funcao de JOB a ser startado pelo WorkFlow do Protheus para ���
���          �chamar a interface de clientes e Notas como Job             ���
���          �Antiga funcao Rcomm03c()                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CALLJOB1(aParams)                                        // cArquivo, cEmp, cFilial 

//ConOut( "Inicio do Job de Importacao de Clientes e Notas Fiscais " )

//ConOut( "Preparando Ambiente - Importacao de Cliente e Notas Fiscais" )
// Prepare Environment Empresa '01' Filial '01' Tables 'SA1','SA2','SA5','SB1','SB2','SB5','SB8','SD1','SD2','SE1','SE2','SE5','SF1','SF2','SF3','SF4','SI1','SI2','SI3','SI4','SI5','SI6','SI7','SI8','SZ1','SZB','SZE','SZL','SZV','SZY'
Prepare Environment Empresa aParams[1] Filial aParams[2] 
//ConOut( "Fim da Preparacao do Ambiente - Importacao de Clientes e Notas Fiscais" )
/*
��������������������������������������������Ŀ
�Realiza a chamada para importacao de Cliente�
����������������������������������������������*/
//ConOut( "Inicio da importacao dos Clientes Novos " )
U_IMPCLI()
//ConOut( "Final da importacao dos Clientes Novos " )
/*
��������������������������������������������Ŀ
�Realiza a chamada para importacao de Notas  �
����������������������������������������������*/
//ConOut( "Inicio da importacao das Notas Fiscais " )
U_IMPNFS()
//ConOut( "Final da importacao das Notas Fiscais " )

//ConOut( "Final do Job de Importacao de Clientes e Notas Fiscais" )

Return Nil



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �CALLFUNC  � Autor �Henio Brasil Claudino  � Data � 06.08.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Chamada da funcao para validar a sua origem                 ���
���          �Verifica de qual rotina foi chamada esta funcao             ���
���          �Antiga funcao ECOMA10                                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CallFunc(cParam05)

Local ni := 0
Private cNomeRot := Upper(AllTrim(ProcName(ni)))

While !Empty(cNomeRot)
	   cNomeRot := Upper(AllTrim(ProcName(ni)))
	   If cNomeRot $ cParam05
   	      Return .t.
	   Endif 
	   nI++	
Enddo
Return .f.



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �STATPROC  � Autor �Henio Brasil Claudino  � Data � 02/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Monta a regua do total de processamento, com duas reguas    ���
���          �de progressao.                                              ���
���          �Antiga funcao EspProc()                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function StatProc(bCodigo,cTxtPrin,cTitle)

Local oDlgProc
Local oTxtPrin
Local lEnd	:= .F.

Private oTxtGua1
Private oTxtGua2
Private oGuage1
Private oGuage2

Private cTxtGua1	:= ""
Private cTxtGua2	:= ""
Private nFix1		:= 0
Private nFix2		:= 0

If cTxtPrin == Nil
	cTxtPrin:= OemToAnsi("Processando...")
EndIf
If cTitle == Nil
	cTitle:= OemToAnsi("Aguarde")
EndIf

Define Dialog oDlgProc From 066,001 To 233,341 Title cTitle Pixel Of GetWndDefault() Style DS_MODALFRAME
	// oDlgProc:nStyle := nOr(DS_MODALFRAME, WS_POPUP)
@ 015,007 Say oTxtPrin  Var OemToAnsi(cTxtPrin) Of oDlgProc Size 145,08 Pixel
@ 030,007 Say oTxtGua1  Var OemToAnsi(cTxtGua1) Of oDlgProc Size 145,08 Pixel
@ 052,007 Say oTxtGua2  Var OemToAnsi(cTxtGua2) Of oDlgProc Size 145,08 Pixel
@ 040,007 METER oGauge1 Var nFix1 SIZE 145,8 Of oDlgProc Pixel BARCOLOR CLR_BLUE,CLR_WHITE COLOR CLR_WHITE,CLR_BLUE
@ 062,007 METER oGauge2 Var nFix2 SIZE 145,8 Of oDlgProc Pixel BARCOLOR CLR_BLUE,CLR_WHITE COLOR CLR_WHITE,CLR_BLUE
oDlgProc:bStart = { || Eval(bCodigo),lEnd:= .T.,oDlgProc:bPainted := NIL,oDlgProc:bValid := NIL,oDlgProc:End() }
Activate Dialog oDlgProc Centered Valid lEnd

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �SETPROC   � Autor �Henio Brasil Claudino  � Data � 02/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Seta o valor total da regua                                 ���
���          �Antiga funcao EspSet()                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SetProc(nGauge,nQtd,cTexto)
/*
����������������������������Ŀ
�Verifica se o gauge e valido�
������������������������������*/
If nGauge <> 1 .And. nGauge <> 2
	nGauge:= 1
EndIf
/*
�����������������������Ŀ
�Seta o tamanho da regua�
�������������������������*/
&("oGauge"+Str(nGauge,1)):Set(0)
&("oGauge"+Str(nGauge,1)):SetTotal(nQtd)
&("oGauge"+Str(nGauge,1)):Refresh()
/*
��������������
�Seta o Texto�
��������������*/
If cTexto <> Nil
	&("cTxtGua"+Str(nGauge,1)):= cTexto
	&("oTxtGua"+Str(nGauge,1)):Refresh()
EndIf

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �ADDPROC   � Autor �Henio Brasil Claudino  � Data � 02/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Incrementa a regua                                          ���
���          �Antiga funcao EspInc()                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AddProc(nGauge,cTexto)
/*	
����������������������������Ŀ
�Verifica se o gauge e valido�
������������������������������*/
If nGauge <> 1 .And. nGauge <> 2
	nGauge:= 1
EndIf
/*
������������������Ŀ
�Incrementa o Gauge�
��������������������*/
&("nFix"+Str(nGauge,1)):= &("nFix"+Str(nGauge,1)) + 1
&("oGauge"+Str(nGauge,1)):Set(&("nFix"+Str(nGauge,1)))
&("oGauge"+Str(nGauge,1)):Refresh()
/*
��������������
�Seta o Texto�
��������������*/
If cTexto <> Nil
	&("cTxtGua"+Str(nGauge,1)):= cTexto
	&("oTxtGua"+Str(nGauge,1)):Refresh()
EndIf
/*
��������������������������������Ŀ
�Verifica se zera a regua parcial�
����������������������������������*/
If nGauge == 1
	oGauge2:Set(0)
	oGauge2:Refresh()
EndIf

Return Nil