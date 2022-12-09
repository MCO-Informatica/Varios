#INCLUDE "PROTHEUS.CH"
#INCLUDE "RwMake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ F460VER	³ Autor ³ Marcio Almenara 	    ³ Data ³ 13.12.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impress„o no verso do Cheque especial					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ponto de Entrada com retorno de Variavel com Conteudo	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico Thermoglass									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
