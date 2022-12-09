#INCLUDE "PROTHEUS.CH"

User Function RCTBA002()

                        
Local _cConta := Space(20)


If !Subs(SRV->RV_CONTAC,1,1)$"12"

	// CENTRO CUSTO MAO DE OBRA INDIRETA
	If Subs(SRZ->RZ_CC,1,3)$"1.1"
	
		_cConta:= "41122"+Subs(Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"SRV->RV_CONTAC"),6,15)
	
	// CENTRO CUSTO MAO DE OBRA DIRETA
	ElseIf Subs(SRZ->RZ_CC,1,3)$"1.2"
	
		_cConta:= "41121"+Subs(Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"SRV->RV_CONTAC"),6,15)
	
	// CENTRO CUSTO ADMINISTRATIVO E COMERCIAL
	Else
	
		_cConta:= Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"SRV->RV_CONTAC")
	
	EndIf
Else

	_cConta:= Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"SRV->RV_CONTAC")

EndIf

Return(_cConta)