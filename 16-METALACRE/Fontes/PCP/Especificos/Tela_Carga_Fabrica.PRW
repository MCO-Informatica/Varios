#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"                                                                                                         
#INCLUDE "COLORS.CH"    
#INCLUDE "RWMAKE.CH" 

User Function TelaCarga()  


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FINLIBPED ³ Autor ³                        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa que permite visualizar TODOS OS PEDIDOS A VISTA    ³±±
±±³          ³ (PRONTA ENTREGA E PROGRAMACAO) PARA QUE O SERGIO FAÇA A CON ³±±
±±³          ³ FIRMACAO DO PEDIDO COM O CLIENTE.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Millenium Comercial Importadora Ltda.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static nRec:={1,1}       

Local nMax 			:= {||LEN(aCols)}
Local aAlter       	:= {}
Local nSuperior    	:= (076)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= (004)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= (173)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= (285)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local cCampoOk     	:= ""    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= ""    // Funcao executada para validar a exclusao de uma linha do aCols       

lOCAL  aCoresSC5   := {{'(alcarga)->LIMITEDIA > 0 ' , 'BR_VERDE'   },; //SEM OP
                       {'(alcarga)->LIMITEDIA < 0 ' , 'BR_VERMELHO'},;
                       {'(alcarga)->LIMITEDIA =  0 ' , 'BR_AZUL'}} //COM OP
 

Private nOpc        := GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Private oCarga
Private VISUAL 		:= .F.                        
Private INCLUI 		:= .F.                        
Private ALTERA 		:= .F.                        
Private DELETA 		:= .F.                        
Private aCols 		:= {}    
PRIVATE aCPSINT     := {{},{},{},{}}
Private aCampos 	:= {{},{},{},{}}
Private aCampos2 	:= {{},{},{},{}} 
private aCpLotes    := {{},{},{},{}} 
Private nLastRec	:={0,0,0,0}
Private aFile		:={"","","","","",""}
Private cExpr1
Private cExpr2
Private cExpr3
Private cExpr4   
Private cPerg        := "RCarma"    
private aRegis := {}


PRIVATE ALcarga := GETNEXTALIAS()    
PRIVATE ALSint  := GETNEXTALIAS()  
PRIVATE ALSintG := GETNEXTALIAS()  
PRIVATE TMPSC6  := GETNEXTALIAS()    
PRIVATE TMPSC2  := GETNEXTALIAS()    
private prodini := ''
Private ProdFim := ''             
 
PRIVATE AOPS  := {}   

private _aArea := GetArea()                                                       


nSuperior    	:= (016) // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
nEsquerda    	:= (004) // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
nInferior    	:= (200) // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
nDireita     	:= (380) // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem

If cEmpAnt <> '01'
	Return
Endif

Pergunte(cPerg,.T.)      

ProdIni := MV_PAR01
pRODfIM := MV_PAR02
                                              
processa({|| GERAPV()}   ,"Aguarde", "Selecionando Pedidos de Venda") 
processa({|| GERAOP()}   ,"Aguarde", "Selecionando Ops ") 
processa({|| GERATELA()} ,"Aguarde", "Montando Tela ")   
processa({|| SINTETICO()},"Aguarde", "Sintetico ")  
//processa({|| SINTGRU()}  ,"Aguarde", "Sintetico Grupo") 

	DEFINE MSDIALOG oCarga TITLE "Tela de Carga Fabrica"  FROM (178),(200) TO (700),(1400) PIXEL
	// Cria as Folders do Sistema
		oFodlg := TFolder():New((005),(005),{"Detalhado", "Sintetico"/*,"Sintetico Grupo"*/},{},oCarga,,,,.T.,.F.,(600),(250),,)
	
	//BROWSE1 - 
		oBrows1:=TcBrowse():New( 005, 005, 580, 200, , , , oFodlg:aDialogs[1] ,"FLAG",,,,,,oFodlg:aDialogs[1]:oFont,,,,, .F.,ALCarga, .T.,, .F., , ,.f. )
//		oBrows1:=TcBrowse():New( nSuperior-10, nEsquerda, NDIREITA + 90, nInferior-10, , , , oFodlg:aDialogs[1] ,"FLAG",,,,,,oFodlg:aDialogs[1]:oFont,,,,, .F.,ALCARGA, .T.,, .F., , ,.f. )
		OBrows1:BlDblClick:={||(ALCARGA)->(MarcaConfPed())}
		
		oEnable  := LoadBitmap( GetResources(), "LBTIK" ) 
		oDisable := LoadBitmap( GetResources(), "LBNO" ) 
		oBrows1:AddColumn( TCColumn():New( "",{ || CorPedido(1) }			       ,,,, "LEFT", 10, .T., .F.,,,, .T., ))
//		oBrows1:AddColumn( TCColumn():New( "",{ || IF(&(cExpr1),oEnable,oDisable)} ,,,, "LEFT", 10, .T., .F.,,,, .T., ))
		For nX:=1 To Len( aCampos)
			oCol:=TCColumn():New( aCampos[nX][2],FieldWBlock(aCampos[nX][1], Select(ALCARGA)),,,,,,.F.,.F.,,,,.F.,)
			oCol:cPicture:=aCampos[nX][3]
			oBrows1:ADDCOLUMN(oCol)
		Next
	
		oBrows1:nFreeze:=2                                                         
	   @ (215), (050) Button "&Legenda"     size (37),(12) Action(Leg_SC5())		Pixel 	Of oFodlg:aDialogs[1]
	   @ (215), (100) Button "&Pesquisa" 	Size (37),(12) Action(Pesquisa(1))      Pixel   Of oFodlg:aDialogs[1]
	   @ (215), (150) Button "&Pedido" 	    Size (37),(12) Action(Eval({||Posicione( "SC5", 1, xFilial( "SC5" )+(ALCARGA)->C6_NUM, "" ), DetalhaPV(1)}))  Pixel Of oFodlg:aDialogs[1]
	   @ (215), (250) Button "&OP" 			Size (37),(12) Action(Eval({||Posicione( "SC2", 1, xFilial( "SC2" )+(ALCARGA)->C2_NUM, "" ), DetalhaOP(1)}))  Pixel Of oFodlg:aDialogs[1]
	   @ (215), (300) Button "&TOTAIS" 	    Size (37),(12) Action(Totais())       	Pixel   Of oFodlg:aDialogs[1]
	   @ (215), (350) Button "&Impressao"   Size (37),(12) Action(U_CargaFabrica()) Pixel 	Of oFodlg:aDialogs[1]	
	   @ (215), (400) Button "&Sair" 		Size (37),(12) Action(oCarga:End()) 	Pixel 	Of oFodlg:aDialogs[1]	
//	   @ (215), (350) Say "OPs sem lote::" Size C(059),C(008) COLOR CLR_RED 	        PIXEL OF oFodlg:aDialogs[1]	   
//	   @ (215), (400) MsGet   REGZ07  Size C(015),C(007) COLOR CLR_RED   Picture "@!"  		WHEN .F. PIXEL OF oFodlg:aDialogs[1]	   
	      	                                                                                      
           
	//BROWSE2 - 
		oBrows2:=TcBrowse():New( 005, 005, 580, 200, , , , oFodlg:aDialogs[2] ,"FLAG",,,,,,oFodlg:aDialogs[2]:oFont,,,,, .F.,ALSINT, .T.,, .F., , ,.f. )
		OBrows2:BlDblClick:={||(alZ07)->(MarcaConfPed(2))}
		
		oEnable  := LoadBitmap( GetResources(), "LBTIK" ) 
		oDisable := LoadBitmap( GetResources(), "LBNO" ) 
		oBrows2:AddColumn( TCColumn():New( "",{ || CorPedido(2) }			       ,,,, "LEFT", 10, .T., .F.,,,, .T., ))
//		oBrows2:AddColumn( TCColumn():New( "",{ || IF(&(cExpr2),oEnable,oDisable)} ,,,, "LEFT", 10, .T., .F.,,,, .T., ))
		For nX:=1 To Len( aCPSINT)
			oCol:=TCColumn():New( aCPSINT[nX][2],FieldWBlock(aCPSINT[nX][1], Select(alSINT)),,,,,,.F.,.F.,,,,.F.,)
			oCol:cPicture:=aCPSINT[nX][3]
			oBrows2:ADDCOLUMN(oCol)
		Next
	
		oBrows2:nFreeze:=2                                                         
	   @ (215), (050) Button "&Legenda"     size (37),(12) Action(Leg_SC5(2))		Pixel 	Of oFodlg:aDialogs[2]
	   @ (215), (100) Button "&Pesquisa" 	Size (37),(12) Action(Pesquisa(2))      Pixel   Of oFodlg:aDialogs[2]
	   @ (215), (300) Button "&TOTAIS" 	    Size (37),(12) Action(Totais(2))       	Pixel   Of oFodlg:aDialogs[2]
	   @ (215), (350) Button "&Impressao"   Size (37),(12) Action(U_CargaFabrica()) Pixel 	Of oFodlg:aDialogs[2]	
	   @ (215), (400) Button "&Sair" 		Size (37),(12) Action(oCarga:End()) 	Pixel 	Of oFodlg:aDialogs[2]	
	    /*
	//BROWSE1 - 
		oBrows3:=TcBrowse():New( 005, 005, 480, 200, , , , oFodlg:aDialogs[3] ,"FLAG",,,,,,oFodlg:aDialogs[3]:oFont,,,,, .F.,ALlote, .T.,, .F., , ,.f. )
//		oBrows1:=TcBrowse():New( nSuperior-10, nEsquerda, NDIREITA + 90, nInferior-10, , , , oFodlg:aDialogs[1] ,"FLAG",,,,,,oFodlg:aDialogs[1]:oFont,,,,, .F.,ALCARGA, .T.,, .F., , ,.f. )
//		OBrows1:BlDblClick:={||(ALCARGA)->(MarcaConfPed())}
		
		oEnable  := LoadBitmap( GetResources(), "LBTIK" ) 
		oDisable := LoadBitmap( GetResources(), "LBNO" ) 
		oBrows3:AddColumn( TCColumn():New( "",{ || CorPedido(3) }			       ,,,, "LEFT", 10, .T., .F.,,,, .T., ))
//		oBrows3:AddColumn( TCColumn():New( "",{ || IF(&(cExpr1),oEnable,oDisable)} ,,,, "LEFT", 10, .T., .F.,,,, .T., ))
		For nX:=1 To Len( acpLotes)
			oCol:=TCColumn():New( acpLotes[nX][2],FieldWBlock(acpLotes[nX][1], Select(alLote)),,,,,,.F.,.F.,,,,.F.,)
			oCol:cPicture:=acpLotes[nX][3]
			oBrows3:ADDCOLUMN(oCol)
		Next
	
		oBrows3:nFreeze:=2                                                         
	   @ (215), (050) Button "&Legenda"     size (37),(12) Action(Leg_SC5())		Pixel 	Of oFodlg:aDialogs[3]
	   @ (215), (100) Button "&Pesquisa" 	Size (37),(12) Action(PesqZ07(3))       Pixel   Of oFodlg:aDialogs[3]
	   @ (215), (300) Button "&Sair" 		Size (37),(12) Action(oCarga:End()) 	Pixel 	Of oFodlg:aDialogs[3]	
	   @ (215), (350) Say "Lotes com Saldo:" Size C(059),C(008) COLOR CLR_RED 	        PIXEL OF oFodlg:aDialogs[3]	   
	   @ (215), (400) MsGet   nLotes  Size C(015),C(007) COLOR CLR_RED   Picture "@!"  		WHEN .F. PIXEL OF oFodlg:aDialogs[3]	   
	      	                                                                                      
                        */
	
	ACTIVATE MSDIALOG oCarga CENTERED  
	
	(alCarga)->(DbCloseArea()) 
	(alSint)->(DbCloseArea())
	(TMPSC6)->(DbCloseArea())
	(TMPSC2)->(DbCloseArea())

	FErase( aFile[1] ) 
	FErase( aFile[2] )
	FErase( aFile[3] )           
	FErase( aFile[4] )

	restArea(_Aarea)
	
Return(.T.)    

static Function GeraPV()

AREGIS := {}

If Select(TMPSC6) <> 0
	(TMPSC6)->(dbCloseArea())
Endif

cQuery:= " SELECT C6_NUM, C6_NUMOP, C6_PEDCLI, C6_ENTREG, C6_QTDVEN,  BM_CAPDIA, BM_DESC, C6_QTDENT, C6_PRODUTO, " + CRLF
CQUERY+= "  B1_GRUPO, B1_TIPO, A1_NOME, A1_COD, B1_DESC, A1_LOJA, C6_ITEM " + CRLF
cQuery+= " FROM " + RetSqlName("SC6") +  " C6   " +CRLF
cQuery+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
cQuery+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
cQuery+= " , " + RetSqlName("SA1") +  " A1   " +CRLF 
cQuery+= " , " + RetSqlName("SC5") +  " C5   " +CRLF
cQuery+= " WHERE    "
CQUERY+= "          C6_FILIAL='"+XFilial("SC6")+"' AND C6.D_E_L_E_T_<>'*'  " +CRLF  
CQUERY+= " AND      C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      B1.D_E_L_E_T_<>'*'  AND      B1_FILIAL='"+XFilial("SB1")+"' " +CRLF
cQuery+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF  
CQUERY+= " AND      C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5_TIPO = 'N'  " +CRLF
cQuery+= " AND      C6_QTDENT < C6_QTDVEN  AND C6_PRODUTO = B1_COD "+CRLF
cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO) "+CRLF 
//cQuery+= " AND      B1_GRUPO = BM_GRUPO   "+CRLF          
cQuery+= " AND      C6_CLI = A1_COD AND C6_LOJA = A1_LOJA  AND C6_NUMOP = '' " + CRLF 
// PARAMETROS
cQuery+= " AND C6_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "+CRLF
If !Empty(MV_PAR03)
	cQuery+= " AND B1_GRUPO = '" + MV_PAR03 + "'    " +CRLF
EndIf                                              
cQuery+= " AND C6_ENTREG BETWEEN '" + DToS(MV_PAR05) + "' AND '" + DToS(MV_PAR06) + "'    " +CRLF 
cquery+= " group by C6_NUM, C6_NUMOP, C6_PEDCLI, C6_ENTREG, C6_QTDVEN,  BM_CAPDIA, BM_DESC, C6_QTDENT, C6_PRODUTO, " + CRLF
CQUERY+= "  B1_GRUPO, B1_TIPO, A1_NOME, A1_COD, B1_DESC, A1_LOJA, C6_ITEM                            " + CRLF
If MV_PAR04==3
	cQuery+= " ORDER BY C6_ENTREG, B1_GRUPO   " +CRLF
Else
	cQuery+= " ORDER BY C6_ENTREG, C6_PRODUTO   " +CRLF
EndIf

MemoWrite('C:\Qry\GERAPV.txt',cQuery)

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), TMPSC6, .F., .T. ) 
TcSetField( TMPSC6	, "C6_ENTREG"	, "D", 08, 0 )  
TcSetField( TMPSC6	, "C6_QTDVEN"	, "N", 14, 2 )  
TcSetField( TMPSC6	, "BM_CAPDIA"	, "N", 14, 2 )  
TcSetField( TMPSC6	, "C6_QTDENT"	, "N", 14, 2 ) 

  
DBSELECTAREA(TMPSC6)
(TMPSC6)->(dbGoTop())                 
DO WHILE !EOF()  
	IF !EMPTY((TMPSC6)->C6_NUMOP)
		QTDEPRODUZIR := U_PROCURA((TMPSC6)->C6_NUM,"(C2_QUANT-C2_QUJE-C2_PERDA)","SC2","C2_PEDIDO","C2_ITEMPV",(TMPSC6)->C6_ITEM)
		IF VALTYPE(QTDEPRODUZIR) == 'C'
			IF EMPTY(QTDEPRODUZIR)
				LCONTINUA := .F.
			ELSE
				LCONTINUA := .T.
			ENDIF
		ELSEIF QTDEPRODUZIR > 0
			LCONTINUA := .T.
		ELSE
			LCONTINUA := .F.
		ENDIF  
	ELSE
		LCONTINUA := .T.
	ENDIF
	
	IF LCONTINUA
			
		IF LEN(AREGIS) <> 0
			NN := ASCAN(AREGIS,{|_E|_E[1]== (TMPSC6)->C6_NUM .AND.  _E[11]== (TMPSC6)->C6_PRODUTO .AND. _E[5]== (TMPSC6)->C6_ENTREG})
			//ASCAN(_ANOTAFIS ,{|_E|_E[3]== TRBSAIDA->D2_SERIE .and. _E[4]== TRBSAIDA->D2_DOC .and. _E[8]== TRBSAIDA->D2_CLIENTE})
		ELSE
			NN := 0
		ENDIF
		
			IF NN <> 0
	                                                                                     
	
			ELSE
				AADD(AREGIS,{	(TMPSC6)->C6_NUM,;
								(TMPSC6)->A1_NOME,;
								(TMPSC6)->C6_NUMOP,;
								alltrim((TMPSC6)->C6_PEDCLI),;
								(TMPSC6)->C6_ENTREG,;
								'',;
								(TMPSC6)->C6_QTDVEN,;
								0 ,;
								(TMPSC6)->C6_QTDVEN - (TMPSC6)->C6_QTDENT,;
								(TMPSC6)->BM_CAPDIA,;
								(TMPSC6)->C6_PRODUTO,;
								(TMPSC6)->BM_DESC, (TMPSC6)->B1_GRUPO, (TMPSC6)->B1_DESC })
			ENDIF 
	ENDIF
	DBSELECTAREA(TMPSC6)
	(TMPSC6)->(DBSKIP())
ENDDO					
				


Return                                               


static Function GeraOP()

If Select(TMPSC2) <> 0
	(TMPSC2)->(dbCloseArea())
Endif

cQuery:= " SELECT C2_PEDIDO, C2_ITEMPV, C2_PRODUTO, C2_NUM, C2_ITEM, C2_SEQUEN, A1_NOME, C2_DATAJF, "
CQUERY+= " B1_GRUPO, BM_DESC, BM_CAPDIA, C2_QUANT, C2_QUJE, C2_DATPRF, B1_DESC FROM "   +CRLF
cQuery+= " " + RetSqlName("SC2") +  " C2   " +CRLF
cQuery+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
cQuery+= " , " + RetSqlName("SA1") +  " A1   " +CRLF
cQuery+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
cQuery+= " WHERE    "
CQUERY+= "          C2_FILIAL='"+XFilial("SC2")+"' AND C2.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      B1.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF   
cQuery+= " AND      B1_FILIAL='"+XFilial("SB1")+"' AND B1.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      C2_PRODUTO = B1_COD  "+CRLF         
cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO) "+CRLF 
cQuery+= " AND      C2_CLI = A1_COD AND C2_LOJA = A1_LOJA "
CQUERY+= " AND (C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') ) " +CRLF
// PARAMETROS
cQuery+= " AND C2_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "+CRLF
If !Empty(MV_PAR03)
	cQuery+= " AND B1_GRUPO = '" + MV_PAR03 + "'   " +CRLF
EndIf                                              
cQuery+= " AND C2_DATPRF BETWEEN '" + DToS(MV_PAR05) + "' AND '" + DToS(MV_PAR06) + "'    " +CRLF                            
If MV_PAR04==3
	cQuery+= " ORDER BY C2_DATPRF, B1_GRUPO   " +CRLF
Else
	cQuery+= " ORDER BY C2_DATPRF, C2_PRODUTO   " +CRLF
EndIf

MemoWrite('C:\Qry\TMPSC2.txt',cQuery)

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), TMPSC2, .F., .T. )
TcSetField( TMPSC2	, "C2_DATAJF"	, "D", 08, 0 )  
TcSetField( TMPSC2	, "C2_DATPRF"	, "D", 08, 0 ) 
TcSetField( TMPSC2	, "C2_QUANT"	, "N", 14, 2 )  
TcSetField( TMPSC2	, "BM_CAPDIA"	, "N", 14, 2 )  
TcSetField( TMPSC2	, "C2_QUJE"  	, "N", 14, 2 ) 

DBSELECTAREA(TMPSC2)
(TMPSC2)->(dbGoTop())
DO WHILE !EOF()  
	IF !EMPTY((TMPSC2)->C2_PEDIDO) 
		NOTA := U_PROCURA((TMPSC2)->C2_PEDIDO,"C6_NOTA","SC6","C6_NUM","C6_ITEM",(TMPSC2)->C2_ITEMPV)
		IF EMPTY(NOTA)         
			NN := ASCAN(AREGIS,{|_E|_E[3]== (TMPSC2)->C2_NUM .AND.  _E[11]== (TMPSC2)->C2_PRODUTO .AND.  _E[5]== (TMPSC2)->C2_DATPRF})
			//ASCAN(_ANOTAFIS ,{|_E|_E[3]== TRBSAIDA->D2_SERIE .and. _E[4]== TRBSAIDA->D2_DOC .and. _E[8]== TRBSAIDA->D2_CLIENTE})
			IF NN <> 0     
			   aregis[NN][5] := (TMPSC2)->C2_DATPRF
			   aregis[NN][8] := (TMPSC2)->C2_QUANT 
			   AREGIS[NN][9] := AREGIS[NN][9] - (TMPSC2)->C2_QUJE
			   // SE O TOTAL FOR ZERO, OU SEJA A QUANTIDADE PRODUZIDA JA FOR IGUAL A DO PEDIDO, ENTÃO NÃP PRECISA APARECER NO RELATORIO.
			ELSE
				AADD(AREGIS,{	(TMPSC2)->C2_PEDIDO,;
								(TMPSC2)->A1_NOME,;
								(TMPSC2)->C2_NUM,;
								'',;
								(TMPSC2)->C2_DATPRF,;
								(TMPSC2)->C2_DATAJF,;
								0,;
								(TMPSC2)->C2_QUANT ,;
								(TMPSC2)->C2_QUANT - (TMPSC2)->C2_QUJE,;
								(TMPSC2)->BM_CAPDIA,;
								(TMPSC2)->C2_PRODUTO,;
								(TMPSC2)->BM_DESC, (TMPSC2)->B1_GRUPO, (TMPSC2)->B1_DESC })
			ENDIF  
		ENDIF      
	ELSE                                            
			AADD(AREGIS,{	SPACE(6),;
							(TMPSC2)->A1_NOME,;
							(TMPSC2)->C2_NUM,;
							'',;
							(TMPSC2)->C2_DATPRF,;
							(TMPSC2)->C2_DATAJF,;
							0,;
							(TMPSC2)->C2_QUANT ,;
							(TMPSC2)->C2_QUANT - (TMPSC2)->C2_QUJE,;
							(TMPSC2)->BM_CAPDIA,;
							(TMPSC2)->C2_PRODUTO,;
							(TMPSC2)->BM_DESC, (TMPSC2)->B1_GRUPO, (TMPSC2)->B1_DESC })
	ENDIF	
	DBSELECTAREA(TMPSC2)
	(TMPSC2)->(DBSKIP())
ENDDO					


Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FINLIBPED ³ Autor ³                        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa que permite visualizar TODOS OS PEDIDOS A VISTA    ³±±
±±³          ³ (PRONTA ENTREGA E PROGRAMACAO) PARA QUE O SERGIO FAÇA A CON ³±±
±±³          ³ FIRMACAO DO PEDIDO COM O CLIENTE.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Millenium Comercial Importadora Ltda.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/***************************/
Static Function GeraTela()
/***************************/

cExpr1:="(alCarga)->Flag==cMarca"
If Select( alCarga )>0
	(alCarga)->(DbCloseArea())
	FErase( aFile[3] )
EndIf      
                      
aRegis := aSort(aRegis,,,{|_x,_y|_x[5] <=_y[5]})
//AQUI SELECIONA OS CAMPOS 
aCampos:={}  
//Aadd(aCampos ,{ "FLAG"   		,	" "	        ,	"@!" }) 
Aadd(aCampos ,{ "C6_NUM"		,	"Pedido"	,	"@!" }) 
Aadd(aCampos ,{ "A1_NOME" 		,	"Cliente"	,	"@!" })
Aadd(aCampos ,{ "C2_NUM"		,	"OP"   	,	"@!" })         
Aadd(aCampos ,{ "C6_PEDCLI"    	,	"Ped Cliente"    	,	"@!" })   
Aadd(aCampos ,{ "C6_ENTREG"    	,	"Dt Entrega"    	,	"@!" }) 
Aadd(aCampos ,{ "QTDABERTO"		,	"Qtde Aberto"	,	"@!" })
Aadd(aCampos ,{ "BM_CAPDIA"		,	"Capac Diaria"		,	"@!" })
Aadd(aCampos ,{ "GRUPODIA"		,	"Total Grupo Dia "	,	"@!" })
Aadd(aCampos ,{ "LIMITEDIA"  	,	"Qtde limite dia"   ,	"@!" })  
//Aadd(aCampos ,{ "saldoDia"  	,	"SALDO dia"   ,	"@!" })  


aStru := {}
AADD(aStru,{ "C6_NUM"    , "C", TAMSX3("C6_NUM")[1]   , TAMSX3("C6_NUM")[2]})
AADD(aStru,{ "A1_NOME"   , "C", TAMSX3("A1_NOME")[1]  , TAMSX3("A1_NOME")[2]})
AADD(aStru,{ "C2_NUM"    , "C", TAMSX3("C2_NUM")[1]   , TAMSX3("C2_NUM")[2]})
AADD(aStru,{ "C6_PEDCLI" , "C", TAMSX3("C6_PEDCLI")[1], TAMSX3("C6_PEDCLI")[2]})
AADD(aStru,{ "C6_ENTREG" , "D", TAMSX3("C6_ENTREG")[1], TAMSX3("C6_ENTREG")[2]})
AADD(aStru,{ "QTDABERTO" , "N", TAMSX3("C6_QTDVEN")[1], TAMSX3("C6_QTDVEN")[2]})
AADD(aStru,{ "BM_CAPDIA" , "N", TAMSX3("BM_CAPDIA")[1], TAMSX3("BM_CAPDIA")[2]})
AADD(aStru,{ "GRUPODIA"  , "N", TAMSX3("C6_QTDVEN")[1], TAMSX3("C6_QTDVEN")[2]})
AADD(aStru,{ "LIMITEDIA" , "N", TAMSX3("C6_QTDVEN")[1], TAMSX3("C6_QTDVEN")[2]})
Aadd(aStru ,{ "saldoDia" , "N", TAMSX3("C6_QTDVEN")[1], TAMSX3("C6_QTDVEN")[2]})


aFile[3]:=CriaTrab(aStru,.T.)
DbUseArea( .t., "DBFCDX", aFile[3], alCARGA )

DbSelectArea( alCARGA )
DbGoTop()  
FOR II := 1 TO LEN(AREGIS) 
	cargadia :=  u_CargaGrp(AREGIS[II][13], AREGIS[II][5], AREGIS[II][5],PRODINI,PRODFIM)        
	RECLOCK((ALCARGA),.T.) 
		(ALCARGA)->C6_NUM   := AREGIS[II][1]
		(ALCARGA)->A1_NOME  := AREGIS[II][2]
		(ALCARGA)->C2_NUM   := AREGIS[II][3]
		(ALCARGA)->C6_PEDCLI:= AREGIS[II][4]
		(ALCARGA)->C6_ENTREG:= AREGIS[II][5]
		(ALCARGA)->QTDABERTO:= AREGIS[II][9]
		(ALCARGA)->BM_CAPDIA:= AREGIS[II][10] 
		(ALCARGA)->GRUPODIA := cargadia
		(ALCARGA)->LIMITEDIA:= AREGIS[II][10]  -  cargadia   
		(ALCARGA)->SALDODIA := cargadia - AREGIS[II][10]
	 (ALCARGA)->(MSUNLOCK())
NEXT II
 
	
DbSelectArea( alCARGA )
DbGoTop()  

Return Nil


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³leg_sc5   ³ Autor ³FLAVIA AGUIAR           ³ Data ³27/11/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Legenda do browse de confirmacoes 								   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Leg_SC5()

cCadastro := "Legenda"

aCores2 := { { 'BR_VERDE'    , "Carga com limite disponivel"   },;
   			 { 'BR_AZUL'     , "Carga com limite zerado"       },;
             { 'BR_VERMELHO' , "Carga Excedida"                }}
          
BrwLegenda(cCadastro,"Legenda",aCores2)

Return   

   
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Confirma  ³ Autor ³FLAVIA AGUIAR           ³ Data ³27/11/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de confirmacao do pedido   						   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
Static Function MarcaConfPed()

Local nRecWk2

RecLock( alCarga, .f. )
	(alCarga)->Flag:=If( (alCarga)->Flag=cMarca, "  ", cMarca )
MsUnLock()

Return Nil   

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CorPEDIDO ³ Autor ³FLAVIA AGUIAR           ³ Data ³27/11/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de confirmacao do pedido   								   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
Static Function CorPedido(janela) 
                                                        
Local cCor

cCor:=LoadBitmap( GetResources(), "BR_AMARELO" )

/*	If &cExpr1
		cCor:=LoadBitmap( GetResources(), "BR_AMARELO" )
	Else
		cCor:=LoadBitmap( GetResources(), "BR_VERMELHO" )
	EndIf
  */	                                              
if JANELA = 1	           
	If (ALCARGA)->LIMITEDIA > 0
		cCor:=LoadBitmap( GetResources(), 'BR_VERDE' )
	elseif (ALCARGA)->LIMITEDIA = 0
		cCor:=LoadBitmap( GetResources(), 'BR_AZUL' )	
	Elseif (ALCARGA)->LIMITEDIA < 0
		cCor:=LoadBitmap( GetResources(), 'BR_VERMELHO' )
	EndIf    
ELSEIF JANELA = 2
	If (ALSINT)->LIMITEDIA > 0
		cCor:=LoadBitmap( GetResources(), 'BR_VERDE' )
	elseif (ALSINT)->LIMITEDIA = 0
		cCor:=LoadBitmap( GetResources(), 'BR_AZUL' )	
	Elseif (ALSINT)->LIMITEDIA < 0
		cCor:=LoadBitmap( GetResources(), 'BR_VERMELHO' )
	EndIf    

ENDIF

Return cCor   


STATIC FUNCTION PESQuisa(JANELA)
   
                    
Pergunte(cPerg,.T.)   

IF JANELA = 1
                                              
	processa({|| GERAPV()}  ,"Aguarde", "Selecionando Pedidos de Venda") 
	processa({|| GERAOP()}  ,"Aguarde", "Selecionando Ops ") 
	processa({|| GERATELA()},"Aguarde", "Montando Tela ") 
ELSEIF JANELA = 2
	processa({|| GERAPV()}   ,"Aguarde", "Selecionando Pedidos de Venda") 
	processa({|| GERAOP()}   ,"Aguarde", "Selecionando Ops ") 
	processa({|| GERATELA()} ,"Aguarde", "Montando Tela ")   
	processa({|| SINTETICO()},"Aguarde", "Sintetico ")  
//	processa({|| SINTGRU()}  ,"Aguarde", "Sintetico Grupo") 	
ENDIF
	
	SYSREFRESH()

RETURN   

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DETALHAPED³ Autor ³FLAVIA AGUIAR           ³ Data ³27/11/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de confirmacao do pedido   						   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
Static Function DetalhaOP(JANELA)

Local aCabPV  := {}
Local aItemPV := {}
Local aItem   := {}
Local _nOpc   := 2  
Local aPedExp := {}, cQuery := "", aPedDraw := {}, aPedDefer := {},aNedDefer := {}
  
PRIVATE aRotina := {	{"Pesquisar","AxPesqui"  , 0 , 1, 0, .F.},;	//"Pesquisar"
						{"Visualizar","A650View"  , 0 , 2, 0, .F.},;	//"Visualizar"
						{"Incluir","A650Inclui", 0 , 3, 0, nil},;	//"Incluir"
						{"Alterar","A650Altera", 0 , 4, 0, nil},;	//"Alterar"
						{"Excluir","A650Deleta", 0 , 5, 0, nil},;	//"Excluir"
						{"venDas","A650Automa", 0 , 6, 0, nil}}	//"venDas"
Private lMshelpAuto := .t.
Private lMsErroAuto := .f.   
private cCadastro := "Ordens de Produçao"

M->C2_Num:=Sc2->C2_Num
A650VIEW("SC2",SC2->(RecNo()),2)

BO_confped()
sysrefresh()

Return Nil     

Static Function DetalhaPV()

PRIVATE aRotina := {{ "Pesquisar","AxPesqui"  ,0,1},;	
					{ "Visual","A410Visual"   ,0,2},;	
					{ "Incluir","A410Inclui"  ,0,3},;	
					{ "Alterar","A410Altera"  ,0,4},;
					{ "Excluir","A410Deleta"  ,0,5}}
Private lMshelpAuto := .t.
Private lMsErroAuto := .f.  
private cCadastro := "Pedido de Venda"
Private _aarea := Getarea()      
	
m->C5_Num:=Sc5->C5_Num
A410Visual("SC5",Sc5->(RecNo()),2)
                            
BO_confped()
sysrefresh()

Return


Static Function Totais()


Local cdata   
LOCAL TOTABERTO := 0
LOCAL TOTCAPAC  := 0
LOCAL TOTSALDO  := 0 
LOCAL TOTGRUDIA := 0
Local oSButton1     
LOCAL GRUPO   := '' 
local cargadiaria   
local agrupos := {}

Private Cargatotal  
Private aTotais := {} 
Private _aarea := Getarea()    

aRegis := aSort(aRegis,,,{|_x,_y|_x[5] <=_y[5]})

For II:= 1 to len(aregis)
	if !empty(cdata) .and. cData <> AREGIS[II][5]  
		AADD(ATOTAIS,{CDATA, TOTABERTO, TOTCAPAC, TOTGRUDIA, TOTSALDO,GRUPO})
		TOTABERTO := 0
		TOTCAPAC  := 0
		TOTSALDO  := 0                                       
		TOTGRUDIA := 0   
		agrupos   := {}
	ENDIF
	
	cargadiaria := u_CargaGrp(AREGIS[II][13], AREGIS[II][5], AREGIS[II][5],PRODINI,PRODFIM) 
	TOTABERTO += AREGIS[II][9]

	NN := ASCAN(agrupos,ALLTRIM(AREGIS[II][13]))
	IF NN == 0
		TOTGRUDIA := TOTGRUDIA + cargadiaria  
		TOTCAPAC  := TOTCAPAC  + AREGIS[II][10] 
		aadd(agrupos,ALLTRIM(AREGIS[II][13]))
	ENDIF                            
	
	TOTSALDO  := TOTCAPAC - TOTGRUDIA
	CDATA := AREGIS[II][5]                               
	GRUPO := AREGIS[II][13]
NEXT II 

		AADD(ATOTAIS,{CDATA, TOTABERTO, TOTCAPAC, TOTGRUDIA, TOTSALDO, GRUPO})
		TOTABERTO := 0
		TOTCAPAC  := 0
		TOTSALDO  := 0 
		TOTGRUDIA := 0


  DEFINE MSDIALOG Cargatotal TITLE "Totais" FROM 000, 000  TO 400, 600 COLORS 0, 16777215 PIXEL

    fWBrowse1()
//    DEFINE SBUTTON oSButton1 FROM 020, 253 TYPE 01 OF Cargatotal action close(cargatotal) ENABLE

  ACTIVATE MSDIALOG Cargatotal CENTERED

RestArea(_aarea)

Return 

//------------------------------------------------
Static Function fWBrowse1()
//------------------------------------------------
Local oWBrowse1
Local aWBrowse1 := {}

    // Insert items here 
    If Len(atotais) > 0
       for KK := 1 to len(atotais)
           Aadd(aWBrowse1,{aTotais[kk][1],aTotais[kk][2],aTotais[kk][3],aTotais[kk][4],aTotais[kk][5]})	
       next kk
    else
	    Aadd(aWBrowse1,{"Data","Total Aberto","Total Capacidade","Total Grupo Dia", "Total Saldo"})
    endif

    @ 006, 006 LISTBOX oWBrowse1 Fields HEADER "Data","Total Aberto","Total Capacidade","Total Grupo Dia", "Total Saldo" SIZE 275, 178 OF Cargatotal PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      aWBrowse1[oWBrowse1:nAt,1],;
      aWBrowse1[oWBrowse1:nAt,2],;
      aWBrowse1[oWBrowse1:nAt,3],;
      aWBrowse1[oWBrowse1:nAt,4],; 
      aWBrowse1[oWBrowse1:nAt,5];
    }}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
      oWBrowse1:DrawSelect()}

Return     

Static Function Sintetico()       

Local AGru := {}

cExpr2:="(alSint)->Flag==cMarca"
If Select( alSint )>0
	(alSint)->(DbCloseArea())
	FErase( aFile[4] )
EndIf      
                      
aRegis := aSort(aRegis,,,{|_x,_y|_x[5] <=_y[5]})
//AQUI SELECIONA OS CAMPOS 
aCPSINT:={}  
//Aadd(aCampos ,{ "FLAG"   		,	" "	        ,	"@!" })   
Aadd(aCPSINT ,{ "DATAENT"		,	"Dt Entrega"	,	"@!" }) 
Aadd(aCPSINT ,{ "CODIGO"		,	"CODIGO"	,	"@!" }) 
Aadd(aCPSINT ,{ "DESCRICAO"		,	"DESCRICAO"	,	"@!" })
Aadd(aCPSINT ,{ "QTDABERTO"		,	"Qtde Aberto"	,	"@!" })
Aadd(aCPSINT ,{ "BM_CAPDIA"		,	"Capac Diaria"		,	"@!" })
Aadd(aCPSINT ,{ "GRUPODIA"		,	"Total Grupo Dia "	,	"@!" })
Aadd(aCPSINT ,{ "LIMITEDIA"  	,	"Qtde limite dia"   ,	"@!" })  
//Aadd(aCampos ,{ "saldoDia"  	,	"SALDO dia"   ,	"@!" })  


aStru := {}     
AADD(aStru,{ "DATAENT"    , "D", TAMSX3("C6_ENTREG")[1]   , TAMSX3("C6_ENTREG")[2]})
AADD(aStru,{ "CODIGO"    , "C", TAMSX3("B1_COD")[1]   , TAMSX3("B1_COD")[2]})
AADD(aStru,{ "DESCRICAO"   , "C", TAMSX3("B1_DESC")[1]  , TAMSX3("B1_DESC")[2]})
AADD(aStru,{ "QTDABERTO" , "N", TAMSX3("C6_QTDVEN")[1], TAMSX3("C6_QTDVEN")[2]})
AADD(aStru,{ "BM_CAPDIA" , "N", TAMSX3("BM_CAPDIA")[1], TAMSX3("BM_CAPDIA")[2]})
AADD(aStru,{ "GRUPODIA"  , "N", TAMSX3("C6_QTDVEN")[1], TAMSX3("C6_QTDVEN")[2]})
AADD(aStru,{ "LIMITEDIA" , "N", TAMSX3("C6_QTDVEN")[1], TAMSX3("C6_QTDVEN")[2]})
Aadd(aStru ,{ "saldoDia" , "N", TAMSX3("C6_QTDVEN")[1], TAMSX3("C6_QTDVEN")[2]})


aFile[4]:=CriaTrab(aStru,.T.)
DbUseArea( .t., "DBFCDX", aFile[4], alSint)     


FOR II := 1 TO LEN(AREGIS)  
	
	if AREGIS[II][9] == 0

	ELSE
		NN:= ASCAN(AGRU  ,{|_E|_E[1]== AREGIS[II][11]   .and.  _E[6]== AREGIS[II][5]})      
	   //ASCAN(AREGIS,{|_E|_E[3]== (TMPSC2)->C2_NUM .AND.  _E[11]== (TMPSC2)->C2_PRODUTO})
		IF NN == 0   // CODIGO, DESCRICAO, QTDABERTO, CAPDIA, 
			aadd(aGru,{AREGIS[II][11], AREGIS[II][14], AREGIS[II][9],AREGIS[II][10],aregis[II][13],aRegis[II][5]})
		ELSE
			AGRU[NN][3] := AGRU[NN][3] + AREGIS[II][9]
			AGRU[NN][4] := AREGIS[II][10]
		ENDIF 
  	endif
NEXT II      


DbSelectArea( alSint )
DbGoTop()  
FOR GRU := 1 TO LEN(AGRU) 
	cargadia :=  u_CargaGrp(AGRU[GRU][5], (AGRU[GRU][6]), (AGRU[GRU][6]),prodini,prodfim)         
	RECLOCK((ALSint),.T.)    
		(AlSint)->DATAENT    := AGRU[GRU][6]
		(ALSint)->CODIGO     := AGRU[GRU][1]
		(ALSint)->DESCRICAO  := AGRU[GRU][2]
		(ALSint)->QTDABERTO  := AGRU[GRU][3]
		(ALSint)->BM_CAPDIA  := AGRU[GRU][4] 
		(ALSint)->GRUPODIA   := cargadia
		(ALSint)->LIMITEDIA  := AGRU[GRU][4]  -  cargadia   
		(ALSint)->SALDODIA   := cargadia - AGRU[GRU][4]
	 (ALSint)->(MSUNLOCK())
NEXT II
 
	
DbSelectArea( ALSint )
DbGoTop()  

Return Nil



Return  

Static Function SintGru()

Local	aGru    := {}    
Local	cgrpatu := aRegis[1][13]	
Local	cDatAtu := aRegis[1][5]
	
Local	nQADia:= 0
Local	nCTotGeral:=0
Local	nLimGeral :=0
Local	nQADiaTot :=0
Local	nQAP80 	  :=0
Local	nCTotD80  :=0
Local	cDesc80	  :=""
Local	nQAP22 	  :=0
Local	nCTotD22  :=0
Local	cDesc22	  :=""    
LOCAL   DTENT 

	aRegis  := aSort(aRegis,,,{|_x,_y|_x[5]+_x[13] <=_y[5]+_y[13]})
	
	FOR II := 1 TO LEN(AREGIS)
		
	   if AREGIS[II][9] == 0

		ELSE
	
			cDesAnt := AREGIS[II][12] //TRB->BM_DESC
			cGrpAnt := AREGIS[II][13] //TRB->B1_GRUPO
			
			If AllTrim(AREGIS[II][13]) $ "612/613"    //Familia 80 e 81 e 83
				nQAP80   += AREGIS[II][9]
				nCTotD80 := AREGIS[II][10]
				cDesc80  += If (AllTrim(AREGIS[II][12]) $ cDesc80, "", AllTrim(AREGIS[II][12]) + " / ") 
			ELSEIF AllTrim(AREGIS[II][13]) $ "605/617" //cGrpAnt == AREGIS[GRU][13]
				nQAP22   += AREGIS[II][9]
				nCTotD22 := AREGIS[II][10]
				cDesc22  += If (AllTrim(AREGIS[II][12]) $ cDesc22, "", AllTrim(AREGIS[II][12]) + " / ")      
			ENDIF 				
	
			NN:= ASCAN(AGRU,{|_E|_E[1]== AREGIS[II][13]})
			IF NN == 0 
				aadd(aGru,{AREGIS[II][13], AREGIS[II][12], AREGIS[II][9],AREGIS[II][10],AREGIS[II][5]})
			ELSE
				AGRU[NN][3] := AGRU[NN][3] + AREGIS[II][9]         //    qtde produzir
				AGRU[NN][4] := AREGIS[II][10]                      // capac diaria
			ENDIF

		    	// AI IMPRIME OS GRUPOS Q ACHOU NA DATA E ZERA O ARRAY DOS GRUPOS.
				// faz a impressao dos dados.				
			cDatAtu := aRegis[II][5]
    	ENDIF
	NEXT II      
	   
	// imprime o ultimo
	FOR GRU := 1 TO LEN(AGRU)  
//		IF !EMPTY(  

		DBSELECTAREA(ALSINTG)
		DBGOTOP()
		RECLOCK(ALSINTG,.T.)
			(ALSINTG)->DTENT := AGRU[GRU][5]
			(ALSINTG)->GRUPO := AGRU[GRU][1]
			(ALSINTG)->DESCG := AGRU[GRU][2]
						
			cargadia := u_CargaGrp(AGRU[GRU][1], SToD(cDatAtu), SToD(cDatAtu),prodini,prodfim)
			
			(ALSINTG)->QTDABERTO := AGRU[GRU][3]
			(ALSINTG)->CAPDIARIA := AGRU[GRU][4]		
			(ALSINTG)->LIMITEDIA := AGRU[GRU][4]- AGRU[GRU][3]
		(ALSINTG)->(MSUNLOCK())  
		cDatAtu := AGRU[GRU][5]
	NEXT GRU
	        
	If nQAP80>0

				@nLin,005 PSAY "TOTAL DIA/GRUPO: "
				@nLin,025 PSAY "612/613"
				@nLin,045 PSAY "Familia REF.80 / Familia REF.81 / Familia REF.83" //cDesc80
				
				@nLin,100 PSAY nQAP80 Picture "@E 999,999,999"
				@nLin,120 PSAY nCTotD80 Picture "@E 999,999,999"
				@nLin,140 PSAY nCTotD80-nQAP80 Picture "@E 999,999,999"
				nLin++
				nQAP80 	  :=0
				nCTotD80  :=0
				cDesc80	  :=""
			EndIF

			If nQAP22>0
				@nLin,005 PSAY "TOTAL DIA/GRUPO: "
				@nLin,025 PSAY "605/617"
				@nLin,045 PSAY "Familia REF.22"//cDesc22
				
				@nLin,100 PSAY nQAP22 Picture "@E 999,999,999"
				@nLin,120 PSAY nCTotD22 Picture "@E 999,999,999"
				@nLin,140 PSAY nCTotD22 - nQAP22 Picture "@E 999,999,999"
				nLin++
				nQAP22 	  :=0
				nCTotD22  :=0
				cDesc22	  :=""
			EndIF	        
	    
			nLin++
			@nLin,040 PSAY "TOTAL GERAL DIA: " +  DToC(SToD(cDatatu))
			@nLin,100 PSAY nQADia    Picture "@E 999,999,999"
			@nLin,120 PSAY nCTotGeral Picture "@E 999,999,999"
			@nLin,140 PSAY nLimGeral Picture "@E 999,999,999"
			
			nLin++
			@nLin,000 PSAY Replicate("_",220)                
			nLin++                                           
			
			nQADiaTot+= nQADia
			nQADia     := 0
			nCTotGeral := 0
			nLimGeral  := 0	    
	    	
	nLin++
	@nLin,040 PSAY "TOTAL GERAL PERIODO: " +  DToC(MV_PAR05) +" ATE "+DToC(MV_PAR06)
	@nLin,100 PSAY nQADiaTot 	   Picture "@E 999,999,999,999,999"
	@nLin,000 PSAY Replicate("_",220)
	

Return


