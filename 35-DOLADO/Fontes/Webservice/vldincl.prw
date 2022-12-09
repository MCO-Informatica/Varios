#include 'totvs.ch'

/*/{Protheus.doc} NextA1Lj
Função utilizada no gatilho do campo A1_COD para buscar a proxima numeração disponível da loja
@type function
@version  12.1.33
@author elton.alves@totvs.com.br
@since 25/04/2022
@return character, Código da próxima loja disponível
/*/
user function NextA1Lj(cc)

	local cRet   := ''
	local cAlias := GetNextAlias()

	If Select( cAlias ) <> 0

		( cAlias )->( DbCloseArea() )

	EndIf

	BeginSql alias cAlias
    
    %NOPARSER%

    SELECT MAX( A1_LOJA ) A1_LOJA FROM %Table:SA1% 
    WHERE %NOTDEL%
    AND A1_FILIAL = %XFILIAL:SA1%
    AND A1_COD = %EXP:M->A1_COD%

	EndSql

	If Empty( ( cAlias )->A1_LOJA ) 

		cRet := Replicate( '0', TamSx3( 'A1_LOJA' )[ 1 ] )

	else

		cRet := Soma1( ( cAlias )->A1_LOJA )

	EndIf

	( cAlias )->( DbCloseArea() )

return cRet
