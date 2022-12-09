#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFINV02 บAutor  ณLoop Consultoria     บ Data ณ  18/04/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava o Flag para remover os Tํtulos do Serasa Relato       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verquimica                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFINV02()

Private cPerg := PADR("RFINV02",Len(SX1->X1_GRUPO))

CriaSx1(cPerg)

If Pergunte(cPerg,.T.)
	MsgRun("Verificando Tํtulos Enviados...","Serasa Relato",{||U_RFIN02A()})
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRIASX1   บAutor  ณLoop Consultoria    บ Data ณ  30/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se existe o grupo de perguntas, caso nao exista    บฑฑ
ฑฑบ          ณa funcao ira cria-lo.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGENERICO                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1(cPerg)

Local aAreaAtu := GetArea()
Local aRegs    := {}

dbSelectArea("SX1")
dbSetOrder(1)

AADD(aRegs,{cPerg,"01","Emissใo de ?                  "," "," ","mv_ch1","D",08,0,0,"G","","mv_par01",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Emissใo At้ ?                 "," "," ","mv_ch2","D",08,0,0,"G","","mv_par02",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Prefixo de ?                  "," "," ","mv_ch3","C",03,0,0,"G","","mv_par03",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Prefixo At้ ?                 "," "," ","mv_ch4","C",03,0,0,"G","","mv_par04",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Tํtulo de ?                   "," "," ","mv_ch5","C",09,0,0,"G","","mv_par05",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Tํtulo At้ ?                  "," "," ","mv_ch6","C",09,0,0,"G","","mv_par06",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Parcela de ?                  "," "," ","mv_ch7","C",02,0,0,"G","","mv_par07",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Parcela At้ ?                 "," "," ","mv_ch8","C",02,0,0,"G","","mv_par08",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Cliente de ?                  "," "," ","mv_ch9","C",06,0,0,"C","","mv_par09",""		        ,"","","","",""	        ,"","","","",""	        ,"","","","",""		                ,"","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"10","Cliente At้ ?                 "," "," ","mv_cha","C",06,0,0,"G","","mv_par10",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"11","Loja de ?                     "," "," ","mv_chb","C",02,0,0,"G","","mv_par11",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Loja At้ ?                    "," "," ","mv_chc","C",02,0,0,"G","","mv_par12",""				,"","","","",""			,"","","","",""			,"","","","",""						,"","","","","","","","",""})


For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Restarea(aAreaAtu)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN02A   บAutor  ณLoop Consultoria    บ Data ณ  24/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verquimica                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFIN02A

Local aArea    	:= GetArea()
Local aAreaSX2 	:= SX2->(GetArea())

Local cAlias	:= "SE1"
Local cRet     	:= ""
Local cFiltSX2 	:= ''
Local cQuery	:= ""
Local cPesq    	:= Space(20)

Local nL		:= 0
Local nMakeDir	:= 0
Local nPosLbx  	:= 0
Local nPosArq  	:= 0

Local lOk      	:= .T.
Local _lOk		:= .T.

Local bFiltSX2 	:= NIL

Local oOk     	:= LoadBitmap( GetResources(), "LBOK" )
Local oNo     	:= LoadBitmap( GetResources(), "LBNO" )
Local _oOk     	:= LoadBitmap( GetResources(), "BR_VERDE" )
Local _oNo     	:= LoadBitmap( GetResources(), "BR_VERMELHO" )
Local oChk    	:= Nil

Private aTitSer	:= {}

Private cEstCob	:= ""
Private cDtaPro	:= DtoC(dDataBase)
Private cCusuar	:= Alltrim(Capital(cUserName))

Private lChk  	:= .F.

Private oDlg, oLbx, oPesq, oValSel, oQtdSel, oValExt, oDtaPro, oCusuar, oTipOpe
Private oChk  	:= Nil

Private nValSel	:= 0
Private nValExt	:= 0
Private nQtdSel	:= 0

cQuery += " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_BAIXA, E1_VALOR, E1_SALDO "
cQuery += " FROM "+RetSqlName("SE1")+ " SE1 "
cQuery += " WHERE E1_FILIAL ='"+xFilial("SE1")+"' "
cQuery += " AND E1_PREFIXO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND E1_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND E1_PARCELA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += " AND E1_CLIENTE BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += " AND E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
cQuery += " AND E1_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQuery += " AND E1_XRELATO = '1' "
cQuery += " AND E1_XSOLEXL <> '1' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_EMISSAO, E1_NUM, E1_PARCELA "


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณGarante que a area QRY nao esta em uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Select( "QRY" ) > 0
	QRY->( dbCloseArea() )
EndIf

MemoWrite("MAFINP03.sql",cQuery)
dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .F. )

QRY->( dbGoTop() )
Do While !QRY->(Eof())

	lNotSer := .T.
	_lOk	:= .T.
	
	If lNotSer
		aAdd( aTitSer, {Empty(QRY->E1_BAIXA),,QRY->E1_FILIAL, QRY->E1_PREFIXO, QRY->E1_NUM, QRY->E1_PARCELA, QRY->E1_TIPO, QRY->E1_CLIENTE,;
		QRY->E1_LOJA, QRY->E1_NOMCLI, StoD(QRY->E1_EMISSAO), StoD(QRY->E1_VENCTO), StoD(QRY->E1_VENCREA), StoD(QRY->E1_BAIXA), QRY->E1_VALOR} )
	EndIf
	
	//nValExt:=nValExt+QRY->E1_VALOR
	//nValSel:=nValSel+QRY->E1_VALOR
	//nQtdSel++

	QRY->(dbSkip())
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha a area QRY ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

QRY->(dbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGarante que exista titulos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Len( aTitSer ) == 0
	ApMsgInfo("Nใo existe Tํtulos para remover Flag de envio Serasa Relato.", "Aten็ใo - RFINV02")
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณOrdena array aTitSer (FILIAL+CLIENTE+LOJA)     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

ASort( aTitSer, , , { |x,y| y[3]+y[8]+y[9] > x[3]+x[8]+x[9] } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica posicoes de pesquisa no array aTitSer   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nPosArq := IIf( !Empty( cRet ), aScan( aTitSer, { |z| AllTrim( cRet ) $ z[4] .Or. AllTrim( cRet ) $ z[9] } ), 1 )
nPosLbx := nPosArq

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao da dialog de selecao do arquivo a exportar           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Define MSDialog oDlg Title "Serasa Relato - Tํtulos Enviados" From C(186),C(202) To C(665),C(943) Pixel //STYLE nOR(WS_VISIBLE,WS_POPUP)


@ C(013),C(215) TO C(039),C(308) LABEL " Tํtulos Selecionado  " PIXEL OF oDlg
@ C(013),C(308) TO C(039),C(370) LABEL " Usuแrio " PIXEL OF oDlg
@ C(040),C(006) TO C(215),C(370) LABEL " Tํtulos Selecionados " PIXEL OF oDlg

@ C(023),C(220) Say "Quant.:" Size C(042),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(023),C(237) Say oQtdSel Var StrZero(nQtdSel,4) Size C(025),C(008) COLOR CLR_HBLUE PIXEL OF oDlg
@ C(023),C(250) Say "no Valor de :" Size C(044),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@ C(023),C(280) Say oValSel Var Alltrim(Transform(nValSel,'@E 999,999,999,999.99')) Size C(044),C(008) COLOR CLR_HBLUE PIXEL OF oDlg
@ C(023),C(320) Say oCusuar Var cCusuar Size C(040),C(008) COLOR CLR_HBLUE PIXEL OF oDlg

@ C(046),C(010) ListBox oLbx Fields Header "","","Filial", "Pref" , "Numero", "Parc", "Tipo",;
"Cliente", "Loja", "Razใo Social", "Emissใo", "Vencto", "Vencto Real", "Baixa", "Valor" ,;
Size C(357), C(168) Of oDlg Pixel On dblClick ( Inverter(oLbx:nAt),oLbx:Refresh(.F.) )

//oLbx:cToolTip := "Clientes pr้-selecionados para negativa็ใo"
oLbx:nAt      := nPosArq
oLbx:SetArray( aTitSer )
oLbx:bLine 	  := { || { Iif(aTitSer[oLbx:nAt,01],_oOk,_oNo),;
Iif(aTitSer[oLbx:nAt,02],oOk,oNo),;
aTitSer[oLbx:nAt, 03],;
aTitSer[oLbx:nAt, 04],;
aTitSer[oLbx:nAt, 05],;
aTitSer[oLbx:nAt, 06],;
aTitSer[oLbx:nAt, 07],;
aTitSer[oLbx:nAt, 08],;
aTitSer[oLbx:nAt, 09],;
aTitSer[oLbx:nAt, 10],;
aTitSer[oLbx:nAt, 11],;
aTitSer[oLbx:nAt, 12],;
aTitSer[oLbx:nAt, 13],;
aTitSer[oLbx:nAt, 14],;
aTitSer[oLbx:nAt, 15]}}

@ C(225),C(007) Say "Pesquisar " Size C(025), C(007) Of oDlg Pixel
@ C(223),C(035) MSGet oPesq  Var cPesq  Size C(100), C(010) Message "Pesquisa por Tํtulo ou Razใo Social" Of oDlg Pixel Picture "@!" ;
Valid ( nPosArq := Iif( !Empty( cPesq ), aScan( aTitSer, { |z| AllTrim( cPesq ) $ z[5] .Or. AllTrim( cPesq ) $ z[10]}), oLbx:nAt ),;
Iif( nPosArq <> 0, oLbx:nAt := nPosArq, ApMsgInfo("Numero do tํtulo ou Razใo Social nใo localizados.","Aten็ใo")),;
oLbx:Refresh(), Iif( nPosArq <> 0, nPosLbx := nPosArq, ), ( nPosArq <> 0 ) )

@ C(225),C(145) CheCkBox oChk Var lChk PROMPT "Marca/Desmarca" Size C(060),C(007) Message "Marca e Desmarca todos os registros" Pixel Of oDlg;
On CLICK(Iif(lChk,Marca(lChk),Marca(lChk)))

@ C(223),C(282) Button "&Gravar Flag"    Size C(038),C(012) Message "Grava Flag nos tํtulos" Pixel Of oDlg Action(RFINV02OK(),oDlg:End())
@ C(223),C(327) Button "&Sair"           Size C(037),C(012) Message "Sair" Pixel Of oDlg Action(oDlg:End())

Activate MSDialog oDlg Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MaFin3GerบAutor  ณAG Consulting       บ Data ณ  24/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Confirmacao para geracao do arquivo TXT.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Madis Solucoes e Acessos                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RFINV02OK()

If ApMsgYesNo("Confirma grava็ใo do Flag [E1_XSOLEXL] para remover os tํtulos do Serasa Relato ? ","Aten็ใo - RFINV02")
	MsgRun("Gravando Flag nos tํtulos...","Verquimica - Serasa Relato",{||RFINV02GV()})
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFINV02GV  ณLoop Consultoria          บ Data ณ  18/04/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava Flag                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verquimica                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RFINV02GV()

Local nCountR := 0
Local _nOpc	  := 1

For i:= 1 To Len(aTitSer)
	If aTitSer[i][2]
		nCountR++
	EndIf
Next i

If nCountR == 0
	If ApMsgStop("Nใo existem registros selecionado para envio de arquivo ao Serasa.","Aten็ใo!")
		Return
	EndIf
EndIf

If _nOpc == 1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza tabela SE1 (Conta a Receber) com FLAG de solicita็ใo       ณ
	//ณ para extorno do tํtulo no Serasa Relato                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nCountR > 0
		For i:= 1 To Len(aTitSer)
			
			If !aTitSer[i][2]
				Loop
			EndIf
			
			cQuery := "UPDATE " + RetSqlName( "SE1" ) +" SET "
			cQuery += "	E1_XSOLEXL = '1' "
			cQuery += "	WHERE D_E_L_E_T_ = ' '"
			cQuery += "	AND E1_PREFIXO = '"+aTitSer[i][4]+"'"
			cQuery += "	AND E1_NUM     = '"+aTitSer[i][5]+"'"
			cQuery += "	AND E1_PARCELA = '"+aTitSer[i][6]+"'"
			cQuery += "	AND E1_TIPO    = '"+aTitSer[i][7]+"'"
			cQuery += "	AND E1_CLIENTE = '"+aTitSer[i][8]+"'"
			cQuery += "	AND E1_LOJA    = '"+aTitSer[i][9]+"'"
			
			nRtUp := TcSqlExec(cQuery)
			
			If nRtUp <> 0
				ApMsgStop(cQuery,"Erro na opera็ใo de atualiza็ใo da SE1")
			EndIf
		Next
	EndIf
Else
	Return
EndIf

Return nil	


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Inverter บAutor  ณAG Consulting       บ Data ณ  24/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inverte selecao de marcacao de registros do listbox        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verquimica                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Inverter(nPos)

aTitSer[nPos][2] := !aTitSer[nPos][2]

If aTitSer[nPos][2]
	nValSel := nValSel + aTitSer[nPos][15]
	nValExt := nValExt + aTitSer[nPos][15]
	nQtdSel := nQtdSel + 1
Else
	nValSel := nValSel - aTitSer[nPos][15]
	nValExt := nValExt - aTitSer[nPos][15]
	nQtdSel := nQtdSel - 1
EndIf

oLbx:Refresh()
oValSel:Refresh()
//oValExt:Refresh()
oQtdSel:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Marca    บAutor  ณAG Consulting       บ Data ณ  07/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Controla marcacao do listbox                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verquimica                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Marca(lMarca)

Local i := 0
nValSel := 0
nValExt := 0
nQtdSel := 0

For i := 1 To Len(aTitSer)
	If lMarca
		nValSel := nValSel + aTitSer[i][15]
		nValExt := nValExt + aTitSer[i][15]
		nQtdSel := nQtdSel + 1
	Else
		nValSel := 0
		nValExt := 0
		nQtdSel := 0
	EndIf
	aTitSer[i][2] := lMarca
Next i

oLbx:Refresh()
oValSel:Refresh()
//oValExt:Refresh()
oQtdSel:Refresh()

Return