#INCLUDE "PROTHEUS.CH"

User Function F200CNAB()

   LOCAL _lBxCnab
   
   If Type( '_oProcess' ) <> 'O'

      PUBLIC _oProcess
      PUBLIC _oHtml 
      PUBLIC _nValPagto

   End

   _lBxCnab := GetMv('MV_BXCNAB') = 'S'

   _oProcess := TWFProcess():New( "000003", "Retorno CNAB SISCOB" )
   _oProcess:NewTask( "Processamento", "\WORKFLOW\WFCNABRet.htm" )
   _oProcess:cSubject := 'Baixas Contas a Receber'
   _oProcess:bReturn  := "U_WFW120P( 1 )"
   _oProcess:bTimeOut := {{"U_WFW120P( 2 )", 30, 0, 5 }}
   _oHtml := _oProcess:oHtml
   _oHtml:ValByName( "empresa", rTrim( SM0->M0_NOMECOM ) )
   _oHtml:ValByName( "tipo", 'SISCOB ' + Substr( MV_PAR04, RAt( '\', MV_PAR04 ) + 1 ) )
   _oHtml:ValByName( "conta", MV_PAR06 + '-' + MV_PAR07 + '-' + MV_PAR08 )
   
   _nValPagto  := 0 

Return( _lBxCnab )