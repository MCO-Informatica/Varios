#include "Totvs.ch" 
#Define CRLF chr(13) + chr(10)
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
4?????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ? MATG010 ? Autor ? Marcos Souza (MGS)   ? Data ? 09.12.2020 ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ? Gatilho para tratamento de caracteres especiais quando da  ???
???          ? digita??o do c?digo e/ou descri??o do produto.             ???
???          ? EXECUCAO: CADASTRO DO PRODUTO                              ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function MATG010() // Gatilho campo B1_COD
__cCod := alltrim(M->B1_COD)
__cNewCod		:= FWNoAccent(__cCod)
__cNewCod		:= StrTran(__cNewCod," ","")
__cNewCod		:= StrTran(__cNewCod,"!","")
__cNewCod		:= StrTran(__cNewCod,"@","")
__cNewCod		:= StrTran(__cNewCod,"#","")
__cNewCod		:= StrTran(__cNewCod,"$","")
__cNewCod		:= StrTran(__cNewCod,"%","")
__cNewCod		:= StrTran(__cNewCod,"?","")
__cNewCod		:= StrTran(__cNewCod,"&","")
__cNewCod		:= StrTran(__cNewCod,"*","")
__cNewCod		:= StrTran(__cNewCod,"(","")
__cNewCod		:= StrTran(__cNewCod,")","")
__cNewCod		:= StrTran(__cNewCod,"+","")
__cNewCod		:= StrTran(__cNewCod,"=","")
__cNewCod		:= StrTran(__cNewCod,"?","")
__cNewCod		:= StrTran(__cNewCod,"?","")
__cNewCod		:= StrTran(__cNewCod,"[","")
__cNewCod		:= StrTran(__cNewCod,"]","")
__cNewCod		:= StrTran(__cNewCod,"{","")
__cNewCod		:= StrTran(__cNewCod,"}","")
__cNewCod		:= StrTran(__cNewCod,",","")
__cNewCod		:= StrTran(__cNewCod,"<","")
__cNewCod		:= StrTran(__cNewCod,">","")
__cNewCod		:= StrTran(__cNewCod,";","")
__cNewCod		:= StrTran(__cNewCod,":","")
__cNewCod		:= StrTran(__cNewCod,"/","")
__cNewCod		:= StrTran(__cNewCod,"?","")
__cNewCod		:= StrTran(__cNewCod,"|","")
__cNewCod		:= StrTran(__cNewCod,"\","")
EECVIEW(__cCod+"|"+__cNewCod,"MATG010")
If .not. __cCod == __cNewCod 
    cMsg := "Caracteres especiais e/ou espa?os em branco n?o devem ser"+CRLF
    cMsg += "utilizados na composi??o do c?digo do produto !"+CRLF
    apMsgAlert(cMsg,"Inconsist?ncia")
    __cCod := (NIL)
//	RegToMemory("SB1",.T.)
	M->B1_COD := (NIL)
//	SysRefresh()
Endif    
Return __cCod

User Function MATG010A() // Valida??o campo B1_COD 
Local _lRet := .T.
__cCod := alltrim(M->B1_COD)
__cNewCod		:= FWNoAccent(__cCod)
__cNewCod		:= StrTran(__cNewCod," ","")
__cNewCod		:= StrTran(__cNewCod,"!","")
__cNewCod		:= StrTran(__cNewCod,"@","")
__cNewCod		:= StrTran(__cNewCod,"#","")
__cNewCod		:= StrTran(__cNewCod,"$","")
__cNewCod		:= StrTran(__cNewCod,"%","")
__cNewCod		:= StrTran(__cNewCod,"?","")
__cNewCod		:= StrTran(__cNewCod,"&","")
__cNewCod		:= StrTran(__cNewCod,"*","")
__cNewCod		:= StrTran(__cNewCod,"(","")
__cNewCod		:= StrTran(__cNewCod,")","")
__cNewCod		:= StrTran(__cNewCod,"+","")
__cNewCod		:= StrTran(__cNewCod,"=","")
__cNewCod		:= StrTran(__cNewCod,"?","")
__cNewCod		:= StrTran(__cNewCod,"?","")
__cNewCod		:= StrTran(__cNewCod,"[","")
__cNewCod		:= StrTran(__cNewCod,"]","")
__cNewCod		:= StrTran(__cNewCod,"{","")
__cNewCod		:= StrTran(__cNewCod,"}","")
__cNewCod		:= StrTran(__cNewCod,",","")
__cNewCod		:= StrTran(__cNewCod,"<","")
__cNewCod		:= StrTran(__cNewCod,">","")
__cNewCod		:= StrTran(__cNewCod,";","")
__cNewCod		:= StrTran(__cNewCod,":","")
__cNewCod		:= StrTran(__cNewCod,"/","")
__cNewCod		:= StrTran(__cNewCod,"?","")
__cNewCod		:= StrTran(__cNewCod,"|","")
__cNewCod		:= StrTran(__cNewCod,"\","")
If .not. __cCod == __cNewCod 
    M->B1_COD := (NIL)
    _lRet := .F.
Endif    
Return _lRet

User Function MATG010B()  // Gatilho campo B1_DESC
__cDesc := alltrim(M->B1_DESC)
__cNewDesc		:= FWNoAccent(__cDesc)
__cNewDesc		:= StrTran(__cNewDesc,"          "," ")
__cNewDesc		:= StrTran(__cNewDesc,"         "," ")
__cNewDesc		:= StrTran(__cNewDesc,"        "," ")
__cNewDesc		:= StrTran(__cNewDesc,"       "," ")
__cNewDesc		:= StrTran(__cNewDesc,"      "," ")
__cNewDesc		:= StrTran(__cNewDesc,"     "," ")
__cNewDesc		:= StrTran(__cNewDesc,"    "," ")
__cNewDesc		:= StrTran(__cNewDesc,"   "," ")
__cNewDesc		:= StrTran(__cNewDesc,"  "," ")
__cNewDesc		:= StrTran(__cNewDesc,"!","")
__cNewDesc		:= StrTran(__cNewDesc,"@","")
__cNewDesc		:= StrTran(__cNewDesc,"#","")
__cNewDesc		:= StrTran(__cNewDesc,"$","")
__cNewDesc		:= StrTran(__cNewDesc,"%","")
__cNewDesc		:= StrTran(__cNewDesc,"?","")
__cNewDesc		:= StrTran(__cNewDesc,"&","")
__cNewDesc		:= StrTran(__cNewDesc,"=","")
__cNewDesc		:= StrTran(__cNewDesc,"?","")
__cNewDesc		:= StrTran(__cNewDesc,"?","")
__cNewDesc		:= StrTran(__cNewDesc,"[","")
__cNewDesc		:= StrTran(__cNewDesc,"]","")
__cNewDesc		:= StrTran(__cNewDesc,"{","")
__cNewDesc		:= StrTran(__cNewDesc,"}","")
__cNewDesc		:= StrTran(__cNewDesc,"<","")
__cNewDesc		:= StrTran(__cNewDesc,">","")
__cNewDesc		:= StrTran(__cNewDesc,";","")
__cNewDesc		:= StrTran(__cNewDesc,":","")
__cNewDesc		:= StrTran(__cNewDesc,"?","")
__cNewDesc		:= StrTran(__cNewDesc,"|","")
__cNewDesc		:= StrTran(__cNewDesc,"\","")
EECVIEW(__cDesc+"|"+__cNewDesc,"MATG010")
If .not. __cDesc == __cNewDesc 
    cMsg := "Caracteres especiais e/ou m?ltiplos espa?os em branco"+CRLF
    cMsg += " n?o devem ser utilizados na descri??o do produto !"+CRLF
    apMsgAlert(cMsg,"Inconsist?ncia")
    __cDesc := __cNewDesc
	M->B1_DESC := __cNewDesc
Endif    
Return __cDesc

User Function MATG010C()  // Gatilho campo B1_DESC
Local _lRet := .T.
Local __cDesc := alltrim(M->B1_DESC)
__cNewDesc		:= FWNoAccent(__cDesc)
__cNewDesc		:= StrTran(__cNewDesc,"          "," ")
__cNewDesc		:= StrTran(__cNewDesc,"         "," ")
__cNewDesc		:= StrTran(__cNewDesc,"        "," ")
__cNewDesc		:= StrTran(__cNewDesc,"       "," ")
__cNewDesc		:= StrTran(__cNewDesc,"      "," ")
__cNewDesc		:= StrTran(__cNewDesc,"     "," ")
__cNewDesc		:= StrTran(__cNewDesc,"    "," ")
__cNewDesc		:= StrTran(__cNewDesc,"   "," ")
__cNewDesc		:= StrTran(__cNewDesc,"  "," ")
__cNewDesc		:= StrTran(__cNewDesc,"!","")
__cNewDesc		:= StrTran(__cNewDesc,"@","")
__cNewDesc		:= StrTran(__cNewDesc,"#","")
__cNewDesc		:= StrTran(__cNewDesc,"$","")
__cNewDesc		:= StrTran(__cNewDesc,"%","")
__cNewDesc		:= StrTran(__cNewDesc,"?","")
__cNewDesc		:= StrTran(__cNewDesc,"&","")
__cNewDesc		:= StrTran(__cNewDesc,"=","")
__cNewDesc		:= StrTran(__cNewDesc,"?","")
__cNewDesc		:= StrTran(__cNewDesc,"?","")
__cNewDesc		:= StrTran(__cNewDesc,"[","")
__cNewDesc		:= StrTran(__cNewDesc,"]","")
__cNewDesc		:= StrTran(__cNewDesc,"{","")
__cNewDesc		:= StrTran(__cNewDesc,"}","")
__cNewDesc		:= StrTran(__cNewDesc,"<","")
__cNewDesc		:= StrTran(__cNewDesc,">","")
__cNewDesc		:= StrTran(__cNewDesc,";","")
__cNewDesc		:= StrTran(__cNewDesc,":","")
__cNewDesc		:= StrTran(__cNewDesc,"?","")
__cNewDesc		:= StrTran(__cNewDesc,"|","")
__cNewDesc		:= StrTran(__cNewDesc,"\","")
//EECVIEW(__cDesc+"|"+__cNewDesc,"MATG010")
If .not. __cDesc == __cNewDesc 
  /*
    cMsg := "Caracteres especiais e/ou m?ltiplos espa?os em branco"+CRLF
    cMsg += " n?o devem ser utilizados na descri??o do produto !"+CRLF
    apMsgAlert(cMsg,"Inconsist?ncia")
  */
    __cDesc := __cNewDesc
	M->B1_DESC := __cNewDesc
    _lRet := .F.
Endif    
Return _lRet
