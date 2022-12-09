#include 'protheus.ch'
#include 'parmtype.ch'

user function zFJobAberto()
	
Local aGetArea := GetArea()

Local aInd:={}
Local cCondicao
Local bFiltraBrw
Local oDlgPrd
Local oBrowse
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a descrição da rotina
    oBrowse:SetAlias("CTD")

CTD->(DbClearFilter())

cCondicao:= "! alltrim(CTD->CTD_ITEM) $ 'ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ESTOQUE/OPERACOES' .AND. SUBSTR(CTD_ITEM,9,2) >= '15' .AND. CTD_DTEXSF >= DDATABASE "

bFiltraBrw := {|| FilBrowse("CTD",@aInd,@cCondicao) }
Eval(bFiltraBrw)

return