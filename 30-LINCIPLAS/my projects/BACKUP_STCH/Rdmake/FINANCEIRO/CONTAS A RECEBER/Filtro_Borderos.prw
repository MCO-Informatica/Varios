#Include "Rwmake.ch"

                                                                                  
/*
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿛onto de entrada criado para trazer somente os titulos de ?
//쿬lientes cujo cadastro esta com o campo                   ?
//?"A1_BORDERO"= 1 (SIM).                                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/
User Function FA060QRY()

cRet:= ""

cRet:= " E1_CLIENTE in ( Select A1_COD from SA1010 WHERE A1_BORDERO = '1' AND A1_LOJA = E1_LOJA)" 

Return cRet