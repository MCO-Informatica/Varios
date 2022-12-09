#include "Protheus.ch"

//.==============================================================.
//|                         TOTVS                                |
//|--------------------------------------------------------------|
//| Funcao: CBRETEAN          | Autor: Lucilene Litoldo          |
//|--------------------------------------------------------------|
//| Descricao: Ponto de Entrada utilizado para informar os dados |
//|            pertinentes a etiquetas, quando utilizadas        |
//|            etiquetas de código natural.                      |
//|--------------------------------------------------------------|
//| Data criacao  : 09/08/2012  | ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.

User Function CBRETEAN()
	Local cId  := PARAMIXB[1] // Código da etiqueta lida
	Local aRet := {}
	Local cLote := ""
	Local cNumSerie := ""
	Local cFluxo := ""

	// Colocado a busca por B1_COD ao invés do B1_ZZCATAL

	SB1->(dbsetorder(11))
	if SB1->(dbSeek(xFilial("SB1")+padr(cId,20)))
		aRet := {SB1->B1_COD,1,Padr(cLote,10),"",Padr(cNumSerie,20)}
	elseif SB1->(dbSeek(xFilial("SB1") + padr(replace(cId, "-", "-AR"), 20)))
		aRet := {SB1->B1_COD,1,Padr(cLote,10),"",Padr(cNumSerie,20)}
	/*elseif SB1->(dbSeek(xFilial("SB1")+padr(AllTrim(cId) + "R",20))) 
		aRet := {SB1->B1_COD,1,Padr(cLote,10),"",Padr(cNumSerie,20)}
	else 
		cFluxo = AllTrim(U_GETFLUXO(AllTrim(cId)))
		if (cFluxo <> "")
			PARAMIXB[1] := cFluxo
			aRet := {cFluxo,1,Padr(cLote,10),"",Padr(cNumSerie,20)}
		endif*/
	endif

Return aRet // Estrutura do vetor: {"Código do Produto","Quantidade","Lote","Data de Validade","Número de Série"}