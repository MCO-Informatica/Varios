#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEM10
Locais de Entrega - ALELO.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------

User Function BNGPEA10

 Private cCadastro := "Locais de Entrega - ALELO"
 Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

 Private aRotina := { { "Pesquisar"    , "AxPesqui"      ,0 , 1 } ,;
                      { "Visualizar"   , "AxVisual"      ,0 , 2 } ,;
                      { "Incluir"      , "AxInclui"      ,0 , 3 } ,;
                      { "Alterar"      , "AxAltera"      ,0 , 4 } ,;
                      { "Excluir"      , "AxDeleta"      ,0 , 5 } }

 dbSelectArea( "ZZP" )
 dbSetOrder( 1 )

 mBrowse( 6,1,22,75,"ZZP" )

Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPExcl
Retorna informações da Filial.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
User Function RetFil(nOpt)

Loca cRet := " "

 SM0->(dbSeek(cEmpAnt+M->ZZP_FILZZP))
 
 If nOpt = 1
   cRet := SM0->(M0_FILIAL)
 Else
   cRet := SM0->(M0_CGC)
 EndIf 
 
Return(cRet)
 


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPExcl
Valida o processo de exclusão.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $05.05.2017}
/*/
//------------------------------------------------------------------------------------------
/*

DESENVOLVER AQUI AS REGRAS DE VALIDAÇÃO DO LOCAL DE ENTREGA.

Static Function BNGPExcl()

Local cQuery := ""

cQuery := "SELECT 1 FROM '"+RetSqlName("")




Return
*/