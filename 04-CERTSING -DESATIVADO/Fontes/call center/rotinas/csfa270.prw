//-----------------------------------------------------------------------
// Rotina | CSFA270    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de cadastro de tipos de despesas.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA270()
	Private cCadastro := 'Tipo de Despesa'
	Private aRotina := {}

	AAdd( aRotina, {"Pesquisar" ,"AxPesqui"  ,0, 1 } )
	AAdd( aRotina, {"Visualizar","AxVisual"  ,0, 2 } )
	AAdd( aRotina, {"Incluir"   ,"AxInclui"  ,0, 3 } )
	AAdd( aRotina, {"Alterar"   ,"AxAltera"  ,0, 4 } )
	AAdd( aRotina, {"Excluir"   ,"U_A270Exc" ,0, 5 } )

	dbSelectArea('PAF')
	dbSetOrder(1)
	
	MBrowse(,,,,'PAF')
Return

//-----------------------------------------------------------------------
// Rotina | A270Exc    | Autor | Robson Gonçalves     | Data | 01.11.2013
//-----------------------------------------------------------------------
// Descr. | Rotina que critica se o registro poderá ser excluído.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A270Exc( cAlias, nRecNo, nOpc )
	PAE->(dbSetOrder(2))
	If PAE->(dbSeek(xFilial('PAE')+PAF->PAF_CODIGO))
		MsgAlert('Este código de Tipo de Despesa não poderá ser excluído, '+;
		         'pois este código já foi utilizado na relação das despesas, se for o caso bloqueia o registro.',cCadastro)
	Else
		AxDeleta(cAlias, nRecNo, nOpc )
	Endif
Return