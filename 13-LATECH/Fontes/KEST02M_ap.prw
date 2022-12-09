#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 01/08/05

User Function KEST02M()        // incluido pelo assistente de conversao do AP6 IDE em 01/08/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,AREGS,I,J,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KEST02M  � Autor �Ricardo Correa de Souza� Data �20/10/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Zera Arquivo de Lotes no Inventario				          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Kenia Industrias Texteis Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ���
�������������������������������������������������������������������������Ĵ��
���   Analista   �  Data  �             Motivo da Alteracao               ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")         //----> Cadastro de Produtos
DbSetOrder(1)               //----> Produto

DbSelectArea("SB2")         //----> Saldos em Estoque
DbSetOrder(1)               //----> Produto

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg := "ESTM02    "

ValidPerg()

If !Pergunte(cPerg,.t.)
	Return
EndIf

Processa({||RunProc()},"Processa Invent�rio Fios")// Substituido pelo assistente de conversao do AP6 IDE em 01/08/05 ==> Processa({||Execute(RunProc)},"Ajusta Lotes")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 01/08/05 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()

ProcRegua(RecCount())

While !Eof()
	
	IncProc("Selecionando Produto "+SB2->B2_COD)
	
	If SB1->B1_TIPO <> MV_PAR03
		dbSkip()
		Loop
	EndIf
	
	
	DbSelectArea("SB2")
	DbSetOrder(1)
	If dbSeek(xFilial("SB2")+SB1->B1_COD,.F.)
		
		
		While !Eof() .and. SB2->B2_COD == SB1->B1_COD
			
			DbSelectArea("SB7")
			RecLock("SB7",.t.)
			SB7->B7_FILIAL  :=  XFILIAL("SB7")
			SB7->B7_COD     :=  SB2->B2_COD
			SB7->B7_LOCAL   :=  SB2->B2_LOCAL
			SB7->B7_TIPO    :=  SB1->B1_TIPO
			SB7->B7_DOC     :=  MV_PAR05
			SB7->B7_QUANT   :=  0
			SB7->B7_DATA    :=  dDataBase
			MsUnLock()
			
			dbSelectArea("SB2")
			dbSkip()
		EndDo
	EndIf
	
	DbSelectArea("SB1")
	DbSkip()
	
	
EndDo

// Substituido pelo assistente de conversao do AP6 IDE em 01/08/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 01/08/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 01/08/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
	
	aRegs := {}
	
	aadd(aRegs,{cPerg,'01','Do Produto     ? ','mv_ch1','C',15, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SB1'})
	aadd(aRegs,{cPerg,'02','Ate o Produto  ? ','mv_ch2','C',15, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SB1'})
	aadd(aRegs,{cPerg,'03','Documento      ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','','   '})
	
	For i:=1 to Len(aRegs)
		Dbseek(cPerg+StrZero(i,2))
		If found() == .f.
			RecLock("SX1",.t.)
			For j:=1 to Fcount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnLock()
		EndIf
	Next
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 01/08/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 01/08/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

