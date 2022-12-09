#include "protheus.ch" 

//criada função para tratar o limite de dias para data da proposta em no maximo 30 dias !
// LH actual trend 15/08/16
User Function DATAPROP()     

Local _lRet 	 :='' //Empty(AF1_XDTPRP)  
Local ret   	 :=''
Private d_dtProp := M->AF1_XDTPRP //data da proposta
Private d_dtOrca := M->AF1_DATA      //data do orcamento
Private d_dtRet  := M->AF1_XDTRET 	//data de retorno      
Private d_dtFase := M->AF1_XDTFAS // data da fase 03

//se a data da proposta estiver vazia .... data de retorno recebe data base
if EMPTY(d_dtProp)
   M->AF1_XDTRET := dDataBase + 2 // incluido variavel para tratar o campo de data de retorno LH ACTUAL 04/01/2017   
endif 
   
 //comentado bloco abaixo ...pois quando o usuario alterar orçamento data de retorno continua a mesma LH 15/03/17             
 // if !EMPTY(d_dtProp)  // se dt proposta estiver no prazo de 30 dias dt retorno recebe data da proposta + 2 dias      	
 //  M->AF1_XDTRET:=d_dtProp+2 // incluido variavel para tratar o campo de data de retorno LH ACTUAL 04/01/2017   
//   endif                                              		
 
if d_dtProp > dDataBase + 31    // se a data da proposta for maior que a database+31 dias ... data da proposta ira receber a data atual do sistema 
    d_dtProp      := dDataBase 
    M->AF1_XDTPRP := d_dtProp
    M->AF1_XDTRET := d_dtProp + 2 // incluido variavel para tratar o campo de data de retorno LH ACTUAL 04/01/2017
    if d_dtProp > dDataBase + 31  
		MsgAlert('A data da Proposta esta superior a 30 dias, Por favor verifique !!', "A T E N Ç Ã O") 
	endif   
endif 
	
// criada expressao abaixo para tratar a data em que a fase do orçamento passa para 03
if EMPTY(d_dtFase) .and. M->AF1_FASE = '03'
	M->AF1_XDTFAS := dDataBase
endif  
    
Return _lRet      
