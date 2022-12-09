#include 'TopConn.ch'
#include "RWMAKE.CH"     
#include 'protheus.ch'


User Function UPDFASE()
	
Local c_query       := ''   
Private d_dtupdfase := date()-2 

//excluido bloco abaixo pois nao tinha utilidade [Mauro Nagata, Actual Trend, 20180111]
/*
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Seleciona os orcamentos fase 03 que ira atualizar a fase para 04     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
c_query := " SELECT * FROM AF1010"
c_query += " where   AF1010.D_E_L_E_T_  =' ' AND AF1_XDTFAS <= '" + dtos(d_dtupdfase) + "'  and AF1_XDTFAS <>'' AND AF1_FASE='03' "
*/
//fim bloco [Mauro Nagata, Actual Trend, 20180111]
                 
// Apos fazer o select executa o update 	
c_query := "UPDATE AF1010 "
c_query += "SET		AF1_FASE = '04' "      
//incluida linha abaixo [Mauro Nagata, Actual Trend, 20180111]     defindo a data de follow up quando alterada a fase para 04 automaticamente, tratdao com a Sheila
c_query += "       ,AF1_XDTFOL = '" + Dtos(date()+3) + "' " 
c_query += "WHERE AF1_XDTFAS <=  '" + dtos(d_dtupdfase) + "' and AF1_XDTFAS <>'' AND AF1_FASE='03'"
c_query += "	AND  AF1010.D_E_L_E_T_ =' ' "

TcSqlExec(c_query)   
RETURN
                                      



