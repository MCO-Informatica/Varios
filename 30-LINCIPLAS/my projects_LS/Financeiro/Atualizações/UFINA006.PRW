#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FINA006  º Autor ³ Antonio Carlos     º Data ³  02/12/09   º±±                                                                            
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para ajuste dos lançamentos referente ao fechamento º±±
±±º          ³ de Lojas, digitados erroneamente na Movimentação Bancaria. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function UFINA006()

Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local oDlg
Private oProcess
Private cCadastro   := "Ajusta Movimentacao Bancaria - Lojas"

AADD(aSays,OemToAnsi("Esta rotina tem por objetivo realizar a correcao dos lancamentos"))
AADD(aSays,OemToAnsi("referente ao fechamento de Lojas processados de forma incorreta "))
AADD(aSays,OemToAnsi("na Movimentacao Bacaria do Protheus."))

AADD(aButtons, { 1,.T.,{|o| nOpc:= 1,If(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Atenção")),o:oWnd:End(),nOpc:=0) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons,,200,405 )
	
If nOpc == 1
	oProcess := MsNewProcess():New({|lEnd| Integra(@lEnd)},"Processando","Transferindo...",.T.)
	oProcess:Activate()
EndIf

Return nil

Static Function Integra()

bPesqui		:= {|| Pesqui()}
bLibera		:= {|| Libera()}
aRotina 	:= {{ "Pesquisar"	, "Eval(bPesqui)"	, 0 , 1} , { "Liberacao"	, "Eval(bLibera)"	, 0 , 3}}

aCampos := {}
Aadd(aCampos, {"OK"        , "C" ,  2, 0})
Aadd(aCampos, {"E_FILIAL"  , "C" ,  2, 0})
Aadd(aCampos, {"E_DATA"    , "D" ,  8, 0})
Aadd(aCampos, {"E_MOEDA"   , "C" ,  3, 0})
Aadd(aCampos, {"E_VALOR"   , "N" , 17, 2})
Aadd(aCampos, {"E_NATUREZ" , "C" , 10, 0})
Aadd(aCampos, {"E_BANCO"   , "C" ,  3, 0})
Aadd(aCampos, {"E_AGENCIA" , "C" ,  2, 0})
Aadd(aCampos, {"E_CONTA"   , "C" , 10, 0})
Aadd(aCampos, {"E_DOCUMEN" , "C" , 50, 0})

aCpos		:= {}
Aadd(aCpos, {"OK"	   		,,  	   		})
Aadd(aCpos, {"E_FILIAL"	 	,, "Filial"		})
Aadd(aCpos, {"E_DATA"	    ,, "Data"		})
Aadd(aCpos, {"E_MOEDA"		,, "Moeda"		})
Aadd(aCpos, {"E_VALOR"		,, "Valor"		})
Aadd(aCpos, {"E_NATUREZ"	,, "Natureza"	})
Aadd(aCpos, {"E_BANCO"      ,, "Banco" 		})
Aadd(aCpos, {"E_AGENCIA"    ,, "Agencia" 	})
Aadd(aCpos, {"E_CONTA"      ,, "Conta" 		})
Aadd(aCpos, {"E_DOCUMEN"    ,, "Documento" 	})

cTrab := CriaTrab(aCampos)
DbCreate(cTrab, aCampos)
DbUseArea( .T.,, cTrab, "TMP", .F., .F. )

IndRegua("TMP",cTrab,"E_FILIAL+DTOC(E_DATA)",,,"Ordenando por Numero")

GeraSql()

DbSelectArea("TMP")
TMP->( DbGoTop() )
MarkBrow("TMP","OK","",aCpos,,cMarca,,,,,)

Return nil

Static Function GeraSql()

cQuery1 := " SELECT E5_FILIAL, E5_DATA, E5_MOEDA, E5_VALOR, E5_NATUREZ, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_DOCUMEN "
cQuery1 += " FROM "+RetSqlName("SE5")+" SE5 (NOLOCK)"
cQuery1 += " WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND "
cQuery1 += " PAT.D_E_L_E_T_ = '' "
cQuery1 += " AND PAT_STATUS <> 'S' "
cQuery1 += " AND PAT_DTFECH BETWEEN '" +DTOS(_ddadata)+"' AND '"+DTOS(_datedata)+"'"
cQuery1 += " GROUP BY PAT_FILIAL, PAT_DTFECH, PAT_TURNO, PAT_FORMA, PAT_BANCO, PAT_AGENCI, PAT_CONTA, PAT_NUMCFI, PAT_OPERAD, PAT_PDV, PAT_FORMA "
cQuery1 += " ORDER BY PAT_FILIAL, PAT_DTFECH, PAT_TURNO "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), "QRY", .F., .T.)

DbSelectArea("QRY")
QRY->( DbGoTop() )
If QRY->( !Eof() )
	
	While QRY->( !Eof() )
		
		DbSelectArea("SX5")
		SX5->( DbSetorder(1) )
		SX5->( DbSeek(space(02)+'ZD'+QRY->PAT_FILIAL) )
		
		If SX5->( Found() )
			_conta := Alltrim(SX5->X5_DESCRI)
		Else
			_conta := ''
		EndIf
		
		DbSelectArea("SM2")
		SM2->( DbSetorder(01) )
		SM2->( DbSeek( STOD(QRY->PAT_DTFECH) ) )
		
		If SM2->(found())
			If alltrim(_escolha) == "U$"
				_qtdmoeda := QRY->VALORDIG/SM2->M2_MOEDA2
			ElseIf alltrim(_escolha) == "E$"
				_qtdmoeda := QRY->VALORDIG/SM2->M2_MOEDA4
			Else
				_qtdmoeda := 0
			EndIf
		Else
			_qtdmoeda := 0
		EndIf
		
		DbSelectArea("TMP")
		RecLock("TMP",.T.)
		
		TMP->E_FILIAL 	:= QRY->PAT_FILIAL
		TMP->E_DATA 	:= STOD(QRY->PAT_DTFECH)
		TMP->E_MOEDA 	:= QRY->PAT_FORMA
		TMP->E_VALOR 	:= QRY->VALOR
		TMP->E_VALORDIG	:= QRY->VALORDIG
		TMP->E_NATUREZ  := "DEPOSITO"
		TMP->E_BANCO 	:= QRY->PAT_BANCO
		TMP->E_AGENCIA  := QRY->PAT_AGENCI
		TMP->E_CONTA 	:= QRY->PAT_CONTA
		TMP->DIFF       := QRY->VALORDIG-QRY->VALOR
		
		TMP->E_DOCUMEN	:= QRY->PAT_FILIAL+QRY->PAT_DTFECH+QRY->PAT_TURNO
		TMP->E_VENCTO   := STOD(QRY->PAT_DTFECH)
		TMP->E_RECPAG  	:= "R"
		TMP->E_BENEF 	:= Alltrim(GetAdvFVal("SM0","M0_NOME",cEmpAnt + QRY->PAT_FILIAL,1))+" - "+Alltrim(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + QRY->PAT_FILIAL,1))
		
		Do Case
			Case alltrim(_escolha) == 'R$'
				TMP->E_HISTOR 	:= "MOVTO EM REAIS - "+DTOC(STOD(QRY->PAT_DTFECH))+" PERIODO: "+QRY->PAT_TURNO
			Case alltrim(_escolha) == 'U$'
				TMP->E_HISTOR 	:= "MOVTO EM REAIS (DOLARES) - "+DTOC(STOD(QRY->PAT_DTFECH))+" PERIODO: "+QRY->PAT_TURNO
			Case alltrim(_escolha) == 'E$'
				TMP->E_HISTOR 	:= "MOVTO EM REAIS (EURO) - "+DTOC(STOD(QRY->PAT_DTFECH))+" PERIODO: "+QRY->PAT_TURNO
			Case alltrim(_escolha) == 'CH'
				TMP->E_HISTOR 	:= "MOVTO EM REAIS (CHEQUE) - "+DTOC(STOD(QRY->PAT_DTFECH))+" PERIODO: "+QRY->PAT_TURNO
			Case alltrim(_escolha) == 'FI'
				TMP->E_HISTOR 	:= "MOVTO EM REAIS (CHEQUE PRE) - "+DTOC(STOD(QRY->PAT_DTFECH))+" PERIODO: "+QRY->PAT_TURNO
		EndCase
		
		TMP->E_DTDIGIT	:= STOD(QRY->PAT_DTFECH)
		TMP->E_DTDISPO	:= STOD(QRY->PAT_DTFECH)
		TMP->E_FILORIG  := QRY->PAT_FILIAL
		TMP->E_MODSPB   := "4"
		TMP->E_DEBITO   := _conta
		TMP->E_SERREC   := QRY->PAT_NUMCFI
		TMP->E_TURNO    := QRY->PAT_TURNO
		TMP->E_OPERAD   := QRY->PAT_OPERAD
		TMP->E_PDV		:= QRY->PAT_PDV
		TMP->E_NUMCFI   := QRY->PAT_NUMCFI
		TMP->PAT_FORMA  := QRY->PAT_FORMA
		TMP->QTD_MOEDA  := _qtdmoeda
		
		TMP->( MsUnLock() )

		QRY->( DbSkip() )
		
	EndDo

EndIf

Return nil

Static Function Pesqui()

Private cRom	:= Space(8)
Private oDlgPsq

DEFINE MSDIALOG oDlgPsq TITLE "Pesquisa" FROM 129,047 TO 250,280 PIXEL

@ 08,20 SAY OemToAnsi("Filial")	PIXEL OF oDlgPsq
@ 06,50 MSGET oRom VAR cRom PICTURE "@!"	PIXEL OF oDlgPsq
@ 30,20 BUTTON "Ok"  		SIZE 31,10 ACTION PsqRom()			PIXEL OF oDlgPsq
@ 30,70 BUTTON "Cancela"	SIZE 30,10 ACTION oDlgPsq:End()		PIXEL OF oDlgPsq

ACTIVATE MSDIALOG oDlgPsq CENTERED

Return nil

Static Function PsqRom()

DbSelectArea("TMP")
IndRegua("TMP",cTrab,"E_FILIAL",,,"Ordenando por Numeros")
If !DbSeek(cRom,.F.)
	MsgStop("Nao encontrado!")
EndIf
MarkBRefresh()
oDlgPsq:End()

Return Nil

Static Function Libera()

Local aArea		:= GetArea()
Local aaArea	:= SE5->(GetArea())

Private cPerg := Padr("FATA03",len(SX1->X1_GRUPO)," ")

//Posiciona o ponteiro no primeiro registro selecionado para pegar os dados do banco.

DbSelectArea("TMP")
TMP->( DbGoTop() )
While TMP->( !Eof() )
	If !Marked("OK")
		DbSelectArea("TMP")
		TMP->( DbSkip() )
		Loop
	Else
		exit
	EndIf
EndDo

//Executo o seek antes de criar as perguntas para pegar os dados do banco escolhido no momento do fechamento de caixa.
DbSelectArea("PAT")
PAT->( DbSetOrder(1) )
PAT->( DBSEEK( TMP->E_FILIAL+ dtos(TMP->E_DATA)+ TMP->E_OPERAD+  TMP->E_PDV+ TMP->E_TURNO+ TMP->E_NUMCFI+ TMP->E_MOEDA ) )
_pergunt(PAT->PAT_BANCO,PAT->PAT_AGENCI,PAT->PAT_CONTA)

If !Pergunte(cPerg,.T.)
	Return
EndIf

DbSelectArea("TMP")
TMP->( DbGoTop() )
While TMP->( !Eof() )
	
	If !TMP->( Marked("OK") )
		DbSelectArea("TMP")
		TMP->( DbSkip() )
		Loop
	EndIf
	
	MsAguarde({|lEnd| },"Aguarde...","Liberando Movimento: "+Alltrim(TMP->E_FILIAL+dtoc(TMP->E_DATA)+TMP->E_TURNO),.T.)
		
	Begin Transaction
	
	DbSelectArea("SE5")
	SE5->( DbOrderNickName("DOCUMEN") )
	
	lGrava := .T.   // !SE5->(DbSeek(TMP->E_FILIAL+TMP->E_DATA+TMP->E_TURNO))
	
	RecLock("SE5",lGrava)
	
	cFil				:= TMP->E_FILIAL
	SE5->E5_FILIAL 	    := TMP->E_FILIAL
	SE5->E5_DATA 		:= MV_PAR01  // STOD(TMPPAT->PAT_DTFECH)   
	
	If Alltrim(_escolha) $ ('R$','CH')
		SE5->E5_MOEDA	:= 'R$'
	Else
		SE5->E5_MOEDA	:= TMP->E_MOEDA
	EndIf
	
	SE5->E5_VALOR 		:= TMP->E_VALOR
	
	Do Case
		Case Alltrim(_escolha) == 'R$'
			SE5->E5_NATUREZ	:= "DEPOSITO"
		Case alltrim(_escolha) == 'CH'
			SE5->E5_NATUREZ	:= "DEPOSITO" // alterado em 16/03/09 conforme solicitacao do sr marcelo oliveira
	EndCase
	
	SE5->E5_BANCO 		:= MV_PAR02
	SE5->E5_AGENCIA 	:= MV_PAR03
	SE5->E5_CONTA 		:= MV_PAR04
	
	SE5->E5_DOCUMEN		:= TMP->E_FILIAL + DTOS(TMP->E_DATA) + TMP->E_TURNO
	SE5->E5_VENCTO      := TMP->E_DATA
	SE5->E5_RECPAG   	:= "R"
	SE5->E5_BENEF 		:= TMP->E_BENEF
	SE5->E5_HISTOR   	:= TMP->E_HISTOR
	SE5->E5_DTDIGIT		:= MV_PAR01  //TMP->E_DATA
	SE5->E5_DTDISPO		:= MV_PAR01  //TMP->E_DATA
	SE5->E5_FILORIG	    := TMP->E_FILIAL
	SE5->E5_MODSPB	    := "4"
	SE5->E5_DEBITO      := TMP->E_DEBITO
	SE5->E5_SERREC      := TMP->E_SERREC
	
	If _escolha == 'CH'
		SE5->E5_NUMCHE :=  TMP->E_FILIAL + subst(str(year(TMP->E_DATA)),15,5) + subst(strzero(month(TMP->E_DATA)),29,2) +subst(strzero(day(TMP->E_DATA)),29,2)
	EndIf
	
	SE5->( MsUnlock() )
	
	If TMP->DIFF <> 0   // If  TMP->VALORDIG - TMP->VALOR  <> 0
		
		RecLock("SE5",.T.)
		
		SE5->E5_FILIAL 	    := TMP->E_FILIAL
		SE5->E5_DATA 		:= MV_PAR01  // TMP->E_DATA
		SE5->E5_MOEDA 		:= TMP->E_MOEDA
		SE5->E5_NATUREZ 	:= "DEPOSITO"
		//					SE5->E5_BANCO 		:= TMP->E_BANCO
		//	 				SE5->E5_AGENCIA 	:= TMP->E_AGENCI
		//					SE5->E5_CONTA 		:= TMP->E_CONTA
		
 		SE5->E5_DOCUMEN		:= TMP->E_FILIAL + DTOS(TMP->E_DATA) + TMP->E_TURNO
		SE5->E5_VENCTO      := TMP->E_DATA
				
		If TMP->DIFF < 0  // TMP->VALORDIG-TMP->VALOR < 0
		
			_cBanco := "111"'
			_cAgenc	:= "1112"
			
			If TMP->E_FILIAL $ GetMv("MV_FILIA01")			
				_cConta := "'28993" 
			ElseIf TMP->E_FILIAL $ GetMv("MV_FILIAG0")					
		    	_cConta := "28995"  
			ElseIf TMP->E_FILIAL $ GetMv("MV_FILIAC0")					
				_cConta := "28994"
			ElseIf TMP->E_FILIAL $ GetMv("MV_FILIAA0")					
				_cConta := "28997" 
			ElseIf TMP->E_FILIAL $ GetMv("MV_FILIABH")					
				_cConta := "28999"
			ElseIf TMP->E_FILIAL $ GetMv("MV_FILIAR0")					
				_cConta := "28996"  
			ElseIf TMP->E_FILIAL $ GetMv("MV_FILIAT0")					
				_cConta := "28998"  
			EndIf
				
			SE5->E5_BANCO 		:= _cBanco
			SE5->E5_AGENCIA 	:= _cAgenc
			SE5->E5_CONTA 		:= _cConta
			SE5->E5_VALOR 		:= TMP->DIFF * -1 
			SE5->E5_RECPAG   	:= "R"
			SE5->E5_BENEF 		:= TMP->E_BENEF
			SE5->E5_HISTOR := "FALTA EM REAIS (Q.C.) - "+DTOC(SE5->E5_DATA)+" PER.: "+TMP->E_TURNO                             
			SE5->E5_DEBITO := '43011009'
			
		Else
			SE5->E5_VALOR 		:= TMP->DIFF  
			SE5->E5_RECPAG   	:= "R"
			SE5->E5_BENEF 		:= TMP->E_BENEF
			SE5->E5_HISTOR := "SOBRA EM REAIS - "+DTOC(SE5->E5_DATA)+" PERIODO: "+TMP->E_TURNO
			SE5->E5_DEBITO := '55511004'
		EndIf
		
		SE5->E5_DTDIGIT		:= MV_PAR01  //TMP->PAT_DATA
		SE5->E5_DTDISPO		:= MV_PAR01  //TMP->PAT_DATA
		SE5->E5_FILORIG	    := TMP->E_FILIAL
		SE5->E5_MODSPB	    := "4"
		SE5->E5_SERREC      := TMP->E_SERREC
		
		If _escolha == 'CH'
			SE5->E5_NUMCHE :=  TMP->E_FILIAL + subst(str(year(TMP->E_DATA)),15,5) + subst(strzero(month(TMP->E_DATA)),29,2) +subst(strzero(day(TMP->E_DATA)),29,2)
		EndIf
		
		SE5->( MsUnlock() )
		
	EndIf
	
	DbSelectArea("PAT")
	PAT->( DbSetOrder(1) )
		
	If PAT->( DbSeek(TMP->E_FILIAL+ dtos(TMP->E_DATA)+ TMP->E_OPERAD+  TMP->E_PDV+ TMP->E_TURNO+ TMP->E_NUMCFI+ TMP->E_MOEDA ) )
		
		If Empty(PAT->PAT_STATUS)
			RecLock("PAT",.F.)
			PAT->PAT_STATUS	:= "S"
			PAT->( MsUnLock() )
		EndIf
		
	EndIf
	
	DbSelectArea("TMP")
	DbGoTo( TMP->( Recno() ) )
	TMP->( DbDelete() )
	MarkBRefresh()
	
	DbSelectArea("TMP")
	IndRegua("TMP",cTrab,"E_FILIAL",,,"Ordenando por Numeros")
	TMP->( DbSeek(cFil,.F.) )
	MarkBRefresh()

	End Transaction
	
	TMP->( DbSkip() )
	
EndDo

RestArea(aArea)

Return Nil

Static function _pergunt(_RFBCO,_RFAG,_RFCONT)

_Ordem := 1
_param := '1'
//MV_PAR02 := TMP->

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))

If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
EndIf

SX1->X1_PERGUNT := "Data para baixa    ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "D"
SX1->X1_TAMANHO := 8
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))

If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
EndIf

SX1->X1_PERGUNT := "Banco Portador     ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 3
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "SEE"
SX1->X1_CNT01   := _RFBCO
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))

If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
EndIf 

SX1->X1_PERGUNT := "Agencia            ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 5
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "SEE"
SX1->X1_CNT01   := _RFAG
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))

If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
EndIf

SX1->X1_PERGUNT := "Conta Corrente   ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 10
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "SEE"
SX1->X1_CNT01   := _RFCONT
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)

Return Nil

Static Function VALIDPERG()

PutSX1(cPergData,"01","Da Data"			,"Data"			    ,"Data" 			,"mv_ch1","D",08,0,0,"G","",""	 ,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPergData,"02","Ate aData"       ,"Data"     	    ,"Data"    	    	,"mv_ch2","D",08,0,0,"G","",""	 ,"",,"mv_par02","","","","","","","","","","","","","","","","")

Return()