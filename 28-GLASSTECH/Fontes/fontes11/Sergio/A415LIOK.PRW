
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A415LIOK  ºAutor  ³Sergio Santana      º Data ³  04/03/13   º±±
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


User Function A415LIOK()

   LOCAL _cProd := ' '
   LOCAL _lRet  := .T.

   If ( ProcName( 8 ) = 'A415COPIA' ) .Or.;
      ( ProcName( 13 ) = 'A415COPIA' )  // Verifica a função utilizada igual a cópia zera campos de descontos gerência e diretoria
       
      TMP1->CK_ZZDESC1 := 0
      TMP1->CK_ZZVDES1 := 0

      If ( Type('TMP1->CK_ZZLIMIG' ) <> 'U' ) // Verifica campo disponivel (nivel) omitido para vendedores

         TMP1->CK_ZZLIMIG := 0

      End

      TMP1->CK_ZZDESC2 := 0
      TMP1->CK_ZZVDES2 := 0

      TMP1->( dbSkip() )

   End
   
   If (TMP1->CK_FLAG = .T.)
   	  Return _lRet
   EndIf

   _nRecNo := TMP1->( RecNo() )
   _cProd  := TMP1->CK_PRODUTO

   TMP1->( dbGoTop() )

   While !TMP1->(Eof()) .And. TMP1->CK_FLAG = .F.
                         
      If ( _nRecNo <> TMP1->( RecNo() ) ) .And.;
         ( TMP1->CK_PRODUTO = _cProd )

          MsgInfo( 'Não é permitido incluir Orçamento com produto' + Chr(13) +;
                   'existente em outro item! ['+TMP1->CK_ITEM+']',;
                   'Duplicidade Produto';
                  )
          _lRet := .F.

      End 

      TMP1->( dbSkip() )
                                          
   End

   TMP1->( dbGoTo( _nRecNo ) )

Return( _lRet )
