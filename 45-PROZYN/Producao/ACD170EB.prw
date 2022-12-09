#INCLUDE "ACDV167.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ACD170EB Autor ³ Denis Varella    ³ Data ³ 23/07/2019      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Geração de etiquetas por volume                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ACD170EB

Local cCodEmb := ''
Local nTotVol := 0
nTotVol := POSICIONE("SF2",1,xFilial("SF2")+CB7->CB7_NOTA+CB7->CB7_SERIE,"F2_VOLUME1")
cCodEmb := POSICIONE("SF2",1,xFilial("SF2")+CB7->CB7_NOTA+CB7->CB7_SERIE,"F2_CODEMB")

//IF cCodEmb:= "003" //CARGA BATIDA - Caixa  imprimir apenas 1 volume
//	nTotVol:= 1
//Endif

cString := Iif(nTotVol > 1, "Deseja imprimir as "+cValtoChar(nTotVol)+" etiquetas?","Deseja imprimir a única etiqueta?")
If VTYesNo(cString,STR0014,.T.)
	For nVol := 1 to nTotVol-1
		If ExistBlock('IMG05') .and. CB5SetImp(cImp,.t.)
			cCodVol := CB6->(GetSX8Num("CB6","CB6_VOLUME"))
			ConfirmSX8()
			VTAlert("Imprimindo etiqueta "+cValtoChar(nVol)+" / "+cValtoChar(nTotVol),STR0008,.T.,2000) //"Imprimindo etiqueta de volume "###"Aviso"
			ExecBlock("IMG05",.f.,.f.,{cCodVol,CB7->CB7_PEDIDO,CB7->CB7_NOTA,CB7->CB7_SERIE})
			MSCBCLOSEPRINTER()

			CB6->(RecLock("CB6",.T.))
			CB6->CB6_FILIAL := xFilial("CB6")
			CB6->CB6_VOLUME := cCodVol
			CB6->CB6_PEDIDO := CB7->CB7_PEDIDO
			CB6->CB6_NOTA   := CB7->CB7_NOTA
			//CB6->CB6_SERIE  := CB7->CB7_SERIE
			SerieNfId("CB6",1,"CB6_SERIE",,,,CB7->CB7_SERIE)
			CB6->CB6_TIPVOL := CB3->CB3_CODEMB
			CB6->CB6_STATUS := "1"   // ABERTO
			CB6->(MsUnlock())
		EndIf
	Next nVol
EndIf

If empty(cCodEmb)
	cCodEmb := SUPERGETMV("MV_CODEMB", .F., "001")
EndIf

Return cCodEmb