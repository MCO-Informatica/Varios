/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT105FIM  ºAutor  ³Sérgio Santana      º Data ³  04/01/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta rotina tem a finalidade de gerar a pre-requisição du- º±±
±±º          ³ rante a inclusão da solicitação ao armazém                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glastech                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT105FIM()

LOCAL _nIdx      := SCP->( IndexOrd() )                                                   
LOCAL _cFilSCP   := xFilial( 'SCP' )
LOCAL _lOpc      := if( Paramixb = 1, .T., .F. )
LOCAL _nRec      := 0
LOCAL _nLen      := 0
LOCAL nAglutSC   := 1
LOCAL lRateio    := .F.
LOCAL lIntegDef	 := FWHasEAI("MATA105",.T.,,.T.)
LOCAL n1Cnt      := 0
LOCAL aRecSCP    := {}
LOCAL aCamposSCP := {}
LOCAL aCamposSD3 := {}

PRIVATE aIndexSCP  := {}
PRIVATE aCheckDes  := {}
PRIVATE cMarca     := GetMark()
PRIVATE cFiltraSCP := "(CP_OK = '" + cMarca +"')"
PRIVATE bBloco     := If(Empty(cFiltraSCP), {|| .T.}, {|| &cFiltraSCP})
PRIVATE bFiltraBrw := " "
PRIVATE nCancela   := 0
PRIVATE cAlias     := 'SCP'

If _lOpc

   _aArea := GetArea()
   _nRec := SCP->( RecNo() )
   SCP->( dbSetOrder(1) )
   SCP->( dbSeek( _cFilSCP + cA105Num, .T. ) )

   While (SCP->CP_FILIAL = _cFilSCP) .And.;
         (SCP->CP_NUM    = cA105Num) .And.;
         ! (SCP->( Eof() ) )

      RecLock( 'SCP', .F. )

      SCP->CP_OK := cMarca
      SCP->( MSUnLock() )
      SCP->( dbSkip() )

   End

   Pergunte( "MTA106", .F. )


   If A106VldRat(@nAglutSC,@lRateio)
      MaSaPreReq( .F., MV_PAR01==1, bBloco, MV_PAR02==1, MV_PAR03==1, MV_PAR04==1, MV_PAR05, MV_PAR06, MV_PAR07==1, MV_PAR08==1, nAglutSC,, MV_PAR10==1, @aRecSCP, lRateio )
   End

   If lIntegDef
	  //-- Atualiza array de recnos a serem processados na mensagem unica no MATA105
	  MTSetRecSCP( aRecSCP )
	  //-- Somente SA processada pela funcao MaSaPreReq
	  _nLen := Len( aRecSCP )

	  For n1Cnt := 1 To _nLen

	      SCP->( dbGoTo( aRecSCP[ n1Cnt ] ) )

		  If aScan( aNumSCP, SCP->CP_NUM ) = 0

			 aAdd( aNumSCP, SCP->CP_NUM )
			 FwIntegDef( 'MATA105' )

		   End

	  Next

   End
   
   RestArea( _aArea )
   SCP->( dbSetOrder( _nIdx ) )
   SCP->( dbGoTo( _nRec ) )

End

Return( NIL )


Static Function A106VldRat(nAglutSC,lRateio)

Local cAliasSCP	:= "SCP"
Local cQuery	:= ""
Local lQuery	:= .F.
Local lHelp		:= .F.
Local lContinua	:= .T.
Local cSAComRat := ""

// Armazena opcao de aglutinacao
nAglutSC := MV_PAR09

cAliasSCP := GetNextAlias()
lQuery  := .T.
cQuery  := "SELECT CP_FILIAL, CP_NUM, CP_ITEM, CP_RATEIO "
cQuery  += "FROM "+RetSqlName("SCP")+" SCP "
cQuery  += "WHERE CP_FILIAL='"+xFilial("SCP")+"' AND "
cQuery  += "CP_PREREQU<>'S' AND "
cQuery  += "D_E_L_E_T_=' ' "
If ( ThisInv() )
	cQuery += "AND CP_OK<>'"+ThisMark()+"' "
Else
	cQuery += "AND CP_OK='"+ThisMark()+"' "
EndIf
cQuery += "ORDER BY "+SqlOrder(SCP->(IndexKey()))
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasSCP, .F., .T. )

While ( !Eof() .And. (cAliasSCP)->CP_FILIAL == xFilial("SCP") )
	If lQuery
		If (cAliasSCP)->CP_RATEIO = "1"		// Se o item possuir rateio nao podera ocorrer aglutinacao da solicitacao
			lRateio	 := .T.
			nAglutSC := 2
			cSAComRat += (cAliasSCP)->CP_NUM+" - "+(cAliasSCP)->CP_ITEM + CRLF
			If MV_PAR09 == 1 .Or. MV_PAR09 == 3
				lHelp := .T.
			EndIf
		EndIf
	Else
		If ThisInv()
			If SCP->CP_OK == ThisMark() .Or. CP_PREREQU == "S"
				dbSelectArea("SCP")
				dbSkip()
				Loop
			Else
				If SCP->CP_RATEIO = "1"		// Se o item possuir rateio nao podera ocorrer a lutinacao da solicitacao
					lRateio	 := .T.
					nAglutSC := 2
					cSAComRat += SCP->CP_NUM+" - "+SCP->CP_ITEM + CRLF
					If MV_PAR09 == 1 .Or. MV_PAR09 == 3
						lHelp := .T.
					EndIf
				EndIf
			EndIf
		Else
			If AllTrim(SCP->CP_OK) <> ThisMark() .Or. CP_PREREQU == "S"
				dbSelectArea("SCP")
				dbSkip()
				Loop
			Else
				If SCP->CP_RATEIO = "1"		// Se o item possuir rateio nao podera ocorrer aglutinacao da solicitacao
					lRateio	 := .T.
					nAglutSC := 2
					cSAComRat += SCP->CP_NUM+" - "+SCP->CP_ITEM + CRLF
					If MV_PAR09 == 1 .Or. MV_PAR09 == 3
						lHelp := .T.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	dbSelectArea(cAliasSCP)
	dbSkip()
EndDo

If lHelp
	nOpc := Aviso('STR0010','STR0011' + 'CRLF' + 'STR0012' + CRLF + 'STR0013 + CRLF' + CRLF + cSAComRat,{'STR0014','STR0015'},3,'STR0016')
	If nOpc == 2
		lContinua := .F.
	EndIf
EndIf

Return lContinua
