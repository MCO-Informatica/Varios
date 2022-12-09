#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "FILEIO.ch"

# DEFINE BLOCO 400

/*
Funcao: ORCHCIBR
Descricao: Atualiza os itens do orcamenTO de venda, baseado num arquivo CSV
*/

User Function ORCHCIBR()

	Private FileProds

	@ 50,1 TO 420,410 DIALOG oReadTxt TITLE OemTOAnsi("Leitura de Arquivo TexTO - HCIBR")
	@ 02,10 TO 180,190
	@ 10,018  Say " Este programa ira ler o conteudo de um arquivo texTO, "
	@ 18,018  Say " inserindo TOdos os itens de seu conteúdo dentro do    "
	@ 26,018  Say " orçamenTO ativo                                       "
	@ 34,018  Say " Sequencia de campos:                                  "
	@ 42,018  Say " Coluna (A) --> Codigo Prod Protheus                   "
	@ 50,018  Say " Coluna (B) --> Quantidade                             "
	@ 58,018  Say " Coluna (C) --> R$ Unitario                            "
	@ 66,018  Say " Coluna (D) --> Prazo                                  "
	@ 74,018  Say " Coluna (E) --> Tecnico                                "
	@ 82,018  Say " Coluna (F) --> Obs Item                               "
	@ 90,018  Say " Coluna (G) --> Referencia do Cliente                  "
	@ 98,018  Say " Coluna (H) --> Pedido do Cliente                      "
	@ 106,018 Say " Coluna (I) --> Item do Cliente                        " 
	@ 114,018 Say " Coluna (J) --> IPI									  "
	@ 130,50  Get FileProds                      Size 100,10 when.F.
	@ 130,145 BUTTON "..."                       SIZE 10,10 ACTION FileProds := OpenFile()
	@ 160,128 BMPBUTTON TYPE 01 ACTION ReadyFileTxt()
	@ 160,158 BMPBUTTON TYPE 02 ACTION Close(oReadTxt)
	
	Activate Dialog oReadTxt Centered

RETURN

/*
Funcao: ReadyFileTxt                       
Descricao: Funcao chamada pelo botao OK na tela inicial de processameTO
*/

Static Function ReadyFileTxt
	
	Private cFileTxt := FileProds
	Private nHdl    := fOpen(FileProds,68)
	Private nLog    := fCreate("c:\Import.log")
	Private cEOL    := "CHR(13)+CHR(10)"
	
	IF Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	ELSE
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	EndIF
	
	IF nHdl == -1
		MsgAlert("O arquivo de nome "+cFileTxt+" nao pode ser aberTO! VerIFique os parametros.","Atencao!")
		RETURN
	EndIF
	
	Processa({|| ReadCount() },"Processando...")
	
RETURN       


Static Function ReadCount
                           
	Local aArea		:= GetArea()
	Local nTamFile, cBuffer, nBtLidos, cCod
	Local nIni, nFim, nPos, nSize
	Local lPode		:=.T.
	Local aOrc 		:= Array(10)
	Local nRegLido	:=1
	
	//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
	//º Lay-Out do arquivo TexTO lido  :                                º
	//ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
	//ºCampo           ³ Descrição                                      º
	//ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
	//º CK_PRODUTO     ³ Codigo do ProduTO                              ºnPos = 1
	//º CK_NUMREF      ³ Referencia do ProduTO no Cliente               ºnPos = 2
	//º CK_QTDVEN      ³ Quantidade do ProduTO                          ºnPos = 3
	//º CK_ITEMCLI     ³ Numero do Item no Cliente                      ºnPos = 4
	//º CK_PROJETO     ³ Referencia do Cliente                          ºnPos = 5
	//º CK_OBS         ³ Observacao                                     ºnPos = 6
	//º CK_PRCVEN      ³ Valor Unitario                                 ºnPos = 7
	//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
	/* 
	@ 42,018  Say " Coluna (01) --> Codigo Prod Protheus                   "
	@ 50,018  Say " Coluna (02) --> Quantidade                             "
	@ 58,018  Say " Coluna (03) --> R$ Unitario                            "
	@ 66,018  Say " Coluna (04) --> Prazo                                  "
	@ 74,018  Say " Coluna (05) --> Tecnico                                "
	@ 74,018  Say " Coluna (06) --> Obs Item                               "
	@ 82,018  Say " Coluna (07) --> Referencia do Cliente                  "
	@ 90,018  Say " Coluna (08) --> Pedido do Cliente                      "
	@ 98,018  Say " Coluna (09) --> Item do Cliente                        " 
	@ 106,018 Say " Coluna (10) --> IPI									  "
	*/
	
	nBtLidos := 0
	nTamFile := FSEEK(nHdl, 0, FS_END) //Troquei funcao de tamanho do arquivo
	fSeek(nHdl,0,0) //resetando posicao do ponteiro                                          
	ProcRegua(nTamFile) // Numero de registros a processar
	
	               
	While nBtLidos < (nTamFile -2)            //Caracteres de fim de arquivo                             
	 	//Pega Linha a linha do arquivo  
	    cBuffer  := SPACE(BLOCO) // Variavel para criacao da linha do registro para leitura
	    fRead(nHdl,@cBuffer,BLOCO)
		
	 	FOR nSize:=1 TO Len(cBuffer)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Incrementa a regua                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc()
	 	
	 	  	IF (Substr(cBuffer,nSize,1)=Chr(13))	    
	   	      fSeek(nHdl, nBtLidos) 
	   	      nSize	++
	 	      exit                  	    
	 	  	EndIF    
	 	End             	 	 	
	 	
	 	fRead(nHdl,@cBuffer, nSize)  	  
		nBtLidos := nBtLidos + nSize
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os campos obtendo os valores da linha lida do arquivo texTO.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Valores Iniciais para busca dos campos
		      
		//Controles de quebra por ponTO e virgula 
		nIni := 1 //Posicao inicial na linha
		nFim := 1 //Posicao Final na linha                          
		nPos := 1 //Campo do VeTOr
		
		While .T.                      
	      lPode:=.t.
	      cCod:=""
	      IF (Substr(cBuffer, nFim, 1) != ';') .And. (Substr(cBuffer, nFim, 1) != Chr(13))  
	        nFim ++
	      ELSE
	        IF (Substr(cBuffer, nIni, nFim-nIni)!=Chr(13)) .And. (Substr(cBuffer, nIni, nFim-nIni)!=";") //Se Campo cheio
	        	aOrc[nPos] := Substr(cBuffer, nIni, nFim-nIni) //Alimenta
	        ELSE              
	            aOrc[nPos] := ""      		                   //senao deixa em branco
	        EndIF
	
	        IF (Substr(cBuffer, nFim, 1)==Chr(13)) //Fim da Linha sai do laco
			  exit                               
			EndIF
	
			nPos ++		
			nFim ++
			nIni  := nFim		  
	      EndIF        
	    End
	    cCod:=""
	    FOR xEsp:=1 TO Len(aOrc[1])
	     IF SUBSTRING(aOrc[1],xEsp,1)=" " 
	     ELSE
	      cCod:=cCod+SUBSTRING(aOrc[1],xEsp,1)
	     EndIF   
	    next
	    IF Len(cCod)>0 
	      aOrc[1]:=cCod
	    EndIF  
	    dbSelectArea("SB1")
		dbSeTOrder(1)
	 	IF dbSeek(xFilial()+aOrc[1])     
		ELSE              
				MsgAlert("Registro:["+str(nRegLido)+"]ProduTO "+ aOrc[1] +" inexistente.... Incluindo!")	
				dbSelectArea("SBP")
				DBGOTOP()
				cCod:=A093MontaCod(aOrc[1],.T.)
				IF Len(trim(cCod))>0 
				  aOrc[1]:=cCod
				  A093VldCod(cCod,.T.)
				ELSE
				  A093VldCod(aOrc[1],.T.)
				EndIF
				dbSelectArea("SB1")
				dbSeTOrder(1)
	            IF dbSeek(xFilial()+aOrc[1])
	            ELSE
	              MsgAlert("Registro:["+str(nRegLido)+"]ProduTO "+ aOrc[1] +" Impossivel de ser incluido!")	
	              lpode:=.f.
	            EndIF      
		EndIF	                     	
		IF (lPode=.t.)
	  	    dbSelectArea("TMP1")
	 		
	 		TMP1->(dbGoBotTOm())
	  	    IF (Empty(TMP1->CK_PRODUTO)) //Se planilha vazia, edita a primeira linha (em branco)
	    	    RecLock("TMP1", .F.)
	   		ELSE
	    	    RecLock("TMP1", .T.)
	    	EndIF
	    	      	              
	    	//PREENCHE DADOS VINDOS DO ARQUIVO
		   /* 
	       @ 42,018  Say " Coluna (01) --> Codigo Prod Protheus                   "
	       @ 50,018  Say " Coluna (02) --> Quantidade                             "
	       @ 58,018  Say " Coluna (03) --> R$ Unitario                            "
	       @ 66,018  Say " Coluna (04) --> Prazo                                  "
	       @ 74,018  Say " Coluna (05) --> Tecnico                                "
	       @ 74,018  Say " Coluna (06) --> Obs Item                               "
	       @ 82,018  Say " Coluna (07) --> Referencia do Cliente                  "
	       @ 90,018  Say " Coluna (08) --> Pedido do Cliente                      "
	       @ 98,018  Say " Coluna (09) --> Item do Cliente                        " 
	       @ 106,018 Say " Coluna (10) --> IPI									  "
	
	*/
			 	      	    
			TMP1->CK_ITEM    := strzero(TMP1->(RecNo()),2)
	  	    TMP1->CK_PRODUTO := aOrc[1] 
	  	    TMP1->CK_QTDVEN  := U_HCCVAL(aOrc[2])
	  		TMP1->CK_PRCVEN  := U_HCCVAL(aOrc[3])
	  	    TMP1->CK_XDIAS   := val(aOrc[4])
	  	    TMP1->CK_DSCTEC  := u_matatec(aOrc[1]) 
	  	    TMP1->CK_OBS     := aOrc[6]      	    
	  	    TMP1->CK_NUMREF  := aOrc[7]
	  	    TMP1->CK_PV      := aOrc[8]
	        TMP1->CK_ITEMCLI := aOrc[9]                       
	        
	        TMP1->CK_VALOR   := TMP1->CK_QTDVEN*TMP1->CK_PRCVEN
	        TMP1->CK_ENTREG  := DATE() + val(aOrc[4])
	        TMP1->CK_TABPRC	 := "INF"
	        TMP1->CK_FILENT  :=SM0->M0_CODFIL
	        TMP1->CK_FILVEN  :=SM0->M0_CODFIL 
	        TMP1->CK_FONTE   := "000000"
	        TMP1->CK_DTVALID := DATE()+30
	        //PREENCHE DADOS VINDOS DE PRODUTOS (SB1)
			IF (FieldPos("CK_UM") > 0 )
				TMP1->CK_UM       := SB1->B1_UM
			EndIF
			IF (FieldPos("CK_TES") > 0 )
				IF (!Empty(RetFldProd(SB1->B1_COD,"B1_TS")))
					TMP1->CK_TES      := RetFldProd(SB1->B1_COD,"B1_TS")
				ELSE
					TMP1->CK_TES      := A415TesPad()
				EndIF
			EndIF
			IF Posicione("SF4",1,xFilial("SF4")+TMP1->CK_TES,"F4_IPI")="S"
			  TMP1->CK_IPI=5.00
			ELSE
			  TMP1->CK_IPI=0
			EndIF    
			IF (FieldPos("CK_LOCAL") > 0 )
				TMP1->CK_LOCAL    := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
			EndIF
			IF (FieldPos("CK_COMIS1") > 0 )
				TMP1->CK_COMIS1   := SB1->B1_COMIS
			EndIF
			IF (FieldPos("CK_DESCRI") > 0 )
				TMP1->CK_DESCRI   := SB1->B1_DESC
			EndIF
			IF (FieldPos("CK_CONTRAT") > 0 )
				TMP1->CK_CONTRAT := ""
			EndIF
			IF (FieldPos("CK_ITEMCON") > 0 )
				TMP1->CK_ITEMCON := ""
			EndIF        
	        
	        MsUnlock("TMP1")
	      ELSE 
	        MsgAlert("Tamanho do registro iniciado em "+ aOrc[1] +" inválido !")		  
	      EndIF
	      nRegLido++
	End	

	FClose(nLog)
	fClose(nHdl)                
	RestArea(aArea)
	Close(oReadTxt)               
RETURN

Static function OpenFile()

	cFileTxt	:= cGetFile("*.csv|*.csv","Importacao de OrçamenTO",1,"C:\",.F.,GETF_LOCALHARD) 
	
	IF Empty(cFileTxt)
		RETURN .F.
	EndIF
	
	cFileTxt = ALLTRIM(cFileTxt)
	
RETURN (cFileTxt)   