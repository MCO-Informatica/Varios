#INCLUDE 'PROTHEUS.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � CPACVD   � Autor � RICARDO CAVALINI   � Data �  04/11/09   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de update dos dicion�rios para compatibilizacao     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � UPDFST   - V.2.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CPACVD()

Local   aSay     := {}
Local   aButton  := {}
Local   aMarcadas:= {}
Local   cTitulo  := 'Geracao de plano de contas x plano referencial '
Local   cDesc1   := 'Esta rotina tem como fun��o fazer a atualiza��o da tabela CVD - plano de contas x plano referencial '
Local   cDesc2   := ''
Local   cDesc3   := ''
Local   cDesc4   := ''
Local   cDesc5   := ''
Local   cDesc6   := ''
Local   cDesc7   := ''
Local   lOk      := .F.

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, '*OFF' ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch()  } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch()  } } )

FormBatch(  cTitulo,  aSay,  aButton )

If lOk
//	oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, 'Atualizando', 'Aguarde , atualizando ...', .F. )
	oProcess:Activate()


	If lOk
		Final( 'Atualiza��o Conclu�da' )
	Else
		Final( 'Atualiza��o n�o Realizada' )
	EndIf
EndIf

Return NIL
