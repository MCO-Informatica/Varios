#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#Include "VKEY.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SelOpc   บAutor ณLuiz Albertoบ Data ณ  Maio/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela Selecao Opcionais         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                      บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SelOpc()
Local aArea := GetArea()
Local cCampo := ReadVar()
PRIVATE oRcp5
Private    oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private    oNo  	 := LoadBitmap(GetResources(),"LBNO")
Private  oSinalNo    := LoadBitmap(GetResources(),"BR_VERMELHO")
Private  oSinalOk    := LoadBitmap(GetResources(),"BR_VERDE")
Private aOpc := {}
Private oBotaoCnf
                                                    
lPedido := .f.
lCallCenter := .f.
lContrato := .f.    
lProdCli  := .F.
lOportuni1 := .f.
lOportuni2 := .f.

If Type("aHeader")=='U'
	aHeader := {}
Endif

If Type("l650Auto") == "U"
	l650Auto := .f.
Endif
If l650Auto
	Return ''
Endif

If aScan(aHeader,{|x| Alltrim(x[2])== "C6_OPC"}) > 0
	lPedido	:= .t.
	_cOpcio	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_OPC"})]
ElseIf aScan(aHeader,{|x| Alltrim(x[2])== "UB_OPC"}) > 0
	lCallCenter := .t.
	_cOpcio	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_OPC"})]
ElseIf aScan(aHeader,{|x| Alltrim(x[2])== "ADB_OPC"}) > 0
	lContrato := .t.
	_cOpcio	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_OPC"})]
ElseIf FunName() = "AXCADSA7" .Or. cCampo == 'M->A7_PRODUTO'
	lProdCli  := .t.
	_cOpcio	:=	M->A7_XOPC
ElseIf FunName() = "FATA300" .And. cCampo == 'M->AD1_CODPRO'
	lOportuni1 := .t.
	_cOpcio	:=	M->AD1_OPC
ElseIf FunName() = "FATA300" .And. aScan(aHeader,{|x| Alltrim(x[2])== "ADJ_PROD"}) > 0
	lOportuni2 := .t.
	_cOpcio	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADJ_OPC"})]
Else
	Return ''
Endif


// Insere um SetKey
SetKey(VK_F11, {|| U_CopyAcols() })		// Funcao para Replicar linha do Acols

cRetorno	:= ''
If lCallCenter .And. cCampo <> 'M->A7_PRODUTO'
	nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "UB_PRODUTO"}) 
	cProduto	:= aCols[n,nPosProd]  
ElseIf FunName() = "AXCADSA7" .Or. cCampo == 'M->A7_PRODUTO' .Or. lProdCli
	cProduto := M->A7_PRODUTO                              
ElseIf lContrato
	cProduto := M->ADB_CODPRO
ElseIf lOportuni1
	cProduto := M->AD1_CODPRO
ElseIf lOportuni2
	nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "ADJ_PROD"}) 
	cProduto	:= aCols[n,nPosProd]  
ElseIf lPedido
	cProduto	:=	M->C6_PRODUTO
Endif

cQuery := 	 " SELECT G1_COD, G1_GROPC, G1_OPC, R_E_C_N_O_ REG "
cQuery +=	 " FROM " + RetSqlName("SG1") + " SG1 (NOLOCK) "
cQuery +=	 " WHERE  "
cQuery +=	 " G1_FILIAL = '" + xFilial("SG1") + "' "
cQuery +=	 " AND SG1.D_E_L_E_T_ = '' "      
cQuery +=	 " AND SG1.G1_COD = '" + cProduto + "' "
cQuery += 	 " AND G1_OPC <> '' "  // VERIFICA SE TEM ALGUM COMPRIMENTO
//cQuery += 	 " AND (SUBSTRING(G1_COMP, 1,1) ='C'  OR  SUBSTRING(G1_COMP, 1,2) ='CP' OR  SUBSTRING(G1_COMP, 1,1) ='F' OR  SUBSTRING(G1_COMP, 1,1) ='N' )" //VERIFICA SE EH CABO
cQuery +=	 " ORDER BY G1_OPC "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

Count To nReg

CHK1->(dbGoTop())

cRetor1 := CHK1->G1_GROPC
cRetor2 := CHK1->G1_OPC

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)
lConfirma := .f.	
While CHK1->(!Eof())
	IncProc("Aguarde Localizando Opcionais")
		
	SG1->(dbGoto(CHK1->REG))
				
	AAdd(aOpc,{oOk,;
					Iif(SG1->G1_OPC$_cOpcio,'1','2'),;
					SG1->G1_GROPC,;
					SG1->G1_OPC,;
					SG1->G1_COMP,;
					SG1->(Recno())})

	If SG1->G1_OPC$_cOpcio
		lConfirma := .t.
	Endif
		
	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())
	
RestArea(aArea)

If Empty(Len(aOpc))
//	MsgAlert("Aten็ใo Nใo Existem Opcionais para Este Produto !")
	RestArea(aArea)
	Return ''
Endif


DEFINE MSDIALOG oRcp5 TITLE "Sele็ใo Opcionais  - Produto: " + AllTrim(SB1->B1_COD) + ' ' + SB1->B1_DESC FROM 000, 000  TO 350, 720 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
oRcp5:lEscClose := .F. //Nใo permite sair ao usuario se precionar o ESC

    @ 010, 005 LISTBOX oOpcionais Fields HEADER '','',"Grupo Opc.","Item Opcion.","Componente" SIZE 340, 140 OF oRcp5 PIXEL //ColSizes 50,50

    oOpcionais:SetArray(aOpc)
    oOpcionais:bLine := {|| {	Iif(aOpc[oOpcionais:nAt,2]=="1",oSinalOk,oSinalNo),;
    							Iif(aOpc[oOpcionais:nAt,2]=="1",oOk,oNo),;
        						aOpc[oOpcionais:nAt,3],;
      							aOpc[oOpcionais:nAt,4],;
					      		aOpc[oOpcionais:nAt,5]}}

	oOpcionais:bLDblClick := {||DblClick(oOpcionais:nAt)}

	nOpc := 0
	
  	@ 160, 005 BUTTON oBotaoCnf PROMPT "&Confirma" 			ACTION (Close(oRcp5),nOpc:=1) SIZE 080, 010 OF oRcp5 PIXEL
//    @ 160, 105 BUTTON oBotaoSai PROMPT "&Voltar" 			ACTION (Close(oRcp5),nOpc:=0) SIZE 080, 010 OF oRcp5 PIXEL
	
	If lConfirma
		oBotaoCnf:Enable()
	Else                  
		oBotaoCnf:Disable()
	Endif

	ACTIVATE MSDIALOG oRcp5 CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
	
	If nOpc == 1
		cRetorno := ''//cRetor1 //+ cRetor2 + "/" // GA_GROPC + "" + GA_OPC + "/"
		For nI := 1 To Len(aOpc)
			If aOpc[nI,2] == '1'
				cRetorno := cRetor1 + aOpc[nI,4] + '/'
				
				SG1->(dbGoTo(aOpc[nI,6]))
				
				If FunName() <> "AXCADSA7" .And. FunName() <> "FATA300" .And. !cCampo $'M->A7_PRODUTO,M->ADB_CODPRO,M->AD1_CODPRO' .And. cEmpAnt == '01'
					If FindFunction("U_RFATG01")
						xValor := U_RFATG01(2,.t.,.t.) // Igual a 1 Retorna Quantidade, Igual a 2 Retorna Valor Unitario, .t. atualiza linha, .f. nao atualiza, .t. Posicionado na SG1, .f. Nใo Posicionado
					Endif 
				Endif
				Exit
			Endif
		Next 
	Else
		cRetorno := ''
	Endif

RestArea(aArea)
Return cRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ DblClickณ Autor ณ Luiz Alberto        ณ Data ณ 06/12/11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao Responsavel pelo Double Click Tela Rotas ณฑฑ
ฑฑณ          |                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function dblClick(nPos)
Local aArea := GetArea()

If aOpc[nPos,2]=="1"
	aOpc[nPos,2]:="2"
	oBotaoCnf:Disable()
Else

	aOpc[nPos,2]:="1"
	oBotaoCnf:Enable()
	For nI := 1 To Len(aOpc)
		If nI <> nPos
			aOpc[nI,2] := '2'
		Endif
	Next
Endif 
oOpcionais:Refresh()
oRcp5:Refresh()
Return .t.
	