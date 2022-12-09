#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK271ROTM ºAutor  ³Opvs (David)        º Data ³  23/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusao de Acesso a Rotina de COnhecimento para Liberacao  º±±
±±º          ³de Pedidos de Vendas                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//-------------------------------------------------------------------------------------------------
// RELATO DE MANUTENÇÕES
// ---------------------
// Autor....: Robson Luiz
// Data.....: 08/08/2013
// Descrição: Eliminado a chamada da função U_FILEGEN - Documentado na OTRS número: 
//            Inserido o recurso de submenu com a chamada das funções abaixo.
//-------------------------------------------------------------------------------------------------
User Function TK271ROTM()
	Local nI := 0
	
	Local aRot := {}
	Local aSubRot := {}
	Local aFunc := {}
	Local cOrigem := ''
	
	//------------------------------------------------------------------------
	// Ponto de entrada para atender somente Telemarketing e Agenda Certisign.
	//------------------------------------------------------------------------
	aFunc := {'U_CSFA030','TMKA271'}
	
	//---------------------------------
	// A chamada é da Agenda Certisign?
	//---------------------------------
	If FunName()=='CSFA110'
		For nI := 1 To Len( aFunc )
			If IsInCallStack( aFunc[ nI ] )
				cOrigem := Right( aFunc[ nI ], 7 ) // Capturar somente os 7 últimos caractere no nome: exemplo: U_CSFA030 -> CSFA030.
				Exit
			Endif
		Next nI 
	Else
		cOrigem := FunName()
	Endif
	
	AAdd( aSubRot, { "Conhecimento"   , "MSDOCUMENT"  , 0, 4 } )
	AAdd( aSubRot, { "Oportunidade"   , "U_CSFA220('"+cOrigem+"', NIL )"  , 0, 4 } )
	AAdd( aSubRot, { "Gerar Propostas", "U_A321IPro()",  0, 4 } )
	AAdd( aSubRot, { "Autorizar"      , "U_A321Check()", 0, 4 } )
	
	AAdd( aRot, { "Mais...", aSubRot, 0, 4 } )

Return( aRot )