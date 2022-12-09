User Function M103DSE2()

   LOCAL _aResult
                                                 
   If !EMPTY(SE2->E2_IDMOV) .And. SE2->E2_ORIGBD = 'G' //Montes - 06/05/2019 -> Só chama procedure se tiver ID e origem for GESTOQ, procedure especifica para base GESTOQ TPCP

      _aResult := TCSPExec( "ExcCPgGSTQ", Val( SE2->E2_IDMOV ) ) // Chama Store Procedure para excluir titulos GESTOQ
   
      If ValType( _aResult ) <> 'A'

         MsgInfo('Não conformidade ao excluir o Título ' + rTrim( SE2->E2_NUM ) + '/' +SE2->E2_PARCELA + ' ' +rTrim( SE2->E2_NOMFOR ) + '.', 'Rotina mt103dse2' )
   
      EndIf
   EndIf

Return( NIL )