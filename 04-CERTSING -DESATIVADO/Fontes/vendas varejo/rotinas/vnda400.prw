/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA400�Autor  �                    � Data �  18/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Consulta Especifica para m�ltiplos tipos de Vouchers serem   ���
���          �selecionados para um usu�rios                               ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VNDA400(l1Elem, lTipoRet)

Local cTitulo := "Tipos de Vouchers"
Local MvPar   := ""
Local MvParDef :=""
Local aTipos := {} 
Local aArea	:= GetArea()
      
lTipoRet := .T.


l1Elem := IF (l1Elem = NIL, .f., .T.)      


DbselectArea("SZH")
SZH->(DbGoTop())
CursorWait()
While SZH->(!Eof())

	IF SZH->(!Deleted())
	
		AADD(aTipos,SZH->ZH_TIPO + "-"+SZH->ZH_DESCRI)
		MvParDef += Left(SZH->ZH_TIPO,1)		 
	
	Endif
	SZH->(DbSkip())

Enddo
CursorArrow()

If lTipoRet  

	f_opcoes(@MvPar,cTitulo,aTipos,MvParDef,Nil,Nil,l1Elem,1,len(aTipos))
	
Endif 

MvPar := StrTran(MvPar,'*','')

RestArea(aArea)  

Return MvPar
		


