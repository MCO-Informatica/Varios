#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfat11m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CNATUREZA,LSAIR,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KFAT11M  � Autor �                       � Data �23/03/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Grava a Natureza Financeira na Nota Fiscal de Saida        ���
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
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cNatureza := "0000"

If SF2->F2_TIPO $ "D"

    cNatureza := space(10)
    lSair     := .F.  

    While .t.

        @ 025,005 To 400,600 Dialog janela1 Title OemToAnsi("Natureza Financeira Nota Fiscal Devolucao de Compras")

        @ 050,010 Say OemToAnsi("Natureza") Size 37,8
    
        @ 060,010 Get cNatureza Picture "@!" F3 "SED"        
	
        @ 165,220 BmpButton Type 1 Action GravaNat()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>         @ 165,220 BmpButton Type 1 Action Execute(GravaNat)

        Activate Dialog janela1
    
        If lSair
            Exit
        EndIf
    EndDo

//    MarkBRefresh()

EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(cNatureza)
Return(cNatureza)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function GravaNat
Static Function GravaNat()

lSair := .T.

Close(janela1)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao GravaNat                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

