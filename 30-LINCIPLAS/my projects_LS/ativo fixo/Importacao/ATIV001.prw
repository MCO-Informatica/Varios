#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ATIV001  º Autor ³Robson Mazzarotto   º Data ³  27/02/07   º±±
±±º          ³          º        Ricardo Felipelli   º Data ³  20/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de catalogo do Ativo                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                   

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ATIV001()
Local _Opcao := .f.

If MsgYesNO("Confirma Processamento?","Importação Ativo")
	Processa({|| ImpAtiv()},"Importando Ativo...")
	MsgStop("Importação Finalizada!!!")
	
EndIf

Return

Static Function ImpAtiv()
Local aATFA010 := {}
Local aItens   := {}
Local aLinha   := {}
Local _arquivo := "e:\DBF_CUST.dtc"
Local _arquivo2:= "\system\PRO_SN3.dtc"
Local _Grava   := 0
Local _proce   := 0
Local _Estru   := {}
Local _Estru2  := {}
Local _cCbase  := ""
Local _cItem   := ""
Local _cChapa  := ""
Local _nItem   := 0
Local _cItem2  := 0          
Local aArea    := GetArea()
Local aAreaSN1 := SN1->( GetArea() )
Local aAreaSN3 := SN3->( GetArea() )


If !File("PRO_SN1.DTC")
	MsgStop("Atencao. O arquivo PRO_SN1 nao foi encontrado. Verifique !!!")
	Return
Endif

DBUseArea( .T.,,"PRO_SN1", "TMPSN1", .F., .F. )

If !File("PRO_SN3.DTC")
	MsgStop("Atencao. O arquivo PRO_SN3 nao foi encontrado. Verifique !!!")
	Return
Endif

DBUseArea( .T.,,"PRO_SN3", "TMPSN3", .F., .F. )


//rf
// SN1 - CADASTRO DE ATIVO IMOBILIZADO
// SN2 - DESCRICOES ESTENDIDAS
// SN3 - CADASTRO DE SALDOS E VALORES

// tabela do centro de custo
cArqSF2:="\spool\Felipelli\CUSTO_31"
dbUseArea(.T.,,"CUSTO_31","CCUST",.F.,.F.)
cChave:="CCPROGET"
IndRegua("CCUST",cArqSF2,cChave,,,"Selecionando Registros...")
dbSelectArea("CCUST")
dbGoTop()



AaDd(_Estru,{"FILIAL", 	  "C", 02, 0})
AaDd(_Estru,{"CBASE", 	  "C", 10, 0})
AaDd(_Estru,{"ITEM", 	  "C", 04, 0})
AaDd(_Estru,{"AQUISIC",	  "D", 08, 0})
AaDd(_Estru,{"QUANTD",    "N", 09, 3})
AaDd(_Estru,{"BAIXA", 	  "D", 08, 0})
AaDd(_Estru,{"CHAPA", 	  "C", 06, 0})
AaDd(_Estru,{"GRUPO", 	  "C", 04, 0})
AaDd(_Estru,{"CSEGURO",	  "C", 25, 0})
AaDd(_Estru,{"APOLICE",	  "C", 15, 0})
AaDd(_Estru,{"DTVENC", 	  "D", 08, 0})
AaDd(_Estru,{"TIPOSEG",	  "C", 05, 0})
AaDd(_Estru,{"FORNEC",    "C", 06, 0})
AaDd(_Estru,{"LOJA",      "C", 02, 0})
AaDd(_Estru,{"LOCA",      "C", 06, 0})
AaDd(_Estru,{"SERIE" , 	  "C", 03, 0})
AaDd(_Estru,{"NFISCAL",	  "C", 06, 0})
AaDd(_Estru,{"DESCRIC",   "C", 40, 0})
AaDd(_Estru,{"PROJETO",	  "C", 10, 0})
AaDd(_Estru,{"PATRIM", 	  "C", 01, 0})
AaDd(_Estru,{"CODCIAP",	  "C", 06, 0})
AaDd(_Estru,{"ICMSAPR",	  "N", 18, 2})
AaDd(_Estru,{"DTBLOQ", 	  "D", 08, 0})
AaDd(_Estru,{"CODBEM", 	  "C", 06, 0})
AaDd(_Estru,{"BASESUP",	  "C", 10, 0})
//AaDd(_Estru,{"ITEMSUP",	"C", 04, 0})
AaDd(_Estru,{"CALCPIS",	  "C", 01, 0})
AaDd(_Estru,{"PENHORA",   "C", 01, 0})
AaDd(_Estru,{"FILIALANT", "C", 02, 0})

_cArqBlq := CriaTrab(_Estru, .t.)
dbUseArea(.T.,, _cArqBlq,"TRB", .T. , .F. )
//IndRegua ( "TRB",_cArqBlq,"FILIAL",,,"Selecionando Registros...")
IndRegua ( "TRB",_cArqBlq,"FILIAL+CBASE",,,"Selecionando Registros...")


//DbSelectArea("TRB")
//Append from PROSN1.DTC

DbSelectArea("TMPSN1")
TMPSN1->( DbGoTop() )
While TMPSN1->( !Eof() )     
                           
	//de para dos grupos 
	_grupo := '9999'
	if alltrim(TMPSN1->N1_GRUPO) == '100'  // TERRENOS	
		_grupo := '0001'
	elseif alltrim(TMPSN1->N1_GRUPO) == '101'  // ANTENA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '102'  // APAR LUZ EMERG	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '103'  // APAR TELEF CEL	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '104'  // AR COND	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '105'  // ARMARIO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '106'  // ARQUIVO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '107'  // ASPIRADOR PO	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '108'  // BACKLIGHT	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '109'  // BALANCA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '110'  // BALCAO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '111'  // BANCADA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '112'  // BANCO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '113'  // BEBEDOURO	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '114'  // CADEIRA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '115'  // CAFETEIRA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '116'  // CALCULADORA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '117'  // CARRINHO	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '118'  // CENTRAL TELEFONICA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '119'  // CHECK OUT	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '120'  // COFRE	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '121'  // COLETOR DE DADOS	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '122'  // CONSULTOR PRECOS	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '123'  // COPIADORA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '124'  // CORTINA	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '125'  // DISPLAY	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '126'  // EMBALADORA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '127'  // ESPELHO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '128'  // ESTACAO TRABALHO	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '129'  // ESTABILIZADOR TENSAO	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '130'  // ESTANTE	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '131'  // ETIQUETADOR	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '132'  // EXPOSITOR	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '133'  // FACSIMILE	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '134'  // FRAGMENTADORA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '135'  // FREEZER	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '136'  // GABINETE	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '137'  // GAVETA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '138'  // GAVETEIRO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '139'  // GONDOLA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '140'  // HUB	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '141'  // IMPRESSORA	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '142'  // INSTAL GERAIS	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '143'  // LEITOR CARTOES	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '144'  // MAQ ESCREVER	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '145'  // MARMITEIRO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '146'  // MICRO	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '147'  // MODEM	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '148'  // MODULO MADEIRA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '149'  // MODULO PDV	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '150'  // MODULO QUIOSQUE	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '151'  // MONITOR	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '152'  // MOVEL ESTOQUE	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '153'  // NO BREAK	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '154'  // PAINEL CANALETADO	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '155'  // PAINEL MADEIRA	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '156'  // PATCH PANEL	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '157'  // PINPAD	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '158'  // POLTRONA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '159'  // PORTA METALICA	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '160'  // PRATELEIRA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '161'  // RACK	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '162'  // RECEIVER ANTENA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '163'  // REFRIGERADOR	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '164'  // RETROPROJETOR	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '165'  // ROTEADOR	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '166'  // SCANNER	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '167'  // SECRET ELETRONICA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '168'  // SELADORA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '169'  // SERVIDOR	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '170'  // SINTONIZADOR	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '171'  // SOFA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '172'  // SUPORTE	
		_grupo := '0008'
	elseif alltrim(TMPSN1->N1_GRUPO) == '173'  // SWITCH	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '174'  // TELEVISOR	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '175'  // TERMINAL CONSULTA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '176'  // TOLDO	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '177'  // TORRE	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '178'  // TOTEM	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '179'  // VAPORIZADOR	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '180'  // VENTILADOR	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '181'  // VERelseifICADOR PRECOS	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '182'  // VIDEO CASSETE	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '183'  // VITRINE	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '184'  // DESATIVADOR	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '185'  // BANQUETA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '186'  // CARRO PLATAFORMA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '187'  // CARRO PORTA PALLETS	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '188'  // MESA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '189'  // EDIFÍCIOS	
		_grupo := '0002'
	elseif alltrim(TMPSN1->N1_GRUPO) == '190'  // RECEIVER	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '191'  // CD PLAYER	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '192'  // CAIXAS ACÚSTICAS	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '193'  // CHAVEADOR	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '194'  // TELA LCD	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '195'  // REFORMAS	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '196'  // APAR.TELEFONE	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '197'  // CARPETE/PISO	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '198'  // TECLADO P/ COMPUTADOR	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '199'  // MOUSE OPTICO	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '200'  // SOFTWARE	
		_grupo := '0008'
	elseif alltrim(TMPSN1->N1_GRUPO) == '201'  // RELÓGIO PROTOCOLADOR	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '202'  // MIDIA DIGITAL	
		_grupo := '0008'
	elseif alltrim(TMPSN1->N1_GRUPO) == '203'  // TELA RETRATIL	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '204'  // CABO 	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '205'  // VEICULOS	
		_grupo := '0005'
	elseif alltrim(TMPSN1->N1_GRUPO) == '206'  // PONTO COMERCIAL	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '207'  // MARCAS E PATENTES	
		_grupo := '0009'
	elseif alltrim(TMPSN1->N1_GRUPO) == '208'  // RECUP.DE ICMS	
		_grupo := '9999'
	elseif alltrim(TMPSN1->N1_GRUPO) == '209'  // CIRCUITO INTERNO DE VIDEO	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '210'  // ABAJUR	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '211'  // CHAPA 	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '212'  // SERVIÇOS	
		_grupo := '9999'
	elseif alltrim(TMPSN1->N1_GRUPO) == '213'  // UTENSILIOS	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '214'  // PEG BOARDS	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '215'  // ESCADA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '216'  // APAR. FAX	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '217'  // PORTA LIVRO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '218'  // FONTE	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '219'  // MÁQUINA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '220'  // TAMPA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '221'  // BATERIA	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '222'  // CARREGADOR	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '223'  // CONVERSOR	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '224'  // CHAPÉU	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '225'  // PORTA SACOLAS	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '226'  // TRANSPALETE	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '227'  // REFRESQUEIRA	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '228'  // MICROONDAS	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '229'  // SINALIZADOR	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '230'  // PLACAS	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '231'  // MOTOR	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '232'  // TAPETE	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '233'  // DVD PLAYER	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '234'  // P.O.S	
		_grupo := '0006'
	elseif alltrim(TMPSN1->N1_GRUPO) == '235'  // CAPAS PARA QUIOSQUE	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '236'  // NICHO FACHADA	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '237'  // NICHO INTERNO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '238'  // BASE	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '239'  // FECHAMENTO EM MADEIRA	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '240'  // HAND HELD	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '241'  // BALEIRO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '242'  // ROUPEIRO	
		_grupo := '0004'
	elseif alltrim(TMPSN1->N1_GRUPO) == '243'  // CORREDIÇAS	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '244'  // ARREMATES DE MADEIRA	
		_grupo := '0003'
	elseif alltrim(TMPSN1->N1_GRUPO) == '245'  // UNIDADE DE FITA PARA BACKUP	
		_grupo := '0008'
	elseif alltrim(TMPSN1->N1_GRUPO) == '246'  // MODULO DE MEMORIA	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '247'  // DISCO RIGIDO	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '248'  // PLACA CONTROLADORA	
		_grupo := '0007'
	elseif alltrim(TMPSN1->N1_GRUPO) == '249'  // PROCESSADORA DE CHEQUES C/ TECLADO	
		_grupo := '0006'         
	endif
	
    
	_ccontabil := ''
	If TMPSN1->N1_FILIAL == xFilial("SN1")
		
		RecLock("TRB",.T.)
		
		TRB->FILIAL		:= TMPSN1->N1_FILIAL
		TRB->CBASE		:= TMPSN1->N1_CBASE
		TRB->ITEM		:= TMPSN1->N1_ITEM
		TRB->AQUISIC	:= TMPSN1->N1_AQUISIC 
		if TMPSN1->N1_QUANTD == 0
			TRB->QUANTD		:= 1
		else
			TRB->QUANTD		:= TMPSN1->N1_QUANTD
		endif
		TRB->BAIXA		:= TMPSN1->N1_BAIXA
		TRB->CHAPA 		:= TMPSN1->N1_CHAPA
		TRB->GRUPO		:= 	_grupo   // TMPSN1->N1_GRUPO
		TRB->LOCA		:= TMPSN1->N1_LOCAL
		TRB->DESCRIC	:= TMPSN1->N1_DESCRIC
		TRB->PATRIM		:= TMPSN1->N1_PATRIM
		
		MsUnLock()
		
	EndIf
	
	TMPSN1->( DbSkip() )
	
EndDo

AaDd(_Estru2,{"FILIAL", 	"C", 02, 0})
AaDd(_Estru2,{"CBASE", 		"C", 10, 0})
AaDd(_Estru2,{"ITEM", 		"C", 04, 0})
AaDd(_Estru2,{"TIPO", 		"C", 02, 0})
AaDd(_Estru2,{"BAIXA", 		"C", 01, 0})
AaDd(_Estru2,{"HISTOR",		"C", 40, 0})
AaDd(_Estru2,{"CCONTAB",    "C", 20, 0})
AaDd(_Estru2,{"CCUSTO", 	"C", 09, 0})
AaDd(_Estru2,{"CUSTBEM", 	"C", 09, 0})
AaDd(_Estru2,{"CCORREC",	"C", 20, 0})
AaDd(_Estru2,{"CDEPREC",	"C", 20, 0})
AaDd(_Estru2,{"CDESP", 		"C", 20, 0})
AaDd(_Estru2,{"CCDEPR",		"C", 20, 0})
AaDd(_Estru2,{"NLANCTO",    "C", 09, 0})
AaDd(_Estru2,{"DLANCTO",    "D", 08, 0})
AaDd(_Estru2,{"DINDEPR" , 	"D", 08, 0})
AaDd(_Estru2,{"DEXAUST",	"D", 08, 0})
AaDd(_Estru2,{"VORIG1",	    "N", 14, 2})
AaDd(_Estru2,{"VORIG2",	    "N", 14, 4})
AaDd(_Estru2,{"VORIG3",	    "N", 14, 4})
AaDd(_Estru2,{"VORIG4",	    "N", 14, 4})
AaDd(_Estru2,{"VORIG5",	    "N", 14, 4})
AaDd(_Estru2,{"VRCBAL1",	"N", 14, 2})
AaDd(_Estru2,{"VRDBAL1",	"N", 14, 2})
AaDd(_Estru2,{"VRCMES1", 	"N", 14, 2})
AaDd(_Estru2,{"VRDMES1", 	"N", 14, 2})
AaDd(_Estru2,{"VRCACM1", 	"N", 14, 2})
AaDd(_Estru2,{"VRDACM1", 	"N", 14, 2})
AaDd(_Estru2,{"VRDBAL2", 	"N", 14, 4})
AaDd(_Estru2,{"VRDMES2", 	"N", 14, 4})
AaDd(_Estru2,{"VRDACM2", 	"N", 14, 4})
AaDd(_Estru2,{"VRDBAL3", 	"N", 14, 4})
AaDd(_Estru2,{"VRDMES3", 	"N", 14, 4})
AaDd(_Estru2,{"VRDACM3", 	"N", 14, 4})
AaDd(_Estru2,{"VRDBAL4", 	"N", 14, 4})
AaDd(_Estru2,{"VRDMES4", 	"N", 14, 4})
AaDd(_Estru2,{"VRDACM4", 	"N", 14, 4})
AaDd(_Estru2,{"VRDBAL5", 	"N", 14, 4})
AaDd(_Estru2,{"VRDMES5", 	"N", 14, 4})
AaDd(_Estru2,{"VRDACM5", 	"N", 14, 4})
AaDd(_Estru2,{"TXDEPR1",	"N", 07, 4})
AaDd(_Estru2,{"TXDEPR2",	"N", 07, 4})
AaDd(_Estru2,{"TXDEPR3",	"N", 07, 4})
AaDd(_Estru2,{"TXDEPR4",	"N", 07, 4})
AaDd(_Estru2,{"TXDEPR5",	"N", 07, 4})
AaDd(_Estru2,{"INDICE1",	"N", 07, 4})
AaDd(_Estru2,{"INDICE2",	"N", 08, 4})
AaDd(_Estru2,{"INDICE3",	"N", 07, 4})
AaDd(_Estru2,{"INDICE4",	"N", 07, 4})
AaDd(_Estru2,{"INDICE5",	"N", 07, 4})
AaDd(_Estru2,{"DTBAIXA",	"D", 08, 0})
AaDd(_Estru2,{"AQUISIC", 	"D", 08, 0})
AaDd(_Estru2,{"DEPREC",		"C", 40, 0})
AaDd(_Estru2,{"OK",			"C", 02, 0})
AaDd(_Estru2,{"FIMDEPR",	"D", 08, 0})
AaDd(_Estru2,{"SUBCCON",	"C", 09, 0})
AaDd(_Estru2,{"SUBCCOR",	"C", 09, 0})
AaDd(_Estru2,{"SUBCDEP",	"C", 09, 0})
AaDd(_Estru2,{"SUBCDES",	"C", 09, 0})
AaDd(_Estru2,{"SUBCCDE",	"C", 09, 0})
AaDd(_Estru2,{"BXICMS",		"N", 18, 2})
AaDd(_Estru2,{"SEQREAV",	"C", 02, 0})
AaDd(_Estru2,{"AMPLIA1",	"N", 14, 2})
AaDd(_Estru2,{"AMPLIA2",	"N", 14, 4})
AaDd(_Estru2,{"AMPLIA3",	"N", 14, 4})
AaDd(_Estru2,{"AMPLIA4",	"N", 14, 4})
AaDd(_Estru2,{"AMPLIA5",	"N", 14, 4})
AaDd(_Estru2,{"CODBAIX",	"C", 06, 0})
AaDd(_Estru2,{"SEQ",		"C", 03, 0})
AaDd(_Estru2,{"VRCDA1",		"N", 14, 2})
AaDd(_Estru2,{"VRCDB1",		"N", 14, 2})
AaDd(_Estru2,{"VRCDM1",		"N", 14, 2})
AaDd(_Estru2,{"FILORIG",	"C", 02, 0})
AaDd(_Estru2,{"CLVLCON",	"C", 09, 0})
AaDd(_Estru2,{"CLVLCOR",	"C", 09, 0})
AaDd(_Estru2,{"CLVLDEP",	"C", 09, 0})
AaDd(_Estru2,{"CLVLDES",	"C", 09, 0})
AaDd(_Estru2,{"CLVLCDE",	"C", 09, 0})
AaDd(_Estru2,{"TPDEPR",		"C", 01, 0})
AaDd(_Estru2,{"CCDESP",		"C", 09, 0})
AaDd(_Estru2,{"CCCDEP",		"C", 09, 0})
AaDd(_Estru2,{"CCCDES",		"C", 09, 0})
AaDd(_Estru2,{"CCCORR",		"C", 09, 0})
AaDd(_Estru2,{"SUBCTA",		"C", 09, 0})
AaDd(_Estru2,{"CLVL",		"C", 09, 0})
AaDd(_Estru2,{"IDBAIXA",	"C", 01, 0})
AaDd(_Estru2,{"LOCAL",		"C", 06, 0})
AaDd(_Estru2,{"FILIALANT",	"C", 02, 0})

_cArqBlq2 := CriaTrab(_Estru2, .t.)
dbUseArea(.T.,, _cArqBlq2,"TRB2", .T. , .F. )
IndRegua ( "TRB2",_cArqBlq2,"FILIAL+CBASE+ITEM",,,"Selecionando Registros...")

//DbSelectArea("TRB2")
//Append from PROSN3.DTC

DbSelectArea("TMPSN3")
TMPSN3->( DbGoTop() )
While TMPSN3->( !Eof() )                         
//  de para conta contabil proget - microsiga
	_cconta := ''
	if alltrim(TMPSN3->N3_CCONTAB) == '1130700003'  // icms à recuperar
		_cconta := '11330001'
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100001' // terrenos - despresar conforme orientacao do sr.joao
		_cconta := '13021998'  // conta gerada para apoio a importacao
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100002' // edificios - despresar conforme orientacao do sr.joao
		_cconta := '13021002'
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100003' // instalacoes
		_cconta := '13021002'
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100004' // moveis e utencilios
		_cconta := '13021003'
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100005' // veiculos
		_cconta := '13021004'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100006' // maquinas e equipamentos
		_cconta := '13021005'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100007' // equipamentos de informatica
		_cconta := '13021006'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100008' // software
		_cconta := '13021007'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100011' // marcas e patentes
		_cconta := '13021008'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320100012' // benfeitorias
		_cconta := '13021999'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1320500002' // consorcios
		_cconta := '13023001'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1330200001' // instalacoes
		_cconta := '13031001'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1330200002' // moveis e ut.
		_cconta := '13021003'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1330200003' // instalacoes
		_cconta := '13021005'                        
	elseif alltrim(TMPSN3->N3_CCONTAB) == '1330200004' // instalacoes de loja
		_cconta := '13031001'                        
	endif               
                                                  
	                           
//  de para centro de custo proget - microsiga
    _ccusto_ := ''
	CCUST->(dbseek(ALLTRIM(TMPSN3->N3_CCUSTO))) // TMPSN3->N3_CCUSTO
	if CCUST->(found()) 
		_ccusto_ := CCUST->CCSIGA
	else
	    _ccusto_ := '1043'
	endif                                  
	
	
// de para conta contabil debito mensal	  
	_CDEPREC:=''
	if alltrim(TMPSN3->N3_CDEPREC) == '1130700003'
		_CDEPREC:='11330007'
	elseif alltrim(TMPSN3->N3_CDEPREC) == '5210100004' 
		if substr(_ccusto_,1,1) == '2'
			_CDEPREC:='53112004'
		else
			_CDEPREC:='53110004'
		endif
	endif 
	                       
// de para conta contabil credito mensal   
	_CCDEPR := ''
	if alltrim(TMPSN3->N3_CCDEPR) == '1130700003'		
		_CCDEPR := '11330007'
	elseif alltrim(TMPSN3->N3_CCDEPR) == '1320300002'
		_CCDEPR := '13022999'
	elseif alltrim(TMPSN3->N3_CCDEPR) == '1320300003'
		_CCDEPR := '13022001'
	elseif alltrim(TMPSN3->N3_CCDEPR) == '1320300004'
		_CCDEPR := '13022002'
	elseif alltrim(TMPSN3->N3_CCDEPR) == '1320300005'
		_CCDEPR := '13022003'
	elseif alltrim(TMPSN3->N3_CCDEPR) == '1320300006'
		_CCDEPR := '13022004'
	elseif alltrim(TMPSN3->N3_CCDEPR) == '1320300007'
		_CCDEPR := '13022005'
	elseif alltrim(TMPSN3->N3_CCDEPR) == '1320300008'
		_CCDEPR := '13022006'
	elseif alltrim(TMPSN3->N3_CCDEPR) == '1320300011'
		_CCDEPR := '13022007'
	elseif alltrim(TMPSN3->N3_CCDEPR) == '1320300012'
		_CCDEPR := '13022009'
	endif	            
	
	
	If TMPSN3->N3_FILIAL == xFilial("SN3")
		
		RecLock("TRB2",.T.)
		
		TRB2->FILIAL		:= TMPSN3->N3_FILIAL
		TRB2->CBASE			:= TMPSN3->N3_CBASE
		TRB2->ITEM			:= TMPSN3->N3_ITEM
 		if empty(TMPSN3->N3_TIPO)
 		   TRB2->TIPO			:= '01'
 		else
			TRB2->TIPO			:= TMPSN3->N3_TIPO
		endif
		TRB2->BAIXA			:= TMPSN3->N3_BAIXA
		TRB2->HISTOR		:= "IMPORTADO DO SISTEMA PROGET"
		TRB2->CCONTAB		:= 	_cconta  // TMPSN3->N3_CCONTAB
		TRB2->CCUSTO		:= _ccusto_  // TMPSN3->N3_CCUSTO
		TRB2->CUSTBEM		:= _ccusto_  // TMPSN3->N3_CUSTBEM
		TRB2->CDEPREC		:= _CDEPREC  // MPSN3->N3_CDEPREC
		TRB2->CCDEPR		:= _CCDEPR   // TMPSN3->N3_CCDEPR
		TRB2->AQUISIC		:= TMPSN3->N3_AQUISIC
		TRB2->VORIG1		:= TMPSN3->N3_VORIG1
		TRB2->TXDEPR3		:= TMPSN3->N3_TXDEPR3
		TRB2->VRDBAL1		:= TMPSN3->N3_VRDBAL1
		if TMPSN3->N3_VRDACM1 == 0
			TRB2->VRDACM1		:= 0.01
		else                 
			if TMPSN3->N3_VRDACM1 > TMPSN3->N3_VORIG1
				TRB2->VRDACM1		:= TMPSN3->N3_VORIG1
			else
				TRB2->VRDACM1		:= TMPSN3->N3_VRDACM1
			endif
		endif	
		TRB2->VRDBAL3		:= TMPSN3->N3_VRDBAL3
		TRB2->VRDMES3		:= TMPSN3->N3_VRDMES3
		TRB2->VRDACM3		:= TMPSN3->N3_VRDACM3
		TRB2->TXDEPR1		:= TMPSN3->N3_TXDEPR1
		TRB2->TXDEPR3		:= TMPSN3->N3_TXDEPR3
		TRB2->DTBAIXA		:= TMPSN3->N3_DTBAIXA
		TRB2->SEQ			:= TMPSN3->N3_SEQ
		
		MsUnLock()
		
	EndIf
	
	TMPSN3->( DbSkip() )
	
EndDo

Private lMsErroAuto := .f.

aBrowse := {}
AaDd(aBrowse,{"FILIAL",  "N1_FILIAL"})
AaDd(aBrowse,{"CBASE",   "N1_CBASE"})
AaDd(aBrowse,{"ITEM",    "N1_ITEM"})
AaDd(aBrowse,{"AQUISIC", "N1_AQUISIC" })
AaDd(aBrowse,{"QUANTD",  "N1_QUANTD"})
AaDd(aBrowse,{"CHAPA",   "N1_CHAPA"})
AaDd(aBrowse,{"GRUPO",   "N1_GRUPO"})
AaDd(aBrowse,{"CSEGURO", "N1_CSEGURO"})
AaDd(aBrowse,{"APOLICE", "N1_APOLICE"})
AaDd(aBrowse,{"DTVENC",  "N1_DTVENC"})
AaDd(aBrowse,{"TIPOSEG", "N1_TIPOSEG"})
AaDd(aBrowse,{"FORNEC",  "N1_FORNEC"})
AaDd(aBrowse,{"LOJA",    "N1_LOJA"})
AaDd(aBrowse,{"NFISCAL", "N1_NFISCAL"})
AaDd(aBrowse,{"DESCRIC", "N1_DESCRIC"})
AaDd(aBrowse,{"PROJETO", "N1_PROJETO"})
AaDd(aBrowse,{"PATRIM" , "N1_PATRIM"})
AaDd(aBrowse,{"CODCIAP", "N1_CODCIAP"})
AaDd(aBrowse,{"ICMSAPR", "N1_ICMSAPR"})
AaDd(aBrowse,{"CODBEM",  "N1_CODBEM"})
AaDd(aBrowse,{"BASESUP", "N1_BASESUP"})
//AaDd(aBrowse,{"ITEMSUP","N1_ITEMSUP"})
AaDd(aBrowse,{"CALCPIS", "N1_CALCPIS"})
AaDd(aBrowse,{"PENHORA", "N1_PENHORA"})

aBrowse2 := {}
AaDd(aBrowse2,{"FILIAL",  "N3_FILIAL"})
AaDd(aBrowse2,{"CBASE",   "N3_CBASE"})
AaDd(aBrowse2,{"ITEM",    "N3_ITEM"})
AaDd(aBrowse2,{"BAIXA",   "N3_BAIXA"})
AaDd(aBrowse2,{"HISTOR",  "N3_HISTOR"})
AaDd(aBrowse2,{"CCONTAB", "N3_CCONTAB" })
AaDd(aBrowse2,{"CCUSTO",  "N3_CCUSTO"})
AaDd(aBrowse2,{"CUSTBEM", "N3_CUSTBEM"})
AaDd(aBrowse2,{"CCORREC", "N3_CCORREC"})
AaDd(aBrowse2,{"CDEPREC", "N3_CDEPREC"})
AaDd(aBrowse2,{"CDESP",   "N3_CDESP"})
AaDd(aBrowse2,{"CCDEPR",  "N3_CCDEPR"})
AaDd(aBrowse2,{"NLANCTO", "N3_NLANCTO"})
AaDd(aBrowse2,{"DLANCTO", "N3_DLANCTO"})
AaDd(aBrowse2,{"DINDEPR", "N3_DINDEPR"})
AaDd(aBrowse2,{"DEXAUST", "N3_DEXAUST"})
AaDd(aBrowse2,{"VORIG1",  "N3_VORIG1"})
AaDd(aBrowse2,{"VORIG2",  "N3_VORIG2"})
AaDd(aBrowse2,{"VORIG3",  "N3_VORIG3"})
AaDd(aBrowse2,{"VORIG4",  "N3_VORIG4"})
AaDd(aBrowse2,{"VORIG5",  "N3_VORIG5"})
AaDd(aBrowse2,{"VRCBAL1", "N3_VRCBAL1"})
AaDd(aBrowse2,{"VRDBAL1", "N3_VRDBAL1"})
AaDd(aBrowse2,{"VRCMES1", "N3_VRCMES1"})
AaDd(aBrowse2,{"VRDMES1", "N3_VRDMES1"})
AaDd(aBrowse2,{"VRCACM1", "N3_VRCACM1"})
AaDd(aBrowse2,{"VRDACM1", "N3_VRDACM1"})
AaDd(aBrowse2,{"VRDBAL2", "N3_VRDBAL2"})
AaDd(aBrowse2,{"VRDMES2", "N3_VRDMES2"})
AaDd(aBrowse2,{"VRDACM2", "N3_VRDACM2"})
AaDd(aBrowse2,{"VRDBAL3", "N3_VRDBAL3"})
AaDd(aBrowse2,{"VRDMES3", "N3_VRDMES3"})
AaDd(aBrowse2,{"VRDACM3", "N3_VRDACM3"})
AaDd(aBrowse2,{"VRDBAL4", "N3_VRDBAL4"})
AaDd(aBrowse2,{"VRDMES4", "N3_VRDMES4"})
AaDd(aBrowse2,{"VRDACM4", "N3_VRDACM4"})
AaDd(aBrowse2,{"VRDBAL5", "N3_VRDBAL5"})
AaDd(aBrowse2,{"VRDMES5", "N3_VRDMES5"})
AaDd(aBrowse2,{"VRDACM5", "N3_VRDACM5"})
AaDd(aBrowse2,{"TXDEPR1", "N3_TXDEPR1"})
AaDd(aBrowse2,{"TXDEPR2", "N3_TXDEPR2"})
AaDd(aBrowse2,{"TXDEPR3", "N3_TXDEPR3"})
AaDd(aBrowse2,{"TXDEPR4", "N3_TXDEPR4"})
AaDd(aBrowse2,{"TXDEPR5", "N3_TXDEPR5"})
AaDd(aBrowse2,{"INDICE1", "N3_INDICE1"})
AaDd(aBrowse2,{"INDICE2", "N3_INDICE2"})
AaDd(aBrowse2,{"INDICE3", "N3_INDICE3"})
AaDd(aBrowse2,{"INDICE4", "N3_INDICE4"})
AaDd(aBrowse2,{"INDICE5", "N3_INDICE5"})
AaDd(aBrowse2,{"DTBAIXA", "N3_DTBAIXA"})
AaDd(aBrowse2,{"AQUISIC", "N3_AQUISIC"})
AaDd(aBrowse2,{"DEPREC",  "N3_DEPREC"})
AaDd(aBrowse2,{"OK",      "N3_OK"})
AaDd(aBrowse2,{"FIMDEPR", "N3_FIMDEPR"})
AaDd(aBrowse2,{"SUBCCON", "N3_SUBCCON"})
AaDd(aBrowse2,{"SUBCCOR", "N3_SUBCCOR"})
AaDd(aBrowse2,{"SUBCDEP", "N3_SUBCDEP"})
AaDd(aBrowse2,{"SUBCDES", "N3_SUBCDES"})
AaDd(aBrowse2,{"SUBCCDE", "N3_SUBCCDE"})
AaDd(aBrowse2,{"BXICMS",  "N3_BXICMS"})
AaDd(aBrowse2,{"SEQREAV", "N3_SEQREAV"})
AaDd(aBrowse2,{"AMPLIA1", "N3_AMPLIA1"})
AaDd(aBrowse2,{"AMPLIA2", "N3_AMPLIA2"})
AaDd(aBrowse2,{"AMPLIA3", "N3_AMPLIA3"})
AaDd(aBrowse2,{"AMPLIA4", "N3_AMPLIA4"})
AaDd(aBrowse2,{"AMPLIA5", "N3_AMPLIA5"})
AaDd(aBrowse2,{"CODBAIX", "N3_CODBAIX"})
AaDd(aBrowse2,{"SEQ",     "N3_SEQ"})
AaDd(aBrowse2,{"VRCDA1",  "N3_VRCDA1"})
AaDd(aBrowse2,{"VRCDB1",  "N3_VRCDB1"})
AaDd(aBrowse2,{"VRCDM1",  "N3_VRCDM1"})
AaDd(aBrowse2,{"FILORIG", "N3_FILORIG"})
AaDd(aBrowse2,{"CLVLCON", "N3_CLVLCON"})
AaDd(aBrowse2,{"CLVLCOR", "N3_CLVLCOR"})
AaDd(aBrowse2,{"CLVLDEP", "N3_CLVLDEP"})
AaDd(aBrowse2,{"CLVLDES", "N3_CLVLDES"})
AaDd(aBrowse2,{"CLVLCDE", "N3_CLVLCDE"})
AaDd(aBrowse2,{"TPDEPR",  "N3_TPDEPR"})
AaDd(aBrowse2,{"CCDESP",  "N3_CCDESP"})
AaDd(aBrowse2,{"CCCDEP",  "N3_CCCDEP"})
AaDd(aBrowse2,{"CCCDES",  "N3_CCCDES"})
AaDd(aBrowse2,{"CCCORR",  "N3_CCCORR"})
AaDd(aBrowse2,{"SUBCTA",  "N3_SUBCTA"})
AaDd(aBrowse2,{"CLVL",    "N3_CLVL"})
AaDd(aBrowse2,{"IDBAIXA", "N3_IDBAIXA"})
AaDd(aBrowse2,{"LOCAL",   "N3_LOCAL"})

dbSelectArea("TRB")
cCadastro := OemtoAnsi("Importação de tabelas - ATIVO FIXO")

DbSelectArea("TRB")
TRB->( DbGotop() )

@ 200,1 TO 455,620 DIALOG oDlg2 TITLE cCadastro
@ 113,140 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
@ 15,5 TO 93,310 BROWSE "TRB" FIELDS aBrowse
ACTIVATE DIALOG oDlg2 CENTERED

ProcRegua( LastRec() )

TRB->( DbGotop() )
MsSeek(xFilial("SN1"))                               

//rf   
/*
While TRB->( !Eof() ) .And. xFilial("SN1") == TRB->FILIAL
	if alltrim(TRB->CBASE) <> '300131'
		trb->(dbskip())
		loop
	endif
	exit
enddo
*/


While TRB->( !Eof() ) .And. xFilial("SN1") == TRB->FILIAL
		
	IncProc("Importando... " + TRB->FILIAL+ " - " + TRB->CBASE + " - " + TRB->ITEM )        
	
	lMsErroAuto := .f.
	
    aLinha:={}     
    aItens:={}
	aATFA010:={}               
	
	aAdD(aATFA010,{"N1_FILIAL"      ,TRB->FILIAL,Nil})
	aAdD(aATFA010,{"N1_CBASE" 	    ,TRB->CBASE,Nil})
	aAdD(aATFA010,{"N1_ITEM" 		,TRB->ITEM,Nil})
	aAdD(aATFA010,{"N1_AQUISIC" 	,TRB->AQUISIC,Nil})
	aAdD(aATFA010,{"N1_QUANTD" 	    ,TRB->QUANTD,Nil})
	aAdd(aATFA010,{"N1_BAIXA" 	    ,TRB->BAIXA,Nil})
/*
	if TRB->CHAPA == "      " .OR. TRB->CHAPA == "0     "
		_nItem += 1
		_cItem2 := StrZero(_nItem,4)
		_cChapa := "IM" + _cItem2
		aAdD(aATFA010,{"N1_CHAPA" 	    ,_cChapa,Nil})
	Else
		aAdD(aATFA010,{"N1_CHAPA" 	    ,TRB->CHAPA,Nil})
	endif
*/  

//rf	
//procura na SN1 se já existe a chapa !
_vchapa := TRB->CHAPA         
if TRB->CHAPA == "      " .OR. TRB->CHAPA == "0     "
	_nItem += 1
	_cItem2 := StrZero(_nItem,4)
	_vChapa := "IM" + _cItem2
Else
	dbselectarea("SN1")
	dbsetorder(2)
	SN1->(dbseek(TRB->FILIAL + alltrim(TRB->CHAPA)))
	if SN1->(FOUND()) // PRECISA PROCURAR O PROXIMO NUMERO VALIDO
		SN1->(DBGOTOP())
		SN1->(dbseek(TRB->FILIAL ))
		WHILE !EOF() .AND. SN1->N1_FILIAL == TRB->FILIAL
			SN1->(DBSKIP())
			LOOP
		ENDDO
		SN1->(DBSKIP(-1))
		_vchapa := soma1(SN1->N1_CHAPA)
	endif
endif
aAdD(aATFA010,{"N1_CHAPA" 	    ,_vchapa,Nil})
RestArea( aArea )
RestArea( aAreaSN1 )


	aAdD(aATFA010,{"N1_GRUPO" 	    ,TRB->GRUPO,Nil})
	//aAdD(aATFA010,{"N1_CSEGURO" 	,TRB->CSEGURO,Nil})
	//aAdD(aATFA010,{"N1_APOLICE" 	,TRB->APOLICE,Nil})
	//aAdD(aATFA010,{"N1_DTVENC" 		,TRB->DTVENC,Nil})
	//aAdD(aATFA010,{"N1_TIPOSEG" 	,TRB->TIPOSEG,Nil})
	//aAdD(aATFA010,{"N1_FORNECE" 	,TRB->FORNEC,Nil})
	//aAdD(aATFA010,{"N1_LOJA"    	,TRB->LOJA,Nil})
	aAdD(aATFA010,{"N1_LOCAL"    	,TRB->LOCA,Nil})
	//aAdD(aATFA010,{"N1_SERIE"   	,TRB->SERIE,Nil})
	//aAdD(aATFA010,{"N1_NFISCAL" 	,TRB->NFISCAL,Nil})
	aAdD(aATFA010,{"N1_DESCRIC" 	,TRB->DESCRIC,Nil})
	//aAdD(aATFA010,{"N1_PROJETO"  	,TRB->PROJETO,Nil})
	aAdD(aATFA010,{"N1_PATRIM"  	,TRB->PATRIM,Nil})
	//aAdD(aATFA010,{"N1_CODCIAP"  	,TRB->CODCIAP,Nil})
	//aAdD(aATFA010,{"N1_ICMSAPR"  	,TRB->ICMSAPR,Nil})
	//aAdD(aATFA010,{"N1_DTBLOQ"  	,TRB->DTBLOQ,Nil})
	//aAdD(aATFA010,{"N1_CODBEM"  	,TRB->CODBEM,Nil})
	//aAdD(aATFA010,{"N1_BASESUP"  	,TRB->BASESUP,Nil})
	//aAdD(aATFA010,{"N1_ITEMSUP"  	,TRB->ITEMSUP,Nil})
	//aAdD(aATFA010,{"N1_CALCPIS" 	,"1",Nil})
	//aAdD(aATFA010,{"N1_PENHORA"	    ,"0",Nil})
	
	_cFilial	:= TRB->FILIAL
	_cCbase 	:= TRB->CBASE
	_cItem  	:= TRB->ITEM        
	_dtaquis    := TRB->AQUISIC
	
	DbSelectArea("TRB2")
	TRB2->( DbGotop() )
	
	MsSeek(_cFilial+_cCbase+_cItem)
	
	While TRB2->( !Eof() ) .And. _cFilial+_cCbase+_cItem == TRB2->FILIAL+TRB2->CBASE+TRB2->ITEM
		
		_Proce ++
		aLinha:={}
		//aadd(aLinha,{"N3_FILIAL"   ,TRB2->FILIAL,Nil})
		//aadd(aLinha,{"N3_CBASE"   ,TRB2->CBASE,Nil})
		//aadd(aLinha,{"N3_ITEM"   ,TRB2->ITEM,Nil})
		aadd(aLinha,{"N3_TIPO"   ,TRB2->TIPO,Nil})
		aadd(aLinha,{"N3_BAIXA"   ,TRB2->BAIXA,Nil})
		aadd(aLinha,{"N3_HISTOR"   ,"IMPORTADO DO SISTEMA PROGET",Nil})
		aadd(aLinha,{"N3_CCONTAB",TRB2->CCONTAB,Nil})
		aadd(aLinha,{"N3_CCUSTO",TRB2->CCUSTO,Nil})
		aadd(aLinha,{"N3_CUSTBEM",TRB2->CUSTBEM,Nil})
		//aadd(aLinha,{"N3_CCORREC",TRB2->CCORREC,Nil})
		aadd(aLinha,{"N3_CDEPREC",TRB2->CDEPREC,Nil})
		//aadd(aLinha,{"N3_CDESP"  ,TRB2->CDESP,Nil})
 		aadd(aLinha,{"N3_CCDEPR" ,TRB2->CCDEPR,Nil})
		//aadd(aLinha,{"N3_NLANCTO",TRB2->NLANCTO,Nil})
		//aadd(aLinha,{"N3_DLANCTO",TRB2->DLANCTO,Nil})
		// rf
//		aadd(aLinha,{"N3_DINDEPR",TRB->AQUISIC,Nil})    
		aadd(aLinha,{"N3_DINDEPR",_dtaquis,Nil})    
		
		
		//aadd(aLinha,{"N3_DEXAUST",TRB2->DEXAUST,Nil})
		aadd(aLinha,{"N3_VORIG1"  ,TRB2->VORIG1,Nil})
		//aadd(aLinha,{"N3_VORIG2"  ,TRB2->VORIG2,Nil})
		aadd(aLinha,{"N3_VORIG3"  ,TRB2->VORIG1/TRB2->TXDEPR3,Nil})
		//aadd(aLinha,{"N3_VORIG4"  ,TRB2->VORIG4,Nil})
		//aadd(aLinha,{"N3_VORIG5"  ,TRB2->VORIG5,Nil})
		//aadd(aLinha,{"N3_VRCBAL1",TRB2->VRCBAL1,Nil})
		aadd(aLinha,{"N3_VRDBAL1",TRB2->VRDBAL1,Nil})
		//aadd(aLinha,{"N3_VRCMES1",TRB2->VRCMES1,Nil})
		//aadd(aLinha,{"N3_VRDMES1",TRB2->VRDMES1,Nil})
		//aadd(aLinha,{"N3_VRCACM1",TRB2->VRCACM1,Nil})
		aadd(aLinha,{"N3_VRDACM1",TRB2->VRDACM1,Nil})
		//aadd(aLinha,{"N3_VRDBAL2",TRB2->VRDBAL2,Nil})
		//aadd(aLinha,{"N3_VRDMES2",TRB2->VRDMES2,Nil})
		//aadd(aLinha,{"N3_VRDACM2",TRB2->VRDACM2,Nil})
		aadd(aLinha,{"N3_VRDBAL3",TRB2->VRDBAL3,Nil})
		//aadd(aLinha,{"N3_VRDMES3",TRB2->VRDMES3,Nil})
		aadd(aLinha,{"N3_VRDACM3",TRB2->VRDACM3,Nil})
		//aadd(aLinha,{"N3_VRDBAL4",TRB2->VRDBAL4,Nil})
		//aadd(aLinha,{"N3_VRDMES4",TRB2->VRDMES4,Nil})
		//aadd(aLinha,{"N3_VRDACM4",TRB2->VRDACM4,Nil})
		//aadd(aLinha,{"N3_VRDBAL5",TRB2->VRDBAL5,Nil})
		//aadd(aLinha,{"N3_VRDMES5",TRB2->VRDMES5,Nil})
		//aadd(aLinha,{"N3_VRDACM5",TRB2->VRDACM5,Nil})
		aadd(aLinha,{"N3_TXDEPR1",TRB2->TXDEPR1,Nil})
		//aadd(aLinha,{"N3_TXDEPR2",TRB2->TXDEPR2,Nil})
		aadd(aLinha,{"N3_TXDEPR3",TRB2->TXDEPR3,Nil})
		//aadd(aLinha,{"N3_TXDEPR4",TRB2->TXDEPR4,Nil})
		//aadd(aLinha,{"N3_TXDEPR5",TRB2->TXDEPR5,Nil})
		//aadd(aLinha,{"N3_INDICE1",TRB2->INDICE1,Nil})
		//aadd(aLinha,{"N3_INDICE2",TRB2->INDICE2,Nil})
		//aadd(aLinha,{"N3_INDICE3",TRB2->INDICE3,Nil})
		//aadd(aLinha,{"N3_INDICE4",TRB2->INDICE4,Nil})
		//aadd(aLinha,{"N3_INDICE5",TRB2->INDICE5,Nil})
		aadd(aLinha,{"N3_DTBAIXA",TRB2->DTBAIXA,Nil})
		//aadd(aLinha,{"N3_AQUISIC",TRB2->AQUISIC,Nil})
		//aadd(aLinha,{"N3_DEPREC", TRB2->DEPREC,Nil})
		//aadd(aLinha,{"N3_OK"	 ,TRB2->OK,Nil})
		//aadd(aLinha,{"N3_FIMDEPR",TRB2->FIMDEPR,Nil})
		//aadd(aLinha,{"N3_SUBCCON",TRB2->SUBCCON,Nil})
		//aadd(aLinha,{"N3_SUBCCOR",TRB2->SUBCCOR,Nil})
		//aadd(aLinha,{"N3_SUBCDEP",TRB2->SUBCDEP,Nil})
		//aadd(aLinha,{"N3_SUBCDES",TRB2->SUBCDES,Nil})
		//aadd(aLinha,{"N3_SUBCCDE",TRB2->SUBCCDE,Nil})
		//aadd(aLinha,{"N3_BXICMS" ,TRB2->BXICMS,Nil})
		//aadd(aLinha,{"N3_SEQREAV",TRB2->SEQREAV,Nil})
		//aadd(aLinha,{"N3_AMPLIA1",TRB2->AMPLIA1,Nil})
		//aadd(aLinha,{"N3_AMPLIA2",TRB2->AMPLIA2,Nil})
		//aadd(aLinha,{"N3_AMPLIA3",TRB2->AMPLIA3,Nil})
		//aadd(aLinha,{"N3_AMPLIA4",TRB2->AMPLIA4,Nil})
		//aadd(aLinha,{"N3_AMPLIA5",TRB2->AMPLIA5,Nil})
		//aadd(aLinha,{"N3_CODBAIX" ,TRB2->CODBAIX,Nil})
		aadd(aLinha,{"N3_SEQ"	  ,TRB2->SEQ,Nil})
		//aadd(aLinha,{"N3_VRCDA1",TRB2->VRCDA1,Nil})
		//aadd(aLinha,{"N3_VRCDB1",TRB2->VRCDB1,Nil})
		//aadd(aLinha,{"N3_VRCDM1",TRB2->VRCDM1,Nil})
		//aadd(aLinha,{"N3_FILORIG",TRB2->FILORIG,Nil})
		//aadd(aLinha,{"N3_CLVLCON",TRB2->CLVLCON,Nil})
		//aadd(aLinha,{"N3_CLVLCOR",TRB2->CLVLCOR,Nil})
		//aadd(aLinha,{"N3_CLVLDEP",TRB2->CLVLDEP,Nil})
		//aadd(aLinha,{"N3_CLVLDES",TRB2->CLVLDES,Nil})
		//aadd(aLinha,{"N3_CLVLCDE",TRB2->CLVLCDE,Nil})
		//aadd(aLinha,{"N3_TPDEPR",TRB2->TPDEPR,Nil})
		//aadd(aLinha,{"N3_CCDESP",TRB2->CCDESP,Nil})
		//aadd(aLinha,{"N3_CCCDEP",TRB2->CCCDEP,Nil})
		//aadd(aLinha,{"N3_CCCDES",TRB2->CCCDES,Nil})
		//aadd(aLinha,{"N3_CCCORR",TRB2->CCCORR,Nil})
		//aadd(aLinha,{"N3_SUBCTA",TRB2->SUBCTA,Nil})
		//aadd(aLinha,{"N3_CLVL"	,TRB2->CLVL,Nil})
		//aadd(aLinha,{"N3_IDBAIXA",TRB2->IDBAIXA,Nil})
		//aadd(aLinha,{"N3_LOCAL",TRB2->LOCAL,Nil})
		aadd(aItens,aLinha)
		
		_cFilial    := TRB2->FILIAL
		_cCbase 	:= TRB2->CBASE
		_cItem  	:= TRB2->ITEM
		
		DbSelectArea("TRB2")
		TRB2->( DbSkip() )
		
	End
	
	If Len(aATFA010) > 0 .and. Len(aItens) > 0
		LMSErroAuto := .F.
		MSExecAuto({|x,y,z| atfa010(x,y,z)},aATFA010,aItens,3)
		If LMSErroAuto
			MostraErro()
			If !MSGyesno("Continua?")
				Exit
			EndIF
		else
			_Grava++
			aATFA010 := {}
			aItens   := {}
			
		Endif
	EndIf
	DbSelectArea("TRB")
	DbSkip()
	
End

DbSelectArea("TRB")
DbCloseArea()

DbSelectArea("TRB2")
DbCloseArea()

MsgStop("Processou: "+Transform(_Proce,"@E 999,999")+" Gravou: "+Transform(_Grava,"@E 999,999"))
Return


