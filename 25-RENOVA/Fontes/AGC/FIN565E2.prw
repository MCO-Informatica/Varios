#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/
Ponto de Entrada: FIN565E2
Descrição       : Permite executar operações customizadas após o cancelamento de liquidação.
                  A execução desse PE está após tratamento padrão dos saldos do Fornecedor, após a contabilização
                  do cancelamento e antes da exclusão do título cancelado
Localização     : Rotina de Cancelamento de Liquidação

Funcionalidade  : Subtrair de A2_XACPRJ no cancelamento da liquidação quando for a parcela destinada a pagamento
                  gerada pela rotina de Liquidação Automática - RFINA002

Condições       : Prefixo = PRJ / Número = NNNNNN001 / 

Posicionamentos : SE2 - No título sendo cancelado
                  SA2 - No fornecedor do título
                  SE5 - No título original a ser estornado (último dos originais)
/*/

User function FIN565E2()

Local aArea := GetArea()
Local cMsg  := ""

if SE2->E2_PREFIXO = "PRJ" .and. Substr(SE2->E2_NUM,7,3) $ "001/003/005/007/009" .and. SubStr(SE2->E2_XUSER,1,4)="AUTO"
    
    dbSelectArea("SA2")
    dbsetorder(1)

    // Se o título tiver um representado, deverá estonar os valores do representado - 17/06/2021
    if !Empty(AllTrim(SE2->E2_XFORREP))
       if !DBSeek(xFilial("SA2")+SE2->E2_XFORREP+SE2->E2_XLOJREP)
          cMsg := "Atenção: Erro para encontrar o fornecedor representado para"+chr(13)+chr(10)
          cMsg += "estornar os valores acumulados!"+chr(13)+chr(10)+chr(13)+chr(10)
          cMsg += "Verifique o código do representado informado no título do representante."+chr(13)+chr(10)
          cMsg += "Representante: "+SE2->E2_FORNECE+"/"+SE2->E2_LOJA+chr(13)+chr(10) 
          cMsg += "Representado : "+SE2->E2_XFORREP+"/"+SE2->E2_XLOJREP+chr(13)+chr(10) 
          MessageBox(cMsg,"Erro ao acessar cadastro do Representado",16)
          RestArea(aArea)
          Return
       else
          DBSeek(xFilial("SA2")+SE2->E2_XFORREP+SE2->E2_XLOJREP)
       endif
    endif

    RecLock("SA2", .F.)
    if Substr(SE2->E2_NUM,7,3) = "001"                      // Final do número é 001 = Primeira Liquidação
       A2_XACPRJ := A2_XACPRJ - SE2->E2_SALDO
    else                                                    // Outros = Reliquidação
       if SubStr(cFilAnt,4,2) = "03"
          A2_XACPRJA := A2_XACPRJA - SE2->E2_SALDO
       else
          A2_XACPRJB := A2_XACPRJB - SE2->E2_SALDO
       endif
    endif 
    MsUnlock()

    if A2_XACPRJ < 0 .or. A2_XACPRJA < 0 .or. A2_XACPRJB < 0
       cMsg := "Atenção: o campo de Acumulador de Parcelas de Pagamento "+chr(10)+chr(13)
       cMsg += "desse fornecedor ficou negativo."+chr(10)+chr(13)
       cMsg += "Após finalização do cancelamento, favor verificar seu conteúdo."+chr(10)+chr(13)
       MessageBox(cMsg,"Erro no Acumulador",16)
    endif

endif

RestArea(aArea)

Return
