#include "protheus.ch"

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} BNGPEA12
Cadastro de Locais de Entrega ALELO.

@Return Null
@author Alexandre Alves
@since 12/05/2017.
@version 1.0
/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function BNGPEA12()

Local oBrw       := FWmBrowse():New()
Local aArea      := GetArea()
Local aCores     := {}
Local cFiltroBrw := "ZZP_FILIAL == '"+xFilial('ZZP')+"'"

oBrw  := FWmBrowse():New()
oBrw:SetAlias("ZZP")
oBrw:SetDescription("Cadastro de Locais de Entrega - ALELO")
oBrw:SetFilterDefault( cFiltroBrw )

oBrw:SetMenuDef( 'BNGPEA12' )
oBrw:Activate()

RestArea( aArea )

Return Nil

// Exemplo: Determinando a opção do aRotina pela informação recebida em nOpcUser 

Static Function Exclui(cAlias, nReg, nOpc)

Local nOpcao:= 0

AxDeleta(cAlias,nReg,nOpc)

If nOpcao == 2 //Se confirmou a exclusão	
   MsgInfo("Exclusão realizada com sucesso!")
ElseIf nOpcao == 1	
   MsgInfo("Exclusão cancelada!")
Endif

Return Nil

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} fRetFil(nCodOpe,cCodFil)
Retorno de Informações da Filial para o Cadastro.

nCodOpe = Codigo da Operação de Busca (1 = somente a descrição da filial / 2 = CNPJ da filial.)
cCodFil = Codigo da Filial para Busca.

@Return Null
@author Alexandre Alves
@since 12/05/2017.
@version 1.0
/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function fRetFil(nCodOpe,cCodFil)

Local cDescFil := " "
Local cCNPJ    := " "

If nCodOpe = 1 //-> Só descrição da Filial.
   cDescFil := Posicione("SM0",1,cEmpAnt+cCodFil,"M0_FILIAL")
ElseIf nCodOpe = 2 //-> Só CNPJ da Filial.
   cCNPJ    := Posicione("SM0",1,cEmpAnt+cCodFil,"M0_CGC")
EndIf

Return(If(nCodOpe=1,cDescFil,cCNPJ))
