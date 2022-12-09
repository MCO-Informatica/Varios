#Include "Protheus.ch"   
#Include "TopConn.ch"     
#INCLUDE "RWMAKE.CH"

#DEFINE CRLF CHR(13)+CHR(10)
User Function VQMETCLI(cOrigem) 
    Local aCampos  	:= {"CT_GRUPO","CT_PRODUTO", "CT_QUANT"}
    Local aBotoes	:= {}  
    Local cLinOk	:= "U_VQMCLILOK()"         
    Local cTudOk	:= "U_VQMCLITOK()"
    Local cFieldOk	:= "U_VQMCLFOK()"
    Local cIniCpos	:= "+CT_SEQUEN"  
    Local nFreeze	:= 000      
                    
    If cOrigem == "CallCenter"
    	If Empty(M->UA_CLIENTE)
    		Alert("Selecione um cliente")
    		Return  
    	Else
    		DbSelectArea("SA1");DbSetOrder(1)
    		If SA1->(DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA))   
				    Private _cCodCli	:= AllTrim(SA1->A1_COD)
				    Private _cLojCli	:= AllTrim(SA1->A1_LOJA)  
					Private _cNomCli	:= AllTrim(SA1->A1_NREDUZ)      
				    Private _cRegCli    := AllTrim(SA1->A1_REGIAO)
				    Private _cGrpCli    := AllTrim(SA1->A1_GRPVEN)
				    Private _cCgcCli	:= AllTrim(SA1->A1_CGC)    			
    		EndIf
    	EndIf
    Else
		Private _cCodCli	:= AllTrim(SA1->A1_COD)
	    Private _cLojCli	:= AllTrim(SA1->A1_LOJA)  
		Private _cNomCli	:= AllTrim(SA1->A1_NREDUZ)      
	    Private _cRegCli    := AllTrim(SA1->A1_REGIAO)
	    Private _cGrpCli    := AllTrim(SA1->A1_GRPVEN)
	    Private _cCgcCli	:= AllTrim(SA1->A1_CGC)
    EndIf         
                                
	Private _cQuery := ""
    Private _oNvNumDoc
    Private _cNvNumDoc	:= "000000000"        

	Private _cUsuario	:= USRRETNAME(RETCODUSR())
    Private _cVQAlias 	:= GetNextAlias()  
    Private oLista                    
    Private aHeader  	:= {}         
    Private aCols 		:= {}    
   	Private aColsAux    := {}  
   	Private _LinAlt		:= ""    
   	Private lLoadTela   := .F. 
   	Private lLoadData	:= .F.
   	
    
    Private oAzul  		:= LoadBitmap( GetResources(), "BR_AZUL")
    Private oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO")   
    Private oVioleta	:= LoadBitmap( GetResources(), "BR_VIOLETA")
   	   	
   	aSize := MsAdvSize()

	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 020, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
	aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})     
//	aadd(aBotoes,{"Vis. Grafico", {|| },"Vis. Grafico","Vis. Grafico"})
                 
 	SOFTLOCK("SA1") 
    loadACols()   
	If lLoadTela 
		Define MsDialog oDlg Title "Consumo Estimado Cliente" From aSize[7]/1.5,0 To aSize[6]/1.5,aSize[5]/1.5 STYLE DS_MODALFRAME  OF oMainWnd  PIXEL
    	    CriaCabec()      
	        @ 006,005 SAY "Cliente: "		   				OBJECT oLabel
			@ 006,025 SAY _cCodCli + "/" + _cLojCli			OBJECT oLabel        
			@ 006,065 SAY _cNomCli							OBJECT oLabel        
			@ 006,165 SAY "CPF/CNPJ: "		   				OBJECT oLabel
			@ 006,195 SAY _cCgcCli					   		OBJECT 	oLabel
	        @ 016,005 SAY "Operador:"						OBJECT oLabel        
	  		@ 016,040 SAY _cUsuario		 					OBJECT oLabel        
	        @ 026,005 SAY "Documento:"						OBJECT oLabel        
	        @ 026,040 SAY _oNvNumDoc var _cNvNumDoc 		of oDlg Pixel
	        
	        oGrid := MsNewGetDados():New((aPosObj[1][1]/1.5)+35,(aPosObj[1][2]/1.5)+5,(aPosObj[3][3]/1.5)-5,(aPosObj[3][4]/1.5)-5, GD_INSERT+GD_DELETE+GD_UPDATE, cLinOk, cTudOk, cIniCpos, aCampos,nFreeze, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeader, aCols)
	     	If lLoadData	
	     		_oNvNumDoc:Refresh()
				oGrid:SetArray(aCols,.T.)
				oGrid:Refresh()  
			Else
				_oNvNumDoc:Refresh()
	     	EndIf
	
	        oGrid:oBrowse:SetFocus()          
	
	    ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| VQMCLICADOK() }, {||  VQMFECHA() },,aBotoes) CENTERED
	EndIf
Return                   

Static function Legenda()
    Local aLegenda := {}
    AADD(aLegenda,{"BR_AZUL"    	,"Cadastrado Manualmente" })
    AADD(aLegenda,{"BR_AMARELO"     ,"Cadastrado Automaticamente no Faturamento" })
    AADD(aLegenda,{"BR_VIOLETA"     ,"Importado do cadastro anterior" })
    BrwLegenda("Legenda", "Legenda", aLegenda)
Return Nil
  
Static Function CriaCabec()  
  	Aadd(aHeader, {""			,"IMAGEM"		,"@BMP",3,0,".F.","","C","","V","","","","V"})
	Aadd(aHeader, {"Seq."		, "CT_SEQUEN"	,"@!",3,0,"","","C","","","", "", ""	})
	Aadd(aHeader, {"Data"		, "CT_DATA"		,""	 ,8,0,"","","D","","","", "", ""	})
	Aadd(aHeader, {"Cod.Grupo"	, "CT_GRUPO"	,""  ,4,0,"(Vazio() .Or. ExistCpo('SBM')) .And. U_VQATUGRUPO('SBM')","","C","SBM","","", "", ""})
	Aadd(aHeader, {"Desc.Grupo"	,"DESC_GRUPO"	,"",20,0,"","","C","","","", "", ""	})   
	Aadd(aHeader, {"Cod.Produto", "CT_PRODUTO"	,"@!",15,0,"(Vazio() .Or. ExistCpo('SB1')).And. U_VQATUGRUPO('SB1')","","C","SB1","","", "", ""})
	Aadd(aHeader, {"Desc.Produto","DESC_PROD"	,"",30,0,"","","C","","","", "", ""})  
	Aadd(aHeader, {"Quantidade em KG" , "CT_QUANT"	,"@e 999,999,999.99",12,2,"","","N","","","", "", ""}) 
//	Aadd(aHeader, {"Gerado"  , "CT_VQ_GFAT"	,"@!",10,1,"","","C","","","", "", ""})  
	Aadd(aHeader, {"R_E_C_N_O_","R_E_C_N_O_"	,"",12,0,"","","N","","","", "", ""})          
Return           
                          


Static Function loadACols()
Local _cGerAut	:= ""  
Local _cQuery   := VQGCMETA(SA1->A1_COD, SA1->A1_LOJA)
Local _cCor

If Select(_cVQAlias) > 0
	_cVQAlias->(DbCloseArea())
EndIf       
                   
TcQuery _cQuery New Alias _cVQAlias
  	
While !_cVQAlias->(Eof())    
	IF	_cVQAlias->CT_VQ_GAUT = "A"
		_cCor := oAmarelo
	ELSEIF _cVQAlias->CT_VQ_GAUT = "I"
		_cCor := oVioleta
	ELSE     
		_cCor := oAzul
	ENDIF
	Aadd(aCols, 	{_cCor,_cVQAlias->CT_SEQUEN, StoD(_cVQAlias->CT_DATA), _cVQAlias->CT_GRUPO,_cVQAlias->BM_DESC, _cVQAlias->CT_PRODUTO,_cVQAlias->B1_DESC, _cVQAlias->CT_QUANT, _cVQAlias->R_E_C_N_O_, .F.})     
	Aadd(aColsAux, 	{_cVQAlias->CT_DOC,_cVQAlias->CT_SEQUEN, StoD(_cVQAlias->CT_DATA), _cVQAlias->CT_GRUPO,_cVQAlias->BM_DESC, _cVQAlias->CT_PRODUTO,_cVQAlias->B1_DESC, _cVQAlias->CT_QUANT, _cVQAlias->R_E_C_N_O_, .F.})     
	_cVQAlias->(DbSkip())
EndDo    

If Len(aCols) > 0  
	_cNvNumDoc := aColsAux[1][1]
	lLoadTela := .T.    
	lLoadData := .T.
	
Else
	If MSGYESNO("O cliente ainda não possui consumo cadastrado, deseja cadastrar?")
		lLoadTela := .T.      
		lLoadData := .F.
		_cNvNumDoc := GETSXENUM("SCT","CT_DOC")  
	EndIf
EndIf   

_cVQAlias->(DbCloseArea())
  
Return  


Static Function VQGCMETA(_codcli, _lojcli)  
Local cQuery
	cQuery := " SELECT " + CRLF
	cQuery += " SCT.CT_DOC " + CRLF
	cQuery += " ,SCT.CT_SEQUEN 	" + CRLF
	cQuery += " ,SCT.CT_DATA 	" + CRLF                        	
	cQuery += " ,SCT.CT_REGIAO 	" + CRLF
	cQuery += " ,SCT.CT_GRPCLI 	" + CRLF
	cQuery += " ,SCT.CT_GRUPO 	" + CRLF
	cQuery += " ,SCT.CT_PRODUTO " + CRLF
	cQuery += " ,SCT.CT_QUANT 	" + CRLF
	cQuery += " ,SCT.CT_VEND 	" + CRLF  
	cQuery += " ,SB1.B1_DESC 	" + CRLF
	cQuery += " ,SBM.BM_DESC 	" + CRLF  
	cQuery += " ,SCT.CT_VEND 	" + CRLF  
	cQuery += " ,SCT.R_E_C_N_O_ " + CRLF 
	cQuery += " ,SCT.CT_VQ_GAUT " + CRLF 
	cQuery += " FROM "+RetSqlName("SCT")+" SCT " + CRLF
	cQuery += "		LEFT JOIN "+RetSqlName("SB1")+ " SB1 ON (SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = SCT.CT_PRODUTO)" + CRLF
	cQuery += "		LEFT JOIN "+RetSqlName("SBM")+ " SBM ON (SBM.D_E_L_E_T_ <> '*' AND SBM.BM_GRUPO = SCT.CT_GRUPO)" + CRLF
	cQuery += " 	WHERE  	" + CRLF
	cQuery += " 	SCT.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += " 	AND SCT.CT_CLIENTE 	= '" + _codcli + "' " + CRLF
	cQuery += " 	AND SCT.CT_LOJA 	= '" + _lojcli + "' " + CRLF       
	cQuery += "ORDER BY SCT.CT_DOC, SCT.CT_SEQUEN "	
Return cQuery              
      
                      
                 
Static Function VQMFECHA()
	SA1->(MSUNLOCK())
	oDlg:End()
Return

Static Function VQMCLICADOK()    

Local lTudoOk 	:= .T.
Local lHouvAlt	:= .F.
Local nPosSeq	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_SEQUEN"})
Local nPosData  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_DATA"})                                                         
Local nPosGrpP	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_GRUPO"})
Local nPosProd	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_PRODUTO"})
Local nPosQtde  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_QUANT"})
Local nPosRec 	:= aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="R_E_C_N_O_"})
 
lHouvAlt := VQHOUVEALT()

If lHouvAlt
	IF(MSGYESNO("Deseja salvar as alterações?"))
		lTudoOk := U_VQMCLITOK()	
		If lTudoOk     
		   	DbSelectArea("SCT");DbSetOrder(1) 
			For nX := 1 To Len(oGrid:aCols)   
				If (STRZERO(nX,3) $ _LinAlt  )
			 		cTipoGrv := ""
					If oGrid:aCols[nX][nPosRec] == 0 .And. !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
						cTipoGrv := "I" 
					ElseIf oGrid:aCols[nX][nPosRec] > 0 .And. !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
						cTipoGrv := "A" 
					ElseIf oGrid:aCols[nX][nPosRec] > 0 .And. GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
						cTipoGrv := "E"
					EndIf  
			
					If cTipoGrv $ "A/E"
						SCT->(DbGoTo(oGrid:aCols[nX][nPosRec]))
						RecLock("SCT",.F.)
					ElseIf cTipoGrv == "I"
						If !RecLock("SCT",.T.)
							RollBackSX8()
						EndIf
						
					Else
						Loop
					EndIf
		
					If cTipoGrv == "I"
						SCT->CT_FILIAL 	:= 	XFILIAL("SCT")
		  				SCT->CT_DOC		:= 	_cNvNumDoc
			  			SCT->CT_SEQUEN	:= 	oGrid:aCols[nX][nPosSeq]
			 	 		SCT->CT_DESCRI	:= 	"INCLUSAO MANUAL - " + _cUsuario 
		  				SCT->CT_DATA	:=	Date()    
		  				SCT->CT_CLIENTE	:= 	_cCodCli
		  				SCT->CT_LOJA	:=	_cLojCli
						SCT->CT_REGIAO	:=	_cRegCli
						SCT->CT_GRPCLI	:=  _cGrpCli
				  		SCT->CT_VEND	:=	""
				  		SCT->CT_GRUPO	:=	oGrid:aCols[nX][nPosGrpP]
				  		SCT->CT_PRODUTO	:=	oGrid:aCols[nX][nPosProd]
				  		SCT->CT_QUANT	:=	oGrid:aCols[nX][nPosQtde]
				  		SCT->CT_VALOR	:=	1
				  		SCT->CT_MOEDA	:=	1
				  		SCT->CT_VQ_GAUT	:=	"M"        
				  		ConfirmSX8()
					EndIf
					
					If cTipoGrv == "A"
						SCT->CT_FILIAL 	:= 	XFILIAL("SCT")
		  				SCT->CT_DOC		:= 	_cNvNumDoc
			  			SCT->CT_SEQUEN	:= 	oGrid:aCols[nX][nPosSeq]
			 	 		SCT->CT_DESCRI	:= 	"ALTERACAO MANUAL - " + _cUsuario
		  				SCT->CT_DATA	:=	Date()
		  				SCT->CT_CLIENTE	:= 	_cCodCli
		  				SCT->CT_LOJA	:=	_cLojCli
						SCT->CT_REGIAO	:=	_cRegCli
						SCT->CT_GRPCLI	:=  _cGrpCli
						SCT->CT_VEND	:=	""
				  		SCT->CT_GRUPO	:=	oGrid:aCols[nX][nPosGrpP]
				  		SCT->CT_PRODUTO	:=	oGrid:aCols[nX][nPosProd]
				  		SCT->CT_QUANT	:=	oGrid:aCols[nX][nPosQtde]
				  		SCT->CT_VALOR	:=	1
				  		SCT->CT_MOEDA	:=	1
				  		SCT->CT_VQ_GAUT	:=	"M"
					EndIf
					If cTipoGrv == "E"
						SCT->(DbDelete())
					EndIf
					SCT->(MsUnLock()) 		
				EndIf
			Next          
			MsgInfo("Informações atualizadas com sucesso")
			VQMFECHA()
		EndIf	
	ELSE 
		VQMFECHA()
	ENDIF	
Else
	VQMFECHA()
EndIf
Return()  


Static Function VQHOUVEALT()
Local lRet 	  := .F.
Local nPosRec := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="R_E_C_N_O_"})

For nX := 1 To Len(aColsAux)
	If GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
		lRet := .T.         
		_LinAlt += STRZERO(nX,3) + "/"
	EndIf        
	If !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
		For nY := 2 to Len(aColsAux[nX])
			If oGrid:aCols[nX][nY] <> aColsAux[nX][nY]
				lRet := .T.                           
				_LinAlt += STRZERO(nX,3) + "/"
			EndIf               
		Next
	EndIf
Next       

For nX := 1 To Len(oGrid:aCols)
	If oGrid:aCols[nX][nPosRec] == 0  .AND. !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
		lRet := .T.                                                               
	    _LinAlt += STRZERO(nX,3) + "/"
	EndIf
Next               

Return lRet
 
User Function VQMCLITOK()
Local lRet := .T.
Local nPosProduto := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_PRODUTO"})
Local nPosGrupoP  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_GRUPO"})  
Local nPosQuant   := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_QUANT"})  
Local nPosRec 	  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="R_E_C_N_O_"})  
Local _cMsg		  := ""

For nX := 1 To Len(oGrid:aCols)
	If !GdDeleted(nX,aHeader,oGrid:aCols)
		If Empty(oGrid:aCols[nX][nPosProduto]) .And. Empty(oGrid:aCols[nX][nPosGrupoP])
			_cMsg += "Informe o Grupo do Produto ou o Produto na linha " + cvaltochar(nX) + CRLF
			lRet := .F.
		EndIf          
		If oGrid:aCols[nX][nPosQuant]  <= 0
			_cMsg += "Informe a quantidade em KG de consumo estimado na linha " + cvaltochar(nX) + CRLF
			lRet := .F.
		EndIf  
		If (oGrid:aCols[nX][nPosGrupoP] == oGrid:aCols[oGrid:NAT][nPosGrupoP] .And. oGrid:aCols[nX][nPosProduto] == oGrid:aCols[oGrid:NAT][nPosProduto] .And.nX != oGrid:NAT) .AND. !GdDeleted(oGrid:NAT,aHeader,oGrid:aCols)
			_cMsg += " Não é permitida a inclusão de informação repetida, verifique a linha "+AllTrim(Str(nX))+ CRLF
			lRet := .F.
			Exit
		EndIf     
		If !Empty(oGrid:aCols[nX][nPosProduto])
			DbSelectArea("SB1"); DbSetOrder(1)
			If SB1->(DbSeek(xFilial("SB1")+oGrid:aCols[nX][nPosProduto])) 
				If AllTrim(SB1->B1_GRUPO) <> AllTrim(oGrid:aCols[nX][nPosGrupoP])
					oGrid:aCols[nX][nPosGrupoP] :=  SB1->B1_GRUPO              
					oGrid:Refresh()
				EndIf
			EndIf
		EndIf		
	EndIf
Next

If !Empty(_cMsg)
	Alert(_cMsg)
EndIf

Return lRet       

User Function VQMCLILOK()
Local lRet := .T.
Local nPosProduto := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_PRODUTO"})
Local nPosGrupoP  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_GRUPO"})      
Local nPosQuant   := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_QUANT"}) 
Local _cMsg := ""

For nX := 1 To Len(oGrid:aCols)  
	If !GdDeleted(nX,aHeader,oGrid:aCols)
		If Empty(oGrid:aCols[nX][nPosProduto]) .And. Empty(oGrid:aCols[nX][nPosGrupoP])
			_cMsg += "Informe o Grupo do Produto ou o Produto na linha " + cvaltochar(nX) + CRLF
			lRet := .F.
		EndIf     
		If oGrid:aCols[nX][nPosQuant]  <= 0
			_cMsg += "Informe a quantidade em KG de consumo estimado na linha " + cvaltochar(nX) + CRLF
			lRet := .F.
		EndIf 
  		If oGrid:aCols[nX][nPosGrupoP] == oGrid:aCols[oGrid:NAT][nPosGrupoP] .And. oGrid:aCols[nX][nPosProduto] == oGrid:aCols[oGrid:NAT][nPosProduto] .And.nX != oGrid:NAT
			_cMsg += " Não é permitida a inclusão de informação repetida, verifique a linha "+AllTrim(Str(nX))+ CRLF
			lRet := .F.
			Exit
		EndIf 
		If !Empty(oGrid:aCols[nX][nPosProduto])
			DbSelectArea("SB1"); DbSetOrder(1)
			If SB1->(DbSeek(xFilial("SB1")+oGrid:aCols[nX][nPosProduto])) 
				If AllTrim(SB1->B1_GRUPO) <> AllTrim(oGrid:aCols[nX][nPosGrupoP])
					oGrid:aCols[nX][nPosGrupoP] :=  SB1->B1_GRUPO   
					oGrid:Refresh()
				EndIf
			EndIf
		EndIf		
	EndIf
Next nX  

If !Empty(_cMsg)
	Alert(_cMsg)
EndIf

Return lRet    

User Function VQATUGRUPO(cOrigem)
Local lRet := .T.               
Local nPosProduto := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_PRODUTO"})
Local nPosGrupoP  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="CT_GRUPO"})  
Local nPDscGrp 	  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="DESC_GRUPO"})
Local nPDscPrd    := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="DESC_PROD"})
Local _cGrupo	  := ""    

If cOrigem == "SBM"   
	If !Empty(M->CT_GRUPO)
		DbSelectArea("SBM"); DbSetOrder(1)
		If SBM->(DbSeek(xFilial("SBM")+M->CT_GRUPO))
			oGrid:aCols[n][nPDscGrp] := SBM->BM_DESC
		EndIf 			
	Else                                            
		oGrid:aCols[n][nPDscGrp] := ""
	EndIf
ElseIf cOrigem == "SB1"               
	If !Empty(M->CT_PRODUTO)
		DbSelectArea("SB1"); DbSetOrder(1)
		If SB1->(DbSeek(xFilial("SB1")+M->CT_PRODUTO)) 
			_cGrupo := SB1->B1_GRUPO   
			oGrid:aCols[n][nPosGrupoP]	:=  _cGrupo
			oGrid:aCols[n][nPDscPrd] 	:=  SB1->B1_DESC
			DbSelectArea("SBM"); DbSetOrder(1)
			If SBM->(DbSeek(xFilial("SBM")+_cGrupo))
				oGrid:aCols[n][nPDscGrp] := SBM->BM_DESC
			EndIf 		
		EndIf                  
	Else
		oGrid:aCols[n][nPDscPrd] 	:=  ""
	EndIf
EndIf                      
oGrid:Refresh()
Return lRet

Static Function VQMCLIGRAF()
    Local oChart
    Local oDlg
    Local aRand := {}
     
    //Cria a Janela
    DEFINE MSDIALOG oDlg PIXEL FROM 0,0 TO 400,600
        //Instância a classe
        oChart := FWChartBar():New()
         
        //Inicializa pertencendo a janela
        oChart:Init(oDlg, .T., .T. )
         
        //Seta o título do gráfico
        oChart:SetTitle("Cons. Estimado - Produto AB9", CONTROL_ALIGN_CENTER)
         
        //Adiciona as séries, com as descrições e valores
        oChart:addSerie("Janeiro 2017", 20044453.50)
        oChart:addSerie("Fevereiro 2017", 21044453.35)
        oChart:addSerie("Março 2017", 22044453.15)
        oChart:addSerie("Abril 2017", 23044453.10)
        oChart:addSerie("Maio 2017", 25544453.01)
         
        //Define que a legenda será mostrada na esquerda
        oChart:setLegend( CONTROL_ALIGN_LEFT )
         
        //Seta a máscara mostrada na régua
        oChart:cPicture := "@E 999,999,999,999,999.99"
         
        //Define as cores que serão utilizadas no gráfico
        aAdd(aRand, {"084,120,164", "007,013,017"})
        aAdd(aRand, {"171,225,108", "017,019,010"})
        aAdd(aRand, {"207,136,077", "020,020,006"})
        aAdd(aRand, {"166,085,082", "017,007,007"})
        aAdd(aRand, {"130,130,130", "008,008,008"})
         
        //Seta as cores utilizadas
        oChart:oFWChartColor:aRandom := aRand
        oChart:oFWChartColor:SetColor("Random")

        oChart:Build()
    ACTIVATE MSDIALOG oDlg CENTERED
Return                            
          




/*
aAdd(aRand, {"199,199,070", "022,022,008"}) //Amarelo Escuro
aAdd(aRand, {"084,120,164", "007,013,017"}) //Azul Claro
aAdd(aRand, {"054,090,134", "007,013,017"}) //Azul Escuro
aAdd(aRand, {"175,175,175", "011,011,011"}) //Cinza Claro
aAdd(aRand, {"130,130,130", "008,008,008"}) //Cinza Médio
aAdd(aRand, {"100,100,100", "008,008,008"}) //Cinza Escuro
aAdd(aRand, {"207,136,077", "020,020,006"}) //Laranja Claro
aAdd(aRand, {"177,106,047", "020,020,006"}) //Laranja Escuro
aAdd(aRand, {"001,001,001", "001,001,001"}) //Preto
aAdd(aRand, {"141,225,078", "017,019,010"}) //Verde Claro
aAdd(aRand, {"171,225,108", "017,019,010"}) //Verde Escuro
aAdd(aRand, {"166,085,082", "017,007,007"}) //Vermelho Claro
aAdd(aRand, {"136,055,052", "017,007,007"}) //Vermelho Escuro

*/

User Function GRMETCLI(_cNotSer)
Local _cQuery 	:= ""
Local _cCodCli	:= ""
Local _cLojCli 	:= ""
Local _cRegCli	:= ""
Local _cDivCli	:= ""
Local _cAlias 	:= GetNextAlias()
Local _aConsC	:= {}

If SF2->(DbSeek(xFilial("SF2")+_cNotSer))     
	_cCodCli := SF2->F2_CLIENTE
	_cLojCli := SF2->F2_LOJA
EndIf  

If SA1->(DbSeek(xFilial("SA1")+_cCodCli+_cLojCli))
	_cRegCli := SA1->A1_REGIAO
	_cDivCli := SA1->A1_GRPVEN 
Else 
	Return
EndIf

_cQuery := VQGCMETA(_cCodCli, _cLojCli)

If Select((_cAlias)) > 0
	_cAlias->(DbCloseArea())
EndIf 

TcQuery _cQuery New Alias _cAlias

While !_cAlias->(Eof()) 
	Aadd(_aConsC,{_cAlias->CT_DOC, _cAlias->CT_SEQUEN, _cAlias->CT_DATA , _cAlias->CT_REGIAO , _cAlias->CT_GRPCLI , _cAlias->CT_GRUPO , _cAlias->CT_PRODUTO , _cAlias->CT_QUANT })     
	_cAlias->(DbSkip())
EndDo  
    
If Len(_aConsC) == 0   
	BEGIN TRANSACTION
		_cNumDoc := GETSXENUM("SCT","CT_DOC")  
		_nSeq := 1    
		If SD2->(DbSeek(xFilial("SD2")+_cNotSer))
			While !SD2->(Eof()) .And. _cNotSer == SD2->(D2_DOC+D2_SERIE)
				If SD2->D2_TP $ "PA/MP"
					If RecLock("SCT", .T.)
							SCT->CT_FILIAL 	:= 	XFILIAL("SCT")
			  				SCT->CT_DOC		:=  _cNumDoc
				  			SCT->CT_SEQUEN	:= 	STRZERO(_nSeq,3)
				 	 		SCT->CT_DESCRI	:= 	"INCLUSAO AUTOMATICA FATURAMENTO"
			  				SCT->CT_DATA	:=	Date()    
			  				SCT->CT_CLIENTE	:= 	_cCodCli
			  				SCT->CT_LOJA	:=	_cLojCli
							SCT->CT_REGIAO	:=	_cRegCli
							SCT->CT_GRPCLI	:=  _cDivCli
					  		SCT->CT_VEND	:=	""
					  		SCT->CT_GRUPO	:=  SD2->D2_GRUPO
					  		SCT->CT_PRODUTO	:=	""
					  		SCT->CT_QUANT	:=	SD2->D2_QUANT
					  		SCT->CT_VALOR	:=	1
					  		SCT->CT_MOEDA	:=	1
					  		SCT->CT_VQ_GAUT	:=	"A"  
						MsUnlock() 
				   		_nSeq += 1                    
					Else 
						RollBackSx8()
					EndIf
				EndIf 
			SD2->(DbSkip())
			EndDo      
			ConfirmSX8()
		EndIf 
	END TRANSACTION
Else     
	BEGIN TRANSACTION
		_cNumDoc := _aConsC[1][1]
		_nSeq := Val(_aConsC[Len(_aConsC)][2])+1 
		If SD2->(DbSeek(xFilial("SD2")+_cNotSer))
			While !SD2->(Eof()) .And. _cNotSer == SD2->(D2_DOC+D2_SERIE)
				_nPos := AScan(_aConsC, {|x| ALLTRIM(UPPER(x[6])) == ALLTRIM(UPPER(SD2->D2_GRUPO))})
				If _nPos = 0
					If SD2->D2_TP $ "PA/MP"
						RecLock("SCT", .T.)
						SCT->CT_FILIAL 	:= 	XFILIAL("SCT")
		  				SCT->CT_DOC		:=  _cNumDoc
			  			SCT->CT_SEQUEN	:= 	STRZERO(_nSeq,3)
			 	 		SCT->CT_DESCRI	:= 	"INCLUSAO AUTOMATICA FATURAMENTO"
		  				SCT->CT_DATA	:=	Date()    
		  				SCT->CT_CLIENTE	:= 	_cCodCli
		  				SCT->CT_LOJA	:=	_cLojCli
						SCT->CT_REGIAO	:=	_cRegCli
						SCT->CT_GRPCLI	:=  _cDivCli
				  		SCT->CT_VEND	:=	""
				  		SCT->CT_GRUPO	:=  SD2->D2_GRUPO
				  		SCT->CT_PRODUTO	:=	""
				  		SCT->CT_QUANT	:=	SD2->D2_QUANT
				  		SCT->CT_VALOR	:=	1
				  		SCT->CT_MOEDA	:=	1
				  		SCT->CT_VQ_GAUT	:=	"A"
						MsUnlock()
						_nSeq += 1 					
					EndIf                      
				EndIf
				SD2->(DbSkip())
			EndDo
		EndIf  
	END TRANSACTION
EndIf      

_cAlias->(DbCloseArea())

Return()