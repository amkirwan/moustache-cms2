jQuery ->
  $(document).ready ->
    if $('form#new_site_asset').length
      $("div#uploader").pluploadQueue
        runtimes: "html5"
        url:  $('form#new_site_asset').attr('action')
        rename: true
        multipart: true
        multipart_params:
          authenticity_token: $('input[name=authenticity_token]').val()

    if $('form#new_theme_asset').length
      $("div#uploader").pluploadQueue
        runtimes: "html5"
        url:  $('form#new_theme_asset').attr('action')
        rename: true
        multipart: true
        multipart_params:
          authenticity_token: $('input[name=authenticity_token]').val()
