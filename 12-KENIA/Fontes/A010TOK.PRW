#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????Ŀ??
???Programa  ? A010TOK  ? Autor ? Ricardo Correa de Souza ? Data ? 28/02/2011 ???
???          ?          ?       ?     MVG Consultoria     ?      ?            ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Descricao ? Confirma Alteracao do Cadastro de Produto                      ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Observacao?                                                                ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Uso       ? Kenia Industrias Texteis Ltda                                  ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???             ATUALIZACOES SOFRIDAS DESDE A CONSTRU?AO INICIAL              ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???Programador   ?  Data  ?              Motivo da Alteracao                  ???
?????????????????????????????????????????????????????????????????????????????Ĵ??
???              ?        ?                                                   ???
??????????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????????
*/


User Function A010TOK()

Local _lRet		:= .F.
Local _cProduto :=	M->B1_COD
Local _nQtdBase	:=	0
Local _aArea	:=	GetArea()
Local _nRecSB1	:=	0
                     
_nQtdBase	:=	Round(100/M->B1_CONV,4)
_cComp		:=	IIF(M->B1_TIPO$"TT",SUBS(M->B1_COD,1,3)+"000"+SUBS(M->B1_COD,7),SUBS(M->B1_COD,1,3)+"000")

dbSelectArea("SG1")
dbSetOrder(1)
//If dbSeek(xFilial("SG1")+_cProduto+_cComp,.f.)
If dbSeek(xFilial("SG1")+_cProduto,.f.)
	
	While Eof() == .f. .And. SG1->G1_COD == _cProduto

        
		If Alltrim(_cComp) $ Alltrim(SG1->G1_COMP)
		
			RecLock("SG1",.F.)
			SG1->G1_QUANT	:=	_nQtdBase
			MsUnLock()
	    
	    EndIf
	    
		dbSelectArea("SG1")
		dbSkip()
		
	EndDo
	
	/*
	dbSelectArea("SB1")
	_nRecSb1	:=	Recno()
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+_cComp,.f.)
		RecLock("SB1",.F.)
		SB1->B1_CONV	:=	_nQtdBase
		MsUnLock()
	EndIf
	
	dbSelectArea("SB1")
	dbGoTo(_nRecSB1)
	*/
EndIf

RestArea(_aArea)

Return(_nQtdBase)

