
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A100TRA   ºAutor  ³ Sérgio Santana     º Data ³ 30/03/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada tem por finalidade compatibilizar a  º±±
±±º          ³ empresa de origem de acordo com a conta corrente.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glasstech                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A100TRA()

/* []---------------------------------------------------------------------------[]

            Lista de paramentros

   lEstorno   [1]
   cBcoOrig   [2]
   cBcoDest   [3]
   cAgenOrig  [4]
   cAgenDest  [5]
   cCtaOrig   [6]
   cCtaDest   [7]
   cNaturOri  [8]
   cNaturDes  [9]
   cDocTran  [10]
   cHist100  [11]

 []---------------------------------------------------------------------------[] */

_aTransf := ParamIxb

If ( SE5->E5_CONTA = _aTransf[ 6 ] )

   _aSaveArea := GetArea()
   SE5->E5_FILIAL  := SA6->A6_ZFILORI
   SE5->E5_FILORIG := SA6->A6_ZFILORI
   SE5->E5_MOEDA   := 'TB'
   FK5->FK5_FILIAL := SA6->A6_ZFILORI
   FK5->FK5_FILORI := SA6->A6_ZFILORI
   FKA->FKA_FILIAL := SA6->A6_ZFILORI

   _nRecSA6 := SA6->( RecNo() )
   _nRecSM0 := SM0->( RecNo() )
   SA6->( dbSeek( xFilial('SA6') + _aTransf[ 3 ] + _aTransf[ 5 ] + _aTransf[ 7 ] ) )
   SM0->( dbSeek( cEmpAnt + SA6->A6_ZFILORI, .T. ) )   
   SE5->E5_HISTOR  := SA6->A6_NOME
   SE5->E5_BENEF   := SM0->M0_NOMECOM
   SA6->( dbGoTo( _nRecSA6 ) )
   SM0->( dbGoTo( _nRecSM0 ) )
   RestArea( _aSaveArea )
   

End

Return( NIL )