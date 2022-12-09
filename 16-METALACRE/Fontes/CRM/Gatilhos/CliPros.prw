#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"

User Function CliPros()  

Local cCliPros := M->UA_CLIPROS
Local cCli     := M->UA_CLIENTE
Local cLoja    := M->UA_LOJA
Local cCliX    := ""
Local cLojaX   := ""
Local cNomeX   := ""      
Local cObserv  := ''

IF cCliPros == '1'

	DBSELECTAREA("SA1")
   	DBSETORDER(1)
   	IF DBSEEK(XFILIAL("SA1") + cCli + cLoja)
   		cClix  := SA1->A1_COD
   		cLojaX := SA1->A1_LOJA
   		cNomeX := SA1->A1_NOME
   		cObserv:= ALLTRIM(SA1->A1_OBSERV)
    ENDIF
    
    U_SitCli(SA1->A1_COD)
    
ELSE

	DBSELECTAREA("SUS")
   	DBSETORDER(1)
   	IF DBSEEK(XFILIAL("SUS") + cCli + cLoja)
   		cCliX  := SUS->US_COD
   		cLojaX := SUS->US_LOJA
   		cNomeX := SUS->US_NOME                 
   		cObserv:= ''
    ENDIF 
    
ENDIF    

M->UA_XCLIENT := cCliX
M->UA_XLOJAEN := cLojaX
M->UA_NOMECLI := cNomeX
M->UA_OBSCLI  := cObserv

Return 
