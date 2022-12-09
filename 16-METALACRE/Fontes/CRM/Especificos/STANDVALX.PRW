#include 'Protheus.ch'        
#include 'MsgOpManual.ch'
#Include  "Tbiconn.ch"
#include  "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³StandyVal ºAutor  ³Bruno Daniel Abrigo º Data ³  27/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria pop para localização da OP de origem do "stand by"     º±±
±±º          ³e digitação de lacre inicial                                º±±
±±º          ³Uma vez preenchido o pop up serão carregas informações de OPº±±
±±º          ³Item da OP,lacre inicial e lacre final(Inicial+Qtd Pedido-1)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ Ajustado por Mateus Hengle em 26/01/14 para o Televendas   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function StandValX()                                                        

Local nComboBox1 	:= 1
Local nListBox1 	:= 1
Local cQry  		:= ""
Local oFont1 		:= TFont():New("Calibri",,019,,.F.,,,,,.F.,.F.)
Local oFont2 		:= TFont():New("Calibri",,18,,.T.,,,,,.F.,.F.)
Local nPosLacre     := AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XLACRE" })
Local nPosQtd   	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_QUANT" })
Local nPosItem  	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_ITEM"   })
Local nPosProd  	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO"})
Local nPosNumOP  	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_NUMOP"})
Local nPosItemOP 	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_ITEMOP"})
Local nPosxStand 	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XSTAND"})
Local nPosnLacreIni	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XINIC"})
Local nPos_nLacFim	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XFIM"})
Local nPosRecalc	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_RECALC"}) 
Local nPosEmb    	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XEMBALA"})
Local nPosAlm    	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_LOCAL"})
Local cFiltroSQL	:= ''
Local _lRet			:=.T.

Private    oLbx    := Nil
Private    bLbx    := {}
Private    aLbx    := {'Del',"Item","Produto",'Personal.','Pedido','OP+Item PV+001','Lacre Inicial','Lacre Final'}	
Private aPedido := {{'','','','','','','',''}}
Private aDados		:= {}
Private oDlg1, oButton1 , oButton2, oButton3, oSay1,oSay2,oGet1,oGet2,oGet3,oListBox1
Private nGet1 		:= 0
Private nGet2 		:= 0
Private nGet3 		:= 0
Private	lEmpPrev		:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)

If M->UA_OPER == '1' 	// Pedido
	If !Empty(aCols[n][nPos_nLacFim])
		Alert("Atenção Não é Permitido a Alteração deste Item para Stand By Favor Deleta-lo e Incluir um Novo !")
		Return .f.
	Endif
Endif

If &(ReadVar()) == "1"

   // alteracao para verificar o campo embalagem.
   IF EMPTY(aCols[n][nPosEMB])
   		MSGALERT("PREENCHA O CAMPO DA EMBALAGEM.")
   		RETURN .F.
   ENDIF
   
	If Select("TRBB") <> 0
		TRBB->(dbCloseArea())
	Endif	
	
	cQry:= " SELECT C2_XLACRE,C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,C2_LOCAL,C2_QUANT,C2_EMISSAO,C2_XLACINI,C2_XLACFIN,SC2.R_E_C_N_O_ 'RECNOSC2' FROM "+RETSQLNAME("SC2")+" SC2"+CRLF
	cQry+= "  WHERE C2_SEQUEN = '001' AND SC2.D_E_L_E_T_ <> '*' AND C2_XLACRE <> '' AND C2_XLACRE = '"+aCols[n][nPosLacre]+"' AND C2_PRODUTO = '"+Alltrim(aCols[n][nPosProd])+"' AND C2_XOP = '2' "+CRLF
	cQry+= " ORDER BY C2_NUM"
	
	If Select("TRBB") > 0
		TRBB->(dbCloseArea())
	EndIf
	
	TCQUERY cQry New Alias "TRBB"
	
	dbSelectArea("TRBB")
	TRBB->(dbGotop())
	If !TRBB->(Eof())
		
		While !TRBB->(Eof())
			
			// Busca Saldo do Lote
			
			nSaldo:=0
			If SB8->(dbSetOrder(3), dbSeek(xFilial("SB8")+aCols[n][nPosProd]+aCols[n][nPosAlm]+TRBB->C2_NUM+TRBB->C2_ITEM))
				While SB8->(!EOF()) .And. AllTrim(xFilial("SB8")+aCols[n][nPosProd]+aCols[n][nPosAlm]+TRBB->C2_NUM+TRBB->C2_ITEM)==AllTrim(SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL))
					nSaldo+=SB8SALDO(,,,,,lEmpPrev,,,.T.)
			
					SB8->(dbSkip(1))
				End
			Endif
			
			If Empty(nSaldo)
				TRBB->(dbSkip(1));Loop
			Endif

			nSaldo -= U_BscPed(TRBB->C2_NUM,TRBB->C2_XLACRE)
			
			If Empty(nSaldo)
				TRBB->(dbSkip(1));Loop
			Endif

			// add registros encontrados no array
			aAdd(aDados,{;
							TRBB->C2_XLACRE,;
							TRBB->C2_NUM,;
							TRBB->C2_ITEM,;
							TRBB->C2_SEQUEN,;
							Alltrim(TRBB->C2_PRODUTO),;
							TRBB->C2_LOCAL,;
							cValtochar(TRBB->C2_QUANT),;
							C2_XLACINI,;
							C2_XLACFIN,;
							STOD(TRBB->C2_EMISSAO),;
							TRBB->RECNOSC2 ,;
							nSaldo })
			
			TRBB->(dbSkip())
		Enddo
		
		If Empty(Len(aDados))
			Msgstop("Não Foram Localizados Lotes com Saldo !")
			Return .f.
		Endif

		DEFINE MSDIALOG oDlg1 TITLE STR0012 FROM 000, 000  TO 570, 500  COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
		
		oDlg1:lEscClose := .F.
		@ 007, 008 SAY oSay1 PROMPT STR0013  SIZE 112, 011 Font oFont2 OF oDlg1 COLORS 0, 16777215 PIXEL
		@ 020, 006 MSGET @oGet1 VAR nGet1 PICTURE "999999999" Font oFont2 WHEN .F. SIZE 50, 016 OF oDlg1 COLORS 0, 16777215 PIXEL
		@ 007, 72 SAY oSay2 PROMPT STR0014  SIZE 103, 010 Font oFont2 OF oDlg1 COLORS 0, 16777215 PIXEL
		@ 020, 71 MSGET @oGet2 VAR nGet2 PICTURE "999999999" Font oFont2 WHEN .F. SIZE 50, 015 OF oDlg1 COLORS 0, 16777215 PIXEL
		@ 007, 132 SAY oSay2 PROMPT 'Saldo Lote'  SIZE 103, 010 Font oFont2 OF oDlg1 COLORS 0, 16777215 PIXEL
		@ 020, 131 MSGET @oGet3 VAR nGet3 PICTURE "999999999" Font oFont2 WHEN .F. SIZE 50, 015 OF oDlg1 COLORS 0, 16777215 PIXEL

		@ 040, 005 LISTBOX oListBox1 VAR nListBox1 FIELDS HEADER ;
									"Lacre",;
									"Numero",;
									"Item",;
									"Sequen",;
									"Produto",;
									"Local",;
									"Qtd",;
									"Lacre Ini.",;
									"Lacre Fin.",;
									"Emissao",;
									"Saldo";
		SIZE 238, 117 OF @oDlg1 COLORS 0, 16777215 FONT oFont1 PIXEL;
		ON CHANGE(IPed(oListBox1:nAt));
		ON dblClick(iif(Msgyesno(STR0011),AtivaOP(aDados[oListBox1:nAt,11]),.T.))
		          
		//
		//seta informacoes do Array no ListBox
		oListBox1:SetArray(@aDados)
		
		// ExecBloc dos registro do array                                v
		oListBox1:bLine := {|| {;
									aDados[oListBox1:nAt,1],;
									aDados[oListBox1:nAt,2],;
									aDados[oListBox1:nAt,3],;
									aDados[oListBox1:nAt,4],;
									aDados[oListBox1:nAt,5],;
									aDados[oListBox1:nAt,6],;
									aDados[oListBox1:nAt,7],;
									aDados[oListBox1:nAt,8],;
									aDados[oListBox1:nAt,9],;
									aDados[oListBox1:nAt,10],;
									aDados[oListBox1:nAt,12]}}
		
		// LISTBOX ROTAS
	
		@ 200,005  LISTBOX oLbx FIELDS HEADER "" SIZE 238,070  OF oDlg1 PIXEL
		oLbx:aColumns  := aLbx
		oLbx:aHeaders  := oLbx:aColumns
		
		oLbx:SetArray(aPedido)
		oLbx:bLine:= {|| {  aPedido[oLbx:nAt,1],;
							aPedido[oLbx:nAt,2],;
							aPedido[oLbx:nAt,3],;
							aPedido[oLbx:nAt,4],;
							aPedido[oLbx:nAt,5],;
							aPedido[oLbx:nAt,6],;
							aPedido[oLbx:nAt,7],;
							aPedido[oLbx:nAt,8]}}
				
//		oLbx:bChange := {||U_Bairro()}

		@ 167, 005 BUTTON oButton2 PROMPT "Ok" SIZE 028, 013 OF oDlg1 PIXEL;
		Action(Iif(TRetorno(),oDlg1:End(),.f.))
		
		/*
		Action(iif(Msgyesno(STR0015),( _lRet:=.T.,aCols[n,nPosNumOP]:=aDados[oListBox1:nAt,2],;
		aCols[n,nPosItemOP]:=aDados[oListBox1:nAt,3],;
		aCols[n,nPosnLacreIni]:=aDados[oListBox1:nAt,8],;
		aCols[n,nPos_nLacFim]:=aDados[oListBox1:nAt,9],;
		aCols[n,nPosRecalc]:="2" ,oDlg:End()),.F.);
		) */
		
		
		
		@ 167, 035 BUTTON oButton3 PROMPT "Cancelar" SIZE 028, 013 OF oDlg1 PIXEL;
		Action( _lRet:=.F., oDlg1:End() )
		
		ACTIVATE MSDIALOG oDlg1 CENTERED
		
	Else
		TRBB->(dbCloseArea())
		Msgstop(STR0006)
		_lRet:=.F.
		Return(_lRet)
	Endif
	
	TRBB->(dbCloseArea())
Endif

Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STANDYVAL ºAutor  ³Microsiga           º Data ³  05/15/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AtivaOP(xRecno)
DbselectArea("SC2")
SC2->(dbGoto(xRecno))

A650View("SC2",SC2->(Recno()),2)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Iped() ºAutor  ³Luiz Alberto º Data ³  15/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona outro listbox no pop up para mostrar     º±±
±±º          ³os pedidos já faturados da OP e tratar Lacre Inicial e Finalº±±
±±º          ³mais saldo do Lote do Produtoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function iPed(nPos)
Local aArea := GetArea()
Local nPosQtd   	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_QUANT" })
Local nPosPrd   	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO" })
Local nPosLot   	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_LOTECTL" })
Local nPosAlm   	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_LOCAL" })
Local lEmpPrev		:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)

// Busca Saldo do Lote

If SB8->(dbSetOrder(3), dbSeek(xFilial("SB8")+aCols[n,nPosPrd]+aCols[n,nPosAlm]+aDados[nPos,2]+aDados[nPos,3]))
	nSaldo:=0
	While SB8->(!EOF()) .And. AllTrim(xFilial("SB8")+aCols[n,nPosPrd]+aCols[n,nPosAlm]+aDados[nPos,2]+aDados[nPos,3])==AllTrim(SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL))
		nSaldo+=SB8SALDO(,,,,,lEmpPrev,,,.T.)

		SB8->(dbSkip(1))
	End
	nSaldo -= U_BscPed(aDados[nPos,2])
	nGet3 := nSaldo
Else
	nGet3 := 0
Endif

If Select("CAD") > 0
	CAD->(DbCloseArea())
Endif     

// Captura o Numero do Pedido de Venda no Registro OP

cQuery := ""
cQuery += " SELECT D_E_L_E_T_ DELETADO, * "
cQuery += " FROM " + RETSQLNAME("SC6") + " C6 (NOLOCK) "
cQuery += " WHERE "		// C6.D_E_L_E_T_ = ' ' 
cQuery += " C6.C6_NUMOP = '" + aDados[nPos,2] + "' "
cQuery += " ORDER BY C6.C6_XFIM  "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)

COUNT TO _nCount
ProcRegua(_nCount)
CAD->(dbGoTop())
aPedido := {{'','','','','','','',''}}
oLbx:SetArray(aPedido)
oLbx:bLine:= {|| {aPedido[oLbx:nAt,1],;
				aPedido[oLbx:nAt,2],;
				aPedido[oLbx:nAt,3],;
				aPedido[oLbx:nAt,4],;
				aPedido[oLbx:nAt,5],;
				aPedido[oLbx:nAt,6],;
				aPedido[oLbx:nAt,7],;
				aPedido[oLbx:nAt,8]}}
oLbx:Refresh()
oDlg1:Refresh()  
oLbx:nAt := 1

If Empty(_nCount) 
	//aLbx    := {'',"Item","Produto",'Personal.','Pedido','OP+Item PV+001','Lacre Inicial','Lacre Final'}	
	nGet1 := aDados[nPos,8]	// Pega o Lacre Final
	nGet2 := aDados[nPos,9] 
	
	If !Empty(aCols[n,nPosQtd])
		nGet2:=(nGet1 + aCols[n,nPosQtd])-1			// nÃO PERMITIR QUANTIDADE MAIOR QUE O SALDO DA OP - 27-06-2014
	Endif

	oGet1:Refresh()
	oGet2:Refresh()
	oGet3:Refresh()
	oDlg1:Refresh()  
	oLbx:nAt := 1
    CAD->(dbCloseArea())
	Return .t.                        
ElseIf !Empty(_nCount) .And. !Empty(CAD->DELETADO)
	nGet1 := aDados[nPos,8]+(Val(aDados[nPos,7])-aDados[nPos,12])	// Inicio + (Qtd a Produzir - Saldo a Produzir) 
	nGet2 := aDados[nPos,9] 
	
	If !Empty(aCols[n,nPosQtd])
		nGet2:=(nGet1 + aCols[n,nPosQtd])-1   // Inicio + (Qtd Produzir - Saldo) + Qtde Linha do Atendimento
	Endif

	oGet1:Refresh()
	oGet2:Refresh()
	oGet3:Refresh()
	oDlg1:Refresh()  
	oLbx:nAt := 1
	aPedido := {}
Else
	aPedido := {}
Endif

Dbselectarea("CAD")
dbGoTop()
While CAD->(!Eof())                                
	IncProc()

	AaDd(aPedido,{Iif(!Empty(CAD->DELETADO),'X',''),CAD->C6_ITEM,CAD->C6_PRODUTO, CAD->C6_XLACRE, CAD->C6_NUM, CAD->C6_NUMOP+CAD->C6_ITEMOP+'001', CAD->C6_XINIC, CAD->C6_XFIM})

//	AaDd(aPedido,{Iif(!Empty(CAD->DELETADO),'X',''),CAD->UB_ITEMPV,CAD->UB_PRODUTO, CAD->UB_XLACRE, CAD->UB_NUMPV	, CAD->UB_NUMOP+CAD->UB_ITEMOP+'001', CAD->UB_XINIC, CAD->UB_XFIM})
	
	CAD->(DbSkip())
EndDo
CAD->(dbCloseArea())

oLbx:SetArray(aPedido)
oLbx:bLine:= {|| {aPedido[oLbx:nAt,1],;
				aPedido[oLbx:nAt,2],;
				aPedido[oLbx:nAt,3],;
				aPedido[oLbx:nAt,4],;
				aPedido[oLbx:nAt,5],;
				aPedido[oLbx:nAt,6],;
				aPedido[oLbx:nAt,7],;
				aPedido[oLbx:nAt,8]}}
oLbx:Refresh()
If !Empty(aPedido[Len(aPedido),7]) .And. Empty(aPedido[Len(aPedido),1])
	For nI := 1 To Len(aPedido)
		If aPedido[nI,1] <> 'X'
			nGet1 := aPedido[nI,8]	+ 1 // Pega o Lacre Final
		Endif
	Next

	nGet2:=aDados[nPos,9]
	
	If !Empty(aCols[n,nPosQtd])
		nGet2:=(nGet1 + aCols[n,nPosQtd])-1
	Endif
Endif    
oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()
oDlg1:Refresh()
RestArea(aArea)        
oLbx:nAt := 1
Return .t. 

/*
		@ 167, 005 BUTTON oButton2 PROMPT "Ok" SIZE 028, 013 OF oDlg1 PIXEL;
		Action(iif(Msgyesno(STR0015),( _lRet:=.T.,aCols[n,nPosNumOP]:=aDados[oListBox1:nAt,2],;
		aCols[n,nPosItemOP]:=aDados[oListBox1:nAt,3],;
		aCols[n,nPosnLacreIni]:= aDados[oListBox1:nAt,8],;//nGet1,;
		nGet2:= aDados[oListBox1:nAt,8]	 + (aCols[n,nPosQtd])-1,;
		aCols[n,nPos_nLacFim]:= nGet2,;  
		aCols[n,nPosRecalc]:="2" ,oDlg1:End()),.F.);

          */


Static Function TRetorno()
Local nPosLacre     := AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XLACRE" })
Local nPosQtd   	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_QUANT" })
Local nPosItem  	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_ITEM"   })
Local nPosProd  	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO"})
Local nPosNumOP  	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_NUMOP"})
Local nPosItemOP 	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_ITEMOP"})
Local nPosxStand 	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XSTAND"})
Local nPosnLacreIni	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XINIC"})
Local nPos_nLacFim	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XFIM"})
Local nPosRecalc	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_RECALC"}) 
Local nPosEmb    	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_XEMBALA"})
Local nPosAlm    	:= AScan(aHeader,{|x| AllTrim(x[2]) == "UB_LOCAL"})
Local lRet := .F.

nSaldo:=0
If SB8->(dbSetOrder(3), dbSeek(xFilial("SB8")+aCols[n,nPosProd]+aCols[n,nPosAlm]+aDados[oListBox1:nAt,2]+aDados[oListBox1:nAt,3]))
	While SB8->(!EOF()) .And. AllTrim(xFilial("SB8")+aCols[n,nPosProd]+aCols[n,nPosAlm]+aDados[oListBox1:nAt,2]+aDados[oListBox1:nAt,3])==AllTrim(SB8->(B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL))
		nSaldo+=SB8SALDO(,,,,,lEmpPrev,,,.T.)

		SB8->(dbSkip(1))
	End
Endif
nSaldo -= U_BscPed(aDados[oListBox1:nAt,2])

If aCols[n,nPosQtd] > nSaldo
	MsgStop("Atenção a Quantidade de Venda não pode ser Superior ao Saldo da OP, Distribua caso seja necessário !")
	Return lRet
Endif

If Msgyesno(STR0015)
	lRet := .t.
	aCols[n,nPosNumOP]:=aDados[oListBox1:nAt,2]
	aCols[n,nPosItemOP]:=aDados[oListBox1:nAt,3]
	aCols[n,nPosnLacreIni]:= nGet1
	aCols[n,nPos_nLacFim]:= nGet2  
	aCols[n,nPosRecalc]:="2" 
Endif		
Return lRet


User Function BscPed(cNumOp,cPersona)
Local aArea := GetArea()

cQuery := ""
cQuery += " SELECT SUM(ISNULL(C6_QTDVEN,0)) QTDPED "
cQuery += " FROM " + RETSQLNAME("SC6") + " C6 (NOLOCK) "
cQuery += " WHERE C6.D_E_L_E_T_ = ' ' "
cQuery += " AND C6.C6_DATFAT = '' "
cQuery += " AND C6.C6_NUMOP = '" + cNumOp + "' "
If !Empty(cPersona)
	cQuery += " AND C6.C6_XLACRE = '" + cPersona + "' "
Endif

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"KAD",.T.,.T.)

nQtdPed := KAD->QTDPED

KAD->(dbCloseArea())

RestArea(aArea)
Return nQtdPed
