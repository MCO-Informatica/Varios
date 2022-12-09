#include "protheus.ch"      
           
// Este fonte tem como função que chamar cadastros padrões da Thermoglass

user function CADFZZ2               
	DbSelectArea("ZZ2")       
	dbSetOrder(1)
	AxCadastro("ZZ2", "Cadastro Marca Proprietária", ".T.", ".T.")
return    

user function CADFZZ3      
	DbSelectArea("ZZ3")  
	dbSetOrder(1)
	AxCadastro("ZZ3", "Cadastro Modelo Produção", ".T.", ".T.")
return 

user function CADFZZ4 
	DbSelectArea("ZZ4")  
	dbSetOrder(1)
	AxCadastro("ZZ4", "Cadastro Aplicação Comercial", ".T.", ".T.")
return            

user function CADFZZ5  
	DbSelectArea("ZZ5")  
	dbSetOrder(1)
	AxCadastro("ZZ5", "Cadastro Tipo Produto", ".T.", ".T.")
return     

user function CADFZZ6 
	DbSelectArea("ZZ6")  
	dbSetOrder(1)
	AxCadastro("ZZ6", "Cadastro Cor Produto", ".T.", ".T.")
return   

user function CADFZZ7 
	DbSelectArea("ZZ7")  
	dbSetOrder(1)
	AxCadastro("ZZ7", "Cadastro Lado Vidro", ".T.", ".T.")
return 

user function CADFZZE
	DbSelectArea("ZZE")  
	dbSetOrder(1)
	AxCadastro("ZZE", "Cadastro Setores", ".T.", ".T.")
return

user function CADFZZG
	DbSelectArea("ZZG")
	dbSetOrder(1)
	AxCadastro("ZZG", "Cadastro Tes x Valor serviço", ".T.", ".T.")
return

user function CADFZZJ
	DbSelectArea("ZZJ")
	dbSetOrder(1)
	AxCadastro("ZZJ", "Cadastro Tipo Prod x Grupo Prod", ".T.", ".T.")
return

user function CADFZZH
	DbSelectArea("ZZH")
	dbSetOrder(1)
	AxCadastro("ZZH", "Cadastro de informação de erros", ".T.", ".T.")
return

user function ZP1SET1()
	U_CADFZP1(1)
return

user function ZP1SET2()
	U_CADFZP1(2)
return

user function ZP1SET3()
	U_CADFZP1(3)
return

user function ZP1SET4()
	U_CADFZP1(4)
return

user function ZP1SET5()
	U_CADFZP1(5)
return

user function ZP1SET6()
	U_CADFZP1(6)
return

user function ZP1SET7()
	U_CADFZP1(7)
return

user function ZP1SET8()
	U_CADFZP1(8)
return

user function CADFZP1(cSetor)
	private cAlias := "ZP1"
	private aRotina := {}
	private lRefresh := .T.
	private cCadastro := "Fluxo de produção - "
	
	dbSelectArea("ZZE")
	dbSetOrder(1)
	
	if (!dbSeek(xFilial("ZZE") + cValToChar(cSetor)))
		Alert("Setor informado não existe na empresa.")
		return nil
	else
		cCadastro += AllTrim(ZZE->ZZE_DESCRI)
	endif
	
	aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
	aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
	aAdd(aRotina, {"Incluir", "AxInclui", 0, 3})
	aAdd(aRotina, {"Alterar", "AxAltera", 0, 4})
	aAdd(aRotina, {"Excluir", "AxExcluir", 0, 5})
	
	dbSelectArea(cAlias)
	
	mBrowse(nil, nil, nil, nil, cAlias)
return nil