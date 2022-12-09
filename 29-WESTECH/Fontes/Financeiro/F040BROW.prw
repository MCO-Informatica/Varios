#Include 'Protheus.ch'

User Function F040BROW()
	PswOrder( 1 ) // Ordena por user ID //
        
	If PswSeek( RetCodUsr() )
   		cGRUPO := Upper( AllTrim( PswRet( 1 )[1][10][1] ) )
   		//cDepartamento := Upper( AllTrim( PswRet( 1 )[1][12] ) )
	EndIf 
	
	IF cGRUPO == "000002" .OR. cGRUPO == "000003" .OR. cGRUPO == "000006"  
		dbSelectArea("SE1")
	    dbSetOrder(1)
	    SET FILTER TO SUBSTR(SE1->E1_XXIC,1,2) $ "AT/EQ/EN/ST/PR/ST/CM"   
	 	DBFILTER() // retorna: Nome > "Jose"
	ENDIF
	
Return

