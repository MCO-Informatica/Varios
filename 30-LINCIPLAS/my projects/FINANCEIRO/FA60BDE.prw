#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  ³FA60BDE_ATUALIZA TIT DO BODERO         ºAutor  Rogerio      º±±
±±ºData 	 ³  05/21/10   							 º					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Na transferencia para bordero verifica se o título ja teve º±±
±±º          ³ o boleto do Bradesco impresso - Venda Spider 			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PROTHEUS                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA60BDE()

ASE5		:= GETAREA()

//RECLOCK("SE1")


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡a¿
//³Verifico se o vencimento e o vencimento real sao a mesma data  ³
//³e somo a quantidade de dias entre eles e o campo no cadastro   ³
//³de bancos                                                                                                                                                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡aÙ
*/
/*
nPrzMedio	:= 0
dData    	:= DATAVALIDA(SE1->E1_VENCREA)
dDtBase  	:= dDatabase
aTitulos 	:= {}
*/
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡a¿
//³Não alimenta titulos cujo vencimento for menor que data base.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡aÙ
*/
/*
// REMOVIDO POR THIAGO - SUPERTECH EM 19/06/2013
WHILE !EOF() .AND. SE1->E1_PORTAD2 == "237"
	Aadd(aTitulos,{SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA})
	//SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
	//aTitulos[1]    := SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
	//aTitulos[2]    := SE1->E1_NUM
	//aTitulos[3]	:= SE1->E1_PARCELA

	DbSelectArea("SE1")
	DbSkip()
ENDDO
*/
/*
//	MSGBOX("Já foi impresso o boleto do bradesco para o título: " + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + " ")

@ 100,001 To 240,250 Dialog oDlg Title "Transferencia Bordero" 	// 100,001 To 340,350
@ 003,008 To 065,120											// 003,010 To 110,167
@ 013,014 Say OemToAnsi("Já foi impresso Boleto do BRADESCO")
@ 023,014 Say OemToAnsi("para os títulos:")
@ 033,014 Say SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA//aTitulos[i]
//@ 025,014 Get cAutent Picture "@E 999999999999999"
@ 045,085 BmpButton Type 01 Action Close(oDlg)					// @ 097,130

Activate Dialog oDlg Centered
*/

//MSUNLOCK()

RESTAREA(ASE5)
RETURN
