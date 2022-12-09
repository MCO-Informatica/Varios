/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CTARCIMP �Autor  � S�rgio Santana     � Data � 18/05/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza��o registro do conta a receber (GESTOQ/BV)        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Glastech                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTARCIMP()

Processa( { || AtualSE1() }, 'Atualizando Contas a Receber' )

Return()

Static Function AtualSE1()
	
ProcRegua( 3 )

IncProc('Importando T�tulos GESTOQ...')
U_CTARCGSTQ('  ', DtoS( dDataBase ), DtoS( dDataBase ), ' ', .F. )

IncProc('Importando T�tulos BV...')
U_CTARCGSTQ('BV', DtoS( dDataBase ), DtoS( dDataBase ), ' ', .F. )

IncProc('Finalizado!')

Return()