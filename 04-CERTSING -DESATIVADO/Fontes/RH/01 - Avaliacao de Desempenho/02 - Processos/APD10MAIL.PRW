//+-------------------------------------------
//|Função: APD10MAIL - Envio de e-mail
//+-------------------------------------------
Static Function APD10MAIL( cEmail, cNOME, cMSG )
Local oHTML
Local cBody      := ''
Local cTemplate  := ''
Local cFileHTML  := ''
Local lRet       := .F.
cTemplate := cMV_APD05 + cMV_APD06
cFileHTML := cMV_APD05 + CriaTrab( NIL, .F. ) + '.htm'
 
oHTML := TWFHtml():New( cTemplate )
oHTML:ValByName( 'cNOME', cNOME ) 
oHTML:ValByName( 'cMSG' , cMSG  )
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
lRet := FSSendMail( cEmail, 'Portal RH - Planos e Metas', cBody, /*cAnexo*/ )
IF lRet
MsgInfo(cFONTOK+'E-mail enviado com sucesso para o participante.',cCadastro)
Conout( 'FSSendMail > [CSAPD010] | E-mail: ' + cEmail + ' Assunto: Inclusão de plano/metas' )
EndIF
Ferase( cFileHTML )
Else
ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
Endif
Return
