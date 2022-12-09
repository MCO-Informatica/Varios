#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º                                   DBM SYSTEM S/C LTDA                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma    ³M520SF3 ³Cancelamento de Nota Fiscal - Informação do motivo               º±±
±±º            ³        ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºProjeto/PL  ³                                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSolicitante ³05.03.08³Vanderleia                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAutor       ³05.03.08³Almir Bandina                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros  ³Nil                                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno     ³Nil.                                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservações ³                                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterações  ³ 99.99.99 - Consultor - Descrição da Alteração                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M520SF3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as variáveis da rotina                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta tela de interface com o usuário                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFont NAME "Mono AS" SIZE 8,16 
DEFINE MSDIALOG oDlgExc FROM 000,000 TO 105,730 TITLE "Cancelamento de Nota Fiscal"				PIXEL

@ 020,005 SAY "N.Fiscal/Série:"										OF oDlgExc 					PIXEL COLOR CLR_HBLUE
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava os dados                                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
