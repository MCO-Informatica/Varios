#Include 'Protheus.ch'

User Function F050BROW()
	PswOrder( 1 ) // Ordena por user ID //
        
	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf 
	
	IF cGRUPO == "000002" .OR. cGRUPO == "000003" .OR. cGRUPO == "000006"  
		dbSelectArea("SE2")
	    dbSetOrder(1)
	    SET FILTER TO  SUBSTR(SE2->E2_XXIC,1,2) $ "AT/EQ/EN/ST/PR/ST/CM" 
	    //SET FILTER TO SE2->E2_XXIC > "0" .AND. SE2->E2_XXIC < "X" 
	 	DBFILTER() // retorna: Nome > "Jose"
	ENDIF
	
Return

