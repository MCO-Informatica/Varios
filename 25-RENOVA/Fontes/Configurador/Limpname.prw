#include "Protheus.ch"

/*/
���������������������������������������������������������������������
���������������������������������������������������������������������
������������������������������������������������������������������Ŀ�
��Fun��o    � Limpname � Autor �Rafael Alencar   � Data � ��
������������������������������������������������������������������Ĵ�
��Descri��o �        ��
������������������������������������������������������������������Ĵ�
��Uso       � Renova Energia                                       ��
������������������������������������������������������������������Ĵ�
���������������������������������������������������������������������
/*/


User Function Limpname()
Local lRet     := .T.
Local cReadVar := ReadVar()
Local cVar     := ""
Local nLoop    := Nil

If ! Empty(cReadVar)
	cVar := &(cReadVar)
	For nLoop := 1 to Len(cVar)
		If Substr(cVar, nLoop, 1) $ "������������������������������������.'~-/\,�`��!@#$%�&*()+=�������"
			lRet := .F.
			Exit
		Endif
	Next
	If ! lRet
		Aviso("A T E N � � O", "N�o � permitido inseir caracteres especiais!!!",{"OK"})
	Endif
Endif

Return (lRet)