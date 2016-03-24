$(document).on 'ready page:load', ->

  $('.small.add.game.modal')
    .modal({
      onApprove : ->
        return false
    })

  $('.small.add.proficiency.modal')
    .modal({
      onApprove : ->
        return false
    })

  $('#add_game_to_user').on 'click', ->
    $('.small.add.game.modal')
      .modal('show')

  $('.add_proficiency_to_user').on 'click', ->
    $('.small.add.proficiency.modal')
      .modal('show');

  $('.dropdown')
    .dropdown()

  $('.ui.sign.up.form')
    .form({
      on: 'change',
      fields: {
        user_username : {
          identifier: "user_username",
          rules: [
            {
              type    : 'empty',
              prompt  : 'Please enter a username'
            }
          ]
        },
        user_password : {
          identifier : "user_password",
          rules: [
            {
              type    : 'empty',
              prompt  : 'Please enter a password'
            },
            {
              type    : 'minLength[7]',
              prompt  : 'Password must be at least 7 characters long'
            }
          ]
        },
        user_password_confirmation : {
          identifier  : 'user_password_confirmation',
          rules: [
            {
              type    : 'match[user_password]',
              prompt  : 'The password fields don\'t match'
            }
          ]
        }
      }
    })

  $('.ui.add.game.form')
    .form({
      on: 'submit',
      fields: {
        dropdown: {
          identifier: 'game',
          rules: [
            {
              type    : 'empty',
              prompt  : 'Please select a game to add.'
            }
          ]
        }
      }
    })

  $('.ui.add.proficiency.form')
    .form({
      on: 'submit',
      fields: {
        dropdown: {
          identifier: 'proficiency',
          rules: [
            {
              type    : 'empty',
              prompt  : 'Please select a proficiency to add.'
            }
          ]
        }
      }
    })

  $('.message .close').on 'click', ->
    $(this).closest('.message').transition('fade')
