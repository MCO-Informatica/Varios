#ifdef SPANISH
	#define STR0001 "Generacion de Neto en archivo"
	#define STR0002 "Este programa tiene por objetivo generar el archivo de neto en disco."
	#define STR0003 "Antes de ejecutar este programa es necesario registrar el lay-out del "
	#define STR0004 "archivo. Modulo SIGACFG opcion CNAB por cobrar o SISPAG. "
	#define STR0005 "Intente nuevamente"
	#define STR0006 "Salir"
	#define STR0007 "Drive A"
	#define STR0008 "Drive B"
	#define STR0009 "Codigo banco "
	#define STR0010 "N� Agencia "
	#define STR0011 "N� C/C.         "
	#define STR0012 "Neto en archivo"
	#define STR0013 "(*.REM) |*.rem|"
	#define STR0014 "(*.2RE) |*.2re|"
	#define STR0015 "(*.PAG) |*.pag|"
	#define STR0016 "Seleccione archivo"
	#define STR0017 "Empleado                             "
	#define STR0018 "Proceso          "
	#define STR0019 "Sucursal          "
	#define STR0020 "�Desea visualizar movimientos generados?"
	#define STR0021 "�Atencion!"
	#define STR0022 "Log de generacion de netos en archivo."
	#define STR0023 "Matricula          "
	#define STR0024 "Total de registros generados: "
	#define STR0025 "Valor total: "
		#define STR0027 "O ENDERECO ESPECIFICADO NO PARAMETRO 'ARQUIVO DE SAIDA' NAO E VALIDO. DIGITE UM ENDERECO VALIDO CONFORME O EXEMPLO:"
		#define STR0028 "UNIDADE:\NOME_DO_ARQUIVO"
		#define STR0029 "/NOME_DO_ARQUIVO"
		#define STR0030 "Arquivo nao encontrado "
		#define STR0031 "Banco e Filial para processamento do CNAB n�o cadastrados na tabela S052! Favor verificar!"
		#define STR0032 "Sair"
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Di�rio De Cria��o  De L�quidos Em Ficheiro.", "Log de Geracao de Liquidos em Arquivo." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "L�quido em ficheiro", "L�quido em Arquivo" )		
		#define STR0036 "� necess�rio informar o c�digo do banco da empresa."
		#define STR0037 "N�o foi informada nenhuma Situa��o nos par�metros."
		#define STR0038 "N�o foi informada nenhuma Categoria nos par�metros."
		

#else
	#ifdef ENGLISH
		#define STR0001 "Generation of Liquid file"
		#define STR0002 "This program generates liquid file in disk."
		#define STR0003 "Before running this program, you must register file "
		#define STR0004 "layout. Module SIGACFG option CNAB Receivable or SISPAG. "
		#define STR0005 "Try again"
		#define STR0006 "Quit"
		#define STR0007 "Drive A"
		#define STR0008 "Drive B"
		#define STR0009 "Bank Code "
		#define STR0010 "Bank Office Nr."
		#define STR0011 "Current Account Nr."
		#define STR0012 "Liquid File"
		#define STR0013 "(*.REM) |*.rem|"
		#define STR0014 "(*.2RE) |*.2re|"
		#define STR0015 "(*.PAG) |*.pag|"
		#define STR0016 "Select File"
		#define STR0017 "Employee                             "
		#define STR0018 "Process          "
		#define STR0019 "Branch          "
		#define STR0020 "Do you want to view generated transactions?"
		#define STR0021 "Attention!"
		#define STR0022 "Generation Log of Liquid in File."
		#define STR0023 "Enrollment          "
		#define STR0024 "Total of Generated Records: "
		#define STR0025 "Total: "
		#define STR0027 "O ENDERECO ESPECIFICADO NO PARAMETRO 'ARQUIVO DE SAIDA' NAO E VALIDO. DIGITE UM ENDERECO VALIDO CONFORME O EXEMPLO:"
		#define STR0028 "UNIDADE:\NOME_DO_ARQUIVO"
		#define STR0029 "/NOME_DO_ARQUIVO"
		#define STR0030 "Arquivo nao encontrado "
		#define STR0031 "Banco e Filial para processamento do CNAB n�o cadastrados na tabela S052! Favor verificar!"
		#define STR0032 "Sair"
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Di�rio De Cria��o  De L�quidos Em Ficheiro.", "Log de Geracao de Liquidos em Arquivo." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "L�quido em ficheiro", "L�quido em Arquivo" )		
		#define STR0036 "� necess�rio informar o c�digo do banco da empresa."
		#define STR0037 "N�o foi informada nenhuma Situa��o nos par�metros."
		#define STR0038 "N�o foi informada nenhuma Categoria nos par�metros."

	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Cria��o  de l�quido em ficheiro", "Gera��o de L�quido em arquivo" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este programa tem o objectivo de criar o ficheiro de l�quido em disco.", "Este programa tem o objetivo de gerar o arquivo de l�quido em disco." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Antes de rodar este programa e necess�rio cadastras o lay-out do ", "Antes de rodar este programa � necess�rio cadastras o lay-out do " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Ficheiro. modulo sigacfg op��o  cnab a receber ou sisp�g. ", "arquivo. M�dulo SIGACFG op��o CNAB a Receber ou SISPAG. " )
		#define STR0005 "Tenta Novamente"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0007 "Drive A"
		#define STR0008 "Drive B"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "C�digo banco   ", "C�digo Banco   " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Num. ag�ncia   ", "Num. Ag�ncia   " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Num. c/c.         ", "Num. C/C.         " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "L�quido em ficheiro", "L�quido em Arquivo" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "(*.rem) |*.rem|", "(*.REM) |*.rem|" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "(*.2re) |*.2re|", "(*.2RE) |*.2re|" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "(*.p�g) |*.p�g|", "(*.PAG) |*.pag|" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Seleccionar Ficheiro", "Selecione Arquivo" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Empregado                             ", "Funcionario                             " )
		#define STR0018 "Processo          "
		#define STR0019 "Filial          "
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Deseja visualizar movimentos criados?", "Deseja visualizar movimentos gerados?" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Aten��o!", "Atencao!" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Di�rio De Cria��o  De L�quidos Em Ficheiro.", "Log de Geracao de Liquidos em Arquivo." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Registo          ", "Matricula          " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Total de registos criados: ", "Total de Registros Gerados: " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Valor total: ", "Valor Total: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Nenhum Registo Processado Com Os Par�metro S Introduzidos!", "Nenhum Registro Processado com os Parametros Informados!" )
		#define STR0027 "O ENDERECO ESPECIFICADO NO PARAMETRO 'ARQUIVO DE SAIDA' NAO E VALIDO. DIGITE UM ENDERECO VALIDO CONFORME O EXEMPLO:"
		#define STR0028 "UNIDADE:\NOME_DO_ARQUIVO"
		#define STR0029 "/NOME_DO_ARQUIVO"
		#define STR0030 "Arquivo nao encontrado "
		#define STR0031 "Banco e Filial para processamento do CNAB n�o cadastrados na tabela S052! Favor verificar!"
		#define STR0032 "Sair"
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Di�rio De Cria��o  De L�quidos Em Ficheiro.", "Log de Geracao de Liquidos em Arquivo." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "L�quido em ficheiro", "L�quido em Arquivo" )		
		#define STR0036 "� necess�rio informar o c�digo do banco da empresa."
		#define STR0037 "N�o foi informada nenhuma Situa��o nos par�metros."
		#define STR0038 "N�o foi informada nenhuma Categoria nos par�metros."
		
	#endif
#endif
