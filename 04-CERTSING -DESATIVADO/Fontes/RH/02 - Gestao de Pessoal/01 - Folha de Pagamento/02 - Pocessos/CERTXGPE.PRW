#INCLUDE "PROTHEUS.CH"

/*+-------------+-----------------------------------------------------------+
  | 10/12/2014  | Alexandre Alves da Silva - OPVS                           |
  +-------------+-----------------------------------------------------------+
  | CERTXGPE    | Biblioteca de funções especificas para uso no modulo GPE. |
  +-------------+-----------------------------------------------------------+
  | Observações | Exclusivo CERTISIGN.                                      |
  +-------------+-----------------------------------------------------------+
*/
User Function CERTXGPE()
Return

User Function PEGACTA(nOper)                                                    
/*
+--------------------+-----------------------------------------------------------------------------------------------------------------------------+
|PEGACTA(nArgumento) | Resgata a conta corrente para deposito de salario do colaborador. Usada em geral em arquivos de configuração de CNAB/SISPAG.|
|                    | nArgumento = 1 = Resgata o numero da Conta Corrente, descartando o ultimo digito subentendendo como DV da conta.            |
|                    | nArgumento = 2 = Resgata o DV da conta, descartando do penultimo numero PARA TRAS, subentendendo como numero da conta.      |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------+
*/
Local cRet   := "0"

If nOper = 1 //-> Conta Corrente.
   cRet   := PADL(SUBS( RIGHT(ALLTRIM(SRA->RA_CTDEPSA),6),1, LEN(RIGHT(ALLTRIM(SRA->RA_CTDEPSA),6))-1 ),06,'0')
ElseIf nOper = 2 //-> DV.
   cRet   := PADL( RIGHT( ALLTRIM(SRA->RA_CTDEPSA),1 ) ,01,'0' )   
EndIf


Return cRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} CSMV_TCF()
Rotina desenvolvida para o usuário do RH alterar os parâmetros
pertinentes aos demonstrativos de pagamentos no portal de Gestão do Capital Humano.  

@author	Rafael Beghini
@since	15/05/2019
@version 12
/*/
//-----------------------------------------------------------------------
User Function CSMV_TCF()
  Local oDlg
	Local oLbx
	Local oPanel 
	Local nI        := 0
	Local aParamSX6 := {}
  Local CSMV_TCF  := 'MV_XTCFPAR'

	Private aSX6    := {}
  Private aAlter  := {}

  If .NOT. SX6->( ExisteSX6( CSMV_TCF ) )
		CriarSX6( CSMV_TCF, 'C', 'Parâmetros que podem ser alterados via rotina do RH CERTXGPE.prw',;
              'MV_TCF013A,MV_TCFD131,MV_TCFD132,MV_TCFDADT,MV_TCFDEMO,MV_TCFDEXT,MV_TCFDFOL,MV_TCFMARC,MV_TCFMFEC,MV_TCFQHOL,MV_TCFVREN' )
	Endif
	
  //Armazena conteudo da conversa no array
  aParamSX6 := StrToArray( GetMv( CSMV_TCF ),',' )

  SX6->( dbSetOrder( 1 ) )
  For nI := 1 To Len( aParamSX6 )
    If SX6->( dbSeek( xFilial( 'SX6' ) + aParamSX6[ nI ] ) )
      SX6->( AAdd( aSX6, { X6_VAR, RTrim(X6_DESCRIC)+' '+RTrim(X6_DESC1)+' '+RTrim(X6_DESC2), X6_TIPO, rTrim(X6_CONTEUD) } ) )
    Endif
  Next nI

  If Len( aSX6 ) > 0
    DEFINE MSDIALOG oDlg TITLE "Parâmetros da Rotina" FROM 180,180  TO 500,1200 PIXEL
      oDlg:lEscClose := .F.
      @ 10, 10 TO 135,500 of oDlg PIXEL
      @ 20, 15 SAY "Parâmetros pertinentes aos demonstrativos de pagamentos no portal GCH" SIZE 200,15 of oDlg PIXEL
      @ 140, 10 BUTTON '&Editar' SIZE 030, 015 PIXEL OF oDlg ACTION EdtSX6( @oLbx )
      @ 140, 50 BUTTON '&Sair  ' SIZE 030, 015 PIXEL OF oDlg ACTION (Notifica(),oDlg:End())
      
      oLbx := TWBrowse():New( 40 , 15, 480,90,,{'Parâmetro','Descrição','Tipo','Conteúdo'},{40,40,20,40,50,60},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )  
          
      oLbx:SetArray(aSX6) 
      oLbx:bLine := {|| aEval( aSX6[oLbx:nAt],{|z,w| aSX6[oLbx:nAt,w]})}
      oLbx:BlDblClick := {|| EdtSX6( @oLbx ) }
      oLbx:lColDrag    := .T.
            
    ACTIVATE MSDIALOG oDlg CENTERED
  Else
    MsgAlert('Parâmetro [MV_XTCFPAR] inválido, verifique com Sistemas Corporativos','CSMV_TCF')
  Endif
  
Return
//-----------------------------------------------------------------------
/*/{Protheus.doc} EdtSX6()
Rotina que abre o Parambox para editar o parâmetro

@author	Rafael Beghini
@since	16/05/2019
@version 12
/*/
//-----------------------------------------------------------------------
Static Function EdtSX6( oLbx )
	Local aPar := {}
	Local aRet := {}
	Local cX6_VAR := aSX6[ oLbx:nAt, 1 ]
	Local cX6_CONTEUD := RTrim( aSX6[ oLbx:nAt, 4 ] )
	AAdd( aPar,{ 1, 'Conteúdo do parâmetro',(cX6_CONTEUD + Space( 250 - Len( cX6_CONTEUD ) )),'','','','',120,.F.})
	If ParamBox( aPar,'Editar parâmetro', @aRet )
		If Upper( cX6_CONTEUD ) <> Upper( RTrim( aRet[ 1 ] ) )
			PutMv( cX6_VAR, aRet[ 1 ] )
			aSX6[ oLbx:nAt, 4 ] := aRet[ 1 ]
			oLbx:Refresh()
      aADD( aAlter, { cX6_VAR, cX6_CONTEUD, Upper( RTrim( aRet[ 1 ] ) ) } )
			MsgInfo('Parâmetro modificado com sucesso.', 'CSMV_TCF')
		Endif
	Endif
Return
//-----------------------------------------------------------------------
/*/{Protheus.doc} Notifica()
Rotina para notificar Sistemas da alteração realizada

@author	Rafael Beghini
@since	16/05/2019
@version 12
/*/
//-----------------------------------------------------------------------
Static Function Notifica()
  Local cMail     := 'sistemascorporativos@certisign.com.br'
  Local cBody     := ''
  Local cFileHTML := ''
  Local cTemplate := '\htmls\CSMV_TCF.htm'
  Local lSrvTst   := GetServerIP() $ GetMv( 'MV_610_IP', .F. )
  Local cAssunto  := IIF( lSrvTst, "[TESTE] ", "" ) + 'Alteração parâmetros demonstrativos GCH'
  Local nI        := 0

  IF Len( aAlter ) > 0
    cFileHTML := '\htmls\' + CriaTrab( NIL, .F. ) + '.htm'	

    oHTML := TWFHtml():New( cTemplate )
	
	  oHTML:ValByName( 'cUSER' , Upper(Alltrim(cUserName)) )

    For nI := 1 To Len(aAlter)
	   aAdd(oHTML:ValByName( "a.cParam" ) , aAlter[nI,1] )
	   aAdd(oHTML:ValByName( "a.cOld"   ) , aAlter[nI,2] )
	   aAdd(oHTML:ValByName( "a.cNew"   ) , aAlter[nI,3] )	  
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
  EndIF
Return