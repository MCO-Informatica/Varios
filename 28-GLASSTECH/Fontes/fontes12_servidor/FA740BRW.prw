
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? FA740BRW ?Autor  ? S?rgio Santana     ? Data ? 11/03/2017  ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Este ponto de entrada tem por finalidade inclir as rotinas ???
???          ? referente ao a emiss?o dos boletos ita? e pr?-nota.        ???
???          ?                                                            ???
???          ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Glasstech                                                  ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function FA740BRW()

LOCAL _aRotina := ParamIxb

aRotPre :=	{;
			 { 'Emiss?o Individual', "U_P_FIR009( 'I' )", 0 , 4},;
			 { 'Pr?-Nota'          , "U_P_FIR009( 'P' )", 0 , 4} ;
            }

_aRotina := {;
             { 'Boletos Ita?'    , aRotPre     , 0, 6 },;
             { 'Atualiza Cobr.'  , 'U_CTARCIMP', 0, 4 },;
             { 'Consulta &t?tulo', 'FINC040(2)', 0, 4 } ;
            }

Return( _aRotina )