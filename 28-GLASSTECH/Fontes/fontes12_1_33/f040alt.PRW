/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F040ALT  ºAutor  ³ Sérgio Santana     º Data ³ 20/06/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na alteração do titulo do Contas a Receberº±±
±±º          ³ - Tratamento para realizar a alteração do valor/data de    º±±
±±º          ³   vencimento no sistema GESTOQ.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Glasstech                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F040ALT()

LOCAL _nIdVct  := SE1->E1_IDBOLET
LOCAL _nResult := NIL
LOCAL _lRet    := .F.

If SE1->E1_TIPO = 'RA ' .Or.;
   SE1->E1_TIPO = 'PRE' .Or.;
   SE1->E1_TIPO = 'NCC'

   _lRet := .F.

Else

   _nResult := TCSPExec("f04_50Alt"     ,;
	                     _nIdVct        ,;
	                     SE1->E1_VALOR  ,;
	                     SE1->E1_VENCREA,;
	                     SE1->E1_DECRESC,;
	                     SE1->E1_ACRESC ,;
	                     SE1->E1_ORIGBD  ;
                       )

   //Precisa validar o que esta retornando da procedure para apresentação de mensagem de erro.
   //If Empty(_nResult)
   //   Aviso('F04_50ALT','Erro na execução da Stored Procedure : '+TcSqlError(),{"Sair"})
   //Else
      RecLock("SE1",.F.)
         SE1->E1_MSEXP := DTOS(DATE())
      MsUnLock()
   //Endif

   _lRet := .T.

EndIf

Return( _lRet )