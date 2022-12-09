
User Function FCTeste()

	Local _aClientes	:= {}
	Local _cCodMun		:= ""
	Private lMsErroAuto	:= .F.

	_aCliente:={	{"A1_FILIAL"    ,XFILIAL("SA1")           					,Nil},; // Codigo       C 06
					{"A1_COD"       ,"TESTE2"           					,Nil},; // Codigo       C 06
					{"A1_LOJA"      ,"01"             					,Nil},; // Loja         C 02
					{"A1_PESSOA"    ,"J"								,Nil},; // Nome         C 40
					{"A1_XVAL1"		,"N"									,Nil},; // Nome         C 40
				 	{"A1_NOME"      ,"TESTE CAD"  								,Nil},; // Nome         C 40
				 	{"A1_NREDUZ"    ,"TESTE CAD"		 							,Nil},; // Nome reduz.  C 20
				 	{"A1_TIPO"      ,"F"								,Nil},; // Tipo         C 01 //R Revendedor
				 	{"A1_CEP"		,"09220190"									,Nil},; // Nome         C 40
				 	{"A1_END"       ,"Rua teste"									,Nil},; // Endereco     C 40
				 	{"A1_BAIRRO"	,"teste"								,Nil},; // Nome         C 40
				 	{"A1_EST"		,"SP"									,Nil},; // Nome         C 40
				 	{"A1_CGC"		,"33033028002047"									,Nil},; // Nome         C 40
					{"A1_MUN"       ,"SANTO ANDRE"									,Nil},; // Cidade       C 15
					{"A1_COD_MUN"	,"47809"								,Nil},; // Nome         C 40
					{"A1_DDD"		,"011"						,Nil},; // Nome         C 40
					{"A1_INSCR"		,"675040798117"								,Nil},; // Nome         C 40
					{"A1_TEL"		,"9999999"								,Nil},; // Nome         C 40
					{"A1_PAIS"		,"013"									,Nil},; // Nome         C 40
					{"A1_XVAL2"		,"N"									,Nil},; // Nome         C 40
					{"A1_NATUREZ"	,"1002"									,Nil},; // Nome         C 40
					{"A1_XVAL3"		,"N"									,Nil},; // Nome         C 40
					{"A1_XVAL4"		,"N"									,Nil},; // Nome         C 40
					{"A1_VEND"		,"000011"									,Nil},; // Nome         C 40
					{"A1_CONTA"		,"1.1.2.01.01"									,Nil},; // Nome         C 40
					{"A1_SATIV1"	,"000001"									,Nil},; // Nome         C 40
					{"A1_CODPAIS"	,"00132" 								,Nil},; // Nome         C 40
					{"A1_MSBLQL"	,"2"  								,Nil},; // Nome         C 40
					{"A1_CLVL"		,"APRCUSTOS"								,Nil},; // Nome         C 40
					{"A1_CNAE"		,"2539-0/01"									,Nil},;
					{"A1_SOLICIT"	,"VEND1"								,Nil},;
					{"A1_DTCADAS"	,DATE()									,Nil},;
					{"A1_USERLGI"	,"PORTAL"								,Nil}}  // Estado       C 02
					
		lMsErroAuto	:= .F.
		MSExecAuto({|x,y| Mata030(x,y)},_aCliente,3)
		
		If lMsErroAuto
			Mostraerro()
		EndIF
		
Return()