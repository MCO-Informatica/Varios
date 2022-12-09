#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410CONS  º Autor ³FLAVIA AGUIAR       º Data ³ 11/11/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PE NA MONTAGEM DO BROWSE DA TELA DE PEDIDO.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ atualizacao do arquivo szl                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   

USER FUNCTION M410INIC()


local RotInc := '' 
LOCAL ITCLI  := GDFIELDPOS("C6_ITEMCLI") //     
LOCAL XCODAP := GDFIELDPOS("C6_XAPLC") //
LOCAL XAPLIC := GDFIELDPOS("C6_XAPLICA") //
LOCAL XEMBAL := GDFIELDPOS("C6_XEMBALA") //
LOCAL XLACRE := GDFIELDPOS("C6_XLACRE")               //
LOCAL XPBITE  := GDFIELDPOS("C6_XPBITEM")  //
LOCAL XPLITE    := GDFIELDPOS("C6_XPLITEM") // 
//LOCAL XQTDEM    := Ascan( aHeader, { |x| Alltrim(x[2]) =="C6_XQTDEMB" } ) // 
LOCAL XVOLIT := GDFIELDPOS("C6_XVOLITE")  //
LOCAL ITEM   := GDFIELDPOS("C6_ITEMCON")     
LOCAL XOPC   := GDFIELDPOS("C6_OPC")     
LOCAL XPRUNIT   := GDFIELDPOS("C6_PRUNIT")     
LOCAL XPRCVEN   := GDFIELDPOS("C6_PRCVEN")     
LOCAL XULTACAO  := GDFIELDPOS("C6_ULTACAO")     
LOCAL XPRODUTO  := GDFIELDPOS("C6_PRODUTO")     
LOCAL XDESCRICAO:= GDFIELDPOS("C6_DESCRI")     
LOCAL XENTREGA	:= GDFIELDPOS("C6_ENTREG")     
LOCAL XPEDCLI	:= GDFIELDPOS("C6_PEDCLI")     


// SE VIER DA ROTINA DE APROVAÇÃO, TEM QUE TRAZER OS CAMPOS PERSONALIZADOS.

IF ALLTRIM(UPPER(FUNNAME())) == 'FATA400'
 // CAMPOS SC5 VEM DA ADA 
 
	 SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+ADA->ADA_CODCLI+ADA->ADA_LOJCLI))

	 M->C5_CLIMTS := ADA->ADA_CLIMTS
	 M->C5_CONDPAG	:=	ADA->ADA_CONDPG
	 M->C5_FORMPAG := ADA->ADA_FORMPA
	 M->C5_LOJMTS := ADA->ADA_LOJMTS
	 M->C5_OBSCLI := ALLTRIM(SA1->A1_OBSERV)
	 If SA1->(FieldPos("A1_OBSOP")) > 0
	 	M->C5_OBSOP	:=	ALLTRIM(SA1->A1_OBSOP)
	 Endif
	 M->C5_OBSOP  := ADA->ADA_OBSOP 
	 M->C5_REGIAO := ADA->ADA_REGIAO
	 If SC5->(FieldPos("C5_XOBSCPL")) > 0
		 M->C5_XOBSCPL := ADA->ADA_XOBSCP
	 Endif
	 M->C5_XOBSFA := ADA->ADA_XOBSFA
	 M->C5_XOPCCOM := ADA->ADA_XOPCCO         
	 M->C5_NOMECLI := SA1->A1_NOME
	 M->C5_TPFRETE := ADA->ADA_TPFRET
	 If SC5->(FieldPos("C5_XCONTRA")) > 0
	   	 M->C5_XCONTRA := ADA->ADA_NUMCTR
	 Endif
	 
	 If !Empty(ADA->ADA_CLIMTS)         // Pega Informacao do Cliente MTS
	 	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+ADA->ADA_CLIMTS+ADA->ADA_LOJMTS))
	 	
		M->C5_OBSCLI := ALLTRIM(SA1->A1_OBSERV)

		 If SA1->(FieldPos("A1_OBSOP")) > 0
		 	M->C5_OBSOP	:=	ALLTRIM(SA1->A1_OBSOP)
		 Endif
	 Endif


 	 DBSELECTAREA("ADB")
 	 DBSETORDER(1)
 
	 FOR II := 1 TO LEN(ACOLS) 
	 	IF DBSEEK(XFILIAL("ADB") + ADA->ADA_NUMCTR + ACOLS[II,ITEM])
			ACOLS[II,ITCLI]  := ADB->ADB_ITEMCL
			ACOLS[II,XCODAP] := ADB->ADB_XAPL
			ACOLS[II,XAPLIC] := ADB->ADB_XAPLIC
			ACOLS[II,XEMBAL] := ADB->ADB_XEMBAL
			ACOLS[II,XLACRE] := ADB->ADB_XLACRE               
			ACOLS[II,XPBITE] := ADB->ADB_XPBITE 
			ACOLS[II,XPLITE] := ADB->ADB_XPLITE 
			ACOLS[II,XVOLIT] := ADB->ADB_XVOLIT
			ACOLS[II,XENTREGA] := ADB->ADB_DATA
			ACOLS[II,XPRUNIT] := ACOLS[II,XPRCVEN]
			ACOLS[II,XOPC] := ADB->ADB_OPC     
			ACOLS[II,XPEDCLI] := ADB->ADB_NPCL
			ACOLS[II,XULTACAO] := 'Incluido Em ' + DtoC(Date()) + ' as ' + Left(Time(),5) 
			
			SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aCols[II,xPRODUTO]))
			
			aCols[II,xDescricao] := SB1->B1_DESC
			
			
		ENDIF
	 NEXT II	                  
	 
 // CAMPOS DO SC6 VEM DO ADB

ENDIF

 
return   


User Function ConsZ02
      
local cRetorna := ''

If alltrim(FUNNAME()) == "MATA410"
	cretorna := Z02->Z02_CODCLI + Z02_LOJACL = M->C5_CLIENTE + M->C5_LOJACLI 
elseIF FUNNAME()== "MATA650"
	cRetorna := Z02->Z02_CODCLI + Z02_LOJACL = M->C2_CLI + M->C2_LOJA
elseIF FUNNAME()== "FATA400"
	cRetorna := Z02->Z02_CODCLI + Z02_LOJACL = M->ADA_CODCLI + M->ADA_LOJCLI	
else
	msgAlert("Ajustar Consulta Padrao Z02!")
endif

RETURN CRETORNA



User Function M410GET()

nValor := U_CalcPeso(1)

Return .t.