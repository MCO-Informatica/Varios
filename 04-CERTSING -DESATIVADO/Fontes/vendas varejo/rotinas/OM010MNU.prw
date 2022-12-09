#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OM010MNU  � Autor � Renato Ruy         � Data �  02/09/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para incluir opcoes na Tabela de Precos.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function OM010MNU

// Parametros do array aRotina:
// 1. Nome a aparecer no cabecalho
// 2. Nome da Rotina associada   
// 3. Reservado                       
// 4. Tipo de Transa��o a ser efetuada:     1 - Pesquisa e Posiciona em um Banco de Dados     2 - Simplesmente Mostra os Campos                 3 - Inclui registros no Bancos de Dados            4 - Altera o registro corrente                     5 - Remove o registro corrente do Banco de Dados
// 5. N�vel de acesso                                  
// 6. Habilita Menu Funcional

Aadd(aRotina,{ "Exportar CSV","U_CSTA020"		,0,2,0,NIL})
Aadd(aRotina,{ "Importar CSV","U_CSTA030"		,0,2,0,NIL})
               
Return aRotina