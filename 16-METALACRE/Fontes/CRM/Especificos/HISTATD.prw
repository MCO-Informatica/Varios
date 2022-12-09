#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"                                                                                                         
#INCLUDE "COLORS.CH"     
#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"   
//--------------------------------------------------------------
/*/{Protheus.doc} HISTATD
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 06/11/2012
/*/
//--------------------------------------------------------------
User Function HISTATD(cCod,cloj)

Local aArea 	 	:= GetArea()															// Salva a area atual
Local cCliente	 	:= cCod					// Codigo do Cliente/Prospect
Local cLoja		 	:= cLoj	// Codigo da Loja
Local lRet			:= .F.																	// Retorno da funcao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Compatibilizacao com o TMKA271 - Fonte principal das rotinas de atendimento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lProspect	:= .T.																	// Flag que indica se e um prospect (.T.) ou nao (.F.)	
Private aCols  		:= {}																	// aCols do Televendas - SUB
Private aHeader 	:= {}																	// aHeader do Televendas - SUB
Private INCLUI		:= .F.																	// FLAG de INCLUSAO da ENCHOICE
Private n			:= 1																	// Posicao do aCols inicial

Private aRotina 	:= {	{ ""  ,"" ,0,1 },; 												// aRotinas
							{ ""  ,"" ,0,2 },; 	
							{ ""  ,"" ,0,3 },; 	
							{ ""  ,"" ,0,4 },;  
							{ ""  ,"" ,0,2} } 	


lProspect := .F.

DbSelectarea( "SUA" )
DbSetorder(7)
If !DbSeek(xFilial("SUA") + cCliente + cLoja)
	Help(" ",1,"SEMDADOS" )
	Return(lRet)
Endif

RegToMemory( "SUA", .F., .F. ) // terceiro como false.

M->UA_CLIENTE := cCliente
M->UA_LOJA    := cLoja
M->UA_DESCCLI := POSICIONE("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SUB")
While ( !Eof() .AND. (SX3->X3_ARQUIVO == "SUB") )
	
	If ( X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL )

		Aadd(aHeader,{ 	AllTrim(X3Titulo())	,;	//01
						SX3->X3_CAMPO		,;	//02
						SX3->X3_PICTURE		,;	//03
						SX3->X3_TAMANHO		,;	//04
						SX3->X3_DECIMAL		,;	//05
						SX3->X3_VALID		,;	//06	
						SX3->X3_USADO		,;	//07
						SX3->X3_TIPO		,;	//08
						SX3->X3_F3			,;	//09
						SX3->X3_CONTEXT } )		//10
					Endif
	
	DbSelectArea("SX3")
	DbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aCols                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCols,Array(Len(aHeader)+ 1))
aCols[Len(aCols)][Len(aHeader) + 1] := .F.

Tk273HTlv(	2	 	,.T.	,NIL	,NIL,;
			NIL	 	,NIL	,NIL	,NIL,;
			NIL	 	,NIL	,NIL	,NIL,;
			NIL	 	,NIL	,NIL	,NIL,;
			NIL	 	,NIL	,NIL	,NIL,;
			NIL	 	,NIL	,NIL	,NIL,;
			NIL  	,NIL	,NIL	,NIL,;
			NIL		,NIL)

RestArea(aArea)
lRet := .T.

Return(lRet)
Return