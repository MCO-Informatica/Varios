#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
        #DEFINE PSAY SAY
#ENDIF

User Function Sf2520e()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_CREGIST,_CORDEM,_CEMP,_CNFISCAL,_CSERIE")
SetPrvt("_CRSE1,_COSE1,_CRSE3,_COSE3,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>         #DEFINE PSAY SAY
#ENDIF

_cALIAS  := ALIAS()
_cREGIST := RECNO()
_cORDEM  := IndexOrd()

_cEmp    := SM0->M0_CODIGO
_cNFiscal:= SF2->F2_DOC
_cSerie  := SF2->F2_SERIE

IF _cEmp == "01"

     DbSelectArea("SE1")
     _cRSE1 := RECNO()
     _cOSE1  := IndexOrd()
    
     DbSelectArea("SE3")
     _cRSE3 := RECNO()
     _cOSE3  := IndexOrd()
    
    /*/
       ---------------------------------------------
       Especifico para tratamento de Processos Kenia
    */
  
    DbUseArea( .t. ,"TOPCONN" , "SF2030" , "NSF2", .T., .F. )  // Abre arquivo Kenia - Matriz empresa 03
    DbUseArea( .t. ,"TOPCONN" , "SD2030" , "NSD2", .T., .F. )  // Abre arquivo Kenia - Filial empresa 03
    DbUseArea( .t. ,"TOPCONN" , "SE1030" , "NSE1", .T., .F. )  // Abre arquivo Kenia - Matriz empresa 03
    DbUseArea( .t. ,"TOPCONN" , "SE3030" , "NSE3", .T., .F. )  // Abre arquivo Kenia - Filial empresa 03
   
    // Exclui itens da nota fiscal

    DbSelectArea("NSD2")
    DbSetOrder(3)
	DbSeek( xFilial("SD2") + _cNFiscal + _cSERIE )

    While NSD2->D2_DOC == _cNFiscal   .and. ;
          NSD2->D2_SERIE == _cSERIE   .and. !Eof()
		  *NSD2->D2_FILIAL == xFilial("SD2") .and. !Eof()

          RecLock("NSD2", .f.)
             DbDelete()
          MsUnlock()
          
          DbSkip()
    EndDo

    // Exclui titulos do contas a receber

    DbSelectArea("NSE1")
    DbSetOrder(1)
	DbSeek( xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC )

    While NSE1->E1_PREFIXO == SF2->F2_SERIE     .and. ;
          NSE1->E1_NUM == SF2->F2_DOC           .and. !Eof()
		 * NSE1->E1_FILIAL == xFilial("SE1")    .and.

          RecLock("NSE1", .f.)
             DbDelete()
          MsUnlock()
          
          DbSkip()
    EndDo

    // Exclui registros do arquivo de comissoes

    DbSelectArea("NSE3")
    DbSetOrder(1)
	DbSeek( xFilial("SE3") + SF2->F2_SERIE + SF2->F2_DOC )

    While NSE3->E3_PREFIXO == SF2->F2_SERIE     .and. ;
          NSE3->E3_NUM == SF2->F2_DOC           .and. !Eof()
		  *NSE3->E3_FILIAL == xFILIAL("SE3")    .and.

          RecLock("NSE3", .f.)
             DbDelete()
          MsUnlock()
          
          DbSkip()
    EndDo
    
    DbSelectArea("NSF2")
    DbSetOrder(1)
    
	If DbSeek(xFilial("SF2") + SF2->F2_DOC + SF2->F2_SERIE )
       RecLock("NSF2", .f.)
          DbDelete()
       MsUnlock()
    EndIf  
    
    DbSelectArea("NSE1")
    DbCloseArea("NSE1")
    
    DbSelectArea("SE1")
    DbGoto( _cRSE1 )
    DbSetOrder( _cOSE1 )

    DbSelectArea("NSE3")
    DbCloseArea("NSE3")

	DbSelectArea("NSF2")
	DbCloseArea("NSF2")

	DbSelectArea("NSD2")
	DbCloseArea("NSD2")
     
    DbSelectArea("SE3")
    DbGoto( _cRSE3 )
    DbSetOrder( _cOSE3 )

ENDIF

DbSelectArea( _cALIAS )
DbGoto( _cREGIST )
DbSetOrder( _cORDEM )

Return()

          


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

