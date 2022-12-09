#Include 'Protheus.ch'

/*/{Protheus.doc} User Function MT103IPC
    Ponto de Entrada que atualiza os campos customizados do Documento de Entrada após selecionar os Pedidos de Compras através (F5)
    No Cenário abaixo, serve para gravar o campo customizado Desc. Prod (D1_YDESPRO).
    @type  Function
    @author Anderson Martins
    @since 18/10/2022
    @version 12.1.33
    @see https://tdn.totvs.com/display/public/PROT/MT103IPC+-+Atualiza+campos+customizados+no+Documento+de+Entrada
/*/

User Function MT103IPC()
Local _nItem := PARAMIXB[1]
Local _nPosCod := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
Local _nPosDes := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_YDESPRO"}) //COLOCAR O NOME DO CAMPO CUSTOMIZADO CRIADO.

IF _nPosCod > 0 .And. _nItem > 0
    aCols[_nItem,_nPosDes] := SB1->B1_DESC //RETORNARÁ A DESCRIÇÃO DO PRODUTO
ENDIF

Return 
