#include "Totvs.ch" 
#Define CRLF chr(13) + chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
4±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ MATG010 ³ Autor ³ Marcos Souza (MGS)   ³ Data ³ 09.12.2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Gatilho para tratamento de caracteres especiais quando da  ³±±
±±³          ³ digitação do código e/ou descrição do produto.             ³±±
±±³          ³ EXECUCAO: CADASTRO DO PRODUTO                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
__cNewCod		:= StrTran(__cNewCod,"¨","")
__cNewCod		:= StrTran(__cNewCod,"&","")
__cNewCod		:= StrTran(__cNewCod,"*","")
__cNewCod		:= StrTran(__cNewCod,"(","")
__cNewCod		:= StrTran(__cNewCod,")","")
__cNewCod		:= StrTran(__cNewCod,"+","")
__cNewCod		:= StrTran(__cNewCod,"=","")
__cNewCod		:= StrTran(__cNewCod,"ª","")
__cNewCod		:= StrTran(__cNewCod,"º","")
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
    cMsg := "Caracteres especiais e/ou espaços em branco não devem ser"+CRLF
    cMsg += "utilizados na composição do código do produto !"+CRLF
    apMsgAlert(cMsg,"Inconsistência")
    __cCod := (NIL)
//	RegToMemory("SB1",.T.)
	M->B1_COD := (NIL)
//	SysRefresh()
Endif    
Return __cCod

User Function MATG010A() // Validação campo B1_COD 
Local _lRet := .T.
__cCod := alltrim(M->B1_COD)
__cNewCod		:= FWNoAccent(__cCod)
__cNewCod		:= StrTran(__cNewCod," ","")
__cNewCod		:= StrTran(__cNewCod,"!","")
__cNewCod		:= StrTran(__cNewCod,"@","")
__cNewCod		:= StrTran(__cNewCod,"#","")
__cNewCod		:= StrTran(__cNewCod,"$","")
__cNewCod		:= StrTran(__cNewCod,"%","")
__cNewCod		:= StrTran(__cNewCod,"¨","")
__cNewCod		:= StrTran(__cNewCod,"&","")
__cNewCod		:= StrTran(__cNewCod,"*","")
__cNewCod		:= StrTran(__cNewCod,"(","")
__cNewCod		:= StrTran(__cNewCod,")","")
__cNewCod		:= StrTran(__cNewCod,"+","")
__cNewCod		:= StrTran(__cNewCod,"=","")
__cNewCod		:= StrTran(__cNewCod,"ª","")
__cNewCod		:= StrTran(__cNewCod,"º","")
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
__cNewDesc		:= StrTran(__cNewDesc,"¨","")
__cNewDesc		:= StrTran(__cNewDesc,"&","")
__cNewDesc		:= StrTran(__cNewDesc,"=","")
__cNewDesc		:= StrTran(__cNewDesc,"ª","")
__cNewDesc		:= StrTran(__cNewDesc,"º","")
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
    cMsg := "Caracteres especiais e/ou múltiplos espaços em branco"+CRLF
    cMsg += " não devem ser utilizados na descrição do produto !"+CRLF
    apMsgAlert(cMsg,"Inconsistência")
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
__cNewDesc		:= StrTran(__cNewDesc,"¨","")
__cNewDesc		:= StrTran(__cNewDesc,"&","")
__cNewDesc		:= StrTran(__cNewDesc,"=","")
__cNewDesc		:= StrTran(__cNewDesc,"ª","")
__cNewDesc		:= StrTran(__cNewDesc,"º","")
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
    cMsg := "Caracteres especiais e/ou múltiplos espaços em branco"+CRLF
    cMsg += " não devem ser utilizados na descrição do produto !"+CRLF
    apMsgAlert(cMsg,"Inconsistência")
  */
    __cDesc := __cNewDesc
	M->B1_DESC := __cNewDesc
    _lRet := .F.
Endif    
Return _lRet
