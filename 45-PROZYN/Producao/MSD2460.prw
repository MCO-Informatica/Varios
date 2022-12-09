#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSD2460  �Autor  �Daniel Paulo        � Data �  13/ 03 / 18���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na gera��o da nota fiscal de saida        ���
���          � para preenchimento dos campos de amarra��o da opera��o     ���
���          � Triangular                                                 ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Prozyn                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MSD2460      

Local CR          := Chr(13)+Chr(10)           

aArea := GetArea()

IF SD2->D2_CF = '5924' .OR. SD2->D2_CF= '6924'
			
			dbSelectArea('SC6')
			dbSetOrder(1)
			DbSeek(xFilial("SC6")+SD2->(D2_PEDIDO+D2_ITEMPV))      
			
			
			// GRAVA AMARRA��O DA NF FAT TRIANGULAR NO ITEM DA NF DE REMESSA TRIANGULAR
			
			dbSelectArea('SD2')
			RecLock("SD2",.F.) //Bloqueia o registro no item e .F.=atualiza, .T. = Append
			
			SD2->D2_XNFVEN    := SC6->C6_XNFVEN // NF FATURAMENTO TRIANGULAR
			SD2->D2_XNFVITE	  := SC6->C6_XNFITE // ITEM PRODUTO FAT TRIAGULAR
			
			MsUnlock() 
			
			_cNfven = SD2->D2_DOC
			_cnfitem = SD2->D2_ITEM
			
			// GRAVA AMARRA��O DA NF DE REMESSA TRIANGULAR NO ITEM DA NF FAT TRIANGULAR
			
			
				 cQuery2	:=" SELECT D2_XNFVEN,D2_XNFVITE, R_E_C_N_O_ as RECSD2 FROM " + RetSqlName("SD2") + " D2  " + CR
				 cQuery2	+=" WHERE D2_DOC = '"+SC6->C6_XNFVEN+"' AND D2_COD = '"+SD2->D2_COD+"' AND D2_ITEM = '"+SC6->C6_XNFITE+"' " + CR  
			
				If Select("QRY2") > 0
			       QRY2->( dbCloseArea() )
				EndIf
			
				dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), "QRY2", .F., .F. ) /// Abre a conexao
			
				If Select("QRY2") > 0
				   dbSelectArea("SD2")
				   dbSetOrder(1)      
					QRY2->( dbGoTop() )
					While QRY2->( !Eof() )
				    			SD2->(DbGoTo(QRY2->RECSD2))	
						    	RecLock("SD2",.F.) 
								SD2->D2_XNFVEN:=  _cNfven
								SD2->D2_XNFVITE:= _cnfitem
			     			   	msunlock()
					QRY2->( dbSkip() )
					Enddo		
			  	Endif
			RestArea(aArea)   
Endif

Return
