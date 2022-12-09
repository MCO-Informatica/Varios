#INCLUDE "rwmake.ch" 
#INCLUDE 'PROTHEUS.CH' 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MDVENC � Autor � Luiz Alberto V Alves � Data �  22/02/18   ���
�������������������������������������������������������������������������͹��
���Descricao � Altera Vencimento Titulos Contas a Pagar                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MDVENC()
Local aArea := GetArea()
Private cCadastro := "Contas a Pagar"
Private aRotina := { 	{"Pesquisar"	,"AxPesqui",0,1} ,;
						{"Visualizar"	,"AxVisual",0,2} ,;
						{"Muda Vencto"	,"U_AltVencto()",0,6}}
						
						
dbSelectArea("SE2")

mBrowse( 6,1,22,75,"SE2")


RestArea(aArea)
Return(Nil)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AltVencto � Autor � Luiz Alberto      � Data �  22/02/18   ���
�������������������������������������������������������������������������͹��
���Descricao � Altera��o de Vencimento de Titulos Contas a Pagar          ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function AltVencto()
Local dDtVenc:=SE2->E2_VENCREA

If !Empty(SE2->E2_BAIXA)
	MsgStop("Aten��o o Titulo Posicionado Encontra-se Baixado, Imposs�vel Efetuar Altera��o !")
	Return .f.
Endif

DEFINE MSDIALOG oDlg TITLE "Altera Vencimento Titulos a Pagar" FROM 0,0 TO 150,400 OF oDlg PIXEL

@ 07, 10 SAY   "Vencto Atual"     SIZE 100,8 PIXEL OF oDlg 		// pega o numero do pedido
@ 07, 65 SAY DTOC(SE2->E2_VENCREA) SIZE 50,10 PIXEL OF oDlg
		
@ 35, 10 SAY   "Mudar Parar:"     SIZE 100,8 PIXEL OF oDlg //pega o numero da OP manual
@ 35, 65 MSGET dDtVenc Picture '99/99/9999' Valid dDtVenc >= SE2->E2_EMISSAO SIZE 60,10 PIXEL OF oDlg
		
@ 35,140 BUTTON "OK"          SIZE 25,13 PIXEL ACTION oDlg: End()
	
ACTIVATE MSDIALOG oDlg CENTER ON INIT(oDlg)

If Empty(SE2->E2_BAIXA)
	If RecLock("SE2",.f.)
		SE2->E2_VENCTO	:=	dDtVenc
		SE2->E2_VENCREA	:=	dDtVenc
		SE2->(MsUnlock())
	Endif
Endif

Return 



/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()   � Autores � Norbert/Ernani/Mansano � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//���������������������������Ŀ
//�Tratamento para tema "Flat"�
//�����������������������������
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)
