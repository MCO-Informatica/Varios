#INCLUDE "protheus.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA010MNU   ºAutor  ³Microsiga           º Data ³  03/30/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA010MNU()
Local cESUSERSB1  := SuperGetMv("ES_USERSB1",,'000000')

//aAdd( aRotina, { "Endereços", "U_AEST016", 0, 4, 0, .F. } )
aAdd( aRotina, { "Cons. Especifica", "U_CFAT010( SB1->B1_COD )", 0 , 2, 0, .F.} )
aAdd( aRotina, { "MRP", "U_IMCDAJUSTEMRP()", 0, 4, 0, .F. } )


if cEmpAnt == '02' 

	aAdd( aRotina, { "Log Cmp. Anvisa", "U_ANVISALOG()", 0 , 2, 0, .F.} )
	AAdd( aRotina, { 'Liberar PRD INDENT' ,"U_LIBPRDIDENT()", 0 , 2, 0, .F.} )
	
	if !(__cUserId $ cESUSERSB1)
		nPosInc := aScan(aRotina,{|x| AllTrim(x[2]) ==  "A010Inclui" }) 

		IF nPosInc > 0 

			ADel( aRotina, nPosInc )
			Asize(aRotina,Len(aRotina)-1)

		ENDIF
	endif

ENDIF

Return
