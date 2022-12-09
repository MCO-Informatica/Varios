#include 'TopConn.ch'
#include "RWMAKE.CH"     
#include 'protheus.ch'



User Function UPDVERSAO()
	
Local c_query := '' 
//Local nhWnd := TCLink("MSSQL/DADOSP11", "192.168.0.203", 7890) 
//subsituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20180712]
//Local nhWnd := TCLink("MSSQL/DADOSP12", "192.168.0.203", 7890)
//Local dDt := dDatabase
//subsituida linha acima pela abaixo [Thiago Miguel, Actual Trend, 20180718]
Local nhWnd := TCLink("MSSQL/DADOSP12", "192.168.0.203", 7892)
Local dDt := Date()
 
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� update nas versoes abertas , apos expediente versoes sao fechadas    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

 c_query := "UPDATE SZ2010   "
 c_query += "SET 		SZ2010.Z2_DTFIM  = '"+Dtos(dDt)+ "', SZ2010.Z2_HRFIM = '"+time()+"'  "
// c_query += "WHERE  SZ2010.Z2_DTINI = '"+Dtos(dDatabase)+"' "
//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20171018]
 c_query += "WHERE  SZ2010.Z2_DTINI <= '"+Dtos(dDt)+"' "
 c_query += "AND SZ2010.Z2_DTFIM = ' ' "
 c_query += "AND SZ2010.D_E_L_E_T_ =' ' "					
 TcSqlExec(c_query) 
 TCUnlink(nhWnd)      

return
