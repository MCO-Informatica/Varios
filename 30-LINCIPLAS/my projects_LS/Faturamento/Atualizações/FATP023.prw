#INCLUDE "protheus.ch"  

  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                                
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP022   º Autor ³ Vanilson Souza     º Data ³  01/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                                                                     
±±º			 ³ Esta rotina tem como finalidade a impressão de etiquetas    ±±
±±º			 ³ do tipo volume 100x70mm em impressora Zembra S500.	      º±±       
±±º          ³ Padrão de impressão: INTERLEAVED 2 OF 5   				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATP023()

Local 	cNF	      := Space(9)  
Local   cSerie    := Space(3) 
Local	cPorta	  
Local   aPorta    :={"LPT1","COM1"}
Local 	oBtn2
Private oDlg
Private nQtd	  := 0  
Private oNF
Private oSerie
Private oQtd
Private oPorta  



DEFINE MSDIALOG oDlg TITLE "Imprime Etiquetas Volume - Impressora Zebra" FROM 100,150 TO 350,600 PIXEL
@ 005,005 To 110,220 PIXEL
@ 015,015 SAY "Impressão de etiquetas conforme a Nota Fiscal informada." PIXEL
@ 035,015 SAY "Porta: " PIXEL
oPorta := tComboBox():New(033,055,{|u|if(PCount()>0,cPorta:=u,cPorta)},;
aPorta,035,010,oDlg,,,,,,.T.,,,,,,,,,"cCombo")
@ 050,015 SAY "NF: " PIXEL
@ 048,055 MSGET oNF VAR cNF PICTURE "@N 99999999" SIZE 70,10 F3 "SF2" VALID (ExistCpo("SF2", cNF), cSerie := Posicione("SF2",1, xFilial("SF2")+cNF, "F2_SERIE"), oDlg:Refresh()) PIXEL
//@ 035,055 MSGET oCodigo VAR cCodigo PICTURE "@N 9999999999999999" SIZE 70,10 F3 "SB1" VALID (ExistCpo("SB1", cCodigo), cDesc := Posicione("SB1",1, xFilial("SB1")+cCodigo, "B1_DESC"), oDlg:Refresh()) PIXEL
@ 065,015 SAY "Serie: " PIXEL
@ 063,055 MSGET oSerie VAR cSerie PICTURE "@!" SIZE 20,10 PIXEL                     
@ 080,015 SAY "Quantidade" PIXEL
@ 078,055 MSGET oQtd VAR nQtd PICTURE "@E 9,999.99" SIZE 30,10 PIXEL


DEFINE SBUTTON FROM 112,150 TYPE 1 ACTION (U_ImpEtiqVol(cNF, cSerie, nQtd, cPorta)) ENABLE OF oDlg
DEFINE SBUTTON FROM 112,180 TYPE 2 ACTION ( oDlg:End() ) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED
  
Return      

User Function ImpEtiqVol( cNF, cSerie, nQtd, cPorta )  

Local nX := 1
Private nQtdori := nQtd
Private nAux 
/*
If  nQtd % 2 = 0
	nQtd += 1 
	nAux := 1
End
*/

While nX <= nQtd   

    impEtiq(nQtd, cNF, cSerie, nX)
    impEtiq(nQtd, cNF, cSerie, nX)			
	nX += 1
	
End 

Static Function impEtiq(nQtd, cNF, cSerie, nX)
   
Local nLen 		:=	0  
Local cEmissao 	:=	DTOC( SF2->F2_EMISSAO )  
Local cGrupo	:=	""
Local cCliente	:=	""
Local cLoja		:=	""
Local nCont     :=  1
   
DbSelectArea( "SF2" )
SF2->( DbSetOrder( 1 ) )  
If SF2->( DbSeek(xFilial( "SF2" )+ cNF + cSerie ) )   
	
	cCliente	:=	SF2->F2_CLIENTE
	cLoja		:=	SF2->F2_LOJA
	
	DbSelectArea("SD2")
	SD2->( DbSetOrder(3) )  
	SD2->( DbSeek( xFilial( "SD2" ) + cNF + cSerie + cCliente + cLoja ) ) 
	
    	cGrupo := POSICIONE( "SBM",1,xFilial( "SBM" ) + SD2->D2_GRUPO, "BM_DESC" )
	      
	DbSelectArea("SA2")
	SA2->( DbSetOrder(1) )  
	SA2->( DbSeek( xFilial( "SA2" )+cCliente+cLoja ) )
	
	MSCBPRINTER( "105SL","LPT1",,,.F.,,,,, )
	MSCBCHKStatus( .F. )  
	MSCBBEGIN( 1,50,100 )
                                 
    //cVolume := str( nX )+" / "+alltrim( str( nQtd ) )
           
 	// **************************************** ETIQUETA VOLUME ************************************************ //
 
 	MSCBSAY   ( 5,6.50,"LASELVA BOOKSTORE ","N","0","35" )  // X - COLUNA, Y - LINHA, STRING, ROTACAO, TIPO FONTE, TAMANHO     
 	MSCBSAY   ( 5,15,"NF: ","'N","0","45" ) 
 	MSCBSAY   ( 17,15,cNF,"'N","0","45" )    
 	MSCBSAY   ( 52,17,"Data: ","N","0","23" ) 
 	MSCBSAY   ( 61,17,cEmissao,"N","0","23" ) 
 	MSCBSAY   ( 96,16,"Volume: ","N","0","35" )
 	
 	/*
 	If nAux == 1
 		If nx > nQtdori
	 		nx := nQtdori
 		 	MSCBSAY   ( 117,16,cValTochar(nX) + " / " + cValToChar(nQtdori),"N","0","35" )
 		 Else	
			MSCBSAY   ( 117,16,cValTochar(nX) + " / " + cValToChar(nQtdori),"N","0","35" )
 		 EndIf
    Else */
    	MSCBSAY   ( 117,16,cValTochar(nX) + " / " + cValToChar(nQtd),"N","0","35" )
    //EndIf
              
 	MSCBLINEH ( 0, 21, 200,2,"B" ) // LINHA HORIZONTAL 
    		   
 	MSCBSAY   ( 5,23,"Remetente: ","N","0","27" ) 
 	MSCBSAY   ( 5,29,AllTrim( SM0->M0_NOMECOM ),"N","0","33" )  
 	MSCBSAY   ( 5,36,AllTrim( SM0->M0_ENDENT ),"N","0","25" )     
 	MSCBSAY   ( 5,41,AllTrim( SM0->M0_BAIRENT )+" - "+AllTrim( SM0->M0_CIDENT )+" - "+AllTrim( SM0->M0_ESTENT ),"N","0","25" )  
 	MSCBSAY   ( 5,46,AllTrim( Left(SM0->M0_CEPENT,6 )+"-"+Right( SM0->M0_CEPENT,3 ) ),"N","0","25")  
       
 	MSCBLINEH (0, 51, 200,2,"B") // LINHA HORIZONTAL 
    		       		              
 	MSCBSAY   ( 5,53,"Destinatario: ","N","0","27" ) 
 	MSCBSAY   ( 5,59,AllTrim( SA2->A2_NREDUZ ),"N","0","33" ) 
 	MSCBSAY   ( 60,59,AllTrim( SA2->A2_LOJA ),"N","0","33" )
 	MSCBSAY   ( 5,66,AllTrim( SA2->A2_END ),"N","0","25" )     
 	MSCBSAY   ( 5,71,AllTrim( SA2->A2_BAIRRO )+" - "+AllTrim( SA2->A2_MUN )+" - ","N","0","25" )   
   	MSCBSAY   ( 96,69,AllTrim( SA2->A2_EST ),"N","0","40" )  
 	MSCBSAY   ( 5,76,AllTrim( Left(SA2->A2_CEP,6 )+"-"+RighT( SA2->A2_CEP,3 ) ),"N","0","25" )  
 	MSCBLINEH ( 0, 81, 200,2,"B" ) // LINHA HORIZONTAL 
 	MSCBSAY   ( 5,86," GRUPO: ","'N","0","40")   
 	MSCBSAY   ( 63-LEN(AllTrim( cGrupo ) ),86,AllTrim( cGrupo ),"'N","0","40" )   
	 		 			 	
	MSCBEND( )  

 	MSCBCLOSEPRINTER( )  	
EndIf

Return


cNF	  		:= Space( 6 )
cSerie     	:= Space( 3 )
nQtd	  	:= 0
oDlg:Refresh( )

   
Return 