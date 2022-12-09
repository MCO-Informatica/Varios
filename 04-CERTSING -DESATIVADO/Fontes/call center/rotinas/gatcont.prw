#include "protheus.ch"

//---------------------------------------------------------------------
// Rotina | GATCONT | Autor | Gustavo Prudente      | Data | 28.05.2013
//---------------------------------------------------------------------
// Descr. | Cria gatilho de contatos para tela de atendimento.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function GATCONT( cFuncOrig )
	If cFuncOrig == "ADE"                         
		FillADE()      
	Elseif cFuncOrig == "TMK_SUC_SUD"
		FillSUS( cFuncOrig )
	Endif
Return   
         
//---------------------------------------------------------------------
// Rotina | FILLADE | Autor | Gustavo Prudente      | Data | 28.05.2013
//---------------------------------------------------------------------
// Descr. | Cria gatilho de contatos para tela de atendimento.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function FillAde()
	M->ADE_CODCON	:= aContatos[oLtContatos:nAt,1]
	M->ADE_NMCONT	:= TKDadosContato(aContatos[oLtContatos:nAt,1],0)		
	M->ADE_ENTIDA	:= _cAlias
	M->ADE_NMENT 	:= POSICIONE('SX2',1,_cAlias,'X2NOME()')
	M->ADE_DESCIN	:= ALLTRIM(POSICIONE("SIX",1,_cAlias+"1","SIXDescricao()")) //Codigo+Loja
	M->ADE_CHAVE	:= ALLTRIM(_cCodEnt+_cLojaEnt)    
	
	If _cAlias == "SA1"
		M->ADE_EMAIL2 := POSICIONE(_cAlias, 1, xFilial(_cAlias)+_cCodEnt, "A1_EMAIL")
	EndIf     
	
	If _cAlias == "SZ3"
		M->ADE_DESCCH	:= Posicione(_cAlias,1,xFilial(_cAlias)+Alltrim(_cCodEnt+_cLojaEnt),"Z3_DESENT") //Empresa X Ltda.
	Else	
		M->ADE_DESCCH	:= TkEntidade(_cAlias,Alltrim(_cCodEnt+_cLojaEnt),1) //Empresa X Ltda.
	EndIf
Return

//---------------------------------------------------------------------
// Rotina | FILLSUS | Autor | Robson Gonçalves      | Data | 29.05.2013
//---------------------------------------------------------------------
// Descr. | Cria gatilho de contatos para tela de atendimento TMK.
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function FillSUS( cFuncOrig )
	If FunName() $ 'CSFA030|CSFA110' .And. cFuncOrig == "TMK_SUC_SUD"
		TkCliente( _cAlias, RTrim(_cCodEnt) + RTrim(_cLojaEnt) )

		M->UC_CODCONT := aContatos[ oLtContatos:nAt, 1 ] 
		M->UC_DESCNT  := TKDadosContato( aContatos[ oLtContatos:nAt, 1 ], 0 )
		M->UC_DESCENT := Posicione( "SX2", 1, _cAlias, "X2NOME()" )
		M->UC_DESCIND := RTrim( Posicione( "SIX", 1, _cAlias + "1", "SIXDescricao()" ) )
		M->UC_DESCCHA := TkEntidade( _cAlias, RTrim( _cCodEnt ) + RTrim( _cLojaEnt ), 1 )
		M->UC_ENTIDAD := _cAlias
		M->UC_CHAVE   := RTrim( _cCodEnt ) + RTrim( _cLojaEnt )
	Endif
Return