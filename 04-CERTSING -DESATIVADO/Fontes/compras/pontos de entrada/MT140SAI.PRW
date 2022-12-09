#Include 'Protheus.ch'
//------------------------------------------------------------------------
// Rotina | MT140SAI | Rafael Beghini                | Data | 06.09.2019
//------------------------------------------------------------------------
// Descr. | Ponto de entrada executado no final da gravação da pré-Nota
//------------------------------------------------------------------------
// Param  | PARAMIXB[1] = Numero da operação - ( 2-Visualização, 3-Inclusão, 4-Alteração, 5-Exclusão )
//          PARAMIXB[2] = Número da nota
//          PARAMIXB[3] = Série da nota
//          PARAMIXB[4] = Fornecedor
//          PARAMIXB[5] = Loja
//          PARAMIXB[6] = Tipo
//          PARAMIXB[7] = Opção de Confirmação (1 = Confirma pré-nota; 0 = Não Confirma pré-nota)
// Retorno| Nenhum retorno esperado pelo ponto de entrada.
//------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------
User Function MT140SAI()
    Local cNumDoc   := ParamIxb[2] + ParamIxb[3] +ParamIxb[4] + ParamIxb[5]
    Local cTRB      := ''
    Local aDelACB   := {}
    Local nL        := 0

    IF ParamIxb[1] == 3 .And. ParamIxb[7] == 1
        cTRB := GetNextAlias()
        BeginSQL Alias cTRB
            SELECT D1_PEDIDO 
            FROM %Table:SF1% SF1 
                INNER JOIN %Table:SD1% SD1 
                        ON SD1.%NOTDEL%
                            AND D1_FILIAL   = F1_FILIAL 
                            AND D1_DOC      = F1_DOC 
                            AND D1_SERIE    = F1_SERIE 
                            AND D1_FORNECE  = F1_FORNECE 
                            AND D1_LOJA     = F1_LOJA
                            AND D1_PEDIDO   > ' ' 
            WHERE  SF1.%NOTDEL%
                AND F1_FILIAL   = %xFilial:SF1%
                AND F1_DOC      = %Exp:ParamIxb[2]%
                AND F1_SERIE    = %Exp:ParamIxb[3]%
                AND F1_FORNECE  = %Exp:ParamIxb[4]%
                AND F1_LOJA     = %Exp:ParamIxb[5]%
            GROUP BY D1_PEDIDO 
        EndSQL
        
        While .NOT. (cTRB)->( EOF() )
            U_CSReplica( 'SC7', 'SF1', (cTRB)->D1_PEDIDO, cNumDoc )
            (cTRB)->( dbSkip() )
        End
    EndIf    
Return