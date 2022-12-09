#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Acertac()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPEDIDO,NRECNO,")

// Ajuste de Comissao.

DbUseArea( .T. ,"TOPCONN" , "SE3030" , "NSE3", .T., .F. )  // Abre arquivo Kenia - Matriz empresa 03

#IFDEF WINDOWS
       RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>        RptStatus({|| Execute(RptDetail)})
       Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>        Function RptDetail
Static Function RptDetail()
#ENDIF

// Limpa as comissoes.
dbSelectArea("NSE3")
dbGoTop()
SetRegua(RecCount())

While !Eof()

      IncRegua()

      IF NSE3->E3_PREFIXO == "UNI"
         RecLock("NSE3")
         Dele
         MsUnLock()
      EndIF

      dbSkip()

End

// Gravacao de Comissoes.
DbSelectArea("SE3")
DbSetOrder(1)
DbGotop()
SetRegua(Reccount())

While !Eof()
       
       DbSelectArea("SE3") 

       If AllTrim(SE3->E3_TIPO) == "NCC"
          Devolu()
	   Else
		  cPedido := SE3->E3_PEDIDO
		  Grava()
       EndIf


       DbSelectArea("SE3")
       DbSkip()
       IncRegua()
EndDo

__RetProc()


***************************

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Grava
Static Function Grava()

       DbSelectArea("SC5")
       DbSetOrder(1)
       DbSeek( xFilial("SC5") + cPedido )
       
       If Found() .and. SC5->C5_PAPELET == "O"
          
          DbSelectArea("NSE3")  // le arquivo Kenia matriz
          DbSetOrder(1)
		  If !DbSeek( xFilial("SE3") + SE3->E3_PREFIXO + SE3->E3_NUM + SE3->E3_PARCELA )
           
                DbSelectArea("NSE3")
                RecLock("NSE3", .t.)
                   NSE3->E3_FILIAL  := SE3->E3_FILIAL
                   NSE3->E3_VEND    := SE3->E3_VEND   
                   NSE3->E3_PREFIXO := SE3->E3_PREFIXO
                   NSE3->E3_NUM     := SE3->E3_NUM
                   NSE3->E3_EMISSAO := SE3->E3_EMISSAO
                   NSE3->E3_SERIE   := SE3->E3_SERIE
                   NSE3->E3_CODCLI  := SE3->E3_CODCLI
                   NSE3->E3_LOJA    := SE3->E3_LOJA
                   NSE3->E3_BASE    := SE3->E3_BASE
                   NSE3->E3_PORC    := SE3->E3_PORC
                   NSE3->E3_COMIS   := SE3->E3_COMIS
                   NSE3->E3_DATA    := SE3->E3_DATA
                   NSE3->E3_PARCELA := SE3->E3_PARCELA
                   NSE3->E3_TIPO    := SE3->E3_TIPO
                   NSE3->E3_BAIEMI  := SE3->E3_BAIEMI
                   NSE3->E3_PEDIDO  := SE3->E3_PEDIDO
                   NSE3->E3_AJUSTE  := SE3->E3_AJUSTE
                   NSE3->E3_SEQ     := SE3->E3_SEQ
                   NSE3->E3_ORIGEM  := SE3->E3_ORIGEM
                MsUnlock()
          EndIf
       EndIf
__RetProc()


***************

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Devolu
Static Function Devolu()
      
DbSelectArea("SE3")
nRecno := Recno()   

DbSelectArea("SD1")
DbSetOrder(1)
DbSeek( xFilial("SD1") + SE3->E3_NUM + SE3->E3_PREFIXO )

While xFilial("SD1") == SD1->D1_FILIAL .and. ;
      SD1->D1_DOC == SE3->E3_NUM .and. ;
      SD1->D1_SERIE == SE3->E3_PREFIXO .and. !Eof()
      
      DbSelectArea("SE3")
      DbSetOrder(1)
      
      IF DbSeek( xFilial("SE3") + SD1->D1_SERIORI + SD1->D1_NFORI )
         cPedido := SE3->E3_PEDIDO
         
         DbSelectArea("SE3")
         DbGoto(nRecno)
         Grava()
         Exit
      EndIf
   
   DbSelectArea("SD1")
   DbSkip()
EndDo

DbSelectArea("SE3")
DbGoto(nRecno)

__RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

