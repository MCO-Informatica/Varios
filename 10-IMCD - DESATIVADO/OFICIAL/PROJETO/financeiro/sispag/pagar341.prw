#include "Protheus.ch"
/*
+-----------------------------------------------------------------------------+
|Programa  : PAGAR341                                                         |
|Descrição : Função única para o Sispag ITAU                                  |
+-----------------------------------------------------------------------------+
|Autor     : TI2228 - Marciane Gennari Rosa                                   | 
|Observacao:                  04/11/2010                                                |
|                                                                             |
+-------------------------------------------------+--------+------------------+
|Alterado                                         |Em      | Por              |
|                                                 |DD/MM/AA|                  |                                                                                                                             |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
+-----------------------------------------------------------------------------+

FORNECEDORES
+----------------------+----------+
| Nome Campo           | Parametro|                                            
+----------------------+----------+
| CODIGO AGENCIA       |   PP001  |                     
| VALOR PAGTO          |   PP002  |                     
| VALOR DESCONTO       |   PP003  |                   
| VALOR ACRESCIMO      |   PP004  |                   
| DV CODIGO DE BARRAS  |   PP005  |                     
| FATOR VENCTO E VALOR |   PP006  |                     
| CAMPO LIVRE (CODBAR) |   PP007  |                     
+----------------------+----------+


TRIBUTOS
+----------------------+----------+
| Nome Campo           | Parametro|                                            
+----------------------+----------+
| TIPO DO IMPOSTO  |   PT000  |                     
| DADOS DARF / GPS   / DARF SIMPLES / FGTS / IPVA / DPVAT  |   PT001  |                     
+----------------------+----------+

*/

User Function Pagar341(_cOpcao)   

Local  _cTipo     := ""
Local  _cRetorno  := ""
Local  _cConta     := ""
Local  _TtAbat    := 0.00
Local  _Liqui     := 0.00




_cTipo    := Alltrim(Upper(_cOpcao))

Do Case
	
    Case _cTipo == "PP001"	//  Agencia e Conta Corrente Favorecido


       _cConta := strzero(val(sa2->a2_numcon),10,0)

     If sa2->a2_banco == "341"
          _cRetorno := "0"+strzero(val(substr(sa2->a2_agencia,1,4)),4)+" "+"0000000"
          _cRetorno += strzero(val(substr(_cConta,6,5)),5)+" "+substr(sa2->a2_xdigcta,1,1)                               
       Else
          _cRetorno := strzero(val(substr(sa2->a2_agencia,1,5)),5)+" "
          _cRetorno += strzero(val(substr(_cConta,1,12)),12)
           If len(alltrim(sa2->a2_xdigcta)) > 1
            _cRetorno += strzero(val(substr(sa2->a2_xdigcta,1,2)),2)
            Else
             _cRetorno += " "+substr(sa2->a2_xdigcta,1,1)
           EndIf                                     
     EndIf
                                              
        
         //--- Mensagem ALERTA
         If Empty(SA2->A2_AGENCIA) .or. Empty(_cConta)                             
     
            MsgAlert('Fornecedor '+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+' sem banco/agência/conta corrente no titulo '+SE2->E2_PREFIXO+'-'+SE2->E2_NUM+'-'+SE2->E2_PARCELA+'. Atualize os dados no titulo e execute esta rotina novamente.')
 
         EndIf                  
  
         //--- Mensagem ALERTA
         If Empty(SA2->A2_CGC)
     
            MsgAlert('Fornecedor '+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+' sem CNPJ no cadastro. Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')

         EndIf          

                 
    Case _cTipo == "PP002"	//  Valor Pagamento                    
   
         _TtAbat := 0.00
         
         //--- Funcao SOMAABAT totaliza todos os titulos com e2_tipo AB- relacionado ao
         //---        titulo do parametro 
         _TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
         _TtAbat   += SE2->E2_DECRESC                       
         _Liqui    := (SE2->E2_SALDO-_TtAbat+SE2->E2_ACRESC)
         
         _cRetorno :=    StrZero(_Liqui*100,15)


        
    Case _cTipo == "PP003"	//  Valor Abatimento/Desconto          
   
         _TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
         _TtAbat   += SE2->E2_DECRESC                          
         
         _cRetorno := StrZero(_TtAbat*100,15)

     

    Case _cTipo == "PP008"	//  Tipo de Conta para DOC (Conta Poupança)
         _cRetorno := ""

         If SEA->EA_MODELO=="03"
	         _cRetorno := "01" 
		 EndIf        
                              
		 
	Case _cTipo == "PT000"
		 
         _cRetorno := ""                       
         
         //  Dados DARF  
         If SEA->EA_MODELO == "16"            // Posicao 018 a 019: Identificacao do Tributo 02-Darf 03-Darf Simples
             _cRetorno := "02"                         
         ElseIf (SEA->EA_MODELO == "17")    // Posicao 018 a 019: Identificacao do Tributo 01-GPS                    
            _cRetorno := "01"                                                       
         ElseIf  SEA->EA_MODELO == "18"     // Posicao 018 a 019: Identificacao do Tributo  03-Darf Simples
            _cRetorno := "03"                          
         ElseIf SEA->EA_MODELO == "22"     // Posicao 018 a 019: Identificacao do Tributo  05-ICMS
            _cRetorno := "05"                          
         ElseIf SEA->EA_MODELO == "35"    // Posicao 018 a 019: Identificacao do Tributo  11-FGTS-GFIP //sem cod bar
            _cRetorno := "11"                          
         ElseIf SEA->EA_MODELO == "25"  .or. SEA->EA_MODELO == "26" .or. SEA->EA_MODELO == "27"  //--- Posicao 018 a 019: Identificacao do Tributo  07-IPVA e 08-DPVAT
              _cRetorno := If(SEA->EA_MODELO=="25","07","08")  
         EndIf     


    Case _cTipo == "PT001"	                           
 
         _cRetorno := ""                       
         
         //  Dados DARF  
         If SEA->EA_MODELO == "16"    
   
            // Posicao 018 a 019: Identificacao do Tributo 02-Darf 03-Darf Simples
            // _cRetorno := "02"                         

            // Posicao 020 a 023: Codigo da Receita                                 
              _cRetorno += STRZERO(Val(SE2->E2_CODRET),4)
  
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
           If !Empty(SM0->M0_CGC) //SUBS(SM0->M0_CGC,1,14) 
               _cRetorno += "2"  //Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
           Else               
              _cRetorno += "2"       
           EndIf
  
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
            If !Empty(SM0->M0_CGC)
            //   _cRetorno += Subs(SM0->M0_CGC,1,14)
            //Else
            //   _cRetorno += Subs(SM0->M0_CGC,1,14)
            //EndIf 
            _cRetorno += Strzero(Val(u_dadosSM0("02",SE2->E2_FILIAL)),14) 
            Endif
                                                 
            // Posicao 039 a 046: Periodo Apuracao //ATENCAO
            _cRetorno += GravaData(SE2->E2_XAPUR,.F.,5) 
            
            // Posicao 047 a 063: Referencia  //ATENCAO 
            _cRetorno +=  Strzero(Val(SE2->E2_IDDARF),17)

            // Posicao 064 a 077: Valor Principal
            _cRetorno += Strzero(SE2->E2_SALDO*100,14)                               
            
            // Posicao 078 a 091: Multa  //ATENCAO           
            _cRetorno += STRZERO(SE2->E2_XMULTA*100,14)         
            
            // Posicao 092 a 105: Juros   //ATENCAO     
            _cRetorno += Strzero(SE2->E2_XJUROS*100,14)          

            // Posicao 106 a 119: Valor Total (Principal + Multa + Juros) //ATENCAO
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_XJUROS)*100,14)           

            // Posicao 120 a 127: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)                             

            // Posicao 128 a 135: Data Pagamento                            
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                            

            // Posicao 136 a 165: Compl.Registro                          
            _cRetorno += Space(30)                                                   

            // Posicao 166 a 195: Nome do Contribuinte                 
            If !Empty(SM0->M0_NOME)  //SUBS(SM0->M0_NOME,1,30)
               _cRetorno += SUBS(SM0->M0_NOME,1,30)
               Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(SE2->E2_XAPUR)  //ATENÇAO                            
        
               MsgAlert('Tributo sem Data de Apuracao. Informe o campo Apuracao no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     
  
            
         // Dados GPS  //POR FILIAL
         ElseIf (SEA->EA_MODELO == "17")   
   
            // Posicao 018 a 019: Identificacao do Tributo 01-GPS                    
            //_cRetorno := "01"                                                       

            // Posicao 020 a 023: Codigo Pagamento                                 
            _cRetorno +=  STRZERO(Val(SE2->E2_CODINS),4)     //cod receita campo padrão
                                                 
            // Posicao 024 a 029: Competencia   MMAAAA  //mes e ano competencia
            _cRetorno += STRZERO(MONTH(SE2->E2_XAPUR),2)+STRZERO(YEAR(SE2->E2_XAPUR),4)
            
            // Posicao 030 a 043: N Identificacao  //--- CNPJ/CPF do Contribuinte        
            _cRetorno += Strzero(Val(u_dadosSM0("02",SE2->E2_FILIAL)),14)                                                         

              // Posicao 044 a 057: Valor Principal (Valor Titulo - Outras Entidades)
            _cRetorno += Strzero((SE2->E2_SALDO-SE2->E2_XOENTID)*100,14)   //atenção campo                            
            
            // Posicao 058 a 071: Valor Outras Entidades
            _cRetorno += Strzero(SE2->E2_XOENTID*100,14)            
            
            // Posicao 072 a 085: Multa        
            _cRetorno += Strzero(SE2->E2_XMULTA+SE2->E2_XJUROS*100,14)  //atenção campo           
            
            // Posicao 086 a 099: Valor Total (Principal + Multa)
            _cRetorno += Strzero((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_XJUROS)*100,14)              

            // Posicao 100 a 107: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                             

            // Posicao 108 a 115: Compl.Registro                          
            _cRetorno += Space(8)                                                   

            // Posicao 116 a 165: Informacoes Complementares              
            _cRetorno += Space(50)                                                  

            // Posicao 166 a 195: Nome do Contribuinte                                                  
            If !Empty(SM0->M0_CGC)
               _cRetorno += Subs(SM0->M0_NOME,1,30)
             Else
               _cRetorno += Subs(SM0->M0_NOME,1,30)
            EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(SE2->E2_XAPUR)                             
        
               MsgAlert('Tributo sem Competencia. Informe o campo Apuração no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     
   
   
                                                             

         //----- DARF SIMPLES
         ElseIf  SEA->EA_MODELO == "18"   
                                                                     
            // Posicao 018 a 019: Identificacao do Tributo  03-Darf Simples
            //_cRetorno := "03"                          

            // Posicao 020 a 023: Codigo da Receita  - Para DARF Simples - fixar código 6106
             _cRetorno += "6106"
                       
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
             _cRetorno += Strzero(Val(u_dadosSM0("02",SE2->E2_FILIAL)),14) 
			
			   
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
            //EndIf
              _cRetorno += Strzero(Val(u_dadosSM0("02",SE2->E2_FILIAL)),14) 
              
                                                 
            // Posicao 039 a 046: Periodo Apuracao
            _cRetorno += GravaData(SE2->E2_XAPUR,.F.,5) 
            
            // Posicao 047 a 055: Valor da Receita Bruta Acumulada
            _cRetorno += Repl("0",9) 
            
            // Posicao 056 a 059: % sobre a Receita Bruta Acumulada
            _cRetorno += Repl("0",4) 
            
            // Posicao 060 a 063: Compl.Registro                          
            _cRetorno += Space(4)                                                   

            // Posicao 064 a 077: Valor Principal
            _cRetorno += Strzero(SE2->E2_SALDO*100,14)                               
            
            // Posicao 078 a 091: Multa             
            _cRetorno += STRZERO(SE2->E2_XMULTA*100,14)         
            
            // Posicao 092 a 105: Juros        
            _cRetorno += STRZERO(SE2->E2_XJUROS*100,14)         
            
            // Posicao 106 a 119: Valor Total (Principal + Multa + Juros)
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_XJUROS)*100,14)           

            // Posicao 120 a 127: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)                             

            // Posicao 128 a 135: Data Pagamento                            
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                            

            // Posicao 136 a 165: Compl.Registro                          
            _cRetorno += Space(30)                                                   

            // Posicao 166 a 195: Nome do Contribuinte                 
            If !Empty(SM0->M0_CGC)
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
               Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(SE2->E2_XAPUR)                              
        
               MsgAlert('Tributo sem Data de Apuracao. Informe o campo Apuracao no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     
  

         //--- GARE ICMS SP                  
         ElseIf SEA->EA_MODELO == "22" //--- GARE ICMS - SP
 
            // Posicao 018 a 019: Identificacao do Tributo  05-ICMS
            // _cRetorno := "05"                          

            // Posicao 020 a 023: Codigo da Receita                                 
            _cRetorno += STRZERO(Val(SE2->E2_XCODREC),4)  
                       
            // Posicao 024 a 024: Tp Inscricao  1-CNPJ /  2-CEI               
            _cRetorno += "1"       
            
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
            _cRetorno += Strzero(Val(u_dadosSM0("02",SE2->E2_FILIAL)),14) 
  
            //--- Posicao 039 a 050: Inscricao Estadual-  
            _cRetorno += Strzero(Val(u_dadosSM0("01",SE2->E2_FILIAL)),12)
 
            //--- Posicao 051 a 063: Divida Ativa / Etiqueta  
            _cRetorno +=  "0000000000000" //Strzero(Val(SE2->E2_XDIVID),13)                               

            //--- Posicao 064 a 069: Periodo de Referencia (Mes/Ano)  Formato MMAAAA 
            _cRetorno += Strzero(Month(SE2->E2_XAPUR),2)+Strzero(Year(SE2->E2_XAPUR),4)  

            //--- Posicao 070 a 082: N. Parcela / Notificação  
            //_cRetorno +=  "0000000000000" //Strzero(Val(SE2->E2_XPARCE),13)
            _cRetorno += Strzero(Val(SE2->E2_XIDENTI),13)                   

            //--- Posicao 083 a 096: Valor da Receita (Principal) 
            _cRetorno += Strzero(SE2->E2_SALDO*100,14)
     
            //--- Posicao 097 a 110: Valor Juros/Encargos 
            _cRetorno += Strzero(SE2->E2_XJUROS*100,14)                              

            //--- Posicao 111 a 124: Valor da Multa              
            _cRetorno += Strzero(SE2->E2_XMULTA*100,14)     
            
            //--- Posicao 125 a 138: Valor do Pagamento              
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_XJUROS)*100,14)           
            
            //--- Posicao 139 a 146: Data de Vencimento   Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCTO,.F.,5)                               

            //--- Posicao 147 a 154: Data de Pagamento-  Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCREA,.F.,5)                               

            //--- Posicao 155 a 165: Brancos                                   
            _cRetorno += Space(11)                                                      

            //--- Posicao 166 a 195: Nome do Contribuinte                                   
            If !Empty(SM0->M0_CGC)
                _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
              Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf   
  
                           
 
         //--- 35 - FGTS              
         ElseIf SEA->EA_MODELO == "35" 

            // Posicao 018 a 019: Identificacao do Tributo  11-FGTS-GFIP
            // _cRetorno := "11"                          

            // Posicao 020 a 023: Codigo da Receita  
            _cRetorno += STRZERO(Val(SE2->E2_XCODREC),4)  
                       
            // Posicao 024 a 024: Tp Inscricao  1-CNPJ /  2-CEI               
            If !Empty(SM0->M0_CGC)
                _cRetorno += "1" //Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
            Else               
              _cRetorno += "1"       
            EndIf
  
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
                       
            	If !Empty(SM0->M0_CGC)
               	//_cRetorno += Subs(SM0->M0_CGC,1,14)
            	//Else
               	//_cRetorno += Subs(SM0->M0_CGC,1,14)
            	//EndIf
            	_cRetorno += Strzero(Val(u_dadosSM0("02",SE2->E2_FILIAL)),14) 
                Endif
                                                               
            // Posicao 039 a 086: Codigo de Barras
            _cRetorno += SE2->E2_LINDIG  //SE2->E2_CODBAR 
            
            // Posicao 087 a 102: Identificador do FGTS  
            _cRetorno += STRZERO(Val(SE2->E2_XIDENTI),16)
            
            
            // Posicao 103 a 111: Lacre de Conectividade Social
            _cRetorno += "000000000" //Strzero(Val(SE2->E2_LACRE),9)
             
            // Posicao 112 a 113: Digito do Lacre de Conectividade Social
            _cRetorno += "00" //Strzero(Val(SE2->E2_DGLACR),2)
             
            // Posicao 114 a 143: Nome do Contribuinte                 
            If !Empty(SM0->M0_CGC)
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            EndIf                                                                      
            
            // Posicao 144 a 151: Data Pagamento                            
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                            

            // Posicao 152 a 165: Valor do Pagamento
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_XJUROS-SE2->E2_DECRESC)*100,14)           

            // Posicao 166 a 195: Compl.Registro                          
            _cRetorno += Space(30)                                                   
         
         EndIf     
  
  
    Otherwise  //  Parametro não existente
      
	 MsgAlert('Não foi encontrado o Parametro '+ _cTipo + "."+;
                  'Solicite à informática para verificar o fonte PAGAR341, ou o arquivo de configuração do CNAB.')  

EndCase		      

return(_cRetorno)     


//--- Retornar Inscrição Estadual e CNPJ da Filial do Título do SE2
User Function DadosSM0(_cOpc,_cFilSE2)
                                                            
Local _cVolta := ""
Local _nRecnoSM0 :=SM0->(Recno())


  SM0->(dbSetOrder(1))
  SM0->(dbSeek(cEmpAnt+_cFilSE2))
		
  If _cOpc == "01"
     _cVolta := SM0->M0_INSC 
  Else
    _cVolta := SM0->M0_CGC
  EndIf
		
SM0->(dbGoto(_nRecnoSM0))


Return(_cVolta)


