#include 'protheus.ch'
#include 'parmtype.ch'

user function F580CHAV()
DbSelectArea("SE2");DbSetOrder(3)
return SE2->(IndexKey())