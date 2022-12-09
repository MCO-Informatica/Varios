#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � rqg010  			 Ricardo Felipelli   � Data �  13/05/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Corrige tabela se5 com natureza DOC/TEC      DEPOSITO      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Laselva                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function rqg010()
Local _Opcao := .f.

If MsgYesNO("Corrige as contas da natureza (DOC/TED)  ??  ","executa")
	Processa({|| CorrSE5()},"Processando...")
EndIf


Return nil

Static Function CorrSE5()

DbSelectArea("SX5")
Dbsetorder(01)

Dbselectarea("SE5")
dbsetorder(1)
SE5->(dbgotop())
ProcRegua( LastRec() )

_proc:=0
_atual:=0

while SE5->(!eof())
	IncProc( SE5->E5_HISTOR )
	IF SE5->E5_NATUREZ <> 'DOC' .OR. SE5->E5_NATUREZ <> 'TED'
		_proc++
		SE5->(dbskip())
		LOOP
	ENDIF




	_proc++
	_atual++

	SE5->(dbskip())
	
enddo

Alert("Processou: "+str(_proc) + " Atualizou: "+str(_atual))            

return nil
