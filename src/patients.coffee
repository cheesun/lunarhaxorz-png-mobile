(($) ->

  $('#add-patient').click((event) ->
    $$.Patient.create()
  )

  buildTable = () ->
    template = Handlebars.compile($("#patient-template").html())
    $$.Patient.getAllWithName((results) ->
      console.log(results.rows)
      for i in [0...results.rows.length]
        value = results.rows.item(i)
        console.log(value)
        $('#patients-table tbody').append(template({ id: value.id, name: value.name}))
    )
    $('#patients-table').sieve()

  buildTable()

  console.log($$.Utils.queryParam('id'))

) jQuery
