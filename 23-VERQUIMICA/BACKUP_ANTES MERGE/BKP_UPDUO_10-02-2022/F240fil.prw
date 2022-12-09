#include "rwmake.ch"                                                                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF240fil   บAutor  ณFelipe Pieroni        บ Data ณ  12/11/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para filtrar os titulos do contas a pagar บฑฑ
ฑฑบ          ณ conforme tipo de pagamento do bordero.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F240fil()

SetPrvt("_cFiltro,")

_cFiltro:=""

If cModPgto == "30"
   
   If cPort240 == "341"                                        
      _cFiltro := " SUBS(E2_CODBAR,1,3)=="+"'"+cPort240+"'"
   Else   
      _cFiltro := " !EMPTY(E2_CODBAR) "
   EndIf                                                                                                 
   
   _cFiltro += " .AND. SUBS(E2_CODBAR,1,1)<>'8' "
   
ElseIf cModPgto == "31"
   
   _cFiltro := " !EMPTY(E2_CODBAR)"
   
   If cPort240 == "341"                                         
      _cFiltro += " .AND. SUBS(E2_CODBAR,1,3)<>"+"'"+cPort240+"'"
   EndIf

   _cFiltro += " .AND. SUBS(E2_CODBAR,1,1)<>'8' "

ElseIf cModPgto == "01"
   _cFiltro := " Empty(E2_CODBAR)  .and. " 
   _cFiltro += "  GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  =="+" '"+cPort240+ "'" 

ElseIf cModPgto == "03" 
   _cFiltro := " Empty(E2_CODBAR) .and. "
   If cPort240 == "341"                                         
      _cFiltro += " E2_SALDO < 3000 .and. "   
   EndIf
   _cFiltro += " (  !Empty(GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1))  "
   _cFiltro += "  .and. GetAdvFval('SA2','A2_BANCO'  ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  <>"+"'"+cPort240+"'  )"

ElseIf cModPgto == "41" .or. cModPgto == "43"
   _cFiltro := " Empty(E2_CODBAR) .and. " 
   If cPort240 == "341"                                         
      _cFiltro += " E2_SALDO >= 3000 .and. "   // Verificar o valor limite para TED
   EndIf
   _cFiltro += " (  !Empty(GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1))  "
   _cFiltro += "  .and. GetAdvFval('SA2','A2_BANCO'  ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  <>"+"'"+cPort240+"'  )"
 
ElseIf cModPgto == "13"  //--- Concessionarias

   _cFiltro := " !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8' .AND. E2_TIPO <> 'ISS'"

ElseIf cModPgto == "16"  //--- Darf Normal - Selecionar com codigo de retencao e tipo TX              

   _cFiltro := " ( !Empty(E2_CODRET) .OR. !Empty(E2_CODREC) ) .AND. E2_TIPO == 'TX '"

ElseIf cModPgto == "17"  //--- GPS 

   _cFiltro := " E2_TIPO == 'INS'"

ElseIf cModPgto == "19"  //--- ISS  
  
   _cFiltro := " E2_TIPO == 'ISS' .OR. E2_TIPO == 'TX ' .AND. E2_NATUREZ == 'ISS       ' .AND. E2_ORIGEM == 'MATA460 ' .OR. 'PREF' $ E2_NOMFOR"

EndIf

Return(_cFiltro)        