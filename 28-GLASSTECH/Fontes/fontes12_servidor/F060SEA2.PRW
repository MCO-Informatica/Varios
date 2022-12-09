#INCLUDE "PROTHEUS.CH" 

Static cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F060SEA2 ºAutor  ³ Sérgio Santana     º Data ³ 07/03/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada na geração do Bordero do C.Receber   º±±
±±º          ³ - Tem a finalidade de gerar os boletos                     º±±
±±º          ³ bancários referente as cobranças em carteira, Banco Itaú   º±±
±±º          ³ operação 109.                                              º±±
±±º12/05/2017³ atualização da carteira no sistema GESTOQ com base no de-  º±±
±±º          ³ para SA6 -> COBRANCA                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F060SEA2( _cRot )

   LOCAL _lRet
   LOCAL _nIdCart := 0
   LOCAL _nIdCont := 0   

   DEFAULT _cRot := 'B'
   
   _nIdCart := if( _cRot = 'T' .And. SE1->E1_SITUACA = '0' .And. SE1->E1_PORTADO = '   ', 1, SA6->A6_IDCART )
   _nIdCont := if( _cRot = 'T' .And. SE1->E1_SITUACA = '0' .And. SE1->E1_PORTADO = '   ', 1, SA6->A6_IDCONTA )

   If SE1->E1_ORIGBD == "B" //SE1->E1_IDBOLET > 374000 // Titulos gerados pelo BV

	  _cUpd := 'UPDATE [192.168.0.7].'+cBVGstq+'.dbo.VENCTITULO SET QdeBoleto = QdeBoleto + 1, ID_COBRANCA = ' + Alltrim( Str( _nIdCart, 3, 0  ) ) + ', ID_CONTA = '  + Alltrim( Str( _nIdCont, 3, 0  ) )
	  _cUpd += ' WHERE ID_VENCTITULO = ' + Alltrim( Str( SE1->E1_IDBOLET, 9, 0 ) )
		
   Else // Títules gerados pelo GESTOQ
		
	  _cUpd := 'UPDATE '+cBDGSTQ+'.dbo.VENCTITULO SET QdeBoleto = QdeBoleto + 1, ID_COBRANCA = ' + Alltrim( Str( _nIdCart, 3, 0  ) ) + ', ID_CONTA = '  + Alltrim( Str( _nIdCont, 3, 0  ) )
	  _cUpd += ' WHERE ID_VENCTITULO = ' + Alltrim( Str( SE1->E1_IDBOLET, 9, 0 ) )

   EndIf

   _lRet := TCSqlExec( _cUpd )

Return( NIL )