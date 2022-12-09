#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110GRV  ºAutor  ³Sérgio Santana      º Data ³  11/03/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava código do comprador a partir do grupo do comprador   º±±
±±º          ³ individualizado quando o campo código do comprador não es- º±±
±±º          ³ tiver preenchido.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Thermoglass                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT110GRV( _cGrupoCom )

   DEFAULT _cGrupoCom := SC1->C1_GRUPCOM
   
   If Empty( cCodCompr )
   
	   SAJ->( dbSeek( xFilial( 'SAJ' ) + _cGrupoCom, .T. ) )
	   _cCodUser := SAJ->AJ_USER
	
	   If SAJ->AJ_GRCOM = _cGrupoCom
	
	      _nIdxOrd := SY1->( IndexOrd() )  
	      SY1->( dbSetOrder( 3 ) )
	
		  If ( SY1->( dbSeek( xFilial( 'SY1' ) + SAJ->AJ_USER, .F. ) ) )

	         If Inclui 
   	            RecLock( 'SC1', .F. )
    	        SC1->C1_CODCOMP := SY1->Y1_COD
	            SC1->( dbUnLock() )
	         Else
	            SC1->C1_CODCOMP := SY1->Y1_COD	         
	         End
		  
		  End
		  
		  SY1->( dbSetOrder( _nIdxOrd ) )
	   
	   End

   End


Return( NIL )
