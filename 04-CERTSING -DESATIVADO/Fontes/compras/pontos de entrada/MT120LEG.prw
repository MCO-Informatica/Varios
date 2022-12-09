#INCLUDE "PROTHEUS.CH"
//------------------------------------------------------------------------
// Rotina | MT120LEG | Rafael Beghini        | Data | 06.07.2018
//------------------------------------------------------------------------
// Descr. | Ponto de entrada para adicionar novas legendas no 
//        | browse do pedido de compras. 
//------------------------------------------------------------------------
// Param  | Passagem: ParamIXB[1] - Array com a descrição das cores
//        | Retorno.: Array
//------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------
User Function MT120LEG()
    Local aNewLegenda  := aClone(PARAMIXB[1])
    
    aAdd(aNewLegenda,{'CRDIMG16_OCEAN.PNG','Em recebimento (Pré-nota) - Origem MEDIÇÃO'})
    
Return (aNewLegenda)