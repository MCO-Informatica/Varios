#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Montalot()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_AAREA,_CLOTECTL,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿎liente   ? Kenia Industrias Texteis Ltda.                             낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿛rograma:#? MONTALOT.PRW                                               낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏escricao:? Execblock que gera a numeracap de lotes de producao.       낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏ata:     ? 03/08/00    ? Implantacao: ? 11/08/00                      낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛rogramad:? Sergio Oliveira                                            낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿚bjetivos:? Este programa gera a numeracao automatica dos lotes de pro-낢?
굇?          ? ducao. Ex.: 0000000001, 00000000002...                     낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿌rquivos :? SM4.                                                       낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/


dbSelectArea("SD3")
_aAreaSD3 	:= GetArea()
_cProduto 	:= M->D3_COD 
_cLocal		:= M->D3_LOCAL
_cLotectl	:= SUBS(M->D3_OP,1,6)
_cSeq		:= "0001"

dbSetOrder(19)
If dbSeek(xFilial("SD3")+_cProduto+_cLocal+_cLotectl,.f.)

	While !Eof() .And. SD3->(D3_COD+D3_LOCAL+SUBS(D3_OP,1,6)) == _cProduto+_cLocal+_cLotectl
	     
		_cSeq	:=	Subs(SD3->D3_LOTECTL,7,4)
		
		dbSelectArea("SD3")
		dbSkip()
	EndDo
	
	_cSeq	:=	StrZero(Val(_cSeq)+1,4)
Else
	_cSeq	:=	"0001"
EndIf

RestArea(_aAreaSD3)

Return(_cLoteCtl+_cSeq)
