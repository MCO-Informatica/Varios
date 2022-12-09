#Include 'Protheus.ch'
//-----------------------------------------------------------------------------------
// Rotina | CSFA500      | Autor | Robson Gonçalves               | Data | 17/11/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina que cria o título a receber com base na condição de pagamento, 
//        | cria o movimento bancário e a relação com o pagamento antecipado.
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
User Function CSFA500( nOpc, cCondPagto, nValor, aSE1, lFIE, lSE5, dDtCred, aBanco, cHistSE5, cDocSE5 )
	Local lRet := .T.
	
	Local nI := 0
	Local nTitulos := 0

	Local aAutoErr := {}
	Local aRet := {}
	Local aVenc := {}
	Local aRegSE1 := {}
	
	Local cMsg := ''
	Local cParcela := ''

	Private lMsErroAuto := .F.
	Private lAutoErrNoFile	:= .T.
	
	Default cCondPagto	:=  "000"
	Default cDocSE5		:=  ""

	// nPar1 = nValorTotal
	// cPar2 = cCodigoCondicaoPagamento
	// nPar3 = nValorIpi
	// dPar4 = dDataEmissao
	// nPar5 = nValorSolidario
	aVenc := Condicao( nValor, cCondPagto, 0.00, aSE1[ 7 ], 0.00 )
	nTitulos := Len( aVenc )

	// Verificar se há mais de uma parcela de títulos.
	If nTitulos > 1
		cParcela := SuperGetMV('MV_1DUP',,'1')
	EndIf
	
	If Len(aSE1)>= 14 .and. nTitulos == 1 .and. !Empty(aSE1[ 14 ]) 
		cParcela := aSE1[ 14 ]
	Endif
	
	For nI := 1 To nTitulos       
		aRegSE1 := {}
		AAdd( aRegSE1, { 'E1_PREFIXO', aSE1[ 1 ]                  ,NIL } ) //01-Campo que permite ao usuario identificar um conjunto de titulos que pertencam a um mesmo grupo 
		AAdd( aRegSE1, { 'E1_NUM'    , aSE1[ 2 ]                  ,NIL } ) //02-Numero do titulo
		AAdd( aRegSE1, { 'E1_PARCELA', cParcela                   ,NIL } ) //03-Parcela do Titulo
		AAdd( aRegSE1, { 'E1_TIPO'   , aSE1[ 3 ]                  ,NIL } ) //04-Tipo(Boleto, Cartao, Cheque...)
		AAdd( aRegSE1, { 'E1_NATUREZ', aSE1[ 4 ]                  ,NIL } ) //05-Utilizado para identificar a procedencia dos titulos
		AAdd( aRegSE1, { 'E1_CLIENTE', aSE1[ 5 ]                  ,NIL } ) //06-Codigo do Cliente
		AAdd( aRegSE1, { 'E1_LOJA'   , aSE1[ 6 ]                  ,NIL } ) //07-Lojas do Cliente
		AAdd( aRegSE1, { 'E1_EMISSAO', aSE1[ 7 ]                  ,NIL } ) //08-Data de Emissao
		AAdd( aRegSE1, { 'E1_VENCTO' , aVenc[ nI, 1 ]             ,NIL } ) //09-Data de Vencimento
		AAdd( aRegSE1, { 'E1_VENCREA', DataValida( aVenc[ nI, 1 ]),NIL } ) //10-Venvimento Real
		AAdd( aRegSE1, { 'E1_VALOR'  , aVenc[ nI, 2 ]             ,NIL } ) //11-Valor do Titulo
		AAdd( aRegSE1, { 'E1_PEDIDO' , aSE1[ 8 ]                  ,NIL } ) //12-Pedido de Venda
		AAdd( aRegSE1, { 'E1_XNPSITE', aSE1[ 9 ]                  ,NIL } ) //13-Pedido de Venda gerado pelo site
		AAdd( aRegSE1, { 'E1_VEND1'  , ''                         ,NIL } ) //14-Vendedor 1
		AAdd( aRegSE1, { 'E1_VEND2'  , ''                         ,NIL } ) //15-Vendedor 2
		AAdd( aRegSE1, { 'E1_VEND3'  , ''                         ,NIL } ) //16-Vendedor 3
		AAdd( aRegSE1, { 'E1_VEND4'  , ''                         ,NIL } ) //17-Vendedor 4
		AAdd( aRegSE1, { 'E1_VEND5'  , ''                         ,NIL } ) //18-Vendedor 5
		AAdd( aRegSE1, { 'E1_NUMBCO' , aSE1[ 10 ]                 ,NIL } ) //19-Nosso Número do Boleto
		AAdd( aRegSE1, { 'E1_TIPMOV' , aSE1[ 11 ]                 ,NIL } ) //20-Tipo do Movimento
		AAdd( aRegSE1, { 'E1_PEDGAR' , aSE1[ 12 ]                 ,NIL } ) //21-Código Pedido GAR
		
		If Len( aSE1 ) > 15 .AND. .NOT. Empty( aSE1[ 16 ] )
			AAdd( aRegSE1, { 'E1_OS' , aSE1[ 16 ]                  ,NIL } ) //22-Número da OS agendamento externo.
		Endif
		
		U_GTPutIN( aSE1[ 13 ], 'T', aSE1[ 12 ], .T., { 'U_CSFA500', aSE1[ 12 ], 'Inclusão de Título', aRegSE1 }, aSE1[ 9 ] )
		
		M->E1_VEND1 := ''
		M->E1_VEND2 := ''
		M->E1_VEND3 := ''
		M->E1_VEND4 := ''
		M->E1_VEND5 := ''
		
		MSExecAuto({|x,y| FINA040( x, y ) }, aRegSE1, nOpc )
		
		If lMsErroAuto
		 	MOSTRAERRO()
			cMsg := 'Inconsistência para Criar Título' + CRLF + CRLF
			aAutoErr := GetAutoGRLog()
			For nI := 1 To Len( aAutoErr )
				cMsg += aAutoErr[nI] + CRLF
			Next nI   
			U_GTPutOUT( aSE1[ 13 ], 'T', aSE1[ 12 ], { 'INC_TITULO', { .F., 'E00015', aSE1[ 12 ], cMsg } }, aSE1[ 9 ] )
			aRet := { .F., cMsg, aRegSE1 }
			lRet := .F.
		Else
			cMsg := 'Título Gerado com Sucesso'
			U_GTPutOUT( aSE1[ 13 ], 'T', aSE1[ 12 ], { 'INC_TITULO', { .T., 'M00001', aSE1[ 12 ], cMsg } }, aSE1[ 9 ] )
			aRet := { .T., cMsg, aRegSE1 }
			
			If lFIE
				A500GrvFIE( aSE1, aVenc[ nI ], cParcela )
			Endif

			IF Len(aSE1) >= 17
				IF aSE1[ 17 ] > 0
					PBS->( dbGoto( aSE1[ 17 ] ) )
					PBS->( RecLock('PBS',.F.) )
						PBS->PBS_RECSE1	:= SE1->( Recno() )
					PBS->( MsUnlock() )
				EndIF
			EndIF
			
			If lSE5 .AND. .NOT. Empty( dDtCred ) .AND. Len( aBanco ) > 0 .AND. .NOT. Empty( cHistSE5 )
				U_A500SE5( nOpc, aSE1, cParcela, aVenc[ nI ], dDtCred, aBanco, cHistSE5, cDocSE5 )
			Endif
		Endif
		If nTitulos > 1
			cParcela := Soma1( cParcela )
		Endif		
	Next nI
Return( lRet )

//-----------------------------------------------------------------------------------
// Rotina | A500GrvFIE   | Autor | Robson Gonçalves               | Data | 17/11/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina que cria a relação com o pagamento antecipado.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
Static Function A500GrvFIE( aSE1, aVenc, cParcela )
	FIE->( RecLock( 'FIE', .T. ) )
	FIE->FIE_FILIAL := xFilial( 'FIE' )
	FIE->FIE_CART   := 'R'
	FIE->FIE_PEDIDO := aSE1[ 8 ]
	FIE->FIE_PREFIX := aSE1[ 1 ] 
	FIE->FIE_NUM    := aSE1[ 2 ] 
	FIE->FIE_PARCEL := cParcela
	FIE->FIE_TIPO   := aSE1[ 3 ] 
	FIE->FIE_CLIENT := aSE1[ 5 ] 
	FIE->FIE_FORNEC := ''
	FIE->FIE_LOJA   := aSE1[ 6 ]
	FIE->FIE_VALOR  := aVenc[ 2 ]
	FIE->FIE_SALDO  := aVenc[ 2 ]
	FIE->( MsUnLock() )
Return	

//-----------------------------------------------------------------------------------
// Rotina | A500GrvFIE   | Autor | Robson Gonçalves               | Data | 17/11/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina que cria o movimento bancário.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
User Function A500SE5( nOpc, aSE1, cParcela, aVenc, dDtCred, aBanco, cHistSE5, cDocSE5 )
	SE5->( RecLock( 'SE5',.T.) )
	SE5->E5_FILIAL  := xFilial('SE5')
	SE5->E5_MOEDA   := 'M1'
	SE5->E5_DATA    := dDtCred
	SE5->E5_VALOR   := aVenc[ 2 ]
	SE5->E5_NATUREZ := aSE1[ 4 ]
	SE5->E5_RECPAG  := 'R'
	SE5->E5_DTDIGIT := dDataBase
	SE5->E5_BANCO   := aBanco[ 1 ]
	SE5->E5_AGENCIA := aBanco[ 2 ]
	SE5->E5_CONTA   := aBanco[ 3 ]
	SE5->E5_DTDISPO := dDtCred
	SE5->E5_DOCUMEN := cDocSE5
	SE5->E5_HISTOR  := cHistSE5
	SE5->E5_PREFIXO := aSE1[ 1 ]
	SE5->E5_NUMERO  := aSE1[ 2 ]
	SE5->E5_PARCELA := cParcela
	SE5->E5_TIPO    := aSE1[ 3 ]
	SE5->E5_CLIFOR  := aSE1[ 5 ]
	SE5->E5_LOJA    := aSE1[ 6 ]
	SE5->E5_FILORIG := '02' //xFilial('SE5')
	SE5->( MsUnlock() )

	IF Len(aSE1) >= 17
		IF aSE1[ 17 ] > 0
			PBS->( dbGoto( aSE1[ 17 ] ) )
			PBS->( RecLock('PBS',.F.) )
				PBS->PBS_RECSE5	:= SE5->( Recno() )
			PBS->( MsUnlock() )
		EndIF
	EndIF
Return

//-----------------------------------------------------------------------------------
// Rotina | My500       | Autor | Robson Gonçalves               | Data | 17/11/2014
//-----------------------------------------------------------------------------------
// Descr. | Rotina para testar o funcionamento geral.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
User Function My500()
	Local nOpc := 3
	Local cCondPagto := '3XA'
	Local aSE1 := {}
	Local lFIE := .T.
	Local lSE5 := .T.
	Local dDtCred := dDataBase
	Local aBanco := {}
	Local cHistSE5 := 'TESTE CSFA500 ' + Dtoc( dDataBase ) + ' ' + Time()
	
	If MsgYesNo( 'Quer testar a rotina U_CSFA500()' , 'CSFA500' )
		//aSE1 := {'TST','20141117A','NF ','000001','000011','01',dDataBase,'PED001','XNPSITE','1234567890','1','PEDGAR01','cID001'}
		//aSE1 := {'TST','20141117B','NF ','000001','000011','01',dDataBase,'PED002','XNPSITE','1234567890','1','PEDGAR01','cID002'}
		//aSE1 := {'TST','20141117C','NF ','000001','000011','01',dDataBase,'PED003','XNPSITE','1234567890','1','PEDGAR01','cID003'}
		aSE1 := {'TST','20141117D','NF ','000001','000011','01',dDataBase,'PED004','XNPSITE','1234567890','1','PEDGAR01','cID004'}
		aBanco := {'341','2901','04814-6'}
		U_CSFA500( nOpc, cCondPagto, 370.00, aSE1, lFIE, lSE5, dDtCred, aBanco, cHistSE5 )
		MsgAlert( 'Rotina executada até seu final de processamento.', 'CSFA500' )
	Endif
Return