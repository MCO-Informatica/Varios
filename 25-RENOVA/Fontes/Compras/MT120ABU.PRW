#INCLUDE "Protheus.CH"
/*/
	Funcao:		MT120ABU
	Data:		16/07/2015
	Autor:		Jesus
	Descricao:	Ponto de Entrada executado no progama MATA120.
				- Implementação do Ponto de Entrada MT120ALT que srá utilizado para verificar se o aRotina
				  Nao Permite adiantamento	
*/
 
User Function MT120ABU()
	Local aButons := {}
	Local nX := 0        
//AVISO("passei aqui",{"OK"})
//	ParamIxb[1][6][4]:=""
      
//   aButons:=	ParamIxb[1]
	For nX:=1 to Len( ParamIxb[1] )
		If Upper(ParamIxb[1][nX][1]) <> 'FINIMG32'
			AADD( aButons, aClone(ParamIxb[1][nX]) )		
		EndIF	
	Next nX                 

Return( aButons )