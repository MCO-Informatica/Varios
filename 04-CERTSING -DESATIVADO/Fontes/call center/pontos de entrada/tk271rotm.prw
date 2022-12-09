#include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK271ROTM �Autor  �Opvs (David)        � Data �  23/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclusao de Acesso a Rotina de COnhecimento para Liberacao  ���
���          �de Pedidos de Vendas                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//-------------------------------------------------------------------------------------------------
// RELATO DE MANUTEN��ES
// ---------------------
// Autor....: Robson Luiz
// Data.....: 08/08/2013
// Descri��o: Eliminado a chamada da fun��o U_FILEGEN - Documentado na OTRS n�mero: 
//            Inserido o recurso de submenu com a chamada das fun��es abaixo.
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
	// A chamada � da Agenda Certisign?
	//---------------------------------
	If FunName()=='CSFA110'
		For nI := 1 To Len( aFunc )
			If IsInCallStack( aFunc[ nI ] )
				cOrigem := Right( aFunc[ nI ], 7 ) // Capturar somente os 7 �ltimos caractere no nome: exemplo: U_CSFA030 -> CSFA030.
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