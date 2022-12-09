#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#Include "Fileio.ch"
#Include "tbiconn.ch"

User Function AJUSTACD5()

Local dData := CTOD("08/01/2014")  //quando roda no servidor a data fica MM/DIA/AAAA

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"  //-> MUDAR para empresa 01 e depois para empresa 02

DbSelectArea("SD1")
DbSetOrder(3)
DbSeek(xFilial("SD1")+DTOS(dData),.T.)
While !Eof() .and. SD1->D1_EMISSAO >= dData 

	If SUBSTR(SD1->D1_CF,1,1) <> "3" .or. "Z" $ ALLTRIM(SD1->D1_SERIE)
		DbSelectArea("SD1")
		DbSkip()
		loop
	Endif

	DbSelectArea("SF1")
	DbSetOrder(1)
	If DbSeek(xFilial("SF1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA))
	
		DbSelectArea("CD5")
		DbSetOrder(1)
		If !DbSeek(xFilial("CD5")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
			RecLock("CD5",.T.)
				CD5_FILIAL := xFilial("CD5")
				CD5_DOC    := SF1->F1_DOC
				CD5_SERIE  := SF1->F1_SERIE
				CD5_ESPEC  := "N"
				CD5_FORNEC := SF1->F1_FORNECE
				CD5_LOJA   := SF1->F1_LOJA   
				CD5_TPIMP  := "0"
				CD5_DOCIMP := SD1->D1_DI
				CD5_BSPIS  := SF1->F1_BASIMP6
				CD5_ALPIS  := 1.65
				CD5_VLPIS  := SF1->F1_VALIMP6
				CD5_BSCOF  := SF1->F1_BASIMP5
				CD5_ALCOF  := 8.60
				CD5_VLCOF  := SF1->F1_VALIMP5			
				CD5_ACDRAW := "0"
				CD5_DTDI   := SF1->F1_XDTDI
				CD5_LOCDES := SF1->F1_XLOCDES 
				CD5_UFDES  := SF1->F1_XUFDES
				CD5_DTDES  := SF1->F1_XDTDES
				CD5_CODEXP := SF1->F1_XCODEXP
				CD5_DSPAD  := SF1->F1_DESPESA
				CD5_VLRII  := SF1->F1_II
				CD5_NDI    := SD1->D1_DI		
			MsUnLock()	
		Endif
		
	Endif
	
	DbSelectArea("SD1")
	While !Eof() .and. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		DbSelectArea("SD1")
		Dbskip()	
	Enddo
     
Enddo                               

ALERT("CONCLUIDO!!")

Return 
