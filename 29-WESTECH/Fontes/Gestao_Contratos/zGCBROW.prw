#Include 'Protheus.ch'
#Include "TOTVS.ch"

User Function zGCBROW()


Private cCadastro := "Gestao de Contratos"
Private cFornece  := ""
Private cAlias1   := "CTD"            // Alias da Enchoice. Tabela Pai   CAPA
  
Private bFiltraBrw := {|| Nil}
Private nTotal    := 0

Private aRotina   := {}
Private aSize     := {}
Private aInfo     := {}
Private aObj      := {}
Private aPObj     := {}
Private aPGet     := {}
Private _cRetorno



Private bCampo    := {|nField| FieldName(nField) }


	// Retorna a area util das janelas Protheus
	aSize := MsAdvSize()

	// Ser� utilizado tr�s �reas na janela
	// 1� - Enchoice, sendo 80 pontos pixel
	// 2� - MsGetDados, o que sobrar em pontos pixel � para este objeto
	// 3� - Rodap� que � a pr�pria janela, sendo 15 pontos pixel

	AADD( aObj, { 100, 210, .T., .F. })
	AADD( aObj, { 100, 400, .T., .T. })
	AADD( aObj, { 100, 015, .T., .F. })

	// C�lculo autom�tico da dimens�es dos objetos (altura/largura) em pixel

	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPObj := MsObjSize( aInfo, aObj )

	// C�lculo autom�tico de dimens�es dos objetos MSGET

	aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )

	//AADD( aRotina, {"Pesquisar"  , "AxPesqui" , 0, 1} )
	AADD( aRotina, {"Custos" , 'U_zGESTCTR', 0, 2} )
	//AADD( aRotina, {"Incluir"    , 'U_zInvMnt', 0, 3} )
	//AADD( aRotina, {"Alterar"    , 'U_zInvMnt', 0, 4} )
	//AADD( aRotina, {"Excluir"    , 'U_zInvMnt', 0, 5} )
	//AADD( aRotina, {"Imprimir" 	 , 'U_zInvMnt',0,6})

	aCores:={{"CTD_DTEXSF < Date()","GRAY"},;
			 {"CTD_DTEXSF >= Date()", "GREEN"}}

	dbSelectArea(cAlias1)
	dbSetOrder(6)
	dbGoTop()


	SET FILTER TO CTD->CTD_ITEM <> 'ADMINISTRACAO' .AND. CTD->CTD_ITEM<>'PROPOSTA' .AND. CTD->CTD_ITEM<>'QUALIDADE' .AND. CTD->CTD_ITEM<>'ATIVO' ;
			 .AND. CTD->CTD_ITEM<>'ENGENHARIA' .AND. CTD->CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD->CTD_ITEM<>'XXXXXX' .AND. SUBSTR(CTD->CTD_ITEM,9,2) >= '15' ;
			 .AND. CTD_DTEXSF >= DDatabase


	//MBrowse(,,,,cAlias1)
	MBrowse(,,,,cAlias1,,"CTD_DTEXSF",,,8,aCores)

Return()