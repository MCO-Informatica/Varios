#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Programa  ? MA650VLD ? Autor ? Jefferson Marques     ? Data ?29/04/2004???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Descricao ? Valida Somatoria de Pecas com Quantidade da OP             ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Uso       ? Kenia Industrias Texteis Ltda                              ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???   Analista   ?  Data  ?             Motivo da Alteracao               ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???              ?        ?                                               ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function MTA650OK()

Local _aArea	:=	GetArea()
Local _lRet		:=	.f.

ALERT("MTA650OK")


//----> RESTAURA AREA ANTERIOR
RestArea(_aArea)

Return(_lRet)

