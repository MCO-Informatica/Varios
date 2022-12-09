#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � FT300BUT   � Autor � Derik Santos        � Data � 23/08/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Adiciona bot�o na rotina de oportunidade de venda do modulo��� 
���Desc.     � CRM                                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
                                                                                                 		
User Function FT300BUT()

Local aButtons := {}                                            

aAdd( aButtons,{"Forecast","", {|| U_RCRME001(M->AD1_CODCLI,M->AD1_LOJCLI,M->AD1_CODPRO)},"ViewAltera",,})
//Inibe a tecla de atalho para prevenir duplicidade da abertura da janela
//SetKey(VK_F5,{||     })
//SetKey(VK_F5,{|| U_RCRME001(M->AD1_CODCLI,M->AD1_LOJCLI,M->AD1_CODPRO)  })

Return( aButtons )