#Include "protheus.ch"
#Include "rwmake.ch"

User Function RFATG15()

Local _lRet:=.F.
Local _cProduto := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO" })]
Local _cKit     := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_KIT"   })]
Local _cTes     := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_TES"     })]

If M->C5_TABELA$"ZZZ"
    _lRet := .T.
EndIf
    
//----> DESPESAS DIVERSAS LIBERA A EDICAO DO PRECO DE VENDA E PRECO DE LISTA
If Alltrim(_cProduto)$"12001001010" .or. Alltrim(_cProduto)$"900"
    _lRet := .T.
EndIf

//----> TES QUE NAO GERA FINANCEIRO LIBERA A EDICAO DO PRECO DE VENDA E PRECO E LISTA
If Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_DUPLIC")$"N"
    _lRet := .T.
EndIf

//----> DISTRIBUIDORES LIBERA A EDICAO DO CAMPO PRECO DE VENDA E PRECO DE LISTA
If Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_GRPVEN")$"000001"
    _lRet := .T.
EndIf

Return(_lRet)
