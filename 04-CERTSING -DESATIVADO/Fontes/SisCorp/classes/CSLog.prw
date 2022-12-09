#Include "Protheus.ch"
#Include "Ap5Mail.ch"
#Include "TbiConn.ch"
#Include "Totvs.ch"

/*/{Protheus.doc} CSLog
Classe para auxiliar o desenvolvedor Protheus na gera��o de log via email
@author    bruno.nunes
@since     05/08/2020
@version   P12
/*/   
class CSLog
	data listaMensagem	  as array
	data parametroSX6     as string
	data assunto		  as string
	data email			  as string
	data ipServidor       as string
	data portaServidor    as string
	data ambienteServidor as string
	data geraEmail	      as string
	data bodyHtml		  as string
	
	method New( paramSX6 ) constructor
	method AddLog( xMsg ) 
	method SetEmail( cEmail )
	method SetAssunto( cAssunto )
	method EnviarLog()	
	method GetSX6FuncaoNome()
endclass

/*/{Protheus.doc} New
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method New( paramSX6 ) class CSLog as object
	default paramSX6 := ::GetSX6FuncaoNome()
	
	::parametroSX6     := paramSX6
	::assunto          := "LOG - Processamento"
	::email            := "sistemascorporativos@certisign.com.br"
	::listaMensagem    := {}
	::ipServidor       := GetSrvInfo()[1]
	::portaServidor    := GetPvProfString( GetPvProfString( "DRIVERS", "ACTIVE", "TCP", GetADV97() ), "PORT", "0", GetADV97() )
	::ambienteServidor := GetEnvServer()
 
	if !GetMv( ::parametroSX6, .T. )
		CriaPar( {{ ::parametroSX6, "L", "Parametro criado pela classe CSLog para controle de mensagem", ".T." }})
	endif
	::geraEmail := GetMv( ::parametroSX6 )
return self

/*/{Protheus.doc} AddLog
Adiciona log ao objeto
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method AddLog( xMsg ) class CSLog as Undefinied
	default xMsg := ""
	aAdd( ::listaMensagem, { cValToChar( ThreadId() ), cValToChar( ProcLine(1) ), alltrim( ProcName(1) ), xMsg} )
return 

/*/{Protheus.doc} SetEmail
Guarda email para envio pela rotina EnviarLog
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method SetEmail( cEmail ) class CSLog as Undefinied
	default cEmail := ""
	::email := cEmail
return 

/*/{Protheus.doc} SetAssunto
Guarda assunto para envio pela rotina EnviarLog
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method SetAssunto( cAssunto ) class CSLog as Undefinied
	default cAssunto := ""
	::assunto := cAssunto
return 

/*/{Protheus.doc} EnviarLog
Envia email dos logs
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method EnviarLog() class CSLog as Undefinied 
	local i := 0
	
	if ::geraEmail
		::bodyHtml := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
		::bodyHtml += '<html xmlns="http://www.w3.org/1999/xhtml">'
		::bodyHtml += '	<head>'
		::bodyHtml += '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />'
		::bodyHtml += '		<title>' + ::assunto + '</title>'
		::bodyHtml += '		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>'
		::bodyHtml += '</head>'
		::bodyHtml += '<body style="margin: 0; padding: 0;">'
		::bodyHtml += '	<table border="1" cellpadding="0" cellspacing="0" width="100%">'
		::bodyHtml += '		<tr><td colspan="4"><h3>' + ::assunto + '</h3></td></tr>'
		::bodyHtml += '		<tr><td><strong> Servidor	</strong></td><td colspan="3"> ' + ::ipServidor 				+ '</td></tr>'
		::bodyHtml += '		<tr><td><strong> Porta 		</strong></td><td colspan="3"> ' + ::portaServidor 				+ '</td></tr>'
		::bodyHtml += '		<tr><td><strong> Ambiente 	</strong></td><td colspan="3"> ' + ::ambienteServidor 			+ '</td></tr>'	
		::bodyHtml += '		<tr><td><strong> Data 		</strong></td><td colspan="3"> ' + DtoC(Date()) + ' - ' + Time() + '</td></tr>'
		::bodyHtml += '		<tr><td><strong> Thread  	</strong></td><td><strong> Linha  	</strong></td><td><strong> Fun��o  </strong></td><td><strong> Mensagem  </strong></td></tr>'
		
		for i := 1 to len( ::listaMensagem )
			::bodyHtml += '<tr>'
			::bodyHtml += '<td>' + cValToChar( ::listaMensagem[i][1] ) 		 + '</td>'
			::bodyHtml += '<td>' + cValToChar( ::listaMensagem[i][2] ) 		 + '</td>'
			::bodyHtml += '<td>' + cValToChar( ::listaMensagem[i][3] ) 		 + '</td>'
			if valtype( ::listaMensagem[i][4] ) == "A"
				::bodyHtml += '<td>' + VarInfo('', ::listaMensagem[i][4],,.F.,.F.) + '</td>'
			else
				::bodyHtml += '<td>' + cValToChar( ::listaMensagem[i][4] ) 		 + '</td>'
			endif
			::bodyHtml += '</tr>'
		next 
		::bodyHtml += ' </table>'
		::bodyHtml += '</body>'
		::bodyHtml += '</html>'
	
		fsSendMail( ::email, ::assunto, ::bodyHtml, "" )
	endif
return

/*/{Protheus.doc} CriaPar
Fun��o para cria��o de par�metros (SX6)
@type function
@author Atilio
@since 12/11/2015
@version 1.0
@param aPars, Array, Array com os par�metros do sistema
@example
CriaPar(aParametros)
@obs Abaixo a estrutura do array:
[01] - Par�metro (ex.: "MV_X_TST")
[02] - Tipo (ex.: "C")
[03] - Descri��o (ex.: "Par�metro Teste")
[04] - Conte�do (ex.: "123;456;789")
/*/
static function CriaPar( aPars )
	Local nAtual  := 0
	Local aArea   := GetArea()
	Local aAreaX6 := SX6->(GetArea())
	Default aPars := {}
	
	dbSelectArea( "SX6" )
	SX6->( dbGoTop() )
	For nAtual := 1 To Len( aPars ) 	//Percorrendo os par�metros e gerando os registros
		//Se n�o conseguir posicionar no par�metro cria
		If !( SX6->( dbSeek( xFilial("SX6") + aPars[ nAtual ][ 1 ] ) ) )
			RecLock("SX6", .T.)
			SX6->X6_VAR     := aPars[nAtual][1] //Nome do parametro
			SX6->X6_TIPO    := aPars[nAtual][2] // Tipo do parametro
			SX6->X6_PROPRI  := "U" 				//Parametro customizado
			SX6->X6_DESCRIC := aPars[nAtual][3] //Descri��o Portugu�s
			SX6->X6_DSCSPA  := aPars[nAtual][3] //Descri��o Espanhol
			SX6->X6_DSCENG  := aPars[nAtual][3] //Descri��o Ingles
			SX6->X6_CONTEUD := aPars[nAtual][4] //Conte�do Portugu�s
			SX6->X6_CONTSPA := aPars[nAtual][4] //Conte�do Espanhol
			SX6->X6_CONTENG := aPars[nAtual][4] //Conte�do Ingles
			SX6->(MsUnlock())
		EndIf
	Next nAtual
	
	RestArea( aAreaX6 )
	RestArea( aArea   )
Return

/*/{Protheus.doc} GetSX6FuncaoNome
Envia email dos logs
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method GetSX6FuncaoNome() class CSLog as Undefinied 
	local cPrefixo := "LG_"
	local nRotina := 0
	local cRotina := ProcName( nRotina ) 

	while !empty( cRotina )
		nRotina++
		cRotina := ProcName( nRotina ) 
	end
	cRotina := ProcName( nRotina - 1 ) 
	cRotina := Replace( cRotina, "U_", "" )
	cRotina := cPrefixo + Left( PadR( cRotina, 7 ), 7 )
	
Return cRotina
