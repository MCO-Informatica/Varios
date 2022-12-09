#Include 'protheus.ch'
#Include 'fwmvcdef.ch'

#DEFINE ENTER Chr(13)+Chr(10)

//---------------------------------------------------------------------------------
// Rotina | CRMA980        | Autor | Lucas Baia          | Data |    13/05/2022	
//---------------------------------------------------------------------------------
// Descr. | Ponto de Entrada em MVC do Cadastro de Clientes (MATA030)
//---------------------------------------------------------------------------------
// Uso    | PITERPAN
//---------------------------------------------------------------------------------


User Function CRMA980()

Local aParam    := PARAMIXB //Parâmetro obrigatório no PEs em MVC, pois eles trazem informações importantes sobre o estado e ponto de execução da rotina.
Local xRet      := .T. //Esta variavel pode retornar no final, tanto lógico quanto um array.
Local cEmailTo  := "sandra@piterpan.com.br"
Local cAssunto  := "Análise de Crédito - Novo Cliente"
Local cMensagem

/* RETORNO DO ARRAY aParam
1   O   Objeto do formulário ou do modelo, conforme o caso
2   C   ID do Local de execução do ponto de entrada
3   C   ID do Formulário
*/

Local oObject   := aParam[1] //Objeto do formulário ou do modelo, conforme o caso
Local cIdPonto  := aParam[2] //ID do Local de execução do ponto de entrada 
Local cIdModel  := aParam[3] //ID do Formulário

Local nOperation     := oObject:GetOperation()
/*
1- Pesquisar
2- Visualizar
3- Incluir
4- Alterar
5- Excluir
6- Outras Funções
7- Copiar
*/

IF aParam[2] <> Nil //Se ele estiver diferente de nulo, quer dizer que alguma ação está sendo feita no modelo
        
	IF cIdPonto == "MODELCOMMITTTS" //Após a gravação total do modelo e dentro da transação.

		IF nOperation == 3 //Inclusão
		
			cMensagem := "Foi incluído um novo Cliente "+Alltrim(SA1->A1_COD)+" Loja "+Alltrim(SA1->A1_LOJA)+", "+Alltrim(SA1->A1_NOME)+" CNPJ/CPF "+Alltrim(SA1->A1_CGC)+"."+" Favor realizar consulta aos órgãos de proteção ao crédito!!!"						  	   
                        U_envmail(cEmailTo,,cAssunto,cMensagem,,,,)

                ENDIF
			
        ENDIF

        If cIdPonto == "MODELVLDACTIVE"

                IF RETCODUSR()$"000105/000292/000002/000003" // Alteração
                        // MODELO -> SUBMODELO -> ESTRUTURA -> PROPRIEDADE -> BLOCO DE CÓDIGO -> X3_WHEN := .F.
                        oObject:GetModel("SA1MASTER"):GetStruct():SetProperty('A1_RISCO', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , '.T.'))
                        oObject:GetModel("SA1MASTER"):GetStruct():SetProperty('A1_LC', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , '.T.'))
                        oObject:GetModel("SA1MASTER"):GetStruct():SetProperty('A1_VENCLC', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , '.T.'))
                        oObject:GetModel("SA1MASTER"):GetStruct():SetProperty('A1_MSBLQL', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , '.T.'))
                ELSE 
                        // MODELO -> SUBMODELO -> ESTRUTURA -> PROPRIEDADE -> BLOCO DE CÓDIGO -> X3_WHEN := .F.
                        oObject:GetModel("SA1MASTER"):GetStruct():SetProperty('A1_RISCO', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , '.F.'))
                        oObject:GetModel("SA1MASTER"):GetStruct():SetProperty('A1_LC', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , '.F.'))
                        oObject:GetModel("SA1MASTER"):GetStruct():SetProperty('A1_VENCLC', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , '.F.'))
                        oObject:GetModel("SA1MASTER"):GetStruct():SetProperty('A1_MSBLQL', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , '.F.'))
                ENDIF

        EndIf
ENDIF

Return xRet
