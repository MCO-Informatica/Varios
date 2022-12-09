#INCLUDE 'PROTHEUS.CH'  
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TBICONN.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �TK271ROTM � Autor � Mateus                � Data �10/03/2014���
�������������������������������������������������������������������������Ĵ��
���Locacao   � Metalacre        �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para adicionar um novo botao de rotina na ���        
���          � lista de acoes relacionadas da tela de Atendimento do Call ���        
���          � Center.  Este botao vai chamar a rotina METEC05, onde vai  ���        
���          � ser exibido o MBrowser da SUA, com a opcao de Copiar.      ���        
�������������������������������������������������������������������������Ĵ��
���Uso       � Rotina Padrao TMKA271                                      ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���Adalberto Neto�11/03/14�Inclusao da funcao que vai alterar as cores das���
���              �        �legendas existente. Inclusao da funcao de legen���
���              �        �da, para mostrar essas novas cores e um novo   ���
���              �        �aRotinas, com as opcoes padrao do Televendas,  ���
���              �        �exceto o botao de alterar.                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function TK271ROTM()

Local aRotAdic := {}

aAdd( aRotAdic, { 'TELEVENDAS' ,'U_METEC05()', 0 , 1 })

Return aRotAdic 





/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �METEC05   � Autor � Adalberto Mendes Neto � Data �11/03/2014���
�������������������������������������������������������������������������Ĵ��
���Locacao   � Metalacre        �Contato �adalberto.neto@totvs.com.br     ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para alterar as cores das legendas e inclusao dos   ���        
���          � botoes nas acoes relacionadas.                             ���        
�������������������������������������������������������������������������Ĵ��
���Uso       � TK271ROTM                                                  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function METEC05() 

Local cFilSQL  	:= Nil

Private aCores2	:= {{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC))" 	, "BR_VERDE"   	},;// Faturamento - VERDE
					{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. !Empty(SUA->UA_DOC))"	, "BR_VERMELHO"	},;// Faturado - VERMELHO
   					{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 2)"							, "BR_AZUL"   	},;// Orcamento - AZUL
   					{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 3)"							, "BR_MARRON"	},;// Atendimento - MARRON
   					{"(!EMPTY(SUA->UA_CODCANC))"														,"BR_PRETO"		}} // Cancelado
   					
aCores2 := U_ATUACORES()
   						
aRotina	:= {{ "Pesquisar"  	,"AxPesqui"        	,0,1 },; 	// "Pesquisar"
			{ "Visualizar"	,"TK271CallCenter" 	,0,2 },; 	// "Visualizar"
			{ "Incluir"  	,"TK271CallCenter" 	,0,3 },; 	// "Incluir"
			{ "Legenda" 	,"U_MeLegen()"	   	,0,2 },; 	// "Legenda"
			{ "Copiar"  	,"TK271Copia"	  	,0,6 },; 	// "Copiar"   						
			{ "Ver Pedido" 	,"U_VerPed()"		 ,0,7},; 	// "Ver Pedido de Vendas"   						
			{ "Imp Orcamento","U_RFAT100X()"		 ,0,8}} 	// "Imprime Or�amento"   						
			

MBrowse(,,,,"SUA",,,,,,aCores2,,,,,,,,cFilSQL)

Return 



/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ATUACORES � Autor � Mateus                � Data �10/03/2014���
�������������������������������������������������������������������������Ĵ��
���Locacao   � Metalacre        �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para alterar as cores das legendas.                 ���        
�������������������������������������������������������������������������Ĵ��
���Uso       � METEC05                                                    ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function ATUACORES()    

Local aArea  := GetArea()
Local aVetor := {}      
local alegend:= {} 

PROCESSA({||U_ATULEGEN()},"Aguarde", "Atualizando Legendas...")

aadd(aVetor,{"UA_STATUS == 'NF.' .And. UA_OPER == '1' .And. UA_CANC <> 'S'"  					   	,"BR_VERMELHO"}) // CRIAR O CAMPO UA_NOTAFIS NA PRODUCAO  
aadd(aVetor,{"UA_OPER == '3' .AND. UA_CANC <> 'S'" 	   					   						   	,"BR_VIOLETA"}) 
aadd(aVetor,{"UA_OPER == '2' .AND. UA_CANC <> 'S'"   					   						   	,"BR_AZUL"}) 
aadd(aVetor,{"UA_STATUS $ 'LIB*SUP' .And. UA_LIBERA == 'S' .AND. UA_CANC <> 'S' .AND. UA_TEMOP <> 'X' .AND. UA_TEMOP <>'S'"    	,"BR_AMARELO"})   // CRIAR O CAMPO UA_LIBERA NA PRODUCAO 
aadd(aVetor,{"UA_LIBERA <> 'S' .AND. UA_CANC <> 'S'"						   					   	,"BR_VERDE"})  
aadd(aVetor,{"UA_CANC == 'S'" 						  					   					   	 	,"BR_PRETO"}) 
aadd(aVetor,{"UA_TEMOP =='S' .AND. UA_CANC <> 'S'"						  						 	,"BR_PINK"}) 
aadd(aVetor,{"UA_TEMOP == 'X' .AND. UA_CANC <> 'S'"   					   						 	,"BR_LARANJA"})  // CRIAR O CAMPO UA_BLCRED NA PRODUCAO   

Return aVetor  
                           	
User Function ATULEGEN() 

CQRYG := " UPDATE "+RETSQLNAME("SUA") 
CQRYG += " SET UA_LIBERA = C5_LIBEROK,"
CQRYG += " UA_TEMOP = C5_TEMOP"  		 // ATUALIZA O CAMPO PRA MUDAR A LEGENDA PRA PINK - OP GERADA
CQRYG += " FROM "+RETSQLNAME("SC5")+" SC5" 
cQRYG += " INNER JOIN "+RETSQLNAME("SUA")+" SUA"
cQRYG += " ON UA_FILIAL = C5_FILIAL AND UA_NUMSC5 = C5_NUM" 
CQRYG += " WHERE UA_CANC <> 'S'"
//CQRYG += " AND (UA_TEMOP <> C5_TEMOP "  		 // aTUALIZA S� SE ESTIVER DIFERENTE NAO TODOS COMO ANTES
//CQRYG += " OR UA_LIBERA = C5_LIBEROK)"
CQRYG += " AND SC5.D_E_L_E_T_ ='' " 
CQRYG += " AND SUA.D_E_L_E_T_ ='' " 

TcSqlExec(cQRYG) 


CQRYG1 := " UPDATE "+RETSQLNAME("SUA") 
CQRYG1 += " SET UA_BLCRED = ISNULL(C9_BLCRED,'') " 
CQRYG1 += " FROM "+RETSQLNAME("SC9")+" SC9" 
cQRYG1 += " RIGHT JOIN "+RETSQLNAME("SUA")+" SUA"
cQRYG1 += " ON UA_FILIAL = C9_FILIAL AND UA_NUMSC5 = C9_PEDIDO" 
CQRYG1 += " AND UA_BLCRED <> C9_BLCRED " 
CQRYG1 += " AND SC9.D_E_L_E_T_ ='' " 
CQRYG1 += " AND SUA.D_E_L_E_T_ ='' " 

TcSqlExec(cQRYG1)

// QUERY QUE ATUALIZA O CAMPO DO NUMERO E ITEM DA OP TRAZENDO DA SC5 PARA SUB - AJUSTE FEITO EM 07/04/14 - MATEUS HENGLE
CQRYG7 := " UPDATE "+RETSQLNAME("SUB") 
CQRYG7 += " SET UB_NUMOP = C6_NUMOP, UB_ITEMOP = C6_ITEMOP" 
CQRYG7 += " FROM "+RETSQLNAME("SC6")+" SC6" 
cQRYG7 += " RIGHT JOIN "+RETSQLNAME("SUB")+" SUB"
cQRYG7 += " ON UB_FILIAL = C6_FILIAL AND UB_NUMPV = C6_NUM AND UB_ITEM = C6_ITEM" 
CQRYG7 += " WHERE SC6.D_E_L_E_T_ ='' " 
CQRYG7 += " AND SUB.UB_NUMOP <> C6_NUMOP " 
CQRYG7 += " AND SUB.D_E_L_E_T_ ='' " 

TcSqlExec(cQRYG7)


Return
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MeLegen   � Autor � Adalberto Mendes Neto � Data �11/03/2014���
�������������������������������������������������������������������������Ĵ��
���Locacao   � Metalacre        �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para exibir as legendas existentes.                 ���        
�������������������������������������������������������������������������Ĵ��
���Uso       � METEC05                                                    ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MeLegen()

BrwLegenda(cCadastro,"Legenda",{{"BR_VIOLETA" 	, "Atendimento"			},;
								{"BR_AZUL"		, "Orcamento"			},;
								{"BR_AMARELO" 	, "Pedido Liberado"		},; 
								{"BR_VERDE" 	, "Pedido Bloqueado"	},;
								{"BR_VERMELHO"	, "NF. Emitida"			},; 
								{"BR_PRETO" 	, "Cancelado"			},;
								{"BR_PINK"		, "OP Gerada"			},;    
								{"BR_LARANJA"	, "Bloqueado Credito"	}})  
																			
Return(.T.)        



User Function VerPed()
Local aArea := GetArea()
Local cNumPed := SUA->UA_NUMSC5

If Empty(cNumPed)
	Alert("Aten��o, Pedido de Venda ainda N�o Gerado Neste Atendimento !")
	RestArea(aArea)
	Return .f.     
Endif

If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNumPed))

	DbSelectArea("SC5") ; DbSetOrder(1)
	A410Visual( Alias() , SC5->(Recno()) , 2 ) //Visualiza��o do pedido de vendas
Else
	Alert("Pedido de Venda " + cNumPed + " N�o Localizado !!!")
Endif
RestArea(aArea)
Return .t.
