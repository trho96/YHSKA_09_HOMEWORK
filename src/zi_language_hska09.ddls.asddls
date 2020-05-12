@AbapCatalog.sqlViewName: 'ZVI_LANG_HSKA09'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data model for languages'
define root view ZI_LANGUAGE_HSKA09
  as select from yhska09_language as ranking
  /* Associations */
    association [0..*] to yhska09_todo  as _Todo on $projection.name = _Todo.name
{
      //ranking
  key language_id,
      @EndUserText.label: 'Programming Language Name'
      name,
      @EndUserText.label: 'Rank'
      rank,
      popularity,
      @EndUserText.label: 'Trend'
      trend,
      @EndUserText.label: 'Region'
      region,
      cuky_field,
      rating,
      
      @EndUserText.label: 'Todo'
      _Todo.todo as Todo
}
