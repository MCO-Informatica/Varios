#INCLUDE "protheus.ch"  

  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                                
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP022   º Autor ³ Vanilson Souza     º Data ³  01/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                                                                     
±±º			 ³ Esta rotina tem como finalidade a impressão de etiquetas    ±±
±±ºDescricao ³ 40x40mm em impressora Zembra S500.     			          º±±       
±±º          ³ Padrão de impressão: INTERLEAVED 2 OF 5   				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATP022()

Local 	cCodigo	  := Space(16)
Local 	cDesc     
Local 	cPeriod
Local 	aPeriod   := {"SIM", "NAO"}   
Local 	nOpc      := 0
Local 	oBtn2
Private oDlg
Private nQtd	  := 0  
Private oCodigo
Private oDesc
Private oQtd
Private oPeriod

DEFINE MSDIALOG oDlg TITLE "Imprime Etiquetas - Impressora Zebra" FROM 100,150 TO 400,600 PIXEL
@ 005,005 To 130,220 PIXEL
@ 015,015 SAY "Impressão de etiquetas conforme o produto e quantidade informada." PIXEL
@ 035,015 SAY "Produto " PIXEL
@ 035,055 MSGET oCodigo VAR cCodigo PICTURE "@N 9999999999999999" SIZE 70,10 F3 "SB1" VALID (ExistCpo("SB1", cCodigo), cDesc := Posicione("SB1",1, xFilial("SB1")+cCodigo, "B1_DESC"), oDlg:Refresh()) PIXEL
@ 055,015 SAY "Descrição" PIXEL
@ 055,055 MSGET oDesc VAR cDesc SIZE 140,10 WHEN .F. PIXEL                     
@ 075,015 SAY "Quantidade" PIXEL
@ 075,055 MSGET oQtd VAR nQtd PICTURE "@E 9,999.99" SIZE 30,10 PIXEL
@ 095,015 SAY "Periodico" PIXEL

oPeriod := tComboBox():New(095,055,{|u|if(PCount()>0,cPeriod:=u,cPeriod)},;
aPeriod,035,010,oDlg,,,,,,.T.,,,,,,,,,"cCombo")


//oCombo:= tComboBox():New(050,008,{|u|if(PCount()>0,cCombo:=u,cCombo)},;
	//							aItems2,65,20,oDlg,,{|| nNewCodTab := left(cCombo,2) },;
	  //							,,,.T.,,,,,,,,,"cCombo")



DEFINE SBUTTON FROM 125,150 TYPE 1 ACTION (U_ImpZebra( cCodigo,nQtd, cPeriod, oDlg)) ENABLE OF oDlg
DEFINE SBUTTON FROM 125,180 TYPE 2 ACTION ( oDlg:End() ) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED
  
Return      

User Function ImpZebra(cCodigo, nQtd, cPeriod, oDlg)  

Local nLen := 0   
   
DbSelectArea("SB1")
SB1->( DbSetOrder(1) )  
If SB1->( DbSeek(xFilial("SB1")+cCodigo) )
      
	If SB1->B1_MSBLQL <> "1"
		              
		MSCBPRINTER("S500","LPT1",,,.F.,,,,,)
		MSCBCHKStatus(.F.)
       
		For nX := 1 To nQtd
			MSCBBEGIN(1,40)
          
			If cPeriod == "SIM" 
			
				Do Case 
					
   					Case Len(AllTrim(B1_COD)) == 6  
               		
               			//nLen := 12 	        
       				      nLen := 18
       				Case Len(AllTrim(B1_COD)) == 7  
               		
               			nLen := 11
          			
          			Case Len(AllTrim(B1_COD)) == 8  
               		
               			nLen := 13
            		
            		Case Len(AllTrim(B1_COD)) == 9  
               		
               			nLen := 14	
             		
             		Case Len(AllTrim(B1_COD)) == 10  
               		
               			nLen := 15	
               		
               		Case Len(AllTrim(B1_COD)) == 11  
               		
               			nLen := 16
               		
               		Case Len(AllTrim(B1_COD)) == 12
               		
               			nLen := 17
              		
              		Case Len(AllTrim(B1_COD)) == 13
              		
              			nLen := 18
              		
              		Case Len(AllTrim(B1_COD)) == 14
              		
              			nLen := 19
              		
              		Case Len(AllTrim(B1_COD)) == 15
              		  
               			nLen := 22
               	   
               		OtherWise 
               		
               			nLen := Len(AllTrim(B1_COD)) 
               										
				EndCase   
                              
               // **************************************** REVISTA ************************************************ //
               
               // ----->> IMPRIME ETIQUETA DO LADO ESQUERDO <<----- 
    		   MSCBSAY   (4.70,4.50,"LASELVA BOOKSTORE ","N","0","32")  // X - COLUNA, Y - LINHA, STRING, ROTACAO, TIPO FONTE, TAMANHO     
    		   MSCBSAY   (6.50,9.50,"ASSINATURAS 0800 - 110052","N","0","20")    
    		   MSCBSAY   (4.70,18.00,"Fornece: ","N","0","18") 
    		   MSCBSAY   (16.00,18.40,"( " + AllTrim(B1_PROC)+ ")","N","0","19" )
    		   MSCBSAY   (33.00,16.40,"R$ ","N","0","30")
    		   MSCBSAY   (40.00,16.40,STR(B1_PRV1),"N","0","30")
    		   MSCBSAY   (4.70,24.00,AllTrim(B1_DESC),"N","0","20")  
      	       //MSCBSAYBAR(8.70,30.00,AllTrim("2000000007007"),"N","E",12,.F.,.T.,,,3,2,.F.,,,.F.,)     // (EAN 13)	 
    	       MSCBSAYBAR(29-nLen,30.00,AllTrim(B1_COD),"N","2",12,.F.,.T.,,,2,1,.T.,,,.F.,)  
               //MSCBSAYBAR(29-nLen,30.00,AllTrim(B1_COD),"N","2",12,.F.,.F.,,,2.40,1,.T.,,,.F.,)
               //MSCBSAY   (30-nLen,43.00,AllTrim(B1_COD),"N","0","22") 
			   //MSCBSAY   (29-LEN(AllTrim(B1_COD)),43.00,AllTrim(B1_COD),"N","0","22")                
               MSCBSAY   (4.70,49.00,"ENCALHE: ","N","0","18") 
               MSCBSAY   (19.50,49.00,DTOC(B1_ENCALHE),"N","0","18") 
    	           
    	       // ----->> IMPRIME ETIQUETA DO LADO DIREITO <<-----// 
    		   MSCBSAY   (61.00,4.50," LASELVA BOOKSTORE ","N","0","32")  // X - coluna, y - linha     
    		   MSCBSAY   (62.80,9.50,"ASSINATURAS 0800 - 110052","N","0","20")  //Imprime Texto - MSCBSAY(_nColuna,_nLinha,SeuTexto,"N","2","1,2")  
    		   MSCBSAY   (61.00,16.40,"Fornece: ","N","0","18") 
    		   MSCBSAY   (72.30,16.40,"( " + AllTrim(B1_PROC)+ " )","N","0","19" )
    		   MSCBSAY   (89.30,16.40," R$ ","N","0","30")
    		   MSCBSAY   (96.30,16.40,STR(B1_PRV1),"N","0","30")
    		   MSCBSAY   (61.00,24.00,AllTrim(B1_DESC),"N","0","20") 
    		   MSCBSAYBAR(86-nLen,30.00,AllTrim(B1_COD),"N","2",12,.F.,.T.,,,2,1,.T.,,,.F.,)	 
    	       //MSCBSAY   (86-LEN(AllTrim(B1_COD)),43.00,AllTrim(B1_COD),"N","0","22")
    	       MSCBSAY   (61.00,49.00," ENCALHE: ","N","0","18") 
    	       MSCBSAY   (75.80,49.00,DTOC(B1_ENCALHE),"N","0","18") 
    	      
			Else 
      			
      			//******************************************  LIVROS ***********************************************//
	       	    // -----> IMPRIME ETIQUETA DO LADO ESQUERDO <-----  //
				MSCBSAY   (4.70,  4.50,   "LASELVA BOOKSTORE","N","0","32")  // X - COLUNA, Y - LINHA, STRING, ROTACAO, TIPO FONTE, TAMANHO      
	       		MSCBSAY   (6.50,  10.10,  "ASSINATURAS 0800 - 110052","N","0","20")  
				MSCBSAY   (4.70,  19.00,  AllTrim(B1_DESC),"N","0","20")
				MSCBSAYBAR(7.70,30.00,AllTrim("2000000007007"),"N","E",12,.F.,.T.,,,3,2,.F.,,,.F.,)     // (EAN 13)	   	 
			    //MSCBSAYBAR(29-nLen,30.00,AllTrim(B1_COD),"N","C",12,.F.,.F.,,,2.40,1,.T.,,,.F.,)** Alterado Vanilson ** 22-06-10
                MSCBSAY   (29-LEN(AllTrim(B1_COD)),43.00,AllTrim(B1_COD),"N","0","22") 	 
				MSCBSAY   (4.70,  49.00,  "FORNECE: ","N","0","18") 
				MSCBSAY   (18.00, 49.00,  "( " + AllTrim(B1_PROC) + " )","N","0","19" )   
				MSCBSAY   (35.00, 49.00,  DTOC(Date()),"N","0","19" ) 
    	       
				// -----> IMPRIME ETIQUETA DO LADO DIREITO <----- //
				MSCBSAY   (61.00, 4.50,   "LASELVA BOOKSTORE ","N","0","32")  //X - COLUNA, Y - LINHA, STRING, ROTACAO, TIPO FONTE, TAMANHO      
				MSCBSAY   (62.80, 10.10,  "ASSINATURAS 0800 - 110052","N","0","20")  
				MSCBSAY   (61.00, 19.00,  AllTrim(B1_DESC),"N","0","20") 	 
				MSCBSAYBAR(86-nLen,30.00,AllTrim(B1_COD),"N","C",12,.F.,.F.,,,2.40,1,.T.,,,.F.,)	 
    	       	MSCBSAY   (86-LEN(AllTrim(B1_COD)),43.00,AllTrim(B1_COD),"N","0","22")	 	 
				MSCBSAY   (61.00, 49.00,  "FORNECE: ","N","0","18")
				MSCBSAY   (74.30, 49.00,  "( " + AllTrim(B1_PROC)+ " )","N","0","19" ) 
				MSCBSAY   (91.30, 49.00,  DTOC(Date()),"N","0","19" ) //"30.11.2009","N","0","19" ) 
    	  
			EndIf
    	            
			MSCBEND()
			
		Next  
        	
		MSCBCLOSEPRINTER()  
      
	Else 
      
		Msgstop("O produto encontra-se bloqueado, favor efetuar desbloqueio!")
      
	EndIf

EndIf

cCodigo	  := Space(15)
cDesc     := Space(30)
nQtd	  := 0
cPeriod   := "SIM"   
oDlg:Refresh()

   
Return() 