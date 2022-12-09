#INCLUDE "PROTHEUS.CH"   
#INCLUDE "TopConn.ch"   
#INCLUDE "TbiConn.ch"                                                                                                                       
#INCLUDE "TbiCode.ch"
                                                                                                            
/*
+============================================================+
|Programa: COMP009 |Autor: Antonio Carlos |Data: 01/06/10    |
+============================================================+
|Descricao: Rotina responsavel pela aprovação de Pedidos de  |
|Compra via Protheus.                                        |
+============================================================+
|Especifico: Laselva                                         |
+============================================================+
*/

User Function COMP009()

Private oValor
Private oQtda
Private nQtd		:= 0
Private lInverte	:= .F.
Private _cUser 		:= RetCodUsr()
Private cMarca		:= GetMark()
Private aCores		:= {}
Private aButtons	:= {{"OBJETIVO"	,{||Legenda()},"Legenda" }}   
Private cCadastro	:= "Aprovacao Pedidos de Compra"
Private _cSql		:= ""

PERGUNTE("COMP09", .T.)
If MV_PAR01 == 1
	_cSql += " CR_STATUS = '02' AND "
ElseIf MV_PAR01 == 2
	_cSql += " CR_STATUS IN ('03','05') AND "		
ElseIf MV_PAR01 == 3
	_cSql += " CR_STATUS IN ('01','02','03','04','05') AND "		
Else
	_cSql += " CR_STATUS IN ('04') AND "			
EndIf	

Aadd(aCores,{ "TMP->STATUSP == '01' ", 'BR_PRETO'		}) // Digitado
Aadd(aCores,{ "TMP->STATUSP == '02' ", 'BR_VERMELHO'	}) // Processado
Aadd(aCores,{ "TMP->STATUSP == '03' ", 'BR_VERDE'		}) // Finalizado
Aadd(aCores,{ "TMP->STATUSP == '04' ", 'BR_CINZA'		}) // Finalizado

If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf

aCampos := {}
Aadd(aCampos, {"OK"			,"C", 2, 0})
Aadd(aCampos, {"FILIAL"		,"C", 2, 0})
Aadd(aCampos, {"NOME"		,"C", 15,0})
Aadd(aCampos, {"DOCUMENTO"	,"C", 10,0})
Aadd(aCampos, {"VALOR"		,"N" ,14,2})
Aadd(aCampos, {"CPAGTO"		,"C", 15,0})
Aadd(aCampos, {"FORNECEDOR"	,"C" ,50,2})
Aadd(aCampos, {"EMISSAO"	,"D" ,8 ,0})
Aadd(aCampos, {"ENTREGA"	,"D" ,8, 2})
Aadd(aCampos, {"COMPRADOR"	,"C" ,50,0})
Aadd(aCampos, {"OBS"		,"C" ,30,0})
Aadd(aCampos, {"TIPODOC"	,"C" ,2, 0})
Aadd(aCampos, {"CODUSU"		,"C" ,6, 0})
Aadd(aCampos, {"CODAPRO"	,"C" ,6, 0})
Aadd(aCampos, {"STATUSP"	,"C" ,2, 0})

aCpos		:= {}
Aadd(aCpos, {"OK"	   		,,  			})
Aadd(aCpos, {"FILIAL" 		,, "Filial"		})
Aadd(aCpos, {"NOME" 		,, "Nome"		})
Aadd(aCpos, {"DOCUMENTO" 	,, "Documento"	})
Aadd(aCpos, {"VALOR"       	,, "Valor" 		,"@E 99,999,999,999.99"})
Aadd(aCpos, {"CPAGTO"      	,, "Cond.Pagto" })
Aadd(aCpos, {"FORNECEDOR"  	,, "Fornecedor" })
Aadd(aCpos, {"EMISSAO"     	,, "Emissao"	})
Aadd(aCpos, {"ENTREGA"     	,, "Entrega" 	})
Aadd(aCpos, {"COMPRADOR"   	,, "Comprador" 	})
Aadd(aCpos, {"OBS" 	    	,, "Observacao" })
Aadd(aCpos, {"TIPODOC"	    ,, "Tipo Docto"		})
Aadd(aCpos, {"CODUSU"		,, "Cod.Usuario"	})
Aadd(aCpos, {"CODAPRO" 		,, "Cod.Aprovador"	})

cTrab := CriaTrab(aCampos)
DbCreate(cTrab, aCampos)
DbUseArea( .T.,, cTrab, "TMP", .F., .F. )

IndRegua("TMP",cTrab,"FILIAL+DOCUMENTO",,,"Ordenando por Filial")

GeraSql()

DbSelectArea("TMP")
TMP->( DbGoTop() )

DEFINE MSDIALOG oDlg TITLE cCadastro  From 10,10 To 400,600 PIXEL
oDlg:LMAXIMIZED := .T.
//@1.4,.8 SAY OemToAnsi("Valor Total:") //"Valor Total:"   
//@1.4, 7 SAY oValor VAR nValor Picture "@E 999,999,999.99"
@1.4,.8 SAY OemToAnsi("Quantidade:" )//"Quantidade:"
@1.4, 7 SAY oQtda VAR nQtd Picture "@E 99999" SIZE 50,10
oMark := MsSelect():New("TMP","OK",,aCpos,@lInverte,@cMarca,{35,1,250,600},,,,,aCores)
//oMark := MsSelect():New("TMP","OK",,aCpos,@lInverte,@cMarca,{35,1,250,600},,,,,aCores)
oMark:bMark := {| | Marca(cMarca,lInverte,oQtda)}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.

@ 270,5	 	BUTTON "Pesquisar" 	 SIZE 30,15 ACTION( Pesqui() )  OF oDlg PIXEL
@ 270,45 	BUTTON "Visualizar"	 SIZE 30,15 ACTION( Visual() )  OF oDlg PIXEL
@ 270,85 	BUTTON "Liberar"	 SIZE 30,15 ACTION( LibPed() )  OF oDlg PIXEL
@ 270,125 	BUTTON "Bloquear"	 SIZE 30,15 ACTION( BlqPed() )  OF oDlg PIXEL
	
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2,oDlg:End()},,aButtons)

Return Nil

Static Function GeraSql()

Local _cObserv	:= ""
Local _dEntre	:= CTOD("  /  /  ")	

If Select("QRY") > 0
	QRY->( DbCloseArea() )
EndIf

cQuery := " SELECT CR_FILIAL, CR_NUM, E4_DESCRI, A2_NOME, C7_USER, CR_TIPO, CR_USER, CR_APROV, CR_USERLIB, CR_TOTAL, C7_EMISSAO, CR_STATUS, SUM(C7_TOTAL) AS 'TOTAL' "
cQuery += " FROM "+RetSqlName("SCR")+" SCR 	(NOLOCK) "
cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 (NOLOCK) " 
cQuery += " ON CR_FILIAL = C7_FILIAL AND RTRIM(CR_NUM) = C7_NUM AND SC7.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 (NOLOCK) " 
cQuery += " ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN "+RetSqlName("SE4")+" SE4 (NOLOCK) "
cQuery += " ON C7_COND = E4_CODIGO AND SE4.D_E_L_E_T_ = '' "
cQuery += " WHERE "
cQuery += " CR_USER = '"+_cUser+"' AND "
//cQuery += " CR_USER = '000351' AND "
cQuery += _cSql
cQuery += " SCR.D_E_L_E_T_ = '' "

cQuery += " GROUP BY CR_FILIAL, CR_NUM, E4_DESCRI, A2_NOME, C7_USER, CR_TIPO, CR_USER, CR_APROV, CR_USERLIB, CR_TOTAL, C7_EMISSAO, CR_STATUS "
cQuery += " ORDER BY CR_FILIAL, C7_EMISSAO "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.)

DbSelectArea("TMP")

DbSelectArea("QRY")
QRY->( DbGoTop() )
If QRY->( !Eof() )
	While QRY->( !Eof() )
		
		RecLock("TMP",.T.)
		
		TMP->FILIAL		:= QRY->CR_FILIAL
		TMP->NOME		:= GetAdvFval("SM0",Alltrim("M0_FILIAL"),"01" + QRY->CR_FILIAL)
		TMP->DOCUMENTO	:= QRY->CR_NUM
		TMP->VALOR		:= QRY->CR_TOTAL
		TMP->CPAGTO		:= QRY->E4_DESCRI	
		TMP->FORNECEDOR	:= QRY->A2_NOME	
		TMP->EMISSAO	:= STOD(QRY->C7_EMISSAO)
		TMP->ENTREGA	:= Posicione("SC7",1,QRY->CR_FILIAL+Alltrim(QRY->CR_NUM),"C7_DATPRF")
		TMP->COMPRADOR	:= Alltrim(UsrFullName(QRY->C7_USER))
		TMP->OBS		:= Posicione("SC7",1,QRY->CR_FILIAL+Alltrim(QRY->CR_NUM),"C7_OBS")
		TMP->TIPODOC	:= QRY->CR_TIPO
		TMP->CODUSU		:= QRY->CR_USER
		TMP->CODAPRO	:= QRY->CR_APROV
		TMP->STATUSP	:= QRY->CR_STATUS
		
		TMP->( MsUnLock() )
		
		QRY->( DbSkip() )
		
	EndDo
	
EndIf

Return

Static Function Marca(cMarca,lInverte,oQtda)

If IsMark("OK",cMarca,lInverte)
	nQtd ++
Else
	nQtd --
	nQtd := IIf(nQtd<0,0,nQtd)
Endif

oQtda:Refresh()

Return

Static Function Legenda()

Local aLegenda := {}

AADD(aLegenda,{"BR_PRETO"	  	,"Nivel Bloqueado" 		})
AADD(aLegenda,{"BR_VERMELHO"	,"Aguardando Liberacao" })
AADD(aLegenda,{"BR_VERDE"		,"Pedido Liberado" 		})
AADD(aLegenda,{"BR_CINZA"		,"Pedido Bloqueado" 	})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil
	
Return(.T.)       

Static Function Pesqui()

Private cDoc	:= Space(8)
Private oDlgPsq

DEFINE MSDIALOG oDlgPsq TITLE "Pesquisa" FROM 129,047 TO 250,280 PIXEL

@ 08,20 SAY OemToAnsi("Filial+Documento")	PIXEL OF oDlgPsq
@ 18,20 MSGET oDoc VAR cDoc PICTURE "@!"	PIXEL OF oDlgPsq
@ 40,20 BUTTON "Ok"  		SIZE 31,10 ACTION PsqDoc()			PIXEL OF oDlgPsq
@ 40,70 BUTTON "Cancela"	SIZE 30,10 ACTION oDlgPsq:End()		PIXEL OF oDlgPsq

ACTIVATE MSDIALOG oDlgPsq CENTERED

Return nil

Static Function PsqDoc()

DbSelectArea("TMP")
IndRegua("TMP",cTrab,"FILIAL+DOCUMENTO",,,"Ordenando por Filial+Documento")
If !DbSeek(cDoc,.F.)
	MsgStop("Nao encontrado!")
EndIf
oMark:oBrowse:Refresh()
oDlgPsq:End()

Return(Nil)

Static Function Visual()

U_COMP010(TMP->FILIAL,Alltrim(TMP->DOCUMENTO))	

Return	

Static Function LibPed()

DbSelectArea("TMP")
TMP->( DbGoTop() )
While TMP->( !Eof() )
	
	If !TMP->(Marked("OK"))
		DbSelectArea("TMP")
		TMP->(DbSkip())
		Loop
	EndIf
	
	If !TMP->STATUSP $ "02/04" 
		DbSelectArea("TMP")
		TMP->(DbSkip())
		Loop
	EndIf
	
	MsAguarde({|lEnd| },"Aguarde...","Liberando Pedidos: "+TMP->FILIAL+Alltrim(TMP->DOCUMENTO),.T.)
	Aprova(TMP->FILIAL,Alltrim(TMP->DOCUMENTO),_cUser,TMP->OBS)	
    
	DbSelectArea("TMP")
	DbGoTo( TMP->( Recno() ) )
	TMP->( DbDelete() )
	
	TMP->( DbSkip() )	
	
EndDo	

DbSelectArea("TMP")
TMP->( DbGoTop() )

oMark:oBrowse:Refresh()
	
Return	

Static Function BlqPed()

Private _cObs	:= CriaVar("CR_OBS")

DbSelectArea("TMP")
TMP->( DbGoTop() )
While TMP->( !Eof() )
	
	If !TMP->(Marked("OK"))
		DbSelectArea("TMP")
		TMP->(DbSkip())
		Loop
	EndIf
	
	If TMP->STATUSP <> "02" 
		DbSelectArea("TMP")
		TMP->(DbSkip())
		Loop
	EndIf
	
	
	DEFINE MSDIALOG oDlgV TITLE "Bloqueio Pedido de Compra" FROM 000,000 TO 240,700 OF oMainWnd PIXEL  

	@ 020,010 SAY "Pedido" PIXEL
	@ 020,040 MSGET oPed VAR Alltrim(TMP->DOCUMENTO) WHEN .F. PIXEL

	@ 020,100 SAY "Comprador" PIXEL
	@ 020,140 MSGET oComp VAR Alltrim(TMP->COMPRADOR) WHEN .F. PIXEL
	
	@ 040,010 SAY "Emissao" PIXEL
	@ 040,040 MSGET oEmi VAR TMP->EMISSAO WHEN .F. PIXEL

	@ 040,100 SAY "Fornecedor" PIXEL
	@ 040,140 MSGET oForn VAR Alltrim(TMP->FORNECEDOR) WHEN .F. PIXEL
	
	@ 070,010 SAY "Observacao" PIXEL
	@ 080,010 MSGET oObs VAR _cObs  PICTURE "@!" PIXEL	
	            
	ACTIVATE MSDIALOG oDlgV CENTERED ON INIT EnchoiceBar( oDlgV, { || oDlgV:End() }, { ||  oDlgV:End() } )
	
	MsAguarde({|lEnd| },"Aguarde...","Liberando Pedidos: "+TMP->FILIAL+Alltrim(TMP->DOCUMENTO),.T.)
		
	Bloqueia(TMP->FILIAL,Alltrim(TMP->DOCUMENTO),_cUser,_cObs)	
    
	DbSelectArea("TMP")
	DbGoTo( TMP->( Recno() ) )
	TMP->( DbDelete() )
	
	TMP->( DbSkip() )	

EndDo	

DbSelectArea("TMP")
TMP->( DbGoTop() )

oMark:oBrowse:Refresh()
	
Return

Static Function Aprova(_cFilial,_cNumPed,_cUser,_cObsA)

Local _cEmail	:= ""
Local _cHtm		:= ""
Local _cObs		:= ""
Local _cRespSo	:= ""
Local _cGrupo	:= Space(6)
Local _cRespS	:= Space(6)
Local _cGrpApv	:= Space(6) 
Local _nValPed	:= 0
Local _nSaldo	:= 0
Local _nSaldoI	:= 0
Local _nVlrPed	:= 0 
Local _nContr	:= 0
Local nTotal	:= 0
Local _lAprov	:= .T.
Local _lAprova	:= .F.
Local _aAprov	:= {}

DbSelectArea("SCR")		
SCR->( DbSetOrder(2) )
If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+_cUser ) )
	
	_nValPed := SCR->CR_TOTAL
		
	Begin Transaction
	
	If SCR->CR_NIVEL == "01" .And. SCR->CR_STATUS <> "03"
		
		RecLock("SCR",.F.)
		SCR->CR_DATALIB	:= dDataBase	
		SCR->CR_STATUS	:= "03"
		SCR->CR_USERLIB := _cUser
		SCR->CR_VALLIB	:= SCR->CR_TOTAL
		SCR->CR_TIPOLIM := "D"
		SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
		SCR->( MsUnLock() )
		
		DbSelectArea("SCS")
		SCS->( DbSetOrder(1) )
		If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
			_nSaldo := SCS->CS_SALDO 
			RecLock("SCS",.F.) 
			SCS->CS_FILIAL	:= xFilial("SCS")
			SCS->CS_SALDO := _nSaldo - _nValPed	
			SCS->( MsUnLock() )
		Else 
			_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
			RecLock("SCS",.T.)
			SCS->CS_FILIAL	:= xFilial("SCS")
			SCS->CS_COD		:= _cUser
			SCS->CS_DATA	:= dDatabase
			SCS->CS_MOEDA	:= 1
			SCS->CS_SALDO	:= _nSaldoI - _nValPed	
			SCS->CS_APROV	:= _cGrpApv
			SCS->( MsUnLock() )
		EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"02" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf	
						
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			
			If Empty(SC7->C7_NUMSC)
				_cResp := SC7->C7_USER											
			Else				
				DbSelectArea("SC1")	
				SC1->( DbsetOrder(1) )
				SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
				_cResp := SC1->C1_USER
			EndIf	
			
			DbSelectArea("SY1")
			SY1->( DbSetOrder(3) )
			If SY1->( Dbseek(xFilial("SY1")+_cResp) )
	
				DbSelectarea("SAL")
				SAL->( DbSetOrder(1) )
				If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
					While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
		                If SAL->AL_NIVEL == "02"    
		                	if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM )
								Aadd(_aAProv,{SAL->AL_USER,UsrRetMail(SAL->AL_USER)}) 
							Endif
						EndIf	
						SAL->( Dbskip() )		
					EndDo
				EndIf

	 		EndIf
	 		
			For _nI := 1 To Len(_aAProv)

				//Cria o processo
				oProcess := TWFProcess():New( "PEDCOM", "Pedido de Compras" )

				//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
				oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\PEDCOMP.HTM" ) 			
				oProcess:cSubject := "Aprovacao Pedido de Compra - Num.: "+_cNumPed

				//Chama rotina de aprovacao
				oProcess:bReturn := "U_COMP005()"

				oHTML := oProcess:oHTML
	
				DbSelectArea("SE4")
				SE4->( DbSetOrder(1) )
				If SE4->( DbSeek(xFilial("SE4")+SC7->C7_COND) )
					_cCondPg := Alltrim(SE4->E4_DESCRI) 
				EndIf
				
				//Preenche os dados do cabecalho 
				//oHtml:ValByname( "EMPRESA", SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL) )
				oHtml:ValByname( "EMPRESA", Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	) )
				oHtml:ValByName( "EMISSAO", SC7->C7_EMISSAO )
				oHtml:ValByName( "FORNECEDOR", Alltrim(SC7->C7_FORNECE))

				DbSelectArea("SA2")
				SA2->( DbSetOrder(1) )
				SA2->( DbSeek(xFilial("SA2")+SC7->C7_FORNECE) )
				oHtml:ValByName( "LB_NOME", Alltrim(SA2->A2_NOME) )
				oHtml:ValByName( "LB_COND", _cCondPg )

				cComprador	:= Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,Alltrim("Y1_NOME"))
				oHtml:ValByName( "COMPRADOR", cComprador )
	
				oHtml:ValByName( "RESPUSR", _aAprov[_nI,1])			   
		
				cAprovador	:= Posicione("SAK",2,xFilial("SAK")+_aAprov[_nI,1],Alltrim("AK_NOME"))
				oHtml:ValByName( "APROVADOR", cAprovador )
				
				DbSelectArea("SC1")	
				SC1->( DbsetOrder(1) )
				If SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
					_cRespSo := UsrFullName(SC1->C1_USER)
				EndIf	
		
				oHtml:ValByName( "SOLICITANTE", Alltrim(_cRespSo) )
				oHtml:ValByName( "PRZENTREGA", SC7->C7_DATPRF )
	
				DbSelectArea("SC7")
				SC7->( DbSetOrder(1) )
				SC7->( DbSeek(Substr(_cFilial,1,2)+SC7->C7_NUM ) )
				oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
				cNum := SC7->C7_NUM
				oProcess:fDesc := "Pedido de Compras No. "+ SC7->C7_NUM
		
				While SC7->( !Eof() ) .And. C7_NUM = cNum
	
					nTotal := nTotal + C7_TOTAL
					Aadd( (oHtml:ValByName( "IT.ITEM" )),SC7->C7_ITEM )
					Aadd( (oHtml:ValByName( "IT.CODIGO" )),Alltrim(SC7->C7_PRODUTO ))
	
					DbSelectArea('SB1')
					SB1->( DbSetOrder(1) )
					SB1->( DbSeek(xFilial('SB1')+SC7->C7_PRODUTO) )
					Aadd( (oHtml:ValByName( "IT.PRODUTO" )),Alltrim(SC7->C7_DESCRI ))
					Aadd( (oHtml:ValByName( "IT.UNID" )),SB1->B1_UM )
					Aadd( (oHtml:ValByName( "IT.QUANT" )),TRANSFORM( SC7->C7_QUANT,'@E 999999999.99'   ) )
					Aadd( (oHtml:ValByName( "IT.PRECO" )),TRANSFORM( SC7->C7_PRECO,'@E 999,999,999.99' ) )
					Aadd( (oHtml:ValByName( "IT.TOTAL" )),TRANSFORM( SC7->C7_TOTAL,'@E 999,999,999.99' ) )
			
					_cObs += IIf(Empty(_cObs),"","  ")+AllTrim(SC7->C7_OBS)
					WFSalvaID('SC7','C7_WFID',oProcess:fProcessID)
					SC7->( DbSkip() )
		
				EndDo
	
				oHtml:ValByName( "LBVALOR" ,TRANSFORM( nTotal,'@E 999,999,999.99' ) )
				oHtml:ValByName( "LBFRETE" ,TRANSFORM( 0,'@E 999,999,999.99' ) )
				oHtml:ValByName( "LBTOTAL" ,TRANSFORM( nTotal,'@E 999,999,999.99') )
		
				oHtml:ValByName( "LBOBSP", AllTrim(_cObs)+" "+Alltrim(_cObsA) ) 
	
				oProcess:ClientName( cUserName )
				cMailID := oProcess:Start()
				_cEmail := _aAprov[_nI,2]
				
			Next _nI	
			
			cPath := "http://200.198.75.212/emp01/temp/" +cMailID+ ".htm"
	
			_cTo		:= Alltrim(_cEmail)
			_cSubject	:= "Aprovacao Pedido de Compra "
	
			_cHtm += "	<TABLE border=0 width=800>  "
			_cHtm += "   <tr> "
			_cHtm += "   <td width=180><img src=http:\\192.168.0.194:7914\header_logo.jpg></img></td> "
			_cHtm += "   </tr> "
			_cHtm += "	</TABLE> "

			_cHtm += "	<BR> "

			_cHtm += " 	<TABLE border=0 width= 800> "
			_cHtm += " 	   <tr> "
			_cHtm += "      <td width= 600 ><font color= #000040  size= 3 face= Verdana ><hr><b>Aprovação de Pedido de Compra</b></hr></font></td> "
			_cHtm += "	   </tr> "
			_cHtm += "	</TABLE> "
	
			_cHtm += " 	<BR> "
    	
			_cHtm += "	<b>Favor acessar o link abaixo:</b> "

			_cHtm += "	<BR> "
			_cHtm += " 	<BR> "

			_cHtm += "	<a href="+cPath+">PEDIDO</a> "
			
			cQuery := ""
			cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
			TcSQLExec(cQuery)
					    	
	ElseIf SCR->CR_NIVEL == "02" .And. SCR->CR_STATUS <> "03"
				
		RecLock("SCR",.F.)
		SCR->CR_DATALIB	:= dDataBase	
		SCR->CR_STATUS	:= "03"
		SCR->CR_USERLIB := _cUser
		SCR->CR_VALLIB	:= SCR->CR_TOTAL
		SCR->CR_TIPOLIM := "D"
		SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
		SCR->( MsUnLock() )
			
        DbSelectArea("SCS")
		SCS->( DbSetOrder(1) )
		If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
			_nSaldo := SCS->CS_SALDO 
			RecLock("SCS",.F.) 
			SCS->CS_FILIAL	:= xFilial("SCS")
			SCS->CS_SALDO := _nSaldo - _nValPed	
			SCS->( MsUnLock() )
		Else 		
			_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
			RecLock("SCS",.T.)
			SCS->CS_FILIAL	:= xFilial("SCS")
			SCS->CS_COD		:= _cUser
			SCS->CS_DATA	:= dDatabase
			SCS->CS_MOEDA	:= 1
			SCS->CS_SALDO	:= _nSaldoI - _nValPed	
			SCS->CS_APROV	:= _cGrpApv
			SCS->( MsUnLock() )
		EndIf
			
		DbSelectArea("SCR")		
		SCR->( DbSetOrder(1) )
		If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"03" ) )
	
			RecLock("SCR",.F.)
			SCR->CR_STATUS	:= "02"
			SCR->( MsUnLock() )
				
		EndIf	
						
		DbSelectArea("SC7")		
		SC7->( DbSetOrder(1) )
		SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
		_cGrupo := SC7->C7_APROV
			
		If Empty(SC7->C7_NUMSC)
			_cResp := SC7->C7_USER											
		Else				
			DbSelectArea("SC1")	
			SC1->( DbsetOrder(1) )
			SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
			_cResp := SC1->C1_USER
		EndIf	
			
		DbSelectArea("SY1")
		SY1->( DbSetOrder(3) )
		If SY1->( Dbseek(xFilial("SY1")+_cResp) )
		
			DbSelectarea("SAL")
			SAL->( DbSetOrder(1) )
			If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
				While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
				    If SAL->AL_NIVEL == "03" 
				    	if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM )
					   		Aadd(_aAProv,{SAL->AL_USER,UsrRetMail(SAL->AL_USER)}) 
					   	Endif
					EndIf	
					SAL->( Dbskip() )		
				EndDo
			EndIf

		 EndIf
		 		
		If _cGrupo $ GetMv("MV_GRPRFIN") .And. SCR->CR_TOTAL <= GetMv("MV_VLRGER")
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed ) )
	
			While SCR->( !Eof() ) .And. Substr(_cFilial,1,2) == SCR->CR_FILIAL .And. Alltrim(SCR->CR_NUM) == _cNumPed
	
				If SCR->CR_STATUS <> "03"
					
					RecLock("SCR",.F.)
					SCR->CR_DATALIB	:= dDataBase	
					SCR->CR_STATUS	:= "03"
					SCR->CR_USERLIB := _cUser
					SCR->CR_VALLIB	:= SCR->CR_TOTAL
					SCR->CR_TIPOLIM := "D"
					SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
					SCR->( MsUnLock() )
							
				EndIf	
		
				SCR->( DbSkip() )
				
			EndDo
						
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			While SC7->( !Eof() ) .And. Substr(_cFilial,1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _cNumPed
				RecLock("SC7",.F.)
				SC7->C7_CONAPRO := "L"
				SC7->( MsUnLock() )
				SC7->( DbSkip() )
			EndDo

			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			
			If !Empty(SC7->C7_NUMSC)
				
				DbSelectArea("SC1")	
				SC1->( DbsetOrder(1) )
				SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
				_cRespS := SC1->C1_USER				
			
			EndIf
			
			_cTo := Alltrim(UsrRetMail(SC7->C7_USER))+";"+IIf(!Empty(_cRespS),Alltrim(UsrRetMail(_cRespS)),"")			
						
			_cSubject	:= "Liberacao de Pedido de Compra "

			cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
			cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

			// Empresa
			_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
			_cHtm+="   <tr>"
			_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
			_cHtm+="         <font color=#ffffff size=2face=Verdana><b>UNIDADE</b></font></TD>"
			_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center>"
			_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>Pedido de Compra</b></font></TD>"
			_cHtm+="   </tr>"
			_cHtm+="   <tr>"
			_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
			_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	)+"</b></font></TD>"
			_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
			_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cNumPed+"</b></font></TD>"
			_cHtm+="   </tr>"
			_cHtm+="</TABLE>"                                      
			_cHtm+="<br>"

			//Aprovador
			_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
			_cHtm+="     <TR>"
			_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
			_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Aprovador</b></font>"
			_cHtm+="         </TD>"
			_cHtm+="     </TR>"
			_cHtm+="     <TR>"
			_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
			_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(_cUser)+"</b></font>"
			_cHtm+="         </TD>"
			_cHtm+="     </TR>"
			_cHtm+=" </TABLE>"
			
			_cHtm+="<p><font color=#9999cc size=2 face=Verdana><b>Observação</b></font></p>"

			_cHtm+="<TR>"
			_cHtm+="<TD width=470 height=10 bgColor=#ffffff>"
			_cHtm+="<font color=#000040 size=2 face=Verdana>"
			_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObsA)+"</textarea></font></TD>"
			_cHtm+="</TR>"
	
			cQuery := ""
			cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
			TcSQLExec(cQuery)                

		Else	
			
			For _nI := 1 To Len(_aAProv)

				//Cria o processo
				oProcess := TWFProcess():New( "PEDCOM", "Pedido de Compras" )

				//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
				oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\PEDCOMP.HTM" ) 			
				oProcess:cSubject := "Aprovacao Pedido de Compra - Num.: "+_cNumPed

				//Chama rotina de aprovacao
				oProcess:bReturn := "U_COMP005()"

				//oProcess:bTimeOut := {{"U_EXTIMEOUT",0, 0, 5 }}
				oHTML := oProcess:oHTML
	
				DbSelectArea("SE4")
				SE4->( DbSetOrder(1) )
				If SE4->( DbSeek(xFilial("SE4")+SC7->C7_COND) )
					_cCondPg := Alltrim(SE4->E4_DESCRI) 
				EndIf
				
				//Preenche os dados do cabecalho 
				//oHtml:ValByname( "EMPRESA", SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL) )
				oHtml:ValByname( "EMPRESA", Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	) )
				oHtml:ValByName( "EMISSAO", SC7->C7_EMISSAO )
				oHtml:ValByName( "FORNECEDOR", Alltrim(SC7->C7_FORNECE))
                
				DbSelectArea("SA2")
				SA2->( DbSetOrder(1) )
				SA2->( DbSeek(xFilial("SA2")+SC7->C7_FORNECE) )
				oHtml:ValByName( "LB_NOME", Alltrim(SA2->A2_NOME) )
				oHtml:ValByName( "LB_COND", _cCondPg )

				cComprador	:= Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,Alltrim("Y1_NOME"))
				oHtml:ValByName( "COMPRADOR", cComprador )
	
				oHtml:ValByName( "RESPUSR", _aAprov[_nI,1])			   
		
				cAprovador	:= Posicione("SAK",2,xFilial("SAK")+_aAprov[_nI,1],Alltrim("AK_NOME"))
				oHtml:ValByName( "APROVADOR", cAprovador )
				
				DbSelectArea("SC1")	
				SC1->( DbsetOrder(1) )
				If SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
					_cRespSo := UsrFullName(SC1->C1_USER)
				EndIf	
		
				oHtml:ValByName( "SOLICITANTE", Alltrim(_cRespSo) )
				oHtml:ValByName( "PRZENTREGA", SC7->C7_DATPRF )
	
				DbSelectArea("SC7")
				SC7->( DbSetOrder(1) )
				SC7->( DbSeek(Substr(_cFilial,1,2)+SC7->C7_NUM ) )
				oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
				cNum := SC7->C7_NUM
				oProcess:fDesc := "Pedido de Compras No. "+ SC7->C7_NUM
		
				While SC7->( !Eof() ) .And. C7_NUM = cNum
	
					nTotal := nTotal + C7_TOTAL
					Aadd( (oHtml:ValByName( "IT.ITEM" )),SC7->C7_ITEM )
					Aadd( (oHtml:ValByName( "IT.CODIGO" )),Alltrim(SC7->C7_PRODUTO ))
	        	
					DbSelectArea('SB1')
					SB1->( DbSetOrder(1) )
					SB1->( DbSeek(xFilial('SB1')+SC7->C7_PRODUTO) )
					Aadd( (oHtml:ValByName( "IT.PRODUTO" )),Alltrim(SC7->C7_DESCRI ))
					Aadd( (oHtml:ValByName( "IT.UNID" )),SB1->B1_UM )
					Aadd( (oHtml:ValByName( "IT.QUANT" )),TRANSFORM( SC7->C7_QUANT,'@E 999999999.99'   ) )
					Aadd( (oHtml:ValByName( "IT.PRECO" )),TRANSFORM( SC7->C7_PRECO,'@E 999,999,999.99' ) )
					Aadd( (oHtml:ValByName( "IT.TOTAL" )),TRANSFORM( SC7->C7_TOTAL,'@E 999,999,999.99' ) )
										_cObs += IIf(Empty(_cObs),"","  ")+AllTrim(SC7->C7_OBS)
					WFSalvaID('SC7','C7_WFID',oProcess:fProcessID)
					SC7->( DbSkip() )
		    	
				EndDo
	
				oHtml:ValByName( "LBVALOR" ,TRANSFORM( nTotal,'@E 999,999,999.99' ) )
				oHtml:ValByName( "LBFRETE" ,TRANSFORM( 0,'@E 999,999,999.99' ) )
				oHtml:ValByName( "LBTOTAL" ,TRANSFORM( nTotal,'@E 999,999,999.99') )
				
				oHtml:ValByName( "LBOBSP", AllTrim(_cObs)+" "+Alltrim(_cObsA) ) 
				
				oProcess:ClientName( cUserName )
				cMailID := oProcess:Start()
				_cEmail := _aAprov[_nI,2]
				
			Next _nI	
			
			cPath := "http://200.198.75.212/emp01/temp/" +cMailID+ ".htm"
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Apos ter repassado todas as informacoes necessarias para o ³
				//³workflow, solicita a ser executado o método Start() para se³
				//³gerado todo processo e enviar a mensagem ao destinatário.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
				//oProcess:Start()			
			
				_cTo		:= Alltrim(_cEmail)
				_cSubject	:= "Aprovacao Pedido de Compra "
	
				_cHtm += "	<TABLE border=0 width=800>  "
				_cHtm += "   <tr> "
				//_cHtm += "   <td width=180><img src=\\192.168.0.194\workflow\header_logo.jpg></img></td> "
				_cHtm += "   <td width=180><img src=http:\\192.168.0.194:7914\header_logo.jpg></img></td> "
				_cHtm += "   </tr> "
				_cHtm += "	</TABLE> "

				_cHtm += "	<BR> "

				_cHtm += " 	<TABLE border=0 width= 800> "
				_cHtm += " 	   <tr> "
				_cHtm += "      <td width= 600 ><font color= #000040  size= 3 face= Verdana ><hr><b>Aprovação de Pedido de Compra</b></hr></font></td> "
				_cHtm += "	   </tr> "
				_cHtm += "	</TABLE> "

				_cHtm += " 	<BR> "

				_cHtm += "	<b>Favor acessar o link abaixo:</b> "

				_cHtm += "	<BR> "
				_cHtm += " 	<BR> "

				_cHtm += "	<a href="+cPath+">PEDIDO</a> "

				//U_EnvMail(_cTo,_cSubject, _cHtm,)	
				
				cQuery := ""
				cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
				TcSQLExec(cQuery)
				
			EndIf	
			
		ElseIf ( SCR->CR_NIVEL == "03" .And. SCR->CR_TOTAL > GetMv("MV_VLRGER") .And. SCR->CR_STATUS <> "03" )		
				
			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )

	        DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"04" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf	
			
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			_cGrupo := SC7->C7_APROV
			
			If Empty(SC7->C7_NUMSC)
				_cResp := SC7->C7_USER											
			Else				
				DbSelectArea("SC1")	
				SC1->( DbsetOrder(1) )
				SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
				_cResp := SC1->C1_USER
			EndIf	
	
			DbSelectArea("SY1")
			SY1->( DbSetOrder(3) )
			If SY1->( Dbseek(xFilial("SY1")+_cResp) )
	
				DbSelectarea("SAL")
				SAL->( DbSetOrder(1) )
				If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
					While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
		                If SAL->AL_NIVEL == "04" 
		                	if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM )
								Aadd(_aAProv,{SAL->AL_USER,UsrRetMail(SAL->AL_USER)}) 
							Endif
						EndIf	
						SAL->( Dbskip() )		
					EndDo
				EndIf

	 		EndIf
			
			If _cGrupo $ GetMv("MV_GRPRFIN") .And. SCR->CR_TOTAL <= GetMv("MV_VLRDIR")

				DbSelectArea("SCR")		
				SCR->( DbSetOrder(1) )
				SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed ) )
	
				While SCR->( !Eof() ) .And. Substr(_cFilial,1,2) == SCR->CR_FILIAL .And. Alltrim(SCR->CR_NUM) == _cNumPed
	
					If SCR->CR_STATUS <> "03"
					
						RecLock("SCR",.F.)
						SCR->CR_DATALIB	:= dDataBase	
						SCR->CR_STATUS	:= "03"
						SCR->CR_USERLIB := _cUser
						SCR->CR_VALLIB	:= SCR->CR_TOTAL
						SCR->CR_TIPOLIM := "D"
						SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
						SCR->( MsUnLock() )
							
					EndIf	
		
					SCR->( DbSkip() )
		
				EndDo

	            DbSelectArea("SCS")
				SCS->( DbSetOrder(1) )
				If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
					_nSaldo := SCS->CS_SALDO 
					RecLock("SCS",.F.) 
					SCS->CS_FILIAL	:= xFilial("SCS")
					SCS->CS_SALDO := _nSaldo - _nValPed	
					SCS->( MsUnLock() )
				Else 
					_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
					RecLock("SCS",.T.)
					SCS->CS_FILIAL	:= xFilial("SCS")
					SCS->CS_COD		:= _cUser
					SCS->CS_DATA	:= dDatabase
					SCS->CS_MOEDA	:= 1
					SCS->CS_SALDO	:= _nSaldoI - _nValPed	
					SCS->CS_APROV	:= _cGrpApv
					SCS->( MsUnLock() )
				EndIf
			
				DbSelectArea("SC7")		
				SC7->( DbSetOrder(1) )
				SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
				While SC7->( !Eof() ) .And. Substr(_cFilial,1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _cNumPed
					RecLock("SC7",.F.)
					SC7->C7_CONAPRO := "L"
					SC7->( MsUnLock() )
					SC7->( DbSkip() )
				EndDo

				DbSelectArea("SC7")		
				SC7->( DbSetOrder(1) )
				SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			
				If !Empty(SC7->C7_NUMSC)
				
					DbSelectArea("SC1")	
					SC1->( DbsetOrder(1) )
					SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
					_cRespS := SC1->C1_USER				
				
				EndIf
			
				_cTo := Alltrim(UsrRetMail(SC7->C7_USER))+";"+IIf(!Empty(_cRespS),Alltrim(UsrRetMail(_cRespS)),"")			
						
				_cSubject	:= "Liberacao de Pedido de Compra "

				cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
				cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

				// Empresa
				_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2face=Verdana><b>UNIDADE</b></font></TD>"
				_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>Pedido de Compra</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	)+"</b></font></TD>"
				_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cNumPed+"</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="</TABLE>"                                      
				_cHtm+="<br>"

				//Aprovador
				_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
				_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Aprovador</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
				_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(_cUser)+"</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+=" </TABLE>"
			
				_cHtm+="<p><font color=#9999cc size=2 face=Verdana><b>Observação</b></font></p>"

				_cHtm+="<TR>"
				_cHtm+="<TD width=470 height=10 bgColor=#ffffff>"
				_cHtm+="<font color=#000040 size=2 face=Verdana>"
				_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObsA)+"</textarea></font></TD>"
				_cHtm+="</TR>"

				//U_EnvMail(_cTo,_cSubject, _cHtm,)		
				
				cQuery := ""
				cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
				TcSQLExec(cQuery)
				
			Else
			
				For _nI := 1 To Len(_aAProv)

					//Cria o processo
					oProcess := TWFProcess():New( "PEDCOM", "Pedido de Compras" )

					//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
					oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\PEDCOMP.HTM" ) 			
					oProcess:cSubject := "Aprovacao Pedido de Compra - Num.: "+_cNumPed

					//Chama rotina de aprovacao
					oProcess:bReturn := "U_COMP005()"

					//oProcess:bTimeOut := {{"U_EXTIMEOUT",0, 0, 5 }}
					oHTML := oProcess:oHTML
	
					DbSelectArea("SE4")
					SE4->( DbSetOrder(1) )
					If SE4->( DbSeek(xFilial("SE4")+SC7->C7_COND) )
						_cCondPg := Alltrim(SE4->E4_DESCRI) 
					EndIf
				
					//Preenche os dados do cabecalho 
					//oHtml:ValByname( "EMPRESA", SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL) )
					oHtml:ValByname( "EMPRESA", Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	) )
					oHtml:ValByName( "EMISSAO", SC7->C7_EMISSAO )
					oHtml:ValByName( "FORNECEDOR", Alltrim(SC7->C7_FORNECE))

					DbSelectArea("SA2")
					SA2->( DbSetOrder(1) )
					SA2->( DbSeek(xFilial("SA2")+SC7->C7_FORNECE) )
					oHtml:ValByName( "LB_NOME", Alltrim(SA2->A2_NOME) )
					oHtml:ValByName( "LB_COND", _cCondPg )

					cComprador	:= Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,Alltrim("Y1_NOME"))
					oHtml:ValByName( "COMPRADOR", cComprador )
	
					oHtml:ValByName( "RESPUSR", _aAprov[_nI,1])			   
		
					cAprovador	:= Posicione("SAK",2,xFilial("SAK")+_aAprov[_nI,1],Alltrim("AK_NOME"))
					oHtml:ValByName( "APROVADOR", cAprovador )
				
					DbSelectArea("SC1")	
					SC1->( DbsetOrder(1) )
					If SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
						_cRespSo := UsrFullName(SC1->C1_USER)
					EndIf	
		
					oHtml:ValByName( "SOLICITANTE", Alltrim(_cRespSo) )
					oHtml:ValByName( "PRZENTREGA", SC7->C7_DATPRF )
			
					DbSelectArea("SC7")
					SC7->( DbSetOrder(1) )
					SC7->( DbSeek(Substr(_cFilial,1,2)+SC7->C7_NUM ) )
					oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
					cNum := SC7->C7_NUM
					oProcess:fDesc := "Pedido de Compras No. "+ SC7->C7_NUM
		
					While SC7->( !Eof() ) .And. C7_NUM = cNum
	
						nTotal := nTotal + C7_TOTAL
						Aadd( (oHtml:ValByName( "IT.ITEM" )),SC7->C7_ITEM )
						Aadd( (oHtml:ValByName( "IT.CODIGO" )),Alltrim(SC7->C7_PRODUTO ))
	        	
						DbSelectArea('SB1')
						SB1->( DbSetOrder(1) )
						SB1->( DbSeek(xFilial('SB1')+SC7->C7_PRODUTO) )
						Aadd( (oHtml:ValByName( "IT.PRODUTO" )),Alltrim(SC7->C7_DESCRI ))
						Aadd( (oHtml:ValByName( "IT.UNID" )),SB1->B1_UM )
						Aadd( (oHtml:ValByName( "IT.QUANT" )),TRANSFORM( SC7->C7_QUANT,'@E 999999999.99'   ) )
						Aadd( (oHtml:ValByName( "IT.PRECO" )),TRANSFORM( SC7->C7_PRECO,'@E 999,999,999.99' ) )
						Aadd( (oHtml:ValByName( "IT.TOTAL" )),TRANSFORM( SC7->C7_TOTAL,'@E 999,999,999.99' ) )
			
						_cObs += IIf(Empty(_cObs),"","  ")+AllTrim(SC7->C7_OBS)
						WFSalvaID('SC7','C7_WFID',oProcess:fProcessID)
						SC7->( DbSkip() )
		    	
					EndDo
	
					oHtml:ValByName( "LBVALOR" ,TRANSFORM( nTotal,'@E 999,999,999.99' ) )
					oHtml:ValByName( "LBFRETE" ,TRANSFORM( 0,'@E 999,999,999.99' ) )
					oHtml:ValByName( "LBTOTAL" ,TRANSFORM( nTotal,'@E 999,999,999.99') )
		    	
					oHtml:ValByName( "LBOBSP", AllTrim(_cObs)+" "+Alltrim(_cObsA) ) 

					oProcess:ClientName( cUserName )
					cMailID := oProcess:Start()
					_cEmail := _aAprov[_nI,2]
					
				Next _nI	
			
				//cAssunto	:= "Aprovacao Pedido de Compra"
				//cHtmlLink	:= "\WORKFLOW\HTML\LINKPED.HTM" //se for utilizar o link
				//oProcess:NewTask(cAssunto, cHtmlLink)  //Gera o processo para envio do link para o aprovador e os usuarios que serao copiados.
				//oProcess:cSubject := cAssunto //se for utilizar o link
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Endereco eletronico do destinatario aprovador.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//oProcess:cTo := _cEmail
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Link com o endereco para acesso a pagina.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//oProcess:oHtml:ValByName("cPath"	,"\\TERRA\workflow\emp01\temp\" +cMailID+ ".htm")
				//cPath := "\\192.168.0.194\workflow\emp01\temp\" +cMailID+ ".htm"
				cPath := "http://200.198.75.212/emp01/temp/" +cMailID+ ".htm"
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Apos ter repassado todas as informacoes necessarias para o ³
				//³workflow, solicita a ser executado o método Start() para se³
				//³gerado todo processo e enviar a mensagem ao destinatário.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
				//oProcess:Start()
			
				_cTo		:= Alltrim(_cEmail)
				_cSubject	:= 'Aprovacao Pedido de Compra '
	
				_cHtm += "	<TABLE border=0 width=800>  "
				_cHtm += "   <tr> "
				//_cHtm += "   <td width=180><img src=\\192.168.0.194\workflow\header_logo.jpg></img></td> "
				_cHtm += "   <td width=180><img src=http:\\192.168.0.194:7914\header_logo.jpg></img></td> "
				_cHtm += "   </tr> "
				_cHtm += "	</TABLE> "

				_cHtm += "	<BR> "

				_cHtm += " 	<TABLE border=0 width= 800> "
				_cHtm += " 	   <tr> "
				_cHtm += "      <td width= 600 ><font color= #000040  size= 3 face= Verdana ><hr><b>Aprovação de Pedido de Compra</b></hr></font></td> "
				_cHtm += "	   </tr> "
				_cHtm += "	</TABLE> "

				_cHtm += " 	<BR> "

				_cHtm += "	<b>Favor acessar o link abaixo:</b> "

				_cHtm += "	<BR> "
				_cHtm += " 	<BR> "

				_cHtm += "	<a href="+cPath+">PEDIDO</a> "

				//U_EnvMail(_cTo,_cSubject, _cHtm,)	
				
				cQuery := ""
				cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
				TcSQLExec(cQuery)
				
			EndIf	
	
		ElseIf SCR->CR_NIVEL == "03" .And. SCR->CR_STATUS <> "03"

			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )

            DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"04" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf	
						
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			While SC7->( !Eof() ) .And. Substr(_cFilial,1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _cNumPed
				RecLock("SC7",.F.)
				SC7->C7_CONAPRO := "L"
				SC7->( MsUnLock() )
				SC7->( DbSkip() )
			EndDo
			
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			
			If !Empty(SC7->C7_NUMSC)
				
				DbSelectArea("SC1")	
				SC1->( DbsetOrder(1) )
				SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
				_cRespS := SC1->C1_USER				
				
			EndIf
			
			_cTo := Alltrim(UsrRetMail(SC7->C7_USER))+";"+IIf(!Empty(_cRespS),Alltrim(UsrRetMail(_cRespS)),"")
			
			_cSubject	:= "Liberacao de Pedido de Compra "

				cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
				cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

				// Empresa
				_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2face=Verdana><b>UNIDADE</b></font></TD>"
				_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>Pedido de Compra</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	)+"</b></font></TD>"
				_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cNumPed+"</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="</TABLE>"                                      
				_cHtm+="<br>"

				//Aprovador
				_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
				_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Aprovador</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
				_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(_cUser)+"</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+=" </TABLE>"
			
				_cHtm+="<p><font color=#9999cc size=2 face=Verdana><b>Observação</b></font></p>"

				_cHtm+="<TR>"
				_cHtm+="<TD width=470 height=10 bgColor=#ffffff>"
				_cHtm+="<font color=#000040 size=2 face=Verdana>"
				_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObsA)+"</textarea></font></TD>"
				_cHtm+="</TR>"

				//U_EnvMail(_cTo,_cSubject, _cHtm,)		
				
				cQuery := ""
				cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
				TcSQLExec(cQuery)
			
		ElseIf ( SCR->CR_NIVEL == "04" .And. SCR->CR_TOTAL > GetMv("MV_VLRDIR") .And. SCR->CR_STATUS <> "03" )		
				
			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )

	        DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"05" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "02"
				SCR->( MsUnLock() )
				
			EndIf							

			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			_cGrupo := SC7->C7_APROV
			
			If Empty(SC7->C7_NUMSC)
				_cResp := SC7->C7_USER											
			Else				
				DbSelectArea("SC1")	
				SC1->( DbsetOrder(1) )
				SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
				_cResp := SC1->C1_USER
			EndIf	
	
			DbSelectArea("SY1")
			SY1->( DbSetOrder(3) )
			If SY1->( Dbseek(xFilial("SY1")+_cResp) )
	
				DbSelectarea("SAL")
				SAL->( DbSetOrder(1) )
				If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
					While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
		                If SAL->AL_NIVEL == "05"     
		                	if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM )
						   		Aadd(_aAProv,{SAL->AL_USER,UsrRetMail(SAL->AL_USER)})   
							Endif
						EndIf	
						SAL->( Dbskip() )		
					EndDo
				EndIf

	 		EndIf
	        
			If _cGrupo $ GetMv("MV_GRPRFIN")
			
				DbSelectArea("SC7")		
				SC7->( DbSetOrder(1) )
				SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
				While SC7->( !Eof() ) .And. Substr(_cFilial,1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _cNumPed
					RecLock("SC7",.F.)
					SC7->C7_CONAPRO := "L"
					SC7->( MsUnLock() )
					SC7->( DbSkip() )
				EndDo

				DbSelectArea("SC7")		
				SC7->( DbSetOrder(1) )
				SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			
				If !Empty(SC7->C7_NUMSC)
				
					DbSelectArea("SC1")	
					SC1->( DbsetOrder(1) )
					SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
					_cRespS := SC1->C1_USER				
				
				EndIf
			
				_cTo := Alltrim(UsrRetMail(SC7->C7_USER))+";"+IIf(!Empty(_cRespS),Alltrim(UsrRetMail(_cRespS)),"")			
						
				_cSubject	:= "Liberacao de Pedido de Compra "

				cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
				cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

				// Empresa
				_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2face=Verdana><b>UNIDADE</b></font></TD>"
				_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>Pedido de Compra</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	)+"</b></font></TD>"
				_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cNumPed+"</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="</TABLE>"                                      
				_cHtm+="<br>"

				//Aprovador
				_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
				_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Aprovador</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
				_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(_cUser)+"</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+=" </TABLE>"
			
				_cHtm+="<p><font color=#9999cc size=2 face=Verdana><b>Observação</b></font></p>"

				_cHtm+="<TR>"
				_cHtm+="<TD width=470 height=10 bgColor=#ffffff>"
				_cHtm+="<font color=#000040 size=2 face=Verdana>"
				_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObsA)+"</textarea></font></TD>"
				_cHtm+="</TR>"

				//U_EnvMail(_cTo,_cSubject, _cHtm,)		
				
				cQuery := ""
				cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
				TcSQLExec(cQuery)
				
			Else	
	
				For _nI := 1 To Len(_aAProv)

					//Cria o processo
					oProcess := TWFProcess():New( "PEDCOM", "Pedido de Compras" )

					//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
					oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\PEDCOMP.HTM" ) 			
					oProcess:cSubject := "Aprovacao Pedido de Compra - Num.: "+_cNumPed

					//Chama rotina de aprovacao
					oProcess:bReturn := "U_COMP005()"

					//oProcess:bTimeOut := {{"U_EXTIMEOUT",0, 0, 5 }}
					oHTML := oProcess:oHTML
	
					DbSelectArea("SE4")
					SE4->( DbSetOrder(1) )
					If SE4->( DbSeek(xFilial("SE4")+SC7->C7_COND) )
						_cCondPg := Alltrim(SE4->E4_DESCRI) 
					EndIf
				
					//Preenche os dados do cabecalho 
					//oHtml:ValByname( "EMPRESA", SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL) )
					oHtml:ValByname( "EMPRESA", Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	) )
					oHtml:ValByName( "EMISSAO", SC7->C7_EMISSAO )
					oHtml:ValByName( "FORNECEDOR", Alltrim(SC7->C7_FORNECE))
                	
					DbSelectArea("SA2")
					SA2->( DbSetOrder(1) )
					SA2->( DbSeek(xFilial("SA2")+SC7->C7_FORNECE) )
					oHtml:ValByName( "LB_NOME", Alltrim(SA2->A2_NOME) )
					oHtml:ValByName( "LB_COND", _cCondPg )

					cComprador	:= Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,Alltrim("Y1_NOME"))
					oHtml:ValByName( "COMPRADOR", cComprador )
	    	
					oHtml:ValByName( "RESPUSR", _aAprov[_nI,1])			   
		
					cAprovador	:= Posicione("SAK",2,xFilial("SAK")+_aAprov[_nI,1],Alltrim("AK_NOME"))
					oHtml:ValByName( "APROVADOR", cAprovador )
				
					DbSelectArea("SC1")	
					SC1->( DbsetOrder(1) )
					If SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
						_cRespSo := UsrFullName(SC1->C1_USER)
					EndIf	
		
					oHtml:ValByName( "SOLICITANTE", Alltrim(_cRespSo) )
					oHtml:ValByName( "PRZENTREGA", SC7->C7_DATPRF )
			
					DbSelectArea("SC7")
					SC7->( DbSetOrder(1) )
					SC7->( DbSeek(Substr(_cFilial,1,2)+SC7->C7_NUM ) )
					oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
					cNum := SC7->C7_NUM
					oProcess:fDesc := "Pedido de Compras No. "+ SC7->C7_NUM
		
					While SC7->( !Eof() ) .And. C7_NUM = cNum
	
						nTotal := nTotal + C7_TOTAL
						Aadd( (oHtml:ValByName( "IT.ITEM" )),SC7->C7_ITEM )
						Aadd( (oHtml:ValByName( "IT.CODIGO" )),Alltrim(SC7->C7_PRODUTO ))
	
						DbSelectArea('SB1')
						SB1->( DbSetOrder(1) )
						SB1->( DbSeek(xFilial('SB1')+SC7->C7_PRODUTO) )
						Aadd( (oHtml:ValByName( "IT.PRODUTO" )),Alltrim(SC7->C7_DESCRI ))
						Aadd( (oHtml:ValByName( "IT.UNID" )),SB1->B1_UM )
						Aadd( (oHtml:ValByName( "IT.QUANT" )),TRANSFORM( SC7->C7_QUANT,'@E 999999999.99'   ) )
						Aadd( (oHtml:ValByName( "IT.PRECO" )),TRANSFORM( SC7->C7_PRECO,'@E 999,999,999.99' ) )
						Aadd( (oHtml:ValByName( "IT.TOTAL" )),TRANSFORM( SC7->C7_TOTAL,'@E 999,999,999.99' ) )
				
						_cObs += IIf(Empty(_cObs),"","  ")+AllTrim(SC7->C7_OBS)
						WFSalvaID('SC7','C7_WFID',oProcess:fProcessID)
						SC7->( DbSkip() )
		
					EndDo
	
					oHtml:ValByName( "LBVALOR" ,TRANSFORM( nTotal,'@E 999,999,999.99' ) )
					oHtml:ValByName( "LBFRETE" ,TRANSFORM( 0,'@E 999,999,999.99' ) )
					oHtml:ValByName( "LBTOTAL" ,TRANSFORM( nTotal,'@E 999,999,999.99') )
		    	
					oHtml:ValByName( "LBOBSP", AllTrim(_cObs)+" "+Alltrim(_cObsA) ) 
				
					oProcess:ClientName( cUserName )
					cMailID := oProcess:Start()
					_cEmail := _aAprov[_nI,2]
					
				Next _nI	
			
				//cAssunto	:= "Aprovacao Pedido de Compra"
				//cHtmlLink	:= "\WORKFLOW\HTML\LINKPED.HTM" //se for utilizar o link
				//oProcess:NewTask(cAssunto, cHtmlLink)  //Gera o processo para envio do link para o aprovador e os usuarios que serao copiados.
				//oProcess:cSubject := cAssunto //se for utilizar o link
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Endereco eletronico do destinatario aprovador.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//oProcess:cTo := _cEmail
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Link com o endereco para acesso a pagina.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//oProcess:oHtml:ValByName("cPath"	,"\\TERRA\workflow\emp01\temp\" +cMailID+ ".htm")
				//cPath := "\\192.168.0.194\workflow\emp01\temp\" +cMailID+ ".htm"
				cPath := "http://200.198.75.212/emp01/temp/" +cMailID+ ".htm"
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Apos ter repassado todas as informacoes necessarias para o ³
				//³workflow, solicita a ser executado o método Start() para se³
				//³gerado todo processo e enviar a mensagem ao destinatário.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
				//oProcess:Start()
			
				_cTo		:= Alltrim(_cEmail)
				_cSubject	:= " Aprovacao Pedido de Compra "
	
  				_cHtm += "	<TABLE border=0 width=800>  "
				_cHtm += "   <tr> "
				//_cHtm += "   <td width=180><img src=\\192.168.0.194\workflow\header_logo.jpg></img></td> "
				_cHtm += "   <td width=180><img src=http:\\192.168.0.194:7914\header_logo.jpg></img></td> "
				_cHtm += "   </tr> "
				_cHtm += "	</TABLE> "

				_cHtm += "	<BR> "

				_cHtm += " 	<TABLE border=0 width= 800> "
				_cHtm += " 	   <tr> "
				_cHtm += "      <td width= 600 ><font color= #000040  size= 3 face= Verdana ><hr><b>Aprovação de Pedido de Compra</b></hr></font></td> "
				_cHtm += "	   </tr> "
				_cHtm += "	</TABLE> "

				_cHtm += " 	<BR> "

				_cHtm += "	<b>Favor acessar o link abaixo:</b> "

				_cHtm += "	<BR> "
				_cHtm += " 	<BR> "

				_cHtm += "	<a href="+cPath+">PEDIDO</a> "
				//U_EnvMail(_cTo,_cSubject, _cHtm,)	
				
				cQuery := ""
				cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
				TcSQLExec(cQuery)
				
			EndIf	
			
		ElseIf SCR->CR_NIVEL == "04" .And. SCR->CR_STATUS <> "03"

			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed ) )
	
			While SCR->( !Eof() ) .And. Substr(_cFilial,1,2) == SCR->CR_FILIAL .And. Alltrim(SCR->CR_NUM) == _cNumPed
	
				If SCR->CR_STATUS <> "03"
					
					RecLock("SCR",.F.)
					SCR->CR_DATALIB	:= dDataBase	
					SCR->CR_STATUS	:= "03"
					SCR->CR_USERLIB := _cUser
					SCR->CR_VALLIB	:= SCR->CR_TOTAL
					SCR->CR_TIPOLIM := "D"
					SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
					SCR->( MsUnLock() )
						
				EndIf	
		
				SCR->( DbSkip() )
		
			EndDo

            DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SCR")		
			SCR->( DbSetOrder(1) )
			If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+"05" ) )

				RecLock("SCR",.F.)
				SCR->CR_STATUS	:= "03"
				SCR->( MsUnLock() )
				
			EndIf	
						
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			While SC7->( !Eof() ) .And. Substr(_cFilial,1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _cNumPed
				RecLock("SC7",.F.)
				SC7->C7_CONAPRO := "L"
				SC7->( MsUnLock() )
				SC7->( DbSkip() )
			EndDo
			
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			
			If !Empty(SC7->C7_NUMSC)
				
				DbSelectArea("SC1")	
				SC1->( DbsetOrder(1) )
				SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
				_cRespS := SC1->C1_USER				
				
			EndIf
			
			_cTo := Alltrim(UsrRetMail(SC7->C7_USER))+";"+IIf(!Empty(_cRespS),Alltrim(UsrRetMail(_cRespS)),"")
			
			_cSubject	:= "Liberacao de Pedido de Compra "

				cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
				cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

				// Empresa
				_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2face=Verdana><b>UNIDADE</b></font></TD>"
				_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>Pedido de Compra</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	)+"</b></font></TD>"
				_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cNumPed+"</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="</TABLE>"                                      
				_cHtm+="<br>"

				//Aprovador
				_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
				_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Aprovador</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
				_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(_cUser)+"</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+=" </TABLE>"
			
				_cHtm+="<p><font color=#9999cc size=2 face=Verdana><b>Observação</b></font></p>"

				_cHtm+="<TR>"
				_cHtm+="<TD width=470 height=10 bgColor=#ffffff>"
				_cHtm+="<font color=#000040 size=2 face=Verdana>"
				_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObsA)+"</textarea></font></TD>"
				_cHtm+="</TR>"

				//U_EnvMail(_cTo,_cSubject, _cHtm,)		
				
				cQuery := ""
				cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
				TcSQLExec(cQuery)
			
		ElseIf SCR->CR_NIVEL == "05" .And. SCR->CR_STATUS <> "03"

			RecLock("SCR",.F.)
			SCR->CR_DATALIB	:= dDataBase	
			SCR->CR_STATUS	:= "03"
			SCR->CR_USERLIB := _cUser
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM := "D"
			SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
			SCR->( MsUnLock() )

            DbSelectArea("SCS")
			SCS->( DbSetOrder(1) )
			If SCS->( DbSeek( xFilial("SCS")+_cUser+DToS(dDatabase) ) )
				_nSaldo := SCS->CS_SALDO 
				RecLock("SCS",.F.) 
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_SALDO := _nSaldo - _nValPed	
				SCS->( MsUnLock() )
			Else 
				_nSaldoI := Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_LIMITE")
				RecLock("SCS",.T.)
				SCS->CS_FILIAL	:= xFilial("SCS")
				SCS->CS_COD		:= _cUser
				SCS->CS_DATA	:= dDatabase
				SCS->CS_MOEDA	:= 1
				SCS->CS_SALDO	:= _nSaldoI - _nValPed	
				SCS->CS_APROV	:= _cGrpApv
				SCS->( MsUnLock() )
			EndIf
			
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			While SC7->( !Eof() ) .And. Substr(_cFilial,1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _cNumPed
				RecLock("SC7",.F.)
				SC7->C7_CONAPRO := "L"
				SC7->( MsUnLock() )
				SC7->( DbSkip() )
			EndDo
			
			DbSelectArea("SC7")		
			SC7->( DbSetOrder(1) )
			SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
			
			If !Empty(SC7->C7_NUMSC)
				
				DbSelectArea("SC1")	
				SC1->( DbsetOrder(1) )
				SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
				_cRespS := SC1->C1_USER				
				
			EndIf
			
			_cTo := Alltrim(UsrRetMail(SC7->C7_USER))+";"+IIf(!Empty(_cRespS),Alltrim(UsrRetMail(_cRespS)),"")
			
			_cSubject	:= " Liberacao de Pedido de Compra "

				cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
				cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

				// Empresa
				_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2face=Verdana><b>UNIDADE</b></font></TD>"
				_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center>"
				_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>Pedido de Compra</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="   <tr>"
				_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	)+"</b></font></TD>"
				_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
				_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cNumPed+"</b></font></TD>"
				_cHtm+="   </tr>"
				_cHtm+="</TABLE>"                                      
				_cHtm+="<br>"

				//Aprovador
				_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
				_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Aprovador</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+="     <TR>"
				_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
				_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(_cUser)+"</b></font>"
				_cHtm+="         </TD>"
				_cHtm+="     </TR>"
				_cHtm+=" </TABLE>"
			
				_cHtm+="<p><font color=#9999cc size=2 face=Verdana><b>Observação</b></font></p>"

				_cHtm+="<TR>"
				_cHtm+="<TD width=470 height=10 bgColor=#ffffff>"
				_cHtm+="<font color=#000040 size=2 face=Verdana>"
				_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObsA)+"</textarea></font></TD>"
				_cHtm+="</TR>"

				//U_EnvMail(_cTo,_cSubject, _cHtm,)		
				
				cQuery := ""
				cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
				TcSQLExec(cQuery)
	    
	    EndIf
	    
	End Transaction	    
	    
	EndIf	    
	
Return	
	
Static Function Bloqueia(_cFilial,_cNumPed,_cUser,_cObsA)

Local _cRespS	:= Space(6)
Local _cEmail	:= ""
Local _cHtm		:= ""

DbSelectArea("SCR")		
SCR->( DbSetOrder(2) )
If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+_cUser ) )
		
	Begin Transaction
		
	RecLock("SCR",.F.)
	SCR->CR_DATALIB	:= dDataBase	
	SCR->CR_STATUS	:= "04"
	SCR->CR_USERLIB := _cUser
	SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
	SCR->CR_OBS 	:= _cObsA
	SCR->( MsUnLock() )

    End Transaction
   
EndIf    
	
DbSelectArea("SC7")		
SC7->( DbSetOrder(1) )
SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )

If !Empty(SC7->C7_NUMSC)
				
	DbSelectArea("SC1")	
	SC1->( DbsetOrder(1) )
	SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
	_cRespS := SC1->C1_USER				
	
EndIf
			
_cTo := UsrRetMail(SC7->C7_USER)+IIf(!Empty(_cRespS),UsrRetMail(_cRespS),"")
	
_cSubject	:= " Bloqueio de Pedido de Compra "

cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

// Empresa
_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
_cHtm+="   <tr>"
_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
_cHtm+="         <font color=#ffffff size=2face=Verdana><b>UNIDADE</b></font></TD>"
_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center>"
_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>Pedido de Compra</b></font></TD>"
_cHtm+="   </tr>"
_cHtm+="   <tr>"
_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	)+"</b></font></TD>"
_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cNumPed+"</b></font></TD>"
_cHtm+="   </tr>"
_cHtm+="</TABLE>"                                      
_cHtm+="<br>"

//Aprovador
_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
_cHtm+="     <TR>"
_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Aprovador</b></font>"
_cHtm+="         </TD>"
_cHtm+="     </TR>"
_cHtm+="     <TR>"
_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(_cUser)+"</b></font>"
_cHtm+="         </TD>"
_cHtm+="     </TR>"
_cHtm+=" </TABLE>"
		
_cHtm+="<p><font color=#9999cc size=2 face=Verdana><b>Observação</b></font></p>"

_cHtm+="<TR>"
_cHtm+="<TD width=470 height=10 bgColor=#ffffff>"
_cHtm+="<font color=#000040 size=2 face=Verdana>"
_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObsA)+"</textarea></font></TD>"
_cHtm+="</TR>"

//U_EnvMail(_cTo,_cSubject, _cHtm,)		
				
cQuery := ""
cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
TcSQLExec(cQuery)
    
Return