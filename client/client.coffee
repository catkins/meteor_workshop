Meteor.startup ->
  Session.set 'new_cussword', ''

Template.navigation.project_title = ->
  'Meteor workshop'

Template.content.cusswords = ->
  Swearwords.find()
  

Template.content.total_cusswords_message = ->
  count = Swearwords.find().count()
  
  if count > 1
    "My favourite #{count} cusswords"
  else
    if count == 1 then 'My favourite cussword' else 'My favourite cusswords'

window.word_exists = (word) ->
  Swearwords.findOne(word: word)?

add_event = ->
  new_word = Session.get 'new_cussword'
  unless new_word.length == 0 or word_exists(new_word)
    Swearwords.insert
      word: new_word
      up_votes: 0
      down_votes: 0
    Session.set 'new_cussword', ''

Template.content.events
  "click .remove": ->
    Swearwords.remove(this._id)
  
  "click .upvote": ->
    Swearwords.update(this._id, {$inc: {up_votes: 1}})

  "click .downvote": ->
    Swearwords.update(this._id, {$inc: {down_votes: 1}})

  'click input[type="submit"]': add_event

  'keyup input[name=word]': (event) ->
    Session.set 'new_cussword', $('#new_cussword').val();
    if event.keyCode == 13
      add_event()


Template.content.new_cussword = ->
  Session.get 'new_cussword'