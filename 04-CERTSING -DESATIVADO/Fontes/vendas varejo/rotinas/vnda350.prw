/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA350    �Autor  �                    � Data �  11/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte criado para gerar o codigo do voucher.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VNDA350()
	Local lIsThread := .F.
	Local cVoucher := ""
	Local cCodUsr := RetCodUsr()
	
	If ( ValType( cCodUsr ) == NIL .OR. Empty( cCodUsr ) .OR. cCodUsr == "000000" )
		lIsThread := .T.
		cCodUsr := cValToChar( ThreadID() )
		If Len( cCodUsr ) > 6
			cCodUsr := Right( cCodUsr, 6 )
		Endif
	Endif
	
	cVoucher := Algoritmo( cCodUsr, lIsThread )
	
	SZF->( DbSetOrder( 2 ) ) 
	While SZF->( DbSeek( xFilial( "SZF" ) + cVoucher ) )
		cVoucher := Algoritmo( cCodUsr, lIsThread )
	End
	
Return( cVoucher )

//-------------------------------------------------------------------
// Rotina | Algoritmo | Autor | Robson e Giovanni | Data | 11.03.2016
//-------------------------------------------------------------------
// Descr. | Elaborar o n�mero do Voucher conforme par�metros.
//-------------------------------------------------------------------
// Uso    | Certisign Certificadora S.A.
//-------------------------------------------------------------------
Static Function Algoritmo( cCodUsr, lIsThread )
	Local cNumero := ""
	Local cDigito := ""
	Local cVoucher := ""
	Local nData := 0
	Local nUser := 0
	Local nSecond := 0
	Local nLimite := 0
	
	Sleep( Randomize( 1, 999 ) )
	
	nData    := Val( Dtos( Date() ) )
	nUser    := Val( cCodUsr )
	nSecond  := Val( StrTran( LTrim( StrZero( Seconds(), 9, 3 ) ), ".", "" ) )
	cNumero  := StrZero( ( nData +  nUser + nSecond ), 9, 0 )
	cDigito  := Modulo11( cNumero )
	cVoucher := cNumero + cDigito
	nLimite  := Iif( lIsThread, 10, 11 )
	
	If Len( cVoucher ) < nLimite
		While Len( cVoucher ) < nLimite
			cDigito := Modulo11( cVoucher )
			cVoucher := cVoucher + cDigito 
		End
	Endif
	
	If lIsThread
		cVoucher := cVoucher + "H"
	Endif
	
	cVoucher := Embaralha( cVoucher, 0 )
	
Return( cVoucher )