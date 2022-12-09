#include "protheus.ch"
  
/*
-------------------------------------------------------------------------------
| Rotina     | TK510COR     | Autor | Gustavo Prudente   | Data | 20.04.2015  |
|-----------------------------------------------------------------------------|
| Descricao  | Ponto de entrada para alterar as regras de corres dos status   |
|			 | dos atendimentos.                                              |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
User Function TK510COR
                                                                               
Local nPos	 := 0
Local aCores := ParamIxb[ 1 ]

AAdd( aCores, { "ADE->ADE_XSTOPE == '1'", "CERTI_VERDE_ESCURO" } )
        
// Altera a legenda de atendimento pendente para considerar o status de Abertura/Reabertura
nPos := AScan( aCores, { |x| "ADE->ADE_STATUS == '1'" $ Upper( AllTrim( x[ 1 ] ) ) } )
             
If nPos > 0
    aCores[ nPos, 1 ] := "ADE->ADE_STATUS == '1' .And. ADE->ADE_XSTOPE # '1'"
EndIf

Return( aCores )