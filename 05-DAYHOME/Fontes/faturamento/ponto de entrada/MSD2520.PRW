#Include 'protheus.ch'

//----------------------------------------------------------------//
/*/{Protheus.doc} MSD2520
//TODO Ponto de entrada ap?s a exclus?o da nota fiscal de sa?da,
    utilizado para apgar o n?mero da nota fiscal na tabela SZ4,
    que controla os n?meros de s?ries dos produtos.
@author Claudio Macedo
@since 14/02/2022
@version 1.0
/*/
//----------------------------------------------------------------//
User Function MSD2520()

Local cNota  := SF2->F2_DOC 	
Local cSerie := SF2->F2_SERIE 	

SZ4->(DbSetOrder(5))

SZ4->(DbSeek(xFilial('SZ4') + cNota + cSerie))

While !(SZ4->(EOF())) .And. cNota = SZ4->Z4_NOTA .And. cSerie = SZ4->Z4_SERIE
    
        SZ4->(reclock('SZ4',.F.))
        
        SZ4->Z4_NOTA    := ''
        SZ4->Z4_SERIE   := ''
        SZ4->Z4_CLIENTE := ''
        SZ4->Z4_LOJA    := ''
        SZ4->Z4_DTNOTA  := CTOD('  /  /  ')
        
        SZ4->(MsUnlock())

    SD2->(DbSkip())

Enddo

Return Nil
