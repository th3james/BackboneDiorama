window.JST ||= {}

window.JST['post_index'] = _.template("""
  <h1>Post Index</h1>
  <%= view.addSubView(new Backbone.Views.PostRowView()) %>
""")
