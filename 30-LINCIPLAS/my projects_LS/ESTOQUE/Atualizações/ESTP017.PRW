#INCLUDE "PROTHEUS.CH"


User Function ESTP017()

Local _lTela	:= .T.

Private _cLoc	:= Space(2)
Private _cNF	:= Space(9)
Private _cSR	:= Space(3)
Private _cCli	:= Space(6)
Private _cLoj	:= Space(2)

Private nOpc
Private oCombo
Private cCombo
Private aItems	:= {"1 - Incluir"}

cCombo := aItems[1]
nOpc := Left(cCombo,1)

While _lTela
	
	DEFINE MSDIALOG oDlg FROM 000,000 TO 400,400 TITLE "Processa NF Entrada" PIXEL
	
	@ 010,050 SAY "Local: " PIXEL OF oDlg                     // Filial de entreda
	@ 010,090 MSGET oLoc VAR _cLoc SIZE 10,10 PIXEL OF oDlg
	
	@ 030,050 SAY "Nota Fiscal: " PIXEL OF oDlg               // Numero da NF de Entrada
	@ 030,090 MSGET oNF VAR _cNF SIZE 10,10 PIXEL OF oDlg
	
	@ 050,050 SAY "Serie: " PIXEL OF oDlg                     // Serie da NF de Entrada
	@ 050,090 MSGET oSR VAR _cSR SIZE 10,10 PIXEL OF oDlg
	
	@ 070,050 SAY "Fornecedor: " PIXEL OF oDlg             	  // Cliente
	@ 070,090 MSGET oCli VAR _cCli F3 "SA1" SIZE 10,10 PIXEL OF oDlg
	
	@ 090,050 SAY "Loja: " PIXEL OF oDlg                      // Loja
	@ 090,090 MSGET oLoj VAR _cLoj SIZE 10,10 PIXEL OF oDlg
	
	@ 110,050 SAY "Opcao: " PIXEL OF oDlg
	oCombo:= TComboBox():New(110,090,{|u|if(PCount()>0,cCombo:=u,cCombo)},;
	aItems,65,20,oDlg,,{|| nOpc := Left(cCombo,1) },,,,.T.,,,,,,,,,"cCombo")
	
	@ 140,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION(LjMsgRun("Aguarde..., Processando Nota Fiscal...",, {||  GeraPreNota( _cCli, _cLoj, _cNF, _cSR ) }) )
	@ 140,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(_lTela := .F.,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
EndDo

Return



Static Function GeraPreNota( cFornece, cLoja, cNF, cSR )


Private aCab     	:=  {}
Private aItens		:=  {}
Private aLinha      := 	{}
Private lMsErroAuto := .F.
Private cRomaneio

If SM0->M0_CODFIL == _cLoc
	
	dbSelectArea("SD2")
	dbSetOrder(3)
	If dbSeek(cLoja+cNF+cSR)
		
		dbSelectArea("PA6")
		dbSetOrder(1)
		If !dbSeek( xFilial( "PA6" ) + SD2->D2_PEDIDO + SD2->D2_FILIAL )
			
			dbSelectArea("SF2")
			SF2->(DbSetOrder(1))
			SF2->(DbGoTop())
			
			If !SF2->(DbSeek(cLoja+cNF+cSR))
				Alert("Nota fiscal " + _CNF + " não encontrada na filial " + cLoja )
				Return
			EndIf
			
			aAdd(aCab,{"F1_TIPO",			"N" 			})
			aAdd(aCab,{"F1_FORMUL",      	"N" 			})
			aAdd(aCab,{"F1_DOC",         	SF2->F2_DOC		})
			aAdd(aCab,{"F1_SERIE",      	SF2->F2_SERIE	})
			aAdd(aCab,{"F1_EMISSAO",     	SF2->F2_EMISSAO	})
			aAdd(aCab,{"F1_FORNECE",     	cFornece		})
			aAdd(aCab,{"F1_LOJA",        	cLoja  			})
			aAdd(aCab,{"F1_ESPECIE",     	"NFE"			})
			aAdd(aCab,{"F1_COND",			"001"			})
			
			
			//Localizar item da NF
			//Indice 3 -D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			SD2->(DbSetOrder(3))
			If !SD2->(DbSeek(cLoja+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
				Alert("Nota fiscal " + F2_DOC + " não tem item ")
				Return
			EndIf
			
			While !SD2->(Eof()) .And. (SD2->D2_FILIAL	== cLoja;
				.And. SD2->D2_DOC		== SF2->F2_DOC;
				.And. SD2->D2_SERIE	== SF2->F2_SERIE;
				.And. SD2->D2_CLIENTE	== SF2->F2_CLIENTE;
				.And. SD2->D2_LOJA		== SF2->F2_LOJA)
				
				aAdd(aLinha,{"D1_COD", 		SD2->D2_COD, 	Nil	})
				aAdd(aLinha,{"D1_UM", 		SD2->D2_UM, 	Nil	})
				aAdd(aLinha,{"D1_QUANT",	SD2->D2_QUANT, 	Nil	})
				aAdd(aLinha,{"D1_VUNIT",	SD2->D2_PRCVEN,	Nil	})
				aAdd(aLinha,{"D1_TOTAL",	SD2->D2_TOTAL, 	Nil	})
				aAdd(aLinha,{"D1_TOTAL",	SD2->D2_QUANT*SD2->D2_PRCVEN, 	Nil	})
				aAdd(aLinha,{"D1_LOCAL",	SD2->D2_LOCAL, 	Nil	})
//				aAdd(aLinha,{"D1_ITEM",		SD2->D2_ITEM, 	Nil	})
				aAdd(aLinha,{"D1_ITEM",	strzero(len(aItens)+1,4), 	Nil	})
				aAdd(aLinha,{"D1_PESO",		SD2->D2_PESO, 	Nil	})
				aAdd(aLinha,{"D1_TP",		SD2->D2_TP, 	Nil	})
				
				SD2->( DbSkip() )
				aAdd( aItens, aLinha )
				aLinha := {}
			EndDo
			
			MsAguarde({|| MATA140(aCab,aItens)},"Aguarde...","Gerando pre-nota",.T.)
			
			If lMsErroAuto
				MostraErro()
				Return
			Else
				MsgInfo("Processamento efetuado com sucesso!" + char(13) + "Classifique a Pré-Nota:" + cNF)
				_cLoc	:= Space(2)
				_cNF	:= Space(9)
				_cSR	:= Space(3)
				_cCli	:= Space(6)
				_cLoj	:= Space(2)
			EndIf
		Else
			MsgInfo("Esta NF possui romaneio, " +char(13) + "efetue o recebimento através do romaneio: " + PA6->PA6_NUMROM)
		Endif
	Else
		Alert("Nota fiscal " + _CNF + " não encontrada na filial " + cLoja )
	Endif
Else
	MsgInfo("A entrada deve ser efetuada na filial: " + _cLoc)
	_cLoc	:= Space(2)
	_cNF	:= Space(9)
	_cSR	:= Space(3)
	_cCli	:= Space(6)
	_cLoj	:= Space(2)
Endif

Return 
