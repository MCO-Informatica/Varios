#INCLUDE "AvPrint.ch"  
#INCLUDE "Font.ch"  
#INCLUDE "rwmake.ch"       
#DEFINE DLG_CHARPIX_H   15.1
#DEFINE DLG_CHARPIX_W    7.9

Static aMarcados:={}

User Function SHLISTA()        

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
SetPrvt("XLINHA,")


// Para imprimir um BitMap
// Ex: oSend(oPrn, "SayBitmap", nLin, 100, "SEAL.BMP" , 400, 200 )

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦ SHLISTA  ¦ Autor ¦Jaime Ranulfo Leite F. ¦ Data ¦15/09/2002¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Emissao de Lista de Preco com lay-out personalizado        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Observacao¦ Especifico Shangrila                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
cPerg   := PADR("SHLIST",LEN(SX1->X1_GRUPO))               // Pergunta Padrao

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
      //                                                            Underline
      oFont9 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,.T.,,,,,,oPrn )
      oFont10:= oSend(TFont(),"New","Courier New"    ,0,10,,.T.,,,,,,,,,,,oPrn )

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

c2EndSM0:=""; c2EndSA2:=""; cCommission:=""; c2EndSYT:=""; cTerms:=""
cDestinat:=""; cRepr:=""; cCGC:=""; cNr:=""
oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
oSend( oPrn, "Say", Linha-50,65 , "Emissao: "+DTOC(DDATABASE), aFontes:TIMES_NEW_ROMAN_10_NEGRITO)
oSend( oPrn, "Say", Linha-50,2180, "Pag.: "+Str(nPagina,3), aFontes:TIMES_NEW_ROMAN_10_NEGRITO)
TRACO_NORMAL
Linha := Linha+80
oSend( oPrn, "Say", Linha-30 , 1400, SM0->M0_NOMECOM      , aFontes:TIMES_NEW_ROMAN_18_NEGRITO,,,, 2 )
oSend( oPrn, "Say", Linha+50 , 1430, Trim(SM0->M0_ENDENT)+" "+SM0->M0_BAIRENT, aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 )
oSend( oPrn, "Say", Linha+90,  1400, Trim(SM0->M0_CIDENT)+" "+SM0->M0_ESTENT+" CEP "+Transf(SM0->M0_CEPENT,"@R 99999-999")+" e-mail "+MV_PAR21, aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 )
oSend( oPrn, "Say", Linha+130, 1400, "PABX: "+SM0->M0_TEL, aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,, 2 )

oSend( oPrn, "SayBitmap", Linha-40, 100, MV_PAR20 , 400, 200)
Linha := Linha+90

oSend(oPrn,"oFont", aFontes:COURIER_20_NEGRITO)  // Define fonte padrao

Linha := Linha+100

TRACO_NORMAL

Linha := Linha+20

oFnt := aFontes:COURIER_20_NEGRITO

WTAB1 := WTAB2 := WTAB3 := " "
YTAB1 := YTAB2 := YTAB3 := "0"

//IF Subs(MV_PAR07,1,1) $ "1234567"
   WTAB1 := "Tabela "+MV_PAR07
   YTAB1 := Posicione("DA1",1,xFilial("DA1")+MV_PAR07+SB1->B1_COD,"DA1->DA1_PRCVEN")
   If YTAB1 == 0 .And. MV_PAR07 == "1  "
      YTAB1 := SB1->B1_PRV1
   EndIf
/*  --- Desabilitado por Rodrigo Caetano em 08/11/2002
   If Subs(MV_PAR07,1,1) = "1"
      YTAB1 := "SB1->B1_PRV1"
   ELSE
      YTAB1 := "SB5->B5_PRV"+Subs(MV_PAR07,1,1)
   ENDIF
*/
//ENDIF
/*  --- Desabilitado por Rodrigo Caetano em 08/11/2002
IF Subs(MV_PAR07,2,1) $ "1234567"
   WTAB2 := "Preco "+Subs(MV_PAR07,2,1)
   If Subs(MV_PAR07,2,1) = "1"
      YTAB2 := "SB1->B1_PRV1"
   ELSE
      YTAB2 := "SB5->B5_PRV"+Subs(MV_PAR07,2,1)
   ENDIF
ENDIF
IF Subs(MV_PAR07,3,1) $ "1234567"
   WTAB3 := "Preco "+Subs(MV_PAR07,3,1)
   If Subs(MV_PAR07,3,1) = "1"
      YTAB3 := "SB1->B1_PRV1"
   ELSE
      YTAB3 := "SB5->B5_PRV"+Subs(MV_PAR07,3,1)
   ENDIF
ENDIF
*/
oSend( oPrn, "Say",  Linha,  100, "Codigo"     , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) 
oSend( oPrn, "Say",  Linha,  370, "Descricao"  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 1200, "Cod.Barra"  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 1430, "Emb.Minima" , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 1630, "Emb.Master" , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 1820, WTAB1        , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say",  Linha, 1970, "Un"         , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//oSend( oPrn, "Say",  Linha, 2040, WTAB2        , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//oSend( oPrn, "Say",  Linha, 2190, WTAB3        , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )

Linha := Linha+50

oSend(oPrn,"oFont", aFontes:TIMES_NEW_ROMAN_10_NEGRITO) // Define fonte padrao

//TRACO_NORMAL

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
	        oPrn:Box( Linha,2010, (Linha+xLinha),2011)
	        oPrn:Box( Linha,2190, (Linha+xLinha),2191)
	
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

DbSelectArea("SB1")        
cArqNtx  := CriaTrab(NIL,.f.)
If MV_PAR09 = 1
   //IndRegua("SB1",cArqNtx,"B1_FILIAL+B1_GRUPO+B1_COD",,,"Selecionando registros..." )
   Dbsetorder(4)
Elseif MV_PAR09 = 2
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
If MV_PAR09 = 3
  TRACO_NORMAL
  Linha := Linha + 15
Endif

DbSelectArea("SB1")        
If MV_PAR09 = 3
   Dbgotop()
Else
   Dbseek(xFilial("SB1")+MV_PAR03,.T.)
Endif
ProcRegua(LastRec())

Do While !SB1->(Eof()) .And. (MV_PAR09=3.Or.(SB1->B1_GRUPO<=MV_PAR04))

   IncProc("Imprimindo...") // Atualiza barra de progresso

     IF MV_PAR28 = 1
	   IF SB1->B1_COD     < MV_PAR05 .OR. SB1->B1_COD     > MV_PAR06 .OR. ;
	      SB1->B1_GRUPO   < MV_PAR03 .OR. SB1->B1_GRUPO   > MV_PAR04 .OR. ;
	      SB1->B1_TIPO    < MV_PAR01 .OR. SB1->B1_TIPO    > MV_PAR02 .OR. ;
	      SB1->B1_UTILIZ  < MV_PAR22 .OR. SB1->B1_UTILIZ  > MV_PAR23 
	      DBSELECTAREA("SB1")
	      DBSKIP()
	      LOOP
	   ENDIF
	
	   DBSELECTAREA("SB5")
	   DBSETORDER(1)
	   DBSEEK(XFILIAL("SB5")+SB1->B1_COD,.F.)

       If MV_PAR09 = 1 .OR. MV_PAR09 = 2
	      WCHAV := "SB1->B1_GRUPO"
       Else
	      WCHAV := "WPED"
       Endif
	
	   IF WPED <> &WCHAV
	      WPED := &WCHAV
	      
         TRACO_NORMAL
         WGRU := POSICIONE("SBM",1,XFILIAL("SBM")+SB1->B1_GRUPO,"BM_DESC")
		   Linha := Linha + 15
	      
	      oSend(oPrn,"Say", Linha,   65, SB1->B1_GRUPO+" "+WGRU   ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
		   Linha := Linha + 50
	      
	   ENDIF
	   
       YTAB1 := Posicione("DA1",1,xFilial("DA1")+MV_PAR07+SB1->B1_COD,"DA1->DA1_PRCVEN")
       If YTAB1 == 0 .And. MV_PAR07 == "1  "
          YTAB1 := SB1->B1_PRV1
       EndIf

	   oSend(oPrn,"Say", Linha,  100, SB1->B1_COD   ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	   oSend(oPrn,"Say", Linha,  370, SB1->B1_DESC  ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	   oSend(oPrn,"Say", Linha, 1200, SB1->B1_CODBAR,aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	   oSend(oPrn,"Say", Linha, 1510, Transf(SB5->B5_QE1,"@E@Z 99,999,999"),aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	   oSend(oPrn,"Say", Linha, 1670, Transf(SB5->B5_QE2,"@E@Z 99,999,999"),aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	   oSend(oPrn,"Say", Linha, 1820, Transf(YTAB1,"@E@Z 999,999.99"),aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	   oSend(oPrn,"Say", Linha, 1970, SB1->B1_UM    ,aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	   oSend(oPrn,"Say", Linha, 2040, Transf(&YTAB2,"@E@Z 999,999.99"),aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	   oSend(oPrn,"Say", Linha, 2190, Transf(&YTAB3,"@E@Z 999,999.99"),aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	   Linha := Linha + 50
	   
	   CHKLINE()

   Endif
   
   SB1->(dbSkip())
   
Enddo

Linha := Linha + 30
TRACO_NORMAL
                                            
Linha := Linha + 30
oSend(oPrn,"Say", Linha,  065, MV_PAR10, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )

If !Empty(MV_PAR11)
	CHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR11, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR11)
	CHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR12, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR11)
	CHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR13, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR11)
	CHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR14, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR11)
	CHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR15, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR11)
	CHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR16, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR11)
	CHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR17, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR11)
	CHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR18, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

If !Empty(MV_PAR11)
	CHKLINE()		
	Linha := Linha + 50
	oSend(oPrn,"Say", Linha,  065, MV_PAR19, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Endif

Linha := Linha + 50

ENCERRA_PAGINA

dbSelectArea("SB1")
RetIndex("SB1")
fErase(cArqNtx + OrdBagExt())

Return nil


///////////////////////////
Static Function ValidPerg()
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
aAdd(aRegs,{cPerg,"01","Do  Tipo           ?","Do  Tipo           ?","Do  Tipo           ?","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Tipo           ?","Ate Tipo           ?","Ate Tipo           ?","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","",""})
aAdd(aRegs,{cPerg,"03","De  Grupo          ?","De  Grupo          ?","De  Grupo          ?","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","_1","","","",""})
aAdd(aRegs,{cPerg,"04","Ate Grupo          ?","Ate Grupo          ?","Ate Grupo          ?","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","_1","","","",""})
aAdd(aRegs,{cPerg,"05","De  Produto        ?","De  Produto        ?","De  Produto        ?","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegs,{cPerg,"06","Ate Produto        ?","Ate Produto        ?","Ate Produto        ?","mv_ch6","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegs,{cPerg,"07","Tabela de Preço    ?","Tabela de Preço    ?","Tabela de Preço    ?","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","DA0","","","",""})
aAdd(aRegs,{cPerg,"08","Imprime Tabela     ?","Imprime Tabela     ?","Imprime Tabela     ?","mv_ch8","N",01,0,0,"C","","mv_par08","Somente Liberadas","Somente Liberadas","Somente Liberadas","","","Todas","Todas","Todas","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Ordenacao          ?","Ordenacao          ?","Ordenacao          ?","mv_ch9","N",01,0,0,"C","","mv_par09","Grupo+Cod.Produto","Grupo+Cod.Produto","Grupo+Cod.Produto","","","Grupo+Desc.Produto","Grupo+Desc.Produto","Grupo+Desc.Produto","","","Desc.Produto","Desc.Produto","Desc.Produto","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Mensagem 1         ?","Mensagem 1         ?","Mensagem 1         ?","mv_cha","C",30,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Mensagem 2         ?","Mensagem 2         ?","Mensagem 2         ?","mv_chb","C",30,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Mensagem 3         ?","Mensagem 3         ?","Mensagem 3         ?","mv_chc","C",30,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Mensagem 4         ?","Mensagem 4         ?","Mensagem 4         ?","mv_chd","C",30,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Mensagem 5         ?","Mensagem 5         ?","Mensagem 5         ?","mv_che","C",30,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","Mensagem 6         ?","Mensagem 6         ?","Mensagem 6         ?","mv_chf","C",30,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Mensagem 7         ?","Mensagem 7         ?","Mensagem 7         ?","mv_chg","C",30,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Mensagem 8         ?","Mensagem 8         ?","Mensagem 8         ?","mv_chh","C",30,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"18","Mensagem 9         ?","Mensagem 9         ?","Mensagem 9         ?","mv_chi","C",30,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"19","Mensagem 10        ?","Mensagem 10        ?","Mensagem 10        ?","mv_chj","C",30,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"20","Arquivo Logotipo   ?","Arquivo Logotipo   ?","Arquivo Logotipo   ?","mv_chk","C",30,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"21","e-mail             ?","e-mail             ?","e-mail             ?","mv_chl","C",30,0,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"22","Da  Utilizacao     ?","Da  Utilizacao     ?","Da  Utilizacao     ?","mv_chm","C",20,0,0,"G","","mv_par22","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"23","Ate Utilizacao     ?","Ate Utilizacao     ?","Ate Utilizacao     ?","mv_chn","C",20,0,0,"G","","mv_par23","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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


Static Function CHKLINE()
*------------------------
If Linha >= 2800
   Linha := Linha+50
   ENCERRA_PAGINA
   Linha := Linha+80
   COMECA_PAGINA
   WPED  := "ZZZZZZ"
	If MV_PAR09 = 3
	   TRACO_NORMAL
	   Linha := Linha + 15
	Endif
Endif
Return

