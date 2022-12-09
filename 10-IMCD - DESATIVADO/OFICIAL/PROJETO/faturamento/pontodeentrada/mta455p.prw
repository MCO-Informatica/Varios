#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA455P  � Autor �  Daniel   Gondran  � Data �  10/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para validar conforme tolerancia gravada  ���
���          � em parametro a quantidade na libera��o manual de estoque.  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico MAKENI / faturamento/liberacao estoque manual   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MTA455P()    
	Local nToler 	:= GetMV("MV_TOLLIBE")
	Local lRet		:= .T.   
if cEmpant <> "02"     

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA455P" , __cUserID )

	If Type("nQtdNew") <> "U" .AND. 'GRANEL' $ Posicione("SB1",1,xFilial("SB1") + SC9->C9_PRODUTO,"B1_DESC")
		if Abs(SC9->C9_QTDLIB - nQtdNew) > SC9->C9_QTDLIB * (nToler / 100)
			Alert("Quantidade digitada excede tolerancia ( " + Transform(nToler,"@E 999.99") + " )")
			lRet := .F.
		endif
	Endif   
	
	If lRet .and. Type("SB8->B8_PRODUTO") <> "U"                 
		If SB8->B8_PRODUTO == SC9->C9_PRODUTO
			U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,'Liberacao Est.Manual', , SC9->C9_ITEM )     
		Endif	
	Endif
			
endif

Return lRet