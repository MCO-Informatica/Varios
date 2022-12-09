#include "rwmake.ch"
#include "colors.ch"   
#include "PROTHEUS.ch"       
#INCLUDE "TOPCONN.CH

//--------------------------------------------------------------
/*/{Protheus.doc} AltData
Description

@param xParam Parameter Description
@return xRet Return Description                                 
@author  -
@since 03/07/2013
/*/
//--------------------------------------------------------------
User Function AltData()       


Private aRet 		:= {}
Private aParambox   := {}  
Private lRet        := .T.        
Private cCadastro   := ""  
private PEDIDO      := ''    
PRIVATE LGO         := .T.

// PARA TIPO 1 = MSGET:TIPO, DESCRICAO, INICIALIZADOR CAMPO, PICTURE CAMPO,VALIDACAO, F3,WHEN,TAMANHO,OBRIGATORIO(T/F)  
//Aadd(aParambox,{1,"Data Inicial"         ,  ,"99/99/99" ,"","","",0,.T.})         
Aadd(aParambox,{1,"Pedido :"    , space(6) ,           ,"","SC5","",0,.T.})         // 09      

// para tipo 2 = combo: TIPO, DESCRICAO, OPCAO INICIAL, TAMANHO, VALIDACAO, OBRIG
//Aadd(aParambox,{1,"Inter ",Space(8),'99/99/99',"","","",0,.f.})          

DO WHILE LGO
	IF Parambox(aParambox,"Escolha o Pedido de Venda",@aRet,   ,         , .T.      ,     ,      ,         ,      ,.T.,.T.)
		PEDIDO     := ARET[1]   
		DBSELECTAREA("SC5")
		DBSETORDER(1)
		IF DBSeEK(XFILIAL("SC5") + PEDIDO )
			ALTENTREGA()
		ELSE
			MSGALERT("PEDIDO NAO ENCONTRADO")
		ENDIF
	else
		lGo := .F.
	ENDIF	          
ENDDO	

Return

Static Function Altentrega()

Local getCli
Local cetCli := ALLTRIM(SC5->C5_NOMECLI)
Local getPed
Local cetPed := ALLTRIM(SC5->C5_NUM)
Local oSButton1
Local oSButton2

PRIVATE odlgTroca
PRIVATE ALTROCA := GETNEXTALIAS()    
private aItens  := {}

  DEFINE MSDIALOG odlgTroca TITLE "Troca Data" FROM 000, 000  TO 430, 800 COLORS 0, 16777215 PIXEL

    fWBrowse1()
    @ 011, 008 SAY "Pedido" SIZE 025, 007 OF odlgTroca COLORS 0, 16777215 PIXEL
    @ 011, 042 MSGET getPed VAR cetPed SIZE 060, 010 OF odlgTroca COLORS 0, 16777215 ON CHANGE TRAZITENS() F3 "SC5" PIXEL

    @ 027, 007 SAY  "Cliente" SIZE 025, 007 OF odlgTroca COLORS 0, 16777215 PIXEL
    @ 024, 042 MSGET getCli VAR cetCli SIZE 296, 010 OF odlgTroca COLORS 0, 16777215 READONLY PIXEL

    DEFINE SBUTTON oSButton1 FROM 006, 360 TYPE 01 OF odlgTroca ENABLE ACTION Troca()
    DEFINE SBUTTON oSButton2 FROM 025, 360 TYPE 02 OF odlgTroca ENABLE ACTION Close(odlgTroca)

  ACTIVATE MSDIALOG odlgTroca CENTERED

Return

//------------------------------------------------ 
Static Function fWBrowse1()
//------------------------------------------------ 

Local nX
Local aHeaderEx 	:= {}
Local aColsEx 		:= {}
Local aFieldFill 	:= {}
Local aFields 		:= {"C6_ITEM","C6_PRODUTO","C6_QTDVEN","C6_ENTREG","NEWDATA","CARGADIA","LIMDIA","B1_GRUPO"}
Local aAlterFields 	:= {"NEWDATA"}  
LOCAL GRUPO         := ''
Local CARGADIARIA   := 0 
local limdir        := 0

Private oMSNewGe1    


  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)  
  	IF aFields[nX] == "NEWDATA"
  		SX3->(DbSeek('C6_ENTREG')) 
  		Aadd(aHeaderEx, {"Nova Data","NEWDATA",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  	ELSEIF aFields[nX] == "CARGADIA"
  		SX3->(DbSeek('BM_CAPDIA')) 
  		Aadd(aHeaderEx, {"Qtde Dia","CARGADIA",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  	ELSEIF aFields[nX] == "LIMDIA"
  		SX3->(DbSeek('BM_CAPDIA')) 
  		Aadd(aHeaderEx, {"Lim Dia","LIMDIA",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  	ELSE
    	SX3->(DbSeek(aFields[nX]))
	    Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,,;
    	                   SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})

    ENDIF
      
    
  Next nX

    // Insert items here  
    IF SELECT(ALTROCA)>0
    	(ALTROCA)->(DBCLOSEAREA())
    EndIf
    
    	CQUERY := " SELECT * FROM "
    	CQUERY += " " + RETSQLNAME("SC6") + " C6 "
    	CQUERY += " WHERE C6.D_E_L_E_T_ = '' and C6_FILIAL = '" + XFILIAL("SC6") + "' AND C6_NUM = '" + PEDIDO + "' "  
    	CQUERY += " AND C6_QTDENT < C6_QTDVEN <> 0 "
    	MemoWrite('C:\Qry\ALTDATAENT.txt',cQuery)

		DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), ALTROCA, .F., .T. ) 
		TcSetField( ALTROCA	, "C6_ENTREG"	, "D", 08, 0 )  
		TcSetField( ALTROCA	, "C6_QTDVEN"	, "N", 14, 2 )  
		
		DBSELECTAREA(ALTROCA)
		DBGOTOP()  
		DO WHILE !EOF()    
			GRUPO := U_PROCURA((ALTROCA)->C6_PRODUTO,"B1_GRUPO","SB1","B1_COD","B1_FILIAL",XFILIAL("SB1"))
			CARGADIARIA := u_CargaGrp(Grupo, (ALTROCA)->C6_ENTREG, (ALTROCA)->C6_ENTREG ,(ALTROCA)->C6_PRODUTO,(ALTROCA)->C6_PRODUTO)   
			LIMDIR := U_PROCURA(GRUPO,"BM_CAPDIA","SBM","BM_GRUPO","BM_FILIAL",XFILIAL("SBM"))
	   		Aadd(aFieldFill, (ALTROCA)->C6_ITEM)
	   		Aadd(aFieldFill, (ALTROCA)->C6_PRODUTO)
	   		Aadd(aFieldFill, (ALTROCA)->C6_QTDVEN)
	   		Aadd(aFieldFill, (ALTROCA)->C6_ENTREG)
	   		Aadd(aFieldFill, DDATABASE)   
	   		Aadd(aFieldFill, cargadiaria)
	   		Aadd(aFieldFill, LIMDIR)     
	   		Aadd(aFieldFill, GRUPO)
			DBSELECTAREA(ALTROCA)
			DBSKIP()
		 	Aadd(aFieldFill, .F.)
		  	Aadd(aColsEx, aFieldFill)
	  		AFIELDFILL := {}
//			aadd(aitens, {(ALTROCA)->C6_ITEM, (ALTROCA)->C6_PRODUTO, (ALTROCA)->C6_QTDVEN,(ALTROCA)->C6_ENTREG,DDATABASE})
		ENDDO
		(ALTROCA)->(DBCLOSEAREA())        		

 oMSNewGe1 := MsNewGetDados():New( 047, 008, 190, 390, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,,;
                                    999, "u_ALTTROCA", "", "", odlgTroca, aHeaderEx, aColsEx)  

RETURN 
                                    
                                           
User Function AltTroca()

Local cVar  		:= ReadVar()  
Local nPosIT 	    := aScan(aHeader,{|_x| Upper(Alltrim(_x[2]))=='C6_ITEM'   }) 
Local nPosPROD      := aScan(aHeader,{|_x| Upper(Alltrim(_x[2]))=='C6_PRODUTO'}) 
Local nPosQTDE      := aScan(aHeader,{|_x| Upper(Alltrim(_x[2]))=='C6_QTDVEN' }) 
Local nPosENT       := aScan(aHeader,{|_x| Upper(Alltrim(_x[2]))=='C6_ENTREG' }) 
Local nPosNEW   	:= aScan(aHeader,{|_x| Upper(Alltrim(_x[2]))=='NEWDATA'   })      
Local nPosCRG   	:= aScan(aHeader,{|_x| Upper(Alltrim(_x[2]))=='CARGADIA'   }) 
Local nPosLIM   	:= aScan(aHeader,{|_x| Upper(Alltrim(_x[2]))=='LIMDIA'   }) 
Local nPosGRU   	:= aScan(aHeader,{|_x| Upper(Alltrim(_x[2]))=='B1_GRUPO'   }) 

Local cConteudo     
Local cTemp  
Local lVazio := .F.   
LOCAL GRUPO  := ''
LOCAL CARGADIARIA := 0
LOCAL LIMDIR  := 0     
local _aarea := GetArea()

// AITENS := ITEM,  CODOLD, descold,CODNEW,DESCNEW, nitem 
 
IF READVAR() == "M->NEWDATA"           

	cConteudo := ACOLS[N][NPOSNEW]                                       
	cTemp     := &(READVAR())  
	
	IF cConteudo <> cTemp
		Acols[N][NPOSNEW] := cTemp 
		CARGADIARIA := u_CargaGrp(ACOLS[N][NPOSGRU], CTEMP, CTEMP ,ACOLS[N][NPOSPROD],ACOLS[N][NPOSPROD]) 
		IF (CARGADIARIA+ACOLS[N][NPOSqtde]) > ACOLS[N][NPOSLIM]
			MSGALERT("Carga do dia + a qtde do pedido, excedem o limite para o dia escolhido. Verifique.")
			Acols[N,NPOSNEW] := ddatabase
		ELSE		
			aadd(aitens, {Acols[n,nPosit], Acols[n,nPosprod], Acols[n,nPosqtde], Acols[n,nPosent], Acols[n,nPosnew]})
   		endif                                     
	endif
endif


RestArea(_Aarea)

Return .T.    
              

STATIC FUNCTION TROCA() 
    
dbselectarea("SC6")
DBSETORDER(1) // FILIAL PEDIDO ITEM PRODUTO
FOR II:= 1 TO LEN(AITENS) 
	IF DBSEEK(XFILIAL("SC6") + PEDIDO + PADR(AITENS[II][1],2) + PADR(AITENS[II][2],15))
		RECLOCK("SC6",.F.)
			SC6->C6_ENTREG := AITENS[II][5]
		SC6->(MSUNLOCK())
	ENDIF
NEXT II

Close(odlgtroca)

RETURN