#INCLUDE "RWMAKE.ch" 
#INCLUDE "PROTHEUS.CH"


USER FUNCTION MMBROW(xLAUTO)

Local nCnt,nUsado:=0
Local nOpcA:=0,GetList:={}
Local nRegistro,oGet,cDescSZ4
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³Salva a integridade dos dados     ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Local nSavRec  := RecNo()
Private xAUTOMM := (xLAUTO <> NIL)
Private oDlg
Private cChave  := "006243"
Private cDescri := "" //Posicione("SB1",1,xFilial("SB1")+cChave,"B1_DESC")
Private nopcx:= 4
PRIVATE aRotina := {{ "Pesquisar" , "AxPesqui"   , 0 , 1},;
                    { "Pesquisar" , "AxInclui"   , 0 , 2},;
                    { "Pesquisar" , "AxPesqui"   , 0 , 3},;
                    { "Pesquisar" , "Axaltera"   , 0 , 4}}  

cAlias := "SC9"

    aEstru  := {}
    aEstru  := {{"SEQUEN"  ,"C",02,0 },;    //1
                {"PEDIDO"  ,"C",06,0 },;    //2
                {"ITEM"    ,"C",02,0 },;    //3
                {"CLIENTE" ,"C",06,0 },;    //4
                {"DESCRIC" ,"C",25,0 },;    //5
                {"PRODUTO" ,"C",30,0 },;    //6
                {"ARMAZEM" ,"C",02,0 },;    //7
                {"ORDSEP"  ,"C",06,0 },;    //8
                {"QTDLIB"  ,"N",10,2 },;    //9
                {"LOCAL1"  ,"C",08,0 },;    //10
                {"SALDO1"  ,"N",08,2 },;    //11
                {"QUANT1"  ,"N",08,2 },;    //12
                {"LOCAL2"  ,"C",08,0 },;    //13
                {"SALDO2"  ,"N",08,2 },;    //14
                {"QUANT2"  ,"N",08,2 },;    //15
                {"LOCAL3"  ,"C",08,0 },;    //16
                {"SALDO3"  ,"N",08,2 },;    //17
                {"QUANT3"  ,"N",08,2 },;   //18             
                {"LOCAL4"  ,"C",08,0 },;    //19
                {"SALDO4"  ,"N",08,2 },;    //20
                {"QUANT4"  ,"N",08,2 },;    //21
                {"LOCAL5"  ,"C",08,0 },;    //22
                {"SALDO5"  ,"N",08,2 },;    //23
                {"QUANT5"  ,"N",08,2 },;    //24
                {"LOCAL6"  ,"C",08,0 },;    //25
                {"SALDO6"  ,"N",08,2 },;    //26
                {"QUANT6"  ,"N",08,2 },;    //27
                {"LOCAL7"  ,"C",08,0 },;    //28
                {"SALDO7"  ,"N",08,2 },;    //29
                {"QUANT7"  ,"N",08,2 },;    //30             
                {"LOCAL8"  ,"C",08,0 },;    //31
                {"SALDO8"  ,"N",08,2 },;    //32
                {"QUANT8"  ,"N",08,2 },;    //33
                {"LOCAL9"  ,"C",08,0 },;    //34
                {"SALDO9"  ,"N",08,2 },;    //35
                {"QUANT9"  ,"N",08,2 }}     //36


    cArq    := CriaTrab(aEstru,.T.)
    dbUseArea(.T.,,cArq,"cArq",.F.,.F.)
    cIndTrb:= CriaTrab(,.F.)
    IndRegua("cArq",cIndTrb,"PEDIDO+ITEM",,,"Selecionando Registros...")
  
    Dbselectarea("SC9")
    
    dbSetOrder(1)
IF !xAUTOMM
		cArqInd   := CriaTrab(, .F.)
		cChaveInd := IndexKey()		
		cCondicao := 'C9_PEDIDO  >="'+cCHAVE+'".And.C9_PEDIDO <="'+"006244"+'".And.'
		cCondicao += '!Empty(C9_ORDSEP) .And.'
		cCondicao += ' C9_FILIAL == "0101" '
		IndRegua("SC9", cArqInd, cChaveInd, , cCondicao, "Criando indice de trabalho" ) //"Criando indice de trabalho"
		nIndice := RetIndex("SC9") + 1
Endif    
    
    
    Dbgotop()
    xCONTB9:= 1
    While !eof()
      xCONTB9 := xCONTB9 + 1
      Dbskip()
    Enddo
    Dbgotop()        


    xORDSEQ:={}
    xULTSEQ:= "00"
    xPRODSC9:= {}
    xORDARQ:= 0 
    Dbselectarea("SDC")
    xRESTSDC:= ARRAY(xCONTB9*4,FCOUNT())
    xLINSDC := 0
    
    Dbselectarea("CB8")    
    xRESTCB8:= ARRAY(xCONTB9*4,FCOUNT())
    xLINCB8:= 0
    
    Dbselectarea("SC9")
    xRESTSC9:= ARRAY(xCONTB9,FCOUNT())
    xLINSC9 := 0
    
    While !EOF()
	     xQTDLIB := SC9->C9_QTDLIB
         xULTSEQ := IF(SC9->C9_SEQUEN > xULTSEQ,SC9->C9_SEQUEN,xULTSEQ)
         xGRVARQ := .T. 

         IF(LEN(xORDSEQ)) == 0
            AADD(xORDSEQ,{SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO,SC9->C9_SEQUEN})
         Else
            xPROCC9:= ascan(xORDSEQ,{|x| x[01] == SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO}) 
            If xPROCC9 > 0
               xORDSEQ[xPROCC9,2] := SC9->C9_SEQUEN
            Else
               AADD(xORDSEQ,{SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO,SC9->C9_SEQUEN})
            Endif
         Endif         
            
         If(Len(xPRODSC9)) == 0
       		aadd(xPRODSC9,{SC9->C9_PRODUTO+SC9->C9_LOCAL,1})
         Else   
       		xORDARQ:= ascan(xPRODSC9,{|x| x[01] == SC9->C9_PRODUTO+SC9->C9_LOCAL}) 
       		If xORDARQ == 0 
          		aadd(xPRODSC9,{SC9->C9_PRODUTO+SC9->C9_LOCAL,1})
//           	Else
//           		xGRVARQ := .F.
           	Endif
         Endif

         Dbselectarea("SBF")
         DbsetOrder(2)
         If DBseek(SC9->C9_FILIAL+SC9->C9_PRODUTO+SC9->C9_LOCAL) // +SC9->C9_LOTECTL+SC9->C9_NUMLOTE)
            
            xOKBF:= 0
            While !eof() .AND. SC9->C9_FILIAL+SC9->C9_PRODUTO+SC9->C9_LOCAL == SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL .AND. ;
                 xOKBF <= 9
                Dbselectarea("SDC")
                DbsetOrder(1)
                
                If Dbseek(xFILIAL("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN)  //+SC9->C9_LOTECTL+SC9->C9_NUMLOTE+SBF->BF_LOCALIZ)
                	While !eof() .AND. xFILIAL("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN == ;
                	    SDC->DC_FILIAL+SDC->DC_PRODUTO+SDC->DC_LOCAL+SDC->DC_ORIGEM+SDC->DC_PEDIDO+SDC->DC_ITEM+SDC->DC_SEQ
                	
               	    	xLINSDC := xLINSDC + 1
                		For za:=1 to FCount()
                    		xRESTSDC[xLINSDC][zA] := FIELDGET(za)
                    	Next
                    
                   		Reclock("SDC",.F.)
                		   Dbdelete()
                   		MsUnlock()
                        Dbskip()
                    Enddo    
                   
/*                   Dbselectarea("SB8")
                   DbsetOrder(2)
                   If Dbseek(xFILIAL("SB8")+SC9->C9_NUMLOTE+SC9->C9_LOTECTL+SC9->C9_PRODUTO+SC9->C9_LOCAL)
                   		Reclock("SB8",.F.)
                   			SB8->B8_EMPENHO := If(SB8->B8_EMPENHO > xQTDLIB, SB8->B8_EMPENHO - xQTDLIB,0)
                        MsUnlock()
                   Endif     
                   
                   Dbselectarea("SB2")
                   DbsetOrder(1)
                   If Dbseek(xFILIAL("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL)
                   		Reclock("SB2",.F.)
                   			SB2->B2_RESERVA := If(SB2->B2_RESERVA > xQTDLIB, SB2->B2_RESERVA - xQTDLIB,0)
                   		MsUnlock()	
                   Endif
*/                   
                   Dbselectarea("CB8")
                   DbsetOrder(4)
                   If Dbseek(xFILIAL("CB8")+SC9->C9_ORDSEP+SC9->C9_ITEM+SC9->C9_PRODUTO+SC9->C9_LOCAL)   //+SBF->BF_LOCALIZ+SC9->C9_LOTECTL+SC9->C9_NUMLOTE)
                	While !eof() .and. xFILIAL("CB8")+SC9->C9_ORDSEP+SC9->C9_ITEM+SC9->C9_PRODUTO+SC9->C9_LOCAL == ;
                	     CB8->CB8_FILIAL+CB8->CB8_ORDSEP+CB8->CB8_ITEM+CB8->CB8_PROD+CB8->CB8_LOCAL
                	
                		xLINCB8 := xLINCB8 + 1
                		For za:=1 to FCount()
                    		xRESTCB8[xLINCB8][zA] := FIELDGET(za)
                    	Next
                    

                      	RecLock("CB8",.F.)
                      		DbDelete()
                      	MsUnlock()
                      	Dbskip()
                     Enddo 	
                   Endif   	
/*                   
                   Dbselectarea("SBF")
                   Reclock("SBF",.F.)
                      SBF->BF_EMPENHO := If(SBF->BF_EMPENHO > xQTDLIB, SBF->BF_EMPENHO - xQTDLIB,0)
                   MsUnlock()
*/                
                Endif   
                
                Dbselectarea("SBF")
                If SBF->BF_QUANT - SBF->BF_EMPENHO > 0
                   xOKBF := xOKBF + 1
                   
                   If  xORDARQ == 0   //xGRVARQ
                   
                   		If xOKBF == 1
                      		DbSelectArea("cArq")
	                   		RecLock("cArq",.T.)
    				    		cArq->SEQUEN  := SC9->C9_SEQUEN
						        cArq->PEDIDO  := SC9->C9_PEDIDO
						        cArq->ITEM    := SC9->C9_ITEM
				        		cArq->CLIENTE := SC9->C9_CLIENTE
						        cArq->DESCRIC := POSICIONE("SA1",1,xFILIAL("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A1_NREDUZ")
						        cArq->PRODUTO := SC9->C9_PRODUTO
				        		cArq->ARMAZEM := SC9->C9_LOCAL
						        cArq->ORDSEP  := SC9->C9_ORDSEP
						        cArq->QTDLIB  := SC9->C9_QTDLIB
				        		cArq->LOCAL1  := SBF->BF_LOCALIZ
						        cArq->SALDO1  := SBF->BF_QUANT - SBF->BF_EMPENHO
						        cArq->QUANT1  := If( (SBF->BF_QUANT - SBF->BF_EMPENHO) >= xQTDLIB, xQTDLIB, (SBF->BF_QUANT - SBF->BF_EMPENHO))
				        		
						        xQTDLIB := IIF(xQTDLIB > (SBF->BF_QUANT - SBF->BF_EMPENHO),xQTDLIB - (SBF->BF_QUANT - SBF->BF_EMPENHO),0)
				       
				        
				//SA1->(DbSeek(xFilial("SA1")+SC9->C9_CLIENTE))
				//SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
				//cArq->NOMECLI := SUBSTR(SA1->A1_NOME,1,25)
				//cArq->DESCPRO := SUBSTR(SB1->B1_DESC,1,30)

						    MsUnlock()
			            Else
            			  IF xOKBF <= 9
            			    DbSelectArea("cArq")
				            RecLock("cArq",.F.)
						        xLOCALIZ := "LOCAL" + STRZERO(xOKBF,1)
					    		xQUANTL  := "SALDO" + STRZERO(xOKBF,1)
							    xQTDEMP  := "QUANT" + STRZERO(xOKBF,1)
							    cArq->&xLOCALIZ := SBF->BF_LOCALIZ
				        		cArq->&xQUANTL  := SBF->BF_QUANT - SBF->BF_EMPENHO
							    IF xQTDLIB > 0
							       	carq->&xQTDEMP  := If( (SBF->BF_QUANT - SBF->BF_EMPENHO) >= xQTDLIB, xQTDLIB, (SBF->BF_QUANT - SBF->BF_EMPENHO))
					    		    xQTDLIB := IIF(xQTDLIB > (SBF->BF_QUANT - SBF->BF_EMPENHO),xQTDLIB - (SBF->BF_QUANT - SBF->BF_EMPENHO),0)
							    Endif
				        
							MsUnlock()
						  Endif	
						Endif     
                   Else
               		 xGRVARQ := .F.
                     If xOKBF == 1
                   
                  		DbSelectArea("cArq")
                  		Dbgotop()
                  		While !eof() .AND. SC9->C9_PRODUTO+SC9->C9_LOCAL <> cARQ->PRODUTO+cARQ->ARMAZEM
                  		   Dbskip()
                  		Enddo    

                  		xQTDLIB := SC9->C9_QTDLIB   

	                   	RecLock("cArq",.F.)
	                 	  cArq->QTDLIB  := cArq->QTDLIB + SC9->C9_QTDLIB
	                 	  For xZA:=1 TO 9
						        xLOCALIZ := "LOCAL" + STRZERO(xZA,1)
					    		xQUANTL  := "SALDO" + STRZERO(xZA,1)
							    xQTDEMP  := "QUANT" + STRZERO(xZA,1)
				        		
							    IF xQTDLIB > 0  .AND. (carq->&xQUANTL - carq->&xQTDEMP) > 0
							       If( (carq->&xQUANTL - carq->&xQTDEMP) >= xQTDLIB)	
							       		carq->&xQTDEMP := carq->&xQTDEMP + xQTDLIB 
					    		    	xQTDLIB := 0
					    		   Else
					    		        xQTDLIB := xQTDLIB - (carq->&xQUANTL - carq->&xQTDEMP)
					    		        carq->&xQTDEMP := carq->&xQUANTL
					    		   Endif     
							    Endif	                 
	                      Next
	                 
	                 Endif  	
            
                   Endif


			  	   Dbselectarea("SBF")
				Endif
                Dbskip()
			Enddo
         Endif          
        
        DbSelectArea("SC9")
        
        If !xGRVARQ    //deleto o registro que ja acusei ser repetido, mesmo Produto + Local 2x no mesmo pedido
            xLINSC9 := xLINSC9 + 1
           	For za:=1 to FCount()
               	xRESTSC9[xLINSC9][zA] := FIELDGET(za)
            Next

           Reclock("SC9",.F.)
             Dbdelete()
           MsUnlock()
        Endif     
        
        DbSkip()
    Enddo
    
    DbSelectArea("cArq")
    DbGoTop()

    If RecCount() == 0
       Dbclosearea()
       Return .T.
    EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o cabecalho do GetDados                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aHeader[0]

//bCpos:="C9_PEDIDO,C9_ITEM,C9_PRODUTO,C9_LOCAL,C9_LOTECTL,C9_ORDSEP,C9_QTDLIB,C9_NFISCAL,C9_SERIENF,C9_CLIENTE,C9_LOJA" 
xCPOALT:={"QUANT1","QUANT2","QUANT3","QUANT4","QUANT5","QUANT6","QUANT7","QUANT8","QUANT9"}

For xA:=1 TO LEN(aESTRU)
      nUsado++
//      cValid := X3_VALID
      Do Case 
         Case  substr(aESTRU[xA,1],1,5) == "QUANT"
            AADD(aHeader,{ aESTRU[xA,1], aESTRU[xA,1], "9999",;
              aESTRU[xA,3], aESTRU[xA,4], 'M->' + ALLTRIM(aESTRU[xA,1])+ ' <= aCols[n,'+ strzero(XA-1,2) + ']', "", aESTRU[xA,2], "" } )           
//              aESTRU[xA,3], aESTRU[xA,4], 'aCols[n,' + strzero(XA,2) + '] <= aCols[n,'+ strzero(XA-1,2) + ']', "", aESTRU[xA,2], "" } )           
            //aESTRU[xA,3], aESTRU[xA,4], '" QUANT' + STRZERO(VAL(SUBSTR(aESTRU[xA,1],6,1)),1) + ' <= SALDO' + STRZERO(VAL(SUBSTR(aESTRU[xA,1],6,1)),1)+' "', "", aESTRU[xA,2], "" } )
         OtherWise
            AADD(aHeader,{ aESTRU[xA,1], aESTRU[xA,1], "",;
            aESTRU[xA,3], aESTRU[xA,4], "", "", aESTRU[xA,2], "" } )
      EndCase
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem o tamanho do aCols e monta-o logo em seguida           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CARQ")
DbGotop()
nCnt := 0
While ! Eof()
	nCnt++
	DbSkip()
EndDo
PRIVATE aCOLS[nCnt][nUsado+1]

DbGotop()


nCnt := 0
While !Eof()
    nCnt++
    nUsado:=0

    For xA:=1 TO LEN(aESTRU)
                                
      aCOLS[nCnt][xA] := &("cARQ"+"->"+aESTRU[xA,1])
    Next
    aCols[nCnt][xA] := .F.
    DbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra o cabecalho                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRegistro := RecNo( )
dbGoTo( nRegistro )

xCONTP := .F.
While !xCONTP

/* MONITOR DO MARCIO
DEFINE MSDIALOG oDlg TITLE "Alocacao Empenhos" From 8,0 To 40,165
DEFINE FONT o_Font NAME "Courier New" SIZE 0,16 BOLD
oGet := MSGetDados():New(10,5,245,640,nOpcx,"U_MMBLINOK()","U_MBTUDOK","",.F.,xCPOALT,9,.F.,2000,,,,,,.T.,)   //258,485
oGet:obrowse:Refresh()
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nopca:=1,oDlg:End()},{||nopca:=0,oDlg:End()})
*/

//MONITOR DANIEL
DEFINE MSDIALOG oDlg TITLE "Alocacao Empenhos" From 8,0 To 35,125
DEFINE FONT o_Font NAME "Courier New" SIZE 0,16 BOLD
oGet := MSGetDados():New(10,5,214,484,nOpcx,"U_MMBLINOK()","U_MBTUDOK","",.F.,xCPOALT,9,.F.,2000,,,,,,.T.,)   //258,485
oGet:obrowse:Refresh()
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nopca:=1,oDlg:End()},{||nopca:=0,oDlg:End()})
	If nOpcA == 1
	   	xCONTP := U_MBTUDOK()
	Endif   

    If nOpcA == 0

   		Dbselectarea("SC9")
   		For i := 1 To Len(aCols)
      		If !aCols[i][Len(aCols[i])]
         		xPRODUTO := aCols[i][6]
  		       xARMAZEM := aCols[i][7]
				 xSEQUEN  := aCols[i][1]         
				 xPEDIDO  := aCols[i][2]         
				 xITEM    := aCols[i][3]         

		         If Dbseek(xFILIAL("SC9")+xPEDIDO+xITEM+xSEQUEN+xPRODUTO)
        		    Reclock("SC9",.F.)
		               SC9->C9_ORDSEP := ""
		               SC9->C9_OK := ""
        		    MsUnlock()
		         Endif
		      Endif         
   		Next
       Dbselectarea("SDC")
       
        For Za:= 1 to xLINSDC
           RecLock("SDC",.T.)
           For Zb := 1 to FCOUNT()
              FIELDPUT(ZB,xRESTSDC[ZA,ZB])
           Next   
           MsUnlock()
        	U_TWAJEMP(SDC->DC_PRODUTO,SDC->DC_LOCAL,SDC->DC_PEDIDO,SDC->DC_ITEM,SDC->DC_NUMSERI,SDC->DC_LOTECTL,SDC->DC_NUMLOTE,SDC->DC_LOCALIZ)
           Dbselectarea("SDC")        
        Next

       Dbselectarea("CB8")

        For Za:= 1 to xLINCB8
//           RecLock("CB8",.T.)
           For Zb := 1 to FCOUNT()
//              FIELDPUT(ZB,xRESTCB8[ZA,ZB])
               IF ALLTRIM(Fieldname(ZB)) == "CB8_ORDSEP"
                  If !Dbseek(xFILIAL("CB8")+ xRESTCB8[ZA,ZB])
                      Dbselectarea("CB7")
                      If Dbseek(xFILIAL("CB7")+xRESTCB8[ZA,ZB])
                         Reclock("CB7",.F.)
                           Dbdelete()
                         MsUnlock()
                         ALERT("Ordem Separacao " + xRESTCB8[ZA,ZB] + " Excluida ")
                      Endif
                  Endif
                  Dbselectarea("CB8")
               Endif
           Next   
//           MsUnlock()
        Next

       Dbselectarea("SC9")
       
        For Za:= 1 to xLINSC9
           RecLock("SC9",.T.)
           For Zb := 1 to FCOUNT()
              FIELDPUT(ZB,xRESTSC9[ZA,ZB])
           Next   
           SC9->C9_ORDSEP := ""
           SC9->C9_OK := ""
           MsUnlock()
        Next


    	xCONTP := .T.
    Endif
Enddo

If nOpcA == 1
   xLFILIAL := xFILIAL("SC9")
   
   DbSelectArea(cAlias)

   For i := 1 To Len(aCols)
      If !aCols[i][Len(aCols[i])]
         xPRODUTO := aCols[i][6]
         xARMAZEM := aCols[i][7]
		 xSEQUEN  := aCols[i][1]         
		 xPEDIDO  := aCols[i][2]         
		 xITEM    := aCols[i][3]         
         xQTDPASS := 1
         For xA:=1 TO 9 
         	xQUANTEMP := aCols[i][12+((xa-1)*3)]
         	xLOCALIZ  := aCols[i][10+((xa-1)*3)]
         	xSALDO    := aCols[i][11+((xa-1)*3)]

         	If  xQUANTEMP > 0
         	
         		Dbselectarea("SBF")
         		DbsetOrder(2)         
         		If DBseek(xLFILIAL+xPRODUTO+xARMAZEM)
            	   xPRDLOCALIZ := .T. 
            		While !eof() .AND. xLFILIAL+xPRODUTO+xARMAZEM == SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL
                 		If SBF->BF_LOCALIZ <> xLOCALIZ .OR. (SBF->BF_QUANT - SBF->BF_EMPENHO) <> xSALDO .OR. SBF->BF_QUANT == 0
                 		   Dbskip()
                 		   Loop
                 		Endif   
                       Exit    
                     Enddo
                     RecLock("SBF",.F.)
                     	SBF->BF_EMPENHO := SBF->BF_EMPENHO + xQUANTEMP
                      MsUnlock()
                        
                      If !EMPTY(SBF->BF_LOTECTL)
                      	Dbselectarea("SB8")
                        	DbsetOrder(3)
                        	If Dbseek(SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOTECTL+SBF->BF_NUMLOTE)
                        		RecLock("SB8",.F.)
                        			SB8->B8_EMPENHO := SB8->B8_EMPENHO + xQUANTEMP
                        		MsUnlock()
                        	Endif
                      Endif
                Else
                   xPRDLOCALIZ := .F.
                Endif 
                /*
                Dbselectarea("SB2")
                DbsetOrder(1)
                        
                If Dbseek(xFILIAL("SB2")+xPRODUTO+xARMAZEM)
                  	RecLock("SB2",.F.)
                	SB2->B2_RESERVA := SB2->B2_RESERVA + xQUANTEMP
                   	MsUnlock()
                Endif
                */
                Dbselectarea("SC9")
                DbClearFil()
                DbsetOrder(1)
                If xQTDPASS == 1 //PRIMEIRA PASSAGEM
                   	xQTDPASS := xQTDPASS + 1
                   	If Dbseek(SBF->BF_FILIAL+xPEDIDO+xITEM+xSEQUEN+xPRODUTO)
                  		RecLock("SC9",.F.)
                 			IF xPRDLOCALIZ
                 			   SC9->C9_LOTECTL := SBF->BF_LOTECTL
                   			   SC9->C9_NUMLOTE := SBF->BF_NUMLOTE
                   			Endif
                   			SC9->C9_QTDLIB2 := SC9->C9_QTDLIB2 / SC9->C9_QTDLIB * xQUANTEMP
                   			SC9->C9_QTDLIB  := xQUANTEMP
                      			
                   		MsUnlock()
                   	Endif		
                    aDADSC9:= {}
                    For za:=1 to FCount()
                        AADD(aDADSC9,FIELDGET(za))  
                    Next
                        
                Else
//                	aC9PRODUTO :=""
//                 	aC9PEDIDO  :=""
//                 	aC9ITEM    :=""
                   	Reclock("SC9",.T.)
                   	For Za:= 1 to len(aDADSC9)
//                 	   aC9PRODUTO := If(ALLTRIM(FIELDNAME(zA)) == "C9_PRODUTO",aDADSC9[ZA],aC9PRODUTO)
//                 	   aC9PEDIDO  := If(ALLTRIM(FIELDNAME(zA)) == "C9_PEDIDO",aDADSC9[ZA],aC9PEDIDO)
//                	   aC9ITEM    := If(ALLTRIM(FIELDNAME(zA)) == "C9_ITEM",aDADSC9[ZA],aC9ITEM)
                        	   
                  	   If ALLTRIM(FIELDNAME(zA)) == "C9_SEQUEN"
//               	   		xPROCC9:= ascan(xORDSEQ,{|x| x[01] == aC9PEDIDO+AC9ITEM+aC9PRODUTO})
                   	   		xPROCC9:= ascan(xORDSEQ,{|x| x[01] == xPEDIDO+xITEM+xPRODUTO})
                  	   		If xPROCC9 == 0
                   	   		   xSEQSC9:= "02"
                   	   		Else
                   	   		   xSEQSC9:= STRZERO( VAL(xORDSEQ[xPROCC9,02])+1,2)
                  	   		   xORDSEQ[xPROCC9,2] := xSEQSC9
                   	   		   aDADSC9[ZA]  := xSEQSC9 
                   	   		Endif   
                   	   Endif

                       FIELDPUT(ZA, aDADSC9[ZA])
                        	   
                   	Next
             	     	If xPRDLOCALIZ
             	     	   SC9->C9_LOTECTL := SBF->BF_LOTECTL
              			   SC9->C9_NUMLOTE := SBF->BF_NUMLOTE
              			Endif   
               			SC9->C9_QTDLIB2 := SC9->C9_QTDLIB2 / SC9->C9_QTDLIB * xQUANTEMP
               			SC9->C9_QTDLIB  := xQUANTEMP
                       			
                  	MsUnlock()
                Endif
                    Dbselectarea("CB8")
                    Reclock("CB8",.T.)
                       CB8->CB8_FILIAL := xFILIAL("CB8")
                       CB8->CB8_ORDSEP := SC9->C9_ORDSEP
                       CB8->CB8_ITEM   := SC9->C9_ITEM
                       CB8->CB8_PEDIDO := SC9->C9_PEDIDO
                       CB8->CB8_PROD   := SC9->C9_PRODUTO
                       CB8->CB8_LOCAL  := SC9->C9_LOCAL
                       CB8->CB8_QTDORI := SC9->C9_QTDLIB
                       CB8->CB8_SALDOS := SC9->C9_QTDLIB
                       CB8->CB8_LCALIZ := SBF->BF_LOCALIZ
                       CB8->CB8_SEQUEN := SC9->C9_SEQUEN
                       CB8->CB8_LOTECT := SC9->C9_LOTECTL
                       CB8->CB8_NUMLOT := SC9->C9_NUMLOTE
                       CB8->CB8_CFLOTE := "1"
                    MsUnlock()  
                        
                 If xPRDLOCALIZ   //produto possui controle de localizacao, precisa incluir SDC
               		Dbselectarea("SDC")
                	Reclock("SDC",.T.)
                		SDC->DC_FILIAL := xFILIAL("SDC")
                		SDC->DC_ORIGEM := "SC6"
                		SDC->DC_PRODUTO := xPRODUTO
                		SDC->DC_LOCAL   := xARMAZEM
                		SDC->DC_LOCALIZ := SBF->BF_LOCALIZ
                		SDC->DC_LOTECTL := SBF->BF_LOTECTL
                		SDC->DC_NUMLOTE := SDC->DC_NUMLOTE
                		SDC->DC_QUANT   := SC9->C9_QTDLIB
                		SDC->DC_TRT     := SC9->C9_SEQUEN
                		SDC->DC_SEQ     := SC9->C9_SEQUEN
                		SDC->DC_PEDIDO  := SC9->C9_PEDIDO
                		SDC->DC_ITEM    := SC9->C9_ITEM
                		SDC->DC_QTDORIG := SC9->C9_QTDLIB
                	MsUnlock()
                 Endif

            Endif       
         Next               


      EndIf	
   Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da janela                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Dbselectarea("cARQ")
Dbclosearea()

dbSelectArea(cAlias)
Go nSavRec
Return nOpca

****************************************************************************************
////////////////////////
User Function MMBLinOk()
////////////////////////
****************************************************************************************
Local cTermatu:=aCols[n,1]
Local lRet := .T.

If aCols[n][Len(aCols[n])]   && caso tenha sido deletado
   Return lRet
Endif

IF aCols[n][9] <> ( aCols[n][12]+aCols[n][15]+aCols[n][18]+aCols[n][21]+aCols[n][24]+aCols[n][27]+aCols[n][30]+aCols[n][33]+aCols[n][36])
   ALERT("A qtde empenhada é diferente da necessaria")
   lRet := .F.
Endif

Return lRet

****************************************************************************************
/////////////////////////
User Function MBTudOk()
/////////////////////////
****************************************************************************************
Local lRet := .T.


For i := 1 To Len(aCols)
	IF aCols[i][9] <> ( aCols[i][12]+aCols[i][15]+aCols[i][18]+aCols[i][21]+aCols[i][24]+aCols[i][27]+aCols[i][30]+aCols[i][33]+aCols[i][36])
   		ALERT("A qtde empenhada do item " + strzero(i,2) + " é diferente da necessaria")
   		lRet := .F.
	Endif

Next

Return lRet

