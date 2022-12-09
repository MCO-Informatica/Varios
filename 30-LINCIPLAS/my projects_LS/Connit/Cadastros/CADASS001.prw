
#INCLUDE "PROTHEUS.CH"   


/*
+=====================================================+
|Programa: CADP009|Autor: Vanilson Souza |01/08/09    |
+=====================================================+
|Programa utilizado para cadastros de assunto,           |
| sub assunto e auto.                                 |
+=====================================================+
|Uso: Laselva                                         |
+=====================================================+  
*/



User Function CadP010() // *** Cadastro Assunto ***

Local cAlias  := "SZ1"
Local cTitulo :="Cadastro de Assunto"
Local cVldExc :=".T."                                                 
Local cVldAlt :=".T."

dbSelectArea(cAlias)
dbSetOrder(1)
AxCadastro(cAlias, cTitulo, cVldExc, cVldAlt)

return nil        



/* --------------- Altera��o de Assunto -----------------*/

User Function VldAlte(cAlias, nReg, nOpc)

Local lRet    :=  ".T."
Local cTitulo :=  GetArea()
Local cVldExc :=  0

nOpcao  :=  AxAltera(cAlias, nReg, nOpc)

If nOpcao == 1
	 MsgInfo("Altera��o Concluida com Sucesso!")
Endif

RestArea(aArea)

return lRet 

            


/* --------------- Exclusao de Assunto -----------------*/

User Function Exclui(cAlias, nReg, nOpc)

Local lRet    :=  ".T."
Local cTitulo :=  GetArea()
Local cVldExc :=  0

nOpcao  :=  AxExclui(cAlias, nReg, nOpc)

If nOpcao == 1
	 MsgInfo("Exclus�o Efetuada com Sucesso!")
Endif

RestArea(aArea)

return lRet   

User Function CadSub() // *** Cadastro de Subassunto ***

Local cAlias  := "SZ2"
Local cTitulo :="Cadastro de Subassunto"
Local cVldExc :=".T."                                                 
Local cVldAlt :=".T."

dbSelectArea(cAlias)
dbSetOrder(1)
AxCadastro(cAlias, cTitulo, cVldExc, cVldAlt)

return nil        

    
                                    
User Function CadAutor() // *** Cadastro de Autor ***

Local cAlias  := "SZ3"
Local cTitulo :="Cadastro de Autor"
Local cVldExc :=".T."                                                 
Local cVldAlt :=".T."

dbSelectArea(cAlias)
dbSetOrder(1)  
//GETSXENUM("SZ3","Z3_COD",1)             

AxCadastro(cAlias, cTitulo, cVldExc, cVldAlt)

return nil        



            

