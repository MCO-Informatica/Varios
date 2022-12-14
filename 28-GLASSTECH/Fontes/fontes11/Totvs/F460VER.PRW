#INCLUDE "PROTHEUS.CH"
#INCLUDE "RwMake.CH"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o	 ? F460VER	? Autor ? Marcio Almenara 	    ? Data ? 13.12.12 ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ? Impress?o no verso do Cheque especial					  ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Sintaxe   ? Ponto de Entrada com retorno de Variavel com Conteudo	  ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? Uso		 ? Especifico Thermoglass									  ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/


User Function F460VER
 cSavAlia := Alias()
 cSavInd := IndexOrd()
 cVerso := ""
 
 Dbselectarea("SEF")
 xRECNO := Recno()
 xORDEM := IndexOrd()
 xDADOS:= SEF->EF_FILIAL+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+SEF->EF_NUM

 xLINHAS := 0  //CONTADOR DE LINHAS
 xLIMITE := 6  //LIMITE DE LINHAS A SEREM IMPRESSAS NO VERSO DO CHEQUE

 DbsetOrder(1)
 Dbseek(xFILIAL(xDADOS))

 While !eof() .and. xDADOS == SEF->EF_FILIAL+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+SEF->EF_NUM
    IF(SEF->EF_IMPRESS $ "SAC" .or. SubStr(SEF->EF_TIPO,1,2) = "TB") .AND. xLINHAS <= xLIMITE
       xLINHAS := xLINHAS + 1
       cVerso += SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+"-" + SEF->EF_BENEF + CHR(13)+CHR(10)+" "
    Endif
    Dbskip()
Enddo    

Set Device to Screen

DbsetOrder(xORDEM)
Dbgoto(xRECNO)

dbSelectArea(cSavAlia)
dbSetOrder(cSavInd)

Return(cVerso)
