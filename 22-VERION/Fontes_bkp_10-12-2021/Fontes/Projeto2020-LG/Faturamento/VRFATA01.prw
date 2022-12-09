#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VRFATA01  ³ Autor ³ RICARDO CAVALINI      ³ Data ³06/10/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Programa para gerar o pedido de vendas e faturamento com   ³±±
±±³Descricao ³ base na nota fiscal de importacao.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³ Data   ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VRFATA01()
cCadastro := "Transformar Nota de Importacao em Pedido de Vendas AEM"
aRotina   := {}
aCores    := {}

// montagem das bolinhas coloridas
Private aCores:= {	{"F1_FORNECE == '000093'"  , 'BR_VERDE'    },;
					{"F1_FORNECE <> '000093'"  , 'BR_VERMELHO' }}


Private aLegenda := { 	{"BR_VERDE", 	"Fornecedor Hidraulica Sulamericana" },;	 
						{"BR_VERMELHO", "Outros Fornecedores"}}

// Monta um aRotina proprio
aAdd(aRotina,{"Pesquisar "            ,"AxPesqui",0,1})
aAdd(aRotina,{"Visualizar"            ,"AxVisual",0,2})
aAdd(aRotina,{"Ped.Vendas"            ,"U_GRPV01",0,3})
aAdd(aRotina,{"Ped.Vendas Liberado"   ,"U_GRPV01",0,4})
aAdd(aRotina,{"Ped.Vendas/Nota Saida" ,"U_GRPV01",0,5})
aAdd(aRotina,{"Legenda"               ,"BrwLegenda('Legenda', 'Fornecedor', aLegenda)"   ,0,8})


dbselectarea("SF1")
cAlias  := Alias()
nOrd    := Indexord()
nReg    := Recno()

Set Filter to F1_FORMUL ='S'

mBrowse(6,1,22,75,"SF1",,,,,,acores)

// Retorna condicao original
dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoto(nReg)

return

//  ======================   INICIO DA FUNCAO DE GERACAO DE PEDIDO DE VENDAS SOMENTE  ================= //
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GRPV01    ³ Autor ³ RICARDO CAVALINI      ³ Data ³06/10/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Programa para gerar o pedido de vendas somente             ³±±
±±³Descricao ³ Gera somente o ped de vendas sem liberacao ou faturamento  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³ Data   ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION GRPV01()
Local cQry    := ''
Local _stru   := {}
Local aCpoBro := {}
Local oDlgLocal
aCores            := {}
Private cPerg     := "Notas Fiscais de Importação"
Private lInverte  := .F.
Private cMark     := GetMark()
Private oMark     //Cria um arquivo de Apoio
Private cTabSF1   := RetSQLName("SF1")
Private cQuebra   := Chr(13)+Chr(10)
Private cAliasSF1 := GetNextAlias()
Private nNUMNF    := 0
Private cQuantNF  := ""
nvr := 0

fAtuPerg()

If Pergunte(cPerg,.T.)   // Perguntas do Relatorio
	cQry += CRLF + " SELECT SF1.F1_FILIAL, SF1.F1_DOC, SF1.F1_SERIE, SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_EMISSAO, SF1.F1_VALBRUT"
	cQry += CRLF + " FROM " +cTabSF1+ " SF1 "
	cQry += CRLF + " WHERE SF1.F1_DOC BETWEEN     '"+MV_PAR01+"' and '"+MV_PAR02+"'   "
	cQry += CRLF + " AND SF1.F1_FORNECE = '"+MV_PAR03+"' AND  SF1.D_E_L_E_T_ = ''"
	cQry += CRLF+ " ORDER BY SF1.F1_DOC"
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),cAliasSF1,.F.,.T.)
	
	AADD(_stru,{"OK"           ,"C"     ,2          ,0          })
	AADD(_stru,{"FILIAL"       ,"C"     ,4          ,0          })
	AADD(_stru,{"NOTA"         ,"C"     ,6          ,0          })
	AADD(_stru,{"SERIE"        ,"C"     ,3          ,0          })
	AADD(_stru,{"FORNECEDOR"   ,"C"     ,6          ,0          })
	AADD(_stru,{"LOJA"         ,"C"     ,2          ,0          })
	AADD(_stru,{"EMISSAO"      ,"D"     ,8          ,0          })
	AADD(_stru,{"VALOR"        ,"N"     ,12         ,2          })
	AADD(_stru,{"STATUS"       ,"C"     ,2          ,0          })
	
	cArq:=Criatrab(_stru,.T.)
	DBUSEAREA(.t.,,carq,"TTRB") //Alimenta o arquivo de apoio com os registros do cadastro de clientes (SA1)
	
	
	(cAliasSF1)->(dbGotop())
	
	While (cAliasSF1)->(!Eof())
		DbSelectArea("TTRB")
		RecLock("TTRB",.T.)
		emisss := stod( (cAliasSF1)->F1_EMISSAO )
		
		TTRB->FILIAL     :=   (cAliasSF1)->F1_FILIAL
		TTRB->NOTA       :=   (cAliasSF1)->F1_DOC
		TTRB->SERIE      :=   (cAliasSF1)->F1_SERIE
		TTRB->FORNECEDOR :=   (cAliasSF1)->F1_FORNECE
		TTRB->LOJA       :=   (cAliasSF1)->F1_LOJA
		TTRB->EMISSAO    :=   stod((cAliasSF1)->F1_EMISSAO)
		TTRB->VALOR      :=   (cAliasSF1)->F1_VALBRUT
		TTRB->STATUS     :=   "0"    //Verde
		MsunLock()
		
		nNUMNF := nNUMNF +1
		(cAliasSF1)->(DbSkip())
	End
	
	//Define as cores dos itens de legenda.
	aCores := {}
	aAdd(aCores,{"TTRB->STATUS == ‘0‘","BR_VERDE"   })
	aAdd(aCores,{"TTRB->STATUS == ‘1‘","BR_AMARELO" })
	aAdd(aCores,{"TTRB->STATUS == ‘2‘","BR_VERMELHO"})
	
	//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
	aCpoBro     := {{ "OK"                 ,, "Mark"           ,"@!"},;        // @! @1!   @x " @E 999,999,999.99"
					{ "FILIAL"             ,, "Filial"         ,"@!"},;
					{ "NOTA"               ,, "Nota"           ,"@!"},;
					{ "SERIE"              ,, "Serie"          ,"@!"},;
					{ "FORNECEDOR"         ,, "Fornecedor"     ,"@!"},;
					{ "LOJA"               ,, "Loja"           ,"@!"},;
					{ "EMISSAO"            ,, "Emissao"        ,"@!"},;
					{ "VALOR"              ,, "Valor"          ," @E 999,999,999.99"}}
	
	//Cria uma Dialog
	cQuantNF := cValtoChar (nNUMNF)
	DEFINE MSDIALOG oDlg TITLE "Relacao das Notas de Importação -    " + cQuantNF + "    Encontrados " From 9,0 To 315,1000 PIXEL
	DbSelectArea("TTRB")
	DbGotop()
	
	//Cria a MsSelect
	oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{17,1,150,500},,,,,) //aCores)
	oMark:bMark := {| | Disp()}
	
	//Exibe a Dialog
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nvr:=1,VrGrPv(),oDlg:End()},{||nvr:=2, oDlg:End()})
	
	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	TTRB->(DbCloseArea())
	
	IF nvr = 1
		MSGALERT("Dados Atualizados!", "Gravacao ok")
	ENDIF
	
	Iif(File(cArq + GetDBExtension()),FErase(cArq + GetDBExtension()) ,Nil)
Else
	Return
Endif
Return

//Funcao executada ao Marcar/Desmarcar um registro.
Static Function Disp()
RecLock("TTRB",.F.)
If Marked("OK")
	TTRB->OK := cMark
Else
	TTRB->OK := ""
Endif
MSUNLOCK()
oMark:oBrowse:Refresh()
Return()

//Cria Perguntas
Static Function fAtuPerg()
PutSx1( cPerg, "01", "Da Nota        :" , "Da Nota        " , "Da Nota        "   ,"MV_CH1" , "C" ,9 ,0, 1, "G", "", "", "" , "", "MV_PAR01"   , ""    ,""    ,""        ,""     ,""     ,"","","","","","","","","","","","","","", ""   ,"", "")
PutSx1( cPerg, "02", "Ate Nota       :" , "Ate Not        " , "Ate Nota       "   ,"MV_CH2" , "C" ,9 ,0, 1, "G", "", "", "" , "", "MV_PAR02"   , ""    ,""    ,""        ,""     ,""     ,"","","","","","","","","","","","","","", ""   ,"", "")
PutSx1( cPerg, "03", "Fornecedor     :" , "Fornecedor     " , "Fornecedor     "   ,"MV_CH3" , "C" ,6 ,0, 1, "G", "", "", "" , "", "MV_PAR03"   , ""    ,""    ,""        ,""     ,""     ,"","","","","","","","","","","","","","", ""   ,"", "")
Return
//  ======================   FIM DA FUNCAO DE GERACAO DE PEDIDO DE VENDAS SOMENTE  ================= //

// INICIO DO TRATAMENTO DE TRANSFERENCIA !!!!
// GERA PEDIDO DE VENDAS
STATIC FUNCTION VrGrPv()
__lCtMsg   := .F.
__NCABRC   := 0
_aIntCab  := {}  // Array com os dados para montagem do pedido de transferencia (SC5)
_aIntAux  := {}  // Array com os dados para montagem do pedido de transferencia (SC6)
_aIntDet  := {}  // Array de complemento para montagem do pedido de transferencia (SC6)
_aIntCf2  := {}  // Array com os dados para inclusao da nota no Deposito (SF1)
_aIntAf2  := {}  // Array com os dados para inclusao de nota no Deposito (SD1)
_aIntDf2  := {}  // Array de complemento para inclusao de nota no Deposito (SD1)
aPvlNfs   := {}  // Array com a montagem da nota fiscal de transferencia
_lSC9Blq  := .F. // Tratamento de itens liberado para geracao da nota de transferencia
_lRetorno := .F. // Tratamento de itens liberado para geracao da nota de transferencia
_cNota    := ""  // numero da nota fiscal de saida de transferencia
__cNrPv   := ""  // numero do pedido de vendas

DbSelectArea("TTRB")
DbGotop()
While !Eof()

	IF EMPTY(TTRB->OK)
		DbSelectArea("TTRB")
		DBSKIP()
		LOOP
	ENDIF
	
	DBSELECTAREA("SF1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SF1")+TTRB->(NOTA+SERIE+FORNECEDOR+LOJA))
		
		If cEmpAnt == "01"  // Almoxarifado
			
			__lCtMsg   := .T.
			__cCLI 	   := "001574"   // CLIENTE
			__cLja     := "01"       // LOJA
			__cTrp 	   := "000487"   // TRANSPORTADORA
			__cTpo 	   := "N"        // TIPO DO PEDIDO
			__cEmp 	   := "02"
			__xlgdp    := .t.
			__cFilEp   := "02"
			
			IF __NCABRC = 0
			
			AAdd(_aIntCab, {"C5_TIPO"   , __cTpo          , Nil})
			AAdd(_aIntCab, {"C5_CLIENTE", __cCLI          , Nil})
			AAdd(_aIntCab, {"C5_LOJACLI", __cLja          , Nil})
			AAdd(_aIntCab, {"C5_CLIENT" , __cCLI          , Nil})
			AAdd(_aIntCab, {"C5_LOJAENT", __cLja          , Nil})
			AAdd(_aIntCab, {"C5_TRANSP" , __cTrp          , Nil})
			AAdd(_aIntCab, {"C5_TIPOCLI", "R"             , Nil})
			AAdd(_aIntCab, {"C5_CONDPAG", "103"           , Nil})
			AAdd(_aIntCab, {"C5_VEND1"  , "000003"        , Nil})
			AAdd(_aIntCab, {"C5_VKGFAT" , "S"             , Nil})
			AAdd(_aIntCab, {"C5_MOEDA"  , 1               , Nil})
			AAdd(_aIntCab, {"C5_TPFRETE", "C"             , Nil})
			AAdd(_aIntCab, {"C5_MENNOTA", ""              , Nil})
			AAdd(_aIntCab, {"C5_TPCARGA", "2"             , Nil})
//			AAdd(_aIntCab, {"C5_PESOL"  , SF1->F1_PLIQUI  , Nil})
//			AAdd(_aIntCab, {"C5_PBRUTO" , SF1->F1_PBRUTO  , Nil})
//			AAdd(_aIntCab, {"C5_ESPECI1", SF1->F1_ESPECI1 , Nil})
//			AAdd(_aIntCab, {"C5_VOLUME1", SF1->F1_VOLUME1 , Nil})
			AAdd(_aIntCab, {"C5_TIPLIB" , "1"             , Nil})
			AAdd(_aIntCab, {"C5_TPCARGA", "2"             , Nil})
			AAdd(_aIntCab, {"C5_GERAWMS", "1"             , Nil})
			AAdd(_aIntCab, {"C5_DTTXREF", Ddatabase       , Nil})
			
			__NCABRC++
			ENDIF

			// ITENS DA NOTA FISCAL DE ENTRADA / MONTAGEM DO SC6
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
			While !Eof() .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
				_aIntAux := {}
				
				AAdd(_aIntAux,{"C6_ITEM"   , STRZERO(VAL(SD1->D1_ITEM),2)   , Nil})
				AAdd(_aIntAux,{"C6_PRODUTO", SD1->D1_COD       , Nil})
				AAdd(_aIntAux,{"C6_DESCRI" , POSICIONE("SB1",1,XFILIAL("SD1")+SD1->D1_COD,"B1_DESC")       , Nil})
				AAdd(_aIntAux,{"C6_QTDVEN" , SD1->D1_QUANT     , Nil})
				AAdd(_aIntAux,{"C6_PRUNIT" , 0                 , Nil})  
				AAdd(_aIntAux,{"C6_PRCVEN" , SD1->D1_VUNIT     , Nil})
				AAdd(_aIntAux,{"C6_OPER"   , "01"              , Nil})
				AAdd(_aIntAux,{"C6_LOCAL"  , SD1->D1_LOCAL     , Nil})
				AAdd(_aIntAux,{"C6_VRDESC" , 0                 , Nil})  
				AAdd(_aIntAux,{"C6_VALDESC", 0                 , Nil})  
				AAdd(_aIntAux,{"C6_DESCONT", 0                 , Nil})  

//				AAdd(_aIntAux,{"C6_QTDLIB" , SD1->D1_QUANT     , Nil})				

				AAdd(_aIntDet, _aIntAux)
				dbSelectArea("SD1")
				dbSkip()
			End
			
		Endif
	ENDIF
	DbSelectArea("TTRB")
	DBSKIP()
	LOOP
END

// GERA O PEDIDO DE VENDAS COM BASE NO ARRAY
IF __lCtMsg
	
	lMsErroAuto := .F.
	
	IF EMPTY(_aIntCab) .OR. EMPTY(_aIntDet)
		
		MSGSTOP("ARRAY VAZIO. ENTRAR EM CONTATO COM TI!!!")
		return
		
	ELSE
		MSExecAuto( { |x,y,z| Mata410(x,y,z) }, _aIntCab, _aIntDet, 3 )
	ENDIF
	
	If lMsErroAuto
		DisarmTransaction()
		MostraErro("SYSTEM","00PV_VERION.txt")
		Aviso("Inclusão de Pedido de Vendas.","Houve um erro na inclusão do Pedido, favor entrar em contato com TI. (00PV_VERION) !!!",{"Voltar"})
		
	Else
		
		MSGALERT("Pedido de Vendas Nr.: "+SC5->C5_NUM)
		__cNrPv := SC5->C5_NUM
		
		/*
		aPvlNfs   := {}
		aBloqueio := {{"","","","","","","",""}}
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5")+__cNrPv)
		Ma410LbNfs(2,@aPvlNfs,@aBloqueio)//libera o pedido
		Ma410LbNfs(1,@aPvlNfs,@aBloqueio)//verifica o pedido
		
		If !empty(aBloqueio)
		_lSC9Blq := .T.
		EndIf
		
		If _lSC9Blq
		Aviso("Inclusão de pedido de vendas","O pedido de vendas "+SC5->C5_NUM+" está com itens bloqueados e portanto não será possível efetuar o faturamento!",{"Voltar"})
		_lRetorno := .F.
		ElseIf Len(aPvlNfs) == 0
		Aviso("Inclusão de pedido de vendas","Não foram encontrados itens para serem faturados!",{"Voltar"})
		_lRetorno := .F.
		Else
		/*
		// Efetua o faturamento do pedido GERA A NOTA FISCAL
		// _cNota := GeraNfs(__cNrPv,"004")  //MaPvlNfs(aPvlNfs,"004",.F.,.F.,.F.,.T.,.F.,0,0,.T.,.F.)
		
		// MSGALERT("Nota Fiscal Nr.: "+_cNota+". Para continuidade do processo será necessario a transmissao ao SEFAZ !!!")
		
		// Grava numero de pedido e nota no SF1
		// DbSelectArea("SF1")
		// RecLock("SF1",.F.)
		// SF1->F1_E_PV := __cNrPv
		// SF1->F1_E_NF := _cNota
		// SF1->F1_E_SR := "004"
		// MsUnlock("SF1")
		
		// cab de nota de entrada, montagem da entrada no deposito...
		dbSelectArea("SF2")
		dbSetOrder(1)
		If dbSeek(xFilial("SF2")+_cNota+"004")
		
		AAdd(_aIntCf2, {"F1_TIPO"   , "N"                  , nil} )
		AAdd(_aIntCf2, {"F1_FORMUL" , "N"                  , nil} )
		AAdd(_aIntCf2, {"F1_DOC"    , SF2->F2_DOC          , nil} )
		AAdd(_aIntCf2, {"F1_SERIE"  , SF2->F2_SERIE        , nil} )
		AAdd(_aIntCf2, {"F1_EMISSAO", SF2->F2_EMISSAO      , nil} )
		AAdd(_aIntCf2, {"F1_ESPECIE", "SPED"               , nil} )
		
		IF __cEmp == "02"
		AAdd(_aIntCf2, {"F1_FORNECE", "000757"             , nil} )
		AAdd(_aIntCf2, {"F1_LOJA"   , "07"                 , nil} )
		AAdd(_aIntCf2, {"F1_FILIAL" , "02"                 , nil} )
		ELSE
		AAdd(_aIntCf2, {"F1_FORNECE", SF2->F2_CLIENTE      , nil} )
		AAdd(_aIntCf2, {"F1_LOJA"   , SF2->F2_LOJA         , nil} )
		AAdd(_aIntCf2, {"F1_FILIAL" , "15"                 , nil} )  // DEVE SER TRATADO QDO TIVER MAIS DEPOSITOS DE TERCEIROS...
		ENDIF
		
		dbSelectArea("SD2") // F2_FILIAL + F2_DOC + F2_SERIE
		dbSetOrder(3)
		__CVRPSQ := "004"
		
		If dbSeek(xfilial("SD2")+_cNota+__CVRPSQ)
		While !Eof() .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE) == xfilial("SD2")+_cNota+__CVRPSQ
		
		_aIntAf2 := {}
		
		IF __cEmp == "02"
		If SD2->D2_TES == "820"
		__cTes := "498"
		ElseIf SD2->D2_TES == "892"
		__cTes := "499"
		Endif
		
		AAdd(_aIntAf2,{"D1_FILIAL"  , "02"               , Nil})
		
		If  __cFilEp == "00"
		AAdd(_aIntAf2,{"D1_LOCAL"   , "00"               , Nil})
		Else
		AAdd(_aIntAf2,{"D1_LOCAL"   , "02"               , Nil})
		Endif
		
		ELSE
		__cTes := "498"
		
		AAdd(_aIntAf2,{"D1_FILIAL"  , "15"               , Nil})
		AAdd(_aIntAf2,{"D1_LOCAL"   , "15"               , Nil})
		ENDIF
		
		AAdd(_aIntAf2,{"D1_COD"     , SD2->D2_COD        , Nil})
		AAdd(_aIntAf2,{"D1_TES"     , __cTes             , Nil})
		AAdd(_aIntAf2,{"D1_VUNIT"   , SD2->D2_PRCVEN     , Nil})
		AAdd(_aIntAf2,{"D1_QUANT"   , SD2->D2_QUANT      , Nil})
		AAdd(_aIntAf2,{"D1_TOTAL"   , SD2->D2_TOTAL      , Nil})
		//AAdd(_aIntAf2,{"D1_LOTECTL" , SD2->D2_LOTECTL    , Nil})   // TRATAMENTO DE LOTE
		//AAdd(_aIntAf2,{"D1_DTVALID" , SD2->D2_DTVALID    , Nil})   // TRATAMENTO DE LOTE
		
		AAdd(_aIntDf2, _aIntAf2)
		dbSelectArea("SD2")
		dbSkip()
		End
		Endif
		lMsErroAuto	:= .F.
		
		IF __cEmp == "02"
		cFilant:="02"
		ELSE
		cFilant:="15"
		ENDIF
		
		// Inclui pre-nota
		lMsErroAuto := .F.
		MSExecAuto( { |x,y,z| Mata140(x,y,z) }, _aIntCf2,_aIntDf2,3)
		//MATA140(_aIntCf2,_aIntDf2,3)
		
		// Atualiza para a filial origem
		cFilant:="01"
		
		If lMsErroAuto
		DisarmTransaction()
		MostraErro("SYSTEM","00NF_DEPOSITO.txt")
		Aviso("Inclusão da nota de entrada no Deposito.","Houve um erro na inclusão da nota, favor entrar em contato com TI. (00NF_DEPOSITO) !!!",{"Voltar"})
		Endif
		
		Else
		_lRetorno := .F.
		Aviso("Inclusão da nota de entrada no Deposito.","Houve um erro na inclusão da nota de saída para o Deposito !!!",{"Voltar"})
		EndIf
		
		EndIf
		*/
	EndIf
ENDIF

DBSELECTAREA("SF1")
// FIM DO TRATAMENTO DE TRANSFERENCIA !!!!

return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ GERANFS  ¦ Autor ¦ SERGIO COMPAIN        ¦ Data ¦ 24/11/10 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ GRAVACAO DA NOTA DE SAIDA                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function GeraNfs(cPedido,cSerie)

Local aNotas 	:= {}
Local aLockSX6  := {}

Begin Transaction

IncNota(cPedido,cSerie,"",@aNotas)
#IFDEF TOP
	
	//-- Na função IncNota tem uma chamada para a função NxtSX5Nota (MATXFUNA) onde tem um RecLock no parâmetro MV_NUMITEN,
	//-- ao voltar, por algum motivo, o lock não é retirado, em todas as outras tabelas os locks são perdidos ao finalizar com
	//-- END TRANSACTION.... a tabela SX6 continua com o registro travado dando erro em outras telas.	Esse problema só ocorre
	//-- qdo estamos utilizando o TOP CONNECT com o parâmetro MV_TTS como S.
	aLockSX6 := SX6->(DBRLockList())
	
	For nX := 1 To Len(aLockSX6)
		SX6->(DBGoTo(aLockSX6[nX]))
		SX6->(MSUnLock())
	Next
#ENDIF
End Transaction

Return (aNotas[1,2])