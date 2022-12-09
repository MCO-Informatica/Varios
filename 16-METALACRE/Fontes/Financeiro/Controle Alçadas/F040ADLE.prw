#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออหออออออออออหอออออออหออออออออออออออออออออหออออออหอออออออออออปฑฑ
ฑฑบ Programa บ F040ADLE บ Autor บ Luiz Alberto       บ Data บ  MAR/17   บฑฑ
ฑฑฬออออออออออฮออออออออออสอออออออสออออออออออออออออออออสออออออสอออออออออออนฑฑ
ฑฑบ Funcao   บ Legenda Contas a Pagar     บฑฑ
ฑฑฬออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso      บ Personalizacao Metalacre                                    บฑฑ
ฑฑศออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F040ADLE
Local aRet := {}     
Local cAli := If(AllTrim(Upper(FunName()))$("FINA740/FINA040"),"SE1","SE2")

If cAli == "SE2"
     aAdd(aRet,{"BR_VIOLETA","Tํtulo Aguard. Libera็ใo (Al็ada)"})
     aAdd(aRet,{"BR_LARANJA","Tํtulo Liberado (Al็ada)"})
     aAdd(aRet,{"BR_PRETO","Tํtulo Rejeitado (Al็ada)"})
Endif

Return aRet

/*
If FunName() $ "FINA050,FINA750"
     aAdd(aRet,{"BR_VIOLETA","Tํtulo Aguard. Libera็ใo (Al็ada)"})
     aAdd(aRet,{"BR_LARANJA","Tํtulo Liberado (Al็ada)"})
     aAdd(aRet,{"BR_PRETO","Tํtulo Rejeitado (Al็ada)"})
EndIf
*/
//If FunName() $ "FINA040,FINA740"
//     aAdd(aRet,{"BR_LARANJA","Tํtulo Bloqueado"})
//EndIf
//Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออหออออออออออหอออออออหออออออออออออออออออออหออออออหอออออออออออปฑฑ
ฑฑบ Programa บ F040URET บ Autor บ Luiz Alberto       บ Data บ  MAR/17   บฑฑ
ฑฑฬออออออออออฮออออออออออสอออออออสออออออออออออออออออออสออออออสอออออออออออนฑฑ
ฑฑบ Funcao   บ Controle de Legendas Contas a Pagar      บฑฑ
ฑฑฬออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso      บ Personalizacao Metalacre                                    บฑฑ
ฑฑศออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F040URET
Local aRet := {}
Local cAli := If(AllTrim(Upper(FunName()))$("FINA740/FINA040"),"SE1","SE2")

If cAli=="SE2"
     aAdd(aRet,{"(E2_XCONAP) <> 'L' .AND. E2_ORIGEM='FINA050' ","BR_VIOLETA"})
     aAdd(aRet,{"(E2_XCONAP) == 'L' .AND. E2_ORIGEM='FINA050' ","BR_LARANJA"})
     aAdd(aRet,{"(E2_XCONAP) == 'R' .AND. E2_ORIGEM='FINA050' ","BR_PRETO"})  
Endif

/*If FunName() $ "FINA050,FINA750"
     aAdd(aRet,{"(E2_XCONAP) <> 'L' .AND. E2_ORIGEM='FINA050' ","BR_VIOLETA"})
     aAdd(aRet,{"(E2_XCONAP) == 'L' .AND. E2_ORIGEM='FINA050' ","BR_LARANJA"})
     aAdd(aRet,{"(E2_XCONAP) == 'R' .AND. E2_ORIGEM='FINA050' ","BR_PRETO"})  
EndIf
*/
//If FunName() $ "FINA040,FINA740"
//     aAdd(aRet,{"(E1_MSBLQL) == '1'","BR_LARANJA"})
//EndIf
Return aRet