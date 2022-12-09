#Include 'Protheus.ch'
#Include 'TopConn.ch'

// Abre MarkBrowser e utiliza para controle de ordem de separa��o por prioridade
User Function FAT1F002()
	// Campos para o MarkBrow
	Local aCampos := {"C9_OK",,"",},;
		{"C9_COD", "C�digo", "@!"},;
		{"C9_PEDIDO", "Descri��o", "@!"}
	// Query que retorna as pend�ncias por prioridade
	Local cQuery := ''
	// Fun��o que retorna uma marca��o a ser utilizada
	Private cMarca := GetMark()
	// Tabela tempor�ria para marca��o
	Private aStru	 := {}
	// T�tulo
	Private cTit   := "Controle de Ordem de Separa��o"
	
	// Adiciona campos a tabela tempor�ria
	AAdd(AStru, {"C9_OK", "C", 1})
	AAdd(AStru, {"C9_COD", "C", 60})
	AAdd(AStru, {"C9_PEDIDO", "C", 6})
	
	cFile := CriaTrab(AStru, .T.)
	
	If Select("TRB") <> 0
		SC9LIB->(dbclosearea("TRB"))
	EndIf
	
	DbUseArea(.T., "DBFCDX", cFile, "TRB", .T., .F.)
	
	cIndex := Criatrab(nil, .F.)
	IndRegua("TRB", cIndex, "C9_OK",,, "Indexando Registros...")
		
	cQuery := 'Select * From SC9010'
	
	If Select("SC9LIB") <> 0
		SC9LIB->(dbclosearea("SC9LIB"))
	EndIf
	
	TCQuery cQuery New Alias "SC9LIB"
	
	While SC9LIB->(!Eof())
		If Reclock("TRB", .T.)
			LIB->C9_OK     := SC9LIB->C9_OK
			LIB->C9_COD    := SC9LIB->C9_COD
			LIB->C9_PEDIDO := SC9LIB->C9_PEDIDO
			LIB->(msUnlock())
		EndIf
		
		SC9LIB->(dbskip())
	Enddo
	
	dbSelectArea("TRB")
	dbSetOrder(1)
	
	MarkBrow("SC9LIB", "C9_OK",, aCampos,, cMarca, MarkAll() 
Return

// Desmarca o item no MarkBrowse
Static Function DesItem()
	// Retorna o n�mero do registro no MarkBrow
	Local oMark := GetMarkBrow()
	
	DbSelectArea("TRB")
	DbGoTop()
	
	While TRB->(!Eof())
		If RecLock("TRB", .F.)
			TRB->C9_OK := Space(2)
			MsUnlock()		
		EndIf
		
		TRB->(dbskip())
	EndDo
	
	// Refaz leitura e posiciona no primeiro registro 
	MarkBRefresh() 
	oMark:oBrowse:GoTop()
Return

// Fun��o respons�vel por marcar o item no grid
Static Function MarkItem()
	// Retorna o n�mero do registro no MarkBrow
	Local oMark := GetMarkBrow()
	
	// Confirma alias 
	DbSelectArea("TRB")
	DbGoTop()
	
	While TRB->(!Eof())
		If RecLock("TRB", .F.)
			TRB->C9_OK := cMark
			MsUnLock()
		EndIf
		
		TRB->(dbSkip())
	EndDo
	
	// Refaz leitura e posiciona no primeiro registro 
	MarkBRefresh() 
	oMark:oBrowse:GoTop()
Return

// Fun��o respons�vel por marcar todos os itens no grid
// Obs: Utiliza a MarkItem
Static Function MarkAll()
	// Retorna o n�mero do registro no MarkBrow
	Local nRecNo := GetMarkBrow()
	
	// Seta a area do LIB
	DbSelectArea("LIB")
	DbGoTop()
	
	// Passa no la�o chamando MarkItem
	While LIB->(!Eof())
		MarkItem()
		LIB->(dbskip())
	End
	
	// Refaz leitura e posiciona no primeiro registro 
	MarkBRefresh()
	oMark:oBrowse:GoTop()
Return

Static Function InitScreen()
	DEFINE MSDIALOG oDlg FROM 18, 1 TO 130, 555 TITLE "Controle OS" PIXEL
	
	@01, 003 TO 52, 242 OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
Return