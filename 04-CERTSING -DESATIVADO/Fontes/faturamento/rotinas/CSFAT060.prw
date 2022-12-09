#Include 'totvs.ch'
#Include 'rwmake.ch'

//---------------------------------------------------------------
// Rotina | CSFAT060 | Autor | Rafael Beghini | Data | 18/01/2016 
//---------------------------------------------------------------
// Descr. | Rotina para cadastro de Solicitantes de Voucher 
//        | 
//---------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//---------------------------------------------------------------
User Function CSFAT060()
	Private cCadastro := "Cadastro - Solicitantes de Voucher"
	Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cString   := "PB2"
	Private aRotina   := { {"Pesquisar","AxPesqui",0,1} ,;
		{"Visualizar","AxVisual",0,2} ,;
		{"Incluir","AxInclui",0,3} ,;
		{"Alterar","AxAltera",0,4} ,;
		{"Excluir","AxDeleta",0,5} }
	
	dbSelectArea(cString)
	
	mBrowse( 6,1,22,75,cString)
Return