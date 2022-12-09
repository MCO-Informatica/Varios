#Include "protheus.ch"

/*/{Protheus.doc} cslp597()
Posiciona o registro da tabela SED na Natureza de Operação da baixa da Compensação
Este fonte foi feito porque estava contabilizando com conta contábil errada.
Foi colocada a chamada dessa função no lançamento contábil 597/002 no campo de 
conta de crédito.
@type function
@author Luciano A Oliveira
@since 10/08/2020
@version P12 R25

/*/

user function cslp597()
    Local aArea :=  getArea()
    Local cRetConta := ""

    dbSelectArea("SE2")
    SE2->(dbSetOrder(1))
        
    if SE2->(dbSeek(xFilial("SED") + strlctpad))
        dbSelectArea("SED")
        SED->(dbSetOrder(1))
        if SED->(dbSeek(xFilial("SE2") + SE2->E2_NATUREZ))
            cRetCta := SED->ED_CONTA
        endif
    endif
    
    RestArea(aArea)

Return cRetCta
