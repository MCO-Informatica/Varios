
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?A415LIOK  ?Autor  ?Sergio Santana      ? Data ?  04/03/13   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Este ponto de entrada tem a finalidade iniciar os campos   ???
???          ? descontos ger?ncia e diretoria quando utilizada a fun??o   ???
???          ? c?pia.                                                     ??? 
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Exclusivo ThermoGlass                                      ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/


User Function A415LIOK()

   LOCAL _cProd := ' '
   LOCAL _lRet  := .T.

   If ( ProcName( 8 ) = 'A415COPIA' ) .Or.;
      ( ProcName( 13 ) = 'A415COPIA' )  // Verifica a fun??o utilizada igual a c?pia zera campos de descontos ger?ncia e diretoria
       
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

          MsgInfo( 'N?o ? permitido incluir Or?amento com produto' + Chr(13) +;
                   'existente em outro item! ['+TMP1->CK_ITEM+']',;
                   'Duplicidade Produto';
                  )
          _lRet := .F.

      End 

      TMP1->( dbSkip() )
                                          
   End

   TMP1->( dbGoTo( _nRecNo ) )

Return( _lRet )
