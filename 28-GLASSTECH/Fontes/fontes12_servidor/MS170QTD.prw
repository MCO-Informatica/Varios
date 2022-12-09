// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : MS170QTD
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 25/09/18 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     25/09/2018
/*/
//------------------------------------------------------------------------------------------
user function MS170QTD
	
local nQtdAtu := 0

dbSelectArea("SB2")
dbSeek( xFilial("SB2")+TRBSB1->B1_COD , .T. )
While !Eof() .And. B2_FILIAL+B2_COD == xFilial("SB2")+TRBSB1->B1_COD

	if SB2->B2_QATU >= SBZ->BZ_ESTSEG 
	   nQtdAtu := 0
		 ElsEif SB2->B2_SALPEDI > 0
	        nQtdAtu := 0
		 Else
	   nQtdAtu := SBZ->BZ_ESTSEG
	endIf

SB2->(dbSkip())
EndDo
return( nQtdAtu )


//--< fim de arquivo >----------------------------------------------------------------------
