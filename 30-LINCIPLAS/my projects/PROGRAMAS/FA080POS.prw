#include "rwmake.ch"
/*
============================================================================
|Funcao    | FA080POS           | Rodrigo Correa        |6Data | 30/01/08  |
============================================================================
|Descricao | Grava��o complementar - Baixa autom�tica pagar                |
|          |                                                               |
============================================================================
|Observa��es: Utilizado para grava��o de dados complementares da baixa a   |
|             pagar autom�tica. Executado ap�s a gava��o do SE5            |
============================================================================
*/
//ExecBlock: 	FA080POS
//Ponto:	Antes da digita��o dos dados do t�tulo a ser baixado.
//Observa��es: 	Permite alterar dados da baixa antes de serem exibidos ao usu�rio. 
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
