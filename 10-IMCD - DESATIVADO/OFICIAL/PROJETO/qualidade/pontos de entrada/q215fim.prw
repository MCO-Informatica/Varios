#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Q215FIM  � Autor �  Daniel   Gondran  � Data �  27/08/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar a data de fabricacao do lote  ���
���          � na liberacao do CQ                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Q215FIM
	Local _aArea := GetArea()
	Local nIndice 

	Local _aAreaSB8 	:= SB8->(GetArea())	//Adicionado para tratar data de fabrica��o do lote na tabela SB8

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "Q215FIM" , __cUserID )

	dbSelectArea("SD3")                   
	nIndice := SD3->( IndexOrd() )
	dbSetOrder(2)                                                            
	dbSeek(xFilial("SD3") + SD7->D7_NUMERO + "   " + SD7->D7_PRODUTO)
	do While !Eof() .and. SD3->D3_FILIAL + SD3->D3_DOC + SD3->D3_COD == xFilial("SD3") + SD7->D7_NUMERO + "   " + SD7->D7_PRODUTO
		If SD3->D3_LOTECTL == SD7->D7_LOTECTL
			RecLock("SD3",.F.)
			SD3->D3_DTFABRI := SD7->D7_DTFABRI
			msUnlock()
		Endif
		dbSkip()
	Enddo    
	//Tratamento da data de fabrica��o do lote na tabela SB8 

	dbSelectArea("SB8")                   
	dbSetOrder(5)                                                            
	dbSeek(xFilial( "SB8" )+SD7->D7_PRODUTO+SD7->D7_LOTECTL)
	do While !Eof() .and. SB8->B8_FILIAL+SB8->B8_PRODUTO == xFilial("SD8")+SD7->D7_PRODUTO
		If SB8->B8_LOTECTL == SD7->D7_LOTECTL .AND. ALLTRIM(SB8->B8_DOC) == SD7->D7_NUMERO
			RecLock("SB8",.F.)                                          
			SB8->B8_DFABRIC := SD7->D7_DTFABRI
			msUnlock()
		Endif
		dbSkip()
	Enddo  


	SD3->(dbSetOrder(nIndice))
	RestArea(_aArea)    
	RestArea(_aAreaSB8)
Return
