#Include "Totvs.ch"

//------------------------------------------------------------------
// Rotina | CN100BUT 	| Autor | Renato Ruy 	  | Data | 18/02/14
//------------------------------------------------------------------
// Descr. | Ponto de Entrada para adicionar botão na manutenção
//        | da tela de contratos.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------

User Function CN100BUT()

Local aButtons := {} // Botoes a adicionar

aadd(aButtons,{'BUDGETY',{|| U_CSGCT001()},'Sol.Aprovação','Sol.Aprovac.'})
aadd(aButtons,{'BUDGETY',{|| U_CSCGT003()},'Rast.Contrato','Rast.Contrato'}) 
IF INCLUI
	aadd(aButtons,{'BUDGETY',{|| U_CSGCT040(2)},'Notificação eMails','Notificação eMails'})
EndIF 

Return (aButtons)