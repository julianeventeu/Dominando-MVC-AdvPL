#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC05
Exemplo de setOptional, setUniqueLine e FWLoadModel

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC05()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC05' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC05' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC05' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC05' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC05' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC05' OPERATION 9 ACCESS 0
ADD OPTION aRotina TITLE 'Alt. MVC09' ACTION 'VIEWDEF.MVC09' OPERATION 4 ACCESS 0

Return aRotina

Static Function ModelDef() 
Local oModel := FWLoadModel("MVC04")

    oModel:getModel("DETAILZB6"):SetUniqueLine({"ZB6_RA"})

    oModel:getModel("DETAILZB7"):SetUniqueLine({"ZB7_CODDIS","ZB7_BIM"})
    oModel:getModel("DETAILZB7"):SetOptional(.T.)
    
Return oModel

Static Function ViewDef() 
Local oModel := ModelDef() 
Local oView 
Local oStrZB5:= FWFormStruct(2, 'ZB5')   
Local oStrZB6:= FWFormStruct(2, 'ZB6')
Local oStruZB7:= FWFormStruct(2, 'ZB7')
    
    oStrZB6:RemoveField('ZB6_CODTUR')

    oStruZB7:RemoveField('ZB7_CODTUR')
    oStruZB7:RemoveField('ZB7_RA')

	oView := FWFormView():New()  
	oView:SetModel(oModel)    

	oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )  
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')  
	oView:AddGrid('FORM_NOTA' , oStruZB7,'DETAILZB7')     
		
	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 20)  
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 40)  
	oView:CreateHorizontalBox( 'BOX_FORM_NOTA', 40)   
		
 	oView:SetOwnerView('FORM_NOTA','BOX_FORM_NOTA')  
 	oView:SetOwnerView('FORM_ALUNOS','BOX_FORM_ALUNOS')  
 	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA') 	
	
Return oView 
 