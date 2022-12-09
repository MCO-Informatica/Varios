#Include 'Protheus.ch'
//--------------------------------------------------------------------------
// Rotina | MT131MNU    | Autor | Rafael Beghini        | Data | 26.11.2019
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada - Adiciona opcões no Browse de Cotação
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT131MNU()
    aAdd( aRotina , { "® Rejeitar" , "U_MT131Mot()", 0,6,0,Nil } )
Return (aRotina)

//--------------------------------------------------------------------------
// Rotina | MT131Mot    | Autor | Rafael Beghini        | Data | 26.11.2019
//--------------------------------------------------------------------------
// Descr. | Rotina para rejeitar a solicitação
//--------------------------------------------------------------------------
User Function MT131Mot()
	Local oConfirm
	Local oCancel
	Local oGtMotiv
	Local cMotivo := ""
	Local oLblMot

	Static oDlg

	// +--------------------------------------------------------------------------------------+
	// | Monta janela para o usuario informar o motivo da rejeicao da solicitacao de compras. |
	// +--------------------------------------------------------------------------------------+
  	DEFINE MSDIALOG oDlg TITLE "Rejeitar Solicitação de Compras" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL
	
    	@ 015, 004 GET oGtMotiv VAR cMotivo MEMO SIZE 190,057 PIXEL OF oDlg
    	@ 080, 004 BUTTON oConfirm PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION {|| Iif( A131Valid(@cMotivo), oDlg:End(), NIL ) } PIXEL
        @ 006, 004 SAY oLblMot PROMPT "Informe o motivo da rejeição:" SIZE 100, 007 OF oDlg COLORS 0, 16777215 PIXEL
    	@ 080, 053 BUTTON oCancel PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL
	
  	ACTIVATE MSDIALOG oDlg CENTERED
	
Return

//--------------------------------------------------------------------------
// Rotina | A131Valid    | Autor | Rafael Beghini        | Data | 26.11.2019
//--------------------------------------------------------------------------
// Descr. | Verifica se o usuário preencheu o Motivo
//--------------------------------------------------------------------------
Static Function A131Valid( cMotivo )
    Local lRet := .T.

    IF Empty( cMotivo )
        MsgAlert('Informe o motivo para prosseguir com a rejeição.')
        Return .F.
    EndIF
    MT131Rej(cMotivo)
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | MT131Rej    | Autor | Rafael Beghini        | Data | 26.11.2019
//--------------------------------------------------------------------------
// Descr. | Rejeita a solicitação e envia e-mail para o solicitante
//--------------------------------------------------------------------------
Static Function MT131Rej(cMotivo)
    Local aArea     := GetArea()
    Local aDados    := {}
	Local cAssunto  := "Solicitacao de Compras Rejeitada"
    Local cCorpo    := ""
	Local cHtml     := ""
    Local cPara     := ""

    IF Len(aRecMark) > 0
        //-- Verifica se o usuario deseja realmente rejeitar a solicitacao de compras.
        IF MsgYesNo("Deseja rejeitar os itens selecionados?","Atenção")
            For nI := 1 To Len( aRecMark )
                SC1->( dbGoto( aRecMark[ nI ] ) )
                IF Empty( SC1->C1_PEDIDO ) .And. SC1->C1_OK == cMarca
                    RecLock("SC1", .F.)
                        SC1->C1_APROV := "R"
                    MsUnLock()

                    IF AScan( aDados, { |e| e[1] == SC1->C1_NUM .And. e[2] == SC1->C1_SOLICIT } ) == 0 
                        AAdd( aDados, { SC1->C1_NUM, SC1->C1_SOLICIT } )
                    Endif
                EndIF
            Next nI

            IF Len( aDados ) > 0
                For nI := 1 To Len( aDados )
                    //-- Alimenta as variaveis que serao passadas por parametro.
                    cCorpo   := ""
                    cHtml    := ""
                    cPara    := AllTrim( aDados[ nI, 2 ] ) + "@certisign.com.br"
                    
                    //-- Montagem do corpo do e-mail.
                    cCorpo := "<br><p>"
                    cCorpo += "	Segue abaixo informações detalhadas:<br>"
                    cCorpo += "	A solicitação de compras: "    + aDados[ nI, 1 ]   + " foi rejeitada por: <br><br>"
                    cCorpo += "	<strong>Usuario .:</strong> "  + AllTrim(cUserName) + "<br>"
                    cCorpo += "	<strong>E-mail ...:</strong> " + AllTrim(UsrRetMail(__cUserID)) + "<br><br>"
                    cCorpo += "	<strong>Motivo:</strong><br>"
                    cCorpo += "	" + cMotivo + "<br><br><br>"					
                    cCorpo += "</p>"
                    
                    //-- Retorna o HTML completo concatenando o corpo do e-mail.
                    cHtml := u_CSModHtm(cCorpo)

                    //-- Realiza o envio do e-mail.
                    FSSendMail( cPara, cAssunto, cHtml )
                Next nI
            EndIF
        EndIF
    Else
        MsgStop("Nenhum registro foi selecionado. Favor selecionar os registros que deseja rejeitar.")
    EndIF

    RestArea(aArea)
Return