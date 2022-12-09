#include 'Protheus.ch'
#include 'MsgOpManual.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTVALPED  �Autor  �Bruno Daniel Abrigo � Data �  10/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Permite validar alteracao nos campos Lacre e Qtd           ���
���          � Se for alterar, bloqueia                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTValPed(nOpc)
Local nPosLacre := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XLACRE" })
Local nPosQtd   := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
Local nPosxEmb  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_XEMBALA" })
Local nPosxOP   := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_NUMOP" })

Local lRet	    :=.T.
Local _lOk 		:=ALTERA
      /*
If Type('_lCopy') # 'U'
	If _lCopy
		_lOk:=_lCopy
	Endif
Endif


If nOpc == 1
	If INCLUI .and. !aCols[n,Len(aHeader)+1] .and. !Empty(aCols[n,nPosLacre])
		ExistCpo("Z02",""+Alltrim(M->C6_XLACRE)+M->C5_CLIENTE,2)
		IF &(ReadVar()) # aCols[n,nPosLacre]
			MsgStop(STR0007 + STR0008,STR0009) ;&(ReadVar()):=aCols[n,nPosLacre];	lRet:=.F.;	Return(lRet)
		Endif
		
	ElseIf (ALTERA .OR. _lOk ).and. !Empty(aCols[n,nPosLacre]) .and. !aCols[n,Len(aHeader)+1]
		IF &(ReadVar()) # aCols[n,nPosLacre]
			MsgStop(STR0007 + STR0008,STR0009) ;&(ReadVar()):=aCols[n,nPosLacre];	lRet:=.F.;	Return(lRet)
		Endif
	Endif
Elseif nOpc == 2
	If (ALTERA .OR. _lOk) .and. aCols[n,nPosQtd]>0 .and. !aCols[n,Len(aHeader)+1] .and. !Empty(aCols[n,nPosLacre])
		IF &(ReadVar()) # aCols[n,nPosQtd]
			MsgStop(STR0007 + STR0008,STR0010) ;&(ReadVar()):=aCols[n,nPosQtd];	lRet:=.F.;	Return(lRet)
		Endif
	Endif
Else
	If (ALTERA .OR. _lOk) .and. !aCols[n,Len(aHeader)+1] .and. !Empty(aCols[n,nPosxOP])
		IF &(ReadVar()) # aCols[n,nPosxEmb]
			MsgStop(STR0007 + STR0008,STR0010) ;&(ReadVar()):=aCols[n,nPosxEmb];	lRet:=.F.;	Return(lRet)
		Endif
	Endif
	
Endif
        */
Return(lRet)