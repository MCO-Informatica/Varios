#ifdef SPANISH
	#define STR0001 "Informe de Visitas "
	#define STR0002 "Este programa emitira el detalle de visitas a los clientes"
	#define STR0003 "hechas por los vendedores."
	#define STR0004 "A Rayas"
	#define STR0005 "Administracion"
	#define STR0006 "INFORME DE VISITAS A CLIENTES  "
	#define STR0007 "VENDEDOR  CODIGO               SUC.  RAZON SOCIAL                              ULT.VISITA  FREC  CONTATO             TELEFONO"
	#define STR0008 "ANULADO POR EL OPERADOR"
	#define STR0009 "Seleccionando registros..."
	#define STR0010 "Informe de Visitas"
	#define STR0011 "Este programa emitira la lista con las visitas a clientes,"
	#define STR0012 "efectuadas por los vendedores."
	#define STR0013 "Seleccionando Registros..."
	#define STR0014 "Clientes"
#else
	#ifdef ENGLISH
		#define STR0001 "Report of Calls"
		#define STR0002 "This program will print a list of Visits to the Customers,"
		#define STR0003 "accomplished by the Sales Representatives."
		#define STR0004 "Z.Form"
		#define STR0005 "Management"
		#define STR0006 "REPORT OF VISITS TO CUSTOMERS"
		#define STR0007 "REPRESE.  CODE                 UNIT  COMPANY NAME                              LST.VISIT   FREQ  CONTACT             PHONE"
		#define STR0008 "CANCELLED BY THE OPERATOR"
		#define STR0009 "Selecting Records ...    "
		#define STR0010 "Report of visits     "
		#define STR0011 "This program will list visits to customers                 "
		#define STR0012 "made by sales represent."
		#define STR0013 "Selecting records ...    "
		#define STR0014 "Customers"
	#else
		Static STR0001 := "Relatorios de Visitas"
		Static STR0002 := "Este programa ira emitir a relacao de visitas aos clientes,"
		Static STR0003 := "feitas pelos vendedores."
		Static STR0004 := "Zebrado"
		Static STR0005 := "Administracao"
		Static STR0006 := "RELATORIO DE VISITAS A CLIENTES"
		Static STR0007 := "VENDEDOR  CODIGO               LOJA  RAZAO SOCIAL                              ULT.VISITA  FREQ  CONTATO             TELEFONE"
		Static STR0008 := "CANCELADO PELO OPERADOR"
		Static STR0009 := "Selecionando Registros..."
		Static STR0010 := "Relatorios de Visitas"
		Static STR0011 := "Este programa ira emitir a relacao de visitas aos clientes,"
		Static STR0012 := "feitas pelos vendedores."
		Static STR0013 := "Selecionando Registros..."
		#define STR0014  "Clientes"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Relatórios De Visitas"
			STR0002 := "Este programa irá emitir a relação de visitas aos clientes,"
			STR0003 := "Feitas pelos vendedores."
			STR0004 := "Código de barras"
			STR0005 := "Administração"
			STR0006 := "Relatório De Visitas A Clientes"
			STR0007 := "Vendedor  Código               Loja  Razão Social                              últ.visita  Freq  Contacto             Telefone"
			STR0008 := "Cancelado Pelo Operador"
			STR0009 := "A Seleccionar Registos..."
			STR0010 := "Relatórios De Visitas"
			STR0011 := "Este programa irá emitir a relação de visitas aos clientes,"
			STR0012 := "Feitas pelos vendedores."
			STR0013 := "A Seleccionar Registos..."
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Relatórios De Visitas"
			STR0002 := "Este programa irá emitir a relação de visitas aos clientes,"
			STR0003 := "Feitas pelos vendedores."
			STR0004 := "Código de barras"
			STR0005 := "Administração"
			STR0006 := "Relatório De Visitas A Clientes"
			STR0007 := "Vendedor  Código               Loja  Razão Social                              últ.visita  Freq  Contacto             Telefone"
			STR0008 := "Cancelado Pelo Operador"
			STR0009 := "A Seleccionar Registos..."
			STR0010 := "Relatórios De Visitas"
			STR0011 := "Este programa irá emitir a relação de visitas aos clientes,"
			STR0012 := "Feitas pelos vendedores."
			STR0013 := "A Seleccionar Registos..."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
