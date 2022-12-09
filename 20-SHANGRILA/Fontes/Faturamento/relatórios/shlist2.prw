#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#DEFINE DLG_CHARPIX_H   15.1             
#DEFINE DLG_CHARPIX_W    7.9

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦ SHLISTA  ¦ Autor ¦ Marcos M. Neto        ¦ Data ¦11/10/2007¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Emissao de Lista de Preco com lay-out personalizado        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Observacao¦ Especifico Shangrila                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Alterado  ¦  					                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function SHLIST2()

// Para imprimir um BitMap
// Ex: oSend(oPrn, "SayBitmap", nLin, 100, "SEAL.BMP" , 400, 200 )

	SetPrvt("CPOINT1P,LPOINT1P,CPOINT2P,LPOINT2P,CMARCA,LINVERTE")
	SetPrvt("APOS,AROTINA,BFUNCAO,NCONT")
	SetPrvt("NTOTAL,NTOTALGERAL,NIDIOMA,CCADASTRO,NPAGINA,ODLGIDIOMA")
	SetPrvt("NVOLTA,ORADIO1,LEND,OPRINT>,LINHA,PTIPO")
	SetPrvt("CINDEX,CCOND,NINDEX,NOLDAREA,OFONT1")
	SetPrvt("OFONT2,OFONT3,OFONT4,OFONT5,OFONT6,OFONT7")
	SetPrvt("OFONT8,OFONT9,OPRN,AFONTES,CCLICOMP,ACAMPOS")
	SetPrvt("CNOMARQ,AHEADER,LCRIAWORK,CPICTQTDE,CPICT1TOTAL")
	SetPrvt("CPICT2TOTAL,CQUERY,OFONT10,OFNT,C2ENDSM0,C2ENDSA2")
	SetPrvt("CCOMMISSION,C2ENDSYT,CTERMS,CDESTINAT,CREPR,CCGC")
	SetPrvt("CNR,CPOINTS,I,N1,N2,NNUMERO,MV_PAR01")
	SetPrvt("BACUMULA,BWHILE,LPULALINHA,NTAM,CDESCRITEM,CREMARKS")
	SetPrvt("empendeM,empbairM,empcidaM,empestaM,empcepeM")
	SetPrvt("empendeEC,empbairEC,empcidaEC,empestaEC,empcepeEC")
	SetPrvt("empfone,nTotReg,XLINHA,XCOLS,XCOLINI,_nST")

	cPerg := "SHLST2" // Pergunta Padrao

	ValidPerg()

	If !Pergunte(cPerg, .T.)
		Return (.T.)
	Endif

	#xtranslate :TIMES_NEW_ROMAN_18_NEGRITO    => \[1\]
	#xtranslate :TIMES_NEW_ROMAN_12            => \[2\]
	#xtranslate :TIMES_NEW_ROMAN_12_NEGRITO    => \[3\]
	#xtranslate :COURIER_08_NEGRITO            => \[4\]
	#xtranslate :TIMES_NEW_ROMAN_08_NEGRITO    => \[5\]
	#xtranslate :COURIER_12_NEGRITO            => \[6\]
	#xtranslate :COURIER_20_NEGRITO            => \[7\]
	#xtranslate :TIMES_NEW_ROMAN_10_NEGRITO    => \[8\]
	#xtranslate :TIMES_NEW_ROMAN_08_UNDERLINE  => \[9\]
	#xtranslate :COURIER_NEW_10_NEGRITO        => \[10\]
	#xtranslate :TAHOMA_10                     => \[11\]

	#COMMAND    TRACO_NORMAL                   => oSend(oPrn,"Line", Linha  ,  0005, Linha  , Mm2Pix(oPrn, oPrn:nHorzSize()) - 10  ) ;
		;  oSend(oPrn,"Line", Linha+1,  0005, Linha+1, Mm2Pix(oPrn, oPrn:nHorzSize()) - 10  ) ;
		;  oSend(oPrn,"Line", Linha+2,  0005, Linha+2, Mm2Pix(oPrn, oPrn:nHorzSize()) - 10  ) ;
		;  oSend(oPrn,"Line", Linha+3,  0005, Linha+3, Mm2Pix(oPrn, oPrn:nHorzSize()) - 10  )

	#COMMAND    TRACO_HALF                   => oSend(oPrn,"Line", Linha  ,  0005, Linha  , Mm2Pix(oPrn, oPrn:nHorzSize()) - 10  ) ;
		;  oSend(oPrn,"Line", Linha+1,  0005, Linha+1, Mm2Pix(oPrn, oPrn:nHorzSize()) - 10  )

	#COMMAND    TRACO_REDUZIDO                 => oSend(oPrn,"Line", Linha  ,1200, Linha  , Mm2Pix(oPrn, oPrn:nHorzSize()) - 10  ) ;
		;  oSend(oPrn,"Line", Linha+1,1200, Linha+1, Mm2Pix(oPrn, oPrn:nHorzSize()) - 10  )

	#COMMAND    ENCERRA_PAGINA                 => oSend(oPrn,"oFont",aFontes:COURIER_20_NEGRITO) ;
		;  TRACO_NORMAL

	#COMMAND    COMECA_PAGINA                  => AVNEWPAGE                    ;
		;  Linha := 180                 ;
		;  nPagina := nPagina+ 1        ;
		;  pTipo := 2                   ;
		;  P001Cabec()    //              ;
//                                           ;  P002Cabec()

		#xTranslate  DATA_MES(<x>) =>              SUBSTR(DTOC(<x>)  ,1,2)+ " " + ;
		MesExtenso(MONTH(<x>))+ " " + ;
		LEFT(DTOS(<x>)  ,4)

	cIndex := cCond := nIndex := Nil; nOldArea:=ALIAS()
	oFont1:=oFont2:=oFont3:=oFont4:=oFont5:=oFont6:=oFont7:=oFont8:=oFont9:=oFont10:=oFont11:=Nil
	oPrn:= Linha:= aFontes:= Nil; cCliComp:=""
	YTAB1 := YTAB2 := YTAB3 := "0"
	aCampos:={}; cNomArq:=Nil; aHeader:={}
	lCriaWork:=.T.

	XCOLS := {}
// Passo = 30 / Inicio = 70
	Passo = 35
	XCOLINI = 70;

	aAdd(XCOLS,{"Codigo     ",140,0,0,   0, 100,  50,"SB1->B1_COD"                           ,"1=1"})
	aAdd(XCOLS,{"Descrição  ",780,0,0, 140, 920, 530,"SB1->B1_DESC"                          ,"1=1"})
	aAdd(XCOLS,{"Cod.Barra  ",230,0,0, 260,0990,0875,"SB1->B1_CODBAR"                        ,"1=1"})
	aAdd(XCOLS,{"NCM        ",170,0,0,1030,1200,1115,"Transf(SB1->B1_POSIPI,'@R 9999.99.99')","1=1"})
	aAdd(XCOLS,{"Emb.Minima ",120,2,2,1240,1360,1300,"Transf(SB5->B5_QE1,'@E@Z 9,999')"      ,"1=1"})
	aAdd(XCOLS,{"Emb.Master ",120,2,2,1400,1520,1460,"Transf(SB5->B5_QE2,'@E@Z 9,999')"      ,"1=1"})
	aAdd(XCOLS,{"Tabela     ",150,2,1,1560,1710,1635,"Transf(YTAB1,'@E@Z 99,999.99')"        ,"1=1"})
	aAdd(XCOLS,{"IPI        ",130,2,1,1750,1880,1815,"Transf(SB1->B1_IPI,'@E 999.99')+'%'"   ,"1=1"})
//aAdd(XCOLS,{"ST         ",130,2,1,1950,2080,2015,"Transf(_nST       ,'@E 999.99')+'%'"   ,"1=1"})
	aAdd(XCOLS,{"Un         ", 50,2,2,2120,2170,2145,"SB1->B1_UM"                            ,"1=1"})
	aAdd(XCOLS,{"Tipo       ", 70,2,2,2210,2280,2245,"SB1->B1_TIPO"                          ,"MV_PAR30=1"})

	th=1
	XCOLS[th,5] := 0
	XCOLS[th,6] := XCOLS[th,5]+XCOLS[th,2]
	XCOLS[th,7] := XCOLS[th,5]+(XCOLS[th,2]/2)
	Do while (th<10)
		th=th+1
		XCOLS[th,5] := XCOLS[th-1,6]+Passo
		XCOLS[th,6] := XCOLS[th,5]+XCOLS[th,2]
		XCOLS[th,7] := XCOLS[th,5]+(XCOLS[th,2]/2)
	enddo

	AVPRINT oPrn NAME "Emissão: "+Dtoc(dDatabase)
	oPrn:SetLandScape()
	oPrn:SetPage(9) 
//                              Font            W  H  Bold          Device
	oFont1 := oSend(TFont(),"New","Times New Roman",0,16,,.T.,,,,,,,,,,,oPrn )
	oFont2 := oSend(TFont(),"New","Times New Roman",0,10,,.F.,,,,,,,,,,,oPrn )
	oFont3 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,,,,,,,oPrn )
	oFont4 := oSend(TFont(),"New","Courier New"    ,0,08,,.T.,,,,,,,,,,,oPrn )
	oFont5 := oSend(TFont(),"New","Times New Roman",0,06,,.T.,,,,,,,,,,,oPrn )
	oFont6 := oSend(TFont(),"New","Courier New"    ,0,10,,.T.,,,,,,,,,,,oPrn )
	oFont7 := oSend(TFont(),"New","Courier New"    ,0,24,,.T.,,,,,,,,,,,oPrn )
	oFont8 := oSend(TFont(),"New","Times New Roman",0,08,,.T.,,,,,,,,,,,oPrn )
	oFont11:= oSend(TFont(),"New","Tahoma"         ,0,08,,.F.,,,,,,,,,,,oPrn )
//                                                            Underline
	oFont9 := oSend(TFont(),"New","Times New Roman",0,08,,.T.,,,,,.T.,,,,,,oPrn )
	oFont10:= oSend(TFont(),"New","Courier New"    ,0,08,,.T.,,,,,,,,,,,oPrn )

	aFontes := { oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8, oFont9, oFont10, oFont11 }

// AVPAGE

	Processa({|X| lEnd := X, P001Det() })

	AVENDPAGE

	oSend(oFont1,"End")
	oSend(oFont2,"End")
	oSend(oFont3,"End")
	oSend(oFont4,"End")
	oSend(oFont5,"End")
	oSend(oFont6,"End")
	oSend(oFont7,"End")
	oSend(oFont8,"End")
	oSend(oFont9,"End")
	oSend(oFont10,"End")
	oSend(oFont11,"End")

	AVENDPRINT
	dbSelectArea("SB1")
//
	Return .T.

	*---------------------------*
Static FUNCTION P001Cabec()
	*---------------------------*

	If MV_PAR29 = 1
// Endereço Padrão
		empendeM := SM0->M0_ENDENT
		empbairM := SM0->M0_BAIRENT
		empcidaM := SM0->M0_CIDENT
		empestaM := SM0->M0_ESTENT
		empcepeM := SM0->M0_CEPENT
//	empfone := SM0->M0_TEL
	Else
// Endereço Fixo
		empendeM := "Rod. Senador Laurindo Dias Minhoto, 591 A"
		empbairM := "Guarapiranga"
		empcidaM := "Capela do Alto"
		empestaM := "SP"
		empcepeM := "18195000"
//	empfone := "55-11-35152939"
	Endif

	empendeEC := "Rua Lessing, 437"
	empbairEC := "Vila Ema"
	empcidaEC := "São Paulo"
	empestaEC := "SP"
	empcepeEC := "03276000"
	empfoneEC := "551532678844"
	empfaxEC :=  "551532678859"

	XLOGOX =  40 // 100
	XLOGOY = -40 // -40
	XLOGOW = 500 // 400
	XLOGOH = 250 // 250

	c2EndSM0:=""; c2EndSA2:=""; cCommission:=""; c2EndSYT:=""; cTerms:=""; cDestinat:=""; cRepr:=""; cCGC:=""; cNr:=""

	oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
	if (MV_PAR13 = 2)
		oSend( oPrn, "Say", Linha-85,1175 , "USO EXCLUSIVO INTERNO", aFontes:TIMES_NEW_ROMAN_18_NEGRITO,,,, 2)
	endif
	oSend( oPrn, "Say", Linha-60,40 , "Emissao: "+DTOC(DDATABASE), aFontes:TIMES_NEW_ROMAN_10_NEGRITO)
	oSend( oPrn, "Say", Linha-60,2355, "Pag.: "+Str(nPagina,3), aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 1)
	TRACO_NORMAL
	Linha := Linha + 70
	oSend( oPrn, "Say", Linha-35 , Mm2Pix(oPrn, oPrn:nHorzSize()) - 10, Trim(SM0->M0_NOMECOM) , aFontes:TIMES_NEW_ROMAN_18_NEGRITO,,,, 1 )
	oSend( oPrn, "Say", Linha+45 , Mm2Pix(oPrn, oPrn:nHorzSize()) - 10, Trim(empendeM)+" - "+Trim(empbairM), aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 1 )
	oSend( oPrn, "Say", Linha+88 , Mm2Pix(oPrn, oPrn:nHorzSize()) - 10, Trim(empcidaM)+" - "+empestaM+" - CEP "+Transf(empcepeM,"@R 99999-999"), aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 1 )
	oSend( oPrn, "Say", Linha+129, Mm2Pix(oPrn, oPrn:nHorzSize()) - 10, "site: www.gruposhangrila.com.br - e-mail: "+Trim(MV_PAR26), aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 1 )
	oSend( oPrn, "Say", Linha+173, Mm2Pix(oPrn, oPrn:nHorzSize()) - 10, "PABX: "+Transf(empfoneEC,"@R 99(99)9999-9999")+" - FAX: "+Transf(empfaxEC,"@R 99(99)9999-9999"), aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 1 )

	oSend( oPrn, "SayBitmap", Linha+XLOGOY, XLOGOX, MV_PAR25 , XLOGOW, XLOGOH)
	Linha := Linha + 140

	oSend(oPrn,"oFont", aFontes:COURIER_20_NEGRITO)  // Define fonte padrao

	Linha := Linha + 100

	TRACO_NORMAL

	Linha := Linha + 20

	oFnt := aFontes:COURIER_20_NEGRITO
	WTAB1 := WTAB2 := WTAB3 := " "
	YTAB1 := YTAB2 := YTAB3 := "0"
	//IF Subs(MV_PAR12,1,1) $ "1234567"
	WTAB1 := "Tabela "+MV_PAR12
	//YTAB1 := Posicione("DA1",1,xFilial("DA1")+MV_PAR12+SB1->B1_COD,"DA1->DA1_PRCVEN")

	YTAB1	:= GetPrcTab(MV_PAR12,SB1->B1_COD,MV_PAR31)      
	
	If YTAB1 == 0 
		YTAB1	:= GetPrcTab(MV_PAR12,SB1->B1_COD,MV_PAR31,.T.)
	EndIf
	
	If YTAB1 == 0 .And. MV_PAR12 == "1  "
		YTAB1 := SB1->B1_PRV1
	EndIf

	oSend( oPrn, "Say",  Linha   , 0005                                 , "Codigo"    , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[1,3])
	oSend( oPrn, "Say",  Linha   , 0200                                 , "Descricao" , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[2,3])
	oSend( oPrn, "Say",  Linha   , Mm2Pix(oPrn, oPrn:nHorzSize()) - 1800, "Cod.Barra" , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[3,3])
	oSend( oPrn, "Say",  Linha   , Mm2Pix(oPrn, oPrn:nHorzSize()) - 1500, "NCM"       , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[4,3])
	oSend( oPrn, "Say",  Linha   , Mm2Pix(oPrn, oPrn:nHorzSize()) - 1200, "Emb. Minima"      , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[5,3])
	oSend( oPrn, "Say",  Linha	 , Mm2Pix(oPrn, oPrn:nHorzSize()) - 1000, "Emb. Master"      , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[6,3])
	oSend( oPrn, "Say",  Linha   , Mm2Pix(oPrn, oPrn:nHorzSize()) - 0800, "Tabela " + MV_PAR12     , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[7,3])
	oSend( oPrn, "Say",  Linha   , Mm2Pix(oPrn, oPrn:nHorzSize()) - 0600, "IPI"       , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[8,3])
	oSend( oPrn, "Say",  Linha   , Mm2Pix(oPrn, oPrn:nHorzSize()) - 0400, "ST"        , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[8,3])
	oSend( oPrn, "Say",  Linha   , Mm2Pix(oPrn, oPrn:nHorzSize()) - 0200, "Un"        , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[9,3])
	IF &(XCOLS[10,9])
		oSend( oPrn, "Say",  Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 0100, "Tipo"    , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[10,3])
	Endif

	Linha := Linha+50
	oSend(oPrn,"oFont", aFontes:TIMES_NEW_ROMAN_10_NEGRITO) // Define fonte padrao

	Linha := Linha+15
	Return

	*------------------------------*
Static FUNCTION P001Traco()
	*------------------------------*

	xLinha := nil

	If pTipo == 1      .OR.  pTipo == 2  .OR. pTipo == 7
		xLinha := 100

	ElseIf pTipo == 3  .OR.  pTipo == 4
		xLinha := 20

	ElseIf pTipo == 5  .OR.  pTipo == 6
		xLinha := 50

	Endif

	If pTipo # 1
		oSend(oPrn,"oFont",oFnt)
		DO CASE

		CASE  pTipo == 3
			oPrn:Box( Linha,  50, (Linha+xLinha),  51)
			oPrn:Box( Linha,2300, (Linha+xLinha),2301)
		CASE pTipo == 2  .OR.  pTipo == 4  .OR.  pTipo == 5
			oPrn:Box( Linha,  50, (Linha+xLinha),  51)
			oPrn:Box( Linha, 180, (Linha+xLinha), 181)
			oPrn:Box( Linha, 460, (Linha+xLinha), 461)
			oPrn:Box( Linha,1190, (Linha+xLinha),1191)
			oPrn:Box( Linha,1260, (Linha+xLinha),1261)
			oPrn:Box( Linha,1420, (Linha+xLinha),1421)
			oPrn:Box( Linha,1610, (Linha+xLinha),1611)
			oPrn:Box( Linha,1810, (Linha+xLinha),1811)
			oPrn:Box( Linha,2060, (Linha+xLinha),2011) //2010
			oPrn:Box( Linha,2230, (Linha+xLinha),2191) //2190

		CASE pTipo == 6  .OR.  pTipo == 7
			oPrn:Box( Linha,  50, (Linha+xLinha),  51)
			oPrn:Box( Linha,1200, (Linha+xLinha),1201)
			oPrn:Box( Linha,2300, (Linha+xLinha),2301)


		ENDC
	Else
		oSend( oPrn, "Line",  Linha  ,  50, Linha  , 2300 )
	EndIf

	RETURN NIL

	*--------------------------*
Static Function P001Det()
	*--------------------------*

	Local cAlias1
	Local cQuery1
	Local _cArea := ""
    Local cAliasTab := 'ALIASTAB'
                 	
	DbSelectArea("SB1")
	cArqNtx  := CriaTrab(NIL,.f.)
	If MV_PAR14 = 1
//IndRegua("SB1",cArqNtx,"B1_FILIAL+B1_GRUPO+B1_COD",,,"Selecionando registros..." )
		Dbsetorder(4)
	Elseif MV_PAR14 = 2
		IndRegua("SB1",cArqNtx,"B1_FILIAL+B1_GRUPO+B1_DESC",,,"Selecionando registros..." )
	Else
//IndRegua("SB1",cArqNtx,"B1_FILIAL+B1_DESC",,,"Selecionando registros..." )
		Dbsetorder(3)
	Endif

	Linha := 180
	nPagina:=0
	nCont := 0
	WPED  := "ZZZZZZ"

	COMECA_PAGINA
	If MV_PAR14 = 3
		TRACO_NORMAL
		Linha := Linha + 15
	Endif

	DbSelectArea("SB1")
	If MV_PAR14 = 3
		Dbgotop()
	Else
		Dbseek(xFilial("SB1")+MV_PAR08,.T.)
	Endif
	ProcRegua(LastRec())

   //	Do While !SB1->(Eof()) .And. (MV_PAR14=3.Or.(SB1->B1_GRUPO<=MV_PAR09))
                         
  	SB1->(DbSetOrder(1))		  
   ListTabPrc(@cAliasTab,MV_PAR12)
   While !(cAliasTab)->(Eof())

		IncProc("Imprimindo...") // Atualiza barra de progresso
		
		If SB1->(DbSeek(xFilial('SB1') + (cAliasTab)->PRODUTO))
		
		IF ((MV_PAR13 = 1 .AND. SB1->B1_TABELA <>"N") .OR. (MV_PAR13 = 2 .AND. SB1->B1_TAB_IN <>"N") .OR. MV_PAR13 = 3)

		   	IF MV_PAR07 = 1
				IF SB1->B1_COD     < MV_PAR10 .OR. SB1->B1_COD     > MV_PAR11 .OR. ;
						SB1->B1_GRUPO   < MV_PAR08 .OR. SB1->B1_GRUPO   > MV_PAR09 .OR. ;
						SB1->B1_TIPO    < MV_PAR01 .OR. SB1->B1_TIPO    > MV_PAR02 .OR. ;
						SB1->B1_UTILIZ  < MV_PAR27 .OR. SB1->B1_UTILIZ  > MV_PAR28
					DBSELECTAREA("SB1")
					DBSKIP()
					LOOP
				ENDIF
			ELSEIF MV_PAR07 = 2
				IF SB1->B1_COD     < MV_PAR10 .OR. SB1->B1_COD     > MV_PAR11 .OR. ;
						SB1->B1_GRUPO   < MV_PAR08 .OR. SB1->B1_GRUPO   > MV_PAR09 .OR. ;
						SB1->B1_UTILIZ  < MV_PAR27 .OR. SB1->B1_UTILIZ  > MV_PAR28 .OR. ;
						(SB1->B1_TIPO   <> MV_PAR03 .AND. SB1->B1_TIPO <> MV_PAR04 .AND. SB1->B1_TIPO <> MV_PAR05 .AND. SB1->B1_TIPO <> MV_PAR06)
					DBSELECTAREA("SB1")
					DBSKIP()
					LOOP
				ENDIF
			ENDIF    
		
			DBSELECTAREA("SB5")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SB5")+SB1->B1_COD,.F.)

			If MV_PAR14 = 1 .OR. MV_PAR14 = 2
				WCHAV := "SB1->B1_GRUPO"
			Else
				WCHAV := "WPED"
			Endif
			
			If Empty(Alltrim((cAliasTab)->(GRADE))) .And. SB1->B1_GRADE = 'S'
				lProduto := (cAliasTab)->(PRODUTO)
			ElseIf Empty(Alltrim((cAliasTab)->(GRADE))) .And. SB1->B1_GRADE = 'N'
				lProduto := (cAliasTab)->(PRODUTO)
			ElseIf Empty(Alltrim((cAliasTab)->(GRADE))) .And. SB1->B1_GRADE = ' '
				lProduto := (cAliasTab)->(PRODUTO)
			Else
				lProduto := (cAliasTab)->(GRADE)
		    EndIf
			
			//YTAB1 := Posicione("DA1",1,xFilial("DA1")+MV_PAR12+SB1->B1_COD,"DA1->DA1_PRCVEN")
			//YTAB1	:= GetPrcTab(MV_PAR12,If(SB1->B1_GRADE = 'S',(cAliasTab)->(GRADE),SB1->B1_COD),MV_PAR31)
			YTAB1	:= GetPrcTab(MV_PAR12,lProduto,MV_PAR31)	
			If YTAB1 == 0 
				//YTAB1	:= GetPrcTab(MV_PAR12,If(SB1->B1_GRADE = 'S',(cAliasTab)->(GRADE),SB1->B1_COD),MV_PAR31,.T.) 
				YTAB1	:= GetPrcTab(MV_PAR12,lProduto,MV_PAR31,.T.)
			EndIf  
			  
			If YTAB1 == 0 .And. MV_PAR12 == "1  "
				YTAB1 := SB1->B1_PRV1
			EndIf

			IF YTAB1<>0
				IF WPED <> &WCHAV
					WPED := &WCHAV
					TRACO_NORMAL
					WGRU := POSICIONE("SBM",1,XFILIAL("SBM")+SB1->B1_GRUPO,"BM_DESC")
					Linha := Linha + 15
					oSend(oPrn,"Say", Linha, 40, SB1->B1_GRUPO+" "+WGRU, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
					Linha := Linha + 50
					TRACO_HALF
				ENDIF

				TH=1
				Do while TH<=10
					if &(XCOLS[TH,9])
//		        oSend(oPrn,"Say", Linha, XCOLINI+XCOLS[TH,5+XCOLS[TH,4]], &(XCOLS[TH,8]) ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, XCOLS[TH,4])
					endif
					TH=TH+1
				Enddo

				_cArea := GetArea()
				dbSelectArea("SF7")
				dbsetOrder(1)
				dbSeek(xFilial("SF7")+SB1->B1_GRTRIB)
				Do While SB1->B1_GRTRIB == SF7->F7_GRTRIB .And. !Eof()

					If MV_PAR31 == SF7->F7_EST

						//_nCusto := 	Posicione("DA1",1,xFilial("DA1")+MV_PAR12+SB1->B1_COD,"DA1->DA1_PRCVEN")
						//_nCusto	:= GetPrcTab(MV_PAR12,If(SB1->B1_GRADE = 'S',(cAliasTab)->(GRADE),SB1->B1_COD),MV_PAR31)
						_nCusto	:= GetPrcTab(MV_PAR12,lProduto,MV_PAR31)
						If _nCusto == 0
							//_nCusto	:= GetPrcTab(MV_PAR12,If(SB1->B1_GRADE = 'S',(cAliasTab)->(GRADE),SB1->B1_COD),MV_PAR31,.T.)
							_nCusto	:= GetPrcTab(MV_PAR12,lProduto,MV_PAR31,.T.)
						EndIf
						_nValIpi:= 	(_nCusto * (SB1->B1_IPI / 100))  
						nMargem := 0 
						nMargem := SF7->F7_MARGEM
						_nIva	:=	(nMargem / 100)
						_nPreco	:=	((_nCusto + _nValIpi) * _nIva)
						_nIcmsC	:=	((_nCusto * (SF7->F7_ALIQEXT / 100)))
						_nIcmsD	:=	(((_nPreco + _nCusto + _nValIpi)* (SF7->F7_ALIQDST / 100)))    
						If nMargem > 0 
						_nIcmsST:=	(_nIcmsD - _nIcmsC)
						_nST 	:= 	((_nIcmsST / _nCusto) * 100)  
						Else
						_nIcmsST := 0
						_nST	 := 0
						EndIf
						exit
					Else
						_nST := 0
					Endif
					SF7->(dbSkip())
				EndDo
				RestArea(_cArea)

				oSend(oPrn,"Say", Linha, 0005					              , SB1->B1_COD   ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
				oSend(oPrn,"Say", Linha, 0200								  , SB1->B1_DESC  ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
				oSend(oPrn,"Say", Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 1800, SB1->B1_CODBAR,aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
				oSend(oPrn,"Say", Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 1500, Transf(SB1->B1_POSIPI,'@R 9999.99.99'),aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
				oSend(oPrn,"Say", Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 1200, Transf(SB5->B5_QE1,"@E@Z 9,999"),aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2)
				oSend(oPrn,"Say", Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 1000, Transf(SB5->B5_QE2,"@E@Z 9,999"),aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2)
				oSend(oPrn,"Say", Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 0750, Transf(YTAB1,"@E@Z 99,999.99") ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 1)
				oSend(oPrn,"Say", Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 0550, Transf(SB1->B1_IPI,"@E 999.99")+"%",aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 1)
				oSend(oPrn,"Say", Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 0350, Iif(MV_PAR32 == 1,Transf(_nST,"@E 999.9999"),Transf(0,"@E 999.9999"))+"%",aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 1)
				oSend(oPrn,"Say", Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 0200, SB1->B1_UM    ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 ) //2010
				IF MV_PAR30 = 1
					oSend(oPrn,"Say", Linha, Mm2Pix(oPrn, oPrn:nHorzSize()) - 0100, SB1->B1_TIPO ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 ) //2080
				Endif
				Linha := Linha + 50
				_nST := 0
			ENDIF

			CHKLINE()

		Endif
                              
		EndIf
	   //	SB1->(dbSkip())
	   
	   (cAliasTab)->(DbSkip())

	Enddo

	Linha := Linha + 30
	TRACO_NORMAL

	Linha := Linha + 30
	oSend(oPrn,"Say", Linha,  065, MV_PAR15, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )

	If !Empty(MV_PAR16)
		CHKLINE()
		Linha := Linha + 50
		oSend(oPrn,"Say", Linha,  065, MV_PAR16, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	Endif

	If !Empty(MV_PAR16)
		CHKLINE()
		Linha := Linha + 50
		oSend(oPrn,"Say", Linha,  065, MV_PAR17, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	Endif

	If !Empty(MV_PAR16)
		CHKLINE()
		Linha := Linha + 50
		oSend(oPrn,"Say", Linha,  065, MV_PAR18, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	Endif

	If !Empty(MV_PAR16)
		CHKLINE()
		Linha := Linha + 50
		oSend(oPrn,"Say", Linha,  065, MV_PAR19, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	Endif

	If !Empty(MV_PAR16)
		CHKLINE()
		Linha := Linha + 50
		oSend(oPrn,"Say", Linha,  065, MV_PAR20, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	Endif

	If !Empty(MV_PAR16)
		CHKLINE()
		Linha := Linha + 50
		oSend(oPrn,"Say", Linha,  065, MV_PAR21, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	Endif

	If !Empty(MV_PAR16)
		CHKLINE()
		Linha := Linha + 50
		oSend(oPrn,"Say", Linha,  065, MV_PAR22, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	Endif

	If !Empty(MV_PAR16)
		CHKLINE()
		Linha := Linha + 50
		oSend(oPrn,"Say", Linha,  065, MV_PAR23, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	Endif

	If !Empty(MV_PAR16)
		CHKLINE()
		Linha := Linha + 50
		oSend(oPrn,"Say", Linha,  065, MV_PAR24, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	Endif

	Linha := Linha + 50

	ENCERRA_PAGINA

	dbSelectArea("SB1")
	RetIndex("SB1")
	fErase(cArqNtx + OrdBagExt())
	Return nil

///////////////////////////
Static Function CHKLINE()
///////////////////////////
	If Linha >= 2300  // 3250
		Linha := Linha+50
		ENCERRA_PAGINA
		Linha := Linha+80
		COMECA_PAGINA
		WPED  := "ZZZZZZ"
		If MV_PAR14 = 3
			TRACO_NORMAL
			Linha := Linha + 15
		Endif
	Endif
	Return

///////////////////////////
Static Function ValidPerg()
///////////////////////////
//
	_sAlias := Alias()
	cPerg   := Padr(cPerg, 10)
	aRegs   := {}
//
	DbSelectArea("SX1")
	DbSetOrder(1)
//
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/
// Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/
// Cnt04/Var05/Def05/Cnt05
//
	aAdd(aRegs,{cPerg,"01","Do  Tipo           ?","Do  Tipo           ?","Do  Tipo           ?","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","","",""})
	aAdd(aRegs,{cPerg,"02","Ate Tipo           ?","Ate Tipo           ?","Ate Tipo           ?","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","","",""})
	aAdd(aRegs,{cPerg,"03","Tipo A             ?","Tipo A             ?","Type A             ?","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","","",""})
	aAdd(aRegs,{cPerg,"04","Tipo B             ?","Tipo B             ?","Type B             ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","","",""})
	aAdd(aRegs,{cPerg,"05","Tipo C             ?","Tipo C             ?","Type C             ?","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","","",""})
	aAdd(aRegs,{cPerg,"06","Tipo D             ?","Tipo D             ?","Type D             ?","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","","",""})
	aAdd(aRegs,{cPerg,"07","Tipo de Criterio   ?","Tipo de Criterio   ?","Tipo de Criterio   ?","mv_ch7","N",01,0,0,"C","","mv_par07","De/Ate","De/Ate","De/Ate","","","Seleção","Seleção","Seleção","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","De  Grupo          ?","De  Grupo          ?","De  Grupo          ?","mv_ch8","C",04,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","_1","","","","",""})
	aAdd(aRegs,{cPerg,"09","Ate Grupo          ?","Ate Grupo          ?","Ate Grupo          ?","mv_ch9","C",04,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","_1","","","","",""})
	aAdd(aRegs,{cPerg,"10","De  Produto        ?","De  Produto        ?","De  Produto        ?","mv_cha","C",15,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
	aAdd(aRegs,{cPerg,"11","Ate Produto        ?","Ate Produto        ?","Ate Produto        ?","mv_chb","C",15,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
	aAdd(aRegs,{cPerg,"12","Tabela de Preço    ?","Tabela de Preço    ?","Tabela de Preço    ?","mv_chc","C",03,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","DA0","","","","",""})
	aAdd(aRegs,{cPerg,"13","Imprime Tabela     ?","Imprime Tabela     ?","Imprime Tabela     ?","mv_chd","N",01,0,0,"C","","mv_par13","Somente Liberados","Somente Liberados","Somente Liberados","","","Somente Interno","Somante Interno","Somente Interno","","","Todos","Todos","Todos","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","Ordenacao          ?","Ordenacao          ?","Ordenacao          ?","mv_che","N",01,0,0,"C","","mv_par14","Grupo+Cod.Produto","Grupo+Cod.Produto","Grupo+Cod.Produto","","","Grupo+Desc.Produto","Grupo+Desc.Produto","Grupo+Desc.Produto","","","Desc.Produto","Desc.Produto","Desc.Produto","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"15","Mensagem 1         ?","Mensagem 1         ?","Mensagem 1         ?","mv_chf","C",30,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","Mensagem 2         ?","Mensagem 2         ?","Mensagem 2         ?","mv_chg","C",30,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"17","Mensagem 3         ?","Mensagem 3         ?","Mensagem 3         ?","mv_chh","C",30,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"18","Mensagem 4         ?","Mensagem 4         ?","Mensagem 4         ?","mv_chi","C",30,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"19","Mensagem 5         ?","Mensagem 5         ?","Mensagem 5         ?","mv_chj","C",30,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"20","Mensagem 6         ?","Mensagem 6         ?","Mensagem 6         ?","mv_chk","C",30,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"21","Mensagem 7         ?","Mensagem 7         ?","Mensagem 7         ?","mv_chl","C",30,0,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"22","Mensagem 8         ?","Mensagem 8         ?","Mensagem 8         ?","mv_chm","C",30,0,0,"G","","mv_par22","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"23","Mensagem 9         ?","Mensagem 9         ?","Mensagem 9         ?","mv_chn","C",30,0,0,"G","","mv_par23","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"24","Mensagem 10        ?","Mensagem 10        ?","Mensagem 10        ?","mv_cho","C",30,0,0,"G","","mv_par24","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"25","Arquivo Logotipo   ?","Arquivo Logotipo   ?","Arquivo Logotipo   ?","mv_chp","C",30,0,0,"G","","mv_par25","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"26","e-mail             ?","e-mail             ?","e-mail             ?","mv_chq","C",35,0,0,"G","","mv_par26","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"27","Da  Utilizacao     ?","Da  Utilizacao     ?","Da  Utilizacao     ?","mv_chr","C",20,0,0,"G","","mv_par27","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"28","Ate Utilizacao     ?","Ate Utilizacao     ?","Ate Utilizacao     ?","mv_chs","C",20,0,0,"G","","mv_par28","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"29","Endereço Padrão    ?","Endereço Padrão    ?","Endereço Padrão    ?","mv_cht","N",01,0,1,"C","","mv_par29","Sim","Si ","Yes","","","Não","No ","No ","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"30","Exibe Tipo         ?","Exibe Tipo         ?","Exibe Tipo         ?","mv_chu","N",01,0,1,"C","","mv_par30","Sim","Si ","Yes","","","Não","No ","No ","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"31","Estado         	   ?","Estado             ?","Estado             ?","mv_chv","C",02,0,0,"G","","mv_par31","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"32","Imprime ST         ?","Imprime ST         ?","Imprime ST         ?","mv_chx","N",01,0,1,"C","","mv_par32","Sim","Si ","Yes","","","Não","No ","No ","","","","","","","","","","","","","","","","","","","","","",""})
//
	For i := 1 To Len(aRegs)
//
		If !DbSeek(cPerg + aRegs[i, 2])
//
			Reclock("SX1", .T.)
			For j := 1 To FCount()
				FieldPut(j, aRegs[i, j])
			Next
			MsUnlock()
//
		Endif
//
	Next
//
	DbSelectArea(_sAlias)
//
	Return (.T.)

Static Function Mm2Pix(oPrint, nMm)

	Local nValor := (nMm * 300) / 25.4

	Return nValor


//  Imprimi Regua
//	      	 	TH=0
//	      	 	TD=0
//	      	 	DO WHILE TH<=250
//	      	 		oSend(oPrn,"Line", Linha-10  ,  TH*10, Linha+10 , TH*10 )
//	      	 		IF (TD=10)
//	      	 			oSend(oPrn,"Line", Linha-25  ,  TH*10, Linha+25 , TH*10 )
//	      	 			TD=0
//	      	 		ENDIF
//	      	 		IF (TD=5)
//	      	 			oSend(oPrn,"Line", Linha-15  ,  TH*10, Linha+15 , TH*10 )
//	      	 		ENDIF
//	      	 		TH=TH+1
//	      	 		TD=TD+1
//	      	 	ENDDO

Return

Static Function ListTabPrc(cAliasTAB,cTabela)
Local cWhere := '%'
Local Inner  := '%'
Local eNorte	:= Alltrim(SuperGetMv('MV_NORTE',.F.,''))
Local eEstadual	:= Alltrim(SuperGetMv('MV_ESTADO',.F.,''))
Local eEstado   := Alltrim(MV_PAR31)
Local eTpOper 	:= '' 
Local xPadrao   := .F.
Local cEof		:= chr(13)+chr(10)
Local cQuery	:= ''
  
	If !xPadrao
		If eEstado == eEstadual 
			eTpOper := '1'
		ElseIf eEstado $ eNorte
		     eTpOper := '3'
		Else        
			eTpOper := '2'
		EndIf
	Else
		eTpOper := '4'
    EndIf   

                    
	If MV_PAR10 == MV_PAR11
	     cWhere += "PRODUTO LIKE '%" + MV_PAR10 + "%'"
	Else                           
	 	cWhere += " PRODUTO BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR11 + "'"
	EndIf  
	
	cWhere += '%'
    
	BeginSql Alias cAliasTab
		%noparser%              
		
		SELECT DISTINCT GRUPO, PRODUTO, DESCRICAO, GRADE, TIPO FROM (
		
			//SELECT DISTINCT B1_GRUPO GRUPO,B1_DESC DESCRICAO, DA1_CODPRO PRODUTO, DA1_REFGRD GRADE, DA1_PRCVEN PRECO, DA1_TPOPER TIPO
			SELECT DISTINCT B1_GRUPO GRUPO,B1_DESC DESCRICAO, DA1_CODPRO PRODUTO, DA1_REFGRD GRADE, DA1_TPOPER TIPO  
			FROM %TABLE:DA1% DA1 , %TABLE:SB1% SB1 
			WHERE            
			DA1.DA1_FILIAL  = %xFilial:DA1% AND
			DA1.DA1_CODTAB = %EXP:cTabela% AND 
			DA1.DA1_REFGRD = '              ' AND     
			SB1.B1_COD = DA1.DA1_CODPRO AND					
			DA1.DA1_TPOPER = %EXP:eTpOper% AND 
			DA1.%NOTDEL%   AND
			SB1.%NOTDEL%			
			
			UNION ALL
			
			//SELECT DISTINCT B1_GRUPO GRUPO,B1_DESC DESCRICAO,  B1_COD PRODUTO , DA1_REFGRD GRADE, DA1_PRCVEN PRECO, DA1_TPOPER TIPO
			SELECT DISTINCT B1_GRUPO GRUPO,B1_DESC DESCRICAO,  B1_COD PRODUTO , DA1_REFGRD GRADE, DA1_TPOPER TIPO   
			FROM %TABLE:DA1% DA1, %TABLE:SB1% SB1 
			WHERE            
			DA1.DA1_FILIAL  = %xFilial:DA1% AND
			DA1.DA1_CODTAB = %EXP:cTabela% AND 
			DA1.DA1_REFGRD <> '              ' AND
			SUBSTRING(SB1.B1_COD,1,6) = RTRIM(LTRIM(DA1.DA1_REFGRD)) AND								
			DA1.DA1_TPOPER = %EXP:eTpOper% AND 
			DA1.%NOTDEL%  AND
			SB1.%NOTDEL%			
			
		) TMP         
		
		WHERE 
		%EXP:cWhere%
		GROUP BY GRUPO , DESCRICAO, PRODUTO, GRADE, TIPO
		ORDER BY GRUPO , DESCRICAO

	EndSql
	//cQuery := GetLastQuery()[2]
	//memowrite("C:\TEMP\SHANGRILA\CQUERY.TXT",cQuery)		                    
Return 


Static Function GetPrcTab(cTabela,cProduto,cEstado,lPadrao)
Local nRet 		:= 0   
Local cAliasDA1 := 'CALIASDA1'
Local cNorte	:= Alltrim(SuperGetMv('MV_NORTE',.F.,''))
Local cEstadual	:= Alltrim(SuperGetMv('MV_ESTADO',.F.,''))
Local cTpOper 	:= ''
Local lGrade	:= SB1->B1_GRADE == 'S'
Local cWhere	:= '%'                        

lRefGrd := Alltrim(Posicione("DA1",1,xFilial("DA1") + cTabela + cProduto , "DA1_REFGRD"))

If lGrade
	
	If Empty(lRefGrd)
   		lRefGrd 	:= Substr(Alltrim(cProduto),1,6)
	EndIf
 
	If Empty(lRefGrd)
		cWhere += " DA1.DA1_CODPRO = '" + cProduto + "' " 
	Else
     	cWhere += " DA1.DA1_REFGRD = '" + cProduto + "'"
	Endif 
Else
     cWhere += " DA1.DA1_CODPRO = '" + cProduto + "' " 
EndIf     

cWhere += '%'
                
Default lPadrao := .F.
      
	If !lPadrao
		If cEstado == cEstadual 
			cTpOper := '1'
		ElseIf cEstado $ cNorte
		     cTpOper := '3'
		Else
			cTpOper := '2'
		EndIf
	Else
		cTpOper := '4'
    EndIf   
               
	BeginSql Alias cAliasDA1
		%noparser%
		SELECT DA1_PRCVEN DA1_PRCVEN, DA1_CODPRO DA1_CODPRO
		FROM %TABLE:DA1% DA1
		WHERE
		DA1.DA1_FILIAL  = %xFilial:DA1% AND
		DA1.DA1_CODTAB = %EXP:cTabela% AND 
		%EXP:cWhere% AND
		DA1.DA1_TPOPER = %EXP:cTpOper% AND
		DA1.%NOTDEL%            
	EndSql
	/*
	BeginSql Alias cAliasDA1
		%noparser%
		SELECT MAX(DA1_PRCVEN) DA1_PRCVEN
		FROM %TABLE:DA1% DA1
		WHERE
		DA1.DA1_FILIAL  = %xFilial:DA1% AND
		DA1.DA1_CODTAB = %EXP:cTabela% AND 
		%EXP:cWhere% AND
		DA1.DA1_TPOPER = %EXP:cTpOper% AND 
		DA1.%NOTDEL%
	EndSql                                       
    */
	If !(cAliasDA1)->(Eof())
	     nRet :=  (cAliasDA1)->DA1_PRCVEN
	EndIf                      
	
	(cAliasDA1)->(DbCloseArea())

Return nRet
