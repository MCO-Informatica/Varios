#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA070TIT  �Autor  �Henio Brasil        � Data �  10/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para tratar o codigo de banco a ser usado    ���
���          �na baixa de Titulos a Receber - Botao de Confirmacao        ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificados                                      ���
�������������������������������������������������������������������������ͼ��
���Original  � Consiste informacoes importantes no Cadastro do Cliente    ���
���          �                                                            ���
���          � Data                     Analista Henio Brasil             ���
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Altera��es�Incluida nova valida��o quanto ao motivo de baixa conforme  ���
���          � OTRS Ticket#: 2008070110000443                             ���
���          � Data 01/07/2008          Analista Eduardo Ramos            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA070TIT() 
Local lReturn 	:= .t.   		
Local lOrigBco	:= If(Posicione("SA6", 1, xFilial("SA6")+cBanco+cAgencia+cConta, "A6_ORIGBCO")=='1', .t., .f.) 
Local usermot   := GetMV("MV_USERMOT") // parametro criado para controlar usu�rios com acesso ao motivo de baixa DACAO e CANCTO
/*
��������������������������������������������������������������Ŀ
�Consiste informacoes importantes no Cadastro do Cliente       �
����������������������������������������������������������������*/     
If cMotBx=="NORMAL" .And. (Left(cBanco,2) == 'CX' .Or. !lOrigBco) 
   MsgStop(" Atencao... Este banco "+cBanco+" n�o pode ser utilizado para baixar Titulos a Receber! ") 
   lReturn := .f.
Endif 


/*
��������������������������������������������������������������Ŀ
Valida��o da Descricao do motivo de baixa, que retorna do arrary 
aDescmotbx{} e compara o usu�rio atrav�s da variavel publica 
cUsername com o conteudo do parametro MV_USERMOT
����������������������������������������������������������������
*/     
If cMotBx=="DACAO" .OR. cMotBx=="CANCTO" .AND. usermot$cUsername 
   MsgStop(" O Motivo de Baixa "+cMotbx+" n�o pode ser utilizado pelo seu usu�rio! ") 
   lReturn := .f.
Endif 
                                   
/*
��������������������������������������������������������������Ŀ
Atualiza o campo hist�rico da baixa com o n�mero do PEDIDO GAR
A vari�vel cHist070 � private e ser� gravada no E1_HIST e E5_HISTOR
����������������������������������������������������������������
*/     
           

If !empty(SE1->E1_PEDGAR).OR. !EMPTY(SE1->E1_XNPSITE)  
             //1234567890123456789012345678901234567890//
	cHist070:="PEDGAR "+SE1->E1_PEDGAR + " NPSITE " + SE1->E1_XNPSITE 
Endif

Return(lReturn)         