#Include 'Protheus.ch'

User Function GatExcFiscal()
	
	Local cError
	Local bError
 	Local bErrorBlock
 	Local oError
 	
 	bError      	:= { |e| oError := e , BREAK(e) }
 	bErrorBlock    	:= ErrorBlock( bError )


 	BEGIN SEQUENCE
 	
		cGRPTRIB 	:= SA2->A2_GRPTRIB
		cGRTRIB  	:= SB1->B1_GRTRIB
		
		IF !EMPTY(cGRPTRIB) .AND. !EMPTY(cGRTRIB)
			
			
			IF ALLTRIM(cGRPTRIB) = ALLTRIM(cGRTRIB)
				
				If SF7->( dbSeek( xFilial("SF7") + ALLTRIM(cGRPTRIB)) )
					
					cValor := SF7->F7_ALIQDST
					Return (cValor)
					
				END IF
			else
				break
				
			ENDIF
			
		ENDIF
		
	END SEQUENCE
	ErrorBlock( bErrorBlock )


Return NIL

