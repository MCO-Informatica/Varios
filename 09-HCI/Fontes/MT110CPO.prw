/*                    
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ? MT110CPO ? Autor ? INIBE EXCLUSAO DA SC   ? Data ? 01.03.16 ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ? inclui campos para edicao na sc                             ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???Uso       ? MATA110                                                     ???
??????????????????????????????????????????????????????????????????????????Ĵ??
??? ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ???
??????????????????????????????????????????????????????????????????????????Ĵ??
??? PROGRAMADOR  ? DATA   ? BOPS ?  MOTIVO DA ALTERACAO                    ???
??????????????????????????????????????????????????????????????????????????Ĵ??
???XXXXXXXXXXXXXX?XX/XX/XX?XXXXXX?                                         ???
???????????????????????????????????????????????????????????????????????????ٱ?
??????????????????????????????????????????????????????????????????????????????
??????????????????????????????????????????????????????????????????????????????
*/
User Function MT110CPO()

Local aNewCpos :=  PARAMIXB[1]  //Array contendo os campos da tabela SC1 (Default) 

aAdd(aNewCpos,{ 'C1_VUNIT'})  //-- Adiciona os campos do usuario

Return (aNewCpos) 
