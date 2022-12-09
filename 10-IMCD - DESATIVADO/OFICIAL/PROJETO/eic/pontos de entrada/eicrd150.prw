User Function EICRD150()
Local cParam:= ""


IF Type("ParamIXB") == "C"
cParam:= PARAMIXB
Else
cParam:= PARAMIXB[1]
Endif

IF cParam == "STRU_WORK"
msginfo("Entrou no ponto de entrada 'STRU_WORK'")
//T_DBF := {"WKPO_NUM","C",15,0} Exemplo STRU_WORK
//aTitulos := {"Nr. P.O.","C","",""} 
ENDIF

IF cParam == "CRIAR_CAMPO"
msginfo("Entrou no ponto de entrada 'CRIAR_CAMPO'")
//AADD(TB_Campos,{"WKMOEDA" ,"", "Moeda"}) // Exemplo Criar_Campo
ENDIF

IF cParam == "DENTRO_JANELA"
msginfo("Entrou no ponto de entrada 'DENTRO_JANELA'")

EndIF

IF cParam == "GRAVA_CAMPO"
msginfo("Entrou no ponto de entrada 'GRAVA_CAMPO'")
//Work->WKMOEDA := SW2->W2_MOEDA //Exemplo GRAVA_CAMPO
EndIF

IF cParam == "IMPRIME"
msginfo("Entrou no ponto de entrada 'IMPRIME'")
//@ X,X+5 PSAY "Sub Total" //Exemplo IMPRIME
EndIF

IF cParam == "IMPRIME_TOTAL"
msginfo("Entrou no ponto de entrada 'IMPRIME_TOTAL'")
//@X,X PSAY Alltrim(TRANS(nVariavel , '@E 999,999,999.99')) //Exemplo IMPRIME_TOTAL
EndIF

IF cParam == "CABEC1"
msginfo("Entrou no ponto de entrada 'CABEC1'")
//@ X,X PSAY Teste //Exemplo CABEC1
EndIF


IF cParam == "CABEC2"
msginfo("Entrou no ponto de entrada 'CABEC2'")
//@ X,X PSAY Replicate("-",03) //"---" //Exemplo CABEC2
EndIF

IF cParam == "DETALHE"
msginfo("Entrou no ponto de entrada 'DETALHE'")
//@ X,X PSAY Teste->teste_campo //Exemplo DETALHE
EndIF

Return Nil

