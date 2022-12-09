/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A415TDOK  ºAutor  ³Sergio Santana      º Data ³  04/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada tem a finalidade iniciar os campos   º±±
±±º          ³ descontos gerência e diretoria quando utilizada a função   º±±
±±º          ³ cópia.                                                     º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ThermoGlass                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


// A T E N Ç Ã O  P O N T O   D E  E N T R A D A   E X I S T E   N O   P R O J E T O   A T U A L

User Function A415TDOK()

    If ( ProcName(  8 ) = 'A415COPIA' ) .Or.;
       ( ProcName( 13 ) = 'A415COPIA' )  // Verifica a função utilizada igual a cópia zera campos de descontos gerência e diretoria

       _nRecNo := TMP1->( RECNO() )
       TMP1->( dbGoTop() )

	   While ! TMP1->( Eof() )

 //         RecLock( 'TMP1', .F. ) // trava registro temporário
   
          TMP1->CK_ZZDESC1 := 0
          TMP1->CK_ZZVDES1 := 0

          If ( Type('TMP1->CK_ZZLIMIG' ) <> 'U' ) // Verifica campo disponivel (nivel) omitido para vendedores

             TMP1->CK_ZZLIMIG := 0

          End

          TMP1->CK_ZZDESC2 := 0
          TMP1->CK_ZZVDES2 := 0

//          TMP1->( MSUnLock() ) // destrava registro temporário
          TMP1->( dbSkip() )

       End  
       
       TMP1->( dbGoTo( _nRecNo ) )

    End

Return( .T. )
