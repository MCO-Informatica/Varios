#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/
Ponto de Entrada: FIN565E2
Descri��o       : Permite executar opera��es customizadas ap�s o cancelamento de liquida��o.
                  A execu��o desse PE est� ap�s tratamento padr�o dos saldos do Fornecedor, ap�s a contabiliza��o
                  do cancelamento e antes da exclus�o do t�tulo cancelado
Localiza��o     : Rotina de Cancelamento de Liquida��o

Funcionalidade  : Subtrair de A2_XACPRJ no cancelamento da liquida��o quando for a parcela destinada a pagamento
                  gerada pela rotina de Liquida��o Autom�tica - RFINA002

Condi��es       : Prefixo = PRJ / N�mero = NNNNNN001 / 

Posicionamentos : SE2 - No t�tulo sendo cancelado
                  SA2 - No fornecedor do t�tulo
                  SE5 - No t�tulo original a ser estornado (�ltimo dos originais)
/*/

User function FIN565E2()

Local aArea := GetArea()
Local cMsg  := ""

if SE2->E2_PREFIXO = "PRJ" .and. Substr(SE2->E2_NUM,7,3) $ "001/003/005/007/009" .and. SubStr(SE2->E2_XUSER,1,4)="AUTO"
    
    dbSelectArea("SA2")
    dbsetorder(1)

    // Se o t�tulo tiver um representado, dever� estonar os valores do representado - 17/06/2021
    if !Empty(AllTrim(SE2->E2_XFORREP))
       if !DBSeek(xFilial("SA2")+SE2->E2_XFORREP+SE2->E2_XLOJREP)
          cMsg := "Aten��o: Erro para encontrar o fornecedor representado para"+chr(13)+chr(10)
          cMsg += "estornar os valores acumulados!"+chr(13)+chr(10)+chr(13)+chr(10)
          cMsg += "Verifique o c�digo do representado informado no t�tulo do representante."+chr(13)+chr(10)
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
    if Substr(SE2->E2_NUM,7,3) = "001"                      // Final do n�mero � 001 = Primeira Liquida��o
       A2_XACPRJ := A2_XACPRJ - SE2->E2_SALDO
    else                                                    // Outros = Reliquida��o
       if SubStr(cFilAnt,4,2) = "03"
          A2_XACPRJA := A2_XACPRJA - SE2->E2_SALDO
       else
          A2_XACPRJB := A2_XACPRJB - SE2->E2_SALDO
       endif
    endif 
    MsUnlock()

    if A2_XACPRJ < 0 .or. A2_XACPRJA < 0 .or. A2_XACPRJB < 0
       cMsg := "Aten��o: o campo de Acumulador de Parcelas de Pagamento "+chr(10)+chr(13)
       cMsg += "desse fornecedor ficou negativo."+chr(10)+chr(13)
       cMsg += "Ap�s finaliza��o do cancelamento, favor verificar seu conte�do."+chr(10)+chr(13)
       MessageBox(cMsg,"Erro no Acumulador",16)
    endif

endif

RestArea(aArea)

Return
