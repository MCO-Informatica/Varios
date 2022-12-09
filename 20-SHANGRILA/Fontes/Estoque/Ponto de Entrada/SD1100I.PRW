#include "rwmake.ch"
#include "protheus.ch"

User Function SD1100I()

LOCAL _aArea    := GetArea()
LOCAL _aAreaSB1 := SB1->( GetArea() )
LOCAL _aAreaSF4 := SF4->( GetArea() )

dbSelectArea("SF4")  
dbSetOrder(1)        
dbSeek( xFilial("SF4") + SD1->D1_TES , .F. )
	
If !SD1->D1_TIPO$"DB"
	If SF4->F4_ESTOQUE $"S" .AND. SF4->F4_DUPLIC $ "S"
	
		dbSelectArea("SB1")  
		dbSetOrder(1)        
		dbSeek( xFilial("SB1") + SD1->D1_COD , .F. )
		
		If SD1->D1_DTDIGIT >= SB1->B1_DATREF
			RecLock("SB1",.f.)
			SB1->B1_X_CUSTD := "N"
			MsUnLock()
		EndIf

		If !Empty(SB1->B1_X_ALTER)
		
			_cProdDest	:=	Subs(SB1->B1_X_ALTER,1,15)
		
		ElseIf Len(Alltrim(SB1->B1_COD))>9
		
			//----> VERIFICA SE EXISTE PRODUTO ESPECIAL
			If Subs(SB1->B1_COD,1,1)$"Z"
				_cProdDest	:=	Subs(SB1->B1_COD,2,15)
		
			//----> CASO CONTRARIO PEGA PRODUTO PADRAO
			Else
				_cProdDest	:=	"Z"+Subs(SB1->B1_COD,1,15)
			EndIf
		Else
			//----> VERIFICA SE EXISTE PRODUTO ESPECIAL
			If Subs(SB1->B1_COD,1,1)$"Z"
				_cProdDest	:=	Subs(SB1->B1_COD,2,15)
		
			//----> CASO CONTRARIO PEGA PRODUTO PADRAO
			Else
				_cProdDest	:=	"Z"+Subs(SB1->B1_COD,1,15)
			EndIf
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+_cProdDest,.f.)
				
			If SD1->D1_DTDIGIT >= SB1->B1_DATREF
				RecLock("SB1",.f.)
				SB1->B1_X_CUSTD := "N"
				MsUnLock()
			EndIf
		EndIf
			
	EndIf
EndIf
	
RestArea( _aAreaSF4 )
RestArea( _aAreaSB1 )
RestArea( _aArea )

Return( .T. )
