#INCLUDE "PROTHEUS.CH"
//------------------------------------------------------------------------
// Rotina | MT120COR | Rafael Beghini        | Data | 06.07.2018
//------------------------------------------------------------------------
// Descr. | Ponto de entrada para adicionar novas cores no 
//        | browse do pedido de compras. 
//------------------------------------------------------------------------
// Param  | Passagem: ParamIXB[1] - Array com as cores
//        | Retorno.: Array
//------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------
User Function MT120COR()
    Local aCores    := aClone(PARAMIXB[1]) 
    Local aNew      := Array( 1 )
    Local nL        := 0
    //-- Pedido Usado em Pre-Nota de origem MEDIÇÃO
	aNew[1] := { 'C7_QTDACLA >0 .And. !Empty(C7_CONTRA)','CRDIMG16_OCEAN.PNG'} 
    
    For nL := 1 To Len( aCores )
        aAdd( aNew, aCores[nL] )
    Next
Return (aNew)