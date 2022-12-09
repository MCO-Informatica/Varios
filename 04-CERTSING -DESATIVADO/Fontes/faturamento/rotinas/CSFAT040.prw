#include 'totvs.ch'
#Include 'Protheus.ch'

Static cRetorno := ''

//---------------------------------------------------------------
// Rotina | CSFAT040 | Autor | Rafael Beghini | Data | 08/01/2016 
//---------------------------------------------------------------
// Descr. | Rotina para informar o código do solicitante do    
//        | voucher conforme tipo do Voucher selecionado.
//---------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//---------------------------------------------------------------
User Function CSFAT040()

	Local cQuery  := ''
	Local cAlias1 := ''
	Local cOrd    := ''
	Local aOrdem  := {}
	Local nOrd    := 1
	Local cSeek   := Space(100)
	
	Private cCodVou  := ''
	Private cMV_CodV := 'MV_CSFAT40'
	Private cCodigo  := ''
	Private cSolicit := Space(200)
	Private oLst     := Nil
	Private oDlg     := Nil
	Private oOrdem   := Nil
	Private oSeek    := Nil
	Private oPesq    := Nil
	Private _bRet    := .F.
	Private aDados   := {} 
	
	AAdd(aOrdem,'Nome do Solicitante') 
	AAdd(aOrdem,'Código')
	
	IF .Not. GetMv( cMV_CodV, .T. )
		CriarSX6( cMV_CodV,'C','Códigos Voucher que permitem utilizar o campo Solicitante na geração do voucher. CSFAT040.prw', '3,4,5,8,9,D,E,F,G,7')
	EndIF
	
	cCodVou := GetMv( cMV_CodV )
	
	cRetorno := ''
	
	IF M->ZF_TIPOVOU $ cCodVou
		cQuery := " SELECT PB2_CODIGO, PB2_NOME, PB2_NOMVOU, QB_DESCRIC "
		cQuery += " FROM "+RetSQLName("PB2") + " PB2 "
		cQuery += " LEFT JOIN " + RetSQLName("SQB") + " SQB "
		cQuery += " ON QB_DEPTO = PB2_DEPTO AND SQB.D_E_L_E_T_= ' ' "
		cQuery += " WHERE PB2.D_E_L_E_T_= ' ' " 
		cQuery += " AND PB2_MSBLQL <> '1' " 
		cQuery += " ORDER BY PB2_CODIGO ASC " 
		
		cAlias1:= CriaTrab(Nil,.F.) 
		
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.) 
		
		(cAlias1)->(DbGoTop()) 
		
		If (cAlias1)->(Eof())
			MsgInfo( 'Não existe dados na tabela, verifique.' )
			Return .F.
		Endif
		
		Do While (cAlias1)->(!Eof())
			aAdd( aDados, { (cAlias1)->PB2_CODIGO, Alltrim( (cAlias1)->PB2_NOME ), Alltrim( (cAlias1)->PB2_NOMVOU ), (cAlias1)->QB_DESCRIC } )
			(cAlias1)->(DbSkip())
		Enddo 
		
		DbCloseArea(cAlias1)
		
		//--Montagem da Tela
		Define MsDialog oDlg Title "Solicitantes Voucher" From 0,0 To 300, 600 Of oMainWnd Pixel
		
		@ 001,005 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 75,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oDlg
		@ 001,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oDlg
		@ 001,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oDlg ACTION (A040Pesq(nOrd,cSeek,@oLst))
		
		@ 015,005 LISTBOX oLst Fields HEADER "Código", "Nome Completo", "Nome Voucher", "Departamento" ;
		      SIZE 295,110 On DblClick ( A040Conf(oLst:nAt, @aDados, @_bRet) ) OF oDlg PIXEL
		
			oLst:SetArray(aDados)
		
			oLst:nAt := 1
		
			oLst:bLine := { || { aDados[oLst:nAt,1], aDados[oLst:nAt,2], aDados[oLst:nAt,3], aDados[oLst:nAt,4] } }
		
			DEFINE SBUTTON FROM 130,005 TYPE 1 ACTION A040Conf(oLst:nAt, @aDados, @_bRet) ENABLE OF oDlg 
		
			DEFINE SBUTTON FROM 130,040 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg 
		
		Activate MSDialog oDlg Centered
	Else
		Define MsDialog oDlg Title "Cadastro de Voucher" From 0,0 To 240, 500 Of oMainWnd Pixel
		
		@ 003,005 TO 082,250 LABEL "Informar o solicitante do Voucher" OF oDlg PIXEL
		@ 015,010 MsGet cSolicit Picture '@!' Size 200,010 PIXEL OF oDlg
		
		DEFINE SBUTTON FROM 100,5 TYPE 1 ACTION CSFAT40B(cSolicit) ENABLE OF oDlg 
	
		DEFINE SBUTTON FROM 100,40 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg 
		
		Activate MSDialog oDlg Centered
	EndIF
	
Return .T.

//-------------------------------------------------------------------------
// Rotina | A040Conf   | Autor | Rafael Beghini     | Data | 15/01/2016
//-------------------------------------------------------------------------
// Descr. | Rotina que descarrega o codigo e nome do solicitante informado.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-------------------------------------------------------------------------
Static Function A040Conf(_nPos, aDados, _bRet)
	cCodigo := aDados[_nPos,1]
	cRetorno := ''
	
	_bRet := .T.
	IF M->ZF_TIPOVOU $ cCodVou	
		M->ZF_USRSOL := Posicione( 'PB2', 1, xFilial("PB2")+ cCodigo, 'PB2_NOMVOU' )
		cRetorno := cCodigo
	EndIF
	
	oDlg:End()
Return _bRet

//---------------------------------------------------------------------------
// Rotina | CSFAT40A   | Autor | Rafael Beghini     | Data | 15/01/2016
//---------------------------------------------------------------------------
// Descr. | Retorno da Consulta padrão utilizada no campo Código Solicitante
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//---------------------------------------------------------------------------
User Function CSFAT40A() 
Return(cRetorno)

//-----------------------------------------------------------------------
// Rotina | CSFAT40B   | Autor | Rafael Beghini     | Data | 15/01/2016
//-----------------------------------------------------------------------
// Descr. | Rotina que descarrega o nome do solicitante informado.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CSFAT40B( cSolicit )
	M->ZF_USRSOL := Subst( rTrim( cSolicit ), 1, 40 )
	oDlg:End()
Return .T.

//-----------------------------------------------------------------------
// Rotina | A040Pesq   | Autor | Rafael Beghini     | Data | 15/01/2016
//-----------------------------------------------------------------------
// Descr. | Rotina de pesquisa na interface de seleção do solicitante.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A040Pesq( nOrd, cSeek, oLbx )
	Local bAScan := {|| .T. }

	Local nBegin := 0
	Local nColPesq := 0
	Local nEnd := 0
	Local nP := 0
	
	nColPesq := Iif( nOrd == 1, 2, Iif( nOrd == 2, 1, ( MsgAlert('Opção não disponível para pesquisar.','Pesquisar'), 0 ) ) )
		
	If nColPesq > 0
		nBegin := Min( oLbx:nAt + 1, Len( oLbx:aArray ) )
		nEnd   := Len( oLbx:aArray )
		
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		Endif
		
		bAScan := {|p| Upper(AllTrim( cSeek ) ) $ Upper(AllTrim( p[nColPesq] )) } 
		
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )

		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('Informação não localizada.','Pesquisar')
		Endif
	Endif
Return