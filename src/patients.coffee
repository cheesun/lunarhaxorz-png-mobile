(($) ->

  searcher = {
    bind: (inputId, buttonId) ->
      @input = $(id)
      @button = $(button)
      @button.click( () =>
        @search(@input.value)
      )
  }

  buildTable = () ->
    template = Handlebars.compile($("#patient-template").html())
    $$.Patient.getAll((results) ->
      for i in [0...results.rows.length]
        value = results.rows.item(i)
        $('#patients-table tbody').append(template({ id: value.id, name: value.name}))
    )
    $('#patients-table').sieve()

  buildTable()

) jQuery
