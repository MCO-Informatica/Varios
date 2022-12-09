#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_LEMENU
// Autor 		Alexandre Dalpiaz
// Data 		08/09/2013
// Descricao  	LE MENUS DO SISTEMA
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_LEMENU()
/////////////////////////

For _nJ := 1 to 2
	
	If _nJ == 1
		_cPath := 'V:\protheus_data\system\'
	Else
		_cPath := 'V:\protheus_data\system\menus\'
	EndIf
	
	_aMenus := Directory(_cPath + '*.xnu')
	
	For _nI := 1 to len(_aMenus)
		
		
		_cMenu    := _aMenus[_nI,1]
		_cArquivo := _cPath + _cMenu
		
		FT_FUSE(_cArquivo)
		FT_FGotop()
		
		_nNivel  := 0
		_cModNom := ''
		
		_lLock1 := .f.
		_lLock2 := .f.
		Do While !FT_FEof()
			
			_cLinha := alltrim(FT_FREADLN())
			_cLinha := strtran(_cLinha,'	','')
			_cLinha := strtran(_cLinha,'&','')
			_nPos := at('</',_cLinha)
			
			If upper(left(_cLinha,8)) == '<MODULE>' .and. empty(_cModNom)
				_cModNom := substr(_cLinha,9,_nPos-9)
				
			ElseIf upper(left(_cLinha,13)) == '<MENU STATUS='
				++_nNivel
				_lMenu := .t.
				RecLock('ZX1',.t.)
				ZX1->ZX1_MODNOM := _cModNom
				ZX1->ZX1_MENU   := _cMenu
				ZX1->ZX1_STATUS := upper(substr(_cLinha,15,1))
				_lLock1 := .t.
				
			ElseIf upper(left(_cLinha,17)) == '<TITLE LANG="PT">' .and. _lLock1
				ZX1->ZX1_DESCPT := '&' + substr(_cLinha,18,_nPos-18)
				
			ElseIf upper(left(_cLinha,17)) $ '<TITLE LANG="ES">/<TITLE LANG="SP">' .and. _lLock1
				ZX1->ZX1_DESCSP := '&' + substr(_cLinha,18,_nPos-18)
				
			ElseIf upper(left(_cLinha,17)) == '<TITLE LANG="EN">' .and. _lLock1
				ZX1->ZX1_NIVEL  := str(_nNivel,1)
				ZX1->ZX1_DESCEN := '&' + substr(_cLinha,18,_nPos-18)   
				--_nNivel
				MsUnLock()
				_lLock1 := .f.
				
			ElseIf upper(left(_cLinha,17)) == '<MENUITEM STATUS=' .and. !_lLock1
				_lMenu := .f.
				++_nNivel
				_lLock2 := .t.
				RecLock('ZX1',.t.)
				ZX1->ZX1_MODNOM := _cModNom
				ZX1->ZX1_MENU   := _cMenu
				ZX1->ZX1_STATUS := upper(substr(_cLinha,19,1))
				
			ElseIf upper(left(_cLinha,17)) == '<TITLE LANG="PT">' .and. _lLock2      
				ZX1->ZX1_DESCPT := substr(_cLinha,18,_nPos-18)
				
			ElseIf upper(left(_cLinha,17)) $ '<TITLE LANG="ES">/<TITLE LANG="SP">' .and. _lLock2
				ZX1->ZX1_DESCSP := substr(_cLinha,18,_nPos-18)
				
			ElseIf upper(left(_cLinha,17)) == '<TITLE LANG="EN">' .and. _lLock2
				ZX1->ZX1_DESCEN := substr(_cLinha,18,_nPos-18)
				
			ElseIf upper(left(_cLinha,10)) == '<FUNCTION>' .and. _lLock2
				ZX1->ZX1_FUNCAO := upper(substr(_cLinha,11,_nPos-11))
				
			ElseIf upper(left(_cLinha,6)) == '<TYPE>' .and. _lLock2
				If upper(left(ZX1->ZX1_FUNCAO,2)) == 'U_'
					ZX1->ZX1_TIPO := '3'
					ZX1->ZX1_FUNCAO := substr(ZX1->ZX1_FUNCAO,3)
				Else
					ZX1->ZX1_TIPO :=  substr(_cLinha,7,1)
				EndIf
				
			ElseIf upper(left(_cLinha,8)) == '<TABLES>' .and. _lLock2
				ZX1->ZX1_TABELA := alltrim(ZX1->ZX1_TABELA) + upper(substr(_cLinha,9,_nPos-9))
				
			ElseIf upper(left(_cLinha,8)) == '<ACCESS>' .and. _lLock2
				ZX1->ZX1_ACESSO := substr(_cLinha,9,_nPos-9)
				
			ElseIf upper(left(_cLinha,8)) == '<MODULE>' .and. _lLock2
				ZX1->ZX1_MODULO := substr(_cLinha,9,2)
				
			ElseIf upper(left(_cLinha,11)) == '</MENUITEM>'     .and. _lLock2
				ZX1->ZX1_NIVEL := str(_nNivel,1)
				--_nNivel                         
				MsUnLock()
				_lLock2 := .f.

			EndIf
			
			FT_FSkip()
			
		EndDo
		
	Next
Next

Return()
