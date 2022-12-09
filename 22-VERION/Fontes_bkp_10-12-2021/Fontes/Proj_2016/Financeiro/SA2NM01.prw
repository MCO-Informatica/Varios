#Include "Rwmake.ch"                                                    
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+------------+---------+--------+-----------------+-------+------------+
| Programa:  | SA2NM01 | Autor: | Silv�rio Bastos | Data: | Junho/2010 |
+------------+---------+--------+-----------------+-------+------------+
| Descri��o: | SE2 E SE5 - ACERTO DA NATUREZA ATRAVES DO SA2           |
+------------+---------------------------------------------------------+              
| Uso:       | Verion �leo Hidr�ulica Ltda.                            |
+------------+---------------------------------------------------------+
*/

User Function SA2NM01()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local aArea:=GetArea()

dbSelectArea("SE2")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 000,000 TO 160,550 DIALOG oSa2Ok TITLE "Acerto das Naturezas Financeiras no SE2 e SE5"
@ 045,117 BMPBUTTON TYPE 01 ACTION OkSa2Ok()
@ 045,145 BMPBUTTON TYPE 02 ACTION Close(oSa2Ok)

Activate Dialog oSa2Ok Centered

RestArea(aArea)

Return .f.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKSa2Ok  � Autor � AP6 IDE            � Data �  23/03/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkSa2Ok

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  23/03/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

DbSelectArea("SE2")
dbSetOrder(1)

DbGoTop()

Do While SE2->(!Eof())
       
      xNatureza := space(10)
      DbSelectArea("SA2")
	   If DbSeek(xFilial("SA2") + SE2->E2_FORNECE+SE2->E2_LOJA,.F.)
	   
	   		xNatureza := SA2->A2_NATUREZ
	   		xPesqSE2  := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
	   		
       DbSelectArea("SED")
       If DbSeek(xFilial("SED") + xNatureza,.F.)
	   	If !Empty(xNatureza)
	   		WHile !RecLock("SE2",.f.)
	   		Enddo
	   		SE2->E2_NATUREZ := xNatureza
		   	MsUnLock()
				
				DbSelectArea("SE5")
				dbSetOrder(7)
				If DbSeek(xFilial("SE5") + xPesqSE2 ,.F.)
		   			WHile !RecLock("SE5",.f.)
		   			Enddo
	   				SE5->E5_NATUREZ := xNatureza
		   			MsUnLock()
				Endif	
		    Endif
       Endif
       Endif

       SE2->(dbSkip())

Enddo

//���������������������������������������������������������������������Ŀ
//� Fechando o dialogo criado na funcao anterior.                       �
//�����������������������������������������������������������������������

Close(oSa2Ok)

Alert(" Termino do Processo !!! ")

Return .f.                        

