#include 'protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | SPED0150 | Autor | Rafael Beghini | Data | 06.11.2018 
//+-------------------------------------------------------------------+
//| Descr. | PE para alterar as informações dos registros 0150
//|        | gerados para o SPED Fiscal e SPED Contribuições.
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function SPED0150()
    Local aReg0150  := ParamIXB[ 1 ]
    Local nPosCompl := Iif( IsInCallStack( 'SPEDFISCAL' ), 12, 13 )
    Local cString   := aReg0150[ nPosCompl ]

    //-- FwCutOff > Funcao para retirar CR/LF/TAB de strings e eventualmente acentos
    aReg0150[ nPosCompl ] := rTrim( FwCutOff( cString, .T. ) )
Return( aReg0150 )