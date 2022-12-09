#ifdef SPANISH
	#define STR0001 "No se identificó la configuración mínima para la generación del MAPAS. Configure el parámetro MV_PRODPF con el campo de la SB5 responsable por la identificación de Productos químicos controlados."
	#define STR0002 "Ocurrió un error en el intento de la generación del archivo magnético. Verifique los parámetros pertinentes e intente nuevamente. Código del error:"
#else
	#ifdef ENGLISH
		#define STR0001 "The minimum configuration for MAPS generation was not identified. Set the MV_PRODPF parameter with the SB5 field responsible for identifying Controlled Chemicals."
		#define STR0002 "There was an error trying to create the magnetic file. Check the relevant parameters and try again. Error code:"
	#else
		#define STR0001 "Não foi identificada a configuração mínima para a geração do MAPAS. Configure o parâmetro MV_PRODPF com o campo da SB5 responsável pela identificação de Produtos Químicos Controlados."
		#define STR0002 "Ocorreu um erro na tentativa da geração do arquivo magnético. Verifique os parâmetros pertinentes e tente novamente. Código do erro: "
	#endif
#endif
