#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} SFAUTSFTP
//Tela para atualização do arquivo de
autenticação do FTP
Rotina chamada pelo menu.
@author marcio.katsumata
@since 15/07/2019
@version 1.0
@return return, nil
/*/
user function SFAUTSFTP()
	
	local cPath        := ""
	local cFile        := "authentication.aut"
	local cBkpFile     := "authentication.bkp"
	local cLine       := ""
	local oSfUtils    := SFUTILS():New()
	local cArquivo    := ""
	local cArqBkp     := ""
	private cUserName := space(60)                //string que armazena o usuário sftp
	private cPass     := space(60)                //string que armazena a senha sftp
	private cHostKey  := space(100)               //string que armazena o host key SFTP

	//chama a janela do wizard
	if  wizardP12()
		//Verificação se as strings de autenticação não estão vazias
		if !empty(cUserName) .and. !empty(cPass) .and. !empty(cHostKey)
		    cPath       := oSfUtils:getAuthPath()
		    cArquivo    := cPath+"\"+cFile
		    cArqBkp     := cPath+"\"+cBkpFile
		    
			//Realiza o backup do arquivo de autenticação 
			if file (cArquivo)	
				if file (cArqBkp)
					FErase (cArqBkp)
				endif
				__CopyFile(cArquivo, cArqBkp )
				FErase (cArquivo)
			endif
			
			//Realiza a gravalção do arquivo de autenticação.
			cLine := oSfUtils:encryptTxt(cUserName)+";"+oSfUtils:encryptTxt(cPass)+";"+oSfUtils:encryptTxt(cHostKey)
			if MemoWrite(cArquivo, cLine)
				aviso ("SFAUTSFTP", "Arquivo de autenticação gravado com sucesso", {"OK"}, 1)
			else
				msgAlert("Erro ao gravar o arquivo de autenticação")
			endif
		endif
	endif
	
	freeObj (oSfUtils)
return


/*/{Protheus.doc} wizardP12
//Wizard de orientação P12.
@author ERPSERV
@since 14/06/2019
@version 1.0
@return return, boolean, retorno se o usuário optou em prossseguir.
@example
(examples)
@see (links_or_references)
/*/
Static Function wizardP12()
 
	Local oPanel
	Local oNewPag
	Local cNome   := ""
	Local cFornec := ""
	Local cCombo1 := ""
	Local oStepWiz := nil
	Local oDlg := nil
	Local oPanelBkg
	local lWiz    := .F.
	Local aCoors  := FWGetDialogSize( oMainWnd )
	
	DEFINE DIALOG oDlg TITLE 'Wizard de Configuração Arquivo Autenticação' PIXEL
	oDlg:nWidth := 600
	oDlg:nHeight := 630
	oPanelBkg:= tPanel():New(01,01,"",oDlg,,,,,,300,300)
	oStepWiz:= FWWizardControl():New(oPanelBkg)//Instancia a classe FWWizard
	oStepWiz:ActiveUISteps()
	 
	//----------------------
	// Pagina 1
	//----------------------
	oNewPag := oStepWiz:AddStep("1")
	//Altera a descrição do step
	oNewPag:SetStepDescription("Boas Vindas")
	//Define o bloco de construção
	oNewPag:SetConstruction({|Panel|cria_pg1(Panel)})
	//Define o bloco ao clicar no botão Próximo
	oNewPag:SetNextAction({||.T.})
	//Define o bloco ao clicar no botão Cancelar
	oNewPag:SetCancelAction({||oDlg:End(),.T.})
	 
	 
	//----------------------
	// Pagina 2
	//----------------------
	oNewPag := oStepWiz:AddStep("2", {|Panel|cria_pg2(Panel)})
	oNewPag:SetStepDescription("Informe os parâmetros")
	oNewPag:SetNextAction({||lWiz := .T.,oDlg:End(), .T.})
	oNewPag:SetCancelAction({||oDlg:End(), .T.})
	oNewPag:SetCancelWhen({||.T.})
	oStepWiz:Activate()
	
	ACTIVATE DIALOG oDlg CENTER

	oStepWiz:Destroy()
	
Return lWiz


/*/{Protheus.doc} cria_pg1
//Cria o painel do primeiro passo do wizard P12.
@author ERPSERV
@since 14/06/2019
@version 1.0
@param oPanel, object, painel do wizard
@return return, nil
/*/
static function cria_pg1 (oPanel)
	local oSay1
	local oSay2
	
 	@ 010, 010 TO 125,280 OF oPanel PIXEL                                                       	    
    @ 20, 15 SAY oSay1 VAR "Esta rotina tem por objetivo realizar a configuração do arquivo de autenticação do FTP" OF oPanel PIXEL	
    @ 30, 15 SAY oSay2 VAR "Este procedimento é necessário na implantação do projeto ou na mudança das chaves de autenticação." OF oPanel PIXEL	

			      

return


/*/{Protheus.doc} cria_pg1
//Cria o painel do primeiro passo do wizard P12.
@author ERPSERV
@since 14/06/2019
@version 1.0
@param oPanel, object, painel do wizard
@return return, nil
/*/
static function cria_pg2 (oPanel)
 

    Local oTGet1
	Local oTGet2
	Local oTGet3
    local oSay1
	local oSay2
	local oSay3
    
    oSay1	:= TSay():New(10,10,{||'Usuario'},oPanel,,,,,,.T.,,,200,20)	
    oTGet1 	:= TGet():New(20,10,{|u| if( PCount()>0, cUserName := u, cUserName ) } ,oPanel,150,009,"",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cUserName")
    
    oSay2	:= TSay():New(40,10,{||'Senha'},oPanel,,,,,,.T.,,,200,20)
    oTGet2 	:= TGet():New(50,10,{|u| if( PCount()>0, cPass := u, cPass ) },oPanel,150,009,"",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cPass")

	oSay3	:= TSay():New(70,10,{||'HostKey'},oPanel,,,,,,.T.,,,200,20)
    oTGet3 	:= TGet():New(80,10,{|u| if( PCount()>0, cHostKey := u, cHostKey ) },oPanel,150,009,"",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cHostKey")

      

return