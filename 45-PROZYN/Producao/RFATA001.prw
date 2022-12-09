#INCLUDE "rwmake.ch"
#include "Ap5Mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA001  º Autor ³Roberta Alonso      º Data ³  27/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tela para controle de coleta                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Redelease                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFATA001()
Local aFixe	:= {} //Array contendo a ordem inicial do browse
Local nFixe := 0

aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "C5_FECENT" , "X3_TITULO"  )
	aFixe[nFixe][2] := "C5_FECENT"
	aFixe[nFixe][3] := GetSx3Cache( "C5_FECENT" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "C5_FECENT" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "C5_FECENT" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "C5_FECENT" , "X3_PICTURE" )

aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "C5_EMISSAO" , "X3_TITULO"  )
	aFixe[nFixe][2] := "C5_EMISSAO"
	aFixe[nFixe][3] := GetSx3Cache( "C5_EMISSAO" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "C5_EMISSAO" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "C5_EMISSAO" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "C5_EMISSAO" , "X3_PICTURE" )

aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "C5_DTEXP" , "X3_TITULO"  )
	aFixe[nFixe][2] := "C5_DTEXP"
	aFixe[nFixe][3] := GetSx3Cache( "C5_DTEXP" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "C5_DTEXP" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "C5_DTEXP" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "C5_DTEXP" , "X3_PICTURE" )

aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "C5_NOMECLI" , "X3_TITULO"  )
	aFixe[nFixe][2] := "C5_NOMECLI"
	aFixe[nFixe][3] := GetSx3Cache( "C5_NOMECLI" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "C5_NOMECLI" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "C5_NOMECLI" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "C5_NOMECLI" , "X3_PICTURE" )

aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "C5_NOMTRAN" , "X3_TITULO"  )
	aFixe[nFixe][2] := "C5_NOMTRAN"
	aFixe[nFixe][3] := GetSx3Cache( "C5_NOMTRAN" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "C5_NOMTRAN" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "C5_NOMTRAN" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "C5_NOMTRAN" , "X3_PICTURE" )

aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "C5_TPFRETE" , "X3_TITULO"  )
	aFixe[nFixe][2] := "C5_TPFRETE"
	aFixe[nFixe][3] := GetSx3Cache( "C5_TPFRETE" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "C5_TPFRETE" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "C5_TPFRETE" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "C5_TPFRETE" , "X3_PICTURE" )

aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "C5_NOTA" , "X3_TITULO"  )
	aFixe[nFixe][2] := "C5_NOTA"
	aFixe[nFixe][3] := GetSx3Cache( "C5_NOTA" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "C5_NOTA" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "C5_NOTA" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "C5_NOTA" , "X3_PICTURE" )

aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "C5_NUM" , "X3_TITULO"  )
	aFixe[nFixe][2] := "C5_NUM"
	aFixe[nFixe][3] := GetSx3Cache( "C5_NUM" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "C5_NUM" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "C5_NUM" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "C5_NUM" , "X3_PICTURE" )

aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "C5_MOTORIS" , "X3_TITULO"  )
	aFixe[nFixe][2] := "C5_MOTORIS"
	aFixe[nFixe][3] := GetSx3Cache( "C5_MOTORIS" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "C5_MOTORIS" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "C5_MOTORIS" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "C5_MOTORIS" , "X3_PICTURE" )

Private cCadastro := "Controle de Coleta"

Private aRotina := { {"Pesquisar" 		,"AxPesqui"  ,0,1} ,;
	    	         {"Visualizar"		,"AxVisual"  ,0,2} ,;
    	    	     {"Logistica" 		,"U_RFAT16L" ,0,3} ,;
		             {"Rel. Separação"	,"U_RFATR003",0,2} ,;
		             {"Peso Bruto"		,"U_RFAT16P" ,0,2} ,;
    	    	     {"Legenda"  		,"U_FAT6Leg" ,0,3} }
//    	    	     {"Coleta"    ,"U_RFAT16C",0,3} ,;

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SC5" 


aCores := { { "Empty(C5_LIBEROK).And. Empty(C5_NOTA) .And. Empty(C5_BLQ)",'BR_PRETO' },; //pedido nao liberado para separação
			{ "(!Empty(C5_LIBEROK)) .and. Empty(C5_NOTA) .And. Empty(C5_BLQ) .and. Empty(C5_LOGIST) ",'ENABLE' },;		//Pedido liberado e não informada logistica
			{ "(!Empty(C5_LIBEROK)) .and. Empty(C5_NOTA) .And. Empty(C5_BLQ) .and. !Empty(C5_LOGIST) ",'BR_AMARELO' },;		//Pedido liberado e informada logistica
			{ "(!Empty(C5_NOTA) .Or. C5_LIBEROK=='E') .And. Empty(C5_BLQ) .And. !Empty(C5_LOGIST)" ,'DISABLE'},;   //Faturada com logistica
			{ "(!Empty(C5_NOTA) .Or. C5_LIBEROK=='E') .And. Empty(C5_BLQ) .And. Empty(C5_LOGIST)",'BR_LARANJA'}}  //Faturada sem logistica 



dbSelectArea("SC5")
dbSetOrder(1)

//mBrowse( 6,1,22,75,cString,_aCampos,,,,,aCores)
mBrowse( 6,1,22,75,cString,aFixe,,,,,aCores)

Return

/*
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ abrindo a tela da logistica                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
*/

User Function RFAT16L()

_cMotoris := SC5->C5_MOTORIS
_cDtCol   := SC5->C5_DTCOL 
_cNumCol  := SC5->C5_NUMCOL
_cVol     := SC5->C5_VOL   
_cDtExp   := SC5->C5_DTEXP

IF SF2->F2_TIPO == "B" .or. SF2->F2_TIPO == "D"
	_cCodCli := SC5->C5_CLIENTE
	_cLoja   := SC5->C5_LOJACLI
	_cCliente:= "Fornecedor: " + Posicione("SA2",1,xFilial("SA2") + _cCodCli + _cLoja,"A2_NREDUZ")
Else
	_cCodCli := SC5->C5_CLIENTE
	_cLoja   := SC5->C5_LOJACLI
	_cTransp := SC5->C5_TRANSP
	DbselectArea("SA1")
    DbSetOrder(1)
    If DbSeek(xFilial("SA1") + _cCodCli + _cLoja)
		_cCliente:= "Cliente: " + _cCodCli +"/"+ _cLoja +" - " + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99") + " - " +  trim(SA1->A1_NREDUZ) + " - " + trim(SA1->A1_MUN)
    endif		
	DbselectArea("SA4")
    DbSetOrder(1)
    If DbSeek(xFilial("SA4") + _cTransp)
		_cTransp:= "Transp: " + _cTransp + " - " + trim(SA4->A4_NREDUZ) + " - " + "("+SA4->A4_DDD+")"+Transform(SA4->A4_TEL,"@R 9999-9999") 
    endif		
Endif                    

_cLogist  := SC5->C5_LOGIST
_aLogist  := {"C=Coleta","E=Entrega","R=Retira"}
_cTot 	  := Transform(Posicione("SF2",1,xFilial("SF2") + SC5->C5_NOTA + SC5->C5_SERIE + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"F2_VALFAT"),"@E 999,999.99")
_cTpf	  := Iif(SC5->C5_TPFRETE == 'F','FOB','CIF')
	
@ 001,001 TO 280,500 DIALOG oDlg5 TITLE "Informacoes de logistica" 
@ 005,008 Say _cCliente        
@ 020,008 Say _cTransp
@ 035,008 Say OemToAnsi("Data Coleta: ")
@ 034,045 Get _cDtCol    Size 70,11  
@ 034,125 Get _cTpf    Size 50,11  
@ 050,008 Say OemToAnsi("Numero Coleta: ")
@ 049,045 Get _cNumCol   Size 130,11  
@ 065,008 Say OemToAnsi("Motorista: ")
@ 064,045 Get _cMotoris Size 130,11  
@ 080,008 Say OemToAnsi("Volume:     ")
@ 079,045 Get _cVol      Size 130,11 
@ 095,008 Say OemToAnsi("Logistica: ")
@ 094,045 COMBOBOX _cLogist ITEMS _aLogist SIZE 050,11
@ 094,105 Get _cTot      Size 70,11 
@ 110,008 Say OemToAnsi("Expedido Em: ")
@ 109,045 Get _cDtExp    Size 130,11  
@ 125,100 Button OemToAnsi("_Ok") Size 25,11 Action GravaObs1()
@ 125,150 Button OemToAnsi("_Cancel") Size 25,11 Action Close(odlg5)


Activate Dialog oDlg5 Centered

Return(.T.)

Static Function GravaObs1()

DbSelectarea("SC5")
RecLock("SC5",.F.)
SC5->C5_MOTORIS  := _cMotoris 
SC5->C5_DTCOL    := _cDtCol
SC5->C5_NUMCOL   := _cNumCol 
SC5->C5_VOL      := _cVol
SC5->C5_LOGIST   := _cLogist
SC5->C5_DTEXP    := _cDtExp
MsUnlock()

Close(oDlg5)

Return


/*
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ abrindo a tela da coleta                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
*/
User Function RFAT16C()

_cDtCol   := SC5->C5_DTCOL
_cNumCol  := SC5->C5_NUMCOL

IF SF2->F2_TIPO == "B" .or. SF2->F2_TIPO == "D"
	_cCodCli := SF2->F2_CLIENTE
	_cLoja   := SF2->F2_LOJA
	_cCliente:= "Fornecedor: " + Posicione("SA2",1,xFilial("SA2") + _cCodCli + _cLoja,"A2_NREDUZ")
Else
	_cCodCli := SF2->F2_CLIENTE
	_cLoja   := SF2->F2_LOJA
	_cCliente:= "Cliente: " + Posicione("SA1",1,xFilial("SA1") + _cCodCli + _cLoja,"A1_NREDUZ")
Endif                    

@ 001,001 TO 220,400 DIALOG oDlg5 TITLE "Informacoes de coleta"
@ 004,008 Say _cCliente 
@ 020,008 Say OemToAnsi("Data Saida: ")
@ 019,045 Get _cDtCol    Size 120,11  
@ 035,008 Say OemToAnsi("Numero Coleta: ")
@ 034,045 Get _cNumCol   Size 120,11  
@ 095,100 Button OemToAnsi("_Ok") Size 25,11 Action GravaObs2()
@ 095,150 Button OemToAnsi("_Cancel") Size 25,11 Action Close(odlg5)

Activate Dialog oDlg5 Centered

Return(.T.)

Static Function GravaObs2()

DbSelectarea("SC5")
RecLock("SC5",.F.)
SC5->C5_DTCOL   := _cDtCol
SC5->C5_NUMCOL  := _cNumCol  
MsUnlock()

Close(oDlg5)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ TILegenda ³ Autor ³ Roberta                ³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Exibe as legendas do browse.                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function FAT6Leg()

BrwLegenda(cCadastro, "Legenda", {  {"BR_PRETO"   , "Pedido não liberado para separação."},;	
									{"ENABLE"     , "Pedido liberado e nao informada a logistica."},;
									{"BR_AMARELO" , "Pedido liberado e informada a logistica."},;
					 				{"DISABLE"    , "Pedido faturado com logistica informada."},;
									{"BR_LARANJA" , "Pedido faturado sem logistica informada."}})
                                               
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ U_RFAT16P ³ Autor ³ Roberta                ³ Data ³ 07/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Calcula o peso bruto dos produtos contidos no pedido de venda³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function RFAT16P()

_cPedido := SC5->C5_NUM
_nPesBru := 0
_nPesLiq := 0
DbselectArea("SC6")
DbSetOrder(1)
If DbSeek(xFilial("SC6") + _cPedido)
	While !EOF() .and. xFilial("SC6") == SC6->C6_FILIAL .and. _cPedido == SC6->C6_NUM
		// Abre o cadastro de produtos para buscar o peso bruto dos produtos
		Dbselectarea("SB1")
		Dbsetorder(1)
		Dbseek(xFILIAL("SB1") + SC6->C6_PRODUTO)
		   
		_nPesBru := _nPesBru + (SB1->B1_PESBRU * SC6->C6_QTDVEN)
		_nPesLiq	:= _nPesLiq + (SB1->B1_PESO * SC6->C6_QTDVEN)
		DbselectArea("SC6")
		dbSkip()
	Enddo

	Alert("Peso Bruto Total: " + Transform(_nPesBru,"@E 999,999.99"))
Endif

                                            
Return

