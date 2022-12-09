#include "PROTHEUS.CH"
Static cBDGSTQ	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)

/*/{Protheus.doc} ImpGESTOQ
//TODO Descrição auto-gerada.
@author Desconhecido
@since 26/08/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function ImpGESTOQ()

If ( Pergunte( 'IMPGSTQ', .T. ) )
                                                                      
   _dDta := DtoS( MV_PAR01 )

   If (MsgYesNo('Confirma a integração das informações referente ao dia ' + DtoC( MV_PAR01 ) + ' ?' ))

      Processa( { || CargaGstq() }, 'Aguarde...','Importando registros Gestoq..' )
      
      If MV_PAR02 = 1

         _eSql := "EXEC "+cBDPROT+".dbo.UpdFlxCxa '" + _dDta + "'"
         _nRet := TCSQLExec( _eSql )

      End

      MsgInfo('Processamento finalizado!' )

   End

End

Return( NIL )

Static Function CargaGstq()

ProcRegua( 8 )

IncProc('Aguarde, importando Contas a Pagar..')
U_CtaPgGstq('  ', _dDta, _dDta , ' ', MV_PAR03 )

IncProc('Aguarde, importando Movimento bancário...' )
U_CtaMvGstq(_dDta, _dDta)

IncProc('Aguarde, importando Nota Fiscal de Saída...' )
U_NFSDAGSTQ(_dDta, _dDta, .T. )

IncProc('Aguarde, importando Nota Fiscal de Devolução...' )

U_NFDEVGSTQ(_dDta, _dDta)

IncProc('Aguarde, importando Nota Fiscal reclassificadas...' )

U_NfCL8Gstq(_dDta, _dDta)

IncProc('Aguarde, importando Contas a Receber...' )

U_CtaRcGstq('  ', _dDta, _dDta , ' ')   // Excluido flag referente as baixas a partir gestoq em 16/05/2017

U_CtaRcGstq('BV', _dDta, _dDta , ' ')
                                     
//IncProc('Aguarde, importando Adiantamentos...' )  rotina desativada em 03/05/2017 em virtude das compesações que estão sando realizadas pelo TOTVS
//U_CtaAdGstq( _dDta, _dDta )

IncProc('Aguarde, atualizando dados para geração da planilha...' )

Inkey( 1 )

Return( NIL )

/*

Retorna a Filial do Prothes com base no CNPJ da Empresa de Origem do GESTOQ

*/
User Function GestqFil(cCgc,_pTipo)
                    
Local cRetFil := SPACE(4)

If  cCgc = '48254858000109' 
    cRetFil := '0101'
ElseIf cCgc = '48254858000290'
    cRetFil := '0102' 
ElseIf cCgc = '48254858000451'
    cRetFil := '0103' 
ElseIf cCgc = '03061254000108'
    cRetFil := '0201'
ElseIf cCgc = '03061254000299'
    cRetFil := '0202'
ElseIf cCgc = '67313247000139'
    cRetFil := '0301' 
ElseIf cCgc = '04051564000104'
    cRetFil := '0401'
ElseIf cCgc = '09158959000124'
    cRetFil := '0501'
ElseIf cCgc = '04657999000105'
    cRetFil := '0601'
ElseIf cCgc = '03061254000370'
    cRetFil := '0215'
ElseIf cCgc = '25074100000193'
    cRetFil := '0801'
ElseIf cCgc = '11175943000171' // FFM    
    cRetFil := '0701'
ElseIf cCgc = '36360406000122' //
    cRetFil := '1601'
ElseIf cCgc = '36360406000203' //
    cRetFil := '1602'
ElseIf cCgc = '47958868000162' //
    cRetFil := '2001'
Else
    cRetFil := '9001'
EndIf

cRetFil := IIF( (_pTipo <> 'BV') .Or. (_pTipo = 'BV' .And. cRetFil = '0701'), cRetFil, '9001')
    
Return cRetFil
