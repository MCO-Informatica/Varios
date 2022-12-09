#Include 'Protheus.ch'

//---------------------------------------------------------------------------------
// Rotina | MT103IPC       | Autor | Lucas Baia          | Data |    02/08/2022	
//---------------------------------------------------------------------------------
// Descr. | Ponto de Entrada executado após selecionar os Pedidos para Doc. de Entrada
//        | pelo F5.
//---------------------------------------------------------------------------------
// Uso    | ADHESPACK COSMETICOS
//---------------------------------------------------------------------------------


User Function MT103IPC()

Local _nItem         := PARAMIXB[1]
Local _nPosCod       := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
Local _nPosDes       := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_ZDSCR"}) //CAMPO CUSTOMIZADO DESCRIÇÃO DE PRODUTO.
Local _nPosMoeda     := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_X_MOEDA"})
Local _nPosPTAX      := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_X_PTAX"})
Local _nPosVUnitPTAX := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_X_VUNI"})
Local _nPosTotalPTAX := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_X_TOTAL"})

IF _nPosCod > 0 .And. _nItem > 0
    aCols[_nItem,_nPosDes]       := SB1->B1_DESC //RETORNARÁ A DESCRIÇÃO DO PRODUTO
    aCols[_nItem,_nPosMoeda]     := SC7->C7_X_MOEDA //RETORNARÁ A MOEDA
    aCols[_nItem,_nPosPTAX]      := SC7->C7_XPTAX //RETORNARÁ A PTAX
    aCols[_nItem,_nPosVUnitPTAX] := SC7->C7_X_PRECO //RETORNARÁ O PRECO UNITARIO DO PTAX
    aCols[_nItem,_nPosTotalPTAX] := SC7->C7_X_TOTAL //RETORNARÁ VALOR TOTAL DO PTAX
ENDIF

Return
