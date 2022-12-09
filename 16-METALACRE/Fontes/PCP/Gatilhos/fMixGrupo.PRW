#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ fMixGrupo³ Autor ³ Luiz Alberto      ³ Data ³09/05/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar Grupos de Produtos e Agrupar                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fMixgrupo()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function fMixGrupo(cMixGrupo)
Local aArea := GetArea()
Local cTitulo:=""
Local aReq := {}
Local MvPar
Local MvParDef:="" 
Local i := 1

Private aReq:={}

cAlias := Alias()               // Salva Alias Anterior
MvPar:=cMixGrupo //&(Alltrim(ReadVar()))   // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())      // Iguala Nome da Variavel ao Nome variavel de Retorno

SBM->(dbSetOrder(1))
SBM->(dbGoTop())
While SBM->(!Eof())

	AAdd(aReq,Capital(SBM->BM_DESC))
	
	MvParDef += AllTrim(SBM->BM_GRUPO)+' | '
	
	SBM->(dbSkip(1))
Enddo

cTitulo := 'Marque os Grupos que Deseja Agrupar em MIX' //"Atendimento aos requisitos pelos EPIS informados"

IF f_Opcoes(@MvPar,cTitulo,aReq,MvParDef,12,49,.F.,  6       ,   999    , .T.    )  // Chama funcao f_Opcoes
	cMixGrupo := mvpar
EndIF                           

cVarAux2 := ''
For nX := 1 To Len(cMixGrupo)
	cVarAux := Substr(cMixGrupo,nX,1)
	If '*' <> cVarAux
		cVarAux2 += cVarAux
	EndIf
Next nX
cMixGrupo := cVarAux2



RestArea(aArea)
Return( cMixGrupo )
