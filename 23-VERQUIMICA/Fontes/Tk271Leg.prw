
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK271LEG  �Autor  �Nelson Junior       � Data �  15/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE para altera��o das legendas do MBROWSE na tela de Call   ���
���          �Center.                                                     ���   
��� Alterado Por:| Danilo Alves Del Busso 				|Data: 31/07/2015 ��� 	  
��� Descria��o:	 | Ajustada a vari�vel aCores para exibir as cores para	  ��� 
��� as legendas de libera��o por REGRA ou VERBA							  ��� 
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Tk271Leg(cPasta)

Local aArea  := GetArea()
Local aCores := {}

If cPasta == "2" //Televendas
	//
	aCores := {	{"BR_MARRON"  	,"Atendimento" 			},;
				{"BR_AZUL"		,"Or�amento" 			},;    
				{"BR_PINK"		,"Bloqueado para libera��o - REGRA"	}	,;
				{"BR_LARANJA"	,"Bloqueado para libera��o - FINANCEIRO"	},;
				{"BR_AMARELO"	,"Bloqueado para libera��o - ESTOQUE"	}	,;
				{"BR_VERDE"    	,"Faturamento" 			},;
				{"BR_VERMELHO" 	,"NF. Emitida" 			},;
				{"BR_PRETO"    	,"Cancelado" 			} }
	//
EndIf

RestArea(aArea)

Return(aCores)