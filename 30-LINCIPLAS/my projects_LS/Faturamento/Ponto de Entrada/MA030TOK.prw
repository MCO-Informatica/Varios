#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER CHR(13)+CHR(10)

/*/
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  |  MA030TOK      � Autor � Fabiano Pereira    � Data �  05/02/09   ���
�������������������������������������������������������������������������������͹��
���Descricao � PE   Na fun��o que verifica se os campos s�o v�lidos.	        ���
���          � Validar a digita��o dos dados do Cliente na inclus�o e altera��o ���
���          � Retorno Esperado:     .T. ou .F.  								���
�������������������������������������������������������������������������������͹��
���Uso       � Frigorifico MercoSul - AP8                               	    ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
/*/                                                                               


*************************************************************************
User Function MA030TOK() 
*************************************************************************
Local _lRet := .T.

If M->A1_TIPO <> 'X' .And. Empty(M->A1_CGC) .AND. M->A1_COD <> '999999'
	_lRet	:=	.F.                    
	MsgBox('Preenchimeto do CNPJ � obrigat�rio !!!','Alert')
Endif

If _lRet .and. M->A1_TIPO <> 'X' .And. Empty(M->A1_INSCR)
	_lRet	:=	.F.                    
	MsgBox('Preenchimeto do Inscri��o Estadual � obrigat�rio !!!','Alert')
Endif

If _lRet .and. M->A1_TIPO <> 'X' .And. Empty(M->A1_CEP)
	_lRet	:=	.F.                    
	MsgBox('Preenchimeto do CEP � obrigat�rio !!!','Alert')
Endif


Return(_lRet)