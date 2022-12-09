#INCLUDE "RWMAKE.CH"


User Function MT120LOK()

Local _lRet			:=	.t.
Local _cBloqueia	:=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C7_KAPROVA"})]

//----> VERIFICA SE JA ESTA APROVADO E NAO DEIXA ALTERAR                                            
If ALTERA .And. _cBloqueia$"A"
	If !Alltrim(Subs(cUsuario,7,4))$"Admin/Roge/Albe/Rona/Euge"
		MsgBox("Esse pedido não pode ser alterado pois já foi aprovado pela Diretoria.","Alteração Recusada - Pedido Aprovado","Stop")
		_lRet	:=	.f.
	EndIf                                                                                           
EndIf

Return(_lRet)
