#include "protheus.ch"

//-----------------------------------------------------------
// Rotina | f3grpate | Totvs - David       | Data | 01.11.13
// ----------------------------------------------------------
// Descr. | Rotina personalizada para de seleção de postos 
//        | com tela markbrowse para ser chamada através F3
//-----------------------------------------------------------
User Function F3GRPATE(cCpoF3)

Local oDlgGrp      
Local oListGrp
                                    
Local oBtn1
Local oBtn2

Local oPanelList
Local oPanelBtn

Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )

Local lRet		:= .F.
Local cFilAG9	:= xFilial( "AG9" )
Local cFilSU0	:= xFilial( "SU0" )
Local cCodUser	:= ""   
Local aSelGrp	:= {}
Local cSelGrp	:= ""

Default cCpoF3	:= ReadVar()

If !Empty(cCpoF3) .and. !Empty(&(cCpoF3))

	cSelGrp	:=	Alltrim(&(cCpoF3))

EndIf

SU0->( DbGoTop() )
// Monta array com os grupos do usuario logado, para permitir seleção de grupos
Do While SU0->( ! EoF() )
	AAdd( aSelGrp, { IIF(SU0->U0_CODIGO $ cSelGrp, .T., .F.), SU0->U0_CODIGO, SubStr( SU0->U0_NOME, 1, 40 ) } )
	SU0->( DbSkip() )
EndDo

oDlgGrp := MSDialog():New( 180, 180, 400, 600,,,,,, CLR_BLACK, CLR_WHITE,,, .T. )  // Ativa diálogo centralizado

oPanelBtn		:= tPanel():New( 01, 01, "", oDlgGrp,,.T.,,,, 1, 16, .F., .F. )
oPanelBtn:Align := CONTROL_ALIGN_BOTTOM

@ 005, 005 LISTBOX oListGrp FIELDS HEADER " ", "Grupo", "Descrição", ;
	SIZE 100, 100 OF oDlgGrp PIXEL ON dblClick( aSelGrp[ oListGrp:nAt, 1 ] := ! aSelGrp[ oListGrp:nAt, 1 ] )
	                                      
oListGrp:SetArray( aSelGrp )
oListGrp:bLine := { || 	{ Iif( 	aSelGrp[ oListGrp:nAt, 1 ], oOk, oNo ) , ;
  								aSelGrp[ oListGrp:nAt, 2 ] , ;
								aSelGrp[ oListGrp:nAt, 3 ] } }

oListGrp:Align := CONTROL_ALIGN_ALLCLIENT

oBtn1 := TButton():New( 003, 143, "&Ok"		 , oPanelBtn, { || Iif( ValGrp( aSelGrp ), ( lRet := .T., oDlgGrp:End() ), .T. ) }, 032, 011,,,, .T.,, "",,,, .F. )
oBtn1 := TButton():New( 003, 178, "&Cancelar", oPanelBtn, { || lRet := .F., oDlgGrp:End() }, 032, 011,,,, .T.,, "",,,, .F. )

oDlgGrp:Activate( ,,, .T. )

If !Empty(cCpoF3)
	cSelGrp	:= ""
	aEval(aSelGrp,{|x| cSelGrp += iif(x[1] ,x[2]+",","") })
	If Len(cSelGrp) > 1
		cSelGrp := Left(cSelGrp, Len(cSelGrp)-1) 
	EndIf
	&(cCpoF3) := cSelGrp
EndIf

Return(cSelGrp)

//-----------------------------------------------------------
// Rotina | valgrp | Totvs - David       | Data | 01.11.13
// ----------------------------------------------------------
// Descr. | Rotina de validação da seleção de ao menos um  
//        | grupo de atendimento
//-----------------------------------------------------------
Static Function ValGrp( aSelGrp )

Local lRet 	:= .F.
Local nX	:= 0              
            
For nX := 1 To Len( aSelGrp )
	If aSelGrp[ nX, 1 ]
		lRet := .T.
		Exit
	EndIf	
Next nX

If ! lRet
	Aviso( "@Relacao de Atendimentos", "Selecione um grupo de atendimento para continuar.", { "Ok" }, 1 )
EndIf

Return( lRet )