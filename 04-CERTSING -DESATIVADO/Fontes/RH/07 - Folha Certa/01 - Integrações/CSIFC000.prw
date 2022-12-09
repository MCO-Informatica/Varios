#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FILEIO.CH'
#INCLUDE 'Ap5Mail.ch'
#INCLUDE 'TbiConn.ch'

#DEFINE cDEBUG_EMPRESA "01"
#DEFINE cDEBUG_cFILIAL "07"

user function CSIFC000()
	local lDebug   := .F.

	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cDEBUG_EMPRESA FILIAL cDEBUG_cFILIAL

	u_CSIFC001(lDebug)
	u_CSIFC002(lDebug)
	u_CSIFC003(lDebug)
	u_CSIFC004(lDebug)

	RESET ENVIRONMENT
return

user function logFlCer(lErro, cJson, cMetodo, cTabela, id)
	local cData    := dtos(date())
	local cArquivo := ""
	local cHora    := replace(time(),":","_")
	local cId      := ""

	default lErro   := .F.
	default cJson   := ""
	default cMetodo := ""
	default cTabela := ""
	default id      := ""
	if !empty(id)
		cId := "_"+cValToChar( id )
	endif
	if !lErro
		cArquivo := "C:\TEMP\folhacerta\log\"+cData+"\"
		u_CriarDir(cArquivo)
		cArquivo += cTabela+"_"+cMetodo+cId+"_"+cHora+".json"
	else
		cArquivo := "C:\TEMP\folhacerta\log\"+cData+"\erro_"+cData+"\"
		u_CriarDir(cArquivo)
		cArquivo += "erro_"+cTabela+"_"+cMetodo+cId+"_"+cHora+".json"
		emailErro( cArquivo, cTabela, cMetodo, cId, cData, cHora  )
	endif
	MemoWrite( cArquivo, cJson )
return

static function emailErro( cAnexo, cTabela, cMetodo, cId, cData, cHora )
	local cHTML := "<html><head></head><body>*troca*</body></html>"
	local cBody := ""
	default cAnexo  := ""
	default cTabela := "" 
	default cMetodo := ""
	default cId 	:= ""
	default cHora   := ""
	
	cBody := "<h2>Erro na integração com FolhaCerta</h2>"
	cBody += "<ul>"
	cBody += "<li>Data e hora:"+dtoc(stod(cData)) +" - "+replace(cHora,"_",":") +"</li>"
	cBody += "<li>Tabela:"+cTabela+"</li>"
	cBody += "<li>Método:"+cMetodo+"</li>"
	cBody += "<li>Id:"+cId+"</li>"
	cBody += "</ul>"
	
	cHTML := replace(cHTML, "*troca*", cBody)
	
	/*1 - destinatario
	2 - assunto
	3 - html
	4 - anexo (separados por ;*/
	fsSendMail( "sistemascorporativos@certisign.com.br", "FolhaCerta - ERRO", cHTML, cAnexo )
	//fsSendMail( "fulano@eai.com.br", "FolhaCerta - ERRO", cHTML, cAnexo )
return