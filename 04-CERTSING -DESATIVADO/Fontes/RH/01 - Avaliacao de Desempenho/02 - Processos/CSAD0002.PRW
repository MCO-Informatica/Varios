#include "protheus.ch"
#include "apdm010.ch"

/*+-------------------------------------------------------------------------------------
  | Função.: 

*/
User Function CSAD0002()

Local oBrw       := FWmBrowse():New()
Local aArea      := GetArea()
Local aCores     := {}
Local cFiltroBrw := CHKRH(FunName(),"RD6","1")

Private aRotina  := {}

AADD(aRotina,{"Pesquisar" ,"PesqBrw"   ,0,1})
AADD(aRotina,{"Visualizar","AxVisual"  ,0,2})
AADD(aRotina,{"Legenda"   ,"U_BLegenda",0,6})
AADD(aRotina,{"Calculo"   ,"U_BLegenda",0,6})

oBrw  := FWmBrowse():New()
oBrw:SetAlias("RD6")
oBrw:SetDescription("Calculo das Avaliações - CERTISIGN")
oBrw:SetFilterDefault( cFiltroBrw )


oBrw:AddLegend( "RD6_STATUS == '1'" ,"BR_VERDE",    "Avaliação Aberta" )
oBrw:AddLegend( "RD6_STATUS <> '1'" ,"BR_VERMELHO", "Avaliação Encerrada" )
oBrw:SetMenuDef( 'CSAD0002' )
oBrw:Activate()

RestArea( aArea )

Return Nil

 

Static Function Exclui(cAlias, nReg, nOpc)

Local nOpcao:= 0

AxDeleta(cAlias,nReg,nOpc)

If nOpcao == 2 //Se confirmou a exclusão	
   MsgInfo("Exclusão realizada com sucesso!")
ElseIf nOpcao == 1	
   MsgInfo("Exclusão cancelada!")
Endif

Return Nil

//+-------------------------------------------//|Função: BLegenda - Rotina de Legenda//+-------------------------------------------

User Function BLegenda()

Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE",   "Avaliação Aberta"    })
AADD(aLegenda,{"BR_VERMELHO","Avaliação Encerrada" })

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil


