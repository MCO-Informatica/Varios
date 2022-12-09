#Include�"protheus.ch"

/*/{Protheus.doc} cslp597()
Posiciona o registro da tabela SED na Natureza de Opera��o da baixa da Compensa��o
Este fonte foi feito porque estava contabilizando com conta cont�bil errada.
Foi colocada a chamada dessa fun��o no lan�amento cont�bil 597/002 no campo de 
conta de cr�dito.
@type function
@author Luciano A Oliveira
@since 10/08/2020
@version P12 R25

/*/

user function�cslp597()
    Local�aArea�:=��getArea()
    Local�cRetConta�:=�""

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

Return�cRetCta
