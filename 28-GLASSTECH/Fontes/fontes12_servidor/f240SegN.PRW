User Function f240SegN()   

   Local _cReg := ''
   Local _lEmp := .F.
   Local _lMsg := .F.
   Local _nRec := 0

   SE2->( MSSeek( SEA->EA_FILORIG+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA, .F. ) )   

   _cGPS := Substr( SE2->E2_LINDIG, 21, 3 ) + Substr( SE2->E2_LINDIG, 25, 1 )
   
   If _cGPS = '2631'

	  _cCNPJ := Substr( SE2->E2_LINDIG, 26, 10 ) // CNPJ
	  _cCNPJ += Substr( SE2->E2_LINDIG, 37,  4 ) // CNPJ Complemento    
	  _nIdx  := SE2->( IndexOrd() )
      
      SA2->( dbSetOrder( 3 ) )
      SA2->( MSSeek( xFilial( 'SA2' ) + _cCNPJ, .F. ) )
      
      If _cCNPJ <> SA2->A2_CGC
      
         _lMsg := .T.

      End
      
      SA2->( dbSetOrder( _nIdx ) )
   
   ElseIf (SE2->E2_FILIAL <> Substr( SM0->M0_CODFIL, 1, Len( SE2->E2_FILIAL ) ))
   
      _lEmp := .T.
      _nRec := SM0->( RecNo() )
      SM0->( MSSeek( '01' + SE2->E2_FILIAL, .F.  ) )

      If Substr( SE2->E2_CODBAR, 25, 12 ) <> Substr( SM0->M0_CGC, 1, 12 ) .And. ! Empty( SE2->E2_CODBAR ) .And. (SE2->E2_RETINS <> '0115')

         If Substr( SE2->E2_CODBAR, 25, 8 ) <> Substr( SM0->M0_CGC, 1, 8 )

            _lMsg := .T.
         
         Else

            SM0->( dbGoTo( _nRec ) )

         End

      End

   End

   If (_lMsg)
   
      MsgInfo( 'CNPJ inválido, por gentileza verifique a empresa do pagamento em questão.', 'Empresa ativa diverge do titulo')
      _cReg := Space( 178 )
      
   Else

	  If ( SE2->E2_RETINS = '0115' ) .Or. ( SE2->E2_RETINS = '0507' )

	     _cReg := '11'   // FGTS
	     _cReg += SE2->E2_RETINS
	     _cReg += '1'   // Identificação do contribuinte 1 - CNPJ 2 - CEI
	     _cReg += StrZero( Val(SM0->M0_CGC), 14, 0 )
	     _cReg += SE2->E2_LINDIG
	     _cReg += Space( 27 )
	     _cReg += Substr( SM0->M0_NOMECOM, 1,30 )
	     _cReg += GravaData( SE2->E2_VENCREA, .F., 5 )
	     _cReg += StrZero( SE2->E2_VALOR * 100, 14, 0 )
	     _cReg += Space( 30 )
   
     ElseIf ( _cGPS $ '2631' )

	     _cReg := '01'   // GPS
	     _cReg += _cGPS
	     _cReg += Substr( SE2->E2_LINDIG, 45,  2 ) // Mes
	     _cReg += Substr( SE2->E2_LINDIG, 41,  4 ) // Ano
	     _cReg += _cCNPJ // CNPJ
		 _cReg += StrZero( SE2->E2_VALOR * 100, 14, 0)
		 _cReg += Replicate( '0', 28 ) // Juros e Outros Valores Multa
		 _cReg += StrZero( SE2->E2_VALOR * 100, 14, 0)
	     _cReg += GravaData( SE2->E2_VENCREA, .F., 5 ) // Data Arrecadação
	     _cReg += Space( 8 )
	     _cReg += Substr( SA2->A2_NOME, 1, 30 )

	 ElseIf ! Empty( SE2->E2_CODRET )

	     _cReg := '02'   // DARF
	     _cReg += SE2->E2_CODRET
	     _cReg += '1'   // Identificação do contribuinte 1 - CNPJ 2 - CEI
	     _cReg += StrZero( Val(SM0->M0_CGC), 14, 0 )
	     _cReg += GravaData( SE2->E2_EMISSAO, .F., 5 )
	     _cReg += Replicate( '0', 17 )
         _cReg += StrZero( SE2->E2_VALOR * 100, 14, 0 )
		 _cReg += StrZero( (SE2->E2_MULTA+SE2->E2_ACRESC)*100, 14, 0 ) // Multa
		 _cReg += StrZero( (SE2->E2_JUROS+SE2->E2_VALJUR)*100, 14, 0 ) // Juros/Encargos
         _cReg += StrZero( SE2->(E2_VALOR+E2_JUROS+E2_MULTA+E2_VALJUR+E2_ACRESC) * 100, 14, 0 )
	     _cReg += GravaData( SE2->E2_VENCREA, .F., 5 )
	     _cReg += GravaData( SE2->E2_DATAAGE, .F., 5 )
	     _cReg += Space( 30 )
	     _cReg += Substr( SM0->M0_NOMECOM, 1,30 )

	 ElseIf ! Empty( SE2->E2_NUMPRO )

	     CCF->( dbSeek( SE2->E2_FILIAL + SE2->E2_NUMPRO + SE2->E2_INDPRO, .F. ) )
	     _cReg := '05'   // ICMS
	     _cReg += if( Empty( CCF->CCF_CODREC ), Substr( CCF->CCF_DESCJU, 1, 4 ), CCF->CCF_CODREC )
	     _cReg += '1'   // Identificação do contribuinte 1 - CNPJ 2 - CEI
	     _cReg += StrZero( Val(SM0->M0_CGC), 14, 0 )
	     _cReg += if( ! Empty( CCF->CCF_NRDCOM ), StrZero( Val( CCF->CCF_NRDCOM ), 12, 0),  Substr( SM0->M0_INSC, 1, 12 ) )
	     _cReg += Substr( CCF->CCF_NRDCOM, 1, 13 )
	     _cReg += Substr(DtoS( SE2->E2_EMISSAO), 5,2 ) + SubStr( DtoS(SE2->E2_EMISSAO), 1, 4)
   	     _cReg += if( ! Empty( CCF->CCF_CODREC ), StrZero( Val( CCF->CCF_NUMERO ), 13, 0 ), Space(13) )
         _cReg += StrZero( SE2->E2_VALOR * 100, 14, 0 )
		 _cReg += StrZero( SE2->E2_MULTA, 14, 0 ) // Multa
		 _cReg += StrZero( SE2->E2_JUROS, 14, 0 ) // Juros/Encargos
         _cReg += StrZero( SE2->(E2_VALOR+E2_JUROS+E2_MULTA) * 100, 14, 0 )
	     _cReg += GravaData( SE2->E2_VENCREA, .F., 5 )
	     _cReg += GravaData( SE2->E2_DATAAGE, .F., 5 )
	     _cReg += Space( 11 )
	     _cReg += Substr( SM0->M0_NOMECOM, 1,30 )

	 ElseIf ( SE2->E2_RETINS = '2909' ) .Or.;
            ( SE2->E2_RETINS = '2100' ) .Or.;
            ( SE2->E2_RETINS = '2003' ) .Or.;
            ( SE2->E2_RETINS = '4308' )
	 
	     _cReg := '01'
	     _cReg += SE2->E2_RETINS
	     _cReg += StrZero( Month( SE2->E2_EMISSAO ), 2, 0 )
	     _cReg += StrZero( Year( SE2->E2_EMISSAO ), 4, 0 )
	     _cReg += StrZero( Val(SM0->M0_CGC), 14, 0 )
	     _cReg += StrZero( SE2->E2_VALOR * 100, 14, 0 )
	     _cReg += StrZero( SE2->E2_ACRESC * 100, 14, 0 ) // Outras entidades (Multa alterado em 20/10/2016)
		 _cReg += StrZero( SE2->E2_VALJUR * 100, 14, 0 ) // Juros/Encargos
         _cReg += StrZero( (SE2->E2_VALOR + (SE2->E2_ACRESC+SE2->E2_VALJUR)) * 100, 14, 0 )
	     _cReg += GravaData( SE2->E2_VENCREA, .F., 5 )
	     _cReg += Space( 8 )
	     _cReg += SE2->E2_HIST
	     _cReg += Substr( SM0->M0_NOMECOM, 1,30 )
	     
	 End
	 
   End

   nSomaAcres += SE2->E2_VALJUR
   
   If _lEmp
   
      SM0->( dbGoTo( _nRec ) )

   End

Return( _cReg )