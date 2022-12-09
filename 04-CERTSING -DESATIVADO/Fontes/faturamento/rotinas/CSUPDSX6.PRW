#Include 'Protheus.ch'
#Include "Topconn.ch"
#Include 'Ap5Mail.ch'
#Include "COLORS.CH"

//+-------------------------------------------------------------------+
//| Rotina | CSUPDSX6 | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para alterar os parâmetros do ERP
//|        | Desenvolvida para não acessar o APSDU
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSUPDSX6()
  Local aC      := FWGetDialogSize(oMainWnd)
  Local cOrd    := ''
  Local cSeek   := Space(100)
  Local nOrd    := 1
  Local aOrdem  := {}
  Local oDlg
  Local oLbx
  Local oFWLayer
  Local oWinPar, oWinRet
  Local oBtnS
  Local oTPanelPar, oTPanelRet
  Local oOrdem, oSeek, oPesq
  
  Private aSX6    := {}
  Private aAlter  := {}

  AAdd(aOrdem,'Nome do parâmetro') 

  dbSelectArea("SX6")
  dbSetOrder(1)
  dbGotop()
  While .NOT. Eof()
    SX6->( AAdd( aSX6, { X6_FIL, X6_VAR, RTrim(X6_DESCRIC)+' '+RTrim(X6_DESC1)+' '+RTrim(X6_DESC2), X6_TIPO, rTrim(X6_CONTEUD) } ) )
    dbSkip()
  End

  IF Len( aSX6 ) > 0
    DEFINE MSDIALOG oDlg TITLE '' OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
      oDlg:lEscClose := .F.
      oFWLayer := FWLayer():New()	
      oFWLayer:Init( oDlg, .F. )

      oFWLayer:AddCollumn( "Col01", 100, .T. )

      oFWLayer:AddWindow( "Col01", "Win01", "Alteração parâmetros ERP (SX6)"  , 19, .F., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
      oFWLayer:AddWindow( "Col01", "Win02", ""     , 81, .F., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)

      oWinPar  := oFWLayer:GetWinPanel('Col01','Win01')
      oWinRet  := oFWLayer:GetWinPanel('Col01','Win02')

      oTPanelPar := TPanel():New(0,0,"",oWinPar,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
      oTPanelPar:Align := CONTROL_ALIGN_ALLCLIENT

      oTPanelRet := TPanel():New(0,0,"",oWinRet,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
      oTPanelRet:Align := CONTROL_ALIGN_ALLCLIENT

      @ 01,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,50 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oTPanelPar
      @ 01,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oTPanelPar
      @ 01,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oTPanelPar ACTION (PesqSx6(nOrd,Upper(cSeek),@oLbx))

      @ 20,003 SAY 'Clique 2 vezes no registro para alterar o conteúdo.' SIZE 200,10 PIXEL COLOR CLR_HBLUE OF oTPanelPar
      oLbx := TWBrowse():New( 0,0,0,0,,{'Filial','Parâmetro','Descrição','Tipo','Conteúdo'},{10,40,60,20,50},oTPanelRet,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )  

      oLbx:SetArray(aSX6) 
      oLbx:bLine := {|| aEval( aSX6[oLbx:nAt],{|z,w| aSX6[oLbx:nAt,w]})}
      oLbx:BlDblClick := {|| EdtSX6( @oLbx ) }
      oLbx:lColDrag    := .T.
      oLbx:Align := CONTROL_ALIGN_ALLCLIENT


      @ 1,305 	BUTTON oBtnS ;
      PROMPT "&Sair" ;
      SIZE 40,11 ;
      DIALOG oTPanelPar ;
      PIXEL ACTION (Notifica(),oDlg:End())
    ACTIVATE DIALOG oDlg CENTERED
  Else
    MsgAlert('Erro')
  Endif  
Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} PesqSx6()
Rotina para pesquisar o parâmetro digitado e posicionar

@author	Rafael Beghini
@since	31/07/2019
@version 12
/*/
//-----------------------------------------------------------------------
Static Function PesqSx6( nOrd, cSeek, oLbx )
  Local bAScan := {|| .T. }
  Local nBegin := 0
  Local nColPesq := 2
  Local nEnd := 0
  Local nP := 0

  IF nColPesq > 0
    nBegin := Min( oLbx:nAt + 1, Len( oLbx:aArray ) )
    nEnd   := Len( oLbx:aArray )

    IF oLbx:nAt == Len( oLbx:aArray )
      nBegin := 1
    EndIF

    bAScan := {|p| Upper(AllTrim( cSeek ) ) $ AllTrim( p[nColPesq] ) } 

    nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )

    IF nP > 0
      oLbx:nAt := nP
      oLbx:Refresh()
    Else
      MsgInfo('Informação não localizada.','Pesquisar')
    EndIF
  EndIF
Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} EdtSX6()
Rotina que abre o Parambox para editar o parâmetro

@author	Rafael Beghini
@since	31/07/2019
@version 12
/*/
//-----------------------------------------------------------------------
Static Function EdtSX6( oLbx )
  Local aPar := {}
  Local aRet := {}
  Local cX6_FIL := aSX6[ oLbx:nAt, 1 ]
  Local cX6_VAR := aSX6[ oLbx:nAt, 2 ]
  Local cX6_CONTEUD := RTrim( aSX6[ oLbx:nAt, 5 ] )
  
  AAdd( aPar,{ 1, 'Conteúdo do parâmetro',(cX6_CONTEUD + Space( 250 - Len( cX6_CONTEUD ) )),'','','','',120,.F.})
  
  If ParamBox( aPar,'Editar parâmetro', @aRet )
    If Upper( cX6_CONTEUD ) <> Upper( RTrim( aRet[ 1 ] ) )
      PutMv( cX6_VAR, aRet[ 1 ] )
      aSX6[ oLbx:nAt, 5 ] := aRet[ 1 ]
      oLbx:Refresh()
      aADD( aAlter, { cX6_FIL, cX6_VAR, cX6_CONTEUD, Upper( RTrim( aRet[ 1 ] ) ) } )
      MsgInfo( 'Parâmetro modificado com sucesso.', 'CSUPDSX6' )
    Endif
  Endif
Return
//-----------------------------------------------------------------------
/*/{Protheus.doc} Notifica()
Rotina para notificar Sistemas da alteração realizada

@author	Rafael Beghini
@since	31/07/2019
@version 12
/*/
//-----------------------------------------------------------------------
Static Function Notifica()
  Local cMail     := GetNewPar('MV_SISCOR','sistemascorporativos@certisign.com.br')
  Local cBody     := ''
  Local cFileHTML := ''
  Local cIdCV8    := ''
  Local cTemplate := '\htmls\CSUPDSX6.htm'
  Local cDetalhes := ''
  Local lSrvTst   := GetServerIP() $ GetMv( 'MV_610_IP', .F. )
  Local cAssunto  := IIF( lSrvTst, "[TESTE] ", "" ) + 'Alteração parâmetros ERP'
  Local nI        := 0

  IF Len( aAlter ) > 0
    cFileHTML := '\htmls\' + CriaTrab( NIL, .F. ) + '.htm'	

    oHTML := TWFHtml():New( cTemplate )

    oHTML:ValByName( 'cUSER' , Upper(Alltrim(cUserName)) )

    cDetalhes += Padr('Parâmetro',13,'')  + '| ' + Padr('Conteudo Ant.',13,'') + '| '	 + Padr('Conteúdo Novo',13,'') + CRLF

    For nI := 1 To Len(aAlter)
      aAdd(oHTML:ValByName( "a.cParam" ) , aAlter[nI,1] + '-' + aAlter[nI,2] )
      aAdd(oHTML:ValByName( "a.cOld"   ) , aAlter[nI,3] )
      aAdd(oHTML:ValByName( "a.cNew"   ) , aAlter[nI,4] )
      cDetalhes += Padr(aAlter[nI,1] + '-' + aAlter[nI,2],13,'') + '| ' + Padr(aAlter[nI,3],13,'')    + '| '	 + Padr(aAlter[nI,4],13,'') + CRLF
    Next nI

    oHTML:SaveFile( cFileHTML )
    Sleep(500)

    If File( cFileHTML )
      cBody := ''
      FT_FUSE( cFileHTML )
      FT_FGOTOP()
      While .NOT. FT_FEOF()
        cBody += FT_FREADLN()
        FT_FSKIP()
      End
      FT_FUSE()

      FSSendMail( cMail, cAssunto, cBody, /*cAnexo*/ )        
      Ferase( cFileHTML )
    Else
      ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
    Endif

    //Grava informações na tabela CV8
    cIdCV8  := GetSXENum("CV8","CV8_IDMOV",,5)
    ConfirmSX8()
    GravaCV8('6', 'CSUPDSX6', 'Alteração parâmetros ERP', cDetalhes, '', '', .T., cIdCV8)
  EndIF
Return