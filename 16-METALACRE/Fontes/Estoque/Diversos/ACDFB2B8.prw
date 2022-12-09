#include "topconn.ch"      
#include "protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ACDFB2B8 �Autor �Renato S. Parreira � Data � 01/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acerto das diferen�as SB2 e SB8.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ACDFB2B8()                                    

Local cTitulo := "Aguarde o calculo dos Estoques"

MsgInfo("� recomend�vel executar a rotina de Saldo Atual antes das corre��es!","Aviso")

if !msgyesno("Deseja Continuar?","Dif. B2 B8")
     Return .T.
endif

RptStatus({|lEnd| ExibeDif()},ctitulo)

Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ExibeDif �Autor �Renato S. Parreira � Data � 01/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa as diferencas e exibe em tela                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ExibeDif()

//��������������������������������������������������������������Ŀ
//�Variaveis utilizadas na query de verifica��o de dif. SB2 e SB8�
//����������������������������������������������������������������

Local cQuery := ""

Local cFilSB2 := xFilial("SB2")
Local cFilSB8 := xFilial("SB8")
Local cFilSB1 := xFilial("SB1")

Local cArqSB2 := RetSqlName("SB2")
Local cArqSB8 := RetSqlName("SB8")
Local cArqSB1 := RetSqlName("SB1")                               

//�������������������������������������������������������Ŀ
//�Vari�veis utilizadas na tela de exibi��o das diferen�as�
//���������������������������������������������������������

Local oBtnCancel
Local cTitulo := "Diferen�as SB2 x SB8"
Local bCancel := {|| oDlg:End(), WORK1->(dbclosearea())} 
Private nTotal := 0

Private aCampos := {}
Private oDlg                             
Private oMark                         

//�������������������������������������������Ŀ
//�Variaveis utilizadas no arquivo de trabalho�
//���������������������������������������������

Private aStruct := {} 
Private cArqTrab := ""
                            
IncProc(OemToANSI("Pesquisando Registros..."))

//���������������������������������������������������������������������P�
//�Cria arquivo de trabalho para armazenar resultado da query validado.�
//���������������������������������������������������������������������P�

Aadd(aStruct, {"PRODUTO","C",AVSX3("B1_COD",3),0})
Aadd(aStruct, {"QLOCAL" ,"C",AVSX3("B2_LOCAL",3),0})     
Aadd(aStruct, {"QATU" ,"N",AVSX3("B2_QATU",3),2})                                                               
Aadd(aStruct, {"SALDO" ,"N",AVSX3("B8_SALDO",3),2})                                                               
Aadd(aStruct, {"RESULTADO" ,"N",AVSX3("B2_QATU",3),2})                                                               

cArqTrab := CriaTrab(aStruct)

dbUseArea(.T.,,cArqTrab,"WORK1",.T.,.F.)

//����������������������������������������������������Ŀ
//�Faz a Query de Verifica��o de produtos com diferen�a�
//������������������������������������������������������

cQuery := ""

cQuery += "SELECT " + cArqSB8 + ".B8_PRODUTO AS PRODUTO, "
cQuery += cArqSB8 + ".B8_LOCAL AS QLOCAL, "
cQuery += "ROUND(" + cArqSB2 + ".B2_QATU,2) AS QATU, "
cQuery += "ROUND(SUM(" + cArqSB8 + ".B8_SALDO),2) AS SALDO, " 
cQuery += "ROUND(SUM(" + cArqSB8 + ".B8_SALDO),2) - ROUND(" + cArqSB2 + ".B2_QATU,2) AS RESULTADO "
cQuery += "FROM " + cArqSB8 + " " 
cQuery += "INNER JOIN " + cArqSB2 + " ON " + cArqSB8 + ".B8_PRODUTO = " + cArqSB2 + ".B2_COD "
cQuery += "AND " + cArqSB8 + ".B8_LOCAL = " + cArqSB2 + ".B2_LOCAL "
cQuery += "GROUP BY " + cArqSB8 + ".B8_PRODUTO, "
cQuery += cArqSB8 + ".B8_LOCAL, "
cQuery += cArqSB8 + ".D_E_L_E_T_, "
cQuery += cArqSB2 + ".D_E_L_E_T_, "
cQuery += cArqSB2 + ".B2_COD, "
cQuery += cArqSB2 + ".B2_LOCAL, "
cQuery += cArqSB2 + ".B2_QATU, " 
cQuery += cArqSB2 + ".B2_FILIAL, "
cQuery += cArqSB8 + ".B8_FILIAL "
cQuery += "HAVING (" + cArqSB8 + ".D_E_L_E_T_ <> '*') AND (" + cArqSB2 + ".D_E_L_E_T_ <> '*') "
cQuery += "AND (ROUND(SUM(" + cArqSB8 + ".B8_SALDO),2) <> ROUND(" + cArqSB2 + ".B2_QATU,2)) "
cQuery += "AND " + cArqSB2 + ".B2_FILIAL = '" + cFilSB2 + "' "
cQuery += "AND " + cArqSB8 + ".B8_FILIAL = '" + cFilSB8 + "' "
cQuery += "ORDER BY " + cArqSB8 + ".B8_PRODUTO, " + cArqSB8 + ".B8_LOCAL "

cQuery := ChangeQuery(cQuery)

//��������������������������Ŀ
//�Cria o arquivo de trabalho�
//����������������������������

TcQuery cQuery Alias "TRB1" New

TRB1->(DBGOTOP())
                                    
IncProc(OemToANSI("Atualizando Arquivo de Diferen�as..."))

//���������������������������������������������������������D�
//�Faz a verifica��o se o produto utiliza controle por lote�
//���������������������������������������������������������D�

While TRB1->(!EOF())
	If TRB1->PRODUTO <> 'LM19ZP' .And. TRB1->QLOCAL <> 'EX'
		TRB1->(dbSkip(1));Loop
	Endif


     If SB1->(DBSEEK(cFilSB1 + TRB1->PRODUTO))          
          //�����������������������������������������������������������������������������X�
          //�Caso B1_RASTRO = N, nao controla lotes. Entao elimina do arquivo de trabalho�
          //�����������������������������������������������������������������������������X�
          IF SB1->B1_RASTRO <> "N" 
               IF RECLOCK("WORK1",.T.)
                 WORK1->PRODUTO := TRB1->PRODUTO
                 WORK1->QLOCAL   := TRB1->QLOCAL
                 WORK1->QATU     := TRB1->QATU
                 WORK1->SALDO    := TRB1->SALDO
                 WORK1->RESULTADO:= TRB1->RESULTADO                    
                    WORK1->(MSUNLOCK())
                    WORK1->(DBCOMMIT())
                    nTotal++
               ENDIF
          ENDIF
     endif
     TRB1->(DBSKIP())
Enddo                             

TRB1->(DBCLOSEAREA())

//�������������������������������������������������Ŀ
//�Campos que ser�o exibidos na tela (Array aCampos)�
//���������������������������������������������������

Aadd(aCampos, {"PRODUTO" ,,"Cod. Produto"})     
Aadd(aCampos, {"QLOCAL" ,,"Armaz�m"})                                                               
Aadd(aCampos, {"QATU" ,,"Saldo Atual (SB2)"})     
Aadd(aCampos, {"SALDO" ,,"Total Saldo lote (SB8)"})     
Aadd(aCampos, {"RESULTADO" ,,"Diferen�a"})     

//�������������������������������̿
//�Exibe a tela com as diferen�as�
//���������������������������������

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 9,0 TO 28,80 OF oMainWnd
     @ 9,01 SAY "Selecione o item e pressione o Bot�o Corrigir:" SIZE 232,10 PIXEL OF oDlg
     DBSELECTAREA("WORK1")                                           
     WORK1->(DBGOTOP())
     oMark := MsSelect():New("WORK1",,,aCampos,,,{18,3,125,312})   
    DEFINE SBUTTON oBtnCancel FROM 130,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg
     @130,001 SAY "Total de Itens:" SIZE 232,10 PIXEL OF oDlg
     @130,50 SAY nTotal picture "@! 9999999" SIZE 232,10 PIXEL OF oDlg
    @130,100 button "Corrigir" SIZE 34,13 ACTION ExibeLotes() OF oDlg PIXEL 
ACTIVATE MSDIALOG oDlg CENTERED

if select("WORK1") <> 0
     WORK1->(DBCLOSEAREA())
ENDIF


Return .T.                  



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �EXIBELOTES�Autor �Renato S. Parreira � Data � 01/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �EXIBE OS LOTES DISPONIVEIS PARA EFETUAR O ACERTO            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function ExibeLotes()                                  

//��������������������������������������������������������������Ŀ
//�Variaveis utilizadas na query de verifica��o de dif. SB2 e SB8�
//����������������������������������������������������������������

Local cQuery := ""

Local cFilSB2 := xFilial("SB2")
Local cFilSB8 := xFilial("SB8")
Local cFilSB1 := xFilial("SB1")

Local cArqSB2 := RetSqlName("SB2")
Local cArqSB8 := RetSqlName("SB8")
Local cArqSB1 := RetSqlName("SB1")                               

Local cArqTrab1 := ""
Local lExibeZero := .F.

//�������������������������������������������������������Ŀ
//�Vari�veis utilizadas na tela de exibi��o das diferen�as�
//���������������������������������������������������������

Local oBtnCancel
Local cTitulo := "Acerto de Lotes"
Local bCancel := {|| oDlgLotes:End(), WORK2->(dbclosearea())} 

Private nTotalLote := 0   
Private nTotalDif := WORK1->QATU - ntotalLote
Private aCampos1 := {}
Private oDlgLotes                             
Private oMarkLotes                                        

IF WORK1->QATU < 0
     MSGSTOP("Favor regularizar Saldo Negativo no SB2 para prosseguir!","Aviso")
     Return .T.
ENDIF

//�������������������������������������������������<�
//�Cria arquivo de Trabalho para armazenar os lotes�
//�������������������������������������������������<�

aStruct := {}

Aadd(aStruct, {"LOTECTL","C",AVSX3("B8_LOTECTL",3),0})
Aadd(aStruct, {"NUMLOTE" ,"C",AVSX3("B8_NUMLOTE",3),0})     
Aadd(aStruct, {"QLOCAL" ,"C",AVSX3("B8_LOCAL",3),0})     
Aadd(aStruct, {"SALDO" ,"N",AVSX3("B8_SALDO",3),2})     

cArqTrab1 := CriaTrab(aStruct)

dbUseArea(.T.,,cArqTrab1,"WORK2",.T.,.F.)                    

//��������������������������������pX�0NZ�
//�Pergunta se exibe lotes zerados�
//��������������������������������pX�0NZ�

lExibeZero := msgyesno("Exibe Lotes com Saldos Zerados?","Saldos Por lote")
     
//�������������������������������������������������������������������Ŀ
//�Cria query para consulta aos Lotes do produto selecionado na Work1.�
//���������������������������������������������������������������������

cQuery := ""
cQuery += "SELECT " + cArqSB8 + ".B8_LOTECTL, "
cQuery += cArqSB8 + ".B8_NUMLOTE, "        
cQuery += cArqSB8 + ".B8_LOCAL, "        
cQuery += cArqSB8 + ".B8_SALDO "        
cQuery += "FROM " + cArqSB8 + " "
cQuery += "WHERE " + cArqSB8 + ".B8_PRODUTO = '" + WORK1->PRODUTO + "' "
cQuery += "AND " + cArqSB8 + ".B8_LOCAL = '" + WORK1->QLOCAL + "' "

//�������������������������������������0�
//�Filtra se exibe lotes zerados ou n�o�
//�������������������������������������0�

if !lExibeZero
     cQuery += "AND " + cArqSB8 + ".B8_SALDO <> 0 "
endif

cQuery += "AND " + cArqSB8 + ".D_E_L_E_T_ <> '*' "

TcQuery cQuery ALIAS "TRB1" NEW

TRB1->(DBGOTOP())

WHILE TRB1->(!EOF())      
     //���������������������������������������������������������Ŀ
     //�Alimenta Work2 com dados da Query para exibi��o em browse�
     //�����������������������������������������������������������
     IF RECLOCK("WORK2",.T.)
          WORK2->LOTECTL := TRB1->B8_LOTECTL
          WORK2->NUMLOTE := TRB1->B8_NUMLOTE
          WORK2->QLOCAL := TRB1->B8_LOCAL
          WORK2->SALDO   := TRB1->B8_SALDO
          ntotallote := ntotallote + TRB1->B8_SALDO
          WORK2->(MSUNLOCK())
          WORK2->(DBCOMMIT())
     ENDIF
     TRB1->(DBSKIP())
ENDDO                                        

nTotalDif := WORK1->QATU - ntotalLote
                    
TRB1->(DBCLOSEAREA())

WORK2->(DBGOTOP())

//�������������������������������������������������Ŀ
//�Campos que ser�o exibidos na tela (Array aCampos)�
//���������������������������������������������������

Aadd(aCampos1, {"LOTECTL" ,,"Lote"})     
Aadd(aCampos1, {"NUMLOTE" ,,"Sub-Lote"})                                                               
Aadd(aCampos1, {"QLOCAL" ,,"Armaz�m"})     
Aadd(aCampos1, {"SALDO" ,,"Saldo do Lote"})     



//�������������������������������̿
//�Exibe a tela com as diferen�as�
//���������������������������������

DEFINE MSDIALOG oDlgLotes TITLE cTitulo FROM 9,0 TO 31,95 OF oMainWnd
     @010,005 SAY "Cod. Produto: " + WORK1->PRODUTO PIXEL OF oDlgLotes      
     @030,005 SAY "Desc. Produto: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_DESC") PIXEL OF oDlgLotes
     @050,005 SAY "Tipo: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_TIPO") SIZE 232,10 PIXEL OF oDlgLotes
     @050,050 SAY "Armaz�m: " + WORK1->QLOCAL PIXEL OF oDlgLotes                                    
     @050,100 SAY "Unid. Medida: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_UM") SIZE 232,10 PIXEL OF oDlgLotes      
        @070,005 SAY "Total Quantidade SB2 (Saldo Atual): " PIXEL OF oDlgLotes
        @070,150 SAY WORK1->QATU picture "@! 999,999,999.99" PIXEL OF oDlgLotes
        @090,005 SAY "Total Quantidade dos Lotes SB8 (Saldo por Lote): " PIXEL OF oDlgLotes
     @090,150 SAY nTotalLote picture "@! 999,999,999.99" PIXEL OF oDlgLotes                       
     @110,005 SAY "Diferen�a Total (Total SB2 - Total SB8): " PIXEL OF oDlgLotes
     @110,150 SAY nTotalDif picture "@! 999,999,999.99" PIXEL OF oDlgLotes
     DBSELECTAREA("WORK2")                                           
     WORK2->(DBGOTOP())
     oMark := MsSelect():New("WORK2",,,aCampos1,,,{9,185,145,370})   
    DEFINE SBUTTON oBtnCancel FROM 150,340 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlgLotes
    @130,005 button "Modificar Lote" SIZE 68,26 ACTION ModifLotes() OF oDlgLotes PIXEL 
    @130,100 button "Proc. Altera��es" SIZE 68,26 ACTION ProcessaAlt() OF oDlgLotes PIXEL 
ACTIVATE MSDIALOG oDlgLotes CENTERED 

if select("WORK2") <> 0
     WORK2->(DBCLOSEAREA())
ENDIF

Return .T.                                    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ModifLotes�Autor �Renato S. Parreira � Data � 01/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Modifica saldos dos lotes na Work2 para posterior atualiza- ���
���          ���o                                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ModifLotes()

//�������������������������������������������������������Ŀ
//�Vari�veis utilizadas na tela de exibi��o do lote       �
//���������������������������������������������������������

Local oBtnCancel
Local oBtnOk
Local cTitulo := "Acerto do Lote " + WORK2->LOTECTL + " - " + WORK2->NUMLOTE
Local nOpc    := 0
Local bCancel := {|| oDlgAcLote:End(), nOpc := 0} 
Local bOk     := {|| oDlgAcLote:End(), nOpc := 1} 
Local nQatu   := WORK2->SALDO
Local nQnova := WORK2->SALDO 
Local cFilSB1 := xFilial("SB1")

Private oDlgAcLote
Private nBkpTotLote := nTotalLote
Private nBkpTotDif := nTotalDif

//�����������������������������������������4�
//�Exibe a tela para acertos das diferen�as�
//�����������������������������������������4�

DEFINE MSDIALOG oDlgAcLote TITLE cTitulo FROM 9,0 TO 33,40 OF oMainWnd
     @010,005 SAY "Cod. Produto: " + WORK1->PRODUTO PIXEL OF oDlgAcLote
     @030,005 SAY "Desc. Produto: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_DESC") PIXEL OF oDlgAcLote
     @050,005 SAY "Tipo: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_TIPO") SIZE 232,10 PIXEL OF oDlgAcLote
     @050,050 SAY "Armaz�m: " + WORK1->QLOCAL PIXEL OF oDlgAcLote
     @070,005 SAY "Lote: " + WORK2->LOTECTL PIXEL OF oDlgAcLote
     @070,100 SAY "Sub-Lote: " + WORK2->NUMLOTE PIXEL OF oDlgAcLote
     @090,005 SAY "Quantidade Atual do Lote: " PIXEL OF oDlgAcLote
     @090,080 Get nQatu SIZE 70,10 PICTURE "@! 999,999,999.99" When .F. PIXEL OF oDlgAcLote
     @110,005 SAY "Quantidade a ser Aplicada: " PIXEL OF oDlgAcLote
     @110,080 Get nQNova SIZE 70,10 PICTURE "@! 999,999,999.99" When .T. valid(ValidaQtd(nQnova,nQatu)) PIXEL OF oDlgAcLote
     @130,005 SAY "Soma dos Lotes: " PIXEL OF oDlgAcLote
     @130,080 Get nBkpTotLote SIZE 70,10 PICTURE "@! 999,999,999.99" When .F. PIXEL OF oDlgAcLote
     @150,005 SAY "Diferen�a: " PIXEL OF oDlgAcLote
     @150,080 Get nBkpTotDif SIZE 70,10 PICTURE "@! 999,999,999.99" When .F. PIXEL OF oDlgAcLote
    DEFINE SBUTTON oBtnOk FROM 170,100 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlgAclote
    DEFINE SBUTTON oBtnCancel FROM 170,130 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlgAclote
ACTIVATE MSDIALOG oDlgAclote CENTERED           


//���������������������������������������������������������������Ŀ
//�Se clicou em Ok, processa atualiza��o dos arquivos tempor�rios.�
//�����������������������������������������������������������������
                                                        
if nOpc == 1 .and. nQnova <> nQatu                             
     //���������������������������������������Ŀ
     //�Grava saldo atualizado do lote na Work2�
     //�����������������������������������������
     IF RECLOCK("WORK2",.F.)          
          //�����������������������������������������������Ŀ
          //�Atualiza as vari�veis de c�lculo das diferen�as�
          //�������������������������������������������������
          if nQnova > nQatu    
               nTotalLote := nTotalLote + (nQnova - nQatu)
          elseif nQnova < nQatu
               nTotalLote := nTotalLote - (nQatu - nQnova)     
          endif                               
          nTotalDif := WORK1->QATU - nTotalLote 
          WORK2->SALDO := nQnova
          WORK2->(MSUNLOCK())
          WORK2->(DBCOMMIT())          
     ENDIF     
endif

Return .T.     


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ValidaQtd �Autor �Renato S. Parreira � Data � 01/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida a Quantidade digitada na tela de acerto de lotes.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidaQtd(nValor,nValor2)                      

Local lRetorno := .T.

//�����������������������������������Ŀ
//�Valor do lote n�o pode ser negativo�
//�������������������������������������

if(nValor < 0, lRetorno := .F., lRetorno := .T.)

//�������������������������������������������������������
//�Caso valor Ok, atualiza as vari�veis de calculo�
//�������������������������������������������������������

if !lRetorno
     msgstop("Quantidade n�o pode ser negativa!","Aviso")
else          
     //���������������������������������,�
     //�Atualiza as vari�veis de calculo�
     //���������������������������������,�
     if nValor > nValor2    
          nBkpTotLote := nTotalLote + (nValor - nValor2)
     elseif nValor < nValor2
          nBkpTotLote := nTotalLote - (nValor2 - nValor)     
     endif                      
     nBkpTotDif := WORK1->QATU - nBkpTotLote 
endif
     
Return(lRetorno)              


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ProcessaAltAutor �Renato S. Parreira � Data � 01/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Compara a Work2 com Saldos no SB8 e realiza os movimentos   ���
���          �de acerto no SD5                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcessaAlt()

Local lAchouB8 := .T.
Local lSaldoNeg := .T.
Local nTotWork2 := 0

Private cMovDev := "201"
Private cMovReq := "501"

SB8->(DBSETORDER(2))

//������������������������������������������������������������������������������Ŀ
//�Verifica e Valida se Todos os Lotes existem no SB8 e se h� Quantidade negativa�
//��������������������������������������������������������������������������������
WORK2->(DBGOTOP())

WHILE WORK2->(!EOF())     
     //��������������������������������������������������������������Ŀ
     //�Verifica se existe saldo negativo. Se sim, para processamento.�
     //����������������������������������������������������������������
     if WORK2->SALDO < 0
          lSaldoNeg := .F.
     else
          nTotWork2 := nTotWork2 + WORK2->SALDO
     endif
     //���������������������������������������Ŀ
     //�Procura o Lote no SB8 para verifica��es�
     //�����������������������������������������     
     IF !SB8->(DBSEEK(xFilial("SB8") + WORK2->NUMLOTE + WORK2->LOTECTL + WORK1->PRODUTO + WORK2->QLOCAL))
          lAchouB8 := .F. //Se n�o Achou qualque dos lotes, n�o executa o processamento
     endif                   
     WORK2->(DBSKIP())
ENDDO                                                                     


WORK2->(DBGOTOP())

//�����������������������������������������������Ŀ
//�Caso existam Negativos nos Lotes, Aborta Fun��o�
//�������������������������������������������������
If !lSaldoNeg
     MsgAlert("Aten��o! Existem Saldo(s) Negativo(s) no(s) Lote(s)! Favor Corrigir!","Aviso")
     Return .T.
endif                                                                                       

//����������������������������������������������Ŀ
//�Caso n�o ache algum lote no SB8, Aborta Fun��o�
//������������������������������������������������
if !lAchouB8
     MsgStop("Aten��o! Lote n�o encontrado no SB8! Contate o Administrador!","Erro")
     Return .T.
endif           

//�������������������������������������������������������������H�
//�Caso ainda Existam diferen�as entre os saldos, Aborta Fun��o�
//�������������������������������������������������������������H�
if nTotWork2 <> WORK1->QATU
     MsgAlert("Aten��o! Existem Diferen�as entre Saldo Atual e Saldos Por Lote! Favor Corrigir!","Aten��o")
     Return .T.
endif             

//�������������������������������Ŀ
//�Valida o Movimento de Devolu��o�
//���������������������������������

IF SF5->(DBSEEK(xFilial("SF5") + cMovDev))
     if Val(cMovDev) > 500
          msgStop("Codigo do Movimento de Dev. N�o pode ser maior que 500! Contate o Administrador!","Aviso")
          Return .T.
     endif
     if SF5->F5_TIPO <> "D"
          msgstop("Tipo do Movimento de Dev. est� incorreto! Contate o Administrador!","Aviso")
          Return .T.
     endif
     if SF5->F5_TRANMOD == "S"
          msgstop("Movimento de Dev. N�o deve movimentar MOD! Contate o Administrador","Aviso")
          Return .T.
     endif        
     if SF5->F5_ENVCQPR == "S"
          msgstop("Movimento de Dev. N�o deve utilizar o CQ! Contate o Administrador!","Aviso")
          Return .T.
     endif        
     if SF5->F5_LIBPVPR == "S"
          msgstop("Movimento de Dev. N�o deve Liberar PV! Contate o Administrador!","Aviso")
          Return .T.
     endif
else 
     msgStop("Movimento de Devolu��o cadastrado no Parametro MV_DFB2B8D n�o encontrado! Contate o Administrador!","Aviso")
     Return .T.
endif


//��������������������������������Ŀ
//�Valida o Movimento de Requisi��o�
//����������������������������������
IF SF5->(DBSEEK(xFilial("SF5") + cMovReq))
     if Val(cMovReq) <= 500
          msgStop("Codigo do Movimento de Req. N�o pode ser menor que 500! Contate o Administrador!","Aviso")
          Return .T.
     endif
     if SF5->F5_TIPO <> "R"
          msgstop("Tipo do Movimento de Req. est� incorreto! Contate o Administrador!","Aviso")
          Return .T.
     endif
     if SF5->F5_TRANMOD == "S"
          msgstop("Movimento de Req. N�o deve movimentar MOD! Contate o Administrador","Aviso")
          Return .T.
     endif        
     if SF5->F5_ENVCQPR == "S"
          msgstop("Movimento de Req. N�o deve utilizar o CQ! Contate o Administrador!","Aviso")
          Return .T.
     endif        
     if SF5->F5_LIBPVPR == "S"
          msgstop("Movimento de Req. N�o deve Liberar PV! Contate o Administrador!","Aviso")
          Return .T.
     endif
else 
     msgStop("Movimento de Requisi��o cadastrado no Parametro MV_DFB2B8R n�o encontrado! Contate o Administrador!","Aviso")
     Return .T.
endif

//���������������������������������������������������������������������������������Ŀ
//�Caso tenha chegado aqui, est� ok. Prossegue com a atualiza��o dos Saldos Por Lote�
//�����������������������������������������������������������������������������������

WORK2->(DBGOTOP())
WHILE WORK2->(!EOF())
     //�������������������������������������Ŀ
     //�Posiciona no Lote SB8 para compara��o�
     //���������������������������������������     
     SB8->(DBSEEK(xFilial("SB8") + WORK2->NUMLOTE + WORK2->LOTECTL + WORK1->PRODUTO + WORK2->QLOCAL))
     IF WORK2->SALDO > SB8->B8_SALDO          
          //���������������������������������������������������������������������������Ŀ
          //�Chama fun��o que atualiza o SD5. Caso atualiza��o OK, Atualiza Saldo no SB8�
          //�����������������������������������������������������������������������������
          Begin Transaction
               if CriaMovD5(1)
                    IF RECLOCK("SB8",.F.)
                         SB8->B8_SALDO := WORK2->SALDO
                         SB8->(MSUNLOCK())
                         SB8->(DBCOMMIT())
                    ENDIF             
               endif            
          End Transaction
     ELSEIF WORK2->SALDO < SB8->B8_SALDO
          //���������������������������������������������������������������������������Ŀ
          //�Chama fun��o que atualiza o SD5. Caso atualiza��o OK, Atualiza Saldo no SB8�
          //�����������������������������������������������������������������������������
          Begin Transaction
               if CriaMovD5(2)                   
                    IF RECLOCK("SB8",.F.)
                         SB8->B8_SALDO := WORK2->SALDO
                         SB8->(MSUNLOCK())
                         SB8->(DBCOMMIT())
                    ENDIF          
               endif
          End Transaction
     ENDIF
     WORK2->(DBSKIP())
ENDDO     

                      
//�����������������������������������������������������@�
//�Exclui o registro do WORK1 pois o saldo foi acertado�
//�����������������������������������������������������@�
DBSELECTAREA("WORK1")
IF RECLOCK("WORK1",.F.)
     DELETE
     WORK1->(MSUNLOCK())
     WORK1->(DBCOMMIT())                                                        
ENDIF                                                                          

//�����������������������������������������4�
//�Fecha a Janela dos Lotes e Fecha o Work2�
//�����������������������������������������4�

WORK1->(DBGOTOP())

nTotal--

oMark:oBrowse:Refresh()

oDlgLotes:End() 

IF SELECT("WORK2") <> 0
     WORK2->(DBCLOSEAREA())
ENDIF                           

msgInfo("Saldos Atualizados com �xito!","Ok!")

Return .T.                 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �CriaMovD5 �Autor �Renato S. Parreira � Data � 01/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria Movimentos de Acerto no SD5                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaMovD5(nTipo)

Local lRetorno := .T.                   
Local nNumSeq := 0 
Local cFilSD5 := xFilial("SD5")

//��������������������������������Ŀ
//�Busca o ultimo Sequencial do SD5�
//����������������������������������
SD5->(DBGOBOTTOM())
nNumSeq := SD5->D5_NUMSEQ           

//���������������������������������������������Ŀ
//�Grava o Movimento no SD5 de acordo com o lote�
//�����������������������������������������������
if RecLock("SD5",.T.)
     SD5->D5_FILIAL := cFilSD5
     SD5->D5_PRODUTO := SB8->B8_PRODUTO
     SD5->D5_LOCAL   := SB8->B8_LOCAL
     SD5->D5_DOC     := "DFB2B8"
     SD5->D5_DATA    := DDATABASE
     SD5->D5_NUMSEQ := nNumSeq
     SD5->D5_NUMLOTE := SB8->B8_NUMLOTE
     SD5->D5_LOTECTL := SB8->B8_LOTECTL
     SD5->D5_DTVALID := SB8->B8_DTVALID
     SD5->D5_POTENCI := SB8->B8_POTENCI                                                           
     //�����������������������������������������������������������������������������abOr4T@4T@�
     //�Caso Tipo = 1, Movimento de Devolu��o. Caso Tipo = 2 movimento de Requisi��o�
     //�����������������������������������������������������������������������������abOr<��<���
     if ntipo == 1
          SD5->D5_QUANT   := WORK2->SALDO - SB8->B8_SALDO
          SD5->D5_ORIGLAN := cMovDev
     elseif nTipo == 2                                
          SD5->D5_QUANT   := SB8->B8_SALDO - WORK2->SALDO
          SD5->D5_ORIGLAN := cMovReq
     endif            
     SD5->(MSUNLOCK())
     SD5->(DBCOMMIT())
else
     lRetorno := .F.
endif               
Return(lRetorno) 
