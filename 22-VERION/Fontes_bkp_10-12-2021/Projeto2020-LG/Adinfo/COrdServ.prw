#Include "protheus.ch"
#Include "topconn.ch"
#Include "rwmake.ch"
#include "ap5mail.ch"
#include "TbiConn.ch"
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ cOrdServ º Autor ³ RICARDO CAVALINI   º Data ³  13/12/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esta função cria a tela de Ordem de servico no modulo do   º±±
±±º          ³ call center, visandoa documentacao da mesma.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ call center --> Verion                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function cOrdServ()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCores    := {}
Local aLegenda  := {}
PUBLIC _ctmp       := TIME()

// montagem das bolinhas coloridas
aCores:= {	{'ZA_STATUS == "B"'  , 'BR_BRANCO'        },;
			{'Empty(ZA_STATUS)'  , 'ENABLE'           },;
			{'ZA_STATUS == "R"'  , 'RECUSA_ALMOX'     },;
			{'ZA_STATUS == "L"'  , 'BR_PINK'          },;
			{'ZA_STATUS == "S"'  , 'BR_AMARELO'       },;
			{'ZA_STATUS == "J"'  , 'PEND_ALM'         },;
			{'ZA_STATUS == "O"'  , 'BR_AZUL'          },;
			{'ZA_STATUS == "P"'  , 'PEND_FAB'         },;
			{'ZA_STATUS == "M"'  , 'RECUSA_FABRICA'   },;
			{'ZA_STATUS == "C"'  , 'ENCERR_FABRICA'   },;
			{'ZA_STATUS == "W"'  , 'BR_AZUL_CLARO'    },;
			{'ZA_STATUS == "Y"'  , 'PEND_ELET'        },;
			{'ZA_STATUS == "X"'  , 'RECUSA_ELET'      },;
			{'ZA_STATUS == "Z"'  , 'ENCER_ELET'       },;
			{'ZA_STATUS == "E"'  , 'DISABLE'          }}
                               
Private aRotina := MenuDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := "Ordem de Servico - Verion"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(6,1,22,75,"SZA",,,,,,aCores)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ZOrdServ º Autor ³ RICARDO CAVALINI   º Data ³  13/12/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esta função cria a tela de Ordem de servico no modulo do   º±±
±±º          ³ call center, visandoa documentacao da mesma.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ call center --> Verion                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ZOrdServ(_nmnu)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

local nCntFor2
Local oRadio,oStatus,oStatu1,oStatu2,oStatu3,oStatu4,oPatente,oStatus,oTpLog
Local cStatus,cStatu1,cStatu2,cStatu3,cStatu4,cParente,cStatus
Local aPages	    := {"HEADER"}
Local aTitles	    := {"Modificação","Serv.Executado","Teste","Relatorio"}  // FOLDER´S DO PROGRAMA
Local aArrayF4	    := {}
Local aArrayline    := {}
Local aHeadCpos	    := {}
Local _cCD1         := ""
Local _CCT  		:= 0
Local _CCT3			:= ""
Local _cCt2 		:= ""
Local nX
Local nCntFor2
Private aCab        := {}
Private aItem       := {}
Private aReg        := {}
Private APOSOBJ     := {}                                                                                                  
Private aOper       := {"","1-Conserto","2-Estoque","3-Manutencao","4-Montagem","5-Transformacao","6-Usinagem","7-Fabrica","8-Eletronica"}
Private aOpGr       := {"","S-Sim","N-Nao"}
Private lMsErroAuto := .f.
Private oDlg
STATIC aBrwLF
STATIC aNFCab
Public _nvis        := _nmnu
Public cUsuMAST     := ""
aTpLogr             := {}

DEFINE FONT oBold NAME  "Times New Roman"    SIZE 0,20  BOLD

aSizeAut := MsAdvSize(,.F.,400)
aObjects := {}
aRecSF3	 := {}
AAdd( aObjects, { 000, 041, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 000, 075, .T., .F. } )
aInfo      := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj    := MsObjSize( aInfo, aObjects )
l103Class  := .F.
// Tratamento de combobox e radio
csitu      := ccivi   := _cTpLog := cStat  := ctpci := ""
oSitu      := oTitSex := ocivi   := oTpLog := oStat := otpci := ""
nTitSex    := NDEBITO := ndesfol := 1
_nDtConta  := 0

// Tela Principal do atendimento contribuições Call Center
DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Ordem de Serviço" OF oMainWnd PIXEL

// Label da Tela Principal
@ aPosObj[1][1]-25,aPosObj[1][2] TO 085,aPosObj[1][4] LABEL '' OF oDlg PIXEL

// parametro com os usuarios que podem alterar a OS a qualquer momento
cUsuMAST := Getmv("MV_USUMAS")

// ALTERACAO
IF  !RetCodUsr() $ cUsuMAST
	If _nmnu = 4
		IF SZA->ZA_STATUS $ "E/S/J/O/M/C/W/Y/Z/X"
			_nvis := 1
			_nmnu := 1
			
			IF SZA->ZA_STATUS == "S"
				MSGALERT("Ordem de Servico, no processo de SEPARACAO. Operação de ALTERAÇÃO, invalida !!!", "Ordem de Servico - Status Separação")
			ELSEIF SZA->ZA_STATUS == "O/W"
				MSGALERT("Ordem de Servico, no processo de APONTAMENTO. Operação de ALTERAÇÃO, invalida !!!", "Ordem de Servico - Status Apontamento")
			ELSEIF SZA->ZA_STATUS $ "J/P/Y"
				MSGALERT("Ordem de Servico, no processo de PENDENCIA. Operação de ALTERAÇÃO, invalida !!!", "Ordem de Servico - Status Pendente")
			ELSEIF SZA->ZA_STATUS $ "E/C/Z"
				MSGALERT("Ordem de Servico, no processo de ENCERRADA. Operação de ALTERAÇÃO, invalida !!!", "Ordem de Servico - Status Encerrada")
			ELSEIF SZA->ZA_STATUS == "M/X"
				MSGALERT("Ordem de Servico, no processo de RECUSA. Solicite estorno ao Depto. Almoxarifado. Operação de ALTERAÇÃO, invalida !!!", "Ordem de Servico - Status Encerrada")
			ENDIF
		ENDIF
	ENDIF
ENDIF

If _nmnu = 3  //inclusao
	_cMsgAni  := ""
	_cMsgdev  := ""
	_dDataint := CTOD("  /  /  ")
	_cNros    := GetSXENum("SZA","ZA_IDOS")
	_cCliOs   := Space(06)
	_cLojOs   := Space(02)
	_cNomOs   := Space(50)
	_dEmiOs   := DdataBase
	_cDocOs   := Space(09)
	_cSerOs   := Space(03)
	_cPrdOs   := Space(15)
	_cDPrdOs  := Space(60)
	_CPLAOS   := SPACE(15)
	_cDefOs   := Space(100)
	_chini    := Space(08)
	_chprv    := Space(08)
	_chter    := Space(08)
	_dtini    := DdataBase
	_chini    := TIME()
	_dtPrv    := DdataBase
	_dtter    := CTOD("  /  /  ")
	_catend   := space(06)
	_cPedve   := space(06)
	_cOrdPr   := Space(11)
	ooper     := ""
	ooger     := ""
	coper     := ""
	CVEND     := ""
	CNOMEV    := ""
	COPEX     := ""
	CNOMX     := ""
	_cGerOp   := ""
	_CSTAOP	  := ""
Else
	_dDataint := CTOD("  /  /  ")
	_cNros    := SZA->ZA_IDOS
	_cCliOs   := SZA->ZA_CLIENTE
	_cLojOs   := SZA->ZA_LOJA
	_cNomOs   := SZA->ZA_NOME
	_dEmiOs   := SZA->ZA_EMISSAO
	_cDocOs   := SZA->ZA_NFE
	_cSerOs   := SZA->ZA_SERIE
	_cPrdOs   := SZA->ZA_EQUIPAM
	_cDPrdOs  := SZA->ZA_DESCEP
	_CPLAOS   := SZA->ZA_PLANILH
	_cDefOs   := SZA->ZA_DEFEITO
	_chini    := SZA->ZA_HORAINI
	_chprv    := SZA->ZA_HORAPRV
	_dtter    := SZA->ZA_DTFIM
	_chter    := SZA->ZA_TERMINI
	_Dtini    := SZA->ZA_DTINICI
	_dtPrv    := SZA->ZA_DTPREVI
	_catend   := space(06)
	_cPedve   := SZA->ZA_PEDVEND
	_cOrdPr   := SZA->ZA_OP
	coper     := IIF(SUBSTR(SZA->ZA_TIPO,1,1) = "1","1-Conserto",IIF(SUBSTR(SZA->ZA_TIPO,1,1) ="2","2-Estoque",IIF(SUBSTR(SZA->ZA_TIPO,1,1) ="3","3-Manutencao",IIF(SUBSTR(SZA->ZA_TIPO,1,1) ="4","4-Montagem",IIF(SUBSTR(SZA->ZA_TIPO,1,1) ="5","5-Transformacao",IIF(SUBSTR(SZA->ZA_TIPO,1,1) ="6","6-Usinagem","7-Fabrica"))))))
	CVEND     := SZA->ZA_VEND
	CNOMEV    := SZA->ZA_NOMVED
	COPEX     := SZA->ZA_OPERADO
	CNOMX     := SZA->ZA_NOMEOPE
	_cGerOp	  := IIF(SUBSTR(SZA->ZA_GERAOP,1,1)="S","S-Sim","N-Nao")
	_CSTAOP   := SZA->ZA_STATUS
Endif

// Campos do Cabecalho Padrão
@ 010,010 SAY OemToAnsi("Numero ")               OF oDlg PIXEL SIZE 031,006
@ 010,035 MSGET _cNrOs                           OF oDlg PIXEL SIZE 040,006 WHEN .F.
@ 010,100 SAY OemToAnsi("Emissão")               OF oDlg PIXEL SIZE 045,006
@ 010,130 MSGET _dEmiOs                          OF oDlg PIXEL SIZE 040,006 WHEN .F.

@ 010,200 SAY OemToAnsi("Cliente/Loja")          OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 010,230 MSGET _cCliOs                          OF oDlg PIXEL SIZE 040,006 F3 "SA1" VALID VRNOME()
	@ 010,270 MSGET _clojOs                          OF oDlg PIXEL SIZE 015,006 WHEN .F.
	@ 010,291 MSGET _cNomOs                          OF oDlg PIXEL SIZE 205,006 WHEN .F.
else
	@ 010,230 MSGET _cCliOs                          OF oDlg PIXEL SIZE 040,006 WHEN .F.
	@ 010,270 MSGET _clojOs                          OF oDlg PIXEL SIZE 015,006 WHEN .F.
	@ 010,291 MSGET _cNomOs                          OF oDlg PIXEL SIZE 205,006 WHEN .F.
endif

@ 010,500 SAY OemToAnsi("N.Fiscal/Serie")        OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 010,535 MSGET _cDocOs                          OF oDlg PIXEL SIZE 070,006
	@ 010,610 MSGET _cSerOs                          OF oDlg PIXEL SIZE 020,006
else
	@ 010,535 MSGET _cDocOs                          OF oDlg PIXEL SIZE 070,006 WHEN .F.
	@ 010,610 MSGET _cSerOs                          OF oDlg PIXEL SIZE 020,006 WHEN .F.
endif

@ 025,010 SAY OemToAnsi("Planilha")              OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 025,030 MSGET _CPLAOS                          OF oDlg PIXEL SIZE 060,006
else
	@ 025,030 MSGET _CPLAOS                          OF oDlg PIXEL SIZE 060,006 when .f.
endif

@ 025,100 SAY OemToAnsi("Dt Inicio")             OF oDlg PIXEL SIZE 045,006
@ 025,125 MSGET _Dtini                           OF oDlg PIXEL SIZE 045,006 WHEN .F.
@ 025,175 SAY OemToAnsi("Hr Inicio")             OF oDlg PIXEL SIZE 045,006
@ 025,200 MSGET _chini                           OF oDlg PIXEL SIZE 010,006 picture "99:99"  WHEN .F.
@ 025,232 SAY OemToAnsi("Dt Previsao")           OF oDlg PIXEL SIZE 045,006
@ 025,265 MSGET _dtprv                           OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 025,315 SAY OemToAnsi("Hr Previsao")           OF oDlg PIXEL SIZE 045,006
	@ 025,345 MSGET _chprv                           OF oDlg PIXEL SIZE 010,006 picture "99:99"
else
	@ 025,315 SAY OemToAnsi("Hr Previsao")           OF oDlg PIXEL SIZE 045,006
	@ 025,345 MSGET _chprv                           OF oDlg PIXEL SIZE 010,006 picture "99:99" when .f.
endif


@ 025,378 SAY OemToAnsi("Dt Termino")            OF oDlg PIXEL SIZE 045,006
@ 025,405 MSGET _dtter                           OF oDlg PIXEL SIZE 045,006  WHEN .F.
@ 025,455 SAY OemToAnsi("Hr Termino")            OF oDlg PIXEL SIZE 045,006
@ 025,485 MSGET _chter                           OF oDlg PIXEL SIZE 010,006 picture "99:99"  WHEN .F.

@ 040,010 SAY OemToAnsi("Equipamento")           OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 040,045 MSGET _cPrdOs                          OF oDlg PIXEL SIZE 070,006 F3 "SB1" VALID VRPROD()
	@ 040,120 MSGET _cDPrdOs                         OF oDlg PIXEL SIZE 195,006 WHEN .F.
else
	@ 040,045 MSGET _cPrdOs                          OF oDlg PIXEL SIZE 070,006 when .f.
	@ 040,120 MSGET _cDPrdOs                         OF oDlg PIXEL SIZE 195,006 WHEN .F.
endif


@ 040,320 SAY OemToAnsi("Atendimento")            OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 040,355 MSGET _catend                           OF oDlg PIXEL SIZE 045,006 F3 "SUA"
else
	@ 040,355 MSGET _catend                           OF oDlg PIXEL SIZE 045,006 when .f.
endif

@ 040,405 SAY OemToAnsi("Pedido")                 OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 040,425 MSGET _cPedve                           OF oDlg PIXEL SIZE 045,006 F3 "SC5"
else
	@ 040,425 MSGET _cPedve                           OF oDlg PIXEL SIZE 045,006 when .f.
endif


//@ 040,475 SAY OemToAnsi("Ord.Producao")           OF oDlg PIXEL SIZE 045,006
//If _nmnu = 3  //inclusao
//	@ 040,515 MSGET _cOrdPr                           OF oDlg PIXEL SIZE 045,006 F3 "SC2"
//else
//	@ 040,515 MSGET _cOrdPr                           OF oDlg PIXEL SIZE 045,006 when .f.
//endif

@ 055,010 SAY OemToAnsi("Defeito")                OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 055,045 MSGET _cDefOs                           OF oDlg PIXEL SIZE 350,006
else
	@ 055,045 MSGET _cDefOs                           OF oDlg PIXEL SIZE 350,006 when .f.
endif

@ 055,405 SAY OemToAnsi("Operecao")               OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 055,440 MSCOMBOBOX ooper VAR coper ITEMS aoper  OF oDlg PIXEL SIZE 055,050
Else
	@ 055,440 MSCOMBOBOX ooper VAR coper ITEMS aoper  OF oDlg PIXEL SIZE 055,050 when .f.
Endif


@ 055,520 SAY OemToAnsi("Gera OP")               OF oDlg PIXEL SIZE 045,006
If _nmnu = 3  //inclusao
	@ 055,550 MSCOMBOBOX ooger VAR _cGerOp ITEMS aOpGr  OF oDlg PIXEL SIZE 055,050
Else
	@ 055,550 MSCOMBOBOX ooger VAR _cGerOp ITEMS aOpGr  OF oDlg PIXEL SIZE 055,050 when .f.
Endif


@ 070,010 SAY OemToAnsi("Vendedor")              OF oDlg PIXEL SIZE 045,006
@ 070,045 MSGET cvend                            OF oDlg PIXEL SIZE 070,006 WHEN .F.
@ 070,120 MSGET cNOMEV                           OF oDlg PIXEL SIZE 195,006 WHEN .F.

@ 072,320 SAY OemToAnsi("Operador")              OF oDlg PIXEL SIZE 045,006
@ 072,355 MSGET COPEX                            OF oDlg PIXEL SIZE 070,006 WHEN .F.
@ 072,430 MSGET CNOMX                            OF oDlg PIXEL SIZE 195,006 WHEN .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area do rodape da rotina                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFolder := TFolder():New(091,004,aTitles,aPages,oDlg,,,, .T., .F.,646,190,)

//acerto no folder para nao perder o foco
For nX := 1 to Len(oFolder:aDialogs)
	DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nX]
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Folder de modificacao                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFolder:aDialogs[1]:oFont := oDlg:oFont
// Campos do Grid Contatos
aHeadSZD  := {}
acolSZD   := {}
if _nvis = 1
	nOpc   := 0
else
	nOpc   := GD_INSERT+GD_DELETE+GD_UPDATE
endif
nusado    := 0

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZD")
While !Eof() .And. SX3->X3_ARQUIVO == "SZD"
	
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		Aadd(aHeadSZD   , { AllTrim(X3Titulo()),SX3->X3_CAMPO  ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID      ,SX3->X3_USADO  ,SX3->X3_TIPO   ,SX3->X3_F3     ,SX3->X3_CONTEXT,;
		X3Cbox()           ,SX3->X3_RELACAO,".T."})
		nUsado++
	EndIf
	dbSelectArea("SX3")
	dbSkip()
End
If _nmnu = 3  //inclusao
	
	aAuxSZD := {}
	For nX := 1 to Len(aheadSZD)
		IF ALLTRIM(aheadSZD[NX,8])=="C"
			Aadd(aAuxSZD,SPACE(aheadSZD[NX,4]))
		ELSEIF ALLTRIM(aheadSZD[NX,8])=="N"
			Aadd(aAuxSZD,0)
		ELSEIF ALLTRIM(aheadSZD[NX,8])=="D"
			Aadd(aAuxSZD,CTOD("  /  /  "))
		ENDIF
	Next nX
	
	Aadd(aAuxSZD,.F.)
	Aadd(aColSZD,aAuxSZD)
else
	// SELECT dos CONTATOS DA EMPRESA CONTRIBUINTE
	cquer5 := ""
	cquer5 := "SELECT * "
	cquer5 += " FROM "+RetSqlName("SZD")+" SZD"
	cquer5 += " WHERE SZD.D_E_L_E_T_ = '' AND ZD_IDOS = '"+_cNros+"'"
	
	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuer5 NEW ALIAS "QUER5"
	
	// Arquivo Temporario resultado do Select nas tabelas: Socio,Endereco,Empresa
	DBSELECTAREA("QUER5")
	DBGOTOP()
	While !Eof()
		aAuxSZD := {}
		
		_cCT1  := quer5->ZD_QTDSAI
		_cCT2  := quer5->ZD_PRODUTO
		_cCT3  := quer5->ZD_DESCSAI
		_CCTA  := quer5->ZD_SLDSAI
		_cCT4  := quer5->ZD_QTDEENT
		_cCT5  := quer5->ZD_PRODENT
		_cCT6  := quer5->ZD_DESCENT
		_CCTB  := quer5->ZD_SLDENT
		_CCTC  := quer5->ZD_OP
		_CCT7  := quer5->ZD_OBS
		_CCT8  := quer5->ZD_TPOPERA
		
		
		AADD(aAuxSZD ,_cCT1)
		AADD(aAuxSZD ,_cCT2)
		AADD(aAuxSZD ,_cCT3)
		AADD(aAuxSZD ,_cCTA)
		AADD(aAuxSZD ,_cCT4)
		AADD(aAuxSZD ,_cCT5)
		AADD(aAuxSZD ,_cCT6)
		AADD(aAuxSZD ,_cCTB)
		AADD(aAuxSZD ,_cCTC)
		AADD(aAuxSZD ,_cCT7)
		AADD(aAuxSZD ,_cCT8)
		AADD(aAuxSZD ,.F.)
		
		Aadd(aColSZD,aAuxSZD)
		
		DbSkip()
	End
	
	DBSELECTAREA("QUER5")
	DBCLOSEAREA()
	
endif

// Monta Grid de Contatos Vazio.
oOcorSZD := MsNewGetDados():New(000,000,175,645,nOpc,"U_ASZDLinOk","U_ASZDTUDOK","",,,999,"AllwaysTrue","","AllwaysTrue",oFolder:aDialogs[1],aHeadSZD,acolSZD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Folder de dados                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFolder:aDialogs[2]:oFont := oDlg:oFont
// Campos do Grid Contatos
aHeadSZB  := {}
acolSZB   := {}

if _nvis = 1
	nOpc   := 0
else
	nOpc   := GD_INSERT+GD_DELETE+GD_UPDATE
endif
nusado    := 0

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZB")
While !Eof() .And. SX3->X3_ARQUIVO == "SZB"
	
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		Aadd(aHeadSZB   , { AllTrim(X3Titulo()),SX3->X3_CAMPO  ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID      ,SX3->X3_USADO  ,SX3->X3_TIPO   ,SX3->X3_F3     ,SX3->X3_CONTEXT,;
		X3Cbox()           ,SX3->X3_RELACAO,".T."})
		nUsado++
	EndIf
	dbSelectArea("SX3")
	dbSkip()
End

If _nmnu = 3  //inclusao
	aAuxSZB := {}
	
	For nX := 1 to Len(aheadSZB)
		IF ALLTRIM(aheadSZB[NX,8])=="C"
			Aadd(aAuxSZB,SPACE(aheadSZB[NX,4]))
		ELSEIF ALLTRIM(aheadSZB[NX,8])=="N"
			Aadd(aAuxSZB,0.00)
		ENDIF
	Next nX
	
	Aadd(aAuxSZB,.F.)
	Aadd(aColSZB,aAuxSZB)
	
ELSE
	
	// SELECT dos CONTATOS DA EMPRESA CONTRIBUINTE
	cquer3 := ""
	cquer3 := "SELECT ZB_SERVICO,ZB_DESCSR,ZB_QTDADE,ZB_PRODUTO,ZB_DESCRIC,ZB_OBS"
	cquer3 += " FROM "+RetSqlName("SZB")+" SZB"
	cquer3 += " WHERE SZB.D_E_L_E_T_ = '' AND ZB_IDOS = '"+_cNros+"'"
	
	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuer3 NEW ALIAS "QUER3"
	
	// Arquivo Temporario resultado do Select nas tabelas: Socio,Endereco,Empresa
	DBSELECTAREA("QUER3")
	DBGOTOP()
	While !Eof()
		aAuxSZB := {}
		
		_cCT1  := quer3->ZB_SERVICO
		_cCT2  := quer3->ZB_DESCSR
		_cCT3  := quer3->ZB_QTDADE
		_cCT4  := quer3->ZB_PRODUTO
		_CCT5  := quer3->ZB_DESCRIC
		_CCT6  := quer3->ZB_OBS
		
		AADD(aAuxSZB ,_cCT1)    // Numerio do Telefone
		AADD(aAuxSZB ,_cCT2)    // Tipo
		AADD(aAuxSZB ,_cCT3)    // PRODUTO
		AADD(aAuxSZB ,_cCT4)    // Descrição
		AADD(aAuxSZB ,_cCT5)    // OBS
		AADD(aAuxSZB ,_cCT6)    // OBS
		AADD(aAuxSZB ,.F.)
		
		Aadd(aColSZB,aAuxSZB)
		DbSkip()
	End
	
	DBSELECTAREA("QUER3")
	DBCLOSEAREA()
ENDIF

// Monta Grid.
oOcorSZB := MsNewGetDados():New(000,000,175,645,nOpc,"U_ASZBLinOk","AllwaysTrue","",,,999,"AllwaysTrue","","AllwaysTrue",oFolder:aDialogs[2],aHeadSZB,acolSZB)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Folder de TESTE                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFolder:aDialogs[3]:oFont := oDlg:oFont
// Campos do Grid Contatos
aHeadSZC  := {}
acolSZC   := {}
if _nvis = 1
	nOpc   := 0
else
	nOpc   := GD_INSERT+GD_DELETE+GD_UPDATE
endif
nusado    := 0

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZC")
While !Eof() .And. SX3->X3_ARQUIVO == "SZC"
	
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		Aadd(aHeadSZC   , { AllTrim(X3Titulo()),SX3->X3_CAMPO  ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID      ,SX3->X3_USADO  ,SX3->X3_TIPO   ,SX3->X3_F3     ,SX3->X3_CONTEXT,;
		X3Cbox()           ,SX3->X3_RELACAO,".T."})
		nUsado++
	EndIf
	dbSelectArea("SX3")
	dbSkip()
End
If _nmnu = 3  //inclusao
	aAuxSZC := {}
	For nX := 1 to Len(aheadSZC)
		IF ALLTRIM(aheadSZC[NX,8])=="C"
			Aadd(aAuxSZC,SPACE(aheadSZC[NX,4]))
		ELSEIF ALLTRIM(aheadSZC[NX,8])=="N"
			Aadd(aAuxSZC,0)
		ELSEIF ALLTRIM(aheadSZC[NX,8])=="D"
			Aadd(aAuxSZC,CTOD("  /  /  "))
		ENDIF
	Next nX
	
	Aadd(aAuxSZC,.F.)
	Aadd(aColSZC,aAuxSZC)
Else
	
	// SELECT dos CONTATOS DA EMPRESA CONTRIBUINTE
	cquer4 := ""
	cquer4 := "SELECT * "
	cquer4 += " FROM "+RetSqlName("SZC")+" SZC"
	cquer4 += " WHERE SZC.D_E_L_E_T_ = '' AND ZC_IDOS = '"+_cNros+"'"
	
	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuer4 NEW ALIAS "QUER4"
	
	// Arquivo Temporario resultado do Select nas tabelas: Socio,Endereco,Empresa
	DBSELECTAREA("QUER4")
	DBGOTOP()
	While !Eof()
		aAuxSZC := {}
		
		_cCT1  := quer4->ZC_TESTE
		_cCT2  := quer4->ZC_VAZAO
		_cCT3  := quer4->ZC_RPM
		_cCT4  := quer4->ZC_PRES001
		_cCT5  := quer4->ZC_PRES002
		_cCT6  := quer4->ZC_PRES003
		_cCT7  := quer4->ZC_PRES004
		_cCT8  := quer4->ZC_PRES005
		_cCT9  := quer4->ZC_DRENO
		_cCT10 := quer4->ZC_VALALIV
		_cCT11 := quer4->ZC_PILOTO
		_cCT12 := quer4->ZC_PRESCAR
		_cCT13 := quer4->ZC_TEMPERA
		_cCT14 := stod(quer4->ZC_DTINICI)
		_cCT15 := quer4->ZC_HRINI
		_cCT16 := stod(quer4->ZC_DTFIM)
		_cCT17 := quer4->ZC_HRFIM
		_cCT18 := quer4->ZC_HRREAL
		_cCT19 := quer4->ZC_OUTROS
		
		AADD(aAuxSZC ,_cCT1)
		AADD(aAuxSZC ,_cCT2)
		AADD(aAuxSZC ,_cCT3)
		AADD(aAuxSZC ,_cCT4)
		AADD(aAuxSZC ,_cCT5)
		AADD(aAuxSZC ,_cCT6)
		AADD(aAuxSZC ,_cCT7)
		AADD(aAuxSZC ,_cCT8)
		AADD(aAuxSZC ,_cCT9)
		AADD(aAuxSZC ,_cCT10)
		AADD(aAuxSZC ,_cCT11)
		AADD(aAuxSZC ,_cCT12)
		AADD(aAuxSZC ,_cCT13)
		AADD(aAuxSZC ,_cCT14)
		AADD(aAuxSZC ,_cCT15)
		AADD(aAuxSZC ,_cCT16)
		AADD(aAuxSZC ,_cCT17)
		AADD(aAuxSZC ,_cCT18)
		AADD(aAuxSZC ,_cCT19)
		AADD(aAuxSZC ,.F.)
		
		Aadd(aColSZC,aAuxSZC)
		
		DbSkip()
	End

	DBSELECTAREA("QUER4")
	DBCLOSEAREA()
Endif

// Monta Grid de Contatos Vazio.
oOcorSZC := MsNewGetDados():New(000,000,175,645,nOpc,"AllwaysTrue","AllwaysTrue","",,,999,"AllwaysTrue","","AllwaysTrue",oFolder:aDialogs[3],aHeadSZC,acolSZC)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Folder de RELATORIO                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFolder:aDialogs[4]:oFont := oDlg:oFont
// Campos do Grid Contatos
aHeadSZE  := {}
acolSZE   := {}
cUsuMAST := Getmv("MV_USUMAS")

IF RetCodUsr() $ cUsuMAST
	nOpc   := GD_INSERT+GD_DELETE+GD_UPDATE
Else
	nOpc   := 0
Endif

nusado    := 0        


dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZE")
While !Eof() .And. SX3->X3_ARQUIVO == "SZE"
	
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		Aadd(aHeadSZE   , { AllTrim(X3Titulo()),SX3->X3_CAMPO  ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID      ,SX3->X3_USADO  ,SX3->X3_TIPO   ,SX3->X3_F3     ,SX3->X3_CONTEXT,;
		X3Cbox()           ,SX3->X3_RELACAO,".T."})
		nUsado++
	EndIf
	dbSelectArea("SX3")
	dbSkip()
End

If _nmnu = 3  //inclusao
	
	aAuxSZE := {}
	For nX := 1 to Len(aheadSZE)
		IF ALLTRIM(aheadSZE[NX,8])=="C"
			Aadd(aAuxSZE,SPACE(aheadSZE[NX,4]))
		ELSEIF ALLTRIM(aheadSZE[NX,8])=="N"
			Aadd(aAuxSZE,0)
		ELSEIF ALLTRIM(aheadSZE[NX,8])=="D"
			Aadd(aAuxSZE,CTOD("  /  /  "))
		ENDIF
	Next nX
	
	Aadd(aAuxSZE,.F.)
	Aadd(aColSZE,aAuxSZE)
ELSE
	
	// SELECT dos CONTATOS DA EMPRESA CONTRIBUINTE
	cquer6 := ""
	cquer6 := "SELECT * "
	cquer6 += " FROM "+RetSqlName("SZE")+" SZE"
	cquer6 += " WHERE SZE.D_E_L_E_T_ = '' AND ZE_IDOS = '"+_cNros+"'"
	cquer6 += " ORDER BY ZE_DTFIM+ZE_HORAFIM "
	
	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuer6 NEW ALIAS "QUER6"
	
	// Arquivo Temporario resultado do Select nas tabelas: Socio,Endereco,Empresa
	DBSELECTAREA("QUER6")
	DBGOTOP()
	While !Eof()
		aAuxSZE := {}
		
		_cCT1  := stod(quer6->ZE_EMISSAO)
		_cCT2  := quer6->ZE_HORAINI
		_cCT3  := stod(quer6->ZE_DTFIM)
		_cCT4  := quer6->ZE_HORAFIM
		_cCT5  := quer6->ZE_FUNC
		_cCT6  := quer6->ZE_NOME
		_cCT7  := quer6->ZE_OBS
		
		AADD(aAuxSZE ,_cCT1)
		AADD(aAuxSZE ,_cCT2)
		AADD(aAuxSZE ,_cCT3)
		AADD(aAuxSZE ,_cCT4)
		AADD(aAuxSZE ,_cCT5)
		AADD(aAuxSZE ,_cCT6)
		AADD(aAuxSZE ,_cCT7)
		AADD(aAuxSZE ,.F.)
		
		Aadd(aColSZE,aAuxSZE)
		
		DbSkip()
	End
	
	DBSELECTAREA("QUER6")
	DBCLOSEAREA()
ENDIF

// Monta Grid de Contatos Vazio.
oOcorSZE := MsNewGetDados():New(000,000,175,645,nOpc,"AllwaysTrue","AllwaysTrue","",,,999,"AllwaysTrue","","AllwaysTrue",oFolder:aDialogs[4],aHeadSZE,acolSZE)

// Grupo de Botões do Cabeçalho da tela Principal
SButton():New(025, 610, 01, {|| Executa(_nmnu)    },,.T.,"Cofirma")
SButton():New(040, 610, 02, {|| oDlg:End()   },,.T.,"Cancela")
//SButton():New(020, 405, 11, {|| Contremail() },,.T.,"E_mail")
ACTIVATE DIALOG oDlg CENTER
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função do Botão(OK) do Cabeçalho da tela Principal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Executa(_nmnu)

local nCntFor
local nCntFor2
// TABELA SZA --> CABECALHO
_LGRVSZA := .T.

// validacoes de inclusao !!!
If Empty(coper)
	MsgAlert("O campo de Operacao, está em branco. Favor Preencher para dar continuidade !!!", "CAMPO OPERACAO - EM BRANCO")
	return
Endif

If Empty(_cGerOp)
	MsgAlert("O campo de Gera OP, está em branco. Favor Preencher para dar continuidade !!!", "CAMPO GERA OP - EM BRANCO")
	return
Endif

If Empty(_cNomOs)
	MsgAlert("O campo de Cliente, está em branco. Favor Preencher para dar continuidade !!!", "CAMPO CLIENTE - EM BRANCO")
	return
Endif

If Empty(_dtprv)
	MsgAlert("O campo de Data Previsão, está em branco. Favor Preencher para dar continuidade !!!", "CAMPO DT.PREVISAO - EM BRANCO")
	return
Endif

// inclusao ==> VALIDACAO DA ABA DE MOVIMENTACAO
If _nmnu = 3
	_lvldin := u_ASZDTUDOk()
	if !_lvldin
		return
	endif
endif


// visualizar
If _nmnu = 1
	oDlg:End()
	Return
Endif


// Exclusao                 2
If _nmnu = 5
	DBSELECTAREA("SZA")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL()+_cNros)
		DBSELECTAREA("SZA")
		RECLOCK("SZA",.f.)
		DbDelete()
		MsUnLock("SZA")
	ENDIF
	
	DBSELECTAREA("SZB")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZB")+_cNros)
		WHILE !EOF() .AND. SZB->ZB_IDOS == _cNros
			DBSELECTAREA("SZB")
			RECLOCK("SZB",.f.)
			DbDelete()
			MsUnLock("SZB")
			DBSKIP()
			LOOP
		END
	ENDIF
	
	DBSELECTAREA("SZC")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZC")+_cNros)
		WHILE !EOF() .AND. SZC->ZC_IDOS == _cNros
			DBSELECTAREA("SZC")
			RECLOCK("SZC",.f.)
			DbDelete()
			MsUnLock("SZC")
			DBSKIP()
			LOOP
		END
	ENDIF
	
	DBSELECTAREA("SZD")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZD")+_cNros)
		WHILE !EOF() .AND. SZD->ZD_IDOS == _cNros
			DBSELECTAREA("SZD")
			RECLOCK("SZD",.f.)
			DbDelete()
			MsUnLock("SZD")
			DBSKIP()
			LOOP
		END
	ENDIF
	
	DBSELECTAREA("SZE")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZE")+_cNros)
		WHILE !EOF() .AND. SZE->ZE_IDOS == _cNros
			DBSELECTAREA("SZE")
			RECLOCK("SZE",.f.)
			DbDelete()
			MsUnLock("SZE")
			DBSKIP()
			LOOP
		END
	ENDIF
	
	oDlg:End()
	Return
Endif


// PROCESSO DE INCLUSAO DOS DADOS !!!!
DBSELECTAREA("SZA")
DBSETORDER(1)
IF DBSEEK(XFILIAL()+_cNros)
	_LGRVSZA := .F.
ELSE
	_LGRVSZA := .T.
ENDIF

DBSELECTAREA("SZA")
RECLOCK("SZA",_LGRVSZA)
ZA_FILIAL    := XFILIAL("SZA")
ZA_IDOS      := _cNros
ZA_CLIENTE   := _cCliOs
ZA_LOJA      := _cLojOs
ZA_NOME      :=  _cNomOs
ZA_PLANILH   := _CPLAOS
ZA_EMISSAO   := _dEmiOs
ZA_HORAINI   := _chini
ZA_HORAPRV   := _chprv
ZA_EQUIPAM   := _cPrdOs
ZA_DESCEP    := _cDPrdOs
ZA_DEFEITO   := _cDefOs
ZA_NFE       := _cDocOs
ZA_SERIE     := _cSerOs
ZA_DTINICI   := _Dtini
ZA_DTPREVI   := _dtPrv
ZA_PEDVEND   := _cPedve
ZA_OP        := _cOrdPr
ZA_TIPO      := SUBSTR(COPER,1,1)
ZA_VEND      := CVEND
ZA_NOMVED    := CNOMEV
ZA_OPERADO   := COPEX
ZA_NOMEOPE   := CNOMX
ZA_GERAOP    := SUBSTR(_cGerOp,1,1)

If !SUBSTR(COPER,1,1) $ "7/8"
	IF _nmnu = 3  // inclusao de os
		ZA_STATUS    := IIF(SUBSTR(_cGerOp,1,1)="S","B","")
	ENDIF
ElseIf SUBSTR(COPER,1,1) $ "7"  // os da fabrica
	IF _nmnu = 3  // inclusao de os
		ZA_STATUS    := "O"
	endif
ElseIf SUBSTR(COPER,1,1) $ "8"  // os da eletronica
	IF _nmnu = 3  // inclusao de os
		ZA_STATUS    := "W"
	endif
Endif

MSUNLOCK("SZA")

// TABELA SZB --> SERV EXECUTADO
IF LEN(oOcorSZB:ACOLS) > 0
	
	DBSELECTAREA("SZB")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZB")+_cNros)
		WHILE !EOF() .AND. SZB->ZB_IDOS == _cNros
			DBSELECTAREA("SZB")
			RECLOCK("SZB",.f.)
			DbDelete()
			MsUnLock("SZB")
			DBSKIP()
			LOOP
		END
	ENDIF
	
	// INCLUSAO DE DADOS NA TABELA SZB....
	For nCntFor := 1 To Len(oOcorSZB:ACOLS)
		If ( !oOcorSZB:aCols[nCntFor][7] )  // valida se a linha esta ativa ou nao....
			
			DBSELECTAREA("SZB")
			RECLOCK("SZB",.T.)
			For nCntFor2 := 1 To 6
				If ( oOcorSZB:aHeader[nCntFor2][10] != "V" )
					SZB->(FieldPut(FieldPos(oOcorSZB:aHeader[nCntFor2][2]),oOcorSZB:aCols[nCntFor][nCntFor2]))
				EndIf
			Next nCntFor2
			
			SZB->ZB_IDOS   := _cNros
			SZB->ZB_FILIAL := XFILIAL("SZB")
			MsUnLock("SZB")
		Endif
	Next nCntFor
ENDIF

// TABELA SZC --> TESTE
IF LEN(oOcorSZC:ACOLS) > 0
	DBSELECTAREA("SZC")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZC")+_cNros)
		WHILE !EOF() .AND. SZC->ZC_IDOS == _cNros
			DBSELECTAREA("SZC")
			RECLOCK("SZC",.f.)
			DbDelete()
			MsUnLock("SZC")
			DBSKIP()
			LOOP
		END
	ENDIF
	
	// INCLUSAO DE DADOS NA TABELA SZC....
	For nCntFor := 1 To Len(oOcorSZC:ACOLS)
		If ( !oOcorSZC:aCols[nCntFor][20] )
			DBSELECTAREA("SZC")
			RECLOCK("SZC",.T.)
			
			For nCntFor2 := 1 To 19
				If ( oOcorSZC:aHeader[nCntFor2][10] != "V" )
					SZC->(FieldPut(FieldPos(oOcorSZC:aHeader[nCntFor2][2]),oOcorSZC:aCols[nCntFor][nCntFor2]))
				EndIf
			Next nCntFor2
			
			SZC->ZC_IDOS   := _cNros
			SZC->ZC_FILIAL := XFILIAL("SZC")
			MsUnLock("SZC")
		endif
	Next nCntFor
	
ENDIF

// TABELA SZD --> MODIFICACAO
IF LEN(oOcorSZD:ACOLS) > 0
	_nmdst := 0
	
	DBSELECTAREA("SZD")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZD")+_cNros)
		WHILE !EOF() .AND. SZD->ZD_IDOS == _cNros
			DBSELECTAREA("SZD")
			RECLOCK("SZD",.f.)
			DbDelete()
			MsUnLock("SZD")
			DBSKIP()
			LOOP
		END
	ENDIF
	
	// INCLUSAO DE DADOS NA TABELA SZD....
	For nCntFor := 1 To Len(oOcorSZD:ACOLS)
		If ( !oOcorSZD:aCols[nCntFor][12] )
			DBSELECTAREA("SZD")
			RECLOCK("SZD",.T.)
			
			For nCntFor2 := 1 To 11
				If ( oOcorSZD:aHeader[nCntFor2][10] != "V" )
					SZD->(FieldPut(FieldPos(oOcorSZD:aHeader[nCntFor2][2]),oOcorSZD:aCols[nCntFor][nCntFor2]))
					
					// tratamento na alteracao de gera op
					IF _nmnu = 4 .and. SUBSTR(_cGerOp,1,1) == "S" .and. SZA->ZA_STATUS == "B"
						if alltrim(oOcorSZD:aHeader[nCntFor2][2]) == "ZD_OP"
							if !Empty(alltrim(oOcorSZD:aCols[nCntFor][nCntFor2]))
								_nmdst++
							endif
						Endif
					ENDIF
				EndIf
			Next nCntFor2
			
			SZD->ZD_IDOS   := _cNros
			SZD->ZD_FILIAL := XFILIAL("SZD")
			
			MsUnLock("SZD")
		endif
	Next nCntFor
	
	// acerta status no gera op
	if _nmdst > 0
		dbselectarea("SZA")
		RECLOCK("SZA",.F.)
		SZA->ZA_STATUS := ""
		MSUNLOCK("SZA")
		
	endif
ENDIF

// TABELA SZE --> RELATORIO
IF _LGRVSZA
	DBSELECTAREA("SZE")
	RECLOCK("SZE",.T.)
	SZE->ZE_FILIAL  := XFILIAL("SZE")
	SZE->ZE_IDOS    := _cNros
	SZE->ZE_EMISSAO := _DEMIOS
	SZE->ZE_HORAINI := _CHINI
	SZE->ZE_DTFIM   := _DEMIOS
	SZE->ZE_HORAFIM := TIME()
	SZE->ZE_FUNC    := COPEX
	SZE->ZE_NOME    := CNOMX
	SZE->ZE_OBS     := "INCLUSAO"
	MsUnLock("SZE")
	
ELSE  // ALTERACAO
	
	IF RetCodUsr() $ Getmv("MV_USUMAS")
		IF LEN(oOcorSZE:ACOLS) > 0
			_nmdst := 0
			
			DBSELECTAREA("SZE")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SZE")+_cNros)
				WHILE !EOF() .AND. SZE->ZE_IDOS == _cNros
					DBSELECTAREA("SZE")
					RECLOCK("SZE",.f.)
					DbDelete()
					MsUnLock("SZE")
					DBSKIP()
					LOOP
				END
			ENDIF
			
			// INCLUSAO DE DADOS NA TABELA SZD....
			For nCntFor := 1 To Len(oOcorSZE:ACOLS)
				If ( !oOcorSZE:aCols[nCntFor][8])
					DBSELECTAREA("SZE")
					RECLOCK("SZE",.T.)
					
					For nCntFor2 := 1 To 7
						If ( oOcorSZD:aHeader[nCntFor2][10] != "V" )
							SZE->(FieldPut(FieldPos(oOcorSZE:aHeader[nCntFor2][2]),oOcorSZE:aCols[nCntFor][nCntFor2]))
						EndIf
					Next nCntFor2
					
					SZE->ZE_IDOS   := _cNros
					SZE->ZE_FILIAL := XFILIAL("SZE")
					
					MsUnLock("SZE")
				endif
			Next nCntFor
			
			// acerta status no gera op
			if _nmdst > 0
				dbselectarea("SZA")
				RECLOCK("SZA",.F.)
				SZA->ZA_STATUS := ""
				MSUNLOCK("SZA")
				
			endif
		ENDIF
	ENDIF
ENDIF

ConfirmSX8()
oDlg:End()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função de envio de e_mail do Cabeçalho da tela Principal      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Contremail(_CNRMAIL,_CPROCE,_cClimail)
Local aArea := getarea()
Local nL
Local aItemAlt  := {}
Local aItemDel  := {}
Local lResult   := .f.
Local cServer   := ""
Local cConta    := ""
Local cPassw    := ""
Local cFromAcc  := ""
Local ctoAcc    := ""
Local cSubject  := ""
Local cMsg      := ""
Local cCentCus  := ""
Local lOkCCusto := .F.
Local lRet      := .F.
Local cError    := ""
Local lProcessa := .T.
Local crlf      := chr(10)+chr(13)
Local cTab      := chr(9)

ctoAcc   := ""
cSubject := "Processo ordem de Serviço - Nr. " + _CNRMAIL + " Processo de " + _CPROCE
cMsg     :=  "<p><font size='2' face='Verdana, Arial, Helvetica, sans-serif'>Ordem de Servico nr "+_CNRMAIL+"</strong></font></p>"
cMsg     +=  "<br>"
cMsg     +=  "<p><font size='2' face='Verdana, Arial, Helvetica, sans-serif'>Cliente: "+_cClimail+"</strong></font></p>"
cMsg     +=  "<br>"
cMsg     +=  "<p><font size='2' face='Verdana, Arial, Helvetica, sans-serif'>Processo de "+_CPROCE+"</strong></font></p>"
cMsg     +=  "<br>"
cMsg     +=  "<p><font size='2' face='Verdana, Arial, Helvetica, sans-serif'>Mensagem enviado pelo Operador: "+SUBSTR(CUSUARIO,7,15)+"."+"</strong></font></p>"
cMsg     +=  "<br>"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rotina de Geracao de Email.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cServer  := nil
cConta   := nil
cPassw   := nil
cFromAcc := nil
lResult  := ACSendMail( , , , , cToAcc, cSubject, cMsg)

restArea(aArea)
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ACSendMail³ Autor ³ Gustavo Henrique     ³ Data ³ 22/01/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para o envio de emails                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Conta para conexao com servidor SMTP                 ³±±
±±³          | ExpC2 : Password da conta para conexao com o servidor SMTP   ³±±
±±³          ³ ExpC3 : Servidor de SMTP                                     ³±±
±±³          ³ ExpC4 : Conta de origem do e-mail. O padrao eh a mesma conta ³±±
±±³          ³         de conexao com o servidor SMTP.                      ³±±
±±³          ³ ExpC5 : Conta de destino do e-mail.                          ³±±
±±³          ³ ExpC6 : Assunto do e-mail.                                   ³±±
±±³          ³ ExpC7 : Corpo da mensagem a ser enviada.               	    |±±
±±³          | ExpC8 : Patch com o arquivo que serah enviado                |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ACSendMail(cAccount,cPassword,cServer,cFrom,cEmail,cAssunto,cMensagem,cAttach)

Local cEmailTo := ""
Local cEmailBcc:= ""
Local lResult  := .F.
Local cError   := ""
Local i        := 0
Local cArq     := ""

// Verifica se serao utilizados os valores padrao.
cAccount	:= Iif( cAccount  == NIL, GetMV( "MV_RELACNT" ), cAccount  )
cPassword	:= Iif( cPassword == NIL, GetMV( "MV_RELPSW"  ), cPassword )
cServer		:= Iif( cServer   == NIL, GetMV( "MV_RELSERV" ), cServer   )
cAttach 	:= Iif( cAttach == NIL, "", cAttach )


cEmailTo := "r_cavalini@terra.com.br"
cEmailBcc:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe o SMTP Server³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cServer)
	Help(" ",1,"O Servidor de SMTP nao foi configurado !!!" ,"Atencao")
	Return(.F.)
EndIf

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

If lResult
	cFrom	:= "r_cavalini@terra.com.br"
	
	SEND MAIL FROM cFrom ;
	TO      	cEmailTo;
	BCC     	cEmailBcc;
	SUBJECT 	cAssunto;
	BODY    	cMensagem FORMAT TEXT;
	RESULT lResult
	
	If !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
	EndIf
	
	DISCONNECT SMTP SERVER
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
EndIf

Return(lResult)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Marco Bianchi         ³ Data ³01/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados         ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()

aSZAALM:= { {"Separar"      ,"u_OSSEPARA()"    ,0,5,0,NIL} ,;
			{"Recusar"      ,"u_OSRECUSA(1)"   ,0,5,0,NIL} ,;
			{"Pendente"     ,"u_OSPENDEN(1)"   ,0,5,0,NIL} ,;
			{"Encerrar"     ,"u_OSENCERR(1)"   ,0,5,0,NIL} ,;
			{"Estorno Sep"  ,"u_OSESTORN()"    ,0,5,0,NIL}}

aSZAFAB:= { {"Apontar"      ,"u_OSAPONTA()"    ,0,5,0,NIL} ,;
			{"Pendente"     ,"u_OSPENDEN(2)"   ,0,5,0,NIL} ,;
			{"Recusar"      ,"u_OSRECUSA(2)"   ,0,5,0,NIL} ,;
			{"Encerrar"     ,"u_OSENCERR(2)"   ,0,5,0,NIL}}

aSZAELE:= { {"Apontar"      ,"u_OSAPONTA()"    ,0,5,0,NIL} ,;
			{"Pendente"     ,"u_OSPENDEN(2)"   ,0,5,0,NIL} ,;
			{"Recusar"      ,"u_OSRECUSA(2)"   ,0,5,0,NIL} ,;
			{"Encerrar"     ,"u_OSENCERR(2)"   ,0,5,0,NIL}}


IF RetCodUsr() $ Getmv("MV_USUMAS") //"000000/000174/000019/000181" 
	aSZAMNT:= { {"Funcionarios" ,"u_OSFUNCIO()"    ,0,5,0,NIL} ,;
				{"Servicos"     ,"u_OSSERVIC()"    ,0,5,0,NIL} ,;
				{"Enc. OS"      ,"u_OSENCERR(3)"   ,0,5,0,NIL} ,;
				{"Estorno Enc." ,"u_OSESTENC()"    ,0,5,0,NIL}}
else
	aSZAMNT:= {{"Funcionarios" ,"u_OSFUNCIO(1)"    ,0,5,0,NIL}}
endif



Private aRotina := {{ "Pesquisar"   ,"AxPesqui"         ,0,1,0,.F.},;
					{ "Visualizar"  ,"u_ZOrdServ(1)"	,0,2,0,NIL},;
					{ "Incluir"     ,"u_ZOrdServ(3)"	,0,3,0,NIL},;
					{ "Alterar"     ,"u_ZOrdServ(4)"	,0,4,0,NIL},;
					{ "Excluir"     ,"u_ZOrdServ(5)"	,0,5,0,NIL},;
					{ "Imprimir"    ,"u_OSIMPSV()"   	,0,5,0,NIL},;
					{ "Aprovar"     ,"u_OSAPROVA()"  	,0,5,0,NIL},;
					{ "Almox."      ,aSZAALM            ,0,5,0,NIL},;
					{ "Fabrica"     ,aSZAFAB      	    ,0,5,0,NIL},;
					{ "Eletronica"  ,aSZAELE      	    ,0,5,0,NIL},;
					{ "Manutenção"  ,aSZAMNT         	,0,5,0,NIL},;
					{ "Legenda"     ,"u_LEGM80()"       ,0,5,0,NIL} }
Return(aRotina)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³          ³ Autor ³ Ricardo Cavalini      ³ Data ³20/12/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcoes genericas usadas nos folder. Funcoes tais          ³±±
±±³          ³ validação, preenchimento de telas, etc....                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// -------------- CAMPOS DOS CABECALHO ------------------------------- //
// FUNCAO PARA PREENCHER O NOME DO CLIENTE TELA PRINCIPAL - CABECALHO
Static Function VRNOME()
_cNomOs  := POSICIONE("SA1",1,xFILIAL("SA1")+_cCliOs,"A1_NOME")
cvend    := POSICIONE("SA1",1,xFILIAL("SA1")+_cCliOs,"A1_VEND")
cnomEv   := POSICIONE("SA3",1,xFILIAL("SA3")+cvend,"A3_NOME")
COPEX    := RetCodUsr() //Retorna o Codigo do Usuario
CNOMX    := UsrRetName( COPEX )//Retorna o nome do usuario

IF EMPTY(_cNomOs)
	MSGALERT("Cliente não cadastrado...", "Verificar o Cliente informado !!!")
ENDIF

Return


// FUNCAO PARA PREENCHER A DESCRICAO DO PRODUTO TELA PRINCIPAL - CABECALHO
Static Function VRPROD()
_cDPrdOs := POSICIONE("SB1",1,xFILIAL("SB1")+_cPrdOs,"B1_DESC")
Return
// ------------------ FIM CAMPOS DOS CABECALHOS --------------------- //

// FUNCAO NA VALIDACAO DA LINHA DO FOLDER SERV. EXECUTADO
USER FUNCTION ASZBLinOk()
lSZB2 := .T.
_cPosSrv   := ascan(aHeadSZB,{|_vAux|alltrim(_vAux[2])=="ZB_SERVICO"})
_nPosQtd   := ascan(aHeadSZB,{|_vAux|alltrim(_vAux[2])=="ZB_QTDADE"})
_cCodSrv   := acolS[n,_cPosSrv]
_nQtdSrv   := acolS[n,_nPosQtd]

// valida campo servico, que deve estar preenchido
IF EMPTY(_cCodSrv)
	MSGALERT("Campo de Servico não esta preenchido !!!", "IMPORTANTE")
	lSZB2 := .F.
ENDIF

// valida campo quantidade de servicos, nao pode ser zerado.... quando preenchido o servico
IF !EMPTY(_cCodSrv) .and. _nQtdSrv = 0
	MSGALERT("Campo de Quantidade não esta preenchido !!!", "IMPORTANTE")
	lSZB2 := .F.
ENDIF
oOcorSZB:Refresh()
Return lSZB2
// -----------------------------  FIM FOLDER SERV EXECUTADO  -------------------------- //

// FUNCAO NA VALIDACAO DA LINHA DO FOLDER MODIFICACAO
USER FUNCTION ASZDLinOk()
lSZD2 := .T.
// coluna de saida
_nPosS01   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_SLDSAI"})
_nPosP01   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_PRODUTO"})
_nPosD01   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_DESCSAI"})
_nPosQ01   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_QTDSAI"})
_nQtdS01   := oOcorSZD:acolS[n,_nPosS01]
_cPrdS01   := oOcorSZD:acolS[n,_nPosP01]
_nREQQ01   := oOcorSZD:acolS[n,_nPosQ01]
_cdeserr   := oOcorSZD:acolS[n,_nPosd01]

// coluna de entrada
_nPosP02   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_PRODENT"})
_nPosD02   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_DESCENT"})
_nPosQ02   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_QTDEENT"})
_cPrdS02   := oOcorSZD:acolS[n,_nPosP02]
_nDEQQ02   := oOcorSZD:acolS[n,_nPosQ02]
_cdeser2   := oOcorSZD:acolS[n,_nPosd02]


// valida campo servico, que deve estar preenchido
IF _nQtdS01 <= 0 .and. !Empty(_cPrdS01)
	MSGALERT("O produto escolhido, na saida, nao apresenta saldo !!!", "Atenção - Saida - Lok !!!")
	oOcorSZD:acolS[n,_nPosP01] := SPACE(15)
	oOcorSZD:acolS[n,_nPosD01] := SPACE(50)
	oOcorSZD:acolS[n,_nPosQ01] := 0
	lSZD2 := .F.
ENDIF

// valida campo servico, que deve estar preenchido - SAIDA
IF _nREQQ01 = 0 .and. !Empty(_cPrdS01)
	MSGALERT("Não foi informado a quantidade na saida deste produto !!!", "Atenção - Saida - Lok !!!")
	lSZD2 := .F.
ENDIF


// valida campo servico, que deve estar preenchido - ENTRADA
IF _nDEQQ02 = 0 .and. !Empty(_cPrdS02)
	MSGALERT("Não foi informado a quantidade na Entrada deste produto !!!", "Atenção - Entrada - Lok !!!")
	lSZD2 := .F.
ENDIF


// valida campo servico, que deve estar preenchido - saida
IF !Empty(_cdeserr) .and. Empty(_cPrdS01)
	MSGALERT("Não foi informado o produto, somente a descricao na saida deste produto !!!", "Atenção - Saida - Lok !!!")
	lSZD2 := .F.
ENDIF


// valida campo servico, que deve estar preenchido - entrada
IF !Empty(_cdeser2) .and. Empty(_cPrdS02)
	MSGALERT("Não foi informado o produto, somente a descricao na Entrada deste produto !!!", "Atenção - Entrada - Lok !!!")
	lSZD2 := .F.
ENDIF


// valida campo servico, que deve estar preenchido - saida
IF _nREQQ01 > 0 .and. Empty(_cPrdS01)
	MSGALERT("Não foi informado o produto na saida !!!", "Atenção - Saida - Lok !!!")
	lSZD2 := .F.
ENDIF

// valida campo servico, que deve estar preenchido
IF _nDEQQ02 > 0 .and. Empty(_cPrdS02)
	MSGALERT("Não foi informado o produto na Entrada !!!", "Atenção - Entrada - Lok !!!")
	lSZD2 := .F.
ENDIF




oOcorSZD:Refresh()
Return lSZD2

// -------------------------------------------------
// FUNCAO NA VALIDACAO DA TODO O FOLDER MODIFICACAO
USER FUNCTION ASZDTUDOk()

local ii
lSZD2T := .T.

// Verifica se máquina informada existe
For ii:= 1 to len(oOcorSZD:aCols)
	
	If !oOcorSZD:aCols[ii][12]
		
		_nPosS01   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_SLDSAI"})
		_nPosP01   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_PRODUTO"})
		_nPosD01   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_DESCSAI"})
		_nPosQ01   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_QTDSAI"})
		
		_nPosS02   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_SLDENT"})
		_nPosP02   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_PRODENT"})
		_nPosD02   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_DESCENT"})
		_nPosQ02   := ascan(aHeadSZD,{|_vAux|alltrim(_vAux[2])=="ZD_QTDEENT"})
		
		
		_nQtdS01   := oOcorSZD:acolS[ii,_nPosS01] // SALDO SAIDA
		_cPrdS01   := oOcorSZD:acolS[ii,_nPosP01] // PRODUTO SAIDA
		_nREQQ01   := oOcorSZD:acolS[ii,_nPosQ01] // QTDE SAIDA
		_cdeserr   := oOcorSZD:acolS[ii,_nPosd01]
		
		
		_cPrdS02   := oOcorSZD:acolS[ii,_nPosP02]  // produto entrada
		_cDesc02   := oOcorSZD:acolS[ii,_nPosD02]  // descricao entrada
		_nREQQ02   := oOcorSZD:acolS[ii,_nPosQ02]  // qtde entrada
		
		
		IF _nQtdS01 <= 0 .and. !Empty(_cPrdS01)
			MSGALERT("Existe produto que não apresenta saldo !!!", "Atenção - Saida !!!")
			lSZD2T := .F.
		ENDIF
		
		// valida campo servico, que deve estar preenchido
		IF _nREQQ01 = 0 .and. !Empty(_cPrdS01)
			MSGALERT("Não foi informado a quantidade na saida do produto !!!", "Atenção - Saida !!!")
			lSZD2T := .F.
		ENDIF
		
		// valida campo servico, que deve estar preenchido
		IF !Empty(_cdeserr) .and. Empty(_cPrdS01)
			MSGALERT("Não foi informado o produto, somente a descricao na saida deste produto !!!", "Atenção - Saida !!!")
			lSZD2 := .F.
		ENDIF
		
		// valida campo servico, que deve estar preenchido
		IF _nREQQ01 > 0 .and. Empty(_cPrdS01)
			MSGALERT("Não foi informado o produto na saida !!!", "Atenção - Saida !!!")
			lSZD2t := .F.
		ENDIF
		
		// valida campo servico, que deve estar preenchido
		IF _nREQQ02 = 0 .and. !Empty(_cPrdS02)
			MSGALERT("Não foi informado a quantidade na entrada do produto !!!", "Atenção - Entrada !!!")
			lSZD2T := .F.
		ENDIF
		
		// valida campo servico, que deve estar preenchido
		IF _nREQQ02 = 0 .and. Empty(_cPrdS02) .and. !Empty(_cDesc02)
			MSGALERT("Não foi informado a quantidade e o codigo do produto na entrada !!!", "Atenção - Entrada !!!")
			lSZD2T := .F.
		ENDIF
	Endif
Next ii

Return(lSZD2T)


// -----------------------------  FIM FOLDER MODIFICACAO  -------------------------- //

// LEGENDA DO SISTEMA DO PROGRAMA RPCPM80 -> PROGRAMACAO DE MAQUINAS.
User Function LEGM80()
BRWLEGENDA(cCADASTRO,"Legenda",{{"BR_BRANCO"      ,"Gerar OP"        },;
								{"ENABLE"         ,"Inclusao"        },;
								{"RECUSA_ALMOX"   ,"Recusa Almox"    },;
								{"BR_PINK"        ,"Aprovado"        },;
								{"BR_AMARELO"     ,"Separação"       },;
								{"pend_alm"       ,"Pendente Almox"  },;
								{"BR_AZUL"        ,"Fabrica"         },;
								{"pend_fab"       ,"Pendente Fabr"   },;
								{"RECUSA_FABRICA" ,"Recusa Fabrica"  },;
								{"ENCERR_FABRICA" ,"Encerrado Fab"   },;
								{"BR_AZUL_CLARO"  ,"Eletronica"      },;     
								{"Pend_Elet"      ,"Pendente Eletr"  },;     
								{"recusa_Elet"    ,"Recusa Eletr"    },;     																
								{"Encer_Elet"     ,"Encerrado Eletr" },;     								
								{"DISABLE"        ,"Encerrada"       }})
return

// FUNCAO PARA TRATAMENTO DE RECUSA DA ORDEM DE SERVICO
// ESTA OPERACAO VISAO A AUTORIZACAO DA DIRETORIA
// PARA DAR CONTINUIDADE AO PROCESSO DA ORDEM
USER FUNCTION OSRECUSA(_NVRSIT)
__CUSR :=  RetCodUsr()
nopca	    := 0
_NTEMOP     := 0
lMSErroAuto := .F.

IF EMPTY(SZA->ZA_STATUS) .OR. SZA->ZA_STATUS $ "L/S/O/P"
	
	_DSEPDT01 := CTOD("  /  /  ")  // data inicio
	_CSEPT001 := space(06) // hora inicio
	_DSEPDT02 := CTOD("  /  /  ")  // data final
	_CSEPT002 := space(06) // hora final
	_CSEPOBS  := SPACE(200)
	_CCODFF   := SPACE(06)
	_CNOMFF   := SPACE(25)
	
	
	DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Recusa") From 0,0 To 280,505 PIXEL OF oMainWnd
	@ 10, 007   Say OemToAnsi("Apontamento das horas trabalhada no processo de recusa") PIXEL
	
	if _NVRSIT = 1
		@ 22, 007  	SAY OemToAnsi("Cod.Funcionario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
	elseif _NVRSIT = 2
		@ 22, 007  	SAY OemToAnsi("Cod.Func") PIXEL
		@ 22, 050	MSGET _CCODFF SIZE 40,08 F3  "AA1V" OF __ODlg PIXEL
		@ 22, 100	MSGET _CNOMFF SIZE 80,08 WHEN .F.  OF __ODlg PIXEL
	endif
	
	@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
	@ 35, 050	MSGET _DSEPDT01                     SIZE 40,08 Valid VInDtRec(_DSEPDT01,SZA->ZA_IDOS)           When .t. OF __ODlg PIXEL
	@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
	@ 35, 215 	MSGET _CSEPT001 Picture "99:99"     SIZE 25,08 Valid VInHrRec(_DSEPDT01,_CSEPT001,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
	@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
	@ 48, 050	MSGET _DSEPDT02                     SIZE 40,08 Valid VfmDtRec(_DSEPDT01,_DSEPDT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
	@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
	@ 48, 215 	MSGET _CSEPT002 Picture "99:99"     SIZE 25,08 Valid VfmHrRec(_DSEPDT01,_DSEPDT02,_CSEPT001,_CSEPT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
	@ 61, 007	Say OemToAnsi("Observação ") PIXEL				//
	@ 68, 007   GET oDesc VAR _CSEPOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
	ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
	
	If nOpca = 1
		
		__CUSR :=  RetCodUsr()
		DBSELECTAREA("SZA")
		RECLOCK("SZA",.F.)
		
		IF _NVRSIT = 1
			SZA->ZA_STATUS := "R"
			SZA->ZA_RECUSA := __CUSR + " - " + UsrRetName(__CUSR) + " - RECUSA ALMOX EM : " + DTOC(DDATABASE)+ " - " + TIME()
		ELSE
			SZA->ZA_STATUS := "M"
			SZA->ZA_RECUSA := __CUSR + " - " + UsrRetName(__CUSR) + " - RECUSA FABRICA EM : " + DTOC(DDATABASE)+ " - " + TIME()
		ENDIF
		MSUNLOCK("SZA")
		
		// TABELA SZE --> RELATORIO
		DBSELECTAREA("SZE")
		RECLOCK("SZE",.T.)
		SZE->ZE_FILIAL  := XFILIAL("SZE")
		SZE->ZE_IDOS    := SZA->ZA_IDOS
		SZE->ZE_EMISSAO := _DSEPDT01
		SZE->ZE_HORAINI := _CSEPT001
		SZE->ZE_DTFIM   := _DSEPDT02
		SZE->ZE_HORAFIM := _CSEPT002
		SZE->ZE_FUNC    := __CUSR
		SZE->ZE_NOME    := UsrRetName(__CUSR)
		SZE->ZE_OBS     := "RECUSA " + ALLTRIM(SUBSTRING(_CSEPOBS,1,200))
		MsUnLock("SZE")
	ENDIF
ELSE
	IF SZA->ZA_STATUS == "S"
		MSGALERT("Ordem de Servico, no processo de SEPARACAO. Operação de RECUSA, invalida !!!", "Ordem de Servico - Status Separação")
	ELSEIF SZA->ZA_STATUS == "O"
		MSGALERT("Ordem de Servico, no processo de APONTAMENTO. Operação de RECUSA, invalida !!!", "Ordem de Servico - Status Apontamento")
	ELSEIF SZA->ZA_STATUS == "J"
		MSGALERT("Ordem de Servico, no processo de PENDENCIA. Operação de RECUSA, invalida !!!", "Ordem de Servico - Status Pendente")
	ELSEIF SZA->ZA_STATUS == "R"
		MSGALERT("Ordem de Servico, no processo de RECUSA. Operação de RECUSA, invalida !!!", "Ordem de Servico - Status Recusa")
	ELSEIF SZA->ZA_STATUS == "E"
		MSGALERT("Ordem de Servico, no processo de ENCERRADA. Operação de RECUSA, invalida !!!", "Ordem de Servico - Status Encerrada")
	ENDIF
ENDIF
RETURN

// FUNCAO PARA TRATAMENTO DE LIBERACAO DA ORDEM DE SERVICO
// ESTA OPERACAO VISAO A AUTORIZACAO DA DIRETORIA
// PARA DAR CONTINUIDADE AO PROCESSO DA ORDEM
USER FUNCTION OSAPROVA()
__CUSR :=  RetCodUsr()

IF SZA->ZA_STATUS  == "R"
	DBSELECTAREA("SZA")
	RECLOCK("SZA",.F.)
	SZA->ZA_STATUS  := "L"
	SZA->ZA_AUTORIZ := __CUSR + " - " + UsrRetName(__CUSR) + " - LIBERADO EM : " + DTOC(DDATABASE)+ " - " + TIME()
	MSUNLOCK("SZA")
	
	// TABELA SZE --> RELATORIO
	DBSELECTAREA("SZE")
	RECLOCK("SZE",.T.)
	SZE->ZE_FILIAL  := XFILIAL("SZE")
	SZE->ZE_IDOS    := SZA->ZA_IDOS
	SZE->ZE_EMISSAO := DDATABASE
	SZE->ZE_HORAINI := _ctmp
	SZE->ZE_DTFIM   := DDATABASE
	SZE->ZE_HORAFIM := TIME()
	SZE->ZE_FUNC    := __CUSR
	SZE->ZE_NOME    := UsrRetName(__CUSR)
	SZE->ZE_OBS     := "APROVADO"
	MsUnLock("SZE")
ELSE
	IF SZA->ZA_STATUS == "S"
		MSGALERT("Ordem de Servico, no processo de SEPARACAO. Operação de APROVAR, invalida !!!", "Ordem de Servico - Status Separação")
	ELSEIF SZA->ZA_STATUS == "O"
		MSGALERT("Ordem de Servico, no processo de APONTAMENTO. Operação de APROVAR, invalida !!!", "Ordem de Servico - Status Apontamento")
	ELSEIF SZA->ZA_STATUS == "E"
		MSGALERT("Ordem de Servico, no processo de ENCERRADA. Operação de APROVAR, invalida !!!", "Ordem de Servico - Status Encerrada")
	ELSEIF SZA->ZA_STATUS == "L"
		MSGALERT("Ordem de Servico, ja se encontra APROVADA. Operação de APROVAR, invalida !!!", "Ordem de Servico - Status Aprovada")
	ELSEIF SZA->ZA_STATUS == "J"
		MSGALERT("Ordem de Servico, no processo de PENDENCIA. Operação de RECUSA, invalida !!!", "Ordem de Servico - Status Pendente")
	ELSEIF EMPTY(SZA->ZA_STATUS)
		MSGALERT("Ordem de Servico, não foi RECUSADA. Operação de APROVAR, invalida !!!", "Ordem de Servico - Status Inclusao")
	ENDIF
ENDIF
RETURN


// FUNCAO PARA TRATAMENTO DE PENDENTE DA ORDEM DE SERVICO
USER FUNCTION OSPENDEN(_NDEPTO)

IF EMPTY(SZA->ZA_STATUS) .OR. SZA->ZA_STATUS $ "L/S/O"
	
	__CUSR :=  RetCodUsr()
	DBSELECTAREA("SZA")
	RECLOCK("SZA",.F.)
	IF _NDEPTO = 1
		SZA->ZA_STATUS := "J"
		SZA->ZA_RECUSA := __CUSR + " - " + ALLTRIM(UsrRetName(__CUSR)) + " - PENDENTE DE PEÇAS EM : " + DTOC(DDATABASE)+ " - " + TIME()
	ELSEIF _NDEPTO = 2
		SZA->ZA_STATUS := "P"
		SZA->ZA_RECUSA := __CUSR + " - " + ALLTRIM(UsrRetName(__CUSR)) + " - PENDENTE FABRICA EM : " + DTOC(DDATABASE)+ " - " + TIME()
	ENDIF
	MSUNLOCK("SZA")
	
	// TABELA SZE --> RELATORIO
	DBSELECTAREA("SZE")
	RECLOCK("SZE",.T.)
	SZE->ZE_FILIAL  := XFILIAL("SZE")
	SZE->ZE_IDOS    := SZA->ZA_IDOS
	SZE->ZE_EMISSAO := DDATABASE
	SZE->ZE_HORAINI := _ctmp
	SZE->ZE_DTFIM   := DDATABASE
	SZE->ZE_HORAFIM := TIME()
	SZE->ZE_FUNC    := __CUSR
	SZE->ZE_NOME    := UsrRetName(__CUSR)
	SZE->ZE_OBS     := "PENDENTE "+IIF(_NDEPTO = 2,"FABRICA","ALMOX")
	MsUnLock("SZE")
ELSE
	IF SZA->ZA_STATUS == "J"
		MSGALERT("Ordem de Servico, no processo de PENDENCIA. Operação de PENDENTE, invalida !!!", "Ordem de Servico - Status Pendencia")
	ELSEIF SZA->ZA_STATUS == "O"
		MSGALERT("Ordem de Servico, no processo de APONTAMENTO. Operação de PENDENTE, invalida !!!", "Ordem de Servico - Status Apontamento")
	ELSEIF SZA->ZA_STATUS == "E"
		MSGALERT("Ordem de Servico, no processo de ENCERRADA. Operação de PENDENTE, invalida !!!", "Ordem de Servico - Status Encerrada")
	ELSEIF SZA->ZA_STATUS == "S"
		MSGALERT("Ordem de Servico, no processo de SEPARAÇÃO. Operação de PENDENTE, invalida !!!", "Ordem de Servico - Status Separação")
	ELSEIF SZA->ZA_STATUS == "R"
		MSGALERT("Ordem de Servico, no processo de RECUSA. Operação de PENDENTE, invalida !!!", "Ordem de Servico - Status Recusa")
	ENDIF
ENDIF
RETURN

// FUNCAO PARA TRATAMENTO DE SEPARACAO DE PECA PARA A OFICINA
// COM GERACAO DE DADOS PARA MOVIMENTACAO INTERNA MSAUTOEXEC
// E MUDANCA DO STATUS DA ORDEM DE SERVICO
USER FUNCTION OSSEPARA()
__CUSR      :=  RetCodUsr()
__CZDOS     := SZA->ZA_IDOS
__CZDCL     := SZA->ZA_NOME
__AZDOS     := {}
nopca	    := 0
_NTEMOP     := 0
_nTdSep     := 0
_NTOTPO     := 0
_NTOTNE     := 0
lMSErroAuto := .F.
CLOG        := ""
aCabMov     := {}

// PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST" TABLES "SD3","SB1","SZA","SZD","SB2"

IF EMPTY(SZA->ZA_STATUS) .OR. SZA->ZA_STATUS $ "J/L"
	
	// ARQUIVO DA MODIFICACAO
	DBSELECTAREA("SZD")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZD")+__CZDOS)
		WHILE !EOF() .AND. SZD->ZD_IDOS == __CZDOS
		
			//Incluído por Alex Rodrigues - 09/08/2018 
			//Adinfo Consultoria
			IF !EMPTY(SZD->ZD_OP)
				_NTEMOP++
			ENDIF
			
			IF SZD->ZD_QTDSAI = 0 .AND. EMPTY(SZD->ZD_PRODUTO)
				DBSELECTAREA("SZD")
				DBSKIP()
				LOOP
			ENDIF
			
			IF SZD->ZD_QTDSAI > 0 .AND. EMPTY(SZD->ZD_PRODUTO)
				MSGALERT("Codigo do produto esta em BRANCO !!! Não será possivel executar esta operação.", "ATENÇÂO")
				RETURN
			ELSEIF SZD->ZD_QTDSAI = 0 .AND. !EMPTY(SZD->ZD_PRODUTO)
				MSGALERT("Quantidade zerada !!! Não será possivel executar esta operação.", "ATENÇÂO")
				RETURN
			ENDIF
			
			IF SZD->ZD_QTDSAI < 0
				MSGALERT("Quantidade NEGATIVA !!! Não será possivel executar esta operação.", "ATENÇÂO")
				RETURN
			ENDIF
			     
			//retirado por Alex Rodrigues - 09/08/2018 
			//Adinfo Consultoria
			/*
			IF !EMPTY(SZD->ZD_OP)
				_NTEMOP++
			ENDIF
			*/
			
			// CONSULTA SALDO EM ESTOQUE
			DBSELECTAREA("SB2")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SB2")+SZD->ZD_PRODUTO+"01")
				_NTOTPO     := (SB2->B2_QATU)
				_NTOTNE     := (SB2->B2_QEMP+SB2->B2_RESERVA+SB2->B2_QEMPN+SZD->ZD_QTDSAI)
				
				IF (_NTOTPO - _NTOTNE  ) < 0
					_nTdSep++
					CLOG += "Produto ==> " + SZD->ZD_PRODUTO + " Saldo " + TRANSFORM((_NTOTPO - _NTOTNE),"999,999.99")+chr(13)+chr(10)
				ENDIF
			ELSE
				_NTOTPO := 0
				_NTOTNE := 0
				_nTdSep++
				CLOG += "Produto ==> " + SZD->ZD_PRODUTO + " Saldo " + TRANSFORM((_NTOTPO - _NTOTNE),"999,999.99")+chr(13)+chr(10)
			ENDIF
			
			DBSELECTAREA("SZD")
			
//			AAdd(__AZDOS,{SZD->ZD_FILIAL,"901",SZD->ZD_PRODUTO,SZD->ZD_QTDSAI,"01",__CZDOS,SZD->ZD_OP,__CZDCL})

       		Aadd(__AZDOS,{{"D3_FILIAL"   ,SZD->ZD_FILIAL       ,NIL},;
				    	  {"D3_COD"      ,SZD->ZD_PRODUTO      ,NIL},;
       					  {"D3_LOCAL"    ,'01'                 ,NIL},;
       					  {"D3_QUANT"    ,SZD->ZD_QTDSAI       ,NIL},;
       					  {"D3_EMISSAO"  ,dDataBase            ,NIL},;
       					  {"D3_OBS"      ,__CZDOS              ,NIL},;
       					  {"D3_CLIENTE"  ,__CZDCL              ,NIL}})

			DBSELECTAREA("SZD")
			DBSKIP()
			LOOP
		END
		
		IF _NTEMOP = 0
			
			// TRATAMENTO PARA PRODUTOS QUE NAO TEM ESTOQUE
			// NAO DEIXAR DAR BAIXA DA ORDEM DE SERVICO
			IF _nTdSep > 0
				MSGALERT("Esta Ordem de Serviço, apresenta itens que não tem saldo em estoque !!! Não será possivel executar esta operação.", "ATENÇÂO")
				u_ESTNG(cLog)  // apresenta os produtos sem estoque
				RETURN
			ENDIF
                                             
		      _cNumDoc:= GETSXENUM("SD3","D3_DOC",NIL)                                        
		      _CCUSTO := ""
		      aCabMov := {{"D3_DOC"    ,_cNumDoc  ,NIL},;
        	    	      {"D3_TM"     ,'901'     ,NIL},;
	            	      {"D3_EMISSAO",dDataBase ,NIL},;
    		              {"D3_CC"     ,_CCUSTO   ,NIL}}

			
/*
			//-- REQUISITA DO LOTE INDICADO NA
			FOR RC := 1 TO LEN(__AZDOS)
				lMSErroAuto := .F.
				lMSHelpAuto := .T.
				aMovSD3		:= {}
				
				AAdd(aMovSD3,{'D3_FILIAL'	,__AZDOS[RC,1],Nil})
				AAdd(aMovSD3,{'D3_TM'		,__AZDOS[RC,2],Nil})
				AAdd(aMovSD3,{'D3_COD'		,__AZDOS[RC,3],Nil})
				AAdd(aMovSD3,{'D3_QUANT'	,__AZDOS[RC,4],Nil})
				AAdd(aMovSD3,{'D3_LOCAL'	,__AZDOS[RC,5],Nil})
				AAdd(aMovSD3,{'D3_EMISSAO'	,dDataBase    ,Nil})
				AAdd(aMovSD3,{'D3_OBS'	    ,__AZDOS[RC,6],Nil})
				AAdd(aMovSD3,{'D3_CLIENTE'  ,__AZDOS[RC,8],Nil})
				
				MsExecAuto({|x,y|MATA240(x,y)}, aMovSD3  , 3)        
                MSExecAuto({|x,y,z| MATA241(x,y,z)}, aCabMov, aItensMov, cOperacao)				
                
                
				If lMsErroAuto
					MostraErro()
				Endif
				
				lMSHelpAuto := .F.
			NEXT

*/
                
				lMSErroAuto := .F.
				lMSHelpAuto := .T.                                          
                
				If len(__AZDOS) > 0 .and. len(aCabMov) > 0
					
            	    MSExecAuto({|x,y,z| MATA241(x,y,z)}, aCabMov, __AZDOS , 3)				
                
					If lMsErroAuto
						MostraErro()
					Endif
				
					lMSHelpAuto := .F.
				Endif

		ENDIF
	ENDIF

	IF !lMsErroAuto
		
		_DSEPDT01 := CTOD("  /  /  ")  // data inicio
		_CSEPT001 := space(06)         // hora inicio
		_DSEPDT02 := CTOD("  /  /  ")  // data final
		_CSEPT002 := space(06)         // hora final
		_CSEPOBS  := SPACE(200)
		
		DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Apontamento") From 0,0 To 280,505 PIXEL OF oMainWnd
		@ 10, 007   Say OemToAnsi("Apontamento das horas trabalhada no processo de separação") PIXEL
		@ 22, 007  	SAY OemToAnsi("Cod.Funcionario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
		@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
		@ 35, 050	MSGET _DSEPDT01 SIZE 40,08 Valid VInDtRec(_DSEPDT01,SZA->ZA_IDOS) When .t.  OF __ODlg PIXEL
		@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
		@ 35, 215 	MSGET _CSEPT001 Picture "99:99" SIZE 25,08 Valid VInHrRec(_DSEPDT01,_CSEPT001,SZA->ZA_IDOS)  When .t. OF __ODlg PIXEL
		@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
		@ 48, 050	MSGET _DSEPDT02 SIZE 40,08 Valid VfmDtRec(_DSEPDT01,_DSEPDT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
		@ 48, 215 	MSGET _CSEPT002 Picture "99:99" SIZE 25,08 Valid VfmHrRec(_DSEPDT01,_DSEPDT02,_CSEPT001,_CSEPT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 61, 007	Say OemToAnsi("Observação ") PIXEL
		@ 68, 007   GET oDesc VAR _CSEPOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
		ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
		
		If nOpca = 1
			
			DBSELECTAREA("SZA")
			RECLOCK("SZA",.F.)
			SZA->ZA_STATUS := "S"
			SZA->ZA_SEPARAC := __CUSR + " - " + UsrRetName(__CUSR) + " - SEPARADO EM : " + DTOC(DDATABASE)+ " - " + TIME()
			MSUNLOCK("SZA")
			
			// TABELA SZE --> RELATORIO
			DBSELECTAREA("SZE")
			RECLOCK("SZE",.T.)
			SZE->ZE_FILIAL  := XFILIAL("SZE")
			SZE->ZE_IDOS    := SZA->ZA_IDOS
			SZE->ZE_EMISSAO := _DSEPDT01
			SZE->ZE_HORAINI := _CSEPT001
			SZE->ZE_DTFIM   := _DSEPDT02
			SZE->ZE_HORAFIM := _CSEPT002
			SZE->ZE_FUNC    := __CUSR
			SZE->ZE_NOME    := UsrRetName(__CUSR)
			SZE->ZE_OBS     := "SEPARACAO " + ALLTRIM(SUBSTRING(_CSEPOBS,1,200))
			MsUnLock("SZE")
		ELSE
			MSGALERT("O processo de SEPARACAO, foi finalizado sem apontamento de horas. Foi gerado movimentacoes de produtos NO ESTOQUE !!! ","ANALISE AS MOVIMENTACOES")
			IF MSGYESNO("Deseja incluir o apontamento de horas ?")
				
				_DSEPDT01 := CTOD("  /  /  ")  // data inicio
				_CSEPT001 := space(06) // hora inicio
				_DSEPDT02 := CTOD("  /  /  ")  // data final
				_CSEPT002 := space(06) // hora final
				_CSEPOBS  := SPACE(200)
				
				DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Apontamento") From 0,0 To 280,505 PIXEL OF oMainWnd
				@ 10, 007   Say OemToAnsi("Apontamento das horas trabalhada no processo de separação") PIXEL
				@ 22, 007  	SAY OemToAnsi("Cod.Funcionario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
				@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
				@ 35, 050	MSGET _DSEPDT01 SIZE 40,08 Valid VInDtRec(_DSEPDT01,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
				@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
				@ 35, 215 	MSGET _CSEPT001 Picture "99:99" SIZE 25,08 Valid VInHrRec(_DSEPDT01,_CSEPT001,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
				@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
				@ 48, 050	MSGET _DSEPDT02 SIZE 40,08 Valid VfmDtRec(_DSEPDT01,_DSEPDT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
				@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
				@ 48, 215 	MSGET _CSEPT002 Picture "99:99" SIZE 25,08 Valid VfmHrRec(_DSEPDT01,_DSEPDT02,_CSEPT001,_CSEPT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
				@ 61, 007	Say OemToAnsi("Observação ") PIXEL				//
				@ 68, 007   GET oDesc VAR _CSEPOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
				ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
				
				If nOpca = 1
					
					DBSELECTAREA("SZA")
					RECLOCK("SZA",.F.)
					SZA->ZA_STATUS := "S"
					SZA->ZA_SEPARAC := __CUSR + " - " + UsrRetName(__CUSR) + " - SEPARADO EM : " + DTOC(DDATABASE)+ " - " + TIME()
					MSUNLOCK("SZA")
					
					// TABELA SZE --> RELATORIO
					DBSELECTAREA("SZE")
					RECLOCK("SZE",.T.)
					SZE->ZE_FILIAL  := XFILIAL("SZE")
					SZE->ZE_IDOS    := SZA->ZA_IDOS
					SZE->ZE_EMISSAO := _DSEPDT01
					SZE->ZE_HORAINI := _CSEPT001
					SZE->ZE_DTFIM   := _DSEPDT02
					SZE->ZE_HORAFIM := _CSEPT002
					SZE->ZE_FUNC    := __CUSR
					SZE->ZE_NOME    := UsrRetName(__CUSR)
					SZE->ZE_OBS     := "SEPARACAO " + ALLTRIM(SUBSTRING(_CSEPOBS,1,200))
					MsUnLock("SZE")
				Endif
			Else
				MSGALERT("Você escolheu a opcao de nao gerar apontamento de horas. Mas existe movimentacoes para esta ordem de servico !!! ","ANALISE AS MOVIMENTACOES")
			Endif
		Endif
	ENDIF
ELSE
	IF SZA->ZA_STATUS == "S"
		MSGALERT("Ordem de Servico, no processo de SEPARACAO. Operação de SEPARAÇÃO, invalida !!!", "Ordem de Servico - Status Separação")
	ELSEIF SZA->ZA_STATUS == "O"
		MSGALERT("Ordem de Servico, no processo de APONTAMENTO. Operação de SEPARAÇÃO, invalida !!!", "Ordem de Servico - Status Apontamento")
	ELSEIF SZA->ZA_STATUS == "E"
		MSGALERT("Ordem de Servico, no processo de ENCERRADA. Operação de SEPARAÇÃO, invalida !!!", "Ordem de Servico - Status Encerrada")
	ELSEIF SZA->ZA_STATUS == "R"
		MSGALERT("Ordem de Servico, ja se encontra RECUSADA. Operação de SEPARAÇÃO, invalida !!!", "Ordem de Servico - Status Recusada")
	ENDIF
ENDIF
RETURN


// FUNCAO PARA TRATAMENTO DE APONTAMENTO DE HORAS DA OFICINA
// E MUDANCA DO STATUS DA ORDEM DE SERVICO
USER FUNCTION OSAPONTA()
__CUSR :=  RetCodUsr()
__CZDOS := SZA->ZA_IDOS
__AZDOS := {}
nopca	:= 0

IF SZA->ZA_STATUS $ "S/M/ /O/P"
	_DAPODT01 := CTOD("  /  /  ")  // data inicio
	_CAPOT001 := space(06) // hora inicio
	_DAPODT02 := CTOD("  /  /  ")  // data final
	_CAPOT002 := space(06) // hora final
	_CAPOOBS  := SPACE(200)
	_CCODFF   := SPACE(06)
	_CNOMFF   := SPACE(25)
	
	DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Apontamento") From 0,0 To 280,505 PIXEL OF oMainWnd
	@ 10, 007   Say OemToAnsi("Apontamento das horas trabalhada no processo de fabrica") PIXEL
	@ 22, 007  	SAY OemToAnsi("Cod.Func") PIXEL
	@ 22, 050	MSGET _CCODFF SIZE 40,08 F3  "AA1V" OF __ODlg PIXEL
	@ 22, 100	MSGET _CNOMFF SIZE 80,08 WHEN .F.  OF __ODlg PIXEL
	@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
	@ 35, 050	MSGET _DAPODT01 SIZE 40,08 When .t. OF __ODlg PIXEL
	@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
	@ 35, 215 	MSGET _CAPOT001 Picture "99:99" SIZE 25,08 When .t. OF __ODlg PIXEL
	@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
	@ 48, 050	MSGET _DAPODT02 SIZE 40,08 When .t. OF __ODlg PIXEL
	@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
	@ 48, 215 	MSGET _CAPOT002 Picture "99:99" SIZE 25,08 When .t. OF __ODlg PIXEL
	@ 61, 007  	SAY OemToAnsi("Usuario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
	@ 71, 007	Say OemToAnsi("Observação ") PIXEL				//
	@ 78, 007   GET oDesc VAR _CAPOOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
	
	ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
	
	If nOpca = 1
		
		DBSELECTAREA("SZA")
		RECLOCK("SZA",.F.)
		SZA->ZA_STATUS := "P"
		SZA->ZA_SEPARAC := __CUSR + " - " + UsrRetName(__CUSR) + " - APONTAMENTO EM : " + DTOC(DDATABASE)+ " - " + TIME()
		MSUNLOCK("SZA")
		
		// TABELA SZE --> RELATORIO
		DBSELECTAREA("SZE")
		RECLOCK("SZE",.T.)
		SZE->ZE_FILIAL  := XFILIAL("SZE")
		SZE->ZE_IDOS    := SZA->ZA_IDOS
		SZE->ZE_EMISSAO := _DAPODT01
		SZE->ZE_HORAINI := _CAPOT001
		SZE->ZE_DTFIM   := _DAPODT02
		SZE->ZE_HORAFIM := _CAPOT002
		SZE->ZE_FUNC    := _CCODFF
		SZE->ZE_NOME    := _CNOMFF
		SZE->ZE_OBS     := ALLTRIM(SUBSTRING(_CAPOOBS,1,200))+ " " +__CUSR + "-" + UsrRetName(__CUSR)
		MsUnLock("SZE")
	Endif
ELSE
	IF SZA->ZA_STATUS == "E"
		MSGALERT("Ordem de Servico, no processo de ENCERRADA. Operação de APONTAMENTO, invalida !!!", "Ordem de Servico - Status Encerrada")
	ELSEIF SZA->ZA_STATUS == "R"
		MSGALERT("Ordem de Servico, ja se encontra RECUSADA. Operação de APONTAMENTO, invalida !!!", "Ordem de Servico - Status Recusada")
	ENDIF
ENDIF
RETURN


// FUNCAO PARA TRATAMENTO DE ENCERRAMENTO DA OS
// E MUDANCA DO STATUS DA ORDEM DE SERVICO
USER FUNCTION OSENCERR(_NDTP)

local RC
__CUSR  :=  RetCodUsr()
__CZDOS := SZA->ZA_IDOS
__CZDCL := SZA->ZA_NOME
__AZDOS := {}
nopca	:= 0
_NTEMOP := 0
_NSEMOP := 0
_NTOTPO := 0
_NTOTNE := 0
_nTdSep := 0
lMSErroAuto := .F.

IF _NDTP = 2
	IF SZA->ZA_STATUS $ "S/O/P"
		IF !lMsErroAuto
			_DAPODT01 := CTOD("  /  /  ")  // data inicio
			_CAPOT001 := space(06) // hora inicio
			_DAPODT02 := CTOD("  /  /  ")  // data final
			_CAPOT002 := space(06) // hora final
			_CAPOOBS  := SPACE(200)
			_CCODFF   := SPACE(06)
			_CNOMFF   := SPACE(25)
			
			DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Encerramento") From 0,0 To 280,505 PIXEL OF oMainWnd
			@ 10, 007   Say OemToAnsi("Encerramento das horas trabalhada no processo de fabrica") PIXEL
			@ 22, 007  	SAY OemToAnsi("Cod.Func") PIXEL
			@ 22, 050	MSGET _CCODFF SIZE 40,08 F3  "AA1V" OF __ODlg PIXEL
			@ 22, 100	MSGET _CNOMFF SIZE 80,08 WHEN .F.  OF __ODlg PIXEL
			@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
			@ 35, 050	MSGET _DAPODT01 SIZE 40,08 Valid VInDtRec(_DAPODT01,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
			@ 35, 215 	MSGET _CAPOT001 Picture "99:99" SIZE 25,08 Valid VInHrRec(_DAPODT01,_CAPOT001,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
			@ 48, 050	MSGET _DAPODT02 SIZE 40,08 Valid VfmDtRec(_DAPODT01,_DAPODT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
			@ 48, 215 	MSGET _CAPOT002 Picture "99:99" SIZE 25,08 Valid VfmHrRec(_DAPODT01,_DAPODT02,_CAPOT001,_CAPOT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 61, 007  	SAY OemToAnsi("Usuario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
			@ 71, 007	Say OemToAnsi("Observação ") PIXEL				//
			@ 78, 007   GET oDesc VAR _CAPOOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
			
			ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
			
			If nOpca = 1
				
				DBSELECTAREA("SZA")
				RECLOCK("SZA",.F.)
				IF MSGYESNO("Retorna para o Almoxarifado ?")
					SZA->ZA_STATUS := "C"
				ELSE
					SZA->ZA_STATUS := "E"
				ENDIF
				SZA->ZA_ENCERRA := __CUSR + " - " + UsrRetName(__CUSR) + " - ENCERRADO EM : " + DTOC(DDATABASE)+ " - " + TIME()
				MSUNLOCK("SZA")
				
				// TABELA SZE --> RELATORIO
				DBSELECTAREA("SZE")
				RECLOCK("SZE",.T.)
				SZE->ZE_FILIAL  := XFILIAL("SZE")
				SZE->ZE_IDOS    := SZA->ZA_IDOS
				SZE->ZE_EMISSAO := _DAPODT01
				SZE->ZE_HORAINI := _CAPOT001
				SZE->ZE_DTFIM   := _DAPODT02
				SZE->ZE_HORAFIM := _CAPOT002
				SZE->ZE_FUNC    := _CCODFF
				SZE->ZE_NOME    := _CNOMFF
				SZE->ZE_OBS     := "ENCERRAMENTO " + SUBSTRING(_CAPOOBS,1,200)
				MsUnLock("SZE")
			Endif
		Endif
	ENDIF
	RETURN
ELSEIF _NDTP = 3      // encerra a ordem de servico sem gerar movimentacao no estoque
	IF !lMsErroAuto
		_DAPODT01 := CTOD("  /  /  ")  // data inicio
		_CAPOT001 := space(06) // hora inicio
		_DAPODT02 := CTOD("  /  /  ")  // data final
		_CAPOT002 := space(06) // hora final
		_CAPOOBS  := SPACE(200)
		_CCODFF   := SPACE(06)
		_CNOMFF   := SPACE(25)
		
		DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Encerramento Sem Geração de Movimentos") From 0,0 To 280,505 PIXEL OF oMainWnd
		@ 10, 007   Say OemToAnsi("Encerramento das horas trabalhada Manual. Não Gera Movimento no Estoque") PIXEL
		@ 22, 007  	SAY OemToAnsi("Cod.Func") PIXEL
		@ 22, 050	MSGET _CCODFF SIZE 40,08 F3  "AA1V" OF __ODlg PIXEL
		@ 22, 100	MSGET _CNOMFF SIZE 80,08 WHEN .F.  OF __ODlg PIXEL
		@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
		@ 35, 050	MSGET _DAPODT01 SIZE 40,08 Valid VInDtRec(_DAPODT01,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
		@ 35, 215 	MSGET _CAPOT001 Picture "99:99" SIZE 25,08 Valid VInHrRec(_DAPODT01,_CAPOT001,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
		@ 48, 050	MSGET _DAPODT02 SIZE 40,08 Valid VfmDtRec(_DAPODT01,_DAPODT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
		@ 48, 215 	MSGET _CAPOT002 Picture "99:99" SIZE 25,08 Valid VfmHrRec(_DAPODT01,_DAPODT02,_CAPOT001,_CAPOT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 61, 007  	SAY OemToAnsi("Usuario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
		@ 71, 007	Say OemToAnsi("Observação ") PIXEL				//
		@ 78, 007   GET oDesc VAR _CAPOOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
		
		ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
		
		If nOpca = 1
			
			DBSELECTAREA("SZA")
			RECLOCK("SZA",.F.)
			SZA->ZA_STATUS := "E"
			SZA->ZA_ENCERRA := __CUSR + " - " + UsrRetName(__CUSR) + " - ENCERRADO EM : " + DTOC(DDATABASE)+ " - " + TIME()
			MSUNLOCK("SZA")
			
			// TABELA SZE --> RELATORIO
			DBSELECTAREA("SZE")
			RECLOCK("SZE",.T.)
			SZE->ZE_FILIAL  := XFILIAL("SZE")
			SZE->ZE_IDOS    := SZA->ZA_IDOS
			SZE->ZE_EMISSAO := _DAPODT01
			SZE->ZE_HORAINI := _CAPOT001
			SZE->ZE_DTFIM   := _DAPODT02
			SZE->ZE_HORAFIM := _CAPOT002
			SZE->ZE_FUNC    := _CCODFF
			SZE->ZE_NOME    := _CNOMFF
			SZE->ZE_OBS     := "ENCERRAMENTO " + SUBSTRING(_CAPOOBS,1,200)
			MsUnLock("SZE")
		Endif
	Endif
	RETURN
ENDIF

IF SZA->ZA_STATUS $ "S/O/ /C"
	
	// ARQUIVO DA MODIFICACAO
	DBSELECTAREA("SZD")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZD")+__CZDOS)
		WHILE !EOF() .AND. SZD->ZD_IDOS == __CZDOS
			
			IF SZD->ZD_QTDEENT = 0 .AND. EMPTY(SZD->ZD_PRODENT)
				MSGALERT("Codigo do produto esta em BRANCO e a quantidade zerada !!! Não será possivel executar esta operação.", "ATENÇÂO")
				DBSELECTAREA("SZD")
				DBSKIP()
				LOOP
			ENDIF
			
			IF SZD->ZD_QTDEENT > 0 .AND. EMPTY(SZD->ZD_PRODENT)
				MSGALERT("Codigo do produto esta em BRANCO !!! Não será possivel executar esta operação.", "ATENÇÂO")
				RETURN
			ELSEIF SZD->ZD_QTDEENT = 0 .AND. !EMPTY(SZD->ZD_PRODENT)
				MSGALERT("Quantidade zerada !!! Não será possivel executar esta operação.", "ATENÇÂO")
				RETURN
			ELSEIF SZD->ZD_QTDEENT = 0 .AND. EMPTY(SZD->ZD_PRODENT) .AND. !EMPTY(SZD->ZD_DESCENT)
				MSGALERT("Quantidade zerada !!! Não será possivel executar esta operação.", "ATENÇÂO")
				RETURN
			ENDIF
			
			IF !EMPTY(SZD->ZD_OP)
				_NTEMOP++
			ELSE
				_NSEMOP++
			ENDIF
			
			AAdd(__AZDOS,{SZD->ZD_FILIAL,"201",SZD->ZD_PRODENT,SZD->ZD_QTDEENT,"01",SZD->ZD_OP,__CZDOS,__CZDCL})
			
			DBSELECTAREA("SZD")
			DBSKIP()
			LOOP
		END
	ENDIF
	
	
	// CONFERENCIA DE SALDOS DAS OP´S.....
	CLOG := ""
	FOR RC := 1 TO LEN(__AZDOS)
		lMSErroAuto := .F.
		lMSHelpAuto := .T.
		aMovSD3		:= {}
		
		If _NTEMOP > 0
			// tratamento para produtos sem saldo em estoque
			DBSELECTAREA("SD4")
			DBSETORDER(2)
			IF DBSEEK(XFILIAL("SD4")+ALLTRIM(__AZDOS[RC,6]))
				
				WHILE !EOF() .AND. SUBSTR(ALLTRIM(SD4->D4_OP),1,6) == SUBSTR(ALLTRIM(__AZDOS[RC,6]),1,6)
					
					// ESTRUTURA DE PRODUTOS
					DBSELECTAREA("SG1")
					DBSETORDER(1)
					IF !DBSEEK(XFILIAL("SG1")+SD4->(D4_COD))  // NAO E SUB-KIT
						
						// CONSULTA SALDO EM ESTOQUE
						DBSELECTAREA("SB2")
						DBSETORDER(1)
						IF DBSEEK(XFILIAL("SB2")+SD4->(D4_COD+D4_LOCAL))
							_NTOTPO     := (SB2->B2_QATU)
							_NTOTNE     := (SB2->B2_RESERVA+SD4->D4_QUANT)
							
							IF (_NTOTPO - _NTOTNE  ) < 0
								_nTdSep++
								CLOG += "Produto ==> " + SD4->D4_COD + "OP ==> " + SD4->D4_OP + " Saldo " + TRANSFORM((_NTOTPO - _NTOTNE),"999,999.99")+chr(13)+chr(10)
							ENDIF
							
						ELSE
							_nTdSep++
							
							// INCLUI O PRODUTO NO SALDO EM ESTOQUE QUANDO NAO EXISTIR
							DBSELECTAREA("SB2")
							RECLOCK("SB2",.T.)
							SB2->B2_FILIAL := XFILIAL("SB2")
							SB2->B2_COD    := __AZDOS[RC,3]
							SB2->B2_LOCAL  := "01"
							MSUNLOCK("SB2")
							CLOG := "Produto ==> "+ SD4->D4_COD  + "OP ==> " + SD4->D4_OP + " Saldo " +  TRANSFORM((_NTOTPO - _NTOTNE),"999,999.99")+chr(13)+chr(10)
						ENDIF
					ENDIF
					
					DBSELECTAREA("SD4")
					DBSKIP()
					LOOP
				END
			ENDIF
		ENDIF
	NEXT
	
	// TRATAMENTO PARA PRODUTOS QUE NAO TEM ESTOQUE
	// NAO DEIXAR DAR BAIXA DA ORDEM DE SERVICO
	IF _nTdSep > 0
		MSGALERT("Esta Ordem de Serviço, apresenta itens que não tem saldo em estoque !!! Não será possivel executar esta operação.", "ATENÇÂO")
		
		// funcao de tela....
		u_ESTNG(cLog)
		RETURN   //  ===>>   É O CARA.......
	ENDIF
	
	// TEM Q SAIR CARALHO !!!!! SENAO O ALEMAO VAI FICAR FALANDO......
	IF _nTdSep > 0
		RETURN
	ENDIF
	
	// FAZ A MOVIMENTACAO DOS ITENS...
	FOR RC := 1 TO LEN(__AZDOS)
		lMSErroAuto := .F.
		lMSHelpAuto := .T.
		aMovSD3		:= {}
		
		If _NTEMOP = 0 .AND. _NSEMOP > 0   // SO TEM DEVOLUCAO
			
			// INCLUI O PRODUTO NO SALDO EM ESTOQUE QUANDO NAO EXISTIR
			DBSELECTAREA("SB2")
			DBSETORDER(1)
			IF !DBSEEK(XFILIAL("SB2")+__AZDOS[RC,3]+"01")
				DBSELECTAREA("SB2")
				RECLOCK("SB2",.T.)
				SB2->B2_FILIAL := XFILIAL("SB2")
				SB2->B2_COD    := __AZDOS[RC,3]
				SB2->B2_LOCAL  := "01"
				MSUNLOCK("SB2")
			ENDIF
			
			AAdd(aMovSD3,{'D3_FILIAL'	,__AZDOS[RC,1],Nil})
			AAdd(aMovSD3,{'D3_TM'		,__AZDOS[RC,2],Nil})
			AAdd(aMovSD3,{'D3_COD'		,__AZDOS[RC,3],Nil})
			AAdd(aMovSD3,{'D3_QUANT'	,__AZDOS[RC,4],Nil})
			AAdd(aMovSD3,{'D3_LOCAL'	,__AZDOS[RC,5],Nil})
			AAdd(aMovSD3,{'D3_EMISSAO'	,dDataBase    ,Nil})
			AAdd(aMovSD3,{'D3_OBS'	    ,__AZDOS[RC,7],Nil})
			AAdd(aMovSD3,{'D3_CLIENTE'	,__AZDOS[RC,8],Nil})
			
			MsExecAuto({|x,y|MATA240(x,y)}, aMovSD3  , 3)
			
		Else  // TEM ORDEM DE PRODUCAO E DEVOLUCAO
			
			IF !EMPTY(ALLTRIM(__AZDOS[RC,6]))  // APONTAMENTO DE OP
				AAdd(aMovSD3,{'D3_OP'	    ,__AZDOS[RC,6],Nil})
				AAdd(aMovSD3,{'D3_TM'		,"101"        ,Nil})
				AAdd(aMovSD3,{'D3_FILIAL'	,__AZDOS[RC,1],Nil})
				AAdd(aMovSD3,{'D3_COD'		,__AZDOS[RC,3],Nil})
				AAdd(aMovSD3,{'D3_QUANT'	,__AZDOS[RC,4],Nil})
				AAdd(aMovSD3,{'D3_LOCAL'	,__AZDOS[RC,5],Nil})
				AAdd(aMovSD3,{'D3_EMISSAO'	,dDataBase    ,Nil})
				AAdd(aMovSD3,{'D3_OBS'	    ,__AZDOS[RC,7],Nil})
				AAdd(aMovSD3,{'D3_CLIENTE'	,__AZDOS[RC,8],Nil})
				
				MSExecAuto({|x,y| mata250(x, y)},aMovSD3, 3 )
				
			ELSE  // DEVOLUCAO AO ESTOQUE
				
				AAdd(aMovSD3,{'D3_FILIAL'	,__AZDOS[RC,1],Nil})
				AAdd(aMovSD3,{'D3_TM'		,__AZDOS[RC,2],Nil})
				AAdd(aMovSD3,{'D3_COD'		,__AZDOS[RC,3],Nil})
				AAdd(aMovSD3,{'D3_QUANT'	,__AZDOS[RC,4],Nil})
				AAdd(aMovSD3,{'D3_LOCAL'	,__AZDOS[RC,5],Nil})
				AAdd(aMovSD3,{'D3_EMISSAO'	,dDataBase    ,Nil})
				AAdd(aMovSD3,{'D3_OBS'	    ,__AZDOS[RC,7],Nil})
				AAdd(aMovSD3,{'D3_CLIENTE'	,__AZDOS[RC,8],Nil})
				
				MsExecAuto({|x,y|MATA240(x,y)}, aMovSD3  , 3)
			ENDIF
		ENDIF
		
		If lMsErroAuto
			MostraErro()
		Endif
		
		lMSHelpAuto := .F.
	NEXT
	
	
	IF !lMsErroAuto
		_DAPODT01 := CTOD("  /  /  ")  // data inicio
		_CAPOT001 := space(06) // hora inicio
		_DAPODT02 := CTOD("  /  /  ")  // data final
		_CAPOT002 := space(06) // hora final
		_CAPOOBS  := SPACE(200)
		
		DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Encerramento") From 0,0 To 280,505 PIXEL OF oMainWnd
		@ 10, 007   Say OemToAnsi("Apontamento das horas trabalhada no processo de encerramento") PIXEL
		@ 22, 007  	SAY OemToAnsi("Cod.Funcionario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
		@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
		@ 35, 050	MSGET _DAPODT01 SIZE 40,08 Valid VInDtRec(_DAPODT01,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
		@ 35, 215 	MSGET _CAPOT001 Picture "99:99" SIZE 25,08  Valid VInHrRec(_DAPODT01,_CAPOT001,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
		@ 48, 050	MSGET _DAPODT02 SIZE 40,08 Valid VfmDtRec(_DAPODT01,_DAPODT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
		@ 48, 215 	MSGET _CAPOT002 Picture "99:99" SIZE 25,08 Valid VfmHrRec(_DAPODT01,_DAPODT02,_CAPOT001,_CAPOT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 61, 007	Say OemToAnsi("Observação ") PIXEL				//
		@ 68, 007   GET oDesc VAR _CAPOOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
		ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
		
		If nOpca = 1
			
			DBSELECTAREA("SZA")
			RECLOCK("SZA",.F.)
			SZA->ZA_STATUS  := "E"
			SZA->ZA_ENCERRA := __CUSR + " - " + UsrRetName(__CUSR) + " - ENCERRADO EM : " + DTOC(DDATABASE)+ " - " + TIME()
			SZA->ZA_DTFIM   := _DAPODT02
			SZA->ZA_TERMINI := _CAPOT002
			MSUNLOCK("SZA")
			
			// TABELA SZE --> RELATORIO
			DBSELECTAREA("SZE")
			RECLOCK("SZE",.T.)
			SZE->ZE_FILIAL  := XFILIAL("SZE")
			SZE->ZE_IDOS    := SZA->ZA_IDOS
			SZE->ZE_EMISSAO := _DAPODT01
			SZE->ZE_HORAINI := _CAPOT001
			SZE->ZE_DTFIM   := _DAPODT02
			SZE->ZE_HORAFIM := _CAPOT002
			SZE->ZE_FUNC    := __CUSR
			SZE->ZE_NOME    := UsrRetName(__CUSR)
			SZE->ZE_OBS     := "ENCERRAMENTO " + SUBSTRING(_CAPOOBS,1,200)
			MsUnLock("SZE")
		Endif
	Endif
	
ELSEIF SZA->ZA_STATUS == "M"  // RECUSA FABRICA DEVE GERAR DEVOLUCAO
	
	__CUSR      :=  RetCodUsr()
	__CZDOS     := SZA->ZA_IDOS
	__CZDCL     := SZA->ZA_NOME
	__AZDOS     := {}
	nopca	    := 0
	_NTEMOP     := 0
	_nTdSep     := 0
	_NTOTPO     := 0
	_NTOTNE     := 0
	lMSErroAuto := .F.
	
	// ARQUIVO DA MODIFICACAO
	DBSELECTAREA("SZD")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SZD")+__CZDOS)
		WHILE !EOF() .AND. SZD->ZD_IDOS == __CZDOS
			
			IF SZD->ZD_QTDSAI = 0.AND. EMPTY(SZD->ZD_PRODUTO)
				DBSELECTAREA("SZD")
				DBSKIP()
				LOOP
			ENDIF
			
			IF SZD->ZD_QTDSAI > 0 .AND. EMPTY(SZD->ZD_PRODUTO)
				MSGALERT("Codigo do produto esta em BRANCO !!! Não será possivel executar esta operação.", "ATENÇÂO")
				RETURN
			ELSEIF SZD->ZD_QTDSAI = 0 .AND. !EMPTY(SZD->ZD_PRODUTO)
				MSGALERT("Quantidade zerada !!! Não será possivel executar esta operação.", "ATENÇÂO")
				RETURN
			ENDIF
			
			IF SZD->ZD_QTDSAI < 0
				MSGALERT("Quantidade NEGATIVA !!! Não será possivel executar esta operação.", "ATENÇÂO")
				RETURN
			ENDIF
			
			IF !EMPTY(SZD->ZD_OP)
				_NTEMOP++
			ENDIF
			
			DBSELECTAREA("SZD")
			
			AAdd(__AZDOS,{SZD->ZD_FILIAL,"201",SZD->ZD_PRODUTO,SZD->ZD_QTDSAI,"01",__CZDOS,SZD->ZD_OP,__CZDCL})
			
			DBSELECTAREA("SZD")
			DBSKIP()
			LOOP
		END
		
		
		//-- REQUISITA DO LOTE INDICADO NA
		FOR RC := 1 TO LEN(__AZDOS)
			lMSErroAuto := .F.
			lMSHelpAuto := .T.
			aMovSD3		:= {}
			
			AAdd(aMovSD3,{'D3_FILIAL'	,__AZDOS[RC,1],Nil})
			AAdd(aMovSD3,{'D3_TM'		,__AZDOS[RC,2],Nil})
			AAdd(aMovSD3,{'D3_COD'		,__AZDOS[RC,3],Nil})
			AAdd(aMovSD3,{'D3_QUANT'	,__AZDOS[RC,4],Nil})
			AAdd(aMovSD3,{'D3_LOCAL'	,__AZDOS[RC,5],Nil})
			AAdd(aMovSD3,{'D3_EMISSAO'	,dDataBase    ,Nil})
			AAdd(aMovSD3,{'D3_OBS'	    ,__AZDOS[RC,6],Nil})
			AAdd(aMovSD3,{'D3_CLIENTE'  ,__AZDOS[RC,8],Nil})
			
			MsExecAuto({|x,y|MATA240(x,y)}, aMovSD3  , 3)
			
			If lMsErroAuto
				MostraErro()
			Endif
			
			lMSHelpAuto := .F.
		NEXT
	ENDIF
	
	IF !lMsErroAuto
		
		_DSEPDT01 := CTOD("  /  /  ")  // data inicio
		_CSEPT001 := space(06) // hora inicio
		_DSEPDT02 := CTOD("  /  /  ")  // data final
		_CSEPT002 := space(06) // hora final
		_CSEPOBS  := SPACE(200)
		
		DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Apontamento") From 0,0 To 280,505 PIXEL OF oMainWnd
		@ 10, 007   Say OemToAnsi("Apontamento das horas trabalhada no processo de Encerramento") PIXEL
		@ 22, 007  	SAY OemToAnsi("Cod.Funcionario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
		@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
		@ 35, 050	MSGET _DSEPDT01 SIZE 40,08 Valid VInDtRec(_DSEPDT01,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
		@ 35, 215 	MSGET _CSEPT001 Picture "99:99" SIZE 25,08 Valid VInHrRec(_DSEPDT01,_CSEPT001,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
		@ 48, 050	MSGET _DSEPDT02 SIZE 40,08 Valid VfmDtRec(_DSEPDT01,_DSEPDT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
		@ 48, 215 	MSGET _CSEPT002 Picture "99:99" SIZE 25,08 Valid VfmHrRec(_DSEPDT01,_DSEPDT02,_CSEPT001,_CSEPT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 61, 007	Say OemToAnsi("Observação ") PIXEL				//
		@ 68, 007   GET oDesc VAR _CSEPOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
		ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
		
		If nOpca = 1
			
			DBSELECTAREA("SZA")
			RECLOCK("SZA",.F.)
			SZA->ZA_STATUS := "E"
			SZA->ZA_SEPARAC := __CUSR + " - " + UsrRetName(__CUSR) + " - ENCERRADO EM : " + DTOC(DDATABASE)+ " - " + TIME()
			MSUNLOCK("SZA")
			
			// TABELA SZE --> RELATORIO
			DBSELECTAREA("SZE")
			RECLOCK("SZE",.T.)
			SZE->ZE_FILIAL  := XFILIAL("SZE")
			SZE->ZE_IDOS    := SZA->ZA_IDOS
			SZE->ZE_EMISSAO := _DSEPDT01
			SZE->ZE_HORAINI := _CSEPT001
			SZE->ZE_DTFIM   := _DSEPDT02
			SZE->ZE_HORAFIM := _CSEPT002
			SZE->ZE_FUNC    := __CUSR
			SZE->ZE_NOME    := UsrRetName(__CUSR)
			SZE->ZE_OBS     := "ENCERRADO " + ALLTRIM(SUBSTRING(_CSEPOBS,1,200))
			MsUnLock("SZE")
		Endif
	ENDIF
ELSE
	IF SZA->ZA_STATUS == "E"
		MSGALERT("Ordem de Servico, no processo de ENCERRADA. Operação de ENCERRAMENTO, invalida !!!", "Ordem de Servico - Status Encerrada")
	ELSEIF SZA->ZA_STATUS == "R"
		MSGALERT("Ordem de Servico, ja se encontra RECUSADA. Operação de ENCERRAMENTO, invalida !!!", "Ordem de Servico - Status Recusada")
	ELSEIF SZA->ZA_STATUS == "L"
		MSGALERT("Ordem de Servico, ja se encontra APROVADA. Operação de ENCERRAMENTO, invalida !!!", "Ordem de Servico - Status Aprovada")
	ELSEIF SZA->ZA_STATUS == "J"
		MSGALERT("Ordem de Servico, ja se encontra PENDENTE. Operação de ENCERRAMENTO, invalida !!!", "Ordem de Servico - Status Pendente")
	ENDIF
ENDIF
RETURN


// FUNCAO PARA TRATAMENTO DE Estorno DA OS
// E MUDANCA DO STATUS DA ORDEM DE SERVICO
USER FUNCTION OSESTORN()

local RC
__CUSR :=  RetCodUsr()
__CZDOS := SZA->ZA_IDOS
__AZDOS := {}
nopca	:= 0
_NTEMOP := 0
lMsErroAuto := .f.

IF SZA->ZA_STATUS $ "S/J/M"
	
	IF SZA->ZA_STATUS $ "S/M"
		// ARQUIVO DA MODIFICACAO
		DBSELECTAREA("SZD")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SZD")+__CZDOS)
			WHILE !EOF() .AND. SZD->ZD_IDOS == __CZDOS
				
				IF SZD->ZD_QTDSAI = 0.AND. EMPTY(SZD->ZD_PRODUTO)
					DBSELECTAREA("SZD")
					DBSKIP()
					LOOP
				ENDIF
				
				IF SZD->ZD_QTDSAI > 0 .AND. EMPTY(SZD->ZD_PRODUTO)
					MSGALERT("Codigo do produto esta em BRANCO !!! Não será possivel executar esta operação.", "ATENÇÂO")
					RETURN
				ELSEIF SZD->ZD_QTDSAI = 0 .AND. !EMPTY(SZD->ZD_PRODUTO)
					MSGALERT("Quantidade zerada !!! Não será possivel executar esta operação.", "ATENÇÂO")
					RETURN
				ENDIF
				
				IF !EMPTY(SZD->ZD_OP)
					_NTEMOP++
				ENDIF
				
				AAdd(__AZDOS,{SZD->ZD_FILIAL,"201",SZD->ZD_PRODUTO,SZD->ZD_QTDSAI,"01",__CZDOS,SZD->ZD_OP})
				
				DBSELECTAREA("SZD")
				DBSKIP()
				LOOP
			END
			
			IF _NTEMOP = 0
				
				//-- REQUISITA DO LOTE INDICADO NA
				FOR RC := 1 TO LEN(__AZDOS)
					lMSErroAuto := .F.
					lMSHelpAuto := .T.
					aMovSD3		:= {}
					
					
					AAdd(aMovSD3,{'D3_FILIAL'	,__AZDOS[RC,1],Nil})
					AAdd(aMovSD3,{'D3_TM'		,__AZDOS[RC,2],Nil})
					AAdd(aMovSD3,{'D3_COD'		,__AZDOS[RC,3],Nil})
					AAdd(aMovSD3,{'D3_QUANT'	,__AZDOS[RC,4],Nil})
					AAdd(aMovSD3,{'D3_LOCAL'	,__AZDOS[RC,5],Nil})
					AAdd(aMovSD3,{'D3_EMISSAO'	,dDataBase    ,Nil})
					AAdd(aMovSD3,{'D3_OBS'	    ,__AZDOS[RC,6],Nil})
					
					MsExecAuto({|x,y|MATA240(x,y)}, aMovSD3  , 3)
					
					If lMsErroAuto
						MostraErro()
					Endif
					
					lMSHelpAuto := .F.
				NEXT
			ENDIF
		ENDIF
	ENDIF
	
	IF !lMsErroAuto
		_DAPODT01 := CTOD("  /  /  ")  // data inicio
		_CAPOT001 := space(06) // hora inicio
		_DAPODT02 := CTOD("  /  /  ")  // data final
		_CAPOT002 := space(06) // hora final
		_CAPOOBS  := SPACE(200)
		
		DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Estorno") From 0,0 To 280,505 PIXEL OF oMainWnd
		@ 10, 007   Say OemToAnsi("Apontamento das horas trabalhada no processo de estorno") PIXEL
		@ 22, 007  	SAY OemToAnsi("Cod.Funcionario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
		@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
		@ 35, 050	MSGET _DAPODT01 SIZE 40,08 Valid VInDtRec(_DAPODT01,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
		@ 35, 215 	MSGET _CAPOT001 Picture "99:99" SIZE 25,08 Valid VInHrRec(_DAPODT01,_CAPOT001,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
		@ 48, 050	MSGET _DAPODT02 SIZE 40,08 Valid VfmDtRec(_DAPODT01,_DAPODT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
		@ 48, 215 	MSGET _CAPOT002 Picture "99:99" SIZE 25,08 Valid VfmHrRec(_DAPODT01,_DAPODT02,_CAPOT001,_CAPOT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
		@ 61, 007	Say OemToAnsi("Observação ") PIXEL				//
		@ 68, 007   GET oDesc VAR _CAPOOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
		ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
		
		If nOpca = 1
			
			DBSELECTAREA("SZA")
			RECLOCK("SZA",.F.)
			SZA->ZA_STATUS := ""
			SZA->ZA_ENCERRA := __CUSR + " - " + UsrRetName(__CUSR) + " - Estorno EM : " + DTOC(DDATABASE)+ " - " + TIME()
			MSUNLOCK("SZA")
			
			
			// TABELA SZE --> RELATORIO
			DBSELECTAREA("SZE")
			RECLOCK("SZE",.T.)
			SZE->ZE_FILIAL  := XFILIAL("SZE")
			SZE->ZE_IDOS    := SZA->ZA_IDOS
			SZE->ZE_EMISSAO := _DAPODT01
			SZE->ZE_HORAINI := _CAPOT001
			SZE->ZE_DTFIM   := _DAPODT02
			SZE->ZE_HORAFIM := _CAPOT002
			SZE->ZE_FUNC    := __CUSR
			SZE->ZE_NOME    := UsrRetName(__CUSR)
			SZE->ZE_OBS     := "ESTORNO " + SUBSTRING(_CAPOOBS,1,200)
			MsUnLock("SZE")
		Endif
	Endif
ELSE
	IF SZA->ZA_STATUS == "O"
		MSGALERT("Ordem de Servico, no processo de APONTAMENTO. Operação de ESTORNO, invalida !!!", "Ordem de Servico - Status Apontamento")
	ELSEIF SZA->ZA_STATUS == "E"
		MSGALERT("Ordem de Servico, no processo de ENCERRADA. Operação de ESTORNO, invalida !!!", "Ordem de Servico - Status Encerrada")
	ELSEIF SZA->ZA_STATUS == "R"
		MSGALERT("Ordem de Servico, ja se encontra RECUSADA. Operação de ESTORNO, invalida !!!", "Ordem de Servico - Status Recusada")
	ELSEIF SZA->ZA_STATUS == "L"
		MSGALERT("Ordem de Servico, ja se encontra APROVADA. Operação de ESTORNO, invalida !!!", "Ordem de Servico - Status Aprovada")
	ENDIF
ENDIF
RETURN

// FUNCAO PARA TRATAMENTO DE IMPRESSAO SE ORDEM
// DE SERVICO VIA CRYSTAL
USER FUNCTION OSIMPSV()
/*
CALLCRYS(rpt , params, options), onde
rpt = Nome do relatório, sem o caminho.
params = Parâmetros do relatório, separados por vírgula ou ponto e vírgula. Caso seja setado este parâmetro, serão desconsiderados os parâmetros setados no SX1.
options = Opções para não se mostrar a tela de configuração de impressão , no formato x;y;z;w ,onde:
x = Impressão em Vídeo(1) ou Impressora(2)
y = Atualiza Dados(0) ou não(1)
z = Número de Cópias
w =Título do Report

Exemplo:

Local cParams,cOptions
cParams := "1;UNI;217872;217873"
cOptions := "1;0;1;Minuta de Despacho"
CallCrys("FA_001", cParams,cOptions)
*/
STATIC cParams,cOptions
cParams  := SZA->ZA_IDOS   //"000000001"
cOptions := "1;0;1;Ordem de Servico"

if SM0->M0_CODIGO == "01"
	CallCrys("OSVERION01",cParams,cOptions)
ELSE
	CallCrys("OSAEMN01",cParams,cOptions)
ENDIF
RETURN                            

// =============== MENU DE MANUTENCAO DAS TABELAS AUXILIARES ==================== //
// CADASTRO DE FUNCIONARIO
USER FUNCTION OSFUNCIO(_ncnc)

If _ncnc = 1
	msgalert("Usuario sem autorizacao de uso.","Atenção")
	Return
Endif

AXCADASTRO("AA1","Funcionario")
RETURN

// CADSTRO DE SERVICOS
USER FUNCTION OSSERVIC()
AXCADASTRO("AA5","Serviços")
RETURN


// teala de mensagem de estoque negativo.....
USER FUNCTION ESTNG(cLog)
local cTexto := cLog
local oDlg
local oMemo
local Retorno

DEFINE MSDIALOG oDlg TITLE "Texto a ser processado" FROM 0,0 TO 555,650 PIXEL
@ 005, 005 GET oMemo VAR cTexto MEMO SIZE 315, 250 OF oDlg PIXEL
@ 260, 280 Button "OK" Size 015, 015 PIXEL OF oDlg Action(Auxiliar(oDlg))
ACTIVATE MSDIALOG oDlg CENTERED
Return

Static Function Auxiliar(oDlg)
Retorno := oDlg:End()
Return(Retorno)


// PROCESSO DE VALIDACAO DE RECUSADA DATA INICIAL X DATA FINAL DA INCLUSAO ==> INICIAL ....
Static Function VInDtRec(_DSEPDT01,_CIDOSF)
_lvldDt := .T.
_nVldDt := 0
_xArea  :=	GetArea()

// primeiro passo validacao de data
// 1 - data informada em relacao a do sistema
If _DSEPDT01 < DDATABASE
	MSGALERT("Data Informada menor que a data do sistema. Favor Corrigir a data !!!","Data Inicial Menor que Data Sistema" )
	//     _nVldDt++
	//     _lvldDt := .F.
Endif

// 2 - Data informada x fim data inclusao
If _nVldDt = 0
	
	_dDtAcFm := AchDtfim("",_CIDOSF)  // ACHA O REGISTRO DE INCLUSAO PARA ANALISE
	
	If _DSEPDT01 < _dDtAcFm[1]
		MSGALERT("Data Informada menor que a data de INCLUSAO. DATA INCLUSAO --> " + DTOC(_dDtAcFm[1]) +". Favor Corrigir a data !!!","Data Recusa X Data Inclusao")
		_nVldDt++
		_lvldDt := .F.
	Endif
Endif

RestArea(_xArea)
return(_lvldDt)

// TRATAMENTO DE HORA INICIAL
Static Function VInHrRec(_DSEPDT01,_CSEPT001,_CIDOSF)
_lvldHR := .T.
_nVldhr := 0
_xArehr :=	GetArea()

// VALIDAR HORA DIGITADA ENTRE 07:00 E 19:00
IF _CSEPT001 < "07:00" .OR. _CSEPT001 > "19:00"
	MSGALERT("Hora informada fora do expediente de trabalho. Favor Corrigir a hora !!!","Horario 07:00 - 19:00")
	_nVldhr++
	_lvldhr := .F.
ENDIF

// VALIDAR DATA E HORA FIM INCLUSAO X DATA E HORA INFORMADA
If _nVldHR = 0
	
	_dDtAcFm := AchDtfim("",_CIDOSF)  // ACHA O REGISTRO DE INCLUSAO PARA ANALISE
	
	If _DSEPDT01 = _dDtAcFm[1]
		IF _CSEPT001 < _dDtAcFm[2]
			MSGALERT("Hora Informada menor que a HORA DA INCLUSAO. HORA INCLUSAO --> " + _dDtAcFm[2] +". Favor Corrigir a Hora !!!","Hora Recusa X Hora Inclusao")
			_nVldhr++
			_lvldhr := .F.
		ENDIF
	Endif
Endif

RestArea(_xArehr)
return(_lvldHR)

// PROCESSO DE VALIDACAO DE RECUSADA DATA INICIAL X DATA FINAL DA INCLUSAO ==> FINAL ....
Static Function VFMDtRec(_DSEPDT01,_DSEPDT02,_CIDOSF)
_lvldDt := .T.
_nVldDt := 0
_xArea  :=	GetArea()

// primeiro passo validacao de data
// 1 - data informada em relacao a do sistema
If _DSEPDT02 < DDATABASE
	MSGALERT("Data Informada menor que a data do sistema. Favor Corrigir a data !!!","Data Inicial Menor que Data Sistema" )
	//     _nVldDt++
	//     _lvldDt := .F.
Endif

// 2 - Data informada x fim data inclusao
If _nVldDt = 0
	
	_dDtAcFm := AchDtfim("",_CIDOSF)  // ACHA O REGISTRO DE INCLUSAO PARA ANALISE
	
	If _DSEPDT02 < _DSEPDT01
		MSGALERT("Data Informada menor que a DATA INICIO. DATA INICIO --> " + DTOC(_DSEPDT01) +". Favor Corrigir a data !!!","Data Recusa X Data Inicio")
		_nVldDt++
		_lvldDt := .F.
	Endif
Endif

RestArea(_xArea)
return(_lvldDt)


// TRATAMENTO DE HORA FINAL
Static Function VFMHrRec(_DSEPDT01,_DSEPDT02,_CSEPT001,_CSEPT002,_CIDOSF)
_lvldHR := .T.
_nVldhr := 0
_xArehr :=	GetArea()

// VALIDAR HORA DIGITADA ENTRE 07:00 E 19:00
IF _CSEPT002 < "07:00" .OR. _CSEPT002 > "19:00"
	MSGALERT("Hora informada fora do expediente de trabalho. Favor Corrigir a hora !!!","Horario 07:00 - 19:00")
	_nVldhr++
	_lvldhr := .F.
ENDIF

// VALIDAR DATA E HORA FIM INCLUSAO X DATA E HORA INFORMADA
If _nVldHR = 0
	
	If _DSEPDT01 = _DSEPDT02
		IF _CSEPT002 < _CSEPT001
			MSGALERT("Hora Informada menor que a HORA INICIO. HORA INICIO --> " + _CSEPT001 +". Favor Corrigir a Hora !!!","Hora Recusa X Hora Inicio")
			_nVldhr++
			_lvldhr := .F.
		ENDIF
	Endif
Endif

RestArea(_xArehr)
return(_lvldHR)

// query para achar o registro de inclusao, recusa, aprovacao, separacao, apontamento, enc apontamento,enc os
STATIC FUNCTION  AchDtfim(cOpeAcha,_CIDOSFI)
_cOpAc  := cOpeAcha
_NOPAC  := STR(LEN(ALLTRIM(cOpeAcha)))
_cquery := ""
_AdDtQAc := {}

_cquery := "SELECT TOP 1 * "
_cquery += " FROM "+RetSqlName("SZE")+" SZE "
_cquery += " WHERE SZE.D_E_L_E_T_ = '' AND ZE_IDOS = '" + _CIDOSFI + "' "
_cquery += " ORDER BY ZE_DTFIM+ZE_HORAFIM DESC "

//TCQuery Abre uma workarea com o resultado da query
TCQUERY _cquery NEW ALIAS "QUACH"

// Arquivo Temporario resultado do Select nas tabelas: Socio,Endereco,Empresa
DBSELECTAREA("QUACH")
DBGOTOP()
While !Eof()
	_ADtQAc := {StoD(QUACH->ZE_DTFIM),QUACH->ZE_HORAFIM}
	DbSkip()
	Loop
End

DBSELECTAREA("QUACH")
DBCLOSEAREA("QUACH")
RETURN(_ADtQAc)


//N FUNCAO DE ESTORNO DE OS ENCERRADAS
USER FUNCTION OSESTENC()

local RC
__CUSR :=  RetCodUsr()
__CZDOS := SZA->ZA_IDOS
__AZDOS := {}
nopca	:= 0
_NTEMOP := 0
lMsErroAuto := .f.

IF SZA->ZA_STATUS $ "E/C/S"
	
	IF SZA->ZA_STATUS $ "E/S"
		IF SZA->ZA_TIPO = "7"
		// ARQUIVO DA MODIFICACAO
		DBSELECTAREA("SZD")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SZD")+__CZDOS)
			WHILE !EOF() .AND. SZD->ZD_IDOS == __CZDOS
				
				IF !EMPTY(SZD->ZD_OP)
					_NTEMOP++
				ELSE
					_NSEMOP++
				ENDIF
				
				AAdd(__AZDOS,{SZD->ZD_FILIAL,"201",SZD->ZD_PRODENT,SZD->ZD_QTDEENT,"01",SZD->ZD_OP,__CZDOS,__CZDCL})
				
				DBSELECTAREA("SZD")
				DBSKIP()
				LOOP
			END
		ENDIF
		
		
		// FAZ A MOVIMENTACAO DOS ITENS...
		FOR RC := 1 TO LEN(__AZDOS)
			lMSErroAuto := .F.
			lMSHelpAuto := .T.
			aMovSD3		:= {}
			
			If _NTEMOP = 0 .AND. _NSEMOP > 0   // SO TEM DEVOLUCAO
				
				AAdd(aMovSD3,{'D3_FILIAL'	,__AZDOS[RC,1],Nil})
				AAdd(aMovSD3,{'D3_TM'		,__AZDOS[RC,2],Nil})
				AAdd(aMovSD3,{'D3_COD'		,__AZDOS[RC,3],Nil})
				AAdd(aMovSD3,{'D3_QUANT'	,__AZDOS[RC,4],Nil})
				AAdd(aMovSD3,{'D3_LOCAL'	,__AZDOS[RC,5],Nil})
				AAdd(aMovSD3,{'D3_EMISSAO'	,dDataBase    ,Nil})
				AAdd(aMovSD3,{'D3_OBS'	    ,__AZDOS[RC,7],Nil})
				AAdd(aMovSD3,{'D3_CLIENTE'	,__AZDOS[RC,8],Nil})
				
				MsExecAuto({|x,y|MATA240(x,y)}, aMovSD3  , 5)
				
			Else  // TEM ORDEM DE PRODUCAO E DEVOLUCAO
				
				IF !EMPTY(ALLTRIM(__AZDOS[RC,6]))  // APONTAMENTO DE OP
					AAdd(aMovSD3,{'D3_OP'	    ,__AZDOS[RC,6],Nil})
					AAdd(aMovSD3,{'D3_TM'		,"101"        ,Nil})
					AAdd(aMovSD3,{'D3_FILIAL'	,__AZDOS[RC,1],Nil})
					AAdd(aMovSD3,{'D3_COD'		,__AZDOS[RC,3],Nil})
					AAdd(aMovSD3,{'D3_QUANT'	,__AZDOS[RC,4],Nil})
					AAdd(aMovSD3,{'D3_LOCAL'	,__AZDOS[RC,5],Nil})
					AAdd(aMovSD3,{'D3_EMISSAO'	,dDataBase    ,Nil})
					AAdd(aMovSD3,{'D3_OBS'	    ,__AZDOS[RC,7],Nil})
					AAdd(aMovSD3,{'D3_CLIENTE'	,__AZDOS[RC,8],Nil})
					
					MSExecAuto({|x,y| mata250(x, y)},aMovSD3, 5 )
					
				ELSE  // DEVOLUCAO AO ESTOQUE
					
					AAdd(aMovSD3,{'D3_FILIAL'	,__AZDOS[RC,1],Nil})
					AAdd(aMovSD3,{'D3_TM'		,__AZDOS[RC,2],Nil})
					AAdd(aMovSD3,{'D3_COD'		,__AZDOS[RC,3],Nil})
					AAdd(aMovSD3,{'D3_QUANT'	,__AZDOS[RC,4],Nil})
					AAdd(aMovSD3,{'D3_LOCAL'	,__AZDOS[RC,5],Nil})
					AAdd(aMovSD3,{'D3_EMISSAO'	,dDataBase    ,Nil})
					AAdd(aMovSD3,{'D3_OBS'	    ,__AZDOS[RC,7],Nil})
					AAdd(aMovSD3,{'D3_CLIENTE'	,__AZDOS[RC,8],Nil})
					
					MsExecAuto({|x,y|MATA240(x,y)}, aMovSD3  , 5)
				ENDIF
			ENDIF
			
			If lMsErroAuto
				MostraErro()
			Endif
			
			lMSHelpAuto := .F.
		NEXT
		ENDIF
		
		IF !lMsErroAuto
			_DAPODT01 := CTOD("  /  /  ")  // data inicio
			_CAPOT001 := space(06) // hora inicio
			_DAPODT02 := CTOD("  /  /  ")  // data final
			_CAPOT002 := space(06) // hora final
			_CAPOOBS  := SPACE(200)
			
			DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Estorno Encerramento") From 0,0 To 280,505 PIXEL OF oMainWnd
			@ 10, 007   Say OemToAnsi("Apontamento das horas trabalhada no Estorno do encerramento") PIXEL
			@ 22, 007  	SAY OemToAnsi("Cod.Funcionario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
			@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
			@ 35, 050	MSGET _DAPODT01 SIZE 40,08 Valid VInDtRec(_DAPODT01,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
			@ 35, 215 	MSGET _CAPOT001 Picture "99:99" SIZE 25,08  Valid VInHrRec(_DAPODT01,_CAPOT001,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
			@ 48, 050	MSGET _DAPODT02 SIZE 40,08 Valid VfmDtRec(_DAPODT01,_DAPODT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
			@ 48, 215 	MSGET _CAPOT002 Picture "99:99" SIZE 25,08 Valid VfmHrRec(_DAPODT01,_DAPODT02,_CAPOT001,_CAPOT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 61, 007	Say OemToAnsi("Observação ") PIXEL				//
			@ 68, 007   GET oDesc VAR _CAPOOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
			ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
			
			If nOpca = 1
				
				DBSELECTAREA("SZA")
				RECLOCK("SZA",.F.)              
				
				SZA->ZA_STATUS  := ""
				SZA->ZA_ENCERRA := __CUSR + " - " + UsrRetName(__CUSR) + " - ESTORNO ENC EM : " + DTOC(DDATABASE)+ " - " + TIME()
				SZA->ZA_DTFIM   := _DAPODT02
				SZA->ZA_TERMINI := _CAPOT002
				MSUNLOCK("SZA")
				
				// TABELA SZE --> RELATORIO
				DBSELECTAREA("SZE")
				RECLOCK("SZE",.T.)
				SZE->ZE_FILIAL  := XFILIAL("SZE")
				SZE->ZE_IDOS    := SZA->ZA_IDOS
				SZE->ZE_EMISSAO := _DAPODT01
				SZE->ZE_HORAINI := _CAPOT001
				SZE->ZE_DTFIM   := _DAPODT02
				SZE->ZE_HORAFIM := _CAPOT002
				SZE->ZE_FUNC    := __CUSR
				SZE->ZE_NOME    := UsrRetName(__CUSR)
				SZE->ZE_OBS     := "EST ENC " + SUBSTRING(_CAPOOBS,1,200)
				MsUnLock("SZE")
			Endif
		Endif
	ELSE
			_DAPODT01 := CTOD("  /  /  ")  // data inicio
			_CAPOT001 := space(06) // hora inicio
			_DAPODT02 := CTOD("  /  /  ")  // data final
			_CAPOT002 := space(06) // hora final
			_CAPOOBS  := SPACE(200)
			__CUSR    :=  RetCodUsr()
			__AZDOS := {}
			nopca	:= 0
			
			DEFINE MSDIALOG __ODlg TITLE OemToAnsi("Estorno Encerramento") From 0,0 To 280,505 PIXEL OF oMainWnd
			@ 10, 007   Say OemToAnsi("Apontamento das horas trabalhada no Estorno do encerramento") PIXEL
			@ 22, 007  	SAY OemToAnsi("Cod.Funcionario" + __CUSR + " - " + UsrRetName(__CUSR)) PIXEL
			@ 35, 007  	SAY OemToAnsi("Data Inicio") PIXEL
			@ 35, 050	MSGET _DAPODT01 SIZE 40,08 Valid VInDtRec(_DAPODT01,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 35, 160 	Say OemToAnsi("Hora Inicio") PIXEL
			@ 35, 215 	MSGET _CAPOT001 Picture "99:99" SIZE 25,08  Valid VInHrRec(_DAPODT01,_CAPOT001,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 48, 007  	SAY OemToAnsi("Data Final") PIXEL
			@ 48, 050	MSGET _DAPODT02 SIZE 40,08 Valid VfmDtRec(_DAPODT01,_DAPODT02,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 48, 160 	Say OemToAnsi("Hora Final") PIXEL
			@ 48, 215 	MSGET _CAPOT002 Picture "99:99" SIZE 25,08 Valid VfmHrRec(_DAPODT01,_DAPODT02,_CAPOT001,_CAPOT002,SZA->ZA_IDOS) When .t. OF __ODlg PIXEL
			@ 61, 007	Say OemToAnsi("Observação ") PIXEL				//
			@ 68, 007   GET oDesc VAR _CAPOOBS OF __ODlg MEMO size 200,40 PIXEL  NO VSCROLL  //READONLY
			ACTIVATE MSDIALOG __ODlg  CENTERED ON INIT EnchoiceBar(__ODlg,{||nOpca:= 1,if(.T.,__ODlg:End(),nOpca := 0)},{||nOpca:=2,__ODlg:End()})
			
			If nOpca = 1
				
				DBSELECTAREA("SZA")
				RECLOCK("SZA",.F.)
				SZA->ZA_STATUS  := "S"
				SZA->ZA_ENCERRA := __CUSR + " - " + UsrRetName(__CUSR) + " - ESTORNO ENC EM : " + DTOC(DDATABASE)+ " - " + TIME()
				SZA->ZA_DTFIM   := _DAPODT02
				SZA->ZA_TERMINI := _CAPOT002
				MSUNLOCK("SZA")
				
				// TABELA SZE --> RELATORIO
				DBSELECTAREA("SZE")
				RECLOCK("SZE",.T.)
				SZE->ZE_FILIAL  := XFILIAL("SZE")
				SZE->ZE_IDOS    := SZA->ZA_IDOS
				SZE->ZE_EMISSAO := _DAPODT01
				SZE->ZE_HORAINI := _CAPOT001
				SZE->ZE_DTFIM   := _DAPODT02
				SZE->ZE_HORAFIM := _CAPOT002
				SZE->ZE_FUNC    := __CUSR
				SZE->ZE_NOME    := UsrRetName(__CUSR)
				SZE->ZE_OBS     := "EST ENC " + SUBSTRING(_CAPOOBS,1,200)
				MsUnLock("SZE")
			Endif
	ENDIF
Endif
RETURN
