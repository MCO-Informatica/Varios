#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA450I   �Autor  �Microsiga           � Data �  01/27/11   ���
�������������������������������������������������������������������������͹��
���          � Ponto de Entrada- Liberacao de Credito de Pedido de        ���
���          �   Venda para gravar status do Painel de Pedido no SC6      ���
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

//IMPORTANTE!!!!!!!!!!!!!

/*BEGINDOC
//��������������������������������������������A8�
//�ESTE FONTE ESTA COM ALGUMAS PARTES         �
//�COMENTADAS.                                �
//�ELAS SAO DA CUSTOMIZACAO DE VERIFICACAO DE �
//�ESTOQUE NO PAINEL DE PEDIDO.               �
//�                                           �
//�FORAM COMENTADAS POIS O ESTOQUE AINDA NAO  �
//�ESTA FUNCIONANDO CORRETAMENTE.             �
//��������������������������������������������A8�
ENDDOC*/
            


/*BEGINDOC
//�����������������������������������������������Ŀ
//�APOS 17/05/2012 NAO SERA MAS UTILIZADA A ROTINA�
//�DE APROVACAO DE CREDITO, ASSIM ESTE FONTE NAO  �
//�SERA MAIS UTILIZADO                            �
//�������������������������������������������������
ENDDOC*/

User Function MTA450I()
/*
	dbSelectArea("SC9")
	While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == SC9->C9_FILIAL+SC9->C9_PEDIDO 

	//_nQtdlib	:= SC9->C9_QTDLIB  		//VARIAVEIS UTILIZADAS PARA VERIFICACAO DE ESTOQUE
	//_cBlest		:= SC9->C9_BLEST

	RecLock("SC6",.F.)
	
		//VERIFICA SE O ITEM ESTA APTO A MUDANCA DE STATUS.
		If SC6->C6_XALTERA == .T.
		
			//If _cBlest =	" " 
			//	SC6->C6_XSTATUS := "7"
			//ElseIf _cBlest =="10"   
			//	SC6->C6_XSTATUS := "7"  
			//Else                  
				SC6->C6_XSTATUS := "1"
			//EndIf 
			SC6->C6_XALTERA := .F.
			
		EndIf                  
	
	MsUnlock()
	        
dbSelectArea("SC6")
	dbSkip()
EndDo
*/
 Return()
