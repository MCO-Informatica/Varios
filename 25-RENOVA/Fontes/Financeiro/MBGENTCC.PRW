#INCLUDE 'PROTHEUS.CH'

/*
Autor:  	Luiz M. Suguiura - UpDuo
Função:		MBGATENTCC
Descrição:  Gatilhar entidades contabeis Centro de Custo pela natureza financeira.
Uso:        Renova                                                     
Data:		14/09/2021
*/

User Function MBGENTCC()

Local _cEntCC := ""

If ALLTRIM(M->E5_NATUREZ) $ "1204,2338,2412,2416,2501,2508,2513,2513,2514,2516,2520,2521,2604,3107"
   	_cEntCC := "22000"
Else
   	if AllTrim(M->E5_NATUREZ) $ "2006,2301,2341,2341,2343,2351,2408,2409,2410,2421,2512,3103,3203"
		_cEntCC := ""
	else
		if AllTrim(M->E5_NATUREZ) $ "2310,2311"
		   _cEntCC := "11000"
		ENDIF
   	Endif
Endif

Return(_cEntCC)
