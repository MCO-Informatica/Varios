#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"


User Function Novo22

_cConta := "112001"

// +-----------------------------------------------------+
// | Verifica se já existe Conta Contábil para o Cliente |
// +-----------------------------------------------------+

DbSelectArea("SA1")
DbSetOrder(1)  
DbGotop()


While !eof()                                 

    
    _cCODCLI := SA1->A1_COD

	DbSelectArea("CT1")
	DbSetOrder(1)  

	If DbSeek(xFilial("CT1") + _cConta + _cCODCLI,.f.)

       _cCTACTB := CT1->CT1_CONTA
    
       DbSelectArea("SA1")
   	   DbSetOrder(1)  
	
	   While !RecLock("SA1",.f.)
	   Enddo
	   SA1->A1_CONTA := _cCTACTB
	   MsUnLock()
	   
    Endif
    
	DbSelectArea("SA1")
	DbSetOrder(1)  
    
    DbSkip()               
    
    
Enddo

Return(.t.)
