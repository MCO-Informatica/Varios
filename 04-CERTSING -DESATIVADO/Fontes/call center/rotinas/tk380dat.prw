/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK380DAT  �Autor  �Opvs(Warleson)      � Data �  07/26/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Atualiza status da Lista de Atendimento                   ���
���          �  Baixa nova Lista para atendimento                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//���������������������������������������������������������������������������������Ŀ
//�Par�metro MV_CSVVENC                                                             �
//�recebe a quantidade de dias para vencimento da Lista, antes da data de expira��o.�
//�����������������������������������������������������������������������������������

User function TK380DAT

Local dData
Local cLista
Local cDesc
Local cChave
Local cNovaLista
Local nSaveSx8
Local _cFilial 
Local _dData 	 
Local _cForma  
Local _cTele 	 
Local _cTipoTel 
Local _cCodlig  
Local _cStatus  
Local _cTipo 	 
Local _cHora1  
Local aArea			:= GetArea()
Local nCont

Private _cOperad	:= ''
Private lOperador // Usuario do tipo Operador?
Private cOpeLista // Possui permissao para baixar atendimento da Lista de Contato de outro operador?
Private nQtdLista // Quantidade de  atendimento a baixar da fila
Private nQtdVenc   // Quantidade de dias Antes da Expira��o para encerrar uma Lista de atendimento

	if !(type('ParamIXB[1]')=='U')
		dData 		:= ParamIXB[1]
	Endif
		
	DbSelectArea("SU7")
	DbSetOrder(4)
	
	If MsSeek(xFilial("SU7")+__cUserId) // Posiciona e retorna o valor do U7_COD
		_cOperad	:= 	SU7->U7_COD
		_cPosto		:=  SU7->U7_POSTO
		lOperador	:=  SU7->U7_TIPO == '1' //1 = Operador, 2= Supervisor
		cOpeLista	:=  SU7->U7_XOPELIS
		nQtdLista  	:=  SU7->U7_XQTDLST    
		nQtdVenc    :=  SuperGetMv("MV_CSVVENC",,0)	
	Else
		Alert('Falha no Cadastro do Operador '+__cUserId)
		Return dData
	EndIf
 		
	RestArea(aArea)
	                            
	If lOperador .and. !empty(cOpeLista) .and. nQtdLista> 0
		dbselectarea("SU4")
		DBORDERNICKNAME("BAIXA_FILA") // Filial+Lista+Status+Grupo
		If dbseek(xFilial('SU4')+cOpeLista+'3'+_cPosto) // Posiciona no cabecalho da Lista principal/Em andamento
			lAchou := .T.
		Elseif dbseek(xFilial('SU4')+cOpeLista+'1'+_cPosto) // Posiciona no cabecalho da Lista principal/Pendentes
			lAchou := .T.				
		Else
			lAchou := .F.							
		Endif

		//�����������������������������x�[�
		//�Baixar Atendimentos apenas    �
		//�quando a database for maior ou �
		//�igual a data de agendamento	 �
		//�����������������������������x�[�

		If lAchou .and. (dDataBase >= SU4->U4_DATA) 
			
			cLista		:= SU4->U4_LISTA
			cDesc 		:= SU4->U4_DESC
			cChave		:= cLista+' '+cDesc
			
			_cFilial	:= SU4->U4_FILIAL
			_dData 		:= SU4->U4_DATA
			_cForma 	:= SU4->U4_FORMA  
			_cTele 		:= SU4->U4_TELE
			_cTipoTel	:= SU4->U4_TIPOTEL  
			_cCodlig 	:= SU4->U4_CODLIG   
			_cStatus 	:= SU4->U4_STATUS   
			_cTipo 		:= SU4->U4_TIPO	 
			_cHora1 	:= SU4->U4_HORA1
							
			//��������������������������������P�P��
			//�Testar se a lista est� expirada�
			//��������������������������������P�P��

			If (SU4->U4_XDTVENC-dDataBase) < nQtdVenc
				RecLock("SU4",.F.)
				Replace U4_DESC     With alltrim(cDesc)+' (Expirado)'
				Replace U4_STATUS   With '2' //Status Encerrado
				MsUnlock()			
				
				aArea := GetArea()				
				
				Limpa_Lista(cChave) // Se lista principal for encerrada,ent�o limpa a lista temporaria dos operadores
				
				RestArea(aArea)				
				
				//Chamada recursiva - para baixa atendimento de uma nova lista
				If ExistBlock("TK380DAT")
					Execblock("TK380DAT",.F.,.F.,{})
				Endif
				
				Return dData //Encerra o programa
			Endif
			
			RecLock("SU4",.F.)	
			Replace U4_STATUS   With "3" // Em andamento
			MsUnlock()		
			
			dbselectarea('SU6') 
			DBORDERNICKNAME("ITEMLISTA") // Filial+Lista+Status
			if dbseek(xFilial('SU6')+cLista+'1') // Posiciona no intem da Lista principal/Pendente
	        	
	        	aArea:= GetArea()
				dbselectarea("SU4")		
				DBORDERNICKNAME("CABECLISTA") // Filial+Operador+Desc_da_lista
				If !(dbseek(xFilial('SU4')+_cOperad+cChave)) //Verica se Existe Lista temporaria para o Operador Ativo		 
		
					//�������������������������������������������Ŀ
					//�Cria lista temporaria para o operador atual�
					//���������������������������������������������
		
					RestArea(aArea)
					
					nSaveSx8 	:= GetSX8Len()  // Funcao de numeracao
					cNovaLista	:= GetSXENum("SU4","U4_LISTA")
	
					RecLock("SU4",.T.)	
					Replace U4_FILIAL   With _cFilial
					Replace U4_LISTA    With cNovaLista 	// Codigo da lista temporaria          
					Replace U4_DESC		With cChave 		// Descricao da Lista temporaria
					Replace U4_DATA		With _dData
					Replace U4_FORMA	With _cForma
					Replace U4_TELE		With _cTele
					Replace U4_OPERAD	With _cOperad		// Operador atual
					Replace U4_TIPOTEL	With _cTipoTel
					Replace U4_CODLIG   With _cCodlig
					Replace U4_STATUS   With _cStatus
					Replace U4_TIPO		With _cTipo
					Replace U4_HORA1    With _cHora1
					MsUnlock()
				
					DbSelectarea("SU4")
					While (GetSx8Len() > nSaveSx8)
						ConfirmSX8()
					End            
				
				Else
					cNovaLista := SU4->U4_LISTA 
					RecLock("SU4",.F.)	            
					
					Replace U4_STATUS   With "3" // Em andamento
					MsUnlock()
				Endif	
	
				aArea:= GetArea()
				dbselectarea('SU6') 
				DBORDERNICKNAME("ITEMLISTA") // Filial+Lista+Status
				if !(dbseek(xFilial('SU6')+cNovaLista+'1')) // Posiciona no intem da Lista temporaria/Pendente
	           		For nCont:=1 to nQtdLista 
		           		if dbseek(xFilial('SU6')+cLista+'1') // Posiciona no intem da Lista principal/Pendente
				            RecLock("SU6",.F.)
							Replace U6_LISTA   With	cNovaLista // Codigo da Lista temporaria - Chave extrangeira(SU4)
							MsUnlock()
		             	Endif
	   			    Next
	   			Endif
				
				RestArea(aArea)
		    Endif
		Endif
    Endif
Return dData

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Limpa_Lista �Autor  � Opvs(Warleson)   � Data �  07/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao responsavel por encerrar a lista temporaria dos     ���
���          � operadores, quando a lista Original estiver expirada       ���
�������������������������������������������������������������������������͹��
���Uso       � CERTISIGN                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Limpa_Lista(cChave)

Local _cLista
Local _cDesc
	dbselectarea('SU4')
	dbsetorder(2) // Filial+Descricao
	If dbseek(XFilial('SU4')+cChave)
		
		_cLista := SU4->U4_LISTA
		
		RecLock("SU4",.F.)
		Replace U4_DESC     With alltrim(cChave)+' (Lista temporaria)'
		Replace U4_STATUS   With '2' //Status Encerrado
		SU4->(dbDelete())
		MsUnlock()	
		
		//����������������������������������Ŀ
		//�Retorna o Item da Lista Temporaria�
		//�para a Lista Original             �
		//������������������������������������
		dbselectarea('SU6')	
		If dbseek(xFilial('SU6')+_cLista+'1') // Posiciona no intem da Lista temporaria/Pendente
			While !SU6->(Eof()) .AND. _cLista == SU6->U6_LISTA
				RecLock("SU6",.F.)
				Replace U6_LISTA   With	SUBSTRING(_cDesc,1,6) // Codigo da Lista temporaria - Chave extrangeira(SU4)
				Replace U6_STATUS  With	'2'
				MsUnlock()
				SU6->(dbskip())
			Enddo
		Endif
	  
		Limpa_Lista(cChave)	// Chamada recursiva - para encerra lista temporaria dos operadores
	Endif

Return