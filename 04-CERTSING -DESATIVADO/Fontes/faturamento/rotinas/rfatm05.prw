#INCLUDE "rwmake.ch"
#INCLUDE "fileio.ch"
#define F_BLOCK 212

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFATM05  � Autor �Rodrigo Harmel      � Data �  07/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para importacao de arquivo texto de tabela de CEPs   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo para o cliente Certisign                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFATM05()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private _oDlg

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 400,420 DIALOG _oDlg TITLE OemToAnsi("Importacao de Tabela de CEPs - Vr 4.0")
@ 02,10 TO 090,200
@ 10,018 Say " Este programa ir� importar os registros de um arquivo texto     "
@ 18,018 Say " de CEPs, logradouros e municipios, atualizando a Tabela PA7.    "

@ 50,128 BMPBUTTON TYPE 01 ACTION Pergunt()
@ 50,158 BMPBUTTON TYPE 02 ACTION Close(_oDlg)

Activate Dialog _oDlg Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � Pergunt  � Autor �Rodrigo Harmel      � Data �  07/03/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Pergunt()

//���������������������������������������������������������������������Ŀ
//� Definicao de variaveis                                              �
//�����������������������������������������������������������������������
Private _oDlg1     
Private _cArqTxt            // armazena o path + o nome do arquivo

_cArqTxt := Space(100)

//���������������������������������������������������������������������Ŀ
//� Monta caixa de dialogo                                              �
//�����������������������������������������������������������������������
//���������������������������������������������������������������������Ŀ
//� Dados a serem informados para o processamento                       �
//| Caminho dos arquivos                                                |
//| Condicao de pagamento                                               |
//| Natureza financeira                                                 |
//| Banco                                                               |
//�����������������������������������������������������������������������
close(_oDlg)

@ 200,1 TO 415,535 DIALOG _oDlg1 TITLE OemToAnsi("Importacao de Tabela de CEPs")
@ 08,10 TO 085,260
@ 20,018 Say " Path Arq. "
@ 20,052 Get _cArqTxt  		Picture "@S80"
@ 20,212 Button "Procura" 	Size 35,10 Action Busca()

@ 45,178 BMPBUTTON TYPE 01 ACTION Importa(Trim(_cArqTxt))
@ 45,208 BMPBUTTON TYPE 02 ACTION Close(_oDlg1)

Activate Dialog _oDlg1 Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � Importa  � Autor �Rodrigo Harmel      � Data �  07/03/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Importa(_parm2)

Local _nHdl             // variavel que armazena o retorno da funcao fopen
Local _cEol             // definicao de final de linha + retorno de cursor
Local _nLin             // Contador do numero de linhas do arquivo texto
Local _cQryD            // Monta query para delecao dos registros
Local _xLinha           // Armazena a linha lida do arquivo
Local _nTamFile         // Descobre o tamnho do arquivo
Local _nBytes 		:= _nPos :=  0 		// tamanho do arquivo Txt 
Local _EndOfLine  := chr(13)+chr(10) 
Local lLimpaBase	:= .F. 

_nHdl := 0
_cEol := CHR(13)+CHR(10)

//���������������������������������������������������������������������Ŀ
//� Verifica se o arquivo existe                                        �
//�����������������������������������������������������������������������
If !(File(Trim(_parm2)))
   Aviso("Importacao de Tabelas de CEP's. O arquivo de nome "+Trim(_parm2)+;
	      " nao pode ser aberto! Verifique.",{"Ok"})
   fClose(_nHdl)
   Return
EndIf

//���������������������������������������������������������������������Ŀ
//� Se existe tenta abrir                                               �
//�����������������������������������������������������������������������
_nHdl := fOpen(Trim(_parm2), 2)

// _nHdl := fOpen(Trim(_parm2),68)			porque 68 ? 
//���������������������������������������������������������������������Ŀ
//� Verifica se o arquivo foi aberto corretamente                       �
//�����������������������������������������������������������������������
If _nHdl == -1
	Aviso("Importacao de tabela de CEPs. O arquivo de nome "+Trim(_parm2)+;
	      " nao pode ser aberto! Verifique.",{"Ok"})
   fClose(_nHdl)
   Return	
Endif

//���������������������������������������������������������������������Ŀ
//� Verifica o tamanho do arquivo                                       �
//�����������������������������������������������������������������������
_nBytes 	:= fSeek(_nHdl , 0, 2)
_nTamFile:= Int(_nBytes/F_BLOCK)

// _nTamFile := fSeek(_nHdl,0,FS_END)
// _nTamFile := Int(_nTamFile/117)
//���������������������������������������������������������������������Ŀ
//� Se arquivo foi aberto corretamente monta query para limpar o arquivo�
//�����������������������������������������������������������������������
If lLimpaBase
	_cQryD := ""
	_cQryD := "DELETE PA7010"

	DbSelectArea("PA7")
	TCSqlExec(_cQryD)
	MsgAlert(" Apagou o conteudo do PA7 - Tabela de Cep... Ira iniciar a importacao agora! ") 
Endif 	
//���������������������������������������������������������������������Ŀ
//� Posiciona no inicio do arquivo e le primeira linha                  �
//�����������������������������������������������������������������������

fSeek(_nHdl, 0, 0)
_xLinha := Space(F_BLOCK) 
_nLinha := F_BLOCK+Len(_EndOfLine)
// ProcRegua(_nTamFile) 
ProcRegua(100) 

For _nLin := 1 To _nTamFile

	 IncProc(" Importando Base de Cep... "+Str(_nLin, 8))  
	 // _xLinha := Space(F_Block)					apenas 1 vez 
    fRead(_nHdl,@_xLinha,_nLinha)
    _nPos := _nPos + _nLinha 
    If _nPos > _nBytes 
       Exit 
	 Endif        
    /* 
    If fRead(_nHdl,@_xLinha,F_BLOCK) <> F_BLOCK
       Aviso("Importacao da tabela de CEPs O Arquivo "+Trim(_parm2)+ ;
             " nao pode ser lido! Verifique.",{"Ok"})
       fClose(_nHdl)
       Return
    EndIf					*/ 

    cCodCep	:= SubStr(_xLinha,001,  8)		//   8 		001 a 008
    cEndere	:= SubStr(_xLinha,009,100)		// 100 		009 a 109
    cBairro	:= SubStr(_xLinha,109, 35)		//  35 		109 a 143 
    cCidade	:= SubStr(_xLinha,144, 35)		//  35		144 a 178 
    cEstado := SubStr(_xLinha,179,  2)		//   2		179 a 180 
    cPais   := SubStr(_xLinha,181, 20)		//  20 		181 a 200 
    cCodPais:= SubStr(_xLinha,201, 04)		//  05		201 a 205
    cCodEst := SubStr(_xLinha,206, 02)		//  02		206 a 207
    cCodMun := SubStr(_xLinha,208, 05)		//  05 		208 a 212 

    RecLock("PA7",.t.)
    PA7->PA7_CODCEP := cCodCep 
    PA7->PA7_LOGRA  := NoAcento(Upper(cEndere))
    PA7->PA7_BAIRRO := NoAcento(Upper(cBairro))
    PA7->PA7_MUNIC  := NoAcento(Upper(cCidade))
    PA7->PA7_ESTADO := Upper(cEstado)
    PA7->PA7_PAIS   := Upper(cPais) 
    PA7->PA7_CODPAI := cCodPais
    PA7->PA7_CODMUN := cCodMun	// cCodEst
    PA7->PA7_CODUF  := cCodEst 	// cCodMun
	 MsUnLock()
	 
Next _nLin

Close(_oDlg1)

Aviso("Importacao da tabela de CEPs",;
      "Importacao finalizada",;
      {"Ok"})
fClose(_nHdl)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BUSCA    � Autor �Rodrigo Harmel      � Data �  07/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para importacao de arquivo texto de tabela de CEPs   ���
���          �Busca arquivo texto no disco                                ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo para o cliente Certisign                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Busca()

_cArqTxt := cGetFile("Arquivo Texto  | *.TXT",;
                      OemToAnsi("Selecione o arquivo a ser importado"),;
                      0,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)

Return