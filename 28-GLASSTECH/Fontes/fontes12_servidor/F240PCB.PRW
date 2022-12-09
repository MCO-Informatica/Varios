
Static cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F240PCB  ºAutor  ³ Sérgio Santana     º Data ³ 22/05/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Estorna carteira GESTOQ/BV via cancelamento bordero        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glasstech                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F240PCB()

   LOCAL _lRet
   LOCAL _idCobr :=  Alltrim( Str( if( SA6->A6_IDCART  <> 0, SA6->A6_IDCART , 1 ), 3, 0 ) )
   LOCAL _idCont :=  Alltrim( Str( if( SA6->A6_IDCONTA <> 0, SA6->A6_IDCONTA, 1 ), 3, 0 ) )

   If SE1->E1_ORIGBD = "B" //SE1->E1_IDBOLET > 374000 // Titulos gerados pelo BV

	  _cUpd := 'UPDATE [192.168.0.7].'+cBVGstq+'.dbo.VENCTITULO SET QdeBoleto = QdeBoleto + 1, ID_COBRANCA = ' + _idCobr + ', ID_CONTA = '  + _idCont
	  _cUpd += ' WHERE ID_VENCTITULO = ' + Alltrim( Str( SE1->E1_IDBOLET, 9, 0 ) )
		
   Else // Títules gerados pelo GESTOQ
		
	  _cUpd := 'UPDATE '+cBDGSTQ+'.dbo.VENCTITULO SET QdeBoleto = QdeBoleto + 1, ID_COBRANCA = ' + _idCobr + ', ID_CONTA = '  + _idCont
	  _cUpd += ' WHERE ID_VENCTITULO = ' + Alltrim( Str( SE1->E1_IDBOLET, 9, 0 ) )
	
   EndIf
	
   _lRet :=  TCSqlExec( _cUpd )

Return( NIL )