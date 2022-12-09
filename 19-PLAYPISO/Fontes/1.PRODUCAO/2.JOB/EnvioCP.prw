Local c_query := '' 

 c_query += "SET 		SZ2010.Z2_DTFIM  = '"+Dtos(dDt)+ "', SZ2010.Z2_HRFIM = '"+time()+"'  "
// c_query += "WHERE  SZ2010.Z2_DTINI = '"+Dtos(dDatabase)+"' "

 c_query += "WHERE  SZ2010.Z2_DTINI <= '"+Dtos(dDt)+"' "
 c_query += "AND SZ2010.Z2_DTFIM = ' ' "
 c_query += "AND SZ2010.D_E_L_E_T_ =' ' "					
 TcSqlExec(c_query) 
 TCUnlink(nhWnd)      

return