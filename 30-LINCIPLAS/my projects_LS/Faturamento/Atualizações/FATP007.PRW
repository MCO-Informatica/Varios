#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
+==================+======================+=================+
|Programa: FATP007 |Autor: Antonio Carlos |Data: 10/07/08   |
+==================+======================+=================+
|Descricao: Rotina responsavel pela liberação dos romaneios |
|com separacao divergente.                                  |
+===========================================================+
*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FATP007()
///////////////////////

Local aArea 		:= GetArea()
Local aRetUsu		:= {}
Private cCTGrpUser	:= ""

cMarca		:= GetMark()
aCampos		:= {}
aCpos		:= {}
cCadastro	:= "Liberacao de Romaneios"

bPesqui		:= {|| Pesqui()}
bVisual		:= {|| Visual()}
bLibera		:= {|| Libera()}

aRotina 	:= {{ "Pesquisar"	, "Eval(bPesqui)"	, 0 , 1},;
{ "Visualiza"	, "Eval(bVisual)"	, 0 , 4},;
{ "Liberacao"	, "Eval(bLibera)"	, 0 , 3}}

PswOrder(2)
If PSWSEEK(cUserName,.T.)
	PswOrder(3)
	aRetUsu := PswRet()
	For nX := 1 to Len(aRetUsu[1][10])
		cCTGrpUser += "/" + CTGrpUser(aRetUsu[1][10][nX]) + "/"
	Next nX
EndIf
If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf

aCampos := {}
Aadd(aCampos, {"OK"     	, "C",  2, 0, })
Aadd(aCampos, {"NUMROM"		, "C",  8, 0, })
Aadd(aCampos, {"LOJA"		, "C",  50, 0, })
Aadd(aCampos, {"EMISSAO"	, "C",  8, 0, })
Aadd(aCampos, {"FILORI"		, "C",  2, 0, })
Aadd(aCampos, {"FILDES"		, "C",  2, 0, })
Aadd(aCampos, {"DESCST"		, "C",  25, 0, })
Aadd(aCampos, {"USER1"		, "C",  15, 0, })

Aadd(aCpos, {"OK"		,,  			})
Aadd(aCpos, {"NUMROM"	,, "Romaneio"	})
Aadd(aCpos, {"LOJA"		,, "Loja"		})
Aadd(aCpos, {"EMISSAO"	,, "Emissao"	})

cTrab := CriaTrab(aCampos)
DBCreate(cTrab, aCampos)
DBUseArea( .T.,, cTrab, "TMP", .F., .F. )

IndRegua("TMP",cTrab,"NUMROM",,,"Ordenando por Numero")

If !GeraSql()
	Return()
EndIf

DbSelectArea("TMP")
DbGoTop()
//MarkBrow("TMP","OK","",aCpos,,cMarca,,,,,'Eval(bSelecIt)' )
MarkBrow("TMP","OK","",aCpos,,cMarca,,,,,)

RestArea(aArea)

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraSql()
/////////////////////////

Private cPerg	:= Padr("FATP07",len(SX1->X1_GRUPO)," ")
If !Pergunte(cPerg,.T.)
	Return(.f.)
Endif

cQuery := " SELECT * "
cQuery += " FROM "	+RetSqlName("PA6")+" PA6 (NOLOCK)"
cQuery += " WHERE "
cQuery += " SUBSTRING(PA6_NUMROM,7,2) = '" + Substr(cNumEmp,3,2) + "' AND "
cQuery += " PA6_DTROM BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' AND "
If cFilial $ "01/55"
	cQuery += " PA6_STATUS = '03' AND "
Else
	cQuery += " PA6_STATUS IN ('01','03') AND "
EndIf
cQuery += " PA6.D_E_L_E_T_ = '' "
cQuery += " ORDER BY PA6_DTROM "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.)

DbSelectArea("TMP")

DbSelectArea("QRY")
DbGoTop()
If !Eof()
	While !Eof()
		RecLock("TMP",.T.)
		Replace TMP->NUMROM		With QRY->PA6_NUMROM
		Replace TMP->LOJA		With QRY->PA6_LOJA
		Replace TMP->EMISSAO	With Substr(QRY->PA6_DTROM,7,2)+"/"+Substr(QRY->PA6_DTROM,5,2)+"/"+Substr(QRY->PA6_DTROM,3,2)
		Replace TMP->FILORI		With QRY->PA6_FILORI
		Replace TMP->FILDES		With QRY->PA6_FILDES
		Replace TMP->DESCST		With QRY->PA6_DESCST
		Replace TMP->USER1		With QRY->PA6_USER
		MsUnLock()
		DbSelectArea("QRY")
		DbSkip()
	EndDo
	_lRet := .t.
Else
	DbCloseArea()
	TMP->(DbCloseArea())
	MsgAlert('Não existem romaneios aguardando liberação!!!','ATENÇÃO!!!')
	_lRet := .f.
EndIf

Return(_lRet)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function SelItens()
///////////////////////////

Local aArea	:= GetArea()

nQuant := 0

If IsMark( "OK", cMarca )
	RecLock("TMP", .F. )
	Replace OK		With Space(2)
	MsUnLock()
Else
	RecLock("TMP", .F. )
	Replace OK		With cMarca
	MsUnLock()
EndIf

RestArea(aArea)

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Pesqui()
////////////////////////

Private cRom	:= Space(8)
Private oDlgPsq

DEFINE MSDIALOG oDlgPsq TITLE "Pesquisa" FROM 129,047 TO 250,280 PIXEL

@ 08,20 SAY OemToAnsi("Romaneio")	PIXEL OF oDlgPsq
@ 06,50 MSGET oRom VAR cRom PICTURE "@!"	PIXEL OF oDlgPsq
@ 30,20 BUTTON "Ok"  		SIZE 31,10 ACTION PsqRom()			PIXEL OF oDlgPsq
@ 30,70 BUTTON "Cancela"	SIZE 30,10 ACTION oDlgPsq:End()		PIXEL OF oDlgPsq

ACTIVATE MSDIALOG oDlgPsq CENTERED

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function PsqRom()
////////////////////////

DbSelectArea("TMP")
IndRegua("TMP",cTrab,"NUMROM",,,"Ordenando por Romaneios")
If !DbSeek(cRom,.F.)
	MsgStop("Romaneio nao encontrado!")
EndIf
MarkBRefresh()
oDlgPsq:End()

Return(Nil)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Libera()
////////////////////////

Local aArea := GetArea()

DbSelectArea("TMP")
DbGoTop()
While !Eof()
	
	If !Marked("OK")
		DbSelectArea("TMP")
		DbSkip()
		Loop
	EndIf
	
	MsAguarde({|lEnd| },"Aguarde...","Liberando romaneio nro. "+Alltrim(TMP->NUMROM),.T.)
	LibRom(TMP->NUMROM)
	
	RecLock("TMP", .F. )
	Replace OK		With Space(2)
	MsUnLock()
	
	DbSelectArea("TMP")
	DbSkip()
EndDo

RestArea(aArea)

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LibRom(cNumRom)
///////////////////////////////

Local aArea			:= GetArea()
Local nCont			:= 0
Local nQtde			:= 0
Local nPrcTot		:= 0
Local nRegDiv		:= 0
Local cUpdPA6		:= " "
Local cUpdPA7		:= " "
Local _lInclui		:= .F.
Local _aIteDiv 		:= {}
Private _aCabPv		:= {}
Private _aItemTemp 	:= {}
Private _aItemPv	:= {}

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+Substr(cNumRom,1,6)))

_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
{"C5_NUM"		,   SC5->C5_NUM					,Nil},;
{"C5_TIPO"		,   SC5->C5_TIPO	  			,Nil},;
{"C5_CLIENTE"	,	SC5->C5_CLIENTE				,Nil},;
{"C5_LOJACLI"	,	SC5->C5_LOJACLI				,Nil},;
{"C5_TIPOCLI"	,	SC5->C5_TIPOCLI				,Nil},;
{"C5_TRANSP"	,	SC5->C5_TRANSP	  			,Nil},;
{"C5_TPFRETE"	,	SC5->C5_TPFRETE				,Nil},;
{"C5_MOEDA"		,	SC5->C5_MOEDA				,Nil},;
{"C5_CONDPAG"	,	SC5->C5_CONDPAG				,Nil},;
{"C5_EMISSAO"	,	SC5->C5_EMISSAO	 	  	 	,Nil},;
{"C5_VEND1"		,	SC5->C5_VEND1				,Nil}}

DbSelectArea("PA6")
PA6->(DbSetOrder(1))
PA6->(DbSeek(xFilial("PA6")+cNumRom))

DbSelectArea("PA7")
PA7->(DbSetOrder(2))
PA7->(DbSeek(xFilial("PA7")+cNumRom))

&& Incluído por Rodrigo daqui

DbSelectArea("PA8")
DbSetOrder(1) // PA8_FILIAL+PA8_NUMROM+PA8_CODCOL
&& Até aqui

Do While PA7->(!Eof()) .And. PA7->PA7_NUMROM == cNumRom
	
			If SC5->C5_CLIENTE < '000009'
				DbSelectArea("SC6")
				SC6->(DbSetOrder(1))
				SC6->(DbSeek(xFilial("SC6")+Substr(cNumRom,1,6)+PA7->PA7_ITEM+PA7->PA7_CODPRO))
				Do While SC6->( !Eof() ) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == Substr(cNumRom,1,6) .and. SC6->C6_ITEM==PA7->PA7_ITEM .and. SC6->C6_PRODUTO==PA7->PA7_CODPRO 
					_cQuery := "UPDATE " + RetSqlName('SB2')
					_cQuery += _cEnter + " SET B2_XRESERV = B2_XRESERV  - "+CVALTOCHAR(SC6->C6_QTDVEN)
					
					_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
					
					_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
					_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ 			= ''"
					_cQuery += _cEnter + " AND F4_CODIGO 				= '"+SC6->C6_TES+"'"
					_cQuery += _cEnter + " AND F4_ESTOQUE 				= 'S'"
					
					_cQuery += _cEnter + " WHERE SC6.D_E_L_E_T_ 		= ''"
					_cQuery += _cEnter + " AND C6_FILIAL 				= '"+SC6->C6_FILIAL+"'"
					_cQuery += _cEnter + " AND C6_NUM 					= '"+SC6->C6_NUM+"'"
					_cQuery += _cEnter + " AND C6_CLI 					< '000009'"
					_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ 		= ''"
					_cQuery += _cEnter + " AND B2_FILIAL 				= '"+SC6->C6_LOJA+"'"
					_cQuery += _cEnter + " AND B2_COD 					='"+SC6->C6_PRODUTO+"'"
					_cQuery += _cEnter + " AND B2_LOCAL 				='"+SC6->C6_LOCAL+"'"
					nValSQL := TcSqlExec(_cQuery)
					
					if nValSQL < 0
						alert("Erro na execução do SQL -Delete Reserva filial")
						alert(_cquery)
						
					endif
					SC6->( DbSkip() )
					
				EndDo
				
			ENDIF

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	If !SC6->(DbSeek(xFilial("SC6")+Substr(cNumRom,1,6)+PA7->PA7_ITEM+PA7->PA7_CODPRO))
		
		Aadd(_aIteDiv,{cNumRom,PA7->PA7_ITEM,PA7->PA7_CODPRO})
		nRegDiv++
		PA7->(DbSkip())
		
	Else
		
		If Substr(cNumEmp,3,2) $ "01/55" .And. PA7->PA7_QUANT == 0 .And. PA6->PA6_STATUS == "03"
			
			RecLock("SC6",.F.)
			SC6->(DbDelete())
			MsUnLock()
			
			DbSelectArea("SC9")
			SC9->(DbSetOrder(1))
			If SC9->(DbSeek(xFilial("SC9")+Substr(cNumRom,1,6)+PA7->PA7_ITEM))
				RecLock("SC9",.F.)
				SC9->(DbDelete())
				MsUnLock()
			EndIf
			
			Aadd(_aIteDiv,{cNumRom,PA7->PA7_ITEM,PA7->PA7_CODPRO})
			nRegDiv++
			
		Else
			
			If Substr(cNumEmp,3,2) $ "01/55" .And. PA6->PA6_STATUS == "01"
				nQtde	:= PA7->PA7_QTDORI
				//nPrcTot	:= Round(SC6->C6_PRCVEN*nQtde,2)
				nPrcTot	:= SC6->C6_PRCVEN*nQtde
				_lInclui := .T.
			ElseIf Substr(cNumEmp,3,2) $ "01/55" .And. PA6->PA6_STATUS == "03"
				nQtde	:= PA7->PA7_QUANT
				nPrcTot	:= SC6->C6_PRCVEN*nQtde
				_lInclui := .T.
			ElseIf !Substr(cNumEmp,3,2) $ "01/55"
				nQtde	:= PA7->PA7_QTDORI
				nPrcTot	:= SC6->C6_PRCVEN*nQtde
				_lInclui := .T.
			EndIf
			

				
			
			
			
			If _lInclui
				
				_aItemTemp := {{"C6_NUM"	,	SC6->C6_NUM		,Nil},;
				{"C6_FILIAL"	,	xFilial("SC6")				,Nil},;
				{"C6_ITEM"		,	SC6->C6_ITEM				,Nil},;
				{"C6_PRODUTO"	,	SC6->C6_PRODUTO				,Nil},;
				{"C6_DESCRI"	,	SC6->C6_DESCRI				,Nil},;
				{"C6_UM"		,	SC6->C6_UM					,Nil},;
				{"C6_QTDVEN"	,	nQtde						,Nil},;
				{"C6_QTDEMP"	,	nQtde						,Nil},;
				{"C6_QTDLIB"	,	nQtde						,Nil},;
				{"C6_PRUNIT"	,	SC6->C6_PRUNIT				,Nil},;
				{"C6_PRCVEN"	,	SC6->C6_PRCVEN				,Nil},;
				{"C6_VALOR"		,	nPrcTot						,Nil},;
				{"C6_TES"		,	SC6->C6_TES					,Nil},;
				{"C6_CF"		,	SC6->C6_CF					,Nil},;
				{"C6_LOCAL"		,	SC6->C6_LOCAL				,Nil},;
				{"C6_CLI"		,	SC6->C6_CLI		 			,Nil},;
				{"C6_ENTREG"	,	SC6->C6_ENTREG				,Nil},;
				{"C6_LOJA"		,	SC6->C6_LOJA				,Nil}}
				
				aAdd(_aItemPv,aClone(_aItemTemp))
				
				nCont++
				_lInclui := .F.
				
			EndIf
			
			If Substr(cNumEmp,3,2) $ "01/55"
				DbSelectArea("SC6")
				SC6->( DbSetOrder(1) )
				SC6->( DbSeek(xFilial("SC6")+Substr(PA7->PA7_NUMROM,1,6)+PA7->PA7_ITEM+PA7->PA7_CODPROD) )
				RecLock("SC6",.F.)
				SC6->C6_QTDVEN :=	nQtde
				SC6->C6_QTDEMP :=	nQtde
				SC6->C6_QTDLIB :=	nQtde
				SC6->C6_VALOR  :=	nPrcTot
				MsUnLock()
			EndIf
			
		EndIf
		
		PA7->(DbSkip())
		
	EndIf
	
EndDo

If nCont > 0
	
	LibPedid(Substr(cNumRom,1,6))
	
	cUpdPA7	+= " UPDATE " + RetSQLName("PA7")
	cUpdPA7	+= " SET PA7_STATUS = '02', " + iif(Posicione('PA6',1,xFilial('PA6') + cNumRom,'PA6_STATUS') == '01',"PA7_QUANT = PA7_QTDORI", "PA7_QTDORI = PA7_QUANT")
	cUpdPA7 += " WHERE "
	cUpdPA7	+= " PA7_NUMROM = '"+cNumRom+"' AND "
	cUpdPA7	+= " D_E_L_E_T_ = '' "
	
	TcSQLExec(cUpdPA7)
	
	cUpdPA6	+= " UPDATE " + RetSQLName("PA6")
	cUpdPA6	+= " SET PA6_STATUS = '02', PA6_CARGA = '', PA6_NFE = '', PA6_NFS = '', PA6_SERIE = '',"
	cUpdPA6	+= " PA6_TOQUEU = '" + cUserName + "', PA6_TOQUED = '" + dtos(date()) + "', PA6_TOQUEH = '" + left(time(),2) + substr(time(),4,2) + "'"
	cUpdPA6 += " WHERE "
	cUpdPA6	+= " PA6_NUMROM = '"+cNumRom+"' AND "
	cUpdPA6	+= " D_E_L_E_T_ = '' "
	
	TcSQLExec(cUpdPA6)
	
	
	
	If nRegDiv > 0
		For _nI := 1 To Len(_aIteDiv)
			DbSelectArea("PA7")
			PA7->(DbSetOrder(2))
			If (PA7->(DbSeek(xFilial("PA7")+_aIteDiv[_nI,1]+_aIteDiv[_nI,2]+_aIteDiv[_nI,3])))
				RecLock("PA7",.F.)
				PA7->(DbDelete())
				MsUnlock()
			EndIf
		Next _nI
	EndIf
	
	DbSelectArea("TMP")
	IndRegua("TMP",cTrab,"NUMROM",,,"Ordenando por Romaneios")
	DbSeek(cNumRom,.F.)
	DbDelete()
	MarkBRefresh()
	
	
EndIf

RestArea(aArea)

&& Incluído por Rodrigo Alexandre em 12/08

DbSelectArea("PA8")
PA8->(DbSetOrder(1))

If PA8->( DbSeek(xFilial("PA8") + cNumRom + cNumRom + '001001') )
	Reclock("PA8", .F.)
Else
	Reclock("PA8", .T.)
EndIf
PA8->PA8_FILIAL := xFilial("PA8")
PA8->PA8_NUMROM := cNumRom
PA8->PA8_CODCOL	:= cNumRom + '001001'
PA8->PA8_CODST	:= "01" //Volume nao verificado
MsUnlock()

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LibPedid(cNumPed)
/////////////////////////////////

Local aArea		:= GetArea()
Local nX		:= 0
Local lLiberOk  := .T.
Local lCredito  := .T.
Local lEstoque  := .T.
Local lLiber    := .T.
Local lTransf   := .F.

DbSelectArea("SC9")
DbSetOrder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
If DbSeek(xFilial("SC9")+cNumPed,.f.)
	Do While SC9->(!Eof()) .and. SC9->C9_PEDIDO==cNumPed .and. SC9->C9_FILIAL == xFilial('SC9')
		SC9->(a460Estorna(.T.))
		SC9->(dbskip())
	EndDo
EndIf

DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+cNumPed)
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->( DbSeek( xFilial("SC6")+cNumPed ) )
	Do While SC6->( !Eof() ) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cNumPed .and. SC6->C6_FILIAL == xFilial('SC6')
		
		DbSelectArea("SC9")
		SC9->( DbSetOrder(1) )
		
		If SC9->( DbSeek( xFilial("SC9") + cNumPed + SC6->C6_ITEM + "01" + SC6->C6_PRODUTO,.F. ) )
			Reclock("SC9",.F.)
		Else
			Reclock("SC9",.T.)
		EndIf
		_nQuant := SC9->C9_QTDLIB
		
		SC9->C9_FILIAL 	:= xFilial("SC9")
		SC9->C9_PEDIDO	:= SC6->C6_NUM
		SC9->C9_ITEM	:= SC6->C6_ITEM
		SC9->C9_CLIENTE	:= SC6->C6_CLI
		SC9->C9_LOJA	:= SC6->C6_LOJA
		SC9->C9_PRODUTO	:= SC6->C6_PRODUTO
		SC9->C9_QTDLIB	:= SC6->C6_QTDVEN
		SC9->C9_DATALIB	:= dDatabase
		SC9->C9_SEQUEN	:= "01"
		SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
		SC9->C9_LOCAL	:= SC6->C6_LOCAL
		SC9->C9_TPCARGA	:= "2"
		Msunlock()
		
		DbSelectArea("SB2")
		If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO
			RecLock("SB2",.F.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tatiane de Oliveira 11/02/2016                        ³
			//³Trocou o campo b2_reserva por B2_XRESERV              ³
			//³ o valor de pedido não faturado para a filial destino ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			SB2->B2_XRESERV := SB2->B2_XRESERV - _nQuant + SC9->C9_QTDLIB // RESERVA
			
			MsUnLock()
		EndIf
		
		
		SC6->( DbSkip() )
		
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza do C5_LIBEROK e C5_STATUS                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "S"
	MsUnlock()
	
EndIf

RestArea(aArea)

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Visual()
////////////////////////

Local aButtons	:= {}

Local cFilOri		:= ""
Local cFilDes		:= ""

Private oDlg5
Private oListBox5

Private VISUAL 		:= .F.
Private INCLUI 		:= .F.
Private ALTERA 		:= .F.
Private DELETA 		:= .F.

Private aListBox5	:= {}

Private oOk5   		:= LoadBitmap( GetResources(), "BR_VERDE" 	)	//Qtd Ok
Private oCont5   	:= LoadBitmap( GetResources(), "BR_AMARELO" )	//Qtd em contagem
Private oDiv5		:= LoadBitmap( GetResources(), "BR_VERMELHO" )	//Qtd Divergente

If TMP->(EOF())
	Alert("Arquivo Vazio")
	Return
EndIf

DbSelectArea("SM0")
SM0->(DbSetOrder(1))
If SM0->( DbSeek(cEmpAnt + Trim(TMP->FILORI)) )
	cFilOri := Trim(SM0->M0_CODFIL)+" - "+Trim(SM0->M0_FILIAL)
EndIf

cFilDes := TMP->FILDES+" - "+ GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + TMP->FILDES,1)

DEFINE MSDIALOG oDlg5 TITLE "Romaneios - Visualiza" FROM 178,181 TO 665,967 PIXEL

DEFINE FONT oRsvFonte NAME "MonoAs" SIZE 0, -16 BOLD

@ 013,008 Say "Romaneio : " 									FONT oRsvFonte COLOR CLR_BLUE PIXEL OF oDlg5
@ 013,060 Say Alltrim(TMP->NUMROM)								FONT oRsvFonte COLOR CLR_BLACK PIXEL OF oDlg5

@ 028,008 Say "Data : " 										FONT oRsvFonte COLOR CLR_BLUE PIXEL OF oDlg5
@ 028,060 Say TMP->EMISSAO	 									FONT oRsvFonte COLOR CLR_BLACK PIXEL OF oDlg5

@ 043,008 Say "Filial de Origem :" 								FONT oRsvFonte COLOR CLR_BLUE PIXEL OF oDlg5
@ 043,080 Say cFilOri			 								FONT oRsvFonte COLOR CLR_BLACK PIXEL OF oDlg5

@ 058,008 Say "Filial de Destino :" 				   			FONT oRsvFonte COLOR CLR_BLUE PIXEL OF oDlg5
@ 058,080 Say cFilDes				 							FONT oRsvFonte COLOR CLR_BLACK PIXEL OF oDlg5

@ 043,250 Say "Última ação realizada por :" 		  	   		FONT oRsvFonte COLOR CLR_BLACK PIXEL OF oDlg5
@ 058,250 Say Alltrim(FWLeUserlg('USER1',1)) 		  			FONT oRsvFonte COLOR CLR_BLACK PIXEL OF oDlg5

fListBox5()

ACTIVATE MSDIALOG oDlg5 CENTERED  ON INIT EnchoiceBar(oDlg5, {||oDlg5:End()},{||oDlg5:End()},,aButtons)

Return(.T.)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListBox5()
///////////////////////////

Local nDiffSaida := 0
Local nDiffEntrada := 0

PA7->( DbSetOrder(1) )
PA7->( DbSeek( xFilial("PA7")+TMP->NUMROM ) )

While !PA7->( EOF() ) .AND. PA7->PA7_NUMROM == TMP->NUMROM
	
	nDiffSaida   := PA7->PA7_QTDORIG - PA7->PA7_QUANT
	nDiffEntrada := PA7->PA7_QTDORIG - PA7->PA7_QUANT
	
	
	If nDiffSaida == 0 .Or. nDiffEntrada == 0
		Aadd( aListBox5,{oOk5,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	If nDiffSaida > 0 .Or. nDiffEntrada > 0
		Aadd( aListBox5,{oDiv5,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	If nDiffSaida < 0 .Or. nDiffEntrada < 0
		Aadd( aListBox5,{oCont5,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	PA7->(DbSkip())
	
EndDo

@ 084,003 ListBox oListBox5 Fields ;
HEADER " ","Codigo","Descricao","Qtd original","Qtd Saida","Qtd Entrada", "Dif Saida","Dif Entrada"  Size 389,157 Of oDlg5 Pixel;
ColSizes 50,50,50,50,50,50,50,50

oListBox5:SetArray(aListBox5)

oListBox5:bLine	:= {|| {;
aListBox5[oListBox5:nAT,01],;
aListBox5[oListBox5:nAT,02],;
aListBox5[oListBox5:nAT,03],;
aListBox5[oListBox5:nAT,04],;
aListBox5[oListBox5:nAT,05],;
aListBox5[oListBox5:nAT,06],;
aListBox5[oListBox5:nAT,07],;
aListBox5[oListBox5:nAT,08]}}

Return Nil

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CTGrpUser(cCodGrup)
///////////////////////////////////

Local cName   := Space(15)
Local aGrupo  := {}

PswOrder(1)
IF	PswSeek(cCodGrup,.F.)
	aGrupo   := PswRet()
	cNameGrp := Upper(Alltrim(aGrupo[1,2]))
EndIF
IF cCodGrup == "******"
	cNameGrp := "Todos"
EndIF

Return(cNameGrp)
