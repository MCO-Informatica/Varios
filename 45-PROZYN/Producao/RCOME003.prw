#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCOME003  � Autor � Ricardo Nisiyama   � Data �  08/11/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Browse para Observa��o na NF de entrada                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Prozyn                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RCOME003()   
                                               
Private oDlg, oMemo
Private cMemo:= SF1->F1_OBSERV

If AllTrim(SF1->F1_CHVNFE) <> ""
	DEFINE MSDIALOG oDlg FROM 0,0 TO 300,600 PIXEL TITLE "Observacao"
	oMemo:= tMultiget():New(30,10,{|u|if(Pcount()>0,cMemo:=u,cMemo)};
	,oDlg,280,100,,,,,,.T.)
	@ 10,10 SAY "Observacao para NF de entrada"	SIZE 300,7 OF oDlg PIXEL //"Codigo"
	//@ 20,10 SAY "Teste"	SIZE 300,7 OF oDlg PIXEL			 //"Codigo"
	//@ 135,10 BUTTON oBtn PROMPT "Confirma" OF oDlg PIXEL ACTION Grava()
	@ 135,10 BUTTON oBtn PROMPT "Fecha" OF oDlg PIXEL ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED
	//Return()
Else                              
	 
	DEFINE MSDIALOG oDlg FROM 0,0 TO 300,600 PIXEL TITLE "Observacao"
	oMemo:= tMultiget():New(30,10,{|u|if(Pcount()>0,cMemo:=u,cMemo)};
	,oDlg,280,100,,,,,,.T.)
	@ 10,10 SAY "Observacao para NF de entrada"	SIZE 300,7 OF oDlg PIXEL			 //"Codigo"
	//@ 20,10 SAY "Teste"	SIZE 300,7 OF oDlg PIXEL			 //"Codigo"
	@ 135,10 BUTTON oBtn PROMPT "Confirma" OF oDlg PIXEL ACTION Grava()
	@ 135,100 BUTTON oBtn PROMPT "Fecha" OF oDlg PIXEL ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED
Endif

Return()


Static Function Grava() 

DbSelectArea("SF1")
Reclock("SF1",.F.)
SF1->F1_OBSERV  := cMemo      
//SE1->E1_HHORA  := Substr(TIME(),1,5) 
//SE1->E1_HDATA  := ddatabase
MsUnLock()

Close(oDlg)

Return()