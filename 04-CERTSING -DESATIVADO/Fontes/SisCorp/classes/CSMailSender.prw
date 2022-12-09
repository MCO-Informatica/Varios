#INCLUDE "PROTHEUS.CH"
#Include 'AP5MAIL.ch'

#DEFINE STR_MAIL_STATUS     'STATUS: '
#DEFINE STR_MAIL_NOT_SENT   'Não foi possível enviar o e-mail. Verifique: '
#DEFINE STR_MAIL_NOT_AUTH   'Não foi possível autenticar com o Login e Senha informados.'
#DEFINE STR_MAIL_NOT_CONN   'Não foi possível conectar ao servidor de E-mails.'
#DEFINE STR_MAIL_SENT       'E-mail enviado com sucesso.'
#DEFINE STR_BAD_USER_PASS   'Usuário ou senha não enviados.'
#DEFINE STR_BAD_SERVER_DATA 'Dados do Servidor de E-mail inválidos'
#DEFINE STR_NOT_ATTACHED    'Não foi possível anexar o arquivo selecionado.'
#DEFINE STR_DEST_NOT_SET    'Mensagem não enviada: Não foi especificado um destinatário.'
#DEFINE STR_FILE_404        "O arquivo indicado não existe e não foi anexado."

Class CSMailSender

    Data cMailServer
    Data cMailLogin
    Data cMailSenha
    Data nTimeOut
    Data lResultConn
    Data lResultSend
    Data lSMTPAuth
    Data cSubject
    Data cMailDest
    Data cMailRem
    Data cBody
    Data cSMTPUser     
    Data cSMTPPassword       
    Data lResultAuth
    Data aAnexos       
    Data cMailStatus
    Data cAttachStatus
    Data lCompressAttach
    Data lConnected

    Method New() Constructor
    Method Attach(cAnexo)
    Method Connect(cMailServer, cMailLogin, cMailSenha, nTimeOut, lSMTPAuth) 
    Method SendMail()
    Method AuthSMTP(cMailLogin, cMailSenha)
    Method Disconnect()
    Method setMailBody(cBody)
    Method CompressAttach()
    Method getAttachments()
    Method getAttachCount()
    Method hasAttachments()
    Method setMailSubject(cSubject)
    Method getAttachString()
    Method setMailRemetente(cRemetente)
    Method setMailDestinatario(cDestinatario)
    Method setCompressAttachments(lCompress)

EndClass

/*/{Protheus.doc} New
Método Construtor. Recebe dois arrays com os dados do servidor e da mensagem.
Quando não recebe parâmetros, tenta buscar dos parâmetros default de relatório.
Os parâmetros não são obrigatórios e podem ser setados como propriedades do objeto.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@Param      aServerData (array), aMessageData (array)
                aServerData => 
                    aServerData[1] = Servidor -> C
                    aServerData[2] = Usuário -> C
                    aServerData[3] = Senha -> C
                    aServerData[4] = STMP Requer autenticação -> L
                    aServerData[5] = Usuário Autenticação SMTP -> C
                    aServerData[6] = Senha Autenticação SMTP -> C

                aMessageData =>
                    aMessageData[1] = Destinatário -> C
                    aMessageData[2] = Remetente -> C
                    aMessageData[3] = Assunto -> C
                    aMessageData[4] = Corpo da Mensagem -> C
                    aMessageData[5] = Anexos -> A   
*/
Method New(aServerData, aMessageData) Class CSMailSender

    DEFAULT aServerData     := {}
    DEFAULT aMessageData    := {}

    ::cMailServer   := Iif(Len(aServerData) > 0, aServerData[1], GetMv("MV_RELSERV"))
    ::cMailLogin    := Iif(Len(aServerData) > 1, aServerData[2], GetMv("MV_RELACNT"))
    ::cMailSenha    := Iif(Len(aServerData) > 2, aServerData[3], GetMv("MV_RELAPSW"))
    ::lSMTPAuth     := Iif(Len(aServerData) > 3, aServerData[4], GetMv("MV_RELAUTH"))
    ::cSMTPUser     := Iif(Len(aServerData) > 4, aServerData[5], GetMv("MV_RELACNT"))
    ::cSMTPPassword := Iif(Len(aServerData) > 5, aServerData[6], GetMv("MV_RELAPSW"))
    ::nTimeOut      := 0
    ::lResultConn   := .F.
    ::lResultSend   := .F.
    ::lResultAuth   := .T.
    ::cMailRem      := Iif(Len(aMessageData) > 1, aMessageData[2], GetMv("MV_RELFROM"))
    ::cMailDest     := Iif(Len(aMessageData) > 0, aMessageData[1], "")
    ::cSubject      := Iif(Len(aMessageData) > 2, aMessageData[3], "")
    ::cBody         := Iif(Len(aMessageData) > 3, aMessageData[4], "")
    ::aAnexos       := Iif(Len(aMessageData) > 4, aMessageData[5], {})

    ::cMailStatus   := ""
    ::cAttachStatus := ""
    ::lCompressAttach := .F.

Return

/*/{Protheus.doc} Connect
Tenta se conectar ao servidor SMTP e autenticar no SMTP, caso necessário.
A propriedade lResultAuth por default é definida como .T., uma vez que nem
sempre é necessária a autenticação no SMTP e ela não deve obstruir o 
processo de conexão.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cMailServer (char)  Servidor de E-mail
@param      cMailLogin (char)   Login para autenticar no servidor
@param      cMailSenha (char)   Senha para autenticar no servidor
@param      nTimeOut (int)      Tempo para timeout se não houver resposta
@param      lSMTPAuth (bool)    Informa necessidade de autenticar no SMTP 

@return     lResultConn (bool)  Retorna se a conexão foi realizada com sucesso
*/
Method Connect(cMailServer, cMailLogin, cMailSenha, nTimeOut, lSMTPAuth) Class CSMailSender

    Local cMailErro     := ""
    Local lResultConn   := .F.

    DEFAULT cMailServer   := ::cMailServer
    DEFAULT cMailLogin    := ::cMailLogin
    DEFAULT cMailSenha    := ::cMailSenha
    DEFAULT nTimeOut      := ::nTimeOut
    DEFAULT lSMTPAuth     := ::lSMTPAuth

    // Caso dados de conexão estejam vazios, grava mensagem de erro em atributo e cancela conexão
    If Empty(cMailServer) .Or. Empty(cMailLogin) .Or. Empty(cMailSenha)
        ::cMailStatus := STR_BAD_SERVER_DATA
        Return .F.
    EndIf

    CONNECT SMTP SERVER cMailServer ACCOUNT cMailLogin PASSWORD cMailSenha TIMEOUT nTimeOut RESULT lResultConn

    // Caso não consiga a conexão, salva o erro
    If !lResultConn
        GET MAIL ERROR cMailErro
        ::cMailStatus := STR_MAIL_NOT_CONN + cMailErro
    EndIf

    ::lResultConn := lResultConn

    // Tenta a autenticação, caso necessário
    If ::lSMTPAuth
        ::lResultAuth := ::AuthSMTP(::cSMTPUser, ::cSMTPPassword)
    EndIf

    // Considerará conectado se a conexão e a autenticação forem bem sucedidas
    ::lConnected := ::lResultConn .And. ::lResultAuth

Return ::lConnected

/*/{Protheus.doc} AuthSMTP
Tenta realizar a autenticação no servidor SMTP, quando necessário.
Alguns servidores requerem que, para o envio de e-mails, seja realizada
a autenticação no SMTP, além da autenticação básica do servidor.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cMailServer (char)  Servidor de E-mail
@param      cMailLogin (char)   Login para autenticar no servidor
@param      cMailSenha (char)   Senha para autenticar no servidor
@param      nTimeOut (int)      Tempo para timeout se não houver resposta
@param      lSMTPAuth (bool)    Informa necessidade de autenticar no SMTP       

@return     lResultAuth (bool)  Informa se a autenticação foi realizada com sucessp
*/
Method AuthSMTP(cMailLogin, cMailSenha) Class CSMailSender

    DEFAULT cMailLogin := ::cMailLogin
    DEFAULT cMailSenha := ::cMailSenha

    If Empty(cMailLogin) .Or. Empty(cMailSenha)
        ::cMailStatus := STR_BAD_USER_PASS
        Return ::lResultAuth := .F.
    EndIf

    ::lResultAuth := MailAuth(cMailLogin, cMailSenha)

    If !::lResultAuth
        ::cMailStatus := STR_MAIL_NOT_AUTH
    EndIf

Return ::lResultAuth

/*/{Protheus.doc} setMailRemetente
Modifica o e-mail do remetente do e-mail.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cRemetente (char)  Endereço de e-mail do remetente

@return     null
*/
Method setMailRemetente(cRemetente) Class CSMailSender
    ::cMailRem := cRemetente
Return

/*/{Protheus.doc} setMailDestinatario
Modifica o e-mail do destinatário do e-mail.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cRemetente (char)  Endereço de e-mail do destinatário

@return     null
*/
Method setMailDestinatario(cDestinatario) Class CSMailSender
    ::cMailDest := cDestinatario
Return

/*/{Protheus.doc} setMailRemetente
Modifica o corpo da mensagem de e-mail.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cBody (char)  Corpo da mensagem de e-mail

@return     null
*/
Method setMailBody(cBody) Class CSMailSender
    ::cBody := cBody
Return

/*/{Protheus.doc} setMailSubject
Modifica o assunto da mensagem de e-mail.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cSubject (char)  Assunto da mensagem.

@return     null
*/
Method setMailSubject(cSubject) Class CSMailSender
    ::cSubject := cSubject
Return

/*/{Protheus.doc} Attach
Anexa um arquivo à mensagem a ser disparada

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      cAnexo (char)  Caminho completo do arquivo a ser anexado.

@return     lAttached (bool) Informa se o arquivo foi anexado corretamente.
*/
Method Attach(cAnexo) Class CSMailSender

    Local cAttachDir    := getAttachDir()
    Local cFileName     := AllTrim(Substr(cAnexo, rat("\", cAnexo) + 1))

    If File(cAnexo)
        If CPYT2S(cAnexo, cAttachDir)
            aAdd(::aAnexos, cAttachDir + cFileName)
        Else
            ::cAttachStatus := STR_NOT_ATTACHED
            Return .F.
        EndIf
    Else
        ::cAttachStatus := STR_FILE_404
        Return .F.
    EndIf

Return .T.

/*/{Protheus.doc} getAttachDir
Recupera e cria, se necessário, o Path que armazenará os arquivos anexos

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      null

@return     cDir (string)   Diretório apto para gravar os arquivos anexos no servidor
*/
Static Function getAttachDir()

    Local cDir := "\mailtmp\"
    Local cCodUsuario := RetCodUsr()
    Local cData := DTOS(Date())

    // Verifica raiz \mailtmp\
    If !ExistDir(cDir)
        MakeDir(cDir)
    EndIf

    // Adiciona o código do usuário e verifica se existe o diretório
    cDir += cCodUsuario
    If !ExistDir(cDir)
        MakeDir(cDir)
    EndIf

    // Adiciona a data do envio do e-mail e verifica se existe
    cDir += "\" + cData
    If !ExistDir(cDir)
        MakeDir(cDir)
    EndIf    

    cDir += "\"

Return cDir

/*/{Protheus.doc} hasAttachments
Retorna se há anexos incluídos ao objeto

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      null

@return     nAttachments (int) Informa o número de arquivos anexos.
*/
Method hasAttachments() Class CSMailSender
Return Len(::aAnexos) > 0

/*/{Protheus.doc} getAttachmentString
Retorna uma string com a relação de arquivos anexos, separados por
ponto-e-vírgula (";")

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      null

@return     cAttachments (char) Lista de arquivos anexos
*/
Method getAttachString() Class CSMailSender

    Local cAnexos := ""
    Local Ni := 1

    For Ni := 1 To Len(::aAnexos)
        cAnexos += ::aAnexos[Ni] + Iif(Ni<Len(::aAnexos),",","")
    Next

Return cAnexos

/*/{Protheus.doc} getAttachCount
Recupera o número de arquivos anexos à mensagem

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      null

@return     nAttached (int) Número de arquivos anexos
*/
Method getAttachCount() Class CSMailSender
Return Len(::aAnexos)

/*/{Protheus.doc} getAttachments
Retorna um array com a lista de arquivos anexos

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      null

@return     aAnexos (array) Conjunto de anexos à mensagem
*/
Method getAttachments() Class CSMailSender
Return ::aAnexos

/*/{Protheus.doc} SendMail
Tenta disparar o e-mail de acordo com as configurações informadas nas
propriedades da Classe.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      null

@return     lResultSend (bool)  Informa se o disparo da mensagem foi bem sucedido.
*/
Method SendMail() Class CSMailSender

    Local cAnexos := ""

    If Empty(::cMailDest)
        ::cMailStatus := STR_DEST_NOT_SET
        Return .F.
    EndIf

    If !::lConnected
        ::Connect()
    EndIf

    If ::hasAttachments()
        
        If ::lCompressAttach
            ::CompressAttach()
        EndIf

        cAnexos := ::getAttachString()
    	SEND MAIL FROM ::cMailRem TO ::cMailDest SUBJECT ::cSubject BODY ::cBody ATTACHMENT cAnexos RESULT ::lResultSend
    Else
        SEND MAIL FROM ::cMailRem TO ::cMailDest SUBJECT ::cSubject BODY ::cBody RESULT ::lResultSend
    EndIf
	
    MailFormatText( .F. )

    If !::lResultSend
        GET MAIL ERROR ::cMailStatus
        ::cMailStatus += STR_MAIL_NOT_SENT + ::cMailStatus
    Else
        ::cMailStatus := STR_MAIL_SENT
    Endif

Return ::lResultSend

/*/{Protheus.doc} Disconnect
Disconecta do servidor de e-mails.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      null
@return     null
*/
Method Disconnect() Class CSMailSender
	DISCONNECT SMTP SERVER
Return

/*/{Protheus.doc} setCompressAttachments
Seta se os anexos devem ser Zipados

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      lCompress (bool)    Flag de compressão dos arquivos anexos
@return     null
*/
Method setCompressAttachments(lCompress) Class CSMailSender
    ::lCompressAttach := lCompress
Return

/*/{Protheus.doc} CompressAttach
Método para compressão de arquivos a serem anexados no e-mail
utilzando a função FZip.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      aFiles (array)  Lista de arquivos a serem comprimidos
@param      cName (string)  Nome do arquivo ZIP a ser gerado
@param      cDir (string)   Diretório onde será salvo o arquivo ZIP
@param      cPwd (string)   Senha a ser atribuída para abertura do arquivo
@return     null
*/
Method CompressAttach(aFiles, cName, cDir, cPwd) Class CSMailSender

    Local nRet      := 0
    Local cFullName := ""

    DEFAULT aFiles  := ::aAnexos
    DEFAULT cDir    := "\mailtmp\" + RetCodUsr() + "\" + DTOS(Date())
    DEFAULT cName   := DTOS(Date()) + StrTran(Time(),":","") + ".zip"
    DEFAULT cPwd    := Nil

    cFullName := cDir + "\" + cName

    nRet := FZip(cFullName, aFiles, cDir, cPwd)

    If nRet == 0
        ::aAnexos := {cFullName}
    EndIf

Return nRet == 0
