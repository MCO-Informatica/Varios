#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LP510    � Autor � JUNIOR CARVALHO    � Data �  25/08/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � LP 510 -                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico MAKENI                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LP510(_cseq)

	Local _aArea  := GetArea()
	Local _nValor := 0

	If _cseq == '001'

		IF 	( ALLTRIM(SE2->E2_FATURA)<>'NOTFAT' .AND. !ALLTRIM(SE2->E2_PREFIXO)$'GPE/EIC';
		.AND. !ALLTRIM(SE2->E2_TIPO)$'PR/PRE/FOL/RES/ADI/FER/131/132/IMP' ;
		.AND. !ALLTRIM(SE2->E2_NATUREZ)$'218012/218015/218016' ;
		.AND. !( ALLTRIM(SE2->E2_PREFIXO)=='EIC' .AND. ALLTRIM(SE2->E2_FORNECE) == 'UNIAO' ) )

			_nValor := SE2->E2_VALOR
		Else
			_nValor := 0
		Endif
	Endif

	If _cseq == '002'

		IF ( ALLTRIM(SE2->E2_FATURA)<>'NOTFAT' .AND. !SE2->E2_PREFIXO$'GPE/EIC' ;
		.AND. !ALLTRIM(SE2->E2_TIPO)$'PR/PRE/FOL/RES/ADI/FER/131/132/IMP';
		.AND. !ALLTRIM(SE2->E2_NATUREZ)$'218018/218015/218016' ;
		.AND. !( ALLTRIM(SE2->E2_PREFIXO)=='EIC' .AND. ALLTRIM(SE2->E2_FORNECE) == 'UNIAO' ) )

			_nValor := SE2->( E2_VALOR - E2_INSS - E2_IRRF - E2_ISS)
		Else
			_nValor := 0
		Endif
	Endif


	RestArea(_aArea)

Return(_nValor)