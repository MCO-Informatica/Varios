#INCLUDE "RWMAKE.CH"
#include 'protheus.ch'    
#include 'topconn.ch'    
#include 'colors.ch'
#Define DMPAPER_A4 9

#Define LOTEINI 001
#Define LOTEFIM 002
#Define CAIXAS  003
#Define QUANT   004
#Define EMBALA  005
#Define LINI    006
#Define LFIM    007
#Define PESOB   008
#Define PESOL   009
#Define REC     010


User Function Meta1()
Local aArea := GetArea()
&&TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
Local oFnt09b  := TFont():New( "Calibri",,9,,.T.,,,,,.f. )      	&& Tam 09   
Local oFnt13b  := TFont():New( "Calibri",,13.5,,.t.,,,,,.f., )      && Tam 13.5 
Local oFnt10b  := TFont():New( "Calibri",,10,,.t.,,,,,.f., )      && Tam 13.5 

&&Variáveis de Posicionamento
Local x			:=-30
Local y			:=1
Local a			:=0
Local b			:=0

Local nEtiq1	:=0
Local nPosEti	:=0
Local nEtiqs	:=0
Local nQtEtiq1	:=0
Local nTotlote	:=0
Local nQtLote1	:=0
Local nlFim		:=0

Private cPerg:= "META01"
Private oPrint
           
oPrint:= TMSPrinter():New( "Etiqueta Metalacre 1" )  
oPrint:Setup() 	&&Página tipo retrato
oPrint:SetPortrait() 	&&Página tipo retrato
oPrint:StartPage()		&&Inicia a Pagina 
oPrint:SetpaperSize(9)  &&Papel A4


AjustaSx1(cPerg)
If !Pergunte("META01")  
	Return
EndIf              

_cOrdProd:=Left(mv_par01,11)   &&Pergunta1
_cOrdProd2:=Left(mv_par02,11)   &&Pergunta1
nQtlote :=mv_par03             &&Pergunta2 

/*
-----------------------------------
Ajustes Bruno Abrigo em 15.05.12; Desc.: Campos alterados na consulta da Query para integrar com OP;
C6_QTDVEN = C2_QUANT
C6_XLACRE = C2_XLACRE
C6_NUM    = C2_NUM
C6_XEMBALA= C2_XEMBALA
C6_OPC    = C2_OPC
C6_XVOLITE= C2_XVOLITE
C6_XPBITEM= C2_XPBITEM
C6_XPLITEM= C2_XPLITEM
-----------------------------------
*/

cQry:=" SELECT	ISNULL(A1_NOME,'') A1_NOME, A1_MUN, A1_EST, B1_COD, B1_DESC, "+CRLF
cQry+=" A7_CODCLI = "+CRLF
cQry+=" 		CASE  "+CRLF
cQry+=" 		WHEN C6_XCODCLI <> '' THEN C6_XCODCLI "+CRLF
cQry+=" 		WHEN C6_XCODCLI = '' THEN A7_CODCLI "+CRLF
cQry+=" 		END, "+CRLF
cQry+=" 		A7_CODFORN, A1_COD, C2_QUANT AS 'C6_QTDVEN', "+CRLF
cQry+=" C2_XLACRE AS 'C6_XLACRE', Z00_DESC, Z00_TIPO, Z00_DESC1,Z00_TMLACR,Z01_INIC,Z01_FIM,C2_NUM as 'C6_NUM' ,C6_PEDCLI, "+CRLF
cQry+=" C2_XEMBALA AS 'C6_XEMBALA',C2_NUM, Z05_DESC, C2_OPC  AS 'C6_OPC', Z06_QTDMAX, Z06_OPCMAX,"+CRLF
cQry+=" Z05_PESOEM,Z06_PESOUN,C2_NUM+C2_ITEM+C2_SEQUEN LOTE, C2_ITEM, C2_QUANT, ISNULL(C6_XVOLITE,C2_XVOLITE) AS C6_XVOLITE, C2_XPBITEM AS 'C6_XPBITEM', " + CRLF
cQry+=" C2_XPLITEM AS 'C6_XPLITEM', C2_CLI, C2_LOJA "+CRLF
cQry+=" FROM "+RetSqlName("SC2")+" C2 "
cQry+=" INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=C2_PRODUTO AND B1_FILIAL = C2_FILIAL AND B1.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SC6")+" C6 ON C6_NUM=C2_PEDIDO AND C6_ITEM=C2_ITEMPV AND C6.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SA1")+" A1 ON A1_COD=C2_CLI AND A1_LOJA=C2_LOJA AND A1.D_E_L_E_T_<>'*' " +CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z06")+" Z06 ON Z06_PROD=B1_COD AND Z06_COD=C2_XEMBALA AND Z06.D_E_L_E_T_<>'*' " +CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z05")+" Z05 ON Z05_COD=Z06_EMBALA AND Z05.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SA7")+" A7 ON A7_CLIENTE=A1_COD AND A7_LOJA=A1_LOJA AND A7.A7_XOPC = C2_OPC AND A7.D_E_L_E_T_<>'*' AND A7.A7_PRODUTO = C2.C2_PRODUTO AND A7.A7_XLACRE IN('',C2_XLACRE) "  +CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z00")+" Z00 ON Z00_COD=C2_XLACRE AND Z00.D_E_L_E_T_<>'*' " +CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z01")+" Z01 ON Z01_COD=C2_XLACRE AND Z01_PV=C2_NUM AND Z01_ITEMPV = C2_ITEM AND Z01.D_E_L_E_T_<>'*' "   +CRLF
cQry+=" WHERE C2.D_E_L_E_T_<>'*' "+CRLF
cQry+=" AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '"+_cOrdProd+"' AND '" + _cOrdProd2 + "' "+CRLF
cQry+=" AND C2_XLACRE <> ''              "+CRLF
//cQry+=" AND C2_PEDIDO <> ''  "+CRLF
cQry+=" ORDER BY C2_NUM+C2_ITEM+C2_SEQUEN "+CRLF
MemoWrite("c:\Qry\etiq.txt", cQry)



DbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),"TRBB",.T.,.T.)

Count To nRecs
TRBB->(DbGoTop())
If TRBB->(EOF())	
	MsgInfo("Ordem de produção não localizada.")
	TRBB->(dbCloseArea())
	Return .f.
EndIf         

aCampos := {}
AAdd(aCampos,{"A1_NOME" ,"C",TamSX3("A1_NOME")[1],0})
AAdd(aCampos,{"A1_MUN"  ,"C",TamSX3("A1_MUN")[1],0})
AAdd(aCampos,{"A1_EST"  ,"C",TamSX3("A1_EST")[1],0})
AAdd(aCampos,{"B1_COD"  ,"C",TamSX3("B1_COD")[1],0})
AAdd(aCampos,{"B1_DESC" ,"C",TamSX3("B1_DESC")[1],0})
AAdd(aCampos,{"A7_CODCLI","C",TamSX3("A7_CODCLI")[1],0})
AAdd(aCampos,{"A7_CODFORN" ,"C",TamSX3("A7_CODFORN")[1],0})
AAdd(aCampos,{"A1_COD" ,"C",TamSX3("A1_COD")[1],0})
AAdd(aCampos,{"C6_QTDVEN" ,"N",TamSX3("C6_QTDVEN")[1],0})
AAdd(aCampos,{'C6_XLACRE' ,"C",TamSX3('C6_XLACRE')[1],0})
AAdd(aCampos,{"Z00_DESC" ,"C",TamSX3("Z00_DESC")[1],0})
AAdd(aCampos,{"Z00_TIPO" ,"C",TamSX3("Z00_TIPO")[1],0})
AAdd(aCampos,{"Z00_DESC1" ,"C",TamSX3("Z00_DESC1")[1],0})
AAdd(aCampos,{"Z00_TMLACR" ,"N",TamSX3("Z00_TMLACR")[1],0})
AAdd(aCampos,{"Z01_INIC" ,"N",TamSX3("Z01_INIC")[1],0})
AAdd(aCampos,{"Z01_FIM" ,"N",TamSX3("Z01_FIM")[1],0})
AAdd(aCampos,{"C6_NUM" ,"C",TamSX3("C6_NUM")[1],0})
AAdd(aCampos,{"C6_PEDCLI" ,"C",TamSX3("C6_PEDCLI")[1],0})
AAdd(aCampos,{'C6_XEMBALA' ,"C",TamSX3('C6_XEMBALA')[1],0})
AAdd(aCampos,{"C2_NUM" ,"C",TamSX3("C2_NUM")[1],0})
AAdd(aCampos,{"Z05_DESC" ,"C",TamSX3("Z05_DESC")[1],0})
AAdd(aCampos,{"C6_OPC" ,"C",TamSX3("C6_OPC")[1],0})
AAdd(aCampos,{"Z06_QTDMAX" ,"N",TamSX3("Z06_QTDMAX")[1],0})
AAdd(aCampos,{"Z06_OPCMAX" ,"C",TamSX3("Z06_OPCMAX")[1],0})
AAdd(aCampos,{"Z05_PESOEM" ,"N",TamSX3("Z05_PESOEM")[1],4})
AAdd(aCampos,{"Z06_PESOUN" ,"N",TamSX3("Z06_PESOUN")[1],4})
AAdd(aCampos,{"LOTE" ,"C",11,0})
AAdd(aCampos,{"C2_ITEM" ,"C",TamSX3("C2_ITEM")[1],0})
AAdd(aCampos,{"C2_QUANT" ,"N",TamSX3("C2_QUANT")[1],0})
AAdd(aCampos,{'C6_XVOLITE' ,"N",TamSX3('C6_XVOLITE')[1],0})
AAdd(aCampos,{'C6_XPBITEM' ,"N",TamSX3('C6_XPBITEM')[1],4})
AAdd(aCampos,{'C6_XPLITEM' ,"N",TamSX3('C6_XPLITEM')[1],4})
AAdd(aCampos,{"C2_CLI" ,"C",TamSX3("C2_CLI")[1],0})
AAdd(aCampos,{"C2_LOJA" ,"C",TamSX3("C2_LOJA")[1],0})

cFileTRB := CriaTrab(aCampos) 
DBCreate(cFileTRB,aCampos)

DBUseArea(.T.,,cFileTRB,"TRRB",.F.,.F.) // Exclusivo
While TRBB->(!Eof())
	RecLock("TRRB",.t.)
	
	TRRB->A1_NOME		:=	TRBB->A1_NOME
	TRRB->A1_MUN		:=	TRBB->A1_MUN
	TRRB->A1_EST		:=	TRBB->A1_EST
	TRRB->B1_COD		:=	TRBB->B1_COD
	TRRB->B1_DESC		:=	TRBB->B1_DESC
	TRRB->A7_CODCLI		:=	TRBB->A7_CODCLI
	TRRB->A7_CODFORN	:=	TRBB->A7_CODFORN
	TRRB->A1_COD   		:=	TRBB->A1_COD
	TRRB->C6_QTDVEN		:=	TRBB->C6_QTDVEN
	TRRB->C6_XLACRE		:=	TRBB->C6_XLACRE
	TRRB->Z00_DESC		:=	TRBB->Z00_DESC
	TRRB->Z00_TIPO		:=	TRBB->Z00_TIPO
	TRRB->Z00_DESC1		:=	TRBB->Z00_DESC1
	TRRB->Z00_TMLACR	:=	TRBB->Z00_TMLACR
	TRRB->Z01_INIC		:=	TRBB->Z01_INIC
	TRRB->Z01_FIM		:=	TRBB->Z01_FIM
	TRRB->C6_NUM		:=	TRBB->C6_NUM
	TRRB->C6_PEDCLI		:=	TRBB->C6_PEDCLI
	TRRB->C6_XEMBALA	:=	TRBB->C6_XEMBALA
	TRRB->C2_NUM		:=	TRBB->C2_NUM
	TRRB->Z05_DESC		:=	TRBB->Z05_DESC
	TRRB->C6_OPC		:=	TRBB->C6_OPC
	TRRB->Z06_QTDMAX	:=	TRBB->Z06_QTDMAX
	TRRB->Z06_OPCMAX	:=	TRBB->Z06_OPCMAX
	TRRB->Z05_PESOEM	:=	TRBB->Z05_PESOEM
	TRRB->Z06_PESOUN	:=	TRBB->Z06_PESOUN
	TRRB->LOTE			:=	TRBB->LOTE
	TRRB->C2_ITEM		:=	TRBB->C2_ITEM
	TRRB->C2_QUANT		:=	TRBB->C2_QUANT
	TRRB->C6_XVOLITE	:=	TRBB->C6_XVOLITE
	TRRB->C6_XPBITEM	:=	TRBB->C6_XPBITEM
	TRRB->C6_XPLITEM	:=	TRBB->C6_XPLITEM
	TRRB->C2_CLI		:=	TRBB->C2_CLI
	TRRB->C2_LOJA		:=	TRBB->C2_LOJA
	TRRB->(MsUnlock())

	TRBB->(dbSkip(1))
Enddo

	
TRBB->(dbCloseArea())
TRRB->(dbGoTop())

aEtiquetas := {}
nCaixas	:=0
nNmLote := 1                          

ProcRegua(nRecs)
While TRRB->(!Eof())
	IncProc('Processando Lotes...')
	
	If Empty(TRRB->C6_XLACRE)
		TRRB->(dbSkip(1));Loop
	Endif                                                                                   

	nSaldo  := TRRB->C6_QTDVEN
    nQtLote := Int(Min(nSaldo,TRRB->Z06_QTDMAX)/MV_PAR03)
    nLIni   := TRRB->Z01_INIC
    For nEtiq := 1 To TRRB->C6_XVOLITE
		AAdd(aEtiquetas,{	Strzero(nNmLote,TRRB->Z00_TMLACR),;
    						Strzero((nNmLote+CEILING(Min(nSaldo,TRRB->Z06_QTDMAX)/MV_PAR03))-1,TRRB->Z00_TMLACR),;
    						++nCaixas,;                                      
    						Min(nSaldo,TRRB->Z06_QTDMAX),;                                      
    						CEILING(Min(nSaldo,TRRB->Z06_QTDMAX)/MV_PAR03),;
    						nLIni,;
    						(nLIni+Min(nSaldo,TRRB->Z06_QTDMAX)-1),;
    						Round(TRRB->C6_XPBITEM/TRRB->C6_XVOLITE,3),;
    						Round(TRRB->C6_XPLITEM/TRRB->C6_XVOLITE,3),;
    						TRRB->(Recno())})

		nLIni   := 	(nLIni+Min(nSaldo,TRRB->Z06_QTDMAX))
		nNmLote += 	CEILING(Min(nSaldo,TRRB->Z06_QTDMAX)/MV_PAR03)//nQtLote
		nSaldo -=	Min(TRRB->C6_QTDVEN,TRRB->Z06_QTDMAX)
		If Empty(nSaldo) .Or. nSaldo <0
			Exit
		Endif
	Next
	TRRB->(dbSkip(1))
Enddo
		
If Len(aEtiquetas) > 0
	nRecno := aEtiquetas[1,REC]
	TRRB->(dbGoTo(nRecno))
    For nEtq := 1 To Len(aEtiquetas)
        
		// Posiciona no Registro da Tabela Temporaria
		If nRecno <> aEtiquetas[nEtq,REC]
			nRecno := aEtiquetas[nEtq,REC]			
			TRRB->(dbGoTo(nRecno))

	        &&Etiqueta parte superior da Pagina
	        If y=1601 .And. nEtq <= Len(aEtiquetas)
	   	        oPrint:EndPage()
				oPrint:StartPage()
			Endif
   	        nPosEti:=0
   	    	x:=-30
   	    	y:=1
   	    	a:=0
   	    	b:=0
		Endif
		
		// Tratamento para pedidos da Empresa METALSIL
		// Luiz Alberto - 02-05-2012
		
    	If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+TRRB->C6_NUM))
    		If !Empty(SC5->C5_CLIMTS)
    			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIMTS+SC5->C5_LOJMTS))
    		Else
    			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
    		Endif
    	ElseIf !Empty(TRRB->C2_CLI)
			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+TRRB->C2_CLI+TRRB->C2_LOJA))    	
    	Endif

		LayoutMT1(oPrint,1,x,y) &&Imprime o Layout  
		  		
  		&&Informações Gerais                        	
		oPrint:Say(y+265, x+2250,	Str(aEtiquetas[nEtq,CAIXAS],3),oFnt13b)
		   	    oPrint:Say(y+565, x+435,	SA1->A1_NOME				,oFnt13b)
		   	    oPrint:Say(y+550, x+1900,	TRRB->C6_PEDCLI				,oFnt13b)   
		   	    oPrint:Say(y+655, x+600,	TRRB->A7_CODFORN				,oFnt13b)    
		   	    oPrint:Say(y+655, x+1750,	TRRB->A7_CODCLI				,oFnt13b)   
		   	    oPrint:Say(y+745, x+400,	TRRB->Z00_DESC				,Iif(Len(AllTrim(TRRB->Z00_DESC))>30,oFnt09b,oFnt13b))    
		   	    oPrint:Say(y+745, x+1390,	TRRB->C6_XLACRE				,oFnt13b)    

				cTipo := ''
				If TRRB->Z00_TIPO=='1'
					cTipo := 'Semi-Barreira'
				ElseIf TRRB->Z00_TIPO=='2'
					cTipo := 'Sinalizacao'
				Endif                    
	
		   	    oPrint:Say(y+745, x+1730,	cTipo				,oFnt13b)       									
		        oPrint:Say(y+745, x+2170,	TRRB->C2_NUM+" "+TRRB->C2_ITEM	,oFnt13b)
		        oPrint:Say(y+835, x+435,	SA1->A1_MUN					,oFnt13b)
		        oPrint:Say(y+835, x+2250,	SA1->A1_EST					,oFnt13b)
		        oPrint:Say(y+925, x+435,	AllTrim(TRRB->B1_DESC) + ' ' + SubStr(AllTrim(TRRB->C6_OPC),4,4) + ' m',oFnt13b)
		        oPrint:Say(y+925, x+2250,	cValToChar(Year(DATE()))	,oFnt13b)
		        oPrint:Say(y+1015, x+235,	""							,oFnt13b)      
		                                                                 
		   		&&Quadrado separado
		  	    cBar1 := cValtoChar(aEtiquetas[nEtq,LOTEINI])                      
		  	    cBar11:= cValTochar(aEtiquetas[nEtq,LOTEFIM])
		  	    cBar2 := cValtoChar(aEtiquetas[nEtq,LINI])
		  	    cBar21:= cValtoChar(aEtiquetas[nEtq,LFIM])
		  	    cBar3 := cValtoChar(aEtiquetas[nEtq,EMBALA])                      

		  	    oPrint:Say(y+1170,x+455,	cValtoChar(aEtiquetas[nEtq,LOTEINI])							,oFnt09b) 
		  	    oPrint:Say(y+1170,x+1415,	cValToChar(aEtiquetas[nEtq,LOTEFIM])						,oFnt09b)   
		  	    oPrint:Say(y+1250,x+335,	cValTochar(aEtiquetas[nEtq,QUANT])			 						,oFnt13b)   
		  	    oPrint:Say(y+1300,x+955,	StrZero(aEtiquetas[nEtq,LINI],TRRB->Z00_TMLACR)											,oFnt09b)   
		  	    oPrint:Say(y+1300,x+1415,	StrZero(aEtiquetas[nEtq,LFIM],TRRB->Z00_TMLACR)	,oFnt09b) 
		  	    oPrint:Say(y+1390,x+595,	cValTochar(Strzero(aEtiquetas[nEtq,EMBALA],TRRB->Z00_TMLACR))   			,oFnt09b)    
		  	    oPrint:Say(y+1080,x+2235,	Iif(!Empty(aEtiquetas[nEtq,PESOB]),cValtoChar(Round(aEtiquetas[nEtq,PESOB],2)),'')						,oFnt13b)   
		   	    oPrint:Say(y+1310,x+2235,	Iif(!Empty(aEtiquetas[nEtq,PESOL]),cValToChar(Round(aEtiquetas[nEtq,PESOL],2)),'')						,oFnt13b)    
		   	    oPrint:Say(y+1390,x+1150,    TRRB->Z05_DESC												,oFnt13b)
		        &&Codigo de Barras
/*		        MSBAR("CODE128",a+9.3,b+3.0,cBar1 								,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
		   	    MSBAR("CODE128",a+9.3,b+11.2,cBar11								,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
				// CERTOS
   			    MSBAR("CODE128",a+10.4,b+7.3,cBar2			,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)   
   			    MSBAR("CODE128",a+10.4,b+11.5,cBar21        ,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
				MSBAR("CODE128",a+11.2,b+4.0,cBar3			,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
  */		 
				&&Codigo de Barras

				MSBAR("CODE128",a+9.7,b+3.8,cBar1  								,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.) // Lote DE
				MSBAR("CODE128",a+9.7,b+12.2,cBar11								,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)	// Lote Ate
				MSBAR("CODE128",a+10.8,b+7.9,cBar2			,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.) // N.Ini
				MSBAR("CODE128",a+10.8,b+12.2,cBar21	,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)		// N.Final
				MSBAR("CODE128",a+11.6,b+4.8,cBar3					,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)	// Embalagem

		
        &&Etiqueta parte superior da Pagina
   	    If y==1601 .And. nEtq < Len(aEtiquetas)//MOD(nEtq,2)=0 .And. nEtq < Len(aEtiquetas)
   	        oPrint:EndPage()
			oPrint:StartPage()
   	        nPosEti:=0
   	    	x:=-30
   	    	y:=1
   	    	a:=0
   	    	b:=0
   	    &&Etiqueta parte Inferior da Pagina
   	    Elseif y==1 //MOD(nEtq,2)<>0
   	    	x:=-30
   	    	y+=1600
   	    	a+=13.55
    	EndIf  
	   	    	
	Next 
Endif
&&Encerra a Pagina	
oPrint:EndPage()
&&Visualiza impressão    
oPrint:Preview()
&&Desativa Impressora
ms_flush()
TRRB->(dbCloseArea())
RestArea(aArea)
Return

&&Monta layout do arquivo(Meta1)
Static Function LayoutMT1(oPrint,i,x,y) 


&&TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
Local oFnt08a	:= TFont():New( "Arial",,8,,.f.,,,,,.f. )      		&& Tam 08   
Local oFnt13a	:= TFont():New( "Arial",,13,,.t.,,,,,.f.,.t. )      && Tam 13   italico
Local oFnt13c	:= TFont():New( "Calibri",,13,,.t.,,,,,.f., )  		&& Tam 13 
Local oFnt13b	:= TFont():New( "Calibri",,13.5,,.t.,,,,,.f., )  	&& Tam 13.5 
Local oFnt20a	:= TFont():New( "Arial",,20,,.f.,,,,,.f. )     		&& Tam 20 
Local oFnt35a	:= TFont():New( "Arial Black",,35,,.t.,,,,,.f. )	&& Tam 35 - Titulo
&&X=Posição da Linha
Local x:=-30		
       
         
   	&&Caixa Geral
   	&&Box - externo
   	oPrint:Box(y+080,x+090,y+1450,x+2400) 
   	&&MiniBox  - interno &&Nro de Caixas
   	oPrint:Box(y+255,x+2190,y+345,x+2335)     
	
	
	&&Linhas  
	oPrint:Line(y+545,x+090,y+545,x+2400)   	//Linha 1  
	oPrint:Line(y+635,x+090,y+635,x+2400)   	//Linha 2  
	oPrint:Line(y+725,x+090,y+725,x+2400)   	//Linha 3  
	oPrint:Line(y+810,x+090,y+810,x+2400)  		//Linha 4  
	oPrint:Line(y+905,x+090,y+905,x+2400)   	//Linha 5  
	oPrint:Line(y+995,x+090,y+995,x+2400)   	//Linha 6  
	oPrint:Line(y+1085,x+090,y+1085,x+1665)   	//Linha 7  
	oPrint:Line(y+1240,x+1885,y+1240,x+2400)   	//Linha 8                              
	&&Colunas				
	oPrint:Line(y+995, x+1665 ,y+1450 ,x+1665)   //Coluna 1 
	oPrint:Line(y+995, x+1885 ,y+1450 ,x+1885)   //Coluna 2 
	oPrint:Line(y+995, x+2150 ,y+1450 ,x+2150)   //Coluna 3 	
			
	    
	&&Cabeçalho &&Não alterar a disposição!!
	
	If SC5->C5_CLIENTE+SC5->C5_LOJACLI$'01140401' .And. !Empty(SC5->C5_CLIMTS)
		oPrint:SayBitmap( y+170,080,"LOGOTIPOMPM.bmp",900,300 )
	   	oPrint:Say(y+135, x+1500,"MPM - COMÉRCIO E DISTRIBUIÇÃO EIRELLI - EPP",oFnt13c)      
	   	oPrint:Say(y+195, x+1355,"C.N.P.J.           26.589.342/0001-82",oFnt13c) 
	   	oPrint:Say(y+195, x+2190,"Nº CX.:",oFnt13c)  
	   	oPrint:Say(y+255, x+1355,"I.E.                        796.525.286.111",oFnt13c)
	Else
		oPrint:SayBitmap( y+170,080,"logotipopng.bmp",900,300 )
	   	oPrint:Say(y+135, x+1555,"METALACRE IND.COM.LACRES LTDA",oFnt13c)      
	   	oPrint:Say(y+195, x+1355,"C.N.P.J.           52.924.099/0001-11",oFnt13c) 
	   	oPrint:Say(y+195, x+2190,"Nº CX.:",oFnt13c)  
	   	oPrint:Say(y+255, x+1355,"I.E.                           336165261119",oFnt13c)
	Endif   	    
   	    
   	&&Informações Gerais 
   	oPrint:Say(y+565, x+135,"CLIENTE:"			,oFnt13b)
   	oPrint:Say(y+550, x+1750,"PEDIDO"			,oFnt08a)   
   	oPrint:Say(y+575, x+1750,"CLIENTE:"			,oFnt08a)
   	oPrint:Say(y+655, x+135,"CÓD. FORNECEDOR.:"	,oFnt13b)    
   	oPrint:Say(y+655, x+1405,"CÓD.MATERIAL:"	,oFnt13b)   
   	oPrint:Say(y+745, x+135,"PERSON.:"			,oFnt13b)    
   	oPrint:Say(y+745, x+1205,"CÓDIGO:"			,oFnt13b)    
   	oPrint:Say(y+745, x+1615,"TIPO:"			,oFnt13b)       									
    oPrint:Say(y+745, x+2050,"O.P.:"			,oFnt13b)
    oPrint:Say(y+835, x+135,"CIDADE:"			,oFnt13b)
   	oPrint:Say(y+835, x+1405,"VALIDADE: 2 ANOS"	,oFnt13b)   
    oPrint:Say(y+835, x+2135,"EST.:"			,oFnt13b)
    oPrint:Say(y+925, x+135,"PRODUTO:"			,oFnt13b)
    oPrint:Say(y+925, x+2135,"ANO:"				,oFnt13b)
    oPrint:Say(y+1015, x+135,"N.FISCAL Nº:"		,oFnt13b)     
        
   	&&Quadrado separado
  	oPrint:Say(y+1110,x+135,"LOTE DE:"			,oFnt13b)   
  	oPrint:Say(y+1110,x+1115,"LOTE ATÉ:"		,oFnt13b)   
  	oPrint:Say(y+1250,x+135,"QUANT.:"			,oFnt13b)   
  	oPrint:Say(y+1250,x+755,"Nº INI.:"			,oFnt13b)   
  	oPrint:Say(y+1250,x+1255,"Nº FIN.:"			,oFnt13b)   
  	oPrint:Say(y+1340,x+135,"QTD.EMBALAGEM:"	,oFnt13b)
//  	oPrint:Say(y+1390,x+850,"TIPO EMBALAGEM:"   ,oFnt13b)      
  	oPrint:Say(y+1110,x+1675,"PESOS:"			,oFnt13b)   
  	oPrint:Say(y+1080,x+1935,"BRUTO:"			,oFnt13b)   
   	oPrint:Say(y+1310,x+1920,"LIQUIDO:"			,oFnt13b)    

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								   ³
//³ mv_par01		 // Ordem de Produção								   ³
//³ mv_par02		 // Itens por Lote								       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AjustaSx1(cPerg)
	PutSx1(cPerg, "01","Ordem de Produção de"," "," ","mv_ch1","C",11,0,0,"G","        "      , "SC2","","","mv_par01","","",""," ","","","" ,"","","","","","","",""," ")
	PutSx1(cPerg, "02","Ordem de Produção ate"," "," ","mv_ch2","C",11,0,0,"G","        "      , "SC2","","","mv_par02","","",""," ","","","" ,"","","","","","","",""," ")
	PutSx1(cPerg, "03","Itens por Lote"  ," "," ","mv_ch3","N",05,0,0,"G","        "      , "   ","","","mv_par03","","",""," ","","","" ,"","","","","","","",""," ")
Return
