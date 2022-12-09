#INCLUDE 'TOTVS.CH' 
#Include "rwmake.ch"
#Include 'FWMVCDef.ch'

user function RQG0001()

LOcal  oSay
Local  oButton1
Local  oButton2
Local  lCancelado := .T.
Local  oValor
Local  nValor := 0
Static oDlg

Define Font o_Fn10 Name "Verdana" Size 0,10
Define Font o_Fn11 Name "Verdana" Size 0,11
Define Font o_Fn12 Name "Verdana" Size 0,12
Define Font o_Fn13 Name "Verdana" Size 0,13
Define Font o_Fn14 Name "Verdana" Size 0,14
Define Font o_Fb14 Name "Verdana" Size 0,14 Bold

if E2_PREFIXO <> "PRJ" 
   Alert("Tipo de título inválido para alteração")
   return()
endif

if E2_SALDO = 0
   Alert("Título sem saldo - não pode ser alterado!")
   return()
endif

DEFINE MSDIALOG oDlg TITLE "Atualização do IRRF" FROM 000, 000  TO 200, 300 COLORS 0, 16777200 PIXEL

   @ 005, 011 Say oSay Prompt "Título: "+E2_PREFIXO+"-"+E2_NUM+"-"+E2_PARCELA+" / "+E2_TIPO Size 200,010 Of oDlg Pixel Color CLR_BLACK  
   @ 020, 009 SAY oSay PROMPT "Digite o valor do IRRF a somar" SIZE 200, 010 OF oDlg COLORS 0, 16777215 PIXEL    
   @ 035, 047 MsGet oValor Var nValor Size 050,005 Of oDlg Pixel Color CLR_BLACK Picture "@E 999,999,999.99"

   oButton1:= TButton():New(080,020, "OK",     oDlg,{||lCancelado:=.F.,oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
   oButton2:= TButton():New(080,090, "Cancela",oDlg,{||lCancelado:=.T.,oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlg CENTERED

if nValor = 0 .or. lCancelado
   alert("Cancelado - Não houve alteração")
   return()
endif

if nValor >0 .and. "INCREM" $ E2_HIST
   Alert("Atenção, título já incrementado - para alterar o valor, primeiro estorne o valor incrementeado anteriormente!")
   return()
endif

if nValor < 0 .and. !"INCREM" $ E2_HIST   
   Alert("Atenção, título inválido para estornar - Não há incremento")
   return()
endif

Reclock("SE2",.F.)
E2_VALOR   := E2_VALOR + nValor
E2_SALDO   := E2_VALOR
E2_VLCRUZ  := E2_VALOR
E2_BASEIRF := E2_VALOR
E2_NATUREZ := "2182"
if nValor > 0
   E2_HIST := "2 INCREMENTADO IRF ORIGEM "+AllTrim(str(nValor,9,2))
else
   E2_HIST := ""
endif
MSUnlock()

Alert("Valores atualizados - conferir")

Return()


