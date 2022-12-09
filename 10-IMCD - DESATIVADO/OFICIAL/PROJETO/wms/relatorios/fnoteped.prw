#INCLUDE 'RWMAKE.CH'
#include 'protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FNOTEPED ºAutor  ³ Reinaldo Dias      º Data ³  02/10/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para possibilitar abertura do arquivo de log de   º±±
±±º          ³ restricao do lote pelo NOTEPED.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            
User Function FNOTEPED() 
	Local cDirIni    := "\shelflife"
	Local cArqOpen 
	Local cPathFile  
	local cLocalPath 
	local cNome
	local cExtensao

	cLocalPath := GetTempPath(.T.)

	While .T.
		/*
		cMask(Caracter)  -> Máscara para filtro (Ex: 'Informes Protheus (*.JPG) | *.JPG')
		cTitle(Caracter) -> Título da Janela
		nMask(Numérico)  -> Número da máscara padrão ( Ex: 1 p/ *.JPG )
		cDir(Caracter)   -> Diretório inicial
		lSave(Lógico)    -> .T. para mostrar o botão como 'Salvar' e .F. para botao 'Abrir'
		nOpc(Numérico)   -> Veja tabela em Opções
		lServer(Lógico)  -> .T. exibe diretório do servidor
		// Opções permitidas
		GETF_NOCHANGEDIR    // Impede que o diretorio definido seja mudado
		GETF_LOCALFLOPPY    // Mostra arquivos do drive de Disquete
		GETF_LOCALHARD      // Mostra arquivos dos Drives locais como HD e CD/DVD
		GETF_NETWORKDRIVE   // Mostra pastas compartilhadas da rede
		GETF_RETDIRECTORY   // Retorna apenas o diretório e não o nome do arquivo  
		*/                    //cMask                                       ,cTitle               ,nMark,cDir   ,lSave,nOpc,lServer
		cPathFile  := cGetFile("Arquivos de Log de Lote (LT*.LOG) | LT*.LOG","Selecione o Arquivo",0   ,cDirIni,.F., GETF_NOCHANGEDIR )
		
		IF Empty(cPathFile)
			Exit
		Endif
		

		SplitPath ( cPathFile, ,, @cNome, @cExtensao) 

		cArqName := cNome+cExtensao

		__copyFile(cPathFile, cLocalPath+cArqName )

		if file(cLocalPath+"\\"+cArqName )
			ShellExecute("Open","C:\Windows\System32\notepad.exe",cLocalPath+"\\"+cArqName ,"" ,3)   
		endif
		// shellExecute("Open", "C:\Windows\System32\notepad.exe", " /k dir", "C:\", 1 )

	Enddo

Return