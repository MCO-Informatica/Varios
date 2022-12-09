#include "rwmake.ch"
#include "topconn.ch"
#Include "Totvs.ch"
#include "Ap5Mail.ch"
#include 'COLORS.CH'  
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc}
@author	Gesse Santos
@version	P11.5
@since		13/09/2014
@obs		Cadastro Gestor x Centro de Custos	
@todo		
/*/
User Function CSPCO005()
dbselectarea("Z05")
dbsetorder(1) 

AxCadastro("Z05","Gestor x Centro de Custo - Alertas")

Return NIL

