#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                                   DBM SYSTEM S/C LTDA                                 ���
�����������������������������������������������������������������������������������������͹��
���Programa    �M520SF3 �Cancelamento de Nota Fiscal - Informa��o do motivo               ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Projeto/PL  �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Solicitante �05.03.08�Vanderleia                                                       ���
�����������������������������������������������������������������������������������������͹��
���Autor       �05.03.08�Almir Bandina                                                    ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �Nil                                                                       ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
User Function M520SF3()
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis da rotina                                                           �
//�������������������������������������������������������������������������������������������
Local oDlgExc
Local aAreaAtu	:= GetArea()
Local aButtons	:= {}
Local nOpcA		:= 0
Local cNota		:= SF3->F3_NFISCAL + "/" + SF3->F3_SERIE
Local cCliente	:= SF3->F3_CLIEFOR + "/" + SF3->F3_LOJA
Local cTpNota	:= If( SubStr( SF3->F3_CFO, 2, 3) $ "201/202", "D", "N" )
Local cNomCli	:= ""
Local cMotivo	:= CriaVar( "PA1_CODMOT", .F. )
Local cDesMot	:= CriaVar( "PA1_DESMOT", .F. )
If cTpNota == "D"
	cNomCli	:= GetAdvFVal( "SA2", "A2_NOME", xFilial( "SA2" ) + SF3->( F3_CLIEFOR + F3_LOJA ), 1, "" )
Else
	cNomCli	:= GetAdvFVal( "SA1", "A1_NOME", xFilial( "SA1" ) + SF3->( F3_CLIEFOR + F3_LOJA ), 1, "" )
EndIf
//�����������������������������������������������������������������������������������������Ŀ
//� Monta tela de interface com o usu�rio                                                   �
//�������������������������������������������������������������������������������������������
DEFINE FONT oFont NAME "Mono AS" SIZE 8,16 
DEFINE MSDIALOG oDlgExc FROM 000,000 TO 105,730 TITLE "Cancelamento de Nota Fiscal"				PIXEL

@ 020,005 SAY "N.Fiscal/S�rie:"										OF oDlgExc 					PIXEL COLOR CLR_HBLUE
@ 020,040 MSGET cNota												WHEN .F. ;
																	OF oDlgExc SIZE 050,006		PIXEL

@ 020,095 SAY "Cliente/Loja:"										OF oDlgExc 					PIXEL COLOR CLR_HBLUE
@ 020,130 MSGET cCliente											WHEN .F. ;
																	OF oDlgExc SIZE 050,006		PIXEL
@ 020,185 MSGET cNomCli												WHEN .F. ;
																	OF oDlgExc SIZE 160,006		PIXEL


@ 035,005 SAY "Motivo:"												OF oDlgExc 					PIXEL COLOR CLR_HBLUE
@ 035,040 MSGET cMotivo												WHEN .T. F3 "ZA" VALID( !Empty( cMotivo ) ) ;
																	OF oDlgExc SIZE 050,006		PIXEL
@ 035,095 MSGET cDesMot												WHEN .T. ;
																	OF oDlgExc SIZE 250,006		PIXEL

ACTIVATE MSDIALOG oDlgExc CENTERED ON INIT EnchoiceBar( oDlgExc, { || nOpcA := 1, oDlgExc:End() }, { || nOpcA := 1, oDlgExc:End() },, aButtons )
//�����������������������������������������������������������������������������������������Ŀ
//� Grava os dados                                                                          �
//�������������������������������������������������������������������������������������������
If nOpcA == 1
	dbSelectArea( "PA1" )
	dbSetOrder( 1 )
	RecLock( "PA1", .T. )
		PA1->PA1_FILIAL	:= xFilial( "PA1" )
		PA1->PA1_TIPO	:= "S"
		PA1->PA1_TPNOTA	:= cTpNota
		PA1->PA1_DOC	:= SF3->F3_NFISCAL
		PA1->PA1_SERIE	:= SF3->F3_SERIE
		PA1->PA1_CLIFOR	:= SF3->F3_CLIEFOR
		PA1->PA1_LOJA	:= SF3->F3_LOJA
		PA1->PA1_CODMOT	:= cMotivo
		PA1->PA1_DESMOT	:= cDesMot
		PA1->PA1_CODUSR	:= __cUserId
		PA1->PA1_DATUSR	:= MsDate()
		PA1->PA1_HORUSR	:= Time()
	MsUnLock()
EndIf

RestArea( aAreaAtu )

Return( Nil )
