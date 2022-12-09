#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MA440COR  ³ Autor ³ Eneovaldo Roveri Juni ³ Data ³18/11/2009³±±
±±³Descrição ³adicionar cor ao status do pedido: Cancelado e Reprovado    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MA410COR()
Local aCores := {}
Local nX := 1
local lExcept := cEmpAnt == '02'

if type( "PARAMIXB" ) == "A"
	aCores := PARAMIXB
endif

Aadd(aCores,NIL)
Ains(aCores,1)
aCores[01] := {"C5_X_REP == 'R' .AND. empty(C5_CONTRA)","BR_PINK","Reprovado"}

Aadd(aCores,NIL)
Ains(aCores,1)
aCores[01] := { "C5_X_CANC == 'C'","BR_CINZA","Cancelado"}

Aadd(aCores,NIL)
Ains(aCores,1)
if !lExcept
	aCores[01] := { "ALLTRIM(C5_CONTRA) == 'XX' .OR.  ALLTRIM(C5_CONTRA) == 'Y'","BR_BRANCO","Margem"}
else
	aCores[01] := { "ALLTRIM(C5_CONTRA) == 'XX' .or. ALLTRIM(C5_CONTRA) == 'X'","BR_BRANCO","Margem"}
endif
	aCores[01] := { "ALLTRIM(C5_CONTRA) == 'MFR' ","BR_VIOLETA","Bloqueio Risco de Fraude"}

// incluido cor laranja para assinalar o pedido bloqueados Por Margem
nEnable :=  aScan(aCores,{ |x| Alltrim(x[2])=="ENABLE"})
if !lExcept
	aCores[nEnable,1] +=  " .AND. (ALLTRIM(C5_CONTRA) <> 'XX'  .OR. ALLTRIM(C5_CONTRA) <> 'Y' )"
else
	aCores[nEnable,1] +=  " .AND. empty(C5_CONTRA) "
endif

nAmarelo :=  aScan(aCores,{ |x| Alltrim(x[2])=="BR_AMARELO"})
aCores[nAmarelo][1] += " .AND. C5_LIBCRED <> 'X'"

// incluido cor laranja para assinalar o pedido que foi liberado no credito
nLaranja :=  aScan(aCores,{ |x| Alltrim(x[2])=="BR_LARANJA"})
if nLaranja > 0
	aCores[nLaranja][3] :=	"Liberado Credito"
	aCores[nLaranja][1] :=	"C5_LIBCRED == 'X' .AND. Empty(C5_NOTA)"
Endif

For nX := 1 to len(aCores)
	aCores[nX,3] := nX
Next nX

Return( aCores )
