#Include "TOTVS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} EmbxProd
Description

@Tela criada para permitir ao usuário relaizar a amarração 
	entre embalagem e Produto
@return xRet Return Description
@author Oscar - oscar@totalsiga.com.br
@since 20/01/2012
/*/
//--------------------------------------------------------------

User Function EmbxProd()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z06"

dbSelectArea("Z06")
dbSetOrder(1)

AxCadastro(cString,"Embalagem x Produto",cVldExc,cVldAlt)

Return lRet:= .T.
