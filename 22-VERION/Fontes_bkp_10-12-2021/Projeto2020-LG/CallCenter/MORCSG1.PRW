#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

user function MORCSG1()
Local  nn 		:= 1
Local  nV       := 1
lOCAL  nPerc    := 50
Local  cTes	    := '558'
private  ly1 := .T.
private  ly2 := .T.
private  ly3 := .T.
private  ly4 := .T.
private  cStu   := space(15) //

//M->UA_XCPROJ := 'S'

If alltrim(M->UA_CLIENTE) = ""
	alert("Atenção nao pode usar esta rotina se nao informar o Cliente.")
	Return
Endif


If len(aCols) > 1 .or. alltrim(aCols[1][2]) <> ""
	alert("Atenção nao pode usar esta rotina para orçamentos com Itens lançados")
	Return
Endif

// MONTAGEM DA TELA .....
DEFINE MSDIALOG _oDlg FROM 0,0 TO 180,380 PIXEL TITLE "Cria a estrutura conforme o orçamento"
@ 001,003 TO 052,160 LABEL "Selecione o item conforme estrutura " OF _oDlg PIXEL
@ 15, 010 	Say OemToAnsi("Estrutura         : ") PIXEL
@ 15, 060	MSGET cStu Picture "@!" SIZE 080,8 When .t. Valid .T. F3 "SG1" OF _oDlg PIXEL
@ 35, 010 	Say OemToAnsi("% Desconto Padrao : ") PIXEL
@ 35, 068	MSGET nPerc Picture "99.99" SIZE 022,8 When .t. Valid nPerc < 63.9 OF _oDlg PIXEL

DEFINE SBUTTON FROM 65,020 TYPE 1 OF _oDlg ENABLE ONSTOP "Copia" ACTION (nV := 2,_oDlg:end()) ENABLE OF _oDlg
DEFINE SBUTTON FROM 65,080 TYPE 2 OF _oDlg ENABLE ONSTOP "Cancela e Sai..." ACTION _oDlg:End()

ACTIVATE MSDIALOG _oDlg CENTER

If nV <> 2
	return
endif

IF AVISO("Título", "Deseja incluir o Orçamento conforme estrutura "+ cStu + " . ", { "Sim", "Não" }, 1) = 1
	_nPosqt      := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_QUANT"})
	_nPospro     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_PRODUTO"})
	_nPosoper    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_OPER"})
	_nPostes     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_TES"})
	_nPosdes     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRDESC"})
	_nPosTes     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_TES"})
	_nPosEmissao := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_EMISSAO"})
	_nPosVun     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRUNIT"})
	_nPosXvrc    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XVRCOMP"})
	_nPosXmar    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XMARGEM"})
	_nPosVLR     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VLRITEM"})
	_nPosVLDC    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRVLRDE"})
	_nPosDESX    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XDESCAD"})
	N            := 1
	
	_CQUERY := ""                       
	
	
	
	_CQUERY := "SELECT G1_COMP,G1_QUANT "
	_CQUERY += " FROM ( SELECT G1_COMP,G1_QUANT "
	_CQUERY += "		FROM " + RetSqlName("SG1") +" G12A (NOLOCK) "
	_CQUERY += " 		WHERE G1_COD IN (SELECT G1_COD FROM " + RetSqlName("SG1") +" G12B (NOLOCK) WHERE G1_COD IN (SELECT G1_COMP "
	_CQUERY += "		FROM " + RetSqlName("SG1") +"  G11A "
	_CQUERY += "		WHERE G1_COD IN ( SELECT G1_COMP FROM " + RetSqlName("SG1") +" G11B WHERE G1_COD =  '"+cStu+"' AND G11B.D_E_L_E_T_ = '') AND G11A.D_E_L_E_T_ = '')  AND G12B.D_E_L_E_T_ = '') AND G12A.D_E_L_E_T_ = '') T3 "
	_CQUERY += " UNION ALL "	
	_CQUERY += "SELECT G1_COMP,G1_QUANT "
	_CQUERY += " FROM ( SELECT * "
	_CQUERY += " 		FROM " + RetSqlName("SG1") +" G1A (NOLOCK) "
	_CQUERY += " 		WHERE G1_COD IN ( SELECT G1_COMP FROM SG1010 G1B (NOLOCK) WHERE G1_COD = '"+cStu+"'  AND G1B.D_E_L_E_T_ = '') AND G1A.D_E_L_E_T_ = '') T1 "
	_CQUERY += " UNION ALL "
	_CQUERY += " SELECT G1_COMP,G1_QUANT "
	_CQUERY += " FROM ( SELECT * "
	_CQUERY += " 		FROM " + RetSqlName("SG1") +" G2A (NOLOCK) "
	_CQUERY += " 		WHERE G1_COD IN (SELECT G1_COD FROM SG1010 G2B (NOLOCK) WHERE G1_COD = '"+cStu+"'   AND G2B.D_E_L_E_T_ = '') AND G2A.D_E_L_E_T_ = '') T2 "


	TCQUERY _CQUERY NEW ALIAS "VRSG1"
	
	Dbselectarea("VRSG1")
	DbGoTop()
	While !EOF()   //alltrim(SG1->G1_COD) == alltrim(cStu)

		// ESTRUTURA
		DbSelectArea("SG1")
		DbSetOrder(1)
		If !dbseek(xfilial("SG1")+alltrim(VRSG1->G1_COMP))
		
		If nn > 1
			aCstu := {}
			aadd(aCOLS,Array(Len(aHeader)+1))
			
			For nY := 1 To Len(aHeader)
				
				If ( AllTrim(aHeader[nY][2]) == 'UB_ITEM' )
					aCols[Len(aCols)][nY] := strzero(nn,2)
				Else
					
					If aHeader[nY,10] == "V"
						aCols[Len(aCols)][nY] := iif(Alltrim(aHeader[nY,2]) = "UB_ALI_WT","SUB",iif(Alltrim(aHeader[nY,2]) = "UB_REC_WT",0,CriaVar(Alltrim(aHeader[nY,2]))))
					Else
						aCols[Len(aCols)][nY] := ("SUB")->&(Alltrim(aHeader[nY,2]))
					EndIf
					
				EndIf
			Next nY
			
			N  := Len(aCols)
			aCOLS[N][Len(aHeader)+1] := .F.
			
		Endif

			acols[nn,_npospro] := VRSG1->G1_COMP
			acols[N,_nposqt]   := VRSG1->G1_QUANT
		    nn := nn + 1
		Endif
		
		dbselectarea("VRSG1")
		VRSG1->(dbskip())
		
		if alltrim(VRSG1->G1_COMP) = "Y-VBMOENG"
			ly1 := .F.
		elseif alltrim(VRSG1->G1_COMP) = "Y-VBMOMONT"
			ly2 := .F.
		elseif alltrim(VRSG1->G1_COMP) = "Y-VBMOUSI"
			ly3 := .F.
		elseif alltrim(SG1->G1_COMP) = "Y-VBEMB"
			ly4 := .F.
		endif
		
	end


	Dbselectarea("VRSG1")
	DbGoTop()
	
	nn := 1
	While !EOF()
		//		While SG1->G1_COD = cStu
		N:= nn
		// ESTRUTURA
		DbSelectArea("SG1")
		DbSetOrder(1)
		If !dbseek(xfilial("SG1")+alltrim(VRSG1->G1_COMP))
			acols[N,_npospro] := VRSG1->G1_COMP
			
			dbselectarea("SUB")
			M->UB_PRODUTO := VRSG1->G1_COMP
			
			if  MAFISREF("IT_PRODUTO","TK273",M->UB_PRODUTO)  // TK273Calcula("UB_PRODUTO") .AND.
			else
				alert("erro no produto" + M->UB_PRODUTO)
				return
			endif
			
			acols[N,_nposqt]   := VRSG1->G1_QUANT
			acols[N,_nposoper] := '01'  
			nn := nn + 1
		ENDIF
		
		dbselectarea("VRSG1")
		VRSG1->(dbskip())
	end

/*/	
Retirado conforme email da Sra Renata no dia 26/9/2017.

	//  add servicos
	for h := 1 to 4
		cdo := "ly" + alltrim(str(h,1,0))
		
		if nn > 1 .and. &(cdo) = .t.
			aCstu := {}
			aadd(aCOLS,Array(Len(aHeader)+1))
			
			For nY := 1 To Len(aHeader)
				If ( AllTrim(aHeader[nY][2]) == 'UB_ITEM' )
					aCols[Len(aCols)][nY] := strzero(len(aCOLS),2)
				Else
 
					If aHeader[nY,10] == "V"
						aCols[Len(aCols)][nY] := iif(Alltrim(aHeader[nY,2]) = "UB_ALI_WT","SUB",iif(Alltrim(aHeader[nY,2]) = "UB_REC_WT",0,CriaVar(Alltrim(aHeader[nY,2]) )) )
					Else
						aCols[Len(aCols)][nY] := ("SUB")->&(Alltrim(aHeader[nY,2]))
					EndIf
				EndIf
			Next nY
 
			N := Len(aCols)
			aCOLS[N][Len(aHeader)+1] := .F.
			
			acols[N,_npospro] := iif(h = 1,"Y-VBMOENG",iif(h = 2,"Y-VBMOMONT",iif(h = 3,"Y-VBMOUSI","Y-VBEMB")))
			acols[N,_nposqt]  := 1
			
			M->UB_PRODUTO := acols[N,_npospro]
			
			if  MAFISREF("IT_PRODUTO","TK273",M->UB_PRODUTO)  // TK273Calcula("UB_PRODUTO") .AND.
			else
				alert("erro no produto" + M->UB_PRODUTO)
				return
			endif
			
			acols[N,_nposqt]   := 1
			acols[N,_nposoper] := '01'
			
		ENDIF
	next
	//  fim add servico
/*/
	
	N := 1
	Tk273FRefresh()
	GetDRefresh()
	SYSREFRESH()
	
	For i := 1 to len(aCols)
		N := i
		nQTu := acols[N,_nposqt]
		acols[N,_nPosEmissao] := DDATABASE
		M->UB_PRODUTO         := acols[N,_npospro]
		
		If ExistTrigger('UB_PRODUTO')
			RunTrigger(2,N,nil,,'UB_PRODUTO')
		ENDIF
		
		acols[N,_nposdes] := nPerc
		acols[N,_nposqt]  := nQTu
		
		If ExistTrigger('UB_QUANT')
			RunTrigger(2,N,nil,,'UB_QUANT  ')
		ENDIF
		
		If ExistTrigger('UB_VRDESC')
			RunTrigger(2,i,nil,,'UB_VRDESC ')
		ENDIF
		
		If ExistTrigger('UB_TES')
			acols[N,_nposTes]   := cTes
			RunTrigger(2,i,nil,,'UB_TES ')
		ENDIF
	next
	
	For i := 1 to len(aCols)
		N := i
		nXvrcom    := acols[N,_nPosXvrc]
		nXmargem   := acols[N,_nPosXmar]
		
		if nXvrcom * ((nXmargem + 100) / 100) > 0
			
			acols[n,_nPosVun] := nXvrcom * ((nXmargem + 100)/100)
			M->UB_VRUNIT      := acols[n,_nPosVun]
			
			TK273CALCULA("UB_VRUNIT")
		endif
	next i


// INICIO ==> AJUSTE DE ESTRUTURA CONFORME ORIENTACAO DA SRA ELISANGELA
For i := 1 to len(aCols)
	N      := i
    _WDATA := DDATABASE

	dbSelectArea("SM2")
	dbSeek(_WDATA)
	_WDOLAR := SM2->M2_MOEDA2
	_WEURO  := SM2->M2_MOEDA4
	_WLIBRA := SM2->M2_MOEDA6
	_WTXDES := ((SM2->M2_TXDESP + 100) / 100)

	dbSelectArea("SB1")
	dbSeek(xfilial()+ACOLS[N,_nPospro])  
	_WPRECO   := SB1->B1_VERVEN
	_WTIPICMS := SB1->B1_TIPICMS
	_WMOEDA   := SB1->B1_TPMOEDA
	_WFATOR   := SB1->B1_FATOR
	_WPRECO1  := IIF(SB1->B1_VERCOM > 0,SB1->B1_VERCOM,IIF(SB1->B1_CUSTD > 0,SB1->B1_CUSTD,IIF(SB1->B1_UPRC > 0,SB1->B1_UPRC,0)))
	_WGRUPO   := SB1->B1_GRUPO
	_cORI     := SB1->B1_ORIGEM
	_WPERCENT := Posicione("SB1",1,xFilial("SB1")+CSTU,"B1_PICM")
	_cGRPTRI  := SA1->A1_GRPTRIB
	_WPISCOF  := SB1->B1_PPIS+SB1->B1_PCOFINS	// ALTERADO POR RICARDO SOUZA (UPDUO) 15/09/2021

	dbSelectArea("SBM")
	dbSeek(xFilial()+_WGRUPO)
	IF _WFATOR = 0
		_WFATOR := SBM->BM_FATOR
	Endif

	//_WPERCENT := 12
	__WPERCENT := (100 - _WPERCENT - _WPISCOF) / 100

	If _WMOEDA == space(1)
		_WMOEDA := SBM->BM_MOEDA
		IF _WMOEDA == "D"
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA  := Round( ((_WAA1   * _WDOLAR) / _WPERCENT ) * _WTXDES ,2)
		ELSEIF _WMOEDA == "E"
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA  := Round( ((_WAA1   * _WEURO)  / _WPERCENT ) * _WTXDES ,2)
		ELSEIF _WMOEDA == "L"
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA  := Round( ((_WAA1   * _WLIBRA)  / _WPERCENT ) * _WTXDES ,2) // vlr venda
		ELSE
			_WAA1 := Round( (_WPRECO1 * _WFATOR) ,2)
			_WAA  := Round( (_WAA1  / _WPERCENT ) * _WTXDES ,2)
		ENDIF
	ELSE
		IF _WMOEDA == "D"
			_WAA := Round( (((_WPRECO1 * _WFATOR) * _WDOLAR) / _WPERCENT ) * _WTXDES ,2)
		ELSEIF _WMOEDA == "E"
			_WAA := Round( (((_WPRECO1 * _WFATOR) * _WEURO ) / _WPERCENT ) * _WTXDES ,2)
		ELSEIF _WMOEDA == "L"
			_WAA := Round((((_WPRECO1 * _WFATOR) * _WLIBRA)  / _WPERCENT ) * _WTXDES ,2) // vlr venda
		ELSE
			_WAA := Round( ((_WPRECO1 * _WFATOR) / _WPERCENT ) * _WTXDES ,2)
		ENDIF
	ENDIF

	If _WAA < 0.01 .and. M->UA_XCPROJ = 'S' 
		_WAA          := u_vera120()
	Endif                                                                           
	

	If acols[n,_nPosdes] > 0      // calculo do desconto com o novo valor
		_NDSC              := (acols[n,_nPosdes]/100)
		_nprc              := Round((_WAA*_NDSC) ,2)
		acols[n,_nPosVun]  := (_WAA - _nprc) // PRECO unitario
		acols[n,_nPosVLDC] := _nprc          // VALOR DE DESCONTO
	
		_CVLN             := Round((acols[N,_nposqt] * (_WAA - _nprc)) ,2)
		acols[n,_nPosVLR] := round(_CVLN,2)  // valor total 
	
	    IF ALLTRIM(_WGRUPO) $ "Y-"  
		    acols[n,_nPosXvrc] := round(_CVLN,2)  // valor total 
		    acols[n,_nPosDESX] := SB1->B1_DESC
	    ENDIF
	
	Else
		_nprc             := _WAA
		acols[n,_nPosVun] := _nprc
		_CVLN             := Round((acols[N,_nposqt] * _nprc) ,2)
		acols[n,_nPosVLR] := round(_CVLN,2)
	
	    IF ALLTRIM(_WGRUPO) $ "Y-"  
		    acols[n,_nPosXvrc] := round(_CVLN,2)  // valor total 
		    acols[n,_nPosDESX] := SB1->B1_DESC
	    ENDIF
	Endif                            

	M->UB_VRUNIT      := acols[n,_nPosVun]
	TK273CALCULA("UB_VRUNIT")
next i
// FIM ==> CALCULO

	N:= 1
	GetDRefresh()
	SYSREFRESH()
	
	M->UA_XCPROJ := 'S'

	Alert("Importado Itens da estrutura ." + cStu )
	
	VRSG1->(DBCLOSEAREA())
ENDIF
