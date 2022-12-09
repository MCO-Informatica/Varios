#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  03/10/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function vera120(_nvlraem,_cprxd)
local oDesc
Local _aAre       := GetArea()
local nopca	      := 0
local cXDescad    := ''

private __ODlg
private nXvrcom   := 0
private nXmargem  := 50
private NRET 	  := 0

// tratamento especifico para VERION E AEM...
If SM0->M0_CODIGO == "01"
	If SB1->B1_VERCOM > 0
		Return (0)
	Endif
	Prod      := M->UB_PRODUTO
ELSE 
    If _nvlraem > 0 
       Return (SB1->B1_PRV1)
	Endif
	
	If M->UA_XCPROJ <> 'S'
	   Return (0)
	Endif
    Prod      := _cprxd
Endif

_nPosProd := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_PRODUTO"})
_nPosXDes := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XDESCAD"})
_nPosXvrc := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XVRCOMP"})
_nPosXmar := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XMARGEM"})
_nPosDSC  := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRDESC"})
cXDescad  := acols[N,_nPosXDes]
nXvrcom   := acols[N,_nPosXvrc]
nXmargem  := acols[N,_nPosXmar]

DBSELECTAREA("SG1")
DBSETORDER(1)
If dbseek(xfilial("SG1")+alltrim(prod))
	cMest  :=  "Este pruduto TEM estrutura"
else
	cMest  :=  "Este Produto N�O tem estrutura"
endif

DBSELECTAREA("SB1")
DBSETORDER(1)
If nXvrcom = 0 .and. dbseek(xfilial("SB1")+alltrim(prod))
    If SB1->B1_UPRC > 0 
   		nXvrcom  :=  SB1->B1_UPRC
	Else 
		nXvrcom  :=  SB1->B1_CUSTD  
	Endif
Endif

DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Item nacional") From 0,0 To 280,505 PIXEL OF oMainWnd 
@ 35, 007  	SAY OemToAnsi("Codigo do Produto .: "+ prod + "-"+acols[N,3]) PIXEL   // 10
@ 47, 007   Say OemToAnsi(cMest) PIXEL  //READONLY
@ 60, 007  	SAY OemToAnsi("Valor de compra : ") PIXEL				
@ 60, 050	MSGET nXvrcom Picture "9999,999.99" SIZE 060,08 When .t. Valid .T. OF __ODlg PIXEL
@ 60, 115   BUTTON "Hist.Prod." SIZE 040, 010 PIXEL OF __ODlg ACTION (u_MaCom(SB1->B1_COD))
@ 60, 160 	Say OemToAnsi("Margem de Venda %: ") PIXEL  			
@ 60, 215 	MSGET nXmargem Picture "999.99"  SIZE 15,08 When .t. Valid nxMARGEM > 49.9 OF __ODlg PIXEL
@ 75, 007	Say OemToAnsi("Descri��o: ") PIXEL				
@ 75, 035   GET oDesc VAR cXDescad OF __ODlg MEMO size 180,60 PIXEL  NO VSCROLL  //READONLY
ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:=1,if(.t.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()}) // VALID nOpca != 0

If nOpca = 1
	acols[n,_nPosDSC]  :=   0
	acols[N,_nPosXDes] := 	cXDescad
	acols[N,_nPosXvrc] :=	nXvrcom
	acols[N,_nPosXmar] := 	nXmargem
	M->UB_XDESCAD      := 	cXDescad
	M->UB_XVRCOMP      :=	nXvrcom
	M->UB_XMARGEM      :=   nXmargem
	M->UB_PRODUTO      :=   Prod
	RestArea(_aAre)
	
	Return( nXvrcom * ((nXmargem + 100) / 100))
Else
	M->UB_PRODUTO := Prod
	RestArea(_aAre)
	Return(0)
Endif


user function macom(codprd)
Local _aArea :=	GetArea()
MaComView(codprd)
RestArea(_aArea)
Return .t.