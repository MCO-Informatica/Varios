#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE ENTER CHR(13)+CHR(10)

/*/{Protheus.doc} MFAT10
//Relatório de Faturamento (Acompanhamento de Receita)
@author yuri.volpe
@since 15/08/2018
@version 1.0

@type function
/*/
user function MFAT10()
	
	Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3         	:= "Demonstrativo de Receitas"
	Local cPict          	:= ""
	Local titulo       	 	:= "Demonstrativo de Receitas"
	Local nLin         		:= 80
	Local Cabec1       		:= "FILIAL ID_VEND_1   NM_VEND_1 			ID_VEND_2	NM_VEND_2			ID_PROD			DESC_PROD			SEGMENTO			ID CLIENTE/LOJA	 NM_CLIENTE				          							  NUM PEDIDO  DT_DO_PEDIDO  DT_LIBERACAO  DT_EMISSAO_PED  BPAG		  QTD DO ITEM		VL_UNIT			  VL_TOTAL			 MUNICÍPIO						ESTADO  GRP_CLIENTE					NF/ITEM			OPORTUNIDADE	NM_LICITAÇÃO	TP_RECEITA			DT_SOLICITAÇÃO	ORIGEM PEDIDO"
	Local Cabec2			:= ""
	Local imprime      		:= .T.
	Local aOrd 				:= {}
	Private lEnd         	:= .F.
	Private lAbortPrint  	:= .F.
	Private limite          := 220
	Private tamanho         := "G"
	Private nomeprog        := "MFAT10"
	Private nTipo           := 18
	Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      		:= Space(10)
	Private cbcont     		:= 00
	Private CONTFL     		:= 01
	Private m_pag      		:= 01
	Private wnrel      		:= "MFAT10"
	Private cString 		:= ""
	Private cPerg			:= "MFAT10"
	Private cAlias 			:= GetNextAlias()		

	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	Else

		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)
		
		MsAguarde({|| M10LOADTB()},"Aguarde...","Carregando tabelas...",.F.)
		Processa({|| MFAT10SQL(Cabec1,Cabec2,Titulo,nLin)},"[MFAT10] Gerando Relatório","Gerando resultados e exportando para Excel",.F.)

	EndIf

Return

/*/{Protheus.doc} AjustaSX1
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 17/08/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function AjustaSX1()

	Local aArea := GetArea()

	PutSx1(cPerg,"01","Emissao De         ","Emissao De         ","Emissao De         ","mv_ch1","D",08,00,01,"G","","   "	 ,"","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
	PutSx1(cPerg,"02","Emissao Ate        ","Emissao Ate        ","Emissao Ate        ","mv_ch2","D",08,00,01,"G","","   "	 ,"","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
	PutSx1(cPerg,"03","Vendedor De		  ","Vendedor De		","Vendedor De		  ","mv_ch3","C",06,00,00,"G","","SA3"	 ,"","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor Inicial para filtro"})
	PutSx1(cPerg,"04","Vendedor Ate		  ","Vendedor Ate		","Vendedor Ate		  ","mv_ch4","C",06,00,00,"G","","SA3"	 ,"","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor Final para filtro"})
	PutSx1(cPerg,"05","Filial De		  ","Filial De		    ","Filial De		  ","mv_ch5","C",02,00,00,"G","","SM0"	 ,"","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Filial Inicial para filtro"})
	PutSx1(cPerg,"06","Filial Ate		  ","Filial Ate		    ","Filial Ate		  ","mv_ch6","C",02,00,00,"G","","SM0"	 ,"","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Filial Final para filtro"})
	PutSx1(cPerg,"07","Origem P.V.        ","Origem P.V.        ","Origem P.V.        ","mv_ch7","C",25,00,01,"G","","MFAT10","","","mv_par03"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",{"Indica as origens de pedido a serem consideradas"})

	RestArea(aArea)

Return

/*/{Protheus.doc} CSPVORF3
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 11/06/2018
@version 1.0
@return cRetorno, 
@param cMVPAR03, characters, descricao
@type function
/*/
user function MFAT10F3(cMVPAR07)

Local oDlg
Local oPnlLbx
Local oLbx
Local oMrk      := LoadBitmap( GetResources(), "LBOK" )
Local oNoMrk    := LoadBitmap( GetResources(), "LBNO" )
Local cTitle 	:= "Origem de Pedidos"
Local cRetorno	:= ""
Local aDadosOp 	:= {}
Local aCombo	:= StrToKArr(U_CSC5XBOX(),";")
Local aAux 		:= {}
Local aButton	:= {}
Local nL		:= 2
Local Ni		:= 0
Local lMrkAll 	:= .F.

For Ni := 1 To Len(aCombo)
	aAux := {}
	aAux := StrToKArr(aCombo[Ni],"=")
	aAdd(aDadosOp, { .F., aAux[1], aAux[2]})
Next

If !Empty(mv_par07) .And. Empty(cMVPAR07)
	cMVPAR07 := mv_par07
EndIf

If !Empty(cMVPAR07)
	aAux := {}
	aAux := StrToKArr(cMVPAR07,";")
	For Ni := 1 To Len(aAux)
		If !Empty(aAux[Ni])
			nPosItem := aScan(aDadosOp,{|x| AllTrim(x[2]) == AllTrim(aAux[Ni])})
			If nPosItem > 0
				aDadosOp[nPosItem][1] := .T.
			EndIf
		EndIf 
	Next
EndIf

aAdd( aButton, {"&Concluído", "{|| oDlg:End() }"})
aAdd( aButton, {"&Abandonar", "{|| oDlg:End() }"})

DEFINE MSDIALOG oDlg TITLE cTitle FROM 0,0 TO 300,250 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
		//oDlg:lEscClose := .F.
			
		oPnlLbx := TPanel():New(0,0,'',oDlg,,.T.,,,,80,0,.T.,.T.)
		oPnlLbx:Align := CONTROL_ALIGN_ALLCLIENT

		oPnlBott := TPanel():New(0,0,'',oDlg,,.T.,,,,40,14,.T.,.F.)
		oPnlBott:Align := CONTROL_ALIGN_BOTTOM		
	
		oLbx := TwBrowse():New(0,0,800,400,,{'','Código','Descrição',''},{20,25,80},oPnlLbx,,,,,,,,,,,,.F.,,.T.,,.F.,,.F.,.F.)
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDadosOp )
		oLbx:bLDblClick := {|| aDadosOp[oLbx:nAt,1]:=!aDadosOp[oLbx:nAt,1]}
		   
		oLbx:bLine := {|| {Iif(aDadosOp[oLbx:nAt,1],oMrk,oNoMrk),aDadosOp[oLbx:nAt,2],aDadosOp[oLbx:nAt,3]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMrkAll := !lMrkAll,;
			                     AEval( aDadosOp, {|p| p[1] := lMrkAll } ),oLbx:Refresh()}
			                     
		For Ni := 1 To Len( aButton )			
			TButton():New(3,nL,aButton[nI,1],oPnlBott,&(aButton[nI,2]),38,10,,,.F.,.T.,.F.,,.F.,,,.F.)
			nL += 40
		Next Ni			                     
         
ACTIVATE MSDIALOG oDlg CENTER

For Ni := 1 To Len(aDadosOp)
	If aDadosOp[Ni][1]
		cRetorno += aDadosOp[Ni][2] + Iif( Len(aDadosOp)>1 , ";", "")
	EndIf
Next

If rat(";",cRetorno) == Len(cRetorno)
	cRetorno := Substr(cRetorno,1,Len(cRetorno)-1)
EndIf

cRetorno := AllTrim(cRetorno)

Return cRetorno

/*/{Protheus.doc} loadTables
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 16/08/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function M10LOADTB()

dbSelectArea("SD2")
SD2->(dbSetOrder(1))

dbSelectArea("SF2")
SF2->(dbSetOrder(1))

dbSelectArea("SC6")
SC6->(dbSetOrder(1))

dbSelectArea("SC9")
SC9->(dbSetOrder(1))

dbSelectArea("SC5")
SC5->(dbSetOrder(1))

dbSelectArea("SA3")
SA3->(dbSetOrder(1))

dbSelectArea("SA1")
SA1->(dbSetOrder(1))

dbSelectArea("ACY")
ACY->(dbSetOrder(1))

dbSelectArea("SZY")
SZY->(dbSetOrder(1))

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

dbSelectArea("SZ1")
SZ1->(dbSetOrder(1))

dbSelectArea("SZ2")
SZ2->(dbSetOrder(1))

Return

/*/{Protheus.doc} sweepTables
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 16/08/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function MFAT10SQL(Cabec1,Cabec2,Titulo,nLin)

Local _aPVORG 		:= {}
Local _cPVORG 		:= ""
Local _cCountTes	:= ""
Local _cCountNewTes	:= ""
Local _cNewTes		:= ""
Local _cQuery		:= ""
Local _cFilRel 		:= ""
Local _cIdVend1 	:= ""
Local _cNmVend1 	:= ""
Local _cIdVend2 	:= ""
Local _cNmVend2		:= ""	
Local _cIdProd		:= ""
Local _cDescProd	:= ""
Local _cSegmto		:= ""
Local _cCliIdLoja	:= ""
Local _cNomeCli		:= ""
Local _cNumPed		:= ""
Local _cDtPedido	:= ""
Local _cDtLibera	:= ""
Local _cDtEmisPed	:= ""
Local _cPedGAR		:= ""
Local _nValBruto	:= 0
Local _nVlUnit		:= 0
Local _nValTotal	:= 0
Local _nFrete		:= 0
Local _nDespesa		:= 0
Local _cMunicipio	:= ""
Local _cEstado		:= ""
Local _cGrpCli		:= ""
Local _cNfItem		:= ""
Local _cNumOport	:= ""
Local _cNmLicita	:= ""
Local _cTpReceita	:= ""
Local _cDtSolicit	:= ""
Local _cOrigPed		:= ""
Local _cDtEmisNF	:= ""
Local _cDtSolFat	:= ""
Local aHeader 		:= {}
Local aDados		:= {}
Local cFiltroSF2	:= ""
Local cFiltroSC5	:= ""
Local nTamA1COD		:= TamSX3("A1_COD")[1]
Local nTamA1LOJA	:= TamSX3("A1_LOJA")[1]
Local nTamF1DOC		:= TamSX3("F1_DOC")[1]
Local nTamD2ITEM	:= TamSX3("D2_ITEM")[1]
Local cLin			:= ""
Local nLin			:= 1
Local nCounter		:= 0
//Local lMostraSemNF	:= Iif(mv_par08==1,.T.,.F.)

	//Bloco reservado para tratar campo Origem PV (mv_par17).
	_aPVORG		:= StrToArray(Alltrim(mv_par17),";")

	_cPVORG		:= " "

	For _nI := 1 To Len(_aPVORG)
		If !Empty(_aPVORG[_nI])
			_cPVORG += "'" + _aPVORG[_nI] + "'"
			If _nI <> Len(_aPVORG)
				_cPVORG += ","
			EndIf
		EndIf
	Next _nI

	_cPVORG := Alltrim(_cPVORG)

	_cCountTes := Len(_cPVORG)
	_cCountNewTes := _cCountTes -2
	_cNewTes := Substring(_cPVORG,2,_cCountNewTes)

	If Empty(MV_PAR17)
		MV_PAR17 := '1;2;3;4;5;6;7;8;9;0;A'
	End
	
	If !Empty(mv_par09)
		_aTes := StrToArray(Alltrim(mv_par09),";")
		_cTes := "("
	
		For _nI := 1 To Len(_aTes)
		
			If !Empty(_aTes[_nI])
				_cTes += "'" + _aTes[_nI] + "'"
				If _nI <> Len(_aTes)
					_cTes += ","
				EndIf
			EndIf
		Next _nI
		
		_cTes += ")"
	Endif
	
	IF !Empty( MV_par16 )
		aCanal := StrToArray( RTrim(Mv_par16), ';' )
		cCanal := "("
		
		For _nI := 1 To Len( aCanal )
			IF !Empty( aCanal[_nI] )
				cCanal += "'" + aCanal[_nI] + "'"
				IF _nI <> Len( aCanal )
					cCanal += ","
				EndIF
			EndIF
		Next _nI
		
		cCanal += ")"
	EndIF	

aAdd(aDados,{"FILIAL",;
			"ID_VEND_1",;
			"NM_VEND_1",;
			"ID_VEND_2",;
			"NM_VEND_2",;
			"ID_PROD",;
			"DESC_PROD",;
			"SEGMENTO",;
			"ID_CLIENTE/LOJA",;
			"NM_CLIENTE",;
			"NUM_PEDIDO",;
			"DT_DO_PEDIDO",;
			"DT_LIBERACAO",;
			"DT_EMISSAO_PED",;
			"BPAG",;
			"QTD DO ITEM",;
			"VL_UNIT",;
			"VL_TOTAL",;
			"MUNICÍPIO",;
			"ESTADO",;
			"GRP_CLIENTE",;
			"NF/ITEM",;
			"OPORTUNIDADE",;
			"NM_LICITAÇÃO",;
			"TP_RECEITA",;
			"DT_SOLICITAÇÃO",;
			"ORIGEM_PEDIDO"})
	
_cQuery += "SELECT D2_FILIAL                 AS FILIAL," + ENTER 
_cQuery += "F2_VEND1                         AS VEND1," + ENTER
_cQuery += "F2_VEND2                         AS VEND2," + ENTER
_cQuery += "D2_COD                           AS COD_PROD," + ENTER
_cQuery += "D2_CLIENTE||D2_LOJA              AS CLI_LOJA," + ENTER
_cQuery += "C5_NUM                           AS NUM_PEDIDO," + ENTER
_cQuery += "C5_EMISSAO                       AS EMISSAO_PED," + ENTER
_cQuery += "D2_EMISSAO                       AS EMISSAO_NF," + ENTER
_cQuery += "C5_CHVBPAG                       AS PEDIDO_GAR," + ENTER
_cQuery += "D2_QUANT                         AS QTDE," + ENTER
_cQuery += "D2_TOTAL                         AS TOTAL," + ENTER
_cQuery += "D2_TOTAL + F2_DESPESA + F2_FRETE AS TOTAL_DESP_FRETE," + ENTER 
_cQuery += "F2_DESPESA 						 AS DESPESA," + ENTER
_cQuery += "F2_FRETE 						 AS FRETE," + ENTER
_cQuery += "D2_DOC||D2_ITEM                  AS NF_ITEM," + ENTER
_cQuery += "C5_TPRECE                        AS TIPO_RECEITA," + ENTER
_cQuery += "C5_XDTSLFT                       AS DT_SOLICIT_FAT," + ENTER
_cQuery += "C5_XCODLIC						 AS NM_LICITACAO," + ENTER
_cQuery += "C5_XORIGPV                       AS ORIGEM_PEDIDO" + ENTER
_cQuery += "	FROM   "+RetSqlName("SF2")+" SF2" + ENTER
_cQuery += "	       INNER JOIN "+RetSqlName("SD2")+" SD2" + ENTER 
_cQuery += "	               ON SF2.F2_FILIAL = '" + xFilial("SD2") + "'" + ENTER 
_cQuery += "	                  AND SF2.F2_DOC = SD2.D2_DOC" + ENTER
_cQuery += "	                  AND SF2.F2_SERIE = SD2.D2_SERIE" + ENTER
_cQuery += "	                  AND SF2.F2_CLIENTE = SD2.D2_CLIENTE" + ENTER
_cQuery += "                  AND SF2.F2_LOJA = SD2.D2_LOJA" + ENTER
_cQuery += "	       INNER JOIN "+RetSqlName("SC5")+" SC5" + ENTER
_cQuery += "	               ON SC5.C5_FILIAL = '" + xFilial("SC5") + "'" + ENTER
_cQuery += "	                  AND SC5.C5_CLIENTE = SF2.F2_CLIENTE" + ENTER
_cQuery += "	                  AND SC5.C5_LOJACLI = SF2.F2_LOJA" + ENTER
_cQuery += "	                  AND SC5.C5_NUM = SD2.D2_PEDIDO" + ENTER
_cQuery += " WHERE"+ ENTER
_cQuery += "	SF2.F2_EMISSAO BETWEEN '"+ DTOS(mv_par01) + "' AND '"+ DTOS(mv_par02) + "' "+ ENTER
_cQuery += "	AND SF2.F2_VEND1 BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "+ ENTER
_cQuery += "	AND SC5.C5_XNATURE BETWEEN '" + mv_par07 +"' AND '"+ mv_par08 +"' "+ ENTER

If !Empty(mv_par09)
	_cQuery += "	AND SD2.D2_TES IN " + _cTes + " " + ENTER
EndIf

_cQuery += "	AND SF2.F2_CLIENTE BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'" + ENTER
 	
If mv_par13 == 1
	_cQuery += "	 AND SF2.F2_FILIAL BETWEEN '"+mv_par14+"' AND '"+mv_par15+"' " + ENTER
EndIf
	
_cQuery += "	AND SC5.C5_XORIGPV IN ('"+_cNewTes+"') " + ENTER
_cQuery += "	AND SC5.D_E_L_E_T_ = ' '"  + ENTER
_cQuery += "	AND SF2.D_E_L_E_T_ = ' '"  + ENTER
_cQuery += "	AND SD2.D_E_L_E_T_ = ' '"  + ENTER
_cQuery += "ORDER BY SC5.C5_NUM" 

MemoWrite("C:\Data\Query_MFAT10.sql",_cQuery)

If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
EndIf

_nTimeStart := Seconds()
MsgRun("Executando Query","[MFAT10] Demonstrativo de Receitas",{|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAlias,.T.,.T.) })
_nTimeEnd := Seconds()
_nTotalTime := _nTimeEnd - _nTimeStart

If Select("CNTQRY") > 0
	CNTQRY->(dbCloseArea())
EndIf

MsgRun("Calculando total de itens [Query: " + cValToChar(Round(_nTotalTime / 60,2)) + " min. ]",;
		"[MFAT10] Demonstrativo de Receitas",{|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,"SELECT COUNT(*) COUNTER FROM ("+_cQuery+")"),"CNTQRY",.T.,.T.)})
		
_cRegCnt := CNTQRY->COUNTER
ProcRegua(_cRegCnt)

CNTQRY->(dbCloseArea())

//Loop na Query que traz SD2, SC5 e SF2
dbSelectArea(cAlias)
While (cAlias)->(!EoF())
	
	nCounter++
	IncProc("Processando registro " + cValToChar(nCounter) + "/" + cValToChar(_cRegCnt))
	
	//Zera variaveis
	_cFilRel 	:= "'" + (cAlias)->FILIAL
	_cCliIdLoja	:= Substr((cAlias)->CLI_LOJA,1,nTamA1COD) + "/" + Substr((cAlias)->CLI_LOJA,nTamA1COD+1,nTamA1LOJA) 
	_cNumPed	:= (cAlias)->NUM_PEDIDO 
	_cDtEmisPed := Substr((cAlias)->EMISSAO_PED,7,2)+"/"+Substr((cAlias)->EMISSAO_PED,5,2)+"/"+Substr((cAlias)->EMISSAO_PED,1,4)
	_cPedGAR	:= (cAlias)->PEDIDO_GAR
	_cNfItem	:= Substr((cAlias)->NF_ITEM,1,nTamF1DOC) + "/" +Substr((cAlias)->NF_ITEM,nTamF1DOC+1,nTamD2ITEM) 
	_cNmLicita 	:= (cAlias)->NM_LICITACAO
	_cTpReceita := (cAlias)->TIPO_RECEITA	
	_cOrigPed	:= (cAlias)->ORIGEM_PEDIDO
	_cEmisNF	:= Substr((cAlias)->EMISSAO_NF,7,2)+"/"+Substr((cAlias)->EMISSAO_NF,5,2)+"/"+Substr((cAlias)->EMISSAO_NF,1,4)
	_nValBruto 	:= (cAlias)->TOTAL_DESP_FRETE
	_cDtSolFat	:= Iif(!Empty((cAlias)->DT_SOLICIT_FAT),Substr((cAlias)->DT_SOLICIT_FAT,7,2)+"/"+Substr((cAlias)->DT_SOLICIT_FAT,5,2)+"/"+Substr((cAlias)->DT_SOLICIT_FAT,1,4),"")
	_nFrete		:= (cAlias)->FRETE
	_nDespesa	:= (cAlias)->DESPESA
	_cNumOport	:= ""
	_cDtPedido	:= ""
	_cDtLibera	:= ""
	_cIdVend1 	:= ""
	_cNmVend1	:= ""
	_cIdVend2 	:= ""
	_cNmVend2 	:= ""
	_cNomeCli	:= ""
	_nQtdItem	:= 0
	_nValTotal	:= 0
	__nVlUnit 	:= 0
	_cNomeCli	:= ""	
	_cMunicipio	:= ""
	_cEstado	:= ""
	_cGrpCli	:= ""
	_cSegmto 	:= ""
	_cIdProd 	:= ""
	_cDescProd 	:= ""

	//Captura dados do cliente
	If SA1->(dbSeek(xFilial("SA1") + Substr(_cCliIdLoja,1,at("/",_cCliIdLoja)-1) + Substr(_cCliIdLoja,at("/",_cCliIdLoja)+1)))
		_cNomeCli	:= SA1->A1_NOME	
		_cMunicipio	:= SA1->A1_MUN
		_cEstado	:= SA1->A1_EST
		
		//Grupo de Vendas do Cliente
		If ACY->(dbSeek(xFilial("ACY") + SA1->A1_GRPVEN))
			_cGrpCli	:= ACY->ACY_DESCRI
		EndIf
		
	EndIf
	
	//Dados de Licitacao
	If SZY->(dbSeek(xFilial("SZY") + _cNmLicita))
		_cNmLicita := SZY->ZY_NOMELIC
	EndIf

	//Localiza os itens do pedido para capturar demais dados
	If SC6->(dbSeek(xFilial("SC6") + _cNumPed))
		
		While SC6->(!EoF()) .And. SC6->C6_NUM+SC6->C6_CLI+SC6->C6_LOJA == _cNumPed+(cAlias)->CLI_LOJA  
	
			_cNumOport 	:= SC6->C6_NROPOR
			_nQtdItem	:= SC6->C6_QTDVEN
			_nVlUnit 	:= SC6->C6_PRCVEN
			_cNfItem	:= SC6->C6_NOTA+"/"+SC6->C6_SERIE
			
			If (Empty(SC6->C6_NOTA) .And. Empty(SC6->C6_SERIE))
				SC6->(dbSkip())
				Loop
			EndIf
				
			//Localiza Vendedor 1
			If SA3->(dbSeek(xFilial("SA3") + (cAlias)->VEND1))
			
				//Validação do Canal de Venda
				If !Empty(mv_par16) .And. !(SA3->A3_XCANAL $ mv_par16)
					SC6->(dbSkip())
					Loop
				EndIf
				
				_cIdVend1 := SA3->A3_COD
				_cNmVend1 := SA3->A3_NOME
				
			EndIf
			
			//Localiza Vendedor 2
			If SA3->(dbSeek(xFilial("SA3") + (cAlias)->VEND2))
				_cIdVend2 := SA3->A3_COD
				_cNmVend2 := SA3->A3_NOME
			EndIf
			
			//Pega dados da Liberação do Pedido	
			If SC9->(dbSeek(xFilial("SC9") + (cAlias)->NUM_PEDIDO))
				_cDtLibera := DTOC(SC9->C9_DATALIB)
			EndIf
			
			//Pega dados do Produto
			If SB1->(dbSeek(xFilial("SB1") + (cAlias)->COD_PROD))
				_cIdProd	:= SB1->B1_COD
				_cDescProd	:= SB1->B1_DESC
				
				//Segmento de Produtos
				If SZ1->(dbSeek(xFilial("SZ1") + SB1->B1_XSEG))
					_cSegmto := SZ1->Z1_DESCSEG
				EndIf
			EndIf

			aAdd(aDados,{	_cFilRel,; 		//FILIAL
					_cIdVend1,;				//ID_VEND_1
					_cNmVend1,; 			//NM_VEND_1
					_cIdVend2,; 			//ID_VEND_2
					_cNmVend2,; 			//NM_VEND_2
					_cIdProd,; 				//ID_PROD
					_cDescProd,;			//DESC_PROD
					_cSegmto,; 				//SEGMENTO
					_cCliIdLoja,; 			//ID_CLIENTE/LOJA
					_cNomeCli,; 			//NM_CLIENTE
					_cNumPed,; 				//NUM_PEDIDO
					_cDtEmisPed,;			//DT_DO_PEDIDO
					_cDtLibera,;			//DT_LIBERACAO
					_cEmisNF,;				//DT_EMISSAO_PED
					_cPedGAR,;				//BPAG
					Transform(_nQtdItem, X3Picture("D2_QUANT")),; 		//QTD DO ITEM
					Transform(_nVlUnit, X3Picture("D2_TOTAL")),; 		//VL_UNIT
					Transform((_nVlUnit * _nQtdItem) + _nFrete + _nDespesa, '@E 999,999,999.99'),;		//VL_TOTAL
					_cMunicipio,;			//MUNICÍPIO
					_cEstado,;				//ESTADO
					_cGrpCli,; 				//GRP_CLIENTE
					_cNfItem,;				//NF/ITEM
					_cNumOport,; 			//OPORTUNIDADE
					_cNmLicita,; 			//NM_LICITAÇÃO
					_cTpReceita,; 			//TP_RECEITA
					_cDtSolFat,; 			//DT_SOLICITAÇÃO
					_cOrigPed })			//ORIGEM_PEDIDO
					
				 
			/*cLin += _cFilRel + Space(5) + _cIdVend1 + Space(6) +  Substr(_cNmVend1,1,20) + Space(1) + _cIdVend2 + Space(6) + _cNmVend2 + Space(1) + _cIdProd + Space(1) +;
					_cDescProd + Space(1) + _cSegmto + Space(1) +  _cCliIdLoja + Space(8) + _cNomeCli +  Space(1) + _cNumPed + Space(5) +;
					_cDtEmisPed + _cDtLibera + _cEmisNF + _cPedGAR + Transform(_nQtdItem, X3Picture("D2_QUANT")) +  Transform(_nValTotal, X3Picture("D2_TOTAL")) +;
					Transform(_nValBruto, '@E 999,999,999.99') + _cMunicipio + _cEstado + _cGrpCli +  _cNfItem + _cNumOport +  _cNmLicita +  _cTpReceita +;
					_cDtSolFat +  _cOrigPed
			
			@nLin, 01 PSAY cLin*/
			
			nLin++
	
			SC6->(dbSkip())			
		EndDo
	EndIf

	(cAlias)->(dbSkip())
EndDo

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

DlgToExcel({ {"ARRAY","Demonstrativo de Receitas", aHeader, aDados} })

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

(cAlias)->(dbCloseArea())

Return