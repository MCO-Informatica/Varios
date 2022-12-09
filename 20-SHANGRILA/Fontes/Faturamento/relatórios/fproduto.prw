#INCLUDE "AvPrint.ch"  
#INCLUDE "Font.ch"  
#INCLUDE "rwmake.ch"       
#DEFINE DLG_CHARPIX_H   15.1
#DEFINE DLG_CHARPIX_W    7.9

Static aMarcados:={}

User Function FPRODUTO()

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
SetPrvt("empende,empbair,empcida,empesta,empcepe,empfone")
SetPrvt("XLINHA,DetStep,DetCount,DetCol1,DetCol2,")

// Para imprimir um BitMap
// Ex: oSend(oPrn, "SayBitmap", nLin, 100, "SEAL.BMP" , 400, 200 )

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦ FPRODUTO ¦ Autor ¦ Marcos Martins Neto   ¦ Data ¦03/07/2007¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Emissao de Ficha de Produtos com lay-out personalizado     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Observacao¦ Especifico Shangrila                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Alterado  ¦ Marcos M. Neto em 03/07/2007                               ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
cPerg   := PadR("FPROD",Len(SX1->X1_GRUPO))               // Pergunta Padrao

PRValidPerg()

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
#xtranslate :TIMES_NEW_ROMAN_14            => \[12\]
#xtranslate :TIMES_NEW_ROMAN_14_NEGRITO    => \[13\]
#xtranslate :TIMES_NEW_ROMAN_16            => \[14\]
#xtranslate :TIMES_NEW_ROMAN_16_NEGRITO    => \[15\]
#xtranslate :PROD_CHAMADA                  => \[16\]
#xtranslate :PROD_VALOR                    => \[17\]


#COMMAND    TRACO_NORMAL                   => oSend(oPrn,"Line", Linha  ,  50, Linha  , 2300 ) ;
                                           ;  oSend(oPrn,"Line", Linha+1,  50, Linha+1, 2300 )

#COMMAND    TRACO_REDUZIDO                 => oSend(oPrn,"Line", Linha  ,1200, Linha  , 2300 ) ;
                                           ;  oSend(oPrn,"Line", Linha+1,1200, Linha+1, 2300 )

#COMMAND    ENCERRA_PAGINA                 => oSend(oPrn,"oFont",aFontes:COURIER_20_NEGRITO) ;
                                           ;  TRACO_NORMAL 


#COMMAND    COMECA_PAGINA                  => AVNEWPAGE                    ;
                                           ;  Linha := 180                 ;
                                           ;  nPagina := nPagina+ 1        ;
                                           ;  pTipo := 2                   ;
                                           ;  PR01Cabec()    //              ;
//                                           ;  P002Cabec()


#xTranslate  DATA_MES(<x>) =>              SUBSTR(DTOC(<x>)  ,1,2)+ " " + ;
                                           MesExtenso(MONTH(<x>))+ " " + ;
                                           LEFT(DTOS(<x>)  ,4)


cIndex := cCond := nIndex := Nil; nOldArea:=ALIAS()
oFont1:=oFont2:=oFont3:=oFont4:=oFont5:=oFont6:=oFont7:=oFont8:=oFont9:=oFont10:=oFont11:=oFont12:=oFont13:=oFont14:=oFont15:=oFont16:=oFont17:=Nil
oPrn:= Linha:= aFontes:= Nil; cCliComp:=""
YTAB1 := YTAB2 := YTAB3 := "0"
aCampos:={}; cNomArq:=Nil; aHeader:={}
lCriaWork:=.T.

   dbSelectArea("SB1")

   AVPRINT oPrn NAME "Emissão: "+Dtoc(dDatabase)
      //                              Font            W  H  Bold          Device
      oFont1 := oSend(TFont(),"New","Times New Roman",0,18,,.T.,,,,,,,,,,,oPrn )
      oFont2 := oSend(TFont(),"New","Times New Roman",0,12,,.F.,,,,,,,,,,,oPrn )
      oFont3 := oSend(TFont(),"New","Times New Roman",0,12,,.T.,,,,,,,,,,,oPrn )
      oFont4 := oSend(TFont(),"New","Courier New"    ,0,10,,.T.,,,,,,,,,,,oPrn )
      oFont5 := oSend(TFont(),"New","Times New Roman",0,08,,.T.,,,,,,,,,,,oPrn )
      oFont6 := oSend(TFont(),"New","Courier New"    ,0,12,,.T.,,,,,,,,,,,oPrn )
      oFont7 := oSend(TFont(),"New","Courier New"    ,0,26,,.T.,,,,,,,,,,,oPrn )
      oFont8 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,,,,,,,oPrn )
      oFont11:= oSend(TFont(),"New","Tahoma"         ,0,10,,.F.,,,,,,,,,,,oPrn )
      oFont12:= oSend(TFont(),"New","Times New Roman",0,14,,.F.,,,,,,,,,,,oPrn )
      oFont13:= oSend(TFont(),"New","Times New Roman",0,14,,.T.,,,,,,,,,,,oPrn )
      oFont14:= oSend(TFont(),"New","Times New Roman",0,16,,.F.,,,,,,,,,,,oPrn )
      oFont15:= oSend(TFont(),"New","Times New Roman",0,16,,.T.,,,,,,,,,,,oPrn )
      oFont16:= oSend(TFont(),"New","Arial"          ,0,16,,.T.,,,,,,,,,,,oPrn )
      oFont17:= oSend(TFont(),"New","Arial"          ,0,16,,.F.,,,,,,,,,,,oPrn )
      //                                                            Underline
      oFont9 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,.T.,,,,,,oPrn )
      oFont10:= oSend(TFont(),"New","Courier New"    ,0,10,,.T.,,,,,,,,,,,oPrn )

      aFontes := { oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8, oFont9, oFont10, oFont11, oFont12, oFont13, oFont14, oFont15, oFont16, oFont17 }

      // AVPAGE

	If MV_PAR29 = 1
	   // Endereço Padrão
		empende := SM0->M0_ENDENT
		empbair := SM0->M0_BAIRENT
		empcida := SM0->M0_CIDENT
		empesta := SM0->M0_ESTENT
		empcepe := SM0->M0_CEPENT
		empfone := SM0->M0_TEL
	Else
	   // Endereço Fixo
		empende := "Rua Lessing, 437"
		empbair := "Vila Ema"
		empcida := "São Paulo"
		empesta := "SP"
		empcepe := "03276-000"
		empfone := "001169182939"
	Endif

         Processa({|X| lEnd := X, PR01Det() })

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
      oSend(oFont12,"End")
      oSend(oFont13,"End")
      oSend(oFont14,"End")
      oSend(oFont15,"End")
      oSend(oFont16,"End")
      oSend(oFont17,"End")

   AVENDPRINT
   dbSelectArea("SB1")
	//
Return .T.


*---------------------------*
Static FUNCTION PR01Cabec()
*---------------------------*

c2EndSM0:=""; c2EndSA2:=""; cCommission:=""; c2EndSYT:=""; cTerms:=""
cDestinat:=""; cRepr:=""; cCGC:=""; cNr:=""
oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
//oSend( oPrn, "Say", Linha-50,65 , "Emissao: "+DTOC(DDATABASE), aFontes:TIMES_NEW_ROMAN_10_NEGRITO)
//oSend( oPrn, "Say", Linha-50,2180, "Pag.: "+Str(nPagina,3), aFontes:TIMES_NEW_ROMAN_10_NEGRITO)
//TRACO_NORMAL
//Linha := Linha+80
oSend( oPrn, "Say", Linha-30 , 1400, SM0->M0_NOMECOM      , aFontes:TIMES_NEW_ROMAN_18_NEGRITO,,,, 2 )
oSend( oPrn, "Say", Linha+50 , 1400, Trim(empende)+" - "+Trim(empcida)+" - "+Trim(empesta)+" - CEP "+Transf(empcepe,"@R 99999-999")+" - Fone: "+Trim(empfone) , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 )
oSend( oPrn, "Say", Linha+90 , 1400, "Insc. Est. - 112.815.886.114 - CNPJ 38.908.778/0001-76 ", aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 )
oSend( oPrn, "Say", Linha+130, 1400, "www.gruposhangrila.com.br ", aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 )
//oSend( oPrn, "Say", Linha+90,  1400, " e-mail "+MV_PAR26, aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 )
//oSend( oPrn, "Say", Linha+130, 1400, "PABX: "+empfone, aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 )
oSend( oPrn, "SayBitmap", Linha-40, 100, MV_PAR25 , 164, 200)
Linha := Linha+90

oSend(oPrn,"oFont", aFontes:COURIER_20_NEGRITO)  // Define fonte padrao

Linha := Linha+100

TRACO_NORMAL

Linha := Linha+20

oFnt := aFontes:COURIER_20_NEGRITO

WTAB1 := WTAB2 := WTAB3 := " "
YTAB1 := YTAB2 := YTAB3 := "0"

//IF Subs(MV_PAR12,1,1) $ "1234567"
   WTAB1 := "Tabela "+MV_PAR12
   YTAB1 := Posicione("DA1",1,xFilial("DA1")+MV_PAR12+SB1->B1_COD,"DA1->DA1_PRCVEN")
   If YTAB1 == 0 .And. MV_PAR12 == "1  "
      YTAB1 := SB1->B1_PRV1
   EndIf
/*  --- Desabilitado por Rodrigo Caetano em 08/11/2002
   If Subs(MV_PAR12,1,1) = "1"
      YTAB1 := "SB1->B1_PRV1"
   ELSE
      YTAB1 := "SB5->B5_PRV"+Subs(MV_PAR12,1,1)
   ENDIF
*/
//ENDIF
/*  --- Desabilitado por Rodrigo Caetano em 08/11/2002
IF Subs(MV_PAR12,2,1) $ "1234567"
   WTAB2 := "Preco "+Subs(MV_PAR12,2,1)
   If Subs(MV_PAR12,2,1) = "1"
      YTAB2 := "SB1->B1_PRV1"
   ELSE
      YTAB2 := "SB5->B5_PRV"+Subs(MV_PAR12,2,1)
   ENDIF
ENDIF
IF Subs(MV_PAR12,3,1) $ "1234567"
   WTAB3 := "Preco "+Subs(MV_PAR12,3,1)
   If Subs(MV_PAR12,3,1) = "1"
      YTAB3 := "SB1->B1_PRV1"
   ELSE
      YTAB3 := "SB5->B5_PRV"+Subs(MV_PAR12,3,1)
   ENDIF
ENDIF
*/
//oSend( oPrn, "Say",  Linha,  100, "Codigo"     , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) 
//oSend( oPrn, "Say",  Linha,  350, "Descricao"  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//oSend( oPrn, "Say",  Linha, 1180, "Cod.Barra"  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//oSend( oPrn, "Say",  Linha, 1430, "Emb.Minima" , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//oSend( oPrn, "Say",  Linha, 1650, "Emb.Master" , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//oSend( oPrn, "Say",  Linha, 1860, WTAB1        , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//oSend( oPrn, "Say",  Linha, 2060, "Un"         , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //2010
//IF MV_PAR30 = 1
//	oSend( oPrn, "Say",  Linha, 2130, "Tipo"       , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //2090
//Endif
//oSend( oPrn, "Say",  Linha, 2040, WTAB2        , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//oSend( oPrn, "Say",  Linha, 2190, WTAB3        , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )

Linha := Linha+50

oSend(oPrn,"oFont", aFontes:TIMES_NEW_ROMAN_10_NEGRITO) // Define fonte padrao

//TRACO_NORMAL

Linha := Linha+15

Return

*------------------------------*
Static FUNCTION PR01Traco()
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
Static Function PR01Det()
*--------------------------*  

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
//If MV_PAR14 = 3
//  TRACO_NORMAL
//  Linha := Linha + 15
//Endif

DbSelectArea("SB1")
If MV_PAR14 = 3
   Dbgotop()
Else
   Dbseek(xFilial("SB1")+MV_PAR08,.T.)
Endif
ProcRegua(LastRec())

Do While !SB1->(Eof()) .And. (MV_PAR14=3.Or.(SB1->B1_GRUPO<=MV_PAR09))

   IncProc("Imprimindo...") // Atualiza barra de progresso

   IF ((MV_PAR13 = 1 .AND. SB1->B1_TABELA <>"N") .OR. MV_PAR13 = 2)

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
	
//	   IF WPED <> &WCHAV
//	      WPED := &WCHAV
//	      
//         TRACO_NORMAL
//         WGRU := POSICIONE("SBM",1,XFILIAL("SBM")+SB1->B1_GRUPO,"BM_DESC")
//		   Linha := Linha + 15
//	      
//	      oSend(oPrn,"Say", Linha,   65, SB1->B1_GRUPO+" "+WGRU   ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//		   Linha := Linha + 50
//	      
//	   ENDIF
//	   
       YTAB1 := Posicione("DA1",1,xFilial("DA1")+MV_PAR12+SB1->B1_COD,"DA1->DA1_PRCVEN")
       If YTAB1 == 0 .And. MV_PAR12 == "1  "
          YTAB1 := SB1->B1_PRV1
       EndIf

//	   oSend( oPrn, "SayBitmap", Linha, 100, '_arquivos/010/produtos/fotos/'+SB1->B1_COD+'.jpg' , 400, 200)
//	   oSend( oPrn, "SayBitmap", Linha, 100, '042001.jpg' , 400, 200)

	   oSend(oPrn,"Say", Linha,  1125, 'Ficha de Cadastro de Produto' ,aFontes:TIMES_NEW_ROMAN_18_NEGRITO,,,, 2 )
	   Linha := Linha + 100
       TRACO_NORMAL
	   Linha := Linha + 50
	   oSend(oPrn, "SayBitmap", Linha, 0725, '/sigaadv/_arquivos/010/produtos/fotos/'+trim(SB1->B1_COD)+'.bmp' , 800, 800)
	   Linha := Linha + 850
       TRACO_NORMAL
	   Linha := Linha + 50

       aCalls   := {}
       DetStep := 70
       DetCol1 := 200
       DetCol2 := 1100
       DetCount := Linha
	   
	   aAdd(aCalls,{'Descrição do Produto'  ,SB1->B1_DESC})
	   aAdd(aCalls,{'Código do Produto'     ,SB1->B1_COD})
	   aAdd(aCalls,{'EAN13'                 ,SB1->B1_CODBAR})
	   aAdd(aCalls,{'NCM'                   ,SB1->B1_POSIPI})
	   aAdd(aCalls,{'  Comprimento'         ,Trim(Transf(SB5->B5_COMPR ,"@E@Z 99.9999")+' m')})
	   aAdd(aCalls,{'  Espessura'           ,Trim(Transf(SB5->B5_ESPESS,"@E@Z 99.9999")+' m')})
	   aAdd(aCalls,{'  Largura'             ,Trim(Transf(SB5->B5_LARG  ,"@E@Z 99.9999")+' m')})
	   aAdd(aCalls,{'Peso Unitário Liquido' ,Trim(Transf(SB1->B1_PESO  ,"@E@Z 99.9999")+' kg')})
	   aAdd(aCalls,{'Embalagem Mínima'      ,Trim(Transf(SB5->B5_QE1   ,"@E@Z 999")+' '+SB1->B1_UM)})
	   aAdd(aCalls,{'Embalagem Master'      ,Trim(Transf(SB5->B5_QE2   ,"@E@Z 999")+' '+SB1->B1_UM)})
	   aAdd(aCalls,{'Peso Embalagem Master' ,Trim(Transf(SB5->B5_QE2*SB1->B1_PESO,"@E@Z 99.9999")+' kg')})
//	   aAdd(aCalls,{'Composição'            ,'Composição'})
//	   aAdd(aCalls,{'Descrição'             ,'Descrição'})
	   
	   aAdd(aCalls,{'Valor vigente'         ,'R$'+Trim(Transf(SB1->B1_PRV1,"@E@Z 99,999.99"))})
//	   aAdd(aCalls,{'Valor novo'            ,'Valor novo'})
//	   aAdd(aCalls,{'Percentual de Reajuste','Percentual de Reajuste'})
	   
	   For i := 1 To Len(aCalls)
		  //
	      oSend(oPrn, "Say", Linha, DetCol1, aCalls[i,1], aFontes:PROD_CHAMADA )
	      oSend(oPrn, "Say", Linha, DetCol2, aCalls[i,2], aFontes:PROD_VALOR )
	      Linha := Linha + DetStep
	   	  //
	   Next
	
	   PRCHKLINE()

   Endif
  
   SB1->(dbSkip())
   
Enddo

Linha := Linha + 30
TRACO_NORMAL
                                            
Linha := Linha + 30
oSend(oPrn,"Say", Linha,  065, MV_PAR15, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )

If !Empty(MV_PAR16)
	PRCHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR16, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR16)
	PRCHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR17, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR16)
	PRCHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR18, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR16)
	PRCHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR19, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR16)
	PRCHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR20, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR16)
	PRCHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR21, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR16)
	PRCHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR22, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR16)
	PRCHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR23, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR16)
	PRCHKLINE()		
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
Static Function PRValidPerg()
///////////////////////////
//
_sAlias := Alias()
cPerg   := Padr(cPerg, 6)
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
aAdd(aRegs,{cPerg,"13","Imprime Tabela     ?","Imprime Tabela     ?","Imprime Tabela     ?","mv_chd","N",01,0,0,"C","","mv_par13","Somente Liberadas","Somente Liberadas","Somente Liberadas","","","Todas","Todas","Todas","","","","","","","","","","","","","","","","","","","","","",""})
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


Static Function PRCHKLINE()
*------------------------
   Linha := Linha+50
   ENCERRA_PAGINA
   Linha := Linha+80
   COMECA_PAGINA
   WPED  := "ZZZZZZ"
//	If MV_PAR14 = 3
//	   TRACO_NORMAL
//	   Linha := Linha + 15
//	Endif
Return