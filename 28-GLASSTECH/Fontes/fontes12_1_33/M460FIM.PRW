
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   ºAutor  ³Sérgio Santana      º Data ³  06/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusão Placa Veicular faturamento para FFM               º±±
±±º          ³ Embalagens                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'

User Function M460FIM()

   If cFilAnt = '0701' 
   
     InfPlcEmb()                                  
      _aResult := TCSPExec( "IncNFEsp", SF2->F2_DOC )
      _nIdxSD2 := SD2->( IndexOrd() )
      _nRegSD2 := SD2->( RecNo() )
      SD2->( dbSetOrder( 3 ) )

      SD2->( dbSeek( xFilial( 'SD2' ) + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ) )
      
      While ! SD2->( Eof() ) .And.;
         (SD2->D2_DOC)     = (SF2->F2_DOC)     .And.;
         (SD2->D2_SERIE)   = (SF2->F2_SERIE)   .And.;
         (SD2->D2_CLIENTE) = (SF2->F2_CLIENTE) .And.;
         (SD2->D2_LOJA)    = (SF2->F2_LOJA) 

         _aResult := TCSPExec( "IncItNFEsp", SD2->D2_FILIAL, SD2->D2_DOC, SD2->D2_SERIE, SD2->D2_ITEM, 0 )
         SD2->( dbSkip() )
         
      End
      
      SD2->( dbSetOrder( _nIdxSD2 ) )
      SD2->( dbGoTo( _nRegSD2 ) )    
      
      _aResult := TCSPExec( "IncFtNFEsp", SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE )

   End

Return()


Static Function InfPlcEmb()

   Local _cMenNota := Space( 254 )
   Local _cCodTran := Space( 6 )
   Local _cPlc     := Space( 7 )
   Local _aCodEsp  := { '   ' ,'   ', '   ' }
   Local _nLen     := 0
   Local i         := 0
   Local _aArea    := GetArea()
   Local _aAreaCB3 := CB3->( GetArea() )
   Local _aAreaDA3 := DA3->( GetArea() )
   Local _aAreaSA4 := SA4->( GetArea() )
   Local _aAreaSC6 := SC6->( GetArea() )
   Local _aAreaSC5 := SC5->( GetArea() )
   Local _aAreaSF2 := SF2->( GetArea() )
   Local _aAreaSD2 := SD2->( GetArea() )
   Local _aAreaSFT := SFT->( GetArea() )

   Private _cFilCB3 := xFilial( 'CB3' )
   Private _cFilDA3 := xFilial( 'DA3' )
   Private _aDscEsp := { 'PECA(S)', SF2->F2_ESPECI2, SF2->F2_ESPECI3 }
   Private _aQdeEsp := { SF2->F2_VOLUME1, SF2->F2_VOLUME2, SF2->F2_VOLUME3 }
   Private _aPsoEsp := { 0, 0, 0 }
   Private _cEst    := Space( 2 )
   Private _lAtu    := .F.
   Private aTransp  := {' ',' ',' ',' ',' ',' ',' ',' ',' '}
   
   IF SF2->F2_TIPO <> 'I'

	  While ! ( _lAtu  )

	     _cCodTran := SF2->F2_TRANSP
	     _cPlc     := SF2->F2_VEICUL1
		
	     @ 62,1 TO 455,780 DIALOG oDlg1 TITLE 'Dados Complementares'
	     @ 10, 9 SAY 'Transpordadora:'
	     @ 09, 50 GET _cCodTran F3 "SA4" valid VldTrans( _cCodTran )
	   
	     @ 10, 105 SAY 'Placa:'
	     @ 09, 125 GET _cPlc F3 "DA3" picture "@R !!!-9999" size 30,10 Valid PlcVeic( _cPlc )
	
	     @ 10, 220 SAY 'Nota Fiscal:'
	     @ 09, 260 GET SF2->F2_DOC when .F.
	
	     @ 10, 168 SAY 'UF:'
	     @ 09, 180 GET _cEst picture "@R !!"
	
	     @ 35, 9 SAY 'Nome:'
	     @ 34, 25 get aTransp[2] when .F. size 160, 7 
	   
	     @ 50, 9 SAY 'Endereço:'
	     @ 49, 35 get aTransp[4] when .F. size 110, 7
	
	     @ 50, 155 SAY 'Bairro:'
	     @ 49, 180 get aTransp[8] when .F.
	
	     @ 50, 245 SAY 'CEP:'
	     @ 48, 260 get aTransp[9] picture "@R 99999-999" when .F.
	
	     @ 65, 9 SAY 'Municipio:'
	     @ 64, 36 get aTransp[5] when .F. size 50,7
	
	     @ 65, 90 SAY 'Estado:'
	     @ 64, 112 get aTransp[6] when .F.
	     
	     @ 65, 130 SAY 'CNPJ:'
	     @ 64, 147 get aTransp[1] picture '@R 99.999.999/9999-99'  when .F. size 60, 7
	
	     @ 65, 208 SAY 'IE:'
	     @ 64, 215 get aTransp[3] when .F. size 60,7
	
	     @ 85,5   To 110,130 Title 'Especie 1'
	     @ 85,135 To 110,260 Title 'Especie 2'
	     @ 85,266 To 110,388 Title 'Especie 3'
	
	     @ 95, 9  get _aCodEsp[1] F3 "CB3" valid TpEmb( _aCodEsp[1], 1 )
	     @ 95,39  get _aDscEsp[1]
	     @ 95,100 get _aQdeEsp[1] picture '99' size 25,7
	
	     @ 95,139 get _aCodEsp[2] F3 "CB3" valid TpEmb( _aCodEsp[2], 2 )
	     @ 95,169 get _aDscEsp[2]
	     @ 95,230 get _aQdeEsp[2] picture '99' size 25, 7
	
	     @ 95,270 get _aCodEsp[3] F3 "CB3" valid TpEmb( _aCodEsp[3], 3 )
	     @ 95,300 get _aDscEsp[3]
	     @ 95,360 get _aQdeEsp[3] picture '99' size 25, 7
	
	     @ 120,5 To 175,388 Title "Mensagem Nota" 
	     @ 130,9  get oObs Var _cMenNota Multiline Size 375,40 Pixel
	
	     @ 180, 325 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
	     @ 180, 361 BMPBUTTON TYPE 1 ACTION GrvDadAd( _cCodTran, _cMenNota, _cPlc, _aPsoEsp )
	
	     ACTIVATE DIALOG oDlg1 CENTERED

	  End
		     
   END

   RestArea( _aAreaCB3 )
   RestArea( _aAreaDA3 )
   RestArea( _aAreaSA4 )
   RestArea( _aAreaSC6 )
   RestArea( _aAreaSC5 )
   RestArea( _aAreaSF2 )
   RestArea( _aAreaSD2 )
   RestArea( _aAreaSFT )
   RestArea( _aArea )

Return( NIL )


Static Function TpEmb( _cEmb, _nEmb )

   _lRet := .T.

   If ! ( CB3->( dbSeek( _cFilCB3 + _cEmb, .F. ) ) ) .And. ! ( Empty( _cEmb ) )

      MsgInfo( 'Embalagem não cadastrada, por favor verifique o código...' )
      _lRet := .F.   

   ElseIf ( _nEmb = 2 .Or. _nEmb = 3) .And. Empty( _cEmb )

      _aDscEsp[ _nEmb ] := space( 30 )
      _aPsoEsp[ _nEmb ] := 0
   
   ElseIf ! Empty( _cEmb )

     _aDscEsp[ _nEmb ] := CB3->CB3_DESCRI               
     _aPsoEsp[ _nEmb ] := CB3->CB3_PESO

   End

Return( NIL )


Static Function PlcVeic( _cPlcVeic )

LOCAL _cTransp := 'N'
LOCAL _aPlacas := {;
					{'BOQ9877','48254858000109'},;
					{'BPG9037','03061254000299'},;
					{'BVU9809','48254858000109'},;
					{'BYT8813','48254858000109'},;
					{'CPS3850','04051564000104'},;
					{'CZE8693','03061254000108'},;
					{'CZE9492','03061254000108'},;
					{'DCP8139','48254858000109'},;
					{'DEQ7466','48254858000109'},;
					{'DHU6698','48254858000109'},;
					{'DKX2896','48254858000109'},;
					{'DPB2546','48254858000109'},;
					{'DQB1872','48254858000109'},;
					{'ETL1438','04051564000104'},;
					{'ETL1439','48254858000109'},;
					{'ETL1461','48254858000109'},;
					{'ETL1463','48254858000109'},;
					{'ETL1465','48254858000109'},;
					{'EYD5793','49925225000148'},;
					{'EYD8291','49925225000148'},;
					{'EYI1716','48254858000109'},;
					{'FFP1692','04051564000104'},;
					{'FJW2809','04051564000104'} ;
				  }

If ! ( DA3->( dbSeek( _cFilDA3 + _cPlcVeic, .F. ) ) )
   
   MsgInfo( 'Placa de Veiculo não cadastrada, por favor verifique a Placa...' )
   _lRet := .T.

Else

   _lRet    := .T.
   _cEst    := DA3->DA3_ESTPLA
   _nPos    :=  aScan( _aPlacas , {|x| x[1] = _cPlcVeic } )
   _cCgcPlc := iif( _nPos <> 0, _aPlacas[ _nPos ][ 2 ], ' ' )

	If _cCgcPlc <> ' ' 

	   _cTransp := 'S'

	End
		
	If SA1->A1_CGC = _cCgcPlc

	   _cCgcPlc := 'S' 
	   _cTransp := 'S'

	Else

	   _cCgcPlc := 'N'

	End
		
	If ( _cPlcVeic $ 'EYD5793,EYD8291,EYI1716') .Or.;
	   ( _cTransp = 'S' .And.  _cCgcPlc = 'N' )

      aAdd(aTransp,'')
	  aAdd(aTransp,'NOSSO CARRO')
      aAdd(aTransp,'')				
	  aAdd(aTransp,'')
	  aAdd(aTransp,'')
	  aAdd(aTransp,'SP')
	  aAdd(aTransp,'')
      aAdd(aTransp,'')
      aAdd(aTransp,'')

	End

	If (_cCgcPlc = 'S') .And.;
	 ! ( _cPlcVeic $ 'EYD5793,EYD8291,EYI1716' )

      aAdd( aTransp, AllTrim( SM0->M0_CGC ) )
	  aAdd( aTransp, Upper( Alltrim( SM0->M0_NOMECOM ) ) )
      aAdd( aTransp, Alltrim( SM0->M0_INSC ) )				
	  aAdd( aTransp, Upper( Alltrim( SM0->M0_ENDCOB ) ) )
	  aAdd( aTransp, Upper( Alltrim( SM0->M0_CIDCOB ) ) )
	  aAdd( aTransp, Upper( Alltrim( SM0->M0_ESTCOB ) ) )
	  aAdd( aTransp, '' )
      aAdd( aTransp,Upper( Alltrim( SM0->M0_BAIRCOB ) ) ) 
      aAdd( aTransp,Transform(SM0->M0_CEPCOB,'@R 99999-999'))

    End

    If rTrim( SA4->A4_NREDUZ ) = 'RETIRA (GRANEL)' .Or.;
	   rTrim( SA4->A4_NREDUZ ) = 'RETIRA (CAIXA)'

       aAdd( aTransp, AllTrim( SA1->A1_CGC ) )
	   aAdd( aTransp, Upper( Alltrim( SA1->A1_NOME ) ) )
       aAdd( aTransp, Alltrim( SA1->A1_INSCR ))				
	   aAdd( aTransp, Upper( Alltrim( SA1->A1_END ) ) )
	   aAdd( aTransp, Upper( Alltrim( SA1->A1_MUN ) ) )
	   aAdd( aTransp, Upper( Alltrim( SA1->A1_EST ) ) )
	   aAdd( aTransp, '' )
       aAdd( aTransp,Upper( Alltrim( SA1->A1_BAIRRO ) ) ) 
       aAdd( aTransp,Transform( SA1->A1_CEP,'@R 99999-999'))

    End

End

Return( _lRet )

Static Function GrvDadAd( _cCodTran, _cMenNota, _cPlc, _aPsoEsp )

   _lAtu := MsgYesNo('Confirma a atualização dos dados adicionais?', 'Nota Fiscal nº ' + SF2->F2_DOC )

   If _lAtu

      RecLock( 'SF2', .F. )
	  SF2->F2_TRANSP  := _cCodTran
      SF2->F2_VEICUL1 := _cPlc
      SF2->F2_MENNOTA := _cMenNota

      SF2->F2_ESPECI1 := _aDscEsp[1]
      SF2->F2_ESPECI2 := _aDscEsp[2]
      SF2->F2_ESPECI3 := _aDscEsp[3]
   
      SF2->F2_VOLUME1  := _aQdeEsp[1]
      SF2->F2_VOLUME2  := _aQdeEsp[2]
      SF2->F2_VOLUME3  := _aQdeEsp[3]
      
      _aPsoEsp[ 1 ] *= _aQdeEsp[ 1 ]
      _aPsoEsp[ 2 ] *= _aQdeEsp[ 2 ]
      _aPsoEsp[ 3 ] *= _aQdeEsp[ 3 ]
      
      SF2->F2_PBRUTO := SF2->F2_PLIQUI + _aPsoEsp[1] + _aPsoEsp[2] + _aPsoEsp[3]
      
      SF2->( MSUnLock() )

   End

Return( Close( oDlg1 ) )

Static Function VldTrans( _cTrans )

   If ! ( SA4->( dbSeek( xFilial( 'SA4' ) + _cTrans, .F. ) ) )
   
      MsgInfo( 'Transportadora não cadastrada, por favor verifique o cadastro...' )
     _lRet := .F.

   Else

      aTransp := {}
      aAdd(aTransp,AllTrim(SA4->A4_CGC))
      aAdd(aTransp,SA4->A4_NOME)

      If (SA4->A4_TPTRANS <> "3")
          aAdd(aTransp,VldIE(SA4->A4_INSEST))
      Else
          aAdd(aTransp,"")				
      End

      aAdd(aTransp,SA4->A4_END)
	  aAdd(aTransp,SA4->A4_MUN)
	  aAdd(aTransp,Upper(SA4->A4_EST)	)
	  aAdd(aTransp,SA4->A4_EMAIL	)
      aAdd(aTransp,SA4->A4_BAIRRO)
      aAdd(aTransp,SA4->A4_CEP)
      _lRet := .T.

   End

Return( _lRet )
