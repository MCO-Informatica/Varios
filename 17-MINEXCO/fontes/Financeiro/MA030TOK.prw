#INCLUDE "PROTHEUS.CH" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030TOK   �Autor  �Rafael Strozi       � Data �  13/09/11  ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica��o de dados na inclus�o/altera��o de clientes 	  ���
���          � Principalmente dados para NFs de Exporta��o                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA030TOK()
	Local cEst		:= M->A1_EST   
	Local cCNPJ		:= M->A1_CGC
	Local cCEP		:= M->A1_CEP
	Local cMun		:= M->A1_COD_MUN
	Local cPais1	:= M->A1_PAIS
	Local cPais2  	:= M->A1_CODPAIS
	Local cPais3  	:= M->A1_PABCB
	Local cEmail	:= M->A1_EMAIL
	Local cIE		:= M->A1_INSCR
	Local cContrib	:= M->A1_CONTRIB
	Local cTipo		:= M->A1_TIPO
	Local cPessoa	:= M->A1_PESSOA
	Local lOk		:= .T.
	
	If cEst == 'EX'
		If Alltrim(cCNPJ) <> ''
			Alert("Por ser cliente exporta��o 'CNPJ' deve estar em branco!")
			lOk := .F. 
		ElseIf cCEP	<> '00000000'
			Alert("Por ser cliente exporta��o 'CEP' deve ser igual a '00000-000'!")
		    lOk := .F.
		ElseIf cMun <> '99999'
			Alert("Por ser cliente exporta��o 'Cd.Municipio' deve ser igual a '99999'")
			lOk := .F.
		ElseIf cPais1 == '105'
			Alert("Por ser cliente exporta��o 'Pa�s' deve ser diferente de '105'")
			lOk := .F.			
		ElseIf cPais2 == '01058'
			Alert("Por ser cliente exporta��o 'Pa�s Bacen' deve ser diferente de '01058'")
			lOk := .F.
		ElseIf cPais3 == '01058'
			Alert("Por ser cliente exporta��o 'Cod.Pa�s BCB' deve ser diferente de '01058'")
			lOk := .F.			
		ElseIf Alltrim(cEmail) == ''
			Alert("Email Obrigat�rio!")
			lOk := .F.
		ElseIf cTipo <> 'X'
			Alert("Tipo de Cliente deve ser igual a 'Exporta��o'")
			lOk := .F.
		ElseIf cContrib == '1'
			Alert("Campo 'Contribuinte' na pasta 'Fiscais' deve ser igual a 'N�o'. Verifique!")
			lOk	:= .F.
		EndIf
	ElseIf cEst <> 'EX'
		If Alltrim(cCNPJ) == ''
			Alert("'CNPJ' Obrigat�rio!")
			lOk := .F.
		ElseIf Alltrim(cEmail) == ''
			Alert("Email Obrigat�rio")
			lOk := .F.
		ElseIf Alltrim(cIE) == ""
			Alert("Inscri��o Estadual do Cliente n�o pode estar em branco! Caso o cliente n�o possua, deve ser 'ISENTO'.")
			lOk	:= .F.
		ElseIf Alltrim(cIE) == "ISENTO" .And. cContrib == '1'
			Alert("Campo 'Contribuinte' na pasta 'Fiscais' deve ser igual a 'N�o'. Verifique!")
			lOk := .F.
		ElseIf Alltrim(cIE) != "ISENTO" .And. cContrib == '2'
			Alert("Campo 'Contribuinte' na pasta 'Outros' deve ser igual a 'Sim'. Verifique!")
			lOk	:= .F.			
		ElseIf cPessoa == 'F' .And. cTipo != 'F'
			Alert("Tipo cliente deve ser 'Cons. Final' quando 'Fisica/Jurid' = 'Fisica' ! Verifique!")
			lOk := .F.	
		EndIf
	EndIf
	
	If Alltrim(cEmail) == 'sememail@dominio.com.br' .Or. Alltrim(cEmail) == ''
		Alert("O email � muito importante na comunica��o com o cliente! Procure utilizar o email do cliente/empresa! Lembre-se de que o email � utilizado para envio do xml da NF-e . Evite o uso do sememail@dominio.com.br !")
	EndIf
				
Return lOk