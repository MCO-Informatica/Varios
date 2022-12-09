#Include 'Protheus.ch'

#DEFINE ENTER Chr(13)+Chr(10)

//---------------------------------------------------------------------------------
// Rotina | CRMA980        | Autor | Lucas Baia          | Data |    13/05/2022	
//---------------------------------------------------------------------------------
// Descr. | Ponto de Entrada em MVC do Cadastro de Clientes (MATA030)
//---------------------------------------------------------------------------------
// Uso    | BIODOMANI
//---------------------------------------------------------------------------------


User Function CRMA980()

Local aParam    := PARAMIXB //Par�metro obrigat�rio no PEs em MVC, pois eles trazem informa��es importantes sobre o estado e ponto de execu��o da rotina.
Local xRet      := .T. //Esta variavel pode retornar no final, tanto l�gico quanto um array.
Local cEmailTo  := "financeiro@hgrextrusoras.com.br"
Local cAssunto  := "An�lise de Cr�dito - Novo Cliente"
Local cMensagem

/* RETORNO DO ARRAY aParam
1   O   Objeto do formul�rio ou do modelo, conforme o caso
2   C   ID do Local de execu��o do ponto de entrada
3   C   ID do Formul�rio
*/

Local oObject   := aParam[1] //Objeto do formul�rio ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do Local de execu��o do ponto de entrada 
Local cIdModel  := aParam[3] //ID do Formul�rio

Local nOperation     := oObject:GetOperation()
/*
1- Pesquisar
2- Visualizar
3- Incluir
4- Alterar
5- Excluir
6- Outras Fun��es
7- Copiar
*/

IF aParam[2] <> Nil //Se ele estiver diferente de nulo, quer dizer que alguma a��o est� sendo feita no modelo
        
		IF cIdPonto == "MODELCOMMITTTS" //Ap�s a grava��o total do modelo e dentro da transa��o.

				IF nOperation == 3 //Inclus�o
		
				cMensagem := "Foi inclu�do um novo Cliente "+Alltrim(SA1->A1_COD)+" Loja "+Alltrim(SA1->A1_LOJA)+", "+Alltrim(SA1->A1_NOME)+" CNPJ/CPF "+Alltrim(SA1->A1_CGC)+"."+" Favor realizar consulta aos �rg�os de prote��o ao cr�dito!!!"						  	   
                U_envmail(cEmailTo,,cAssunto,cMensagem,,,,)

                ENDIF
			
        ENDIF
ENDIF

Return xRet
