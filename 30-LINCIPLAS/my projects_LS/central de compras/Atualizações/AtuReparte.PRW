#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

/*
Programa para limpar o campo B2_SALPEDI e/ou campos de reparte da tabela SBZ
A pedido de Polini e Sandro. 
Cada um dos programas abaixo tem uma funcao especifica.
Ilidio Abreu - 13/07/2015	
*/

User Function ATU_SBZ
// Este programa altera os valores dos campos especificados no array "aProd".
// Usado nas tabelas SBZ para colocar valores nos campos BZ_EMIN e BZ_EMAX.
    
_aProd 		:= {}
CargaSBz()					// Esta funcao ira carrregar o seguinte conteudo: PRODUTO - QUANT. MINIMA - QUANTIDADE MAXIMA
_cFilial 	:= _aProd[1]	// ATENCAO !!! ---- colocar a Filial que sera afetada no primeiro item da matriz!
DbSelectArea("SBZ")
Dbsetorder(1)				// BZ_FILIAL + BZ_COD


For _i:= 2 to len(_aProd)

	_cProd := _aProd[_i,1]
    if ! SBZ->(dbseek(_cFilial+_cProd))
    	Loop
    endif
	

//  A linha abaixo e usada para testar se todos os elementos do vetor existem na SB2.
//  Usar Debug / Animacao rapida e acompnhar em Variaveis Privadas.
//_______________________________________________________
//	_aVetor[_i] := _aVetor[_i]+"...._OK !"


    Reclock("SBZ",.f.)
    SBZ->BZ_EMIN := _aProd[_i,2]
    SBZ->BZ_EMAX := _aProd[_i,3]
    MsUnlock()

Next


//____________________________________________________________________________

static function CargaSBz()
// Conteudo recebido via planilha.
// Tera o formato {Produto, Qtd. Maxima , Qtde. Minima}
// ATENCAO !
// O primeiro item da matriz e a Filial que sera afetada !


aadd(_aProd,"CL")
aadd(_aProd,{"1024993",12,24})
aadd(_aProd,{"1035769",12,24})
aadd(_aProd,{"1056701",12,24})
aadd(_aProd,{"1040693",12,24})
aadd(_aProd,{"1056702",6,12})
aadd(_aProd,{"105676",9,18})
aadd(_aProd,{"1044958",18,36})
aadd(_aProd,{"1056703",6,12})
aadd(_aProd,{"105679",3,6})
aadd(_aProd,{"1056704",6,12})
aadd(_aProd,{"105678",9,18})
aadd(_aProd,{"105675",6,12})
aadd(_aProd,{"1030429",3,6})
aadd(_aProd,{"1037102",2.5,5})
aadd(_aProd,{"105683",3,6})
aadd(_aProd,{"1022895",6,12})
aadd(_aProd,{"105689",6,12})
aadd(_aProd,{"1044676",3,6})
aadd(_aProd,{"105690",2,4})
aadd(_aProd,{"105691",1.5,3})
aadd(_aProd,{"105692",2,4})
aadd(_aProd,{"105694",6,12})
aadd(_aProd,{"105701",2,4})
aadd(_aProd,{"105702",1.5,3})
aadd(_aProd,{"105704",6,12})
aadd(_aProd,{"135582",3,6})
aadd(_aProd,{"148213",3,6})
aadd(_aProd,{"105687",6,12})
aadd(_aProd,{"105693",6,12})
aadd(_aProd,{"105695",12,24})
aadd(_aProd,{"105696",0,0})
aadd(_aProd,{"105697",0,0})
aadd(_aProd,{"105698",0,0})
aadd(_aProd,{"105699",0,0})
aadd(_aProd,{"1057000",0,0})
aadd(_aProd,{"211706",6,12})
aadd(_aProd,{"105256",0,0})






Return


//____________________________________________________________________________
static function cargaVet
              

Return

User Function ATU_SB2      
// Este programa zera o B2_SALPEDI baseado em um vetor e a variavel _cFilial.
// Ambos se econtram na funcao CARGAVET
// Usado para "algumas" planilhas do Polini.

_cFilial := "" // ATENCAO !!! ---- colocar a Filial que sera afetada !

_aVetor:= {}
cargaVet()
                                                                           	
DbSelectArea("SB2")
DbSetOrder(1)   

For _i:= 1 to len(_aVetor)  
	_cProd := _aVetor[_i]
    if ! SB2->(dbseek(_cFilial+_cProd))
    	Loop
    endif
	

//  A linha abaixo e usada para testar se todos os elementos do vetor existem na SB2.
//  Usar Debug / Animacao rapida e acompnhar em Variaveis Privadas.
//_______________________________________________________
//	_aVetor[_i] := _aVetor[_i]+"...._OK !"
//	_aVetor[_i] := _aVetor[_i]+"......."+str(SB2->B2_SALPEDI)

    Reclock("SB2",.f.)
    SB2->B2_SALPEDI := 0
    MsUnlock()
	_aVetor[_i] := _aVetor[_i]+"......."+str(SB2->B2_SALPEDI)
	
Next


//________________________________

Alert("Acabatus Est")

Return                                      

User function  ZeraSBZ(_cFil)
Local _cFil	

// Esta funcao zera os estoques maximo e minimo da tabela BZ da filial selecionada.  
// Zera APENAS os Livros nacionais - Grupo 0003

DbSelectArea("SB1")
DbSetOrder(1)   

DbSelectArea("SBZ")
DbSetOrder(1)   
SBZ->(DBSeek(_cFil))

WHILE ! SBZ->(EOF())

 	If SBZ->BZ_FILIAL == _cFil	// .or. SBZ->BZ_FILIAL == "EB" 
 		if SBZ->BZ_EMIN == 0 .and. SBZ->BZ_EMAX == 0
 			SBZ->(dbskip())
 			loop
 		endif
 		if SB1->(dbseek("  "+SBZ->BZ_COD)) .and. (SB1->B1_GRUPO == "0003") //.or. SB1->B1_GRUPO == "0007")
 		
			reclock("SBZ",.f.)
	  		SBZ->BZ_EMIN := 0				
			SBZ->BZ_EMAX := 0	
			MSUNLOCK() 
		endif
    endif
	SBZ->(dbSkip())	          
	if SBZ->BZ_FILIAL # _cFil
		Exit
	Endif
Enddo

Return                                                                        

//___________________________________________________________________________________


User function  VoltaSBZ(_cFil)
Local _cFil	
// Esta funcao usa o backup (anteriormente feito) das filiais envolvidas para restaurar os valores de BZ_EMAX e BZ_EMIN.
// Na linha abaixo, colocar o nome do arquivo de backup

dbUseArea(.T.,"TOPCONN","SBZDD", "DDD", .F. )
select DDD
dbgotop()

DbSelectArea("SB1")
DbSetOrder(1)   

DbSelectArea("SBZ")
DbSetOrder(1)   

_nFiz := 0 

WHILE ! DDD->(EOF())
	if ! SBZ->(DbSeek(DDD->BZ_FILIAL+DDD->BZ_COD)) // Procura item do backup na tabela SBZ
		Dbskip()
  		loop
	endif     
 	If SBZ->BZ_FILIAL == _cFil	// .or. SBZ->BZ_FILIAL == "EB"  // Considera apenas a filial selecionada
 		if SBZ->BZ_EMIN == 0 .and. SBZ->BZ_EMAX == 0
 			SBZ->(dbskip())
 			loop
 		endif        
 	Endif	
 	
 	if SB1->(dbseek("  "+SBZ->BZ_COD)) .and. (SB1->B1_GRUPO == "0004") // Apenas revistas nacionais - Gripo 0004
 		reclock("SBZ",.f.)
		SBZ->BZ_EMIN := DDD->BZ_EMIN
		SBZ->BZ_EMAX := DDD->BZ_EMAX
		MSUNLOCK() 
		_nFiz++
	endif
    
	SBZ->(dbSkip())	          
	if SBZ->BZ_FILIAL # _cFil
		Exit
	Endif
Enddo

Return                                                                        
