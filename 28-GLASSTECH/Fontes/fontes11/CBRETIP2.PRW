#include "Protheus.ch"

//.==============================================================.
//|                         TOTVS                                |
//|--------------------------------------------------------------|
//| Funcao: CBRETIP2          | Autor: Lucilene Litoldo          |
//|--------------------------------------------------------------|
//| Descricao: Ponto de Entrada para definir o tipo de codigo    |
//|            de 	barras utilizado                               |
//|--------------------------------------------------------------|
//| Data criacao  : 09/08/2012  | ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.

User function CBRETIP2()

Local cID     := paramixb[1]
Local cTipo := ""

cTipo := "EAN8OU13" // O codigo de barras especifico do cliente

Return cTipo

	