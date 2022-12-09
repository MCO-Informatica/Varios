#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT780TOK    ºAutor  ³Claudio Henrique Corrêaº Data ³        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para tratar calendarios sem intevalo       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT780TOK()

Local nOpc	        := PARAMIXB[1]  // Opcao executada
Local aCalendario  	:= PARAMIXB[2]  // Var. a780Calend
Local aHoras		:= {}
Local nDias			:= 0
Local lRet          := .T.
Local nPrecisa		:= GETNEWPAR("MV_PRECISA", 1)
Local nTamDia		:= 1440/(60/nPrecisa)

If nOpc == 3 .Or. nOpc == 4   // Ateracao    //Inclusão

	If len(aCalendario) > 0
	
		nIx := 0
		
		nPos:= 0

		For nCont := 1 To Len(aCalendario)
		
			For nIx := 1 to Len( aCalendario[nCont] )
				
				IF substr( aCalendario[nCont],nIx,1) == 'X'
				
					nPos := nIx
				
					aAdd(aHoras,{nCont, nPos-1})
							
					Exit
							
				End If
						
			Next nIx
						
			For nIx := nIx To Len( aCalendario[nCont] )
						
				IF substr( aCalendario[nCont],nIx,1) == " "
						
					nPos := nIx
			
					aAdd(aHoras,{nCont, nPos-1})
							
					Exit
						
				End If
						
			Next nIx			
								
			For nIx := nIx To Len( aCalendario [nCont] )
								
				IF substr( aCalendario[nCont],nIx,1) == 'X'
				
					nPos := nIx
				
					aAdd(aHoras,{nCont, nPos-1})
							
					Exit	
							
				End If
						
			Next nIx				
										
			For nIx := nIx To Len( aCalendario[nCont] )
						
				IF substr( aCalendario[nCont],nIx,1) == " "
						
					nPos := nIx
			
					aAdd(aHoras,{nCont, nPos-1})
							
					Exit
							
				End If
						
			Next nIx
			
			nSema := 0
			
			nDia := 0
			
			nZero := 0
			
			aZero := {}
			
			For nZero := 1 To Len( aCalendario[nCont] )
						
				IF substr( aCalendario[nCont],nZero,1) == " "
						
					aAdd(aZero,{nZero})
				
				End If
						
			Next nZero
			
			If Len(aZero) <> nTamDia
			
				For nDia := 1 To Len(aHoras)
				
					If aHoras[nDia][1] == nCont
		
						nSema++
			
					End If
				
				Next nDia
				
				If nSema <> 4
				
					MsgAlert("O Calendario deve ser preenchido obrigatoriamente com um intervalo!")
					
					lRet := .F.
					
					Return lRet
					
				End If
				
			End If
		
		Next nCont
		
	Else
	
		MsgAlert("É necessario preencher o calendario!")
		
		lRet := .F.
	
	End If

End IF

Return lRet