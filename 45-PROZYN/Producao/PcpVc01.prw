#include "Rwmake.ch"
#include "Protheus.ch"                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCPVC01   ณAutor  ณHenio Brasil        ณ Data ณ 26/04/2018  บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao no item de movimentacao de ajuste de Empenho Mod2 บฑฑ
ฑฑบ          ณpara nao permitir alterar produto.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบUtilizado ณMATA361 - Ajuste de Empenho Mod II                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบEmpresa   ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function PCPVC01(nType) 

Local lReturn	:= .T.       
Local aEnvD3	:= GetArea()  
Local cUserLog	:= RetCodUsr() //c๓digo do usuแrio Logado.      
Local cUserMov	:= SuperGetMv("NB_USRMTE", .F., "000000")  
Local nPosCod	:= If(FunName()=="MATA381", aScan(aHeader,	{|x| Trim(x[2])=="D4_COD"}), 0) 
Local nPosAlm	:= If(FunName()=="MATA381", aScan(aHeader,	{|x| Trim(x[2])=="D4_LOCAL"}), 0) 
Local lNewLine	:= If(FunName()=="MATA381", Empty(aCols[n][nPosCod]) .And. Empty(aCols[n][nPosAlm]), .F.) 

// MsgAlert("Validacao do codigo do Material - MATA381 ")
/* 
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณTratamento apenas para qdo for Movto Interno Mod I e Mod II             ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/                                                                                              
If FunName()<>"MATA381"  
	Return(.T.)   
Endif 
/* 
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณValida transferencia Mod 2 para usuarios especificos                    ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/ 
If FunName()=="MATA381" 
	/* 
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณValida se o usuario pode faser transferencia entre materiais diferentes ณ  
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	If lNewLine
		If !(cUserLog $ cUserMov)
			MsgAlert("Caro usuแrio, voc๊ nใo tem permissใo para incluir novos materiais! Contate o Administrador! ","Permissใo de Usuario")  
			lReturn	:= .F. 		
		Endif
	Endif 	
Endif 	
RestArea(aEnvD3) 
Return(lReturn) 