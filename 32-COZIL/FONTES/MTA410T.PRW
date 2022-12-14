#Include 'Protheus.ch'

//---------------------------------------------------------------------------------
// Rotina | MTA410T           | Autor | Lucas Baia          | Data | 02/02/2021
//---------------------------------------------------------------------------------
// Descr. | Ponto de Entrada que se refere a Grava??o ap?s de Confirmar o Pedido
//        | de venda.
//---------------------------------------------------------------------------------
// Uso    | Protheus 12.1.33
//---------------------------------------------------------------------------------
// Links  | https://tdn.totvs.com/display/public/PROT/MTA410T
//---------------------------------------------------------------------------------
User Function MTA410T()
Local aArea := GetArea()
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSC9 := SC9->(GetArea())

// Grava Total no Pedido de Vendas
U_TotPed(SC5->C5_NUM)

RestArea(aArea)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
Return .T.



User Function TotPed(cNumPed)
Local aArea := GetArea()
// Gravacao do Campo Valor Total do Pedido de Vendas

If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNumPed))
RestArea(aArea)
Return .F.
Endif

MaFisIni(SC5->C5_CLIENTE,; // 1-Codigo Cliente/Fornecedor
SC5->C5_LOJACLI,; // 2-Loja do Cliente/Fornecedor
"C",; // 3-C:Cliente , F:Fornecedor
SC5->C5_TIPO,; // 4-Tipo da NF
SC5->C5_TIPOCLI,; // 5-Tipo do Cliente/Fornecedor
MaFisRelImp("MTR700",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
,; // 7-Tipo de complemento
,; // 8-Permite Incluir Impostos no Rodape .T./.F.
"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
"MTR700") // 10-Nome da rotina que esta utilizando a funcao

nItem := 0
nValIcmSt := 0
nDesconto := 0
//???????????????????????????????????????????????????????????????????Ŀ
//? Faz manualmente porque nao chama a funcao Cabec() ?

//?????????????????????????????????????????????????????????????????????
nNrItem:=0
If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
While !Eof() .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == cNumPed
nNritem+=1
dbSkip()
Enddo
Endif

nCusTotal := 0.00
nPedTotal := 0.00
nVlrTotal := 0.00
nTotDesc := 0.00
nIPI := 0.00
nICM := 0.00
nValIcm := 0.00
nValIpi := 0.00
nTotIpi := 0.00
nTotIcms := 0.00
nTotDesp := 0.00
nTotFrete := 0.00
nTotalNF := 0.00
nTotSeguro := 0.00
nTotMerc := 0.00
nTotIcmSol := 0.00

If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
While SC6->(!Eof()) .And. xFilial("SC6")==SC6->C6_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
nItem ++
MaFisAdd(SC6->C6_PRODUTO,; // 1-Codigo do Produto ( Obrigatorio )
SC6->C6_TES,; // 2-Codigo do TES ( Opcional )
SC6->C6_QTDVEN,; // 3-Quantidade ( Obrigatorio )
SC6->C6_PRCVEN,; // 4-Preco Unitario ( Obrigatorio )
nDesconto,; // 5-Valor do Desconto ( Opcional )
nil,; // 6-Numero da NF Original ( Devolucao/Benef )
nil,; // 7-Serie da NF Original ( Devolucao/Benef )
nil,; // 8-RecNo da NF Original no arq SD1/SD2
SC5->C5_FRETE/nNritem,; // 9-Valor do Frete do Item ( Opcional )
SC5->C5_DESPESA/nNritem,; // 10-Valor da Despesa do item ( Opcional )
SC5->C5_SEGURO/nNritem,; // 11-Valor do Seguro do item ( Opcional )
0,; // 12-Valor do Frete Autonomo ( Opcional )
SC6->C6_Valor+nDesconto,; // 13-Valor da Mercadoria ( Obrigatorio )
0,; // 14-Valor da Embalagem ( Opcional )
0,; // 15-RecNo do SB1
0) // 16-RecNo do SF4
nIPI := MaFisRet(nItem,"IT_ALIQIPI")
nICM := MaFisRet(nItem,"IT_ALIQICM")
nValIcm := MaFisRet(nItem,"IT_VALICM")
nValIpi := MaFisRet(nItem,"IT_VALIPI")
nTotIpi := MaFisRet(,'NF_VALIPI')
nTotIcms := MaFisRet(,'NF_VALICM')
nTotDesp := MaFisRet(,'NF_DESPESA')
nTotFrete := MaFisRet(,'NF_FRETE')
nTotalNF := MaFisRet(,'NF_TOTAL')
nTotSeguro := MaFisRet(,'NF_SEGURO')
aValIVA := MaFisRet(,"NF_VALIMP")
nTotMerc := MaFisRet(,"NF_TOTAL")
nTotIcmSol := MaFisRet(nItem,'NF_VALSOL')
nCusTotal  += SC6->C6_QTDVEN * Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_CUSTD")
nPedTotal  += SC6->C6_VALOR

SC6->(DbSkip())
EndDo
nVlrTotal := Round(nTotMerc + nTotSeguro+nTotDesp - nTotDesc,2)

Endif
MaFisEnd()//Termino

If RecLock("SC5",.F.)
SC5->C5_XTOTAL  := nPedTotal
SC5->C5_XMKP    := Iif(nCusTotal>0,Round((nPedTotal/nCusTotal),2),99.99)
SC5->(MsUnlock())
Endif

RestArea(aArea)
Return .T.




