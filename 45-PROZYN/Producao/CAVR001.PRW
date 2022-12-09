#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} CAVR001
//TODO Relatório quantidade de produtos com mesma estrutura .
@author carlos
@since 06/07/2019
@version 1.0
@return ${return}, ${return_description}
@param cMvPar, characters, descricao
@param xValor, , descricao
@param cTipo, characters, descricao
@param cDescP, characters, descricao
@param cDescS, characters, descricao
@param cDescE, characters, descricao
@param lAlter, logical, descricao
@type function
/*/
User Function CAVR001()  
	Local aPergs		:= {}
	Local aRet			:={} 
	Local cTpRel		:= ""
	Private oTempTable
    Private cAliTMP1	:= GetNextAlias()
    
    
    aAdd( aPergs ,{2,"Relatorio",1, {"Sintético", "Analitico"}, 50,'.T.',.T.})   
    If ParamBox(aPergs ,"Produtos com mesma estrutura ",aRet) 
    	If ValType(MV_PAR01) == "N"
    		If MV_PAR01 == 1
    			cTpRel := "S"
    		Else
    			cTpRel := "A"
    		EndIF
    	Else
    		cTpRel := Left(MV_PAR01,1)
    	EndIf
	    Processa( {|| ProcReport() }, "Aguarde...", "Analisando Base...",.F.)
	    Processa( {|| MontaResult(cTpRel) }, "Aguarde...", "Gerando relatorio...",.F.)
	EndIF
	   
Return

Static Function ProcReport()
    Local cAliRep   := GetNextAlias()
    Local aFields	:= {}
    Local cQuery 	:= ""
    Local aChave    := {}
    
    

    DbSelectArea("SG1")
    DbSetOrder(2) //G1_FILIAL+G1_COMP+G1_COD
        

    MontaTmp1()
    
    DbSelectArea(cAliTMP1)
    DbSetOrder(2) //COD1

	cQuery := QryMontaComp()
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliRep,.T.,.F.)



    While !(cAliRep)->(EOF())
    	IncProc("Processando - Componente: " + (cAliRep)->(G1_COMP) )
    	ProcessMessage()
        
        If Empty(aChave)
            AADD(aChave, {(cAliRep)->(G1_FILIAL)   , "G1_FILIAL"})
            AADD(aChave, {(cAliRep)->(G1_COMP)     , "G1_COMP"})
            AADD(aChave, {(cAliRep)->(G1_TIPO)     , "G1_TIPO"})
            AADD(aChave, {(cAliRep)->(G1_QUANT)    , "G1_QUANT"})
            AADD(aChave, {(cAliRep)->(G1_ATIVIDA)  , "G1_ATIVIDA"})
        EndIf

        

        If  aChave[1,1] == (cAliRep)->(G1_FILIAL)   .and. ;
            aChave[2,1] == (cAliRep)->(G1_COMP)     .and. ;
            aChave[3,1] == (cAliRep)->(G1_TIPO)     .and. ;
            aChave[4,1] == (cAliRep)->(G1_QUANT)    .and. ;
            aChave[5,1] == (cAliRep)->(G1_ATIVIDA)
        Else
            Procuraprod(aChave)
            ASize(aChave, 0) 
            aChave := {}
        EndIf 
        (cAliRep)->(DbSkip())
    End


    

Return


Static Function Procuraprod(aChave)

    Local cQuery    := ""
    Local nx        := 0
    Local ny		:= 0
    Local cAliIgual := GetNextAlias()
    Local aEstrut	:= {}
    Local aEstCom	:= {}
    Local cProd		:= ""
    Local cProdDif	:= ""
    Local aAux		:= {}
    Local lIgual	:= .T.

    cQuery := " SELECT" 
    cQuery += " G1_FILIAL,"
    cQuery += " G1_COD,"
    cQuery += " G1_COMP,"
    cQuery += " G1_TIPO,"
    cQuery += " G1_QUANT,"
    cQuery += " G1_ATIVIDA"  

    cQuery += " FROM " + RetSqlName("SG1") + " SG1"
    
    cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1"
    cQuery += " ON B1_FILIAL = '" + FwxFilial("SB1") + "'"
    cQuery += " AND B1_COD = G1_COMP"
    cQuery += " AND SB1.D_E_L_E_T_ = '" + Space(1) + "'"
    
    cQuery += " WHERE G1_FILIAL = '" + FwxFilial("SG1") + "'"
    cQuery += " AND G1_COD IN "
    	cQuery += "(SELECT G1_COD FROM " + RetSqlName("SG1") + " SG"
	    cQuery += " WHERE "
	    
	    For nx:=1 to Len(aChave)
	        If ValType(aChave[nx,1]) == "C"
	            cQuery += aChave[nx,2] + " = '" + aChave[nx,1] + "'"
	        ElseIf ValType(aChave[nx,1]) == "N"
	            cQuery += aChave[nx,2] + " = '" + AllTrim(Str(aChave[nx,1])) + "'"
	        ElseIf ValType(aChave[nx,1]) == "D"
	            cQuery += aChave[nx,2] + " = '" + DtoS(aChave[nx,1]) + "'"
	        ElseIf ValType(aChave[nx,1]) == "L"
	            cQuery += aChave[nx,2] + " = '" + IIf(aChave[nx,1],"T" , "F") + "'"
	        EndIf
	        
	        cQuery += " AND "
	    Next 
	    cQuery += " SG.D_E_L_E_T_ = ' ') "
	cQuery += " AND SG1.D_E_L_E_T_ = ' ' "
	cQuery += " AND B1_TIPO <> 'MO'"

	cQuery += " ORDER BY"
	cQuery += " G1_FILIAL, G1_COD, G1_COMP,"
	cQuery += " G1_TIPO,"
	cQuery += " G1_QUANT,"
	cQuery += " G1_ATIVIDA"
	
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliIgual,.T.,.F.)
    
    While !(cAliIgual)->(EOF())
    	If !(cAliTMP1)->(DbSeek((cAliIgual)->(G1_COD)))
    		If Empty(cProd)
    			cProd := (cAliIgual)->(G1_COD)
    		EndIf
    		
    		If AllTrim(cProd) == '000030'
    			Conout("Teste")
    		EndIf
	    	If cProd == (cAliIgual)->(G1_COD)
	    		aSize(aAux,0)
	    		aAux := {}
	    		AADD(aAux, (cAliIgual)->(G1_FILIAL))
	    		AADD(aAux, (cAliIgual)->(G1_COMP))
	    		AADD(aAux, (cAliIgual)->(G1_TIPO))
	    		AADD(aAux, (cAliIgual)->(G1_QUANT))
	    		AADD(aAux, (cAliIgual)->(G1_ATIVIDA))
	    		AADD(aEstrut, aClone(aAux))
	    	Else
	    		If Empty(cProdDif)
	    			cProdDif := (cAliIgual)->(G1_COD)
	    			
	    			If (cAliTMP1)->(RecLock(cAliTMP1, .T.))
	    				(cAliTMP1)->(CODPRO)	:= cProd
	    				(cAliTMP1)->(COD1)		:= cProd
	    				(cAliTMP1)->(MsUnLock())
	    			EndIf
	    		EndIf
	    		
	    		If cProdDif == (cAliIgual)->(G1_COD)
	    			
	    		Else
	    			If Len(aEstrut) == Len(aEstCom)
		    			For ny:=1 to Len(aEstrut)
		    			
		    				For nx:=1 to Len(aEstrut[ny])
		    					If aEstrut[ny,nx] <> aEstCom[ny,nx]
		    						lIgual := .F.
		    						Exit
		    					EndIf
		    				Next nx
		    				If !lIgual
		    					Exit
		    				EndIf
		    			Next ny
		    		Else
		    			lIgual := .F.
		    		EndIf
		    		
		    		If lIgual
		    			If !(cAliTMP1)->(DbSeek(cProdDif))
		    				If (cAliTMP1)->(RecLock(cAliTMP1, .T.))
			    				(cAliTMP1)->(CODPRO)	:= cProd
			    				(cAliTMP1)->(COD1)		:= cProdDif
			    				(cAliTMP1)->(MsUnLock())
			    			EndIf
			    		EndIf
		    		EndIf
		    		
		    		aSize(aEstCom,0)
	    			aEstCom := {}
	    			lIgual := .T.
	    			cProdDif := (cAliIgual)->(G1_COD)
	    				
	    		EndIf
	    		aSize(aAux,0)
	    		aAux := {}
	    		AADD(aAux, (cAliIgual)->(G1_FILIAL))
	    		AADD(aAux, (cAliIgual)->(G1_COMP))
	    		AADD(aAux, (cAliIgual)->(G1_TIPO))
	    		AADD(aAux, (cAliIgual)->(G1_QUANT))
	    		AADD(aAux, (cAliIgual)->(G1_ATIVIDA))

	    		AADD(aEstCom, aClone(aAux))		
	    		
	    	EndIf
	    EndIf

        (cAliIgual)->(DbSkip())
    End

    (cAliIgual)->(DbCloseArea())

Return

Static Function MontaResult(cTpRel)

	Local oFWMsExcel
    Local oExcel
    Local cHora 	:= StrTran( Time(), ":", "" )
    Local cArquivo  := GetTempPath()+ "\PRODEST" + cHora + ".XML"
	Local cQuery	:= ""
	Local cAliTemp	:= GetNextAlias()
	Local aExcel	:= {}
	
	oFWMsExcel := FWMSExcel():New()
     

    oFWMsExcel:AddworkSheet("Lista Produtos")

    oFWMsExcel:AddTable("Lista Produtos","Mesma Estrutura")
    oFWMsExcel:AddColumn("Lista Produtos","Mesma Estrutura","Produto"		,1,1) //1 = Modo Texto
    oFWMsExcel:AddColumn("Lista Produtos","Mesma Estrutura","Desc Produto"	,1,1) //1 = Modo Texto
    oFWMsExcel:AddColumn("Lista Produtos","Mesma Estrutura","Tipo Prod"		,1,1) //1 = Modo Texto
    oFWMsExcel:AddColumn("Lista Produtos","Mesma Estrutura","Ativo"		,1,1) //1 = Modo Texto
    If cTpRel == "A"
	    oFWMsExcel:AddColumn("Lista Produtos","Mesma Estrutura","Semelhante"	,1,1) //1 = Modo Texto
	    oFWMsExcel:AddColumn("Lista Produtos","Mesma Estrutura","Desc Semelhante",1,1) //1 = Modo Texto
	    oFWMsExcel:AddColumn("Lista Produtos","Mesma Estrutura","Tipo Semelhante",1,1) //1 = Modo Texto
	    oFWMsExcel:AddColumn("Lista Produtos","Mesma Estrutura","Ativo Semelhante",1,1) //1 = Modo Texto
	Else
	    oFWMsExcel:AddColumn("Lista Produtos","Mesma Estrutura","Qtd Prod",2,2) //2 = Valor sem R$
	EndIf
    
    
    If cTpRel == "A"
    	cQuery := " SELECT CODPRO, SB1.B1_DESC DESCRI, SB1.B1_TIPO TIPO, SB1.B1_ATIVO ATIVO, COD1 TOTAL, "
    	cQuery += " REP.B1_DESC RDESC, REP.B1_TIPO RTIPO, REP.B1_ATIVO RATIVO"
    	cQuery += " FROM "+ oTempTable:GetRealName() + " COM "
    	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1"
    	cQuery += " ON B1_FILIAL = '" + FwxFilial("SB1") + "'"
    	cQuery += " AND B1_COD = CODPRO "
    	cQuery += " AND SB1.D_E_L_E_T_ = ' ' " 
    	cQuery += " INNER JOIN " + RetSqlName("SB1") + " REP"
    	cQuery += " ON REP.B1_FILIAL = '" + FwxFilial("SB1") + "'"
    	cQuery += " AND REP.B1_COD = COD1 "
    	cQuery += " AND REP.D_E_L_E_T_ = ' ' " 
    	
    	cQuery += " WHERE COM.D_E_L_E_T_ = ' ' "
    	cQuery += " AND CODPRO <> COD1" 
    Else
    	cQuery := " SELECT CODPRO, B1_DESC DESCRI, B1_TIPO TIPO, SB1.B1_ATIVO ATIVO, COUNT(COD1) TOTAL "
    	cQuery += " FROM "+ oTempTable:GetRealName() + " COM"
    	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1"
    	cQuery += " ON B1_FILIAL = '" + FwxFilial("SB1") + "'"
    	cQuery += " AND B1_COD = CODPRO "
    	cQuery += " AND SB1.D_E_L_E_T_ = ' ' " 
    	cQuery += " WHERE COM.D_E_L_E_T_ = ' ' "
    	cQuery += " AND CODPRO <> COD1"
    	cQuery += " GROUP BY CODPRO, B1_DESC, B1_TIPO, SB1.B1_ATIVO"
    EndIf
    
    cQuery += " ORDER BY CODPRO
	
	MPSysOpenQuery( cQuery, cAliTemp )

    DbSelectArea(cAliTemp)

    While !(cAliTemp)->(Eof())
        
        IncProc("Processando planilha - " + (cAliTemp)->(CODPRO) )
        ProcessMessage()
        
        Asize(aExcel, 0)
        aExcel := {}
        
    	AADD(aExcel, (cAliTemp)->(CODPRO))
    	AADD(aExcel, (cAliTemp)->(DESCRI))
    	AADD(aExcel, (cAliTemp)->(TIPO))
    	AADD(aExcel, Iif((cAliTemp)->(ATIVO) == 'N', "Não", "Sim"))
    	AADD(aExcel, (cAliTemp)->(TOTAL))    	
    	If cTpRel == "A" 
    		AADD(aExcel, (cAliTemp)->(RDESC))
    		AADD(aExcel, (cAliTemp)->(RTIPO))
    		AADD(aExcel, Iif((cAliTemp)->(RATIVO) == 'N', "Não", "Sim"))
    	EndIf
   	
    	oFWMsExcel:AddRow("Lista Produtos","Mesma Estrutura",aClone(aExcel))

        (cAliTemp)->(DbSkip())
    Enddo
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
    
      
	//Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
 
	oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas 
	
    oTempTable:Delete() 
     
    (cAliTemp)->(DbCloseArea())
    MsgAlert("Fim de processamento")
Return

Static Function MontaTmp1()
    Local aFields   := {}
    Local aTamSX3   := {}
    Local cQuery    := ""

    //-------------------
    //Criação do objeto
    //-------------------
    oTempTable := FWTemporaryTable():New( cAliTMP1 )

    //--------------------------
    //Monta os campos da tabela
    //--------------------------

    aTamSX3 := TamSx3("G1_COD")
    aadd(aFields,{"CODPRO",aTamSX3[3],aTamSX3[1],aTamSX3[2]})
    aadd(aFields,{"COD1",aTamSX3[3],aTamSX3[1],aTamSX3[2]})


    oTemptable:SetFields( aFields )
    oTempTable:AddIndex("indice1", {"CODPRO","COD1"} )
    oTempTable:AddIndex("indice2", {"COD1" } )
    //------------------
    //Criação da tabela
    //------------------
    oTempTable:Create()
Return 


Static Function QryMontaComp()
    Local cQuery    := ""


    cQuery := " SELECT" 
    cQuery += " G1_FILIAL,"
    cQuery += " G1_COMP,"
    cQuery += " G1_TIPO,"
    cQuery += " G1_QUANT,"
    cQuery += " G1_ATIVIDA,"
    cQuery += " COUNT( G1_COD) QTDPROD"

    cQuery += " FROM " + RetSqlName("SG1") + " SG1"
    cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1"
    cQuery += " ON B1_FILIAL = '" + FwxFilial("SB1") + "'"
    cQuery += " AND B1_COD = G1_COMP"
    cQuery += " AND SB1.D_E_L_E_T_ = '" + Space(1) + "'"
    cQuery += " WHERE G1_FILIAL = '" + FwxFilial("SG1") + "'"
    cQuery += " AND SG1.D_E_L_E_T_ = ' ' "
    cQuery += " AND SB1.B1_TIPO <> 'MO'"
    cQuery += " GROUP BY"
    cQuery += " G1_FILIAL,"
    cQuery += " G1_COMP,"
    cQuery += " G1_TIPO,"
    cQuery += " G1_QUANT,"
    cQuery += " G1_ATIVIDA"
  
    cQuery += " HAVING COUNT( G1_COD) > 1"
    
    cQuery += " ORDER BY"
    cQuery += " G1_FILIAL,"
    cQuery += " G1_COMP,"
    cQuery += " G1_TIPO,"
    cQuery += " G1_QUANT,"
    cQuery += " G1_ATIVIDA"
    
    
Return cQuery