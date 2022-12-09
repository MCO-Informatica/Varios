#include "sigawin.ch"
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"

/*
+============================================================+
|Programa: COMP011 |Autor: Antonio Carlos |Data: 01/06/10    |
+============================================================+
|Descricao: Rotina responsavel pela aprovação de Pedidos de  |
|Compra via Protheus.                                        |
+============================================================+
|Especifico: Laselva                                         |
+============================================================+

Alteração
+================================================================+
|Solicitante: Luis Fernando |Autor:Antonio Carlos |Data: 09/09/10|
+================================================================+
|Motivo: Mudança nas regra de aprovação de Pedido de Compra.     |
+================================================================+
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function COMP011()
///////////////////////

Local aPosObj  		:= {}
Local aObjects 		:= {}
Local aSize   	 	:= {}
Local aPosGet 	 	:= {}
Local aInfo    		:= {}

Public _cUser 		:= RetCodUsr()
Public _aAProv 		:= {}

Private oValor
Private oQtda
Private nQtd		:= 0
Private lInverte	:= .F.
Private cMarca1		:= GetMark()
Private cMarca2		:= GetMark()
Private aCores		:= {}
Private aButtons	:= {{"OBJETIVO"	,{||Legenda()},"Legenda" }}
Private cCadastro	:= "Aprovacao Pedidos de Compra"
Private _cSql		:= ""
Private lInvFil		:= .F.
Private oChkInvFil

If (__cUserId $ GetMv('LA_PODER'))
	_cUser := LS_RetAprov()
	If !empty(_cUser)
		_cUser := Posicione('SAK',1,xFilial('SAK') + _cUser,'AK_USER')
	EndIf
EndIf
aSize	:= MsAdvSize(,.F.,400)

aObjects := {}

AAdd( aObjects, { 0,    61, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    50, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,023,043,063,154,162,222,255}} )
nGetLin := aPosObj[3,1]

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
Aadd(aCampos, {"TIPODOC"	,"C" ,3, 0})
Aadd(aCampos, {"VALOR"		,"N" ,14,2})
Aadd(aCampos, {"CPAGTO"		,"C", 15,0})
Aadd(aCampos, {"FORNECEDOR"	,"C" ,50,2})
Aadd(aCampos, {"EMISSAO"	,"D" ,8 ,0})
Aadd(aCampos, {"ENTREGA"	,"D" ,8, 2})
Aadd(aCampos, {"COMPRADOR"	,"C" ,50,0})
Aadd(aCampos, {"OBS"		,"C" ,30,0})
Aadd(aCampos, {"CODUSU"		,"C" ,6, 0})
Aadd(aCampos, {"CODAPRO"	,"C" ,6, 0})
Aadd(aCampos, {"STATUSP"	,"C" ,2, 0})
Aadd(aCampos, {"PEDAGLU"	,"C" ,1, 0})
Aadd(aCampos, {"CGC"		,"C" ,8, 0})

aCpos		:= {}
Aadd(aCpos, {"OK"	   		,,  			})
Aadd(aCpos, {"FILIAL" 		,, "Filial"		})
Aadd(aCpos, {"NOME" 		,, "Nome"		})
Aadd(aCpos, {"DOCUMENTO" 	,, "Documento"	})
Aadd(aCpos, {"TIPODOC"	    ,, "Tipo Docto"		})
Aadd(aCpos, {"VALOR"       	,, "Valor" 		,"@E 99,999,999,999.99"})
Aadd(aCpos, {"CPAGTO"      	,, "Cond.Pagto" })
Aadd(aCpos, {"FORNECEDOR"  	,, "Fornecedor" })
Aadd(aCpos, {"EMISSAO"     	,, "Emissao"	})
Aadd(aCpos, {"ENTREGA"     	,, "Entrega" 	})
Aadd(aCpos, {"COMPRADOR"   	,, "Comprador" 	})
Aadd(aCpos, {"OBS" 	    	,, "Observacao" })
Aadd(aCpos, {"CODUSU"		,, "Cod.Usuario"	})
Aadd(aCpos, {"CODAPRO" 		,, "Cod.Aprovador"	})
Aadd(aCpos, {"CGC" 			,, "CNPJ"			})

cTrab := CriaTrab(aCampos)
DbCreate(cTrab, aCampos)
DbUseArea( .T.,, cTrab, "TMP", .F., .F. )

IndRegua("TMP",cTrab,"FILIAL+DOCUMENTO",,,"Ordenando por Filial")

GeraSql()

DbSelectArea("TMP")
TMP->( DbGoTop() )

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

@1.4,.8 SAY OemToAnsi("Quantidade:" )//"Quantidade:"
@1.4, 7 SAY oQtda VAR nQtd Picture "@E 99999" SIZE 50,10

oMark := MsSelect():New("TMP","OK",,aCpos,@lInverte,@cMarca1,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]},,,,,aCores)

oMark:bMark := {| | Marca(cMarca1,lInverte,oQtda)}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.

@ nGetLin,aPosGet[1,1]	BUTTON "Pesquisar" 	 SIZE 30,15 ACTION( Pesqui() ) OF oDlg PIXEL
@ nGetLin,aPosGet[1,2]	BUTTON "Visualizar"	 SIZE 30,15 ACTION( Visual() ) OF oDlg PIXEL
@ nGetLin,aPosGet[1,3]	BUTTON "Liberar" 	 SIZE 30,15 ACTION( LibPed() ) OF oDlg PIXEL
@ nGetLin,aPosGet[1,4]	BUTTON "Bloquear"	 SIZE 30,15 ACTION( BlqPed() ) OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2,oDlg:End()},,aButtons)

Return Nil

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraSql()
/////////////////////////

Local _nReg		:= 0
Local _aItPed	:= {}
Local _cObserv	:= ""
Local _dEntre	:= CTOD("  /  /  ")

Private _nTotal	:= 0

cQuery := " SELECT CR_FILIAL, CR_NUM, E4_DESCRI, A2_NOME, SUBSTRING(A2_CGC,1,8) AS CGC, C7_USER, CR_TIPO, CR_USER, CR_APROV, CR_USERLIB, CR_TOTAL, C7_EMISSAO, CR_STATUS, SUM(C7_TOTAL) AS 'TOTAL' "
cQuery += " FROM "+RetSqlName("SCR")+" SCR 	(NOLOCK) "
cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 (NOLOCK) "
cQuery += " 		ON CR_FILIAL 	= C7_FILIAL 	AND RTRIM(CR_NUM)	= C7_NUM 	AND SC7.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 (NOLOCK) "
cQuery += " 		ON A2_COD 		= C7_FORNECE 	AND A2_LOJA 		= C7_LOJA	AND SA2.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN "+RetSqlName("SE4")+" SE4 (NOLOCK) "
cQuery += " 		ON C7_COND 		= E4_CODIGO 	AND SE4.D_E_L_E_T_ 	= '' "
cQuery += " WHERE "
If !empty(_cUser)
	cQuery += " CR_USER 	= '"+_cUser+"' AND "
EndIf
cQuery += _cSql
cQuery += " SCR.D_E_L_E_T_	= '' "

cQuery += " GROUP BY CR_FILIAL, CR_NUM, E4_DESCRI, A2_NOME, C7_USER, CR_TIPO, CR_USER, A2_CGC, CR_APROV, CR_USERLIB, CR_TOTAL, C7_EMISSAO, CR_STATUS "
cQuery += " ORDER BY CR_USER, A2_CGC, CR_FILIAL "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.)

Do While QRY->( !Eof() )
	
	_cCgc := QRY->CGC
	
	Do While QRY->( !Eof() ) .And. _cCgc == QRY->CGC
		
		nPos := aScan(_aItPed,{|x| x[15] == QRY->CGC })
		
		If nPos == 0
			
			Aadd(_aItPed, {	QRY->CR_FILIAL,;
			GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + QRY->CR_FILIAL),;
			QRY->CR_NUM,;
			QRY->CR_TOTAL,;
			QRY->E4_DESCRI,;
			QRY->A2_NOME,;
			STOD(QRY->C7_EMISSAO),;
			Posicione("SC7",1,QRY->CR_FILIAL+Alltrim(QRY->CR_NUM),"C7_DATPRF"),;
			Alltrim(UsrFullName(QRY->C7_USER)),;
			Posicione("SC7",1,QRY->CR_FILIAL+Alltrim(QRY->CR_NUM),"C7_OBS"),;
			QRY->CR_TIPO,;
			QRY->CR_USER,;
			QRY->CR_APROV,;
			QRY->CR_STATUS ,;
			QRY->CGC })
			
		EndIf
		
		_nTotal += QRY->CR_TOTAL
		_nReg++
		
		DbSelectArea('QRY')
		DbSkip()
		
	EndDo
	
	For _nI := 1 To Len(_aItPed)
		
		RecLock("TMP",.T.)
		
		TMP->FILIAL		:= _aItPed[_nI,1]
		TMP->NOME		:= _aItPed[_nI,2]
		TMP->VALOR		:= _nTotal
		TMP->CPAGTO		:= _aItPed[_nI,5]
		TMP->FORNECEDOR	:= _aItPed[_nI,6]
		TMP->EMISSAO	:= _aItPed[_nI,7]
		TMP->ENTREGA	:= _aItPed[_nI,8]
		TMP->COMPRADOR	:= _aItPed[_nI,9]
		If _nReg > 1
			TMP->DOCUMENTO	:= 'Varios'
			TMP->OBS		:= "Pedidos aglutinados"
			TMP->PEDAGLU	:= "S"
			TMP->TIPODOC	:= "PCA"
		Else
			TMP->DOCUMENTO	:= _aItPed[_nI,3]
			TMP->OBS		:= _aItPed[_nI,10]
			TMP->PEDAGLU	:= "N"
			TMP->TIPODOC	:= "PC"
		EndIf
		TMP->CODUSU		:= _aItPed[_nI,12]
		TMP->CODAPRO	:= _aItPed[_nI,13]
		TMP->STATUSP	:= _aItPed[_nI,14]
		TMP->CGC		:= _aItPed[_nI,15]
		
		TMP->( MsUnLock() )
		
	Next _nI
	
	_nTotal := 0
	_nReg	:= 0
	_aItPed	:= {}
	
EndDo

DbSelectArea('QRY')
DbCloseArea()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Marca(cMarca,lInverte,oQtda)
////////////////////////////////////////////

If IsMark("OK",cMarca,lInverte)
	nQtd ++
Else
	nQtd --
	nQtd := IIf(nQtd<0,0,nQtd)
Endif

oQtda:Refresh()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Legenda()
/////////////////////////

Local aLegenda := {}

AADD(aLegenda,{"BR_PRETO"	  	,"Nivel Bloqueado" 		})
AADD(aLegenda,{"BR_VERMELHO"	,"Aguardando Liberacao" })
AADD(aLegenda,{"BR_VERDE"		,"Pedido Liberado" 		})
AADD(aLegenda,{"BR_CINZA"		,"Pedido Bloqueado" 	})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Pesqui()
////////////////////////

Private cDoc	:= Space(8)
Private oDlgPsq

DEFINE MSDIALOG oDlgPsq TITLE "Pesquisa" FROM 129,047 TO 250,280 PIXEL

@ 08,20 SAY OemToAnsi("Filial+Documento")	PIXEL OF oDlgPsq
@ 18,20 MSGET oDoc VAR cDoc PICTURE "@!"	PIXEL OF oDlgPsq
@ 40,20 BUTTON "Ok"  		SIZE 31,10 ACTION PsqDoc()			PIXEL OF oDlgPsq
@ 40,70 BUTTON "Cancela"	SIZE 30,10 ACTION oDlgPsq:End()		PIXEL OF oDlgPsq

ACTIVATE MSDIALOG oDlgPsq CENTERED

Return nil

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function PsqDoc()
////////////////////////

DbSelectArea("TMP")
IndRegua("TMP",cTrab,"FILIAL+DOCUMENTO",,,"Ordenando por Filial+Documento")
If !DbSeek(cDoc,.F.)
	MsgStop("Nao encontrado!")
EndIf
oMark:oBrowse:Refresh()
oDlgPsq:End()

Return(Nil)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Visual()
////////////////////////

Local _cIns := _cSql

If TMP->TIPODOC == "PCA"
	U_COMP014(TMP->FILIAL,Alltrim(TMP->DOCUMENTO),TMP->CGC,_cIns)
Else
	U_COMP012(TMP->FILIAL,Alltrim(TMP->DOCUMENTO))
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LibPed()
////////////////////////

Local _cInsSql	:= _cSql

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
	
	If TMP->TIPODOC == "PCA"
		AprovaPA(TMP->EMISSAO,TMP->CGC,1,_cInsSql)
	Else
		MsAguarde({|lEnd| },"Aguarde...","Liberando Pedidos: "+TMP->FILIAL+Alltrim(TMP->DOCUMENTO),.T.)
		Aprova(TMP->FILIAL,Alltrim(TMP->DOCUMENTO),TMP->CODUSU,TMP->OBS,TMP->VALOR,TMP->EMISSAO)
	EndIf
	
	DbSelectArea("TMP")
	DbGoTo( TMP->( Recno() ) )
	TMP->( DbDelete() )
	
	TMP->( DbSkip() )
	
EndDo

DbSelectArea("TMP")
TMP->( DbGoTop() )

oMark:oBrowse:Refresh()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Aprova(__cFilial,__cNumPed,__cUser,__cObsA,__VALOR,__DtEmis)
///////////////////////////////////////////////////////

Local _cRespS	:= Space(6)
Local _cEmail	:= ""
Local _cHtm		:= ""

Local lLiberou	:= .F.
Local cObs		:= ""
Local _nValPed	:= 0
Local _cGrpApv	:= Space(6)
Local _cUsuApr  :=	_cAutoLim := ''
 
Public _cFilial	:= __cFilial
Public _cNumPed	:= __cNumPed
Public _cUser	:= __cUser
Public _cObsA	:= __cObsA
Public _Valor   := __VALOR  
Public dRefer   := __DtEmis

_cFilAt := cFilAnt

nOpc := 2

cFilAnt := Substr(_cFilial,1,2)

DbSelectArea("SC7")
SC7->( DbSetOrder(1) )
If SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
	_cGrpApv := SC7->C7_APROV
EndIf  

//--> Callsystem, localizando se o grupo aceita autolimite
DbSelectArea("SY1")
SY1->( DbSetOrder(3) )
If SY1->( Dbseek(xFilial("SY1")+_cUser) )
	
	_cGrpApv := IIF(EMPTY(_cGrpApv),SY1->Y1_GRAPROV,_cGrpApv) //SY1->Y1_GRAPROV

	
	DbSelectarea("SAL")
	SAL->( DbSetOrder(1) )
	If SAL->( DbSeek(xFilial("SAL")+_cGrpApv) )  
	
		_cAutoLim := SAL->AL_AUTOLIM 
		_cUsuApr  := SAL->AL_APROV 
	 
	EndIf
	
EndIf
 
DbSelectArea("SCR")
SCR->( DbSetOrder(2) )
If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+_cUser ) )
	
	_cCodLib := SCR->CR_APROV
	_nValPed := SCR->CR_TOTAL
	
	lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,_nValPed,_cCodLib,,_cGrpApv,,,,,cObs},dDatabase,If(nOpc==2,4,6))
// SANDRO REIS 06/03/14	lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,_Valor  ,_cCodLib,,_cGrpApv,,,,,cObs},dRefer,If(nOpc==2,4,6))
	
	If lLiberou
		
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

		U_AWFPC()

		
		/*
		_cSubject	:= "Liberacao de Pedido de Compra "
		
		cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
		cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")
		
		//Empresa
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
		
		//Fornecedor
		_cHtm+=" <TABLE width=480 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
		_cHtm+="     <TR>"
		_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
		_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Fornecedor</b></font>"
		_cHtm+="         </TD>"
		_cHtm+="     </TR>"
		_cHtm+="     <TR>"
		_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
		_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+SC7->C7_FORNECE+"-"+SC7->C7_LOJA+" - "+Substr(cFornece,1,30)+"</b></font>"
		_cHtm+="         </TD>"
		_cHtm+="     </TR>"
		_cHtm+=" </TABLE>"
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
		*/
	ELSE
	
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+"PC"+_cNumPed)
		
		WHILE !EOF() .AND. alltrim(SCR->CR_NUM) == _cNumPed //.AND. LEN(_aAprov) <= 1
		
			IF EMPTY(ALLTRIM(SCR->CR_USERLIB)) //SCR->CR_STATUS == '01' .AND. EMPTY(ALLTRIM(SCR->CR_USERLIB)) u__CValAlc( SC7->C7_USER, SAL->AL_AUTOLIM )  
				if u__CValAlc( _cUsuApr, _cAutoLim )      
    				Aadd(_aAProv,{SCR->CR_USER,UsrRetMail(SCR->CR_USER)})
				Endif
			ENDIF
				
			dbSelectArea("SCR")
			dbSkip()
		ENDDO
		
		IF LEN(_aAprov) > 0
			For _nI := 1 To 1 //Len(_aAprov)
				U_WFPC()
			Next _nI
		ELSE 
			U_AWFPC()
		ENDIF
		
	EndIf
	
EndIf

cFilAnt := _cFilAt

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function BlqPed()
////////////////////////

Local _cInsSql := _cSql
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
	
	If TMP->TIPODOC == "PCA"
		AprovaPA(TMP->EMISSAO,TMP->CGC,2,_cInsSql)
	Else
		
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
		
	EndIf
	
	DbSelectArea("TMP")
	DbGoTo( TMP->( Recno() ) )
	TMP->( DbDelete() )
	
	TMP->( DbSkip() )
	
EndDo

DbSelectArea("TMP")
TMP->( DbGoTop() )

oMark:oBrowse:Refresh()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Bloqueia(_cFilial,_cNumPed,_cUser,_cObsA)
/////////////////////////////////////////////////////////

Local _cRespS	:= Space(6)
Local _cEmail	:= ""
Local _cHtm		:= ""

DbSelectArea("SCR")
SCR->( DbSetOrder(2) )
If SCR->( DbSeek( Substr(_cFilial,1,2)+"PC"+_cNumPed+Space(44)+iif(empty(_cUser),SCR->CR_USER,_cUser) ) )
	
	RecLock("SCR",.F.)
	SCR->CR_DATALIB	:= dDataBase
	SCR->CR_STATUS	:= "04"
	SCR->CR_USERLIB := iif(empty(_cUser),SCR->CR_USER,_cUser)
	SCR->CR_LIBAPRO := SCR->CR_LIBAPRO
	SCR->CR_OBS 	:= _cObsA
	SCR->( MsUnLock() )
	
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

//Fornecedor
_cHtm+=" <TABLE width=480 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
_cHtm+="     <TR>"
_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>Fornecedor</b></font>"
_cHtm+="         </TD>"
_cHtm+="     </TR>"
_cHtm+="     <TR>"
_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+SC7->C7_FORNECE+"-"+SC7->C7_LOJA+" - "+Substr(cFornece,1,30)+"</b></font>"
_cHtm+="         </TD>"
_cHtm+="     </TR>"
_cHtm+=" </TABLE>"
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

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AprovaPA(_dEmis,_cCgc,_nOpc,_cInSql)
////////////////////////////////////////////////////

Local _cNome		:= Space(40)
Local aCpo			:= {}
Local aCamp			:= {}
Local aButtons 		:= {{"S4WB011N"	,{||U_COMP012(TMPB->FILIAL,TMPB->PEDIDO)},"Detalhe PC" }}
Local oOk   	    := LoadBitmap( GetResources(), "LBOK")
Local oNo       	:= LoadBitmap( GetResources(), "LBNO")
Private aPedCom		:= {}
Private cCadastro	:= IIf(_nOpc == 1,"Aprovacao Pedido de Compra - Aglutinados","Bloqieio Pedido de Compra - Aglutinados")
Private oDlgPA
Private lInv		:= .F.
Private oChkInvPed
Private lInvPed		:= .F.
Private oLstPed

cQuery := " SELECT CR_FILIAL, C7_NUM, E4_DESCRI, A2_NOME, C7_USER, CR_TOTAL, CR_STATUS, C7_EMISSAO, SUM(C7_TOTAL) AS 'TOTAL' "
cQuery += " FROM "+RetSqlName("SCR")+" SCR 	(NOLOCK) "

cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 (NOLOCK) "
cQuery += " 		ON CR_FILIAL 	= C7_FILIAL AND RTRIM(CR_NUM) = C7_NUM AND SC7.D_E_L_E_T_ = '' "

cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 (NOLOCK) "
cQuery += " 		ON A2_COD 		= C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = '' "

cQuery += " INNER JOIN "+RetSqlName("SE4")+" SE4 (NOLOCK) "
cQuery += " 		ON C7_COND 		= E4_CODIGO AND SE4.D_E_L_E_T_ = '' "

cQuery += " WHERE "
cQuery += " 		CR_USER 		= '" + TMP->CODUSU + "' AND "
cQuery += " SUBSTRING(A2_CGC,1,8)	= '"+_cCgc+"' AND "
cQuery += _cInSql
cQuery += " SCR.D_E_L_E_T_ = '' "

cQuery += " GROUP BY CR_FILIAL, C7_NUM, E4_DESCRI, A2_NOME, C7_USER, CR_TOTAL, CR_STATUS, C7_EMISSAO "
cQuery += " ORDER BY CR_FILIAL, C7_EMISSAO "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMPC", .F., .T.)

Do While TMPC->( !Eof() )
	
	_cNome := TMPC->A2_NOME
	
	Aadd( aPedCom,{ .F.,TMPC->CR_FILIAL,Alltrim(TMPC->A2_NOME),TMPC->C7_NUM,;
	Substr(TMPC->C7_EMISSAO,7,2)+"/"+Substr(TMPC->C7_EMISSAO,5,2)+"/"+Substr(TMPC->C7_EMISSAO,1,4),;
	TMPC->E4_DESCRI,Transform(TMPC->CR_TOTAL,"@E 999,999,999.99"),;
	Posicione("SC7",1,TMPC->CR_FILIAL+TMPC->C7_NUM,"C7_OBS"),Alltrim(UsrFullName(TMPC->C7_USER)),TMPC->CR_STATUS })
	
	TMPC->( DbSkip() )
	
EndDo

DbCloseArea()

DEFINE MSDIALOG oDlgPA TITLE cCadastro FROM 10,10 TO 500,1000 PIXEL

@ 015,005 SAY "Fornecedor:" PIXEL
@ 015,045 MSGET oFor VAR _cNome WHEN .F. PIXEL

@ 25,005 CHECKBOX oChkInvPed VAR lInvPed PROMPT "Inverter Selecao" SIZE 50, 10 OF oDlgPA PIXEL ON CLICK (AEval(aPedCom, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oLstPed:Refresh(.F.)) //"Inverter Selecao"
@ 40,001 LISTBOX oLstPed VAR cVarGrp Fields HEADER "","Filial","Nome","Pedido","Emissao","Cond.Pagto","Total","Obs","Comprador","Status"  SIZE 500,200 ON DBLCLICK (aPedCom:=LSVTroca(oLstPed:nAt,aPedCom),oLstPed:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstPed,oOk,oNo,@aPedCom) OF oDlgPA PIXEL	//"Grupos de Material"
oLstPed:SetArray(aPedCom)
oLstPed:bLine := { || { If(aPedCom[oLstPed:nAt,1],oOk,oNo),aPedCom[oLstPed:nAt,2],aPedCom[oLstPed:nAt,3],aPedCom[oLstPed:nAt,4],aPedCom[oLstPed:nAt,5],aPedCom[oLstPed:nAt,6],aPedCom[oLstPed:nAt,7],aPedCom[oLstPed:nAt,8],aPedCom[oLstPed:nAt,9],aPedCom[oLstPed:nAt,10] }}

ACTIVATE MSDIALOG oDlgPA CENTERED ON INIT EnchoiceBar( oDlgPA, { || LibPedA(_nOpc),oDlgPA:End() }, { ||  oDlgPA:End() },, aButtons )

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LibPedA(_nOpca)
///////////////////////////////

For _nY := 1 To Len(aPedCom)
	
	MsAguarde({|lEnd| },"Aguarde...","Liberando Pedidos: "+aPedCom[_nY,2]+aPedCom[_nY,4])
	Aprova(aPedCom[_nY,2],aPedCom[_nY,4],TMP->CODUSU," ")
	
Next _nY

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function BlqPedA()
/////////////////////////

_cObs	:= CriaVar("CR_OBS")

DbSelectArea("TMPB")
TMPB->( DbGoTop() )
While TMPB->( !Eof() )
	
	If !TMPB->(Marked("OK"))
		DbSelectArea("TMPB")
		TMPB->( DbSkip() )
		Loop
	EndIf
	
	If TMPB->STATUSP <> "02"
		DbSelectArea("TMPB")
		TMPB->( DbSkip() )
		Loop
	EndIf
	
	
	DEFINE MSDIALOG oDlgB TITLE "Bloqueio Pedido de Compra" FROM 000,000 TO 240,700 OF oMainWnd PIXEL
	
	@ 020,010 SAY "Pedido" PIXEL
	@ 020,040 MSGET oPed VAR TMPB->PEDIDO WHEN .F. PIXEL
	
	@ 020,100 SAY "Comprador" PIXEL
	@ 020,140 MSGET oComp VAR Alltrim(TMPB->COMPRADOR) WHEN .F. PIXEL
	
	@ 040,010 SAY "Emissao" PIXEL
	@ 040,040 MSGET oEmi VAR TMPB->EMISSAO WHEN .F. PIXEL
	
	@ 040,100 SAY "Fornecedor" PIXEL
	@ 040,140 MSGET oForn VAR TMPB->NOME WHEN .F. PIXEL
	
	@ 070,010 SAY "Observacao" PIXEL
	@ 080,010 MSGET oObs VAR _cObs  PICTURE "@!" PIXEL
	
	ACTIVATE MSDIALOG oDlgB CENTERED ON INIT EnchoiceBar( oDlgB, { || oDlgB:End() }, { ||  oDlgB:End() } )
	
	MsAguarde({|lEnd| },"Aguarde...","Liberando Pedidos: "+TMPB->FILIAL+TMPB->PEDIDO,.T.)
	
	Bloqueia(TMPB->FILIAL,TMPB->PEDIDO,_cUser,_cObs)
	
	DbSelectArea("TMPB")
	DbGoTo( TMPB->( Recno() ) )
	TMPB->( DbDelete() )
	
	TMPB->( DbSkip() )
	
EndDo

DbSelectArea("TMPB")
TMPB->( DbGoTop() )

oMarkPA:oBrowse:Refresh()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Marca2(cMarca,lInverte,oQtda)
/////////////////////////////////////////////

If IsMark("OK",cMarca,lInverte)
	nQtd ++
Else
	nQtd --
	nQtd := IIf(nQtd<0,0,nQtd)
Endif

oQtda:Refresh()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LSVTroca(nIt,aArray)
////////////////////////////////////
aArray[nIt,1] := !aArray[nIt,1]
Return aArray

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS_RetAprov()
/////////////////////////////
Local _cRet := '      '

Define MsDialog _oDlg2 Title "Aprovador"  From 000,000 to 100,200 of oMainWnd Pixel
@ 010,010 say 'Aprovador:' 						 	Size 040,010  Pixel of _oDlg2
@ 010,050 Msget _cRet F3 'SAK'     					Size 050,010  Pixel of _oDlg2
@ 030,010 BmpButton Type 1 Action (_oDlg2:End())
Activate MsDialog _oDlg2 Centered

Return _cRet
