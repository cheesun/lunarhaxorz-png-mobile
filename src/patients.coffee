(($) ->

  $('#add-patient').click((event) ->
    $$.Patient.create()
    buildTable()
  )

  buildTable = () ->
    template = Handlebars.compile($("#patient-template").html())
    $$.Patient.getAllWithName((results) ->
      console.log(results.rows)
      $('#patients-table tbody').empty()
      for i in [0...results.rows.length]
        value = results.rows.item(i)
        console.log(value)
        $('#patients-table tbody').append(template({ id: value.id, name: value.name}))
    )

  buildTable()
  $('#patients-table').sieve()
  console.log($$.Utils.queryParam('id'))

) jQuery
