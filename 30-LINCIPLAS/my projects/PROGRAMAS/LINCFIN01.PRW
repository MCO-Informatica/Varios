#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LINCFIN01 ºAutor  ³Rodigo Correa       º Data ³  03/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TELINHA UTILIZADA PARA GERACAO DO CONTAS A PAGAR           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LIFIN01()
aArea		:= GetArea()

IF M->E2_GERAR == "S"
	
	PRIVATE oBrowQtd := Nil, oDlgQtd := Nil
	PRIVATE aCols := {}, aHeader := {}, aCampos := {}
	PRIVATE nUsado := 0
	
	PRIVATE cE2_NUM := Space(06)
	
	aRotina := {{"","",0,1},{"","",0,2},{"","",0,3},{"","",0,4}}
	
	aHeader 	:= {}
	nOpc 		:= 3
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_PREFIXO")
	
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		003,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_NUM")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_PARCELA")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		002,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_TIPO")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_NATUREZ")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_FORNEC")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_LOJA")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_EMISSAO")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_VENCTO")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_VENCREA")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_VALOR")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_VLCRUZ")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_HIST")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_GRUPO")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGotop()
	If DbSeek("E2_DESCGRU")
		Aadd(aHeader,{Trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VLDUSER,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT})
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	aCols := {}
	nCont := 1
	Aadd(aCols,{Space(03),Space(06),Space(02),Space(03),Space(10),Space(06),Space(02),Space(08),Space(08),Space(08),Space(17),Space(17),Space(25),Space(06),Space(40),.F.})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulo da Janela                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTitulo:="Inclusao de Titulos a Pagar"
	nOpc	 := 4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada do comando browse                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	@ 000,000 TO 500,800 DIALOG oMainDlg TITLE cTitulo
	
	cE2_PREFIXO		:= M->E2_PREFIXO //Space(03)
	cE2_NUM	    	:= M->E2_NUM //Space(06)
	cE2_PARCELA	  	:= Space(02)
	cE2_TIPO	  	:= M->E2_TIPO //Space(03)
	cE2_NATUREZ	  	:= M->E2_NATUREZ //Space(10)
	cE2_FORNECE     := M->E2_FORNECE //Space(06)
	cE2_LOJA		:= M->E2_LOJA //Space(02)
	dE2_EMISSAO	    := M->E2_EMISSAO 
	dE2_VENCTO	    := M->E2_VENCTO //cTod("  /  /  ")
	dE2_VENCREA	    := M->E2_VENCREA //cTod("  /  /  ")
	nE2_VALOR	    := M->E2_VALOR
	nE2_VLCRUZ	    := M->E2_VLCRUZ
	cE2_HIST	    := M->E2_HIST
	cE2_GRUPO	    := M->E2_GRUPO
	cE2_DESCGRU	    := M->E2_DESCGRU
	
	
	
	@ 004,003 TO 093,390
	
	@ 010,015 Say "Prefixo"
	@ 010,065 Get cE2_PREFIXO PICTURE "@!" SIZE 03,10 //Valid Pedido()
	
	@ 010,115 Say "Grupo"
	@ 010,165 Get cE2_GRUPO F3 "SZ9" PICTURE "@!" SIZE  06,10
    
	@ 010,215 Say "Descricao do Grupo" 
	@ 010,265 Get cE2_DESCGRU  PICTURE "@!" SIZE  100,10
	
	@ 022,015 Say "Numero"
	@ 022,065 Get cE2_NUM PICTURE "@!" SIZE 06,10
	
	@ 022,115 Say "Parcela"
	@ 022,165 Get cE2_PARCELA PICTURE "@!" SIZE 02,10
		
	@ 034,015 Say "Tipo"
	@ 034,065 Get cE2_TIPO  PICTURE "@!" SIZE  03,10

    @ 034,115 Say "Natureza"
	@ 034,165 Get cE2_NATUREZ F3 "SED" PICTURE "@!"  SIZE  50,10

	@ 046,015 Say "Fornecedor"
	@ 046,065 Get cE2_FORNECE F3 "SA2" PICTURE "@!" SIZE  06,10

	@ 046,115 Say "Loja"
	@ 046,165 Get cE2_LOJA  PICTURE "@!" SIZE  02,10

	@ 058,015 Say "Emissao"
	@ 058,065 Get dE2_EMISSAO SIZE  08,10
	
	@ 058,115 Say "Vencimento"
	@ 058,165 Get dE2_VENCTO  SIZE  08,10
	
	@ 058,215 Say "Vencto Real" 
	@ 058,265 Get dE2_VENCREA  SIZE  08,10
	
	@ 070,015 Say "Valor"
	@ 070,065 Get nE2_VALOR PICTURE "@R 999,999,999.99" SIZE  50,10
    
    @ 070,115 Say "Valor Cruz"
	@ 070,165 Get nE2_VLCRUZ PICTURE "@R 999,999,999.99" SIZE  50,10

	@ 082,015 Say "Historico"
	@ 082,065 Get cE2_HIST PICTURE "@!" SIZE  100,10 Valid Pedido()
    


	@ 096,003 TO 247,390
	
	oBrowQtd := MsGetDados():New(100,005,220,385,nOpc,"AllwaysTrue","AllwaysTrue",,.T.)//GetQtd,,,Len(aCols))
	oBrowQtd:oBrowse:bWhen := {||(Len(aCols),.T.)}
	oBrowQtd:oBrowse:Refresh()
	
	@ 230,240 BUTTON "_Gera Fin"	            SIZE 50,12 ACTION GeraFin()
	@ 230,300 BUTTON "_Cancela" 				SIZE 38,12 ACTION FECHAR()
	
	ACTIVATE DIALOG oMainDlg CENTERED
	
ENDIF

RestArea(aArea)
Return(M->E2_GERAR)

Static Function Pedido()

aCols := {}

_dVencim := M->E2_VENCTO       
_nDia := Day(_dVencim)
_nParcela := M->E2_PARCELA
_nValPar := 1  

For ai := 1 To VAL(_nParcela)
	     AADD(aCols,{cE2_PREFIXO,cE2_NUM,STRZERO(_nValPar,2),cE2_TIPO,cE2_NATUREZ,cE2_FORNECE,cE2_LOJA,dE2_EMISSAO,_dVencim,_dVencim,nE2_VALOR,nE2_VLCRUZ,cE2_HIST,cE2_GRUPO,cE2_DESCGRU,.f.}) //Array(nUsado+1))
	     IF (MONTH(_dVencim) == 12)
		    _dVencim := CTOD(STRZERO(_nDia,2)+"/01/"+STRZERO(YEAR(_dVencim)+1,4))
     	 ELSEIF (MONTH(_dVencim) == 1) .AND. _nDia >= 29
	      	_dVencim := UltimoDia(ctod("01/02/"+strzero(year(_dVencim))))
         ELSE
	      	_dVencim := CTOD(STRZERO(_nDia,2)+"/"+STRZERO((MONTH(_dVencim)+1),2)+"/"+STRZERO(YEAR(_dVencim),4))
	     ENDIF 
		 _nValPar := _nValPar + 1
Next ai                                           


If (oBrowQtd <> Nil)
	oBrowQtd:oBrowse:Refresh()
Endif

SysRefresh()

Return (.T.)


Static Function Fechar()
Close(oMainDlg)
RestArea(aArea)
Return(.T.)

Static Function GeraFin()

For i:=1 to len(aCols)
	DbSelectArea("SE2")
	DbSetOrder(1)
	DbSeek( xFilial() + aCols[i,1] + aCols[i,2] + aCols[i,3] + aCols[i,4] + aCols[i,5] + aCols[i,6] + aCols[i,7] ) 
	If Found()
	Aviso("Ja Existe","Titulo ja Existe",{"Voltar"})	
	Else
    	RecLock("SE2", .T. )
		SE2->E2_FILIAL := xFilial("SE2")
		SE2->E2_PREFIXO := aCols[i,1]
		SE2->E2_NUM := aCols[i,2]
		SE2->E2_PARCELA := aCols[i,3]
		SE2->E2_TIPO := aCols[i,4]
		SE2->E2_NATUREZ := aCols[i,5]
		SE2->E2_FORNECE := aCols[i,6]
		SE2->E2_LOJA := aCols[i,7]
		SE2->E2_NOMFOR := M->E2_NOMFOR
		SE2->E2_EMISSAO := aCols[i,8]
		SE2->E2_VENCTO := aCols[i,9]
		SE2->E2_VENCREA := aCols[i,10]
		SE2->E2_VALOR := aCols[i,11]
		SE2->E2_EMIS1 := aCols[i,8]
		SE2->E2_HIST := aCols[i,13]
		SE2->E2_GERAR := "N"
		SE2->E2_SALDO := aCols[i,11]
		SE2->E2_VENCORI := aCols[i,10]
		SE2->E2_MOEDA := 01
		SE2->E2_RATEIO := "N"
		SE2->E2_VLCRUZ := aCols[i,12]
		SE2->E2_OCORREN := "01"
		SE2->E2_FLUXO := "S"
		SE2->E2_ORIGEM := "FINA050"
		SE2->E2_DESDOBR := "N"
		SE2->E2_MULTNAT := "2"
		SE2->E2_PROJPMS := "2"
		SE2->E2_DIRF := "2"
		SE2->E2_MODSPB := "1"
		SE2->E2_FILORIG := "01"
		SE2->E2_MDRTISS := "1"
		SE2->E2_FRETISS := "1"
		SE2->E2_APLVLMN := "1"
		SE2->E2_TRETISS := "2"
		SE2->E2_GRUPO   := aCols[i,14]
		SE2->E2_DESCGRU := aCols[i,15]
		
		MsUnlock()
	Endif
NEXT I 
Return(.T.)

