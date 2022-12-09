#INCLUDE"PROTHEUS.CH"

static cObserv := "" //Observacao registrado pelo usuario

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �TK510Fecha    � Autor � Vendas Clientes   � Data � 18/08/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao executada no encerramento da tela de atendimento.    |��
�������������������������������������������������������������������������Ĵ��
��� Uso      �TMKA271       	        						          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//Nao � um ponto de entrada, essa Funcao eh chamada pelo modelo de atendimento - warleson 10/08


User Function TK001Valid()
	
	//�������������������������������Ŀ
	//�Grava complemento do atendimento�
	//���������������������������������

	TK510GRVIT() //Funcao padrao

	//�������������������������������Ŀ
	//�Atualiza lista de atendimento �
	//���������������������������������

	U_AtuLista() //Funcao personalizada 
	
	//�������������������������������Ŀ
	//�Atualiza Obsevacao do chamado �
	//���������������������������������
	
	U_GravaMemo()// Funcao personalizada

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuLista �Autor  �Opvs(Warleson)       � Data �  18/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function AtuLista()

Local cLista
Local cDesc
Local cChave

Private lOperador // Usuario do tipo Operador?
Private cOpeLista // Possui permissao para baixar atendimento da Lista de Contato de outro operador?
Private nQtdLista // Quantidade de  atendimento a baixar da fila
Private _cOperad	:= ''
Private _cPosto		:= '' // Codigo do Grupo principal
Private lAchou 		:= .F.
Private aArea		:= GetArea()

	
	if funname()=='TMKA380' //Testa se a fun�ao atual/chamada pelo Menu � a agenda do operador('TMKA380')
	
		DbSelectArea("SU7")
		DbSetOrder(4)
		
		If MsSeek(xFilial("SU7")+__cUserId) // Posiciona e retorna o valor do U7_COD
			_cOperad	:= 	SU7->U7_COD
			_cPosto		:=  SU7->U7_POSTO
			lOperador	:=  SU7->U7_TIPO == '1' //1 = Operador, 2= Supervisor
			cOpeLista	:=  SU7->U7_XOPELIS
			nQtdLista  	:=  SU7->U7_XQTDLST
		EndIf
	
	RestArea(aArea)
	
	//�������������������������������������������������������������������Ŀ
	//� Verifica se ha outro analista manipulando o mesmo chamado      	  |
	//� So libera se o analista estiver ha mais de 2 horas alocado.    	  |
	//���������������������������������������������������������������������
	
	
		If lOperador .and. !empty(cOpeLista) .and. nQtdLista> 0
			
			//����������������������������������Ŀ
			//�Retorna o Item da Lista Temporaria�
			//�para a Lista Original             �
			//������������������������������������
			
			//Agenda do operador j� esta posicionado no SU4 e SU6 atual
			If !('ATENDIMENTO'$UPPER(SU4->U4_DESC )) // Caso n�o seja agendamento, entao continua grava��o.
				RecLock("SU6",.F.)
				Replace U6_LISTA   With	SUBSTRING(SU4->U4_DESC,1,6) // Codigo da Lista temporaria - Chave extrangeira(SU4)
				Replace U6_STATUS  With	'2'
				MsUnlock()
			Endif
			
			dbselectarea("SU4")
			DBORDERNICKNAME("BAIXA_FILA") // Filial+Lista+Status+Grupo
			If dbseek(xFilial('SU4')+cOpeLista+'3'+_cPosto) // Posiciona no cabecalho da Lista principal/Em andamento
				lAchou := .T.
			Elseif dbseek(xFilial('SU4')+cOpeLista+'1'+_cPosto) // Posiciona no cabecalho da Lista principal/Pendente
				lAchou := .T.
			Else
				lAchou := .F.
			Endif
			
			If lAchou
				cLista		:= SU4->U4_LISTA
				cDesc 		:= SU4->U4_DESC
				cChave		:= cLista+' '+cDesc
				
				dbselectarea('SU6')
				DBORDERNICKNAME("ITEMLISTA") // Filial+Lista+Status
				if !(dbseek(xFilial('SU6')+cLista+'1')) // Posiciona no intem da Lista principal/Pendente
					
					//����������������������������������������Ŀ
					//�Caso nao tenha mais chamados para baixar�
					//�Ent�o encerra a Lista principal.         �
					//������������������������������������������
					
					RecLock("SU4",.F.)
					Replace U4_STATUS   With '2' //Status Encerrado
					MsUnlock()
					
					//������������������������Ĥ �
					//�Apaga a lista temporaria�
					//������������������������Ĥ �
					
					dbselectarea("SU4")
					DBORDERNICKNAME("CABECLISTA") // Filial+Operador+Desc_da_lista
					If dbseek(xFilial('SU4')+_cOperad+cChave) //Verica se Existe Lista temporaria para o Operador Ativo
						Msgalert('Atividade encerrada'+CRLF+'Lista: '+SU4->U4_LISTA+'/'+cChave+CRLF+'Favor selecionar uma nova lista!')
						RecLock("SU4",.F.)
						Replace U4_DESC     With alltrim(cChave)+' (Lista temporaria)'
						Replace U4_STATUS   With '2' //Status Encerrado
						SU4->(dbDelete())
						MsUnlock()
					Endif
				Endif
			Endif
			
			//������������������������������������������������������Ŀ
			//�a) Testa ponto de Entrada que contem o tratamento para�
			//�Buscar um novo testeatendimento                       �
			//�b) Busca um novo atendimento                          �
			//��������������������������������������������������������
			
			If ExistBlock("TK380DAT")
				Execblock("TK380DAT",.F.,.F.,{})
				Processa({|lEnd|Tk380CFG(SU4->U4_LISTA,oGetDados:aHeader,oGetDados:aCols,'',.F.)},"Selecionando Itens da Lista...",,.T.)
				oGetDados:Refresh(.T.)
			Endif
			
			RestArea(aArea)
			
		Endif
	Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK500INC �Autor�Opvs(Warleson Fernandes)� Data �  19/02/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua Manuten��o no campo de Observacao (Tipo:Memo)       ���
���          �  														  ���
�������������������������������������������������������������������������͹��
���Uso       � CERTISIGN - SERVICE DESK                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
Aplica-se em caso de inclus�o e altera��o, pois nao se exclui atendimentos do Service Desk
*/

User function GravaMemo 

local aArea:= GetArea()
		
		//����������������������Ŀ
		//�Grava campo observa��o�
		//������������������������

		If !Empty(ADE->ADE_OBSCOD) 
		
			MSMM(ADE->ADE_OBSCOD,TamSx3("ADE_OBSERV")[1],,cObserv,1,,,"ADE","ADE_OBSCOD")		
		Else
			DbSelectArea("ADE")
			DbSetOrder(1)
			If MsSeek(xFilial("ADE")+ADE->ADE_CODIGO)

				BEGIN TRANSACTION
					RecLock("ADE", .F.) 
					MSMM(,TamSx3("ADE_OBSERV")[1],,cObserv,1,,,"ADE","ADE_OBSCOD")	        
					MsUnlock()
				END TRANSACTION	
			EndIf 
		EndIf        
		cObserv := ""  
		RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSDK18 �Autor  �Opvs(Warleson)        � Data �  02/20/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa antes da gravacao do chamado                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function CTSDK18()

	cObserv := M->ADE_OBSERV

	TK510BGRVIT() //FUNCAO PADRAO
Return
