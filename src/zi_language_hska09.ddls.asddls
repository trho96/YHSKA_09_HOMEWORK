@AbapCatalog.sqlViewName: 'ZVI_LANG_HSKA09'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data model for languages'
define root view ZI_LANGUAGE_HSKA09
  as select from yhska09_language as ranking
  /* Associations */
    association [0..1] to yhska09_todo  as _Todo on $projection.language_id = _Todo.language_id
    association [0..1] to yhska09_types  as _Types on $projection.language_id = _Types.language_id
{
      //ranking
      key listing_id,
      language_id,
      @EndUserText.label: 'Programming Language Name'
      name,
      popularity,
      @EndUserText.label: 'Trend'
      trend,
      @EndUserText.label: 'Region'
      region,
      
      @EndUserText.label: 'Todo'
      _Todo.todo as Todo,
      _Types.rating as Rating
  
}
