#INCLUDE "rwmake.ch"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?RFINE004  ? Autor ? Leandro Schumann   ? Data ?  16/06/16   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Gera o c?digo sequ?ncial do Lote para o segmento "J"       ???
???          ? liquida??o de T?tulos em cobran?a SISPAG - CNAB  MV_LOTESJ ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Espec?fico Prozyn                                          ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function RFINE004()
_cNum   := ""  
_cOld   := ""


dbSelectArea("SX6")
dBSetOrder(1)
If dBSeek(xfilial("SX6") +"MV_LOTESJ")   

	    _cNum:= alltrim(SX6->X6_CONTEUD)     //resultado do par?metro
	    _cOld:= _cNum
 		_cNum:= SOMA1(_cNum)                                                         
		_cNum:= SUBSTR(_cNum,1,4)  
		
		Reclock("SX6",.F.)                                                        
		SX6->X6_CONTEUD := _cNum
	    msUnLock() 
      
Endif

 Return(_cOld) 