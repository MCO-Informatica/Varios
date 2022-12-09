//Chama o u_retPrefixo(SE1->E1_NUM) no lugar do seu posicione:

//u_retPrefixo(SE1->E1_NUM)
#include 'TopConn.ch'



user function retliq(cDocument)
      
      local cAlias:= getNextAlias()
      local cRet  := ""
      local cQuery:= ""
            
      cQuery := " SELECT E5_PREFIXO "+CRLF
      cQuery += " FROM "+retSqlTab("SE5")+CRLF
      cQuery += " WHERE SE5.D_E_L_E_T_ = ' ' "+CRLF
      cQuery += "       AND E5_FILIAL = '"+xFilial("SE5")+"'"+CRLF
      cQuery += "       AND E5_DOCUMENT = '"+cDocument+"'"+CRLF
            
      TCQUERY cQuery NEW Alias &cAlias
      
      (cAlias)->(dbGoTop())
            
      if !(cAlias)->(eof())
            
            cRet  := (cAlias)->E5_PREFIXO
            
            (cAlias)->(dbSkip())
      endIf
      
      (cAlias)->(DbCloseArea())          
      
return cRet

