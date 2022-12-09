#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͺ��
���Programa  �FA60BDE_ATUALIZA TIT DO BODERO         �Autor  Rogerio      ���
���Data 	 �  05/21/10   												  ���
�������������������������������������������������������������������������͹��
���Desc.     � Na transferencia para bordero verifica se o t�tulo ja teve ���
���          � o boleto do Bradesco impresso - Venda Spider 		  ���
�������������������������������������������������������������������������͹��
���Uso       � PROTHEUS                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA60BDE()

ASE5		:= GETAREA()

RECLOCK("SE1")


/*
//�������������������������������������������������������������ća�
//�Verifico se o vencimento e o vencimento real sao a mesma data  �
//�e somo a quantidade de dias entre eles e o campo no cadastro   �
//�de bancos                                                                                                                                                                                                   �
//�������������������������������������������������������������ća�
*/
nPrzMedio	:= 0
dData    	:= DATAVALIDA(SE1->E1_VENCREA)
dDtBase  	:= dDatabase
aTitulos 	:= {}

/*
//�������������������������������������������������������������ća�
//�N�o alimenta titulos cujo vencimento for menor que data base.  �
//�������������������������������������������������������������ća�
*/

WHILE !EOF() .AND. SE1->E1_PORTAD2 == "237"
	Aadd(aTitulos,{SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA})
	//SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
	//aTitulos[1]    := SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
	//aTitulos[2]    := SE1->E1_NUM
	//aTitulos[3]	:= SE1->E1_PARCELA

	DbSelectArea("SE1")
	DbSkip()
ENDDO

//	MSGBOX("J� foi impresso o boleto do bradesco para o t�tulo: " + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + " ")

@ 100,001 To 240,250 Dialog oDlg Title "Transferencia Bordero" 	// 100,001 To 340,350
@ 003,008 To 065,120											// 003,010 To 110,167
@ 013,014 Say OemToAnsi("J� foi impresso Boleto do BRADESCO")
@ 023,014 Say OemToAnsi("para os t�tulos:")
@ 033,014 Say SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA//aTitulos[i]
//@ 025,014 Get cAutent Picture "@E 999999999999999"
@ 045,085 BmpButton Type 01 Action Close(oDlg)					// @ 097,130

Activate Dialog oDlg Centered

//ENDIF

MSUNLOCK()

RESTAREA(ASE5)
RETURN
