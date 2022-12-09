#INCLUDE "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACTITPAI º Autor ³ Adilson Silva      º Data ³ 09/02/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Acerta o Conteudo dos Campos E2_TITPAI, E2_DIRF e E2_DTDIRFº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ACTITPAI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cPerg    := ""
Private cString  := "SE2"
Private oGeraTxt

dbSelectArea( "SE2" )
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE MSDIALOG oDlg TITLE "Acerto E2_TITPAI no Financeiro" FROM 0,0 TO 220,450 OF oDlg PIXEL
@ 15, 15 SAY "Este programa ira ajustar o conteudo dos campos E2_TITPAI" SIZE 45,8 PIXEL OF oDlg
@ 25, 15 SAY "E2_DIRF e E2_DTDIRF" SIZE 45,8 PIXEL OF oDlg
	
DEFINE SBUTTON FROM 070,190 TYPE 01 ENABLE OF oDlg ACTION {|| nOpca := 1, OkGeraTxt()}
DEFINE SBUTTON FROM 070,150 TYPE 02 ENABLE OF oDlg ACTION oDlg:End()
	
ACTIVATE MSDIALOG oDlg CENTER


//DEFINE MSDIALOG oGeraTxt FROM 001,400 TO 300,1000 PIXEL TITLE "Acerto E2_TITPAI no Financeiro"
//////@002,010 TO 095,230
//@002,018 Say " Este programa ira ajustar o conteudo dos campos E2_TITPAI     "
//@002,018 Say " E2_DIRF e E2_DTDIRF.                                          "

////@070,158 BMPBUTTON TYPE 01 ACTION 
//DEFINE SBUTTON FROM 070,158 TYPE 1 ACTION (nOpca := 1, OkGeraTxt()) ENABLE OF oDlg
////@070,188 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)    
//DEFINE SBUTTON FROM 070, 188 TYPE 2 ACTION (nOpca := 2, End()) ENABLE OF oDlg

//Activate Dialog oGeraTxt Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³OKGERATXT º Autor ³ AP5 IDE            º Data ³  28/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function OkGeraTxt

Processa({|| RunCont() },"Processando...")
Close(oGeraTxt)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  28/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunCont()

Local nTotReg := SE2->(RecCount())
Local nContad := 0
Local nRecno  := 0
Local cTitPai := ""
Local cKey    := ""

//SA2->(dbSetOrder(1))

dbSelectArea( "SE2" )
SE2->(dbSetOrder( 1 ))
SE2->(dbGoTop())
//ProcRegua( 1 )
    
While SE2->(!Eof())

//nContad++ 
//	IncProc( StrZero(nContad,8) + " -> " + StrZero(nTotReg,8) )
	
	
	If SE2->(E2_FORNECE + E2_LOJA + E2_NATUREZ) == "UNIAO 002405      " .Or. ;
		SE2->(E2_FORNECE + E2_LOJA + E2_NATUREZ) == "UNIAO 002402      " .Or. ;
		SE2->(E2_FORNECE + E2_LOJA + E2_NATUREZ) == "INPS  002407      " .Or. ;
		SE2->(E2_FORNECE + E2_LOJA + E2_NATUREZ) == "MUNIC 002406      "
		SE2->(DbSkip())
		Loop
	EndIf
	
	
//	If !(SA2->(dbSeek( SE2->("       " + E2_FORNECE + E2_LOJA) )))
//		SE2->(DbSkip())
//		Loop
//	EndIf
	
	If !(SE2->E2_EMISSAO >= ctod("01/01/2016") .and. SE2->E2_EMISSAO <= ctod("31/12/2017"))
	    SE2->(DbSkip())
		Loop
	EndIf
	
	
	nRecno  := SE2->(Recno())
	cTitPai := SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)  
    _cCodRet:= SE2->E2_CODRET
	
	If SE2->E2_IRRF > 0
		cKey := SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCIR) + "TX " + "UNIAO " + "00"
		If dbSeek( cKey )
			If(empty(SE2->E2_TITPAI))
				RecLock("SE2",.F.)
				SE2->E2_TITPAI := cTitPai   
				If(SE2->E2_CODRET=='1' .OR. EMPTY(SE2->E2_CODRET),SE2->E2_CODRET:=_cCodRet,SE2->E2_CODRET)		
				MsUnlock()
			Endif
		EndIf
		SE2->(dbGoTo( nRecno ))
	EndIf
	
	If SE2->E2_INSS > 0
		cKey := SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCINS) + "INS" + "INPS  " + "00"
		If dbSeek( cKey )
			If(empty(SE2->E2_TITPAI))
				RecLock("SE2",.F.)
				SE2->E2_TITPAI := cTitPai    
				If(SE2->E2_CODRET=='1' .OR. EMPTY(SE2->E2_CODRET),SE2->E2_CODRET:=_cCodRet,SE2->E2_CODRET)	
				MsUnlock()
			Endif
		EndIf
		SE2->(dbGoTo( nRecno ))
	EndIf
	
	If SE2->E2_ISS > 0
		cKey := SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCISS) + "ISS" + "MUNIC " + "00"
		If dbSeek( cKey )
			If(empty(SE2->E2_TITPAI))
				RecLock("SE2",.F.)
				SE2->E2_TITPAI := cTitPai  
				If(SE2->E2_CODRET=='1' .OR. EMPTY(SE2->E2_CODRET),SE2->E2_CODRET:=_cCodRet,SE2->E2_CODRET)	
				MsUnlock()
			Endif
		EndIf
		SE2->(dbGoTo( nRecno ))
	EndIf
	
	If SE2->E2_PIS > 0
		cKey := SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCPIS) + "TX " + "UNIAO " + "00"
		If dbSeek( cKey )
			If(empty(SE2->E2_TITPAI))
				RecLock("SE2",.F.)
				SE2->E2_TITPAI := cTitPai                                                         
				If(SE2->E2_CODRET=='1' .OR. EMPTY(SE2->E2_CODRET),SE2->E2_CODRET:=_cCodRet,SE2->E2_CODRET)
				MsUnlock()
			Endif
		EndIf
		SE2->(dbGoTo( nRecno ))
	EndIf
	
	If SE2->E2_COFINS > 0
		cKey := SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCCOF) + "TX " + "UNIAO " + "00"
		If dbSeek( cKey )
			If(empty(SE2->E2_TITPAI))
				RecLock("SE2",.F.)
				SE2->E2_TITPAI := cTitPai                                                         
				If(SE2->E2_CODRET=='1' .OR. EMPTY(SE2->E2_CODRET),SE2->E2_CODRET:=_cCodRet,SE2->E2_CODRET)	
				MsUnlock()
			Endif
		EndIf
		SE2->(dbGoTo( nRecno ))
	EndIf
	
	If SE2->E2_CSLL > 0
		cKey := SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCSLL) + "TX " + "UNIAO " + "00"
		If dbSeek( cKey )
			If(empty(SE2->E2_TITPAI))
				RecLock("SE2",.F.)
				SE2->E2_TITPAI := cTitPai                                                         
				If(SE2->E2_CODRET=='1' .OR. EMPTY(SE2->E2_CODRET),SE2->E2_CODRET:=_cCodRet,SE2->E2_CODRET)	
				MsUnlock()
			Endif
		EndIf
		SE2->(dbGoTo( nRecno ))
	EndIf
	//SE2->(dbGoTo( nRecno ))
	SE2->(DbSkip())
EndDo

MsgAlert("Finalizou!!!")

Return()