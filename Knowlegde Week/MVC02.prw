#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC02
Exemplo de um modelo e view baseado em duas tabelas (paixfilho)

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC02()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC02' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC02' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC02' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC02' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC02' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC02' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef() 
Local oModel 
Local oStruZB5 := FWFormStruct(1,"ZB5") 
Local oStruZB6 := FWFormStruct(1,"ZB6")   

    oModel := MPFormModel():New("MD_TURMA_ALUNO")  
    oModel:SetDescription("Cadastro de Turma x Aluno")    
    oModel:addFields('MASTERZB5',,oStruZB5)
    oModel:addGrid('DETAILZB6','MASTERZB5',oStruZB6)
 
    oModel:getModel('MASTERZB5'):SetDescription('Dados da Turma')  
    oModel:getModel('DETAILZB6'):SetDescription('Dados do Aluno')  
    
    oModel:SetRelation("DETAILZB6", ;       
 					{{"ZB6_FILIAL",'xFilial("ZB6")'},;        
 						{"ZB6_CODTUR","ZB5_CODTUR"  }}, ;       
 						ZB6->(IndexKey(1)))

Return oModel 

Static Function ViewDef() 
Local oModel := ModelDef() 
Local oView 
Local oStrZB5:= FWFormStruct(2, 'ZB5')   
Local oStrZB6:= FWFormStruct(2, 'ZB6')

    oStrZB6:RemoveField('ZB6_CODTUR')

	oView := FWFormView():New()  
	oView:SetModel(oModel)    
	oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )  
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')  

	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 20)  
    oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 80)  
	 			
 	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA')  
 	oView:SetOwnerView('FORM_ALUNOS','BOX_FORM_ALUNOS')  	
		
Return oView 