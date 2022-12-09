/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACOM010   �Autor  �Microsiga           � Data �  05/19/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Chamada da funcao de solicitacao de compras.                ���
���          �Apenas atualiza o browser.                                  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico lisonda                                          ���
�������������������������������������������������������������������������ͼ��
���Mauro     � Conforme solicitacao do sr.Marcos foram automatizado os    ���
���08/02/2013� status em algumas situacoes                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACOM010()


If select('SC1') > 0
	DbSelectArea('SC1')
	DbGotop()
	Do While !EOF()
	   Do Case
	      Case !Empty(C1_RESIDUO)
				  RecLock('SC1')
				  SC1->C1_STATUS := 'A'
				  MsUnLock()
			Case C1_QUJE==C1_QUANT
				  RecLock('SC1')
				  SC1->C1_STATUS := 'A'
				  MsUnLock()	  
		   Case Empty(SC1->C1_STATUS) .or. SC1->C1_STATUS = 'C'			
					If C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV $ " ,L"
						If Empty(SC1->C1_STATUS)
							RecLock('SC1')
							SC1->C1_STATUS := 'P'
							MsUnLock()          	
						EndIf
					ElseIf C1_QUJE==0.And.(C1_COTACAO==Space(Len(C1_COTACAO)).Or.C1_COTACAO=="IMPORT").And.C1_APROV="R"
						RecLock('SC1')
						SC1->C1_STATUS := 'A'
						MsUnLock()
					ElseIf C1_QUJE==0.And.(C1_COTACAO==Space(Len(C1_COTACAO)).Or.C1_COTACAO=="IMPORT").And.C1_APROV="B"
						RecLock('SC1')
						SC1->C1_STATUS := 'B'
						MsUnLock()					
					ElseIf C1_QUJE>0.And.Empty(SC1->C1_STATUS)
						RecLock('SC1')
						SC1->C1_STATUS := 'P'
						MsUnLock()
					ElseIf C1_QUJE==0.And.C1_COTACAO<>Space(Len(C1_COTACAO)).And. C1_IMPORT <>"S"
						RecLock('SC1')
						SC1->C1_STATUS := 'A'
						MsUnLock()
					ElseIf C1_QUJE==0.And.C1_COTACAO<>Space(Len(C1_COTACAO)).And. C1_IMPORT =="S".And.C1_APROV $ " ,L"
						RecLock('SC1')
						SC1->C1_STATUS := 'A'
						MsUnLock()
					EndIf
			Case !Empty(SC1->C1_STATUS)
			     If SC1->C1_STATUS = 'B'.And.C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV = "L"
				     RecLock('SC1')
				     SC1->C1_STATUS := 'P'
				     MsUnLock()   
				  EndIf          	
				  If SC1->C1_STATUS = 'A'.And.C1_QUJE!=C1_QUANT
				     RecLock('SC1')
				     SC1->C1_STATUS := 'P'
				     MsUnLock()          					  
				  EndIf   
		EndCase
		SC1->(DbSkip())
	EndDo
EndIf

MATA110()

Return