#INCLUDE "PROTHEUS.CH"

User Function IMCD_SYA()
//Exemplo extraído da função GPEXFUNW, mas com pequenas modificações
Local cAliasX := GetNextAlias()
Local cMvPar
Local MvParDef:=""
Local uMvRet:= ""
Private lTipoRet := .T.
Private l1Elem := .F.
Private aCat:={}
Private cTitulo:="Business Unit"

cAlias := Alias() // Salva Alias Anterior

IF lTipoRet
	cMvPar:=&(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
	uMvRet:=Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

BeginSql alias cAliasX
	SELECT DISTINCT ACY_GRPSUP ,ACY_XDESC
	FROM %table:ACY%
	WHERE ACY_GRPSUP <> ' '
	AND ACY_MSBLQL <> '1'
	AND D_E_L_E_T_ <> '*'
	ORDER BY 1
EndSql

CursorWait()

aCat := {}

While (cAliasX)->(!Eof())
	Aadd(aCat,(cAliasX)->ACY_GRPSUP + " - " + Alltrim( (cAliasX)->ACY_XDESC ) )
	
	MvParDef+=(cAliasX)->ACY_GRPSUP
	
	dbSkip()
	
Enddo

CursorArrow()

IF lTipoRet
	
	IF ( f_Opcoes(@cMvPar,cTitulo,aCat,MvParDef,12,49,l1Elem,6,3,.T.))
		
		cVarAux2 := ''
		For nX := 1 To Len(cMvPar)
			cVarAux := Substr(cMvPar,nX,1)
			If '*' <> cVarAux
				cVarAux2 += cVarAux
			EndIf
		Next nX
		cMvPar := cVarAux2
		
		&(uMvRet)  := cMvPar //Devolve o Resutado
		
		lRet:= .T.
	Else
		lRet:= .F.
	EndIF
EndIF
VAR_IXB := AllTrim(cMvPar)

dbSelectArea(cAlias) // Retorna Alias

Return(lRet)