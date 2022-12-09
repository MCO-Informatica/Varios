#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA390MNU �Autor  �ROBSON BUENO        � Data � 11/01/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     �PONTO DE ENTRADA PARA IMPRESSAO E ENVIO DE FOLLOW P/ DILIG  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA225MNU()             
  aAdd(aRotina, {"Status HCI"	,"U_HC225ST()" , 0 , 6})
		
Return()





/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A225Status� Autor � Larson Zordan         � Data � 12/06/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Alteracao do Status do saldo do armazem    (SB2)           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A225Status(ExpC1,ExpN1,ExpN2)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA225                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HC225ST(cAlias,nReg,nOpc)
LOCAL aAcho:={},aAltera:={}
If BlqInvent(B2_COD,B2_LOCAL)
	Help(" ",1,"BLQINVENT",,B2_COD+OemToAnsi("Status do Armazem")+B2_LOCAL,1,11)
Else
	aAdd(aAcho,"B2_COD")
	aAdd(aAcho,"B2_LOCAL")
	If !__lPyme
		aAdd(aAcho,"B2_LOCALIZ")
	EndIf	
	aAdd(aAcho,"B2_CM1")
	aAdd(aAcho,"B2_CM2")
	aAdd(aAcho,"B2_CM3")
	aAdd(aAcho,"B2_CM4")
	aAdd(aAcho,"B2_CM5")
	If ExistSX3("B2_EMIN   ")
		aAdd(aAcho,"B2_EMIN")
	EndIf
	
	If ExistSX3("B2_LE     ")
		aAdd(aAcho,"B2_LE")
	EndIf
	
	If ExistSX3("B2_EMAX   ")
		aAdd(aAcho,"B2_EMAX")
	EndIf
	
	If ExistSX3("B2_ESTSEG ")
		aAdd(aAcho,"B2_ESTSEG")
	EndIf
	
	If ExistSX3("B2_LOCABAS")
		aAdd(aAcho,"B2_LOCABAS")
	EndIf
	
	aAdd(aAcho,"B2_STATUS")
	aAdd(aAltera,"B2_STATUS")
	nOpca := AxAltera(cAlias,nReg,nOpc,aAcho,aAltera)
EndIf
Return
