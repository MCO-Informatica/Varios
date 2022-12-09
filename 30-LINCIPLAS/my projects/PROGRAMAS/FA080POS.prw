#include "rwmake.ch"
/*
============================================================================
|Funcao    | FA080POS           | Rodrigo Correa        |6Data | 30/01/08  |
============================================================================
|Descricao | Gravação complementar - Baixa automática pagar                |
|          |                                                               |
============================================================================
|Observações: Utilizado para gravação de dados complementares da baixa a   |
|             pagar automática. Executado após a gavação do SE5            |
============================================================================
*/
//ExecBlock: 	FA080POS
//Ponto:	Antes da digitação dos dados do título a ser baixado.
//Observações: 	Permite alterar dados da baixa antes de serem exibidos ao usuário. 
//Retorno Esperado:      Nenhum.	
 
User Function Fa080pos() 
_aArea := GetArea()

SetPrvt("CHIST070,DBAIXA,")

   if !EMPTY(SE2->E2_HIST)
      cHIST070:=SE2->E2_HIST
   else
      cHIST070:=SUBSTR(SE2->E2_HIST,1,40)
   ENDIF    
   RestArea(_aArea)
Return()
