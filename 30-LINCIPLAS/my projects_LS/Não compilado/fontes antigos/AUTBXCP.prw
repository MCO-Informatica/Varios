#include "ap5mail.ch"
#include "sigawin.ch"
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"


//Baixa Automatizada CP com Totalizador
User Function AUTBXCP()
Local cBanco   := Criavar("A6_COD")
Local cAgencia := Criavar("A6_AGENCIA")
Local cConta   := Criavar("A6_NUMCON")
Local cCheque  := Criavar("A6_NUMCON")
Local cNatureza:= Criavar("ED_CODIGO")
Local aTitulos := {}

While .T.
   nOpca := 0
   DEFINE MSDIALOG oDlg FROM 10, 5 TO 26, 60 TITLE "Dados bancários para baixa"
   // BANCO
   @ 1.0,2  Say "Banco :         "
   @ 1.0,8   MSGET cBanco F3 "SA6"
   // AGENCIA
   @ 2.0,2  Say "Agência :       "
   @ 2.0,8  MSGET cAgencia
   // CONTA
   @ 3.0,2  Say "Conta :         "
   @ 3.0,8  MSGET cConta
   // NUMERO CHEQUE
   @ 4.0,2  Say "Núm Cheque :   "
   @ 4.0,8  MSGET cCheque    When (Substr(cBanco,1,2)!="CX" .And. !(cBanco $ GEtMV("MV_CARTEIR")))
   // NUMERO CHEQUE
   @ 5.0,2  Say "Natureza :   "
   @ 5.0,8  MSGET cNatureza F3 "SED"
  
   bAction := {|| oDlg:End() }
   DEFINE SBUTTON FROM 105,180.1 TYPE 1 ACTION ( Eval(bAction) ) ENABLE OF oDlg
   ACTIVATE MSDIALOG oDlg CENTERED
   Exit
EndDo
//Baixa Titulos a Pagar
dbSelectArea("SE2")
dbSetOrder(1)
//If MsSEEK(xFilial("SE2")+"BPA")
If MsSEEK(xFilial("SE2"))
   While SE2->(!Eof()) .and. SE2->(E2_FILIAL+E2_PREFIXO) == xFilial("SE2")+"BPA"
 
      //Adiciono o Array acima ao array de baixas
      If SE2->E2_SALDO > 0 .and. !(SE2->E2_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT)
         AADD(aTitulos , SE2->(Recno()))
      Endif
      dbSkip()
   Enddo
  
   //Efetuo Baixa
   If FBxLotAut("SE2",aTitulos,cBanco,cAgencia,cConta,cCheque,,cNatureza)
      ALERT ("Baixas Executadas")
   Else
      ALERT ("Baixas Não Foram Executadas")
   Endif 
 
Else
   Help(" ",1,"RECNO")
Endif
Return