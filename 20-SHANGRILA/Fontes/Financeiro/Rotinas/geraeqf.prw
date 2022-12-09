#INCLUDE "rwmake.ch"  

/*/
+-------------------------------------------------------------------------------------------------------------------+
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Programa  NOVO2      Autor  AP6 IDE             Data   08/08/03   
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Descricao  Codigo gerado pelo AP6 IDE.                                
                                                                      
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Uso        AP6 IDE                                                    
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
/*/

User Function geraeqf

set decimals to 3

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
// Declaracao de Variaveis                                             
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Private cPerg       := PADR("EQUFAX",LEN(SX1->X1_GRUPO))
Private oGeraTxt
PgEquifax()

Private cString := "SE1"

dbSelectArea("SE1")
//dbSetOrder(1)
dbSetOrder(6)

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
// Montagem da tela de processamento.                                  
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geraзгo de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " SE1                                                           "

@ 75,100 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 75,130 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 75,160 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Funo     OKGERATXT Autor  AP5 IDE             Data   08/08/03   
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Descrio  Funcao chamada pelo botao OK na tela inicial de processamen
           to. Executa a geracao do arquivo texto.                    
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Uso        Programa principal                                         
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
/*/

Static Function OkGeraTxt

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
// Cria o arquivo texto                                                
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
// Aletrado en 19 - Jan - 2006
//
// Private cArqTxt := "c:\equifax.txt"
//
// A pedido da Sra Edna e Sr Edmilson para 
//
// Private cArqTxt := "/microsiga/protheus_data/equifax/equifax.txt"
//
// Por James J. Tanner - Akron/Microsiga
//

Private cArqTxt := Mv_Par01
//Private cArqTxt := "c:\equifax.txt"
//Private cArqTxt := "/microsiga/protheus_data/equifax/equifax.txt"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
// Inicializa a regua de processamento                                 
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

Processa({|| RunCont() },"Processando...")
Return

/*/
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Funo     RUNCONT   Autor  AP5 IDE             Data   08/08/03   
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Descrio  Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  
           monta a janela com a regua de processamento.               
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Uso        Programa principal                                         
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
/*/

Static Function RunCont

Local nTamLin, cLin, cCpo


//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
// Posicionamento do primeiro registro e loop principal. Pode-se criar 
// a logica da seguinte maneira: Posiciona-se na filial corrente e pro 
// cessa enquanto a filial do registro for a filial corrente. Por exem 
// plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    
//                                                                     
// dbSeek(xFilial())                                                   
// While !EOF() .And. xFilial() == A1_FILIAL                           
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
// O tratamento dos parametros deve ser feito dentro da logica do seu  
// programa.  Geralmente a chave principal e a filial (isto vale prin- 
// cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- 
// meiro registro pela filial + pela chave secundaria (codigo por exem 
// plo), e processa enquanto estes valores estiverem dentro dos parame 
// tros definidos. Suponha por exemplo o uso de dois parametros:       
// mv_par01 -> Indica o codigo inicial a processar                     
// mv_par02 -> Indica o codigo final a processar                       
//                                                                     
// dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio 
// While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  
//                                                                     
// Assim o processamento ocorrera enquanto o codigo do registro posicio
// nado for menor ou igual ao parametro mv_par02, que indica o codigo  
// limite para o processamento. Caso existam outros parametros a serem 
// checados, isto deve ser feito dentro da estrutura de laпїЅ (WHILE):  
//                                                                     
// mv_par01 -> Indica o codigo inicial a processar                     
// mv_par02 -> Indica o codigo final a processar                       
// mv_par03 -> Considera qual estado?                                  
//                                                                     
// dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio 
// While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  
//                                                                     
//     If A1_EST <> mv_par03                                           
//         dbSkip()                                                    
//         Loop                                                        
//     Endif                                                           
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

dbSelectArea(cString)                                                    
//dbGoTop() 
//dbSeek(xFilial()+dtos(mv_par01),.T.) // Posiciona no 1o.reg. satisfatorio 
//dbSeek(xFilial()+dtos(ctod("01/01/2003")),.T.) // Posiciona no 1o.reg. satisfatorio 
//dbSeek(xFilial()+dtos(ctod(Mv_Par02)),.T.) // Posiciona no 1o.reg. satisfatorio 
dbSeek(xFilial()+dtos(Mv_Par02),.T.) // Posiciona no 1o.reg. satisfatorio 


ProcRegua(RecCount()) // Numero de registros a processar
                                   


//While !EOF() .and. SE1->E1_EMISSAO >= ctod("01/01/2003") .and. SE1->E1_EMISSAO <= ddatabase 
While !EOF() .and. SE1->E1_EMISSAO >= Mv_Par02 .and. SE1->E1_EMISSAO <= Mv_Par03 
     If  SE1->E1_PREFIXO <> "UNI"         
         dbSkip()                                                    
         Loop                                                        
     Endif 
//inclusao de novas regras em 28/02/04     
     If  SE1->E1_PREFIXO = "UNI" .and. SE1->E1_TIPO = "NCC"
         dbSkip()                                                    
         Loop                                                        
     Endif 
//fim alteracoes
     
     if PADR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_PESSOA"),1) = "F"
         dbSkip()                                                    
         Loop                                                        
     Endif 
 
	//set decimals 3
	set date american
		

    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    // Incrementa a regua                                                  
    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

    IncProc()

    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    // Lay-Out do arquivo Texto gerado:                                
    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    //Campo            Inicio  Tamanho                               
    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    // E1_FILIAL      01      02                                    
    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

    nTamLin := 2 
    
        nTamLin := 2
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
	eqf01	:= space(01)
	eqf02	:= space(14)
	eqf03	:= space(55)
	eqf04	:= space(55)
	eqf05	:= space(01)
	eqf06	:= space(70)
	eqf07	:= space(30)
	eqf08	:= space(02)
	eqf09	:= space(08)
	eqf10	:= space(04)
	eqf11	:= space(10)
	eqf12	:= space(04)
	eqf13	:= space(10)
	eqf14	:= space(50)
	dia15   := space(02)
	ano15   := space(04)
	eqf15	:= space(06)
	eqf16	:= space(12)
	eqf17	:= space(01)
	eqf18	:= space(04)
	eqf19	:= space(11)               
	aux20   = 0
	eqf20	:= space(02)
	eqf21	:= space(11)
	aux22   = 0
	eqf22	:= space(02)
	aux23   := space(08)
	dia23   := space(02)
	mes23   := space(02)
	ano23   := space(04)
	eqf23	:= space(08)
	aux24   := space(08)	
	dia24   := space(02)
	mes24   := space(02)
	ano24   := space(04)
	eqf24	:= space(08)
	aux25   := space(08)
	dia25   := space(02)
	mes25   := space(02)
	ano25   := space(04)
	eqf25	:= space(08)


    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    // Substitui nas respectivas posicioes na variavel cLin pelo conteudo  
    // dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     
    // string dentro de outra string.                                      
    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

    //cCpo := PADR(SE1->E1_FILIAL,02)

	Eqf01 := PADR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_PESSOA"),1)       
	Eqf02 := PADR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_CGC"),14)
	Eqf03 := PADR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_NOME"),55)
	Eqf04 := PADR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_NREDUZ"),55)
	Eqf05 := "C" 
	Eqf06 := PADR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_END"),70)
	Eqf07 := PADR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_MUN"),30)
	Eqf08 := PADR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_EST"),2)
	Eqf09 := PADR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_CEP"),8)
	Eqf10 := "    "
	Eqf11 := "          "
	Eqf12 := "    "
	Eqf13 := "          "
	Eqf14 := "                                                  "

	if MONTH(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_PRICOM")) < 10
		dia15 := "0"+PADR(MONTH(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_PRICOM")),1)
	else
		dia15 := PADR(MONTH(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_PRICOM")),2)
	endif

	ano15 := PADR(YEAR(Posicione("SA1",1,Xfilial("SA1")+SE1->E1_CLIENTE,"A1_PRICOM")),4)
	Eqf15 := dia15+ano15
	Eqf16 := PADR(SE1->E1_NUM+SE1->E1_PARCELA,12)
	Eqf17 := "B"
	Eqf18 := "R$  "
	Eqf19 := PADR(int(SE1->E1_VALOR),11)   
	aux20 := se1->e1_valor-int(se1->e1_valor)
   	if 	aux20 = 0
   		Eqf20 := "00"
   	else
   		aux20 :=aux20*1000 		
   	   	Eqf20 := PADR(alltrim(str(aux20)),2) 	
   	endif
	Eqf21 := PADR(int(SE1->E1_VALLIQ),11)                            
	

	aux22 := se1->e1_valliq-int(se1->e1_valliq)
   	if 	aux22 = 0
   		Eqf22 := "00"
   	else
   		aux22 :=aux22*1000 		
   	   	Eqf22 := PADR(alltrim(str(aux22)),2) 	
   	endif    
   	             
   	aux23 := dtos(SE1->E1_EMISSAO)
   	dia23 := substr(aux23,7,2)
   	mes23 := substr(aux23,5,2)
   	ano23 := substr(aux23,1,4)
   	Eqf23 := dia23+mes23+ano23
   	                          
   	aux24 := dtos(SE1->E1_VENCREA)
   	dia24 := substr(aux24,7,2)
   	mes24 := substr(aux24,5,2)
   	ano24 := substr(aux24,1,4)
   	Eqf24 := dia24+mes24+ano24

   	aux25 := dtos(SE1->E1_BAIXA)
   	dia25 := substr(aux25,7,2)
   	mes25 := substr(aux25,5,2)
   	ano25 := substr(aux25,1,4)
   	Eqf25 := dia25+mes25+ano25

//inclusao de novas regras em 28/02/04     
     If  eqf23 = eqf24 .and. eqf23 <> eqf25     
         eqf23 = "        "                                                    
     Endif 
//fim alteracoes
   	
   	 	
    cCpo := Eqf01+Eqf02+Eqf03+Eqf04+Eqf05+Eqf06+Eqf07+Eqf08+Eqf09+Eqf10+Eqf11+Eqf12+Eqf13+Eqf14+Eqf15+Eqf16+Eqf17+Eqf18+Eqf19+Eqf20+Eqf21+Eqf22+Eqf23+Eqf24+Eqf25                    
    
        
    cLin := Stuff(cLin,01,02,cCpo)

    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    // Gravacao no arquivo texto. Testa por erros durante a gravacao da    
    // linha montada.                                                      
    //пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif

    dbSkip()
EndDo

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
// O arquivo texto deve ser fechado, bem como o dialogo criado na fun- 
// cao anterior.                                                       
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

fClose(nHdl)
Close(oGeraTxt)

Return

Static Function PgEquifax()
//
sAlias := Alias()                      // Preparacao das Perguntas
aRegs  := {}
//
Aadd(aRegs,{cPerg,"01","Local de gravaзгo e nome do arquivo?","","","mv_ch1","C",80,0,0,"G","",;
    "Mv_Par01","","","","c:\equifax.txt","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data Inicial ?","","","mv_ch2","D",08,0,0,"G","",;
    "Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Data Final ?","","","mv_ch3","D",08,0,0,"G","",;
    "Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"04","Ate a Data Emissao ?","","","mv_ch4","D",08,0,0,"G","",;
//    "Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//
DbSelectArea("SX1")
DbSetOrder(1)
//
For i := 1 To Len(aRegs)               // Pesquisa e Gravacao Eventual das Perguntas
    //
    If !DbSeek(cPerg + aRegs[i, 2])
       //
       Reclock("SX1", .T.)
       For j := 1 To FCount()
           FieldPut(j, aRegs[i, j])
       Next
       MsUnlock()
       //
    Endif
    //
Next
//
DbSelectArea(sAlias)
//
Return (.T.)
