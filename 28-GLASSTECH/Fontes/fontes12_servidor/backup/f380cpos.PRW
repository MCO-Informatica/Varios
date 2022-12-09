
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF380CPOS  บAutor  ณ S้rgio Santana     บ Data ณ 16/05/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออ2อออออนฑฑ
ฑฑบDesc.     ณ Este ponto de entrada tem a finalidade de reclassificar a  บฑฑ
ฑฑบ          ณ os dados a serem visualizados no markbrowse da reconcilia  บฑฑ
ฑฑบ          ณ cao banacaria.                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Glasstech                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION F380CPOS()

	LOCAL _aCampos := {}

	_aCampos:= { { "E5_OK"  	   ,, OemToAnsi("Rec.")         },; 
				  { "E5_FILIAL"    ,, "Filial" 					},;
				  { "E5_DATA"	   ,, OemToAnsi("DT Movimento") },;
				  { "E5_TIPO" 	   ,, "Tipo"	 				},; 
				  { "E5_PREFIXO"   ,, "Prefixo"				    },;
				  { "E5_NUMERO"    ,, "N๚mero"			        },;
				  { "E5_PARCELA"   ,, "Parcela"				    },;
				  { "E5_CLIFOR"	   ,, "Cli/For"				    },;
				  { "E5_LOJA" 	   ,, "Loja"	 				},;
				  { "E5_DTDISPO"   ,, "DT Disponivel"           },; 		 
				  { "E5_VALOR"     ,, OemToAnsi("Vlr. Movimen."),PesqPict("SE5","E5_VALOR",19)},; 
				  { "E5_RECPAG"    ,, OemToAnsi("Rec/Pag")      },; 
				  { "E5_NUMCHEQ"   ,, OemToAnsi("Num. Cheque")  },; 
				  { "E5_DOCUMEN"   ,, OemToAnsi("Documento")    },; 
				  { "E5_HISTOR"    ,, OemToAnsi("Histขrico")    },; 
				  { "E5_MOEDA"     ,, OemToAnsi("Numer rio")    },; 
				  { "E5_NATUREZ"   ,, OemToAnsi("Natureza")     },; 
				  { "E5_VENCTO"    ,, OemToAnsi("Vencimeto")    },; 
				  { "E5_BENEF"     ,, OemToAnsi("Benefici rio") },; 
				  { "E5_CREDITO"   ,, OemToAnsi("Cta Crdito")  },;  
				  { "E5_BANCO"     ,, OemToAnsi("Banco")        },; 
				  { "E5_AGENCIA"   ,, OemToAnsi("Agncia")      },; 
				  { "E5_CONTA"     ,, OemToAnsi("Conta")        } ; 
				}

Return( _aCampos )