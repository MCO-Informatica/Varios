#Include "Totvs.ch"            

//------------------------------------------------------------------
// Rotina | CN200BUT 	| Autor | Renato Ruy 	  | Data | 25/10/13
//------------------------------------------------------------------
// Descr. | Ponto de Entrada para adicionar botão na manutenção
//        | da tela de planilha.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------

User Function CN200BUT()

Local aButtons := {} 

// Strings para dar origem a um botao

aadd(aButtons,{"CARRCOL",{|| U_CN200Param()},"Gera Estrut. GAR"  ,"Busca GAR"   }) 
aadd(aButtons,{"CARRCOL",{|| U_CN200Oport()},"Gera Através Opor.","Busca Oport."}) 

Return {aButtons}
   