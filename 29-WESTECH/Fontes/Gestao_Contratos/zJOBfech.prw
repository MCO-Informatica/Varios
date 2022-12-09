#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function zJOBfech()

	Local aArea   := GetArea()
    Local oBrowse
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a descri��o da rotina
    oBrowse:SetAlias("CTD")
    oBrowse:SetFilterDefault( "CTD_ITEM<>'ADMINISTRACAO' .AND. CTD_ITEM<>'PROPOSTA' .AND. CTD_ITEM<>'QUALIDADE' .AND. CTD_ITEM<>'ATIVO' .AND. CTD_ITEM<>'ENGENHARIA' .AND. CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD_ITEM<>'XXXXXX' .AND. SUBSTR(CTD_ITEM,9,2) >= '15' .AND. CTD_DTEXSF < DDATABASE "  ) 
    DbSetOrder(1)
  
    oBrowse:Refresh() 
    
Return Nil