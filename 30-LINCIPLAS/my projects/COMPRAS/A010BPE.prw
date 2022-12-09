#Include 'Protheus.ch'

// Ponto de Entrada O Ponto de Entrada A010BPE deve ser utilizado para tratamentos 
// de valida��es de conte�do de caracteres especiais no c�digo do produto ou descri��o, 
// ou valida��es especificas. 
// Sidney Oliveira - Supertech - 06/02/2017
   
User Function A010BPE()
   
local cCampo := ParamIXB[1]
Local cconteudo:= ParamIXB[2]
Local lRet := .F.
   
If cCampo = 'M->B1_DESC'
   lRet:= .T.
EndiF
 
Return lRet