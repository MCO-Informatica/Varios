#include "RWMAKE.CH"

User Function ImpATF()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := ""
Local cDesc1  := "Este rotina ira fazer a importacao do cadastros de Ativo Fixo"
Local cDesc2  := ""
Private _cArquivo := ""
Private cPerg := ""

/*
CriaSX1()
Pergunte(cPerg,.F.)
*/

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

aAdd( aButton, { 5, .T., {|| _cArquivo := SelArq()    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

Return Nil



Static Function RunProc(lEnd)
Local _aDadCab  := {}
Local _aDadItens := {}
Local _aDadHist  := {}
Local _aVetCab := {}
Local _aVetCpos:= {}
Local _aVetHpos:= {}
Local _aVetItens:= {}
Local _nNumCposCab := _nNumCposItem := _nCt := _nNumHposItem := 0
LOCAL _cFileLog, _cPath := ""

If !File(_cArquivo)
	MSGBOX("Arquivo de importacao nao encontrado","","ERRO")
	Return NIL
EndIF



//{Campo, Tipo, Col.Ini,	Tamanho,Dec, Importa ou nao } //	Descricao do Produto

AADD( _aDadCab, { "N1_FILIAL", 	"C", 	   1,	 2, 0,.t.  } ) //	Filial do Sistema
AADD( _aDadCab, { "N1_CBASE", 	"C", 	   3,	10, 0,.t.  } ) //	C¥digo Base do Bem
AADD( _aDadCab, { "N1_ITEM", 	"C", 	  13,	 4, 0,.t.  } ) //	Numero do Item
AADD( _aDadCab, { "N1_AQUISIC", "D", 	  17,	 8, 0,.t.  } ) //	Data de Aquisi¦§o
AADD( _aDadCab, { "N1_DESCRIC", "C", 	  25,	40, 0,.t.  } ) //	Descri¦§o Sint+tica
AADD( _aDadCab, { "N1_QUANTD", 	"N", 	  65,	 9,	3,.t.  } ) //	Quantidade do Bem
AADD( _aDadCab, { "N1_BAIXA", 	"D", 	  74,	 8, 0,.t.  } ) //	Data da Baixa
AADD( _aDadCab, { "N1_CHAPA", 	"C", 	   3,	10, 0,.t.  } ) //	Numero da Plaqueta
AADD( _aDadCab, { "N1_GRUPO", 	"C", 	  88,	 4, 0,.t.  } ) //	Grupo do Bem
AADD( _aDadCab, { "N1_CSEGURO", "C", 	  92,	25, 0,.t.  } ) //	Cia. de Seguro
AADD( _aDadCab, { "N1_APOLICE", "C", 	 117,	15, 0,.t.  } ) //	Numero da Ap¥lice
AADD( _aDadCab, { "N1_DTVENC", 	"D", 	 132,	 8, 0,.t.  } ) //	Vencimento do Seguro
AADD( _aDadCab, { "N1_TIPOSEG",	"C", 	 140,	 5, 0,.t.  } ) //	Tipo de Seguro
AADD( _aDadCab, { "N1_FORNEC",	"C", 	 145,	 6, 0,.t.  } ) //	C¥digo do Fornecedor
AADD( _aDadCab, { "N1_LOJA", 	"C", 	 151,	 2, 0,.t.  } ) //	Loja do Fornecedor
AADD( _aDadCab, { "N1_LOCAL", 	"C", 	 153,	 6, 0,.t.  } ) //	Endereco
AADD( _aDadCab, { "N1_NSERIE", 	"C", 	 159,	 3, 0,.t.  } ) //	S+rie da Nota Fiscal
AADD( _aDadCab, { "N1_NFISCAL", "C", 	 162,	 6, 0,.t.  } ) //	Numero da Nota Fiscal
AADD( _aDadCab, { "N1_PROJETO", "C", 	 168,	10, 0,.t.  } ) //	C¥digo do Projeto
AADD( _aDadCab, { "N1_CHASSIS", "C", 	 178,	20, 0,.t.  } ) //	Numero Chassis Veiculo
AADD( _aDadCab, { "N1_PLACA", 	"C", 	 198,	 7, 0,.t.  } ) //	Placa do Veiculo
AADD( _aDadCab, { "N1_STATUS", 	"C", 	 205,	 1, 0,.t.  } ) //	Status Atual do Bem
AADD( _aDadCab, { "N1_PATRIM", 	"C", 	 206,	 1, 0,.t.  } ) //	Classificacao
AADD( _aDadCab, { "N1_CODCIAP", "C", 	 207,	 6, 0,.t.  } ) //	Codigo CIAP
AADD( _aDadCab, { "N1_ICMSAPR", "N", 	 213,	18,	2,.t.  } ) //	Icms do Item
AADD( _aDadCab, { "N1_DTBLOQ", 	"D", 	 231,	 8, 0,.t.  } ) //	Data para bloqueio
AADD( _aDadCab, { "N1_CODBEM", 	"C", 	 239,	16, 0,.t.  } ) //	Codigo do Bem no SIGAMNT
AADD( _aDadCab, { "N1_BASESUP", "C", 	 255,	10, 0,.t.  } ) //	Codigo Base Superior
AADD( _aDadCab, { "N1_ITEMSUP", "C", 	 265,	 4, 0,.t.  } ) //	Item Superior
// Total			268

AADD( _aDadItens, { "N3_FILIAL",	"C",	   1,	 2, 0,.t.  } ) //	Filial do Sistema
AADD( _aDadItens, { "N3_CBASE", 	"C",	   3,	10, 0,.t.  } ) //	Codigo Base do Bem
AADD( _aDadItens, { "N3_ITEM", 	    "C",	  13,	 4, 0,.t.  } ) //	Codigo do Item do Bem
AADD( _aDadItens, { "N3_TIPO", 	    "C",	 269,	 2, 0,.t.  } ) //	Tipo do Ativo
AADD( _aDadItens, { "N3_BAIXA", 	"C",	 271,	 1, 0,.t.  } ) //	Ocorrencia da Baixa
AADD( _aDadItens, { "N3_HISTOR", 	"C",	 272,	40, 0,.t.  } ) //	Historico do Valor
AADD( _aDadItens, { "N3_CCONTAB", 	"C",	 312,	20, 0,.t.  } ) //	Conta Contabil
AADD( _aDadItens, { "N3_CUSTBEM", 	"C",  	 332,	 9, 0,.t.  } ) //	C Custo da Conta do Bem
AADD( _aDadItens, { "N3_CDEPREC", 	"C",  	 341,	20, 0,.t.  } ) //	Conta Despesa Depreciacao
AADD( _aDadItens, { "N3_CCUSTO", 	"C",	 361,	 9, 0,.t.  } ) //	Centro de Custo Despesa
AADD( _aDadItens, { "N3_CCDEPR", 	"C",	 370,	20, 0,.t.  } ) //	Conta Deprec. Acumulada
AADD( _aDadItens, { "N3_CDESP", 	"C", 	 390,	20, 0,.t.  } ) //	Cta Correcao Depreciacao
AADD( _aDadItens, { "N3_CCORREC", 	"C", 	 410,	20, 0,.t.  } ) //	Conta Correcao Bem
AADD( _aDadItens, { "N3_NLANCTO",	"C", 	 430,	 9, 0,.t.  } ) //	Num Lancto Contabil
AADD( _aDadItens, { "N3_DLANCTO", 	"D", 	 439,	 8, 0,.t.  } ) //	Data lancamento
AADD( _aDadItens, { "N3_DINDEPR", 	"D", 	 447,	 8, 0,.t.  } ) //	Data Inicio depreciacao
AADD( _aDadItens, { "N3_DEXAUST", 	"D", 	 455,	 8, 0,.t.  } ) //	Data Exaustao do Bem
AADD( _aDadItens, { "N3_VORIG1", 	"N", 	 463,	16,	2,.t.  } ) //	Valor Original Moeda 1
AADD( _aDadItens, { "N3_TXDEPR1", 	"N", 	 479,	 8,	4,.t.  } ) //	Taxa Anual Deprecia¦§o 1
AADD( _aDadItens, { "N3_VORIG2", 	"N", 	 487,	16,	4,.t.  } ) //	Valor Original Moeda 2
AADD( _aDadItens, { "N3_TXDEPR2", 	"N", 	 503,	 8,	4,.t.  } ) //	Taxa Anual Deprecia¦§o 2
AADD( _aDadItens, { "N3_VORIG3", 	"N", 	 511,	16,	4,.t.  } ) //	Valor Original Moeda 3
AADD( _aDadItens, { "N3_TXDEPR3", 	"N", 	 527,	 8,	4,.t.  } ) //	Taxa Anual Deprecia¦§o 3
AADD( _aDadItens, { "N3_VORIG4", 	"N", 	 535,	16,	4,.t.  } ) //	Valor Original Moeda 4
AADD( _aDadItens, { "N3_TXDEPR4", 	"N", 	 551,	 8,	4,.t.  } ) //	Taxa Anual Deprecia¦§o 4
AADD( _aDadItens, { "N3_VORIG5", 	"N", 	 559,	16,	4,.t.  } ) //	Valor Original Moeda 5
AADD( _aDadItens, { "N3_TXDEPR5", 	"N", 	 575,	 8,	4,.t.  } ) //	Taxa Anual Deprecia¦§o 5
AADD( _aDadItens, { "N3_VRCBAL1", 	"N", 	 583,	16,	2,.t.  } ) //	Correcao Balanco Moeda 1
AADD( _aDadItens, { "N3_VRDBAL1", 	"N", 	 599,	16,	2,.t.  } ) //	Deprecia Balanco Moeda 1
AADD( _aDadItens, { "N3_VRCMES1", 	"N", 	 615,	16,	2,.t.  } ) //	Correcao no Mes Moeda 1
AADD( _aDadItens, { "N3_VRDMES1", 	"N", 	 631,	16,	2,.t.  } ) //	Valor Depr. Mes Moeda 1
AADD( _aDadItens, { "N3_VRCACM1", 	"N", 	 647,	16,	2,.t.  } ) //	Correcao Acumulada Moeda1
AADD( _aDadItens, { "N3_VRDACM1", 	"N", 	 663,	16,	2,.t.  } ) //	Deprecia Acumulada Moeda1
AADD( _aDadItens, { "N3_VRDBAL2", 	"N", 	 679,	16,	4,.t.  } ) //	Depreciac Balanco Moeda 2
AADD( _aDadItens, { "N3_VRDMES2", 	"N", 	 695,	16,	4,.t.  } ) //	Deprecia Mes Moeda 2
AADD( _aDadItens, { "N3_VRDACM2", 	"N", 	 711,	16,	4,.t.  } ) //	Deprecia Acumulada Moeda2
AADD( _aDadItens, { "N3_VRDBAL3", 	"N", 	 727,	16,	4,.t.  } ) //	Depreciac Balanco Moeda 3
AADD( _aDadItens, { "N3_VRDMES3", 	"N", 	 743,	16,	4,.t.  } ) //	Deprecia Mes Moeda 3
AADD( _aDadItens, { "N3_VRDACM3", 	"N", 	 759,	16,	4,.t.  } ) //	Deprecia Acumulada Moeda3
AADD( _aDadItens, { "N3_VRDBAL4", 	"N", 	 775,	16,	4,.t.  } ) //	Depreciac Balanco Moeda 4
AADD( _aDadItens, { "N3_VRDMES4", 	"N", 	 791,	16,	4,.t.  } ) //	Deprecia Mes Moeda 4
AADD( _aDadItens, { "N3_VRDACM4", 	"N", 	 807,	16,	4,.t.  } ) //	Deprecia Acumulada Moeda4
AADD( _aDadItens, { "N3_VRDBAL5", 	"N", 	 823,	16,	4,.t.  } ) //	Depreciac Balanco Moeda 5
AADD( _aDadItens, { "N3_VRDMES5", 	"N", 	 839,	16,	4,.t.  } ) //	Deprecia Mes Moeda 5
AADD( _aDadItens, { "N3_VRDACM5", 	"N", 	 855,	16,	4,.t.  } ) //	Deprecia Acumulada Moeda5
AADD( _aDadItens, { "N3_INDICE1", 	"N", 	 871,	 8,	4,.t.  } ) //	Indice de Deprecia¦§o 1
AADD( _aDadItens, { "N3_INDICE2", 	"N", 	 879,	 8,	4,.t.  } ) //	Indice de Deprecia¦§o 2
AADD( _aDadItens, { "N3_INDICE3", 	"N", 	 887,	 8,	4,.t.  } ) //	Indice de Deprecia¦§o 3
AADD( _aDadItens, { "N3_INDICE4", 	"N", 	 895,	 8,	4,.t.  } ) //	Indice de Deprecia¦§o 4
AADD( _aDadItens, { "N3_INDICE5", 	"N", 	 903,	 8,	4,.t.  } ) //	Indice de Deprecia¦§o 5
AADD( _aDadItens, { "N3_DTBAIXA", 	"D", 	 911,	 8, 0,.t.  } ) //	Data da Baixa do Bem
AADD( _aDadItens, { "N3_VRCDM1", 	"N", 	 919,	14,	2,.t.  } ) //	Corr. Depr. no Mes
AADD( _aDadItens, { "N3_VRCDB1", 	"N", 	 933,	14,	2,.t.  } ) //	Corr Depr Acum no Exerc.
AADD( _aDadItens, { "N3_VRCDA1", 	"N", 	 947,	14,	2,.t.  } ) //	Corr Depr Acumulada
AADD( _aDadItens, { "N3_AQUISIC", 	"D", 	 961,	 8, 0,.t.  } ) //	Data Aquisicao Original
AADD( _aDadItens, { "N3_DEPREC", 	"C", 	 969,	40, 0,.t.  } ) //	Taxa Variavel de Deprec.
AADD( _aDadItens, { "N3_OK", 		"C", 	1009,	 2, 0,.t.  } ) //	Flag Marcacao da Baixa
AADD( _aDadItens, { "N3_SEQ", 		"C", 	1011,	 3, 0,.t.  } ) //	Sequencia de aquisicao
AADD( _aDadItens, { "N3_FIMDEPR", 	"D", 	1014, 	 8, 0,.t.  } ) //	Data fim da depreciacao
AADD( _aDadItens, { "N3_CCDESP", 	"C", 	1022,	 9, 0,.t.  } ) //	Centro Custo Desp Depr.
AADD( _aDadItens, { "N3_CCCDEP", 	"C", 	1031,	 9, 0,.t.  } ) //	Centro Custo Dep. Acumul.
AADD( _aDadItens, { "N3_CCCDES", 	"C", 	1040,	 9, 0,.t.  } ) //	Centro Custo Corr. Depr.
AADD( _aDadItens, { "N3_CCCORR", 	"C", 	1049,	 9, 0,.t.  } ) //	Centro Custo Corr. Monet.
AADD( _aDadItens, { "N3_SUBCTA", 	"C", 	1058,	 9, 0,.t.  } ) //	Item Despesa
AADD( _aDadItens, { "N3_SUBCCON", 	"C", 	1067,	 9, 0,.t.  } ) //	Item Conta do Bem
AADD( _aDadItens, { "N3_SUBCDEP", 	"C", 	1076,	 9, 0,.t.  } ) //	Item Despesa Depreciacao
AADD( _aDadItens, { "N3_SUBCCDE", 	"C", 	1085,	 9, 0,.t.  } ) //	Item Correcao Depreciacao
AADD( _aDadItens, { "N3_SUBCDES", 	"C", 	1094,	 9, 0,.t.  } ) //	Item Cor.Des. Depreciacao
AADD( _aDadItens, { "N3_SUBCCOR", 	"C", 	1103,	 9, 0,.t.  } ) //	Item Correcao Monetaria
AADD( _aDadItens, { "N3_BXICMS", 	"N", 	1112,	18,	2,.t.  } ) //	Valor do ICMS Baixado
AADD( _aDadItens, { "N3_SEQREAV", 	"C", 	1130,	 2, 0,.t.  } ) //	Sequencia de Reavaliacao
AADD( _aDadItens, { "N3_AMPLIA1", 	"N", 	1132,	14,	2,.t.  } ) //	Vl da Ampliacao na moeda1
AADD( _aDadItens, { "N3_AMPLIA2", 	"N", 	1146,	14,	4,.t.  } ) //	Vl da Ampliacao na moeda2
AADD( _aDadItens, { "N3_AMPLIA3", 	"N", 	1160,	14,	4,.t.  } ) //	Vl da Ampliacao na Moeda3
AADD( _aDadItens, { "N3_AMPLIA4", 	"N", 	1174,	14,	4,.t.  } ) //	Vl da Ampliacao na Moeda4
AADD( _aDadItens, { "N3_AMPLIA5", 	"N", 	1188,	14,	4,.t.  } ) //	Vl da Ampliacao na Moeda5
AADD( _aDadItens, { "N3_CODBAIX", 	"C", 	1202,	 6, 0,.t.  } ) //	Cod lig Aquis por Transf
AADD( _aDadItens, { "N3_FILORIG", 	"C", 	1208,	 2, 0,.t.  } ) //	Filial Origem
AADD( _aDadItens, { "N3_CLVL"   , 	"C", 	1210,	 9, 0,.t.  } ) //	Classe de Valor Despesa
AADD( _aDadItens, { "N3_CLVLCON", 	"C", 	1219,	 9, 0,.t.  } ) //	Classe de Valor do Bem
AADD( _aDadItens, { "N3_CLVLDEP", 	"C", 	1228,	 9, 0,.t.  } ) //	Classe Vlr Despesa Dep.
AADD( _aDadItens, { "N3_CLVLCDE", 	"C", 	1237,	 9, 0,.t.  } ) //	Classe de Vlr Dep. Acum.
AADD( _aDadItens, { "N3_CLVLDES", 	"C", 	1246,    9, 0,.t.  } ) //	Classe de Vlr Cor. Depr.
AADD( _aDadItens, { "N3_CLVLCOR", 	"C", 	1255,	 9, 0,.t.  } ) //	Classe de Vlr Correc Bem
AADD( _aDadItens, { "N3_TPDEPR", 	"C", 	1264,	 1, 0,.t.  } ) //	Tipo de depreciacao
AADD( _aDadItens, { "N3_IDBAIXA", 	"C", 	1265,	 1, 0,.t.  } ) //	Identificac§o da Baixa
AADD( _aDadItens, { "N3_LOCAL", 	"C", 	1266,	 6, 0,.t.  } ) //	Endereco
// Total 1019

AADD( _aDadHist, { "N2_FILIAL",	"C",	   1,	 2, 0,.t.  } ) //	Filial do Sistema
AADD( _aDadHist, { "N2_CBASE", 	"C",	   3,	10, 0,.t.  } ) //	Codigo Base do Bem
AADD( _aDadHist, { "N2_ITEM", 	"C",	  13,	 4, 0,.t.  } ) //	Codigo do Item do Bem
//AADD( _aDadHist, { "N2_SEQUENC",   "C",	 269,	 2, 0,.t.  } ) //	Numero de Sequencia
AADD( _aDadHist, { "N2_HISTOR", 	"C",	1272,	70, 0,.t.  } ) //	Historico
//AADD( _aDadHist, { "N2_TIPO",   	"C",	 271,	 1, 0,.t.  } ) //	Tipo de Ativo
//AADD( _aDadHist, { "N2_SEQ",   	"C",	 271,	 1, 0,.t.  } ) //	Sequencia de Aquisicao


_nNumCposCab  := LEN(_aDadCab)

_nNumCposItem := LEN(_aDadItens)
                                
_nNumHposItem := LEN(_aDadHist)

AutoGrLog("INICIANDO O LOG - IMPORTACAO PRODUTOS")
AutoGrLog("-------------------------------------")
AutoGrLog("ARQUIVO............: "+_cArquivo)
AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
AutoGrLog("DATA...............: "+Dtoc(MsDate()))
AutoGrLog("HORA...............: "+Time())
AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
AutoGrLog("VERSÃO.............: "+GetVersao())
AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
AutoGrLog("USUÁRIO............: "+SubStr(cUsuario,7,15))


FT_FUSE(_cArquivo)
FT_FGOTOP()
ProcRegua(FT_FLASTREC())
_cBuffer := FT_FREADLN()


While !FT_FEOF()
	_nCt++
	
	IncProc("Processando ...")
	
	_aVetCab := {}
	
	For i:=1 to _nNumCposCab
		
		If _aDadCab[i][6]
			_xDado := SUBS(_cBuffer, _aDadCab[i][3],_aDadCab[i][4])
			
			If     _aDadCab[i][2] == "C"
				
				_xDado := ALLTRIM(_xDado)
				
			ElseIf _aDadCab[i][2] == "N"
				
				_xDado := VAL(_xDado) / (10 ^_aDadCab[i][5])
				
			ElseIf _aDadCab[i][2] == "D"
				
				_xDado := CTOD(SUBS(_xDado,1,2)+"/"+SUBS(_xDado,3,2)+"/"+SUBS(_xDado,7,2))
				
			EndIf
			
			AADD(_aVetCab, {_aDadCab[i][1], _xDado, NIL} )
			
		EndIf
		
	Next
	
	_cBemAnt := SUBS(_cBuffer, 1, 16)
	
	//	While !FT_FEOF() .and. _cBemAnt == SUBS(_cBuffer, 1, 16)
	
	_aVetCpos := {}
	_aVetItens:= {}
	_aVetHpos := {}
	
	For i:=1 to _nNumCposItem
			
		
		If _aDadItens[i][6]
			_xDado := SUBS(_cBuffer, _aDadItens[i][3],_aDadItens[i][4])
			
			If     _aDadItens[i][2] == "C"
				
				_xDado := ALLTRIM(_xDado)
				
			ElseIf _aDadItens[i][2] == "N"
				
				_xDado := VAL(_xDado) / (10 ^_aDadItens[i][5])
				
			ElseIf _aDadItens[i][2] == "D"
				
				_xDado := CTOD(SUBS(_xDado,1,2)+"/"+SUBS(_xDado,3,2)+"/"+SUBS(_xDado,7,2))
				
			EndIf
			
			AADD(_aVetCpos, {_aDadItens[i][1], _xDado, NIL} )
	
		EndIf
		
	Next


	For i:=1 to _nNumHposItem
			
		
		If _aDadHist[i][6]
			_xDado := SUBS(_cBuffer, _aDadHist[i][3],_aDadHist[i][4])
			
			If     _aDadHist[i][2] == "C"
				
				_xDado := ALLTRIM(_xDado)
				
			ElseIf _aDadHist[i][2] == "N"
				
				_xDado := VAL(_xDado) / (10 ^_aDadHist[i][5])
				
			ElseIf _aDadHist[i][2] == "D"
				
				_xDado := CTOD(SUBS(_xDado,1,2)+"/"+SUBS(_xDado,3,2)+"/"+SUBS(_xDado,7,2))
				
			EndIf
			if i == 4                                                     
			   AADD(_aVetHpos, {"N2_SEQUENC", "01", NIL} )
               AADD(_aVetHpos, {_aDadHist[i][1], subs(_xDado,1,40), NIL} ) 			
   			   AADD(_aVetHpos, {"N2_TIPO", "01", NIL} )               
               AADD(_aVetHpos, {"N2_SEQ", "001", NIL} )    			   
               
			else				
    		   AADD(_aVetHpos, {_aDadHist[i][1], _xDado, NIL} )
            EndIf
	
		EndIf
		
	Next

	
	AADD(_aVetItens,_aVetCpos,_aVetHpos) 
                                           

    //AADD(_aVetItens,_aVetCpos)

	//	EndDo
	
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| AtfA010(x,y,z)}, _aVetCab, _aVetItens, 3)
	
	If lMsErroAuto
		AutoGrLog(Str(_nCt,5)+" "+SUBS(_cBuffer, 1,50 )+" Nao gerado ")
		AutoGrLog(REPLICATE("=",50))
		DisarmTransaction()
	Endif
	
	FT_FSKIP()
	
	_cBuffer := FT_FREADLN()
	
EndDo

_cFileLog := "ATF.LOG" //NomeAutoLog()

If _cFileLog <> ""
	MostraErro(_cPath, _cFileLog)
Endif

FT_FUSE()
MsgInfo("Processo finalizado")
Return

Static Function SelArq()
Private _cExtens   := "Arquivo Texto (*.TXT) |*.TXT|"
_cRet := cGetFile(_cExtens,"Selecione o Arquivo",,,.F.,GETF_NETWORKDRIVE+GETF_LOCALFLOPPY+GETF_LOCALHARD)
_cRet := ALLTRIM(_cRet)
Return _cRet   
//