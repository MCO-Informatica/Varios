#include 'protheus.ch'
#include 'parmtype.ch'

User Function zLstTipoP(l1Elem,lTipoRet)
 
/*
	cTitulo = Titulo da Janela
	aOpcoes = Opções que irão aparecer para serem selecionados
	l1Elem  = Definie se a seleção será de apenas de 1 elemento
	lTipoRet= Define o tipo de retorno
	*/
	Local MvParDef:=""	
	Local MvPar	  := ""
	Local i
	
	Private aSit:={}
	//Private aCat:=aOpcoes
 
	//Default cTitulo :=""
	Default lTipoRet := .T.
	
	l1Elem := If (l1Elem = Nil , .F. , .T.) //Definie se a seleção será de apenas de 1 elemento, .F. mais de um elemento
	
	cAlias := Alias() // Salva Alias Anterior
	
	/*
	if Len(aOpcoes)==0
		Help('',1,'FSELARRA',,'As opções não foram inseridas!',1,0)
		Return
	Endif
	*/
	aCat := {"1 - Firme","2 - Estimativa","3 - Prospecção"}
	MvParDef:="123"
	cTitulo :="Tipo de Proposta"
 
	IF lTipoRet
		MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF
 
	For i := 1 To Len(aCat)
		MvParDef+=Left(aCat[i],1)
	Next
	
	IF f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,l1Elem)   // Chama funcao f_Opcoes
		&MvRet := mvpar	
	EndIF
 
	dbSelectArea(cAlias) // Retorna Alias
	
Return( IF( lTipoRet , .T. , MvParDef ) )