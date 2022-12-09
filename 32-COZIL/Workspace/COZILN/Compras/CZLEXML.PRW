 User Function CZLEXML() 
Local cFilename     := "" 
Local cPopServer    := AllTrim( SuperGETMV( "MV_NFEPOP3",, "!@__ERR__@!" ) )   // servidor pop3 do email 
Local cSMTPServer   := AllTrim( SuperGETMV( "MV_NFESMTP",, "!@__ERR__@!" ) )   // servidor smtp do email 
Local cAccount      := AllTrim( SuperGETMV( "MV_NFEMAIL",, "!@__ERR__@!" ) )   // conta de email a ser utilizada para o recebimento dos arquivos 
Local cPwd          := AllTrim( SuperGETMV( "MV_NFEPWD",, "!@__ERR__@!" ) )   // Senha da conta de email para acesso 
Local nPortPop      := SuperGETMV( "MV_NFEPORT",, 110 )                        // Porta de acesso ao pop3, padrao 110 
Local nPopResult    := 0 
Local nAtachDown    := 0 
Local nHandle       := 0 
Local cBaseName := "", cName := ""

Private oMessage 
Private nAtach          := 0 
Private lEnd          := .F. 
Private oProcess     := Nil 
Private nMessage     := 0 
Private nMessages    := 0 
Private nMessagedown := 0
Private nContIRej    := 0
Private nContIAce    := 0
Private oPopServer 
Private nConta       := 0
oPopServer     := TMailManager():New() 
 oPopServer:SetUseSSL(.F.)
 oPopServer:Init( "pop.acasadosmacacos.com.br", "", "xml@acasadosmacacos.com.br", "nfe@2020", 110, 0 )

nPopResult := oPopServer:PopConnect() 

If ( nPopResult == 0 ) 

     //Conta quantas mensagens há no servidor 
     oPopServer:GetNumMsgs( @nMessages ) 

     If ( nMessages > 0 ) 

          oProcess := MsNewProcess():New( { |lEnd| RunProc( lEnd, oProcess ) },; 
               "Processando E-Mail", "Lendo mensagens...", .T. ) 
          oProcess:Activate() 

     Else 

          Alert( "Nao existe nenhuma mensagem na caixa postal." ) 

     EndIf 

     oPopServer:PopDisconnect() 

Else 

     Alert( "Erro na conexao: " + oPopServer:GetErrorString( nPopResult ) ) 

EndIf 

Return 


Static Function RunProc( lEnd, oObj ) 
Local nMessage          := 0 
Local nAtach          := 0 
Local lMessageDown    := .F.
oObj:SetRegua1( nMessages ) 
oMessage := TMailMessage():New() 

// Rastreia cada uma das mensagens no servidor 
For nMessage := 1 To nMessages 

     oObj:IncRegua1( "Lendo Mensagem : " + Transform( nMessage, "@E 999,999" ) ) 
     oMessage:Clear() 
     nPopResult := oMessage:Receive( oPopServer, nMessage ) 

     If ( nPopResult == 0 ) //Recebido com sucesso? 

          //Verifica todos anexos .XML da mensagem e os salva 
          cBaseName := GetSrvProfString( "RootPath", "" )
          if Right( cBaseName, 1 ) <> '\'
             cBaseName += '\'
          endif
          cBaseName += "xmlImport\IN\"

          For nAtach := 1 To oMessage:getAttachCount() 

               aAttInfo     := {} 
               aAttInfo     := oMessage:getAttachInfo( nAtach ) 
 
               //Alert("Anexo: "+str(nAtach,3)+" "+aAttInfo[4],"")

               cName := cBaseName
               if right(aAttInfo[4],4) == ".xml"
                  cName += aAttInfo[4]
               else
                  cName += aAttInfo[4]
                  loop
               endif
               //Alert("Anexo: "+cName,"")

               oObj:SetRegua2( 2 ) 

               oObj:IncRegua2( aAttInfo[ 1 ] ) 
               lSave     := oMessage:SaveAttach( nAtach, cName )
               If !lSave 
                  //Alert( "Nao foi possivel salvar o arquivo " + cName ) 
                  nContIRej++ // arquivos rejeitados por já existirem na pasta 
               Else 
                  nContIAce++ // arquivos aceitos                
               EndIf 

               nConta++

          Next 

       //Deleta mensagem 
        oMessage:SetConfirmRead(.T.) 
        oPopServer:DeleteMsg(nMessage) 
        lMessageDown := .T.

     EndIf 

     If lMessageDown 
        nMessageDown++ 
     EndIf 

Next 

Return 
