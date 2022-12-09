#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/07/01
#IFNDEF WINDOWS
#DEFINE Psay Say
#ENDIF

User Function Sn3psn4()        // incluido pelo assistente de conversao do AP5 IDE em 25/07/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NRESP,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/07/01 ==>     #DEFINE Psay Say
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ SN3PSN4  ³ Autor ³  Leandro A. Zimerman  ³ Data ³ 17/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera arquivo de Movimentacoes do ativo fixo (SN4) com base ³±±
±±³          ³ no arq. de saldos e Valores. (SN3)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Espec¡fico para clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFNDEF WINDOWS
    ScreenDraw("SMT250",3,0,0,0)
    @ 03,06 Psay "Processo de Geracao da Movimentacao do Ativo Fixo - (SN4)"
    @ 11,08 Psay " Este programa  ir   efetuar  a cria‡Æo da movimenta‡Æo - (SN4)    " Color "B/BG"
    @ 12,08 Psay " com base no arquivo de saldos e valores - (SN3), ja convertido," Color "B/BG"
    @ 13,08 Psay " e necessario que o arquivo SN4 esteja vazio.                   " Color "B/BG"
    @ 17,04 Psay Space(73) Color "B/W"

    While .T.
        nResp := MenuH({"Confirma","Abandona"},17,04,"b/w,w+/n,r/w","CAP","",1)
        If nResp == 1
            convert()
            Exit
        Else
            Return
        Endif
    EndDo

#ELSE

    @ 200,001 TO 380,395 DIALOG oDlg TITLE OemToAnsi("Processo de Geracao da Movimentacao do Ativo Fixo - (SN4)")
    @ 005,008 TO 068,190
    @ 17,018 SAY OemToAnsi(" Este programa  ir   efetuar  a cria‡Æo da movimenta‡Æo - (SN4)")
    @ 25,018 SAY OemToAnsi(" com base no arquivo de saldos e valores - (SN3), j  convertido,")
    @ 33,018 SAY OemToAnsi(" ‚ necessario que o arquivo SN4 esteja vazio.")

    @ 75,098 BMPBUTTON TYPE 01 ACTION convert()// Substituido pelo assistente de conversao do AP5 IDE em 25/07/01 ==>     @ 75,098 BMPBUTTON TYPE 01 ACTION Execute(convert)
    @ 75,128 BMPBUTTON TYPE 02 ACTION Close(oDlg)

    Activate Dialog oDlg Centered

#ENDIF
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Convert  ³       Leandro A. Zimerman     ³ Data ³ 17/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ gera Movimentacao do Ativo Fixo                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Espec¡fico para clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 25/07/01 ==> Function Convert
Static Function Convert()

Close(oDlg)

Processa({|| RunSN3()},,"Processando SN4...")// Substituido pelo assistente de conversao do AP5 IDE em 25/07/01 ==> Processa({|| Execute(RunSN3)},,"Processando SN4...")
Return

// Substituido pelo assistente de conversao do AP5 IDE em 25/07/01 ==> Function RunSN3
Static Function RunSN3()

dbselectarea("SN3")
dbsetorder(1)

ProcRegua(RecCount())

dbgotop()

Do While !eof()

   If SN3->N3_BAIXA == " "
      dbSkip()
      Loop
   EndIf

   If Empty(SN3->N3_CCONTAB)
      dbSkip()
      Loop
   EndIf
   

   If SN3->N3_TIPO $ "01/02/03/04" 
      // 01 - Aquisicao  
      // 02 - Reavalicao
      // 03 - Adiantamento

      dbSelectArea("SN4")

      If Reclock("SN4",.T.)   // com ocorrencia 05, registro de inclusao do bem
         SN4->N4_FILIAL  := SN3->N3_FILIAL
         SN4->N4_CBASE   := SN3->N3_CBASE
         SN4->N4_ITEM    := SN3->N3_ITEM
         SN4->N4_TIPO    := SN3->N3_TIPO
         SN4->N4_SEQ     := SN3->N3_SEQ
         SN4->N4_OCORR   := "05"   
         SN4->N4_TIPOCNT := "1"
         SN4->N4_CONTA   := SN3->N3_CCONTAB
         SN4->N4_DATA    := SN3->N3_AQUISIC

         dbSelectArea("SN1")
         dbSetOrder(1)
         dbSeek(xFilial("SN1")+SN3->N3_CBASE+SN3->N3_ITEM)
         SN4->N4_QUANTD  := SN1->N1_QUANTD
         dbSelectArea("SN4")

         SN4->N4_VLROC1  := SN3->N3_VORIG1
         SN4->N4_VLROC2  := SN3->N3_VORIG2
         SN4->N4_VLROC3  := SN3->N3_VORIG3
         SN4->N4_VLROC4  := SN3->N3_VORIG4
         SN4->N4_VLROC5  := SN3->N3_VORIG5
         SN4->N4_TXMEDIA := 0
         SN4->N4_TXDEPR  := 0
         SN4->N4_CCUSTO  := SN3->N3_CUSTBEM
         msUnlock()
      EndIf

      If SN3->N3_VRDACM1 > 0        // existindo valor de DEPRECIACAO ACUMULADA 
         If Reclock("SN4", .T.)     // deve-se gerar titulo no sn4 com ocorrencia 06 
            SN4->N4_FILIAL  := SN3->N3_FILIAL
            SN4->N4_CBASE   := SN3->N3_CBASE
            SN4->N4_ITEM    := SN3->N3_ITEM
            SN4->N4_TIPO    := SN3->N3_TIPO
            SN4->N4_SEQ     := SN3->N3_SEQ
            SN4->N4_OCORR   := "06"
            SN4->N4_TIPOCNT := "4"
            SN4->N4_CONTA   := SN3->N3_CCDEPR
            SN4->N4_DATA    := SN3->N3_DINDEPR
            SN4->N4_QUANTD  := 0
            SN4->N4_VLROC1  := SN3->N3_VRDACM1
            SN4->N4_VLROC2  := SN3->N3_VRDACM2
            SN4->N4_VLROC3  := SN3->N3_VRDACM3
            SN4->N4_VLROC4  := SN3->N3_VRDACM4
            SN4->N4_VLROC5  := SN3->N3_VRDACM5
            SN4->N4_TXMEDIA := ROUND((SN3->N3_VRDACM1 / SN3->N3_VRDACM3),2)
            SN4->N4_CCUSTO  := SN3->N3_CCUSTO
            msUnlock()
         EndIf
      EndIf

      If SN3->N3_VRCACM1 > 0        // existindo valor de CORRECAO ACUMULADA deve-se
         If Reclock("SN4",.T.)      // gerar registro no sn4 com ocorrencia 07 para tipo de cta 1
            SN4->N4_FILIAL  := SN3->N3_FILIAL
            SN4->N4_CBASE   := SN3->N3_CBASE
            SN4->N4_ITEM    := SN3->N3_ITEM
            SN4->N4_TIPO    := SN3->N3_TIPO
            SN4->N4_SEQ     := SN3->N3_SEQ
            SN4->N4_OCORR   := "07"
            SN4->N4_TIPOCNT := "1"
            SN4->N4_CONTA   := SN3->N3_CCONTAB
            SN4->N4_DATA    := SN3->N3_DINDEPR
            SN4->N4_QUANTD  := 0
            SN4->N4_VLROC1  := SN3->N3_VRCACM1
            SN4->N4_VLROC2  := 0
            SN4->N4_VLROC3  := 0
            SN4->N4_VLROC4  := 0
            SN4->N4_VLROC5  := 0
            SN4->N4_TXMEDIA := 0
            SN4->N4_TXDEPR  := 0
            SN4->N4_CCUSTO  := SN3->N3_CUSTBEM
            msUnlock()
         EndIf
         If Reclock("SN4",.T.)      // gerar registro no sn4 com ocorrencia 07
            SN4->N4_FILIAL  := SN3->N3_FILIAL
            SN4->N4_CBASE   := SN3->N3_CBASE
            SN4->N4_ITEM    := SN3->N3_ITEM
            SN4->N4_TIPO    := SN3->N3_TIPO
            SN4->N4_SEQ     := SN3->N3_SEQ
            SN4->N4_OCORR   := "07"
            SN4->N4_TIPOCNT := "2"
            SN4->N4_CONTA   := SN3->N3_CCORREC
            SN4->N4_DATA    := SN3->N3_DINDEPR
            SN4->N4_QUANTD  := 0
            SN4->N4_VLROC1  := SN3->N3_VRCACM1
            SN4->N4_VLROC2  := 0
            SN4->N4_VLROC3  := 0
            SN4->N4_VLROC4  := 0
            SN4->N4_VLROC5  := 0
            SN4->N4_TXMEDIA := 0
            SN4->N4_TXDEPR  := 0
            SN4->N4_CCUSTO  := SN3->N3_CCUSTO
            msUnlock()
         EndIf
      EndIf
  
      If SN3->N3_VRCDA1 > 0        // existindo valor da CORRECAO DA DEPRECIACAO ACUMULADA deve-se
         If reclock("SN4",.t.)     // gerar registro no sn4 com ocorrencia 08 e Tipo de conta 5
            SN4->N4_FILIAL  := SN3->N3_FILIAL
            SN4->N4_CBASE   := SN3->N3_CBASE
            SN4->N4_ITEM    := SN3->N3_ITEM
            SN4->N4_TIPO    := SN3->N3_TIPO
            SN4->N4_SEQ     := SN3->N3_SEQ         
            SN4->N4_OCORR   := "08"
            SN4->N4_TIPOCNT := "5"
            SN4->N4_CONTA   := SN3->N3_CCORREC
            SN4->N4_DATA    := SN3->N3_DINDEPR
            SN4->N4_QUANTD  := 0
            SN4->N4_VLROC1  := SN3->N3_VRCDA1
            SN4->N4_VLROC2  := 0
            SN4->N4_VLROC3  := 0
            SN4->N4_VLROC4  := 0
            SN4->N4_VLROC5  := 0
            SN4->N4_TXMEDIA := 0
            SN4->N4_TXDEPR  := 0
            SN4->N4_CCUSTO  := SN3->N3_CCUSTO
            msUnlock()
         EndIf
         If Reclock("SN4",.t.)      // gerar registro no sn4 com ocorrencia 08 e tipo de conta 4
            SN4->N4_FILIAL  := SN3->N3_FILIAL
            SN4->N4_CBASE   := SN3->N3_CBASE
            SN4->N4_ITEM    := SN3->N3_ITEM
            SN4->N4_TIPO    := SN3->N3_TIPO
            SN4->N4_SEQ     := SN3->N3_SEQ         
            SN4->N4_OCORR   := "08"
            SN4->N4_TIPOCNT := "4"
            SN4->N4_CONTA   := SN3->N3_CCDEPR
            SN4->N4_DATA    := SN3->N3_DINDEPR
            SN4->N4_QUANTD  := 0
            SN4->N4_VLROC1  := SN3->N3_VRCDA1
            SN4->N4_VLROC2  := 0
            SN4->N4_VLROC3  := 0
            SN4->N4_VLROC4  := 0
            SN4->N4_VLROC5  := 0
            SN4->N4_TXMEDIA := 0
            SN4->N4_TXDEPR  := 0
            SN4->N4_CCUSTO  := SN3->N3_CCUSTO
            msUnlock()
         EndIf
      EndIf
      If SN3->N3_AMPLIA1 > 0        // existindo valor da AMPLIACAO deve-se gerar registro
         If Reclock("SN4",.T.)     // no SN4 com ocorrencia 09 e Tipo de conta 1
            SN4->N4_FILIAL  := SN3->N3_FILIAL
            SN4->N4_CBASE   := SN3->N3_CBASE
            SN4->N4_ITEM    := SN3->N3_ITEM
            SN4->N4_TIPO    := SN3->N3_TIPO
            SN4->N4_SEQ     := SN3->N3_SEQ
            SN4->N4_OCORR   := "09"
            SN4->N4_TIPOCNT := "1"
            SN4->N4_CONTA   := SN3->N3_CCONTAB
            SN4->N4_DATA    := SN3->N3_DINDEPR
            SN4->N4_QUANTD  := 0
            SN4->N4_VLROC1  := SN3->N3_AMPLIA1
            SN4->N4_VLROC2  := SN3->N3_AMPLIA2
            SN4->N4_VLROC3  := SN3->N3_AMPLIA3
            SN4->N4_VLROC4  := SN3->N3_AMPLIA4
            SN4->N4_VLROC5  := SN3->N3_AMPLIA5
            SN4->N4_TXMEDIA := 0.8287
            SN4->N4_TXDEPR  := 0.8287
            SN4->N4_CCUSTO  := SN3->N3_CUSTBEM
            msUnlock()
         EndIf
      EndIf
    
   /*
   ElseIf SN3->N3_TIPO = "04"
   
      // Se o Registro for Lei 8200 gerar registro no sn4
      // com Tipo 04 e ocorrencia 05 e tipo de conta 1
   
      If Reclock("SN4",.t.)      
         SN4->N4_FILIAL  := SN3->N3_FILIAL
         SN4->N4_CBASE   := SN3->N3_CBASE
         SN4->N4_ITEM    := SN3->N3_ITEM
         SN4->N4_TIPO    := SN3->N3_TIPO
         SN4->N4_SEQ     := SN3->N3_SEQ
         SN4->N4_OCORR   := "05"
         SN4->N4_TIPOCNT := "1"
         SN4->N4_CONTA   := SN3->N3_CCONTAB
         SN4->N4_DATA    := SN3->N3_AQUISIC
         SN4->N4_QUANTD  := 0
         SN4->N4_VLROC1  := SN3->N3_VORIG1
         SN4->N4_VLROC2  := 0
         SN4->N4_VLROC3  := SN3->N3_VORIG3
         SN4->N4_CCUSTO  := SN3->N3_CUSTBEM
         msUnlock()
      Endif */
 
   ElseIf SN3->N3_TIPO = "05"

      // Se o Registro for Reavalicao Negativa gerar registro no sn4
      // com Tipo 05 e ocorrencia 05 e tipo de conta 1
 
      If Reclock("SN4",.t.)      
         SN4->N4_FILIAL  := SN3->N3_FILIAL
         SN4->N4_CBASE   := SN3->N3_CBASE
         SN4->N4_ITEM    := SN3->N3_ITEM
         SN4->N4_TIPO    := SN3->N3_TIPO
         SN4->N4_SEQ     := SN3->N3_SEQ
         SN4->N4_OCORR   := "05"
         SN4->N4_TIPOCNT := "1"
         SN4->N4_CONTA   := SN3->N3_CCONTAB
         SN4->N4_DATA    := SN3->N3_AQUISIC
         SN4->N4_QUANTD  := 0
         SN4->N4_VLROC1  := SN3->N3_VORIG1
         SN4->N4_VLROC2  := 0
         SN4->N4_VLROC3  := SN3->N3_VORIG3
         SN4->N4_CCUSTO  := SN3->N3_CUSTBEM
         SN4->N4_SEQREAV := "01"
         msUnlock()
      EndIf
  
   EndIf

   // Caso o Bem já esteja baixado gera os registros no SN4

   If SN3->N3_BAIXA == "1" .Or. SN3->N3_BAIXA == "2"

      If SN3->N3_TIPO $ "01/02/03" 
         // 01 - Aquisicao  
         // 02 - Reavalicao
         // 03 - Adiantamento

         dbSelectArea("SN4")
  
         If Reclock("SN4",.T.)   // com ocorrencia 01, registro de exclusão do bem
            SN4->N4_FILIAL  := SN3->N3_FILIAL
            SN4->N4_CBASE   := SN3->N3_CBASE
            SN4->N4_ITEM    := SN3->N3_ITEM
            SN4->N4_TIPO    := SN3->N3_TIPO
            SN4->N4_SEQ     := SN3->N3_SEQ
            SN4->N4_OCORR   := "01"   
            SN4->N4_TIPOCNT := "1"
            SN4->N4_CONTA   := SN3->N3_CCONTAB
            SN4->N4_DATA    := SN3->N3_DTBAIXA
  
            dbSelectArea("SN1")
            dbSetOrder(1)
            dbSeek(xFilial("SN1")+SN3->N3_CBASE+SN3->N3_ITEM)
            SN4->N4_QUANTD  := SN1->N1_QUANTD
            dbSelectArea("SN4")

            SN4->N4_VLROC1  := SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1
            SN4->N4_VLROC2  := SN3->N3_VORIG2+SN3->N3_AMPLIA2
            SN4->N4_VLROC3  := SN3->N3_VORIG3+SN3->N3_AMPLIA3
            SN4->N4_VLROC4  := SN3->N3_VORIG4+SN3->N3_AMPLIA4
            SN4->N4_VLROC5  := SN3->N3_VORIG5+SN3->N3_AMPLIA5
            SN4->N4_TXMEDIA := 0
            SN4->N4_TXDEPR  := 0
            SN4->N4_CCUSTO  := SN3->N3_CUSTBEM
            SN4->N4_MOTIVO  := "08"
            msUnlock()
         EndIf

         If SN3->N3_VRDACM1 > 0        // existindo valor de DEPRECIACAO ACUMULADA 
            If Reclock("SN4", .T.)     // deve-se gerar titulo no sn4 com ocorrencia 01 
               SN4->N4_FILIAL  := SN3->N3_FILIAL
               SN4->N4_CBASE   := SN3->N3_CBASE
               SN4->N4_ITEM    := SN3->N3_ITEM
               SN4->N4_TIPO    := SN3->N3_TIPO
               SN4->N4_SEQ     := SN3->N3_SEQ
               SN4->N4_OCORR   := "01"
               SN4->N4_TIPOCNT := "4"
               SN4->N4_CONTA   := SN3->N3_CCDEPR
               SN4->N4_DATA    := SN3->N3_DTBAIXA
               SN4->N4_QUANTD  := 0
               SN4->N4_VLROC1  := SN3->N3_VRDACM1+SN3->N3_VRCDA1
               SN4->N4_VLROC2  := SN3->N3_VRDACM2
               SN4->N4_VLROC3  := SN3->N3_VRDACM3
               SN4->N4_VLROC4  := SN3->N3_VRDACM4
               SN4->N4_VLROC5  := SN3->N3_VRDACM5
               SN4->N4_TXMEDIA := ROUND((SN3->N3_VRDACM1 / SN3->N3_VRDACM3),2)
               SN4->N4_MOTIVO  := "08"
               msUnlock()
            EndIf
         EndIf
    
         /*/
         If SN3->N3_VRDMES1 > 0        // existindo valor de DEPRECIACAO NO MES 

            If Reclock("SN4", .T.)     // deve-se gerar titulo no sn4 com ocorrencia 06 para Conta de Despesa
               SN4->N4_FILIAL  := SN3->N3_FILIAL
               SN4->N4_CBASE   := SN3->N3_CBASE
               SN4->N4_ITEM    := SN3->N3_ITEM
               SN4->N4_TIPO    := SN3->N3_TIPO
               SN4->N4_SEQ     := SN3->N3_SEQ
               SN4->N4_OCORR   := "06"
               SN4->N4_TIPOCNT := "3"
               SN4->N4_CONTA   := SN3->N3_CDEPREC
               SN4->N4_DATA    := SN3->N3_DTBAIXA
               SN4->N4_QUANTD  := 0
               SN4->N4_VLROC1  := SN3->N3_VRDMES1
               SN4->N4_VLROC2  := SN3->N3_VRDMES2
               SN4->N4_VLROC3  := SN3->N3_VRDMES3
               SN4->N4_VLROC4  := SN3->N3_VRDMES4
               SN4->N4_VLROC5  := SN3->N3_VRDMES5
               SN4->N4_TXMEDIA := ROUND((SN3->N3_VRDMES1 / SN3->N3_VRDMES3),2)
               SN4->N4_MOTIVO  := "08"
               msUnlock()
            EndIf

            If Reclock("SN4", .T.)     // deve-se gerar titulo no sn4 com ocorrencia 06 para Conta de Depreciação
               SN4->N4_FILIAL  := SN3->N3_FILIAL
               SN4->N4_CBASE   := SN3->N3_CBASE
               SN4->N4_ITEM    := SN3->N3_ITEM
               SN4->N4_TIPO    := SN3->N3_TIPO
               SN4->N4_SEQ     := SN3->N3_SEQ
               SN4->N4_OCORR   := "06"
               SN4->N4_TIPOCNT := "4"
               SN4->N4_CONTA   := SN3->N3_CCDEPR
               SN4->N4_DATA    := SN3->N3_DTBAIXA
               SN4->N4_QUANTD  := 0
               SN4->N4_VLROC1  := SN3->N3_VRDMES1
               SN4->N4_VLROC2  := SN3->N3_VRDMES2
               SN4->N4_VLROC3  := SN3->N3_VRDMES3
               SN4->N4_VLROC4  := SN3->N3_VRDMES4
               SN4->N4_VLROC5  := SN3->N3_VRDMES5
               SN4->N4_TXMEDIA := ROUND((SN3->N3_VRDMES1 / SN3->N3_VRDMES3),2)
               SN4->N4_MOTIVO  := "08"
               msUnlock()
            EndIf

         EndIf
	 /*/


      ElseIf SN3->N3_TIPO = "04"
   
         // Se o Registro for Lei 8200 gerar registro no sn4
         // com Tipo 04 e ocorrencia 01 e tipo de conta 1
   
         If Reclock("SN4",.t.)      
            SN4->N4_FILIAL  := SN3->N3_FILIAL
            SN4->N4_CBASE   := SN3->N3_CBASE
            SN4->N4_ITEM    := SN3->N3_ITEM
            SN4->N4_TIPO    := SN3->N3_TIPO
            SN4->N4_SEQ     := SN3->N3_SEQ
            SN4->N4_OCORR   := "01"
            SN4->N4_TIPOCNT := "1"
            SN4->N4_CONTA   := SN3->N3_CCONTAB
            SN4->N4_DATA    := SN3->N3_DTBAIXA
            SN4->N4_QUANTD  := 0
            SN4->N4_VLROC1  := SN3->N3_VORIG1
            SN4->N4_VLROC2  := 0
            SN4->N4_VLROC3  := SN3->N3_VORIG3
            SN4->N4_CCUSTO  := SN3->N3_CUSTBEM
            SN4->N4_MOTIVO  := "08"
            msUnlock()
         Endif
 
      ElseIf SN3->N3_TIPO = "05"

         // Se o Registro for Reavalicao Negativa gerar registro no sn4
         // com Tipo 05 e ocorrencia 01 e tipo de conta 1
   
         If Reclock("SN4",.t.)      
            SN4->N4_FILIAL  := SN3->N3_FILIAL
            SN4->N4_CBASE   := SN3->N3_CBASE
            SN4->N4_ITEM    := SN3->N3_ITEM
            SN4->N4_TIPO    := SN3->N3_TIPO
            SN4->N4_SEQ     := SN3->N3_SEQ
            SN4->N4_OCORR   := "01"
            SN4->N4_TIPOCNT := "1"
            SN4->N4_CONTA   := SN3->N3_CCONTAB
            SN4->N4_DATA    := SN3->N3_DTBAIXA
            SN4->N4_QUANTD  := 0
            SN4->N4_VLROC1  := SN3->N3_VORIG1
            SN4->N4_VLROC2  := 0
            SN4->N4_VLROC3  := SN3->N3_VORIG3
            SN4->N4_CCUSTO  := SN3->N3_CUSTBEM
            SN4->N4_SEQREAV := "01"
            SN4->N4_MOTIVO  := "08"
            msUnlock()
         EndIf
  
      EndIf

   EndIf 

   dbSelectArea("SN3")  // leitura do proximo registro do sn3 para processo.
   dbskip()
   IncProc()

EndDo
Return
