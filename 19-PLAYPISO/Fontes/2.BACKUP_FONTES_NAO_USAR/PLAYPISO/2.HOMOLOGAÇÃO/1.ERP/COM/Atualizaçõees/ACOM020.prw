#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFATA001  บAutor  ณAlexandre Martins   บ Data ณ  24/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBrowser para controle especifico de solicitacoes de compras.บฑฑ
ฑฑบ          ณMostra apenas as solicitacoes nao atendidas.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico para necessidades LISONDA.                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACOM020(xAutoCab,xAutoItens, nOpcAuto,lProj711,lWhenGet)
	                                                                
Local bBlock
Local cFiltraSC1
Local cMt110Fil  := ""
Local aIndexSC1  := {}
Local aRotinaNew := {}
Local nPos       := 0
Local nX         := 0
Local nRegSC1    := 0
Local lContinua  := .T.
Local aCores     := {}
Local aCoresNew  := {}
Local lAProvSI   := GetNewPar("MV_APROVSI",.F.)

	PRIVATE aRotina			:= MenuDef() // ALTERADO PARA SIGAGSP
	Private cCadastro		:= "Controle PM"
	Private l_TERMO			:= .F.
	Private l_CANCEL		:= .F.
	Private c_EOL			:= chr(13)+chr(10)

	Private cCusMed			:= GetMv("MV_CUSMED")
	Private aRegSD3  		:= {}

	Private c_alias1		:= "SC1"
	Private c_alias2		:= "SC6"
		
	Private c_cpoitem		:= "C6_ITEM"     //ITENS DO P.V.
	Private c_chave1		:= {"C5_NUM"}   // CHAVES DO P.V.
	Private c_chave2		:= {"C6_NUM"}
	Private c_cpofil1		:= ''
	Private c_cpofil2		:= '' 
    Private a_Index         := {}
    Private cFiltraSC5      := '!(C1_QUJE==C1_QUANT) .and. !(C1_QUJE==0.And.(C1_COTACAO==Space(Len(C1_COTACAO)).Or.C1_COTACAO=="IMPORT").And.C1_APROV="R")'
    Private aCores 			:= {} 
    Private bFiltraBrw
				
	If SC1->(FieldPos("C1_FLAGGCT")) > 0
	    aAdd(aCores,{'C1_FLAGGCT=="1"','BR_MARROM'})		//SC Totalmente Atendida pelo SIGAGCT
	EndIf
	If SC1->(FieldPos("C1_TIPO"))>0
		aAdd(aCores,{'C1_TIPO==2' 	                                                                            ,'BR_BRANCO'	})	//Solicitacao de Importacao	
	Endif		
	aAdd(aCores,{'!Empty(C1_RESIDUO)'																			,'BR_PRETO'		})	//SC Eliminada por Residuo
	aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO==Space(Len(C1_COTACAO)).And.C1_APROV$" ,L"' 						,'ENABLE'		})	//SC em Aberto
	aAdd(aCores,{'C1_QUJE==0.And.(C1_COTACAO==Space(Len(C1_COTACAO)).Or.C1_COTACAO=="IMPORT").And.C1_APROV="R"'	,'BR_LARANJA'	})	//SC Rejeitada
	aAdd(aCores,{'C1_QUJE==0.And.(C1_COTACAO==Space(Len(C1_COTACAO)).Or.C1_COTACAO=="IMPORT").And.C1_APROV="B"'	,'BR_CINZA' 	})	//SC Bloqueada
	aAdd(aCores,{'C1_QUJE==C1_QUANT' 																			,'DISABLE'		})	//SC com Pedido Colocado
	aAdd(aCores,{'C1_QUJE>0' 																					,'BR_AMARELO'	})	//SC com Pedido Colocado Parcial
	aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO<>Space(Len(C1_COTACAO)).And. C1_IMPORT <>"S" ' 						,'BR_AZUL'		})	//SC em Processo de Cotacao
	aAdd(aCores,{'C1_QUJE==0.And.C1_COTACAO<>Space(Len(C1_COTACAO)).And. C1_IMPORT =="S".And.C1_APROV$" ,L"' 	,'BR_PINK'		})	//SC com Produto Importado


		DEFAULT lProj711    := .F.
		DEFAULT lWhenGet	:= .F.
		PRIVATE lProjM711	:= If(ValType(lProj711)== "L",lProj711,.F.)
		PRIVATE aRotina		:= MenuDef() // ALTERADO PARA SIGAGSP
		PRIVATE cCadastro	:= OemtoAnsi("Solicitao de Compras")	//
		PRIVATE l110Auto	:= (xAutoCab <> Nil .and. xAutoItens <> Nil)
		PRIVATE aAutoCab	:= {}
		PRIVATE aAutoItens	:= {}
		PRIVATE bFiltraBrw	:= {|| Nil}
		PRIVATE lCopia      := .F.
		PRIVATE l110Alt     := .T.
		PRIVATE lGrade      := MaGrade()
		PRIVATE lGatilha    := .T.  // Para preencher aCols em funcoes chamadas da validacao (X3_VALID)
	


	bFiltraBrw := {|| FilBrowse(c_alias1,@a_Index,@cFiltraSC5) }   //Filtra MBrowse 
	Eval(bFiltraBrw)                                                                           
	mBrowse( 6, 1,22,75,c_alias1,,,,,,aCores)                                                                      
 
    EndFilBrw(c_alias1,a_Index)
	dbSelectArea(c_alias1)
	DbSetOrder (1)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda   บAutor  ณMarcelo Pagliotto   บ Data ณ  07/28/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Legenda dos itens do Pedido de Vendas para pedidos        บฑฑ
ฑฑบ          ณ    especiais (Controle de Pedidos de Materiais)            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MFATA01a() // Legenda()

	Local aCores := {} 
	                   
	aAdd(aCores,{"BR_VERDE"   ,"Pedido em Aberto" })
	aAdd(aCores,{"BR_AZUL"    ,"Pedido separado"  })
	aAdd(aCores,{"BR_AMARELO" ,"Pedido Entregue"  })
	aAdd(aCores,{"BR_VERMELHO","Pedido Encerrado" })
	BrwLegenda(cCadastro,"Legenda",aCores)

Return .T.                                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFATA01d  บAutor  ณMarcelo Pagliotto   บ Data ณ  04/08/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBotใo Aglutina  Controle de PM e gera PV com itens          บฑฑ
ฑฑบ          |Uso especifico MultLock									  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MFATA01d(cAlias, nRecno, nOpc)

	Local c_Query	   := ''
	Local nK           := 00
	Local _proce       := 0
	Local _MostSn	   := .T.
	Local nOpc         := 4
	Local cNumDoc      := ""
	Local cCondPag     := SuperGetMV("MV_XCONPM") //"000"     // condicao pagamento
	Local cTpv         := "N"       // tipo de pedido de vendas
	Local cCodD        := ''
	Local c_Baixa	   := ''
	Local c_localiz	   := ''
	
	Private cPerg       := "CPM410"
	Private c_Local     := SuperGetMV("MV_XARMTR") //'77'
	Private aCabPv      := {}
	Private aCab        := {}
	Private aItens      := {}
	Private aLinha	    := {}
	Private lMsErroAuto := .F.
	Private cTpFrete	:= "C"
	n_pbruto := 0
	n_pliqui := 0
	n_volume := 0

	ValidPerg(cPerg)
	
	pergunte(cPerg,.T.)
	
	c_Query := " select      C5_FILIAL, C5_VEND1, C5_DESCFI, C5_DESC1, C5_TABELA, C5_XNATURE, C5_EMISSAO, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_XSITPM, C6_FILIAL, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_PRCVEN, C6_NUM, C6_LOCAL, C6_VALOR, C6_TES, C5_TIPOCLI, C5_XORIGEM, C6_DESCONT, C5_PBRUTO, C5_PESOL, C5_VOLUME1 "
	c_Query += " from        "+RetSqlName("SC6")+" SC6 			    "
	c_Query += " inner join  "+RetSqlName("SC5")+" SC5 			    "
	c_Query += " on          SC6.C6_NUM = SC5.C5_NUM       			"
	c_Query += " and         SC6.C6_FILIAL = '"+xFilial("SC6")+"'	"
	c_Query += " Where       SC5.C5_CLIENTE = '"+(MV_PAR01)+"' 		"
	c_Query += " and         SC5.C5_XSITPM = 'E'					"
	c_Query += " and         SC5.C5_XTTPPED = 'S'					"
	c_Query += " and         SC6.D_E_L_E_T_ <> '*' 				    "
	c_Query += " and         SC5.C5_FILIAL = '"+xFilial("SC5")+"'	"
	c_Query += " and         SC5.D_E_L_E_T_ <> '*'	"

	a_campos := {{"Emissใo", "Pedido", "Produto", "Quantidade"}, {"C5_EMISSAO", "C5_NUM", "C6_PRODUTO", "C6_QTDVEN"}}
	c_tit := "Itens a aglutinar"
	U_FGEN008(c_Query, a_campos, c_tit, 1)

	If !msgYesNo("Confirma a aglutin็ใo dos pedidos?", "A T E N ว ร O")
		Return
	EndIf
	
	If Select("QRT") > 0
		DbSelectArea("QRT")
		DbCloseArea()
	EndIf

	dbUseArea( .T., "TOPCONN", TcGenQry(,,c_Query), "QRT", .T., .F. )
	
	If QRT->(eof())
		MsgAlert("nao ha itens para Gerar Pedido de Vendas")
		dbSelectArea("QRT")
		dbclosearea()
		return
	Else
		
		IncProc("Importando")
		
		_Proce ++
		lMsErroAuto := .F.
		
		DbSelectArea("QRT")
		
		aCabPv:={}
		aAdD(aCabPv,{"C5_TIPO"     , cTpv               ,Nil})
		aAdD(aCabPv,{"C5_CLIENTE"  , QRT->C5_CLIENTE    ,Nil})
		aAdD(aCabPv,{"C5_LOJACLI"  , QRT->C5_LOJACLI    ,Nil})
		aAdD(aCabPv,{"C5_CLIENT"   , QRT->C5_CLIENTE    ,Nil})
		aAdD(aCabPv,{"C5_LOJAENT"  , QRT->C5_LOJACLI    ,Nil})
		aAdD(aCabPv,{"C5_TIPOCLI"  , QRT->C5_TIPOCLI    ,Nil})
		aAdD(aCabPv,{"C5_XNATURE"  , QRT->C5_XNATURE    ,Nil})
		aAdD(aCabPv,{"C5_TABELA"   , QRT->C5_TABELA     ,Nil})
		aAdD(aCabPv,{"C5_VEND1"    , QRT->C5_VEND1      ,Nil})
		aAdD(aCabPv,{"C5_DESC1"    , QRT->C5_DESC1      ,Nil})
		aAdD(aCabPv,{"C5_DESCFI"   , QRT->C5_DESCFI     ,Nil})
		aAdD(aCabPv,{"C5_XORIGEM"  , QRT->C5_XORIGEM    ,Nil})
		aAdD(aCabPv,{"C5_CONDPAG"  , cCondPag           ,Nil})
		aAdD(aCabPv,{"C5_XPDAGLT"  , "S"		        ,Nil})
		aAdD(aCabPv,{"C5_TPFRETE"	, cTpFrete			,Nil})
		
		dbSelectArea("QRT")
		dbGoTop()
		
		While QRT->(!EOF())
			c_localiz := Iif(GetAdvFval("SB1", "B1_LOCALIZ", xFilial("SB1")+QRT->C6_PRODUTO, 1, "")='S', "00", "")
		
			nK++
			aLinha := {{"C6_ITEM"     ,Strzero(nK,2)	,Nil},;
			{"C6_PRODUTO"  , QRT->C6_PRODUTO      		,Nil},;
			{"C6_UM"       , "UN"			       		,Nil},;
			{"C6_QTDVEN"   , QRT->C6_QTDVEN     		,Nil},;
			{"C6_PRCVEN"   , QRT->C6_PRCVEN     		,Nil},;
			{"C6_VALOR"    , QRT->C6_VALOR      		,Nil},;
			{"C6_TES"      , QRT->C6_TES        		,Nil},;
			{"C6_LOCAL"    , c_Local	        		,Nil},;
			{"C6_DESCONT"  , QRT->C6_DESCONT      		,Nil}}
			
			aadd(aItens,aLinha)
			
			n_pbruto += QRT->C5_PBRUTO
			n_pliqui += QRT->C5_PESOL
			n_volume += QRT->C5_VOLUME1

			QRT->(DbSkip())
		EndDo
		
		aAdD(aCabPv,{"C5_PBRUTO"	, n_pbruto	,Nil})
		aAdD(aCabPv,{"C5_PESOL"		, n_pliqui	,Nil})
		aAdD(aCabPv,{"C5_VOLUME1"	, n_volume	,Nil})

		MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPV,aItens,3)//nOpc)
		
		If lMsErroAuto
			If _MostSN
				Mostraerro()
				MsgAlert("Baixa nao Concluida")
				Return
			EndIf
		EndIf
		
		A410Altera(c_alias1, c_alias2, nOpc)
		c_pedpai := SC5->C5_NUM
		
		dbSelectArea("QRT")
		DBGOTOP()
		
		While QRT->(!EOF())
			
			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xfilial("SC5")+QRT->C5_NUM)
			
			If SC5->C5_NUM == QRT->C5_NUM
				Reclock("SC5",.F.)
				SC5->C5_XSITPM := "F" //ENCERRA PM
				SC5->C5_XPMPAI := c_pedpai
				MSUNLOCK()
			ENDIF
			QRT->(DbSkip())
		EndDo
		
		dbSelectArea("QRT")
		dbclosearea()
		
	endif
	bFiltraBrw := {|| FilBrowse(c_alias1,@a_Index,@cFiltraSC5) }   //Filtra MBrowse
	
	Eval(bFiltraBrw)
	dbSelectArea(c_alias1)
	DbSetOrder (1)
	
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ MKW Windows 2.0    บ Data ณ  06/01/99   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg(c_Perg)
    Local i, j
	c_Alias := Alias()
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	c_Perg 	:= PADR(c_Perg, 10)
	aRegs	:= {}
	
	aAdd(aRegs,{c_Perg,"01"  ,"Cliente ?",""      ,""     ,"MV_CH1","C"    ,06      ,0       ,1     ,"G" ,""    ,"MV_PAR01",""      	,""      ,""      ,""   ,""         ,""         ,""      ,""      ,""    ,""        ,""             ,""      ,""     ,""     ,""       ,""             ,""      ,""      ,""    ,""        ,""            ,""      ,""      ,"SA1"    ,""   })
	
	For i:=1 to Len(aRegs)
		If !dbSeek(c_Perg+aRegs[i,2])
			RecLock("SX1", .T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	DbSelectArea(c_Alias)                

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFATA01e  บAutor  ณAlexandre Sousa     บ Data ณ  09/15/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChama o relatorio padrao de historico.                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MFATA01e(cAlias, nRecno, nOpc)

	U_MFATR001(SC5->C5_CLIENTE)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณMenuDef   ณ Autor ณ Fabio Alves Silva     ณ Data ณ06/11/2006ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Utilizacao de menu Funcional                               ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณArray com opcoes da rotina.                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณParametros do array a Rotina:                               ณฑฑ
ฑฑณ          ณ1. Nome a aparecer no cabecalho                             ณฑฑ
ฑฑณ          ณ2. Nome da Rotina associada                                 ณฑฑ
ฑฑณ          ณ3. Reservado                                                ณฑฑ
ฑฑณ          ณ4. Tipo de Transao a ser efetuada:                        ณฑฑ
ฑฑณ          ณ	  1 - Pesquisa e Posiciona em um Banco de Dados           ณฑฑ
ฑฑณ          ณ    2 - Simplesmente Mostra os Campos                       ณฑฑ
ฑฑณ          ณ    3 - Inclui registros no Bancos de Dados                 ณฑฑ
ฑฑณ          ณ    4 - Altera o registro corrente                          ณฑฑ
ฑฑณ          ณ    5 - Remove o registro corrente do Banco de Dados        ณฑฑ
ฑฑณ          ณ5. Nivel de acesso                                          ณฑฑ
ฑฑณ          ณ6. Habilita Menu Funcional                                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function MenuDef()
Local lGspInUseM := If(Type('lGspInUse')=='L', lGspInUse, .F.)
PRIVATE aRotina	:= {}

// ALTERADO PARA SIGAGSP
aAdd(aRotina, {OemToAnsi("Pesquisar"),"PesqBrw"    , 0 , 1, 0, .F.})		//
aAdd(aRotina, {OemToAnsi("Visualizar"),"A110Visual" , 0 , 2, 0, nil})		//
aAdd(aRotina, {OemToAnsi("Incluir"),"A110Inclui" , 0 , 3, 113, nil})		//
aAdd(aRotina, {OemToAnsi("Alterar"),"A110Altera" , 0 , 4, 4, nil}) 	//
aAdd(aRotina, {OemToAnsi("Imprimir"),"A110Impri"  , 0 , 4, 0, nil})		//
aAdd(aRotina, {OemToAnsi("Excluir"),"A110Deleta" , 0 , 5, 5, nil})	   //
If !lGspInUseM
	aAdd(aRotina, {OemToAnsi("Aprovacao"),"A110Aprov"  , 0 , 7, 0, nil})	//
EndIf
aAdd(aRotina, {OemToAnsi("Copia"),"A110Copia"  , 0 , 4, 113, nil})		//
aAdd(aRotina, {OemToAnsi("Legenda"),"A110Legenda", 0 , 5, 0, .F.})		//
aAdd(aRotina, {OemToAnsi("Cancelamento SCs"),"A110Cancela", 0 , 6, 0, nil})		//
If !__lPyme
	AAdd( aRotina, {OemToAnsi("Conhecimento"), "MsDocument", 0, 4, 0, nil} )	//
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ExistBlock("MTA110MNU")
	ExecBlock("MTA110MNU",.F.,.F.)
EndIf
Return(aRotina)
