#include "rwmake.ch"
#include 'topconn.ch'
	 

User Function XMLNFe()

Private cPerg := "IMPX3L"
Private aProd := {}
Private aCampos := {}   
Private oMark
Private oDlgXML

ValidPerg()

If !Pergunte(cPerg,.T.)
	return
Endif	

aCampos := {}
nXML := 0
//cCaminho 	:= "\XMLNFE\*.*"
//cDiretor  := "\XMLNFE\"

cCaminho 	:= alltrim(MV_PAR01) + "*.*"
cDiretor    := alltrim(MV_PAR01)
nAcao       := MV_PAR02
nPC         := MV_PAR03
nValCNPJ    := MV_PAR04
nIncAma     := MV_PAR05

AADD(aCampos,{"OK",         "C",002,0})
AADD(aCampos,{"TIPO",       "C",010,0})
AADD(aCampos,{"CODIGO",     "C",TAMSX3('A2_COD')[1],0})
AADD(aCampos,{"LOJA",       "C",TAMSX3('A2_LOJA')[1],0})
AADD(aCampos,{"RAZAO",      "C",TAMSX3('A2_NOME')[1],0})
AADD(aCampos,{"DOCUMENTO",  "C",TAMSX3('F1_DOC')[1],0})
AADD(aCampos,{"SERIE",      "C",TAMSX3('F1_SERIE')[1],0})
AADD(aCampos,{"XML",        "C",100,0})

cArq := CriaTrab(aCampos)

If Select("TMP") > 0
	TMP->(dbCloseArea())
Endif

DbUseArea( .T.,, cArq, "TMP", .T., .F. )

IndRegua("TMP",cArq,"CODIGO+LOJA",,,"Criando Controles") 

fCarrega()

cCadastro :="Selecionar XML"
aCpos   := {}
 
AADD(aCpos,{"OK"        ,," "                   })
AADD(aCpos,{"TIPO"      ,,"Tipo"                })
AADD(aCpos,{"CODIGO"    ,,"Codigo"              })
AADD(aCpos,{"LOJA"      ,,"Loja"                })
AADD(aCpos,{"RAZAO"     ,,"Razão Social"        })
AADD(aCpos,{"DOCUMENTO" ,,"Documento"           })
AADD(aCpos,{"SERIE"     ,,"Serie"               })
AADD(aCpos,{"XML"       ,,"XML"                 })

cMarca    := Getmark()

DbSelectArea("TMP")
TMP->(DbGoTop())

_aSize := MsAdvSize()

aPos := {_aSize[1]+5,_aSize[1]+5,_aSize[4]-15, _aSize[3]}

/*
aRotina := {{"Gerar"   ,"u_GeraNFE()",    0 , 1},;
            {"Marca"   ,"u_fMarcaT(1)",   0 , 1},;
            {"Desmarca","u_fMarcaT(2)",   0 , 1}}
            */
                                  
If nXML > 0

	DEFINE MSDIALOG oDlgXML TITLE "Importacao XML" FROM _aSize[01],_aSize[01] TO _aSize[06],_aSize[05] PIXEL
	
		lInvert := .F.
		oMark := MsSelect():New ("TMP","OK",, aCpos, @lInvert, cMarca, aPos)
		oMark:oBrowse:lHasMark := .T.
		oMark:oBrowse:lCanAllMark:=.T.
		oMark:oBrowse:bAllMark := {|| MrcTdas2(cMarca),oMark:oBrowse:Refresh() }
		oMark:bMark := {|| oMark:oBrowse:Refresh() }
	
	ACTIVATE MSDIALOG oDlgXML CENTERED ON INIT EnchoiceBar(oDlgXML,{||GeraNFE()},{||oDlgXML:End()})
	
Else

	MsgAlert("Nenhum XML encontrado para Importação.","Atencao!")

Endif	
	
TMP->(dbCloseArea())

ferase(cArq)
	
Return


Static Function fCarrega()

aFiles := {} // [ADIR(cCaminho)]
ADIR(cCaminho, aFiles)      
//ALERT(str(len(aFiles)))
For nI:=1 to len(aFiles)

	cFile := cDiretor + aFiles[nI] 	
	nHdl  := fOpen(cFile,0)
		
	If nHdl == -1
		If !Empty(cFile)
			MsgAlert("O arquivo de nome "+cFile+" nao pode ser aberto! Verifique os parametros.","Atencao!")
		Endif
	Else 
	
		If(UPPER(Right(cFile,4))==".XML")
		
			nTamFile := fSeek(nHdl,0,2)
			fSeek(nHdl,0,0)
			cBuffer  := Space(nTamFile)                
			nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  
			fClose(nHdl)
			
			cAviso := ""
			cErro  := ""
			oNfe := XmlParser(cBuffer,"_",@cAviso,@cErro)
			
			If (Empty(cErro))
				Private oNF
				
				If Type("oNFe:_NfeProc") <> "U"
					oNF := oNFe:_NFeProc:_NFe
				Else
					oNF := oNFe:_NFe
				Endif
				
				Private oEmitente  := oNF:_InfNfe:_Emit
				Private oIdent     := oNF:_InfNfe:_IDE
				Private oDestino   := oNF:_InfNfe:_Dest
				Private oTotal     := oNF:_InfNfe:_Total
				Private oTransp    := oNF:_InfNfe:_Transp
				Private oDet       := oNF:_InfNfe:_Det 
				Private cCgcDest := Space(14)
					
				oDet  := IIf(ValType(oDet)=="O",{oDet},oDet)
				cTipo := "N"
		
				cCgcEmit := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))
		
			    cCgcDest := AllTrim(IIf(Type("oDestino:_CPF")=="U",oDestino:_CNPJ:Text,oDestino:_CPF:Text))
				
			    cDoc     := Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)
			    cSerie   := Padr(OIdent:_serie:TEXT,3)
				cTipo    := ''
				cCodigo  := ''
				cLoja    := ''
				cRazao   := ''
		   		
				If !SA2->(dbSetOrder(3), dbSeek(xFilial("SA2") + cCgcEmit))
				
					If !SA1->(dbSetOrder(3), dbSeek(xFilial("SA1") + cCgcEmit))
					
						MsgAlert("CNPJ Origem Não Localizado - Verifique " + cCgcEmit)
						
					Else              
					
						cTipo   := 'ClIENTE'
						cCodigo := SA1->A1_COD
						cLoja   := SA1->A1_LOJA
						cRazao  := SA1->A1_NOME
			
					Endif            
					
				Else
		
					cTipo   := 'FORNECEDOR'
					cCodigo := SA2->A2_COD
					cLoja   := SA2->A2_LOJA
					cRazao  := SA2->A2_NOME
						
				Endif
				
				lInclui := .T. 
				
				If nValCNPJ == 1
					If cCgcDest <> SM0->M0_CGC
		//			alert(cCgcDest,SM0->M0_CGC)
						lInclui := .F.			
					Endif
				Endif			
		 //       alert(lInclui)
				If lInclui
					If !empty(cTipo)	    
						reclock('TMP',.T.)
						replace OK        with ''
						replace TIPO      with cTipo     
						replace CODIGO    with cCodigo     
						replace LOJA      with cLoja     
						replace RAZAO     with cRazao     
				        replace DOCUMENTO with cDoc
				        replace SERIE     with cSerie
						replace XML       with aFiles[nI] 	 
						msunlock()
						nXML++
					Endif		
				Endif
			Else 
				Alert(cErro)
			EndIf 
		EndIf
    Endif
Next

Return

User Function fMarcaT(opcao)

local cArea:=alias()
local nRec :=recno()

dbSelectArea('TMP')
dbGotop()
do while !eof()
	reclock('TMP',.f.)
	if opcao == 1
		replace TMP->OK with cMarca
	else
		replace TMP->OK with ' '
	endif		
	msunlock()
	dbSkip()
enddo

dbSelectArea(cArea)
dbGoto(nRec)

return

Static Function GeraNFE()

Local nItem := 0 
Local cUnidad := ''

dbSelectArea('TMP')
dbGotop()
do while !eof()

	aProd := {}

	IF TMP->OK == cMarca    

		nItem  := 0
		lGera  := .T.
		aCabec := {}
		aItens := {}

		cFile := cDiretor + alltrim(TMP->XML) 	
		nHdl  := fOpen(cFile,0)
					
		nTamFile := fSeek(nHdl,0,2)
		fSeek(nHdl,0,0)
		cBuffer  := Space(nTamFile)                
		nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  
		fClose(nHdl)
		
		cAviso := ""
		cErro  := ""
		oNfe := XmlParser(cBuffer,"_",@cAviso,@cErro)
		
		If Type("oNFe:_NfeProc") <> "U"
			oNF := oNFe:_NFeProc:_NFe
		Else
			oNF := oNFe:_NFe
		Endif
		
		oEmitente  := oNF:_InfNfe:_Emit
		oIdent     := oNF:_InfNfe:_IDE
		oDestino   := oNF:_InfNfe:_Dest
		oTotal     := oNF:_InfNfe:_Total
		oTransp    := oNF:_InfNfe:_Transp
		oDet       := oNF:_InfNfe:_Det 
		cCgcDest   := Space(14)
			
		oDet  := IIf(ValType(oDet)=="O",{oDet},oDet)
		
		cTipo := "N"
	
		cCgcEmit := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))
	
	    cCgcDest := AllTrim(IIf(Type("oDestino:_CPF")=="U",oDestino:_CNPJ:Text,oDestino:_CPF:Text))
		
	    cDoc     := Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)
	    cSerie   := Padr(OIdent:_serie:TEXT,3)
		cTipo    := ''
		cCodigo  := ''
		cLoja    := ''
		cRazao   := ''
	   		
		If !SA2->(dbSetOrder(3), dbSeek(xFilial("SA2") + cCgcEmit))
		
			If !SA1->(dbSetOrder(3), dbSeek(xFilial("SA1") + cCgcEmit))
			
				MsgAlert("CNPJ Origem Não Localizado - Verifique " + cCgcEmit)
				lGera := .F.		
				
			Else              
			
				cTipo   := 'ClIENTE'
				cCodigo := SA1->A1_COD
				cLoja   := SA1->A1_LOJA
				cRazao  := SA1->A1_NOME
	
			Endif            
			
		Else
	
			cTipo   := 'FORNECEDOR'
			cCodigo := SA2->A2_COD
			cLoja   := SA2->A2_LOJA
			cRazao  := SA2->A2_NOME
				
		Endif
	
		If SF1->(DbSeek(XFilial("SF1")+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+Padr(OIdent:_serie:TEXT,3)+cCodigo+cLoja))
			MsgAlert("Nota No.: "+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+"/"+OIdent:_serie:TEXT + if(cTipo=='FORNECEDOR',' do Fornec. ',' do Cliente ') + cCodigo+"/"+cLoja+" Ja foi importada.")
			lGera := .F.			
			dbSelectArea('TMP')
			dbSkip()
			Loop
		EndIf
						
		cProds := ''
		aPedIte:={}                                 
		
		nItens := len(oDet)
		
		cCodFornAx      := AllTrim(oDet[01]:_Prod:_CPROD:Text)
		
		For nCont := 1 To nItens
	
		     cCodBarra     := oDet[nCont]:_Prod:_CEAN:Text
	 	     cCodForn      := AllTrim(oDet[nCont]:_Prod:_CPROD:Text)
	  	     nQuant        := Val(oDet[nCont]:_Prod:_QCOM:Text)
	         nPrcUnBrt     := Val(oDet[nCont]:_Prod:_VUNCOM:Text)
	         nPrcTtBrt     := nQuant * nPrcUnBrt 
	
		     If XmlChildEx(oDet[nCont]:_PROD, "_VDESC")!= Nil
		          nValDesc     := Val(oDet[nCont]:_Prod:_VDESC:Text)
		     Else
		          nValDesc     := 0
		     EndIf    
		     
		     // Busca o Codigo interno do produto.
		     dbSelectArea("SA5")
		     dbSetOrder(5)
		     
		     bOkItem := .F.   
		     cCodPro := ''
		     
		     If bOkItem == .F. .and. alltrim(str(val(cCodForn))) <> cCodForn .and. val(cCodForn) > 0 // busca sem os zeros no inicio. se existirem zeros.
	
		          cCodForn     := Alltrim(Str(val(cCodForn)))
		          
		          If SA5->(dbSeek(xFilial("SA5")+   cCodForn ))
		               While alltrim(SA5->A5_CODPRF) = cCodForn
		                    If SA5->(A5_FORNECE+A5_LOJA) == cCodigo+cLoja
		                         bOkItem := .T.
		                         cCodFornAx := cCodForn
		                         cCodPro := SA5->A5_PRODUTO
		                         cUnidad := SA5->A5_UNID
		                         Exit
		                    Endif
		                    dbSkip()
		               EndDo
		          EndIf
		     Endif
		     
			     
		     If bOkItem == .F.
		     
		          If SA5->(dbSeek(xFilial("SA5")+cCodForn)) // Busca pelo codigo do Fornecedor
		               While alltrim(SA5->A5_CODPRF) = cCodForn
		                    If SA5->(A5_FORNECE+A5_LOJA) == cCodigo+cLoja
		                         bOkItem := .T.
		                         cCodPro := SA5->A5_PRODUTO
		                         cUnidad := SA5->A5_UNID
		                         Exit
		                    EndIf
		                    SA5->(DBSkip())
		               EndDo
		          Endif
		     Endif
		     
		     If bOkItem = .F. .and. !Empty(cCodBarra)
		
		        // Busca pelo Codigo de Barras no cadastro do produto
		          dbSelectArea("SB1")
		          dbSetOrder(5)
		          If SB1->(dbSeek(xFilial("SB1")+cCodBarra))
		               cCodPro := SB1->B1_COD     
		               
		               // Verifica se existe uma amarracao para o produto encontrado
		               dbSelectArea("SA5")
		               dbSetOrder(2)
		               If !(SA5->(DBSeek(xFilial("SA5")+cCodPro+cCodigo+cLoja)))
		                    // Inclui a amarracao do produto X Fornecedor
		                    bOkItem := .T.
		                    RecLock("SA5",.T.)
		                    A5_FILIAL     := xFilial("SA5")
		                    A5_FORNECE    := cCodigo
		                    A5_LOJA       := cLoja
		                    A5_NOMEFOR    := SA2->A2_NOME
		                    A5_PRODUTO    := cCodPro
		                    A5_NOMPROD    := SB1->B1_DESC
		                    A5_CODPRF     := cCodForn
		                    MSUnLock()
		               Else
		                    If Empty(SA5->A5_CODPRF) .or. SA5->A5_CODPRF = "0" // Atualiza a amarracao se nao tiver o codigo do fornecedor cadastrado.
		                         bOkItem := .T.
		                         RecLock("SA5",.F.)
		                         A5_CODPRF     := cCodForn
		                         MSUnLock()
		                    Endif
		               EndIf
		          Endif
	
		          If !bOkItem
		               dbSelectArea("SLK")
		               DBSetOrder(1)
		               If SLK->(dbSeek(xFilial("SLK")+cCodBarra))
		                    bOkItem := .T.
		                    cUnidad := "3"
		                    cCodigo := SLK->LK_CODIGO
		               Endif
		          Endif
		          
		     Endif
		     
		     If (AllTrim(cCodForn)<>AllTrim(cCodFornAx))
//		     	Alert('Item '+StrZero(nCont,3)+CHR(13)+CHR(10)+cCodFornAx+' Diferente De '+cCodForn)
		     	bOkItem := .F.
		     	cCodFornAx := cCodForn
		     EndIf
			
		     If !bOkItem
		     
		     	   If nIncAma == 1	
		     	   
		     	   		cQuery := "SELECT COUNT(*) QTDE "
						cQuery += "FROM "+RetSqlName('SA5')+" "
						cQuery += "WHERE A5_FORNECE = '"+cCodigo+"' AND A5_LOJA = '"+cLoja+"' AND "
						cQuery += "A5_CODPRF = '"+cCodForn+"' AND "
						cQuery += "D_E_L_E_T_ <> '*' "
						
						If (Select("QSA5")>0)
							QSA5->(DbCloseArea())
						EndIf
						
						TcQuery cQuery New Alias "QSA5"
						
						DbSelectArea("QSA5")
						QSA5->(DbGoTop())
						
						If (QSA5->QTDE == 0)
		     	   
		     	   		/*
		     	   		DbSelectArea("SA5")
		     	   		DbSetOrder(5)
		     	   		If (!(SA5->(DbSeek(xFilial("SA5")+cCodigo+cLoja+cCodPro))))
		     	   		If (!(SA5->(DbSeek(xFilial("SA5")+cCodForn))))
		     	   			cCodPro := ''
		     	   			While (!SA5->(EOF()) .AND. SA5->A5_CODPRF==cCodForn)
		     	   			
		     	   			If (SA5->(A5_FORNECE+A5_LOJA)==cCodigo+cLoja)
		     	   			
		     	   		*/
		     	   		
					       @ 200,1 TO 350,500 DIALOG oDlg TITLE OemToAnsi("Inclui Amarração")
				
					       cPPRod := space(tamSx3('B1_COD')[1])
				       
					       @ 10,15 say "Fornecedor:" + cCodigo + "/" + cLoja + " (" + substr(alltrim(posicione('SA2',1,xFilial('SA2')+cCodigo+cLoja,'A2_NOME')),1,40) + ")"
					       @ 20,15 say "Produto Sem Amarração: " + cCodForn + " (" + substr(oDet[nCont]:_Prod:_xProd:Text,1,50) + ")"
					       @ 30,15 say "Produto : "
					       @ 30,40 get cPProd F3 'SB1' valid(chkProd())
				
					       @ 50,120 BMPBUTTON TYPE 01 ACTION GravProd(nCont)
				   		   @ 50,160 BMPBUTTON TYPE 02 ACTION Close(oDlg)
				
				      	   Activate Dialog oDlg Centered
				      	    
						Else           
							
							//	cCodPro := SA5->A5_PRODUTO
						EndIf
			      	   
			       Endif	   
			       
			       
			       If empty(cCodPro)			       
			      					     
						MsgAlert("Produto Sem Amarração: " + cCodForn + " (" + oDet[nCont]:_Prod:_xProd:Text + ") Codigo de barras: " + cCodBarra)
						lGera := .F.
						dbSelectArea('TMP')
						dbSkip()
						Loop       
				
				   Endif
				   
				   /*
				   If (AScan(aProd,{|x| x[01]==StrZero(nCont,3)})==0)
						AAdd(aProd,{StrZero(nCont,3),cCodPro})
					EndIf
					*/
				   	
		     
		     Endif
		     
		     If (AScan(aProd,{|x| x[01]==StrZero(nCont,3)})==0)
				AAdd(aProd,{StrZero(nCont,3),cCodPro})
			EndIf
		     
		        // Posiciona no produto encontrado
		        dbSelectArea("SB1")
		        dbSetOrder(1)
		        SB1->(dbSeek(xFilial("SB1")+cCodPro))
		        
		        If SB1->B1_MSBLQL = '1'
					MsgAlert("Produto Bloqueado: " + cCodForn + " (" + oDet[nCont]:_Prod:_xProd:Text + ") Codigo de barras: " + cCodBarra)
					lGera := .F.					
					dbSelectArea('TMP')
					dbSkip()
					Loop		
		        Endif
			 
			 						
	         nFator := 1
	         Do Case
	               Case cUnidad = "2"
	                    nFator := SB1->B1_CONV
	               Case cUnidad = "3" .and. SLK->LK_QUANT > 1
	                    nFator := SLK->LK_QUANT 
	         End Case
	
	          //Verifica se possui Node _Med
	         bMed := XmlChildEx(oDet[nCont]:_Prod , "_MED" ) != Nil
	     
	         If bMed
	               // Converte o Node Med em array para os casos que existe informacao de mais de um lote do mesmo produto.          
	               If ValType(oDet[nCont]:_PROD:_MED) = "O"
	                    XmlNode2Arr(oDet[nCont]:_PROD:_MED, "_MED")
	               EndIf
	
	               nTotalMed := len(oDet[nCont]:_PROD:_MED)
	         Else
	               nTotalMed := 1
	               nQtdeLote := nQuant
	               cLote     := ""
	               cValidade := ""
	         Endif
	                 
	          // Acumuladores
	         nDescTT  := 0
	         nValorTT := 0
	         
	         For nContLote := 1 to nTotalMed
	         	               	                           
	            if bMed
	                    cLote     := oDet[nCont]:_Prod:_MED[nContLote]:_NLote:Text
	                    cValidade := oDet[nCont]:_Prod:_MED[nContLote]:_DVal:Text
	                    cValidade := Substr(cValidade,9,2)+"/"+Substr(cValidade,6,2)+"/"+Substr(cValidade,1,4)
	                    nQtdeLote := val(oDet[nCont]:_Prod:_MED[nContLote]:_QLote:Text)
	            Endif
	            If nContLote != nTotalMed
	                    nDescLote := Round(nValDesc/nQuant*nQtdeLote,2) // Desconto do Lote Atual
	                    nValLote  := Round(nPrcTtBrt/nQuant*nQtdeLote,2) // Valor do Lote Atual
	
	                    nDescTT   += nDescLote
	                    nValorTT  += nValLote                    
	            Else
	                    nDescLote := nValDesc  - nDescTT // Desconto do Lote Atual - Diferenca
	                    nValLote  := nPrcTtBrt - nValorTT // Valor do Lote Atual - Diferenca
	            Endif

	            If nFator > 1               
	                  nQtdeLote := nQtdeLote*SB1->B1_CONV
	            Endif

				 //Pedido de compra automático
				cPedAut   := ''			 
				cItPedAut := ''
				 
				If nPC == 1
				
				 	dbSelectArea('SC7')
				 	dbSetOrder(2)
				 	SC7->(dbSeek(xFilial('SC7') + padr(cCodPro,tamsx3('C7_PRODUTO')[1]) + padr(cCodigo,tamsx3('C7_FORNECE')[1]) + padr(cLoja,tamsx3('C7_LOJA')[1]), .T. ))
	
					If  C7_FILIAL  == xFilial('SC7') .AND. ;
						C7_PRODUTO == padr(cCodPro,tamsx3('C7_PRODUTO')[1]) .AND. ;
						C7_FORNECE == padr(cCodigo,tamsx3('C7_FORNECE')[1]) .AND. ;
						C7_LOJA    == padr(cLoja,tamsx3('C7_LOJA')[1]) .AND. ;
						C7_QUANT - C7_QUJE >= nQtdeLote
						
						cPedAut   := C7_NUM			 
						cItPedAut := C7_ITEM  
											
					Endif	
				 
				Endif	 
	
                nItem++
	            aLinha := {}
	       
	            xPosProd := AScan(aProd,{|x| x[01]==STRZERO(nItem,3)})
	            
	            If (xPosProd == 0)
	            	xPosProd := 1 
	            EndIf
	            
	            aadd(aLinha,{"D1_ITEM"  ,STRZERO(nItem,3)   ,Nil})
	            aadd(aLinha,{"D1_FILIAL",xFilial('SD1')     ,Nil})
	            aadd(aLinha,{"D1_COD"   ,aProd[xPosProd,02] ,Nil})
	            aadd(aLinha,{"D1_QUANT" ,nQtdeLote          ,Nil})               
	            aadd(aLinha,{"D1_VUNIT" ,nValLote/nQtdeLote ,Nil})
	            aadd(aLinha,{"D1_TOTAL" ,nValLote           ,Nil})
	            aadd(aLinha,{"D1_TES"   ,""                 ,Nil})
	            aadd(aLinha,{"D1_OPER"  ,""                 ,Nil})
	            aadd(aLinha,{"D1_CONTA" ,""                 ,Nil})               
	            aadd(aLinha,{"D1_VALDESC", nDescLote        ,Nil})                
	            aadd(aLinha,{"D1_LOTEFOR",cLote             ,Nil})
	            If !empty(cPedAut)
		            aadd(aLinha,{"D1_PEDIDO",cPedAut            ,Nil})
		            aadd(aLinha,{"D1_ITEMPC",cItPedAut          ,Nil})
		        Endif    
	            aadd(aLinha,{"AUTDELETA","N"                ,Nil}) 
	               
	            aadd(aItens,aLinha)
	            
	         Next
	         
		Next
	
		If len(aItens) > 0 .and. lGera
		
			Private oNFAux
			
			If Type("oNFe:_NfeProc") <> "U"
				oNFAux := oNFe:_NFeProc:_NFe
			Else
				oNFAux := oNFe:_NFe
			Endif

			nFrete        := 0
			nSeguro       := Val(oNFAux:_INFNFE:_TOTAL:_ICMSTOT:_VSeg:Text)			
			nIcmsSubs     := Val(oNFAux:_INFNFE:_TOTAL:_ICMSTOT:_VST:Text)
			nTotalMerc    := Val(oNFAux:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:Text) // Valor Mercadorias
			cData         := Alltrim(OIdent:_dEmi:TEXT)
			dData         := CTOD(Right(cData,2)+'/'+Substr(cData,6,2)+'/'+Left(cData,4)) 
			cChaveNFE     := SubStr(oNFAux:_INFNFE:_ID:TEXT,4,44)
			
//			MsgInfo(cChaveNFE,"CHAVENFE")
						
			aadd(aCabec,{"F1_TIPO"   ,if(cTipo=='FORNECEDOR','N','D'),Nil,Nil})
			aadd(aCabec,{"F1_FORMUL" ,"N",Nil,Nil})
			aadd(aCabec,{"F1_DOC"    ,cDoc,Nil,Nil})
			aadd(aCabec,{"F1_SERIE"  ,cSerie,Nil,Nil})
			aadd(aCabec,{"F1_EMISSAO",dData,Nil,Nil})
			aadd(aCabec,{"F1_FORNECE",cCodigo,Nil,Nil})
			aadd(aCabec,{"F1_LOJA"   ,cLoja,Nil,Nil})
			aadd(aCabec,{"F1_ESPECIE","SPED",Nil,Nil})
		    aadd(aCabec,{"F1_SEGURO" ,nSeguro,NIL})
		    aadd(aCabec,{"F1_FRETE"  ,nFrete,NIL})
		    aadd(aCabec,{"F1_VALMERC",nTotalMerc,NIL})
		    aadd(aCabec,{"F1_VALBRUT",nTotalMerc+nSeguro+nFrete+nIcmsSubs,NIL})
		    aadd(aCabec,{"F1_CHVNFE" ,cChaveNFE,NIL})
		
		    dbSelectArea("SB1")
		    dbSetOrder(1)

			lMsErroAuto := .f.
															     
		    MATA140(aCabec,aItens,3)
		    		     
		    If !lMsErroAuto

				SF1->(DbSeek(XFilial("SF1")+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+Padr(OIdent:_serie:TEXT,3)+cCodigo+cLoja))		          
				
				If nAcao == 1 //PRE NOTA

//					antArotina := aRotina
							
					aRotina	:= {{ "Pesquisar"	            ,"AxPesqui"		, 0 , 1, 0, .F.},; 
								{ "Visualizar"	            ,"A140NFiscal"	, 0 , 2, 0, .F.},; 
								{ "Incluir"	                ,"A140NFiscal"	, 0 , 3, 0, nil},; 
								{ "Alterar"	                ,"A140NFiscal"	, 0 , 4, 0, nil},; 
								{ "Excluir"	                ,"A140NFiscal"	, 0 , 5, 0, nil},; 
								{ "Imprimir"	            ,"A140Impri"  	, 0 , 4, 0, nil},; 
								{ "Estorna Classificacao"	,"A140EstCla" 	, 0 , 5, 0, nil},; 
								{ "Legenda"	                ,"A103Legenda"	, 0 , 2, 0, .F.}} 
	
					PRIVATE aHeadSD1    := {}
					PRIVATE ALTERA      := .F.						
					A140NFiscal('SF1',SF1->(recno()),4)          
					
  //				    aRotina := antArotina
				
				ElseIf nAcao == 2 //Classifica
				
					//antArotina := aRotina

					PRIVATE aRotina := {{"Pesquisar"  , "AxPesqui"   , 0, 1},; 
										{"Visualizar" , "A103NFiscal", 0, 2},; 
										{"Incluir"    , "A103NFiscal", 0, 3},; 
										{"Classificar", "A103NFiscal", 0, 4},; 
										{"Retornar"   , "A103Devol"  , 0, 3},; 
										{"Excluir"    , "A103NFiscal", 3, 5},; 
										{"Imprimir"   , "A103Impri"  , 0, 4},; 
										{"Legenda"    , "A103Legenda", 0, 2} } 
										
					A103NFiscal('SF1',SF1->(recno()),4)          
					
				    //aRotina := antArotina
													
				Endif   
	
				cFileImp := cDiretor + 'Importados\' + alltrim(TMP->XML) 	
				
		        FRename(cFile, cFileImp)

				reclock('TMP',.F.)				
				dbDelete()        
				msunlock()
		
		    Else                       
		    
		        mostraerro()          
		        
		    EndIf
		    
		Endif     
		
	Endif    

	dbSelectArea('TMP')
	dbSkip()
	
enddo

oMark:oBrowse:Refresh()		

Return

Static Function ValidPerg()

Local cAlias := Alias()
Local nI, nJ

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := PADR(cPerg,10)
aRegs   :={}

aAdd(aRegs,{cPerg,"01","Diretorio        ?","","","mv_ch1","C",80,0,0,"G","u_fDiretorio","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ação             ?","","","mv_ch2","N",01,0,0,"C","","mv_par02","Pre-Nota","","","","","Classifica","","","","","Nenhuma","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Pedido Compra    ?","","","mv_ch3","N",01,0,0,"C","","mv_par03","Automatico","","","","","Não Gera","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Valida CNPJ      ?","","","mv_ch4","N",01,0,0,"C","","mv_par04","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Inclui Amarração ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","","",""})

For nI := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[nI,2])
		RecLock("SX1",.T.)
		For nJ:=1 to FCount()
			If nJ <= Len(aRegs[nI])
				FieldPut(nJ,aRegs[nI,nJ])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(cAlias)

Return


User Function fDiretorio()

Local cFile 

If empty(MV_PAR01)

	cFile := cGetFile( "Arquivo NFe (*.xml) | *.xml", "Selecione o Arquivo de Nota Fiscal XML",,'',.F., GETF_LOCALHARD+GETF_RETDIRECTORY)
	
	If !empty(cFile)    
		MV_PAR01 := cFile
	Endif	

Endif
	
Return .T.                  


Static Function GravProd(nCont)

Local aArea:=getArea()

cCodPro := ''

If !empty(cPProd)			       
	dbSelectArea('SB1')
	dbSetOrder(1)
	If SB1->(dbSeek(xFilial('SB1')+cPProd))

    	cCodPro := SB1->B1_COD
    	  
    	cUnidad := ''	    
	Endif               
	                 
	DbSelectArea("SA5") 
	SA5->(DbSetOrder(1)) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
	If (SA5->(DbSeek(xFilial('SA5')+cCodigo+cLoja+cCodPro)))
		If (Empty(SA5->A5_CODPRF))
			RecLock('SA5',.F.)
			Replace A5_CODPRF With cCodForn
			SA5->(MsUnlock())
		EndIf
	Else
	
		RecLock("SA5",.T.)
    	A5_FILIAL     := xFilial("SA5")
    	A5_FORNECE    := cCodigo
    	A5_LOJA       := cLoja
    	A5_NOMEFOR    := SA2->A2_NOME
    	A5_PRODUTO    := cCodPro
    	A5_NOMPROD    := SB1->B1_DESC
    	A5_CODPRF     := cCodForn
    	SA5->(MSUnLock())
  	EndIf
Endif	              

RestArea(aArea)

Close(oDlg)

Return	

Static Function chkProd()

Local aArea:=getArea()
Local lRet :=.T.

If !empty(cPProd)			       
	dbSelectArea('SB1')
	dbSetOrder(1)
	If !(SB1->(dbSeek(xFilial('SB1')+cPProd)))
		lRet:=.F.
	Endif               
Endif	              

RestArea(aArea)

Return lRet

Static Function MrcTdas2(cMarca)
Local lCont:=.F.
dbselectarea("TMP")
dbgotop()
While !EOF()
	if OK<>cMarca
		RecLock("TMP",.F.)
		OK:= cMarca
		MsUnlock()
		lCont:=.T.
	endif
	dbskip()
end
if !lCont
	dbgotop()
	While !EOF()
		RecLock("TMP",.F.)
		OK:=space(2)
		MsUnlock()
		dbskip()
	end
endif
dbgotop()
Return