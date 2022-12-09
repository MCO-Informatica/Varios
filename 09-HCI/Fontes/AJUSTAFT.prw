#INCLUDE "RWMAKE.CH"

User Function AJUSTAFT()

dBSelectarea("SFT")
Set Filter to FT_ENTRADA >= CTOD("01/06/18") 
dBgotop() 

While ! SFT->(Eof())
	
	IF SFT->FT_TIPOMOV="E"
		dBSelectarea("SD1")
		dBSetOrder(1)
		IF dBseek(xFilial("SD1")+SFT->FT_NFISCAL + SFT->FT_SERIE +SFT->FT_CLIEFOR + SFT->FT_LOJA,.T.)
			While !Eof() .AND. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == xFilial("SD1")+SFT->FT_NFISCAL + SFT->FT_SERIE +SFT->FT_CLIEFOR + SFT->FT_LOJA
				
				IF SFT->FT_ITEM == SD1->D1_ITEM
					SFT->(Reclock("SFT",.F.))
					SFT->FT_PRODUTO := SD1->D1_COD
					SFT->(MSunlock())
					Exit
				ENDIF
				
				dBSelectarea("SD1")
				dBSkip()
			Enddo
		ENDIF
	Else
		dBSelectarea("SD2")
		dBSetOrder(3)
		IF dBseek(xFilial("SD2")+SFT->FT_NFISCAL + SFT->FT_SERIE +SFT->FT_CLIEFOR + SFT->FT_LOJA,.T.)
			While !Eof() .AND. D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE + D2_LOJA == xFilial("SD2")+SFT->FT_NFISCAL + SFT->FT_SERIE +SFT->FT_CLIEFOR + SFT->FT_LOJA
				
				IF SFT->FT_ITEM == SD2->D2_ITEM
					SFT->(Reclock("SFT",.F.))
					SFT->FT_PRODUTO := SD2->D2_COD
					SFT->(MSunlock())
					Exit
				ENDIF
				
				dBSelectarea("SD2")
				dBSkip()
			Enddo
		ENDIF

	ENDIF
	
	
	dBSelectarea("SFT")
	dBSkip()
	
Enddo

dBSelectarea("SFT")
SET FILTER TO

ALERT("FINALIZOU !!!")

RETURN



