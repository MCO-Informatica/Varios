#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.CH"

USER FUNCTION F200PORT()

	Local lRet := .F.   
	//.T. = Utiliza o portador do titulo, ignorando o banco do retorno CNAB (padr�o caso n�o exista o ponto de entrada)
	//.F. = Utiliza o banco do retorno CNAB
Return lRet