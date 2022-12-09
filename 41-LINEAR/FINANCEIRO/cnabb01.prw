#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CNABB01   ºAutor  ³Rodrigo Okamoto     º Data ³  03/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para gravação do Endereço no arquivo de remessa   º±±
±±º          ³ CNAB contas a pagar 240 - Banco Real                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10 - LINCIPLAS                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


//PARA TRAZER O LOGRADOURO DO ENDEREÇO
user function cnabb01()
cRet:= ""
if "," $ SA2->A2_END
	cRet:=SUBS(SA2->A2_END,1,AT(",",SA2->A2_END)-1) 
else
	cRet:=SA2->A2_END 
Endif

Return cRet

//-------------------------------------------------
//PARA TRAZER O NUMERO DO ENDEREÇO
user function cnabb02()
cMens:= ""             
cRet:= ""
If "," $ SA2->A2_END
	If SUBS(SA2->A2_END,AT(",",SA2->A2_END)+1,1) == " "
		cMens := subs(SA2->A2_END,AT(",",SA2->A2_END)+2,30)	
		cRet  := subs(cmens,1,AT(" ",cmens)-1)
	Else                                                    
		cMens := subs(SA2->A2_END,AT(",",SA2->A2_END)+1,30)	
		cRet  := subs(cmens,1,AT(" ",cmens)-1)
	EndIf 	
ELSE
	cRet:= ""
EndIf

Return cRet
                                                

//----------------------------------------------------
//PARA TRAZER O COMPLEMENTO DO ENDEREÇO 
user function cnabb03()
cMens:= ""             
cRet:= ""
If "," $ SA2->A2_END
	IF SUBS(SA2->A2_END,AT(",",SA2->A2_END)+1,1) == " "
		cMens := subs(SA2->A2_END,AT(",",SA2->A2_END)+2,30)	
		cRet  := subs(cmens,AT(" ",cmens)+1,30)
	else                                                    
		cMens := subs(SA2->A2_END,AT(",",SA2->A2_END)+1,30)	
		cRet  := subs(cmens,AT(" ",cmens)+1,30)
	endif 
ELSE      
	cRet:= ""
EndIf

Return cRet