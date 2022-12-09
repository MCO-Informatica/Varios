#include 'protheus.ch'
#include 'parmtype.ch'

user function zVXNotas()

	cXNotas := M->C7_XNOTAS
	
	nLinNot :=  MLCount(cXNotas, 200 )
	if MLCount(cXNotas, 200 ) > 16
		MsgInfo( 'Notas da Ordem de Compra não pode ultrapassar 16 linhas.' + Chr(13) + Chr(10) + 'Existem ' + cValtoChar( MLCount(cXNotas, 200 ) ), 'Westech' )
	endif
return (cXNotas)