#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MA440COR  ³ Autor ³ Eneovaldo Roveri Juni ³ Data ³18/11/2009³±±
±±³Descrição ³adicionar cor ao status do pedido: Cancelado e Reprovado    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MA440COR()
	Local aCores := {}
	local lExcept := cEmpAnt == '02'

	if type( "PARAMIXB" ) == "A"
		aCores := PARAMIXB
	endif

	Aadd(aCores,{})
	Ains(aCores,1)
	aCores[1] := { "C5_X_REP == 'R' .AND. empty(C5_CONTRA)","BR_PINK","Reprovado"}

	Aadd(aCores,{})
	Ains(aCores,1)
	aCores[1] := { "C5_X_CANC == 'C'","BR_CINZA","Cancelado"}  

	Aadd(aCores,{})
	Ains(aCores,1)
	if !lExcept
		aCores[1] := { "ALLTRIM(C5_CONTRA) == 'XX' .OR. ALLTRIM(C5_CONTRA) == 'Y'  ","BR_BRANCO","Bloqueio de Margem"}  
	else
		aCores[1] := { "ALLTRIM(C5_CONTRA) == 'X' .or. ALLTRIM(C5_CONTRA) == 'XX' ","BR_BRANCO","Bloqueio de Margem"}  		
	endif
		aCores[1] := { "ALLTRIM(C5_CONTRA) == 'MFR' ","BR_VIOLETA","Bloqueio Risco de Fraude"}
	// incluido cor laranja para assinalar o pedido que foi liberado no credito
	Aadd(aCores,{})
	Ains(aCores,1)
	aCores[1] := { "C5_LIBCRED == 'X' .AND. Empty(C5_NOTA)","BR_LARANJA","Liberado Credito"}
	
Return( aCores )
