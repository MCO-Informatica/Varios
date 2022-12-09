#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FIAUTFTP
//Tela para atualiza��o do arquivo de
autentica��o do FTP
Rotina chamada pelo menu.
@author marcio.katsumata
@since 02/09/2019
@version 1.0
@return return, nil
/*/
user function FIAUTFTP()
	
	local cPath        := ""
	local cFile        := "authentication.aut"
	local cBkpFile     := "authentication.bkp"
	local cLine       := ""
	local oSysFiUtl    := SYSFIUTL():New()
	local cArquivo    := ""
	local cArqBkp     := ""
	private cUserName := space(60)                //string que armazena o usu�rio sftp
	private cPass     := space(60)                //string que armazena a senha sftp


	//chama a janela do wizard
	if  wizardP12()
		//Verifica��o se as strings de autentica��o n�o est�o vazias
		if !empty(cUserName) .and. !empty(cPass)
		    cPath       := oSysFiUtl:getAuthPath()
		    cArquivo    := cPath+"\"+cFile
		    cArqBkp     := cPath+"\"+cBkpFile
		    
			//Realiza o backup do arquivo de autentica��o 
			if file (cArquivo)	
				if file (cArqBkp)
					FErase (cArqBkp)
				endif
				__CopyFile(cArquivo, cArqBkp )
				FErase (cArquivo)
			endif
			
			//Realiza a graval��o do arquivo de autentica��o.
			cLine := oSysFiUtl:encryptTxt(cUserName)+";"+oSysFiUtl:encryptTxt(cPass)
			if MemoWrite(cArquivo, cLine)
				aviso ("FIAUTFTP", "Arquivo de autentica��o gravado com sucesso", {"OK"}, 1)
			else
				msgAlert("Erro ao gravar o arquivo de autentica��o")
			endif
		endif
	endif
	
	freeObj (oSysFiUtl)
return


/*/{Protheus.doc} wizardP12
//Wizard de orienta��o P12.
@author marcio.katsumata
@since 02/09/2019
@version 1.0
@return return, boolean, retorno se o usu�rio optou em prossseguir.
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
	
	DEFINE DIALOG oDlg TITLE 'Wizard de Configura��o Arquivo Autentica��o FTP Sysfiorde' PIXEL
	oDlg:nWidth := 600
	oDlg:nHeight := 630
	oPanelBkg:= tPanel():New(01,01,"",oDlg,,,,,,300,300)
	oStepWiz:= FWWizardControl():New(oPanelBkg)//Instancia a classe FWWizard
	oStepWiz:ActiveUISteps()
	 
	//----------------------
	// Pagina 1
	//----------------------
	oNewPag := oStepWiz:AddStep("1")
	//Altera a descri��o do step
	oNewPag:SetStepDescription("Boas Vindas")
	//Define o bloco de constru��o
	oNewPag:SetConstruction({|Panel|cria_pg1(Panel)})
	//Define o bloco ao clicar no bot�o Pr�ximo
	oNewPag:SetNextAction({||.T.})
	//Define o bloco ao clicar no bot�o Cancelar
	oNewPag:SetCancelAction({||oDlg:End(),.T.})
	 
	 
	//----------------------
	// Pagina 2
	//----------------------
	oNewPag := oStepWiz:AddStep("2", {|Panel|cria_pg2(Panel)})
	oNewPag:SetStepDescription("Informe os par�metros")
	oNewPag:SetNextAction({||lWiz := .T.,oDlg:End(), .T.})
	oNewPag:SetCancelAction({||oDlg:End(), .T.})
	oNewPag:SetCancelWhen({||.T.})
	oStepWiz:Activate()
	
	ACTIVATE DIALOG oDlg CENTER

	oStepWiz:Destroy()
	
Return lWiz


/*/{Protheus.doc} cria_pg1
//Cria o painel do primeiro passo do wizard P12.
@author marcio.katsumata
@since 02/09/2019
@version 1.0
@param oPanel, object, painel do wizard
@return return, nil
/*/
static function cria_pg1 (oPanel)
	local oSay1
	local oSay2
	
 	@ 010, 010 TO 125,280 OF oPanel PIXEL                                                       	    
    @ 20, 15 SAY oSay1 VAR "Esta rotina tem por objetivo realizar a configura��o do arquivo de autentica��o do FTP Sysfiorde" OF oPanel PIXEL	
    @ 30, 15 SAY oSay2 VAR "Este procedimento � necess�rio na implanta��o do projeto ou na mudan�a das chaves de autentica��o." OF oPanel PIXEL	

			      

return


/*/{Protheus.doc} cria_pg1
//Cria o painel do primeiro passo do wizard P12.
@author marcio.katsumata
@since 02/09/2019
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

      

return