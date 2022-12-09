#INCLUDE 'RWMAKE.CH'
#include 'protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FNOTEPED �Autor  � Reinaldo Dias      � Data �  02/10/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para possibilitar abertura do arquivo de log de   ���
���          � restricao do lote pelo NOTEPED.                            ���
�������������������������������������������������������������������������͹��
���Uso       � WMS                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		cMask(Caracter)  -> M�scara para filtro (Ex: 'Informes Protheus (*.JPG) | *.JPG')
		cTitle(Caracter) -> T�tulo da Janela
		nMask(Num�rico)  -> N�mero da m�scara padr�o ( Ex: 1 p/ *.JPG )
		cDir(Caracter)   -> Diret�rio inicial
		lSave(L�gico)    -> .T. para mostrar o bot�o como 'Salvar' e .F. para botao 'Abrir'
		nOpc(Num�rico)   -> Veja tabela em Op��es
		lServer(L�gico)  -> .T. exibe diret�rio do servidor
		// Op��es permitidas
		GETF_NOCHANGEDIR    // Impede que o diretorio definido seja mudado
		GETF_LOCALFLOPPY    // Mostra arquivos do drive de Disquete
		GETF_LOCALHARD      // Mostra arquivos dos Drives locais como HD e CD/DVD
		GETF_NETWORKDRIVE   // Mostra pastas compartilhadas da rede
		GETF_RETDIRECTORY   // Retorna apenas o diret�rio e n�o o nome do arquivo  
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