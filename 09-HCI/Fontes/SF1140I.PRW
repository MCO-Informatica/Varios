#include "RWMAKE.CH"
/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ? SF1140I  ? Autor ? Fabrica de Software   ? Data ? 05/11/07 ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ? Ponto de Entrada para realizar a impressao das etiquetas de???
???          ? identificacao dos produtos na HCI.						  ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? Uso      ? Especifico cliente HCI			                          ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? Retorno  ? Array						                              ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? PROGRAMADOR  ? DATA   ? BOPS ?  MOTIVO DA ALTERACAO                   ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???              ?        ?      ?                                        ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
User Function SF1140I()
	U_ACDHCI02()  //Executa a rotina de impressao de etiquetas de produtos
Return