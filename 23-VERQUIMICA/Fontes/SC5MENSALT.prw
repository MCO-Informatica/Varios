#INCLUDE "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma ³ SC5MENSALT      ºAutor³ MCINFOTEC		             º Data ³ 2017	     º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Programa para atualizacao dos campos de Msg  na Notas					 º±±
±±º         | Volume e Transportadora no Pedido de Venda                             º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe  ³ U_SC5MENSALT()                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ 		                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SC5MENSALT()

	Local cMenNota	 := SC5->C5_MENNOTA
	Local cMenNot1	 := SC5->C5_MENNOT1
	Local cMenNot2	 := SC5->C5_MENNOT2
	Local cMenNot3	 := SC5->C5_MENNOT3
	Local oDlgMen

	While .T.

		@ 000,000 TO 500,600 DIALOG oDlgMen TITLE OemToAnsi("MENSAGENS DO PEDIDO DE VENDA - "+SC5->C5_NUM) 
		
		@ 010,010 Say OemToAnsi("Mensagem 1") Size 100,10
		@ 020,010 Get cMenNota  Picture "@!" Size 250,010 
	
		@ 040,010 Say OemToAnsi("Mensagem 2") Size 100,10
		@ 050,010 Get cMenNot1  Picture "@!" Size 250,010
	
		@ 070,010 Say OemToAnsi("Mensagem 3") Size 100,10
		@ 080,010 Get cMenNot2  Picture "@!" Size 250,010 
	
		@ 100,010 Say OemToAnsi("Mensagem 4") Size 100,10
		@ 110,010 Get cMenNot3  Picture "@!" Size 250,010
	
		@ 220,260 BMPBUTTON TYPE 1 ACTION Close(oDlgMen)
	
		ACTIVATE DIALOG oDlgMen CENTERED

		Exit

	End

	RecLock("SC5",.F.)
		SC5->C5_MENNOTA	:= cMenNota
		SC5->C5_MENNOT1	:= cMenNot1
		SC5->C5_MENNOT2	:= cMenNot2
		SC5->C5_MENNOT3	:= cMenNot3
	MsUnLock("SC5")

Return
