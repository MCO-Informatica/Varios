#include "rwmake.ch"
/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矻INCICUS06? Autor ? Rodrigo Correa     ? Data ?  25/06/07   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋escri噭o ? ESTE PROGRAMA RETORNA CALCULO DO VALOR PARA CALCULO   SZ6  罕?
北?          ? PLANILHA DE CUSTO                                          罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? LINCIPLAS                                                  罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Declaracao de Variaveis                                             ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
USER FUNCTION LICUS06()
aArea		:= GetArea()

		_nICMS        := M->Z6_ICMS   
		_nIPI         := M->Z6_IPI      
		_nPRECOSI     := M->Z6_PRECOSI 
		_nPRECOPC     := 0
		_nPRECO       := 0
		
		_nPRECOPC := M->Z6_PRECOSI - (_nPRECOSI*(M->Z6_ICMS + 9.25) / 100) + M->Z6_FRETE
RestArea(aArea)
Return(_nPRECOPC)


